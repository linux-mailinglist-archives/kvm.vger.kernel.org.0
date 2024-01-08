Return-Path: <kvm+bounces-5843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A94482756E
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 17:38:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65A3E1C21CCF
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 16:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C54E654780;
	Mon,  8 Jan 2024 16:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y5q+87gn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A015466B
	for <kvm@vger.kernel.org>; Mon,  8 Jan 2024 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1704731868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=opoP7uxdS/qgy3LGNWkvHDYOBSZGmIG9rtliHv9yc2w=;
	b=Y5q+87gndnkNB+l6x7lxvU21qOL8P8wlOx1+7OVhjJG/DWcH2aR0lA7onYMJOloTEVIzyN
	lYLP8kmf7YoyuX5wc3VWml+3JcedIk0mmKxwtw0gbr9x/6E89iWkM9IrBCxCy4wxOBD+0A
	BnLs5zLgzZ1Coq0+8y1uR2+Md4qKR6U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-Ase4dTdmOKum7vmebSDwsg-1; Mon, 08 Jan 2024 11:37:46 -0500
X-MC-Unique: Ase4dTdmOKum7vmebSDwsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3900985A5B5;
	Mon,  8 Jan 2024 16:37:45 +0000 (UTC)
Received: from localhost (unknown [10.39.194.85])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EBF511C060AF;
	Mon,  8 Jan 2024 16:37:42 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: qemu-devel@nongnu.org
Cc: qemu-s390x@nongnu.org,
	Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
	qemu-block@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	kvm@vger.kernel.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	qemu-arm@nongnu.org,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jiri Slaby <jslaby@suse.cz>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Eric Blake <eblake@redhat.com>,
	Paul Durrant <paul@xen.org>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Kevin Wolf <kwolf@redhat.com>,
	Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	xen-devel@lists.xenproject.org,
	Anthony Perard <anthony.perard@citrix.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-ppc@nongnu.org,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Song Gao <gaosong@loongson.cn>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Andrey Smirnov <andrew.smirnov@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Alexander Graf <agraf@csgraf.de>,
	Markus Armbruster <armbru@redhat.com>,
	John Snow <jsnow@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Stefan Weil <sw@weilnetz.de>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Hailiang Zhang <zhanghailiang@xfusion.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Michael Roth <michael.roth@amd.com>,
	Fam Zheng <fam@euphon.net>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	David Gibson <david@gibson.dropbear.id.au>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stafford Horne <shorne@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Cameron Esfahani <dirty@apple.com>,
	Eric Farman <farman@linux.ibm.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Hanna Reitz <hreitz@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Bin Meng <bin.meng@windriver.com>,
	Fabiano Rosas <farosas@suse.de>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	David Hildenbrand <david@redhat.com>,
	David Woodhouse <dwmw@amazon.co.uk>
Subject: [PULL 2/6] system/cpus: rename qemu_mutex_lock_iothread() to bql_lock()
Date: Mon,  8 Jan 2024 11:37:31 -0500
Message-ID: <20240108163735.254732-3-stefanha@redhat.com>
In-Reply-To: <20240108163735.254732-1-stefanha@redhat.com>
References: <20240108163735.254732-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

The Big QEMU Lock (BQL) has many names and they are confusing. The
actual QemuMutex variable is called qemu_global_mutex but it's commonly
referred to as the BQL in discussions and some code comments. The
locking APIs, however, are called qemu_mutex_lock_iothread() and
qemu_mutex_unlock_iothread().

The "iothread" name is historic and comes from when the main thread was
split into into KVM vcpu threads and the "iothread" (now called the main
loop thread). I have contributed to the confusion myself by introducing
a separate --object iothread, a separate concept unrelated to the BQL.

The "iothread" name is no longer appropriate for the BQL. Rename the
locking APIs to:
- void bql_lock(void)
- void bql_unlock(void)
- bool bql_locked(void)

There are more APIs with "iothread" in their names. Subsequent patches
will rename them. There are also comments and documentation that will be
updated in later patches.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Acked-by: Fabiano Rosas <farosas@suse.de>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Acked-by: Peter Xu <peterx@redhat.com>
Acked-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Acked-by: Hyman Huang <yong.huang@smartx.com>
Reviewed-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Message-id: 20240102153529.486531-2-stefanha@redhat.com
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/block/aio-wait.h             |   2 +-
 include/qemu/main-loop.h             |  39 +++++----
 include/qemu/thread.h                |   2 +-
 accel/accel-blocker.c                |  10 +--
 accel/dummy-cpus.c                   |   8 +-
 accel/hvf/hvf-accel-ops.c            |   4 +-
 accel/kvm/kvm-accel-ops.c            |   4 +-
 accel/kvm/kvm-all.c                  |  22 ++---
 accel/tcg/cpu-exec.c                 |  26 +++---
 accel/tcg/cputlb.c                   |  16 ++--
 accel/tcg/tcg-accel-ops-icount.c     |   4 +-
 accel/tcg/tcg-accel-ops-mttcg.c      |  12 +--
 accel/tcg/tcg-accel-ops-rr.c         |  14 ++--
 accel/tcg/tcg-accel-ops.c            |   2 +-
 accel/tcg/translate-all.c            |   2 +-
 cpu-common.c                         |   4 +-
 dump/dump.c                          |   4 +-
 hw/core/cpu-common.c                 |   6 +-
 hw/i386/intel_iommu.c                |   6 +-
 hw/i386/kvm/xen_evtchn.c             |  16 ++--
 hw/i386/kvm/xen_overlay.c            |   2 +-
 hw/i386/kvm/xen_xenstore.c           |   2 +-
 hw/intc/arm_gicv3_cpuif.c            |   2 +-
 hw/intc/s390_flic.c                  |  18 ++--
 hw/misc/edu.c                        |   4 +-
 hw/misc/imx6_src.c                   |   2 +-
 hw/misc/imx7_src.c                   |   2 +-
 hw/net/xen_nic.c                     |   8 +-
 hw/ppc/pegasos2.c                    |   2 +-
 hw/ppc/ppc.c                         |   4 +-
 hw/ppc/spapr.c                       |   2 +-
 hw/ppc/spapr_rng.c                   |   4 +-
 hw/ppc/spapr_softmmu.c               |   4 +-
 hw/remote/mpqemu-link.c              |  20 ++---
 hw/remote/vfio-user-obj.c            |   2 +-
 hw/s390x/s390-skeys.c                |   2 +-
 migration/block-dirty-bitmap.c       |   4 +-
 migration/block.c                    |  16 ++--
 migration/colo.c                     |  60 +++++++-------
 migration/dirtyrate.c                |  12 +--
 migration/migration.c                |  52 ++++++------
 migration/ram.c                      |  12 +--
 replay/replay-internal.c             |   2 +-
 semihosting/console.c                |   8 +-
 stubs/iothread-lock.c                |   6 +-
 system/cpu-throttle.c                |   4 +-
 system/cpus.c                        |  51 ++++++------
 system/dirtylimit.c                  |   4 +-
 system/memory.c                      |   2 +-
 system/physmem.c                     |   8 +-
 system/runstate.c                    |   2 +-
 system/watchpoint.c                  |   4 +-
 target/arm/arm-powerctl.c            |  14 ++--
 target/arm/helper.c                  |   4 +-
 target/arm/hvf/hvf.c                 |   8 +-
 target/arm/kvm.c                     |   8 +-
 target/arm/ptw.c                     |   6 +-
 target/arm/tcg/helper-a64.c          |   8 +-
 target/arm/tcg/m_helper.c            |   6 +-
 target/arm/tcg/op_helper.c           |  24 +++---
 target/arm/tcg/psci.c                |   2 +-
 target/hppa/int_helper.c             |   8 +-
 target/i386/hvf/hvf.c                |   6 +-
 target/i386/kvm/hyperv.c             |   4 +-
 target/i386/kvm/kvm.c                |  28 +++----
 target/i386/kvm/xen-emu.c            |  14 ++--
 target/i386/nvmm/nvmm-accel-ops.c    |   4 +-
 target/i386/nvmm/nvmm-all.c          |  20 ++---
 target/i386/tcg/sysemu/fpu_helper.c  |   6 +-
 target/i386/tcg/sysemu/misc_helper.c |   4 +-
 target/i386/whpx/whpx-accel-ops.c    |   4 +-
 target/i386/whpx/whpx-all.c          |  24 +++---
 target/loongarch/tcg/csr_helper.c    |   4 +-
 target/mips/kvm.c                    |   4 +-
 target/mips/tcg/sysemu/cp0_helper.c  |   4 +-
 target/openrisc/sys_helper.c         |  16 ++--
 target/ppc/excp_helper.c             |  12 +--
 target/ppc/kvm.c                     |   4 +-
 target/ppc/misc_helper.c             |   8 +-
 target/ppc/timebase_helper.c         |   8 +-
 target/s390x/kvm/kvm.c               |   4 +-
 target/s390x/tcg/misc_helper.c       | 118 +++++++++++++--------------
 target/sparc/int32_helper.c          |   2 +-
 target/sparc/int64_helper.c          |   6 +-
 target/sparc/win_helper.c            |  20 ++---
 target/xtensa/exc_helper.c           |   8 +-
 ui/spice-core.c                      |   4 +-
 util/async.c                         |   2 +-
 util/main-loop.c                     |   8 +-
 util/qsp.c                           |   6 +-
 util/rcu.c                           |  14 ++--
 audio/coreaudio.m                    |   4 +-
 memory_ldst.c.inc                    |  18 ++--
 target/i386/hvf/README.md            |   2 +-
 ui/cocoa.m                           |  50 ++++++------
 95 files changed, 529 insertions(+), 529 deletions(-)

diff --git a/include/block/aio-wait.h b/include/block/aio-wait.h
index 157f105916..cf5e8bde1c 100644
--- a/include/block/aio-wait.h
+++ b/include/block/aio-wait.h
@@ -143,7 +143,7 @@ static inline bool in_aio_context_home_thread(AioContext *ctx)
     }
 
     if (ctx == qemu_get_aio_context()) {
-        return qemu_mutex_iothread_locked();
+        return bql_locked();
     } else {
         return false;
     }
diff --git a/include/qemu/main-loop.h b/include/qemu/main-loop.h
index 68e70e61aa..72ebc0cb3a 100644
--- a/include/qemu/main-loop.h
+++ b/include/qemu/main-loop.h
@@ -248,19 +248,19 @@ GSource *iohandler_get_g_source(void);
 AioContext *iohandler_get_aio_context(void);
 
 /**
- * qemu_mutex_iothread_locked: Return lock status of the main loop mutex.
+ * bql_locked: Return lock status of the Big QEMU Lock (BQL)
  *
- * The main loop mutex is the coarsest lock in QEMU, and as such it
+ * The Big QEMU Lock (BQL) is the coarsest lock in QEMU, and as such it
  * must always be taken outside other locks.  This function helps
  * functions take different paths depending on whether the current
- * thread is running within the main loop mutex.
+ * thread is running within the BQL.
  *
  * This function should never be used in the block layer, because
  * unit tests, block layer tools and qemu-storage-daemon do not
  * have a BQL.
  * Please instead refer to qemu_in_main_thread().
  */
-bool qemu_mutex_iothread_locked(void);
+bool bql_locked(void);
 
 /**
  * qemu_in_main_thread: return whether it's possible to safely access
@@ -312,58 +312,57 @@ bool qemu_in_main_thread(void);
     } while (0)
 
 /**
- * qemu_mutex_lock_iothread: Lock the main loop mutex.
+ * bql_lock: Lock the Big QEMU Lock (BQL).
  *
- * This function locks the main loop mutex.  The mutex is taken by
+ * This function locks the Big QEMU Lock (BQL).  The lock is taken by
  * main() in vl.c and always taken except while waiting on
- * external events (such as with select).  The mutex should be taken
+ * external events (such as with select).  The lock should be taken
  * by threads other than the main loop thread when calling
  * qemu_bh_new(), qemu_set_fd_handler() and basically all other
  * functions documented in this file.
  *
- * NOTE: tools currently are single-threaded and qemu_mutex_lock_iothread
+ * NOTE: tools currently are single-threaded and bql_lock
  * is a no-op there.
  */
-#define qemu_mutex_lock_iothread()                      \
-    qemu_mutex_lock_iothread_impl(__FILE__, __LINE__)
-void qemu_mutex_lock_iothread_impl(const char *file, int line);
+#define bql_lock() bql_lock_impl(__FILE__, __LINE__)
+void bql_lock_impl(const char *file, int line);
 
 /**
- * qemu_mutex_unlock_iothread: Unlock the main loop mutex.
+ * bql_unlock: Unlock the Big QEMU Lock (BQL).
  *
- * This function unlocks the main loop mutex.  The mutex is taken by
+ * This function unlocks the Big QEMU Lock.  The lock is taken by
  * main() in vl.c and always taken except while waiting on
- * external events (such as with select).  The mutex should be unlocked
+ * external events (such as with select).  The lock should be unlocked
  * as soon as possible by threads other than the main loop thread,
  * because it prevents the main loop from processing callbacks,
  * including timers and bottom halves.
  *
- * NOTE: tools currently are single-threaded and qemu_mutex_unlock_iothread
+ * NOTE: tools currently are single-threaded and bql_unlock
  * is a no-op there.
  */
-void qemu_mutex_unlock_iothread(void);
+void bql_unlock(void);
 
 /**
  * QEMU_IOTHREAD_LOCK_GUARD
  *
- * Wrap a block of code in a conditional qemu_mutex_{lock,unlock}_iothread.
+ * Wrap a block of code in a conditional bql_{lock,unlock}.
  */
 typedef struct IOThreadLockAuto IOThreadLockAuto;
 
 static inline IOThreadLockAuto *qemu_iothread_auto_lock(const char *file,
                                                         int line)
 {
-    if (qemu_mutex_iothread_locked()) {
+    if (bql_locked()) {
         return NULL;
     }
-    qemu_mutex_lock_iothread_impl(file, line);
+    bql_lock_impl(file, line);
     /* Anything non-NULL causes the cleanup function to be called */
     return (IOThreadLockAuto *)(uintptr_t)1;
 }
 
 static inline void qemu_iothread_auto_unlock(IOThreadLockAuto *l)
 {
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 G_DEFINE_AUTOPTR_CLEANUP_FUNC(IOThreadLockAuto, qemu_iothread_auto_unlock)
diff --git a/include/qemu/thread.h b/include/qemu/thread.h
index dd3822d7ce..fb74e21c08 100644
--- a/include/qemu/thread.h
+++ b/include/qemu/thread.h
@@ -47,7 +47,7 @@ typedef void (*QemuCondWaitFunc)(QemuCond *c, QemuMutex *m, const char *f,
 typedef bool (*QemuCondTimedWaitFunc)(QemuCond *c, QemuMutex *m, int ms,
                                       const char *f, int l);
 
-extern QemuMutexLockFunc qemu_bql_mutex_lock_func;
+extern QemuMutexLockFunc bql_mutex_lock_func;
 extern QemuMutexLockFunc qemu_mutex_lock_func;
 extern QemuMutexTrylockFunc qemu_mutex_trylock_func;
 extern QemuRecMutexLockFunc qemu_rec_mutex_lock_func;
diff --git a/accel/accel-blocker.c b/accel/accel-blocker.c
index 1e7f423462..e083f24aa8 100644
--- a/accel/accel-blocker.c
+++ b/accel/accel-blocker.c
@@ -41,7 +41,7 @@ void accel_blocker_init(void)
 
 void accel_ioctl_begin(void)
 {
-    if (likely(qemu_mutex_iothread_locked())) {
+    if (likely(bql_locked())) {
         return;
     }
 
@@ -51,7 +51,7 @@ void accel_ioctl_begin(void)
 
 void accel_ioctl_end(void)
 {
-    if (likely(qemu_mutex_iothread_locked())) {
+    if (likely(bql_locked())) {
         return;
     }
 
@@ -62,7 +62,7 @@ void accel_ioctl_end(void)
 
 void accel_cpu_ioctl_begin(CPUState *cpu)
 {
-    if (unlikely(qemu_mutex_iothread_locked())) {
+    if (unlikely(bql_locked())) {
         return;
     }
 
@@ -72,7 +72,7 @@ void accel_cpu_ioctl_begin(CPUState *cpu)
 
 void accel_cpu_ioctl_end(CPUState *cpu)
 {
-    if (unlikely(qemu_mutex_iothread_locked())) {
+    if (unlikely(bql_locked())) {
         return;
     }
 
@@ -105,7 +105,7 @@ void accel_ioctl_inhibit_begin(void)
      * We allow to inhibit only when holding the BQL, so we can identify
      * when an inhibitor wants to issue an ioctl easily.
      */
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     /* Block further invocations of the ioctls outside the BQL.  */
     CPU_FOREACH(cpu) {
diff --git a/accel/dummy-cpus.c b/accel/dummy-cpus.c
index b75c919ac3..f4b0ec5890 100644
--- a/accel/dummy-cpus.c
+++ b/accel/dummy-cpus.c
@@ -24,7 +24,7 @@ static void *dummy_cpu_thread_fn(void *arg)
 
     rcu_register_thread();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_thread_get_self(cpu->thread);
     cpu->thread_id = qemu_get_thread_id();
     cpu->neg.can_do_io = true;
@@ -43,7 +43,7 @@ static void *dummy_cpu_thread_fn(void *arg)
     qemu_guest_random_seed_thread_part2(cpu->random_seed);
 
     do {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
 #ifndef _WIN32
         do {
             int sig;
@@ -56,11 +56,11 @@ static void *dummy_cpu_thread_fn(void *arg)
 #else
         qemu_sem_wait(&cpu->sem);
 #endif
-        qemu_mutex_lock_iothread();
+        bql_lock();
         qemu_wait_io_event(cpu);
     } while (!cpu->unplug);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     rcu_unregister_thread();
     return NULL;
 }
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index abe7adf7ee..8eabb696fa 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -424,7 +424,7 @@ static void *hvf_cpu_thread_fn(void *arg)
 
     rcu_register_thread();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_thread_get_self(cpu->thread);
 
     cpu->thread_id = qemu_get_thread_id();
@@ -449,7 +449,7 @@ static void *hvf_cpu_thread_fn(void *arg)
 
     hvf_vcpu_destroy(cpu);
     cpu_thread_signal_destroyed(cpu);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     rcu_unregister_thread();
     return NULL;
 }
diff --git a/accel/kvm/kvm-accel-ops.c b/accel/kvm/kvm-accel-ops.c
index 6195150a0b..45ff06e953 100644
--- a/accel/kvm/kvm-accel-ops.c
+++ b/accel/kvm/kvm-accel-ops.c
@@ -33,7 +33,7 @@ static void *kvm_vcpu_thread_fn(void *arg)
 
     rcu_register_thread();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_thread_get_self(cpu->thread);
     cpu->thread_id = qemu_get_thread_id();
     cpu->neg.can_do_io = true;
@@ -58,7 +58,7 @@ static void *kvm_vcpu_thread_fn(void *arg)
 
     kvm_destroy_vcpu(cpu);
     cpu_thread_signal_destroyed(cpu);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     rcu_unregister_thread();
     return NULL;
 }
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index eb17773f0b..bbc60146d1 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -806,7 +806,7 @@ static void kvm_dirty_ring_flush(void)
      * should always be with BQL held, serialization is guaranteed.
      * However, let's be sure of it.
      */
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
     /*
      * First make sure to flush the hardware buffers by kicking all
      * vcpus out in a synchronous way.
@@ -1391,9 +1391,9 @@ static void *kvm_dirty_ring_reaper_thread(void *data)
         trace_kvm_dirty_ring_reaper("wakeup");
         r->reaper_state = KVM_DIRTY_RING_REAPER_REAPING;
 
-        qemu_mutex_lock_iothread();
+        bql_lock();
         kvm_dirty_ring_reap(s, NULL);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
 
         r->reaper_iteration++;
     }
@@ -2817,7 +2817,7 @@ int kvm_cpu_exec(CPUState *cpu)
         return EXCP_HLT;
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     cpu_exec_start(cpu);
 
     do {
@@ -2857,11 +2857,11 @@ int kvm_cpu_exec(CPUState *cpu)
 
 #ifdef KVM_HAVE_MCE_INJECTION
         if (unlikely(have_sigbus_pending)) {
-            qemu_mutex_lock_iothread();
+            bql_lock();
             kvm_arch_on_sigbus_vcpu(cpu, pending_sigbus_code,
                                     pending_sigbus_addr);
             have_sigbus_pending = false;
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
         }
 #endif
 
@@ -2927,7 +2927,7 @@ int kvm_cpu_exec(CPUState *cpu)
              * still full.  Got kicked by KVM_RESET_DIRTY_RINGS.
              */
             trace_kvm_dirty_ring_full(cpu->cpu_index);
-            qemu_mutex_lock_iothread();
+            bql_lock();
             /*
              * We throttle vCPU by making it sleep once it exit from kernel
              * due to dirty ring full. In the dirtylimit scenario, reaping
@@ -2939,7 +2939,7 @@ int kvm_cpu_exec(CPUState *cpu)
             } else {
                 kvm_dirty_ring_reap(kvm_state, NULL);
             }
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             dirtylimit_vcpu_execute(cpu);
             ret = 0;
             break;
@@ -2956,9 +2956,9 @@ int kvm_cpu_exec(CPUState *cpu)
                 break;
             case KVM_SYSTEM_EVENT_CRASH:
                 kvm_cpu_synchronize_state(cpu);
-                qemu_mutex_lock_iothread();
+                bql_lock();
                 qemu_system_guest_panicked(cpu_get_crash_info(cpu));
-                qemu_mutex_unlock_iothread();
+                bql_unlock();
                 ret = 0;
                 break;
             default:
@@ -2973,7 +2973,7 @@ int kvm_cpu_exec(CPUState *cpu)
     } while (ret == 0);
 
     cpu_exec_end(cpu);
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     if (ret < 0) {
         cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
diff --git a/accel/tcg/cpu-exec.c b/accel/tcg/cpu-exec.c
index c938eb96f8..67eda9865e 100644
--- a/accel/tcg/cpu-exec.c
+++ b/accel/tcg/cpu-exec.c
@@ -558,8 +558,8 @@ static void cpu_exec_longjmp_cleanup(CPUState *cpu)
         tcg_ctx->gen_tb = NULL;
     }
 #endif
-    if (qemu_mutex_iothread_locked()) {
-        qemu_mutex_unlock_iothread();
+    if (bql_locked()) {
+        bql_unlock();
     }
     assert_no_pages_locked();
 }
@@ -680,10 +680,10 @@ static inline bool cpu_handle_halt(CPUState *cpu)
 #if defined(TARGET_I386)
         if (cpu->interrupt_request & CPU_INTERRUPT_POLL) {
             X86CPU *x86_cpu = X86_CPU(cpu);
-            qemu_mutex_lock_iothread();
+            bql_lock();
             apic_poll_irq(x86_cpu->apic_state);
             cpu_reset_interrupt(cpu, CPU_INTERRUPT_POLL);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
         }
 #endif /* TARGET_I386 */
         if (!cpu_has_work(cpu)) {
@@ -749,9 +749,9 @@ static inline bool cpu_handle_exception(CPUState *cpu, int *ret)
 #else
         if (replay_exception()) {
             CPUClass *cc = CPU_GET_CLASS(cpu);
-            qemu_mutex_lock_iothread();
+            bql_lock();
             cc->tcg_ops->do_interrupt(cpu);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             cpu->exception_index = -1;
 
             if (unlikely(cpu->singlestep_enabled)) {
@@ -812,7 +812,7 @@ static inline bool cpu_handle_interrupt(CPUState *cpu,
 
     if (unlikely(qatomic_read(&cpu->interrupt_request))) {
         int interrupt_request;
-        qemu_mutex_lock_iothread();
+        bql_lock();
         interrupt_request = cpu->interrupt_request;
         if (unlikely(cpu->singlestep_enabled & SSTEP_NOIRQ)) {
             /* Mask out external interrupts for this step. */
@@ -821,7 +821,7 @@ static inline bool cpu_handle_interrupt(CPUState *cpu,
         if (interrupt_request & CPU_INTERRUPT_DEBUG) {
             cpu->interrupt_request &= ~CPU_INTERRUPT_DEBUG;
             cpu->exception_index = EXCP_DEBUG;
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             return true;
         }
 #if !defined(CONFIG_USER_ONLY)
@@ -832,7 +832,7 @@ static inline bool cpu_handle_interrupt(CPUState *cpu,
             cpu->interrupt_request &= ~CPU_INTERRUPT_HALT;
             cpu->halted = 1;
             cpu->exception_index = EXCP_HLT;
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             return true;
         }
 #if defined(TARGET_I386)
@@ -843,14 +843,14 @@ static inline bool cpu_handle_interrupt(CPUState *cpu,
             cpu_svm_check_intercept_param(env, SVM_EXIT_INIT, 0, 0);
             do_cpu_init(x86_cpu);
             cpu->exception_index = EXCP_HALTED;
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             return true;
         }
 #else
         else if (interrupt_request & CPU_INTERRUPT_RESET) {
             replay_interrupt();
             cpu_reset(cpu);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             return true;
         }
 #endif /* !TARGET_I386 */
@@ -873,7 +873,7 @@ static inline bool cpu_handle_interrupt(CPUState *cpu,
                  */
                 if (unlikely(cpu->singlestep_enabled)) {
                     cpu->exception_index = EXCP_DEBUG;
-                    qemu_mutex_unlock_iothread();
+                    bql_unlock();
                     return true;
                 }
                 cpu->exception_index = -1;
@@ -892,7 +892,7 @@ static inline bool cpu_handle_interrupt(CPUState *cpu,
         }
 
         /* If we exit via cpu_loop_exit/longjmp it is reset in cpu_exec */
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
     /* Finally, check if we need to exit to the main loop.  */
diff --git a/accel/tcg/cputlb.c b/accel/tcg/cputlb.c
index db3f93fda9..5698a9fd8e 100644
--- a/accel/tcg/cputlb.c
+++ b/accel/tcg/cputlb.c
@@ -2030,10 +2030,10 @@ static uint64_t do_ld_mmio_beN(CPUState *cpu, CPUTLBEntryFull *full,
     section = io_prepare(&mr_offset, cpu, full->xlat_section, attrs, addr, ra);
     mr = section->mr;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ret = int_ld_mmio_beN(cpu, full, ret_be, addr, size, mmu_idx,
                           type, ra, mr, mr_offset);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return ret;
 }
@@ -2054,12 +2054,12 @@ static Int128 do_ld16_mmio_beN(CPUState *cpu, CPUTLBEntryFull *full,
     section = io_prepare(&mr_offset, cpu, full->xlat_section, attrs, addr, ra);
     mr = section->mr;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     a = int_ld_mmio_beN(cpu, full, ret_be, addr, size - 8, mmu_idx,
                         MMU_DATA_LOAD, ra, mr, mr_offset);
     b = int_ld_mmio_beN(cpu, full, ret_be, addr + size - 8, 8, mmu_idx,
                         MMU_DATA_LOAD, ra, mr, mr_offset + size - 8);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return int128_make128(b, a);
 }
@@ -2577,10 +2577,10 @@ static uint64_t do_st_mmio_leN(CPUState *cpu, CPUTLBEntryFull *full,
     section = io_prepare(&mr_offset, cpu, full->xlat_section, attrs, addr, ra);
     mr = section->mr;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ret = int_st_mmio_leN(cpu, full, val_le, addr, size, mmu_idx,
                           ra, mr, mr_offset);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return ret;
 }
@@ -2601,12 +2601,12 @@ static uint64_t do_st16_mmio_leN(CPUState *cpu, CPUTLBEntryFull *full,
     section = io_prepare(&mr_offset, cpu, full->xlat_section, attrs, addr, ra);
     mr = section->mr;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     int_st_mmio_leN(cpu, full, int128_getlo(val_le), addr, 8,
                     mmu_idx, ra, mr, mr_offset);
     ret = int_st_mmio_leN(cpu, full, int128_gethi(val_le), addr + 8,
                           size - 8, mmu_idx, ra, mr, mr_offset + 8);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return ret;
 }
diff --git a/accel/tcg/tcg-accel-ops-icount.c b/accel/tcg/tcg-accel-ops-icount.c
index b25685fb71..5824d92580 100644
--- a/accel/tcg/tcg-accel-ops-icount.c
+++ b/accel/tcg/tcg-accel-ops-icount.c
@@ -126,9 +126,9 @@ void icount_prepare_for_run(CPUState *cpu, int64_t cpu_budget)
          * We're called without the iothread lock, so must take it while
          * we're calling timer handlers.
          */
-        qemu_mutex_lock_iothread();
+        bql_lock();
         icount_notify_aio_contexts();
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 }
 
diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index fac80095bb..af7307013a 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -76,7 +76,7 @@ static void *mttcg_cpu_thread_fn(void *arg)
     rcu_add_force_rcu_notifier(&force_rcu.notifier);
     tcg_register_thread();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_thread_get_self(cpu->thread);
 
     cpu->thread_id = qemu_get_thread_id();
@@ -91,9 +91,9 @@ static void *mttcg_cpu_thread_fn(void *arg)
     do {
         if (cpu_can_run(cpu)) {
             int r;
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             r = tcg_cpus_exec(cpu);
-            qemu_mutex_lock_iothread();
+            bql_lock();
             switch (r) {
             case EXCP_DEBUG:
                 cpu_handle_guest_debug(cpu);
@@ -105,9 +105,9 @@ static void *mttcg_cpu_thread_fn(void *arg)
                  */
                 break;
             case EXCP_ATOMIC:
-                qemu_mutex_unlock_iothread();
+                bql_unlock();
                 cpu_exec_step_atomic(cpu);
-                qemu_mutex_lock_iothread();
+                bql_lock();
             default:
                 /* Ignore everything else? */
                 break;
@@ -119,7 +119,7 @@ static void *mttcg_cpu_thread_fn(void *arg)
     } while (!cpu->unplug || cpu_can_run(cpu));
 
     tcg_cpus_destroy(cpu);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     rcu_remove_force_rcu_notifier(&force_rcu.notifier);
     rcu_unregister_thread();
     return NULL;
diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index 611932f3c3..c4ea372a3f 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -188,7 +188,7 @@ static void *rr_cpu_thread_fn(void *arg)
     rcu_add_force_rcu_notifier(&force_rcu);
     tcg_register_thread();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_thread_get_self(cpu->thread);
 
     cpu->thread_id = qemu_get_thread_id();
@@ -218,9 +218,9 @@ static void *rr_cpu_thread_fn(void *arg)
         /* Only used for icount_enabled() */
         int64_t cpu_budget = 0;
 
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         replay_mutex_lock();
-        qemu_mutex_lock_iothread();
+        bql_lock();
 
         if (icount_enabled()) {
             int cpu_count = rr_cpu_count();
@@ -254,7 +254,7 @@ static void *rr_cpu_thread_fn(void *arg)
             if (cpu_can_run(cpu)) {
                 int r;
 
-                qemu_mutex_unlock_iothread();
+                bql_unlock();
                 if (icount_enabled()) {
                     icount_prepare_for_run(cpu, cpu_budget);
                 }
@@ -262,15 +262,15 @@ static void *rr_cpu_thread_fn(void *arg)
                 if (icount_enabled()) {
                     icount_process_data(cpu);
                 }
-                qemu_mutex_lock_iothread();
+                bql_lock();
 
                 if (r == EXCP_DEBUG) {
                     cpu_handle_guest_debug(cpu);
                     break;
                 } else if (r == EXCP_ATOMIC) {
-                    qemu_mutex_unlock_iothread();
+                    bql_unlock();
                     cpu_exec_step_atomic(cpu);
-                    qemu_mutex_lock_iothread();
+                    bql_lock();
                     break;
                 }
             } else if (cpu->stop) {
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 1b57290682..813065c0ec 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -88,7 +88,7 @@ static void tcg_cpu_reset_hold(CPUState *cpu)
 /* mask must never be zero, except for A20 change call */
 void tcg_handle_interrupt(CPUState *cpu, int mask)
 {
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     cpu->interrupt_request |= mask;
 
diff --git a/accel/tcg/translate-all.c b/accel/tcg/translate-all.c
index 79a88f5fb7..1737bb3da5 100644
--- a/accel/tcg/translate-all.c
+++ b/accel/tcg/translate-all.c
@@ -649,7 +649,7 @@ void cpu_io_recompile(CPUState *cpu, uintptr_t retaddr)
 
 void cpu_interrupt(CPUState *cpu, int mask)
 {
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     cpu->interrupt_request |= mask;
     qatomic_set(&cpu->neg.icount_decr.u16.high, -1);
 }
diff --git a/cpu-common.c b/cpu-common.c
index c81fd72d16..ce78273af5 100644
--- a/cpu-common.c
+++ b/cpu-common.c
@@ -351,11 +351,11 @@ void process_queued_cpu_work(CPUState *cpu)
              * BQL, so it goes to sleep; start_exclusive() is sleeping too, so
              * neither CPU can proceed.
              */
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             start_exclusive();
             wi->func(cpu, wi->data);
             end_exclusive();
-            qemu_mutex_lock_iothread();
+            bql_lock();
         } else {
             wi->func(cpu, wi->data);
         }
diff --git a/dump/dump.c b/dump/dump.c
index 4819050764..84064d890d 100644
--- a/dump/dump.c
+++ b/dump/dump.c
@@ -108,11 +108,11 @@ static int dump_cleanup(DumpState *s)
     s->guest_note = NULL;
     if (s->resume) {
         if (s->detached) {
-            qemu_mutex_lock_iothread();
+            bql_lock();
         }
         vm_start();
         if (s->detached) {
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
         }
     }
     migrate_del_blocker(&dump_migration_blocker);
diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index d0e7bbdf06..3ccfe882e2 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -70,14 +70,14 @@ CPUState *cpu_create(const char *typename)
  * BQL here if we need to.  cpu_interrupt assumes it is held.*/
 void cpu_reset_interrupt(CPUState *cpu, int mask)
 {
-    bool need_lock = !qemu_mutex_iothread_locked();
+    bool need_lock = !bql_locked();
 
     if (need_lock) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
     cpu->interrupt_request &= ~mask;
     if (need_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 }
 
diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index ed5677c0ae..1a07faddb4 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -1665,7 +1665,7 @@ static bool vtd_switch_address_space(VTDAddressSpace *as)
 {
     bool use_iommu, pt;
     /* Whether we need to take the BQL on our own */
-    bool take_bql = !qemu_mutex_iothread_locked();
+    bool take_bql = !bql_locked();
 
     assert(as);
 
@@ -1683,7 +1683,7 @@ static bool vtd_switch_address_space(VTDAddressSpace *as)
      * it. We'd better make sure we have had it already, or, take it.
      */
     if (take_bql) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
 
     /* Turn off first then on the other */
@@ -1738,7 +1738,7 @@ static bool vtd_switch_address_space(VTDAddressSpace *as)
     }
 
     if (take_bql) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
     return use_iommu;
diff --git a/hw/i386/kvm/xen_evtchn.c b/hw/i386/kvm/xen_evtchn.c
index 9a5f3caa24..4a835a1010 100644
--- a/hw/i386/kvm/xen_evtchn.c
+++ b/hw/i386/kvm/xen_evtchn.c
@@ -425,7 +425,7 @@ void xen_evtchn_set_callback_level(int level)
      * effect immediately. That just leaves interdomain loopback as the case
      * which uses the BH.
      */
-    if (!qemu_mutex_iothread_locked()) {
+    if (!bql_locked()) {
         qemu_bh_schedule(s->gsi_bh);
         return;
     }
@@ -459,7 +459,7 @@ int xen_evtchn_set_callback_param(uint64_t param)
      * We need the BQL because set_callback_pci_intx() may call into PCI code,
      * and because we may need to manipulate the old and new GSI levels.
      */
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
     qemu_mutex_lock(&s->port_lock);
 
     switch (type) {
@@ -1037,7 +1037,7 @@ static int close_port(XenEvtchnState *s, evtchn_port_t port,
     XenEvtchnPort *p = &s->port_table[port];
 
     /* Because it *might* be a PIRQ port */
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     switch (p->type) {
     case EVTCHNSTAT_closed:
@@ -1104,7 +1104,7 @@ int xen_evtchn_soft_reset(void)
         return -ENOTSUP;
     }
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     qemu_mutex_lock(&s->port_lock);
 
@@ -1601,7 +1601,7 @@ bool xen_evtchn_set_gsi(int gsi, int level)
     XenEvtchnState *s = xen_evtchn_singleton;
     int pirq;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     if (!s || gsi < 0 || gsi >= IOAPIC_NUM_PINS) {
         return false;
@@ -1712,7 +1712,7 @@ void xen_evtchn_snoop_msi(PCIDevice *dev, bool is_msix, unsigned int vector,
         return;
     }
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     pirq = msi_pirq_target(addr, data);
 
@@ -1749,7 +1749,7 @@ int xen_evtchn_translate_pirq_msi(struct kvm_irq_routing_entry *route,
         return 1; /* Not a PIRQ */
     }
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     pirq = msi_pirq_target(address, data);
     if (!pirq || pirq >= s->nr_pirqs) {
@@ -1796,7 +1796,7 @@ bool xen_evtchn_deliver_pirq_msi(uint64_t address, uint32_t data)
         return false;
     }
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     pirq = msi_pirq_target(address, data);
     if (!pirq || pirq >= s->nr_pirqs) {
diff --git a/hw/i386/kvm/xen_overlay.c b/hw/i386/kvm/xen_overlay.c
index 526f7a6077..c68e78ac5c 100644
--- a/hw/i386/kvm/xen_overlay.c
+++ b/hw/i386/kvm/xen_overlay.c
@@ -194,7 +194,7 @@ int xen_overlay_map_shinfo_page(uint64_t gpa)
         return -ENOENT;
     }
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     if (s->shinfo_gpa) {
         /* If removing shinfo page, turn the kernel magic off first */
diff --git a/hw/i386/kvm/xen_xenstore.c b/hw/i386/kvm/xen_xenstore.c
index c3633f7829..1a9bc342b8 100644
--- a/hw/i386/kvm/xen_xenstore.c
+++ b/hw/i386/kvm/xen_xenstore.c
@@ -1341,7 +1341,7 @@ static void fire_watch_cb(void *opaque, const char *path, const char *token)
 {
     XenXenstoreState *s = opaque;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     /*
      * If there's a response pending, we obviously can't scribble over
diff --git a/hw/intc/arm_gicv3_cpuif.c b/hw/intc/arm_gicv3_cpuif.c
index ab1a00508e..77c2a6dd3b 100644
--- a/hw/intc/arm_gicv3_cpuif.c
+++ b/hw/intc/arm_gicv3_cpuif.c
@@ -934,7 +934,7 @@ void gicv3_cpuif_update(GICv3CPUState *cs)
     ARMCPU *cpu = ARM_CPU(cs->cpu);
     CPUARMState *env = &cpu->env;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     trace_gicv3_cpuif_update(gicv3_redist_affid(cs), cs->hppi.irq,
                              cs->hppi.grp, cs->hppi.prio);
diff --git a/hw/intc/s390_flic.c b/hw/intc/s390_flic.c
index 212f268581..f4a848460b 100644
--- a/hw/intc/s390_flic.c
+++ b/hw/intc/s390_flic.c
@@ -106,7 +106,7 @@ static int qemu_s390_clear_io_flic(S390FLICState *fs, uint16_t subchannel_id,
     QEMUS390FlicIO *cur, *next;
     uint8_t isc;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     if (!(flic->pending & FLIC_PENDING_IO)) {
         return 0;
     }
@@ -223,7 +223,7 @@ uint32_t qemu_s390_flic_dequeue_service(QEMUS390FLICState *flic)
 {
     uint32_t tmp;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     g_assert(flic->pending & FLIC_PENDING_SERVICE);
     tmp = flic->service_param;
     flic->service_param = 0;
@@ -238,7 +238,7 @@ QEMUS390FlicIO *qemu_s390_flic_dequeue_io(QEMUS390FLICState *flic, uint64_t cr6)
     QEMUS390FlicIO *io;
     uint8_t isc;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     if (!(flic->pending & CR6_TO_PENDING_IO(cr6))) {
         return NULL;
     }
@@ -262,7 +262,7 @@ QEMUS390FlicIO *qemu_s390_flic_dequeue_io(QEMUS390FLICState *flic, uint64_t cr6)
 
 void qemu_s390_flic_dequeue_crw_mchk(QEMUS390FLICState *flic)
 {
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     g_assert(flic->pending & FLIC_PENDING_MCHK_CR);
     flic->pending &= ~FLIC_PENDING_MCHK_CR;
 }
@@ -271,7 +271,7 @@ static void qemu_s390_inject_service(S390FLICState *fs, uint32_t parm)
 {
     QEMUS390FLICState *flic = s390_get_qemu_flic(fs);
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     /* multiplexing is good enough for sclp - kvm does it internally as well */
     flic->service_param |= parm;
     flic->pending |= FLIC_PENDING_SERVICE;
@@ -287,7 +287,7 @@ static void qemu_s390_inject_io(S390FLICState *fs, uint16_t subchannel_id,
     QEMUS390FLICState *flic = s390_get_qemu_flic(fs);
     QEMUS390FlicIO *io;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     io = g_new0(QEMUS390FlicIO, 1);
     io->id = subchannel_id;
     io->nr = subchannel_nr;
@@ -304,7 +304,7 @@ static void qemu_s390_inject_crw_mchk(S390FLICState *fs)
 {
     QEMUS390FLICState *flic = s390_get_qemu_flic(fs);
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     flic->pending |= FLIC_PENDING_MCHK_CR;
 
     qemu_s390_flic_notify(FLIC_PENDING_MCHK_CR);
@@ -330,7 +330,7 @@ bool qemu_s390_flic_has_crw_mchk(QEMUS390FLICState *flic)
 
 bool qemu_s390_flic_has_any(QEMUS390FLICState *flic)
 {
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     return !!flic->pending;
 }
 
@@ -340,7 +340,7 @@ static void qemu_s390_flic_reset(DeviceState *dev)
     QEMUS390FlicIO *cur, *next;
     int isc;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     flic->simm = 0;
     flic->nimm = 0;
     flic->pending = 0;
diff --git a/hw/misc/edu.c b/hw/misc/edu.c
index e64a246d3f..2a976ca2b1 100644
--- a/hw/misc/edu.c
+++ b/hw/misc/edu.c
@@ -355,9 +355,9 @@ static void *edu_fact_thread(void *opaque)
         smp_mb__after_rmw();
 
         if (qatomic_read(&edu->status) & EDU_STATUS_IRQFACT) {
-            qemu_mutex_lock_iothread();
+            bql_lock();
             edu_raise_irq(edu, FACT_IRQ);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
         }
     }
 
diff --git a/hw/misc/imx6_src.c b/hw/misc/imx6_src.c
index d20727e20b..0c6003559f 100644
--- a/hw/misc/imx6_src.c
+++ b/hw/misc/imx6_src.c
@@ -131,7 +131,7 @@ static void imx6_clear_reset_bit(CPUState *cpu, run_on_cpu_data data)
     struct SRCSCRResetInfo *ri = data.host_ptr;
     IMX6SRCState *s = ri->s;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     s->regs[SRC_SCR] = deposit32(s->regs[SRC_SCR], ri->reset_bit, 1, 0);
     DPRINTF("reg[%s] <= 0x%" PRIx32 "\n",
diff --git a/hw/misc/imx7_src.c b/hw/misc/imx7_src.c
index 24a0b4618c..b3725ff6e7 100644
--- a/hw/misc/imx7_src.c
+++ b/hw/misc/imx7_src.c
@@ -136,7 +136,7 @@ static void imx7_clear_reset_bit(CPUState *cpu, run_on_cpu_data data)
     struct SRCSCRResetInfo *ri = data.host_ptr;
     IMX7SRCState *s = ri->s;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     s->regs[SRC_A7RCR0] = deposit32(s->regs[SRC_A7RCR0], ri->reset_bit, 1, 0);
 
diff --git a/hw/net/xen_nic.c b/hw/net/xen_nic.c
index 1e2b3baeb1..453fdb9819 100644
--- a/hw/net/xen_nic.c
+++ b/hw/net/xen_nic.c
@@ -133,7 +133,7 @@ static bool net_tx_packets(struct XenNetDev *netdev)
     void *page;
     void *tmpbuf = NULL;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     for (;;) {
         rc = netdev->tx_ring.req_cons;
@@ -260,7 +260,7 @@ static ssize_t net_rx_packet(NetClientState *nc, const uint8_t *buf, size_t size
     RING_IDX rc, rp;
     void *page;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     if (xen_device_backend_get_state(&netdev->xendev) != XenbusStateConnected) {
         return -1;
@@ -354,7 +354,7 @@ static bool xen_netdev_connect(XenDevice *xendev, Error **errp)
     XenNetDev *netdev = XEN_NET_DEVICE(xendev);
     unsigned int port, rx_copy;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     if (xen_device_frontend_scanf(xendev, "tx-ring-ref", "%u",
                                   &netdev->tx_ring_ref) != 1) {
@@ -425,7 +425,7 @@ static void xen_netdev_disconnect(XenDevice *xendev, Error **errp)
 
     trace_xen_netdev_disconnect(netdev->dev);
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     netdev->tx_ring.sring = NULL;
     netdev->rx_ring.sring = NULL;
diff --git a/hw/ppc/pegasos2.c b/hw/ppc/pegasos2.c
index 3203a4a728..d84f3f977d 100644
--- a/hw/ppc/pegasos2.c
+++ b/hw/ppc/pegasos2.c
@@ -515,7 +515,7 @@ static void pegasos2_hypercall(PPCVirtualHypervisor *vhyp, PowerPCCPU *cpu)
     CPUPPCState *env = &cpu->env;
 
     /* The TCG path should also be holding the BQL at this point */
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     if (FIELD_EX64(env->msr, MSR, PR)) {
         qemu_log_mask(LOG_GUEST_ERROR, "Hypercall made with MSR[PR]=1\n");
diff --git a/hw/ppc/ppc.c b/hw/ppc/ppc.c
index c532d79f0e..da1626f4d2 100644
--- a/hw/ppc/ppc.c
+++ b/hw/ppc/ppc.c
@@ -314,7 +314,7 @@ void store_40x_dbcr0(CPUPPCState *env, uint32_t val)
 {
     PowerPCCPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     switch ((val >> 28) & 0x3) {
     case 0x0:
@@ -334,7 +334,7 @@ void store_40x_dbcr0(CPUPPCState *env, uint32_t val)
         break;
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 /* PowerPC 40x internal IRQ controller */
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 4997aa4f1d..e8dabc8614 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -1304,7 +1304,7 @@ static void emulate_spapr_hypercall(PPCVirtualHypervisor *vhyp,
     CPUPPCState *env = &cpu->env;
 
     /* The TCG path should also be holding the BQL at this point */
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     g_assert(!vhyp_cpu_in_nested(cpu));
 
diff --git a/hw/ppc/spapr_rng.c b/hw/ppc/spapr_rng.c
index df5c4b9687..c2fda7ad20 100644
--- a/hw/ppc/spapr_rng.c
+++ b/hw/ppc/spapr_rng.c
@@ -82,9 +82,9 @@ static target_ulong h_random(PowerPCCPU *cpu, SpaprMachineState *spapr,
     while (hrdata.received < 8) {
         rng_backend_request_entropy(rngstate->backend, 8 - hrdata.received,
                                     random_recv, &hrdata);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         qemu_sem_wait(&hrdata.sem);
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
 
     qemu_sem_destroy(&hrdata.sem);
diff --git a/hw/ppc/spapr_softmmu.c b/hw/ppc/spapr_softmmu.c
index 278666317e..fc1bbc0b61 100644
--- a/hw/ppc/spapr_softmmu.c
+++ b/hw/ppc/spapr_softmmu.c
@@ -334,7 +334,7 @@ static void *hpt_prepare_thread(void *opaque)
         pending->ret = H_NO_MEM;
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     if (SPAPR_MACHINE(qdev_get_machine())->pending_hpt == pending) {
         /* Ready to go */
@@ -344,7 +344,7 @@ static void *hpt_prepare_thread(void *opaque)
         free_pending_hpt(pending);
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     return NULL;
 }
 
diff --git a/hw/remote/mpqemu-link.c b/hw/remote/mpqemu-link.c
index 9bd98e8219..d04ac93621 100644
--- a/hw/remote/mpqemu-link.c
+++ b/hw/remote/mpqemu-link.c
@@ -33,7 +33,7 @@
  */
 bool mpqemu_msg_send(MPQemuMsg *msg, QIOChannel *ioc, Error **errp)
 {
-    bool iolock = qemu_mutex_iothread_locked();
+    bool drop_bql = bql_locked();
     bool iothread = qemu_in_iothread();
     struct iovec send[2] = {};
     int *fds = NULL;
@@ -63,8 +63,8 @@ bool mpqemu_msg_send(MPQemuMsg *msg, QIOChannel *ioc, Error **errp)
      * for IOThread case.
      * Also skip lock handling while in a co-routine in the main context.
      */
-    if (iolock && !iothread && !qemu_in_coroutine()) {
-        qemu_mutex_unlock_iothread();
+    if (drop_bql && !iothread && !qemu_in_coroutine()) {
+        bql_unlock();
     }
 
     if (!qio_channel_writev_full_all(ioc, send, G_N_ELEMENTS(send),
@@ -74,9 +74,9 @@ bool mpqemu_msg_send(MPQemuMsg *msg, QIOChannel *ioc, Error **errp)
         trace_mpqemu_send_io_error(msg->cmd, msg->size, nfds);
     }
 
-    if (iolock && !iothread && !qemu_in_coroutine()) {
+    if (drop_bql && !iothread && !qemu_in_coroutine()) {
         /* See above comment why skip locking here. */
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
 
     return ret;
@@ -96,7 +96,7 @@ static ssize_t mpqemu_read(QIOChannel *ioc, void *buf, size_t len, int **fds,
                            size_t *nfds, Error **errp)
 {
     struct iovec iov = { .iov_base = buf, .iov_len = len };
-    bool iolock = qemu_mutex_iothread_locked();
+    bool drop_bql = bql_locked();
     bool iothread = qemu_in_iothread();
     int ret = -1;
 
@@ -106,14 +106,14 @@ static ssize_t mpqemu_read(QIOChannel *ioc, void *buf, size_t len, int **fds,
      */
     assert(qemu_in_coroutine() || !iothread);
 
-    if (iolock && !iothread && !qemu_in_coroutine()) {
-        qemu_mutex_unlock_iothread();
+    if (drop_bql && !iothread && !qemu_in_coroutine()) {
+        bql_unlock();
     }
 
     ret = qio_channel_readv_full_all_eof(ioc, &iov, 1, fds, nfds, errp);
 
-    if (iolock && !iothread && !qemu_in_coroutine()) {
-        qemu_mutex_lock_iothread();
+    if (drop_bql && !iothread && !qemu_in_coroutine()) {
+        bql_lock();
     }
 
     return (ret <= 0) ? ret : iov.iov_len;
diff --git a/hw/remote/vfio-user-obj.c b/hw/remote/vfio-user-obj.c
index 8b10c32a3c..d9b879e056 100644
--- a/hw/remote/vfio-user-obj.c
+++ b/hw/remote/vfio-user-obj.c
@@ -400,7 +400,7 @@ static int vfu_object_mr_rw(MemoryRegion *mr, uint8_t *buf, hwaddr offset,
         }
 
         if (release_lock) {
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             release_lock = false;
         }
 
diff --git a/hw/s390x/s390-skeys.c b/hw/s390x/s390-skeys.c
index 8f5159d85d..5c535d483e 100644
--- a/hw/s390x/s390-skeys.c
+++ b/hw/s390x/s390-skeys.c
@@ -153,7 +153,7 @@ void qmp_dump_skeys(const char *filename, Error **errp)
         goto out;
     }
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
     guest_phys_blocks_init(&guest_phys_blocks);
     guest_phys_blocks_append(&guest_phys_blocks);
 
diff --git a/migration/block-dirty-bitmap.c b/migration/block-dirty-bitmap.c
index 24347ab0f7..92e031b6fa 100644
--- a/migration/block-dirty-bitmap.c
+++ b/migration/block-dirty-bitmap.c
@@ -774,7 +774,7 @@ static void dirty_bitmap_state_pending(void *opaque,
     SaveBitmapState *dbms;
     uint64_t pending = 0;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     QSIMPLEQ_FOREACH(dbms, &s->dbms_list, entry) {
         uint64_t gran = bdrv_dirty_bitmap_granularity(dbms->bitmap);
@@ -784,7 +784,7 @@ static void dirty_bitmap_state_pending(void *opaque,
         pending += DIV_ROUND_UP(sectors * BDRV_SECTOR_SIZE, gran);
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     trace_dirty_bitmap_state_pending(pending);
 
diff --git a/migration/block.c b/migration/block.c
index 6ec6a1d6e6..b731d7d778 100644
--- a/migration/block.c
+++ b/migration/block.c
@@ -269,7 +269,7 @@ static int mig_save_device_bulk(QEMUFile *f, BlkMigDevState *bmds)
     int64_t count;
 
     if (bmds->shared_base) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         /* Skip unallocated sectors; intentionally treats failure or
          * partial sector as an allocated sector */
         while (cur_sector < total_sectors &&
@@ -280,7 +280,7 @@ static int mig_save_device_bulk(QEMUFile *f, BlkMigDevState *bmds)
             }
             cur_sector += count >> BDRV_SECTOR_BITS;
         }
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
     if (cur_sector >= total_sectors) {
@@ -316,12 +316,12 @@ static int mig_save_device_bulk(QEMUFile *f, BlkMigDevState *bmds)
      * I/O runs in the main loop AioContext (see
      * qemu_get_current_aio_context()).
      */
-    qemu_mutex_lock_iothread();
+    bql_lock();
     bdrv_reset_dirty_bitmap(bmds->dirty_bitmap, cur_sector * BDRV_SECTOR_SIZE,
                             nr_sectors * BDRV_SECTOR_SIZE);
     blk->aiocb = blk_aio_preadv(bb, cur_sector * BDRV_SECTOR_SIZE, &blk->qiov,
                                 0, blk_mig_read_cb, blk);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     bmds->cur_sector = cur_sector + nr_sectors;
     return (bmds->cur_sector >= total_sectors);
@@ -770,9 +770,9 @@ static int block_save_iterate(QEMUFile *f, void *opaque)
             /* Always called with iothread lock taken for
              * simplicity, block_save_complete also calls it.
              */
-            qemu_mutex_lock_iothread();
+            bql_lock();
             ret = blk_mig_save_dirty_block(f, 1);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
         }
         if (ret < 0) {
             return ret;
@@ -844,9 +844,9 @@ static void block_state_pending(void *opaque, uint64_t *must_precopy,
     /* Estimate pending number of bytes to send */
     uint64_t pending;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     pending = get_remaining_dirty();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     blk_mig_lock();
     pending += block_mig_state.submitted * BLK_MIG_BLOCK_SIZE +
diff --git a/migration/colo.c b/migration/colo.c
index 4447e34914..2a74efdd77 100644
--- a/migration/colo.c
+++ b/migration/colo.c
@@ -420,13 +420,13 @@ static int colo_do_checkpoint_transaction(MigrationState *s,
     qio_channel_io_seek(QIO_CHANNEL(bioc), 0, 0, NULL);
     bioc->usage = 0;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     if (failover_get_state() != FAILOVER_STATUS_NONE) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         goto out;
     }
     vm_stop_force_state(RUN_STATE_COLO);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     trace_colo_vm_state_change("run", "stop");
     /*
      * Failover request bh could be called after vm_stop_force_state(),
@@ -435,23 +435,23 @@ static int colo_do_checkpoint_transaction(MigrationState *s,
     if (failover_get_state() != FAILOVER_STATUS_NONE) {
         goto out;
     }
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     replication_do_checkpoint_all(&local_err);
     if (local_err) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         goto out;
     }
 
     colo_send_message(s->to_dst_file, COLO_MESSAGE_VMSTATE_SEND, &local_err);
     if (local_err) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         goto out;
     }
     /* Note: device state is saved into buffer */
     ret = qemu_save_device_state(fb);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     if (ret < 0) {
         goto out;
     }
@@ -504,9 +504,9 @@ static int colo_do_checkpoint_transaction(MigrationState *s,
 
     ret = 0;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     vm_start();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     trace_colo_vm_state_change("stop", "run");
 
 out:
@@ -557,15 +557,15 @@ static void colo_process_checkpoint(MigrationState *s)
     fb = qemu_file_new_output(QIO_CHANNEL(bioc));
     object_unref(OBJECT(bioc));
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     replication_start_all(REPLICATION_MODE_PRIMARY, &local_err);
     if (local_err) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         goto out;
     }
 
     vm_start();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     trace_colo_vm_state_change("stop", "run");
 
     timer_mod(s->colo_delay_timer, qemu_clock_get_ms(QEMU_CLOCK_HOST) +
@@ -639,14 +639,14 @@ out:
 
 void migrate_start_colo_process(MigrationState *s)
 {
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     qemu_event_init(&s->colo_checkpoint_event, false);
     s->colo_delay_timer =  timer_new_ms(QEMU_CLOCK_HOST,
                                 colo_checkpoint_notify, s);
 
     qemu_sem_init(&s->colo_exit_sem, 0);
     colo_process_checkpoint(s);
-    qemu_mutex_lock_iothread();
+    bql_lock();
 }
 
 static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
@@ -657,9 +657,9 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
     Error *local_err = NULL;
     int ret;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     vm_stop_force_state(RUN_STATE_COLO);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     trace_colo_vm_state_change("run", "stop");
 
     /* FIXME: This is unnecessary for periodic checkpoint mode */
@@ -677,10 +677,10 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
         return;
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     cpu_synchronize_all_states();
     ret = qemu_loadvm_state_main(mis->from_src_file, mis);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     if (ret < 0) {
         error_setg(errp, "Load VM's live state (ram) error");
@@ -719,14 +719,14 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
         return;
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     vmstate_loading = true;
     colo_flush_ram_cache();
     ret = qemu_load_device_state(fb);
     if (ret < 0) {
         error_setg(errp, "COLO: load device state failed");
         vmstate_loading = false;
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         return;
     }
 
@@ -734,7 +734,7 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
     if (local_err) {
         error_propagate(errp, local_err);
         vmstate_loading = false;
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         return;
     }
 
@@ -743,7 +743,7 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
     if (local_err) {
         error_propagate(errp, local_err);
         vmstate_loading = false;
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         return;
     }
     /* Notify all filters of all NIC to do checkpoint */
@@ -752,13 +752,13 @@ static void colo_incoming_process_checkpoint(MigrationIncomingState *mis,
     if (local_err) {
         error_propagate(errp, local_err);
         vmstate_loading = false;
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         return;
     }
 
     vmstate_loading = false;
     vm_start();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     trace_colo_vm_state_change("stop", "run");
 
     if (failover_get_state() == FAILOVER_STATUS_RELAUNCH) {
@@ -851,14 +851,14 @@ static void *colo_process_incoming_thread(void *opaque)
     fb = qemu_file_new_input(QIO_CHANNEL(bioc));
     object_unref(OBJECT(bioc));
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     replication_start_all(REPLICATION_MODE_SECONDARY, &local_err);
     if (local_err) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         goto out;
     }
     vm_start();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     trace_colo_vm_state_change("stop", "run");
 
     colo_send_message(mis->to_src_file, COLO_MESSAGE_CHECKPOINT_READY,
@@ -920,7 +920,7 @@ int coroutine_fn colo_incoming_co(void)
     Error *local_err = NULL;
     QemuThread th;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     if (!migration_incoming_colo_enabled()) {
         return 0;
@@ -940,10 +940,10 @@ int coroutine_fn colo_incoming_co(void)
     qemu_coroutine_yield();
     mis->colo_incoming_co = NULL;
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     /* Wait checkpoint incoming thread exit before free resource */
     qemu_thread_join(&th);
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     /* We hold the global iothread lock, so it is safe here */
     colo_release_ram_cache();
diff --git a/migration/dirtyrate.c b/migration/dirtyrate.c
index 62d86b8be2..1d2e85746f 100644
--- a/migration/dirtyrate.c
+++ b/migration/dirtyrate.c
@@ -90,13 +90,13 @@ static int64_t do_calculate_dirtyrate(DirtyPageRecord dirty_pages,
 
 void global_dirty_log_change(unsigned int flag, bool start)
 {
-    qemu_mutex_lock_iothread();
+    bql_lock();
     if (start) {
         memory_global_dirty_log_start(flag);
     } else {
         memory_global_dirty_log_stop(flag);
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 /*
@@ -106,12 +106,12 @@ void global_dirty_log_change(unsigned int flag, bool start)
  */
 static void global_dirty_log_sync(unsigned int flag, bool one_shot)
 {
-    qemu_mutex_lock_iothread();
+    bql_lock();
     memory_global_dirty_log_sync(false);
     if (one_shot) {
         memory_global_dirty_log_stop(flag);
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 static DirtyPageRecord *vcpu_dirty_stat_alloc(VcpuStat *stat)
@@ -609,7 +609,7 @@ static void calculate_dirtyrate_dirty_bitmap(struct DirtyRateConfig config)
     int64_t start_time;
     DirtyPageRecord dirty_pages;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     memory_global_dirty_log_start(GLOBAL_DIRTY_DIRTY_RATE);
 
     /*
@@ -626,7 +626,7 @@ static void calculate_dirtyrate_dirty_bitmap(struct DirtyRateConfig config)
      * KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE cap is enabled.
      */
     dirtyrate_manual_reset_protect();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     record_dirtypages_bitmap(&dirty_pages, true);
 
diff --git a/migration/migration.c b/migration/migration.c
index 454cd4ec1f..be173cd0f9 100644
--- a/migration/migration.c
+++ b/migration/migration.c
@@ -1283,12 +1283,12 @@ static void migrate_fd_cleanup(MigrationState *s)
         QEMUFile *tmp;
 
         trace_migrate_fd_cleanup();
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         if (s->migration_thread_running) {
             qemu_thread_join(&s->thread);
             s->migration_thread_running = false;
         }
-        qemu_mutex_lock_iothread();
+        bql_lock();
 
         multifd_save_cleanup();
         qemu_mutex_lock(&s->qemu_file_lock);
@@ -2396,7 +2396,7 @@ static int postcopy_start(MigrationState *ms, Error **errp)
     }
 
     trace_postcopy_start();
-    qemu_mutex_lock_iothread();
+    bql_lock();
     trace_postcopy_start_set_run();
 
     migration_downtime_start(ms);
@@ -2504,7 +2504,7 @@ static int postcopy_start(MigrationState *ms, Error **errp)
 
     migration_downtime_end(ms);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     if (migrate_postcopy_ram()) {
         /*
@@ -2545,7 +2545,7 @@ fail:
             error_report_err(local_err);
         }
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     return -1;
 }
 
@@ -2579,14 +2579,14 @@ static int migration_maybe_pause(MigrationState *s,
      * wait for the 'pause_sem' semaphore.
      */
     if (s->state != MIGRATION_STATUS_CANCELLING) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         migrate_set_state(&s->state, *current_active_state,
                           MIGRATION_STATUS_PRE_SWITCHOVER);
         qemu_sem_wait(&s->pause_sem);
         migrate_set_state(&s->state, MIGRATION_STATUS_PRE_SWITCHOVER,
                           new_state);
         *current_active_state = new_state;
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
 
     return s->state == new_state ? 0 : -EINVAL;
@@ -2597,7 +2597,7 @@ static int migration_completion_precopy(MigrationState *s,
 {
     int ret;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     migration_downtime_start(s);
 
     s->vm_old_state = runstate_get();
@@ -2624,7 +2624,7 @@ static int migration_completion_precopy(MigrationState *s,
     ret = qemu_savevm_state_complete_precopy(s->to_dst_file, false,
                                              s->block_inactive);
 out_unlock:
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     return ret;
 }
 
@@ -2632,9 +2632,9 @@ static void migration_completion_postcopy(MigrationState *s)
 {
     trace_migration_completion_postcopy_end();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_savevm_state_complete_postcopy(s->to_dst_file);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     /*
      * Shutdown the postcopy fast path thread.  This is only needed when dest
@@ -2658,14 +2658,14 @@ static void migration_completion_failed(MigrationState *s,
          */
         Error *local_err = NULL;
 
-        qemu_mutex_lock_iothread();
+        bql_lock();
         bdrv_activate_all(&local_err);
         if (local_err) {
             error_report_err(local_err);
         } else {
             s->block_inactive = false;
         }
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
     migrate_set_state(&s->state, current_active_state,
@@ -3105,7 +3105,7 @@ static void migration_iteration_finish(MigrationState *s)
     /* If we enabled cpu throttling for auto-converge, turn it off. */
     cpu_throttle_stop();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     switch (s->state) {
     case MIGRATION_STATUS_COMPLETED:
         migration_calculate_complete(s);
@@ -3136,7 +3136,7 @@ static void migration_iteration_finish(MigrationState *s)
         break;
     }
     migrate_fd_cleanup_schedule(s);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 static void bg_migration_iteration_finish(MigrationState *s)
@@ -3148,7 +3148,7 @@ static void bg_migration_iteration_finish(MigrationState *s)
      */
     ram_write_tracking_stop();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     switch (s->state) {
     case MIGRATION_STATUS_COMPLETED:
         migration_calculate_complete(s);
@@ -3167,7 +3167,7 @@ static void bg_migration_iteration_finish(MigrationState *s)
     }
 
     migrate_fd_cleanup_schedule(s);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 /*
@@ -3289,9 +3289,9 @@ static void *migration_thread(void *opaque)
     object_ref(OBJECT(s));
     update_iteration_initial_status(s);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_savevm_state_header(s->to_dst_file);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     /*
      * If we opened the return path, we need to make sure dst has it
@@ -3319,9 +3319,9 @@ static void *migration_thread(void *opaque)
         qemu_savevm_send_colo_enable(s->to_dst_file);
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_savevm_state_setup(s->to_dst_file);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     qemu_savevm_wait_unplug(s, MIGRATION_STATUS_SETUP,
                                MIGRATION_STATUS_ACTIVE);
@@ -3432,10 +3432,10 @@ static void *bg_migration_thread(void *opaque)
     ram_write_tracking_prepare();
 #endif
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_savevm_state_header(s->to_dst_file);
     qemu_savevm_state_setup(s->to_dst_file);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     qemu_savevm_wait_unplug(s, MIGRATION_STATUS_SETUP,
                                MIGRATION_STATUS_ACTIVE);
@@ -3445,7 +3445,7 @@ static void *bg_migration_thread(void *opaque)
     trace_migration_thread_setup_complete();
     migration_downtime_start(s);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     s->vm_old_state = runstate_get();
 
@@ -3483,7 +3483,7 @@ static void *bg_migration_thread(void *opaque)
     s->vm_start_bh = qemu_bh_new(bg_migration_vm_start_bh, s);
     qemu_bh_schedule(s->vm_start_bh);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     while (migration_is_active(s)) {
         MigIterateState iter_state = bg_migration_iteration_run(s);
@@ -3512,7 +3512,7 @@ fail:
     if (early_fail) {
         migrate_set_state(&s->state, MIGRATION_STATUS_ACTIVE,
                 MIGRATION_STATUS_FAILED);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
     bg_migration_iteration_finish(s);
diff --git a/migration/ram.c b/migration/ram.c
index 8c7886ab79..08dc7e2909 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2984,9 +2984,9 @@ static int ram_save_setup(QEMUFile *f, void *opaque)
     migration_ops = g_malloc0(sizeof(MigrationOps));
     migration_ops->ram_save_target_page = ram_save_target_page_legacy;
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     ret = multifd_send_sync_main(f);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     if (ret < 0) {
         return ret;
     }
@@ -3221,11 +3221,11 @@ static void ram_state_pending_exact(void *opaque, uint64_t *must_precopy,
     uint64_t remaining_size = rs->migration_dirty_pages * TARGET_PAGE_SIZE;
 
     if (!migration_in_postcopy() && remaining_size < s->threshold_size) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         WITH_RCU_READ_LOCK_GUARD() {
             migration_bitmap_sync_precopy(rs, false);
         }
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         remaining_size = rs->migration_dirty_pages * TARGET_PAGE_SIZE;
     }
 
@@ -3453,7 +3453,7 @@ void colo_incoming_start_dirty_log(void)
 {
     RAMBlock *block = NULL;
     /* For memory_global_dirty_log_start below. */
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_mutex_lock_ramlist();
 
     memory_global_dirty_log_sync(false);
@@ -3467,7 +3467,7 @@ void colo_incoming_start_dirty_log(void)
     }
     ram_state->migration_dirty_pages = 0;
     qemu_mutex_unlock_ramlist();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 /* It is need to hold the global lock to call this helper */
diff --git a/replay/replay-internal.c b/replay/replay-internal.c
index 77d0c82327..3e08e381cb 100644
--- a/replay/replay-internal.c
+++ b/replay/replay-internal.c
@@ -216,7 +216,7 @@ void replay_mutex_lock(void)
 {
     if (replay_mode != REPLAY_MODE_NONE) {
         unsigned long id;
-        g_assert(!qemu_mutex_iothread_locked());
+        g_assert(!bql_locked());
         g_assert(!replay_mutex_locked());
         qemu_mutex_lock(&lock);
         id = mutex_tail++;
diff --git a/semihosting/console.c b/semihosting/console.c
index 5d61e8207e..60102bbab6 100644
--- a/semihosting/console.c
+++ b/semihosting/console.c
@@ -43,7 +43,7 @@ static SemihostingConsole console;
 static int console_can_read(void *opaque)
 {
     SemihostingConsole *c = opaque;
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     return (int)fifo8_num_free(&c->fifo);
 }
 
@@ -58,7 +58,7 @@ static void console_wake_up(gpointer data, gpointer user_data)
 static void console_read(void *opaque, const uint8_t *buf, int size)
 {
     SemihostingConsole *c = opaque;
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     while (size-- && !fifo8_is_full(&c->fifo)) {
         fifo8_push(&c->fifo, *buf++);
     }
@@ -70,7 +70,7 @@ bool qemu_semihosting_console_ready(void)
 {
     SemihostingConsole *c = &console;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     return !fifo8_is_empty(&c->fifo);
 }
 
@@ -78,7 +78,7 @@ void qemu_semihosting_console_block_until_ready(CPUState *cs)
 {
     SemihostingConsole *c = &console;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     /* Block if the fifo is completely empty. */
     if (fifo8_is_empty(&c->fifo)) {
diff --git a/stubs/iothread-lock.c b/stubs/iothread-lock.c
index 5b45b7fc8b..d7890e5581 100644
--- a/stubs/iothread-lock.c
+++ b/stubs/iothread-lock.c
@@ -1,15 +1,15 @@
 #include "qemu/osdep.h"
 #include "qemu/main-loop.h"
 
-bool qemu_mutex_iothread_locked(void)
+bool bql_locked(void)
 {
     return false;
 }
 
-void qemu_mutex_lock_iothread_impl(const char *file, int line)
+void bql_lock_impl(const char *file, int line)
 {
 }
 
-void qemu_mutex_unlock_iothread(void)
+void bql_unlock(void)
 {
 }
diff --git a/system/cpu-throttle.c b/system/cpu-throttle.c
index d9bb30a223..786a9a5639 100644
--- a/system/cpu-throttle.c
+++ b/system/cpu-throttle.c
@@ -57,9 +57,9 @@ static void cpu_throttle_thread(CPUState *cpu, run_on_cpu_data opaque)
             qemu_cond_timedwait_iothread(cpu->halt_cond,
                                          sleeptime_ns / SCALE_MS);
         } else {
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             g_usleep(sleeptime_ns / SCALE_US);
-            qemu_mutex_lock_iothread();
+            bql_lock();
         }
         sleeptime_ns = endtime_ns - qemu_clock_get_ns(QEMU_CLOCK_REALTIME);
     }
diff --git a/system/cpus.c b/system/cpus.c
index 7d2c28b1d1..1ede629f1f 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -65,7 +65,8 @@
 
 #endif /* CONFIG_LINUX */
 
-static QemuMutex qemu_global_mutex;
+/* The Big QEMU Lock (BQL) */
+static QemuMutex bql;
 
 /*
  * The chosen accelerator is supposed to register this.
@@ -408,14 +409,14 @@ void qemu_init_cpu_loop(void)
     qemu_init_sigbus();
     qemu_cond_init(&qemu_cpu_cond);
     qemu_cond_init(&qemu_pause_cond);
-    qemu_mutex_init(&qemu_global_mutex);
+    qemu_mutex_init(&bql);
 
     qemu_thread_get_self(&io_thread);
 }
 
 void run_on_cpu(CPUState *cpu, run_on_cpu_func func, run_on_cpu_data data)
 {
-    do_run_on_cpu(cpu, func, data, &qemu_global_mutex);
+    do_run_on_cpu(cpu, func, data, &bql);
 }
 
 static void qemu_cpu_stop(CPUState *cpu, bool exit)
@@ -447,7 +448,7 @@ void qemu_wait_io_event(CPUState *cpu)
             slept = true;
             qemu_plugin_vcpu_idle_cb(cpu);
         }
-        qemu_cond_wait(cpu->halt_cond, &qemu_global_mutex);
+        qemu_cond_wait(cpu->halt_cond, &bql);
     }
     if (slept) {
         qemu_plugin_vcpu_resume_cb(cpu);
@@ -500,46 +501,46 @@ bool qemu_in_vcpu_thread(void)
     return current_cpu && qemu_cpu_is_self(current_cpu);
 }
 
-QEMU_DEFINE_STATIC_CO_TLS(bool, iothread_locked)
+QEMU_DEFINE_STATIC_CO_TLS(bool, bql_locked)
 
-bool qemu_mutex_iothread_locked(void)
+bool bql_locked(void)
 {
-    return get_iothread_locked();
+    return get_bql_locked();
 }
 
 bool qemu_in_main_thread(void)
 {
-    return qemu_mutex_iothread_locked();
+    return bql_locked();
 }
 
 /*
  * The BQL is taken from so many places that it is worth profiling the
  * callers directly, instead of funneling them all through a single function.
  */
-void qemu_mutex_lock_iothread_impl(const char *file, int line)
+void bql_lock_impl(const char *file, int line)
 {
-    QemuMutexLockFunc bql_lock = qatomic_read(&qemu_bql_mutex_lock_func);
+    QemuMutexLockFunc bql_lock_fn = qatomic_read(&bql_mutex_lock_func);
 
-    g_assert(!qemu_mutex_iothread_locked());
-    bql_lock(&qemu_global_mutex, file, line);
-    set_iothread_locked(true);
+    g_assert(!bql_locked());
+    bql_lock_fn(&bql, file, line);
+    set_bql_locked(true);
 }
 
-void qemu_mutex_unlock_iothread(void)
+void bql_unlock(void)
 {
-    g_assert(qemu_mutex_iothread_locked());
-    set_iothread_locked(false);
-    qemu_mutex_unlock(&qemu_global_mutex);
+    g_assert(bql_locked());
+    set_bql_locked(false);
+    qemu_mutex_unlock(&bql);
 }
 
 void qemu_cond_wait_iothread(QemuCond *cond)
 {
-    qemu_cond_wait(cond, &qemu_global_mutex);
+    qemu_cond_wait(cond, &bql);
 }
 
 void qemu_cond_timedwait_iothread(QemuCond *cond, int ms)
 {
-    qemu_cond_timedwait(cond, &qemu_global_mutex, ms);
+    qemu_cond_timedwait(cond, &bql, ms);
 }
 
 /* signal CPU creation */
@@ -590,15 +591,15 @@ void pause_all_vcpus(void)
     replay_mutex_unlock();
 
     while (!all_vcpus_paused()) {
-        qemu_cond_wait(&qemu_pause_cond, &qemu_global_mutex);
+        qemu_cond_wait(&qemu_pause_cond, &bql);
         CPU_FOREACH(cpu) {
             qemu_cpu_kick(cpu);
         }
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     replay_mutex_lock();
-    qemu_mutex_lock_iothread();
+    bql_lock();
 }
 
 void cpu_resume(CPUState *cpu)
@@ -627,9 +628,9 @@ void cpu_remove_sync(CPUState *cpu)
     cpu->stop = true;
     cpu->unplug = true;
     qemu_cpu_kick(cpu);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     qemu_thread_join(cpu->thread);
-    qemu_mutex_lock_iothread();
+    bql_lock();
 }
 
 void cpus_register_accel(const AccelOpsClass *ops)
@@ -668,7 +669,7 @@ void qemu_init_vcpu(CPUState *cpu)
     cpus_accel->create_vcpu_thread(cpu);
 
     while (!cpu->created) {
-        qemu_cond_wait(&qemu_cpu_cond, &qemu_global_mutex);
+        qemu_cond_wait(&qemu_cpu_cond, &bql);
     }
 }
 
diff --git a/system/dirtylimit.c b/system/dirtylimit.c
index 495c7a7082..b5607eb8c2 100644
--- a/system/dirtylimit.c
+++ b/system/dirtylimit.c
@@ -148,9 +148,9 @@ void vcpu_dirty_rate_stat_stop(void)
 {
     qatomic_set(&vcpu_dirty_rate_stat->running, 0);
     dirtylimit_state_unlock();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     qemu_thread_join(&vcpu_dirty_rate_stat->thread);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     dirtylimit_state_lock();
 }
 
diff --git a/system/memory.c b/system/memory.c
index 9ceb229d28..a229a79988 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -1119,7 +1119,7 @@ void memory_region_transaction_commit(void)
     AddressSpace *as;
 
     assert(memory_region_transaction_depth);
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     --memory_region_transaction_depth;
     if (!memory_region_transaction_depth) {
diff --git a/system/physmem.c b/system/physmem.c
index a63853a7bc..4937e67bad 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2639,8 +2639,8 @@ bool prepare_mmio_access(MemoryRegion *mr)
 {
     bool release_lock = false;
 
-    if (!qemu_mutex_iothread_locked()) {
-        qemu_mutex_lock_iothread();
+    if (!bql_locked()) {
+        bql_lock();
         release_lock = true;
     }
     if (mr->flush_coalesced_mmio) {
@@ -2721,7 +2721,7 @@ static MemTxResult flatview_write_continue(FlatView *fv, hwaddr addr,
         }
 
         if (release_lock) {
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             release_lock = false;
         }
 
@@ -2799,7 +2799,7 @@ MemTxResult flatview_read_continue(FlatView *fv, hwaddr addr,
         }
 
         if (release_lock) {
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             release_lock = false;
         }
 
diff --git a/system/runstate.c b/system/runstate.c
index 621a023120..fb07b7b71a 100644
--- a/system/runstate.c
+++ b/system/runstate.c
@@ -819,7 +819,7 @@ void qemu_init_subsystems(void)
 
     qemu_init_cpu_list();
     qemu_init_cpu_loop();
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     atexit(qemu_run_exit_notifiers);
 
diff --git a/system/watchpoint.c b/system/watchpoint.c
index ba5ad13352..b76007ebf6 100644
--- a/system/watchpoint.c
+++ b/system/watchpoint.c
@@ -155,9 +155,9 @@ void cpu_check_watchpoint(CPUState *cpu, vaddr addr, vaddr len,
          * Now raise the debug interrupt so that it will
          * trigger after the current instruction.
          */
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_interrupt(cpu, CPU_INTERRUPT_DEBUG);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         return;
     }
 
diff --git a/target/arm/arm-powerctl.c b/target/arm/arm-powerctl.c
index c078849403..8850381565 100644
--- a/target/arm/arm-powerctl.c
+++ b/target/arm/arm-powerctl.c
@@ -88,7 +88,7 @@ static void arm_set_cpu_on_async_work(CPUState *target_cpu_state,
     g_free(info);
 
     /* Finally set the power status */
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
     target_cpu->power_state = PSCI_ON;
 }
 
@@ -99,7 +99,7 @@ int arm_set_cpu_on(uint64_t cpuid, uint64_t entry, uint64_t context_id,
     ARMCPU *target_cpu;
     struct CpuOnInfo *info;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     DPRINTF("cpu %" PRId64 " (EL %d, %s) @ 0x%" PRIx64 " with R0 = 0x%" PRIx64
             "\n", cpuid, target_el, target_aa64 ? "aarch64" : "aarch32", entry,
@@ -196,7 +196,7 @@ static void arm_set_cpu_on_and_reset_async_work(CPUState *target_cpu_state,
     target_cpu_state->halted = 0;
 
     /* Finally set the power status */
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
     target_cpu->power_state = PSCI_ON;
 }
 
@@ -205,7 +205,7 @@ int arm_set_cpu_on_and_reset(uint64_t cpuid)
     CPUState *target_cpu_state;
     ARMCPU *target_cpu;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     /* Retrieve the cpu we are powering up */
     target_cpu_state = arm_get_cpu_by_id(cpuid);
@@ -247,7 +247,7 @@ static void arm_set_cpu_off_async_work(CPUState *target_cpu_state,
 {
     ARMCPU *target_cpu = ARM_CPU(target_cpu_state);
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
     target_cpu->power_state = PSCI_OFF;
     target_cpu_state->halted = 1;
     target_cpu_state->exception_index = EXCP_HLT;
@@ -258,7 +258,7 @@ int arm_set_cpu_off(uint64_t cpuid)
     CPUState *target_cpu_state;
     ARMCPU *target_cpu;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     DPRINTF("cpu %" PRId64 "\n", cpuid);
 
@@ -294,7 +294,7 @@ int arm_reset_cpu(uint64_t cpuid)
     CPUState *target_cpu_state;
     ARMCPU *target_cpu;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     DPRINTF("cpu %" PRId64 "\n", cpuid);
 
diff --git a/target/arm/helper.c b/target/arm/helper.c
index a2a7f6c29f..7dfd0a1094 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -5851,7 +5851,7 @@ static void do_hcr_write(CPUARMState *env, uint64_t value, uint64_t valid_mask)
      * VFIQ are masked unless running at EL0 or EL1, and HCR
      * can only be written at EL2.
      */
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     arm_cpu_update_virq(cpu);
     arm_cpu_update_vfiq(cpu);
     arm_cpu_update_vserr(cpu);
@@ -11273,7 +11273,7 @@ void arm_cpu_do_interrupt(CPUState *cs)
      * BQL needs to be held for any modification of
      * cs->interrupt_request.
      */
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     arm_call_pre_el_change_hook(cpu);
 
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 203d88f80b..a537a5bc94 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1721,9 +1721,9 @@ static void hvf_wait_for_ipi(CPUState *cpu, struct timespec *ts)
      * sleeping.
      */
     qatomic_set_mb(&cpu->thread_kicked, false);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     pselect(0, 0, 0, 0, ts, &cpu->accel->unblock_ipi_mask);
-    qemu_mutex_lock_iothread();
+    bql_lock();
 }
 
 static void hvf_wfi(CPUState *cpu)
@@ -1824,7 +1824,7 @@ int hvf_vcpu_exec(CPUState *cpu)
 
     flush_cpu_state(cpu);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     assert_hvf_ok(hv_vcpu_run(cpu->accel->fd));
 
     /* handle VMEXIT */
@@ -1833,7 +1833,7 @@ int hvf_vcpu_exec(CPUState *cpu)
     uint32_t ec = syn_get_ec(syndrome);
 
     ret = 0;
-    qemu_mutex_lock_iothread();
+    bql_lock();
     switch (exit_reason) {
     case HV_EXIT_REASON_EXCEPTION:
         /* This is the main one, handle below. */
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index c5a3183843..8f52b211f9 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -1250,7 +1250,7 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
     if (run->s.regs.device_irq_level != cpu->device_irq_level) {
         switched_level = cpu->device_irq_level ^ run->s.regs.device_irq_level;
 
-        qemu_mutex_lock_iothread();
+        bql_lock();
 
         if (switched_level & KVM_ARM_DEV_EL1_VTIMER) {
             qemu_set_irq(cpu->gt_timer_outputs[GTIMER_VIRT],
@@ -1279,7 +1279,7 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
 
         /* We also mark unknown levels as processed to not waste cycles */
         cpu->device_irq_level = run->s.regs.device_irq_level;
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
     return MEMTXATTRS_UNSPECIFIED;
@@ -1410,9 +1410,9 @@ static bool kvm_arm_handle_debug(ARMCPU *cpu,
     env->exception.syndrome = debug_exit->hsr;
     env->exception.vaddress = debug_exit->far;
     env->exception.target_el = 1;
-    qemu_mutex_lock_iothread();
+    bql_lock();
     arm_cpu_do_interrupt(cs);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return false;
 }
diff --git a/target/arm/ptw.c b/target/arm/ptw.c
index 1762b058ae..0ecd3a36da 100644
--- a/target/arm/ptw.c
+++ b/target/arm/ptw.c
@@ -772,9 +772,9 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
 #if !TCG_OVERSIZED_GUEST
 # error "Unexpected configuration"
 #endif
-    bool locked = qemu_mutex_iothread_locked();
+    bool locked = bql_locked();
     if (!locked) {
-       qemu_mutex_lock_iothread();
+        bql_lock();
     }
     if (ptw->out_be) {
         cur_val = ldq_be_p(host);
@@ -788,7 +788,7 @@ static uint64_t arm_casq_ptw(CPUARMState *env, uint64_t old_val,
         }
     }
     if (!locked) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 #endif
 
diff --git a/target/arm/tcg/helper-a64.c b/target/arm/tcg/helper-a64.c
index 8ad84623d3..198b975f20 100644
--- a/target/arm/tcg/helper-a64.c
+++ b/target/arm/tcg/helper-a64.c
@@ -809,9 +809,9 @@ void HELPER(exception_return)(CPUARMState *env, uint64_t new_pc)
         goto illegal_return;
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     arm_call_pre_el_change_hook(env_archcpu(env));
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     if (!return_to_aa64) {
         env->aarch64 = false;
@@ -876,9 +876,9 @@ void HELPER(exception_return)(CPUARMState *env, uint64_t new_pc)
      */
     aarch64_sve_change_el(env, cur_el, new_el, return_to_aa64);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     arm_call_el_change_hook(env_archcpu(env));
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return;
 
diff --git a/target/arm/tcg/m_helper.c b/target/arm/tcg/m_helper.c
index a26adb75aa..d1f1e02acc 100644
--- a/target/arm/tcg/m_helper.c
+++ b/target/arm/tcg/m_helper.c
@@ -373,8 +373,8 @@ void HELPER(v7m_preserve_fp_state)(CPUARMState *env)
     bool ts = is_secure && (env->v7m.fpccr[M_REG_S] & R_V7M_FPCCR_TS_MASK);
     bool take_exception;
 
-    /* Take the iothread lock as we are going to touch the NVIC */
-    qemu_mutex_lock_iothread();
+    /* Take the BQL as we are going to touch the NVIC */
+    bql_lock();
 
     /* Check the background context had access to the FPU */
     if (!v7m_cpacr_pass(env, is_secure, is_priv)) {
@@ -428,7 +428,7 @@ void HELPER(v7m_preserve_fp_state)(CPUARMState *env)
     take_exception = !stacked_ok &&
         armv7m_nvic_can_take_pending_exception(env->nvic);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     if (take_exception) {
         raise_exception_ra(env, EXCP_LAZYFP, 0, 1, GETPC());
diff --git a/target/arm/tcg/op_helper.c b/target/arm/tcg/op_helper.c
index 9de0fa2d1f..105ab63ed7 100644
--- a/target/arm/tcg/op_helper.c
+++ b/target/arm/tcg/op_helper.c
@@ -482,9 +482,9 @@ void HELPER(cpsr_write_eret)(CPUARMState *env, uint32_t val)
 {
     uint32_t mask;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     arm_call_pre_el_change_hook(env_archcpu(env));
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     mask = aarch32_cpsr_valid_mask(env->features, &env_archcpu(env)->isar);
     cpsr_write(env, val, mask, CPSRWriteExceptionReturn);
@@ -497,9 +497,9 @@ void HELPER(cpsr_write_eret)(CPUARMState *env, uint32_t val)
     env->regs[15] &= (env->thumb ? ~1 : ~3);
     arm_rebuild_hflags(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     arm_call_el_change_hook(env_archcpu(env));
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 /* Access to user mode registers from privileged modes.  */
@@ -858,9 +858,9 @@ void HELPER(set_cp_reg)(CPUARMState *env, const void *rip, uint32_t value)
     const ARMCPRegInfo *ri = rip;
 
     if (ri->type & ARM_CP_IO) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         ri->writefn(env, ri, value);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     } else {
         ri->writefn(env, ri, value);
     }
@@ -872,9 +872,9 @@ uint32_t HELPER(get_cp_reg)(CPUARMState *env, const void *rip)
     uint32_t res;
 
     if (ri->type & ARM_CP_IO) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         res = ri->readfn(env, ri);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     } else {
         res = ri->readfn(env, ri);
     }
@@ -887,9 +887,9 @@ void HELPER(set_cp_reg64)(CPUARMState *env, const void *rip, uint64_t value)
     const ARMCPRegInfo *ri = rip;
 
     if (ri->type & ARM_CP_IO) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         ri->writefn(env, ri, value);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     } else {
         ri->writefn(env, ri, value);
     }
@@ -901,9 +901,9 @@ uint64_t HELPER(get_cp_reg64)(CPUARMState *env, const void *rip)
     uint64_t res;
 
     if (ri->type & ARM_CP_IO) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         res = ri->readfn(env, ri);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     } else {
         res = ri->readfn(env, ri);
     }
diff --git a/target/arm/tcg/psci.c b/target/arm/tcg/psci.c
index 6c1239bb96..9080a91d9c 100644
--- a/target/arm/tcg/psci.c
+++ b/target/arm/tcg/psci.c
@@ -107,7 +107,7 @@ void arm_handle_psci_call(ARMCPU *cpu)
             }
             target_cpu = ARM_CPU(target_cpu_state);
 
-            g_assert(qemu_mutex_iothread_locked());
+            g_assert(bql_locked());
             ret = target_cpu->power_state;
             break;
         default:
diff --git a/target/hppa/int_helper.c b/target/hppa/int_helper.c
index 98e9d688f6..efe638b36e 100644
--- a/target/hppa/int_helper.c
+++ b/target/hppa/int_helper.c
@@ -84,17 +84,17 @@ void hppa_cpu_alarm_timer(void *opaque)
 void HELPER(write_eirr)(CPUHPPAState *env, target_ulong val)
 {
     env->cr[CR_EIRR] &= ~val;
-    qemu_mutex_lock_iothread();
+    bql_lock();
     eval_interrupt(env_archcpu(env));
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(write_eiem)(CPUHPPAState *env, target_ulong val)
 {
     env->cr[CR_EIEM] = val;
-    qemu_mutex_lock_iothread();
+    bql_lock();
     eval_interrupt(env_archcpu(env));
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void hppa_cpu_do_interrupt(CPUState *cs)
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 20b9ca3ef5..11ffdd4c69 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -429,9 +429,9 @@ int hvf_vcpu_exec(CPUState *cpu)
         }
         vmx_update_tpr(cpu);
 
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         if (!cpu_is_bsp(X86_CPU(cpu)) && cpu->halted) {
-            qemu_mutex_lock_iothread();
+            bql_lock();
             return EXCP_HLT;
         }
 
@@ -450,7 +450,7 @@ int hvf_vcpu_exec(CPUState *cpu)
         rip = rreg(cpu->accel->fd, HV_X86_RIP);
         env->eflags = rreg(cpu->accel->fd, HV_X86_RFLAGS);
 
-        qemu_mutex_lock_iothread();
+        bql_lock();
 
         update_apic_tpr(cpu);
         current_cpu = cpu;
diff --git a/target/i386/kvm/hyperv.c b/target/i386/kvm/hyperv.c
index e3ac978648..6825c89af3 100644
--- a/target/i386/kvm/hyperv.c
+++ b/target/i386/kvm/hyperv.c
@@ -45,9 +45,9 @@ void hyperv_x86_synic_update(X86CPU *cpu)
 
 static void async_synic_update(CPUState *cs, run_on_cpu_data data)
 {
-    qemu_mutex_lock_iothread();
+    bql_lock();
     hyperv_x86_synic_update(X86_CPU(cs));
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 int kvm_hv_handle_exit(X86CPU *cpu, struct kvm_hyperv_exit *exit)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4ce80555b4..76a66246eb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4713,9 +4713,9 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
     /* Inject NMI */
     if (cpu->interrupt_request & (CPU_INTERRUPT_NMI | CPU_INTERRUPT_SMI)) {
         if (cpu->interrupt_request & CPU_INTERRUPT_NMI) {
-            qemu_mutex_lock_iothread();
+            bql_lock();
             cpu->interrupt_request &= ~CPU_INTERRUPT_NMI;
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             DPRINTF("injected NMI\n");
             ret = kvm_vcpu_ioctl(cpu, KVM_NMI);
             if (ret < 0) {
@@ -4724,9 +4724,9 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
             }
         }
         if (cpu->interrupt_request & CPU_INTERRUPT_SMI) {
-            qemu_mutex_lock_iothread();
+            bql_lock();
             cpu->interrupt_request &= ~CPU_INTERRUPT_SMI;
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             DPRINTF("injected SMI\n");
             ret = kvm_vcpu_ioctl(cpu, KVM_SMI);
             if (ret < 0) {
@@ -4737,7 +4737,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
     }
 
     if (!kvm_pic_in_kernel()) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
 
     /* Force the VCPU out of its inner loop to process any INIT requests
@@ -4790,7 +4790,7 @@ void kvm_arch_pre_run(CPUState *cpu, struct kvm_run *run)
         DPRINTF("setting tpr\n");
         run->cr8 = cpu_get_apic_tpr(x86_cpu->apic_state);
 
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 }
 
@@ -4838,12 +4838,12 @@ MemTxAttrs kvm_arch_post_run(CPUState *cpu, struct kvm_run *run)
     /* We need to protect the apic state against concurrent accesses from
      * different threads in case the userspace irqchip is used. */
     if (!kvm_irqchip_in_kernel()) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
     cpu_set_apic_tpr(x86_cpu->apic_state, run->cr8);
     cpu_set_apic_base(x86_cpu->apic_state, run->apic_base);
     if (!kvm_irqchip_in_kernel()) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     return cpu_get_mem_attrs(env);
 }
@@ -5277,17 +5277,17 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     switch (run->exit_reason) {
     case KVM_EXIT_HLT:
         DPRINTF("handle_hlt\n");
-        qemu_mutex_lock_iothread();
+        bql_lock();
         ret = kvm_handle_halt(cpu);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         break;
     case KVM_EXIT_SET_TPR:
         ret = 0;
         break;
     case KVM_EXIT_TPR_ACCESS:
-        qemu_mutex_lock_iothread();
+        bql_lock();
         ret = kvm_handle_tpr_access(cpu);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         break;
     case KVM_EXIT_FAIL_ENTRY:
         code = run->fail_entry.hardware_entry_failure_reason;
@@ -5313,9 +5313,9 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         break;
     case KVM_EXIT_DEBUG:
         DPRINTF("kvm_exit_debug\n");
-        qemu_mutex_lock_iothread();
+        bql_lock();
         ret = kvm_handle_debug(cpu, &run->debug.arch);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         break;
     case KVM_EXIT_HYPERV:
         ret = kvm_hv_handle_exit(cpu, &run->hyperv);
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index c0631f9cf4..b0ed2e6aeb 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -403,7 +403,7 @@ void kvm_xen_maybe_deassert_callback(CPUState *cs)
 
     /* If the evtchn_upcall_pending flag is cleared, turn the GSI off. */
     if (!vi->evtchn_upcall_pending) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         /*
          * Check again now we have the lock, because it may have been
          * asserted in the interim. And we don't want to take the lock
@@ -413,7 +413,7 @@ void kvm_xen_maybe_deassert_callback(CPUState *cs)
             X86_CPU(cs)->env.xen_callback_asserted = false;
             xen_evtchn_set_callback_level(0);
         }
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 }
 
@@ -773,9 +773,9 @@ static bool handle_set_param(struct kvm_xen_exit *exit, X86CPU *cpu,
 
     switch (hp.index) {
     case HVM_PARAM_CALLBACK_IRQ:
-        qemu_mutex_lock_iothread();
+        bql_lock();
         err = xen_evtchn_set_callback_param(hp.value);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         xen_set_long_mode(exit->u.hcall.longmode);
         break;
     default:
@@ -1408,7 +1408,7 @@ int kvm_xen_soft_reset(void)
     CPUState *cpu;
     int err;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     trace_kvm_xen_soft_reset();
 
@@ -1481,9 +1481,9 @@ static int schedop_shutdown(CPUState *cs, uint64_t arg)
         break;
 
     case SHUTDOWN_soft_reset:
-        qemu_mutex_lock_iothread();
+        bql_lock();
         ret = kvm_xen_soft_reset();
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         break;
 
     default:
diff --git a/target/i386/nvmm/nvmm-accel-ops.c b/target/i386/nvmm/nvmm-accel-ops.c
index 6c46101ac1..f9d5e9a37a 100644
--- a/target/i386/nvmm/nvmm-accel-ops.c
+++ b/target/i386/nvmm/nvmm-accel-ops.c
@@ -25,7 +25,7 @@ static void *qemu_nvmm_cpu_thread_fn(void *arg)
 
     rcu_register_thread();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_thread_get_self(cpu->thread);
     cpu->thread_id = qemu_get_thread_id();
     current_cpu = cpu;
@@ -55,7 +55,7 @@ static void *qemu_nvmm_cpu_thread_fn(void *arg)
 
     nvmm_destroy_vcpu(cpu);
     cpu_thread_signal_destroyed(cpu);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     rcu_unregister_thread();
     return NULL;
 }
diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index 7d752bc5e0..cfdca91123 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -399,7 +399,7 @@ nvmm_vcpu_pre_run(CPUState *cpu)
     uint8_t tpr;
     int ret;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     tpr = cpu_get_apic_tpr(x86_cpu->apic_state);
     if (tpr != qcpu->tpr) {
@@ -462,7 +462,7 @@ nvmm_vcpu_pre_run(CPUState *cpu)
         }
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 /*
@@ -485,9 +485,9 @@ nvmm_vcpu_post_run(CPUState *cpu, struct nvmm_vcpu_exit *exit)
     tpr = exit->exitstate.cr8;
     if (qcpu->tpr != tpr) {
         qcpu->tpr = tpr;
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_set_apic_tpr(x86_cpu->apic_state, qcpu->tpr);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 }
 
@@ -648,7 +648,7 @@ nvmm_handle_halted(struct nvmm_machine *mach, CPUState *cpu,
     CPUX86State *env = cpu_env(cpu);
     int ret = 0;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     if (!((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
           (env->eflags & IF_MASK)) &&
@@ -658,7 +658,7 @@ nvmm_handle_halted(struct nvmm_machine *mach, CPUState *cpu,
         ret = 1;
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return ret;
 }
@@ -721,7 +721,7 @@ nvmm_vcpu_loop(CPUState *cpu)
         return 0;
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     cpu_exec_start(cpu);
 
     /*
@@ -806,16 +806,16 @@ nvmm_vcpu_loop(CPUState *cpu)
             error_report("NVMM: Unexpected VM exit code 0x%lx [hw=0x%lx]",
                 exit->reason, exit->u.inv.hwcode);
             nvmm_get_registers(cpu);
-            qemu_mutex_lock_iothread();
+            bql_lock();
             qemu_system_guest_panicked(cpu_get_crash_info(cpu));
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             ret = -1;
             break;
         }
     } while (ret == 0);
 
     cpu_exec_end(cpu);
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     qatomic_set(&cpu->exit_request, false);
 
diff --git a/target/i386/tcg/sysemu/fpu_helper.c b/target/i386/tcg/sysemu/fpu_helper.c
index 93506cdd94..e0305ba234 100644
--- a/target/i386/tcg/sysemu/fpu_helper.c
+++ b/target/i386/tcg/sysemu/fpu_helper.c
@@ -32,9 +32,9 @@ void x86_register_ferr_irq(qemu_irq irq)
 void fpu_check_raise_ferr_irq(CPUX86State *env)
 {
     if (ferr_irq && !(env->hflags2 & HF2_IGNNE_MASK)) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         qemu_irq_raise(ferr_irq);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         return;
     }
 }
@@ -49,7 +49,7 @@ void cpu_set_ignne(void)
 {
     CPUX86State *env = &X86_CPU(first_cpu)->env;
 
-    assert(qemu_mutex_iothread_locked());
+    assert(bql_locked());
 
     env->hflags2 |= HF2_IGNNE_MASK;
     /*
diff --git a/target/i386/tcg/sysemu/misc_helper.c b/target/i386/tcg/sysemu/misc_helper.c
index e1528b7f80..1ddfc9fe09 100644
--- a/target/i386/tcg/sysemu/misc_helper.c
+++ b/target/i386/tcg/sysemu/misc_helper.c
@@ -118,9 +118,9 @@ void helper_write_crN(CPUX86State *env, int reg, target_ulong t0)
         break;
     case 8:
         if (!(env->hflags2 & HF2_VINTR_MASK)) {
-            qemu_mutex_lock_iothread();
+            bql_lock();
             cpu_set_apic_tpr(env_archcpu(env)->apic_state, t0);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
         }
         env->int_ctl = (env->int_ctl & ~V_TPR_MASK) | (t0 & V_TPR_MASK);
 
diff --git a/target/i386/whpx/whpx-accel-ops.c b/target/i386/whpx/whpx-accel-ops.c
index 67cad86720..e783a760a7 100644
--- a/target/i386/whpx/whpx-accel-ops.c
+++ b/target/i386/whpx/whpx-accel-ops.c
@@ -25,7 +25,7 @@ static void *whpx_cpu_thread_fn(void *arg)
 
     rcu_register_thread();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     qemu_thread_get_self(cpu->thread);
     cpu->thread_id = qemu_get_thread_id();
     current_cpu = cpu;
@@ -55,7 +55,7 @@ static void *whpx_cpu_thread_fn(void *arg)
 
     whpx_destroy_vcpu(cpu);
     cpu_thread_signal_destroyed(cpu);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     rcu_unregister_thread();
     return NULL;
 }
diff --git a/target/i386/whpx/whpx-all.c b/target/i386/whpx/whpx-all.c
index d29ba916a0..a7262654ac 100644
--- a/target/i386/whpx/whpx-all.c
+++ b/target/i386/whpx/whpx-all.c
@@ -1324,7 +1324,7 @@ static int whpx_first_vcpu_starting(CPUState *cpu)
     struct whpx_state *whpx = &whpx_global;
     HRESULT hr;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     if (!QTAILQ_EMPTY(&cpu->breakpoints) ||
             (whpx->breakpoints.breakpoints &&
@@ -1442,7 +1442,7 @@ static int whpx_handle_halt(CPUState *cpu)
     CPUX86State *env = cpu_env(cpu);
     int ret = 0;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     if (!((cpu->interrupt_request & CPU_INTERRUPT_HARD) &&
           (env->eflags & IF_MASK)) &&
         !(cpu->interrupt_request & CPU_INTERRUPT_NMI)) {
@@ -1450,7 +1450,7 @@ static int whpx_handle_halt(CPUState *cpu)
         cpu->halted = true;
         ret = 1;
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return ret;
 }
@@ -1472,7 +1472,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
     memset(&new_int, 0, sizeof(new_int));
     memset(reg_values, 0, sizeof(reg_values));
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     /* Inject NMI */
     if (!vcpu->interruption_pending &&
@@ -1563,7 +1563,7 @@ static void whpx_vcpu_pre_run(CPUState *cpu)
         reg_count += 1;
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     vcpu->ready_for_pic_interrupt = false;
 
     if (reg_count) {
@@ -1590,9 +1590,9 @@ static void whpx_vcpu_post_run(CPUState *cpu)
     uint64_t tpr = vcpu->exit_ctx.VpContext.Cr8;
     if (vcpu->tpr != tpr) {
         vcpu->tpr = tpr;
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_set_apic_tpr(x86_cpu->apic_state, whpx_cr8_to_apic_tpr(vcpu->tpr));
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
     vcpu->interruption_pending =
@@ -1652,7 +1652,7 @@ static int whpx_vcpu_run(CPUState *cpu)
     WhpxStepMode exclusive_step_mode = WHPX_STEP_NONE;
     int ret;
 
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     if (whpx->running_cpus++ == 0) {
         /* Insert breakpoints into memory, update exception exit bitmap. */
@@ -1690,7 +1690,7 @@ static int whpx_vcpu_run(CPUState *cpu)
         }
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     if (exclusive_step_mode != WHPX_STEP_NONE) {
         start_exclusive();
@@ -2028,9 +2028,9 @@ static int whpx_vcpu_run(CPUState *cpu)
             error_report("WHPX: Unexpected VP exit code %d",
                          vcpu->exit_ctx.ExitReason);
             whpx_get_registers(cpu);
-            qemu_mutex_lock_iothread();
+            bql_lock();
             qemu_system_guest_panicked(cpu_get_crash_info(cpu));
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             break;
         }
 
@@ -2055,7 +2055,7 @@ static int whpx_vcpu_run(CPUState *cpu)
         cpu_exec_end(cpu);
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     current_cpu = cpu;
 
     if (--whpx->running_cpus == 0) {
diff --git a/target/loongarch/tcg/csr_helper.c b/target/loongarch/tcg/csr_helper.c
index 55341551a5..15f94caefa 100644
--- a/target/loongarch/tcg/csr_helper.c
+++ b/target/loongarch/tcg/csr_helper.c
@@ -89,9 +89,9 @@ target_ulong helper_csrwr_ticlr(CPULoongArchState *env, target_ulong val)
     int64_t old_v = 0;
 
     if (val & 0x1) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         loongarch_cpu_set_irq(cpu, IRQ_TIMER, 0);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     return old_v;
 }
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index e22e24ed97..15d0cf9adb 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -138,7 +138,7 @@ void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
     int r;
     struct kvm_mips_interrupt intr;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     if ((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
             cpu_mips_io_interrupts_pending(cpu)) {
@@ -151,7 +151,7 @@ void kvm_arch_pre_run(CPUState *cs, struct kvm_run *run)
         }
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
diff --git a/target/mips/tcg/sysemu/cp0_helper.c b/target/mips/tcg/sysemu/cp0_helper.c
index d349548743..cc545aed9c 100644
--- a/target/mips/tcg/sysemu/cp0_helper.c
+++ b/target/mips/tcg/sysemu/cp0_helper.c
@@ -59,9 +59,9 @@ static inline void mips_vpe_wake(MIPSCPU *c)
      * because there might be other conditions that state that c should
      * be sleeping.
      */
-    qemu_mutex_lock_iothread();
+    bql_lock();
     cpu_interrupt(CPU(c), CPU_INTERRUPT_WAKE);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 static inline void mips_vpe_sleep(MIPSCPU *cpu)
diff --git a/target/openrisc/sys_helper.c b/target/openrisc/sys_helper.c
index 782a5751b7..77567afba4 100644
--- a/target/openrisc/sys_helper.c
+++ b/target/openrisc/sys_helper.c
@@ -160,20 +160,20 @@ void HELPER(mtspr)(CPUOpenRISCState *env, target_ulong spr, target_ulong rb)
         break;
     case TO_SPR(9, 0):  /* PICMR */
         env->picmr = rb;
-        qemu_mutex_lock_iothread();
+        bql_lock();
         if (env->picsr & env->picmr) {
             cpu_interrupt(cs, CPU_INTERRUPT_HARD);
         } else {
             cpu_reset_interrupt(cs, CPU_INTERRUPT_HARD);
         }
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         break;
     case TO_SPR(9, 2):  /* PICSR */
         env->picsr &= ~rb;
         break;
     case TO_SPR(10, 0): /* TTMR */
         {
-            qemu_mutex_lock_iothread();
+            bql_lock();
             if ((env->ttmr & TTMR_M) ^ (rb & TTMR_M)) {
                 switch (rb & TTMR_M) {
                 case TIMER_NONE:
@@ -198,15 +198,15 @@ void HELPER(mtspr)(CPUOpenRISCState *env, target_ulong spr, target_ulong rb)
                 cs->interrupt_request &= ~CPU_INTERRUPT_TIMER;
             }
             cpu_openrisc_timer_update(cpu);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
         }
         break;
 
     case TO_SPR(10, 1): /* TTCR */
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_openrisc_count_set(cpu, rb);
         cpu_openrisc_timer_update(cpu);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         break;
     }
 #endif
@@ -347,9 +347,9 @@ target_ulong HELPER(mfspr)(CPUOpenRISCState *env, target_ulong rd,
         return env->ttmr;
 
     case TO_SPR(10, 1): /* TTCR */
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_openrisc_count_update(cpu);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         return cpu_openrisc_count_get(cpu);
     }
 #endif
diff --git a/target/ppc/excp_helper.c b/target/ppc/excp_helper.c
index a42743a3e0..8a2bfb5aa2 100644
--- a/target/ppc/excp_helper.c
+++ b/target/ppc/excp_helper.c
@@ -3056,7 +3056,7 @@ void helper_msgsnd(target_ulong rb)
         return;
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     CPU_FOREACH(cs) {
         PowerPCCPU *cpu = POWERPC_CPU(cs);
         CPUPPCState *cenv = &cpu->env;
@@ -3065,7 +3065,7 @@ void helper_msgsnd(target_ulong rb)
             ppc_set_irq(cpu, irq, 1);
         }
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 /* Server Processor Control */
@@ -3093,7 +3093,7 @@ static void book3s_msgsnd_common(int pir, int irq)
 {
     CPUState *cs;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     CPU_FOREACH(cs) {
         PowerPCCPU *cpu = POWERPC_CPU(cs);
         CPUPPCState *cenv = &cpu->env;
@@ -3103,7 +3103,7 @@ static void book3s_msgsnd_common(int pir, int irq)
             ppc_set_irq(cpu, irq, 1);
         }
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void helper_book3s_msgsnd(target_ulong rb)
@@ -3157,14 +3157,14 @@ void helper_book3s_msgsndp(CPUPPCState *env, target_ulong rb)
     }
 
     /* Does iothread need to be locked for walking CPU list? */
-    qemu_mutex_lock_iothread();
+    bql_lock();
     THREAD_SIBLING_FOREACH(cs, ccs) {
         PowerPCCPU *ccpu = POWERPC_CPU(ccs);
         uint32_t thread_id = ppc_cpu_tir(ccpu);
 
         if (ttir == thread_id) {
             ppc_set_irq(ccpu, PPC_INTERRUPT_DOORBELL, 1);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             return;
         }
     }
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 9b1abe2fc4..26fa9d0575 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -1656,7 +1656,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     CPUPPCState *env = &cpu->env;
     int ret;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     switch (run->exit_reason) {
     case KVM_EXIT_DCR:
@@ -1715,7 +1715,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         break;
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     return ret;
 }
 
diff --git a/target/ppc/misc_helper.c b/target/ppc/misc_helper.c
index a05bdf78c9..a9d41d2802 100644
--- a/target/ppc/misc_helper.c
+++ b/target/ppc/misc_helper.c
@@ -238,7 +238,7 @@ target_ulong helper_load_dpdes(CPUPPCState *env)
         return dpdes;
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     THREAD_SIBLING_FOREACH(cs, ccs) {
         PowerPCCPU *ccpu = POWERPC_CPU(ccs);
         CPUPPCState *cenv = &ccpu->env;
@@ -248,7 +248,7 @@ target_ulong helper_load_dpdes(CPUPPCState *env)
             dpdes |= (0x1 << thread_id);
         }
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return dpdes;
 }
@@ -278,14 +278,14 @@ void helper_store_dpdes(CPUPPCState *env, target_ulong val)
     }
 
     /* Does iothread need to be locked for walking CPU list? */
-    qemu_mutex_lock_iothread();
+    bql_lock();
     THREAD_SIBLING_FOREACH(cs, ccs) {
         PowerPCCPU *ccpu = POWERPC_CPU(ccs);
         uint32_t thread_id = ppc_cpu_tir(ccpu);
 
         ppc_set_irq(cpu, PPC_INTERRUPT_DOORBELL, val & (0x1 << thread_id));
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 #endif /* defined(TARGET_PPC64) */
 
diff --git a/target/ppc/timebase_helper.c b/target/ppc/timebase_helper.c
index 08a6b47ee0..f618ed2922 100644
--- a/target/ppc/timebase_helper.c
+++ b/target/ppc/timebase_helper.c
@@ -173,9 +173,9 @@ target_ulong helper_load_dcr(CPUPPCState *env, target_ulong dcrn)
     } else {
         int ret;
 
-        qemu_mutex_lock_iothread();
+        bql_lock();
         ret = ppc_dcr_read(env->dcr_env, (uint32_t)dcrn, &val);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         if (unlikely(ret != 0)) {
             qemu_log_mask(LOG_GUEST_ERROR, "DCR read error %d %03x\n",
                           (uint32_t)dcrn, (uint32_t)dcrn);
@@ -196,9 +196,9 @@ void helper_store_dcr(CPUPPCState *env, target_ulong dcrn, target_ulong val)
                                POWERPC_EXCP_INVAL_INVAL, GETPC());
     } else {
         int ret;
-        qemu_mutex_lock_iothread();
+        bql_lock();
         ret = ppc_dcr_write(env->dcr_env, (uint32_t)dcrn, (uint32_t)val);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         if (unlikely(ret != 0)) {
             qemu_log_mask(LOG_GUEST_ERROR, "DCR write error %d %03x\n",
                           (uint32_t)dcrn, (uint32_t)dcrn);
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 33ab3551f4..888d6c1a1c 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -1923,7 +1923,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     S390CPU *cpu = S390_CPU(cs);
     int ret = 0;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     kvm_cpu_synchronize_state(cs);
 
@@ -1947,7 +1947,7 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
             fprintf(stderr, "Unknown KVM exit: %d\n", run->exit_reason);
             break;
     }
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     if (ret == 0) {
         ret = EXCP_INTERRUPT;
diff --git a/target/s390x/tcg/misc_helper.c b/target/s390x/tcg/misc_helper.c
index 6aa7907438..89b5268fd4 100644
--- a/target/s390x/tcg/misc_helper.c
+++ b/target/s390x/tcg/misc_helper.c
@@ -101,9 +101,9 @@ uint64_t HELPER(stck)(CPUS390XState *env)
 /* SCLP service call */
 uint32_t HELPER(servc)(CPUS390XState *env, uint64_t r1, uint64_t r2)
 {
-    qemu_mutex_lock_iothread();
+    bql_lock();
     int r = sclp_service_call(env_archcpu(env), r1, r2);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     if (r < 0) {
         tcg_s390_program_interrupt(env, -r, GETPC());
     }
@@ -117,9 +117,9 @@ void HELPER(diag)(CPUS390XState *env, uint32_t r1, uint32_t r3, uint32_t num)
     switch (num) {
     case 0x500:
         /* KVM hypercall */
-        qemu_mutex_lock_iothread();
+        bql_lock();
         r = s390_virtio_hypercall(env);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         break;
     case 0x44:
         /* yield */
@@ -127,9 +127,9 @@ void HELPER(diag)(CPUS390XState *env, uint32_t r1, uint32_t r3, uint32_t num)
         break;
     case 0x308:
         /* ipl */
-        qemu_mutex_lock_iothread();
+        bql_lock();
         handle_diag_308(env, r1, r3, GETPC());
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         r = 0;
         break;
     case 0x288:
@@ -185,7 +185,7 @@ static void update_ckc_timer(CPUS390XState *env)
 
     /* stop the timer and remove pending CKC IRQs */
     timer_del(env->tod_timer);
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
     env->pending_int &= ~INTERRUPT_EXT_CLOCK_COMPARATOR;
 
     /* the tod has to exceed the ckc, this can never happen if ckc is all 1's */
@@ -207,9 +207,9 @@ void HELPER(sckc)(CPUS390XState *env, uint64_t ckc)
 {
     env->ckc = ckc;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     update_ckc_timer(env);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void tcg_s390_tod_updated(CPUState *cs, run_on_cpu_data opaque)
@@ -229,9 +229,9 @@ uint32_t HELPER(sck)(CPUS390XState *env, uint64_t tod_low)
         .low = tod_low,
     };
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     tdc->set(td, &tod, &error_abort);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     return 0;
 }
 
@@ -421,9 +421,9 @@ uint32_t HELPER(sigp)(CPUS390XState *env, uint64_t order_code, uint32_t r1,
     int cc;
 
     /* TODO: needed to inject interrupts  - push further down */
-    qemu_mutex_lock_iothread();
+    bql_lock();
     cc = handle_sigp(env, order_code & SIGP_ORDER_MASK, r1, r3);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     return cc;
 }
@@ -433,92 +433,92 @@ uint32_t HELPER(sigp)(CPUS390XState *env, uint64_t order_code, uint32_t r1,
 void HELPER(xsch)(CPUS390XState *env, uint64_t r1)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_xsch(cpu, r1, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(csch)(CPUS390XState *env, uint64_t r1)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_csch(cpu, r1, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(hsch)(CPUS390XState *env, uint64_t r1)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_hsch(cpu, r1, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(msch)(CPUS390XState *env, uint64_t r1, uint64_t inst)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_msch(cpu, r1, inst >> 16, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(rchp)(CPUS390XState *env, uint64_t r1)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_rchp(cpu, r1, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(rsch)(CPUS390XState *env, uint64_t r1)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_rsch(cpu, r1, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(sal)(CPUS390XState *env, uint64_t r1)
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_sal(cpu, r1, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(schm)(CPUS390XState *env, uint64_t r1, uint64_t r2, uint64_t inst)
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_schm(cpu, r1, r2, inst >> 16, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(ssch)(CPUS390XState *env, uint64_t r1, uint64_t inst)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_ssch(cpu, r1, inst >> 16, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(stcrw)(CPUS390XState *env, uint64_t inst)
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_stcrw(cpu, inst >> 16, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(stsch)(CPUS390XState *env, uint64_t r1, uint64_t inst)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_stsch(cpu, r1, inst >> 16, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 uint32_t HELPER(tpi)(CPUS390XState *env, uint64_t addr)
@@ -533,10 +533,10 @@ uint32_t HELPER(tpi)(CPUS390XState *env, uint64_t addr)
         tcg_s390_program_interrupt(env, PGM_SPECIFICATION, ra);
     }
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     io = qemu_s390_flic_dequeue_io(flic, env->cregs[6]);
     if (!io) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
         return 0;
     }
 
@@ -554,7 +554,7 @@ uint32_t HELPER(tpi)(CPUS390XState *env, uint64_t addr)
         if (s390_cpu_virt_mem_write(cpu, addr, 0, &intc, sizeof(intc))) {
             /* writing failed, reinject and properly clean up */
             s390_io_interrupt(io->id, io->nr, io->parm, io->word);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             g_free(io);
             s390_cpu_virt_mem_handle_exc(cpu, ra);
             return 0;
@@ -570,24 +570,24 @@ uint32_t HELPER(tpi)(CPUS390XState *env, uint64_t addr)
     }
 
     g_free(io);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     return 1;
 }
 
 void HELPER(tsch)(CPUS390XState *env, uint64_t r1, uint64_t inst)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_tsch(cpu, r1, inst >> 16, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(chsc)(CPUS390XState *env, uint64_t inst)
 {
     S390CPU *cpu = env_archcpu(env);
-    qemu_mutex_lock_iothread();
+    bql_lock();
     ioinst_handle_chsc(cpu, inst >> 16, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 #endif
 
@@ -726,27 +726,27 @@ void HELPER(clp)(CPUS390XState *env, uint32_t r2)
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     clp_service_call(cpu, r2, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(pcilg)(CPUS390XState *env, uint32_t r1, uint32_t r2)
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     pcilg_service_call(cpu, r1, r2, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(pcistg)(CPUS390XState *env, uint32_t r1, uint32_t r2)
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     pcistg_service_call(cpu, r1, r2, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(stpcifc)(CPUS390XState *env, uint32_t r1, uint64_t fiba,
@@ -754,9 +754,9 @@ void HELPER(stpcifc)(CPUS390XState *env, uint32_t r1, uint64_t fiba,
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     stpcifc_service_call(cpu, r1, fiba, ar, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(sic)(CPUS390XState *env, uint64_t r1, uint64_t r3)
@@ -764,9 +764,9 @@ void HELPER(sic)(CPUS390XState *env, uint64_t r1, uint64_t r3)
     S390CPU *cpu = env_archcpu(env);
     int r;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     r = css_do_sic(cpu, (r3 >> 27) & 0x7, r1 & 0xffff);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     /* css_do_sic() may actually return a PGM_xxx value to inject */
     if (r) {
         tcg_s390_program_interrupt(env, -r, GETPC());
@@ -777,9 +777,9 @@ void HELPER(rpcit)(CPUS390XState *env, uint32_t r1, uint32_t r2)
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     rpcit_service_call(cpu, r1, r2, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(pcistb)(CPUS390XState *env, uint32_t r1, uint32_t r3,
@@ -787,9 +787,9 @@ void HELPER(pcistb)(CPUS390XState *env, uint32_t r1, uint32_t r3,
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     pcistb_service_call(cpu, r1, r3, gaddr, ar, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(mpcifc)(CPUS390XState *env, uint32_t r1, uint64_t fiba,
@@ -797,8 +797,8 @@ void HELPER(mpcifc)(CPUS390XState *env, uint32_t r1, uint64_t fiba,
 {
     S390CPU *cpu = env_archcpu(env);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     mpcifc_service_call(cpu, r1, fiba, ar, GETPC());
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 #endif
diff --git a/target/sparc/int32_helper.c b/target/sparc/int32_helper.c
index 8f4e08ed09..058dd712b5 100644
--- a/target/sparc/int32_helper.c
+++ b/target/sparc/int32_helper.c
@@ -70,7 +70,7 @@ void cpu_check_irqs(CPUSPARCState *env)
     CPUState *cs;
 
     /* We should be holding the BQL before we mess with IRQs */
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     if (env->pil_in && (env->interrupt_index == 0 ||
                         (env->interrupt_index & ~15) == TT_EXTINT)) {
diff --git a/target/sparc/int64_helper.c b/target/sparc/int64_helper.c
index 1b4155f5f3..27df9dba89 100644
--- a/target/sparc/int64_helper.c
+++ b/target/sparc/int64_helper.c
@@ -69,7 +69,7 @@ void cpu_check_irqs(CPUSPARCState *env)
                   (env->softint & ~(SOFTINT_TIMER | SOFTINT_STIMER));
 
     /* We should be holding the BQL before we mess with IRQs */
-    g_assert(qemu_mutex_iothread_locked());
+    g_assert(bql_locked());
 
     /* TT_IVEC has a higher priority (16) than TT_EXTINT (31..17) */
     if (env->ivec_status & 0x20) {
@@ -267,9 +267,9 @@ static bool do_modify_softint(CPUSPARCState *env, uint32_t value)
         env->softint = value;
 #if !defined(CONFIG_USER_ONLY)
         if (cpu_interrupts_enabled(env)) {
-            qemu_mutex_lock_iothread();
+            bql_lock();
             cpu_check_irqs(env);
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
         }
 #endif
         return true;
diff --git a/target/sparc/win_helper.c b/target/sparc/win_helper.c
index 16d1c70fe7..b53fc9ce94 100644
--- a/target/sparc/win_helper.c
+++ b/target/sparc/win_helper.c
@@ -179,9 +179,9 @@ void helper_wrpsr(CPUSPARCState *env, target_ulong new_psr)
         cpu_raise_exception_ra(env, TT_ILL_INSN, GETPC());
     } else {
         /* cpu_put_psr may trigger interrupts, hence BQL */
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_put_psr(env, new_psr);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 }
 
@@ -407,9 +407,9 @@ void helper_wrpstate(CPUSPARCState *env, target_ulong new_state)
 
 #if !defined(CONFIG_USER_ONLY)
     if (cpu_interrupts_enabled(env)) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_check_irqs(env);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 #endif
 }
@@ -422,9 +422,9 @@ void helper_wrpil(CPUSPARCState *env, target_ulong new_pil)
     env->psrpil = new_pil;
 
     if (cpu_interrupts_enabled(env)) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_check_irqs(env);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 #endif
 }
@@ -451,9 +451,9 @@ void helper_done(CPUSPARCState *env)
 
 #if !defined(CONFIG_USER_ONLY)
     if (cpu_interrupts_enabled(env)) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_check_irqs(env);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 #endif
 }
@@ -480,9 +480,9 @@ void helper_retry(CPUSPARCState *env)
 
 #if !defined(CONFIG_USER_ONLY)
     if (cpu_interrupts_enabled(env)) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
         cpu_check_irqs(env);
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 #endif
 }
diff --git a/target/xtensa/exc_helper.c b/target/xtensa/exc_helper.c
index 91354884f7..168419a505 100644
--- a/target/xtensa/exc_helper.c
+++ b/target/xtensa/exc_helper.c
@@ -105,9 +105,9 @@ void HELPER(waiti)(CPUXtensaState *env, uint32_t pc, uint32_t intlevel)
     env->sregs[PS] = (env->sregs[PS] & ~PS_INTLEVEL) |
         (intlevel << PS_INTLEVEL_SHIFT);
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     check_interrupts(env);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     if (env->pending_irq_level) {
         cpu_loop_exit(cpu);
@@ -120,9 +120,9 @@ void HELPER(waiti)(CPUXtensaState *env, uint32_t pc, uint32_t intlevel)
 
 void HELPER(check_interrupts)(CPUXtensaState *env)
 {
-    qemu_mutex_lock_iothread();
+    bql_lock();
     check_interrupts(env);
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 }
 
 void HELPER(intset)(CPUXtensaState *env, uint32_t v)
diff --git a/ui/spice-core.c b/ui/spice-core.c
index db21db2c94..b6ee495a8f 100644
--- a/ui/spice-core.c
+++ b/ui/spice-core.c
@@ -222,7 +222,7 @@ static void channel_event(int event, SpiceChannelEventInfo *info)
      */
     bool need_lock = !qemu_thread_is_self(&me);
     if (need_lock) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
 
     if (info->flags & SPICE_CHANNEL_EVENT_FLAG_ADDR_EXT) {
@@ -260,7 +260,7 @@ static void channel_event(int event, SpiceChannelEventInfo *info)
     }
 
     if (need_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
     qapi_free_SpiceServerInfo(server);
diff --git a/util/async.c b/util/async.c
index 460529057c..36a8e76ab0 100644
--- a/util/async.c
+++ b/util/async.c
@@ -727,7 +727,7 @@ AioContext *qemu_get_current_aio_context(void)
     if (ctx) {
         return ctx;
     }
-    if (qemu_mutex_iothread_locked()) {
+    if (bql_locked()) {
         /* Possibly in a vCPU thread.  */
         return qemu_get_aio_context();
     }
diff --git a/util/main-loop.c b/util/main-loop.c
index 63b4cda84a..a0386cfeb6 100644
--- a/util/main-loop.c
+++ b/util/main-loop.c
@@ -299,13 +299,13 @@ static int os_host_main_loop_wait(int64_t timeout)
 
     glib_pollfds_fill(&timeout);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     replay_mutex_unlock();
 
     ret = qemu_poll_ns((GPollFD *)gpollfds->data, gpollfds->len, timeout);
 
     replay_mutex_lock();
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     glib_pollfds_poll();
 
@@ -514,7 +514,7 @@ static int os_host_main_loop_wait(int64_t timeout)
 
     poll_timeout_ns = qemu_soonest_timeout(poll_timeout_ns, timeout);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
 
     replay_mutex_unlock();
 
@@ -522,7 +522,7 @@ static int os_host_main_loop_wait(int64_t timeout)
 
     replay_mutex_lock();
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
     if (g_poll_ret > 0) {
         for (i = 0; i < w->num; i++) {
             w->revents[i] = poll_fds[n_poll_fds + i].revents;
diff --git a/util/qsp.c b/util/qsp.c
index 2fe3764906..6b783e2e7f 100644
--- a/util/qsp.c
+++ b/util/qsp.c
@@ -124,7 +124,7 @@ static const char * const qsp_typenames[] = {
     [QSP_CONDVAR]   = "condvar",
 };
 
-QemuMutexLockFunc qemu_bql_mutex_lock_func = qemu_mutex_lock_impl;
+QemuMutexLockFunc bql_mutex_lock_func = qemu_mutex_lock_impl;
 QemuMutexLockFunc qemu_mutex_lock_func = qemu_mutex_lock_impl;
 QemuMutexTrylockFunc qemu_mutex_trylock_func = qemu_mutex_trylock_impl;
 QemuRecMutexLockFunc qemu_rec_mutex_lock_func = qemu_rec_mutex_lock_impl;
@@ -439,7 +439,7 @@ void qsp_enable(void)
 {
     qatomic_set(&qemu_mutex_lock_func, qsp_mutex_lock);
     qatomic_set(&qemu_mutex_trylock_func, qsp_mutex_trylock);
-    qatomic_set(&qemu_bql_mutex_lock_func, qsp_bql_mutex_lock);
+    qatomic_set(&bql_mutex_lock_func, qsp_bql_mutex_lock);
     qatomic_set(&qemu_rec_mutex_lock_func, qsp_rec_mutex_lock);
     qatomic_set(&qemu_rec_mutex_trylock_func, qsp_rec_mutex_trylock);
     qatomic_set(&qemu_cond_wait_func, qsp_cond_wait);
@@ -450,7 +450,7 @@ void qsp_disable(void)
 {
     qatomic_set(&qemu_mutex_lock_func, qemu_mutex_lock_impl);
     qatomic_set(&qemu_mutex_trylock_func, qemu_mutex_trylock_impl);
-    qatomic_set(&qemu_bql_mutex_lock_func, qemu_mutex_lock_impl);
+    qatomic_set(&bql_mutex_lock_func, qemu_mutex_lock_impl);
     qatomic_set(&qemu_rec_mutex_lock_func, qemu_rec_mutex_lock_impl);
     qatomic_set(&qemu_rec_mutex_trylock_func, qemu_rec_mutex_trylock_impl);
     qatomic_set(&qemu_cond_wait_func, qemu_cond_wait_impl);
diff --git a/util/rcu.c b/util/rcu.c
index e587bcc483..bb7f633b5c 100644
--- a/util/rcu.c
+++ b/util/rcu.c
@@ -283,24 +283,24 @@ static void *call_rcu_thread(void *opaque)
 
         qatomic_sub(&rcu_call_count, n);
         synchronize_rcu();
-        qemu_mutex_lock_iothread();
+        bql_lock();
         while (n > 0) {
             node = try_dequeue();
             while (!node) {
-                qemu_mutex_unlock_iothread();
+                bql_unlock();
                 qemu_event_reset(&rcu_call_ready_event);
                 node = try_dequeue();
                 if (!node) {
                     qemu_event_wait(&rcu_call_ready_event);
                     node = try_dequeue();
                 }
-                qemu_mutex_lock_iothread();
+                bql_lock();
             }
 
             n--;
             node->func(node);
         }
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     abort();
 }
@@ -337,13 +337,13 @@ static void drain_rcu_callback(struct rcu_head *node)
 void drain_call_rcu(void)
 {
     struct rcu_drain rcu_drain;
-    bool locked = qemu_mutex_iothread_locked();
+    bool locked = bql_locked();
 
     memset(&rcu_drain, 0, sizeof(struct rcu_drain));
     qemu_event_init(&rcu_drain.drain_complete_event, false);
 
     if (locked) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 
 
@@ -365,7 +365,7 @@ void drain_call_rcu(void)
     qatomic_dec(&in_drain_call_rcu);
 
     if (locked) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
 
 }
diff --git a/audio/coreaudio.m b/audio/coreaudio.m
index 8cd129a27d..9d2db9883c 100644
--- a/audio/coreaudio.m
+++ b/audio/coreaudio.m
@@ -547,7 +547,7 @@ static OSStatus handle_voice_change(
 {
     coreaudioVoiceOut *core = in_client_data;
 
-    qemu_mutex_lock_iothread();
+    bql_lock();
 
     if (core->outputDeviceID) {
         fini_out_device(core);
@@ -557,7 +557,7 @@ static OSStatus handle_voice_change(
         update_device_playback_state(core);
     }
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     return 0;
 }
 
diff --git a/memory_ldst.c.inc b/memory_ldst.c.inc
index 84b868f294..0e6f3940a9 100644
--- a/memory_ldst.c.inc
+++ b/memory_ldst.c.inc
@@ -61,7 +61,7 @@ static inline uint32_t glue(address_space_ldl_internal, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
     return val;
@@ -130,7 +130,7 @@ static inline uint64_t glue(address_space_ldq_internal, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
     return val;
@@ -186,7 +186,7 @@ uint8_t glue(address_space_ldub, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
     return val;
@@ -234,7 +234,7 @@ static inline uint16_t glue(address_space_lduw_internal, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
     return val;
@@ -295,7 +295,7 @@ void glue(address_space_stl_notdirty, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
 }
@@ -339,7 +339,7 @@ static inline void glue(address_space_stl_internal, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
 }
@@ -391,7 +391,7 @@ void glue(address_space_stb, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
 }
@@ -435,7 +435,7 @@ static inline void glue(address_space_stw_internal, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
 }
@@ -499,7 +499,7 @@ static void glue(address_space_stq_internal, SUFFIX)(ARG1_DECL,
         *result = r;
     }
     if (release_lock) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     RCU_READ_UNLOCK();
 }
diff --git a/target/i386/hvf/README.md b/target/i386/hvf/README.md
index 2d33477aca..64a8935237 100644
--- a/target/i386/hvf/README.md
+++ b/target/i386/hvf/README.md
@@ -4,4 +4,4 @@ These sources (and ../hvf-all.c) are adapted from Veertu Inc's vdhh (Veertu Desk
 
 1. Adapt to our current QEMU's `CPUState` structure and `address_space_rw` API; many struct members have been moved around (emulated x86 state, xsave_buf) due to historical differences + QEMU needing to handle more emulation targets.
 2. Removal of `apic_page` and hyperv-related functionality.
-3. More relaxed use of `qemu_mutex_lock_iothread`.
+3. More relaxed use of `bql_lock`.
diff --git a/ui/cocoa.m b/ui/cocoa.m
index cd069da696..5ebb535070 100644
--- a/ui/cocoa.m
+++ b/ui/cocoa.m
@@ -117,29 +117,29 @@ static void cocoa_switch(DisplayChangeListener *dcl,
 typedef void (^CodeBlock)(void);
 typedef bool (^BoolCodeBlock)(void);
 
-static void with_iothread_lock(CodeBlock block)
+static void with_bql(CodeBlock block)
 {
-    bool locked = qemu_mutex_iothread_locked();
+    bool locked = bql_locked();
     if (!locked) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
     block();
     if (!locked) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
 }
 
-static bool bool_with_iothread_lock(BoolCodeBlock block)
+static bool bool_with_bql(BoolCodeBlock block)
 {
-    bool locked = qemu_mutex_iothread_locked();
+    bool locked = bql_locked();
     bool val;
 
     if (!locked) {
-        qemu_mutex_lock_iothread();
+        bql_lock();
     }
     val = block();
     if (!locked) {
-        qemu_mutex_unlock_iothread();
+        bql_unlock();
     }
     return val;
 }
@@ -605,7 +605,7 @@ - (void) updateUIInfo
         return;
     }
 
-    with_iothread_lock(^{
+    with_bql(^{
         [self updateUIInfoLocked];
     });
 }
@@ -790,7 +790,7 @@ - (void) handleMonitorInput:(NSEvent *)event
 
 - (bool) handleEvent:(NSEvent *)event
 {
-    return bool_with_iothread_lock(^{
+    return bool_with_bql(^{
         return [self handleEventLocked:event];
     });
 }
@@ -1182,7 +1182,7 @@ - (QEMUScreen) gscreen {return screen;}
  */
 - (void) raiseAllKeys
 {
-    with_iothread_lock(^{
+    with_bql(^{
         qkbd_state_lift_all_keys(kbd);
     });
 }
@@ -1282,7 +1282,7 @@ - (void)applicationWillTerminate:(NSNotification *)aNotification
 {
     COCOA_DEBUG("QemuCocoaAppController: applicationWillTerminate\n");
 
-    with_iothread_lock(^{
+    with_bql(^{
         shutdown_action = SHUTDOWN_ACTION_POWEROFF;
         qemu_system_shutdown_request(SHUTDOWN_CAUSE_HOST_UI);
     });
@@ -1420,7 +1420,7 @@ - (void)displayConsole:(id)sender
 /* Pause the guest */
 - (void)pauseQEMU:(id)sender
 {
-    with_iothread_lock(^{
+    with_bql(^{
         qmp_stop(NULL);
     });
     [sender setEnabled: NO];
@@ -1431,7 +1431,7 @@ - (void)pauseQEMU:(id)sender
 /* Resume running the guest operating system */
 - (void)resumeQEMU:(id) sender
 {
-    with_iothread_lock(^{
+    with_bql(^{
         qmp_cont(NULL);
     });
     [sender setEnabled: NO];
@@ -1461,7 +1461,7 @@ - (void)removePause
 /* Restarts QEMU */
 - (void)restartQEMU:(id)sender
 {
-    with_iothread_lock(^{
+    with_bql(^{
         qmp_system_reset(NULL);
     });
 }
@@ -1469,7 +1469,7 @@ - (void)restartQEMU:(id)sender
 /* Powers down QEMU */
 - (void)powerDownQEMU:(id)sender
 {
-    with_iothread_lock(^{
+    with_bql(^{
         qmp_system_powerdown(NULL);
     });
 }
@@ -1488,7 +1488,7 @@ - (void)ejectDeviceMedia:(id)sender
     }
 
     __block Error *err = NULL;
-    with_iothread_lock(^{
+    with_bql(^{
         qmp_eject([drive cStringUsingEncoding: NSASCIIStringEncoding],
                   NULL, false, false, &err);
     });
@@ -1523,7 +1523,7 @@ - (void)changeDeviceMedia:(id)sender
         }
 
         __block Error *err = NULL;
-        with_iothread_lock(^{
+        with_bql(^{
             qmp_blockdev_change_medium([drive cStringUsingEncoding:
                                                   NSASCIIStringEncoding],
                                        NULL,
@@ -1605,7 +1605,7 @@ - (void)adjustSpeed:(id)sender
     // get the throttle percentage
     throttle_pct = [sender tag];
 
-    with_iothread_lock(^{
+    with_bql(^{
         cpu_throttle_set(throttle_pct);
     });
     COCOA_DEBUG("cpu throttling at %d%c\n", cpu_throttle_get_percentage(), '%');
@@ -1819,7 +1819,7 @@ - (void)pasteboard:(NSPasteboard *)sender provideDataForType:(NSPasteboardType)t
         return;
     }
 
-    with_iothread_lock(^{
+    with_bql(^{
         QemuClipboardInfo *info = qemu_clipboard_info_ref(cbinfo);
         qemu_event_reset(&cbevent);
         qemu_clipboard_request(info, QEMU_CLIPBOARD_TYPE_TEXT);
@@ -1827,9 +1827,9 @@ - (void)pasteboard:(NSPasteboard *)sender provideDataForType:(NSPasteboardType)t
         while (info == cbinfo &&
                info->types[QEMU_CLIPBOARD_TYPE_TEXT].available &&
                info->types[QEMU_CLIPBOARD_TYPE_TEXT].data == NULL) {
-            qemu_mutex_unlock_iothread();
+            bql_unlock();
             qemu_event_wait(&cbevent);
-            qemu_mutex_lock_iothread();
+            bql_lock();
         }
 
         if (info == cbinfo) {
@@ -1927,9 +1927,9 @@ static void cocoa_clipboard_request(QemuClipboardInfo *info,
     int status;
 
     COCOA_DEBUG("Second thread: calling qemu_default_main()\n");
-    qemu_mutex_lock_iothread();
+    bql_lock();
     status = qemu_default_main();
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     COCOA_DEBUG("Second thread: qemu_default_main() returned, exiting\n");
     [cbowner release];
     exit(status);
@@ -1941,7 +1941,7 @@ static int cocoa_main(void)
 
     COCOA_DEBUG("Entered %s()\n", __func__);
 
-    qemu_mutex_unlock_iothread();
+    bql_unlock();
     qemu_thread_create(&thread, "qemu_main", call_qemu_main,
                        NULL, QEMU_THREAD_DETACHED);
 
-- 
2.43.0


