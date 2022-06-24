Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE5755A455
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 00:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiFXWXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 18:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiFXWXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 18:23:37 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B747985D04
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 15:23:36 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so6981501pjm.4
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 15:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mZCKcbCWXXOx0stmlnfGcfNaxRyKgRYCrrKRpFOC5u0=;
        b=DxqiFX9Kjqb15Z/WDEpl++Vdz8XVrQFDq46aMEQSLWPvyGwwYtlzXO+NVXtxvmTyFB
         UgoR4wY9+vldsJqrU/WOAnR4p7F7qnB5qSc3rTvcr+igyFCumXpfAg5wxstSjRapKSlC
         tYH3i0+5hKvkYrhLl1K6/d6rsxVxKgn+eCCW2rcPkf26jBUe2/mIdbT7JKHuP1KpApYT
         jZDBBAO68L/crXJxo5q4PxKZY4Ljz+bkav5HBdoNznFKJWlXFv6Z6NemVJgbdVz3S3ig
         98harGCsgIS2218utiCjiGef5YjWyFneSABJyPvBzXVC6jU2+7r+PI/y6dIq0T9qg045
         BO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mZCKcbCWXXOx0stmlnfGcfNaxRyKgRYCrrKRpFOC5u0=;
        b=D77LxXlHgo8NyElyjaiSnOs2PEdzMKKQ/Rswe1mQooJWISSbam7xkwvTSDoUWPx5Ie
         lZfbItB7Kd9hAxmE4NZX1roZzfV20rYtjpnCmCpP9YFBJG2ghsBb/p3dq70E4fu3Cqpt
         SZY4brMmjXTWS9kvMgNxXzyuKLvC8DvMq4kDbl28RCKB0AtjjtTyU44VXYdbMmsHM2pc
         lXGWi+VaH+4z/YTwxWmUomO6KsDT/I7CJBUnxjJIEjXcmH+ofRVDgrf4ERGIsEUBhbNo
         FI0XYJosE7hYnB6aovHtupw6L4kyOOjla0SSsvAc3/YGB8S/RFQqzLEXJdvoFTlxb0C0
         iUwQ==
X-Gm-Message-State: AJIora+JxWSKi1aEzHHaVhHrLYo9TbWYvITlvN2Jy8e7GsbWosipLamD
        kkl3Q4bJNEi1oxDap4kISD/trA==
X-Google-Smtp-Source: AGRyM1tQY174diXpBYQ6A3TvnXUs3FgCReAP8l5eEptp8jilCiolHPYZBu5v8M4hezXEr0nkhoV6qw==
X-Received: by 2002:a17:90a:780c:b0:1ec:d94b:2f93 with SMTP id w12-20020a17090a780c00b001ecd94b2f93mr1121925pjk.233.1656109416146;
        Fri, 24 Jun 2022 15:23:36 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id k7-20020a170902ce0700b00163247b64bfsm2307536plg.115.2022.06.24.15.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 15:23:35 -0700 (PDT)
Date:   Fri, 24 Jun 2022 22:23:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v3 3/3] x86: Check platform vPMU capabilities before run
 lbr tests
Message-ID: <YrY5ZNGjyWhPJy1Z@google.com>
References: <20220624090828.62191-1-weijiang.yang@intel.com>
 <20220624090828.62191-4-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624090828.62191-4-weijiang.yang@intel.com>
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

On Fri, Jun 24, 2022, Yang Weijiang wrote:
> Use new helper to check whether pmu is available and Perfmon/Debug
> capbilities are supported before read MSR_IA32_PERF_CAPABILITIES to
> avoid test failure. The issue can be captured when enable_pmu=0.
> 
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  lib/x86/processor.h |  2 +-
>  x86/pmu_lbr.c       | 32 +++++++++++++-------------------
>  2 files changed, 14 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/x86/processor.h b/lib/x86/processor.h
> index 70b9193..bb917b0 100644
> --- a/lib/x86/processor.h
> +++ b/lib/x86/processor.h
> @@ -193,7 +193,7 @@ static inline bool is_intel(void)
>  #define X86_FEATURE_PAUSEFILTER     (CPUID(0x8000000A, 0, EDX, 10))
>  #define X86_FEATURE_PFTHRESHOLD     (CPUID(0x8000000A, 0, EDX, 12))
>  #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
> -
> +#define	X86_FEATURE_PDCM		(CPUID(0x1, 0, ECX, 15))

Please try to think critically about the code you're writing.  All of the existing
X86_FEATURE_* definitions are organized by leaf, sub-leaf, register _and_ bit
position.  And now there's X86_FEATURE_PDCM...
