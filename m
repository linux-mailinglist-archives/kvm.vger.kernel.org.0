Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05F4D11A7A3
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 10:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfLKJme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 04:42:34 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42081 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728659AbfLKJmd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 04:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576057352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1LhOOoPGKMazwl4OGuPMhW4iUHPzm/SjdLULhvaPxsU=;
        b=fHmQQedxjEmGEPAqLo5NEXB3dtcZeGi79PtjwdT9ZQA6DWcx8j7JlZrfQEHQVnS1BwxAPQ
        Mxw2/gTJkwpb8tZbBTY3MipMI2U/evGgvBAtG4tqbGKVY1pftWdIWKV6MLLtDwGR01yLQZ
        sKIBFSu4lCal03zndhNiRj5vjJjfnPw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-rbJwqoaYNfuhaHaeqpbiMw-1; Wed, 11 Dec 2019 04:42:31 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C7238024D6
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 09:42:30 +0000 (UTC)
Received: from thuth.com (ovpn-117-11.ams2.redhat.com [10.36.117.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40D406364A;
        Wed, 11 Dec 2019 09:42:29 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 3/4] x86: Add the setjmp test to the CI
Date:   Wed, 11 Dec 2019 10:42:20 +0100
Message-Id: <20191211094221.7030-4-thuth@redhat.com>
In-Reply-To: <20191211094221.7030-1-thuth@redhat.com>
References: <20191211094221.7030-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: rbJwqoaYNfuhaHaeqpbiMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a proper report() in the test instead of printf(), and add
it to the unittests.cfg and the CI yaml files.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 .gitlab-ci.yml    | 4 ++--
 .travis.yml       | 4 ++--
 x86/setjmp.c      | 8 +++-----
 x86/unittests.cfg | 3 +++
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index fbf3328..ea1aeaf 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -67,7 +67,7 @@ build-x86_64:
      ioapic-split ioapic smptest smptest3 vmexit_cpuid vmexit_mov_from_cr8
      vmexit_mov_to_cr8 vmexit_inl_pmtimer  vmexit_ipi vmexit_ipi_halt
      vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed
-     eventinj msr port80 syscall tsc rmap_chain umip intel_iommu
+     eventinj msr port80 setjmp syscall tsc rmap_chain umip intel_iommu
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
=20
@@ -77,6 +77,6 @@ build-i386:
  - ./configure --arch=3Di386
  - make -j2
  - ACCEL=3Dtcg ./run_tests.sh
-     eventinj port80 sieve tsc taskswitch taskswitch2 umip
+     eventinj port80 setjmp sieve tsc taskswitch taskswitch2 umip
      | tee results.txt
  - if grep -q FAIL results.txt ; then exit 1 ; fi
diff --git a/.travis.yml b/.travis.yml
index 75bcf08..53f8d7d 100644
--- a/.travis.yml
+++ b/.travis.yml
@@ -15,7 +15,7 @@ matrix:
       - BUILD_DIR=3D"."
       - TESTS=3D"access asyncpf debug emulator ept hypercall hyperv_stimer
                hyperv_synic idt_test intel_iommu ioapic ioapic-split
-               kvmclock_test msr pcid rdpru realmode rmap_chain s3 umip"
+               kvmclock_test msr pcid rdpru realmode rmap_chain s3 setjmp =
umip"
       - ACCEL=3D"kvm"
=20
     - addons:
@@ -45,7 +45,7 @@ matrix:
       - BUILD_DIR=3D"i386-builddir"
       - TESTS=3D"tsx-ctrl umip vmexit_cpuid vmexit_ipi vmexit_ipi_halt
                vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ple_round_robi=
n
-               vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall"
+               vmexit_tscdeadline vmexit_tscdeadline_immed vmexit_vmcall s=
etjmp"
       - ACCEL=3D"kvm"
=20
     - addons:
diff --git a/x86/setjmp.c b/x86/setjmp.c
index 1a848b4..cc411cd 100644
--- a/x86/setjmp.c
+++ b/x86/setjmp.c
@@ -14,13 +14,11 @@ int main(void)
 =09int i;
=20
 =09i =3D setjmp(j);
-=09if (expected[index] !=3D i) {
-=09=09printf("FAIL: actual %d / expected %d\n", i, expected[index]);
-=09=09return -1;
-=09}
+=09report(expected[index] =3D=3D i, "actual %d =3D=3D expected %d",
+=09       i, expected[index]);
 =09index++;
 =09if (i + 1 < NUM_LONGJMPS)
 =09=09longjmp(j, i + 1);
=20
-=09return 0;
+=09return report_summary();
 }
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index e99b086..acdde10 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -171,6 +171,9 @@ file =3D realmode.flat
 [s3]
 file =3D s3.flat
=20
+[setjmp]
+file =3D setjmp.flat
+
 [sieve]
 file =3D sieve.flat
 timeout =3D 180
--=20
2.18.1

