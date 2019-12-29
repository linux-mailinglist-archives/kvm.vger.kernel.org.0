Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D518E12C359
	for <lists+kvm@lfdr.de>; Sun, 29 Dec 2019 17:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfL2QTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Dec 2019 11:19:46 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38967
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbfL2QTe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 29 Dec 2019 11:19:34 -0500
X-IronPort-AV: E=Sophos;i="5.69,372,1571695200"; 
   d="scan'208";a="334379018"
Received: from palace.rsr.lip6.fr (HELO palace.lip6.fr) ([132.227.105.202])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/AES128-SHA256; 29 Dec 2019 17:19:30 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kernel-janitors@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] vfio/spapr_tce: use mmgrab
Date:   Sun, 29 Dec 2019 16:42:57 +0100
Message-Id: <1577634178-22530-4-git-send-email-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr>
References: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Mmgrab was introduced in commit f1f1007644ff ("mm: add new mmgrab()
helper") and most of the kernel was updated to use it. Update a
remaining file.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

<smpl>
@@ expression e; @@
- atomic_inc(&e->mm_count);
+ mmgrab(e);
</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/vfio/vfio_iommu_spapr_tce.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
index 26cef65b41e7..16b3adc508db 100644
--- a/drivers/vfio/vfio_iommu_spapr_tce.c
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -79,7 +79,7 @@ static long tce_iommu_mm_set(struct tce_container *container)
 	}
 	BUG_ON(!current->mm);
 	container->mm = current->mm;
-	atomic_inc(&container->mm->mm_count);
+	mmgrab(container->mm);
 
 	return 0;
 }

