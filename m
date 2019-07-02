Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 428685CBFF
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 10:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbfGBI0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 04:26:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbfGBI0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 04:26:09 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6FD1686679;
        Tue,  2 Jul 2019 08:26:09 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 802605C296;
        Tue,  2 Jul 2019 08:26:08 +0000 (UTC)
Date:   Tue, 2 Jul 2019 10:26:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 1/4] vfio-ccw: Set orb.cmd.c64 before calling
 ccwchain_handle_ccw
Message-ID: <20190702102606.2e9cfed3.cohuck@redhat.com>
In-Reply-To: <050943a6f5a427317ea64100bc2b4ec6394a4411.1561997809.git.alifm@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
        <050943a6f5a427317ea64100bc2b4ec6394a4411.1561997809.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 02 Jul 2019 08:26:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  1 Jul 2019 12:23:43 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> Because ccwchain_handle_ccw calls ccwchain_calc_length and
> as per the comment we should set orb.cmd.c64 before calling
> ccwchanin_calc_length.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index d6a8dff..5ac4c1e 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -640,16 +640,16 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  	memcpy(&cp->orb, orb, sizeof(*orb));
>  	cp->mdev = mdev;
>  
> -	/* Build a ccwchain for the first CCW segment */
> -	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
> -	if (ret)
> -		cp_free(cp);
> -
>  	/* It is safe to force: if not set but idals used
>  	 * ccwchain_calc_length returns an error.
>  	 */
>  	cp->orb.cmd.c64 = 1;
>  
> +	/* Build a ccwchain for the first CCW segment */
> +	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
> +	if (ret)
> +		cp_free(cp);
> +
>  	if (!ret)
>  		cp->initialized = true;
>  

Hm... has this ever been correct, or did this break only with the
recent refactorings?

(IOW, what should Fixes: point to?)
