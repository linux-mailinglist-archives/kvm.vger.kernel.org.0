Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F033C791A
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 23:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236119AbhGMVnx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 17:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbhGMVnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 17:43:52 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8EBC0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 14:41:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id v18-20020a17090ac912b0290173b9578f1cso2507444pjt.0
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 14:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vrEJ0IT39G6kebRkO06W9h6TS+oFcHPIOO8VkXk5PLc=;
        b=EkBKXPjG/EViWsVLjIMs74wrEbBjOH730bpAeV5qYqG+B0UneYTAvPtkjZLsA1rjv6
         w2jUhzukYTGEkN5V53eb/WR+qauAqVGwKHRRomK6w8HAJDVa0Y0cmRRMC6Asrnhn+dmU
         Pr04MUNXrEiPdlhTCKD8He9wd3WcedkSp1HqdGVZ3LTxko8dgwSkb+NL9zGmwj82jEX+
         4jUVWseWvcjt8nyo7DdqdbtPvzrQvh+WFPcKRKVuKqOh2es/FcR+fMIjPVhVOr/K3/O8
         SIBH9iBaiwOcJai9B60fJtXdnfezRqdn2ElMDDx4s5kmBvZSFew0evOajJJwFrisVLl2
         qfqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vrEJ0IT39G6kebRkO06W9h6TS+oFcHPIOO8VkXk5PLc=;
        b=LitjRYzwle9ZzGOD9TMFohaw3yqK+AL10p9phEp4WPPrjJn1SW1KWhYBJL+42b38UW
         VXhi+8e0elJMNWijPRE7FHHfSnqZcZwgswNZGZsw4ZHiZUt/+V3ctUjcV5PT4yxfvCiY
         gWy/hiBQCo5g/JHjnwTN4fWuqzWRLrHNMwrANIWPCtwleJ0Ldr4PWNpadX/YLboBUH4j
         GhV8Q5we4uo+neyRkm07TG6Nq1RO1A50NldnlV8yRST/LToQjvEXXolgYhC21eJsIfzL
         S4p85gkLpJQMU2x8cSU+YcWDRoGQIwwlAzttmGGUST+863ukPMHQLrvDeyu0qrf0pBaC
         k9/g==
X-Gm-Message-State: AOAM530JGlYhahfgcRnH7p5FOIrpQ/N7WcX/6WRkVs0XbpyAkXcD5GeX
        35tIMaycpsQrohYTsD6h/s8WTg==
X-Google-Smtp-Source: ABdhPJweJYmPzlJGgylcdQJabbQixGutCZcMF0Rp33GsEdP6B9GDMskxSoz4hKihkerQAW4A12A+iw==
X-Received: by 2002:a17:902:e852:b029:128:e56b:3227 with SMTP id t18-20020a170902e852b0290128e56b3227mr4995350plg.81.1626212460062;
        Tue, 13 Jul 2021 14:41:00 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x128sm114459pfd.167.2021.07.13.14.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 14:40:59 -0700 (PDT)
Date:   Tue, 13 Jul 2021 21:40:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM, SEV: Refactor out function for unregistering
 encrypted regions
Message-ID: <YO4IZwk0M4GoVoit@google.com>
References: <20210621163118.1040170-1-pgonda@google.com>
 <20210621163118.1040170-2-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621163118.1040170-2-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021, Peter Gonda wrote:
> Factor out helper function for freeing the encrypted region list.

...

>  arch/x86/kvm/svm/sev.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 46e339c84998..5af46ff6ec48 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1767,11 +1767,25 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
>  	return ret;
>  }
>  
> +static void __unregister_region_list_locked(struct kvm *kvm,
> +					    struct list_head *mem_regions)

I don't think the underscores or the "locked" qualifier are necessary.  Unlike
__unregister_enc_region_locked(), there is no unregister_region_list() to avoid.

I'd also votes to drop "list" and instead use a plural "regions".  Without the
plural form, it's not immediately obvious that the difference is that this
helper deletes multiple regions.

Last nit, I assume these are all encrypted regions?  If so, unregister_enc_regions()
seems like the natural choice.

> +{
> +	struct enc_region *pos, *q;
> +
> +	lockdep_assert_held(&kvm->lock);

This locked (big thumbs up) is part of why I think it's a-ok to drop the "locked"
qualifier.

> +
> +	if (list_empty(mem_regions))
> +		return;
> +
> +	list_for_each_entry_safe(pos, q, mem_regions, list) {
> +		__unregister_enc_region_locked(kvm, pos);
> +		cond_resched();
> +	}
> +}
