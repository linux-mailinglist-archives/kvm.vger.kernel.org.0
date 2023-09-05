Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 724BE792601
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbjIEQDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344545AbjIEDrw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 23:47:52 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B51CC7;
        Mon,  4 Sep 2023 20:47:49 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-54290603887so1061999a12.1;
        Mon, 04 Sep 2023 20:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693885669; x=1694490469; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1NCd3zXYijLU4BSO+1Z6fSOlgVMAIDUZ/MAH8e1hDO4=;
        b=AbuFJvoYugZ0QVeP6Wtsh1U/wQE8NBNPbfl1MquXhg02kKqwi8XauC76hdQUC6xAil
         YX+y8ZnUiuU6WoOugjO7MKpKmucbEq0JpP9UZv7iTpLg7v/0JM+7JxlZLX3xxFq948Qk
         MtkrzdeYYci+xrClXBE61wXDPyT61xhnWDOnRNj/HsA5yKKA6/negpmjM3EYBIKJGPvO
         A46ZduFjML5cHF0a6v4WdYUKLFZrjPs8N6v9O2AjTQikAz4CevRpPSlcdGAquO1p7K+j
         t+sqLT/wjVspQHUVZDk70m/fqmBRBAhDZenn+MlyKtimii03yLo7RkTIAzeWSYEVkCUy
         W8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693885669; x=1694490469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1NCd3zXYijLU4BSO+1Z6fSOlgVMAIDUZ/MAH8e1hDO4=;
        b=YB5e6gsvhNwPuxBb6sDD75zJtx8mEM2JSZb6jLuukxosCzYwU1yW1SUMPEuzzpnwe2
         GeftFWEI9ec0hwIlH2gdDnB8gyVqOaEDGjj0ELjt0oa3ue3Kec06wjcj9+8C1fIvzeDr
         Cs+qLDEBvqRGhG23Q59TDE3ySVId5R5+hQ3/yNFZwIOxaETXISbQFDvUEDn3ovyUmv+g
         G7SFpMEEh7UfnObSJLxVZAunOe5FyyXbrBnAlMWj31dgEr9YxVf+MW2MDTaUZJlZNdXq
         VkxJlzVF9xOep8+0w+1zPyfH3Y3cY4dW7BxGl2OYxMaxEapXqLaljsBZ3E1puzRxqbRu
         btww==
X-Gm-Message-State: AOJu0YwnZkWkJ42imWzeQkOYGQGy0e4NVr71jDUaA/6bRdePKBezaA0k
        w1cA+ao/EAbxGl3HiIYGExQ=
X-Google-Smtp-Source: AGHT+IHinK7BAHWFKKvz4YXXd1HFuesBNBWZmviPbZ3CaI2Q/brpkCknUKxyXTv5ajigGshJRnqXlQ==
X-Received: by 2002:a05:6a20:158b:b0:14a:d117:ef97 with SMTP id h11-20020a056a20158b00b0014ad117ef97mr11884523pzj.11.1693885668631;
        Mon, 04 Sep 2023 20:47:48 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([129.41.57.2])
        by smtp.gmail.com with ESMTPSA id v23-20020aa78097000000b0063f0068cf6csm7994951pff.198.2023.09.04.20.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 20:47:48 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v4 04/11] KVM: PPC: Use accessors for VCPU registers
Date:   Tue,  5 Sep 2023 13:46:51 +1000
Message-Id: <20230905034658.82835-5-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230905034658.82835-1-jniethe5@gmail.com>
References: <20230905034658.82835-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce accessor generator macros for VCPU registers. Use the accessor
functions to replace direct accesses to this registers.

This will be important later for Nested APIv2 support which requires
additional functionality for accessing and modifying VCPU state.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v4:
  - Split to unique patch
---
 arch/powerpc/include/asm/kvm_book3s.h  | 37 +++++++++++++++++++++++++-
 arch/powerpc/kvm/book3s.c              | 22 +++++++--------
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  4 +--
 arch/powerpc/kvm/book3s_hv.c           | 12 ++++-----
 arch/powerpc/kvm/book3s_hv_p9_entry.c  |  4 +--
 arch/powerpc/kvm/powerpc.c             |  4 +--
 6 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 109a5f56767a..1a220cd63227 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -458,10 +458,45 @@ static inline void kvmppc_set_vscr(struct kvm_vcpu *vcpu, u32 val)
 }
 #endif
 
+#define KVMPPC_BOOK3S_VCPU_ACCESSOR_SET(reg, size)			\
+static inline void kvmppc_set_##reg(struct kvm_vcpu *vcpu, u##size val)	\
+{									\
+									\
+	vcpu->arch.reg = val;						\
+}
+
+#define KVMPPC_BOOK3S_VCPU_ACCESSOR_GET(reg, size)			\
+static inline u##size kvmppc_get_##reg(struct kvm_vcpu *vcpu)		\
+{									\
+	return vcpu->arch.reg;						\
+}
+
+#define KVMPPC_BOOK3S_VCPU_ACCESSOR(reg, size)				\
+	KVMPPC_BOOK3S_VCPU_ACCESSOR_SET(reg, size)			\
+	KVMPPC_BOOK3S_VCPU_ACCESSOR_GET(reg, size)			\
+
+KVMPPC_BOOK3S_VCPU_ACCESSOR(pid, 32)
+KVMPPC_BOOK3S_VCPU_ACCESSOR(tar, 64)
+KVMPPC_BOOK3S_VCPU_ACCESSOR(ebbhr, 64)
+KVMPPC_BOOK3S_VCPU_ACCESSOR(ebbrr, 64)
+KVMPPC_BOOK3S_VCPU_ACCESSOR(bescr, 64)
+KVMPPC_BOOK3S_VCPU_ACCESSOR(ic, 64)
+KVMPPC_BOOK3S_VCPU_ACCESSOR(vrsave, 64)
+
+static inline u64 kvmppc_get_dec_expires(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.dec_expires;
+}
+
+static inline void kvmppc_set_dec_expires(struct kvm_vcpu *vcpu, u64 val)
+{
+	vcpu->arch.dec_expires = val;
+}
+
 /* Expiry time of vcpu DEC relative to host TB */
 static inline u64 kvmppc_dec_expires_host_tb(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.dec_expires - vcpu->arch.vcore->tb_offset;
+	return kvmppc_get_dec_expires(vcpu) - vcpu->arch.vcore->tb_offset;
 }
 
 static inline bool is_kvmppc_resume_guest(int r)
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index c080dd2e96ac..6cd20ab9e94e 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -565,7 +565,7 @@ int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	regs->msr = kvmppc_get_msr(vcpu);
 	regs->srr0 = kvmppc_get_srr0(vcpu);
 	regs->srr1 = kvmppc_get_srr1(vcpu);
-	regs->pid = vcpu->arch.pid;
+	regs->pid = kvmppc_get_pid(vcpu);
 	regs->sprg0 = kvmppc_get_sprg0(vcpu);
 	regs->sprg1 = kvmppc_get_sprg1(vcpu);
 	regs->sprg2 = kvmppc_get_sprg2(vcpu);
@@ -683,19 +683,19 @@ int kvmppc_get_one_reg(struct kvm_vcpu *vcpu, u64 id,
 			*val = get_reg_val(id, vcpu->arch.fscr);
 			break;
 		case KVM_REG_PPC_TAR:
-			*val = get_reg_val(id, vcpu->arch.tar);
+			*val = get_reg_val(id, kvmppc_get_tar(vcpu));
 			break;
 		case KVM_REG_PPC_EBBHR:
-			*val = get_reg_val(id, vcpu->arch.ebbhr);
+			*val = get_reg_val(id, kvmppc_get_ebbhr(vcpu));
 			break;
 		case KVM_REG_PPC_EBBRR:
-			*val = get_reg_val(id, vcpu->arch.ebbrr);
+			*val = get_reg_val(id, kvmppc_get_ebbrr(vcpu));
 			break;
 		case KVM_REG_PPC_BESCR:
-			*val = get_reg_val(id, vcpu->arch.bescr);
+			*val = get_reg_val(id, kvmppc_get_bescr(vcpu));
 			break;
 		case KVM_REG_PPC_IC:
-			*val = get_reg_val(id, vcpu->arch.ic);
+			*val = get_reg_val(id, kvmppc_get_ic(vcpu));
 			break;
 		default:
 			r = -EINVAL;
@@ -768,19 +768,19 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
 			kvmppc_set_fpscr(vcpu, set_reg_val(id, *val));
 			break;
 		case KVM_REG_PPC_TAR:
-			vcpu->arch.tar = set_reg_val(id, *val);
+			kvmppc_set_tar(vcpu, set_reg_val(id, *val));
 			break;
 		case KVM_REG_PPC_EBBHR:
-			vcpu->arch.ebbhr = set_reg_val(id, *val);
+			kvmppc_set_ebbhr(vcpu, set_reg_val(id, *val));
 			break;
 		case KVM_REG_PPC_EBBRR:
-			vcpu->arch.ebbrr = set_reg_val(id, *val);
+			kvmppc_set_ebbrr(vcpu, set_reg_val(id, *val));
 			break;
 		case KVM_REG_PPC_BESCR:
-			vcpu->arch.bescr = set_reg_val(id, *val);
+			kvmppc_set_bescr(vcpu, set_reg_val(id, *val));
 			break;
 		case KVM_REG_PPC_IC:
-			vcpu->arch.ic = set_reg_val(id, *val);
+			kvmppc_set_ic(vcpu, set_reg_val(id, *val));
 			break;
 		default:
 			r = -EINVAL;
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 572707858d65..5c71d6ae3a7b 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -96,7 +96,7 @@ static long kvmhv_copy_tofrom_guest_radix(struct kvm_vcpu *vcpu, gva_t eaddr,
 					  void *to, void *from, unsigned long n)
 {
 	int lpid = vcpu->kvm->arch.lpid;
-	int pid = vcpu->arch.pid;
+	int pid = kvmppc_get_pid(vcpu);
 
 	/* This would cause a data segment intr so don't allow the access */
 	if (eaddr & (0x3FFUL << 52))
@@ -270,7 +270,7 @@ int kvmppc_mmu_radix_xlate(struct kvm_vcpu *vcpu, gva_t eaddr,
 	/* Work out effective PID */
 	switch (eaddr >> 62) {
 	case 0:
-		pid = vcpu->arch.pid;
+		pid = kvmppc_get_pid(vcpu);
 		break;
 	case 3:
 		pid = 0;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4af5b68cf7f8..27faecad1e3b 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2310,7 +2310,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, vcpu->arch.tcscr);
 		break;
 	case KVM_REG_PPC_PID:
-		*val = get_reg_val(id, vcpu->arch.pid);
+		*val = get_reg_val(id, kvmppc_get_pid(vcpu));
 		break;
 	case KVM_REG_PPC_ACOP:
 		*val = get_reg_val(id, vcpu->arch.acop);
@@ -2421,7 +2421,7 @@ static int kvmppc_get_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		*val = get_reg_val(id, vcpu->arch.vcore->arch_compat);
 		break;
 	case KVM_REG_PPC_DEC_EXPIRY:
-		*val = get_reg_val(id, vcpu->arch.dec_expires);
+		*val = get_reg_val(id, kvmppc_get_dec_expires(vcpu));
 		break;
 	case KVM_REG_PPC_ONLINE:
 		*val = get_reg_val(id, vcpu->arch.online);
@@ -2553,7 +2553,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		vcpu->arch.tcscr = set_reg_val(id, *val);
 		break;
 	case KVM_REG_PPC_PID:
-		vcpu->arch.pid = set_reg_val(id, *val);
+		kvmppc_set_pid(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_ACOP:
 		vcpu->arch.acop = set_reg_val(id, *val);
@@ -2606,8 +2606,8 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		 * decrementer, which is better than a large one that
 		 * causes a hang.
 		 */
-		if (!vcpu->arch.dec_expires && tb_offset)
-			vcpu->arch.dec_expires = get_tb() + tb_offset;
+		if (!kvmppc_get_dec_expires(vcpu) && tb_offset)
+			kvmppc_set_dec_expires(vcpu, get_tb() + tb_offset);
 
 		vcpu->arch.vcore->tb_offset = tb_offset;
 		break;
@@ -2690,7 +2690,7 @@ static int kvmppc_set_one_reg_hv(struct kvm_vcpu *vcpu, u64 id,
 		r = kvmppc_set_arch_compat(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_DEC_EXPIRY:
-		vcpu->arch.dec_expires = set_reg_val(id, *val);
+		kvmppc_set_dec_expires(vcpu, set_reg_val(id, *val));
 		break;
 	case KVM_REG_PPC_ONLINE:
 		i = set_reg_val(id, *val);
diff --git a/arch/powerpc/kvm/book3s_hv_p9_entry.c b/arch/powerpc/kvm/book3s_hv_p9_entry.c
index 34f1db212824..34bc0a8a1288 100644
--- a/arch/powerpc/kvm/book3s_hv_p9_entry.c
+++ b/arch/powerpc/kvm/book3s_hv_p9_entry.c
@@ -305,7 +305,7 @@ static void switch_mmu_to_guest_radix(struct kvm *kvm, struct kvm_vcpu *vcpu, u6
 	u32 pid;
 
 	lpid = nested ? nested->shadow_lpid : kvm->arch.lpid;
-	pid = vcpu->arch.pid;
+	pid = kvmppc_get_pid(vcpu);
 
 	/*
 	 * Prior memory accesses to host PID Q3 must be completed before we
@@ -330,7 +330,7 @@ static void switch_mmu_to_guest_hpt(struct kvm *kvm, struct kvm_vcpu *vcpu, u64
 	int i;
 
 	lpid = kvm->arch.lpid;
-	pid = vcpu->arch.pid;
+	pid = kvmppc_get_pid(vcpu);
 
 	/*
 	 * See switch_mmu_to_guest_radix. ptesync should not be required here
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 2e72e5cd7532..f6af752698d0 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -1729,7 +1729,7 @@ int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 			val = get_reg_val(reg->id, kvmppc_get_vscr(vcpu));
 			break;
 		case KVM_REG_PPC_VRSAVE:
-			val = get_reg_val(reg->id, vcpu->arch.vrsave);
+			val = get_reg_val(reg->id, kvmppc_get_vrsave(vcpu));
 			break;
 #endif /* CONFIG_ALTIVEC */
 		default:
@@ -1784,7 +1784,7 @@ int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 				r = -ENXIO;
 				break;
 			}
-			vcpu->arch.vrsave = set_reg_val(reg->id, val);
+			kvmppc_set_vrsave(vcpu, set_reg_val(reg->id, val));
 			break;
 #endif /* CONFIG_ALTIVEC */
 		default:
-- 
2.39.3

