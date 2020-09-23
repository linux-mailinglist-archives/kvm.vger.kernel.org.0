Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2820275D91
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 18:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIWQgb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 12:36:31 -0400
Received: from mga17.intel.com ([192.55.52.151]:7062 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726342AbgIWQgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 12:36:31 -0400
IronPort-SDR: x4nAr6QDRA3ykt+5QQj+A9gKAz9ubDaQMJm1jJ43OKUdU0P9tz0/VcUh7RqUmwYtF1t/b09Lu2
 x1bisoY9EBTQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="140962212"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="140962212"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 09:36:31 -0700
IronPort-SDR: ecqydRGQzLrf0pek4bm8J0e2eNjVebB2Nz7vNgePUFERV/O3wVrO+q33DofTy1BZGNvul8nZho
 wUrLfWWZSIUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="454981822"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 09:36:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] KVM: VMX: Use precomputed MAXPHYADDR for RTIT base MSR check
Date:   Wed, 23 Sep 2020 09:36:27 -0700
Message-Id: <20200923163629.20168-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923163629.20168-1-sean.j.christopherson@intel.com>
References: <20200923163629.20168-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use cpuid_maxphyaddr() instead of cpuid_query_maxphyaddr() for the
RTIT base MSR check.  There is no reason to recompute MAXPHYADDR as the
precomputed version is synchronized with CPUID updates, and
MSR_IA32_RTIT_OUTPUT_BASE is not written between stuffing CPUID and
refreshing vcpu->arch.maxphyaddr.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6f9a0c6d5dc5..be82da055fc4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -147,7 +147,7 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 	RTIT_STATUS_BYTECNT))
 
 #define MSR_IA32_RTIT_OUTPUT_BASE_MASK \
-	(~((1UL << cpuid_query_maxphyaddr(vcpu)) - 1) | 0x7f)
+	(~((1UL << cpuid_maxphyaddr(vcpu)) - 1) | 0x7f)
 
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
-- 
2.28.0

