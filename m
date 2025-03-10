Return-Path: <kvm+bounces-40667-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C9FA59973
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 018EF3A5638
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A7F22FDEB;
	Mon, 10 Mar 2025 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="B6DGJh1z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4689A22DF87
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741619627; cv=none; b=RzRUN63b9f634B7f1b3/fg8nXj39Mm9rksiNKwk3r+sy1+zj4SsSKP//VR1HADILU84WiiT6WWdgAmycgDfd26KzZdcE1mh+Si1RZw69bIjpG/RsPKj7Q1PgI/FLplwjU1s2tvF4o+c2EEJRLZWOSQrWkRZTCTYKAp3F2eP+BLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741619627; c=relaxed/simple;
	bh=H3PXCUjUDQNq8xHh3lVfD9Ld90vm+7TqlKnnpyNaoKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eq+JfCnT9masFKAD3K5e/nBJR8StJ0LBmVZiQge2C7IVLn0uYOvgRTl57onzwYapweB2MrCYvk8o4REwrqUyQBwb5vewEc5iZlbVSaxvLWcFuw8aJcjNhkxGi19MY+2GeV/HojLBSccxgbr0m8HVJOVzjpMJAeKKp/u0KW58xVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=B6DGJh1z; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-22113560c57so81017725ad.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1741619625; x=1742224425; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCBi+dVMU97ACIzU1KLcK/YVJVSSJGwq4MBxilXjNH4=;
        b=B6DGJh1zHetrwu+X5n9C9trKUGkqoYM2zJNlCOJDqQ0fsOHKobJKOYLLzDQolAt+mI
         itNOoNKYpmtMa56vK1qoaCNOz6IP1J7VRYaUSCVOkiAkKvZgSeod+A9rxQSl75cIWx5M
         J4oOgLL9KVHZD49YUc7aTpbRYgjdVTURzu/c3UW1K1WhmdO3Y69BgV89eqppxOJQ9zMr
         0XZHDj5Su2qYNg/0fMUGbLFJauOKFPwf6uF8cm0lt3LztsrTunpdchDxLUOVPmPKef9X
         bQj9VYaEkOm9jCtpcM4AXfNY/vJq9Fi+vEGaToqvJEVmDbbH9nX6eid3nEFvhlMnk7rv
         34MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741619625; x=1742224425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yCBi+dVMU97ACIzU1KLcK/YVJVSSJGwq4MBxilXjNH4=;
        b=I81r7H853h7/kaTJT2CMe5SCfFKNaWtglc7Ov5Ee+etWNcVjKAWG1GgNYFcZPb/xdE
         vfwTz/B5htp9pd18kT1Vd5Ytmw2j30kiKpSNNYm0sJdtqVxb8IVVTR4rN0bR3GaP6vKV
         qFgpp0M0Bnim+RZ+Hy8KVtyLOKc4GeAfhwhWkypjiT0QEejXCcgY1IaluuZ+oogqX6XR
         nUZdOvjiME6G4vNHdDzYBbHHkPr55UzFwi96VCjDOssR1F7JkNbLguLWp1Ii4S8XBBqQ
         qSgWjMuj3CTP4VHIYk3LXYq7iFBh6VGCNAZnEQg6xQsNJMHAIOiUGUp8QtFgkcW25Qgi
         ErbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEGCqGGvrbwi2UvGfc4bF1GgfV4C6BRJk5diU6rx8b+xYRlk8C0AYkhU+oaD4C/HmuUuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSgYBDrMvuTVQdS82nDb7d4+aDNp9GMOBrh/iFvIvswnjFoQaQ
	qR35IvJsyrl77RjwrefCbj6hVasShw+ukLB26E6EeRvxmImPbemfWzPlE/1joqw=
X-Gm-Gg: ASbGncuXeSQNj8XdODkPHLHlZ1r1Zgn3yimhRtqs+JaosrBVBJsTTZnPKGmQM1CLbhZ
	bSDpnRGCfJpHmTrm5Ezcs938yUfMcT4wHM3hbSKolwozb++qNhZFvqhlg+9i5SrBeojfRubN0uH
	7DICjoxQRpScCPM5QeIa7OUpanrp3PNuo7VIU9/33DhqBDcgoKg52oBNPJD52OVQIYTBoLqcY+L
	BKdNiT39ov7dTmW4R/o19MobwN060UsQZxtgVTnxC4zT1ZRj2LCR1EQHi0+5EgI1kpZ8k7KY4t9
	ykaSdRIGkF3VlqU5vAhX5j9zENRb7fx3372IVUBAro4zZw==
X-Google-Smtp-Source: AGHT+IEfHZuAa7IrsxCaNkSR7EwHAs8m2MJ5ac0OEsbyXjAWI9w4OglgcFN0I6P8WNfULj+ZAYb2cg==
X-Received: by 2002:a17:903:283:b0:21f:1bd:efd4 with SMTP id d9443c01a7336-2242888ab0cmr237920295ad.19.1741619625536;
        Mon, 10 Mar 2025 08:13:45 -0700 (PDT)
Received: from carbon-x1.. ([2a01:e0a:e17:9700:16d2:7456:6634:9626])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-224109e99dfsm79230515ad.91.2025.03.10.08.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:13:44 -0700 (PDT)
From: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Shuah Khan <shuah@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-kselftest@vger.kernel.org
Cc: =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 07/17] riscv: misaligned: move emulated access uniformity check in a function
Date: Mon, 10 Mar 2025 16:12:14 +0100
Message-ID: <20250310151229.2365992-8-cleger@rivosinc.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250310151229.2365992-1-cleger@rivosinc.com>
References: <20250310151229.2365992-1-cleger@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Split the code that check for the uniformity of misaligned accesses
performance on all cpus from check_unaligned_access_emulated_all_cpus()
to its own function which will be used for delegation check. No
functional changes intended.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
---
 arch/riscv/kernel/traps_misaligned.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 7fe25adf2539..db31966a834e 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -673,10 +673,20 @@ static int cpu_online_check_unaligned_access_emulated(unsigned int cpu)
 	return 0;
 }
 
-bool check_unaligned_access_emulated_all_cpus(void)
+static bool all_cpus_unaligned_scalar_access_emulated(void)
 {
 	int cpu;
 
+	for_each_online_cpu(cpu)
+		if (per_cpu(misaligned_access_speed, cpu) !=
+		    RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
+			return false;
+
+	return true;
+}
+
+bool check_unaligned_access_emulated_all_cpus(void)
+{
 	/*
 	 * We can only support PR_UNALIGN controls if all CPUs have misaligned
 	 * accesses emulated since tasks requesting such control can run on any
@@ -684,10 +694,8 @@ bool check_unaligned_access_emulated_all_cpus(void)
 	 */
 	on_each_cpu(check_unaligned_access_emulated, NULL, 1);
 
-	for_each_online_cpu(cpu)
-		if (per_cpu(misaligned_access_speed, cpu)
-		    != RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED)
-			return false;
+	if (!all_cpus_unaligned_scalar_access_emulated())
+		return false;
 
 	unaligned_ctl = true;
 	return true;
-- 
2.47.2


