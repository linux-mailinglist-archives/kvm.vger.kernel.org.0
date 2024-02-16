Return-Path: <kvm+bounces-8863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E47857900
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 10:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ACEC1C227BE
	for <lists+kvm@lfdr.de>; Fri, 16 Feb 2024 09:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8199A1CAB1;
	Fri, 16 Feb 2024 09:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b="Ulvq/xe6"
X-Original-To: kvm@vger.kernel.org
Received: from mailbox.box.xen0n.name (mail.xen0n.name [115.28.160.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805951BF47;
	Fri, 16 Feb 2024 09:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.28.160.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708076298; cv=none; b=Ubm4k+EfiTcwstoZWh13wAQ63DZ+z1/ANNMQfZPB8kHTih1X/usC6xSzqKIz80zYl3npsl8yyOizlxQFjkdDc3Q4ehL+FXTGpxgl6iKAGmEB5m+BWPHRjufiRZisE9l0WGl4OBnC97QLOck3Xsvf1X9rMIOuh2KjfSkcMOeF/WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708076298; c=relaxed/simple;
	bh=2gDw0o66DflpWYG/Gy8TCph2SB91NzGgN6Z10TivAUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSj2IoCC5Z8/v2unUAO3j3MdEF1teaZw7vvqTRcMU8KU2k6TayUWn5uMFJ48UPU614q1LRj16V0Y/8zOprtdAQeJ8RLFaY73QOSC9zejw0Dt1bWcHG/tzEsVwONhQytrguLba2MCrB1DIPrnAaF3CgMRDZTeI+i+DCD4ty2rQb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name; spf=pass smtp.mailfrom=xen0n.name; dkim=pass (1024-bit key) header.d=xen0n.name header.i=@xen0n.name header.b=Ulvq/xe6; arc=none smtp.client-ip=115.28.160.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xen0n.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xen0n.name
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xen0n.name; s=mail;
	t=1708076292; bh=2gDw0o66DflpWYG/Gy8TCph2SB91NzGgN6Z10TivAUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ulvq/xe6cFTI8BwAFq0qNG5RRJDH/Y5KfG0hNR+0SLrn7PeldaNl13frJGtctTvxa
	 4abex99Is7H4g0WLJHBr7sO2yztEjCnTxSTTWCJWuRiC2Hmeuk3QL5eAju+X7vqhcE
	 Oe03bg/ZhJUVxnEmXcqf8lksMfnmNCfeJdWG7T/Q=
Received: from ld50.lan (unknown [IPv6:240e:388:8d00:6500:cda4:aa27:b0f6:1748])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mailbox.box.xen0n.name (Postfix) with ESMTPSA id 9404E601C2;
	Fri, 16 Feb 2024 17:38:12 +0800 (CST)
From: WANG Xuerui <kernel@xen0n.name>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	kvm@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	WANG Xuerui <git@xen0n.name>
Subject: [PATCH RESEND for-6.8 v3 3/3] LoongArch: KVM: Streamline kvm_check_cpucfg and improve comments
Date: Fri, 16 Feb 2024 17:37:59 +0800
Message-ID: <20240216093759.3038760-4-kernel@xen0n.name>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240216093759.3038760-1-kernel@xen0n.name>
References: <20240216093759.3038760-1-kernel@xen0n.name>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: WANG Xuerui <git@xen0n.name>

All the checks currently done in kvm_check_cpucfg can be realized with
early returns, so just do that to avoid extra cognitive burden related
to the return value handling.

While at it, clean up comments of _kvm_get_cpucfg_mask and
kvm_check_cpucfg, by removing comments that are merely restatement of
the code nearby, and paraphrasing the rest so they read more natural
for English speakers (that likely are not familiar with the actual
Chinese-influenced grammar).

No functional changes intended.

Signed-off-by: WANG Xuerui <git@xen0n.name>
---
 arch/loongarch/kvm/vcpu.c | 42 +++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
index e5acd4c08071..a241db6d77a6 100644
--- a/arch/loongarch/kvm/vcpu.c
+++ b/arch/loongarch/kvm/vcpu.c
@@ -302,20 +302,16 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
 {
 	switch (id) {
 	case 2:
-		/* Return CPUCFG2 features which have been supported by KVM */
+		/* CPUCFG2 features unconditionally supported by KVM */
 		*v = CPUCFG2_FP     | CPUCFG2_FPSP  | CPUCFG2_FPDP     |
 		     CPUCFG2_FPVERS | CPUCFG2_LLFTP | CPUCFG2_LLFTPREV |
 		     CPUCFG2_LAM;
 		/*
-		 * If LSX is supported by CPU, it is also supported by KVM,
-		 * as we implement it.
+		 * For the ISA extensions listed below, if one is supported
+		 * by the host, then it is also supported by KVM.
 		 */
 		if (cpu_has_lsx)
 			*v |= CPUCFG2_LSX;
-		/*
-		 * if LASX is supported by CPU, it is also supported by KVM,
-		 * as we implement it.
-		 */
 		if (cpu_has_lasx)
 			*v |= CPUCFG2_LASX;
 
@@ -345,24 +341,26 @@ static int kvm_check_cpucfg(int id, u64 val)
 
 	switch (id) {
 	case 2:
-		/* CPUCFG2 features checking */
 		if (!(val & CPUCFG2_LLFTP))
-			/* The LLFTP must be set, as guest must has a constant timer */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
-			/* Single and double float point must both be set when enable FP */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
-			/* FP should be set when enable LSX */
-			ret = -EINVAL;
-		else if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
-			/* LSX, FP should be set when enable LASX, and FP has been checked before. */
-			ret = -EINVAL;
-		break;
+			/* Guests must have a constant timer */
+			return -EINVAL;
+		if ((val & CPUCFG2_FP) && (!(val & CPUCFG2_FPSP) || !(val & CPUCFG2_FPDP)))
+			/* Single and double float point must both be set when FP is enabled */
+			return -EINVAL;
+		if ((val & CPUCFG2_LSX) && !(val & CPUCFG2_FP))
+			/* LSX architecturally implies FP but val does not satisfy that */
+			return -EINVAL;
+		if ((val & CPUCFG2_LASX) && !(val & CPUCFG2_LSX))
+			/* LASX architecturally implies LSX and FP but val does not satisfy that */
+			return -EINVAL;
+		return 0;
 	default:
-		break;
+		/*
+		 * Values for the other CPUCFG IDs are not being further validated
+		 * besides the mask check above.
+		 */
+		return 0;
 	}
-	return ret;
 }
 
 static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
-- 
2.43.0


