Return-Path: <kvm+bounces-8553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AA77B851411
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 14:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE9191C23107
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 13:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A2BB3A1C4;
	Mon, 12 Feb 2024 13:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cuAxuW/P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E217E39FE0
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 13:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707743203; cv=none; b=M4kExIy0yPWmeQZXL1zDjGtwjN0xhXSfxwVOrpkGvpUSZWOKyCKWliyxb4gQilx1Diw1sfEPACqP2CjHJmXlm0ED9/w77qlheVMzy9BjZ/F+CBkXpPjbmfH/cUORTSEs++PJqd0xtHZYu/BzUAgBuX06ROayv3UP9/XEGQVUebA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707743203; c=relaxed/simple;
	bh=wqNsTaiLJuLcjH0ji/72VXkl0tYbQK9jEQcZxwyUXn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ACCSUKGjOxdfRmahbiE+B20u3JBGgO8gU4n5XNaE/CsPPrj89rP+NrgnnfUnIK+cCLMc2OdgcV49FWs3PnhspFKxaFlMO9Psc3zLrF/Lvl5vjYpfd4pyxPUJeDVYUn5SNkc4fuzAtf7HMt6cW5WZHPxCfMkX9/TZkk9+N/FLq8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cuAxuW/P; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707743201;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WDWwBBM+E91ZU6bnMPP22WeGEpsgO4NhaElCMSoXp58=;
	b=cuAxuW/PQ8xTSovhZZZRBs5fZsi9BwZ5NTRI/6csyNi/NDp7RrPPoeJ/Tz3A2XADm/9L4/
	ar1/um0uN74Uf6cgr/YXZ0XY463aqPkXv5KZtZh1vCjP17rRqVYJyqhf5EMd3dT5DMCGwH
	zzlZHImXkCgI/Pxdm/Lw/EDIM+y9FeA=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-edKPWD5ZMyeFmjTKLBSSvg-1; Mon, 12 Feb 2024 08:06:39 -0500
X-MC-Unique: edKPWD5ZMyeFmjTKLBSSvg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5116e3cce79so2690278e87.2
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 05:06:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707743198; x=1708347998;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WDWwBBM+E91ZU6bnMPP22WeGEpsgO4NhaElCMSoXp58=;
        b=lKur95plPjRSs2bmG9xUR4UGDg57+z/AeNu/eQbmzqOQf6yvuPQ61V5B7yvvgcfsRg
         h8yF8bdKKtmM0Wo9rJcq/yGkJRs5u9dDU//d7ienBzmx2bFuy3sG8zkPddDCjuAPQomp
         zhcxAmvV5Tm2RBHlkYNpOvOutQHaQ7MwAiOhNxg6Co2d+AqRpyQNCV49elLuyK0AA9kT
         K5+l6X3sIloxciRb9QxQmLuIXMLNfs2qszdh/e8s23hzD9/bgLTFncxpfHCPsMi4RK0g
         uGqd3A4Z74HbS3D6PcRLC57og3DbQV1bIM3phXphIkPCvQhDeswet3nrW+3j+pUcLhBX
         0rXQ==
X-Gm-Message-State: AOJu0YycPZ87hh4sJu/12LALFdHZO2c6uKxkFSua+/OFYUWgDvood8T6
	An4jFmi8JZEhZBJLMoLElNYJw0VdDSwQdBmegHjl2G4ittYSfJ2zEKDR+FidJU2mlATkR8Ht9g6
	ARYFSJxJQ/eI3/xK18B0LK2vTFggau1jqykAouyv7R6vX4R0LQw==
X-Received: by 2002:ac2:484e:0:b0:511:82b5:b484 with SMTP id 14-20020ac2484e000000b0051182b5b484mr3671297lfy.64.1707743198001;
        Mon, 12 Feb 2024 05:06:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEAi+y4C0q8Pj8RrJ7Auc1O4J3dTFjnTSp79xOJnXlMZlLNC1sCSpKdTZmKkS2ODIqClDBGHg==
X-Received: by 2002:ac2:484e:0:b0:511:82b5:b484 with SMTP id 14-20020ac2484e000000b0051182b5b484mr3671254lfy.64.1707743197527;
        Mon, 12 Feb 2024 05:06:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVXC8dM/g488xbOderXCs0dcp21CcwsLFJHR6YjVOxLWNicm8D/FidrCQhXbQYYPXxP52FQn6GG6VS87CK34RcDM5er9ZOju/TaFSRP5Vpmzu6TqjOW2LMQnF3BbnYMLVP1uHrFHPG0v8N5KFXtd09uerHdjz+fhgi+uLxz7BoPg08zwBh1doJbrsgvvrmypqtOfc4y/zmqECoVg6kbZMoFr1VLc1Uhx9+j903DvZR3LMFGsefY+vF2dw+omnf6cDEOkJL/EEYByXjlD3Bi3MnhLsQnf91b07gLGtSs3VJeKLMdKOY//OjJsCnUva0YKI6swT0sg5VplGAwiG8TiipWfkP4Dkuo+CJy6ZdLfdyPrY/uWjQRQPQ5JLXCq8/B4P6wsn4QEpLeM/OzTu1HD2+I92rn6S/dlq0FbWlwlDV7M3SZLPn72BkiZSW2KrQNpYej7sCjrZxy5j6Ar9j6oS5jhbq2Q9ebBuZ81uny5MKkl0vQMNDUoaEfyNOk2Sv/eofaXbkNVypvTg6d299CrApmhqZ//8eVLqWSYV124AAQLp/ezhBtmhkgLN5cbYX9GZAKGwqEVGrkBDvluzSOJECKk765SluUSMDGuBXIa3ueBGkl4Ds7Elh+eSp6LYL1++VFijkYYUu1o6I02DPsqLKsVAZQx4OV5PILjXyGqx48Na+Ep/o+TOHK5TPg9cyO+CDQGD7fwO3mLgVWpn6Yb4BPDPYs2eanp7zukA0iIqseJiOx/CD8z84YqyHqV+78e0WjMdIcw6BUp/JoMtOVURx6X5ADMonU1DZ+F2UqFSdiCU/C+3r1QKmSwSiaW9J3QpiwZUoHqnaK/SIurVbzLe9w4mFoqc3d/AuD8zZ7xc9SetcFkQ99ywYqdtP5T2CxgTRe2LwsDcmxg4A5QfnmdeAfZ1CteF7hcwmX0qnkJwDd1O7u7G+nMAMphnaovdvLYk1sVt
 Md5KQ94VW9wGUPPwNPZJdsinJnIcn9kBO2w/U5jPqBpfdDTnAswC0qn1g5umFVUiqHB7gH/w04Ns6+L+Hw64YEAKguyQnn/LW8NySO0AhQ2oqgT5AVK2VnmPAeTcgm15OdeIheJPcqNj4x3yAtrIXcwl46Vd/Aqxy+tOLzx02FdOiPiqrALlh8gN7c0CuQBdNU9MMrQMTMC8BDjUbgK+3Q+HIdsVgFFmYhvzdlFUrv7NaWu0yT4hafOLsnnEQoZonKGeQjZsZsvCT457uNFhuE8WfZD0/rKQwSKH6k9FVEUxWmVNC3Zzuz+PpwBigCJCDwsn+yD2q1eiAmUgSmfQ==
Received: from ?IPV6:2003:cb:c730:2200:7229:83b1:524e:283a? (p200300cbc7302200722983b1524e283a.dip0.t-ipconnect.de. [2003:cb:c730:2200:7229:83b1:524e:283a])
        by smtp.gmail.com with ESMTPSA id k14-20020a056000004e00b0033afc81fc00sm6714883wrx.41.2024.02.12.05.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 05:06:37 -0800 (PST)
Message-ID: <30493284-53f6-4172-a9e1-cb9052acced4@redhat.com>
Date: Mon, 12 Feb 2024 14:06:35 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/4] kvm: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
 james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
 brauner@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 mark.rutland@arm.com, alex.williamson@redhat.com, kevin.tian@intel.com,
 yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 andreyknvl@gmail.com, wangjinchao@xfusion.com, gshan@redhat.com,
 shahuang@redhat.com, ricarkol@google.com, linux-mm@kvack.org,
 lpieralisi@kernel.org, rananta@google.com, ryan.roberts@arm.com,
 linus.walleij@linaro.org, bhe@redhat.com, aniketa@nvidia.com,
 cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
 vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
 jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
 mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20240211174705.31992-1-ankita@nvidia.com>
 <aa6c1708-d6ac-46f7-b7ab-e97a273a90c2@redhat.com>
 <20240212125654.GV10476@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240212125654.GV10476@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Jason,

Thanks for all the details (some might be valuable to document in more 
detail, but I'm not that experienced with all of the mapping types on 
arm64, so it might "just be me").

> It is worse that some hand wavey "side effect". If you map memory with
> NORMAL_NC (ie for write combining) then writel() doesn't work
> correctly at all.
> 
> The memory must be mapped according to which kernel APIs the actual
> driver in the VM will use. writel() vs __iowrite64_copy().
> 
>> We can trigger both cases right now inside VMs, where we want the device
>> driver to actually make the decision.
> 
> Yes
>   
>> (2) For a VM, that device driver lives inside the VM, for DPDK and friends,
>> it lives in user space. They have this information.
> 
> Yes
>   
>> We only focus here on optimizing (fixing?) the mapping for VMs, DPDK is out
>> of the picture.
> 
> DPDK will be solved through some VFIO ioctl, we know how to do it,
> just nobody has cared enough to do it.

Good!

> 
>> So we want to allow the VM to achieve a WC/NC mapping by using a
>> relaxed (NC) mapping in stage-1. Whatever is set in stage-2 wins.
> 
> Yes
>   
>>
>> (3) vfio knows whether using WC (and NC?) could be problematic, and must
>> forbid it, if that is the case. There are cases where we could otherwise
>> cause harm (bring down the host?). We must keep mapping the memory as
>> DEVICE_nGnRE when in doubt.
> 
> Yes, there is an unspecific fear that on ARM platforms using NORMAL_NC
> in the wrong way can trigger a catastrophic error and kill the
> host. There is no way to know if the platform has this bug, so the
> agreement was to be conservative and only allow it for vfio-pci, based
> on some specific details of how PCI has to be implemented and ARM
> guidance on PCI integration..
> 
>> Now, what the new mmap() flag does is tell the world "using the wrong
>> mapping type cannot bring down the host", and KVM uses that to use a
>> different mapping type (NC) in stage-1 as setup by vfio in the user space
>> page tables.
> 
> The inverse meaning, we assume VMAs with the flag can bring down the
> host, but yes.

Got it, will have a closer look at the patch soon.

> 
>> I was trying to find ways of avoiding a mmap() flag and was hoping that we
>> could just use a PTE bit that does not have semantics in VM_PFNMAP mappings.
>> Unfortunately, arm64 does not support uffd-wp, which I had in mind, so it's
>> not that easy.
> 
> Seems like a waste of a valuable PTE bit to me.

It would rather have been "it's already unused there, so let's reuse 
it". But there was no such low-hanging gruit.

> 
>> Further, I was wondering if there would be a way to let DPDK similarly
>> benefit, because it looks like we are happily ignoring that (I was told they
>> apply some hacks to work around that).
> 
> dpdk doesn't need the VMA bit, we know how to solve it with vfio
> ioctls, it is very straightforward. dpdk just does a ioctl & mmap and
> VFIO will create a vma with pgprote_writecombine(). Completely
> trivial, the only nasty bit is fitting this into the VFIO uAPI.

That's what I thought.

> 
>> (a) User space tells VFIO which parts of a BAR it would like to have mapped
>> differently. For QEMU, this would mean, requesting a NC mapping for the
>> whole BAR. For DPDK, it could mean requesting different types for parts of a
>> BAR.
> 
> We don't want to have have the memory mapped as NC in qemu. As I said
> above if it is mapped NC then writel() doesn't work. We can't have
> conflicting mappings that go toward NC when the right answer is
> DEVICE.

I was wondering who would trigger that, but as I read below it could be 
MMIO emulation.

> 
> writel() on NC will malfunction.
> 
> __iowrite64_copy() on DEVICE will be functionally correct but slower.
> 
> The S2 mapping that KVM creates is special because it doesn't actually
> map it once the VM kernel gets started. The VM kernel always supplies
> a S1 table that sets the correct type.
> 
> So if qemu has DEVICE, the S2 has NC and the VM's S1 has DEVICE then
> the mapping is realiably made to be DEVICE. The hidden S2 doesn't
> cause a problem.
> 
>> That would mean, that we would map NC already in QEMU. I wonder if that
>> could be a problem with read speculation, even if QEMU never really accesses
>> that mmap'ed region.
> 
> Also correct.
> 
> Further, qemu may need to do emulation for MMIO in various cases and
> the qemu logic for this requires a DEVICE mapping or the emulation
> will malfunction.
> 
> Using NC in qemu is off the table.

Good, thanks for the details, all makes sense to me.

-- 
Cheers,

David / dhildenb


