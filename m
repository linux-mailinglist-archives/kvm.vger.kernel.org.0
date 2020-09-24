Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C101927798A
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 21:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIXTmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 15:42:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:31793 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXTmz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Sep 2020 15:42:55 -0400
IronPort-SDR: zLJCHE2dhFIe648NZH7wi5uvD7Ci/ZSZKiXFKBDDB0lz3Vz71W9Tsoqq8oRVQpWQt6bHtZ4cbY
 J177IJYOOQnw==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="149076387"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="149076387"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 12:42:52 -0700
IronPort-SDR: dsuICRaW7RQs8ixQFzR01Icla57G8r4Ce37vrZK30G2Ghw6iTDvDUFeX/G1xSzG9IMvlTeZKyn
 dEYtQEt/7ZOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="347953045"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Sep 2020 12:42:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] KVM: VMX: Use precomputed MAXPHYADDR for RTIT base MSR check
Date:   Thu, 24 Sep 2020 12:42:46 -0700
Message-Id: <20200924194250.19137-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200924194250.19137-1-sean.j.christopherson@intel.com>
References: <20200924194250.19137-1-sean.j.christopherson@intel.com>
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

