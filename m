Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AC779F88C
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbjINDG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjINDGZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:06:25 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59EB71BD2;
        Wed, 13 Sep 2023 20:06:21 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-53482b44007so334220a12.2;
        Wed, 13 Sep 2023 20:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694660781; x=1695265581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lxy+b1BdYbakS5m9yj1nPqYsElyAEwg/bRTrolDmnOY=;
        b=RvK8CRaYQaiXwQhUkayXkPDKawzGMdOTTrcyadTDmnLYa0s3yhXpW6JLWuKR8PsfDN
         arJYlf2PNKP1vLHLrLUK4Ut1OHA9SMBYalMK5zEtrw4B/GEWqfd0Y7tb9b+5zPvlZQKz
         uD5xlWU0TxeFjwfynaSR+xJWvyqBZ+0xzahVf5MnWd4PWfZyQO8Tjgs16EU9tTFmELd2
         q3TnVvQ1LQFoA4/YUvhRlB63ent0AM5oBeF39ega+8XTpWF6timWvHjJn85/KSHL8NFe
         GWKotYHrgKTEgyuMpFuHUtsrUOWUd1TMbK0/PruQqYZLDqkKV/r/j4nQzb8unGZFaZoZ
         TtpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694660781; x=1695265581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lxy+b1BdYbakS5m9yj1nPqYsElyAEwg/bRTrolDmnOY=;
        b=Yy6LAi3RoZJIgjvuQ+4Tjn61ng0gSrpDhUodU7vBn7reruSX7zbxJTca1AsIDXt+Za
         TT63zZPy9BF+fDrvM0i47LctGkNzbsz4I+fD5xlVZf83HkySYNEQGW476fuDb1Z9xYIt
         E0yf7+tNaXRrypNayR2Z9wE1yUNudDsw0YTA04U7pPn+AiH5DL68S68I2Sl9g2+v6s7i
         NG+bhlIosCEEcsMV3DoJD49WeGSpxYokchsWUcm+SPCdxUODNcVSJt44eVioyiceqXxR
         ymP1n7ZnCUvf/8UU9okueELysYudYXuzsNk8WvzuBX6GUjXCgE8jLaJcp3zP274SOptK
         oWWw==
X-Gm-Message-State: AOJu0Yw2vbmvCo/0WBEsdKJSOiaoLcLb7rK9QnhzPhGuQizcylEJDkgM
        lU0amnE5H5ANYn06C8cjjs4=
X-Google-Smtp-Source: AGHT+IGMi0XgBYO9EFRmcnw54FkV6GXdiiuExEKZr0bdN/YaKp1bJC1yQALhAqWQ38L/9v5PE5pDhQ==
X-Received: by 2002:a17:902:d491:b0:1c3:3347:996e with SMTP id c17-20020a170902d49100b001c33347996emr6015087plg.23.1694660780662;
        Wed, 13 Sep 2023 20:06:20 -0700 (PDT)
Received: from pwon.ozlabs.ibm.com ([146.112.118.69])
        by smtp.gmail.com with ESMTPSA id w2-20020a170902904200b001b567bbe82dsm330521plz.150.2023.09.13.20.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 20:06:20 -0700 (PDT)
From:   Jordan Niethe <jniethe5@gmail.com>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, npiggin@gmail.com,
        mikey@neuling.org, paulus@ozlabs.org, vaibhav@linux.ibm.com,
        sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM, mpe@ellerman.id.au, sachinp@linux.ibm.com,
        Jordan Niethe <jniethe5@gmail.com>
Subject: [PATCH v5 02/11] KVM: PPC: Introduce FPR/VR accessor functions
Date:   Thu, 14 Sep 2023 13:05:51 +1000
Message-Id: <20230914030600.16993-3-jniethe5@gmail.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230914030600.16993-1-jniethe5@gmail.com>
References: <20230914030600.16993-1-jniethe5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce accessor functions for floating point and vector registers
like the ones that exist for GPRs. Use these to replace the existing FPR
and VR accessor macros.

This will be important later for Nested APIv2 support which requires
additional functionality for accessing and modifying VCPU state.

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
v3:
  - Guatam: Pass vector elements by reference
v4:
  - Split into unique patch
---
 arch/powerpc/include/asm/kvm_book3s.h | 55 ++++++++++++++++++++
 arch/powerpc/include/asm/kvm_booke.h  | 10 ++++
 arch/powerpc/kvm/book3s.c             | 16 +++---
 arch/powerpc/kvm/emulate_loadstore.c  |  2 +-
 arch/powerpc/kvm/powerpc.c            | 72 +++++++++++++--------------
 5 files changed, 110 insertions(+), 45 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index bbf5e2c5fe09..109a5f56767a 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -403,6 +403,61 @@ static inline ulong kvmppc_get_fault_dar(struct kvm_vcpu *vcpu)
 	return vcpu->arch.fault_dar;
 }
 
+static inline u64 kvmppc_get_fpr(struct kvm_vcpu *vcpu, int i)
+{
+	return vcpu->arch.fp.fpr[i][TS_FPROFFSET];
+}
+
+static inline void kvmppc_set_fpr(struct kvm_vcpu *vcpu, int i, u64 val)
+{
+	vcpu->arch.fp.fpr[i][TS_FPROFFSET] = val;
+}
+
+static inline u64 kvmppc_get_fpscr(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.fp.fpscr;
+}
+
+static inline void kvmppc_set_fpscr(struct kvm_vcpu *vcpu, u64 val)
+{
+	vcpu->arch.fp.fpscr = val;
+}
+
+
+static inline u64 kvmppc_get_vsx_fpr(struct kvm_vcpu *vcpu, int i, int j)
+{
+	return vcpu->arch.fp.fpr[i][j];
+}
+
+static inline void kvmppc_set_vsx_fpr(struct kvm_vcpu *vcpu, int i, int j,
+				      u64 val)
+{
+	vcpu->arch.fp.fpr[i][j] = val;
+}
+
+#ifdef CONFIG_ALTIVEC
+static inline void kvmppc_get_vsx_vr(struct kvm_vcpu *vcpu, int i, vector128 *v)
+{
+	*v =  vcpu->arch.vr.vr[i];
+}
+
+static inline void kvmppc_set_vsx_vr(struct kvm_vcpu *vcpu, int i,
+				     vector128 *val)
+{
+	vcpu->arch.vr.vr[i] = *val;
+}
+
+static inline u32 kvmppc_get_vscr(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.vr.vscr.u[3];
+}
+
+static inline void kvmppc_set_vscr(struct kvm_vcpu *vcpu, u32 val)
+{
+	vcpu->arch.vr.vscr.u[3] = val;
+}
+#endif
+
 /* Expiry time of vcpu DEC relative to host TB */
 static inline u64 kvmppc_dec_expires_host_tb(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/powerpc/include/asm/kvm_booke.h b/arch/powerpc/include/asm/kvm_booke.h
index 0c3401b2e19e..7c3291aa8922 100644
--- a/arch/powerpc/include/asm/kvm_booke.h
+++ b/arch/powerpc/include/asm/kvm_booke.h
@@ -89,6 +89,16 @@ static inline ulong kvmppc_get_pc(struct kvm_vcpu *vcpu)
 	return vcpu->arch.regs.nip;
 }
 
+static inline void kvmppc_set_fpr(struct kvm_vcpu *vcpu, int i, u64 val)
+{
+	vcpu->arch.fp.fpr[i][TS_FPROFFSET] = val;
+}
+
+static inline u64 kvmppc_get_fpr(struct kvm_vcpu *vcpu, int i)
+{
+	return vcpu->arch.fp.fpr[i][TS_FPROFFSET];
+}
+
 #ifdef CONFIG_BOOKE
 static inline ulong kvmppc_get_fault_dar(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 686d8d9eda3e..c080dd2e96ac 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -636,17 +636,17 @@ int kvmppc_get_one_reg(struct kvm_vcpu *vcpu, u64 id,
 			break;
 		case KVM_REG_PPC_FPR0 ... KVM_REG_PPC_FPR31:
 			i = id - KVM_REG_PPC_FPR0;
-			*val = get_reg_val(id, VCPU_FPR(vcpu, i));
+			*val = get_reg_val(id, kvmppc_get_fpr(vcpu, i));
 			break;
 		case KVM_REG_PPC_FPSCR:
-			*val = get_reg_val(id, vcpu->arch.fp.fpscr);
+			*val = get_reg_val(id, kvmppc_get_fpscr(vcpu));
 			break;
 #ifdef CONFIG_VSX
 		case KVM_REG_PPC_VSR0 ... KVM_REG_PPC_VSR31:
 			if (cpu_has_feature(CPU_FTR_VSX)) {
 				i = id - KVM_REG_PPC_VSR0;
-				val->vsxval[0] = vcpu->arch.fp.fpr[i][0];
-				val->vsxval[1] = vcpu->arch.fp.fpr[i][1];
+				val->vsxval[0] = kvmppc_get_vsx_fpr(vcpu, i, 0);
+				val->vsxval[1] = kvmppc_get_vsx_fpr(vcpu, i, 1);
 			} else {
 				r = -ENXIO;
 			}
@@ -724,7 +724,7 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
 			break;
 		case KVM_REG_PPC_FPR0 ... KVM_REG_PPC_FPR31:
 			i = id - KVM_REG_PPC_FPR0;
-			VCPU_FPR(vcpu, i) = set_reg_val(id, *val);
+			kvmppc_set_fpr(vcpu, i, set_reg_val(id, *val));
 			break;
 		case KVM_REG_PPC_FPSCR:
 			vcpu->arch.fp.fpscr = set_reg_val(id, *val);
@@ -733,8 +733,8 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
 		case KVM_REG_PPC_VSR0 ... KVM_REG_PPC_VSR31:
 			if (cpu_has_feature(CPU_FTR_VSX)) {
 				i = id - KVM_REG_PPC_VSR0;
-				vcpu->arch.fp.fpr[i][0] = val->vsxval[0];
-				vcpu->arch.fp.fpr[i][1] = val->vsxval[1];
+				kvmppc_set_vsx_fpr(vcpu, i, 0, val->vsxval[0]);
+				kvmppc_set_vsx_fpr(vcpu, i, 1, val->vsxval[1]);
 			} else {
 				r = -ENXIO;
 			}
@@ -765,7 +765,7 @@ int kvmppc_set_one_reg(struct kvm_vcpu *vcpu, u64 id,
 			break;
 #endif /* CONFIG_KVM_XIVE */
 		case KVM_REG_PPC_FSCR:
-			vcpu->arch.fscr = set_reg_val(id, *val);
+			kvmppc_set_fpscr(vcpu, set_reg_val(id, *val));
 			break;
 		case KVM_REG_PPC_TAR:
 			vcpu->arch.tar = set_reg_val(id, *val);
diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index 059c08ae0340..e6e66c3792f8 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -250,7 +250,7 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 				vcpu->arch.mmio_sp64_extend = 1;
 
 			emulated = kvmppc_handle_store(vcpu,
-					VCPU_FPR(vcpu, op.reg), size, 1);
+					kvmppc_get_fpr(vcpu, op.reg), size, 1);
 
 			if ((op.type & UPDATE) && (emulated != EMULATE_FAIL))
 				kvmppc_set_gpr(vcpu, op.update_reg, op.ea);
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index 7197c8256668..2e72e5cd7532 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -934,11 +934,11 @@ static inline void kvmppc_set_vsr_dword(struct kvm_vcpu *vcpu,
 		return;
 
 	if (index >= 32) {
-		val.vval = VCPU_VSX_VR(vcpu, index - 32);
+		kvmppc_get_vsx_vr(vcpu, index - 32, &val.vval);
 		val.vsxval[offset] = gpr;
-		VCPU_VSX_VR(vcpu, index - 32) = val.vval;
+		kvmppc_set_vsx_vr(vcpu, index - 32, &val.vval);
 	} else {
-		VCPU_VSX_FPR(vcpu, index, offset) = gpr;
+		kvmppc_set_vsx_fpr(vcpu, index, offset, gpr);
 	}
 }
 
@@ -949,13 +949,13 @@ static inline void kvmppc_set_vsr_dword_dump(struct kvm_vcpu *vcpu,
 	int index = vcpu->arch.io_gpr & KVM_MMIO_REG_MASK;
 
 	if (index >= 32) {
-		val.vval = VCPU_VSX_VR(vcpu, index - 32);
+		kvmppc_get_vsx_vr(vcpu, index - 32, &val.vval);
 		val.vsxval[0] = gpr;
 		val.vsxval[1] = gpr;
-		VCPU_VSX_VR(vcpu, index - 32) = val.vval;
+		kvmppc_set_vsx_vr(vcpu, index - 32, &val.vval);
 	} else {
-		VCPU_VSX_FPR(vcpu, index, 0) = gpr;
-		VCPU_VSX_FPR(vcpu, index, 1) = gpr;
+		kvmppc_set_vsx_fpr(vcpu, index, 0, gpr);
+		kvmppc_set_vsx_fpr(vcpu, index, 1,  gpr);
 	}
 }
 
@@ -970,12 +970,12 @@ static inline void kvmppc_set_vsr_word_dump(struct kvm_vcpu *vcpu,
 		val.vsx32val[1] = gpr;
 		val.vsx32val[2] = gpr;
 		val.vsx32val[3] = gpr;
-		VCPU_VSX_VR(vcpu, index - 32) = val.vval;
+		kvmppc_set_vsx_vr(vcpu, index - 32, &val.vval);
 	} else {
 		val.vsx32val[0] = gpr;
 		val.vsx32val[1] = gpr;
-		VCPU_VSX_FPR(vcpu, index, 0) = val.vsxval[0];
-		VCPU_VSX_FPR(vcpu, index, 1) = val.vsxval[0];
+		kvmppc_set_vsx_fpr(vcpu, index, 0, val.vsxval[0]);
+		kvmppc_set_vsx_fpr(vcpu, index, 1, val.vsxval[0]);
 	}
 }
 
@@ -991,15 +991,15 @@ static inline void kvmppc_set_vsr_word(struct kvm_vcpu *vcpu,
 		return;
 
 	if (index >= 32) {
-		val.vval = VCPU_VSX_VR(vcpu, index - 32);
+		kvmppc_get_vsx_vr(vcpu, index - 32, &val.vval);
 		val.vsx32val[offset] = gpr32;
-		VCPU_VSX_VR(vcpu, index - 32) = val.vval;
+		kvmppc_set_vsx_vr(vcpu, index - 32, &val.vval);
 	} else {
 		dword_offset = offset / 2;
 		word_offset = offset % 2;
-		val.vsxval[0] = VCPU_VSX_FPR(vcpu, index, dword_offset);
+		val.vsxval[0] = kvmppc_get_vsx_fpr(vcpu, index, dword_offset);
 		val.vsx32val[word_offset] = gpr32;
-		VCPU_VSX_FPR(vcpu, index, dword_offset) = val.vsxval[0];
+		kvmppc_set_vsx_fpr(vcpu, index, dword_offset, val.vsxval[0]);
 	}
 }
 #endif /* CONFIG_VSX */
@@ -1058,9 +1058,9 @@ static inline void kvmppc_set_vmx_dword(struct kvm_vcpu *vcpu,
 	if (offset == -1)
 		return;
 
-	val.vval = VCPU_VSX_VR(vcpu, index);
+	kvmppc_get_vsx_vr(vcpu, index, &val.vval);
 	val.vsxval[offset] = gpr;
-	VCPU_VSX_VR(vcpu, index) = val.vval;
+	kvmppc_set_vsx_vr(vcpu, index, &val.vval);
 }
 
 static inline void kvmppc_set_vmx_word(struct kvm_vcpu *vcpu,
@@ -1074,9 +1074,9 @@ static inline void kvmppc_set_vmx_word(struct kvm_vcpu *vcpu,
 	if (offset == -1)
 		return;
 
-	val.vval = VCPU_VSX_VR(vcpu, index);
+	kvmppc_get_vsx_vr(vcpu, index, &val.vval);
 	val.vsx32val[offset] = gpr32;
-	VCPU_VSX_VR(vcpu, index) = val.vval;
+	kvmppc_set_vsx_vr(vcpu, index, &val.vval);
 }
 
 static inline void kvmppc_set_vmx_hword(struct kvm_vcpu *vcpu,
@@ -1090,9 +1090,9 @@ static inline void kvmppc_set_vmx_hword(struct kvm_vcpu *vcpu,
 	if (offset == -1)
 		return;
 
-	val.vval = VCPU_VSX_VR(vcpu, index);
+	kvmppc_get_vsx_vr(vcpu, index, &val.vval);
 	val.vsx16val[offset] = gpr16;
-	VCPU_VSX_VR(vcpu, index) = val.vval;
+	kvmppc_set_vsx_vr(vcpu, index, &val.vval);
 }
 
 static inline void kvmppc_set_vmx_byte(struct kvm_vcpu *vcpu,
@@ -1106,9 +1106,9 @@ static inline void kvmppc_set_vmx_byte(struct kvm_vcpu *vcpu,
 	if (offset == -1)
 		return;
 
-	val.vval = VCPU_VSX_VR(vcpu, index);
+	kvmppc_get_vsx_vr(vcpu, index, &val.vval);
 	val.vsx8val[offset] = gpr8;
-	VCPU_VSX_VR(vcpu, index) = val.vval;
+	kvmppc_set_vsx_vr(vcpu, index, &val.vval);
 }
 #endif /* CONFIG_ALTIVEC */
 
@@ -1194,14 +1194,14 @@ static void kvmppc_complete_mmio_load(struct kvm_vcpu *vcpu)
 		if (vcpu->kvm->arch.kvm_ops->giveup_ext)
 			vcpu->kvm->arch.kvm_ops->giveup_ext(vcpu, MSR_FP);
 
-		VCPU_FPR(vcpu, vcpu->arch.io_gpr & KVM_MMIO_REG_MASK) = gpr;
+		kvmppc_set_fpr(vcpu, vcpu->arch.io_gpr & KVM_MMIO_REG_MASK, gpr);
 		break;
 #ifdef CONFIG_PPC_BOOK3S
 	case KVM_MMIO_REG_QPR:
 		vcpu->arch.qpr[vcpu->arch.io_gpr & KVM_MMIO_REG_MASK] = gpr;
 		break;
 	case KVM_MMIO_REG_FQPR:
-		VCPU_FPR(vcpu, vcpu->arch.io_gpr & KVM_MMIO_REG_MASK) = gpr;
+		kvmppc_set_fpr(vcpu, vcpu->arch.io_gpr & KVM_MMIO_REG_MASK, gpr);
 		vcpu->arch.qpr[vcpu->arch.io_gpr & KVM_MMIO_REG_MASK] = gpr;
 		break;
 #endif
@@ -1419,9 +1419,9 @@ static inline int kvmppc_get_vsr_data(struct kvm_vcpu *vcpu, int rs, u64 *val)
 		}
 
 		if (rs < 32) {
-			*val = VCPU_VSX_FPR(vcpu, rs, vsx_offset);
+			*val = kvmppc_get_vsx_fpr(vcpu, rs, vsx_offset);
 		} else {
-			reg.vval = VCPU_VSX_VR(vcpu, rs - 32);
+			kvmppc_get_vsx_vr(vcpu, rs - 32, &reg.vval);
 			*val = reg.vsxval[vsx_offset];
 		}
 		break;
@@ -1438,10 +1438,10 @@ static inline int kvmppc_get_vsr_data(struct kvm_vcpu *vcpu, int rs, u64 *val)
 		if (rs < 32) {
 			dword_offset = vsx_offset / 2;
 			word_offset = vsx_offset % 2;
-			reg.vsxval[0] = VCPU_VSX_FPR(vcpu, rs, dword_offset);
+			reg.vsxval[0] = kvmppc_get_vsx_fpr(vcpu, rs, dword_offset);
 			*val = reg.vsx32val[word_offset];
 		} else {
-			reg.vval = VCPU_VSX_VR(vcpu, rs - 32);
+			kvmppc_get_vsx_vr(vcpu, rs - 32, &reg.vval);
 			*val = reg.vsx32val[vsx_offset];
 		}
 		break;
@@ -1556,7 +1556,7 @@ static int kvmppc_get_vmx_dword(struct kvm_vcpu *vcpu, int index, u64 *val)
 	if (vmx_offset == -1)
 		return -1;
 
-	reg.vval = VCPU_VSX_VR(vcpu, index);
+	kvmppc_get_vsx_vr(vcpu, index, &reg.vval);
 	*val = reg.vsxval[vmx_offset];
 
 	return result;
@@ -1574,7 +1574,7 @@ static int kvmppc_get_vmx_word(struct kvm_vcpu *vcpu, int index, u64 *val)
 	if (vmx_offset == -1)
 		return -1;
 
-	reg.vval = VCPU_VSX_VR(vcpu, index);
+	kvmppc_get_vsx_vr(vcpu, index, &reg.vval);
 	*val = reg.vsx32val[vmx_offset];
 
 	return result;
@@ -1592,7 +1592,7 @@ static int kvmppc_get_vmx_hword(struct kvm_vcpu *vcpu, int index, u64 *val)
 	if (vmx_offset == -1)
 		return -1;
 
-	reg.vval = VCPU_VSX_VR(vcpu, index);
+	kvmppc_get_vsx_vr(vcpu, index, &reg.vval);
 	*val = reg.vsx16val[vmx_offset];
 
 	return result;
@@ -1610,7 +1610,7 @@ static int kvmppc_get_vmx_byte(struct kvm_vcpu *vcpu, int index, u64 *val)
 	if (vmx_offset == -1)
 		return -1;
 
-	reg.vval = VCPU_VSX_VR(vcpu, index);
+	kvmppc_get_vsx_vr(vcpu, index, &reg.vval);
 	*val = reg.vsx8val[vmx_offset];
 
 	return result;
@@ -1719,14 +1719,14 @@ int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 				r = -ENXIO;
 				break;
 			}
-			val.vval = vcpu->arch.vr.vr[reg->id - KVM_REG_PPC_VR0];
+			kvmppc_get_vsx_vr(vcpu, reg->id - KVM_REG_PPC_VR0, &val.vval);
 			break;
 		case KVM_REG_PPC_VSCR:
 			if (!cpu_has_feature(CPU_FTR_ALTIVEC)) {
 				r = -ENXIO;
 				break;
 			}
-			val = get_reg_val(reg->id, vcpu->arch.vr.vscr.u[3]);
+			val = get_reg_val(reg->id, kvmppc_get_vscr(vcpu));
 			break;
 		case KVM_REG_PPC_VRSAVE:
 			val = get_reg_val(reg->id, vcpu->arch.vrsave);
@@ -1770,14 +1770,14 @@ int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 				r = -ENXIO;
 				break;
 			}
-			vcpu->arch.vr.vr[reg->id - KVM_REG_PPC_VR0] = val.vval;
+			kvmppc_set_vsx_vr(vcpu, reg->id - KVM_REG_PPC_VR0, &val.vval);
 			break;
 		case KVM_REG_PPC_VSCR:
 			if (!cpu_has_feature(CPU_FTR_ALTIVEC)) {
 				r = -ENXIO;
 				break;
 			}
-			vcpu->arch.vr.vscr.u[3] = set_reg_val(reg->id, val);
+			kvmppc_set_vscr(vcpu, set_reg_val(reg->id, val));
 			break;
 		case KVM_REG_PPC_VRSAVE:
 			if (!cpu_has_feature(CPU_FTR_ALTIVEC)) {
-- 
2.39.3

