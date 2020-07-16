Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945B6221B06
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 05:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgGPDoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 23:44:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:54949 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbgGPDoL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 23:44:11 -0400
IronPort-SDR: pbNN2uINWfgaHKnRsAL7IUhDiRlECRX/p41XDtF/uj7zfl3420sNfC8/oFY7zrRMsZb5GnLfWt
 d+1IWDqkVJ7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="150699762"
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="150699762"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2020 20:44:10 -0700
IronPort-SDR: tvy9nyPPeitGruJNQhYxoKw9S2CoFzNA4pJ8ATrid6IesBtWQu4a5E3xnoMDrVLUYg/TQN9xLk
 xjsmWp8wL74A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,357,1589266800"; 
   d="scan'208";a="282314261"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga003.jf.intel.com with ESMTP; 15 Jul 2020 20:44:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: VMX: Use precomputed MAXPHYADDR for RTIT base MSR check
Date:   Wed, 15 Jul 2020 20:44:06 -0700
Message-Id: <20200716034408.6342-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200716034408.6342-1-sean.j.christopherson@intel.com>
References: <20200716034408.6342-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 1bb59ae5016dc..50b7e85d37352 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -146,7 +146,7 @@ module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
 	RTIT_STATUS_BYTECNT))
 
 #define MSR_IA32_RTIT_OUTPUT_BASE_MASK \
-	(~((1UL << cpuid_query_maxphyaddr(vcpu)) - 1) | 0x7f)
+	(~((1UL << cpuid_maxphyaddr(vcpu)) - 1) | 0x7f)
 
 /*
  * These 2 parameters are used to config the controls for Pause-Loop Exiting:
-- 
2.26.0

