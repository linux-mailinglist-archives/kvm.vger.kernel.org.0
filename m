Return-Path: <kvm+bounces-50681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE0EAE837D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:59:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 636F47B707F
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 12:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009EF261393;
	Wed, 25 Jun 2025 12:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YgD2rISE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32E425DAE3
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 12:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750856348; cv=none; b=DI+oOBtjDRCia8RrPAXgSR8a/LXrQXUuolGQCELvIZkr867uckvKXUo9sT/WRMAQXcVmrhzS9FT68u0Vz9lhVvzTR0yKq74md3J4YNkBTTDpxW48L2JrLABp1danBj/iZ0rKJMUAhwGPh2vua5mvxXEuVjtLVs6CMaVlAeDZkQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750856348; c=relaxed/simple;
	bh=omSb4qtffp8wKfjxeF+cs4XkxHLiftOc0485WaPmKr4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U38gA/IrM5cyp3PVd2VBheyRzH8aYyZ8rSRtAZUVhKvGndENk1qQNxBlZpmXkUu3wWuQeYeEh2apdZEUwTJfUd10eY+C1p5K7+Ojz555wYrlUQBbs1UIzWEpUq5SvNy1CnizEPgog4S45ii6Jw2MYQ5Z2sKgwMF/dLO1qnm3ZAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YgD2rISE; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b2fa1a84566so4168459a12.1
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 05:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750856346; x=1751461146; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qxIJ4aQC+IjPoRxmkOWSPu5mR2v1UrY8osqVxd/rWGo=;
        b=YgD2rISEmIjCkeWL/GZXsDdayMEREwYQ72YwmK8Q7XiBgVMKgtr1mKgNy/agb5bljK
         1bPr8VlnBGqZ3DtaHo3CB9JSTzgrfia6iZWyP0ssZ9+VFW04VKYN1z11Tu8mdnWTryZ3
         cu7JgJX42jDoQoAGaOVcp/6Vc6/mcwh2lCNC1b+RD5ifEMeqR6+zVW5ShTCH6fzDrk9U
         1LafOplOV0jW+STFin7QukSMGb/W9HCwRt900K+DpsAucaBDkmV77m+WegZmHvcAbMug
         k/K1XjdTH0TI5GAh7gaZMEk0HR1eHW63xpxicPOm8aO9ot3lMI0vTOlN/7/ymsHSP9yM
         M4VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750856346; x=1751461146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qxIJ4aQC+IjPoRxmkOWSPu5mR2v1UrY8osqVxd/rWGo=;
        b=RhD+tUglGiRtB/kCgcnAmSrGGB/u4cg7beYzQTGsXmvKcviCtgvwd/HlfXFdIcU0oJ
         ra1jauanIPmI9ShP7MjN+rL9ORFtI5O0IGS8IKviWDujZ/vKDO3CSU884xPUwK29o4d8
         UZ2/FYcwWgCoXwTkqAuVzW+iEEtzOmuJ4NR5OQte+ZUGfrvWBjLlr+amN4ezDe+7LH/0
         ifT71wFZsAyy50SgL+E2eWCu03PEsQ06qnJtNbh2Y2RZOog8WIbjXyXmFHjjy7REI33C
         nhL2DKXhRAcLO1gGlEjEM+wERegSM5Ysx47Uc55ROQq3+dObWLFXXj0YzFkcJgLETZVr
         R5kg==
X-Forwarded-Encrypted: i=1; AJvYcCU8+bkw9yfDMCVLNzHIB2zvUCx1WkgF5yFW1lczu/1IGWehIAtxmpuGmjn3+/kb4ssJ/30=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz99/HWJA1sQ/NdlYtPOCXgbfcDK8Esn3OuvSeQR+CMCEolFg+X
	Srt2XXUHrz7vEP58cqO8cIRyKrwsnwuh/aAB5mZc8/zxt/Ifzlp4l7YMgKI4YA6OPfZ0iVrFeR4
	JPiOxsw==
X-Google-Smtp-Source: AGHT+IEhIwcr6ikR86NXDpgfcAQublPKVJCRuEFifK28YdTxbvKmmfgddvnr2t043GixUvzzZ12CrvVkj/A=
X-Received: from pjj15.prod.google.com ([2002:a17:90b:554f:b0:311:eb65:e269])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f0c:b0:315:9ac2:8700
 with SMTP id 98e67ed59e1d1-315f269caabmr4382059a91.24.1750856346092; Wed, 25
 Jun 2025 05:59:06 -0700 (PDT)
Date: Wed, 25 Jun 2025 05:59:04 -0700
In-Reply-To: <24675ed2-e3ae-4473-9d8e-acd378da220c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-4-Neeraj.Upadhyay@amd.com> <20250623114910.GGaFk_NqzGmR81fG8f@fat_crate.local>
 <24675ed2-e3ae-4473-9d8e-acd378da220c@amd.com>
Message-ID: <aFvymAS-pXMwkmjX@google.com>
Subject: Re: [RFC PATCH v7 03/37] x86/apic: KVM: Deduplicate APIC vector =>
 register+bit math
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jun 25, 2025, Neeraj Upadhyay wrote:
> 
> 
> On 6/23/2025 5:19 PM, Borislav Petkov wrote:
> > On Tue, Jun 10, 2025 at 11:23:50PM +0530, Neeraj Upadhyay wrote:
> >> diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> >> index 23d86c9750b9..c84d4e86fe4e 100644
> >> --- a/arch/x86/include/asm/apic.h
> >> +++ b/arch/x86/include/asm/apic.h
> >> @@ -488,11 +488,14 @@ static inline void apic_setup_apic_calls(void) { }
> >>  
> >>  extern void apic_ack_irq(struct irq_data *data);
> >>  
> >> +#define APIC_VECTOR_TO_BIT_NUMBER(v) ((unsigned int)(v) % 32)
> >> +#define APIC_VECTOR_TO_REG_OFFSET(v) ((unsigned int)(v) / 32 * 0x10)
> > 
> > Dunno - I'd probably shorten those macro names:
> > 
> > APIC_VEC_TO_BITNUM()
> > APIC_VEC_TO_REGOFF()
> > 
> > because this way of shortening those words is very common and is still very
> > readable, even if not fully written out...
> > 
> 
> Sounds good to me. Will change this in next version (will also wait for Sean's
> comment on this).

My vote is for the long names.  I find REG_OFFSET in particular to be much more
self-documenting.  My brain gets there eventually with REGOFF, but I just don't
see the point in shortening the names.  The only uses where line lengths get a
bit too long are apic_set_isr() and apic_clear_isr(), and the lines are still
quite long with the shorter names.

