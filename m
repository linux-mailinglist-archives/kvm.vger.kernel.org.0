Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A383BA5A8
	for <lists+kvm@lfdr.de>; Sat,  3 Jul 2021 00:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbhGBWJO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 18:09:14 -0400
Received: from mga12.intel.com ([192.55.52.136]:50197 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhGBWH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 18:07:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10033"; a="188472739"
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="188472739"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:25 -0700
X-IronPort-AV: E=Sophos;i="5.83,320,1616482800"; 
   d="scan'208";a="642814777"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2021 15:05:24 -0700
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 32/69] KVM: x86: Allow host-initiated WRMSR to set X2APIC regardless of CPUID
Date:   Fri,  2 Jul 2021 15:04:38 -0700
Message-Id: <9b00cb86878e9986f47a0febce3c0d2872d91443.1625186503.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3407870b6f44..c231a88d5946 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -437,8 +437,11 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
 	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
-	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
-		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
+	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff;
+
+	if (!msr_info->host_initiated &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_X2APIC))
+		reserved_bits |= X2APIC_ENABLE;
 
 	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
 		return 1;
-- 
2.25.1

