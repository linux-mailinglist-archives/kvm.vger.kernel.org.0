Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B8E43E5D8
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 18:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhJ1QOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 12:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhJ1QOf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 12:14:35 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E14F4C061570
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 09:12:08 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id h193so6892373pgc.1
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 09:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uDFUXcWiQOAZszlFDFiKgSiJL9HB/WuFg2qPOmsqC9E=;
        b=s8JT5njEusSpDvvGXpDQ9LZlankma9a4yiSWD9KOohfnBHlxyPNl/U/08pekLcb/bC
         ovoSobTTd28f9TmLEDOEfxcyphCFmhjuM9+ON0HPn4qn8BCTN2ldIPxu2jDowg4XqJu6
         3xH28lP4FssgtQ0ca7hD6ajCl1FxkivUDYuXRLmLx2Yi3tCCzZXargRA7TY8R9VN5f+Z
         OVvgBrcUFyQ3a4VjcEcymihbaDJ3t1+Gwm46k3BuLJXPbEryRKF1JBLikEHoHCefGv/7
         I7zNR4Q9EXiCvnW7HnxhjPhNdV9zeEX0aTdpBRV58BMvHDUDx6AGdT+87VVv7qJ97TcC
         uARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uDFUXcWiQOAZszlFDFiKgSiJL9HB/WuFg2qPOmsqC9E=;
        b=BUSHpJDPYJ2+tCcGhYZqTGDbHckKwfD+2LBM+rOx+XsbNBvYeVdR3OGVHU/PE9Mk4q
         xzp978bPxR6apcZo7fMH1CXXUz7j4Y9MvQPSkuHPUGkaW+vi6OXpN/cxKwyyuH9YilbE
         VUJg2GVCdJnl+nw0NLCQ1Wihm1RUyV9/X8vlshg8JfmSeonCmATQXsICT7vChJMHQYlo
         J/zwwjiF2DcXmSleYBd2DAbjaDlllb6Jz5O+syXTTfiiOeDZUUjqGhz7rXJ1HemWwHRC
         yG5Exjg/VwcxPIId1M81GMJJ4lY1XGUpDAiHtqLCPcn8bM7BTZuyH4n0SnkzHrwU69Qy
         WWbQ==
X-Gm-Message-State: AOAM5332FfxqLvCC1o1RtHG6q2xy0vyDpKN+pV1uNeGRMQlGsSMloMup
        wmZc/Cly/nEncGlQHqu5TSF/yA==
X-Google-Smtp-Source: ABdhPJzctFKuSMS4ABMglKZzvBYXQnPOjA4L7dQsvoAPPXlll55VtYD46hr5Zh0pXIPugFNW+Dl/hA==
X-Received: by 2002:a05:6a00:1709:b0:47e:493e:ca5f with SMTP id h9-20020a056a00170900b0047e493eca5fmr4461870pfc.60.1635437528216;
        Thu, 28 Oct 2021 09:12:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f7sm4329616pfv.152.2021.10.28.09.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 09:12:07 -0700 (PDT)
Date:   Thu, 28 Oct 2021 16:12:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v2 27/43] KVM: VMX: Move Posted Interrupt ndst
 computation out of write loop
Message-ID: <YXrL1EuzZtTR4J1Q@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-28-seanjc@google.com>
 <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Hoist the CPU => APIC ID conversion for the Posted Interrupt descriptor
> > out of the loop to write the descriptor, preemption is disabled so the
> > CPU won't change, and if the APIC ID changes KVM has bigger problems.
> > 
> > No functional change intended.
> 
> Is preemption always disabled in vmx_vcpu_pi_load? vmx_vcpu_pi_load is called
> from vmx_vcpu_load, which is called indirectly from vcpu_load which is called
> from many ioctls, which userspace does. In these places I don't think that
> preemption is disabled.

Preemption is disabled in vcpu_load() by the get_cpu().  The "cpu" param that's
passed around the vcpu_load() stack is also why I think it's ok to _not_ assert
that preemption is disabled in vmx_vcpu_pi_load(); if preemption is enabled,
"cpu" is unstable and thus the entire "load" operation is busted.


#define get_cpu()		({ preempt_disable(); __smp_processor_id(); })
#define put_cpu()		preempt_enable()


void vcpu_load(struct kvm_vcpu *vcpu)
{
	int cpu = get_cpu();

	__this_cpu_write(kvm_running_vcpu, vcpu);
	preempt_notifier_register(&vcpu->preempt_notifier);
	kvm_arch_vcpu_load(vcpu, cpu);
	put_cpu();
}
EXPORT_SYMBOL_GPL(vcpu_load);
