Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E6C62CC47
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbiKPVHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239116AbiKPVGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:43 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB4520983
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VxTEb0fZwHlPwra1K+/dyLxeaCtdd8l2oZxlED+EbU9Sq9gCNb87KofzmzHz+acTPlLD/5DV5nKDJHLe5sRoF28kp/MEDjCqRx/mpt9K9ODB23eiafZqt1jrwbqnViUsnsA5CRzpDWnLJnVAoxawXEQtHL3FHhpze/rzNd0jiu+41FrdPxLvVeSdtUQzD652wtwQHbsEww9REZ71PhP9ziUr4CAyo0fiVL9h7mRMLdMj+DlIzqMKqCeEs+H2kUc3DICUhBo0fskyfxshWWwBt+uaXzs+ZuJygT0419ghdtxGS2IJ4K+HfmPI+S9s/lcTJ7+sjUVAjoFCOwEMx9eO0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLLOmFH/fQ/1JS/bWjYlZatHFJjU1xRNPIQRDYxZnYo=;
 b=SXiITXwyQLSaOaT4oqTKiP9wHwr+2CGiDzA5/nFt54vhbf7BM/97wQ7qwMVlQl8Yywf9RIckbhDQm33WOjOcImDGijudfkIaAVlgM+Pr3ZfCQH0u84HcLPMR41xDmBXpN0/GCeicAKZLoEg5iOAO/SC2MQMLDUBdI2yBLL1MzOtPcf3qvn6lf02TcLLNDnglsRP9JepILtKItFmkK+way8KazwdxlxQZabcCCxd5iujtF8n7vq3A3GBcZB3gDpBCHN/O0qDDNypATK2BdLKz/SttQSztaxK+QUx5xLlKQqwYqAC/G42f41S5qVYNmjmNmwMfrE/pZqZwuFlpaoc1aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLLOmFH/fQ/1JS/bWjYlZatHFJjU1xRNPIQRDYxZnYo=;
 b=s/DJcR6Om8xbDviXiYp+dJVck8Dumub1MqrDJle0jbPgqEXmRG/Dx79bdOlfx9ozlBp1XGjYXdVTOYZkPZVHFLFUx8KWMY1PP+MmovBYfWJbzXdkZkcI6IdGkN2na5h6460IC1TND6TlnipoasFcDNXlYYbjgO3nixbcoh45Kh2OxQKjLYcU01QPfN9I8J4PaRiSpnEwExLdBsuj0QWAjvlDAph1PkhVBgZhKeFDFWdPzTQVPZbbKG+GEU7UUhlNfm6nTuNB3clVUfaMoVYMp5H+7qvfvid926HWIK0ojjTBPWG60QZU2x8wgIfcCdEDSWjXOex6OCMilBvJMr2LoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:38 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: [PATCH v3 01/11] vfio: Move vfio_device driver open/close code to a function
Date:   Wed, 16 Nov 2022 17:05:26 -0400
Message-Id: <1-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR19CA0020.namprd19.prod.outlook.com
 (2603:10b6:208:178::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fb1cef7-1f3a-4502-4dc3-08dac8164faa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GtBEE4Ouzg6fQ6jrScaP4kcwb4EDxClj91B5o7ssZVtwF36N0fubCE/4LSCZBXDaHTGbtNw4i9GOjf+PrxGRCaXfELwRgeVbzpkvNXeHDWmtp1wTnoLaqkEOky/LnOvjiADMLXeHaNeoybxMJBhKuN4aOa5x0b/D0GXqSLCdNZ9/cHyks8BeF4ewe+ufkzQrdsDk79uO/WsfMb48M95E/JxJ0ZBclBTFn2mbEY7bgkbovY5bo1f0yseBQSpsQ2wy0q9K8iet2C3muXcMdbS5+ZCYhzZGPA2G7+UaB+y70aXlxkKjCp3figr5DJKGWzu6R6Sww2c03OS+t9k+cuy5iH9Wr1RhUoY/9TAuI8LFZHX5F1+CQjjlw6GDvafXhA3vgt33GWxmSAh2TJREBbLjSbmkm4QczJJ2taQhIOIerhzoi+HGiNCj0cgepfTBFDarOQWqpQJ734TSZ+SUOy+Cd8CiKZA4Z2Svu/xqYhOF+B7xWfok9LJMiDCkY0jr/8dym9F26cEmddGixFuca4uOJq9SokfD+N6LqQNErxwi/I7jvw1rhCjCxElZmro/Lg8jmnrEqMacI8me2Tjp0wXYVdwZT/Jv2dsqYUaa6SKCzJux88/iG7bYiUucijVYr0UvOUr48lWGx3MRNqEVDgPc+WD5XF97goYbIxA2TMWaPFIA42duSoX7GdW1iLcCUwKx/jM6zD3uSu+HzSniSYihYCbc+XdYRtVNERDvdww2Cg6goPtglhe13ogFTb/NuufDXIIkCbw6SXt9Yg5ARFcMkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4QSO/B38kDiphO1hq9oE5Mqm3MGbE8EPCOfaaMFBmWAZHDxigv5UqksQCezd?=
 =?us-ascii?Q?TjJPBzv9JIetKOoZd32VLgv0/uz4sCkyB9VI1ZxsGH+nacCT9toZ6eN7Yyl9?=
 =?us-ascii?Q?kzQhiTNpo2F9HePlIay/emC1L+N5AMk8sv0gTDkajprnjbnPoctWgUS8Cmwl?=
 =?us-ascii?Q?CvCu3myc8X3rLfRZvDuGplv74ldvU7UAd0xykFzfcJxhkRfAS+3rSp++vEsf?=
 =?us-ascii?Q?mqehx4ZmvP1eQbMb4hWal9qLFFkWJ/MZqQlp2z9/H+d8uaMleaENeljT6/8A?=
 =?us-ascii?Q?ZMwVIh2EDvPXpEmO+eeKCIo8Rv6RjpreOjl1hlnjzC1FZIUb2Mn2gKB3L+Uz?=
 =?us-ascii?Q?ZSupx7F90Jh5gQgISdTxPducR1+KW32GR/5DMcOJqaRjaEYl86l7hVhYCaTp?=
 =?us-ascii?Q?7F7FB0zHiQvJzoh9AQ30fX3WDXoBQYRaT2ofGP9A/uniY1RkdmJsICiZc7mQ?=
 =?us-ascii?Q?0kJiA+hdZkegu3bo6vBa2ybuVSgcGIOevXcIFsf44QJoy7Gu6qYnI2sdpZlb?=
 =?us-ascii?Q?VQ8EIlhw+vPKNcXMEoL+M2W4fKu8ikSq7dnXs7rz67eY5Ubx/CZuE98WiPiE?=
 =?us-ascii?Q?KS/ooEMRbMxXU3yORXXcqzfHMk27FVQYKU7OY8UUcIS31jf93bDtMGrn1v3E?=
 =?us-ascii?Q?PVp42db/txzYUtFrAm2X1LQRESCGMnO9tTw+egY9fd7Hq2c8KXDefM+AG9Mm?=
 =?us-ascii?Q?HSbX2m/5A90Ij1EP3SSm6h3Y8xIoYNgG0983zYqwIuGCsnxsb1TD3ikjV1OY?=
 =?us-ascii?Q?afFZJcaLk8chRV31m1trklEoucSkVErpGTX8oAa4MNl6He6XIhDDXQsxuf/s?=
 =?us-ascii?Q?u2y2TMWHF7aed7kWn21kaW7iRJGZn5DLyngk2A1lXUlRW/fwwMGdqrffcUUj?=
 =?us-ascii?Q?TqFibRboOHhbxxyOb4n6qUlW0KusAtt4BxMB66jDLqCt4LgRnnoCZYxHjE+x?=
 =?us-ascii?Q?q7BpVsG+2YaSaJobTDVd1tqShJvg94xer/hudGTgCfP5Q5aWZwn8m2wH+t39?=
 =?us-ascii?Q?T+qQPS7k0uouJsKX7FJXqzaG1R4HK0LhDtu1sdwevH5Sh1Mr/mx5RXAv1nHn?=
 =?us-ascii?Q?o4THKBbzJgFWzfa1S/+zrGBUXMuluMIDwI37rrZtqYcuojtWEYbvmQU8k0xc?=
 =?us-ascii?Q?pBTzO8aE8C5p/OzhSaZJt0NyDA8K5O24IQUiXcPbr0SMxw3LN/Y/zEl8BaBT?=
 =?us-ascii?Q?LCmdL0wxkszVLf9q8/xtQKApPw7PADsYVbB6csTleunX2FHKyALcXQyPdoqn?=
 =?us-ascii?Q?CpZWas0v2j28zghKDiXhd7dgmJ30gv1E5GzSzV911NI7QN8olcop26IN3mbf?=
 =?us-ascii?Q?MY2dFuy1PO8ALJE/EDToYfV0r2nE383NSg2Kq/FgiNMHFGiYjeF3sEiV/PU1?=
 =?us-ascii?Q?fH5DOUzrFlKMTi1HSh3msEnHZQkFKErCuCKUckmPAXXqfxno7MmCoV466s7I?=
 =?us-ascii?Q?WniEFfOLVHwsLQniIUHb2TSx0fBm7pHpROlobQ21cjmMrfsAcn+YJtbJI95t?=
 =?us-ascii?Q?/5PJK1QD6JTp/dZ0wdYP9HH1LoYjM4EQF5ZJ+S/iSMQWhfeDU9AlcWyrUQZ/?=
 =?us-ascii?Q?kbV/4Nl2+YjzSUAjDM8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb1cef7-1f3a-4502-4dc3-08dac8164faa
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:37.9305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qk7TfuPPbcHKvzqQ7BfZk1VSKBgUow255Flti6hAlzI+oCo+XxtipnWW0BcOKIBo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5609
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This error unwind is getting complicated. Move all the code into two
pair'd function. The functions should be called when the open_count == 1
after incrementing/before decrementing.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 95 ++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 42 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2d168793d4e1ce..2e8346d13c16ca 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -734,6 +734,51 @@ bool vfio_assert_device_open(struct vfio_device *device)
 	return !WARN_ON_ONCE(!READ_ONCE(device->open_count));
 }
 
+static int vfio_device_first_open(struct vfio_device *device)
+{
+	int ret;
+
+	lockdep_assert_held(&device->dev_set->lock);
+
+	if (!try_module_get(device->dev->driver->owner))
+		return -ENODEV;
+
+	/*
+	 * Here we pass the KVM pointer with the group under the lock.  If the
+	 * device driver will use it, it must obtain a reference and release it
+	 * during close_device.
+	 */
+	mutex_lock(&device->group->group_lock);
+	device->kvm = device->group->kvm;
+	if (device->ops->open_device) {
+		ret = device->ops->open_device(device);
+		if (ret)
+			goto err_module_put;
+	}
+	vfio_device_container_register(device);
+	mutex_unlock(&device->group->group_lock);
+	return 0;
+
+err_module_put:
+	device->kvm = NULL;
+	mutex_unlock(&device->group->group_lock);
+	module_put(device->dev->driver->owner);
+	return ret;
+}
+
+static void vfio_device_last_close(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
+
+	mutex_lock(&device->group->group_lock);
+	vfio_device_container_unregister(device);
+	if (device->ops->close_device)
+		device->ops->close_device(device);
+	device->kvm = NULL;
+	mutex_unlock(&device->group->group_lock);
+	module_put(device->dev->driver->owner);
+}
+
 static struct file *vfio_device_open(struct vfio_device *device)
 {
 	struct file *filep;
@@ -745,29 +790,12 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (!try_module_get(device->dev->driver->owner)) {
-		ret = -ENODEV;
-		goto err_unassign_container;
-	}
-
 	mutex_lock(&device->dev_set->lock);
 	device->open_count++;
 	if (device->open_count == 1) {
-		/*
-		 * Here we pass the KVM pointer with the group under the read
-		 * lock.  If the device driver will use it, it must obtain a
-		 * reference and release it during close_device.
-		 */
-		mutex_lock(&device->group->group_lock);
-		device->kvm = device->group->kvm;
-
-		if (device->ops->open_device) {
-			ret = device->ops->open_device(device);
-			if (ret)
-				goto err_undo_count;
-		}
-		vfio_device_container_register(device);
-		mutex_unlock(&device->group->group_lock);
+		ret = vfio_device_first_open(device);
+		if (ret)
+			goto err_unassign_container;
 	}
 	mutex_unlock(&device->dev_set->lock);
 
@@ -800,20 +828,11 @@ static struct file *vfio_device_open(struct vfio_device *device)
 
 err_close_device:
 	mutex_lock(&device->dev_set->lock);
-	mutex_lock(&device->group->group_lock);
-	if (device->open_count == 1 && device->ops->close_device) {
-		device->ops->close_device(device);
-
-		vfio_device_container_unregister(device);
-	}
-err_undo_count:
-	mutex_unlock(&device->group->group_lock);
+	if (device->open_count == 1)
+		vfio_device_last_close(device);
+err_unassign_container:
 	device->open_count--;
-	if (device->open_count == 0 && device->kvm)
-		device->kvm = NULL;
 	mutex_unlock(&device->dev_set->lock);
-	module_put(device->dev->driver->owner);
-err_unassign_container:
 	vfio_device_unassign_container(device);
 	return ERR_PTR(ret);
 }
@@ -1016,19 +1035,11 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
-	mutex_lock(&device->group->group_lock);
-	if (device->open_count == 1 && device->ops->close_device)
-		device->ops->close_device(device);
-
-	vfio_device_container_unregister(device);
-	mutex_unlock(&device->group->group_lock);
+	if (device->open_count == 1)
+		vfio_device_last_close(device);
 	device->open_count--;
-	if (device->open_count == 0)
-		device->kvm = NULL;
 	mutex_unlock(&device->dev_set->lock);
 
-	module_put(device->dev->driver->owner);
-
 	vfio_device_unassign_container(device);
 
 	vfio_device_put_registration(device);
-- 
2.38.1

