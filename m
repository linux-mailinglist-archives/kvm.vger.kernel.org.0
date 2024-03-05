Return-Path: <kvm+bounces-10858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D298713EB
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:50:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ADD8C288471
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD692940B;
	Tue,  5 Mar 2024 02:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z99FLIPT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053BE18032;
	Tue,  5 Mar 2024 02:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709607028; cv=none; b=PuCF7r3EdMtPZQ28WeX0KC3K8x4j+p008XxSVyl6qb6T1PcclvVqRi+A5Cp6mgzJF6ZNrZKKhcWue+z6iNQkwuKVi4n7pn2Ra7rbJm9nvpYHBgl/Nwx3W4SvIv4bBBphF2cBGyyAU/ka1XhL3RFKJcVwFOpsJgwjLilrxCWKazo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709607028; c=relaxed/simple;
	bh=l1nENdh0odJGSyJitoMidt/y4tZNw4n5Xgmi64sACs8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=X5slEsPIwiGx+pC2QQCQEK/P0vbCxhNtoKIPNoCsYSu30WArjQAAix5DXHx0y6Yh+8MOa0TDcV56NscesGjGzUYbPY8Fa0r95yEZ2I4Cbfylj7DoDBm3u2F/dAPux3Q21v0yq+esmGu8ItOq3VFhb1jUdx0MTXV4w35CUMY5P3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z99FLIPT; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e5eb3dd2f8so1796661b3a.2;
        Mon, 04 Mar 2024 18:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709607026; x=1710211826; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K01sPMa+E35+HBf+hQVX1Loh4XduD8AUM0UI4iasBRg=;
        b=Z99FLIPTmhQ8QyKl1dVQAQliQP8+/KKSWNCI0zsKwjfawV889jrj+fhez42tJ4QJRc
         lUSbh5t8OMGSDrCJB50uC2yq+bHpWJ16RlRknmsWoLkdfPJsXMVpgzKNaQFtvTbb9ANT
         I1wgGEnoJy55Cl8Iue7PIRLoVY+qO8MTmA82jQ2eLN0QD0hQwLbVjGWx1kDfLZHd8JMr
         ludewxU3q0PnnckY0r3Gfu26eE4mgB+HZDQJNT8JLZQQu/1lV50xXmnj3o73UaC7xv7I
         AfU8HovP28ovKJpvojgzE1LObOjTaA2M1zqagDNMFpm3yeJSBLAzYxeCkSAx+q1ySvJl
         W+sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709607026; x=1710211826;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K01sPMa+E35+HBf+hQVX1Loh4XduD8AUM0UI4iasBRg=;
        b=tO5m1KYAaw3h0JVwg9MD3f+qfd0S8Q+USOpO0AE8ezuq+HC6ut9xNr2ykTVaLvNTLq
         5QmAU/HSmkpaoM+uIgx/LVQMWqT7hqwfR68XZiYFK9mjdxQ6Yb1IOhiIdbStrkFut3/C
         VZmEIk5Iaj/GwZt3ZR6172BVOmy099QiajO0xpBkgaVjV6EOvSNLfHwub1pLWEhEpMND
         8e1tNamvqTY7boQPDfLdkX+PHetFvxnkutLuy8xnSzH9voIjC0sZsqg1NDIHkiWOEcGs
         ORzjMlSAlFagf6Ec95Zn/0QimLCsLRQmDhHiYV4HKX/3iAMPTMZ9hVm3UUJ+OzO0cTKK
         OlPw==
X-Forwarded-Encrypted: i=1; AJvYcCUQatdnyt4Zo5hOsekzPWFhXsPnHvw18SGbKWfCgcug7syJGvLhCmjwJAkuaSPszSHiFCfxGGFLdLJyIOOEh3YmaHS/wETJWv7Drw==
X-Gm-Message-State: AOJu0YzEkUm6pA9vyZ0i8poS1T9pA/ePY9Aa3oVBDrp/cYSAc9YSJxIe
	vQaHvmaNtAtHtBpRdxxaoPI1f+zBphec4eap+yKMktZO+BMp14qP
X-Google-Smtp-Source: AGHT+IGeaUyWTzG0fHn8j7kM8kVyutYiwJxH45YKNyPGsMtfAwKqhuxGDXZ2ByjKjIbEtmSLAgF7Iw==
X-Received: by 2002:a62:6203:0:b0:6e5:e7f5:856 with SMTP id w3-20020a626203000000b006e5e7f50856mr6657495pfb.19.1709607026290;
        Mon, 04 Mar 2024 18:50:26 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id k16-20020aa79d10000000b006e5ad7f245esm6916368pfp.11.2024.03.04.18.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:50:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:50:18 +1000
Message-Id: <CZLH3XUGU8Z8.2R73ILJ3ISWN8@wheely>
Subject: Re: [kvm-unit-tests PATCH 7/7] common: add memory dirtying vs
 migration test
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.15.2
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-8-npiggin@gmail.com>
 <e967e7a6-eb20-4b2b-ab7a-fc5052a3eb52@redhat.com>
In-Reply-To: <e967e7a6-eb20-4b2b-ab7a-fc5052a3eb52@redhat.com>

On Mon Mar 4, 2024 at 4:22 PM AEST, Thomas Huth wrote:
> On 26/02/2024 10.38, Nicholas Piggin wrote:
> > This test stores to a bunch of pages and verifies previous stores,
> > while being continually migrated. This can fail due to a QEMU TCG
> > physical memory dirty bitmap bug.
>
> Good idea, but could we then please drop "continuous" test from=20
> selftest-migration.c again? ... having two common tests to exercise the=
=20
> continuous migration that take quite a bunch of seconds to finish sounds=
=20
> like a waste of time in the long run to me.

Yeah if you like. I could shorten them up a bit. I did want to have
the selftests for just purely testing the harness with as little
"test" code as possible.

>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   common/memory-verify.c  | 48 ++++++++++++++++++++++++++++++++++++++++=
+
> >   powerpc/Makefile.common |  1 +
> >   powerpc/memory-verify.c |  1 +
> >   powerpc/unittests.cfg   |  7 ++++++
> >   s390x/Makefile          |  1 +
> >   s390x/memory-verify.c   |  1 +
> >   s390x/unittests.cfg     |  6 ++++++
> >   7 files changed, 65 insertions(+)
> >   create mode 100644 common/memory-verify.c
> >   create mode 120000 powerpc/memory-verify.c
> >   create mode 120000 s390x/memory-verify.c
> >=20
> > diff --git a/common/memory-verify.c b/common/memory-verify.c
> > new file mode 100644
> > index 000000000..7c4ec087b
> > --- /dev/null
> > +++ b/common/memory-verify.c
> > @@ -0,0 +1,48 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * Simple memory verification test, used to exercise dirty memory migr=
ation.
> > + *
> > + */
> > +#include <libcflat.h>
> > +#include <migrate.h>
> > +#include <alloc.h>
> > +#include <asm/page.h>
> > +#include <asm/time.h>
> > +
> > +#define NR_PAGES 32
> > +
> > +int main(int argc, char **argv)
> > +{
> > +	void *mem =3D malloc(NR_PAGES*PAGE_SIZE);
> > +	bool success =3D true;
> > +	uint64_t ms;
> > +	long i;
> > +
> > +	report_prefix_push("memory");
> > +
> > +	memset(mem, 0, NR_PAGES*PAGE_SIZE);
> > +
> > +	migrate_begin_continuous();
> > +	ms =3D get_clock_ms();
> > +	i =3D 0;
> > +	do {
> > +		int j;
> > +
> > +		for (j =3D 0; j < NR_PAGES*PAGE_SIZE; j +=3D PAGE_SIZE) {
> > +			if (*(volatile long *)(mem + j) !=3D i) {
> > +				success =3D false;
> > +				goto out;
> > +			}
> > +			*(volatile long *)(mem + j) =3D i + 1;
> > +		}
> > +		i++;
> > +	} while (get_clock_ms() - ms < 5000);
>
> Maybe add a parameter so that the user can use different values for the=
=20
> runtime than always doing 5 seconds?

Sure.

Thanks,
Nick

