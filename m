Return-Path: <kvm+bounces-37286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2382CA28150
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 02:31:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB7323A6171
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 01:31:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745772288DE;
	Wed,  5 Feb 2025 01:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qnWpQF6W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E8A2288CC
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 01:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738718903; cv=none; b=Du1+TNs4YveuZlfz9HTl8p9iXK2pp2CxVOuB2vODooslqvDxrl0e+xBS/Ai//A/EiflMnAZc6xi++rr6RQfrDXxqpU6BatVX2A+CTa0vGq2qVI/n6RxqATvtNeLyhTD0rlgyjGE8BM8PZjel/ncqlJmXZGcT0TjXE5gGQcAQmQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738718903; c=relaxed/simple;
	bh=L6UNHm52Av64g4eOvrgeAlTD7yyac3XSxjhdr1AZhD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rDaxlvFGnxSUX2aZQyRjRAUViBWkHRa29gOp/Lw9TSMN1+peeaUsV7CDBED3qYAoqvRQHdEZscHO2qYJwsP2sB/sakSqYq8AJpAPt5DJRKdAUamo6+GCoYs8b/5bZ8J/ksbT2wGmSsJdQP4GCuJ4WDcNLERJHoQ9LaB/vY0qPag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qnWpQF6W; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5401af8544bso9830e87.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 17:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738718900; x=1739323700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QynXFqkrYlZr7WYo7fE7UK6Y3PG5CrgtydXdsboPAYk=;
        b=qnWpQF6WQppkAt7SJXefrrMv+iaZzxoG6cNHYLj4XCrjOAl08HU5mh638m0LdtSJnm
         fmWstOub5AnEJOpoMamMFW3y7gJaFRfqD7oWCHPGUAvQ8q0B1NFt87Dpa7+8RCWcaB89
         MBmTlc6VX1oqChhJ21+NsG7MeDfaXOeefBIqyGtswT1LFoQiqW9JcdEZ2zBFLJSdgpI6
         MgG4OyukxYlXZrNt6DtnLIVqxXBpquayHSXyQ0pgvpoJfrYJj4aUO5KlgYgIFFpGihwj
         RzsmQvy39ELQEnyrHOX4bk79iNtYawVArhLJEPafAFTCLkxM92cVpm2Tb6a18TUyqfbC
         DqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738718900; x=1739323700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QynXFqkrYlZr7WYo7fE7UK6Y3PG5CrgtydXdsboPAYk=;
        b=f5hE/RBCMFfYccnLxS5RISmsHh1b/eEGUO7FvxvbLmX1q+RiN2vFtnyfOQiW469HuR
         75LW2jtOCCKVO5vi2iCHlIJNrfNJ2E4VaruC/39p5XrspEL7thNIjBKT6GUvF6caV6U1
         S9obsxQnqQvOTFLR3mXAhrt0kb7XNN6xN7iurkyY/1DYqk7ToduIv9bBpYKmh270QrFq
         V15QUyoC5M+R6ju/O6X8qLJJeXg1JaH2KWAy0nay+L7nIrUpzS5h0w4+r9hv8qK1HX4/
         kPZESWf/UrzmfeO136IEzKuYagoS+iQDbnDw1Qsvc1w0CnsGFCIJyBr0XeJGdTSf5C+j
         u6ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVZuQUyHP26fhkLkNn/fJBrZpT/cr+/qta39lInJETMIzy9cbQ6KMFqNOpBeyuzUNvc03A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxfcDOEVQe0h0fA6oNe5SX37DGTcWGgawiZ1HBKUBvYdJ3D4d6d
	l0mpWVh1ooGm1Ivs/gMoEJr27kw0XTBU9mU9mnRQ3wWQzYMwuGzp/ZN/0VaUcaksLVgiIY+fsEI
	3xeDxWjzqV8hEB8n8itSbqTZjWaENPgDHmXYP
X-Gm-Gg: ASbGnct0ZwkiR7a8dOVcDZJctfYic98X53fSRMCwLus08MGBS0r4s493fBx3pnHbiZB
	xJOxy6fg6WLlyoLiKPNrA7zODjlMz0Tk+xDuqBmNeuvfD3pGwsFXx8Ah1xrhYTJdXo1cygeyN8B
	/vNZROvQeVfrt5Ikkw7tCoH7BI
X-Google-Smtp-Source: AGHT+IFNz//MlKANU68ej4F7AC0JAhD74TZStS2dB/A7UEhGn0VPAsfUnWCNxMCb1a7W8mYPnda49HF5WlF3Dj5ET8Q=
X-Received: by 2002:a05:6512:3f13:b0:543:e3c3:5a5e with SMTP id
 2adb3069b0e04-544002625e0mr505161e87.4.1738718899368; Tue, 04 Feb 2025
 17:28:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250117163001.2326672-7-tabba@google.com> <diqzikq6sdda.fsf@ackerleytng-ctop.c.googlers.com>
 <CA+EHjTzbBNRsQqeSh5L98Rx3QUwh9pUrpg-zkOd7fvnUbJZ-Kw@mail.gmail.com>
In-Reply-To: <CA+EHjTzbBNRsQqeSh5L98Rx3QUwh9pUrpg-zkOd7fvnUbJZ-Kw@mail.gmail.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 4 Feb 2025 17:28:08 -0800
X-Gm-Features: AWEUYZmxcp9mTvtnUopiY1n3kMsHQ2lIiwcawyYp02GM6Ptth0ebKagxPWYdJQE
Message-ID: <CAGtprH-Ryn6Xqs-3_VBMkk3ew74Rf9=D8S_iHVmq2DE-YFk2-w@mail.gmail.com>
Subject: Re: [RFC PATCH v5 06/15] KVM: guest_memfd: Handle final folio_put()
 of guestmem pages
To: Fuad Tabba <tabba@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, yu.c.zhang@linux.intel.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2025 at 1:51=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> On Wed, 22 Jan 2025 at 22:16, Ackerley Tng <ackerleytng@google.com> wrote=
:
> >
> > Fuad Tabba <tabba@google.com> writes:
> >
> > Hey Fuad, I'm still working on verifying all this but for now this is
> > one issue. I think this can be fixed by checking if the folio->mapping
> > is NULL. If it's NULL, then the folio has been disassociated from the
> > inode, and during the dissociation (removal from filemap), the
> > mappability can also either
> >
> > 1. Be unset so that the default mappability can be set up based on
> >    GUEST_MEMFD_FLAG_INIT_MAPPABLE, or
> > 2. Be directly restored based on GUEST_MEMFD_FLAG_INIT_MAPPABLE
>
> Thanks for pointing this out. I hadn't considered this case. I'll fix
> in the respin.
>

Can the below scenario cause trouble?
1) Userspace converts a certain range of guest memfd as shared and
grabs some refcounts on shared memory pages through existing kernel
exposed mechanisms.
2) Userspace converts the same range to private which would cause the
corresponding mappability attributes to be *MAPPABILITY_NONE.
3) Userspace truncates the range which will remove the page from pagecache.
4) Userspace does the fallocate again, leading to a new page getting
allocated without freeing the older page which is still refcounted
(step 1).

Effectively this could allow userspace to keep allocating multiple
pages for the same guest_memfd range.

