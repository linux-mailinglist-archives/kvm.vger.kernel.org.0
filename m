Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B5D78BFDD
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 10:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjH2IEA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 04:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233997AbjH2IDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 04:03:32 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAAABF
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 01:03:13 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3ff1c397405so39242475e9.3
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 01:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693296192; x=1693900992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4gXf3eI1QYqFSBc9LYV5znKy6QYEcZ1Llv8J9Br/30g=;
        b=R4nfeAQe8389sakj85amigGqLjaTc5JmMj9kA/xecvE2GXDEaoUHkRK0WyXB3oI7pG
         N2Y3YUgKsb48TcEPLCZ9o2myLSza9uD5H7rEhmA8xr1ZDbiwGBiwDlqztMO84VEimyck
         0lM3IQiAYPWmW0gii9vGagavXCxeBVCYRx/jLcwbJRG6c8pMvabk5XOr8qWhlz/YF6tG
         3DY8AZUF9Gr0/dCw/TOgKsY32OYI9Bu9Jq1AqI/6TUUIv7fP37wD1kZRWIlVjow6EG5m
         nRV/+5QkP+eTrpPmQngb/iQ333LZWTcLuU1R+56qteSoUnZTu9scy5xqs4m6OOx0tvyU
         CNmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693296192; x=1693900992;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4gXf3eI1QYqFSBc9LYV5znKy6QYEcZ1Llv8J9Br/30g=;
        b=KbDB5eG9JveKKMq7K0wmxvvzLNAhA16Dz59etjlY6ZhmVKl9KMNtKCfsN24hrDdamL
         BTSP0svqUZGzVD8epL4nSXDWg7fJx08ByQQkQkYpNeYC+qhOFCwMVPB/KmK6ctue8umd
         PddHnDARVWnFJwWioDbnGpgHhzfXqRYyQOeGwCPZ6QsIwBmftLVyRyqqxnTc9oUk2zNR
         RM++0O4z+gDIgiqJHe3dXXOdimpkX4r5UTvaFpGv7IPaA6lHCYShYKCN5jWOoDyxud/S
         oJ2aS2P1y+2Y7alkmHkViBCEUYFmp9kxIkVpeTeeXuPL2G83DOcaSK4FWNiXeuQT/0wr
         EkAQ==
X-Gm-Message-State: AOJu0YwY41Yq0NqgOoaSHluQpLMZ23VMXmZKUW586syVxi0lHvLBjj2N
        DP8DCegWfFWzFLKjZMt6wL5SzQ==
X-Google-Smtp-Source: AGHT+IGxucRA+7L1hdHwgNAnEmkSoW5Bvkr6fFVHqCl2UnKHxiBF8oS42kFwTnL8bpzXsEtHLeDh5Q==
X-Received: by 2002:a05:6000:229:b0:31c:8c93:61e3 with SMTP id l9-20020a056000022900b0031c8c9361e3mr4756583wrz.60.1693296191819;
        Tue, 29 Aug 2023 01:03:11 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id a17-20020adfe5d1000000b00317f70240afsm12819304wrn.27.2023.08.29.01.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 01:03:11 -0700 (PDT)
Date:   Tue, 29 Aug 2023 09:03:05 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] KVM: arm64: Properly return allocated EL2 VA from
 hyp_alloc_private_va_range()
Message-ID: <ZO2mOU2Mu42QKlSU@google.com>
References: <20230828153121.4179627-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230828153121.4179627-1-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 28, 2023 at 04:31:21PM +0100, Marc Zyngier wrote:
> Marek reports that his RPi4 spits out a warning at boot time,
> right at the point where the GICv2 virtual CPU interface gets
> mapped.
> 
> Upon investigation, it seems that we never return the allocated
> VA and use whatever was on the stack at this point. Yes, this
> is good stuff, and Marek was pretty lucky that he ended-up with
> a VA that intersected with something that was already mapped.
> 
> On my setup, this random value is plausible enough for the mapping
> to take place. Who knows what happens...
> 
> Cc: Vincent Donnefort <vdonnefort@google.com>
> Fixes: f156a7d13fc3 ("KVM: arm64: Remove size-order align in the nVHE hyp private VA range")
> Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/79b0ad6e-0c2a-f777-d504-e40e8123d81d@samsung.com

Having a hard time reproducing the issue, but clearly that set is missing from
the original patch!

Sorry about that extra work.

> ---
>  arch/arm64/kvm/mmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 11c1d786c506..50be51cc40cc 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -652,6 +652,9 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
>  
>  	mutex_unlock(&kvm_hyp_pgd_mutex);
>  
> +	if (!ret)
> +		*haddr = base;
> +
>  	return ret;
>  }
>  
> -- 
> 2.34.1
> 
