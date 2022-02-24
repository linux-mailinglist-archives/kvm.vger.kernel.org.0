Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38F4C35C3
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 20:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiBXTW3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 14:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232571AbiBXTW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 14:22:28 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DD4522E0
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:21:54 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id q4so2586913ilt.0
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 11:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dlxbBhjVxgATP0KM5oNG0LzdCfA40MUHrDIe/INdi68=;
        b=NYOdpm1bR56HSGohn/sRm5A66fRUWCpyofnOGctj1Y7ae7i9UeuP70P/+ILbsYGshn
         g4CwQLakXJ7vlyBMwxLrvT6z/s1hnpRc/M+qijG4uaLuozRkQ7rglS5G25Lb7vEEW3fx
         79iYlHvvkRS2gTK0O3vXFMqYmF1B8mjqRa9jETuLcu4PalAreDBoVpmPKOZ59Jb7VSWr
         xyxFkKFJ3nUb/YTG8zk8spMQvhsp4Iiz3Sp6WdQoYEpuypYRa23kod5z0BrhLeH5pBG7
         bYHrKwcQ6CwTqdOo19gGMZNyZeTd7zVuSXiIdG5lSR5k/TCUKojup/YE6KCIhw4tVyVR
         4x3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dlxbBhjVxgATP0KM5oNG0LzdCfA40MUHrDIe/INdi68=;
        b=EyX7KygGO9UKN75ZNNKb/9sX+B/A73Do/4iIv6gAoE2uwV4V2fGAVG7Sh8x5KRIqAb
         x641TaE+Sxo7mRTKR6lQc9K1xzNP75c9a4geLjil2nBovcjfbFG7HL7u8oecqN//KnxD
         P6KysBnF1v5fwetaUHYGu/R89gMDATnb5AMsGxJgi2+zNMpZgdjdKHYEYTYoz3bm545/
         rs1UlW4P55zKwpA5cNTNUQXHuLWmsF2OXwR0i6HYlQA2+3zfoK0snF7z9R0+kAEDCgmf
         EfUXNqhEalCox47/yp6KrjuEyNGO13wANYKsIPBF6mwGze/B6q9Nf8aoiAxcCLewJwnn
         b68w==
X-Gm-Message-State: AOAM533E59hRvYs1gCipp+38a5J7QyrNa3iVJlSRTstNSEUVPYtyR6yE
        bv85pnyz2fqDE0PBFuhQYllCaw==
X-Google-Smtp-Source: ABdhPJwn7IgJZMEfgRQOCW+UbgVEsAFzikAr2Dh30XA4U2P9oW3FIDdVTPHHiCobPFdhZhWNF/zmHg==
X-Received: by 2002:a05:6e02:1bc5:b0:2c2:7bc9:8e8f with SMTP id x5-20020a056e021bc500b002c27bc98e8fmr3548686ilv.5.1645730514046;
        Thu, 24 Feb 2022 11:21:54 -0800 (PST)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id k10-20020a6b7e4a000000b00640a8142cbdsm289173ioq.49.2022.02.24.11.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 11:21:53 -0800 (PST)
Date:   Thu, 24 Feb 2022 19:21:50 +0000
From:   Oliver Upton <oupton@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Peter Shier <pshier@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v3 03/19] KVM: arm64: Reject invalid addresses for CPU_ON
 PSCI call
Message-ID: <YhfaztgV0GHzyh24@google.com>
References: <20220223041844.3984439-1-oupton@google.com>
 <20220223041844.3984439-4-oupton@google.com>
 <87zgmg30qu.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgmg30qu.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On Thu, Feb 24, 2022 at 12:30:49PM +0000, Marc Zyngier wrote:
> On Wed, 23 Feb 2022 04:18:28 +0000,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > DEN0022D.b 5.6.2 "Caller responsibilities" states that a PSCI
> > implementation may return INVALID_ADDRESS for the CPU_ON call if the
> > provided entry address is known to be invalid. There is an additional
> > caveat to this rule. Prior to PSCI v1.0, the INVALID_PARAMETERS error
> > is returned instead. Check the guest's PSCI version and return the
> > appropriate error if the IPA is invalid.
> > 
> > Reported-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/arm64/kvm/psci.c | 24 ++++++++++++++++++++++--
> >  1 file changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> > index a0c10c11f40e..de1cf554929d 100644
> > --- a/arch/arm64/kvm/psci.c
> > +++ b/arch/arm64/kvm/psci.c
> > @@ -12,6 +12,7 @@
> >  
> >  #include <asm/cputype.h>
> >  #include <asm/kvm_emulate.h>
> > +#include <asm/kvm_mmu.h>
> >  
> >  #include <kvm/arm_psci.h>
> >  #include <kvm/arm_hypercalls.h>
> > @@ -70,12 +71,31 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
> >  	struct vcpu_reset_state *reset_state;
> >  	struct kvm *kvm = source_vcpu->kvm;
> >  	struct kvm_vcpu *vcpu = NULL;
> > -	unsigned long cpu_id;
> > +	unsigned long cpu_id, entry_addr;
> >  
> >  	cpu_id = smccc_get_arg1(source_vcpu);
> >  	if (!kvm_psci_valid_affinity(source_vcpu, cpu_id))
> >  		return PSCI_RET_INVALID_PARAMS;
> >  
> > +	/*
> > +	 * Basic sanity check: ensure the requested entry address actually
> > +	 * exists within the guest's address space.
> > +	 */
> > +	entry_addr = smccc_get_arg2(source_vcpu);
> > +	if (!kvm_ipa_valid(kvm, entry_addr)) {
> > +
> > +		/*
> > +		 * Before PSCI v1.0, the INVALID_PARAMETERS error is returned
> > +		 * instead of INVALID_ADDRESS.
> > +		 *
> > +		 * For more details, see ARM DEN0022D.b 5.6 "CPU_ON".
> > +		 */
> > +		if (kvm_psci_version(source_vcpu) < KVM_ARM_PSCI_1_0)
> > +			return PSCI_RET_INVALID_PARAMS;
> > +		else
> > +			return PSCI_RET_INVALID_ADDRESS;
> > +	}
> > +
> 
> If you're concerned with this, should you also check for the PC
> alignment, or the presence of a memslot covering the address you are
> branching to?  Le latter is particularly hard to implement reliably.

Andrew, Reiji and I had a conversation regarding exactly this on the
last run of this series, and concluded that checking against the IPA is
probably the best KVM can do [1]. That said, alignment is also an easy
thing to check.

> So far, my position has been that the guest is free to shoot itself in
> the foot if that's what it wants to do, and that babysitting it was a
> waste of useful bits! ;-)
>

Agreed -- there are plenty of spectacular/hilarious ways in which the
guest can mess up :-)

> Or have you identified something that makes it a requirement to handle
> this case (and possibly others)  in the hypervisor?

It is a lot easier to tell a guest that their software is broken if they
get an error back from the hypercall, whereas a vCPU off in the weeds
might need to be looked at before concluding there's a guest issue.


[1]: http://lore.kernel.org/r/20211005190153.dc2befzcisvznxq5@gator.home

--
Oliver
