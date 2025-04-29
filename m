Return-Path: <kvm+bounces-44725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D453AAA07E9
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 12:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBF167A8A2C
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 10:00:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF8F32BE7CB;
	Tue, 29 Apr 2025 10:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OlnMSdqt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F6329CB49
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 10:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745920898; cv=none; b=QYbtd5H5coj8suDl+nqrIOglSeOgS+YN+sPhPm6CrKZffUSy4etU2hNyuKrDkZTvTxvXf/GVAsUCeBMd/pXWBixoK6UUnI9/bGOSkg285dNFW8OOMY4rRNQrRPswAYbAmEYK1rv8MKC05s0nOMD6W8r2e8baQ4yMqW+q8+6IJ9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745920898; c=relaxed/simple;
	bh=Q7FmrTRr6L0gjbqHUrvxBALV9Anos4Mjzxu2ybaDNqs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GRdc4iwmeTFJzDmkySOYoCuj7OcXIMqS6gcDA0UrCE1jFyGmjevwWVQOSF+ZPgYOdO6Dv8sjoFWA5AhXN4Mxa8s6zLIrY4yoUxmAJ3hb+72m7wb6YOYa2IemRiGgDxRfBcqTJtpHWMVSdDLomSY0XSAOhpRyVo0D6boooHfVRdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OlnMSdqt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745920894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LqqGQfAaG6GqaWVEbD9/M+5ef8LAsRnMr5gifHjF8Zs=;
	b=OlnMSdqtZ5P9m4Iaz3UbCAnR6mpqMsYt0MP5LR8/BUTtFHWbjU543TC3fHy/tOHYAXYV/W
	imvBZsNIM3l+iMzNQAsWbRGe8ht7tW4V7ttLtIuEM1CCwCvo/p9NYY9FGY4WoImmvZpBwy
	wLqxdI2fveQPqciDZksXq2gjNqOTX74=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-COoQrMHMNrudUo5gFauuxg-1; Tue, 29 Apr 2025 06:01:33 -0400
X-MC-Unique: COoQrMHMNrudUo5gFauuxg-1
X-Mimecast-MFC-AGG-ID: COoQrMHMNrudUo5gFauuxg_1745920892
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cf327e9a2so39052235e9.3
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 03:01:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745920892; x=1746525692;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LqqGQfAaG6GqaWVEbD9/M+5ef8LAsRnMr5gifHjF8Zs=;
        b=olrIME0enIu4uUa0+2Zznb+r6lqmPlLUppx9wywGbYwpvcQmi7r4x84KxjnX8A0kTy
         T8i2eG4W/7zJhqRSY4HJeVcqQDfdm9/f/Tdp8vqMd6+O4ZT0OhMuOrQXzECRIGVzmIAJ
         LgBlkP3i7VdnQKjICJc1wQIw4FGVVmvSubBBy8f/lsH3dJSLoTm0xu5FthjqV00hgd0E
         pN5ftyHeJiFRHGhsN/8cA1uXuCML0YE/ogWWypiRaChbKaDDa3cbyCLkuZtOphxtTjOO
         aWSlvulF6KDjg8Ztq2HaIjbH945u1CVbr4bjeJg2Xky8ustEtoiIt4eOgM2JLlXZN1E/
         G3Ag==
X-Forwarded-Encrypted: i=1; AJvYcCVVD7PGS8ggNZwkaNlA9LXWYUg/J1SCJPbBOedyGjij6Yu4XZ5tgak3Ru3Pf9tNYoiyFKs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnRLe6V0hURrVyjx8TmI4MsuvXfisr4qhrE2IZs9tcf6mnrOXS
	S7w6D/T6isccDWzLA8koLJPiPvStS+NM6S1j/4w4QbcreUpfsj4gj9ZIac5S/8lUdG/fYLUXXja
	jXFNqYUDQKEvD8v5xq1zar7JeAGPZSwcr8KGN7YIOHNo33KtPoA==
X-Gm-Gg: ASbGncuv0kUWYUgKHTKuO2kySJiqI9rwiEreaw5AJldAbSJGgyWVSvy+JooMrWUqLUl
	3B1ma9DO3TrusiCbHy/zrfw9yh+wmCLjBcvZ+WiR/TF40iUU1UNy/5ayfSjnKq/ExfeJJkr35cJ
	SoZWJbIqH3q+oTWAujBP6A+OAoiWOHqrUbNzG2Ov31ztRBXyPS97vYFnq7obPYm8AMK6ZNxc3/k
	Ak8NirKzjKq9RAiNCvxEic+7u/zkdmgxUeOo9PtisYAn70Z5tsXpa1HWlqxZ+0qXjiQ93g3ZjYg
	+xC0f+qZewK5YErgOE7qUgB7b/RBUPAlRFEipxk=
X-Received: by 2002:a05:600c:8509:b0:439:9e13:2dd7 with SMTP id 5b1f17b1804b1-441ad3a85c3mr17312765e9.2.1745920892155;
        Tue, 29 Apr 2025 03:01:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUcffVlVTc+AkQjXqu+BdGuTgL+n6JW94PnFQ/Atk082X2CUp+MA3n/H/c3kLvxOfdyMv2OQ==
X-Received: by 2002:a05:600c:8509:b0:439:9e13:2dd7 with SMTP id 5b1f17b1804b1-441ad3a85c3mr17312365e9.2.1745920891792;
        Tue, 29 Apr 2025 03:01:31 -0700 (PDT)
Received: from [192.168.3.141] (p5b0c613e.dip0.t-ipconnect.de. [91.12.97.62])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4409d2dfde6sm181466805e9.36.2025.04.29.03.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 03:01:31 -0700 (PDT)
Message-ID: <bff6e10c-6047-4d90-b823-17d06c03b455@redhat.com>
Date: Tue, 29 Apr 2025 12:01:29 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] memory: Introduce PrivateSharedManager Interface
 as child of GenericStateManager
To: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-6-chenyi.qiang@intel.com>
 <5ab45e5c-93cd-4053-8c26-253d27176fab@redhat.com>
 <6a1088ed-5b78-406d-9e50-87dec04cd28e@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <6a1088ed-5b78-406d-9e50-87dec04cd28e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27.04.25 03:40, Chenyi Qiang wrote:
> 
> 
> On 4/25/2025 8:57 PM, David Hildenbrand wrote:
>> On 07.04.25 09:49, Chenyi Qiang wrote:
>>> To manage the private and shared RAM states in confidential VMs,
>>> introduce a new class of PrivateShareManager as a child of
>>> GenericStateManager, which inherits the six interface callbacks. With a
>>> different interface type, it can be distinguished from the
>>> RamDiscardManager object and provide the flexibility for addressing
>>> specific requirements of confidential VMs in the future.
>>>
>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>> ---
>>
>> See my other mail, likely this is going into the wrong direction.
>>
>> If we want to abstract more into a RamStateManager, then it would have
>> to have two two sets of states, and allow for registering a provider for
>> each of the states.
>>
>> It would then merge these informations.
>>
>> But the private vs. shared provider and the plugged vs. unplugged
>> provider would not be a subclass of the RamStateManager.
>>
>> They would have a different interface.
>>
>> (e.g., RamDiscardStateProvider vs. RamPrivateStateProvider)
> 
> Got it! Before the real use case (guest_memfd + virtio-mem) comes, I
> would keep the original design.

Yes, absolutely fine with me.

-- 
Cheers,

David / dhildenb


