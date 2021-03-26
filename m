Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359A634A185
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 07:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhCZGNw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 02:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhCZGNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Mar 2021 02:13:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE68CC0613B1;
        Thu, 25 Mar 2021 23:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=vZFXjwDFBlt15FbbxH8vQOkVklkvteOsEp/Orr07Xyg=; b=2+gf1yHr8gEbFj+N4OJDIkdOzH
        1hQ95DPpzv3ZV+HEoKdNqXg1LoZ/CZVyfn4kmwrMnyoF92NltPaIDzQemqvl47ydc38iAx5Xc9duE
        SvWdyKp6ZrZRqD35Q0w0eC5i6W5jQZqmhSJlzxgBRvt1Rcmu1cPsyAvstO6ROjCwoO8am6QiSFLfu
        Cvgk+lZwd2qb8ecjiKy88HEl0TgZ2L3ZsqAH1s0jTYknSqwuCsSXU98JpAKH/rJyVYShCPQ0tPBaj
        0fr1QXjR0kY18M1p/JiD2YRtpSybZ04Y/KL2rwTFNYKARMEJBrr0cpVgB+98QT2re7IbJ76v2XQEt
        ZGzOfSzQ==;
Received: from [2001:4bb8:191:f692:97ff:1e47:aee2:c7e5] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lPfib-005AmU-19; Fri, 26 Mar 2021 06:13:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Michael Ellerman <mpe@ellerman.id.au>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-api@vger.kernel.org
Subject: remove the nvlink2 pci_vfio subdriver v2
Date:   Fri, 26 Mar 2021 07:13:09 +0100
Message-Id: <20210326061311.1497642-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

the nvlink2 vfio subdriver is a weird beast.  It supports a hardware
feature without any open source component - what would normally be
the normal open source userspace that we require for kernel drivers,
although in this particular case user space could of course be a
kernel driver in a VM.  It also happens to be a complete mess that
does not properly bind to PCI IDs, is hacked into the vfio_pci driver
and also pulles in over 1000 lines of code always build into powerpc
kernels that have Power NV support enabled.  Because of all these
issues and the lack of breaking userspace when it is removed I think
the best idea is to simply kill.

Changes since v1:
 - document the removed subtypes as reserved
 - add the ACK from Greg

Diffstat:
 arch/powerpc/platforms/powernv/npu-dma.c     |  705 ---------------------------
 b/arch/powerpc/include/asm/opal.h            |    3 
 b/arch/powerpc/include/asm/pci-bridge.h      |    1 
 b/arch/powerpc/include/asm/pci.h             |    7 
 b/arch/powerpc/platforms/powernv/Makefile    |    2 
 b/arch/powerpc/platforms/powernv/opal-call.c |    2 
 b/arch/powerpc/platforms/powernv/pci-ioda.c  |  185 -------
 b/arch/powerpc/platforms/powernv/pci.c       |   11 
 b/arch/powerpc/platforms/powernv/pci.h       |   17 
 b/arch/powerpc/platforms/pseries/pci.c       |   23 
 b/drivers/vfio/pci/Kconfig                   |    6 
 b/drivers/vfio/pci/Makefile                  |    1 
 b/drivers/vfio/pci/vfio_pci.c                |   18 
 b/drivers/vfio/pci/vfio_pci_private.h        |   14 
 b/include/uapi/linux/vfio.h                  |   38 -
 drivers/vfio/pci/vfio_pci_nvlink2.c          |  490 ------------------
 16 files changed, 12 insertions(+), 1511 deletions(-)
