Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D918568322F
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 17:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbjAaQFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 11:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbjAaQFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 11:05:47 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78EB4C0CC
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:05:44 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id rm7-20020a17090b3ec700b0022c05558d22so14885258pjb.5
        for <kvm@vger.kernel.org>; Tue, 31 Jan 2023 08:05:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MjlaZ1brx6cAYmKlNK4M4epbvW624n39Y1rszG+o3s4=;
        b=cVPyB63IogoWDeVbq7B8bC+r2jTnL2y1By0jOmwvyDoW1/Ez3+NUxXBz/ymm/CMePo
         zQvyyyBCqz4w6rf8bAMGUNw8ImJ4Gslhl6d5foxFezXU2T7o3lPfMjfO3SFQJp67nDNU
         bj4Kq+NIIR3uTjkEpbjZlPK8xnKuX4gOdcn8uG2Y/KT/1CJkVjt2hXTbrBPEx8vT5/VV
         sPVztq3H1qn4rcgzn0HVeI2cDg57ywMH4CFv/GAfxDiKgw4nhxkzn7DurJ0gjp+seJeP
         1eWX3mefNXmFG/JlSJmyy4DsFHAjDY/84tH2aZMi0YHSNMuaDPsAoY7MuFOKWHTZPFj7
         ok8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MjlaZ1brx6cAYmKlNK4M4epbvW624n39Y1rszG+o3s4=;
        b=k+VSXVaI8APKHJpQHoTNAsMN8Ugw44Y7UtKhgMdoTWo+ylZ3lz2cWF5UYgWKWwM7Y3
         i9AVdbkuDgiksH1BGk0M9GMv8Mb1j9bbBYWus5XhMAaUR6Gu1qc93++6UOtzBppRdwLK
         DBExRVckgQqI1F0cP+47MMz15+k9kC3v67mLFDaBZ+1zEZ5ur4KeLZbIJFjsHtkh9/Js
         FJXwcu/N2gRZLTtHGHKDztZlrevg8iQeR1DF+kZPjcLQXNNp/4eZhxE/gMrVoiBLYTnX
         Deo8IVLH+ScU6YwfHg5j52Jf+OxBC+iRWhk8yar8H9cENzsSW2V9Ff4LelpryVSE8TrA
         9Izg==
X-Gm-Message-State: AO0yUKVxY8be9kXqS2o+KRkdQas84efUpUZQGds3EfvOkjjosjFEecA7
        MttNbYUDMeoScenr6Xr9FxQLuA==
X-Google-Smtp-Source: AK7set+/J8KP8hZdXkV+6i7ttIXxhcdcF570IYwJuNG35we9MAzoZhS3f8gtr09GGedU1+sFzPsIYA==
X-Received: by 2002:a17:902:ce92:b0:189:b910:c6d2 with SMTP id f18-20020a170902ce9200b00189b910c6d2mr1266475plg.1.1675181144002;
        Tue, 31 Jan 2023 08:05:44 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c11-20020a170902d48b00b001960706141fsm6192046plg.149.2023.01.31.08.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 08:05:43 -0800 (PST)
Date:   Tue, 31 Jan 2023 16:05:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "like.xu.linux@gmail.com" <like.xu.linux@gmail.com>,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>,
        "Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 14/15] KVM: x86: Add Arch LBR data MSR access interface
Message-ID: <Y9k8U/pzRWw3HbHp@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-15-weijiang.yang@intel.com>
 <Y9RMbq1FgygCPRrZ@google.com>
 <f70ea782-c7d4-0997-88e0-c24768fd02a9@intel.com>
 <Y9f+nDdnk8fHXRZe@google.com>
 <1ec9fa76-7758-b67f-1695-177a5a573d6d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ec9fa76-7758-b67f-1695-177a5a573d6d@intel.com>
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

On Tue, Jan 31, 2023, Yang, Weijiang wrote:
> 
> On 1/31/2023 1:30 AM, Sean Christopherson wrote:
> > On Mon, Jan 30, 2023, Yang, Weijiang wrote:
> > > On 1/28/2023 6:13 AM, Sean Christopherson wrote:
> > > > On Thu, Nov 24, 2022, Yang Weijiang wrote:
> > > > > Arch LBR MSRs are xsave-supported, but they're operated as "independent"
> > > > > xsave feature by PMU code, i.e., during thread/process context switch,
> > > > > the MSRs are saved/restored with perf_event_task_sched_{in|out} instead
> > > > > of generic kernel fpu switch code, i.e.,save_fpregs_to_fpstate() and
> > > > > restore_fpregs_from_fpstate(). When vcpu guest/host fpu state swap happens,
> > > > > Arch LBR MSRs are retained so they can be accessed directly.
> > > > > 
> > > > > Signed-off-by: Yang Weijiang<weijiang.yang@intel.com>
> > > > > Reviewed-by: Kan Liang<kan.liang@linux.intel.com>
> > > > > ---
> > > > >    arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
> > > > >    1 file changed, 10 insertions(+)
> > > > > 
> > > > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > > > index b57944d5e7d8..241128972776 100644
> > > > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > > > @@ -410,6 +410,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > > > >    			msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
> > > > >    		}
> > > > >    		return 0;
> > > > > +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
> > > > > +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
> > > > > +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
> > > > > +		rdmsrl(msr_info->index, msr_info->data);
> > > > I don't see how this is correct.  As called out in patch 5:
> > > > 
> > > >    : If for some magical reason it's safe to access arch LBR MSRs without disabling
> > > >    : IRQs and confirming perf event ownership, I want to see a very detailed changelog
> > > >    : explaining exactly how that magic works.
> > > The MSR lists here are just for live migration. When arch-lbr is active,
> > > these MSRs are passed through to guest.
> > None of that explains how the guest's MSR values are guaranteed to be resident
> > in hardware.
> 
> I ignored host *event* scheduling case in commit log.
> 
> My understanding is, host LBR *event* could break in at any point when the
> vCPU is running,
> 
> in this case disabling IRQs before read/write the MSRs is pointless because
> the HW context could have been swapped. I need to do more investigation for
> the issue.

Which is presumably why intel_pmu_handle_lbr_msrs_access() checks that the LBR
perf event is active prior to accessing the MSRs, with IRQs disabled...

	/*
	 * Disable irq to ensure the LBR feature doesn't get reclaimed by the
	 * host at the time the value is read from the msr, and this avoids the
	 * host LBR value to be leaked to the guest. If LBR has been reclaimed,
	 * return 0 on guest reads.
	 */
	local_irq_disable();
	if (lbr_desc->event->state == PERF_EVENT_STATE_ACTIVE) {
		if (read)
			rdmsrl(index, msr_info->data);
		else
			wrmsrl(index, msr_info->data);
		__set_bit(INTEL_PMC_IDX_FIXED_VLBR, vcpu_to_pmu(vcpu)->pmc_in_use);
		local_irq_enable();
		return true;
	}
	clear_bit(INTEL_PMC_IDX_FIXED_VLBR, vcpu_to_pmu(vcpu)->pmc_in_use);
	local_irq_enable();
