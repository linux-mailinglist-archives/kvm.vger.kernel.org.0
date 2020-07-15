Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4862322032D
	for <lists+kvm@lfdr.de>; Wed, 15 Jul 2020 06:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgGOEGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 00:06:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:16670 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbgGOEGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 00:06:03 -0400
IronPort-SDR: YVH6ViBrl/AJ3E3MxSKn7cpkxYK9Z9/dKVwm5P+kf0ZP6P9HTa3gMOXXb+3eOA9GUmQaL3H8HQ
 wXrDlLQ0h7hg==
X-IronPort-AV: E=McAfee;i="6000,8403,9682"; a="129167486"
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="129167486"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 21:06:03 -0700
IronPort-SDR: 14tQVUJqoTUwoWBKb9RejmYG0x2tdKbE7FGGXpkyFzfBq22hJdG7sHrwcc7yfz/u7JQkQmIDof
 y+UA/KObHVvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,353,1589266800"; 
   d="scan'208";a="485587029"
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
Subject: [PATCH 6/7] KVM: nVMX: Drop redundant VMCS switch and free_nested() call
Date:   Tue, 14 Jul 2020 21:05:56 -0700
Message-Id: <20200715040557.5889-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200715040557.5889-1-sean.j.christopherson@intel.com>
References: <20200715040557.5889-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the explicit switch to vmcs01 and the call to free_nested() in
nested_vmx_free_vcpu().  free_nested(), which is called unconditionally
by vmx_leave_nested(), ensures vmcs01 is loaded prior to freeing vmcs02
and friends.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5734bff1a5907..66ed449f0d59f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -326,8 +326,6 @@ void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
 	vmx_leave_nested(vcpu);
-	vmx_switch_vmcs(vcpu, &to_vmx(vcpu)->vmcs01);
-	free_nested(vcpu);
 	vcpu_put(vcpu);
 }
 
-- 
2.26.0

