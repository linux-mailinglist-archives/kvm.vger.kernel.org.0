Return-Path: <kvm+bounces-13789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BAEB89A968
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 08:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A5878B21FA2
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 06:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34B082209B;
	Sat,  6 Apr 2024 06:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUyTwJhp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341DB1DA53;
	Sat,  6 Apr 2024 06:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712385555; cv=none; b=s6FdTcuLRsx1yUDbf+BT0USRS62WgSQ9LZKq/FU2BSY1LDzXxn0Gm08RS+pbD8UtZj56CKYDkmKtVqF1HoJojRX28OcMX/FR8/LecHTtscQJMbqWRtF9sMHKgkG2k6LVPiijErPIRH8pL6lwLe/97eybZ28zMxZm/7nnXMbo2co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712385555; c=relaxed/simple;
	bh=dgtho79k0NbkukTya9S75NLdIHroTxBMY9xsdppO0VM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=OM9VZ4tYcRYEx8pCAVlh0OBiSOTMX3GGSVJ/9rwpe3TRY594QqSV+awgbiXcxVANQelKvQmYv3mx1ifq6hvPA0k7gW7PATYQz4vRCvVEqZRJweI4V8/UAuK6YPUa56K1gAKZZqxZDXh28/RVcA/Ih0bQUB7wJlymBmoaqBws7h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RUyTwJhp; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso2372936b3a.0;
        Fri, 05 Apr 2024 23:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712385552; x=1712990352; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jiFnhbowciN3dJNp6As/e1oCvoV+OtiGUNIebM4Vql0=;
        b=RUyTwJhpA2K0XBjPZx/xcjPNjzMrDQ5useHeEE72OBKDiiiDZ8qAbYrlYLWwUfFnry
         oT+0rzV3S1dFqYh/uEFmNZU488NJZKlFb+vQhXALC9IKMGPQPETCAQ/vUttWVI+Pnk2o
         DavE2gOVGketMYgd2yUCu0IkEL5+oqv/D5SrwxYLfrqVdJsrjZKq3kcfD/d8yPJLBfcy
         L9E8rr0ZJivlnE2CU2I0HKNsObZidh2JHYqFWP+vjYloYHXHxCr6WCd6Jo4x8wZVaIT4
         eOzQ8gFvWbkjnokgxhL4PoZtPW4dvd8DvL95gSuRR3FFSA87IMsbrLij0OM+SC/E5eLo
         YSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712385552; x=1712990352;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jiFnhbowciN3dJNp6As/e1oCvoV+OtiGUNIebM4Vql0=;
        b=m87Ys8y58f2UvvO+BhLNX5CVHAi4aqTVhfDWynHyp2oGoO6FcFPwmeiL2xPbAH4KSX
         Z1jTriPc0mII3IfeIIBw1+tf9kruOoXcv5S5bhd7X6h1QtzqkxrtvWF1EKwWPPQHbNUa
         zJUrEqWVwTt9EmZxWqhh4IJS5h//cuPGZUlO9xa3O2EdWthP7KR/dBFE0dz3RarhxNIz
         owtn3BOjSIDFuSZDMkZJbx7eeXHEmS0d9bu210HaTGozt3gfqhwSNaEUF+wQLgW+BHJp
         IWKRYkhDihYjF2um962T1R4t4op7EAKtPcmhe2oIrVK7v2EphVoIbqOFuCLanSlWR54z
         EMKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB40gUUFAdbm4ED9hUR6BXdduhShFvK9JouCv5F46Pp9YfQwcKv9lpQtoObEHY8BdhZ0NukPbW7G8w9b7TeHGsCIwNLR7EVIiSwYlclNHp59ggF1J6TZcRa0psRigkqw==
X-Gm-Message-State: AOJu0YxHo2iqQfqH7d/dBY5ZG35YpbX9hHsOfSEym4QiLF3qD/kKh+V5
	e29NwPrMP5oZB+7WpJYiF/mxGrvEQ0du93gs8KFyS+cLd8yE5Ay4n84nH2ax
X-Google-Smtp-Source: AGHT+IE2a4rhUnhNJrOYJ7HQo3kdN+Hmr1kreci+OEnWvxFAXfBNs9PTvi5QjEI+yjNvUCwhf66MGQ==
X-Received: by 2002:a05:6a21:3396:b0:1a7:4cbc:6262 with SMTP id yy22-20020a056a21339600b001a74cbc6262mr1381725pzb.50.1712385552381;
        Fri, 05 Apr 2024 23:39:12 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id u14-20020a170903124e00b001e3e13781c4sm228684plh.54.2024.04.05.23.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 23:39:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 16:39:02 +1000
Message-Id: <D0CU0I2V06SD.ESUPYVUNWII5@gmail.com>
Cc: "Paolo Bonzini" <pbonzini@redhat.com>, "Thomas Huth" <thuth@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Nikos Nikoleris" <nikos.nikoleris@arm.com>,
 "Nadav Amit" <namit@vmware.com>, "David Woodhouse" <dwmw@amazon.co.uk>,
 "Ricardo Koller" <ricarkol@google.com>, "rminmin" <renmm6@chinaunicom.cn>,
 "Gavin Shan" <gshan@redhat.com>, "Nina Schoetterl-Glausch"
 <nsg@linux.ibm.com>, "Sean Christopherson" <seanjc@google.com>,
 <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
 <kvm-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests RFC PATCH 01/17] Add initial shellcheck
 checking
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-2-npiggin@gmail.com>
 <20240405-4880f3f2b12bcae5f3383043@orel>
In-Reply-To: <20240405-4880f3f2b12bcae5f3383043@orel>

On Sat Apr 6, 2024 at 12:12 AM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:33PM +1000, Nicholas Piggin wrote:
> > This adds a basic shellcheck sytle file, some directives to help
> > find scripts, and a make shellcheck target.
> >=20
> > When changes settle down this could be made part of the standard
> > build / CI flow.
> >=20
> > Suggested-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  .shellcheckrc       | 32 ++++++++++++++++++++++++++++++++
> >  Makefile            |  4 ++++
> >  README.md           |  2 ++
> >  scripts/common.bash |  5 ++++-
> >  4 files changed, 42 insertions(+), 1 deletion(-)
> >  create mode 100644 .shellcheckrc
> >=20
> > diff --git a/.shellcheckrc b/.shellcheckrc
> > new file mode 100644
> > index 000000000..2a9a57c42
> > --- /dev/null
> > +++ b/.shellcheckrc
> > @@ -0,0 +1,32 @@
> > +# shellcheck configuration file
> > +external-sources=3Dtrue
> > +
> > +# Optional extras --  https://www.shellcheck.net/wiki/Optional
> > +# Possibilities, e.g., -
> > +# quote=E2=80=90safe=E2=80=90variables
> > +# require-double-brackets
> > +# require-variable-braces
> > +# add-default-case
> > +
> > +# Disable SC2004 style? I.e.,
> > +# In run_tests.sh line 67:
> > +#            if (( $unittest_run_queues <=3D 0 )); then
> > +#                  ^------------------^ SC2004 (style): $/${} is unnec=
essary on arithmetic variables.
> > +disable=3DSC2004
>
> I vote keep disabled. The problem pointed out in the wiki can be handled
> with ($a), similar to how one handles variables to C preprocessor macros.
>
> > +
> > +# Disable SC2034 - config.mak contains a lot of these unused variable =
errors.
> > +# Maybe we could have a script extract the ones used by shell script a=
nd put
> > +# them in a generated file, to re-enable the warning.
> > +#
> > +# In config.mak line 1:
> > +# SRCDIR=3D/home/npiggin/src/kvm-unit-tests
> > +# ^----^ SC2034 (warning): SRCDIR appears unused. Verify use (or expor=
t if used externally).
> > +disable=3DSC2034
>
> Maybe we should export everything in config.mak.

It would be nice to enable the warning.... Oh, actually it looks like
we can disable a warning for an entire file by adding the disable
directive at the top. I didn't notice that before, I'll try that first.

>
> > +
> > +# Disable SC2086 for now, double quote to prevent globbing and word
> > +# splitting. There are lots of places that use it for word splitting
> > +# (e.g., invoking commands with arguments) that break. Should have a
> > +# more consistent approach for this (perhaps use arrays for such cases=
)
> > +# but for now disable.
> > +# SC2086 (info): Double quote to prevent globbing and word splitting.
> > +disable=3DSC2086
>
> Agreed. We can cross this bridge later.
>
> > diff --git a/Makefile b/Makefile
> > index 4e0f54543..4863cfdc6 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -141,6 +141,10 @@ cscope:
> >  		-name '*.[chsS]' -exec realpath --relative-base=3D$(CURDIR) {} \; | =
sort -u > ./cscope.files
> >  	cscope -bk
> > =20
> > +.PHONY: shellcheck
> > +shellcheck:
> > +	shellcheck -a run_tests.sh */run */efi/run scripts/mkstandalone.sh
> > +
> >  .PHONY: tags
> >  tags:
> >  	ctags -R
> > diff --git a/README.md b/README.md
> > index 6e82dc225..77718675e 100644
> > --- a/README.md
> > +++ b/README.md
> > @@ -193,3 +193,5 @@ with `git config diff.orderFile scripts/git.difford=
er` enables it.
> > =20
> >  We strive to follow the Linux kernels coding style so it's recommended
> >  to run the kernel's ./scripts/checkpatch.pl on new patches.
> > +
> > +Also run make shellcheck before submitting a patch.
>
> which touches Bash scripts.

Yeah good point.

Thanks,
Nick

>
>
> > diff --git a/scripts/common.bash b/scripts/common.bash
> > index ee1dd8659..3aa557c8c 100644
> > --- a/scripts/common.bash
> > +++ b/scripts/common.bash
> > @@ -82,8 +82,11 @@ function arch_cmd()
> >  }
> > =20
> >  # The current file has to be the only file sourcing the arch helper
> > -# file
> > +# file. Shellcheck can't follow this so help it out. There doesn't app=
ear to be a
> > +# way to specify multiple alternatives, so we will have to rethink thi=
s if things
> > +# get more complicated.
> >  ARCH_FUNC=3Dscripts/${ARCH}/func.bash
> >  if [ -f "${ARCH_FUNC}" ]; then
> > +# shellcheck source=3Dscripts/s390x/func.bash
> >  	source "${ARCH_FUNC}"
> >  fi
> > --=20
> > 2.43.0
> >
>
> Other than the extension to the sentence in the README,
>
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
>
> Thanks,
> drew


