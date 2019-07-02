Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B849E5CC25
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 10:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbfGBInA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 04:43:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60590 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfGBInA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 04:43:00 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DEAF306041F;
        Tue,  2 Jul 2019 08:43:00 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A87F50F90;
        Tue,  2 Jul 2019 08:42:59 +0000 (UTC)
Date:   Tue, 2 Jul 2019 10:42:57 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 2/4] vfio-ccw: No need to call cp_free on an error in
 cp_init
Message-ID: <20190702104257.102f32d3.cohuck@redhat.com>
In-Reply-To: <5f1b69cd3a52e367f9f5014a3613768c8634408c.1561997809.git.alifm@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
        <5f1b69cd3a52e367f9f5014a3613768c8634408c.1561997809.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 02 Jul 2019 08:43:00 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  1 Jul 2019 12:23:44 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> We don't set cp->initialized to true so calling cp_free
> will just return and not do anything.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 5ac4c1e..cab1be9 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -647,8 +647,6 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  
>  	/* Build a ccwchain for the first CCW segment */
>  	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
> -	if (ret)
> -		cp_free(cp);

Makes sense; hopefully ccwchain_handle_ccw() cleans up correctly on
error :) (I think it does)

Maybe add a comment

/* ccwchain_handle_ccw() already cleans up on error */

so we don't stumble over this in the future?

(Also, does this want a Fixes: tag?)

>  
>  	if (!ret)
>  		cp->initialized = true;

