Return-Path: <kvm+bounces-51454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 055D5AF7159
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1030527A6C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C162E3AE1;
	Thu,  3 Jul 2025 11:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YB9uqE/s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3DB265CB3
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540415; cv=none; b=oh0/QOt0BD0Hc0gskfii17NcGpgln6+1d6xMkVVEkC+1lnAkFLkt9DNzhtTxJRRBQjh2x3CqjEbLvs5J97IIU9JFOi91uTFWsh/11NRjEunc+lniwRpQ9nmT+VKExnUbZ/Oiip51285VtXcsPz7gf99t6eeLbKD5bI8gn05eLis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540415; c=relaxed/simple;
	bh=umCIcdZg7K7AB/911PoDrLcFWrUc6YF65RFR4+GyaqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S10xJcZDpbrGwmos0FXBVQ+ed0AbJudEwltllOrBMxaabMKZzsS2ketCqA+dcWFGQPGjRRIh3BsUSGMK9UjFYRh8D/FDCHNrJhv60LoGJimJv9PfFEXkVgPhUV4V3lu94bj1wDZ4DWgMul+RX3WwQkSbFBW5byP600jDpteB8Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YB9uqE/s; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a6d77b43c9so5070617f8f.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540411; x=1752145211; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/WhoOlqE7V0YYD9gThfuSml4H33X/s4g/0Rif+XmbeI=;
        b=YB9uqE/sgxYe7qTpdsCjcUUYfHwTQXKw4K8+ejdTXre05zt62y3uxlfx3S8C9KhvKv
         I5uSrGkdFv3TgYL38sExzByWnVuK5dXTtQk3pyPExJm3F0RNVwJkAXU3C5sM66CoLsiC
         GjJ31SF8vqRYRmvObgJngB6QHIlNi6hduHvAtEIYmWkF/nzDvVc1+KOGJX4GkcrM5QS3
         YivPaW1dElGo901iDrA/abES6PUJTQcdEAJvzkdQn2ze21lJdAYu0RbWsrrwk8lD/ZEz
         oNtUTvdijvufL0cwXP/cXenSC4bcfQtsKIYlvNebJ9iq+W7Osdv7WlZyPg4jhlX9/a/i
         uasg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540411; x=1752145211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/WhoOlqE7V0YYD9gThfuSml4H33X/s4g/0Rif+XmbeI=;
        b=CB2V3THN0PJ24jCbkRwrma7NALLYRFBgqu8G4VZ/m0f79rRcGaylK0w+v8VwNdk/BA
         NYDcwCMKk7e3PbYczKzsuZNGqzpUB965P99YcAY3IoKa5kjg91iSqB+R8G8OV46+061L
         xfU8kvqlAN1+pF4KhA9ie31ShBJItH0tlkczT7dhAPrV+1TCjcbDnFr8acU223CRhJc6
         maOqba25UAwYcsI+aqUjEh6xKuYX+LkpsWW93hQ6Pj9N8nn9SuD7FJmTk/tTmHAZ1SUF
         OLlo2IMkTX9LAGRID6cNyP0Og4mL2TQnlDysB5x8gTVe8moFjQ6XtLc9G3Mbf/lfF7G7
         vs6w==
X-Forwarded-Encrypted: i=1; AJvYcCW5l1BWwg+i+j8F3MduVKZbFBPdHWVBnr7icKGNnGpVu9KuALk2ZOuoDX66rqe8VgmlEwA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbOkxSQ2CmWS+VSU4iZa3agTWrPkn7s3aE4NntmCZnlcoK/vC0
	Gv0NO5KTfYTOLjodGVY3GAjG+iDn6FtdEtUXY7EnVDt6hWqPsgTBtBBvLUtvkLNXkkc=
X-Gm-Gg: ASbGncucYDQEou3XVrZOQXaIcc5oSvLP4DmEhyOKxhjUA68HgrE6BCMcbuZvkizmSeq
	YeqJL7/BXdDQ9UhAq15tIgcmDBRN7/97LoVEUcWRuMwR3/pV+rOCrptxK73AbqHQF/czTTAm5G8
	CZ4li6sKXfUHvLcHjcRHQJeIqWByGOwCWJy00A3/vvOydgIicJCtSGzwUAA9KBZJVjWCMh/2njk
	tyfo8j4GJxX6BhUrqNckLCPHw51f/8GBjkj8hYgs8ALuPjKgNvUD9zaS8Cw+m2H6WVwNddI8aGD
	c8+nngHdSe3WmmDcqSWBvtqjf/lA7DkRPf4gHghJlShYNKrfqQKzUWEA+gJODlsh8oltUVuz7qy
	JWAgwcdk88nA=
X-Google-Smtp-Source: AGHT+IFeTMDPZVIUsxjCRROs1WZhm0BU8cjbDiSZTXDbPKt2XE8RpH1YssNTtvaQDLjG2tnATSkPrg==
X-Received: by 2002:a05:6000:43c6:10b0:3a5:2ef8:3512 with SMTP id ffacd0b85a97d-3b32b70c2f9mr1573773f8f.14.1751540411437;
        Thu, 03 Jul 2025 04:00:11 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c80bb28sm17967759f8f.43.2025.07.03.04.00.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:10 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 51/69] accel: Factor accel_create_vcpu_thread() out
Date: Thu,  3 Jul 2025 12:55:17 +0200
Message-ID: <20250703105540.67664-52-philmd@linaro.org>
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

Factor accel_create_vcpu_thread() out of system/cpus.c
to be able to access accel/ internal definitions.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/qemu/accel.h |  2 ++
 accel/accel-common.c | 19 +++++++++++++++++++
 system/cpus.c        |  4 +---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/include/qemu/accel.h b/include/qemu/accel.h
index 598796bdca9..17cf103e445 100644
--- a/include/qemu/accel.h
+++ b/include/qemu/accel.h
@@ -97,6 +97,8 @@ void accel_pre_resume(MachineState *ms, bool step_pending);
  */
 void accel_cpu_instance_init(CPUState *cpu);
 
+void accel_create_vcpu_thread(AccelState *accel, CPUState *cpu);
+
 /**
  * accel_cpu_common_realize:
  * @cpu: The CPU that needs to call accel-specific cpu realization.
diff --git a/accel/accel-common.c b/accel/accel-common.c
index d1a5f3ca3df..d719917063e 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -89,6 +89,25 @@ void accel_cpu_instance_init(CPUState *cpu)
     }
 }
 
+void accel_create_vcpu_thread(AccelState *accel, CPUState *cpu)
+{
+    AccelClass *ac;
+
+    if (!accel) {
+        accel = current_accel();
+    }
+    ac = ACCEL_GET_CLASS(accel);
+
+    /* accelerators all implement the AccelOpsClass */
+    g_assert(ac->ops);
+
+    if (ac->ops->create_vcpu_thread != NULL) {
+        ac->ops->create_vcpu_thread(cpu);
+    } else {
+        g_assert_not_reached();
+    }
+}
+
 bool accel_cpu_common_realize(CPUState *cpu, Error **errp)
 {
     AccelState *accel = current_accel();
diff --git a/system/cpus.c b/system/cpus.c
index 2c3759ea9be..6055f7c1c5f 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -698,9 +698,7 @@ void qemu_init_vcpu(CPUState *cpu)
         cpu_address_space_init(cpu, 0, "cpu-memory", cpu->memory);
     }
 
-    /* accelerators all implement the AccelOpsClass */
-    g_assert(cpus_accel != NULL && cpus_accel->create_vcpu_thread != NULL);
-    cpus_accel->create_vcpu_thread(cpu);
+    accel_create_vcpu_thread(NULL, cpu);
 
     while (!cpu->created) {
         qemu_cond_wait(&qemu_cpu_cond, &bql);
-- 
2.49.0


