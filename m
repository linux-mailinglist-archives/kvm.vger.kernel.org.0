Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B93148B4D
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2020 16:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388377AbgAXPdT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jan 2020 10:33:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30101 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388324AbgAXPdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jan 2020 10:33:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579879997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=32400e5SDnVdKN+d6LwzMdPBXDqrdA6GbCia8UIeK80=;
        b=IiT2QHdyOEL78JeTdOEDYiqTQZojz951/I3KFINwm8rDFLyrN2yNek0kopOK2NQnBwrpoR
        HM/O9euP4Hs0CrcdFZkgPdY8pGFLO6YaA25o46LPDu4PHXLJ1rbbxGDch3gWxjfB5nHkpO
        YAzIpVxmqiyPTnF3rm0WWIqhQmvz8mE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-gDhYxGqAPUu3KrdfgVHCvA-1; Fri, 24 Jan 2020 10:33:13 -0500
X-MC-Unique: gDhYxGqAPUu3KrdfgVHCvA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B948108F245;
        Fri, 24 Jan 2020 15:33:09 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF82A60BE1;
        Fri, 24 Jan 2020 15:33:07 +0000 (UTC)
Date:   Fri, 24 Jan 2020 16:33:05 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Jared Rossi <jrossi@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1 1/1] vfio-ccw: Don't free channel programs for
 unrelated interrupts
Message-ID: <20200124163305.3d6f0d47.cohuck@redhat.com>
In-Reply-To: <20200124145455.51181-2-farman@linux.ibm.com>
References: <20200124145455.51181-1-farman@linux.ibm.com>
        <20200124145455.51181-2-farman@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Jan 2020 15:54:55 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> With the addition of asynchronous channel programs (HALT or CLEAR
> SUBCHANNEL instructions), the hardware can receive interrupts that
> are not related to any channel program currently active.  An attempt
> is made to ensure that only associated resources are freed, but the
> host can fail in unpleasant ways:
> 
> [ 1051.330289] Unable to handle kernel pointer dereference in virtual kernel address space
> [ 1051.330360] Failing address: c880003d16572000 TEID: c880003d16572803
> [ 1051.330365] Fault in home space mode while using kernel ASCE.
> [ 1051.330372] AS:00000000fde9c007 R3:0000000000000024
> ...snip...
> [ 1051.330539]  [<00000000fccbd33e>] __kmalloc+0xd6/0x3d8
> [ 1051.330543] ([<00000000fccbd514>] __kmalloc+0x2ac/0x3d8)
> [ 1051.330550]  [<000003ff801452b4>] cp_prefetch+0xc4/0x3b8 [vfio_ccw]
> [ 1051.330554]  [<000003ff801471e4>] fsm_io_request+0x2d4/0x7b8 [vfio_ccw]
> [ 1051.330559]  [<000003ff80145d9c>] vfio_ccw_mdev_write+0x17c/0x300 [vfio_ccw]
> [ 1051.330564]  [<00000000fccf0d20>] vfs_write+0xb0/0x1b8
> [ 1051.330568]  [<00000000fccf1236>] ksys_pwrite64+0x7e/0xb8
> [ 1051.330574]  [<00000000fd4524c0>] system_call+0xdc/0x2d8
> 
> The problem is corruption of the dma-kmalloc-8 slab [1], if an interrupt
> occurs for a CLEAR or HALT that is not obviously associated with the
> current channel program.  If the channel_program struct is freed AND
> another interrupt for that I/O occurs, then this may occur:
> 
> 583.612967 00          cp_prefetch  NEW SSCH
> 583.613180 03 vfio_ccw_sch_io_todo  orb.cpa=03012690 irb.cpa=03012698
>                                     ccw=2704004203015600 *cda=1955d8fb8
>                                     irb: fctl=4 actl=0 stctl=7
> 587.039292 04          cp_prefetch  NEW SSCH
> 587.039296 01 vfio_ccw_sch_io_todo  orb.cpa=7fe209f0 irb.cpa=03012698
>                                     ccw=3424000c030a4068 *cda=1999e9cf0
>                                     irb: fctl=2 actl=0 stctl=1
> 587.039505 01 vfio_ccw_sch_io_todo  orb.cpa=7fe209f0 irb.cpa=7fe209f8
>                                     ccw=3424000c030a4068 *cda=0030a4070
>                                     irb: fctl=4 actl=0 stctl=7
> 
> Note how the last vfio_ccw_sch_io_todo() call has a ccw.cda that is
> right next to its supposed IDAW, compared to the previous one?  That
> is the result of the previous one freeing the cp (and its IDAL), and
> kfree writing the next available address at the beginning of the
> newly released memory.  When the channel goes to store data, it
> believes the IDAW is valid and overwrites that pointer and causes
> kmalloc to fail some time later.
> 
> Since the vfio-ccw interrupt handler walks the list of ccwchain structs
> to determine if the guest SCSW needs to be updated, it can be changed
> to indicate whether the interrupt points within the channel_program.
> If yes, then the channel_program is valid and its resources can be freed.
> It not, then another interrupt is expected to do that later.
> 
> [1] It could be other dma-kmalloc-xxx slabs; this just happens to be the
> one driven most frequently in my testing.
> 
> Fixes: f4c9939433bd ("vfio-ccw: Don't call cp_free if we are processing a channel program")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_cp.c  | 11 +++++++++--
>  drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
>  drivers/s390/cio/vfio_ccw_drv.c |  4 ++--
>  3 files changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
> index 3645d1720c4b..2d942433baf9 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.c
> +++ b/drivers/s390/cio/vfio_ccw_cp.c
> @@ -803,15 +803,19 @@ union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm)
>   *
>   * This function updates @scsw->cpa to its coressponding guest physical
>   * address.
> + *
> + * Returns true if the channel program address in the irb was found
> + * within the chain of CCWs for this channel program.
>   */
> -void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
> +bool cp_update_scsw(struct channel_program *cp, union scsw *scsw)
>  {
>  	struct ccwchain *chain;
>  	u32 cpa = scsw->cmd.cpa;
>  	u32 ccw_head;
> +	bool within_chain = false;
>  
>  	if (!cp->initialized)
> -		return;
> +		return false;
>  
>  	/*
>  	 * LATER:
> @@ -833,11 +837,14 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
>  			 * head gets us the guest cpa.
>  			 */
>  			cpa = chain->ch_iova + (cpa - ccw_head);
> +			within_chain = true;
>  			break;
>  		}
>  	}
>  
>  	scsw->cmd.cpa = cpa;

Looking at this, I'm wondering why we would want to update the cpa if
!within_chain. But I'm probably too tired to review this properly
today...

> +
> +	return within_chain;
>  }
>  
>  /**
> diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
> index ba31240ce965..a4cb6527bd4e 100644
> --- a/drivers/s390/cio/vfio_ccw_cp.h
> +++ b/drivers/s390/cio/vfio_ccw_cp.h
> @@ -47,7 +47,7 @@ extern int cp_init(struct channel_program *cp, struct device *mdev,
>  extern void cp_free(struct channel_program *cp);
>  extern int cp_prefetch(struct channel_program *cp);
>  extern union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
> -extern void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
> +extern bool cp_update_scsw(struct channel_program *cp, union scsw *scsw);
>  extern bool cp_iova_pinned(struct channel_program *cp, u64 iova);
>  
>  #endif
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index e401a3d0aa57..a8ab256a217b 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -90,8 +90,8 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  	is_final = !(scsw_actl(&irb->scsw) &
>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>  	if (scsw_is_solicited(&irb->scsw)) {
> -		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
> +		if (cp_update_scsw(&private->cp, &irb->scsw) &&
> +		    is_final && private->state == VFIO_CCW_STATE_CP_PENDING)

...but I still wonder why is_final is not catching non-ssch related
interrupts, as I thought it would. We might want to adapt that check,
instead. (Or was the scsw_is_solicited() check supposed to catch that?
As said, too tired right now...)

>  			cp_free(&private->cp);
>  	}
>  	mutex_lock(&private->io_mutex);

