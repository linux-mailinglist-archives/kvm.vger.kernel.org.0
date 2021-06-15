Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0C63A81B4
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 16:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231203AbhFOOFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 10:05:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40176 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230437AbhFOOFu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 10:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623765826;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kLMUNwIYFZdrtc2NmHvIqgVHyZsoQim6Z5rwLBywteg=;
        b=AC+M9NKyf84Ov998/TZirnAiZ65SaTH3D8tjIRDnPC4TzDxc8QoPxfqC84qvom9f5L+vtw
        QCpl5LG1kxjAb98E6JFcpu28mht8JmjkEA0YcnAV/1R5gIicTXquaNGkAH7ZXuhpwHvcwk
        ChwQ1CyqY3B8oB2AeKWelLTAHdUeLoE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-V1Sr6BHiOI64oEIdkGxxcg-1; Tue, 15 Jun 2021 10:03:41 -0400
X-MC-Unique: V1Sr6BHiOI64oEIdkGxxcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E32AD101F7D0;
        Tue, 15 Jun 2021 14:03:32 +0000 (UTC)
Received: from localhost (ovpn-113-156.ams2.redhat.com [10.36.113.156])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D721318B4B;
        Tue, 15 Jun 2021 14:03:28 +0000 (UTC)
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
Subject: Re: [PATCH 04/10] driver core: Don't return EPROBE_DEFER to
 userspace during sysfs bind
In-Reply-To: <20210615133519.754763-5-hch@lst.de>
Organization: Red Hat GmbH
References: <20210615133519.754763-1-hch@lst.de>
 <20210615133519.754763-5-hch@lst.de>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 15 Jun 2021 16:03:27 +0200
Message-ID: <87zgvrw7gw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15 2021, Christoph Hellwig <hch@lst.de> wrote:

> EPROBE_DEFER is an internal kernel error code and it should not be leaked
> to userspace via the bind_store() sysfs. Userspace doesn't have this
> constant and cannot understand it.
>
> Further, it doesn't really make sense to have userspace trigger a deferred
> probe via bind_store(), which could eventually succeed, while
> simultaneously returning an error back.
>
> Resolve this by splitting driver_probe_device so that the version used
> by the sysfs binding that turns EPROBE_DEFER into -EAGAIN, while the one
> used for internally binding keeps the error code, and calls
> driver_deferred_probe_add where needed.  This also allows to nicely split
> out the defer_all_probes / probe_count checks so that they actually allow
> for full device_{block,unblock}_probing protection while not bothering
> the sysfs bind case.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/base/dd.c | 78 +++++++++++++++++++++++++----------------------
>  1 file changed, 42 insertions(+), 36 deletions(-)
>

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

