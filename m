Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE833FE542
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 00:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244939AbhIAWJf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 18:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243133AbhIAWJa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 18:09:30 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE638C061757
        for <kvm@vger.kernel.org>; Wed,  1 Sep 2021 15:08:32 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id a1so31490ilj.6
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 15:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tPUheJaZHBcw4vca9HyUxGYJolSn/dkPnRtCmems3Kk=;
        b=XBRkHtg5GUG48wrLz+RUhRTD7Q7TWZFMtYe69RP+BmyRwImiVD2LD83lEVcJTo+HE0
         XMDBWHB3Il+/uvFYFRnBOOgEb6KO9VTDo0rKZrTe7FxM87LjoQDRcjyqYNkIwOHOHD/X
         fYaWNizVlQ+kn5Pdxs0gShGtRFvReUizq5VH+bWHy5E4rowruiih+MC8iU/NbUriSMMh
         C2fpPAwih/gSvxg8n/52V7XpcyPrrm8yu6hDs7WSD1jJ0Q2eZCZJGUMl5yafDxyIjfSd
         FoZzcMXOAtCRsUfvWIF6gohZFSLO1o8TVvFiKnL/HBNmiZWmiiFjjvMgaaS+gubMIlf+
         LUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tPUheJaZHBcw4vca9HyUxGYJolSn/dkPnRtCmems3Kk=;
        b=FxRiAHbtORsQ+e+VS2dM0VTRzZ0Rg/9gnIrj8SQzYV8lFqTNRNWVzcX+mBewP9h/UL
         bmm83tOEV6obAEVQeQpshLYhiSoxmVp8ejdoW/qcKCn6Btsyvnew6jBxZvB7Od8XIdCn
         RoUD8o+skbDSuR68D6OAXbIWN/UNbva3fsWBlXfA38clMfwCGg1t9WBXPeZR5506EA7a
         pt64gBShf58k7A/OyoeKnaZc3NAwiNhmNPqFGnk22h+P1/Zt0o3aVYmR+ji+F8plu4Nd
         Ea9NxvSB41AaQa88l5BBRUo6zd4Bo4ibIAxGdbceqElLS/+l0o2eUSjKqin3zOPHJ5wh
         85fw==
X-Gm-Message-State: AOAM533+oJ+etvzYimqX8ubk0FBmy8W2IAGjbT4S5Ts59hBRa1mrzygL
        8xP4XMYyVp5ecMme48UeEIZ3fg==
X-Google-Smtp-Source: ABdhPJy7j9n5AI8PSx1LUhSYg41KM1gcaY+NB3v8gxt4nUeuUOMHYoY6GxgdiPT9WZl4I3pv1HmPuQ==
X-Received: by 2002:a92:870b:: with SMTP id m11mr1143869ild.132.1630534112153;
        Wed, 01 Sep 2021 15:08:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id p15sm490025ilc.12.2021.09.01.15.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 15:08:31 -0700 (PDT)
Date:   Wed, 1 Sep 2021 22:08:28 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/12] KVM: arm64: selftests: Add write_sysreg_s and
 read_sysreg_s
Message-ID: <YS/53N7LdJOgdzNu@google.com>
References: <20210901211412.4171835-1-rananta@google.com>
 <20210901211412.4171835-3-rananta@google.com>
 <YS/wfBTnCJWn05Kn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YS/wfBTnCJWn05Kn@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:28:28PM +0000, Oliver Upton wrote:
> On Wed, Sep 01, 2021 at 09:14:02PM +0000, Raghavendra Rao Ananta wrote:
> > For register names that are unsupported by the assembler or the ones
> > without architectural names, add the macros write_sysreg_s and
> > read_sysreg_s to support them.
> > 
> > The functionality is derived from kvm-unit-tests and kernel's
> > arch/arm64/include/asm/sysreg.h.
> > 
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> 
> Would it be possible to just include <asm/sysreg.h>? See
> tools/arch/arm64/include/asm/sysreg.h

Geez, sorry for the noise. I mistakenly searched from the root of my
repository, not the tools/ directory.

In any case, you could perhaps just drop the kernel header there just to
use the exact same source for kernel and selftest.

Thanks,
Oliver

> > ---
> >  .../selftests/kvm/include/aarch64/processor.h | 61 +++++++++++++++++++
> >  1 file changed, 61 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > index 3cbaf5c1e26b..082cc97ad8d3 100644
> > --- a/tools/testing/selftests/kvm/include/aarch64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
> > @@ -118,6 +118,67 @@ void vm_install_exception_handler(struct kvm_vm *vm,
> >  void vm_install_sync_handler(struct kvm_vm *vm,
> >  		int vector, int ec, handler_fn handler);
> >  
> > +/*
> > + * ARMv8 ARM reserves the following encoding for system registers:
> > + * (Ref: ARMv8 ARM, Section: "System instruction class encoding overview",
> > + *  C5.2, version:ARM DDI 0487A.f)
> > + *	[20-19] : Op0
> > + *	[18-16] : Op1
> > + *	[15-12] : CRn
> > + *	[11-8]  : CRm
> > + *	[7-5]   : Op2
> > + */
> > +#define Op0_shift	19
> > +#define Op0_mask	0x3
> > +#define Op1_shift	16
> > +#define Op1_mask	0x7
> > +#define CRn_shift	12
> > +#define CRn_mask	0xf
> > +#define CRm_shift	8
> > +#define CRm_mask	0xf
> > +#define Op2_shift	5
> > +#define Op2_mask	0x7
> > +
> > +/*
> > + * When accessed from guests, the ARM64_SYS_REG() doesn't work since it
> > + * generates a different encoding for additional KVM processing, and is
> > + * only suitable for userspace to access the register via ioctls.
> > + * Hence, define a 'pure' sys_reg() here to generate the encodings as per spec.
> > + */
> > +#define sys_reg(op0, op1, crn, crm, op2) \
> > +	(((op0) << Op0_shift) | ((op1) << Op1_shift) | \
> > +	 ((crn) << CRn_shift) | ((crm) << CRm_shift) | \
> > +	 ((op2) << Op2_shift))
> > +
> > +asm(
> > +"	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
> > +"	.equ	.L__reg_num_x\\num, \\num\n"
> > +"	.endr\n"
> > +"	.equ	.L__reg_num_xzr, 31\n"
> > +"\n"
> > +"	.macro	mrs_s, rt, sreg\n"
> > +"	.inst	0xd5200000|(\\sreg)|(.L__reg_num_\\rt)\n"
> > +"	.endm\n"
> > +"\n"
> > +"	.macro	msr_s, sreg, rt\n"
> > +"	.inst	0xd5000000|(\\sreg)|(.L__reg_num_\\rt)\n"
> > +"	.endm\n"
> > +);
> > +
> > +/*
> > + * read_sysreg_s() and write_sysreg_s()'s 'reg' has to be encoded via sys_reg()
> > + */
> > +#define read_sysreg_s(reg) ({						\
> > +	u64 __val;							\
> > +	asm volatile("mrs_s %0, "__stringify(reg) : "=r" (__val));	\
> > +	__val;								\
> > +})
> > +
> > +#define write_sysreg_s(reg, val) do {					\
> > +	u64 __val = (u64)val;						\
> > +	asm volatile("msr_s "__stringify(reg) ", %x0" : : "rZ" (__val));\
> > +} while (0)
> > +
> >  #define write_sysreg(reg, val)						  \
> >  ({									  \
> >  	u64 __val = (u64)(val);						  \
> > -- 
> > 2.33.0.153.gba50c8fa24-goog
> > 
