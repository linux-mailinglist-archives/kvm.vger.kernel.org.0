Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740EC377C8A
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 08:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbhEJGzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 02:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhEJGzf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 May 2021 02:55:35 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD49C061573
        for <kvm@vger.kernel.org>; Sun,  9 May 2021 23:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Sq4XHMDmRvg4zOADmLFRCjprd6ygyX6pUUVYUuxn5Bo=; b=WSSiM+vF8qQ8nLXBxMp64jItAj
        C4spCPQr0Ol97iquceEOYE84KKmfSwI7TO7+9KBRnkPx8x48qRY9wU6GnbakAhMCKPkW3rG1ks0kR
        0dcvxasARFw8YnlHQqgRsZxqc/J9rjA9ya6dJ3Uhv6KfcRwrB/iqBfbMkdmJH4Y1Oc1OBeDQNCbaP
        qgEN76GRschT9ZriyDzP8TdF++5DeTN/jGQElvp6Gin3KRRcYpINUKqJlEQlRh6YI7lEi3iD67hGc
        RgUvOowwKGpj/hh+hRbvDCdOgyvmQedtlXWjsJ/1367C2qXx68cJOPe1ilfdAocYoeOp67APqnmw5
        SwgmcCtA==;
Received: from [2001:4bb8:198:fbc8:e179:16d2:93d1:8e1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lfznr-008Lnz-JD; Mon, 10 May 2021 06:54:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: more iommu dead code removal
Date:   Mon, 10 May 2021 08:53:59 +0200
Message-Id: <20210510065405.2334771-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

this is another series to remove dead code from the IOMMU subsystem,
this time mostly about the hacky code to pass an iommu device in
struct mdev_device and huge piles of support code.  All of this was
merged two years ago and (fortunately) never got used.

Note that the mdev.h changes might have minor contextual conflicts
with the pending work from Jason, but it is trivial to resolve.

Diffstat:
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |    2 
 drivers/iommu/intel/iommu.c                 |  362 ----------------------------
 drivers/iommu/intel/svm.c                   |    6 
 drivers/iommu/iommu.c                       |   57 ----
 drivers/vfio/vfio_iommu_type1.c             |  132 +---------
 include/linux/intel-iommu.h                 |   11 
 include/linux/iommu.h                       |   41 ---
 include/linux/mdev.h                        |   20 -
 8 files changed, 31 insertions(+), 600 deletions(-)
