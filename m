Return-Path: <kvm+bounces-25537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 361339665CD
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:38:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68B091C23956
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 15:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EDA21B5EA9;
	Fri, 30 Aug 2024 15:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wmsc5rPG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC921B81C5
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 15:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725032070; cv=none; b=Q6516s0jYmfyP3stXCyT3Rh0zlkYpwbOcXs4Te/EKb2UYQMasp+E6IOtFnjx0F/NJpL8oySZ1iie4Vl0TkOKLZLKIdqg2OobzGYo2ijYEuguucLgYuGOEz6H8NnSOqrv6n66tIvcrIfypptT4fOqVPdMk7E1q8t9wNvZ9+xRRkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725032070; c=relaxed/simple;
	bh=fpS42aX0b5K/b3Q1uAIPaQJhJiOQBXKx/N3vFKIRp18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JFPyaupqqAUEgXiOYGItzv9Zqgc2b/attC/23aXt4ew3K73eQXG5YdyFphiAPAKswVId+9gIz1nA0QLbZTYATpPMOXr7svwiMi5DrjCWEgPvnpRAqUlUneYVAupBLJ4VueKul+2oFPaMXY2MEHocwqeLGvkFgNkno+8s4aH1qZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wmsc5rPG; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f4f2868783so21129921fa.2
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 08:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725032067; x=1725636867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fpS42aX0b5K/b3Q1uAIPaQJhJiOQBXKx/N3vFKIRp18=;
        b=Wmsc5rPGtDGiPCZokdC1Gw7pezL3Q+qYze/rrzykk6T6lnvb1YCGpqPa1xSQWGDNUo
         tK6X+kq/xXKH/WmwGautbiHU7kQ6kV7/yuWP8cfQWdTQ2mK45EKOpRaH/gD/JzaLDQHw
         ppIQUv9p+UV5Yh1Z9EGQ2O/RTVOZMMzGzFc3yXx7Gxle5lEqeImVn98gGbE/Vf7ZOHo3
         wKdna+JM5LSDztXAzzJy/1tTVkStuMC9OoLkzIm8LSpr4MHWFlaK/dOJ+YHYoqBvPTYh
         bEXuhlZOoBlVJ8AulTFczU0ewsabFsjNzGXO8oiZqsP98QwEvC0RxrVazAiV3KtVtEBg
         IN7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725032067; x=1725636867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fpS42aX0b5K/b3Q1uAIPaQJhJiOQBXKx/N3vFKIRp18=;
        b=hbiIOzdKUeu0D3gx8DeBYX1WN4fIfbru4/2qxSUFCVqs2e+kOUww9vukqaqOT6a0BB
         RlBR6d5iXNiFdiXd8kvg0Q8Dq3LVjMWvgDLaGp2EfHgJ5/7GtZeTHka7wZze3HIU/eRK
         1Mr5afyLcH6drpyUE9USdpjAh9BdpBVPA7QUbIgvB8GUwsb5gar9UlXCmSuNUrmLx13g
         uMr3M0eVSJu8Vy38yNHZCt3S9HS9PRFbxEJtNr/Esk4gvs7ZBvgxX0ZqxcrZ4d7J60DT
         BnEVevEfqgHJlCQr7uHuW8M+3uvc113zP+Og+8dAgMzV2ljbDEzjl4AusfsIEFodjDJ3
         SlGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXK6Bq9Bjjy8xDDOlP91Us2LFMJHEddP1YUeHl4IU5NnNRa/iVitBr73vIpG3ZueST2yzY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKQ6n63uePzAfMI6k+CTWeKWPtg31gfvz44UKFmGLgBk1Z7cMg
	OnZyGynV9BugOzWy8Ddi9J6c+j7ZH1I6s50PWPJK+WyT+wPIWe1VeLDTc3cSbZaLqCMR+tY9wMZ
	as3AQXrBLXK86dm04wTKYJTYt4GgOq7XKhLa9
X-Google-Smtp-Source: AGHT+IGwBJXtOV0i3GYyRTdCgSnRpiivnFkx2coVNIZMzMIKNaMNwsMNP5zJF5zp0+JOd+xMSn0E3uXDKUV2VAuZcjg=
X-Received: by 2002:a2e:a544:0:b0:2f3:f39f:3719 with SMTP id
 38308e7fff4ca-2f61e0a5143mr23582771fa.29.1725032066374; Fri, 30 Aug 2024
 08:34:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-4-jthoughton@google.com> <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
 <Zr_y7Fn63hdowfYM@google.com> <CAOUHufYc3hr-+fp14jgEkDN++v6t-z-PRf1yQdKtnje6SgLiiA@mail.gmail.com>
 <ZsOuEP6P0v45ffC0@linux.dev> <CADrL8HWf-Onu=4ONBO1CFZ1Tqj5bee=+NnRC333aKqkUy+0Sxg@mail.gmail.com>
 <ZtEW5Iym5QsJbONM@linux.dev>
In-Reply-To: <ZtEW5Iym5QsJbONM@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Fri, 30 Aug 2024 08:33:59 -0700
Message-ID: <CALzav=daN3y9nXNuj7pPpn2u_aAQ84t161z3odP=MGLYCLfYMQ@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Oliver Upton <oliver.upton@linux.dev>
Cc: James Houghton <jthoughton@google.com>, Yu Zhao <yuzhao@google.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2024 at 5:48=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Thu, Aug 29, 2024 at 05:33:00PM -0700, James Houghton wrote:
> > On Mon, Aug 19, 2024 at 1:42=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > > Asking since you had a setup / data earlier on when you were carrying
> > > the series. Hopefully with supportive data we can get arm64 to opt-in
> > > to HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY as well.
> >
> > I'll keep trying some other approaches I can take for getting similar
> > testing that Yu had; it is somewhat difficult for me to reproduce
> > those tests (and it really shouldn't be.... sorry).
>
> No need to apologize. Getting good test hardware for arm64 is a complete
> chore. Sure would love a functional workstation with cores from this
> decade...
>
> > I think it makes most sense for me to drop the arm64 patch for now and
> > re-propose it (or something stronger) alongside enabling aging. Does
> > that sound ok?
>
> I'm a bit disappointed that we haven't gotten forward progress on the
> arm64 patches, but I also recognize this is the direction of travel as
> the x86 patches are shaping up.
>
> So yeah, I'm OK with it, but I'd love to get the arm64 side sorted out
> soon while the context is still fresh.

Converting the aging notifiers to holding mmu_lock for read seems like
a pure win and minimal churn. Can we keep that patch in v7 (which
depends on the lockless notifier refactor, i.e. is not completely
stand-alone)? We can revisit enabling MGLRU on arm64 in a subsequent
series.
>
> --
> Thanks,
> Oliver

