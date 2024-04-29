Return-Path: <kvm+bounces-16149-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C27F08B58C7
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 14:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73320285057
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 12:41:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3C1E10A2E;
	Mon, 29 Apr 2024 12:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MyQueRBE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB59BE4E
	for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 12:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714394444; cv=none; b=NLr1jEwLUMgBHZ7OXYYZlCVPxQTO+UD974fZPdz9aIt1Y1geZOmcZguHFn1M+RJ1lClyk1dxomIrzd4+b1b76dE94rlIabGnWQNe67eEVc63v3b2cXIA9/xAIUT9ARvHF3ZTi7dWOTBeb1YwMXL9oOYlpXpMYk2V2Tdo35cYKnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714394444; c=relaxed/simple;
	bh=6D2a3vGvyPEJ5sHXioTCcxQC31damFpV0mzd8HdSwSo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=srCdG8dwV83lxPCywLJYCGPn5MxHldriAeRQT7+rqFJbC1dVX/AwxnhX8unrCY/SoYarweabbRoXZ0BpIbP6+ms2jdibg90iFMR6vSbSrgqFgyVEU0fwFVnXB3b2MHTCVSE9v8i/umNuo/lyDjh3orOutO1fxVsGaM9kRt64FFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MyQueRBE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714394441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6D2a3vGvyPEJ5sHXioTCcxQC31damFpV0mzd8HdSwSo=;
	b=MyQueRBE9LlX4/Ww7SZJHnnNPrDBeQmiMvezW0VHdBX+GKJ/bcXJ5g/YiO29oP1HfzOLS5
	QL0En0pTKMwD+TEKwzF/DNHduYZwEeA2W+ChKcZ+w23ROlF/fr8PCBGOWsEzpDZ97icKYR
	hjrceyLOBWmIqa5F215tn8m0ZZOMmKw=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-57-tPwSxdREOZCWrx21KguoqQ-1; Mon, 29 Apr 2024 08:40:39 -0400
X-MC-Unique: tPwSxdREOZCWrx21KguoqQ-1
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-43aeee4d2c7so10604471cf.2
        for <kvm@vger.kernel.org>; Mon, 29 Apr 2024 05:40:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714394439; x=1714999239;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6D2a3vGvyPEJ5sHXioTCcxQC31damFpV0mzd8HdSwSo=;
        b=ekp8qlPBQOw+M/Oo1um693mPfzgdmDKw7nObJACGgye1W01lYPckCWwYCFEPKQneyR
         Qzyc4w2YjLDRoyQK1PJyYIAzcAgj3gAJzWWVbZ8jmTa/qrTahKUdiIIOOwrDZcAYoNdZ
         ZptyEFtnKNB7q0yPOkpu5FsX1MB7f8/AzbKogwxmjGHbrG3oDb7CF3fBtW7N/7Rasmtf
         N+Nb9IkwnX2cP/B7iwnqRepELgf4FRfrWpQWY+puD+zDOmJ3I3i1gRNvdb7GVCHolLPf
         JcdPqOD+xIZeUzlvA2GEhZCCSmUvGjl5QlZEqfsP6WZsY5nBdsEeheBkwV2pzQf55Biw
         xhwA==
X-Forwarded-Encrypted: i=1; AJvYcCXqv2k4XiQ9dgBpUkvMPYEmkn/HKderIYhrPhQ6US0v6Z2iz9Z8HuNDwsdjtDif/UUHc44tmq17uETNReEnQFGsBThn
X-Gm-Message-State: AOJu0Yy2yEDa/1rnITiljnHD1VlwodpoUXqrYx4A1TwA4Z8RghIPPuSA
	87q/NEmq3OdXSfhy4IHtpqZP92qfTN5L0hKzjqqy1kcR1o3cMJbt2i7JLfK6KvMDrcLSAwhfKDN
	ImiK0BgfySLL+Xe7EBra71ogdCk/FEslouoeJsjljx5N5PbxGWg==
X-Received: by 2002:ac8:5ad6:0:b0:43a:ef4e:7b28 with SMTP id d22-20020ac85ad6000000b0043aef4e7b28mr3558093qtd.21.1714394439474;
        Mon, 29 Apr 2024 05:40:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH+6+yZssObbaeBialeUKT9GT3Il2t+xTdj7JPBwoyu19bRWzh7C46GmQYHvJdfmx+jFldVVg==
X-Received: by 2002:ac8:5ad6:0:b0:43a:ef4e:7b28 with SMTP id d22-20020ac85ad6000000b0043aef4e7b28mr3558080qtd.21.1714394439200;
        Mon, 29 Apr 2024 05:40:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id s24-20020ac87598000000b00436440fd8bfsm10368318qtq.3.2024.04.29.05.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Apr 2024 05:40:38 -0700 (PDT)
Message-ID: <d8cc4405-fe9c-4b47-be76-708a72d4b1a1@redhat.com>
Date: Mon, 29 Apr 2024 14:40:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] vfio/pci: migration: Skip config space check for
 Vendor Specific Information in VSC during restore/load
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vinayak Kale <vkale@nvidia.com>, qemu-devel@nongnu.org,
 marcel.apfelbaum@gmail.com, avihaih@nvidia.com, acurrid@nvidia.com,
 cjia@nvidia.com, zhiw@nvidia.com, targupta@nvidia.com, kvm@vger.kernel.org
References: <20240322064210.1520394-1-vkale@nvidia.com>
 <20240327113915.19f6256c.alex.williamson@redhat.com>
 <20240327161108-mutt-send-email-mst@kernel.org>
 <20240327145235.47338c2b.alex.williamson@redhat.com>
 <10a42156-067e-4dc1-8467-b840595b38fa@redhat.com>
Content-Language: en-US, fr
In-Reply-To: <10a42156-067e-4dc1-8467-b840595b38fa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello Vinayak,

On 3/28/24 10:30, Cédric Le Goater wrote:
> On 3/27/24 21:52, Alex Williamson wrote:
>> On Wed, 27 Mar 2024 16:11:37 -0400
>> "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>
>>> On Wed, Mar 27, 2024 at 11:39:15AM -0600, Alex Williamson wrote:
>>>> On Fri, 22 Mar 2024 12:12:10 +0530
>>>> Vinayak Kale <vkale@nvidia.com> wrote:
>>>>> In case of migration, during restore operation, qemu checks config space of the
>>>>> pci device with the config space in the migration stream captured during save
>>>>> operation. In case of config space data mismatch, restore operation is failed.
>>>>>
>>>>> config space check is done in function get_pci_config_device(). By default VSC
>>>>> (vendor-specific-capability) in config space is checked.
>>>>>
>>>>> Due to qemu's config space check for VSC, live migration is broken across NVIDIA
>>>>> vGPU devices in situation where source and destination host driver is different.
>>>>> In this situation, Vendor Specific Information in VSC varies on the destination
>>>>> to ensure vGPU feature capabilities exposed to the guest driver are compatible
>>>>> with destination host.
>>>>>
>>>>> If a vfio-pci device is migration capable and vfio-pci vendor driver is OK with
>>>>> volatile Vendor Specific Info in VSC then qemu should exempt config space check
>>>>> for Vendor Specific Info. It is vendor driver's responsibility to ensure that
>>>>> VSC is consistent across migration. Here consistency could mean that VSC format
>>>>> should be same on source and destination, however actual Vendor Specific Info
>>>>> may not be byte-to-byte identical.
>>>>>
>>>>> This patch skips the check for Vendor Specific Information in VSC for VFIO-PCI
>>>>> device by clearing pdev->cmask[] offsets. Config space check is still enforced
>>>>> for 3 byte VSC header. If cmask[] is not set for an offset, then qemu skips
>>>>> config space check for that offset.
>>>>>
>>>>> Signed-off-by: Vinayak Kale <vkale@nvidia.com>
>>>>> ---
>>>>> Version History
>>>>> v2->v3:
>>>>>      - Config space check skipped only for Vendor Specific Info in VSC, check is
>>>>>        still enforced for 3 byte VSC header.
>>>>>      - Updated commit description with live migration failure scenario.
>>>>> v1->v2:
>>>>>      - Limited scope of change to vfio-pci devices instead of all pci devices.
>>>>>
>>>>>   hw/vfio/pci.c | 24 ++++++++++++++++++++++++
>>>>>   1 file changed, 24 insertions(+)
>>>>
>>>>
>>>> Acked-by: Alex Williamson <alex.williamson@redhat.com>
>>>
>>>
>>> A very reasonable way to do it.
>>>
>>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>>>
>>> Merge through the VFIO tree I presume?
>>
>> Yep, Cédric said he´d grab it for 9.1.  Thanks,

Could you please resend an update of this change adding a machine
compatibility property for migration ?

Thanks,

C.


