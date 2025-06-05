Return-Path: <kvm+bounces-48480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7063ACE9F4
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 199B0189A42E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:17:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E7DC212FB0;
	Thu,  5 Jun 2025 06:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="iZdk4X4m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE33A1F4C94
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 06:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749104138; cv=none; b=Ly+N+oAjPMVZCqJuZPZDOn8zDhHzyfU/8YcYjPm50/AnMmpJiM3ISOR68iYLjDU7dGYAUwb6SBgr60cQxtz8k+XN6l+XU36DqffQK+Gl/JTrQPS08PvZBDscwup2aLk9QYrCEGt33swY5/NMEZZFgjhGR8fDPSJ7ZvRCsUAKiaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749104138; c=relaxed/simple;
	bh=vyBV2F4KyvtMk4LF2UAhi7qqpyH1rZyaYbpSJb6E0Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9fIPLT/HpRIFxHSSLFknwFIVhv/UmF4JChTDxIIS2vgiXAErY8cYpI8sHXXcqzG/BQB/R327FQ+H1MosDnXp7mk6Sp2I2knVA2N6srd7oTPKJ/E6TH0iW9ta6WWOJzyouQo7Gx+nFRiaChxIeYPtEqllg9Auv5dQsIuDFfxSMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=iZdk4X4m; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3114560d74aso665170a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 23:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749104136; x=1749708936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PBw4EHffUTV31O6B+TCgyeA+gw4sP4Qg6j7rVTIEdxU=;
        b=iZdk4X4m5u2KioQUq6G/a/rYk1gh/N94aLc1P44UURo44p1doVGMqCtfD6uII6sjfs
         3M1Xrls/bX0eudl4bnRwhM2KB8BvQxvwRRClXdvFKeZbP8GzV9xymMuxspxKX444Zcbr
         9/Lu945kVntppYO7Bortsn2X6wZjCXbe3mBZHTOgJFgaq/65z/teVA4YbTwOObM9SSX3
         +y6B7UoniFS2WB173CIP2jepTGaDFGghc+UfWx/msGlx1p96iDkMab1TxpygclD2jgMx
         ebmQ7A4Wkjh9c9AyTxbCZPLcZlkjQNye8wQppoyG19GsasRi5LQyFTPf0eXfVhG+OLq4
         NJfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749104136; x=1749708936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBw4EHffUTV31O6B+TCgyeA+gw4sP4Qg6j7rVTIEdxU=;
        b=vVgufoO4PgbV4GLssI6iAMW4g3MV9Wf6F4r0Q+aUc9MECffKabbdbymkCv9nVezcDG
         iehcnkw1cgCZa95qpQpsVvO4DlNF25Rol6hJwJMaQdaCgD1/UYFeu7yFixQ5MVjhx+Xy
         6qo2Q+D4iQJA2P5Ms5Hj+oZDTldWwr2BjoZomk0uizwwNq21Vm6zpsiatnTEMxMP2nCa
         pIJGxwyf+blZod1XLTPY5UCAwL5AXLkspy8PMS2S0UuA8fFFSjwjjVmmaGnUyCkFPza6
         EdnA4h5+VD3eYlXg9bI6A7zN8ROZ7jcYQwPBxEKLTvYZl6ox4rXF3bjNI+ORUIy+oFWW
         OD0g==
X-Forwarded-Encrypted: i=1; AJvYcCVyG0xlgzLntg1MQ/Lpzlb7ZKdUqmdlp0b7SxT6IH0bgMoBid1CdGlYQ2NGLSgt0EG3xkY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqnPsBgMCfSabgHhdNNjp8kvc+dbbRI0sgyqSIhXwNgBJjYZ/K
	ejQgWUI4FwM9gFpE4YeV3BIoLzFEqUvwupcn5KVrkBx1Uygwv6o7ar7xuFROhKYW/zA=
X-Gm-Gg: ASbGncu3652g6G7tVEGvigWHP5T+5PqUXLGbBboP2GA3INROXJjW3s1T+9bwUAZW3Xf
	p9ebF4+4gpgwog69pXRPiJpE2Z0M+cN51nEHJ/2fDrjD1AE4G3j2nuZfr1Mv2SL481CQNK+Xot+
	XBBRY0JSCQkd6G8FKZmltZPQ9HhUD01pGrDf3+ahvEoh1JTabl54J9sqTf5twR3Zl8UQ5/fq/u9
	MvPRDB952ntlW2Ebdd9QowJCq7jBnbvfUxyk1WGM5uKm1L6VDMFK/pf37SXv2bRpRJTQCKwR8Gi
	3pgMZWqW38N3Plq2LYL3w+lYIC5fxRik0AnqUi7a7tICx1MTQeX4JNa1yXOMH+P3k5gvUrIa1ij
	63k2+LAqpcPPyyWaadi0AmfQTaPY=
X-Google-Smtp-Source: AGHT+IFD6i36g3dYe1k+gDLGsx1D0hcp/ZxtNU3y3iDfAyRruAl8oD12KxZBz84WYVYtRaZXIXAJqw==
X-Received: by 2002:a17:90b:3ec7:b0:311:9c9a:58da with SMTP id 98e67ed59e1d1-3130cd12ba3mr8390187a91.8.1749104135972;
        Wed, 04 Jun 2025 23:15:35 -0700 (PDT)
Received: from localhost.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3132c0bedc7sm716026a91.49.2025.06.04.23.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 23:15:35 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Atish Patra <atish.patra@linux.dev>
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 08/13] RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
Date: Thu,  5 Jun 2025 11:44:53 +0530
Message-ID: <20250605061458.196003-9-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250605061458.196003-1-apatel@ventanamicro.com>
References: <20250605061458.196003-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kvm_arch_flush_remote_tlbs_range() expected by KVM core can be
easily implemented for RISC-V using kvm_riscv_hfence_gvma_vmid_gpa()
hence provide it.

Also with kvm_arch_flush_remote_tlbs_range() available for RISC-V, the
mmu_wp_memory_region() can happily use kvm_flush_remote_tlbs_memslot()
instead of kvm_flush_remote_tlbs().

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h | 2 ++
 arch/riscv/kvm/mmu.c              | 2 +-
 arch/riscv/kvm/tlb.c              | 8 ++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index afaf25f2c5ab..b9e241c46209 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -42,6 +42,8 @@
 	KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+
 #define KVM_HEDELEG_DEFAULT		(BIT(EXC_INST_MISALIGNED) | \
 					 BIT(EXC_BREAKPOINT)      | \
 					 BIT(EXC_SYSCALL)         | \
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index d4eb1999b794..834d855b0478 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -342,7 +342,7 @@ static void gstage_wp_memory_region(struct kvm *kvm, int slot)
 	spin_lock(&kvm->mmu_lock);
 	gstage_wp_range(kvm, start, end);
 	spin_unlock(&kvm->mmu_lock);
-	kvm_flush_remote_tlbs(kvm);
+	kvm_flush_remote_tlbs_memslot(kvm, memslot);
 }
 
 int kvm_riscv_gstage_ioremap(struct kvm *kvm, gpa_t gpa,
diff --git a/arch/riscv/kvm/tlb.c b/arch/riscv/kvm/tlb.c
index da98ca801d31..f46a27658c2e 100644
--- a/arch/riscv/kvm/tlb.c
+++ b/arch/riscv/kvm/tlb.c
@@ -403,3 +403,11 @@ void kvm_riscv_hfence_vvma_all(struct kvm *kvm,
 	make_xfence_request(kvm, hbase, hmask, KVM_REQ_HFENCE_VVMA_ALL,
 			    KVM_REQ_HFENCE_VVMA_ALL, NULL);
 }
+
+int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
+{
+	kvm_riscv_hfence_gvma_vmid_gpa(kvm, -1UL, 0,
+				       gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT,
+				       PAGE_SHIFT);
+	return 0;
+}
-- 
2.43.0


