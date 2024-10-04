Return-Path: <kvm+bounces-27896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF06F98FF3B
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 11:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97B85281ACB
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2024 09:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC6D5144D0A;
	Fri,  4 Oct 2024 09:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BoR167V7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8904384A31
	for <kvm@vger.kernel.org>; Fri,  4 Oct 2024 09:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728032556; cv=none; b=E3dxZtRxy6DWMUHiCd7HKUCPKOcecvDUp/QBk0LAIVuyqY0RNgNAyXY8wj1lZci82gtKDLUxBw5Rkmqr/6GoZhElIHsZuu0wLE6L//YltPQYiFQtb9CrKZ1NSbDrzPLi/Om6HO976SBOGTS+lQ//NgTK8+KaMuVqlvJrxMq48ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728032556; c=relaxed/simple;
	bh=cvj/bbwL7wzGroTNguyDg1hkU9ArUlS5iQh7ZwpA5bA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=H6bCJzy0aVAmdrynbbbHz6NnO3cAqEBeT1EN/M2vzWUwOnnIBSKGdvMudAEMEgnQ6kxeAx5wRCtwoJDUWj9o9L0O55hoMSuFnmdFfHoEvLBvpOq3axw6Jt7WossyIPPq4tvZrHVOf1ICXZYEzhbwgfBH4pqW7Wyf6RXJf2i51so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BoR167V7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728032553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EWV61+NjRLWN9h7jRFDU6mqmJ25L5jQ7Jfta7diEgeg=;
	b=BoR167V762zG+nZNF0yixrYPbhOkMbZaSUJOW8cr3YZSb8DSjJuJOXiiaIjBPZdEPBX3cQ
	/R8hQZMlqqFFUVWIyb093qDqltal4cjogihr4mf7ZePkEW1fKDa8zE5yNRSm/0vzAw9FQE
	beVikmu3Li8UYK02tPyJ15D34yAVzZY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-AI07o8OkM4G400Pb4l1VdA-1; Fri, 04 Oct 2024 05:02:32 -0400
X-MC-Unique: AI07o8OkM4G400Pb4l1VdA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-42cb471a230so13904935e9.3
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2024 02:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728032551; x=1728637351;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EWV61+NjRLWN9h7jRFDU6mqmJ25L5jQ7Jfta7diEgeg=;
        b=GvuKZxwBZAQlQ1q1IdkmV9z0l/fsXQMhGFlcs2Q28ZWA+w4GkNW7rcDf7fHRUKukfv
         Cz58JPhVfftUqEPYmme9NwpbFqeDXkfvBjDLzBhDkIoX5vx2T+aMZ8q5JUIukIXPryy+
         zU7sO/SLziGW45L3Mo3287/eWG4o56+Y9K2NBsQ4nIxgH9e/QwCsUj30itRslLFYGEs9
         fYx+Ti40skfoKXGd3hjzn9JplHtXqFI/XQoknRS3BCr1YcXMhFV2WA5FYVor22ethzwR
         Cj074V5KiP11VG6/cXcCmzUgWchq9C383U5IsEF35Vaz/rmnoyHy98qywzBy964EsIIa
         7IXw==
X-Gm-Message-State: AOJu0Yz9UKXwCmUrBOWU+nQ0gu/UdQzh3/6u9FHIgEWwFFanTKngGVTA
	PWZ/3AOFm8QqU8AkOTHpErfuholSXhb+OA4DXLE97udMKzpdqc5Sx3XCf3Ss1i3B7MovMu0i824
	Pupbu7B3W83msd7WtnR+IUGsZ1b/X7cP50Vf9oCvSQmQvJgFChQ==
X-Received: by 2002:a05:600c:190b:b0:42f:80f4:ab2b with SMTP id 5b1f17b1804b1-42f85ab77admr13509665e9.19.1728032551248;
        Fri, 04 Oct 2024 02:02:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGlsgXZOEZhhT2agJz2PyCQZK8FXrDwrnLcuhnP9smApMIRgbHENsTThEkN+2vw+ZCeMZxKbQ==
X-Received: by 2002:a05:600c:190b:b0:42f:80f4:ab2b with SMTP id 5b1f17b1804b1-42f85ab77admr13509445e9.19.1728032550809;
        Fri, 04 Oct 2024 02:02:30 -0700 (PDT)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42f86b444a4sm10247255e9.29.2024.10.04.02.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 02:02:30 -0700 (PDT)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] KVM: selftests: Precisely mask off dynamic fields
 in CPUID test
In-Reply-To: <20241003234337.273364-3-seanjc@google.com>
References: <20241003234337.273364-1-seanjc@google.com>
 <20241003234337.273364-3-seanjc@google.com>
Date: Fri, 04 Oct 2024 11:02:29 +0200
Message-ID: <87setci6l6.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> When comparing vCPU CPUID entries against KVM's supported CPUID, mask off
> only the dynamic fields/bits instead of skipping the entire entry.
> Precisely masking bits isn't meaningfully more difficult than skipping
> entire entries, and will be necessary to maintain test coverage when a
> future commit enables OSXSAVE by default, i.e. makes one bit in all of
> CPUID.0x1 dynamic.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  .../testing/selftests/kvm/x86_64/cpuid_test.c | 61 +++++++++++--------
>  1 file changed, 36 insertions(+), 25 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
> index fec03b11b059..f7fdcef5fa59 100644
> --- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
> @@ -12,17 +12,16 @@
>  #include "kvm_util.h"
>  #include "processor.h"
>  
> -/* CPUIDs known to differ */
> -struct {
> -	u32 function;
> -	u32 index;
> -} mangled_cpuids[] = {
> -	/*
> -	 * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR,
> -	 * which are not controlled for by this test.
> -	 */
> -	{.function = 0xd, .index = 0},
> -	{.function = 0xd, .index = 1},
> +struct cpuid_mask {
> +	union {
> +		struct {
> +			u32 eax;
> +			u32 ebx;
> +			u32 ecx;
> +			u32 edx;
> +		};
> +		u32 regs[4];
> +	};
>  };
>  
>  static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
> @@ -56,17 +55,23 @@ static void guest_main(struct kvm_cpuid2 *guest_cpuid)
>  	GUEST_DONE();
>  }
>  
> -static bool is_cpuid_mangled(const struct kvm_cpuid_entry2 *entrie)
> +static struct cpuid_mask get_const_cpuid_mask(const struct kvm_cpuid_entry2 *entry)
>  {
> -	int i;
> +	struct cpuid_mask mask;
>  
> -	for (i = 0; i < ARRAY_SIZE(mangled_cpuids); i++) {
> -		if (mangled_cpuids[i].function == entrie->function &&
> -		    mangled_cpuids[i].index == entrie->index)
> -			return true;
> +	memset(&mask, 0xff, sizeof(mask));
> +
> +	switch (entry->function) {
> +	case 0xd:
> +		/*
> +		 * CPUID.0xD.{0,1}.EBX enumerate XSAVE size based on the current
> +		 * XCR0 and IA32_XSS MSR values.
> +		 */
> +		if (entry->index < 2)
> +			mask.ebx = 0;
> +		break;
>  	}
> -
> -	return false;
> +	return mask;
>  }
>  
>  static void compare_cpuids(const struct kvm_cpuid2 *cpuid1,
> @@ -79,6 +84,8 @@ static void compare_cpuids(const struct kvm_cpuid2 *cpuid1,
>  		    "CPUID nent mismatch: %d vs. %d", cpuid1->nent, cpuid2->nent);
>  
>  	for (i = 0; i < cpuid1->nent; i++) {
> +		struct cpuid_mask mask;
> +
>  		e1 = &cpuid1->entries[i];
>  		e2 = &cpuid2->entries[i];
>  
> @@ -88,15 +95,19 @@ static void compare_cpuids(const struct kvm_cpuid2 *cpuid1,
>  			    i, e1->function, e1->index, e1->flags,
>  			    e2->function, e2->index, e2->flags);
>  
> -		if (is_cpuid_mangled(e1))
> -			continue;
> +		/* Mask off dynamic bits, e.g. OSXSAVE, when comparing entries. */
> +		mask = get_const_cpuid_mask(e1);
>  
> -		TEST_ASSERT(e1->eax == e2->eax && e1->ebx == e2->ebx &&
> -			    e1->ecx == e2->ecx && e1->edx == e2->edx,
> +		TEST_ASSERT((e1->eax & mask.eax) == (e2->eax & mask.eax) &&
> +			    (e1->ebx & mask.ebx) == (e2->ebx & mask.ebx) &&
> +			    (e1->ecx & mask.ecx) == (e2->ecx & mask.ecx) &&
> +			    (e1->edx & mask.edx) == (e2->edx & mask.edx),
>  			    "CPUID 0x%x.%x differ: 0x%x:0x%x:0x%x:0x%x vs 0x%x:0x%x:0x%x:0x%x",
>  			    e1->function, e1->index,
> -			    e1->eax, e1->ebx, e1->ecx, e1->edx,
> -			    e2->eax, e2->ebx, e2->ecx, e2->edx);
> +			    e1->eax & mask.eax, e1->ebx & mask.ebx,
> +			    e1->ecx & mask.ecx, e1->edx & mask.edx,
> +			    e2->eax & mask.eax, e2->ebx & mask.ebx,
> +			    e2->ecx & mask.ecx, e2->edx & mask.edx);
>  	}
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly


