Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDE6A58A445
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 02:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbiHEAnE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 20:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiHEAnD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 20:43:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32816FA14
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 17:43:01 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so1412171pjl.0
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 17:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=9mS3Mfp0zzPbmPwS38oCb4X04tayRN9CYkrMdbYGE5E=;
        b=D/FkG3LtGVX1BhSpXaY+N4t4c2oajJR+xg3uzLJo6L5ejr94qD0YJf0weZ3BX2Br34
         X8ng0cxEN92dhDgChFs2idfjW1PM4dZLDcWBqemsadDwQsfbvxrcfeZULYO22uouBolu
         1fxZqJJEKA88NEvl3jk9Yql53B+73MAc1sz1USKkDlopEtyY84gj4flJbvpHPIUhQ9LE
         fUjJsnk6GyK5I06s/MVmBSgjcYKEQtUXRtttMVyLQg/ADVz/QocB3TzGesG2RMolneL/
         mI+OXGTrs0bewC8EMAJvW3QWp8tbUG5778Zow9YxFb6Ly+2GboBE+hXq5ek17q2mpQFp
         y0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=9mS3Mfp0zzPbmPwS38oCb4X04tayRN9CYkrMdbYGE5E=;
        b=ns9AdwVrc4QLrcBCjRzsEULVKC1UAR+tUAURgsuOdCafUc5pOm2MHrApQXvICjw5aF
         PZtWSTlXsAObvfWKvK6Qczgditlqby+tqoddGYkaG0DyhcOe5Q+lhInbZaQjX4g+F0X1
         e7KuRONFUYhCed2Uuf/yni/lY4b0Q5Oj4DaLZUPqAut+R0BG2a1yr+7Yj0GiOAPuR5Xg
         cYOWATPy4o6LFCPqeTRZaUBh+W+LlddHto240XottNPRPdA77K8rtx4JHmavyBBPt9As
         tTWep+R4BfpENK21BSCa3RKsEg7hCgCg8pSXBuebC3ED7IJ4vx/7FYaLX770G184zSvD
         UedA==
X-Gm-Message-State: ACgBeo3d1LUGJ11NEIg/vamh/e928OBJQcxpFgc0v6e3E5G8SmB1tqle
        8ysxF6g9qLu6DFUEMORT/axmOw==
X-Google-Smtp-Source: AA6agR7crwU6fs5zp1rQ2HaxgIEoz0hMjGBBxbDxp23/BNVlcC056/nC99ZFfbBfvylYxEU0IYcX4A==
X-Received: by 2002:a17:903:40c3:b0:16f:1d75:6f47 with SMTP id t3-20020a17090340c300b0016f1d756f47mr4218200pld.159.1659660180827;
        Thu, 04 Aug 2022 17:43:00 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id 4-20020a620504000000b0052d90512a53sm1631171pff.44.2022.08.04.17.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 17:43:00 -0700 (PDT)
Date:   Thu, 4 Aug 2022 17:42:56 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andrew.jones@linux.dev, maz@kernel.org, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v2 1/3] arm: pmu: Add missing isb()'s
 after sys register writing
Message-ID: <YuxnkI4ADEcVnCPA@google.com>
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-2-ricarkol@google.com>
 <YuuJZf9QPW5p/sbx@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuuJZf9QPW5p/sbx@monolith.localdoman>
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

On Thu, Aug 04, 2022 at 09:55:01AM +0100, Alexandru Elisei wrote:
> Hi,
> 
> On Wed, Aug 03, 2022 at 11:23:26AM -0700, Ricardo Koller wrote:
> > There are various pmu tests that require an isb() between enabling
> > counting and the actual counting. This can lead to count registers
> > reporting less events than expected; the actual enabling happens after
> > some events have happened.  For example, some missing isb()'s in the
> > pmu-sw-incr test lead to the following errors on bare-metal:
> > 
> > 	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
> > 	PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
> > 	FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
> > 	FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
> > 	INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
> > 	PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
> > 	SUMMARY: 4 tests, 2 unexpected failures
> > 
> > Add the missing isb()'s on all failing tests, plus some others that seem
> > required:
> > - after clearing the overflow signal in the IRQ handler to avoid
> >   spurious interrupts.
> 
> Nitpick, but it doesn't avoid (eliminates) spurious interrupts, it makes
> them less likely.
> 
> > - after direct writes to PMSWINC_EL0 for software to read the correct
> >   value for PMEVNCTR0_EL0 (from ARM DDI 0487H.a, page D13-5237).
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 15c542a2..76156f78 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > [..]
> > @@ -821,10 +832,13 @@ static void test_overflow_interrupt(void)
> >  	report(expect_interrupts(0), "no overflow interrupt after preset");
> >  
> >  	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> > +	isb();
> > +
> >  	for (i = 0; i < 100; i++)
> >  		write_sysreg(0x2, pmswinc_el0);
> >  
> >  	set_pmcr(pmu.pmcr_ro);
> > +	isb();
> 
> A context synchronization event affects system register writes that come
> before the context synchronization event in program order, but if there are
> multiple system register writes, it doesn't perform them in program order
> (if that makes sense).

Good point, didn't think of that case. Added the missing isb() in v3.

Thanks,
Ricardo

> 
> So it might happen that the CPU decides to perform the write to PMCR_EL1
> which disables the PMU *before* the writes to PMSWINC_EL0. Which means that
> even if PMINTENSET_EL1 allows the PMU to assert interrupts when it
> shouldn't (thus causing the test to fail), those interrupt won't be
> asserted by the PMU because the PMU is disabled and the test would pass.
> 
> You need an ISB after the PMSWINC_EL0 writes and before disabling the PMU.
> 
> Thanks,
> Alex
> 
> >  	report(expect_interrupts(0), "no overflow interrupt after counting");
