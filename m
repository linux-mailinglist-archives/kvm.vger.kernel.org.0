Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0482A8BE6
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 02:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733107AbgKFBGY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 20:06:24 -0500
Received: from mga18.intel.com ([134.134.136.126]:38191 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730895AbgKFBGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 20:06:22 -0500
IronPort-SDR: DVkEKgvm2WiAWYdcx8h0+yBS4aafl2S+MVGA7qoWoAYuCBQpYoe+wS/O5e9BA2Im+yOg2abPIs
 0XUgF0KR5cIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="157264685"
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="157264685"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 17:06:22 -0800
IronPort-SDR: JTtHd9+0mqb8zk8b9juZcRAEKQ/ZnNgsViHuSkKWhjfgdrST5m0d9/Qm7dTSr2jcfGiXnnWboJ
 CZxv8jTVLuCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,454,1596524400"; 
   d="scan'208";a="471874488"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.156])
  by orsmga004.jf.intel.com with ESMTP; 05 Nov 2020 17:06:20 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        jmattson@google.com
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v14 05/13] KVM: x86: Add fault checks for CR4.CET
Date:   Fri,  6 Nov 2020 09:16:29 +0800
Message-Id: <20201106011637.14289-6-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201106011637.14289-1-weijiang.yang@intel.com>
References: <20201106011637.14289-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the fault checks for CR4.CET, which is the master control for all
CET features (SHSTK and IBT).  In addition to basic support checks, CET
can be enabled if and only if CR0.WP==1, i.e. setting CR4.CET=1 faults
if CR0.WP==0 and setting CR0.WP=0 fails if CR4.CET==1.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 arch/x86/kvm/x86.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0433015ee443..8c9d631d7842 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -847,6 +847,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_ops.set_cr0(vcpu, cr0);
 
 	if ((cr0 ^ old_cr0) & X86_CR0_PG) {
@@ -1008,6 +1011,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !(kvm_read_cr0(vcpu) & X86_CR0_WP))
+		return 1;
+
 	if (kvm_x86_ops.set_cr4(vcpu, cr4))
 		return 1;
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 74858c18978a..50386318a382 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -398,6 +398,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_UMIP;        \
 	if (!__cpu_has(__c, X86_FEATURE_VMX))           \
 		__reserved_bits |= X86_CR4_VMXE;        \
+	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&	\
+	    !__cpu_has(__c, X86_FEATURE_IBT))		\
+		__reserved_bits |= X86_CR4_CET;		\
 	__reserved_bits;                                \
 })
 
-- 
2.17.2

