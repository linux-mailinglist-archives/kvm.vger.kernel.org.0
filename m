Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCC310689
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 11:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfEAJsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 05:48:19 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55024 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726145AbfEAJsS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 05:48:18 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BC752D90602CEF28528A;
        Wed,  1 May 2019 17:48:14 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 17:48:06 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
CC:     <marc.zyngier@arm.com>, <christoffer.dall@arm.com>,
        <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <james.morse@arm.com>,
        <julien.thierry@arm.com>, <suzuki.poulose@arm.com>,
        <steve.capper@arm.com>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH 0/5] KVM: arm64: Add support for contiguous PTE/PMD hugepages at stage2
Date:   Wed, 1 May 2019 09:44:22 +0000
Message-ID: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, we support the following page sizes at stage2:

                PTE     PMD     PUD
               -----   -----   -----
 4K granule:     4K      2M      1G
16K granule:    16K     32M
64K granule:    64K    512M

And we have Contiguous bit[52] in stage2 VMSAv8-64 block and page
descriptors. As ARM ARM said, when the value of the Contiguous bit
is 1, it indicates that the entry is one of a number of adjacent
translation table entries that point to a contiguous output address
range.

This series add support for contiguous PTE/PMD hugepages at stage2
and then we can create huge mappings with following additional
sizes:

                CONT PTE     CONT PMD
                --------     --------
 4K granule:      64K          32M
16K granule:       2M           1G
64K granule:       2M          16G

These patches are based on v5.1.0-rc7 and have been tested on
Taishan 2280 server (D05) with 4K and 64K granule.

Any comments will be appreciated, thanks!

Zenghui Yu (5):
  KVM: arm/arm64: Introduce helpers for page table enties with
    contiguous bit
  KVM: arm/arm64: Re-factor building the stage2 page table entries
  KVM: arm/arm64: Support dirty page tracking for contiguous hugepages
  KVM: arm/arm64: Add support for creating PTE contiguous hugepages at
    stage2
  KVM: arm/arm64: Add support for creating PMD contiguous hugepages at
    stage2

 arch/arm/include/asm/kvm_mmu.h       |  22 +++
 arch/arm/include/asm/pgtable-hwdef.h |   8 +
 arch/arm64/include/asm/kvm_mmu.h     |  20 +++
 virt/kvm/arm/mmu.c                   | 299 ++++++++++++++++++++++++++++++-----
 4 files changed, 312 insertions(+), 37 deletions(-)

-- 
1.8.3.1


