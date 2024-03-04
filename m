Return-Path: <kvm+bounces-10815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E1280870639
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 16:52:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C07DB26D82
	for <lists+kvm@lfdr.de>; Mon,  4 Mar 2024 15:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA8547F7A;
	Mon,  4 Mar 2024 15:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SDZXtRgi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045A347772
	for <kvm@vger.kernel.org>; Mon,  4 Mar 2024 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709567468; cv=none; b=M2+dGgCGBZzP5PQ8MpePsQI+O0kBKhaEww1KqlW+pjodwAGQZ1x5nmyGQEmF//QuUdw5z60eWmaz7pitBJZtGHe3UyP/HbXEfJeNGw5tafvxAjmJHtFP9FEkHBl5Gi3w6FTZHg2qsxOh9VA1Ai0lrIVclmCMqqJf7ZX2Pnc2hmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709567468; c=relaxed/simple;
	bh=yBt5TwzmivGnFmrcNnjakHcmowxPO+T1ILDhjFfS+5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Adc+iYB3HZmwv9RAb/CF5sIgTEhQzWg4ltCKo/0ly9z8BSGfBgkAAiuudDdfTqxG8k+efoAhgpVgIcPVTyGfn4ywP2eFM3eILBUdp8rPomZb/YE+SgteCuuXEJ9kGzdSN9NmHkY8irXy+q3019UgLxCF9d1RXd8EJnHJfrraWhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SDZXtRgi; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5dca5c631ffso4377933a12.2
        for <kvm@vger.kernel.org>; Mon, 04 Mar 2024 07:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709567466; x=1710172266; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sBUCyHuTZA9i0dCfsQh5d6xGpY6OHPS4YyBabmMxAP4=;
        b=SDZXtRgiyj+5MbAIgJu07FhCICtaTMIu9JLGYC24BLs46xhb5qinRqL5sNiG7xAFgh
         c4OfNJoLeO9P0c2wvvQfdW9kKoTs/hlsLXZCSJP0UMpIYFWDZsSQ4FB+EU2U71CxMFdc
         One/V1kt7L1ynO8z3y0QkD4etJgPSNY0OIENB3j3SDtZVu/maykrTUady53rqEw4Y+Qs
         izVc9lkmJ2GAIO4L4zxXAayIKoV0/o5Qr7v4g46SRd8K/4ZDhHyvSmkYdY1PqLc2NaQX
         xJ8PM1YwzEmKj4rofdgdVHqB5+nYKSxb3twT66Zwk8A5NzmXjt3HQAxYb82UDjA/a+lN
         rzUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709567466; x=1710172266;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sBUCyHuTZA9i0dCfsQh5d6xGpY6OHPS4YyBabmMxAP4=;
        b=LxtjY7+fMI0YsK9v9NwO9owedq0DXPOkfKnOHPSbwEpLoIQduRxPIQwZUx6OouYqCH
         9vLN2iIl8lMBsKPSMIgihKe4RSvEMr76w6/dCG3fjIhf4oryx6mlLoMGfhFIrLafEiZk
         tuNOPcxwYTrPwytS8iTpT38S0G3ADGxQ8V9DefYesxPS5KgDPUEFJ9xowwPKy9rbQJjE
         +iKx0CBfuXS/QAiBxheaB7ndaE2gop8HEPj7LisK2qg5S7upSgCc5dcuuNE47/LvR3mY
         uKDEhtfF2CmFNDEE+GLs4IFxcgu178EyqXCgcckQ5OJNqSYBFBuqgddBCoyVcmFb46kU
         8rpA==
X-Forwarded-Encrypted: i=1; AJvYcCXkbL7asuNUZrK61zNdD0KdvJ7ksRpGrBQy6atlNCJLvURr+ulZP3fzwzvokX12CzymkCI2Mb/uSWq5tA3HSIHKAX4V
X-Gm-Message-State: AOJu0Yy8uj3cT52AcuRcvg8TwzW7LeCrCZSSR3oTEaCrZmNc4FilaIXs
	rA/WiwJeJGE+G7H9BJSOfuYCk7WFhqQKOlGR09nBOUHNeiK+BxKN09258RTWv58JNFwmFXpi2Bn
	Iig==
X-Google-Smtp-Source: AGHT+IEVyjSh5NovjKr5fkDkRZyDvD0iMlIGtwRXV2B2y4ATUNzJdtnYgus2gWiVbWe/2y2bviGgzKsFeEE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5d0e:0:b0:5dc:eb5:19db with SMTP id
 r14-20020a635d0e000000b005dc0eb519dbmr27392pgb.0.1709567465769; Mon, 04 Mar
 2024 07:51:05 -0800 (PST)
Date: Mon, 4 Mar 2024 07:51:04 -0800
In-Reply-To: <05449435-008c-4d51-b21f-03df1fa58e77@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-9-seanjc@google.com>
 <2237d6b1-1c90-4acd-99e9-f051556dd6ac@intel.com> <ZeEOC0mo8C4GL708@google.com>
 <05449435-008c-4d51-b21f-03df1fa58e77@intel.com>
Message-ID: <ZeXt6A_w4etYCYP7@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: WARN and skip MMIO cache on private,
 reserved page faults
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 01, 2024, Kai Huang wrote:
> On 1/03/2024 12:06 pm, Sean Christopherson wrote:
> > E.g. in this case, KVM will just skip various fast paths because of the RSVD flag,
> > and treat the fault like a PRIVATE fault.  Hmm, but page_fault_handle_page_track()
> > would skip write tracking, which could theoretically cause data corruption, so I
> > guess arguably it would be safer to bail?
> > 
> > Anyone else have an opinion?  This type of bug should never escape development,
> > so I'm a-ok effectively killing the VM.  Unless someone has a good argument for
> > continuing on, I'll go with Kai's suggestion and squash this:
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index cedacb1b89c5..d796a162b2da 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -5892,8 +5892,10 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
> >                  error_code |= PFERR_PRIVATE_ACCESS;
> >          r = RET_PF_INVALID;
> > -       if (unlikely((error_code & PFERR_RSVD_MASK) &&
> > -                    !WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))) {
> > +       if (unlikely(error_code & PFERR_RSVD_MASK)) {
> > +               if (WARN_ON_ONCE(error_code & PFERR_PRIVATE_ACCESS))
> > +                       return -EFAULT;
> 
> -EFAULT is part of guest_memfd() memory fault ABI.  I didn't think over this
> thoroughly but do you want to return -EFAULT here?

Yes, I/we do.  There are many existing paths that can return -EFAULT from KVM_RUN
without setting run->exit_reason to KVM_EXIT_MEMORY_FAULT.  Userspace is responsible
for checking run->exit_reason on -EFAULT (and -EHWPOISON), i.e. must be prepared
to handle a "bare" -EFAULT, where for all intents and purposes "handle" means
"terminate the guest".

That's actually one of the reasons why KVM_EXIT_MEMORY_FAULT exists, it'd require
an absurd amount of work and churn in KVM to *safely* return useful information
on *all* -EFAULTs.  FWIW, I had hopes and dreams of actually doing exactly this,
but have long since abandoned those dreams.

In other words, KVM_EXIT_MEMORY_FAULT essentially communicates to userspace that
(a) userspace can likely fix whatever badness triggered the -EFAULT, and (b) that
KVM is in a state where fixing the underlying problem and resuming the guest is
safe, e.g. won't corrupt the guest (because KVM is in a half-baked state).

