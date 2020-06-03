Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA321ECE44
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 13:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgFCL10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 07:27:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45135 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725859AbgFCL1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jun 2020 07:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591183643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0fTj5fQOdgWNycfPO0iTGPBBBLkg3emkFGsb1i6/ZK4=;
        b=EP6CizpWW09/74EfkS4nN4LamR53jeyPN7STAgBKW/Vyn+BawktYniiWLp2hq8OU0/GLHJ
        9dHMGMrJNXAKQ1RMKXofbJRsMaRoM8YK5ZU38gd8vkgeYkT1Rt8lJ/EeHiXTfWAsnqG3qS
        YVglXB/vebOItrLWIZmqJa9eSxjUdnM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-424-H6ERAEeCNl2Vnse0jAZ4Sw-1; Wed, 03 Jun 2020 07:27:21 -0400
X-MC-Unique: H6ERAEeCNl2Vnse0jAZ4Sw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F5991883604;
        Wed,  3 Jun 2020 11:27:20 +0000 (UTC)
Received: from localhost (ovpn-112-182.ams2.redhat.com [10.36.112.182])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 329D210016DA;
        Wed,  3 Jun 2020 11:27:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL v2 00/10] vfio-ccw patches for 5.8
Date:   Wed,  3 Jun 2020 13:27:06 +0200
Message-Id: <20200603112716.332801-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit e1750a3d9abbea2ece29cac8dc5a6f5bc19c1492:

  s390/pci: Log new handle in clp_disable_fh() (2020-05-28 12:26:03 +0200)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/vfio-ccw tags/vfio-ccw-20200603-v2

for you to fetch changes up to b2dd9a44a1098c96935c495570b663bd223a087e:

  vfio-ccw: Add trace for CRW event (2020-06-03 11:28:19 +0200)

----------------------------------------------------------------
vfio-ccw updates:
- accept requests without the prefetch bit set
- enable path handling via two new regions

----------------------------------------------------------------

Changes v1->v2:
- add padding to struct ccw_crw_region
- rebase to s390 features branch

Cornelia Huck (1):
  vfio-ccw: document possible errors

Eric Farman (3):
  vfio-ccw: Refactor the unregister of the async regions
  vfio-ccw: Refactor IRQ handlers
  vfio-ccw: Add trace for CRW event

Farhan Ali (5):
  vfio-ccw: Introduce new helper functions to free/destroy regions
  vfio-ccw: Register a chp_event callback for vfio-ccw
  vfio-ccw: Introduce a new schib region
  vfio-ccw: Introduce a new CRW region
  vfio-ccw: Wire up the CRW irq and CRW region

Jared Rossi (1):
  vfio-ccw: Enable transparent CCW IPL from DASD

 Documentation/s390/vfio-ccw.rst     | 100 ++++++++++++++++-
 drivers/s390/cio/Makefile           |   2 +-
 drivers/s390/cio/vfio_ccw_chp.c     | 148 +++++++++++++++++++++++++
 drivers/s390/cio/vfio_ccw_cp.c      |  19 ++--
 drivers/s390/cio/vfio_ccw_drv.c     | 165 ++++++++++++++++++++++++++--
 drivers/s390/cio/vfio_ccw_ops.c     |  65 ++++++++---
 drivers/s390/cio/vfio_ccw_private.h |  16 +++
 drivers/s390/cio/vfio_ccw_trace.c   |   1 +
 drivers/s390/cio/vfio_ccw_trace.h   |  30 +++++
 include/uapi/linux/vfio.h           |   3 +
 include/uapi/linux/vfio_ccw.h       |  19 ++++
 11 files changed, 531 insertions(+), 37 deletions(-)
 create mode 100644 drivers/s390/cio/vfio_ccw_chp.c

-- 
2.25.4

