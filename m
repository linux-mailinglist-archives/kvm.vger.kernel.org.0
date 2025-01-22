Return-Path: <kvm+bounces-36285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56675A19800
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 18:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C64A87A3082
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 17:49:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3547F2163A1;
	Wed, 22 Jan 2025 17:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oi0eEiL7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1CA2153D5
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737567888; cv=none; b=Wiqbh/Cbshi2iKvWCu2iq2QiP2XF48e9YWwyHdqKpswq8yygeKjB8qOXoEa5qvajJMFaicca3rKGwEK+ts4aH0ze6gDaBQWqCQtmEpn4q5LmrSj0xrKMM8N0NcgdrGNx5xckg68KlslJgpwBNFo6r+fy1vtL452qcZhztp4sn+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737567888; c=relaxed/simple;
	bh=9+dYk6uLPNaSfPahFJwjv2TJWB45nPzIcxXEYA0CRvk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eANoejnLVo6yHf1I/dNyZMWe4VgeIdy9EZAXwauBEVEEA4PZo7BEBf1vV4z1eB8XU/3PjksAM+JWVfEJ7qWae2iuuARXPoAHcW4F4nROjb903PP9HOtwcRjTfzH7BqvB9ocFy+9szFLHNr/bXH3JwpgtUpZh6it9uk5khSbx+0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oi0eEiL7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737567885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0mKiKkRzZUgeGTjqlBuywLicTrfkha+hCUcAXkj1MAM=;
	b=Oi0eEiL7XIMe4gZbO43hOqxFSvC9ASvzVfaEAeN5vlPP32F7z1E4bvTeDQkpKMh/2GWoC+
	gKWaN32zwQ2HzqDsrMrZ+DJUmmfCSaFr3staXSC7DzdnkjWdHm6GLarBBgI/1JGj9AVxZP
	DqnhaF/fkBXbuTEn4eMMKM283PW6Qy8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-M1olSR2iPZSC3SxWXWlkNQ-1; Wed, 22 Jan 2025 12:44:43 -0500
X-MC-Unique: M1olSR2iPZSC3SxWXWlkNQ-1
X-Mimecast-MFC-AGG-ID: M1olSR2iPZSC3SxWXWlkNQ
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-385d7611ad3so4487651f8f.2
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 09:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737567882; x=1738172682;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0mKiKkRzZUgeGTjqlBuywLicTrfkha+hCUcAXkj1MAM=;
        b=MZCPGhj5rE0lJJ5MANzNUYyr9ysV4uTaEW5BwG90BSHXGnO0IWYUoY178ewTGywAkO
         N51sUfiJ7g0evPkPI6t6LmJaACi9TwIaNB/zfldxPDV4s0+EFchH3sp4q+zfV68ljZtN
         406vxhs215hB6jAYlPLdsHJ/MBIMJtTaio+8/gpqP9kcjhaVt96pVgjiSzRMBVZBO41u
         4/3f2ltxxtlC6z1Jvzg66riuFeFPrAa56iXSR6vKB9UNXTORUXiNmXQ7b7EnIrNhbq06
         XOWX/4KJgfn9/eFj1QEyOvCgQrkXsQoAVN0h9Vvno0jeDYWdXEaJti2S50qC5iZCDdyk
         OOsg==
X-Forwarded-Encrypted: i=1; AJvYcCXt675bLIMKyhZgcRKLrS9qiBmL3dVDg2YML5ccjiVdO2Ik2ua/sACFqVzCBpcbYoEP9mU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyzNF9Va+9wIq2O+JfFhEtPte3qwpllkJly3XEJ5LE8d6kfq89
	JWKrziGMqgRoas8aIRgjR/h4rTk66gATWJ/a7ZtImQC2jCDXRnzupWs4zCkerI/fxfFnfrd4mTh
	XAxwjNYtk4F8KHY9vFogFX4vOIRBLIE+sD6XiXpm3N4IwtRQNEw==
X-Gm-Gg: ASbGnctfZnhE/9jpn3tTyw386XejlMmBOecFw+BWygi37q7Y2tWy5OyXUQRVD6Lou21
	uUK2dkqJ8ErP0LbdEbCVwEkqQ5R9zW0M4lkOc9KOp1M6a9hdUBlZ5zEQX+nNAgqfnos2na3zd5e
	gGQ9RdywAZw4h6z64ky+SBwz6IuDsK4JPUht4b7YCmlIZ1d+Fq8J9NxDA6cLxcy2ZE1mPxTWMxm
	nX6IRpL3R7kcC0IiBlPxcjedqYdRjljeNU0gYLDnfuLUdkipqKV6RcJVEQoRZVb
X-Received: by 2002:a05:6000:1a8c:b0:385:e5d8:2bea with SMTP id ffacd0b85a97d-38bf56639c9mr19598827f8f.20.1737567882531;
        Wed, 22 Jan 2025 09:44:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDOBXvsJXq7GbkbLYKEhW7E7CbQYXUCT5onjS2F9ksK1iDunvcE5QpwuEznxi/SuLc8Yw7WA==
X-Received: by 2002:a05:6000:1a8c:b0:385:e5d8:2bea with SMTP id ffacd0b85a97d-38bf56639c9mr19598813f8f.20.1737567882216;
        Wed, 22 Jan 2025 09:44:42 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221a5csm17131075f8f.34.2025.01.22.09.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 09:44:41 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: paul@xen.org, Fred Griffoul <fgriffo@amazon.co.uk>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, David Woodhouse <dwmw2@infradead.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Update Xen-specific CPUID leaves during mangling
In-Reply-To: <a5d69c3b-5b9f-4ecf-bae2-2110e52eac64@xen.org>
References: <20250122161612.20981-1-fgriffo@amazon.co.uk>
 <87tt9q7orq.fsf@redhat.com> <a5d69c3b-5b9f-4ecf-bae2-2110e52eac64@xen.org>
Date: Wed, 22 Jan 2025 18:44:40 +0100
Message-ID: <87r04u7ng7.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paul Durrant <xadimgnik@gmail.com> writes:

> On 22/01/2025 17:16, Vitaly Kuznetsov wrote:
>> Fred Griffoul <fgriffo@amazon.co.uk> writes:
>> 
>>> Previous commit ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before
>>> updating vcpu->arch.cpuid_entries") implemented CPUID data mangling in
>>> KVM_SET_CPUID2 support before verifying that no changes occur on running
>>> vCPUs. However, it overlooked the CPUID leaves that are modified by
>>> KVM's Xen emulation.
>>>
>>> Fix this by calling a Xen update function when mangling CPUID data.
>>>
>>> Fixes: ee3a5f9e3d9b ("KVM: x86: Do runtime CPUID update before
>>> updating vcpu->arch.cpuid_entries")
>> 
>> Well, kvm_xen_update_tsc_info() was added with
>> 
>> commit f422f853af0369be27d2a9f1b20079f2bc3d1ca2
>> Author: Paul Durrant <pdurrant@amazon.com>
>> Date:   Fri Jan 6 10:36:00 2023 +0000
>> 
>>      KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present
>> 
>> and the commit you mention in 'Fixes' is older:
>> 
>> commit ee3a5f9e3d9bf94159f3cc80da542fbe83502dd8
>> Author: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Date:   Mon Jan 17 16:05:39 2022 +0100
>> 
>>      KVM: x86: Do runtime CPUID update before updating vcpu->arch.cpuid_entries
>> 
>> so I guess we should be 'Fixing' f422f853af03 instead :-)
>> 
>>> Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
>>> ---
>>>   arch/x86/kvm/cpuid.c | 1 +
>>>   arch/x86/kvm/xen.c   | 5 +++++
>>>   arch/x86/kvm/xen.h   | 5 +++++
>>>   3 files changed, 11 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index edef30359c19..432d8e9e1bab 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -212,6 +212,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
>>>   	 */
>>>   	kvm_update_cpuid_runtime(vcpu);
>>>   	kvm_apply_cpuid_pv_features_quirk(vcpu);
>>> +	kvm_xen_update_cpuid_runtime(vcpu);
>> 
>> This one is weird as we update it in runtime (kvm_guest_time_update())
>> and values may change when we e.g. migrate the guest. First, I do not
>> understand how the guest is supposed to notice the change as CPUID data
>> is normally considered static. Second, I do not see how the VMM is
>> supposed to track it as if it tries to supply some different data for
>> these Xen leaves, kvm_cpuid_check_equal() will still fail.
>> 
>> Would it make more sense to just ignore these Xen CPUID leaves with TSC
>> information when we do the comparison?
>> 
>
> What is the purpose of the comparison anyway? IIUC we want to ensure 
> that a VMM does not change its mind after KVM_RUN so should we not be 
> stashing what was set by the VMM and comparing against that *before* 
> mangling any values?
>

I guess it can be done this way but we will need to keep these 'original'
unmangled values for the lifetime of the vCPU with very little gain (IMO):
KVM_SET_CPUID{,2} either fails (if the data is different) or does (almost)
nothing when the data is the same.

-- 
Vitaly


