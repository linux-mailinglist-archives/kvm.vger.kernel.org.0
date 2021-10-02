Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB7E41FBCE
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhJBMmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:42:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhJBMme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Oct 2021 08:42:34 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E986BC0613EC;
        Sat,  2 Oct 2021 05:40:48 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y5so8069476pll.3;
        Sat, 02 Oct 2021 05:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=boC5DH+e5eDznk4gCfSQd5KzFhA9YXPE0HN8TOlXHRM=;
        b=DrDz4tlLiEuf9X/s3JrTFdv/dbjHHnVXgOJq08OXY9rxryZjAOa0aPLnCA4wrU6kjj
         SGu850FsqNzOzqE8FWNCFQlXlYALzgd9KgSmoAh1dsEfR4zx/5K1bQffnwtwVCxVhy2Z
         16zYnq0qg4NaZGENFiv1m2GJvWw8EgfShf3c2pfRnructRQoWqdlzgLVKuXgL/OhI0Vg
         PFCijxWyRHg0Zbf9Heh5gy5kL8/CodI08EpJfJuugeeukMFy8lMj9/Z46i2xTrxyi4rM
         pEgl1MiIP41gZSoqVz+sD9d5E7b/oFCLvdJyYKEVyX/rZmw9CFA7wdwZ5Zkez11LZ9Nd
         Rdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=boC5DH+e5eDznk4gCfSQd5KzFhA9YXPE0HN8TOlXHRM=;
        b=YCsSakDD7MI/unbWfN1jBCtCMI7PSE91o6/hd/Q//dyPVbvh8rjPCcK6+sCzm8awXG
         y03G1KluRkPaDJq1KkGLm9b+28JPf71CNQn14UKKgkFkg377WKPxp5ZhC9GvIsTYDdp+
         nKQzL5pigRiKDGzU64drb8K5xTuwCMRSiY5PktA2UtTYovT/SY3FJZN2vtf20e2WIXyO
         TogFyoIdr9DqaJcfer+kuY3LRaEKhit+7vYihStynsHTkOmJ5ArWx8mWGTlv5is6LppV
         8v7V8Xl80xovGj86T90JWdmMqCqB8B9ZA1G98CXUjT1VMV67JoESUfu198Qbf3pRXhqn
         JuMg==
X-Gm-Message-State: AOAM531eLE+ZLctufofrUHOmJbGBT2VxRbNRuy8k6KplMJ1cVnnSYQ/O
        s66bz97h4f144GMW8ZYdchykTFh0toQ=
X-Google-Smtp-Source: ABdhPJzDtA/vEzbxkSvzWKRyYY4VFSJIYY3QysxOrL0OPQ4NHudtiWZQ9dn0Lac2J0jbvWPA8DEMJQ==
X-Received: by 2002:a17:902:b909:b0:13a:2d8e:12bc with SMTP id bf9-20020a170902b90900b0013a2d8e12bcmr14245355plb.6.1633178448124;
        Sat, 02 Oct 2021 05:40:48 -0700 (PDT)
Received: from ajay-Latitude-E6320.. ([122.161.244.167])
        by smtp.gmail.com with ESMTPSA id c9sm8760694pgq.58.2021.10.02.05.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:40:47 -0700 (PDT)
From:   Ajay Garg <ajaygargnsit@gmail.com>
To:     linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org
Cc:     Ajay Garg <ajaygargnsit@gmail.com>
Subject: [PATCH] iommu: intel: remove flooding of non-error logs, when new-DMA-PTE is the same as old-DMA-PTE.
Date:   Sat,  2 Oct 2021 18:10:12 +0530
Message-Id: <20211002124012.18186-1-ajaygargnsit@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Taking a SD-MMC controller (over PCI) as an example, following is an
example sequencing, where the log-flooding happened :

0.
We have a host and a guest, both running latest x86_64 kernels.

1.
Host-machine is booted up (with intel_iommu=on), and the DMA-PTEs
are setup for the controller (on the host), for the first time.

2.
The SD-controller device is added to a (L1) guest on a KVM-VM
(via virt-manager).

3.
The KVM-VM is booted up.

4.
Above triggers a re-setup of DMA-PTEs on the host, for a
second time.

It is observed that the new PTEs formed (on the host) are same
as the original PTEs, and thus following logs, accompanied by
stacktraces, overwhelm the logs :

......
 DMAR: ERROR: DMA PTE for vPFN 0x428ec already set (to 3f6ec003 not 3f6ec003)
 DMAR: ERROR: DMA PTE for vPFN 0x428ed already set (to 3f6ed003 not 3f6ed003)
 DMAR: ERROR: DMA PTE for vPFN 0x428ee already set (to 3f6ee003 not 3f6ee003)
 DMAR: ERROR: DMA PTE for vPFN 0x428ef already set (to 3f6ef003 not 3f6ef003)
 DMAR: ERROR: DMA PTE for vPFN 0x428f0 already set (to 3f6f0003 not 3f6f0003)
......

As the PTEs are same, so there is no cause of concern, and we can easily
avoid the logs-flood for this non-error case.

Signed-off-by: Ajay Garg <ajaygargnsit@gmail.com>
---
 drivers/iommu/intel/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index d75f59ae28e6..8bea8b4e3ff9 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2370,7 +2370,7 @@ __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		 * touches the iova range
 		 */
 		tmp = cmpxchg64_local(&pte->val, 0ULL, pteval);
-		if (tmp) {
+		if (tmp && (tmp != pteval)) {
 			static int dumps = 5;
 			pr_crit("ERROR: DMA PTE for vPFN 0x%lx already set (to %llx not %llx)\n",
 				iov_pfn, tmp, (unsigned long long)pteval);
-- 
2.30.2

