Return-Path: <kvm+bounces-49885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E4AADF0D5
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 17:12:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2DECE4A0E54
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 15:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B8D2EF2A2;
	Wed, 18 Jun 2025 15:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="hXnkgei+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5664E13957E
	for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750259535; cv=none; b=OKefICSYfbk1JqKF/XnMA4HgBlCRK1Tl58uOETyVr8FvfDKRv7tRRWcDCzT6U5UqJj5cGBLciHkLqZ04hSOMMeR5/e3t6Mk78T28dhEGjtYqNr36G02PiYPHwiaVS6Fe/udXL2FDmd/vxAhAoUSVtrFMb4DFuwkXTAFXh0pwBI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750259535; c=relaxed/simple;
	bh=S9CRGFxZrsWQiCny4A4jtEs+ZyqisFVOoxUZS4pQsAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pDU7Furn19ERUVZGs2dpgtEYQNCQvQAVzD16lzjA0PKDX453LzdpWXHotgLVlD0mTpjQGxnu1X5yV2De3w94NMm9gmodoWvAe/8OG2nl736p39tCyShX49FZTONhTdc4NNmlHq4oPiO5H9oT+Zntxy1+jaGzwvs5o6T+2PYlik0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=hXnkgei+; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6fadb9a0325so59865436d6.2
        for <kvm@vger.kernel.org>; Wed, 18 Jun 2025 08:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1750259531; x=1750864331; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8w7ovcA+eQ/2b8rTRZRntXptSXxd0DShnhC4amsa/B0=;
        b=hXnkgei+GvAnXgvPWlRXZmB61e4NSw3VNV7hgtaLxE37zsDxFdKtJ/JVtovewvFlxP
         BRigJGwouWNb/jP/l5rLf6wklgPEEtMX9ykrmBG8tArz+bONfw1mrWhNYGLV9tdhK17h
         QMdRvlVoIAy+mnhBaSseAQhT7y4WICxcEY4Zt3drIDPdh/Grd/Fk8tFRPEL0UcHcRWug
         QO7j1LyEhOfWZICyHdg3sqcsZVzOzj4lzY+RT6eA4BKvPh7Sus3QQPCOsjOue5nmHGje
         e5mGy9ggdOQg0cQlN+wwwAtOaTW197HmFDXjOCmWVNrbLCdYKO8gXYtCHMZ+0K7jLewd
         ZDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750259531; x=1750864331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8w7ovcA+eQ/2b8rTRZRntXptSXxd0DShnhC4amsa/B0=;
        b=fx4fwCywCkPYiPlNrzRIi6U2iXO6StDwhsWfywSSgYFfzgt2wAAOE7kgF/glu/ecyG
         OegPjhhyQvYapgZjUG9/d3bWiKTCvYGAYlN0LqjwD6gNqE+JXAn/wEa+DBgZNSRE8YBs
         x76XELgp/ciTcN/SSZji+xIPnKNcO4lYF2TALQS4BQOSYgDBQnlODtwzlJfMiJxQrw2k
         l5xk4lHdatznkv3brRt0IuhWFfVjXWVG5tFRrQXnpKezTTT/R13H06uQIWpN48u3uVOi
         HrS9/FdUmZF8EZSPl4Rt4AtbJp/8LjY15GmYxjjj3P39YR4IACf3WrHiTaeCbDP6MqGo
         naLA==
X-Forwarded-Encrypted: i=1; AJvYcCWisRN44LRNe/lOQ9H1pyRd5Yw4VbooJa1vQwyCuwwy0C7dLV5OZjXqfsRmLmDO8mzA4Ik=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwWAuifUvjRJibtHR3qnrbfMqjN9Qu6eB8s18Gq8SjtG7LEsXx
	XsmIvWrY/g6mgMZVQzfbLsObRCE+HlJ7FRYzSRBjVfydXUW8tpng6AGrcdlruj3Owkc=
X-Gm-Gg: ASbGncu8kwEGPcNOlNtTJF9ubRF/K7v1i3ZplCGoHNvnSb+LHprosn4qbWYPqs4ddcR
	XH7SLZbD82C3mu5jlKY8HiN2I0fHIN611M6vamDLJEmJZv1mPofh5RO/BZimzPBvcxF3tPa9sTG
	XcOn/aOihKv7uk3I4w8amcQB9/GG75/d/TtQFyVp2S033i/LlbLxGxvJTApITHgFo5kH7aMoLcW
	J7IO4B18+2H48E8oZYeaTq3CEXSyqLrCBMyPo+0qU7pBRJBrMQ2YhnlekGfuhMiuqm5JwxoRapu
	mFxj/64F98mvtUM7FSErbdx1OpiF1czrvOyc4gQjlSkjCvyBW7XIeT4badnh3Ef3Bvzu
X-Google-Smtp-Source: AGHT+IHofhP9BiiWq9pfl7Z5RgEudETJ5GYEen3cpQ0dOiuu8S3eCNtXQb4YOLf1G9jX/1/pyfy2rg==
X-Received: by 2002:a05:6214:570d:b0:6e8:fbb7:6760 with SMTP id 6a1803df08f44-6fb47725d95mr260081446d6.1.1750259530934;
        Wed, 18 Jun 2025 08:12:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:400::5:cf64])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb4cca79bcsm45456016d6.6.2025.06.18.08.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 08:12:10 -0700 (PDT)
Date: Wed, 18 Jun 2025 10:12:06 -0500
From: Gregory Price <gourry@gourry.net>
To: Shivank Garg <shivankg@amd.com>
Cc: seanjc@google.com, david@redhat.com, vbabka@suse.cz,
	willy@infradead.org, akpm@linux-foundation.org, shuah@kernel.org,
	pbonzini@redhat.com, brauner@kernel.org, viro@zeniv.linux.org.uk,
	ackerleytng@google.com, paul@paul-moore.com, jmorris@namei.org,
	serge@hallyn.com, pvorel@suse.cz, bfoster@redhat.com,
	tabba@google.com, vannapurve@google.com, chao.gao@intel.com,
	bharata@amd.com, nikunj@amd.com, michael.day@amd.com,
	yan.y.zhao@intel.com, Neeraj.Upadhyay@amd.com,
	thomas.lendacky@amd.com, michael.roth@amd.com, aik@amd.com,
	jgg@nvidia.com, kalyazin@amazon.com, peterx@redhat.com,
	jack@suse.cz, rppt@kernel.org, hch@infradead.org,
	cgzones@googlemail.com, ira.weiny@intel.com, rientjes@google.com,
	roypat@amazon.co.uk, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	kent.overstreet@linux.dev, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, chao.p.peng@intel.com, amit@infradead.org,
	ddutile@redhat.com, dan.j.williams@intel.com, ashish.kalra@amd.com,
	gshan@redhat.com, jgowans@amazon.com, pankaj.gupta@amd.com,
	papaluri@amd.com, yuzhao@google.com, suzuki.poulose@arm.com,
	quic_eberman@quicinc.com, aneeshkumar.kizhakeveetil@arm.com,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH v8 4/7] mm/mempolicy: Export memory policy symbols
Message-ID: <aFLXRtCDfoNzQym6@gourry-fedora-PF4VCD3F>
References: <20250618112935.7629-1-shivankg@amd.com>
 <20250618112935.7629-5-shivankg@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618112935.7629-5-shivankg@amd.com>

On Wed, Jun 18, 2025 at 11:29:32AM +0000, Shivank Garg wrote:
> KVM guest_memfd wants to implement support for NUMA policies just like
> shmem already does using the shared policy infrastructure. As
> guest_memfd currently resides in KVM module code, we have to export the
> relevant symbols.
> 
> In the future, guest_memfd might be moved to core-mm, at which point the
> symbols no longer would have to be exported. When/if that happens is
> still unclear.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/mempolicy.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 3b1dfd08338b..d98243cdf090 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -354,6 +354,7 @@ struct mempolicy *get_task_policy(struct task_struct *p)
>  
>  	return &default_policy;
>  }
> +EXPORT_SYMBOL_GPL(get_task_policy);
>  
>  static const struct mempolicy_operations {
>  	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
> @@ -487,6 +488,7 @@ void __mpol_put(struct mempolicy *pol)
>  		return;
>  	kmem_cache_free(policy_cache, pol);
>  }
> +EXPORT_SYMBOL_GPL(__mpol_put);
>  

I'm concerned that get_task_policy doesn't actually increment the policy
refcount - and mpol_cond_put only decrements the refcount for shared
policies (vma policies) - while __mpol_put decrements it unconditionally.

If you look at how get_task_policy is used internally to mempolicy,
you'll find that it either completes the operation in the context of the
task lock (allocation time) or it calls mpol_get afterwards.

Exporting this as-is creates a triping hazard, if only because get/put
naming implies reference counting.

~Gregory

