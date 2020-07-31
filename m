Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08A0234377
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732321AbgGaJls (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:41:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732254AbgGaJlr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 05:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596188506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=mm93qNh+ID2OyqVFv1UMGbBnIBgXVDHzsRua4uEmitY=;
        b=TQVIJsqpHdBkopzkNnUq/OOFUp+KwAA5C0h7alUvBslpZC9qK82u+OOn8n/sFTaenG+WMa
        S1uJKVK5P4wPfO2SQx0Dxf3lX2/vmqXFzvfDKuHFJkC3yH9Ty/t7UHbjs4nnlkgXQosf+z
        uD8wE6ntc7qDIdbTasu6fcglhfqYSog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-Ee8dEfQ6NU2QEKvD_QxoXQ-1; Fri, 31 Jul 2020 05:41:43 -0400
X-MC-Unique: Ee8dEfQ6NU2QEKvD_QxoXQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3371107ACCA
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 09:41:42 +0000 (UTC)
Received: from thuth.com (ovpn-112-153.ams2.redhat.com [10.36.112.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B671C1A835;
        Fri, 31 Jul 2020 09:41:41 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH] gitlab-ci.yml: Compile some jobs out-of-tree
Date:   Fri, 31 Jul 2020 11:41:39 +0200
Message-Id: <20200731094139.9364-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So far we only compiled all jobs in-tree in the gitlab-CI. For the code
that gets compiled twice (one time for 64-bit and one time for 32-bit
for example), we can easily move one of the two jobs to out-of-tree build
mode to increase the build test coverage a little bit.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index 1ec9797..6613c7b 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -19,7 +19,9 @@ build-aarch64:
 build-arm:
  script:
  - dnf install -y qemu-system-arm gcc-arm-linux-gnu
- - ./configure --arch=arm --cross-prefix=arm-linux-gnu-
+ - mkdir build
+ - cd build
+ - ../configure --arch=arm --cross-prefix=arm-linux-gnu-
  - make -j2
  - ACCEL=tcg MAX_SMP=8 ./run_tests.sh
      selftest-setup selftest-vectors-kernel selftest-vectors-user selftest-smp
@@ -31,7 +33,9 @@ build-arm:
 build-ppc64be:
  script:
  - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
- - ./configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
+ - mkdir build
+ - cd build
+ - ../configure --arch=ppc64 --endian=big --cross-prefix=powerpc64-linux-gnu-
  - make -j2
  - ACCEL=tcg ./run_tests.sh
      selftest-setup spapr_hcall rtas-get-time-of-day rtas-get-time-of-day-base
@@ -77,7 +81,9 @@ build-x86_64:
 build-i386:
  script:
  - dnf install -y qemu-system-x86 gcc
- - ./configure --arch=i386
+ - mkdir build
+ - cd build
+ - ../configure --arch=i386
  - make -j2
  - ACCEL=tcg ./run_tests.sh
      cmpxchg8b vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8
-- 
2.18.1

