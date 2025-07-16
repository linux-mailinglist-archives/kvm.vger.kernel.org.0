Return-Path: <kvm+bounces-52614-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 770F3B07427
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 13:00:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A28F518904DA
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F492F3622;
	Wed, 16 Jul 2025 11:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pm8zFXdN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFC42C15B9
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752663621; cv=none; b=MR+lAjKxx9ujsbvEo1hyRl51x8KquVbftKxnXHoSgUOUw2dD0Ogyo1YwXSAW7OMDKmgMOBnN207PwjdeOBJAbevoAAqmJ+4oeRHRAbc0VP6Jw3BcHxu9jx/wxnngOMXKwb+I2a8peK3oYCZuKi5M9hZKLW9QTRbDRLvcAy3YDaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752663621; c=relaxed/simple;
	bh=WEL3KqF/GpMex8AfuvzJH2hVcfhrkUtP29xcoofDR0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDFJjAK2Ztd3k4ys1O2MfgOJXqbEh/qs87Y/gjlWtC32HAGWrRdaZdGGsAOi327h4xAS85wh7Oai4eEO5DdlhtyKhelGFt4/U8eGXF2VbhKzP8QCKzlPBq1WvYsMbzM5w7655ovO7wsMlxic10XQIQQS2U8+PxidwwzAfBc1Hu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pm8zFXdN; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso159961cf.1
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 04:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752663618; x=1753268418; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WEL3KqF/GpMex8AfuvzJH2hVcfhrkUtP29xcoofDR0M=;
        b=Pm8zFXdNZac7t0ymJlsEKP4MIlrRtm8pAAjG6XTEA7mDXB724dHPbqOlB1lyU0dny0
         GR/vy/zuvGmOIMMwR7czqFRUNsPlkpfDKO/33OBRhnc8C+TbFERb60O/JUkY2freClJh
         GXknNDC+J4YOR0ERFCnW5MVyxUegfMgDp7FNgZtpSygJEqI6y8ZKAVvdckFl1SAgKjoG
         rX8KhdFIJzLZ6iy37tXkS/PIBgW6xu9VLA/GNJgvoufVKfhhuw51yqOFCo7/xErF4kAH
         9cMYZLOJW8wG/TALIFbKsgClexuOGmQyyTnA6ivv5m6D4R2DGg6it/CJujjL2IhjlOmq
         Lf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752663618; x=1753268418;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WEL3KqF/GpMex8AfuvzJH2hVcfhrkUtP29xcoofDR0M=;
        b=APC2KttfHseptboDMMLnKuE0wwe78QLNF89ciSCYE8xgg0cYAMKSKEsgYeBU9HNh/x
         mxX83Q+0JE3d73te2DjSUtHfjbkVkV05UkO//I5Wg4J0htQbvnk72nFnaHKjqOP4Nhwp
         8girIMPltCXKcoRsS/MyGm4j36M6xrgX869Rj74lCX0LcuKgBexYN0yk9H5ydF/jOSgp
         ICubov5j/MW2IT8PoMCaEdGCSJwlK2axUh3xiqkjHPywpA+ZLPT2rktQHpoGxHUHLyII
         ElHQVEtkWdtcFyWLdMQW6Jwz0xL4xz3TFgk0ppd1cmAUUmt/c6kV4Je9yiHP9hXBbWTn
         kMlQ==
X-Forwarded-Encrypted: i=1; AJvYcCU9x4RcZTTHrfLmwgBmDL7y0BnAGM0BDf/PkqUeUzeHNXz8mq8ahX/vLidS5m3EREEep9k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn/JF8COPEleviMbNJgoPqfRMMjix888QXe5XcL5W85/WXb+i4
	IXCxQIrhjv/qhjLy+n5ifXKwO4SMhNW+csxij0PcaJmdwgbhFx1QVLsUh4+5U+bT+S+GaFMMA/0
	6sPr8RJpJFpQdIUSJdhQ1sQHIl0X0AtzDRHY0GuGT
X-Gm-Gg: ASbGncs85Yb2K5cEJ0ZKPxfV+0z+Pb6e8AMG8/N1vkMi2cD3Zyx8UfbFAOd69XwY2/W
	lWdGGwxdh0qP7bLIZkWFG44BfOo/6U2u0AN7TVeOyEfwhJ7EqXTVCN9To7ufmgLJ1KcgN7gfqxr
	yK4/uKP5shENSrsiW0qjNlLNd93veUgOL0f9irqhXNeG5WDpFYTJhQoX77NlqYbMHBlprmKoWzj
	Fuq//EOdhYhY0wW6XRxTaE8uBKiuL86ZXOb
X-Google-Smtp-Source: AGHT+IGm95NUdK5ftP1jftdordV3iftsesNlsHHVUEP+SmlFPVMmNXMBat3YpfN3rnpVHPoTr0gIhtAtDGvUQcp/clk=
X-Received: by 2002:a05:622a:8317:b0:4a9:d263:d983 with SMTP id
 d75a77b69052e-4ab954af75emr2016961cf.22.1752663617597; Wed, 16 Jul 2025
 04:00:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250715093350.2584932-1-tabba@google.com> <20250715093350.2584932-10-tabba@google.com>
 <eb9d39b4-0de8-4abb-b0f7-7180dc1aaee5@intel.com> <CA+EHjTw8Pezyut+pjpRyT9R5ZWvjOZUes27SHJAEeygCOV_HQA@mail.gmail.com>
 <b7feea89-be2d-44a9-b116-fb07d16e3bd3@redhat.com>
In-Reply-To: <b7feea89-be2d-44a9-b116-fb07d16e3bd3@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 16 Jul 2025 11:59:39 +0100
X-Gm-Features: Ac12FXx9zd9JVkXqY3lez4L9ptxfAF4QCJ83KzlvcvcQhQV6SV5GBIjlcQUn8Vo
Message-ID: <CA+EHjTzCRvg130oZFy6xRYr4WTw0afo3sjBSZgLf_4XEe8iBTQ@mail.gmail.com>
Subject: Re: [PATCH v14 09/21] KVM: guest_memfd: Track guest_memfd mmap
 support in memslot
To: David Hildenbrand <david@redhat.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, 
	amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, 
	mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

On Wed, 16 Jul 2025 at 11:31, David Hildenbrand <david@redhat.com> wrote:
>
> On 16.07.25 10:21, Fuad Tabba wrote:
> > Hi Xiaoyao,
> >
> > On Wed, 16 Jul 2025 at 07:11, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> >>
> >> On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> >>> Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
> >>> memslot->flags. This flag tracks when a guest_memfd-backed memory slot
> >>> supports host userspace mmap operations. It's strictly for KVM's
> >>> internal use.
> >>
> >> I would expect some clarification of why naming it with
> >> KVM_MEMSLOT_GMEM_ONLY, not something like KVM_MEMSLOT_GMEM_MMAP_ENABLED
> >>
> >> There was a patch to check the userspace_addr of the memslot refers to
> >> the same memory as guest memfd[1], but that patch was dropped. Without
> >> the background that when guest memfd is mmapable, userspace doesn't need
> >> to provide separate memory via userspace_addr, it's hard to understand
> >> and accept the name of GMEM_ONLY.
> >
> > The commit message could have clarified this a bit more. Regarding the
> > rationale for the naming, there have been various threads and live
> > discussions in the biweekly guest_memfd meeting . Instead of rehashing
> > the discussion here, I can refer you to a couple [1, 2].
>
> Maybe clarify here:
>
> "Add a new internal flag, KVM_MEMSLOT_GMEM_ONLY, to the top half of
> memslot->flags. This flag tracks when a guest_memfd-backed memory slot
> supports host userspace mmap operations, which implies that all memory,
> not just private memory for CoCo VMs, is consumed through guest_memfd:
> "gmem only"
>
> And add a pointer to the list discussion.

Ack.

Thanks,
/fuad

> --
> Cheers,
>
> David / dhildenb
>

