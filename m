Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B396D5F4792
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 18:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiJDQ2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 12:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiJDQ2b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 12:28:31 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0C350069;
        Tue,  4 Oct 2022 09:28:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhgmNLhClhBDrNuSdKuOqk1ASwNgZVehhkUDlZgyvlKFybkgoUQpnQM4hrgvRVyWBMR6MWbPOXssx2+tq+mIik3u2qdMgcfSL6qNJrx+/c5m23F+fxJAtSsHlQCf6kbdBjhX4+lc0F+XjPqICS28mFaHFixjl0uO8PwhZY3e89PIYUvrUDNFZK8T/gfU7Q+iYyMNZLhwnxdidMi0jyuGEXxwHg8bIVN1KhF7Gvp4qPz9zpkfrK7tBGMeuHzE34J/UJ+baXnOeb0gfEEEhsvdWR6zcwzRgGqY85atcMCnaMqrOy9QZsdbngAgUjcKnD1ckKW1+ggv1J0Ec1xTnsJtSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKAzV7dOu1Ilx0W2oyBx1fKsptueqvyQ4FPdq8sWVKA=;
 b=HLopheH/+oNyczu941Y2KqLonpa9suSq89PhC0rh08jT/q3yRsV6ZxWNsBrFZbcU/y27Ks1sGwwkKlh7n54ohdkwbWSJPVVJkZaTwl7lYxPRN0rSTWVWEO8B3XYaJXawOPkL3CLryGiqaYVavRmJqgh/2RswdrFHMPiIAhPvdVFNisGVfjW42spKP/1k5hY0UyYD1XHcUFsSDdkXKp0UC6zRZHXdl8gXn+VKXIQj4jdht+C7u4UAbkJUn448LB/IdZnXWtIS5w1zNdcWA0kHWlD8MN/SJURmxAS2RObOz3kPfnvy1kei44fyruqZQyq1ChL4c1fEhrY8oKE0oPK/2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DKAzV7dOu1Ilx0W2oyBx1fKsptueqvyQ4FPdq8sWVKA=;
 b=NcOqdZvroCEONM2gdN2miiFauXm9RWe0jyei5p5c8ADhmLQnaOq8hwK3J0lWXXgbMWT5p4nEF4dlC+fRv1+FX4ncCLAz0ltxeCooL0y6QjYtG/YPZ6tBVl9UDxj6uXLiPn6Dp5i5XzlPQeRZyalcit8WGZQr2+yyudiMI2sVZR2wOb7JmDMugB20qY/AGacGpTfgOss3iSpsUqQ+5q+LtdaqHREHXaoxCYxokw0NgEBLBYicz0BWsilI5Cfh42fcRmntlQEXJV4nOIFpvFVO7kdrLHzRAOa6NPLyoqo6VtS92wj29iuZC/iVXAoyQqhYlEgbO3BsPSXhTo5kzQVPLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5200.namprd12.prod.outlook.com (2603:10b6:5:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 16:28:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 16:28:28 +0000
Date:   Tue, 4 Oct 2022 13:28:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Message-ID: <YzxfK/e14Bx9yNyo@nvidia.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
X-ClientProxiedBy: MN2PR15CA0003.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DM4PR12MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a19a672-9f0b-489e-0852-08daa62577fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKile+vmGPk34fpXhxpaI5vCI3fMwCita7UPZa9TranoJlTeumVZ0FuZFemVJTy8W89/yWY/eFi+ByTV9LheFi3l/7+V4QEfuuvJrp81qmSH5BHDtC2z+0LhzeYOCj3WRziljqU+CBc+bio1cSBueGMM9w74BQv6uq5RtozttJ+vfSZRlWWIqjT8uCbX1AyLUCNNIAL9FJM+a5/V8M4c/9ggdxJOUh/zfTMvafO88xUtDoVk7GhJyPBlN5UM9o2TeSn3JwJvOcDYjp/ePadXsIsLHaUyOlfm/TXSGYQ5b6sVFdGonm4lXhrFWuYxpotwD4Rvbc+of4uJKX897Y+N6jTTnIE4zi/ERI0zbgFaRsllLTuKO4kHW0Zy2M4gn0EGn1D0C5Xw2SeGCptYXU4OH5m/xNXh+YL3FkjdNOFdZ1ZVLA1kmXUdnWo3766o2sV6VGsVyt06Y1k4TYb8kr2FQCMLKWs6nSe+Q6s4k2/FmYY11IRCTSP/rANYvzUvywpB4iRbOjrO0ClvSQSkNgrnDbhgc7Aq3h9eiVmR1GfRoPjnmCOB0SQMeBO/fA+GKexHzcS1myZA5nVJr5x8NUwrDJmQTcKMnTN44LfikAd4EXTb5JS99ztNrPdu1yVkcPQeqD+B8d1MuV0pyZiEOtFAwCvlPXdcUOigCCCERiCTcvUDVnCwkmYU2fBjii3OFy0KAJmNOh+7cIltpmwJXWayVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(136003)(376002)(39860400002)(451199015)(186003)(83380400001)(66946007)(66476007)(66556008)(478600001)(6486002)(4326008)(6916009)(316002)(54906003)(36756003)(8676002)(2616005)(8936002)(41300700001)(6512007)(5660300002)(6506007)(26005)(86362001)(2906002)(7416002)(30864003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?la8lkKvl1DR9FwVOTgzR6Ob3L3EIOOHwBDuVPQlONkIpdhEfSq9XnTUu6P6m?=
 =?us-ascii?Q?BW+xpJBCWQGVXidNXm/Lg5umPXQCUrPsbR25BZCWNB9XsW/o2O/WXOL6wFch?=
 =?us-ascii?Q?Za9Bbz89vQ0YR0Stu6ZLFWu2F7Z9DN3O1QuYLKwdUEI0lmlmvTUjHViXfP2/?=
 =?us-ascii?Q?ErtfpHavJWRFS5ikugicu4k4evLHitVP6jU4P+Ea5l8UAZ3F6aik5tjBrmbw?=
 =?us-ascii?Q?rrPmRj53U0/YEAmBv+aRKDQUegsFHSpSwNwWIlvVRLDKSmsNvgeoJYDqgHAf?=
 =?us-ascii?Q?yoOfw8iNrD7gBNoAZTp1RAot6unjrD/PjdNJfx656NvwGm+rdS7GtVqLwMvg?=
 =?us-ascii?Q?egHIa/7W3jmhmonLL5ykoPwqDzJDKT9XYXE7wOQtDhf7wIY9SZa+higJXEIw?=
 =?us-ascii?Q?gDRb9krBqISqaLk/4qbyv1Hm3dFxhVTZs++VLKhz6kbGGQKzb1vr2wXn+Y/y?=
 =?us-ascii?Q?ZBbufsgGuKv+feoCFM4NzmTThAAWnD8lrZmC4EyPGWaNMxt1fQea32DEBSO4?=
 =?us-ascii?Q?kdms/T/++yO8iohyXGH+lWAPn2mPuDq0F3wNOFRlQIM4H6vd4x99NcSk+4Q7?=
 =?us-ascii?Q?5QbH6UgGkbmBeyHuqKtV+Dom7be50U3Hjh394BFnS4P/pOkKJwYqqIRn+kQX?=
 =?us-ascii?Q?nF2xR70KZaE6oChrY8X8M0ssO2av9SGqKRKRFJ7ekBD3R5p3/4Ott1yQuFvj?=
 =?us-ascii?Q?Xim0DNB4GWhKbo/TuzilVq68xj0ZoMKjo6tSpo5rzP2/Wrx2uAB1NMxWslAd?=
 =?us-ascii?Q?Z5kG2z83oQ7LAIj8Kg3zaCBxIrh7x11Oxb9D9Ipu7OCdLi9t13b/0OpRFeVt?=
 =?us-ascii?Q?+sy0QzTjDT4mU/gd5Ks8mDLqRP4kQfY6ImbG7SgKxJoluHGvXRj5SdtFdIeG?=
 =?us-ascii?Q?YmTMiGKdO4TnPfRVtY64Vp7gbPCyCd55xU+eNKd6d/VlkdcM+wf1TvOi21On?=
 =?us-ascii?Q?iA49GySpRW2DnQifiAIBtHsh/N0wpHlsSQTlR2Behsz1QdJ/s31czhmlOzYf?=
 =?us-ascii?Q?p/+l3U2SjUoqp2SdFq1L3RHJzfMpoPbapXLdJSSLGcwm8cuvQTFck/+p8emy?=
 =?us-ascii?Q?9wimyLwtpklb534AxNFA2Z58UlWmsCbxWoWQREt3FQqFuFqMpWWW5Vm6CXs9?=
 =?us-ascii?Q?XTQSGiastUCtCuK7kEwMvI+i7U8kPmzl8QN5A0AeBL7Dzn3bxH31RsDSPYX/?=
 =?us-ascii?Q?lbrPv/8ZX+bn6zik+CAZDrku9wVUaFku3ZHMbZmuRqsHW6jyXcIl5CHKWao1?=
 =?us-ascii?Q?3i6ZFmcr8zP+ZK43DzICKqPUup1VkqZLs8mT32jIr91dRZKOuyXGRyp4nFKg?=
 =?us-ascii?Q?diTOT/sZFNq2tS4M07zTKVN46VqtZ9WCpv2LhAXajKyGdrWOgwSDI4wuXzeE?=
 =?us-ascii?Q?9vmU3KU6Fg5flGpkp+Tbxmcv4tLabXK8FzNlLFiCh5Ex0+vY+sCrGMVInUCE?=
 =?us-ascii?Q?z5lvLDrSJ+Xa1ODhyfgGdInaWzutkk79dX46oMHbw+F2ShgKMbDs15k2Vdc6?=
 =?us-ascii?Q?sBX8k/75RUa9lmfxGiXwt3evOlI9rwlNgJn/nlwijLkZe/M62sb4LZktkM4n?=
 =?us-ascii?Q?33SlLQKlfbuNHgTXG6g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a19a672-9f0b-489e-0852-08daa62577fc
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 16:28:28.5071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zXwF/bTp/2QyHHUDyKbjItF0qKuZvXLHRh2np9QLEjiQ+oxRfiCKpbMJo7hTfF7M
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5200
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022 at 05:44:53PM +0200, Christian Borntraeger wrote:

> > Does some userspace have the group FD open when it stucks like this,
> > eg what does fuser say?
> 
> /proc/<virtnodedevd>/fd
> 51480 0 dr-x------. 2 root root  0  4. Okt 17:16 .
> 43593 0 dr-xr-xr-x. 9 root root  0  4. Okt 17:16 ..
> 65252 0 lr-x------. 1 root root 64  4. Okt 17:42 0 -> /dev/null
> 65253 0 lrwx------. 1 root root 64  4. Okt 17:42 1 -> 'socket:[51479]'
> 65261 0 lrwx------. 1 root root 64  4. Okt 17:42 10 -> 'anon_inode:[eventfd]'
> 65262 0 lrwx------. 1 root root 64  4. Okt 17:42 11 -> 'socket:[51485]'
> 65263 0 lrwx------. 1 root root 64  4. Okt 17:42 12 -> 'socket:[51487]'
> 65264 0 lrwx------. 1 root root 64  4. Okt 17:42 13 -> 'socket:[51486]'
> 65265 0 lrwx------. 1 root root 64  4. Okt 17:42 14 -> 'anon_inode:[eventfd]'
> 65266 0 lrwx------. 1 root root 64  4. Okt 17:42 15 -> 'socket:[60421]'
> 65267 0 lrwx------. 1 root root 64  4. Okt 17:42 16 -> 'anon_inode:[eventfd]'
> 65268 0 lrwx------. 1 root root 64  4. Okt 17:42 17 -> 'socket:[28008]'
> 65269 0 l-wx------. 1 root root 64  4. Okt 17:42 18 -> /run/libvirt/nodedev/driver.pid
> 65270 0 lrwx------. 1 root root 64  4. Okt 17:42 19 -> 'socket:[28818]'
> 65254 0 lrwx------. 1 root root 64  4. Okt 17:42 2 -> 'socket:[51479]'
> 65271 0 lr-x------. 1 root root 64  4. Okt 17:42 20 -> '/dev/vfio/3 (deleted)'

Seems like a userspace bug to keep the group FD open after the /dev/
file has been deleted :|

What do you think about this?

commit a54a852b1484b1605917a8f4d80691db333b25ed
Author: Jason Gunthorpe <jgg@ziepe.ca>
Date:   Tue Oct 4 13:14:37 2022 -0300

    vfio: Make the group FD disassociate from the iommu_group
    
    Allow the vfio_group struct to exist with a NULL iommu_group pointer. When
    the pointer is NULL the vfio_group users promise not to touch the
    iommu_group. This allows a driver to be hot unplugged while userspace is
    keeping the group FD open.
    
    SPAPR mode is excluded from this behavior because of how it wrongly hacks
    part of its iommu interface through KVM. Due to this we loose control over
    what it is doing and cannot revoke the iommu_group usage in the IOMMU
    layer via vfio_group_detach_container().
    
    Thus, for SPAPR the group FDs must still be closed before a device can be
    hot unplugged.
    
    This fixes a userspace regression where we learned that virtnodedevd
    leaves a group FD open even though the /dev/ node for it has been deleted
    and all the drivers for it unplugged.
    
    Fixes: ca5f21b25749 ("vfio: Follow a strict lifetime for struct iommu_group")
    Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
    Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 59a28251bb0b97..badc9d828cac20 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1313,7 +1313,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
 		}
 
 		/* Ensure the FD is a vfio group FD.*/
-		if (!vfio_file_iommu_group(file)) {
+		if (!vfio_file_is_group(file)) {
 			fput(file);
 			ret = -EINVAL;
 			break;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 4d2de02f2ced6e..4e10a281420e66 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -59,6 +59,7 @@ struct vfio_group {
 	struct mutex			group_lock;
 	struct kvm			*kvm;
 	struct file			*opened_file;
+	bool				preserve_iommu_group;
 	struct swait_queue_head		opened_file_wait;
 	struct blocking_notifier_head	notifier;
 };
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 9b1e5fd5f7b73c..e725cf38886c09 100644
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
@@ -248,6 +252,7 @@ static struct vfio_group *vfio_create_group(struct iommu_group *iommu_group,
 static void vfio_device_remove_group(struct vfio_device *device)
 {
 	struct vfio_group *group = device->group;
+	struct iommu_group *iommu_group;
 
 	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
 		iommu_group_remove_device(device->dev);
@@ -266,12 +271,25 @@ static void vfio_device_remove_group(struct vfio_device *device)
 	cdev_device_del(&group->cdev, &group->dev);
 
 	/*
-	 * Before we allow the last driver in the group to be unplugged the
-	 * group must be sanitized so nothing else is or can reference it. This
-	 * is because the group->iommu_group pointer should only be used so long
-	 * as a device driver is attached to a device in the group.
+	 * Revoke all users of group->iommu_group. At this point we know there
+	 * are no devices active because we are unplugging the last one. Setting
+	 * iommu_group to NULL blocks all new users.
 	 */
-	while (group->opened_file) {
+	WARN_ON(group->notifier.head);
+	if (group->container)
+		vfio_group_detach_container(group);
+	iommu_group = group->iommu_group;
+	group->iommu_group = NULL;
+
+	/*
+	 * Normally we can set the iommu_group to NULL above and that will
+	 * prevent any users from touching it. However, the SPAPR kvm path takes
+	 * a reference to the iommu_group and keeps using it in arch code out
+	 * side our control. So if this path is triggred we have no choice but
+	 * to wait for the group FD to be closed to be sure everyone has stopped
+	 * touching the group.
+	 */
+	while (group->preserve_iommu_group && group->opened_file) {
 		mutex_unlock(&vfio.group_lock);
 		swait_event_idle_exclusive(group->opened_file_wait,
 					   !group->opened_file);
@@ -288,8 +306,8 @@ static void vfio_device_remove_group(struct vfio_device *device)
 	WARN_ON(!list_empty(&group->device_list));
 	WARN_ON(group->container || group->container_users);
 	WARN_ON(group->notifier.head);
-	group->iommu_group = NULL;
 
+	iommu_group_put(iommu_group);
 	put_device(&group->dev);
 }
 
@@ -531,6 +549,10 @@ static int __vfio_register_dev(struct vfio_device *device,
 
 	existing_device = vfio_group_get_device(group, device->dev);
 	if (existing_device) {
+		/*
+		 * group->iommu_group is non-NULL because we hold the drivers
+		 * refcount.
+		 */
 		dev_WARN(device->dev, "Device already exists on group %d\n",
 			 iommu_group_id(group->iommu_group));
 		vfio_device_put_registration(existing_device);
@@ -702,6 +724,11 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
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
@@ -862,6 +889,11 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
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
@@ -938,13 +970,6 @@ static int vfio_group_fops_release(struct inode *inode, struct file *filep)
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
 	swake_up_one(&group->opened_file_wait);
@@ -1553,17 +1578,34 @@ static const struct file_operations vfio_device_fops = {
  * @file: VFIO group file
  *
  * The returned iommu_group is valid as long as a ref is held on the file.
+ * This function is deprecated, only the SPAPR path in kvm should call it.
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file)
 {
 	struct vfio_group *group = file->private_data;
+	struct iommu_group *iommu_group = NULL;
+
+	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
+		return NULL;
 
 	if (file->f_op != &vfio_group_fops)
 		return NULL;
-	return group->iommu_group;
+
+	mutex_lock(&group->group_lock);
+	if (group->iommu_group) {
+		iommu_group = group->iommu_group;
+		group->preserve_iommu_group = true;
+	}
+	mutex_unlock(&group->group_lock);
+	return iommu_group;
 }
 EXPORT_SYMBOL_GPL(vfio_file_iommu_group);
 
+bool vfio_file_is_group(struct file *file)
+{
+	return (file->f_op == &vfio_group_fops;
+}
+
 /**
  * vfio_file_enforced_coherent - True if the DMA associated with the VFIO file
  *        is always CPU cache coherent
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 73bcb92179a224..bd9faaab85de18 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -199,6 +199,7 @@ int vfio_mig_get_next_state(struct vfio_device *device,
  * External user API
  */
 struct iommu_group *vfio_file_iommu_group(struct file *file);
+bool vfio_file_is_group(struct file *file);
 bool vfio_file_enforced_coherent(struct file *file);
 void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ce1b01d02c5197..6ecd3aca047375 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -77,6 +77,23 @@ static struct iommu_group *kvm_vfio_file_iommu_group(struct file *file)
 	return ret;
 }
 
+static bool kvm_vfio_file_is_group(struct file *file)
+{
+	bool (*fn)(struct file *file);
+	bool ret;
+
+	fn = symbol_get(vfio_file_is_group);
+	if (!fn)
+		return false;
+
+	ret = fn(file);
+
+	symbol_put(vfio_file_is_group);
+
+	return ret;
+}
+
+
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
 					     struct kvm_vfio_group *kvg)
@@ -136,7 +153,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 		return -EBADF;
 
 	/* Ensure the FD is a vfio group FD.*/
-	if (!kvm_vfio_file_iommu_group(filp)) {
+	if (!kvm_vfio_file_is_group(filp)) {
 		ret = -EINVAL;
 		goto err_fput;
 	}
