Return-Path: <kvm+bounces-34637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA3C4A03109
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F36637A195D
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB6121DFE0A;
	Mon,  6 Jan 2025 20:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="onn1kn17"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68461D5CF4
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193822; cv=none; b=en5JU1kTz9OMJIfqrpFqFbXuQce3TIDpnFXNbPcGRdBF1DTmkFBsAp0cj131OI/4sFUhbUUaqsNf4hRp8OVCjDpH9wRcjmr36xzw33zC6wSiC0VZQa6SNk7Q/hozxWGcB6HXSIvNj6vEdSBgDgnmJeCEU5rmnZSa+VAtdv4xl7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193822; c=relaxed/simple;
	bh=cdFEZ+6OmCW3roDp0Ig6SRyhJR/845jzb1sKUfd4Y0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nUehr1RNLlT4PqLyHL4xHve4/JidNHV9XH7BBlLGcZPTD3JM9X4apDMygpPEgcHlVAcvVJcwHbey5Hbkz3/2UD2nTe7ygoMlBnagPTyMWH67994ZTDDPW32p2/u5o7GEVEhzc2t1eZrgmubYdGCW8ofmmo1kmWqrCHqdiZeYtRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=onn1kn17; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43634b570c1so106121935e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736193819; x=1736798619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sQToL39oc1IIGRZ4x4DJpAbte9qYHUOsWxQUB+w3STI=;
        b=onn1kn17hTzwU2anu/vJc+ArC6eAdWFu4GfvR1j0aYkLR+WFUC68ZYOuJqEq9ebnbw
         6LMxyxxvZPqrLizjPq16y/0rW8cI00bAKn3/lQTLZzfMEJb1gH1PsLIfmuYE9ND+LJMf
         fv4lcMc/KQk1r7TRodmF60gvloXRIFqzp1HxpP7G99yXMnU06miU50BwC+YvdFscxCH9
         BRtvw8WcAIWrV+o3kJF/EpONqnBtLjOn5Q7rX5v2Q67wVmpGl/P8kkRODdcEMu2apHkN
         aib3Y8Rmb/cF7UGujZogxoIPZ0q9mxuP5yt+Xm2oCqgdlTU6Rqs+4wMLoAN45eW2SkdK
         bY8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736193819; x=1736798619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sQToL39oc1IIGRZ4x4DJpAbte9qYHUOsWxQUB+w3STI=;
        b=F40FLKMIoHGEvPU8wicHRNf3l8U2V76V/XlQebMl9pbYwKUKsSRp0el0tg/k6uwzZB
         UMMDEqUVI0vHZBvsLdBwM/3NgbZLlGy2a7WQE1jHoC1YBJcAklJpasIgkewEByi4luBx
         aPcIkhgt6zhtSW/qjzUQExKYr4kxftW5bDKCtJA9RNTLmuxh+2E+TE+prpepkH6GLxk5
         4Kep8SDIpCw8iBCiE7mexoxY+X9UpYVfIw8MMtGgkjwQhebBfZJmttT2zkhrL1J6mEiM
         2WrArZPaRuW0ZcceQyKWRYNovxTTMer+9pxG3gWasbgdaK1N6bBI8cZ65wmblj0uZgGj
         G/vA==
X-Forwarded-Encrypted: i=1; AJvYcCXWJw7EH+sHutQWdEIDk5abNJTI8fHbIWeGc4n+CmQssaK33b62Ah67l/r2mH1eg1kF0hs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHB7HnPLCXqjrcMENVZeG5c71HXLm9M02cgWrgSzOTwo2LnHS7
	xqwUFX4/7iApjQMaL5JZFjEztTivN9ujOU6CrkvGr4oQ232H6xwcpn++VErF+8I=
X-Gm-Gg: ASbGncv8Besyxa0cJ8xU/nPPDW9s4zNOMY7cbXkuTjhg5FbyCC9qjmkqpydG8WKJpfA
	3QS9Uuu3iG7j9tQn2PZQvLsiNLUtQsWyUy9ccBHOp0FzzPRxLCyAMI+xNLQsDv2V3oHavFAMGWU
	duWrcQpK6fRz5AFIEuXVKrx1Hoz+AEH/mX10mABv/pR21T8xs9H65V7NcRf3myxgySRY63SgIyA
	2ImokcDuv+/rbzXwfeF834bazaVbarBOL/nnQ9jwc05D7XeGXoJh3Ejjp6A+2RvNxXE5AQ56tf4
	sXMyMNJsSP0dlD9RbCCVlOtgU5EZYt0=
X-Google-Smtp-Source: AGHT+IFXiDdVgmnTH4sfktC8/xKNinP6K1bHXh0LE5bFlepNSrMiJFLvtHvHs4neclwfX3Zl5Vm/Iw==
X-Received: by 2002:a05:600c:5112:b0:434:faa9:5266 with SMTP id 5b1f17b1804b1-436c2b5b491mr121041605e9.13.1736193818909;
        Mon, 06 Jan 2025 12:03:38 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4367086e40esm543882975e9.30.2025.01.06.12.03.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 12:03:38 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Cameron Esfahani <dirty@apple.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Alexander Graf <agraf@csgraf.de>,
	Paul Durrant <paul@xen.org>,
	David Hildenbrand <david@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	xen-devel@lists.xenproject.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-s390x@nongnu.org,
	Riku Voipio <riku.voipio@iki.fi>,
	Anthony PERARD <anthony@xenproject.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	"Edgar E . Iglesias" <edgar.iglesias@amd.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	David Woodhouse <dwmw2@infradead.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Anton Johansson <anjo@rev.ng>
Subject: [RFC PATCH 6/7] accel/hvf: Use CPU_FOREACH_HVF()
Date: Mon,  6 Jan 2025 21:02:57 +0100
Message-ID: <20250106200258.37008-7-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106200258.37008-1-philmd@linaro.org>
References: <20250106200258.37008-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Only iterate over HVF vCPUs when running HVF specific code.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/hvf_int.h  | 4 ++++
 accel/hvf/hvf-accel-ops.c | 9 +++++----
 target/arm/hvf/hvf.c      | 4 ++--
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/system/hvf_int.h b/include/system/hvf_int.h
index 42ae18433f0..3cf64faabd1 100644
--- a/include/system/hvf_int.h
+++ b/include/system/hvf_int.h
@@ -11,6 +11,8 @@
 #ifndef HVF_INT_H
 #define HVF_INT_H
 
+#include "system/hw_accel.h"
+
 #ifdef __aarch64__
 #include <Hypervisor/Hypervisor.h>
 typedef hv_vcpu_t hvf_vcpuid;
@@ -74,4 +76,6 @@ int hvf_put_registers(CPUState *);
 int hvf_get_registers(CPUState *);
 void hvf_kick_vcpu_thread(CPUState *cpu);
 
+#define CPU_FOREACH_HVF(cpu) CPU_FOREACH_HWACCEL(cpu)
+
 #endif
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 945ba720513..bbbe2f8d45b 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -504,7 +504,7 @@ static int hvf_insert_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
         }
     }
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_HVF(cpu) {
         err = hvf_update_guest_debug(cpu);
         if (err) {
             return err;
@@ -543,7 +543,7 @@ static int hvf_remove_breakpoint(CPUState *cpu, int type, vaddr addr, vaddr len)
         }
     }
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_HVF(cpu) {
         err = hvf_update_guest_debug(cpu);
         if (err) {
             return err;
@@ -560,7 +560,7 @@ static void hvf_remove_all_breakpoints(CPUState *cpu)
     QTAILQ_FOREACH_SAFE(bp, &hvf_state->hvf_sw_breakpoints, entry, next) {
         if (hvf_arch_remove_sw_breakpoint(cpu, bp) != 0) {
             /* Try harder to find a CPU that currently sees the breakpoint. */
-            CPU_FOREACH(tmpcpu)
+            CPU_FOREACH_HVF(tmpcpu)
             {
                 if (hvf_arch_remove_sw_breakpoint(tmpcpu, bp) == 0) {
                     break;
@@ -572,7 +572,7 @@ static void hvf_remove_all_breakpoints(CPUState *cpu)
     }
     hvf_arch_remove_all_hw_breakpoints();
 
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_HVF(cpu) {
         hvf_update_guest_debug(cpu);
     }
 }
@@ -581,6 +581,7 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
+    ops->get_cpus_queue = hw_accel_get_cpus_queue;
     ops->create_vcpu_thread = hvf_start_vcpu_thread;
     ops->kick_vcpu_thread = hvf_kick_vcpu_thread;
 
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 0afd96018e0..13400ff0d5f 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -2269,10 +2269,10 @@ static void hvf_arch_set_traps(void)
 
     /* Check whether guest debugging is enabled for at least one vCPU; if it
      * is, enable exiting the guest on all vCPUs */
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_HVF(cpu) {
         should_enable_traps |= cpu->accel->guest_debug_enabled;
     }
-    CPU_FOREACH(cpu) {
+    CPU_FOREACH_HVF(cpu) {
         /* Set whether debug exceptions exit the guest */
         r = hv_vcpu_set_trap_debug_exceptions(cpu->accel->fd,
                                               should_enable_traps);
-- 
2.47.1


