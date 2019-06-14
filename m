Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03EB459C7
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 12:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfFNKBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 06:01:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbfFNKBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jun 2019 06:01:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 38D7E308339B;
        Fri, 14 Jun 2019 10:01:15 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 26234648C3;
        Fri, 14 Jun 2019 10:01:14 +0000 (UTC)
Date:   Fri, 14 Jun 2019 12:01:11 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 9/9] s390/cio: Combine direct and indirect CCW paths
Message-ID: <20190614120111.00b4bd48.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-10-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
        <20190606202831.44135-10-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 14 Jun 2019 10:01:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:31 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> With both the direct-addressed and indirect-addressed CCW paths
> simplified to this point, the amount of shared code between them is
> (hopefully) more easily visible.  Move the processing of IDA-specific
> bits into the direct-addressed path, and add some useful commentary of
> what the individual pieces are doing.  This allows us to remove the
> entire ccwchain_fetch_idal() routine and maintain a single function
> for any non-TIC CCW.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 115 +++++++++++----------------------
>  1 file changed, 39 insertions(+), 76 deletions(-)

Another nice cleanup :)

> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 8205d0b527fc..90d86e1354c1 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -534,10 +534,12 @@ static int ccwchain_fetch_direct(struct ccwchain *chain,

The one minor thing I have is that the function name
(ccwchain_fetch_direct) is now slightly confusing. But we can easily do
a patch on top renaming it (if we can come up with a better name.)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
