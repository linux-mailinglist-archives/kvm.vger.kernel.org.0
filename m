Return-Path: <kvm+bounces-23812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 322BA94DDDB
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 19:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CB0E1C20D4B
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 17:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF61816C6BD;
	Sat, 10 Aug 2024 17:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgSKmtTa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAB116B725
	for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 17:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723312681; cv=none; b=UwF0LyKT5/spO7Z1htIe3WEE+K3svmaR65chy04DvPiCevu/mM4kqnUe4O3gXUQVPYYHrpXSQJrsgNqdxTgUzroNs/LrtxIu/51a2hIcZJJgEkZF1LcPsRR5HQpobdWueWN//a+TgjITZWVkdxmXCuLgqLquLAdxM59uxNCpH5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723312681; c=relaxed/simple;
	bh=BUcC+JZgnEVZKxOclKr73hShv0UQGwI+umJ+6AF1TN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ws8Uwd1rcUpS09lzinuROAJyCe/uU+OD+uXqf6OpMT7FrO86TRGFpucLKYucNnIgXtB/3W69cIc9x3fPHRMvzkITx1AnlEqZ1yfhvaBqs16TMU++ojRBm/mgQYYgvUuKoPARUCKwu6ky47x5AtYbHU+ewJaQw38X3wH1/zLCQ7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OgSKmtTa; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1fb3b7d0d56so18888825ad.1
        for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723312678; x=1723917478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1KdC7QAj8UGEG84hbd9Xp1hKDuMfF7N+5wk+gE4ItP4=;
        b=OgSKmtTadNTr/rNCZogEb8RDn90ltD2q+E4Ilq+tN1FH73hPJJ7Qh2xPs0HhydKTLy
         zQwxwdjfrxgiGFmkqzDGRC6ugZjD7L6HN0RdncJH9t+P2CSlJiwgFP5i1TbuNYDkTpf/
         zsILIIJ3okAHtxcvppgKn2BtqiRrGvBB6DvdX/N5HUWq3lMV68rsn2fqC0ceu0rchi5z
         ndupSVF5uEbTghcAfkWZPxdvrGo6f9eEmhziJvCWw4IX9qsbAx/WSvIMRtjnwOGditu1
         RW+c4ON/uPh/iKFLEcWr1qjsP6Fswfl1IZn5MRMsgU21qxHQF+lpLfDvPAXt+QRc8x1K
         y6IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723312678; x=1723917478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1KdC7QAj8UGEG84hbd9Xp1hKDuMfF7N+5wk+gE4ItP4=;
        b=uC92KC6zh/ZGIrSb2WwQT1H2hZzbIcUTr4d3RxOkgQjbVzEuTdpl2yFHNJVgSuplGP
         VDs4QPnETe9nWjuAV6hBPqFpMLdNlvfD1CTQ1h4D4UZO7vawZrxjM89iE5a/CQno6Z6W
         t4vgqqBtTE6QYmO+/PTTkgcQJOOGW9FpGhai5/+Y8ZSdLK+gIC2YTliyBtnTYHcvLim9
         GPY6V81EKp7kyebDMDpi1PCVSOGnICJOt124eeYDwMUMg44dpMnFtAtWepnV+g2wW6LQ
         x2IfjZaM9dh8CUnwITCjhtGIrDoXzI2sZexCWXnnGLjbGz1Ihzq/rlz/oPuk6+ni6b5e
         U1NA==
X-Gm-Message-State: AOJu0YweDWt6E3iVfITa1QFPS9A4XkeloJVtYe0ZXNYmGO1vLlcF9lVa
	WkgaFHQ+V1FvjZbrufMULByrCBGnKRw+vR+Amrnl6zNDzMxuZN/NmFdmc8PTTJE=
X-Google-Smtp-Source: AGHT+IHVrOypvYV1MW9vb2n9/bazOsa95hpYdfsNODJrlBTaVVFNlwkdx6r6kQGjx6HyQd5JH3CG2Q==
X-Received: by 2002:a17:903:11c3:b0:1fd:d6d8:1355 with SMTP id d9443c01a7336-200ae52c3e6mr56561595ad.17.1723312678278;
        Sat, 10 Aug 2024 10:57:58 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8fd807sm14107795ad.80.2024.08.10.10.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 10:57:57 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 2/3] riscv: sbi: Add HSM extension functions
Date: Sun, 11 Aug 2024 01:57:43 +0800
Message-ID: <20240810175744.166503-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240810175744.166503-1-jamestiotio@gmail.com>
References: <20240810175744.166503-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add helper functions to perform hart-related operations to prepare for
the HSM tests. Also add the HSM state IDs and default suspend type
constants.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h | 18 ++++++++++++++++++
 lib/riscv/sbi.c     | 15 +++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 6b485dd3..5cebc4d9 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -47,6 +47,21 @@ enum sbi_ext_ipi_fid {
 	SBI_EXT_IPI_SEND_IPI = 0,
 };
 
+enum sbi_ext_hsm_sid {
+	SBI_EXT_HSM_STARTED = 0,
+	SBI_EXT_HSM_STOPPED,
+	SBI_EXT_HSM_START_PENDING,
+	SBI_EXT_HSM_STOP_PENDING,
+	SBI_EXT_HSM_SUSPENDED,
+	SBI_EXT_HSM_SUSPEND_PENDING,
+	SBI_EXT_HSM_RESUME_PENDING,
+};
+
+enum sbi_ext_hsm_hart_suspend_type {
+	SBI_EXT_HSM_HART_SUSPEND_RETENTIVE = 0,
+	SBI_EXT_HSM_HART_SUSPEND_NON_RETENTIVE = 0x80000000,
+};
+
 struct sbiret {
 	long error;
 	long value;
@@ -59,6 +74,9 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 
 void sbi_shutdown(void);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
+struct sbiret sbi_hart_stop(void);
+struct sbiret sbi_hart_get_status(unsigned long hartid);
+struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque);
 long sbi_probe(int ext);
 
 #endif /* !__ASSEMBLY__ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 3d4236e5..a5c18450 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -39,6 +39,21 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
 	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
 }
 
+struct sbiret sbi_hart_stop(void)
+{
+	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_STOP, 0, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_hart_get_status(unsigned long hartid)
+{
+	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_STATUS, hartid, 0, 0, 0, 0, 0);
+}
+
+struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
+{
+	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
+}
+
 long sbi_probe(int ext)
 {
 	struct sbiret ret;
-- 
2.43.0


