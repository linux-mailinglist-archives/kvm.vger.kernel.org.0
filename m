Return-Path: <kvm+bounces-17357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8F998C497C
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 00:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 067311C20DDC
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 22:08:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABD8F84D03;
	Mon, 13 May 2024 22:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j23Uyvqa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC3484A37
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 22:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715638104; cv=none; b=i+B+LSCIY1Sg+9tlxwv1Bm6CcvZpmX1+uDIcTfgzRMik4TDwTXkSN1uhnDa2NqmfMCy4nl/gTl+8OclxG8Vr+I5U9XkGGeXMT/PHOa4OY1P5EM5sT8DnkSIXH7lbi3UgGN6WTaxBWLqxuISirlVlWrOyY+kqRf7HOOOyBcGK27s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715638104; c=relaxed/simple;
	bh=dEkg9sqCSTUh6OfERlj2DZRvvgB1ehgJLUUyf9z5i3I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CD1beUaVcZZ8PRTeeUTBZKpm1cxfyYCthrb66xxFxXB6nJs80CF4Wld0oIdzuTsn9jYdvcBiTdLbMQzZ+zlIY9nOcdiGKPvtbNeoQlfTEBaMxlpBgTG+CBtgfpN7j1a50qNTStxPL+moCiimh4BoKwyaJ99E/ga7vO0BgE+JHio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=j23Uyvqa; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6f474d5a8dfso3518964b3a.2
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 15:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715638103; x=1716242903; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+ImMk5mMg/Ph6+UMWEFe1i6y50T+E5sNxxEArfpRbc=;
        b=j23Uyvqah4Asrza+3JC4aOvX+Ny+nxrvHdX0EYt+656I2nzY4vYruzPJ3EXW0F/SXX
         SLaImVn0ICN39fQLoiaIJwLB2e5VsN1/rVijL5PyDuWwu4/SqQ3TfWumLbqmlJJV8xY+
         i4hla7obzANNVYcHO4ZQS4LY5VyoxK7cuay22C0ki4AyclxI8c1n5/dpYwUjOUAettfV
         ZuZ1ezZnSdUFI5iEnz4Y5IV9/7p02rxhz+WO1FrkXs32/00WeSpEPHRMTXpI6VdB3uva
         oM7UtewhhOQ7v+PbmQ6dlCjP4jOYo9ecQLCsQiQw6FP8jQP19Yy1uIDXSZtKkO4Rp5Wf
         9aTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715638103; x=1716242903;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=q+ImMk5mMg/Ph6+UMWEFe1i6y50T+E5sNxxEArfpRbc=;
        b=eltKn/w1QLpHUadXxW3FkqmHFssFdSZI0Kvggd3aMdT4yXdxy8T5viLJ23J8qfoiVB
         oJ/vJvImVHF30C9JqsGh4HmAm8NO3mtdLfk9o4zSqUdZV5OUS5QLf+NkbxwO86jb5isP
         1appqj/eDhH+zx0te3bVQUQ7KJ4pljnzbroMnqgsw42IYQAqyOu3Qq1npqUgmZ8V4mAq
         dnYm98W4g/aIhTRJ2KZThImCZtUjk9dvyLw+FGYRutE7YfiYuJ9hb4XXlLkfdtglzcsm
         IosLtTCm4M4IR/mxfX//uk/u+JDNwumhsQvKvDCtvjkQA0XrXrZNExIYWWb1CldC3XGD
         UBxA==
X-Forwarded-Encrypted: i=1; AJvYcCVoLXQwpktdrV5uUK1ZNLRwVQbZnCy89q1zuLS/9Ns631l8LatoFDRdycrEoS08am5c9BkHVI5dTpRTSBFeFD/CC4GH
X-Gm-Message-State: AOJu0YxXD+Ph5ZRCy558mmd9PxkeNq/w/xiuPUt9k4ZJAc1eab3ojMI7
	xbRv9oBRQ9SrWgCknB7MhD/0H8PveKmO+kEIq8yTg5sFdcbSgLyQHQqE+dSAmIlHLFIaNDWNV2b
	6BA==
X-Google-Smtp-Source: AGHT+IG/zTzeKngjsr80XFMiQVLcYBKJaamxbE5SgnpVzmy6rN4iBqZOwzyNNwZSjtZ3zMA04MvOdqL+ZuY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a17:b0:6ec:ceb4:d9e2 with SMTP id
 d2e1a72fcca58-6f4e01b9126mr999510b3a.0.1715638102944; Mon, 13 May 2024
 15:08:22 -0700 (PDT)
Date: Mon, 13 May 2024 15:08:21 -0700
In-Reply-To: <CABgObfZ=FcDdX=2kT-JZTq=5aYeEAkRQaS4A8Wew44ytQPCS7Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240510211024.556136-1-michael.roth@amd.com> <CABgObfZxeqfNB4tETpH4PqPTnTi0C4pGmCST73a5cTdRWLO9Yw@mail.gmail.com>
 <CABgObfZ=FcDdX=2kT-JZTq=5aYeEAkRQaS4A8Wew44ytQPCS7Q@mail.gmail.com>
Message-ID: <ZkKPVT8Xpp4lh6Xa@google.com>
Subject: Re: [PULL 00/19] KVM: Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, jroedel@suse.de, thomas.lendacky@amd.com, 
	vkuznets@redhat.com, pgonda@google.com, rientjes@google.com, tobin@ibm.com, 
	bp@alien8.de, vbabka@suse.cz, alpergun@google.com, ashish.kalra@amd.com, 
	nikunj.dadhania@amd.com, pankaj.gupta@amd.com, liam.merwick@oracle.com, 
	papaluri@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 12, 2024, Paolo Bonzini wrote:
> On Sun, May 12, 2024 at 9:14=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.co=
m> wrote:
> >
> > On Fri, May 10, 2024 at 11:17=E2=80=AFPM Michael Roth <michael.roth@amd=
.com> wrote:
> > >
> > > Hi Paolo,
> > >
> > > This pull request contains v15 of the KVM SNP support patchset[1] alo=
ng
> > > with fixes and feedback from you and Sean regarding PSC request proce=
ssing,
> > > fast_page_fault() handling for SNP/TDX, and avoiding uncessary
> > > PSMASH/zapping for KVM_EXIT_MEMORY_FAULT events. It's also been rebas=
ed
> > > on top of kvm/queue (commit 1451476151e0), and re-tested with/without
> > > 2MB gmem pages enabled.
> >
> > Pulled into kvm-coco-queue, thanks (and sorry for the sev_complete_psc
> > mess up - it seemed too good to be true that the PSC changes were all
> > fine...).
>=20
> ... and there was a missing signoff in "KVM: SVM: Add module parameter
> to enable SEV-SNP" so I ended up not using the pull request. But it
> was still good to have it because it made it simpler to double check
> what you tested vs. what I applied.
>=20
> Also I have already received the full set of pull requests for
> submaintainers, so I put it in kvm/next.  It's not impossible that it
> ends up in the 6.10 merge window, so I might as well give it a week or
> two in linux-next.

I certainly don't object to getting coverage in linux-next, but unless we h=
ave a
very good reason to push for 6.10, which doesn't seem to be the case, my st=
rong
preference is to wait until 6.11 for the official merge.  I haven't had a c=
hance
to look at v15, and at a quick glance, the SNP_EXTENDED_GUEST_REQUEST suppo=
rt in
particular still looks kludgy.  In general, this all feels very rushed.

