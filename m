Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FAE3CCDF1
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 08:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234345AbhGSGep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 02:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23476 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233048AbhGSGeo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 02:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626676304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sDl9zJ8yJigPizUQxq5VDfedGB5Y2mU/bObQ9LMf+NY=;
        b=gUQKFzVvF5M3lxyEmJpdtrfsz/7OWEVfY5ZBubdeBv2QHhrlvxuZ/iM9vUZnq+10eN6jdw
        EMeS8lYzDn6IO+VUlY9exNZOe/+S67I2dEUMlB33nXE7lmJQFocLmLqObYCQ6y7Y+74luC
        fSNnYR57sQmv3L8NKEsPT5Jv9TFtD6Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-122-PiUcYVZINui7BSlVU_s8TA-1; Mon, 19 Jul 2021 02:31:43 -0400
X-MC-Unique: PiUcYVZINui7BSlVU_s8TA-1
Received: by mail-ed1-f71.google.com with SMTP id g23-20020aa7c8570000b02903954c05c938so3121239edt.3
        for <kvm@vger.kernel.org>; Sun, 18 Jul 2021 23:31:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sDl9zJ8yJigPizUQxq5VDfedGB5Y2mU/bObQ9LMf+NY=;
        b=hHxnSObWQOTsEk0bi9qJsm8mt1UFKV+wVVcEvR3/5Gf4mI4mZ5Fgp+QZi/evClwkcT
         nEXUU03bnKBbNNNYIQRmoXUc1GTqV4Gso2MmkcrpKY1Lkr1nKb+ftcG/NDh0erA1vkBI
         Sm/ujS6tIJXDaq458dwz52Wj1a0rk8JH13IRaUD7DLQsb5mqEdePK28vJGq/eAZsHzbQ
         RGH2O0d9Dv3Vy/V3mPPcXPOCQdc9AfcosZ+4VvqXcWtgpjQLOp5vdNM7MBu10AkTlYeU
         R/vwbOrWkXFBjJ31r1VEIffPP338XDUbViHVRbrI7I4qgohQPFD1Jb/a9NomjtTkQr6i
         9YeA==
X-Gm-Message-State: AOAM530Y1QYHo+JWjIhED3v5RMk7lVcfydIa8waHjDJE29oEg7R6u2+D
        9HmW65kGy2n5s2fFFqeFFfiNLSo2NTse5Rp45x+NxbOvb23T8KQd9jmWbe1EeDM984V3HYlmzxT
        DWaURo37lRSU5
X-Received: by 2002:a05:6402:692:: with SMTP id f18mr33054710edy.327.1626676302243;
        Sun, 18 Jul 2021 23:31:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy03G7eb3Ni5bq5T+4u9WmKa5rbbWmLEfjZhNZllL+I9GCy7NjuQxCbsv+toB/S7ycv5irrnA==
X-Received: by 2002:a05:6402:692:: with SMTP id f18mr33054692edy.327.1626676302062;
        Sun, 18 Jul 2021 23:31:42 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id i10sm7237674edf.12.2021.07.18.23.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 23:31:41 -0700 (PDT)
Subject: Re: [PATCH 3/5] KVM: Remove kvm_is_transparent_hugepage() and
 PageTransCompoundMap()
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Will Deacon <will@kernel.org>,
        Quentin Perret <qperret@google.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
References: <20210717095541.1486210-1-maz@kernel.org>
 <20210717095541.1486210-4-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fc371325-1e4c-b842-1b37-ec197175cb3b@redhat.com>
Date:   Mon, 19 Jul 2021 08:31:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/21 11:55, Marc Zyngier wrote:
> Now that arm64 has stopped using kvm_is_transparent_hugepage(),
> we can remove it, as well as PageTransCompoundMap() which was
> only used by the former.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   include/linux/page-flags.h | 37 -------------------------------------
>   virt/kvm/kvm_main.c        | 10 ----------
>   2 files changed, 47 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 5922031ffab6..1ace27c4a8e0 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -632,43 +632,6 @@ static inline int PageTransCompound(struct page *page)
>   	return PageCompound(page);
>   }
>   
> -/*
> - * PageTransCompoundMap is the same as PageTransCompound, but it also
> - * guarantees the primary MMU has the entire compound page mapped
> - * through pmd_trans_huge, which in turn guarantees the secondary MMUs
> - * can also map the entire compound page. This allows the secondary
> - * MMUs to call get_user_pages() only once for each compound page and
> - * to immediately map the entire compound page with a single secondary
> - * MMU fault. If there will be a pmd split later, the secondary MMUs
> - * will get an update through the MMU notifier invalidation through
> - * split_huge_pmd().
> - *
> - * Unlike PageTransCompound, this is safe to be called only while
> - * split_huge_pmd() cannot run from under us, like if protected by the
> - * MMU notifier, otherwise it may result in page->_mapcount check false
> - * positives.
> - *
> - * We have to treat page cache THP differently since every subpage of it
> - * would get _mapcount inc'ed once it is PMD mapped.  But, it may be PTE
> - * mapped in the current process so comparing subpage's _mapcount to
> - * compound_mapcount to filter out PTE mapped case.
> - */
> -static inline int PageTransCompoundMap(struct page *page)
> -{
> -	struct page *head;
> -
> -	if (!PageTransCompound(page))
> -		return 0;
> -
> -	if (PageAnon(page))
> -		return atomic_read(&page->_mapcount) < 0;
> -
> -	head = compound_head(page);
> -	/* File THP is PMD mapped and not PTE mapped */
> -	return atomic_read(&page->_mapcount) ==
> -	       atomic_read(compound_mapcount_ptr(head));
> -}
> -
>   /*
>    * PageTransTail returns true for both transparent huge pages
>    * and hugetlbfs pages, so it should only be called when it's known
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7d95126cda9e..2e410a8a6a67 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -189,16 +189,6 @@ bool kvm_is_reserved_pfn(kvm_pfn_t pfn)
>   	return true;
>   }
>   
> -bool kvm_is_transparent_hugepage(kvm_pfn_t pfn)
> -{
> -	struct page *page = pfn_to_page(pfn);
> -
> -	if (!PageTransCompoundMap(page))
> -		return false;
> -
> -	return is_transparent_hugepage(compound_head(page));
> -}
> -
>   /*
>    * Switches to specified vcpu, until a matching vcpu_put()
>    */
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

