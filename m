Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D21633C4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 11:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfGIJ5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 05:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbfGIJ5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 05:57:38 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6516519CF51;
        Tue,  9 Jul 2019 09:57:38 +0000 (UTC)
Received: from gondolin (unknown [10.40.205.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECCF35DA97;
        Tue,  9 Jul 2019 09:57:36 +0000 (UTC)
Date:   Tue, 9 Jul 2019 11:57:33 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v2 1/5] vfio-ccw: Fix misleading comment when setting
 orb.cmd.c64
Message-ID: <20190709115733.40eb8db5.cohuck@redhat.com>
In-Reply-To: <25a5bf8ae538a392f8483e6fd4b9b165de40bfce.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
        <25a5bf8ae538a392f8483e6fd4b9b165de40bfce.1562616169.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 09 Jul 2019 09:57:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  8 Jul 2019 16:10:34 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> The comment is misleading because it tells us that
> we should set orb.cmd.c64 before calling ccwchain_calc_length,
> otherwise the function ccwchain_calc_length would return an
> error. This is not completely accurate.
> 
> We want to allow an orb without cmd.c64, and this is fine
> as long as the channel program does not use IDALs. But we do
> want to reject any channel program that uses IDALs and does
> not set the flag, which what we do in ccwchain_calc_length.
> 
> After we have done the ccw processing, it should be safe
> to set cmd.c64, since we will convert them into IDALs.

"After we have done the ccw processing, we need to set cmd.c64, as we
use IDALs for all translated channel programs." ?

>

Fixes: fb9e7880af35 ("vfio: ccw: push down unsupported IDA check")
 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index d6a8dff..7622b72 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -645,8 +645,8 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  	if (ret)
>  		cp_free(cp);
>  
> -	/* It is safe to force: if not set but idals used
> -	 * ccwchain_calc_length returns an error.
> +	/* It is safe to force: if it was not set but idals used
> +	 * ccwchain_calc_length would have returned an error.

Thanks, much clearer.

>  	 */
>  	cp->orb.cmd.c64 = 1;
>  

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
