Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE2B30D888
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 12:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbhBCLXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 06:23:52 -0500
Received: from mga01.intel.com ([192.55.52.88]:28325 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234201AbhBCLXT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 06:23:19 -0500
IronPort-SDR: LagHsbAcctOd0qAvaiT2R+sWEkvl1YpqTipHkXu1TAXd3rh5K7JRFy/qMJRlEyGg1rEymn2YdC
 OwgJmIGJt8bQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="199981279"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="199981279"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 03:22:18 -0800
IronPort-SDR: e5CZMM4knZCciTR5y8wKXCNtfpAHUJtiotYTsnmNVKdxaY2Q2WFrfH7ndxlLRX7trFc2s2sM7q
 oGtnGvpnPuJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="480311141"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2021 03:22:16 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, jmattson@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     yu.c.zhang@linux.intel.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v15 06/14] KVM: x86: Add fault checks for CR4.CET
Date:   Wed,  3 Feb 2021 19:34:13 +0800
Message-Id: <20210203113421.5759-7-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210203113421.5759-1-weijiang.yang@intel.com>
References: <20210203113421.5759-1-weijiang.yang@intel.com>
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
index d9d3bae40a8c..6af240d87a33 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -868,6 +868,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
+		return 1;
+
 	kvm_x86_ops.set_cr0(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1034,6 +1037,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !(kvm_read_cr0(vcpu) & X86_CR0_WP))
+		return 1;
+
 	kvm_x86_ops.set_cr4(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index bdbd0b023ecc..fd8c46da2030 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -425,6 +425,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_UMIP;        \
 	if (!__cpu_has(__c, X86_FEATURE_VMX))           \
 		__reserved_bits |= X86_CR4_VMXE;        \
+	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&	\
+	    !__cpu_has(__c, X86_FEATURE_IBT))		\
+		__reserved_bits |= X86_CR4_CET;		\
 	__reserved_bits;                                \
 })
 
-- 
2.26.2

