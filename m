Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F615A1640
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 18:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbiHYP77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 11:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242571AbiHYP75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 11:59:57 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16028D86
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:59:55 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id w29so14650246pfj.3
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 08:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=s14gyQJTvsj4UP8jOneFH7XrwLl5hvF+f+/gI4nwvs8=;
        b=nDpy5bAsLMhMmxeaP0eBSG7fSwbg7YyPoAJU7/MYosac9TE/FUJnuSNkYI+ypQU0C+
         DXId/TBG4A3MTTAWaCAHOgJ4c5biuK2s0dxkPC7fVEbJbL0g03DrUN3TUQmaj62eeJMW
         DwfMxQfxE//DopQC6lrZEUY15SZ7bn+UAwOoMbNmgTQOiNKWeO9jn5Zg7FNqipRbxhkQ
         mtq1dfyDbB8/Cg/7aRzXFwXsRSZq2J3TMgoIJULIyhEtP/JLOC36KlJH6A236Yb7Xerj
         YCwHNzWBglYw4L/cRlnai38LTO9SfVjxdwNLcyad+7fxx+g2QBDDscJHxO2HpTpRlriW
         b3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=s14gyQJTvsj4UP8jOneFH7XrwLl5hvF+f+/gI4nwvs8=;
        b=EAnfDl4hzTNy0Ey2SjPlr8nr+NSP+N4MMO9Vj/5VeZhYgXt8R1HKleYbTxTf3gxLiK
         YBcEmMbdp96FkDQllnZp7UMCI08XTgHhv5dO1Mp0Kh0u8KvX7md9BDhSXt/AsYltH2M/
         BykStJWeC7nPPfcAQLdeJmd8LVpZXKQ+GMERwce6dvsCpCMl2TXakhxZi8Y5dNCAbAcw
         BxN7xPeR/dvJP6uJiBTJygrOToE9Dhq6xQTp1SJwKkZnt2FCR4l9s1DNQX3w/OmYpSve
         RYEjtfjqO0GjI9XCa1RunfFxVtZJ2mas315rlqrMbqN+SLI46B9GPBIYuxXZymw0zbkG
         2w1Q==
X-Gm-Message-State: ACgBeo0AT7MEYlsaBLS6gfxNcrckMCEf7GhfRP0+VXoIezFaxxeplhEh
        tpC2caS3XfW3jy5VjrpQLr+RYw==
X-Google-Smtp-Source: AA6agR53+X4iJjyIst/MvZeCs6bFcq/30Y8XnjLHDEcSSfwImuoicfydBTS9d7CVYRGjZH3XZ/ERaA==
X-Received: by 2002:a05:6a00:4acc:b0:536:46c4:d084 with SMTP id ds12-20020a056a004acc00b0053646c4d084mr4569426pfb.71.1661443194448;
        Thu, 25 Aug 2022 08:59:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a20-20020a62d414000000b00535e6dbda16sm14630083pfh.35.2022.08.25.08.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 08:59:54 -0700 (PDT)
Date:   Thu, 25 Aug 2022 15:59:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] KVM: VMX: Stop/resume host PT before/after VM
 entry when PT_MODE_HOST_GUEST
Message-ID: <YwecducnM/U6tqJT@google.com>
References: <20220825085625.867763-1-xiaoyao.li@intel.com>
 <20220825085625.867763-3-xiaoyao.li@intel.com>
 <YweWmF3wMPRnthIh@google.com>
 <6bcab33b-3fde-d470-88b9-7667c7dc4b2d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bcab33b-3fde-d470-88b9-7667c7dc4b2d@intel.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022, Xiaoyao Li wrote:
> On 8/25/2022 11:34 PM, Sean Christopherson wrote:
> > On Thu, Aug 25, 2022, Xiaoyao Li wrote:
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index d7f8331d6f7e..3e9ce8f600d2 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -38,6 +38,7 @@
> > >   #include <asm/fpu/api.h>
> > >   #include <asm/fpu/xstate.h>
> > >   #include <asm/idtentry.h>
> > > +#include <asm/intel_pt.h>
> > >   #include <asm/io.h>
> > >   #include <asm/irq_remapping.h>
> > >   #include <asm/kexec.h>
> > > @@ -1128,13 +1129,19 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
> > >   	if (vmx_pt_mode_is_system())
> > >   		return;
> > > +	/*
> > > +	 * Stop Intel PT on host to avoid vm-entry failure since
> > > +	 * VM_ENTRY_LOAD_IA32_RTIT_CTL is set
> > > +	 */
> > > +	intel_pt_stop();
> > > +
> > >   	/*
> > >   	 * GUEST_IA32_RTIT_CTL is already set in the VMCS.
> > >   	 * Save host state before VM entry.
> > >   	 */
> > >   	rdmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
> > 
> > KVM's manual save/restore of MSR_IA32_RTIT_CTL should be dropped.
> 
> No. It cannot. Please see below.
> 
> > If PT/RTIT can
> > trace post-VMXON, then intel_pt_stop() will disable tracing and intel_pt_resume()
> > will restore the host's desired value.
> 
> intel_pt_stop() and intel_pt_resume() touches host's RTIT_CTL only when host
> enables/uses Intel PT. Otherwise, they're just noop. In this case, we cannot
> assume host's RTIT_CTL is zero (only the RTIT_CTL.TraceEn is 0). After
> VM-exit, RTIT_CTL is cleared, we need to restore it.

But ensuring the RTIT_CTL.TraceEn=0 is all that's needed to make VM-Entry happy,
and if the host isn't using Intel PT, what do we care if other bits that, for all
intents and purposes are ignored, are lost across VM-Entry/VM-Exit?  I gotta
imaging the perf will fully initialize RTIT_CTL if it starts using PT.

Actually, if the host isn't actively using Intel PT, can KVM avoid saving the
other RTIT MSRs?

Even better, can we hand that off to perf?  I really dislike KVM making assumptions
about perf's internal behavior.  E.g. can this be made to look like

	intel_pt_guest_enter(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);

and

	intel_pt_guest_exit(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);

> > >   	if (vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN) {
> > > -		wrmsrl(MSR_IA32_RTIT_CTL, 0);
> > > +		/* intel_pt_stop() ensures RTIT_CTL.TraceEn is zero */
> > >   		pt_save_msr(&vmx->pt_desc.host, vmx->pt_desc.num_address_ranges);
> > 
> > Isn't this at risk of the same corruption?  What prevents a PT NMI that arrives
> > after this point from changing other RTIT MSRs, thus causing KVM to restore the
> > wrong values?
> 
> intel_pt_stop() -> pt_event_stop() will do
> 
> 	WRITE_ONCE(pt->handle_nmi, 0);
> 
> which ensure PT NMI handler as noop that at the beginning of
> intel_pt_interrupt():
> 
> 	if (!READ_ONCE(pt->handle_nmi))
> 		return;

Ah, right.  

> 
> > >   		pt_load_msr(&vmx->pt_desc.guest, vmx->pt_desc.num_address_ranges);
> > >   	}
> > > @@ -1156,6 +1163,8 @@ static void pt_guest_exit(struct vcpu_vmx *vmx)
> > >   	 */
> > >   	if (vmx->pt_desc.host.ctl)
> > >   		wrmsrl(MSR_IA32_RTIT_CTL, vmx->pt_desc.host.ctl);
> > > +
> > > +	intel_pt_resume();
> > >   }
> > >   void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
> > > -- 
> > > 2.27.0
> > > 
> 
