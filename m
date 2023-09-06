Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2F847944CF
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 22:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244429AbjIFUzU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 16:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236060AbjIFUzU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 16:55:20 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC8719BA
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 13:54:49 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1c1e128135aso2051125ad.3
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 13:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694033689; x=1694638489; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ol2GBlU6n5ThnYRqLO4P8cjzvJnj4evW3B0TXw5asCU=;
        b=5iDFGIwoHVCVqBVMVi1VG9nxppKPvHIMMPZbz4SpfVMgjbmqr6VjI9Q2wPNzkEV+uT
         SGWYC2i7Q96FcXB+0J4mBpwVVYNl6u8WHpQ/nhwQeRdM+NXKfj0rfD7ysfm5jOFQlrJA
         ZDq7wlQxWJJI3GT/A3zoFi/G/Lu5w73Iau3mwS/42S25ERPOR2EX5tfc0OOE9d+JiWcc
         nTuluAV6/X4RcxB0kKEuE7DapWYJVexoUNMSauZwe4zmmj9z+OVt1q+kJwYSQamt1Z3L
         8NJJwKrcwZsTPcacMCRFel4MkBWqUebD21u1LIrN9M8PWsi3JDq30CG+daLzssvxN00p
         SX8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694033689; x=1694638489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ol2GBlU6n5ThnYRqLO4P8cjzvJnj4evW3B0TXw5asCU=;
        b=Odjielq4yJ1MYz9f+agR5kaZHX6Vt425QCa9H2P0ZSfJy4ushwlXoPLGycWocjETzW
         kpmrexoGZT7gSSoYz38rxy9SRCixXbu5SNS875CEYWzwytOb2+3hlD1Qtc98p+Dv0B7J
         0RKMgeg5UqRvPEE6Xd0o18M/zzuEH2X8NA2D5XlIcIy1yBw3SbHheR8TjSir/lDBMyE7
         LSCyMvW4DqMLI1uB+39PT958GRtaRSDGUQ2oVjOnSAAMNKjZ34LEzb+VC4fsPD+zLMsm
         1Hrej/SIOpqZSeLIgLTJkWcFmjdKBCyY4ipTYIv2Nr0U+PoQM7iuu+oimevLoIiU/etl
         zuEA==
X-Gm-Message-State: AOJu0YyZtfWh+auJwSA98K6SK5WUZtDLciSOUqGOgMuMkz0kapHvZ65I
        Nct45n0IGfqnUMezPLUrj9musg==
X-Google-Smtp-Source: AGHT+IE11wz/OFcIE05X1OQ5IAdNGgBrteNAS/c8Oe7q0J3dAVA1IpImNILl32qOVYkUV+JLsntDnA==
X-Received: by 2002:a17:902:efcb:b0:1bf:2eab:dd4e with SMTP id ja11-20020a170902efcb00b001bf2eabdd4emr12640408plb.1.1694033688612;
        Wed, 06 Sep 2023 13:54:48 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id g12-20020a170902740c00b001bbdd44bbb6sm11407384pll.136.2023.09.06.13.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 13:54:47 -0700 (PDT)
Date:   Wed, 6 Sep 2023 20:54:43 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <likexu@tencent.com>, Roman Kagan <rkagan@amazon.de>,
        Kan Liang <kan.liang@intel.com>,
        Dapeng1 Mi <dapeng1.mi@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Synthesize at most one PMI per VM-exit
Message-ID: <ZPjnExoXOsqlfagD@google.com>
References: <20230901185646.2823254-1-jmattson@google.com>
 <8b964afb-4b8e-b8fb-542c-c76487340705@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b964afb-4b8e-b8fb-542c-c76487340705@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 06, 2023, Mi, Dapeng wrote:
> On 9/2/2023 2:56 AM, Jim Mattson wrote:
> > When the irq_work callback, kvm_pmi_trigger_fn(), is invoked during a
> > VM-exit that also invokes __kvm_perf_overflow() as a result of
> > instruction emulation, kvm_pmu_deliver_pmi() will be called twice
> > before the next VM-entry.
> 
> 
> Do we have a way to reproduce this spurious NMI error constantly?
> 
I think I shared with you in another thread. I also shared the event
list and command here:

https://lore.kernel.org/all/ZKCD30QrE5g9XGIh@google.com/

To observe the spurious NMIs, you can just continously look at the
NMIs/PMIs in /proc/interrupts and see if you have huge number within 2
minutes when running the above command in a 8-vcpu QEMU VM on Intel SPR
machine. Huge here means more than 10K.

In addition, you may observe the following warning from kernel dmesg:

[3939579.462832] Uhhuh. NMI received for unknown reason 30 on CPU 43.
[3939579.462836] Dazed and confused, but trying to continue

> 
> > 
> > That shouldn't be a problem. The local APIC is supposed to
> > automatically set the mask flag in LVTPC when it handles a PMI, so the
> > second PMI should be inhibited. However, KVM's local APIC emulation
> > fails to set the mask flag in LVTPC when it handles a PMI, so two PMIs
> > are delivered via the local APIC. In the common case, where LVTPC is
> > configured to deliver an NMI, the first NMI is vectored through the
> > guest IDT, and the second one is held pending. When the NMI handler
> > returns, the second NMI is vectored through the IDT. For Linux guests,
> > this results in the "dazed and confused" spurious NMI message.
> > 
> > Though the obvious fix is to set the mask flag in LVTPC when handling
> > a PMI, KVM's logic around synthesizing a PMI is unnecessarily
> > convoluted.
> > 
> > Remove the irq_work callback for synthesizing a PMI, and all of the
> > logic for invoking it. Instead, to prevent a vcpu from leaving C0 with
> > a PMI pending, add a check for KVM_REQ_PMI to kvm_vcpu_has_events().
> > 
> > Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >   arch/x86/include/asm/kvm_host.h |  1 -
> >   arch/x86/kvm/pmu.c              | 27 +--------------------------
> >   arch/x86/kvm/x86.c              |  3 +++
> >   3 files changed, 4 insertions(+), 27 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 3bc146dfd38d..f6b9e3ae08bf 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -528,7 +528,6 @@ struct kvm_pmu {
> >   	u64 raw_event_mask;
> >   	struct kvm_pmc gp_counters[KVM_INTEL_PMC_MAX_GENERIC];
> >   	struct kvm_pmc fixed_counters[KVM_PMC_MAX_FIXED];
> > -	struct irq_work irq_work;
> >   	/*
> >   	 * Overlay the bitmap with a 64-bit atomic so that all bits can be
> > diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
> > index bf653df86112..0c117cd24077 100644
> > --- a/arch/x86/kvm/pmu.c
> > +++ b/arch/x86/kvm/pmu.c
> > @@ -93,14 +93,6 @@ void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops)
> >   #undef __KVM_X86_PMU_OP
> >   }
> > -static void kvm_pmi_trigger_fn(struct irq_work *irq_work)
> > -{
> > -	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
> > -	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
> > -
> > -	kvm_pmu_deliver_pmi(vcpu);
> > -}
> > -
> >   static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
> >   {
> >   	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
> > @@ -124,20 +116,7 @@ static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
> >   		__set_bit(pmc->idx, (unsigned long *)&pmu->global_status);
> >   	}
> > -	if (!pmc->intr || skip_pmi)
> > -		return;
> > -
> > -	/*
> > -	 * Inject PMI. If vcpu was in a guest mode during NMI PMI
> > -	 * can be ejected on a guest mode re-entry. Otherwise we can't
> > -	 * be sure that vcpu wasn't executing hlt instruction at the
> > -	 * time of vmexit and is not going to re-enter guest mode until
> > -	 * woken up. So we should wake it, but this is impossible from
> > -	 * NMI context. Do it from irq work instead.
> > -	 */
> > -	if (in_pmi && !kvm_handling_nmi_from_guest(pmc->vcpu))
> > -		irq_work_queue(&pmc_to_pmu(pmc)->irq_work);
> > -	else
> > +	if (pmc->intr && !skip_pmi)
> >   		kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> >   }
> > @@ -677,9 +656,6 @@ void kvm_pmu_refresh(struct kvm_vcpu *vcpu)
> >   void kvm_pmu_reset(struct kvm_vcpu *vcpu)
> >   {
> > -	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
> > -
> > -	irq_work_sync(&pmu->irq_work);
> >   	static_call(kvm_x86_pmu_reset)(vcpu);
> >   }
> > @@ -689,7 +665,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
> >   	memset(pmu, 0, sizeof(*pmu));
> >   	static_call(kvm_x86_pmu_init)(vcpu);
> > -	init_irq_work(&pmu->irq_work, kvm_pmi_trigger_fn);
> >   	pmu->event_count = 0;
> >   	pmu->need_cleanup = false;
> >   	kvm_pmu_refresh(vcpu);
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index c381770bcbf1..0732c09fbd2d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12841,6 +12841,9 @@ static inline bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
> >   		return true;
> >   #endif
> > +	if (kvm_test_request(KVM_REQ_PMI, vcpu))
> > +		return true;
> > +
> >   	if (kvm_arch_interrupt_allowed(vcpu) &&
> >   	    (kvm_cpu_has_interrupt(vcpu) ||
> >   	    kvm_guest_apic_has_interrupt(vcpu)))
