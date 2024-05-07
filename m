Return-Path: <kvm+bounces-16824-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A236D8BE154
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 13:45:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1073B28825
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 11:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AFA5156F21;
	Tue,  7 May 2024 11:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VlYxvc0L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D6915252F
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 11:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715082304; cv=none; b=FizWLkj6vWV0eHEALGCyGj/izr5CMXJtiVodte5CyIxm6Cha++Wa5Y/kKRq22YeCwJIIYb5cO80eJZGE9AbulSx3PiTuel+JcA+Ap/ryMO+XfB6Zy7RiI04Llw5IIaR8DEY7qaf5bkDmk1YEwGudkhbHOUcUPkBAqOccDhkPL+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715082304; c=relaxed/simple;
	bh=tc0Z2T0sY9guCCl+/hlNGIXORrQsFpWc+byENfsUZ+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xo1TPvA5mfGhreOU3RFR7HiKt+K09moLLHHDk4FKTXHfulVSl1Dr2ZKMM/YMvm/lYyEfwD+RHLrEw+C32r7SOc/IUC+SlpZ7JmKg38PDIdUgrgPQ2EQN4EORzlB6Axi6megRZ4m46vZX+Ql1t07xRVx2JmyXm6fwhV7STkbbfyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VlYxvc0L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715082301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IdjnCRPF6KIi2xa+JTCJU6XDqzu+qhgJ7js/LxEsyeI=;
	b=VlYxvc0L7kAzBt/kVqL9OtTvAZQv+R0RZTkm+Upd3Kj8vooETg0tTcqGYDgWVfPThKNdM5
	xMGDBXbXSDf0y4hVN73EWmgDWkv7ZkiTw6IwLSTdAnMZmqOgCwg5EUMh8V28+hTXIygg+K
	2cwkDm4hbB5FgyjVRr5h87fGjkzdSnE=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-NIgRgAo1PFO-KyR73TShYg-1; Tue, 07 May 2024 07:45:00 -0400
X-MC-Unique: NIgRgAo1PFO-KyR73TShYg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6a0b7ebba6cso49660596d6.0
        for <kvm@vger.kernel.org>; Tue, 07 May 2024 04:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715082300; x=1715687100;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IdjnCRPF6KIi2xa+JTCJU6XDqzu+qhgJ7js/LxEsyeI=;
        b=MDmC4/KlJ1uZLfIP++FL4UJkGugly30vScAV8xwlSCsWzv/BhGZRsqBjXkNh6SbS0G
         tzoANW8rLokrABYvE1Pbp7ghGxNO7Yfrhiu/ZR7AwwQibTmi4pn7osfP24cb4C5C2aV/
         ijOKlL9f+PLa5o/rz33aVy1QwmVOaixFcPTh5mIN6JOMFdq+GZCj4UAMUpqmU1Qa9bUJ
         kqfhZTkuokPUSjj1iXsg2Vv7EmGe9uPelatWNJo3dCQcYPASuATENCqM6xpyw6+bjSFU
         4Pr1X7Pa9+PQJDuHlENi3bZntcpm21BXWeGaUhfABpNOTSZpGysbmp1q3lCk5cN4wN9g
         1iHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVObF1OMfriOf6Wdp+T57bL92yMbhTk1N1sg7/+1hNeB+SvMQcVQUk76IhKcK3b+ZHnCb1aDtKy6CM2OyXlPtiOiDDz
X-Gm-Message-State: AOJu0YxrKfWMkZxqWG7ZOvv+QijkvPHI/xxxNRq+sZQrf6HZMWdOyPfS
	FfHDtZcnbWleDwAfjxZNEgA5HXGC+brfldbefRiKpHg4eeEcyrZGpau4GRb+Z2dn7RzbY2NO8T/
	/A5DLRvBhoKzjcXnZySyD3HSOmuvLwTcY+qAZ6R8C9ALlT1Y3vw==
X-Received: by 2002:a05:6214:20cb:b0:6a0:cba9:374d with SMTP id 11-20020a05621420cb00b006a0cba9374dmr16882864qve.1.1715082300048;
        Tue, 07 May 2024 04:45:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFn5zp9cvKYCQsDht+IznsH9QjfYMruFo57MWUdiCANe/cc3LC8nZHXzUqWoY78m0wmvWw3qQ==
X-Received: by 2002:a05:6214:20cb:b0:6a0:cba9:374d with SMTP id 11-20020a05621420cb00b006a0cba9374dmr16882847qve.1.1715082299723;
        Tue, 07 May 2024 04:44:59 -0700 (PDT)
Received: from [192.168.0.9] (ip-109-40-241-109.web.vodafone.de. [109.40.241.109])
        by smtp.gmail.com with ESMTPSA id n14-20020ad444ae000000b006a0f057489fsm4611227qvt.125.2024.05.07.04.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 04:44:59 -0700 (PDT)
Message-ID: <c16d6ebc-1e0e-4f56-929f-495cef708d27@redhat.com>
Date: Tue, 7 May 2024 13:44:56 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v9 03/31] powerpc: Mark known failing tests
 as kfail
To: Nicholas Piggin <npiggin@gmail.com>
Cc: Laurent Vivier <lvivier@redhat.com>, Andrew Jones
 <andrew.jones@linux.dev>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20240504122841.1177683-1-npiggin@gmail.com>
 <20240504122841.1177683-4-npiggin@gmail.com>
 <f2411fc8-5f90-4577-9599-f43bb8694cd0@redhat.com>
 <D1347PSKXAVS.2EMGLUQSZN8W4@gmail.com>
Content-Language: en-US
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <D1347PSKXAVS.2EMGLUQSZN8W4@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/05/2024 06.07, Nicholas Piggin wrote:
> On Mon May 6, 2024 at 5:37 PM AEST, Thomas Huth wrote:
>> On 04/05/2024 14.28, Nicholas Piggin wrote:
>>> Mark the failing h_cede_tm and spapr_vpa tests as kfail.
>>>
>>> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
>>> ---
>>>    powerpc/spapr_vpa.c | 3 ++-
>>>    powerpc/tm.c        | 3 ++-
>>>    2 files changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/powerpc/spapr_vpa.c b/powerpc/spapr_vpa.c
>>> index c2075e157..46fa0485c 100644
>>> --- a/powerpc/spapr_vpa.c
>>> +++ b/powerpc/spapr_vpa.c
>>> @@ -150,7 +150,8 @@ static void test_vpa(void)
>>>    		report_fail("Could not deregister after registration");
>>>    
>>>    	disp_count1 = be32_to_cpu(vpa->vp_dispatch_count);
>>> -	report(disp_count1 % 2 == 1, "Dispatch count is odd after deregister");
>>> +	/* TCG known fail, could be wrong test, must verify against PowerVM */
>>> +	report_kfail(true, disp_count1 % 2 == 1, "Dispatch count is odd after deregister");
>>
>> Using "true" as first argument looks rather pointless - then you could also
>> simply delete the test completely if it can never be tested reliably.
>>
>> Thus could you please introduce a helper function is_tcg() that could be
>> used to check whether we run under TCG (and not KVM)? I think you could
>> check for "linux,kvm" in the "compatible" property in /hypervisor in the
>> device tree to see whether we're running in KVM mode or in TCG mode.
> 
> This I added in patch 30.
> 
> The reason for the suboptimal patch ordering was just me being lazy and
> avoiding rebasing annoyance. I'd written a bunch of failing test cases
> for QEMU work, but hadn't done the kvm/tcg test yet. It had a few
> conflicts so I put it at the end... can rebase if you'd really prefer.

Ah, ok, no need to rebase then, as long it's there in the end, it's fine.

  Thanks,
   Thomas


