Return-Path: <kvm+bounces-36889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2126CA2253F
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 21:55:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1E8C97A2BD0
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 20:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 099161E260D;
	Wed, 29 Jan 2025 20:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h8wRAniu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4CA187325;
	Wed, 29 Jan 2025 20:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738184103; cv=none; b=fwLWIPQ3ejIsjiwWbYNv1HahQOZaQbyYZU/mW5SwGAsTuIyGVYZF1v6nIR5wkP/MhhRSqPz2W2CbFiEAqEJVFWQjeMynevMveYvFUFACQ9WaN5UEg5eFwMV0h2NYr8C9lgwSjqgH5Ie6iqSNTXKS6fPZ2PwTEth5VH2BvoOw0Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738184103; c=relaxed/simple;
	bh=oAUBgof2aIujkwQRJYbG9mhga1e78/p7HKpHVeQdrgg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=vCg4vScFeoONmMtLMkzUjHE1f3U6oPjnE5VwoHfsFpt7ndqEyUW+JT8J8jSFIZhl3BN5LXgOw6DA81T/O2KmSjqWTQbq5+xMXEtlgbnK98/RYfW798bKEeo6cLkIVv4SONjFcd29BqtAUF7N3dt68uZ/Wcs503YHtQfsn9exrqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h8wRAniu; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e549be93d5eso283739276.1;
        Wed, 29 Jan 2025 12:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738184100; x=1738788900; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ueZk4UbNoQ80hfj8dpqw2VgMTf7ByqVqHJz79+NLnU0=;
        b=h8wRAniup+DehEQjrPmQOOnoMi/V8QZDyKmPZzP9AahJ3eT0I/Dy+4RcwvBzd0KcbO
         jIQKlE4NHbItt24M1eyxGqxsv5o3EMWcV7J5WWWvycZjyhdgfI+8cKArQnmkTkw3FJLt
         eQkNIDp2pkAs5LYSWp0GjvTx3kspBRL1DMYOQTMElp/CQhIfKs0UUBKU+SKDBN8zUYb8
         g7aY00r8XwjVCDwYJVDVClbrzxLVWAUBBGeijq0Z7BBR8lnmehdcLREVz67k0znglbN8
         OrfRRPGj6pM+Ofa6MMqwd4YsQZfRQB09NgwR8k671YGXUrGshgiPoeRRMy5rKva71PGY
         hZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738184100; x=1738788900;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ueZk4UbNoQ80hfj8dpqw2VgMTf7ByqVqHJz79+NLnU0=;
        b=Zu/S7nuiCQ7TKBHCmamFsEaWzjfp0tUYXrIz1tyRHUxHhJVZhH8bDOtkvqBRBAA/g3
         1rtftC77bZK7L4UF5u4meH5lX0XzjYoBHdAmv6FADPJnnHKQISbDWgGnCnrWG4oy0ZT/
         DmHmocoiQkDkox7eWlMMynGLa5NGfjVj4WtJDcnvLS1yGrePpJIwSlzqV5587tZB5jz0
         UIExGsFjYEaYmJrqPhXzDvO9td7ofoK1z2PaWXWssTj+Du6kCnLKGdYFz1gogZhIyQMZ
         Lkp0QyCFbVcDirOAsjdND8gOASlyWdRsTa3tZ5GNz36l8jUvqgNf5rxifzebseQv1cyR
         08MQ==
X-Forwarded-Encrypted: i=1; AJvYcCU65YhYJnd4yrIgpgV7RayRx4HD8Kit166g5jfico4uAkRlualGJ2DPfEsO/RL+hVzebS9KDTsxQikeZ++F@vger.kernel.org, AJvYcCUhSLnASyS1dZDpj3Ning74wPQwlXRXQUkdJh+ezIzuU16zN7OXI3mLv4TapW/47gQeGmc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl3IGXz1LjMmR9DR5IHLgUhExRYwoz+oiSCkAfr4n0V8+QXFWr
	FyKBlDZt21u6j/HtoaW3K9w8wwEl22xMKh8xnNa21bLKWA+QBVxt
X-Gm-Gg: ASbGncu+8pwydGhMrIjs+DR8ThTfBxerwLtc1zuzSPr1U0rI9QHfHSl0YLy3hJrSd8+
	nUUpQ0iWLazTYFuGRNUxKW8WmPF3O+S7HEkvV4aAIgLaftVFJKzRkMhUGvzoEAED801TQJILpXO
	s3x+sk+brNaxq5WQfg/csS/zfXZ1BU4jNk4hHln5cJhjp2U6bBGjbbt1m9WrM7O1/R0bzF5dV79
	hO3k6EngQxzFiEyfhNDjbztwHgF7QyKnSDFFRDqzpiZj1NU8/zkcTmb+262pVr++3e+scHsO0+I
	AJhlX0kGGI+IFrrB5I4=
X-Google-Smtp-Source: AGHT+IEWmX2x1u7n/vc0UVcEoX4V7EHvc3YO4LXHl+8qKvZBYQDsROpwgWkMjeON3KdFCpXBNEgtTQ==
X-Received: by 2002:a05:690c:4808:b0:6ef:4fba:8143 with SMTP id 00721157ae682-6f7a836fbafmr43773547b3.18.1738184100325;
        Wed, 29 Jan 2025 12:55:00 -0800 (PST)
Received: from [10.138.7.94] ([45.134.140.51])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6f757876fe8sm24376507b3.5.2025.01.29.12.54.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 12:54:59 -0800 (PST)
Message-ID: <c42ae4f7-f5f4-4906-85aa-b049ed44d7e9@gmail.com>
Date: Wed, 29 Jan 2025 15:54:59 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] drm/virtio: implement blob userptr resource
 object
Content-Language: en-US
To: "Huang, Honglei1" <Honglei1.Huang@amd.com>, Huang Rui
 <ray.huang@amd.com>, virtualization@lists.linux-foundation.org,
 linux-kernel@vger.kernel.org, Dmitry Osipenko
 <dmitry.osipenko@collabora.com>, dri-devel@lists.freedesktop.org,
 David Airlie <airlied@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu
 <olvaffe@gmail.com>, Akihiko Odaki <akihiko.odaki@daynix.com>,
 Lingshan Zhu <Lingshan.Zhu@amd.com>,
 Xen developer discussion <xen-devel@lists.xenproject.org>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>,
 Kernel KVM virtualization development <kvm@vger.kernel.org>
References: <20241220100409.4007346-1-honglei1.huang@amd.com>
 <20241220100409.4007346-3-honglei1.huang@amd.com>
 <Z2WO2udH2zAEr6ln@phenom.ffwll.local>
 <2fb36b50-4de2-4060-a4b7-54d221db8647@gmail.com>
 <de8ade34-eb67-4bff-a1c9-27cb51798843@amd.com>
 <Z36wV07M8B_wgWPl@phenom.ffwll.local>
From: Demi Marie Obenour <demiobenour@gmail.com>
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
In-Reply-To: <Z36wV07M8B_wgWPl@phenom.ffwll.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/8/25 12:05 PM, Simona Vetter wrote:
> On Fri, Dec 27, 2024 at 10:24:29AM +0800, Huang, Honglei1 wrote:
>>
>> On 2024/12/22 9:59, Demi Marie Obenour wrote:
>>> On 12/20/24 10:35 AM, Simona Vetter wrote:
>>>> On Fri, Dec 20, 2024 at 06:04:09PM +0800, Honglei Huang wrote:
>>>>> From: Honglei Huang <Honglei1.Huang@amd.com>
>>>>>
>>>>> A virtio-gpu userptr is based on HMM notifier.
>>>>> Used for let host access guest userspace memory and
>>>>> notice the change of userspace memory.
>>>>> This series patches are in very beginning state,
>>>>> User space are pinned currently to ensure the host
>>>>> device memory operations are correct.
>>>>> The free and unmap operations for userspace can be
>>>>> handled by MMU notifier this is a simple and basice
>>>>> SVM feature for this series patches.
>>>>> The physical PFNS update operations is splited into
>>>>> two OPs in here. The evicted memories won't be used
>>>>> anymore but remap into host again to achieve same
>>>>> effect with hmm_rang_fault.
>>>>
>>>> So in my opinion there are two ways to implement userptr that make sense:
>>>>
>>>> - pinned userptr with pin_user_pages(FOLL_LONGTERM). there is not mmu
>>>>    notifier
>>>>
>>>> - unpinnned userptr where you entirely rely on userptr and do not hold any
>>>>    page references or page pins at all, for full SVM integration. This
>>>>    should use hmm_range_fault ideally, since that's the version that
>>>>    doesn't ever grab any page reference pins.
>>>>
>>>> All the in-between variants are imo really bad hacks, whether they hold a
>>>> page reference or a temporary page pin (which seems to be what you're
>>>> doing here). In much older kernels there was some justification for them,
>>>> because strange stuff happened over fork(), but with FOLL_LONGTERM this is
>>>> now all sorted out. So there's really only fully pinned, or true svm left
>>>> as clean design choices imo.
>>>>
>>>> With that background, why does pin_user_pages(FOLL_LONGTERM) not work for
>>>> you?
>>>
>>> +1 on using FOLL_LONGTERM.  Fully dynamic memory management has a huge cost
>>> in complexity that pinning everything avoids.  Furthermore, this avoids the
>>> host having to take action in response to guest memory reclaim requests.
>>> This avoids additional complexity (and thus attack surface) on the host side.
>>> Furthermore, since this is for ROCm and not for graphics, I am less concerned
>>> about supporting systems that require swappable GPU VRAM.
>>
>> Hi Sima and Demi,
>>
>> I totally agree the flag FOLL_LONGTERM is needed, I will add it in next
>> version.
>>
>> And for the first pin variants implementation, the MMU notifier is also
>> needed I think.Cause the userptr feature in UMD generally used like this:
>> the registering of userptr always is explicitly invoked by user code like
>> "registerMemoryToGPU(userptrAddr, ...)", but for the userptr release/free,
>> there is no explicit API for it, at least in hsakmt/KFD stack. User just
>> need call system call "free(userptrAddr)", then kernel driver will release
>> the userptr by MMU notifier callback.Virtio-GPU has no other way to know if
>> user has been free the userptr except for MMU notifior.And in UMD theres is
>> no way to get the free() operation is invoked by user.The only way is use
>> MMU notifier in virtio-GPU driver and free the corresponding data in host by
>> some virtio CMDs as far as I can see.
>>
>> And for the second way that is use hmm_range_fault, there is a predictable
>> issues as far as I can see, at least in hsakmt/KFD stack. That is the memory
>> may migrate when GPU/device is working. In bare metal, when memory is
>> migrating KFD driver will pause the compute work of the device in
>> mmap_wirte_lock then use hmm_range_fault to remap the migrated/evicted
>> memories to GPU then restore the compute work of device to ensure the
>> correction of the data. But in virtio-GPU driver the migration happen in
>> guest kernel, the evict mmu notifier callback happens in guest, a virtio CMD
>> can be used for notify host but as lack of mmap_write_lock protection in
>> host kernel, host will hold invalid data for a short period of time, this
>> may lead to some issues. And it is hard to fix as far as I can see.
>>
>> I will extract some APIs into helper according to your request, and I will
>> refactor the whole userptr implementation, use some callbacks in page
>> getting path, let the pin method and hmm_range_fault can be choiced
>> in this series patches.
> 
> Ok, so if this is for svm, then you need full blast hmm, or the semantics
> are buggy. You cannot fake svm with pin(FOLL_LONGTERM) userptr, this does
> not work.
> 
> The other option is that hsakmt/kfd api is completely busted, and that's
> kinda not a kernel problem.
> -Sima

On further thought, I believe the driver needs to migrate the pages to
device memory (really a virtio-GPU blob object) *and* take a FOLL_LONGTERM
pin on them.  The reason is that it isn’t possible to migrate these pages
back to "host" memory without unmapping them from the GPU.  For the reasons
I mention in [1], I believe that temporarily revoking access to virtio-GPU
blob objects is not feasible.  Instead, the pages must be treated as if
they are permanently in device memory until guest userspace unmaps them
from the GPU, after which they must be migrated back to host memory.

The problems with other approaches are most obvious if one considers a Xen
guest using a virtio-GPU backend that is not all-powerful.  Normal guest
memory is not accessible to the GPU, and Xen uses the IOMMU to enforce this
restriction.  Therefore, the guest must migrate pages to virtio-GPU blob
objects before the GPU can access them.  From Xen’s perspective, virtio-GPU
blob objects belong to the backend domain, so Xen allows the GPU to access
them.  However, the pages in blob objects _cannot_ be used in Xen grant table
operations, because Xen doesn’t consider them to belong to the guest!
Similarly, if the guest has an assigned PCI device, that device will not
be able to access the blob object’s pages.

I’m no expert on Linux memory management, so I’m not sure how to implement
this behavior.  What I _can_ say is that a blob object is I/O memory, and
behaves somewhat similar to a PCI BAR in a system with no P2PDMA support:
CPU access works, but DMA from other devices does not.  Furthermore, the
memory can’t be used for page tables or granted to other Xen guests, and it
will go away if the device is hot-unplugged.  In fact, if the PCI transport
is used, the blob object is located in the BAR of an (emulated) device.
There are non-PCI transports, though, so assuming that blob objects are
located in a PCI BAR is not a good idea.

The reason that pinning the objects in "device" memory is a reasonable
approach is that the host (or backend, in the Xen case) can still migrate
pages between device and host memory and not allocate backing store for
pages that are never accessed.  Therefore, it is not necessary for every
CPU access to go across the PCIe bus even for dGPUs.  Instead, if guest
CPU accesses are much more frequent than device accesses, the memory will
be migrated to the host side.  It’s up to the virtio-GPU backend
implementation to make sure that this happens.  For KVM, this should be
automatic, but for Xen, this might need additional Xen patches so that
the backend domain is notified when pages are accessed or dirtied.

[1]: https://lore.kernel.org/dri-devel/9572ba57-5552-4543-a3b0-6097520a12a3@gmail.com
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)

