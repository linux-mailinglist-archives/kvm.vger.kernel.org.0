Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F141E234CEC
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729823AbgGaVYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:24:00 -0400
Received: from mga14.intel.com ([192.55.52.115]:50224 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgGaVX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:27 -0400
IronPort-SDR: tZgs9q8IUzK8Ad1NG6weuFbnExjtjlVbyBHxdI/hpbNV2aYGGrJcBe5BlCHAzmC1RWuvNp7iqO
 qKDqrNw2SPqw==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075128"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075128"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:27 -0700
IronPort-SDR: XgiYUcAvmq0d0KmB7mBPZFVTJZBsdfcE9u47qGuK/O4qUyua/RAdqnnhdnPfjJbgAJA4QwNSaH
 nPhpyV9KSfUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191298"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 14:23:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 2/8] KVM: x86/mmu: Use bits 2:0 to check for present SPTEs
Date:   Fri, 31 Jul 2020 14:23:17 -0700
Message-Id: <20200731212323.21746-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use what are effectively EPT's RWX bits to detect present SPTEs instead
of simply looking for a non-zero value.  This will allow using a
non-zero initial value for SPTEs as well as using not-present SPTEs to
track metadata for zapped private SPTEs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 9 +++++++--
 arch/x86/kvm/mmu/paging_tmpl.h | 3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d737042fea55e..82f69a7456004 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -625,9 +625,14 @@ static int is_nx(struct kvm_vcpu *vcpu)
 	return vcpu->arch.efer & EFER_NX;
 }
 
-static int is_shadow_present_pte(u64 pte)
+static inline bool __is_shadow_present_pte(u64 pte)
 {
-	return (pte != 0) && !is_mmio_spte(pte);
+	return !!(pte & 0x7);
+}
+
+static bool is_shadow_present_pte(u64 pte)
+{
+	return __is_shadow_present_pte(pte) && !is_mmio_spte(pte);
 }
 
 static int is_large_pte(u64 pte)
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 0172a949f6a75..57813e92ea8e0 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1024,7 +1024,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 		gpa_t pte_gpa;
 		gfn_t gfn;
 
-		if (!sp->spt[i])
+		if (!__is_shadow_present_pte(sp->spt[i]) &&
+		    !is_mmio_spte(sp->spt[i]))
 			continue;
 
 		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
-- 
2.28.0

