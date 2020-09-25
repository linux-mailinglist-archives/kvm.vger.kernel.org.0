Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E58278460
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgIYJuq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 05:50:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55334 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727905AbgIYJup (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 05:50:45 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601027444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GDhBPOe3jcVROJ0BN62HKOTXC7jV4GnEORkL67PFQTY=;
        b=gcnVxpVL3nd9qrg3gAx2btAzjHQ/cin3t3w9KzOSclnNswcoVqD0HSS86edvQVwugPbGqP
        BVaZ/Sdio3rVBP5CN+7O7HNQdUtfDZg4gYMuwupZu4SW84HElh5jHV1N8+chtbqwQ5iO2O
        K83F2ISUTs7DyWBvXaEm3sSfdRDGMso=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-561-FxIDo48QNMeI2a0fb5P3gg-1; Fri, 25 Sep 2020 05:50:42 -0400
X-MC-Unique: FxIDo48QNMeI2a0fb5P3gg-1
Received: by mail-wm1-f70.google.com with SMTP id m10so635415wmf.5
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 02:50:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=GDhBPOe3jcVROJ0BN62HKOTXC7jV4GnEORkL67PFQTY=;
        b=PNg+bfHV0C6OjhY9bk3cNZHR5NhSIbNEai1Z2yMY0qrNI4I3xEThr9Z3l0jWElFl90
         cdAgTHCzJTOYyYgslHf/eHbGxsmSxcUUQM8J+b2Xpmzw/2OunrDWq/cb5cB2II2Wrsm6
         dC21LnhXRo1AT6ICfx1tdbgF+TNHsiXYTAZ5/URVRBR6eqN5oNZyneuVgugkwgJXwuP7
         T0QVc4Kod5jkTP6uvf2Jjod+Lh3ABoinjCy3AjXnxTiIqehmRuZqCty5b1BnzoWxZuhy
         HAh9BIwJ/P7Fnt9+SSyPRVVILLcY4ovInSwJbzlEJbmovrsEY0z6FQuzjFXkQdW1SmIu
         KKEA==
X-Gm-Message-State: AOAM5338qFFhtgbPUd1UO4S4ReU/Oi5vLXTzMhu3yKX4b/cbdfbvMqzH
        f4jotsYeRtMFa0fFq4D93rRdYJtydQB0XLjoVEVrPW5xrsdK25jiH43qB0gghErKJDBksAVDVhB
        3fMkZK7aACaqU
X-Received: by 2002:a5d:4a49:: with SMTP id v9mr3841593wrs.153.1601027440796;
        Fri, 25 Sep 2020 02:50:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKKVcO2kM6IPpdp2Gg3hQPq2vUbpZkkTaJ2CerST66mM7BDhtIYbJ3z0B9ciUri96lZVcLGw==
X-Received: by 2002:a5d:4a49:: with SMTP id v9mr3841553wrs.153.1601027440543;
        Fri, 25 Sep 2020 02:50:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id k4sm2180432wrx.51.2020.09.25.02.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 02:50:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Huacai Chen <chenhc@lemote.com>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        linux-mips@vger.kernel.org, Paul Mackerras <paulus@ozlabs.org>,
        kvm-ppc@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [RFC PATCH 3/3] KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs that are fatal to the VM
In-Reply-To: <20200924181134.GB9649@linux.intel.com>
References: <20200923224530.17735-1-sean.j.christopherson@intel.com> <20200923224530.17735-4-sean.j.christopherson@intel.com> <878scze4l5.fsf@vitty.brq.redhat.com> <20200924181134.GB9649@linux.intel.com>
Date:   Fri, 25 Sep 2020 11:50:38 +0200
Message-ID: <87k0wichht.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, Sep 24, 2020 at 02:34:14PM +0200, Vitaly Kuznetsov wrote:
>> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> > index 6f9a0c6d5dc5..810d46ab0a47 100644
>> > --- a/arch/x86/kvm/vmx/vmx.c
>> > +++ b/arch/x86/kvm/vmx/vmx.c
>> > @@ -2250,7 +2250,7 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>> >  		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
>> >  		break;
>> >  	default:
>> > -		WARN_ON_ONCE(1);
>> > +		KVM_BUG_ON(1, vcpu->kvm);
>> >  		break;
>> >  	}
>> >  }
>> > @@ -4960,6 +4960,7 @@ static int handle_cr(struct kvm_vcpu *vcpu)
>> >  			return kvm_complete_insn_gp(vcpu, err);
>> >  		case 3:
>> >  			WARN_ON_ONCE(enable_unrestricted_guest);
>> > +
>> >  			err = kvm_set_cr3(vcpu, val);
>> >  			return kvm_complete_insn_gp(vcpu, err);
>> >  		case 4:
>> > @@ -4985,14 +4986,13 @@ static int handle_cr(struct kvm_vcpu *vcpu)
>> >  		}
>> >  		break;
>> >  	case 2: /* clts */
>> > -		WARN_ONCE(1, "Guest should always own CR0.TS");
>> > -		vmx_set_cr0(vcpu, kvm_read_cr0_bits(vcpu, ~X86_CR0_TS));
>> > -		trace_kvm_cr_write(0, kvm_read_cr0(vcpu));
>> > -		return kvm_skip_emulated_instruction(vcpu);
>> > +		KVM_BUG(1, vcpu->kvm, "Guest always owns CR0.TS");
>> > +		return -EIO;
>> >  	case 1: /*mov from cr*/
>> >  		switch (cr) {
>> >  		case 3:
>> >  			WARN_ON_ONCE(enable_unrestricted_guest);
>> > +
>> 
>> Here, were you intended to replace WARN_ON_ONCE() with KVM_BUG_ON() or
>> this is just a stray newline added?
>
> I think it's just a stray newline.  At one point I had converted this to a
> KVM_BUG_ON(), but then reversed direction because it's not fatal to the guest,
> i.e. KVM should continue to function even though it's spuriously intercepting
> CR3 loads.
>
> Which, rereading this patch, completely contradicts the KVM_BUG() for CLTS.
>
> That's probably something we should sort out in this RFC: is KVM_BUG() only
> to be used if the bug is fatal/dangerous, or should it be used any time the
> error is definitely a KVM (or hardware) bug.

Personally, I'm feeling adventurous so my vote goes to the later :-)
Whenever a KVM bug was discovered by a VM it's much safer to stop
executing it as who knows what the implications might be?

In this particular case I can think of a nested scenario when L1 didn't
ask for CR3 intercept but L0 is still injecting it. It is not fatal by
itself but probably there is bug in calculating intercepts in L0 so
if we're getting something extra maybe we're also missing some? And this
doesn't sound good at all.

>
>> >  			val = kvm_read_cr3(vcpu);
>> >  			kvm_register_write(vcpu, reg, val);
>> >  			trace_kvm_cr_read(cr, val);
>> > @@ -5330,7 +5330,9 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>> >  
>> >  static int handle_nmi_window(struct kvm_vcpu *vcpu)
>> >  {
>> > -	WARN_ON_ONCE(!enable_vnmi);
>> > +	if (KVM_BUG_ON(!enable_vnmi, vcpu->kvm))
>> > +		return -EIO;
>> > +
>> >  	exec_controls_clearbit(to_vmx(vcpu), CPU_BASED_NMI_WINDOW_EXITING);
>> >  	++vcpu->stat.nmi_window_exits;
>> >  	kvm_make_request(KVM_REQ_EVENT, vcpu);
>> > @@ -5908,7 +5910,8 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>> >  	 * below) should never happen as that means we incorrectly allowed a
>> >  	 * nested VM-Enter with an invalid vmcs12.
>> >  	 */
>> > -	WARN_ON_ONCE(vmx->nested.nested_run_pending);
>> > +	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
>> > +		return -EIO;
>> >  
>> >  	/* If guest state is invalid, start emulating */
>> >  	if (vmx->emulation_required)
>> > @@ -6258,7 +6261,9 @@ static int vmx_sync_pir_to_irr(struct kvm_vcpu *vcpu)
>> >  	int max_irr;
>> >  	bool max_irr_updated;
>> >  
>> > -	WARN_ON(!vcpu->arch.apicv_active);
>> > +	if (KVM_BUG_ON(!vcpu->arch.apicv_active, vcpu->kvm))
>> > +		return -EIO;
>> > +
>> >  	if (pi_test_on(&vmx->pi_desc)) {
>> >  		pi_clear_on(&vmx->pi_desc);
>> >  		/*
>> > @@ -6345,7 +6350,7 @@ static void handle_external_interrupt_irqoff(struct kvm_vcpu *vcpu)
>> >  	gate_desc *desc;
>> >  	u32 intr_info = vmx_get_intr_info(vcpu);
>> >  
>> > -	if (WARN_ONCE(!is_external_intr(intr_info),
>> > +	if (KVM_BUG(!is_external_intr(intr_info), vcpu->kvm,
>> >  	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
>> >  		return;
>> >  
>> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> > index 17f4995e80a7..672eb5142b34 100644
>> > --- a/arch/x86/kvm/x86.c
>> > +++ b/arch/x86/kvm/x86.c
>> > @@ -8363,6 +8363,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>> >  	bool req_immediate_exit = false;
>> >  
>> >  	if (kvm_request_pending(vcpu)) {
>> > +		if (kvm_check_request(KVM_REQ_VM_BUGGED, vcpu)) {
>> 
>> Do we want to allow userspace to continue executing the guest or should
>> we make KVM_REQ_VM_BUGGED permanent by replacing kvm_check_request()
>> with kvm_test_request()?
>
> In theory, it should be impossible to reach this again as "r = -EIO" will
> bounce this out to userspace, the common checks to deny all ioctls() will
> prevent reinvoking KVM_RUN.

Do we actually want to prevent *all* ioctls? E.g. when 'vm bugged'
condition is triggered userspace may want to extract some information to
assist debugging but even things like KVM_GET_[S]REGS will just return
-EIO. I'm not sure it is generally safe to enable *everything* (except
for KVM_RUN which should definitely be forbidden) so maybe your approach
is preferable.

>
>> > +			r = -EIO;
>> > +			goto out;
>> > +		}
>> >  		if (kvm_check_request(KVM_REQ_GET_VMCS12_PAGES, vcpu)) {
>> >  			if (unlikely(!kvm_x86_ops.nested_ops->get_vmcs12_pages(vcpu))) {
>> >  				r = 0;
>> 
>> -- 
>> Vitaly
>> 
>

-- 
Vitaly

