Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A272B1C6F45
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 13:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgEFLYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 07:24:42 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727849AbgEFLYk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 07:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588764278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Qr0XiLssBUP1KzSEARJHgF0bv5jIGk/42Em4vy6c0w=;
        b=Bi9YTl8NVxTt/1rcNbhZ9M/KTcGrbREsYhi3O3TM5kRmU3ylsUj893trh42oonzFNSJ5oW
        A5cLem75IlZ92HThG82gmbCDYCu5Gqt9hkO24yJTYb2YzLoA71DRJyrqcgQgxjSm8czTUz
        KuP3yHIWHYM7FuA0NhHB6EyWg8w2vDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-7gDtz1ExOEa6CAGZiSQbdw-1; Wed, 06 May 2020 07:24:33 -0400
X-MC-Unique: 7gDtz1ExOEa6CAGZiSQbdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DCE1107ACCA;
        Wed,  6 May 2020 11:24:32 +0000 (UTC)
Received: from gondolin (ovpn-112-211.ams2.redhat.com [10.36.112.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A307399CF;
        Wed,  6 May 2020 11:24:30 +0000 (UTC)
Date:   Wed, 6 May 2020 13:24:27 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jared Rossi <jrossi@linux.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio-ccw: Enable transparent CCW IPL from DASD
Message-ID: <20200506132427.2f64a07d.cohuck@redhat.com>
In-Reply-To: <20200506001544.16213-2-jrossi@linux.ibm.com>
References: <20200506001544.16213-1-jrossi@linux.ibm.com>
        <20200506001544.16213-2-jrossi@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 May 2020 20:15:44 -0400
Jared Rossi <jrossi@linux.ibm.com> wrote:

> Remove the explicit prefetch check when using vfio-ccw devices.
> This check does not trigger in practice as all Linux channel programs
> are intended to use prefetch.
> 
> It is expected that all ORBs issued by Linux will request prefetch.
> Although non-prefetching ORBs are not rejected, they will prefetch
> nonetheless. A warning is issued up to once per 5 seconds when a
> forced prefetch occurs.
> 
> A non-prefetch ORB does not necessarily result in an error, however
> frequent encounters with non-prefetch ORBs indicate that channel
> programs are being executed in a way that is inconsistent with what
> the guest is requesting. While there is currently no known case of an
> error caused by forced prefetch, it is possible in theory that forced
> prefetch could result in an error if applied to a channel program that
> is dependent on non-prefetch.
> 
> Signed-off-by: Jared Rossi <jrossi@linux.ibm.com>
> ---
>  Documentation/s390/vfio-ccw.rst |  6 ++++++
>  drivers/s390/cio/vfio_ccw_cp.c  | 19 ++++++++++++-------
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 

(...)

> @@ -625,23 +626,27 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
>   * the target channel program from @orb->cmd.iova to the new ccwchain(s).
>   *
>   * Limitations:
> - * 1. Supports only prefetch enabled mode.
> - * 2. Supports idal(c64) ccw chaining.
> - * 3. Supports 4k idaw.
> + * 1. Supports idal(c64) ccw chaining.
> + * 2. Supports 4k idaw.
>   *
>   * Returns:
>   *   %0 on success and a negative error value on failure.
>   */
>  int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  {
> +	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
>  	int ret;
>  
>  	/*
> -	 * XXX:
> -	 * Only support prefetch enable mode now.
> +	 * We only support prefetching the channel program. We assume all channel
> +	 * programs executed by supported guests (i.e. Linux) likewise support
> +	 * prefetching. Even if prefetching is not specified the channel program
> +	 * is still executed using prefetch. Executing a channel program that
> +	 * does not specify prefetching will typically not cause an error, but a
> +	 * warning is issued to help identify the problem if something does break.
>  	 */
> -	if (!orb->cmd.pfch)
> -		return -EOPNOTSUPP;

/* custom ratelimiting to avoid flood during boot */

(to avoid people stumbling over this)

> +	if (!orb->cmd.pfch && __ratelimit(&ratelimit_state))
> +		dev_warn(mdev, "executing channel program with prefetch, but prefetch isn't specified");

hmm... what about

"prefetching channel program even though prefetch not specified in orb"?

>  
>  	INIT_LIST_HEAD(&cp->ccwchain_list);
>  	memcpy(&cp->orb, orb, sizeof(*orb));

(...)

Apart from the bikeshedding, looks sane to me; but would like more
opinions.

