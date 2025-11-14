Return-Path: <kvm+bounces-63153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 545E5C5ACD6
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1E708349F46
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 00:38:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A69283FC4;
	Fri, 14 Nov 2025 00:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UyfzhDGz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD47266B46
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 00:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763080607; cv=none; b=ZvYE7olvxIdIV0tWbY14ooJD74gEuAsc+NSRiX4FgkOQYV5fGPYsbmIJs6vIh7bPVf6jJEsCrkvwtIOnh+XajoNqEFL9x7ditk6TSJDBhxjjGn3vZSbiBAq+oZ3nszAJ6mshBPZqLF91jPxZC78NqCXzPEzPgAxBGIMNTwF2Uqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763080607; c=relaxed/simple;
	bh=wZgjyUuJ4bKtSipCRhvvXuowUWE5I6Lbx5mstw8ju/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBcRxZoXiVPrYVibqedFT+lS9TaYAtgKipR9WX99kWlMNtDZbRzITvVLhIPixa9AcLLpVlyjyw4mGMBEeVyzmByJePBPdbo1cyVLAzuDjVYJrC+DXjq6/2ltigyxm+TZ/xzOnfMahqjhrRtthX74bFfhPerNp016LEtkgxLJ63s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UyfzhDGz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763080605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jNpw6akGzzgzwPATGL5Lsbuz5AzDxpwxXI42+6d44EY=;
	b=UyfzhDGzwD8LB3RsbpJIsneDWC82eJWqjJpwj3WIHqfEmTbMkJ1uWqIhSCfhLGJVSGijSA
	iB4IZQYehLCQQYofVIQRo3tOzEejjcQt3tFnglBVAAvlQ8G2qoQsHaoIFCGK2r41qI+SbU
	GNDC10qWHTCnqEbmsiEukV6+XPsyumQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-328-ys94N6ihO9mUxr3M41_6mQ-1; Thu,
 13 Nov 2025 19:36:39 -0500
X-MC-Unique: ys94N6ihO9mUxr3M41_6mQ-1
X-Mimecast-MFC-AGG-ID: ys94N6ihO9mUxr3M41_6mQ_1763080598
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87CEC1956096;
	Fri, 14 Nov 2025 00:36:38 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F297419560B9;
	Fri, 14 Nov 2025 00:36:37 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kbusch@kernel.org,
	chang.seok.bae@intel.com
Subject: [PATCH 05/10] KVM: emulate: share common register decoding code
Date: Thu, 13 Nov 2025 19:36:28 -0500
Message-ID: <20251114003633.60689-6-pbonzini@redhat.com>
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

Remove all duplicate handling of register operands, including picking
the right register class and fetching it, by extracting a new function
that can be used for both REG and MODRM operands.

Centralize setting op->orig_val = op->val in fetch_register_operand()
as well.

No functional change intended.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 49 +++++++++++++++---------------------------
 1 file changed, 17 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 7ef791407dbc..6c8d3f786e74 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1026,6 +1026,7 @@ static void fetch_register_operand(struct operand *op)
 		op->val = *(u64 *)op->addr.reg;
 		break;
 	}
+	op->orig_val = op->val;
 }
 
 static int em_fninit(struct x86_emulate_ctxt *ctxt)
@@ -1071,16 +1072,9 @@ static int em_fnstsw(struct x86_emulate_ctxt *ctxt)
 	return X86EMUL_CONTINUE;
 }
 
-static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
-				    struct operand *op)
+static void __decode_register_operand(struct x86_emulate_ctxt *ctxt,
+				      struct operand *op, int reg)
 {
-	unsigned int reg;
-
-	if (ctxt->d & ModRM)
-		reg = ctxt->modrm_reg;
-	else
-		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
-
 	if (ctxt->d & Sse) {
 		op->type = OP_XMM;
 		op->bytes = 16;
@@ -1099,9 +1093,20 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 	op->type = OP_REG;
 	op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 	op->addr.reg = decode_register(ctxt, reg, ctxt->d & ByteOp);
-
 	fetch_register_operand(op);
-	op->orig_val = op->val;
+}
+
+static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
+				    struct operand *op)
+{
+	unsigned int reg;
+
+	if (ctxt->d & ModRM)
+		reg = ctxt->modrm_reg;
+	else
+		reg = (ctxt->b & 7) | ((ctxt->rex_prefix & 1) << 3);
+
+	__decode_register_operand(ctxt, op, reg);
 }
 
 static void adjust_modrm_seg(struct x86_emulate_ctxt *ctxt, int base_reg)
@@ -1128,24 +1133,7 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 	ctxt->modrm_seg = VCPU_SREG_DS;
 
 	if (ctxt->modrm_mod == 3 || (ctxt->d & NoMod)) {
-		op->type = OP_REG;
-		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
-		op->addr.reg = decode_register(ctxt, ctxt->modrm_rm,
-				ctxt->d & ByteOp);
-		if (ctxt->d & Sse) {
-			op->type = OP_XMM;
-			op->bytes = 16;
-			op->addr.xmm = ctxt->modrm_rm;
-			kvm_read_sse_reg(ctxt->modrm_rm, &op->vec_val);
-			return rc;
-		}
-		if (ctxt->d & Mmx) {
-			op->type = OP_MM;
-			op->bytes = 8;
-			op->addr.mm = ctxt->modrm_rm & 7;
-			return rc;
-		}
-		fetch_register_operand(op);
+		__decode_register_operand(ctxt, op, ctxt->modrm_rm);
 		return rc;
 	}
 
@@ -4619,14 +4607,12 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		op->bytes = (ctxt->d & ByteOp) ? 1 : ctxt->op_bytes;
 		op->addr.reg = reg_rmw(ctxt, VCPU_REGS_RAX);
 		fetch_register_operand(op);
-		op->orig_val = op->val;
 		break;
 	case OpAccLo:
 		op->type = OP_REG;
 		op->bytes = (ctxt->d & ByteOp) ? 2 : ctxt->op_bytes;
 		op->addr.reg = reg_rmw(ctxt, VCPU_REGS_RAX);
 		fetch_register_operand(op);
-		op->orig_val = op->val;
 		break;
 	case OpAccHi:
 		if (ctxt->d & ByteOp) {
@@ -4637,7 +4623,6 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 		op->bytes = ctxt->op_bytes;
 		op->addr.reg = reg_rmw(ctxt, VCPU_REGS_RDX);
 		fetch_register_operand(op);
-		op->orig_val = op->val;
 		break;
 	case OpDI:
 		op->type = OP_MEM;
-- 
2.43.5



