Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65FD351A9D
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbhDASCX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:02:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235986AbhDAR6L (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 13:58:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617299890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MqiD/niNzs8sPdCIMyr36j8rRSsuwo1vckKf82UwdpU=;
        b=EtRR1FaQ7n2jde3ICyjYWn0q3XBhfPUT7Vufza2ukRFZnaaj4VPLeZhP6Y6k4tqu/Vrij7
        bDH0bO+PJz63jnht1dHI7nwDqmJmPrFhjs3oJYr1jEZ0FyEVSuMLpoz85hLbQWkZPgHkSk
        cKwmmyUl49OQJQr4Jsms9ZdYmQPPA+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-ANfHcb41OpqlxX3p4ARpgQ-1; Thu, 01 Apr 2021 09:55:27 -0400
X-MC-Unique: ANfHcb41OpqlxX3p4ARpgQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 128CC1084D94
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 13:55:15 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4131424D
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 13:55:14 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: msr: test vendor-specific behavior for MSR_IA32_SYSENTER_ESP and MSR_IA32_SYSENTER_EIP
Date:   Thu,  1 Apr 2021 09:55:14 -0400
Message-Id: <20210401135514.1095274-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These MSRs are only 32 bits wide on AMD processors, and KVM will emulate
this starting with Linux 5.12.  Add support for this in the msr.flat
test.

Unfortunately QEMU does not have this behavior, so we have to disable the
tests in CI.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .gitlab-ci.yml                |  6 ++--
 ci/cirrus-ci-fedora.yml       |  1 -
 ci/cirrus-ci-macos-x86-64.yml |  1 -
 lib/x86/processor.h           | 20 ++++++++++++
 x86/msr.c                     | 59 +++++++++++++++++++++++++----------
 5 files changed, 65 insertions(+), 22 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index b7c0571..4aebb97 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -74,7 +74,7 @@ build-x86_64:
      ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-     eventinj msr port80 setjmp sieve syscall tsc rmap_chain umip intel_iommu
+     eventinj port80 setjmp sieve syscall tsc rmap_chain umip intel_iommu
      rdpru pku pks smap tsc_adjust xsave
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
@@ -103,7 +103,7 @@ build-clang:
      ioapic-split smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-     eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
+     eventinj port80 setjmp syscall tsc rmap_chain umip intel_iommu
      rdpru pku pks smap tsc_adjust xsave
      | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
@@ -119,7 +119,7 @@ build-centos7:
  - ../configure --arch=x86_64 --disable-pretty-print-stacks
  - make -j2
  - ACCEL=tcg ./run_tests.sh
-     msr vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_inl_pmtimer
+     vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_inl_pmtimer
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed port80
      setjmp sieve tsc rmap_chain umip
      | tee results.txt
diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
index aba6ae7..a6b9cea 100644
--- a/ci/cirrus-ci-fedora.yml
+++ b/ci/cirrus-ci-fedora.yml
@@ -33,7 +33,6 @@ fedora_task:
         ioapic
         ioapic-split
         kvmclock_test
-        msr
         pcid
         pcid-disabled
         rdpru
diff --git a/ci/cirrus-ci-macos-x86-64.yml b/ci/cirrus-ci-macos-x86-64.yml
index dcb8f6d..f72c8e1 100644
--- a/ci/cirrus-ci-macos-x86-64.yml
+++ b/ci/cirrus-ci-macos-x86-64.yml
@@ -18,7 +18,6 @@ macos_task:
          eventinj
          intel_iommu
          ioapic-split
-         msr
          realmode
          rmap_chain
          setjmp
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index dda57a1..aefaa9f 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -174,6 +174,26 @@ static inline u8 cpuid_maxphyaddr(void)
 #define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
 #define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
 
+#define CPUID_VENDOR_AuthenticAMD_ebx 0x68747541
+#define CPUID_VENDOR_AuthenticAMD_ecx 0x444d4163
+#define CPUID_VENDOR_AuthenticAMD_edx 0x69746e65
+
+#define CPUID_VENDOR_AMDisbetterI_ebx 0x69444d41
+#define CPUID_VENDOR_AMDisbetterI_ecx 0x21726574
+#define CPUID_VENDOR_AMDisbetterI_edx 0x74656273
+
+#define CPUID_VENDOR_HygonGenuine_ebx 0x6f677948
+#define CPUID_VENDOR_HygonGenuine_ecx 0x656e6975
+#define CPUID_VENDOR_HygonGenuine_edx 0x6e65476e
+
+#define CPUID_VENDOR_GenuineIntel_ebx 0x756e6547
+#define CPUID_VENDOR_GenuineIntel_ecx 0x6c65746e
+#define CPUID_VENDOR_GenuineIntel_edx 0x49656e69
+
+#define CPUID_VENDOR_CentaurHauls_ebx 0x746e6543
+#define CPUID_VENDOR_CentaurHauls_ecx 0x736c7561
+#define CPUID_VENDOR_CentaurHauls_edx 0x48727561
+
 
 static inline bool this_cpu_has(u64 feature)
 {
diff --git a/x86/msr.c b/x86/msr.c
index ce5dabe..30588d0 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -8,12 +8,14 @@ struct msr_info {
     int index;
     const char *name;
     struct tc {
-        int valid;
+        u8 vendor;
         unsigned long long value;
         unsigned long long expected;
     } val_pairs[20];
 };
 
+#define INTEL 1
+#define AMD 2
 
 #define addr_64 0x0000123456789abcULL
 #define addr_ul (unsigned long)addr_64
@@ -21,42 +23,44 @@ struct msr_info {
 struct msr_info msr_info[] =
 {
     { .index = 0x00000174, .name = "IA32_SYSENTER_CS",
-      .val_pairs = {{ .valid = 1, .value = 0x1234, .expected = 0x1234}}
+      .val_pairs = {{ .vendor = ~0, .value = 0x1234, .expected = 0x1234}}
     },
     { .index = 0x00000175, .name = "MSR_IA32_SYSENTER_ESP",
-      .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
+      .val_pairs = {{ .vendor = INTEL, .value = addr_ul, .expected = addr_ul},
+                    { .vendor = AMD, .value = addr_ul, .expected = 0x56789abc}},
     },
-    { .index = 0x00000176, .name = "IA32_SYSENTER_EIP",
-      .val_pairs = {{ .valid = 1, .value = addr_ul, .expected = addr_ul}}
+    { .index = 0x00000176, .name = "MSR_IA32_SYSENTER_EIP",
+      .val_pairs = {{ .vendor = INTEL, .value = addr_ul, .expected = addr_ul},
+                    { .vendor = AMD, .value = addr_ul, .expected = 0x56789abc}},
     },
     { .index = 0x000001a0, .name = "MSR_IA32_MISC_ENABLE",
       // reserved: 1:2, 4:6, 8:10, 13:15, 17, 19:21, 24:33, 35:63
-      .val_pairs = {{ .valid = 1, .value = 0x400c51889, .expected = 0x400c51889}}
+      .val_pairs = {{ .vendor = ~0, .value = 0x400c51889, .expected = 0x400c51889}}
     },
     { .index = 0x00000277, .name = "MSR_IA32_CR_PAT",
-      .val_pairs = {{ .valid = 1, .value = 0x07070707, .expected = 0x07070707}}
+      .val_pairs = {{ .vendor = ~0, .value = 0x07070707, .expected = 0x07070707}}
     },
     { .index = 0xc0000100, .name = "MSR_FS_BASE",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+      .val_pairs = {{ .vendor = ~0, .value = addr_64, .expected = addr_64}}
     },
     { .index = 0xc0000101, .name = "MSR_GS_BASE",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+      .val_pairs = {{ .vendor = ~0, .value = addr_64, .expected = addr_64}}
     },
     { .index = 0xc0000102, .name = "MSR_KERNEL_GS_BASE",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+      .val_pairs = {{ .vendor = ~0, .value = addr_64, .expected = addr_64}}
     },
 #ifdef __x86_64__
     { .index = 0xc0000080, .name = "MSR_EFER",
-      .val_pairs = {{ .valid = 1, .value = 0xD00, .expected = 0xD00}}
+      .val_pairs = {{ .vendor = ~0, .value = 0xD00, .expected = 0xD00}}
     },
     { .index = 0xc0000082, .name = "MSR_LSTAR",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+      .val_pairs = {{ .vendor = ~0, .value = addr_64, .expected = addr_64}}
     },
     { .index = 0xc0000083, .name = "MSR_CSTAR",
-      .val_pairs = {{ .valid = 1, .value = addr_64, .expected = addr_64}}
+      .val_pairs = {{ .vendor = ~0, .value = addr_64, .expected = addr_64}}
     },
     { .index = 0xc0000084, .name = "MSR_SYSCALL_MASK",
-      .val_pairs = {{ .valid = 1, .value = 0xffffffff, .expected = 0xffffffff}}
+      .val_pairs = {{ .vendor = ~0, .value = 0xffffffff, .expected = 0xffffffff}}
     },
 #endif
 
@@ -99,12 +103,33 @@ static void test_msr_rw(int msr_index, unsigned long long input, unsigned long l
 int main(int ac, char **av)
 {
     int i, j;
+    int vendor = 0;
+    struct cpuid cpuid0 = cpuid(0);
+
+    if (cpuid0.b == CPUID_VENDOR_GenuineIntel_ebx &&
+        cpuid0.c == CPUID_VENDOR_GenuineIntel_ecx &&
+        cpuid0.d == CPUID_VENDOR_GenuineIntel_edx)
+        vendor = INTEL;
+
+    else if (cpuid0.b == CPUID_VENDOR_AuthenticAMD_ebx &&
+             cpuid0.c == CPUID_VENDOR_AuthenticAMD_ecx &&
+             cpuid0.d == CPUID_VENDOR_AuthenticAMD_edx)
+        vendor = AMD;
+
+    else if (cpuid0.b == CPUID_VENDOR_AMDisbetterI_ebx &&
+             cpuid0.c == CPUID_VENDOR_AMDisbetterI_ecx &&
+             cpuid0.d == CPUID_VENDOR_AMDisbetterI_edx)
+        vendor = AMD;
+
+    else if (cpuid0.b == CPUID_VENDOR_HygonGenuine_ebx &&
+             cpuid0.c == CPUID_VENDOR_HygonGenuine_ecx &&
+             cpuid0.d == CPUID_VENDOR_HygonGenuine_edx)
+        vendor = AMD;
+
     for (i = 0 ; i < sizeof(msr_info) / sizeof(msr_info[0]); i++) {
         for (j = 0; j < sizeof(msr_info[i].val_pairs) / sizeof(msr_info[i].val_pairs[0]); j++) {
-            if (msr_info[i].val_pairs[j].valid) {
+            if (msr_info[i].val_pairs[j].vendor & vendor) {
                 test_msr_rw(msr_info[i].index, msr_info[i].val_pairs[j].value, msr_info[i].val_pairs[j].expected);
-            } else {
-                break;
             }
         }
     }
-- 
2.26.2

