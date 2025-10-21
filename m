Return-Path: <kvm+bounces-60608-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A82BF4B51
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E24446506E
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 06:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED23261B75;
	Tue, 21 Oct 2025 06:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HuzalW42"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 410D023BF80
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 06:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761028304; cv=none; b=KCqnmUEhDz5vg+3seChc0YLfq8wzdqfQvFcGOB0ONGyc9N0yhUuKH4NjAD9hvMtP1UpiWVhXR8aq4jHuzBEw9cubW5xD16gitWPZh2E7W7Xs5bTGHXM8U211N1Ke0S0/6dD1z78TroPj722js1hJ1BTNX3cUoczAnRs8hbfanLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761028304; c=relaxed/simple;
	bh=IyT6jbSa7JXteZOeYBPMAyDIFZpjyRO8knftQAqc/zc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YJaolZKhm14XxX2EtTZYQyo9Ie7j4RIxKTLUmMUNVuBfj7teFkfCdfLrLdsc+fQQ/ox3SuMazQySxnS367KZxX+xJW+HheRQQlOxqUPqdxFPAJlw8rUEF2kmdnoyYHy6uYCM8FddR87HwXG37pe/BRI00tmpj2GKZV+XSBA/hCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HuzalW42; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761028301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mJdetGy7s6Eh0AFewJxRezzgesEUhmlB3Y3ANnfqFAo=;
	b=HuzalW42lXkkjtDumag5EYr4mWyG18ASnr2v3PiUA8VtUviweYGCDzTm+LJpO/c3B/c6Oc
	0BUK9aUDArEX4q5GEClQbAZBusvkHJRHRoITrv8RILmF1KY6ztrllpaWDmtYkFup8WZWdR
	g+tt8IOxz8JOX7ywjHI4WNwWkBOAqzs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-284-ekLVLM3BMdSe8C67mXfAIw-1; Tue, 21 Oct 2025 02:31:38 -0400
X-MC-Unique: ekLVLM3BMdSe8C67mXfAIw-1
X-Mimecast-MFC-AGG-ID: ekLVLM3BMdSe8C67mXfAIw_1761028298
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-472ce95ed1dso17555955e9.3
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 23:31:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761028297; x=1761633097;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mJdetGy7s6Eh0AFewJxRezzgesEUhmlB3Y3ANnfqFAo=;
        b=pDcEGnvIXqY62Aq7bYbwJxyFNdhqGDCQ7AWtOtD2uEESz09CH4XSdpOTj1cTlgdCI7
         6Xsw7OVY7J4OvnbFgg6vU8EwK7Gi2Z6dg/pUn7/b6kgeZMFdWPZ6FGFYPJg7ZMeI//ah
         sHKF8bbA5SIYZ8c2ghUS5DUmn5vSaNicDCCLAsr66N3rOg7qiE/Gu8wCd1uuMXDiLy/w
         H3q4FaeUwBBDkh2z58urFymmyeLxqz82rq3/pfB79raLe0cdebE/UqzTFpZf2NXnVKtF
         dHlqHdYGFinxIIhCLvhIUZtUkoUBKQyuXX9NNanOBTYcvJ5k9Xu5w68mmfrTwnwprB5A
         7k9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHYaxLOl7MMfhYGdRYccGlOEbph2kXkr3hbuijBMdQU+d1yzyHQg2ZdDPNFprXeJk8zf0=@vger.kernel.org
X-Gm-Message-State: AOJu0YycD6vlrjIzrA9iHFahg4Snb1tXIcxWpOx3SvjwGiKmWDUdaXO8
	BZF8DDkiDTOVOzP6rsbTUxVmHdgZ3F1zq4RmCJ48RZG4zdEqwg5O3H9JSEsQy23xI2jXl6VBGPf
	9LTk0DNlwAptUMeXmHIHMb+T3yNs3bXx4/9CFyH7RTs9OotRO5f31gDs6JL9taA==
X-Gm-Gg: ASbGncs+5aX1hu7z3o63tFMzFLk0tOl1vKCLzZvIoAn8pBa9Zm1fUnObK58mUU9cToR
	kiylU2/eu1bWkEv9jMP88vW1OnVyOlRD7eDYF7+Khs/zQEgLeqT3d20rBEiILOA7vsjDP9eoHjf
	KiBIa6U9BvrgMdnolFqcBoECg+VutOXYbeROlKovgJsQuYh/4luMVHMcYyxACwvyTKZGF9myjiw
	VufiYdM+4IGg3+zWUxsuWfTYqD1n5pmDThJYZnkJK5h0fRC6Ke6jgM0FziFZlMDS0M4Q78GokB8
	fVQJUQN9cW0s+0uHydM5r0q0TXMPnHMLxZFqDUOvBeAER4K0DuyP578xZNcYN7f/fTwYTgX6E3Z
	fi/zkpPI8LoGOE65CpVgl7kB9TUVwhnn8YKS6rQ==
X-Received: by 2002:a05:600c:3492:b0:471:1774:3003 with SMTP id 5b1f17b1804b1-4711791c88bmr114393335e9.29.1761028297300;
        Mon, 20 Oct 2025 23:31:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGVXDUTvidurILZlOGQfMaqSjOeQ1X+IsWdk1WGAGQttjMvrC8S2YoiOfR4b/NSqr2LLboAXQ==
X-Received: by 2002:a05:600c:3492:b0:471:1774:3003 with SMTP id 5b1f17b1804b1-4711791c88bmr114393105e9.29.1761028296900;
        Mon, 20 Oct 2025 23:31:36 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:576b:abc6:6396:ed4a? ([2a01:e0a:280:24f0:576b:abc6:6396:ed4a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144239f4sm265962245e9.2.2025.10.20.23.31.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 23:31:35 -0700 (PDT)
Message-ID: <8993a80c-6cb5-4c5b-a0ef-db9257c212be@redhat.com>
Date: Tue, 21 Oct 2025 08:31:34 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/18] hw/ppc/spapr: Remove deprecated pseries-3.0 ->
 pseries-4.2 machines
To: Harsh Prateek Bora <harshpb@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
 qemu-ppc@nongnu.org, kvm@vger.kernel.org, Chinmay Rath <rathc@linux.ibm.com>
References: <20251020103815.78415-1-philmd@linaro.org>
 <fdb7e249-b801-4f57-943d-71e620df2fb3@linux.ibm.com>
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Content-Language: en-US, fr
Autocrypt: addr=clg@redhat.com; keydata=
 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
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <fdb7e249-b801-4f57-943d-71e620df2fb3@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi

On 10/21/25 06:54, Harsh Prateek Bora wrote:
> +Cedric
> 
> Hi Phillipe,
> 
> It had been done and the patches were reviewed already here (you were in CC too):
> 
> https://lore.kernel.org/qemu-devel/20251009184057.19973-1-harshpb@linux.ibm.com/

I would take the already reviewed patches, as that work is done. This series
is fine, but it is extra effort for removing dead code, which isn't worth
the time.


Thanks,

C.




> 
> Let us try to avoid duplication of implementation/review efforts.
> If the motivation to re-do is just to split, I think let us consider the original series to avoid duplication of review efforts. I should probably send more frequent PRs to avoid such scenarios in future.
> 
> Thanks for your contribution in reviewing other patches though. It's highly appreciated.
> 
> regards,
> Harsh
> 
> On 10/20/25 16:07, Philippe Mathieu-Daudé wrote:
>> Remove the deprecated pseries-3.0 up to pseries-4.2 machines,
>> which are older than 6 years. Remove resulting dead code.
>>
>> Philippe Mathieu-Daudé (18):
>>    hw/ppc/spapr: Remove deprecated pseries-3.0 machine
>>    hw/ppc/spapr: Remove SpaprMachineClass::spapr_irq_xics_legacy field
>>    hw/ppc/spapr: Remove SpaprMachineClass::legacy_irq_allocation field
>>    hw/ppc/spapr: Remove SpaprMachineClass::nr_xirqs field
>>    hw/ppc/spapr: Remove deprecated pseries-3.1 machine
>>    hw/ppc/spapr: Remove SpaprMachineClass::broken_host_serial_model field
>>    target/ppc/kvm: Remove kvmppc_get_host_serial() as unused
>>    target/ppc/kvm: Remove kvmppc_get_host_model() as unused
>>    hw/ppc/spapr: Remove SpaprMachineClass::dr_phb_enabled field
>>    hw/ppc/spapr: Remove SpaprMachineClass::update_dt_enabled field
>>    hw/ppc/spapr: Remove deprecated pseries-4.0 machine
>>    hw/ppc/spapr: Remove SpaprMachineClass::pre_4_1_migration field
>>    hw/ppc/spapr: Remove SpaprMachineClass::phb_placement callback
>>    hw/ppc/spapr: Remove deprecated pseries-4.1 machine
>>    hw/ppc/spapr: Remove SpaprMachineClass::smp_threads_vsmt field
>>    hw/ppc/spapr: Remove SpaprMachineClass::linux_pci_probe field
>>    hw/ppc/spapr: Remove deprecated pseries-4.2 machine
>>    hw/ppc/spapr: Remove SpaprMachineClass::rma_limit field
>>
>>   include/hw/ppc/spapr.h     |  16 --
>>   include/hw/ppc/spapr_irq.h |   1 -
>>   target/ppc/kvm_ppc.h       |  12 --
>>   hw/ppc/spapr.c             | 298 ++++++++-----------------------------
>>   hw/ppc/spapr_caps.c        |   6 -
>>   hw/ppc/spapr_events.c      |  20 +--
>>   hw/ppc/spapr_hcall.c       |   5 -
>>   hw/ppc/spapr_irq.c         |  36 +----
>>   hw/ppc/spapr_pci.c         |  32 +---
>>   hw/ppc/spapr_vio.c         |   9 --
>>   target/ppc/kvm.c           |  11 --
>>   11 files changed, 75 insertions(+), 371 deletions(-)
>>
> 


