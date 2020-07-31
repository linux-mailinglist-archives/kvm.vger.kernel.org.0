Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00F0233D56
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731281AbgGaCmt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731278AbgGaCms (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:48 -0400
IronPort-SDR: a5BNh0o0I0OcNcvR3yKRkYycZMSCRq5c23WHLfumsBw2ycpu5dDnBATYrg1iey420BLwD/Fzzl
 6M4docLCflfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290122"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290122"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:47 -0700
IronPort-SDR: OLdfMKW+VL1m3BbWk3QCr2Nzhd1vJeqiJvllv6OwmZgJCJezvMG8lK56pnt86sW1ZDJw2OUJuH
 /WL7m+hpt5kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304806009"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:45 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 6/9] KVM:x86: Substitute kvm_update_cpuid_runtime() with kvm_{osxsave,pke}_update_cpuid() in enter_smm()
Date:   Fri, 31 Jul 2020 10:42:24 +0800
Message-Id: <1596163347-18574-7-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d269670..13a2915 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8162,6 +8162,8 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 = cr0;
 
 	kvm_x86_ops.set_cr4(vcpu, 0);
+	kvm_osxsave_update_cpuid(vcpu, false);
+	kvm_pke_update_cpuid(vcpu, false);
 
 	/* Undocumented: IDT limit is set to zero on entry to SMM.  */
 	dt.address = dt.size = 0;
@@ -8199,7 +8201,6 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 		kvm_x86_ops.set_efer(vcpu, 0);
 #endif
 
-	kvm_update_cpuid_runtime(vcpu);
 	kvm_mmu_reset_context(vcpu);
 }
 
-- 
1.8.3.1

