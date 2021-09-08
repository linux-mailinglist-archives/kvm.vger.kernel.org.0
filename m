Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E4E40408C
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbhIHVdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbhIHVdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 17:33:18 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60F1FC061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 14:32:10 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id s16so3852677ilo.9
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 14:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uZbNrjLOwzJp4fFJM+cNQcKd8IqlQMB7ACTwfLqh720=;
        b=Ett/Xnj4B+RYOCHKQFGaJnIjhhXun6RIb3DCCgH1bOAdsvr1XprrI60dfFjcYLkjIp
         WDuayRb97yZhJ+qlb+s6kOSERJhp22DoEXbQrsXurJxcraxBKnTRu5o0SLLnlnoMoThC
         CNFW39GKXId+Xaa4y5B3i6sFIHm1vYXe00gc4VLRu3d7ixbnmZef4+VkRytJFizRYF3g
         r7dRh/qjXx3YrF0WrOYKOG8ipIrYjmOdkK9Lx3/4XJmw9g657fmFuWik1+invwtWyxFJ
         4nXC5Uq6b96hPvLEq5sl7I1C7Way6nZrGMbhwOv3v1FKKcXTaqxybkkw4Qk/07oFwv50
         vPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uZbNrjLOwzJp4fFJM+cNQcKd8IqlQMB7ACTwfLqh720=;
        b=ERwDFCeG5HkzBBymRgRLQuQtxkG7hKQ3CJFLx7dyNjfE32AF7cHObCbojI+CpiRFSh
         +XaqKaVGlnsVF84gHpC9Sah5taZkj6SJi9f6mvIwXi4DiqywGhw5gG4dbGduSD1jXOrp
         R3GiH0gH/1BbbTQ0pQZ1C4O5Wq8yDyPQfqy54EhBSUw3wHLKQFzW1p+gazqiztM3KZ3N
         Vs+p3zcJsPdQ8/Oq+cDAV4e164dfjQND5PquD345S5w36TJ2aB5Ph1xlWaIqZEriIqBE
         bAPtUbXAHY921ga2jMZ8D8C5NtUcrxGuV+sLtoJMFycS6rNKR7lTVFq/8qLzVbwIop7Z
         vdnQ==
X-Gm-Message-State: AOAM533J8w9eaBBR8EiPDrTwBiG1sdiEcauZPBeks5378pwCH/F6LTsg
        R6Zcm1p1XT24+9GGydBww4GTGkyhlqO3yhNA
X-Google-Smtp-Source: ABdhPJwciF/VAdAEbUH3mpVJJwTsflA3hfhOWENiEDiyry80B9MoAQJ2HWB2Fc1zl0RfhUmXiBz2sg==
X-Received: by 2002:a05:6e02:2145:: with SMTP id d5mr257650ilv.214.1631136729375;
        Wed, 08 Sep 2021 14:32:09 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id b76sm184005iof.17.2021.09.08.14.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 14:32:08 -0700 (PDT)
Date:   Wed, 8 Sep 2021 21:32:05 +0000
From:   Oliver Upton <oupton@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com,
        alexandru.elisei@arm.com, Paolo Bonzini <pbonzini@redhat.com>,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
Message-ID: <YTkr1c7S0wPRv6hH@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908210320.1182303-2-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On Wed, Sep 08, 2021 at 02:03:19PM -0700, Ricardo Koller wrote:
> Extend vgic_v3_check_base() to verify that the redistributor regions
> don't go above the VM-specified IPA size (phys_size). This can happen
> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
> 
>   base + size > phys_size AND base < phys_size
> 
> vgic_v3_check_base() is used to check the redist regions bases when
> setting them (with the vcpus added so far) and when attempting the first
> vcpu-run.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
> index 66004f61cd83..5afd9f6f68f6 100644
> --- a/arch/arm64/kvm/vgic/vgic-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>  			rdreg->base)
>  			return false;

Can we drop this check in favor of explicitly comparing rdreg->base with
kvm_phys_size()? I believe that would be more readable.

> +
> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
> +			kvm_phys_size(kvm))
> +			return false;
>  	}
>  
>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
> -- 
> 2.33.0.153.gba50c8fa24-goog
> 

--
Thanks,
Oliver
