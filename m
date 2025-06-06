Return-Path: <kvm+bounces-48660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA3FAD02F7
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 15:15:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 694AF3B1A35
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 13:15:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D72228934B;
	Fri,  6 Jun 2025 13:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nHVT0pQW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB351433AC
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 13:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749215724; cv=none; b=RzzcI5JXCxKdSkQJNjffH4Dd5Ru+HlQToPDvb3n6Tv++EaoNAa5gzQi/2QXWCfdM5u3l8tTLxWq8c3ms2JfEducINRO+em6nzcpv11XpNA3tYVOyucsfYaonu0BpovXvIiZOO86Gg191h7j8i004IYvcGcMOpAJy16M1+YMHhNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749215724; c=relaxed/simple;
	bh=gyt4YaLylyEdGqTGCWW7/jEsxjYOduZjnQjBg14MIi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B419fXrS8W+/rgvyZv9QSSOGwsHbPK2BEgWI8nbi4dHr+RDcxN9M9tuVnA/sCAfmgkQF4knG3EM33SE1AU3P5Amai2nTCdvb3d+q1fm8qC99gtTfdQi2K4vUZCIxGB5gKaoXKKxOZjoTjH108IO8Vs+BJo341YTfouJyXx2QLGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nHVT0pQW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-310c5c2c38cso2182199a91.1
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 06:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749215721; x=1749820521; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yGgF9r+9FKkiYTuXty2xB/3AJrpX6qlhSbOSApR1j+c=;
        b=nHVT0pQWo7ERZEECiSRejF4scmWQQb9qA7RJPGzFRO+D70E0vHxvE6ry0SDdO2jLEu
         ayD/jMv6ENgeGhL8L9M0QBLcKmj+aEmmrOM90onV2fBJyIBkDtCbOotBtfKYpMN33JCo
         WYIUfTuxKs/H8XrbsC+piGECk3VDsuLg89MxZK/xGgiD50k0N0q6JALbEYehc4dF/Nk/
         bGXMKia3nesSV5aQrL03hdgwufRgBPYOXbO8V/SBLc8mQI+XLvFMBMkERvKUhWzTAAy2
         kwwBo1Yj4UYOSmtq4BJpIys3RF1i9RNizQmx4YEWZ7p9irItoCe2SDSTaxsxTiUfp2Xf
         51Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749215721; x=1749820521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGgF9r+9FKkiYTuXty2xB/3AJrpX6qlhSbOSApR1j+c=;
        b=DkdPwrx5xuR9/0T6acOPgDxOJcXQoCk4f90jTt/ZztL08n+17zmpnvsLcVGjP93vsq
         A3cVCkpL3b2VyaUppOJsIQ0/iSXY7aJ/1CoVtr0z+bIkfv0TQXBpr6/dQxWlSa3lnvnf
         ai1Iz7Iykcc8O2VpZC0Vn4j8Mu4k5vszNYskgyCU4M1oSKmYZpAVNwja2r82TEUplz1f
         CHiwCt1DP0dxDCvwOCUsMAfHnecUHyOQdH1TQZaGXxjkgXptV+AeZCTGg9RZZSfjnAoY
         nR2YxYE8y+e7I0z8EFGVQqLFc4YLGaxprJRhDoJoVDhdDROEsIB0zanxFFIggxaivitv
         FGeg==
X-Forwarded-Encrypted: i=1; AJvYcCWLNMVtOTiqrRjlcJJVN0y8Avr17aWdXU7+iV7yi94i+b6Ed42CS5nkLkZ82F+7xppZNvs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU53/AOf8LWqX+wPMcT1zoiXLcOpalSYZpptD3mVWdyWoEn/VC
	FEnj/DO0YKjL/sTR2o/wPCzG5JfgerHBIJT6SUt0dnyZiZEOFF/eO6XT2iRghrQVWEIIx15T4zL
	lNu8axQ==
X-Google-Smtp-Source: AGHT+IEkmdmlhxkvvno3PR4WzLdHB4CTjnz10V2ZdnBYVgAxNWQfyn5XDRSLEqyR+GWL3cZrVs8zuw5Pz+4=
X-Received: from pjc16.prod.google.com ([2002:a17:90b:2f50:b0:2fb:fa85:1678])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b09:b0:313:2adc:b4c4
 with SMTP id 98e67ed59e1d1-31347678bbcmr5190417a91.24.1749215721138; Fri, 06
 Jun 2025 06:15:21 -0700 (PDT)
Date: Fri, 6 Jun 2025 06:15:19 -0700
In-Reply-To: <20250606104945.GY39944@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250506133234.GH4356@noisy.programming.kicks-ass.net>
 <vukrlmb4kbpcol6rtest3tsw4y6obopbrwi5hcb5iwzogsopgt@sokysuzxvehi>
 <20250528074452.GU39944@noisy.programming.kicks-ass.net> <20250528163035.GH31726@noisy.programming.kicks-ass.net>
 <20250528163557.GI31726@noisy.programming.kicks-ass.net> <20250529093017.GJ31726@noisy.programming.kicks-ass.net>
 <fp5amaygv37wxr6bglagljr325rsagllbabb62ow44kl3mznb6@gzk6nuukjgwv>
 <eegs5wq4eoqpu5yqlzug7icptiwzusracrp3nlmjkxwfywzvez@jngbkb3xqj6o>
 <4z4fhaqesjlevwiugiqpnxdths5qkkj7vd4q3wgdosu4p24ppl@nb6c2gybuwe5> <20250606104945.GY39944@noisy.programming.kicks-ass.net>
Message-ID: <aELptV62mbTC3YA9@google.com>
Subject: Re: [PATCH v2 00/13] objtool: Detect and warn about indirect calls in
 __nocfi functions
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org, 
	decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, pbonzini@redhat.com, ardb@kernel.org, 
	kees@kernel.org, Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org, 
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-efi@vger.kernel.org, samitolvanen@google.com, 
	ojeda@kernel.org, xin@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 06, 2025, Peter Zijlstra wrote:
> On Thu, Jun 05, 2025 at 10:19:41AM -0700, Josh Poimboeuf wrote:
> > diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
> > index 29c5c32c16c3..5d1eef193b79 100644
> > --- a/arch/x86/entry/entry_64_fred.S
> > +++ b/arch/x86/entry/entry_64_fred.S
> > @@ -112,11 +112,12 @@ SYM_FUNC_START(asm_fred_entry_from_kvm)
> >  	push %rax				/* Return RIP */
> >  	push $0					/* Error code, 0 for IRQ/NMI */
> >  
> > -	PUSH_AND_CLEAR_REGS clear_bp=0 unwind_hint=0
> > +	PUSH_AND_CLEAR_REGS clear_callee=0 unwind_hint=0
> >  	movq %rsp, %rdi				/* %rdi -> pt_regs */
> >  	call __fred_entry_from_kvm		/* Call the C entry point */
> > -	POP_REGS
> > -	ERETS
> > +	addq $C_PTREGS_SIZE, %rsp
> > +
> > +	ALTERNATIVE "mov %rbp, %rsp", __stringify(ERETS), X86_FEATURE_FRED
> 
> So... I was wondering.. do we actually ever need the ERETS?

Yes, to unblock NMIs, because NMIs are blocked on VM-Exit due to NMI.

The !X86_FEATURE_FRED path can use RET (instead of IRET) because NMIs are routed
through vmx_do_nmi_irqoff(), as proposed in this version[*], after you pointed out
that the FRED entry doesn't have the legacy NMI madness.

[*] https://lore.kernel.org/all/aBUiwLV4ZY2HdRbz@google.com

