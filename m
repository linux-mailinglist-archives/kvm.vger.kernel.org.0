Return-Path: <kvm+bounces-53001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F96B0C70C
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19C3F1882646
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2054828A400;
	Mon, 21 Jul 2025 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e/GrPlEF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D670C289E07
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 14:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753109745; cv=none; b=XQX3Isi3xYEJUk5jwtj02MISPRoSqQLh0+EqmnAQtrW6qKsqUmBZaX/fWi11S9wP26N82lan2o8RoDyhjr5XarBpYsR+xBTzoUrwtzRny84+uo+IvX0q6V+1yAHAKmnSzEFSv1/OYQ7gIz505kqDtvn0HGxK/IgymYe+/jmChOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753109745; c=relaxed/simple;
	bh=T92uPXfYGURbpMpAnfHw3K02jpN+sfhbXqSdhB3YZ0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kk6MtHc3gHIvI2Lts1mYebdmP9HPZJDO9RXRFTQxbIqPZgE5AY6xalstlXoRak1CPADIf73S+eGINxXIaljDQ0Rb34h7WDaG1I/978bSbzB6zAKihIuGP73xirW6XK+5cVx3X1UcNvKfHVCP5f5TY42EJAIvsWDMYl3MSWFWt2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e/GrPlEF; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ab86a29c98so597681cf.0
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 07:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753109743; x=1753714543; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=62Qcferz2ta5LRJ88jGpd09cdn6J94mnG93fNoCzAck=;
        b=e/GrPlEFbHjYDpwQ/sGuuB1+ZW9ujlouj5PLG9kXZs065JKJVUzUczDkq4Pw4HlFV0
         /MaBfJzRHU2YiUDUohCUwgrjbJJ3SeK9jRT3+iLeD8R2f0hM6tUyr4UuJG4paZYrc5xr
         Ag/P85DwnBDxuveiR7x5LeWOURkmZViATZHgPrgUt9FKPNFLDHwnvY1Jgbh8T8cdU4U7
         7pE2tQhwbd94CySXB8EpCR0SRiWoDE/LjsQt4MocpMiqVRGosdvIdq6p227dHbw3rV0Y
         Su7BVxOmAFPTjWUzx/YsYd1+5aaikFoQZqMVbiv59JCVdT2KCsRI0J2EYA8eNZWjFSMh
         /KsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753109743; x=1753714543;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=62Qcferz2ta5LRJ88jGpd09cdn6J94mnG93fNoCzAck=;
        b=mLNpM5mDBabexr6E8o3ZMk4yWElJIt1cR4lQL2bmlLdZLqUd7LajR58lHZbHYr8ZHN
         Aoh4lbl8lfObZMmJwZ4SW1lHlHfPB831/iNrsVRw+Hgg3Gt/ARDNhl+9b8J29BIHL82K
         IM/mWYB+7yCivcvdgyQNQ/+W/vVV09QlORMAogl7j+I3iyP5UF1Ho1ACNO+EEiEwii3x
         BcVXiVNf+D8h5AId9mzn6dduNnyD8h0upuc3eS00WZyXjeslqswaIfmwEBVuCV94xi4v
         2TZmPMg44rSjcXt46XQQEEG5G7/3w9sa/yqt/m7KnEFcaK0Kms7tYfrXl2kf2BHnnxHG
         /aYA==
X-Gm-Message-State: AOJu0YwQg080kL0X3GmRx0OaoG11zHKLqRv1RiyKjOMeRdVhMQX9gtlY
	PlDvT7tEiZmPSQga6kpUjmCYg7LjE+nMoX7CkuOjXkE3ZgZGlUSv6xg3+s7YhjoqLvUWO7uEq2K
	2+fsuC/0AJzz7UpEtDoM6BesnAH+URl8I7gTBPsQ2
X-Gm-Gg: ASbGncvNHBh8I+2K9WMxvkjIcmwt4j/iPUjwsWjuOsQ0J0TL6Sd55FyOZZjij1xfwAP
	slI9pTEELPXpDBuRpd7RdeKLzD7M87W2yovh8l3YhFSidNzQYrk6CPD2I8WmspaNiOy2ei3cwgP
	iHDf4aRxtB+DLTVvsW4D22HjTvEvNo2DgTXUl4KLZarP0toUSv9FmiQSFBxBtq5BVvDjIZZ982o
	g+wjt4=
X-Google-Smtp-Source: AGHT+IGTWuuHynD3kVjQ3ZKHxL2xoSxYhOwKveCXiaEd28ZSrOCHoXsuUfMk6n8k1GpDWeaMa4Ky635f1p2QoKHv8Vw=
X-Received: by 2002:a05:622a:8389:b0:4a9:b6e1:15a with SMTP id
 d75a77b69052e-4ae5adc307cmr26501cf.24.1753109741967; Mon, 21 Jul 2025
 07:55:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-4-tabba@google.com>
 <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
In-Reply-To: <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 21 Jul 2025 15:55:05 +0100
X-Gm-Features: Ac12FXxjOmMLuWpZC_TS5imBaYfBYtso3IHhWRxC85v1TVvpzPnUuCfabMiBMwM
Message-ID: <CA+EHjTz3Fq99q0cbkEK9KKzpSUBGfmnn_fTrQ1cOuUAQDz7=ng@mail.gmail.com>
Subject: Re: [PATCH v15 03/21] KVM: Introduce kvm_arch_supports_gmem()
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
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

On Fri, 18 Jul 2025 at 02:43, Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > -/* SMM is currently unsupported for guests with private memory. */
> > +/* SMM is currently unsupported for guests with guest_memfd private memory. */
> >   # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
>
> As I commented in the v14, please don't change the comment.
>
> It is checking kvm_arch_has_private_mem(), *not*
> kvm_arch_supports_gmem(). So why bother mentioning guest_memfd here?

Ack.

Thanks,
/fuad

>

