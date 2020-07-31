Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F35233D57
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731279AbgGaCmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:51 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731227AbgGaCmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:50 -0400
IronPort-SDR: RMjKFUQ2MJjAhftTemHpv7zN/AGYjqwjXMqP1RR8tJ63XkoCvNfrjtbhgYc1jG2Pt7+2HZ1axh
 hQmCtSN/CtnA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290127"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290127"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:50 -0700
IronPort-SDR: 5guzxLvNPYHVGVY3jTONzLFB7J2eS/vMkyXMow+VZyd128CCQ7YCaGj6iFmRG3wproyp7CH9W0
 UzEAbTkcPFoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304806017"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:48 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 7/9] KVM:x86: Substitute kvm_update_cpuid_runtime() with kvm_{osxsave,pke}_update_cpuid() in __set_sregs()
Date:   Fri, 31 Jul 2020 10:42:25 +0800
Message-Id: <1596163347-18574-8-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 13a2915..35cb3d9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9183,7 +9183,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 {
 	struct msr_data apic_base_msr;
 	int mmu_reset_needed = 0;
-	int cpuid_update_needed = 0;
+	ulong old_cr4 = 0;
 	int pending_vec, max_bits, idx;
 	struct desc_ptr dt;
 	int ret = -EINVAL;
@@ -9217,12 +9217,15 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 	kvm_x86_ops.set_cr0(vcpu, sregs->cr0);
 	vcpu->arch.cr0 = sregs->cr0;
 
-	mmu_reset_needed |= kvm_read_cr4(vcpu) != sregs->cr4;
-	cpuid_update_needed |= ((kvm_read_cr4(vcpu) ^ sregs->cr4) &
-				(X86_CR4_OSXSAVE | X86_CR4_PKE));
+	old_cr4 = kvm_read_cr4(vcpu);
+	mmu_reset_needed |= old_cr4 != sregs->cr4;
+
 	kvm_x86_ops.set_cr4(vcpu, sregs->cr4);
-	if (cpuid_update_needed)
-		kvm_update_cpuid_runtime(vcpu);
+
+	if ((old_cr4 ^ sregs->cr4) & X86_CR4_OSXSAVE)
+		kvm_osxsave_update_cpuid(vcpu, !!(sregs->cr4 & X86_CR4_OSXSAVE));
+	if ((old_cr4 ^ sregs->cr4) & X86_CR4_PKE)
+		kvm_pke_update_cpuid(vcpu, !!(sregs->cr4 & X86_CR4_PKE));
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
 	if (is_pae_paging(vcpu)) {
-- 
1.8.3.1

