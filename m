Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2C010CBF9
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 16:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfK1Pn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 10:43:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbfK1Pn7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 10:43:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574955837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vz34xy23I34V6t61KJptUN9zqdocHEiTDJU+6y5GpJM=;
        b=ONHGFhVCx4xF9AeqmfSViXdv3hl5ot8kKhXJ/0FUEhd7+LPqR+jm7g+wlwB2ptGYyEsYqR
        jt6ro5nCrOFINHu3z1rIqFX4+5tbK1xjm5bTu9thbujfdfiiS3fLqBOIqLJZfRefqWOCU2
        ZIV4MdOgXZb1jBIrNIiVfQHj5idHIFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-gZADEEkKO2aoopNos3i5XQ-1; Thu, 28 Nov 2019 10:43:54 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4997C107B7E8;
        Thu, 28 Nov 2019 15:43:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B18E600CD;
        Thu, 28 Nov 2019 15:43:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     thuth@redhat.com, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests v3] arm: Enable the VFP
Date:   Thu, 28 Nov 2019 16:43:50 +0100
Message-Id: <20191128154350.9650-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: gZADEEkKO2aoopNos3i5XQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Variable argument macros frequently depend on floating point
registers. Indeed we needed to enable the VFP for arm64 since its
introduction in order to use printf and the like. Somehow we
didn't need to do that for arm32 until recently when compiling
with GCC 9.

Tested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---

v3: Added Thomas' t-b and suggested .gitlab-ci.yml change.
v2: Added '-mfpu=3Dvfp' cflag to deal with older compilers

 .gitlab-ci.yml   |  2 +-
 arm/Makefile.arm |  2 +-
 arm/cstart.S     | 14 +++++++++++++-
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index fbf3328a19ea..a9dc16a2d6fd 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -17,7 +17,7 @@ build-aarch64:
=20
 build-arm:
  script:
- - dnf install -y qemu-system-arm gcc-arm-linux-gnu-8.2.1-1.fc30.2
+ - dnf install -y qemu-system-arm gcc-arm-linux-gnu
  - ./configure --arch=3Darm --cross-prefix=3Darm-linux-gnu-
  - make -j2
  - ACCEL=3Dtcg ./run_tests.sh
diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 43b4be1e05ee..d379a2800749 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -5,7 +5,7 @@
 #
 bits =3D 32
 ldarch =3D elf32-littlearm
-machine =3D -marm
+machine =3D -marm -mfpu=3Dvfp
=20
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER :=3D y
diff --git a/arm/cstart.S b/arm/cstart.S
index 114726feab82..bc6219d8a3ee 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -50,10 +50,11 @@ start:
 =09mov=09r0, r2
 =09push=09{r0-r1}
=20
-=09/* set up vector table and mode stacks */
+=09/* set up vector table, mode stacks, and enable the VFP */
 =09mov=09r0, lr=09=09=09@ lr is stack top (see above),
 =09=09=09=09=09@ which is the exception stacks base
 =09bl=09exceptions_init
+=09bl=09enable_vfp
=20
 =09/* complete setup */
 =09pop=09{r0-r1}
@@ -100,6 +101,16 @@ exceptions_init:
 =09isb
 =09mov=09pc, lr
=20
+enable_vfp:
+=09/* Enable full access to CP10 and CP11: */
+=09mov=09r0, #(3 << 22 | 3 << 20)
+=09mcr=09p15, 0, r0, c1, c0, 2
+=09isb
+=09/* Set the FPEXC.EN bit to enable Advanced SIMD and VFP: */
+=09mov=09r0, #(1 << 30)
+=09vmsr=09fpexc, r0
+=09mov=09pc, lr
+
 .text
=20
 .global get_mmu_off
@@ -130,6 +141,7 @@ secondary_entry:
 =09ldr=09r0, [r1]
 =09mov=09sp, r0
 =09bl=09exceptions_init
+=09bl=09enable_vfp
=20
 =09/* finish init in C code */
 =09bl=09secondary_cinit
--=20
2.21.0

