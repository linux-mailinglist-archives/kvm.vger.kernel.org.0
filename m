Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3D0C2CA3ED
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 14:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390680AbgLANeL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 08:34:11 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:8485 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387578AbgLANeL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 08:34:11 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Cljhz3sStzhl60;
        Tue,  1 Dec 2020 21:33:07 +0800 (CST)
Received: from huawei.com (10.174.185.226) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Dec 2020
 21:33:18 +0800
From:   Xingang Wang <wangxingang5@huawei.com>
To:     <eric.auger@redhat.com>
CC:     <alex.williamson@redhat.com>, <eric.auger.pro@gmail.com>,
        <iommu@lists.linux-foundation.org>, <jean-philippe@linaro.org>,
        <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <maz@kernel.org>, <robin.murphy@arm.com>, <vivek.gautam@arm.com>,
        <will@kernel.org>, <zhangfei.gao@linaro.org>,
        <xieyingtai@huawei.com>
Subject: Re: [PATCH v13 07/15] iommu/smmuv3: Allow stage 1 invalidation with unmanaged ASIDs
Date:   Tue, 1 Dec 2020 13:33:10 +0000
Message-ID: <1606829590-25924-1-git-send-email-wangxingang5@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <20201118112151.25412-8-eric.auger@redhat.com>
References: <20201118112151.25412-8-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric

On  Wed, 18 Nov 2020 12:21:43, Eric Auger wrote:
>@@ -1710,7 +1710,11 @@ static void arm_smmu_tlb_inv_context(void *cookie)
> 	 * insertion to guarantee those are observed before the TLBI. Do be
> 	 * careful, 007.
> 	 */
>-	if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {
>+	if (ext_asid >= 0) { /* guest stage 1 invalidation */
>+		cmd.opcode	= CMDQ_OP_TLBI_NH_ASID;
>+		cmd.tlbi.asid	= ext_asid;
>+		cmd.tlbi.vmid	= smmu_domain->s2_cfg.vmid;
>+	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S1) {

Found a problem here, the cmd for guest stage 1 invalidation is built,
but it is not delivered to smmu.
