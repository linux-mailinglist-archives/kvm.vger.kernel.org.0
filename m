Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD2B2B4FA1
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388227AbgKPS2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:28:10 -0500
Received: from mga06.intel.com ([134.134.136.31]:20636 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388095AbgKPS2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:09 -0500
IronPort-SDR: 0uHw5TVTUp1VNyN+BwGMmMYtZ7bDaRWBqB43hlirwkWog4UIYjv2TG8jzbo2NRkKSVaKAHh7k2
 bNtve30jYbWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410050"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410050"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:08 -0800
IronPort-SDR: ix4YNSY74kgFgcbyDGWJufKKuGTn9MPfyqAqrt3TjWDCuvFF3FVUDjc7zYwsfO7gBh0SlllzVN
 qTl/9Pa2C78Q==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400528106"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:08 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 35/67] KVM: x86/mmu: Explicitly check for MMIO spte in fast page fault
Date:   Mon, 16 Nov 2020 10:26:20 -0800
Message-Id: <8d129c5e2ab4ca26eaf761a2fd46cb50cf6376ba.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Explicity check for an MMIO spte in the fast page fault flow.  TDX will
use a not-present entry for MMIO sptes, which can be mistaken for an
access-tracked spte since both have SPTE_SPECIAL_MASK set.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 76de8d48165d..c4d657b26066 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3090,7 +3090,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				break;
 
 		sp = sptep_to_sp(iterator.sptep);
-		if (!is_last_spte(spte, sp->role.level))
+		if (!is_last_spte(spte, sp->role.level) || is_mmio_spte(spte))
 			break;
 
 		/*
-- 
2.17.1

