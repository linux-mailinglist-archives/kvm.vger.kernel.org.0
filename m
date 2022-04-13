Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA0B4FF76F
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 15:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235477AbiDMNND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 09:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233614AbiDMNNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 09:13:02 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8436C3700D
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 06:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zv5yHV/LOy82XnK1nNCxKOo5byJBLRcB1LORNMz74vNqEBys1tAcFNHPSl70nUyzlONumFMXV8KDUDPRpDDES8ItAfcq6cA7NVpENUVRppBMS5R4D4+92D2+OveUNZlfa3cGWSK0TDOPmXlMCXW8OOrysl6stowKpCN67BhceMsGqJXsUumW8G1ZUSbyN8J/YWT9zpa3B+XavoGBwx7uKbWx7Nm25+9XD0GD2wojMcFUIFV/fIO4PvI+K9CYCBq+GtyC9Aw9gU0gjODdpvXrA5t2KedM8oxG3SZZcsGfnie7LjBwEWVlK6zEc2tdIZXAtSpzA+NMd7Mr0YdZ/X1fgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mo56QqTbuaixz3gELwbSED9vXBT0X/dWD/P656cum7o=;
 b=RR6MucyJUVLpUteFg5lwsZRorLqXSlHrHk212grlKLkeR74u35S+x6GmyVCnOesnYNnEzcVpG95jCrQ7hK5cHgio0OUxVSvhsi2R9lIcR0U8itySDb0trJ7z/+pczEu6kHRsCmgKhBLVtKsriKvOeRvonJOb7JfqqngT0R56lc/G5wt4Xtpx6eMPShrZ8F8tDFcK/3jRP7tKm+82z5D2BxCf+nsNNjOgLGxHUaSnYqkUnuL32aARCk9+3MpA7wiLXJuklCywgJf7oIOTuy91HlTqSrG3tTv43S2E6gx30MEQfkZ8e8Z4V4Telzwj+jS1lnpcKZPefZirefl3Z+x7JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mo56QqTbuaixz3gELwbSED9vXBT0X/dWD/P656cum7o=;
 b=FZy1oUR8jDpFs58m7NxmV84cydBTMfIDCuIpfJf12uoN4C1Nq6v08UvCGZoJpxpYhg0X3BtAUhp9owDJIEbjVg/TpyoilYpPO1/Ve2Y2PosNCmv8QinPivK5rtwbi/bHQ2vUNJuDm58RmszSgQoLoaxEjnMvjAo7IGcj3/EYpZEXERLuTUWQ7s1kIxIDzCUugNSaRk+DXJ5XOFsNBWJ6aSbFQLmJ1COED9+LhqbdQhCWV6fBjEJPg2o5Ffgh23Te+qG76+rzoRURp3bTmO7V1DwUfoYjjYdEseL0FtpQktnSd3Ffp5JfzvHHnuLKBDpXqm6TSYhk9K93qTazdFYKDQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3352.namprd12.prod.outlook.com (2603:10b6:a03:a8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 13:10:38 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5164.018; Wed, 13 Apr 2022
 13:10:38 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v3] vfio/pci: Fix vf_token mechanism when device-specific VF drivers are used
Date:   Wed, 13 Apr 2022 10:10:36 -0300
Message-Id: <0-v3-876570980634+f2e8-vfio_vf_token_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0055.namprd19.prod.outlook.com
 (2603:10b6:208:19b::32) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e128c492-c5d4-4248-4c87-08da1d4f00cf
X-MS-TrafficTypeDiagnostic: BYAPR12MB3352:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3352EEEE08588CE9FCBD3C02C2EC9@BYAPR12MB3352.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1fxs/eZ1rPCuOR96wFz76sZC8EVx3li8gKvEvc5aLSO4ASbqbFSglx+RC2sDHV0go3phmjq7AqVewGuya5QASMuc9g9iWjnXbdrMBCjT+3ULOL6W8SePpZ2zFXgcmt5lP7J75HQOqaEKjlpJnwzEVDgSvzwNvHGg++UPy+jNO4THYrcF69/eay8KsTTBEBf36Vx9q72kIWwoT5Kpjd/xRx2tOp+qqtzyZ35JtBaGgmjmM+koZMAdYMUT4htoMtFaGMRVHT03hj5DhL6AtSYVLf1D7X4Ul4wzOY10gCTz9JPEbL620plUgU7sE+cNgk0PEavtknkisKyupf8EEM9iJDGNirRp/nm77qV3x3Yy24UDpGixWJ8SIlWVYc5SBS7P96dzrwOoDJAHpqiAaO3+sVFPx1FigqL8rTCtpMxwsJAlnlzh7rHmm2n3Oj4QL6Pzz8LCQMCKXV/gmAyYsbzGOQEbPT7qLpJ7pQjFnrNVwQxwLDSTd2L5muqbG42fx3N5XppbSxvEwuDY7aBXsBu334pKU2exCPk5m2qWJbGWr+UE/KaFokYIeojBd8a0N9Gex7r6XRYdY/8QaBDF39GsHzkYbhIIwg8TMRnZERFVVKF5Xs/dw78vNu3hieoGRtrlkbm6m6h8Fn4YriBtHDIHDaavtWGPISwYvYkUc9vDrNqNxkrCyCmoPlonQ6GohPAuDrqukeixbiBXpg1gmWd+vUCv/eWYGB3gkm4DP+QpGyGlHbS6j2jKHdP4tdZ5HATF31CFcSZHR+DxOfsEBM1YkHnjbHt5Rwl/4+L5hfXPc9SrGjQl3WFMi/67pw4SUn/u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(6512007)(66476007)(26005)(8676002)(186003)(86362001)(2616005)(508600001)(316002)(6486002)(966005)(6506007)(83380400001)(38100700002)(66946007)(110136005)(5660300002)(8936002)(36756003)(2906002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yKKoWES/pkPirA1+6n9fqZNtADQbUoj80sehaXRKsk+kxDcRshS2ihc8vOZA?=
 =?us-ascii?Q?4VTOUatua6JvdNOfenXrWqlbBSmuiOKlSl9LGbDm0J6tNO4M+tdaI0fHM3z/?=
 =?us-ascii?Q?HykjG7WiSwpqIva0XlatDdoqRn6rbLaNcr9jW8CUEN79fg28Ych0T5lJ8rkv?=
 =?us-ascii?Q?nUsyvbEKtozzQaeqDNBDq+J9oaLphfMMYzbarhBEEkWLFWzpYkp1DuqGx11H?=
 =?us-ascii?Q?ORzwqnylcWVOcymYRr6IyTQR7gRqg+nfQ7M6k9hM++Kqbz7WfccCNyXki0K1?=
 =?us-ascii?Q?wm5cciBXIXTKfLXzzaCnECO7I1/CcAbWK9zTUROoE17pdiu53zz4KXnqrPua?=
 =?us-ascii?Q?4HJyfs1SYMiIaTbHmL+zXyW3oPM+YYIopm10g08BfbqSp02IQ4HdFDNTn7Qn?=
 =?us-ascii?Q?FJMF641AnRvl9zLA/0OIF137a/QUljm/gFArApey57uBNbzsdKJx5fo85pif?=
 =?us-ascii?Q?wPjQpI3OQlH7vmw/pfC/hgVXX1Avm0PKFEKbKgsnc+6cD2Xdcf0+HznrA725?=
 =?us-ascii?Q?r+9ELP/KISjBgM6Giby3cpcajOrGBLWJmDFHyKMClHQG5O/wX9JdvD4TH5eQ?=
 =?us-ascii?Q?S50qzkhPzlvk6f+Vtr7VQ++xE3Zr/eD2CIrw76rynSgJ0OKQbc9DOKDLEcsV?=
 =?us-ascii?Q?htTd2YUi3ay0sTjVbI1vfh1KzngebRwQVTST+pWR14oQrt6J4qrVoWAR2nq4?=
 =?us-ascii?Q?q5ocfWGkyHblsdJLgqabtD8hXtYBsAgjGtPtyqUrJGlRkUU+ui4+slOMDr2C?=
 =?us-ascii?Q?EGCXOzUG8ASLTG4rlpGFBKl/uy6/DDaCtGthE1fdTmpL4e3jojFN1OqteJp8?=
 =?us-ascii?Q?68DrBTu0ZLZWMTZc/rDU/dO07ny8OFW7Xn/ibnY8EFAIIfpb8TmEsLCKER2V?=
 =?us-ascii?Q?0UkcDR8kkj3tES9m8uyJXahUrc18Pltw9PB/AC5zYGpCpr1EamqGWxe6kumE?=
 =?us-ascii?Q?LTqeCwefpvVyccOBUDr8UVLWQbIK7WSrfszFz2+xQH3E+yS2L+Qa4YLXUSAF?=
 =?us-ascii?Q?+/Dr15UDGH80ksB2jxHzqef1WvXT6zEjfgZUfjBr5slEAsdrqHKn3Hs9Rvo3?=
 =?us-ascii?Q?hQ7uAHtgY0bvEmnujmGbScn/rBPZqMlc6ditkaABQeVn/eBz673r2Z0zY4/7?=
 =?us-ascii?Q?pD8f34SpHdknJGtH9e+JdWbcUGw8potlyqhaPTRzSA8IeVAPMzmeWHEOEn+d?=
 =?us-ascii?Q?Gt24JGhgUUm8U2oYPW3DZqM/B29TUDmfIU+NKmyZt2d1a6afNI9wEfk5tQj1?=
 =?us-ascii?Q?kW4StcqVE+BY5qjqSvd976StW2mbXGbU8R56iDoEcdR0OcXWU9u+i9e8vQPP?=
 =?us-ascii?Q?FjvblVDmJjja/v1UaMKb5DEDvgo17pKhHWPoJEGvdkyZdHxXbmMvWh94AK1a?=
 =?us-ascii?Q?zD66wszkTj+cUiyLzQveRTIOOeO0zWH0e+Djw+79RCdUBTMiUWJNFZGuSh9t?=
 =?us-ascii?Q?jvzv7p+hthHm0+ouPZKmNAzYLVVTQvTCNxkr53BiL/zOTulbkpqxHJwXB3wB?=
 =?us-ascii?Q?cUQvIPMoN0J5oQoZUjZyKyEOdcLK2TjyKOjoelTBQB8gwO864YtuM4redRzh?=
 =?us-ascii?Q?WSpY67rp6Jo03QsUPn45U++mq1+ddKsOT9C90I23d7fhpBpq3zMyzZ8vEJDi?=
 =?us-ascii?Q?nhNnQmfBB6o6s8oMSLVXVme5UfZvVNE6WIGrKKww57gNNPhem4h14RYmVjq1?=
 =?us-ascii?Q?sRKwwUMehcf+QGrdxRzi2YOj++7SWAtZAPbzzqaRaSh3879MrdB76NycscOn?=
 =?us-ascii?Q?XZTxGafklQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e128c492-c5d4-4248-4c87-08da1d4f00cf
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:10:38.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v2M6tgTf5Z/sCoU2XualhIU7Vs75TEjy2lJWrsP1mDJhtp4mzfDHPluAj309ri7n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3352
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

get_pf_vdev() tries to check if a PF is a VFIO PF by looking at the driver:

       if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {

However now that we have multiple VF and PF drivers this is no longer
reliable.

This means that security tests realted to vf_token can be skipped by
mixing and matching different VFIO PCI drivers.

Instead of trying to use the driver core to find the PF devices maintain a
linked list of all PF vfio_pci_core_device's that we have called
pci_enable_sriov() on.

When registering a VF just search the list to see if the PF is present and
record the match permanently in the struct. PCI core locking prevents a PF
from passing pci_disable_sriov() while VF drivers are attached so the VFIO
owned PF becomes a static property of the VF.

In common cases where vfio does not own the PF the global list remains
empty and the VF's pointer is statically NULL.

This also fixes a lockdep splat from recursive locking of the
vfio_group::device_lock between vfio_device_get_from_name() and
vfio_device_get_from_dev(). If the VF and PF share the same group this
would deadlock.

Fixes: ff53edf6d6ab ("vfio/pci: Split the pci_driver code out of vfio_pci_core.c")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 124 ++++++++++++++++++-------------
 include/linux/vfio_pci_core.h    |   2 +
 2 files changed, 76 insertions(+), 50 deletions(-)

v3:
 - Use pdev->is_virtfn in vfio_pci_vf_init()
v2: https://lore.kernel.org/r/0-v2-fe53fe3adce2+265-vfio_vf_token_jgg@nvidia.com
 - Ensure pci_enable_sriov() and list_add_tail() are called only once per
   device
 - Add a device_lock_assert() to make it clear how the pci_enable_sriov() and
   pci_disable_sriov() calls are being locked
v1: https://lore.kernel.org/r/0-v1-466f18ca49f5+26f-vfio_vf_token_jgg@nvidia.com

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b7bb16f92ac628..3c6493957abe19 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -36,6 +36,10 @@ static bool nointxmask;
 static bool disable_vga;
 static bool disable_idle_d3;
 
+/* List of PF's that vfio_pci_core_sriov_configure() has been called on */
+static DEFINE_MUTEX(vfio_pci_sriov_pfs_mutex);
+static LIST_HEAD(vfio_pci_sriov_pfs);
+
 static inline bool vfio_vga_disabled(void)
 {
 #ifdef CONFIG_VFIO_PCI_VGA
@@ -434,47 +438,17 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_disable);
 
-static struct vfio_pci_core_device *get_pf_vdev(struct vfio_pci_core_device *vdev)
-{
-	struct pci_dev *physfn = pci_physfn(vdev->pdev);
-	struct vfio_device *pf_dev;
-
-	if (!vdev->pdev->is_virtfn)
-		return NULL;
-
-	pf_dev = vfio_device_get_from_dev(&physfn->dev);
-	if (!pf_dev)
-		return NULL;
-
-	if (pci_dev_driver(physfn) != pci_dev_driver(vdev->pdev)) {
-		vfio_device_put(pf_dev);
-		return NULL;
-	}
-
-	return container_of(pf_dev, struct vfio_pci_core_device, vdev);
-}
-
-static void vfio_pci_vf_token_user_add(struct vfio_pci_core_device *vdev, int val)
-{
-	struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
-
-	if (!pf_vdev)
-		return;
-
-	mutex_lock(&pf_vdev->vf_token->lock);
-	pf_vdev->vf_token->users += val;
-	WARN_ON(pf_vdev->vf_token->users < 0);
-	mutex_unlock(&pf_vdev->vf_token->lock);
-
-	vfio_device_put(&pf_vdev->vdev);
-}
-
 void vfio_pci_core_close_device(struct vfio_device *core_vdev)
 {
 	struct vfio_pci_core_device *vdev =
 		container_of(core_vdev, struct vfio_pci_core_device, vdev);
 
-	vfio_pci_vf_token_user_add(vdev, -1);
+	if (vdev->sriov_pf_core_dev) {
+		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
+		WARN_ON(!vdev->sriov_pf_core_dev->vf_token->users);
+		vdev->sriov_pf_core_dev->vf_token->users--;
+		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
+	}
 	vfio_spapr_pci_eeh_release(vdev->pdev);
 	vfio_pci_core_disable(vdev);
 
@@ -495,7 +469,12 @@ void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev)
 {
 	vfio_pci_probe_mmaps(vdev);
 	vfio_spapr_pci_eeh_open(vdev->pdev);
-	vfio_pci_vf_token_user_add(vdev, 1);
+
+	if (vdev->sriov_pf_core_dev) {
+		mutex_lock(&vdev->sriov_pf_core_dev->vf_token->lock);
+		vdev->sriov_pf_core_dev->vf_token->users++;
+		mutex_unlock(&vdev->sriov_pf_core_dev->vf_token->lock);
+	}
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_finish_enable);
 
@@ -1583,11 +1562,8 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 	 *
 	 * If the VF token is provided but unused, an error is generated.
 	 */
-	if (!vdev->pdev->is_virtfn && !vdev->vf_token && !vf_token)
-		return 0; /* No VF token provided or required */
-
 	if (vdev->pdev->is_virtfn) {
-		struct vfio_pci_core_device *pf_vdev = get_pf_vdev(vdev);
+		struct vfio_pci_core_device *pf_vdev = vdev->sriov_pf_core_dev;
 		bool match;
 
 		if (!pf_vdev) {
@@ -1600,7 +1576,6 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		}
 
 		if (!vf_token) {
-			vfio_device_put(&pf_vdev->vdev);
 			pci_info_ratelimited(vdev->pdev,
 				"VF token required to access device\n");
 			return -EACCES;
@@ -1610,8 +1585,6 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
 		match = uuid_equal(uuid, &pf_vdev->vf_token->uuid);
 		mutex_unlock(&pf_vdev->vf_token->lock);
 
-		vfio_device_put(&pf_vdev->vdev);
-
 		if (!match) {
 			pci_info_ratelimited(vdev->pdev,
 				"Incorrect VF token provided for device\n");
@@ -1732,8 +1705,30 @@ static int vfio_pci_bus_notifier(struct notifier_block *nb,
 static int vfio_pci_vf_init(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
+	struct vfio_pci_core_device *cur;
+	struct pci_dev *physfn;
 	int ret;
 
+	if (pdev->is_virtfn) {
+		/*
+		 * If this VF was created by our vfio_pci_core_sriov_configure()
+		 * then we can find the PF vfio_pci_core_device now, and due to
+		 * the locking in pci_disable_sriov() it cannot change until
+		 * this VF device driver is removed.
+		 */
+		physfn = pci_physfn(vdev->pdev);
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
+		list_for_each_entry (cur, &vfio_pci_sriov_pfs, sriov_pfs_item) {
+			if (cur->pdev == physfn) {
+				vdev->sriov_pf_core_dev = cur;
+				break;
+			}
+		}
+		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+		return 0;
+	}
+
+	/* Not a SRIOV PF */
 	if (!pdev->is_physfn)
 		return 0;
 
@@ -1805,6 +1800,7 @@ void vfio_pci_core_init_device(struct vfio_pci_core_device *vdev,
 	INIT_LIST_HEAD(&vdev->ioeventfds_list);
 	mutex_init(&vdev->vma_lock);
 	INIT_LIST_HEAD(&vdev->vma_list);
+	INIT_LIST_HEAD(&vdev->sriov_pfs_item);
 	init_rwsem(&vdev->memory_lock);
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_init_device);
@@ -1896,7 +1892,7 @@ void vfio_pci_core_unregister_device(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
 
-	pci_disable_sriov(pdev);
+	vfio_pci_core_sriov_configure(pdev, 0);
 
 	vfio_unregister_group_dev(&vdev->vdev);
 
@@ -1935,21 +1931,49 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_aer_err_detected);
 
 int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn)
 {
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	int ret = 0;
 
+	device_lock_assert(&pdev->dev);
+
 	device = vfio_device_get_from_dev(&pdev->dev);
 	if (!device)
 		return -ENODEV;
 
-	if (nr_virtfn == 0)
-		pci_disable_sriov(pdev);
-	else
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	if (nr_virtfn) {
+		mutex_lock(&vfio_pci_sriov_pfs_mutex);
+		/*
+		 * The thread that adds the vdev to the list is the only thread
+		 * that gets to call pci_enable_sriov() and we will only allow
+		 * it to be called once without going through
+		 * pci_disable_sriov()
+		 */
+		if (!list_empty(&vdev->sriov_pfs_item)) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+		list_add_tail(&vdev->sriov_pfs_item, &vfio_pci_sriov_pfs);
+		mutex_unlock(&vfio_pci_sriov_pfs_mutex);
 		ret = pci_enable_sriov(pdev, nr_virtfn);
+		if (ret)
+			goto out_del;
+		ret = nr_virtfn;
+		goto out_put;
+	}
 
+	pci_disable_sriov(pdev);
+
+out_del:
+	mutex_lock(&vfio_pci_sriov_pfs_mutex);
+	list_del_init(&vdev->sriov_pfs_item);
+out_unlock:
+	mutex_unlock(&vfio_pci_sriov_pfs_mutex);
+out_put:
 	vfio_device_put(device);
-
-	return ret < 0 ? ret : nr_virtfn;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_sriov_configure);
 
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 74a4a0f17b28bd..48f2dd3c568c83 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -133,6 +133,8 @@ struct vfio_pci_core_device {
 	struct mutex		ioeventfds_lock;
 	struct list_head	ioeventfds_list;
 	struct vfio_pci_vf_token	*vf_token;
+	struct list_head		sriov_pfs_item;
+	struct vfio_pci_core_device	*sriov_pf_core_dev;
 	struct notifier_block	nb;
 	struct mutex		vma_lock;
 	struct list_head	vma_list;

base-commit: ce522ba9ef7e2d9fb22a39eb3371c0c64e2a433e
-- 
2.35.1

