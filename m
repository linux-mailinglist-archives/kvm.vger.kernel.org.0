Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908AE529572
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350436AbiEPXl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343532AbiEPXlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:41:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE3719037
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:41:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keI9JqQ1w2QrXSkzaGRTjAUCaNYC9GfUjkE/SgK8Kw99lsP8tS/IfqNOmD4+1AyC5ST0TJU5pXOt2mhbHB6oEbyO+ydimxGjQ9w6W1zcEccZNZaH16FQ1v2t8khJFUzaNGI4uVncEmyLzqmvVi/uF67UCURGDf/a+j1OSHTa3eyehzyRSNj0UCjjKeW9yfT+ej5N2mg0sz2cP4r2YeXYU0nPSdqkGfo8UP2zXGzjF22ONsX55EhLOOnSoL42OSyPQgedefu8w2qg/WBDR4Ky7hTmLya0ej8ga1trAM4f0FEBbewv/y/zjc2DDJka/1U2syouFyLCDMvdctefMK5E3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sinb5I70cfM93cz8xq12JVQ/GetCLCVBR7EIBoAKJSU=;
 b=RQl14Ze5lG1lqFcvV0/BrsqpkQxhnpPm6YXqRM41XB0PNL/rhIEdBgZ47JPbobZgTMttRkxAVj65jVWvNsEwvnxD48IKcfBWC21mDiOfaz7LRrKoVoTRHANnXQOvnQ/BDH/zkGA8elu9UJ7FMA457N5oZYFwM7xieWuffDTS62T4gaP/7+DyUvGDDGjzW5bYa1bV8ut8pxAjNHy2/1V6EZ9uBau27ynIYB6ieSBbBeHUDe87yB2lEbpPvFsEQ7pRm9EmppfGz10Wp2GFRa220Yf8lQDW11TjbUE8Ljtu5LVpwmS5f2aL6mDIa2hktCDG785Z/43m50KLHLKMmgQjxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sinb5I70cfM93cz8xq12JVQ/GetCLCVBR7EIBoAKJSU=;
 b=IzwREdebk3Di2QqAOjXXroFo7y6QvYBqHSxdO0YztWXePlJ6Sgd4zp861s4iCEX8bza7XflwFXagbvH2sEiO2sQg25VCziccGZJ9tCRNr2pYmS2zKmFHVjgl+3J1GyoFyWNLgkzdAlRL/pdeyY3Js8n/8j/ZpjS+2b1orl+lOqo/MV1KXeceBqUdHBiTw0VJD+9iNZ9wT8uDuylytkVDEftmLztLjW8lN3Rzzswz9vRsGNsMKudYVO47EkKKUv8+0zsLyXIjhZWdufvYALWCIiC9L+VbYhwSFH2UgaahuGB4dG8vB4Bd26Y1WHmaN+U4NK2jZ0JxHwuHs0lYn0LRmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3832.namprd12.prod.outlook.com (2603:10b6:610:24::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Mon, 16 May
 2022 23:41:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:41:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v2 1/6] vfio: Add missing locking for struct vfio_group::kvm
Date:   Mon, 16 May 2022 20:41:17 -0300
Message-Id: <1-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
In-Reply-To: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0260.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::25) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42ab409f-531f-421e-cd7d-08da3795964d
X-MS-TrafficTypeDiagnostic: CH2PR12MB3832:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3832D9ACE5853B86170CB43EC2CF9@CH2PR12MB3832.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: utTyNvdqDOfxAWtajQiJfbgdKaDU9xt+h/ZSIqYkSG00XzPuJfOC2ziXYRA1H/GZdHi8VZF/NxcmsAcIeJZ4NogkoLvaJLb42cfI0KPBlI6ylKsorI5g3PiwSlByuHX9+DIV46qJG/6/7qQtZ2Rf2fc+bu2sRrD9RDSLRWEErT3iPELBeYxKnLFgZKsP6g24TCYMiN1139Td9PvLP2YOWxEShTy3T+fRhKNW9GJpm7+qUSdxC+MXGt4GcoFg5m+7fIWvRoM2UixmT0Hn0JBQ4UWPY0tnnfuRYujTyWMqMd59PDnf9LDWLS6CJIgHwuJxJFJ62DMlGdwNrwa6ryCugTU0TgaViLZpzV9LJJxjNwANVKv/E04xnM75yywJGqCQcA3NjCqnF911CH6T6Kl9qOzaK/d1p5hfIz+APH+s4G/NIRVER5onLdRObgNqvShOBw/1iDZXjENEGhhmdu+qyUq2eQ3oJDw5S1hEB23BcYCt5HGz5vucEnOwKmt7R2F9ztTJ5dp154t6D/eFeVX+VDTAMc6hmuEPkJLzZoeoyuKDB14Q64uXrOE+1RpUfqwz8ZTd4tJ1QFPjH1u1GFZ5k7w88MQHUB060KaJuZDcVTfhP9HqXPKuTOrgcFsRU13OLc+ejm4vXF78JoApkCAG37ynCU78N1MFSlxy/7Q6tpgNW1q3UIG+HqTnFojaZbq1RflKzaDDoWao29Ubp6Ldiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(5660300002)(66946007)(110136005)(54906003)(316002)(66556008)(66476007)(2906002)(8936002)(4326008)(6506007)(86362001)(107886003)(26005)(2616005)(6512007)(36756003)(83380400001)(186003)(8676002)(6666004)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IsfpieJCXICDDrG3JRp2y1WTwrxMjESehZl4CIiJxIhwjBx2bBPGrdG3Q4O1?=
 =?us-ascii?Q?mBZsmNIC7SZ9tQJ4lSUopqorix/yaA6+QRhA0cydwNNhXtONsImhAbeoeBni?=
 =?us-ascii?Q?2Xq63g9eY1sICOEHH6z5bkpTirleV2q+SV2kLMuTuLBbR7DZ0HOgJZDQ9XgI?=
 =?us-ascii?Q?7sXNRqqWJvdzUTsMHkMUeYXDDoxYOtRyd75zfbhNYJv2YpiuggjOhWE9V+th?=
 =?us-ascii?Q?/36xhEXwE4vQHMJLV7hLfoV8tj7OIZeaXfaN6KTwyihmqiIm+ZdTHJbmjXjY?=
 =?us-ascii?Q?eT8yidB4md90q2gmCoKmTSuXn5N9CerwoV9sK7edAvFxH787s17hi7tvbqxy?=
 =?us-ascii?Q?8bNEIj4vaY1sShdn0+AT/nb/SwdDWycEl3uFW9vQR1ru0tndumZkukY4/tPP?=
 =?us-ascii?Q?P+ttn+MyH/cAsW+XuQxoUO40rxf2p4eQ47yaGTw/1TgUbzj38dOhD4QtbP0a?=
 =?us-ascii?Q?vtysbLIIbdn3HzVTGGOW31UZVhBqwfzrGXY1qLlg9zDfGVIl6paApdxo5hMb?=
 =?us-ascii?Q?G+EOad9KfnqwKAGlwJ/2u314rLYIsVFmneY9WkGWlqXkbKpsiwnCJ6XzoD2a?=
 =?us-ascii?Q?SCjPYZ8K9ENzgz+fyAOd25do1qhpELrxifn98XYcEm9Pd93zQOKKpmjvT7Ht?=
 =?us-ascii?Q?/+LEhXBDlw1CY4ZJSSqV+Pm63e7dhyuFDacsZ7rbkpc3kJiXLlyy7DDuHmp9?=
 =?us-ascii?Q?xVRqkv3N+LkBuG3+qE/kKL/wxi0XYOygAKeu3vF3+vjW9myds3nc5X3bwoIg?=
 =?us-ascii?Q?eB2eindZUTNQR6oCqIZ79Cz1BWGxWx8GqSHTt1mN16n1mBdSWRtLlEBSctbj?=
 =?us-ascii?Q?6eBqyjoJNugCX/00xsB1MGeNuHWNitxT9eEaNJveyV4/H0GH3Ff1X+bp1Ww9?=
 =?us-ascii?Q?bDLZj0HJQx0sqDRcYzOorervBerezeH7E2pIqNQG0RGZqDT/ZScLqgHxdUX3?=
 =?us-ascii?Q?StLCg9B1KjqGiwv9RAPF8NwGZnLo3wpeG74m5uUyif24SfKgNcsTgZtaZ5vz?=
 =?us-ascii?Q?telp0M901yvqdRWLELJv5L3xHBK6abmHunC/Yi+/8fMxGya1ZYHYPTg+CO9D?=
 =?us-ascii?Q?WGqdSihMCgV1oX2wwu1nVnARo45S/+xCHJp3Yo7YfnHBDI6pPJb7QkGA1n/l?=
 =?us-ascii?Q?gJw0AyoGl4jP5zugguWIgqvh8xRxR2Ph6frOdzSQwhA9WQ2/W7Xm/HEvXu1p?=
 =?us-ascii?Q?wFO8isuf4uVubt5132O+2p3Krf6TrcWtioaFq1dc6QZ0/ujyQFcYYB/UsrgU?=
 =?us-ascii?Q?qoiHnXdb4ba/eWghzPkKxXJ6WNNHXi4WZxwvQsypSFYkaNPU1ID57DzZ60AW?=
 =?us-ascii?Q?ArnN4dUW3XB+VG9KTGFenzpyPxTfRyS8pchi/jYLHw/g8bZ+v0cetO411SQ9?=
 =?us-ascii?Q?DpL/F+oOgS/4A/HzrLkzBMMYxZjJKC1Xyt9tuMWTo4Pl8wiRHrbLDEhNy6ah?=
 =?us-ascii?Q?IaQY602hCWtkHxtgENfjln4VODaGh+ByDNhWurAK+EXxL2qpIK38FUAGI5Fx?=
 =?us-ascii?Q?MMd0cdnFHcRGpQ1CA9JzrOQJ2R/4U+J/BFdj+uk7tVH079oBZgib9x/+qZtS?=
 =?us-ascii?Q?g1NVrY1ZjieSA7c7L6aHxZD+GtqUJkfDE2+BE9BCncIO1eCmrfVjHK8nNDYf?=
 =?us-ascii?Q?tmM7T2J8niKaGmVrIimTgmz/Ye47SfQodDu9EPZAMe8OKWGfzOWdH7NFNV5M?=
 =?us-ascii?Q?UoHN6l+rWrmTPqh0+nvADUThn/IvWS54Eg15KmFHjAzJCP41eGb3t6h6PgQ+?=
 =?us-ascii?Q?bcuwzFlpVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42ab409f-531f-421e-cd7d-08da3795964d
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:41:23.8620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iIlgY3DQILPdTfAfkV7oWClZzybP2v1UCC8flU/wsGNsYSi449V+YeTN2TStnl3a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3832
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without locking userspace can trigger a UAF by racing
KVM_DEV_VFIO_GROUP_DEL with VFIO_GROUP_GET_DEVICE_FD:

              CPU1                               CPU2
					    ioctl(KVM_DEV_VFIO_GROUP_DEL)
 ioctl(VFIO_GROUP_GET_DEVICE_FD)
    vfio_group_get_device_fd
     open_device()
      intel_vgpu_open_device()
        vfio_register_notifier()
	 vfio_register_group_notifier()
	   blocking_notifier_call_chain(&group->notifier,
               VFIO_GROUP_NOTIFY_SET_KVM, group->kvm);

					      set_kvm()
						group->kvm = NULL
					    close()
					     kfree(kvm)

             intel_vgpu_group_notifier()
                vdev->kvm = data
    [..]
        kvm_get_kvm(vgpu->kvm);
	    // UAF!

Add a simple rwsem in the group to protect the kvm while the notifier is
using it.

Note this doesn't fix the race internal to i915 where userspace can
trigger two VFIO_GROUP_NOTIFY_SET_KVM's before we reach a consumer of
vgpu->kvm and trigger this same UAF, it just makes the notifier
self-consistent.

Fixes: ccd46dbae77d ("vfio: support notifier chain in vfio_group")
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 1758d96f43f4a6..4261eeec9e73c6 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -76,6 +76,7 @@ struct vfio_group {
 	atomic_t			opened;
 	enum vfio_group_type		type;
 	unsigned int			dev_counter;
+	struct rw_semaphore		group_rwsem;
 	struct kvm			*kvm;
 	struct blocking_notifier_head	notifier;
 };
@@ -360,6 +361,7 @@ static struct vfio_group *vfio_group_alloc(struct iommu_group *iommu_group,
 	group->cdev.owner = THIS_MODULE;
 
 	refcount_set(&group->users, 1);
+	init_rwsem(&group->group_rwsem);
 	INIT_LIST_HEAD(&group->device_list);
 	mutex_init(&group->device_lock);
 	group->iommu_group = iommu_group;
@@ -1694,9 +1696,11 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 	if (file->f_op != &vfio_group_fops)
 		return;
 
+	down_write(&group->group_rwsem);
 	group->kvm = kvm;
 	blocking_notifier_call_chain(&group->notifier,
 				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
+	up_write(&group->group_rwsem);
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
@@ -2004,15 +2008,22 @@ static int vfio_register_group_notifier(struct vfio_group *group,
 		return -EINVAL;
 
 	ret = blocking_notifier_chain_register(&group->notifier, nb);
+	if (ret)
+		return ret;
 
 	/*
 	 * The attaching of kvm and vfio_group might already happen, so
 	 * here we replay once upon registration.
 	 */
-	if (!ret && set_kvm && group->kvm)
-		blocking_notifier_call_chain(&group->notifier,
-					VFIO_GROUP_NOTIFY_SET_KVM, group->kvm);
-	return ret;
+	if (set_kvm) {
+		down_read(&group->group_rwsem);
+		if (group->kvm)
+			blocking_notifier_call_chain(&group->notifier,
+						     VFIO_GROUP_NOTIFY_SET_KVM,
+						     group->kvm);
+		up_read(&group->group_rwsem);
+	}
+	return 0;
 }
 
 int vfio_register_notifier(struct vfio_device *device,
-- 
2.36.0

