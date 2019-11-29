Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C04BB10DB0D
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387433AbfK2Vfd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:35:33 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57161 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387424AbfK2Vfc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:35:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uyOesPhoNbZ1gr0Wg6vykFa3j3pfatuG9nppSZClqgg=;
        b=Jz3H4UhrIiQlAs3dWmby2pxdCJExkp6gDe5pcmMcXlwigHAMIbpodlIfIaxMUBvSizk3TL
        00gfGjLLwMB0l7Pn0J1eNzZeNjTLj4hxw8XbGx0XuaJmKLzPbtHJlaHKlUjBGAONdBwcDo
        LIXufltDOTGIN/QcvneqMdzNt30mOAs=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-rFCEtGLgNmCy1BsyBprlWA-1; Fri, 29 Nov 2019 16:35:30 -0500
Received: by mail-qv1-f72.google.com with SMTP id bt18so2773236qvb.19
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0UF9lp1lBL4kSan9fGihxlve/ru+UF638aRJRIgajpw=;
        b=UvATH73T0QRTyHpiJ3NOPrzSIkmtApoVcyAZl6h4hTppYJh5kJrcFIxbyS+OMtS811
         yxnbEUuBb11v6pg3d2FXayUDdTBK2Juc+QxZ+OKoAe7AvCubxLOEvYGD4TUM+/tcXsbq
         NPVxL6RzQH4iqia2FbBT+rgAoSVogmJ3Hvm/7/1nWypb36nxlcNuVSaOBlbtyTxoWIEE
         ssZ6e+n6R7bszvhmYZlY7fWbjU0y8g2/tkIRsDrc5q04PYdnBR5kXTngqt5CwQPHdXWt
         kVHzWaQYJKPkzXPPge6a+WGnXiczCCzjT0dG8lve8k9N2b8O6wJRAL/ycXo7PlqyrlgM
         SlLQ==
X-Gm-Message-State: APjAAAUMCP79G9yok4I4Zp3Ap9oiovh4m+CKrj6zie9RQLB4qnMOJqnL
        vrUm0KoOSRNanVtDoEk6c8nEwngFNgvApJL3evvITkIuF0b0kBulXCARQy3djieKkrcjM1CdHwa
        sGEkmjVh8A0yF
X-Received: by 2002:ac8:425a:: with SMTP id r26mr1876841qtm.138.1575063329885;
        Fri, 29 Nov 2019 13:35:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqzi5Wvkam1/QRsqbEEqLm30CtDE/1BNPpW0WM979SEKE3y801pwHLFnw/vKPwaJPPOjVnyACg==
X-Received: by 2002:ac8:425a:: with SMTP id r26mr1876817qtm.138.1575063329571;
        Fri, 29 Nov 2019 13:35:29 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:28 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 13/15] KVM: selftests: Let dirty_log_test async for dirty ring test
Date:   Fri, 29 Nov 2019 16:35:03 -0500
Message-Id: <20191129213505.18472-14-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: rFCEtGLgNmCy1BsyBprlWA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously the dirty ring test was working in synchronous way, because
only with a vmexit (with that it was the ring full event) we'll know
the hardware dirty bits will be flushed to the dirty ring.

With this patch we first introduced the vcpu kick mechanism by using
SIGUSR1, meanwhile we can have a guarantee of vmexit and also the
flushing of hardware dirty bits.  With all these, we can keep the vcpu
dirty work asynchronous of the whole collection procedure now.

Further increase the dirty ring size to current maximum to make sure
we torture more on the no-ring-full case, which should be the major
scenario when the hypervisors like QEMU would like to use this feature.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 74 ++++++++++++-------
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  8 ++
 3 files changed, 57 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/s=
elftests/kvm/dirty_log_test.c
index 968e35c5d380..4799db91e919 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -13,6 +13,9 @@
 #include <time.h>
 #include <pthread.h>
 #include <semaphore.h>
+#include <sys/types.h>
+#include <signal.h>
+#include <errno.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <asm/barrier.h>
@@ -59,7 +62,9 @@
 # define test_and_clear_bit_le=09test_and_clear_bit
 #endif
=20
-#define TEST_DIRTY_RING_COUNT=09=091024
+#define TEST_DIRTY_RING_COUNT=09=0965536
+
+#define SIG_IPI SIGUSR1
=20
 /*
  * Guest/Host shared variables. Ensure addr_gva2hva() and/or
@@ -151,6 +156,20 @@ enum log_mode_t {
=20
 /* Mode of logging.  Default is LOG_MODE_DIRTY_LOG */
 static enum log_mode_t host_log_mode;
+pthread_t vcpu_thread;
+
+/* Only way to pass this to the signal handler */
+struct kvm_vm *current_vm;
+
+static void vcpu_sig_handler(int sig)
+{
+=09TEST_ASSERT(sig =3D=3D SIG_IPI, "unknown signal: %d", sig);
+}
+
+static void vcpu_kick(void)
+{
+=09pthread_kill(vcpu_thread, SIG_IPI);
+}
=20
 static void clear_log_create_vm_done(struct kvm_vm *vm)
 {
@@ -179,10 +198,13 @@ static void clear_log_collect_dirty_pages(struct kvm_=
vm *vm, int slot,
 =09kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
 }
=20
-static void default_after_vcpu_run(struct kvm_vm *vm)
+static void default_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 =09struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
=20
+=09TEST_ASSERT(ret =3D=3D 0 || (ret =3D=3D -1 && err =3D=3D EINTR),
+=09=09    "vcpu run failed: errno=3D%d", err);
+
 =09TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) =3D=3D UCALL_SYNC,
 =09=09    "Invalid guest sync status: exit_reason=3D%s\n",
 =09=09    exit_reason_str(run->exit_reason));
@@ -244,19 +266,15 @@ static void dirty_ring_collect_dirty_pages(struct kvm=
_vm *vm, int slot,
 =09uint32_t count =3D 0, cleared;
=20
 =09/*
-=09 * Before fetching the dirty pages, we need a vmexit of the
-=09 * worker vcpu to make sure the hardware dirty buffers were
-=09 * flushed.  This is not needed for dirty-log/clear-log tests
-=09 * because get dirty log will natually do so.
-=09 *
-=09 * For now we do it in the simple way - we simply wait until
-=09 * the vcpu uses up the soft dirty ring, then it'll always
-=09 * do a vmexit to make sure that PML buffers will be flushed.
-=09 * In real hypervisors, we probably need a vcpu kick or to
-=09 * stop the vcpus (before the final sync) to make sure we'll
-=09 * get all the existing dirty PFNs even cached in hardware.
+=09 * These steps will make sure hardware buffer flushed to dirty
+=09 * ring.  Now with the vcpu kick mechanism we can keep the
+=09 * vcpu running even during collecting dirty bits without ring
+=09 * full.
 =09 */
+=09vcpu_kick();
 =09sem_wait(&dirty_ring_vcpu_stop);
+=09DEBUG("Notifying vcpu to continue\n");
+=09sem_post(&dirty_ring_vcpu_cont);
=20
 =09count +=3D dirty_ring_collect_one(kvm_map_dirty_ring(vm),
 =09=09=09=09=09&vm_run->vm_ring_indexes,
@@ -273,13 +291,10 @@ static void dirty_ring_collect_dirty_pages(struct kvm=
_vm *vm, int slot,
 =09TEST_ASSERT(cleared =3D=3D count, "Reset dirty pages (%u) mismatch "
 =09=09    "with collected (%u)", cleared, count);
=20
-=09DEBUG("Notifying vcpu to continue\n");
-=09sem_post(&dirty_ring_vcpu_cont);
-
 =09DEBUG("Iteration %ld collected %u pages\n", iteration, count);
 }
=20
-static void dirty_ring_after_vcpu_run(struct kvm_vm *vm)
+static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 =09struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
=20
@@ -287,9 +302,11 @@ static void dirty_ring_after_vcpu_run(struct kvm_vm *v=
m)
 =09if (get_ucall(vm, VCPU_ID, NULL) =3D=3D UCALL_SYNC) {
 =09=09/* We should allow this to continue */
 =09=09;
-=09} else if (run->exit_reason =3D=3D KVM_EXIT_DIRTY_RING_FULL) {
+=09} else if (run->exit_reason =3D=3D KVM_EXIT_DIRTY_RING_FULL ||
+=09=09   (ret =3D=3D -1 && err =3D=3D EINTR)) {
+=09=09/* Either ring full, or we're probably kicked out */
 =09=09sem_post(&dirty_ring_vcpu_stop);
-=09=09DEBUG("vcpu stops because dirty ring full...\n");
+=09=09DEBUG("vcpu stops because dirty ring full or kicked...\n");
 =09=09sem_wait(&dirty_ring_vcpu_cont);
 =09=09DEBUG("vcpu continues now.\n");
 =09} else {
@@ -313,7 +330,7 @@ struct log_mode {
 =09void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 =09=09=09=09     void *bitmap, uint32_t num_pages);
 =09/* Hook to call when after each vcpu run */
-=09void (*after_vcpu_run)(struct kvm_vm *vm);
+=09void (*after_vcpu_run)(struct kvm_vm *vm, int ret, int err);
 =09void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] =3D {
 =09{
@@ -373,12 +390,12 @@ static void log_mode_collect_dirty_pages(struct kvm_v=
m *vm, int slot,
 =09mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
 }
=20
-static void log_mode_after_vcpu_run(struct kvm_vm *vm)
+static void log_mode_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 =09struct log_mode *mode =3D &log_modes[host_log_mode];
=20
 =09if (mode->after_vcpu_run)
-=09=09mode->after_vcpu_run(vm);
+=09=09mode->after_vcpu_run(vm, ret, err);
 }
=20
 static void log_mode_before_vcpu_join(void)
@@ -402,15 +419,21 @@ static void *vcpu_worker(void *data)
 =09int ret;
 =09struct kvm_vm *vm =3D data;
 =09uint64_t *guest_array;
+=09struct sigaction sigact;
+
+=09current_vm =3D vm;
+=09memset(&sigact, 0, sizeof(sigact));
+=09sigact.sa_handler =3D vcpu_sig_handler;
+=09sigaction(SIG_IPI, &sigact, NULL);
=20
 =09guest_array =3D addr_gva2hva(vm, (vm_vaddr_t)random_array);
=20
 =09while (!READ_ONCE(host_quit)) {
+=09=09/* Clear any existing kick signals */
 =09=09generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 =09=09/* Let the guest dirty the random pages */
-=09=09ret =3D _vcpu_run(vm, VCPU_ID);
-=09=09TEST_ASSERT(ret =3D=3D 0, "vcpu_run failed: %d\n", ret);
-=09=09log_mode_after_vcpu_run(vm);
+=09=09ret =3D __vcpu_run(vm, VCPU_ID);
+=09=09log_mode_after_vcpu_run(vm, ret, errno);
 =09}
=20
 =09return NULL;
@@ -506,7 +529,6 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode=
, uint32_t vcpuid,
 static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 =09=09     unsigned long interval, uint64_t phys_offset)
 {
-=09pthread_t vcpu_thread;
 =09struct kvm_vm *vm;
 =09unsigned long *bmap;
=20
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h
index 5ad52f38af8d..fe5db2da7e73 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -116,6 +116,7 @@ struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t =
vcpuid);
 struct kvm_vm_run *vm_state(struct kvm_vm *vm);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
+int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_set_mp_state(struct kvm_vm *vm, uint32_t vcpuid,
 =09=09       struct kvm_mp_state *mp_state);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c
index 3a71e66a0b58..2addd0a7310f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1209,6 +1209,14 @@ int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
 =09return rc;
 }
=20
+int __vcpu_run(struct kvm_vm *vm, uint32_t vcpuid)
+{
+=09struct vcpu *vcpu =3D vcpu_find(vm, vcpuid);
+
+=09TEST_ASSERT(vcpu !=3D NULL, "vcpu not found, vcpuid: %u", vcpuid);
+=09return ioctl(vcpu->fd, KVM_RUN, NULL);
+}
+
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid)
 {
 =09struct vcpu *vcpu =3D vcpu_find(vm, vcpuid);
--=20
2.21.0

