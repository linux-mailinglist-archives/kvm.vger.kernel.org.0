Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A02373F18
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 18:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhEEQBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 12:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbhEEQBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 12:01:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91125C061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 09:00:06 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ge1so1046481pjb.2
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 09:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wuvv2xBHKwPhd2N5eipShZJIydtEFy0f3fL0n3i5f/E=;
        b=CnoFToZa3auDbf0FuOqX4AWWOMviCqe2lB0xEO0rMdf4kjSk9ihBrlkM71Z5o/hDgb
         KG2IuxmAtiSmKP4+4LxLjS8WbjPoBdz5t6F6veezxjS3unD+JKDguHznYeobPq0f7d3v
         jFk42nEs1aH3FkkWobo0kmNLJPnRJEz6QzMZZYs8WctTjnj37bdXVDgvAvmgdC0m4vXD
         IjzUURatRfcdvWo9e+3L80OKSHIkW7dJbpzyoMtQHfxss1aB6Xp32bcwIGJfsBD4EylO
         ZrdL34u3qMFdgIgWE9PNe3F/Hr+V/4UhH0DCVWre6JvzSoigA/8B+Qrr82RfpCBdgiLJ
         Ozmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wuvv2xBHKwPhd2N5eipShZJIydtEFy0f3fL0n3i5f/E=;
        b=tfDM1yNE5TpaZW83FqgCdWWbMMfbiVv3u/mY+lA03GjblDsEV+2NodcS9qstIOysg0
         DGQjsVvmx2RfSbmAGKtoSZd9sbjy4KRL7j0axkFP32dxRZarRNnc5lkef6+LmC6z8dhN
         AH9bbfVhZYZAbry2A1L7wZF1vv9ozKIJMg+Mx0XArnF1eAos5IZ7QuxlTzYPa9vbBjNh
         4Jd5JIb+OpqWaxNLuf+F/mvoWQNc+QBVmIyYrY5rVS6sMIACzlzlqX2r2OxDY4+pRkaO
         igRKDf1Ov8Q+UaTvRtva1Eiy6J2S+uIf6VnY79wLpVg/+5Pl/RpX6f0NsJy4T0T7itMz
         sC7g==
X-Gm-Message-State: AOAM5328LeqTCoXHauYwUFqGCDHej4oFjhV9YOnSqwQ2VvkJpkwonn/R
        8Qe/Nz0mzglxh9a3+96dVBartg==
X-Google-Smtp-Source: ABdhPJwTrgYanvZ0fsp8qgoIfAsokmxp5ryQa15eblbE9VkXITMTcgTjGMdJx8sQAfP8UenhOXRHaQ==
X-Received: by 2002:a17:90a:e615:: with SMTP id j21mr12176726pjy.43.1620230405979;
        Wed, 05 May 2021 09:00:05 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id k69sm7020641pgc.45.2021.05.05.09.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 09:00:05 -0700 (PDT)
Date:   Wed, 5 May 2021 16:00:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Fix return value in
 tdp_mmu_map_handle_target_level()
Message-ID: <YJLBARcEiD+Sn4UV@google.com>
References: <cover.1620200410.git.kai.huang@intel.com>
 <00875eb37d6b5cc9d19bb19e31db3130ac1d8730.1620200410.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00875eb37d6b5cc9d19bb19e31db3130ac1d8730.1620200410.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021, Kai Huang wrote:
> Currently tdp_mmu_map_handle_target_level() returns 0, which is
> RET_PF_RETRY, when page fault is actually fixed.  This makes
> kvm_tdp_mmu_map() also return RET_PF_RETRY in this case, instead of
> RET_PF_FIXED.  Fix by initializing ret to RET_PF_FIXED.

Probably worth adding a blurb to call out that the bad return value is benign
since kvm_mmu_page_fault() resumes the guest on RET_PF_RETRY or RET_PF_FIXED.
And for good measure, a Fixes without stable@.

  Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")

Reviewed-by: Sean Christopherson <seanjc@google.com> 


Side topic...

Ben, does the TDP MMU intentionally not prefetch pages?  If so, why not?

> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index ff0ae030004d..1cad4c9f7c34 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -905,7 +905,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>  					  kvm_pfn_t pfn, bool prefault)
>  {
>  	u64 new_spte;
> -	int ret = 0;
> +	int ret = RET_PF_FIXED;
>  	int make_spte_ret = 0;
>  
>  	if (unlikely(is_noslot_pfn(pfn)))
> -- 
> 2.31.1
> 
