Return-Path: <kvm+bounces-25012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D1C95E482
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 19:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 756761F204C3
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 17:08:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45ECA16F0C1;
	Sun, 25 Aug 2024 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ene3xXKS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A9716B385
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 17:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724605721; cv=none; b=mTyekVG6xXE3DuLFq6yAVD/FpeOZOS8KkGoOF7zuTyKk9Vt5rkLIaeMI6hstTFyHzW86g4prylL7m/42mkFC8pAsOU+fdCTdELwDSr+LcoO6hHp2Tte7Mv8vIbjcxLSNvWyFq9imZij0JtIZDmojRUqeXCseksF2X2WqRpYSano=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724605721; c=relaxed/simple;
	bh=LmCO7WYGCC4UfmJqvJeP5lbrEtWp9P+qyQs7RPqh5U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+YkByv+PRDUKBzQvh0t36CvojW77iG/i+FPPggmZh0H/CJ7Z7ILIwrskfI9EnqEPBKGYuM7pv4NN4njVBkgQkyE0b5RjWPLhS9k6BurCjHAStAhigp3v4bcw7ErU7IcEhiDbSmg6R3XmdhkspFs2AoWKIkCN5Qncm/qLlYbgWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ene3xXKS; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-7c3e1081804so2096293a12.3
        for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 10:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724605719; x=1725210519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OpNs22/pulDn9EZCJ53fTAiUtjwD32EvR4w6J/z7Ezc=;
        b=Ene3xXKSKyaObx710cwvXThr2DJO4gSmqnKfA0qRA6SHx6jwggu06Q0jsCf7GmEjpS
         tI4b3+op4mKCej/watnBBjoGhyG2beEFwoeAJ23qLw8EXqgjaduPgDsIak9iHWpx+3jd
         Iqa9vJiAXh70AkrQ0Psvy0gTzv3rwFcGpi1O9xKwTRz5FiMM6RGZy/QDwUKDEqUA5fYn
         WUAAOfNkJOYXkP4JhpCn30WQFYP/A9L7DDgNfkDim2BHDAXpiOfsf8HjqkZ2PJPwxhOI
         URKkMEeTOPE9RrlDAyyxYcFmXPB3qaeUWa/6PGmMqJPcb/E8eu+oCbCY5usCTeundyWv
         9gbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724605719; x=1725210519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OpNs22/pulDn9EZCJ53fTAiUtjwD32EvR4w6J/z7Ezc=;
        b=qfvPuquPwp7wpxvaj+ExazvEjmhZzKiwhFfrJ4eFs7dFlpItKbHUE2VDkZiqi6AQgn
         aGc82GNrTo1Uw0mXnC1kuw0c/n8jqkPX1megr129rxd8OmJBxbC2+3QglkIiWd1Hikbg
         DCajK91vT6ybPcbkmb9FDoQHyui8uKRLRhbUlTzLVL6ajG0RQPR6ULR9MWXklYPV69yD
         YDfwRrcNEJUSWRUaFVlKHoNxvY2lNNpkae9ZvYeNEce7hAeB9VL81WatFKXhh7sooSeh
         sg0bRUlH5imAyRgy+eZKzbR6Zt5wRNB72uND+pkDl3CpoD/3k8tqsuxaNobE1REFjspJ
         iWvw==
X-Gm-Message-State: AOJu0YxrLS4BwRHpf33ZVlnd+WTB4WU5Z/SNdsiHtT9eZ/uzXIiWTKCQ
	IXTq5ZV1fKXpUiA3CES//QQr/tZBfq/p9LR5r43jIuG/srQpbOJjCbsAYn9y
X-Google-Smtp-Source: AGHT+IGbsYg+h5bAdNUHI2eUlxM5CFhQGrj73ZM/hb+QDkq1R4yeITyP/ZwpkMtw60F4N1W6uwVH2A==
X-Received: by 2002:a05:6a20:cf90:b0:1c6:fb2a:4696 with SMTP id adf61e73a8af0-1cc89d6bac4mr7566434637.19.1724605718842;
        Sun, 25 Aug 2024 10:08:38 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dd985sm56083165ad.164.2024.08.25.10.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 10:08:38 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 2/4] riscv: sbi: Add IPI extension support
Date: Mon, 26 Aug 2024 01:08:22 +0800
Message-ID: <20240825170824.107467-3-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240825170824.107467-1-jamestiotio@gmail.com>
References: <20240825170824.107467-1-jamestiotio@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add IPI EID and FID constants and a helper function to perform the IPI
SBI ecall.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h | 6 ++++++
 lib/riscv/sbi.c     | 5 +++++
 2 files changed, 11 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 47e91025..a864e268 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -17,6 +17,7 @@
 enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
 	SBI_EXT_TIME = 0x54494d45,
+	SBI_EXT_IPI = 0x735049,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
 	SBI_EXT_DBCN = 0x4442434E,
@@ -43,6 +44,10 @@ enum sbi_ext_time_fid {
 	SBI_EXT_TIME_SET_TIMER = 0,
 };
 
+enum sbi_ext_ipi_fid {
+	SBI_EXT_IPI_SEND_IPI = 0,
+};
+
 enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
 	SBI_EXT_DBCN_CONSOLE_READ,
@@ -61,6 +66,7 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 
 void sbi_shutdown(void);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
+struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
 long sbi_probe(int ext);
 
 #endif /* !__ASSEMBLY__ */
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 3d4236e5..19d58ab7 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -39,6 +39,11 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
 	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_START, hartid, entry, sp, 0, 0, 0);
 }
 
+struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base)
+{
+	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI, hart_mask, hart_mask_base, 0, 0, 0, 0);
+}
+
 long sbi_probe(int ext)
 {
 	struct sbiret ret;
-- 
2.43.0


