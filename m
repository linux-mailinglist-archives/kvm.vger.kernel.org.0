Return-Path: <kvm+bounces-23619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF80694BD3A
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 14:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E15401C22745
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 12:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EEC18C334;
	Thu,  8 Aug 2024 12:18:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B993107B6
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723119480; cv=none; b=TwrrXLATOFsX0LKUSF4Yt94jL6cIXCyHpGq3wdpSOFdi7JNvFVelqe8bejE7qZPIFTUkVQRtdvtgi5/rMf1xolgNNeAEJO3rP/D8NrovvpqJvzaGA7zv1/37MTNMn1lsgan5dZoGnQSWaqfvI/1uO3+4FVGbnFAJkLEcC8UYbpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723119480; c=relaxed/simple;
	bh=eR2sE6dMWDhJniwN1B1GofOlFeWB9dq/HAQ7duNBFFw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GswJuP6PSnvDFdXWESNR/VxLfuQyFUx2JNPE6V6JFjrDn7KRubit6cLFlDUjcY3J9SrsoUVG4BvjBCi7+/yjpIYbEV6TRtPjW1UNRWGiubMrbYv7+z9eror8ia6zeFlTPk2OhPguW4+6uPZ6ADAGpQA2/vA4lXZsiechv/rPMUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9273BFEC;
	Thu,  8 Aug 2024 05:18:23 -0700 (PDT)
Received: from donnerap.manchester.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ADE6C3F766;
	Thu,  8 Aug 2024 05:17:56 -0700 (PDT)
Date: Thu, 8 Aug 2024 13:17:53 +0100
From: Andre Przywara <andre.przywara@arm.com>
To: "J. =?UTF-8?B?TmV1c2Now6RmZXI=?=" <j.neuschaefer@gmx.net>
Cc: kvm@vger.kernel.org, Alyssa Ross <hi@alyssa.is>, Alexandru Elisei
 <Alexandru.Elisei@arm.com>, Will Deacon <will@kernel.org>, Julien Thierry
 <julien.thierry.kdev@gmail.com>
Subject: Re: [PATCH kvmtool v2 1/2] Switch to POSIX version of basename()
Message-ID: <20240808131753.1657f95c@donnerap.manchester.arm.com>
In-Reply-To: <20240727-musl-v2-1-b106252a1cba@gmx.net>
References: <20240727-musl-v2-0-b106252a1cba@gmx.net>
	<20240727-musl-v2-1-b106252a1cba@gmx.net>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, 27 Jul 2024 19:11:02 +0200
J. Neusch=C3=A4fer <j.neuschaefer@gmx.net> wrote:

Hi,

> There are two versions of the basename function: The POSIX version is
> defined in <libgen.h>, and glibc additionally provides a GNU-specific
> version in <string.h>.

That's right, the Linux manpage confirms that. It seems like on GLIBC
Linux we get the GNU version, since we implicitly include string.h, and
define _GNU_SOURCE. The manpage talks about the differences between
the two: the POSIX version can modify the string, and it differs when the
last character is a '/'. Both cases do not apply to us here, so we can use
either version:

> musl-libc only provides the POSIX version,
> resulting in a compilation failure:
>=20
> vfio/core.c:538:22: error: implicit declaration of function 'basename' [-=
Werror=3Dimplicit-function-declaration]
>   538 |         group_name =3D basename(group_path);
>       |                      ^~~~~~~~
>=20
> Reviewed-by: Alyssa Ross <hi@alyssa.is>
> Signed-off-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  vfio/core.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/vfio/core.c b/vfio/core.c
> index 3ff2c0b..8f88489 100644
> --- a/vfio/core.c
> +++ b/vfio/core.c
> @@ -3,6 +3,7 @@
>  #include "kvm/ioport.h"
>=20
>  #include <linux/list.h>
> +#include <libgen.h>
>=20
>  #define VFIO_DEV_DIR		"/dev/vfio"
>  #define VFIO_DEV_NODE		VFIO_DEV_DIR "/vfio"
>=20
> --
> 2.43.0
>=20


