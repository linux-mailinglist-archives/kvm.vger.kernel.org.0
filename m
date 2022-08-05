Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C30758A447
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 02:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiHEAnt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 20:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbiHEAns (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 20:43:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B026FA1F
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 17:43:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t22so1314680pjy.1
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 17:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=kQ7XLNd19T2F/0Kyxgg6JcVUt8GKc+lVKttADwvo10Q=;
        b=o0Hz+1us5VA/Xhi2yrNBqIcOm+c2QYyK5BWs6G7ju17Z1xRI2ewGwz2Q9XJtRUF1zI
         Tzj/J2JNyfa2khkGo5FfEUEAsA8I0Z2HQJuAKT9xkogEOxLB29p+ZSy9p8yf46n56PIt
         7UocWMSPRjNZ8qxr2eY+J5og7iYRzL1PMU9BXE4K6/2EC2TQ9PdexzJCiMDM0mK2GW1E
         Q/xZL/iJTN4y4BxeNKN5S3PnV7PTBqpdJSYqJvzEMg453k4owZx+PUTbYpVadsQGo53/
         9Z5U1BolH3ioIGPN2GX97vUuCHkFoh2LLp5V9WbilWzFNXpn9ij9QC9tlGZ/oPIoGBXH
         Driw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=kQ7XLNd19T2F/0Kyxgg6JcVUt8GKc+lVKttADwvo10Q=;
        b=JcF28PrUzK1D3004ZhojIESy0XY/S7/85GOyyp7QFQihy/8jwSHeS+XEWyRgdzIPi/
         esu6VlxK3MqImAa8P2eL6+tLNojtojllZthFe0exMYQPMBlIF18LhRb6l8KbNtgeTQMV
         51p6AR3uwQAjVMPEQsun6Yiya2f6BZ1WxrnKPexoVPRNv3jc0Wbm2HyEeh6hLO5uPKGf
         BF47Ml5di6tNP1OHNnB/Uqc20vuooG7GOG2Na0ihyJJZVehN/VfbAl/bliyzyAHGXxKE
         IbQTKKnqiuQ1gzv4V4c9KzgnbF07e0tloLEctFIRFBe5ybFeGBQd7/CQwgIpJaTopZAb
         dFZA==
X-Gm-Message-State: ACgBeo0O5Aqvmrkf32HKpyeFhQR4RBbFn9v2rAvye1NReXwxbzsZ497P
        vDsAXJ2/gVE6pPZ974IkPzuoSQ==
X-Google-Smtp-Source: AA6agR5vOF22By5G4B3O1K1orZI72z0z2GBJLPw9nu+X+0JSKcaaDQwhjARKOHGymwsC0NrtMgfaDw==
X-Received: by 2002:a17:90a:4291:b0:1f2:2a19:fc95 with SMTP id p17-20020a17090a429100b001f22a19fc95mr13151051pjg.29.1659660226053;
        Thu, 04 Aug 2022 17:43:46 -0700 (PDT)
Received: from google.com (220.181.82.34.bc.googleusercontent.com. [34.82.181.220])
        by smtp.gmail.com with ESMTPSA id ij29-20020a170902ab5d00b0016dc6243bb2sm1557217plb.143.2022.08.04.17.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 17:43:45 -0700 (PDT)
Date:   Thu, 4 Aug 2022 17:43:41 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        alexandru.elisei@arm.com, eric.auger@redhat.com,
        oliver.upton@linux.dev, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v2 3/3] arm: pmu: Check for overflow in
 the low counter in chained counters tests
Message-ID: <YuxnvTT9EATgTY22@google.com>
References: <20220803182328.2438598-1-ricarkol@google.com>
 <20220803182328.2438598-4-ricarkol@google.com>
 <20220804081832.3pyn7nospfdekbz3@kamzik>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220804081832.3pyn7nospfdekbz3@kamzik>
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

On Thu, Aug 04, 2022 at 10:18:32AM +0200, Andrew Jones wrote:
> On Wed, Aug 03, 2022 at 11:23:28AM -0700, Ricardo Koller wrote:
> > A chained event overflowing on the low counter can set the overflow flag
> > in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
> > Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
> > (DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
> > overflow.
> > 
> > The pmu chain tests fail on bare metal when checking the overflow flag
> > of the low counter _not_ being set on overflow.  Fix by checking for
> > overflow. Note that this test fails in KVM without the respective fix.
> > 
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  arm/pmu.c | 33 ++++++++++++++++++---------------
> >  1 file changed, 18 insertions(+), 15 deletions(-)
> > 
> > diff --git a/arm/pmu.c b/arm/pmu.c
> > index 7c5bc259..258780f4 100644
> > --- a/arm/pmu.c
> > +++ b/arm/pmu.c
> > @@ -583,7 +583,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  
> >  	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
> > -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
> > +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #1");
> >  
> >  	/* test 64b overflow */
> >  
> > @@ -595,7 +595,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> >  	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
> > -	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
> > +	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
> >  
> >  	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
> >  	write_regn_el0(pmevcntr, 1, ALL_SET);
> > @@ -603,7 +603,7 @@ static void test_chained_counters(void)
> >  	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
> >  	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> >  	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
> > -	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
> > +	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
> >  }
> >  
> >  static void test_chained_sw_incr(void)
> > @@ -629,8 +629,9 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > -	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
> > -		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> > +	report((read_sysreg(pmovsclr_el0) == 0x1) &&
> > +		(read_regn_el0(pmevcntr, 1) == 1),
> > +		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
> >  	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
> >  		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
> >  
> > @@ -648,10 +649,10 @@ static void test_chained_sw_incr(void)
> >  		write_sysreg(0x1, pmswinc_el0);
> >  
> >  	isb();
> > -	report((read_sysreg(pmovsclr_el0) == 0x2) &&
> > +	report((read_sysreg(pmovsclr_el0) == 0x3) &&
> >  		(read_regn_el0(pmevcntr, 1) == 0) &&
> >  		(read_regn_el0(pmevcntr, 0) == 84),
> > -		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
> > +		"overflow on even and odd counters,  and expected values after 100 SW_INCR/CHAIN");
> 
> Besides the extra space, this doesn't read well (to me).

Replaced the sentence with something simpler and hopefully nicer (in v3).

Thanks,
Ricardo

> 
> Thanks,
> drew
