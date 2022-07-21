Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F18957D5D8
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 23:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233777AbiGUVVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 17:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233713AbiGUVVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 17:21:22 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD2B9284A
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:21:21 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pc13so2714759pjb.4
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 14:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HcvxDrR9ZNqkme3R06VMLtgxH8qVXC5fmEIw/uDo9xs=;
        b=NOigE/lzv95Z5UN7qE1+2qSf6NyVJK3zPQzOt2C+FvK+DkpERBWxqnlUrQ0nJxZf8M
         xJJM5zod9Zk51mJCwzVbfPz4h2Dp1VdVOTqcnvxUC7DlhqZ1upVEVmRIDME0Kzkx8nxI
         IYR7M5ntovvDLxzR3jLt7Tq4DbiEUje6ALaaPqBqjgjfuKL6SPE0QMJMirmqMq2Sk7AU
         SDbU69ZWKtT7ZUQcC9QgIrfyBIRhkjH5ALfQDLet1YCFUR8W4he9biYWpuGRxlB7nQgR
         opfRIDxwtIp+tZZqmmJIM4l+ONK2m5ByMG82TRG780d+X3PjviGWzFApmHD83lQ913Qb
         kydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HcvxDrR9ZNqkme3R06VMLtgxH8qVXC5fmEIw/uDo9xs=;
        b=zpalWMjGyryc7g3hisNHWj/paO0BKX6lzL3wsf80fkxgOdWFrNAAn2Dg3525EBnjtN
         KMm4gRZz/1uUGQUgwXJvsrgmKc53DdEpErK8W7p/JSJE5xc0b6zwEMkU3vlIvgXHOE6x
         P4S72v33uflLtGIb4MTznoIjuW1Bl8JBzaxYL4TH5R0fYpzR5qj8oZik55/ys4w90eYl
         9PN/ypt+dzsz/GHT7I6nmtebPNhQLtKF32QmUAdxqjbg+05gsopKIFhHwKBlx/8aeFeO
         0CdZlNVDLReAfy4eUzkNHR3jpgXgocPKebIEmcDQxDjliZs10GPuj0I+TZe7mseBxZNb
         6p8A==
X-Gm-Message-State: AJIora8J1GYBHFnaDomGyj+kywQ9axqagU8gP9fMmTLwpkcFxmb5xyEK
        SwRtclSzgb0g7rGC0sd4ZcxAcg==
X-Google-Smtp-Source: AGRyM1sj1bCLL1e+NU8D7aGi5kc9KxhvJuvEpa12ecB3JpNGa6wDDNhk2RyJU8eZdlAiCxLVmwb3bQ==
X-Received: by 2002:a17:903:22d2:b0:16c:5575:d510 with SMTP id y18-20020a17090322d200b0016c5575d510mr222788plg.123.1658438481139;
        Thu, 21 Jul 2022 14:21:21 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id on1-20020a17090b1d0100b001f21646d1a4sm6909073pjb.1.2022.07.21.14.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 14:21:20 -0700 (PDT)
Date:   Thu, 21 Jul 2022 21:21:17 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/4] x86: Use helpers to fetch supported
 perf capabilities
Message-ID: <YtnDTQj72uoN2aj6@google.com>
References: <20220711041841.126648-1-weijiang.yang@intel.com>
 <20220711041841.126648-3-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711041841.126648-3-weijiang.yang@intel.com>
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

On Mon, Jul 11, 2022, Yang Weijiang wrote:
> -	eax.full = id.a;
> -	ebx.full = id.b;
> -	edx.full = id.d;
> +	eax.full = pmu_arch_info();
> +	ebx.full = pmu_gp_events();
> +	edx.full = pmu_fixed_counters();

Adding helpers for individual fields but then caching the full fields and
ignoring the helpers is silly.  It doesn't require much more work to get rid of
the unions entirely (see the pull request I sent to Paolo).
