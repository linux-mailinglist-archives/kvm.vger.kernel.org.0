Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118A05CC2E
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 10:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGBIpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 04:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfGBIpx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 04:45:53 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77804307D853;
        Tue,  2 Jul 2019 08:45:53 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C1AE5C28D;
        Tue,  2 Jul 2019 08:45:52 +0000 (UTC)
Date:   Tue, 2 Jul 2019 10:45:50 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 3/4] vfio-ccw: Set pa_nr to 0 if memory allocation
 fails for pa_iova_pfn
Message-ID: <20190702104550.7d2e7563.cohuck@redhat.com>
In-Reply-To: <19d813c58e0c45df3f23d8b1033e00b5ac5c7779.1561997809.git.alifm@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
        <19d813c58e0c45df3f23d8b1033e00b5ac5c7779.1561997809.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 02 Jul 2019 08:45:53 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  1 Jul 2019 12:23:45 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> So we clean up correctly.
> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index cab1be9..c5655de 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -72,8 +72,10 @@ static int pfn_array_alloc(struct pfn_array *pa, u64 iova, unsigned int len)
>  				  sizeof(*pa->pa_iova_pfn) +
>  				  sizeof(*pa->pa_pfn),
>  				  GFP_KERNEL);
> -	if (unlikely(!pa->pa_iova_pfn))
> +	if (unlikely(!pa->pa_iova_pfn)) {
> +		pa->pa_nr = 0;
>  		return -ENOMEM;
> +	}
>  	pa->pa_pfn = pa->pa_iova_pfn + pa->pa_nr;
>  
>  	pa->pa_iova_pfn[0] = pa->pa_iova >> PAGE_SHIFT;

This looks like an older error -- can you give a Fixes: tag? (Yeah, I
know I sound like a broken record wrt that tag... :)
