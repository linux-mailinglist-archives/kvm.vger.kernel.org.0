Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 671D854DD71
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 10:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376404AbiFPItS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 04:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359794AbiFPIs5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 04:48:57 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035A65EDED;
        Thu, 16 Jun 2022 01:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655369271; x=1686905271;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ulzzAHI2dEL92o/KzFQRO8FgEw/C8l+obGu5qgBKRBU=;
  b=LaVn5YXpwgxFa42lbbjKSQ4XkGjxh21W01QUcMyUhR67jq4vC41/APw1
   X6mI2WZ3rmr3tIAKuVna+Bavinku6DXKX6trvyZ38DYBgk3POLIPNqKXU
   ucOy7rt5lSKHy3N8qCPcxIoJWS2rVIB3kGMgCSen2ZTb86z4URVtOjglx
   RV21S0losdGclc/xhD2LH+q3DtjdBZ7yRI63rQsDcJ/x3T8gkl7hxtnWN
   kDZMX7BxVfQPK3d6dY8URjNEfsjPDffoFC6igjWIQtQrKxRMrNJPcYI5g
   feSsDbIwfYAk6Ntp6gBpdfpAzCK+6tAD9rk/6jexnfpjK+u2pgrohMTAb
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="259664558"
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="259664558"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:41 -0700
X-IronPort-AV: E=Sophos;i="5.91,304,1647327600"; 
   d="scan'208";a="613083158"
Received: from embargo.jf.intel.com ([10.165.9.183])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 01:47:40 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rick.p.edgecombe@intel.com
Cc:     weijiang.yang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 11/19] KVM: x86: Add fault checks for CR4.CET
Date:   Thu, 16 Jun 2022 04:46:35 -0400
Message-Id: <20220616084643.19564-12-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220616084643.19564-1-weijiang.yang@intel.com>
References: <20220616084643.19564-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Message-Id: <20210203113421.5759-7-weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 6 ++++++
 arch/x86/kvm/x86.h | 3 +++
 2 files changed, 9 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 40749e47cda7..cce789f1246a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -952,6 +952,9 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	    (is_64_bit_mode(vcpu) || kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE)))
 		return 1;
 
+	if (!(cr0 & X86_CR0_WP) && kvm_read_cr4_bits(vcpu, X86_CR4_CET))
+		return 1;
+
 	static_call(kvm_x86_set_cr0)(vcpu, cr0);
 
 	kvm_post_set_cr0(vcpu, old_cr0, cr0);
@@ -1168,6 +1171,9 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	}
 
+	if ((cr4 & X86_CR4_CET) && !(kvm_read_cr0(vcpu) & X86_CR0_WP))
+		return 1;
+
 	static_call(kvm_x86_set_cr4)(vcpu, cr4);
 
 	kvm_post_set_cr4(vcpu, old_cr4, cr4);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b9b1fff6d97a..01493b7ae150 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -477,6 +477,9 @@ bool kvm_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u32 type);
 		__reserved_bits |= X86_CR4_VMXE;        \
 	if (!__cpu_has(__c, X86_FEATURE_PCID))          \
 		__reserved_bits |= X86_CR4_PCIDE;       \
+	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&	\
+	    !__cpu_has(__c, X86_FEATURE_IBT))		\
+		__reserved_bits |= X86_CR4_CET;		\
 	__reserved_bits;                                \
 })
 
-- 
2.27.0

