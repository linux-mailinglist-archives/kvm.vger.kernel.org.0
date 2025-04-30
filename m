Return-Path: <kvm+bounces-44948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5908AA524A
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 18:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 478241C06FFC
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 16:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1F5269806;
	Wed, 30 Apr 2025 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oc86Me6R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349C7267733
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 16:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032234; cv=none; b=idDiG13ACRy7/Om/8rAaN69rJuTaxUXEvP5TmAdZYfnNSJdytUVELLdygRSZcfLNAQ6ys3m7UeVBob0bx1t+JN+QNN415hG7FzFppY7koLrH6oMLqGgECKwDPZ6nMJkT5E/3S8TuhJwX1QTg1eLJwghBnfxpaD3KeoDDF9jEKec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032234; c=relaxed/simple;
	bh=w12b4zaFkJCKoQvjJZ1cgL7kXZ9PuO6sSB6PGuoRTyo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hOKe0OcHimRp189ea4T2omd+XkzbRQwt0TQftjUkgEzajLiEJCRVMF16y53/rFR3DOWyu8fr3wn50nfm3oEaubGX/sfuu1hWSQqnWNbtHKHweAku6lL4NcCJRpI/HlfuMz5k/BFXUztDF+GhnNInnA8O8OvYJwV6ueXOCqo9gdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oc86Me6R; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43941ad86d4so32015e9.2
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 09:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746032232; x=1746637032; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=c2CirrXQLYDrGMQg5euGpNIkUrJdTmNtkCDhZrP+vQ0=;
        b=oc86Me6Rnd1aI2t2IL2E4sR/sWMcVgPZ/r19sFVQMbO6XAO4ZIwjiKc24NpgqDeZq/
         Ux6QmIs11M4blRa8IMvDcTHphUzGf+6UPvJJOl1E1CoX6NO5GbDPdMmBxJP0eKX4h+v5
         1wyqMStIbZDl+S0DrKgCHs5o8MF99hds0Kf57czVFxnRVK60Ne6LnOdjOnnkpctoGbEK
         iFUGZ1PQPV/7Gpsxmw4vXYjon3CgQNKWNcTgQL7WbGO9pizupdqez34R/kuSYaATXumb
         xvE3pZpKXCGm3h/6SMBnEceWfurIrWA4TDsNfZ4dxCtfZBEhnt0V/Arh/H9zR5uqwzWj
         oraQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032232; x=1746637032;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c2CirrXQLYDrGMQg5euGpNIkUrJdTmNtkCDhZrP+vQ0=;
        b=axG690PttFG50pYSsS9l62KoyaGoFZP1OoQDGYKJo0TB+9sWojI37XMk+Rjw7E4vOM
         8cW5XWwH0d94ShddsGE/dn/T2AKXYvxk2O46+S88L0t+u8vHWBfrk/oSwF4hlKxqP+bh
         IdrmPez5gJ9mVts76CwiNcapltgjd4lxKEZ+gROcEl/yG8kdqVPuJE0T4C0OrLVBBzTP
         oRGXBV5F42QYP3vBq/LZ9XRdZr4/1VuaGFEfm8zauKYrcFyqtVvpz5kp5VWbjn99Ym5w
         dpTbpN6qV48mszBzQMk2fzj2N7ZtoRu2cE+bNGd8IoMyyDLYJTaUtbeO9eR4jlqWChwT
         eR4w==
X-Gm-Message-State: AOJu0YzhknYo0P6tQjhl1Jfhq4FPMXAkQ+3yE5NbpyUEqG6I0fd/4kcd
	swPdN4ss/narD5MTXGMH5H1P7yf51gMxjZVyIxMDwzEZT4TnpdDjvQlkMyp9TScWzFhU/U35V9T
	Mm2nu1NZ1bzPvF/GITytGFjlCzo24r8MyV8Z0/opDx2fLFqP4AYdnbAbMujRlExwCEzUWiQKIwf
	OPHHSX1ZoyOSY1jJEXI+7FrLY=
X-Google-Smtp-Source: AGHT+IFZ0fZuH5KrBBFCujIwvjpx8VCuAOhwo8FodbLOeOqGwPZm7lxCTBaRHUDn4PpBrTjcI+tyvp+wdw==
X-Received: from wrd17.prod.google.com ([2002:a05:6000:4a11:b0:39a:bc58:83e4])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:420e:b0:391:22e2:cd21
 with SMTP id ffacd0b85a97d-3a08f7a3281mr3864622f8f.36.1746032231484; Wed, 30
 Apr 2025 09:57:11 -0700 (PDT)
Date: Wed, 30 Apr 2025 17:56:49 +0100
In-Reply-To: <20250430165655.605595-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.967.g6a0df3ecc3-goog
Message-ID: <20250430165655.605595-8-tabba@google.com>
Subject: [PATCH v8 07/13] KVM: Fix comments that refer to slots_lock
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Fix comments so that they refer to slots_lock instead of slots_locks
(remove trailing s).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 include/linux/kvm_host.h | 2 +-
 virt/kvm/kvm_main.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index cdcd7ac091b5..9419fb99f7c2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -859,7 +859,7 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
-	/* Protected by slots_locks (for writes) and RCU (for reads) */
+	/* Protected by slots_lock (for writes) and RCU (for reads) */
 	struct xarray mem_attr_array;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2468d50a9ed4..6289ea1685dd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -333,7 +333,7 @@ void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
 	 * All current use cases for flushing the TLBs for a specific memslot
 	 * are related to dirty logging, and many do the TLB flush out of
 	 * mmu_lock. The interaction between the various operations on memslot
-	 * must be serialized by slots_locks to ensure the TLB flush from one
+	 * must be serialized by slots_lock to ensure the TLB flush from one
 	 * operation is observed by any other operation on the same memslot.
 	 */
 	lockdep_assert_held(&kvm->slots_lock);
-- 
2.49.0.901.g37484f566f-goog


