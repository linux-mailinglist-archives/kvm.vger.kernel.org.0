Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E8A6ACA8A
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 18:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjCFRbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 12:31:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjCFRbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 12:31:38 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2907A6A077
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 09:30:59 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 73F0C37E2D6066;
        Mon,  6 Mar 2023 11:29:54 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id D7rELOLGaTDI; Mon,  6 Mar 2023 11:29:54 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 0548C37E2D6063;
        Mon,  6 Mar 2023 11:29:54 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 0548C37E2D6063
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1678123794; bh=UblfvVqy9JNKkVyg/QuZ/+8/xeR2o4hFr+a9TaQPCgY=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=uHoulabi+TH0mWyAwgoNubPmUcb33a10FRzDDSZPtMCTu4FxE8PB/cSfNfzyGK3rE
         Z3BAGJ6KYPl6nvCWd1eH69hJa1SVQxoulF06TB37Qm/H2LQxaQR0h3ku2vaW2lh8h5
         XKbfRDoAVUfin1LEht5L8wWJ7ZgJefa+Z7h6C9sI=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vkFWYm9eZgZS; Mon,  6 Mar 2023 11:29:53 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id D4B1537E2D6060;
        Mon,  6 Mar 2023 11:29:53 -0600 (CST)
Date:   Mon, 6 Mar 2023 11:29:53 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Cc:     linuxppc-dev@lists.ozlabs.org
Message-ID: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH v2 0/4] Reenable VFIO support on POWER systems
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: uScuXMMJXypW8VSpxfj7HiX7Gk0vWQ==
Thread-Topic: Reenable VFIO support on POWER systems
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series reenables VFIO support on POWER systems.  It
is based on Alexey Kardashevskiys's patch series, rebased and
successfully tested under QEMU with a Marvell PCIe SATA controller
on a POWER9 Blackbird host.

Alexey Kardashevskiy (3):
  powerpc/iommu: Add "borrowing" iommu_table_group_ops
  powerpc/pci_64: Init pcibios subsys a bit later
  powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
    domains

Timothy Pearson (1):
  Add myself to MAINTAINERS for Power VFIO support

 MAINTAINERS                               |   5 +
 arch/powerpc/include/asm/iommu.h          |   6 +-
 arch/powerpc/include/asm/pci-bridge.h     |   7 +
 arch/powerpc/kernel/iommu.c               | 246 +++++++++++++++++++++-
 arch/powerpc/kernel/pci_64.c              |   2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
 arch/powerpc/platforms/pseries/iommu.c    |  27 +++
 arch/powerpc/platforms/pseries/pseries.h  |   4 +
 arch/powerpc/platforms/pseries/setup.c    |   3 +
 drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
 10 files changed, 338 insertions(+), 94 deletions(-)

-- 
2.30.2
