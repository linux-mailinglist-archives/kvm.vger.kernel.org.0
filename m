Return-Path: <kvm+bounces-40782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66876A5C8E6
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 16:53:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79C8C3B5758
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 15:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D154E25EF89;
	Tue, 11 Mar 2025 15:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SLpzHWJk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC236232792
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741708405; cv=none; b=N3JE2nBk6DgKEt3X3k/IeOvsaaZLNGJv81Hv/44cuQPlIESuJxqFH4wHOC3plVh0PgCE8AUQUlZl//g7Uk8zPUeWgLlFTxmsUk2jh9PrXdlkqTJhO1cyobotumyVoMvoQHfJyjGMjAn4p4SG5dwM3p2HScOX+Hao2+Rhq1ouUPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741708405; c=relaxed/simple;
	bh=Vl5Pzn82xwu1RL+nqT3gL/YNXUYjkq6bdLnzzSA6Zz4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aWVmadpIHUXQWapTjebrbry/0i9P8JzO3Qe/LW/iTdAiEY7s56Pe88kHsgkSo6JFf6MI9utjDdwLjXbKH72u7RXPsUvoy/ZrYXYmj6SmCpSF3WnrRMWWC+G4SxknQVWUK0pbXZZSkTDSSRuyOAsomWgbz4OWNPU3X+wWUpudOoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SLpzHWJk; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff62f96b10so8864242a91.0
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 08:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741708403; x=1742313203; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mJXe2PMXvr0gkLXLkto+7J2+5UCRfjXqdFJpCb1Hzt0=;
        b=SLpzHWJkHSchvDVgj7Af/45nOMMyBQoKFVVfP4g2qBrd8VJAnM/n0/v/8GlqAQdjQ8
         NbFZp6UvZlfCezwISCQJsVyTHjGz+V0g7R6J/NTJI+rHZgXKQTyZD1PRrA5VMa5jnqaW
         MWqxy5jta+4n41HDjvvAeEL9ubCSSNzO6j0N0AhsHYRtuWBd6rNepFmSmLXYtyuZvY8i
         G41iOnnVoafLkxSj+MCUCMt/7KvgrMHTTlE79w5ufyfB7i6RfSgy4bYvpV33tWHewBmV
         iINDqePfDrKiUA2+T9vK+S9hliIjSwOmv0RmvOV56pqPxJWQt89M8VXZtl7kfrB686+3
         J1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741708403; x=1742313203;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mJXe2PMXvr0gkLXLkto+7J2+5UCRfjXqdFJpCb1Hzt0=;
        b=PNCxLVRq7fZI2nYI7mt7IvxTpGFiIDhlZAJlOBeRRr76jhZR+CRArPbwEYzbQslhLo
         XLYrrt7RRgMVSmXO5au8lv8wv9fHE2XEKn/BiAlQeUNAYYXJYbi3r2/gH4On8V40nryi
         iq9+f+4UjwO3b9DMF3wWQI4STtRl5xXayfaVjOrgVJ7OVAS8471XjDkcDFN6UG4EJR7F
         77k9Dsdsqi8JXKH2kZOMlQ1VAk+yljiOYtJxqCcWwLRgdccH27COnaGGHSBnjMqVfTDo
         jEjxEn8ji0glVkxKDxA3NJrSk3j93ssF8+/jtrnLebpWwbjq5LeByDngr3QDFoizx1jA
         v5Eg==
X-Forwarded-Encrypted: i=1; AJvYcCVWXJTpYnphYcZRN9+dAID94jNjkoydon61pwNhutnIBVtUwm6mCVT5lLY7WynfFcPNY5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzYurh1D4HHPS5oA2MYaYQTMW6yB1nJiWj4b4IFFRaWgxK8kbo8
	XBc5baSe6bC7Urhg4Y9aKitp6eRfxZ+hxQbseMzZEx1GNaOlQrYM7lU7esvIm3hKWvUtsPj7ON0
	nFw==
X-Google-Smtp-Source: AGHT+IEZTfpwSe1b9l6uWQRx/m0lgHSIfYbL734QyAO5YeHzrR3sxzvLMqi5iZFUI4XgvKFJFTSB0cUdL5k=
X-Received: from pjbsy11.prod.google.com ([2002:a17:90b:2d0b:b0:2f2:e97a:e77f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c01:b0:2fa:3174:e344
 with SMTP id 98e67ed59e1d1-301005a6f46mr5364218a91.14.1741708402934; Tue, 11
 Mar 2025 08:53:22 -0700 (PDT)
Date: Tue, 11 Mar 2025 08:53:21 -0700
In-Reply-To: <73c6c8ea-93a0-4e2b-b5fe-74ea972b1a2c@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250310063938.13790-1-nikunj@amd.com> <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-4-nikunj@amd.com> <5ac9fdb6-cbc5-2669-28fa-f178556449ca@amd.com>
 <cc076754-f465-426b-b404-1892d26e8f23@amd.com> <d92856e0-cc43-4c51-88c7-65f4c70424bf@amd.com>
 <0d121f41-a31d-1c0b-22cb-9533dd983b8a@amd.com> <Z9BOEtM6bm-ng68c@google.com> <73c6c8ea-93a0-4e2b-b5fe-74ea972b1a2c@amd.com>
Message-ID: <Z9Bcceu2755QY7cS@google.com>
Subject: Re: [PATCH v4 5/5] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: "Nikunj A. Dadhania" <nikunj@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Mar 11, 2025, Nikunj A. Dadhania wrote:
> 
> 
> On 3/11/2025 8:22 PM, Sean Christopherson wrote:
> > On Tue, Mar 11, 2025, Tom Lendacky wrote:
> >> On 3/11/25 06:05, Nikunj A. Dadhania wrote:
> >>> On 3/11/2025 2:41 PM, Nikunj A. Dadhania wrote:
> >>>> On 3/10/2025 9:09 PM, Tom Lendacky wrote:
> >>>>> On 3/10/25 01:45, Nikunj A Dadhania wrote:
> >>>>
> >>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> >>>>>> index 50263b473f95..b61d6bd75b37 100644
> >>>>>> --- a/arch/x86/kvm/svm/sev.c
> >>>>>> +++ b/arch/x86/kvm/svm/sev.c
> >>>>>> @@ -2205,6 +2205,20 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >>>>>>  
> >>>>>>  	start.gctx_paddr = __psp_pa(sev->snp_context);
> >>>>>>  	start.policy = params.policy;
> >>>>>> +
> >>>>>> +	if (snp_secure_tsc_enabled(kvm)) {
> >>>>>> +		u32 user_tsc_khz = params.desired_tsc_khz;
> >>>>>> +
> >>>>>> +		/* Use tsc_khz if the VMM has not provided the TSC frequency */
> >>>>>> +		if (!user_tsc_khz)
> >>>>>> +			user_tsc_khz = tsc_khz;
> >>>>>> +
> >>>>>> +		start.desired_tsc_khz = user_tsc_khz;
> > 
> > The code just below this clobbers kvm->arch.default_tsc_khz, which could already
> > have been set by userspace.  Why?  Either require params.desired_tsc_khz to match
> > kvm->arch.default_tsc_khz, or have KVM's ABI be that KVM stuffs desired_tsc_khz
> > based on kvm->arch.default_tsc_khz.  I don't see any reason to add yet another
> > way to control TSC.
> 
> Setting of the desired TSC frequency needs to be done during SNP_LAUNCH_START,
> while parsing of the tsc-frequency happens as part of the cpu common class, 
> and kvm->arch.default_tsc_khz is set pretty late.

That's a QEMU problem, not a KVM problem, no?

