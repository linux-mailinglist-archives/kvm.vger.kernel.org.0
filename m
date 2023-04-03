Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFCA56D40AB
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 11:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDCJd7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 05:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbjDCJdv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 05:33:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670804C38
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 02:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680514382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R9bvhW0T9vZH/N8G0NdZuEtSqDdDZcgyH28wEDCMfc0=;
        b=Ads5LFUzXGaEa+ll9dQNiz08xXcccvtxm4MvBEevMJr2HKiMkg68aThSaKJoeYX6MKBc+Q
        h07t+2D8s+Pe8sZjYQG4nsDkSAoqUSs4VxjOGBVz5Ab/BWDxdiqYVrqEoGzB2l3RGnggMV
        g4PEANqlgQlkwaCEapVCCnTvdPGyh7o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-wqfhj8fxMXal1vSIN1kQAA-1; Mon, 03 Apr 2023 05:32:59 -0400
X-MC-Unique: wqfhj8fxMXal1vSIN1kQAA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC011101A531;
        Mon,  3 Apr 2023 09:32:58 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9441DC15BBA;
        Mon,  3 Apr 2023 09:32:57 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH] ci: Provide the logs as artifacts
Date:   Mon,  3 Apr 2023 11:32:55 +0200
Message-Id: <20230403093255.45104-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If something goes wrong, it's good to have a way to see where it failed,
so let's provide the logs as artifacts.

While we're at it, also dump /proc/cpuinfo in the Fedora KVM job
as this might contain valuable information about the KVM environment.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml                | 22 ++++++++++++++++++++++
 ci/cirrus-ci-fedora.yml       |  6 ++++++
 ci/cirrus-ci-macos-i386.yml   |  4 ++++
 ci/cirrus-ci-macos-x86-64.yml |  4 ++++
 4 files changed, 36 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index ad7949c9..59a3d3c8 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -4,7 +4,20 @@ before_script:
  - dnf update -y
  - dnf install -y make python
 
+.intree_template:
+ artifacts:
+  expire_in: 2 days
+  paths:
+   - logs
+
+.outoftree_template:
+ artifacts:
+  expire_in: 2 days
+  paths:
+   - build/logs
+
 build-aarch64:
+ extends: .intree_template
  script:
  - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu
  - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
@@ -35,6 +48,7 @@ build-aarch64:
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-arm:
+ extends: .outoftree_template
  script:
  - dnf install -y qemu-system-arm gcc-arm-linux-gnu
  - mkdir build
@@ -49,6 +63,7 @@ build-arm:
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-ppc64be:
+ extends: .outoftree_template
  script:
  - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
  - mkdir build
@@ -62,6 +77,7 @@ build-ppc64be:
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-ppc64le:
+ extends: .intree_template
  script:
  - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
  - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
@@ -73,6 +89,7 @@ build-ppc64le:
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-s390x:
+ extends: .outoftree_template
  script:
  - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
  - mkdir build
@@ -109,6 +126,7 @@ build-s390x:
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-x86_64:
+ extends: .intree_template
  script:
  - dnf install -y qemu-system-x86 gcc
  - ./configure --arch=x86_64
@@ -147,6 +165,7 @@ build-x86_64:
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-i386:
+ extends: .outoftree_template
  script:
  - dnf install -y qemu-system-x86 gcc
  - mkdir build
@@ -180,6 +199,7 @@ build-i386:
  - if grep -q FAIL results.txt ; then exit 1 ; fi
 
 build-clang:
+ extends: .intree_template
  script:
  - dnf install -y qemu-system-x86 clang
  - ./configure --arch=x86_64 --cc=clang
@@ -218,6 +238,7 @@ build-clang:
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
 
 build-centos7:
+ extends: .outoftree_template
  image: centos:7
  before_script:
  - yum update -y
@@ -266,6 +287,7 @@ cirrus-ci-macos-x86-64:
  <<: *cirrus_build_job_definition
 
 s390x-kvm:
+ extends: .intree_template
  before_script: []
  tags:
   - s390x-z15-vm
diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
index d6070f70..918c9a36 100644
--- a/ci/cirrus-ci-fedora.yml
+++ b/ci/cirrus-ci-fedora.yml
@@ -13,6 +13,8 @@ fedora_task:
     - git fetch origin "@CI_COMMIT_REF_NAME@"
     - git reset --hard "@CI_COMMIT_SHA@"
   script:
+    - uname -r
+    - sed -n "/processor.*:.0/,/^$/p" /proc/cpuinfo
     - mkdir build
     - cd build
     - ../configure
@@ -70,3 +72,7 @@ fedora_task:
         xsave
         | tee results.txt
     - grep -q PASS results.txt && ! grep -q FAIL results.txt
+  on_failure:
+    log_artifacts:
+      path: build/logs/*.log
+      type: text/plain
diff --git a/ci/cirrus-ci-macos-i386.yml b/ci/cirrus-ci-macos-i386.yml
index ed580e61..45d1b716 100644
--- a/ci/cirrus-ci-macos-i386.yml
+++ b/ci/cirrus-ci-macos-i386.yml
@@ -35,3 +35,7 @@ macos_i386_task:
          vmexit_tscdeadline_immed
          | tee results.txt
     - grep -q PASS results.txt && ! grep -q FAIL results.txt
+  on_failure:
+    log_artifacts:
+      path: build/logs/*.log
+      type: text/plain
diff --git a/ci/cirrus-ci-macos-x86-64.yml b/ci/cirrus-ci-macos-x86-64.yml
index 861caa16..8ee6fb7e 100644
--- a/ci/cirrus-ci-macos-x86-64.yml
+++ b/ci/cirrus-ci-macos-x86-64.yml
@@ -39,3 +39,7 @@ macos_task:
          vmexit_tscdeadline_immed
          | tee results.txt
     - grep -q PASS results.txt && ! grep -q FAIL results.txt
+  on_failure:
+    log_artifacts:
+      path: build/logs/*.log
+      type: text/plain
-- 
2.31.1

