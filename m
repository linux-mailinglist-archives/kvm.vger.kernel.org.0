Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2377235173D
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 19:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356144AbhCDA3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347487AbhCCQuN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 11:50:13 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789CCC061764
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 08:49:32 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s7so7162732plg.5
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 08:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w89dhafdcTBvPIF85pqTILGa/UQI997YGnl2uzLm600=;
        b=sjAKSKtdd0qE8aGrV/g7K5tp0Ut2VV3W8GjrebN5IOnnr2u+ye1uUb3f62HiAPRgXp
         QUaFAhKpGHJFh064Js9Fj32CPj/zpSFMdphLhK9awrj3OHBjjZnFj+g6c4sM9IcZ2/f9
         kaIpcn+DnNZG8OGlDfeECHdukgD9ikS7k4B3wdOFR8iYV0tbLVd1E8hovsZYW9gMCYc3
         ApM4s5x/O6tg+/mVUAr4Q7V+SOnEUJQbw8Bwcd3/1er4hJ3d39L0cqBc4fR2gR2VqDmq
         20I9w0hEi5aR1k7F4Z40pfe9y1gN/zpABnqxCyu4xPjRE+9Ke0UOqAXMmQuCHwwqbNUJ
         YdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w89dhafdcTBvPIF85pqTILGa/UQI997YGnl2uzLm600=;
        b=SdD+z3fQe0ZUoBBZRaBVv3J58SnthrY1i76DukKlTfI2MxkANMV85N6s+KAUvN/7+B
         mukkLV4vEpQfa1WtkGlHbd/bB2E1ocB6JNPXv2qcdc0e9XUqwKceqD2I7eigGf60FF5F
         dqC9/doCCvf8DXfTHGhicccSVoIYB4pWu5Rdi6ohnDBPOJ/1STAds3OpzF4SaoBIrrGa
         VKlv4pHCGKwn0FoSpLhSa/dEnccCb3x2JMWbekF5noQtTEaY66FkSHa0caTIHGFiIVlD
         ObDrXVOf/wKAQiEkHGGkWPh6Iz30wFiTrUsmizAlfcHI9KrxXwe3buhqXQBGiK7Ts78V
         S5BQ==
X-Gm-Message-State: AOAM5320GVxLut4NO7y7wEwVl+1W0pClpnQFGEy0UMMdW21iqCYaJR/e
        JJY9qPKl7Mp2dYLEylk11RIdkg==
X-Google-Smtp-Source: ABdhPJygoIGT3E2Mq7v4KxLMZzcbXTD1z+JRgPMCk5eKtTzlmhUO+vNxMmor202/49XuL7QJt0DXRQ==
X-Received: by 2002:a17:902:ff15:b029:e4:51ae:e1ee with SMTP id f21-20020a170902ff15b02900e451aee1eemr85184plj.83.1614790170916;
        Wed, 03 Mar 2021 08:49:30 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id x11sm7841144pjh.0.2021.03.03.08.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 08:49:30 -0800 (PST)
Date:   Wed, 3 Mar 2021 08:49:23 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/9] perf/x86/intel: Fix a comment about guest LBR
 support
Message-ID: <YD++EyC0z2Vtu6uB@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-2-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303135756.1546253-2-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021, Like Xu wrote:
> Starting from v5.12, KVM reports guest LBR and extra_regs
> support when the host has relevant support.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> ---
>  arch/x86/events/intel/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
> index d4569bfa83e3..a32acc7733a7 100644
> --- a/arch/x86/events/intel/core.c
> +++ b/arch/x86/events/intel/core.c
> @@ -5565,7 +5565,7 @@ __init int intel_pmu_init(void)
>  
>  	/*
>  	 * Access LBR MSR may cause #GP under certain circumstances.
> -	 * E.g. KVM doesn't support LBR MSR
> +	 * E.g. KVM doesn't support LBR MSR before v5.12.

Just delete this part of the comment.

>  	 * Check all LBT MSR here.
>  	 * Disable LBR access if any LBR MSRs can not be accessed.
>  	 */
> -- 
> 2.29.2
> 
