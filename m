Return-Path: <kvm+bounces-47410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C0C8AC158E
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 22:36:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69B1EA200E3
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 20:35:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EE823C4EA;
	Thu, 22 May 2025 20:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="fgjlF1VP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB1B239E68
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 20:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747946141; cv=none; b=I8lmp4TZiBTFgskO9jkSi5JVUCGRPczIc2Y1RjWWfOSmO/gfi5wjhm+Loly2bJGzNQcZOmeOJ/kBGaM5haf+HXGnf7YESoj1VjuAmmk7D0GuYt5VfFF3V1eAkCKLTXj5Fjo3Hk2K/VPz1aEfO+BO3X+O7bmE8ZMuTcXXZubSNTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747946141; c=relaxed/simple;
	bh=G5DjctQXgpnKHi8p8ajBugWNHkXnFCRfVVal3XFToIg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=LspkQcQqLY+skVfSrMz0EMWbGqUwtABQNAuQh9yiBnmql/EmF9mH5Mee5ELrLWtjdcW4Z1i2zuQP5JTz7lyOFZeAr5iJ4iDjm973e0Y3C0fsHhpnQpxG77UsOF+o/GuYQEvL914me3DkVOOmBzhpJRGAx4MdEDyJedzIOdVlqoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=fgjlF1VP; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-306b6ae4fb2so6643667a91.3
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 13:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1747946139; x=1748550939; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9U/5M+ajo+Gkj1tgfbc1vbd2oCHGdy+fsgX0VrxxjDQ=;
        b=fgjlF1VP9G0aHiVcaBbmbjk6X83+LQJc1GShZHyVup4TMTbHMhs+sLZZWK2/0tthgX
         Jv/ETPVtJ7T+y7f8w9VffxJk/W5AzchnNBNeHqju0xsiB2jF8H+ZPX91dKY/amy/yrC0
         yRvln8CSHsLWdZt9q1gzWqVbxcQ96QfZ9nfDdGaqLGZGudcd+klSccRS1bIj3prLqhyK
         qwE/W3fPisuUc9my7z1gSQwDyb7CKbZ22qj3C+/6MX9yggtXV5127YSBWhrAsbCkkk58
         VelxSW4orGGo2Ner1XSpwx1EpYX+LtSnky8m/RCtAgnabaGYT4cOfGN1rkrTVXJI8/dR
         hXNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747946139; x=1748550939;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9U/5M+ajo+Gkj1tgfbc1vbd2oCHGdy+fsgX0VrxxjDQ=;
        b=Ip0ynevhtQ8uqGa0jPRgOBfLY02RKDfWObaefs/eFmw80tLeDe7cpJjgOH6gBujSi7
         fqfk1hHUv7gxHc34KU7hm4dHWYutJbUvjpbchQW/TWn0HYmBCxSvY17sHEQc8VgfKdJ3
         ldNKp8qjiPKrQtYGBZtmIvX2jvZOLlTYEk45QY03UoUe4gtETruFTrLvqSSiMBBqlSFf
         xv2TKSUYeLO7ge5R9O8BSNu42JGXJ9siN1tdHOew20hAOM0jr1fKB80Y7xi9nPMAHXdq
         vccRe8tC/YiGQ+giIhmhP4ztFZ4+vp0jCJIEnDbNoZjrLtb18JSOVU4xu2t7FPTMEqzb
         +T9A==
X-Gm-Message-State: AOJu0Yx62w427cP1g6aCvtiwoT/Ht3q8MpUlZJ2XE+fggSU+nMMCfCbY
	i/tpufEw5A2PBdbI4bNxlh25ytXP0QEN4P036PmwGFnM9VplQUm1psMTN4AVgWE4Fn0=
X-Gm-Gg: ASbGncvWknBHg+lY4IetEm6zoqeWfKt8dUPPkbD7U32WDhxsb2fBHx7odFTmXsKWTmX
	dDehk4WYPc8f4eLKUaLoV/r+Mj3pck7s20NpoF8sFjagAbLKWEVDvyQq2meO5mLxRaFRyCyobLm
	G0KG7VPN+24cn9tmMB5hg9+ooz2+/sKrCacB4bap11yy3+RaiIxxZyfte7R9LrhW2XC54nJETPe
	J7/QKIbF9xWg2YwXBkupBUTfiZoebMOnMCyiuJlUF/u8Xlef0r/Jq8JFjysovV5R2mwciaR6soY
	M8El7VDMpTQkubvpy+nWB8FNPVpipzhU+dWjn4P8afVTRpCTM5z0MIjeIgXBrc1h
X-Google-Smtp-Source: AGHT+IELwMEFwHhuScHHyQ7/U0noZU5+9NnOKAusz1Utvndq2rvsq/J8AdaP7d6jJo94bLP1ogTjNw==
X-Received: by 2002:a17:90b:17cc:b0:30e:9349:2d99 with SMTP id 98e67ed59e1d1-310e96b5ff6mr767848a91.5.1747946138723;
        Thu, 22 May 2025 13:35:38 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365b229csm5932754a91.10.2025.05.22.13.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 13:35:38 -0700 (PDT)
From: Atish Patra <atishp@rivosinc.com>
Date: Thu, 22 May 2025 13:35:26 -0700
Subject: [PATCH v2 2/5] RISC-V: KVM: Add a hstateen lazy enabler helper
 function
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250522-kvm_lazy_enable_stateen-v2-2-b7a84991f1c4@rivosinc.com>
References: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
In-Reply-To: <20250522-kvm_lazy_enable_stateen-v2-0-b7a84991f1c4@rivosinc.com>
To: Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>
Cc: kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 Atish Patra <atishp@rivosinc.com>
X-Mailer: b4 0.15-dev-42535

Hstateen has different bits that can be enabled lazily at runtime.
Most of them have similar functionality where the hstateen bit must
be enabled if not enabled already. The correpsonding config bit in
vcpu must be enabled as well so that hstateen CSR is updated correctly
during the next vcpu load. In absesnce of Smstateen extension, exit
to the userspace in the trap because CSR access control exists
architecturally only if Smstateen extension is available.

Add a common helper function to achieve the above said objective.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/include/asm/kvm_vcpu_insn.h |  4 ++++
 arch/riscv/kvm/vcpu_insn.c             | 30 ++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_vcpu_insn.h b/arch/riscv/include/asm/kvm_vcpu_insn.h
index 350011c83581..1125f3f1c8c4 100644
--- a/arch/riscv/include/asm/kvm_vcpu_insn.h
+++ b/arch/riscv/include/asm/kvm_vcpu_insn.h
@@ -6,6 +6,8 @@
 #ifndef __KVM_VCPU_RISCV_INSN_H
 #define __KVM_VCPU_RISCV_INSN_H
 
+#include <linux/kvm_types.h>
+
 struct kvm_vcpu;
 struct kvm_run;
 struct kvm_cpu_trap;
@@ -44,5 +46,7 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			      unsigned long fault_addr,
 			      unsigned long htinst);
 int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_hstateen_lazy_enable(struct kvm_vcpu *vcpu, unsigned int csr_num,
+					uint64_t hstateen_feature_bit_mask);
 
 #endif
diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 97dec18e6989..0a7e229cfd34 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -235,6 +235,36 @@ static int seed_csr_rmw(struct kvm_vcpu *vcpu, unsigned int csr_num,
 	return KVM_INSN_EXIT_TO_USER_SPACE;
 }
 
+int kvm_riscv_vcpu_hstateen_lazy_enable(struct kvm_vcpu *vcpu, unsigned int csr_num,
+					uint64_t hstateen_feature_bit_mask)
+{
+	/* Access from VS shouldn't trap if smstaeen is not present */
+	if (!riscv_has_extension_unlikely(RISCV_ISA_EXT_SMSTATEEN))
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+
+	/*
+	 * Make sure that KVM doesn't enable any guest visible state via sstateen (lower 32 bits)
+	 * yet. Access is restricted to prevent unintended behavior.
+	 */
+	if (hstateen_feature_bit_mask & GENMASK(31, 0)) {
+		pr_err("Unexpected access from lower 32 bits of hstateen0\n");
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+	}
+
+	/* Enable the bit in hstateen0 lazily upon first access */
+	if (!(vcpu->arch.cfg.hstateen0 & hstateen_feature_bit_mask)) {
+		vcpu->arch.cfg.hstateen0 |= hstateen_feature_bit_mask;
+		csr_set(CSR_HSTATEEN0, hstateen_feature_bit_mask);
+		if (IS_ENABLED(CONFIG_32BIT))
+			csr_set(CSR_HSTATEEN0H, hstateen_feature_bit_mask >> 32);
+	} else {
+		return KVM_INSN_EXIT_TO_USER_SPACE;
+	}
+
+	/* Let the guest retry the instruction read after hstateen0 is modified */
+	return KVM_INSN_CONTINUE_SAME_SEPC;
+}
+
 static const struct csr_func csr_funcs[] = {
 	KVM_RISCV_VCPU_AIA_CSR_FUNCS
 	KVM_RISCV_VCPU_HPMCOUNTER_CSR_FUNCS

-- 
2.43.0


