Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EC25F5C98
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiJEWSy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:18:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbiJEWSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:18:37 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A5A330
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:18:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id v186so259972pfv.11
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=td/rSb7Rlrpx2vQbispU4nXvXFycSMNxG+bwxAnDxt8=;
        b=Qy8DS31+hYy2m7Xr1C41jQ96lwEkhipA0EcikSZ4rw6qO5Bu6BsC2bR/aLFrlwim/C
         hpBaiVz/fXWYpiRiLgypBVXmrz2RZKB3OuZ0tjzfT+Gmnby5XdWF8Ac6drkelkVzFW/D
         OR5mAVnIdXdrErbKVsOYenemqlZdrEIG7XnXVG+jn4ZUqhkRcMPd4VxBhHWQvY5NYEu/
         VqNJVaWHafTEQsm7bUovoM38TxXKBE8WcInUr4Tc/ZK72fdU/TUj5TG1zWMT5dYa5BGk
         9V68TUcfcF0/F1/DVfTYt1y25GQ3xeBoeyRWfD5cj1opRtVi3NvVj25vN9ctg2P03nG5
         FAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=td/rSb7Rlrpx2vQbispU4nXvXFycSMNxG+bwxAnDxt8=;
        b=lqj3GL4Ni5me+mV519Ht20AUtysCgvambM3s5aPxQPpr/g2Yi/25fdchLX+YUELhmz
         /WIuZpUIfufdZCzepPxuX9v28+d3hALqfWSHP791FiDu4Wg6ItVYnurMpJevVqO3R1iU
         CDIfQBu/3WtXAi8LB62pgTPuYmrg2PBJZ/ffVFwSkOTyV8YLdrgmEMCjtt2CYA9Ftvvo
         b357DrDCvth4YjwS/AaTagJxBMWbQHl0hJV3kel/ktR5iQV8eM9YoGNRFMXedQ8jRcd4
         8hR4jYzPDtov1jmROQk15Aci61PoR/MvVnQ293pxI6dY1bmQWryMhrKuu+fTamLMMg/7
         R9TA==
X-Gm-Message-State: ACrzQf39qhyYv4teKlmiLo0uH8zujYsLDQNfE0Zr6zyJ0Kar65IZWDVf
        vHNzixyAU9AAwwLgxo0FRU9/1c1yULFMWg==
X-Google-Smtp-Source: AMsMyM4Q/zOjTK3hDEtsvkQWR113EMJccHdDskZ3BWPwTU9yt0AsDLxqtFfRA7XZ8Aeec3yoLu1/4Q==
X-Received: by 2002:a63:4b4c:0:b0:45a:5f8:b49d with SMTP id k12-20020a634b4c000000b0045a05f8b49dmr1683984pgl.490.1665008315540;
        Wed, 05 Oct 2022 15:18:35 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a15-20020a170902b58f00b0017849a2b56asm10956627pls.46.2022.10.05.15.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:18:34 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:18:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 03/13] x86/pmu: Reset the expected
 count of the fixed counter 0 when i386
Message-ID: <Yz4Ct/rxI2EZ+I7o@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-4-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-4-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The pmu test check_counter_overflow() always fails with the "./configure
> --arch=i386".

Explicitly state that the failures are with 32-bit binaries.  E.g. I can and do
run KUT in 32-bit VMs, which doesn't require the explicit --arch=i386.

> The cnt.count obtained from the latter run of measure()
> (based on fixed counter 0) is not equal to the expected value (based
> on gp counter 0) and there is a positive error with a value of 2.
> 
> The two extra instructions come from inline wrmsr() and inline rdmsr()
> inside the global_disable() binary code block. Specifically, for each msr
> access, the i386 code will have two assembly mov instructions before
> rdmsr/wrmsr (mark it for fixed counter 0, bit 32), but only one assembly
> mov is needed for x86_64 and gp counter 0 on i386.
> 
> Fix the expected init cnt.count for fixed counter 0 overflow based on
> the same fixed counter 0, not always using gp counter 0.

You lost me here.  I totally understand the problem, but I don't understand the
fix.

> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  x86/pmu.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 45ca2c6..057fd4a 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -315,6 +315,9 @@ static void check_counter_overflow(void)
>  
>  		if (i == nr_gp_counters) {
>  			cnt.ctr = fixed_events[0].unit_sel;
> +			__measure(&cnt, 0);
> +			count = cnt.count;
> +			cnt.count = 1 - count;

This definitely needs a comment.

Dumb question time: if the count is off by 2, why can't we just subtract 2?

#ifndef __x86_64__
			/* comment about extra MOV insns for RDMSR/WRMSR */
			cnt.count -= 2;
#endif

>  			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
>  		}
>  
> -- 
> 2.37.2
> 
