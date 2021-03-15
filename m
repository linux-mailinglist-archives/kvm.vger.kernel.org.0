Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E87A233ABFA
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 08:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCOHGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 03:06:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:59702 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229964AbhCOHGa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 03:06:30 -0400
IronPort-SDR: 3Lx5/L3RQjLfnYZLbdmSQzo86d9+WYLZ6CvNb9mUGGHUtT+vLbyZb53f8QUrZXjBIZ6Plldm5m
 Ohuc2NZ4WYwA==
X-IronPort-AV: E=McAfee;i="6000,8403,9923"; a="176640944"
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="176640944"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2021 00:06:29 -0700
IronPort-SDR: FB7WoABHpzldz3vOQ17WZ0nzl4tlRppu2RV2EN6i2xsQal8vPHD0A5Xy6FhLU+MvgN5oUpFOep
 h7thfiaPFwaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,249,1610438400"; 
   d="scan'208";a="604749555"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2021 00:06:27 -0700
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v4 2/3] KVM: nVMX: Set X86_CR4_CET in cr4_fixed1_bits if CET IBT is enabled
Date:   Mon, 15 Mar 2021 15:18:40 +0800
Message-Id: <20210315071841.7045-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210315071841.7045-1-weijiang.yang@intel.com>
References: <20210315071841.7045-1-weijiang.yang@intel.com>
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

