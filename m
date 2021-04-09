Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76692359580
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 08:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhDIGcQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 02:32:16 -0400
Received: from mga12.intel.com ([192.55.52.136]:31999 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233296AbhDIGcO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 02:32:14 -0400
IronPort-SDR: xnXHvp1Ic058SqHGkk8U6QNSKOGxqHWeELTX8O7X9BiBh7vrGNHUnDEQVjmXVpfZ3H7K+c7mmK
 HHWxJBk8Sklg==
X-IronPort-AV: E=McAfee;i="6000,8403,9948"; a="173178634"
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="173178634"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2021 23:31:30 -0700
IronPort-SDR: Q3NuLBsoHudazurkjshqtrCYi1sOHkTa1zfeyLvC3rA+qO5ADsr91e06pTpOHilR8PCjzl1On7
 szEBkud+cbjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,208,1613462400"; 
   d="scan'208";a="380538739"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by orsmga003.jf.intel.com with ESMTP; 08 Apr 2021 23:31:28 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v5 2/3] KVM: nVMX: Set X86_CR4_CET in cr4_fixed1_bits if CET IBT is enabled
Date:   Fri,  9 Apr 2021 14:43:44 +0800
Message-Id: <20210409064345.31497-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210409064345.31497-1-weijiang.yang@intel.com>
References: <20210409064345.31497-1-weijiang.yang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET SHSTK and IBT are independently controlled by kernel, set X86_CR4_CET
bit in cr4_fixed1_bits if either of them is enabled so that nested guest
can enjoy the feature.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e78650bf8ae8..bd89b5a24c38 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7267,6 +7267,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
+	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
 
 #undef cr4_fixed1_update
 }
-- 
2.26.2

