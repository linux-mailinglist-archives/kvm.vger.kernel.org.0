Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309805CCF4
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 11:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbfGBJvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 05:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43440 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727128AbfGBJvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 05:51:38 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 184B1C02938A;
        Tue,  2 Jul 2019 09:51:38 +0000 (UTC)
Received: from gondolin (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E60A6F93D;
        Tue,  2 Jul 2019 09:51:37 +0000 (UTC)
Date:   Tue, 2 Jul 2019 11:51:34 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Farhan Ali <alifm@linux.ibm.com>
Cc:     farman@linux.ibm.com, pasic@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC v1 4/4] vfio-ccw: Don't call cp_free if we are processing
 a channel program
Message-ID: <20190702115134.790f8891.cohuck@redhat.com>
In-Reply-To: <31c3c29e3e9c4f0312f9363a1c3a5d22b74f68cb.1561997809.git.alifm@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
        <31c3c29e3e9c4f0312f9363a1c3a5d22b74f68cb.1561997809.git.alifm@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 02 Jul 2019 09:51:38 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  1 Jul 2019 12:23:46 -0400
Farhan Ali <alifm@linux.ibm.com> wrote:

> There is a small window where it's possible that we could be working
> on an interrupt (queued in the workqueue) and setting up a channel
> program (i.e allocating memory, pinning pages, translating address).
> This can lead to allocating and freeing the channel program at the
> same time and can cause memory corruption.

This can only happen if the interrupt is for a halt/clear operation,
right?

> 
> Let's not call cp_free if we are currently processing a channel program.
> The only way we know for sure that we don't have a thread setting
> up a channel program is when the state is set to VFIO_CCW_STATE_CP_PENDING.

I have looked through the code again and I think you are right.

> 
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  drivers/s390/cio/vfio_ccw_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
> index 4e3a903..0357165 100644
> --- a/drivers/s390/cio/vfio_ccw_drv.c
> +++ b/drivers/s390/cio/vfio_ccw_drv.c
> @@ -92,7 +92,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
>  		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
>  	if (scsw_is_solicited(&irb->scsw)) {
>  		cp_update_scsw(&private->cp, &irb->scsw);
> -		if (is_final)
> +		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)

Do we actually want to call cp_update_scsw() unconditionally?

At this point, we know that we have a solicited interrupt; that may be
for several reasons:
- Interrupt for something we issued via ssch; it makes sense to update
  the scsw with the cpa address.
- Interrupt for a csch; the cpa address will be unpredictable, even if
  we did a ssch before. cp_update_scsw() hopefully can deal with that?
  Given that its purpose is to translate the cpa back, any
  unpredictable value in the scsw should be fine in the end.
- Interrupt for a hsch after we did a ssch; the cpa might be valid (see
  figure 16-6).
- Interrupt for a hsch without a prior ssch; we'll end up with an
  unpredictable cpa, again.

So I *think* we're fine with calling cp_update_scsw() in all cases,
even if there's junk in the cpa of the scsw we get from the hardware.
Opinions?

>  			cp_free(&private->cp);
>  	}
>  	mutex_lock(&private->io_mutex);

