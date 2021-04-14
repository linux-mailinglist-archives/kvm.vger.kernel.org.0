Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A6635F8FB
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 18:33:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351635AbhDNQa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 12:30:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40863 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349221AbhDNQa6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 14 Apr 2021 12:30:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618417836;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TDqw7SuxPwDscOI0Q0fTDI3jnZfp7IWUGcUSEKD/yTc=;
        b=hOvgyRBwHKlB6A2CQ50PNtHB59clf+aMy5KiSmGknqZsX1Ke3xbiGHX4/s0XvxpQtf069o
        U4923A+AJ1WIcJ5LsYKKgRo4ibO7HMCX7yAeR5AvXqmJ1Ehw5pUJLGhOyr45i1dAW0Ldn6
        60/RQtttSBVfXkUbWWOHF/JqRZq1JCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-A7xWChHmOqmZb-HYnca-XQ-1; Wed, 14 Apr 2021 12:30:34 -0400
X-MC-Unique: A7xWChHmOqmZb-HYnca-XQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CED8A8030CF;
        Wed, 14 Apr 2021 16:30:32 +0000 (UTC)
Received: from gondolin (ovpn-113-114.ams2.redhat.com [10.36.113.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7F08C5C1B4;
        Wed, 14 Apr 2021 16:30:31 +0000 (UTC)
Date:   Wed, 14 Apr 2021 18:30:28 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 1/4] vfio-ccw: Check initialized flag in
 cp_init()
Message-ID: <20210414183028.1285311e.cohuck@redhat.com>
In-Reply-To: <20210413182410.1396170-2-farman@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
        <20210413182410.1396170-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 20:24:07 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> We have a really nice flag in the channel_program struct that
> indicates if it had been initialized by cp_init(), and use it
> as a guard in the other cp accessor routines, but not for a
> duplicate call into cp_init(). The possibility of this occurring
> is low, because that flow is protected by the private->io_mutex
> and FSM CP_PROCESSING state. But then why bother checking it
> in (for example) cp_prefetch() then?
> 
> Let's just be consistent and check for that in cp_init() too.
> 
> Fixes: 71189f263f8a3 ("vfio-ccw: make it safe to access channel programs")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index b9febc581b1f..8d1b2771c1aa 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -638,6 +638,10 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
>  	int ret;
>  
> +	/* this is an error in the caller */
> +	if (cp->initialized)
> +		return -EBUSY;
> +
>  	/*
>  	 * We only support prefetching the channel program. We assume all channel
>  	 * programs executed by supported guests likewise support prefetching.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

