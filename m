Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B7911864
	for <lists+kvm@lfdr.de>; Thu,  2 May 2019 13:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfEBLsw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 07:48:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43082 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726473AbfEBLsw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 07:48:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE9B581224;
        Thu,  2 May 2019 11:48:51 +0000 (UTC)
Received: from maximlenovopc.usersys.redhat.com (unknown [10.35.206.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAC608AD86;
        Thu,  2 May 2019 11:48:46 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-nvme@lists.infradead.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Keith Busch <keith.busch@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Paul E . McKenney " <paulmck@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liang Cunming <cunming.liang@intel.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        Fam Zheng <fam@euphon.net>, Amnon Ilan <ailan@redhat.com>,
        John Ferlan <jferlan@redhat.com>
Subject: [PATCH v2 04/10] nvme/core: add NVME_CTRL_SUSPENDED controller state
Date:   Thu,  2 May 2019 14:47:55 +0300
Message-Id: <20190502114801.23116-5-mlevitsk@redhat.com>
In-Reply-To: <20190502114801.23116-1-mlevitsk@redhat.com>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 02 May 2019 11:48:51 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This state will be used by a controller that is going to
suspended state, and will later be used by mdev
framework to detect this and flush its queues

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/nvme/host/core.c | 15 +++++++++++++++
 drivers/nvme/host/nvme.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2e11d014d514..22db0c51a0bf 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -317,6 +317,19 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		switch (old_state) {
 		case NVME_CTRL_NEW:
 		case NVME_CTRL_RESETTING:
+		case NVME_CTRL_CONNECTING:
+		case NVME_CTRL_SUSPENDED:
+			changed = true;
+			/* FALLTHRU */
+		default:
+			break;
+		}
+		break;
+	case NVME_CTRL_SUSPENDED:
+		switch (old_state) {
+		case NVME_CTRL_NEW:
+		case NVME_CTRL_LIVE:
+		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
 			changed = true;
 			/* FALLTHRU */
@@ -329,6 +342,7 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		case NVME_CTRL_NEW:
 		case NVME_CTRL_LIVE:
 		case NVME_CTRL_ADMIN_ONLY:
+		case NVME_CTRL_SUSPENDED:
 			changed = true;
 			/* FALLTHRU */
 		default:
@@ -351,6 +365,7 @@ bool nvme_change_ctrl_state(struct nvme_ctrl *ctrl,
 		case NVME_CTRL_ADMIN_ONLY:
 		case NVME_CTRL_RESETTING:
 		case NVME_CTRL_CONNECTING:
+		case NVME_CTRL_SUSPENDED:
 			changed = true;
 			/* FALLTHRU */
 		default:
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 527d64545023..d040eb00e880 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -139,6 +139,7 @@ static inline u16 nvme_req_qid(struct request *req)
 enum nvme_ctrl_state {
 	NVME_CTRL_NEW,
 	NVME_CTRL_LIVE,
+	NVME_CTRL_SUSPENDED,
 	NVME_CTRL_ADMIN_ONLY,    /* Only admin queue live */
 	NVME_CTRL_RESETTING,
 	NVME_CTRL_CONNECTING,
-- 
2.17.2

