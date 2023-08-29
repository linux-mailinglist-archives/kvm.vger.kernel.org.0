Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 394EC78C0DF
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 11:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232221AbjH2JA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 05:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbjH2JAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 05:00:49 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B29A1102
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 02:00:46 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-401ceda85cdso12710985e9.1
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 02:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693299645; x=1693904445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bHTLgnpFFXBTfxGfgdL+O85r9b9TDOpfmvwoDKUJVxM=;
        b=oe8F/g5G1FboEK+FTF4IaG7O0bvi+XeMcUw0IQJ32dDscxNEQw5DQITzn7VYozPDgD
         qgTfy2+lbiZTHAbiTuJQNR8oWdQJxdEoSMT9nKrbDxe4YGLd0rOGnVKcMMJ4Ds6ERZwC
         uqSy743PdciabyVUvxq95A1EwjCrGSyEX5RVjfjtDfKGwuX/iLnZBVK2Vsv8Xu7olwmZ
         qFLtEMtvM8MWQtwAprv/UJC9IsXprMJ+cyr50ylDzHrCx57Xs19vk43C2dUHIpQajN5D
         32mtUEY2zeIHuwcXLcttFRxcXiSEPmbl6MiIxDN+7Hm2QNCAsjK0S/nk2Pw2yFCLok68
         aC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693299645; x=1693904445;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bHTLgnpFFXBTfxGfgdL+O85r9b9TDOpfmvwoDKUJVxM=;
        b=Zus4jbDDAYZSvMEI9aWytQR7OXJY+OHBCbshoFoAEadjG4dl5SliiYAo0GtCevfqvg
         L70BZiw+0U+XiiHE7KuQgZjjokFREesiI66g6XosWi+w5lNjgLkvP3/SkACqN8WNuVeH
         Rm1S+XOPWH88pj7b8qif3iCudDY/ZxrYUZ18ZlOjH/+5DKWsPiYkFbIQioVywau945x+
         sYNx1GbmHM8cDf2SObaMOBamIVVr/66J3KeFyYG6NVKFCk08ZeEcpuqCW/kR0GsOQmmx
         mSgAr8oaR1Z/6gmstAEth1GH+47pztqpXXMMg0/QstvLdsGSS6fry1GFKqg7l7DWlK79
         ni2A==
X-Gm-Message-State: AOJu0Yy3D/rvbCrHQYaaNs91clXnysnwe0xuy/46OmO+yCO7gvVVTC7E
        7PE7kgDQBcFAQNc2FCsT3IMZwhp0lzk93LbAjv9UoYxq
X-Google-Smtp-Source: AGHT+IGN+EhT5kZpnXUg/V1iMKklDj4SQ+Z6bHXsO2fecs6GWuss4AMe2t7VQU16A4d6hDd3nf1zXw==
X-Received: by 2002:a5d:40cd:0:b0:317:5168:c21f with SMTP id b13-20020a5d40cd000000b003175168c21fmr20457804wrq.31.1693299645067;
        Tue, 29 Aug 2023 02:00:45 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id d11-20020a056000114b00b0031c6dc684f8sm13112683wrx.20.2023.08.29.02.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 02:00:44 -0700 (PDT)
Date:   Tue, 29 Aug 2023 10:00:40 +0100
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
Message-ID: <ZO2zuN2rgROORZUu@google.com>
References: <20230828153121.4179627-1-maz@kernel.org>
 <ZO2mOU2Mu42QKlSU@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZO2mOU2Mu42QKlSU@google.com>
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

On Tue, Aug 29, 2023 at 09:03:05AM +0100, Vincent Donnefort wrote:
> On Mon, Aug 28, 2023 at 04:31:21PM +0100, Marc Zyngier wrote:
> > Marek reports that his RPi4 spits out a warning at boot time,
> > right at the point where the GICv2 virtual CPU interface gets
> > mapped.
> > 
> > Upon investigation, it seems that we never return the allocated
> > VA and use whatever was on the stack at this point. Yes, this
> > is good stuff, and Marek was pretty lucky that he ended-up with
> > a VA that intersected with something that was already mapped.
> > 
> > On my setup, this random value is plausible enough for the mapping
> > to take place. Who knows what happens...
> > 
> > Cc: Vincent Donnefort <vdonnefort@google.com>
> > Fixes: f156a7d13fc3 ("KVM: arm64: Remove size-order align in the nVHE hyp private VA range")
> > Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > Link: https://lore.kernel.org/r/79b0ad6e-0c2a-f777-d504-e40e8123d81d@samsung.com
> 
> Having a hard time reproducing the issue, but clearly that set is missing from
> the original patch!
> 
> Sorry about that extra work.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> 
> > ---
> >  arch/arm64/kvm/mmu.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index 11c1d786c506..50be51cc40cc 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -652,6 +652,9 @@ int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
> >  
> >  	mutex_unlock(&kvm_hyp_pgd_mutex);
> >  
> > +	if (!ret)
> > +		*haddr = base;
> > +
> >  	return ret;
> >  }
> >  
> > -- 
> > 2.34.1
> > 
