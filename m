Return-Path: <kvm+bounces-51331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F36BBAF61F9
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 20:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE4803B1639
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 18:55:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A584248F54;
	Wed,  2 Jul 2025 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A5pNI7uI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05432F7D0E
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 18:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751482532; cv=none; b=iUd92/O01MLtFzhOFywhQs285bQPJL6fi/HoiCtv+pup1+W1SsMcWwFSU1AnrMFyreGL5UcSVj2qClmv1C71dX8H3UrCvdy1d5FZqlwjmZiHWdHDIsYL/69vgcIFQA8OiaYkBzIhsgQhh3lGFkPxBOtmKS+/74foV9VnXWM9fic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751482532; c=relaxed/simple;
	bh=+hu154rBLNhT6A+fy++rreqDwMYiNsNjzWDs+QLCJhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aW66kLmwJ4NOPC796TiVTOsKDLjxVBvnbfh5pVhwAU2oYerxY9FmmXemryot9sUqNC5SYiYbozlnja0J8+qA7kavToSzfTflbBwppqnobvHkJaNyPhOeHBXK/BRgKKDK/LNQF4dawhrS9JpeQoqE2ouBak5F0tDq76WvwY8mkvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A5pNI7uI; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4537fdec39fso16572995e9.0
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 11:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751482529; x=1752087329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7sqe5WieSfsWOfFniA97K4tiSwKm4bjRb1aMmtsHEE=;
        b=A5pNI7uIcpHKwCxGWn9fz9hlu9R4Y/+PJZJI4OOsLulnYnUaz4t0bWeRaBsCmSS7jM
         gs8QnCX4ial+nUYYnpjTRjL1sXSs4kPIk5iinQhygWiEy37WmU4F0KiLhaUR3DeVHdGY
         TvaPF1MKEyPK3dHErjyVkLmRcyz39jSJ26fDKoz1zRbXz9ssCJH0/EfDdReFWtzWKDY4
         3sVHJtml2bUkhjlUaxs5aheNCvuhcyjc7vKioyn0HZmynh43by5wHIJ1h37oOq95mWbG
         d/jT7NQF3D5x735utDcgtgweT83NeyZNUiuG8ZVrKE8kZTVh28pv8DGL1eMHqyw5QRdo
         pc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751482529; x=1752087329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7sqe5WieSfsWOfFniA97K4tiSwKm4bjRb1aMmtsHEE=;
        b=DGCaD+eX19332M8oPinaeEB2AvVORMfJ0X/U6KBn4dsO7yY9TkVaE4r/+RHo4Ll7Ek
         VWx5YvU+QWmsLdAv/HjmYDV+uDJV3UWu4qpDLp9PnF2zSHqGZLMuC4Lka0/2hxYGTgXe
         bKq+XIqY8tW+5lpuyC7FXvb3JSItStDqiH/rSr31OSguPSUmDL8Hvuss8rKldkp5pmtB
         /Q5JLxLD4IiX9Lz/UaRHr+V61mQ7fEppR2sXSBOxFGnQWHbD2ElE1mzDJG12cQd2rPng
         GBtH31h6/mVDDwdkZAcqT0pbVhOUEG/zWz1ayS3JSvBj5mY9rvZGR40VPEy3Wl66N4Q2
         6jVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdzs0+Q3S2+GZCW8mudKwlJga7YIKvW2f8nR28iMv0PNnI0Fkr2mpOeio4Te4/lCA5roA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXfd54YVditrup3QzavyBJFMR/XHZX53z5TcbdYl2LxE8bXHKG
	ZtwMR23+P8shR7/NwQSoeWLg8nwwuRAcsnMWaDh0i0Ke1dVrtocwO+9Tx1nzqXudP/Y=
X-Gm-Gg: ASbGncuFD9wAEjOhRQiKhRI7G19U9M9zJacm+OgJaqzQTvaLBUAgTpX1TLWGwLMiMf0
	uhz44ypQEMmQeZF/dElAT7UGuvsu8M55qgzF9nXEayADI3JETBQ/0wiTVmCOsUoUzMgK5q2ghEa
	YtocUmHU8G7+Vz0Val4YVJXOf/MoEvmhp/WTNGKWHQn6NG5bYAGCMLC5pWyjKHmadpdBX6tjhP8
	T11wOgmFASk5CQI3WITgr03Mxi2p1UuEkWMZ3Xc/PgCLXCae3dOkDDK8ww3m4ajWQs57kvBmEUO
	94gMoRVS8eUfWeLWEXQlr+AlMuu+l2EFjCOW2yX9vV5yR90yHz9ywxwty7f7B80o8SiLXN/nSSG
	65f8v4qKsL9GQiGIQ5HxLKJI82zWDHZdVFvOf/ZYrzmMFjYk=
X-Google-Smtp-Source: AGHT+IGmda3LM0dHY2HjDFQ52mTlnAGZ2QunZrg7bMjnKdM1tDfN3QqU8UbNLwJzvfvNCeQ7OUZAZQ==
X-Received: by 2002:a05:600c:1383:b0:43c:ea1a:720a with SMTP id 5b1f17b1804b1-454a9c62561mr7565105e9.1.1751482528907;
        Wed, 02 Jul 2025 11:55:28 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e59884sm16363693f8f.80.2025.07.02.11.55.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 02 Jul 2025 11:55:28 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	kvm@vger.kernel.org
Subject: [PATCH v4 16/65] accel: Pass AccelState argument to gdbstub_supported_sstep_flags()
Date: Wed,  2 Jul 2025 20:52:38 +0200
Message-ID: <20250702185332.43650-17-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250702185332.43650-1-philmd@linaro.org>
References: <20250702185332.43650-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In order to have AccelClass methods instrospect their state,
we need to pass AccelState by argument.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/accel.h      | 2 +-
 accel/accel-common.c      | 2 +-
 accel/hvf/hvf-accel-ops.c | 2 +-
 accel/kvm/kvm-all.c       | 2 +-
 accel/tcg/tcg-all.c       | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index a6a95ff0bcd..1c097ac4dfb 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -50,7 +50,7 @@ typedef struct AccelClass {
                        hwaddr start_addr, hwaddr size);
 
     /* gdbstub related hooks */
-    int (*gdbstub_supported_sstep_flags)(void);
+    int (*gdbstub_supported_sstep_flags)(AccelState *as);
 
     bool *allowed;
     /*
diff --git a/accel/accel-common.c b/accel/accel-common.c
index 55d21b63a48..1d04610f55e 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -128,7 +128,7 @@ int accel_supported_gdbstub_sstep_flags(void)
     AccelState *accel = current_accel();
     AccelClass *acc = ACCEL_GET_CLASS(accel);
     if (acc->gdbstub_supported_sstep_flags) {
-        return acc->gdbstub_supported_sstep_flags();
+        return acc->gdbstub_supported_sstep_flags(accel);
     }
     return 0;
 }
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index c256cdceffb..640f41faa43 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -353,7 +353,7 @@ static int hvf_accel_init(AccelState *as, MachineState *ms)
     return hvf_arch_init();
 }
 
-static inline int hvf_gdbstub_sstep_flags(void)
+static inline int hvf_gdbstub_sstep_flags(AccelState *as)
 {
     return SSTEP_ENABLE | SSTEP_NOIRQ;
 }
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 6f6f9ef69ba..45579f80fa5 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3980,7 +3980,7 @@ static void kvm_accel_instance_init(Object *obj)
  * Returns: SSTEP_* flags that KVM supports for guest debug. The
  * support is probed during kvm_init()
  */
-static int kvm_gdbstub_sstep_flags(void)
+static int kvm_gdbstub_sstep_flags(AccelState *as)
 {
     return kvm_sstep_flags;
 }
diff --git a/accel/tcg/tcg-all.c b/accel/tcg/tcg-all.c
index c674d5bcf78..5904582a68d 100644
--- a/accel/tcg/tcg-all.c
+++ b/accel/tcg/tcg-all.c
@@ -219,7 +219,7 @@ static void tcg_set_one_insn_per_tb(Object *obj, bool value, Error **errp)
     qatomic_set(&one_insn_per_tb, value);
 }
 
-static int tcg_gdbstub_supported_sstep_flags(void)
+static int tcg_gdbstub_supported_sstep_flags(AccelState *as)
 {
     /*
      * In replay mode all events will come from the log and can't be
-- 
2.49.0


