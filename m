Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E35C72B04A
	for <lists+kvm@lfdr.de>; Sun, 11 Jun 2023 06:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbjFKEyk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jun 2023 00:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjFKEyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 11 Jun 2023 00:54:38 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167EE26B0
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 21:54:37 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1b1fdab9d68so121415ad.0
        for <kvm@vger.kernel.org>; Sat, 10 Jun 2023 21:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686459276; x=1689051276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGa8I8r39uYp/NeP+8qZmnK0pbR6JWhYdAPpxPmIMDc=;
        b=uYt89iXhhEib7GqEuR5EHa/NeVwTkUkIm26meR8UzTbxWQbY4ix0JjjhqPR5BKfOxt
         BnyeePPNYqdC6B9hTY1r9WazRn2jnYZMYnUblgJ5TDFkS0gqnvKZKDiEnMOdtx7CoUCF
         bTWnRAIdO4qDwvW+nFtS4VUSu0DETvmZdo91lzTkIOPU8oCnm/bGUCfD9sburBHmyN4M
         Jcyoqee7BlNQ5eTlj6mFKXS2UkWGPHCmGr4EkNZPMoalVM9vLL13RjvlTwgh+MpU+EUK
         9l5Us8EESYvu+wUPpFMEWyjElBOSNBwh1RPsyKrhjklGVjaKJkxAG0UF5e+JziyzZcYb
         5Eng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686459276; x=1689051276;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGa8I8r39uYp/NeP+8qZmnK0pbR6JWhYdAPpxPmIMDc=;
        b=BSlJSdwEQYXR9Rwc5c+MuwIuyvOm0/4k7hOYObrIzDpSL3tR88d7uLNfuxMMCe0OLJ
         o9K6BudGyAJdibIKlFNEKjgiJ0AnOUm3gZ5NZZlolsqb3+efHY7mZEaneBBSKgrzSprn
         4wrwuZoC7T8Ver0r8jKBKpQVbPYdu+nXE+/GqpqU6P7is4tbjcjFOd7AoZBJhKD1BkB8
         3YvCtndT+qBv2xxbHsv6aL1BiGytYXBr7Pa8OF2oVJT1oR7flKYOVF3+iuLSeIRmg9xD
         QmHO3ggIhTft9j79Lerz3JKDLAjAIK7MqrRAZFuqBFJl8Fm2es0pnxYpjPiJyHcXeoDM
         k4GQ==
X-Gm-Message-State: AC+VfDzQvxyJ6MGgkXfFi+VJeCLfSVWvXlCbJVZIy9Ej1/76LYup7iF9
        NpeJsHFn95HJ+P6GeoeGALMLaA==
X-Google-Smtp-Source: ACHHUZ6BtDR7b7stKHZFsPSnhcoH3dPsCYRD+I/7/gRGGnPx9h/rt0rYoC1Pn8qnQ7j3MBOBcVd+qA==
X-Received: by 2002:a17:903:230c:b0:1ac:6a6f:2dc2 with SMTP id d12-20020a170903230c00b001ac6a6f2dc2mr128758plh.6.1686459276058;
        Sat, 10 Jun 2023 21:54:36 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id ja11-20020a170902efcb00b001a9bcedd598sm335313plb.11.2023.06.10.21.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 21:54:34 -0700 (PDT)
Date:   Sat, 10 Jun 2023 21:54:30 -0700
From:   Reiji Watanabe <reijiw@google.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH 1/1] KVM: arm64: PMU: Avoid inappropriate use of host's
 PMUVer
Message-ID: <20230611045430.evkcp4py4yuw5qgr@google.com>
References: <20230610194510.4146549-1-reijiw@google.com>
 <ZIUb/ozyloOm6DfY@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZIUb/ozyloOm6DfY@linux.dev>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Oliver,

On Sat, Jun 10, 2023 at 05:57:34PM -0700, Oliver Upton wrote:
> Hi Reiji,
> 
> On Sat, Jun 10, 2023 at 12:45:10PM -0700, Reiji Watanabe wrote:
> > @@ -735,7 +736,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
> >  		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
> >  		 * as RAZ
> >  		 */
> > -		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P4)
> > +		if (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P4)
> >  			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
> 
> I don't think this conditional masking is correct in the first place,

I'm not sure why this conditional masking is correct.
Could you please elaborate ?


> and this change would only make it worse.
> 
> We emulate reads of PMCEID1_EL0 using the literal value of the CPU. The
> _advertised_ PMU version has no bearing on the core PMU version. So,
> assuming we hit this on a v3p5+ part with userspace (stupidly)
> advertising an older implementation level, we never clear the bit for
> STALL_SLOT.

I'm not sure if I understand this comment correctly.
When the guest's PMUVer is older than v3p4, I don't think we need
to clear the bit for STALL_SLOT, as PMMIR_EL1 is not implemented
for the guest (PMMIR_EL1 is implemented only on v3p4 or newer).
Or am I missing something ?

BTW, as KVM doesn't expose vPMU to the guest on non-uniform PMUVer
systems (as the sanitized value of ID_AA64DFR0_EL1.PMUVer on such
systems is zero), it is unlikely that the guest on such systems will
read this register (KVM should inject UNDEFINED in this case,
although KVM doesn't do that).


> 
> So let's just fix the issue by unconditionally masking the bit.
> 
> >  		base = 32;
> >  	}
> > @@ -932,11 +933,17 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> >  		return 0;
> >  	}
> >  	case KVM_ARM_VCPU_PMU_V3_FILTER: {
> > +		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
> >  		struct kvm_pmu_event_filter __user *uaddr;
> >  		struct kvm_pmu_event_filter filter;
> >  		int nr_events;
> >  
> > -		nr_events = kvm_pmu_event_mask(kvm) + 1;
> > +		/*
> > +		 * Allow userspace to specify an event filter for the entire
> > +		 * event range supported by PMUVer of the hardware, rather
> > +		 * than the guest's PMUVer for KVM backward compatibility.
> > +		 */
> > +		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
> 
> This is a rather signifcant change from the existing behavior though,
> no?
> 
> The 'raw' PMU version of the selected instance has been used as the
> basis of the maximum event list, but this uses the sanitised value. I'd
> rather we consistently use the selected PMU instance as the basis for
> all guest-facing PMU emulation.
> 
> I get that asymmetry in this deparment is exceedingly rare in the wild,
> but I'd rather keep a consistent model in the PMU emulation code where
> all our logic is based on the selected PMU instance.

Oh, sorry, I forget to update this from the previous (slightly different)
series [1], where kvm_arm_pmu_get_pmuver_limit() returned
kvm->arch.arm_pmu->pmuver.  Although the sanitized value will always be
the same as kvm->arch.arm_pmu->pmuver with the series [2], I don't meant
to change this in this patch.

[1] https://lore.kernel.org/all/20230527040236.1875860-1-reijiw@google.com/
[2] https://lore.kernel.org/all/20230610061520.3026530-1-reijiw@google.com/

Thank you,
Reiji
