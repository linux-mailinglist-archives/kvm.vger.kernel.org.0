Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085324EA2AD
	for <lists+kvm@lfdr.de>; Tue, 29 Mar 2022 00:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiC1WOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 18:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiC1WNy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 18:13:54 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30749149255
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 15:03:47 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-df0940c4eeso3294415fac.8
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 15:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6f0ymM3PuwfqwB+Ks8BX5URDH2m1K5HGD6I5Zz3ti5Q=;
        b=NH33JvMBIiaBL7bqX1PZbItw0IUfTlXD/v9oqWvIintdpR2SKhlN4igL4tSF3ZcIDp
         sV7t/z5vUZKMAtkNNIq3fFQIP8pHmS/iH5/d3fDdTtMOUOLAAD1+ikzXU14mMAKEblor
         4qnKBqDpRZ8YwY9xRDH8/eoduqsp55EmqJBNPUueA0rhCUGOiGOlII+LABdG9Wk0Hc3R
         2awwTxAZNazlQDZKuyoiqCopjHbUAqm/HeKkYLztMk8p5n3ui448LMrVKA1TASyWX6yl
         sdiO5htV6zcmiQKdeSxAr5/4UbEU2TU1WB53fCfupefYoUkwxYsso2NclryjmPsTGZ3j
         ZU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6f0ymM3PuwfqwB+Ks8BX5URDH2m1K5HGD6I5Zz3ti5Q=;
        b=ITVbGCJ4fTnXQxWKmBkNmEEhJ6x71YlwiitNw/VqkOOMYNJ4uxiunCajslFObk6LdF
         xzF9ewMuirWY17gGDf47NXp/Lk0MKov3RnUzkqGq1mg4EVspwKviEVmJO7ScTddXw0qV
         mxz2SwZSedoWT77mNCWUzU9MhnU+Dm+q9LdVWBob7Pb34hNIV6bv2KKtzy7EQ03LYPka
         0iTbQluviNcIdECTSwWbrplC865dz+kzMJ1rbcldg6aaUDhh87m8AUqKOjbgqLUKN2To
         +0ceAWufU4+FPj9Iva9Hd6sFvKkMdaC0xYuDtOdZmDdQp0vkSAGp4xaD5Ii3zKsK3bZz
         vTBw==
X-Gm-Message-State: AOAM530lTxadA/ul5n5cMhk3q/mbSKU972ekRjOHdlFGgmYNSuIGMrKb
        dasILEfiP4s4VKWqOUp9hkpdps9rMutzuQ==
X-Google-Smtp-Source: ABdhPJxzsrphJ5SAHT6xGnE9Zsu1eetVvZtTotZHLXscXA64kqeWZA3FguQ77T0PrIoYl9MNauVa6A==
X-Received: by 2002:a17:90a:d3d1:b0:1bb:fdc5:182 with SMTP id d17-20020a17090ad3d100b001bbfdc50182mr1207841pjw.206.1648504597150;
        Mon, 28 Mar 2022 14:56:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 3-20020a630003000000b003828fc1455esm13974792pga.60.2022.03.28.14.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 14:56:36 -0700 (PDT)
Date:   Mon, 28 Mar 2022 21:56:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        Steven Price <steven.price@arm.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, jun.nakajima@intel.com, dave.hansen@intel.com,
        ak@linux.intel.com, david@redhat.com
Subject: Re: [PATCH v5 05/13] KVM: Extend the memslot to support fd-based
 private memory
Message-ID: <YkIvEeC3/lgKTLPt@google.com>
References: <20220310140911.50924-1-chao.p.peng@linux.intel.com>
 <20220310140911.50924-6-chao.p.peng@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140911.50924-6-chao.p.peng@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 10, 2022, Chao Peng wrote:
> Extend the memslot definition to provide fd-based private memory support
> by adding two new fields (private_fd/private_offset). The memslot then
> can maintain memory for both shared pages and private pages in a single
> memslot. Shared pages are provided by existing userspace_addr(hva) field
> and private pages are provided through the new private_fd/private_offset
> fields.
> 
> Since there is no 'hva' concept anymore for private memory so we cannot
> rely on get_user_pages() to get a pfn, instead we use the newly added
> memfile_notifier to complete the same job.
> 
> This new extension is indicated by a new flag KVM_MEM_PRIVATE.
> 
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
> ---
>  Documentation/virt/kvm/api.rst | 37 +++++++++++++++++++++++++++-------
>  include/linux/kvm_host.h       |  7 +++++++
>  include/uapi/linux/kvm.h       |  8 ++++++++
>  3 files changed, 45 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 3acbf4d263a5..f76ac598606c 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -1307,7 +1307,7 @@ yet and must be cleared on entry.
>  :Capability: KVM_CAP_USER_MEMORY
>  :Architectures: all
>  :Type: vm ioctl
> -:Parameters: struct kvm_userspace_memory_region (in)
> +:Parameters: struct kvm_userspace_memory_region(_ext) (in)
>  :Returns: 0 on success, -1 on error
>  
>  ::
> @@ -1320,9 +1320,17 @@ yet and must be cleared on entry.
>  	__u64 userspace_addr; /* start of the userspace allocated memory */
>    };
>  
> +  struct kvm_userspace_memory_region_ext {
> +	struct kvm_userspace_memory_region region;

Peeking ahead, the partial switch to the _ext variant is rather gross.  I would
prefer that KVM use an entirely different, but binary compatible, struct internally.
And once the kernel supports C11[*], I'm pretty sure we can make the "region" in
_ext an anonymous struct, and make KVM's internal struct a #define of _ext.  That
should minimize the churn (no need to get the embedded "region" field), reduce
line lengths, and avoid confusion due to some flows taking the _ext but others
dealing with only the "base" struct.

Maybe kvm_user_memory_region or kvm_user_mem_region?  Though it's tempting to be
evil and usurp the old kvm_memory_region :-)

E.g. pre-C11 do

struct kvm_userspace_memory_region_ext {
	struct kvm_userspace_memory_region region;
	__u64 private_offset;
	__u32 private_fd;
	__u32 padding[5];
};

#ifdef __KERNEL__
struct kvm_user_mem_region {
	__u32 slot;
	__u32 flags;
	__u64 guest_phys_addr;
	__u64 memory_size; /* bytes */
	__u64 userspace_addr; /* start of the userspace allocated memory */
	__u64 private_offset;
	__u32 private_fd;
	__u32 padding[5];
};
#endif

and then post-C11 do

struct kvm_userspace_memory_region_ext {
#ifdef __KERNEL__
	struct kvm_userspace_memory_region region;
#else
	struct kvm_userspace_memory_region;
#endif
	__u64 private_offset;
	__u32 private_fd;
	__u32 padding[5];
};

#ifdef __KERNEL__
#define kvm_user_mem_region kvm_userspace_memory_region_ext
#endif

[*] https://lore.kernel.org/all/20220301145233.3689119-1-arnd@kernel.org

> +	__u64 private_offset;
> +	__u32 private_fd;
> +	__u32 padding[5];
> +};
