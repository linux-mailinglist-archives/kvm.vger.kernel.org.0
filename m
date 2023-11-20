Return-Path: <kvm+bounces-2132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC7C7F1ACC
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 18:39:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 687A7282056
	for <lists+kvm@lfdr.de>; Mon, 20 Nov 2023 17:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE9D224F9;
	Mon, 20 Nov 2023 17:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ThltMWVn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CDC171F
	for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 09:38:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700501932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EA+PtELgafBL4lMg/ITaiAmG0etiKFjvCQCjeW2B3vQ=;
	b=ThltMWVnJ68SB1SUL0BDLl09RFeQqonRLuu6A5oOtlZRGdeE9wiFe6tW94Nt/oBSVvIf74
	WDue7BL1QhBLm2fgWvLLCcZCdw2+bHUrTzrUFw0Vz7IL4jWI1+IJRMeqeRcdFdjaP0639u
	mzrkRkVQvupRfgMxxyuQdw67ad2b2YU=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-V1TU2MlINHyStosF-i3ZkA-1; Mon, 20 Nov 2023 12:38:50 -0500
X-MC-Unique: V1TU2MlINHyStosF-i3ZkA-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-7a668ae1d18so514220639f.1
        for <kvm@vger.kernel.org>; Mon, 20 Nov 2023 09:38:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700501930; x=1701106730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EA+PtELgafBL4lMg/ITaiAmG0etiKFjvCQCjeW2B3vQ=;
        b=WXRJ4KU4uQebuFAtlL1v7cv2oygJRQsnpEHHxo+TjkDQuHVXdLcKYbByKRtgQlat3a
         Nsyop4tfYwDhaU4Af3Rt+7xS4gTOdkbpsd0hMOCAX/I5txJ27DU7kwIFxDe2G+MZH4Ih
         ktArgdhTx69DPJR2jtDQzCrIJRv4LaJ1EUmeq3qrDSrnSEUFfeeTc5TJn3zbdg8GUCIY
         KyP6+egTCQKbqUKad+Y9M6B6S7fMcfkjswI9C5OCb/9ze1/i8ut4CleOAcDZva3Schg/
         jgGXCbjR/SWnyFobmH1sJSD95iV+4hJ33k6ciM+26JiiRZvLADgOoQtUwgm1+SYjKrmC
         05ow==
X-Gm-Message-State: AOJu0YwsMD+5ZIJCwHMxxxHLL7xPVP4otc59cSoBzSzcyyS0tgHOgl1w
	wBmHocpSAVsIxDoLUcBMYfQG/50B6WwugP1GQR59wcjPQgG8mmX31UCwLOECJr5fqx/ewoux6b1
	vnmmKOZ1NWOet
X-Received: by 2002:a05:6602:b0b:b0:795:183b:1e3 with SMTP id fl11-20020a0566020b0b00b00795183b01e3mr3093008iob.6.1700501930223;
        Mon, 20 Nov 2023 09:38:50 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHHT3qhfz3/6ZznnTsb8wnrznUIvtVKE6389r6+Eh6UTrnGUjcgYOv9oE6khUuQ9hoe4DhC0w==
X-Received: by 2002:a05:6602:b0b:b0:795:183b:1e3 with SMTP id fl11-20020a0566020b0b00b00795183b01e3mr3092992iob.6.1700501929955;
        Mon, 20 Nov 2023 09:38:49 -0800 (PST)
Received: from redhat.com ([38.15.60.12])
        by smtp.gmail.com with ESMTPSA id y22-20020a5d94d6000000b00790b6b9d14bsm2329827ior.49.2023.11.20.09.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 09:38:49 -0800 (PST)
Date: Mon, 20 Nov 2023 10:38:48 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: JianChunfu <chunfu.jian@shingroup.cn>
Cc: cohuck@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 shenghui.qu@shingroup.cn
Subject: Re: [PATCH] vfio/pci: Separate INTx-enabled vfio_pci_device from
 unenabled to make the code logic clearer.
Message-ID: <20231120103848.337b6833.alex.williamson@redhat.com>
In-Reply-To: <20231120031752.522139-1-chunfu.jian@shingroup.cn>
References: <20231120031752.522139-1-chunfu.jian@shingroup.cn>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Nov 2023 11:17:52 +0800
JianChunfu <chunfu.jian@shingroup.cn> wrote:

> It seems a little unclear when dealing with vfio_intx_set_signal()
> because of vfio_pci_device which is irq_none,
> so separate the two situations.
> 
> Signed-off-by: JianChunfu <chunfu.jian@shingroup.cn>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
> index 6069a11fb51a..b6d126c48393 100644
> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -468,6 +468,8 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  				     unsigned index, unsigned start,
>  				     unsigned count, uint32_t flags, void *data)
>  {
> +	int32_t fd = *(int32_t *)data;

This is a null pointer dereference if anyone were to use
VFIO_IRQ_SET_DATA_NONE.  Note this is also invalid for
VFIO_IRQ_SET_DATA_BOOL.  I think this is largely why the function has
the current layout.

> +
>  	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
>  		vfio_intx_disable(vdev);
>  		return 0;
> @@ -476,28 +478,25 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>  	if (!(is_intx(vdev) || is_irq_none(vdev)) || start != 0 || count != 1)
>  		return -EINVAL;
>  
> -	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> -		int32_t fd = *(int32_t *)data;
> +	if (!is_intx(vdev)) {
>  		int ret;
> +		if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {

@ret should be scoped within this branch with this layout and there
should be a blank line after variable declaration.

> +			ret = vfio_intx_enable(vdev);
> +			if (ret)
> +				return ret;
>  
> -		if (is_intx(vdev))
> -			return vfio_intx_set_signal(vdev, fd);
> +			ret = vfio_intx_set_signal(vdev, fd);
> +			if (ret)
> +				vfio_intx_disable(vdev);
>  
> -		ret = vfio_intx_enable(vdev);
> -		if (ret)
>  			return ret;
> -
> -		ret = vfio_intx_set_signal(vdev, fd);
> -		if (ret)
> -			vfio_intx_disable(vdev);
> -
> -		return ret;
> +		} else
> +			return -EINVAL;

Single line branches also get braces if the previous branch required
braces.  Thanks,

Alex

>  	}
>  
> -	if (!is_intx(vdev))
> -		return -EINVAL;
> -
> -	if (flags & VFIO_IRQ_SET_DATA_NONE) {
> +	if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
> +		return vfio_intx_set_signal(vdev, fd);
> +	} else if (flags & VFIO_IRQ_SET_DATA_NONE) {
>  		vfio_send_intx_eventfd(vdev, NULL);
>  	} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
>  		uint8_t trigger = *(uint8_t *)data;


