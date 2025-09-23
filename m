Return-Path: <kvm+bounces-58595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EE1FB97405
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 20:55:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B693E32088F
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:55:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6803302172;
	Tue, 23 Sep 2025 18:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xpM08QLW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C832D59F7
	for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 18:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758653748; cv=none; b=SARCLPQUHnuCMDtf4R+99tuZmwmL5WW5PbaALvqpTU3FO2J+rHMlEg5YGOajok9PTU/bac0u78DkaRP/h/822zTXNdrw3RwcV0h9mQwUsIL8IN8UHEOUin94PgdMC2tyqe8GEP9nnljQM7019/NYIdUjA1mixC1l77M8nUu4J80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758653748; c=relaxed/simple;
	bh=LLCA3eHwgHle6/iRRGE9AMFJM0Dss9KsHSuojAzEvug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HZkWFNIe+1wAPTZrgVMMA3l9jC3T9BpMCmB5+IHvofkGQRakYx11dwsdJvoz18+4oR0QfCIdYm6Z+g+ayxaWd9ECpgz584lAw/eME4f06/nPTHNa9xn5vHucz/9IaxV6BZ/ZUgHfDFnkUTip/jLAU7t/OeNGqJOMwp41zoJdG9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xpM08QLW; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77f3998c607so3601575b3a.1
        for <kvm@vger.kernel.org>; Tue, 23 Sep 2025 11:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758653746; x=1759258546; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=64Tb0UtRymHWNSKcGNGEibZRf7V4wY076R1Uryq0wJc=;
        b=xpM08QLWKR3WosjhTNW2j/+2wJRZIxDOEt8TaCwdbuYpVwH68W+QovUo/re87VyRL7
         P20BhiM4eG2SMdqh56k2N9qwRuESagWTcuKECMW/RvNigpBcszP2T15e1bKiT55WTjU/
         Fbl3kbspGEnt3qZY9jX8ZGeohUqZ0vHUtIz1ATu15aOK4IO8fMLhXvd2EKMlcCHLYWSv
         6+ENZfYgO5hug57smLkWPB9L/SXH1vfJNxDbGZ0JOgx4sb5NV7SURfu07nnIe4zupKFK
         WeImqOC14E94fabD9mdUU5CzowSx3p0AADmsQWWClIvM4vDDwim5nCBGxEweQ+iEq5O8
         /gDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758653746; x=1759258546;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64Tb0UtRymHWNSKcGNGEibZRf7V4wY076R1Uryq0wJc=;
        b=Bq6kN5DWmsX4ZSK0moQIfkzmleftbp6ArpvK5iDNy5JLppHHkhkEUA1PbsWoo6fo5v
         RIFp3PGcc+uf2nDX1NXILk4a1D0zUiPMpC5HRt08H0JQQYkUgDPr6HQe/WwFgCElvswH
         BBX0POot4iN5m2sMcDLVVAYI3BQAv4NxxEzPWn22IqQpteC5jpBQ0iBtzpxdEDY3nmRx
         R2pUyzvysKokO/iedrPh1BH7UR+rDpDi4kMshZPM4bIxXyXssN8D0Ch6Ixe8esMy+wui
         jJf60fFk3og1EfQdlepybV6byA/qrFWqshPK2OWsozEC7fvwb74fg33H9/5expuewwf2
         vzYg==
X-Forwarded-Encrypted: i=1; AJvYcCUnR2yomcEYrSoYoWXVCregeXf16y/zPS8MZrpyO3cEUYJCF4hznUiQ+mX57akFzxjqIrQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp+OH5U8w2GvUh1xsvgku3JLqssCaERSR/Xf6vlBR54qCBBMVn
	fPKDYBGJiJ0dP1o4MeifhGA7mz4eSQmMevKG24glgEw5lm5o5EvYrc/rRSqD+bYxC4KbdJwmVCa
	2ZcUNnw==
X-Google-Smtp-Source: AGHT+IEFKoTMqW3ZBSUC+7xU7rgYcYoI8KIAc0Yfk0u7tAjRZkaYdY7PJy/a8RlEIz3To4VwcxJe702x0pQ=
X-Received: from pfbld22.prod.google.com ([2002:a05:6a00:4f96:b0:771:ea87:e37d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d10:b0:76b:e868:eedd
 with SMTP id d2e1a72fcca58-77f53a77620mr5273284b3a.24.1758653745928; Tue, 23
 Sep 2025 11:55:45 -0700 (PDT)
Date: Tue, 23 Sep 2025 11:55:44 -0700
In-Reply-To: <7c7a5a75-a786-4a05-a836-4368582ca4c2@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250813192313.132431-1-mlevitsk@redhat.com> <20250813192313.132431-3-mlevitsk@redhat.com>
 <7c7a5a75-a786-4a05-a836-4368582ca4c2@redhat.com>
Message-ID: <aNLtMC-k95pIYfeq@google.com>
Subject: Re: [PATCH 2/3] KVM: x86: Fix a semi theoretical bug in kvm_arch_async_page_present_queued
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, 
	Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 23, 2025, Paolo Bonzini wrote:
> On 8/13/25 21:23, Maxim Levitsky wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 9018d56b4b0a..3d45a4cd08a4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -13459,9 +13459,14 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
> >   void kvm_arch_async_page_present_queued(struct kvm_vcpu *vcpu)
> >   {
> > -	kvm_make_request(KVM_REQ_APF_READY, vcpu);
> > -	if (!vcpu->arch.apf.pageready_pending)
> > +	/* Pairs with smp_store_release in vcpu_enter_guest. */
> > +	bool in_guest_mode = (smp_load_acquire(&vcpu->mode) == IN_GUEST_MODE);
> > +	bool page_ready_pending = READ_ONCE(vcpu->arch.apf.pageready_pending);
> > +
> > +	if (!in_guest_mode || !page_ready_pending) {
> > +		kvm_make_request(KVM_REQ_APF_READY, vcpu);
> >   		kvm_vcpu_kick(vcpu);
> > +	}
> 
> Unlike Sean, I think the race exists in abstract and is not benign

How is it not benign?  I never said the race doesn't exist, I said that consuming
a stale vcpu->arch.apf.pageready_pending in kvm_arch_async_page_present_queued()
is benign.

