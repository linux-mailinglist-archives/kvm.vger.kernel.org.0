Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 764EF18BE17
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 18:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgCSReB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 13:34:01 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:55062 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727852AbgCSRd5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Mar 2020 13:33:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584639236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IIhtyEtkbfCBYR88/Bx5ref3dIO0us+5XaPzSpXhlrI=;
        b=IpVqoYcAR7GMH0s5s9ZzTmxk7Jo/GjxC4em38W1zEdTXu5JGa3VW7wAUvKtAl/HGOdk5wF
        0FpR1JbO+oLNbWTmK+UhGHb1NIC0WIYWlnepWVywWSltBgAdJdpcQWg6f9fjHvHlQM/NOX
        tUKeVPjtMvKvmc3Ug2zeUNuJUl7/UHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-Vajd_sQFNQqZPI0koncC2A-1; Thu, 19 Mar 2020 13:33:52 -0400
X-MC-Unique: Vajd_sQFNQqZPI0koncC2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37A0E149C0;
        Thu, 19 Mar 2020 17:33:51 +0000 (UTC)
Received: from gondolin (ovpn-113-188.ams2.redhat.com [10.36.113.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 773AF10016EB;
        Thu, 19 Mar 2020 17:33:43 +0000 (UTC)
Date:   Thu, 19 Mar 2020 18:33:41 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com, kevin.tian@intel.com
Subject: Re: [PATCH v3 4/7] vfio: Introduce VFIO_DEVICE_FEATURE ioctl and
 first user
Message-ID: <20200319183341.43ed47ec.cohuck@redhat.com>
In-Reply-To: <158396394121.5601.17199100619127784408.stgit@gimli.home>
References: <158396044753.5601.14804870681174789709.stgit@gimli.home>
        <158396394121.5601.17199100619127784408.stgit@gimli.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Mar 2020 15:59:01 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> The VFIO_DEVICE_FEATURE ioctl is meant to be a general purpose, device
> agnostic ioctl for setting, retrieving, and probing device features.
> This implementation provides a 16-bit field for specifying a feature
> index, where the data porition of the ioctl is determined by the
> semantics for the given feature.  Additional flag bits indicate the
> direction and nature of the operation; SET indicates user data is
> provided into the device feature, GET indicates the device feature is
> written out into user data.  The PROBE flag augments determining
> whether the given feature is supported, and if provided, whether the
> given operation on the feature is supported.
> 
> The first user of this ioctl is for setting the vfio-pci VF token,
> where the user provides a shared secret key (UUID) on a SR-IOV PF
> device, which users must provide when opening associated VF devices.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci.c |   59 +++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h   |   37 +++++++++++++++++++++++++++
>  2 files changed, 96 insertions(+)

(...)

> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 9e843a147ead..aa37f90a2180 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -707,6 +707,43 @@ struct vfio_device_ioeventfd {
>  
>  #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
>  
> +/**
> + * VFIO_DEVICE_FEATURE - _IORW(VFIO_TYPE, VFIO_BASE + 17,
> + *			       struct vfio_device_feature)
> + *
> + * Get, set, or probe feature data of the device.  The feature is selected
> + * using the FEATURE_MASK portion of the flags field.  Support for a feature
> + * can be probed by setting both the FEATURE_MASK and PROBE bits.  A probe
> + * may optionally include the GET and/or SET bits to determine read vs write
> + * access of the feature respectively.  Probing a feature will return success
> + * if the feature is supported and all of the optionally indicated GET/SET
> + * methods are supported.  The format of the data portion of the structure is
> + * specific to the given feature.  The data portion is not required for
> + * probing.

Maybe add

"GET and SET are mutually exclusive, unless PROBE is also specified."

?

> + *
> + * Return 0 on success, -errno on failure.
> + */
> +struct vfio_device_feature {
> +	__u32	argsz;
> +	__u32	flags;
> +#define VFIO_DEVICE_FEATURE_MASK	(0xffff) /* 16-bit feature index */
> +#define VFIO_DEVICE_FEATURE_GET		(1 << 16) /* Get feature into data[] */
> +#define VFIO_DEVICE_FEATURE_SET		(1 << 17) /* Set feature from data[] */
> +#define VFIO_DEVICE_FEATURE_PROBE	(1 << 18) /* Probe feature support */
> +	__u8	data[];
> +};
> +
> +#define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
> +
> +/*
> + * Provide support for setting a PCI VF Token, which is used as a shared
> + * secret between PF and VF drivers.  This feature may only be set on a
> + * PCI SR-IOV PF when SR-IOV is enabled on the PF and there are no existing
> + * open VFs.  Data provided when setting this feature is a 16-byte array
> + * (__u8 b[16]), representing a UUID.
> + */
> +#define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>  
>  /**
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

