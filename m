Return-Path: <kvm+bounces-59565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 89DA9BC0972
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 10:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 711A24E1A17
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 08:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 932AC257437;
	Tue,  7 Oct 2025 08:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LKK4ZyCI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F411D554
	for <kvm@vger.kernel.org>; Tue,  7 Oct 2025 08:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759824998; cv=none; b=XNBvO5E4DD3641QwxG5FgY2uL5NAzXIBwpL32t2+GsXakAbyQR59BLV7hP3a2p2lWtfhI2HVQgJRRbZyDV4/Utd8Qmtu3NjsN/gRIza46J9VH07MyNk45YUEOTOnDTzSgwvVe3MDX9jOi9uJlJC6LPMrs+X7KRqq0X7smODfJyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759824998; c=relaxed/simple;
	bh=Jfa3gvo5FfRmFH3KQoGpo6pwJp3eeDpU2xT0DwWpgVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=drcRa17OcALBDEzbF5Qg9lpmJ0vq8oaXo9ZizZxLYjIu0bNs/vEWPcb9Q5ZYUSUytk8e5jzR3dVGTV+QV+CEepDMhg7gOAS0GScCGLIuLyJj9dk8MR6Gy0ArfR9p0zWStxje/fGVSL9nEt1pWlfg5x1kSQu5JzHbW0kWsBSacyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LKK4ZyCI; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee12807d97so4918126f8f.0
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 01:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759824995; x=1760429795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DcrQ/BRDK8jh9DN0RScPMJskWDfOgmoQpJ709DYAp4w=;
        b=LKK4ZyCI4C623xfqhkVk3D+Z0X9kEY8PGEvi3cgVy03cL8ya1brPTcPn/Q/uRQbnqV
         rlyXv3ZXCb85KSOVsUR+Aq2uhcEgew5kDgCRwg/TcJT3cs+jf3nx344WJvfIIHr6FLtN
         tGd735mEzJ5o8QQh/I9sR/erwOHvlPArcr3enx+OQwicZ7BIn0jz2OpXFPOL1g02pug4
         3gZ0+TRpqNi76i3e/hGttFGWhRzVtM6auCEyVWrNNSKdD59wlWpj3StwdhTdapB1dLwu
         WDaB57j+yBYF7NSK+CzciO83lfck0qmOxSVd7k6eNr4XpxTM4ZrcHbJs7JGdKLTk5Scy
         L1eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759824995; x=1760429795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DcrQ/BRDK8jh9DN0RScPMJskWDfOgmoQpJ709DYAp4w=;
        b=qyvXIkkfIjAYNecd9GmWL/T6TgbiNQKKxt63ImNuAYCjdcHY2UT7dEdof7w2V9Bt4+
         w3hb2ZBVsjxMuJ0M60KOMpQt9sU9ellhz9+5l2ha6OOWUv+nUoiafKIhDqEGucPTeDb/
         69H9fGUG9S2eF6p6f3aJVjqnQNfh5RH6xVwIH1JdfCVCJjIyjyzTCbzXL0NZCYG2jiOA
         KyTaBfPfw5hPXbtXogeqSa6uW/sMa7IuElRVzmwVhgAi+je8K1gz3DWT2iqs/QOFXBXn
         JRvVGLhYIuoKCLQif1M++WfOuuJeze9UnkICgh6W9UFZ0ptCKavnQMs1+MBcgBm8A8X7
         +wGA==
X-Forwarded-Encrypted: i=1; AJvYcCXGph5XDKhFV7q1qxdd2Isq7CP/CZPhWl/frgV1toARWL92gX5EaO1WtOW98XAqlhzwPVM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDapqolTsI5fEk3cA4pQILmOi3ptDhhqYTouJDWOCpjEqdylcb
	j8hn9tyNzhNv0yXjPp99NU7Mi+nT8cDEgc9XiUi3pn8K4FGPJrajWJhNQ2lGs9ojAwc=
X-Gm-Gg: ASbGncsb7eWch2HzXtDIjo+taJmSoPWNihmdyb7Wo+DssN0tXt3P/TQiHKQ3Dn5eeof
	dQ7ZsJNGpf7I8v+LpdzTr5Q0mR68RhuCyEgKDAUEk0X/aGcwQ8R3gDpPxbsRzq7q4OY0iRpLYqz
	qHSrT2jblVIpxLrS16UTz8cLtQQkv3o20c2vZUcbj6wZBm3v0wGbM7/pANbaiwvxTPh3J1utgNH
	MlLcbW9Ft+kwl555ra6e0W+eeb9Xhv+Nm/Pkjcy3CdeMbl0CCyCxOPoA0ZITMCNTAHOv5Bf6S3C
	08z9ImqdRCqe5cytLYEWeUe3Y2UHQfvNesdoPrH7ZLvdCyWheKjFZV3LJ6DahDqaXE5yaecc/08
	loaotYd+rygyY+GqAw5B4Vmhd7ihNQ/YUlzQRWXKutXBoie+0s5eFvpR4djkt8XVFhUJTouUqIH
	bF/cCfqHeOm8bepU0t2f9aMlsg
X-Google-Smtp-Source: AGHT+IFHWOG5U1yMfKEb7WzpHpJ5SLy6VLBCW53DXs+72dWbVVXkRnGeB+r0iTL/l/vZ87owsiQaLQ==
X-Received: by 2002:a05:6000:659:10b0:425:73c9:7159 with SMTP id ffacd0b85a97d-42573c9773emr6459560f8f.33.1759824995064;
        Tue, 07 Oct 2025 01:16:35 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f01absm24198783f8f.44.2025.10.07.01.16.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 01:16:34 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Weiwei Li <liwei1518@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Aurelien Jarno <aurelien@aurel32.net>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	qemu-riscv@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 3/3] accel/kvm: Factor kvm_cpu_synchronize_put() out
Date: Tue,  7 Oct 2025 10:16:16 +0200
Message-ID: <20251007081616.68442-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251007081616.68442-1-philmd@linaro.org>
References: <20251007081616.68442-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The same code is duplicated 3 times: factor a common method.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/kvm/kvm-all.c | 47 ++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9060599cd73..de79f4ca099 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2935,22 +2935,32 @@ void kvm_cpu_synchronize_state(CPUState *cpu)
     }
 }
 
-static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
+static bool kvm_cpu_synchronize_put(CPUState *cpu, KvmPutState state,
+                                    const char *desc)
 {
     Error *err = NULL;
-    int ret = kvm_arch_put_registers(cpu, KVM_PUT_RESET_STATE, &err);
+    int ret = kvm_arch_put_registers(cpu, state, &err);
     if (ret) {
         if (err) {
-            error_reportf_err(err, "Restoring resisters after reset: ");
+            error_reportf_err(err, "Restoring resisters %s: ", desc);
         } else {
-            error_report("Failed to put registers after reset: %s",
+            error_report("Failed to put registers %s: %s", desc,
                          strerror(-ret));
         }
-        cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
-        vm_stop(RUN_STATE_INTERNAL_ERROR);
+        return false;
     }
 
     cpu->vcpu_dirty = false;
+
+    return true;
+}
+
+static void do_kvm_cpu_synchronize_post_reset(CPUState *cpu, run_on_cpu_data arg)
+{
+    if (kvm_cpu_synchronize_put(cpu, KVM_PUT_RESET_STATE, "after reset")) {
+        cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
+        vm_stop(RUN_STATE_INTERNAL_ERROR);
+    }
 }
 
 void kvm_cpu_synchronize_post_reset(CPUState *cpu)
@@ -2964,19 +2974,9 @@ void kvm_cpu_synchronize_post_reset(CPUState *cpu)
 
 static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
 {
-    Error *err = NULL;
-    int ret = kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE, &err);
-    if (ret) {
-        if (err) {
-            error_reportf_err(err, "Putting registers after init: ");
-        } else {
-            error_report("Failed to put registers after init: %s",
-                         strerror(-ret));
-        }
+    if (kvm_cpu_synchronize_put(cpu, KVM_PUT_FULL_STATE, "after init")) {
         exit(1);
     }
-
-    cpu->vcpu_dirty = false;
 }
 
 void kvm_cpu_synchronize_post_init(CPUState *cpu)
@@ -3166,20 +3166,11 @@ int kvm_cpu_exec(CPUState *cpu)
         MemTxAttrs attrs;
 
         if (cpu->vcpu_dirty) {
-            Error *err = NULL;
-            ret = kvm_arch_put_registers(cpu, KVM_PUT_RUNTIME_STATE, &err);
-            if (ret) {
-                if (err) {
-                    error_reportf_err(err, "Putting registers after init: ");
-                } else {
-                    error_report("Failed to put registers after init: %s",
-                                 strerror(-ret));
-                }
+            if (kvm_cpu_synchronize_put(cpu, KVM_PUT_RUNTIME_STATE,
+                                        "at runtime")) {
                 ret = -1;
                 break;
             }
-
-            cpu->vcpu_dirty = false;
         }
 
         kvm_arch_pre_run(cpu, run);
-- 
2.51.0


