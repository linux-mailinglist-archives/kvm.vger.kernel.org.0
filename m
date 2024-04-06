Return-Path: <kvm+bounces-13787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4589D89A959
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 08:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC2BA1F2341F
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 06:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EBBA2110F;
	Sat,  6 Apr 2024 06:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fNOLXNZ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29C90125C1;
	Sat,  6 Apr 2024 06:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712385091; cv=none; b=aSUuMNdPzFl/k/Vb9/5LlgRpMCVbnGwWPTT19mmFsxq4u51JrZlZZAY/vMJ8whNNih/6pq/EBHgw2jTK7W+vGEwWh1cYjIt271t92v8itUbNvcm8XEasHNw1MBleXnRcl49OaXsQOQtHWfnHjbPgM0WyrtWKiyJ9feYMpkTW2xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712385091; c=relaxed/simple;
	bh=KV/wB10K9PldvqN8/z4eMzHUcgIzx9r1HmzzSRp81s8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=Dt51vv3cmPxBfNvRBIE/ixZda3D013igtSTG9MbGPkU7vEBJZqxIf05IZTWwP58APhSuxrrzoBg8ZdmpmfSNhZ0bMilyuDFOWLFjSsLLL5mV1md0m1f6AtDNHQZHL60C/h/dXybEBLi8af/76/qLz2Ld5DXvXSgKzLfTcRG7JDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fNOLXNZ/; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ecea46e1bfso2609513b3a.3;
        Fri, 05 Apr 2024 23:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712385088; x=1712989888; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3gFO0LBD4TsLCWewzw78bLLIgfF1Yq2lATDwkzzjxE=;
        b=fNOLXNZ/wIcdOy8njSjN+S6b8OHi3iKTruGohgQPigzeaD2T99as2OT7uoYSFL+2Ex
         yY9eQVTQl6G42WvPorC5EGR0tb7SPvmw67z1Po2me+G/fptQHRHxLfxqKZ97dKSu1PLz
         3zljGz0r4XKwriVj2OgSEwzNW9xK5wqTJvlA+tawIrwT3W0yiCWZ2nOGttlMD407I6D5
         RzxitXwwRvQpGcXdBODLD9BCG33jH07P1IqRfbIn6ojwqYxfVsV+MRHtHor5/b9llT4X
         /1gmXoaG9gTxduOyagmWShV758QW4CRp2sZtef8IOROckpgGDDUklAMk0t2jUJmsVmQt
         cuPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712385088; x=1712989888;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=C3gFO0LBD4TsLCWewzw78bLLIgfF1Yq2lATDwkzzjxE=;
        b=XYoNoHendfEb1kaocdpN7GSwLo7ennQDNAkYfU3ciLjWGY3mZ50g4gqUKIFhQew2My
         2SdsnDW4N2/Z6/XZ44TuAK3la64/tLHEi7pKnfxK9NJYJcJWjM1tUIxXuo/2BZAjKJkd
         znJrAg4RZDcQfJzJFMKYYw/nAq7CMNscPs0D3c5p5Vbp62vKOpU9x0BUAt0cdrd3O65i
         Rt+BIoTZkSMZITjtVhv5fzuwLV9dDdvrcjHZS9QO/Mt5qKvCnsZ0Y+JdQqccS97TLowb
         DuJqeNhvZXtg3T3HYV2ViN3+3PXO0WBEXTX3EQR0lhgZzRE4LQu0SH5nYk+fDwQ3uZ8x
         Gw0g==
X-Forwarded-Encrypted: i=1; AJvYcCWAVnMvFSawD4PkjGhM4ALfOkVHFMSYypQFMFYxcbH3yU4nYFmyC+avrPau2h5oTdOJ3dLaj642E1VVjtViG4JpIIqiqFL3hopEt4NfAySCNYWrjxu3tpIceytv+CDGZg==
X-Gm-Message-State: AOJu0YxpuVnDt+uEJmBWII1Y9VF+HCN3PAib8l4fi2+T5y4v+W0QZRzH
	xtUic0SvDo+LQ4afqIhpNMoJF4rCULJYUb2hTipe7ZguBm5oQxJK
X-Google-Smtp-Source: AGHT+IFALmVk08NKzMWMyCDJd6QtuwmTTglOMhS/paEBbUp86/OqFJdFQ+4zrRK30sQPpbpFcknh1Q==
X-Received: by 2002:aa7:8893:0:b0:6ec:ed90:65ea with SMTP id z19-20020aa78893000000b006eced9065eamr3711769pfe.32.1712385088140;
        Fri, 05 Apr 2024 23:31:28 -0700 (PDT)
Received: from localhost (124-169-104-130.tpgi.com.au. [124.169.104.130])
        by smtp.gmail.com with ESMTPSA id km23-20020a056a003c5700b006e6bf17ba8asm2549066pfb.65.2024.04.05.23.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Apr 2024 23:31:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 06 Apr 2024 16:31:17 +1000
Message-Id: <D0CTUKHP4IZV.2OQZNUD6J9U1P@gmail.com>
Subject: Re: [kvm-unit-tests RFC PATCH 17/17] shellcheck: Suppress various
 messages
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
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
X-Mailer: aerc 0.17.0
References: <20240405090052.375599-1-npiggin@gmail.com>
 <20240405090052.375599-18-npiggin@gmail.com>
 <20240405-7c0ad5d3ce76e1ad9ad2f5a9@orel>
In-Reply-To: <20240405-7c0ad5d3ce76e1ad9ad2f5a9@orel>

On Sat Apr 6, 2024 at 12:55 AM AEST, Andrew Jones wrote:
> On Fri, Apr 05, 2024 at 07:00:49PM +1000, Nicholas Piggin wrote:
> > Various info and warnings are suppressed here, where circumstances
> > (commented) warrant.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  run_tests.sh            | 3 +++
> >  scripts/arch-run.bash   | 9 +++++++++
> >  scripts/mkstandalone.sh | 2 ++
> >  scripts/runtime.bash    | 2 ++
> >  4 files changed, 16 insertions(+)
> >=20
> > diff --git a/run_tests.sh b/run_tests.sh
> > index 938bb8edf..152323ffc 100755
> > --- a/run_tests.sh
> > +++ b/run_tests.sh
> > @@ -45,6 +45,9 @@ fi
> >  only_tests=3D""
> >  list_tests=3D""
> >  args=3D$(getopt -u -o ag:htj:vl -l all,group:,help,tap13,parallel:,ver=
bose,list,probe-maxsmp -- "$@")
> > +# Shellcheck likes to test commands directly rather than with $? but s=
ometimes they
> > +# are too long to put in the same test.
> > +# shellcheck disable=3DSC2181
> >  [ $? -ne 0 ] && exit 2;
> >  set -- $args;
> >  while [ $# -gt 0 ]; do
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index ed440b4aa..fe8785cfd 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -44,6 +44,8 @@ run_qemu ()
> >  	if [ "$errors" ]; then
> >  		sig=3D$(grep 'terminating on signal' <<<"$errors")
> >  		if [ "$sig" ]; then
> > +			# This is too complex for ${var/search/replace}
> > +			# shellcheck disable=3DSC2001
> >  			sig=3D$(sed 's/.*terminating on signal \([0-9][0-9]*\).*/\1/' <<<"$=
sig")
> >  		fi
> >  	fi
> > @@ -174,9 +176,12 @@ run_migration ()
> > =20
> >  	# Holding both ends of the input fifo open prevents opens from
> >  	# blocking and readers getting EOF when a writer closes it.
> > +	# These fds appear to be unused to shellcheck so quieten the warning.
> >  	mkfifo ${src_infifo}
> >  	mkfifo ${dst_infifo}
> > +	# shellcheck disable=3DSC2034
> >  	exec {src_infifo_fd}<>${src_infifo}
> > +	# shellcheck disable=3DSC2034
> >  	exec {dst_infifo_fd}<>${dst_infifo}
> > =20
> >  	"${migcmdline[@]}" \
> > @@ -184,6 +189,8 @@ run_migration ()
> >  		-mon chardev=3Dmon,mode=3Dcontrol \
> >  		< ${src_infifo} > ${src_outfifo} &
> >  	live_pid=3D$!
> > +	# SC complains about useless cat but I prefer it over redirect here.
>
> Let's spell out 'shellcheck' when referring to it rather than call it
> 'SC'. And instead of "but I prefer..." let's write
>
>  # shellcheck complains about a useless cat, but using a redirect here is
>  # harder to read

Sounds good, will do.

>
> or something like that. Don't tell my cat-loving daughter that I just
> wrote "a useless cat"!

:D

>
>
> > +	# shellcheck disable=3DSC2002
> >  	cat ${src_outfifo} | tee ${src_out} | filter_quiet_msgs &
> > =20
> >  	# Start the first destination QEMU machine in advance of the test
> > @@ -224,6 +231,8 @@ do_migration ()
> >  		-mon chardev=3Dmon,mode=3Dcontrol -incoming unix:${dst_incoming} \
> >  		< ${dst_infifo} > ${dst_outfifo} &
> >  	incoming_pid=3D$!
> > +	# SC complains about useless cat but I prefer it over redirect here.
>
> Same comment as above.
>
> > +	# shellcheck disable=3DSC2002
> >  	cat ${dst_outfifo} | tee ${dst_out} | filter_quiet_msgs &
> > =20
> >  	# The test must prompt the user to migrate, so wait for the
> > diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> > index 756647f29..2318a85f0 100755
> > --- a/scripts/mkstandalone.sh
> > +++ b/scripts/mkstandalone.sh
> > @@ -65,6 +65,8 @@ generate_test ()
> >  	fi
> > =20
> >  	temp_file bin "$kernel"
> > +	# Don't want to expand $bin but print it as-is.
> > +	# shellcheck disable=3DSC2016
> >  	args[3]=3D'$bin'
> > =20
> >  	(echo "#!/usr/bin/env bash"
> > diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> > index 3b76aec9e..c87613b96 100644
> > --- a/scripts/runtime.bash
> > +++ b/scripts/runtime.bash
> > @@ -137,6 +137,8 @@ function run()
> >      # the check line can contain multiple files to check separated by =
a space
> >      # but each check parameter needs to be of the form <path>=3D<value=
>
> >      if [ "$check" ]; then
> > +        # There is no globbing allowed in the check parameter.
> > +        # shellcheck disable=3DSC2206
> >          check=3D($check)
>
> Hmm, I'm not sure about this one. $check is an arbitrary path, which mean=
s
> it can have spaces, then =3D, and then an arbitrary value, which means it=
 can
> contain spaces. If there are multiple check path=3Dvalue pairs then
> separation by space is a bad idea, and any deliminator really is. It seem=
s
> like each pair should be quoted, i.e.
>
>  check =3D "path1=3Dvalue1" "path2=3Dvalue2"
>
> and then that should be managed here.

Yeah I did think of that, valid paths could also have =3D and ", and even
with double quotes it seems to be tricky to handle spaces.

Maybe I'll just add to the unittest.cfg docs to stick with alphanumeric
paths, and we can improve it if someone complains?

Thanks,
Nick

