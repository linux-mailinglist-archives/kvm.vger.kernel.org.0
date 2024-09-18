Return-Path: <kvm+bounces-27088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6CF997BE9B
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 17:28:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D8C8B1C21929
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2024 15:28:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BD071C9DC4;
	Wed, 18 Sep 2024 15:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="l77kZWU+"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-52004.amazon.com (smtp-fw-52004.amazon.com [52.119.213.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80B21C9855
	for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 15:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726673305; cv=none; b=ZpXDO+u9xmsS1bvdceOS2OOPM7xMb8Z2Kq/U/KLtSQVMxAZBMCe8BY647JS3QJE56Ncdq3uS04Ydt4/+1Cp28PbWiXT15fN0xtlVcaGT8q8gZoAqdEjqnppSYp1UxN6Rw+5kdl878NI3b/fSzpxUKSXbfm8wlymqPsUqtL9uleM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726673305; c=relaxed/simple;
	bh=/fiwKLJNU+6tNWT6VQd7KBpnBT+w41Rr0g3Co8I4NZQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iFv4GtWkbgxeAFAEPlnh0uqunBP42r1Lc/SjkeHJdkp9HBM9pas2huT5b/4z9N3tB45ZjsTCdSAIecQWtXVOJrzVkr+fRXRYoVNrLpSqlmoS3YO+nJNCli7HSNbNhc1eO+CEs0WTCLCMq1Hz47i1lrhZE9RCrQneNMMphZ0HsiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=l77kZWU+; arc=none smtp.client-ip=52.119.213.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1726673304; x=1758209304;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=cBuhl0qXKMJntrBkdWcKjcLFuCE565FUUFhI9H/DaWM=;
  b=l77kZWU+2A9Zp6h1wtzMQco35vJ/sQEM/qF5gJgKY/9kXZvBy0HSqXvv
   htih3b6x0h4UZYn3NjSV2Fijbg8oRLAEwUBee6TFU99Dmlgv5Ox7cHzB0
   1apiZqrDKb55cOTuSZ6CNqiSDWsR5kHY99gqrZpqL+sBeRoGplhtLwEnn
   w=;
X-IronPort-AV: E=Sophos;i="6.10,239,1719878400"; 
   d="scan'208";a="232771200"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.2])
  by smtp-border-fw-52004.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 15:28:23 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:54299]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.16.194:2525] with esmtp (Farcaster)
 id 4bd0e212-e6c1-41ad-a1ff-6bfdfe5b07a3; Wed, 18 Sep 2024 15:28:22 +0000 (UTC)
X-Farcaster-Flow-ID: 4bd0e212-e6c1-41ad-a1ff-6bfdfe5b07a3
Received: from EX19D018EUA001.ant.amazon.com (10.252.50.145) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:20 +0000
Received: from EX19MTAUEB001.ant.amazon.com (10.252.135.35) by
 EX19D018EUA001.ant.amazon.com (10.252.50.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Wed, 18 Sep 2024 15:28:20 +0000
Received: from email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com
 (10.43.8.2) by mail-relay.amazon.com (10.252.135.35) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Wed, 18 Sep 2024 15:28:20 +0000
Received: from dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com (dev-dsk-lilitj-1a-5039c68b.eu-west-1.amazon.com [172.19.104.233])
	by email-imr-corp-prod-iad-all-1a-93a35fb4.us-east-1.amazon.com (Postfix) with ESMTPS id 6258C4063D;
	Wed, 18 Sep 2024 15:28:19 +0000 (UTC)
From: Lilit Janpoladyan <lilitj@amazon.com>
To: <kvm@vger.kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<james.morse@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<nh-open-source@amazon.com>, <lilitj@amazon.com>
Subject: [PATCH 8/8] KVM: arm64: make hardware manage dirty state after write faults
Date: Wed, 18 Sep 2024 15:28:07 +0000
Message-ID: <20240918152807.25135-9-lilitj@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240918152807.25135-1-lilitj@amazon.com>
References: <20240918152807.25135-1-lilitj@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

In case of hardware dirty logging, fault in pages with their dirty
state managed by hardware. This will allow further writes to the
faulted in pages to be logged by the page tracking device. The first
write will still be logged on write fault. To avoid faults on first
writes we need to set DBM bit when eagerly splitting huge pages (to be
added).

Add KVM_PTE_LEAF_ATTR_HI_S2_DBM for the hardware DBM flag and
KVM_PGTABLE_PROT_HWDBM as a software page protection flag.

Hardware dirty state management changes the way
KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W is interpreted. Pages whose dirty state
is managed by the hardware are always writable and
KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W bit denotes their dirty state.

Signed-off-by: Lilit Janpoladyan <lilitj@amazon.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  1 +
 arch/arm64/kvm/hyp/pgtable.c         | 23 ++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                 |  8 ++++++++
 3 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 19278dfe7978..d3b81d7e923b 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -210,6 +210,7 @@ enum kvm_pgtable_prot {
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
 	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
+	KVM_PGTABLE_PROT_HWDBM			= BIT(5),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d507931ab10c..c4d654e7189c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -46,6 +46,8 @@
 
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
+
 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
@@ -746,7 +748,13 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_R)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
-	if (prot & KVM_PGTABLE_PROT_W)
+	/*
+	 * If hardware dirty state management is enabled then S2AP_W is interpreted
+	 * as dirty state, don't set S2AP_W in this case
+	 */
+	if (prot & KVM_PGTABLE_PROT_HWDBM)
+		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+	else if (prot & KVM_PGTABLE_PROT_W)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
 	if (!kvm_lpa2_is_enabled())
@@ -768,7 +776,10 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte)
 
 	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R)
 		prot |= KVM_PGTABLE_PROT_R;
-	if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
+
+	if (pte & KVM_PTE_LEAF_ATTR_HI_S2_DBM)
+		prot |= KVM_PGTABLE_PROT_HWDBM | KVM_PGTABLE_PROT_W;
+	else if (pte & KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W)
 		prot |= KVM_PGTABLE_PROT_W;
 	if (!(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN))
 		prot |= KVM_PGTABLE_PROT_X;
@@ -1367,7 +1378,13 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_R)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R;
 
-	if (prot & KVM_PGTABLE_PROT_W)
+	/*
+	 * If hardware dirty state management is enabled then S2AP_W is interpreted
+	 * as dirty state, don't set S2AP_W in this case
+	 */
+	if (prot & KVM_PGTABLE_PROT_HWDBM)
+		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+	else if (prot & KVM_PGTABLE_PROT_W)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
 	if (prot & KVM_PGTABLE_PROT_X)
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index a509b63bd4dd..a5bcc7f11083 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1418,6 +1418,11 @@ static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_MTE_ALLOWED;
 }
 
+static bool is_hw_logging_enabled(struct kvm *kvm)
+{
+	return kvm->arch.page_tracking_ctx != NULL;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1658,6 +1663,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (writable)
 		prot |= KVM_PGTABLE_PROT_W;
 
+	if (is_hw_logging_enabled(kvm))
+		prot |= KVM_PGTABLE_PROT_HWDBM;
+
 	if (exec_fault)
 		prot |= KVM_PGTABLE_PROT_X;
 
-- 
2.40.1


