Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D63F37BB48
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 12:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhELKu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 06:50:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50661 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhELKuX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 06:50:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620816555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g6ZqJG2exIYG7PlPiCBsNSM/rwDZhImxg4IaHwFDE2k=;
        b=HDYwcy48pwz9ll6XKVZPxaIY0oHuv8ViJGU/4IOmuTEuXzR16apkZgVdnjnNC551DCjPZW
        kRoLHc9PZTHCahu/7Ryt3VCs2slGIuHg24aHAgfqydb+froiUtxWqeisQZJoVWfMvlGIDs
        w7nUNrAvuJ5PyazobIAM6c4IaiG1N10=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-557-_C15r1peNO2Xa0wq0Bo3yQ-1; Wed, 12 May 2021 06:49:11 -0400
X-MC-Unique: _C15r1peNO2Xa0wq0Bo3yQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73152100855A;
        Wed, 12 May 2021 10:49:10 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-78.ams2.redhat.com [10.36.113.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DFD15D6A8;
        Wed, 12 May 2021 10:49:08 +0000 (UTC)
Date:   Wed, 12 May 2021 12:49:06 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 3/3] vfio-ccw: Serialize FSM IDLE state with I/O
 completion
Message-ID: <20210512124906.709d562c.cohuck@redhat.com>
In-Reply-To: <20210511195631.3995081-4-farman@linux.ibm.com>
References: <20210511195631.3995081-1-farman@linux.ibm.com>
        <20210511195631.3995081-4-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 11 May 2021 21:56:31 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Today, the stacked call to vfio_ccw_sch_io_todo() does three things:
> 
>   1) Update a solicited IRB with CP information, and release the CP
>      if the interrupt was the end of a START operation.
>   2) Copy the IRB data into the io_region, under the protection of
>      the io_mutex
>   3) Reset the vfio-ccw FSM state to IDLE to acknowledge that
>      vfio-ccw can accept more work.
> 
> The trouble is that step 3 is (A) invoked for both solicited and
> unsolicited interrupts, and (B) sitting after the mutex for step 2.
> This second piece becomes a problem if it processes an interrupt
> for a CLEAR SUBCHANNEL while another thread initiates a START,
> thus allowing the CP and FSM states to get out of sync. That is:
> 
>     CPU 1                           CPU 2
>     fsm_do_clear()
>     fsm_irq()
>                                     fsm_io_request()
>     vfio_ccw_sch_io_todo()
>                                     fsm_io_helper()
> 
> Since the FSM state and CP should be kept in sync, let's make a
> note when the CP is released, and rely on that as an indication
> that the FSM should also be reset at the end of this routine and
> open up the device for more work.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)

Looking good :)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

