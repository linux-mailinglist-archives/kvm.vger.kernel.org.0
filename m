Return-Path: <kvm+bounces-20100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44C489109AB
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:22:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6819E1C216F7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976F61B0120;
	Thu, 20 Jun 2024 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ox8J7eZV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF7F1AD486
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896953; cv=none; b=X/tO4mvYgFVygK+fUP7U3jyzTJ6z8ZC1dAKAa5Eyt8ycVptBb1pGp3QJKbr2vJ5CJChfxBYtzD9lvNS2F72PHKgcEZZ2M1hKDavqs+T6AF87/dVURFNtdqLNiln5hAykvxMbAf8/RJTeigEXLj18W/CNgUIIjDpbBAnGSqwWgZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896953; c=relaxed/simple;
	bh=LWQ0eRFkADYmGUcTVY4hJ+pbgRc491C2SQ/i8aBPBiI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HTA7cTtXvyldAwnQtdBMh5M9TkSjUBseGc4fnfGzjerPo7eWMZCylDRmwz8z0po16snjg1yfUsUM7PN6rO0BGCyXLZKYi/qzQAvgLV7L1dw4T7rmbPrDaonbE/buQ6MkOjjFQWP40m7bPIWt+Gn0HfNfeAIDtRVBt5ZnbGSYezk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ox8J7eZV; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57cbc2a2496so1252259a12.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896949; x=1719501749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/X0IxOQD+UVox1iqgN/w4twKxD3yeUu+cfpZug2C5Oo=;
        b=ox8J7eZVQV3HzTHLVqJ+Szj+UNbNFdmbpJQ/3+pHyS/YMB8KqvIF33NalLunh2XB7r
         Jzv2iWbe6H5UOe23ZQXEOu5MNzSFd1bUyN18sU+6JE3UwxUi9fhJ/CM0T6AjAFcKTqOy
         dsfbg6hqjtseln0nOGDOVp0CBJq498IFAWBnES9MytL6W6NyFteN3RlnsILQcixSxbGZ
         9bP/tApd+IUC2vIcKRrZc11J63JUX0BP/X8OkK5QrUmEYOQUFZattWbxFfBpXHjSThbM
         U87dWnhA97AE5W9CVNgosZHXckCZuyKJJkIVWzpLhdtZAyD8JVs/Irz3Q2YCcgotNcdn
         MqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896949; x=1719501749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/X0IxOQD+UVox1iqgN/w4twKxD3yeUu+cfpZug2C5Oo=;
        b=Q82d9Uqs3+/lW9+KvHbh9WSfaln5UEP8u+wxdR/wpyXxXKPPw862Z/4TDrQL1KPu1H
         2kqHIxcqcBfgoGVof1C4/2Hmke6sS6kUt7gaPZDRvtODGPPjg5fzFGlU9Xe1NfoYKweQ
         V2jXQiupH0suFHiXruh6CdzefkY9iHbD1ckeagQkn1+q5Cy0jJnyQE5ZfR0lpdEkDNn/
         mtQahEGxEkPT56CKLPkIM0Uv9TYVZWTHVBq/8V8j6H4uW4DqxnXk7hkH7ZwW3ZA0XF+C
         blF5EWfpLKc3UMojvYKyOm7IVr1Ath7Rt6EcVQwLhyYaXFBbOI59fA+eUBr402MzjVoe
         pjRg==
X-Forwarded-Encrypted: i=1; AJvYcCUnWI/W7ekVf2Z9ulSQYyZgfAQXDBAg6E+05e575vMauEi2xRscpJQk1uh2MKX3w8ZBV1xwn+ncLuftja6/ga+s/SaW
X-Gm-Message-State: AOJu0YwKpFLF+cudSsSjjOyLXm8+8UYuc6tDJhhOeVACIvZLHBosuoJK
	+S740zfcUz1n8K/Mkk+gP/PTT1uiyQmfbpNwelzYfxI2IYUFwt78N+s2Zuctvpo=
X-Google-Smtp-Source: AGHT+IFnftecJ/1MRTQF1ZOm+xWFpcYdRKEdC+4UG5LvASjIC+lNz5bhVZnty9lEhOtdxKLlbFvYZw==
X-Received: by 2002:a50:ccca:0:b0:57a:2475:6a16 with SMTP id 4fb4d7f45d1cf-57d07e7bc1bmr5166576a12.11.1718896948929;
        Thu, 20 Jun 2024 08:22:28 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72e9943sm9855578a12.51.2024.06.20.08.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:22 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 6C5285F9FB;
	Thu, 20 Jun 2024 16:22:21 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-arm@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marco Liebel <mliebel@qti.qualcomm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-s390x@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 04/12] sysemu: add set_virtual_time to accel ops
Date: Thu, 20 Jun 2024 16:22:12 +0100
Message-Id: <20240620152220.2192768-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240620152220.2192768-1-alex.bennee@linaro.org>
References: <20240620152220.2192768-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We are about to remove direct calls to individual accelerators for
this information and will need a central point for plugins to hook
into time changes.

Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20240530220610.1245424-2-pierrick.bouvier@linaro.org>
---
 include/sysemu/accel-ops.h                     | 18 +++++++++++++++++-
 include/sysemu/cpu-timers.h                    |  3 ++-
 ...et-virtual-clock.c => cpus-virtual-clock.c} |  5 +++++
 system/cpus.c                                  | 11 +++++++++++
 stubs/meson.build                              |  2 +-
 5 files changed, 36 insertions(+), 3 deletions(-)
 rename stubs/{cpus-get-virtual-clock.c => cpus-virtual-clock.c} (68%)

diff --git a/include/sysemu/accel-ops.h b/include/sysemu/accel-ops.h
index ef91fc28bb..a088672230 100644
--- a/include/sysemu/accel-ops.h
+++ b/include/sysemu/accel-ops.h
@@ -20,7 +20,12 @@
 typedef struct AccelOpsClass AccelOpsClass;
 DECLARE_CLASS_CHECKERS(AccelOpsClass, ACCEL_OPS, TYPE_ACCEL_OPS)
 
-/* cpus.c operations interface */
+/**
+ * struct AccelOpsClass - accelerator interfaces
+ *
+ * This structure is used to abstract accelerator differences from the
+ * core CPU code. Not all have to be implemented.
+ */
 struct AccelOpsClass {
     /*< private >*/
     ObjectClass parent_class;
@@ -44,7 +49,18 @@ struct AccelOpsClass {
 
     void (*handle_interrupt)(CPUState *cpu, int mask);
 
+    /**
+     * @get_virtual_clock: fetch virtual clock
+     * @set_virtual_clock: set virtual clock
+     *
+     * These allow the timer subsystem to defer to the accelerator to
+     * fetch time. The set function is needed if the accelerator wants
+     * to track the changes to time as the timer is warped through
+     * various timer events.
+     */
     int64_t (*get_virtual_clock)(void);
+    void (*set_virtual_clock)(int64_t time);
+
     int64_t (*get_elapsed_ticks)(void);
 
     /* gdbstub hooks */
diff --git a/include/sysemu/cpu-timers.h b/include/sysemu/cpu-timers.h
index d86738a378..7bfa960fbd 100644
--- a/include/sysemu/cpu-timers.h
+++ b/include/sysemu/cpu-timers.h
@@ -96,8 +96,9 @@ int64_t cpu_get_clock(void);
 
 void qemu_timer_notify_cb(void *opaque, QEMUClockType type);
 
-/* get the VIRTUAL clock and VM elapsed ticks via the cpus accel interface */
+/* get/set VIRTUAL clock and VM elapsed ticks via the cpus accel interface */
 int64_t cpus_get_virtual_clock(void);
+void cpus_set_virtual_clock(int64_t new_time);
 int64_t cpus_get_elapsed_ticks(void);
 
 #endif /* SYSEMU_CPU_TIMERS_H */
diff --git a/stubs/cpus-get-virtual-clock.c b/stubs/cpus-virtual-clock.c
similarity index 68%
rename from stubs/cpus-get-virtual-clock.c
rename to stubs/cpus-virtual-clock.c
index fd447d53f3..af7c1a1d40 100644
--- a/stubs/cpus-get-virtual-clock.c
+++ b/stubs/cpus-virtual-clock.c
@@ -6,3 +6,8 @@ int64_t cpus_get_virtual_clock(void)
 {
     return cpu_get_clock();
 }
+
+void cpus_set_virtual_clock(int64_t new_time)
+{
+    /* do nothing */
+}
diff --git a/system/cpus.c b/system/cpus.c
index f8fa78f33d..d3640c9503 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -229,6 +229,17 @@ int64_t cpus_get_virtual_clock(void)
     return cpu_get_clock();
 }
 
+/*
+ * Signal the new virtual time to the accelerator. This is only needed
+ * by accelerators that need to track the changes as we warp time.
+ */
+void cpus_set_virtual_clock(int64_t new_time)
+{
+    if (cpus_accel && cpus_accel->set_virtual_clock) {
+        cpus_accel->set_virtual_clock(new_time);
+    }
+}
+
 /*
  * return the time elapsed in VM between vm_start and vm_stop.  Unless
  * icount is active, cpus_get_elapsed_ticks() uses units of the host CPU cycle
diff --git a/stubs/meson.build b/stubs/meson.build
index f15b48d01f..772a3e817d 100644
--- a/stubs/meson.build
+++ b/stubs/meson.build
@@ -29,7 +29,7 @@ endif
 if have_block or have_ga
   stub_ss.add(files('replay-tools.c'))
   # stubs for hooks in util/main-loop.c, util/async.c etc.
-  stub_ss.add(files('cpus-get-virtual-clock.c'))
+  stub_ss.add(files('cpus-virtual-clock.c'))
   stub_ss.add(files('icount.c'))
   stub_ss.add(files('graph-lock.c'))
   if linux_io_uring.found()
-- 
2.39.2


