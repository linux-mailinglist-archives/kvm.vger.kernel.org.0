Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2E7310CB60
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 16:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfK1PJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 10:09:53 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39712 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbfK1PJx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 10:09:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574953791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zfCwKwf1qQnxszU4MATj1+UFG4UOmnvAEgBHepQ9IM4=;
        b=aEfMbS37+RME8R4Xp9eOuxHCbGAjAyhzN3q4HbnjJY3cJKDB8nnFn2Q+6uHj4m8j5eXIdt
        ElleCcorSnpVCEZG4BJKPVSEJHIB3cohOwLl9+nkW4nb1IupwpX8UHykbzA+P1hj+9dibG
        d+l/NUAyU3tKwSIQAyMoQV9VNlr7v/0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-fm-CBMAuPZekwbgiC5X58A-1; Thu, 28 Nov 2019 10:09:48 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A57EC10054E3;
        Thu, 28 Nov 2019 15:09:47 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 754A4608AC;
        Thu, 28 Nov 2019 15:09:46 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     thuth@redhat.com, pbonzini@redhat.com
Subject: [PATCH kvm-unit-tests v2] arm: Enable the VFP
Date:   Thu, 28 Nov 2019 16:09:45 +0100
Message-Id: <20191128150945.3851-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: fm-CBMAuPZekwbgiC5X58A-1
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

Signed-off-by: Andrew Jones <drjones@redhat.com>
---

v2: Added '-mfpu=3Dvfp' cflag to deal with older compilers

CC'ing Thomas because I think he had to workaround travis tests
failing due to this issue once. Maybe travis can now be
un-worked-around?


 arm/Makefile.arm |  2 +-
 arm/cstart.S     | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

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

