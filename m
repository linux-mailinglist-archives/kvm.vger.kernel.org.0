Return-Path: <kvm+bounces-19647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B15B90807B
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 03:07:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FB471C214F8
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2024 01:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026F1158D83;
	Fri, 14 Jun 2024 01:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ba9yB+Zt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF8D157E7D
	for <kvm@vger.kernel.org>; Fri, 14 Jun 2024 01:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718327228; cv=none; b=nC/83pq5IIyfl/bn/svfYNe5j88qS/nqXqSjDWZIRgLC/mGfYwo9C5H5lWXdzbRqzb4+I7sBbqRqgbYBwbCFQYraAIx4asS3CG1tba/7/4hlXkLwBt7m1v73M3pl3b6WwIsiaTpvndHSrZAzeVqSC+gNSMtXolualJDujHtxyE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718327228; c=relaxed/simple;
	bh=YOj0onMTTIxGksev6gT0kNJDEuXgd9NZ28Y2S69SlsI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=nLgrm5AU/9ZtIsEnEcG3KpbNudW3AqqMCaGqsRhErPZarFeC5N1bKFBJlcut89WCYAh1OLWrtLcTMG1QRWwEcwhnxL+OnhQUbrrYOBk4x0/6ZjwaH2HtgY+67a1yFtNRHDCq5seAiTPwTvrfCCxHzSNG+pFvBQ5wOA5FCpX2O7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ba9yB+Zt; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f4603237e0so1209147b3a.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 18:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718327226; x=1718932026; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nA1MS5BUUKTry76DF8Bj23gSBG5shQDrHkWBt3GYo6c=;
        b=Ba9yB+ZtwCuw+Cu8kpnYw9gYLjCGol7yS6GuZq1EKlh+JyAuOBG1FOFJlY9bHEq+PM
         n4UzIs/hnS28KT25qrG8y2z8wtnf7DpIfAKASB9PmB99t1zsrKgRU7+TxCc8r9fLdTYR
         B2UCIN37XIzwywp232u9YC6ZmYRepGNY1V+wlKOpSfYjQfbBxZyq6vaVbYFmuVCdHo2Q
         79+WdZr8xwruQt3OT74rkWGagd/UNJ15YZh+nS/dSYxdNyu0rTKGGTcpEQh3XjpC8ku7
         M5w6cq4OSr7NTgBJdf3nQP/zdYI0VTClbFmAsewBREy2PhD/XOZDym/KmXpaajpiuLQz
         tSnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718327226; x=1718932026;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nA1MS5BUUKTry76DF8Bj23gSBG5shQDrHkWBt3GYo6c=;
        b=ldAAOFDVpbUrPLf+hGlaa6zJ0M00pmgh7T8iFiM6PmrcHoyTZydcP3bppghwneJA4M
         TOxqF4eMd/R5yNmYc4Ih/RdFctXr23lsw0G6WojWQJTdTfcNxuTCG7QLlwh9CcuNXspr
         lfZaFQhz4/zwFT/Jhur6YI/Au3QFmIQC7BMK+PQxp3LOKrM8k16KSRuuAqLw62YyVuGz
         dh3RwyQiCW3RB45NVwAScRGLqQP7jN5tqKKWw7N+8skcMcXiO3Av7bFvoqFegE1moo+f
         FAiJxKK8AQxOFe9Vj0iN4aGM/zKUnPVYAgThycO5FgJ8qrP59QMGLOkfYNNmZwjOFsSQ
         s8aQ==
X-Gm-Message-State: AOJu0Yz9ZHusBrnqCgSpTaphbID6O5HIUfkPtvCQznAmL16YV0zPVb1P
	hT1QwD1I8WUiURhGaOGTb0r2eitU8eZvMIGoRrfBEh7ln2JqVEPV
X-Google-Smtp-Source: AGHT+IHfkxOq5SsV10bgPlXjD1yexS7hEohTSdLetgJW3xTd9EH0/kE1l+94xII7+1nV9DLpn93mNw==
X-Received: by 2002:aa7:9e5b:0:b0:705:a9d9:62b1 with SMTP id d2e1a72fcca58-705d6af5fdbmr1559485b3a.15.1718327226044;
        Thu, 13 Jun 2024 18:07:06 -0700 (PDT)
Received: from localhost (220-235-199-47.tpgi.com.au. [220.235.199.47])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705cc98915esm2028337b3a.96.2024.06.13.18.07.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 18:07:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Jun 2024 11:07:01 +1000
Message-Id: <D1ZC5VS6CZP9.2UYNUXB1FMN1Q@gmail.com>
Cc: <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 3/4] build: Make build output pretty
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Thomas Huth" <thuth@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>
X-Mailer: aerc 0.17.0
References: <20240602122559.118345-1-npiggin@gmail.com>
 <20240602122559.118345-4-npiggin@gmail.com>
 <448757a4-46c8-4761-bc51-32ee39f39b97@redhat.com>
 <20240603-20454ab2bca28b2a4b119db6@orel>
 <D1RNX51NOJV5.31CE9AGI74SKP@gmail.com>
 <36a997ac-324f-4fd9-9607-d81bd378be33@redhat.com>
In-Reply-To: <36a997ac-324f-4fd9-9607-d81bd378be33@redhat.com>

On Wed Jun 12, 2024 at 8:32 PM AEST, Thomas Huth wrote:
> On 05/06/2024 02.38, Nicholas Piggin wrote:
> > On Mon Jun 3, 2024 at 6:56 PM AEST, Andrew Jones wrote:
> >> On Mon, Jun 03, 2024 at 10:26:50AM GMT, Thomas Huth wrote:
> >>> On 02/06/2024 14.25, Nicholas Piggin wrote:
> >>>> Unless make V=3D1 is specified, silence make recipe echoing and prin=
t
> >>>> an abbreviated line for major build steps.
> >>>>
> >>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> >>>> ---
> >>>>    Makefile                | 14 ++++++++++++++
> >>>>    arm/Makefile.common     |  7 +++++++
> >>>>    powerpc/Makefile.common | 11 +++++++----
> >>>>    riscv/Makefile          |  5 +++++
> >>>>    s390x/Makefile          | 18 +++++++++++++++++-
> >>>>    scripts/mkstandalone.sh |  2 +-
> >>>>    x86/Makefile.common     |  5 +++++
> >>>>    7 files changed, 56 insertions(+), 6 deletions(-)
> >>>
> >>> The short lines look superfluous in verbose mode, e.g.:
> >>>
> >>>   [OBJCOPY] s390x/memory-verify.bin
> >>> objcopy -O binary  s390x/memory-verify.elf s390x/memory-verify.bin
> >>>
> >>> Could we somehow suppress the echo lines in verbose mode, please?
> >>>
> >>> For example in the SLOF project, it's done like this:
> >>>
> >>> https://gitlab.com/slof/slof/-/blob/master/make.rules?ref_type=3Dhead=
s#L48
> >>>
> >>> By putting the logic into $CC and friends, you also don't have to add
> >>> "@echo" statements all over the place.
> >>
> >> And I presume make will treat the printing and compiling as one unit, =
so
> >> parallel builds still get the summary above the error messages when
> >> compilation fails. The way this patch is now a parallel build may show
> >> the summary for the last successful build and then error messages for
> >> a build that hasn't output its summary yet, which can be confusing.
> >>
> >> So I agree that something more like SLOF's approach would be better.
> >=20
> > Hmm... kbuild type commands is a pretty big patch. I like it though.
> > Thoughts?
>
> Looks pretty complex to me ... do we really need this complexity in the=
=20
> k-u-t? If not, I think I'd rather prefer to go with a more simple approac=
h=20
> like the one from SLOF.

The first patch I posted added silent to make too, but I don't love
it because it silences things that you missed or forgot about.

This way is loud by default and you have to adjust recipes to be
quiet. It caught a couple of things I missed the first time around.
I think that's a long term advantage for more short term churn.

Thanks,
Nick

