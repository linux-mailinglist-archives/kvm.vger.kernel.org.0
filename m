Return-Path: <kvm+bounces-25903-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DAA96C7B5
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 21:41:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B84B1C25171
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 19:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6F621E7672;
	Wed,  4 Sep 2024 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A75cg0sa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037481E764F
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 19:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725478836; cv=none; b=ozRPd1yCRPCbDd32Lhrw7I7kLW2614YtIU47troy/RbrEBNNRD1H0S+idpPKjb6DK8TXogr6wlzvKA4asUVVFoaUSTLlR8xSLBEAcIUR5lxGJukCstk+bo3T3ImgSew59CP5K50PrgCe2r5ceH6xSxmExihRMseb+hcyVhx4JWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725478836; c=relaxed/simple;
	bh=Fk53gPQvgVQIFSLCm4xJJJE5cIkbACatIsWQP4OYOpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQoyvfVK1ni+3UjIvQBVwQxvj6Yk6FNwbCvKJ1DQIhVEOY9ypPNiTxsiCHBMl6akbfHz+rQA2lZHze4H9RIJwuAEIBa3EEnM0gv3dSdnK9EnRBWOk8V/On1dgY4bBdej1NrxLIbS4ncGmSES+TlHSIBpfU3wXjTw0X3HLaO8ww8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A75cg0sa; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725478834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hLwsZcpOTdWORq3NHEPNQ7b2Jve9flGiI+UyLFhibvs=;
	b=A75cg0saGMyMuShsZpX3Bb7sfZbUOCSszNxv5Hq6rELQ0d7ko3a5iL6Y8+zGLV8XnocO5R
	B2wNVrEeMQfLbHH6dnyP7Lmg5sZPgFBlR8L5YDmzFViD6RHzcQg1vMnQjMQOExfFIh1NdY
	a1HEB1l9XGlP/ZAcyY56+cgKkLxUSew=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-QbJzrSPGPG-wB0bVdt8vtA-1; Wed, 04 Sep 2024 15:40:33 -0400
X-MC-Unique: QbJzrSPGPG-wB0bVdt8vtA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8222bad34e9so142993539f.0
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 12:40:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725478832; x=1726083632;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hLwsZcpOTdWORq3NHEPNQ7b2Jve9flGiI+UyLFhibvs=;
        b=qDJ7Hph+JPNH7TA23hLVRWhZm4zQ2Kqw7TiSIy28YRGYpxR87Nhk0sBOjIQRUZUdRF
         RXpL2oBM93raUTe97x7xzTewVZXP+bpNDUJ5xorHW3FcMny+F9LKKdMiewhqT5Mw7gg0
         5W2YlZVFsFp4uf3MnvO6Otkyml0SVYn+Z1xNUrNZ+c0nCDZbd5b01GNv1UETt7lECcOn
         3sMAMelTLBjfOOrk8lwazdWNP5n5P3AE2kqc5WQpt2A9TYnsJcnqAbnN5oDtGuVn4jsA
         tohqc0MiagayrtM/4n2ctMGjiMnY+sqsaBSznrWjku4vbJEk9ga5P5EryT5tH7taD7eQ
         xrgQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvgv0Y3c3WeTr53+Y8+8rxncLQF6kv+ucB8NWRQwdp6ZJ+7zJdCsCsObuOA/TR/hP58gw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMYx2PwSxOMxTmweJxSNDjfwMsxfiMsQuC8lNQx+Rdq9qR3IA2
	UX8tx9JA6P8OX43wy7Td+LQdDDhHDDmD0JopfyZAL02YK6QYtBIvgsWRll4oASPhhGDQIrXCe+B
	XxxWchndMzYNQyQLhGQnsbqYcEAffkHwdcIq9WnFAZ3i6A1MidN0P6DIVcQ==
X-Received: by 2002:a6b:db0a:0:b0:80a:9c66:3842 with SMTP id ca18e2360f4ac-82a262dcc94mr1148969439f.3.1725478832152;
        Wed, 04 Sep 2024 12:40:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqeePWUUXEKuIVJXWvfFpfgvAULwqemwYPtg9DlL8GY2cFsyHNg/zSv6eyEmYPzXtWnaZCVw==
X-Received: by 2002:a6b:db0a:0:b0:80a:9c66:3842 with SMTP id ca18e2360f4ac-82a262dcc94mr1148967839f.3.1725478831702;
        Wed, 04 Sep 2024 12:40:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ced2ee8559sm3239846173.174.2024.09.04.12.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 12:40:31 -0700 (PDT)
Date: Wed, 4 Sep 2024 13:40:28 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, treding@nvidia.com, vbhadram@nvidia.com,
 jonathanh@nvidia.com, mperttunen@nvidia.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, clg@redhat.com, alexandre.torgue@foss.st.com,
 joabreu@synopsys.com, msalter@redhat.com
Subject: Re: [RFC PATCH 3/5] vfio_platform: reset: Introduce new open and
 close callbacks
Message-ID: <20240904134028.796b2670.alex.williamson@redhat.com>
In-Reply-To: <60841b43-878a-4467-99a4-12b6e503063c@redhat.com>
References: <20240829161302.607928-1-eric.auger@redhat.com>
	<20240829161302.607928-4-eric.auger@redhat.com>
	<20240829172140.686a7aa7.alex.williamson@redhat.com>
	<60841b43-878a-4467-99a4-12b6e503063c@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Sep 2024 18:03:23 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> Hi Alex,
> 
> On 8/30/24 01:21, Alex Williamson wrote:
> > On Thu, 29 Aug 2024 18:11:07 +0200
> > Eric Auger <eric.auger@redhat.com> wrote:
> >  
> >> Some devices may require resources such as clocks and resets
> >> which cannot be handled in the vfio_platform agnostic code. Let's
> >> add 2 new callbacks to handle those resources. Those new callbacks
> >> are optional, as opposed to the reset callback. In case they are
> >> implemented, both need to be.
> >>
> >> They are not implemented by the existing reset modules.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> ---
> >>  drivers/vfio/platform/vfio_platform_common.c  | 28 ++++++++++++++++++-
> >>  drivers/vfio/platform/vfio_platform_private.h |  6 ++++
> >>  2 files changed, 33 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> >> index 3be08e58365b..2174e402dc70 100644
> >> --- a/drivers/vfio/platform/vfio_platform_common.c
> >> +++ b/drivers/vfio/platform/vfio_platform_common.c
> >> @@ -228,6 +228,23 @@ static int vfio_platform_call_reset(struct vfio_platform_device *vdev,
> >>  	return -EINVAL;
> >>  }
> >>  
> >> +static void vfio_platform_reset_module_close(struct vfio_platform_device *vpdev)
> >> +{
> >> +	if (VFIO_PLATFORM_IS_ACPI(vpdev))
> >> +		return;
> >> +	if (vpdev->reset_ops && vpdev->reset_ops->close)
> >> +		vpdev->reset_ops->close(vpdev);
> >> +}
> >> +
> >> +static int vfio_platform_reset_module_open(struct vfio_platform_device *vpdev)
> >> +{
> >> +	if (VFIO_PLATFORM_IS_ACPI(vpdev))
> >> +		return 0;
> >> +	if (vpdev->reset_ops && vpdev->reset_ops->open)
> >> +		return vpdev->reset_ops->open(vpdev);
> >> +	return 0;
> >> +}  
> > Hi Eric,
> >
> > I didn't get why these are no-op'd on an ACPI platform.  Shouldn't it
> > be up to the reset ops to decide whether to implement something based
> > on the system firmware rather than vfio-platform-common?  
> 
> In case of ACPI boot, ie. VFIO_PLATFORM_IS_ACPI(vpdev) is set, I
> understand we don't use the vfio platform reset module but the ACPI _RST
> method. see vfio_platform_acpi_call_reset() and
> vfio_platform_acpi_has_reset() introduced by d30daa33ec1d ("vfio:
> platform: call _RST method when using ACPI"). I have never had the
> opportunity to test acpi boot reset though.

Aha, I was expecting that VFIO_PLATFORM_IS_ACPI() wouldn't exclusively
require _RST support, but indeed in various places we only look for the
acpihid for the device without also checking for a _RST method.  In
fact commit 7aef80cf3187 ("vfio: platform: rename reset function")
prefixed the reset function pointer with "of_" to try to make that
exclusion more clear, but the previous patch of this series introducing
the ops structure chose a more generic name.  Should we instead use
"of_reset_ops" to maintain that we have two distinct paths, ACPI vs DT?

TBH I'm not sure why we couldn't check that an acpihid also supports a
_RST method and continue to look for reset module support otherwise,
but that's not the way it's coded and there's apparently no demand for
it.

> >> +
> >>  void vfio_platform_close_device(struct vfio_device *core_vdev)
> >>  {
> >>  	struct vfio_platform_device *vdev =
> >> @@ -242,6 +259,7 @@ void vfio_platform_close_device(struct vfio_device *core_vdev)
> >>  			"reset driver is required and reset call failed in release (%d) %s\n",
> >>  			ret, extra_dbg ? extra_dbg : "");
> >>  	}
> >> +	vfio_platform_reset_module_close(vdev);
> >>  	pm_runtime_put(vdev->device);
> >>  	vfio_platform_regions_cleanup(vdev);
> >>  	vfio_platform_irq_cleanup(vdev);
> >> @@ -265,7 +283,13 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
> >>  
> >>  	ret = pm_runtime_get_sync(vdev->device);
> >>  	if (ret < 0)
> >> -		goto err_rst;
> >> +		goto err_rst_open;
> >> +
> >> +	ret = vfio_platform_reset_module_open(vdev);
> >> +	if (ret) {
> >> +		dev_info(vdev->device, "reset module load failed (%d)\n", ret);
> >> +		goto err_rst_open;
> >> +	}
> >>  
> >>  	ret = vfio_platform_call_reset(vdev, &extra_dbg);
> >>  	if (ret && vdev->reset_required) {
> >> @@ -278,6 +302,8 @@ int vfio_platform_open_device(struct vfio_device *core_vdev)
> >>  	return 0;
> >>  
> >>  err_rst:
> >> +	vfio_platform_reset_module_close(vdev);
> >> +err_rst_open:
> >>  	pm_runtime_put(vdev->device);
> >>  	vfio_platform_irq_cleanup(vdev);
> >>  err_irq:
> >> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> >> index 90c99d2e70f4..528b01c56de6 100644
> >> --- a/drivers/vfio/platform/vfio_platform_private.h
> >> +++ b/drivers/vfio/platform/vfio_platform_private.h
> >> @@ -74,9 +74,13 @@ struct vfio_platform_device {
> >>   * struct vfio_platform_reset_ops - reset ops
> >>   *
> >>   * @reset:	reset function (required)
> >> + * @open:	Called when the first fd is opened for this device (optional)
> >> + * @close:	Called when the last fd is closed for this device (optional)  
> > This doesn't note any platform firmware dependency.  We should probably
> > also note here the XOR requirement enforced below here.  Thanks,  
> To me this is just used along with dt boot, hence the lack of check.

Per the above comment, I'd just specify the whole struct as a DT reset
ops interface and sprinkle "_of_" into the name to make that more
obvious.  Thanks,

Alex

> >>   */
> >>  struct vfio_platform_reset_ops {
> >>  	int (*reset)(struct vfio_platform_device *vdev);
> >> +	int (*open)(struct vfio_platform_device *vdev);
> >> +	void (*close)(struct vfio_platform_device *vdev);
> >>  };
> >>  
> >>  
> >> @@ -129,6 +133,8 @@ __vfio_platform_register_reset(&__ops ## _node)
> >>  MODULE_ALIAS("vfio-reset:" compat);				\
> >>  static int __init reset ## _module_init(void)			\
> >>  {								\
> >> +	if (!!ops.open ^ !!ops.close)				\
> >> +		return -EINVAL;					\
> >>  	vfio_platform_register_reset(compat, ops);		\
> >>  	return 0;						\
> >>  };								\  
> 


