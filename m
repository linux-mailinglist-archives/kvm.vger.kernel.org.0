Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF35710DB0E
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbfK2Vfc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:35:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55796 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387406AbfK2Vfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 16:35:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AVwR89GpLJvgOqcOYsvRfM8XUB2WN/29zxkwIRsm8Ds=;
        b=Dy6cNiHRMVJGkit2DR3GVBLLkgLhfDLHDTOrOG0fttB+uWQ+L6d1Bln04RXgh5/Su0gCv1
        1totNGJm8/6FXPUHkIP/UzItxS2CioS6Em+fGxxwHofpm8te5eaSu9DoVuvCzxoIShz3JL
        dLMzi9IFSo8Rt/ZAWrlhP1mNveYnrks=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-227-dFTn7oKpMUSjgxpURXLXoQ-1; Fri, 29 Nov 2019 16:35:27 -0500
Received: by mail-qv1-f71.google.com with SMTP id d3so19713856qvz.2
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I/ru2uLWH98VwOEpQ4g8Db5rqCjk9Lo4bBQ00K16x0M=;
        b=HGZQzfWY1pWqiPdMMdJykm4RI2y+gI5lqyzskfrVJwz3MrcdMa71HYtZXWbzBwlAAc
         /wxvYTjUfibY72llbe+g60rEaTphqaifFs+Y+ka/vWbyh2xBgxfKXLyOqO64UTDvcPk6
         +Xo3bTx7aQqGkSHzeZdinLi9n48KPRqePhMkwt4tRuMZfuv+D69FoCasBPjvu7M6c2gz
         r17nDhy9J07l2fPAje2xkKDbiaXItjkuihdI9gCtu3LYfQgDLNt2v8ZRAYyhL0ys597X
         fhPUizeQ0GLjv/bwEQ9kHOa6ecWGuqOCB2if2t9Mdi98yRG5JqWLkCf2kKWOq/9D32XH
         7Lug==
X-Gm-Message-State: APjAAAUuf7GX+RSreBTMs0T1jHsx3G2bTndoeKa5+Gj6OclWR6pi2tXX
        JQwpQtf8DtkHsC58Iagf63tj/xab/DqLE8pvkb/+acYHHPCD3vizOrpVAJmG6T+Q46Dg2Ky1Oa8
        beQISwf9QSlCE
X-Received: by 2002:ad4:55e8:: with SMTP id bu8mr15973908qvb.61.1575063326994;
        Fri, 29 Nov 2019 13:35:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqyO0sB52jgNAeOKc4OLF6WGBaoE6fp1MHQy2+mrUu67bIMbdQuVzZkL3OSLnKOEKAm8ZgDobg==
X-Received: by 2002:ad4:55e8:: with SMTP id bu8mr15973883qvb.61.1575063326723;
        Fri, 29 Nov 2019 13:35:26 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:25 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 11/15] KVM: selftests: Introduce after_vcpu_run hook for dirty log test
Date:   Fri, 29 Nov 2019 16:35:01 -0500
Message-Id: <20191129213505.18472-12-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: dFTn7oKpMUSjgxpURXLXoQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a hook for the checks after vcpu_run() completes.  Preparation
for the dirty ring test because we'll need to take care of another
exit reason.

Since at it, drop the pages_count because after all we have a better
summary right now with statistics, and clean it up a bit.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 39 ++++++++++++--------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/s=
elftests/kvm/dirty_log_test.c
index a8ae8c0042a8..3542311f56ff 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -168,6 +168,15 @@ static void clear_log_collect_dirty_pages(struct kvm_v=
m *vm, int slot,
 =09kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
 }
=20
+static void default_after_vcpu_run(struct kvm_vm *vm)
+{
+=09struct kvm_run *run =3D vcpu_state(vm, VCPU_ID);
+
+=09TEST_ASSERT(get_ucall(vm, VCPU_ID, NULL) =3D=3D UCALL_SYNC,
+=09=09    "Invalid guest sync status: exit_reason=3D%s\n",
+=09=09    exit_reason_str(run->exit_reason));
+}
+
 struct log_mode {
 =09const char *name;
 =09/* Hook when the vm creation is done (before vcpu creation) */
@@ -175,16 +184,20 @@ struct log_mode {
 =09/* Hook to collect the dirty pages into the bitmap provided */
 =09void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
 =09=09=09=09     void *bitmap, uint32_t num_pages);
+=09/* Hook to call when after each vcpu run */
+=09void (*after_vcpu_run)(struct kvm_vm *vm);
 } log_modes[LOG_MODE_NUM] =3D {
 =09{
 =09=09.name =3D "dirty-log",
 =09=09.create_vm_done =3D NULL,
 =09=09.collect_dirty_pages =3D dirty_log_collect_dirty_pages,
+=09=09.after_vcpu_run =3D default_after_vcpu_run,
 =09},
 =09{
 =09=09.name =3D "clear-log",
 =09=09.create_vm_done =3D clear_log_create_vm_done,
 =09=09.collect_dirty_pages =3D clear_log_collect_dirty_pages,
+=09=09.after_vcpu_run =3D default_after_vcpu_run,
 =09},
 };
=20
@@ -224,6 +237,14 @@ static void log_mode_collect_dirty_pages(struct kvm_vm=
 *vm, int slot,
 =09mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
 }
=20
+static void log_mode_after_vcpu_run(struct kvm_vm *vm)
+{
+=09struct log_mode *mode =3D &log_modes[host_log_mode];
+
+=09if (mode->after_vcpu_run)
+=09=09mode->after_vcpu_run(vm);
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 =09uint64_t i;
@@ -237,31 +258,17 @@ static void *vcpu_worker(void *data)
 =09int ret;
 =09struct kvm_vm *vm =3D data;
 =09uint64_t *guest_array;
-=09uint64_t pages_count =3D 0;
-=09struct kvm_run *run;
-
-=09run =3D vcpu_state(vm, VCPU_ID);
=20
 =09guest_array =3D addr_gva2hva(vm, (vm_vaddr_t)random_array);
-=09generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
=20
 =09while (!READ_ONCE(host_quit)) {
+=09=09generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 =09=09/* Let the guest dirty the random pages */
 =09=09ret =3D _vcpu_run(vm, VCPU_ID);
 =09=09TEST_ASSERT(ret =3D=3D 0, "vcpu_run failed: %d\n", ret);
-=09=09if (get_ucall(vm, VCPU_ID, NULL) =3D=3D UCALL_SYNC) {
-=09=09=09pages_count +=3D TEST_PAGES_PER_LOOP;
-=09=09=09generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
-=09=09} else {
-=09=09=09TEST_ASSERT(false,
-=09=09=09=09    "Invalid guest sync status: "
-=09=09=09=09    "exit_reason=3D%s\n",
-=09=09=09=09    exit_reason_str(run->exit_reason));
-=09=09}
+=09=09log_mode_after_vcpu_run(vm);
 =09}
=20
-=09DEBUG("Dirtied %"PRIu64" pages\n", pages_count);
-
 =09return NULL;
 }
=20
--=20
2.21.0

