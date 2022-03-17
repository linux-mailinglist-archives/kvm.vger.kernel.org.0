Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F914DBF0B
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 07:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiCQGOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 02:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiCQGFz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 02:05:55 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785DA18179A
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 22:37:38 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id o12so3037198ilg.5
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 22:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eOhA5o/rv2hDIRWbKN8H2klxdoKowJwEzyK4YFjI0Ok=;
        b=eeGjN5mJoNpfj5kKLs04Hxp8X5XHrjfeLPZrK1GmJPCRupkJZf477uJa/kOmtzy0ah
         YpIQBOMEEmnBPa2QqUCDk2hxy905PuK7tGHlm1nA8Diqbj8GpX8QcZehpprTbs1pc8zy
         gJ1O4s1tdr7D6LqnHE/pWm8PcUef5DhVZRSRXlk+gFupMitoIzsVDFACkBPdNGwXgbtT
         RaAmW2zB98eSXT7Mdyna2gbwqUpFp/Y1Hmehe7Zel/0BoWXMFW80r2wjeAxZeohqY2SR
         Ie5vR9drsGClueifPs5p0dbl+q8ZPjbwfHuvP2SwJIZhjdFQuXamj1plYXStripntCBf
         /WFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eOhA5o/rv2hDIRWbKN8H2klxdoKowJwEzyK4YFjI0Ok=;
        b=RX3A0//SAJhRrbN9nWiDWWqhxINAFgF/b6+ArVBWKoVMqt3XxkHU9ctTnL8L81iWTE
         s745bAb36UP2azVsAkJNgbB4QqqGSWkvTzFIOLsROuQD4RN1XaDZwAUW/OyaAe75K3Iq
         ikWx9PbF5oUx4eDxZkcW61eqdZbtRTBiNYWmdsCZnkAsLtJXuxB1Fl8JZe/Uwj4GOD/l
         L35V3NvwPn/XDBYacP1g2G1alYSfRoQf22YinDEEhFD7iZoI5OboSksxH9VcZ7K9GTvl
         PvdjaPgNG2zkX0i2nEVeq2kZhfrpjTwgKilnbPQ3uUfqSyEepvaVXo6d7hPb5gHuDNRA
         6hpA==
X-Gm-Message-State: AOAM532EAdIMZrdbyHIiqGoZMggb8JIRTDCF5KiW5FVEDmhPhxxHlIHY
        j2Kl7sv3EQAWGowylVxVZ88kGA==
X-Google-Smtp-Source: ABdhPJy6LallOZSL7cqSmQyF4OC2oFoWT6AOIFXJUadLeyXNHu1TKa02/s52DyymredH2yAh2eCM5g==
X-Received: by 2002:a05:6e02:1aa6:b0:2c7:769e:8403 with SMTP id l6-20020a056e021aa600b002c7769e8403mr1226693ilv.49.1647495457228;
        Wed, 16 Mar 2022 22:37:37 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id i3-20020a056602134300b0064620a85b6dsm2177542iov.12.2022.03.16.22.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 22:37:36 -0700 (PDT)
Date:   Thu, 17 Mar 2022 05:37:32 +0000
From:   Oliver Upton <oupton@google.com>
To:     Jing Zhang <jingzhangos@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v1 2/2] KVM: arm64: Add debug tracepoint for vcpu exits
Message-ID: <YjLJHDV58GRMxF2P@google.com>
References: <20220317005630.3666572-1-jingzhangos@google.com>
 <20220317005630.3666572-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317005630.3666572-3-jingzhangos@google.com>
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

Hi Jing,

On Thu, Mar 17, 2022 at 12:56:30AM +0000, Jing Zhang wrote:
> This tracepoint only provides a hook for poking vcpu exits information,
> not exported to tracefs.
> A timestamp is added for the last vcpu exit, which would be useful for
> analysis for vcpu exits.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 3 +++
>  arch/arm64/kvm/arm.c              | 2 ++
>  arch/arm64/kvm/trace_arm.h        | 8 ++++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index daa68b053bdc..576f2c18d008 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -415,6 +415,9 @@ struct kvm_vcpu_arch {
>  
>  	/* Arch specific exit reason */
>  	enum arm_exit_reason exit_reason;
> +
> +	/* Timestamp for the last vcpu exit */
> +	u64 last_exit_time;
>  };
>  
>  /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index f49ebdd9c990..98631f79c182 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -783,6 +783,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  	ret = 1;
>  	run->exit_reason = KVM_EXIT_UNKNOWN;
>  	while (ret > 0) {
> +		trace_kvm_vcpu_exits(vcpu);
>  		/*
>  		 * Check conditions before entering the guest
>  		 */
> @@ -898,6 +899,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>  		local_irq_enable();
>  
>  		trace_kvm_exit(ret, kvm_vcpu_trap_get_class(vcpu), *vcpu_pc(vcpu));
> +		vcpu->arch.last_exit_time = ktime_to_ns(ktime_get());
>  
>  		/* Exit types that need handling before we can be preempted */
>  		handle_exit_early(vcpu, ret);
> diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
> index 33e4e7dd2719..3e7dfd640e23 100644
> --- a/arch/arm64/kvm/trace_arm.h
> +++ b/arch/arm64/kvm/trace_arm.h
> @@ -301,6 +301,14 @@ TRACE_EVENT(kvm_timer_emulate,
>  		  __entry->timer_idx, __entry->should_fire)
>  );
>  
> +/*
> + * Following tracepoints are not exported in tracefs and provide hooking
> + * mechanisms only for testing and debugging purposes.
> + */
> +DECLARE_TRACE(kvm_vcpu_exits,
> +	TP_PROTO(struct kvm_vcpu *vcpu),
> +	TP_ARGS(vcpu));
> +

When we were discussing this earlier, I wasn't aware of the kvm_exit
tracepoint which I think encapsulates what you're looking for.
ESR_EL2.EC is the critical piece to determine what caused the exit.

It is probably also important to call out that this trace point only
will fire for a 'full' KVM exit (i.e. out of hyp and back to the
kernel). There are several instances where the exit is handled in hyp
and we immediately resume the guest.

Now -- I am bordering on clueless with tracepoints, but it isn't
immediately obvious how the attached program can determine the vCPU that
triggered the TP. If we are going to propose modularizing certain KVM
metrics with tracepoints then that would be a rather critical piece of
information.

Apologies for any confusion I added to the whole situation, but
hopefully we can still engage in a broader conversation regarding
how to package up optional KVM metrics.

--
Thanks,
Oliver
