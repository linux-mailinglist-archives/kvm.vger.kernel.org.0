Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D37032CC35
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 06:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234385AbhCDF4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 00:56:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:42041 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234340AbhCDF4B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 00:56:01 -0500
IronPort-SDR: AG5dRs8UNcZzfl5aOJ/iCZoSMpfk+hljgv3TzRmJm6p5xenFm/3fqK2dYKDUoLV4MuMqsvyMxL
 Up8PvEF3YU3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="272348873"
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="272348873"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 21:55:21 -0800
IronPort-SDR: 6FHpe5O+jNJQVFDNGutnncU1Db3JUjleWRJo/4YbAdG67YPx7esPLmIY0klAYRwTtxulqgN7xB
 WFHWWs+C2eJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,221,1610438400"; 
   d="scan'208";a="407618112"
Received: from local-michael-cet-test.sh.intel.com ([10.239.159.166])
  by orsmga008.jf.intel.com with ESMTP; 03 Mar 2021 21:55:19 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v3 2/3] KVM: nVMX: Set X86_CR4_CET in cr4_fixed1_bits if CET IBT is enabled
Date:   Thu,  4 Mar 2021 14:07:39 +0800
Message-Id: <20210304060740.11339-3-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210304060740.11339-1-weijiang.yang@intel.com>
References: <20210304060740.11339-1-weijiang.yang@intel.com>
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

