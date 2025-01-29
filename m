Return-Path: <kvm+bounces-36886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C819BA2249D
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 20:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B39B1631BE
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 19:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E52311E2845;
	Wed, 29 Jan 2025 19:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kB7hYCUf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588C9158A09;
	Wed, 29 Jan 2025 19:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738179655; cv=none; b=E4Dl8aJPkMdZvmEbvUB61DPZHIGlAkNcLi+iuKumHRzTry1vq3MOnem5klLybZ0pCfmOw4QlonZwvwRnPAKdhwQ9sLFpxmxx9rJGSRsq3A0rdrlVnDKMSdWh8Z50ad1IDaW5R31s16+RYaU8viCO+x8JzLKQLLJvHsoqoBUGCdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738179655; c=relaxed/simple;
	bh=n0qc7hxwmQT3LcE9Yl45QXnZe+KyfZkh3DIPJkcoiBs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=qnm0bInO91D6h9ehjTpug7tkdfOVKbaI4HMfPI12PQ6FLDwQGrb/H01rIBVFE1CqSrr0n39Yrtg1YsO/zmAY9OQ9yUnEc0N2BgylUOIyPlCyd2sJWClxJVFH8SE/IE0x47V51UibiMlhco6tSd0+TDfh6vJQrbshmkPzf+VNJfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kB7hYCUf; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e58a99f493bso124323276.2;
        Wed, 29 Jan 2025 11:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738179652; x=1738784452; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YiAwe4ZwCv8Im80AYWWU2ZRBnO1Np7+D1TolCE4p/M0=;
        b=kB7hYCUfY+ypECLEXsKI/+DFPiqDESW2JesuehlY0WOSR0G8QJo+YHucRaoemX7pjy
         pS/HxJ9+uSTUHfj/u0BGBuboHOU5YLmvx33LH9aLCvjZFyo9uSaLc+E6t+9ouiUOyM3j
         6gtYKxBGKafMXUFONa5ODQnZ27neRjr70C+hMJ61UghrSV2T1qr1RXlev2QemIlKDEdc
         05aKhKGB0rZ3oFRurZiU+T8mcyMgMtX0cskZWdFP6ORSQ3T+zRel93rq5Xbskk8hMaey
         EufVcBmaAshahtl1CLMWf9+c6BEKm8cUb4RynqFvpNCHK1cMjIHx+z8cUmn76z0GUC5m
         jXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738179652; x=1738784452;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YiAwe4ZwCv8Im80AYWWU2ZRBnO1Np7+D1TolCE4p/M0=;
        b=gMImY5cmQiCJgexEpMsTIZZLcGyC6Lps7MTkM19tt+QIJmA9Gi9VKWw6OWqUw4NXbD
         KeyS8W6IPdGnhBr4qAEDtDBG9HWYPtkiOiir+HFe+CxrFYWELyJbyo35soU1MVSY2H7c
         mYQ5loRMTd8+z+TVxbMHU1I22fz78jm8jdB0jrfj9PU6j5Pp1QgN7WyoskYWTadNT7Et
         QRC3SyryP0523wYFIFCAwxLE9MawDbkGdsJ5JiXp0mm+OQfoxZpkvgdnZvwykZTaqjli
         Qaw/Ud9VW9cUcXA5O53J8BVythe6ZhVAQTQRoxdH+25OhQcqBmrDOk2g05Uon9Tu8a7Y
         eNQQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0qB0HcXKR9VGljK3SCDUf12G1sMepFTWbRIMTeCzEVAG3/hfoediCQkHntRBWV/ztdr4=@vger.kernel.org, AJvYcCXMlNIIQYZ3UUntUurwg0T3DQcCdwCliltA9s9rAWRJHHvgkJBTR1XiMnDL3EoziEj47iMnXH6MVIV3YJIN@vger.kernel.org
X-Gm-Message-State: AOJu0YzVd+yaOjiFYhGrl5pR751F6az3sHB0EpOIqwtVS3yPauwjqgiy
	mefcDhVV7rz0niswCIwxCHdpE3qgYTmIUhFaxrEKbmqabJkxSP4e
X-Gm-Gg: ASbGncvrKyr7jhVCRPNuKEgNBL3Sc59A+Vib3tUyBWQQHxdFIxxaCotLOcG6oq/jlzW
	q7uQ4wzS7uT2WZZcUsP0pIDd5ZfxHUpIIBtM/7bjCW/kpOtIGM8zMV4BuR2orK3KIG+A5IRmP4M
	ULjEcQREraLqJGUvgjJOPe+UvOdnG8vorAa+G2poTXHrtrNVXgG9zY54f119ov5onU4UkaO9QxG
	MzeTla/iYF1adDUEZqw8N04y4qzZUCsUGOt/+6lfNHYddR0mA9QfQdYMLm18pIpVDGbKqCFevtB
	f2zNLW95/GvIwXuT/Mw=
X-Google-Smtp-Source: AGHT+IFcm70cBzxdaG4YIpPTJqjr1mlkmvf4KaftoD5a2PQ8bLHewaoEFQM7aAbm4+WTw3yFJ6O+gg==
X-Received: by 2002:a05:690c:4912:b0:6ef:805c:ea15 with SMTP id 00721157ae682-6f7a83fd04bmr32763617b3.23.1738179652005;
        Wed, 29 Jan 2025 11:40:52 -0800 (PST)
Received: from [10.138.7.94] ([45.134.140.51])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6f757a2ac24sm23937107b3.103.2025.01.29.11.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 11:40:51 -0800 (PST)
Message-ID: <a0165511-b7c7-442a-84cc-15fef7ea53b9@gmail.com>
Date: Wed, 29 Jan 2025 14:40:50 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] drm/virtio: implement blob userptr resource
 object
From: Demi Marie Obenour <demiobenour@gmail.com>
To: "Huang, Honglei1" <Honglei1.Huang@amd.com>, Huang Rui
 <ray.huang@amd.com>, virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org, Dmitry Osipenko
 <dmitry.osipenko@collabora.com>, dri-devel@lists.freedesktop.org,
 David Airlie <airlied@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu
 <olvaffe@gmail.com>, Akihiko Odaki <akihiko.odaki@daynix.com>,
 Lingshan Zhu <Lingshan.Zhu@amd.com>, Simona Vetter <simona.vetter@ffwll.ch>,
 Xen developer discussion <xen-devel@lists.xenproject.org>,
 Kernel KVM virtualization development <kvm@vger.kernel.org>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
References: <20241220100409.4007346-1-honglei1.huang@amd.com>
 <20241220100409.4007346-3-honglei1.huang@amd.com>
 <Z2WO2udH2zAEr6ln@phenom.ffwll.local>
 <2fb36b50-4de2-4060-a4b7-54d221db8647@gmail.com>
 <de8ade34-eb67-4bff-a1c9-27cb51798843@amd.com>
 <Z36wV07M8B_wgWPl@phenom.ffwll.local>
 <9572ba57-5552-4543-a3b0-6097520a12a3@gmail.com>
Content-Language: en-US
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <9572ba57-5552-4543-a3b0-6097520a12a3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/24/25 7:42 PM, Demi Marie Obenour wrote:
> On 1/8/25 12:05 PM, Simona Vetter wrote:
>> On Fri, Dec 27, 2024 at 10:24:29AM +0800, Huang, Honglei1 wrote:
>>>
>>> On 2024/12/22 9:59, Demi Marie Obenour wrote:
>>>> On 12/20/24 10:35 AM, Simona Vetter wrote:
>>>>> On Fri, Dec 20, 2024 at 06:04:09PM +0800, Honglei Huang wrote:
>>>>>> From: Honglei Huang <Honglei1.Huang@amd.com>
>>>>>>
>>>>>> A virtio-gpu userptr is based on HMM notifier.
>>>>>> Used for let host access guest userspace memory and
>>>>>> notice the change of userspace memory.
>>>>>> This series patches are in very beginning state,
>>>>>> User space are pinned currently to ensure the host
>>>>>> device memory operations are correct.
>>>>>> The free and unmap operations for userspace can be
>>>>>> handled by MMU notifier this is a simple and basice
>>>>>> SVM feature for this series patches.
>>>>>> The physical PFNS update operations is splited into
>>>>>> two OPs in here. The evicted memories won't be used
>>>>>> anymore but remap into host again to achieve same
>>>>>> effect with hmm_rang_fault.
>>>>>
>>>>> So in my opinion there are two ways to implement userptr that make sense:
>>>>>
>>>>> - pinned userptr with pin_user_pages(FOLL_LONGTERM). there is not mmu
>>>>>    notifier
>>>>>
>>>>> - unpinnned userptr where you entirely rely on userptr and do not hold any
>>>>>    page references or page pins at all, for full SVM integration. This
>>>>>    should use hmm_range_fault ideally, since that's the version that
>>>>>    doesn't ever grab any page reference pins.
>>>>>
>>>>> All the in-between variants are imo really bad hacks, whether they hold a
>>>>> page reference or a temporary page pin (which seems to be what you're
>>>>> doing here). In much older kernels there was some justification for them,
>>>>> because strange stuff happened over fork(), but with FOLL_LONGTERM this is
>>>>> now all sorted out. So there's really only fully pinned, or true svm left
>>>>> as clean design choices imo.
>>>>>
>>>>> With that background, why does pin_user_pages(FOLL_LONGTERM) not work for
>>>>> you?
>>>>
>>>> +1 on using FOLL_LONGTERM.  Fully dynamic memory management has a huge cost
>>>> in complexity that pinning everything avoids.  Furthermore, this avoids the
>>>> host having to take action in response to guest memory reclaim requests.
>>>> This avoids additional complexity (and thus attack surface) on the host side.
>>>> Furthermore, since this is for ROCm and not for graphics, I am less concerned
>>>> about supporting systems that require swappable GPU VRAM.
>>>
>>> Hi Sima and Demi,
>>>
>>> I totally agree the flag FOLL_LONGTERM is needed, I will add it in next
>>> version.
>>>
>>> And for the first pin variants implementation, the MMU notifier is also
>>> needed I think.Cause the userptr feature in UMD generally used like this:
>>> the registering of userptr always is explicitly invoked by user code like
>>> "registerMemoryToGPU(userptrAddr, ...)", but for the userptr release/free,
>>> there is no explicit API for it, at least in hsakmt/KFD stack. User just
>>> need call system call "free(userptrAddr)", then kernel driver will release
>>> the userptr by MMU notifier callback.Virtio-GPU has no other way to know if
>>> user has been free the userptr except for MMU notifior.And in UMD theres is
>>> no way to get the free() operation is invoked by user.The only way is use
>>> MMU notifier in virtio-GPU driver and free the corresponding data in host by
>>> some virtio CMDs as far as I can see.
>>>
>>> And for the second way that is use hmm_range_fault, there is a predictable
>>> issues as far as I can see, at least in hsakmt/KFD stack. That is the memory
>>> may migrate when GPU/device is working. In bare metal, when memory is
>>> migrating KFD driver will pause the compute work of the device in
>>> mmap_wirte_lock then use hmm_range_fault to remap the migrated/evicted
>>> memories to GPU then restore the compute work of device to ensure the
>>> correction of the data. But in virtio-GPU driver the migration happen in
>>> guest kernel, the evict mmu notifier callback happens in guest, a virtio CMD
>>> can be used for notify host but as lack of mmap_write_lock protection in
>>> host kernel, host will hold invalid data for a short period of time, this
>>> may lead to some issues. And it is hard to fix as far as I can see.
>>>
>>> I will extract some APIs into helper according to your request, and I will
>>> refactor the whole userptr implementation, use some callbacks in page
>>> getting path, let the pin method and hmm_range_fault can be choiced
>>> in this series patches.
>>
>> Ok, so if this is for svm, then you need full blast hmm, or the semantics
>> are buggy. You cannot fake svm with pin(FOLL_LONGTERM) userptr, this does
>> not work.
> 
> Is this still broken in the virtualized case?  Page migration between host
> and device memory is completely transparent to the guest kernel, so pinning
> guest memory doesn't interfere with the host KMD at all.  In fact, the host
> KMD is not even aware of it.

To elaborate further:

Memory in a KVM guest is *not* host physical memory, or even host kernel
memory.  It is host *userspace* memory, and in particular, *it is fully pageable*.
There *might* be a few exceptions involving structures that are accessed by
the (physical) CPU, but none of these are relevant here.

This means that memory management works very differently than in the
non-virtualized case.  The host KMD can migrate pages between host memory
and device memory without either the guest kernel or host userspace being
aware that such migration has happened.  This means that pin(FOLL_LONGTERM)
in the guest doesn't pin memory on the host.  Instead, it pins memory in the
*guest*.  The host will continue to migrate pages between host and device
as needed.  I’m no expert on SVM, but I suspect this is the desired behavior.

Xen is significantly trickier, because most guest memory is provided by
the Xen toolstack via the hypervisor and is _not_ pageable.  Therefore,
it cannot be mapped into the GPU without using Xen grant tables.  Since
Xen grants do not support non-cooperative revocation, this requires a
FOLL_LONGTERM pin *anyway*.  Furthermore, granted pages _cannot_ be
migrated from host to device, so unless the GPU is an iGPU all of its
accesses will need to cross the PCI bus.  This will obviously be slow.

The guest can avoid this problem by migrating userptr memory to virtio-GPU
blob objects _before_ pinning it.  Virtio-GPU blob objects are backed by
host userspace memory, so the host can migrate them between device and host
memory just like in the KVM case.  Under KVM, such migration would be be
slightly wasteful but otherwise harmless in the common case.  In the case
where PCI passthrough is also in use, however, it might be necessary even
for KVM guests.  This is because PCI passthrough requires pinned memory,
and pinned memory cannot be migrated to the device.

Since AMD’s automotive use-case uses Xen, and since KVM might also need
page migration, I recommend that the initial implementation _always_
migrate pages to blob objects no matter what the hypervisor is.  Direct
GPU access to guest memory can be implemented as a KVM-specific optimization
later.

Also worth noting is that only pages that have been written need to be
migrated.  If a page hasn't been written, it should not be migrated, because
unwritten pages of a blob objects will read as zero.  However, the migration
should almost certainly be done in 2M chunks, rather than 4K ones.  This is
because the TLBs of at least AMD GPU are optimized for 2M pages, and GPU access
to 4K pages takes a 30% performance penalty.  This nicely matches the penalty
that AMD observed.
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)

