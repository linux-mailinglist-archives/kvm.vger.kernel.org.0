Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C232F887C
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 23:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727293AbhAOWbw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 17:31:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727257AbhAOWbv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Jan 2021 17:31:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610749825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IeUvLT/gh534WCxJ77kQH0u+G3n/xrfvtouSuqL1Q5I=;
        b=igG9MrmljaPe7YsQHeI2IpbWS21AkYKVb1EBYYcB6YtnR5gB9O5+wkCVegeX9xhXKzLgI3
        2gf4HQlxQTqkLFnkixetHV8zNYrubT6riVzQ2DtmJdoDEfy+btOGYGxFAw2R1gdZTfFkgX
        xzcy3a2og7a3qaIN4UbnYpvQzHQ+q2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-581-5ngi5WOAPi2P_yvLvNDw3Q-1; Fri, 15 Jan 2021 17:30:22 -0500
X-MC-Unique: 5ngi5WOAPi2P_yvLvNDw3Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A3BF80A5C0
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 22:30:21 +0000 (UTC)
Received: from thuth.com (ovpn-112-32.ams2.redhat.com [10.36.112.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E75C6B8DD;
        Fri, 15 Jan 2021 22:30:20 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: [kvm-unit-tests PATCH] gitlab-ci.yml: Run test with KVM and macOS via cirrus-run
Date:   Fri, 15 Jan 2021 23:30:17 +0100
Message-Id: <20210115223017.271339-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since Travis changed their policy, we soon cannot use it for the
kvm-unit-tests anymore, thus we lose the CI testing with KVM enabled
and the compilation jobs on macOS. Fortunately there is an alternative:
Cirrus-CI also provides containers with KVM enabled and CI jobs with
macOS. Thanks to the so-call "cirrus-run" script, we can even start
the jobs from the gitlab-CI, so we get all the test coverage in the
gitlab-CI again. cirrus-run needs some configuration first, though.
Please refer to the description from libvirt for the details how to
set up your environment for these jobs:

 https://gitlab.com/libvirt/libvirt/-/blob/v7.0.0/ci/README.rst

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml                | 31 +++++++++++++++++
 ci/cirrus-ci-fedora.yml       | 65 +++++++++++++++++++++++++++++++++++
 ci/cirrus-ci-macos-i386.yml   | 36 +++++++++++++++++++
 ci/cirrus-ci-macos-x86-64.yml | 41 ++++++++++++++++++++++
 4 files changed, 173 insertions(+)
 create mode 100644 ci/cirrus-ci-fedora.yml
 create mode 100644 ci/cirrus-ci-macos-i386.yml
 create mode 100644 ci/cirrus-ci-macos-x86-64.yml

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 6613c7b..8834e59 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -122,3 +122,34 @@ build-centos7:
      setjmp sieve tsc rmap_chain umip
      | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
+# Cirrus-CI provides containers with macOS and Linux with KVM enabled,
+# so we can test some scenarios there that are not possible with the
+# gitlab-CI shared runners. We use the "cirrus-run" container from the
+# libvirt project to start the jobs. See the following URL for more
+# information how to set up your environment to use these containers:
+#
+#   https://gitlab.com/libvirt/libvirt/-/blob/v7.0.0/ci/README.rst
+#
+.cirrus_build_job_template: &cirrus_build_job_definition
+ image: registry.gitlab.com/libvirt/libvirt-ci/cirrus-run:master
+ before_script:
+  - sed -e "s|[@]CI_REPOSITORY_URL@|$CI_REPOSITORY_URL|g"
+        -e "s|[@]CI_COMMIT_REF_NAME@|$CI_COMMIT_REF_NAME|g"
+        -e "s|[@]CI_COMMIT_SHA@|$CI_COMMIT_SHA|g"
+        < ci/$CI_JOB_NAME.yml > ci/_$CI_JOB_NAME.yml
+ script:
+  - cirrus-run -v --show-build-log always ci/_$CI_JOB_NAME.yml
+ only:
+  variables:
+   - $CIRRUS_GITHUB_REPO
+   - $CIRRUS_API_TOKEN
+
+cirrus-ci-fedora:
+ <<: *cirrus_build_job_definition
+
+cirrus-ci-macos-i386:
+ <<: *cirrus_build_job_definition
+
+cirrus-ci-macos-x86-64:
+ <<: *cirrus_build_job_definition
diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
new file mode 100644
index 0000000..aba6ae7
--- /dev/null
+++ b/ci/cirrus-ci-fedora.yml
@@ -0,0 +1,65 @@
+
+fedora_task:
+  container:
+    image: fedora:latest
+    cpu: 4
+    memory: 4Gb
+    kvm: true
+  install_script:
+    - dnf update -y
+    - dnf install -y diffutils gcc git make qemu-system-x86
+  clone_script:
+    - git clone --depth 100 "@CI_REPOSITORY_URL@" .
+    - git fetch origin "@CI_COMMIT_REF_NAME@"
+    - git reset --hard "@CI_COMMIT_SHA@"
+  script:
+    - mkdir build
+    - cd build
+    - ../configure
+    - make -j$(nproc)
+    - ./run_tests.sh
+        access
+        asyncpf
+        debug
+        emulator
+        ept
+        hypercall
+        hyperv_clock
+        hyperv_connections
+        hyperv_stimer
+        hyperv_synic
+        idt_test
+        intel_iommu
+        ioapic
+        ioapic-split
+        kvmclock_test
+        msr
+        pcid
+        pcid-disabled
+        rdpru
+        realmode
+        rmap_chain
+        s3
+        setjmp
+        sieve
+        smptest
+        smptest3
+        syscall
+        tsc
+        tsc_adjust
+        tsx-ctrl
+        umip
+        vmexit_cpuid
+        vmexit_inl_pmtimer
+        vmexit_ipi
+        vmexit_ipi_halt
+        vmexit_mov_from_cr8
+        vmexit_mov_to_cr8
+        vmexit_ple_round_robin
+        vmexit_tscdeadline
+        vmexit_tscdeadline_immed
+        vmexit_vmcall
+        vmx_apic_passthrough_thread
+        xsave
+        | tee results.txt
+    - grep -q PASS results.txt && ! grep -q FAIL results.txt
diff --git a/ci/cirrus-ci-macos-i386.yml b/ci/cirrus-ci-macos-i386.yml
new file mode 100644
index 0000000..b837101
--- /dev/null
+++ b/ci/cirrus-ci-macos-i386.yml
@@ -0,0 +1,36 @@
+
+macos_i386_task:
+  osx_instance:
+    image: catalina-base
+  install_script:
+    - brew install coreutils bash git gnu-getopt make qemu i686-elf-gcc
+  clone_script:
+    - git clone --depth 100 "@CI_REPOSITORY_URL@" .
+    - git fetch origin "@CI_COMMIT_REF_NAME@"
+    - git reset --hard "@CI_COMMIT_SHA@"
+  script:
+    - export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
+    - mkdir build
+    - cd build
+    - ../configure --arch=i386 --cross-prefix=i686-elf-
+    - gmake -j$(sysctl -n hw.ncpu)
+    - ACCEL=tcg ./run_tests.sh
+         cmpxchg8b
+         eventinj
+         realmode
+         setjmp
+         sieve
+         taskswitch
+         tsc
+         umip
+         vmexit_cpuid
+         vmexit_inl_pmtimer
+         vmexit_ipi
+         vmexit_ipi_halt
+         vmexit_mov_from_cr8
+         vmexit_mov_to_cr8
+         vmexit_ple_round_robin
+         vmexit_tscdeadline
+         vmexit_tscdeadline_immed
+         | tee results.txt
+    - grep -q PASS results.txt && ! grep -q FAIL results.txt
diff --git a/ci/cirrus-ci-macos-x86-64.yml b/ci/cirrus-ci-macos-x86-64.yml
new file mode 100644
index 0000000..00cc1a2
--- /dev/null
+++ b/ci/cirrus-ci-macos-x86-64.yml
@@ -0,0 +1,41 @@
+
+macos_task:
+  osx_instance:
+    image: catalina-base
+  install_script:
+    - brew install coreutils bash git gnu-getopt make qemu x86_64-elf-gcc
+  clone_script:
+    - git clone --depth 100 "@CI_REPOSITORY_URL@" .
+    - git fetch origin "@CI_COMMIT_REF_NAME@"
+    - git reset --hard "@CI_COMMIT_SHA@"
+  script:
+    - export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
+    - mkdir build
+    - cd build
+    - ../configure --cross-prefix=x86_64-elf-
+    - gmake -j$(sysctl -n hw.ncpu)
+    - ACCEL=tcg ./run_tests.sh
+         eventinj
+         intel_iommu
+         ioapic-split
+         msr
+         realmode 
+         rmap_chain 
+         setjmp
+         sieve 
+         smptest
+         smptest3
+         syscall
+         tsc
+         umip
+         vmexit_cpuid 
+         vmexit_inl_pmtimer 
+         vmexit_ipi 
+         vmexit_ipi_halt 
+         vmexit_mov_from_cr8 
+         vmexit_mov_to_cr8 
+         vmexit_ple_round_robin 
+         vmexit_tscdeadline 
+         vmexit_tscdeadline_immed 
+         | tee results.txt
+    - grep -q PASS results.txt && ! grep -q FAIL results.txt
-- 
2.27.0

