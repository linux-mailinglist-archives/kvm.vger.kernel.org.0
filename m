Return-Path: <kvm+bounces-10859-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC2A5871404
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6717E1F21A05
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E9F2941F;
	Tue,  5 Mar 2024 02:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HhvGQNIl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175D53FE37;
	Tue,  5 Mar 2024 02:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709607527; cv=none; b=rOj5gQOl+LJw+1akpph281+OOpk0uxSLTKHv21DUL1zrBlf9R/c8nUPIc8kWGOJU1FnFrm5q/tVzuUskpgXuc7+tQaJGCpMScnzwJcn6xzZowEQXk1EkC8dex6Xo3U6/UYVhS0lDUwRiYgVEHSce3hmyud6K+twMr/gSwVjcmwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709607527; c=relaxed/simple;
	bh=XmPcT7/mDIdmg30Rwv5piHQCNZacxqeTxPu2Oyby+hg=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=uVOsS3rvpC6tfSvd1a0ujiTLzd5xmIqRyz4aO+vRNBSkN6sMvIPu+GXK/xFkMXofWiFe+w7STDGqkDsvtQ0uNZwdSQ6j74eerSS77Pu19jYWbvekusb3LCEwrhI1jDy/jq/hnxXjKiHCnf3j1rcmuUialOwOFYDJQTph0K2EA7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HhvGQNIl; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1dba177c596so32115965ad.0;
        Mon, 04 Mar 2024 18:58:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709607525; x=1710212325; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCrs5zL2Khs7cSmXK351HQUe+lXmYGGNniszlyDGHZU=;
        b=HhvGQNIlriYi2IAV67P345VvcrtqgADf21+/8ajDl01r6wxLHXy/iNR3K9NKmXwpwD
         Cs+ZWxVdk09apxeO98PGYedFSz98xXRqpgeMUK7+8K8Ae1azi5T5roPdJETbunwpWsDv
         QUXEU0yu3BK8PToHtqNq+YgQykf1KLNAG/KNRF/rpKVykuHqoyq0rxWVeOXkRMVG2Fx1
         NyjGop2MHSq0WF+TtJ/wWyFjXjc1crx1GhyQi1qAXbuVGJpc9jeAyiE53uyEaz9tBMfg
         L2Mh4Qhzn0QGxSjUC+PaqxrdKgAvIyPftyzQQxONvshB1gzkPKCmygNY7+rfOSQ6RyUf
         OhRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709607525; x=1710212325;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RCrs5zL2Khs7cSmXK351HQUe+lXmYGGNniszlyDGHZU=;
        b=f5JCwvUtx7xPUB7QeaPuVFpD5ySscL5uGY/P0t6QQEzTJpDUwEjsHljy7DUlcy/CyB
         H1mdxJPDNBSqccQW/sWAyjTudAW/galLZ7DTFxbrse3S8nu+OuIXjqS0zlCKDYgqq4UB
         n9UXMew7jxg51RF5Qv0VWRxJnjuF0ZhShdv7kvXHMEBVVylT3HgWjaWb942DNgYNkCg1
         eE2M/+k2jIPHAQlo+Rco8s6cs4asQFEJMRFJY37dJx5hehpcw9OmYIWmIy9LNEPNHbKr
         L8yR4RyYle0vqiWjC9TNBmn0ngbtUxcAf3fDsUmzMiQ+R7XT+4AWQ6yooGGAM43ewRTj
         OdqA==
X-Forwarded-Encrypted: i=1; AJvYcCU9mk/Xt0ozOVsuBE6afqtp+onkblVIOyzk0bxIGXjR7s90dQeyBy5TF7KgNMKYzvU1om8sseL9k1yzKT14RJFp78SLYaPIlc6Juw==
X-Gm-Message-State: AOJu0YypSKIk4IucCWzkx+mP1QjQZ6jQqAnrGIMa8cGL783tyq6P8/tn
	3hqrHuHONLE9nVo+ZDsUr3ffHaNejbdyjVNtf+ziMr4MrcDdz+Ex
X-Google-Smtp-Source: AGHT+IGvX119Qxv0r58vHXRmQz8eKsM7NGWAogePZFvA0DiMODh/Cp/tprnaiunm19Il0MiXx20R0w==
X-Received: by 2002:a17:903:2443:b0:1dc:b887:35bd with SMTP id l3-20020a170903244300b001dcb88735bdmr908023pls.5.1709607525321;
        Mon, 04 Mar 2024 18:58:45 -0800 (PST)
Received: from localhost (220-235-220-130.tpgi.com.au. [220.235.220.130])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902dac700b001dc23e877c9sm9271707plx.106.2024.03.04.18.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:58:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 05 Mar 2024 12:58:37 +1000
Message-Id: <CZLHAB0NZDIK.32S3A33LM1GWC@wheely>
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <ajones@ventanamicro.com>, "Thomas Huth"
 <thuth@redhat.com>
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
X-Mailer: aerc 0.15.2
References: <20240226093832.1468383-1-npiggin@gmail.com>
 <20240226093832.1468383-6-npiggin@gmail.com>
 <6329dd4c-2093-40c3-8eb8-701d8e8b2ecd@redhat.com>
 <20240304-e416eb5a087bde2cad5ff325@orel>
In-Reply-To: <20240304-e416eb5a087bde2cad5ff325@orel>

On Mon Mar 4, 2024 at 7:19 PM AEST, Andrew Jones wrote:
> On Mon, Mar 04, 2024 at 07:17:35AM +0100, Thomas Huth wrote:
> > On 26/02/2024 10.38, Nicholas Piggin wrote:
> > > The cooperative migration protocol is very good to control precise
> > > pre and post conditions for a migration event. However in some cases
> > > its intrusiveness to the test program, can mask problems and make
> > > analysis more difficult.
> > >=20
> > > For example to stress test migration vs concurrent complicated
> > > memory access, including TLB refill, ram dirtying, etc., then the
> > > tight spin at getchar() and resumption of the workload after
> > > migration is unhelpful.
> > >=20
> > > This adds a continuous migration mode that directs the harness to
> > > perform migrations continually. This is added to the migration
> > > selftests, which also sees cooperative migration iterations reduced
> > > to avoid increasing test time too much.
> > >=20
> > > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > > ---
> > >   common/selftest-migration.c | 16 +++++++++--
> > >   lib/migrate.c               | 18 ++++++++++++
> > >   lib/migrate.h               |  3 ++
> > >   scripts/arch-run.bash       | 55 ++++++++++++++++++++++++++++++++--=
---
> > >   4 files changed, 82 insertions(+), 10 deletions(-)
> > >=20
> > > diff --git a/common/selftest-migration.c b/common/selftest-migration.=
c
> > > index 0afd8581c..9a9b61835 100644
> > > --- a/common/selftest-migration.c
> > > +++ b/common/selftest-migration.c
> > > @@ -9,12 +9,13 @@
> > >    */
> > >   #include <libcflat.h>
> > >   #include <migrate.h>
> > > +#include <asm/time.h>
> > > -#define NR_MIGRATIONS 30
> > > +#define NR_MIGRATIONS 15
> > >   int main(int argc, char **argv)
> > >   {
> > > -	report_prefix_push("migration");
> > > +	report_prefix_push("migration harness");
> > >   	if (argc > 1 && !strcmp(argv[1], "skip")) {
> > >   		migrate_skip();
> > > @@ -24,7 +25,16 @@ int main(int argc, char **argv)
> > >   		for (i =3D 0; i < NR_MIGRATIONS; i++)
> > >   			migrate_quiet();
> > > -		report(true, "simple harness stress");
> > > +		report(true, "cooperative migration");
> > > +
> > > +		migrate_begin_continuous();
> > > +		mdelay(2000);
> > > +		migrate_end_continuous();
> > > +		mdelay(1000);
> > > +		migrate_begin_continuous();
> > > +		mdelay(2000);
> > > +		migrate_end_continuous();
> > > +		report(true, "continuous migration");
> > >   	}
> > >   	report_prefix_pop();
> > > diff --git a/lib/migrate.c b/lib/migrate.c
> > > index 1d22196b7..770f76d5c 100644
> > > --- a/lib/migrate.c
> > > +++ b/lib/migrate.c
> > > @@ -60,3 +60,21 @@ void migrate_skip(void)
> > >   	puts("Skipped VM migration (quiet)\n");
> > >   	(void)getchar();
> > >   }
> > > +
> > > +void migrate_begin_continuous(void)
> > > +{
> > > +	puts("Begin continuous migration\n");
> > > +	(void)getchar();
> > > +}
> > > +
> > > +void migrate_end_continuous(void)
> > > +{
> > > +	/*
> > > +	 * Migration can split this output between source and dest QEMU
> > > +	 * output files, print twice and match once to always cope with
> > > +	 * a split.
> > > +	 */
> > > +	puts("End continuous migration\n");
> > > +	puts("End continuous migration (quiet)\n");
> > > +	(void)getchar();
> > > +}
> > > diff --git a/lib/migrate.h b/lib/migrate.h
> > > index db6e0c501..35b6703a2 100644
> > > --- a/lib/migrate.h
> > > +++ b/lib/migrate.h
> > > @@ -11,3 +11,6 @@ void migrate_quiet(void);
> > >   void migrate_once(void);
> > >   void migrate_skip(void);
> > > +
> > > +void migrate_begin_continuous(void);
> > > +void migrate_end_continuous(void);
> > > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > > index d0f6f098f..5c7e72036 100644
> > > --- a/scripts/arch-run.bash
> > > +++ b/scripts/arch-run.bash
> > > @@ -125,15 +125,17 @@ qmp_events ()
> > >   filter_quiet_msgs ()
> > >   {
> > >   	grep -v "Now migrate the VM (quiet)" |
> > > +	grep -v "Begin continuous migration (quiet)" |
> > > +	grep -v "End continuous migration (quiet)" |
> > >   	grep -v "Skipped VM migration (quiet)"
> > >   }
> > >   seen_migrate_msg ()
> > >   {
> > >   	if [ $skip_migration -eq 1 ]; then
> > > -		grep -q -e "Now migrate the VM" < $1
> > > +	        grep -q -e "Now migrate the VM" -e "Begin continuous migrat=
ion" < $1
> > >   	else
> > > -		grep -q -e "Now migrate the VM" -e "Skipped VM migration" < $1
> > > +	        grep -q -e "Now migrate the VM" -e "Begin continuous migrat=
ion" -e "Skipped VM migration" < $1
> > >   	fi
> > >   }
> > > @@ -161,6 +163,7 @@ run_migration ()
> > >   	src_qmpout=3D/dev/null
> > >   	dst_qmpout=3D/dev/null
> > >   	skip_migration=3D0
> > > +	continuous_migration=3D0
> > >   	mkfifo ${src_outfifo}
> > >   	mkfifo ${dst_outfifo}
> > > @@ -186,9 +189,12 @@ run_migration ()
> > >   	do_migration || return $?
> > >   	while ps -p ${live_pid} > /dev/null ; do
> > > -		# Wait for test exit or further migration messages.
> > > -		if ! seen_migrate_msg ${src_out} ;  then
> > > +		if [[ ${continuous_migration} -eq 1 ]] ; then
> >=20
> > Here you're using "[[" for testing ...
> >=20
> > > +			do_migration || return $?
> > > +		elif ! seen_migrate_msg ${src_out} ;  then
> > >   			sleep 0.1
> > > +		elif grep -q "Begin continuous migration" < ${src_out} ; then
> > > +			do_migration || return $?
> > >   		elif grep -q "Now migrate the VM" < ${src_out} ; then
> > >   			do_migration || return $?
> > >   		elif [ $skip_migration -eq 0 ] && grep -q "Skipped VM migration" =
< ${src_out} ; then
> >=20
> > ... while the other code seems to use "[" for testing values. Can we tr=
y to
> > stick to one style, please (unless it's really required to use "[["
> > somewhere)?
> >
>
> We should decide on a Bash coding style and on preferences like [[ and
> then write a document for it, as well as create a set of shellcheck
> includes/excludes to test it. Then, using shellcheck we'd change all our
> current Bash code and also require shellcheck to pass on all new code
> before merge.

Seems like a good idea.

> Any volunteers for that effort? For the style selection
> we can take inspiration from other projects or even just adopt their
> style guides. Google has some guidance[1][2] and googling for Bash style
> pops up other hits.
>
> [1] https://google.github.io/styleguide/shellguide.html
> [2] https://chromium.googlesource.com/chromiumos/docs/+/master/styleguide=
/shell.md

My bash skills consit of mashing the keyboard until the errors quieten
down, so I may not be the best to decide on this stuff. I could take a
look at getting the checker running in make and post an RFC though. No
promises if it turns out to be harder than it looks...

Thanks,
Nick

