Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E6462CC41
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 22:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239221AbiKPVHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 16:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239217AbiKPVGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 16:06:53 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A131C6AEC3
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 13:05:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oX5gd/jr6CTdIEaISwAJ7v8DPEUpMojAKvyRlXKKd98ICU3nkRaPXI/6lxVVy6D/4zaeExomLWQlLG0D+2AOo1lfd5+p64cKN7PKootyraJ3F5TJ8i0etiACaTwt//z3tHcZMo7QJiIi9v/EiMmZr0PyBKvTM+QF+llbMlDhlkapszoc5iAirGvvUgnZq8/lSYKAl9Avxw0XCUJQnkUpT14wUJJfDyqvj3qMx8JTqtsMtHpSVn5f0EybKw1QOV46WvI3ufP/DMzPEYKoBbU51Q+f+2SNjEde4iwNjdnpQ7WZIjQdqf4JKNHZRV4UbO09J61dJ8X6jHlxdCkNvf9hmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EHgYvVbfWBUl3S9gV31npkG/TW/G8a78fDH+HNt7HuQ=;
 b=SZau8NRTL1tHjm7oHqa1yD2IXiPRLyiO5DotkUMUDVaYNzONRhoVeHYsySUdRow19k+OTvnCmwL4l0iuQpepNUV0Dj9slQDxTDgeqoqy11neEpv1WVI7Tjm/qg06sgKdJooJZ7Jt4x8yAiM3P65sZc0cDAWySgqWZGbgcSDLGGJLZcxxfswytzdyUTi+lsCiMa+8EKsvUZgb/MH39f5Q22c50vpDdx3lfSj5Oo+GDqN7VWOTiRqTV3E1qfifR5ZGBHjXRUoqLCQn9Qznni0EcYoGdGdP2R65Vm9qJ6wUcIYvn5DkWIaKQLiMzLT9mtbpzHQj0oyyzy5sltphH012Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EHgYvVbfWBUl3S9gV31npkG/TW/G8a78fDH+HNt7HuQ=;
 b=HQsgKu4jDj3xtVDFP7+ixNK4w3OJdCJawlSO+Ack/jSIAsdQl2zWEU8fi7wJcKK2z1ljTOkzNuUTT3ztmXyYgGvq6pA7ze1GUStqUVlNpcjGIu8MEy5QpKgks/KCiktWC58L4XehU2kr+IRosUIs1BlXhd/f1VWvHfG4guMwzIA1Sg42aMOT42gwAD/1axFxfOH8Uw15DToujMwK85H/p6dwqYmuj8IoBm1/V3rx+RyxNG1R4pWLup599MYmvRNvEhvUrzJshV5mEZQvfSBormywoPLB3OhBWpjWUe0morvOYGsv6NTwc3S51UzDlnvaSYl+/ZJ2t6nbOrtQGdR51A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5609.namprd12.prod.outlook.com (2603:10b6:a03:42c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Wed, 16 Nov
 2022 21:05:44 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5813.017; Wed, 16 Nov 2022
 21:05:44 +0000
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
Subject: [PATCH v3 02/11] vfio: Move vfio_device_assign_container() into vfio_device_first_open()
Date:   Wed, 16 Nov 2022 17:05:27 -0400
Message-Id: <2-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
In-Reply-To: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR01CA0029.prod.exchangelabs.com (2603:10b6:208:71::42)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 8950aff8-c54f-42da-4043-08dac816506b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2jXpWNL0zqZghovsuhPONTDiswDIrUMiSNszRdVDz1HMM8Pz0ngDyMTW+/v4l2QJXUnAxluA5Y//Ri/zIkIUTYOUl/XW08yBZhChl8LvXb8MjQSjc0nXvl+y62xpM3P6D3jZjsglS4jydrgDSurVu158v+jUkqm9+mWhGCpxq2E60t0lhi4fUvvCehIv2TBiIVUgFiRsefyLI0QG0TCMinU7gz9Ga3WS6X4BRQvododEXr6jTav9qnW4sIkkQPMjUEULCqbmZPDXgFFEdGZvgQJbU678l6LH0AePNTTOmQ3MmvEVoXe1uh6s1ZdRV/VLkcU2Xs9l+EzvWGO/Dt2NdD1UtgqS0uJKE7v+qQT3C+JfK+W/cpSbS61ghM44duY2jX9FStT8NHiTb9LNNji8FMLvli5vHQGCd5kaj+r8WxMEcArKag1ouNnYnJM2tCxklRLtPR2p7w8lPc9ACijXusY3v28zhPOowmUpuHuLBlFkewb2vdPEq/9RhIfeMHgdcGRvsPXcICvQj3O4fKUEbkF66o6Ojo2e5XCTnYQPYb/QkZ5QWcO8Nl6HDhaT08HMsfNYvdoFPO9dpkvhhZzEnYehnpPgb9e7nAdHiz5C5doKjSSzMsr2IO8iXpca4oPEqNd68W6I3cgOlnFtH1PHjb6KvC8L8Sjcg0f7C9cTvJuAT+kMdi4tPutwbMJ9lgmzRGXkcY4Va5H3tw6HRkdw3xSuaJVbzTZ4AgE2CqZ+CaWYfzIPBe3JLJZW5ix5a6IkowW2tdVVIVATsR/nGnijTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(451199015)(109986013)(86362001)(36756003)(38100700002)(54906003)(316002)(6506007)(6486002)(478600001)(2906002)(5660300002)(7416002)(186003)(2616005)(6666004)(8936002)(66556008)(4326008)(66476007)(66946007)(83380400001)(6512007)(41300700001)(26005)(8676002)(4216001)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6UES4EnB4n4M0Kvfk3E+ER2VkaqY/0NUgh1xV/6Igw42+lMd4FfLOhmCmNPa?=
 =?us-ascii?Q?yo4/qUPCkbRA1x/YurCNO4B5fV8rEM37XiR2/rA0nl3REpyPRKK43beDquXL?=
 =?us-ascii?Q?0t90/zQUr23ZyES/9RD0+HoGx+d/mXG4EJQ3rrIzEHT2Sdium3wY3GRrGJrH?=
 =?us-ascii?Q?5/8c2undeYVpDLYyJM/bSskAk45ROmbFAYbsNS9UjvS5DcPTeFefB9b99n77?=
 =?us-ascii?Q?xH8yVi6BKxH5LXrQBI+6BRnmlf2lgFjhE7Fasjw+/1uhdFFzGe0QJDshDZBL?=
 =?us-ascii?Q?vo702LQO6QSJyWRWo0kerOlkz6ngDS0JTkALth73sqqlW2h5s7AdddLgprCZ?=
 =?us-ascii?Q?ntdJKsAqTjczxDjN5UgHdOlFTCvxv2o0c6sTHKvEOIC8Wg0hCAU17xUyF5MU?=
 =?us-ascii?Q?wFhR1T4xseWttk+cVkWsGeYqiUMYByb/p6l2ZFXPWFrTMhhFycnAAsElADXN?=
 =?us-ascii?Q?YU3QqbehLV+ES4ZmjToUtfsVDjBUFRUX7dIS8TBBUisZUoM7q9z7WivQjd6X?=
 =?us-ascii?Q?+1KcYju+C5am4GHrNtROvLue4TY7uphFBd0QUYwmrJEwm05MmSyM8SikibKx?=
 =?us-ascii?Q?sQBashNDEE/DPMNgsPEiVEP7wRUvZ9qJ3QZ0UjIaa390p6/lHz7FdAUs1I07?=
 =?us-ascii?Q?K16yhQBAhQeggVwnWzIwUPvfc5Iqilq4gT3Mc/vVKl9fTGhoouMWsb7NhanB?=
 =?us-ascii?Q?/B4HOTsaqyof5ufhKQ/+gbpi8YkNVb009zdNXz4Q6jC3kg4uMHyILD4lEvJ+?=
 =?us-ascii?Q?PoOJf89a05uSHHmk1SWDgXda7XtCvCyPBWp165kxDoZkRSPUC5qmfQHmuXWC?=
 =?us-ascii?Q?C1LFkp52w+FjMBBgDrfEPE7vfuuroTL6ufzzYVrZGTqGv5u5ZBL8ezJBC2Y2?=
 =?us-ascii?Q?OA9OhC/IiTC6ydwCg/aYDfPTYO66gp1gj1Z9ta1Pul+FpBwm3oiIrmemYvKB?=
 =?us-ascii?Q?oja3ZGaZrHU+P1+EJjnpd9Z398a2cisStxTpkG1yLhLXQH7Mh/3OyAQwjY3j?=
 =?us-ascii?Q?vGJvRSgqw+u4PrQ6nScHv5EqV6cNuS1g7GkXRUcF/Uy3VlJuyuL+IWH1nUnB?=
 =?us-ascii?Q?uvUgg3qPolUFaEgUYofBn6Y1UqKEc2B2ghWxeyPWOTvWU74x2A/ZESGgWgfR?=
 =?us-ascii?Q?uYLZ3mdLDq1b4HAZFsgZO1Snz1kcgTgdRtSb+od8sINDTZJ9R3Fpr2jHg7q8?=
 =?us-ascii?Q?37rVhC8IAVej8X2Iblk6tJbbKYawk5x4SYKf0zBfklV7lDg7OFlIPQc1haDc?=
 =?us-ascii?Q?I86luYW9wFRb1ZU6gOpL8SuIRGAtPO3mAiAkr+RtBLjijPHjJ2/vMNbARNwa?=
 =?us-ascii?Q?sbo+LrErVj4fnV0tg71RMcEWnsp6WgZFRBfmppsOQFkZSbW9sx17CbCVdOEE?=
 =?us-ascii?Q?J8TftwhIjQX6APYioLCMNdzB1tU5RzFVajkax6C8j859+QPZ4d+p6DG8x6/1?=
 =?us-ascii?Q?/ke5OxuN/d7bfTZGo3dEBR1Xt2Ux0+xkTzu3lgKaL2QouVhXkgvEktPNHSil?=
 =?us-ascii?Q?8p2dnvLK4iSeyW5GcCUTAX1PCBO7aW10DuCcP0+VPhRs3MbLb9nzo2F0xBWU?=
 =?us-ascii?Q?Mmc5nQfwFLIpjomsQug=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8950aff8-c54f-42da-4043-08dac816506b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2022 21:05:39.1638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wcFRNH3BMeYDYXGGAvWGZAFSU+onsMWxJdbne0qc0B9Svk53QK6Jl4PYj7PJfdHL
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

The only thing this function does is assert the group has an assigned
container and incrs refcounts.

The overall model we have is that once a container_users refcount is
incremented it cannot be de-assigned from the group -
vfio_group_ioctl_unset_container() will fail and the group FD cannot be
closed.

Thus we do not need to check this on every device FD open, just the
first. Reorganize the code so that only the first open and last close
manages the container.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Yu He <yu.he@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/container.c |  4 ++--
 drivers/vfio/vfio_main.c | 24 +++++++++++-------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
index d74164abbf401d..dd79a66ec62cad 100644
--- a/drivers/vfio/container.c
+++ b/drivers/vfio/container.c
@@ -531,11 +531,11 @@ int vfio_device_assign_container(struct vfio_device *device)
 
 void vfio_device_unassign_container(struct vfio_device *device)
 {
-	mutex_lock(&device->group->group_lock);
+	lockdep_assert_held_write(&device->group->group_lock);
+
 	WARN_ON(device->group->container_users <= 1);
 	device->group->container_users--;
 	fput(device->group->opened_file);
-	mutex_unlock(&device->group->group_lock);
 }
 
 /*
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 2e8346d13c16ca..717c7f404feeea 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -749,18 +749,24 @@ static int vfio_device_first_open(struct vfio_device *device)
 	 * during close_device.
 	 */
 	mutex_lock(&device->group->group_lock);
+	ret = vfio_device_assign_container(device);
+	if (ret)
+		goto err_module_put;
+
 	device->kvm = device->group->kvm;
 	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
-			goto err_module_put;
+			goto err_container;
 	}
 	vfio_device_container_register(device);
 	mutex_unlock(&device->group->group_lock);
 	return 0;
 
-err_module_put:
+err_container:
 	device->kvm = NULL;
+	vfio_device_unassign_container(device);
+err_module_put:
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 	return ret;
@@ -775,6 +781,7 @@ static void vfio_device_last_close(struct vfio_device *device)
 	if (device->ops->close_device)
 		device->ops->close_device(device);
 	device->kvm = NULL;
+	vfio_device_unassign_container(device);
 	mutex_unlock(&device->group->group_lock);
 	module_put(device->dev->driver->owner);
 }
@@ -784,18 +791,12 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	struct file *filep;
 	int ret;
 
-	mutex_lock(&device->group->group_lock);
-	ret = vfio_device_assign_container(device);
-	mutex_unlock(&device->group->group_lock);
-	if (ret)
-		return ERR_PTR(ret);
-
 	mutex_lock(&device->dev_set->lock);
 	device->open_count++;
 	if (device->open_count == 1) {
 		ret = vfio_device_first_open(device);
 		if (ret)
-			goto err_unassign_container;
+			goto err_unlock;
 	}
 	mutex_unlock(&device->dev_set->lock);
 
@@ -830,10 +831,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
 	mutex_lock(&device->dev_set->lock);
 	if (device->open_count == 1)
 		vfio_device_last_close(device);
-err_unassign_container:
+err_unlock:
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
-	vfio_device_unassign_container(device);
 	return ERR_PTR(ret);
 }
 
@@ -1040,8 +1040,6 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 
-	vfio_device_unassign_container(device);
-
 	vfio_device_put_registration(device);
 
 	return 0;
-- 
2.38.1

