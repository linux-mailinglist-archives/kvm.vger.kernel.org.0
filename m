Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC97FAFA9
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 12:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727934AbfKML1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 06:27:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27666 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727899AbfKML1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 06:27:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573644424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKfM7POce08IlNCxkWT06hdP5LlFwW/k4TsFFSaQwPk=;
        b=Rck1Oqe4gzBEWyxuEaJ17Fkdg2CkkM8ztZyXnXBrqIN1XBuHGjW3N5Dsba1XDS/uDhRe6y
        /zYKcbahQeP8crD9+tQJMYUk3sfwsl1YSTpjs+hB8BYFqgj5qw6y98pFhSrwwSDV0lS52H
        4dAEnhCCvqelERqECuwdMgBCEUx6t78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-sDRYjPyTMRqVidPiRwKaRg-1; Wed, 13 Nov 2019 06:27:03 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3064D803CE7;
        Wed, 13 Nov 2019 11:27:02 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B25660464;
        Wed, 13 Nov 2019 11:27:00 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-test PATCH 3/5] travis.yml: Test with KVM instead of TCG (on x86)
Date:   Wed, 13 Nov 2019 12:26:47 +0100
Message-Id: <20191113112649.14322-4-thuth@redhat.com>
In-Reply-To: <20191113112649.14322-1-thuth@redhat.com>
References: <20191113112649.14322-1-thuth@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: sDRYjPyTMRqVidPiRwKaRg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Travis nowadays supports KVM in their CI pipelines, so we can finally
run the kvm-unit-tests with KVM instead of TCG here. Unfortunately, there
are some quirks: First, the QEMU binary has to be running as root, otherwis=
e
you get an "permission denied" error here - even if you fix up the access
permissions to /dev/kvm first. Second, not all x86 tests are working in
this environment, so we still have to manually select the test set here
(but the amount of tests is definitely higher now than what we were able
to run with TCG before).

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .travis.yml | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/.travis.yml b/.travis.yml
index 3f5b5ee..f91118c 100644
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
@@ -85,6 +90,9 @@ matrix:
       - ACCEL=3D"tcg,firmware=3Ds390x/run"
=20
 before_script:
+  - if [ "$ACCEL" =3D "kvm" ]; then
+      sudo chmod u+s /usr/bin/qemu-system-* ;
+    fi
   - mkdir -p $BUILD_DIR && cd $BUILD_DIR
   - if [ -e ./configure ]; then ./configure $CONFIG ; fi
   - if [ -e ../configure ]; then ../configure $CONFIG ; fi
--=20
2.23.0

