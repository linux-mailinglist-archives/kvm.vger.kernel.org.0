Return-Path: <kvm+bounces-25421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 424C0965404
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:33:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE8731F20219
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 00:33:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CCA4A2F;
	Fri, 30 Aug 2024 00:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Y/mPb8MP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A040B20EB
	for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 00:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724978020; cv=none; b=h1+NGQF1Xb1XZFdsjT+3BLSSC1MZbmE+VmroV60Yn/ZoOcTEP0bbRLKhUrGSnkYUcMhG7LDQL0QAaNJAdCjL5UUbWvBH6zTMR43cUVRV3FLyAVDuxIWLjETgUy4ByputWHEl6aZRkz6XkVKpsMz7Q1wEIsiNGfn3lkQAy8a5Y7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724978020; c=relaxed/simple;
	bh=SH85gWPyWDBMrPTxg5hwF9eFmgdFespsOtsowukOS9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cQpVtPUNgmyjmOJDRmPLAtnbsTuGx9q6XOrtP139DNLNWQJt7PUz73Xl3IYLl0mlScdA3BAMxR+1V4WxmpNM80SJ+ACcCNvomiRra85bQLbtJgnImVco8dFZQ3XbITcIsxp6yZ1U0KS9dKm1K/QvdQh0UapGvbs892r04+ZYLyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Y/mPb8MP; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6b8d96aa4c3so10828767b3.1
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 17:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724978017; x=1725582817; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0c5SIq1ErU8LqTXRTvzlDlvgCjUaMFsATO9CN846VQ=;
        b=Y/mPb8MPTl65Z1Otvjjg8QrPKfmi9jSRHvdEgOC4zgsd4p7GjDnZPPK+nAl+fa5M2v
         bxhTKYv8lTTavySyVmlsRerzHbY1ce40NVdgo6wvWBz69J1qSl6HWkyXCgLXEfo+PjmD
         xtvpEXcJhpwWry7RF3rd4dmzrrX9GRVBp44gvGfgyU/o8cFBOWvgBzs7bCk/9qDus6Au
         XWBUC+YMRPKEknZksVMA7thsO627YTW90nPl48XxIbrY0TJ2av0q4mhXczMBpR9vwtSL
         GjsJn9jeTZbe84C0MpI//f6LPy7vWMONAUE4IEJ8+aIniS0H8M01TMdA20d9YSAAX9ss
         oPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724978017; x=1725582817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v0c5SIq1ErU8LqTXRTvzlDlvgCjUaMFsATO9CN846VQ=;
        b=BZTkA8C4Z3ct2DZy14W0uLMsP54MkOju/kmB8Mg7SASb+drXpIv2w6RdAfCSvkLxBp
         YcZR8CVY0zChpLkOvFO8iRwsmFbVTP9S88aSNLBcD+mFfNNFHiVkKEGZOtat6Yumw3Do
         daQMie2pTgewHbwGLRKsMEYMSA/d44l9zcEabZsUNHb9oNZ2K8MKXhgONF+xsXgS4Vo8
         x62ySBVC7l1YhbhGS0cMwOXsHAih+//7BUEYEV+N+sW/7CsaChHsQBAdxWXMqeryPbik
         Ducerayw+QWDEDg7OvwFOpjL3D/b6d0pBcDepeB+4Xpyp+wkfmLn/sXDzEyg8OaC0xOq
         fz0A==
X-Forwarded-Encrypted: i=1; AJvYcCU3Z3l0p+EVv3bA4ECohgUa5Okcfxx1uGIy2xLIUQJ3ELc/IQdv+0ITN9apKYge6gZnhtQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwuZ12FDAyG/CaMqLjEWJvc8KEuJawjrC6z2Me0sSl+R+4tBmL1
	wjpyWH6hvSj4lrUmAr1Ftz/uUbylGiCOU0dORLUJNLpEplBDAQ6AXfkW/FleonzW4KsuITfJnjL
	GtDAcBj8xS4fQzIa18l/lRbvAW+DOm3wmMkyS
X-Google-Smtp-Source: AGHT+IE56ditvMsqd+EwyV0AwwWQn10JX3FwGZqO74Otl79fYNdQirjfyiEfOM48/ZWOjAG0+PeTvxcA3jfyHAIhk/4=
X-Received: by 2002:a05:690c:f84:b0:62c:e6c0:e887 with SMTP id
 00721157ae682-6d40d88eabfmr4560677b3.9.1724978017312; Thu, 29 Aug 2024
 17:33:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-4-jthoughton@google.com> <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
 <Zr_y7Fn63hdowfYM@google.com> <CAOUHufYc3hr-+fp14jgEkDN++v6t-z-PRf1yQdKtnje6SgLiiA@mail.gmail.com>
 <ZsOuEP6P0v45ffC0@linux.dev>
In-Reply-To: <ZsOuEP6P0v45ffC0@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Thu, 29 Aug 2024 17:33:00 -0700
Message-ID: <CADrL8HWf-Onu=4ONBO1CFZ1Tqj5bee=+NnRC333aKqkUy+0Sxg@mail.gmail.com>
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>, Sean Christopherson <seanjc@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
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

On Mon, Aug 19, 2024 at 1:42=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> On Fri, Aug 16, 2024 at 07:03:27PM -0600, Yu Zhao wrote:
> > On Fri, Aug 16, 2024 at 6:46=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
>
> [...]
>
> > > Were you expecting vCPU runtime to improve (more)?  If so, lack of mo=
vement could
> > > be due to KVM arm64 taking mmap_lock for read when handling faults:

I had no real expectation. I was hoping that maybe there could be a
vCPU runtime improvement, given that user_mem_abort() (being called
because we're faulting memory in continuously in this test) has to
take the KVM MMU lock for reading, and aging is taking it for reading
vs. writing. I think that's why aging is a lot slower when using the
write lock: it is waiting for the readers to drop the lock, but I
guess the delay on the *readers* due to the pending writer seems to be
pretty minimal.

> > >
> > > https://lore.kernel.org/all/Zr0ZbPQHVNzmvwa6@google.com
> >
> > For the above test, I don't think it's mmap_lock
>
> Yeah, I don't think this is related to the mmap_lock.
>
> James is likely using hardware that has FEAT_HAFDBS, so vCPUs won't
> fault for an Access flag update. Even if he's on a machine w/o it,
> Access flag faults are handled outside the mmap_lock.

Yeah I was running on Ampere Altra CPUs.

> Forcing SW management of the AF at stage-2 would be the best case for
> demonstrating the locking improvement:
>
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index a24a2a857456..a640e8a8c6ea 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -669,8 +669,6 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift=
)
>          * happen to be running on a design that has unadvertised support=
 for
>          * HAFDBS. Here be dragons.
>          */
> -       if (!cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
> -               vtcr |=3D VTCR_EL2_HA;
>  #endif /* CONFIG_ARM64_HW_AFDBM */
>
>         if (kvm_lpa2_is_enabled())

Thanks!

> Changing the config option would work too, but I wasn't sure if
> FEAT_HAFDBS on the primary MMU influenced MGLRU heuristics.

Indeed, disabling CONFIG_ARM64_HW_AFDBM will cause MGLRU not to do aging.

> > -- the reclaim path,
> > e.g., when zswapping guest memory, has two stages: aging (scanning
> > PTEs) and eviction (unmapping PTEs). Only testing the former isn't
> > realistic at all.
>
> AIUI, the intention of this test data is to provide some justification
> for why Marc + I should consider the locking change *outside* of any
> MMU notifier changes. So from that POV, this is meant as a hacked
> up microbenchmark and not meant to be realistic.
>
> And really, the arm64 change has nothing to do with this series at
> this point, which is disappointing. In the interest of moving this
> feature along for both architectures, would you be able help James
> with:
>
>  - Identifying a benchmark that you believe is realistic
>
>  - Suggestions on how to run that benchmark on Google infrastructure
>
> Asking since you had a setup / data earlier on when you were carrying
> the series. Hopefully with supportive data we can get arm64 to opt-in
> to HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY as well.

I'll keep trying some other approaches I can take for getting similar
testing that Yu had; it is somewhat difficult for me to reproduce
those tests (and it really shouldn't be.... sorry).

I think it makes most sense for me to drop the arm64 patch for now and
re-propose it (or something stronger) alongside enabling aging. Does
that sound ok?

