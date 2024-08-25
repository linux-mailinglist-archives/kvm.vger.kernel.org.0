Return-Path: <kvm+bounces-25013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74E2A95E483
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 19:08:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 383CF281736
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 17:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBAE155A43;
	Sun, 25 Aug 2024 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NlRfIt4h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B8316F0C6
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724605723; cv=none; b=KuNNwv3MA+cO9XWB0/MYlpB9/VtD/l1OO60kmyOA8ARfwLnG115nCEI8fF6G6xC9VFxAAMVSXYwqLNtPNGMOVsReubzBihiAaYIS1cLOVQyXOif5yl1O3K48BcdL9E/qcqsLcgaXswi5PlTGrCuVbIsw4NZ6RrrcYz01agJlpX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724605723; c=relaxed/simple;
	bh=tyBlGvQ4IpzB2ul/Qu+0jHPBIGsIUSGhkR9hzLEpGtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvzObrpjSaZ2+Mo3JuJGtf9VwWQI4GZUOqIy/e+ILrn4Zxc9UQ2STmqMU7MQadDS9cxG8ysqX2RCoj+5N8ObzQ3CH/GbfzXFJWfp0dWZ2aumOfyducGbjEhFWT7Tpd22ImRxOWnZh3fFL3EaVdf6uLugI4Vd7icFOjI+yaOaCkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NlRfIt4h; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20202df1c2fso29078525ad.1
        for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 10:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724605721; x=1725210521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gckUWFxhpGbWVlGAGlzsWH3byBepNJj4AE/d1tkaAcc=;
        b=NlRfIt4hK+rHi5tMtWOhjiSDcM+Mv2rE506LBDBT1vHXqlvv6qz205R3NZZWV22k+b
         4s+Dh9hrEPTFP4fjLYVKx0gNL7mKyVDcDRyGN7djWbiCXH2M/EuEnNubligvDB6dE7X3
         TU3fqfUjcPAAo80KDQhLDX6QWhdj1a2NWwjMEPjlNN11BBi5OQLLIEJJlA+BLAVLNNcz
         NbzGzKONIFWXqHw1faIb3Tw2+HL8qtv1owIfTaeE3rQQzCATTFVGNRSHQ9RCESDNz8Sl
         h8PivztlDWtU/HfVzd79jThpOyCOEPcO61VmX8nULThHokfPBguXFTtBzwnw8UeXfAuV
         2U1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724605721; x=1725210521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gckUWFxhpGbWVlGAGlzsWH3byBepNJj4AE/d1tkaAcc=;
        b=jEfTZ1OZo/7+t++JzA6cP7BTTQ31pJZ078oOwDAxWZ2oKEDMIoyzO0CTj2/8gbSn1I
         sv68RIv572BCU7lekoVLRCuep5NB529T30dQHapmGyaWaPvmZnSE8a6+wDXtw8eOwEp5
         brdmQ7qRaoCJfl05Vpoq/PZFC5JGgNKwdN5DKCAP0KqCnSlwgXGKFfennw5wfxgvt0J/
         VhhFSe/hZ6WhugevItr856hKLyxGVhVC406b1rsP38mp5ToE2T9LqSMl8KkA5/WZ3utd
         kZA522BJVubqN9SlYliA+0G1HkY5mzBnk+z89bp6eqKsO4mjfy+uSno3QbnuiInmQgba
         CWmg==
X-Gm-Message-State: AOJu0Ywc89cU5dol0wbdrs3p/hSUIP7DtL/ExO2WROqEKQJOFBAKfXG+
	Y/aS2xODjy5l/X6sHe9ivZAmcqRnSyKq2iN5pW/LDMYJV1Rj5lyeyUO+7xMQ
X-Google-Smtp-Source: AGHT+IHZzM/qViHLzQpOrmEC/WRNtKeiND6zRKFGZ5NNcOHQwbqPlhRQOWaK/R3e/WS76nMTxpy+Gw==
X-Received: by 2002:a17:902:f68c:b0:1f9:d6bf:a67c with SMTP id d9443c01a7336-2039c31cca4mr128706135ad.5.1724605720939;
        Sun, 25 Aug 2024 10:08:40 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dd985sm56083165ad.164.2024.08.25.10.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 10:08:40 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v2 3/4] riscv: sbi: Add HSM extension functions
Date: Mon, 26 Aug 2024 01:08:23 +0800
Message-ID: <20240825170824.107467-4-jamestiotio@gmail.com>
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

Add helper functions to perform hart-related operations to prepare for
the HSM tests. Also add the HSM state IDs and default suspend type
constants.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h | 17 +++++++++++++++++
 lib/riscv/sbi.c     | 10 ++++++++++
 riscv/sbi.c         |  5 +++++
 3 files changed, 32 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index a864e268..4e48ceaa 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -48,6 +48,21 @@ enum sbi_ext_ipi_fid {
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
 enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
 	SBI_EXT_DBCN_CONSOLE_READ,
@@ -66,6 +81,8 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 
 void sbi_shutdown(void);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
+struct sbiret sbi_hart_stop(void);
+struct sbiret sbi_hart_get_status(unsigned long hartid);
 struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
 long sbi_probe(int ext);
 
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index 19d58ab7..256196b7 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -39,6 +39,16 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
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
 struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base)
 {
 	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI, hart_mask, hart_mask_base, 0, 0, 0, 0);
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 36ddfd48..6469304b 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -72,6 +72,11 @@ static phys_addr_t get_highest_addr(void)
 	return highest_end - 1;
 }
 
+static struct sbiret sbi_hart_suspend(uint32_t suspend_type, unsigned long resume_addr, unsigned long opaque)
+{
+	return sbi_ecall(SBI_EXT_HSM, SBI_EXT_HSM_HART_SUSPEND, suspend_type, resume_addr, opaque, 0, 0, 0);
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
-- 
2.43.0


