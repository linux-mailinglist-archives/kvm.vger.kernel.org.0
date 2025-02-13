Return-Path: <kvm+bounces-38001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2037A33677
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 04:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E57D168142
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 03:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FAEB205502;
	Thu, 13 Feb 2025 03:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XSFQTZss"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8DA204C1D
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 03:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739419014; cv=none; b=cLWhDFYcViBxRlNmx/Cov7As9rGORuzKjeN8bksJrYoGvUX7d/QjbeHi/4Nyxu59wIY3wSzkW3WC/OqSxufCqPlkkQL2VvJ5OOWsPJ9MypzP5gWHgffz8daT9Tw579NNGrevFFqo3LQJH3xjrkZA8rzai8F2mcVxbh2ahceEtJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739419014; c=relaxed/simple;
	bh=lIp+HsaCTW2c1qH6AV4piTqN68lzAxi9fzfNaYbm8ow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=drmVWZlzilZXIK3ncyFVps0KHLEGTAEILA4BkU8L7MeBPcV7nDbDqcXRzuD/SHBTagDPB9DQRSl8ciYGbHT84VuHE005XlYcLV6eb2EKZyOIqRVq9iLaQYkMWWxb1lyVLqeasN7i8tviK3A6AOS2RRrPKhMh+niGZYJMBQSStYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XSFQTZss; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-46fee2b9c7aso3203211cf.2
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 19:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739419012; x=1740023812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G4d4nkVlEN0PRY0ICgCFHrYMedwLuqUNW6GLaoppbDo=;
        b=XSFQTZssj0Gy1OrOQGRuw0u7vhK29FdjpsDKRBjm/Gwd7SORmSyd5dUyTv3MY1PYYT
         viwR/V2odt9jedbMKfAptzTEArq/hY6pKOLT1ZXfOmw4MnlRdDRshQfkYGy6N5fMYkeL
         L5T/x++l4dsPTMDse4OX1aH7cPVhWUS6HeTf3QvhPkkh0H7XeNbCPWeM3BLIZqq4/71A
         9U5YyEe9WBQ0cmvaXr3hIkLtAtaIv32wz5RGdoR9F9d4Zb10qrXO2qis2Jk+7s7x5jL2
         8rmS9+9hpKvRrZe4KlrQf8CrDiFTPSR0xJn83xAWNJ3dlebCOGwA4qXlQFGyOszzcQRP
         eMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739419012; x=1740023812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G4d4nkVlEN0PRY0ICgCFHrYMedwLuqUNW6GLaoppbDo=;
        b=tz6WV3xBr3rWk9J1hz/e4NEHvUe3x2D7c7t6kRb725OCwrFhZfvgbJeJ2f/Z2OXyz1
         oQxB3rk0wBjpa+5Nj9omOzEtvk8ZicsSU5SZLR68qwM+aOJZnnjNv5vpMtC/BQDKjorU
         CFyPntUOMj4yet8ryj2ZfuZAr1Y9yCstvxIu8X4NVpKQ7sm+DCGxgm5Pt10xTR4T58RV
         5Ofj8W14QNAPzEi0UR9Nj+gmbwg3WIzUZEy7PPHdMsDncE5v+YvU9eiOiVqVeOraQJ/M
         veLf3Yf4MyM+LowYMEwKSxbP34mP/4xeznxK82xV1juTqxYhxZb1b9BzK6f6CN50IE9t
         jg4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXdPPkTqJs2iXxVPE8P7N42PZ9Mz2Z04ek5vUBy+99pq6v2Js5rKIbxIU6aMkRIEw33evE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfP3zHsmuNBSPybQTu1dADZoJAJkAKm+C9QFUd0VrRnq9RAApX
	4RPcCTUoR2m0OMRIoXpKJsqfZOojlYgO/Z3QOA4SRzsIbf7qoltWfjsfVEFBnTy2l5YZI5HylcJ
	SzXTgtRqIfAn4vFRx3iIEOmH+J77va+SElFQ8
X-Gm-Gg: ASbGnct+BaJpOnh+Wr+YtSKKS3Uv849ga+QdItdg9iePJnA7C43I0fBZgwZA0nbAVfK
	K9PSwFgV+YcOoEQDRM2Vz32CqGLZYATLqIvWWAl/JB3XkidBllmYzTsi9PCb0yoIyscwjAmvzjp
	6jHbN1/glixrVzB6ltsKjuwiRCP8I=
X-Google-Smtp-Source: AGHT+IFt2SRHcEtHijHYyd/DgImJNa0gqT37F6giMOPmbndZK9qekQVCUW6Tr4TIzTxrmtUuEL8fr09ot7NeHJrgFAQ=
X-Received: by 2002:a05:622a:6786:b0:471:b411:700f with SMTP id
 d75a77b69052e-471b411722fmr57144091cf.50.1739419011776; Wed, 12 Feb 2025
 19:56:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107042202.2554063-1-suleiman@google.com> <20250107042202.2554063-2-suleiman@google.com>
 <Z4gtb-Z2GpbEkAsQ@google.com> <CABCjUKDU4b5QodgT=tSgrV-fb_qnksmSxhMK3gNrUGsT9xeitg@mail.gmail.com>
 <Z4qK4B6taSoZTJMp@google.com> <CABCjUKDDDhXx8mSRKHCa34JjSX1nfM5WMG-UrPu9fjei6gkUJA@mail.gmail.com>
 <Z5AB-6bLRNLle27G@google.com> <CABCjUKB-4kvAg5U0D2O2aiTgfHnYx5qBTBEJJsK7edZY5g5eTQ@mail.gmail.com>
 <CABCjUKCDoHtLyX2CvrN+_D4N5ZiL2sLzyg+vY=LMkWZefrP_cA@mail.gmail.com> <Z6QQjmJE4CiWtUpI@google.com>
In-Reply-To: <Z6QQjmJE4CiWtUpI@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Thu, 13 Feb 2025 12:56:40 +0900
X-Gm-Features: AWEUYZkiJi609h5vUbEhDyMgn7TCz7Lh_NkQvTV6g9hIlv_y3sD6PlGK0_1NurA
Message-ID: <CABCjUKBd8izT7NF0CDa56qcMVvEd0i8O4A-5GK7ARMsWD-KE9g@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] kvm: Introduce kvm_total_suspend_ns().
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Chao Gao <chao.gao@intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ssouhlal@freebsd.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 6, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Feb 05, 2025, Suleiman Souhlal wrote:
> > >
> > > I tried your suggestion of moving this to a PM notifier and I found
> > > that it's possible for VCPUs to run after resume but before the PM
> > > notifier has been called, because the resume notifiers get called
> > > after tasks are unfrozen. Unfortunately that means that if we were to
> > > do that, guest TSCs could go backwards.
>
> Ugh.  That explains why KVM hooks the CPU online path.
>
> > > However, I think it should be possible to keep the existing backwards
> > > guest TSC prevention code but also use a notifier that further adjust=
s
> > > the guest TSCs to advance time on suspends where the TSC did go
> > > backwards. This would make both s2idle and deep suspends behave the
> > > same way.
> >
> > An alternative might be to block VCPUs from newly entering the guest
> > between the pre and post suspend notifiers.
> > Otherwise, some of the steal time accounting would have to be done in
> > kvm_arch_enable_virtualization_cpu(), to make sure it gets applied on
> > the first VCPU run, in case that happens before the resume notifier
> > would have fired. But the comment there says we can't call
> > ktime_get_boottime_ns() there, so maybe that's not possible.
>
> I don't think the PM notifier approach is viable.  It's simply too late. =
 Without
> a hook in CPU online, KVM can't even tell which VMs/vCPUs were running be=
fore the
> suspend, i.e. which VMs need to be updated.
>
> One idea would be to simply fast forward guest TSC to current time when t=
he vCPU
> is loaded after suspend+resume.  E.g. this hack appears to work.

That's really interesting!
One possible concern with this approach is that now each VCPU gets a
slightly different offset.
It's possible to avoid that by making sure that only one VCPU computes
the offset and having the other ones reuse it.
I'll send a patch. Should it be "Suggested-by:" you or is there
something else I should do?

I also wasn't sure if we should do this when the user sets the offset
with KVM_VCPU_TSC_OFFSET. I guess we probably should.

-- Suleiman

