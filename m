Return-Path: <kvm+bounces-46097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3F77AB1FFF
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 00:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 018AB1BC6D36
	for <lists+kvm@lfdr.de>; Fri,  9 May 2025 22:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5BB26280A;
	Fri,  9 May 2025 22:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wWzXQ6/S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2328325F79A
	for <kvm@vger.kernel.org>; Fri,  9 May 2025 22:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746830336; cv=none; b=Whb2YiQT46Kr0cXvzrVa1aKvj7TlXAl9QvtG5AyKfzMZAXxwuAuzew7r3EKtSVMK4E+grALW4GupzPgZ4pnZPhhW9jVpz7zuR5jKC40W5L2EWvlrD8+yVU4X8jMVQgtxYVs7CNp0TffkY1LA6GU7xa0VF4lf9x4O56yhc50sihQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746830336; c=relaxed/simple;
	bh=kmDsJHb6weFuouS1GIMRh+/+zOqxj3gT5yXpY5KmAFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W6ZoJpg4JvKwo16xrQZQnG57bQ7BAynXRNXtuPc4TIuFCaXGAD27d2adFOcTqrpYF3mtbwy3Vll/O4IvxQFkGIxbaqmQxwQYbyDY4HWC4Pcq0b7mLBMoyUhQp5W2n6h9OkXDNxeuzZqaplgFYoJ1J3E95TpkvLHFPN9j+SdAlRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wWzXQ6/S; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7086dcab64bso26450537b3.1
        for <kvm@vger.kernel.org>; Fri, 09 May 2025 15:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746830334; x=1747435134; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4y+7YrkNmYTMpHr+hnhsBX+FluOGpdkroormS9kd3y0=;
        b=wWzXQ6/S7t4abyOKC/Gk4y6Qj8lDln2X3SdbYD9OA97yAyuJO/nLWxztIl91rjBfki
         G/k+s6L6Mp6re5Qz8q843Bxo590Ddhh0f8uR03+o4ucj4aQohwduqR0ePeGTkdBSikb7
         lBxbcQZ5ocR5EKTaAZnU2uTq7C580kuYqT6kKb1sRDnf/hW1S0Kpigw1UVy4z9BePjME
         Kprb6oXhO7jNSVSXMTIBg8cpOQChz4mT/4xvVCq9btvzU4N429yNbdpy3CNEqgt16Rr3
         IFkhWzrWUWHUtFlTLwNnBOgI9o04+PUz63hB43YubyCqR06JVfvP/AgP4HCPDh587CVE
         e3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746830334; x=1747435134;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4y+7YrkNmYTMpHr+hnhsBX+FluOGpdkroormS9kd3y0=;
        b=sPtdYJjrHEbOr6rYFkWp0QSip8vkzWkUc7pa3VMMnGG8fGiAMtfA4Ya4VT0qDW1sZj
         3uKxIQxILkS+7CvBecx2w2DoclwTnzTANBYi4p4iwZy5hks07ENlyal1PO32A1eE9fwp
         kcQxXSLZBvWnut0F/m+/YLOXK0fOqKoGrJzp0nTdU9IuoxbZrqPM8GG++mXjhDP59dhQ
         5SwRpy5fR7KI/45yipDaNkfogrl3+bm2Omx4sAbheipZn5IRDr8kcEUV41oiTR0K0d2T
         ZRc4oBmR+3EqCI1CHS7aIQ64yfJwTQ4V/CJ9YFi2g/T8Swzj6WD/k9aBp/LHugVGrK4U
         Qztg==
X-Forwarded-Encrypted: i=1; AJvYcCXJjbWLjCETLL1Bliy0quFWMqgq3lPvB+SI1qhKIncHSR2m/mJT4ujwtWHWTUQ4vznbtBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqJc3eitVQ5WnV8ri6iZ9jlddL2qkWRRNWmmJNbAsPal6J/HTt
	6SzahG+nh40UYRVf0AEKfPTq7XlN6tNzEi1F/qpZmywOZMPebXZf3INg89By9iwXNkiec59RxH2
	s5dabJycmA7FFurT4OX+d0zQ0enNDZ4uREhHh
X-Gm-Gg: ASbGnctIQ78KhwVCq+X+dZ9Xo6A5Z1BIHNtY23GDznuzeqIW9CowvaOGpFsCp/4aLJZ
	3KgeWytcGs50CjcZKEKpWWxnwEGHGixqp+kEXkuWKzR2C9GhtrLsIWMmHaO2RGMAqGGXQGy+Lrk
	0/XMOdqikyt+uOJ1B4+g/Bp/Yv7LPd5b+NFUIByU1zmaET5P3+RDeOffX9WdZH+28=
X-Google-Smtp-Source: AGHT+IEdJ+t/M16J4dyjgQQaZBcaPjjKUhl0VsQtk+UZnkR2Q/ptZ5TFyDnjP/nWec8PjOqDBhuDWCDx/3z7sNn8daQ=
X-Received: by 2002:a05:690c:498e:b0:707:48a7:ea6a with SMTP id
 00721157ae682-70a3fa4037emr77537247b3.19.1746830333843; Fri, 09 May 2025
 15:38:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <diqz7c31xyqs.fsf@ackerleytng-ctop.c.googlers.com>
 <386c1169-8292-43d1-846b-c50cbdc1bc65@redhat.com> <aBTxJvew1GvSczKY@google.com>
 <diqzjz6ypt9y.fsf@ackerleytng-ctop.c.googlers.com> <7e32aabe-c170-4cfc-99aa-f257d2a69364@redhat.com>
 <aBlCSGB86cp3B3zn@google.com> <CAGtprH8DW-hqxbFdyo+Mg7MddsOAnN+rpLZUOHT-msD+OwCv=Q@mail.gmail.com>
 <CAGtprH9AVUiFsSELhmt4p24fssN2x7sXnUqn39r31GbA0h39Sw@mail.gmail.com>
 <aBoVbJZEcQ2OeXhG@google.com> <39ea3946-6683-462e-af5d-fe7d28ab7d00@redhat.com>
 <diqzh61xqxfh.fsf@ackerleytng-ctop.c.googlers.com> <CADrL8HWHAzfYJktatQraUV6n661=rU4q4+f+tYRB8Q5xwdSY_Q@mail.gmail.com>
 <e2f878c1-c2fb-4951-ac64-e1ee4a827e0b@redhat.com>
In-Reply-To: <e2f878c1-c2fb-4951-ac64-e1ee4a827e0b@redhat.com>
From: James Houghton <jthoughton@google.com>
Date: Fri, 9 May 2025 15:38:17 -0700
X-Gm-Features: AX0GCFuLEYUHA0d2HeMJJiPSjcin0qtvtKfgi2kmBbW_YclH7-KTCKoitgoaUSw
Message-ID: <CADrL8HW5zq8j57_O_kbyYG91cDcJH89RQV81-MS2gx-Ht24Nvg@mail.gmail.com>
Subject: Re: [PATCH v8 06/13] KVM: x86: Generalize private fault lookups to
 guest_memfd fault lookups
To: David Hildenbrand <david@redhat.com>
Cc: Ackerley Tng <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

On Fri, May 9, 2025 at 3:29=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 09.05.25 23:04, James Houghton wrote:
> > On Tue, May 6, 2025 at 1:47=E2=80=AFPM Ackerley Tng <ackerleytng@google=
.com> wrote:
> >>  From here [1], these changes will make it to v9
> >>
> >> + kvm_max_private_mapping_level renaming to kvm_max_gmem_mapping_level
> >> + kvm_mmu_faultin_pfn_private renaming to kvm_mmu_faultin_pfn_gmem
> >>
> >>> Only kvm_mmu_hugepage_adjust() must be taught to not rely on
> >>> fault->is_private.
> >>>
> >>
> >> I think fault->is_private should contribute to determining the max
> >> mapping level.
> >>
> >> By the time kvm_mmu_hugepage_adjust() is called,
> >>
> >> * For Coco VMs using guest_memfd only for private memory,
> >>    * fault->is_private would have been checked to align with
> >>      kvm->mem_attr_array, so
> >> * For Coco VMs using guest_memfd for both private/shared memory,
> >>    * fault->is_private would have been checked to align with
> >>      guest_memfd's shareability
> >> * For non-Coco VMs using guest_memfd
> >>    * fault->is_private would be false
> >
> > I'm not sure exactly which thread to respond to, but it seems like the
> > idea now is to have a *VM* flag determine if shared faults use gmem or
> > use the user mappings. It seems more natural for that to be a property
> > of the memslot / a *memslot* flag.
>
> I think that's exactly what we discussed in the last meetings. The
> guest_memfd flag essentially defines that.
>
> So it's not strictly a memslot flag but rather a guest_memfd flag, and
> the memslot is configured with that guest_memfd, inheriting that flag.
>
> There might be a VM capability, whether it supports creation of these
> new guest_memfds (iow, guest_memfd understands the new flag).

Oh yeah, I remember now, thanks for clearing that up for me. And I can
see it in the notes from last week's guest_memfd meeting. :)

