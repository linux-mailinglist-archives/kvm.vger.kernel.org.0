Return-Path: <kvm+bounces-3919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9418880A733
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 16:20:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C47391C20382
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 15:20:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3646A30337;
	Fri,  8 Dec 2023 15:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="czmw8vXO"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C2310C8
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 07:20:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702048813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gQ5r27WTNi1tlXFNvyLVJ6+tXAR6kKSZwKnBBPrryVU=;
	b=czmw8vXOm7vEQ/Yfv/ElDRxduV1RR5xRH2SwNyNRXL1oEu00SovTMkfhU2mU83QsxNUqYR
	MXvRydH/s9kN2Z5sjhbAnrX6ldGwPipzy8YcaqBYFg7o4aBYeLvlnAnq09SB1yLpoGZ1h+
	AaKgUh4bE0cuVN3KAAYmyRUGifSfwcI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-MNtcvlNLOFS-PpAJtv6AKw-1; Fri, 08 Dec 2023 10:20:11 -0500
X-MC-Unique: MNtcvlNLOFS-PpAJtv6AKw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-334adbe43acso1365311f8f.0
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 07:20:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702048810; x=1702653610;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gQ5r27WTNi1tlXFNvyLVJ6+tXAR6kKSZwKnBBPrryVU=;
        b=V1qCGHQ290A0BduSeORS7lhGTpsi5bDooZ2i7nRiNftazGu16rqtN4PovL0QSlO76X
         1zOr+bQFsWsYcyex8z8cUpKtGqQvVRcVjI4Tin/5PV62c5xi+Cx85ixUsu6sTyVZnNS7
         FLrL3Vn3T80YpGp2ac2cMxZgqbkZbE2KzI4UZ7AJwiRxPlXVbh4B8WsyEE7XuA1h2rAF
         cFNNgbcKEPEj8aWVfwiSIQS4m/wv6RbxmR9zCPzEIYngZgNR3Z7tcnWU4QixFQcFdLax
         9hB99+XriOf4JYONPdmFBBVx8Me7N7+0HdVKL8Iy0t1W8gYIpqHahUyEsEOx1EHWEU1w
         fZAQ==
X-Gm-Message-State: AOJu0YxBo9jMKhk4fZWeWI/pA7gZjMmTJx/Ytj2nog6d+L7crGskVkj6
	fND/3b15IsdyNJIvlaeb0VSBq/lPK+sQk1gJKtBsLh5G96IqbSLROqLMOTzP8oltkVQv1+Rt6s4
	+Z0mXI9N9LCYB
X-Received: by 2002:a05:600c:4e4f:b0:40c:23e0:7dad with SMTP id e15-20020a05600c4e4f00b0040c23e07dadmr158559wmq.168.1702048810530;
        Fri, 08 Dec 2023 07:20:10 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEcPJRbzsB3vyWAQnpo4WFhSNjU+T5FUkhLcEtq0DNBmKLN16Ty0vOof9ojkND/sMr3DezBfw==
X-Received: by 2002:a05:600c:4e4f:b0:40c:23e0:7dad with SMTP id e15-20020a05600c4e4f00b0040c23e07dadmr158550wmq.168.1702048810172;
        Fri, 08 Dec 2023 07:20:10 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c510b00b0040a3f9862e3sm1583317wms.1.2023.12.08.07.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Dec 2023 07:20:09 -0800 (PST)
Message-ID: <3663aa04f6c3002d47362f3877d96c0e18bc163e.camel@redhat.com>
Subject: Re: [PATCH v2 for-8.2?] i386/sev: Avoid SEV-ES crash due to missing
 MSR_EFER_LMA bit
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, Marcelo
 Tosatti <mtosatti@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, kvm@vger.kernel.org
Date: Fri, 08 Dec 2023 17:20:08 +0200
In-Reply-To: <20231206174235.b7fwrqzko27of7qz@amd.com>
References: <20231205222816.1152720-1-michael.roth@amd.com>
	 <9eae0513c912faa04a11db378ea3ca176ab45f0d.camel@redhat.com>
	 <20231206174235.b7fwrqzko27of7qz@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-12-06 at 11:42 -0600, Michael Roth wrote:
> On Wed, Dec 06, 2023 at 07:20:14PM +0200, Maxim Levitsky wrote:
> > On Tue, 2023-12-05 at 16:28 -0600, Michael Roth wrote:
> > > Commit 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> > > added error checking for KVM_SET_SREGS/KVM_SET_SREGS2. In doing so, it
> > > exposed a long-running bug in current KVM support for SEV-ES where the
> > > kernel assumes that MSR_EFER_LMA will be set explicitly by the guest
> > > kernel, in which case EFER write traps would result in KVM eventually
> > > seeing MSR_EFER_LMA get set and recording it in such a way that it would
> > > be subsequently visible when accessing it via KVM_GET_SREGS/etc.
> > > 
> > > However, guests kernels currently rely on MSR_EFER_LMA getting set
> > > automatically when MSR_EFER_LME is set and paging is enabled via
> > > CR0_PG_MASK. As a result, the EFER write traps don't actually expose the
> > > MSR_EFER_LMA even though it is set internally, and when QEMU
> > > subsequently tries to pass this EFER value back to KVM via
> > > KVM_SET_SREGS* it will fail various sanity checks and return -EINVAL,
> > > which is now considered fatal due to the aforementioned QEMU commit.
> > > 
> > > This can be addressed by inferring the MSR_EFER_LMA bit being set when
> > > paging is enabled and MSR_EFER_LME is set, and synthesizing it to ensure
> > > the expected bits are all present in subsequent handling on the host
> > > side.
> > > 
> > > Ultimately, this handling will be implemented in the host kernel, but to
> > > avoid breaking QEMU's SEV-ES support when using older host kernels, the
> > > same handling can be done in QEMU just after fetching the register
> > > values via KVM_GET_SREGS*. Implement that here.
> > > 
> > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > Cc: Marcelo Tosatti <mtosatti@redhat.com>
> > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: Akihiko Odaki <akihiko.odaki@daynix.com>
> > > Cc: kvm@vger.kernel.org
> > > Fixes: 7191f24c7fcf ("accel/kvm/kvm-all: Handle register access errors")
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > > v2:
> > >   - Add handling for KVM_GET_SREGS, not just KVM_GET_SREGS2
> > > 
> > >  target/i386/kvm/kvm.c | 14 ++++++++++++++
> > >  1 file changed, 14 insertions(+)
> > > 
> > > diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> > > index 11b8177eff..8721c1bf8f 100644
> > > --- a/target/i386/kvm/kvm.c
> > > +++ b/target/i386/kvm/kvm.c
> > > @@ -3610,6 +3610,7 @@ static int kvm_get_sregs(X86CPU *cpu)
> > >  {
> > >      CPUX86State *env = &cpu->env;
> > >      struct kvm_sregs sregs;
> > > +    target_ulong cr0_old;
> > >      int ret;
> > >  
> > >      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS, &sregs);
> > > @@ -3637,12 +3638,18 @@ static int kvm_get_sregs(X86CPU *cpu)
> > >      env->gdt.limit = sregs.gdt.limit;
> > >      env->gdt.base = sregs.gdt.base;
> > >  
> > > +    cr0_old = env->cr[0];
> > >      env->cr[0] = sregs.cr0;
> > >      env->cr[2] = sregs.cr2;
> > >      env->cr[3] = sregs.cr3;
> > >      env->cr[4] = sregs.cr4;
> > >  
> > >      env->efer = sregs.efer;
> > > +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> > > +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> > > +            env->efer |= MSR_EFER_LMA;
> > > +        }
> > > +    }
> > 
> > I think that we should not check that CR0_PG has changed, and just blindly assume
> > that if EFER.LME is set and CR0.PG is set, then EFER.LMA must be set as defined in x86 spec.
> > 
> > Otherwise, suppose qemu calls kvm_get_sregs twice: First time it will work,
> > but second time CR0.PG will match one that is stored in the env, and thus the workaround
> > will not be executed, and instead we will revert back to wrong EFER value 
> > reported by the kernel.
> > 
> > How about something like that:
> > 
> > 
> > if (sev_es_enabled() && env->efer & MSR_EFER_LME && env->cr[0] & CR0_PG_MASK) {
> > 	/* 
> >          * Workaround KVM bug, because of which KVM might not be aware of the 
> >          * fact that EFER.LMA was toggled by the hardware 
> >          */
> > 	env->efer |= MSR_EFER_LMA;
> > }
> 
> Hi Maxim,
> 
> I'd already sent a v3 based on a similar suggestion from Paolo:
> 
>   https://lists.gnu.org/archive/html/qemu-devel/2023-12/msg00751.html
> 
> Does that one look okay to you?

Yep, thanks!

Best regards,
	Maxim Levitsky
> 
> Thanks,
> 
> Mike
> 
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > >  
> > >      /* changes to apic base and cr8/tpr are read back via kvm_arch_post_run */
> > >      x86_update_hflags(env);
> > > @@ -3654,6 +3661,7 @@ static int kvm_get_sregs2(X86CPU *cpu)
> > >  {
> > >      CPUX86State *env = &cpu->env;
> > >      struct kvm_sregs2 sregs;
> > > +    target_ulong cr0_old;
> > >      int i, ret;
> > >  
> > >      ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_SREGS2, &sregs);
> > > @@ -3676,12 +3684,18 @@ static int kvm_get_sregs2(X86CPU *cpu)
> > >      env->gdt.limit = sregs.gdt.limit;
> > >      env->gdt.base = sregs.gdt.base;
> > >  
> > > +    cr0_old = env->cr[0];
> > >      env->cr[0] = sregs.cr0;
> > >      env->cr[2] = sregs.cr2;
> > >      env->cr[3] = sregs.cr3;
> > >      env->cr[4] = sregs.cr4;
> > >  
> > >      env->efer = sregs.efer;
> > > +    if (sev_es_enabled() && env->efer & MSR_EFER_LME) {
> > > +        if (!(cr0_old & CR0_PG_MASK) && env->cr[0] & CR0_PG_MASK) {
> > > +            env->efer |= MSR_EFER_LMA;
> > > +        }
> > > +    }
> > >  
> > >      env->pdptrs_valid = sregs.flags & KVM_SREGS2_FLAGS_PDPTRS_VALID;
> > >  



