Return-Path: <kvm+bounces-49854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6E70ADEA5A
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 13:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3110C162F4B
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 11:38:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDBC1296160;
	Wed, 18 Jun 2025 11:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="kIkLXFCL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16AD2E2645
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 11:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750246577; cv=none; b=l1p9nVYkkhjtJG4K78bZzjJYJTQRlo0l0EHyWanq3mW8O5KaOAppGQq1GtcXaFFbw9PKoJUhxj51w7DzpSM3s45jTmalUOIHamQgv5ZRezJqxT/pWUGWfGYDdGFF+I+HNNCDcAsix7pRby6ETZPtBXNlolMfYQXf9hh1tSuCB1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750246577; c=relaxed/simple;
	bh=lA01uq6QDQodlRWmaVdLcLE/1/AUd0mQeIhxuBJzy3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIbXpOeqH9va+nKfcw8GjyZVi3zY3lUnZMmNN2dGy2OXZ5ZcXw6DddPrt4w7qCQUIMA7IS1YtJdKQPf++TvymyaMzcQjQekmKkuywq/TxRlDrOXmLKuQdiEYKWveMwLIzoa3aWpYL4/ovljXhOceLrXEE+eh8oXRhQr+hrztsOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=kIkLXFCL; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-236192f8770so5214005ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 04:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1750246575; x=1750851375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fsGDp/PENI7aB5HoDYrfk/XMREQKVS7VE/vtxv5oiE=;
        b=kIkLXFCLh/ikEB6j9/X+C5gSZD7KkoqSlYvNceKhpUIA6RjZdZ2cjWRVrTOCba+Yj5
         SG3oZz9C8Fhnzs06DTVL97Dizp3X+CNP5CUbPQaD8vXzSaOGZm6Smd80QnQd0Z+9E+lH
         UeC4AwjbfTRhdK87Iydwl2spzQahBYYSQ/X9pIEb6rzmvVr1riFi01QH0W4RjTOYj+dI
         wi+7lucLkZGfR6XP1sWU9rStpT+kZQFgAw0KZF1hDVLoyg2CeHLKAxLg/29Npct6Ee7Q
         dOSyw7wRelJ2tH1KWYeWCX8hhRmZ89xO+Xw3hOYcA7Ex0FSwpgJeF7NW1u6cJjNH5wQJ
         t0EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750246575; x=1750851375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4fsGDp/PENI7aB5HoDYrfk/XMREQKVS7VE/vtxv5oiE=;
        b=S1wGTb7aDFKZNlxRh4M+s9tFuPyZ6LehzQajKmUoo9vRxys6dNvi80UtlokKLhIT3T
         XshwjMCl2a3Orlgi7WD/35ZUghMlt+3pRQptCy6q+9W74dsGaFy2MJYshkpIXfDDLC9Z
         YXy83Yr62lsLIAwpLZG1fHEfQX5IU4S2mvjRJAos238ydXPCMXcm6Gez0f65l58ADeKi
         AwWpcOKmNwlUhJ6+HXO5ZCUjKOJwXlsFLd3QPnMq2cvvLStQWpP5idpc/44uYTCJtcez
         Io93EdzajIHiWQpI5GfhHao5k0EeKWvlmjaTIXMqGS3fwxuPssK6jvEKM6Oh7eYo/6FY
         D3tQ==
X-Forwarded-Encrypted: i=1; AJvYcCXey4y+y4krti2XjIQLUbsDLQmhNu8p1QBqf/t2Dp/oybzKiQXgzE4MzLUIc5rSYaPg0a4=@vger.kernel.org
X-Gm-Message-State: AOJu0YytGyCUakgGMmsT+sLCgaEwrzGJlV6yEydrOb4botdy2buCU8Va
	wTYzDEVQ53odXpQyPf+N6PaXyQI7rKr9MHBhvrPZoy6EEcoicIAvsXn02cSsOeSP/o4=
X-Gm-Gg: ASbGncsCd38v1wLv9X/tOsABEWgwmDr+g49R3W/qciXOQkyfqJuu5x7GHTW7B/8ZZk+
	twiAH9fV09Kr0hHqucuF634nUVkod/KZEoDgFNG+wKwWD2l6dDxrLILO7pngfnW7YD2uAquR4Tv
	zaDZX7p5W87/GLrXDevQKi+AoR9JXSbHF1yxoqVnZ65nN25R+qUoDwOFxmXt0VJ/6xUQhWNr98n
	iOOHBJCnH2c2YifcR7I980fyTJhGRHLe+W06okPVG1aY0NzoOER0AozsOh3vAhLsgVwrdgyVRh9
	SBuZvVQIoAO43zj721W0QMK7Ewgc58idz3Dhd+jZr6Wr5T4CPx8q92P5KzFaBOO8Ht4INkl/cb8
	1Vv5SIVnjkmpSQ7I9mw==
X-Google-Smtp-Source: AGHT+IGPdPYj0gZ7Vn94CMfnaQxwq36XrmsmDwGfdD+JAuyfQGtPOHOXGGbxG4KxhqzNEij1VvDbCA==
X-Received: by 2002:a17:902:ec89:b0:22e:457d:3989 with SMTP id d9443c01a7336-237c1d2a8b3mr37447295ad.0.1750246574778;
        Wed, 18 Jun 2025 04:36:14 -0700 (PDT)
Received: from localhost.localdomain ([122.171.23.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237c57c63efsm9112475ad.172.2025.06.18.04.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 04:36:14 -0700 (PDT)
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
	Anup Patel <apatel@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>
Subject: [PATCH v3 06/12] RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
Date: Wed, 18 Jun 2025 17:05:26 +0530
Message-ID: <20250618113532.471448-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250618113532.471448-1-apatel@ventanamicro.com>
References: <20250618113532.471448-1-apatel@ventanamicro.com>
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

Reviewed-by: Atish Patra <atishp@rivosinc.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_host.h | 2 ++
 arch/riscv/kvm/mmu.c              | 2 +-
 arch/riscv/kvm/tlb.c              | 8 ++++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index ff1f76d6f177..6162575e2177 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -43,6 +43,8 @@
 	KVM_ARCH_REQ_FLAGS(5, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_STEAL_UPDATE		KVM_ARCH_REQ(6)
 
+#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
+
 #define KVM_HEDELEG_DEFAULT		(BIT(EXC_INST_MISALIGNED) | \
 					 BIT(EXC_BREAKPOINT)      | \
 					 BIT(EXC_SYSCALL)         | \
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 29f1bd853a66..a5387927a1c1 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -344,7 +344,7 @@ static void gstage_wp_memory_region(struct kvm *kvm, int slot)
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


