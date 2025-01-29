Return-Path: <kvm+bounces-36878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D19ECA222D6
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB8763A38A7
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:24:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25DD61E32B7;
	Wed, 29 Jan 2025 17:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3bAWx54"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771211E200E
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171425; cv=none; b=tRTZudBxajYBhxdbANae4GsI/xPUUccXREz/DRrfbZkf4xymMW/w6fvY2iD3vC3zRV8PH2x3HW549djjFB4najOq50BOKN06n41lBE92ppnU4oWF9o4Zn7DR6yNYWxCURAqiK8lNG/2hlIEFqzUXOWSi5K3PnGttl7dxpZkiAus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171425; c=relaxed/simple;
	bh=lTP2WZGK7rl5hpI7hR7S+twULR2cKHG1SjFFxN33iF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=puABYAZFeQSmebRc4dY9mrQKQMPDnuQgStGenOPO8Ztdklv0J+ULjuK6qupy5WbLy2Faeik3IOVnWfEEPqB1+thBKX0wgsB4JlBANCdi/PiB3asrsUaP8e21veQ5AbT6rhCTcHQBH3bjU2hJ2VdFKPeJt1SUojT4v3zd72ixYuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I3bAWx54; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738171422;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUinW45xP5e5WNhMH3KfMBEndfX+Wq9Gq0wkIWuPQkM=;
	b=I3bAWx54rCorILOhbHxkyJWp3CX1p+bjvafSd9mEXnFeVpi4rpI8JfJ79xnEE6YiEg3NnA
	IF65reYuPPsyD6NPtXSV5DMxfUktk3bTOV/FDsRBei9v5KpClYf6XNoTZFTdrxGAbz2wRH
	m4nqVlI1DjJKTpzfHP2LlmnaRBIbz70=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-HdeL1vELMDq9g6WeKj3eWg-1; Wed, 29 Jan 2025 12:23:39 -0500
X-MC-Unique: HdeL1vELMDq9g6WeKj3eWg-1
X-Mimecast-MFC-AGG-ID: HdeL1vELMDq9g6WeKj3eWg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361b090d23so36494855e9.0
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171418; x=1738776218;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cUinW45xP5e5WNhMH3KfMBEndfX+Wq9Gq0wkIWuPQkM=;
        b=MC53zZhVf6ief50pwrXRfQwZwcMYRX2y0JI+Ov+hphk8Ee/NEK2IYn9yx01BvmkRZY
         H3rKr3pEwAOwwvxnEVSMntJTgpFf8hByylbWEq7xp4Ae8vfPZrsF0rjRhLdSEztFEoxc
         /UWuTq0i+uJkZ3tP80D5fTV70VRLkiJp/fHUYFGXaDhM0QYqUH8Vq6cMIq+bdH7TZWLE
         e3cDVwwJ6XOB4mt7lbYcm0EUIdWECPDGDH1P3nxVOE+DaABc1uaToTSQX1eww1l2vwjd
         fNPX8Mc7rzZCT+27gusozcNpQGJvgHSZJwvHOluYQhPdHzPv8YCn8EXql4ngqmwHVuZX
         sDFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM4hTI+gA+A0pg8oMV8fDNZMm0RQh7PRidiW4w2HOvzljNnBD1DB8CndHZXK6OqJYHKXM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJpC08EVxINay2jrnf+QFiXhBXonwNfdBcuHEjCx7txPB5Jqzk
	bdJ/yGDCfaBn97d8t4cjJL2Ln6BDJtbJvUe0xZaIZ3tb91QMUNsKOgUMiR/18k92d5SxgBMNvxo
	K9wC+VZiC78+YfaOm6Mt1/+fotUF5tRtkFrqa0dd3s047504tBg==
X-Gm-Gg: ASbGncsfuXonJKTZxUIxK6HXFyTV1MTrC5KvO/jz6t7W7byqFXc/gUuPdMhhDzL44ES
	5SgWmnY/fqrta3b8kCS244N+mTzZTe4qFQK5sodlx9bc5qufPkixZb44PPqfv+OYIfLwbk5nUZW
	AyH+8yjAczzWbsn1AVKOJhmKeZo4o/4HQUc3oBatZbTBqPNBlEYI6tdKXOuNojoUTCvvRgJi+VF
	AFRrmiKb1uUKhBSrcFSN/6dmWWaddmzHbWzHYpWvVGQEubfs8CSZnmrE39v4wk3b3Ic/RErxzDU
	BeuesHTrbWQbzc0+Rvb4UnunOPwU0f9vF+H4pvsQjJoTVzd9B3BE
X-Received: by 2002:a05:600c:468d:b0:434:f270:a513 with SMTP id 5b1f17b1804b1-438dc429eb0mr37292645e9.29.1738171418181;
        Wed, 29 Jan 2025 09:23:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpj2GyirYUousb08KORRhwwxL2nA/aWckunw7W2c2Pu3YOW2k9PIs9cw16oemlKH4tI9rx+g==
X-Received: by 2002:a05:600c:468d:b0:434:f270:a513 with SMTP id 5b1f17b1804b1-438dc429eb0mr37292495e9.29.1738171417820;
        Wed, 29 Jan 2025 09:23:37 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438dcc24cefsm29536565e9.15.2025.01.29.09.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 09:23:36 -0800 (PST)
Message-ID: <21ac88b0-fe93-4933-893c-7ffb09267e7b@redhat.com>
Date: Wed, 29 Jan 2025 18:23:33 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 09/13] iommufd: Add IOMMU_OPTION_SW_MSI_START/SIZE
 ioctls
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
 robin.murphy@arm.com, kevin.tian@intel.com, tglx@linutronix.de,
 maz@kernel.org, alex.williamson@redhat.com, joro@8bytes.org,
 shuah@kernel.org, reinette.chatre@intel.com, yebin10@huawei.com,
 apatel@ventanamicro.com, shivamurthy.shastri@linutronix.de,
 bhelgaas@google.com, anna-maria@linutronix.de, yury.norov@gmail.com,
 nipun.gupta@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
 jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
 shameerali.kolothum.thodi@huawei.com, smostafa@google.com, ddutile@redhat.com
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <d3cb1694e07be0e214dc44dcb2cb74f014606560.1736550979.git.nicolinc@nvidia.com>
 <0521187e-c511-4ab1-9ffa-be2be8eacd04@redhat.com>
 <20250129145800.GG5556@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250129145800.GG5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit




On 1/29/25 3:58 PM, Jason Gunthorpe wrote:
> On Wed, Jan 29, 2025 at 02:44:12PM +0100, Eric Auger wrote:
>> Hi,
>>
>>
>> On 1/11/25 4:32 AM, Nicolin Chen wrote:
>>> For systems that require MSI pages to be mapped into the IOMMU translation
>>> the IOMMU driver provides an IOMMU_RESV_SW_MSI range, which is the default
>>> recommended IOVA window to place these mappings. However, there is nothing
>>> special about this address. And to support the RMR trick in VMM for nested
>> well at least it shall not overlap VMM's RAM. So it was not random either.
>>> translation, the VMM needs to know what sw_msi window the kernel is using.
>>> As there is no particular reason to force VMM to adopt the kernel default,
>>> provide a simple IOMMU_OPTION_SW_MSI_START/SIZE ioctl that the VMM can use
>>> to directly specify the sw_msi window that it wants to use, which replaces
>>> and disables the default IOMMU_RESV_SW_MSI from the driver to avoid having
>>> to build an API to discover the default IOMMU_RESV_SW_MSI.
>> IIUC the MSI window will then be different when using legacy VFIO
>> assignment and iommufd backend.
> ? They use the same, iommufd can have userspace override it. Then it
> will ignore the reserved region.
In current arm-smmu-v3.c you have
        region = iommu_alloc_resv_region(MSI_IOVA_BASE, MSI_IOVA_LENGTH,
                                         prot, IOMMU_RESV_SW_MSI,
GFP_KERNEL);

in arm_smmu_get_resv_regions()
If you overwrite the default region, don't you need to expose the user
defined resv region?

>
>> MSI reserved regions are exposed in
>> /sys/kernel/iommu_groups/<n>/reserved_regions
>> 0x0000000008000000 0x00000000080fffff msi
>  
>> Is that configurability reflected accordingly?
> ?
>
> Nothing using iommufd should parse that sysfs file.
Right but aren't you still supposed to populate the sysfs files
properly. This region must be carved out from the IOVA space, right?
>  
>> How do you make sure it does not collide with other resv regions? I
>> don't see any check here.
> Yes this does need to be checked, it does look missing. It still needs
> to create a reserved region in the ioas when attaching to keep the
> areas safe and it has to intersect with the incoming reserved
> regions from the driver.
>
>>> + * @IOMMU_OPTION_SW_MSI_START:
>>> + *    Change the base address of the IOMMU mapping region for MSI doorbell(s).
>>> + *    It must be set this before attaching a device to an IOAS/HWPT, otherwise
>>> + *    this option will be not effective on that IOAS/HWPT. User can choose to
>>> + *    let kernel pick a base address, by simply ignoring this option or setting
>>> + *    a value 0 to IOMMU_OPTION_SW_MSI_SIZE. Global option, object_id must be 0
>> I think we should document it cannot be put at a random place either.
> It can be put at any place a map can be placed.
to me It cannot overlap with guest RAM IPA so userspace needs to be
cautious about that

Eric
>
> That also needs to be checked when creating a domain, it can't be
> outside the geometry.
>
> Jason
>


