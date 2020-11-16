Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F32B2B4FBB
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388382AbgKPScS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:32:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:20636 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388092AbgKPS2F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:05 -0500
IronPort-SDR: HGyHCLRlsR6rhvGFeeAmTMZEHZFDS3CGzP6E63U4g0vHlo/Z48S02Bv/AhZRgxyfRm0HwtiowQ
 FcZeZRw14xwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410034"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410034"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:04 -0800
IronPort-SDR: efEQDO8MHzFjirZlU/JQsPOVdBDIf2Lalk0TGZC8zFXHSz75h6ldUESOHHMrjB+dSYEEifotY3
 vsOwBahEB5yw==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528010"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:03 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 25/67] KVM: x86: Allow host-initiated WRMSR to set X2APIC regardless of CPUID
Date:   Mon, 16 Nov 2020 10:26:10 -0800
Message-Id: <66de675d14feb088d60051501523848784d94044.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Let userspace, or in the case of TDX, KVM itself, enable X2APIC even if
X2APIC is not reported as supported in the guest's CPU model.  KVM
generally does not force specific ordering between ioctls(), e.g. this
forces userspace to configure CPUID before MSRs.  And for TDX, vCPUs
will always run with X2APIC enabled, e.g. KVM will want/need to enable
X2APIC from time zero.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8d58141256c5..a1c57d1eb460 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -394,8 +394,11 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
 	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
-	u64 reserved_bits = ((~0ULL) << cpuid_maxphyaddr(vcpu)) | 0x2ff |
-		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
+	u64 reserved_bits = ((~0ULL) << cpuid_maxphyaddr(vcpu)) | 0x2ff;
+
+	if (!msr_info->host_initiated &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
+		reserved_bits |= X2APIC_ENABLE;
 
 	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
 		return 1;
-- 
2.17.1

