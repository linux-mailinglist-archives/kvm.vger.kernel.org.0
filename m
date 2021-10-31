Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2529944114F
	for <lists+kvm@lfdr.de>; Sun, 31 Oct 2021 23:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhJaWyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Oct 2021 18:54:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230519AbhJaWyg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 31 Oct 2021 18:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635720723;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dQzBTZB2neuQYMfndsZa2+3/XGXbUkUJliSXmv07Tbg=;
        b=TewOPruTUwM2k0xjQHDskCDRHUq6yLeFDZgV2emtnflNAZlnNeuc5bGcI/vCBBu54IWtgk
        0CPU8en6ErBnXCC8c5UKQh/v7MG+VS6RIJm1AdmtqOHYJLFugS15F2BPrORuJTuQ8zz7RA
        8lyAGEpBKLMBoK9J2g2HJUp5tu2TSQg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-8bdx3_mDPHG0BFe5kWTFcQ-1; Sun, 31 Oct 2021 18:52:00 -0400
X-MC-Unique: 8bdx3_mDPHG0BFe5kWTFcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE91391272;
        Sun, 31 Oct 2021 22:51:56 +0000 (UTC)
Received: from starship (unknown [10.40.194.243])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9DE0810023AB;
        Sun, 31 Oct 2021 22:51:41 +0000 (UTC)
Message-ID: <432666f36add6647283631770f1b140656c67c62.camel@redhat.com>
Subject: Re: [PATCH v2 27/43] KVM: VMX: Move Posted Interrupt ndst
 computation out of write loop
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
Date:   Mon, 01 Nov 2021 00:51:39 +0200
In-Reply-To: <YXrL1EuzZtTR4J1Q@google.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-28-seanjc@google.com>
         <643d9c249b5863f04290a6f047ea1a2d98bd75f9.camel@redhat.com>
         <YXrL1EuzZtTR4J1Q@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-10-28 at 16:12 +0000, Sean Christopherson wrote:
> On Thu, Oct 28, 2021, Maxim Levitsky wrote:
> > On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > > Hoist the CPU => APIC ID conversion for the Posted Interrupt descriptor
> > > out of the loop to write the descriptor, preemption is disabled so the
> > > CPU won't change, and if the APIC ID changes KVM has bigger problems.
> > > 
> > > No functional change intended.
> > 
> > Is preemption always disabled in vmx_vcpu_pi_load? vmx_vcpu_pi_load is called
> > from vmx_vcpu_load, which is called indirectly from vcpu_load which is called
> > from many ioctls, which userspace does. In these places I don't think that
> > preemption is disabled.
> 
> Preemption is disabled in vcpu_load() by the get_cpu().  The "cpu" param that's
> passed around the vcpu_load() stack is also why I think it's ok to _not_ assert
> that preemption is disabled in vmx_vcpu_pi_load(); if preemption is enabled,
> "cpu" is unstable and thus the entire "load" operation is busted.

Yes, I even knew about the get_cpu() behavier which indeed has to disable preemption.
But I didn't notice call to it, when I wrote this mail! Later I did notice it but it was
too late. Sometimes sending all the review mails at once at the end does make sense after all,
I guess.

Best regards,
	Maxim Levitsky

> 
> 
> #define get_cpu()		({ preempt_disable(); __smp_processor_id(); })
> #define put_cpu()		preempt_enable()
> 
> 
> void vcpu_load(struct kvm_vcpu *vcpu)
> {
> 	int cpu = get_cpu();
> 
> 	__this_cpu_write(kvm_running_vcpu, vcpu);
> 	preempt_notifier_register(&vcpu->preempt_notifier);
> 	kvm_arch_vcpu_load(vcpu, cpu);
> 	put_cpu();
> }
> EXPORT_SYMBOL_GPL(vcpu_load);
> 


