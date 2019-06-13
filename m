Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2FB544014
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbfFMQCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 12:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34798 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387749AbfFMQCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 12:02:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A7505B2DD4;
        Thu, 13 Jun 2019 16:02:53 +0000 (UTC)
Received: from gondolin (dhcp-192-222.str.redhat.com [10.33.192.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9742B5427C;
        Thu, 13 Jun 2019 16:02:52 +0000 (UTC)
Date:   Thu, 13 Jun 2019 18:02:49 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v2 6/9] vfio-ccw: Adjust the first IDAW outside of the
 nested loops
Message-ID: <20190613180249.1f26258d.cohuck@redhat.com>
In-Reply-To: <20190606202831.44135-7-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
        <20190606202831.44135-7-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 13 Jun 2019 16:02:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 22:28:28 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Now that pfn_array_table[] is always an array of 1, it seems silly to
> check for the very first entry in an array in the middle of two nested
> loops, since we know it'll only ever happen once.
> 
> Let's move this outside the loops to simplify things, even though
> the "k" variable is still necessary.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 86a0e76ef2b5..ab9f8f0d1b44 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -201,11 +201,12 @@ static inline void pfn_array_table_idal_create_words(
>  		pa = pat->pat_pa + i;
>  		for (j = 0; j < pa->pa_nr; j++) {
>  			idaws[k] = pa->pa_pfn[j] << PAGE_SHIFT;
> -			if (k == 0)
> -				idaws[k] += pa->pa_iova & (PAGE_SIZE - 1);
>  			k++;
>  		}
>  	}
> +
> +	/* Adjust the first IDAW, since it may not start on a page boundary */
> +	idaws[0] += pat->pat_pa->pa_iova & (PAGE_SIZE - 1);
>  }
>  
>  

Also +1 to adding a nice explaining comment :)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
