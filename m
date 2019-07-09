Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51FD0633F4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 12:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGIKI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 06:08:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfGIKI1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 06:08:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CB64A3082B68;
        Tue,  9 Jul 2019 10:08:27 +0000 (UTC)
Received: from gondolin (unknown [10.40.205.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 433BE19936;
        Tue,  9 Jul 2019 10:08:26 +0000 (UTC)
Date:   Tue, 9 Jul 2019 12:08:22 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v2 3/5] vfio-ccw: Set pa_nr to 0 if memory allocation
 fails for pa_iova_pfn
Message-ID: <20190709120822.34a17f9b.cohuck@redhat.com>
In-Reply-To: <452bf0756d8b0efdb9fd1e1aa5d8c0e6a7f31c03.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
        <452bf0756d8b0efdb9fd1e1aa5d8c0e6a7f31c03.1562616169.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 09 Jul 2019 10:08:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  8 Jul 2019 16:10:36 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> So we don't call try to call vfio_unpin_pages() incorrectly.
> 
> Fixes: 0a19e61e6d4c ("vfio: ccw: introduce channel program interfaces")

So that was there since the beginning :)

> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> Reviewed-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 31a04a5..1b93863 100644
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

Reviewed-by: Cornelia Huck <cohuck@redhat.com>
