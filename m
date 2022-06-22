Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674FA55494F
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354988AbiFVK3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 06:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbiFVK3s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 06:29:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F369B3A70E
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 03:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655893787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dPImrDmzKVBbb0HXU+86u9rvHqc6doxrZkENPaWv+QY=;
        b=dr3THTki99Bx0NW6D5lK1YVrFPYjnkXNMZqOmG+sPBFKKFNnhIccKfn8cUqZmHzvjbvA4I
        Oc/hiRfJQxpg2t8FUPlHft/ETfazCsEuoEXbu5ldGULZBNZBank9fdjwlSLNqYa6rIFnNJ
        zN+2zTjgvMKlYHds6HNY4K1sO4OCAXU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-Z5gw7jdXOTu1m4xhNSVtKw-1; Wed, 22 Jun 2022 06:29:45 -0400
X-MC-Unique: Z5gw7jdXOTu1m4xhNSVtKw-1
Received: by mail-wm1-f72.google.com with SMTP id c185-20020a1c35c2000000b0039db3e56c39so9859969wma.5
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 03:29:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dPImrDmzKVBbb0HXU+86u9rvHqc6doxrZkENPaWv+QY=;
        b=VsP2u9NhHFvTw5ri8QEZQIQephfP3iteTyI+175auGCaf0L7fZnAnOn+9db1A1UCqq
         HUzHYe59mWxlQXN62NLPLkI6kuQBHU64nb8TR9Vez/YjqQtwLyJ1hHMmru/zjz8d9tGN
         MG1aOwp3/zGU0ZBkitPM+Hp4qK1ahPXjqmcEPhswOSh5mo3qtolpZHJL3ldfSPCFw8LD
         LKxqwUBKRda15p8nsOaB59IBUJ6W2oOQOo7dzmeCSoJBBi82cFzYY87LOOMc4uJPk8P1
         1h2LSFm0RToW4AOF70L77bGRCzc7fhzDhUw763LaeIuyThDIlJZlij8l94A9+svidhNK
         3bXA==
X-Gm-Message-State: AJIora9olvSIAHvXBM7zKPY2V8yAHTj/S1XDavRYiRC+Zz9AzyYXIKKD
        0ntRIktVqPn2AD0958EcMbQA+OsarU/p0x0odOz3BA+rvqaoPf1UReooiv9k+bluHWhGyPT5zno
        X6e0gq34QyCFD
X-Received: by 2002:a1c:4409:0:b0:39e:f584:e2ad with SMTP id r9-20020a1c4409000000b0039ef584e2admr24330411wma.84.1655893784574;
        Wed, 22 Jun 2022 03:29:44 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u1XHiUDfVPnZUYfKY/mgems8JmFfwFlb/wgGrZRelp3hn61XNeDuU8hnDLBQxhmGsrnR5hBg==
X-Received: by 2002:a1c:4409:0:b0:39e:f584:e2ad with SMTP id r9-20020a1c4409000000b0039ef584e2admr24330379wma.84.1655893784355;
        Wed, 22 Jun 2022 03:29:44 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id e5-20020adfef05000000b0021b99efceb6sm4112539wro.22.2022.06.22.03.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jun 2022 03:29:43 -0700 (PDT)
Date:   Wed, 22 Jun 2022 11:29:40 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, michael.roth@amd.com, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, jarkko@kernel.org
Subject: Re: [PATCH Part2 v6 27/49] KVM: SVM: Mark the private vma unmerable
 for SEV-SNP guests
Message-ID: <YrLvFB+cyBbXMbrB@work-vm>
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <bb10f0a4c5eb13a5338f77ef34f08f1190d4ae30.1655761627.git.ashish.kalra@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb10f0a4c5eb13a5338f77ef34f08f1190d4ae30.1655761627.git.ashish.kalra@amd.com>
User-Agent: Mutt/2.2.5 (2022-05-16)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Ashish Kalra (Ashish.Kalra@amd.com) wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled, the guest private pages are added in the RMP
> table; while adding the pages, the rmp_make_private() unmaps the pages
> from the direct map. If KSM attempts to access those unmapped pages then
> it will trigger #PF (page-not-present).
> 
> Encrypted guest pages cannot be shared between the process, so an
> userspace should not mark the region mergeable but to be safe, mark the
> process vma unmerable before adding the pages in the RMP table.
                   ^
                   Typo 'unmergable' (also in title)

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index b5f0707d7ed6..a9461d352eda 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -19,11 +19,13 @@
>  #include <linux/trace_events.h>
>  #include <linux/hugetlb.h>
>  #include <linux/sev.h>
> +#include <linux/ksm.h>
>  
>  #include <asm/pkru.h>
>  #include <asm/trapnr.h>
>  #include <asm/fpu/xcr.h>
>  #include <asm/sev.h>
> +#include <asm/mman.h>
>  
>  #include "x86.h"
>  #include "svm.h"
> @@ -1965,6 +1967,30 @@ static bool is_hva_registered(struct kvm *kvm, hva_t hva, size_t len)
>  	return false;
>  }
>  
> +static int snp_mark_unmergable(struct kvm *kvm, u64 start, u64 size)
> +{
> +	struct vm_area_struct *vma;
> +	u64 end = start + size;
> +	int ret;
> +
> +	do {
> +		vma = find_vma_intersection(kvm->mm, start, end);
> +		if (!vma) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
> +				  MADV_UNMERGEABLE, &vma->vm_flags);
> +		if (ret)
> +			break;
> +
> +		start = vma->vm_end;
> +	} while (end > vma->vm_end);
> +
> +	return ret;
> +}
> +
>  static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1989,6 +2015,12 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (!is_hva_registered(kvm, params.uaddr, params.len))
>  		return -EINVAL;
>  
> +	mmap_write_lock(kvm->mm);
> +	ret = snp_mark_unmergable(kvm, params.uaddr, params.len);
> +	mmap_write_unlock(kvm->mm);
> +	if (ret)
> +		return -EFAULT;
> +
>  	/*
>  	 * The userspace memory is already locked so technically we don't
>  	 * need to lock it again. Later part of the function needs to know
> -- 
> 2.25.1
> 
-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

