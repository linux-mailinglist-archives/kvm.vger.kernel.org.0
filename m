Return-Path: <kvm+bounces-22467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A1693E8AB
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 18:50:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 941BD28171D
	for <lists+kvm@lfdr.de>; Sun, 28 Jul 2024 16:50:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C960B6F30B;
	Sun, 28 Jul 2024 16:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e+vykUJi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C97A6F2E0
	for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722185439; cv=none; b=AhoGYt/r19Fuoc8ZyhDRLYSp1ZwQjqm23Cq8MVwJqrgm3jNSv4O8Rru358RGMvnGLktwUNLdG+ZTXpTpJqmfflYWt3UtTHV6hn+YJK04+rKhEawm9CffW9/rfjbBDATrcw+DMmHAD99zyU4L0uBgqhwWTfrq98wSwWK8peL+NbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722185439; c=relaxed/simple;
	bh=XRJl/uPgbWvSt8YMeQOUC5JnzlykeY0IhpbgHZkzhCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2dTWOz4xde9ESy4fq4ESuk9UTbMQ/vFH8Af5fNfzGqTzZ9zqAKP9WdaEdnt4S+NuvsoDbCmd5qL6emOR7MEBaV6Ej07Z8U2Q5dRVZFqerOKcZkkXjSXF62fYj65FgUxaBeEWcLN3Hb8OAZNxk/mBcnL8AqSu9JmdFIfO6RHE5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e+vykUJi; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fc569440e1so20722915ad.3
        for <kvm@vger.kernel.org>; Sun, 28 Jul 2024 09:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722185436; x=1722790236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEiXZ1Hftnd13V7cSXtmzxOOQFtbwN2az/SPk33hWyc=;
        b=e+vykUJiowodE0mz8UzFLoulH4q1PGD+90b1lRsvuOLoinYjJoExY8Y8skif3nN/0+
         cP1U/PVejTriIWuLnws9GpZ15MQmNiqAuTVsD2wEtABa6ZJOauNMKoiVVc5Zwjh6hrEI
         lH7TsOcTvmFh0bhklEW2XTHe99Jsu/FrKFaBwG7Uu3NjDYOec6UtCnTHO2EbvniMGf36
         CFxvV5ko16OzmggH3W7lf6tCsyGh1Noadln0yX+7AWqNrUi9QbYAcMZz/rzIKtctgEMt
         +CCfvXuHrpVB4LPusSYhhWLUpvfU8fOdQsh1goPWSow8XEEEvniQsO3oWc85e8zWRjTn
         auPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722185436; x=1722790236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEiXZ1Hftnd13V7cSXtmzxOOQFtbwN2az/SPk33hWyc=;
        b=D5Yk9jQAM0Z9qY6kRQJ7gjXjZpySay+dvB+CS57/8wUP/cXgbtnn5RZZfWMvuaw+cP
         CkHF7dyBDC7IRqtVvxZL7q/+wz0YDEA6N/2Kz+NJFxlBg8KCDRsiYpXkAdaLfCiZoimU
         +eKoUDxEZtsPhbbE0JzTPAK1uuNkAqtwuoz00gzia/2jUZ9YpYW6Qha6tlXA6vOcCBd7
         eqOO0/IBZY5iXyO0thxe4YqPsLo+l+smZz43AGhr0pkoML4pzgqhQf0WvOCLkW3GcKGT
         W5Ix3jzKTjPMye3yVIRtm+6s/m/FW2kCB7KI21OUx1PtRygMvdZC6fJXh30ZCLDLkvXT
         lbJA==
X-Gm-Message-State: AOJu0YzeHSetaGQkyf5DcrkZGSXoGHMPA5b2+dXC6WVIPqwyNeVgXzFj
	mkfPrPXqVT3WFD43HjjKS3CnYKATAIqBFb5Qp6BslPEDxsIWsujaLoJK6zBWtio=
X-Google-Smtp-Source: AGHT+IGEE725G2chsjeyL29DACmq+1GFpgRJnqRTT1ifMi62MPfDn9z5FD0POiYJZZ8jiOJUdwaa9Q==
X-Received: by 2002:a17:903:190:b0:1fd:9420:1044 with SMTP id d9443c01a7336-1ff04817e13mr62739745ad.16.1722185436090;
        Sun, 28 Jul 2024 09:50:36 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cf28c7b0besm6969413a91.14.2024.07.28.09.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jul 2024 09:50:35 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v5 3/5] riscv: Add method to probe for SBI extensions
Date: Mon, 29 Jul 2024 00:50:20 +0800
Message-ID: <20240728165022.30075-4-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240728165022.30075-1-jamestiotio@gmail.com>
References: <20240728165022.30075-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a `sbi_probe` helper method that can be used by SBI extension tests
to check if a given extension is available.

Suggested-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h |  1 +
 lib/riscv/sbi.c     | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index d82a384d..5e1a674a 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -49,6 +49,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 
 void sbi_shutdown(void);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
+long sbi_probe(int ext);
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMRISCV_SBI_H_ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index f39134c4..3d4236e5 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -38,3 +38,16 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
 {
 	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
 }
+
+long sbi_probe(int ext)
+{
+	struct sbiret ret;
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_GET_SPEC_VERSION, 0, 0, 0, 0, 0, 0);
+	assert(!ret.error && ret.value >= 2);
+
+	ret = sbi_ecall(SBI_EXT_BASE, SBI_EXT_BASE_PROBE_EXT, ext, 0, 0, 0, 0, 0);
+	assert(!ret.error);
+
+	return ret.value;
+}
-- 
2.43.0


