Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7D041CA09
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 18:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345697AbhI2Q0Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 12:26:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345551AbhI2Q0P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 29 Sep 2021 12:26:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632932674;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPjpZB7ZKa4VEqgp/LOlyRjs9pgY0FjMtIXN/7uEb5A=;
        b=PPADVmBXp8TbxNqY6Es1vs6u0fIJ4QcZ7p8fwWwQbsf/S2Rluv39w4y6JXJvmhqIOabJl/
        FSiM6CzCjy/8Lf+73Rm12g8qb5FoZZZh9ZkF3ZD8U5hm9m9Eb2Lrc2/kAutENq4oOwQp/V
        8ehub9kIW1AYmUdP6hdqPA0qxiaJ5tM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-3yjkkSutO_uQzEqf61uWkQ-1; Wed, 29 Sep 2021 12:24:32 -0400
X-MC-Unique: 3yjkkSutO_uQzEqf61uWkQ-1
Received: by mail-wr1-f69.google.com with SMTP id x2-20020a5d54c2000000b0015dfd2b4e34so805479wrv.6
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 09:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=WPjpZB7ZKa4VEqgp/LOlyRjs9pgY0FjMtIXN/7uEb5A=;
        b=tCA7VYPQVzMfRKcq6wTOFeHeCbbWhQDjls7KvKew8qmZAuOGZa4tiPElk5PValEbje
         BKhwN/THfITnYYnS95mErTKfmK/NfsO5Di7feRrz5q6jhGDx1NaTHBoTOpzKcnGB8d97
         RCAn6/IdaLwgAsGeaIp4TR5Y97K8Y3dUKQnmPUwe5x06YjeSG8Q4lynu5265SFy3W5yq
         AfIYp4+Il3HDWVZoHwZBfj6qqqhlqZkuYHPjU9eQge8G97k0ZL7fd/l4Tufb1dbEFlwR
         1/Ej50PQkVjwm9x7TQhbN5rhDfrxkItLhbEra92iWzG7PWi+e06h99wVYxcnUIG92Bxq
         TsLw==
X-Gm-Message-State: AOAM533n5UtPKaHiyC4hWUCB0HiP3ePFdwRLU+3h4QFjZJOC+qIWTzJl
        hEKuQ423iRUAX28hMBnbyS1KmNfhZhbfgVdZQR1iDg/oKaR58pTZd7ZfIjnaEOBIP3xetj50Nzv
        oDwqij7Esvj8b
X-Received: by 2002:a7b:c1d2:: with SMTP id a18mr11253728wmj.28.1632932671041;
        Wed, 29 Sep 2021 09:24:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzuGBla69X4IO7m6rAp7nL6WSmtL324HkUosRDgfHqwWdWBE791/8ceRT5Q9xIMilR/CHJgA==
X-Received: by 2002:a7b:c1d2:: with SMTP id a18mr11253705wmj.28.1632932670885;
        Wed, 29 Sep 2021 09:24:30 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id f63sm1734004wma.24.2021.09.29.09.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 09:24:30 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 04/10] KVM: arm64: vgic-v3: Check ITS region is not
 above the VM IPA size
To:     Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
        maz@kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com,
        alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-5-ricarkol@google.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <fc09a2a3-960a-9444-d736-7a6171d710af@redhat.com>
Date:   Wed, 29 Sep 2021 18:24:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210928184803.2496885-5-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/28/21 8:47 PM, Ricardo Koller wrote:
> Verify that the ITS region does not extend beyond the VM-specified IPA
> range (phys_size).
>
>   base + size > phys_size AND base < phys_size
>
> Add the missing check into vgic_its_set_attr() which is called when
> setting the region.
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 61728c543eb9..321743b87002 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2710,8 +2710,8 @@ static int vgic_its_set_attr(struct kvm_device *dev,
>  		if (copy_from_user(&addr, uaddr, sizeof(addr)))
>  			return -EFAULT;
>  
> -		ret = vgic_check_ioaddr(dev->kvm, &its->vgic_its_base,
> -					addr, SZ_64K);
> +		ret = vgic_check_iorange(dev->kvm, &its->vgic_its_base,
> +					 addr, SZ_64K, KVM_VGIC_V3_ITS_SIZE);
>  		if (ret)
>  			return ret;
>  
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

