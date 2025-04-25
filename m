Return-Path: <kvm+bounces-44315-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EAC85A9C9A0
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 14:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06BF21C00E98
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 12:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F80825291D;
	Fri, 25 Apr 2025 12:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EcIYruM6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEBF2528E0
	for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 12:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585692; cv=none; b=u08GRMdB92AI3mPff/eN/OF9HXkg3jyF1pVz1zHH/VsUtHKVKWgNKOdp93CiGeyqMtrjWjxZb8nL8s2H4+nU1rD6RjywWFIX6yWosRZLu2EOqDd4JkBgRxzhXGf94cPp/3wDQbp61+/66mPPI/qJElGkgt5UNaOECiSfD0Ggg7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585692; c=relaxed/simple;
	bh=jeotXM0KA3DWatybi2Ymo9xsA2e1n40u6d5rM2fTPnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dv+7jx9k+ltxDg4OdjZtX+cNapgUC00+JBPH1tOxuZTWLBfO9IqB/sMDDZ07oHmuyqAFhpdc95PK54ngvgQBCSnAWjEC0c8XqQBryfZ5yzrr1WBFZEs5CUIhZKUPEwH2Yne8y+R47DJHrI5bBI0xiXA6LzCnp0UM/nWmZTerQ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EcIYruM6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745585689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qanu2gT01TsqxsN6xnJ0bpKNS+Yc0ZbR4TJGQSzNeQ0=;
	b=EcIYruM6W6Qm6PzAGLe88lIpojyYNnUeaG1D42n8Gcr8cTZBcBp3XCn+moZk2KdxCqucAG
	ILTKqUPQVAPZyvWdOvC3C8WIItGTQLzOBxyLcdZJEg+m1ECNPtwVj0kh08Vg2+djY3N7+n
	k3/RcrUJXTIQCFXLVIH1yc6qFgfcRSc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-QfxUiVJIPMmVMQ9lch6QrA-1; Fri, 25 Apr 2025 08:54:47 -0400
X-MC-Unique: QfxUiVJIPMmVMQ9lch6QrA-1
X-Mimecast-MFC-AGG-ID: QfxUiVJIPMmVMQ9lch6QrA_1745585686
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43d4d15058dso16184965e9.0
        for <kvm@vger.kernel.org>; Fri, 25 Apr 2025 05:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585686; x=1746190486;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qanu2gT01TsqxsN6xnJ0bpKNS+Yc0ZbR4TJGQSzNeQ0=;
        b=Az5hM48P4XFylV75etQrJ+gNOw8psrlZMsD5lz17zy0ov6Mlzj6WwoJ9xLkDRoXkXn
         OzvHYSoUY7thoFKEvjOSo6Byo7C++E/t3Dp6grkBVxGmB0XXGHZyW4F3Kg/P2m2hAEpL
         Tob8fi6sDVdxZzKdSxM2+Bi6zHj+H0Cj1q+ZA7JKyY5zB2z/P0WduTKGA/GzZ7xroBWK
         zzgPWydqG8qY6OPJS3vsVDV9eZYEa7kScWT5rL+28vlOBvjet9rU81sKGvpR0MImuVtc
         xffQpGtems4CY1fhg7RGfw85KzXn0kCbc+ZzbNNFJLNAiIEQPuNEnRdWiBHgDGoH0UQu
         G6HQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzh0PZrP2gk6M7hzSx8lFcwnWMIBgo1bJIwxzi7KRZk7XdgR0rb+E9A9+JtKPWUl3k/KI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDqwSnrZBB8Iw7hPL2wpy3LsW2XPVpA7CDQ33FpUnbgWFLWHo3
	rYFHQytbV2wchXkut658C3qYjFx+q0XK+c8peHOenTasWTA9moc7d9fnkJ82UXA1E2cO16k34pL
	NCh3A3JQ35iN8pNhOBDabP7t+HKaExQtkkIo2y7+ycQw2KQxMxg==
X-Gm-Gg: ASbGncs/O9hjgnU8/gGUeyB/uNOaWnRNhw9/Gyja7uiUPvcmTLEu1mGC5AjRk/YsSzg
	k8eZ3Hetrjc3d8f/OFKXOqRKYCHJa5n2VNXEvSEMCTEnRXv/yMGgulYZ5Y0I7+a4bx8emYJUcP5
	5zeTEEcoR1b86UZz62aZQxShX1l4e64H1mDGDFhrwi26d99BwKkTz2HLVyES6RvBb9+6vaCc8hW
	ubKEZVkTAyIOY0QeuLLfG8tAk0F/fUYFpwurQ/J+NDQAQb4Pv44Z5i/ZFUdwzFUK0wnW9bwx59P
	2LfDJTwtOJbrRoKvcOQMk3nYm5vDbL4bFFPvIpr9VOYDwf69S0i/5Qx4Bq5J/gciKg1zhlWe1iV
	2lB84BCPrx2NRR+I0j34yPHAEOHaUDFtTFeWw
X-Received: by 2002:a05:600c:34ca:b0:43e:a7c9:8d2b with SMTP id 5b1f17b1804b1-440a66aaf1bmr18907935e9.24.1745585686532;
        Fri, 25 Apr 2025 05:54:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHfpFH/Lot6K/PHIT5IH6k4Nij/gtpQAAvJoVMIMGNiKEo8FBpt8p/VDb0e5UHsoLU9n6xluQ==
X-Received: by 2002:a05:600c:34ca:b0:43e:a7c9:8d2b with SMTP id 5b1f17b1804b1-440a66aaf1bmr18907645e9.24.1745585686157;
        Fri, 25 Apr 2025 05:54:46 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70f:6900:6c56:80f8:c14:6d2a? (p200300cbc70f69006c5680f80c146d2a.dip0.t-ipconnect.de. [2003:cb:c70f:6900:6c56:80f8:c14:6d2a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a536a1e8sm24453705e9.28.2025.04.25.05.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 05:54:45 -0700 (PDT)
Message-ID: <9820c103-7274-444d-90ad-f2c128f34ff1@redhat.com>
Date: Fri, 25 Apr 2025 14:54:44 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/13] memory: Introduce generic state change parent
 class for RamDiscardManager
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
 <20250407074939.18657-5-chenyi.qiang@intel.com>
 <402e0db2-b1af-4629-a651-79d71feffeec@amd.com>
 <04e6ce1f-1159-4bf3-b078-fd338a669647@intel.com>
 <25f8159e-638d-446f-8f87-a14647b3eb7b@amd.com>
 <cfffa220-60f8-424c-ab67-e112953109c6@intel.com>
 <fd658f30-bd28-4155-8889-deda782c56eb@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <fd658f30-bd28-4155-8889-deda782c56eb@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 16.04.25 05:32, Chenyi Qiang wrote:
> 
> 
> On 4/10/2025 9:44 AM, Chenyi Qiang wrote:
>>
>>
>> On 4/10/2025 8:11 AM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 9/4/25 22:57, Chenyi Qiang wrote:
>>>>
>>>>
>>>> On 4/9/2025 5:56 PM, Alexey Kardashevskiy wrote:
>>>>>
>>>>>
>>>>> On 7/4/25 17:49, Chenyi Qiang wrote:
>>>>>> RamDiscardManager is an interface used by virtio-mem to adjust VFIO
>>>>>> mappings in relation to VM page assignment. It manages the state of
>>>>>> populated and discard for the RAM. To accommodate future scnarios for
>>>>>> managing RAM states, such as private and shared states in confidential
>>>>>> VMs, the existing RamDiscardManager interface needs to be generalized.
>>>>>>
>>>>>> Introduce a parent class, GenericStateManager, to manage a pair of
>>>>>
>>>>> "GenericState" is the same as "State" really. Call it RamStateManager.
>>>>
>>>> OK to me.
>>>
>>> Sorry, nah. "Generic" would mean "machine" in QEMU.
>>
>> OK, anyway, I can rename to RamStateManager if we follow this direction.
>>
>>>
>>>
>>>>>
>>>>>
>>>>>> opposite states with RamDiscardManager as its child. The changes
>>>>>> include
>>>>>> - Define a new abstract class GenericStateChange.
>>>>>> - Extract six callbacks into GenericStateChangeClass and allow the
>>>>>> child
>>>>>>      classes to inherit them.
>>>>>> - Modify RamDiscardManager-related helpers to use GenericStateManager
>>>>>>      ones.
>>>>>> - Define a generic StatChangeListener to extract fields from
>>>>>
>>>>> "e" missing in StateChangeListener.
>>>>
>>>> Fixed. Thanks.
>>>>
>>>>>
>>>>>>      RamDiscardManager listener which allows future listeners to
>>>>>> embed it
>>>>>>      and avoid duplication.
>>>>>> - Change the users of RamDiscardManager (virtio-mem, migration,
>>>>>> etc.) to
>>>>>>      switch to use GenericStateChange helpers.
>>>>>>
>>>>>> It can provide a more flexible and resuable framework for RAM state
>>>>>> management, facilitating future enhancements and use cases.
>>>>>
>>>>> I fail to see how new interface helps with this. RamDiscardManager
>>>>> manipulates populated/discarded. It would make sense may be if the new
>>>>> class had more bits per page, say private/shared/discarded but it does
>>>>> not. And PrivateSharedManager cannot coexist with RamDiscard. imho this
>>>>> is going in a wrong direction.
>>>>
>>>> I think we have two questions here:
>>>>
>>>> 1. whether we should define an abstract parent class and distinguish the
>>>> RamDiscardManager and PrivateSharedManager?
>>>
>>> If it is 1 bit per page with the meaning "1 == populated == shared",
>>> then no, one class will do.
>>
>> Not restrict to 1 bit per page. As mentioned in questions 2, the parent
>> class can be more generic, e.g. only including
>> register/unregister_listener().
>>
>> Like in this way:
>>
>> The parent class:
>>
>> struct StateChangeListener {
>>      MemoryRegionSection *section;
>> }
>>
>> struct RamStateManagerClass {
>>      void (*register_listener)();
>>      void (*unregister_listener)();
>> }
>>
>> The child class:
>>
>> 1. RamDiscardManager
>>
>> struct RamDiscardListener {
>>      StateChangeListener scl;
>>      NotifyPopulate notify_populate;
>>      NotifyDiscard notify_discard;
>>      bool double_discard_supported;
>>
>>      QLIST_ENTRY(RamDiscardListener) next;
>> }
>>
>> struct RamDiscardManagerClass {
>>      RamStateManagerClass parent_class;
>>      uint64_t (*get_min_granularity)();
>>      bool (*is_populate)();
>>      bool (*replay_populate)();
>>      bool (*replay_discard)();
>> }
>>
>> 2. PrivateSharedManager (or other name like ConfidentialRamManager?)
>>
>> struct PrivateSharedListener {
>>      StateChangeListener scl;
>>      NotifyShared notify_shared;
>>      NotifyPrivate notify_private;
>>      int priority;
>>
>>      QLIST_ENTRY(PrivateSharedListener) next;
>> }
>>
>> struct PrivateSharedManagerClass {
>>      RamStateManagerClass parent_class;
>>      uint64_t (*get_min_granularity)();
>>      bool (*is_shared)();
>>      // No need to define replay_private/replay_shared as no use case at
>> present.
>> }
>>
>> In the future, if we want to manage three states, we can only extend
>> PrivateSharedManagerClass/PrivateSharedListener.
> 
> Hi Alexey & David,
> 
> Any thoughts on this proposal?

Thinking about how to reasonable make virtio-mem and guest_memdfd work 
in the future together, I don't think such an abstraction might 
necessarily help. (see my other mails)

In the end we populate/discard, how to merge that information from 
multiple sources (or maintain it in a single object) is TBD.

virtio-mem has a bitmap that is usually 1 bit per block (e.g., 2 MiB). 
guest_memfd has a bitmap that is usually 1 bit per page.

Maybe a GuestRamStateManager would store both separately if requested. 
virtio-mem would register itself with it, and guest_memfd would register 
itself with that.

GuestRamStateManager would then implement the logic of merging both 
information (shared vs. private, plugged vs. unplugged).

But that needs more thought: essentially, the virtio-mem bitmap would 
move to the GuestRamStateManager.

OFC, we would only want the bitmaps and the manager if there is an 
actual provider for it (e.g., virtio-mem for the plugged part, 
guest_memfd for the cc part).

-- 
Cheers,

David / dhildenb


