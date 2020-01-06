Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1EF130FE0
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 11:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgAFKD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 05:03:56 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28017 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726155AbgAFKDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 05:03:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578305034;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3smR9uG6pdk/rEmUuZ4iR/HJrt2gkG7IJPNUbTHoJIw=;
        b=FxV6SUEHeTD+L2tnfI8j/A8xtWA75U2rTXwmAG/hqsMW/Bh0A/uRXEp9TAlYgYGBeoKcii
        UlyaTqGpCWhMSsod8YsVQ/kMYNeOVV58Q3o/wuHCTcbPDu3NiInTyJFsp1kjqNp1+rOIu1
        hYkGf/AuovE04RuUzHK+X+P9Ga6DeWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-ybhVirw5MB2oNssStDJUGw-1; Mon, 06 Jan 2020 05:03:53 -0500
X-MC-Unique: ybhVirw5MB2oNssStDJUGw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 666B810054E3
        for <kvm@vger.kernel.org>; Mon,  6 Jan 2020 10:03:52 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6412163BCA;
        Mon,  6 Jan 2020 10:03:51 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Thomas Huth <thuth@redhat.com>
Subject: [PULL kvm-unit-tests 02/17] arm: Enable the VFP
Date:   Mon,  6 Jan 2020 11:03:32 +0100
Message-Id: <20200106100347.1559-3-drjones@redhat.com>
In-Reply-To: <20200106100347.1559-1-drjones@redhat.com>
References: <20200106100347.1559-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
 	mov	r0, r2
 	push	{r0-r1}
=20
-	/* set up vector table and mode stacks */
+	/* set up vector table, mode stacks, and enable the VFP */
 	mov	r0, lr			@ lr is stack top (see above),
 					@ which is the exception stacks base
 	bl	exceptions_init
+	bl	enable_vfp
=20
 	/* complete setup */
 	pop	{r0-r1}
@@ -100,6 +101,16 @@ exceptions_init:
 	isb
 	mov	pc, lr
=20
+enable_vfp:
+	/* Enable full access to CP10 and CP11: */
+	mov	r0, #(3 << 22 | 3 << 20)
+	mcr	p15, 0, r0, c1, c0, 2
+	isb
+	/* Set the FPEXC.EN bit to enable Advanced SIMD and VFP: */
+	mov	r0, #(1 << 30)
+	vmsr	fpexc, r0
+	mov	pc, lr
+
 .text
=20
 .global get_mmu_off
@@ -130,6 +141,7 @@ secondary_entry:
 	ldr	r0, [r1]
 	mov	sp, r0
 	bl	exceptions_init
+	bl	enable_vfp
=20
 	/* finish init in C code */
 	bl	secondary_cinit
--=20
2.21.0

