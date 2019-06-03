Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49AC932DF2
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2019 12:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727488AbfFCKur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jun 2019 06:50:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43860 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfFCKur (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jun 2019 06:50:47 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F30E4309265A;
        Mon,  3 Jun 2019 10:50:46 +0000 (UTC)
Received: from localhost (ovpn-204-96.brq.redhat.com [10.40.204.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 70CC11001E69;
        Mon,  3 Jun 2019 10:50:46 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 1/7] s390/cio: Update SCSW if it points to the end of the chain
Date:   Mon,  3 Jun 2019 12:50:32 +0200
Message-Id: <20190603105038.11788-2-cohuck@redhat.com>
In-Reply-To: <20190603105038.11788-1-cohuck@redhat.com>
References: <20190603105038.11788-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Mon, 03 Jun 2019 10:50:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

Per the POPs [1], when processing an interrupt the SCSW.CPA field of an
IRB generally points to 8 bytes after the last CCW that was executed
(there are exceptions, but this is the most common behavior).

In the case of an error, this points us to the first un-executed CCW
in the chain.  But in the case of normal I/O, the address points beyond
the end of the chain.  While the guest generally only cares about this
when possibly restarting a channel program after error recovery, we
should convert the address even in the good scenario so that we provide
a consistent, valid, response upon I/O completion.

[1] Figure 16-6 in SA22-7832-11.  The footnotes in that table also state
that this is true even if the resulting address is invalid or protected,
but moving to the end of the guest chain should not be a surprise.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Message-Id: <20190514234248.36203-2-farman@linux.ibm.com>
Reviewed-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 0e79799e9a71..6e48b66ae31a 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -886,7 +886,11 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
 	 */
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
 		ccw_head = (u32)(u64)chain->ch_ccw;
-		if (is_cpa_within_range(cpa, ccw_head, chain->ch_len)) {
+		/*
+		 * On successful execution, cpa points just beyond the end
+		 * of the chain.
+		 */
+		if (is_cpa_within_range(cpa, ccw_head, chain->ch_len + 1)) {
 			/*
 			 * (cpa - ccw_head) is the offset value of the host
 			 * physical ccw to its chain head.
-- 
2.20.1

