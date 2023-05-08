Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D4B6FBB6F
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 01:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233831AbjEHXay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 19:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjEHXax (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 19:30:53 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 899964C1F;
        Mon,  8 May 2023 16:30:51 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1aafa03f541so50866335ad.0;
        Mon, 08 May 2023 16:30:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683588646; x=1686180646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NWxWshApja0U0iHBNlsacIgsAdM0MyD6OFNDBR0TtQw=;
        b=IzLBkalk10UYJRHbcvJG4FDrPexD91OQn3RH12DbW9q+8Pwfa+GgVwBtjGHUORnPbn
         RohXlJHd63t1c54UlWzN/JozEybtgV9vUE9OPXF7SMpAhP42DqYsvI1gh887hNU8xwEc
         0MD9S6HswMr7DZfEj7RQTo4iFpa8orlzLcAboUThFoPOnmfCayn+7+91QABLIe2OaKYN
         YPvuI3QPL28A2HHSV9Gj2vL7ofXNRsiE257rcw+ede932eqP7RHlRnSX2og5Igw/0vbw
         rMXijtJWsSWQwvkYwHJxq53BfdcZ4OVoeiYRvR3jbPE7hvW4PIaSVA2TSDGs0KoksUF2
         Y2qQ==
X-Gm-Message-State: AC+VfDzJGojeTxY9NvpnCzvPqUo9vDJsRhzXHbgQ63Q6PQi4DhLJVVX2
        zEZc6kS5SrhwcVdgJpU2clg=
X-Google-Smtp-Source: ACHHUZ5KJ4FNkdOABPorvJcHaGbZpI6LNA96wccpsa7XLg8qzH5+GC1t9zf3JxwP2V/DQj2I5E7UKA==
X-Received: by 2002:a17:902:ec88:b0:1aa:fbaa:ee09 with SMTP id x8-20020a170902ec8800b001aafbaaee09mr16421433plg.49.1683588646241;
        Mon, 08 May 2023 16:30:46 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([20.69.120.36])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902820100b0019e60c645b1sm6760pln.305.2023.05.08.16.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 16:30:45 -0700 (PDT)
Date:   Mon, 8 May 2023 23:30:43 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>,
        Michael Kelley <mikelley@microsoft.com>, ltykernel@gmail.com
Cc:     bigeasy@linutronix.de, mark.rutland@arm.com, maz@kernel.org,
        catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
        kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
        agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, longman@redhat.com, boqun.feng@gmail.com,
        pmladek@suse.com, senozhatsky@chromium.org, rostedt@goodmis.org,
        john.ogness@linutronix.de, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, jstultz@google.com, sboyd@kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC][PATCH 7/9] x86/tsc: Provide sched_clock_noinstr()
Message-ID: <ZFmGI1EN24xroPHa@liuwe-devbox-debian-v2>
References: <20230508211951.901961964@infradead.org>
 <20230508213147.853677542@infradead.org>
 <20230508214419.GA2053935@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230508214419.GA2053935@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023 at 11:44:19PM +0200, Peter Zijlstra wrote:
> On Mon, May 08, 2023 at 11:19:58PM +0200, Peter Zijlstra wrote:
> 
> > --- a/drivers/clocksource/hyperv_timer.c
> > +++ b/drivers/clocksource/hyperv_timer.c
> > @@ -408,9 +408,9 @@ static u64 notrace read_hv_clock_tsc_cs(
> >  	return read_hv_clock_tsc();
> >  }
> >  
> > -static u64 notrace read_hv_sched_clock_tsc(void)
> > +static u64 noinstr read_hv_sched_clock_tsc(void)
> >  {
> > -	return (read_hv_clock_tsc() - hv_sched_clock_offset) *
> > +	return (hv_read_tsc_page(hv_get_tsc_page()) - hv_sched_clock_offset) *
> >  		(NSEC_PER_SEC / HV_CLOCK_HZ);
> >  }
> >  
> > --- a/include/clocksource/hyperv_timer.h
> > +++ b/include/clocksource/hyperv_timer.h
> > @@ -38,7 +38,7 @@ extern void hv_remap_tsc_clocksource(voi
> >  extern unsigned long hv_get_tsc_pfn(void);
> >  extern struct ms_hyperv_tsc_page *hv_get_tsc_page(void);
> >  
> > -static inline notrace u64
> > +static __always_inline notrace u64
> >  hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg, u64 *cur_tsc)
> >  {
> >  	u64 scale, offset;
> > @@ -85,7 +85,7 @@ hv_read_tsc_page_tsc(const struct ms_hyp
> >  	return mul_u64_u64_shr(*cur_tsc, scale, 64) + offset;
> >  }
> >  
> > -static inline notrace u64
> > +static __always_inline notrace u64
> >  hv_read_tsc_page(const struct ms_hyperv_tsc_page *tsc_pg)
> >  {
> >  	u64 cur_tsc;
> 
> Hyper-V folks!
> 
> While reviewing all this I found the following 'gem':
> 
> hv_init_clocksource()
>   hv_setup_sched_clock()
>     paravirt_set_sched_clock(read_hv_sched_clock_msr)
> 
> read_hv_sched_clock_msr() [notrace]
>   read_hv_clock_msr()     [notrace]
>     hv_get_register()      *traced*
>       hv_get_non_nested_register() ...
>         hv_ghcb_msr_read()
> 	  WARN_ON(in_nmi())
> 	  ...
> 	  local_irq_save()
> 
> 
> Note that:
> 
>  a) sched_clock() is used in NMI context a *LOT*
>  b) sched_clock() is notrace (or even noinstr with these patches)
>     and local_irq_save() implies tracing
> 

Tianyu and Michael, what's your thought on this?

Is the MSR-based GHCB usable at this point?

What other clock source can be used?

Thanks,
Wei.

> 
> Can you pretty please:
> 
>  1) delete all this; or,
>  2) fix it in a hurry?
> 
> Thanks!
