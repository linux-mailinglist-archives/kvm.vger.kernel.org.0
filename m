Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8CA10DB06
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387437AbfK2Vfe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:35:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:24751 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387419AbfK2Vfc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:35:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHvz4uCnwPahuSSwiWfF4UrUk2alj3qViK65/D923A4=;
        b=SuX3Ruu9pLH4AgjvUXTZ9LHJOyiJlQcDelXBBz9a/UTiXoNhwSyrs9zdprCBxVmxKJawtV
        K0Y7oML6olt/gdxIS+0KiKONo5mpKX+p/iEU37Orv60kQKtBYw1HaCNEbfGWleZq1VahTx
        MjAV5MskbICGI4Sbtxn0ARZt9E1UHBk=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-eeKeLtMSNcS2tkJimIMY8g-1; Fri, 29 Nov 2019 16:35:29 -0500
Received: by mail-qt1-f198.google.com with SMTP id s8so19654322qtq.17
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AQHPtukpR8BIC9uU90sfq2RrCEOxqZPLoV+AnhfQkQ0=;
        b=Le0XIQNC8scxLZPPS4RVyJ7R03PXUrIMBR3z27wmjrA82Tj3Q5jAVZwUqtI885nO+I
         PZbBlk4rQrJfopTIz4D1qr+e/48wA61QVz1J28JTtwJdqHtDJFsTVLcIi2xQmDvTldUP
         8QIf0rpJkTeSTahvZVpzlXyLKyMMCjkNqRES9sr7lJzY0eYZq8i8duWhaJorWu9avkbw
         n3ESymzmPRrKHDiuzAfvhSPucyY5/rMtlka14qA63MG4wOt/EqrtwcNXeexMIarrFStI
         FTiOVrDaLJSKfL+kT6/srBnI1w1Nm/yoms/6fDVftiAs0LwRl5AQglw+nAQ7kXizPM1X
         V+sA==
X-Gm-Message-State: APjAAAXN+gl9+8GrNWoLmgq6LseGqDEnaU5BuWANemBNWFlxVV3XJF/f
        jvAFGMtUlPovIg7tBL0Im7L41my8TKGS9VuQoLxs6V/lwQsbJUsFaF6TyyB9iFbSUcJhOSZRM6C
        o0efM/p7iCEyK
X-Received: by 2002:ac8:43da:: with SMTP id w26mr43275235qtn.272.1575063328684;
        Fri, 29 Nov 2019 13:35:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqxDmuGEjts35ZAA78yzU46ONcDtlygTqVON5jLy8y+XNRNbspZdBrfALEfw2fF5MLkkh53b1w==
X-Received: by 2002:ac8:43da:: with SMTP id w26mr43275199qtn.272.1575063328230;
        Fri, 29 Nov 2019 13:35:28 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:27 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 12/15] KVM: selftests: Add dirty ring buffer test
Date:   Fri, 29 Nov 2019 16:35:02 -0500
Message-Id: <20191129213505.18472-13-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: eeKeLtMSNcS2tkJimIMY8g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the initial dirty ring buffer test.

The current test implements the userspace dirty ring collection, by
only reaping the dirty ring when the ring is full.

So it's still running asynchronously like this:

            vcpu                             main thread

  1. vcpu dirties pages
  2. vcpu gets dirty ring full
     (userspace exit)

                                       3. main thread waits until full
                                          (so hardware buffers flushed)
                                       4. main thread collects
                                       5. main thread continues vcpu

  6. vcpu continues, goes back to 1

We can't directly collects dirty bits during vcpu execution because
otherwise we can't guarantee the hardware dirty bits were flushed when
we collect and we're very strict on the dirty bits so otherwise we can
fail the future verify procedure.  A follow up patch will make this
test to support async just like the existing dirty log test, by adding
a vcpu kick mechanism.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 148 ++++++++++++++++++
 .../testing/selftests/kvm/include/kvm_util.h  |   5 +
 tools/testing/selftests/kvm/lib/kvm_util.c    |  95 +++++++++++
 .../selftests/kvm/lib/kvm_util_internal.h     |   5 +
 4 files changed, 253 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/s=
elftests/kvm/dirty_log_test.c
index 3542311f56ff..968e35c5d380 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -12,8 +12,10 @@
 #include <unistd.h>
 #include <time.h>
 #include <pthread.h>
+#include <semaphore.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <asm/barrier.h>
=20
 #include "test_util.h"
 #include "kvm_util.h"
@@ -57,6 +59,8 @@
 # define test_and_clear_bit_le=09test_and_clear_bit
 #endif
=20
+#define TEST_DIRTY_RING_COUNT=09=091024
+
 /*
  * Guest/Host shared variables. Ensure addr_gva2hva() and/or
  * sync_global_to/from_guest() are used when accessing from
@@ -128,6 +132,10 @@ static uint64_t host_dirty_count;
 static uint64_t host_clear_count;
 static uint64_t host_track_next_count;
=20
+/* Whether dirty ring reset is requested, or finished */
+static sem_t dirty_ring_vcpu_stop;
+static sem_t dirty_ring_vcpu_cont;
+
 enum log_mode_t {
 =09/* Only use KVM_GET_DIRTY_LOG for logging */
 =09LOG_MODE_DIRTY_LOG =3D 0,
@@ -135,6 +143,9 @@ enum log_mode_t {
 =09/* Use both KVM_[GET|CLEAR]_DIRTY_LOG for logging */
 =09LOG_MODE_CLERA_LOG =3D 1,
=20
+=09/* Use dirty ring for logging */
+=09LOG_MODE_DIRTY_RING =3D 2,
+
 =09LOG_MODE_NUM,
 };
=20
@@ -177,6 +188,123 @@ static void default_after_vcpu_run(struct kvm_vm *vm)
 =09=09    exit_reason_str(run->exit_reason));
 }
=20
+static void dirty_ring_create_vm_done(struct kvm_vm *vm)
+{
+=09/*
+=09 * Switch to dirty ring mode after VM creation but before any
+=09 * of the vcpu creation.
+=09 */
+=09vm_enable_dirty_ring(vm, TEST_DIRTY_RING_COUNT *
+=09=09=09     sizeof(struct kvm_dirty_gfn));
+}
+
+static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
+=09=09=09=09       struct kvm_dirty_ring_indexes *indexes,
+=09=09=09=09       int slot, void *bitmap,
+=09=09=09=09       uint32_t num_pages, int index)
+{
+=09struct kvm_dirty_gfn *cur;
+=09uint32_t avail, fetch, count =3D 0;
+
+=09/*
+=09 * We should keep it somewhere, but to be simple we read
+=09 * fetch_index too.
+=09 */
+=09fetch =3D READ_ONCE(indexes->fetch_index);
+=09avail =3D READ_ONCE(indexes->avail_index);
+
+=09/* Make sure we read valid entries always */
+=09rmb();
+
+=09DEBUG("ring %d: fetch: 0x%x, avail: 0x%x\n", index, fetch, avail);
+
+=09while (fetch !=3D avail) {
+=09=09cur =3D &dirty_gfns[fetch % test_dirty_ring_count];
+=09=09TEST_ASSERT(cur->pad =3D=3D 0, "Padding is non-zero: 0x%x", cur->pad=
);
+=09=09TEST_ASSERT(cur->slot =3D=3D slot, "Slot number didn't match: "
+=09=09=09    "%u !=3D %u", cur->slot, slot);
+=09=09TEST_ASSERT(cur->offset < num_pages, "Offset overflow: "
+=09=09=09    "0x%llx >=3D 0x%llx", cur->offset, num_pages);
+=09=09//DEBUG("slot %d offset %llu\n", cur->slot, cur->offset);
+=09=09test_and_set_bit(cur->offset, bitmap);
+=09=09fetch++;
+=09=09count++;
+=09}
+=09WRITE_ONCE(indexes->fetch_index, fetch);
+
+=09return count;
+}
+
+static void dirty_ring_collect_dirty_pages(struct kvm_vm *vm, int slot,
+=09=09=09=09=09   void *bitmap, uint32_t num_pages)
+{
+=09/* We only have one vcpu */
+=09struct kvm_run *state =3D vcpu_state(vm, VCPU_ID);
+=09struct kvm_vm_run *vm_run =3D vm_state(vm);
+=09uint32_t count =3D 0, cleared;
+
+=09/*
+=09 * Before fetching the dirty pages, we need a vmexit of the
+=09 * worker vcpu to make sure the hardware dirty buffers were
+=09 * flushed.  This is not needed for dirty-log/clear-log tests
+=09 * because get dirty log will natually do so.
+=09 *
+=09 * For now we do it in the simple way - we simply wait until
+=09 * the vcpu uses up the soft dirty ring, then it'll always
+=09 * do a vmexit to make sure that PML buffers will be flushed.
+=09 * In real hypervisors, we probably need a vcpu kick or to
+=09 * stop the vcpus (before the final sync) to make sure we'll
+=09 * get all the existing dirty PFNs even cached in hardware.
+=09 */
+=09sem_wait(&dirty_ring_vcpu_stop);
+
+=09count +=3D dirty_ring_collect_one(kvm_map_dirty_ring(vm),
+=09=09=09=09=09&vm_run->vm_ring_indexes,
+=09=09=09=09=09slot, bitmap, num_pages, -1);
+
+=09/* Only have one vcpu */
+=09count +=3D dirty_ring_collect_one(vcpu_map_dirty_ring(vm, VCPU_ID),
+=09=09=09=09=09&state->vcpu_ring_indexes,
+=09=09=09=09=09slot, bitmap, num_pages, VCPU_ID);
+
+=09cleared =3D kvm_vm_reset_dirty_ring(vm);
+
+=09/* Cleared pages should be the same as collected */
+=09TEST_ASSERT(cleared =3D=3D count, "Reset dirty pages (%u) mismatch "
+=09=09    "with collected (%u)", cleared, count);
+
+=09DEBUG("Notifying vcpu to continue\n");
+=09sem_post(&dirty_ring_vcpu_cont);
+
+=09DEBUG("Iteration %ld collected %u pages\n", iteration, count);
+}
+
+static void dirty_ring_after_vcpu_run(struct kvm_vm *vm)
+{
+=09struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
+
+=09/* A ucall-sync or ring-full event is allowed */
+=09if (get_ucall(vm, VCPU_ID, NULL) =3D=3D UCALL_SYNC) {
+=09=09/* We should allow this to continue */
+=09=09;
+=09} else if (run->exit_reason =3D=3D KVM_EXIT_DIRTY_RING_FULL) {
+=09=09sem_post(&dirty_ring_vcpu_stop);
+=09=09DEBUG("vcpu stops because dirty ring full...\n");
+=09=09sem_wait(&dirty_ring_vcpu_cont);
+=09=09DEBUG("vcpu continues now.\n");
+=09} else {
+=09=09TEST_ASSERT(false, "Invalid guest sync status: "
+=09=09=09    "exit_reason=3D%s\n",
+=09=09=09    exit_reason_str(run->exit_reason));
+=09}
+}
+
+static void dirty_ring_before_vcpu_join(void)
+{
+=09/* Kick another round of vcpu just to make sure it will quit */
+=09sem_post(&dirty_ring_vcpu_cont);
+}
+
 struct log_mode {
 =09const char *name;
 =09/* Hook when the vm creation is done (before vcpu creation) */
@@ -186,6 +314,7 @@ struct log_mode {
 =09=09=09=09     void *bitmap, uint32_t num_pages);
 =09/* Hook to call when after each vcpu run */
 =09void (*after_vcpu_run)(struct kvm_vm *vm);
+=09void (*before_vcpu_join) (void);
 } log_modes[LOG_MODE_NUM] =3D {
 =09{
 =09=09.name =3D "dirty-log",
@@ -199,6 +328,13 @@ struct log_mode {
 =09=09.collect_dirty_pages =3D clear_log_collect_dirty_pages,
 =09=09.after_vcpu_run =3D default_after_vcpu_run,
 =09},
+=09{
+=09=09.name =3D "dirty-ring",
+=09=09.create_vm_done =3D dirty_ring_create_vm_done,
+=09=09.collect_dirty_pages =3D dirty_ring_collect_dirty_pages,
+=09=09.before_vcpu_join =3D dirty_ring_before_vcpu_join,
+=09=09.after_vcpu_run =3D dirty_ring_after_vcpu_run,
+=09},
 };
=20
 /*
@@ -245,6 +381,14 @@ static void log_mode_after_vcpu_run(struct kvm_vm *vm)
 =09=09mode->after_vcpu_run(vm);
 }
=20
+static void log_mode_before_vcpu_join(void)
+{
+=09struct log_mode *mode =3D &log_modes[host_log_mode];
+
+=09if (mode->before_vcpu_join)
+=09=09mode->before_vcpu_join();
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 =09uint64_t i;
@@ -460,6 +604,7 @@ static void run_test(enum vm_guest_mode mode, unsigned =
long iterations,
=20
 =09/* Tell the vcpu thread to quit */
 =09host_quit =3D true;
+=09log_mode_before_vcpu_join();
 =09pthread_join(vcpu_thread, NULL);
=20
 =09DEBUG("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
@@ -524,6 +669,9 @@ int main(int argc, char *argv[])
 =09unsigned int host_ipa_limit;
 #endif
=20
+=09sem_init(&dirty_ring_vcpu_stop, 0, 0);
+=09sem_init(&dirty_ring_vcpu_cont, 0, 0);
+
 #ifdef __x86_64__
 =09vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
 #endif
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h
index 29cccaf96baf..5ad52f38af8d 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -67,6 +67,7 @@ enum vm_mem_backing_src_type {
=20
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
+void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size);
=20
 struct kvm_vm *vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int =
perm);
 struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int=
 perm);
@@ -76,6 +77,7 @@ void kvm_vm_release(struct kvm_vm *vmp);
 void kvm_vm_get_dirty_log(struct kvm_vm *vm, int slot, void *log);
 void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slot, void *log,
 =09=09=09    uint64_t first_page, uint32_t num_pages);
+uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm);
=20
 int kvm_memcmp_hva_gva(void *hva, struct kvm_vm *vm, const vm_vaddr_t gva,
 =09=09       size_t len);
@@ -111,6 +113,7 @@ vm_paddr_t addr_hva2gpa(struct kvm_vm *vm, void *hva);
 vm_paddr_t addr_gva2gpa(struct kvm_vm *vm, vm_vaddr_t gva);
=20
 struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32_t vcpuid);
+struct kvm_vm_run *vm_state(struct kvm_vm *vm);
 void vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 int _vcpu_run(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_run_complete_io(struct kvm_vm *vm, uint32_t vcpuid);
@@ -137,6 +140,8 @@ void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t =
vcpuid,
 int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
 =09=09=09  struct kvm_nested_state *state, bool ignore_error);
 #endif
+void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid);
+void *kvm_map_dirty_ring(struct kvm_vm *vm);
=20
 const char *exit_reason_str(unsigned int exit_reason);
=20
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c
index 41cf45416060..3a71e66a0b58 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -85,6 +85,26 @@ int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_c=
ap *cap)
 =09return ret;
 }
=20
+void vm_enable_dirty_ring(struct kvm_vm *vm, uint32_t ring_size)
+{
+=09struct kvm_enable_cap cap =3D {};
+=09int ret;
+
+=09ret =3D kvm_check_cap(KVM_CAP_DIRTY_LOG_RING);
+
+=09TEST_ASSERT(ret >=3D 0, "KVM_CAP_DIRTY_LOG_RING");
+
+=09if (ret =3D=3D 0) {
+=09=09fprintf(stderr, "KVM does not support dirty ring, skipping tests\n")=
;
+=09=09exit(KSFT_SKIP);
+=09}
+
+=09cap.cap =3D KVM_CAP_DIRTY_LOG_RING;
+=09cap.args[0] =3D ring_size;
+=09vm_enable_cap(vm, &cap);
+=09vm->dirty_ring_size =3D ring_size;
+}
+
 static void vm_open(struct kvm_vm *vm, int perm)
 {
 =09vm->kvm_fd =3D open(KVM_DEV_PATH, perm);
@@ -297,6 +317,11 @@ void kvm_vm_clear_dirty_log(struct kvm_vm *vm, int slo=
t, void *log,
 =09=09    strerror(-ret));
 }
=20
+uint32_t kvm_vm_reset_dirty_ring(struct kvm_vm *vm)
+{
+=09return ioctl(vm->fd, KVM_RESET_DIRTY_RINGS);
+}
+
 /*
  * Userspace Memory Region Find
  *
@@ -408,6 +433,13 @@ static void vm_vcpu_rm(struct kvm_vm *vm, uint32_t vcp=
uid)
 =09struct vcpu *vcpu =3D vcpu_find(vm, vcpuid);
 =09int ret;
=20
+=09if (vcpu->dirty_gfns) {
+=09=09ret =3D munmap(vcpu->dirty_gfns, vm->dirty_ring_size);
+=09=09TEST_ASSERT(ret =3D=3D 0, "munmap of VCPU dirty ring failed, "
+=09=09=09    "rc: %i errno: %i", ret, errno);
+=09=09vcpu->dirty_gfns =3D NULL;
+=09}
+
 =09ret =3D munmap(vcpu->state, sizeof(*vcpu->state));
 =09TEST_ASSERT(ret =3D=3D 0, "munmap of VCPU fd failed, rc: %i "
 =09=09"errno: %i", ret, errno);
@@ -447,6 +479,16 @@ void kvm_vm_free(struct kvm_vm *vmp)
 {
 =09int ret;
=20
+=09if (vmp->vm_run) {
+=09=09munmap(vmp->vm_run, sizeof(struct kvm_vm_run));
+=09=09vmp->vm_run =3D NULL;
+=09}
+
+=09if (vmp->vm_dirty_gfns) {
+=09=09munmap(vmp->vm_dirty_gfns, vmp->dirty_ring_size);
+=09=09vmp->vm_dirty_gfns =3D NULL;
+=09}
+
 =09if (vmp =3D=3D NULL)
 =09=09return;
=20
@@ -1122,6 +1164,18 @@ struct kvm_run *vcpu_state(struct kvm_vm *vm, uint32=
_t vcpuid)
 =09return vcpu->state;
 }
=20
+struct kvm_vm_run *vm_state(struct kvm_vm *vm)
+{
+=09if (!vm->vm_run) {
+=09=09vm->vm_run =3D (struct kvm_vm_run *)
+=09=09    mmap(NULL, sizeof(struct kvm_vm_run),
+=09=09=09 PROT_READ | PROT_WRITE, MAP_SHARED, vm->fd, 0);
+=09=09TEST_ASSERT(vm->vm_run !=3D MAP_FAILED,
+=09=09=09    "kvm vm run mapping failed");
+=09}
+=09return vm->vm_run;
+}
+
 /*
  * VM VCPU Run
  *
@@ -1409,6 +1463,46 @@ int _vcpu_ioctl(struct kvm_vm *vm, uint32_t vcpuid,
 =09return ret;
 }
=20
+void *vcpu_map_dirty_ring(struct kvm_vm *vm, uint32_t vcpuid)
+{
+=09struct vcpu *vcpu;
+=09uint32_t size =3D vm->dirty_ring_size;
+
+=09TEST_ASSERT(size > 0, "Should enable dirty ring first");
+
+=09vcpu =3D vcpu_find(vm, vcpuid);
+
+=09TEST_ASSERT(vcpu, "Cannot find vcpu %u", vcpuid);
+
+=09if (!vcpu->dirty_gfns) {
+=09=09vcpu->dirty_gfns_count =3D size / sizeof(struct kvm_dirty_gfn);
+=09=09vcpu->dirty_gfns =3D mmap(NULL, size, PROT_READ | PROT_WRITE,
+=09=09=09=09=09MAP_SHARED, vcpu->fd, vm->page_size *
+=09=09=09=09=09KVM_DIRTY_LOG_PAGE_OFFSET);
+=09=09TEST_ASSERT(vcpu->dirty_gfns !=3D MAP_FAILED,
+=09=09=09    "Dirty ring map failed");
+=09}
+
+=09return vcpu->dirty_gfns;
+}
+
+void *kvm_map_dirty_ring(struct kvm_vm *vm)
+{
+=09uint32_t size =3D vm->dirty_ring_size;
+
+=09TEST_ASSERT(size > 0, "Should enable dirty ring first");
+
+=09if (!vm->vm_dirty_gfns) {
+=09=09vm->vm_dirty_gfns =3D mmap(NULL, size, PROT_READ | PROT_WRITE,
+=09=09=09=09=09 MAP_SHARED, vm->fd, vm->page_size *
+=09=09=09=09=09 KVM_DIRTY_LOG_PAGE_OFFSET);
+=09=09TEST_ASSERT(vm->vm_dirty_gfns !=3D MAP_FAILED,
+=09=09=09    "Dirty ring map failed");
+=09}
+
+=09return vm->vm_dirty_gfns;
+}
+
 /*
  * VM Ioctl
  *
@@ -1503,6 +1597,7 @@ static struct exit_reason {
 =09{KVM_EXIT_INTERNAL_ERROR, "INTERNAL_ERROR"},
 =09{KVM_EXIT_OSI, "OSI"},
 =09{KVM_EXIT_PAPR_HCALL, "PAPR_HCALL"},
+=09{KVM_EXIT_DIRTY_RING_FULL, "DIRTY_RING_FULL"},
 #ifdef KVM_EXIT_MEMORY_NOT_PRESENT
 =09{KVM_EXIT_MEMORY_NOT_PRESENT, "MEMORY_NOT_PRESENT"},
 #endif
diff --git a/tools/testing/selftests/kvm/lib/kvm_util_internal.h b/tools/te=
sting/selftests/kvm/lib/kvm_util_internal.h
index ac50c42750cf..3423d78d7993 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util_internal.h
+++ b/tools/testing/selftests/kvm/lib/kvm_util_internal.h
@@ -39,6 +39,8 @@ struct vcpu {
 =09uint32_t id;
 =09int fd;
 =09struct kvm_run *state;
+=09struct kvm_dirty_gfn *dirty_gfns;
+=09uint32_t dirty_gfns_count;
 };
=20
 struct kvm_vm {
@@ -61,6 +63,9 @@ struct kvm_vm {
 =09vm_paddr_t pgd;
 =09vm_vaddr_t gdt;
 =09vm_vaddr_t tss;
+=09uint32_t dirty_ring_size;
+=09struct kvm_vm_run *vm_run;
+=09struct kvm_dirty_gfn *vm_dirty_gfns;
 };
=20
 struct vcpu *vcpu_find(struct kvm_vm *vm, uint32_t vcpuid);
--=20
2.21.0

