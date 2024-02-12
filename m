Return-Path: <kvm+bounces-8542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 317308510C9
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 11:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDD05282EE3
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 10:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E50028387;
	Mon, 12 Feb 2024 10:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTMBsINB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA191BDC2
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 10:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707733580; cv=none; b=IVL4yQQR/N3qGZP8W6TIGL7D2TYD7sn8Wpp+lsyN0aWCNAji3zywKp4R1VshfvSYbV140eAgW9ow67AjjGlFq1cxU+LQWWbxqC1Be6lNCBM62UqhXGiy0cesPXik93/gIpH03LaAgOufTQ84MbqwogG4PL+gKoGPFxVapJhu4cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707733580; c=relaxed/simple;
	bh=sOL90vEBcEko5xkjlPxp8zv+72g9wfoxFuHOUtP0+l8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S1oZLBMQdfLEttlN8jHssUJfmVM225JwuLvaHfjN+o4DDTHgWkwxg4owErZuAYvW4sGRX30tG04lCJqWyI1wT2wbDQpxhAAoXmQs5GJMpbKGvq9Viy1cp5eC5tCmF3mQBW6Gnr003vcQLWw2XLWOScf8j07gkM9z5UXDE3l9ZDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OTMBsINB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707733578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ajsmGt1bfpvDAI9sBo5jj02X8v7xaTXyEQzhR5XLbDM=;
	b=OTMBsINBLrFPqQKATio2oh/1l6r3vThQwAckepCxcxqtJz+sghG1pCYTDf1XDZRLNH5mEi
	K3/ZbRCoNUbyJ8FHjrw3UowgF12EkfNGBTqjKT/wSvHueRCibaevKroAS5gh1SAFPNmMVy
	wL7rCI6pEZpDtB5siF8VAcNUFx2rN6k=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-aZOMnG1oN-W83IbgDRVhQQ-1; Mon, 12 Feb 2024 05:26:16 -0500
X-MC-Unique: aZOMnG1oN-W83IbgDRVhQQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-410422e8cd1so18626685e9.3
        for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 02:26:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707733576; x=1708338376;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ajsmGt1bfpvDAI9sBo5jj02X8v7xaTXyEQzhR5XLbDM=;
        b=qCclx4Rs90oLGeUlQbB/iHItFLMVAxHcP8ntYEIHBKcnZzTX2OHwoj7h0Qy2beQsXu
         hqSaD1LugPPJdTA5cZr0w3FtFax9MdpeEc+EctJV/mYiJNQKPY91mdbqU8mvw6Wby+zz
         TsrSJ30gx3Krrz1upPAorUhe97YYCrYJUjYTKQFX/OFUzs9dZJfC6Ab7RGvfEOx+vcjU
         Z/MpkfMNhtmzrbSgrz7bp5nQ6w6TZPNOgzqdzsxFp4ui0x87hb7X7ULwQgOzUiEIg2dH
         HctZBJiuxJFr1DAvT67TBF62bt3HpOU+vYoaV5qmmeeAr7Ux9a2BXF09bT6bacqRTKir
         r4dw==
X-Forwarded-Encrypted: i=1; AJvYcCU6nDA6pjVFb5pEVSNo/nhHTxG7yYL7IsAJ4U7LnEujOcHi3BX0XQjVitAaGOzCo+Ud+gCuBgKyjOl5hvTnBP2JR7SL
X-Gm-Message-State: AOJu0YwL8XCq12zCZvzJS6CcUYqO8UV56DJeVDL7jzqUGfOdmvLXxcHe
	wJ0fvNwmJxeLLnRCzqe6j6XNnsmiHPScJBN9RyBr6YBtnQc9Je+/pLNomZkK9FBU84lyc9EMGsR
	aK5ekJ3YUUWFFlrZiT92ezKebr3yE3ugVA1KWjENJzTTccKLwdg==
X-Received: by 2002:a05:600c:1547:b0:410:c25d:38fe with SMTP id f7-20020a05600c154700b00410c25d38femr2340020wmg.28.1707733575633;
        Mon, 12 Feb 2024 02:26:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVD8DZA+W7q7BMDIBUU3MF2lO2KU7zAmuFrQYrgoMoZ6HW+m5qw6f8vnK6rVyl/q9ES5E3Nw==
X-Received: by 2002:a05:600c:1547:b0:410:c25d:38fe with SMTP id f7-20020a05600c154700b00410c25d38femr2339995wmg.28.1707733575193;
        Mon, 12 Feb 2024 02:26:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX4gsbNkHRRqRmeaCnsyMXIotsiVg8FOGx+3lUiGBeU2q6YxqcVLPBsdJFC8G3G2qx1rxh00i5dYr6fj9YEK5zqrZuEpcfxmAxQ46gy8Q+B5E+a2GU0I+OFu0+r5kBSTuRBs20wyCgi1LXiZsn/6SmSOSkpZnhRgnllKfy+urzdhuQpFVA/BIjiShdbJhzo0Drtt3wH86j1Pp8RRXRc0UfHPxM71eiSbr3EY7+nlLAhXR2m8V6BZwKJrmTzilX3Afw/L1UJKjv0VOEt4MyqSE8hljrUMPmcryJBkGs51sHWaTCe5l0jjNnLTSUum3K+FI2BqPsqzctt4sl6FW0YfccXpvYOec6FoYlFflT1Ami3jWtwsxkXFTizPQEpoVZWEg1OASFtA830BpZB6qkw12j738pUTct/V82ZOliICzx1gvAhvrLbjtCE37RN6cLs6XZG5xhB03QMbAPcQArwZs6dUKvBL0bCZabxbVKcaGTIs4t34vn4CRpm/SzixoJcOAKXBduyQ1g8yWRI2QdBSzX6GtjgeQUSHRG19NyhIxvFZ/nzeIy6SecPDCZvxKSA+QXXkt68bHZfTl6beajEC3uB+qACmihudYp2FnvSmCHnUqqeu5HIWXl36JkzkrbLEVFxfYg/T3t5q809awy4nrDie2Gusi70eaFwofZOnZpkl4Y+lxGeb+BwsO7P6YZ2O0iCdfVBBdZzPaCdZjWqc/9us17tLXRS+0t3j3Wp3wapgsSNtPRMUsxn7Dxinv4xPajMWKnWLXwC6CRzDs+Lg4VMPYifyloEsPS2cMK/e2CKVzz+7rLwA00bblUPoHiGCIEHYV9JD3mYH7MVZfGHq6alr+hetrPnk92soENAxNlHW9+ISYQdGLK53Pjqn4MuIbyrmGz8J4bgl7WfsA3I3Mlqi8nw+Ex80BTB2byg7ZUG5OmSjXNLFOR9XlGCqBVtys50br
 4TO+Fs2wkaz0wz6ozhv9kHVheahIztFhA0uQQdrFTtkwuMV/nusxIMhuCnWZ/wLvoB0tDTEjhL2C0gIE+ENdCLK4P1zj0EY0PFGwDy30/vTgAcQf/ANyNt9xevrA3hPwSG0LDkYmiSkDXYwXhPTCZWm05Z0wposEib542tAOOoIiK7GubvwMLSN9fa7ByIMVPe9GIlaqbhC5PYOhB1dziPivbXlPwuUECUZT8dd57WK00Fl+HmH1IQJ/wFYugJNT59S5QPSopt+6PvFsgpcwevf57u3BE577aB55MKZrwfsA9OMNL6+Vp1Bd3C0jW14ajFbflLWD8k2BV5
Received: from ?IPV6:2003:cb:c730:2200:7229:83b1:524e:283a? (p200300cbc7302200722983b1524e283a.dip0.t-ipconnect.de. [2003:cb:c730:2200:7229:83b1:524e:283a])
        by smtp.gmail.com with ESMTPSA id js26-20020a05600c565a00b0040fe3147babsm8164556wmb.0.2024.02.12.02.26.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 02:26:14 -0800 (PST)
Message-ID: <aa6c1708-d6ac-46f7-b7ab-e97a273a90c2@redhat.com>
Date: Mon, 12 Feb 2024 11:26:12 +0100
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
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, reinette.chatre@intel.com, surenb@google.com,
 stefanha@redhat.com, brauner@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, mark.rutland@arm.com, alex.williamson@redhat.com,
 kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, andreyknvl@gmail.com, wangjinchao@xfusion.com,
 gshan@redhat.com, shahuang@redhat.com, ricarkol@google.com,
 linux-mm@kvack.org, lpieralisi@kernel.org, rananta@google.com,
 ryan.roberts@arm.com, linus.walleij@linaro.org, bhe@redhat.com
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com,
 kvmarm@lists.linux.dev, mochs@nvidia.com, zhiw@nvidia.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20240211174705.31992-1-ankita@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20240211174705.31992-1-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11.02.24 18:47, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 

Hi,

> Currently, KVM for ARM64 maps at stage 2 memory that is considered device
> with DEVICE_nGnRE memory attributes; this setting overrides (per
> ARM architecture [1]) any device MMIO mapping present at stage 1,
> resulting in a set-up whereby a guest operating system cannot
> determine device MMIO mapping memory attributes on its own but
> it is always overridden by the KVM stage 2 default.
> 
> This set-up does not allow guest operating systems to select device
> memory attributes independently from KVM stage-2 mappings
> (refer to [1], "Combining stage 1 and stage 2 memory type attributes"),
> which turns out to be an issue in that guest operating systems
> (e.g. Linux) may request to map devices MMIO regions with memory
> attributes that guarantee better performance (e.g. gathering
> attribute - that for some devices can generate larger PCIe memory
> writes TLPs) and specific operations (e.g. unaligned transactions)
> such as the NormalNC memory type.
> 
> The default device stage 2 mapping was chosen in KVM for ARM64 since
> it was considered safer (i.e. it would not allow guests to trigger
> uncontained failures ultimately crashing the machine) but this
> turned out to be asynchronous (SError) defeating the purpose.
> 
> For these reasons, relax the KVM stage 2 device memory attributes
> from DEVICE_nGnRE to Normal-NC.
> 
> Generalizing to other devices may be problematic, however. E.g.
> GICv2 VCPU interface, which is effectively a shared peripheral, can
> allow a guest to affect another guest's interrupt distribution. Hence
> limit the change to VFIO PCI as caution. This is achieved by
> making the VFIO PCI core module set a flag that is tested by KVM
> to activate the code. This could be extended to other devices in
> the future once that is deemed safe.

I still have to digest some of the stuff I learned about this issue, 
please bear with me :)

(1) PCI BARs might contain mixtures of RAM and MMIO, the exact 
locations/semantics within a BAR are only really known to the actual 
device driver.

We must not unconditionally map PFNs "the wrong way", because it can 
have undesired side effects. Side effects might include 
read-speculation, that can be very problematic with MMIO regions.

The safe way (for the host) is DEVICE_nGnRE. But that is actually 
problematic for performance (where we want WC?) and unaligned accesses 
(where we want NC?).

We can trigger both cases right now inside VMs, where we want the device 
driver to actually make the decision.


(2) For a VM, that device driver lives inside the VM, for DPDK and 
friends, it lives in user space. They have this information.

We only focus here on optimizing (fixing?) the mapping for VMs, DPDK is 
out of the picture. So we want to allow the VM to achieve a WC/NC 
mapping by using a relaxed (NC) mapping in stage-1. Whatever is set in 
stage-2 wins.


(3) vfio knows whether using WC (and NC?) could be problematic, and must 
forbid it, if that is the case. There are cases where we could otherwise 
cause harm (bring down the host?). We must keep mapping the memory as 
DEVICE_nGnRE when in doubt.


Now, what the new mmap() flag does is tell the world "using the wrong 
mapping type cannot bring down the host", and KVM uses that to use a 
different mapping type (NC) in stage-1 as setup by vfio in the user 
space page tables.

I was trying to find ways of avoiding a mmap() flag and was hoping that 
we could just use a PTE bit that does not have semantics in VM_PFNMAP 
mappings. Unfortunately, arm64 does not support uffd-wp, which I had in 
mind, so it's not that easy.


Further, I was wondering if there would be a way to let DPDK similarly 
benefit, because it looks like we are happily ignoring that (I was told 
they apply some hacks to work around that).


In essence, user space knows how it will consume that memory: QEMU wants 
to mmap() it only to get it into stage-1 and not access it via the user 
page tables. DPDK wants to mmap() it to actually access it from user space.


So I am curious, is the following problematic, and why:

(a) User space tells VFIO which parts of a BAR it would like to have 
mapped differently. For QEMU, this would mean, requesting a NC mapping 
for the whole BAR. For DPDK, it could mean requesting different types 
for parts of a BAR.

(b) VFIO decides if it is safe to use a relaxed mapping. If in doubt, it 
falls back to existing (legacy) handling -- DEVICE_nGnRE.

(c) KVM simply uses the existing mapping type instead of diverging from 
the one in the user space mapping.


That would mean, that we would map NC already in QEMU. I wonder if that 
could be a problem with read speculation, even if QEMU never really 
accesses that mmap'ed region.

Something like that would of course require user space changes. Handling 
it without such changes (ignoring DPDK of course) would require some 
information exchange between KVM and vfio, like the mmap flag proposed.

-- 
Cheers,

David / dhildenb


