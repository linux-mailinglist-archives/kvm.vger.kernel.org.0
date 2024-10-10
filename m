Return-Path: <kvm+bounces-28430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32FDE9989B6
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 16:33:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54CE81C24E58
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 14:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B9B1CC15B;
	Thu, 10 Oct 2024 14:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nV9VWsnY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEF61CB316
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 14:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728570488; cv=none; b=A0SAhY/TOEvBJyUq4js5OzGnVeALaLJ/C8/ygd676iOZOyAAfSXwhNM+pKbdDRKzdXJoAPrg7Comvtw+hUFqnSmb6dg3jRRSPxr5dTFXzLYf9CnM0ZiCV5f0njc5RUOALEUd/cwXE2Chc/PzBxoiEyu8IRKQyKX1h+bgbxkN6Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728570488; c=relaxed/simple;
	bh=W7D5zgoOX71fsrxt/wRDcTx+76rxKX+swJ0Nf9w1b3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KUbA4K4M4XHo8QRgZH8oFcsIRZjxdyZ8jSVKnETDbE/MUghEd9NmwapCoxFAsPUlZvKSN18YHUCt0qXQ+H5sV62j3vwwntGhhAmeK9QyRa+AwlVkBP/3brMRCEyN5Ds0QwDO75LWYhzOIJ4P3FcTqa6flWWqfrOEDpWzUpewoFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nV9VWsnY; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-431141cb4efso276865e9.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 07:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728570485; x=1729175285; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wBCsx6f+siqvoCuj4B+Pvu9ADkJZ7wKgsSIJdEcIngE=;
        b=nV9VWsnYluSqxCwhvDG6HYCCMRpUlzcFziIXZDaKd/t0TPgJ3j0sl07oUm5RR59Rvq
         ezcSk6aO5/wq6BLG38AZrloA9MCkpKWj1zizg2OayBo6u552sPxXfg4RGSY3lVhP465J
         qYY5FslQDILBcqZws0YD0pc0NfE93ZfK8rD/6E2drbxK4iRuklZcW08kjg3ouALtOzBP
         fEBisRJ5pY6HUPXGyFQmqdA3bRujFXcSkZYwf7oHwMo+JxoQh0c/ox7h/wt4oXb5DoUL
         x/L7oIq3fUgCer5tQla1ryE5XzwyLzYKMhcvxMAcwFdEmVteUFaOyELUbztSq7EXqLUx
         NfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728570485; x=1729175285;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wBCsx6f+siqvoCuj4B+Pvu9ADkJZ7wKgsSIJdEcIngE=;
        b=SQENq5imD70F/KOzNTzN3dwKaWxZvmAL1nV8xL2tlb71gwLXRMnVEHwowVGYarG/py
         XkkW7REmnboQkA4+WNzB4K+zzcYEZIwsBFZ3DrQ0GtW0SlcwLQdUs10zfl6P5rl+n2Wm
         7JhIv74LHyZcU12FNbQSrgwaox5qZAJOsbv6lrekBWyEYz/DH2l5G/lCzAiNAHalmRrc
         qTRnsOLZBIvBWbbKh7Vg+wa1xAz/fGIHcL9YYT35Ce/p87nGAKI4opCqpPAPb9cbijmo
         Wf+FEa3j4A35XFXPGITDxKUkvaAbSze36Pzsiqgpyz1Okk+Jv1rg7d85B+EN7Ma1ulFV
         zn/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXus0AL7N8e2Q6qOpsXTTbtAjVbhoxdaroPdBTnjfi4Z8dy0xtqmzgmuu5yHejbu5r8CWA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqforANJCIC28XRv6RJW1N1rQqtV1+6HBByc6UQ/zuHx2Ns6n2
	WmOI0qWtMM06tftFgdb8iQ4RUTT5BeWZFJQEpZrTjmhIKs/2oohHkxhwE41vHgUVrzWHtBSD09G
	bjMJlnLAoGlrWbocMKkydavAQ3CyMYF9fbxmp
X-Google-Smtp-Source: AGHT+IHMywAqitIx8zT+z6idTauONY/Ezsn94DX4sJ68/dq+KHet2i3FDOkO8nINBGJtBEPSJkUH5cPl2DbLSWlCL7g=
X-Received: by 2002:a05:600c:3482:b0:426:66a0:6df6 with SMTP id
 5b1f17b1804b1-431160a6792mr4845475e9.0.1728570484599; Thu, 10 Oct 2024
 07:28:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241010085930.1546800-1-tabba@google.com> <20241010085930.1546800-5-tabba@google.com>
 <i44qkun5ddu3vwli7dxh27je72ywlrb7m5ercjhvprhleapv6x@52dwi3kwp2zx>
 <CA+EHjTwOsbNRN=6ZQ4rAJLhpVNifrtmLLs84q4_kOixghaSHBg@mail.gmail.com> <20241010120356.GB3394334@nvidia.com>
In-Reply-To: <20241010120356.GB3394334@nvidia.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 10 Oct 2024 15:27:27 +0100
Message-ID: <CA+EHjTwVFeegPS5yTUJeVC120Bqxz3JQ0W0o2qUBAW+JuJC2Kg@mail.gmail.com>
Subject: Re: [PATCH v3 04/11] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, rientjes@google.com, 
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Jason,

On Thu, 10 Oct 2024 at 13:04, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Oct 10, 2024 at 11:23:55AM +0100, Fuad Tabba wrote:
> > Hi Kirill,
> >
> > On Thu, 10 Oct 2024 at 11:14, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> > >
> > > On Thu, Oct 10, 2024 at 09:59:23AM +0100, Fuad Tabba wrote:
> > > > +out:
> > > > +     if (ret != VM_FAULT_LOCKED) {
> > > > +             folio_put(folio);
> > > > +             folio_unlock(folio);
> > >
> > > Hm. Here and in few other places you return reference before unlocking.
> > >
> > > I think it is safe because nobody can (or can they?) remove the page from
> > > pagecache while the page is locked so we have at least one refcount on the
> > > folie, but it *looks* like a use-after-free bug.
> > >
> > > Please follow the usual pattern: _unlock() then _put().
> >
> > That is deliberate, since these patches rely on the refcount to check
> > whether the host has any mappings, and the folio lock in order not to
> > race. It's not that it's not safe to decrement the refcount after
> > unlocking, but by doing that i cannot rely on the folio lock to ensure
> > that there aren't any races between the code added to check whether a
> > folio is mappable, and the code that checks whether the refcount is
> > safe. It's a tiny window, but it's there.
>
> That seems very suspicious as the folio lock does not protect the
> refcount, and we have things like speculative refcount increments in
> GUP.
>
> When we talked at LPC the notion was you could just check if the
> refcount was 1 without sleeping or waiting, and somehow deal with !1
> cases. Which also means you shouldn't need a lock around the refcount.

The idea of the lock isn't to protect the refcount, which I know isn't
protected by the lock. It is to protect against races with the path
that (added in this patch series), would check whether the host is
allowed to map a certain page/folio. But as Kirill pointed out, there
seems to be other issues there, which I'll cover more in my reply to
him.

Thank you,
/fuad


> Jason

