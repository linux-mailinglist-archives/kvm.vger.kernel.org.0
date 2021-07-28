Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D653D88DB
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 09:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbhG1Hay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 03:30:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48379 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234950AbhG1Hax (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 03:30:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627457451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gBzmiE2KaP1Rkx4ybMUdQ6OFEaFkTJDJ5ZMf+LCZDks=;
        b=HdCdZrmn4KKGal5Bha2pIAH33b8zgofbACG5cWw5zem/fibKJpFjjcFi0JaPal+aXkhPj+
        rWXscPqkrD8TebSUsx/fdpGLB+EO93egDF63knJmOPV++HEwPQd45cxvfMWmiIuAkAXCgQ
        sEA27JScT+nBvoSgYMJIFJxPGXBVmiY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-325-YDMJHPmKM2yPDnFKY8kbtw-1; Wed, 28 Jul 2021 03:30:50 -0400
X-MC-Unique: YDMJHPmKM2yPDnFKY8kbtw-1
Received: by mail-ej1-f72.google.com with SMTP id g21-20020a1709061e15b029052292d7c3b4so497461ejj.9
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 00:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gBzmiE2KaP1Rkx4ybMUdQ6OFEaFkTJDJ5ZMf+LCZDks=;
        b=iJxfQqwROoAXoNRLXLA6ri20NnDjg8wHnD0yUxwisVYd20nuslep8p8QLrHJPwYcC9
         N8WaloR8Py7y28DaYPkaeCaYumBVwwq0Lm5eJeHBj2zyQCiCdeUXixi4CX75VAwG/MlV
         xnL3nBrcOXWdW56VwML82EU4diI2QiR3ZagXh3CcscbNnsMWP5TuOUDLj/QG8U2WRa03
         8LovaUunCBcnhNVm+ei4NiaaoXMc8CED+NBraOoJs9L6Oz79cfdCvIVVV2lRvZ1u1tk6
         cK3PkKc8VynBiP0il24BP36qpaknkYAtYDrJKwlTC/7IZ6EBOdCCz/UwyMCaN/b0YOfG
         VVnw==
X-Gm-Message-State: AOAM533Dcit5GiPPn9v12WccFzbO10K7wplTFnyAeUZQddvsiZbxnxPy
        XKhkUfGubtU0nSxNwLw/2qBB3lYxwzLXz3bVcDpfFD34srNODKwPpUvLzUf2LOOJLia/vN2HHu6
        z16QJ61jhu+pV
X-Received: by 2002:a05:6402:170d:: with SMTP id y13mr4083406edu.228.1627457449047;
        Wed, 28 Jul 2021 00:30:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxIPD61KneKnMpS6mbHSyOaSwiQcu3JMUJX83HwyFObdeqXpzvjKPm1SBdhQyu2ZD3VBppUXQ==
X-Received: by 2002:a05:6402:170d:: with SMTP id y13mr4083394edu.228.1627457448889;
        Wed, 28 Jul 2021 00:30:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id n17sm2220109edr.84.2021.07.28.00.30.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 00:30:48 -0700 (PDT)
Subject: Re: [PATCH] target/arm: kvm: use RCU_READ_LOCK_GUARD() in
 kvm_arch_fixup_msi_route()
To:     Hamza Mahfooz <someguy@effective-light.com>, qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org
References: <20210727235201.11491-1-someguy@effective-light.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e84e3fe7-e644-7059-22cc-ddefd8bfc8c4@redhat.com>
Date:   Wed, 28 Jul 2021 09:30:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210727235201.11491-1-someguy@effective-light.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/21 01:52, Hamza Mahfooz wrote:
> As per commit 5626f8c6d468 ("rcu: Add automatically released rcu_read_lock
> variants"), RCU_READ_LOCK_GUARD() should be used instead of
> rcu_read_{un}lock().
> 
> Signed-off-by: Hamza Mahfooz <someguy@effective-light.com>
> ---

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

>   target/arm/kvm.c | 17 ++++++++---------
>   1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index d8381ba224..5d55de1a49 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -998,7 +998,6 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
>       hwaddr xlat, len, doorbell_gpa;
>       MemoryRegionSection mrs;
>       MemoryRegion *mr;
> -    int ret = 1;
>   
>       if (as == &address_space_memory) {
>           return 0;
> @@ -1006,15 +1005,19 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
>   
>       /* MSI doorbell address is translated by an IOMMU */
>   
> -    rcu_read_lock();
> +    RCU_READ_LOCK_GUARD();
> +
>       mr = address_space_translate(as, address, &xlat, &len, true,
>                                    MEMTXATTRS_UNSPECIFIED);
> +
>       if (!mr) {
> -        goto unlock;
> +        return 1;
>       }
> +
>       mrs = memory_region_find(mr, xlat, 1);
> +
>       if (!mrs.mr) {
> -        goto unlock;
> +        return 1;
>       }
>   
>       doorbell_gpa = mrs.offset_within_address_space;
> @@ -1025,11 +1028,7 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
>   
>       trace_kvm_arm_fixup_msi_route(address, doorbell_gpa);
>   
> -    ret = 0;
> -
> -unlock:
> -    rcu_read_unlock();
> -    return ret;
> +    return 0;
>   }
>   
>   int kvm_arch_add_msi_route_post(struct kvm_irq_routing_entry *route,
> 

