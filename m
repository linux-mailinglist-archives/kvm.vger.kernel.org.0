Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04408FB691
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 18:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKMRsu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 12:48:50 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:32392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbfKMRst (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Nov 2019 12:48:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573667328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DqDxQKf1L8BXZYWjyfeQ7+2ppmpxNqc2YxrLPzA1JJ4=;
        b=F2s3c7oLQHlkR8HYojmrDTcspNhouauwUJ6dbfZBb4CPSvYCNk51YT3UpR68kOGaQZ3Oah
        aRB8AKMyDfTGK4OidMxlt36Oy8arfVK76xilEXwLneGGNoSHyRhRvyW5f1nebAYPgGCWpG
        fCCgzb1odqYB+o1mG27whxhUjjr6yzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-82-pnp35ybBPzO5UVgfncamIg-1; Wed, 13 Nov 2019 12:48:47 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D2268048EC;
        Wed, 13 Nov 2019 17:48:46 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5754B10374B9;
        Wed, 13 Nov 2019 17:48:45 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v2] travis.yml: Test with KVM instead of TCG (on x86)
Date:   Wed, 13 Nov 2019 18:48:42 +0100
Message-Id: <20191113174842.20759-1-thuth@redhat.com>
In-Reply-To: <e7246b2d-e76a-1302-513b-30cbfacdd4c6@redhat.com>
References: <e7246b2d-e76a-1302-513b-30cbfacdd4c6@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: pnp35ybBPzO5UVgfncamIg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Travis nowadays supports KVM in their CI pipelines, so we can finally
run the kvm-unit-tests with KVM instead of TCG here. Unfortunately, there
are some quirks:

First, /dev/kvm is not accessible on Ubuntu by default. You have to be
"root" or in the "kvm" group to access it. But changing the group of the
current user is not taking into account for the current shell process, so
that would need some indirections in the yml file. Thus the yml script now
rather changes the group and "g+s" permission of the qemu binary instead.

Second, not all x86 tests are working in this environment, so we still
have to manually select the test set here (but the amount of tests is
definitely higher now than what we were able to run with TCG before).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 v2: Use chgrp + "chmod g+s" instead "chmod u+s" to get it running

 .travis.yml | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 3f5b5ee..89c50fe 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -1,4 +1,4 @@
-sudo: false
+sudo: true
 dist: bionic
 language: c
 cache: ccache
@@ -13,16 +13,21 @@ matrix:
       env:
       - CONFIG=3D""
       - BUILD_DIR=3D"."
-      - TESTS=3D"vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit=
_ipi
-             vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_=
immed"
+      - TESTS=3D"access asyncpf debug emulator ept hypercall hyperv_stimer
+               hyperv_synic idt_test intel_iommu ioapic ioapic-split
+               kvmclock_test msr pcid rdpru realmode rmap_chain s3 umip"
+      - ACCEL=3D"kvm"
=20
     - addons:
         apt_packages: gcc qemu-system-x86
       env:
       - CONFIG=3D""
       - BUILD_DIR=3D"x86-builddir"
-      - TESTS=3D"ioapic-split ioapic smptest smptest3 eventinj msr port80 =
syscall
-             tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_ipi=
_halt"
+      - TESTS=3D"smptest smptest3 tsc tsc_adjust xsave vmexit_cpuid vmexit=
_vmcall
+               sieve vmexit_inl_pmtimer vmexit_ipi_halt vmexit_mov_from_cr=
8
+               vmexit_mov_to_cr8 vmexit_ple_round_robin vmexit_tscdeadline
+               vmexit_tscdeadline_immed  vmx_apic_passthrough_thread sysca=
ll"
+      - ACCEL=3D"kvm"
=20
     - addons:
         apt_packages: gcc-arm-linux-gnueabihf qemu-system-arm
@@ -85,6 +90,10 @@ matrix:
       - ACCEL=3D"tcg,firmware=3Ds390x/run"
=20
 before_script:
+  - if [ "$ACCEL" =3D "kvm" ]; then
+      sudo chgrp kvm /usr/bin/qemu-system-* ;
+      sudo chmod g+s /usr/bin/qemu-system-* ;
+    fi
   - mkdir -p $BUILD_DIR && cd $BUILD_DIR
   - if [ -e ./configure ]; then ./configure $CONFIG ; fi
   - if [ -e ../configure ]; then ../configure $CONFIG ; fi
--=20
2.23.0

