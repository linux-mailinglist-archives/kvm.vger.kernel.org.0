Return-Path: <kvm+bounces-12991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95D9388FB80
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 10:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A04D29D7F5
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB6C651B7;
	Thu, 28 Mar 2024 09:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E4FL02lb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1A418E1E
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 09:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711618246; cv=none; b=ZiexlLQIdZAUrPJiyePo0VU5MkSYECePSs6+Vmv7UrAxjEpenZ+s9ziN6QyA+z+sbj484/hHrMfgrl2Rz2rc8nBzZRJwxMS5he+ttYk1mWGzro8EakS/O96NFbfTw4gDm7aB6Yxd/j0Oe8b+lmGieiYMf7NY7SQ1LhShAetVxUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711618246; c=relaxed/simple;
	bh=9Z1qs9XTPsGGhlaQLzNAl/p68WoUvCU0AXDQXzgIfgo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ckAQg/Z8pLgIzqcKY7p+CU0veSVTfQIe5PC5ywOW8QEoIX+8GkBVnYhlVPv3qolUai8waEbWPe3MtrkL1mMROCfjARYVM+yuUZumqTcCXJS2KExiweho0h+3/TF1CfvC3vbzvDWv5e/9qDS4M3xyH8PBR4CCKB95R1rXbiraXMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E4FL02lb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711618243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FQWW+mOh8BdxtFe8eYzFiv5O4mZSp01nIMopDnGEp1o=;
	b=E4FL02lbrIdojeWz9AHTJ7JFMalKlyXRpz/e2/3wPqMLSoxxRO7SuEzwiW088eD7zj10Ft
	QKPiys8e4fgHsHnBThn65us0CGNq33QZNrDaBrVkNcMMG1Cd/HTEheKiwVoCcbyo/oPDTm
	QY64sQPcqLsJgx+4EWpr5csNNNftRYA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-MVX2r2wpPlGoxxFl0sIbqQ-1; Thu, 28 Mar 2024 05:30:41 -0400
X-MC-Unique: MVX2r2wpPlGoxxFl0sIbqQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-41481ad9364so5643185e9.0
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 02:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711618240; x=1712223040;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FQWW+mOh8BdxtFe8eYzFiv5O4mZSp01nIMopDnGEp1o=;
        b=hyEsSCkpgWpYbi7tMBGEdRwQle7X6Z6IcgrcvsN9Xkhlc853WVyn1PU0b1WsYGIxYA
         A/61Zwv2ycv14RSNa0klMQ0oxfx3QEFfL7/DHktSXLV77xMrjeeAUOTG6kfoRfOLqw42
         jIxVa1FTNAavxjisFbdUJsc7qYJWqPQbUxFl8Fs69qNvjhthxk+Ybw7kzOFyP+dyZRup
         XEwweibqlmzzyGqLgAI6AtN7+rIwrEefbm9BBBajKBNmOMUzPIu43XfQK3FKuzfENo1Q
         6tlTjoEsAXybFb5D0lyLvjvluiVCBesyH5i7HPPo1HC/kJtF8VEmB0KSvf0peUYmAKAp
         Ddlw==
X-Forwarded-Encrypted: i=1; AJvYcCUqpC25zzSHK3RfxXQb1N5Mw9xt3i9E0EL2crscM8Dbw7JsbwGd88/1dS9hkU4W1TX/rID1Wa1VPdJcEDqG3Kb29SL9
X-Gm-Message-State: AOJu0Yw7qoeHpbPdTYCo5E7KTXHenXXO34Hasb6z4HxTTp4tk7FgS82K
	RbQcIMkFMJDbtDFKxV1jOe2Juwr2FESLEa/wiNEXxZ6EkQbdI5AoYMWbY1MZbSaXh/ZvTkhkziG
	MKQYUZoNDfP/gxllzHjDGrwFsdl/OPNRVNV3xTO3wjlHg/rh7L/6pUqm3CA==
X-Received: by 2002:a05:600c:358f:b0:414:24d:7f9 with SMTP id p15-20020a05600c358f00b00414024d07f9mr2664773wmq.1.1711618239998;
        Thu, 28 Mar 2024 02:30:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpu+DyqKl6BrfNbknLdN+rGX9ya+Or7yIy0/p5SlBuhvdl00XViqNUUgkjmq8A58c7+ptXgA==
X-Received: by 2002:a05:600c:358f:b0:414:24d:7f9 with SMTP id p15-20020a05600c358f00b00414024d07f9mr2664744wmq.1.1711618239610;
        Thu, 28 Mar 2024 02:30:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id f8-20020a05600c4e8800b0041489e97565sm4821139wmq.10.2024.03.28.02.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 02:30:39 -0700 (PDT)
Message-ID: <10a42156-067e-4dc1-8467-b840595b38fa@redhat.com>
Date: Thu, 28 Mar 2024 10:30:37 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] vfio/pci: migration: Skip config space check for
 Vendor Specific Information in VSC during restore/load
To: Alex Williamson <alex.williamson@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>
Cc: Vinayak Kale <vkale@nvidia.com>, qemu-devel@nongnu.org,
 marcel.apfelbaum@gmail.com, avihaih@nvidia.com, acurrid@nvidia.com,
 cjia@nvidia.com, zhiw@nvidia.com, targupta@nvidia.com, kvm@vger.kernel.org
References: <20240322064210.1520394-1-vkale@nvidia.com>
 <20240327113915.19f6256c.alex.williamson@redhat.com>
 <20240327161108-mutt-send-email-mst@kernel.org>
 <20240327145235.47338c2b.alex.williamson@redhat.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
In-Reply-To: <20240327145235.47338c2b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/27/24 21:52, Alex Williamson wrote:
> On Wed, 27 Mar 2024 16:11:37 -0400
> "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
>> On Wed, Mar 27, 2024 at 11:39:15AM -0600, Alex Williamson wrote:
>>> On Fri, 22 Mar 2024 12:12:10 +0530
>>> Vinayak Kale <vkale@nvidia.com> wrote:
>>>    
>>>> In case of migration, during restore operation, qemu checks config space of the
>>>> pci device with the config space in the migration stream captured during save
>>>> operation. In case of config space data mismatch, restore operation is failed.
>>>>
>>>> config space check is done in function get_pci_config_device(). By default VSC
>>>> (vendor-specific-capability) in config space is checked.
>>>>
>>>> Due to qemu's config space check for VSC, live migration is broken across NVIDIA
>>>> vGPU devices in situation where source and destination host driver is different.
>>>> In this situation, Vendor Specific Information in VSC varies on the destination
>>>> to ensure vGPU feature capabilities exposed to the guest driver are compatible
>>>> with destination host.
>>>>
>>>> If a vfio-pci device is migration capable and vfio-pci vendor driver is OK with
>>>> volatile Vendor Specific Info in VSC then qemu should exempt config space check
>>>> for Vendor Specific Info. It is vendor driver's responsibility to ensure that
>>>> VSC is consistent across migration. Here consistency could mean that VSC format
>>>> should be same on source and destination, however actual Vendor Specific Info
>>>> may not be byte-to-byte identical.
>>>>
>>>> This patch skips the check for Vendor Specific Information in VSC for VFIO-PCI
>>>> device by clearing pdev->cmask[] offsets. Config space check is still enforced
>>>> for 3 byte VSC header. If cmask[] is not set for an offset, then qemu skips
>>>> config space check for that offset.
>>>>
>>>> Signed-off-by: Vinayak Kale <vkale@nvidia.com>
>>>> ---
>>>> Version History
>>>> v2->v3:
>>>>      - Config space check skipped only for Vendor Specific Info in VSC, check is
>>>>        still enforced for 3 byte VSC header.
>>>>      - Updated commit description with live migration failure scenario.
>>>> v1->v2:
>>>>      - Limited scope of change to vfio-pci devices instead of all pci devices.
>>>>
>>>>   hw/vfio/pci.c | 24 ++++++++++++++++++++++++
>>>>   1 file changed, 24 insertions(+)
>>>
>>>
>>> Acked-by: Alex Williamson <alex.williamson@redhat.com>
>>
>>
>> A very reasonable way to do it.
>>
>> Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
>>
>> Merge through the VFIO tree I presume?
> 
> Yep, Cédric said he´d grab it for 9.1.  Thanks,


Applied to vfio-next.

Thanks,

C.



