Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94242600FD
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 08:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfGEGVn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 02:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53980 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727753AbfGEGVn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 02:21:43 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 59B798762F;
        Fri,  5 Jul 2019 06:21:43 +0000 (UTC)
Received: from localhost (ovpn-116-51.ams2.redhat.com [10.36.116.51])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BDE68E9F8;
        Fri,  5 Jul 2019 06:21:41 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 1/1] vfio-ccw: Fix the conversion of Format-0 CCWs to Format-1
Date:   Fri,  5 Jul 2019 08:21:32 +0200
Message-Id: <20190705062132.20755-2-cohuck@redhat.com>
In-Reply-To: <20190705062132.20755-1-cohuck@redhat.com>
References: <20190705062132.20755-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 05 Jul 2019 06:21:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

When processing Format-0 CCWs, we use the "len" variable as the
number of CCWs to convert to Format-1.  But that variable
contains zero here, and is not a meaningful CCW count until
ccwchain_calc_length() returns.  Since that routine requires and
expects Format-1 CCWs to identify the chaining behavior, the
format conversion must be done first.

Convert the 2KB we copied even if it's more than we need.

Fixes: 7f8e89a8f2fd ("vfio-ccw: Factor out the ccw0-to-ccw1 transition")
Reported-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20190702180928.18113-1-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index a7b9dfd5b464..1d4c893ead23 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -431,7 +431,7 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 
 	/* Convert any Format-0 CCWs to Format-1 */
 	if (!cp->orb.cmd.fmt)
-		convert_ccw0_to_ccw1(cp->guest_cp, len);
+		convert_ccw0_to_ccw1(cp->guest_cp, CCWCHAIN_LEN_MAX);
 
 	/* Count the CCWs in the current chain */
 	len = ccwchain_calc_length(cda, cp);
-- 
2.20.1

