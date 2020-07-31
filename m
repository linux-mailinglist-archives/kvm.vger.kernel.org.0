Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CDD233D54
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 04:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731271AbgGaCmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 22:42:43 -0400
Received: from mga12.intel.com ([192.55.52.136]:47518 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbgGaCmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 22:42:43 -0400
IronPort-SDR: EkM05VYRsr0OFSmkcA6Ws5mfPeW3fHV1cLY17HMgM8KKXjgvoRPJUSc8JIA9/1h94yGFSQEhQk
 X34qF+u1ygUQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="131290119"
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="131290119"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 19:42:42 -0700
IronPort-SDR: X37saEi0Id94VKA4p4k1pHbCfxs4Rf7lgHb9vuJFPtDaxQO9yfEi+WPjmargjNThiarZsrpQ3I
 +4OEJ191I8uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,416,1589266800"; 
   d="scan'208";a="304805985"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by orsmga002.jf.intel.com with ESMTP; 30 Jul 2020 19:42:40 -0700
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, xiaoyao.li@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Cc:     robert.hu@intel.com, Robert Hoo <robert.hu@linux.intel.com>
Subject: [RFC PATCH 4/9] KVM:x86: Substitute kvm_update_cpuid_runtime() with kvm_{osxsave,pke}_update_cpuid() in kvm_set_cr4()
Date:   Fri, 31 Jul 2020 10:42:22 +0800
Message-Id: <1596163347-18574-5-git-send-email-robert.hu@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
References: <1596163347-18574-1-git-send-email-robert.hu@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 263ba47..e31dba2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1006,8 +1006,10 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_mmu_reset_context(vcpu);
 
-	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-		kvm_update_cpuid_runtime(vcpu);
+	if ((cr4 ^ old_cr4) & X86_CR4_OSXSAVE)
+		kvm_osxsave_update_cpuid(vcpu, !!(cr4 & X86_CR4_OSXSAVE));
+	if ((cr4 ^ old_cr4) & X86_CR4_PKE)
+		kvm_pke_update_cpuid(vcpu, !!(cr4 & X86_CR4_PKE));
 
 	return 0;
 }
-- 
1.8.3.1

