Return-Path: <kvm+bounces-21234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 524B392C3E5
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 21:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D17D21F2389A
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 19:28:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81DFB182A76;
	Tue,  9 Jul 2024 19:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jnYN+9U5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F76C17B027
	for <kvm@vger.kernel.org>; Tue,  9 Jul 2024 19:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720553288; cv=none; b=MtIETNwfcHHBl7vqKe7WGiBAFVu2l51UTcvzAQAJWmA9aFea86InvlJ8uyELTCm4ZxAH0AtAPyax1U0g1qt/Rgooo6f+4cV6KCzib+XZZNDc8vK/MaiT1mihX7aLJBM1CzBG8aihxPLwQaCGO6gjA3VsJjOzmWJpR6mVI8fIT/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720553288; c=relaxed/simple;
	bh=tGk64PZTZhXihUtRm6IYWWYJazPp+3ZgAGpmSoZB3ro=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GEtiPdFreu39g8T++TELB3TRqGHpG6FvfI4nxKyZGk/lgEdMMNjxsN9b9Uv1lfMW1nG3fSfqlIN/eh0YeZfDkkkYbWPmi9b/8cHmEfZYld7zdzIwn/itM3pVC+iNy9rtyvRLFi+AKJnR8KRjSRpTokNbBzNIs/GViVLnCeVM/JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jnYN+9U5; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fb05b9e222so33174005ad.0
        for <kvm@vger.kernel.org>; Tue, 09 Jul 2024 12:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720553287; x=1721158087; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8BfHp9bQzvvOsKp2JilOmjO7TBNJLedjR/ZG6jBd2vA=;
        b=jnYN+9U5f9nJUmTLrypaEUgiP6tK+WF3Y3e1NveKBF8A65sOztA3VCIJj8cLxAhMko
         uFbuWgtrm1Ln62JPVM6XD4rCzgSNkVWI/DapXXa4bkENjzYuuoUiWSAFd3O+Oglfo5g8
         WCDW73vKsKoN1h2Y42vDY1aECaRF1SVxJIeiJmc14O7XY5cvuCGNQvcSim+qLQb3xwDw
         6U0POcugwlX8QTxPJxxe5b3wDG8L9Ko52t0aka12dP+MRnNXxiwe83qMF/bBcce29Z7N
         2xlPAiNuHLfk2ileCbDjs+UZQqf+Dn515UknkkV5wlkmj0kh8mg5dy8Q5Dja2mAxzAPo
         IzYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720553287; x=1721158087;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8BfHp9bQzvvOsKp2JilOmjO7TBNJLedjR/ZG6jBd2vA=;
        b=fYox/1iGu27D/Fy12o0BBTsnAA1t39ZabDIa0LDs6AQ/W6XFFaYISj7xc9JmRkXa8B
         dv9BlwL3sxGR4YRd+4bGT00SdK8DJNXCIt0oWcuep0ckfaYBEXu6dNvYw9YAXyxCb86A
         hLn+QLy2ZACiySwdK0agD7vWjr3ADy0W3jzKaI5VMv9Ew5P2DsKQV6iiKTUH4hm7zAo6
         AjxAm6vH/egOh14mPR/W23JynHkwgjM+tfvaVxIsP5h/vrY8nzwktLBpQN/TzwITx4rT
         4X4k5jSQCUfgR4lAUM/f0/Q6cNPc9ygswJj8rtqXV3QNGz3hGRIAr7v+zp8fb46kv4eP
         NQeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlWu08L7HYwuGwCRrVCp+FwkEuXc6ew6iSlIgNrSWvrFdJYAsNEwthC33koLb/oQTj9QDweH2+aC2jHjQSA2DUTa1u
X-Gm-Message-State: AOJu0YxrOKyNhdZtO5BG6c8QTZEIYsYKy1VJWxZAROgAXq1TiC156KfL
	q17g1xf6piWRvEoWo/CqONUoXcNzWpT47BcChENBjK0X+AZ1lHrSNc/6Hv7FST9Jt498Ha2QSdp
	OCA==
X-Google-Smtp-Source: AGHT+IGWhkiIz2Y2g3Ner7BOHEwPH6Z/gYQ/jE0/y9L37RbGyZJn6Z1cRXZGPxQRndFfUlsvmeisfjj31Zs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:2442:b0:1fa:13d8:a09c with SMTP id
 d9443c01a7336-1fbb6d601c4mr1788535ad.10.1720553286750; Tue, 09 Jul 2024
 12:28:06 -0700 (PDT)
Date: Tue, 9 Jul 2024 12:28:05 -0700
In-Reply-To: <924352564a5ab003b85bf7e2ee422907f9951e26.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240517173926.965351-1-seanjc@google.com> <20240517173926.965351-34-seanjc@google.com>
 <924352564a5ab003b85bf7e2ee422907f9951e26.camel@redhat.com>
Message-ID: <Zo2PRdv1KMf_Mgwj@google.com>
Subject: Re: [PATCH v2 33/49] KVM: x86: Advertise TSC_DEADLINE_TIMER in KVM_GET_SUPPORTED_CPUID
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Hou Wenlong <houwenlong.hwl@antgroup.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jul 04, 2024, Maxim Levitsky wrote:
> On Fri, 2024-05-17 at 10:39 -0700, Sean Christopherson wrote:
> >  4.47 KVM_PPC_GET_PVINFO
> >  -----------------------
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 699ce4261e9c..d1f427284ccc 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -680,8 +680,8 @@ void kvm_set_cpu_caps(void)
> >  		F(FMA) | F(CX16) | 0 /* xTPR Update */ | F(PDCM) |
> >  		F(PCID) | 0 /* Reserved, DCA */ | F(XMM4_1) |
> >  		F(XMM4_2) | EMUL_F(X2APIC) | F(MOVBE) | F(POPCNT) |
> > -		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
> > -		F(F16C) | F(RDRAND)
> > +		EMUL_F(TSC_DEADLINE_TIMER) | F(AES) | F(XSAVE) |
> > +		0 /* OSXSAVE */ | F(AVX) | F(F16C) | F(RDRAND)
> >  	);
> >  
> >  	kvm_cpu_cap_init(CPUID_1_EDX,
> 
> Hi,
> 
> I have a mixed feeling about this.
> 
> First of all KVM_GET_SUPPORTED_CPUID documentation explicitly states that it
> returns bits that are supported in *default* configuration TSC_DEADLINE_TIMER
> and arguably X2APIC are only supported after enabling various caps, e.g not
> default configuration.

Another side topic, in the near future, I think we should push to make an in-kernel
local APIC a hard requirement.  AFAIK, userspace local APIC gets no meaningful
test coverage, and IIRC we have known bugs where a userspace APIC doesn't work
as it should, e.g. commit 6550c4df7e50 ("KVM: nVMX: Fix interrupt window request
with "Acknowledge interrupt on exit"").

> However, since X2APIC also in KVM_GET_SUPPORTED_CPUID (also wrongly IMHO),
> for consistency it does make sense to add TSC_DEADLINE_TIMER as well.
> 
> I do think that we need at least to update the documentation of KVM_GET_SUPPORTED_CPUID
> and KVM_GET_EMULATED_CPUID, as I state in a review of a later patch.

+1

