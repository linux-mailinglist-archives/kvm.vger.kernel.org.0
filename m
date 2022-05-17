Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6F452AB53
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 20:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352417AbiEQS4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 14:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235327AbiEQS4u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 14:56:50 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1212715E;
        Tue, 17 May 2022 11:56:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SD5FNG5Il+qyL3WBH17iChP9etdGNxYP4UGE7CN0jifzGngYsnRGAFrp1vHkWi35AzBzey6btZ6vt2mWrk60GAiJLY1R99SSMGJXBLBXbpeUn7/3izQe70jX0utCzcNij0CqXc+sSnWvmZhs+yr4wI7rgdz7QnPwPapgMLGdI5Wldak4PCTXGrbYkw02ciVHyqEmXdw1x7GcC4k5wm1n2jdGO6v2gXboFLci919AaXnncnkFmZoNNdgWt63AN5L3iHenPQfWk+SA9qknn8BTwhaOVzPVJTCDUTqDCdRlupIDy7qPv1jz0eD/AG3eRgT3lKkqPKKH0hhF7a7Ezh4jPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bc4I1YBxsF7ltTyt2zDHPziypcBrLW5kYPw53HZwet8=;
 b=WplwdvWJx/8iIBxzNJViDC58O929dx3bZkpBIFuAiBB+/mrsSORc5M1+wT5qLDBZ/0+T7jtKu8zVSoAt7tvbWiO58xJ78ZzdFwKEL0WefkdEBrFLp9GQkB7AIDmAyWpnQ+A21LBaIGscLteVNlAMjnekASzDHvOZ/F9Sa2bX7MtraGUK08SqXvHGB2OJeNO0SW2234qKXnIo/JO4RNmeAsamdT6Rza9i3lmDH0iBgEoN4TWXlBFlqBFC+y9dmaPuVXkCyXALVwKnqTk98bIzQ83/0GzOBtjScrKbFLrgkrl+3ayAk3ZhAEEazTzRVkgqpK9mev7xq9WJX/OJv0UiKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bc4I1YBxsF7ltTyt2zDHPziypcBrLW5kYPw53HZwet8=;
 b=OOW606n1luNTDeljkmkK9HYgwvYO/EIHQODPEcWrjT0qFiKld+ccAZqj5AWGca3aDT7PWuVJwwxqF+DY/zEBMsQlzPn2qT/3Oow3pu9wQrHfCdcO+6xnKtlUsk0/+gc8xAtBvV+ISZVhSHTzT+MBc7hu2yp9pmWPnhnzvc/SElRN2BZPAqSy+VT46r12zid8UVFDgxpv6AjnRuTjyxiYCQ8+D9Gnx7k5ugT/nIeZoRIODwvrvcQuByQOdrutz4GP0yzUxH0fZ9FBob0k1Z1s207sLVeYrvZmtGSbL0A+143DFrip1Fn7GaBeasoNOfEPPR7rMfwCK/oz/QcuOp5bvA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by BN6PR12MB1891.namprd12.prod.outlook.com (2603:10b6:404:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 18:56:45 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::182c:a653:21b2:b351]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::182c:a653:21b2:b351%4]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 18:56:45 +0000
Date:   Tue, 17 May 2022 15:56:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20220517185643.GY1343366@nvidia.com>
References: <20220517180851.166538-1-mjrosato@linux.ibm.com>
 <20220517180851.166538-2-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517180851.166538-2-mjrosato@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:208:32a::24) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d89b4610-5887-4f20-5f45-08da3836fd49
X-MS-TrafficTypeDiagnostic: BN6PR12MB1891:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1891FDF8EB4AF49B03B4C16AC2CE9@BN6PR12MB1891.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i7S71Zus40JFM4QDnHBbWBAc6VhMJfF/8yqlHbXwjlzzj//WJdAk0jp4IB6qJ78bJY4G7k/gsQYQQOUCokRF672C7GeaJecDNSPRyhBWKYK6E2WuQoKobi0Rk+Zn5lttUSCcixkErhVz1T8q6f+GACjAw343wwEXyho60Ieo3JEJ+TQJFsum9y19KJ9jfJ8evdyx3JbCUd+FqzH1eW+o/DEGIYNvXlJnHNcm4NCzezUQF2j8Qdnx8/G8drjOIXBiRRm9dbDtJAkBXiFBNigYVq9W6530NXGIx68ZXetteXwwaI7iGBgOS2BpsnbIdj0ggIDJHGQ3uURtEbZzH1K/mfzZZvrYulz0uLaCht4TW6HphQhNLO/gemYiQ7+mWrHTrTwB2ud/Ni68T362YvX1KWgxQDyYWAwdreKe7H6vCSYcCyMuf6lbHYC0UG4vomnuns9o9WESl2oUety6hVYIAZCPiHebWrZUocfLg/s/SLtY+C+KUr5tJU588WmFzrzMn9qn63D9DrrH/kDg0vYXG8tWKlpGw6eYbZLW8tRyIcGBOugtM3KsAfHwDIvFznkr/M/brEsxfn82zqasiAjKLYUl8JaT1qmboMoh/G1qZxlD5SSV+cWcr7tIvyFNXRmt3FuDwWDFDfqNAQLBIcZVsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(7416002)(186003)(5660300002)(8936002)(4326008)(66556008)(66476007)(66946007)(8676002)(38100700002)(6486002)(36756003)(6916009)(2906002)(1076003)(26005)(2616005)(6512007)(508600001)(83380400001)(86362001)(6506007)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dUz4GwIVj/vNEJ8Qq1aE37w042TK4L5Uak0Sqe74m0jU0rX8Qs1NepvnZweU?=
 =?us-ascii?Q?vPb0C++2cMutR1OEHm6jAur6SI/ENgrFvSSdI2rRsEzmZ0tgH36HvVGVlSdQ?=
 =?us-ascii?Q?MrN4rtKW/N0PgLJrJFfUQwebYtSMhB2XTn4XXPOH7iZTT3JbiTIotrgJ4/0O?=
 =?us-ascii?Q?PPxB0YxKFb5wgHIWy1MHbPyXtK0uHLXSPJOyebgU1rH6hjvJhbrx2+pT72uA?=
 =?us-ascii?Q?cuayKHF2PXRB2wD5JD+wWr306rak2Ke4m8JQKttg7q4ZirhTms8aDh+4k3Wd?=
 =?us-ascii?Q?KVOKns0z8wx7ue8BEuesWtekwD9dn/gqCRCDg9WZ/9gY855tk65/bWLZKyrG?=
 =?us-ascii?Q?kNcvxB3mJ0qtlMtadio+6xXwrhnI6Bc3VCQSSA/l8zW6Jn8UnxXdE4I5A8H1?=
 =?us-ascii?Q?3N9ndPqTBw2qF7vDD8PQOAvC6hUmOquyLKFCq+tuW9RB14m0X3wdxRcth3m3?=
 =?us-ascii?Q?LKDfnqahW/rCowV2I95+plAbg2DlEO98t+3c5mfbPCoV4+MZQLeE3G6HlxfL?=
 =?us-ascii?Q?q/SyF/Z2YfCkO1ZVUxDIpVRYT18utJdkvX0pU5g476oRjJoFCcoop+Dw381A?=
 =?us-ascii?Q?znISCt9bSdFjxaSAXDl4R/ptTp8kdGDg4tT1bLIw4E9VVC/38GIvED9r89DF?=
 =?us-ascii?Q?GznyFUUBBkWyJHm+Ddjo+ZsR48uOeWMKaOoC3MoDJPEZQNynr821S1MXTpRo?=
 =?us-ascii?Q?+/TGu52RuD+EfvYchwnySItaXomiTrHRxx/4ei290c2iuv5cVeB4bMtPYiGC?=
 =?us-ascii?Q?Wdphyh1PvIkhzC9zFxSxu1Y+fo8fHeoLWQypSeq1TQHyq1JxdhADv6MxZTQX?=
 =?us-ascii?Q?TIRNZEdwF/rhGpHlnlOL6KXMZO5gk4IEXCqvRohi/BlDjFuITYl+Uj98yzvO?=
 =?us-ascii?Q?d0wEonKvT1yi0Xe63lDfpHaO+N4JnLs89yW/MC3YXTPlN1ZllfxtXkDdciao?=
 =?us-ascii?Q?1Gs2kEkDbJEiFDu7uJAg6TVhz/krZSMSCtYQ4g5BnaWvRXegv/Cnd9AqvtKX?=
 =?us-ascii?Q?W3kM7RpTVHq9ckejPZT8sXSwWA5PwAMNMYM9f+QF3+nmizYp1ycSjA55SamT?=
 =?us-ascii?Q?MkKZ2i3AR/XleMByqJNRYsDYiOiRwoPbcu0D0IaWjTsrrUoORFHzKMaBb2Zd?=
 =?us-ascii?Q?h5XQ9TNrFt8DZlR9NFyQ5hsidNI1JBR0XLHcZAaxyC+p4ra49LsBmyRh8eX4?=
 =?us-ascii?Q?5MIddaobnf+YUQEwcp79Oxs6uVDjaVNiRd0FaADc1KzSjxtE0EI/dpU7kaQD?=
 =?us-ascii?Q?pW7xjtpqT8/CfaZkr9APvaEz8ib4fmphMTxwKhkGMZRXUSheAXS5cjigSUjp?=
 =?us-ascii?Q?neqC/zh+1YpqJcUQuhNXVkMYACvf4ocydUiCUmxUfaYuQyCwANyJDVWDInGd?=
 =?us-ascii?Q?r4azeSdZ7/fDb4JyiJ15UPgSecDc9/f5WC3QJ1NovwWS+StGZCS43UfKomLk?=
 =?us-ascii?Q?pzMIP1+lTnhqJHvl5wmYThOibqijQUxWwVC7JywlAIHoxFb9KDywfoukhSm3?=
 =?us-ascii?Q?jGB6OZK4xHRDlZXeUAFJUMVSJJJFy5PXmS3VgbsDQGmc8O9Pi0ic9IrMY7Ca?=
 =?us-ascii?Q?rpTVOiUzbsGMa03PcgjqRmfdVlPR7FEvaYtRy3eZ95F9cJaYTQ55P7kkOwwU?=
 =?us-ascii?Q?ggPzdvu/ViVZf5aLRIhh5Ui+66y1g+L9Li2ho/EpazDDd5dQAF7YvwAMBmJ9?=
 =?us-ascii?Q?7fRZ3ijGJr7oyNffSjmAY9+GgIzBdqEFmbO7Wx4BFwsAluGABsDgfT0VvU8u?=
 =?us-ascii?Q?wKJjQfvy+w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d89b4610-5887-4f20-5f45-08da3836fd49
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 18:56:45.7234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mK6qFWlzXD8FlRi8FdabANzqP33yl1PHEBT5Lce8kvQOt/kguGwuZUJAseeGUywP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1891
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 17, 2022 at 02:08:51PM -0400, Matthew Rosato wrote:
> Rather than relying on a notifier for associating the KVM with
> the group, let's assume that the association has already been
> made prior to device_open.  The first time a device is opened
> associate the group KVM with the device.

This also fixes a user triggerable oops in gvt
 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>

You can add my signed-off-by as well

> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index cfcff7764403..c5d421eda275 100644
> +++ b/drivers/vfio/vfio.c
> @@ -10,6 +10,7 @@
>   * Author: Tom Lyon, pugs@cisco.com
>   */
>  
> +#include "linux/kvm_host.h"

This is the wrong format of include (editor automation, sigh)

> @@ -1083,6 +1084,13 @@ static struct file *vfio_device_open(struct vfio_device *device)
>  
>  	mutex_lock(&device->dev_set->lock);
>  	device->open_count++;
> +	down_write(&device->group->group_rwsem);

Read I suppose

> +	if (device->open_count == 1 && device->group->kvm) {
> +		device->kvm = device->group->kvm;
> +		kvm_get_kvm(device->kvm);
> +	}
> +	up_write(&device->group->group_rwsem);

Yeah, this is OK, not very elegant though

I was looking at this - but it could come later too:

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 8e11d9119418be..c5d8dfe8314108 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -10,7 +10,6 @@
  * Author: Tom Lyon, pugs@cisco.com
  */
 
-#include "linux/kvm_host.h"
 #include <linux/cdev.h>
 #include <linux/compat.h>
 #include <linux/device.h>
@@ -33,6 +32,7 @@
 #include <linux/vfio.h>
 #include <linux/wait.h>
 #include <linux/sched/signal.h>
+#include <linux/kvm_host.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -1059,93 +1059,71 @@ static int vfio_device_assign_container(struct vfio_device *device)
 
 static void vfio_device_unassign_container(struct vfio_device *device)
 {
-	down_write(&device->group->group_rwsem);
+	lockdep_assert_held(&device->group->group_rwsem);
+
 	WARN_ON(device->group->container_users <= 1);
 	device->group->container_users--;
 	fput(device->group->opened_file);
-	up_write(&device->group->group_rwsem);
 }
 
-static struct file *vfio_device_open(struct vfio_device *device)
+static int vfio_device_open(struct vfio_device *device)
 {
-	struct file *filep;
 	int ret;
 
+	lockdep_assert_held(&device->dev_set->lock);
+
+	if (!try_module_get(device->dev->driver->owner))
+		return -ENODEV;
+
 	down_write(&device->group->group_rwsem);
 	ret = vfio_device_assign_container(device);
-	if (ret) {
-		up_write(&device->group->group_rwsem);
-		return ERR_PTR(ret);
-	}
+	if (ret)
+		goto err_unlock;
 
 	if (device->ops->flags & VFIO_DEVICE_NEEDS_KVM)
 	{
-		if (!device->group->kvm) {
-			up_write(&device->group->group_rwsem);
+		if (!device->group->kvm)
 			goto err_unassign_container;
-		}
 		device->kvm = device->group->kvm;
 		kvm_get_kvm(device->kvm);
 	}
 	up_write(&device->group->group_rwsem);
 
-	if (!try_module_get(device->dev->driver->owner)) {
-		ret = -ENODEV;
-		goto err_put_kvm;
-	}
-
-	mutex_lock(&device->dev_set->lock);
-	device->open_count++;
-	if (device->open_count == 1 && device->ops->open_device) {
+	if (device->ops->open_device) {
 		ret = device->ops->open_device(device);
 		if (ret)
-			goto err_undo_count;
+			goto err_put_kvm;
 	}
-	mutex_unlock(&device->dev_set->lock);
+	return 0;
 
-	/*
-	 * We can't use anon_inode_getfd() because we need to modify
-	 * the f_mode flags directly to allow more than just ioctls
-	 */
-	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops,
-				   device, O_RDWR);
-	if (IS_ERR(filep)) {
-		ret = PTR_ERR(filep);
-		goto err_close_device;
+err_put_kvm:
+	if (device->kvm) {
+		kvm_put_kvm(device->kvm);
+		device->kvm = NULL;
 	}
+	down_write(&device->group->group_rwsem);
+err_unassign_container:
+	vfio_device_unassign_container(device);
+err_unlock:
+	up_write(&device->group->group_rwsem);
+	module_put(device->dev->driver->owner);
+	return ret;
+}
 
-	/*
-	 * TODO: add an anon_inode interface to do this.
-	 * Appears to be missing by lack of need rather than
-	 * explicitly prevented.  Now there's need.
-	 */
-	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
-
-	if (device->group->type == VFIO_NO_IOMMU)
-		dev_warn(device->dev, "vfio-noiommu device opened by user "
-			 "(%s:%d)\n", current->comm, task_pid_nr(current));
-	/*
-	 * On success the ref of device is moved to the file and
-	 * put in vfio_device_fops_release()
-	 */
-	return filep;
+static void vfio_device_close(struct vfio_device *device)
+{
+	lockdep_assert_held(&device->dev_set->lock);
 
-err_close_device:
-	mutex_lock(&device->dev_set->lock);
-	if (device->open_count == 1 && device->ops->close_device)
+	if (device->ops->close_device)
 		device->ops->close_device(device);
-err_undo_count:
-	device->open_count--;
-	mutex_unlock(&device->dev_set->lock);
-	module_put(device->dev->driver->owner);
-err_put_kvm:
 	if (device->kvm) {
 		kvm_put_kvm(device->kvm);
 		device->kvm = NULL;
 	}
-err_unassign_container:
+	down_write(&device->group->group_rwsem);
 	vfio_device_unassign_container(device);
-	return ERR_PTR(ret);
+	up_write(&device->group->group_rwsem);
+	module_put(device->dev->driver->owner);
 }
 
 static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
@@ -1159,23 +1137,61 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
-	fdno = get_unused_fd_flags(O_CLOEXEC);
-	if (fdno < 0) {
-		ret = fdno;
-		goto err_put_device;
+	mutex_lock(&device->dev_set->lock);
+	device->open_count++;
+	if (device->open_count == 1) {
+		ret = vfio_device_open(device);
+		if (ret) {
+			device->open_count--;
+			mutex_unlock(&device->dev_set->lock);
+			goto err_put_device;
+		}
 	}
+	mutex_unlock(&device->dev_set->lock);
 
-	filep = vfio_device_open(device);
+	/*
+	 * We can't use anon_inode_getfd() because we need to modify
+	 * the f_mode flags directly to allow more than just ioctls
+	 */
+	filep = anon_inode_getfile("[vfio-device]", &vfio_device_fops, device,
+				   O_RDWR);
 	if (IS_ERR(filep)) {
 		ret = PTR_ERR(filep);
-		goto err_put_fdno;
+		goto err_close_device;
+	}
+
+	/*
+	 * TODO: add an anon_inode interface to do this.
+	 * Appears to be missing by lack of need rather than
+	 * explicitly prevented.  Now there's need.
+	 */
+	filep->f_mode |= (FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE);
+
+	fdno = get_unused_fd_flags(O_CLOEXEC);
+	if (fdno < 0) {
+		ret = fdno;
+		goto err_put_file;
 	}
 
+	if (device->group->type == VFIO_NO_IOMMU)
+		dev_warn(device->dev, "vfio-noiommu device opened by user "
+			 "(%s:%d)\n", current->comm, task_pid_nr(current));
+
+	/*
+	 * On success the ref of device is moved to the file and put in
+	 * vfio_device_fops_release().
+	 */
 	fd_install(fdno, filep);
 	return fdno;
 
-err_put_fdno:
-	put_unused_fd(fdno);
+err_put_file:
+	fput(filep);
+err_close_device:
+	mutex_lock(&device->dev_set->lock);
+	if (device->open_count == 1)
+		vfio_device_close(device);
+	device->open_count--;
+	mutex_unlock(&device->dev_set->lock);
 err_put_device:
 	vfio_device_put(device);
 	return ret;
@@ -1333,19 +1349,11 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 
 	mutex_lock(&device->dev_set->lock);
 	vfio_assert_device_open(device);
-	if (device->open_count == 1 && device->ops->close_device)
-		device->ops->close_device(device);
+	if (device->open_count == 1)
+		vfio_device_close(device);
 	device->open_count--;
 	mutex_unlock(&device->dev_set->lock);
 
-	module_put(device->dev->driver->owner);
-
-	if (device->kvm) {
-		kvm_put_kvm(device->kvm);
-		device->kvm = NULL;
-	}
-	vfio_device_unassign_container(device);
-
 	vfio_device_put(device);
 
 	return 0;
