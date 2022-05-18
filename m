Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF4B52AF72
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 02:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiERA5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 20:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiERA5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 20:57:21 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B4553B63
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 17:57:19 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id q18so321341pln.12
        for <kvm@vger.kernel.org>; Tue, 17 May 2022 17:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=npTrpyibpcHYPfQZTpDmUyucJGjeBDrioG++oR2ibeU=;
        b=FkHgNSHUuiilewkuVEF+228MjpomAsEOeZx+wFeVrbVR95SFY/ifSBstmx+9+7EDxU
         b6BwOt6DKM1jvTKDjf/rMZTKHSCOWGDXgTsxIdQLQJUhTCLcXJaPBR+agKQsSfH0PWVL
         IUsQfTbH9VgXwDHOqIE1opsmGlPsXJaqmTX08DkjmH1GCZmRa8I75dp5ZO5z9oaJbO42
         0YrKei0bwgwYpkpFP1hwKjDdudV7oJmUoz5aLLC9umAqK6ff8SOFUbx5X5E1KIs6U7HG
         ITDmUxj2VvaZoxW8MxyjlXTbDkwoQh8iqfgg7JiQYX0r4T7VCVnSsDcTg3lk02cuG+DS
         7J9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=npTrpyibpcHYPfQZTpDmUyucJGjeBDrioG++oR2ibeU=;
        b=sgZVkgHUv1KfmB1dLsmf8zw5IGEaW/owAHaX+U23sB2dy1kt62wdQb4SUpOU57GLxm
         dG95YV2xJjAb501Uh++9n6C5CCUzF4FDKDzoMDd/5XCMNe7bUAhY+Bsjflx+J8xKnnvR
         xs+QS5QJswfFUPYyP1mggPEXCcoxif1lTxz0rtvh3uQNcsswpVdtgPUIvHdD8WOOr7bg
         CNpCOnG8geiezBWSMYlXNMRPHeJv2ydlKieX6qNROdDxaP2JiGc6ZOFzVvBDnUNE91rB
         ynwv5TqnXlBBjQt0pNf4U9AHn212vb/pp+7AMTpLJsZUacObF6kPSXk6m6bVpgeJaH/m
         Q9oA==
X-Gm-Message-State: AOAM533KFfa2zw3sIoYZMCJ9MJ5nDm1wHdQz/uxuIO3BWTTBIBgmOvx5
        5E+SZKFi8fPUk1+t+IQKsXZ72VrJqGLq4w==
X-Google-Smtp-Source: ABdhPJxvQ607k2GDaByZK/BKjAnDf6cuyNWxq2HYbYyZLQ6IafdHeOwv0mweP9qRTit9HjbVRdbU/w==
X-Received: by 2002:a17:90a:3f8c:b0:1df:28c5:e87a with SMTP id m12-20020a17090a3f8c00b001df28c5e87amr18516069pjc.170.1652835439221;
        Tue, 17 May 2022 17:57:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b7-20020a62a107000000b0050dc7628195sm351714pff.111.2022.05.17.17.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 17:57:18 -0700 (PDT)
Date:   Wed, 18 May 2022 00:57:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 1/3] kvm: x86/pmu: Fix the compare function used by the
 pmu event filter
Message-ID: <YoREatFTrxJVcfHg@google.com>
References: <20220517051238.2566934-1-aaronlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517051238.2566934-1-aaronlewis@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022, Aaron Lewis wrote:
> When returning from the compare function the u64 is truncated to an
> int.  This results in a loss of the high nybble[1] in the event select
> and its sign if that nybble is in use.  Switch from using a result that
> can end up being truncated to a result that can only be: 1, 0, -1.
> 
> [1] bits 35:32 in the event select register and bits 11:8 in the event
>     select.
> 
> Fixes: 7ff775aca48ad ("KVM: x86/pmu: Use binary search to check filtered events")
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> ---
>  arch/x86/kvm/pmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> index eca39f56c231..1666e9d3e545 100644
> --- a/arch/x86/kvm/pmu.c
> +++ b/arch/x86/kvm/pmu.c
> @@ -173,7 +173,7 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
>  
>  static int cmp_u64(const void *a, const void *b)
>  {
> -	return *(__u64 *)a - *(__u64 *)b;
> +	return (*(u64 *)a > *(u64 *)b) - (*(u64 *)a < *(u64 *)b);

On one hand, this is downright evil.  On the other, it does generate branch-free
code, whereas gcc does not for explicit returns...

It's a little easier to read if the values are captured in local variables?

	u64 l = *(u64 *)a;
	u64 r = *(u64 *)b;

	return (l > r) - (l < r);

Either way,

Reviewed-by: Sean Christopherson <seanjc@google.com>
