Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417246E84D8
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbjDSWXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbjDSWXQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:23:16 -0400
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D54AC172
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:21:25 -0700 (PDT)
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5191796a483so231528a12.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942729; x=1684534729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XK5xUw/rzaPgA4jO4a/YwH8Byrp1ajuQRNW8VnU2lnI=;
        b=QfXuULt6GKdZ0yIYOBu58cROq1xtd+AwU5tA9tWSYcP8puXwvEN9RX3lXVuV60tyoW
         4Q0CSfUoxv6NDjypNOuOT4ywNhU7IYB+qeWNkXwN91wiD9TQD3HOmit1hlHNqFbWVtNJ
         ziwh+QBq1N6MeIyCvSv5s6RR13cXyHzSqXBQKCnCZR2rrQanp3QhB3VbRYZ2jQSTPE6d
         Vpg87adIN6SFou4dfOJ3ZLRcLAQq2ZlEUcDyGi0vckdKvSSc1nPlKdGfKGwb9h5rUo3e
         rLKhVd1kgYj7FOEo7g+ojtFs7lAxzBaXut+YFsbxt/trii3p8w9AEE1pM3je3JF/e5ut
         1yXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942729; x=1684534729;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XK5xUw/rzaPgA4jO4a/YwH8Byrp1ajuQRNW8VnU2lnI=;
        b=SnXvLvYkhF2MSR/N/hfRHrEeQmn68HAJMItUvW0QxaQggFKgwEJ1nk2WIqqnC2dFOV
         UJ/kOt9Oo7RBBwuofKV8ZVDO9j710BHoj+1421F03WiGwya7uzQmLe/wpltK38NSJ+Rb
         ZwHtfywYkY+KQSECQy5ph2VZoZ0X9o/u2PUbXU0aQMmHyWzvRn/K6NSp4bVBshq2tIid
         kFOF2Tokclui1nhOgq7gk+s9oQ4tJcmE6XSIFC+heFir9Rn83QdeD+i66TD0QOoZUyoH
         A9SB9jayG6k6jbcD934mX+T6dPOsr//XDJjgGxiicWQ6lWwiMDhvLS6XesMGvNfU3qrN
         kjjw==
X-Gm-Message-State: AAQBX9f2JbmjiKPtMPz6u7abqjfanBJdN4sogZ8oucs2BAF99wDqy1JR
        j5fTa2bm4QpMvj2bZV7QCSi1mA==
X-Google-Smtp-Source: AKy350baQTNt4Vs4HHjBbXvyObvJ3IXFGZptf7h2H+OASSZVy5+7QV7+crZBWOtRSKw2ldJwBUdMWw==
X-Received: by 2002:a17:903:784:b0:1a2:9183:a499 with SMTP id kn4-20020a170903078400b001a29183a499mr5853196plb.34.1681942729515;
        Wed, 19 Apr 2023 15:18:49 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:18:49 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Atish Patra <atishp@rivosinc.com>,
        Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 36/48] RISC-V: KVM: Read/write gprs from/to shmem in case of TVM VCPU.
Date:   Wed, 19 Apr 2023 15:17:04 -0700
Message-Id: <20230419221716.3603068-37-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230419221716.3603068-1-atishp@rivosinc.com>
References: <20230419221716.3603068-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Rajnesh Kanwal <rkanwal@rivosinc.com>

For TVM vcpus, TSM uses shared memory to exposes gprs for the trusted
VCPU. This change makes sure we use shmem when doing mmio emulation
for trusted VMs.

Signed-off-by: Rajnesh Kanwal <rkanwal@rivosinc.com>
Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 arch/riscv/kvm/vcpu_insn.c | 98 +++++++++++++++++++++++++++++++++-----
 1 file changed, 85 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/kvm/vcpu_insn.c b/arch/riscv/kvm/vcpu_insn.c
index 331489f..56eeb86 100644
--- a/arch/riscv/kvm/vcpu_insn.c
+++ b/arch/riscv/kvm/vcpu_insn.c
@@ -7,6 +7,9 @@
 #include <linux/bitops.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_cove.h>
+#include <asm/kvm_nacl.h>
+#include <asm/kvm_cove_sbi.h>
+#include <asm/asm-offsets.h>
 
 #define INSN_OPCODE_MASK	0x007c
 #define INSN_OPCODE_SHIFT	2
@@ -116,6 +119,10 @@
 #define REG_OFFSET(insn, pos)		\
 	(SHIFT_RIGHT((insn), (pos) - LOG_REGBYTES) & REG_MASK)
 
+#define REG_INDEX(insn, pos)                                    \
+	((SHIFT_RIGHT((insn), (pos)-LOG_REGBYTES) & REG_MASK) / \
+	 (__riscv_xlen / 8))
+
 #define REG_PTR(insn, pos, regs)	\
 	((ulong *)((ulong)(regs) + REG_OFFSET(insn, pos)))
 
@@ -600,6 +607,7 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	int len = 0, insn_len = 0;
 	struct kvm_cpu_trap utrap = { 0 };
 	struct kvm_cpu_context *ct = &vcpu->arch.guest_context;
+	void *nshmem;
 
 	/* Determine trapped instruction */
 	if (htinst & 0x1) {
@@ -627,7 +635,15 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 		insn_len = INSN_LEN(insn);
 	}
 
-	data = GET_RS2(insn, &vcpu->arch.guest_context);
+	if (is_cove_vcpu(vcpu)) {
+		nshmem = nacl_shmem();
+		data = nacl_shmem_gpr_read_cove(nshmem,
+					       REG_INDEX(insn, SH_RS2) * 8 +
+						       KVM_ARCH_GUEST_ZERO);
+	} else {
+		data = GET_RS2(insn, &vcpu->arch.guest_context);
+	}
+
 	data8 = data16 = data32 = data64 = data;
 
 	if ((insn & INSN_MASK_SW) == INSN_MATCH_SW) {
@@ -643,19 +659,43 @@ int kvm_riscv_vcpu_mmio_store(struct kvm_vcpu *vcpu, struct kvm_run *run,
 #ifdef CONFIG_64BIT
 	} else if ((insn & INSN_MASK_C_SD) == INSN_MATCH_C_SD) {
 		len = 8;
-		data64 = GET_RS2S(insn, &vcpu->arch.guest_context);
+		if (is_cove_vcpu(vcpu)) {
+			data64 = nacl_shmem_gpr_read_cove(
+				nshmem,
+				RVC_RS2S(insn) * 8 + KVM_ARCH_GUEST_ZERO);
+		} else {
+			data64 = GET_RS2S(insn, &vcpu->arch.guest_context);
+		}
 	} else if ((insn & INSN_MASK_C_SDSP) == INSN_MATCH_C_SDSP &&
 		   ((insn >> SH_RD) & 0x1f)) {
 		len = 8;
-		data64 = GET_RS2C(insn, &vcpu->arch.guest_context);
+		if (is_cove_vcpu(vcpu)) {
+			data64 = nacl_shmem_gpr_read_cove(
+				nshmem, REG_INDEX(insn, SH_RS2C) * 8 +
+						KVM_ARCH_GUEST_ZERO);
+		} else {
+			data64 = GET_RS2C(insn, &vcpu->arch.guest_context);
+		}
 #endif
 	} else if ((insn & INSN_MASK_C_SW) == INSN_MATCH_C_SW) {
 		len = 4;
-		data32 = GET_RS2S(insn, &vcpu->arch.guest_context);
+		if (is_cove_vcpu(vcpu)) {
+			data32 = nacl_shmem_gpr_read_cove(
+				nshmem,
+				RVC_RS2S(insn) * 8 + KVM_ARCH_GUEST_ZERO);
+		} else {
+			data32 = GET_RS2S(insn, &vcpu->arch.guest_context);
+		}
 	} else if ((insn & INSN_MASK_C_SWSP) == INSN_MATCH_C_SWSP &&
 		   ((insn >> SH_RD) & 0x1f)) {
 		len = 4;
-		data32 = GET_RS2C(insn, &vcpu->arch.guest_context);
+		if (is_cove_vcpu(vcpu)) {
+			data32 = nacl_shmem_gpr_read_cove(
+				nshmem, REG_INDEX(insn, SH_RS2C) * 8 +
+						KVM_ARCH_GUEST_ZERO);
+		} else {
+			data32 = GET_RS2C(insn, &vcpu->arch.guest_context);
+		}
 	} else {
 		return -EOPNOTSUPP;
 	}
@@ -725,6 +765,7 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	u64 data64;
 	ulong insn;
 	int len, shift;
+	void *nshmem;
 
 	if (vcpu->arch.mmio_decode.return_handled)
 		return 0;
@@ -738,26 +779,57 @@ int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	len = vcpu->arch.mmio_decode.len;
 	shift = vcpu->arch.mmio_decode.shift;
 
+	if (is_cove_vcpu(vcpu))
+		nshmem = nacl_shmem();
+
 	switch (len) {
 	case 1:
 		data8 = *((u8 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data8 << shift >> shift);
+		if (is_cove_vcpu(vcpu)) {
+			nacl_shmem_gpr_write_cove(nshmem,
+						 REG_INDEX(insn, SH_RD) * 8 +
+							 KVM_ARCH_GUEST_ZERO,
+						 (unsigned long)data8);
+		} else {
+			SET_RD(insn, &vcpu->arch.guest_context,
+			       (ulong)data8 << shift >> shift);
+		}
 		break;
 	case 2:
 		data16 = *((u16 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data16 << shift >> shift);
+		if (is_cove_vcpu(vcpu)) {
+			nacl_shmem_gpr_write_cove(nshmem,
+						 REG_INDEX(insn, SH_RD) * 8 +
+							 KVM_ARCH_GUEST_ZERO,
+						 (unsigned long)data16);
+		} else {
+			SET_RD(insn, &vcpu->arch.guest_context,
+			       (ulong)data16 << shift >> shift);
+		}
 		break;
 	case 4:
 		data32 = *((u32 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data32 << shift >> shift);
+		if (is_cove_vcpu(vcpu)) {
+			nacl_shmem_gpr_write_cove(nshmem,
+						 REG_INDEX(insn, SH_RD) * 8 +
+							 KVM_ARCH_GUEST_ZERO,
+						 (unsigned long)data32);
+		} else {
+			SET_RD(insn, &vcpu->arch.guest_context,
+			       (ulong)data32 << shift >> shift);
+		}
 		break;
 	case 8:
 		data64 = *((u64 *)run->mmio.data);
-		SET_RD(insn, &vcpu->arch.guest_context,
-			(ulong)data64 << shift >> shift);
+		if (is_cove_vcpu(vcpu)) {
+			nacl_shmem_gpr_write_cove(nshmem,
+						 REG_INDEX(insn, SH_RD) * 8 +
+							 KVM_ARCH_GUEST_ZERO,
+						 (unsigned long)data64);
+		} else {
+			SET_RD(insn, &vcpu->arch.guest_context,
+			       (ulong)data64 << shift >> shift);
+		}
 		break;
 	default:
 		return -EOPNOTSUPP;
-- 
2.25.1

