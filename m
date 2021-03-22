Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0CB344889
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhCVPDf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbhCVPDW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:03:22 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF19AC061574;
        Mon, 22 Mar 2021 08:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=bamDW4tWcmpmZWtEFDiJV/rlKK4CXzfvVah3vZuv+e0=; b=LN85Wn8UXptFXqz3UeBXxEjrk3
        TaNR1fSXx70W3k3pqxmJMNSmMSyG30XAfn5WHtIpRFdRzG722/sEBt8Ai703dXt5ByhZ3WJazJ16D
        aWE5uiHAPKJ4q00gLHR8zZXJ9jO1VIQbqtcG4MabhmLO43TQGqeSI5zgK5Qo1eYkKGIFHnhHvJgXj
        IoR4nFztMsLM6OiFtkvOfK6qBKOiX8jMTK5814ewuRq1nRNeikfGmHw4mvXi9wny6rPuRAQjgG6yG
        yoD2Hbjt0g+W7KBkM0plnba+jhx9E23uFqHG8f3NvdALkicqPSGgJPG97oMNvgHWLON5jl9AsbNPa
        /LCyxTuA==;
Received: from [2001:4bb8:191:f692:8c8d:c425:8476:e5e8] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOM44-008gT8-H3; Mon, 22 Mar 2021 15:02:06 +0000
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
Subject: remove the nvlink2 pci_vfio subdriver
Date:   Mon, 22 Mar 2021 16:01:53 +0100
Message-Id: <20210322150155.797882-1-hch@lst.de>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
 b/include/uapi/linux/vfio.h                  |   40 -
 drivers/vfio/pci/vfio_pci_nvlink2.c          |  490 ------------------
 16 files changed, 8 insertions(+), 1517 deletions(-)
