Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2651E5F663D
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiJFMkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 08:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbiJFMkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 08:40:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1117B8E9B8
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 05:40:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTDWfQ+QEjiJUh0hAvFvgLYoqnwsb7f4sV8hFgW2xSch0P9lXpziApfpa+rmLVyRkGr+M2zCA78N5V1mORMvY3lilGpvtba7EEBnutmCUYUWbtm5lnmL9+dxvJWmKpC7qNsTmCABPZS9gKX0SwosgspyysxIMY3IZWDnv9fR1zVUUQ2f8vPCyGoc79xO0a99/PQPAtDcXmnv8JtAvQc65Zn2nYBAxcXfQ3FD2IbZmv8LEvIzG7sU7c8Cb/It4kIc3wXvYxzpN5WEc/LZBHpqTlOR7npKBatlzNJzhTqJ6oX7mYmQj7MBj9qpZuX/AtgJ57T9H+qh9yWpPo79hn4TTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DdpmnGehi6YjTi3JHxLHGBHN79koKECIzopPhtdlCEo=;
 b=kb5lVg5zk39VAFRLNoDu4VuCp6ZbIp4LLMiJEBobKV0t1AEwaV8HX5KeGriSzfoMCw6up6W8kJu0xyZModHAb0zpMwYeHelxyJD1J4sX6oX0ZlsjF0SyE20xl7gKMZ7mqRm8k1kzoEgWL3cb18Uhj2IMLa1UTExCvCwwUWGGMdC+Oql8fJVhfMHq9vCOCOnQ92YU8d+8gp9jw3klP+Ov+Pd/+lStm6vls5lMleDNOJ/VK+bZavnbO0AQNWI0Od9uaMj92zXglsEP5EDTegI04Lr2CXEiPtMhzVUzzOGDy68BKKlTtz0gdLhhiSFd2xZgWE5vYgcZTpnYTtztxrvr6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdpmnGehi6YjTi3JHxLHGBHN79koKECIzopPhtdlCEo=;
 b=Yqkb77EPuR9t5ru98aEH8vNrAEXMEZJGeEK6406fR4bhSsrCKhiIooGilBFxW+C3z3BJdqaUK1phEPo6rWb+0uOFbB60Y8UGtrX4dsUvLKWho2YkyUUJCD3kVf5jJQ7075CNVDIZBJ0FfOpFkOH/ZNU7+FCdPpACbyIeWwMmKEQ19q02nhFLkC5ypsuncw2ZtI6mi0R7QFwkfcBDWYVQPIEEOUJNpmTD5v33z9JWiWVeyNFXN7HxC82M6v48S8fn5NAIfxdFVu0zWgMC57E+YN4P9u5hXNgQQPd7mtyq6PXe8QisGdJuQ+6HbR9omykobxix0JZ1oXoOFeZyLv3BLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5736.namprd12.prod.outlook.com (2603:10b6:510:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Thu, 6 Oct
 2022 12:40:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%5]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 12:40:40 +0000
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
Subject: [PATCH 3/3] vfio: Make the group FD disassociate from the iommu_group
Date:   Thu,  6 Oct 2022 09:40:38 -0300
Message-Id: <3-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
In-Reply-To: <0-v1-90bf0950c42c+39-vfio_group_disassociate_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5736:EE_
X-MS-Office365-Filtering-Correlation-Id: 47452018-e111-48de-aa5e-08daa797f94b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rEoJwYqhBryX0ePBz7YsWBamGIbS5u/zfyg3AZx3m4lDWNXtFSVc0H6cWeYFrK3ixjyHx3hF/D2aXgbpneKwAAu2Clco71HQ/Cmw8R8F3Yu0SEWGD78UJBzugyvzr9DxW313ennKc4VPGuT1NMIIz8eOsK6kGK7mxJTJd0ewaxOPdYUypyNouDfDSjYAqLiC1OaGNfKG/FQU4VLNlIVgEXv0v/VCu4Z15ePtTZoZJgpfFDitCnSM4FP20ZBTZIH63mwqtR5eI68h3xWE1KYMHOtAeku7ZQJcjT4FOMx8EbP2/oAMifpKk8LsisizbCUwnY9bMWFCMyGlL1QisN2GEKkOjkk7JXpdYlIpsd4QYYkIwOI4/10N+dum1gUv0yA7oOZ5BEtA9XuzVYZ72rKjW/5qAO4MS1w4WTiPcPo8tHMDfBPvjw0X9ZLSKWFdhddgqNXCB9pzKLdkc+6PGq4J+kzBJR8tLOV5pZbrXrswlmJFS+OgH0z7kuvNLKXCaQUmGnUU2rdInaCVJdlejuxZTfAHCTXKo4PuEhvcppiybUBkU8TWs+w0MFbDDVAc15CW2QiLbSgsJld5+rEJYHkifS9jlZVLFsukoz8OHWtBGkCz0ihcLvl7Vk8nSBiup99DuehJMStIElXbpyzPTkFpnLl9bj+OQn+ZciQ2Z58dkNzcDP3oVCMHftcLu0QKLF+YPKyzy7KwFYnVs8KEwstd3GPlXXE6aMlZXpie4+EoVW0E0m08K9ByLVhN/iij7Bwj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199015)(2616005)(2906002)(38100700002)(54906003)(66556008)(66476007)(4326008)(110136005)(8676002)(316002)(8936002)(41300700001)(186003)(83380400001)(66946007)(6512007)(7416002)(26005)(6506007)(86362001)(5660300002)(6486002)(36756003)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UPL16QnIhI2vE+Jwq10TM0+sNJiqUxoP2q1lKcPYOb6zpzKUleqpWQyz1S+X?=
 =?us-ascii?Q?0WsU0pe2bCe5s8smIASmnWoIAYXi8lpGoF1phjIUR87vMsp7e5TfZgXtkG7t?=
 =?us-ascii?Q?ejoCRUKuTBnqV3r8X1OX9VY4gb5v2OusRoDGwkpv99DFD/1USZXrziCLIheB?=
 =?us-ascii?Q?vvFM0rxfFkW5Vyc87OA7sRwK3C49xHvGIIcB5aEIDlZzWrSQdfJMFpqZ24Fr?=
 =?us-ascii?Q?Ye4Z2LuaaAU6eKj3BVijUZdMbQpDv8RFuIlf74/9BDKbYEKDoS0zck22KjEG?=
 =?us-ascii?Q?p2/BQ/ScggCG+Dt+uDhfdiqKxwE6Wfz6esUCPq97PfnK+CvlMNENUUzMNnHO?=
 =?us-ascii?Q?eVBdp1pqz4iccVMmiRMbrELBvojPcRVHBA3xm8KblK2xN8KEyiNFPu8op2WL?=
 =?us-ascii?Q?VUOBczEtT0eUQOZJad3wLdceEuZTRmoTWuJYrIjhDkA7ntAIbC/SXS1Rv+PY?=
 =?us-ascii?Q?f7pMro/012Im16CgWNcUfrrIbpDqvfpbnemOOlWMc4vx8m9SO1Z9cdG1OAEu?=
 =?us-ascii?Q?QiiAABBsuB0CsewrcfPlrs7LmJ8/c5FOVndfSFO4ZIwcXJmmOqdtd3L775tL?=
 =?us-ascii?Q?aFffCgB3nmszDRrkUupceLiF+44REpUfGk1SlzHUWjU2AHCDAzJZA8c767be?=
 =?us-ascii?Q?N1l9v8MqoXNIdpNi1YrC8Q+nawFZFJTRb1i1YIkTsA5GjO/AG/GxlH/n3oOC?=
 =?us-ascii?Q?SgEgPUt2CEUSF46mTfMWOjT7iw3nTMK2cPTLLVAk92uzUsSzqmyeieLASJLP?=
 =?us-ascii?Q?+F4c2JJPECUZ3qGMex3SCFhtAXdVY3quaNer9VArUmn3JAieohtrvdC/mTyF?=
 =?us-ascii?Q?bxq0rytwrJNlIkCP/KorUxq9xjoxbfljzutmuwU3qWrJVTYJ7+jxjo6067SS?=
 =?us-ascii?Q?pYvlCav2clzcJ79Z9Ns9hjFBKZP43s8mQW8vyoAXNhab88wrJgtvrhP8amRL?=
 =?us-ascii?Q?ujEJIFvog0apCAtjxCi3pyVjxAJGiVYoALJbr3c/QAZtnYuN+CLfv76kFlfo?=
 =?us-ascii?Q?nLyjJ4iM0MTxqadlDXKT+4EgbANMNeoaSe/syTuyoB/BSUTpsc5VCYiCHy0e?=
 =?us-ascii?Q?N+5kiAjsQvpHfJa174TZeds87GhAkXapJC1jahzPuvwZ5rmW3JKZvoRQrgH7?=
 =?us-ascii?Q?BXl6dJpz9WwoNosJYsQOJmvWDP2iFs7PZ4We9fm+2BxHGsfXG3D49q3gizvs?=
 =?us-ascii?Q?M2qVJ0sdQDpoBV3DBmFnKecppI8fRVZTIWlrQ4K+qvbgZKt4hj8Qn6p7alwm?=
 =?us-ascii?Q?8S6pRK8f8fuRj7E8G6Wkcn4lSiTkfdmuLbmRjPronp5VV49QfNJrqXytbD6u?=
 =?us-ascii?Q?NB1HU9ANJ4JGSuOio8DW4HyKfF7AP5wQndrpyoydD4qeDnrf8lUGw7rSrPIp?=
 =?us-ascii?Q?PPBgiWKgamQBvDQsRlCySml7EQ8u1s5PYigi5DXab37pcwFvNfgHZw7m8HT5?=
 =?us-ascii?Q?1OlUXx4obxxO4ya+3m4316W0BOAS1ODy66uERQA/aNvslusiB74I3/85AA2V?=
 =?us-ascii?Q?azQgjO2e97XLqPJyDFnRmUZW0E3GsISHbTQNOfLT3YsToATF8kncNeT9/8Ao?=
 =?us-ascii?Q?Po1lB6xvmZ7pMG0/hi4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47452018-e111-48de-aa5e-08daa797f94b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 12:40:39.1670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAKDG/H6y3Kk5DkoVYIkuwOJkumotfYbhaNEutKr2An/DgNnZpRYipzF0f2jSAZ/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5736
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the vfio_group struct to exist with a NULL iommu_group pointer. When
the pointer is NULL the vfio_group users promise not to touch the
iommu_group. This allows a driver to be hot unplugged while userspace is
keeping the group FD open.

Remove all the code waiting for the group FD to close.

This fixes a userspace regression where we learned that virtnodedevd
leaves a group FD open even though the /dev/ node for it has been deleted
and all the drivers for it unplugged.

Fixes: ca5f21b25749 ("vfio: Follow a strict lifetime for struct iommu_group")
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.h      |  1 -
 drivers/vfio/vfio_main.c | 74 ++++++++++++++++++++++++----------------
 2 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 4a1bac1359a952..bcad54bbab08c4 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -59,7 +59,6 @@ struct vfio_group {
 	struct mutex			group_lock;
 	struct kvm			*kvm;
 	struct file			*opened_file;
-	struct swait_queue_head		opened_file_wait;
 	struct blocking_notifier_head	notifier;
 };
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 233349867fb36a..360742cafe3a1f 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -133,6 +133,10 @@ __vfio_group_get_from_iommu(struct iommu_group *iommu_group)
 {
 	struct vfio_group *group;
 
+	/*
+	 * group->iommu_group from the vfio.group_list cannot be NULL
+	 * under the vfio.group_lock.
+	 */
 	list_for_each_entry(group, &vfio.group_list, vfio_next) {
 		if (group->iommu_group == iommu_group) {
 			refcount_inc(&group->drivers);
@@ -159,7 +163,7 @@ static void vfio_group_release(struct device *dev)
 
 	mutex_destroy(&group->device_lock);
 	mutex_destroy(&group->group_lock);
-	iommu_group_put(group->iommu_group);
+	WARN_ON(group->iommu_group);
 	ida_free(&vfio.group_ida, MINOR(group->dev.devt));
 	kfree(group);
 }
@@ -189,7 +193,6 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 
 	refcount_set(&group->drivers, 1);
 	mutex_init(&group->group_lock);
-	init_swait_queue_head(&group->opened_file_wait);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	group->iommu_group = iommu_group;
@@ -248,6 +251,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 static void vfio_device_remove_group(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
+	struct iommu_group *iommu_group;
 
 	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
 		iommu_group_remove_device(device->dev);
@@ -265,31 +269,29 @@ static void vfio_device_remove_group(struct vfio_device *device)
 	 */
 	cdev_device_del(&group->cdev, &group->dev);
 
-	/*
-	 * Before we allow the last driver in the group to be unplugged the
-	 * group must be sanitized so nothing else is or can reference it. This
-	 * is because the group->iommu_group pointer should only be used so long
-	 * as a device driver is attached to a device in the group.
-	 */
-	while (group->opened_file) {
-		mutex_unlock(&vfio.group_lock);
-		swait_event_idle_exclusive(group->opened_file_wait,
-					   !group->opened_file);
-		mutex_lock(&vfio.group_lock);
-	}
-	mutex_unlock(&vfio.group_lock);
-
+	mutex_lock(&group->group_lock);
 	/*
 	 * These data structures all have paired operations that can only be
-	 * undone when the caller holds a live reference on the group. Since all
-	 * pairs must be undone these WARN_ON's indicate some caller did not
+	 * undone when the caller holds a live reference on the device. Since
+	 * all pairs must be undone these WARN_ON's indicate some caller did not
 	 * properly hold the group reference.
 	 */
 	WARN_ON(!list_empty(&group->device_list));
-	WARN_ON(group->container || group->container_users);
 	WARN_ON(group->notifier.head);
+
+	/*
+	 * Revoke all users of group->iommu_group. At this point we know there
+	 * are no devices active because we are unplugging the last one. Setting
+	 * iommu_group to NULL blocks all new users.
+	 */
+	if (group->container)
+		vfio_group_detach_container(group);
+	iommu_group = group->iommu_group;
 	group->iommu_group = NULL;
+	mutex_unlock(&group->group_lock);
+	mutex_unlock(&vfio.group_lock);
 
+	iommu_group_put(iommu_group);
 	put_device(&group->dev);
 }
 
@@ -531,6 +533,10 @@ static int __vfio_register_dev(struct vfio_device *device,
 
 	existing_device = vfio_group_get_device(group, device->dev);
 	if (existing_device) {
+		/*
+		 * group->iommu_group is non-NULL because we hold the drivers
+		 * refcount.
+		 */
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(group->iommu_group));
 		vfio_device_put_registration(existing_device);
@@ -702,6 +708,11 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
 		ret = -EINVAL;
 		goto out_unlock;
 	}
+	if (!group->iommu_group) {
+		ret = -ENODEV;
+		goto out_unlock;
+	}
+
 	container = vfio_container_from_file(f.file);
 	ret = -EINVAL;
 	if (container) {
@@ -862,6 +873,11 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
 	status.flags = 0;
 
 	mutex_lock(&group->group_lock);
+	if (!group->iommu_group) {
+		mutex_unlock(&group->group_lock);
+		return -ENODEV;
+	}
+
 	if (group->container)
 		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
 				VFIO_GROUP_FLAGS_VIABLE;
@@ -938,17 +954,8 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	filep->private_data = NULL;
 
 	mutex_lock(&group->group_lock);
-	/*
-	 * Device FDs hold a group file reference, therefore the group release
-	 * is only called when there are no open devices.
-	 */
-	WARN_ON(group->notifier.head);
-	if (group->container)
-		vfio_group_detach_container(group);
 	group->opened_file = NULL;
 	mutex_unlock(&group->group_lock);
-	swake_up_one(&group->opened_file_wait);
-
 	return 0;
 }
 
@@ -1559,14 +1566,21 @@ static const struct file_operations vfio_device_fops = {
 struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
 	struct vfio_group *group = file->private_data;
+	struct iommu_group *iommu_group = NULL;
 
 	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
 		return NULL;
 
 	if (file->f_op != &vfio_group_fops)
 		return NULL;
-	iommu_group_ref_get(group->iommu_group);
-	return group->iommu_group;
+
+	mutex_lock(&group->group_lock);
+	if (group->iommu_group) {
+		iommu_group = group->iommu_group;
+		iommu_group_ref_get(iommu_group);
+	}
+	mutex_unlock(&group->group_lock);
+	return iommu_group;
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
-- 
2.37.3

