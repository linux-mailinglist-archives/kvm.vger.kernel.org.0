Return-Path: <kvm+bounces-13499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72DA7897AF6
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 23:42:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93D311C26F31
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 21:42:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB1615688D;
	Wed,  3 Apr 2024 21:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S+UUXE09"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE23D15686D
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 21:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712180556; cv=none; b=sW0gDEJ40qOQqHzgLsTBs7EU6hxIjoD6ePK3L4jGhfg68p/6jX/+G1nOahgO6ruMZ/4HMY3LNxGX9gJTR/9sqU0kKxrj8L1dIxgvq1GtFMzAiOHgC3zUpgbN2CRKizZ04ZsC5fsvfFvBScEdNtMREEYPLitwb2Bf4Oupq0pND/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712180556; c=relaxed/simple;
	bh=MfA2fO46lhLsDa7FeVjwGuSV2tB/w58dfCGAPaFO8U8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WbqoameCCREnJxeuyBMnhQA0VF2bHt333z65vWH0YSAJBlNRit2kTKN19skpZ3WcUdeB6QSTcvOqowSzmwGqxLNQWkBpBJz2ST/a5MLudl6uh6WdxxYJDxNhQ0s+WZ8TC4ccdCAVmTTpmz4hzhafcGhjZdqby7q4rvrYOTO2rFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S+UUXE09; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6152135cd23so5416087b3.0
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 14:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712180554; x=1712785354; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lUlMHgGwPaVmm9YD6Wuiedxqqf2KvncEVELWkk3e+OQ=;
        b=S+UUXE09cJdUa81gZWcSfstzh9O9ww3wYPOyTSvYdQJRb5mvzwfQQ7MKnHFk0KA5Iq
         u4/eHGfDy83TdOg7oJYv2VFfAHuAlnDyCsYFZ9XVd3w53YErRGQzAPjtNVJtdErmEhlX
         yVsbHn1RnmxOxp5xclX5g681ohk7kam0vjJ+eWLSocD2o1uxA6K9axN79Pa0iEFYV8jI
         OAs9jxtgYHmXQaTCjjpAo0f2lPX5nWjYa9hx6ELgnJsIt6egRGdx4IpQUNC9dDvWjw4+
         2bdk9ET5dLLSqo5iMpSoABng8OkfEuO1bi3z867udnIgdYpOClJP8BHTdY4ancw0QAfa
         H8ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712180554; x=1712785354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lUlMHgGwPaVmm9YD6Wuiedxqqf2KvncEVELWkk3e+OQ=;
        b=XhVKGUMXQroVeqe0Y9570NO1bBLQF2iGeEWK2zlWkA9muaQNI7iqa5PbTEFQ/9ARmW
         RiZrW+8vLwLyXv9JnFQlyCQqB0zFOt2CCqC5gzsvlGF+e7EGmGYesgfeh3JFp+xJHjCd
         +nvfW7z/jjjt8tY5wOT/3ZKY5ktxx/YnoM/rrrRXLOK2c3clSqT8RgReWM6qqZRvau8a
         jLFbNblEwn8fKb92YQ8ahQs50eR/qP22J5fdEjhlEfBCDmhwRjY7g5Ii+tRJc5pc8g6p
         uBMjdF0gAHC78wwoPrBZ0nR/Me9vf5JOXH4XGiPEsw2nchPZbir3IVT1hmKs5EdYQWZr
         gozw==
X-Forwarded-Encrypted: i=1; AJvYcCX4cmuniS/J0NRdrcwL8fDTyIgcz5UQJqBatRJNcvxhZt7Ff+ICg6yojbMLyJqB+bCyEzWcNDLrQP9R1JBoqqJRV2mT
X-Gm-Message-State: AOJu0YxqIdEnASrwiVnNErOAtmpPxThohVG0p1XbxcMDLzI9/sT9/Zlq
	0uoUwSaj9/7aelbynXhLNgDFZz5ZRSL6dSdsCq78+l5OOnPgam6U9+G0UW+lEt7x1Ks6fXBhIK+
	JSg==
X-Google-Smtp-Source: AGHT+IHJ0aJM/2/LrQ2a81R9ZzCCLWbQnc2e93zBV1KvHULAXpNMMmDoIEmSZqsw6e8KfWoOaLDoSEDUKRM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:723:b0:dc6:c94e:fb85 with SMTP id
 l3-20020a056902072300b00dc6c94efb85mr55084ybt.2.1712180553949; Wed, 03 Apr
 2024 14:42:33 -0700 (PDT)
Date: Wed, 3 Apr 2024 21:42:32 +0000
In-Reply-To: <ee54cd65-6fb7-4b59-a4bf-d7f661110a07@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309012725.1409949-1-seanjc@google.com> <20240309012725.1409949-2-seanjc@google.com>
 <2a369e6e229788f66fb2bbf8bc89552d86ba38b9.camel@intel.com>
 <Zg2msDI9q_7GcwHk@google.com> <ee54cd65-6fb7-4b59-a4bf-d7f661110a07@intel.com>
Message-ID: <Zg3NSI1Max1iHrAI@google.com>
Subject: Re: [PATCH v6 1/9] x86/cpu: KVM: Add common defines for architectural
 memory types (PAT, MTRRs, etc.)
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "luto@kernel.org" <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "peterz@infradead.org" <peterz@infradead.org>, 
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>, Xin3 Li <xin3.li@intel.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Shan Kang <shan.kang@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 04, 2024, Kai Huang wrote:
> On 4/04/2024 7:57 am, Sean Christopherson wrote:
> > On Wed, Mar 27, 2024, Kai Huang wrote:
> > > IIUC, the purpose of this patch is for the kernel to use X86_MEMTYPE_xx, which
> > > are architectural values, where applicable?
> > 
> > Maybe?  Probably?
> > 
> > > Yeah we need to keep MTRR_TYPE_xx in the uapi header, but in the kernel, should
> > > we change all places that use MTRR_TYPE_xx to X86_MEMTYPE_xx?  The
> > > static_assert()s above have guaranteed the two are the same, so there's nothing
> > > wrong for the kernel to use X86_MEMTYPE_xx instead.
> > > 
> > > Both PAT_xx and VMX_BASIC_MEM_TYPE_xx to X86_MEMTYPE_xx, it seems a little bit
> > > odd if we don't switch for MTRR_TYPE_xx.
> > > 
> > > However by simple search MEM_TYPE_xx are intensively used in many files, so...
> > 
> > Yeah, I definitely don't want to do it in this series due to the amount of churn
> > that would be required.
> > 
> >    $ git grep MTRR_TYPE_ | wc -l
> >    100
> > 
> > I'm not even entirely convinced that it would be a net positive.  Much of the KVM
> > usage that's being cleaned up is flat out wrong, e.g. using "MTRR" enums in places
> > that having nothing to do with MTRRs.  But the majority of the remaining usage is
> > in MTRR code, i.e. isn't wrong, and is arguably better off using the MTRR specific
> > #defines.
> 
> Yeah understood.
> 
> But the patch title says we also "add common defines for ... MTRRs", so to
> me looks we should get rid of MTRR_TPYE_xx and use the common ones instead.
> And it also looks a little bit inconsistent if we remove the PAT_xx but keep
> the MTRR_TYPE_xx.
> 
> Perhaps we can keep PAT_xx but add macros?
> 
>   #define PAT_UC	X86_MEMTYPE_UC
>   ...
> 
> But looks not nice either because the only purpose is to keep the PAT_xx..

Ya, keeping PAT_* is the only option I strongly object to.  I have no problem
replacing MTRR_TPYE_* usage, I would simply prefer not to do it in this series.
And I obviously have no problem leaving the MTRR stuff as-is.

