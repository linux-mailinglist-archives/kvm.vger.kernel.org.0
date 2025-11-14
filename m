Return-Path: <kvm+bounces-63149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C9AC5ACA3
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3A0014E6DBD
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:37:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393AA261B98;
	Fri, 14 Nov 2025 00:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oubw6EmQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C85A22B8CB
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080604; cv=none; b=FujVdmgADh3vXhk8Wp08r2S3OYtr8SaBlMvcFuhfkBkRlydnnSd28ARfCL72ZVxRasdmgjEWlnZHdA3shzrBax57M6qgNE639MxNFNgcWWJM4oPtnqRc4t1fKmwQVxASUqqPorSsaSJi4FTo3wLPViKZ7WDp1cPpSZkDQdhCoHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080604; c=relaxed/simple;
	bh=H5UKbvBsaxIf0pIYY6+pT0tB3zIufZLhUj0R+NVeyOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uJm0fpeWd6rin55w0sYFoQflfBlzp2Lt5N4eKw42MIj+Rz+hYTrOKvHPZdTwUlJ3Z8z7G+e2MKVAPTrySQBhiqp5zgUHmSHQlK6vMKFlswH9iPd8GBgUAR/MMebWePmbXze6z2zN7cXCdL66WFBahV2uOIp0SzUXdoEwnQG1qi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oubw6EmQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VKQmF1tUOZsKo3Jm2LZO5qVmWJK91z8FqVEr0r+L40o=;
	b=Oubw6EmQ7reEQCreIish2MWSpY0UHJI7KQXxBYKcvl26Dmon6oIZTxEYOLyQ/VllngSoDq
	LNKy0OEqDe2LQqhR9BOdJlJWA4mAM02TRXhuFr/xLN3vW2iYsRCDnJisPoML9AfceRDT9n
	ZqTxzSatl7m55cmNMlv2f5jsjc5QDto=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-CjyF-IB3Nw2iFO67UbPPfQ-1; Thu,
 13 Nov 2025 19:36:38 -0500
X-MC-Unique: CjyF-IB3Nw2iFO67UbPPfQ-1
X-Mimecast-MFC-AGG-ID: CjyF-IB3Nw2iFO67UbPPfQ_1763080597
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 196E0180048E;
	Fri, 14 Nov 2025 00:36:37 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 815BD19560B9;
	Fri, 14 Nov 2025 00:36:36 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 03/10] KVM: emulate: improve formatting of flags table
Date: Thu, 13 Nov 2025 19:36:26 -0500
Message-ID: <20251114003633.60689-4-pbonzini@redhat.com>
In-Reply-To: <20251114003633.60689-1-pbonzini@redhat.com>
References: <20251114003633.60689-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Align a little better the comments on the right side and list
explicitly the bits used by multi-bit fields.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 57799b5d9da2..28f81346878e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -81,9 +81,8 @@
  */
 
 /* Operand sizes: 8-bit operands or specified/overridden size. */
-#define ByteOp      (1<<0)	/* 8-bit operands. */
-/* Destination operand type. */
-#define DstShift    1
+#define ByteOp      (1<<0)      /* 8-bit operands. */
+#define DstShift    1           /* Destination operand type at bits 1-5 */
 #define ImplicitOps (OpImplicit << DstShift)
 #define DstReg      (OpReg << DstShift)
 #define DstMem      (OpMem << DstShift)
@@ -95,8 +94,7 @@
 #define DstDX       (OpDX << DstShift)
 #define DstAccLo    (OpAccLo << DstShift)
 #define DstMask     (OpMask << DstShift)
-/* Source operand type. */
-#define SrcShift    6
+#define SrcShift    6           /* Source operand type at bits 6-10 */
 #define SrcNone     (OpNone << SrcShift)
 #define SrcReg      (OpReg << SrcShift)
 #define SrcMem      (OpMem << SrcShift)
@@ -119,10 +117,10 @@
 #define SrcAccHi    (OpAccHi << SrcShift)
 #define SrcMask     (OpMask << SrcShift)
 #define BitOp       (1<<11)
-#define MemAbs      (1<<12)      /* Memory operand is absolute displacement */
+#define MemAbs      (1<<12)     /* Memory operand is absolute displacement */
 #define String      (1<<13)     /* String instruction (rep capable) */
 #define Stack       (1<<14)     /* Stack instruction (push/pop) */
-#define GroupMask   (7<<15)     /* Opcode uses one of the group mechanisms */
+#define GroupMask   (7<<15)     /* Group mechanisms, at bits 15-17 */
 #define Group       (1<<15)     /* Bits 3:5 of modrm byte extend opcode */
 #define GroupDual   (2<<15)     /* Alternate decoding of mod == 3 */
 #define Prefix      (3<<15)     /* Instruction varies with 66/f2/f3 prefix */
@@ -131,11 +129,8 @@
 #define InstrDual   (6<<15)     /* Alternate instruction decoding of mod == 3 */
 #define ModeDual    (7<<15)     /* Different instruction for 32/64 bit */
 #define Sse         (1<<18)     /* SSE Vector instruction */
-/* Generic ModRM decode. */
-#define ModRM       (1<<19)
-/* Destination is only written; never read. */
-#define Mov         (1<<20)
-/* Misc flags */
+#define ModRM       (1<<19)     /* Generic ModRM decode. */
+#define Mov         (1<<20)     /* Destination is only written; never read. */
 #define Prot        (1<<21) /* instruction generates #UD if not in prot-mode */
 #define EmulateOnUD (1<<22) /* Emulate if unsupported by the host */
 #define NoAccess    (1<<23) /* Don't access memory (lea/invlpg/verr etc) */
@@ -143,11 +138,10 @@
 #define Undefined   (1<<25) /* No Such Instruction */
 #define Lock        (1<<26) /* lock prefix is allowed for the instruction */
 #define Priv        (1<<27) /* instruction generates #GP if current CPL != 0 */
-#define No64	    (1<<28)
+#define No64        (1<<28)     /* Instruction generates #UD in 64-bit mode */
 #define PageTable   (1 << 29)   /* instruction used to write page table */
 #define NotImpl     (1 << 30)   /* instruction is not implemented */
-/* Source 2 operand type */
-#define Src2Shift   (32)       /* bits 32-36 */
+#define Src2Shift   (32)        /* Source 2 operand type at bits 32-36 */
 #define Src2None    (OpNone << Src2Shift)
 #define Src2Mem     (OpMem << Src2Shift)
 #define Src2CL      (OpCL << Src2Shift)
@@ -163,11 +157,12 @@
 #define Src2Mask    (OpMask << Src2Shift)
 /* free: 37-39 */
 #define Mmx         ((u64)1 << 40)  /* MMX Vector instruction */
-#define AlignMask   ((u64)7 << 41)
+#define AlignMask   ((u64)7 << 41)  /* Memory alignment requirement at bits 41-43 */
 #define Aligned     ((u64)1 << 41)  /* Explicitly aligned (e.g. MOVDQA) */
 #define Unaligned   ((u64)2 << 41)  /* Explicitly unaligned (e.g. MOVDQU) */
 #define Avx         ((u64)3 << 41)  /* Advanced Vector Extensions */
 #define Aligned16   ((u64)4 << 41)  /* Aligned to 16 byte boundary (e.g. FXSAVE) */
+/* free: 44 */
 #define NoWrite     ((u64)1 << 45)  /* No writeback */
 #define SrcWrite    ((u64)1 << 46)  /* Write back src operand */
 #define NoMod	    ((u64)1 << 47)  /* Mod field is ignored */
-- 
2.43.5



