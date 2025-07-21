Return-Path: <kvm+bounces-53048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 211C1B0CE6B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 01:50:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4061E6C1628
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9351524678E;
	Mon, 21 Jul 2025 23:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ccFs8bJu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE4612E7F
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 23:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753141847; cv=none; b=Birqvdqvl+UBHEIfqSYhAVlH+yQbWKAIHNCdFyPIqEYpw1QRS2ZaDRHYg32fLWpNy/izCt/JCvld37bLN/NdEbU5q9jI2G8QMCBwdQZbpS+mvex0iFonQYBEnDjCuRgm619NnDMhG/9aa3EQnUEWmmwjO0c4VYS+pqAcl5+0ElQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753141847; c=relaxed/simple;
	bh=X76sqgXUjd4+zPeFBazIpld1nyyNRqan5r6plQcLZq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C63UxFuhy8c0OUCez1KleEZc+VMXYTW/TX0K+yqzFd51Zm75m4AWrBQi5UnGOWd6FUjJsbxjYsu+aDBvfzJlhlhYZc+Xd4bLwcnrjibpfPilfJpcxec94i+I3FF1f2+kJHe2ohN5OYG2xyECkaBkC1QYuMWAjtKh6i+LaTnheqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ccFs8bJu; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2357c61cda7so30405ad.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 16:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753141845; x=1753746645; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IB72aB1pAV9dq+XvFFbs2e0X7c42HGWgrt5SuJCD/0=;
        b=ccFs8bJuzPsfEgvfxPBigj44wAN/DeMFP7GMiWJFVygsGtKFg+hIsAlTjcRq+mVEkg
         BHP5haV3earx2WX2yZQ0sDPqMUdT4c6JaRAHzOYI1lE2LW/zAufhrcHC9eppfD2W7ILW
         eLP2tH+WHwq77I2bnryrBsaUfeDwbLI0Ajfc6Lu0J+nfX3yzPXD4cHlTxMGkQmzW5cyQ
         fwwi1vP1YSE6HtSyFXsbrxN6VhqiGtC3e19lWXtZYNxnydcufcS5UHbMvTcfWNPyxxx7
         nad+knBaAd5liuZyP2xfwOvti/EUsKzjGx8DfBN/+LWt4v+eosCF9SEghwkEr1F4t6OD
         rUpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753141845; x=1753746645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8IB72aB1pAV9dq+XvFFbs2e0X7c42HGWgrt5SuJCD/0=;
        b=I2qWWNHZfPuIa3vDvVlwsresk7HribM2oA8VQwclqdcYiMTq7IUq0rsOZJjSsCf2n2
         3m4cQqCyXKkraIEgshxkpolC069WCk0aD6yum26xo/2PKTYr4+UBm2pTYvHPvHuGbL0I
         3kZIDCvw7ZpP2E5TwGgvcScOr0UrHmCTBC9UNW7rN8w49GaQuNs6/ukTyDn4jYQiJwOU
         YQtbTgw4f5MLJ1NfJsHEYDAWZLDii6VsQIIKpSxQDFkwx8p8kgwbIENzkh/RwnEoHZHE
         y1ZzEeUVu0xWPzH/ypnqJQTB4OrQeD6Oxz3I2iXLY5vav9f3HyXr1ThzQ6o10u0D01Wp
         L1Vw==
X-Forwarded-Encrypted: i=1; AJvYcCWCoHs8bYvlfhUMUUqpsK0hpnZf16QwgrTleYMiJhbsr11OK6MiUEPSwH7Qqw08II2gpyo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywgc8kzsEufnaSukHp8Rkq+cBgSZl/9BSH3wnpqikVqXlMTPuTx
	xIkpoRZRn+nxO1hGl2c7sTTF3OsOeTDSIC0OHdMxBMRPZHsLi25pW7KVZ7jqpA/NCtRJbdXxVS8
	SP1kbMz9bCx0I2kgZRopmLC4xKZo8qPgC7857elko
X-Gm-Gg: ASbGncsqStOXWzV4r2kQvQdn7Q2UVqrG+0AGfgADvEMbYQ20CAb+XLyq63oN6hvGWX5
	r63VpcKoHbss8WM/HEB4+K3wmHrqfynlC7HrYZPgJn1YB8eBG/tjf8Z8hQctjJlLAM1/umZD/L8
	g9AMWud9gFaz24gjMMq5OqiOXHQPHFVubQG0Wblo6cNo3/y+SfTKekVoE+fTqD8dp5HwODCmQ52
	y8Sy5anhdGzGMfnaVwotGjtwOKla7hT2FqhLBY7vyUQkkU0
X-Google-Smtp-Source: AGHT+IH3YiQMKqSdvOi3Hl2chQEQjKBZYYncsqU52df1Cul+060EhTbwEXWwh9jGrpqKQQvBZjZc/wdEQOaLY9BZwWk=
X-Received: by 2002:a17:902:e5ca:b0:215:65f3:27ef with SMTP id
 d9443c01a7336-23f8b590f46mr1250935ad.12.1753141844936; Mon, 21 Jul 2025
 16:50:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com> <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
 <aH69a_CVJU0-P9wY@google.com>
In-Reply-To: <aH69a_CVJU0-P9wY@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 21 Jul 2025 16:50:32 -0700
X-Gm-Features: Ac12FXzatYxpj7dOmCOTU3y6raVwJgub7Hc67jtCHL8r3j1EPu7lx3yUXCqmwaM
Message-ID: <CAGtprH_r+eQjdi8q5LABz7LHEhK-xAMi4ciz83j3GnMm5EZRqQ@mail.gmail.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	willy@infradead.org, akpm@linux-foundation.org, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, ackerleytng@google.com, mail@maciej.szmigiero.name, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2025 at 3:21=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Jul 21, 2025, Vishal Annapurve wrote:
> > On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > >
> > > >
> > > > > > 2) KVM fetches shared faults through userspace page tables and =
not
> > > > > > guest_memfd directly.
> > > > >
> > > > > This is also irrelevant.  KVM _already_ supports resolving shared=
 faults through
> > > > > userspace page tables.  That support won't go away as KVM will al=
ways need/want
> > > > > to support mapping VM_IO and/or VM_PFNMAP memory into the guest (=
even for TDX).
> >
> > As a combination of [1] and [2], I believe we are saying that for
> > memslots backed by mappable guest_memfd files, KVM will always serve
> > both shared/private faults using kvm_gmem_get_pfn().
>
> No, KVM can't guarantee that with taking and holding mmap_lock across hva=
_to_pfn(),
> and as I mentioned earlier in the thread, that's a non-starter for me.

I think what you mean is that if KVM wants to enforce the behavior
that VMAs passed by the userspace are backed by the same guest_memfd
file as passed in the memslot then KVM will need to hold mmap_lock
across hva_to_pfn() to verify that.

What I understand from the implementation of [1] & [2], all guest
faults on a memslot backed by mappable guest_memfd will pass the
fault_from_gmem() check and so will be routed to guest_memfd i.e.
hva_to_pfn path is skipped for any guest faults. If userspace passes
in VMA mapped by a different guest_memfd file then the guest and
userspace will have a different view of the memory for shared faults.

[1] https://lore.kernel.org/kvm/20250717162731.446579-10-tabba@google.com/
[2] https://lore.kernel.org/kvm/20250717162731.446579-14-tabba@google.com/

>
> For a memslot without a valid slot->gmem.file, slot->userspace_addr will =
be used
> to resolve faults and access guest memory.  By design, KVM has no knowled=
ge of
> what lies behind userspace_addr (arm64 and other architectures peek at th=
e VMA,
> but x86 does not).  So we can't say that mmap()'d guest_memfd instance wi=
ll *only*
> go through kvm_gmem_get_pfn().
>
>

