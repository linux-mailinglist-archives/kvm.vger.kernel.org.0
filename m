Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB531835E9
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 17:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbgCLQOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 12:14:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37847 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726385AbgCLQOE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 12:14:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584029642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aUmlo8MrH4gk71Z4QNFrQL6GEhldMh1YHNoBnWn6ApQ=;
        b=LIPsZ84jMGJXs8m5JNvnN8x056rUiTf4pymEBnN5CvQq0A6c4Zem58Avli8P3TI29S8lCi
        rruqMH6vsOrgsr0Apk7aq9IJ3ulTuUP8Dg8kwy2S5Oq7koYuN4+ViSahY4BOL17P0Mcv2C
        rNoY3tt+xNzeYOK5Ye5K3iPwgCEncUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-dmC-x3q7M-Wm-r0xaaxhTA-1; Thu, 12 Mar 2020 12:14:00 -0400
X-MC-Unique: dmC-x3q7M-Wm-r0xaaxhTA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 322E68017CC;
        Thu, 12 Mar 2020 16:13:59 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-131.ams2.redhat.com [10.36.117.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B507A5C1B5;
        Thu, 12 Mar 2020 16:13:54 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org
Subject: [PATCH RFCv2 4/4] kvm: Implement atomic memory region resizes via region_resize()
Date:   Thu, 12 Mar 2020 17:12:17 +0100
Message-Id: <20200312161217.3590-5-david@redhat.com>
In-Reply-To: <20200312161217.3590-1-david@redhat.com>
References: <20200312161217.3590-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virtio-mem wants to resize (esp. grow) ram memory regions while the guest
is already aware of them and makes use of them. Resizing a KVM slot can
only currently be done by removing it and re-adding it. While the kvm slo=
t
is temporarily removed, VCPUs that try to access memory on these slots (v=
ia
KVM_RUN) will fault. But also, other ioctls might depend on all slots bei=
ng
in place.

Let's inhibit most KVM ioctls while performing the resize. Once we have a=
n
ioctl that can perform atomic resizes (e.g., KVM_SET_USER_MEMORY_REGION
extensions), we can make inhibiting optional at runtime.

To minimize cache-line bouncing, use separate indicators (in_ioctl) and
locks (ioctl_mutex) per CPU.  Also, make sure to hold the kvm_slots_lock
while performing both actions (removing+re-adding).

We have to wait until all IOCTLs were exited and block new ones from
getting executed. Kick all CPUs, so they will exit the KVM_RUN ioctl.

This approach cannot result in a deadlock as long as the inhibitor does
not hold any locks that might hinder an IOCTL from getting finished and
exited - something fairly unusual. The inhibitor will always hold the BQL=
.

AFAIKs, one possible candidate would be userfaultfd. If a page cannot be
placed (e.g., during postcopy), because we're waiting for a lock, or if t=
he
userfaultfd thread cannot process a fault, because it is waiting for a
lock, there could be a deadlock. However, the BQL is not applicable here,
because any other guest memory access while holding the BQL would already
result in a deadlock.

Nothing else in the kernel should block forever and wait for userspace
intervention.

Note1: Resizes of memory regions currently seems to happen during bootup
only, so I don't think any existing RT users should be affected.

Note2: pause_all_vcpus()/resume_all_vcpus() or
start_exclusive()/end_exclusive() cannot be used, as they either drop
the BQL or require to be called without the BQL - something inhibitors
cannot handle. We need a low-level locking mechanism that is
deadlock-free even when not releasing the BQL.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c   | 129 +++++++++++++++++++++++++++++++++++++++---
 hw/core/cpu.c         |   2 +
 include/hw/core/cpu.h |   4 ++
 3 files changed, 128 insertions(+), 7 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 439a4efe52..be159a2f78 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -149,6 +149,21 @@ bool kvm_msi_use_devid;
 static bool kvm_immediate_exit;
 static hwaddr kvm_max_slot_size =3D ~0;
=20
+/*
+ * While holding kvm_ioctl_mutex and all cpu->ioctl_mutex, no new KVM io=
ctls
+ * can be started, but kvm ioctl inhibitors will have to wait for existi=
ng ones
+ * to finish (indicated by cpu->in_ioctl and kvm_in_ioctl, both updated =
with
+ * kvm_ioctl_mutex or under the cpu->ioctl_mutex when entering the ioctl=
).
+ */
+QemuMutex kvm_ioctl_mutex;
+/*
+ * Atomic counter of active KVM ioctls except
+ * - The KVM ioctl inhibitor is doing an ioctl
+ * - kvm_ioctl(): Harmless and not interesting for inhibitors.
+ * - kvm_vcpu_ioctl(): Tracked via cpu->in_ioctl.
+ */
+static int kvm_in_ioctl;
+
 static const KVMCapabilityInfo kvm_required_capabilites[] =3D {
     KVM_CAP_INFO(USER_MEMORY),
     KVM_CAP_INFO(DESTROY_MEMORY_REGION_WORKS),
@@ -1023,6 +1038,7 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
     kvm_max_slot_size =3D max_slot_size;
 }
=20
+/* Called with KVMMemoryListener.slots_lock held */
 static void kvm_set_phys_mem(KVMMemoryListener *kml,
                              MemoryRegionSection *section, bool add)
 {
@@ -1052,14 +1068,12 @@ static void kvm_set_phys_mem(KVMMemoryListener *k=
ml,
     ram =3D memory_region_get_ram_ptr(mr) + section->offset_within_regio=
n +
           (start_addr - section->offset_within_address_space);
=20
-    kvm_slots_lock(kml);
-
     if (!add) {
         do {
             slot_size =3D MIN(kvm_max_slot_size, size);
             mem =3D kvm_lookup_matching_slot(kml, start_addr, slot_size)=
;
             if (!mem) {
-                goto out;
+                return;
             }
             if (mem->flags & KVM_MEM_LOG_DIRTY_PAGES) {
                 kvm_physical_sync_dirty_bitmap(kml, section);
@@ -1079,7 +1093,7 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml=
,
             start_addr +=3D slot_size;
             size -=3D slot_size;
         } while (size);
-        goto out;
+        return;
     }
=20
     /* register the new slot */
@@ -1108,9 +1122,6 @@ static void kvm_set_phys_mem(KVMMemoryListener *kml=
,
         ram +=3D slot_size;
         size -=3D slot_size;
     } while (size);
-
-out:
-    kvm_slots_unlock(kml);
 }
=20
 static void kvm_region_add(MemoryListener *listener,
@@ -1119,7 +1130,9 @@ static void kvm_region_add(MemoryListener *listener=
,
     KVMMemoryListener *kml =3D container_of(listener, KVMMemoryListener,=
 listener);
=20
     memory_region_ref(section->mr);
+    kvm_slots_lock(kml);
     kvm_set_phys_mem(kml, section, true);
+    kvm_slots_unlock(kml);
 }
=20
 static void kvm_region_del(MemoryListener *listener,
@@ -1127,10 +1140,76 @@ static void kvm_region_del(MemoryListener *listen=
er,
 {
     KVMMemoryListener *kml =3D container_of(listener, KVMMemoryListener,=
 listener);
=20
+    kvm_slots_lock(kml);
     kvm_set_phys_mem(kml, section, false);
+    kvm_slots_unlock(kml);
     memory_region_unref(section->mr);
 }
=20
+/*
+ * Certain updates (e.g., resizing memory regions) require temporarily r=
emoving
+ * kvm memory slots. Make sure any ioctl sees a consistent memory slot s=
tate.
+ */
+static void kvm_ioctl_inhibit_begin(void)
+{
+    CPUState *cpu;
+
+    /*
+     * We allow to inhibit only when holding the BQL, so we can identify
+     * when an inhibitor wants to issue an ioctl easily.
+     */
+    g_assert(qemu_mutex_iothread_locked());
+
+    CPU_FOREACH(cpu) {
+        qemu_mutex_lock(&cpu->ioctl_mutex);
+    }
+    qemu_mutex_lock(&kvm_ioctl_mutex);
+
+    /* Inhibiting happens rarely, we can keep things simple and spin her=
e. */
+    while (true) {
+        bool any_cpu_in_ioctl =3D false;
+
+        CPU_FOREACH(cpu) {
+            if (atomic_read(&cpu->in_ioctl)) {
+                any_cpu_in_ioctl =3D true;
+                qemu_cpu_kick(cpu);
+            }
+        }
+        if (!any_cpu_in_ioctl && !atomic_read(&kvm_in_ioctl)) {
+            break;
+        }
+        g_usleep(100);
+    }
+}
+
+static void kvm_ioctl_inhibit_end(void)
+{
+    CPUState *cpu;
+
+    qemu_mutex_unlock(&kvm_ioctl_mutex);
+    CPU_FOREACH(cpu) {
+        qemu_mutex_unlock(&cpu->ioctl_mutex);
+    }
+}
+
+static void kvm_region_resize(MemoryListener *listener,
+                              MemoryRegionSection *section, Int128 new)
+{
+    KVMMemoryListener *kml =3D container_of(listener, KVMMemoryListener,
+                                          listener);
+    MemoryRegionSection new_section =3D *section;
+
+    new_section.size =3D new;
+
+    kvm_slots_lock(kml);
+    /* Inhibit KVM ioctls while temporarily removing slots. */
+    kvm_ioctl_inhibit_begin();
+    kvm_set_phys_mem(kml, section, false);
+    kvm_set_phys_mem(kml, &new_section, true);
+    kvm_ioctl_inhibit_end();
+    kvm_slots_unlock(kml);
+}
+
 static void kvm_log_sync(MemoryListener *listener,
                          MemoryRegionSection *section)
 {
@@ -1249,6 +1328,7 @@ void kvm_memory_listener_register(KVMState *s, KVMM=
emoryListener *kml,
=20
     kml->listener.region_add =3D kvm_region_add;
     kml->listener.region_del =3D kvm_region_del;
+    kml->listener.region_resize =3D kvm_region_resize;
     kml->listener.log_start =3D kvm_log_start;
     kml->listener.log_stop =3D kvm_log_stop;
     kml->listener.log_sync =3D kvm_log_sync;
@@ -1894,6 +1974,7 @@ static int kvm_init(MachineState *ms)
     assert(TARGET_PAGE_SIZE <=3D qemu_real_host_page_size);
=20
     s->sigmask_len =3D 8;
+    qemu_mutex_init(&kvm_ioctl_mutex);
=20
 #ifdef KVM_CAP_SET_GUEST_DEBUG
     QTAILQ_INIT(&s->kvm_sw_breakpoints);
@@ -2304,6 +2385,34 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
=20
+static void kvm_cpu_set_in_ioctl(CPUState *cpu, bool in_ioctl)
+{
+    if (unlikely(qemu_mutex_iothread_locked())) {
+        return;
+    }
+    if (in_ioctl) {
+        qemu_mutex_lock(&cpu->ioctl_mutex);
+        cpu->in_ioctl =3D true;
+        qemu_mutex_unlock(&cpu->ioctl_mutex);
+    } else {
+        atomic_set(&cpu->in_ioctl, false);
+    }
+}
+
+static void kvm_set_in_ioctl(bool in_ioctl)
+{
+    if (likely(qemu_mutex_iothread_locked())) {
+        return;
+    }
+    if (in_ioctl) {
+        qemu_mutex_lock(&kvm_ioctl_mutex);
+        kvm_in_ioctl++;
+        qemu_mutex_unlock(&kvm_ioctl_mutex);
+    } else {
+        atomic_dec(&kvm_in_ioctl);
+    }
+}
+
 int kvm_cpu_exec(CPUState *cpu)
 {
     struct kvm_run *run =3D cpu->kvm_run;
@@ -2488,7 +2597,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
     va_end(ap);
=20
     trace_kvm_vm_ioctl(type, arg);
+    kvm_set_in_ioctl(true);
     ret =3D ioctl(s->vmfd, type, arg);
+    kvm_set_in_ioctl(false);
     if (ret =3D=3D -1) {
         ret =3D -errno;
     }
@@ -2506,7 +2617,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
     va_end(ap);
=20
     trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
+    kvm_cpu_set_in_ioctl(cpu, true);
     ret =3D ioctl(cpu->kvm_fd, type, arg);
+    kvm_cpu_set_in_ioctl(cpu, false);
     if (ret =3D=3D -1) {
         ret =3D -errno;
     }
@@ -2524,7 +2637,9 @@ int kvm_device_ioctl(int fd, int type, ...)
     va_end(ap);
=20
     trace_kvm_device_ioctl(fd, type, arg);
+    kvm_set_in_ioctl(true);
     ret =3D ioctl(fd, type, arg);
+    kvm_set_in_ioctl(false);
     if (ret =3D=3D -1) {
         ret =3D -errno;
     }
diff --git a/hw/core/cpu.c b/hw/core/cpu.c
index fe65ca62ac..3591dc3874 100644
--- a/hw/core/cpu.c
+++ b/hw/core/cpu.c
@@ -379,6 +379,7 @@ static void cpu_common_initfn(Object *obj)
     cpu->nr_threads =3D 1;
=20
     qemu_mutex_init(&cpu->work_mutex);
+    qemu_mutex_init(&cpu->ioctl_mutex);
     QTAILQ_INIT(&cpu->breakpoints);
     QTAILQ_INIT(&cpu->watchpoints);
=20
@@ -389,6 +390,7 @@ static void cpu_common_finalize(Object *obj)
 {
     CPUState *cpu =3D CPU(obj);
=20
+    qemu_mutex_destroy(&cpu->ioctl_mutex);
     qemu_mutex_destroy(&cpu->work_mutex);
 }
=20
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 73e9a869a4..3abf251037 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -431,6 +431,10 @@ struct CPUState {
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
=20
+    /* kvm only for now: CPU is in kvm_vcpu_ioctl() (esp. KVM_RUN) */
+    bool in_ioctl;
+    QemuMutex ioctl_mutex;
+
     /* Used to keep track of an outstanding cpu throttle thread for migr=
ation
      * autoconverge
      */
--=20
2.24.1

