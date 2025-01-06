Return-Path: <kvm+bounces-34633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CEB4A03105
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:03:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B4343A3B6D
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396E91D5CF4;
	Mon,  6 Jan 2025 20:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BeM+Muqn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788411DED44
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193800; cv=none; b=txwyjvqiGWRM2CYN8eZZsixjNhdmZLASYrFjcW4TzseoCKmqYsUx42ph59ESp7viu6KTdIqTEN/vkymZZjoR4n1DVwi/TpfG+ATML1INXwMa8nozKRBsM2B0y/Js/eYI5evQXUwagX3UyesqKwHAY7VZGtT3nCrXkFOhzogXyGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193800; c=relaxed/simple;
	bh=Gzob3myfhJ77HbtIdJeXGuH6Ojs0DaIU+RlrJQQt4nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mvsIreYZqMP0iGEsnThCUND7QudJ4bjEMHJ8xRcwC8pD3FfOQbzMiGCznXq0/4t/8h3IoVe5doai1iGpvGNSDFARGjbcbUL//EkAgsBwLVEiVoRKazrxcE9qOYn35JWxZJxq6UZpnYNEpBIHboAHgccGrfoETTQzNiEZflK+7QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BeM+Muqn; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43635796b48so89317975e9.0
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:03:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736193795; x=1736798595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xubr80DdDK1TQnuEw657hT2ILmCSL1Bi/K/I0ME5hpI=;
        b=BeM+Muqn9+y2leTxSHxPDumk6kl8KeObfVlhu+r9IttzZMdG4DZ1Q3ZgPytZotef//
         RwclS4eYj+QRg4YmcMG/IdRyII3Uwxk8Zp6jLA2mv34CgYJCEgDCqzvJ26Xvac4b3OG6
         /Gt4srgkEwUP0JcqnQ+Ap/PdiAzOAf0onIm4/WbTF4kFVmi72gwnqkoMEYYFY/ur4KC5
         Pw+ahcTVA2V1GDy92TjGxG5zK4K8lDX7/eIS7juHI2FoORM1WvVFKP9U5Uilaa8vOBKK
         N2SW2KIUePyXuZx7ZMhLsaoM5SsVO4UDNqwvRoZ+hm51jCTrVAH+WMSTgaHknale0byT
         xGlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736193795; x=1736798595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xubr80DdDK1TQnuEw657hT2ILmCSL1Bi/K/I0ME5hpI=;
        b=lG29La2ezNJznJKK/cb8fLfftTd4gXG97hRjElb1al5uYU4I8TCWf5/mkT18evuAqq
         FpBaCeg1DkuzuQAxqEqinAva/BYgmJVxET3jW79cLu4dNyBQSavRFbWyJ8s+XreN2nJw
         OBuDaIBsbsMTBIM6gAMiI+y48YJHovlmRHRCQ+G4dOsK9p1CQzHxX/pJSuYra7WKsLwe
         sh1gPcxE6USuG/MkGc1FAaXxjRMWywpQB3OvIdjW9svR4enLn6ZryJVymlZ9POmhRUuz
         8pnCFmYITwfouKUuOUse8AAqedYzfVDmRjLD8vnGiBdXBl9R7SPCBybVkV55QWfTEx5z
         o2WA==
X-Forwarded-Encrypted: i=1; AJvYcCW4TyBMiTLClD9beVwH8+Q4h92p49lnfLI2UIk8255Lw53ILXQpD3GKgTha3hdZFvScrGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPn6WXuVRYuC5Wgy4ZEOl+468ml2qqsNI818Uzxjg9mtRH5JL9
	xFlthu0oyJBcoqa78FGAr5aPnm51LWQObIgJnMczAPRfnqW+QZjJJ5bY9ts6c7w=
X-Gm-Gg: ASbGncvhtn25dnvk6Sme3ylsZnfg3ZB1SE5C1s2EocQtjBznIqXiinRWNR7Mq0U7/p+
	7yVPJo18olH4m7DdwsQ78D2MjpmmhF4o8JylHrg5T/go50ncTU74OOL0Eqp85JRjrsPJISb+GC+
	L4RNNMdsBscrWNd4Ht8zd95ECGw+MrRfzHHo0Lu4ktCiX02VB4XVhymOA6TVraRQNjrpcF47V7w
	KoA5KoEf9ANi0XXRqXf5IHjm4xOQB6pTrpnYjTVqHvDZIwFIIxxYCNZznmjP5SoA/tPKAFdBX/k
	o3cZFhwl55vhLeyFrGttXhzxO6zIsEk=
X-Google-Smtp-Source: AGHT+IG6hn6gQ1rEDpo0RUo5rK6HsOddWfOpcS85mXtVNMxlfkCCUdnnKaA6rQB2Q6OTZ5JLDkEevw==
X-Received: by 2002:a05:600c:1d12:b0:436:1b86:f05 with SMTP id 5b1f17b1804b1-436dc20b0c1mr4405765e9.11.1736193795597;
        Mon, 06 Jan 2025 12:03:15 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4366128a353sm577748615e9.42.2025.01.06.12.03.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 12:03:15 -0800 (PST)
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
Subject: [RFC PATCH 2/7] cpus: Introduce AccelOpsClass::get_cpus_queue()
Date: Mon,  6 Jan 2025 21:02:53 +0100
Message-ID: <20250106200258.37008-3-philmd@linaro.org>
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

We want the ability to iterate over vCPUs of a specific
accelerator.  Introduce cpus_get_accel_cpus_queue() to
be used by accelerator common code, and expose the
get_cpus_queue() in AccelOpsClass, so each accelerator
can register its own queue of vCPUs.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/cpu.h      |  8 ++++++++
 include/system/accel-ops.h |  6 ++++++
 accel/tcg/user-exec-stub.c |  5 +++++
 cpu-common.c               | 10 ++++++++++
 system/cpus.c              |  5 +++++
 5 files changed, 34 insertions(+)

diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 48d90f50a71..5ae9bb64d6e 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -591,6 +591,14 @@ static inline CPUArchState *cpu_env(CPUState *cpu)
 typedef QTAILQ_HEAD(CPUTailQ, CPUState) CPUTailQ;
 extern CPUTailQ cpus_queue;
 
+/**
+ * cpus_get_accel_cpus_queue:
+ * @cpu: The vCPU to get the accelerator #CPUTailQ.
+ *
+ * Returns the #CPUTailQ associated with the accelerator of the vCPU.
+ */
+CPUTailQ *cpus_get_accel_cpus_queue(CPUState *cpu);
+
 #define first_cpu        QTAILQ_FIRST_RCU(&cpus_queue)
 #define CPU_NEXT(cpu)    QTAILQ_NEXT_RCU(cpu, node)
 #define CPU_FOREACH(cpu) QTAILQ_FOREACH_RCU(cpu, &cpus_queue, node)
diff --git a/include/system/accel-ops.h b/include/system/accel-ops.h
index 137fb96d444..fe59f728bfc 100644
--- a/include/system/accel-ops.h
+++ b/include/system/accel-ops.h
@@ -12,6 +12,7 @@
 
 #include "exec/vaddr.h"
 #include "qom/object.h"
+#include "hw/core/cpu.h"
 
 #define ACCEL_OPS_SUFFIX "-ops"
 #define TYPE_ACCEL_OPS "accel" ACCEL_OPS_SUFFIX
@@ -37,6 +38,11 @@ struct AccelOpsClass {
     bool (*cpus_are_resettable)(void);
     void (*cpu_reset_hold)(CPUState *cpu);
 
+    /**
+     * get_cpus_queue:
+     * Returns the #CPUTailQ maintained by this accelerator.
+     */
+    CPUTailQ *(*get_cpus_queue)(void);
     void (*create_vcpu_thread)(CPUState *cpu); /* MANDATORY NON-NULL */
     void (*kick_vcpu_thread)(CPUState *cpu);
     bool (*cpu_thread_is_idle)(CPUState *cpu);
diff --git a/accel/tcg/user-exec-stub.c b/accel/tcg/user-exec-stub.c
index 4fbe2dbdc88..cb76cec76be 100644
--- a/accel/tcg/user-exec-stub.c
+++ b/accel/tcg/user-exec-stub.c
@@ -18,6 +18,11 @@ void cpu_exec_reset_hold(CPUState *cpu)
 {
 }
 
+CPUTailQ *cpus_get_accel_cpus_queue(CPUState *cpu)
+{
+    return NULL;
+}
+
 /* User mode emulation does not support record/replay yet.  */
 
 bool replay_exception(void)
diff --git a/cpu-common.c b/cpu-common.c
index 4248b2d727e..ff8db9c7f9d 100644
--- a/cpu-common.c
+++ b/cpu-common.c
@@ -82,6 +82,7 @@ unsigned int cpu_list_generation_id_get(void)
 void cpu_list_add(CPUState *cpu)
 {
     static bool cpu_index_auto_assigned;
+    CPUTailQ *accel_cpus_queue = cpus_get_accel_cpus_queue(cpu);
 
     QEMU_LOCK_GUARD(&qemu_cpu_list_lock);
     if (cpu->cpu_index == UNASSIGNED_CPU_INDEX) {
@@ -92,17 +93,26 @@ void cpu_list_add(CPUState *cpu)
         assert(!cpu_index_auto_assigned);
     }
     QTAILQ_INSERT_TAIL_RCU(&cpus_queue, cpu, node);
+    if (accel_cpus_queue) {
+        QTAILQ_INSERT_TAIL_RCU(accel_cpus_queue, cpu, node);
+    }
+
     cpu_list_generation_id++;
 }
 
 void cpu_list_remove(CPUState *cpu)
 {
+    CPUTailQ *accel_cpus_queue = cpus_get_accel_cpus_queue(cpu);
+
     QEMU_LOCK_GUARD(&qemu_cpu_list_lock);
     if (!QTAILQ_IN_USE(cpu, node)) {
         /* there is nothing to undo since cpu_exec_init() hasn't been called */
         return;
     }
 
+    if (accel_cpus_queue) {
+        QTAILQ_REMOVE_RCU(accel_cpus_queue, cpu, node);
+    }
     QTAILQ_REMOVE_RCU(&cpus_queue, cpu, node);
     cpu->cpu_index = UNASSIGNED_CPU_INDEX;
     cpu_list_generation_id++;
diff --git a/system/cpus.c b/system/cpus.c
index 99f83806c16..972df6ab061 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -209,6 +209,11 @@ void cpu_exec_reset_hold(CPUState *cpu)
     }
 }
 
+CPUTailQ *cpus_get_accel_cpus_queue(CPUState *cpu)
+{
+    return cpus_accel ? cpus_accel->get_cpus_queue() : NULL;
+}
+
 int64_t cpus_get_virtual_clock(void)
 {
     /*
-- 
2.47.1


