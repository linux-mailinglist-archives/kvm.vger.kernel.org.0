Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFFB441149
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 23:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhJaWvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 18:51:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhJaWvL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 18:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635720518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IAXDzBRARqGuWFKHNo+aw3J6+tC4cDZIOgfc+O9TnKM=;
        b=WZrVsXUCnklhCn/rlKfhnZ/5G+v5AYBCQM62cu5MutD1b9HPYF+XBXH5YTAthtACvRpzNP
        YIo03gHrAlOqbBcBboCHUd6q5DnkUQWlUycBsQL2DCv9Gf49U8zb1d2+VNQZhlBKVHB9sv
        BhVcHoODp/EHloorSKlyz/5BzuxeLEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-DA7Ib6_UPm-Qx5l3Quy1qw-1; Sun, 31 Oct 2021 18:48:35 -0400
X-MC-Unique: DA7Ib6_UPm-Qx5l3Quy1qw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95B171006AA2;
        Sun, 31 Oct 2021 22:48:31 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03B4019C79;
        Sun, 31 Oct 2021 22:48:18 +0000 (UTC)
Message-ID: <20a17d75855dfb9bd496466fcd9f14baab0b2bda.camel@redhat.com>
Subject: Re: [PATCH v2 26/43] KVM: VMX: Read Posted Interrupt "control"
 exactly once per loop iteration
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
Date:   Mon, 01 Nov 2021 00:48:17 +0200
In-Reply-To: <YXrH/ZZBOHrWHz4j@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-27-seanjc@google.com>
         <b078cce30f86672d7d8f8eaa0adc47d24def24e2.camel@redhat.com>
         <YXrH/ZZBOHrWHz4j@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-10-28 at 15:55 +0000, Sean Christopherson wrote:
> On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> > On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > > Use READ_ONCE() when loading the posted interrupt descriptor control
> > > field to ensure "old" and "new" have the same base value.  If the
> > > compiler emits separate loads, and loads into "new" before "old", KVM
> > > could theoretically drop the ON bit if it were set between the loads.
> > > 
> > > Fixes: 28b835d60fcc ("KVM: Update Posted-Interrupts Descriptor when vCPU is preempted")
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/vmx/posted_intr.c | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> > > index 414ea6972b5c..fea343dcc011 100644
> > > --- a/arch/x86/kvm/vmx/posted_intr.c
> > > +++ b/arch/x86/kvm/vmx/posted_intr.c
> > > @@ -53,7 +53,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
> > >  
> > >  	/* The full case.  */
> > >  	do {
> > > -		old.control = new.control = pi_desc->control;
> > > +		old.control = new.control = READ_ONCE(pi_desc->control);
> > >  
> > >  		dest = cpu_physical_id(cpu);
> > >  
> > > @@ -104,7 +104,7 @@ static void __pi_post_block(struct kvm_vcpu *vcpu)
> > >  	     "Wakeup handler not enabled while the vCPU was blocking");
> > >  
> > >  	do {
> > > -		old.control = new.control = pi_desc->control;
> > > +		old.control = new.control = READ_ONCE(pi_desc->control);
> > >  
> > >  		dest = cpu_physical_id(vcpu->cpu);
> > >  
> > > @@ -160,7 +160,7 @@ int pi_pre_block(struct kvm_vcpu *vcpu)
> > >  	     "Posted Interrupt Suppress Notification set before blocking");
> > >  
> > >  	do {
> > > -		old.control = new.control = pi_desc->control;
> > > +		old.control = new.control = READ_ONCE(pi_desc->control);
> > >  
> > >  		/* set 'NV' to 'wakeup vector' */
> > >  		new.nv = POSTED_INTR_WAKEUP_VECTOR;
> > 
> > I wish there was a way to mark fields in a struct, as requiring 'READ_ONCE' on them
> > so that compiler would complain if this isn't done, or automatically use 'READ_ONCE'
> > logic.
> 
> Hmm, I think you could make an argument that ON and thus the whole "control"
> word should be volatile.  AFAICT, tagging just "on" as volatile actually works.
> There's even in a clause in Documentation/process/volatile-considered-harmful.rst
> that calls this out as a (potentially) legitimate use case.
> 
>   - Pointers to data structures in coherent memory which might be modified
>     by I/O devices can, sometimes, legitimately be volatile.
> 
> That said, I think I actually prefer forcing the use of READ_ONCE.  The descriptor
> requires more protections than what volatile provides, namely that all writes need
> to be atomic.  So given that volatile alone isn't sufficient, I'd prefer to have
> the code itself be more self-documenting.

I took a look at how READ_ONCE/WRITE_ONCE is implemented and indeed they use volatile
(the comment above __READ_ONCE is worth gold...), so there is a bit of contradiction:

volatile-considered-harmful.rst states not to mark struct members volatile since
you usually need more that than (very true often) and yet, I also heard that
READ_ONCE/WRITE_ONCE is very encouraged to be used to fields that are used in lockless
algorithms, even when not strictly needed,
so why not to just mark the field and then use it normally? I guess that
explicit READ_ONCE/WRITE_ONCE is much more readable/visible that a volatile in some header file.

Anyway this isn't something I am going to argue about or push to be changed,
just something I thought about.

Best regards,
	Maxim Levitsky



> 
> E.g. this compiles and does mess up the expected size.
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
> index 7f7b2326caf5..149df3b18789 100644
> --- a/arch/x86/kvm/vmx/posted_intr.h
> +++ b/arch/x86/kvm/vmx/posted_intr.h
> @@ -11,9 +11,9 @@ struct pi_desc {
>         union {
>                 struct {
>                                 /* bit 256 - Outstanding Notification */
> -                       u16     on      : 1,
> +                       volatile u16    on      : 1;
>                                 /* bit 257 - Suppress Notification */
> -                               sn      : 1,
> +                       u16     sn      : 1,
>                                 /* bit 271:258 - Reserved */
>                                 rsvd_1  : 14;
>                                 /* bit 279:272 - Notification Vector */
> @@ -23,7 +23,7 @@ struct pi_desc {
>                                 /* bit 319:288 - Notification Destination */
>                         u32     ndst;
>                 };
> -               u64 control;
> +               volatile u64 control;
>         };
>         u32 rsvd[6];
>  } __aligned(64);
> 


