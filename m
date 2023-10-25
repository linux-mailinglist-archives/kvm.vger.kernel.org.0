Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34FC87D78DA
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 01:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbjJYXrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 19:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjJYXrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 19:47:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1ECD181
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 16:47:06 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1c9a1762b43so2086195ad.1
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 16:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698277626; x=1698882426; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PMB1/GiQQTIiJZvhsIYCOx0hg6B4h+aKw9KU6MvpDV8=;
        b=jA8Dh2H7kf7WYv5hEd0Zf8QXun8YSMiXadvBIJ2uwqhPkeVZsPj7oE8TzQFYKVwn33
         +ydsVe35YzcxvYNNEzJW6gibvBELfSFTd1EB4H/J65ni3gDXt8OdJuwYntTeLv/8mecD
         w6v6Ds9dMyAKXJ26YbG1RAxDJTbiNMcVWtVuQy4S/TD/5IB/N39Uog3B5qnlRlK+bCH0
         NP2zveLVNlwWrwU5D1vKBBVr+ANTigHIx6tPATiNQiNFJ9Z7DkMrAhbJ/yjUoqCTiPCO
         PLiIdFStz8WA5t5Qiwtq40jG+J9fOTTID+IkUhm9ZXUSRJhbsKjgp9jO7H0ng5a2B1d9
         A99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698277626; x=1698882426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PMB1/GiQQTIiJZvhsIYCOx0hg6B4h+aKw9KU6MvpDV8=;
        b=lY2Wl9SG3XP+8zWHxvqeRNHKEZW9y39iAObk294aZzXAvk5h5f2FAeN82vLvZjzq1L
         vF88EPzUqU4Nuw1p52ep4vcAAt+5BYESXjWAVWlCW1N0VnDr/xU35rqMfOc89jaJHXh9
         CVfZ2xbqfc3d6FaKMErG+5PID+lJikzcVgABKfe8ixtzx5HAic0ijUBswvltOBSD6UbZ
         JdqSLyKWUNHPCjUnn+LrWINZnc3B4X0bdrt2Cr8Tw62eA+B/3JnhCtk0EgMsd5ldmyFZ
         qHmFghNjVG0JNqmBlS1hksFWIU1iw/nI6r/Wmyye93qktYh0EZWJ5LCWGPU9MKwjx9H4
         2fRw==
X-Gm-Message-State: AOJu0YzBSEKHiZXQqdCo8DfERUjTx+jKyZQVjU4zQpGb5irxgfQfDbjL
        jdFP253BZDnKD3KB2S9Mcky5VQ==
X-Google-Smtp-Source: AGHT+IFC+sfzXdin+SwOZnQG/WZCrvMbxnLbGN16wolfDypkoWF5rGlWg0STSpBFiVa7RzS4eO/Tvw==
X-Received: by 2002:a17:903:84c:b0:1ca:1be4:bda4 with SMTP id ks12-20020a170903084c00b001ca1be4bda4mr15202511plb.4.1698277625873;
        Wed, 25 Oct 2023 16:47:05 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id u14-20020a170902e5ce00b001c61901ed2esm9651662plf.219.2023.10.25.16.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 16:47:05 -0700 (PDT)
Date:   Wed, 25 Oct 2023 23:47:00 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [kvm-unit-tests Patch 0/5] Fix PMU test failures on Sapphire
 Rapids
Message-ID: <ZTmo9IVM2Tq6ZSrn@google.com>
References: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024075748.1675382-1-dapeng1.mi@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023, Dapeng Mi wrote:
> When running pmu test on Intel Sapphire Rapids, we found several
> failures are encountered, such as "llc misses" failure, "all counters"
> failure and "fixed counter 3" failure.

hmm, I have tested your series on a SPR machine. It looks like, all "llc
misses" already pass on my side. "all counters" always fail with/without
your patches. "fixed counter 3" never exists... I have "fixed
cntr-{0,1,2}" and "fixed-{0,1,2}"

You may want to double check the requirements of your series. Not just
under your setting without explainning those setting in detail.

Maybe what I am missing is your topdown series? So, before your topdown
series checked in. I don't see value in this series.

Thanks.
-Mingwei
> 
> Intel Sapphire Rapids introduces new fixed counter 3, total PMU counters
> including GP and fixed counters increase to 12 and also optimizes cache
> subsystem. All these changes make the original assumptions in pmu test
> unavailable any more on Sapphire Rapids. Patches 2-4 fixes these
> failures, patch 0 remove the duplicate code and patch 5 adds assert to
> ensure predefine fixed events are matched with HW fixed counters.
> 
> Dapeng Mi (4):
>   x86: pmu: Change the minimum value of llc_misses event to 0
>   x86: pmu: Enlarge cnt array length to 64 in check_counters_many()
>   x86: pmu: Support validation for Intel PMU fixed counter 3
>   x86: pmu: Add asserts to warn inconsistent fixed events and counters
> 
> Xiong Zhang (1):
>   x86: pmu: Remove duplicate code in pmu_init()
> 
>  lib/x86/pmu.c |  5 -----
>  x86/pmu.c     | 17 ++++++++++++-----
>  2 files changed, 12 insertions(+), 10 deletions(-)
> 
> 
> base-commit: bfe5d7d0e14c8199d134df84d6ae8487a9772c48
> -- 
> 2.34.1
> 
