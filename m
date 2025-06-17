Return-Path: <kvm+bounces-49728-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5635ADD5BE
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:25:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B317F1944992
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 16:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D492EF2A0;
	Tue, 17 Jun 2025 16:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E5GvQz/U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA0C2DFF06
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 16:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176614; cv=none; b=IrQixH8/drqfrA8hO5O6FbLXQlOHG+8iZC0ZGeEnDXTlVcQIYFPp+sdqQDdX44/exdwym/nQsEM/q+0RA9H7cGZM/I47oshmq7e+WhOjWdmkH6bSudOb3nDuIMbHOuXhCc8ExezBCkPEXR3SDvGuUSlJ0rMxD4VkvPRhvGOaP34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176614; c=relaxed/simple;
	bh=tZ+fZ2k1EPsBMGXOim/2G6gz3Iic+QUqPhsBrJ7hjss=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BLDdoeU/0yG0u/x3iHFfqDsrZ5OakADgbjzS3TaCw0c64I39UuIWVmoeR3oJ0gDJ7XTRWsJ5SBvR/A0X+CZgtNKr7PXx2I8ppcIdEYs4dsSuZzpWmpmF1xXQ0pwrZLL0ym774lVDcBOl3ELoKgLZNGmR/oYVf+I0TsoNPjLs58I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=E5GvQz/U; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313c3915345so7711925a91.3
        for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750176612; x=1750781412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mpe9oKaiEbfB05dXqSqSLq6O1r6s9FrJ+B97+HDCer0=;
        b=E5GvQz/UDF8Y7tFZyWAWhDVTwT7OcvyWAHkHfN5VWKzQt/so0SezLB4WNWlZ3yKQ4w
         EsG3Hbe9jprWrrXbASnzBeRALIOpZAQ5ptsMvraw4qCXJNGgJIb82KiC2IVnuIllu0t0
         VRLZo1pGCdG8yIggKvn390V81MhR11fSWkZ2L3VWKNaoB1beSfGAWL2jNG+P/Vq9ybqy
         rI5N3HqgBuaaABGkwTBwJ+ZpxbyqmCbHwk50pRkf3V8AF/YUtcTrSFtUJBeSVi7jWBU2
         C73LM7CBGpcg5Oyj/z0uZYiGnZzcFmHGluPO0RfnaD7f6awX1ZeNlgOO9vNokJd9tpRW
         0twA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750176612; x=1750781412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mpe9oKaiEbfB05dXqSqSLq6O1r6s9FrJ+B97+HDCer0=;
        b=UhjREar9Eq3fw+r/ZMLAzW7ziVP9q/xwSxMlRyNcuI/9IedKt1/L12INlUsMjciGcT
         9hgMfqZl+dP7vj5XJPTNxmWB3KByHsQk1+rmXRvdLylVkbsc7LoP/Ljh8yldCwSivTq1
         dulrZqKDVx6a9SHTwPCiEnWJQycRmgzSupevPqws3DKOCNyfThdLWl5CholEgZhvk05w
         T3kU4OlzjFbu2Q6dxjJGdaKrAISQ2Mnn5HIejzSAMPLuBTa0V/RoCk5sfRConnTnGQw+
         /1kzPMagrfXMpAN6wZzv3xsQEzEEOvrLvx6x+sDZQOyTcBPjoTGf0lLqS5sQsM5AFRsM
         +xcw==
X-Forwarded-Encrypted: i=1; AJvYcCWItnJKDn6IgpO4zwEEMMX/s1ma4ZrKWcJlFUnk6mmUqs3j1oUKcE7CNJ9Gj/1L0zwLgLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbz1ePSqPejUFCB1ZxfNicCaw6Dqm1qWI1QvjqpDqQhB824LEg
	bMoYTjxUV+mcd59VA0pAoz1i6ZPiRC0wCO9T9dCm+U8ieUd24y28cs7aXiU6uNtcOQZM23N+6Qh
	Z1htPaw==
X-Google-Smtp-Source: AGHT+IFq1bSy5ue6p5VOY2+WKnKKimaXelT5uMjgsHODbKGY/Q+ifAgtUVMh8UXZFapv6bjOQtBJ96fEnfQ=
X-Received: from pjl7.prod.google.com ([2002:a17:90b:2f87:b0:311:b3fb:9f74])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cd:b0:312:1ae9:152b
 with SMTP id 98e67ed59e1d1-313f1d12fe0mr17819830a91.23.1750176611703; Tue, 17
 Jun 2025 09:10:11 -0700 (PDT)
Date: Tue, 17 Jun 2025 09:10:10 -0700
In-Reply-To: <bmx43lru6mwdyun3ktcmoeezqw6baih7vgtykolsrmu5q2x7vu@xp5jrbbqwzej>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-14-seanjc@google.com>
 <bmx43lru6mwdyun3ktcmoeezqw6baih7vgtykolsrmu5q2x7vu@xp5jrbbqwzej>
Message-ID: <aFGTYoxlLhZsiMUC@google.com>
Subject: Re: [PATCH v3 12/62] KVM: SVM: Inhibit AVIC if ID is too big instead
 of rejecting vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 17, 2025, Naveen N Rao wrote:
> On Wed, Jun 11, 2025 at 03:45:15PM -0700, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > index ab228872a19b..f0a74b102c57 100644
> > --- a/arch/x86/kvm/svm/avic.c
> > +++ b/arch/x86/kvm/svm/avic.c
> > @@ -277,9 +277,19 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
> >  	int id = vcpu->vcpu_id;
> >  	struct vcpu_svm *svm = to_svm(vcpu);
> >  
> > +	/*
> > +	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
> > +	 * hardware.  Immediately clear apicv_active, i.e. don't wait until the
> > +	 * KVM_REQ_APICV_UPDATE request is processed on the first KVM_RUN, as
> > +	 * avic_vcpu_load() expects to be called if and only if the vCPU has
> > +	 * fully initialized AVIC.
> > +	 */
> >  	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
> > -	    (id > X2AVIC_MAX_PHYSICAL_ID))
> > -		return -EINVAL;
> > +	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
> > +		kvm_set_apicv_inhibit(vcpu->kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_TOO_BIG);
> > +		vcpu->arch.apic->apicv_active = false;
> 
> This bothers me a bit. kvm_create_lapic() does this:
>           if (enable_apicv) {
>                   apic->apicv_active = true;
>                   kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
> 	  }
> 
> But, setting apic->apicv_active to false here means KVM_REQ_APICV_UPDATE 
> is going to be a no-op.

That's fine, KVM_REQ_APICV_UPDATE is a nop in other scenarios, too.  I agree it's
not ideal, but this is a rather extreme edge case and a one-time slow path, so I
don't think it's worth doing anything special just to avoid KVM_REQ_APICV_UPDATE.

> This does not look to be a big deal given that kvm_create_lapic() itself 
> is called just a bit before svm_vcpu_create() (which calls the above 
> function through avic_init_vcpu()) in kvm_arch_vcpu_create(), so there 
> isn't that much done before apicv_active is toggled.
> 
> But, this made me wonder if introducing a kvm_x86_op to check and 
> enable/disable apic->apicv_active in kvm_create_lapic() might be cleaner 
> overall

Hmm, yes and no.  I completely agree that clearing apicv_active in avic.c is all
kinds of gross, but clearing apic->apicv_active in lapic.c to handle this particular
scenario is just as problematic, because then avic_init_backing_page() would need
to check kvm_vcpu_apicv_active() to determine whether or not to allocate the backing
page.  In a way, that's even worse, because setting apic->apicv_active by default
is purely an optimization, i.e. leaving it %false _should_ work as well, it would
just be suboptimal.  But if AVIC were to key off apic->apicv_active, that could
lead to KVM incorrectly skipping allocation of the AVIC backing page.

> Maybe even have it be the initialization point for APICv: 
> apicv_init(), so we can invoke avic_init_vcpu() right away?

I mostly like this idea (actually, I take that back; see below), but VMX throws
a big wrench in things.  Unlike SVM, VMX doesn't have a singular "enable APICv"
flag.  Rather, KVM considers "APICv" to be the combination of APIC-register
virtualization, virtual interrupt delivery, and posted interrupts.

Which is totally fine.  The big wrench is that the are other features that interact
with "APICv" and require allocations.  E.g.  the APIC access page isn't actually
tied to enable_apicv, it's tied to yet another VMX feature, "virtualize APIC
accesses" (not to be confused with APIC-register virtualization; don't blame me,
I didn't create the control knobs/names).

As a result, KVM may need to allocate the APIC access page (not to be confused
with the APIC *backing* page; again, don't blame me :-D) when enable_apicv=false,
and even more confusingly, NOT allocate the APIC access page when enable_apicv=true.

	if (cpu_need_virtualize_apic_accesses(vcpu)) {  <=== not an enable_apic check, *sigh*
		err = kvm_alloc_apic_access_page(vcpu->kvm);
		if (err)
			goto free_vmcs;
	}

And for both SVM and VMX, IPI virtualization adds another wrinkle, in that the
per-vCPU setup needs to fill an entry in a per-VM table.  And filling that entry
needs to happen at the very end of vCPU creation, e.g. so that the vCPU can't be
targeted until KVM is ready to run the vCPU.

Ouch.  And I'm pretty sure there's a use-after-free in the AVIC code.  If
svm_vcpu_alloc_msrpm() fails, the avic_physical_id_table[] will still have a pointer
to freed vAPIC page.

Thus, invoking avic_init_vcpu() "right away" is unfortunately flat out unsafe
(took me a while to realize that).

So while I 100% agree with your dislike of this patch, I think it's the least
awful band-aid, at least in the short term.

Longer term, I'd definitely be in favor of cleaning up the related flows, but I
think that's best done on top of this series, because I suspect it'll be somewhat
invasive.

