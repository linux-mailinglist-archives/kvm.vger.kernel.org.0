Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF6910CB4A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2019 16:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfK1PGK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Nov 2019 10:06:10 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:46470 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726436AbfK1PGK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Nov 2019 10:06:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574953569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FB2NxuXo03bjG5BMgixcxMCaomV9zklTdD9jueZG8ZU=;
        b=aSDEhFB6ff/rZqWPqe6zT3jfKhoVm7itThn6djrtSrgk/N8Ghi78oeGk4IYP4Mv2emME2G
        d4imZ+yMXhUzdBxPcWkBKWH+ES/Oyfar7Q0mmSOMHLrKJcjjFLI6wNrMeMrCR+xZMmUcKh
        hBbRnfMN40a+gXJilgQy+7JC5ohawus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-45B5G9iUN52kxXh0T1klHg-1; Thu, 28 Nov 2019 10:06:05 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A8CD107ACC5;
        Thu, 28 Nov 2019 15:06:04 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3879860BE0;
        Thu, 28 Nov 2019 15:06:03 +0000 (UTC)
Date:   Thu, 28 Nov 2019 16:06:00 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     thuth@redhat.com, pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] arm: Enable the VFP
Message-ID: <20191128150600.2ktf4ytattn5aop4@kamzik.brq.redhat.com>
References: <20191128143421.13815-1-drjones@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191128143421.13815-1-drjones@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 45B5G9iUN52kxXh0T1klHg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Doh, now I need another change to deal with older compilers

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 43b4be1e05eeb..d379a28007493 100644
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


I'll send a v2 now.


On Thu, Nov 28, 2019 at 03:34:21PM +0100, Andrew Jones wrote:
> Variable argument macros frequently depend on floating point
> registers. Indeed we needed to enable the VFP for arm64 since its
> introduction in order to use printf and the like. Somehow we
> didn't need to do that for arm32 until recently when compiling
> with GCC 9.
>=20
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>=20
> CC'ing Thomas because I think he had to workaround travis tests
> failing due to this issue once. Maybe travis can now be
> un-worked-around?
>=20
>=20
>  arm/cstart.S | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 114726feab82..bc6219d8a3ee 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -50,10 +50,11 @@ start:
>  =09mov=09r0, r2
>  =09push=09{r0-r1}
> =20
> -=09/* set up vector table and mode stacks */
> +=09/* set up vector table, mode stacks, and enable the VFP */
>  =09mov=09r0, lr=09=09=09@ lr is stack top (see above),
>  =09=09=09=09=09@ which is the exception stacks base
>  =09bl=09exceptions_init
> +=09bl=09enable_vfp
> =20
>  =09/* complete setup */
>  =09pop=09{r0-r1}
> @@ -100,6 +101,16 @@ exceptions_init:
>  =09isb
>  =09mov=09pc, lr
> =20
> +enable_vfp:
> +=09/* Enable full access to CP10 and CP11: */
> +=09mov=09r0, #(3 << 22 | 3 << 20)
> +=09mcr=09p15, 0, r0, c1, c0, 2
> +=09isb
> +=09/* Set the FPEXC.EN bit to enable Advanced SIMD and VFP: */
> +=09mov=09r0, #(1 << 30)
> +=09vmsr=09fpexc, r0
> +=09mov=09pc, lr
> +
>  .text
> =20
>  .global get_mmu_off
> @@ -130,6 +141,7 @@ secondary_entry:
>  =09ldr=09r0, [r1]
>  =09mov=09sp, r0
>  =09bl=09exceptions_init
> +=09bl=09enable_vfp
> =20
>  =09/* finish init in C code */
>  =09bl=09secondary_cinit
> --=20
> 2.21.0
>=20

