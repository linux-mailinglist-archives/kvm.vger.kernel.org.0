Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8FD36D546
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238785AbhD1KBg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:01:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43909 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238554AbhD1KBd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 06:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619604048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhFNqwiAFSjk5pc8IGLBBUa1bd6wwdqJ26xugM42AOU=;
        b=bUHp+K/PLPuY7Y2kC9ThTes/GauyUYORH6PYmclXfq8i1XFFohoI3A5OK2J5r21LOKim4Q
        3os9g55VJDJ6YhFLk/wrNO272A6tvTRa4A3R++lboK8owZTmmKw97pcHDKdnjSO5+tMASv
        Fnjd/Q/mJoSoYEkIu1rMXsMehJguTJY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-hG1kYZBHOGmkl9itqx6h-w-1; Wed, 28 Apr 2021 06:00:46 -0400
X-MC-Unique: hG1kYZBHOGmkl9itqx6h-w-1
Received: by mail-ed1-f71.google.com with SMTP id u30-20020a50a41e0000b0290385504d6e4eso4711548edb.7
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:00:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FhFNqwiAFSjk5pc8IGLBBUa1bd6wwdqJ26xugM42AOU=;
        b=YCHu/umWP/DI4hOAW8jQH5eOMq8iaemZS9HcjVSdcqL4IjJIj54vvbKJUMp0PwTig+
         GkC2uuud4ag5F+oA19uTHw8sS0r0DGQEPTi5rKrqr8aITbfY8jb5z7lzKp9Vgyb/EaPi
         R1pra48/WuwL4spQiDLecn7VVJplBE7D8mxINuxM679a4ouXR5sFj6MESIvlFYYa19HM
         gOYJLIc11K6i8lp27BXbVElrGzTyffHw8p1ykpsjmptYF/Wx9jsRbT1RVtIaqMBrKNDj
         mFTf4PlXLpUYyh73+hvpLhGpvdyuF/emdzcjrAFUAzPDmJxAeP9uvdVbKUAim/6lNqwn
         bGRA==
X-Gm-Message-State: AOAM531gGlzC6hN5tHBp0HNit4DcOrLWOxZxBMOEbdeXkqTfaxPAUQFZ
        4Bbcy6xJBJKtuuSZ5liCXc0kigWUepq2fekGc2u+RTBE5AgI//WvfRVCsOVcDRbkbEZP/p/gd2U
        6MJvhuudM4EDt
X-Received: by 2002:a17:906:a0d4:: with SMTP id bh20mr28035351ejb.348.1619604045185;
        Wed, 28 Apr 2021 03:00:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTMhrX4bqXfljul31u2glQku96LkpSI89jMTVvHtGdEXLDq8ZAQFkOvHuZRusQHJD5Oogk+A==
X-Received: by 2002:a17:906:a0d4:: with SMTP id bh20mr28035332ejb.348.1619604045012;
        Wed, 28 Apr 2021 03:00:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id u13sm1620873ejj.16.2021.04.28.03.00.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 03:00:44 -0700 (PDT)
Subject: Re: [PATCH 3/6] KVM: x86/mmu: Deduplicate rmap freeing in
 allocate_memslot_rmap
To:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210427223635.2711774-1-bgardon@google.com>
 <20210427223635.2711774-4-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2e5ecc0b-0ef4-a663-3b1d-81d020626b39@redhat.com>
Date:   Wed, 28 Apr 2021 12:00:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210427223635.2711774-4-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Typo in the commit subject, I guess?

Paolo

On 28/04/21 00:36, Ben Gardon wrote:
> Small code deduplication. No functional change expected.
> 
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---
>   arch/x86/kvm/x86.c | 19 +++++++++++--------
>   1 file changed, 11 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index cf3b67679cf0..5bcf07465c47 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10818,17 +10818,23 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>   	kvm_hv_destroy_vm(kvm);
>   }
>   
> -void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> +static void free_memslot_rmap(struct kvm_memory_slot *slot)
>   {
>   	int i;
>   
>   	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
>   		kvfree(slot->arch.rmap[i]);
>   		slot->arch.rmap[i] = NULL;
> +	}
> +}
>   
> -		if (i == 0)
> -			continue;
> +void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
> +{
> +	int i;
> +
> +	free_memslot_rmap(slot);
>   
> +	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
>   		kvfree(slot->arch.lpage_info[i - 1]);
>   		slot->arch.lpage_info[i - 1] = NULL;
>   	}
> @@ -10894,12 +10900,9 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>   	return 0;
>   
>   out_free:
> -	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
> -		kvfree(slot->arch.rmap[i]);
> -		slot->arch.rmap[i] = NULL;
> -		if (i == 0)
> -			continue;
> +	free_memslot_rmap(slot);
>   
> +	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
>   		kvfree(slot->arch.lpage_info[i - 1]);
>   		slot->arch.lpage_info[i - 1] = NULL;
>   	}
> 

