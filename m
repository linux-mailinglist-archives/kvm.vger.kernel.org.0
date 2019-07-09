Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE001633ED
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 12:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfGIKG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 06:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59264 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfGIKG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 06:06:56 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8DE3430C7473;
        Tue,  9 Jul 2019 10:06:56 +0000 (UTC)
Received: from gondolin (unknown [10.40.205.62])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0D5A490C1A;
        Tue,  9 Jul 2019 10:06:54 +0000 (UTC)
Date:   Tue, 9 Jul 2019 12:06:51 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v2 2/5] vfio-ccw: Fix memory leak and don't call cp_free
 in cp_init
Message-ID: <20190709120651.06d7666e.cohuck@redhat.com>
In-Reply-To: <fbb44bc85f5dfe4fdaebaf9cb74efcfae4743fba.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
        <fbb44bc85f5dfe4fdaebaf9cb74efcfae4743fba.1562616169.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 09 Jul 2019 10:06:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  8 Jul 2019 16:10:35 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> We don't set cp->initialized to true so calling cp_free
> will just return and not do anything.
> 
> Also fix a memory leak where we fail to free a ccwchain
> on an error.
> 
> Fixes: 812271b910 ("s390/cio: Squash cp_free() and cp_unpin_free()")
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)

(...)

> @@ -642,8 +647,6 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
>  
>  	/* Build a ccwchain for the first CCW segment */
>  	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
> -	if (ret)
> -		cp_free(cp);

Now that I look again: it's a bit odd that we set the bit in all cases,
even if we have an error. We could move that into the !ret branch that
sets ->initialized; but it does not really hurt.

>  
>  	/* It is safe to force: if it was not set but idals used
>  	 * ccwchain_calc_length would have returned an error.

The rest of the patch looks good to me.
