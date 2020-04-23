Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 340B01B5267
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgDWCZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:25:59 -0400
Received: from mga05.intel.com ([192.55.52.43]:43420 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgDWCZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:58 -0400
IronPort-SDR: wM19L4gr9oxiPfoATnG+pwzDYYhXm2MgaLMssCFyKiY2NDUtM788cs3FSZq+DJRdgLh3HKf14J
 uxN5g3GCLQow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:54 -0700
IronPort-SDR: PVnCEJYehreoWf0lBzr4dNWvVBTu0u3jmAHrc6AlP3H9rww3JzHGd3riVr/szbSOwSGPe2xgEt
 pHfBmuMwlx6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273947"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 19:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 06/13] KVM: nVMX: Report NMIs as allowed when in L2 and Exit-on-NMI is set
Date:   Wed, 22 Apr 2020 19:25:43 -0700
Message-Id: <20200423022550.15113-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Report NMIs as allowed when the vCPU is in L2 and L2 is being run with
Exit-on-NMI enabled, as NMIs are always unblocked from L1's perspective
in this case.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7dd42e7fef94..c7bb9d90d441 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4516,6 +4516,9 @@ static bool vmx_nmi_allowed(struct kvm_vcpu *vcpu)
 	if (to_vmx(vcpu)->nested.nested_run_pending)
 		return false;
 
+	if (is_guest_mode(vcpu) && nested_exit_on_nmi(vcpu))
+		return true;
+
 	if (!enable_vnmi &&
 	    to_vmx(vcpu)->loaded_vmcs->soft_vnmi_blocked)
 		return false;
-- 
2.26.0

