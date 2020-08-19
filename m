Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3CF249965
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 11:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgHSJfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 05:35:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgHSJfE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 05:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597829702;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zgtCTigZDuhIGcxkV1+kVI09BLaRJYOiJT5Qj4JZMc0=;
        b=NWvsaX6KxcaVKWeczrmsQADFybabdpeFcVkuRdoN8LjbRbO1DT3tvmrFn+hIWDsvwVLVo9
        KGUo3oHPWy8toallB6PBAcF9GnVl2dMTO0OtKDVOrf8Z/kiaAjnQMdfbH/llWzzw7f1yCb
        2dWrPuV95P1QQjU7VytBuaE+C5wRzck=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-ZetAcgeqN7WK8fydIu2eWQ-1; Wed, 19 Aug 2020 05:34:58 -0400
X-MC-Unique: ZetAcgeqN7WK8fydIu2eWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1ED41084C8A;
        Wed, 19 Aug 2020 09:34:55 +0000 (UTC)
Received: from gondolin (ovpn-112-216.ams2.redhat.com [10.36.112.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 62AFA59;
        Wed, 19 Aug 2020 09:34:49 +0000 (UTC)
Date:   Wed, 19 Aug 2020 11:34:46 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v8 1/2] virtio: let arch validate VIRTIO features
Message-ID: <20200819113446.3f098d1e.cohuck@redhat.com>
In-Reply-To: <64acd55a-8a22-4b84-0f9e-e13196c1520d@linux.ibm.com>
References: <1597762711-3550-1-git-send-email-pmorel@linux.ibm.com>
        <1597762711-3550-2-git-send-email-pmorel@linux.ibm.com>
        <20200818191910.1fc300f2.cohuck@redhat.com>
        <64acd55a-8a22-4b84-0f9e-e13196c1520d@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 19 Aug 2020 10:50:18 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> On 2020-08-18 19:19, Cornelia Huck wrote:
> > On Tue, 18 Aug 2020 16:58:30 +0200
> > Pierre Morel <pmorel@linux.ibm.com> wrote:
> >   
> ...
> >> +config ARCH_HAS_RESTRICTED_MEMORY_ACCESS
> >> +	bool
> >> +	help
> >> +	  This option is selected by any architecture enforcing
> >> +	  VIRTIO_F_IOMMU_PLATFORM  
> > 
> > This option is only for a very specific case of "restricted memory
> > access", namely the kind that requires IOMMU_PLATFORM for virtio
> > devices. ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS? Or is this intended
> > to cover cases outside of virtio as well?  
> 
> AFAIK we did not identify other restrictions so adding VIRTIO in the 
> name should be the best thing to do.
> 
> If new restrictions appear they also may be orthogonal.
> 
> I will change to ARCH_HAS_RESTRICTED_VIRTIO_MEMORY_ACCESS if no one 
> complains.
> 
> >   
> >> +
> >>   menuconfig VIRTIO_MENU
> >>   	bool "Virtio drivers"
> >>   	default y
> >> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> >> index a977e32a88f2..1471db7d6510 100644
> >> --- a/drivers/virtio/virtio.c
> >> +++ b/drivers/virtio/virtio.c
> >> @@ -176,6 +176,10 @@ int virtio_finalize_features(struct virtio_device *dev)
> >>   	if (ret)
> >>   		return ret;
> >>   
> >> +	ret = arch_has_restricted_memory_access(dev);
> >> +	if (ret)
> >> +		return ret;  
> > 
> > Hm, I'd rather have expected something like
> > 
> > if (arch_has_restricted_memory_access(dev)) {  
> 
> may be also change the callback name to
> arch_has_restricted_virtio_memory_access() ?

Yes, why not.

> 
> > 	// enforce VERSION_1 and IOMMU_PLATFORM
> > }
> > 
> > Otherwise, you're duplicating the checks in the individual architecture
> > callbacks again.  
> 
> Yes, I agree and go back this way.
> 
> > 
> > [Not sure whether the device argument would be needed here; are there
> > architectures where we'd only require IOMMU_PLATFORM for a subset of
> > virtio devices?]  
> 
> I don't think so and since we do the checks locally, we do not need the 
> device argument anymore.

Yes, that would also remove some layering entanglement.

