Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975DA37A5CE
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 13:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhEKLdL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 07:33:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231409AbhEKLdL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 07:33:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620732724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=noaKl91GZtjSUFV6u8sREF0taPucQNZsvq/1PFe3aI8=;
        b=CdUqEDq/A7d5FTJOvhLhWrHGq3Pkr10o9K8S+qPwoZQV+yPKfAonmO+2KTdH07oY0/0oPc
        kV9ON2vGDpPk1/XOc0Z8jSwhTPv2FUYIGjpEPDob4DjoAUpa69wjPtG4QkAO7AFUX/J00I
        qwIt5eANUU3BnJk1/ytuVEPv9uBM/W8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-QStnA6OgOfGIT25KW3zosw-1; Tue, 11 May 2021 07:31:59 -0400
X-MC-Unique: QStnA6OgOfGIT25KW3zosw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C473410066E8;
        Tue, 11 May 2021 11:31:58 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-172.ams2.redhat.com [10.36.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7447362499;
        Tue, 11 May 2021 11:31:57 +0000 (UTC)
Date:   Tue, 11 May 2021 13:31:54 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [RFC PATCH v5 3/3] vfio-ccw: Serialize FSM IDLE state with I/O
 completion
Message-ID: <20210511133154.66440087.cohuck@redhat.com>
In-Reply-To: <20210510205646.1845844-4-farman@linux.ibm.com>
References: <20210510205646.1845844-1-farman@linux.ibm.com>
        <20210510205646.1845844-4-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 22:56:46 +0200
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
>  drivers/s390/cio/vfio_ccw_drv.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 8c625b530035..ef39182edab5 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -85,7 +85,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  {
>  	struct vfio_ccw_private *private;
>  	struct irb *irb;
> -	bool is_final;
> +	bool is_final, is_finished = false;

<bikeshed>
"is_finished" does not really say what is finished; maybe call it
"cp_is_finished"?
</bikeshed>

>  
>  	private = container_of(work, struct vfio_ccw_private, io_work);
>  	irb = &private->irb;
> @@ -94,14 +94,16 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>  	if (scsw_is_solicited(&irb->scsw)) {
>  		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
>  			cp_free(&private->cp);
> +			is_finished = true;
> +		}
>  	}
>  	mutex_lock(&private->io_mutex);
>  	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
>  	mutex_unlock(&private->io_mutex);
>  
> -	if (private->mdev && is_final)
> +	if (private->mdev && is_finished)

Maybe add a comment?

/*
 * Reset to idle if processing of a channel program
 * has finished; but do not overwrite a possible
 * processing state if we got a final interrupt for hsch
 * or csch.
 */

Otherwise, I see us scratching our heads again in a few months :)

>  		private->state = VFIO_CCW_STATE_IDLE;
>  
>  	if (private->io_trigger)

Patch looks good to me.

