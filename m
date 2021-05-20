Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D73F38AC64
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 13:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241363AbhETLij (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 07:38:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241559AbhETLgc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 07:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621510510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Au9nWIMCoQk6wVhEc03Ii+LBKp3hBKUFlVdTr5dd6w=;
        b=Pf/WCO+14mnhKSYmgXvM3RW5kZJUShxM+qsvwwmLg1jZnRScg48Gw2+lYBIMd38PEtuj2r
        /zkScVpYmC92CdASWu4XY9ohS+MEiBaNUyan6t85h9S9sRonPL/rFPGFX5VBGCuux80tg2
        lwTZJPrwNtySIlkXQeUwpu47N1sZnMI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-lE_kh2uONVSGYLKc38e_pA-1; Thu, 20 May 2021 07:35:06 -0400
X-MC-Unique: lE_kh2uONVSGYLKc38e_pA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F32D5107ACF2;
        Thu, 20 May 2021 11:35:03 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-166.ams2.redhat.com [10.36.113.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F44F10013C1;
        Thu, 20 May 2021 11:35:02 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 3/3] vfio-ccw: Serialize FSM IDLE state with I/O completion
Date:   Thu, 20 May 2021 13:34:50 +0200
Message-Id: <20210520113450.267893-4-cohuck@redhat.com>
In-Reply-To: <20210520113450.267893-1-cohuck@redhat.com>
References: <20210520113450.267893-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Today, the stacked call to vfio_ccw_sch_io_todo() does three things:

  1) Update a solicited IRB with CP information, and release the CP
     if the interrupt was the end of a START operation.
  2) Copy the IRB data into the io_region, under the protection of
     the io_mutex
  3) Reset the vfio-ccw FSM state to IDLE to acknowledge that
     vfio-ccw can accept more work.

The trouble is that step 3 is (A) invoked for both solicited and
unsolicited interrupts, and (B) sitting after the mutex for step 2.
This second piece becomes a problem if it processes an interrupt
for a CLEAR SUBCHANNEL while another thread initiates a START,
thus allowing the CP and FSM states to get out of sync. That is:

    CPU 1                           CPU 2
    fsm_do_clear()
    fsm_irq()
                                    fsm_io_request()
    vfio_ccw_sch_io_todo()
                                    fsm_io_helper()

Since the FSM state and CP should be kept in sync, let's make a
note when the CP is released, and rely on that as an indication
that the FSM should also be reset at the end of this routine and
open up the device for more work.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20210511195631.3995081-4-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 8c625b530035..9b61e9b131ad 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -86,6 +86,7 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	struct vfio_ccw_private *private;
 	struct irb *irb;
 	bool is_final;
+	bool cp_is_finished = false;
 
 	private = container_of(work, struct vfio_ccw_private, io_work);
 	irb = &private->irb;
@@ -94,14 +95,21 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 		     (SCSW_ACTL_DEVACT | SCSW_ACTL_SCHACT));
 	if (scsw_is_solicited(&irb->scsw)) {
 		cp_update_scsw(&private->cp, &irb->scsw);
-		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING)
+		if (is_final && private->state == VFIO_CCW_STATE_CP_PENDING) {
 			cp_free(&private->cp);
+			cp_is_finished = true;
+		}
 	}
 	mutex_lock(&private->io_mutex);
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
 	mutex_unlock(&private->io_mutex);
 
-	if (private->mdev && is_final)
+	/*
+	 * Reset to IDLE only if processing of a channel program
+	 * has finished. Do not overwrite a possible processing
+	 * state if the final interrupt was for HSCH or CSCH.
+	 */
+	if (private->mdev && cp_is_finished)
 		private->state = VFIO_CCW_STATE_IDLE;
 
 	if (private->io_trigger)
-- 
2.31.1

