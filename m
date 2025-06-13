Return-Path: <kvm+bounces-49378-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77BFCAD8375
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 08:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 640027AE1D9
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 06:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0D925DAF4;
	Fri, 13 Jun 2025 06:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="JhBtF9N2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17BF25D54A
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 06:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749797900; cv=none; b=Fsq3ZZ6sTt2crm7G79/cY2IZTynm2Tcaqfpr8qXPSoYR2AFL1Ffndj2hDiJMGQP+c4vDoJ3gjlGu35tr8U80AtQ2NJ53mUBr1HeG7VVxokoMsNVzxcM+813EH/py/mpvyaeqyGVj/Ioe3Vkw7I9xZp0svyTBwWy27C07f5LYXV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749797900; c=relaxed/simple;
	bh=N1Q7Yyxv25kh8YbbPEq1f4Xpl9cPz/xmC60ZF02nnis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YeKyZqq/VzE8hHUU9K4lQhzLn9TiMqsolDgHfZ7vAShNHdU0LVddpJbTvqe2quEEs1XtevDoDFt9dqSg+3FhpLSuNVsnHm+W6oe2AqOzbL7DltRf90e+TQPr2xE+dXFwjuJ1d844PyJhK6/03GwbtB2Uuzsnd4/4jTzatsX6fQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=JhBtF9N2; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-31329098ae8so1578363a91.1
        for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 23:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1749797898; x=1750402698; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vPp46eZSp7JL4MdOWPUs+dW6gfTxSrmGdnYXz+FMAYQ=;
        b=JhBtF9N2FLyRy6kJaLSipSLeBzJr5/v+eVEOXiOAbvdrDeLkZaVgOe/lUcT1Ddl9vn
         yU/NZ09DuwNG3J3DcJkbMXinrYUpS1+my77++y8hgOE4TWf888P5nYp66mvW3VPPZsw5
         /EuM67m06U4zQzH2nq/boh3UQR+S4XTfGBhMdJRkxMryrHRkiNi6bWLXP0ChiBqeQ2Xj
         I2s17Si7ezP9oJWc5Bz+/5hswj7XoIFSDMDFtpxPeXoReOcpN2q0ZCzkqazVlWkVVjX1
         eVja8zu9IwoCc36OXYmoaOGuVxfYuOmL6WSB8ahr1aJaKlJeooFOi6dkddwYLj08+ARQ
         YY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749797898; x=1750402698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vPp46eZSp7JL4MdOWPUs+dW6gfTxSrmGdnYXz+FMAYQ=;
        b=WsLZn8WTiCUTVYMNW3CZsyMZNk2E4hjkJ7j263ZfOyYzr45XibK9KT7X1Muu6TgVQ3
         KN5FPgZaXTxv1PbzU21VPeQmWyp3kPouikKWbIsFN7Y6mHFY0SuMAdS0atptmYGYwfMr
         2tVxRdJcLiZUcC9cJ2n6LkxrfndGd5pl2CoeN8M+yz37qs1TGz6KPSzXzhJhRWweEX06
         UNrrC9/YGQQ8WGkKBTUqd8S3CevB53l/Cu3Wg39urkrlB6o3UlNUgtKuEp1cnMAcuL4Q
         v3rjKw2ZzQzkq0sG7STjr2tCpAxg7ZnAlj4KNCGVAzpuPTdXTnqFBTXyuzjDSs83Evyf
         5oyg==
X-Forwarded-Encrypted: i=1; AJvYcCUBcuI7j5AH0JbZPJ7q3QRk9mpkIiW8Cd3LtkdAq80oaQyU5YG4Wom1Fns8BbOQ0l0Kq98=@vger.kernel.org
X-Gm-Message-State: AOJu0YzM5MMQK1QgoiMQLhJAttHK4MaoQuam3kX68X3Tdiox7xmKhJ8Z
	qLrH7pZ6Xu/5c9YmYG5sSUhQwW47dsN1Irdip7v67W6BoAmTTWeiqXV6zewHK3pOSJs=
X-Gm-Gg: ASbGncviDTN8JIkmvH/pLd2TotJwn7RaNMbpOY56PGrhrkLIydlYn4y6gc3NQi0Yjk3
	QrAmkPqGCzZvzTPqF9lFnCn/qfh0sAltHNeLPa8io4QYpDSOv5f4gBdx3UN9s6OnUOr7N11PF9b
	CiskCYDI+ZA1ADKPuv7InNJbv5pMNYdzpZHO7NS37be3PhhIHFf5rNnOB+zyK+VkYEcly/3Qg+g
	9t98+AiTHzPqv3YApVMnxOsQdItvKdqDGveg7+FgVa7+nUCV0KpDuhl10KnHmydGYuERtp0djAD
	ue+E2kgZUqiVZ0Y4Ef+ayCXWHmlS1mflL0Y1sLsvEEcG5crf6t9poYpiy5MoE7sv7PF9gPYKRXG
	nes0bF0SzGRIYWIvA/r8=
X-Google-Smtp-Source: AGHT+IHlesOh77cakTH2YhHv43j8zOza0rZEzGZ+37qo1i6wlvyL7TrOfPOjUkpSesJgnyG08PjCmA==
X-Received: by 2002:a17:90b:1256:b0:311:abba:53b6 with SMTP id 98e67ed59e1d1-313dc25631cmr1682026a91.14.1749797897914;
        Thu, 12 Jun 2025 23:58:17 -0700 (PDT)
Received: from localhost.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-313c1b49b7fsm2653022a91.24.2025.06.12.23.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jun 2025 23:58:17 -0700 (PDT)
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
Subject: [PATCH v2 05/12] RISC-V: KVM: Don't flush TLB when PTE is unchanged
Date: Fri, 13 Jun 2025 12:27:36 +0530
Message-ID: <20250613065743.737102-6-apatel@ventanamicro.com>
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

The gstage_set_pte() and gstage_op_pte() should flush TLB only when
a leaf PTE changes so that unnecessary TLB flushes can be avoided.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/mmu.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 1087ea74567b..29f1bd853a66 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -167,9 +167,11 @@ static int gstage_set_pte(struct kvm *kvm, u32 level,
 		ptep = &next_ptep[gstage_pte_index(addr, current_level)];
 	}
 
-	set_pte(ptep, *new_pte);
-	if (gstage_pte_leaf(ptep))
-		gstage_remote_tlb_flush(kvm, current_level, addr);
+	if (pte_val(*ptep) != pte_val(*new_pte)) {
+		set_pte(ptep, *new_pte);
+		if (gstage_pte_leaf(ptep))
+			gstage_remote_tlb_flush(kvm, current_level, addr);
+	}
 
 	return 0;
 }
@@ -229,7 +231,7 @@ static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
 			  pte_t *ptep, u32 ptep_level, enum gstage_op op)
 {
 	int i, ret;
-	pte_t *next_ptep;
+	pte_t old_pte, *next_ptep;
 	u32 next_ptep_level;
 	unsigned long next_page_size, page_size;
 
@@ -258,11 +260,13 @@ static void gstage_op_pte(struct kvm *kvm, gpa_t addr,
 		if (op == GSTAGE_OP_CLEAR)
 			put_page(virt_to_page(next_ptep));
 	} else {
+		old_pte = *ptep;
 		if (op == GSTAGE_OP_CLEAR)
 			set_pte(ptep, __pte(0));
 		else if (op == GSTAGE_OP_WP)
 			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
-		gstage_remote_tlb_flush(kvm, ptep_level, addr);
+		if (pte_val(*ptep) != pte_val(old_pte))
+			gstage_remote_tlb_flush(kvm, ptep_level, addr);
 	}
 }
 
-- 
2.43.0


