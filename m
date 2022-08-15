Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95DEC593532
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 20:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbiHOSVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 14:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240497AbiHOSUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 14:20:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A642A730;
        Mon, 15 Aug 2022 11:16:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZXH9zGhmkKxoilZHg/Lc/WPfJ7cgwqCALMm3Fkb52iFAhvCW2Z2lOcmw6etPB7WYcFQVL3SaU+ElCmGOFp06ldGwUeax0S8oRWuoHikBi8jvMT3feaTwssofSxHstBuYr+X9uA9cQTDZomaGmxnWTLG/iKjRI3aLs2F4prOHBCoiS+XAIud1wyzhxvaMSa7uoRrdua9BVqwnCZ7uJWrVZb4NsjTq18agv3wow+sTEBgBOUiFE0RnH8a24f2AXC1pHGj8mCGW7/rLTMPG6oznh3XYZTQmPJgeal0D6pUoclkFK9eQtJmsc+t06doDHwytFUZSI3/54XFBfB4C7w53Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cz4dKs4M8LotOQ3mq+dlLOExrZWEEoncspj4cooOucQ=;
 b=me366VbprlsdIZhGvTeoqn/GkuMk4KmaIs0EsM+kIWGbwD+eUO/8pkrAftWuN9WpPmeVVbFrrIFB5B2LcG8kh5UYu+Wqfzbu5N8a4BV5E4VTVa4Y6trK9gIvcKr4+TB1vmzhNzwSqxPh7cTatf/45mHo5U5I51C3fY1Aq0frM+IkeCRqghtsrfBrLjFRbb5BvcOptddDyW5PxFCpcVy8AO9a7ugRP+rBzCMyY65/BB7im+6OcydnEW9SGzq+sR5zVqw3XnOVvf53dN2ZlwN5cgvRFf4uMMsGNb5X+CcCFYUz0u31/nvu/bxmTFz9xdsCg2HtTyUb+L7FhXeulQXDEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=rosenzweig.io smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cz4dKs4M8LotOQ3mq+dlLOExrZWEEoncspj4cooOucQ=;
 b=Z+ptxr4EzfSet2jHjIK+WjlqVuc8ofzvOy23a1L0CCnrB2f+mjxCBxFqHH/EiHMqQvBsqRwei5id/zqSLvfQUOKt4rwIIn9RYaVLwP2z8ZQZMDyZ9xMRvHnmZ8+HWz7PbJR44ctEwoGq8PsXMc3KDGx98ivrkXK6ViKW7sSJfFyXPpR9BqG1R62Qr/E2nm38SzMpSqCggraxNqN9G/JSueju/wa0V86sqTFPh1GjzE3ogILIwJe9xxAqhW0/SmgJPn9vpW3i6MYp+PB4E6SX/b9d0mHyHZ5hszZFfUkmnanA3VsUAElXneUJZb8peZc3o1EkgKzFoQWoh2Fdx3GQ4A==
Received: from DM6PR12CA0022.namprd12.prod.outlook.com (2603:10b6:5:1c0::35)
 by MN2PR12MB3453.namprd12.prod.outlook.com (2603:10b6:208:c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 15 Aug
 2022 18:16:37 +0000
Received: from DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::d2) by DM6PR12CA0022.outlook.office365.com
 (2603:10b6:5:1c0::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Mon, 15 Aug 2022 18:16:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT113.mail.protection.outlook.com (10.13.173.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5546.7 via Frontend Transport; Mon, 15 Aug 2022 18:16:37 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Mon, 15 Aug 2022 18:14:50 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Mon, 15 Aug 2022 11:14:49 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Mon, 15 Aug 2022 11:14:47 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
        <alex.williamson@redhat.com>
CC:     <suravee.suthikulpanit@amd.com>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <alyssa@rosenzweig.io>,
        <robdclark@gmail.com>, <dwmw2@infradead.org>,
        <baolu.lu@linux.intel.com>, <mjrosato@linux.ibm.com>,
        <gerald.schaefer@linux.ibm.com>, <orsonzhai@gmail.com>,
        <baolin.wang@linux.alibaba.com>, <zhang.lyra@gmail.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <jean-philippe@linaro.org>,
        <cohuck@redhat.com>, <jgg@nvidia.com>, <tglx@linutronix.de>,
        <shameerali.kolothum.thodi@huawei.com>,
        <thunder.leizhen@huawei.com>, <christophe.jaillet@wanadoo.fr>,
        <yangyingliang@huawei.com>, <jon@solid-run.com>,
        <iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
        <asahi@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kevin.tian@intel.com>
Subject: [PATCH v6 2/5] vfio/iommu_type1: Prefer to reuse domains vs match enforced cache coherency
Date:   Mon, 15 Aug 2022 11:14:34 -0700
Message-ID: <20220815181437.28127-3-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220815181437.28127-1-nicolinc@nvidia.com>
References: <20220815181437.28127-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a4977c7-0155-44d1-2b43-08da7eea4b0c
X-MS-TrafficTypeDiagnostic: MN2PR12MB3453:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P4jC+NffVH3HGayyE+Tj59H3BENIdafaISvO2y0WUe6Eq7lJ5oMDsQ5AvbTg5r11Yz74zSsJhHBbXjMEGfMDjwjeD5r160HkV8zN0aUen8VCc4ivNeJQVepZbv3Qu9RwYcIEJ2fR1cCSZ48ESkgcJul7jAqNFzNfjE5xHPlI3CR4z9sJ569dYb1E0N5rVgqzedtTf3XeEL7mPe+IUYNUYsOsLXgTlFeOw9tlaO6SsakVCDewitERWOl9gbBczPOzzypm0dOP+NZsAcoo51UQG0eAVdiK9iwq0b+RuP/iO9bS+40RogvjikNfPF1b86DRB9dyzmTPtx1AH4oFDBBmS1XhOAjfCbjSwYvqEEpDYPwN878gV8GV7lftOTiFBdsJfu1rCMgom3+ok8QVia1SJLclkEYlHece2mn1EoRpb413F939QF0xBHPhzhesZsFHoh2X3KASwQaVMAWyhqieb3l4NkC6PKVbTGNw6fkci+7gQqEKXOG7P85rUHqytlZAd0AwbbKmyG8f5NWFCXmMJvrxj75hNXr8OVjM1fDNg0ODBYDEkeu6q49yWafuBmaWSwGlUW/z5hd8PpEKbBfToffajljyYCv8ZESJ6Ek9v8phDi4u2n/VIXpBlBrNlmWmtXiCb1UVGvmYAS04AlAJQs7DPP0jdHkB7ZiJpurVhS8c4sWreIbDAPjZax8Qt6JIeu0BunKk8Y3HyZiIqF/ZuRDt/Q0t1xViiA1fUEKpveTkx/L1V+SSPqGuLOlk3aD6RPYCOz3XgcsyDYBs18nErrNE4jNHsjNNT0MvtcZRjSTxZ+9a0LUMk+0djKfUTUjN+wp9kfTsduoZUKw3DPPr2Q==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(136003)(396003)(36840700001)(40470700004)(46966006)(70586007)(7416002)(478600001)(4326008)(8936002)(2906002)(5660300002)(70206006)(356005)(82740400003)(7406005)(81166007)(40480700001)(6666004)(2616005)(1076003)(7696005)(26005)(186003)(41300700001)(40460700003)(36860700001)(336012)(426003)(8676002)(82310400005)(110136005)(54906003)(47076005)(86362001)(83380400001)(316002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 18:16:37.1476
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a4977c7-0155-44d1-2b43-08da7eea4b0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3453
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The KVM mechanism for controlling wbinvd is based on OR of the coherency
property of all devices attached to a guest, no matter whether those
devices are attached to a single domain or multiple domains.

On the other hand, the benefit to using separate domains was that those
devices attached to domains supporting enforced cache coherency always
mapped with the attributes necessary to provide that feature, therefore
if a non-enforced domain was dropped, the associated group removal would
re-trigger an evaluation by KVM.

In practice however, the only known cases of such mixed domains included
an Intel IGD device behind an IOMMU lacking snoop control, where such
devices do not support hotplug, therefore this scenario lacks testing and
is not considered sufficiently relevant to support.

After all, KVM won't take advantage of trying to push a device that could
do enforced cache coherency to a dedicated domain vs re-using an existing
domain, which is non-coherent.

Simplify this code and eliminate the test. This removes the only logic
that needed to have a dummy domain attached prior to searching for a
matching domain and simplifies the next patches.

It's unclear whether we want to further optimize the Intel driver to
update the domain coherency after a device is detached from it, at
least not before KVM can be verified to handle such dynamics in related
emulation paths (wbinvd, vcpu load, write_cr0, ept, etc.). In reality
we don't see an usage requiring such optimization as the only device
which imposes such non-coherency is Intel GPU which even doesn't
support hotplug/hot remove.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index db516c90a977..88ee6aaf1c88 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2296,9 +2296,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	 * testing if they're on the same bus_type.
 	 */
 	list_for_each_entry(d, &iommu->domain_list, next) {
-		if (d->domain->ops == domain->domain->ops &&
-		    d->enforce_cache_coherency ==
-			    domain->enforce_cache_coherency) {
+		if (d->domain->ops == domain->domain->ops) {
 			iommu_detach_group(domain->domain, group->iommu_group);
 			if (!iommu_attach_group(d->domain,
 						group->iommu_group)) {
-- 
2.17.1

