Return-Path: <kvm+bounces-53159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D60B0E125
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 18:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 004077AC898
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:01:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA1F27A90F;
	Tue, 22 Jul 2025 16:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VWtbYmBy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB5727A47C
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 16:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753200128; cv=none; b=TXDJ4aOHIRxEPiFn5BT2mznlAvhXXxmOzQMYByAUB33XFngvnHu3q8HZ4CiMx1ZWn/DP+Aj+BwjrwTVGRUtMq/Z3prj1RkE0FgHdm4DjI3tG7jMseBBOwBTXnoNDJl71heJF7FBHwYJbfiHgpX0903dm8cA0OSJfHwfEq51gMg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753200128; c=relaxed/simple;
	bh=9LyYeLmky4Pxwkj3LVEv54HpdyvuC1ah0EvaCPHukc0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IS+w9s/P+B8py4IYtOQ/t4jFtXXCsCPB/N3RxawLfcGXmTiS6vGpaYHaAABKJIkYm9prpXikLlHu9FqZ7JC+k9d40uxUPJGXAf07tNSTNLMV/NUh7LLW8HNWY1zhzLU2QHtHMmyMNYuuFgN7O5YNAXTTf4KV3PncnxZc3n/5I24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VWtbYmBy; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso226671cf.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 09:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753200125; x=1753804925; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zJ5oDalvHQQyRD506B9hQPa7CZetF/bu3rVEuMz2nko=;
        b=VWtbYmByN82vJ26Qdvb8YDSRoDqEqlF5QhGIV/RpKoZUJi7ukG9tieq7l/QgatzE3T
         KHvY4v8VInzOaNDGSnl8eCnZNGHk+QZDxikgeItpSKde4FqfUYfG0q36OT1XTaELN7yx
         K+1BUS8srqxg+sYZwgak9qCWW3Jb8za/001Ker0sJ4+u1gCqSraklNeEccS1xGeuR6tD
         gucQuLyYIbcNGP6gNyRC6rRyJ6aHOMN/TeJGQp7nVHlNHS3+zTL+qTFpUhjH7qikyhti
         ceBf5GzLPawPsqX/DIeub0PA2F1IJesVwR8pOfghAw2nfG3UrJZPEm2QSSgL645J9IW4
         EY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753200125; x=1753804925;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zJ5oDalvHQQyRD506B9hQPa7CZetF/bu3rVEuMz2nko=;
        b=qfa/hwjadUqcIkNVxGm5zJN5IlSZ8XCP5R4h+deEoS6TpWi75V2sooqkNGr5FlmPI1
         WNA0suOZG5iUlFcqwD8KhK2VMayJVRB1Af0eTKjbsDpZmFauC5xQ4TANmanNi15Ogd8w
         3l1/BW79urqAkWBFohgHUaKj0DSx3wCU47fz4AKc/1h992Hr+3JOZfd5LtbIUf2pUaFw
         /u1DXobC+mPdZxgV+MtDYW5PgPcQOXu327rmIN2Rqi6MoVzaNvq2cyUmsvjTJje6OKZ0
         XlnSCqQ41DMCdtDwLCh3yFaoHSJ4Tc3QplG5yZ4o7+7uIzlC3/FY3CnlVLNuf8xIS9rb
         lB1A==
X-Gm-Message-State: AOJu0YyibedWlBJUB4bXrQyfc5G9ZNkQ7IqbX3q/L/mtpLCF56suELF1
	9a/V9vvKAjONvZPWVWVmV0xOf+NSPcpGyAMg02Kmi/1Y+L/HU7mWylBIsScnbe2kD3EEqzone61
	wQgARyLGLz9Jl1JcW2pdFxgcwQZ8c2SW9GT3+DDzd
X-Gm-Gg: ASbGnctaxdHIWE8F3X+WNMdvUV1Ywo4OM7+TYMKyPRPHWGTv5xDHYEdh/eIE9hjuIK3
	FihgfpAWwXVNS+PbYhaZGZcIFI5S9bjBeM04VIvmvzbjhTSGtALH6LTwx1E98lu0uKgB243lItb
	xfIKijbdUlLYgpdohcCZs3W7LCrUqemeq2U914Mvyae6dU+GdeAu5PsRakPDy4/b2kEhgpM597B
	k5bMczeX0V5qrhk3g==
X-Google-Smtp-Source: AGHT+IHz1Md5CvjkMr0v63+zalLU7h1VJHuKRRiw/5Kb9EG5psNH9QWi7eZC9q9jEanCdF+aUxZTXQqWhAN+64R/RQ8=
X-Received: by 2002:ac8:628c:0:b0:494:4aa0:ad5b with SMTP id
 d75a77b69052e-4ae5cc6db00mr4063241cf.2.1753200124082; Tue, 22 Jul 2025
 09:02:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-3-tabba@google.com>
 <aH5uY74Uev9hEWbM@google.com> <CA+EHjTxcgCLzwK5k+rTf2v_ufgsX0AcEzhy0EQL-pvmsg9QQeg@mail.gmail.com>
 <aH552woocYo1ueiU@google.com> <CA+EHjTwPnFLZ1OxKkV5gqk_kU_UU_KdupAGDoLbRyK__0J+YeQ@mail.gmail.com>
 <aH-1JeJH2cEvyEei@google.com>
In-Reply-To: <aH-1JeJH2cEvyEei@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 22 Jul 2025 17:01:27 +0100
X-Gm-Features: Ac12FXztwmXhhi72jh3H00X5S1zdW7e0Z4aKDTPt7mq7MLiUgNVB0JPJsFGM4PY
Message-ID: <CA+EHjTw46a+NCcgGXQ1HA+a3MSZD9Q97V8W-Xj5+pYuTh4Z2_w@mail.gmail.com>
Subject: Re: [PATCH v15 02/21] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to CONFIG_KVM_GENERIC_GMEM_POPULATE
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Jul 2025 at 16:58, Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Jul 22, 2025, Fuad Tabba wrote:
> > On Mon, 21 Jul 2025 at 18:33, Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Jul 21, 2025, Fuad Tabba wrote:
> > > > > The below diff applies on top.  I'm guessing there may be some intermediate
> > > > > ugliness (I haven't mapped out exactly where/how to squash this throughout the
> > > > > series, and there is feedback relevant to future patches), but IMO this is a much
> > > > > cleaner resting state (see the diff stats).
> > > >
> > > > So just so that I am clear, applying the diff below to the appropriate
> > > > patches would address all the concerns that you have mentioned in this
> > > > email?
> > >
> > > Yes?  It should, I just don't want to pinky swear in case I botched something.
> >
> > Other than this patch not applying, nah, I think it's all good ;P. I
> > guess base-commit: 9eba3a9ac9cd5922da7f6e966c01190f909ed640 is
> > somewhere in a local tree of yours. There are quite a few conflicts
> > and I don't think it would build even if based on the right tree,
> > e.g.,  KVM_CAP_GUEST_MEMFD_MMAP is a rename of KVM_CAP_GMEM_MMAP,
> > rather an addition of an undeclared identifier.
> >
> > That said, I think I understand what you mean, and I can apply the
> > spirit of this patch.
> >
> > Stay tuned for v16.
>
> Want to point me at your branch?  I can run it through my battery of tests, and
> maybe save you/us from having to spin a v17.

That would be great. Here it is:

https://android-kvm.googlesource.com/linux/+/refs/heads/tabba/guestmem-basic-6.16-v16

No known issues from my end. But can you have a look at the patch:

KVM: guest_memfd: Consolidate Kconfig and guest_memfd enable checks

In that I collected the changes to the config/enable checks that
didn't seem to fit well in any of the other patches.

Cheers,
/fuad

