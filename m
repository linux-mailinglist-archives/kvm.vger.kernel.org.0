Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D0B307E78
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhA1SvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 13:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbhA1Sp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 13:45:58 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB10FC06178C
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:45:17 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id v15so4605110ljk.13
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 10:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CFgwpT5IXthdNc6sW9qZn5kyWf1tpKNhXennZuUPtbU=;
        b=RcvvTWTSqljZvQPmh9QjgJ0kfxN9MEfo4TeURzvKJgU1dZ9h79LXY0iAowwYGSSJfm
         4C3yu7Qys7A4lfvcqvkJqXpc4JgLeGnU6JhMB9BrEc6j4jtvqtxxBwnPIbFoGA7rXtvK
         9dO/zPC18LuL5hh8akMF/BV41W3xwwrX8WKCT7jNYUXx3PzCBm3Aet6Mxy7K7Ts+cV4R
         tw2wN1krAc0Nnc+F2o1uaeGciPgy+LZN28FoGAgCquGtAiHoKEeesP1AXZXHHx0OlLXe
         WmkK3mpkIYgQKqUBLvT+nLfVZqEMMrbJ/nz6UF90nSEJYXqupqh7RpY83A8Wn8P0jhmF
         4f6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CFgwpT5IXthdNc6sW9qZn5kyWf1tpKNhXennZuUPtbU=;
        b=g4NnvshHN4ijJ7AQc5OjuM7+eRt1KinIv4Kx32hV4u1akugSONeyEXWX84gsRz9sI6
         nisMz+iwbMqPpbHxjbAm2fh4ERxaEVMUeoIxz1hntNcgEfBdhQKLai7eOv0z6g6uyBCu
         V/Vk5OTAa7jwrB/BuRts+z7tKSs9Mae+w0Z85EWOT4ynoGTbk+XQDzmSVDKRdFLG11CZ
         FpgHxUl7OCwqd7nBGi18TWO4qaROlaHNJVFNDisdp4+euei+GeaElAyMRUvv9pZ8zaP3
         vx67QNQXqWQiywBTKqwAHOmtGo06A98HrtmSSK//LFQ/lG6HR8K8Io79CerPmIg/xbaE
         79Qw==
X-Gm-Message-State: AOAM533C72YpsMKLVTAv0atcJMPpotEGs1EXOvkZaI4zJNFXi4hJ8p2t
        2FM5t6KvGL3ANak61zYtuwW9eNtLR3p9eg==
X-Google-Smtp-Source: ABdhPJzatOaIBYXGHBx4FVJIpyp8dD+pFdIehX75HYOWIYX3gz6OyZzqRwu2JcXVItDhkqP4wLSNDQ==
X-Received: by 2002:a2e:b1c6:: with SMTP id e6mr379139lja.140.1611859515941;
        Thu, 28 Jan 2021 10:45:15 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id k8sm1750508lfg.41.2021.01.28.10.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 10:45:15 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC v2 3/4] KVM: add support for ioregionfd cmds/replies serialization
Date:   Thu, 28 Jan 2021 21:32:22 +0300
Message-Id: <294d8a0e08eff4ec9c8f8f62492f29163e6c4319.1611850291.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1611850290.git.eafanasova@gmail.com>
References: <cover.1611850290.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add ioregionfd context and kvm_io_device_ops->prepare/finish()
in order to serialize all bytes requested by guest.

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
 arch/x86/kvm/x86.c       |  19 ++++++++
 include/kvm/iodev.h      |  14 ++++++
 include/linux/kvm_host.h |   4 ++
 virt/kvm/ioregion.c      | 102 +++++++++++++++++++++++++++++++++------
 virt/kvm/kvm_main.c      |  32 ++++++++++++
 5 files changed, 157 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a04516b531da..393fb0f4bf46 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5802,6 +5802,8 @@ static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
 	int ret = 0;
 	bool is_apic;
 
+	kvm_io_bus_prepare(vcpu, KVM_MMIO_BUS, addr, len);
+
 	do {
 		n = min(len, 8);
 		is_apic = lapic_in_kernel(vcpu) &&
@@ -5823,8 +5825,10 @@ static int vcpu_mmio_write(struct kvm_vcpu *vcpu, gpa_t addr, int len,
 	if (ret == -EINTR) {
 		vcpu->run->exit_reason = KVM_EXIT_INTR;
 		++vcpu->stat.signal_exits;
+		return handled;
 	}
 #endif
+	kvm_io_bus_finish(vcpu, KVM_MMIO_BUS, addr, len);
 
 	return handled;
 }
@@ -5836,6 +5840,8 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 	int ret = 0;
 	bool is_apic;
 
+	kvm_io_bus_prepare(vcpu, KVM_MMIO_BUS, addr, len);
+
 	do {
 		n = min(len, 8);
 		is_apic = lapic_in_kernel(vcpu) &&
@@ -5858,8 +5864,10 @@ static int vcpu_mmio_read(struct kvm_vcpu *vcpu, gpa_t addr, int len, void *v)
 	if (ret == -EINTR) {
 		vcpu->run->exit_reason = KVM_EXIT_INTR;
 		++vcpu->stat.signal_exits;
+		return handled;
 	}
 #endif
+	kvm_io_bus_finish(vcpu, KVM_MMIO_BUS, addr, len);
 
 	return handled;
 }
@@ -6442,6 +6450,10 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 {
 	int r = 0, i;
 
+	kvm_io_bus_prepare(vcpu, KVM_PIO_BUS,
+			   vcpu->arch.pio.port,
+			   vcpu->arch.pio.size);
+
 	for (i = 0; i < vcpu->arch.pio.count; i++) {
 		if (vcpu->arch.pio.in)
 			r = kvm_io_bus_read(vcpu, KVM_PIO_BUS,
@@ -6458,8 +6470,12 @@ static int kernel_pio(struct kvm_vcpu *vcpu, void *pd)
 #ifdef CONFIG_KVM_IOREGION
 	if (vcpu->ioregion_interrupted && r == -EINTR) {
 		vcpu->ioregion_ctx.pio = i;
+		return r;
 	}
 #endif
+	kvm_io_bus_finish(vcpu, KVM_PIO_BUS,
+			  vcpu->arch.pio.port,
+			  vcpu->arch.pio.size);
 
 	return r;
 }
@@ -9309,6 +9325,7 @@ static int complete_ioregion_mmio(struct kvm_vcpu *vcpu)
 		vcpu->mmio_cur_fragment++;
 	}
 
+	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
 	vcpu->mmio_needed = 0;
 	if (!vcpu->ioregion_ctx.in) {
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
@@ -9333,6 +9350,7 @@ static int complete_ioregion_pio(struct kvm_vcpu *vcpu)
 		vcpu->ioregion_ctx.val += vcpu->ioregion_ctx.len;
 	}
 
+	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
 	if (vcpu->ioregion_ctx.in)
 		r = kvm_emulate_instruction(vcpu, EMULTYPE_NO_DECODE);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
@@ -9352,6 +9370,7 @@ static int complete_ioregion_fast_pio(struct kvm_vcpu *vcpu)
 	complete_ioregion_access(vcpu, vcpu->ioregion_ctx.addr,
 				 vcpu->ioregion_ctx.len,
 				 vcpu->ioregion_ctx.val);
+	vcpu->ioregion_ctx.dev->ops->finish(vcpu->ioregion_ctx.dev);
 	srcu_read_unlock(&vcpu->kvm->srcu, idx);
 
 	if (vcpu->ioregion_ctx.in) {
diff --git a/include/kvm/iodev.h b/include/kvm/iodev.h
index d75fc4365746..db8a3c69b7bb 100644
--- a/include/kvm/iodev.h
+++ b/include/kvm/iodev.h
@@ -25,6 +25,8 @@ struct kvm_io_device_ops {
 		     gpa_t addr,
 		     int len,
 		     const void *val);
+	void (*prepare)(struct kvm_io_device *this);
+	void (*finish)(struct kvm_io_device *this);
 	void (*destructor)(struct kvm_io_device *this);
 };
 
@@ -55,6 +57,18 @@ static inline int kvm_iodevice_write(struct kvm_vcpu *vcpu,
 				 : -EOPNOTSUPP;
 }
 
+static inline void kvm_iodevice_prepare(struct kvm_io_device *dev)
+{
+	if (dev->ops->prepare)
+		dev->ops->prepare(dev);
+}
+
+static inline void kvm_iodevice_finish(struct kvm_io_device *dev)
+{
+	if (dev->ops->finish)
+		dev->ops->finish(dev);
+}
+
 static inline void kvm_iodevice_destructor(struct kvm_io_device *dev)
 {
 	if (dev->ops->destructor)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5cfdecfca6db..f6b9ff4c468d 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -194,6 +194,10 @@ void kvm_io_bus_unregister_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 			       struct kvm_io_device *dev);
 struct kvm_io_device *kvm_io_bus_get_dev(struct kvm *kvm, enum kvm_bus bus_idx,
 					 gpa_t addr);
+void kvm_io_bus_prepare(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
+			int len);
+void kvm_io_bus_finish(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
+		       int len);
 
 #ifdef CONFIG_KVM_ASYNC_PF
 struct kvm_async_pf {
diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
index da38124e1418..3474090ccc8c 100644
--- a/virt/kvm/ioregion.c
+++ b/virt/kvm/ioregion.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kvm_host.h>
-#include <linux/fs.h>
+#include <linux/wait.h>
 #include <kvm/iodev.h>
 #include "eventfd.h"
 #include <uapi/linux/ioregion.h>
@@ -12,15 +12,23 @@ kvm_ioregionfd_init(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->ioregions_pio);
 }
 
+/* Serializes ioregionfd cmds/replies */
+struct ioregionfd {
+	wait_queue_head_t	  wq;
+	struct file		 *rf;
+	struct kref		  kref;
+	bool			  busy;
+};
+
 struct ioregion {
-	struct list_head     list;
-	u64                  paddr;  /* guest physical address */
-	u64                  size;   /* size in bytes */
-	struct file         *rf;
-	struct file         *wf;
-	u64                  user_data; /* opaque token used by userspace */
-	struct kvm_io_device dev;
-	bool                 posted_writes;
+	struct list_head	  list;
+	u64			  paddr;   /* guest physical address */
+	u64			  size;    /* size in bytes */
+	struct file		 *wf;
+	u64			  user_data; /* opaque token used by userspace */
+	struct kvm_io_device	  dev;
+	bool			  posted_writes;
+	struct ioregionfd	 *ctx;
 };
 
 static inline struct ioregion *
@@ -29,13 +37,22 @@ to_ioregion(struct kvm_io_device *dev)
 	return container_of(dev, struct ioregion, dev);
 }
 
+/* assumes kvm->slots_lock held */
+static void ctx_free(struct kref *kref)
+{
+	struct ioregionfd *ctx = container_of(kref, struct ioregionfd, kref);
+
+	kfree(ctx);
+}
+
 /* assumes kvm->slots_lock held */
 static void
 ioregion_release(struct ioregion *p)
 {
-	fput(p->rf);
+	fput(p->ctx->rf);
 	fput(p->wf);
 	list_del(&p->list);
+	kref_put(&p->ctx->kref, ctx_free);
 	kfree(p);
 }
 
@@ -94,6 +111,28 @@ ioregion_save_ctx(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 	vcpu->ioregion_ctx.in = in;
 }
 
+static void
+ioregion_prepare(struct kvm_io_device *this)
+{
+	struct ioregion *p = to_ioregion(this);
+
+	spin_lock(&p->ctx->wq.lock);
+	wait_event_interruptible_exclusive_locked(p->ctx->wq, !p->ctx->busy);
+	p->ctx->busy = true;
+	spin_unlock(&p->ctx->wq.lock);
+}
+
+static void
+ioregion_finish(struct kvm_io_device *this)
+{
+	struct ioregion *p = to_ioregion(this);
+
+	spin_lock(&p->ctx->wq.lock);
+	p->ctx->busy = false;
+	wake_up_locked(&p->ctx->wq);
+	spin_unlock(&p->ctx->wq.lock);
+}
+
 static int
 ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	      int len, void *val)
@@ -142,7 +181,7 @@ ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 
 get_repl:
 	memset(&buf, 0, sizeof(buf));
-	ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
+	ret = kernel_read(p->ctx->rf, &buf.resp, sizeof(buf.resp), 0);
 	state += (ret == sizeof(buf.resp));
 	if (signal_pending(current)) {
 		ioregion_save_ctx(vcpu, this, 1, addr, len, buf.resp.data, state, val);
@@ -209,7 +248,7 @@ ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 get_repl:
 	if (!p->posted_writes) {
 		memset(&buf, 0, sizeof(buf));
-		ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
+		ret = kernel_read(p->ctx->rf, &buf.resp, sizeof(buf.resp), 0);
 		state += (ret == sizeof(buf.resp));
 		if (signal_pending(current)) {
 			ioregion_save_ctx(vcpu, this, 0, addr, len,
@@ -240,6 +279,8 @@ ioregion_destructor(struct kvm_io_device *this)
 static const struct kvm_io_device_ops ioregion_ops = {
 	.read       = ioregion_read,
 	.write      = ioregion_write,
+	.prepare    = ioregion_prepare,
+	.finish     = ioregion_finish,
 	.destructor = ioregion_destructor,
 };
 
@@ -295,6 +336,34 @@ get_bus_from_flags(__u32 flags)
 	return KVM_MMIO_BUS;
 }
 
+/* assumes kvm->slots_lock held */
+static bool
+ioregion_get_ctx(struct kvm *kvm, struct ioregion *p, struct file *rf, int bus_idx)
+{
+	struct ioregion *_p;
+	struct list_head *ioregions;
+
+	ioregions = get_ioregion_list(kvm, bus_idx);
+	list_for_each_entry(_p, ioregions, list)
+		if (file_inode(_p->ctx->rf)->i_ino == file_inode(rf)->i_ino) {
+			p->ctx = _p->ctx;
+			kref_get(&p->ctx->kref);
+			return true;
+		}
+
+	p->ctx = kzalloc(sizeof(*p->ctx), GFP_KERNEL_ACCOUNT);
+	if (!p->ctx) {
+		kfree(p);
+		return false;
+	}
+	p->ctx->rf = rf;
+	p->ctx->busy = false;
+	init_waitqueue_head(&p->ctx->wq);
+	kref_get(&p->ctx->kref);
+
+	return true;
+}
+
 int
 kvm_set_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
 {
@@ -327,11 +396,10 @@ kvm_set_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
 	}
 
 	INIT_LIST_HEAD(&p->list);
+	p->wf = wfile;
 	p->paddr = args->guest_paddr;
 	p->size = args->memory_size;
 	p->user_data = args->user_data;
-	p->rf = rfile;
-	p->wf = wfile;
 	p->posted_writes = args->flags & KVM_IOREGION_POSTED_WRITES;
 	bus_idx = get_bus_from_flags(args->flags);
 
@@ -341,6 +409,12 @@ kvm_set_ioregion(struct kvm *kvm, struct kvm_ioregion *args)
 		ret = -EEXIST;
 		goto unlock_fail;
 	}
+
+	if (!ioregion_get_ctx(kvm, p, rfile, bus_idx)) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	kvm_iodevice_init(&p->dev, &ioregion_ops);
 	ret = kvm_io_bus_register_dev(kvm, bus_idx, p->paddr, p->size,
 				      &p->dev);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index df387857f51f..096504a6cc62 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4308,6 +4308,38 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	return r < 0 ? r : 0;
 }
 
+void kvm_io_bus_prepare(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr, int len)
+{
+	struct kvm_io_bus *bus;
+	int idx;
+
+	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
+	if (!bus)
+		return;
+
+	idx = kvm_io_bus_get_first_dev(bus, addr, len);
+	if (idx < 0)
+		return;
+
+	kvm_iodevice_prepare(bus->range[idx].dev);
+}
+
+void kvm_io_bus_finish(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr, int len)
+{
+	struct kvm_io_bus *bus;
+	int idx;
+
+	bus = srcu_dereference(vcpu->kvm->buses[bus_idx], &vcpu->kvm->srcu);
+	if (!bus)
+		return;
+
+	idx = kvm_io_bus_get_first_dev(bus, addr, len);
+	if (idx < 0)
+		return;
+
+	kvm_iodevice_finish(bus->range[idx].dev);
+}
+
 /* Caller must hold slots_lock. */
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
-- 
2.25.1

