Return-Path: <kvm+bounces-37984-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37C86A32E86
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 19:21:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D02B97A1C2F
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 18:20:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43633263F32;
	Wed, 12 Feb 2025 18:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BMK0fhVR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7451E260A2D
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 18:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739384396; cv=none; b=MYYjYoaZXA2PV9ORvnw5cmz4oPPxCDsnMUqvX6x/lIOPMjDkisKL5EoIF9VnBaX+tckBLPOIZQtuoea2vVHiP+H8Xhz3ZAwpOLkavWM7eP3rHae7G0+pAUpCHipT1cEC85Mu2ZunL3hqjRWh+2uAhRsQb8lS83aD6bX7QWXA3eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739384396; c=relaxed/simple;
	bh=SU45/sVZe3bX14PqfSrlPSD+s0TbnFHh43x1wYWkSkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljbt1+A9v4k06IcDyxiDv9/dBgTcXB1XvQDCzTKb2zF9ndKek3jhUVT0nQne/9GppbXj2yCsYwdiJNADfHqN/JegzSRKpvLbwcHJwcyqX2W05KxO/mCTig/pIBxmPQ+MEj0i2wNNZ4bKaBZlDYVRJp/HLZAF3AjQTWY4hIM90wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BMK0fhVR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739384393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7TaJyS8UpMoetirTb14n4MP+blnMrufFTQ0BeKyiM/A=;
	b=BMK0fhVR27fLHnk1n90d4wHLgOsvz8Q3BVpUFZXAC30nWtLhc582HsyiMIBSk3P9eV6UG1
	EahY1LO/5OSmQVpsH6o7imn10mI/6u2RkGLWow+8+A2b1IHClqL3M8a717Y57yZYN1XYRy
	dNwaL1OVY9ZApuzwkhKxn2wBwFLnXIU=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-5MmNWakMOCaxp_7oaj58wg-1; Wed, 12 Feb 2025 13:19:45 -0500
X-MC-Unique: 5MmNWakMOCaxp_7oaj58wg-1
X-Mimecast-MFC-AGG-ID: 5MmNWakMOCaxp_7oaj58wg_1739384384
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-2b85ba34d99so76513fac.0
        for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 10:19:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739384384; x=1739989184;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7TaJyS8UpMoetirTb14n4MP+blnMrufFTQ0BeKyiM/A=;
        b=oVoEwnOYYz8EtKFE+byMZu/rbsfGxVaHaxlcpW5JJRRBXz/L1dPct4MMPk7z4u/Y/m
         CTm6oYCTDACMMJMNAUnO0hrg7BXCD9C3qs1tHIOcObqj3Ugf0cZzDbZQq0Dy/5Xbuvct
         CM9z2Dl7bmsnYfGUXKgwlX8f9vT9nHGtY/q9/AT3pXTuas4uSvqe4kO/jdVM1s32sjcg
         +crDTe0IKbY4JASh4gp4GUOAOamF8Jt7agyngxjzCcWZ+xbuixT/COEnbfUsrnbO1jvf
         zvskOsMO+dq2GUut+lebAJqdHdOH79PXYeZDlFssHcsSe0HT5UJYXRn2e5IbdDm7MUlz
         MDCA==
X-Gm-Message-State: AOJu0Yz+2Goc1Fpk9CidHI4+vAeNvoSmc3fMPLhazdAmuAOZA1H1ljUH
	hRzubdgxYEdFUcOOBUF5hmOlaKcopQSwSvk2xnN3xO3u9xhseauO/+AXLV9UkqIaOz3WFS/GPkA
	nz9KQ4TUfqzyEjQOzM8FE5WmwO6WLEG/aURZoYXFkkR62b45ikQ==
X-Gm-Gg: ASbGnctfoKMZJ0iZ8tgJTEbrr66DJtJLXpEV1E57KkDFBPDSXmobtOXxgcBmEJY1utJ
	EdPlMwxh8cREXvJSLXVP9gfFnWajz7/B/ew6bKQfdK+L+xOEkrUlVguftxS6BsI2gaPNDJF2t6g
	kCWO6qzI0wDhrOMMuVXHyq6C4nDH9mpfmKXrsjz7gcrZNH4QLySaFBiz2H9Z47t6um/sY4DwSSR
	mMEZHNFXwobaRrg6QJmT4+pHT/JLKej/Qebl4zmdphzJMYUYp1PzyIE3V0=
X-Received: by 2002:a05:6870:910a:b0:288:6a16:fe1 with SMTP id 586e51a60fabf-2b8d65a165fmr2608394fac.18.1739384384116;
        Wed, 12 Feb 2025 10:19:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6yLCJZv0DxHVkLCCWT8uUox4uppNsodWZzjO6mSf7H+Gw6LNzcNxExlJipAp5dck6BfMKUA==
X-Received: by 2002:a05:6870:910a:b0:288:6a16:fe1 with SMTP id 586e51a60fabf-2b8d65a165fmr2608348fac.18.1739384383715;
        Wed, 12 Feb 2025 10:19:43 -0800 (PST)
Received: from x1.local ([2604:7a40:2041:2b00::1000])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2b832f1e59asm4880842fac.49.2025.02.12.10.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:19:43 -0800 (PST)
Date: Wed, 12 Feb 2025 13:19:37 -0500
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
Subject: Re: [PATCH v3 02/11] KVM: guest_memfd: Handle final folio_put() of
 guest_memfd pages
Message-ID: <Z6zmOQLrAjhhM1Pn@x1.local>
References: <20250211121128.703390-1-tabba@google.com>
 <20250211121128.703390-3-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250211121128.703390-3-tabba@google.com>

On Tue, Feb 11, 2025 at 12:11:18PM +0000, Fuad Tabba wrote:
> Before transitioning a guest_memfd folio to unshared, thereby
> disallowing access by the host and allowing the hypervisor to
> transition its view of the guest page as private, we need to be
> sure that the host doesn't have any references to the folio.
> 
> This patch introduces a new type for guest_memfd folios, which
> isn't activated in this series but is here as a placeholder and
> to facilitate the code in the next patch. This will be used in
> the future to register a callback that informs the guest_memfd
> subsystem when the last reference is dropped, therefore knowing
> that the host doesn't have any remaining references.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h   |  9 +++++++++
>  include/linux/page-flags.h | 17 +++++++++++++++++
>  mm/debug.c                 |  1 +
>  mm/swap.c                  |  9 +++++++++
>  virt/kvm/guest_memfd.c     |  7 +++++++
>  5 files changed, 43 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index f34f4cfaa513..8b5f28f6efff 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2571,4 +2571,13 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  				    struct kvm_pre_fault_memory *range);
>  #endif
>  
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +void kvm_gmem_handle_folio_put(struct folio *folio);
> +#else
> +static inline void kvm_gmem_handle_folio_put(struct folio *folio)
> +{
> +	WARN_ON_ONCE(1);
> +}
> +#endif
> +
>  #endif
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 6dc2494bd002..734afda268ab 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -933,6 +933,17 @@ enum pagetype {
>  	PGTY_slab	= 0xf5,
>  	PGTY_zsmalloc	= 0xf6,
>  	PGTY_unaccepted	= 0xf7,
> +	/*
> +	 * guestmem folios are used to back VM memory as managed by guest_memfd.
> +	 * Once the last reference is put, instead of freeing these folios back
> +	 * to the page allocator, they are returned to guest_memfd.
> +	 *
> +	 * For now, guestmem will only be set on these folios as long as they
> +	 * cannot be mapped to user space ("private state"), with the plan of
> +	 * always setting that type once typed folios can be mapped to user
> +	 * space cleanly.

Does it imply that gmem folios can be mapped to userspace at some point?
It'll be great if you can share more about it, since as of now it looks
like anything has a page type cannot use the per-page mapcount.

When looking at this, I also found that __folio_rmap_sanity_checks() has
some folio_test_hugetlb() tests, not sure whether they're prone to be
changed too e.g. to cover all pages that have a type, so as to cover gmem.

For the longer term, it'll be definitely nice if gmem folios can be
mapcounted just like normal file folios.  It can enable gmem as a backstore
just like what normal memfd would do, with gmem managing the folios.

> +	 */
> +	PGTY_guestmem	= 0xf8,
>  
>  	PGTY_mapcount_underflow = 0xff
>  };
> @@ -1082,6 +1093,12 @@ FOLIO_TYPE_OPS(hugetlb, hugetlb)
>  FOLIO_TEST_FLAG_FALSE(hugetlb)
>  #endif
>  
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM

This seems to only be defined in follow up patches.. so may need some
adjustments.

> +FOLIO_TYPE_OPS(guestmem, guestmem)
> +#else
> +FOLIO_TEST_FLAG_FALSE(guestmem)
> +#endif
> +
>  PAGE_TYPE_OPS(Zsmalloc, zsmalloc, zsmalloc)
>  
>  /*
> diff --git a/mm/debug.c b/mm/debug.c
> index 8d2acf432385..08bc42c6cba8 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> @@ -56,6 +56,7 @@ static const char *page_type_names[] = {
>  	DEF_PAGETYPE_NAME(table),
>  	DEF_PAGETYPE_NAME(buddy),
>  	DEF_PAGETYPE_NAME(unaccepted),
> +	DEF_PAGETYPE_NAME(guestmem),
>  };
>  
>  static const char *page_type_name(unsigned int page_type)
> diff --git a/mm/swap.c b/mm/swap.c
> index 47bc1bb919cc..241880a46358 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -38,6 +38,10 @@
>  #include <linux/local_lock.h>
>  #include <linux/buffer_head.h>
>  
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +#include <linux/kvm_host.h>
> +#endif
> +
>  #include "internal.h"
>  
>  #define CREATE_TRACE_POINTS
> @@ -101,6 +105,11 @@ static void free_typed_folio(struct folio *folio)
>  	case PGTY_hugetlb:
>  		free_huge_folio(folio);
>  		return;
> +#endif
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +	case PGTY_guestmem:
> +		kvm_gmem_handle_folio_put(folio);
> +		return;
>  #endif
>  	default:
>  		WARN_ON_ONCE(1);
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b2aa6bf24d3a..c6f6792bec2a 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,6 +312,13 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +void kvm_gmem_handle_folio_put(struct folio *folio)
> +{
> +	WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
> +}
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> +
>  static struct file_operations kvm_gmem_fops = {
>  	.open		= generic_file_open,
>  	.release	= kvm_gmem_release,
> -- 
> 2.48.1.502.g6dc24dfdaf-goog
> 
> 

-- 
Peter Xu


