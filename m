Return-Path: <kvm+bounces-49379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7134CAD8377
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 241E43A1657
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:59:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE8725E471;
	Fri, 13 Jun 2025 06:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="KkxSWW+S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581D525B676
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749797904; cv=none; b=MRiprNaRvOmrGpmi0Dsox0ESc5k2HqgtnKVYmBWqlcZ+OTJTlKimErLzDxMjsNWAaLKqskKcE8UWaGjZjmhTQGUmADquHQITD3fZQW8ROMDVC5SOCqsTjnFj4MAat2kMix+GH+ye7HJNJHimVrkHiHMarY/zPzwS16FZCFReRr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749797904; c=relaxed/simple;
	bh=rq4NA0UvWiBGdQQMC6kdlaKltEwLwO4T2L6EMR3/fYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lskPg1Y0BZIH6M0F9RBQI5JjLCpfo8LQY14b8++IQLn3cn9fSA10/wKk6Wmklho27XdEjVhsp92c5n3HF8170UTpR5bqGiVM/ePiHPofmkPK6KZdHbt5AtW7TjO0bsxxNG1GJ4yi5DPuP6QvNj2z2nPE6Akdy/+L3ZMzRseVYa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=KkxSWW+S; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3122368d7c4so1693251a91.1
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 23:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749797902; x=1750402702; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+QkzcBlS9vLeXpRqbqSrDujMqO/PGHcWXsj9ZWs9Z+U=;
        b=KkxSWW+SF9FhhCnVtTyaMB67h9yguKRlIVV6bbR1uVKMNCs2wHuVzWy//n/GS4bWb0
         SximIxThvye5qm/TntjDXRlBeAjvPLNQkC9xQmgtXDra5ICRHgq8J5pVMPU6bUyI5i1s
         LHGhsXOdomHF4lKhE6AHXD9dCEfrI/NFydIXgtA6dSzstDRHmKlhGXNqioqUDHbqRNiw
         ifaAABpmX3PlxeMNQGCvr1sqjmjYqAIY1+BvjvQn2QC68RAlfKAYP5mgOkNhjjhsCz6y
         1mMsxg/hJW3icWD28Qqk9ACoxw41kpOP6DDt4T/xPQ3enfjyg/hJw4MiMUJTtIJUftyh
         GC8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749797902; x=1750402702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+QkzcBlS9vLeXpRqbqSrDujMqO/PGHcWXsj9ZWs9Z+U=;
        b=SiPfPGFnlXAaoiFxjxyC38Kt4iy/tAbvGRk/nmIRW8hDJfnDTbtnnB9EiPNSRwbRh1
         3UEuq4QmqYT7wu/VeluL5cvUtgNuOCiMiu1pQV0LjgooHr/lBEmNFULkTckO1/MXzWK0
         QopXG0w9LYTCefyY7qDS3myL51O2R1NhRTt0hA2L3UIyZDMNmCBNE+2lZ/N0lWS6kdbE
         98gIOsEiEoFkZbPtmdgOX4/mJxtbRZm4OyK155fzdOgiQX0gglv5Qb6o34Z9bzVnz/g4
         XZJ04z6qVXNRTwSwhwx/Nado8iuYMkCtTFMbd8nILdKtXklbryXQ1fL9OWfqXMqCaRFG
         AyrQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0XznXI5/PDViMyYlCKJybzx5kHDMpDnT6XiKerU3ol6+mrTF7gas9d0YKFu3fxkekOCY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCE5kUf01xqMMaKiqGlhz8iCIn8aBYjBPyEVCYg6+jqlXqNZdw
	y63D5e3ChC+1KLbx7ftMRQidIhaCuprkKwTUPwHU0fgmFTI6B2G3l87lVlpUSnlCgo9Xa0gL7G/
	ymsQTjsE=
X-Gm-Gg: ASbGncugdPZxA+YS1M/WTl2X3tBTEtj/weUxRAdaWav6BLswJ+zTpLlHee2pQUvQGVc
	++JSz9VxtwxqgIwadtEZzFWuafoBdtB3uojL1avweuPX6KptvzR6zYAka0elvTtOOns88/IEfJn
	jtONO9Z1arQGlgYSBG+hMjp5ivA8vlPeUkRWOeg63aBJjNeMSEfNCYuCtiNVWrUudi+RLI1HHP5
	RWYCETFxwFDs61FkCb6lIfwW18k3G5qUOPkDZAPUvbbQ2SSOL38+1MW50/tkDIfQ1+DaQAnqd/6
	7RH8r6A0kJlokM44JC+dS74Q4omQTM3OkVUn8GXrFuf2bzpSKaw6OmHEaeBmsCvcVcRzeEUIUcU
	H1OckiQjDxoQ32MbvVH0=
X-Google-Smtp-Source: AGHT+IFcoxTnNLLCaRe3MbV5XZ2eB09JQHRiE2nVJsRUpfaY0rXLYI7i9qxtUj8gRjcaZRLWDhOK7A==
X-Received: by 2002:a17:90b:28cf:b0:313:2768:3f6b with SMTP id 98e67ed59e1d1-313d9ed72f7mr2932665a91.27.1749797902357;
        Thu, 12 Jun 2025 23:58:22 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b49b7fsm2653022a91.24.2025.06.12.23.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 23:58:21 -0700 (PDT)
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
Subject: [PATCH v2 06/12] RISC-V: KVM: Implement kvm_arch_flush_remote_tlbs_range()
Date: Fri, 13 Jun 2025 12:27:37 +0530
Message-ID: <20250613065743.737102-7-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250613065743.737102-1-apatel@ventanamicro.com>
References: <20250613065743.737102-1-apatel@ventanamicro.com>
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


