Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BB045ED52
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377271AbhKZMGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:06:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229924AbhKZMEc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:04:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637928079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=htVA9Ky3eiWU2ZLKAstUa1VUWll1GNmlBwV0oBfJQmA=;
        b=T3hzlUTdnojPEMIp9O2wIB6V8q+jlXLoW7qO2n9Gy0w249yOaHiEv0KIOAY/3VuJ90GV2T
        q7PpgG01MdRRbcO+rUB1OI1Kts7I+BLKvxE83lWkoU4VmbxyY46NIwW2e3lG5PqPOKJU+d
        Qc2EFmL8QZZ/VP2DRRpss4kKrge+1fA=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-ObSBvuHzNI6B_3J0sIZ2SQ-1; Fri, 26 Nov 2021 07:01:18 -0500
X-MC-Unique: ObSBvuHzNI6B_3J0sIZ2SQ-1
Received: by mail-pj1-f71.google.com with SMTP id g14-20020a17090a578e00b001a79264411cso3202231pji.3
        for <kvm@vger.kernel.org>; Fri, 26 Nov 2021 04:01:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=htVA9Ky3eiWU2ZLKAstUa1VUWll1GNmlBwV0oBfJQmA=;
        b=FPxMheBIpKhCfW+Ebbe44GT5xodRIItfbB49YHQSHlxzZwnEpHA/hOctcas+3ovit2
         ieJgyog5pxg3tNd79L8UszSLdZTTNuWtzvr0U1rTIEBb1SY8kg/iPLKi4j5TepVmVmSj
         o8jOp1kUMObi76e9fiQvsEdJCc0dcw0pl72rR0og80dCCnO6diYUWe2jtZ+QJ7uEVUPg
         pcAGDtfV2/PUfKh999Ns/O0umm7arZz+ssRb4/ekxunNu0Qf7nLMLyHKEW1UT0+OWP1D
         v4ypjHf0RIFsL3ZmH3BfXAXPNDSXqXUVTAWKbYzZgtbJpAEyg4gIElgv3P5ZXIntVkJ5
         rTmg==
X-Gm-Message-State: AOAM5308nnZjmtvXLu7HbVkdf4vZZgj8+//oQ1f6Bb0TFjWtkeqx3/4Z
        6zeUZXuD/2geG873R879zPiGK9kn4yPU/rUSuWGgVCGWO+aEx5tgwv1WK+BpcCKw37S6j54obtb
        wgHAiMp/ksBoS
X-Received: by 2002:a17:903:41ca:b0:142:1dff:1cb7 with SMTP id u10-20020a17090341ca00b001421dff1cb7mr37703652ple.37.1637928076101;
        Fri, 26 Nov 2021 04:01:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxIql08PEapGRemLjFWrtEU7v/b+qUA0AyLdnzK/fvNxilo9JnHiuEaIVrDTmt75sycwefQhA==
X-Received: by 2002:a17:903:41ca:b0:142:1dff:1cb7 with SMTP id u10-20020a17090341ca00b001421dff1cb7mr37703617ple.37.1637928075834;
        Fri, 26 Nov 2021 04:01:15 -0800 (PST)
Received: from xz-m1.local ([94.177.118.150])
        by smtp.gmail.com with ESMTPSA id g22sm7295763pfj.29.2021.11.26.04.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 04:01:14 -0800 (PST)
Date:   Fri, 26 Nov 2021 20:01:07 +0800
From:   Peter Xu <peterx@redhat.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [RFC PATCH 12/15] KVM: x86/mmu: Split large pages when dirty
 logging is enabled
Message-ID: <YaDMg3/xUSwL5+Ei@xz-m1.local>
References: <20211119235759.1304274-1-dmatlack@google.com>
 <20211119235759.1304274-13-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211119235759.1304274-13-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, David,

On Fri, Nov 19, 2021 at 11:57:56PM +0000, David Matlack wrote:
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2a7564703ea6..432a4df817ec 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1232,6 +1232,9 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +
> +	/* MMU caches used when splitting large pages during VM-ioctls. */
> +	struct kvm_mmu_memory_caches split_caches;

Are mmu_gfn_array_cache and mmu_pte_list_desc_cache wasted here?  I saw that
"struct kvm_mmu_memory_cache" still takes up quite a few hundreds of bytes,
just want to make sure we won't waste them in vain.

[...]

> +int mmu_topup_split_caches(struct kvm *kvm)
> +{
> +	struct kvm_mmu_memory_caches *split_caches = &kvm->arch.split_caches;
> +	int r;
> +
> +	assert_split_caches_invariants(kvm);
> +
> +	r = kvm_mmu_topup_memory_cache(&split_caches->page_header_cache, 1);
> +	if (r)
> +		goto out;
> +
> +	r = kvm_mmu_topup_memory_cache(&split_caches->shadow_page_cache, 1);
> +	if (r)
> +		goto out;

Is it intended to only top-up with one cache object?  IIUC this means we'll try
to proactively yield the cpu for each of the huge page split right after the
object is consumed.

Wondering whether it be more efficient to make it a slightly larger number, so
we don't overload the memory but also make the loop a bit more efficient.

> +
> +	return 0;
> +
> +out:
> +	pr_warn("Failed to top-up split caches. Will not split large pages.\n");
> +	return r;
> +}

Thanks,

-- 
Peter Xu

