Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2EB46AA123
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbjCCV2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjCCV2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:28:03 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E4A7D9C
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:28:01 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 0E9F537E2A81C2
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:28:01 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id LmxS3Ypraf3H for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:27:59 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id D432037E2A81BF
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:27:59 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com D432037E2A81BF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1677878879; bh=xzG3bauSC17MMqnDI0TlyJ6yxpVBZ//Zkfp/+8juphk=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=e+Bn5Do2vL3gl8YHWfIYmZu0fVLGJxPL6modmFi3goty2ViJ+FfPWQzAHtMp4Y98X
         t/EJ1c63Oykr4c7tMLhDrm3Jwm2Zk4c7kToVQQ3PxPyWbyt1egvurhfjLQlfhd19Dm
         /Fq7Qo0fbqzPAIijVHwhHbwvBy8YsTXNZn4k0Kmw=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Pl9DMxHKSZN7 for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:27:59 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id AEF8E37E2A81BC
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:27:59 -0600 (CST)
Date:   Fri, 3 Mar 2023 15:27:59 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Message-ID: <906355348.16280452.1677878879601.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH 2/5] powerpc/iommu: Add "borrowing" iommu_table_group_ops
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: fefTu0p8DT2dLQjzD9UzXblSJ2AF+w==
Thread-Topic: powerpc/iommu: Add "borrowing" iommu_table_group_ops
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

PPC64 IOMMU API defines iommu_table_group_ops which handles DMA windows
for PEs: control the ownership, create/set/unset a table the hardware
for dynamic DMA windows (DDW). VFIO uses the API to implement support
on POWER.

So far only PowerNV IODA2 (POWER8 and newer machines) implemented this and other cases (POWER7 or nested KVM) did not and instead reused
existing iommu_table structs. This means 1) no DDW 2) ownership transfer
is done directly in the VFIO SPAPR TCE driver.

Soon POWER is going to get its own iommu_ops and ownership control is
going to move there. This implements spapr_tce_table_group_ops which
borrows iommu_table tables. The upside is that VFIO needs to know less
about POWER.

The new ops returns the existing table from create_table() and
only checks if the same window is already set. This is only going to work
if the default DMA window starts table_group.tce32_start and as big as
pe->table_group.tce32_size (not the case for IODA2+ PowerNV).

This changes iommu_table_group_ops::take_ownership() to return an error
if borrowing a table failed.

This should not cause any visible change in behavior for PowerNV.
pSeries was not that well tested/supported anyway.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
---
 arch/powerpc/include/asm/iommu.h          |  6 +-
 arch/powerpc/kernel/iommu.c               | 98 ++++++++++++++++++++++-
 arch/powerpc/platforms/powernv/pci-ioda.c |  6 +-
 arch/powerpc/platforms/pseries/iommu.c    |  3 +
 drivers/vfio/vfio_iommu_spapr_tce.c       | 94 ++++------------------
 5 files changed, 121 insertions(+), 86 deletions(-)
