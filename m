Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B2A54D5AD
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 02:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348987AbiFPADX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 20:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346372AbiFPADT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 20:03:19 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74EB4C7BD;
        Wed, 15 Jun 2022 17:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nw5PyHSyCB2Sxt4jKDfqj7u1zLYEG2Xcj1fFolsScreoDFQ8mbRNU5wfbHlLemd9YDXx6J491AecpfI7PmlJN74jVhY630fppegsnyReH/JuyirXJWzLE9Tz7N7cZQoFViXwViL4R9DDCoJd0K8Mv64fLlET3EqPaShHHTIEwotgYMS6ZYRnNglRPBz10CHoTOxcd+vjaXMUfDFswRFR9okYo7Vb4/68TCyKUJ7ttx3AKVBG0zyrLue1SE/RGbowiiuJvVxlLeLIOMYhhXNzwE38HiqWaTrOlDS1UInKqoq3D8+HBQSjuVr8yk4+4ZuUozxYSkg886Hy9/pV5RyACg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jauZu1JZ0EjRRsLjq+9fYvdku8WhvGC8mvSh+MRyeuU=;
 b=h1w6OST3OSxJU8HzevC7/YJ18RZuXM2RiPtcdyjGR0Ls8N40HXlrpmSWcAAjdRFmDxtVz8y+y2oeFDBFVgAqymmJAM62843LRUVFE48Tv0BMRbCYN8BfnVLu3pJ0HUr6tpxcW4mdKc29VI9Fj3mC/G8UfHqz9jYhpS4zvnkNU5nEODp5f8B9XVKEUcQhNgpnVSnMQi2I2XDHuQhq1fEJxcIfDgr7Z7OwEXfkrId4vqGJSL8j0ktP+L4vVsCt+NUHDBaP1AiqP6SEr4+j7f5VDFQAweajfLtzXLQAXcQKjS26mkWIi1Oy9pPRIe0H+cJO6jgWjlalpAyuDooFTrgXjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jauZu1JZ0EjRRsLjq+9fYvdku8WhvGC8mvSh+MRyeuU=;
 b=PhUhT8Emb7MoJssbsQkG/CXJ0SKGpJ4xnF/up4eexCpXyo5P1Ve0kACyZmKtxwIhf9s+DFZEKObLH6FkK+9G3qa1ewsbW+zA3NSxThb4eJhaqlEEgoyy//deOfp4WUSiFQD9wa5RDns0jLKoy/r11bUwAHc19Lm73xGTdRpCqY0y98d+1ultXMJM6upIRJWIblTXxPP9951ByByQ8vNH4EXaHqO6iF1y2UJXa6weL2wBc7Tb3ng5Yca7M9Jzh0Z3Uik0O3uaUjHgGHvFNHz1SKL2aOsOvJtwiZciER8LtvelBIiPUVBTiH30WXUhZ2837GpW9yH7quo8YQgZv35r0A==
Received: from BN9PR03CA0921.namprd03.prod.outlook.com (2603:10b6:408:107::26)
 by IA1PR12MB6331.namprd12.prod.outlook.com (2603:10b6:208:3e3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Thu, 16 Jun
 2022 00:03:16 +0000
Received: from BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::f7) by BN9PR03CA0921.outlook.office365.com
 (2603:10b6:408:107::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16 via Frontend
 Transport; Thu, 16 Jun 2022 00:03:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT060.mail.protection.outlook.com (10.13.177.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Thu, 16 Jun 2022 00:03:15 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 16 Jun 2022 00:03:15 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Wed, 15 Jun 2022 17:03:14 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Wed, 15 Jun 2022 17:03:12 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <joro@8bytes.org>, <will@kernel.org>, <marcan@marcan.st>,
        <sven@svenpeter.dev>, <robin.murphy@arm.com>,
        <robdclark@gmail.com>, <baolu.lu@linux.intel.com>,
        <matthias.bgg@gmail.com>, <orsonzhai@gmail.com>,
        <baolin.wang7@gmail.com>, <zhang.lyra@gmail.com>,
        <jean-philippe@linaro.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>
CC:     <suravee.suthikulpanit@amd.com>, <alyssa@rosenzweig.io>,
        <dwmw2@infradead.org>, <yong.wu@mediatek.com>,
        <mjrosato@linux.ibm.com>, <gerald.schaefer@linux.ibm.com>,
        <thierry.reding@gmail.com>, <vdumpa@nvidia.com>,
        <jonathanh@nvidia.com>, <cohuck@redhat.com>,
        <thunder.leizhen@huawei.com>, <tglx@linutronix.de>,
        <christophe.jaillet@wanadoo.fr>, <john.garry@huawei.com>,
        <chenxiang66@hisilicon.com>, <saiprakash.ranjan@codeaurora.org>,
        <isaacm@codeaurora.org>, <yangyingliang@huawei.com>,
        <jordan@cosmicpenguin.net>, <iommu@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <kvm@vger.kernel.org>
Subject: [PATCH v2 2/5] vfio/iommu_type1: Prefer to reuse domains vs match enforced cache coherency
Date:   Wed, 15 Jun 2022 17:03:01 -0700
Message-ID: <20220616000304.23890-3-nicolinc@nvidia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220616000304.23890-1-nicolinc@nvidia.com>
References: <20220616000304.23890-1-nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 983d751c-36ee-48ce-88a5-08da4f2b9ccf
X-MS-TrafficTypeDiagnostic: IA1PR12MB6331:EE_
X-Microsoft-Antispam-PRVS: <IA1PR12MB63317969D69B60CF58AFEBE9ABAC9@IA1PR12MB6331.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yboDXVffL3w6sJqprITRC10rb+BkzMV16RO60Re1vfT83wNw7AH0QcBytge7dwckbSLcaBs3qasCflzCpY1zWaXJd8BVZS9LiCv3tQRDbrfaA/Ib9sjs/Wk+Vo7qQNAkuCA1M2wOTAicHGdxRi5B9FCX8+fwYBnRjQunJyagKO27KilxN4HmZVpivwaFgB/2eQ2Nq/fMP/1PKPNvR3wHLvYI5AvMnVq0FSYR+cDFjNVYRJNfxPn85EK+NBSAzzOsUdd8zj1xuObjjcGrhDiJtMCfwcj0fwvpcK9XcWiLG4JVMzCRiNjtpcSv70cXLl4m8rt+UZwmhmWvIEaAesbpM8jGw2vm5cnX2n3FbIavpYwAUqHcWKfaYDSnAomgFp1469gSgR90iYiqhfa1UNamBaNK1c2vM9jjn5cPc/LF12waMEBNCQr/hEpzBycOvGN7mvR/611PxVjGMTmPbYpIJVGBuTVvspDTL/9hZGPjp8mnwYwdSh+tE9DOIVy0Bz6jNCqc90B49odKa+VegIW8ziS9ZjtWO2PkpBBOk161N+j+FBPWbQceZq6DwzHk6VVU8pq4RQs0kUlXTDjkRh7oTEEw2NDbCnrcLDMsF+vOR8S+4ZN45s6rXKZ36TG0TvZ84njOcTcpgh/4rXyhEz1hap1BpHro9DHdDDq8Mn2nvAgh1bhnFKyPAgn1ehHo27x8H1JnJD1uofYLu7/cuaaZY8DBgJkGOLBHfAsReqwL7oeRAlW8Rh8Z2WtLjzsF3twK2Bm0v3Air6njBNWtV76DyA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(46966006)(36840700001)(40470700004)(54906003)(110136005)(316002)(40460700003)(86362001)(82310400005)(7696005)(26005)(356005)(921005)(81166007)(4326008)(508600001)(8936002)(5660300002)(8676002)(70586007)(70206006)(7406005)(186003)(7416002)(1076003)(83380400001)(47076005)(426003)(336012)(6666004)(36860700001)(2616005)(36756003)(2906002)(36900700001)(2101003)(83996005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 00:03:15.7818
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 983d751c-36ee-48ce-88a5-08da4f2b9ccf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6331
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

The KVM mechanism for controlling wbinvd is based on OR of the coherency
property of all devices attached to a guest, no matter those devices are
attached to a single domain or multiple domains.

So, there is no value in trying to push a device that could do enforced
cache coherency to a dedicated domain vs re-using an existing domain
which is non-coherent since KVM won't be able to take advantage of it.
This just wastes domain memory.

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
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/vfio_iommu_type1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c13b9290e357..f4e3b423a453 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2285,9 +2285,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
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

