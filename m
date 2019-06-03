Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA0032DF4
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 12:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfFCKuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 06:50:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbfFCKuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 06:50:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9F54D2F8BCA;
        Mon,  3 Jun 2019 10:50:49 +0000 (UTC)
Received: from localhost (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EDD56062D;
        Mon,  3 Jun 2019 10:50:48 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 2/7] s390/cio: Set vfio-ccw FSM state before ioeventfd
Date:   Mon,  3 Jun 2019 12:50:33 +0200
Message-Id: <20190603105038.11788-3-cohuck@redhat.com>
In-Reply-To: <20190603105038.11788-1-cohuck@redhat.com>
References: <20190603105038.11788-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 03 Jun 2019 10:50:49 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Otherwise, the guest can believe it's okay to start another I/O
and bump into the non-idle state.  This results in a cc=2 (with
the asynchronous CSCH/HSCH code) returned to the guest, which is
unfortunate since everything is otherwise working normally.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Message-Id: <20190514234248.36203-3-farman@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index ee8767f5845a..66a66ac1f3d1 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -95,11 +95,11 @@ static void vfio_ccw_sch_io_todo(struct work_struct *work)
 	memcpy(private->io_region->irb_area, irb, sizeof(*irb));
 	mutex_unlock(&private->io_mutex);
 
-	if (private->io_trigger)
-		eventfd_signal(private->io_trigger, 1);
-
 	if (private->mdev && is_final)
 		private->state = VFIO_CCW_STATE_IDLE;
+
+	if (private->io_trigger)
+		eventfd_signal(private->io_trigger, 1);
 }
 
 /*
-- 
2.20.1

