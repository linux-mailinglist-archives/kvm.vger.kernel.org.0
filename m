Return-Path: <kvm+bounces-46091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16834AB1E94
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 22:54:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA0B8A23A4A
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 20:54:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D23E25F7AD;
	Fri,  9 May 2025 20:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PPeRCq7I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5E122D9E3
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 20:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746824080; cv=none; b=c43E1F7RiCyzb9h1jthSV//7gr4Nx+LH2NktcqG6jujA7wy2YTZ1DUx+JQn5NJyBbZQWmER0yOjs9IHods+Wfmzt2Hmx8MZe05jnnwbpX2WqRvpjgcys3Lu+DUizBzuHXDx8zUejLUUJ/vaRcqySbY2plznTOYyeRmWADGUjHU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746824080; c=relaxed/simple;
	bh=4OALAvXo9+lipv0xjA2AawQMhuHbGUTriBP+yDkWhFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qJ9jziq1gRDyBUWkA04aTYvzbpwOWEF/60LjSr5Pi3DnaNsP3pWrLEvYeLD5FnWK3l9SzFWPsP15mFXzL+UmZCSSjACr4wPDB8eO3UaSgxqc1oWGCTdaXhjCNa6J//vRH2yVc+pN1Sbps3dbLDBI82NrA9CTMGhj3sOQDbjkcag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PPeRCq7I; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-70907505121so26810407b3.0
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 13:54:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746824078; x=1747428878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YDh7AUtJazlpCVEpTi9HcGNJAhAqUebSltmnVaJLqs=;
        b=PPeRCq7IqRyEzqDGgjN+rju5q1iWgNBG4NgZF/Vh+l208dKMsIOtAfcODRJzwMMdjg
         wbZbF5ju7hf7tGUJ4I7dAJnv7WAHbAaXvJf+rn67Mjh0cxXCs0hpKIWM9PeUtNy9Y0ET
         ZrRX4q1KKYIOl5+NScOy97j2g+H2WLMVldzVKdjeRbsIgKXa52jDypOejuYwrHudyaqJ
         oPp4isiBZkvLqDYGHHT+P6jkmfSMb7MWGhp7ihOP9cFod/62smyN5UsSytrbbvMgS7zx
         FUQPfpDC6FWfBIvnbwDD8SEiSIqa7encA98D9gj1/Ai4lRIwxVvoADUODxRrJcF8u/UA
         wz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746824078; x=1747428878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YDh7AUtJazlpCVEpTi9HcGNJAhAqUebSltmnVaJLqs=;
        b=CPvReZDjjxIJbZJD3/ti2SqPjnpvtG/HRf4Qs3Z7r8jcSWIMimtJloaM+C0gjjf/P9
         O8MpceJ1tEP1Iaz03Di4LJZ5VhSQAEQ5DNkNRk7C1+mXgmRQzu09q9oEy+u9v8xtZZen
         rYFOG88IOatblVCYBryio6S27otOKa8X0wtMjtY7KyHdcmsmuzB79Seib0aPXQ8xvZDR
         vbi6Lr+1w5yv4IPcfh+CV4O+q0xLz5s6JwE1mKEvsMAGQJfGRPoZZlsm2crIPl0KEhke
         dWXAUJ06Rit9CuMbRm0lk0ggReEFAp6TfBcL+WqnJNbPYlBQqGZJ6f/4ZVZH77O09UGD
         Uugw==
X-Gm-Message-State: AOJu0YzE0Sj1kNXruNKWAwqbvJHdTAaHAY/MtkiVF7/SeyH1QbIkrmY9
	Kp3vjxxrX/4OSoq4uS3zGjCfiavvANoc+6sYRhL2f7WTK6/wKgdaQ3kQk7GsR8G1joh8vDl+UfJ
	x0Ht4H2CAIDeGXVpp2Bq46vYOKVJtTtY5qyO5
X-Gm-Gg: ASbGnctVTC1qULZ4dCv7jx+AGZuNud+4aOActDAdBF3RHAeymsdczTJ1tzrqwy23EuU
	wyLuyK9rc1ya3twfBd5q8Kx8Bdy5QXuvcPvIIdLnOXAVt293c6c1Ryr3uUEmZkwX2AZIn7rUBKA
	h1xgNkPUdBkk2zhWWnh+6AZT93IAo4jUPdkBqII3RVM/r3gVjbOIxEUcv8O69ybVM=
X-Google-Smtp-Source: AGHT+IFiewDsh+KtQaHc0+sMyr5WyQmEk6swjiDZjCjdcy6OqRcTDauDDFEFO1+U8aLuAUaLbLYDQ/fh6Pt9jjFl3vM=
X-Received: by 2002:a05:690c:6a13:b0:702:4eb0:6af with SMTP id
 00721157ae682-70a3fb50442mr71919297b3.31.1746824077805; Fri, 09 May 2025
 13:54:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com> <20250430165655.605595-9-tabba@google.com>
In-Reply-To: <20250430165655.605595-9-tabba@google.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 9 May 2025 13:54:02 -0700
X-Gm-Features: AX0GCFvn133p0WfcWXRvPwPeSy4C7Kx4OsjhoiQ9viApK0YRW3SBt1Ynv90_jo0
Message-ID: <CADrL8HVO6s7V0c0Jv0gJ58Wk4NKr3F+sqS4i2dFw069P6ot7Fg@mail.gmail.com>
Subject: Re: [PATCH v8 08/13] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
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
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2025 at 9:57=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       struct kvm_gmem *gmem =3D file->private_data;
> +
> +       if (!kvm_arch_gmem_supports_shared_mem(gmem->kvm))
> +               return -ENODEV;
> +
> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D
> +           (VM_SHARED | VM_MAYSHARE)) {
> +               return -EINVAL;
> +       }
> +
> +       vm_flags_set(vma, VM_DONTDUMP);

Hi Fuad,

Sorry if I missed this, but why exactly do we set VM_DONTDUMP here?
Could you leave a small comment? (I see that it seems to have
originally come from Patrick? [1]) I get that guest memory VMAs
generally should have VM_DONTDUMP; is there a bigger reason?

[1]: https://lore.kernel.org/kvm/20240709132041.3625501-9-roypat@amazon.co.=
uk/#t

> +       vma->vm_ops =3D &kvm_gmem_vm_ops;
> +
> +       return 0;
> +}

