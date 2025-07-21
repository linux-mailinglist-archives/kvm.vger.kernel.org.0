Return-Path: <kvm+bounces-53025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5C7B0CBDD
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 22:33:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7333F1AA316D
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 20:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D82423B62C;
	Mon, 21 Jul 2025 20:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TBUXWeVl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C33D238C21
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 20:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753130005; cv=none; b=LLarjssSXdsM1J+AJkMQSgWj+o3iD2lQ4EgZoyt16UBTXd4qm7g7i5acXlEbx+xL3ocn5Js3qE90TGKzwgrPDWlOnpKo1rjhm5EG+xd8jKcFC4NegVQbAkLcgjmwcq1g1Lg+8OEEohE4l5BCkjHcytqEVGbOBTUBF6VRqmekQW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753130005; c=relaxed/simple;
	bh=9q738OSy5F3XSck6fQATo5Tzl7DSUQk68x8EkXY8TcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HgWQG8L2i52gzAvoCRfvR8Q3plGlTFIbKmHffnQFfOA0nPGX5FUH+pxTCtLtEdSgTDF9Cke7htiQwOcjgHuVjfJSx4GxG1QcM3dUaEl56joEX3GVsB+J9HlWpvn/NUrupOXhvBbcEg7KJxL8goj2oGg4MQS2v32RCW6VoQgFESQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TBUXWeVl; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-23dd9ae5aacso13975ad.1
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 13:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753130004; x=1753734804; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsRkrVSZ79KFOrHUZnkYB8zyV0FovPAw/7nSbgdf9SA=;
        b=TBUXWeVledvYrz07Eu5Omg3SM6HVjM9DAbHE2pO6vreR6d58656dngCmV+32wOOfp3
         I6kd5WuVHFZ4Nmqkfi0DWddm0eufSePTta65qXGaLPXVzO+nKl/1ZzNnpK6/S5TnVOiQ
         h4mgJuG++BS8VBRXcaLKzNWp7rpfEaY9CfDHSeLXuDIT1CfWvqXpaVsFgINGpcYyWk6I
         /+UeNhKzmiuSspkx+1ad9nO0b3X3iCvSddG17OOkWaTnAbTIcIZ3delq/sfXMlnNfOHm
         XrQ5YZ31aK9L0WN6/PItX8g1VFxAIedQe1PQxt/qK9/eYwkPnskURq0WREyAj0IkQOgF
         lXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753130004; x=1753734804;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tsRkrVSZ79KFOrHUZnkYB8zyV0FovPAw/7nSbgdf9SA=;
        b=aXlSBz60fWglApHVfZYW4rvBmzUme2BQInMx33vo2Y22jXp1vNvOSdtCRpyCyyrCH2
         mEVVeNUowpf4SzQ5weij8QDxvinaxed/VaZe9GAF5XobSktG6mVfVtKfdPrHljFJ9I2h
         NtbqmGHkqBSqmFtySZOihDumB+nhxT59GAiVScyzVI8kS4VnjTleZUtTcZOt+0vZNx5a
         Z/0EewT5wKIeELvVwuyMVeD1xQawoBprXq4TXjwHjVq+ZemVlNuG6Jm59p8TXMZdxtrt
         ctnLD1HMne+0Cp9nPGObvdohYPId2HqZ+yoeBcAqQ81wh6GbC2cDgnadxKnxGCpHW4nI
         f1Cw==
X-Forwarded-Encrypted: i=1; AJvYcCWnrSg1/t7SctOOhBAwb3vbgviS5IXwndIiEsMKSNTngVmkQedCdkS0hGPlMDDb/RbNGk4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzADb6N5WxF7WW/z/ZRYa6ZLXVMULxAUewVV+66JS8hGks+V3fD
	IzBGe9SjMdWXBLC6iyYKcaYgti4ze6mDMml7ciPKP04JTPkVVfF8wZ8yPOw0NIq2XU0mvCcwrnj
	4D1xLMMGJhAottmQQcQjlCMELll8RoqujCTP0pKua
X-Gm-Gg: ASbGncueWY2K+xTAwVE7hRXjllwj1Maq902nwLoiMyIrdgXRsVBors4BtFuEVLIgkRV
	VfPvp0xr61gaC1AgfS5L9PuSUPEJwXd+X4JQ/TU/KgnQ/UCM6mJ/KpQimSY/qcLueRCeMfAKcs1
	7ZWR6JVMjCqQLWxRTSWHBlboKZPk5C5gEXSnSV98qYoosF+11dQ+WhQfk2W28cA3XRC+5OQmU7F
	7pUq7slyzB/L1PJmW/WzgHxuqrj1VleAphhDxqT5nNgJS+r
X-Google-Smtp-Source: AGHT+IFkWHBx/fnOdJ0fH9ksHzfcdY6F8RTAu24ALLaPBJXK759V2xcE3RRWajNRHJ7uflgEVtUatOGBWMqwE9pCFGw=
X-Received: by 2002:a17:902:fc47:b0:235:e1d6:5343 with SMTP id
 d9443c01a7336-23f8b60e3e9mr699005ad.20.1753130002979; Mon, 21 Jul 2025
 13:33:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <CAGtprH8swz6GjM57DBryDRD2c6VP=Ayg+dUh5MBK9cg1-YKCDg@mail.gmail.com>
 <aH5RxqcTXRnQbP5R@google.com> <1fe0f46a-152a-4b5b-99e2-2a74873dafdc@intel.com>
 <aH55BLkx7UkdeBfT@google.com>
In-Reply-To: <aH55BLkx7UkdeBfT@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Mon, 21 Jul 2025 13:33:10 -0700
X-Gm-Features: Ac12FXygamzg8jas5GHmqT107kji5KSuvRb10tflFD6TWTFWMXuoj12Xx7V3ojk
Message-ID: <CAGtprH8H2c=bK-7rA1wC1-9f=g8mK3PNXja54bucZ8DnWF7z3g@mail.gmail.com>
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

On Mon, Jul 21, 2025 at 10:29=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> >
> > > > 2) KVM fetches shared faults through userspace page tables and not
> > > > guest_memfd directly.
> > >
> > > This is also irrelevant.  KVM _already_ supports resolving shared fau=
lts through
> > > userspace page tables.  That support won't go away as KVM will always=
 need/want
> > > to support mapping VM_IO and/or VM_PFNMAP memory into the guest (even=
 for TDX).

As a combination of [1] and [2], I believe we are saying that for
memslots backed by mappable guest_memfd files, KVM will always serve
both shared/private faults using kvm_gmem_get_pfn(). And I think the
same story will be carried over when we get the stage2 i.e.
mmap+conversion support.

[1] https://lore.kernel.org/kvm/20250717162731.446579-10-tabba@google.com/
[2] https://lore.kernel.org/kvm/20250717162731.446579-14-tabba@google.com/

> > >
> > > > I don't see value in trying to go out of way to support such a usec=
ase.
> > >
> > > But if/when KVM gains support for tracking shared vs. private in gues=
t_memfd
> > > itself, i.e. when TDX _does_ support mmap() on guest_memfd, KVM won't=
 have to go
> > > out of its to support using guest_memfd for the @userspace_addr backi=
ng store.
> > > Unless I'm missing something, the only thing needed to "support" this=
 scenario is:
> >
> > As above, we need 1) mentioned by Vishal as well, to prevent userspace =
from
> > passing mmapable guest_memfd to serve as private memory.
>
> Ya, I'm talking specifically about what the world will look like once KVM=
 tracks
> private vs. shared in guest_memfd.  I'm not in any way advocating we do t=
his
> right now.

I think we should generally strive to go towards single memory backing
for all the scenarios, unless there is a real world usecase that can't
do without dual memory backing (We should think hard before committing
to supporting it).

Dual memory backing was just a stopgap we needed until the *right*
solution came along.

