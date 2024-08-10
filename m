Return-Path: <kvm+bounces-23811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08EF594DDDA
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 19:58:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BD911C20C67
	for <lists+kvm@lfdr.de>; Sat, 10 Aug 2024 17:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F6116B736;
	Sat, 10 Aug 2024 17:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bgsKjzze"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55EF16A955
	for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723312679; cv=none; b=Mdjql2V9Tq2SY4ut2UGSspqAlUKwHXyXkPx8dHHus+Yv56XnG5rY08RIq4FXjxL4kOsL/m6UeZ0ZCURi7np0grMeAtUnxzliMfStmPZ/XMeUfV80Vip6lllJsi2PnInVAgONP4/7jlTKvhrm+qhY2gvvpweUf/lP5oloHD05Bu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723312679; c=relaxed/simple;
	bh=MSH7xTZPrKvsIt+eZaQtZz9rkhBE4sSdFfEjMP1LTvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxhUep2O2FgF7OrrqTiAj1YvpoUHXS8W4ZrC0j+507tVsCuGgUzlcltgqKUn4RPV6rBbZTNf5E6/s8Y41DCUYGjwGgVmLB8P2OavGxXYrlP+4eG4ZpdnWzolygsaN6Nm4BeTbh3yHjw+zP335NqIsG3NyV1D5cqCWqGL/x5UcRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bgsKjzze; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-5d5e97b84fbso1677062eaf.1
        for <kvm@vger.kernel.org>; Sat, 10 Aug 2024 10:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723312676; x=1723917476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iiA15RK33yxGQEASjv70VGn8cOt9t5t1YvCkcvYjpkE=;
        b=bgsKjzze9B0Bk0QFSXHTV+6WG3CaIEFokJfKRXyecm8nJmZL73nF2iX09iu60U6Z/r
         W2e+t6G1vrqUmltxGhI3BY4RjjGfO048m7lJclu2VqvirUXRXMNsWrQsADrIWvW7KNrD
         O6whELE+0+B9YixpTKRBg4g1qChcitPMSoY5sKn5T8BIWItr/DYYpAwls/uVgEIkmfEG
         ITbTNqFPc1lVMalpx40UpdsRZ5IoMdRw/BrothHSD77595IFlapkxRPtk/1DD20Xxv3l
         3Vh+XkfbkpkcQyxTvUg9MXNTloWoqNBVM6IsrPSzwuj1yehZTC8Rc3Btca7ZVWuvePsp
         BVqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723312676; x=1723917476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iiA15RK33yxGQEASjv70VGn8cOt9t5t1YvCkcvYjpkE=;
        b=IPX96fDk1F3oa4IPEeh0HWb9cwSZHTd9BFdgogpEppRWVYGiOvrRf271OJ0Vg0wn+7
         R9zbFZR0x9BvVL0ssfps2rbZFFxfVMrH+552t2D1rh4z862L0iIXt4t5gjD0lHVv/T+m
         jBjeQmp7iTucKTWdYXnjGBEqfAnKkOYRSBT/AzMMpfk70VAy6YReMR1BUhhzVEeX2NjW
         +R0qkYO8mwAgXKFwbpOBlUDlXsH6y+SIm0DqLbpG3AlLzNGzpzk1CKtzLMNYLqeuhuIG
         nd9c7JemfuT+nGD0ro04BL3YLHAoKKJujQu/dujMrCgK2EUnMGNVQ8aiAoep1wjCTTnF
         x3RQ==
X-Gm-Message-State: AOJu0YwZMm5PZAzCliqOKwWulTXB8NGswhWn4S6zE/MB2TXbDW0QPIYq
	U/eojqNvWA7pm6dNj2tFPROh5bMIgH/MWAYla/N4FCp/jNxM1ttZyVGqUL4weLY=
X-Google-Smtp-Source: AGHT+IGbN0SZVioxgikEcVEwDqZXvdNl0JP1tlVCLXDpQQD9CzT9J7DYjcIlMkWmiAh5mL0WMKmrOg==
X-Received: by 2002:a05:6358:886:b0:1a5:a3b3:ada7 with SMTP id e5c5f4694b2df-1b177198480mr786746455d.25.1723312676190;
        Sat, 10 Aug 2024 10:57:56 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8fd807sm14107795ad.80.2024.08.10.10.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Aug 2024 10:57:55 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH 1/3] riscv: sbi: Add IPI extension support
Date: Sun, 11 Aug 2024 01:57:42 +0800
Message-ID: <20240810175744.166503-2-jamestiotio@gmail.com>
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

Add IPI EID and FID constants and a helper function to perform the IPI
SBI ecall.

Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h | 5 +++++
 riscv/sbi.c         | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index 73ab5438..6b485dd3 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -17,6 +17,7 @@
 enum sbi_ext_id {
 	SBI_EXT_BASE = 0x10,
 	SBI_EXT_TIME = 0x54494d45,
+	SBI_EXT_IPI = 0x735049,
 	SBI_EXT_HSM = 0x48534d,
 	SBI_EXT_SRST = 0x53525354,
 };
@@ -42,6 +43,10 @@ enum sbi_ext_time_fid {
 	SBI_EXT_TIME_SET_TIMER = 0,
 };
 
+enum sbi_ext_ipi_fid {
+	SBI_EXT_IPI_SEND_IPI = 0,
+};
+
 struct sbiret {
 	long error;
 	long value;
diff --git a/riscv/sbi.c b/riscv/sbi.c
index 2438c497..08bd6a95 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -32,6 +32,11 @@ static struct sbiret __time_sbi_ecall(unsigned long stime_value)
 	return sbi_ecall(SBI_EXT_TIME, SBI_EXT_TIME_SET_TIMER, stime_value, 0, 0, 0, 0, 0);
 }
 
+static struct sbiret __ipi_sbi_ecall(unsigned long hart_mask, unsigned long hart_mask_base)
+{
+	return sbi_ecall(SBI_EXT_IPI, SBI_EXT_IPI_SEND_IPI, hart_mask, hart_mask_base, 0, 0, 0, 0);
+}
+
 static bool env_or_skip(const char *env)
 {
 	if (!getenv(env)) {
-- 
2.43.0


