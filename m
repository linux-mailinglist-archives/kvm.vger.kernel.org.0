Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094E543E70C
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 19:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhJ1RWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 13:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhJ1RWH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 13:22:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607BBC061348
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 10:19:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id v1-20020a17090a088100b001a21156830bso8476893pjc.1
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 10:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q4iJG3ZW7obL4DMmrtDt5ktj041PvD+dEvmTQN+uKyY=;
        b=mnkWkJlsD3Efv+dhabg9XRW3VcAMBFLrAWU0a5kq4aSl4p3OkuIs64Ri3PE1R6G45W
         WWX1srIjeyGp7bl0JwXP4EsqbWo0C7Rq7LlpprSwJJDhP6Z9C4BlGZ6pF0W6uFPVwJd6
         newuZGIp7fi3S1LWbDnukcAYyKzMEUnwUDvBD8yhO2TaY/ppfXW+LzQN7N/3ahTyR+Xa
         EoqLzmvlkN3t1dBGcUsabuqlQMThWwYqrYkPzmYbFq4TCGSH1FBWF6bLFrKhvfl+wIkg
         myDgbOosQ39NTrE5GkyLOk3F2ofMqkvjX3mEfa4Ds01sxY6mlbwLLtW+SYgm0DJ0rLj4
         pK7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q4iJG3ZW7obL4DMmrtDt5ktj041PvD+dEvmTQN+uKyY=;
        b=7WreF5XGWGdqkSvJB8PwZ3E8lYLckmNkCIWf0Yhj+cYv4JBP5BWMfTie+OGcpIlJIW
         VjA3jh+CKFL6D2tQ9BXaCY4nrV4I8U0cUkw8KBdbauWnLlfLsAe69pq4l8iHyIYxEDk0
         +e2O76somZGgoIvB5RxvjJcsvSdUDHXVtWf/DGpHLNGCS9tSW0tAyisQQTCANinYkHGO
         WBM8GczRpI7VyAMFoT8vMLHZBTXHvOKO0wLaKUWMyrObkYn3Ja2PSXDwio5Ze/QCPMgI
         HE8+Yb0jxpzvCsgXNVkE5yRkvpR1McZJFjbIuToyw+Ffz20dXPRGsuisDiYB2X/KIeaz
         /mqQ==
X-Gm-Message-State: AOAM5305F2Epe7uvMJnl2ricF99cC1HoHEu2S9CTbJpQxBuOwzOLAr3/
        dwXfPTv3dLGZDCEkyp0tb3zt+w==
X-Google-Smtp-Source: ABdhPJybd062Z7dZdlv5Ua0y9WgXsZDlcpD/ngOKZtR+XtlO0zPIxbocuXwUccJIVKZ7ltOnF8e4MQ==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr5854314pjq.181.1635441579540;
        Thu, 28 Oct 2021 10:19:39 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d24sm3945465pfn.62.2021.10.28.10.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 10:19:38 -0700 (PDT)
Date:   Thu, 28 Oct 2021 17:19:34 +0000
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
Subject: Re: [PATCH v2 28/43] KVM: VMX: Remove vCPU from PI wakeup list
 before updating PID.NV
Message-ID: <YXrbpvHG7YD0MNO2@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
 <20211009021236.4122790-29-seanjc@google.com>
 <558e7e4c36e649709837079a25c2f56fc5609fbe.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <558e7e4c36e649709837079a25c2f56fc5609fbe.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Remove the vCPU from the wakeup list before updating the notification
> > vector in the posted interrupt post-block helper.  There is no need to
> > wake the current vCPU as it is by definition not blocking.  Practically
> > speaking this is a nop as it only shaves a few meager cycles in the
> > unlikely case that the vCPU was migrated and the previous pCPU gets a
> > wakeup IRQ right before PID.NV is updated.  The real motivation is to
> > allow for more readable code in the future, when post-block is merged
> > with vmx_vcpu_pi_load(), at which point removal from the list will be
> > conditional on the old notification vector.
> > 
> > Opportunistically add comments to document why KVM has a per-CPU spinlock
> > that, at first glance, appears to be taken only on the owning CPU.
> > Explicitly call out that the spinlock must be taken with IRQs disabled, a
> > detail that was "lost" when KVM switched from spin_lock_irqsave() to
> > spin_lock(), with IRQs disabled for the entirety of the relevant path.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/vmx/posted_intr.c | 49 +++++++++++++++++++++++-----------
> >  1 file changed, 33 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > index 2b2206339174..901b7a5f7777 100644
> > --- a/arch/x86/kvm/vmx/posted_intr.c
> > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > @@ -10,10 +10,22 @@
> >  #include "vmx.h"
> >  
> >  /*
> > - * We maintain a per-CPU linked-list of vCPU, so in wakeup_handler() we
> > - * can find which vCPU should be waken up.
> > + * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
> Nit: While at it, it would be nice to rename this to pi_wakeup_hanlder() so
> that it can be more easilly found.

Ah, good catch.

> > + * when a WAKEUP_VECTOR interrupted is posted.  vCPUs are added to the list when
> > + * the vCPU is scheduled out and is blocking (e.g. in HLT) with IRQs enabled.
> s/interrupted/interrupt ?
> 
> Isn't that comment incorrect? As I see, the PI hardware is setup to use the WAKEUP_VECTOR
> when vcpu blocks (in pi_pre_block) and then that vcpu is added to the list.
> The pi_wakeup_hanlder just goes over the list and wakes up all vcpus on the lsit.

Doh, yes.  This patch is predicting the future.  The comment becomes correct as of 

  KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load

but as of this patch the "scheduled out" piece doesn't hold true.
 
> > + * The vCPUs posted interrupt descriptor is updated at the same time to set its
> > + * notification vector to WAKEUP_VECTOR, so that posted interrupt from devices
> > + * wake the target vCPUs.  vCPUs are removed from the list and the notification
> > + * vector is reset when the vCPU is scheduled in.
> >   */
> >  static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
> Also while at it, why not to rename this to 'blocked_vcpu_list'?
> to explain that this is list of blocked vcpus. Its a per-cpu variable
> so 'on_cpu' suffix isn't needed IMHO.

As you noted, addressed in a future patch.

> > +/*
> > + * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
> > + * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
> > + * ->sched_in() path will need to take the vCPU off the list of the _previous_
> > + * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
> > + * occur if a wakeup IRQ arrives and attempts to acquire the lock.
> > + */
> >  static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
> >  
> >  static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
> > @@ -101,23 +113,28 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
> >  	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
> >  	     "Wakeup handler not enabled while the vCPU was blocking");
> >  
> > -	dest = cpu_physical_id(vcpu->cpu);
> > -	if (!x2apic_mode)
> > -		dest = (dest << 8) & 0xFF00;
> > -
> > -	do {
> > -		old.control = new.control = READ_ONCE(pi_desc->control);
> > -
> > -		new.ndst = dest;
> > -
> > -		/* set 'NV' to 'notification vector' */
> > -		new.nv = POSTED_INTR_VECTOR;
> > -	} while (cmpxchg64(&pi_desc->control, old.control,
> > -			   new.control) != old.control);
> > -
> > +	/*
> > +	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
> > +	 * will not be the same as the current pCPU if the task was migrated.
> > +	 */
> >  	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> >  	list_del(&vcpu->blocked_vcpu_list);
> >  	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> > +
> > +	dest = cpu_physical_id(vcpu->cpu);
> > +	if (!x2apic_mode)
> > +		dest = (dest << 8) & 0xFF00;
> It would be nice to have a function for this, this appears in this file twice.
> Maybe there is a function already somewhere?

The second instance does go away by the aforementioned:

  KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load

I'm inclined to say we don't want a helper because there should only ever be one
path that changes PI.ndst.  But a comment would definitely help to explain the
difference between xAPIC and x2APIC IDs.
