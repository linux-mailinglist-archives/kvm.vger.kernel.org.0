Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C874A1D36F8
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 18:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgENQv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 12:51:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48495 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725975AbgENQv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 12:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589475116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=9NDpO6ne1oX6puFusLi9MT5jheUbCdzi50HXZXuFYME=;
        b=hwyr+/vKTbWHwZCtBx79ITs4/RpbAj7IB+BwfwyKGTl14nRKurSIclDhipNSVCpiSCfaDi
        MfQsC8LO4IRPwtk4TW6mwy5ibBrbjpzIpzNWf8GM02X3vPQMQlPFJWFRkXv0CZlXaRTxoo
        kUvsaXdblexf8pLVFDIoKodXvqksVp8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-xOZiXWc8OXyREJq3fKHouQ-1; Thu, 14 May 2020 12:51:54 -0400
X-MC-Unique: xOZiXWc8OXyREJq3fKHouQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 388EA1899528;
        Thu, 14 May 2020 16:51:53 +0000 (UTC)
Received: from gimli.home (ovpn-113-111.phx2.redhat.com [10.3.113.111])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 424465C1BE;
        Thu, 14 May 2020 16:51:47 +0000 (UTC)
Subject: [PATCH 0/2] vfio/type1/pci: IOMMU PFNMAP invalidation
From:   Alex Williamson <alex.williamson@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, cohuck@redhat.com, jgg@ziepe.ca,
        peterx@redhat.com
Date:   Thu, 14 May 2020 10:51:46 -0600
Message-ID: <158947414729.12590.4345248265094886807.stgit@gimli.home>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a follow-on series to "vfio-pci: Block user access to disabled
device MMIO"[1], which extends user access blocking of disabled MMIO
ranges to include unmapping the ranges from the IOMMU.  The first patch
adds an invalidation callback path, allowing vfio bus drivers to signal
the IOMMU backend to unmap ranges with vma level granularity.  This
signaling is done both when the MMIO range becomes inaccessible due to
memory disabling, as well as when a vma is closed, making up for the
lack of tracking or pinning for non-page backed vmas.  The second
patch adds registration and testing interfaces such that the IOMMU
backend driver can test whether a given PFNMAP vma is provided by a
vfio bus driver supporting invalidation.  We can then implement more
restricted semantics to only allow PFNMAP DMA mappings when we have
such support, which becomes the new default.

Jason, if you'd like Suggested-by credit for the ideas here I'd be
glad to add it.  Thanks,

Alex

[1]https://lore.kernel.org/kvm/158871401328.15589.17598154478222071285.stgit@gimli.home/

---

Alex Williamson (2):
      vfio: Introduce bus driver to IOMMU invalidation interface
      vfio: Introduce strict PFNMAP mappings


 drivers/vfio/pci/vfio_pci.c         |   41 ++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |    1 
 drivers/vfio/vfio.c                 |   76 ++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c     |  130 +++++++++++++++++++++++++++--------
 include/linux/vfio.h                |    9 ++
 5 files changed, 222 insertions(+), 35 deletions(-)

