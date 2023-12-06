Return-Path: <kvm+bounces-3712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 600828074CF
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:20:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 164E81F212AD
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:20:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134B54655E;
	Wed,  6 Dec 2023 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b8aGgm4l"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE0510EB
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 08:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701879630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u/Q8rdpQLGJDQtjt7EUY5rfj9IQLbZ3N/w3XKiq7Zp8=;
	b=b8aGgm4leBaDGHh6HVqpdPqEkfTLqbCBHMBWsBTIZaRpyMjG7yiMJDiBAciXFcZ4rjCmBB
	Wqo8IVGe4NYGTpgyRZyiIWTtfo43JO3djWrkZEiq7+4GDIo/gsFXaF1i5rSzDNMSDnV7WY
	3EMN8usZXCohoei5W82Fb8fXRF2+xXQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-349-noYMJmwBM0SGDAbCsLh9og-1; Wed, 06 Dec 2023 11:20:01 -0500
X-MC-Unique: noYMJmwBM0SGDAbCsLh9og-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3334b1055fbso808153f8f.2
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 08:19:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701879594; x=1702484394;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u/Q8rdpQLGJDQtjt7EUY5rfj9IQLbZ3N/w3XKiq7Zp8=;
        b=UyP8/bYSxRz6bcSpcEtkjNiRn3l11FryD8ieuISaRD9zjzYLcbYy6RFE0rYlwxYLYT
         yVzRK9miqCSM8r7kESr+mk2FlE/Ah6AY+Z8/rr+TKuU6g5v/fRfM8OrDpblbfje61MgO
         pButLgdleHA5wbcOfguvUVXsbgsjnEojwWRl9a7+W6jrq6yTDcpW5PUoroeaDYb/5x04
         stujhNLTmeO0YLNvA5MH8Za2PBMIDpA5PV0Dn6yQ3jo/lLvYvpl0gKazp6rR1uH/eMNa
         CYL10VBMYhFGnXRWxzq3ClmaZ3+1Z4dj+8UYAYQ0giwbpn8+5lQUrEcdtiZSMcwFSris
         41Mw==
X-Gm-Message-State: AOJu0YzaUeLcHT/4jqiyYlhu3bDmfDz+ChzFfvPP3WWNLsheSdTvecCK
	LgglZBzp5NVyoR35Neo2ltO5dBpEuLykk+ge7vF2CxzdQkMtEO0xaLBe+4ZpDqY+/5zHfER3Vcn
	fe+Y1eCswQgxP
X-Received: by 2002:a05:600c:1e18:b0:40c:2101:dab2 with SMTP id ay24-20020a05600c1e1800b0040c2101dab2mr485135wmb.185.1701879594000;
        Wed, 06 Dec 2023 08:19:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH4xLDaJ0nX52wZDtegFdbDV/Vhk4LlL67t4ugX51B9lLHdkt4Pwtf1OhZN87CJx1NsN5/KNQ==
X-Received: by 2002:a05:600c:1e18:b0:40c:2101:dab2 with SMTP id ay24-20020a05600c1e1800b0040c2101dab2mr485124wmb.185.1701879593670;
        Wed, 06 Dec 2023 08:19:53 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id o15-20020a5d408f000000b00333381c6e12sm59389wrp.40.2023.12.06.08.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 08:19:53 -0800 (PST)
Message-ID: <afb23eab62a9a0f3dce360579e9aeefa5a3f1548.camel@redhat.com>
Subject: Re: [RFC 05/33] KVM: x86: hyper-v: Introduce VTL call/return
 prologues in hypercall page
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Nicolas Saenz Julienne <nsaenz@amazon.com>, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
 pbonzini@redhat.com,  vkuznets@redhat.com, anelkz@amazon.com,
 graf@amazon.com, dwmw@amazon.co.uk,  jgowans@amazon.com, kys@microsoft.com,
 haiyangz@microsoft.com, decui@microsoft.com,  x86@kernel.org,
 linux-doc@vger.kernel.org
Date: Wed, 06 Dec 2023 18:19:51 +0200
In-Reply-To: <ZW-7Mwev4Ilf541L@google.com>
References: <20231108111806.92604-1-nsaenz@amazon.com>
	 <20231108111806.92604-6-nsaenz@amazon.com>
	 <f4495d1f697cf9a7ddfb786eaeeac90f554fc6db.camel@redhat.com>
	 <CXD4TVV5QWUK.3SH495QSBTTUF@amazon.com> <ZWoKlJUKJGGhRRgM@google.com>
	 <CXD5HJ5LQMTE.11XP9UB9IL8LY@amazon.com> <ZWocI-2ajwudA-S5@google.com>
	 <CXD7AW5T9R7G.2REFR2IRSVRVZ@amazon.com> <ZW94T8Fx2eJpwKQS@google.com>
	 <fc09fec34a89ba7655f344a31174d078a8248182.camel@redhat.com>
	 <ZW-7Mwev4Ilf541L@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 2023-12-05 at 16:07 -0800, Sean Christopherson wrote:
> On Tue, Dec 05, 2023, Maxim Levitsky wrote:
> > On Tue, 2023-12-05 at 11:21 -0800, Sean Christopherson wrote:
> > > On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > > > On Fri Dec 1, 2023 at 5:47 PM UTC, Sean Christopherson wrote:
> > > > > On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > > > > > On Fri Dec 1, 2023 at 4:32 PM UTC, Sean Christopherson wrote:
> > > > > > > On Fri, Dec 01, 2023, Nicolas Saenz Julienne wrote:
> > > > > > > > > To support this I think that we can add a userspace msr filter on the HV_X64_MSR_HYPERCALL,
> > > > > > > > > although I am not 100% sure if a userspace msr filter overrides the in-kernel msr handling.
> > > > > > > > 
> > > > > > > > I thought about it at the time. It's not that simple though, we should
> > > > > > > > still let KVM set the hypercall bytecode, and other quirks like the Xen
> > > > > > > > one.
> > > > > > > 
> > > > > > > Yeah, that Xen quirk is quite the killer.
> > > > > > > 
> > > > > > > Can you provide pseudo-assembly for what the final page is supposed to look like?
> > > > > > > I'm struggling mightily to understand what this is actually trying to do.
> > > > > > 
> > > > > > I'll make it as simple as possible (diregard 32bit support and that xen
> > > > > > exists):
> > > > > > 
> > > > > > vmcall             <-  Offset 0, regular Hyper-V hypercalls enter here
> > > > > > ret
> > > > > > mov rax,rcx  <-  VTL call hypercall enters here
> > > > > 
> > > > > I'm missing who/what defines "here" though.  What generates the CALL that points
> > > > > at this exact offset?  If the exact offset is dictated in the TLFS, then aren't
> > > > > we screwed with the whole Xen quirk, which inserts 5 bytes before that first VMCALL?
> > > > 
> > > > Yes, sorry, I should've included some more context.
> > > > 
> > > > Here's a rundown (from memory) of how the first VTL call happens:
> > > >  - CPU0 start running at VTL0.
> > > >  - Hyper-V enables VTL1 on the partition.
> > > >  - Hyper-V enabled VTL1 on CPU0, but doesn't yet switch to it. It passes
> > > >    the initial VTL1 CPU state alongside the enablement hypercall
> > > >    arguments.
> > > >  - Hyper-V sets the Hypercall page overlay address through
> > > >    HV_X64_MSR_HYPERCALL. KVM fills it.
> > > >  - Hyper-V gets the VTL-call and VTL-return offset into the hypercall
> > > >    page using the VP Register HvRegisterVsmCodePageOffsets (VP register
> > > >    handling is in user-space).
> > > 
> > > Ah, so the guest sets the offsets by "writing" HvRegisterVsmCodePageOffsets via
> > > a HvSetVpRegisters() hypercall.
> > 
> > No, you didn't understand this correctly. 
> > 
> > The guest writes the HV_X64_MSR_HYPERCALL, and in the response hyperv fills
> 
> When people say "Hyper-V", do y'all mean "root partition"?  
> If so, can we just
> say "root partition"?  Part of my confusion is that I don't instinctively know
> whether things like "Hyper-V enables VTL1 on the partition" are talking about the
> root partition (or I guess parent partition?) or the hypervisor.  Functionally it
> probably doesn't matter, it's just hard to reconcile things with the TLFS, which
> is written largely to describe the hypervisor's behavior.
> 
> > the hypercall page, including the VSM thunks.
> > 
> > Then the guest can _read_ the offsets, hyperv chose there by issuing another hypercall. 
> 
> Hrm, now I'm really confused.  Ah, the TLFS contradicts itself.  The blurb for
> AccessVpRegisters says:
> 
>   The partition can invoke the hypercalls HvSetVpRegisters and HvGetVpRegisters.
> 
> And HvSetVpRegisters confirms that requirement:
> 
>   The caller must either be the parent of the partition specified by PartitionId,
>   or the partition specified must be “self” and the partition must have the
>   AccessVpRegisters privilege
> 
> But it's absent from HvGetVpRegisters:
> 
>   The caller must be the parent of the partition specified by PartitionId or the
>   partition specifying its own partition ID.

Yes, it is indeed very strange, that a partition would do a hypercall to read its own
registers - but then the 'register' is also not really a register but more of a 'hack', and I guess
they allowed it in this particular case. That is why I wrote the 'another hypercall'
thing, because it is very strange that they (ab)used the HvGetVpRegisters for that.


But regardless of the above, guests (root partition or any other partition) do the
VTL calls, and in order to do a VTL call, that guest has to know the hypercall page offsets,
and for that the guest has to do the HvGetVpRegisters hypercall first.

> 
> > In the current implementation, the offsets that the kernel choose are first
> > exposed to the userspace via new ioctl, and then the userspace exposes these
> > offsets to the guest via that 'another hypercall' (reading a pseudo partition
> > register 'HvRegisterVsmCodePageOffsets')
> > 
> > I personally don't know for sure anymore if the userspace or kernel based
> > hypercall page is better here, it's ugly regardless :(
> 
> Hrm.  Requiring userspace to intercept the WRMSR will be a mess because then KVM
> will have zero knowledge of the hypercall page, e.g. userspace would be forced to
> intercept HV_X64_MSR_GUEST_OS_ID as well.
>   That's not the end of the world, but
> it's not exactly ideal either.
> 
> What if we exit to userspace with a new kvm_hyperv_exit reason that requires
> completion? 

BTW the other option is to do the whole thing in kernel - the offset bug in the hypercall page
can be easily solved with a variable, and then the kernel can also intercept the HvGetVpRegisters
hypercall and return these offsets for HvRegisterVsmCodePageOffsets, and for all
other VP registers it can still exit to userspace - that way we also avoid adding a new ioctl,
and have the whole thing in one place.

All of the above can even be done unconditionally (or be conditionally tied to a Kconfig option),
because it doesn't add much overhead and neither should break backward compatibility - I don't think
hyperv guests rely on hypervisor not touching the hypercall page beyond the few bytes that KVM
does write currently.

Best regards,
	Maxim Levitsky


>  I.e. punt to userspace if VSM is enabled, but still record the data
> in KVM?  Ugh, but even that's a mess because kvm_hv_set_msr_pw() is deep in the
> WRMSR emulation call stack and can't easily signal that an exit to userspace is
> needed.  Blech.
> 



