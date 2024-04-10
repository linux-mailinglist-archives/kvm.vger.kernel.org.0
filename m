Return-Path: <kvm+bounces-14065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9828B89E8EE
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 06:34:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D15A11C22B7C
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 04:34:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E25DBA2B;
	Wed, 10 Apr 2024 04:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bqc5iKiu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374066110;
	Wed, 10 Apr 2024 04:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712723685; cv=none; b=qnzzbXSoKlukBvQnV4Ug8/ldYWoDfjwDryuyy5DOf0TE8iXzu+2G2/pZp+Nxp9xQiIliP2PVRxR2LFITcNx1JRQkNqtsNdFZVFa/xSxSXjJZJefkjmKZVlczOVV1kl7lMqBwBU/YiijqqsnHhM+J1Ok8eyAGoP4cWJjs1Vmvkso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712723685; c=relaxed/simple;
	bh=Uwy9cLaf+wVH3Y+GzKGwg/mcZ84M2g+2BFnT+jf2eQw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=f2dDAU48b1esDNanmsvTfxksoBE2todJnyHYxuV/9fq9yTx4N24dFSEnYEozdpnd94WSrcCsMfzIbwtpJ8ayA6mPHmWIc4+uCLz4J71okXzBA/wdQA1TvK45nvFXMvTdN9Bv2M33K/iIYEDlI1nAoZha51sxByfAyrp0u0Ohlf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bqc5iKiu; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1e3f17c64daso23646155ad.3;
        Tue, 09 Apr 2024 21:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712723683; x=1713328483; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdnOfxg1zEAXeO9zBjumZTmP0t6Cdrrr7sd1o3ojeNg=;
        b=bqc5iKiuMMwfcY4s2HPra9kKGjjKeCPwrMkCJ6PVGpG3K+KfmX3Yy6fogYoBChItpq
         RskkKfKOumtKaihfAD9vZATIKDzeuQNcd6eSSmtNpWmxvfj9jUqFAqh6fomHeVjcsLvL
         HD1e1VUxxDm5DQVmeuIZd60nh/wD5mUYjF/54XDgKqE3F94fVgLcRVy4J/9WAGCuKXYk
         bZptIZcyaVx/7lOPe2Xs5B4SG5RI+UhpvVjfzi1376DT3bPkL3OhSxkficfDup5+IZb/
         qgbeOU50Jh0U5gKc9NabdxIQ7HLMODehvBP73Wzb9drT5YOZKSchMkYmQLB6tmqIQtiJ
         vGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712723683; x=1713328483;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WdnOfxg1zEAXeO9zBjumZTmP0t6Cdrrr7sd1o3ojeNg=;
        b=HEI3fY5QBhdPx6x8s8R6ECqMR2Jg/JPLergr1K1tEXbNpFi00wWJTrNd0XYBQ13Tug
         1BvmzDJTunM/qvqpwRWdpUKZFYedEYtsk4l6Dx7dmA+lMRzjvxpLcKP2Ks+789abTvKY
         RP9Z96LjW//I0o+zfTW4vkndqVfEZvf68MTnKKl39hdnp03ayQxDFPyzA4iXp3rV0Q5a
         w1ouRnYFdvhVm8291mhETfMQvFwAMvq2WkU+wyn37OHL68ra2Dv5t/zuIct0Y6FklG4B
         tIW6xYrRZaPY2XBndAVlFsQ//Qgzcb/Kbw2WQ0e+/oXY6aosF6rGiB6PJK4bm7EQesxW
         spnA==
X-Forwarded-Encrypted: i=1; AJvYcCVpf7ev0jh4rsbNIEKdvqdvLyKbtT/fz382uXGH2m1hmHnh2BzQ9KsIVLf5smG2JYGOJk5joi9VesIJvi5He8cv0hVSy7KsIjkM5Omy8+QH5O9vPBvBwDUIxpJd0Jqv6Q==
X-Gm-Message-State: AOJu0YybofSmYBN/Ph4ZCUodKAhgwmdVzd75e71OdNX/OV8xbFX7c8Pg
	rj0u8GSra0/xiwSZB4l4gkVUoepLzcIm8vhLR+R6UKH4T07ZLJ1B
X-Google-Smtp-Source: AGHT+IFediIiTOkmS1V3XfkACbU1O1MCePtIrUsxoRnvEMxwJ9hEGOvWZQe2sHYxkmL+s0eSEQYjTg==
X-Received: by 2002:a17:902:e5c2:b0:1e4:55d8:dfae with SMTP id u2-20020a170902e5c200b001e455d8dfaemr1935502plf.4.1712723683374;
        Tue, 09 Apr 2024 21:34:43 -0700 (PDT)
Received: from localhost ([1.146.50.27])
        by smtp.gmail.com with ESMTPSA id 12-20020a170902e9cc00b001defa97c6basm9721731plk.235.2024.04.09.21.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 21:34:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Apr 2024 14:34:25 +1000
Message-Id: <D0G5V9Z62QS1.1BWMOLQZWBO5T@gmail.com>
Cc: "Thomas Huth" <thuth@redhat.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
 "David Hildenbrand" <david@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linux-s390@vger.kernel.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 2/2] s390x: Fix is_pv check in run script
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240406122456.405139-1-npiggin@gmail.com>
 <20240406122456.405139-3-npiggin@gmail.com>
 <20240408133629.34a2e34c@p-imbrenda>
In-Reply-To: <20240408133629.34a2e34c@p-imbrenda>

On Mon Apr 8, 2024 at 9:36 PM AEST, Claudio Imbrenda wrote:
> On Sat,  6 Apr 2024 22:24:54 +1000
> Nicholas Piggin <npiggin@gmail.com> wrote:
>
> > Shellcheck reports "is_pv references arguments, but none are ever
> > passed." and suggests "use is_pv "$@" if function's $1 should mean
> > script's $1."
> >=20
> > The is_pv test does not evaluate to true for .pv.bin file names, only
> > for _PV suffix test names. The arch_cmd_s390x() function appends
> > .pv.bin to the file name AND _PV to the test name, so this does not
> > affect run_tests.sh runs, but it might prevent PV tests from being
> > run directly with the s390x-run command.
> >=20
> > Reported-by: shellcheck SC2119, SC2120
> > Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: bcedc5a2 ("s390x: run PV guests with confidential guest enabled")

Thanks.

> although tbh I would rewrite it to check a variable, something like:
>
> IS_PV=3Dno
> [ "${1: -7}" =3D ".pv.bin" -o "${TESTNAME: -3}" =3D "_PV" ] && IS_PV=3Dye=
s

I don't have a problem if you want to fix it a different way
instead. I don't have a good way to test at the moment and
this seemed the simplest fix. Shout out if you don't want it
going upstream as is.

Thanks,
Nick

>
> > ---
> >  s390x/run | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/s390x/run b/s390x/run
> > index e58fa4af9..34552c274 100755
> > --- a/s390x/run
> > +++ b/s390x/run
> > @@ -21,12 +21,12 @@ is_pv() {
> >  	return 1
> >  }
> > =20
> > -if is_pv && [ "$ACCEL" =3D "tcg" ]; then
> > +if is_pv "$@" && [ "$ACCEL" =3D "tcg" ]; then
>
> if [ "$IS_PV" =3D "yes" -a "$ACCEL" =3D "tcg" ]; then
>
> etc...
>
> >  	echo "Protected Virtualization isn't supported under TCG"
> >  	exit 2
> >  fi
> > =20
> > -if is_pv && [ "$MIGRATION" =3D "yes" ]; then
> > +if is_pv "$@" && [ "$MIGRATION" =3D "yes" ]; then
> >  	echo "Migration isn't supported under Protected Virtualization"
> >  	exit 2
> >  fi
> > @@ -34,12 +34,12 @@ fi
> >  M=3D'-machine s390-ccw-virtio'
> >  M+=3D",accel=3D$ACCEL$ACCEL_PROPS"
> > =20
> > -if is_pv; then
> > +if is_pv "$@"; then
> >  	M+=3D",confidential-guest-support=3Dpv0"
> >  fi
> > =20
> >  command=3D"$qemu -nodefaults -nographic $M"
> > -if is_pv; then
> > +if is_pv "$@"; then
> >  	command+=3D" -object s390-pv-guest,id=3Dpv0"
> >  fi
> >  command+=3D" -chardev stdio,id=3Dcon0 -device sclpconsole,chardev=3Dco=
n0"


