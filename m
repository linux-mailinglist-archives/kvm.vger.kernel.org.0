Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A259B43652C
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhJUPML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231738AbhJUPMK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 11:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634828993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=83A37QZOYVvxXVFXpAnu1+exjyyjf1N0SkLxb+/5xyI=;
        b=LZ0+fkSoxTQgIsqnx41GVHHHTZPSafH9f06E5H8p/tXH5xrfpD0H/TRp7WulROwwsrCV8u
        s4bo7+SfKKTSSY68DrQ3OAQa6uO+Txc29I/4xtYSneWfdiCRp9BuEkIoWDBuoByEnHK7uU
        a2LYlOVUiep0ygklyaSgdNvjWWVNSe0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-cG9q7u5ONn-Fe2gCmRzzlg-1; Thu, 21 Oct 2021 11:09:52 -0400
X-MC-Unique: cG9q7u5ONn-Fe2gCmRzzlg-1
Received: by mail-ed1-f71.google.com with SMTP id z1-20020a05640235c100b003dcf0fbfbd8so688059edc.6
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 08:09:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=83A37QZOYVvxXVFXpAnu1+exjyyjf1N0SkLxb+/5xyI=;
        b=hhMdJwER9dUkq1DmPbX1+omWoc/ptH+OiL3ipbODdNy8+Sm3bKLSbtT24FfjPOSzeq
         vQbkfwLTqQlAyG5OdCdSCMwNgtAu+yUyBWNMXVOoueIz6s9sTHdrqeIKerFl0vNmEdP1
         Y1qk9GyrnAeD8TUJeAYbP12xHdcVUUygc0vdFieMdS99NfMU0NSrPLBDHr/Bh+Bsy8y7
         k+22oGPCjKTMpeQLyveR5RXx2eKiOEh0SjK1y2oGBl77QHPjXkeUTNLce5m/Aaeji03j
         wXH8VcWesWCeOYhKVuARl18F2n3mRhehbNbEDgEJaSUjezn8fuOf1YLLqn4rOTsGn+K/
         nuDw==
X-Gm-Message-State: AOAM530Wrn4DNIYUJ4V39NIRhiN656u7OoLb7uN8EygtLXhpUt/laLYM
        CbiBiOrOceEyLGZFYhInXNXjvHxrcoXsZM2ZgoRD5cFc38s4JQeXd4DZ3ym2bbHSRuMdAq2W0PM
        kq+dKMmROEroS
X-Received: by 2002:a17:906:2f10:: with SMTP id v16mr7896380eji.434.1634828990613;
        Thu, 21 Oct 2021 08:09:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5osbNure7kSj2eOIIMK7ExqhTuzbJFqJ//gd+55tzrFkDqZraDqizfEQvo3PILlPFqdhHHw==
X-Received: by 2002:a17:906:2f10:: with SMTP id v16mr7896361eji.434.1634828990358;
        Thu, 21 Oct 2021 08:09:50 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id r16sm2615032ejj.89.2021.10.21.08.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 08:09:49 -0700 (PDT)
Message-ID: <347b2e6f-8075-b15e-7d53-a6050856754f@redhat.com>
Date:   Thu, 21 Oct 2021 17:09:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: MMU: Reset mmu->pkru_mask to avoid stale data
Content-Language: en-US
To:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211021071022.1140-1-chenyi.qiang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211021071022.1140-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/21 09:10, Chenyi Qiang wrote:
> When updating mmu->pkru_mask, the value can only be added but it isn't
> reset in advance. This will make mmu->pkru_mask keep the stale data.
> Fix this issue.
> 
> Fixes: commit 2d344105f57c ("KVM, pkeys: introduce pkru_mask to cache conditions")
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c6ddb042b281..fe73d7ee5492 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4556,10 +4556,10 @@ static void update_pkru_bitmask(struct kvm_mmu *mmu)
>   	unsigned bit;
>   	bool wp;
>   
> -	if (!is_cr4_pke(mmu)) {
> -		mmu->pkru_mask = 0;
> +	mmu->pkru_mask = 0;
> +
> +	if (!is_cr4_pke(mmu))
>   		return;
> -	}
>   
>   	wp = is_cr0_wp(mmu);
>   
> 

Queued, thanks.

Paolo

