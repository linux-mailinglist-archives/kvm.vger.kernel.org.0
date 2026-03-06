Return-Path: <kvm+bounces-73066-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MPLOMSfgqmn0XwEAu9opvQ
	(envelope-from <kvm+bounces-73066-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:09:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADFF22258C
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D7D930F4103
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABADD3AE71F;
	Fri,  6 Mar 2026 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bFzzqmgT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B4B3AE6E4
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805768; cv=none; b=Q6yG+39kWcIFjeMMve5WlKO2nr5G2hLjqQpU7GM43t/3UUcmncDrRJCCTBLNteblo/EefsBtset0sIV4jx+hfHpo/2WLODhJxM2A/8r2hINZG82K5uPZKv0NcGY2r4zVgYi7kf/YeiREytpOa9Zg7z3N3p+rRWQfC/DEVhdQyaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805768; c=relaxed/simple;
	bh=h1PHct1x/stm5rxYiib9C8v7vw/FQ3/w8rGWdwn8hBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A/JOrlAHJbNdIDZfDoXumdNWVmh01UU7Awr+7FC5Zmctglcld7BaXx4NaI8JgCLHigNlB6pE3nkHWyLYcM6Tg2fmNv/5qJeWwoRBvYBEeLOo/5i3lHTU6QNpEqwegsEJ9kyRfps6TsXoyaoOoxib2etTEVynBfXYItMPk6GtNj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bFzzqmgT; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-661420734b7so3068341a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805764; x=1773410564; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qBDvUPOUvZlIighyaRp+5oG5fBA2IhyoxKOHVs/vQh8=;
        b=bFzzqmgTc7nZhMZFKzcgGG/F6bn2U9vZHMPLAQ6xJ4naffUBk/wzN0QKiDIOvbyz7A
         YdmfGQb1ocHw2+7sEdCyN6vL5Yacpi49zRVZ/EDDORr1KD/DycMyVbvnzXDZDGnUa9t4
         uTZAYdAJTfKgcumTMtyV5O3Vk49INb8v/pSMTpc7JqdFkIRbTite25T5BLIptssutp/X
         TxMo3lX77T4X/82/Hj8jMf7rcnbzZldwmzJj3R8+qIlijJMBbO+rTPX6xnRfnaLDBggT
         EaUsPFHHWitrdPJlzq1HowBa+OzUXBUGuWEhfbbPdip42AT//eAlwS4ZT/+YKtkfwdj8
         gKVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805764; x=1773410564;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qBDvUPOUvZlIighyaRp+5oG5fBA2IhyoxKOHVs/vQh8=;
        b=vU6h2AKNIObYZEmefFXcde785UOgadResUIYNyjujCjd1DOcH/rP/l1NkM6PeIXedM
         XHP2F7K+dLcQHOU+lGaixJx4OoU9BOWsa9SCvz3JDD64W1/bLxKL75HhmL+dfm4k+agt
         mIYuJXyseElLjxqrI6P8eH25X4mkO8odXp8b57Cb7EZkAnvjEUcyK9W5KsLvyhvNHMGq
         bsC6cI5LWusyel+yFUxR6jUBQfQA8seq8Aq3cXCkmGUBhWF4s3yh5je3HQRfew7FqzkR
         eMpe6Qe0/5ehZEKLiL3TshUKAJHdR2pE60n8BzkgvWWqjohE1IFGNTaqi/Os6Ak46Fzw
         NHxQ==
X-Gm-Message-State: AOJu0YyCLz0oI1+Ilq1t8ww+mnBrPps8ZjzNQet2t26jwimqhIgXh0UT
	loSxX9RdVwI+bf423q8suwrX3vz1aXtq/fvrnx+23KXlp9YOcUJZdUM7V8aKnGdWdRqh6+kyX41
	Jj9NqwlBfJYVQhTb0oDkDX4H3mpivrxzEp9a7VjkoM0qYVclGKOBS3qG8hfwcC8Z9DGkIBzqGAo
	5NbxUOW0ldIpTgjP1hAuo2To4P8BQ=
X-Received: from edev7-n2.prod.google.com ([2002:a05:6402:a2c7:20b0:660:afb7:89d6])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1d4c:b0:658:e665:766c
 with SMTP id 4fb4d7f45d1cf-6619d46826dmr1250580a12.8.1772805763972; Fri, 06
 Mar 2026 06:02:43 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:27 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-9-tabba@google.com>
Subject: [PATCH v1 08/13] KVM: arm64: Remove redundant state variables from
 struct kvm_s2_fault
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5ADFF22258C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73066-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Remove redundant variables vma_shift and vfio_allow_any_uc from struct
kvm_s2_fault as they are easily derived or checked when needed.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 090a906d3a12..01f4f4bee155 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1721,10 +1721,8 @@ struct kvm_s2_fault {
 	bool mte_allowed;
 	bool is_vma_cacheable;
 	bool s2_force_noncacheable;
-	bool vfio_allow_any_uc;
 	unsigned long mmu_seq;
 	phys_addr_t ipa;
-	short vma_shift;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active;
@@ -1749,9 +1747,9 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 		return -EFAULT;
 	}
 
-	fault->vma_shift = kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot, fault->nested,
-						   &fault->force_pte, &fault->ipa);
-	fault->vma_pagesize = 1UL << fault->vma_shift;
+	fault->vma_pagesize = 1UL << kvm_s2_resolve_vma_size(vma, fault->hva, fault->memslot,
+							     fault->nested, &fault->force_pte,
+							     &fault->ipa);
 
 	/*
 	 * Both the canonical IPA and fault IPA must be aligned to the
@@ -1764,8 +1762,6 @@ static int kvm_s2_fault_get_vma_info(struct kvm_s2_fault *fault)
 	fault->gfn = fault->ipa >> PAGE_SHIFT;
 	fault->mte_allowed = kvm_vma_mte_allowed(vma);
 
-	fault->vfio_allow_any_uc = vma->vm_flags & VM_ALLOW_ANY_UNCACHED;
-
 	fault->vm_flags = vma->vm_flags;
 
 	fault->is_vma_cacheable = kvm_vma_is_cacheable(vma);
@@ -1796,7 +1792,7 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 				       fault->write_fault ? FOLL_WRITE : 0,
 				       &fault->writable, &fault->page);
 	if (fault->pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(fault->hva, fault->vma_shift);
+		kvm_send_hwpoison_signal(fault->hva, __ffs(fault->vma_pagesize));
 		return 0;
 	}
 	if (is_error_noslot_pfn(fault->pfn))
@@ -1874,7 +1870,7 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 		fault->prot |= KVM_PGTABLE_PROT_X;
 
 	if (fault->s2_force_noncacheable) {
-		if (fault->vfio_allow_any_uc)
+		if (fault->vm_flags & VM_ALLOW_ANY_UNCACHED)
 			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
 		else
 			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
@@ -1978,7 +1974,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		.logging_active = memslot_is_logging(memslot),
 		.force_pte = memslot_is_logging(memslot),
 		.s2_force_noncacheable = false,
-		.vfio_allow_any_uc = false,
 		.prot = KVM_PGTABLE_PROT_R,
 	};
 	struct kvm_s2_fault *fault = &fault_data;
-- 
2.53.0.473.g4a7958ca14-goog


