Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4661C10021D
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 11:08:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfKRKId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Nov 2019 05:08:33 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52566 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726922AbfKRKIc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Nov 2019 05:08:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574071711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aq+jdGNHAVTsKPtuya3iDlxhCgoEdRjl8mf9wNUuL2M=;
        b=fDJ+NLuzO9thB8xJFw+XGL74gWC1/zwB9g2V405vmNHD1TEYWtCAG8F47Se3Uf8KC111C5
        8NEwW1RTJkbq4wsZw9hy+JGnhsTbx4zRVj+YuTBQ0KrSmaGuNfMefeygyGRSAmY/2T8BP5
        VsC08frkkAQX35mV7rN6x+UcILNBdqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-1RIWPw8-Nf2mbWQjl9Ig3g-1; Mon, 18 Nov 2019 05:08:30 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5200F107ACCC;
        Mon, 18 Nov 2019 10:08:29 +0000 (UTC)
Received: from t460s.redhat.com (unknown [10.36.118.85])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97CBF66856;
        Mon, 18 Nov 2019 10:08:27 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [kvm-unit-tests PULL 10/12] travis.yml: Test with KVM instead of TCG (on x86)
Date:   Mon, 18 Nov 2019 11:07:17 +0100
Message-Id: <20191118100719.7968-11-david@redhat.com>
In-Reply-To: <20191118100719.7968-1-david@redhat.com>
References: <20191118100719.7968-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: 1RIWPw8-Nf2mbWQjl9Ig3g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Huth <thuth@redhat.com>

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
Message-Id: <20191113174842.20759-1-thuth@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
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
2.21.0

