Return-Path: <kvm+bounces-29515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A38BE9ACB17
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 15:22:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B25E1F21FC1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 13:22:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5438C1B4F07;
	Wed, 23 Oct 2024 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="puXWbn4x"
X-Original-To: kvm@vger.kernel.org
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1541AE018
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 13:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689708; cv=none; b=Dg5u+W7w8E2lB/bVfu5ENU613ThquPHaTT6NkognzxINW0aOKb+fkBmHu5OpjyUhjaGuFbAKVkZsCHHB+THK1Nk4LbVND5vZIkILN7dRIrwxKMe060WLmaqXqELI/Jo4jaHScwL7xgPAUfpX6Ssg3bPvvrVFkAPJM+L5KlaoqRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689708; c=relaxed/simple;
	bh=uGy2Tdom1P6MSr0n5d/7evDoV1fqiacc+jFCAfkZUJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHAZgG8nT3ng6gvIM7cVnWMRH7DuXLMvSO7h2Xf2CGx9OGhW+D/DCAhpoJt6Hs3RZ0OQMK5/I08ullmd1RwvcZDuobRhWPgGbaz4Vevdlc38EUpxiddkpN0g/iYgwvNpslp2sC1bx5Scu4Re+qKOREmtT62R5FBi8znYEQtnn0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=puXWbn4x; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729689705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b5ln1rtoJpJgmzh9v/JiEP0bJ5A/bzOlNsyfFTmukE8=;
	b=puXWbn4xIhdKnF680eXYpH/Za5XvN8PIQP1A+r4RVPvZLOXs+bUNevUYLEIxJRdF6zb/76
	YFSi7aYuhCD6TWaHY7FzEFkxgl20VPJdsL0le6JkO4osu1xFcilwK2XaN3YOjjkfoDvAat
	GGNVSx/KORH+vr2TCIhJL4DlzMHAP24=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: atishp@rivosinc.com,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 3/4] riscv: Fix secondary_entry
Date: Wed, 23 Oct 2024 15:21:34 +0200
Message-ID: <20241023132130.118073-9-andrew.jones@linux.dev>
In-Reply-To: <20241023132130.118073-6-andrew.jones@linux.dev>
References: <20241023132130.118073-6-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The last few instructions of secondary_entry had the right concept,
but were the totally wrong implementation. Without setting ra, then,
when the boot function doesn't stay in an infinite loop, like
do_idle() would, we'd go off into the weeds when trying to return
from it. Make sure we set ra to come back to where we can then call
do_idle() instead. The bug was found by inspection since nobody is
calling smp_boot_secondary() with anything other than do_idle() at
this time.

Fixes: 9c92b28e6b7b ("riscv: Add SMP support")
Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 riscv/cstart.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/riscv/cstart.S b/riscv/cstart.S
index bae1d2f5b4d5..687173706d83 100644
--- a/riscv/cstart.S
+++ b/riscv/cstart.S
@@ -154,9 +154,9 @@ secondary_entry:
 	mv	a0, sp
 	call	secondary_cinit
 	addi	sp, sp, SECONDARY_DATA_SIZE
-	jr	a0
-	la	a0, do_idle
-	jr	a0
+	jalr	ra, a0
+	call	do_idle
+	j	.	/* unreachable */
 
 /*
  * Save context to address in a0.
-- 
2.47.0


