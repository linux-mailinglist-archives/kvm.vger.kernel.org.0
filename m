Return-Path: <kvm+bounces-34902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 16B65A072A6
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 11:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E68F57A259A
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 10:17:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B61AD215785;
	Thu,  9 Jan 2025 10:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mBlUF+zi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B2A215186
	for <kvm@vger.kernel.org>; Thu,  9 Jan 2025 10:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736417874; cv=none; b=MOuS6MDHws5Itzqk13ushlmwfjaQrNxX2Vcm730+WEfKQw/pO3pfKdLEr9orwbI0nG0FdYa6w8mxp3gr73RQqrBuMpXKJs+xTElCIPRs19U2d8bu3iPbjS7DmOBQ752Vl64hjCOMc3pQB4QDacQHihA2PWIap9rZZCSkKhG0x1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736417874; c=relaxed/simple;
	bh=ShkuFHpIgAgmnrusVcCg/aQQHvdukD87YkrA02qal74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VL2jX97WN73jGGXxsMdMxVaVch8qdGkKnQnaxuFqzks/wKLc8ToHFPuFHcQG0V81w/rQntvdkRh8wOfb0acYCsqDGCRFHWDXp4yjwTlHwkJNPRSITNtL2n+X/0dA8qkfYa4EzEJ8ZA0V2dVvXLBFS2wKinlJTWFX5YwH7o+BKXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mBlUF+zi; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4361d5730caso31635e9.1
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2025 02:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736417871; x=1737022671; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ShkuFHpIgAgmnrusVcCg/aQQHvdukD87YkrA02qal74=;
        b=mBlUF+ziT0SCs+wDxsUt7KDvBCK0yPJNY4mcSB5aGiSCENrZgoM7OuWstWzF1r6OoE
         XnBiisBt6mqHVibINNnQto5ov2mhjnKMRljIqXjPHTKMIzCjj4ddkg5m0jP3KGEEShn9
         xVD62bec5zz+INbXfAZEjEWs2kX7fDHKSeDLxlBkxZy9PVRlTDbaXbY6yweisZ1H8q7E
         4kQcbztfsBFFWvb6kRQ+Cc5jlReB55D/ocjiG4zYaopKFZ7bEM70GJi/XH+/OAgWq+gr
         e+nGBUV7EGaawXvVQcMAByli4oy3lM8ucQJyuR0pHtbd7wVK15Lb3TQ8YukTITHieLt1
         NvjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736417871; x=1737022671;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ShkuFHpIgAgmnrusVcCg/aQQHvdukD87YkrA02qal74=;
        b=J1SZITv0frxlC0lZENkGuO2X0jRkUWMsKnb9Flv0YugN4ky3NbzrNKTlesYNZvRb7P
         bsBap7yQqGzuc9yCNr5JjEumLQ5php9xS1n9csXBrPDsaB1EaIX7QtXdtFC6zQxusOGT
         xklTmNRK+8pDpDTYTQxkdltaBkaUjhA4pfUvo39yORhws6ECTidIDs9bT0vEoWQDK79X
         fuGVjGjhZR7mJRFnhurWa+PSq08G4n39WlaAz5DRTyYT+85tFzhUiWLdgw2HzP0YEsVq
         x2Sfw53MZDVz2A93/xS7BqGmG1PYLC0sxgMpQFZCc+qvMkWLg1pMHn0dgvedVI9GPXCg
         BiRA==
X-Gm-Message-State: AOJu0YztN6p0hN9LMtPoVu+FlsWibI9C42OFpVBGnUJb7knqHzwoH7Bh
	G533fpbeEzYLR13g0BmBBP5MZrcfs8yKu7OyITA5RccmbxJowO73LEjW1Histu/bZk5TSWvWMEd
	k6ILEbCzdlId68KlOxSTH2M2f+bnjkJj2M4Os
X-Gm-Gg: ASbGnctjasIKAeSBkdCAXqjR04oC0rma8k5EZJ8Ib2B4lvW61l+3dAmiMdkv6eBn8CG
	fWlORidZMxDn51CgLwDjIIMOpq4YNEc415wBxDWVbVJZMEuG2EKf+QVScijJideIP0K0=
X-Google-Smtp-Source: AGHT+IEiK9RMSw+R49U1jPfNM/PdAVqlbc6ZDR69z1c/dwnl2wdeCCgQscmLrBl6kaD6RG2+4VvjsOOtPm1XJ01v4Ok=
X-Received: by 2002:a05:600c:3ba7:b0:434:c967:e4b5 with SMTP id
 5b1f17b1804b1-436e9b9e6cfmr638005e9.1.1736417871286; Thu, 09 Jan 2025
 02:17:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241213164811.2006197-1-tabba@google.com> <20241213164811.2006197-8-tabba@google.com>
 <37ce8f83-2ef2-4ba3-bcf9-1b93c1502ca6@amd.com>
In-Reply-To: <37ce8f83-2ef2-4ba3-bcf9-1b93c1502ca6@amd.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 9 Jan 2025 10:17:14 +0000
X-Gm-Features: AbW1kvZSvscJd7GkJEXwrke934Ul91EfCRqWQsAQEZkmAuIp9-xiwZPiCMDOnUk
Message-ID: <CA+EHjTz8ZTTsCCnBWq6a43xt0kZmn0HXyfcf8HcSyZYH+HZ-XQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 07/14] KVM: guest_memfd: Allow host to mmap
 guest_memfd() pages when shared
To: Alexey Kardashevskiy <aik@amd.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
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

Hi Alexey,

On Fri, 27 Dec 2024 at 04:21, Alexey Kardashevskiy <aik@amd.com> wrote:
>
> On 14/12/24 03:48, Fuad Tabba wrote:
> > Add support for mmap() and fault() for guest_memfd in the host.
> > The ability to fault in a guest page is contingent on that page
> > being shared with the host.
> >
> > The guest_memfd PRIVATE memory attribute is not used for two
> > reasons. First because it reflects the userspace expectation for
> > that memory location, and therefore can be toggled by userspace.
> > The second is, although each guest_memfd file has a 1:1 binding
> > with a KVM instance, the plan is to allow multiple files per
> > inode, e.g. to allow intra-host migration to a new KVM instance,
> > without destroying guest_memfd.
> >
> > The mapping is restricted to only memory explicitly shared with
> > the host. KVM checks that the host doesn't have any mappings for
> > private memory via the folio's refcount. To avoid races between
> > paths that check mappability and paths that check whether the
> > host has any mappings (via the refcount), the folio lock is held
> > in while either check is being performed.
> >
> > This new feature is gated with a new configuration option,
> > CONFIG_KVM_GMEM_MAPPABLE.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Co-developed-by: Elliot Berman <quic_eberman@quicinc.com>
> > Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > ---
> > The functions kvm_gmem_is_mapped(), kvm_gmem_set_mappable(), and
> > int kvm_gmem_clear_mappable() are not used in this patch series.
> > They are intended to be used in future patches [*], which check
> > and toggle mapability when the guest shares/unshares pages with
> > the host.
> >
> > [*] https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v4-pkvm
>
> This one requires access, can you please push it somewhere public? I am
> interested in in-place shared<->private memory conversion and I wonder
> if kvm_gmem_set_mappable() that guy. Thanks,

Sorry for the late reply, I was away, and sorry for the broken link,
I'd forgotten to push. Could you try now?

https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-6.13-v4-pkvm

Thanks,
/fuad

> --
> Alexey
>

