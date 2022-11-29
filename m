Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8848E63C965
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbiK2Uds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236239AbiK2UdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:25 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8856C73E
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxBJgr+FH+tyhnkIW3sPe3s9FEUpNs0qKt+ANAOBmq5JIlTDAlBVOwkIbxNBwnLrVsnv7uHb1ydgBPH/YEYE/j7yLB01MAhOo13/UnC1RFMuQCzjbQdmMvZf4Zyvn3zouaELS8hr1xtlSXry7tXFzSpj26hgEq9XkI/w8l+01ah6IgGDDgAJkiWndGG3eIboMYXqDOKi38IFJ7OfEHMWHdfZAVtBRxSgzb0zCaCsZ4nPuuZ4ogE1us7RlraPOH2K2PXeYxVGJ2Ut+sCZTFCGLBFTZ7VrYc/Nq7unMCWI8PbvkFcZqtNXs+TWacU8kzS+FfWqlvKZMjBHuYAFwf7CnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hLLOmFH/fQ/1JS/bWjYlZatHFJjU1xRNPIQRDYxZnYo=;
 b=I+Gnic9pr3NZsBQN8+fU6ELl1kVwbPplq6Mr6UKQQk6Ac778kQfkeOtZfc0eH30dugI/nYoeaGMfFIuCipejdgIAEgYRmqCsOykCMTw77714OeivKyv4H/wfEXD0ePV6PiSQeL9s/g8LFr85cLLKftxIkrT1dQsB1cHIvOjaNui61zpiZvxV9OvTxNmqqWh2o9SgomvXjsBiXqN+gFpY3MTCnxG0H18QYbLh3TgzYgHrhvYuwrsjFVTQ5WU7xtq41BwJqpex8AI2hE+y0O9QDigd8yZ+WQXGhui6a44kb70QUt7Qzjy3OavGPyVyES5aAYAaH6TNnMmxGhecwNvjlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hLLOmFH/fQ/1JS/bWjYlZatHFJjU1xRNPIQRDYxZnYo=;
 b=E6yGoPpUKGPXgA2lFWsQJT7j72SrVs+7/jb6wworUiz1iJGVijnlKC3d6W5uPyX+TrHpqW2hkdymh4SFehXYumGBYztnVvKgvfWwb7B/4QBOBO/ESuLpM75xQkavE6Lo/Aone9SQylFVwdA7lqf1PKjcYztUAt2LX1oQqhz5J4saeNEfUf8Lz0/7g2pBICrL4j4vN0CQXOUybV+qfBNZqdzMCmaE6i/IAIB2zXDCwtxLVLLdEsxWXfRg6nWJqLN1r/Hhcywlp6+WGjdnRiCfmpPz/DrzOENEJ8zySe4nMV0V6cwU/0tfPKdpj0xoBaCRkdZkqh1vZnWso8N62O30eg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5688.namprd12.prod.outlook.com (2603:10b6:510:130::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 20:32:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 20:32:04 +0000
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
Subject: [PATCH v4 01/10] vfio: Move vfio_device driver open/close code to a function
Date:   Tue, 29 Nov 2022 16:31:46 -0400
Message-Id: <1-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v4-42cd2eb0e3eb+335a-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0146.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5688:EE_
X-MS-Office365-Filtering-Correlation-Id: 7230ae1c-b35b-4a52-0d60-08dad248c535
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ovFxKwBOYR18THFkVc1dg8k4+HftzGQALyY50EwNVo/0p8+WnjKO+Nvgq3TaUhbL1tYyjKdOTO6yErCXOr6yA2TcQ2ftfUGbuAjd+EVyqGGI29ZUqAWC/pgZbTKutHJ36gWL2bDohk1NHEeKRFOLn1zsDEQGXkLO9K5OO13ZJdx4QziSl8A6hK6Igw2/Ve7pYz4lbZatDuNt5n59HUhtsyRPwfxavDZ41DoC6zr3V1kLhY3H/huKLNXPjSCUbxNhfP/JuBzRhw7BGi752aF9hRyzoAEbducsBQE4tYI8iNA4mGv6H7jvtCRP1q1ECSXs7VFSwasACot2Tt5guXxdr4j7vLIzGJ2aFdET9sZMNQuyy3aNOjKvjjnuQpEfdE66Qul3smWbELQ5YeooH448D3IyIweGK0/ZbQr+dNgqQq4pqBCwXgQBnTIj4w7ecwpX493xMWG+tKlkP8aNk/EBa11K2k3nOOh9efS87d4tHWQg2s21ottb61mvDCnKy16aWhqk3teujm2NLknRmzt3rP3EuKO2h/d4AboM2MxstiX8fNK+7cJ9h3a63tlK6V1rwiliR+M1J3UvzrgDsh1NNCyq4h196NMwS/3daigHhdE/u/7VKprLBrW2sQ/e+ZYNk4aENspW+gXfAsbLVjjFJIa1u68foRerzh5x3c3zyVgIL50PvROgcAKtuyGC+/bhp2vz7TVi3X51Cz9fOXE7EA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(109986013)(451199015)(5660300002)(66946007)(7416002)(38100700002)(54906003)(186003)(6512007)(316002)(8936002)(36756003)(4326008)(8676002)(6666004)(66556008)(26005)(66476007)(6506007)(2616005)(41300700001)(86362001)(478600001)(6486002)(2906002)(83380400001)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9zQ2xbtsNabOdF4xcxKqB0kAiJ58KgKez323Gu2AkCRnxWbMqwJn2ktvfQuN?=
 =?us-ascii?Q?nfB3BpVOVfS3JtTH70JlAx3XgKY1M5PGM1Mtq7I1fZMpemJPlFhc6jLPdbA6?=
 =?us-ascii?Q?HQlMED0sVhYJH27iowVVA8/TkL3wOo9w/y/btLdDHQFZ1hvNsI/tIX03YjmO?=
 =?us-ascii?Q?132twKyqXKl2Q0ib8asZ6AAXQLShGdtrGKdHzs0zIrZh9Y5jfVUzZYNjxcUk?=
 =?us-ascii?Q?rFC/OZ+Iie0C/Ed0Np4JTybtWhJF8ucW+Xdd87U5dKcy2KUrpSTI7H9Rqb8N?=
 =?us-ascii?Q?6SYhxmwPR0mWM5if44HsSkRg9l/IePHgJOnX5ZjO+UktTaZHZoxXaJUKfJ2a?=
 =?us-ascii?Q?6jPI5JFOpHIkR0q35hV55+LVejdB85mEM2jvJ2bu3yvQUnDwtAmUhUPxOROf?=
 =?us-ascii?Q?JOG0MquH08XLq5mvDcXQlavrkggIdsPZIJjJwyvxzvR49+Gj0x/fofvb8Pot?=
 =?us-ascii?Q?7SnnVEKUebxZgFwj7mgFMIRgdhLnKaJU0xMnXXb9znBULjg81m7fRpPdzTSM?=
 =?us-ascii?Q?qgMIxLEqH5E2U/o+z0Io0lDufzn4K5Re90yIVEK9mD0uT4tvGrDzAdjlXYjD?=
 =?us-ascii?Q?q0yihSeI+Hf2MThnuoufvM86XsbxfJV6Q2uteFLaGyi4vDF9D9E0GshiBU1W?=
 =?us-ascii?Q?K530Axzfo2u+6O2h3AhMT4yuBanq2avkOKyb9rsqFN3E8oP+w3DqWQ552b6s?=
 =?us-ascii?Q?/glULpJBa+OOIMQeaGvDVZHXD99r4COZdDPw1yt5bCxiFZMyRnuG526w7SLA?=
 =?us-ascii?Q?r6GKOihjc/dmAByfHgqk4MbA4EG6+hNV08CmAN4fAteCYQHs6c+jArd1B/Yw?=
 =?us-ascii?Q?nLJc5xVwCMQlE4zn98ppgUc6DENJ+pbIkpnYEZJILLurDtkjYTN3h/ufpf2G?=
 =?us-ascii?Q?KSTEJYFHwzNpD/aCC2GWm2RCyzGU4gR1JLph3GeFQIjca9bfTrfQ2iGyuog2?=
 =?us-ascii?Q?gvnlnt+4yCSs36s8/aEKgz6PBu5O69O2nsaDt5O+FTkiLx4LfyzBsl5N0tzB?=
 =?us-ascii?Q?75BEnueJbvcLrhRTPw9w83cZl/+2t8W0j6fL2LaMKIV2KZ/kgGxrwJLYVECh?=
 =?us-ascii?Q?CUw8Rh1FMCQqbEAzaF8020wIv6HZF+qNp+i2hBbJWGHLCJ110+FYscdkLayO?=
 =?us-ascii?Q?qHNmzvJkuizNuyJCPjetpVaXTzHyiRuTO1WCxsKTV5ZfsKKWHWdvdEmleifs?=
 =?us-ascii?Q?cNlCp0i/kVJjx+QwF1bn86KtGzpQI3tqpExUtQ+5+f1P3PN/WxrblobqPMLq?=
 =?us-ascii?Q?SUxC0pjnZvC64AXOm3LQLPYnigR3y5mkIJTChOgsFm5idmsBNVopCtW4qunZ?=
 =?us-ascii?Q?O/Cj5mRnUlOjj6rXS9ZHB7VfjV9yRIiEYrynpynlQalmU7T0Oczckse5Cx4c?=
 =?us-ascii?Q?Dh5BUEIJW6Eg2KFKV5s3lw2MnjIx2eCsw/YIfr/oJCAZyS5PyTr/KxMBe9xp?=
 =?us-ascii?Q?gZL0omEoCZHIOWR+44L7YxuV7gOqr33vGG7fKqhXrXYmoKX4MnAzPHPV9taR?=
 =?us-ascii?Q?l+KSKoNVl9z8ghebijGjXqsG2YLKepgf005GqBghF0XgyjUU48APeBGZ+7GK?=
 =?us-ascii?Q?GyMQ4DGkcZvgDQUlcXgCyyXmLxp0XCC0cVF5iLFc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7230ae1c-b35b-4a52-0d60-08dad248c535
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 20:32:01.5975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X7bS0m/I22gXzrbScxb+fZfk6MSa2tqKuTssI2sw1GMLHnMz54q598ASeWEIIXqA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5688
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

