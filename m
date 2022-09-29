Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59DA5EF830
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 16:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbiI2O7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 10:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiI2O7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 10:59:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38CB149780
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 07:59:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KG18zrfMsJS11Sh4/Z9QlWKSK0MLXPhViCz8p/j41aLtHyaOWqzKUot7WFnMvvTxhylr7yL9+xKjqmsaTCKnLluuFedyHieO0+5zsS9H9YgWuteeZNuBz25b9fV5eaRJf8mJQpvZNKf523/k8rrwyl8gBBpBZfWKjky6u4u/DhrWPOjb+cF7fJqG+RDBHvnRFuB0FtDmN9D3x2dty+8EYAwq0g4QDnx0O/Eeb11xfxS4Q8BkCPVlPiTs12EhCROah5NCrksTzp/Y16ySWR05RDMydd6clmCgIGQseq0Ldf2DwrkuOJIW5zMkuqnztQgywjfq/qh4at6N0fGpHpr45Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9PTFsmw8jXiUsTneXZVvWLlsY2XQxjEv1V8f+bOhzU=;
 b=hVPIBF+X1hzrpQ2DjQSVJWoy8IKbga/bjeSyDNtAbNyKDZTtTCQpMhROTx/tOaEtEoo81XKKrt4DSFg0LZttxX4eflLQ3AHL7kPjEWlCnS3eyEm5vU8ZtHnYO05+cpk7Xl06CkxGg4A6wlMsaKB638OjTKCQ0IrHDkyf2H0u6vjaHg0VBO0sToP/nWpHEY0ZQPEbT9H3b2lQp08+od4P6Tuiv6LyyovxRGri93dlJAkdOK1LLJuhYq+iuReYKWwBQb8fruPTVRCqmFJH83tIgoLm7hhSGgeqhirWJCqsBHzdtqRYWVFtIc739ABMt01YyG4uyFQLLmKiiJ3J+8NTOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9PTFsmw8jXiUsTneXZVvWLlsY2XQxjEv1V8f+bOhzU=;
 b=ieeR34Gtx+kxOU+r/c/O7kWvk4IXQjcpngPMdzQq9zIt8dG2vOgY5EbncYfnMnOSpxO0CZ1eAoQittJ108qKZ96bdI9dFltJfUNo2ZinUGvLMVRsBvrDJJGlI8E0hcdzphrcCePPVxLom2h2/5S5eDOJb17ChTESt7ffBIl/NTF6qB/PC/d6lGCkNpi5jlSZ11L8471yDa/jv6jkjHJj7ZIwiRNAQtb4jEwORv9VRYtjo2dX5azp9HyucI5vcA4Tqm1tZuLOYJVco/fvxj0U5Ev6JiOg8Sq0MKhuUa+Ji4lTTbThGoXVlYk5ySnPtPXm84AiyFGEZ6ehtWU7+cnq4w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS0PR12MB6389.namprd12.prod.outlook.com (2603:10b6:8:cf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Thu, 29 Sep 2022 14:59:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 14:59:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 1/2] vfio: Remove the vfio_group->users and users_comp
Date:   Thu, 29 Sep 2022 11:59:24 -0300
Message-Id: <1-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
In-Reply-To: <0-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DS0PR12MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: 70e09e68-308b-495c-2743-08daa22b33d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z1V7jza5fxhShg4D9VpfzJILf0wzD7sq8I6Ues0wIz7XtD4R3XHnLE3/1BoMccIXHjwFG0/1vES9s+FDkNRnQBHPLnqcABzp6pwfVqUpQ7X0scyX/AWSInPKi3tCCMwNKKZERfQGLSo0WBOSQAImA5B8KohRvxyOGzTIdmfCiO1dNmzvSEsPB/teQVqdtCeS52NQf17sLl/HzfVsxSlYUhfISXRG38wbImXhiQmDNCUngMSSUevQcHhqfTa5n+0BrP8bXW9Xojf4YgpXoSyFi5DS0NfxvUFYiXLSTPk1VeBBSF915cjehcgedUftqyCFem3dyaaMquxU/FxWddDFJAlW3Vzx0iJ5ILHiBJhV2ZWv+d2HjZTA9L/QIKagdFtOlkqjuAizd9QBv37bXa6WJfw+2Rx6fwhhxHcbYhg//yokEa3kvsBhpxrTIEhmZVZqXNDfQAjpbGXyXi4Rdsl47oJQsdHrGh1J7R1aWFgSUUfIwssNVsZ9Y40ct/9uC6OsF968Txh9duwiYWrdBcOgqlUCXuzrGHy/fV5kM8vndca+P0wSLm8UWrY5su47jS3vDbojtuD118ZmWyrfIMPAHMDkNSa7Tjtqw0nT4ziVd4/cOK3m1Ujfs5KcVI100FFuzz1Fr40h6IJ1Agb7685Ek7RJYIKn1/oXhokqS5s2fez6kB5MFNEsDRX4gVWweG04BsXyhJuLnBMLX3JG3tLTlp9DImxg307PwbdyXkAUJHmsvt8VXTL0HTwKaLBRSD6V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(6506007)(478600001)(110136005)(6486002)(26005)(316002)(38100700002)(86362001)(2616005)(186003)(83380400001)(6512007)(2906002)(8936002)(66476007)(41300700001)(36756003)(8676002)(66556008)(66946007)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qr/v5bOiJtjZgjL6Pw5hiZr/ooq3CM8Nt2QWHJGMZBGbjoDAfgMo389tC1ob?=
 =?us-ascii?Q?BJwuGS2ewh8yWFIwYAugnPKghwIoW2xrZEEuRfjEaO5+huoIdoeJ6cWDM/Wc?=
 =?us-ascii?Q?LEk4IGWfjgMS4J86IhUqqYw8reBjJyBLPuWrnMnioKlVea+k0WZnFiIloVXh?=
 =?us-ascii?Q?lNTvWV/AiK/RzyaxWFuNBu2QEfT7e3KPxhJTsuFqIAQUuaayz6qptVYxVz1B?=
 =?us-ascii?Q?ugTf1PAtce88VeQMlqkPkvLRrij+1yIk58ITxBENaohUinZOlCBA7TmQokzf?=
 =?us-ascii?Q?EfR5AZe92KDcUfKOdaOeA1FI9FOHwDWHopWeL0xdnEMckHZYKQojb4qqMLxL?=
 =?us-ascii?Q?8XeVQnAxezQ7BRsON/HDsYxpjd7v9TOWbTaAheL6jfgUTGlW6im+H/3CMX/c?=
 =?us-ascii?Q?fu8iIuVN4tBWKJ6UC69ozKZ/911Y+rD6jqllLz468PbrZNaVjeY3ZeUirD/U?=
 =?us-ascii?Q?S0NdkTOh167UkTWp4Rb0F8OPYs3bIwAlVu8/DKwUbiMWfYTgsdgI00Al+XUu?=
 =?us-ascii?Q?eySnZ2Nw9GdbFKlz4hT0scNGB0gVLBuhvLV//X/0hiAV8yTNKir59BXzjGRg?=
 =?us-ascii?Q?4287n86UM+RUHu9xgsn8gc2pxl3plLKQY8lOgK+acbsQ+fdk09r1ACRlkG0I?=
 =?us-ascii?Q?D7fcpVurGrk1+PktMC04OoeEUjEr6njF8AqmnYNT0KJosWrKR1L4g9WjI+8g?=
 =?us-ascii?Q?57uMyrub7PG2SfHttc8BsMJicIhiYMCD4FJeMKLxV2rIapep/BzgFDwNR6ox?=
 =?us-ascii?Q?GHTD38tqJcAw+pxEkPhjezluWUgePCOQGa8qWYFB8pL7envud/so/3cQX6J6?=
 =?us-ascii?Q?0n4kGPk87WZ2CGuiE3HItj63OJMJgSsDz39V0ud//f+59V1unGw0xaKRlRlF?=
 =?us-ascii?Q?tRUOImJxiE17Zcf/THdtzi0ki2uJBkvsdlxxTXfTvJhgGcULarXWvUuDqBTA?=
 =?us-ascii?Q?EEMlFeekm9DOH/sNYgalS6SaM8B3Pg2hyYBss8kVUPP2cbxj3ndIeCvwshn2?=
 =?us-ascii?Q?Ywp7KbzXc6JJC+S+RRo9sGH3MYHzj38GTKTgupEB1RDI80p9RemvCX7y5mL0?=
 =?us-ascii?Q?0hNamj2QEsKu9DX/RWy+PW3n0fQf2HNoHRZelCHfqnGzdboDO7MWW/LDBcMY?=
 =?us-ascii?Q?gJgbYTEc4XNWCS/7zxXDjPRVyAuOba6jY4eS907loVzOFFdD8O5G5T8p6L/c?=
 =?us-ascii?Q?XFjJaxyY8gU2U3B8V8LVOKc4dlw93MtTBvxLQWQOrwFh5vS8YkL+ug5utrDs?=
 =?us-ascii?Q?RB9pD2voLaNt/r0WCS8XO14/Vvjj/aqv60yRTpljqvALM1NGCvVbfUuEPNuI?=
 =?us-ascii?Q?G5fqSNPhwxyDdOdFAzlRGCyWASLNfi3alsaxTvC9QxXSW1ChAy5HgpLi7kEs?=
 =?us-ascii?Q?C7uLfmf+X944a8WgWuJzB4dQ2WYUGbVSxISyo1lEdd2KQ3B0m42vHTND5dB2?=
 =?us-ascii?Q?+PxtfgLqydmlscegQfd76zIwmVODFnEYSbxhrPNim08uhf4A8BHZCqixEFTs?=
 =?us-ascii?Q?U6vmty9GMCKlqI5zRxxRuJQm4jvByZ4OKn/G21oZcSodaEB/Oceq/9vrtgN5?=
 =?us-ascii?Q?pqqiDK5PQQtmio6LxDw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e09e68-308b-495c-2743-08daa22b33d1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 14:59:26.4403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c0F3wiXeEhQby88DlNnOt4rqbwNFloJZwYvO2+0xq6cuUBRKseX4G5xMgHn7IVH7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6389
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kevin points out that the users is really just tracking if
group->opened_file is set, so we can simplify this code to a wait_queue
that looks for !opened_file under the group_rwsem.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.h      |  3 +--
 drivers/vfio/vfio_main.c | 45 +++++++++++++++++-----------------------
 2 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 039e3208d286fa..78b362a9250113 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -48,8 +48,6 @@ struct vfio_group {
 	 * reaches 0 then the iommu_group is invalid.
 	 */
 	refcount_t			drivers;
-	refcount_t			users;
-	struct completion		users_comp;
 	unsigned int			container_users;
 	struct iommu_group		*iommu_group;
 	struct vfio_container		*container;
@@ -61,6 +59,7 @@ struct vfio_group {
 	struct rw_semaphore		group_rwsem;
 	struct kvm			*kvm;
 	struct file			*opened_file;
+	struct swait_queue_head		opened_file_wait;
 	struct blocking_notifier_head	notifier;
 };
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f19171cad9a25f..57a7576a96a61b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -186,10 +186,9 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	cdev_init(&group->cdev, &vfio_group_fops);
 	group->cdev.owner = THIS_MODULE;
 
-	refcount_set(&group->users, 1);
 	refcount_set(&group->drivers, 1);
-	init_completion(&group->users_comp);
 	init_rwsem(&group->group_rwsem);
+	init_swait_queue_head(&group->opened_file_wait);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	group->iommu_group = iommu_group;
@@ -245,12 +244,6 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 	return ret;
 }
 
-static void vfio_group_put(struct vfio_group *group)
-{
-	if (refcount_dec_and_test(&group->users))
-		complete(&group->users_comp);
-}
-
 static void vfio_device_remove_group(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
@@ -270,10 +263,6 @@ static void vfio_device_remove_group(struct vfio_device *device)
 	 * cdev_device_add() will fail due to the name aready existing.
 	 */
 	cdev_device_del(&group->cdev, &group->dev);
-	mutex_unlock(&vfio.group_lock);
-
-	/* Matches the get from vfio_group_alloc() */
-	vfio_group_put(group);
 
 	/*
 	 * Before we allow the last driver in the group to be unplugged the
@@ -281,7 +270,13 @@ static void vfio_device_remove_group(struct vfio_device *device)
 	 * is because the group->iommu_group pointer should only be used so long
 	 * as a device driver is attached to a device in the group.
 	 */
-	wait_for_completion(&group->users_comp);
+	while (group->opened_file) {
+		mutex_unlock(&vfio.group_lock);
+		swait_event_idle_exclusive(group->opened_file_wait,
+					   !group->opened_file);
+		mutex_lock(&vfio.group_lock);
+	}
+	mutex_unlock(&vfio.group_lock);
 
 	/*
 	 * These data structures all have paired operations that can only be
@@ -906,15 +901,18 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 
 	down_write(&group->group_rwsem);
 
-	/* users can be zero if this races with vfio_device_remove_group() */
-	if (!refcount_inc_not_zero(&group->users)) {
+	/*
+	 * drivers can be zero if this races with vfio_device_remove_group(), it
+	 * will be stable at 0 under the group rwsem
+	 */
+	if (refcount_read(&group->drivers) == 0) {
 		ret = -ENODEV;
-		goto err_unlock;
+		goto out_unlock;
 	}
 
 	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO)) {
 		ret = -EPERM;
-		goto err_put;
+		goto out_unlock;
 	}
 
 	/*
@@ -922,16 +920,12 @@ static int vfio_group_fops_open(struct inode *inode, struct file *filep)
 	 */
 	if (group->opened_file) {
 		ret = -EBUSY;
-		goto err_put;
+		goto out_unlock;
 	}
 	group->opened_file = filep;
 	filep->private_data = group;
-
-	up_write(&group->group_rwsem);
-	return 0;
-err_put:
-	vfio_group_put(group);
-err_unlock:
+	ret = 0;
+out_unlock:
 	up_write(&group->group_rwsem);
 	return ret;
 }
@@ -952,8 +946,7 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 		vfio_group_detach_container(group);
 	group->opened_file = NULL;
 	up_write(&group->group_rwsem);
-
-	vfio_group_put(group);
+	swake_up_one(&group->opened_file_wait);
 
 	return 0;
 }
-- 
2.37.3

