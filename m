Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0607E4DA160
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 18:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350607AbiCORhB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 13:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344156AbiCORhA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 13:37:00 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4FD3580D4
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 10:35:47 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id x9so7230957ilc.3
        for <kvm@vger.kernel.org>; Tue, 15 Mar 2022 10:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xB07ic4vDEAKEcGbENjMpvSU5bZev7EeZpcMe0SL1Sk=;
        b=Q2mKJ54VdYT6PKF7Kd3MohhT/81mfTqd4J7TMBaooLNsVo0jqQwGZFPhF8RqLSKXo0
         TNWcggKLIsYTc5/va5vz9giH4ldO6Q5o3HQaSUmUnZqzOlldxvtYE2ghIwJlPhcs1Chx
         0q3sOfEyPL/JwgI6wRCT0JDujBHYzyKuVEnW3YyxOw37xGyhdBeS5BcFeNXwO340Yt3/
         Ja8vFIkl/NmuB1J91yOpQOzmt0AseowGy7bu1PTomEHrDe+pjFlHCTroIZDAtIeUclwz
         zowr7r4PM/QxV5ePZL6XtWlcCIUUd/TGYnFyELqC8YPvsXBq1MKke1gLNIdbIjaAz4RY
         ibyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xB07ic4vDEAKEcGbENjMpvSU5bZev7EeZpcMe0SL1Sk=;
        b=w4+V96hAjzg1X8YYdpG+BnNWiPHE1f3WSJ7KWRMFv56D45/RFRgbHSIJQODASbO+xa
         hrK8deUvBoHzT+Kmc2OeSuSqhNIja51k4RMqa64gINXlYFHZpkxc8/Nbkn0/3Q8oHOEZ
         htCNVGyYtdu6laVU2FqF4RjwRmY4tNazA1B528Oxlb78xj3rGcf+XRDiiJX1fCeUFVtH
         1lh845J+0z4iNR7qW2gIIn13ONzV/s5Azvo6MMDgCzIPPt2rEFSpoFeWnHUxgmPL97Qj
         vaFGW9ZSrBQZHqVqTAjGpe8lT0kKDKNUDFs4Wri5nb+2PiJS66QD9gS35o5mucYuRzGF
         1FmA==
X-Gm-Message-State: AOAM533Feu4/N0PoifWfj405cr1kxqDh8kfqtFHIi9iUqwi7HHvuTvd6
        S2uBHj8u+ZnCAgditIKN0zxyMw==
X-Google-Smtp-Source: ABdhPJy4FslpKdd7Rvtr7sUC8GERMFuvONRw0Uih85qVWf2Mo8FrrV58on66V6E5rtt4qoWtdn1J/g==
X-Received: by 2002:a05:6e02:1a25:b0:2c6:5c9b:3951 with SMTP id g5-20020a056e021a2500b002c65c9b3951mr22025335ile.81.1647365746829;
        Tue, 15 Mar 2022 10:35:46 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id e15-20020a92194f000000b002c25e778042sm10820871ilm.73.2022.03.15.10.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 10:35:46 -0700 (PDT)
Date:   Tue, 15 Mar 2022 17:35:43 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 05/13] KVM: arm64: Setup a framework for hypercall
 bitmap firmware registers
Message-ID: <YjDOb7R9ClibFMjQ@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-6-rananta@google.com>
 <Yi+aTs4ufnxHXg4r@google.com>
 <CAJHc60yuSfd9YUXmXQjoS+K5u562nAArriB_tVP=mvuLuDeKFQ@mail.gmail.com>
 <YjA/TmAeXt2l19HP@google.com>
 <CAJHc60wz5WsZWTn66i41+G4-dsjCFuFkthXU_Vf6QeXHkgzrZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60wz5WsZWTn66i41+G4-dsjCFuFkthXU_Vf6QeXHkgzrZg@mail.gmail.com>
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

On Tue, Mar 15, 2022 at 09:59:35AM -0700, Raghavendra Rao Ananta wrote:
> On Tue, Mar 15, 2022 at 12:25 AM Oliver Upton <oupton@google.com> wrote:
> >
> > On Mon, Mar 14, 2022 at 05:22:31PM -0700, Raghavendra Rao Ananta wrote:
> > > Hi Oliver,
> > >
> > > On Mon, Mar 14, 2022 at 12:41 PM Oliver Upton <oupton@google.com> wrote:
> > > >
> > > > On Thu, Feb 24, 2022 at 05:25:51PM +0000, Raghavendra Rao Ananta wrote:
> > > > > KVM regularly introduces new hypercall services to the guests without
> > > > > any consent from the userspace. This means, the guests can observe
> > > > > hypercall services in and out as they migrate across various host
> > > > > kernel versions. This could be a major problem if the guest
> > > > > discovered a hypercall, started using it, and after getting migrated
> > > > > to an older kernel realizes that it's no longer available. Depending
> > > > > on how the guest handles the change, there's a potential chance that
> > > > > the guest would just panic.
> > > > >
> > > > > As a result, there's a need for the userspace to elect the services
> > > > > that it wishes the guest to discover. It can elect these services
> > > > > based on the kernels spread across its (migration) fleet. To remedy
> > > > > this, extend the existing firmware psuedo-registers, such as
> > > > > KVM_REG_ARM_PSCI_VERSION, for all the hypercall services available.
> > > > >
> > > > > These firmware registers are categorized based on the service call
> > > > > owners, and unlike the existing firmware psuedo-registers, they hold
> > > > > the features supported in the form of a bitmap.
> > > > >
> > > > > During the VM initialization, the registers holds an upper-limit of
> > > > > the features supported by the corresponding registers. It's expected
> > > > > that the VMMs discover the features provided by each register via
> > > > > GET_ONE_REG, and writeback the desired values using SET_ONE_REG.
> > > > > KVM allows this modification only until the VM has started.
> > > > >
> > > > > Older userspace code can simply ignore the capability and the
> > > > > hypercall services will be exposed unconditionally to the guests, thus
> > > > > ensuring backward compatibility.
> > > > >
> > > > > In this patch, the framework adds the register only for ARM's standard
> > > > > secure services (owner value 4). Currently, this includes support only
> > > > > for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> > > > > register representing mandatory features of v1.0. The register is also
> > > > > added to the kvm_arm_vm_scope_fw_regs[] list as it maintains its state
> > > > > per-VM. Other services are momentarily added in the upcoming patches.
> > > > >
> > > > > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > > > > ---
> > > > >  arch/arm64/include/asm/kvm_host.h | 12 +++++
> > > > >  arch/arm64/include/uapi/asm/kvm.h |  8 ++++
> > > > >  arch/arm64/kvm/arm.c              |  8 ++++
> > > > >  arch/arm64/kvm/guest.c            |  1 +
> > > > >  arch/arm64/kvm/hypercalls.c       | 78 +++++++++++++++++++++++++++++++
> > > > >  include/kvm/arm_hypercalls.h      |  4 ++
> > > > >  6 files changed, 111 insertions(+)
> > > > >
> > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > index e823571e50cc..1909ced3208f 100644
> > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > @@ -101,6 +101,15 @@ struct kvm_s2_mmu {
> > > > >  struct kvm_arch_memory_slot {
> > > > >  };
> > > > >
> > > > > +/**
> > > > > + * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
> > > > > + *
> > > > > + * @hvc_std_bmap: Bitmap of standard secure service calls
> > > > > + */
> > > > > +struct kvm_hvc_desc {
> > > >
> > > > nit: maybe call this structure kvm_hypercall_features? When nested comes
> > > > along guests will need to use the SVC conduit as HVC traps are always
> > > > taken to EL2. Same will need to be true for virtual EL2.
> > > >
> > > Sure, I can rename it to be more generic.
> > >
> > > > > +     u64 hvc_std_bmap;
> > > > > +};
> > > > > +
> > > > >  struct kvm_arch {
> > > > >       struct kvm_s2_mmu mmu;
> > > > >
> > > > > @@ -142,6 +151,9 @@ struct kvm_arch {
> > > > >
> > > > >       /* Capture first run of the VM */
> > > > >       bool has_run_once;
> > > > > +
> > > > > +     /* Hypercall firmware register' descriptor */
> > > > > +     struct kvm_hvc_desc hvc_desc;
> > > > >  };
> > > > >
> > > > >  struct kvm_vcpu_fault_info {
> > > > > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > > > > index c35447cc0e0c..2decc30d6b84 100644
> > > > > --- a/arch/arm64/include/uapi/asm/kvm.h
> > > > > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > > > > @@ -287,6 +287,14 @@ struct kvm_arm_copy_mte_tags {
> > > > >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED     3
> > > > >  #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED          (1U << 4)
> > > > >
> > > > > +/* Bitmap firmware registers, extension to the existing psuedo-register space */
> > > > > +#define KVM_REG_ARM_FW_BMAP                  KVM_REG_ARM_FW_REG(0xff00)
> > > >
> > > > What is the motivation for moving the bitmap register indices so far
> > > > away from the rest of the firmware regs?
> > > >
> > > The original motivation to create a sub-space came from Reiji's
> > > comment on v3 [1] so that user-space can distinguish between bitmapped
> > > and regular fw registers.
> > > As with the spacing, I thought a 50/50 split would do a good job of
> > > avoiding collisions. Do you have any recommendations here?
> > >
> >
> > I see. This is for the sake of ABI stability with future expansion,
> > right? A new register could be added in the future that controls more
> > SMCCC features, and we expect userspace to zero them if it cares about
> > ABI stability.
> >
> > If that is all true, we probably need some strong supporting
> > documentation. Additionally, using a new COPROC value for the register
> > range might be better than partitioning the existing FW reg range.
> >
> I assumed the 50/50 split could be fine even for future expansion, but
> I can go for a new COPROC value. However, wouldn't the same problem
> exist even with that? We could never have enough space :)

Of course, but I think the UAPI is consistent if you use a new COPROC
value for the bitmaps. That way, you can add documentation that covers
the entire COPROC value you've selected, and doesn't require any further
twiddling with an existing register range. It seems that we have plenty
of COPROC values that are available as well.

> > > > > +#define KVM_REG_ARM_FW_BMAP_REG(r)           (KVM_REG_ARM_FW_BMAP | (r))
> > > >
> > > > If you are still going to use the index offset, just pass 'r' through to
> > > > the other macro:
> > > >
> > > >   #define KVM_REG_ARM_FW_BMAP_REG(r)            KVM_REG_ARM_FW_REG(0xff00 + r)
> > > >
> > > I'm sorry, what's the advantage of doing this?
> > >

Just a style nit :)

--
Thanks,
Oliver
