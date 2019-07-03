Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0A8F5E078
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2019 11:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbfGCJHI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 05:07:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10103 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbfGCJHH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 05:07:07 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 96DB930BC580;
        Wed,  3 Jul 2019 09:07:07 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A503C7AB6C;
        Wed,  3 Jul 2019 09:07:06 +0000 (UTC)
Date:   Wed, 3 Jul 2019 11:07:04 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] vfio-ccw: Fix the conversion of Format-0 CCWs to
 Format-1
Message-ID: <20190703110704.21509e60.cohuck@redhat.com>
In-Reply-To: <20190702180928.18113-1-farman@linux.ibm.com>
References: <20190702180928.18113-1-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 03 Jul 2019 09:07:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  2 Jul 2019 20:09:28 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> When processing Format-0 CCWs, we use the "len" variable as the
> number of CCWs to convert to Format-1.  But that variable
> contains zero here, and is not a meaningful CCW count until
> ccwchain_calc_length() returns.  Since that routine requires and
> expects Format-1 CCWs to identify the chaining behavior, the
> format conversion must be done first.

The usage of the 'len' variable in the function is a bit confusing
anyway.

> 
> Convert the 2KB we copied even if it's more than we need.
> 
> Fixes: 7f8e89a8f2fd ("vfio-ccw: Factor out the ccw0-to-ccw1 transition")
> Reported-by: Farhan Ali <alifm@linux.ibm.com>
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 9cddc1288059..a870bde10445 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -431,7 +431,7 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
>  
>  	/* Convert any Format-0 CCWs to Format-1 */
>  	if (!cp->orb.cmd.fmt)
> -		convert_ccw0_to_ccw1(cp->guest_cp, len);
> +		convert_ccw0_to_ccw1(cp->guest_cp, CCWCHAIN_LEN_MAX);
>  
>  	/* Count the CCWs in the current chain */
>  	len = ccwchain_calc_length(cda, cp);

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
