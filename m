Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE14F5E6FC5
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 00:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiIVWfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 18:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiIVWfa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 18:35:30 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFB4CBACA
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:35:29 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id y11so11200498pjv.4
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 15:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=rK3/dlGa4rCcv+m0nXYz5jCboyd8Nm97QGQCHOltOyE=;
        b=a6VSOhmj6G0upAZNb4uNbz1Qfva4zEdxktlQ99mEIsyw/SitdVGkATNnanZvlc3jwa
         E4QbHXi9Ia8xAHtItU1eQynIPV/vzNtDeRGoO7thBr9UzqogQPHycj2FZPgBBVgV3Y2i
         LV91mT4qCFLYxavV0Cc9PYJK/0GCpuKm/xXcGJE502XzjBRZYL8FKeClXrf8tDj8PgYZ
         7p5gJAATmtguAOrauBy+r1/l9uiymEX8hHZCZ+5lObjDGM0aI9j8i26gRX7x/h5+rkCr
         hPaE3uu8gzi9y2Cw/hzOBrkqtc2EYueagGQi876C86kDRq4RKPIpTdXuujm0lhqr6Ipa
         /oFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=rK3/dlGa4rCcv+m0nXYz5jCboyd8Nm97QGQCHOltOyE=;
        b=b7G4CxQwl6H0zkkHxvFyolr80VOgfPjTmtNuOeZIrUVZWr0mzc724dOaKYAZAxoHVy
         m622TRx60sbmqRMEAfvtKHajJ0CEF21EYrz4hINQEQwK6ykq2YhhMr5kZTNuYbzswWJa
         t+RXAWZTCHeUFrRPgPAJcML1JyhZC01K9YoDaFJMscF51OKn4h0ex2Fj6sBDziWFv/kE
         OLiYYiePFkUlm/HTszeDx9U9p2QOMoY/CcCvXxCFYr23MTrDzwLFcdaHeL2FA4s80Obu
         nPlM5mqQah2gDXxvXDTybipU9pSSK6egfIG0CLUZTxnwDwg525Lk7AQeWIoQhtM5tcoD
         AEig==
X-Gm-Message-State: ACrzQf3Hbry9x7+PuSMr9TDYPy/2scQ3zo/ZT+1xnv7IizO8s82ZgbH/
        95MZ/WGoTr4qHtkPTvGKBhtbxA==
X-Google-Smtp-Source: AMsMyM7hbqqEeaSiLGMhQFTem4CLQi6aXE4MeNAJYWwSIfpdHvcdbsWjQT61TDNfZ6aUD31+N/Ln7g==
X-Received: by 2002:a17:902:6542:b0:172:95d8:a777 with SMTP id d2-20020a170902654200b0017295d8a777mr5543367pln.61.1663886129253;
        Thu, 22 Sep 2022 15:35:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id b23-20020a63cf57000000b00434651f9a96sm4236228pgj.15.2022.09.22.15.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 15:35:28 -0700 (PDT)
Date:   Thu, 22 Sep 2022 22:35:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/7] KVM: x86/pmu: Avoid using PEBS perf_events for
 normal counters
Message-ID: <YyzjLRbPahKP71uZ@google.com>
References: <20220831085328.45489-1-likexu@tencent.com>
 <20220831085328.45489-4-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831085328.45489-4-likexu@tencent.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Like Xu wrote:
> To address this issue, the reuse check has been revamped and KVM will

State what the patch does as a command, don't describe the effects in the past
tense.

> go back to do reprogram_counter() when any bit of guest PEBS_ENABLE
> msr has changed, which is similar to what global_ctrl_changed() does.

This managed to confuse the heck out of me.  I misread reprogram_counter() as
reprogram_counters() because that's what I see in the diff, and then got all
turned around because this patch also stealthily renames global_ctrl_changed() to
reprogram_counters().

This is a very good example of when splitting a refactor with a bug fix can help
tremendously, e.g. with the refactor moved to a separate patch, this fix becomes:

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 390d697efde1..d9b9a0f0db17 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -237,8 +237,8 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
                              get_sample_period(pmc, pmc->counter)))
                return false;
 
-       if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
-           pmc->perf_event->attr.precise_ip)
+       if (test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) !=
+           (!!pmc->perf_event->attr.precise_ip))
                return false;
 
        /* reuse perf_event to serve as pmc_reprogram_counter() does*/
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 5592b1259e1b..25b70a85bef5 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -431,7 +431,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
                if (pmu->pebs_enable == data)
                        return 0;
                if (!(data & pmu->pebs_enable_mask)) {
+                       diff = pmu->pebs_enable ^ data;
                        pmu->pebs_enable = data;
+                       reprogram_counters(pmu, diff);
                        return 0;
                }
                break;

which is much, much easier to describe and to follow.

TL;DR: I split this into two patches.

> Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---

...

> -/* function is called when global control register has been updated. */
> -static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
> +static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
