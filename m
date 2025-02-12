Return-Path: <kvm+bounces-37988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14668A3316B
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 22:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B719D166385
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 21:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 541DD202F68;
	Wed, 12 Feb 2025 21:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HzPSLlh7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21781FBC8D
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 21:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739395445; cv=none; b=AHnnk3aGDjdvc7fFIlaGsK8m6J7xXv2jSwZiZnC25hMwoKOBXprQ0DKC5QhVmsV+GTW2SEni2mVYXOHD+tQWOz38AnXfXqhTTUNm9SOtEEHVpT+0tvJtr3jPMdcFlQSzZhwPYRmrSfH9snoT6Uwa6Tkfy6SbwvSqC1kroMEy2eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739395445; c=relaxed/simple;
	bh=TT8QDCIDQGCMkNj7vFXoOL/LNDDnvNdI2Z4hRrVEWhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pWKN72iYFm8nVsw8xil/HoVk/hCZK+L2gcOr/6mwag8+PV/RTR5nrjrfdlwrAEqaLf4QTldH/KG/8hfrH8APcOnp+cGV7T9Pirq7RSdi81SrcJWfk4Q8skWESGHN0hNHlsvAcTNahRUqPqEdEG9QVcshboQIYAUToa29x8r3Ymo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HzPSLlh7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739395443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rMR3xW0eowjAI1vyo1tpASMiTeQNf0mRWejyS2lahAE=;
	b=HzPSLlh7zEkcGQ8KyUMGIQI0YY4Yows+7a9qaL9yvQO/noH25LEXx1gbHjNhyu4FnFPq2B
	CPs5RmV6kP9hbNo9vh887qTYOulYehOfS6wHva0VpImjstSV7GPqdJ5kowkTgq0RWqxY+g
	RM8F+okP9Z9iC/6H8kIFf7ou1DIemYY=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-F3sxopjpP6yKC6lX-M2Dyg-1; Wed, 12 Feb 2025 16:24:01 -0500
X-MC-Unique: F3sxopjpP6yKC6lX-M2Dyg-1
X-Mimecast-MFC-AGG-ID: F3sxopjpP6yKC6lX-M2Dyg
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3f3412843dbso133344b6e.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 13:24:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739395440; x=1740000240;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rMR3xW0eowjAI1vyo1tpASMiTeQNf0mRWejyS2lahAE=;
        b=TzNiAGSFF+gpa41CS5VQZoD658kXo+84fVy6WroZVoYMfRxwxmSBJF2sswjJb7Ie0n
         /8vz2CMYK83GxQsyAa8ouzkU4JZxJ7BLt7LUp4BTcAHUNiW/Ax5jtXIhnfxRs01yRGxL
         uFi/pakGLRFVkfVXhxXA1ZH8U3+z0PGv6EAFPt3w0xXI/2S1EIr5bIfNTnT/RarkI+uA
         AVqRkZ8L+bDzy7gEpbZ4sf8npSz2yKKr4dNtm0jD+Y6jIkIbDoVWOQzXN3s/1rfHRSHh
         QgFbnE5/odgueqwUtzd82kO8NmukBeZNSQQSpVRBbfgJlaw7gm8G8PIkZtST49zfPhW1
         ESvw==
X-Gm-Message-State: AOJu0YwPxNhhR3LAQlNY5ul1L6IKyMZZvr059MUteOL3HBP/YQYipXdf
	ilxBjNwiAUz621PuMyVUYwoMOIgxXiOuPAUwAO4ah2Le8xqIinVEWUZSXOaXC6zcE9dXS8wiX6O
	HQlspUwxLzLuIR2FpbOJzVgSQ6vL8ZKaHMBkEOBAQTsqY660SSw==
X-Gm-Gg: ASbGncubtrD0hHgiUyg9S7aH4bBT3wADgkhuMal2T7U1Va/miE0onWRhIaTxnwmioO6
	icpzaUyLSY0+/BkR1kf5AXKLpElRowMsHho1RnYykP51G/u6Pua+gFmZGsHUbHmjl+lM0JC0M0S
	Su7WEnRhKYaxpuqT5z++E0XqPBEt3OvlUXlLrFXuVVOsivAUcA9cTCMQfnC2sz59TLAfcvsy6Wk
	l2y538t8AeTsybk9FTJS4VjIwOqXqI22BxZoSA4vdry0ysB9sW313Lqpis=
X-Received: by 2002:a05:6808:2e9a:b0:3f3:beb0:f89c with SMTP id 5614622812f47-3f3cd5cd00cmr3215266b6e.12.1739395440675;
        Wed, 12 Feb 2025 13:24:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFY2m3xIb+XCqqJUt5LWlRvkVKJprpgK78iqDdhGlaeRGKuKuddp8PHVk68yR2vDMJ2oP4DmQ==
X-Received: by 2002:a05:6808:2e9a:b0:3f3:beb0:f89c with SMTP id 5614622812f47-3f3cd5cd00cmr3215250b6e.12.1739395440341;
        Wed, 12 Feb 2025 13:24:00 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f389ea9194sm4723990b6e.10.2025.02.12.13.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 13:23:59 -0800 (PST)
Date: Wed, 12 Feb 2025 16:23:53 -0500
From: Peter Xu <peterx@redhat.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, yu.c.zhang@linux.intel.com,
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz,
	vannapurve@google.com, ackerleytng@google.com,
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
Subject: Re: [PATCH v3 03/11] KVM: guest_memfd: Allow host to map
 guest_memfd() pages
Message-ID: <Z60RacIJMwL0M8On@x1.local>
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250211121128.703390-4-tabba@google.com>

On Tue, Feb 11, 2025 at 12:11:19PM +0000, Fuad Tabba wrote:
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 54e959e7d68f..4e759e8020c5 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -124,3 +124,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE
>         bool
>         depends on KVM_PRIVATE_MEM
> +
> +config KVM_GMEM_SHARED_MEM
> +       select KVM_PRIVATE_MEM
> +       bool

No strong opinion here, but this might not be straightforward enough for
any reader to know why a shared mem option will select a private mem..

I wonder would it be clearer if we could have a config for gmem alone, and
select that option no matter how gmem would be consumed.  Then the two
options above could select it.

I'm not sure whether there're too many guest-memfd stuff hard-coded to
PRIVATE_MEM, actually that's what I hit myself both in qemu & kvm when I
wanted to try guest-memfd on QEMU as purely shared (aka no conversions, no
duplicated backends, but in-place).  So pretty much a pure question to ask
here.

The other thing is, currently guest-memfd binding only allows 1:1 binding
to kvm memslots for a specific offset range of gmem, rather than being able
to be mapped in multiple memslots:

kvm_gmem_bind():
	if (!xa_empty(&gmem->bindings) &&
	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
		filemap_invalidate_unlock(inode->i_mapping);
		goto err;
	}

I didn't dig further yet, but I feel like this won't trivially work with
things like SMRAM when in-place, which can map the same portion of a gmem
range more than once.  I wonder if this is a hard limit for guest-memfd,
and whether you hit anything similar when working on this series.

Thanks,

-- 
Peter Xu


