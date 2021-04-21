Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EC7366923
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 12:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238732AbhDUK1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 06:27:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238390AbhDUK1J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Apr 2021 06:27:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619000796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bjglrOe7R8vsi2nemsozqNa/o3uknpFaJaifsKU0JIc=;
        b=TxUrpOCF3AZ72YfIYfvVoUXlrW8kg8Engk8fPft7zIEm+qp0o3kLuGqVhfQnmq7x3XtGLw
        usgRCCqa53FUMw0hvK/HPMuygVsIJgCmCOT5I/YFsHUGP2ehLHLoXcoHEXtN5L7g5dN/av
        +JexAm3FNLrcb5OiSLblBj+aHWM5cPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-Yqu4U4LhNAu4XZj8RLpP3Q-1; Wed, 21 Apr 2021 06:25:34 -0400
X-MC-Unique: Yqu4U4LhNAu4XZj8RLpP3Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58CB3107ACE4;
        Wed, 21 Apr 2021 10:25:33 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-112-160.ams2.redhat.com [10.36.112.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F0A7D10016FE;
        Wed, 21 Apr 2021 10:25:31 +0000 (UTC)
Date:   Wed, 21 Apr 2021 12:25:29 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v4 4/4] vfio-ccw: Reset FSM state to IDLE before
 io_mutex
Message-ID: <20210421122529.6e373a39.cohuck@redhat.com>
In-Reply-To: <20210413182410.1396170-5-farman@linux.ibm.com>
References: <20210413182410.1396170-1-farman@linux.ibm.com>
        <20210413182410.1396170-5-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Apr 2021 20:24:10 +0200
Eric Farman <farman@linux.ibm.com> wrote:

> Today, the stacked call to vfio_ccw_sch_io_todo() does three things:
> 
> 1) Update a solicited IRB with CP information, and release the CP
> if the interrupt was the end of a START operation.
> 2) Copy the IRB data into the io_region, under the protection of
> the io_mutex
> 3) Reset the vfio-ccw FSM state to IDLE to acknowledge that
> vfio-ccw can accept more work.
> 
> The trouble is that step 3 is (A) invoked for both solicited and
> unsolicited interrupts, and (B) sitting after the mutex for step 2.
> This second piece becomes a problem if it processes an interrupt
> for a CLEAR SUBCHANNEL while another thread initiates a START,
> thus allowing the CP and FSM states to get out of sync. That is:
> 
> 	CPU 1				CPU 2
> 	fsm_do_clear()
> 	fsm_irq()
> 					fsm_io_request()
> 					fsm_io_helper()
> 	vfio_ccw_sch_io_todo()
> 					fsm_irq()
> 					vfio_ccw_sch_io_todo()
> 
> Let's move the reset of the FSM state to the point where the
> channel_program struct is cleaned up, which is only done for
> solicited interrupts anyway.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 8c625b530035..e51318f23ca8 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -94,16 +94,15 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>  	if (scsw_is_solicited(&irb->scsw)) {
>  		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
>  			cp_free(&private->cp);
> +			private->state = VFIO_CCW_STATE_IDLE;
> +		}
>  	}
>  	mutex_lock(&private->io_mutex);
>  	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
>  	mutex_unlock(&private->io_mutex);
>  
> -	if (private->mdev && is_final)
> -		private->state = VFIO_CCW_STATE_IDLE;

Isn't that re-allowing new I/O requests a bit too early? Maybe remember
that we had a final I/O interrupt for an I/O request and only change
the state in this case?


> -
>  	if (private->io_trigger)
>  		eventfd_signal(private->io_trigger, 1);
>  }

