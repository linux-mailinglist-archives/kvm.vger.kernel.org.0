Return-Path: <kvm+bounces-61176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EFF85C0ED1E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 90FED4EDE34
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 15:02:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32F0830B522;
	Mon, 27 Oct 2025 15:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cnbGfecW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13703019A3
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761577262; cv=none; b=u52bagvOmkMSD+qj5f3gLS0n9/Yyws2BK2Y0+C2m5bQ9bnruRrCLYc9X/9H3vQL4kXSWQXVmxJyyAuZDJay6Ni5kKOF0BXWyOkla+r4HyAH2QivO4QC/wukPoEM/fvyTGD1Ukv6EgrfjSSUdT2di71sl8X5kt7KnDmgWiF/AYQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761577262; c=relaxed/simple;
	bh=Oqb/ykPQwKXmqMnKoREOo5RxBIsJusI36AyJHETL69A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZiUHN/VsTQ3tXPAe/9NZwD0KggzC3OYp4/cwaDXgAhdCt+RMbpOyxrkXhZMuwBP5WgIIBHEPaz/vsJ7hcFvDxlDMr0ELDpbsMztMNmabWcV+h5ZEoXdPFY0asTi8ZxmrFMVJkcBjUzFtHuSNDMs0R3PSESVx5QpygVIj7ZJA1hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cnbGfecW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bba464b08so4343982a91.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 08:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761577260; x=1762182060; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SDs1a8nS3uTGahV0ZmYqOOZW+k9DRkyEi9pQqEh63xk=;
        b=cnbGfecWXEm1EXBJlUZQhiclh5T3OcflWu9CXoCkyO9/4CpDSLBlltKWD1P+RKvJDD
         dBZt7VckYQk9DPF1txN4Y2CrRmp6AaYzY2lL+lp0dD5okUbqw9p+6AKlYrxmWy0b8HXQ
         geuhYSuu/MS5S5tdnrpcw0OPcSD5ZroGWh9vBlro+1ELhsQIs9h57fFWFOEFkQRIhLQ6
         5LrjK+8Ejye9YWW4SEfEqo1sBM0JFo/S1sGK/MCzC3dSx2R8PCDH/4/t+ihgZfM06dm4
         i3HI7PfqVC/oEMSax9Z48eeu8AMKrWQc7uwNu3ETactNANTIjiPFVKx7ZzanL5NfRdD3
         T4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761577260; x=1762182060;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDs1a8nS3uTGahV0ZmYqOOZW+k9DRkyEi9pQqEh63xk=;
        b=tV/SeQ8N4Cvr3spB9bi8qRaUwzM9twqKeTMndgbMjrUPCGeTiuncb2Wp4aasQrw9rb
         XvraJBhTBkxWjtijyiJeC936TQo02TCVg7RvVexNFdm9m7erotzbMHnZRrkj2L4BZ1oV
         sO0eW4JT3DWJ6YglCChKE0HREREGoofkkO47W3GKrAvm5uO9ve68PHr70RgZgBcmiQwb
         cV/SU1YARimLvC0HouW+p5sVaML1wJWNMf2napPTzdieEUbcE3nUH6xGUt7F3w7uqHUv
         a9bjfOl0DpdNCEq539UMsbMn00rneqSTOQKy7Y2c/8UdfjpGFipygZUK+XbJ7rWWC5Tv
         9fjg==
X-Forwarded-Encrypted: i=1; AJvYcCW0lYwTij5xB2tYVTMNf83/pl7X+bos5TyPRWnk2VCHS7p6iJb+yVTztMuuCE0WqmNB8i8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYJW76IARpGrX+VR2sElag5IEen9jTNCUzbduQirtW1RXA0qK0
	bszJ5M0iENSZvyxzCU89ka1X5/Kcvm5krih12RQ6WIb1sBYj/86s8mlCTpdVg2mEL4eFmZm8a3V
	DKDFfIw==
X-Google-Smtp-Source: AGHT+IFcTWECwsglXqgobA0NsEiSDzF8ic7uavux6KREgbBRTlsyfPZPh/tOYTH76scS6QSMy9xpZ6I4YFg=
X-Received: from pjbbd5.prod.google.com ([2002:a17:90b:b85:b0:330:49f5:c0b1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:58f0:b0:32e:2059:ee83
 with SMTP id 98e67ed59e1d1-340279e5f8bmr164106a91.7.1761577260155; Mon, 27
 Oct 2025 08:01:00 -0700 (PDT)
Date: Mon, 27 Oct 2025 08:00:58 -0700
In-Reply-To: <aNMpz96c9JOtPh-w@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250813192313.132431-1-mlevitsk@redhat.com> <20250813192313.132431-3-mlevitsk@redhat.com>
 <7c7a5a75-a786-4a05-a836-4368582ca4c2@redhat.com> <aNLtMC-k95pIYfeq@google.com>
 <23f11dc1-4fd1-4286-a69a-3892a869ed33@redhat.com> <aNMpz96c9JOtPh-w@google.com>
Message-ID: <aP-JKkZ400TERMSy@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present_queued
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, 
	Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Sean Christopherson wrote:
> On Tue, Sep 23, 2025, Paolo Bonzini wrote:
> > On 9/23/25 20:55, Sean Christopherson wrote:
> > > On Tue, Sep 23, 2025, Paolo Bonzini wrote:
> > > > On 8/13/25 21:23, Maxim Levitsky wrote:
> > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > index 9018d56b4b0a..3d45a4cd08a4 100644
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -13459,9 +13459,14 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> > > > >    void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
> > > > >    {
> > > > > -	kvm_make_request(KVM_REQ_APF_READY, vcpu);
> > > > > -	if (!vcpu->arch.apf.pageready_pending)
> > > > > +	/* Pairs with smp_store_release in vcpu_enter_guest. */
> > > > > +	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
> > > > > +	bool page_ready_pending = READ_ONCE(vcpu->arch.apf.pageready_pending);
> > > > > +
> > > > > +	if (!in_guest_mode || !page_ready_pending) {
> > > > > +		kvm_make_request(KVM_REQ_APF_READY, vcpu);
> > > > >    		kvm_vcpu_kick(vcpu);
> > > > > +	}
> > > > 
> > > > Unlike Sean, I think the race exists in abstract and is not benign
> > > 
> > > How is it not benign?  I never said the race doesn't exist, I said that consuming
> > > a stale vcpu->arch.apf.pageready_pending in kvm_arch_async_page_present_queued()
> > > is benign.
> > 
> > In principle there is a possibility that a KVM_REQ_APF_READY is missed.
> 
> I think you mean a kick (wakeup or IPI), is missed, not that the APF_READY itself
> is missed.  I.e. KVM_REQ_APF_READY will never be lost, KVM just might enter the
> guest or schedule out the vCPU with the flag set.
> 
> All in all, I think we're in violent agreement.  I agree that kvm_vcpu_kick()
> could be missed (theoretically), but I'm saying that missing the kick would be
> benign due to a myriad of other barriers and checks, i.e. that the vCPU is
> guaranteed to see KVM_REQ_APF_READY anyways.
> 
> E.g. my suggestion earlier regarding OUTSIDE_GUEST_MODE was to rely on the
> smp_mb__after_srcu_read_{,un}lock() barriers in vcpu_enter_guest() to ensure
> KVM_REQ_APF_READY would be observed before trying VM-Enter, and that if KVM might
> be in the process of emulating HLT (blocking), that either KVM_REQ_APF_READY is
> visible to the vCPU or that kvm_arch_async_page_present() wakes the vCPU.  Oh,
> hilarious, async_pf_execute() also does an unconditional __kvm_vcpu_wake_up().
> 
> Huh.  But isn't that a real bug?  KVM doesn't consider KVM_REQ_APF_READY to be a
> wake event, so isn't this an actual race?
> 
>   vCPU                                  async #PF
>   kvm_check_async_pf_completion()
>   pageready_pending = false
>   VM-Enter
>   HLT
>   VM-Exit
>                                         kvm_make_request(KVM_REQ_APF_READY, vcpu)
>                                         kvm_vcpu_kick(vcpu)  // nop as the vCPU isn't blocking, yet
>                                         __kvm_vcpu_wake_up() // nop for the same reason
>   vcpu_block()
>   <hang>
> 
> On x86, the "page ready" IRQ is only injected from vCPU context, so AFAICT nothing
> is guarnateed wake the vCPU in the above sequence.

Gah, KVM checks async_pf.done instead of the request.  So I don't think there's
a bug, just weird code.

  bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
  {
	if (!list_empty_careful(&vcpu->async_pf.done))  <===
		return true;

