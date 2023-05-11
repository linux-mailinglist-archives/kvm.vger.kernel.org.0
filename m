Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4B26FFB39
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 22:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239298AbjEKUY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 16:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238381AbjEKUYy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 16:24:54 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E889270D;
        Thu, 11 May 2023 13:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=E5l2shnH01QrTljpAFFGCJicO6JUqqgyxvzlIMkP6A0=; b=eszcc0bs0lf/dqVDO8eQ4oUVkU
        cMqG0k06X+5D5Liq1lzWonVEHUZhG+C4fHoBAx0b2kIHABcyMm6+cnaOofe8PHLUvnloriwFbxFoV
        Yqem1gFhi9OYmna/FWqs44k/rS2+x6h8vxkpOaqvEyZ6z9ng2JWTiy+HodorH5wmvv7WM0YTRAVUy
        qPTYmsTBy69OorstP119zRNMNMdRXh9iAua0LPGy+eE2xLKjO0XL4HM5sgiM3D/O7OzRWPVxpdQKv
        x6jrzvogksLb37T9oN2EKWjffwa5kV/zWypFMtC+VxyMR+i4uabOkU0shVvaJEjBXed5+1s03gDUT
        qFxpBLLQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pxCpO-008NaG-2j;
        Thu, 11 May 2023 20:23:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B76C1300244;
        Thu, 11 May 2023 22:23:51 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9F2A32C7C5BE0; Thu, 11 May 2023 22:23:51 +0200 (CEST)
Date:   Thu, 11 May 2023 22:23:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Michael Kelley <mikelley@microsoft.com>, ltykernel@gmail.com,
        bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com, rafael@kernel.org,
        longman@redhat.com, boqun.feng@gmail.com, pmladek@suse.com,
        senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH 7/9] x86/tsc: Provide sched_clock_noinstr()
Message-ID: <20230511202351.GE2296992@hirez.programming.kicks-ass.net>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.853677542@infradead.org>
 <20230508214419.GA2053935@hirez.programming.kicks-ass.net>
 <ZFmGI1EN24xroPHa@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFmGI1EN24xroPHa@liuwe-devbox-debian-v2>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023 at 11:30:43PM +0000, Wei Liu wrote:
> On Mon, May 08, 2023 at 11:44:19PM +0200, Peter Zijlstra wrote:
> > On Mon, May 08, 2023 at 11:19:58PM +0200, Peter Zijlstra wrote:
> > 
> > > --- a/drivers/clocksource/hyperv_timer.c
> > > +++ b/drivers/clocksource/hyperv_timer.c
> > > @@ -408,9 +408,9 @@ static u64 notrace read_hv_clock_tsc_cs(
> > >  	return read_hv_clock_tsc();
> > >  }
> > >  
> > > -static u64 notrace read_hv_sched_clock_tsc(void)
> > > +static u64 noinstr read_hv_sched_clock_tsc(void)
> > >  {
> > > -	return (read_hv_clock_tsc() - hv_sched_clock_offset) *
> > > +	return (hv_read_tsc_page(hv_get_tsc_page()) - hv_sched_clock_offset) *
> > >  		(NSEC_PER_SEC / HV_CLOCK_HZ);
> > >  }
> > >  
> > > --- a/include/clocksource/hyperv_timer.h
> > > +++ b/include/clocksource/hyperv_timer.h
> > > @@ -38,7 +38,7 @@ extern void hv_remap_tsc_clocksource(voi
> > >  extern unsigned long hv_get_tsc_pfn(void);
> > >  extern struct ms_hyperv_tsc_page *hv_get_tsc_page(void);
> > >  
> > > -static inline notrace u64
> > > +static __always_inline notrace u64
> > >  hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg, u64 *cur_tsc)
> > >  {
> > >  	u64 scale, offset;
> > > @@ -85,7 +85,7 @@ hv_read_tsc_page_tsc(const struct ms_hyp
> > >  	return mul_u64_u64_shr(*cur_tsc, scale, 64) + offset;
> > >  }
> > >  
> > > -static inline notrace u64
> > > +static __always_inline notrace u64
> > >  hv_read_tsc_page(const struct ms_hyperv_tsc_page *tsc_pg)
> > >  {
> > >  	u64 cur_tsc;
> > 
> > Hyper-V folks!
> > 
> > While reviewing all this I found the following 'gem':
> > 
> > hv_init_clocksource()
> >   hv_setup_sched_clock()
> >     paravirt_set_sched_clock(read_hv_sched_clock_msr)
> > 
> > read_hv_sched_clock_msr() [notrace]
> >   read_hv_clock_msr()     [notrace]
> >     hv_get_register()      *traced*
> >       hv_get_non_nested_register() ...
> >         hv_ghcb_msr_read()
> > 	  WARN_ON(in_nmi())
> > 	  ...
> > 	  local_irq_save()
> > 
> > 
> > Note that:
> > 
> >  a) sched_clock() is used in NMI context a *LOT*
> >  b) sched_clock() is notrace (or even noinstr with these patches)
> >     and local_irq_save() implies tracing
> > 
> 
> Tianyu and Michael, what's your thought on this?
> 
> Is the MSR-based GHCB usable at this point?
> 
> What other clock source can be used?

You do have TSC support -- which is what I fixed for you. It's just the
whole MSR thing that is comically broken.

You could do a read_hv_clock_msr() implementation using
__rdmsr() and add some sanity checking that anything GHCB using (SEV?)
*will* use TSC.

Anyway, will you guys do that, or should I pull out the chainsaw and fix
it for you?
