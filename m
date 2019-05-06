Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3204314D9F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 16:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfEFOrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 10:47:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbfEFOrQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 May 2019 10:47:16 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C299681DFA;
        Mon,  6 May 2019 14:47:15 +0000 (UTC)
Received: from gondolin (unknown [10.40.205.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 078B210021B2;
        Mon,  6 May 2019 14:47:13 +0000 (UTC)
Date:   Mon, 6 May 2019 16:47:10 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] s390/cio: Update SCSW if it points to the end of
 the chain
Message-ID: <20190506164710.5fe0b6c8.cohuck@redhat.com>
In-Reply-To: <20190503134912.39756-2-farman@linux.ibm.com>
References: <20190503134912.39756-1-farman@linux.ibm.com>
        <20190503134912.39756-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 06 May 2019 14:47:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  3 May 2019 15:49:06 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Per the POPs [1], when processing an interrupt the SCSW.CPA field of an
> IRB generally points to 8 bytes after the last CCW that was executed
> (there are exceptions, but this is the most common behavior).
> 
> In the case of an error, this points us to the first un-executed CCW
> in the chain.  But in the case of normal I/O, the address points beyond
> the end of the chain.  While the guest generally only cares about this
> when possibly restarting a channel program after error recovery, we
> should convert the address even in the good scenario so that we provide
> a consistent, valid, response upon I/O completion.
> 
> [1] Figure 16-6 in SA22-7832-11.  The footnotes in that table also state
> that this is true even if the resulting address is invalid or protected,
> but moving to the end of the guest chain should not be a surprise.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 384b3987eeb4..f86da78eaeaa 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -870,7 +870,7 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
>  	 */
>  	list_for_each_entry(chain, &cp->ccwchain_list, next) {
>  		ccw_head = (u32)(u64)chain->ch_ccw;
> -		if (is_cpa_within_range(cpa, ccw_head, chain->ch_len)) {
> +		if (is_cpa_within_range(cpa, ccw_head, chain->ch_len + 1)) {

Maybe add a comment

/* On successful execution, cpa points just beyond the end of the chain. */

or so, to avoid head-scratching and PoP-reading in the future?

>  			/*
>  			 * (cpa - ccw_head) is the offset value of the host
>  			 * physical ccw to its chain head.

