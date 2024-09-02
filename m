Return-Path: <kvm+bounces-25687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47FBB968B85
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 18:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0049028384F
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 16:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79ED41A3047;
	Mon,  2 Sep 2024 16:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Guq6UQSp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67791A3024
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 16:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725293014; cv=none; b=rG9F1Eqdq2J+f0y43+mm+p9U9+j+6DfVFjoobwMBJr+Germr679uF44/2yiUwNf8cgWMrAchrnocRmf1R7ZOp7AQVuXU7JU7m/AyKFwnyYw4Ov7UacTImAzpII4kqJPAVtZlwo+DAQ3DffMrthRm/gYq0pThCUAfeKrbCfStQRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725293014; c=relaxed/simple;
	bh=QkCBGS2sXiAPn2JyccF0UCgSeMeG2oRyf6qQZDXkBPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GlFtO/NIhLF5/tss0TUZSbMsv6frg0FthjdzQboZCNGPNI57G6NJraU3Jd8/UsEn8i79sEbiQqPtxVRvq5qtw83bNvlu14iBR+JDybxb16FBtlegc/GgfEK3VvWB2dx45z/L7MptpVUZwk00AlMIKdmN0z2+PQPLO3y5CVqs2x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Guq6UQSp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725293009;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yc/XZqRZkYvpK5BS/4Oz3twFrDBzb7MYtEWJE/on1P4=;
	b=Guq6UQSp8DuMPLGtdIHjZqHby6jGkHu5KVQiT6zvrzEjZhuarI2pPoAilyuX0qoUIDr1Na
	19hmC5YmW43ow0JDQceAvaOV5Yb/VqBYR4xcDcTzAGB6LmtDdGd2aMfoU27h6N4fuQ7HIn
	K1XEzvENB3/SfMFxbhLkSQFejdCovDQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-M_xHlinYP5meWHV8VqTNGw-1; Mon, 02 Sep 2024 12:03:28 -0400
X-MC-Unique: M_xHlinYP5meWHV8VqTNGw-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7a80599c404so659835485a.3
        for <kvm@vger.kernel.org>; Mon, 02 Sep 2024 09:03:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725293008; x=1725897808;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yc/XZqRZkYvpK5BS/4Oz3twFrDBzb7MYtEWJE/on1P4=;
        b=HN2+UY2c76fH3C3Fqa4y/iDq24Chi78uAVIOu4syy/1M0PodWppo4NlrtjeUnn2Y2R
         oHvchTvH2/q7YIpuvutiJTH+NV+3L3zu3Nni3dEs1UrRKducJm1TcrJ26WiR9ZBByls4
         dsRDoVBqZQ1zx7H9gbhRaFfzbE0EdEnYRUBtc1KgxvYPMlrCIgPHWmhniKwgL2+CPozG
         TXSXtIFH5n8T9ZjNUPmRORu7BffwajM33MdrjihDq1+OxHPzmatdPeIsUtCOfl1KQnC6
         1ob88R+BOakPnvkiSAFblAsV9j6OyeEGy70vuGizXvrZF+NBFFRI82pUWaxug1uiNgE9
         WVBQ==
X-Forwarded-Encrypted: i=1; AJvYcCV462miftBnFf5xOgePyDwHxVaoQvhk3Z+4Ah4/GWr8tw161aVN8o5hPx1o9kGdNc6shzg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQYWy/drwOWBjUp2uAgnFIzv78gEx4p2WfF0RurKnsON3d5g70
	RpvmShBdSPAL74MHZy0p44WliPcntqT5BZ1uxWZpMfxO0AuHFhjAcSLWzOH4gdffp5l5KDgD4LP
	Rc1jyrj/uizrJ7I0PHxnDt9tcuoptpVK1aKpJ+W5puu+86mbzLw==
X-Received: by 2002:a05:620a:370d:b0:7a4:dfd6:5fb8 with SMTP id af79cd13be357-7a81d67f978mr1121076685a.23.1725293007896;
        Mon, 02 Sep 2024 09:03:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHM3apCD4sp4+nR7bLQeDK99T/1mpDtwbgEMl+f8Ekn/hxJs+sZSvADILuK047UXSJy/fohsg==
X-Received: by 2002:a05:620a:370d:b0:7a4:dfd6:5fb8 with SMTP id af79cd13be357-7a81d67f978mr1121072785a.23.1725293007445;
        Mon, 02 Sep 2024 09:03:27 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a806c4cb8asm429554685a.67.2024.09.02.09.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Sep 2024 09:03:26 -0700 (PDT)
Message-ID: <60841b43-878a-4467-99a4-12b6e503063c@redhat.com>
Date: Mon, 2 Sep 2024 18:03:23 +0200
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
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20240829172140.686a7aa7.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Alex,

On 8/30/24 01:21, Alex Williamson wrote:
> On Thu, 29 Aug 2024 18:11:07 +0200
> Eric Auger <eric.auger@redhat.com> wrote:
>
>> Some devices may require resources such as clocks and resets
>> which cannot be handled in the vfio_platform agnostic code. Let's
>> add 2 new callbacks to handle those resources. Those new callbacks
>> are optional, as opposed to the reset callback. In case they are
>> implemented, both need to be.
>>
>> They are not implemented by the existing reset modules.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> ---
>>  drivers/vfio/platform/vfio_platform_common.c  | 28 ++++++++++++++++++-
>>  drivers/vfio/platform/vfio_platform_private.h |  6 ++++
>>  2 files changed, 33 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index 3be08e58365b..2174e402dc70 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -228,6 +228,23 @@ static int vfio_platform_call_reset(struct vfio_platform_device *vdev,
>>  	return -EINVAL;
>>  }
>>  
>> +static void vfio_platform_reset_module_close(struct vfio_platform_device *vpdev)
>> +{
>> +	if (VFIO_PLATFORM_IS_ACPI(vpdev))
>> +		return;
>> +	if (vpdev->reset_ops && vpdev->reset_ops->close)
>> +		vpdev->reset_ops->close(vpdev);
>> +}
>> +
>> +static int vfio_platform_reset_module_open(struct vfio_platform_device *vpdev)
>> +{
>> +	if (VFIO_PLATFORM_IS_ACPI(vpdev))
>> +		return 0;
>> +	if (vpdev->reset_ops && vpdev->reset_ops->open)
>> +		return vpdev->reset_ops->open(vpdev);
>> +	return 0;
>> +}
> Hi Eric,
>
> I didn't get why these are no-op'd on an ACPI platform.  Shouldn't it
> be up to the reset ops to decide whether to implement something based
> on the system firmware rather than vfio-platform-common?

In case of ACPI boot, ie. VFIO_PLATFORM_IS_ACPI(vpdev) is set, I
understand we don't use the vfio platform reset module but the ACPI _RST
method. see vfio_platform_acpi_call_reset() and
vfio_platform_acpi_has_reset() introduced by d30daa33ec1d ("vfio:
platform: call _RST method when using ACPI"). I have never had the
opportunity to test acpi boot reset though.
>
>> +
>>  void vfio_platform_close_device(struct vfio_device *core_vdev)
>>  {
>>  	struct vfio_platform_device *vdev =
>> @@ -242,6 +259,7 @@ void vfio_platform_close_device(struct vfio_device *core_vdev)
>>  			"reset driver is required and reset call failed in release (%d) %s\n",
>>  			ret, extra_dbg ? extra_dbg : "");
>>  	}
>> +	vfio_platform_reset_module_close(vdev);
>>  	pm_runtime_put(vdev->device);
>>  	vfio_platform_regions_cleanup(vdev);
>>  	vfio_platform_irq_cleanup(vdev);
>> @@ -265,7 +283,13 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>>  
>>  	ret = pm_runtime_get_sync(vdev->device);
>>  	if (ret < 0)
>> -		goto err_rst;
>> +		goto err_rst_open;
>> +
>> +	ret = vfio_platform_reset_module_open(vdev);
>> +	if (ret) {
>> +		dev_info(vdev->device, "reset module load failed (%d)\n", ret);
>> +		goto err_rst_open;
>> +	}
>>  
>>  	ret = vfio_platform_call_reset(vdev, &extra_dbg);
>>  	if (ret && vdev->reset_required) {
>> @@ -278,6 +302,8 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
>>  	return 0;
>>  
>>  err_rst:
>> +	vfio_platform_reset_module_close(vdev);
>> +err_rst_open:
>>  	pm_runtime_put(vdev->device);
>>  	vfio_platform_irq_cleanup(vdev);
>>  err_irq:
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 90c99d2e70f4..528b01c56de6 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -74,9 +74,13 @@ struct vfio_platform_device {
>>   * struct vfio_platform_reset_ops - reset ops
>>   *
>>   * @reset:	reset function (required)
>> + * @open:	Called when the first fd is opened for this device (optional)
>> + * @close:	Called when the last fd is closed for this device (optional)
> This doesn't note any platform firmware dependency.  We should probably
> also note here the XOR requirement enforced below here.  Thanks,
To me this is just used along with dt boot, hence the lack of check.

Thanks

Eric
>
> Alex
>
>>   */
>>  struct vfio_platform_reset_ops {
>>  	int (*reset)(struct vfio_platform_device *vdev);
>> +	int (*open)(struct vfio_platform_device *vdev);
>> +	void (*close)(struct vfio_platform_device *vdev);
>>  };
>>  
>>  
>> @@ -129,6 +133,8 @@ __vfio_platform_register_reset(&__ops ## _node)
>>  MODULE_ALIAS("vfio-reset:" compat);				\
>>  static int __init reset ## _module_init(void)			\
>>  {								\
>> +	if (!!ops.open ^ !!ops.close)				\
>> +		return -EINVAL;					\
>>  	vfio_platform_register_reset(compat, ops);		\
>>  	return 0;						\
>>  };								\


