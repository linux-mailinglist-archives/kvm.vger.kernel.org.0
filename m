Return-Path: <kvm+bounces-16998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 956788BFD1A
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 14:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B905E1C218AF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 12:27:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A19184A28;
	Wed,  8 May 2024 12:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gLPoESYB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610BE83CDB
	for <kvm@vger.kernel.org>; Wed,  8 May 2024 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715171234; cv=none; b=BrGARlf46n6pZL2Y036gaW2Ir1ceX70UGiu1kTg7LfIEVs2egFEabduMc9IK3g41xAlOcul3yRaYdx59xFhj6AjLxdzWB1zxVAVA48nHs/D0jUDAqOR/I/21WyFjCCetP5XI9j1CcnSvQJr2YXyUB3R4rNpWm0d2vL69zhnI8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715171234; c=relaxed/simple;
	bh=zEK5VGiBmVYMdEviiein7Ignei4kraq/t/66nkfr6m0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=UNQruB4tG2JxwZu4/ivyJ47lHu+VJxFDJ+0XcVW4fpf7MLwffDrdZdVbIM2+f83zm+99YiuiI73ttdLDUbqIorZEFvUcEa7MiM06L/nRZZYr1NkGcjGnIj9igWEubDazchfmPnRtcRbwAvFND4buLbFUog8busx1N+3NQKgsAjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gLPoESYB; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-61aef9901deso2963919a12.1
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 05:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715171232; x=1715776032; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tzhl7ZAW8jGRz42aowIWp6lQAQOy/vCwiQrcQ4oOFJk=;
        b=gLPoESYB+jwZucaIg5F7srAeaYwwLNR97SIk2YT8OAXPBemSUPLIysckkLemAkwNAT
         eKcTzdJ/L7ZfEIQlTZdUe8z5hHI58Np407CTyoHb/DuQUwaKdjyfH5o2YATSjJouE9Nr
         Y1k3Mo+rCXwwIbRV/P4qE6opcnFsghWmor+4stqJ8KwBIe9Vq+jVY3/iwzGDm32C4tRT
         uR8oJaSPdNyqaO7SJP6hQLI2zOF9MRx6QbuQc4kL0DFz5HjeRlR5NOhs3YVHJGOSaoC0
         GA84rC4rbqG+cnnMC4CElDs9NSUsfJuQ5ArUURuo0MxRkcxV5XYYBC/avSXN1C59+uC2
         6uxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715171232; x=1715776032;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Tzhl7ZAW8jGRz42aowIWp6lQAQOy/vCwiQrcQ4oOFJk=;
        b=Wp6Cp6qv/D2Jk5mIQ0Sf4UWYs1FBkKJdamMUQgtFGAYvm35KyXWSW9Klx45d3QwE6b
         o0rwwF7O36btOKgG9+A2QK+wcbPOJ2YhRISsBOgP8f8XjUJtLwM0tFTouWg3VovfDOyM
         ocmBKbWBJFr1CkZLldqiFRUF5pzclmRvozcLehl8hVQ0qx/xcniBpblDInaDoza+elW5
         ofjBfPdrXWUTajd8MGRAY6qInrT4qOK251FPLlKhO/szGyX29nGcidlYfLzBxEXMnqRn
         11MEeR8vHPOSZhWnHvvdTT+/LfSBn4YmkXyovXML9OJJdqFxoqJ61qR0BM9rju1+Ndt6
         BLXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwzD8CNYk5pRdqDHCxcFz6G8TlFYRwntmFzGQ0Cv6vID3xcDXyBnbwGdl4+Tjz3VsoIkE4p/qVd6jAY+4IoWO0R268
X-Gm-Message-State: AOJu0Yxr+iAWGhqFLbT94uxIx2CfdEgKhKINteC2fAzxp8zUn21iuLfe
	jRM8eZYsXQAPJLCzx++MI1e7q6uv2fK0fHmpjH1ryy8MVvsrvp3y
X-Google-Smtp-Source: AGHT+IExSIPuMSRPDbfvHtma7L54x5+aVxWuQHg9He/3VD/CbX/zKKN8vvUnUhZKdtm0xXYCF+asZg==
X-Received: by 2002:a17:90a:b38a:b0:2b4:fe80:1b1b with SMTP id 98e67ed59e1d1-2b616ae2a2fmr2221006a91.43.1715171232484;
        Wed, 08 May 2024 05:27:12 -0700 (PDT)
Received: from localhost ([1.146.8.34])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090a390800b002b622cdbc40sm1409386pjb.39.2024.05.08.05.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 05:27:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 May 2024 22:27:06 +1000
Message-Id: <D149GFR9LAZH.1X2F7YKPEJ42C@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 07/31] scripts: allow machine option
 to be specified in unittests.cfg
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-8-npiggin@gmail.com>
 <e0df1892-c17f-4fc3-b95a-4efc0af917d3@redhat.com>
In-Reply-To: <e0df1892-c17f-4fc3-b95a-4efc0af917d3@redhat.com>

On Wed May 8, 2024 at 1:08 AM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > This allows different machines with different requirements to be
> > supported by run_tests.sh, similarly to how different accelerators
> > are handled.
> >=20
> > Acked-by: Thomas Huth <thuth@redhat.com>
> > Acked-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   docs/unittests.txt   |  7 +++++++
> >   scripts/common.bash  |  8 ++++++--
> >   scripts/runtime.bash | 16 ++++++++++++----
> >   3 files changed, 25 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/docs/unittests.txt b/docs/unittests.txt
> > index 7cf2c55ad..6449efd78 100644
> > --- a/docs/unittests.txt
> > +++ b/docs/unittests.txt
> > @@ -42,6 +42,13 @@ For <arch>/ directories that support multiple archit=
ectures, this restricts
> >   the test to the specified arch. By default, the test will run on any
> >   architecture.
> >  =20
> > +machine
> > +-------
> > +For those architectures that support multiple machine types, this rest=
ricts
> > +the test to the specified machine. By default, the test will run on
> > +any machine type. (Note, the machine can be specified with the MACHINE=
=3D
> > +environment variable, and defaults to the architecture's default.)
> > +
> >   smp
> >   ---
> >   smp =3D <number>
> > diff --git a/scripts/common.bash b/scripts/common.bash
> > index 5e9ad53e2..3aa557c8c 100644
> > --- a/scripts/common.bash
> > +++ b/scripts/common.bash
> > @@ -10,6 +10,7 @@ function for_each_unittest()
> >   	local opts
> >   	local groups
> >   	local arch
> > +	local machine
> >   	local check
> >   	local accel
> >   	local timeout
> > @@ -21,7 +22,7 @@ function for_each_unittest()
> >   		if [[ "$line" =3D~ ^\[(.*)\]$ ]]; then
> >   			rematch=3D${BASH_REMATCH[1]}
> >   			if [ -n "${testname}" ]; then
> > -				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" =
"$arch" "$check" "$accel" "$timeout"
> > +				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" =
"$arch" "$machine" "$check" "$accel" "$timeout"
> >   			fi
> >   			testname=3D$rematch
> >   			smp=3D1
> > @@ -29,6 +30,7 @@ function for_each_unittest()
> >   			opts=3D""
> >   			groups=3D""
> >   			arch=3D""
> > +			machine=3D""
> >   			check=3D""
> >   			accel=3D""
> >   			timeout=3D""
> > @@ -58,6 +60,8 @@ function for_each_unittest()
> >   			groups=3D${BASH_REMATCH[1]}
> >   		elif [[ $line =3D~ ^arch\ *=3D\ *(.*)$ ]]; then
> >   			arch=3D${BASH_REMATCH[1]}
> > +		elif [[ $line =3D~ ^machine\ *=3D\ *(.*)$ ]]; then
> > +			machine=3D${BASH_REMATCH[1]}
> >   		elif [[ $line =3D~ ^check\ *=3D\ *(.*)$ ]]; then
> >   			check=3D${BASH_REMATCH[1]}
> >   		elif [[ $line =3D~ ^accel\ *=3D\ *(.*)$ ]]; then
> > @@ -67,7 +71,7 @@ function for_each_unittest()
> >   		fi
> >   	done
> >   	if [ -n "${testname}" ]; then
> > -		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$=
arch" "$check" "$accel" "$timeout"
> > +		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$=
arch" "$machine" "$check" "$accel" "$timeout"
> >   	fi
> >   	exec {fd}<&-
> >   }
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 177b62166..0c96d6ea2 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -32,7 +32,7 @@ premature_failure()
> >   get_cmdline()
> >   {
> >       local kernel=3D$1
> > -    echo "TESTNAME=3D$testname TIMEOUT=3D$timeout ACCEL=3D$accel $RUNT=
IME_arch_run $kernel -smp $smp $opts"
> > +    echo "TESTNAME=3D$testname TIMEOUT=3D$timeout MACHINE=3D$machine A=
CCEL=3D$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> >   }
> >  =20
> >   skip_nodefault()
> > @@ -80,9 +80,10 @@ function run()
> >       local kernel=3D"$4"
> >       local opts=3D"$5"
> >       local arch=3D"$6"
> > -    local check=3D"${CHECK:-$7}"
> > -    local accel=3D"$8"
> > -    local timeout=3D"${9:-$TIMEOUT}" # unittests.cfg overrides the def=
ault
> > +    local machine=3D"$7"
> > +    local check=3D"${CHECK:-$8}"
> > +    local accel=3D"$9"
> > +    local timeout=3D"${10:-$TIMEOUT}" # unittests.cfg overrides the de=
fault
> >  =20
> >       if [ "${CONFIG_EFI}" =3D=3D "y" ]; then
> >           kernel=3D${kernel/%.flat/.efi}
> > @@ -116,6 +117,13 @@ function run()
> >           return 2
> >       fi
> >  =20
> > +    if [ -n "$machine" ] && [ -n "$MACHINE" ] && [ "$machine" !=3D "$M=
ACHINE" ]; then
> > +        print_result "SKIP" $testname "" "$machine only"
> > +        return 2
> > +    elif [ -n "$MACHINE" ]; then
> > +        machine=3D"$MACHINE"
> > +    fi
> > +
> >       if [ -n "$accel" ] && [ -n "$ACCEL" ] && [ "$accel" !=3D "$ACCEL"=
 ]; then
> >           print_result "SKIP" $testname "" "$accel only, but ACCEL=3D$A=
CCEL"
> >           return 2
>
> For some reasons that I don't quite understand yet, this patch causes the=
=20
> "sieve" test to always timeout on the s390x runner, see e.g.:
>
>   https://gitlab.com/thuth/kvm-unit-tests/-/jobs/6798954987

How do you use the s390x runner?

>
> Everything is fine in the previous patches (I pushed now the previous 5=
=20
> patches to the repo):
>
>   https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/pipelines/1281919104
>
> Could it be that he TIMEOUT gets messed up in certain cases?

Hmm not sure yet. At least it got timeout right for the duration=3D90s
message.

Thanks,
Nick

