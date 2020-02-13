Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10DCA15C994
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 18:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgBMRkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 12:40:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37806 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727966AbgBMRkF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Feb 2020 12:40:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581615604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GLZM+36nvBe4D6Zpq/xw18BS+ZIob6yzLP0Z2c3tuXU=;
        b=MtnpP1HBYQDQlOEEjCVJrpmpzqxH0kq6eAsl6xeggCKrfdfH86NXGhC5/xO2WYKg3E2p8B
        rPTpTp6ii8FOkqkWESFHdbqgzRsQp8dWlee7bUw53Zvt2o20HPBSpk9pvTzSkegy4TseuK
        zCxZEmrJg8dTmosHXeBNxhaArutQTIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-QlKTuWg3PB6qDr-rm7hjjw-1; Thu, 13 Feb 2020 12:40:00 -0500
X-MC-Unique: QlKTuWg3PB6qDr-rm7hjjw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FB81190B2A9;
        Thu, 13 Feb 2020 17:39:58 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3473391;
        Thu, 13 Feb 2020 17:39:57 +0000 (UTC)
Date:   Thu, 13 Feb 2020 10:39:57 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com
Subject: Re: [PATCH 4/7] vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first
 user
Message-ID: <20200213103957.0d75034b@w520.home>
In-Reply-To: <20200213134121.54b8debb.cohuck@redhat.com>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
        <158146235133.16827.7215789038918853214.stgit@gimli.home>
        <20200213134121.54b8debb.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Feb 2020 13:41:21 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Tue, 11 Feb 2020 16:05:51 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
> > The VFIO_DEVICE_FEATURE ioctl is meant to be a general purpose, device
> > agnostic ioctl for setting, retrieving, and probing device features.
> > This implementation provides a 16-bit field for specifying a feature
> > index, where the data porition of the ioctl is determined by the
> > semantics for the given feature.  Additional flag bits indicate the
> > direction and nature of the operation; SET indicates user data is
> > provided into the device feature, GET indicates the device feature is
> > written out into user data.  The PROBE flag augments determining
> > whether the given feature is supported, and if provided, whether the
> > given operation on the feature is supported.
> > 
> > The first user of this ioctl is for setting the vfio-pci VF token,
> > where the user provides a shared secret key (UUID) on a SR-IOV PF
> > device, which users must provide when opening associated VF devices.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c |   52 +++++++++++++++++++++++++++++++++++++++++++
> >  include/uapi/linux/vfio.h   |   37 +++++++++++++++++++++++++++++++
> >  2 files changed, 89 insertions(+)  
> 
> (...)
> 
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 9e843a147ead..c5cbf04ce5a7 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -707,6 +707,43 @@ struct vfio_device_ioeventfd {
> >  
> >  #define VFIO_DEVICE_IOEVENTFD		_IO(VFIO_TYPE, VFIO_BASE + 16)
> >  
> > +/**
> > + * VFIO_DEVICE_FEATURE - _IORW(VFIO_TYPE, VFIO_BASE + 17,
> > + *			       struct vfio_device_feature  
> 
> Missing ')'

Fixed.
 
> > + *
> > + * Get, set, or probe feature data of the device.  The feature is selected
> > + * using the FEATURE_MASK portion of the flags field.  Support for a feature
> > + * can be probed by setting both the FEATURE_MASK and PROBE bits.  A probe
> > + * may optionally include the GET and/or SET bits to determine read vs write
> > + * access of the feature respectively.  Probing a feature will return success
> > + * if the feature is supported and all of the optionally indicated GET/SET
> > + * methods are supported.  The format of the data portion of the structure is  
> 
> If neither GET nor SET are specified, will it return success if any of
> the two are supported?

Yes, that's how I've implemented this first feature.

> > + * specific to the given feature.  The data portion is not required for
> > + * probing.
> > + *
> > + * Return 0 on success, -errno on failure.
> > + */
> > +struct vfio_device_feature {
> > +	__u32	argsz;
> > +	__u32	flags;
> > +#define VFIO_DEVICE_FEATURE_MASK	(0xffff) /* 16-bit feature index */
> > +#define VFIO_DEVICE_FEATURE_GET		(1 << 16) /* Get feature into data[] */
> > +#define VFIO_DEVICE_FEATURE_SET		(1 << 17) /* Set feature from data[] */
> > +#define VFIO_DEVICE_FEATURE_PROBE	(1 << 18) /* Probe feature support */
> > +	__u8	data[];
> > +};  
> 
> I'm not sure I'm a fan of cramming both feature selection and operation
> selection into flags. What about:
> 
> struct vfio_device_feature {
> 	__u32 argsz;
> 	__u32 flags;
> /* GET/SET/PROBE #defines */
> 	__u32 feature;
> 	__u8  data[];
> };

Then data is unaligned so we either need to expand feature or add
padding.  So this makes the structure at least 8 bytes bigger and buys
us...?  What's so special about the bottom half of flags that we can't
designate it as the flags that specify the feature?  We still have
another 13 bits of flags for future use.

> Getting/setting more than one feature at the same time does not sound
> like a common use case; you would need to specify some kind of
> algorithm for that anyway, and just doing it individually seems much
> easier than that.

Yup.  I just figured 2^16 features is a nice way to make use of the
structure vs 2^32 features and 4 bytes of padding or 2^64 features.  I
don't think I'm being optimistic in thinking we'll have far less than
16K features and we can always reserve feature 0xffff as an extended
feature where the first 8-bytes of data defines that extended feature
index.

> > +
> > +#define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
> > +
> > +/*
> > + * Provide support for setting a PCI VF Token, which is used as a shared
> > + * secret between PF and VF drivers.  This feature may only be set on a
> > + * PCI SR-IOV PF when SR-IOV is enabled on the PF and there are no existing
> > + * open VFs.  Data provided when setting this feature is a 16-byte array
> > + * (__u8 b[16]), representing a UUID.  
> 
> No objection to that.

:)  Thanks!

Alex

