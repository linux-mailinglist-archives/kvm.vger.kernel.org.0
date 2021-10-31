Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22278441152
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 23:53:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhJaWzr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 18:55:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32903 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229982AbhJaWzr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 18:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635720794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZziS6A0PLOF59zuYLA0PLPaHEKD4d3OXJ9lmaNmprf8=;
        b=EPUvT+0WsmhA13QTwfLUXNyxpx3hKo6PHw5vjRaH2xruBfdVs0NrU9j9x6QI6h9XUL03He
        CkktIAgBJLGLHf7a36tlOAdRCtFovSn66h0J0yvnEZnXDIsgWxGxfexO0oloOGCcdqr5aQ
        wUlK8LKOCkQ1ehNbrjgwCpdvNuXabro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-44-IImPJGOmM_6WIOZi84VP9g-1; Sun, 31 Oct 2021 18:53:11 -0400
X-MC-Unique: IImPJGOmM_6WIOZi84VP9g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9FA010A8E00;
        Sun, 31 Oct 2021 22:53:07 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7AC0019C59;
        Sun, 31 Oct 2021 22:52:56 +0000 (UTC)
Message-ID: <b03c61ae0fa7e9531db8115569ef1c201c1aecef.camel@redhat.com>
Subject: Re: [PATCH v2 28/43] KVM: VMX: Remove vCPU from PI wakeup list
 before updating PID.NV
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
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
Date:   Mon, 01 Nov 2021 00:52:55 +0200
In-Reply-To: <YXrbpvHG7YD0MNO2@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-29-seanjc@google.com>
         <558e7e4c36e649709837079a25c2f56fc5609fbe.camel@redhat.com>
         <YXrbpvHG7YD0MNO2@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-10-28 at 17:19 +0000, Sean Christopherson wrote:
> On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> > On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > > Remove the vCPU from the wakeup list before updating the notification
> > > vector in the posted interrupt post-block helper.  There is no need to
> > > wake the current vCPU as it is by definition not blocking.  Practically
> > > speaking this is a nop as it only shaves a few meager cycles in the
> > > unlikely case that the vCPU was migrated and the previous pCPU gets a
> > > wakeup IRQ right before PID.NV is updated.  The real motivation is to
> > > allow for more readable code in the future, when post-block is merged
> > > with vmx_vcpu_pi_load(), at which point removal from the list will be
> > > conditional on the old notification vector.
> > > 
> > > Opportunistically add comments to document why KVM has a per-CPU spinlock
> > > that, at first glance, appears to be taken only on the owning CPU.
> > > Explicitly call out that the spinlock must be taken with IRQs disabled, a
> > > detail that was "lost" when KVM switched from spin_lock_irqsave() to
> > > spin_lock(), with IRQs disabled for the entirety of the relevant path.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/posted_intr.c | 49 +++++++++++++++++++++++-----------
> > >  1 file changed, 33 insertions(+), 16 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > > index 2b2206339174..901b7a5f7777 100644
> > > --- a/arch/x86/kvm/vmx/posted_intr.c
> > > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > > @@ -10,10 +10,22 @@
> > >  #include "vmx.h"
> > >  
> > >  /*
> > > - * We maintain a per-CPU linked-list of vCPU, so in wakeup_handler() we
> > > - * can find which vCPU should be waken up.
> > > + * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
> > Nit: While at it, it would be nice to rename this to pi_wakeup_hanlder() so
> > that it can be more easilly found.
> 
> Ah, good catch.
> 
> > > + * when a WAKEUP_VECTOR interrupted is posted.  vCPUs are added to the list when
> > > + * the vCPU is scheduled out and is blocking (e.g. in HLT) with IRQs enabled.
> > s/interrupted/interrupt ?
> > 
> > Isn't that comment incorrect? As I see, the PI hardware is setup to use the WAKEUP_VECTOR
> > when vcpu blocks (in pi_pre_block) and then that vcpu is added to the list.
> > The pi_wakeup_hanlder just goes over the list and wakes up all vcpus on the lsit.
> 
> Doh, yes.  This patch is predicting the future.  The comment becomes correct as of 
> 
>   KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load
> 
> but as of this patch the "scheduled out" piece doesn't hold true.
>  
> > > + * The vCPUs posted interrupt descriptor is updated at the same time to set its
> > > + * notification vector to WAKEUP_VECTOR, so that posted interrupt from devices
> > > + * wake the target vCPUs.  vCPUs are removed from the list and the notification
> > > + * vector is reset when the vCPU is scheduled in.
> > >   */
> > >  static DEFINE_PER_CPU(struct list_head, blocked_vcpu_on_cpu);
> > Also while at it, why not to rename this to 'blocked_vcpu_list'?
> > to explain that this is list of blocked vcpus. Its a per-cpu variable
> > so 'on_cpu' suffix isn't needed IMHO.
> 
> As you noted, addressed in a future patch.
> 
> > > +/*
> > > + * Protect the per-CPU list with a per-CPU spinlock to handle task migration.
> > > + * When a blocking vCPU is awakened _and_ migrated to a different pCPU, the
> > > + * ->sched_in() path will need to take the vCPU off the list of the _previous_
> > > + * CPU.  IRQs must be disabled when taking this lock, otherwise deadlock will
> > > + * occur if a wakeup IRQ arrives and attempts to acquire the lock.
> > > + */
> > >  static DEFINE_PER_CPU(spinlock_t, blocked_vcpu_on_cpu_lock);
> > >  
> > >  static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
> > > @@ -101,23 +113,28 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
> > >  	WARN(pi_desc->nv != POSTED_INTR_WAKEUP_VECTOR,
> > >  	     "Wakeup handler not enabled while the vCPU was blocking");
> > >  
> > > -	dest = cpu_physical_id(vcpu->cpu);
> > > -	if (!x2apic_mode)
> > > -		dest = (dest << 8) & 0xFF00;
> > > -
> > > -	do {
> > > -		old.control = new.control = READ_ONCE(pi_desc->control);
> > > -
> > > -		new.ndst = dest;
> > > -
> > > -		/* set 'NV' to 'notification vector' */
> > > -		new.nv = POSTED_INTR_VECTOR;
> > > -	} while (cmpxchg64(&pi_desc->control, old.control,
> > > -			   new.control) != old.control);
> > > -
> > > +	/*
> > > +	 * Remove the vCPU from the wakeup list of the _previous_ pCPU, which
> > > +	 * will not be the same as the current pCPU if the task was migrated.
> > > +	 */
> > >  	spin_lock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> > >  	list_del(&vcpu->blocked_vcpu_list);
> > >  	spin_unlock(&per_cpu(blocked_vcpu_on_cpu_lock, vcpu->pre_pcpu));
> > > +
> > > +	dest = cpu_physical_id(vcpu->cpu);
> > > +	if (!x2apic_mode)
> > > +		dest = (dest << 8) & 0xFF00;
> > It would be nice to have a function for this, this appears in this file twice.
> > Maybe there is a function already somewhere?
> 
> The second instance does go away by the aforementioned:

Then no need for a helper.

> 
>   KVM: VMX: Handle PI wakeup shenanigans during vcpu_put/load
> 
> I'm inclined to say we don't want a helper because there should only ever be one
> path that changes PI.ndst.  But a comment would definitely help to explain the
> difference between xAPIC and x2APIC IDs.
> 

Makes sense!

Best regards,
	Maxim Levitsky

