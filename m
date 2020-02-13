Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C57B15C9F9
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 19:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727707AbgBMSI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 13:08:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28815 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727608AbgBMSI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 13:08:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581617305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=deHttPInqFs6xYAV0uYMAcNgDa9/Kd+C12ssa7guPmc=;
        b=AVDeWbsgsxiMA6Au4vxlvEpfXcxDgNnRiYttHE1ra50tLdYcyoV0XwRFprDpzhxEkTSA9/
        WNQrOVQn4zka0Qx1Pm2tFiExmczqGTZGPEeb2j95WtBRZeMbo+Z9AE6CJaEKiMX0PogwEQ
        Vqd9yKvdh9LaQo1SXqBnJwN8OUfQWcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-iTjufJ3TOB2pFQOEgpdEsg-1; Thu, 13 Feb 2020 13:08:23 -0500
X-MC-Unique: iTjufJ3TOB2pFQOEgpdEsg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AA217A583;
        Thu, 13 Feb 2020 18:08:21 +0000 (UTC)
Received: from gondolin (ovpn-117-100.ams2.redhat.com [10.36.117.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DF891000325;
        Thu, 13 Feb 2020 18:08:16 +0000 (UTC)
Date:   Thu, 13 Feb 2020 19:08:13 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, dev@dpdk.org, mtosatti@redhat.com,
        thomas@monjalon.net, bluca@debian.org, jerinjacobk@gmail.com,
        bruce.richardson@intel.com
Subject: Re: [PATCH 4/7] vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first
 user
Message-ID: <20200213190813.1bcd1a15.cohuck@redhat.com>
In-Reply-To: <20200213103957.0d75034b@w520.home>
References: <158145472604.16827.15751375540102298130.stgit@gimli.home>
        <158146235133.16827.7215789038918853214.stgit@gimli.home>
        <20200213134121.54b8debb.cohuck@redhat.com>
        <20200213103957.0d75034b@w520.home>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Feb 2020 10:39:57 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> On Thu, 13 Feb 2020 13:41:21 +0100
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
> > On Tue, 11 Feb 2020 16:05:51 -0700
> > Alex Williamson <alex.williamson@redhat.com> wrote:

> > > +struct vfio_device_feature {
> > > +	__u32	argsz;
> > > +	__u32	flags;
> > > +#define VFIO_DEVICE_FEATURE_MASK	(0xffff) /* 16-bit feature index */
> > > +#define VFIO_DEVICE_FEATURE_GET		(1 << 16) /* Get feature into data[] */
> > > +#define VFIO_DEVICE_FEATURE_SET		(1 << 17) /* Set feature from data[] */
> > > +#define VFIO_DEVICE_FEATURE_PROBE	(1 << 18) /* Probe feature support */
> > > +	__u8	data[];
> > > +};    
> > 
> > I'm not sure I'm a fan of cramming both feature selection and operation
> > selection into flags. What about:
> > 
> > struct vfio_device_feature {
> > 	__u32 argsz;
> > 	__u32 flags;
> > /* GET/SET/PROBE #defines */
> > 	__u32 feature;
> > 	__u8  data[];
> > };  
> 
> Then data is unaligned so we either need to expand feature or add
> padding.  So this makes the structure at least 8 bytes bigger and buys
> us...?  What's so special about the bottom half of flags that we can't
> designate it as the flags that specify the feature?  We still have
> another 13 bits of flags for future use.

It is more my general dislike of bit fiddling here, no strong
objection, certainly.

> 
> > Getting/setting more than one feature at the same time does not sound
> > like a common use case; you would need to specify some kind of
> > algorithm for that anyway, and just doing it individually seems much
> > easier than that.  
> 
> Yup.  I just figured 2^16 features is a nice way to make use of the
> structure vs 2^32 features and 4 bytes of padding or 2^64 features.  I
> don't think I'm being optimistic in thinking we'll have far less than
> 16K features and we can always reserve feature 0xffff as an extended
> feature where the first 8-bytes of data defines that extended feature
> index.

Agreed, we're probably not going to end up with a flood of features
here.

Anyway, much of this seems to be a matter of personal taste, so let's
keep it as it is.

