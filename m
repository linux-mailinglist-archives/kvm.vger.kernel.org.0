Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A42D509066
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381781AbiDTT0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 15:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381767AbiDTT0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 15:26:10 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2070.outbound.protection.outlook.com [40.107.102.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6A1427FE
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 12:23:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcM1cye7VtTS/PiA1L4ZZ8g4SWsJWNRircIDvNwxZBchnwwdvYgT73eg2scBklPlYInTFJdTf6JgDfk45159+D3BbHD8YioOnIViZJxU+B3U0K5t4qGQ0DSV8f3bpOICE1gegB1sTV51r0TDy5jMAvMXnjtRdxGwswjg9T4NQiBXOrO+Cl6I4lumGZoIYzQwsVhkA2rhQ/wecEdu6cSodETsKdlZ1hCkrjmJOFW58VF2VRegpMFYn7FJmjmMpFI9CwQBRIuW1Z/j0Xg/rfXQpxbAyF0kYqecMqbmwM2mLV8Ha1uHdiHr662n2X1Or3EfuQkN97hoLj1U4T/WDh6Vfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugI/oGBMEue8Bi3Gq2aim10r2xqeY2bEycUnr59bEis=;
 b=B6ppXePPlRaSAGGV3bdBbgYcEfdufhJJBjUaRKRNWt9LHDyGuH4Vbi+qxR+GBH8a0CwLtnvf2iZ6DXIiaT+YQ2EmcBIbldjItxR8w6HqiXjN1ja2wy1xBs+0Izck3mowpO6lohULREtSlTQq1LgVMhQEOr89c8uQCl6iOTS2CxuIbBcYz8qKtiOqve6dBkQSS77lp8BJF35sievY79L43jqk4Z78XXhmD9fcKXgFl0xJscZ+FOGKIrzvsoBntLYv0aM4prmD5tHSDo13rOrrYz5aSA3aePUfIFgo9h6KdkEIbql/Vnworg1S3R4EqQyZDKHD23LrfXWRpR3bvJV7dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugI/oGBMEue8Bi3Gq2aim10r2xqeY2bEycUnr59bEis=;
 b=pjj6sPg7KkCeIsF9uqzI1XCGRKNBtjnYnoT/JPW05cG3fgYURXkaIDOMnfopV2B8ZEyMqAvtKhPtXoVkHHQ/vfdhyNK2xzg7Mlmz1e/ZXgxtGcySbKiUgyJwpQMOzlHG0MYX9lU66oliiMlswzEPcTChJhusrm+bRhdQnH5FM8vYenxgMUEZp9MT95d3nRunzNN1XnWaf6t4HcqCRLBiMwxbB7MURXebi7PKYZOb3qeRrJk+AE5w9vNM2bWYcSf46iBcpdgD5jGiRZ06Od7hCkxXVpuFoe/RPuSbMVbTLbhhXlI/GQD244nqwyI9Nv/RnS0MSK7KdUdHJpxLi/dbfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB4679.namprd12.prod.outlook.com (2603:10b6:4:a2::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 20 Apr
 2022 19:23:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 19:23:19 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v2 6/8] vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()
Date:   Wed, 20 Apr 2022 16:23:15 -0300
Message-Id: <6-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v2-6a528653a750+1578a-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0128.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a5350d1-4393-4ddf-0a1c-08da230339b1
X-MS-TrafficTypeDiagnostic: DM5PR12MB4679:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB467910355981C5994D6179F6C2F59@DM5PR12MB4679.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yIvYgaUN58bcA8b/HIMYSNIOcVEr2/YVdp6SZfGkq06+3oJrigr9FW768oAADkzzOVT/ZhXfeZmVl6c2A6XAs7L2lSojjEmirHPvbuOVCTyM3lq/OWRbQ1XFMc8alQgMvsPT1ZwClE0XiI8jvNg6zg3eLXJvOT+O3uFgHGltg8sB8xVoGdL6srT61cWcsAByNnWjg4l83h4inG0t2ryvyvvwZULVkSFkiiEcbjuOkMsmBPDVcRZb+jvKrInsofmSk6OhO7Qv9UwbLYU4ySTArraG+W5Ddv7C5k/6qj5TyJ7YjsJXefp1N/vwjrZu684IEoZsRZXyRbJ5R9gONC/l11LmD2qF7Tph5b1IPMEb3u8fBKOjmSgzFl8YiUZifcdkBHbc9JkY//S3fAM5p+P3QDhB9kU4sZl5C6CILUWQZWgV5ptO8Dd/I5oDU8NeyoK0eGZJCqQx6dfK4baYzn23jopi6D4wFcqXk3HwILCH4+6fHcHj4sZ5TzCDYTLlmPqB4Hn89sYVlhXUNnvR/CL1Oh7Yp/Ag0VUd2fUX9iI1CzwPxifNhin1/NH9eb5cupuePTRkGnPDqGHRw96PKYE9iWVJUq6ry995GKGSqHTzJJ28xzI2yyQhrChRFsFUqgct+BfKXfINxH/EaXf38pvWIyvheJdKtIdZFyHQAFTzfboivF2evTWgk85VxztyAXsA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(86362001)(5660300002)(83380400001)(6486002)(36756003)(4326008)(2616005)(186003)(8676002)(8936002)(2906002)(66556008)(6506007)(66476007)(6512007)(6666004)(26005)(38100700002)(110136005)(54906003)(66946007)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XRLUlqL1hjwSoxngPtXZdiIk5OB7e0yJwq0qRpmY17S3Ykko3rwnpWBTP2PT?=
 =?us-ascii?Q?s3Ywryfv81MxzGp19UW1OojYbYgZiu8YNQQ0ui23gYZTo+iqCWb3G83yHAKi?=
 =?us-ascii?Q?lwc1pIl3oCl1hFu4U7f645bh3CBnFqO7iEzmtxBZL1cPcdAdUJSS217pr0/g?=
 =?us-ascii?Q?pWBsU/EgFEnSXMDCoYdUN7c7EVFmcRPJHnDxwr+RTc8yzCPY7jnNa4X9i4Et?=
 =?us-ascii?Q?jLof3TNDZN5nkpE7QIMPRA6JDeIwuIZrp7NPj2cF+QrrV22NsHFzAtHyxF4B?=
 =?us-ascii?Q?mcYKn47Y/A1OOTsW7xYBan4r70KVJDOMNxrK24PvnZp1bzjHyCcL37lZE1WO?=
 =?us-ascii?Q?la3zyB5kkOchF+snkgmumK8+KTNQ/6IBxvvYAZ+KyvvvlcDwD2ySyEwlx7xL?=
 =?us-ascii?Q?QLshigzNbuwAC92VEhiL+0C8dAINa5BasR7QZZi8r4n+tTXJ+SUPmIRWy0uI?=
 =?us-ascii?Q?NLPNu9t1LaaOiMbEbfASPcQD2k3ZC2mL4p8FaJqXmITjxo5yma+IjZuBpuIw?=
 =?us-ascii?Q?jhtJlsDrlhw07gNxcOwNRu1kvEmFrk0NcwUc9swI/hZXI+wfPq4YeCBzqC2Q?=
 =?us-ascii?Q?jySYWjc3mdsCwEHbQZTMy7jIRKcvHE7izsHj4bv3ox9vMHzt9MfWpMdAL9+w?=
 =?us-ascii?Q?ib4GZAqNc9CqRisQrN5EYjTq5f8ixozPtXj3Kq0CjoKND+Gg/AycktGqLK8C?=
 =?us-ascii?Q?aBwxdKyhLv4vNipDxQwEyu793ZyglopaK0Nk+AgQ9JSe56NTVE1OqV37bV3X?=
 =?us-ascii?Q?EEz3eUb+wCgOTfEa9g/foeXB8fdYKF5u+5IaGci98RE5JMo2OuUcL4vQjTnI?=
 =?us-ascii?Q?sMt1lxTNIiPHRLZsPuZ8HACPnkUvNfw+as1FbBhz06b50/G8/mSEN1CrQKSQ?=
 =?us-ascii?Q?VYF9Il8cOeX3WLqgaLffWj9Nf4rC+fGf6PDvKRpoBTsok//ajdNqiNbKsxBm?=
 =?us-ascii?Q?9j+Ut2/ynKaVD5YKWoYwEuNeGlEUEQLT7wlO4CDNp0p2k8deff4QZ6G36nXR?=
 =?us-ascii?Q?o0u/PqjNj9CdXCtFVZSMtUH4olCM+w2RJP1qtgE4u+Rfb67bOIfwiQgm2+Wi?=
 =?us-ascii?Q?2EFOoBMj58fEo1icshxdS2v0RvCeAliUobEdwLTH/P/SxWrNWPCZXq/p0HLv?=
 =?us-ascii?Q?M5SYf+GDwSYGkosJfJNy9wDyTS6BKDVtwdVtrOtGMw9X8CrpXrXLuc6fxdkt?=
 =?us-ascii?Q?LQt5oldQVncPRj1BsixUhvcqDO7y3z1VRBBcHsfsX0PpSgjJjrVs8iADH4MH?=
 =?us-ascii?Q?L754d21aXenLOAYHJElaC5V67sgQ6MTjNJq3KHvfF1MdOCQxwPkzy48VKP2j?=
 =?us-ascii?Q?HwEZHBfQOto9SedkoVUCH//eCPgYbIIUtsGQGSKN+QKHpoN3xMF9SCCuPGZY?=
 =?us-ascii?Q?C2fcImISyX9Rg1AaOwhKoE15A36lAbvaxQD2xKIItFYiOSc9GCBENMqvsEWp?=
 =?us-ascii?Q?YzNY6TqetLY4IxpXhVrk/1dfjqeJf6F94im9dCTNqWc7EjOnqbRGmYT24eOS?=
 =?us-ascii?Q?8LDHHncC0CCdC27B3eFVbUxxv8LjwqpdvnYsplo6zfT289SKEz08l6kQPErQ?=
 =?us-ascii?Q?0cMf9a/v8Ulp1c+g13QmZ6EPfoCgHi85xDvuqFA8K2n+clhmwjwd629WshVM?=
 =?us-ascii?Q?pbMVgt219hGjShdmhq+mzhi4aPjc/wT8NGqHCkHczv8SUi+5gbEH6RN+Hrau?=
 =?us-ascii?Q?QkjtZvisNIcwT2XsIJPu9o16atuV4MIZNaq/0gohAUnPG0JIYeEavdb19whj?=
 =?us-ascii?Q?J7qlE0EABw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a5350d1-4393-4ddf-0a1c-08da230339b1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 19:23:18.7217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lDFsH3MNuM3BuiYkaF2CDcAIfT5vW0P+xrYqRvyL9BYo6rfPtpHFV5MJM8k6/KXZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB4679
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just change the argument from struct vfio_group to struct file *.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c  | 29 +++++++++++++++++++++--------
 include/linux/vfio.h |  5 +++--
 virt/kvm/vfio.c      | 16 ++++++++--------
 3 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index ae3e802991edf2..7d0fad02936f69 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -2035,6 +2035,27 @@ bool vfio_file_enforced_coherent(struct file *file)
 }
 EXPORT_SYMBOL_GPL(vfio_file_enforced_coherent);
 
+/**
+ * vfio_file_set_kvm - Link a kvm with VFIO drivers
+ * @file: VFIO group file
+ * @kvm: KVM to link
+ *
+ * The kvm pointer will be forwarded to all the vfio_device's attached to the
+ * VFIO file via the VFIO_GROUP_NOTIFY_SET_KVM notifier.
+ */
+void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
+{
+	struct vfio_group *group = file->private_data;
+
+	if (file->f_op != &vfio_group_fops)
+		return;
+
+	group->kvm = kvm;
+	blocking_notifier_call_chain(&group->notifier,
+				     VFIO_GROUP_NOTIFY_SET_KVM, kvm);
+}
+EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
+
 /*
  * Sub-module support
  */
@@ -2446,14 +2467,6 @@ static int vfio_unregister_iommu_notifier(struct vfio_group *group,
 	return ret;
 }
 
-void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
-{
-	group->kvm = kvm;
-	blocking_notifier_call_chain(&group->notifier,
-				VFIO_GROUP_NOTIFY_SET_KVM, kvm);
-}
-EXPORT_SYMBOL_GPL(vfio_group_set_kvm);
-
 static int vfio_register_group_notifier(struct vfio_group *group,
 					unsigned long *events,
 					struct notifier_block *nb)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 7f022ae126a392..cbd9103b5c1223 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -15,6 +15,8 @@
 #include <linux/poll.h>
 #include <uapi/linux/vfio.h>
 
+struct kvm;
+
 /*
  * VFIO devices can be placed in a set, this allows all devices to share this
  * structure and the VFIO core will provide a lock that is held around
@@ -144,6 +146,7 @@ extern struct vfio_group *vfio_group_get_external_user_from_dev(struct device
 								*dev);
 extern struct iommu_group *vfio_file_iommu_group(struct file *file);
 extern bool vfio_file_enforced_coherent(struct file *file);
+extern void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
@@ -183,8 +186,6 @@ extern int vfio_unregister_notifier(struct device *dev,
 				    enum vfio_notify_type type,
 				    struct notifier_block *nb);
 
-struct kvm;
-extern void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
 
 /*
  * Sub-module helpers
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 2330b0c272e671..2aeb53247001cc 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -62,17 +62,17 @@ static void kvm_vfio_group_put_external_user(struct vfio_group *vfio_group)
 	symbol_put(vfio_group_put_external_user);
 }
 
-static void kvm_vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm)
+static void kvm_vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 {
-	void (*fn)(struct vfio_group *, struct kvm *);
+	void (*fn)(struct file *file, struct kvm *kvm);
 
-	fn = symbol_get(vfio_group_set_kvm);
+	fn = symbol_get(vfio_file_set_kvm);
 	if (!fn)
 		return;
 
-	fn(group, kvm);
+	fn(file, kvm);
 
-	symbol_put(vfio_group_set_kvm);
+	symbol_put(vfio_file_set_kvm);
 }
 
 static bool kvm_vfio_file_enforced_coherent(struct file *file)
@@ -195,7 +195,7 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 
 	mutex_unlock(&kv->lock);
 
-	kvm_vfio_group_set_kvm(vfio_group, dev->kvm);
+	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
@@ -231,7 +231,7 @@ static int kvm_vfio_group_del(struct kvm_device *dev, unsigned int fd)
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
-		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvm_vfio_file_set_kvm(kvg->file, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->file);
 		kfree(kvg);
@@ -358,7 +358,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
 #ifdef CONFIG_SPAPR_TCE_IOMMU
 		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
 #endif
-		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
+		kvm_vfio_file_set_kvm(kvg->file, NULL);
 		kvm_vfio_group_put_external_user(kvg->vfio_group);
 		fput(kvg->file);
 		list_del(&kvg->node);
-- 
2.36.0

