Return-Path: <kvm+bounces-33784-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 557259F1740
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 21:12:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48F56188ADC2
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 20:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF26E198836;
	Fri, 13 Dec 2024 20:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2DHYIITn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AB342A92
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 20:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734120564; cv=none; b=jcenPPxHoy6d0+vs3DmUKu2XaB/OrZkqto/AaCLduYNUX5uCjReGx8m1eee5vcGy9Gnbpq9lr570B0zbgUfxquIyWtPbazPCNdYA+PMM2Ae46Mr9M0nF6pq0VmFF7BA8yZpz0LhoncSO+pKoF1zLRYcTyrD/sieOmru8SYa2pCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734120564; c=relaxed/simple;
	bh=zC9BTE/86XdOFOIMDJ2jwHIkedHbdzd5NbKps9y9TkY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GZ9I8gNsVnXCOX1VlwWw2czWI689ngSQO4A/O+yenanccxsqVBZpPUQP0d9HZupXzPL04eWJ9dKQSGyQhzpdVHjZuoztaRfbM12xAMeD9GUGGXZwbu818mdk339ItdyrbkfXVx6UN4a++S7S/qNEljJsvXEWehsosHJjU9gakMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2DHYIITn; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ee36569f4cso1998512a91.2
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 12:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734120563; x=1734725363; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oWe44j1VIg6qYkfEWkPdzcvfPT6QWStum/CznGoFe/4=;
        b=2DHYIITne1PuECM3caXKH0QY60u+gf+wqHmJOGkOkKdPL5mh69Iw5ceDDrogeglIxa
         Rez+A94sWizI/YVTG43j5saJBhfVQ6lKNd430Ilc7myuQijGMYGn+Pft7ZtGdx1Xe7X5
         uS+AnpBHSA/Vp7DOSjEvsuBkofOC6oIDhK/wkd1jP8I+N4GkHNtLZMRTQUHEniVvfYR0
         Srj9hX/ivCLkWBfK3gYV+UfF1uzcsTaceOmD5+sStVswnWed2thtaJAngsrVcKgI5epm
         02XEKARl3UR4THnbuDRXUajaUy9HzZ7+uFbRG5m5CNECD+wT9g1fmkxeqUSFcmwLM1jK
         T8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734120563; x=1734725363;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oWe44j1VIg6qYkfEWkPdzcvfPT6QWStum/CznGoFe/4=;
        b=ayIbGkzPjW7S+1JxcpfPRbhiXEyfafr4oixixF2SCgs45h4e/AjhXPWZQVz5wcF0yE
         bTdxmyvFCBfk90IQY1NB3cIiiu6UBGjxT81KKJ/VUjmWAPZ8jAlJfvnpY3M9PvyD3/NP
         Bo2UZZMPf6vb1awDAGscZNWvGA0QFp6B7VqQHCsQVRVMQi/gd7hj8A10XzXFBCkYqobO
         mtsbMyH3phRKmS3yrRa15WbMMglUQC2rFOKi8JsletwwSZHUWFAjz7dwscb5n008FjbU
         P7D21vaQSTb3CYZUvB+CIc21/RkLoyQkjb5dwm2FgB2isHKZ7+7f6iXNGMJcU5Osojhx
         FYtA==
X-Forwarded-Encrypted: i=1; AJvYcCUhQn69l0sX099VdenY6HGdsRqDCuc/YYxJiGLQykPmjd7IORgdyhtsMjnvybZmxz7Xhpc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzLBW2Hd0Ie9RSw2M9xozXIidGpmdSn8Ns6S6kijVII8iILIN+p
	gPg5BsY94O0k0PgSf5PdigIpAxpquo3YAVFrqUkuxZzyMYcHhTYCpdQ4OyK7lumWiP0bHX+lWWz
	9BQ==
X-Google-Smtp-Source: AGHT+IG8Z8XXK8zlWOr0tzLqr/7Y+eTDpG0yEYtLy8WZ30WPxxdX4TRITnkAN6UZ0AGz++ZFXz5Zc2FUM4k=
X-Received: from pjbrr6.prod.google.com ([2002:a17:90b:2b46:b0:2d8:8d32:2ea3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2651:b0:2ee:7c65:ae8e
 with SMTP id 98e67ed59e1d1-2f28fb6f0c2mr5583098a91.11.1734120562799; Fri, 13
 Dec 2024 12:09:22 -0800 (PST)
Date: Fri, 13 Dec 2024 12:09:21 -0800
In-Reply-To: <20241213173816.GA7768@dev-dsk-iorlov-1b-d2eae488.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241111102749.82761-1-iorlov@amazon.com> <20241111102749.82761-4-iorlov@amazon.com>
 <Z1nWykQ3e4D5e2C-@google.com> <2b75550c-0dc7-4bcc-ac60-9ad4402c17f8@gmail.com>
 <Z1o1013dUex8w9hK@google.com> <20241212164137.GA71156@dev-dsk-iorlov-1b-d2eae488.eu-west-1.amazon.com>
 <Z1s8rWBrDhQaUHuw@google.com> <20241213173816.GA7768@dev-dsk-iorlov-1b-d2eae488.eu-west-1.amazon.com>
Message-ID: <Z1yHAAomsCdn5B8z@google.com>
Subject: Re: [PATCH v2 3/6] KVM: VMX: Handle vectoring error in check_emulate_instruction
From: Sean Christopherson <seanjc@google.com>
To: Ivan Orlov <iorlov@amazon.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, pdurrant@amazon.co.uk, 
	dwmw@amazon.co.uk
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 13, 2024, Ivan Orlov wrote:
> On Thu, Dec 12, 2024 at 11:42:37AM -0800, Sean Christopherson wrote:
> > Unprotect and re-execute is fine, what I'm worried about is *successfully*
> > emulating the instruction.  E.g.
> > 
> >   1. CPU executes instruction X and hits a #GP.
> >   2. While vectoring the #GP, a shadow #PF is taken.
> >   3. On VM-Exit, KVM re-injects the #GP (see __vmx_complete_interrupts()).
> >   4. KVM emulates because of the write-protected page.
> >   5. KVM "successfully" emulates and also detects the #GP
> >   6. KVM synthesizes a #GP, and because the vCPU already has injected #GP,
> >      incorrectly escalates to a #DF.
> > 
> > The above is a bit contrived, but I think it could happen if the guest reused a
> > page that _was_ a page table, for a vCPU's kernel stack.
> > 
> 
> Does it work like that only for contributory exceptions / page faults?

The #DF case, yes.

> In case if it's not #GP but (for instance) #UD, (as far as I understand)
> KVM will queue only one of them without causing #DF so it's gonna be
> valid?

No, it can still be invalid.  E.g. initialize hit a #BP, replace it with a #UD,
but there may be guest-visibile side effects from the original #BP.

> > > However, I'm not sure what happens if vectoring is caused by external
> > > interrupt: if we unprotect the page and re-execute the instruction,
> > > will IRQ be delivered nonetheless, or it will be lost as irq is
> > > already in ISR? Do we need to re-inject it in such a case?
> > 
> > In all cases, the event that was being vectored is re-injected.  Restarting from
> > scratch would be a bug.  E.g. if the cause of initial exception was "fixed", say
> > because the initial exception was #BP, and the guest finished patching out the INT3,
> > then restarting would execute the _new_ instruction, and the INT3 would be lost.
> > 
> 
> Cool, that is what I was concerned about, glad that it is already
> implemented :)
> 
> > 
> > As far as unprotect+retry being viable, I think we're on the same page.  What I'm
> > getting at is that I think KVM should never allow emulating on #PF when the #PF
> > occurred while vectoring.  E.g. this:
> > 
> >   static inline bool kvm_can_emulate_event_vectoring(int emul_type)
> >   {
> >         return !(emul_type & EMULTYPE_PF);
> >   }
> > 
> 
> Yeah, I agree. I'll post a V3 with suggested fixes (after running all of the
> selftests to be sure that it doesn't break anything).
> 
> > and then I believe this?  Where this diff can be a separate prep patch (though I'm
> > pretty sure it's technically pointless without the vectoring angle, because shadow
> > #PF can't coincide with any of the failure paths for kvm_check_emulate_insn()).
> > 
> 
> Looks good. If you don't mind, I could add this patch to the series with `Suggested-by`
> tag since it's neccessary to allow unprotect+retry in case of shadow #PF during
> vectoring.

Ya, go for it.

