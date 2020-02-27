Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235C8170F05
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 04:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728276AbgB0Ddf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 22:33:35 -0500
Received: from ozlabs.org ([203.11.71.1]:40231 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728238AbgB0Dde (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 22:33:34 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 48SdYS6fpjz9sRQ;
        Thu, 27 Feb 2020 14:33:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1582774413;
        bh=Dor7dcwvpsNbsL7046VI5GfMcMzut5cyU0ZI1YD/FhE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Eg1fnyGPDBsCRIvLtiUzT228EP+RPP0YGqznCGILGSb6SuEsfKYi8uybQw8UhyfE4
         zEQPQWWGR1Mf/EeFHUHD5GrYdnX4GQFy0ts9XKTQaFtQjtezI4zGffjZu4OwMP2tfJ
         ubrxUwHovUOsbBKtrKQyEFGyOS53eoleDA7MEjQipo+tYMoxOVbeUIM7YscSeiCI3C
         +sbNWDoPk3F5UtyO98IJoWDShn6V+IPwpbuGn6LcCDXR575TJM+dxFStG2LxBYDfRS
         PlGP+0xZdz9OLxrQoCDGqV4D0qebc9066U9haeIFvjVaEEPqwYSPRRdBT676oUuR1A
         rcGIAANrN3u0g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christoph Hellwig <hch@lst.de>, torvalds@linux-foundation.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "KVM: x86: enable -Werror"
In-Reply-To: <20200226153929.786743-1-hch@lst.de>
References: <20200226153929.786743-1-hch@lst.de>
Date:   Thu, 27 Feb 2020 14:33:30 +1100
Message-ID: <87v9ns1z79.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:
> This reverts commit ead68df94d248c80fdbae220ae5425eb5af2e753.
>
> Using the brain dead Werror flag fixes the build for me due to mostly
> harmless KASAN or similar warnings:
>
> arch/x86/kvm/x86.c: In function =E2=80=98kvm_timer_init=E2=80=99:
> arch/x86/kvm/x86.c:7209:1: error: the frame size of 1112 bytes is larger =
than 1024 bytes [-Werror=3Dframe-larger-than=3D]
>  7209 | }
>
> Feel free to add a CONFIG_WERROR if you care strong enough, but don't bre=
ak
> peoples builds for absolutely no good reason.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  arch/x86/kvm/Makefile | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index 4654e97a05cc..b19ef421084d 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -1,7 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>=20=20
>  ccflags-y +=3D -Iarch/x86/kvm
> -ccflags-y +=3D -Werror
>=20=20
>  KVM :=3D ../../../virt/kvm

We've had -Werror enabled by default on powerpc for over 10 years, and
haven't had many complaints. Possibly that's just because no one builds
powerpc kernels ...

The key thing is that it's configurable, so if it does break the build
for someone they can just turn it off. It's also off by default for
allyes/allmod builds because the user-selectable option disables
-Werror, eg:

config PPC_DISABLE_WERROR
	bool "Don't build arch/powerpc code with -Werror"
	help
	  This option tells the compiler NOT to build the code under
	  arch/powerpc with the -Werror flag (which means warnings
	  are treated as errors).

	  Only enable this if you are hitting a build failure in the
	  arch/powerpc code caused by a warning, and you don't feel
	  inclined to fix it.

config PPC_WERROR
	bool
	depends on !PPC_DISABLE_WERROR
	default y


In fact these days with shell support in Kconfig we could make it even
smarter, eg:

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index 0b063830eea8..e7564f7cabc6 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -2,6 +2,7 @@
=20
 config PPC_DISABLE_WERROR
        bool "Don't build arch/powerpc code with -Werror"
+       default $(success,whoami | grep hch)
        help
          This option tells the compiler NOT to build the code under
          arch/powerpc with the -Werror flag (which means warnings


cheers
