Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C2A220336
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbgGOEG2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:06:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:16670 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgGOEGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:06:03 -0400
IronPort-SDR: ewqDVWYm/bKfgZAMVkHy/hNbO8+RCEHg0ojOO9qIl4huHBdAzbR2eHTg1QkAR/UgZjd0qTECN0
 hfVO8KKXhMFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129167484"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129167484"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:06:02 -0700
IronPort-SDR: SEOjMc0bIN3O1+ATeg3OlT4+KKnZ9ViTaGXOrsu4KzXFmbmdj6Zk8TwBs2jE8Z9XQ9xv6De86Y
 B8u4Vd2kpTZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485587024"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 14 Jul 2020 21:06:02 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Cross <dcross@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 5/7] KVM: nVMX: Ensure vmcs01 is the loaded VMCS when freeing nested state
Date:   Tue, 14 Jul 2020 21:05:55 -0700
Message-Id: <20200715040557.5889-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715040557.5889-1-sean.j.christopherson@intel.com>
References: <20200715040557.5889-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a WARN in free_nested() to ensure vmcs01 is loaded prior to freeing
vmcs02 and friends, and explicitly switch to vmcs01 if it's not.  KVM is
supposed to keep is_guest_mode() and loaded_vmcs==vmcs02 synchronized,
but bugs happen and freeing vmcs02 while it's in use will escalate a KVM
error to a use-after-free and potentially crash the kernel.

Do the WARN and switch even in the !vmxon case to help detect latent
bugs.  free_nested() is not a hot path, and the check is cheap.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e9b27c6478da3..5734bff1a5907 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -279,6 +279,9 @@ static void free_nested(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01))
+		vmx_switch_vmcs(vcpu, &vmx->vmcs01);
+
 	if (!vmx->nested.vmxon && !vmx->nested.smm.vmxon)
 		return;
 
-- 
2.26.0

