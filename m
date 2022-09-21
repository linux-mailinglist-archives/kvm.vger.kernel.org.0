Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC7995BF24D
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 02:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbiIUAmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 20:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbiIUAmm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 20:42:42 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766B44362B
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 17:42:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mhCA9t6KDHm9Q5BiMhdjnjIQ+vRflBRFKA+LTgiBUi1Xvh/oi73lsmG9HNQogU3XVmpTRgzSyqyOZCv3qcF6zLsCuDArwiNiqGd0H5iUql5RDVD03NNc6b9FwHwLCTFDAhTlb9X7nhNjqkor8Svs4HcFjBSzHzP1U0olEx6rg6cL+b7S0RCDBxw8OIb+/k/XtkW5p+o5qeGydEShAP91zjEKBsHdzHjCiTyb6YFH9C6621gMJlXJjTHHgfumpGxSVINZOsD59zYFjvv61930q70K5dR6eiYfd73DK2gjdpEG5YN/yTF0GO7BEljnTYHmOmsi1EhcRgkN20IeCN1FTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTYVoB1wolZx4ApFD+ObJ+MspunbB86PcJXoAI9sxVI=;
 b=Dsv2q8tlRNZePaRriHjvm/N/6vjQ4z3QAo+iXNRdS1u+HvAwiOpZAI+FfaY/aGlCpjQOg4lK4MAPVtoMLDlT37wHw2HEBYrdzeWrKf7RKo22ihrsKQw5PZ9UudJQEGj6bdJLr5oFLC6IQpy1FbELUozLZZGn1NgE7pKPrkig4DJEPbgy3phCAITpJhAc0zThOhwnyhAff6HR1zN8P7u551KqFbqG5Sbp957nWiu2gR9KLQr47DC6ovqxmmdlNmg4S9SGnfW/CiTwUP9Rnmv5/e99KF0JZAOpkCIzJPwWI5LDhpd06E2RzpGDelrhPTCRZHYxeJg/zVLysTRdjCsFLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTYVoB1wolZx4ApFD+ObJ+MspunbB86PcJXoAI9sxVI=;
 b=pan4pC3adULMnmA+CycHduxkD4IzqwXC3PXIPErtwF9jGv06+Gf6Sm3j6HoUtf1xuS8Hqbqw79F7fqY4hdAdJEWLTGctWb0H/W6OT78mQC205QHpSBp/oz+wpWmkvn2Bwbi3c3EOn9pgHWbUDOWuGmUSCZTQfjWWhycD08tekvpRdi0ewaPUQObo7Cex9vD+tN50ahxIE4cVIgq4tnSeDmTsOV5b7cX5KWd/7+rt3pS9ALV/1SXrbkg/wmgXAHcdpPtZ5T4rsNvTUNrn9o1fcyhh0kJm8jgqiptfzC3j9QKA9PP5ZvvGVfId6J86R07Rw5U77hhWpOOQwbkjDv/KTQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by MW3PR12MB4426.namprd12.prod.outlook.com (2603:10b6:303:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Wed, 21 Sep
 2022 00:42:38 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5632.021; Wed, 21 Sep 2022
 00:42:38 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v2 2/8] vfio: Rename __vfio_group_unset_container()
Date:   Tue, 20 Sep 2022 21:42:30 -0300
Message-Id: <2-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
In-Reply-To: <0-v2-d7744ee9cf4f+33d-vfio_container_split_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:91::11) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PR12MB4181:EE_|MW3PR12MB4426:EE_
X-MS-Office365-Filtering-Correlation-Id: c640e0aa-8d96-4765-763e-08da9b6a2e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tMYZiVXFjOmrphfSAkcVRx5waYUm5o26F2Jji+LXl24oAeGd7U2Ac/Nw8dkm/j3yMFQPnUGqDc44C+MWudvyCDa3Or96Li7uLs23bu+hfn9DKXGQG/TpCi3Ihv8BkYrh6RKr31zDxWPVKSY9tfA7o9PxTvl12UQlqm+jABvijitaCKpZzNRX56bd0vPpKoT6WOYHmFmD4UAhmXRJN/qxllKKVXkBfvXungkNN+H/YEpHYegleFHnpBCAmZ0X0XrAFW4nAny5fX6qG9ulH559TtXUmtER8F+BiltzxSDH510of40XiGPRj/CO2XzTOnhZypIFcMyFgP4/nXqnkzBygW1PIAqKa1POxUcUS5svryVf3JtFcE8HyIf/2BLaZZwYbk8qpSRvOsuiwdYRYEIEUuo/guzHg9lIsgegGLLpyClFekAZAFthOAI4yhcALKptbBKZwuL5bPJWo+n3q5j97sta2y9jIdFSqA7pTZ53Owq0GlF+LRlzjNANx8pYZ3Q+hFGv0mCWFFVrzR0Spyvj+7gw+RCZ09h1F2qOUyAv1kDJ+3QGOgDU5hGcXNaiMPGiZgkt02LUlfQQfnd19Pv5MfLNc3RI6xHYAL1/D+UAeMtT7Wy0ZVztk3jxd8XW14uniEM3lN06VvbKv4aoiJtJkqjpBofPeFEeneVb6Z2LQbaDoHAProIG16yRx+TfdWDmRyO4khQj+mlPV7AeTRi41h2/3tBYuH/KYDtRZIizZoWdvxMecQWWh2fWRNnrblks
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199015)(38100700002)(8676002)(6512007)(41300700001)(316002)(83380400001)(110136005)(36756003)(86362001)(478600001)(2906002)(2616005)(26005)(6486002)(6506007)(5660300002)(66556008)(8936002)(66476007)(186003)(4326008)(66946007)(6666004)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wgyMJeNNEb830ZI0GLgfVWITXgjX6hEocHkS2J/ghmn5Ps6kmGWmHfkHWShv?=
 =?us-ascii?Q?wIP15OTzhsw9aEnb1l0DCE+GPqqqK7s2xO1WtUGUMd/yJU/3k71mrdjstjQh?=
 =?us-ascii?Q?uneC281b71LvECPvZxtSMxhz6irbgZ7W6jSXcFza8GZqsm+bkOluivndYfbb?=
 =?us-ascii?Q?L6FOOhTEmWGTJqEk9mNeAQn6k7QiwPNMOcYn/zDGQ3gV3GqyInox807bwIWy?=
 =?us-ascii?Q?lnUFUZF18t0S6UEUGt3OmYi7FXM+/YmuPI3r8Gs1AaD2pDtSDUAMcVBQ7R1x?=
 =?us-ascii?Q?+yacPEtlNj9asj/jO1gpHpmGgm4n6F1MzJfvH/evAkHW2Yqeqb5X7A6njVvT?=
 =?us-ascii?Q?LIu7uQzHNJnbgEzeSvfbKobuhl5fvi2y6ubIUSBmZrjbu3mxjZkEZRh1k+UP?=
 =?us-ascii?Q?flVkmlRGoGVvQE7NCB0Gg1hFqDXuSd48sCElHKuifOfkZPxfYFSuVXmIFT9L?=
 =?us-ascii?Q?Yeys3dioFrnv7ci2fqMDiLCW8YWjl58+v0B6/XRgbbb1ZpEjZxXW5Te0WTid?=
 =?us-ascii?Q?SbKhvMEYcr0KYJ3WXKGU7Nyk2MwUURgfwF061qcScRXwvkBbbWYJLcLPhjFm?=
 =?us-ascii?Q?BcpqPUVDs3+Mmqytqb/vcp4G7QAcK6ofzDYUfb6l+TiGSXaSnSStV5IZinjG?=
 =?us-ascii?Q?LXYMuwb/n0iZujOq23ouA0mS0TQ7ukTsnpp2wppI8Hfl8juAm4kzXEjIwm0s?=
 =?us-ascii?Q?/ZYI1EByVk+I/cTlDAijiq0Y0CVfH5KRrrPNmUK66OLzP+SfSAMdp0nCbpIp?=
 =?us-ascii?Q?CXBzYhRMm+OCwzo8qA21WtRrQFznrlgMfVZxu7FzmJSM4wSdcNp4veygPobz?=
 =?us-ascii?Q?Q8ulBpn9TVywmbmPDj8ypXDRq8RSORgKGTtDDiS2cvT0bvV5ZuvBDc4sYWhg?=
 =?us-ascii?Q?vIq6fsioOO0OWZUrrdIGyTmym3KPqy0kkxgh7G73r/dnLtsN2GQajlZJJxQz?=
 =?us-ascii?Q?eJS11lN+JCqMLu+mrqBEZ9spROjMI5fVKPXTI6ho46nRKxt6loAaJlplK9ad?=
 =?us-ascii?Q?jQ/Ku/1JvrhdhZMDZGbh03Fcs/hm/WN2LhkTdD/HVi10VBFFAadLwE8KEvAq?=
 =?us-ascii?Q?O8DcNN5d35LfqfDGQGrCx8nCADh0//5zS1a2XbeDAbi3WTX8YQ15vWyoFMwN?=
 =?us-ascii?Q?mUgxTy91YEwNBNJYhUe39qlZ9AN1MxQXOe9Yqu6cxgAV72S67C5Dtde8RAM8?=
 =?us-ascii?Q?86kGJkrgpe4X5COzWHrf496nsG3WtLpvVpKhwQQ5ESo1CKUs+gfkPGDFauSD?=
 =?us-ascii?Q?hiD/sG5A1fpYjIR+eppKWOGplUfnIJ7xd1udZM0/Q67a5tXtoPnfMYYv7Zbi?=
 =?us-ascii?Q?SY8LlPlAp70cIW8Vt/81THSPjegK3LpBnDPle3yU7Znqi8gD7IoaCW2dYt5c?=
 =?us-ascii?Q?p3vqchFjuvEr5SSPqxyz+OtIW8qSloMeM1dp8K3VIbwZ2TjprztvCdftmBgU?=
 =?us-ascii?Q?xJJQuIMN5ZmI2IhE1Z43rkCFs22S0pIVR18TqQkt++QPP1PjHMRk2YharK2w?=
 =?us-ascii?Q?CBQViYazqhLUTkyjVemKlduxaxngw1pBP4EMVPq4xtDjbSYIzXgZx2krCKpv?=
 =?us-ascii?Q?s90ypmJM1o2wXUAMZLej9e9JHOfMBoHIj7Fv3AwP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c640e0aa-8d96-4765-763e-08da9b6a2e66
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2022 00:42:37.5057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSCTjHRNtncf8TbdhDsBdVSYt2bsukfLujpUY00W8nBhx7DZVKnVPmz0m0qmXecT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4426
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To vfio_group_detach_container(). This function is really a container
function.

Fold the WARN_ON() into it as a precondition assertion.

A following patch will move the vfio_container functions to their own .c
file.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 77264d836d5200..eb2fefb1227e9d 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -926,12 +926,13 @@ static const struct file_operations vfio_fops = {
 /*
  * VFIO Group fd, /dev/vfio/$GROUP
  */
-static void __vfio_group_unset_container(struct vfio_group *group)
+static void vfio_group_detach_container(struct vfio_group *group)
 {
 	struct vfio_container *container = group->container;
 	struct vfio_iommu_driver *driver;
 
 	lockdep_assert_held_write(&group->group_rwsem);
+	WARN_ON(group->container_users != 1);
 
 	down_write(&container->group_lock);
 
@@ -979,7 +980,7 @@ static int vfio_group_ioctl_unset_container(struct vfio_group *group)
 		ret = -EBUSY;
 		goto out_unlock;
 	}
-	__vfio_group_unset_container(group);
+	vfio_group_detach_container(group);
 
 out_unlock:
 	up_write(&group->group_rwsem);
@@ -1331,10 +1332,8 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
 	 * is only called when there are no open devices.
 	 */
 	WARN_ON(group->notifier.head);
-	if (group->container) {
-		WARN_ON(group->container_users != 1);
-		__vfio_group_unset_container(group);
-	}
+	if (group->container)
+		vfio_group_detach_container(group);
 	group->opened_file = NULL;
 	up_write(&group->group_rwsem);
 
-- 
2.37.3

