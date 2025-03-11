Return-Path: <kvm+bounces-40772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BB32A5C438
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E31F71899C78
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 14:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817EF25D209;
	Tue, 11 Mar 2025 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y2dOrT6G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D361BDCF
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 14:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741704725; cv=none; b=YURKDkVYqKj7KNX/xTYpZZRdcXwYRJnCK0dLFPCpNGFkl7/cweQ+zUJq1LgePR3KWLX1o/erbFn+ILbIxVlHu2WfrRxVCLgk1V4hK3hEG6GYDjJlIhM9Qs8WbNO7v7nsRr5vb8QGIBRRxOUZGrWTqVa3a7z4ysaFY1seaV41W2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741704725; c=relaxed/simple;
	bh=UYR4PyrCdY+jO1nNSr7wMauz8OGG/q7aPzF+GtyMQus=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IJ34kJw/VcpG7FHNrpUwz2K5XJHDU/JArlrn7+zgCT7B60EmCVDA+SUiuxYdubcbDg0RNauPWR0O9/sl7fihkOKN53J4gZPG67tYfw7rEhxAZPfffM39cZrAyHehxNf5oO84wmopSCsvbwjVPtUU9YbuRoFHbRavP2eJ8FuNAhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y2dOrT6G; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2242ade807fso122477615ad.2
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 07:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741704723; x=1742309523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ycuo6EmGPQYjDQLNoZqw5zxfS6GWrbIA74YP2fq1UeI=;
        b=y2dOrT6GnXw457dbsny1DCPuFCLpiAIyCgqbxAB5ndwRC52sA1NbQ+B0f0vErcgPCa
         X5J/fpuhPPVAC+NWRdUYGFocYysKnxmvLlO5o2GCOcwIhyRnlZ/iTTJj3M/OyHiyvttX
         p/qicc8W59gdoG1uTbrLfSJPaf8CTl4RLo+U7xGQDcV8Zi5kFnuKzOQhEWzJFhvtjhDd
         ZpQHt/6ZRjQpk/A12bliwTYKO13JrPgkA4tn/ZzhA7/sP9g/UTQo+fc0dxxnjD/ZpwCa
         wNzPttTuXUc0e30MUNxR3kMcz2CfKqflt6VQwvgUeFVCltOUTaAolX4ldUU7+6K30NKc
         bNNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741704723; x=1742309523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycuo6EmGPQYjDQLNoZqw5zxfS6GWrbIA74YP2fq1UeI=;
        b=CQQOtmR0TDO4yRn44kb3lRwAhfNId59jOMb6mm3wstU1vwh9+cHg8ZPZIOqNbT03/o
         EaXTn8PcxEYBBZgkrU0T2ndLPckGc3lF7zRIYoR+Ov3pkU6Z0kpFQ7iKO+nHJzjBl9Ef
         K3vNW5DjHRtq3Iq8sQzkOJgEohiGgv63Fpdn5R2lvJUq1jMz4lURCaHTmoyQ/MIjZ+NR
         INcPSLMlueSWlkLGAcaIdh3BnhmCqlT22m4AysUvhnnqxCpErAQWFAc8wI+j9bbuWs7a
         Z+kwDVyJho7qT+Qyj7FlCU5dAqhmVjlMYWJTZg61zUaeihzhVGuUXNkF7K4LT3kcGayD
         8tBw==
X-Forwarded-Encrypted: i=1; AJvYcCVXVLwCi/AQPS6pFuoUjcNOiwLOIXsH8w9sX9Fg33bQfBJMGXhBSk7wRrcgF6IAexADkA4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfiZ1FHino6aZ0t6I2RT6fCpdCSDY85ct1johOWBYLntm/D/HW
	uHwY7WM+jF1yKDbJY8WjDPg0Ol6mSlxKteCFaUHq0NksVtEjs0wzHrM+NiKMZKyF9Cl1tpFamm5
	0cg==
X-Google-Smtp-Source: AGHT+IHV8W7flwuj/9DrU8BlspyKP/HLUW4yFKBfcGT9+c4tb2+a8q00r3d9K2ubu/q/UzFEi8dwnXpsRI4=
X-Received: from pfop6.prod.google.com ([2002:a05:6a00:b46:b0:732:2df9:b513])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4f90:b0:736:3d6c:aa64
 with SMTP id d2e1a72fcca58-736aab13b03mr27033960b3a.21.1741704723480; Tue, 11
 Mar 2025 07:52:03 -0700 (PDT)
Date: Tue, 11 Mar 2025 07:52:02 -0700
In-Reply-To: <0d121f41-a31d-1c0b-22cb-9533dd983b8a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250310063938.13790-1-nikunj@amd.com> <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-4-nikunj@amd.com> <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
 <cc076754-f465-426b-b404-1892d26e8f23@amd.com> <d92856e0-cc43-4c51-88c7-65f4c70424bf@amd.com>
 <0d121f41-a31d-1c0b-22cb-9533dd983b8a@amd.com>
Message-ID: <Z9BOEtM6bm-ng68c@google.com>
Subject: Re: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 11, 2025, Tom Lendacky wrote:
> On 3/11/25 06:05, Nikunj A. Dadhania wrote:
> > On 3/11/2025 2:41 PM, Nikunj A. Dadhania wrote:
> >> On 3/10/2025 9:09 PM, Tom Lendacky wrote:
> >>> On 3/10/25 01:45, Nikunj A Dadhania wrote:
> >>
> >>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >>>> index 50263b473f95..b61d6bd75b37 100644
> >>>> --- a/arch/x86/kvm/svm/sev.c
> >>>> +++ b/arch/x86/kvm/svm/sev.c
> >>>> @@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>>>  
> >>>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
> >>>>  	start.policy = params.policy;
> >>>> +
> >>>> +	if (snp_secure_tsc_enabled(kvm)) {
> >>>> +		u32 user_tsc_khz = params.desired_tsc_khz;
> >>>> +
> >>>> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
> >>>> +		if (!user_tsc_khz)
> >>>> +			user_tsc_khz = tsc_khz;
> >>>> +
> >>>> +		start.desired_tsc_khz = user_tsc_khz;

The code just below this clobbers kvm->arch.default_tsc_khz, which could already
have been set by userspace.  Why?  Either require params.desired_tsc_khz to match
kvm->arch.default_tsc_khz, or have KVM's ABI be that KVM stuffs desired_tsc_khz
based on kvm->arch.default_tsc_khz.  I don't see any reason to add yet another
way to control TSC.

> >>> Do we need to perform any sanity checking against this value?
> >>
> >> On the higher side, sev-snp-guest.stsc-freq is u32, a Secure TSC guest boots fine with
> >> TSC frequency set to the highest value (stsc-freq=0xFFFFFFFF).
> >>
> >> On the lower side as MSR_AMD64_GUEST_TSC_FREQ is in MHz, TSC clock should at least be 1Mhz. 
> > 
> > Something like this ?
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index b61d6bd75b37..c46b6afa969d 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2213,6 +2213,14 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  		if (!user_tsc_khz)
> >  			user_tsc_khz = tsc_khz;
> >  
> > +		/*
> > +		 * The minimum granularity for reporting Secure TSC frequency is
> > +		 * 1MHz. Return an error if the user specifies a TSC frequency
> > +		 * less than 1MHz.
> > +		 */
> > +		if (user_tsc_khz < 1000)
> > +			return -EINVAL;
> 
> Seems reasonable to me. I'll let Sean or Paolo weigh in on it. I don't
> think we need a message, there should be a check in the VMM, too, which
> would be able to provide information to the end user?

Why bother?  Userspace can DoS the guest anytime it wants.  A TSC frequency of
1MHz on a modern CPU is absolutely absurd.  Making that the minimum is is likely
going to do nothing but sow confusion.

