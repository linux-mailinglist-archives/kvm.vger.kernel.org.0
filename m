Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B08325F796B
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 16:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJGOEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 10:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJGOEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 10:04:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198291DF3B
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 07:04:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1Euip6yIhuzTsptI9m0EHQ6iuoeOKps6qnfB0sQXp+/R9oqEYeoXLfezOZP/WKBWNz+xBjW8bn4chGYUFEH+1hc/IJ7MhFb7Sv0V1U1sH6ZhGsX0/7MHpNC1Mye4ImkBPxmfXrWw2/FIda94NMl2mUb/ADUvUIed5m02PjiBTK11j8dlJCSdSHsjdP8Y2Q0ru/uP7H1kn12vONFhuZeqInIvjzvvohKX1MRGflmvI1+uSgDxl5pZ7Qg4+ifh/YphL96s/3F4s9QYANlFI4f8wdpaWCMZ0P1WV144ysHHRFTM4Zjoeo9CPqnTTivMDabPEE7fyLllKgIUC8VylqZgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G3jgJejDX1a/PEQNowibYLMK2ef6K12e6/66PnGc43g=;
 b=Ew+fQUeXsSntOCeDhTISOZ9SedCa0Qtva2BbZja8iRzkn4tpD2Ga+yp0x7ZdbSjAo8od63UKmYwSZOMOYBMjOY1Dbfa6H2heBZHbiTwUYHXH0/zpESwGXlApwV/1KOZS7ojDfYkhbwltONY/SDSzdGfmZZ5AUqc/H+2HP8G00qS6ZmfBnMDirbZptJHQ874TVAXfFQW9tj81EHGMiyMaxFTbNXjAbqtv6QJ+Jp5sKZEspzelMTYb7rHrF7vXM4G00g3Xqp6mEB/4sgMuc91Ard7ygTv3qfVIO4NUfDrO9eNG5ee9bve7lO5lyJ8Cujl1mYuSCnxghgAlDosNr2uBWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G3jgJejDX1a/PEQNowibYLMK2ef6K12e6/66PnGc43g=;
 b=a3+J3yX2aTE5UMu+lGC+p3QzveeZP4LnA/yWiRl6keBKaZ/orNwQ8uuRnSpdRJnHvVw4e9XCKTo68gCM53XInuCWY0nw6phC0gZ2dBM/AFZl5obj/gfsvXJ0uBJvrAAxfMYMh9aemnBbVTvtidKN1Min8BMPg9c+AZ9E1uh+OAf2xyQHBLN3bV+zc41YarjHijsNTmmhWNIgzuHkJzzywAe0kC+FvgKu3D4hCQrB5a2jV+5yUEIGNE/NBWjecPP98+DeivrjjgxpFSISJtKQ2wXFggetmn6T76ysn9cduXJAchqOJDX2BllvNpilHIVw5ndrgnLjrMqOefyjfmBZKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Fri, 7 Oct
 2022 14:04:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Fri, 7 Oct 2022
 14:04:45 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Qian Cai <cai@lca.pw>, Eric Farman <farman@linux.ibm.com>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 2/3] vfio: Hold a reference to the iommu_group in kvm for SPAPR
Date:   Fri,  7 Oct 2022 11:04:40 -0300
Message-Id: <2-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
In-Reply-To: <0-v2-15417f29324e+1c-vfio_group_disassociate_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0104.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b0d31a6-044f-44c2-0158-08daa86ce267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+bgh+Ajxu3RuzNcYIHz9Isd89Qv4ty3ZG17F+7QOPtSO6NcimYLDaPvDEOVi6G8a5fctyrKJGNa31n+BuCjYSc4KLMwPW90llPHT//Q1iGw8pgnx2BLYlmwxePBLmLFxSz07DjLl55158I2eBGeRalhQBDcdz/Zq9R8Nw/wEc1/jcUa1KXNJf4ovk2QYBW5VPBZBZGhbmU9ykGxkp1ZKrAc0sNEfcS8UE2nUXVJ67juUjNdmVinrpFZ6jYljqnHY7yQzDDuC0qHa8rHRnAKvbJWuTErEWxPlnTongcfxe3fiC52eq3HgYJJYhNCZEC+5dIF4Y9SqEGAim7Etpi8zR7C9kC6J6d0ZS7XGhpIODOgZLVkbSZg8b1Esc3bPFCfHtai7Badphzpljvp6YfdNSajjyJfkWAE2gjlEjPTHYk6/NqEXcOqD9j7mS5RxjzthfHckx2QDY2mlSojIU89kvCLGue54JwsXBFMafgi72NYFvJnviqt8hs5I4J2IjvEpjyrGdU0oC9K17dzw3MhS4nmvypsVTKH5ZDgrwKwt7fhEO/Rqke1QZ/jTttUUNSv5nyYnKBPAWCqu4yKNiyCET/FsTEoPLDSjYEYvl/BCbxt6RXj4Qt/em+MQXvd9WeZVbODowmEwIIW0D5vBLOmiCj7SA8S5te6TSCnmDe/L2C06n//SLlJgOhYEtJ1rl8kyyXQvGfhtCToH/HNpjGZs7Val99lmK9/ZHyvJ2aBARuMpSK/S+HfcC6LDEBbwUrv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(346002)(366004)(451199015)(110136005)(316002)(5660300002)(54906003)(7416002)(36756003)(6666004)(66946007)(4326008)(66476007)(66556008)(41300700001)(6506007)(26005)(2616005)(6512007)(186003)(8676002)(2906002)(8936002)(38100700002)(83380400001)(478600001)(86362001)(6486002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iIZXcax5kOv5MPwNtE9oZKHDa2dfju3qdh1rKhQdYUAFhLL4aV2gvFCPTSZ8?=
 =?us-ascii?Q?3rPNMll08NZe1hSQTfjFKRzg9oHUcL0fj2HYvkFPU56D6H20wYnyFkquXa+i?=
 =?us-ascii?Q?Qu7zLQ70tdIo0uQOxaweiijW5Olu2cglg38a8Cd++2sesKS+TY/39dTUX3+D?=
 =?us-ascii?Q?eeqvst6v+XltqSf0iaKlRM8QKaRbAgsE1ktOzebIiZ0HvSND+3L2x41CMT/+?=
 =?us-ascii?Q?tebyaieHcuzWrTAjF8byB9xHY9hmByRu6e5eFrW/bSnBdlBHUIlUI/5do/KC?=
 =?us-ascii?Q?LzuFTGHfHOVoT/mU5UJIV5E+cP/ZGOKA8FGbvvR+SuP1wiSyl9olZRb8G9oh?=
 =?us-ascii?Q?QxLUppeXlFzQWcRZl/u93CHk4/FRkDXtZNKJYFPKm5hJiGPVTrvap/1Spz3B?=
 =?us-ascii?Q?U0987aQeuyk4lNQlgf7EwIFCiH53FU5F1ywECf3+UyASnpJ99gTIVbxeJuDO?=
 =?us-ascii?Q?VKcYrXP1kNSbfH+001jCL7qfcbkiC4L3k6j4tu0rWvUYOVf0Y+8GlgYpblPd?=
 =?us-ascii?Q?ZeFUzk8JNG+3fEsVjFNmwWwWoH15M+P2x5lfbUQyoU+8TZDe2n0/wGuQeYGl?=
 =?us-ascii?Q?3PsQigd0Fa+/2bS1iUvVbGm83wcMO4Ho4UlBVjFKRgWd7hIdOF6iRF3+tdjo?=
 =?us-ascii?Q?8OeREP1UnTX6ZtXdLzOLGDv9e/A4ytFIL6pcUC2LD7ObbX+8njyrvScLR/PM?=
 =?us-ascii?Q?qZahIlpXLY5iTZs5aEjVvOGHLdv+ap+MDHHAgmT8f47eEA/o2M5Ojq2COXyw?=
 =?us-ascii?Q?n85FmW14Egl9dzLM3e4BRYOfT6ywOVkXEmgOMZi8MxMg80hVM3to1eP5mGfq?=
 =?us-ascii?Q?V3m9yIe5il4j2msyR8khd8YF/LRKzaks784hYM5tlSQXNdAbqgnRnGvcDab0?=
 =?us-ascii?Q?Go3gx2oN5c2+TC52EpuVvlq2FUKq+OLaO8+T78j1LHqtL0MzLas8zxhIs6Wv?=
 =?us-ascii?Q?tpAACHscYy3XtA38VOPrjNsf7ooRyT1xwtf5BTbjgRi6JtB6u3VMSmau1dwe?=
 =?us-ascii?Q?2Bfizm8DxugWp4ZSFNRdNjzJL9ZvAEZYWcG625H/0V1dhSGKUcJ3KreyYSp9?=
 =?us-ascii?Q?XcQwL1tMoeZQ3XylKAEV37xQHueyeUA4XVrFjYLhH/laf/PZk2smdSuejlyI?=
 =?us-ascii?Q?qV2oZeiJdKrV5sa3nvCwgfojnW8COYs894TIQaHsMwup4JzRD5cfI1Fl1+x5?=
 =?us-ascii?Q?sM3IRkSPykvyfH8q0zU/+zIvhrV3quRvB5BPUL7Ox+0WFga43EaJtBAJB5MB?=
 =?us-ascii?Q?zZolWD+2l2JYUXsiTwwnKKcQg4P69bgMv3GWuWSHiGLAPTX1ghznAJ7oNvrs?=
 =?us-ascii?Q?SGL6vwl/ehlcDqx2Rj18CVfXRhEOgvx5mcj5cOOLYPdMI7kWCxoXxCyNkJag?=
 =?us-ascii?Q?oXgRRYa4XFFAPi+yzN14pqelUOkn0cOPM5XJOl0IJaBIBEKR5TqclKj8+CAr?=
 =?us-ascii?Q?zKahtgIyuhfxRYszj8Dxfv1mzNuVZnIMDsps91wxW+11sZvm4OXu+oU/X3EV?=
 =?us-ascii?Q?5HDjMN5SeUfMkuQDwjGPp8g13YD5NxKJdsa9tdR8moaIOJq1cCHwjkfZ2NvP?=
 =?us-ascii?Q?ZfobCuH/VIbz2bKMR2ZtiiKr8KAk4I8mrr1k6kDI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0d31a6-044f-44c2-0158-08daa86ce267
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2022 14:04:43.5931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2bI+TNQbNfhHCq8+xsLITfASc+I0S7/ttTdgH1APbOoBaEIiFvDMyVMYIH/XauK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SPAPR exists completely outside the normal iommu driver framework, the
groups it creates are fake and are only created to enable VFIO's uAPI.

Thus, it does not need to follow the iommu core rule that the iommu_group
will only be touched while a driver is attached.

Carry a group reference into KVM and have KVM directly manage the lifetime
of this object independently of VFIO. This means KVM no longer relies on
the vfio group file being valid to maintain the group reference.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c |  6 ++++--
 virt/kvm/vfio.c          | 25 ++++++++++++++-----------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9f830d0a25b7a9..911ee1abdff074 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1552,8 +1552,9 @@ static const struct file_operations vfio_device_fops = {
  * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
  * @file: VFIO group file
  *
- * The returned iommu_group is valid as long as a ref is held on the file.
- * This function is deprecated, only the SPAPR path in kvm should call it.
+ * The returned iommu_group is valid as long as a ref is held on the file. This
+ * returns a reference on the group. This function is deprecated, only the SPAPR
+ * path in kvm should call it.
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
@@ -1564,6 +1565,7 @@ struct iommu_group *vfio_file_iommu_group(struct file *file)
 
 	if (!vfio_file_is_group(file))
 		return NULL;
+	iommu_group_ref_get(group->iommu_group);
 	return group->iommu_group;
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 54aec3b0559c70..495ceabffe88bb 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -24,6 +24,9 @@
 struct kvm_vfio_group {
 	struct list_head node;
 	struct file *file;
+#ifdef CONFIG_SPAPR_TCE_IOMMU
+	struct iommu_group *iommu_group;
+#endif
 };
 
 struct kvm_vfio {
@@ -97,12 +100,12 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
 {
-	struct iommu_group *grp = kvm_vfio_file_iommu_group(kvg->file);
-
-	if (WARN_ON_ONCE(!grp))
+	if (WARN_ON_ONCE(!kvg->iommu_group))
 		return;
 
-	kvm_spapr_tce_release_iommu_group(kvm, grp);
+	kvm_spapr_tce_release_iommu_group(kvm, kvg->iommu_group);
+	iommu_group_put(kvg->iommu_group);
+	kvg->iommu_group = NULL;
 }
 #endif
 
@@ -252,19 +255,19 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 	mutex_lock(&kv->lock);
 
 	list_for_each_entry(kvg, &kv->group_list, node) {
-		struct iommu_group *grp;
-
 		if (kvg->file != f.file)
 			continue;
 
-		grp = kvm_vfio_file_iommu_group(kvg->file);
-		if (WARN_ON_ONCE(!grp)) {
-			ret = -EIO;
-			goto err_fdput;
+		if (!kvg->iommu_group) {
+			kvg->iommu_group = kvm_vfio_file_iommu_group(kvg->file);
+			if (WARN_ON_ONCE(!kvg->iommu_group)) {
+				ret = -EIO;
+				goto err_fdput;
+			}
 		}
 
 		ret = kvm_spapr_tce_attach_iommu_group(dev->kvm, param.tablefd,
-						       grp);
+						       kvg->iommu_group);
 		break;
 	}
 
-- 
2.38.0

