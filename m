Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B106B265488
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 23:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725440AbgIJV5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 17:57:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730533AbgIJLzG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Sep 2020 07:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599738901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=49H7U6LJbGnt6e693nebQ7+aRxoWnzJ6KmFbIoT1CKw=;
        b=NbVYA5u+a+AAWTQ6myvT0RMBM8clRALbmtzHTMXUaAVRyWD8DRs6PVFeIXXCGX+nmgKOWF
        OMmsiS1++lJrkfSFWx1JJk04F+hCzZ/y1FT8p8Mu/613AYOeJnkj4DU6Ijv0S7QY97aH1j
        q1ptoGEXITZPK/ebfQTRNi9zvQDdnnk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-h5xfY9iHNuKG2eaqfXuq4w-1; Thu, 10 Sep 2020 07:36:27 -0400
X-MC-Unique: h5xfY9iHNuKG2eaqfXuq4w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2E0DE801AEA;
        Thu, 10 Sep 2020 11:36:25 +0000 (UTC)
Received: from gondolin (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C61827E8EC;
        Thu, 10 Sep 2020 11:36:11 +0000 (UTC)
Date:   Thu, 10 Sep 2020 13:36:09 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>, dgilbert@redhat.com,
        frankja@linux.ibm.com, pair@us.ibm.com, qemu-devel@nongnu.org,
        pbonzini@redhat.com, brijesh.singh@amd.com, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>
Subject: Re: [for-5.2 v4 10/10] s390: Recognize host-trust-limitation option
Message-ID: <20200910133609.4ac88c25.cohuck@redhat.com>
In-Reply-To: <20200907172253.0a51f5f7.pasic@linux.ibm.com>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
        <20200724025744.69644-11-david@gibson.dropbear.id.au>
        <20200907172253.0a51f5f7.pasic@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 7 Sep 2020 17:22:53 +0200
Halil Pasic <pasic@linux.ibm.com> wrote:

> On Fri, 24 Jul 2020 12:57:44 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
> 
> > At least some s390 cpu models support "Protected Virtualization" (PV),
> > a mechanism to protect guests from eavesdropping by a compromised
> > hypervisor.
> > 
> > This is similar in function to other mechanisms like AMD's SEV and
> > POWER's PEF, which are controlled bythe "host-trust-limitation"
> > machine option.  s390 is a slightly special case, because we already
> > supported PV, simply by using a CPU model with the required feature
> > (S390_FEAT_UNPACK).
> > 
> > To integrate this with the option used by other platforms, we
> > implement the following compromise:
> > 
> >  - When the host-trust-limitation option is set, s390 will recognize
> >    it, verify that the CPU can support PV (failing if not) and set
> >    virtio default options necessary for encrypted or protected guests,
> >    as on other platforms.  i.e. if host-trust-limitation is set, we
> >    will either create a guest capable of entering PV mode, or fail
> >    outright  
> 
> Shouldn't we also fail outright if the virtio features are not PV
> compatible (invalid configuration)?
> 
> I would like to see something like follows as a part of this series.
> ----------------------------8<--------------------------
> From: Halil Pasic <pasic@linux.ibm.com>
> Date: Mon, 7 Sep 2020 15:00:17 +0200
> Subject: [PATCH] virtio: handle host trust limitation
> 
> If host_trust_limitation_enabled() returns true, then emulated virtio
> devices must offer VIRTIO_F_ACCESS_PLATFORM, because the device is not
> capable of accessing all of the guest memory. Otherwise we are in
> violation of the virtio specification.
> 
> Let's fail realize if we detect that VIRTIO_F_ACCESS_PLATFORM feature is
> obligatory but missing.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> ---
>  hw/virtio/virtio.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/hw/virtio/virtio.c b/hw/virtio/virtio.c
> index 5bd2a2f621..19b4b0a37a 100644
> --- a/hw/virtio/virtio.c
> +++ b/hw/virtio/virtio.c
> @@ -27,6 +27,7 @@
>  #include "hw/virtio/virtio-access.h"
>  #include "sysemu/dma.h"
>  #include "sysemu/runstate.h"
> +#include "exec/host-trust-limitation.h"
>  
>  /*
>   * The alignment to use between consumer and producer parts of vring.
> @@ -3618,6 +3619,12 @@ static void virtio_device_realize(DeviceState *dev, Error **errp)
>      /* Devices should either use vmsd or the load/save methods */
>      assert(!vdc->vmsd || !vdc->load);
>  
> +    if (host_trust_limitation_enabled(MACHINE(qdev_get_machine()))
> +        && !virtio_host_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM)) {
> +        error_setg(&err, "devices without VIRTIO_F_ACCESS_PLATFORM are not compatible with host trust imitation");
> +        error_propagate(errp, err);
> +        return;

How can we get here? I assume only if the user explicitly turned the
feature off while turning HTL on, as otherwise patch 9 should have
taken care of it?

> +    }
>      if (vdc->realize != NULL) {
>          vdc->realize(dev, &err);
>          if (err != NULL) {

