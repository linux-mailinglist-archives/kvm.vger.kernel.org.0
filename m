Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62C8F36D560
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 12:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239070AbhD1KEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 06:04:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239012AbhD1KEm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Apr 2021 06:04:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619604237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i38qAydUV9D1OXWVf8wjL2KUV1llC+suuvz1DX0fuV4=;
        b=A0Q5tbMowMpvoK5X/U9jlm6ldlzeQYKACNDqm1cCglcEpxSXLdnCtzd/XnXBy+cYJR3UyN
        pdCpredFaS3Kfi+7M2NkP9x2TKjY/DTxHKLcVLm/nk2K0tm2fv7r5o4xLzYl9csegdhBra
        IpdYpS5sZQnIadusdchkZZSOi94cbSs=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-8TkP04apOVOpmOkwW_Pleg-1; Wed, 28 Apr 2021 06:03:56 -0400
X-MC-Unique: 8TkP04apOVOpmOkwW_Pleg-1
Received: by mail-ed1-f72.google.com with SMTP id c15-20020a056402100fb029038518e5afc5so19097319edu.18
        for <kvm@vger.kernel.org>; Wed, 28 Apr 2021 03:03:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i38qAydUV9D1OXWVf8wjL2KUV1llC+suuvz1DX0fuV4=;
        b=guVcp6UjYE4fqwPiWY8hKLy6Uw9tRZmUDiFglg6hnGk8ZurfS3Ifh8Ow86XWXdQgVy
         w/XPSUXzlEFL221KYEn9JvEtpRDN9pm1nWC2H5qOTqbJ6fY8a7X1szepbIlSnUDCb3Vy
         nJbZRU8h8twdVDoE1G+dPZyUfNRKna53RG9Ut76oUOIvlllQBhBSleE+ST84EOJ27KkV
         wqN+vHkO/foMzbjLvVPz8h9MNl8dqz7sMjd2p/9fP1VZ3fP+T5VTum/lHu/nVJkQE6XF
         Nttl1VClai0ENF5osCmO6OWj6/7YbOAT7QNvFQCvnrfBUL3/tpQ5uzYJnSaPSbQycM7Z
         xaUA==
X-Gm-Message-State: AOAM533KswQNIZTnnxn/0Sgx4TNmWs7LWCJ3jxfmy1XACPDfF5IXq4sd
        thimmpqRAqCzI59WWMtO0XOgfOWHt4yHVKm+t1K25yFRHcIUoPA09V+9rUow4mXPAfmHBgcK82D
        8QZ79y6qoP3oq
X-Received: by 2002:a17:906:52d7:: with SMTP id w23mr1364770ejn.451.1619604234830;
        Wed, 28 Apr 2021 03:03:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy3+JiV66h277msomicqDtfqP9yRtiRRZvSSPmGaeRT5LaIAQspF8Ms21rTk7kH4E0CXyD43Q==
X-Received: by 2002:a17:906:52d7:: with SMTP id w23mr1364748ejn.451.1619604234686;
        Wed, 28 Apr 2021 03:03:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id cm21sm4438901edb.29.2021.04.28.03.03.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 03:03:54 -0700 (PDT)
Subject: Re: [PATCH 6/6] KVM: x86/mmu: Lazily allocate memslot rmaps
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
 <20210427223635.2711774-7-bgardon@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1b598516-4478-4de2-4241-d4b517ec03fa@redhat.com>
Date:   Wed, 28 Apr 2021 12:03:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210427223635.2711774-7-bgardon@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 00:36, Ben Gardon wrote:
> -static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> +static int kvm_alloc_memslot_metadata(struct kvm *kvm,
> +				      struct kvm_memory_slot *slot,
>   				      unsigned long npages)
>   {
>   	int i;
> @@ -10892,7 +10950,7 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
>   	 */
>   	memset(&slot->arch, 0, sizeof(slot->arch));
>   
> -	r = alloc_memslot_rmap(slot, npages);
> +	r = alloc_memslot_rmap(kvm, slot, npages);
>   	if (r)
>   		return r;
>   

I wonder why you need alloc_memslot_rmap at all here in 
kvm_alloc_memslot_metadata, or alternatively why you need to do it in 
kvm_arch_assign_memslots.  It seems like only one of those would be 
necessary.

Paolo

