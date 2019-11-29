Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E42210DB10
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387411AbfK2Vfa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:35:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30415 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727455AbfK2Vf2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 16:35:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P5AbgpUfRNxdJPVDFTcfRzPiSipiKvMe/PdnHweHoi8=;
        b=VuQD0mDKdKc6OMfv1rPW0kk2ULJpTM8M6tfgaySaAk6vpzYKbQO06/D30H4tW8y9RgNwgC
        cniwOM8FGdkir1fdtdoAt4OS0yKa4Ud02pAc27Esu2yhPF+J/b8xzhOHYs7CKRlN1i7ycS
        /Kq293yqGgQSoojVsTNvAQavObJcSoM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-aRhnBmPaMjKVtxlAO66SDA-1; Fri, 29 Nov 2019 16:35:26 -0500
Received: by mail-qt1-f198.google.com with SMTP id x21so19719742qtp.1
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJUKGGK5QCK7nGpwM9ItG2F9zksWMA0xUQtg22oHDPc=;
        b=SuzuGqDBf1KLRHtwAocMHSPT/G6OGHWhB5tiUxmDeOF9Hy9RtE3Oh8OkJLfYHkrzM9
         ykUO8VkKqZzH15H6JOjarX3603Y2V3dMxJTKDDEB6DxKgwZ2YKEj4rxvPIHjVZyv7tC8
         jg6cBb6iTl9LgA6qzNQjXo3BPXQCASRbr4zq+F2+khByH9vF7u3DRNlapcbYA/Z95891
         KTmVaOzhgYO2uFCMwFjutJ9CkFbENBwt26etG76o+dD3AWKM52RziYotZ6GXqv4GPfo7
         V+2WuraVYPTFJm7t19HgDTVILLcKGnq+arvD4KEB4+zhcGMkEFg7ztNDDwG4tGArVRPh
         e/9A==
X-Gm-Message-State: APjAAAXzvUyo6F3nfQTp5cM5rf0ZMlsv/pz3JbR6z4rAv6wgdJ6H3ZfV
        eTcIfNDoRAa8MLQ5GcuXoxwwQ97jElqej69Z3dsp9MGWt+TwaJB54UVI2k7W319UyPiilgaLG/q
        njyaOUtxk0fxE
X-Received: by 2002:aed:2103:: with SMTP id 3mr42418235qtc.132.1575063325389;
        Fri, 29 Nov 2019 13:35:25 -0800 (PST)
X-Google-Smtp-Source: APXvYqwvgOZjGvsXBPgfSr/Px2y4ZuxtVQVUzGcdlunaZ0Md4LZTtDyMj7SjYRKhhNcrydFW4faW5A==
X-Received: by 2002:aed:2103:: with SMTP id 3mr42418207qtc.132.1575063325096;
        Fri, 29 Nov 2019 13:35:25 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:24 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 10/15] KVM: selftests: Use a single binary for dirty/clear log test
Date:   Fri, 29 Nov 2019 16:35:00 -0500
Message-Id: <20191129213505.18472-11-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: aRhnBmPaMjKVtxlAO66SDA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the clear_dirty_log test, instead merge it into the existing
dirty_log_test.  It should be cleaner to use this single binary to do
both tests, also it's a preparation for the upcoming dirty ring test.

The default test will still be the dirty_log test.  To run the clear
dirty log test, we need to specify "-M clear-log".

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/Makefile          |   2 -
 .../selftests/kvm/clear_dirty_log_test.c      |   2 -
 tools/testing/selftests/kvm/dirty_log_test.c  | 131 +++++++++++++++---
 3 files changed, 110 insertions(+), 25 deletions(-)
 delete mode 100644 tools/testing/selftests/kvm/clear_dirty_log_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests=
/kvm/Makefile
index 3138a916574a..130a7b1c7ad6 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -26,11 +26,9 @@ TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_set_nested_state_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/vmx_tsc_adjust_test
 TEST_GEN_PROGS_x86_64 +=3D x86_64/xss_msr_test
-TEST_GEN_PROGS_x86_64 +=3D clear_dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D dirty_log_test
 TEST_GEN_PROGS_x86_64 +=3D kvm_create_max_vcpus
=20
-TEST_GEN_PROGS_aarch64 +=3D clear_dirty_log_test
 TEST_GEN_PROGS_aarch64 +=3D dirty_log_test
 TEST_GEN_PROGS_aarch64 +=3D kvm_create_max_vcpus
=20
diff --git a/tools/testing/selftests/kvm/clear_dirty_log_test.c b/tools/tes=
ting/selftests/kvm/clear_dirty_log_test.c
deleted file mode 100644
index 749336937d37..000000000000
--- a/tools/testing/selftests/kvm/clear_dirty_log_test.c
+++ /dev/null
@@ -1,2 +0,0 @@
-#define USE_CLEAR_DIRTY_LOG
-#include "dirty_log_test.c"
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/s=
elftests/kvm/dirty_log_test.c
index 3c0ffd34b3b0..a8ae8c0042a8 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -128,6 +128,66 @@ static uint64_t host_dirty_count;
 static uint64_t host_clear_count;
 static uint64_t host_track_next_count;
=20
+enum log_mode_t {
+=09/* Only use KVM_GET_DIRTY_LOG for logging */
+=09LOG_MODE_DIRTY_LOG =3D 0,
+
+=09/* Use both KVM_[GET|CLEAR]_DIRTY_LOG for logging */
+=09LOG_MODE_CLERA_LOG =3D 1,
+
+=09LOG_MODE_NUM,
+};
+
+/* Mode of logging.  Default is LOG_MODE_DIRTY_LOG */
+static enum log_mode_t host_log_mode;
+
+static void clear_log_create_vm_done(struct kvm_vm *vm)
+{
+=09struct kvm_enable_cap cap =3D {};
+
+=09if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2)) {
+=09=09fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, skipping tests\n=
");
+=09=09exit(KSFT_SKIP);
+=09}
+
+=09cap.cap =3D KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
+=09cap.args[0] =3D 1;
+=09vm_enable_cap(vm, &cap);
+}
+
+static void dirty_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+=09=09=09=09=09  void *bitmap, uint32_t num_pages)
+{
+=09kvm_vm_get_dirty_log(vm, slot, bitmap);
+}
+
+static void clear_log_collect_dirty_pages(struct kvm_vm *vm, int slot,
+=09=09=09=09=09  void *bitmap, uint32_t num_pages)
+{
+=09kvm_vm_get_dirty_log(vm, slot, bitmap);
+=09kvm_vm_clear_dirty_log(vm, slot, bitmap, 0, num_pages);
+}
+
+struct log_mode {
+=09const char *name;
+=09/* Hook when the vm creation is done (before vcpu creation) */
+=09void (*create_vm_done)(struct kvm_vm *vm);
+=09/* Hook to collect the dirty pages into the bitmap provided */
+=09void (*collect_dirty_pages) (struct kvm_vm *vm, int slot,
+=09=09=09=09     void *bitmap, uint32_t num_pages);
+} log_modes[LOG_MODE_NUM] =3D {
+=09{
+=09=09.name =3D "dirty-log",
+=09=09.create_vm_done =3D NULL,
+=09=09.collect_dirty_pages =3D dirty_log_collect_dirty_pages,
+=09},
+=09{
+=09=09.name =3D "clear-log",
+=09=09.create_vm_done =3D clear_log_create_vm_done,
+=09=09.collect_dirty_pages =3D clear_log_collect_dirty_pages,
+=09},
+};
+
 /*
  * We use this bitmap to track some pages that should have its dirty
  * bit set in the _next_ iteration.  For example, if we detected the
@@ -137,6 +197,33 @@ static uint64_t host_track_next_count;
  */
 static unsigned long *host_bmap_track;
=20
+static void log_modes_dump(void)
+{
+=09int i;
+
+=09for (i =3D 0; i < LOG_MODE_NUM; i++)
+=09=09printf("%s, ", log_modes[i].name);
+=09puts("\b\b  \b\b");
+}
+
+static void log_mode_create_vm_done(struct kvm_vm *vm)
+{
+=09struct log_mode *mode =3D &log_modes[host_log_mode];
+
+=09if (mode->create_vm_done)
+=09=09mode->create_vm_done(vm);
+}
+
+static void log_mode_collect_dirty_pages(struct kvm_vm *vm, int slot,
+=09=09=09=09=09 void *bitmap, uint32_t num_pages)
+{
+=09struct log_mode *mode =3D &log_modes[host_log_mode];
+
+=09TEST_ASSERT(mode->collect_dirty_pages !=3D NULL,
+=09=09    "collect_dirty_pages() is required for any log mode!");
+=09mode->collect_dirty_pages(vm, slot, bitmap, num_pages);
+}
+
 static void generate_random_array(uint64_t *guest_array, uint64_t size)
 {
 =09uint64_t i;
@@ -257,6 +344,7 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode=
, uint32_t vcpuid,
 #ifdef __x86_64__
 =09vm_create_irqchip(vm);
 #endif
+=09log_mode_create_vm_done(vm);
 =09vm_vcpu_add_default(vm, vcpuid, guest_code);
 =09return vm;
 }
@@ -316,14 +404,6 @@ static void run_test(enum vm_guest_mode mode, unsigned=
 long iterations,
 =09bmap =3D bitmap_alloc(host_num_pages);
 =09host_bmap_track =3D bitmap_alloc(host_num_pages);
=20
-#ifdef USE_CLEAR_DIRTY_LOG
-=09struct kvm_enable_cap cap =3D {};
-
-=09cap.cap =3D KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2;
-=09cap.args[0] =3D 1;
-=09vm_enable_cap(vm, &cap);
-#endif
-
 =09/* Add an extra memory slot for testing dirty logging */
 =09vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
 =09=09=09=09    guest_test_phys_mem,
@@ -364,11 +444,8 @@ static void run_test(enum vm_guest_mode mode, unsigned=
 long iterations,
 =09while (iteration < iterations) {
 =09=09/* Give the vcpu thread some time to dirty some pages */
 =09=09usleep(interval * 1000);
-=09=09kvm_vm_get_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap);
-#ifdef USE_CLEAR_DIRTY_LOG
-=09=09kvm_vm_clear_dirty_log(vm, TEST_MEM_SLOT_INDEX, bmap, 0,
-=09=09=09=09       host_num_pages);
-#endif
+=09=09log_mode_collect_dirty_pages(vm, TEST_MEM_SLOT_INDEX,
+=09=09=09=09=09     bmap, host_num_pages);
 =09=09vm_dirty_log_verify(bmap);
 =09=09iteration++;
 =09=09sync_global_to_guest(vm, iteration);
@@ -413,6 +490,9 @@ static void help(char *name)
 =09       TEST_HOST_LOOP_INTERVAL);
 =09printf(" -p: specify guest physical test memory offset\n"
 =09       "     Warning: a low offset can conflict with the loaded test co=
de.\n");
+=09printf(" -M: specify the host logging mode "
+=09       "(default: log-dirty).  Supported modes: \n\t");
+=09log_modes_dump();
 =09printf(" -m: specify the guest mode ID to test "
 =09       "(default: test all supported modes)\n"
 =09       "     This option may be used multiple times.\n"
@@ -437,13 +517,6 @@ int main(int argc, char *argv[])
 =09unsigned int host_ipa_limit;
 #endif
=20
-#ifdef USE_CLEAR_DIRTY_LOG
-=09if (!kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2)) {
-=09=09fprintf(stderr, "KVM_CLEAR_DIRTY_LOG not available, skipping tests\n=
");
-=09=09exit(KSFT_SKIP);
-=09}
-#endif
-
 #ifdef __x86_64__
 =09vm_guest_mode_params_init(VM_MODE_PXXV48_4K, true, true);
 #endif
@@ -463,7 +536,7 @@ int main(int argc, char *argv[])
 =09vm_guest_mode_params_init(VM_MODE_P40V48_4K, true, true);
 #endif
=20
-=09while ((opt =3D getopt(argc, argv, "hi:I:p:m:")) !=3D -1) {
+=09while ((opt =3D getopt(argc, argv, "hi:I:p:m:M:")) !=3D -1) {
 =09=09switch (opt) {
 =09=09case 'i':
 =09=09=09iterations =3D strtol(optarg, NULL, 10);
@@ -485,6 +558,22 @@ int main(int argc, char *argv[])
 =09=09=09=09    "Guest mode ID %d too big", mode);
 =09=09=09vm_guest_mode_params[mode].enabled =3D true;
 =09=09=09break;
+=09=09case 'M':
+=09=09=09for (i =3D 0; i < LOG_MODE_NUM; i++) {
+=09=09=09=09if (!strcmp(optarg, log_modes[i].name)) {
+=09=09=09=09=09DEBUG("Setting log mode to: '%s'\n",
+=09=09=09=09=09      optarg);
+=09=09=09=09=09host_log_mode =3D i;
+=09=09=09=09=09break;
+=09=09=09=09}
+=09=09=09}
+=09=09=09if (i =3D=3D LOG_MODE_NUM) {
+=09=09=09=09printf("Log mode '%s' is invalid.  "
+=09=09=09=09       "Please choose from: ", optarg);
+=09=09=09=09log_modes_dump();
+=09=09=09=09exit(-1);
+=09=09=09}
+=09=09=09break;
 =09=09case 'h':
 =09=09default:
 =09=09=09help(argv[0]);
--=20
2.21.0

