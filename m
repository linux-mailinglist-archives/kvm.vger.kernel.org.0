Return-Path: <kvm+bounces-48723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D9D2AD18D6
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:06:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22904169C5E
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 07:06:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79DBD27FB38;
	Mon,  9 Jun 2025 07:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hth+lJFS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E0011185
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 07:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749452800; cv=none; b=Lxz1gxaR+syFWxkbj6hhwRzVMAKLTg/LcgTftU5vApUefz4taMbCwqsJZif5DZJ2Dx2pZ20e9+j4szq+FCV9o5swwwEbZ4ECN7OB/s3X/64RuNEt65UPu6v90Fcvmy0uehgBSZ9aQk28zsGJavWhdetZ9EGJlvkQy3QYIcdNPVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749452800; c=relaxed/simple;
	bh=/nYlTVFkGT0OGtHTSp/hNQUXe1GD1QSrgJLAsAVqlnE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CAbqMSWQO6hhtbbhVlvzVqfBTBIBm1CIUW+ni0vtLJ6nXdugOIJaaqTczH+pfq42KnrBOy05ZRnKmMTd4thDg6dOuORV1e2KTEIYd2FDz2EebO1riGAplCi5zUtwr7M77Eb8PhNRQ+Lr68DbEjK8/bAKITh8Vqyl3IHAmh6lUKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hth+lJFS; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-47e9fea29easo510491cf.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 00:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749452798; x=1750057598; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=njmwY/aoE2EHkI0yhj8tKMubAoBenpVg25f6lK/8keo=;
        b=hth+lJFSHydmbbi17hgU8iLqstIB/4OHC7dLwB6AGUcM3wqjbj2hplV6CBCGCUHg4j
         24z1Li76yKFWoq+q6RSll0OtQWUJjT8UDXtxgRz28+/WCvBvYtjI51n66st9EXjb9pvM
         bvxtW54Vff3hfoUVjWPyD5u4eZF5aVKaaeukPuJCxXl/220yBab6jKLC0klScLzN3YxN
         c3E2WMXsovqxcwEsQA3Qo4AtVQaUsc/XoUyIBmA+5WJY1iD96ZiV+atoe6c1zn+u7GpM
         wr9uN2iugDS9/jTMoL9KlzfAbNdHdMY1awtQ2YQIeV1EdHiqa6uUXqYSHatey6xcMte5
         ByFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749452798; x=1750057598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=njmwY/aoE2EHkI0yhj8tKMubAoBenpVg25f6lK/8keo=;
        b=O9gIJrZF3bgANYVziBBoFGIEUKi26v5Lu3x4i77zZyRXi9xI67y6pYf28317aoYIhG
         /lQ0Uj6EaraeIJ/nk62MM9G43tZdRGNtIhwZUPyxS0cTvBeRn2OOyhLLGPhPtzruX32I
         6GLBPvvA+hhfa70uh4s0KU2DmecAWwZISE32GbsxmHiI9h/ab2teVm7hw0TNXnbVxAHs
         N4OHLVQQh60EDv6thROWxvpsnuswLbr4p/s0lq/TznRMKzUh0eKyo/iZA9NE75gIdUbr
         38qJ+NEBZo0t0fgzTQwmzdOYo526QzfbINHRArdqx2lb0rQIXSCIgvp7b5za/k/TSFR7
         9QmA==
X-Gm-Message-State: AOJu0YxmiUzteh3KWsZ7anKoiWtIgxC7AiMgnBzIc9Wju42FyFNyJg00
	Oom0No8FB2gHP8oyAYze5aYmg+lBh50+8JeiOTMOYAKkLmAMWqVkrd1Ej9QPdLcd5VG3G8d60B2
	iRz+VEowXSiB/b10DAUXT1BHmOFpbzGNqTTPA7/6b
X-Gm-Gg: ASbGncvYjFb7WMBL7PDC3YOQ57Fl8xKxGf5ptsd4XXXGFCtAeiMcZ4JIepV2TJ0WyFV
	ufE7Qf7KF7rFgWoFFbAxXGdvWYTiroShfQi7czNmUzTNO7W66Un9Ms1v6C0NyKcs7sFUzGBCefb
	ftwH2vxE7XLn63e7a2HL5f69o5w/+1LO1ITIX2t0lrjGcwheMyza5TKw==
X-Google-Smtp-Source: AGHT+IGchZ7SLhMAZ8W5hxY3EegUp7fjwAy75x4g922pGqe4NGnjJFDVi+3Q9Wgft0rlGl/fT20Fa5nQRkS1NNQ9g2g=
X-Received: by 2002:a05:622a:309:b0:494:b06f:7495 with SMTP id
 d75a77b69052e-4a6efa728a3mr5651671cf.24.1749452797818; Mon, 09 Jun 2025
 00:06:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-19-tabba@google.com>
 <df4bfc32-d395-4f0b-8664-5c65e05f5af0@redhat.com>
In-Reply-To: <df4bfc32-d395-4f0b-8664-5c65e05f5af0@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 9 Jun 2025 08:06:01 +0100
X-Gm-Features: AX0GCFtgC2aghzzNsqRBIEjFjyqySUxgD1FLhPdmCAmQ5m2-5RHKx5fP1W3VLwk
Message-ID: <CA+EHjTxoBSpcLUVDhSq=0dmvP9znKqPRtN-mDZ2YTP+6un8NVA@mail.gmail.com>
Subject: Re: [PATCH v11 18/18] KVM: selftests: guest_memfd mmap() test when
 mapping is allowed
To: Gavin Shan <gshan@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, 
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, 
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
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Jun 2025 at 00:44, Gavin Shan <gshan@redhat.com> wrote:
>
> On 6/6/25 1:38 AM, Fuad Tabba wrote:
> > Expand the guest_memfd selftests to include testing mapping guest
> > memory for VM types that support it.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >   .../testing/selftests/kvm/guest_memfd_test.c  | 201 ++++++++++++++++--
> >   1 file changed, 180 insertions(+), 21 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
> > index 341ba616cf55..1612d3adcd0d 100644
> > --- a/tools/testing/selftests/kvm/guest_memfd_test.c
> > +++ b/tools/testing/selftests/kvm/guest_memfd_test.c
> > @@ -13,6 +13,8 @@
> >
>
> Reviewed-by: Gavin Shan <gshan@redhat.com>


Thanks for the reviews!
/fuad

