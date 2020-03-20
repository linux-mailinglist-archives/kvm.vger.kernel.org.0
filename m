Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCA118D623
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbgCTRnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 13:43:19 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:45452 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726974AbgCTRnS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 20 Mar 2020 13:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584726197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7krMgYrLviqR5RFlOfg+d+WWKR25x9POwU7DsBJYErA=;
        b=FwrVwZknKSqy+VU41I40B+Xmzz77SLboH6h4McC01cApx2bW2idMGDzGVr+WiYan+U5iDB
        H9O3+bizHHtp1Ufg8vO3yKwnIXVVbqcFjN3YAdetNTvAMFcyMElRJTpKFqPCYzbfdIDBpW
        xwDvzNVnP+9ZKK2nDM+F9Tm+omxa9x8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-TRj7MfV1PrGdbGkyiSIBFw-1; Fri, 20 Mar 2020 13:43:15 -0400
X-MC-Unique: TRj7MfV1PrGdbGkyiSIBFw-1
Received: by mail-wm1-f70.google.com with SMTP id p18so2070650wmk.9
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 10:43:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7krMgYrLviqR5RFlOfg+d+WWKR25x9POwU7DsBJYErA=;
        b=LlHiqwdzsvwhi0G1NePSIjZee9TS0jhT+zqvHvA2zjS17mb1aghilYOfBZCPvE2/Y6
         7H0HiadrWzBEyvYPkzerRbYTBWe8E04sFIobgo38ELhipNKYGiAEoTvL9/t/DevHfbaP
         cOe89q718WQJ1ctFhyskzUcYya8jzENGq0vUA5wrQH2nV9J3DRz93waIDi6kDsy0Nwb6
         flcMwTD22J74UOyLKK1YizkiiY5+ySkimmO9cXnwvRgDC11/Spjz+12PtVTnAhJM8HVK
         eQeKbVUA+y9Ffd5R9gibjMUUGs/4PhBmPA4asKR1fEntFKi5IhmF0LLrGkE5F8yfEyo0
         sNmg==
X-Gm-Message-State: ANhLgQ03KF9fmL8OaiYq3PlyFHb6y4qseJHSnZ8HtwEr7YHbZGQTuwQj
        x5E1Bm+RH1sdh4rvuLGvFDNID9prokTaizxRZ792ivlDoa99B9JFT8/o4OXmCmrHZhu0KHYC18y
        kBMYX7Bs1Cz3n
X-Received: by 2002:a1c:8108:: with SMTP id c8mr11432326wmd.50.1584726194455;
        Fri, 20 Mar 2020 10:43:14 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vsAtEWKoguJOc/KY7Vn81oqAla4zRc1CqqIumjVg73UvF25mFsHXlpV+BDb1BfgzQqXX+HPyw==
X-Received: by 2002:a1c:8108:: with SMTP id c8mr11432291wmd.50.1584726194078;
        Fri, 20 Mar 2020 10:43:14 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.43])
        by smtp.gmail.com with ESMTPSA id f10sm9339428wrw.96.2020.03.20.10.43.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 10:43:13 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Issue WBINVD after deactivating an SEV guest
To:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Rientjes <rientjes@google.com>
References: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <db38f194-cdd0-23a0-00d9-78ef5eaa1534@redhat.com>
Date:   Fri, 20 Mar 2020 18:43:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <c8bf9087ca3711c5770bdeaafa3e45b717dc5ef4.1584720426.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/03/20 17:07, Tom Lendacky wrote:
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
> 

Queued for kvm/master, thanks.

Paolo

