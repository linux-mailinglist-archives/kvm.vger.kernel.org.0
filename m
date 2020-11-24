Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A802C2239
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 10:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731321AbgKXJ5W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 04:57:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731568AbgKXJ5V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 04:57:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606211840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mi0S82r7bzQoS3BczSKSMu4awfdr5Uu/IpAabFMazi4=;
        b=cy8do4TVFf/kErIV3/ii+KzPWg0eLkVIa8rz9XnxNLZnCrj4Stj+d8TsYTNOAbTEcAZTu0
        AOcX0DmY6IVGYIhMvyyU4vQMJOBjHyGr116xfIGnVmWtjOqxvelXbAKPfNZ/9Pt9t0U6Dz
        rd0B3Z/baiJc/1TfiwOl8eYGjYt/ap8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-De7nGcK5NmeVNUhrXovq8Q-1; Tue, 24 Nov 2020 04:57:16 -0500
X-MC-Unique: De7nGcK5NmeVNUhrXovq8Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F249A107AFAF;
        Tue, 24 Nov 2020 09:57:14 +0000 (UTC)
Received: from gondolin (ovpn-113-136.ams2.redhat.com [10.36.113.136])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BEEC60C13;
        Tue, 24 Nov 2020 09:57:10 +0000 (UTC)
Date:   Tue, 24 Nov 2020 10:57:07 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfio-mdev: Wire in a request handler for mdev
 parent
Message-ID: <20201124105707.7f5802eb.cohuck@redhat.com>
In-Reply-To: <20201120180740.87837-2-farman@linux.ibm.com>
References: <20201120180740.87837-1-farman@linux.ibm.com>
        <20201120180740.87837-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Nov 2020 19:07:39 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> While performing some destructive tests with vfio-ccw, where the
> paths to a device are forcible removed and thus the device itself
> is unreachable, it is rather easy to end up in an endless loop in
> vfio_del_group_dev() due to the lack of a request callback for the
> associated device.
> 
> In this example, one MDEV (77c) is used by a guest, while another
> (77b) is not. The symptom is that the iommu is detached from the
> mdev for 77b, but not 77c, until that guest is shutdown:
> 
>     [  238.794867] vfio_ccw 0.0.077b: MDEV: Unregistering
>     [  238.794996] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: Removing from iommu group 2
>     [  238.795001] vfio_mdev 11f2d2bc-4083-431d-a023-eff72715c4f0: MDEV: detaching iommu
>     [  238.795036] vfio_ccw 0.0.077c: MDEV: Unregistering
>     ...silence...
> 
> Let's wire in the request call back to the mdev device, so that a
> device being physically removed from the host can be (gracefully?)
> handled by the parent device at the time the device is removed.
> 
> Add a message when registering the device if a driver doesn't
> provide this callback, so a clue is given that this same loop
> may be encountered in a similar situation.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/vfio/mdev/mdev_core.c |  4 ++++
>  drivers/vfio/mdev/vfio_mdev.c | 10 ++++++++++
>  include/linux/mdev.h          |  4 ++++
>  3 files changed, 18 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

