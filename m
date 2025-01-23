Return-Path: <kvm+bounces-36352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1151CA1A463
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:35:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C87EC18819F5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6958B20F087;
	Thu, 23 Jan 2025 12:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BXS7gvt3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF1C3596B
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 12:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737635724; cv=none; b=PFBm5RNRn8UAso7y4OYyLhm5qCi2tw3s+V6klaFwMMhRDVXiR2boFy6B6Mcxafw+jb2xAbelU89YW/TPIJoNoHO3CjI8kr+csKSUkmDqGBU6PdbOVREmbTvpFBSomU+hKxKPELZM+06lNI3TgTSWdNxeF+y9+HjIeDiqXcWWT6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737635724; c=relaxed/simple;
	bh=xnFi+wOJypDbDOuWBma0iM8HogcsxEUv2vuCeSTtlvw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tF76Oek0ba6GqnmXnVxWIWLPVB2jsTVg66k0HoUOBTX4bDtB4StomoahthtXqN9VdoTF5CYW8ia91vOpm2DM0uC7iix4CLzDj1GtUIR1GIJKVG250cEdn1pAm2ztLMou7XJy1B6wKLZB1/KZfXmv7pGnptDJG+tUN9OOhnJv9tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BXS7gvt3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737635721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m8606wbDjuykWUSCHLg5Z4OmTqWmwe2NXbgkVdN2fJg=;
	b=BXS7gvt3ENO734xEbi65Jb3pZI4p2bc3SGEj8fOpCT3j6c8OwQn8iEI0o0r0aJsBgHnNCi
	Wpj+lqEmoLqqWIyTlX2vPIUedCxCtjAj3Dg5INjn1146aVjwj6zHHMSJEYBFKpmNO07M6R
	Ik7ZkZgcicBW31/ldG2Tfqy6S87yqEs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-z4AvbsW3OCSXcj_X42Sd9Q-1; Thu, 23 Jan 2025 07:35:20 -0500
X-MC-Unique: z4AvbsW3OCSXcj_X42Sd9Q-1
X-Mimecast-MFC-AGG-ID: z4AvbsW3OCSXcj_X42Sd9Q
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4361efc9d1fso7076175e9.2
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 04:35:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737635719; x=1738240519;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m8606wbDjuykWUSCHLg5Z4OmTqWmwe2NXbgkVdN2fJg=;
        b=rlhMjm+2xsdbq0IEdww28kpdApnEFWijXfugdL4A1zVo0s1xBOPa0ANwtYaA81j1Xv
         aJ3tab4gia4aepmikOD3G4lb6EyKY2VBZIxkyZWutTGZhwxI4ztVQqDvCj/RPnQdQ3/T
         ilIrCsOJmb/F3GD0i8A1Y0/lbwGUvmE4xcPZg86jEbeNUAReStJu/L5vCpAB3OCmlIgZ
         quPPb/ilFKCbl70UZmZlbKx/HRgJzTk0V0nQh0M0fPyGnH2KQNdjWCLNVs80U5bbbzkD
         YXOWdzcrFT/ctCG/RCR7efHdvYTjGhvgM/TSy+UG00bvXOL/nV/9ZqSpbvE+nPbLH/ME
         cIkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvJ/LhfTyaCGHH4cxOUhS6QzC2BGEVS+UDZ27VoEZIIwWNtBb2OgHO2tey3rjZDOMx4FQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGvBotv6mx6N6dYJ29P0wtFQrIXDT1cirvDoo6VtwtPoWREEXq
	ir+hgT9UFmTEkLYIy3N1uzpRyQZSbFT0zoaO105j6cI5bYKDnQfolSoTN/gUecLm8wEW45ypNl+
	UYJCgP6UpDR0BClZIUSyuxkZtkAMp8+o/sDvRiJzY2k7fzYQwGO6Huew1JA==
X-Gm-Gg: ASbGncsEb5TwTfrgNO+WaFlBoiEfBBGN9t6/5UHrCP1CDftfXNGqnKj5NhUHXN/jXwV
	YU2B4PfH/rZKsjiq6i/p0eq0iul8qYkUCTBMXpXYpKOj2bBxBwlAYF6UqrxtTKBcMSv7LN3iCOV
	2OvRts3NRH4B/iKcHMDRU2MZOkGbkC5op8X5650NE6xrM6FaqfHKsj/VWnb8mDu2jw6KqoQqskT
	p3Y+7luvRnLPk3xVLgtqxavdEML2hsN2yBZ28aJo3yIseGosKxIsRIroZBnexvu
X-Received: by 2002:a05:600c:4e89:b0:436:30e4:459b with SMTP id 5b1f17b1804b1-438913f1649mr250850325e9.18.1737635719164;
        Thu, 23 Jan 2025 04:35:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEC4nMXDk7Ulk569V8Hjp92gcI6PLi8LlyaLduqUrS8eS5+QtUPpRjnXFGrijzXxgvwLXzPHA==
X-Received: by 2002:a05:600c:4e89:b0:436:30e4:459b with SMTP id 5b1f17b1804b1-438913f1649mr250850045e9.18.1737635718762;
        Thu, 23 Jan 2025 04:35:18 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31b7655sm59718235e9.30.2025.01.23.04.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 04:35:18 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, David Woodhouse
 <dwmw2@infradead.org>
Cc: paul@xen.org, Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave
 Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
In-Reply-To: <Z5FqdjTwPmnV1t-1@google.com>
References: <20250122161612.20981-1-fgriffo@amazon.co.uk>
 <87tt9q7orq.fsf@redhat.com> <a5d69c3b-5b9f-4ecf-bae2-2110e52eac64@xen.org>
 <87r04u7ng7.fsf@redhat.com>
 <06e9f951afb46098983dc009c0efbcef3fc1b246.camel@infradead.org>
 <Z5FqdjTwPmnV1t-1@google.com>
Date: Thu, 23 Jan 2025 13:35:17 +0100
Message-ID: <87ldv17loa.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jan 22, 2025, David Woodhouse wrote:
>> On Wed, 2025-01-22 at 18:44 +0100, Vitaly Kuznetsov wrote:
>> > > What is the purpose of the comparison anyway?
>
> To avoid scenarios where KVM has configured state for a set of features X, and
> doesn't correctly handle vCPU features suddenly become Y.  Or more commonly,
> where correctly handling such transitions (if there's even a "correct" option)
> is a complete waste of time and complexity because no sane setup will ever add
> and/or remove features from a running VM.
>
>> > > IIUC we want to ensure that a VMM does not change its mind after KVM_RUN
>> > > so should we not be stashing what was set by the VMM and comparing
>> > > against that *before* mangling any values?
>> > 
>> > I guess it can be done this way but we will need to keep these 'original'
>> > unmangled values for the lifetime of the vCPU with very little gain (IMO):
>> > KVM_SET_CPUID{,2} either fails (if the data is different) or does (almost)
>> > nothing when the data is the same.
>
> More importantly, userspace is allowed to set the CPUID returned by KVM_GET_CPUID2.
> E.g. selftests do KVM_GET_CPUID2 specifically to read the bits that are managed
> by KVM.
>
> Disallowing that would likely break userspace, and would create a weird ABI where
> the output of KVM_GET_CPUID2 is rejected by KVM_SET_CPUID2.
>
>> If they're supposed to be entirely unchanged, would it suffice just to
>> keep a hash of them?

In case we want to support both cases:
- VMM calls KVM_SET_CPUID2 at some point in vCPU's lifetime with the
same data it used initially;
- VMM does KVM_GET_CPUID2 and feeds this directly into KVM_SET_CPUID2
we can't use a hash as the later contains entries mangled by
KVM. Currently, we kind of support both but we expect the result of the
mangling done by KVM to always be the same.

I guess we can change the logic the following: when KVM_SET_CPUID2 is
called on a vCPU again we check that all entries which KVM did not touch
match. For that, we will need to keep a list of mangled entries so we
can introduce a kvm_mangle_cpuid_entry() helper to avoid the need to
keep a static list. Personally, I'm not sure this is not an overkill
though.

-- 
Vitaly


