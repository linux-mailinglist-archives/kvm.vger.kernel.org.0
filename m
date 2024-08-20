Return-Path: <kvm+bounces-24669-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 940E19590DE
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 01:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D3F32850AF
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 23:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75AE91C8FAA;
	Tue, 20 Aug 2024 23:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="PKJvkQ+p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B70219E0
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 23:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724195081; cv=none; b=uuBArEGLb2YeuMGEwgeGJMexIMSydGGnd0OJ1WpnDBYehbrdLY15vyIu65+7SwXe8yWLtH0vn2T4ykDuO4IFyWGh/KLb0uw5xsP9E3O+RP7sNqjO0u2IaDfTUiX2+o6NkAr/tiuMACYiTPaR2g+GxR82rlkW4minguW03EcrFG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724195081; c=relaxed/simple;
	bh=SroR5M+LOjNOg0gYAdSIeJH7RaSWRQK0ZHLR3FofWVc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iQQR3OsnTKyoKyqHcmSWjafCPv5d4KVlKk2NqU/iSD84dnCrkaGiIMXsHeR92cN2w+t1e7xChAPR1DcjjeymGWCnuVYzvwsdE0paFXVzLFhvSRZkq4YA1Yaw0C5WXu/uIMww9LwLVY5ZFgJ3qIddBRjX4CXfJmsy10vbWmmBroI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=PKJvkQ+p; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47KLx8o9004506
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 16:04:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding:content-type; s=s2048-2021-q4; bh=Y3V
	mxUfnel9yF0bKq/RVBlpfzPEicGFKUa52i8XUMDQ=; b=PKJvkQ+pJbG/zRhv02F
	AjXlbrIZa62rHLXXzd0bI+bFKpdqJDmES9tZXDPxlWI+zJKVoEFZ8niuUpphik9U
	D1Z/VAHw+DvRzDkWpVPpY4gxs+WFGCbK7xNFLmTPwY461g9lwHuesndpBLYMqigV
	YLdFQPFvAtvX4qkuFPcT+NZQqUkilApa2LbfBKu2yJqH8xS73aOOvILN7ODmR/5V
	SYuAvbysWHVwC6jSoNZLzsRdw5NEYoK5XjYp/XYIJoPqFrTtCBuulWyGL4vB1deC
	+egjg0hKgOAzBnhsbNHCCy71rHI3aDb9R2zLoI5XbN52O+1iDKmkwOb4C55oT4g2
	gXA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4153hmgae9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 20 Aug 2024 16:04:38 -0700 (PDT)
Received: from twshared30099.05.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.11; Tue, 20 Aug 2024 23:04:34 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 60F5C120702FE; Tue, 20 Aug 2024 16:04:31 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <kvm@vger.kernel.org>
CC: <x86@kernel.org>, Keith Busch <kbusch@kernel.org>,
        Alex Williamson
	<alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Xu Liu
	<liuxu@meta.com>
Subject: [PATCH RFC] kvm: emulate avx vmovdq
Date: Tue, 20 Aug 2024 16:04:31 -0700
Message-ID: <20240820230431.3850991-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: VJhqWtgKt1mmt8zE7qaTyhBdLh1e9NPs
X-Proofpoint-GUID: VJhqWtgKt1mmt8zE7qaTyhBdLh1e9NPs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-20_17,2024-08-19_03,2024-05-17_01

From: Keith Busch <kbusch@kernel.org>

Because people would like to use this (see "Link"), interpret the VEX
prefix and emulate mov instrutions accordingly. The only avx
instructions emulated here are the aligned and unaligned mov.
Everything else will fail as before.

This is new territory for me, so any feedback is appreciated.

To test, I executed the following program against a qemu emulated pci
device resource. Prior to this kernel patch, it would fail with

  traps: vmovdq[378] trap invalid opcode ip:4006b2 sp:7ffe2f5bb680 error:=
0 in vmovdq[6b2,400000+1000]

And is successful with this kernel patch.

Test program, vmovdq.c:

  #include <x86intrin.h>
  #include <fcntl.h>
  #include <stdint.h>
  #include <stdio.h>
  #include <string.h>
  #include <unistd.h>
  #include <sys/mman.h>

  static inline void read_avx_reg(__m256i *data)
  {
          asm("vmovdqu %%ymm0, %0" : "=3Dm"(*data));
  }

  static inline void write_avx_reg(const __m256i *data)
  {
          asm("vmovdqu %0, %%ymm0" : : "m"(*data));
  }

  int main(int argc, char **argv)
  {
          __m256i s, *d;
          void *map;
          int fd;

          if(argc < 2) {
                  fprintf(stderr, "usage: %s <resource-file>\n", argv[1])=
;
                  return 1;
          }

          fd =3D open(argv[1], O_RDWR | O_SYNC);
          if (fd < 0) {
                  fprintf(stderr, "failed to open %s\n", argv[1]);
                  return 1;
          }

          map =3D mmap(0, 0x1000, PROT_READ | PROT_WRITE, MAP_SHARED, fd,=
 0);
          if (map =3D=3D MAP_FAILED) {
                  fprintf(stderr, "failed to mmap %s\n", argv[1]);
                  return 1;

          }

          memset(&s, 0xd0, sizeof(s));
          d =3D (__m256i *)map;

          write_avx_reg(&s);
          read_avx_reg(d);

          write_avx_reg(d);
          read_avx_reg(&s);

          return 0;
  }

Link: https://lore.kernel.org/kvm/BD108C42-0382-4B17-B601-434A4BD038E7@fb=
.com/T/
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xu Liu <liuxu@meta.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 arch/x86/kvm/emulate.c     | 136 ++++++++++++++++++++++++++++++++-----
 arch/x86/kvm/fpu.h         |  62 +++++++++++++++++
 arch/x86/kvm/kvm_emulate.h |   6 +-
 3 files changed, 187 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index e72aed25d7212..aad8da15b6b77 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1144,6 +1144,19 @@ static void decode_register_operand(struct x86_emu=
late_ctxt *ctxt,
 	else
 		reg =3D (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
=20
+	if (ctxt->d & Avx) {
+		op->bytes =3D ctxt->op_bytes;
+		if (op->bytes =3D=3D 16) {
+			op->type =3D OP_XMM;
+			op->addr.xmm =3D reg;
+			kvm_read_sse_reg(reg, &op->vec_val);
+		} else {
+			op->type =3D OP_YMM;
+			op->addr.ymm =3D reg;
+			kvm_read_avx_reg(reg, &op->vec_val2);
+		}
+		return;
+	}
 	if (ctxt->d & Sse) {
 		op->type =3D OP_XMM;
 		op->bytes =3D 16;
@@ -1177,13 +1190,24 @@ static int decode_modrm(struct x86_emulate_ctxt *=
ctxt,
 			struct operand *op)
 {
 	u8 sib;
-	int index_reg, base_reg, scale;
+	int index_reg =3D 0, base_reg =3D 0, scale =3D 0;
 	int rc =3D X86EMUL_CONTINUE;
 	ulong modrm_ea =3D 0;
=20
-	ctxt->modrm_reg =3D ((ctxt->rex_prefix << 1) & 8); /* REX.R */
-	index_reg =3D (ctxt->rex_prefix << 2) & 8; /* REX.X */
-	base_reg =3D (ctxt->rex_prefix << 3) & 8; /* REX.B */
+	if (ctxt->vex_prefix[0]) {
+		if ((ctxt->vex_prefix[1] & 0x80) =3D=3D 0)  /* VEX._R */
+			ctxt->modrm_reg =3D 8;
+		if (ctxt->vex_prefix[0] =3D=3D 0xc4) {
+			if ((ctxt->vex_prefix[1] & 0x40) =3D=3D 0) /* VEX._X */
+				index_reg =3D 8;
+			if ((ctxt->vex_prefix[1] & 0x20) =3D=3D 0) /* VEX._B */
+				base_reg =3D 8;
+		}
+	} else {
+		ctxt->modrm_reg =3D ((ctxt->rex_prefix << 1) & 8); /* REX.R */
+		index_reg =3D (ctxt->rex_prefix << 2) & 8; /* REX.X */
+		base_reg =3D (ctxt->rex_prefix << 3) & 8; /* REX.B */
+	}
=20
 	ctxt->modrm_mod =3D (ctxt->modrm & 0xc0) >> 6;
 	ctxt->modrm_reg |=3D (ctxt->modrm & 0x38) >> 3;
@@ -1195,6 +1219,19 @@ static int decode_modrm(struct x86_emulate_ctxt *c=
txt,
 		op->bytes =3D (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.reg =3D decode_register(ctxt, ctxt->modrm_rm,
 				ctxt->d & ByteOp);
+		if (ctxt->d & Avx) {
+			op->bytes =3D ctxt->op_bytes;
+			if (op->bytes =3D=3D 16) {
+				op->type =3D OP_XMM;
+				op->addr.xmm =3D ctxt->modrm_rm;
+				kvm_read_sse_reg(ctxt->modrm_rm, &op->vec_val);
+			} else {
+				op->type =3D OP_YMM;
+				op->addr.ymm =3D ctxt->modrm_rm;
+				kvm_read_avx_reg(ctxt->modrm_rm, &op->vec_val2);
+			}
+			return rc;
+		}
 		if (ctxt->d & Sse) {
 			op->type =3D OP_XMM;
 			op->bytes =3D 16;
@@ -1808,6 +1845,9 @@ static int writeback(struct x86_emulate_ctxt *ctxt,=
 struct operand *op)
 	case OP_XMM:
 		kvm_write_sse_reg(op->addr.xmm, &op->vec_val);
 		break;
+	case OP_YMM:
+		kvm_write_avx_reg(op->addr.ymm, &op->vec_val2);
+		break;
 	case OP_MM:
 		kvm_write_mmx_reg(op->addr.mm, &op->mm_val);
 		break;
@@ -3232,7 +3272,7 @@ static int em_rdpmc(struct x86_emulate_ctxt *ctxt)
=20
 static int em_mov(struct x86_emulate_ctxt *ctxt)
 {
-	memcpy(ctxt->dst.valptr, ctxt->src.valptr, sizeof(ctxt->src.valptr));
+	memcpy(ctxt->dst.valptr, ctxt->src.valptr, ctxt->op_bytes);
 	return X86EMUL_CONTINUE;
 }
=20
@@ -4460,6 +4500,23 @@ static const struct opcode twobyte_table[256] =3D =
{
 	N, N, N, N, N, N, N, N, N, N, N, N, N, N, N, N
 };
=20
+static const struct gprefix pfx_avx_0f_6f_0f_7f =3D {
+	N, I(Avx | Aligned, em_mov), N, I(Avx | Unaligned, em_mov),
+};
+
+static const struct opcode avx_0f_table[256] =3D {
+	/* 0x00 - 0x5f */
+	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
+	/* 0x60 - 0x6F */
+	X8(N), X4(N), X2(N), N,
+	GP(SrcMem | DstReg | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
+	/* 0x70 - 0x7F */
+	X8(N), X4(N), X2(N), N,
+	GP(SrcReg | DstMem | ModRM | Mov, &pfx_avx_0f_6f_0f_7f),
+	/* 0x80 - 0xFF */
+	X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N), X16(N),
+};
+
 static const struct instr_dual instr_dual_0f_38_f0 =3D {
 	I(DstReg | SrcMem | Mov, em_movbe), N
 };
@@ -4724,6 +4781,41 @@ static int decode_operand(struct x86_emulate_ctxt =
*ctxt, struct operand *op,
 	return rc;
 }
=20
+static struct opcode x86_decode_avx(struct x86_emulate_ctxt *ctxt)
+{
+	u8 map, pp, l, v;
+
+	if (ctxt->vex_prefix[0] =3D=3D 0xc5) {
+		pp =3D ctxt->vex_prefix[1] & 0x3;	/* VEX.p1p0 */
+		l =3D ctxt->vex_prefix[1] & 0x4;	/* VEX.L */
+		v =3D ~((ctxt->vex_prefix[1] >> 3) & 0xf) & 0xf; /* VEX.v3v2v1v0 */
+		map =3D 1; /* for 0f map */
+		ctxt->opcode_len =3D 2;
+	} else {
+		map =3D ctxt->vex_prefix[1] & 0x1f;
+		pp =3D ctxt->vex_prefix[2] & 0x3;
+		l =3D ctxt->vex_prefix[2] & 0x4;
+		v =3D ~((ctxt->vex_prefix[2] >> 3) & 0xf) & 0xf;
+		ctxt->opcode_len =3D 3;
+	}
+
+	if (l)
+		ctxt->op_bytes =3D 32;
+	else
+		ctxt->op_bytes =3D 16;
+
+	switch (pp) {
+	case 0: ctxt->rep_prefix =3D 0x00; break;
+	case 1: ctxt->rep_prefix =3D 0x66; break;
+	case 2: ctxt->rep_prefix =3D 0xf3; break;
+	case 3: ctxt->rep_prefix =3D 0xf2; break;
+	}
+
+	if (map =3D=3D 1 && !v)
+		return avx_0f_table[ctxt->b];
+	return (struct opcode){.flags =3D NotImpl};
+}
+
 int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_=
len, int emulation_type)
 {
 	int rc =3D X86EMUL_CONTINUE;
@@ -4777,7 +4869,7 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, =
void *insn, int insn_len, int
 	ctxt->op_bytes =3D def_op_bytes;
 	ctxt->ad_bytes =3D def_ad_bytes;
=20
-	/* Legacy prefixes. */
+	/* prefixes. */
 	for (;;) {
 		switch (ctxt->b =3D insn_fetch(u8, ctxt)) {
 		case 0x66:	/* operand-size override */
@@ -4822,6 +4914,19 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt,=
 void *insn, int insn_len, int
 				goto done_prefixes;
 			ctxt->rex_prefix =3D ctxt->b;
 			continue;
+		case 0xc4: /* VEX */
+			if (mode !=3D X86EMUL_MODE_PROT64)
+				goto done_prefixes;
+			ctxt->vex_prefix[0] =3D ctxt->b;
+			ctxt->vex_prefix[1] =3D insn_fetch(u8, ctxt);
+			ctxt->vex_prefix[2] =3D insn_fetch(u8, ctxt);
+			break;
+		case 0xc5: /* VEX */
+			if (mode !=3D X86EMUL_MODE_PROT64)
+				goto done_prefixes;
+			ctxt->vex_prefix[0] =3D ctxt->b;
+			ctxt->vex_prefix[1] =3D insn_fetch(u8, ctxt);
+			break;
 		case 0xf0:	/* LOCK */
 			ctxt->lock_prefix =3D 1;
 			break;
@@ -4844,10 +4949,10 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt=
, void *insn, int insn_len, int
 	if (ctxt->rex_prefix & 8)
 		ctxt->op_bytes =3D 8;	/* REX.W */
=20
-	/* Opcode byte(s). */
-	opcode =3D opcode_table[ctxt->b];
-	/* Two-byte opcode? */
-	if (ctxt->b =3D=3D 0x0f) {
+	if (ctxt->vex_prefix[0]) {
+		opcode =3D x86_decode_avx(ctxt);
+	} else if (ctxt->b =3D=3D 0x0f) {
+		/* Two-byte opcode? */
 		ctxt->opcode_len =3D 2;
 		ctxt->b =3D insn_fetch(u8, ctxt);
 		opcode =3D twobyte_table[ctxt->b];
@@ -4858,18 +4963,16 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt=
, void *insn, int insn_len, int
 			ctxt->b =3D insn_fetch(u8, ctxt);
 			opcode =3D opcode_map_0f_38[ctxt->b];
 		}
+	} else {
+		/* Opcode byte(s). */
+		opcode =3D opcode_table[ctxt->b];
 	}
+
 	ctxt->d =3D opcode.flags;
=20
 	if (ctxt->d & ModRM)
 		ctxt->modrm =3D insn_fetch(u8, ctxt);
=20
-	/* vex-prefix instructions are not implemented */
-	if (ctxt->opcode_len =3D=3D 1 && (ctxt->b =3D=3D 0xc5 || ctxt->b =3D=3D=
 0xc4) &&
-	    (mode =3D=3D X86EMUL_MODE_PROT64 || (ctxt->modrm & 0xc0) =3D=3D 0xc=
0)) {
-		ctxt->d =3D NotImpl;
-	}
-
 	while (ctxt->d & GroupMask) {
 		switch (ctxt->d & GroupMask) {
 		case Group:
@@ -5091,6 +5194,7 @@ void init_decode_cache(struct x86_emulate_ctxt *ctx=
t)
 	/* Clear fields that are set conditionally but read without a guard. */
 	ctxt->rip_relative =3D false;
 	ctxt->rex_prefix =3D 0;
+	memset(ctxt->vex_prefix, 0, sizeof(ctxt->vex_prefix));;
 	ctxt->lock_prefix =3D 0;
 	ctxt->rep_prefix =3D 0;
 	ctxt->regs_valid =3D 0;
diff --git a/arch/x86/kvm/fpu.h b/arch/x86/kvm/fpu.h
index 3ba12888bf66a..9bc08c3c53f5d 100644
--- a/arch/x86/kvm/fpu.h
+++ b/arch/x86/kvm/fpu.h
@@ -15,6 +15,54 @@ typedef u32		__attribute__((vector_size(16))) sse128_t=
;
 #define sse128_l3(x)	({ __sse128_u t; t.vec =3D x; t.as_u32[3]; })
 #define sse128(lo, hi)	({ __sse128_u t; t.as_u64[0] =3D lo; t.as_u64[1] =
=3D hi; t.vec; })
=20
+typedef u32		__attribute__((vector_size(32))) avx256_t;
+
+static inline void _kvm_read_avx_reg(int reg, avx256_t *data)
+{
+	switch (reg) {
+	case 0:  asm("vmovdqa %%ymm0,  %0" : "=3Dm"(*data)); break;
+	case 1:  asm("vmovdqa %%ymm1,  %0" : "=3Dm"(*data)); break;
+	case 2:  asm("vmovdqa %%ymm2,  %0" : "=3Dm"(*data)); break;
+	case 3:  asm("vmovdqa %%ymm3,  %0" : "=3Dm"(*data)); break;
+	case 4:  asm("vmovdqa %%ymm4,  %0" : "=3Dm"(*data)); break;
+	case 5:  asm("vmovdqa %%ymm5,  %0" : "=3Dm"(*data)); break;
+	case 6:  asm("vmovdqa %%ymm6,  %0" : "=3Dm"(*data)); break;
+	case 7:  asm("vmovdqa %%ymm7,  %0" : "=3Dm"(*data)); break;
+	case 8:  asm("vmovdqa %%ymm8,  %0" : "=3Dm"(*data)); break;
+	case 9:  asm("vmovdqa %%ymm9,  %0" : "=3Dm"(*data)); break;
+	case 10: asm("vmovdqa %%ymm10, %0" : "=3Dm"(*data)); break;
+	case 11: asm("vmovdqa %%ymm11, %0" : "=3Dm"(*data)); break;
+	case 12: asm("vmovdqa %%ymm12, %0" : "=3Dm"(*data)); break;
+	case 13: asm("vmovdqa %%ymm13, %0" : "=3Dm"(*data)); break;
+	case 14: asm("vmovdqa %%ymm14, %0" : "=3Dm"(*data)); break;
+	case 15: asm("vmovdqa %%ymm15, %0" : "=3Dm"(*data)); break;
+	default: BUG();
+	}
+}
+
+static inline void _kvm_write_avx_reg(int reg, const avx256_t *data)
+{
+	switch (reg) {
+	case 0:  asm("vmovdqa %0, %%ymm0"  : : "m"(*data)); break;
+	case 1:  asm("vmovdqa %0, %%ymm1"  : : "m"(*data)); break;
+	case 2:  asm("vmovdqa %0, %%ymm2"  : : "m"(*data)); break;
+	case 3:  asm("vmovdqa %0, %%ymm3"  : : "m"(*data)); break;
+	case 4:  asm("vmovdqa %0, %%ymm4"  : : "m"(*data)); break;
+	case 5:  asm("vmovdqa %0, %%ymm5"  : : "m"(*data)); break;
+	case 6:  asm("vmovdqa %0, %%ymm6"  : : "m"(*data)); break;
+	case 7:  asm("vmovdqa %0, %%ymm7"  : : "m"(*data)); break;
+	case 8:  asm("vmovdqa %0, %%ymm8"  : : "m"(*data)); break;
+	case 9:  asm("vmovdqa %0, %%ymm9"  : : "m"(*data)); break;
+	case 10: asm("vmovdqa %0, %%ymm10" : : "m"(*data)); break;
+	case 11: asm("vmovdqa %0, %%ymm11" : : "m"(*data)); break;
+	case 12: asm("vmovdqa %0, %%ymm12" : : "m"(*data)); break;
+	case 13: asm("vmovdqa %0, %%ymm13" : : "m"(*data)); break;
+	case 14: asm("vmovdqa %0, %%ymm14" : : "m"(*data)); break;
+	case 15: asm("vmovdqa %0, %%ymm15" : : "m"(*data)); break;
+	default: BUG();
+	}
+}
+
 static inline void _kvm_read_sse_reg(int reg, sse128_t *data)
 {
 	switch (reg) {
@@ -109,6 +157,20 @@ static inline void kvm_fpu_put(void)
 	fpregs_unlock();
 }
=20
+static inline void kvm_read_avx_reg(int reg, avx256_t *data)
+{
+	kvm_fpu_get();
+	_kvm_read_avx_reg(reg, data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_write_avx_reg(int reg, const avx256_t  *data)
+{
+	kvm_fpu_get();
+	_kvm_write_avx_reg(reg, data);
+	kvm_fpu_put();
+}
+
 static inline void kvm_read_sse_reg(int reg, sse128_t *data)
 {
 	kvm_fpu_get();
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 55a18e2f2dcd9..0e12f187e0b57 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -239,7 +239,7 @@ struct x86_emulate_ops {
=20
 /* Type, address-of, and value of an instruction's operand. */
 struct operand {
-	enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_MM, OP_NONE } typ=
e;
+	enum { OP_REG, OP_MEM, OP_MEM_STR, OP_IMM, OP_XMM, OP_YMM, OP_MM, OP_NO=
NE } type;
 	unsigned int bytes;
 	unsigned int count;
 	union {
@@ -253,13 +253,16 @@ struct operand {
 			unsigned seg;
 		} mem;
 		unsigned xmm;
+		unsigned ymm;
 		unsigned mm;
 	} addr;
 	union {
 		unsigned long val;
 		u64 val64;
 		char valptr[sizeof(sse128_t)];
+		char valptr2[sizeof(avx256_t)];
 		sse128_t vec_val;
+		avx256_t vec_val2;
 		u64 mm_val;
 		void *data;
 	};
@@ -347,6 +350,7 @@ struct x86_emulate_ctxt {
=20
 	bool rip_relative;
 	u8 rex_prefix;
+	u8 vex_prefix[3];
 	u8 lock_prefix;
 	u8 rep_prefix;
 	/* bitmaps of registers in _regs[] that can be read */
--=20
2.43.5


