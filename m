Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B2F618B82
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 23:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbiKCW3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 18:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiKCW3R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 18:29:17 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80ED22BF8
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 15:29:16 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id 4so3314665pli.0
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 15:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5roKd3dzGljHrTZvorPWCF+JnKyRC7p9CZ4elbqwas=;
        b=pHPBzIRvTuEp0FZBJVItXCZLfqGBJQwIcLzR2QNu8yL7ebm+whm2cDwsH/YtJpliw9
         B6DTqI/0aBUanj1d6O5dwRiBetSIt5eGLqn7IM34rZP+VAAfiCcx5y2d9kk/yVeAWjhc
         3nruwBTl9RtMWF9Vv/mh0Go+d2gUsKAzvSn6rkSMX02VTMviqdaX+5rj6XRONthFJ8JR
         PTK9aLM+J/3dILPlwT0BkONm5lJVAKcCvx/KQD7B3weXUBINGyKCS9szfCPvfessx4PY
         OxMbF3z3iHtTJpnScF/levjuR/Y+aGT6UX9drY4++/YYQpxCSBEOL1OUTEWgAuIjOT3T
         xG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5roKd3dzGljHrTZvorPWCF+JnKyRC7p9CZ4elbqwas=;
        b=01E9o48XIey71YTrJTf5U30URvraZcDmx0iX+WbU4vAOF+W1/8+kwl+Uqynm02hAkf
         WNay4vQVyd40wuMemj28y+8BylHzmtHg55oJZF63yJFaRc9mVGRLcSgfAUWpT4Yla9tO
         Ije6ZxkIH5jc7TYm21nWgvZPQPsYbUdOVWqS7vMauqP8mo8v2GSXziif3c4JylhD/p6l
         EMOQa8nMtsPdq1YsfeOSLeqkKht1QYVZtOmZ1U2YstIKHPdUMhgzSsJ6r113KDdJkBOJ
         xmB+EnCU5hGdtCWp26FkpKdQecEf1nD3iebGREZ5YiE2fy/uuGGLaeLYq0gtZZAbplGD
         ndvg==
X-Gm-Message-State: ACrzQf2ZZyZzTL39TGetmtV9/ml6j8xxR9Ew3Nh8Qoi0WKFk592WeeoH
        +8+UqxX5Uq2JP8ylRA6KzM9Urw==
X-Google-Smtp-Source: AMsMyM5XBQErr9M7P4rDwdOZA08fzkCaolPvHx8BfJ4JTLlPYAx98QUGHOSRtac8whnFwDM1FZK1wA==
X-Received: by 2002:a17:902:eccc:b0:186:5f09:f9 with SMTP id a12-20020a170902eccc00b001865f0900f9mr32251529plh.6.1667514556220;
        Thu, 03 Nov 2022 15:29:16 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x3-20020a170902ea8300b00176ab6a0d5fsm1192465plb.54.2022.11.03.15.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 15:29:15 -0700 (PDT)
Date:   Thu, 3 Nov 2022 22:29:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH] KVM: x86: Omit PMU MSRs from KVM_GET_MSR_INDEX_LIST if
 !enable_pmu
Message-ID: <Y2RAuO9Si74/sW1y@google.com>
References: <20221103191733.3153803-1-aaronlewis@google.com>
 <CALMp9eTjJHMhQGDmbn2WYdcaFLWMvtQjWN4pTUMRXTAnBwj6jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTjJHMhQGDmbn2WYdcaFLWMvtQjWN4pTUMRXTAnBwj6jQ@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03, 2022, Jim Mattson wrote:
> On Thu, Nov 3, 2022 at 12:18 PM Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > When the PMU is disabled, don't bother sharing the PMU MSRs with
> > userspace through KVM_GET_MSR_INDEX_LIST.  Instead, filter them out so
> > userspace doesn't have to keep track of them.
> >
> > Note that 'enable_pmu' is read-only, so userspace has no control over
> > whether the PMU MSRs are included in the list or not.
> >
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> >  arch/x86/kvm/x86.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 521b433f978c..19bc42a6946d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -7042,13 +7042,20 @@ static void kvm_init_msr_list(void)
> >                                 continue;
> >                         break;
> >                 case MSR_ARCH_PERFMON_PERFCTR0 ... MSR_ARCH_PERFMON_PERFCTR0 + 17:
> > -                       if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> > -                           min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
> > +                       if ((msrs_to_save_all[i] - MSR_ARCH_PERFMON_PERFCTR0 >=
> > +                           min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp)) ||
> > +                           !enable_pmu)
> >                                 continue;
> >                         break;
> >                 case MSR_ARCH_PERFMON_EVENTSEL0 ... MSR_ARCH_PERFMON_EVENTSEL0 + 17:
> > -                       if (msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> > -                           min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp))
> > +                       if ((msrs_to_save_all[i] - MSR_ARCH_PERFMON_EVENTSEL0 >=
> > +                           min(INTEL_PMC_MAX_GENERIC, kvm_pmu_cap.num_counters_gp)) ||
> > +                           !enable_pmu)
> > +                               continue;
> > +                       break;
> > +               case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
> > +               case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
> > +                       if (!enable_pmu)
> >                                 continue;
> >                         break;
> >                 case MSR_IA32_XFD:
> 
> I think you've missed a bunch:
> 
> MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
> MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
> MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
> MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> MSR_IA32_PEBS_ENABLE, MSR_PEBS_DATA_CFG

Ooh, better idea!  Assuming this isn't a pressing concern, what about organizing
the MSR lists into sublists, kinda like what I proposed for VMX MSRs[*], but do
it in a generic way.  E.g. have all the PMU MSRs in a sub-list so that they can
be skipped as a group instead of needing to add a bunch of enable_pmu checks.

[*] https://lore.kernel.org/all/20220805172945.35412-3-seanjc@google.com
