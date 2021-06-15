Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115A53A7BFC
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 12:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhFOKdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 06:33:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231758AbhFOKdv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 06:33:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623753107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=F8QWQfVZrepeYJ8pBFnyNbs8hCa7lpsmDCFMZoGlYqY=;
        b=AvsAlfkhPy1fslI+wn5h8CtgYDwEqHIKXKBQfv3W8w+5KIjIUn4bTY245QjmERMF+z7jCB
        46jSeNd28SbJDMXQaEmSX5PQ+1wOdMYMCg2lhrdvQL8f+eALadmPaZqMQ2+K3zs+MDJItG
        BXymCDE/wJT+gO3TmLywan8oTEmn6D0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-qtllWZvcM3q_pedBpzFCUA-1; Tue, 15 Jun 2021 06:31:43 -0400
X-MC-Unique: qtllWZvcM3q_pedBpzFCUA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E849EC1A0;
        Tue, 15 Jun 2021 10:31:41 +0000 (UTC)
Received: from localhost (ovpn-113-156.ams2.redhat.com [10.36.113.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8D9460877;
        Tue, 15 Jun 2021 10:31:37 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     David Airlie <airlied@linux.ie>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 03/10] driver core: Flow the return code from ->probe()
 through to sysfs bind
In-Reply-To: <20210614150846.4111871-4-hch@lst.de>
Organization: Red Hat GmbH
References: <20210614150846.4111871-1-hch@lst.de>
 <20210614150846.4111871-4-hch@lst.de>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 15 Jun 2021 12:31:36 +0200
Message-ID: <87eed3xvuf.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14 2021, Christoph Hellwig <hch@lst.de> wrote:

> Currently really_probe() returns 1 on success and 0 if the probe() call
> fails. This return code arrangement is designed to be useful for
> __device_attach_driver() which is walking the device list and trying every
> driver. 0 means to keep trying.
>
> However, it is not useful for the other places that call through to
> really_probe() that do actually want to see the probe() return code.
>
> For instance bind_store() would be better to return the actual error code
> from the driver's probe method, not discarding it and returning -ENODEV.
>
> Reorganize things so that really_probe() returns the error code from
> ->probe as a (inverted) positive number, and 0 for successful attach.
>
> With this, __device_attach_driver can ignore the (positive) probe errors,
> return 1 to exit the loop for a successful binding and pass on the
> other negative errors, while device_driver_attach simplify inverts the
> positive errors and returns all errors to the sysfs code.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/base/bus.c |  6 +-----
>  drivers/base/dd.c  | 29 ++++++++++++++++++++---------
>  2 files changed, 21 insertions(+), 14 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

