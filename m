Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A41BA1778A7
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 15:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgCCOUd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 09:20:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26031 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727311AbgCCOUd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 09:20:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583245231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fO4uZMYE82gtwCvsu4xnQfm16x7G0X5NKbdPHitYWJ0=;
        b=LOscpQYigMR776H24Ub6ZxTaIiaOep6L/5ISgJRtvOru10QszwpNMF+C5xlLSxwGPNkonI
        Ac86+y6xlAwqqIW/xgzfMWJrf+b6wOgsw7E553996c4dM5y9xxBSXYMvW5u561zBG+ujK4
        7LZPQT1VLUehtD5Ohol68aUAmRqwIB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-VNP-6lTlN_axUtd7OtkI2Q-1; Tue, 03 Mar 2020 09:20:29 -0500
X-MC-Unique: VNP-6lTlN_axUtd7OtkI2Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8DC60107ACCA;
        Tue,  3 Mar 2020 14:20:28 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-117-113.ams2.redhat.com [10.36.117.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8279C60BE1;
        Tue,  3 Mar 2020 14:20:26 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org
Subject: [PATCH RFC 4/4] kvm: Implement atomic memory region resizes via region_resize()
Date:   Tue,  3 Mar 2020 15:19:39 +0100
Message-Id: <20200303141939.352319-5-david@redhat.com>
In-Reply-To: <20200303141939.352319-1-david@redhat.com>
References: <20200303141939.352319-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virtio-mem wants to resize (esp. grow) ram memory regions while the guest
is already aware of them and makes use of them. Resizing a KVM slot can
only currently be done by removing it and re-adding it. While the kvm slo=
t
is temporarily removed, VCPUs that try to read from these slots will faul=
t.
But also, other ioctls might depend on all slots being in place.

Let's inhibit most KVM ioctls while performing the resize. Once we have a=
n
ioctl that can perform atomic resizes (e.g., KVM_SET_USER_MEMORY_REGION
extensions), we can make inhibiting optional at runtime.

Also, make sure to hold the kvm_slots_lock while performing both
actions (removing+re-adding).

Note: Resizes of memory regions currently seems to happen during bootup
only, so I don't think any existing RT users should be affected.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Cc: Igor Mammedov <imammedo@redhat.com>
Cc: kvm@vger.kernel.org
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c   | 121 +++++++++++++++++++++++++++++++++++++++---
 include/hw/core/cpu.h |   3 ++
 2 files changed, 117 insertions(+), 7 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 439a4efe52..bba58db098 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -149,6 +149,21 @@ bool kvm_msi_use_devid;
 static bool kvm_immediate_exit;
 static hwaddr kvm_max_slot_size =3D ~0;
=20
+/*
+ * While holding this lock in write, no new KVM ioctls can be started, b=
ut
+ * kvm ioctl inhibitors will have to wait for existing ones to finish
+ * (indicated by cpu->in_ioctl and kvm_in_ioctl, both updated with this =
lock
+ * held in read when entering the ioctl).
+ */
+pthread_rwlock_t kvm_ioctl_lock;
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
@@ -1127,10 +1140,68 @@ static void kvm_region_del(MemoryListener *listen=
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
+    pthread_rwlock_wrlock(&kvm_ioctl_lock);
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
+    pthread_rwlock_unlock(&kvm_ioctl_lock);
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
@@ -1249,6 +1320,7 @@ void kvm_memory_listener_register(KVMState *s, KVMM=
emoryListener *kml,
=20
     kml->listener.region_add =3D kvm_region_add;
     kml->listener.region_del =3D kvm_region_del;
+    kml->listener.region_resize =3D kvm_region_resize;
     kml->listener.log_start =3D kvm_log_start;
     kml->listener.log_stop =3D kvm_log_stop;
     kml->listener.log_sync =3D kvm_log_sync;
@@ -1894,6 +1966,7 @@ static int kvm_init(MachineState *ms)
     assert(TARGET_PAGE_SIZE <=3D qemu_real_host_page_size);
=20
     s->sigmask_len =3D 8;
+    pthread_rwlock_init(&kvm_ioctl_lock, NULL);
=20
 #ifdef KVM_CAP_SET_GUEST_DEBUG
     QTAILQ_INIT(&s->kvm_sw_breakpoints);
@@ -2304,6 +2377,34 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
=20
+static void kvm_cpu_set_in_ioctl(CPUState *cpu, bool in_ioctl)
+{
+    if (unlikely(qemu_mutex_iothread_locked())) {
+        return;
+    }
+    if (in_ioctl) {
+        pthread_rwlock_rdlock(&kvm_ioctl_lock);
+        atomic_set(&cpu->in_ioctl, true);
+        pthread_rwlock_unlock(&kvm_ioctl_lock);
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
+        pthread_rwlock_rdlock(&kvm_ioctl_lock);
+        atomic_inc(&kvm_in_ioctl);
+        pthread_rwlock_unlock(&kvm_ioctl_lock);
+    } else {
+        atomic_dec(&kvm_in_ioctl);
+    }
+}
+
 int kvm_cpu_exec(CPUState *cpu)
 {
     struct kvm_run *run =3D cpu->kvm_run;
@@ -2488,7 +2589,9 @@ int kvm_vm_ioctl(KVMState *s, int type, ...)
     va_end(ap);
=20
     trace_kvm_vm_ioctl(type, arg);
+    kvm_set_in_ioctl(true);
     ret =3D ioctl(s->vmfd, type, arg);
+    kvm_set_in_ioctl(false);
     if (ret =3D=3D -1) {
         ret =3D -errno;
     }
@@ -2506,7 +2609,9 @@ int kvm_vcpu_ioctl(CPUState *cpu, int type, ...)
     va_end(ap);
=20
     trace_kvm_vcpu_ioctl(cpu->cpu_index, type, arg);
+    kvm_cpu_set_in_ioctl(cpu, true);
     ret =3D ioctl(cpu->kvm_fd, type, arg);
+    kvm_cpu_set_in_ioctl(cpu, false);
     if (ret =3D=3D -1) {
         ret =3D -errno;
     }
@@ -2524,7 +2629,9 @@ int kvm_device_ioctl(int fd, int type, ...)
     va_end(ap);
=20
     trace_kvm_device_ioctl(fd, type, arg);
+    kvm_set_in_ioctl(true);
     ret =3D ioctl(fd, type, arg);
+    kvm_set_in_ioctl(false);
     if (ret =3D=3D -1) {
         ret =3D -errno;
     }
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index 73e9a869a4..4fbff6f3d7 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -431,6 +431,9 @@ struct CPUState {
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
=20
+    /* kvm only for now: CPU is in kvm_vcpu_ioctl() (esp. KVM_RUN) */
+    bool in_ioctl;
+
     /* Used to keep track of an outstanding cpu throttle thread for migr=
ation
      * autoconverge
      */
--=20
2.24.1

