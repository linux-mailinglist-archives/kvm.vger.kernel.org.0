Return-Path: <kvm+bounces-51980-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A5B68AFEDFE
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 17:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8680E4E421F
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 15:46:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B88C2E8DF9;
	Wed,  9 Jul 2025 15:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+wAkBXu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A89AF2E613F
	for <kvm@vger.kernel.org>; Wed,  9 Jul 2025 15:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752075994; cv=none; b=QbsEoCmj5FIi1wZJrWCMRRdA1r7q1iIgxi8UMrkjx6xWDtIq5WoTZHIM/rtpQruGLorMiwYC+sf2g4iCFWRF/A5V8KLAROEMLI/Ga8yQSVk8LpzXfCJqNQ7D4KSZqzrsyRrrt0o4hqT9ybMHud/y8XH+zdue/6k42ppKFnG2kV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752075994; c=relaxed/simple;
	bh=WAq6X8gLKLtsCYe4GvFLjHjmRCUnVoQ8X8DTjzp3uJc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=GUZ+nLVR04Z4l25sT8Zo/IL3d63Lx44CisvtYlRAShifqdTLLA9zo1UK92he/m8kyhWLjK1G6iY6HYiKFMRZwYLCxhiCRyz1UPJa5O9yvdck6xm6mQPBd0twUY9QXWGUQGquXxacArKXpiq3lmt+t3Ms6FAl9AfQ04Zu3Rk2kJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P+wAkBXu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752075991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qX2+U56Doe6O5KPy8vxSLK1AIbRo7RJ7CWcz4fuNoKo=;
	b=P+wAkBXuKSfx0I1mQafnXs3YWIBuF01T4M4B8re7fQW9t12x4Q5z8NpAIHM5rbh8JbyjSQ
	t8wECMhGiclAUoPC8PFOFW8PhFo8BnRk3edp/C50M7JXBZxkWmTAj75+I/PzxxZDKVyrJe
	gwS+LlbGlDXUtygRD4x30eiIAA8F2Zs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-h0htnq0yO1Cc_vI6rp8H-g-1; Wed, 09 Jul 2025 11:46:30 -0400
X-MC-Unique: h0htnq0yO1Cc_vI6rp8H-g-1
X-Mimecast-MFC-AGG-ID: h0htnq0yO1Cc_vI6rp8H-g_1752075985
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f85f31d9so34302f8f.1
        for <kvm@vger.kernel.org>; Wed, 09 Jul 2025 08:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752075984; x=1752680784;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qX2+U56Doe6O5KPy8vxSLK1AIbRo7RJ7CWcz4fuNoKo=;
        b=NCooy8W8GuHBRzC+023WSDoYN1ayErFUxDmxZa/dLUkjmAQGblcqPf7uGrW+jhSXJa
         mYgyZ/vZAb0MXPR1Nks7iUXnBBqejQcp5ayRpsGLZ0aO+4dIvH3g4XU+/ulP6+mhvW3F
         bxAJ5USYwEapb64Iy2VUzwAz1WLxm4aDpaYlZ7vjvfnt3MNE1feLJv4QK25D0ka5zpc9
         LBvZqY8obn1/Hnii1GKwABFXlymNjBRrbylJBHoQAv0X2mQm5/Bs2Z8+6HDwLlLymlgT
         CNAnj87qYFUytcVJBoKjOTEv4loJ2c41UjTwnzR+jC1hLYA6rAY9Zan4l2+j7xixCwcu
         UBZg==
X-Forwarded-Encrypted: i=1; AJvYcCWtXoLbJR9aO8nKUb5Usz9b2ZA+atpR/a0m7+mqESe2dbpJ2UQEkXUNIW/bovFkDXSWdvA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzfkscReqpF8a4elva7Dutxnd+gjmCMFOlG+m3MjNkB5nOzMdBf
	R5vqNbKVNPATthByizhpv2D/bgYhLeE6iYSuoHtn/ssTwWY1N0vAuQS4QKIeRpgFnNODXXpzvcL
	X1kh9mlgdoADVz6RoS/5X6N4kyBRzTger2b6+jk83i/C1+QsIGi7p8n8ME3a5yVi+TZl3bi92yE
	d/zQ01Kxx1XpqnOfDwJ5sqd1bOdsF2HbD0pXRdjA==
X-Gm-Gg: ASbGncsbsdRoajHiy9B7UI522XtkDazSFTHaMbF7f0MHlMMLVSXU7fZGNm3jifknlYZ
	xrIhph1zt5DfnQwZdXrKYnpnjO1aUnNkYPaG2wcAU6ZKjd9cdJj9wJu6m8bf5wJ+bue54pBLz+p
	JzTKjcbUBBhA4EMVWOx46m/lNPNaXmc+Ff+iS9z1PvLJKBCTgwATzAdc/VzfGO7ATtK78+Ax55p
	IC3/IgCJuC9WOmEo6rExFUZGDyyHFbAfIHnBUzZTuCiLa6DeiHhZElOLsiZCaS7hJCtHiF2mxMn
	wQmE4nJGHCUEoXLXeA==
X-Received: by 2002:a5d:584a:0:b0:3b5:e631:404e with SMTP id ffacd0b85a97d-3b5e7880feamr512417f8f.11.1752075984531;
        Wed, 09 Jul 2025 08:46:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+VXt8UflaBx9N9+VFLECmBUXVr7laX0K70+n281DypajoTyeiy9u7ILUxrHU1Hfw4cJ1UJw==
X-Received: by 2002:a5d:584a:0:b0:3b5:e631:404e with SMTP id ffacd0b85a97d-3b5e7880feamr512358f8f.11.1752075983916;
        Wed, 09 Jul 2025 08:46:23 -0700 (PDT)
Received: from fedora (g3.ign.cz. [91.219.240.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454d5061a91sm30870505e9.17.2025.07.09.08.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 08:46:22 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 alanjiang@microsoft.com, chinang.ma@microsoft.com,
 andrea.pellegrini@microsoft.com, Kevin Tian <kevin.tian@intel.com>, "K. Y.
 Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
 Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
 linux-hyperv@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] KVM: VMX: Use Hyper-V EPT flush for local TLB
 flushes
In-Reply-To: <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
References: <cover.1750432368.git.jpiotrowski@linux.microsoft.com>
 <4266fc8f76c152a3ffcbb2d2ebafd608aa0fb949.1750432368.git.jpiotrowski@linux.microsoft.com>
 <875xghoaac.fsf@redhat.com>
 <ca26fba1-c2bb-40a1-bb5e-92811c4a6fc6@linux.microsoft.com>
Date: Wed, 09 Jul 2025 17:46:21 +0200
Message-ID: <87o6tttliq.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:

> On 27/06/2025 10:31, Vitaly Kuznetsov wrote:
>> Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:
>> 
>>> Use Hyper-V's HvCallFlushGuestPhysicalAddressSpace for local TLB flushes.
>>> This makes any KVM_REQ_TLB_FLUSH_CURRENT (such as on root alloc) visible to
>>> all CPUs which means we no longer need to do a KVM_REQ_TLB_FLUSH on CPU
>>> migration.
>>>
>>> The goal is to avoid invept-global in KVM_REQ_TLB_FLUSH. Hyper-V uses a
>>> shadow page table for the nested hypervisor (KVM) and has to invalidate all
>>> EPT roots when invept-global is issued. This has a performance impact on
>>> all nested VMs.  KVM issues KVM_REQ_TLB_FLUSH on CPU migration, and under
>>> load the performance hit causes vCPUs to use up more of their slice of CPU
>>> time, leading to more CPU migrations. This has a snowball effect and causes
>>> CPU usage spikes.
>>>
>>> By issuing the hypercall we are now guaranteed that any root modification
>>> that requires a local TLB flush becomes visible to all CPUs. The same
>>> hypercall is already used in kvm_arch_flush_remote_tlbs and
>>> kvm_arch_flush_remote_tlbs_range.  The KVM expectation is that roots are
>>> flushed locally on alloc and we achieve consistency on migration by
>>> flushing all roots - the new behavior of achieving consistency on alloc on
>>> Hyper-V is a superset of the expected guarantees. This makes the
>>> KVM_REQ_TLB_FLUSH on CPU migration no longer necessary on Hyper-V.
>> 
>> Sounds reasonable overall, my only concern (not sure if valid or not) is
>> that using the hypercall for local flushes is going to be more expensive
>> than invept-context we do today and thus while the performance is
>> improved for the scenario when vCPUs are migrating a lot, we will take a
>> hit in other cases.
>> 
>

Sorry for delayed reply!

....

>>>  		return;
>>>  
>>> -	if (enable_ept)
>>> +	if (enable_ept) {
>>> +		/*
>>> +		 * hyperv_flush_guest_mapping() has the semantics of
>>> +		 * invept-single across all pCPUs. This makes root
>>> +		 * modifications consistent across pCPUs, so an invept-global
>>> +		 * on migration is no longer required.
>>> +		 */
>>> +		if (vmx_hv_use_flush_guest_mapping(vcpu))
>>> +			return (void)WARN_ON_ONCE(hyperv_flush_guest_mapping(root_hpa));
>>> +
>> 
>> HvCallFlushGuestPhysicalAddressSpace sounds like a heavy operation as it
>> affects all processors. Is there any visible perfomance impact of this
>> change when there are no migrations (e.g. with vCPU pinning)? Or do we
>> believe that Hyper-V actually handles invept-context the exact same way?
>> 
> I'm going to have to do some more investigation to answer that - do you have an
> idea of a workload that would be sensitive to tlb flushes that I could compare
> this on?
>
> In terms of cost, Hyper-V needs to invalidate the VMs shadow page table for a root
> and do the tlb flush. The first part is CPU intensive but is the same in both cases
> (hypercall and invept-single). The tlb flush part will require a bit more work for
> the hypercall as it needs to happen on all cores, and the tlb will now be empty
> for that root.
>
> My assumption is that these local tlb flushes are rather rare as they will
> only happen when:
> - new root is allocated
> - we need to switch to a special root
>

KVM's MMU is an amazing maze so I'd appreciate if someone more
knowledgeble corrects me;t my understanding is that we call
*_flush_tlb_current() from two places:

kvm_mmu_load() and this covers the two cases above. These should not be
common under normal circumstances but can be frequent in some special
cases, e.g. when running a nested setup. Given that we're already
running on top of Hyper-V, this means 3+ level nesting which I don't
believe anyone really cares about.

kvm_vcpu_flush_tlb_current() from KVM_REQ_TLB_FLUSH_CURRENT. These are
things like some CR4 writes, APIC mode changes, ... which also shouldn't
be that common but VM boot time can be affected. So I'd suggest to test
big VM startup time, i.e. take the biggest available instance type on
Azure and measure how much time it takes to boot a VM which has the same
vCPU count. Honestly, I don't expect to see a significant change but I
guess it's still worth checking.

> So not very frequent post vm boot (with or without pinning). And the effect of the
> tlb being empty for that root on other CPUs should be a neutral, as users of the
> root would have performed the same local flush at a later point in
> time (when using it).
>
> All the other mmu updates use kvm_flush_remote_tlbs* which already go
> through the hypercall.

-- 
Vitaly


