Return-Path: <kvm+bounces-36027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0373AA16FE8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 17:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82EFA18877F8
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDEAA1E9B0D;
	Mon, 20 Jan 2025 16:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DN9iP4Oq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743BA19BA6
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 16:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389534; cv=none; b=CuFZArtRsXxxS0M6ctOOXp8grSPGwgzVuxNnxjTDDFrfWvut0DcqO5wlf0z3frxaFsvhelv7Beg/mHFA0MEOI+jWZYTQkv0aQm48mGSNiA2mQOKvlyiJfC/6h766YVSAzkz5dx9WBo264rZIkiFVOo2KKI/trgYNS/GKJPasjyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389534; c=relaxed/simple;
	bh=+3EsmQj+CQK1FXr1dDZ87s9EuYXLXE9Zb/pvgfZOph4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r1wVUOa3TQIGnZweiEhhzCUNthoVJ/KZm/vlp16P2ZHrakUtuvDZU5KHs+NjFjubgW7r4AE3FcEQ3p3Wuo1nVpNMQ0oc/NVYHx3kJ0jrgY2mCJrDL3/PgCGHvdT5dVA8Zz3EcuY7z1kpGS6jQXP6nXauUcy2kZEA2PaWRZXT1DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DN9iP4Oq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737389531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tQN884q7n6iUSgOlEMeiAufxoX8VAcWcV5B2kjDvv1A=;
	b=DN9iP4OqSa7LtkppWE+iTojNMDOSBGVtTuH6nRzAt5pB572YfBU/1R3BpD9AUxeScJML4d
	YN1LVNEBl1lDaY/CAoqL81fHP5Y5vp7/6NKBvd5fe4r3at/6Tfq9zQsNBrUmbjK6+axGYK
	FVeFPAZMhls2+HtbiDOktEs9Q42fUps=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-EOFzPgYqPe2kEmgTG3bdIQ-1; Mon, 20 Jan 2025 11:12:10 -0500
X-MC-Unique: EOFzPgYqPe2kEmgTG3bdIQ-1
X-Mimecast-MFC-AGG-ID: EOFzPgYqPe2kEmgTG3bdIQ
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-aa6732a1af5so524620166b.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 08:12:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737389529; x=1737994329;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tQN884q7n6iUSgOlEMeiAufxoX8VAcWcV5B2kjDvv1A=;
        b=uK8doF2euWPi0Up6rLrCgX0tj89czylf5wsg0k7vUaoGrXUiG1ZtrOjCVkoGvnLCID
         AdJ+OD9Zhf5YE5Y54qU18LkvG3X5A/jX1j8Y/GYWZYhv/WO8Ot1rIANoevH9/8kxRrFT
         eH+IYywhRLdgrjvuAWpBZZdb8dwrUxLbdqQ57BfOzhq5KPNgN3N4THF9Kfp2hsjjOsWt
         Q+HfDjrsfARuqbHaVf0OFP0QlrvTV6K22tefgM1ofI7gw9vWszH93rEnTo6H6BkJiMzv
         Bpr97tGjNuPyhK1gHqP0gZKfLnez/L/5Wj64ApU6DBCJ0nnUHPk+YviIyYcu/5B1ADsP
         hZIg==
X-Gm-Message-State: AOJu0Yw1P1fsMf01hD195dL4oTJv9kF4/QFF6NR9fm7N00ZU6HNPA4c7
	WQUoE64ggMAsWu8Zl+OQkW8dkeyanOjnxwvVJFCj5Y5vCDXpUySL+Gf3oR65pkL2JCx7ZkDXlaa
	wlr30i/RX4UMFy5920LQMpvTwAr8Y1rCrvqhg+BPyt3XS6UTPjw==
X-Gm-Gg: ASbGncvavEqCBz7zF8ItA3JlkvPMIxArQYDDcj9UwFsALbgv9o/A+c0pxuirAcbQ3yv
	7x5pJ7iWRhMlnGOBOrFhqjahsFKJdLfrr0U8Aqmv5JUKkeTpR7QVw/LqzX3Mg1tNwmuGzc0EfEb
	8/FO2ViGEjP7cEPGDsaqCDn822fGqKJMt7BJfusEOsCd3zlPrQ5Shx5oE3JwHEke26duW+C9a3a
	PWRzJ5FMxvqcJJ/W2fPQpVnrudDBlN2JekfjdjXbLEWKcz0kj0OWE5iYcJAFHE+7yWLwjKiGEU=
X-Received: by 2002:a17:906:6a17:b0:aa6:b473:8500 with SMTP id a640c23a62f3a-ab38b44e059mr1160083566b.42.1737389529218;
        Mon, 20 Jan 2025 08:12:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFOzuEfsa1LGCGkOco9jKYBh0UrfKE+3qBmxwAqoOC+7EZVU1hty10OJU8q8CwUkvVR91OgNw==
X-Received: by 2002:a17:906:6a17:b0:aa6:b473:8500 with SMTP id a640c23a62f3a-ab38b44e059mr1160081266b.42.1737389528834;
        Mon, 20 Jan 2025 08:12:08 -0800 (PST)
Received: from [192.168.10.47] ([176.206.124.70])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-ab384f23162sm629851966b.113.2025.01.20.08.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2025 08:12:08 -0800 (PST)
Message-ID: <e939590d-c30a-4e00-be7c-584d4e80ec83@redhat.com>
Date: Mon, 20 Jan 2025 17:12:07 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] KVM: selftests: Only validate counts for
 hardware-supported arch events
To: Sean Christopherson <seanjc@google.com>,
 Mingwei Zhang <mizhang@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20250117234204.2600624-1-seanjc@google.com>
 <20250117234204.2600624-3-seanjc@google.com> <Z4rwlyysGukXBBw4@google.com>
 <Z4r4UtpAIVe-EGeI@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z4r4UtpAIVe-EGeI@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/18/25 01:39, Sean Christopherson wrote:
> On Sat, Jan 18, 2025, Mingwei Zhang wrote:
>> On Fri, Jan 17, 2025, Sean Christopherson wrote:
>>> @@ -582,18 +585,26 @@ static void test_intel_counters(void)
>>>   
>>>   	/*
>>>   	 * Detect the existence of events that aren't supported by selftests.
>>> -	 * This will (obviously) fail any time the kernel adds support for a
>>> -	 * new event, but it's worth paying that price to keep the test fresh.
>>> +	 * This will (obviously) fail any time hardware adds support for a new
>>> +	 * event, but it's worth paying that price to keep the test fresh.
>>>   	 */
>>>   	TEST_ASSERT(nr_arch_events <= NR_INTEL_ARCH_EVENTS,
>>>   		    "New architectural event(s) detected; please update this test (length = %u, mask = %x)",
>>> -		    nr_arch_events, kvm_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
>>> +		    nr_arch_events, this_cpu_property(X86_PROPERTY_PMU_EVENTS_MASK));
>>
>> This is where it would make troubles for us (all companies that might be
>> using the selftest in upstream kernel and having a new hardware). In
>> this case when we get new hardware, the test will fail in the downstream
>> kernel. We will have to wait until the fix is ready, and backport it
>> downstream, re-test it.... It takes lots of extra work.
> 
> If Intel can't upstream what should be a *very* simple patch to enumerate the
> new encoding and its expected count in advance of hardware being shipped to
> partners, then we have bigger problems.

Conceptually I have bigger problems with people running stable kernels 
than people running on really really new hardware.

However the intersection of running a pretty old kernel on a very new 
bare metal x86 system is relatively small but nonzero (those pesky 
Debian users); it may happen with cloud instances but then the 
intersection of running old selftests in a nested virt environment is 
probably even smaller.

I am not too happy about the assertion, but it does seem like the lesser 
evil.

Paolo


