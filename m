Return-Path: <kvm+bounces-26504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCEF89751C9
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 14:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 910DB28702F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 12:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB8D18C03E;
	Wed, 11 Sep 2024 12:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EBZaf0Nw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7332E187848
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726057131; cv=none; b=h5utQRBLaPSHR5FAZ5Rnfs4zn5+i9sA5BwpMD967UohV71wJyEHenRaA4AUDfFsbj4GFeI54nBMEZR+H9CL/B0dvnwmT85nZufEX6z0TPqXXK+u2ghLi7UzCdBKpqjlxK9T84WNGaK31K96Ha6ia07TIWE6heEEx9ESmqg0nxpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726057131; c=relaxed/simple;
	bh=cWl4hvgSo6boo2KLEhVb9/A+8gatbKWTDXmnRWR4lJQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VtONwL3/I/gnsXJK10bUCG806fT+1I/e4j7EtUE6E4FcO0MojvhE+IfeDropY+Ka2DrSU+P7lp9K2Li/PC//mQ33SR52uagmf7VGphjBXWsbDoYFONqjZXLdaiost0TNdslK/dvl8qod1+F1C9mNi4WrRjsJUHuT/ZNOYml//NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EBZaf0Nw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726057128;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Zt5DDXfrTzQFL+z4Cg2KYJzUOEOMi+DBdhvZemKwIY=;
	b=EBZaf0NwfVm4DeAiFzb6M36pZd7wPfnaLCDOgqeHy2ScHK6vel4JEbGyvqeAtcBAmbHXw7
	Wn0A153eKxEtdA2/IXG2vKIV3L4pKKnt5DwLe2h8CBTBX1w1sFiT2gGZlfw1hIW2QhVgk0
	D16VIItakgX1yix3D2jtAPOZeNgJnsk=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-75-PXhG86BeO2qolZ-X9DNY3Q-1; Wed, 11 Sep 2024 08:18:47 -0400
X-MC-Unique: PXhG86BeO2qolZ-X9DNY3Q-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7a9b1216a68so826547685a.2
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 05:18:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726057127; x=1726661927;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Zt5DDXfrTzQFL+z4Cg2KYJzUOEOMi+DBdhvZemKwIY=;
        b=tek5jBCF3S3cQ2hRFG6AXQN/I7Yh1uSt8/53iHOGqBASgoPEAMRtIapUhJiC9OoJcd
         BALBQ41Js8lCPtczio2g/hLGd+zhP1ZAdloMXPWqEMly0NKlsf1/8YXgdqVxN9u5bTSp
         LHN9cqggMpA4nQw1/sw91OnU/YqV9vYf8zuAPOg8qAmMiAHsPf7itumQqLUsBT5JppyO
         inKwmy3A7FVoPm+Hu5RIwsFBcxDXTszz6YJVW3yQ7F3Cv7QYNlW0MXpTJsfBqxzpKt4H
         21SAID+gqib0/FYrvqwOm0p2kLvplOxFy3MXeRZlu/opULWCmfaEKPxI05Bex5IsPqZ3
         p9QA==
X-Forwarded-Encrypted: i=1; AJvYcCU2tvtkGzAITJShG18PmRe5ce570dUHyYyCyTAxKwwdu7rjneMiMILRVof4+c8ledT/VtU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6Tgz9csn1DTzcXSQI0wGMaLb/ifbaZxI1ENMuB5alLIEv+AAY
	G3A3xo9g1Bhq/FCoP6XkhLjfsdGyJ+3I1ShjDU9MLoex6B40vL7tcVSQ6JSGjX6+9+60dvwdUPd
	/YHTKFsDw41udfB//mmLPHJ1Q/9gkhBEdxnUREnoCbOXnerd0wA==
X-Received: by 2002:a05:620a:414c:b0:7a7:deb7:6d9a with SMTP id af79cd13be357-7a997322383mr2499099685a.11.1726057126683;
        Wed, 11 Sep 2024 05:18:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1WRoZe+DYRkXS9zx02gwScQ97Yuz8WeNJpuMZ7SdObTDobtCB5+U2e+ZG8bXV42o4rG2ziA==
X-Received: by 2002:a05:620a:414c:b0:7a7:deb7:6d9a with SMTP id af79cd13be357-7a997322383mr2499095585a.11.1726057126222;
        Wed, 11 Sep 2024 05:18:46 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7946afbsm415249785a.3.2024.09.11.05.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 05:18:45 -0700 (PDT)
Message-ID: <3e7824f9-4934-49a7-a0e7-531dae4e57ee@redhat.com>
Date: Wed, 11 Sep 2024 14:18:42 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC PATCH 3/5] vfio_platform: reset: Introduce new open and
 close callbacks
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger.pro@gmail.com, treding@nvidia.com, vbhadram@nvidia.com,
 jonathanh@nvidia.com, mperttunen@nvidia.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, clg@redhat.com, alexandre.torgue@foss.st.com,
 joabreu@synopsys.com, msalter@redhat.com
References: <20240829161302.607928-1-eric.auger@redhat.com>
 <20240829161302.607928-4-eric.auger@redhat.com>
 <20240829172140.686a7aa7.alex.williamson@redhat.com>
 <60841b43-878a-4467-99a4-12b6e503063c@redhat.com>
 <20240904134028.796b2670.alex.williamson@redhat.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240904134028.796b2670.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alex,

On 9/4/24 21:40, Alex Williamson wrote:
> On Mon, 2 Sep 2024 18:03:23 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
>
>> Hi Alex,
>>
>> On 8/30/24 01:21, Alex Williamson wrote:
>>> On Thu, 29 Aug 2024 18:11:07 +0200
>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>  
>>>> Some devices may require resources such as clocks and resets
>>>> which cannot be handled in the vfio_platform agnostic code. Let's
>>>> add 2 new callbacks to handle those resources. Those new callbacks
>>>> are optional, as opposed to the reset callback. In case they are
>>>> implemented, both need to be.
>>>>
>>>> They are not implemented by the existing reset modules.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> ---
>>>>  drivers/vfio/platform/vfio_platform_common.c  | 28 ++++++++++++++++++-
>>>>  drivers/vfio/platform/vfio_platform_private.h |  6 ++++
>>>>  2 files changed, 33 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>>>> index 3be08e58365b..2174e402dc70 100644
>>>> --- a/drivers/vfio/platform/vfio_platform_common.c
>>>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>>>> @@ -228,6 +228,23 @@ static int vfio_platform_call_reset(struct vfio_platform_device *vdev,
>>>>  	return -EINVAL;
>>>>  }
>>>>  
>>>> +static void vfio_platform_reset_module_close(struct vfio_platform_device *vpdev)
>>>> +{
>>>> +	if (VFIO_PLATFORM_IS_ACPI(vpdev))
>>>> +		return;
>>>> +	if (vpdev->reset_ops && vpdev->reset_ops->close)
>>>> +		vpdev->reset_ops->close(vpdev);
>>>> +}
>>>> +
>>>> +static int vfio_platform_reset_module_open(struct vfio_platform_device *vpdev)
>>>> +{
>>>> +	if (VFIO_PLATFORM_IS_ACPI(vpdev))
>>>> +		return 0;
>>>> +	if (vpdev->reset_ops && vpdev->reset_ops->open)
>>>> +		return vpdev->reset_ops->open(vpdev);
>>>> +	return 0;
>>>> +}  
>>> Hi Eric,
>>>
>>> I didn't get why these are no-op'd on an ACPI platform.  Shouldn't it
>>> be up to the reset ops to decide whether to implement something based
>>> on the system firmware rather than vfio-platform-common?  
>> In case of ACPI boot, ie. VFIO_PLATFORM_IS_ACPI(vpdev) is set, I
>> understand we don't use the vfio platform reset module but the ACPI _RST
>> method. see vfio_platform_acpi_call_reset() and
>> vfio_platform_acpi_has_reset() introduced by d30daa33ec1d ("vfio:
>> platform: call _RST method when using ACPI"). I have never had the
>> opportunity to test acpi boot reset though.
> Aha, I was expecting that VFIO_PLATFORM_IS_ACPI() wouldn't exclusively
> require _RST support, but indeed in various places we only look for the
> acpihid for the device without also checking for a _RST method.  In
> fact commit 7aef80cf3187 ("vfio: platform: rename reset function")
> prefixed the reset function pointer with "of_" to try to make that
> exclusion more clear, but the previous patch of this series introducing
> the ops structure chose a more generic name.  Should we instead use
> "of_reset_ops" to maintain that we have two distinct paths, ACPI vs DT?
Yes I will rename with of_ prefix.
>
> TBH I'm not sure why we couldn't check that an acpihid also supports a
> _RST method and continue to look for reset module support otherwise,
> but that's not the way it's coded and there's apparently no demand for
> it.
I agree. Without explicit request I am reluctant to change that because
I can't test atm
>
>>>> +
>>>>  void vfio_platform_close_device(struct vfio_device *core_vdev)
>>>>  {
>>>>  	struct vfio_platform_device *vdev =
>>>> @@ -242,6 +259,7 @@ void vfio_platform_close_device(struct vfio_device *core_vdev)
>>>>  			"reset driver is required and reset call failed in release (%d) %s\n",
>>>>  			ret, extra_dbg ? extra_dbg : "");
>>>>  	}
>>>> +	vfio_platform_reset_module_close(vdev);
>>>>  	pm_runtime_put(vdev->device);
>>>>  	vfio_platform_regions_cleanup(vdev);
>>>>  	vfio_platform_irq_cleanup(vdev);
>>>> @@ -265,7 +283,13 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>>>>  
>>>>  	ret = pm_runtime_get_sync(vdev->device);
>>>>  	if (ret < 0)
>>>> -		goto err_rst;
>>>> +		goto err_rst_open;
>>>> +
>>>> +	ret = vfio_platform_reset_module_open(vdev);
>>>> +	if (ret) {
>>>> +		dev_info(vdev->device, "reset module load failed (%d)\n", ret);
>>>> +		goto err_rst_open;
>>>> +	}
>>>>  
>>>>  	ret = vfio_platform_call_reset(vdev, &extra_dbg);
>>>>  	if (ret && vdev->reset_required) {
>>>> @@ -278,6 +302,8 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>>>>  	return 0;
>>>>  
>>>>  err_rst:
>>>> +	vfio_platform_reset_module_close(vdev);
>>>> +err_rst_open:
>>>>  	pm_runtime_put(vdev->device);
>>>>  	vfio_platform_irq_cleanup(vdev);
>>>>  err_irq:
>>>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>>>> index 90c99d2e70f4..528b01c56de6 100644
>>>> --- a/drivers/vfio/platform/vfio_platform_private.h
>>>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>>>> @@ -74,9 +74,13 @@ struct vfio_platform_device {
>>>>   * struct vfio_platform_reset_ops - reset ops
>>>>   *
>>>>   * @reset:	reset function (required)
>>>> + * @open:	Called when the first fd is opened for this device (optional)
>>>> + * @close:	Called when the last fd is closed for this device (optional)  
>>> This doesn't note any platform firmware dependency.  We should probably
>>> also note here the XOR requirement enforced below here.  Thanks,  
>> To me this is just used along with dt boot, hence the lack of check.
> Per the above comment, I'd just specify the whole struct as a DT reset
> ops interface and sprinkle "_of_" into the name to make that more
> obvious.  Thanks,

agreed

Thanks

Eric
>
> Alex
>
>>>>   */
>>>>  struct vfio_platform_reset_ops {
>>>>  	int (*reset)(struct vfio_platform_device *vdev);
>>>> +	int (*open)(struct vfio_platform_device *vdev);
>>>> +	void (*close)(struct vfio_platform_device *vdev);
>>>>  };
>>>>  
>>>>  
>>>> @@ -129,6 +133,8 @@ __vfio_platform_register_reset(&__ops ## _node)
>>>>  MODULE_ALIAS("vfio-reset:" compat);				\
>>>>  static int __init reset ## _module_init(void)			\
>>>>  {								\
>>>> +	if (!!ops.open ^ !!ops.close)				\
>>>> +		return -EINVAL;					\
>>>>  	vfio_platform_register_reset(compat, ops);		\
>>>>  	return 0;						\
>>>>  };								\  


