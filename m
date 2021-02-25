Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C68E324904
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 03:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234375AbhBYC7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 21:59:14 -0500
Received: from mga17.intel.com ([192.55.52.151]:39413 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229890AbhBYC7N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 21:59:13 -0500
IronPort-SDR: cnVM5gMeFgQeoFJdlesiQYVnMw3atHDLZKCKAaWEmJxRZ3VdhQn5I88Lt8DZhmP5Ml7/NZAx2x
 ZI/LXstzIWbQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9905"; a="165256826"
X-IronPort-AV: E=Sophos;i="5.81,203,1610438400"; 
   d="scan'208";a="165256826"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2021 18:58:33 -0800
IronPort-SDR: nbXT/+alB64Yrz7rFyCIDbZg5FuJULDgOI0w8g2h1I7f91PufB54sX+eLH9zYdJpH8CwdbplmG
 /LYbJM0BXPuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,203,1610438400"; 
   d="scan'208";a="391903158"
Received: from unknown (HELO local-michael-cet-test.sh.intel.com) ([10.239.159.166])
  by fmsmga008.fm.intel.com with ESMTP; 24 Feb 2021 18:58:31 -0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH] KVM: nVMX: Set X86_CR4_CET in cr4_fixed1_bits if CET IBT is enabled
Date:   Thu, 25 Feb 2021 11:09:50 +0800
Message-Id: <20210225030951.17099-1-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CET SHSTK and IBT are independently controlled by kernel, set X86_CR4_CET
bit in cr4_fixed1_bits if either of them is enabled so that nested guest
can enjoy the feature.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5856c5b81084..e92134ee081c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7258,6 +7258,7 @@ static void nested_vmx_cr_fixed1_bits_update(struct kvm_vcpu *vcpu)
 	cr4_fixed1_update(X86_CR4_UMIP,       ecx, feature_bit(UMIP));
 	cr4_fixed1_update(X86_CR4_LA57,       ecx, feature_bit(LA57));
 	cr4_fixed1_update(X86_CR4_CET,	      ecx, feature_bit(SHSTK));
+	cr4_fixed1_update(X86_CR4_CET,	      edx, feature_bit(IBT));
 
 #undef cr4_fixed1_update
 }
-- 
2.26.2

