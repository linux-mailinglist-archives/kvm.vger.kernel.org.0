Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586B269F9D4
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 18:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbjBVRRx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 12:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbjBVRRw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 12:17:52 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61648B0;
        Wed, 22 Feb 2023 09:17:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hLG+XHeMfr7zrLrTk8zCPSucK3y5U7yAgZ3xFdx4C8PM4ng1s1rPjNFu7fN6nrsVzodr3zjIN1QbFISxaGKBSMFkYbfxEtO4szwd561NLfgLFG8qITyfIqqOPDNg+CmX3CNhWZZQm4vofewfb6jNBFvIZSzxklcs/grhapKbqNIMPERkl2hPJCeQazA3CqWA2MF9ENviPryJtcCMNb2QPcHIQ14FxPPTtAoXgSWsEXkvoyvz7SGo8/h5Q2xVnVZtDf9tmx98VYaov4Vrivp1ehseY5cB24xFKAKjlVs2px3Qp3J0tiRO+/fF2eCWPE46GVe5Ba4k8QxGls4TOKj3Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/zNqOloHgEzNr2drTcGd6U/pz/7xMB1lXGFlmv8Q7k=;
 b=ZbVMfsXGekR/HkdU8v8LDHOabAaXlGlQ9UgoaIl4a2z8LCfiPMKTqpmk+onR667jaYO1NLu38vsIJX1P7VjwrqlZyOaeciqThORMYMx7XLMWzuqEC3P3udTdTK6pOaepOU8LIT6wuQLU4qfqVfCxKg4rMloxZFKIZXISKeF/56dgC90XgxYK5i8QJWCL0kDhkBzz8PF7V4YHn5rBIYeuLPik9erSJXai5FS9BXarpOZi6J4KW+9y1EvM0XT0+iRQYxBlTKLdV1pcowk9sCTn6bkQ/xWV6IJLqvQfXvgIfgzKMjl6LPKpYNRpmN1ztbGPKmdEb04nDPQ+lvl2t2g24Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/zNqOloHgEzNr2drTcGd6U/pz/7xMB1lXGFlmv8Q7k=;
 b=LLYoFyX3edd+G5QfOOvSufzV+45o76FwKgHcTwEsECQjS0DZf6EDnK+qEkCBTkcv6zvCGuGQ4lRtrmHcqAOk8idYRYSmZ0HewNKTf1bvl3DT1wKDYGS07KwL5q2Ifr47GIFWVeop5lWtR16CxUJ/uDkHZEQTyEXPrpFk02DsdHa1YhfJJMLB4cZnp9UkXe/J/veOyAy+CSJ35lMgOuRF8tKAeOowHfiJwri6+ld/pR7Kaqm4KJAF1NaWXZHasr6rvhiTAVPo+1QHc7FFF6b2b/8nvLw4AgPsKwg3sINRGA2PQNiC8bM6BsARBSRsoc3OqGTDlqA5dst5uBxjYkEXbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Wed, 22 Feb
 2023 17:17:45 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 17:17:45 +0000
Date:   Wed, 22 Feb 2023 13:17:44 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v4 09/19] vfio/pci: Accept device fd for hot reset
Message-ID: <Y/ZOOClu8nXy2toX@nvidia.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-10-yi.l.liu@intel.com>
 <BL1PR11MB5271D122329B6908BDE1F8328CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
 <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529B33D098225CFAAA7D63FC3AA9@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:208:23b::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6323:EE_
X-MS-Office365-Filtering-Correlation-Id: 4507a1bf-bc16-42c7-8ebb-08db14f8b6ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z2m5xlp8/06EpOgu8BhZA4ZM/ijZr9VEqrpHiCtuSmnpE9IE0fcuJIPIn+BdSplXNJjstCBVztEFksLcMUuGzrTjIoPwniHYj8gINcETgwpmj9XPilNtQPjtk9IoMLoArrSxE1Uo/NjjRfPyy/TfR5pb01O/Za27faalSVNHi2NPW5LWnT2QKlsQez2tOsk499VnuQooQtzaoFxiohuWm1L6jH/JS+f81+aIA5VlYrFfB9LVrGAcBDnZ4xeaeo0JucvR3nHMz6D1bBuEaoSivdAUm/WshzE45s4Pl1uBlHvxOivxN6EMqo/8B985mK6M52SoRKIk75QcTE1cReFDZS4TdK7de8o57dRzDrYGvhfJ5JA0iSsqQTQEYYmaHHIRt/6KXSJxAz2vsoSdXXEFTnwvMZWqi63AUybMOwBSzhdBtlU8UWcWjTzDvtwnHc7Qt7gGB1gP7TF23/hgcXnhbaF3ds1mVBCeZ/kJc21AMvb/euPxGGwWpCIwZmuwlZZQ72ikikm/cxMca59+ZUolgeeNAbLC34T3DwJeYr43t/5dUmBGndxNS5TGzG6eOwVgoLbynay8kc4NRvmB1xLpP0BkpfG6w2xxR7KpJcMlPcZd9b93gG+uEzqrW4Fhm7DrER6s5hD6y1YclOTbmTy3zQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199018)(38100700002)(2906002)(6512007)(26005)(6506007)(8936002)(186003)(41300700001)(2616005)(86362001)(7416002)(478600001)(6916009)(6486002)(4326008)(54906003)(83380400001)(5660300002)(36756003)(316002)(66476007)(8676002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cWb3NN8CWjk7kg7gBZACpFpIltHtQH8IIsw2tPvEa5j6Wa0n/qZGGYjNzYw/?=
 =?us-ascii?Q?VP1gtdiB5k60E2O6ceEbW2hViLKW1Pq/OejkglqyyCeTP4Ohqe627YIQnmwR?=
 =?us-ascii?Q?Aa3jOHP5E1k4Qvo+OzDa5UfQ883/COZlB3Jqab1A1mpDUrDvyChaXWmRj5Ww?=
 =?us-ascii?Q?sPf0t1GiEyB8+QncpSLc7dm67vYXj15JDHZI0nbbFMtW+OCfMXRMIfzZHSfH?=
 =?us-ascii?Q?DtCoVwo4JtCQ6xe420B1OGKr+TzIxOHa2t2lz4wFllOPhJwKUQzT1BGqC1vp?=
 =?us-ascii?Q?5/81GIkp8eBmDtPGfScvStcQ10DlsA1Sadvja72Bxqf9+GxqdpUIRPp/c4D+?=
 =?us-ascii?Q?B1htFmutiPmWXnc+gBFNbCWIxp0NmXU5YwOxrWGknP1N7IUq+pZgFMnaLzjX?=
 =?us-ascii?Q?Q7O1UsgqQ/b+oNXQxov3hS8a95Hcbw+ls3I4+tpMP+AzZsEaN3ENnuHacY0N?=
 =?us-ascii?Q?pGQEYbS/jeQu0T48jwLYu/5/V4wMbAYi0enk9ckVbVBa7veBGzTx6vKk0bpQ?=
 =?us-ascii?Q?IVrbQr0veiN/JGyomDGkIEJ4K4uUyYgS0Wwn4uUbtT/4AZgqzPPC/xLRV/s8?=
 =?us-ascii?Q?gUm32rveZ0+UN4OL1nyjZVf/NKqjjTxwZqSqFTxG6lWI4XPi4g52qDs0MNud?=
 =?us-ascii?Q?iDhuZRO30wZNYPT3IQq1R8G3ckwyOS/KAQ3RWsYCGgYVq5FN2pwApCcaUQjd?=
 =?us-ascii?Q?GMF3RBK97cVMm6XRkqKNdY/jmF345DYdb7KjgKJU82acmMLlJJwuuKf0iqXE?=
 =?us-ascii?Q?GkiwnNxmOeUuKPAbsM+IjwV7FTMK8jGKGEULR1MfJlCKqiR0PagljTtuPbeU?=
 =?us-ascii?Q?2onah7dwVtZBd7vjKaEUDF4q1waS3fu2WtHRItDeEx1t5EatjHSOyrtDcra6?=
 =?us-ascii?Q?DD5eZS699qQKv6LKlLQNLa7sED4W4q+SRrjtxj4rdrRB+OM9DehmXKx17ft+?=
 =?us-ascii?Q?sWf8qxBaZUXXqRGJhh/Urfe0tcd9DsC7bmcNhi5ulVwzZsB1zaIwnJgvuLlP?=
 =?us-ascii?Q?WrW2WOpOg/5mIHBXIM99Y9h8glEPGEZXMwhKkYpUsZyECYCp0WiBFkSQRrZ+?=
 =?us-ascii?Q?Vo58M8YSp03HZQtoT1O/Y2OXrqhjNoQygYQpbf4SKXsmFoAB3Lrcs7udiPTl?=
 =?us-ascii?Q?wD6rJK/ghh9JRXomLURWfx5iuiV8dKSz6Ul+z6tqcfI5Es35SbXyMFmuWOA7?=
 =?us-ascii?Q?vh65UlM4zlMxhIW+UKc6154Jn9Kmqw+Ndm6T5MxPipgm3zIcWfgTP1/qCBNb?=
 =?us-ascii?Q?egA08URH1Uot6RBSyY6UZckBUzdK7MuZQu4gV7+/ymTtfSRFMiED90InKHwb?=
 =?us-ascii?Q?pVCtRILmwHdgbocnNsy4hzwJtsEVkWtmSqMVaw7MjbBlc1GdqeOdLoJQ3000?=
 =?us-ascii?Q?WHEImG7BexDy7xgZXgJ18NKDxDny9T2UZHN4AI0sl2wpoLbY9/mFwtHL8c/a?=
 =?us-ascii?Q?uNkK3EOe00rpS2b8NONU8+5mDFYSwwJwRFE/VE4ziU82iaQWJAgye48K/FP/?=
 =?us-ascii?Q?xE8pgdltfg5CyURL5NoelFojmUo4qKxnEuvyw7EqaEbM2mKL36txiuB02a6t?=
 =?us-ascii?Q?X6N9SHW67Ir72jTRrXfYSGAFukwWJiJZ15I45MQ+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4507a1bf-bc16-42c7-8ebb-08db14f8b6ba
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 17:17:45.6149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0PsMZP662U7IccsXIPEJwu3Q8ILqhKfdOMelSBVpZgy4lKL2sdwMIuGQVtdrOO1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6323
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 01:35:06PM +0000, Liu, Yi L wrote:

> > btw this patch is insufficient to handle device fd. The current logic
> > requires every device in the dev_set covered by provided fd's:

Yes, which is what it should be

> > static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> >                                struct vfio_pci_group_info *groups)
> > {
> >  	unsigned int i;
> > 
> > 	for (i = 0; i < groups->count; i++)
> > 		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> > 			return true;
> > 	return false;
> > }
> > 
> > Presumably when cdev fd is provided above should compare iommu
> > group of the fd and that of the vdev. Otherwise it expects the user
> > to have full access to every device in the set which is impractical.

No, it should check the dev's directly, userspace has to provide every
dev in the dev set to do a reset. We should not allow userspace to
take a shortcut based on hidden group stuff.

The dev set is already unrelated to the groups, and userspace cannot
discover the devset, so nothing has changed.

This is looking worse to me. I think we should not require userspace
to pass in lists of devices here. The simpler solution is to just take
in a single iommufd and use that as the ownership proof. Something
like the below.

Jason

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index d81f93a321afcb..a5833bfdd7307e 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -114,6 +114,34 @@ struct iommufd_device *iommufd_device_bind(struct iommufd_ctx *ictx,
 }
 EXPORT_SYMBOL_NS_GPL(iommufd_device_bind, IOMMUFD);
 
+/**
+ * iommufd_ctx_has_device - True if the struct device is bound to this ictx
+ * @ictx: iommufd file descriptor
+ * @dev: Pointer to a physical device struct
+ *
+ * True if a iommufd_device_bind() is present for dev.
+ */
+bool iommufd_ctx_has_device(struct iommufd_ctx *ictx, struct device *dev)
+{
+	unsigned long index;
+	struct iommufd_object *obj;
+
+	if (!ictx)
+		return false;
+
+	xa_lock(&ictx->objects);
+	xa_for_each(&ictx->objects, index, obj) {
+		if (obj->type == IOMMUFD_OBJ_DEVICE &&
+		    container_of(obj, struct iommufd_device, obj)->dev == dev) {
+			xa_unlock(&ictx->objects);
+			return true;
+		}
+	}
+	xa_unlock(&ictx->objects);
+	return false;
+}
+EXPORT_SYMBOL_NS_GPL(iommufd_ctx_has_device, IOMMUFD);
+
 /**
  * iommufd_device_unbind - Undo iommufd_device_bind()
  * @idev: Device returned by iommufd_device_bind()
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 26a541cc64d114..28f6db1b81c1af 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -27,6 +27,7 @@
 #include <linux/vgaarb.h>
 #include <linux/nospec.h>
 #include <linux/sched/mm.h>
+#include <linux/iommufd.h>
 #if IS_ENABLED(CONFIG_EEH)
 #include <asm/eeh.h>
 #endif
@@ -179,7 +180,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
 struct vfio_pci_group_info;
 static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups);
+				      struct vfio_pci_group_info *groups,
+				      struct iommufd_ctx *iommufd_ctx);
 
 /*
  * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
@@ -1254,29 +1256,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	return ret;
 }
 
-static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
-					struct vfio_pci_hot_reset __user *arg)
+static int
+vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
+				    struct vfio_pci_hot_reset *hdr,
+				    struct vfio_pci_hot_reset __user *arg)
 {
-	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
-	struct vfio_pci_hot_reset hdr;
 	int32_t *group_fds;
 	struct file **files;
 	struct vfio_pci_group_info info;
 	bool slot = false;
 	int file_idx, count = 0, ret = 0;
 
-	if (copy_from_user(&hdr, arg, minsz))
-		return -EFAULT;
-
-	if (hdr.argsz < minsz || hdr.flags)
-		return -EINVAL;
-
-	/* Can we do a slot or bus reset or neither? */
-	if (!pci_probe_reset_slot(vdev->pdev->slot))
-		slot = true;
-	else if (pci_probe_reset_bus(vdev->pdev->bus))
-		return -ENODEV;
-
 	/*
 	 * We can't let userspace give us an arbitrarily large buffer to copy,
 	 * so verify how many we think there could be.  Note groups can have
@@ -1288,11 +1278,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		return ret;
 
 	/* Somewhere between 1 and count is OK */
-	if (!hdr.count || hdr.count > count)
+	if (!hdr->count || hdr->count > count)
 		return -EINVAL;
 
-	group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
-	files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
+	group_fds = kcalloc(hdr->count, sizeof(*group_fds), GFP_KERNEL);
+	files = kcalloc(hdr->count, sizeof(*files), GFP_KERNEL);
 	if (!group_fds || !files) {
 		kfree(group_fds);
 		kfree(files);
@@ -1300,7 +1290,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	}
 
 	if (copy_from_user(group_fds, arg->group_fds,
-			   hdr.count * sizeof(*group_fds))) {
+			   hdr->count * sizeof(*group_fds))) {
 		kfree(group_fds);
 		kfree(files);
 		return -EFAULT;
@@ -1311,7 +1301,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	 * interface and store the group and iommu ID.  This ensures the group
 	 * is held across the reset.
 	 */
-	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+	for (file_idx = 0; file_idx < hdr->count; file_idx++) {
 		struct file *file = fget(group_fds[file_idx]);
 
 		if (!file) {
@@ -1335,10 +1325,10 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	if (ret)
 		goto hot_reset_release;
 
-	info.count = hdr.count;
+	info.count = hdr->count;
 	info.files = files;
 
-	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
 
 hot_reset_release:
 	for (file_idx--; file_idx >= 0; file_idx--)
@@ -1348,6 +1338,50 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 	return ret;
 }
 
+static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
+					struct vfio_pci_hot_reset __user *arg)
+{
+	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
+	struct vfio_pci_hot_reset hdr;
+	struct iommufd_ctx *iommufd;
+	bool slot = false;
+	struct fd f;
+	int32_t fd;
+	int ret;
+
+	if (copy_from_user(&hdr, arg, minsz))
+		return -EFAULT;
+
+	if (hdr.argsz < minsz || hdr.flags)
+		return -EINVAL;
+
+	/* Can we do a slot or bus reset or neither? */
+	if (!pci_probe_reset_slot(vdev->pdev->slot))
+		slot = true;
+	else if (pci_probe_reset_bus(vdev->pdev->bus))
+		return -ENODEV;
+
+	if (hdr.count != 1)
+		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, arg);
+
+	if (copy_from_user(&fd, arg->group_fds, sizeof(fd)))
+		return -EFAULT;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+	iommufd = iommufd_ctx_from_file(f.file);
+	if (IS_ERR(iommufd)) {
+		fdput(f);
+		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, arg);
+	}
+	fdput(f);
+
+	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL, iommufd);
+	iommufd_ctx_put(iommufd);
+	return ret;
+}
+
 static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
 				    struct vfio_device_ioeventfd __user *arg)
 {
@@ -2317,6 +2351,9 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 {
 	unsigned int i;
 
+	if (!groups)
+		return false;
+
 	for (i = 0; i < groups->count; i++)
 		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
 			return true;
@@ -2398,7 +2435,8 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
  * get each memory_lock.
  */
 static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
-				      struct vfio_pci_group_info *groups)
+				      struct vfio_pci_group_info *groups,
+				      struct iommufd_ctx *iommufd_ctx)
 {
 	struct vfio_pci_core_device *cur_mem;
 	struct vfio_pci_core_device *cur_vma;
@@ -2432,7 +2470,8 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 		 * Test whether all the affected devices are contained by the
 		 * set of groups provided by the user.
 		 */
-		if (!vfio_dev_in_groups(cur_vma, groups)) {
+		if (!vfio_dev_in_groups(cur_vma, groups) &&
+		    !iommufd_ctx_has_device(iommufd_ctx, &cur_vma->pdev->dev)) {
 			ret = -EINVAL;
 			goto err_undo;
 		}
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 650d45629647a7..1f58673701cb1e 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -58,6 +58,7 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
 int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
 		      void *data, size_t len, unsigned int flags);
 int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
+bool iommufd_ctx_has_device(struct iommufd_ctx *ictx, struct device *dev);
 #else /* !CONFIG_IOMMUFD */
 static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
 {
@@ -94,5 +95,12 @@ static inline int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline bool iommufd_ctx_has_device(struct iommufd_ctx *ictx,
+					  struct device *dev)
+{
+	return false;
+}
+
 #endif /* CONFIG_IOMMUFD */
 #endif

