Return-Path: <kvm+bounces-2799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B98F27FE1DC
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 22:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D71691C20AAF
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 21:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2352B9CB;
	Wed, 29 Nov 2023 21:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XDewRpob"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B810D7F
	for <kvm@vger.kernel.org>; Wed, 29 Nov 2023 13:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701293203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aRXyTaHypebwyOUnVd682fvvQLv7a/HZq8MmldgnYg0=;
	b=XDewRpobci9gvlmiq6z5bTlehuvHWatO5Nvwow8qXecQ8NYjWWfaq78Ox6MXd9QYl5QD6e
	3dXzYHexuIYVGXBEXBb8qM7FnbywkcAEk+BcupUa5kW4dpxFxekJlcu9PRZ7Ukx4oIEfxY
	hylD+z3E9qBf8JU7VmI3xeXJ4670/Zk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-bwNzhLevN8aHRXurZibo-g-1; Wed, 29 Nov 2023 16:26:40 -0500
X-MC-Unique: bwNzhLevN8aHRXurZibo-g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5540C831715;
	Wed, 29 Nov 2023 21:26:38 +0000 (UTC)
Received: from localhost (unknown [10.39.192.91])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01B912166B26;
	Wed, 29 Nov 2023 21:26:36 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: Jean-Christophe Dubois <jcd@tribudubois.net>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-s390x@nongnu.org,
	Song Gao <gaosong@loongson.cn>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Kevin Wolf <kwolf@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Paul Durrant <paul@xen.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Juan Quintela <quintela@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-arm@nongnu.org,
	Jason Wang <jasowang@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Fam Zheng <fam@euphon.net>,
	Eric Blake <eblake@redhat.com>,
	Jiri Slaby <jslaby@suse.cz>,
	Alexander Graf <agraf@csgraf.de>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Eric Farman <farman@linux.ibm.com>,
	Stafford Horne <shorne@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Cameron Esfahani <dirty@apple.com>,
	xen-devel@lists.xenproject.org,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	qemu-riscv@nongnu.org,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	John Snow <jsnow@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Michael Roth <michael.roth@amd.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Bin Meng <bin.meng@windriver.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	kvm@vger.kernel.org,
	Stefan Hajnoczi <stefanha@redhat.com>,
	qemu-block@nongnu.org,
	Halil Pasic <pasic@linux.ibm.com>,
	Peter Xu <peterx@redhat.com>,
	Anthony Perard <anthony.perard@citrix.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Leonardo Bras <leobras@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 2/6] qemu/main-loop: rename QEMU_IOTHREAD_LOCK_GUARD to QEMU_BQL_LOCK_GUARD
Date: Wed, 29 Nov 2023 16:26:21 -0500
Message-ID: <20231129212625.1051502-3-stefanha@redhat.com>
In-Reply-To: <20231129212625.1051502-1-stefanha@redhat.com>
References: <20231129212625.1051502-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

The name "iothread" is overloaded. Use the term Big QEMU Lock (BQL)
instead, it is already widely used and unambiguous.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/qemu/main-loop.h  | 20 ++++++++++----------
 hw/i386/kvm/xen_evtchn.c  | 14 +++++++-------
 hw/i386/kvm/xen_gnttab.c  |  2 +-
 hw/mips/mips_int.c        |  2 +-
 hw/ppc/ppc.c              |  2 +-
 target/i386/kvm/xen-emu.c |  2 +-
 target/ppc/excp_helper.c  |  2 +-
 target/ppc/helper_regs.c  |  2 +-
 target/riscv/cpu_helper.c |  4 ++--
 9 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/include/qemu/main-loop.h b/include/qemu/main-loop.h
index d6f75e57bd..0b6a3e4824 100644
--- a/include/qemu/main-loop.h
+++ b/include/qemu/main-loop.h
@@ -344,13 +344,13 @@ void qemu_bql_lock_impl(const char *file, int line);
 void qemu_bql_unlock(void);
 
 /**
- * QEMU_IOTHREAD_LOCK_GUARD
+ * QEMU_BQL_LOCK_GUARD
  *
- * Wrap a block of code in a conditional qemu_mutex_{lock,unlock}_iothread.
+ * Wrap a block of code in a conditional qemu_bql_{lock,unlock}.
  */
-typedef struct IOThreadLockAuto IOThreadLockAuto;
+typedef struct BQLLockAuto BQLLockAuto;
 
-static inline IOThreadLockAuto *qemu_iothread_auto_lock(const char *file,
+static inline BQLLockAuto *qemu_bql_auto_lock(const char *file,
                                                         int line)
 {
     if (qemu_bql_locked()) {
@@ -358,19 +358,19 @@ static inline IOThreadLockAuto *qemu_iothread_auto_lock(const char *file,
     }
     qemu_bql_lock_impl(file, line);
     /* Anything non-NULL causes the cleanup function to be called */
-    return (IOThreadLockAuto *)(uintptr_t)1;
+    return (BQLLockAuto *)(uintptr_t)1;
 }
 
-static inline void qemu_iothread_auto_unlock(IOThreadLockAuto *l)
+static inline void qemu_bql_auto_unlock(BQLLockAuto *l)
 {
     qemu_bql_unlock();
 }
 
-G_DEFINE_AUTOPTR_CLEANUP_FUNC(IOThreadLockAuto, qemu_iothread_auto_unlock)
+G_DEFINE_AUTOPTR_CLEANUP_FUNC(BQLLockAuto, qemu_bql_auto_unlock)
 
-#define QEMU_IOTHREAD_LOCK_GUARD() \
-    g_autoptr(IOThreadLockAuto) _iothread_lock_auto __attribute__((unused)) \
-        = qemu_iothread_auto_lock(__FILE__, __LINE__)
+#define QEMU_BQL_LOCK_GUARD() \
+    g_autoptr(BQLLockAuto) _bql_lock_auto __attribute__((unused)) \
+        = qemu_bql_auto_lock(__FILE__, __LINE__)
 
 /*
  * qemu_cond_wait_iothread: Wait on condition for the main loop mutex
diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index 07d0ff0253..3ab686bd79 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -1127,7 +1127,7 @@ int xen_evtchn_reset_op(struct evtchn_reset *reset)
         return -ESRCH;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
     return xen_evtchn_soft_reset();
 }
 
@@ -1145,7 +1145,7 @@ int xen_evtchn_close_op(struct evtchn_close *close)
         return -EINVAL;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
     qemu_mutex_lock(&s->port_lock);
 
     ret = close_port(s, close->port, &flush_kvm_routes);
@@ -1272,7 +1272,7 @@ int xen_evtchn_bind_pirq_op(struct evtchn_bind_pirq *pirq)
         return -EINVAL;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
 
     if (s->pirq[pirq->pirq].port) {
         return -EBUSY;
@@ -1824,7 +1824,7 @@ int xen_physdev_map_pirq(struct physdev_map_pirq *map)
         return -ENOTSUP;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
     QEMU_LOCK_GUARD(&s->port_lock);
 
     if (map->domid != DOMID_SELF && map->domid != xen_domid) {
@@ -1884,7 +1884,7 @@ int xen_physdev_unmap_pirq(struct physdev_unmap_pirq *unmap)
         return -EINVAL;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
     qemu_mutex_lock(&s->port_lock);
 
     if (!pirq_inuse(s, pirq)) {
@@ -1924,7 +1924,7 @@ int xen_physdev_eoi_pirq(struct physdev_eoi *eoi)
         return -ENOTSUP;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
     QEMU_LOCK_GUARD(&s->port_lock);
 
     if (!pirq_inuse(s, pirq)) {
@@ -1956,7 +1956,7 @@ int xen_physdev_query_pirq(struct physdev_irq_status_query *query)
         return -ENOTSUP;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
     QEMU_LOCK_GUARD(&s->port_lock);
 
     if (!pirq_inuse(s, pirq)) {
diff --git a/hw/i386/kvm/xen_gnttab.c b/hw/i386/kvm/xen_gnttab.c
index 0a24f53f20..ee5f8cf257 100644
--- a/hw/i386/kvm/xen_gnttab.c
+++ b/hw/i386/kvm/xen_gnttab.c
@@ -176,7 +176,7 @@ int xen_gnttab_map_page(uint64_t idx, uint64_t gfn)
         return -EINVAL;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
     QEMU_LOCK_GUARD(&s->gnt_lock);
 
     xen_overlay_do_map_page(&s->gnt_aliases[idx], gpa);
diff --git a/hw/mips/mips_int.c b/hw/mips/mips_int.c
index 6c32e466a3..c2454f9724 100644
--- a/hw/mips/mips_int.c
+++ b/hw/mips/mips_int.c
@@ -36,7 +36,7 @@ static void cpu_mips_irq_request(void *opaque, int irq, int level)
         return;
     }
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
 
     if (level) {
         env->CP0_Cause |= 1 << (irq + CP0Ca_IP);
diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
index c8c3b43602..ce7d3692c4 100644
--- a/hw/ppc/ppc.c
+++ b/hw/ppc/ppc.c
@@ -47,7 +47,7 @@ void ppc_set_irq(PowerPCCPU *cpu, int irq, int level)
     unsigned int old_pending;
 
     /* We may already have the BQL if coming from the reset path */
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
 
     old_pending = env->pending_interrupts;
 
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index f79f5d270f..be8a1fef58 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -581,7 +581,7 @@ static int xen_set_shared_info(uint64_t gfn)
     uint64_t gpa = gfn << TARGET_PAGE_BITS;
     int i, err;
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
 
     /*
      * The xen_overlay device tells KVM about it too, since it had to
diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index 0a1c942831..2122f89990 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -2222,7 +2222,7 @@ static int ppc_next_unmasked_interrupt(CPUPPCState *env)
 void ppc_maybe_interrupt(CPUPPCState *env)
 {
     CPUState *cs = env_cpu(env);
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
 
     if (ppc_next_unmasked_interrupt(env)) {
         cpu_interrupt(cs, CPU_INTERRUPT_HARD);
diff --git a/target/ppc/helper_regs.c b/target/ppc/helper_regs.c
index f380342d4d..b92e3a223a 100644
--- a/target/ppc/helper_regs.c
+++ b/target/ppc/helper_regs.c
@@ -244,7 +244,7 @@ void cpu_interrupt_exittb(CPUState *cs)
      * unless running with TCG.
      */
     if (tcg_enabled()) {
-        QEMU_IOTHREAD_LOCK_GUARD();
+        QEMU_BQL_LOCK_GUARD();
         cpu_interrupt(cs, CPU_INTERRUPT_EXITTB);
     }
 }
diff --git a/target/riscv/cpu_helper.c b/target/riscv/cpu_helper.c
index e7e23b34f4..fa73bb8ce9 100644
--- a/target/riscv/cpu_helper.c
+++ b/target/riscv/cpu_helper.c
@@ -655,7 +655,7 @@ void riscv_cpu_interrupt(CPURISCVState *env)
     uint64_t gein, vsgein = 0, vstip = 0, irqf = 0;
     CPUState *cs = env_cpu(env);
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
 
     if (env->virt_enabled) {
         gein = get_field(env->hstatus, HSTATUS_VGEIN);
@@ -681,7 +681,7 @@ uint64_t riscv_cpu_update_mip(CPURISCVState *env, uint64_t mask, uint64_t value)
     /* No need to update mip for VSTIP */
     mask = ((mask == MIP_VSTIP) && env->vstime_irq) ? 0 : mask;
 
-    QEMU_IOTHREAD_LOCK_GUARD();
+    QEMU_BQL_LOCK_GUARD();
 
     env->mip = (env->mip & ~mask) | (value & mask);
 
-- 
2.42.0


