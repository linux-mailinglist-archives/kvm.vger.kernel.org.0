Return-Path: <kvm+bounces-13635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AA21089949D
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 06:54:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 21A66B2379A
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 04:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342DA21350;
	Fri,  5 Apr 2024 04:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AsKwv7P+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1660A21
	for <kvm@vger.kernel.org>; Fri,  5 Apr 2024 04:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292859; cv=none; b=j31eKpUCqZKmMU/B02Z5y1e50aBB6yMP7B4zlsqC6NHE17F5Lw2xUqO693hJqUxgq+fW6GL/p79xg3pLKdqYNseLWgTk/SQmtUhAkFd+qJwoYWyEip7xueGpkHLsfT/bmvwIe53O7ltN8vb1tnhuQvWLUjaNU7yP9dnoqZwxbSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292859; c=relaxed/simple;
	bh=H+3L2GtRWBx6xlaQUptrJGMP/7UNUsoQePX3+YJssFw=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=s2VdWZoM/dt3yA5dvmnRTCRIZNq7oVhhPSnj+NcqpXoCxxm12/uwdWy39zxORofsMD5BkRN/SxhxIhRnGpHVo2jFEMs2DLh/H0tx7jdgW16dSH2o39yfqZ8Qz6xYFumRXtrKsiVMu3VGmxTP0Cr82BtdxpaNV0tNprnixvleMzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AsKwv7P+; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3c5db6797deso443096b6e.3
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 21:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712292857; x=1712897657; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NM65XexEQuUDhr+aIgnkbT0SpwOWl1w3Itz5eH8He64=;
        b=AsKwv7P+H8ZnpE3n8OcoRBqbq1uA+y5eOeqdT5mFBztnWWHA0O0+HxpEnB5A4Di83/
         8UxJWKokG2bnYt3HZaic1V6POmXSoJW0Ch3LkkO8DLVQ4/0X+yUvU3eMmhXvoT8LUald
         l6w2sPbFEUrEP9xCfZPfhl73X8lLP6Lbr2h7QZ6oQVAUpk4zYq/bcV+T3OIoi2L6v43l
         Fm0DAqwJTFbo0RVbIyry8blmplKfp7Pi+ftN/NhpPU132PrKqYCylfjcH68QjWoBYtTZ
         aKwBMgeHYqOATBYBw3qZs/VsRLa5ooUyJ4NeE/tKFZpsOnSUFmnKlTwJWPg+NfaT+5Ow
         wyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712292857; x=1712897657;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NM65XexEQuUDhr+aIgnkbT0SpwOWl1w3Itz5eH8He64=;
        b=K/I8vX+3qc6dbibcA7d9sl2YV0Cl/7kFRQz5ueG2F/FRwBeansOndR5IzHAfnfVuLn
         4vImD6MaIkzT3/NACvS62z/T3rNFnDusIz8YXMc1esY4OBNgtuKbeacxp4/Jmg6SOmzd
         v6vA9rbTVT3RkINvCKeYM5tyG/qSbcY8Zdnbo/8pyYH0fzj2WayfTCVRsTf91zQkgpnf
         c87yAUIK6J6XIPCFlw9txpAhTBGP4BafcKvRwvxmJO8ooy394aP+HiY14zB71m7eYQ5Q
         c7k2FFvu5KSkZqpwvWSbSVvhYUZA9ZA1QHbnSj5b8oUAcyxxOhFtzsv7MNKSHlKLeaz4
         TgRA==
X-Forwarded-Encrypted: i=1; AJvYcCVVAECDFKCZR7p4Ydf6OIRGsue3nVPV8rk7EHyvXgDuLFs+Iv3fYhHhNZVm4424XcAkhyYueEk8UUy+hIXysKxC6uBI
X-Gm-Message-State: AOJu0YyRWXQXYYg2JWRt6NVwPQm/D8mN8E6iCh7EiInJXR+GkrMBpv/O
	uTE0KDn3n9rv7mWoLVqscD+HbJoUqAUtplgHpDuvxvMYmZqpkPiY8a1lmP49veE=
X-Google-Smtp-Source: AGHT+IGHD0DlwEdgHO7QJ9tkbc1GkMFmfexAQlDtE82V1qn/NLI0Tu7/QDx6d5bnKtEbzA7K44YNSg==
X-Received: by 2002:a54:451a:0:b0:3c5:d953:3814 with SMTP id l26-20020a54451a000000b003c5d9533814mr381743oil.2.1712292857082;
        Thu, 04 Apr 2024 21:54:17 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id gu11-20020a056a004e4b00b006e6cc93381esm546830pfb.125.2024.04.04.21.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Apr 2024 21:54:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Apr 2024 14:54:06 +1000
Message-Id: <D0BX5M9GOA7N.RV1WXBCHI79X@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, "Paolo Bonzini" <pbonzini@redhat.com>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v7 07/35] common: add memory dirtying vs
 migration test
From: "Nicholas Piggin" <npiggin@gmail.com>
X-Mailer: aerc 0.17.0
References: <20240319075926.2422707-1-npiggin@gmail.com>
 <20240319075926.2422707-8-npiggin@gmail.com>
 <6821682a-56f8-46aa-8fee-197434723bf5@redhat.com>
In-Reply-To: <6821682a-56f8-46aa-8fee-197434723bf5@redhat.com>

On Fri Mar 29, 2024 at 3:37 AM AEST, Thomas Huth wrote:
> On 19/03/2024 08.58, Nicholas Piggin wrote:
> > This test stores to a bunch of pages and verifies previous stores,
> > while being continually migrated. Default runtime is 5 seconds.
> >=20
> > Add this test to ppc64 and s390x builds. This can fail due to a QEMU
> > TCG physical memory dirty bitmap bug, so it is not enabled in unittests
> > for TCG yet.
> >=20
> > The selftest-migration test time is reduced significantly because
> > this test
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   common/memory-verify.c      | 67 ++++++++++++++++++++++++++++++++++++=
+
> >   common/selftest-migration.c |  8 ++---
> >   powerpc/Makefile.common     |  1 +
> >   powerpc/memory-verify.c     |  1 +
> >   powerpc/unittests.cfg       |  7 ++++
> >   s390x/Makefile              |  1 +
> >   s390x/memory-verify.c       |  1 +
> >   s390x/unittests.cfg         |  6 ++++
> >   8 files changed, 88 insertions(+), 4 deletions(-)
> >   create mode 100644 common/memory-verify.c
> >   create mode 120000 powerpc/memory-verify.c
> >   create mode 120000 s390x/memory-verify.c
> >=20
> > diff --git a/common/memory-verify.c b/common/memory-verify.c
> > new file mode 100644
> > index 000000000..e78fb4338
> > --- /dev/null
> > +++ b/common/memory-verify.c
> > @@ -0,0 +1,67 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Simple memory verification test, used to exercise dirty memory migr=
ation.
> > + */
> > +#include <libcflat.h>
> > +#include <migrate.h>
> > +#include <alloc.h>
> > +#include <asm/page.h>
> > +#include <asm/time.h>
> > +
> > +#define NR_PAGES 32
> > +
> > +static unsigned time_sec =3D 5;
> > +
> > +static void do_getopts(int argc, char **argv)
> > +{
> > +	int i;
> > +
> > +	for (i =3D 0; i < argc; ++i) {
> > +		if (strcmp(argv[i], "-t") =3D=3D 0) {
> > +			i++;
> > +			if (i =3D=3D argc)
> > +				break;
> > +			time_sec =3D atol(argv[i]);
> > +		}
> > +	}
> > +
> > +	printf("running for %d secs\n", time_sec);
> > +}
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	void *mem =3D malloc(NR_PAGES*PAGE_SIZE);
>
> Use alloc_pages(5) instead ? Or add at least some white spaces around "*"=
.

Hmm, alloc_pages is physical? Maybe I should use memalign instead (and
I'll fix the space). Even though it's not using VM, we might change
that.

> Apart from that this patch looks sane to me, so with that line fixed:
> Reviewed-by: Thomas Huth <thuth@redhat.com>

I'll keep your R-B with the memalign change if that's okay.

Thanks,
Nick

