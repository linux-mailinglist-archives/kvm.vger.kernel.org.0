Return-Path: <kvm+bounces-10857-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEC4F8713E1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:48:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 457DEB23CC3
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7450428E3F;
	Tue,  5 Mar 2024 02:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TPyaz1YP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE9C18030;
	Tue,  5 Mar 2024 02:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709606886; cv=none; b=EDv91Pfz9xKgWusc/RoAbnT8epYb2Qhp8Jl72PmNuO975v4aRmUrU3ayCfxiwdBz9+jL9sDGBkim3Ik1za3NERVQOHhZTzHfyAAVXGT9voiVkio+41G47kriiqkRS07/esto1HhaozfsjA02p7ISJgxNU67AM2QpkwipRIcQmNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709606886; c=relaxed/simple;
	bh=Xsg9/Jh9dP0xAQoPb3gMHd4ro5AWgfmO7FptS66buDA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=lVYkMyQfUhBfijN8mmxD+hV177o8rigP8hTPBrRleVAseD0Mk5bdQ2R3OC7a+fMdw2iJodShgJYl4uNBwZhpdr+4EEUrkJ9Yv9m1KkcfSQb5ZgEqVBei+aVAXemOqSJEIaVtWv8tKz1aQz7UAT+KCJWP0zuwgM/EW5dRytC+bWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TPyaz1YP; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-3c1a2f7e1d2so2943648b6e.1;
        Mon, 04 Mar 2024 18:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709606884; x=1710211684; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HSZr4DPIKRSKTMaW46X/jcBrQt1dzvbv+0KNdLtj2k8=;
        b=TPyaz1YPt8vMauSLcsH1Tt//t9Z8ciUCTnqocbU90EMdcGZ6FyH20YU6Hg0f77oAUS
         M274Klmpq3B/R/xOKXwXrGAPhL+E+NdMDOHJnfkgM5sTTu+J59PEeBIRH6qwj3yMoMVz
         mb/iqqaMCWGKwQ5KxromCl3cEeW6SJIsOc0ALVVUn3RbBTD7PYYQNf5CzTquxLwOmaSD
         rBhmuW8PnQ/utkaro2C08Keu891fl1+ZgH0PF3IuGpnesGkA6JYmvoa3330hGkX6is7X
         MNyZ5YTc7JAuk2fJtHTwZ/7B4k2VI5qNlyxcaGrZZU038TrRS8XA8TaR6FlOBXclvy67
         NU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709606884; x=1710211684;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HSZr4DPIKRSKTMaW46X/jcBrQt1dzvbv+0KNdLtj2k8=;
        b=TM4F89mOBM7M48ztsvCALSQbz+yQkVhNYhEhKRopL/E5MRp03qICap5WIeMg2tZVVO
         RaO+v6g3OocLA48giSgiMuiHL2ZIIzpWJIPNbxuBYgURXgYWMwe+juhGPaOPw3oajcTu
         Qjg0oxsl5qKOzWE9dQ4htmPRaN+DybobWf2vVIPhb33xZO8agCVcmi89w/G0n7r+T9JT
         4NUhIAa9vfgoOG3Aje1WYZAZ5vMnSmJxqN0m3R5nCNU9ZZO5QdvdXOmH9sftmQ76mr/k
         lbGRPFO363+sX36LfveGJSPh97PR5x+pWe2SMMOGDhS3pS8lZgEyna+MWjuIjcR4Tz2V
         t9cg==
X-Forwarded-Encrypted: i=1; AJvYcCVvhXg1pxqJ6LIgGo/EDEIlgwIShHhS68xeGQ3H8BZj3fpD8/4/HfWnyMbKlhofx1qlds6DAgiadULXaeB0dPFBeyeoV8OQDClpVA==
X-Gm-Message-State: AOJu0YxMl1NU3mdqa0+p5TpMw4GyQcnWmO3jyTm7BFpQI2iWvxvEdn+m
	b3h+xQS0J1W0w/Bb2u1iKWhJEl6kxBVXc00ADIaLtGdkJQSxvOrA
X-Google-Smtp-Source: AGHT+IH0UuEdRgXkpB3snaCgFc1Pc+EgsL4JBZeNU3fqUdfBioGXZ1BGiwqZOs82imAc/KYqpTli9g==
X-Received: by 2002:aca:f01:0:b0:3c1:dbd5:fc39 with SMTP id 1-20020aca0f01000000b003c1dbd5fc39mr585576oip.31.1709606882631;
        Mon, 04 Mar 2024 18:48:02 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id c6-20020aa78806000000b006e53cc789c3sm7936038pfo.107.2024.03.04.18.47.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:48:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:47:54 +1000
Message-Id: <CZLH23VYF085.2H710Q91HBR6A@wheely>
Cc: <kvm@vger.kernel.org>, "Laurent Vivier" <lvivier@redhat.com>, "Shaoqin
 Huang" <shahuang@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>,
 "Nico Boehr" <nrb@linux.ibm.com>, "Paolo Bonzini" <pbonzini@redhat.com>,
 "Alexandru Elisei" <alexandru.elisei@arm.com>, "Eric Auger"
 <eric.auger@redhat.com>, "Janosch Frank" <frankja@linux.ibm.com>, "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>,
 "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
 <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 5/7] arch-run: Add a "continuous"
 migration option for tests
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.15.2
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-6-npiggin@gmail.com>
 <6329dd4c-2093-40c3-8eb8-701d8e8b2ecd@redhat.com>
In-Reply-To: <6329dd4c-2093-40c3-8eb8-701d8e8b2ecd@redhat.com>

On Mon Mar 4, 2024 at 4:17 PM AEST, Thomas Huth wrote:
> On 26/02/2024 10.38, Nicholas Piggin wrote:
> > The cooperative migration protocol is very good to control precise
> > pre and post conditions for a migration event. However in some cases
> > its intrusiveness to the test program, can mask problems and make
> > analysis more difficult.
> >=20
> > For example to stress test migration vs concurrent complicated
> > memory access, including TLB refill, ram dirtying, etc., then the
> > tight spin at getchar() and resumption of the workload after
> > migration is unhelpful.
> >=20
> > This adds a continuous migration mode that directs the harness to
> > perform migrations continually. This is added to the migration
> > selftests, which also sees cooperative migration iterations reduced
> > to avoid increasing test time too much.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   common/selftest-migration.c | 16 +++++++++--
> >   lib/migrate.c               | 18 ++++++++++++
> >   lib/migrate.h               |  3 ++
> >   scripts/arch-run.bash       | 55 ++++++++++++++++++++++++++++++++----=
-
> >   4 files changed, 82 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/common/selftest-migration.c b/common/selftest-migration.c
> > index 0afd8581c..9a9b61835 100644
> > --- a/common/selftest-migration.c
> > +++ b/common/selftest-migration.c
> > @@ -9,12 +9,13 @@
> >    */
> >   #include <libcflat.h>
> >   #include <migrate.h>
> > +#include <asm/time.h>
> >  =20
> > -#define NR_MIGRATIONS 30
> > +#define NR_MIGRATIONS 15
> >  =20
> >   int main(int argc, char **argv)
> >   {
> > -	report_prefix_push("migration");
> > +	report_prefix_push("migration harness");
> >  =20
> >   	if (argc > 1 && !strcmp(argv[1], "skip")) {
> >   		migrate_skip();
> > @@ -24,7 +25,16 @@ int main(int argc, char **argv)
> >  =20
> >   		for (i =3D 0; i < NR_MIGRATIONS; i++)
> >   			migrate_quiet();
> > -		report(true, "simple harness stress");
> > +		report(true, "cooperative migration");
> > +
> > +		migrate_begin_continuous();
> > +		mdelay(2000);
> > +		migrate_end_continuous();
> > +		mdelay(1000);
> > +		migrate_begin_continuous();
> > +		mdelay(2000);
> > +		migrate_end_continuous();
> > +		report(true, "continuous migration");
> >   	}
> >  =20
> >   	report_prefix_pop();
> > diff --git a/lib/migrate.c b/lib/migrate.c
> > index 1d22196b7..770f76d5c 100644
> > --- a/lib/migrate.c
> > +++ b/lib/migrate.c
> > @@ -60,3 +60,21 @@ void migrate_skip(void)
> >   	puts("Skipped VM migration (quiet)\n");
> >   	(void)getchar();
> >   }
> > +
> > +void migrate_begin_continuous(void)
> > +{
> > +	puts("Begin continuous migration\n");
> > +	(void)getchar();
> > +}
> > +
> > +void migrate_end_continuous(void)
> > +{
> > +	/*
> > +	 * Migration can split this output between source and dest QEMU
> > +	 * output files, print twice and match once to always cope with
> > +	 * a split.
> > +	 */
> > +	puts("End continuous migration\n");
> > +	puts("End continuous migration (quiet)\n");
> > +	(void)getchar();
> > +}
> > diff --git a/lib/migrate.h b/lib/migrate.h
> > index db6e0c501..35b6703a2 100644
> > --- a/lib/migrate.h
> > +++ b/lib/migrate.h
> > @@ -11,3 +11,6 @@ void migrate_quiet(void);
> >   void migrate_once(void);
> >  =20
> >   void migrate_skip(void);
> > +
> > +void migrate_begin_continuous(void);
> > +void migrate_end_continuous(void);
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index d0f6f098f..5c7e72036 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -125,15 +125,17 @@ qmp_events ()
> >   filter_quiet_msgs ()
> >   {
> >   	grep -v "Now migrate the VM (quiet)" |
> > +	grep -v "Begin continuous migration (quiet)" |
> > +	grep -v "End continuous migration (quiet)" |
> >   	grep -v "Skipped VM migration (quiet)"
> >   }
> >  =20
> >   seen_migrate_msg ()
> >   {
> >   	if [ $skip_migration -eq 1 ]; then
> > -		grep -q -e "Now migrate the VM" < $1
> > +	        grep -q -e "Now migrate the VM" -e "Begin continuous migratio=
n" < $1
> >   	else
> > -		grep -q -e "Now migrate the VM" -e "Skipped VM migration" < $1
> > +	        grep -q -e "Now migrate the VM" -e "Begin continuous migratio=
n" -e "Skipped VM migration" < $1
> >   	fi
> >   }
> >  =20
> > @@ -161,6 +163,7 @@ run_migration ()
> >   	src_qmpout=3D/dev/null
> >   	dst_qmpout=3D/dev/null
> >   	skip_migration=3D0
> > +	continuous_migration=3D0
> >  =20
> >   	mkfifo ${src_outfifo}
> >   	mkfifo ${dst_outfifo}
> > @@ -186,9 +189,12 @@ run_migration ()
> >   	do_migration || return $?
> >  =20
> >   	while ps -p ${live_pid} > /dev/null ; do
> > -		# Wait for test exit or further migration messages.
> > -		if ! seen_migrate_msg ${src_out} ;  then
> > +		if [[ ${continuous_migration} -eq 1 ]] ; then
>
> Here you're using "[[" for testing ...
>
> > +			do_migration || return $?
> > +		elif ! seen_migrate_msg ${src_out} ;  then
> >   			sleep 0.1
> > +		elif grep -q "Begin continuous migration" < ${src_out} ; then
> > +			do_migration || return $?
> >   		elif grep -q "Now migrate the VM" < ${src_out} ; then
> >   			do_migration || return $?
> >   		elif [ $skip_migration -eq 0 ] && grep -q "Skipped VM migration" < =
${src_out} ; then
>
> ... while the other code seems to use "[" for testing values. Can we try =
to=20
> stick to one style, please (unless it's really required to use "[[" somew=
here)?

Good point. Will do.

Thanks,
Nick

