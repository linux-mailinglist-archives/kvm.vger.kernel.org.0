Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178FD3466EF
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 18:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhCWR4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 13:56:09 -0400
Received: from mail-dm6nam12on2060.outbound.protection.outlook.com ([40.107.243.60]:2016
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230486AbhCWRzj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 13:55:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=How0YWmmKs2DQR7NiBPqh5AIVYKf8tMKOgMezENqGzHc/X9RTJ8AzBvE3GMdvsCtiaoOltfPdznV9PakM81GR/dH0vtx6O2ZyHoC6CrJ5o/Q1IIVs1C/hB5RhCcsOg1ClTU2ukaX6+m99ChmZK5bxZLkMPGMcg8WRlWo2XgqW3DRl5mQbvcKJet5Dw30gHnnVq5LIJhIfkAWWNGawYeJEymGMN3e7VUqfnSsTenUvZBV3d7k9sznQKQuX0QjCSEbGMIDDOKDOnZOW18dq3DfUIUNbMdezzQaxI0PpD0r6zc+Mkt6KaGUb17wU1+cq5pV3qH8y2q9nyQOwZn9qLFOZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TtGBYQPbWyayp2ZCBthrWYuQ+1NmWl04bzwa25ti5cI=;
 b=TMOUFgkdjwSTuJ5HRCPShsZSD0vZYNDhM2e3YST0BTdTk67MVRByS4s+v/7PKh1A9eOIjN34o7HywbJ9pIvWuhUZz3LPTzTBB45WaSYM80Y6tepOHRZT5QSxs0nJrQNIPTYNJo/INQzCduENppkkBFRr+6OkHNbUQBOXTk31Px9C7OV7U8wDr2CATVy2FKCuvWjPfL6F5SjfDxQp0zSWFb1LmBM21fR+v3OacbPK7JeZ4NDoaQIjSqH7Is3HVLwWbLGAv7R25fDkSaRqJiki6KWrkvypWCvLUToJoPzZcLdmbhxtTDuwle07kjjg1lVmc4GbDmwXrlPZls+ULECNfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TtGBYQPbWyayp2ZCBthrWYuQ+1NmWl04bzwa25ti5cI=;
 b=JCBcDSYmrnc6ROJu1ZCdtVMnNBwHyKahGAmVcjS0fYivZVsQWOasmFeTyioxT38iBOWUqaHUZ8KRcO4NAPX1LbojuaxFWz/a81UaSDY/nsjvR0ZxMmF3akIDo+FuXjJZnZbvqrnap88lax63B9S3NsHISKq4Jtjxu6Lthaq5s7M5V9Z5U+Q0x1zWO/2OkPWnb1bylbZS/r5IMcOl7VRUAibGmC15q+DCptR1kHTZvCR/tjDfWgAfc+wtK6fHenLkJNwH86vaUNzUK8VZrWkjrubJfoR+yBbzNw+gMp17+JADQw71Rto5kPIiCzKD/GqbqpxaXsecOWat2Up1duklAw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4483.namprd12.prod.outlook.com (2603:10b6:5:2a2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.25; Tue, 23 Mar
 2021 17:55:37 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 17:55:37 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 06/18] vfio/mdev: Expose mdev_get/put_parent to mdev_private.h
Date:   Tue, 23 Mar 2021 14:55:23 -0300
Message-Id: <6-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v1-7dedf20b2b75+4f785-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BLAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:208:32b::24) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BLAPR03CA0019.namprd03.prod.outlook.com (2603:10b6:208:32b::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 23 Mar 2021 17:55:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOlFf-001cgk-EH; Tue, 23 Mar 2021 14:55:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f874ecbd-f97e-4060-4267-08d8ee24dd17
X-MS-TrafficTypeDiagnostic: DM6PR12MB4483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB44835A7098E9A96768EE086BC2649@DM6PR12MB4483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: USwgDIJjHjeysg+iGkHEkEC/jNkpht/ZOWdSAHTC0Lorz5KN/d0AeQn5CNNbrztKTcvT1eErhbqFJ4rjqKWgc28CqRdqo+3nUTCfEtous0g8rVY4PI/OGk1ywRkHuHXROeI+Isi/1xjp3pd4jiGnWt+NuFTqc+NJuZvwG+7osFHEhHmsrCUOKbC57pY4nO78tUYX/9lcErl84smlqT1KgWgPQazI14SelUSuuCcW3jt2305CGkOlGhieqeyuESnWfr53E1wn411Sw15rtAaK0w8kLOx6I7SxfATPJHhzfx47B30jDsVOEo0ZHplT12QtO7CoFP6mYIpoyspk06x9v3qDjOIWBO5JJrgCXcyeXSQ150zO4+Wqz5EnSNpWULvksEk2xU1a7W+2BZNW+qZajQf1QVPezo3tTToJSfRftGAVJLvpOF/E4t9qHd6DO/DW8iqG0Ts1LRyKQj1kYN6Ed7bFfBNgcD/2zZtrkrIZxWaambeTYh7CB7Culx8sB5idNFAObUP4H/xsryUfe/ulRqWRY82vA6LmkMhCrikUeNhx51T6Thb5iF5iQ1Q2uYHYhY0pgW6m6aFVZlLXtrYK2268Nk9IrdrCDotivMP0uZXFlDUxaleg7h2KUTt5+Rfk9qiQSZJvMaS/JDL1Yk3HDYpOpX2nIIyGoRZ79tvAzzwot/3fj04YTdCHmKyNiU8X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(186003)(26005)(36756003)(110136005)(5660300002)(38100700001)(66946007)(4326008)(66476007)(6666004)(2906002)(66556008)(54906003)(6636002)(478600001)(86362001)(316002)(8936002)(426003)(9746002)(9786002)(107886003)(8676002)(2616005)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?aVsDFZKkfC2Y2jfS6ojG/ASoBIiP96SeIZGFB1svNt4Q6N7FvVDFMhJIJ9q4?=
 =?us-ascii?Q?YIUemdkCxihJz/HHZg8cnn4Dx2fUrFJg/7CEx17kxlE82Co1SxDl9PLeXK3H?=
 =?us-ascii?Q?ZnY6k3jHKEVYgZXBxA7TrVxDZT0DP3FoYw3ZIJ6ysKteucs0yLlSXVCCbdtZ?=
 =?us-ascii?Q?bxJEcmUsIgKYySUaqvf390tMREh2ny8duDR/9h+H0l0o1JVwNv/SgugNnCiU?=
 =?us-ascii?Q?23Fl8uluf02u+e/8KTBvbIhY548fl11yeHG+LZN8lS/Tf5wNBFUpTWDl92AG?=
 =?us-ascii?Q?CrWF4h2jrzVPXRxDzbsoBQVe2dIu9vKxMT0MRkm9//kDc50kCFgMIiLcKkIw?=
 =?us-ascii?Q?EQLzYofwIvTM/1gT4lxykQ3pnT/5NZUa6FKQpJJv/f9hthqYm6gKVXYoKfzb?=
 =?us-ascii?Q?Ypm7nivtEvCRYB4zM2Hc+kBbluus1MzzJXI9Hr3H/R6tLNmsyLw5eudD2HFG?=
 =?us-ascii?Q?R7a24baYc+Q0Hgku7HM8ut5+9tZfdRyfTiYOMNvr4z9obdJBe4J9J8I0ejZL?=
 =?us-ascii?Q?dz6hp8GbNRl8E1UflCpUb6tfiVeNm3b5yyL2vZe1ouBZZRCmDccNe0ERwRqr?=
 =?us-ascii?Q?KnrKgUWY12+RAooZJ0Pjxepcr5SbKApTbOhwl44FpDymE/AA+1GmCwDqQqTp?=
 =?us-ascii?Q?lcs4naHfzdJuIPnah2/yhdoY8Q+2wNwvj3inxI+Xot1PSyDAFc/GOFtp0kVN?=
 =?us-ascii?Q?baZLywU+S2oxxFnQboUAKLxBygWAcrpZOx0rRv87N2OMdP7QIwa91wtTfUEc?=
 =?us-ascii?Q?Qui2l2x2fpJredX6jklUBNRARCZR0sYBWoUqbOHbpHiCvSRrNyOhPtZJH42y?=
 =?us-ascii?Q?EDU7UAzMIygHS93k/RK3bgUTXAf1cuSZzDW0FmA64gz8gWfyq5kh+ZE0aqn9?=
 =?us-ascii?Q?uPoMXjEARZVVk6UBKMdJL3ftgGhC9mBD2wAt8VWNPl3K4OtfB7wiEPQyD0XX?=
 =?us-ascii?Q?pknNSrAn6cz0xzwoEFbHJcXvVabmwLG4VBiBw+YvQB/hbA0OX7zzBBXuthEc?=
 =?us-ascii?Q?Lfi5wjvHiP9d3LSBTP0WDHlleRcfHZh8L41pyMqL/nc8iRHDRLZGvLgbtm6f?=
 =?us-ascii?Q?/PyKRkCnhYQEl5ri+x1zfDuVbOGq75hjDjM4b9XXC91nhlT4tK6/bHF3ypBe?=
 =?us-ascii?Q?CqjDFi95h/Se2hBmBNmGCBqg5Bjx5wexWSW+JxS/UZOeWimOmr1kjyJLhYSW?=
 =?us-ascii?Q?SXvEoMYEwFcTAAXCMo4NEhjE668z/UpZYOGXkduOkq7Iuq24+Ck2qOkyDHE/?=
 =?us-ascii?Q?YBjqWn+Uag9yHFDEoyUrDpt8PLJi0saDy8sckloIBUfgf4LRfBLjZO1iXkIv?=
 =?us-ascii?Q?gnH04V1gdn7jl29RMBtfY+3B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f874ecbd-f97e-4060-4267-08d8ee24dd17
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 17:55:37.0436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5lL8T1102bnCnWlvCKnh2zuYVlrs5Cn/0fferNLxW2h8+RH9q9SKn95D7iCabt/L
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4483
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next patch will use these in mdev_sysfs.c

While here remove the now dead code checks for NULL, a mdev_type can never
have a NULL parent.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/mdev/mdev_core.c    | 23 +++--------------------
 drivers/vfio/mdev/mdev_private.h | 12 ++++++++++++
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
index 5ca0efa5266bad..7ec21c907397a5 100644
--- a/drivers/vfio/mdev/mdev_core.c
+++ b/drivers/vfio/mdev/mdev_core.c
@@ -45,7 +45,7 @@ static struct mdev_parent *__find_parent_device(struct device *dev)
 	return NULL;
 }
 
-static void mdev_release_parent(struct kref *kref)
+void mdev_release_parent(struct kref *kref)
 {
 	struct mdev_parent *parent = container_of(kref, struct mdev_parent,
 						  ref);
@@ -55,20 +55,6 @@ static void mdev_release_parent(struct kref *kref)
 	put_device(dev);
 }
 
-static struct mdev_parent *mdev_get_parent(struct mdev_parent *parent)
-{
-	if (parent)
-		kref_get(&parent->ref);
-
-	return parent;
-}
-
-static void mdev_put_parent(struct mdev_parent *parent)
-{
-	if (parent)
-		kref_put(&parent->ref, mdev_release_parent);
-}
-
 /* Caller must hold parent unreg_sem read or write lock */
 static void mdev_device_remove_common(struct mdev_device *mdev)
 {
@@ -243,12 +229,9 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
 {
 	int ret;
 	struct mdev_device *mdev, *tmp;
-	struct mdev_parent *parent;
-
-	parent = mdev_get_parent(type->parent);
-	if (!parent)
-		return -EINVAL;
+	struct mdev_parent *parent = type->parent;
 
+	mdev_get_parent(parent);
 	mutex_lock(&mdev_list_lock);
 
 	/* Check for duplicate */
diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
index debf27f95b4f10..10eccc35782c4d 100644
--- a/drivers/vfio/mdev/mdev_private.h
+++ b/drivers/vfio/mdev/mdev_private.h
@@ -46,4 +46,16 @@ void mdev_remove_sysfs_files(struct mdev_device *mdev);
 int mdev_device_create(struct mdev_type *kobj, const guid_t *uuid);
 int  mdev_device_remove(struct mdev_device *dev);
 
+void mdev_release_parent(struct kref *kref);
+
+static inline void mdev_get_parent(struct mdev_parent *parent)
+{
+	kref_get(&parent->ref);
+}
+
+static inline void mdev_put_parent(struct mdev_parent *parent)
+{
+	kref_put(&parent->ref, mdev_release_parent);
+}
+
 #endif /* MDEV_PRIVATE_H */
-- 
2.31.0

