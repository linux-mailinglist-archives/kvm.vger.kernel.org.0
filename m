Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE82D3CCDF4
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 08:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhGSGev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 02:34:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233689AbhGSGev (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 19 Jul 2021 02:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626676312;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5iBFyoa3ekzBjt+3mHKhKLuzk3TVXqOUxd9HJiVKOWA=;
        b=jDB2KKBoU/XoTVQsQGXZxnceyw4AszMc3RxVq9HJzRRbUkWw0a/jll/nXNpGtQniT/dUdt
        uSaVDTAEgMMWqHAP2BtxrIqURmiTKjEfGXhv5lWMgZTrKJqeMzrY09C6+aaJz148NCUP8Y
        wkY+WWC1vr/U3TVe5pafh3vgIDjlz/A=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-DVHCHmFpMOmEypfKSYsFsQ-1; Mon, 19 Jul 2021 02:31:48 -0400
X-MC-Unique: DVHCHmFpMOmEypfKSYsFsQ-1
Received: by mail-ej1-f70.google.com with SMTP id nc15-20020a1709071c0fb029052883e9de3eso4847368ejc.19
        for <kvm@vger.kernel.org>; Sun, 18 Jul 2021 23:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5iBFyoa3ekzBjt+3mHKhKLuzk3TVXqOUxd9HJiVKOWA=;
        b=MkkmSsLandcP0He05fywO+TTq2HcYZwQDgXGiYg9Nq0aPytEUpSpisWr2SFYvdgzQm
         PsV1vujXZE09kqef1m/42BYc9zieY4yF3cB0pOvIHFMCc4//jUsiauBzmbR8DWS4MRlU
         JbQrJfFHKvBZg4OtdHoFh1l6dYEo4SXXfschHcSVPZ+7DfAWDjIvmOTVKuxe+1aTQ4vq
         XVpmR7GLs8h2+yyktZtCwl4EifPUpdP9i8EHyTSKknQZ/PMaY6LTxK2GQRVTJZK9eWDE
         VV48GkhF70yqwegDzLe4vHQ9v8sTDt/Rw0uEZHPSFDWzabyQXxoQ8xF/ntWs6F+hvZ6Q
         vzVQ==
X-Gm-Message-State: AOAM53085ud3Kfi3XygrGoVZXSwTs/cGqyXGlPYrhEGbKpQrIT4s0z8a
        jubCo+HrPYGEmIoqhP1CgxqvRxDqViOxlthfrvk8Yx4kz1/eF6Jrc7mKJNZNi2GTBPz0FhH++T1
        5UQN3fw7DlSf0
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr26130816ejp.443.1626676307274;
        Sun, 18 Jul 2021 23:31:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwKAXQ0jz8kg1aBiPUIh7/qkMfflW9/UFkvvWaaFSOpzP+F0zQJJOF6m/qps2butenIEa5BQ==
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr26130798ejp.443.1626676307142;
        Sun, 18 Jul 2021 23:31:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id f24sm4761419edv.93.2021.07.18.23.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Jul 2021 23:31:46 -0700 (PDT)
Subject: Re: [PATCH 5/5] KVM: Get rid of kvm_get_pfn()
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
 <20210717095541.1486210-6-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ef15f26a-4701-9d8c-b856-e7bb717a69f9@redhat.com>
Date:   Mon, 19 Jul 2021 08:31:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210717095541.1486210-6-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/07/21 11:55, Marc Zyngier wrote:
> Nobody is using kvm_get_pfn() anymore. Get rid of it.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   include/linux/kvm_host.h | 1 -
>   virt/kvm/kvm_main.c      | 9 +--------
>   2 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ae7735b490b4..9818d271c2a1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -824,7 +824,6 @@ void kvm_release_pfn_clean(kvm_pfn_t pfn);
>   void kvm_release_pfn_dirty(kvm_pfn_t pfn);
>   void kvm_set_pfn_dirty(kvm_pfn_t pfn);
>   void kvm_set_pfn_accessed(kvm_pfn_t pfn);
> -void kvm_get_pfn(kvm_pfn_t pfn);
>   
>   void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
>   int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2e410a8a6a67..0284418c4400 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2215,7 +2215,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
>   	 * Get a reference here because callers of *hva_to_pfn* and
>   	 * *gfn_to_pfn* ultimately call kvm_release_pfn_clean on the
>   	 * returned pfn.  This is only needed if the VMA has VM_MIXEDMAP
> -	 * set, but the kvm_get_pfn/kvm_release_pfn_clean pair will
> +	 * set, but the kvm_try_get_pfn/kvm_release_pfn_clean pair will
>   	 * simply do nothing for reserved pfns.
>   	 *
>   	 * Whoever called remap_pfn_range is also going to call e.g.
> @@ -2612,13 +2612,6 @@ void kvm_set_pfn_accessed(kvm_pfn_t pfn)
>   }
>   EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
>   
> -void kvm_get_pfn(kvm_pfn_t pfn)
> -{
> -	if (!kvm_is_reserved_pfn(pfn))
> -		get_page(pfn_to_page(pfn));
> -}
> -EXPORT_SYMBOL_GPL(kvm_get_pfn);
> -
>   static int next_segment(unsigned long len, int offset)
>   {
>   	if (len > PAGE_SIZE - offset)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

