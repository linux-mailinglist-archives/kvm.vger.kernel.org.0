Return-Path: <kvm+bounces-34636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E647A03108
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 21:03:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3096C7A05B6
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 20:03:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9944A1DF24B;
	Mon,  6 Jan 2025 20:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ANl7Or5x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8F51DF981
	for <kvm@vger.kernel.org>; Mon,  6 Jan 2025 20:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736193818; cv=none; b=QorhqyUz0OVHmJDJ1Y6F0x/QyPc6CFgdWqW1Y6EZ2xRbZYhhOUf4VT4nAwdC0ISZJWWY3VlvPelqlBFtXnFwGgfcaresbxsdbqWS0hsSqPUSi1YZNiAu7qZbOa05Fe8+riLwhwcIgewC/caa53GEejBLLLrki/9pmNAiNdV+Ijs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736193818; c=relaxed/simple;
	bh=+IrMKbazEv/2Tm1YENOmcIwzVPuD29IvWSa/xeIasLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nb8IXyUu7ugRVF0ecSO0CL//m/FmO+FjGbUQzeDNE/ekEH1JXG04Ff/aSA0LxnPJji5NKtHtb9qt4Z7oENJyn1mqsxfIW/ioKKZeyQnAHHbL8BbzH2VO5T1Cfh4PbZonztyLRhmyEGnjqHDnFUUoxKVwPQU30YVmdyASWRb65Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ANl7Or5x; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-385e1fcb0e1so8141555f8f.2
        for <kvm@vger.kernel.org>; Mon, 06 Jan 2025 12:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1736193813; x=1736798613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zxJ3+xb03FIgQb6HyhO+0vTNSYN1GRLEa0EnbI36swA=;
        b=ANl7Or5xlPd68N9rNBVoKoj1XMVU6uQ0kH/3LyN3iFMeW/fEPCA4ryUIjjhqCuvmvk
         mrJ/u0dtqvBtQuIxm89ZiLstVFp81VmhsQJpGLZ/loI08j7qeCv1sUPcxWNy6zQPlL0p
         ZqxYZJL4T7KbEzpHLQsUaEX9sQWB3LuI9fRK2X+U/Ef/IvQFmoH41ngTwZ7LKQ2xdScz
         l6fQOwX+s5cpcRY8wxrM66nwiiZjvQgx8lAheWYVsMV/OKU9KkYp9KcOYffO3ZIGgr63
         5RowGTPa7hZu7THsbWLPzcJYc9IgjFi4l679bX4rVJRQZ2v7vNBAMpnHAibs0Xo0tV/6
         62OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736193813; x=1736798613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zxJ3+xb03FIgQb6HyhO+0vTNSYN1GRLEa0EnbI36swA=;
        b=ed25/+YNwKoocmyJyYA0Mg9XxusV+tPVOfKUqln3H21McvOd9i9XmwCQfLphxxl05i
         o7xK30v+WUhFiF/2TLsHwgxBDdJEnBv3JhfZ72iPhkmMnd8xUwML4IOBC8qo0nhO31gZ
         Qnwt9qk5Pjbm4x+1m940btp3O9trJiwkKHa4UYPjvfVd7sv9die08EkrZo8gt6ztrKuS
         NsL0Boj3EoqDztwUwiacoFPgUN5A87JAsS0x95xg5UpIiIqEvUUMYC6dnzP0USga0Bce
         1O3F5Qp9j/OxRpnINcULgoWBLP37pDkT8c9uQtBJ/Dgavi3PEAqy0cXVNTw7MmVGjUOb
         cwgg==
X-Forwarded-Encrypted: i=1; AJvYcCULphsJhmR1AqNwS8643PNhxwiP/1pXCp1qBfespHTrxRdsl3/1JN208zAgXnXfVnV0bk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YysnUCAlUY4mvhT2pPYbieFlKi5tV+4pMFa4alL5ZDlZURS/a2b
	KdGTUOQANQrNqqnteqXDfZ0Erfr3oQohdHPX23spoJjXzLkAxD9u8ZnnVBGvhLE=
X-Gm-Gg: ASbGncuqUadbbHdhGIu0M2GWUKQTwqdmK3UsxhVyGFoXgTkLFqeDwkpLSpArA0VnRII
	BLG4iarYvAjVaijF1ApmPqhEZwrVawRr9PfWa1Hc0qKgXtBLU/o5Z/oerUou5Yr+Jvjw2jZ90sy
	DRptMVvu+6frW0XN87qR5rbU9nct64gdNiR2SIZ+m/OeUE1lr7jS3LMFw0cxQkvCv2Y4qOuhHrM
	7JSwlV2lzqeG7IeyOQNLCdbRTLsOKutAyJk4jrHp2rg9auEvphyT+RzhqDW8ZZThyNf1oZSndmT
	XrLwr/jnMQVJFSC3Qd+obgmQnCLg1Ag=
X-Google-Smtp-Source: AGHT+IGoS13s7EdoAdq3NUY+QaACk4mt67qvYvBPAyuPr3+V1znGvuXeRZNJwXBUnZIrDNw4J4+93w==
X-Received: by 2002:adf:a3d9:0:b0:38a:39ad:3e31 with SMTP id ffacd0b85a97d-38a39ad4128mr24752061f8f.57.1736193813254;
        Mon, 06 Jan 2025 12:03:33 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43656af6d02sm618987535e9.1.2025.01.06.12.03.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 12:03:32 -0800 (PST)
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
Subject: [RFC PATCH 5/7] accel/hw: Implement hw_accel_get_cpus_queue()
Date: Mon,  6 Jan 2025 21:02:56 +0100
Message-ID: <20250106200258.37008-6-philmd@linaro.org>
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

We can only run a single hardware accelerator at a time,
so add a generic hw_accel_get_cpus_queue() helper in
accel-system.c, a file common to all HW accelerators.

Register AccelOpsClass::get_cpus_queue() for each HW
accelerator. Add a generic CPU_FOREACH_HWACCEL() macro.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/hw_accel.h         | 9 +++++++++
 accel/accel-system.c              | 8 ++++++++
 accel/kvm/kvm-accel-ops.c         | 1 +
 accel/xen/xen-all.c               | 1 +
 target/i386/nvmm/nvmm-accel-ops.c | 1 +
 target/i386/whpx/whpx-accel-ops.c | 1 +
 6 files changed, 21 insertions(+)

diff --git a/include/system/hw_accel.h b/include/system/hw_accel.h
index 380e9e640b6..12664cac6f9 100644
--- a/include/system/hw_accel.h
+++ b/include/system/hw_accel.h
@@ -2,6 +2,7 @@
  * QEMU Hardware accelerators support
  *
  * Copyright 2016 Google, Inc.
+ * Copyright 2025 Linaro Ltd.
  *
  * This work is licensed under the terms of the GNU GPL, version 2 or later.
  * See the COPYING file in the top-level directory.
@@ -17,6 +18,14 @@
 #include "system/whpx.h"
 #include "system/nvmm.h"
 
+/* Guard with qemu_cpu_list_lock */
+extern CPUTailQ hw_accel_cpus_queue;
+
+#define CPU_FOREACH_HWACCEL(cpu) \
+            QTAILQ_FOREACH_RCU(cpu, &hw_accel_cpus_queue, node)
+
+CPUTailQ *hw_accel_get_cpus_queue(void);
+
 void cpu_synchronize_state(CPUState *cpu);
 void cpu_synchronize_post_reset(CPUState *cpu);
 void cpu_synchronize_post_init(CPUState *cpu);
diff --git a/accel/accel-system.c b/accel/accel-system.c
index a7596aef59d..60877ea7a28 100644
--- a/accel/accel-system.c
+++ b/accel/accel-system.c
@@ -27,9 +27,17 @@
 #include "qemu/accel.h"
 #include "hw/boards.h"
 #include "system/cpus.h"
+#include "system/hw_accel.h"
 #include "qemu/error-report.h"
 #include "accel-system.h"
 
+CPUTailQ hw_accel_cpus_queue = QTAILQ_HEAD_INITIALIZER(hw_accel_cpus_queue);
+
+CPUTailQ *hw_accel_get_cpus_queue(void)
+{
+    return &hw_accel_cpus_queue;
+}
+
 int accel_init_machine(AccelState *accel, MachineState *ms)
 {
     AccelClass *acc = ACCEL_GET_CLASS(accel);
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index a81e8f3b03b..5f4001860d5 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -93,6 +93,7 @@ static void kvm_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
+    ops->get_cpus_queue = hw_accel_get_cpus_queue;
     ops->create_vcpu_thread = kvm_start_vcpu_thread;
     ops->cpu_thread_is_idle = kvm_vcpu_thread_is_idle;
     ops->cpus_are_resettable = kvm_cpus_are_resettable;
diff --git a/accel/xen/xen-all.c b/accel/xen/xen-all.c
index 852e9fbe5fe..ac5ed2dfb80 100644
--- a/accel/xen/xen-all.c
+++ b/accel/xen/xen-all.c
@@ -150,6 +150,7 @@ static void xen_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
+    ops->get_cpus_queue = hw_accel_get_cpus_queue;
     ops->create_vcpu_thread = dummy_start_vcpu_thread;
 }
 
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index e7b56662fee..bb407c68e14 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -84,6 +84,7 @@ static void nvmm_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
+    ops->get_cpus_queue = hw_accel_get_cpus_queue;
     ops->create_vcpu_thread = nvmm_start_vcpu_thread;
     ops->kick_vcpu_thread = nvmm_kick_vcpu_thread;
 
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index ab2e014c9ea..191214ca81d 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -86,6 +86,7 @@ static void whpx_accel_ops_class_init(ObjectClass *oc, void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
+    ops->get_cpus_queue = hw_accel_get_cpus_queue;
     ops->create_vcpu_thread = whpx_start_vcpu_thread;
     ops->kick_vcpu_thread = whpx_kick_vcpu_thread;
     ops->cpu_thread_is_idle = whpx_vcpu_thread_is_idle;
-- 
2.47.1


