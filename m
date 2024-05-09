Return-Path: <kvm+bounces-17096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 794298C0B1B
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 07:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 019D5281DCC
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 05:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E5D1494AB;
	Thu,  9 May 2024 05:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UxJIRiS9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980E0C13C
	for <kvm@vger.kernel.org>; Thu,  9 May 2024 05:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715233475; cv=none; b=ep4ivWiP9OOLMDVYsHJZ2NbvCsvhL0MTWf+jYo1vktyR8cgfgp4rAX5GI+OIy4b03cp8sOD92pQRLzm/aqvyFJHRSQ7o9+64M4Dw87MseDEJ5ploxO8DZ0U/0QazdajUOgtX0wzmLAK5PFV+AnUBgNgUlTVNp0V1oAkwXUWDhs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715233475; c=relaxed/simple;
	bh=rWY6owxGWaT0K4KnL0t1XoHYa61/+PJJDoCVgrNMLOA=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=L7x61LA+ZbdieD4lzJOv8BvktJVASMnrPTl93UcEN+y645CWpen2yjlHWwbNRRPL+Fp/yZ7OYeUtwR5A+ewTkKsLVeShWhpwMbLsWzt4ZiB471qALGBycjlyyNC9e+IMARSCzg2z/Fizfl8HM7/4seFREWd4gWXTuZ4ffH0FrHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UxJIRiS9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1ed41eb3382so3365875ad.0
        for <kvm@vger.kernel.org>; Wed, 08 May 2024 22:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715233473; x=1715838273; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AJWRqriluNl85+42GdgojZnsAFr/eRJv/kXU3cwJsng=;
        b=UxJIRiS9P4XQ5MGdkDmU6nbI0yuNKpGQTdtzf1p113fk6ehvsur9ABxnoqkzN0HXi5
         G39lgz+yKztm4sz1NV13JIjjBXukrTnFsAtlt785d2MFlgRYi9Y+6XYr5xdRfu+y/d/o
         fdxrFlgt2Uo2sp2T5EF+DQL+WVDiTVp+RbDn3M1J3A7y5K+gxXm+wQmh9w0lqqeYFVVa
         dg0qGGeklm9q7nx7HmLfCpOzsgsSnq6zFS9atDL2ddTQoXTrP7aeZfDEqz1LmuYKpRLm
         hTfLntTUAGwchegtUN22Ccv7sIeAD73q2xQ5oc8IVZwmgkmgtToINxheKWopWiAkOfts
         8ecA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715233473; x=1715838273;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AJWRqriluNl85+42GdgojZnsAFr/eRJv/kXU3cwJsng=;
        b=Jy2ObV2kqKc1Ripe6Q7r0hixFItxw0wOrtpHk3YlmRHaAh0g8+ruDRr7ba6tYVLr5K
         1lMmXMxMMOfg0gnpSlWiTlNl3O0qRTzsVfy+9KeCEB1EqbwshCjNVg4Ds3pFPKw7eS7f
         5+A4aa22X/5ZeiKDrIWbpL/5kp+4tqnyfV/NxQw5g332c47EVsJAjP0kINEhWaLKcbwK
         zH+TE/v3R3nPInMunkEHjj0/PQpsFwsMS9LKL5JLClrM0JI34syRIOhRM9MU1Dy0+EbD
         MAhWIvFVA7+e8BlHBjD7NwjHk4v8U7Fpm+l+Txc8JUzKa+PneUiUritGFq6MjQcsqqwI
         fySw==
X-Gm-Message-State: AOJu0Yw6Vx5wVG7u4vi7oQvcqkH3YMUeakoPXOe8ggyWzIwL0LmxuuSe
	NG2Q/Agl20AU23rDJF+jgC0QraplBajgmb0LtaMvQG6ssFour6x2
X-Google-Smtp-Source: AGHT+IGd4oa2yMXCfYQP+bxGt12i9vjzrC31YakhXmhGF7KdK4LjzEQLYLhaBSydZRE54ks0BhUoqg==
X-Received: by 2002:a17:903:2283:b0:1eb:2f02:cd0d with SMTP id d9443c01a7336-1eeaf870a61mr69944755ad.0.1715233472788;
        Wed, 08 May 2024 22:44:32 -0700 (PDT)
Received: from localhost (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c1368cfsm5209235ad.253.2024.05.08.22.44.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 May 2024 22:44:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 09 May 2024 15:44:27 +1000
Message-Id: <D14VIP36ZLPW.334QUWLZMQ5T3@gmail.com>
Cc: <kvm@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [kvm-unit-tests PATCH v9 07/31] scripts: allow machine option
 to be specified in unittests.cfg
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-8-npiggin@gmail.com>
 <e0df1892-c17f-4fc3-b95a-4efc0af917d3@redhat.com>
 <D149GFR9LAZH.1X2F7YKPEJ42C@gmail.com>
 <f304924b-8acf-40f6-9426-10fdf77712b6@redhat.com>
 <1e07de7a-5b14-4168-aa14-56dae8766dc0@redhat.com>
 <50e43047-b251-465b-b4b0-b5987ec9aa78@redhat.com>
In-Reply-To: <50e43047-b251-465b-b4b0-b5987ec9aa78@redhat.com>

On Wed May 8, 2024 at 11:36 PM AEST, Thomas Huth wrote:
> On 08/05/2024 14.58, Thomas Huth wrote:
> > On 08/05/2024 14.55, Thomas Huth wrote:
> >> On 08/05/2024 14.27, Nicholas Piggin wrote:
> >>> On Wed May 8, 2024 at 1:08 AM AEST, Thomas Huth wrote:
> >>>> On 04/05/2024 14.28, Nicholas Piggin wrote:
> >>>>> This allows different machines with different requirements to be
> >>>>> supported by run_tests.sh, similarly to how different accelerators
> >>>>> are handled.
> >>>>>
> >>>>> Acked-by: Thomas Huth <thuth@redhat.com>
> >>>>> Acked-by: Andrew Jones <andrew.jones@linux.dev>
> >>>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> >>>>> ---
> >>>>> =C2=A0=C2=A0 docs/unittests.txt=C2=A0=C2=A0 |=C2=A0 7 +++++++
> >>>>> =C2=A0=C2=A0 scripts/common.bash=C2=A0 |=C2=A0 8 ++++++--
> >>>>> =C2=A0=C2=A0 scripts/runtime.bash | 16 ++++++++++++----
> >>>>> =C2=A0=C2=A0 3 files changed, 25 insertions(+), 6 deletions(-)
> >>>>>
> >>>>> diff --git a/docs/unittests.txt b/docs/unittests.txt
> >>>>> index 7cf2c55ad..6449efd78 100644
> >>>>> --- a/docs/unittests.txt
> >>>>> +++ b/docs/unittests.txt
> >>>>> @@ -42,6 +42,13 @@ For <arch>/ directories that support multiple=20
> >>>>> architectures, this restricts
> >>>>> =C2=A0=C2=A0 the test to the specified arch. By default, the test w=
ill run on any
> >>>>> =C2=A0=C2=A0 architecture.
> >>>>> +machine
> >>>>> +-------
> >>>>> +For those architectures that support multiple machine types, this=
=20
> >>>>> restricts
> >>>>> +the test to the specified machine. By default, the test will run o=
n
> >>>>> +any machine type. (Note, the machine can be specified with the MAC=
HINE=3D
> >>>>> +environment variable, and defaults to the architecture's default.)
> >>>>> +
> >>>>> =C2=A0=C2=A0 smp
> >>>>> =C2=A0=C2=A0 ---
> >>>>> =C2=A0=C2=A0 smp =3D <number>
> >>>>> diff --git a/scripts/common.bash b/scripts/common.bash
> >>>>> index 5e9ad53e2..3aa557c8c 100644
> >>>>> --- a/scripts/common.bash
> >>>>> +++ b/scripts/common.bash
> >>>>> @@ -10,6 +10,7 @@ function for_each_unittest()
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local opts
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local groups
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local arch
> >>>>> +=C2=A0=C2=A0=C2=A0 local machine
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local check
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local accel
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local timeout
> >>>>> @@ -21,7 +22,7 @@ function for_each_unittest()
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [[ =
"$line" =3D~ ^\[(.*)\]$ ]]; then
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 rematch=3D${BASH_REMATCH[1]}
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 if [ -n "${testname}" ]; then
> >>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 $(arch_cmd) "$cmd" "$testname" "$groups" "$smp"=20
> >>>>> "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
> >>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 $(arch_cmd) "$cmd" "$testname" "$groups" "$smp"=20
> >>>>> "$kernel" "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 fi
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 testname=3D$rematch
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 smp=3D1
> >>>>> @@ -29,6 +30,7 @@ function for_each_unittest()
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 opts=3D""
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 groups=3D""
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 arch=3D""
> >>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 machine=3D""
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 check=3D""
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 accel=3D""
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 timeout=3D""
> >>>>> @@ -58,6 +60,8 @@ function for_each_unittest()
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 groups=3D${BASH_REMATCH[1]}
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 elif [=
[ $line =3D~ ^arch\ *=3D\ *(.*)$ ]]; then
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 arch=3D${BASH_REMATCH[1]}
> >>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 elif [[ $line =3D~ ^mac=
hine\ *=3D\ *(.*)$ ]]; then
> >>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 machine=3D${BASH_REMATCH[1]}
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 elif [=
[ $line =3D~ ^check\ *=3D\ *(.*)$ ]]; then
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 check=3D${BASH_REMATCH[1]}
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 elif [=
[ $line =3D~ ^accel\ *=3D\ *(.*)$ ]]; then
> >>>>> @@ -67,7 +71,7 @@ function for_each_unittest()
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fi
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 done
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ -n "${testname}" ]; then
> >>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 $(arch_cmd) "$cmd" "$te=
stname" "$groups" "$smp" "$kernel"=20
> >>>>> "$opts" "$arch" "$check" "$accel" "$timeout"
> >>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 $(arch_cmd) "$cmd" "$te=
stname" "$groups" "$smp" "$kernel"=20
> >>>>> "$opts" "$arch" "$machine" "$check" "$accel" "$timeout"
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fi
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 exec {fd}<&-
> >>>>> =C2=A0=C2=A0 }
> >>>>> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> >>>>> index 177b62166..0c96d6ea2 100644
> >>>>> --- a/scripts/runtime.bash
> >>>>> +++ b/scripts/runtime.bash
> >>>>> @@ -32,7 +32,7 @@ premature_failure()
> >>>>> =C2=A0=C2=A0 get_cmdline()
> >>>>> =C2=A0=C2=A0 {
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local kernel=3D$1
> >>>>> -=C2=A0=C2=A0=C2=A0 echo "TESTNAME=3D$testname TIMEOUT=3D$timeout A=
CCEL=3D$accel=20
> >>>>> $RUNTIME_arch_run $kernel -smp $smp $opts"
> >>>>> +=C2=A0=C2=A0=C2=A0 echo "TESTNAME=3D$testname TIMEOUT=3D$timeout M=
ACHINE=3D$machine=20
> >>>>> ACCEL=3D$accel $RUNTIME_arch_run $kernel -smp $smp $opts"
> >>>>> =C2=A0=C2=A0 }
> >>>>> =C2=A0=C2=A0 skip_nodefault()
> >>>>> @@ -80,9 +80,10 @@ function run()
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local kernel=3D"$4"
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local opts=3D"$5"
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 local arch=3D"$6"
> >>>>> -=C2=A0=C2=A0=C2=A0 local check=3D"${CHECK:-$7}"
> >>>>> -=C2=A0=C2=A0=C2=A0 local accel=3D"$8"
> >>>>> -=C2=A0=C2=A0=C2=A0 local timeout=3D"${9:-$TIMEOUT}" # unittests.cf=
g overrides the default
> >>>>> +=C2=A0=C2=A0=C2=A0 local machine=3D"$7"
> >>>>> +=C2=A0=C2=A0=C2=A0 local check=3D"${CHECK:-$8}"
> >>>>> +=C2=A0=C2=A0=C2=A0 local accel=3D"$9"
> >>>>> +=C2=A0=C2=A0=C2=A0 local timeout=3D"${10:-$TIMEOUT}" # unittests.c=
fg overrides the default
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ "${CONFIG_EFI}" =3D=3D "y=
" ]; then
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kernel=
=3D${kernel/%.flat/.efi}
> >>>>> @@ -116,6 +117,13 @@ function run()
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 2
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 fi
> >>>>> +=C2=A0=C2=A0=C2=A0 if [ -n "$machine" ] && [ -n "$MACHINE" ] && [ =
"$machine" !=3D=20
> >>>>> "$MACHINE" ]; then
> >>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print_result "SKIP" $te=
stname "" "$machine only"
> >>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 2
> >>>>> +=C2=A0=C2=A0=C2=A0 elif [ -n "$MACHINE" ]; then
> >>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 machine=3D"$MACHINE"
> >>>>> +=C2=A0=C2=A0=C2=A0 fi
> >>>>> +
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if [ -n "$accel" ] && [ -n "$A=
CCEL" ] && [ "$accel" !=3D "$ACCEL"=20
> >>>>> ]; then
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 print_=
result "SKIP" $testname "" "$accel only, but=20
> >>>>> ACCEL=3D$ACCEL"
> >>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return=
 2
> >>>>
> >>>> For some reasons that I don't quite understand yet, this patch cause=
s the
> >>>> "sieve" test to always timeout on the s390x runner, see e.g.:
> >>>>
> >>>> =C2=A0=C2=A0 https://gitlab.com/thuth/kvm-unit-tests/-/jobs/67989549=
87
> >>>
> >>> How do you use the s390x runner?
> >>>
> >>>>
> >>>> Everything is fine in the previous patches (I pushed now the previou=
s 5
> >>>> patches to the repo):
> >>>>
> >>>> =C2=A0=C2=A0 https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/pipe=
lines/1281919104
> >>>>
> >>>> Could it be that he TIMEOUT gets messed up in certain cases?
> >>>
> >>> Hmm not sure yet. At least it got timeout right for the duration=3D90=
s
> >>> message.
> >>
> >> That seems to be wrong, the test is declared like this in=20
> >> s390x/unittests.cfg :
> >>
> >> [sieve]
> >> file =3D sieve.elf
> >> groups =3D selftest
> >> # can take fairly long when KVM is nested inside z/VM
> >> timeout =3D 600
> >>
> >> And indeed, it takes way longer than 90 seconds on that CI machine, so=
 the=20
> >> timeout after 90 seconds should not occur here...
> >=20
> > I guess you need to adjust arch_cmd_s390x in scripts/s390x/func.bash to=
 be=20
> > aware of the new parameter, too?
>
> This seems to fix the problem:

Thanks, that looks good.

> diff --git a/scripts/s390x/func.bash b/scripts/s390x/func.bash
> index fa47d019..6b817727 100644
> --- a/scripts/s390x/func.bash
> +++ b/scripts/s390x/func.bash
> @@ -13,12 +13,13 @@ function arch_cmd_s390x()
>          local kernel=3D$5
>          local opts=3D$6
>          local arch=3D$7
> -       local check=3D$8
> -       local accel=3D$9
> -       local timeout=3D${10}
> +       local machine=3D$8
> +       local check=3D$9
> +       local accel=3D${10}
> +       local timeout=3D${11}
>  =20
>          # run the normal test case
> -       "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$c=
heck" "$accel" "$timeout"
> +       "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$m=
achine" "$check" "$accel" "$timeout"
>  =20
>          # run PV test case
>          if [ "$accel" =3D 'tcg' ] || grep -q "migration" <<< "$groups"; =
then
>
> If you don't like to respin, I can add it to the patch while picking it u=
p?

Yeah I shouldn't resend the full series just for this. If you're happy
to squash it in that would be good.

Thanks,
Nick

