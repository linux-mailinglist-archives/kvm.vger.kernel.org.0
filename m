Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1B320A35
	for <lists+kvm@lfdr.de>; Sun, 21 Feb 2021 13:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhBUMMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Feb 2021 07:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhBUMMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Feb 2021 07:12:02 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C1AC06178B
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 04:11:21 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id c8so47176309ljd.12
        for <kvm@vger.kernel.org>; Sun, 21 Feb 2021 04:11:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x0RBaipR9PXwbELxNszRAUv20CSSLCJyKfQGgE/hhnk=;
        b=ODJnb0rwJwJ/T0ogYdEwmDoTrrm5zW2/nIx6EcbOejtDn8PCO0zYh3Zq0DML5X3BUC
         75JP4E+8PRBp1/JmIkr/XG3v+bjuxps7pj/0uYNpVPzl5Jkji4FNfB00cjczUEzu2eza
         N3VRuN/FxCwDIROcRGHdS3Bl9zGdr031IvSa4Pu239Q4XDxJBRRGacPzDLpFbL4oi/6Z
         eScLL2OO2wJoGZNq+oAM59EzvrvsAR3Oz5UfjG5hQNBMlyKpIC6qY/NpR5HoLGQeUoop
         tFKnKQNrEpqIuOO6l85byAPR7U+luT+A9cLnwPgZ8dqmASF7EiMAV3W0sX/lTCpHu56i
         ZhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x0RBaipR9PXwbELxNszRAUv20CSSLCJyKfQGgE/hhnk=;
        b=bMHxKYwIHdo+KFIwJ71nv2L0JIyrzxR9Tl4JNOfkpZDPM05fhiNuoodPavMcEh8U6K
         m9YhqgHqCCEES+oyR0csmtcNipUxTj4e13Zt94Y2hb0FDOYG3qdva9M+1+kVO71g22Ef
         cUPRA8BkzbdUTl6b5dWkJ9F2qHPjrJJ2v8752bXX3PsCET54/tpZVw6cuhcwkWfxUMsi
         qsD1VTghXK+APpiMy+BZBITU6NJ/OBlTttZ1YsSrspgNgaFDSXdCoT2e1e6dnf/5W8rN
         gmso9JetN5HBdPsuQmyDgGrK/DIJLwcgztUDmDghnJmweQbyGqTAY5iBP8Ib5nByLGKm
         Godw==
X-Gm-Message-State: AOAM532CWLLIeoDXeqAWR7gXaDOsWNvSH4WBBmgwVS3aAfvQq0RUSgVV
        v0nnLmM5Dsa3nY4bmxPAjVDBRVrFrNLNIPxg
X-Google-Smtp-Source: ABdhPJxy/h4mo1fs65vRplUzgzecBcjEk3a8Zk4QPWd0KqwwYLPhr0DcFwx5YWSUF7PxWjkjpQd2Ag==
X-Received: by 2002:a05:651c:288:: with SMTP id b8mr10973238ljo.133.1613909480018;
        Sun, 21 Feb 2021 04:11:20 -0800 (PST)
Received: from localhost.localdomain (37-145-186-126.broadband.corbina.ru. [37.145.186.126])
        by smtp.gmail.com with ESMTPSA id q6sm1547715lfn.23.2021.02.21.04.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Feb 2021 04:11:19 -0800 (PST)
From:   Elena Afanasova <eafanasova@gmail.com>
To:     kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com,
        jasowang@redhat.com, mst@redhat.com, cohuck@redhat.com,
        john.levon@nutanix.com, Elena Afanasova <eafanasova@gmail.com>
Subject: [RFC v3 4/5] KVM: add ioregionfd context
Date:   Sun, 21 Feb 2021 15:04:40 +0300
Message-Id: <4436ef071e55d88ff3996b134cc2303053581242.1613828727.git.eafanasova@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1613828726.git.eafanasova@gmail.com>
References: <cover.1613828726.git.eafanasova@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for ioregionfd cmds/replies serialization.

Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
---
v3:
 - add comment
 - drop kvm_io_bus_finish/prepare()

 virt/kvm/ioregion.c | 164 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 135 insertions(+), 29 deletions(-)

diff --git a/virt/kvm/ioregion.c b/virt/kvm/ioregion.c
index 1e1c7772d274..d53e3d1cd2ff 100644
--- a/virt/kvm/ioregion.c
+++ b/virt/kvm/ioregion.c
@@ -1,10 +1,39 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kvm_host.h>
-#include <linux/fs.h>
+#include <linux/wait.h>
 #include <kvm/iodev.h>
 #include "eventfd.h"
 #include <uapi/linux/ioregion.h>
 
+/* ioregions that share the same rfd are serialized so that only one vCPU
+ * thread sends a struct ioregionfd_cmd to userspace at a time. This
+ * ensures that the struct ioregionfd_resp received from userspace will
+ * be processed by the one and only vCPU thread that sent it.
+ *
+ * A waitqueue is used to wake up waiting vCPU threads in order. Most of
+ * the time the waitqueue is unused and the lock is not contended.
+ * For best performance userspace should set up ioregionfds so that there
+ * is no contention (e.g. dedicated ioregionfds for queue doorbell
+ * registers on multi-queue devices).
+ */
+struct ioregionfd {
+	wait_queue_head_t	  wq;
+	struct file		 *rf;
+	struct kref		  kref;
+	bool			  busy;
+};
+
+struct ioregion {
+	struct list_head	  list;
+	u64			  paddr;   /* guest physical address */
+	u64			  size;    /* size in bytes */
+	struct file		 *wf;
+	u64			  user_data; /* opaque token used by userspace */
+	struct kvm_io_device	  dev;
+	bool			  posted_writes;
+	struct ioregionfd	 *ctx;
+};
+
 void
 kvm_ioregionfd_init(struct kvm *kvm)
 {
@@ -13,29 +42,28 @@ kvm_ioregionfd_init(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->ioregions_pio);
 }
 
-struct ioregion {
-	struct list_head     list;
-	u64                  paddr;  /* guest physical address */
-	u64                  size;   /* size in bytes */
-	struct file         *rf;
-	struct file         *wf;
-	u64                  user_data; /* opaque token used by userspace */
-	struct kvm_io_device dev;
-	bool                 posted_writes;
-};
-
 static inline struct ioregion *
 to_ioregion(struct kvm_io_device *dev)
 {
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
-	if (p->rf)
-		fput(p->rf);
+	if (p->ctx) {
+		fput(p->ctx->rf);
+		kref_put(&p->ctx->kref, ctx_free);
+	}
 	fput(p->wf);
 	list_del(&p->list);
 	kfree(p);
@@ -90,6 +118,30 @@ ioregion_save_ctx(struct kvm_vcpu *vcpu, bool in, gpa_t addr, u8 state, void *va
 	vcpu->ioregion_ctx.in = in;
 }
 
+static inline void
+ioregion_lock_ctx(struct ioregionfd *ctx)
+{
+	if (!ctx)
+		return;
+
+	spin_lock(&ctx->wq.lock);
+	wait_event_interruptible_exclusive_locked(ctx->wq, !ctx->busy);
+	ctx->busy = true;
+	spin_unlock(&ctx->wq.lock);
+}
+
+static inline void
+ioregion_unlock_ctx(struct ioregionfd *ctx)
+{
+	if (!ctx)
+		return;
+
+	spin_lock(&ctx->wq.lock);
+	ctx->busy = false;
+	wake_up_locked(&ctx->wq);
+	spin_unlock(&ctx->wq.lock);
+}
+
 static int
 ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	      int len, void *val)
@@ -115,11 +167,15 @@ ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 		}
 	}
 
+	ioregion_lock_ctx(p->ctx);
+
 send_cmd:
 	memset(&buf, 0, sizeof(buf));
 	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_READ,
-		      1, p->user_data, NULL))
-		return -EOPNOTSUPP;
+		      1, p->user_data, NULL)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
 	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
@@ -129,14 +185,15 @@ ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	}
 	if (ret != sizeof(buf.cmd)) {
 		ret = (ret < 0) ? ret : -EIO;
-		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+		ret = (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+		goto out;
 	}
-	if (!p->rf)
+	if (!p->ctx)
 		return 0;
 
 get_repl:
 	memset(&buf, 0, sizeof(buf));
-	ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
+	ret = kernel_read(p->ctx->rf, &buf.resp, sizeof(buf.resp), 0);
 	state = (ret == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
 	if (signal_pending(current) && state == GET_REPLY) {
 		ioregion_save_ctx(vcpu, 1, addr, state, val);
@@ -144,12 +201,17 @@ ioregion_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	}
 	if (ret != sizeof(buf.resp)) {
 		ret = (ret < 0) ? ret : -EIO;
-		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+		ret = (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+		goto out;
 	}
 
 	memcpy(val, &buf.resp.data, len);
+	ret = 0;
 
-	return 0;
+out:
+	ioregion_unlock_ctx(p->ctx);
+
+	return ret;
 }
 
 static int
@@ -177,11 +239,15 @@ ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 		}
 	}
 
+	ioregion_lock_ctx(p->ctx);
+
 send_cmd:
 	memset(&buf, 0, sizeof(buf));
 	if (!pack_cmd(&buf.cmd, addr - p->paddr, len, IOREGIONFD_CMD_WRITE,
-		      p->posted_writes ? 0 : 1, p->user_data, val))
-		return -EOPNOTSUPP;
+		      p->posted_writes ? 0 : 1, p->user_data, val)) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 
 	ret = kernel_write(p->wf, &buf.cmd, sizeof(buf.cmd), 0);
 	state = (ret == sizeof(buf.cmd)) ? GET_REPLY : SEND_CMD;
@@ -191,13 +257,14 @@ ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 	}
 	if (ret != sizeof(buf.cmd)) {
 		ret = (ret < 0) ? ret : -EIO;
-		return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+		ret = (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+		goto out;
 	}
 
 get_repl:
 	if (!p->posted_writes) {
 		memset(&buf, 0, sizeof(buf));
-		ret = kernel_read(p->rf, &buf.resp, sizeof(buf.resp), 0);
+		ret = kernel_read(p->ctx->rf, &buf.resp, sizeof(buf.resp), 0);
 		state = (ret == sizeof(buf.resp)) ? COMPLETE : GET_REPLY;
 		if (signal_pending(current) && state == GET_REPLY) {
 			ioregion_save_ctx(vcpu, 0, addr, state, (void *)val);
@@ -205,11 +272,16 @@ ioregion_write(struct kvm_vcpu *vcpu, struct kvm_io_device *this, gpa_t addr,
 		}
 		if (ret != sizeof(buf.resp)) {
 			ret = (ret < 0) ? ret : -EIO;
-			return (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+			ret = (ret == -EAGAIN || ret == -EWOULDBLOCK) ? -EINVAL : ret;
+			goto out;
 		}
 	}
+	ret = 0;
 
-	return 0;
+out:
+	ioregion_unlock_ctx(p->ctx);
+
+	return ret;
 }
 
 /*
@@ -285,6 +357,33 @@ get_bus_from_flags(__u32 flags)
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
+	if (!p->ctx)
+		return false;
+
+	p->ctx->rf = rf;
+	p->ctx->busy = false;
+	init_waitqueue_head(&p->ctx->wq);
+	kref_get(&p->ctx->kref);
+
+	return true;
+}
+
 int
 kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bus_idx)
 {
@@ -309,11 +408,10 @@ kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bu
 	}
 
 	INIT_LIST_HEAD(&p->list);
+	p->wf = wfile;
 	p->paddr = args->guest_paddr;
 	p->size = args->memory_size;
 	p->user_data = args->user_data;
-	p->rf = rfile;
-	p->wf = wfile;
 	p->posted_writes = args->flags & KVM_IOREGION_POSTED_WRITES;
 
 	mutex_lock(&kvm->slots_lock);
@@ -322,6 +420,12 @@ kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bu
 		ret = -EEXIST;
 		goto unlock_fail;
 	}
+
+	if (rfile && !ioregion_get_ctx(kvm, p, rfile, bus_idx)) {
+		ret = -ENOMEM;
+		goto unlock_fail;
+	}
+
 	kvm_iodevice_init(&p->dev, &ioregion_ops);
 	ret = kvm_io_bus_register_dev(kvm, bus_idx, p->paddr, p->size,
 				      &p->dev);
@@ -335,6 +439,8 @@ kvm_set_ioregion_idx(struct kvm *kvm, struct kvm_ioregion *args, enum kvm_bus bu
 
 unlock_fail:
 	mutex_unlock(&kvm->slots_lock);
+	if (p->ctx)
+		kref_put(&p->ctx->kref, ctx_free);
 	kfree(p);
 fail:
 	if (rfile)
-- 
2.25.1

