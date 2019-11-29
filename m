Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C837610DB0A
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387470AbfK2Vfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:35:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46604 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387457AbfK2Vfj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:35:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/6Vnhm3Bnof3G6qR9jmImN6Mxny1Mm+SQ/fRHV6cvM=;
        b=HkIssdS/tQH/+DRnKBjBGDBnGEcAfyOPNK6OLN4A+s5TGPiMA44NqmuJiEf6RYzFkPLWkN
        NiMsw0r8GL+ttD7yvZya4+GpWeJlycCiLRqpxLP4beciCPPgGZXN3KoeY6GYSXSLovYPUp
        z94M8eNoJYllfS68yFKcfUBqbTyW6WM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-H8M-nMrMOTyf-L6sRIuU_g-1; Fri, 29 Nov 2019 16:35:33 -0500
Received: by mail-qt1-f198.google.com with SMTP id r9so8017474qtc.4
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ABKV7wtXWm4O1KQ//VgIZzpF4hiWiXzcQGJHlUZJvqM=;
        b=e6oUp9hJLp/5eVVhefAS10HPUd6VS80YRWPhkmzW0QRO0Q7r8uPAVBmHmarA0mJiSk
         xCDQwbrVmPq9w1W/cNebxjw29VqfrtDNTyFUGHvLDycmgqo1sMWkBrtaIhjz99daNFyN
         4ByeilP8dYgY9UO05tzVhRLFSiD6tdXO+phxddTZ5tlYvkHo/MixcqQuwxKcF39Fitbr
         jjw6dNgaMxi43vtnCuOX4Zv6ywRRtw9amHaaXZAI+IUhXGFsbn9epoq1OVXb4ZbUI7yU
         m3RR50FKSKchB7df0GwIGX0TKI3TvucivZ/CxlBvAnKqF0x+F8NZ/fq7Wmw5bOloL9hU
         T7Yw==
X-Gm-Message-State: APjAAAVxLG+BsSeponWA2dXx6kMX0hdjlFQkQq0+jJ+aOjUV0v+6EFVG
        f370v220vKqWh9M8zXGW2aulO7uDulbkzuEcW9idApgiTA/2GwlbCgEryLB40pDtRipwhjIrxkV
        dcaUjH0iMMG7q
X-Received: by 2002:a0c:baa5:: with SMTP id x37mr19072002qvf.228.1575063332542;
        Fri, 29 Nov 2019 13:35:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqx0gzwjNokztQZ2uGe1W03JAxQU4oiBDN2ekwESAnlau3v7lb+68GzvJT2MYI6UKslZ39yUvA==
X-Received: by 2002:a0c:baa5:: with SMTP id x37mr19071983qvf.228.1575063332220;
        Fri, 29 Nov 2019 13:35:32 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:31 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 15/15] KVM: selftests: Test dirty ring waitqueue
Date:   Fri, 29 Nov 2019 16:35:05 -0500
Message-Id: <20191129213505.18472-16-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: H8M-nMrMOTyf-L6sRIuU_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a bit tricky, but should still be reasonable.

Firstly we introduce a totally new dirty log test type, because we
need to force vcpu to go into a blocked state by dead loop on vcpu_run
even if it wants to quit to userspace.

Here the tricky part is we need to read the procfs to make sure the
vcpu thread is TASK_UNINTERRUPTIBLE.

After that, we reset the ring and the reset should kick the vcpu again
by moving out of that state.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 101 +++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/s=
elftests/kvm/dirty_log_test.c
index c9db136a1f12..41bc015131e1 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -16,6 +16,7 @@
 #include <sys/types.h>
 #include <signal.h>
 #include <errno.h>
+#include <sys/syscall.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <asm/barrier.h>
@@ -151,12 +152,16 @@ enum log_mode_t {
 =09/* Use dirty ring for logging */
 =09LOG_MODE_DIRTY_RING =3D 2,
=20
+=09/* Dirty ring test but tailored for the waitqueue */
+=09LOG_MODE_DIRTY_RING_WP =3D 3,
+
 =09LOG_MODE_NUM,
 };
=20
 /* Mode of logging.  Default is LOG_MODE_DIRTY_LOG */
 static enum log_mode_t host_log_mode;
 pthread_t vcpu_thread;
+pid_t vcpu_thread_tid;
 static uint32_t test_dirty_ring_count =3D TEST_DIRTY_RING_COUNT;
=20
 /* Only way to pass this to the signal handler */
@@ -221,6 +226,18 @@ static void dirty_ring_create_vm_done(struct kvm_vm *v=
m)
 =09=09=09     sizeof(struct kvm_dirty_gfn));
 }
=20
+static void dirty_ring_wq_create_vm_done(struct kvm_vm *vm)
+{
+=09/*
+=09 * Force to use a relatively small ring size, so easier to get
+=09 * full.  Better bigger than PML size, hence 1024.
+=09 */
+=09test_dirty_ring_count =3D 1024;
+=09DEBUG("Forcing ring size: %u\n", test_dirty_ring_count);
+=09vm_enable_dirty_ring(vm, test_dirty_ring_count *
+=09=09=09     sizeof(struct kvm_dirty_gfn));
+}
+
 static uint32_t dirty_ring_collect_one(struct kvm_dirty_gfn *dirty_gfns,
 =09=09=09=09       struct kvm_dirty_ring_indexes *indexes,
 =09=09=09=09       int slot, void *bitmap,
@@ -295,6 +312,81 @@ static void dirty_ring_collect_dirty_pages(struct kvm_=
vm *vm, int slot,
 =09DEBUG("Iteration %ld collected %u pages\n", iteration, count);
 }
=20
+/*
+ * Return 'D' for uninterruptible, 'R' for running, 'S' for
+ * interruptible, etc.
+ */
+static char read_tid_status_char(unsigned int tid)
+{
+=09int fd, ret, line =3D 0;
+=09char buf[128], *c;
+
+=09snprintf(buf, sizeof(buf) - 1, "/proc/%u/status", tid);
+=09fd =3D open(buf, O_RDONLY);
+=09TEST_ASSERT(fd >=3D 0, "open status file failed: %s", buf);
+=09ret =3D read(fd, buf, sizeof(buf) - 1);
+=09TEST_ASSERT(ret > 0, "read status file failed: %d, %d", ret, errno);
+=09close(fd);
+
+=09/* Skip 2 lines */
+=09for (c =3D buf; c < buf + sizeof(buf) && line < 2; c++) {
+=09=09if (*c =3D=3D '\n') {
+=09=09=09line++;
+=09=09=09continue;
+=09=09}
+=09}
+
+=09/* Skip "Status:  " */
+=09while (*c !=3D ':') c++;
+=09c++;
+=09while (*c =3D=3D ' ') c++;
+=09c++;
+
+=09return *c;
+}
+
+static void dirty_ring_wq_collect_dirty_pages(struct kvm_vm *vm, int slot,
+=09=09=09=09=09      void *bitmap, uint32_t num_pages)
+{
+=09uint32_t count =3D test_dirty_ring_count;
+=09struct kvm_run *state =3D vcpu_state(vm, VCPU_ID);
+=09struct kvm_dirty_ring_indexes *indexes =3D &state->vcpu_ring_indexes;
+=09uint32_t avail;
+
+=09while (count--) {
+=09=09/*
+=09=09 * Force vcpu to run enough time to make sure we
+=09=09 * trigger the ring full case
+=09=09 */
+=09=09sem_post(&dirty_ring_vcpu_cont);
+=09}
+
+=09/* Make sure it's stuck */
+=09TEST_ASSERT(vcpu_thread_tid, "TID not inited");
+        /*
+=09 * Wait for /proc/pid/status "Status:" changes to "D". "D"
+=09 * stands for "D (disk sleep)", TASK_UNINTERRUPTIBLE
+=09 */
+=09while (read_tid_status_char(vcpu_thread_tid) !=3D 'D') {
+=09=09usleep(1000);
+=09}
+=09DEBUG("Now VCPU thread dirty ring full\n");
+
+=09avail =3D READ_ONCE(indexes->avail_index);
+=09/* Assuming we've consumed all */
+=09WRITE_ONCE(indexes->fetch_index, avail);
+
+=09kvm_vm_reset_dirty_ring(vm);
+
+=09/* Wait for it to be awake */
+=09while (read_tid_status_char(vcpu_thread_tid) =3D=3D 'D') {
+=09=09usleep(1000);
+=09}
+=09DEBUG("VCPU Thread is successfully waked up\n");
+
+=09exit(0);
+}
+
 static void dirty_ring_after_vcpu_run(struct kvm_vm *vm, int ret, int err)
 {
 =09struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
@@ -353,6 +445,12 @@ struct log_mode {
 =09=09.before_vcpu_join =3D dirty_ring_before_vcpu_join,
 =09=09.after_vcpu_run =3D dirty_ring_after_vcpu_run,
 =09},
+=09{
+=09=09.name =3D "dirty-ring-wait-queue",
+=09=09.create_vm_done =3D dirty_ring_wq_create_vm_done,
+=09=09.collect_dirty_pages =3D dirty_ring_wq_collect_dirty_pages,
+=09=09.after_vcpu_run =3D dirty_ring_after_vcpu_run,
+=09},
 };
=20
 /*
@@ -422,6 +520,9 @@ static void *vcpu_worker(void *data)
 =09uint64_t *guest_array;
 =09struct sigaction sigact;
=20
+=09vcpu_thread_tid =3D syscall(SYS_gettid);
+=09printf("VCPU Thread ID: %u\n", vcpu_thread_tid);
+
 =09current_vm =3D vm;
 =09memset(&sigact, 0, sizeof(sigact));
 =09sigact.sa_handler =3D vcpu_sig_handler;
--=20
2.21.0

