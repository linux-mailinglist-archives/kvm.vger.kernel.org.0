Return-Path: <kvm+bounces-26276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AE9E973B3E
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 17:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED805286C47
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 15:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331BB1993AF;
	Tue, 10 Sep 2024 15:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idyc9M9z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BA0196C86
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725981347; cv=none; b=HroWTgy64127j9Nl/2wFb0g+rWgFLeFQEzUsVztF+Z0HL1wccJX8G/XiALSNp2+yZ47oQsgOdhbWGY/io2q7QRXvvRgdobefIQ4YPm+OEPUswXcfDHKx9h+3LHEgArBC5GZSspcHkyVW1ikbE4XSCMWWbgCeYJu7O/NpYForiow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725981347; c=relaxed/simple;
	bh=J0V9vFqNxsCHY7LZQzMokbjsEZAbTZCCT3+H26G6FsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEaZ7frWsU7HMROi+xUbgBxJev76X+K+MMxAMAayYX5YxRJgGyl43sRJPM+XMIZDlYRUYiB6TtNrhdePxa30Oubw0rLr3pLl3nffmUHCpE16tNzmcTSwStw1mSUSvgJWSlSAgb3EFEaCK6Vu/Q+GsKPWq7044/X9NdYPlX8ulrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=idyc9M9z; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-82ade877fbeso149822339f.0
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 08:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725981345; x=1726586145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xkaOiUCcEWksaAjNJVfQshh8c4VMisSUowo1/58qFts=;
        b=idyc9M9zF1Bt+VUHoePMPz7fcD0y3ciWPkDDwMi7m1X0pneULSMSDM0wIDpsd/9cPl
         08UJtpkU60MMDkIoLkd2/4bvzGcabvQ77AJGglkve//KATCbym4XNpiJ1nUk1Tc8ugfa
         CZZMBfIWJuvMq6gHFT0xx44C2VzDQJg9sYcVBJouMa2PabVM0DRT3SC7JvMHKHH1Yhke
         1rqLNTidQVuSpFeBD+oF5hkbjSSW85zSxNW2wt1R9Nd4WJ+6QjrrqyMSjQLK7qqkUFNl
         QmmaS5SKslaPPLMRl+2MlOOxF1N9KZAvihmgNBZdinP1Yv33nrKDuF9OM6X8gPPf/SeM
         kkaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725981345; x=1726586145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xkaOiUCcEWksaAjNJVfQshh8c4VMisSUowo1/58qFts=;
        b=qyO5QntSQTIGctw+AHmFvvsWQ9QCJEu8ebyUZAug8XbLQjWAz6XThLThHrFdIqNA8Z
         cNIWdTLVJakICsGHPoaIAboJ16PlpVT8ZCf/CYeEdxBbsGv0JOvFIhjx1zs4wqnjEuB/
         kqkKMfFwlcfteYKUJHdYxG6+SQ2jeYAA4Ej7jrKFl4nbCqUIgxdwpho+Y6Scszkn+PC+
         exmIOmruQjv6PjXwz5OnZ3Y2qQfPbFmLnbri6ruGOpcG9EdZ3TgJ7a8B8LGBCImFHjgz
         tpuw9wXBcBbUsWgM6xzxOwN2sVGo/11De91D+sNKu+6YMIa17Xfb7M/w5nqHcJMRlTuM
         u5SA==
X-Gm-Message-State: AOJu0YzmYf1rT3+T4720mwzBfkJ/kg1okmjqNJlcEyPtV656oKATLQBo
	+L38SjVHlI6zUN920JE66HiiJXuSOxQzY+wLrls0N0v3NpjInsGro5R0XiAO
X-Google-Smtp-Source: AGHT+IEGao7JXGGrQF20u8Br69vkKnAepgX7IPCtwNlEn4gESzTMzT66CX9k6JOXeKXTj6GcKWkewA==
X-Received: by 2002:a05:6e02:1d06:b0:3a0:4a63:e7ac with SMTP id e9e14a558f8ab-3a04f0ccccfmr180421135ab.18.1725981344518;
        Tue, 10 Sep 2024 08:15:44 -0700 (PDT)
Received: from JRT-PC.. ([202.166.44.78])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d823cf3d58sm4939414a12.20.2024.09.10.08.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 08:15:43 -0700 (PDT)
From: James Raphael Tiovalen <jamestiotio@gmail.com>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org
Cc: andrew.jones@linux.dev,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	James Raphael Tiovalen <jamestiotio@gmail.com>
Subject: [kvm-unit-tests PATCH v3 1/2] riscv: sbi: Add HSM extension functions
Date: Tue, 10 Sep 2024 23:15:35 +0800
Message-ID: <20240910151536.163830-2-jamestiotio@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240910151536.163830-1-jamestiotio@gmail.com>
References: <20240910151536.163830-1-jamestiotio@gmail.com>
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

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
---
 lib/riscv/asm/sbi.h | 17 +++++++++++++++++
 lib/riscv/sbi.c     | 10 ++++++++++
 riscv/sbi.c         |  5 +++++
 3 files changed, 32 insertions(+)

diff --git a/lib/riscv/asm/sbi.h b/lib/riscv/asm/sbi.h
index e032444d..1319439b 100644
--- a/lib/riscv/asm/sbi.h
+++ b/lib/riscv/asm/sbi.h
@@ -49,6 +49,21 @@ enum sbi_ext_ipi_fid {
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
@@ -67,6 +82,8 @@ struct sbiret sbi_ecall(int ext, int fid, unsigned long arg0,
 
 void sbi_shutdown(void);
 struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned long sp);
+struct sbiret sbi_hart_stop(void);
+struct sbiret sbi_hart_get_status(unsigned long hartid);
 struct sbiret sbi_send_ipi(unsigned long hart_mask, unsigned long hart_mask_base);
 struct sbiret sbi_send_ipi_cpu(int cpu);
 struct sbiret sbi_send_ipi_cpumask(const cpumask_t *mask);
diff --git a/lib/riscv/sbi.c b/lib/riscv/sbi.c
index ecc63acd..8972e765 100644
--- a/lib/riscv/sbi.c
+++ b/lib/riscv/sbi.c
@@ -42,6 +42,16 @@ struct sbiret sbi_hart_start(unsigned long hartid, unsigned long entry, unsigned
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
index f88bf700..c9fbd6db 100644
--- a/riscv/sbi.c
+++ b/riscv/sbi.c
@@ -73,6 +73,11 @@ static phys_addr_t get_highest_addr(void)
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


