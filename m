Return-Path: <kvm+bounces-59622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7F7BC344E
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 06:07:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 68675189D195
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 04:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82852BE646;
	Wed,  8 Oct 2025 04:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jZMyq1VK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208C514A60C
	for <kvm@vger.kernel.org>; Wed,  8 Oct 2025 04:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759896458; cv=none; b=ByNNzsl9UT8y2jMm2QybZum+aUhpMdgZjg9yipASl/o4kJdtj9blC92IbWsrQ+fMrBPDyMK4tj8MbZCcV2+wDh4JrzD1gRZqSR70a+k0NoBgtxnFKSJQIuBsabNq81lY9ID4FoqDEb/CEQB7tBonHWbF4oYqx9d4nktJ5QJs7K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759896458; c=relaxed/simple;
	bh=eCz9QfLUl+FNTCKNBKu/1QynIVS7w94LAHQgIDtxDwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oSmtPcmb+5s27t/V5muFPC3y/sAQdpXo1FPOmP6fHZpWFgGH6rK1NYU1QuV5GlX2oK7n+TenbbDdXWcVmAkf/uuvhDMp6PhmgvGj+St1qLIjti7UOA2PniALEEu4MU3oDM+54xonX9O77/GTk6vcaP684RhvQYWsOCI9WtSgbxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jZMyq1VK; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e326e4e99so2391985e9.1
        for <kvm@vger.kernel.org>; Tue, 07 Oct 2025 21:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759896454; x=1760501254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ocgs0Ja+xiwuPd8e/woUF/Yw02CcYFns8xQ4ykIqIlg=;
        b=jZMyq1VKahJ37kfMU14YqAg+i1XWB87DxVKRNW53l4iLvaHsNO/EEZHAlsBbF4N+9G
         U6alfQqU1XvUzHhUVUAqR9DDyllMo7OahJdYBhRVT15tKSST9x8Q9Z5qz+LWtaYaMvDU
         3tCZPpWVwt7AzoiSsIPkadz1MXGP3NONRQ+Gpcs6B9hOKDLBWPesGv9a3q39CreBCgA5
         6GktWdDmGGTXD+/QMQO3OenFZCz7QdVDUQfj8iUy/yl8zdpAIndUe54+ZBj/1eAqkz7M
         moaHvC1qRwvnEyGJ52/Pq6JxmAV84VQ+fJ1oI3cao8d+oD3QB/L4Pc0wkHhfq0qElmOf
         bO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759896454; x=1760501254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ocgs0Ja+xiwuPd8e/woUF/Yw02CcYFns8xQ4ykIqIlg=;
        b=l1Aw2iGR30H4IpLb9fLZYXMVbrlRZQ+K4ZPVrPqExsjtZwANEENYcl5jcY3KE7tB6d
         xQope9idiZQ0x+RxEg+lNElzbhhRfFTLbNBxmqze+T0fNN+CKk0oDV6IAUgmWM0T9fCH
         jS4lWfWbZReW1TRelDDXVLoaLp5+0TAIemASEfFLV8uCWjrW8+laMCouerfZkYG57Xx3
         n9OUeiUF8aiY2l9T7/tpk9AOZWydIaCEZuP3fFxfKdIFJ7/JgVGXsn/ZoeKO2cLWOTuh
         shKQGu6QYWAXfkUr/+jO7Gn91m8qzjAHF4Y8jLlju5i+jLQ1YE7nKYZQBi38haVqfhgM
         ZYCA==
X-Forwarded-Encrypted: i=1; AJvYcCU1pr2tyVThGE8TR349vHYKjJFcXmckC/rUxLkJEQjee9XdHVgla09c731O2WKa8WaqnB4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUrG/6qSnvw+sX4f5RhxcXjGo9aTLzDK5kaBty6Q1WEeQKNiFt
	YxGiAUSP6ae0l2zW/ykT76meNU8qMS+6gl15NkPfK4OjSILgnhYv7IDiewoD/kiTJtk=
X-Gm-Gg: ASbGncuiPlxXvpJy0wKFRmJVIjDj/GsKM7N5/W0udi8GOFMXyGf9dF6MqO1/VEOflSb
	LNSMb5oxbOBlLfDobHjXBoe/04/eXr5WA5BDFABX8PSne0bLBX/Ee25CHYrbCXaxao1jUBaGa2P
	XXmrPIORMHrUFPaoOzCwOqBUEkJV8PPogI565y/OmrDeoih9fv1eU54ZxyyvdrmuHyiatOSGkAO
	WkblI0HDJYbMeoUFlWIXLs/2IgiF5xGmacbADfhMuKO6axOeltMaUjkVSzvbya0fhIYBM2kk4yV
	AnqsLfEoveXRCahBMwqY7fpSUjCENV/Tmy/RWx3A+jWNpZZETJ0rJ9moGG0Fv4nNsK/bYDSBdMr
	kkACbPK8IiB/eGKR6yWNpvnkAalw0sYw82VNwKLULS31bJXI5R5x27nEp7fC+S0QKxT4GTCCAu8
	89b7x36NbZksyyUmrYCBIfwwk8
X-Google-Smtp-Source: AGHT+IHZFS8T1I/ZV9bUVDRHuknpw5/lllydyyhBKp58Zgvdd1J6n7PoUdc39F+bAmKfqLUaH6pXJQ==
X-Received: by 2002:a05:600c:8a8:b0:46d:38c4:1ac9 with SMTP id 5b1f17b1804b1-46fa2952c99mr23685225e9.2.1759896454357;
        Tue, 07 Oct 2025 21:07:34 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4bdcsm28015265f8f.54.2025.10.07.21.07.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 21:07:33 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org,
	kvm@vger.kernel.org,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Thomas Huth <thuth@redhat.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Song Gao <gaosong@loongson.cn>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 3/3] accel/kvm: Factor kvm_cpu_synchronize_put() out
Date: Wed,  8 Oct 2025 06:07:14 +0200
Message-ID: <20251008040715.81513-4-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008040715.81513-1-philmd@linaro.org>
References: <20251008040715.81513-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/kvm/kvm-all.c | 47 ++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 58802f7c3cc..56031925c4e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2937,22 +2937,32 @@ void kvm_cpu_synchronize_state(CPUState *cpu)
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
+    if (!kvm_cpu_synchronize_put(cpu, KVM_PUT_RESET_STATE, "after reset")) {
+        cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
+        vm_stop(RUN_STATE_INTERNAL_ERROR);
+    }
 }
 
 void kvm_cpu_synchronize_post_reset(CPUState *cpu)
@@ -2966,19 +2976,9 @@ void kvm_cpu_synchronize_post_reset(CPUState *cpu)
 
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
+    if (!kvm_cpu_synchronize_put(cpu, KVM_PUT_FULL_STATE, "after init")) {
         exit(1);
     }
-
-    cpu->vcpu_dirty = false;
 }
 
 void kvm_cpu_synchronize_post_init(CPUState *cpu)
@@ -3168,20 +3168,11 @@ int kvm_cpu_exec(CPUState *cpu)
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
+            if (!kvm_cpu_synchronize_put(cpu, KVM_PUT_RUNTIME_STATE,
+                                         "at runtime")) {
                 ret = -1;
                 break;
             }
-
-            cpu->vcpu_dirty = false;
         }
 
         kvm_arch_pre_run(cpu, run);
-- 
2.51.0


