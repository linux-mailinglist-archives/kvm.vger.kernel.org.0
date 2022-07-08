Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7937956BD57
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 18:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238536AbiGHP52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 11:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238878AbiGHP5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 11:57:20 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594857435C
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 08:57:16 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id bf13so9645495pgb.11
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 08:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BUQQx0dJ/n8uKfupk6kp7f/sUkdarp1GLkk1tnlVSBY=;
        b=Vl3k9+d0sp5+4kJbhmNJ5y/L6xhpGCzFkbLS+wxpzvlLqFHxhwwsEPJrX17kTYmC02
         uItaEbxFDVyqDIYKCR3tF+geEHiI7VYOLAb2pmcCwP+4DGos/O9C2mRImknnYU8mDKSO
         8bHgCx6ORqBIJq4PwCga5LnrV20tHZDeGSke2yUeWs4HiWQufwq7peaQBfm+OJktlX1E
         8EMGUe51M/SedensFHbwbJhJjAhmD7Ia/A6guzem7YuE2X5YLAwKbf9ztcMvFywg6cEz
         bLDCO73whmni/K1F2im/Nguw9OKo8IZMkTms6unsiH1/A/xWB2Y0s8xyhF+dbgU1TGTB
         /t/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BUQQx0dJ/n8uKfupk6kp7f/sUkdarp1GLkk1tnlVSBY=;
        b=DmzXNzpq6R3uPZtqbTwHGi4QwKD0m6lukT3o/WIXxlEFQABqd94RA4nl2cs/TkH0Ta
         BVxEPImvBekIEJeJTDaMZyt0UbWk5w7FJ3Re68Z/fCbQ9OJHR1JMiHMQavG8g3VWoD5J
         mn0XO5qhjUAuZBlK8iuWyp22iYPeq3Nxoy3fIwiHqJxAdZ9kGLMAnkgXsRrAnPH7B9yA
         D9Sc+ju3s0eYoRhUmp4wcUTLktMW0FCICuGyZ3qeFcX6C3d/s0N+GwwyQphPM40o0QEK
         6kgXhL65E+ISKZlUEFeaGyTG7d6BW3tTz3VW4UKrzgAWkCR31QWqRohDkT3n62w8u///
         xpgQ==
X-Gm-Message-State: AJIora9vYB06Z1F3hLSyqnrPT0R2NcGqo6BHhh94RyMwkBl2nUjAV/QR
        fyRiT/HKu2EX4pAwAw+tt13VEg==
X-Google-Smtp-Source: AGRyM1uZ+5ixBiV0vC0hqQLKQiXX1rOtpkXgaGdgXMa9Fn6j2NU9ZcMsP7WkerLLpLiWI9rWSafqMw==
X-Received: by 2002:a05:6a00:1687:b0:518:6c6b:6a9a with SMTP id k7-20020a056a00168700b005186c6b6a9amr4401458pfc.81.1657295835761;
        Fri, 08 Jul 2022 08:57:15 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s10-20020a170902ea0a00b0016c1efb9195sm2210955plg.298.2022.07.08.08.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 08:57:15 -0700 (PDT)
Date:   Fri, 8 Jul 2022 15:57:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 3/3] x86: Check platform vPMU
 capabilities before run lbr tests
Message-ID: <YshT2I8/lb8oU1a5@google.com>
References: <20220708051119.124100-1-weijiang.yang@intel.com>
 <20220708051119.124100-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220708051119.124100-3-weijiang.yang@intel.com>
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

On Fri, Jul 08, 2022, Yang Weijiang wrote:
> Use new helper to check whether pmu is available and Perfmon/Debug
> capbilities are supported before read MSR_IA32_PERF_CAPABILITIES to
> avoid test failure. The issue can be captured when enable_pmu=0.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> 
> ---
> 
> v5:
>  Use new helpers to check pmu availability and get pmu version.[Sean]
> 
>  lib/x86/processor.h |  1 +
>  x86/pmu_lbr.c       | 31 ++++++++++++-------------------

What about x86/pmu.c?  It has pretty much all the same issues.

> @@ -74,19 +62,24 @@ int main(int ac, char **av)
>  		return 0;
>  	}
>  
> -	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> -	eax.full = id.a;
> -
> -	if (!eax.split.version_id) {
> +	if (!cpu_has_pmu()) {
>  		printf("No pmu is detected!\n");

Please opportunistically switch these to report_skip() (and drop the \n), or fix
them in patch 1 too.  Either way is fine.  And obviously use report_skip() for
the new PDCM check.
