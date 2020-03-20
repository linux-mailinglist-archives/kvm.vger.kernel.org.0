Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 748F718D96D
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 21:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727264AbgCTUeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 16:34:15 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44587 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbgCTUeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 16:34:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id 37so3634267pgm.11
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 13:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=+N0bQ4JlxAy2jfmVhmfgL9o3zKHhJL+I15S0ny2lKgs=;
        b=RLsZNvbzOdBVhWrbvFQr3CKCdKtnq0K+ohA8v7c0w2gc/e5LPRQ7JGoNHVRoeXa984
         2z3VSPKSoz7GWala01EO5uP5GlkIL9GqUS1EeA4kAuhwaKOk9cWUv0Epbqx+W7fTHG26
         F7GSf84Ed0e/vmNEPjG99lgw+qHi5S5N4O5Z7eWZI4tt13hwNTSs9RSZrckzBagL8Xec
         vB7KAdDqQ4/LDtPSw0rwyPF5jUdN/dbp0migODoWfLJveA8otGKFz4Vi4ZzssqyfKx7L
         Lq3fZqlYdRzjncLjUv324t9/cYxxu5IwiOO8MK7leI4eFF6Fp11guAennTNahV8u7/TW
         amlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=+N0bQ4JlxAy2jfmVhmfgL9o3zKHhJL+I15S0ny2lKgs=;
        b=odxIxXv8Fy3EA0RKdS3yUgoa3+bcP2cU5Xim6aLm7wKaLkS3pNwN4brqrdY1oGZPJb
         ZznL6GFQICGGF/UATCnmR6Mix8R13leTozmrWv6GWWolEB6Ov83O8Uwx1SBjR+adI7Ak
         jEbs4uQAIAoGWX2mmvTt0zGQBhN1yX+wdUKpu6/bURiZymn634QVnVlH6onh6Kx2I5hl
         F6T/EOdWSwaHBLJVunWujoEZfU3V8U62SrVok/+HCk+BGrYE3KAtuCg7QmNuPvWW8ibV
         bmOKVeiDdsQaMFx51Kpv3gEdPxziGAckwQup1XgqiCTWCgSzlP092t5xMB+D6g84HJlt
         4+Vg==
X-Gm-Message-State: ANhLgQ3colQHOpkW+2wDhJA2vqN/KsoLfEOJ3D/TxAsVJRZLeCDh1w+i
        awtOslC5XR2eKzLOmjagWE42kw==
X-Google-Smtp-Source: ADFU+vvR5V4d3Av2dfFh7WwI8fAcwnWol4/NYm+baHmdq6gt93cp+asM2U0D8WNlss8Unt2oKz1U3w==
X-Received: by 2002:a63:d351:: with SMTP id u17mr10257174pgi.396.1584736453455;
        Fri, 20 Mar 2020 13:34:13 -0700 (PDT)
Received: from [2620:15c:17:3:3a5:23a7:5e32:4598] ([2620:15c:17:3:3a5:23a7:5e32:4598])
        by smtp.gmail.com with ESMTPSA id 93sm5153147pjo.43.2020.03.20.13.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 13:34:12 -0700 (PDT)
Date:   Fri, 20 Mar 2020 13:34:12 -0700 (PDT)
From:   David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To:     Tom Lendacky <thomas.lendacky@amd.com>
cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH] KVM: SVM: Issue WBINVD after deactivating an SEV guest
In-Reply-To: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
Message-ID: <alpine.DEB.2.21.2003201333510.205664@chino.kir.corp.google.com>
References: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Mar 2020, Tom Lendacky wrote:

> Currently, CLFLUSH is used to flush SEV guest memory before the guest is
> terminated (or a memory hotplug region is removed). However, CLFLUSH is
> not enough to ensure that SEV guest tagged data is flushed from the cache.
> 
> With 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations"), the
> original WBINVD was removed. This then exposed crashes at random times
> because of a cache flush race with a page that had both a hypervisor and
> a guest tag in the cache.
> 
> Restore the WBINVD when destroying an SEV guest and add a WBINVD to the
> svm_unregister_enc_region() function to ensure hotplug memory is flushed
> when removed. The DF_FLUSH can still be avoided at this point.
> 
> Fixes: 33af3a7ef9e6 ("KVM: SVM: Reduce WBINVD/DF_FLUSH invocations")
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Acked-by: David Rientjes <rientjes@google.com>

Should this be marked for stable?

Cc: stable@vger.kernel.org # 5.5+

> ---
>  arch/x86/kvm/svm.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 08568ae9f7a1..d54cdca9c140 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1980,14 +1980,6 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>  static void __unregister_enc_region_locked(struct kvm *kvm,
>  					   struct enc_region *region)
>  {
> -	/*
> -	 * The guest may change the memory encryption attribute from C=0 -> C=1
> -	 * or vice versa for this memory range. Lets make sure caches are
> -	 * flushed to ensure that guest data gets written into memory with
> -	 * correct C-bit.
> -	 */
> -	sev_clflush_pages(region->pages, region->npages);
> -
>  	sev_unpin_memory(kvm, region->pages, region->npages);
>  	list_del(&region->list);
>  	kfree(region);
> @@ -2004,6 +1996,13 @@ static void sev_vm_destroy(struct kvm *kvm)
>  
>  	mutex_lock(&kvm->lock);
>  
> +	/*
> +	 * Ensure that all guest tagged cache entries are flushed before
> +	 * releasing the pages back to the system for use. CLFLUSH will
> +	 * not do this, so issue a WBINVD.
> +	 */
> +	wbinvd_on_all_cpus();
> +
>  	/*
>  	 * if userspace was terminated before unregistering the memory regions
>  	 * then lets unpin all the registered memory.
> @@ -7247,6 +7246,13 @@ static int svm_unregister_enc_region(struct kvm *kvm,
>  		goto failed;
>  	}
>  
> +	/*
> +	 * Ensure that all guest tagged cache entries are flushed before
> +	 * releasing the pages back to the system for use. CLFLUSH will
> +	 * not do this, so issue a WBINVD.
> +	 */
> +	wbinvd_on_all_cpus();
> +
>  	__unregister_enc_region_locked(kvm, region);
>  
>  	mutex_unlock(&kvm->lock);
> -- 
> 2.17.1
> 
> 
