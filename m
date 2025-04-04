Return-Path: <kvm+bounces-42701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDD7A7C495
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:08:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 79B4C1B6452C
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 20:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C1DC225A3B;
	Fri,  4 Apr 2025 19:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qe3qkxU4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF87224B0E
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795616; cv=none; b=EOOTMkvZTHxkYQUxZlD94drLfrQiI6pqPkWLDbEiR22nlLiQVWSwKlt5/mK49xiYWWGwSGYOsgZnWUheBz5fbLme9IzOAeNhJIIVCPJ9qdo9kuc1MrMKtJJAiNLadRvKIj2duVl4eqJR0ILncN5puRlyHFYxoQmtnqO2Rd4Em/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795616; c=relaxed/simple;
	bh=5nhNidq5kKCw8cPZzC/2EhhNf9DP5bsK6q2EHVi+AUQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uysOYWePuTfCA7rPqZ6n/CmpE5Nq+PFHPIccbZUuojtrWYQUVYgev8pUUWH5n09uOyAVy7lySR6WFTF68XVmA2ZhzzGHQH3Ku+tzUUC2XTmlaJGdgXcLl6nipxZzrLIz/kW/3aonqdBFaP8UT1HSYOXhb82PzosGEmnsdYNcmss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qe3qkxU4; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736c89461d1so3576554b3a.3
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795613; x=1744400413; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=7R6CjC9nxAlVYVI0vNC7khUHTwDmf+yRrkIu6OvCEfg=;
        b=qe3qkxU4whFzZfvuVAUo68SzHiPxCNb1tSZP0UHpTxHI53jqfQ2vmfuwFi1cp0vJRw
         yt212uHXGS7Nh6OGVE2GRQetvbv/uc8koH7TvAuF6xyS4gn+D6lIN7pJFj8HcWJni/GQ
         oslqDAgbbI79V4bkPsvcSgsy8cy+5xc39tWc80+TfhG5mi5f/G3scCRW173+l1TIhEYU
         G6YGPynDrPmZK/xiLJOUmJpIQF/av8FJW1V9SoS9wt1vT8Vo+DOowW9Ke53GX0fxho6F
         UCF0PlYHx3i0HdDjVlk3N+zC2wfvVYh97sP8dDtESWkpWeoEdNQ3BPjx2cV55SbgINqX
         jL9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795613; x=1744400413;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7R6CjC9nxAlVYVI0vNC7khUHTwDmf+yRrkIu6OvCEfg=;
        b=UiNg53tNvTXqnMr06ehDYz0A0S6Fzk2Y896bR7baFkl8L6xoP6D2BxIBSMqbtXvk6q
         wP/5cS1Cd/C808zuHKJOHXOFPNmLoEKD8S/ER8atjURuVqPo9PDeiw7VRFN8BXfaxz0I
         bpL61w2x7fl3sL33ChZs8rIgKWpS39hbz1USNCDqOTLlpoQWjnsrITgMJXm/6R063sUO
         HXAIBiqlNoor88N+bEtzz9f9y+mPVTB4SDQQPJy3XkG8UcKLmUc6Re89bb+E0mgh/mTe
         27RNqGVvL8j4vlNjEed2HTlWdIrjm0cy5xfI8TNzUf8qZMmr8tl9NId3P3L8cPd6+08T
         Y0qQ==
X-Gm-Message-State: AOJu0YzO5fP/fs4WPUlUmpEHDhpqen7o9bOOVqBdY02yLCOvTCT1uJwz
	mEgRz9ps8mejEFFR5JdBxmr9Pijc7myBMVWqC0fqxdW/GHsbqlZHqcGncS6AuWIa9YmUM6MznR/
	ubA==
X-Google-Smtp-Source: AGHT+IE1EIppngaCdboWmAsyGLdJBGl6DmfjRI9oduZtmRDlzdb3XCSaEM1nhSyczDVhV3HThe+yTT0lId8=
X-Received: from pfblm21.prod.google.com ([2002:a05:6a00:3c95:b0:739:45ba:a49a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4606:b0:736:592e:795f
 with SMTP id d2e1a72fcca58-739e6ff6b02mr4668862b3a.9.1743795612853; Fri, 04
 Apr 2025 12:40:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:30 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-16-seanjc@google.com>
Subject: [PATCH 15/67] KVM: SVM: Drop vcpu_svm's pointless avic_backing_page field
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop vcpu_svm's avic_backing_page pointer and instead grab the physical
address of KVM's vAPIC page directly from the source.  Getting a physical
address from a kernel virtual address is not an expensive operation, and
getting the physical address from a struct page is *more* expensive for
CONFIG_SPARSEMEM=y kernels.  Regardless, none of the paths that consume
the address are hot paths, i.e. shaving cycles is not a priority.

Eliminating the "cache" means KVM doesn't have to worry about the cache
being invalid, which will simplify a future fix when dealing with vCPU IDs
that are too big.

WARN if KVM attempts to allocate a vCPU's AVIC backing page without an
in-kernel local APIC.  avic_init_vcpu() bails early if the APIC is not
in-kernel, and KVM disallows enabling an in-kernel APIC after vCPUs have
been created, i.e. it should be impossible to reach
avic_init_backing_page() without the vAPIC being allocated.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 6 ++----
 arch/x86/kvm/svm/svm.h  | 1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index a1f4a08d35f5..c8ba2ce4cfd8 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -245,7 +245,7 @@ int avic_vm_init(struct kvm *kvm)
 
 static phys_addr_t avic_get_backing_page_address(struct vcpu_svm *svm)
 {
-	return __sme_set(page_to_phys(svm->avic_backing_page));
+	return __sme_set(__pa(svm->vcpu.arch.apic->regs));
 }
 
 void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
@@ -290,7 +290,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	    (id > X2AVIC_MAX_PHYSICAL_ID))
 		return -EINVAL;
 
-	if (!vcpu->arch.apic->regs)
+	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
 		return -EINVAL;
 
 	if (kvm_apicv_activated(vcpu->kvm)) {
@@ -307,8 +307,6 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	svm->avic_backing_page = virt_to_page(vcpu->arch.apic->regs);
-
 	/* Setting AVIC backing page address in the phy APIC ID table */
 	entry = avic_get_physical_id_entry(vcpu, id);
 	if (!entry)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 294d5594c724..1cc4e145577c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -301,7 +301,6 @@ struct vcpu_svm {
 
 	u32 ldr_reg;
 	u32 dfr_reg;
-	struct page *avic_backing_page;
 	u64 *avic_physical_id_cache;
 
 	/*
-- 
2.49.0.504.g3bcea36a83-goog


