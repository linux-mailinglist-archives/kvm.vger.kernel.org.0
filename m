Return-Path: <kvm+bounces-35046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2639A0925E
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 14:45:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB9B13A92B2
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 13:45:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6076620E02B;
	Fri, 10 Jan 2025 13:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ddd+2NcG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1AE20B7E0
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736516747; cv=none; b=WXmBLmrn6Tu70zAXFjP+amuyceXL9+WkNp0JEJ59gPADTVpWP3t7Uw7PEOPJYTd/2a6jdfT5KjgkxF7ArRTw5QRbitntl8kFjRNvA8WbywoF7fPuqfgVMtyh8CwvlPoqjBWugpJu0EvuUcKKBbi2QW1AX0KSbeD0s73UBdTWOS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736516747; c=relaxed/simple;
	bh=uK7SA/kVJjFt5mx0EWvNMGIy2sMOpNEsq20YxpHvmyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1awQ0yw4rS+9NTZL38LGduUCUYpF/DCa2kvsUrLU8owElqOis03XcLH8pizqd52mEPxcmvc8TcK4H/RoI6GU3r6xFVTMmWszW2G6qm+Uyb72H5vGTcd8IJ3Q3jxiv6a7zrMKj6MnNdZeUcK47gxMelWkX7Nl7ENrqVGMZRzN+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ddd+2NcG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736516744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MgC1ykSz+B2npPAEBoQJVfWIGKdXFExdQ2eK7KNKeso=;
	b=ddd+2NcG12xnOXzcm+yaxSYds+GumwhoDdUsDJ1zrOmg0cQRQ2HEZNBapgmziBDYSsAZwO
	ngmrwifgV5uCa9XV8yJBMpGtLcbn/fPDluD8k+5OnB5ess2OhufztXcH1V0jh84kgoU5Ji
	5perhrN977gfiauyX4Bkwn8LpcjRRKE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-595-bKqeYbxeMGqBedfazpe37A-1; Fri, 10 Jan 2025 08:45:43 -0500
X-MC-Unique: bKqeYbxeMGqBedfazpe37A-1
X-Mimecast-MFC-AGG-ID: bKqeYbxeMGqBedfazpe37A
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4361d4e8359so16455885e9.3
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 05:45:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736516742; x=1737121542;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MgC1ykSz+B2npPAEBoQJVfWIGKdXFExdQ2eK7KNKeso=;
        b=UKzoy5KpXBjshQL2ZNgapK2O5GD4yZgoxrncJddo4lipOuaXAhcbYClvPRPth2okTx
         L/R4KN3vafDt0OvHhOwjPsbsTATalOdFw3zKb0n8DsZkq/WgTirCDXRcLuFbNQp+Ia57
         Hoocg+PcltJXav+nhLfLLLR4DkKD4WKAdevVGr3XJefcnAYBv928siJ/lPXK8P6WvVck
         fxvLC6nAMA49KIJP+h8F3zRuFISS0Nqa0k8wFK/1Yf29RplBoX0B+FYs1E9978bZiHzz
         djytimBDW13gbSmsmWJqQO1kyV6qESL2JsxunK8v71pZlfrWzt1/JTFrDkQd0VoHMo8g
         YIhA==
X-Forwarded-Encrypted: i=1; AJvYcCVkf7WGC4abOQ9sB4/WVDcfmGnPYHjXPxbr9mnDc1svDKJ9cOSp8lsZNa3k23lEKC/nds8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6u5OozLyWdlXD/FSy38S5+HKzdjkVB2z8ozw7eznnswyUTqXS
	FcwPkM10xiGAfKvroP1eOqTGbnn/fkAi57j8rNPKvxpX1nIjhfHuFboAXJ+3RjQanfXSrU6THTH
	unNoeBg7Nhf6PkUMJDEU813HkX/w5LKG1YJdMJWxCcXGxOEIuqg==
X-Gm-Gg: ASbGnctf6nIXn2GRw6GlOkuDEzBign5UKeyxB3yfvPqZ9dtFea8mr0Mu/R+yNM/zIdC
	mNXV+JWtxEHjbPD0rNnWD5D40RPrt1kOL/J8WaEuoewQXvB+IwdmMrBwlytmWxYcuO1epLICaCC
	A4bo1Vmxn3UZ1bzTKfXG7DGGvaRxInbSoIflwephgHwDbw1V6jVHszIBAKBadFEy08VvWBKCvCt
	q/rkx3d5Gq9gZVrtk7nevfmgLNMsM2nv3a3IRl9a8bVMC9NePM0W8EpKqss0uAjAqld/bDXshdr
	YykJAp/q4Ozj2HBN4cCCPHIHckWZ7AWXFtxGWbG3+VWL/fPRSmibuhGkDy3OhdlgCKj11ZQ0te1
	eV2FbAl19
X-Received: by 2002:a05:600c:1d0c:b0:436:1bbe:f686 with SMTP id 5b1f17b1804b1-436e2707c59mr85179205e9.21.1736516741752;
        Fri, 10 Jan 2025 05:45:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXoja55Oz8ju9Y5pIQ4zEfVd8CuyyhjgWKANpd/OCOmWrYWezUDG9OTIt45/30cstml/rNEA==
X-Received: by 2002:a05:600c:1d0c:b0:436:1bbe:f686 with SMTP id 5b1f17b1804b1-436e2707c59mr85178975e9.21.1736516741372;
        Fri, 10 Jan 2025 05:45:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c708:e100:4f41:ff29:a59f:8c7a? (p200300cbc708e1004f41ff29a59f8c7a.dip0.t-ipconnect.de. [2003:cb:c708:e100:4f41:ff29:a59f:8c7a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-436e9e6251asm55521085e9.40.2025.01.10.05.45.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 05:45:40 -0800 (PST)
Message-ID: <17db435a-8eca-4132-8481-34a6b0e986cb@redhat.com>
Date: Fri, 10 Jan 2025 14:45:39 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Enable shared device assignment
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>, Alexey Kardashevskiy
 <aik@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
 <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
 <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
 <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
 <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
 <1361f0b4-ddf8-4a83-ba21-b68321d921da@intel.com>
 <c318c89b-967d-456e-ade1-3a8cacb21bd7@redhat.com>
 <20250110132021.GE5556@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <20250110132021.GE5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.01.25 14:20, Jason Gunthorpe wrote:

Thanks for your reply, I knew CCing you would be very helpful :)

> On Fri, Jan 10, 2025 at 09:26:02AM +0100, David Hildenbrand wrote:
>>>>>>>>>>> One limitation (also discussed in the guest_memfd
>>>>>>>>>>> meeting) is that VFIO expects the DMA mapping for
>>>>>>>>>>> a specific IOVA to be mapped and unmapped with the
>>>>>>>>>>> same granularity.
> 
> Not just same granularity, whatever you map you have to unmap in
> whole. map/unmap must be perfectly paired by userspace.

Right, that's what virtio-mem ends up doing by mapping each memory block 
(e.g., 2 MiB) separately that could be unmapped separately.

It adds "overhead", but at least you don't run into "no, you cannot 
split this region because you would be out of memory/slots" or in the 
past issues with concurrent ongoing DMA.

> 
>>>>>>>>>>> such as converting a small region within a larger
>>>>>>>>>>> region. To prevent such invalid cases, all
>>>>>>>>>>> operations are performed with 4K granularity. The
>>>>>>>>>>> possible solutions we can think of are either to
>>>>>>>>>>> enable VFIO to support partial unmap
> 
> Yes, you can do that, but it is aweful for performance everywhere

Absolutely.


In your commit I read:

"Implement the cut operation to be hitless, changes to the page table
during cutting must cause zero disruption to any ongoing DMA. This is 
the expectation of the VFIO type 1 uAPI. Hitless requires HW support, it 
is incompatible with HW requiring break-before-make."

So I guess that would mean that, depending on HW support, one could 
avoid disabling large pages to still allow for atomic cuts / partial 
unmaps that don't affect concurrent DMA.


What would be your suggestion here to avoid the "map each 4k page 
individually so we can unmap it individually" ? I didn't completely 
grasp that, sorry.

 From "IIRC you can only trigger split using the VFIO type 1 legacy API. 
We would need to formalize split as an IOMMUFD native ioctl.
Nobody should use this stuf through the legacy type 1 API!!!!"

I assume you mean that we can only avoid the 4k map/unmap if we add 
proper support to IOMMUFD native ioctl, and not try making it fly 
somehow with the legacy type 1 API?

-- 
Cheers,

David / dhildenb


