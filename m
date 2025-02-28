Return-Path: <kvm+bounces-39738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6246AA49EB3
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 17:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 628A1189ADE2
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 16:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7C7A2755F6;
	Fri, 28 Feb 2025 16:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z4Tyj+lP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717AA271818
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740759847; cv=none; b=AVium15duZE7L3bqn/HH3Y0pILfigxv88wBG/NltZC+BJddYvQW0+tMO3q/+tPge4CLJCtv4ZeeTaRUAIA1ektwJTX58eCWt8FiohyqyVeIUoBtsyW/wnhTmHGa4K5FBVCvrBDYLbBeVKgVFm4khI8jSpC4/fl06nIKmSjGQIPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740759847; c=relaxed/simple;
	bh=DIdk9cvonh0cWhcywg/PEu7UTE2tXfjWkb0MBkIpE2w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jStGQDP6G9BRj9HsT65L0MI3MNArXQSQisgnFZBXvvu51CMxG+I+K/LuhUZPDqsrpSxMdhGr8+Q+mlFIG6uUz+vumnMTnnhXmah+FMlSQ0YS23N2DvJxFwcxMC7Se4ye+D8J7sUvc/0GEzgCVg9h9yLFhovPpjzSdld1dwtQwGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z4Tyj+lP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740759844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uYI0vlZyC64AS4GVxFaAT8W4ll0MhAyDbelrl5Y3Uek=;
	b=Z4Tyj+lPRp7xblEccEXyJBY3S0vHmnEfKLGaLzeoGPA8DMjTecSBIhduhTiZ/s7VSTgtHu
	/fSf1AiCXkffeF3tt9k1BWiH4YNlDZFOmbibJHvPY7jklSEJt6WYQHs4jFMPw2Zjlxbiza
	w/BlhvnDUGjIn3bKIoEfCv6JqgG+JQ0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-9EJ11_LbPG2LOp6Iq81lxw-1; Fri, 28 Feb 2025 11:24:02 -0500
X-MC-Unique: 9EJ11_LbPG2LOp6Iq81lxw-1
X-Mimecast-MFC-AGG-ID: 9EJ11_LbPG2LOp6Iq81lxw_1740759842
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c096d86f44so404251485a.0
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 08:24:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740759842; x=1741364642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uYI0vlZyC64AS4GVxFaAT8W4ll0MhAyDbelrl5Y3Uek=;
        b=pMBiHcuuV9/WQJxvT1XQCtuBHy+fdMXdB0BcRbmQii6IS6tNDYFJB5nBCTxe/f9C6D
         +Sy5/m7PR0VPB788Na3gBuZsdxTVgMV4ZISM5rd9v32UMBowDSchLjofo0kZ9xBIhlOl
         dXXJzo1yP5+SA7t/ystgHtp1JdKWYarSDEpEYiSDiRGeg8dBoSNpnELJOJ4bQ7jSOuoX
         SRMgPAGAQdKHXzqWU9pCGJMJ4dZXCkxPvlCYWQQBchQb0n/DqiHa2MHRqDJgJo04bqfJ
         11Dkt8xqZNmK7FYdteVUsFwcoi2ESoFuoZVisCcCM3TXYSMY0XWJ4u5sysr1ZJwLVNrr
         8+bw==
X-Gm-Message-State: AOJu0Yww4R7IjR2ZOqz/WGwWko2u2eTB9DgePolqZJaMHfXSclRf7FWp
	kYES5pRdyZD/PchInjVnEjp2GolkrVIIbd/t6SZc7e8eHb4P0gPVK4ux1h4Ix8RIBV2A/XwnRSm
	CrssWUW33EJirTW3FjA6LBCz8fc8N56LXOcua0f2HvErhDtl2QA==
X-Gm-Gg: ASbGncsACFHdN5ynKgWzCw0pmhpNZNAJjdSQ1COEJ5LipOIf1VqXkk6d7XjSpdHH35P
	GZjrLXEPQhfNoZ8200xQncCHhIFBALHhqk3xcJoFexFN5WnQJJ2nBzUdUSgqBr8Ln6XdRMdo+S1
	TzP1u2C9jebc7pZE6DARSVtveB1QD/qQeaL/SMExG91ltEyZZcsMa5aTDprlVJPPRed4NwAuQcz
	jBiI/oqLVEOsF4+awgpAA2yS0GXoeo8l/mMOqSRvmicHqNM9bOgcOAbb1UmyhKcIsRZLQiX2mbB
	SbdiIyI=
X-Received: by 2002:a05:620a:4608:b0:7c0:c13f:4185 with SMTP id af79cd13be357-7c39c49da23mr583603585a.7.1740759842040;
        Fri, 28 Feb 2025 08:24:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExnELW4Wgs0tRW9CQ35XcwJhUH+A1yMpSXnIV/5wwwvQCQtoXyGWAYFfR96/rPAP9Kfr+Sjw==
X-Received: by 2002:a05:620a:4608:b0:7c0:c13f:4185 with SMTP id af79cd13be357-7c39c49da23mr583599685a.7.1740759841731;
        Fri, 28 Feb 2025 08:24:01 -0800 (PST)
Received: from x1.local ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c36fee963esm265695385a.23.2025.02.28.08.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 08:24:00 -0800 (PST)
Date: Fri, 28 Feb 2025 11:23:55 -0500
From: Peter Xu <peterx@redhat.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com, liam.merwick@oracle.com,
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com, steven.price@arm.com,
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com, catalin.marinas@arm.com,
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
	maz@kernel.org, will@kernel.org, qperret@google.com,
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org,
	hch@infradead.org, jgg@nvidia.com, rientjes@google.com,
	jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
	jthoughton@google.com
Subject: Re: [PATCH v4 04/10] KVM: guest_memfd: Add KVM capability to check
 if guest_memfd is shared
Message-ID: <Z8HjG9WlE3Djouko@x1.local>
References: <20250218172500.807733-1-tabba@google.com>
 <20250218172500.807733-5-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250218172500.807733-5-tabba@google.com>

On Tue, Feb 18, 2025 at 05:24:54PM +0000, Fuad Tabba wrote:
> Add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which indicates
> that the VM supports shared memory in guest_memfd, or that the
> host can create VMs that support shared memory. Supporting shared
> memory implies that memory can be mapped when shared with the
> host.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/uapi/linux/kvm.h | 1 +
>  virt/kvm/kvm_main.c      | 4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 45e6d8fca9b9..117937a895da 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -929,6 +929,7 @@ struct kvm_enable_cap {
>  #define KVM_CAP_PRE_FAULT_MEMORY 236
>  #define KVM_CAP_X86_APIC_BUS_CYCLES_NS 237
>  #define KVM_CAP_X86_GUEST_MODE 238
> +#define KVM_CAP_GMEM_SHARED_MEM 239

I think SHARED_MEM is ok.  Said that, to me the use case in this series is
more about "in-place" rather than "shared".

In comparison, what I'm recently looking at is a "more" shared mode of
guest-memfd where it works almost like memfd.  So all pages will be shared
there.

That helps me e.g. for the N:1 kvm binding issue I mentioned in another
email (in one of my relies in previous version), in which case I want to
enable gmemfd folios to be mapped more than once in a process.

That'll work there as long as it's fully shared, because all things can be
registered in the old VA way, then there's no need to have N:1 restriction.
IOW, gmemfd will still rely on mmu notifier for tearing downs, and the
gmem->bindings will always be empty.

So if this one would be called "in-place", then I'll have my use case as
"shared".

I don't want to add any burden to your series, I think I can still make
that one "shared-full"..  So it's more of a pure comment just in case you
also think "in-place" suites more, or any name you think can identify
"in-place conversions" use case and "complete sharable" use cases.

Please also feel free to copy me for newer posts.  I'd be more than happy
to know when gmemfd will have a basic fault() function.

Thanks,

-- 
Peter Xu


