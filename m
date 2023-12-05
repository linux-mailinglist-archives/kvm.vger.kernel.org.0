Return-Path: <kvm+bounces-3478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70198804FB1
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B76F7B20CFD
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7314C3B5;
	Tue,  5 Dec 2023 10:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Marm9RDD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68658A0
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701770536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YZXF7waANU5+mhguvuvh8JxjfsSebRKaX6sLaLZrogE=;
	b=Marm9RDDfC8VcOWe21q6dRlhRPF283iN0TBVjSq6KxdIwS51GCMgJvQB8l0zZreqVNuXgY
	+LHWQ3/cKON+GpnMep1Np69pfU2CKCxZPfWbWYfT+l6r5hd75x1eoSducmratsuK9SQEEu
	txeFjAs1L7yCG/rTz2rmWfxTUAbVP0M=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-147-4-9dJqT5MiWnPVYU6OwsZQ-1; Tue, 05 Dec 2023 05:02:14 -0500
X-MC-Unique: 4-9dJqT5MiWnPVYU6OwsZQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-40b40234bd5so37860475e9.0
        for <kvm@vger.kernel.org>; Tue, 05 Dec 2023 02:02:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701770533; x=1702375333;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YZXF7waANU5+mhguvuvh8JxjfsSebRKaX6sLaLZrogE=;
        b=NH0orpvd1ZKutT4aF43uS6XlSjINWbP+R8/cAbHxLBqrEjV06DD3DWzojftA+IOl57
         vj5IzCiKK7gBA6YYwM3a5hJIGS2q1O6ZkJy+Haz8sChtBQF2mNji0RTjvw1OmWfDP2Gk
         JLgI4omDQK6F3H3tByf7Ae5M4SqSBvtWACHagCJKKZDhswMMPCvD9jxqVGQskFSXept8
         gX/+FS0Oe1KA/jOPxl2+65O36est+VcNzzES+eIco3PDQUYQrBGPGCPEjPlercA1cKJS
         SvMJCafNDwSXS+QkVKPf8oaOIJ80+E9RTfqgFo7YjdKh23Vt4xGQc1s/bmrh0VhYs1NS
         JcTQ==
X-Gm-Message-State: AOJu0YxRwm5Y7cqROhsLrXMbHYjPCFur8CuLjcjB+HPK/J+LHchUoDr6
	FpTItXthEoK8dyPIMISaZhhYsG8wu1XY/qzkFmriSR/ST7rjlz1WgOW0QtxFaas4wYg5EZNZ384
	G7pbC5CuPgHh3
X-Received: by 2002:a05:600c:4593:b0:3fe:4cbc:c345 with SMTP id r19-20020a05600c459300b003fe4cbcc345mr297116wmo.41.1701770533521;
        Tue, 05 Dec 2023 02:02:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHkyh6uz8tLTANh12Tdqz9NiKwahRoAQySUBBbY1KeDQe3kryYq6CKsi25SwLURKdLaHjSVWQ==
X-Received: by 2002:a05:600c:4593:b0:3fe:4cbc:c345 with SMTP id r19-20020a05600c459300b003fe4cbcc345mr297101wmo.41.1701770533112;
        Tue, 05 Dec 2023 02:02:13 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id f11-20020a1c6a0b000000b0040523bef620sm497429wmc.0.2023.12.05.02.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 02:02:12 -0800 (PST)
Message-ID: <4f07482c7117b9d27b352621577d78e29ae951b7.camel@redhat.com>
Subject: Re: [PATCH v7 21/26] KVM: x86: Save and reload SSP to/from SMRAM
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, Chao Gao <chao.gao@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, dave.hansen@intel.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	rick.p.edgecombe@intel.com, john.allen@amd.com
Date: Tue, 05 Dec 2023 12:02:11 +0200
In-Reply-To: <7531921a-e7b2-4027-86c4-75fc91a45f26@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-22-weijiang.yang@intel.com>
	 <d2be8a787969b76f71194ce65bd6f35426b60dcc.camel@redhat.com>
	 <ZWlDhYBYGiX7ir4X@chao-email>
	 <7531921a-e7b2-4027-86c4-75fc91a45f26@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2023-12-04 at 08:45 +0800, Yang, Weijiang wrote:
> On 12/1/2023 10:23 AM, Chao Gao wrote:
> > On Thu, Nov 30, 2023 at 07:42:44PM +0200, Maxim Levitsky wrote:
> > > On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> > > > Save CET SSP to SMRAM on SMI and reload it on RSM. KVM emulates HW arch
> > > > behavior when guest enters/leaves SMM mode,i.e., save registers to SMRAM
> > > > at the entry of SMM and reload them at the exit to SMM. Per SDM, SSP is
> > > > one of such registers on 64bit Arch, so add the support for SSP.
> > > > 
> > > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > ---
> > > >   arch/x86/kvm/smm.c | 8 ++++++++
> > > >   arch/x86/kvm/smm.h | 2 +-
> > > >   2 files changed, 9 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
> > > > index 45c855389ea7..7aac9c54c353 100644
> > > > --- a/arch/x86/kvm/smm.c
> > > > +++ b/arch/x86/kvm/smm.c
> > > > @@ -275,6 +275,10 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu,
> > > >   	enter_smm_save_seg_64(vcpu, &smram->gs, VCPU_SREG_GS);
> > > >   
> > > >   	smram->int_shadow = static_call(kvm_x86_get_interrupt_shadow)(vcpu);
> > > > +
> > > > +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> > > > +		KVM_BUG_ON(kvm_msr_read(vcpu, MSR_KVM_SSP, &smram->ssp),
> > > > +			   vcpu->kvm);
> > > >   }
> > > >   #endif
> > > >   
> > > > @@ -564,6 +568,10 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
> > > >   	static_call(kvm_x86_set_interrupt_shadow)(vcpu, 0);
> > > >   	ctxt->interruptibility = (u8)smstate->int_shadow;
> > > >   
> > > > +	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
> > > > +		KVM_BUG_ON(kvm_msr_write(vcpu, MSR_KVM_SSP, smstate->ssp),
> > > > +			   vcpu->kvm);
> > > > +
> > > >   	return X86EMUL_CONTINUE;
> > > >   }
> > > >   #endif
> > > > diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
> > > > index a1cf2ac5bd78..1e2a3e18207f 100644
> > > > --- a/arch/x86/kvm/smm.h
> > > > +++ b/arch/x86/kvm/smm.h
> > > > @@ -116,8 +116,8 @@ struct kvm_smram_state_64 {
> > > >   	u32 smbase;
> > > >   	u32 reserved4[5];
> > > >   
> > > > -	/* ssp and svm_* fields below are not implemented by KVM */
> > > >   	u64 ssp;
> > > > +	/* svm_* fields below are not implemented by KVM */
> > > >   	u64 svm_guest_pat;
> > > >   	u64 svm_host_efer;
> > > >   	u64 svm_host_cr4;
> > > 
> > > My review feedback from the previous patch series still applies, and I don't
> > > know why it was not addressed/replied to:
> > > 
> > > I still think that it is worth it to have a check that CET is not enabled in
> > > enter_smm_save_state_32 which is called for pure 32 bit guests (guests that don't
> > > have X86_FEATURE_LM enabled)
> > can KVM just reject a KVM_SET_CPUID ioctl which attempts to expose shadow stack
> > (or even any CET feature) to 32-bit guest in the first place? I think it is simpler.
> 
> I favor adding an early defensive check for the issue under discussion if we want to handle the case.
> Crashing the VM at runtime when guest SMI is kicked seems not user friendly.
> 

I don't mind. I remember that I was told that crashing a guest when #SMI arrives and a nested guest is running
is ok for 32 bit guests, don't know what the justification was.
Sean, Paolo, do you remember?

IMHO the chances of pure 32 bit guest (only qemu-system-386 creates these) running with CET are very low,
but I just wanted to have a cheap check just to keep the 32 bit and 64 bit smm save/restore code similar,
so that nobody in the future will ask 'why this code does this or that'.

Also it is trivial to add the ssp to 32 bit smmram image - the layout is not really compliant to x86 spec,
and never consumed by the hardware, you can just put it somewhere in the image, instead of one of the reserved fields.

From my point of view I want the code to be as orthogonal as possible.

Best regards,
	Maxim Levitsky





