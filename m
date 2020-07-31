Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD3323422C
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 11:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgGaJP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 05:15:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:35950 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731966AbgGaJP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 05:15:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596186955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=l2ZtpK/CPsR5J0CY/66IZxCzTKywXLo4B8SE15nW9hM=;
        b=AIc6u9MAa30ubrKhm8abcttFip6qx+cAR4S6h8ijxn2Kd1RqJpuBEFbgPByAhoCKEmIPh4
        +fMPfptMp24xg533c1ohitWhZuaxR5J0UpoW+MSLlN8l5+OCJcjU2B1mV1SWOAvzeENBmt
        pkYPGzWVbZ7vEoJXHyCfmuZi4xUOW2M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-ntleCtAfOlKL_Qfk-fOQHw-1; Fri, 31 Jul 2020 05:15:52 -0400
X-MC-Unique: ntleCtAfOlKL_Qfk-fOQHw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 43F6E18C63C0
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 09:15:51 +0000 (UTC)
Received: from thuth.com (ovpn-112-153.ams2.redhat.com [10.36.112.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5108310013C4;
        Fri, 31 Jul 2020 09:15:50 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com
Subject: [kvm-unit-tests PATCH] gitlab-ci.yml: Test build on CentOS 7
Date:   Fri, 31 Jul 2020 11:15:48 +0200
Message-Id: <20200731091548.8302-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We should also test our build with older versions of Bash and Gcc (at
least the versions which we still want to support). CentOS 7 should be
a reasonable base for such tests.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index d042cde..1ec9797 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -99,3 +99,20 @@ build-clang:
      eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
      | tee results.txt
  - grep -q PASS results.txt && ! grep -q FAIL results.txt
+
+build-centos7:
+ image: centos:7
+ before_script:
+ - yum update -y
+ - yum install -y make python qemu-kvm gcc
+ script:
+ - mkdir build
+ - cd build
+ - ../configure --arch=x86_64 --disable-pretty-print-stacks
+ - make -j2
+ - ACCEL=tcg ./run_tests.sh
+     msr vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_inl_pmtimer
+     vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed port80
+     setjmp sieve tsc rmap_chain umip
+     | tee results.txt
+ - grep -q PASS results.txt && ! grep -q FAIL results.txt
-- 
2.18.1

