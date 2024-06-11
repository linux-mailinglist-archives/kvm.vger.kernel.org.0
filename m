Return-Path: <kvm+bounces-19293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBD9902F33
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 05:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F179D1F2274E
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 03:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA5A16F918;
	Tue, 11 Jun 2024 03:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JdBwBiGt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f65.google.com (mail-lf1-f65.google.com [209.85.167.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424CA64B;
	Tue, 11 Jun 2024 03:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718077738; cv=none; b=dczE15tUbeTZ1RcRPviJ0HkhjR+gu/elTUnBkroHUgVEFuIxv307qnZX3bSoMwI29zC9fRpBKQr3aH5QzTOmeewsnDoLw0p2TRKiR2alTIu9pRHrwvFWFSplzNam2YrmE6wwxLKSmqxI3MC3UT70t3eCEXoHptD/oIsPTcJE7UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718077738; c=relaxed/simple;
	bh=4bRj6TsecIphPgJOPJ9cAYvpa6UNiuELaeuFMUXXMoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jSwDEWn0EyZfydnf6kdUO7gID8zFH5nSItjdSE9GquMuPIbiKKIRs3o1wK104bMjVg2bBWfU9KC6pg0Pc5ti/7S1KNdN7gUNexG82PrM7zj7iLC7ugsjwIl92X44yXFSowRLBbPnOl7V+l7Cn7q1EHav9ncDys8Bs1meDTqtolk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JdBwBiGt; arc=none smtp.client-ip=209.85.167.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f65.google.com with SMTP id 2adb3069b0e04-52c815e8e9eso2589883e87.0;
        Mon, 10 Jun 2024 20:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718077734; x=1718682534; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EeURxhgiQoYCCJH8wV3+dknCqUQ9gQWVawbH/GCc3eE=;
        b=JdBwBiGtRtkA1ReUFTxq5UANcD3qlFSBb3mAZhA49MKb0zoRV3UWa5N3ixL4km6MPG
         H0/xIzUVki96jnn3HrDCqJ6jbXjmhpX5l/VNe3zOuKW1Wgjxl9UnIHvuj8Kt0GYn8VqW
         oncTMzDF5dDagSj5BNIXip/p/wgPf3JSBm0OqXfTavDcWOl9YCtLdEaFVrkAaiteLIml
         Oyb145I6SQSuJpozEBXPkb1iluSja3dS2H/IudtFXRawwuJFsTpa13S+Utp+u6EYjh7u
         gMOWVJlsfv2yVW/+juOoa9QECS7y7tRvLLrftzDp9awpwtydmY8Pyruaq2VmXia2ee/6
         alGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718077734; x=1718682534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EeURxhgiQoYCCJH8wV3+dknCqUQ9gQWVawbH/GCc3eE=;
        b=TfCSPRtRG0dfs+pCKYPnrrles5XhCbNGH4VVhrJdPngOwp8ag8wIducVYeEbmT9S7D
         AtvepUL60qTKJKe51etYyghDO5js165xztutm+za5ZuuSKV32kCLHbQuSMEROUBBLBqv
         Cta55kfMuuoKyZhwLglmCYWAYhUSucOG0ltD23YzQ4xQuebBsGca+gUTZlHAqWMmlT19
         wZexpDIrtnJGIcoAbeqveRM+eItwLdG8sM8FSeF/JvFEDRZleExct5+sIDgHlfhOwmtG
         kur9OxYy8SIVs13nDC0e+nDqkdFFO1xu1QBFwBbtBwWP28ntaV1SiR8lqcjQc79OIAj9
         4rmQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/GHYw3YoXwvm2IV+PspFsQoQ+gb0asZoDaMhx1tXMj8STd8lVkwCN9MKNHAZ/zW+tr/BECpADM1qR7Hv0RT3XWwGdeq2xjwUDxLCNlE9sOreUEtIQtAYrFuEVLxdS/OHi
X-Gm-Message-State: AOJu0Yyr3LQQzPPNRXRZv1EaP3pgggodubAkqj6tBR7Kebbflc2JqCUl
	NOtfqY2QHf0wkj34LrBYV2PjN+myErqEaIidQrVWO258NJ3gv2k6i79PCzYhXVOlEj2w2LYzU9E
	/gGNRxhCRGD7F6AnZivDxumTLDa4=
X-Google-Smtp-Source: AGHT+IF04T7zbC8N5zlMa29YiDaf22w1ifIGqkmzcoGxgZVg+8srWa3Y+uUWvLtgQp51gpO9FasZVRcj8tvXWXNcCuI=
X-Received: by 2002:ac2:5142:0:b0:529:b734:ebc9 with SMTP id
 2adb3069b0e04-52bb9f8ef21mr6461781e87.38.1718077733920; Mon, 10 Jun 2024
 20:48:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231121115457.76269-1-cloudliang@tencent.com> <gsntzfrs9xqp.fsf@coltonlewis-kvm.c.googlers.com>
In-Reply-To: <gsntzfrs9xqp.fsf@coltonlewis-kvm.c.googlers.com>
From: Jinrong Liang <ljr.kernel@gmail.com>
Date: Tue, 11 Jun 2024 11:48:43 +0800
Message-ID: <CAFg_LQWoBrg_ANF4SA-rOuZLtNxLijWNRKcvVR_FZp6yy6kRXQ@mail.gmail.com>
Subject: Re: [PATCH 0/9] Test the consistency of AMD PMU counters and their features
To: Colton Lewis <coltonlewis@google.com>
Cc: seanjc@google.com, pbonzini@redhat.com, likexu@tencent.com, 
	jmattson@google.com, aaronlewis@google.com, wanpengli@tencent.com, 
	cloudliang@tencent.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Colton Lewis <coltonlewis@google.com> =E4=BA=8E2024=E5=B9=B46=E6=9C=8811=E6=
=97=A5=E5=91=A8=E4=BA=8C 07:36=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi Jinrong,
>
> Sorry if this is repeating myself, but I only replied to you before
> when I should have included the list.
>
> Sean may have something useful to add as well.
>
> Jinrong Liang <ljr.kernel@gmail.com> writes:
>
> > Hi,
>
> > This series is an addition to below patch set:
> > KVM: x86/pmu: selftests: Fixes and new tests
> > https://lore.kernel.org/all/20231110021306.1269082-1-seanjc@google.com/
>
> Since this is a few months old and v10 of Sean's patch has been applied
> here [1], have you done any further work on this series? No pressure if
> not, but Mingwei and I are interested in covering AMD for some PMU
> testing we are working on and we want to make sure we know the latest
> work.

Hi Colton,

There are no further updates to this series. I appreciate your
interest in covering AMD for PMU testing purposes.

Please feel free to modify this patch series to suit your requirements
and make any necessary adjustments. If you have any questions or need
assistance, please don't hesitate to contact me.

Thanks

>
> > Add selftests for AMD PMU counters, including tests for basic
> > functionality
> > of AMD PMU counters, numbers of counters, AMD PMU versions, PerfCtrExtC=
ore
> > and AMD PerfMonV2 features. Also adds PMI tests for Intel gp and fixed
> > counters.
>
> > All patches have been tested on both Intel and AMD machines, with one
> > exception
> > AMD Guest PerfMonV2 has not been tested on my AMD machine, as does not
> > support
> > PerfMonV2.
>
> > If Sean fixed the issue of not enabling forced emulation to generate #U=
D
> > when
> > applying the "KVM: x86/pmu: selftests: Fixes and new tests" patch set,
> > then the
> > patch "KVM: selftests: Add forced emulation check to fix #UD" can be
> > dropped.
>
> > Any feedback or suggestions are greatly appreciated.
>
> I'll happily review once my question above is answered.
>
> > Sincerely,
>
> > Jinrong
>
> > Jinrong Liang (9):
> >    KVM: selftests: Add forced emulation check to fix #UD
> >    KVM: selftests: Test gp counters overflow interrupt handling
> >    KVM: selftests: Test fixed counters overflow interrupt handling
> >    KVM: selftests: Add x86 feature and properties for AMD PMU in
> >      processor.h
> >    KVM: selftests: Test AMD PMU performance counters basic functions
> >    KVM: selftests: Test consistency of AMD PMU counters num
> >    KVM: selftests: Test consistency of PMU MSRs with AMD PMU version
> >    KVM: selftests: Test AMD Guest PerfCtrExtCore
> >    KVM: selftests: Test AMD Guest PerfMonV2
>
> >   .../selftests/kvm/include/x86_64/processor.h  |   3 +
> >   .../selftests/kvm/x86_64/pmu_counters_test.c  | 446 ++++++++++++++++-=
-
> >   2 files changed, 400 insertions(+), 49 deletions(-)
>
>
> > base-commit: c076acf10c78c0d7e1aa50670e9cc4c91e8d59b4
> > prerequisite-patch-id: e33e3cd1ff495ffdccfeca5c8247dc8af9996b08
> > prerequisite-patch-id: a46a885c36e440f09701b553d5b27cb53f6b660f
> > prerequisite-patch-id: a9ac79bbf777b3824f0c61c45a68f1308574ab79
> > prerequisite-patch-id: cd7b82618866160b5ac77199b681148dfb96e341
> > prerequisite-patch-id: df5d1c23dd98d83ba3606e84eb5f0a4cd834f52c
> > prerequisite-patch-id: e374d7ce66c66650f23c066690ab816f81e6c3e3
> > prerequisite-patch-id: 11f133be9680787fe69173777ef1ae448b23168c
> > prerequisite-patch-id: eea75162480ca828fb70395d5c224003ea5ae246
> > prerequisite-patch-id: 6b7b22b6b56dd28bd80404e1a295abef60ecfa9a
> > prerequisite-patch-id: 2a078271ce109bb526ded7d6eec12b4adbe26cff
> > prerequisite-patch-id: e51c5c2f34fc9fe587ce0eea6f11dc84af89a946
> > prerequisite-patch-id: 8c1c276fc6571a99301d18aa00ad8280d5a29faf
> > prerequisite-patch-id: 37d2f2895e22bae420401e8620410cd628e4fb39
> > prerequisite-patch-id: 1abba01ee49d71c38386afa9abf1794130e32a2c
> > prerequisite-patch-id: a7486fd15be405a864527090d473609d44a99c3b
> > prerequisite-patch-id: 41993b2eef8d1e2286ec04b3c1aa1a757792bafe
> > prerequisite-patch-id: 9442b1b4c370b1a68c32eaa6ce3ee4c5d549efd0
> > prerequisite-patch-id: 89b2e89917a89713d6a63cbd594f6979f4d06578
> > prerequisite-patch-id: 1e9fe564790f41cfd52ebafc412434608187d8db
> > prerequisite-patch-id: 7d0b2b4af888fe09eae85ebfe56b4daed71aa08c
> > prerequisite-patch-id: 4e6910c90ae769b7556f6aec40f5d600285fe4d0
> > prerequisite-patch-id: 5248bc19b00c94188b803a4f41fa19172701d7b0
> > prerequisite-patch-id: f9310c716dbdcbe9e3672e29d9e576064845d917
> > prerequisite-patch-id: 21b2c6b4878d2ce5a315627efa247240335ede1e
> > prerequisite-patch-id: e01570f8ff40aacba38f86454572803bd68a1d59
> > prerequisite-patch-id: 65eea4f11ce5e8f9836651c593b7e563b0404459
>
> [1]
> https://lore.kernel.org/kvm/170666267480.3861961.1911322891711579495.b4-t=
y@google.com/

