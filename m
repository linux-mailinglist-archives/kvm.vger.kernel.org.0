Return-Path: <kvm+bounces-51420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C29CAF7122
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93D327B18DB
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 735D12E339D;
	Thu,  3 Jul 2025 10:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x4j7dbL+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14472E2F01
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540235; cv=none; b=dxmyK/1PlNFWfCFFsnA1gnSSGibPyWcPBhc3Rvg/ogwY8tXd/lPqP7gJx40vLfmq2/uw9xPcSqMrA8VjkTqg07XaRzoPlNlXEW2Ud6XrQ9JXS808/+VP6GMXsmUnBijzg9dL5ynneqaS+hDyQcBgEF+zBc1i/tAU2lnc4ej2iyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540235; c=relaxed/simple;
	bh=+hu154rBLNhT6A+fy++rreqDwMYiNsNjzWDs+QLCJhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/k0TmtgtDRaAG3Sx3w3h2hVfpGitTvz+Rn++WgACy83tjJb0/sEBJuTiNyrx9DMXv3Ul3x66sbxJ7Hsxxp3Hz5sjENVGKGj8ye94U8s9XimI0dsRTBF2wySsBN1nP9ogU62YEp7/Sq4WNKkTijLy7R9eLY2tSEpFI4NA2LR7zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x4j7dbL+; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3a4e742dc97so554656f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540232; x=1752145032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n7sqe5WieSfsWOfFniA97K4tiSwKm4bjRb1aMmtsHEE=;
        b=x4j7dbL+ZrpvLRZpHboa96wKqYlCJtMFbumjrN4ppBKl7ODiSzNaGZjkjaJuZ2+sTj
         NwWAZU35Ayn9hJ6CQe+E6XSTcmd/dnpD2oyAPhbtyjtF+MJ7LUlLpZ4EOclIS47z4a0B
         JO8VOXH4BXBbtu98K5e3KhMeEhI64uSU9hshwqBZb6GrXRnxTQVHiKM+wEXB4WpQwe96
         A3ISyi1S2JR5i1ZGiPiY0cU3CbDTvOnA7jqo8z2wNu7GDs1A1OqDjOU7aYQtijhV4B5c
         wbUp0k5ekHObnoKWEgPeTy6lYNl8rCXTmh2fwNF0gp6HDWC91rJC6WgQdv65mPwkZqZZ
         xhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540232; x=1752145032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n7sqe5WieSfsWOfFniA97K4tiSwKm4bjRb1aMmtsHEE=;
        b=BfUSzkTEpzd3BHmShZ5M+hs0GJUK8YGBV8TBjT8EpmmBXZKFdtGqinwz5ZAf3JRNOa
         HZTGy2DB6w/LQip4hLWNxIg/1JFmYhgjoJo3sflkINIyZ7czQpO9BaEI8T7aXLl4oXHQ
         ZaDC6cEid2iaJo1wepFeQhc6opTpGWdHeqf0E1/EPzTGTY0JKtAmTsrB3K/c2/tP+lYx
         AkUGe4x2/hITRb/bB0uYzuEMQlMT3HsQFNCX+JWLZ95B18drQyW9XAiNcocVOGHAWB8X
         ow6h2WRr34+H9bwANlBQ+2MuDno63uZdzdsar5QmWjtttFI9PDKmcm87YCF9kTK3HBYD
         4jVA==
X-Forwarded-Encrypted: i=1; AJvYcCWI7qOmUnVOZM6cb6ovF9SxHnt9i/It50iumU++89BOuVLG0SpUKFN5BnEhsFIdjzUCCLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoFSh6/F5SMLZbwav5tmi3gYIhVDPg/rGmX1bWIFpVFoow0IRQ
	lkhFrBw9vpOTfB5XQSISKeKeL2O8Vx+tPj4BZ3LR+mP9/NfnSoGp5ICrE5YfXYdkooI=
X-Gm-Gg: ASbGncugsIZ8v3zQhn8DtYEpYNAm2t85vcqJ5OzwOHi74+NRRZUX7LUUX6KRJgLNDT9
	YEXXXkLoejYHUcpiCQ75QAv+0igHukqY7clz//QSZ/DJBbyylhnqAAYPCCmuZU3KV33pJvPfzVo
	OpQL1f9it6ZrMZ/bO/8Y+VjvUIHm4H288p2ehetSQ+bgdIVoV2DxOCWb7oVA9KzxWPWVvCHxM2y
	ox5sEKEDSUhov0FBsQNxrwQgs2kteHizO0tUB+NRZqjOWbQxjqSj4S3He0YVBKeFoe+NrCDosWk
	XlKWKO0UsikuQyFCpF7H2BbzEIVh49tYQaqUozHgR/VS8sJn2LoORdu5QlGu4OXI0DWRU1GLHuk
	r9qvfb9TJcPg=
X-Google-Smtp-Source: AGHT+IGRy6J9bSh2nCm/wWER+UpTUBFDN2Gq3tiv65nOglWjOb0sw7QVz7lMukD2pAC1YNJDsKOanw==
X-Received: by 2002:a05:6000:2484:b0:3a5:5136:bd25 with SMTP id ffacd0b85a97d-3b342440189mr2171036f8f.1.1751540232092;
        Thu, 03 Jul 2025 03:57:12 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a9969f2asm24089165e9.8.2025.07.03.03.57.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:11 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>
Subject: [PATCH v5 17/69] accel: Pass AccelState argument to gdbstub_supported_sstep_flags()
Date: Thu,  3 Jul 2025 12:54:43 +0200
Message-ID: <20250703105540.67664-18-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
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


