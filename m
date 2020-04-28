Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB831BC0A8
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 16:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgD1OHc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 10:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgD1OHc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 10:07:32 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FD4C03C1A9
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 07:07:31 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id v26so11742722qto.0
        for <kvm@vger.kernel.org>; Tue, 28 Apr 2020 07:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fy9ivS8QPPwiuCK+doJtcNxxWhUNoFRKbiicEk8ESXs=;
        b=m03V7Bqnrzc7u1hOHNegLX/D6uRA6iSn20RxNU8QvJ1QFKsSaD70QJ6n/s/UyarsFJ
         rS4XcjYTl/K8wPVQmsqZcwGaYD4DEF96z+keAqbELkFqDS54ADd792WseZXN6fmhZjdK
         D2hC44IoUKWdnBAHvC5M60WEYESwUu1VZofGFOKhASI+hQkhe9zsHZWNSdgUyJHHj9IU
         jBU0JJsSzE8KiMpymNT5HJRvRE8knYzVWS+0PdOCFmaciO0iQSVK5de5Rbf3CztawIBI
         CdsaCr46/lqDnOLgGy9KBM4Sz16Nusr1wxAiubc5Qq7sqPrR7bFG3qVDFZzxPdIE6WuI
         tBmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fy9ivS8QPPwiuCK+doJtcNxxWhUNoFRKbiicEk8ESXs=;
        b=nAd5V4gnOefyTvchimkJgZc9pCfluWFfOCKyd00VTqp6YnaXqF0J9vg/YxFh6iqnvo
         1QzMsMjbW3KtFEYHnn3ITDx9yDdEqqRtYmrYwfAZDOtZHTQ+VjSU2lc0bkbEdZe+8BR3
         oxrzizHdKs7T/pILh/nC074qS/0prNdoVB9ezMooRprJhwb3eyPMdGAY+J9g36HJoqDp
         8/6+xuCCEVPjUr+7G9jEnUYKfObQuDai46httClC8Yd+bj9H9z/c+vxQOfBDHmYWgvWV
         WCH6Dq+wI+UGgW7DdrpP/7hfNyI9KEt/aOHo090bxzIrDgpGAFYCtB3dnkw1/JK52ZyN
         inRQ==
X-Gm-Message-State: AGi0PuadCyllvtrWsC3E4FfIvl/g8e2jlkIHfq/7qsNLT+c6pCQQDPu8
        W+vm8m4DC4OJGHwZ2VhSQO9mLg==
X-Google-Smtp-Source: APiQypL8JVVgXn1Z0K37nLLf+jtFxuaUMdsGklwooOQS8IA68vzDHPI0GpgPkHQUdRDPsQEeiTjwEQ==
X-Received: by 2002:ac8:65cc:: with SMTP id t12mr28186660qto.310.1588082850656;
        Tue, 28 Apr 2020 07:07:30 -0700 (PDT)
Received: from [192.168.1.10] (c-66-30-119-151.hsd1.ma.comcast.net. [66.30.119.151])
        by smtp.gmail.com with ESMTPSA id 29sm13492497qkr.109.2020.04.28.07.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2020 07:07:29 -0700 (PDT)
Subject: Re: [PATCH 1/3] KVM: x86/mmu: Tweak PSE hugepage handling to avoid 2M
 vs 4M conundrum
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200428005422.4235-1-sean.j.christopherson@intel.com>
 <20200428005422.4235-2-sean.j.christopherson@intel.com>
From:   Barret Rhoden <brho@google.com>
Message-ID: <3e60b34b-e160-2052-3066-c29867ccef64@google.com>
Date:   Tue, 28 Apr 2020 10:07:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200428005422.4235-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/20 8:54 PM, Sean Christopherson wrote:
> Change the PSE hugepage handling in walk_addr_generic() to fire on any
> page level greater than PT_PAGE_TABLE_LEVEL, a.k.a. PG_LEVEL_4K.  PSE
> paging only has two levels, so "== 2" and "> 1" are functionally the
> seam, i.e. this is a nop.
   ^ s/seam/same/

Barret

> 
> A future patch will drop KVM's PT_*_LEVEL enums in favor of the kernel's
> PG_LEVEL_* enums, at which point "walker->level == PG_LEVEL_2M" is
> semantically incorrect (though still functionally ok).
> 
> No functional change intended.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>   arch/x86/kvm/mmu/paging_tmpl.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index efec7d27b8c5..ca39bd315f70 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -436,7 +436,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>   	gfn = gpte_to_gfn_lvl(pte, walker->level);
>   	gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
>   
> -	if (PTTYPE == 32 && walker->level == PT_DIRECTORY_LEVEL && is_cpuid_PSE36())
> +	if (PTTYPE == 32 && walker->level > PT_PAGE_TABLE_LEVEL && is_cpuid_PSE36())
>   		gfn += pse36_gfn_delta(pte);
>   
>   	real_gpa = mmu->translate_gpa(vcpu, gfn_to_gpa(gfn), access, &walker->fault);
> 

