Return-Path: <kvm+bounces-19644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4899908057
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 02:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E92EF1C21895
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 00:56:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E08794409;
	Fri, 14 Jun 2024 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H5MLAjl0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2A64A1E
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 00:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718326570; cv=none; b=jVVMAvMpBuFHYuChPY2klY+h1z03umAl84SXAnRgHciup+syTC2ffxBfkO2tf0GSMD38lZztKAXUKBjOFk9UTCfTvwwNFri1U5getKfuZBLqgip4WK4v40aS9PhoX2VzQeBQeAfFuKOR97O+ofJA0zsh+ywGx1eXB1FgTTHZScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718326570; c=relaxed/simple;
	bh=Tjhmlj2PSw6rmandQ2CtXEwcLjr8NyQgeMlb0aAjugk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=HsuJaZijdBoS1Dn1Fk1AWEaNylFaKVN73zyMO+llTPDWnSxANpKAvfZA29270aY4EYXiXCFQOw14e9NpBChAAJmYyMyN55YmVEvZWngYQpHqAue/hCxR+mbXDNgvUCofVxCIdWHsG9Vr96KWQ9D2KXtotZtlopWc1APs3z/iyVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H5MLAjl0; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7042a8ad9f5so1767576b3a.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 17:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718326568; x=1718931368; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=13BylizCRYc6Xcl35+0sm0bp1dbpJApZtVGohrWhPfM=;
        b=H5MLAjl07iombp2oS5L3WicuveYUXd+S3Seew+iA0NZwohMP6l09+1bCqMieH9Jlp1
         zfPdLKdiZZSIV9R/0Fcy/7N33etoO32lvv+6MUs5UEQUIUXbCarBsbRpYYhKBj6Yd3II
         cZtEaTL0yU01dVJvxmZEDmSci2qJC+I5r95xHfUJuEM59UHvJJivkH4vkWJAQbAmAQO3
         eh9n6c1y7eoIzHKKiS3T55my+M1B7kjK+0pUlyFfxFivFUADwC7oCHuRIysNoebbBOPW
         e74lFyRmgV+kC1L18ia/sAc+Mr9QG2+4L67pcnGaH4ccdNiDxMc65UzitBmE9RUObhPM
         cM0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718326568; x=1718931368;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=13BylizCRYc6Xcl35+0sm0bp1dbpJApZtVGohrWhPfM=;
        b=YlHNLQKTM0SaZafnrJQYhIYACS8qqC7GPT2854MaOtFBoyGhNHwoaJqopm3Uno2Tgl
         KCRtxENmeY7r/4qK761rVJfKCd+THIrTbem4LlFnGyGFk1x9dMlkfTdXJEZ8qetc/2wC
         wAKna2PIIvgxpcqAnq/AzE1DmSJ6kE/2ubFrQL9g4HhtUNk5anu/HCe7kpG9OywknAuL
         TwBGwanq24zOkNTa31GtDssJzlWd96jV2U64HL/ZzvvlmCJXs4AMBLmK5Iy9GzT/ZR+Y
         6KmL/DaH9fxjAdCRNsvmNL8t6F5zvAQ/W7p4oJG+JY5A1aLS0VJxIakRjEUECdwzLXsv
         cZzg==
X-Forwarded-Encrypted: i=1; AJvYcCV+YWXEMxQxN9WI5Qx34DRsC5CH3CL7tqwQQb6c+i8ALmiqws9K3xSxnBfYHRSoLgpgtzl8fPCpA/7HRu7XAdPFlykY
X-Gm-Message-State: AOJu0YywFJoiuhyEJoIQDbr1iQY4CDur9Eljvil8jlAhjJ/Zm0asBVI0
	8SkrLkA+Izh7AaYY3AdwVmIFzjgprpZfnPjrB7BKaO3glPuQYCxQdY2vmg==
X-Google-Smtp-Source: AGHT+IHVjVqM9SRwWFeUNQo97OxW6rjAwjoczj1H61metQ/sd7wrR3wNOsFSzjKa/AWIug8jJaCQwg==
X-Received: by 2002:a05:6a21:99a0:b0:1b8:13fd:c00f with SMTP id adf61e73a8af0-1bae7f948c2mr1998463637.22.1718326567830;
        Thu, 13 Jun 2024 17:56:07 -0700 (PDT)
Received: from localhost (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc91e0fbsm1961562b3a.9.2024.06.13.17.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 17:56:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Jun 2024 10:56:02 +1000
Message-Id: <D1ZBXH42OY9O.3N6I0DBO4UF3J@gmail.com>
Subject: Re: [kvm-unit-tests PATCH v10 12/15] scripts/arch-run.bash: Fix
 run_panic() success exit status
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Andrew Jones" <andrew.jones@linux.dev>
Cc: "Thomas Huth" <thuth@redhat.com>, "Laurent Vivier" <lvivier@redhat.com>,
 <linuxppc-dev@lists.ozlabs.org>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240612052322.218726-1-npiggin@gmail.com>
 <20240612052322.218726-13-npiggin@gmail.com>
 <20240612-eef98a649a0764215ea0d91f@orel>
In-Reply-To: <20240612-eef98a649a0764215ea0d91f@orel>

On Wed Jun 12, 2024 at 5:26 PM AEST, Andrew Jones wrote:
> On Wed, Jun 12, 2024 at 03:23:17PM GMT, Nicholas Piggin wrote:
> > run_qemu_status() looks for "EXIT: STATUS=3D%d" if the harness command
> > returned 1, to determine the final status of the test. In the case of
> > panic tests, QEMU should terminate before successful exit status is
> > known, so the run_panic() command must produce the "EXIT: STATUS" line.
> >=20
> > With this change, running a panic test returns 0 on success (panic),
> > and the run_test.sh unit test correctly displays it as PASS rather than
> > FAIL.
> >=20
> > Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> > ---
> >  scripts/arch-run.bash | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 8643bab3b..9bf2f0bbd 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -378,6 +378,7 @@ run_panic ()
> >  	else
> >  		# some QEMU versions report multiple panic events
> >  		echo "PASS: guest panicked"
> > +		echo "EXIT: STATUS=3D1"
> >  		ret=3D1
> >  	fi
> > =20
> > --=20
> > 2.45.1
> >
>
> Do we also need an 'echo "EXIT: STATUS=3D3"' in the if-arm of this if-els=
e?

In that case we don't need it because run_panic() returns 3 in that
case. run_qemu_status() only checks guest status if harness said
QEMU ran successfully.

Arguably this is a bit hacky because "EXIT: STATUS" should really be
a guest-printed status, and we would have a different success code
for expected-QEMU-crash type of tests where guest can't provide status.
I can do that incrementally after this if you like, but it's a bit
more code.

Thanks,
Nick

