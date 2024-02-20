Return-Path: <kvm+bounces-9214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5AD85C129
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A0191F226D1
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 16:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0045879DBE;
	Tue, 20 Feb 2024 16:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hnH3DEK1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F086079939
	for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 16:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708446041; cv=none; b=JQP5SX6TlHu+KtNtep7K+4T6ap/xfXrfx6dHTVxkKSVuA7ZNRtdo5csC1FTgjDNOrkHZMtFjan8p+GPl6fG0fMpgKV/cTeQmr3xZS0/ArzW6kzRt5HozvzAf8RET0I73wYNiY2t43/+bo3CmHY6GygPA5Edhvqw0t2WmEx5poIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708446041; c=relaxed/simple;
	bh=tkQx8P4cA4yFykrMvurCrO/U9EcQdI6W6X9CrUgTWAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fINQlu80x0U1D605vUqHsXbFCg0J5e8umgaKPS5v0WpHmrfCiKiDzX4By2wsknbRAzKlgyRE5avxvhaneZJPeVTtzsFuPfFBYz509Q5b0jyifkQM7lFVMlVxyBd5gJ4jQ4g9R2jvcRcwebrV7AW4QiLq5WJdeZWkHjd5RLP/O8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hnH3DEK1; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1db90f7b92bso52075255ad.0
        for <kvm@vger.kernel.org>; Tue, 20 Feb 2024 08:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708446038; x=1709050838; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gaBNvIG1XlI7Rma4r4ZehqM6i4uIMsjEXoMFyCXLWog=;
        b=hnH3DEK1TlZ9XwRPa83LdjKnfEDz6mvX3uvbNOKk5vlHxAcF/xGUsoDiW2kmphZJ8P
         sSzYna9rcvjRU0qhgID4aqNAZCnYGaS7rkjVN74ZngY/yBpmP8AlzeLd7pY1SaEAIjuI
         9xov93twffL7EOgDT1w8w9DHfjjiuHWQ4Pq1IzsCXV8iN8Ka/2MxdYq/TUU4/r1vZktI
         YxIc5uaLt+QDWpwjB/5/5VM3dRkP7AL0S/Jdde+HuZFCJj/j3wJKppg6jTdT4bEzSnq1
         DYB5xhRw4vik1jyn9upwPoZ/PsVFyfq+IxzVOtp7WOMrF7+wd+PDFjNftoT07ZP2HVTi
         Ra5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708446038; x=1709050838;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gaBNvIG1XlI7Rma4r4ZehqM6i4uIMsjEXoMFyCXLWog=;
        b=bDUnK+TVv4EerQd7ag89rGZULi9D0hcrML0dVoU2iSjsGHFUhDZ+DqdZwl9LHecpRJ
         UPQwGJxzIpkySSWwNsWUPYkVzHeK8UKSmcgTX/dVUr9zmV+nxft/ENXqBvvXzzdEFItk
         Dua4ehVoGk3tw1PCcszX0BCsRv0LlzFALpujC9574pdLmrJz+avtWZm3twcRf+JvJ7e5
         5sq2A1HzMzKXKfCLOKCXmOEcWH+G4XoYh7/VcS3RRBeqHPLIoGvT7wMas3yX5iU9ZPx/
         hbA/QNvyOhOfzjp49vybxbEunV3PG9nN92stsFA9wpH7UulwizkA7fuAKdJDslQIQv/Q
         HJnw==
X-Forwarded-Encrypted: i=1; AJvYcCWWyUmIR2T9g0YNpB6qXCni/rSFVD72wZU87eThZcrBumjmuGlUsRtFvhddt4aJalS/bHBL0mNoAOfNHWxtk5l7r7nh
X-Gm-Message-State: AOJu0YxUa51ZESwA5QNTMS8zWxnWda0DFCHUBfRQ9sqyreBsEzKAo7ct
	Wv1ckP6dwGuNLNCbG/juqwtB/Yjd3pBS1a1MzJwBFt6g1UqY0pEHrZNyLdHoUyjdd8XmX7C1wB8
	Ymg==
X-Google-Smtp-Source: AGHT+IHQi9e4VsipuZL3tTtt6H5NilJ+ksQWV/bXRNHygHBVBXjwpN+pFq6S26zUER6fkq27ZHG9pHuUsUo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e74d:b0:1db:e494:4b51 with SMTP id
 p13-20020a170902e74d00b001dbe4944b51mr268101plf.4.1708446038280; Tue, 20 Feb
 2024 08:20:38 -0800 (PST)
Date: Tue, 20 Feb 2024 08:20:36 -0800
In-Reply-To: <Zc5MRqmspThUoB+n@AUS-L1-JOHALLEN.amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231010200220.897953-1-john.allen@amd.com> <20231010200220.897953-7-john.allen@amd.com>
 <5e413e05de559971cdc2d1a9281a8a271590f62b.camel@redhat.com>
 <ZUQvNIE9iU5TqJfw@google.com> <c077e005c64aa82c7eaf4252f322c4ca29a2d0af.camel@redhat.com>
 <Zc5MRqmspThUoB+n@AUS-L1-JOHALLEN.amd.com>
Message-ID: <ZdTRVNt5GWXEKL8h@google.com>
Subject: Re: [PATCH 6/9] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
From: Sean Christopherson <seanjc@google.com>
To: John Allen <john.allen@amd.com>
Cc: mlevitsk@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pbonzini@redhat.com, weijiang.yang@intel.com, rick.p.edgecombe@intel.com, 
	x86@kernel.org, thomas.lendacky@amd.com, bp@alien8.de
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 15, 2024, John Allen wrote:
> On Tue, Nov 07, 2023 at 08:20:52PM +0200, Maxim Levitsky wrote:
> > On Thu, 2023-11-02 at 16:22 -0700, Sean Christopherson wrote:
> > > On Thu, Nov 02, 2023, Maxim Levitsky wrote:
> > > > On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> > > > > @@ -3032,6 +3037,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
> > > > >  		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
> > > > >  			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
> > > > >  	}
> > > > > +
> > > > > +	if (kvm_caps.supported_xss)
> > > > > +		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
> > > > 
> > > > This is not just a virtualization hole. This allows the guest to set MSR_IA32_XSS
> > > > to whatever value it wants, and thus it might allow XSAVES to access some host msrs
> > > > that guest must not be able to access.
> > > > 
> > > > AMD might not yet have such msrs, but on Intel side I do see various components
> > > > like 'HDC State', 'HWP state' and such.
> > > 
> > > The approach AMD has taken with SEV-ES+ is to have ucode context switch everything
> > > that the guest can access.  So, in theory, if/when AMD adds more XCR0/XSS-based
> > > features, that state will also be context switched.
> > > 
> > > Don't get me wrong, I hate this with a passion, but it's not *quite* fatally unsafe,
> > > just horrific.
> > > 
> > > > I understand that this is needed so that #VC handler could read this msr, and
> > > > trying to read it will cause another #VC which is probably not allowed (I
> > > > don't know this detail of SEV-ES)
> > > > 
> > > > I guess #VC handler should instead use a kernel cached value of this msr
> > > > instead, or at least KVM should only allow reads and not writes to it.
> > > 
> > > Nope, doesn't work.  In addition to automatically context switching state, SEV-ES
> > > also encrypts the guest state, i.e. KVM *can't* correctly virtualize XSS (or XCR0)
> > > for the guest, because KVM *can't* load the guest's desired value into hardware.
> > > 
> > > The guest can do #VMGEXIT (a.k.a. VMMCALL) all it wants to request a certain XSS
> > > or XCR0, and there's not a damn thing KVM can do to service the request.
> > > 
> > 
> > Ah, I understand now. Everything makes sense, and yes, this is really ugly.
> 
> Hi Maxim and Sean,
> 
> It looks as though there are some broad changes that will need to happen
> over the long term WRT to SEV-ES/SEV-SNP. In the short term, how would
> you suggest I proceed with the SVM shstk series? Can we omit the SEV-ES
> changes for now with an additional patch that disallows guest shstk when
> SEV-ES is enabled? Subsequently, when we have a proper solution for the
> concerns discussed here, we could submit another series for SEV-ES
> support.

The SEV-ES mess was already addressed by commit a26b7cd22546 ("KVM: SEV: Do not
intercept accesses to MSR_IA32_XSS for SEV-ES guests").  Or is there more that's
needed for shadow stacks?

