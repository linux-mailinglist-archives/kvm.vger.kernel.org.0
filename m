Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE5642EFD4
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbhJOLnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:43:03 -0400
Received: from mail-co1nam11on2057.outbound.protection.outlook.com ([40.107.220.57]:17792
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232225AbhJOLnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:43:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWdnirONKhSJYCFGUpS4We57ugkMIB5CaAc6gjLrQd0eJyjo/B9WQ8ToDK/7aPmuTH+HsiXgF+RryOL3H/7K0Xso52lYl8oOA2xB6IdxvYzmCA4cpPnmfSsX5bI6t7ymA6J6WSeZt//y7FaI0o5V3NT1+cuaPIZpYH22UDActvQS3NHTzQsrXHeGmvwTheGrIU1Crp86M1kIwpX+plxWvZSoSPMverjfTgMQTY210IdgrYBKKQeRXAzJAq2oZuoHmbf36++g0GLnq5/KwyRPOXt1Wgyt+zTomOfn9djYjOBzqYceArtqQy3+prbbTpPjh4FTBJggdacN/JhASDKulw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZoqnaZ10nnsZTzTl5eJyM8vbsr2NsTuLrfgflKetbA=;
 b=oLoKkTTDECXdshkkEG+22Eu4uLIfI7qlltW6W9BPZt09OUJus+9CPQ9mrlHUU7HdLcRi/6sbIe3Xvh+/B0GSXJW8Yyc/MyxaSef0vrHuCzgEbiDqarDry4XtyevSuxqTASNVw0zSfwpT/Dp/ESd4ocRSt4f6eTsxOAP9tee6E/RE40ITjkh+pitxgNpM6TGtJ8J+br6WCWJJCYEWG208+ne0r/c5/q2uQbCQgBdYggI+GiR2/Se3cs/uB0e6JLXkqtS9AQSH8wIoC4pA357QTOUq662J2SO51b4kV9kWCyON7xZ1lYxpi3sywq8DMwCodxSp77AGBq/F3VApsLGfOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZoqnaZ10nnsZTzTl5eJyM8vbsr2NsTuLrfgflKetbA=;
 b=cFA6lhFGxvOrs8mSBS85KXPCyZXSiWGyGecIu95wMKNgsPfrD2XM3X71CZdIEEzH6jpOeLtFK/SzuR54f9mOBCtjC4EbjHlfCZam6T333SyZ++F4PBN8eFDoTxTm9IQ8DQAUAXb7M1rrLUXJowA3OqYYf1/z6ESqpe47BoTK6Ed5ZtDb/ytUGJtwjC9w33gRDVNosTlLvd4ElSn6fofPgDZtQBIEbc6ZMXfYTybdEEpZkxUpP+LAPLYgY2blMKO7/dBUct53Ol0fCZ9LuG4/mlH7datDE+x/lLF+aUBeUixESNUT1z7CzpXDOrr2zY8I+MP/OVKiLEX8wwSfsNHvPQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5208.namprd12.prod.outlook.com (2603:10b6:208:311::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 11:40:55 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:40:55 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: [PATCH v3 2/5] vfio: Do not open code the group list search in vfio_create_group()
Date:   Fri, 15 Oct 2021 08:40:51 -0300
Message-Id: <2-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <0-v3-2fdfe4ca2cc6+18c-vfio_group_cdev_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:208:fc::49) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR02CA0036.namprd02.prod.outlook.com (2603:10b6:208:fc::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 11:40:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbLa2-00FJUD-61; Fri, 15 Oct 2021 08:40:54 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b8cdafc-287c-4999-4201-08d98fd0a5e5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5208:
X-Microsoft-Antispam-PRVS: <BL1PR12MB520877138DB4426BFB8245E4C2B99@BL1PR12MB5208.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M5bDsglvGfSqAWLvp5zwvA3spM5cLeUMxBGuBDX7rlwVsSh1OaPWtvfU3fuc+xOnZo3lLwYlHRGCZsqLVTHP+M5KExks4n0GiI85VGhhMqiqSSfK6wbBkShdTaTbj5hWSd6OcB+VpXOVhYR2mHaAYE6j4UmYMkWw2lLUFJ/snSe1ORSbrwBWAHFD33kFL9S0jl1CqBay11uXHzNGeO/P2of6BnTnd386wmmmSvFhhen/DuH1y1LFUDCsVXPEgg6rAW8/ZoBAHpADV/yy8jVtN0LvmrX7HGYejCEiDzBy8nrUqsHWqLSG7xqsxFcsgVBedgseudRJMW/x/IPMoGlFrL7scuGqKjqET9KldJdW028otXV5Y4+THZvPKVTTWWtx2KS487kTuHJVIdZTm8F+aK6lzqov37IslNPwv/f/+fkELcpB0vTqdqMMA8Uohg/84ldqBxdYT4WqP7f0El/3gvWyDm3buZYjmGRmAWa7Ixa2d8GCqNRHwNfjVUfFI4qOb4UtogBSKYFB/G8+nL6nm59azlJhupKB4Esh3Dkor4BoD+2SnRJoKtXGrKD7XtTg/GlFMGkLwJ/FzPCfEOVarB52qUwyHynQKcQDkgwQyIRdd/+l3KCCrtb/UQR1aRoPkIGtmR/IKwULUtywEim1HWW/EBNoNihtX1QDsuQUwPou0N8TS8VK+aP4mXbcCXmH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(38100700002)(5660300002)(8676002)(66476007)(2616005)(83380400001)(4326008)(2906002)(426003)(36756003)(508600001)(6666004)(86362001)(186003)(316002)(110136005)(26005)(9746002)(9786002)(8936002)(54906003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zsK2YLZZPIK8uwW3EAH6HNM3VAgJhvlDYMQPHKp9bx9GRWWUnq6bohRDbpLS?=
 =?us-ascii?Q?K8PY7y5OxXVGeL67dFpykx6TcxWtCatumFTkF3mc7x4iH/IP63HI2mo0ykYk?=
 =?us-ascii?Q?He4Y5jGbMwg4RKXd+SEHNHTVnxOvXb5S6ixJO6SrMnLRpySV3dPTL4vYKqWp?=
 =?us-ascii?Q?UUzQ+sBiP3/Afk0x2u2fcVS7YHWf2AScD0Rs63DaFeYPe87GTfuhU5GsuH6v?=
 =?us-ascii?Q?OoOUEc/i+/Oma+oJeXIBdSq4dXM66AcVYXIDs8LBBCsyg5m2FFnokGWV8yM2?=
 =?us-ascii?Q?kmtd0O65piQtdt+oN20bOvhQnFdfkDiAKRBFj0s20zPjsMd/xZJWdvvVhifX?=
 =?us-ascii?Q?G07ZnChdfUtbW1GJ48bgsbwH6NJdJcSy8gje5yayOPrl5JHgiXAtyB4zIo8x?=
 =?us-ascii?Q?4RivOR80eVIOubsWwhnAamoEzQCfH0XZ0TYKSSQlwo4kKbuUf+ECjCCvxorL?=
 =?us-ascii?Q?hPD9oIYbFcKPXkOG3EB8D/4FmC5jRD8sW6tYCC+J2mCgQe5kZfvZ9NbnJ80n?=
 =?us-ascii?Q?Ht3y3hJCyc6zMLvXzGE1jvIbwRbj/RF16xJqziqCfR1YLqh8+4bM3icP/2qU?=
 =?us-ascii?Q?u2wdBR8f2clcixoikjwsjMWojpqRLmcz7HgFXguza+DLzFzoApvW4Ken2Gcx?=
 =?us-ascii?Q?rUmvJjKWj9TL2LDuGAq5dvWzienQJTQ4RPals/QC6TDmzzlZVMP2edT3U1EC?=
 =?us-ascii?Q?D2zzSqY40rDBiU8VGlusM3P1FeCGoNP6lOOhQLQg2ey03i9JK4gyZ//Z8BKG?=
 =?us-ascii?Q?tL6XicUqXZLb1GRjhnsRZ2wRAeBbskyqTx3xlmc/vaYPZZFMoJd5CcTKcAtX?=
 =?us-ascii?Q?dtPmzQ+g8Zlg4zpHqPopiIlZdNyRcqVDWt27npqVWBGX70yqxoccavV4LfYa?=
 =?us-ascii?Q?Bm5Uw43mgqhSM3VNLW2r4hz26DpCiwrb5D1tRoYfr6nzKoJxnTjKqtpvuKLz?=
 =?us-ascii?Q?IPfgsgooKR71l8OParPT5vl5YJ0QU69ewNH9UllL65lSyC+A77727RwlSNVX?=
 =?us-ascii?Q?dW9a3RcQDJfVXaU1yETfVv4wzGN7Ami2kVZ4GfEo/miV5skcp80xSduHapGG?=
 =?us-ascii?Q?4og4Qjvb/v08yS+h/V/TQnZaMSNi0iW25TKM8orrkZgt/zxE9ONf1Kgccvj3?=
 =?us-ascii?Q?OUsPLZalnsNP5XayOHykkMdtYeowMRtUMoH4gnGr3eDLAL9TMd1jaxiD2ubZ?=
 =?us-ascii?Q?MOINxrrx+fpQpZdUenKSW0y9aFuiLhc0XdZpy1F6iCaCw1Ma/HlmQHuwgz51?=
 =?us-ascii?Q?0MAfBToWqk+HD38cDzQr16d8RuHDK1ENZ5EXoyrq20kW3AEfMzRv77giBbZY?=
 =?us-ascii?Q?C7l0kcgfDaedOoHdNNHixIny?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b8cdafc-287c-4999-4201-08d98fd0a5e5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:40:55.0125
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yGp5/W/2iUQq99JjWNxYF/efJVw75H3iRH4NtJy0CnTrqSyHpDUVPap2veoYJVIE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5208
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Split vfio_group_get_from_iommu() into __vfio_group_get_from_iommu() so
that vfio_create_group() can call it to consolidate this duplicated code.

Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 55 ++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 4ce7e9fe43af95..513fb5a4c102db 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -340,10 +340,35 @@ static void vfio_group_unlock_and_free(struct vfio_group *group)
 /**
  * Group objects - create, release, get, put, search
  */
+static struct vfio_group *
+__vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group;
+
+	list_for_each_entry(group, &vfio.group_list, vfio_next) {
+		if (group->iommu_group == iommu_group) {
+			vfio_group_get(group);
+			return group;
+		}
+	}
+	return NULL;
+}
+
+static struct vfio_group *
+vfio_group_get_from_iommu(struct iommu_group *iommu_group)
+{
+	struct vfio_group *group;
+
+	mutex_lock(&vfio.group_lock);
+	group = __vfio_group_get_from_iommu(iommu_group);
+	mutex_unlock(&vfio.group_lock);
+	return group;
+}
+
 static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 		enum vfio_group_type type)
 {
-	struct vfio_group *group, *tmp;
+	struct vfio_group *group, *existing_group;
 	struct device *dev;
 	int ret, minor;
 
@@ -373,12 +398,10 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	mutex_lock(&vfio.group_lock);
 
 	/* Did we race creating this group? */
-	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
-		if (tmp->iommu_group == iommu_group) {
-			vfio_group_get(tmp);
-			vfio_group_unlock_and_free(group);
-			return tmp;
-		}
+	existing_group = __vfio_group_get_from_iommu(iommu_group);
+	if (existing_group) {
+		vfio_group_unlock_and_free(group);
+		return existing_group;
 	}
 
 	minor = vfio_alloc_group_minor(group);
@@ -441,24 +464,6 @@ static void vfio_group_get(struct vfio_group *group)
 	kref_get(&group->kref);
 }
 
-static
-struct vfio_group *vfio_group_get_from_iommu(struct iommu_group *iommu_group)
-{
-	struct vfio_group *group;
-
-	mutex_lock(&vfio.group_lock);
-	list_for_each_entry(group, &vfio.group_list, vfio_next) {
-		if (group->iommu_group == iommu_group) {
-			vfio_group_get(group);
-			mutex_unlock(&vfio.group_lock);
-			return group;
-		}
-	}
-	mutex_unlock(&vfio.group_lock);
-
-	return NULL;
-}
-
 static struct vfio_group *vfio_group_get_from_minor(int minor)
 {
 	struct vfio_group *group;
-- 
2.33.0

