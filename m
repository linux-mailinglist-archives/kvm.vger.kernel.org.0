Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 388252A983
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 13:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfEZL7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 07:59:44 -0400
Received: from www17.your-server.de ([213.133.104.17]:49672 "EHLO
        www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfEZL7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 07:59:44 -0400
X-Greylist: delayed 936 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 May 2019 07:59:43 EDT
Received: from [88.198.220.130] (helo=sslproxy01.your-server.de)
        by www17.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <thomas@m3y3r.de>)
        id 1hUrZO-0001z0-4z; Sun, 26 May 2019 13:44:06 +0200
Received: from [2a02:908:4c22:ec00:915f:2518:d2f6:b586] (helo=maria.localdomain)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <thomas@m3y3r.de>)
        id 1hUrZM-0007qA-Q8; Sun, 26 May 2019 13:44:05 +0200
Received: by maria.localdomain (sSMTP sendmail emulation); Sun, 26 May 2019 13:44:04 +0200
From:   "Thomas Meyer" <thomas@m3y3r.de>
Date:   Sun, 26 May 2019 13:44:04 +0200
Message-Id: <E1hUrZM-0007qA-Q8@sslproxy01.your-server.de>
X-Authenticated-Sender: thomas@m3y3r.de
X-Virus-Scanned: Clear (ClamAV 0.100.3/25461/Sun May 26 09:57:08 2019)
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From thomas@m3y3r.de Sun May 26 00:13:26 2019
Subject: [PATCH] vfio-pci/nvlink2: Use vma_pages function instead of explicit
 computation
To: alex.williamson@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Patch: Cocci
X-Mailer: DiffSplit
Message-ID: <1558822461341-1674464153-1-diffsplit-thomas@m3y3r.de>
References: <1558822461331-726613767-0-diffsplit-thomas@m3y3r.de>
In-Reply-To: <1558822461331-726613767-0-diffsplit-thomas@m3y3r.de>
X-Serial-No: 1

Use vma_pages function on vma object instead of explicit computation.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/vfio/pci/vfio_pci_nvlink2.c b/drivers/vfio/pci/vfio_pci_nvlink2.c
--- a/drivers/vfio/pci/vfio_pci_nvlink2.c
+++ b/drivers/vfio/pci/vfio_pci_nvlink2.c
@@ -161,7 +161,7 @@ static int vfio_pci_nvgpu_mmap(struct vf
 
 	atomic_inc(&data->mm->mm_count);
 	ret = (int) mm_iommu_newdev(data->mm, data->useraddr,
-			(vma->vm_end - vma->vm_start) >> PAGE_SHIFT,
+			vma_pages(vma),
 			data->gpu_hpa, &data->mem);
 
 	trace_vfio_pci_nvgpu_mmap(vdev->pdev, data->gpu_hpa, data->useraddr,
