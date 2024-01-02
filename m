Return-Path: <kvm+bounces-5438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03305821ECD
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 16:35:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DC6B1F22ECD
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 15:35:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E1F14F7B;
	Tue,  2 Jan 2024 15:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S9JaVXU4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F4314F67
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 15:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704209740;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C6keNf8ENMxa5hxSNThwu7kx0Y76THaDxXwlioY2QjA=;
	b=S9JaVXU4EYR9mHJGZXe5T90YMQZms8ZmQXhL/5NI3VAixVEHu+vu7yFw2Dekwu3jSHJfai
	4sg2kAm+/DNjcI+C1/jIBVXP5AhZT7Esg2ane/1tW5ZVi2SpBzZiGhPNyF/xaS6eFIwHsR
	gMNIt00AQR9Z8n4QilexrDwvSe8i9j0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-Bm2rbuoVOe6GrPhdPQjYsQ-1; Tue,
 02 Jan 2024 10:35:39 -0500
X-MC-Unique: Bm2rbuoVOe6GrPhdPQjYsQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 691CB1C04B4C;
	Tue,  2 Jan 2024 15:35:38 +0000 (UTC)
Received: from localhost (unknown [10.39.193.188])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8BFAE2027042;
	Tue,  2 Jan 2024 15:35:37 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: Hanna Reitz <hreitz@redhat.com>,
	qemu-riscv@nongnu.org,
	Roman Bolshakov <rbolshakov@ddn.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Thomas Huth <thuth@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	qemu-block@nongnu.org,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Fam Zheng <fam@euphon.net>,
	Gerd Hoffmann <kraxel@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	John Snow <jsnow@redhat.com>,
	Stafford Horne <shorne@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	David Hildenbrand <david@redhat.com>,
	Juan Quintela <quintela@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Jiri Slaby <jslaby@suse.cz>,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	Eric Blake <eblake@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Michael Roth <michael.roth@amd.com>,
	Paul Durrant <paul@xen.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	xen-devel@lists.xenproject.org,
	Halil Pasic <pasic@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Song Gao <gaosong@loongson.cn>,
	Kevin Wolf <kwolf@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	qemu-ppc@nongnu.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Bin Meng <bin.meng@windriver.com>,
	qemu-arm@nongnu.org,
	Anthony Perard <anthony.perard@citrix.com>,
	Leonardo Bras <leobras@redhat.com>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Eric Farman <farman@linux.ibm.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH v3 2/5] qemu/main-loop: rename QEMU_IOTHREAD_LOCK_GUARD to BQL_LOCK_GUARD
Date: Tue,  2 Jan 2024 10:35:26 -0500
Message-ID: <20240102153529.486531-3-stefanha@redhat.com>
In-Reply-To: <20240102153529.486531-1-stefanha@redhat.com>
References: <20240102153529.486531-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

The name "iothread" is overloaded. Use the term Big QEMU Lock (BQL)
instead, it is already widely used and unambiguous.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Acked-by: Ilya Leoshkevich <iii@linux.ibm.com>
---
 include/qemu/main-loop.h  | 19 +++++++++----------
 hw/i386/kvm/xen_evtchn.c  | 14 +++++++-------
 hw/i386/kvm/xen_gnttab.c  |  2 +-
 hw/mips/mips_int.c        |  2 +-
 hw/ppc/ppc.c              |  2 +-
 target/i386/kvm/xen-emu.c |  2 +-
 target/ppc/excp_helper.c  |  2 +-
 target/ppc/helper_regs.c  |  2 +-
 target/riscv/cpu_helper.c |  4 ++--
 9 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/include/qemu/main-loop.h b/include/qemu/main-loop.h
index 72ebc0cb3a..c26ad2a029 100644
--- a/include/qemu/main-loop.h
+++ b/include/qemu/main-loop.h
@@ -343,33 +343,32 @@ void bql_lock_impl(const char *file, int line);
 void bql_unlock(void);
 
 /**
- * QEMU_IOTHREAD_LOCK_GUARD
+ * BQL_LOCK_GUARD
  *
  * Wrap a block of code in a conditional bql_{lock,unlock}.
  */
-typedef struct IOThreadLockAuto IOThreadLockAuto;
+typedef struct BQLLockAuto BQLLockAuto;
 
-static inline IOThreadLockAuto *qemu_iothread_auto_lock(const char *file,
-                                                        int line)
+static inline BQLLockAuto *bql_auto_lock(const char *file, int line)
 {
     if (bql_locked()) {
         return NULL;
     }
     bql_lock_impl(file, line);
     /* Anything non-NULL causes the cleanup function to be called */
-    return (IOThreadLockAuto *)(uintptr_t)1;
+    return (BQLLockAuto *)(uintptr_t)1;
 }
 
-static inline void qemu_iothread_auto_unlock(IOThreadLockAuto *l)
+static inline void bql_auto_unlock(BQLLockAuto *l)
 {
     bql_unlock();
 }
 
-G_DEFINE_AUTOPTR_CLEANUP_FUNC(IOThreadLockAuto, qemu_iothread_auto_unlock)
+G_DEFINE_AUTOPTR_CLEANUP_FUNC(BQLLockAuto, bql_auto_unlock)
 
-#define QEMU_IOTHREAD_LOCK_GUARD() \
-    g_autoptr(IOThreadLockAuto) _iothread_lock_auto __attribute__((unused)) \
-        = qemu_iothread_auto_lock(__FILE__, __LINE__)
+#define BQL_LOCK_GUARD() \
+    g_autoptr(BQLLockAuto) _bql_lock_auto __attribute__((unused)) \
+        = bql_auto_lock(__FILE__, __LINE__)
 
 /*
  * qemu_cond_wait_iothread: Wait on condition for the main loop mutex
diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index d7d15cfaf7..bd077eda6d 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -1127,7 +1127,7 @@ int xen_evtchn_reset_op(struct evtchn_reset *reset)
         return -ESRCH;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
     return xen_evtchn_soft_reset();
 }
 
@@ -1145,7 +1145,7 @@ int xen_evtchn_close_op(struct evtchn_close *close)
         return -EINVAL;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
     qemu_mutex_lock(&s->port_lock);
 
     ret = close_port(s, close->port, &flush_kvm_routes);
@@ -1272,7 +1272,7 @@ int xen_evtchn_bind_pirq_op(struct evtchn_bind_pirq *pirq)
         return -EINVAL;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
 
     if (s->pirq[pirq->pirq].port) {
         return -EBUSY;
@@ -1824,7 +1824,7 @@ int xen_physdev_map_pirq(struct physdev_map_pirq *map)
         return -ENOTSUP;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
     QEMU_LOCK_GUARD(&s->port_lock);
 
     if (map->domid != DOMID_SELF && map->domid != xen_domid) {
@@ -1884,7 +1884,7 @@ int xen_physdev_unmap_pirq(struct physdev_unmap_pirq *unmap)
         return -EINVAL;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
     qemu_mutex_lock(&s->port_lock);
 
     if (!pirq_inuse(s, pirq)) {
@@ -1924,7 +1924,7 @@ int xen_physdev_eoi_pirq(struct physdev_eoi *eoi)
         return -ENOTSUP;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
     QEMU_LOCK_GUARD(&s->port_lock);
 
     if (!pirq_inuse(s, pirq)) {
@@ -1956,7 +1956,7 @@ int xen_physdev_query_pirq(struct physdev_irq_status_query *query)
         return -ENOTSUP;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
     QEMU_LOCK_GUARD(&s->port_lock);
 
     if (!pirq_inuse(s, pirq)) {
diff --git a/hw/i386/kvm/xen_gnttab.c b/hw/i386/kvm/xen_gnttab.c
index 0a24f53f20..d9477ae927 100644
--- a/hw/i386/kvm/xen_gnttab.c
+++ b/hw/i386/kvm/xen_gnttab.c
@@ -176,7 +176,7 @@ int xen_gnttab_map_page(uint64_t idx, uint64_t gfn)
         return -EINVAL;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
     QEMU_LOCK_GUARD(&s->gnt_lock);
 
     xen_overlay_do_map_page(&s->gnt_aliases[idx], gpa);
diff --git a/hw/mips/mips_int.c b/hw/mips/mips_int.c
index 6c32e466a3..eef2fd2cd1 100644
--- a/hw/mips/mips_int.c
+++ b/hw/mips/mips_int.c
@@ -36,7 +36,7 @@ static void cpu_mips_irq_request(void *opaque, int irq, int level)
         return;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
 
     if (level) {
         env->CP0_Cause |= 1 << (irq + CP0Ca_IP);
diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
index b6581c16fc..7387b5b677 100644
--- a/hw/ppc/ppc.c
+++ b/hw/ppc/ppc.c
@@ -47,7 +47,7 @@ void ppc_set_irq(PowerPCCPU *cpu, int irq, int level)
     unsigned int old_pending;
 
     /* We may already have the BQL if coming from the reset path */
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
 
     old_pending = env->pending_interrupts;
 
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index b0ed2e6aeb..fc2c2321ac 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -581,7 +581,7 @@ static int xen_set_shared_info(uint64_t gfn)
     uint64_t gpa = gfn << TARGET_PAGE_BITS;
     int i, err;
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
 
     /*
      * The xen_overlay device tells KVM about it too, since it had to
diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index 8a2bfb5aa2..2ec6429e36 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -2222,7 +2222,7 @@ static int ppc_next_unmasked_interrupt(CPUPPCState *env)
 void ppc_maybe_interrupt(CPUPPCState *env)
 {
     CPUState *cs = env_cpu(env);
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
 
     if (ppc_next_unmasked_interrupt(env)) {
         cpu_interrupt(cs, CPU_INTERRUPT_HARD);
diff --git a/target/ppc/helper_regs.c b/target/ppc/helper_regs.c
index f380342d4d..e0b2dcd02e 100644
--- a/target/ppc/helper_regs.c
+++ b/target/ppc/helper_regs.c
@@ -244,7 +244,7 @@ void cpu_interrupt_exittb(CPUState *cs)
      * unless running with TCG.
      */
     if (tcg_enabled()) {
-        QEMU_IOTHREAD_LOCK_GUARD();
+        BQL_LOCK_GUARD();
         cpu_interrupt(cs, CPU_INTERRUPT_EXITTB);
     }
 }
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index e7e23b34f4..99d1275729 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -655,7 +655,7 @@ void riscv_cpu_interrupt(CPURISCVState *env)
     uint64_t gein, vsgein = 0, vstip = 0, irqf = 0;
     CPUState *cs = env_cpu(env);
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
 
     if (env->virt_enabled) {
         gein = get_field(env->hstatus, HSTATUS_VGEIN);
@@ -681,7 +681,7 @@ uint64_t riscv_cpu_update_mip(CPURISCVState *env, uint64_t mask, uint64_t value)
     /* No need to update mip for VSTIP */
     mask = ((mask == MIP_VSTIP) && env->vstime_irq) ? 0 : mask;
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    BQL_LOCK_GUARD();
 
     env->mip = (env->mip & ~mask) | (value & mask);
 
-- 
2.43.0


