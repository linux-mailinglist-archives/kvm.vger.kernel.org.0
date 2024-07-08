Return-Path: <kvm+bounces-21124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D6CF92A964
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 20:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC9C7281CD1
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 18:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001AD14C584;
	Mon,  8 Jul 2024 18:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Hr0sAXD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D023814B967
	for <kvm@vger.kernel.org>; Mon,  8 Jul 2024 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720465189; cv=none; b=jW5DbyYdQaomgN5YA4nR1Tkck6N5EzkxSDebOw55+bQe9ZtCgHqWiJggKd1xjWzsBc+eo/l+dE5n4DqLjxRR1MByWnhOKHNkhspZ6yKfcva2SHrzOSonDQf5Ulai3GSRagtyAh8d/xiclFaSk8Ei94GrLlyfOdZwo+DBZkWID+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720465189; c=relaxed/simple;
	bh=Lf76HX7zNzWzxMJIHc/54hT1puH2WYdX7xtsOWXyEbc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CFLgSSbRxaprZpG2F70fArkP5wJqrbzRdcjKRY8VjD4Fpjas3J1SZ8rV6HYo/0pgR4AhQdlbA19nd7kr7EcelCbO4H+I7QP8QebT0BvNR2YjOIp3MAjiJpIpJPSy2tRC7/ueiKCrDEK951UcYSTu0iA+T0Q0B9C1B8ftXfjguhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Hr0sAXD; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-71cdcb122e8so3729389a12.2
        for <kvm@vger.kernel.org>; Mon, 08 Jul 2024 11:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720465187; x=1721069987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vf2NY6EWfiw7dDAJ0gi5MeJq2TdsJcdWnkBzZ7gEIG0=;
        b=2Hr0sAXDLa1rEkOY2/1nTGvp4lB8FPnpuZXjtaTVM+jptSBkltnUjlxZgIE2OpWnr7
         L+dY2XOPFpEc2m8Hlw9L4CMu0kjLeyUJyjOXozSxsc15No+ju7br1qfh61Pe42MmlYDz
         Csq3Ka1qpfNQjTtc8TQEbFBI2lKWa/KvPfAk/rINZGQ9axhHdtOQC9O/n2Jz3SbwdcP8
         ctVJbx/o0fJ/U3IrXyQkqi99F0Q/Iu65zxp5hi+JLpZy1o7SiNIbo5afOwc2YKuk6uBl
         wo1d8twN5+aahCwy0iFLF6qKUOc0AA7L+ltgZaYIpDqU1FpdF1rI2EHnoPaq09+w27qj
         4slg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720465187; x=1721069987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vf2NY6EWfiw7dDAJ0gi5MeJq2TdsJcdWnkBzZ7gEIG0=;
        b=r1J62bZgb+eREMisQ1lJ1lQwp0gnPbWZWVQ8kOKM7D9QSHWGxJmjpfdXSaQZAcX2hH
         ig2/ULnehyH2VawoW2dR56qW0Sejwo8YZGjZJNwwSADpmenIFhbr8ZvJomPPbwg9x/hH
         wLsvzfuueJ/jCW/iciYj0k+pgv+Z43RWxdvh4is2ZSGMyXm3ONBvvBsPAbkMg7dy/jdl
         LWf+mp5eJuMjfEaz7l6pNAIx2VDn63MqEYi6yYDDXCi1xr8sYWDUTDyfUL7DBLv5PcaP
         7DJJHdacN1yECVpcnhx6VXK2Mhda/ReL1B7IKGKCOofFLjE1LLsVEkh2uGGH6qnuWt8w
         0StQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDhN4yYcIAWrFHhuqiYrAvwETHoXNOk7kin1BMfVatZ0Gdy7v7eLLkts+boAGO973YoOqQsnes9TFsL71Hp+uhukvb
X-Gm-Message-State: AOJu0YzPE41d7+8e27acjd+/gZMzy5mqO5jpFk3bOHqDYxxxZsUh5lk8
	pl6GD4SOb3MnhwCan4GM0M9ws3yVmsJ3diDjQea+e62jmwGGrOUIqSghtW+23epvv8E52OtR3IE
	VUg==
X-Google-Smtp-Source: AGHT+IFy7VBZpllFczGeS7Y5SrEIWga1z74oQWwOWI/dmQSRdFd6yYJv4SglQCCFGVWWOkPpvAmxoF+Z0C0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:713:b0:6e4:e7a1:d18 with SMTP id
 41be03b00d2f7-77db6c05b45mr600a12.6.1720465186914; Mon, 08 Jul 2024 11:59:46
 -0700 (PDT)
Date: Mon, 8 Jul 2024 11:59:45 -0700
In-Reply-To: <DS7PR12MB57665C3E8A7F0AF59E034B3C94D32@DS7PR12MB5766.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240626073719.5246-1-amit@kernel.org> <Zn7gK9KZKxBwgVc_@google.com>
 <CALMp9eSfZsGTngMSaWbFrdvMoWHyVK_SWf9W1Ps4BFdwAzae_g@mail.gmail.com>
 <52d965101127167388565ed1520e1f06d8492d3b.camel@kernel.org> <DS7PR12MB57665C3E8A7F0AF59E034B3C94D32@DS7PR12MB5766.namprd12.prod.outlook.com>
Message-ID: <Zow3IddrQoCTgzVS@google.com>
Subject: Re: [PATCH v2] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
From: Sean Christopherson <seanjc@google.com>
To: David Kaplan <David.Kaplan@amd.com>
Cc: Amit Shah <amit@kernel.org>, Jim Mattson <jmattson@google.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	Kim Phillips <kim.phillips@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jul 01, 2024, David Kaplan wrote:
> > > >        /*
> > > >         * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the
> > > > Intel feature
> > > >         * flag and protect from vendor-specific bugs via the
> > > > whitelist.
> > > >         *
> > > >         * Don't use AutoIBRS when SNP is enabled because it degrades
> > > > host
> > > >         * userspace indirect branch performance.
> > > >         */
> > > >        if ((x86_arch_cap_msr & ARCH_CAP_IBRS_ALL) ||
> > > >            (cpu_has(c, X86_FEATURE_AUTOIBRS) &&
> > > >             !cpu_feature_enabled(X86_FEATURE_SEV_SNP))) {
> > > >                setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
> > > >                if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB)
> > > > &&
> > > >                    !(x86_arch_cap_msr & ARCH_CAP_PBRSB_NO))
> > > >                        setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
> > > >        }
> > >
> > > Families 0FH through 12H don't have EIBRS or AutoIBRS, so there's no
> > > cpu_vuln_whitelist[] lookup. Hence, no need to set the NO_EIBRS_PBRSB
> > > bit, even if it is accurate.
> >
> > The commit that adds the RSB_VMEXIT_LITE feature flag does describe the
> > bug in a good amount of detail:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?i
> > d=2b1299322016731d56807aa49254a5ea3080b6b3
> >
> > I've not seen any indication this is required for AMD CPUs.
> >
> > David, do you agree we don't need this?
> >
> 
> It's not required, as AMD CPUs don't have the PBRSB issue with AutoIBRS.
> Although I think Sean was talking about being extra paranoid

Ya.  I'm asking if there's a reason not to tack on X86_FEATURE_RSB_VMEXIT_LITE,
beyond it effectively being dead code.  There's no runtime cost, and so assuming
it doesn't get spuriously enabled, I don't see a downside.

On the upside, if some SVM-capable CPU comes along that needs the lite version,
then fixing things for that CPU won't need a corresponding KVM change, just a
bugs/caps update.

