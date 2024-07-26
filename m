Return-Path: <kvm+bounces-22378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B7B193DB6F
	for <lists+kvm@lfdr.de>; Sat, 27 Jul 2024 01:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD3FE281113
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 23:58:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E25170829;
	Fri, 26 Jul 2024 23:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EHGzxS0H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EF616DC0A
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 23:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722037990; cv=none; b=ICcUIVmJjLJL7ThxwQnW/XRTP/Ixrj5pCtNVZRTE1JidPUzOxPc28A4Sl89zlb345pO6liP65PG+BQM6zstddqQ23yoqkFxqZHg65XjAVn4+fcmQETWQdfnQtn8MYDzEQvdJoeX+NwaXO+VK52TsBuAsWt8kTqMWbw2+ZsxTkYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722037990; c=relaxed/simple;
	bh=wc/x3/oHz+A3HJ1377TECtP4A+SVRJ7qmCHuMbUKaP8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G+gs9D6NTjQU75x15NXfZ8x9oDo+wLVz3OKwD5BX48IKDkIbdsAeuat3OgKRQHyOPMxbHCG9jOFeiuv4fAaKJHGJ5Q5RFNq5uF+HQ+ufcAG8ckkmCgyl405221BOSkWZBiwtXELfFTn7rgdDtznFvo+QmrJqgXt3P6WOLPBAW/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EHGzxS0H; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-76522d1dca5so1517191a12.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 16:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722037988; x=1722642788; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XEii1g2QxUcfpOdmeEwY4J2sYQAHz7s0WQ4Z9lEf4mM=;
        b=EHGzxS0HrLGgrJbHtWk+Qhe4MRs8fAABfwYbZu2W5hpU8aguKrm9ZyDqWpyCBd7i7R
         MwiNoZNPeS1gmr+I4eFWzty2MTPNNoXv5Bp3Xq6ganSxPmWk8FyT098aszpoEG7Y/VmD
         /3rGLXKnwVrVTEjqLBwM5rXgq/lwdDC6TtROHWJTivELZ/5nFjFi+f+Cp9TX/KXzqhGs
         bWnvHI/t1/q3h08FgOp17SdHLdABnJQ+xYuXcktcU491qhA+45KQ2pjqW+FxlfxvzlhH
         Qt7TyvcytVEri0xmVigSxECP3AjXzuTY8x0wKjneRa1oAlDMsph95NQTBsjJ+65j5Ytu
         dlmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722037988; x=1722642788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XEii1g2QxUcfpOdmeEwY4J2sYQAHz7s0WQ4Z9lEf4mM=;
        b=IMz9qpqrc55WRFurWWsy4Diyv0ac+sq+fyZMZCMmpGzDahSlyye3Xaa/9fCS1/0CC4
         wCkTsFJOVGBwkZ6/nDQBMPAlHdSlREyd660AfQbnyVnh+ewza1Z7l8bZ5wCZdTjVQvlZ
         B0eC+ZvepYU5xAwF47hvJCsu7uBvO9gUYsFJySARN/jq6bzYhdEZGvng04U0N8RN68QL
         bPmwzPpdv7AwToCFaLPk9nrUbEC9gpsybgjUyxbdAaxWR75qxPgRyTO/yNnza86oemE9
         ih7aVhoAAzuX1xFNpoWtirjPQzkEqqr2jODNvy7ESdIArW3ZBgN5cSKVgFgJle0RnBIV
         Nf1Q==
X-Gm-Message-State: AOJu0YzZx91eg+RNyDkQUlQpRLbQlCNo1WP/IWJWTGQE2hSq5LF5eUhC
	pqi4ENfsfORU3eTG2VGHfi1jSDo+uGT9J85Y1TAWx6g6/JXYU3xBdR7RCeic81CPyFDPVS2B78q
	joA==
X-Google-Smtp-Source: AGHT+IHOguM9TV1Wqy8YwTb6CBUJl4Q4k/lDzAhV2epo/9u56TnU3ou5KRwZKpMCKdXGcBYB5FJy1Mcb3zg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6556:0:b0:710:cc3c:3916 with SMTP id
 41be03b00d2f7-7ac8e0b6796mr2159a12.3.1722037987987; Fri, 26 Jul 2024 16:53:07
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 26 Jul 2024 16:51:24 -0700
In-Reply-To: <20240726235234.228822-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240726235234.228822-16-seanjc@google.com>
Subject: [PATCH v12 15/84] KVM: x86/mmu: Drop kvm_page_fault.hva, i.e. don't
 track intermediate hva
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="UTF-8"

Remove kvm_page_fault.hva as it is never read, only written.  This will
allow removing the @hva param from __gfn_to_pfn_memslot().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 5 ++---
 arch/x86/kvm/mmu/mmu_internal.h | 2 --
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index eb9ad0283fd5..e0bfbf95646c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3248,7 +3248,6 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	fault->slot = NULL;
 	fault->pfn = KVM_PFN_NOSLOT;
 	fault->map_writable = false;
-	fault->hva = KVM_HVA_ERR_BAD;
 
 	/*
 	 * If MMIO caching is disabled, emulate immediately without
@@ -4333,7 +4332,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 
 	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, false, true,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  NULL);
 
 	/*
 	 * If resolving the page failed because I/O is needed to fault-in the
@@ -4362,7 +4361,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	 */
 	fault->pfn = __gfn_to_pfn_memslot(fault->slot, fault->gfn, true, true,
 					  fault->write, &fault->map_writable,
-					  &fault->hva);
+					  NULL);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..f67396c435df 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -238,7 +238,6 @@ struct kvm_page_fault {
 	/* Outputs of kvm_faultin_pfn.  */
 	unsigned long mmu_seq;
 	kvm_pfn_t pfn;
-	hva_t hva;
 	bool map_writable;
 
 	/*
@@ -310,7 +309,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.is_private = err & PFERR_PRIVATE_ACCESS,
 
 		.pfn = KVM_PFN_ERR_FAULT,
-		.hva = KVM_HVA_ERR_BAD,
 	};
 	int r;
 
-- 
2.46.0.rc1.232.g9752f9e123-goog


