Return-Path: <kvm+bounces-41203-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BE07A64AA1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B75133B6286
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41D2122FF39;
	Mon, 17 Mar 2025 10:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J0EFHRQy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB63F21CC70
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 10:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742207785; cv=none; b=gZI9B8uumdzYvemS54kp3H7MJN36s5MvPbkAwjm/vLgTUdJ0ymP9m/6xufqKjLNwOE3N2sgSDQrTpAhUPkLrA+Fr3AnqCy25seWfv6B3aYA/hDZw8r9KQBTZ0M2JnSaxryFcaNovxsDs+DnxE4Yr8RH561bXM30+y+HeKFV+HeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742207785; c=relaxed/simple;
	bh=UzTCuVM4BpViUSL7Fn3zkH/+iRoJXAEOxsNDcO88B/4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uATHTyXn7qLA62GIoUXxJy+VJ+aEF6fxUpwtngf/heJ2wpL3mUq7GO9XrZXoh0ErqUKIWc5ueCuQ2RVUXzs7kBNn0hq20aTa3h7VhtISSSZ/2E4Mu4Gm0TKTfiLPla3QTszTJ/F55BKwQxgV3B0oFlQdd/MiNDRigFVgzZwCCpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J0EFHRQy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742207782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bM2dyKJpstUzKe5NW+C4OxEF497of7da5cfefbVtcrg=;
	b=J0EFHRQy7FbJkBgge9OSnSrrTxY+KYEGdo5KB7WF7FUkwcIng20/dixbFZwDN8fZ5sOYr2
	TQrbs0UM7AREB7PWXt/lilNTJRvNqRIQsewHGa8DIPPT4BGYVNjPPEmMWtQQm0EyDsskYw
	wuA231m3BH5USjjG79Z/nj2sPPWjhk8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-169-kEiwUcnxO7aGwiD1DhmzCw-1; Mon, 17 Mar 2025 06:36:21 -0400
X-MC-Unique: kEiwUcnxO7aGwiD1DhmzCw-1
X-Mimecast-MFC-AGG-ID: kEiwUcnxO7aGwiD1DhmzCw_1742207780
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43943bd1409so12265735e9.3
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 03:36:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742207780; x=1742812580;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bM2dyKJpstUzKe5NW+C4OxEF497of7da5cfefbVtcrg=;
        b=HcdDCBq9tf9lbfdHPAEAXUcMW4HdWA38J7iVzBGRIu4euF5EerhFZqYTsX/tjcQkdM
         uYm5wmdw8HmsF1CjXDDm/PLNlOuXjWXdhQWJ/Xp9OdF1P4qyQwxQqUq0COhszgWmmbk8
         juKxGlRblcbUUYmT0vQWuHYjlN9FaujAX8DI2w/Ba3NamQSmzlxfdnh52I1Tdh1kf48a
         PbEijtMsAGX15/VnJ4fw79qF0TPsPZ/aoK84NT3b3xqwYmf7dyIe6zPG/7SuKBu3qabz
         mCBGQUsy0tfkgBZmLGqU07hVWH13Rnlq29/apye45OumB/1juA1IJ/wSqiSiAVfntxId
         y4Ig==
X-Forwarded-Encrypted: i=1; AJvYcCXdOjgJVkuZKkayYnHGY5LA3R2lAK/n0pphfn4qjuDLTU4R2dyPIgShlLKKfZ/+JMNoixQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ7sedaBCgEZEsVY+xjt7uxs+ZzdqRFBL3VuHNs5xVrcPynhaj
	FmLRP+66Jx8/MpWoup9Ri6u2dIYF6uP+eNRTAoRjDeJzw6uIEK7UukicLwCV1gbtDFVhZnNciFj
	QWouAFQguiL5Vl6VVu9OU82aMFDrgcuMI8YITovtxFtgcONPVJA==
X-Gm-Gg: ASbGncs+bwKtD+0OTmOtZsiO3LuJaNQ/P9P3XPolsnDcyd/A2pQ7nlG8KtzQJmhA71a
	rfiJJIbZhPb/2hPtSfQ2Zn9T9izky7CfQb7fX3qX+hoBNJjjj2Q2hLeXhJGG/EKESd4EuQEm/NA
	SLD+c4r+ug/J1tkjLrTB+HgyuMv6kfYBD0TKpnqQbaWpyZCSBby/KCwa5qzGzgL/qEkcUFnOno/
	heO3HyNNM/VoLOp16QnISmC7QL70Jdx2BnLwPz9rt0Y0+1s8oNbkKXp/cygYNCrI0TTB3pVK4d4
	ky6nQLnNr3IbpJjOnIi8NhuUgeaibi2wJB+v/VxdyDkht9+Zg+ia7ZMKzYPREXGJCBE1t2lfPmS
	hdrc6jyL6qEncIoJSF4HhZMnnxJKSKC/6LZzk83olekg=
X-Received: by 2002:a5d:64cf:0:b0:38f:2efb:b829 with SMTP id ffacd0b85a97d-3971f5113f7mr10374677f8f.50.1742207779895;
        Mon, 17 Mar 2025 03:36:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFWs4TgZN7EpkNdNwfgAZlMLTvoqVsv2Gn4ZHvm/LbyORj0yeGh6VUTmO0DyNPbaa2C5WSJTg==
X-Received: by 2002:a5d:64cf:0:b0:38f:2efb:b829 with SMTP id ffacd0b85a97d-3971f5113f7mr10374655f8f.50.1742207779487;
        Mon, 17 Mar 2025 03:36:19 -0700 (PDT)
Received: from ?IPV6:2003:cb:c73c:aa00:ab00:6415:bbb7:f3a1? (p200300cbc73caa00ab006415bbb7f3a1.dip0.t-ipconnect.de. [2003:cb:c73c:aa00:ab00:6415:bbb7:f3a1])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-395cb7eb953sm14725162f8f.93.2025.03.17.03.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 03:36:19 -0700 (PDT)
Message-ID: <58ad6709-b229-4223-9956-fa9474bad4a6@redhat.com>
Date: Mon, 17 Mar 2025 11:36:18 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 "Gupta, Pankaj" <pankaj.gupta@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
 <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
 <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 17.03.25 03:54, Chenyi Qiang wrote:
> 
> 
> On 3/14/2025 8:11 PM, Gupta, Pankaj wrote:
>> On 3/10/2025 9:18 AM, Chenyi Qiang wrote:
>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>> uncoordinated discard") highlighted, some subsystems like VFIO may
>>> disable ram block discard. However, guest_memfd relies on the discard
>>> operation to perform page conversion between private and shared memory.
>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>> device to a confidential VM via shared memory. To address this, it is
>>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>>
>>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>>> VFIO mappings in relation to VM page assignment. Effectively page
>>> conversion is similar to hot-removing a page in one mode and adding it
>>> back in the other. Therefore, similar actions are required for page
>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>> facilitate this process.
>>>
>>> Since guest_memfd is not an object, it cannot directly implement the
>>> RamDiscardManager interface. One potential attempt is to implement it in
>>> HostMemoryBackend. This is not appropriate because guest_memfd is per
>>> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
>>> particular, the ones like virtual BIOS calling
>>> memory_region_init_ram_guest_memfd() do not.
>>>
>>> To manage the RAMBlocks with guest_memfd, define a new object named
>>> MemoryAttributeManager to implement the RamDiscardManager interface. The
>>
>> Isn't this should be the other way around. 'MemoryAttributeManager'
>> should be an interface and RamDiscardManager a type of it, an
>> implementation?
> 
> We want to use 'MemoryAttributeManager' to represent RAMBlock to
> implement the RamDiscardManager interface callbacks because RAMBlock is
> not an object. It includes some metadata of guest_memfd like
> shared_bitmap at the same time.
> 
> I can't get it that make 'MemoryAttributeManager' an interface and
> RamDiscardManager a type of it. Can you elaborate it a little bit? I
> think at least we need someone to implement the RamDiscardManager interface.

shared <-> private is translated (abstracted) to "populated <-> 
discarded", which makes sense. The other way around would be wrong.

It's going to be interesting once we have more logical states, for 
example supporting virtio-mem for confidential VMs.

Then we'd have "shared+populated, private+populated, shared+discard, 
private+discarded". Not sure if this could simply be achieved by 
allowing multiple RamDiscardManager that are effectively chained, or if 
we'd want a different interface.

-- 
Cheers,

David / dhildenb


