Return-Path: <kvm+bounces-2270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC3207F44B1
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 12:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F7ED28165A
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 11:07:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474373E49C;
	Wed, 22 Nov 2023 11:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQgxUT4T"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8266192
	for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 03:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700651207;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=SlzLCHUeZIecB8wYp0wKxs51RJCQ0+gXCiCFzZa8v/Q=;
	b=SQgxUT4T5lMgoz22PKkX+QhCJLQJjsrcr4k0yi2B1U+zKw9usIgrFNGvIr84yamZwC8b24
	hDnFB6db6fzxifcvzryWPwVf4v1PgJKQOzqoX8T1O7dwRCG1VANPf5dzJGOOIO1lzZ2we6
	fsfxwvLwr6Uoimgog+rFFiQVao6zUwE=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-mHiJbBaoPp-IfBEA6AH2LA-1; Wed, 22 Nov 2023 06:06:46 -0500
X-MC-Unique: mHiJbBaoPp-IfBEA6AH2LA-1
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-3b2e2487c6bso8540521b6e.2
        for <kvm@vger.kernel.org>; Wed, 22 Nov 2023 03:06:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700651205; x=1701256005;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SlzLCHUeZIecB8wYp0wKxs51RJCQ0+gXCiCFzZa8v/Q=;
        b=O1Koy6YhKwrlQ8+3u3uQgAvIIItPYJEHDv0EuZGvfkAJGBIEy7iieH8ceYPJhFzMxz
         LHoiN4jOU/y+4kKt9W1TK2LbX2NH6LT49wQtk98ZNWeMrWJOZW8OpAxzFrKcg/oqLixF
         rHWoZuEeosWQkJglmqSWduyZVceSczkQ+a/YomfJAcQ97vvu21G9AVfmNlTiuQddipOO
         4LkLvOAxH8efx4sX2hBbHkGw5NybGkAp/DyM2jJtY6RriUPOQUkk435Ntom0Ir4tzrK9
         ViNvDmC1+J6Uxe/wR0LZLBKILp1fFSUM2NrZsBitT/zyAEf4RQqzobZ4oToDI3OlD6Lv
         Ng3w==
X-Gm-Message-State: AOJu0YyvrFJjLfiMaGmqcH84yvYqes5qaj+SY490KkCShFqLrmLzFR5H
	SrDAedPhYEx3lmfylRY6n2gxsWCFKsgf6/x+CgPB2+j34OMzFZRp/mxcko5nJjQHBAQNaFdfIBw
	a1xE2fCH41VdSUF8u9Z1J
X-Received: by 2002:a05:6808:2024:b0:3b8:402c:7081 with SMTP id q36-20020a056808202400b003b8402c7081mr1046982oiw.27.1700651205397;
        Wed, 22 Nov 2023 03:06:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmK4XjcKOKPZ6QQtXVgD2kViUPq8DspxxPMFs15998pUUIWQlhKHU+T9fQ1Fdak+wWWbClmg==
X-Received: by 2002:a05:6808:2024:b0:3b8:402c:7081 with SMTP id q36-20020a056808202400b003b8402c7081mr1046962oiw.27.1700651205116;
        Wed, 22 Nov 2023 03:06:45 -0800 (PST)
Received: from [192.168.0.6] (ip-109-43-176-233.web.vodafone.de. [109.43.176.233])
        by smtp.gmail.com with ESMTPSA id p10-20020ae9f30a000000b0076d08d5f93asm4347109qkg.60.2023.11.22.03.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 03:06:44 -0800 (PST)
Message-ID: <4c7ce0a1-5da0-4c1f-bb4c-af06167ad2f1@redhat.com>
Date: Wed, 22 Nov 2023 12:06:41 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests GIT PULL 07/26] s390x: sie: ensure guests are
 aligned to 2GB
Content-Language: en-US
To: Nico Boehr <nrb@linux.ibm.com>
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
 Jan Richter <jarichte@redhat.com>
References: <20231110135348.245156-1-nrb@linux.ibm.com>
 <20231110135348.245156-8-nrb@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20231110135348.245156-8-nrb@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/2023 14.52, Nico Boehr wrote:
> Until now, kvm-unit-tests has aligned guests to 1 MB in the host virtual
> address space. Unfortunately, some s390x environments require guests to
> be 2GB aligned in the host virtual address space, preventing
> kvm-unit-tests which act as a hypervisor from running there.
> 
> We can't easily put guests at address 0, since we want to be able to run
> with MSO/MSL without having to maintain separate page tables for the
> guest physical memory. 2GB is also not a good choice, since the
> alloc_pages allocator will place its metadata there when the host has
> more than 2GB of memory. In addition, we also want a bit of space after
> the end of the host physical memory to be able to catch accesses beyond
> the end of physical memory.
> 
> The vmalloc allocator unfortunately allocates memory starting at the
> highest virtual address which is not suitable for guest memory either
> due to additional constraints of some environments.
> 
> The physical page allocator in memalign_pages() is also not a optimal
> choice, since every test running SIE would then require at least 4GB+1MB
> of physical memory.
> 
> This results in a few quite complex allocation requirements, hence add a
> new function sie_guest_alloc() which allocates memory for a guest and
> then establishes a properly aligned virtual space mapping.
> 
> Rework snippet test and sie tests to use the new sie_guest_alloc()
> function.
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Link: https://lore.kernel.org/r/20231106170849.1184162-3-nrb@linux.ibm.com
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>   lib/s390x/sie.h     |  2 ++
>   lib/s390x/snippet.h |  9 +++------
>   lib/s390x/sie.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
>   s390x/sie.c         |  4 ++--
>   4 files changed, 49 insertions(+), 8 deletions(-)

  Hi Nico!

a colleague of mine (Jan) told me today that the current SIE-related tests 
of the kvm-unit-tests are failing when being run from a KVM guest (i.e. when 
we're testing a double-nested scenario). I've bisected the problem and ended 
up with this patch here.
Could you please check whether "./run_tests.sh sie mvpg-sie spec_ex-sie" 
still works for you from within a KVM guest?

  Thanks,
   Thomas


