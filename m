Return-Path: <kvm+bounces-16786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E7D8BDA07
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:08:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 848B51F2347B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 04:08:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14764EB44;
	Tue,  7 May 2024 04:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kSABngv1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3C2A93C
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 04:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715054884; cv=none; b=aWb+rftiq2cN7qrS5oeBMniA1hVBQYGiksk2pUHBjamb50UTLSkcYy0QJojlRbKFgiAQCh+QMhDKePkFmb1HfOcyjar0VEXAaeaK06uXEtkKz5dHj7plKJJHP9o9fMqJlZxktWOunsTE2bXGEvGcHTfxF9i8ErbMCmD9hmpIQRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715054884; c=relaxed/simple;
	bh=xjkDosqYUTy0xoTlJqRpf+l5RfAZf5nuaHpElQBuFi0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=g/mbofi6s207CuvEv63bds8EnkxvsL/tQAHkVWbxrflAX62e7SDYH3qnaN3xB+81f0hI/2rLZ2qJgGtKl0P2KLzxHGd7iSElmznii4i0Q+ZJPtM0tmPRUeLKmZ7ukrZdsUhrt8EzkcvbgkauneejuB8f5vkZqVesjJdSgAWO7Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kSABngv1; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-61be599ab77so987275a12.1
        for <kvm@vger.kernel.org>; Mon, 06 May 2024 21:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715054882; x=1715659682; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8roWS+q9ljvtBS0JKC7xbUiCmEhIcKhzMHcrhEm9Nos=;
        b=kSABngv1LIy8hFKvUU5HFOJHUmkR/japSNJ6uN2aLEdORScqV/tG4HArDw4PrWMPuu
         PsvOkTz1P+2uGWtdtlyR9Wfe//d+bylCzAylYYIL7GydfV/sZI+XfgRv9UGdpkvDCCkq
         Lmzwm61SjgvvWr1G/F10ezgEilA0vjLX+o3BOWhZjDVXu/AdV/22OZiCKJSkc/sFEAoe
         eZksjguevKwPdd3bHbzA0RSnPDnGUlFS0SY3F32jTu0BJfFBjcMb6fR19q0WylUi5XXk
         Ts99/i8IvyokXAlNgLle1EKNhVLwlULc0eQzEsGHgqSSUzVhJrRzDXIX1wUbsLlUVjz5
         Fyug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715054882; x=1715659682;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8roWS+q9ljvtBS0JKC7xbUiCmEhIcKhzMHcrhEm9Nos=;
        b=oGHELt08vC9iYIO71tOb8wiy89wiwWOkNVASWaiwbNRfoSZh7zBXCuegIVR1rtftOj
         O5azL0yJf9dwr8YwPgmneA+sriVtLC2/9AQrwg0eJp0gqIoXjCLGr81rD4q99BdbahyU
         YAedUkLHa8NKJEeS+ZCbi1Q3L1CJmNs2YHq2Rm/ck2b25UoDVC4ZlLC5ShrECZFD/2C8
         NUE7LnpDot/ALcdpg003uGBeXXdKJqN8kvglywJiVC0fkZdifBm7snBq9EalRPr2un5b
         6hFH+MlJc1dChVcw8LB9b3XRO18WG3Rt+j7+IaUV+qFAwqluNnv6cavRKUoStumyYIlO
         Y1Ng==
X-Forwarded-Encrypted: i=1; AJvYcCVQTswhoSWagZ7YZ73TOU9YL0WfZt9eDssryhmUqWzMWx6/gMzD3fblHD5QnQ4+0TiN/EHh2xdFBMsBRJiskdr3Cf1q
X-Gm-Message-State: AOJu0YxSrIi5Ut4zxVlY8lcfAVd1SbckTyc9c/jqdYXHKPgiaVtC52v0
	p56WLzLtmAhV/kvHu9pat018MISf7x2AYUWwzcdKfyx4EQKrDojt
X-Google-Smtp-Source: AGHT+IHIHMa1Ll9G/eID7YmLtNoFyqT8YXrPKhHPZ74WPRdXykl0qss1zUJNo7yWAHVJLHnKwPouBg==
X-Received: by 2002:a17:90a:d50f:b0:2b4:329e:e363 with SMTP id t15-20020a17090ad50f00b002b4329ee363mr8797538pju.1.1715054882153;
        Mon, 06 May 2024 21:08:02 -0700 (PDT)
Received: from localhost (220-245-239-57.tpgi.com.au. [220.245.239.57])
        by smtp.gmail.com with ESMTPSA id sp7-20020a17090b52c700b002b4fd3f390bsm3973720pjb.53.2024.05.06.21.07.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 21:08:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 May 2024 14:07:57 +1000
Message-Id: <D1347PSKXAVS.2EMGLUQSZN8W4@gmail.com>
Cc: "Laurent Vivier" <lvivier@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v9 03/31] powerpc: Mark known failing
 tests as kfail
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-4-npiggin@gmail.com>
 <f2411fc8-5f90-4577-9599-f43bb8694cd0@redhat.com>
In-Reply-To: <f2411fc8-5f90-4577-9599-f43bb8694cd0@redhat.com>

On Mon May 6, 2024 at 5:37 PM AEST, Thomas Huth wrote:
> On 04/05/2024 14.28, Nicholas Piggin wrote:
> > Mark the failing h_cede_tm and spapr_vpa tests as kfail.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >   powerpc/spapr_vpa.c | 3 ++-
> >   powerpc/tm.c        | 3 ++-
> >   2 files changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
> > index c2075e157..46fa0485c 100644
> > --- a/powerpc/spapr_vpa.c
> > +++ b/powerpc/spapr_vpa.c
> > @@ -150,7 +150,8 @@ static void test_vpa(void)
> >   		report_fail("Could not deregister after registration");
> >  =20
> >   	disp_count1 =3D be32_to_cpu(vpa->vp_dispatch_count);
> > -	report(disp_count1 % 2 =3D=3D 1, "Dispatch count is odd after deregis=
ter");
> > +	/* TCG known fail, could be wrong test, must verify against PowerVM *=
/
> > +	report_kfail(true, disp_count1 % 2 =3D=3D 1, "Dispatch count is odd a=
fter deregister");
>
> Using "true" as first argument looks rather pointless - then you could al=
so=20
> simply delete the test completely if it can never be tested reliably.
>
> Thus could you please introduce a helper function is_tcg() that could be=
=20
> used to check whether we run under TCG (and not KVM)? I think you could=
=20
> check for "linux,kvm" in the "compatible" property in /hypervisor in the=
=20
> device tree to see whether we're running in KVM mode or in TCG mode.

This I added in patch 30.

The reason for the suboptimal patch ordering was just me being lazy and
avoiding rebasing annoyance. I'd written a bunch of failing test cases
for QEMU work, but hadn't done the kvm/tcg test yet. It had a few
conflicts so I put it at the end... can rebase if you'd really prefer.

>
> >   	report_prefix_pop();
> >   }
> > diff --git a/powerpc/tm.c b/powerpc/tm.c
> > index 6b1ceeb6e..d9e7f455d 100644
> > --- a/powerpc/tm.c
> > +++ b/powerpc/tm.c
> > @@ -133,7 +133,8 @@ int main(int argc, char **argv)
> >   		report_skip("TM is not available");
> >   		goto done;
> >   	}
> > -	report(cpus_with_tm =3D=3D nr_cpus,
> > +	/* KVM does not report TM in secondary threads in POWER9 */
> > +	report_kfail(true, cpus_with_tm =3D=3D nr_cpus,
> >   	       "TM available in all 'ibm,pa-features' properties");
>
> Could you check the PVR for POWER9 here instead of using "true" as first=
=20
> parameter?

Also covered in patch 30.

Thanks,
Nick

