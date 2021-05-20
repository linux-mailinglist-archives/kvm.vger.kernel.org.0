Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E06138AC61
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 13:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241899AbhETLia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 07:38:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241356AbhETLg0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 May 2021 07:36:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621510503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3OVBDZCb6MIQPs6dPbIQhHKwZvFJuf68f56hTGwMOrY=;
        b=GFES1iEGHyJvP02hCPLRfG5rFWckEk7gWxgPmhpF3oHyOllqdbf/lGwtnNdw95CydPWomw
        svlM41dDC8V0tYtXMciHrM8RaB8v3le/M3GZPLxRhgmFDm8QWDmfcznMRJy1zFXJXjTidr
        Mgo4+JgzUgVs2Ril6eq1Ufk+Ff1SXjI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-UKu6pWHXNzuw252w3cqO5g-1; Thu, 20 May 2021 07:34:58 -0400
X-MC-Unique: UKu6pWHXNzuw252w3cqO5g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 535E7100960F;
        Thu, 20 May 2021 11:34:57 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-166.ams2.redhat.com [10.36.113.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3D5D10016F2;
        Thu, 20 May 2021 11:34:55 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: [PULL 1/3] vfio-ccw: Check initialized flag in cp_init()
Date:   Thu, 20 May 2021 13:34:48 +0200
Message-Id: <20210520113450.267893-2-cohuck@redhat.com>
In-Reply-To: <20210520113450.267893-1-cohuck@redhat.com>
References: <20210520113450.267893-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

We have a really nice flag in the channel_program struct that
indicates if it had been initialized by cp_init(), and use it
as a guard in the other cp accessor routines, but not for a
duplicate call into cp_init(). The possibility of this occurring
is low, because that flow is protected by the private->io_mutex
and FSM CP_PROCESSING state. But then why bother checking it
in (for example) cp_prefetch() then?

Let's just be consistent and check for that in cp_init() too.

Fixes: 71189f263f8a3 ("vfio-ccw: make it safe to access channel programs")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Acked-by: Matthew Rosato <mjrosato@linux.ibm.com>
Message-Id: <20210511195631.3995081-2-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index b9febc581b1f..8d1b2771c1aa 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -638,6 +638,10 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 1);
 	int ret;
 
+	/* this is an error in the caller */
+	if (cp->initialized)
+		return -EBUSY;
+
 	/*
 	 * We only support prefetching the channel program. We assume all channel
 	 * programs executed by supported guests likewise support prefetching.
-- 
2.31.1

