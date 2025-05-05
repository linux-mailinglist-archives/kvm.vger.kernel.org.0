Return-Path: <kvm+bounces-45512-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F8DAAAD5B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:33:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88A5D163715
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AB9306CBC;
	Mon,  5 May 2025 23:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RZ7r2FqO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538813B2899
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487247; cv=none; b=t1vxnrbtbZa3F0hxhqsdoAKEX9N9N67JovJ04zYYtMyNeKaCGK5yUSiBWdsXHiPVKtCKYD5d5BSu+Ef7OIwPmYC7pUaogWrAQZNOwJbQ+xIYsysteJOMfUG0rb+mYtbxRvlMl0X7k+CP7yL/Ei207UjULwfha29tz+VcJ6/QhdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487247; c=relaxed/simple;
	bh=QTKVnR3dxb6YiT9nVr9N7IaUWwG0tfEl4EVtzghDltU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Thw8nf+Id7M56nlRLq5rNp9j2CEEbDueCp47h26Zptz4URz/lqaWv3Lsm4qmuLNIZSfWvVCTJ4/7BIjyRSar+RfRdLAkgVBSDNnZ+NXmQbhxBCemZxArvOJyEUA3MMRzcNb2raAj3HCViKk28eZEFs2WCoDvKE/ekFVmrnoRPEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RZ7r2FqO; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22401f4d35aso59069185ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487244; x=1747092044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=RZ7r2FqOuLlHkY3LWxgHyy+J7AuQuelOfZv/vtR3sW6NqUuGd6brw4naTmR0a+vfrW
         3tLoSsWgOOqvlyN1x+ZwExzI2J590Q0LMSExRBRkVBa98DqOeT19rwBWPiQWZYb48C8m
         i410JEcNZdM3PhIngHyEl3IaFQQCjIm8BL4s7dvb+1eOLOzTWsr3eg89tYWVSA/2Kagk
         rTcvXT3RiPyVxv/vels2kI267//l9ux3ljt2dAtaBD9hkPma1CDrg2KD4vrAaeCHq57G
         qTxuZtqKTHWQ9J1LFEVHUwdD+msEu0+uhC7vzWP7bM6TKz4L19HzgGBnpsf6dtwGkqYz
         uDUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487244; x=1747092044;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zqH0yuKEeNcEhgp08pnDlbJMJEZktVD9woNi3X9JPBk=;
        b=ivhxgMZzptwMxIQRyEe36UeDUFAXVEdzIF+aRTGhi0nlWMovYhGp4evoH/zY/YxFcH
         gfDST6rXm+GCL5Tuq2UISjS/5mB/2lmcaOm1HiXCJNDuojBWqWsQcVwVG9SMy3AzNiMz
         QYQ9jDzaxrpHlKciJUpNwvKTty5V9JP/lVWFmJ1CoxPzmVpNHet1ZcI5EzsMkOGT+DV9
         jAJOKOiG86LvMH4lWVs1EHfryptJq3ojhfgQZj4GTH6Mq/lGY8AQbdQRHREgmOTt9WRP
         uAoLm8aCUngqxozMRH3bymhqsdlnfHCMtKmoF0dFvhmrt7k3RJtwHR5rloHnxQuXQbSE
         fapw==
X-Forwarded-Encrypted: i=1; AJvYcCX4i/0Bn0O1i4EtYCJyx7PvNo9WCJayxDqaPiPP6vcEVrgg8UkhgCaN4pHQ6KdPZqw9ZqI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy217gRxHZx+5kTFr/SLZSqnYIeKqBR7AM9NVk+ObEhcR4K+UiR
	v4I3Exz1UKNG8rk6hmbxEW2DyGFoHCS80+YXUpTVs9FsTLqKEswKrEHfdiU8Sbk=
X-Gm-Gg: ASbGnctpC0HUvfo/mVn4gYbp4z78q9+TuIweCzMov/ilRgnCLXS9uyhrGZ+H+pPQ+Ac
	l/kjTbTx+MYGfuj6icSU1KcnKsz10gzjrixYlq9G93RuGJ86SfkvwAJCmMm8lWoUGQtQzzaKbzo
	Mk6V7n95P43GBmTPe+TcOYzu6IL8XP48fSi0MroNufovxlOZiZyqsF0GKpluRLuIKiePAE5nrcN
	6gBfSDgqWagg9IyZaWnNKL50wrC9YT6oVyYmu4Xwq3c1N9PzAtB8d/opPooMKn8P500SngPRZDc
	mmUKhBoMsveeNr18yvgRQ9BRjd4Q81idEaNLVPxf
X-Google-Smtp-Source: AGHT+IEM7kaXEWCjPJCRibG1QX47pOlJJpefd7EuFnbK5xMzUMnHJ0NFjXgA0rgQXuFWitn7GRKtLw==
X-Received: by 2002:a17:902:ce91:b0:223:325c:89f6 with SMTP id d9443c01a7336-22e35fa30eemr13388815ad.10.1746487244580;
        Mon, 05 May 2025 16:20:44 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:44 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 27/50] target/arm/arch_dump: remove TARGET_AARCH64 conditionals
Date: Mon,  5 May 2025 16:19:52 -0700
Message-ID: <20250505232015.130990-28-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Associated code is protected by cpu_isar_feature(aa64*)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/arch_dump.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/target/arm/arch_dump.c b/target/arm/arch_dump.c
index c40df4e7fd7..1dd79849c13 100644
--- a/target/arm/arch_dump.c
+++ b/target/arm/arch_dump.c
@@ -143,7 +143,6 @@ static int aarch64_write_elf64_prfpreg(WriteCoreDumpFunction f,
     return 0;
 }
 
-#ifdef TARGET_AARCH64
 static off_t sve_zreg_offset(uint32_t vq, int n)
 {
     off_t off = sizeof(struct aarch64_user_sve_header);
@@ -231,7 +230,6 @@ static int aarch64_write_elf64_sve(WriteCoreDumpFunction f,
 
     return 0;
 }
-#endif
 
 int arm_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
                              int cpuid, DumpState *s)
@@ -273,11 +271,9 @@ int arm_cpu_write_elf64_note(WriteCoreDumpFunction f, CPUState *cs,
         return ret;
     }
 
-#ifdef TARGET_AARCH64
     if (cpu_isar_feature(aa64_sve, cpu)) {
         ret = aarch64_write_elf64_sve(f, env, cpuid, s);
     }
-#endif
 
     return ret;
 }
@@ -451,11 +447,9 @@ ssize_t cpu_get_note_size(int class, int machine, int nr_cpus)
     if (class == ELFCLASS64) {
         note_size = AARCH64_PRSTATUS_NOTE_SIZE;
         note_size += AARCH64_PRFPREG_NOTE_SIZE;
-#ifdef TARGET_AARCH64
         if (cpu_isar_feature(aa64_sve, cpu)) {
             note_size += AARCH64_SVE_NOTE_SIZE(&cpu->env);
         }
-#endif
     } else {
         note_size = ARM_PRSTATUS_NOTE_SIZE;
         if (cpu_isar_feature(aa32_vfp_simd, cpu)) {
-- 
2.47.2


