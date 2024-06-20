Return-Path: <kvm+bounces-20103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 338699109AE
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DEF6B2830A8
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 15:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F1EF1B1408;
	Thu, 20 Jun 2024 15:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="I63hvIfS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7861AED45
	for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 15:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718896957; cv=none; b=J+AGTE7YcO7AwWDEUqiEB+m6SY+1F+oKi4rdBmS865za8zECSqq3XDqwaFDeAbpa5852VNmQCDe6mlqs7VNBR4RPNJwO/OM2Ck5qjp+lX9e9aoKjdqaCsvsRUiKYZDQTwkLkFqalDePR4qSsQUTux01fiJvlpjNnF0RQ56lUavM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718896957; c=relaxed/simple;
	bh=ewzmX50QquN9YGXnBE44Fb5gfuDMtN+sabHiA0pcCuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYxEIoxHZgjCZEdSq3ybHS35Zh2qvBPkbIFGEMh2iK6kf8+c5mVXTZHsWuX/fbLwYCxrr731jMdXuCoAsqOSaBWudy34n5HFiVxI22O9BSf3y420ncEf4iRyC/UZIOlWlDumcHh41QwyNgIUmHer9pcqhOYDwLPyKpxcVnsCi+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=I63hvIfS; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a6f1da33826so130637866b.0
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2024 08:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718896954; x=1719501754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6bnw8wtrxQn8og2FDwWWp7AmT3nbEagSCExx0Sw+yVA=;
        b=I63hvIfSadA1LevOuxrZlJhIzcvyQ5+XbkeDQBxSwwDP8LgRuB9qUnC2MSHQ1u9OVw
         Ka5zc8QkxW2lZyn5baP357HX3qRNbGKcZoUFhCo+BAwxZI5lTY09C3pD2dkggrW16u/G
         Jtwf6PyZ603jKphLGvZBS7nx0noQNjvsy+NN5SoxD+jto/PF1ZTSCcMj/HZHbiYRLPql
         0UbHd2f3jgljNXfsscVLy6kVKhDJ0HxqGYE9zqT4TtMm0DWgoKhXOABe/mZ9ruaTXR/7
         3+fvqq8RY8bPsMUQiMXyv2V8bN7+U8rHFFQnt4Y8NBsZ4HKHlaSLpXnLNo405aPZeViT
         nQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718896954; x=1719501754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6bnw8wtrxQn8og2FDwWWp7AmT3nbEagSCExx0Sw+yVA=;
        b=awfkUxavo70FPFLL3myicjubWAcsabT1aqKTbOGYPAhs6zE6mS6AFUaz6ghLYvF0QM
         BA9VCGYGWjVMRZUnfJORnuCLzZns+1cQR1aHRr8F4O/jQRCpLvmpQ3eWQJHHpIAe6BkB
         zUsTEWWLghNWg36mFe8NqgZdhpintqsJrfy+KTw0MC2E+lBK4umZvS5yJKCOSzzw0x+u
         C7oUpP4UHuSO1TOJXgOftRWHs0fcyQ/4tNC+SkKVcTKbluXjG8TyShI0J5FcfmTAgf1h
         uuc0xJMbcE6P8mJE8ARLLtnSQ+s7Ix6XVnX1O4xkMryyWvmhKEkur4L5xJbChPHC3GFD
         5VKA==
X-Forwarded-Encrypted: i=1; AJvYcCXMxo6dtFLR7rQ46sx4UEl1iQo7Tw41Wx3/hRBVymrru3dJIGVwS99OTxiWGZGEmOmSVtOHVwgCf0vIIi/AF+2UXnRH
X-Gm-Message-State: AOJu0YxFNsKjlsCE1nwU2TRSvh6G9F7O2TKJamDpSCoxHSB409hDsmmD
	Jh/pY+xAOC7z0ECVi7fYY5NPX/UG3wXCgKkCoYJwZljw0EjtVMtAjHxEdAC06Pc=
X-Google-Smtp-Source: AGHT+IH2DovLg9WwgVHZUoNTkAIC+HvMNQYXd4BSqH/mpbcJPFM2PUXUQxyUB+bFIycF54XbJ/zPYg==
X-Received: by 2002:a17:907:a787:b0:a6f:ad2f:ac4b with SMTP id a640c23a62f3a-a6fad2fad01mr374136066b.2.1718896953649;
        Thu, 20 Jun 2024 08:22:33 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56db5b98sm774609266b.86.2024.06.20.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jun 2024 08:22:28 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id CDBB15FA06;
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
Subject: [PATCH v2 08/12] plugins: add time control API
Date: Thu, 20 Jun 2024 16:22:16 +0100
Message-Id: <20240620152220.2192768-9-alex.bennee@linaro.org>
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

Expose the ability to control time through the plugin API. Only one
plugin can control time so it has to request control when loaded.
There are probably more corner cases to catch here.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
[AJB: tweaked user-mode handling, merged QEMU_PLUGIN_API fix]
Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20240530220610.1245424-6-pierrick.bouvier@linaro.org>

---
plugins/next
  - make qemu_plugin_update_ns a NOP in user-mode
v2
  - remove From: header
  - merged in plugins: missing QEMU_PLUGIN_API for time control
---
 include/qemu/qemu-plugin.h   | 27 +++++++++++++++++++++++++++
 plugins/api.c                | 35 +++++++++++++++++++++++++++++++++++
 plugins/qemu-plugins.symbols |  2 ++
 3 files changed, 64 insertions(+)

diff --git a/include/qemu/qemu-plugin.h b/include/qemu/qemu-plugin.h
index 95703d8fec..c71c705b69 100644
--- a/include/qemu/qemu-plugin.h
+++ b/include/qemu/qemu-plugin.h
@@ -661,6 +661,33 @@ void qemu_plugin_register_vcpu_mem_inline_per_vcpu(
     qemu_plugin_u64 entry,
     uint64_t imm);
 
+/**
+ * qemu_plugin_request_time_control() - request the ability to control time
+ *
+ * This grants the plugin the ability to control system time. Only one
+ * plugin can control time so if multiple plugins request the ability
+ * all but the first will fail.
+ *
+ * Returns an opaque handle or NULL if fails
+ */
+QEMU_PLUGIN_API
+const void *qemu_plugin_request_time_control(void);
+
+/**
+ * qemu_plugin_update_ns() - update system emulation time
+ * @handle: opaque handle returned by qemu_plugin_request_time_control()
+ * @time: time in nanoseconds
+ *
+ * This allows an appropriately authorised plugin (i.e. holding the
+ * time control handle) to move system time forward to @time. For
+ * user-mode emulation the time is not changed by this as all reported
+ * time comes from the host kernel.
+ *
+ * Start time is 0.
+ */
+QEMU_PLUGIN_API
+void qemu_plugin_update_ns(const void *handle, int64_t time);
+
 typedef void
 (*qemu_plugin_vcpu_syscall_cb_t)(qemu_plugin_id_t id, unsigned int vcpu_index,
                                  int64_t num, uint64_t a1, uint64_t a2,
diff --git a/plugins/api.c b/plugins/api.c
index 6bdb26bbe3..4431a0ea7e 100644
--- a/plugins/api.c
+++ b/plugins/api.c
@@ -39,6 +39,7 @@
 #include "qemu/main-loop.h"
 #include "qemu/plugin.h"
 #include "qemu/log.h"
+#include "qemu/timer.h"
 #include "tcg/tcg.h"
 #include "exec/exec-all.h"
 #include "exec/gdbstub.h"
@@ -583,3 +584,37 @@ uint64_t qemu_plugin_u64_sum(qemu_plugin_u64 entry)
     }
     return total;
 }
+
+/*
+ * Time control
+ */
+static bool has_control;
+
+const void *qemu_plugin_request_time_control(void)
+{
+    if (!has_control) {
+        has_control = true;
+        return &has_control;
+    }
+    return NULL;
+}
+
+#ifdef CONFIG_SOFTMMU
+static void advance_virtual_time__async(CPUState *cpu, run_on_cpu_data data)
+{
+    int64_t new_time = data.host_ulong;
+    qemu_clock_advance_virtual_time(new_time);
+}
+#endif
+
+void qemu_plugin_update_ns(const void *handle, int64_t new_time)
+{
+#ifdef CONFIG_SOFTMMU
+    if (handle == &has_control) {
+        /* Need to execute out of cpu_exec, so bql can be locked. */
+        async_run_on_cpu(current_cpu,
+                         advance_virtual_time__async,
+                         RUN_ON_CPU_HOST_ULONG(new_time));
+    }
+#endif
+}
diff --git a/plugins/qemu-plugins.symbols b/plugins/qemu-plugins.symbols
index aa0a77a319..ca773d8d9f 100644
--- a/plugins/qemu-plugins.symbols
+++ b/plugins/qemu-plugins.symbols
@@ -38,6 +38,7 @@
   qemu_plugin_register_vcpu_tb_exec_cond_cb;
   qemu_plugin_register_vcpu_tb_exec_inline_per_vcpu;
   qemu_plugin_register_vcpu_tb_trans_cb;
+  qemu_plugin_request_time_control;
   qemu_plugin_reset;
   qemu_plugin_scoreboard_free;
   qemu_plugin_scoreboard_find;
@@ -51,5 +52,6 @@
   qemu_plugin_u64_set;
   qemu_plugin_u64_sum;
   qemu_plugin_uninstall;
+  qemu_plugin_update_ns;
   qemu_plugin_vcpu_for_each;
 };
-- 
2.39.2


