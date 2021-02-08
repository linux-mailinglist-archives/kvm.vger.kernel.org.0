Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFD1B313612
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 16:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhBHPFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 10:05:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32783 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232363AbhBHPEQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 10:04:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612796557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=U4vE6QO9gJ7FHiO0oK3chDBjSo4heyDGI9neiMKhD6U=;
        b=QkeUgdFzg8sNhWR02rnc3KqzlerqLOZ1mW/r6VAOzIm+dV4kadqPxJIWei8806G0iAG3f+
        IUmLEFiS/lBWdSyad2wxJunidsy6qMlkmSHn6IGZxhAAfmswCeIhEgaxVVeKOeVf6Azr98
        cF/rDQ9/ILBNOkIUSGPsjSt3me6FjaE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-p9TqOEBLPSK4Az4vTLNDVw-1; Mon, 08 Feb 2021 10:02:34 -0500
X-MC-Unique: p9TqOEBLPSK4Az4vTLNDVw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FDA18030CD
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 15:02:33 +0000 (UTC)
Received: from mbandeir.redhat.com (ovpn-116-15.gru2.redhat.com [10.97.116.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37E825D9E4;
        Mon,  8 Feb 2021 15:02:28 +0000 (UTC)
From:   Marcelo Bandeira Condotta <mbandeir@redhat.com>
To:     pbonzini@redhat.com, thuth@redhat.com, kvm@vger.kernel.org
Cc:     Marcelo Bandeira Condotta <mcondotta@redhat.com>
Subject: [kvm-unit-tests PATCH] gitlab-ci.yml: Add new s390x targets to run tests with TCG and KVM accel
Date:   Mon,  8 Feb 2021 12:02:27 -0300
Message-Id: <20210208150227.178953-1-mbandeir@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marcelo Bandeira Condotta <mcondotta@redhat.com>

A new s390x z15 VM provided by IBM Community Cloud will be used to run
the s390x KVM Unit tests natively with both TCG and KVM accel options.

Signed-off-by: Marcelo Bandeira Condotta <mbandeir@redhat.com>
---
 .gitlab-ci.yml | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index d97e27e..bc7a115 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -155,3 +155,31 @@ cirrus-ci-macos-i386:
 
 cirrus-ci-macos-x86-64:
  <<: *cirrus_build_job_definition
+
+test-s390x-tcg:
+  stage: test
+  before_script: []
+  tags:
+    - s390x-z15-vm
+  script:
+    - ./configure --arch=s390x
+    - make -j2
+    - ACCEL=tcg ./run_tests.sh
+     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
+     stsi sclp-1g sclp-3g
+     | tee results.txt
+    - if grep -q FAIL results.txt ; then exit 1 ; fi
+
+test-s390x-kvm:
+  stage: test
+  before_script: []
+  tags:
+    - s390x-z15-vm
+  script:
+    - ./configure --arch=s390x
+    - make -j2
+    - ACCEL=kvm ./run_tests.sh
+     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
+     stsi sclp-1g sclp-3g
+     | tee results.txt
+    - if grep -q FAIL results.txt ; then exit 1 ; fi
-- 
2.26.2

