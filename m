Return-Path: <kvm+bounces-1168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB597E551A
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 12:22:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86C7FB21057
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666BB15EAB;
	Wed,  8 Nov 2023 11:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="sNm8tk4b"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EA315E89;
	Wed,  8 Nov 2023 11:21:47 +0000 (UTC)
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A721BE1;
	Wed,  8 Nov 2023 03:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1699442507; x=1730978507;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iycFoTQhbiLFSko2vQExEp1NsC8B9ilkhIKK0YicW+o=;
  b=sNm8tk4bdiSv9RcK/p31fYA5P8oPP9zXu7plXO17n8vzt3AEhJxPRgaG
   HpxMQtnznovUjHqlU4klh8y3Yh5f0cMHfyTFUPpGHvsH5W41JUc8qY1Qf
   SsuE9Ar5H845RLHucxk3HM+TLuFPWUIMhBV/09vgIKnWKDEPWauz9kkEb
   k=;
X-IronPort-AV: E=Sophos;i="6.03,286,1694736000"; 
   d="scan'208";a="375131996"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2023 11:21:40 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
	by email-inbound-relay-iad-1e-m6i4x-529f0975.us-east-1.amazon.com (Postfix) with ESMTPS id BA00148E12;
	Wed,  8 Nov 2023 11:21:36 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.17.79:28792]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.4.34:2525] with esmtp (Farcaster)
 id cc98cadf-a052-4f23-b472-377eb7ac99f7; Wed, 8 Nov 2023 11:21:35 +0000 (UTC)
X-Farcaster-Flow-ID: cc98cadf-a052-4f23-b472-377eb7ac99f7
Received: from EX19D004EUC001.ant.amazon.com (10.252.51.190) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:21:34 +0000
Received: from dev-dsk-nsaenz-1b-189b39ae.eu-west-1.amazon.com (10.13.235.138)
 by EX19D004EUC001.ant.amazon.com (10.252.51.190) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Wed, 8 Nov 2023 11:21:29 +0000
From: Nicolas Saenz Julienne <nsaenz@amazon.com>
To: <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-hyperv@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<anelkz@amazon.com>, <graf@amazon.com>, <dwmw@amazon.co.uk>,
	<jgowans@amazon.com>, <corbert@lwn.net>, <kys@microsoft.com>,
	<haiyangz@microsoft.com>, <decui@microsoft.com>, <x86@kernel.org>,
	<linux-doc@vger.kernel.org>, Nicolas Saenz Julienne <nsaenz@amazon.com>
Subject: [RFC 15/33] KVM: x86/mmu: Introduce infrastructure to handle non-executable faults
Date: Wed, 8 Nov 2023 11:17:48 +0000
Message-ID: <20231108111806.92604-16-nsaenz@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20231108111806.92604-1-nsaenz@amazon.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.13.235.138]
X-ClientProxiedBy: EX19D043UWA003.ant.amazon.com (10.13.139.31) To
 EX19D004EUC001.ant.amazon.com (10.252.51.190)

The upcoming per-VTL memory protections support needs to fault in
non-executable memory. Introduce a new attribute in struct
kvm_page_fault, map_executable, to control whether the gfn range should
be mapped as executable.

No functional change intended.

Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
---
 arch/x86/kvm/mmu/mmu.c          | 6 +++++-
 arch/x86/kvm/mmu/mmu_internal.h | 2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 8 ++++++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2afef86863fb..4e02d506cc25 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3245,6 +3245,7 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	struct kvm_mmu_page *sp;
 	int ret;
 	gfn_t base_gfn = fault->gfn;
+	unsigned access = ACC_ALL;
 
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
@@ -3274,7 +3275,10 @@ static int direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (WARN_ON_ONCE(it.level != fault->goal_level))
 		return -EFAULT;
 
-	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, ACC_ALL,
+	if (!fault->map_executable)
+		access &= ~ACC_EXEC_MASK;
+
+	ret = mmu_set_spte(vcpu, fault->slot, it.sptep, access,
 			   base_gfn, fault->pfn, fault);
 	if (ret == RET_PF_SPURIOUS)
 		return ret;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index b66a7d47e0e4..bd62c4d5d5f1 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -239,6 +239,7 @@ struct kvm_page_fault {
 	kvm_pfn_t pfn;
 	hva_t hva;
 	bool map_writable;
+	bool map_executable;
 
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
@@ -298,6 +299,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
 		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.map_executable = true,
 	};
 	int r;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6cd4dd631a2f..46f3e72ab770 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -957,14 +957,18 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
 	u64 new_spte;
 	int ret = RET_PF_FIXED;
 	bool wrprot = false;
+	unsigned access = ACC_ALL;
 
 	if (WARN_ON_ONCE(sp->role.level != fault->goal_level))
 		return RET_PF_RETRY;
 
+	if (!fault->map_executable)
+		access &= ~ACC_EXEC_MASK;
+
 	if (unlikely(!fault->slot))
-		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
+		new_spte = make_mmio_spte(vcpu, iter->gfn, access);
 	else
-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
+		wrprot = make_spte(vcpu, sp, fault->slot, access, iter->gfn,
 					 fault->pfn, iter->old_spte, fault->prefetch, true,
 					 fault->map_writable, &new_spte);
 
-- 
2.40.1


