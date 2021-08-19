Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB9D3F1730
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 12:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbhHSKVi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 06:21:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236149AbhHSKVb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Aug 2021 06:21:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629368454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L1CCzAeJSpDDezCsXtRC9C3/Zrf0t5tN8EP1vLgFDsA=;
        b=PGsom/lHPOUwk23xAPZs0kT7+1kbMAkC5MPD2WlBwlgkFvM4L3M9PxCbBTGOStweljI+C+
        EtxzFXoc/Hf9PpnnOxyPSCqPgqpErKBOug5aP81gSANGTPuabnsfWDRXkXD5OByS/v6iuq
        KC/hwYt1X9yhkP9ih9FN9yeNmGm85To=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-NTvHQAb4OHWqdwGUdEDw0A-1; Thu, 19 Aug 2021 06:20:53 -0400
X-MC-Unique: NTvHQAb4OHWqdwGUdEDw0A-1
Received: by mail-ej1-f70.google.com with SMTP id e15-20020a1709061fcf00b005bd9d618ea0so2054895ejt.13
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 03:20:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L1CCzAeJSpDDezCsXtRC9C3/Zrf0t5tN8EP1vLgFDsA=;
        b=HT6usEX5htZ25Wo2FyOBGXkIARicvsuXGKslbCbVq/wVib/NzgO4JuJyaS2XqSB90z
         8opIR9j/Q8k4ztiRjLIcQbZkqVm/2oaVjz7NrqncBxwAhIbpzQ2BOOzPW/mq4YFEc8BV
         tOmNew9upf9dIGjMWCP8iiv3I88HuBlo+9g5Tx+RqTZtG4BzG798wpxUTrffiRHullD9
         2dpcRS2hBxKUswyXShE/WOYbvDhiySZmlwZ3cPIzycDajwCMflRKERZ+BTRBaT+y5o5k
         NE1KM0vdOMVbNuVX54///dD5FS7PMbu8dNs67Nic4eLoWT+0NKxi2RXJsK1c8r25QTWU
         RDpQ==
X-Gm-Message-State: AOAM531ALvUTRu35UbCmW+tu5SLrE+lp1oNKBuH06+O4U7+rNlZCF2Y5
        gLCSb6fx7Z0WFcIg2JDYIv75EJlbGLH7SKLrj+sdCBKC7za5dUXc+zUgz5dAnhrR5UWV5TyeWUk
        l3d2GsTxFAjVY
X-Received: by 2002:a17:907:98b1:: with SMTP id ju17mr8008283ejc.184.1629368452319;
        Thu, 19 Aug 2021 03:20:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBfnTVCvp6rGinFVT8nbfW7JjQV7oLtknw18f9vGb86D+Jkir22d3T6cemMPFhCyhW/uyIrg==
X-Received: by 2002:a17:907:98b1:: with SMTP id ju17mr8008256ejc.184.1629368452082;
        Thu, 19 Aug 2021 03:20:52 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id f20sm1065910ejz.30.2021.08.19.03.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 03:20:51 -0700 (PDT)
Date:   Thu, 19 Aug 2021 12:20:49 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 3/7] KVM: arm64: Allow userspace to configure a vCPU's
 virtual offset
Message-ID: <20210819102049.xbpwancdrram6ujj@gator.home>
References: <20210816001217.3063400-1-oupton@google.com>
 <20210816001217.3063400-4-oupton@google.com>
 <874kblsssy.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874kblsssy.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 19, 2021 at 10:11:09AM +0100, Marc Zyngier wrote:
> On Mon, 16 Aug 2021 01:12:13 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > Allow userspace to access the guest's virtual counter-timer offset
> > through the ONE_REG interface. The value read or written is defined to
> > be an offset from the guest's physical counter-timer. Add some
> > documentation to clarify how a VMM should use this and the existing
> > CNTVCT_EL0.
> > 
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > Reviewed-by: Andrew Jones <drjones@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.rst    | 10 ++++++++++
> >  arch/arm64/include/uapi/asm/kvm.h |  1 +
> >  arch/arm64/kvm/arch_timer.c       | 23 +++++++++++++++++++++++
> >  arch/arm64/kvm/guest.c            |  6 +++++-
> >  include/kvm/arm_arch_timer.h      |  1 +
> >  5 files changed, 40 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index dae68e68ca23..adb04046a752 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -2463,6 +2463,16 @@ arm64 system registers have the following id bit patterns::
> >       derived from the register encoding for CNTV_CVAL_EL0.  As this is
> >       API, it must remain this way.
> >  
> > +.. warning::
> > +
> > +     The value of KVM_REG_ARM_TIMER_OFFSET is defined as an offset from
> > +     the guest's view of the physical counter-timer.
> > +
> > +     Userspace should use either KVM_REG_ARM_TIMER_OFFSET or
> > +     KVM_REG_ARM_TIMER_CNT to pause and resume a guest's virtual
> > +     counter-timer. Mixed use of these registers could result in an
> > +     unpredictable guest counter value.
> > +
> >  arm64 firmware pseudo-registers have the following bit pattern::
> >  
> >    0x6030 0000 0014 <regno:16>
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index b3edde68bc3e..949a31bc10f0 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -255,6 +255,7 @@ struct kvm_arm_copy_mte_tags {
> >  #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
> >  #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
> >  #define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
> > +#define KVM_REG_ARM_TIMER_OFFSET	ARM64_SYS_REG(3, 4, 14, 0, 3)
> >
> 
> Andrew, does this warrant an update to the selftest that checks for
> sysreg visibility?

Yup, until we do, the test will emit a warning with a suggestion to add
the new register to the list. It won't be a test FAIL, because adding new
registers doesn't break migration from older kernels, but we might as well
update the list sooner than later.

> 
> I am also wondering how a VMM such as QEMU is going to deal with the
> above restriction, given the way it blindly saves/restores all the
> registers that KVM exposes, hence hitting that mixed-use that the
> documentation warns about...

You're right and I think it's a problem. While we can special case
registers in QEMU using a cpreg "level" so they won't get saved/restored
all the time, it doesn't help here since we won't be special casing
KVM_REG_ARM_TIMER_OFFSET in older QEMU. We need a way for the VMM to opt
in to using KVM_REG_ARM_TIMER_OFFSET, such as with a CAP we can enable.

Thanks,
drew

