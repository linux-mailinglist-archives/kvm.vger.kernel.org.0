Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95F7355C60
	for <lists+kvm@lfdr.de>; Tue,  6 Apr 2021 21:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242771AbhDFTlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Apr 2021 15:41:01 -0400
Received: from mail-bn8nam11on2061.outbound.protection.outlook.com ([40.107.236.61]:28513
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235234AbhDFTk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Apr 2021 15:40:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF8Z7pUWlY95h2fa4EacFZN5SmhKZgd1w8xwSxZoq/lWOjux1WejBVE5lKCycZVLdOh8PKQanMxJR+u2N/mZm84hLW8pA2ocYR2XkQafxKxeVudkb+d7c9CPzTm4MLBPS3rNugEp8ThLI7Otj15ERIPHB6RYiuVq8BocH63TE6GHzNJulwy0MHacFMthZegQirV/BOp9ecGntsSb4iyr7fzriGMuxiK6B8HuoOTxzs+doKk8XM92hhhQ2PbVz2ve+5u9eh9HxQD/Pauk/ox0CAI08HTlc95s2cEBFiKxO3AksTSU6cW4B3L+UrZSgAQqM3Ze/CFb6LGp1FUp0GaUHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EThwu+N8z8edP7jiWd3LH+J3xAYs2vWsRfmw4C+N8c=;
 b=nSMNDx4DaefATUtwL6/aK25QRVlAHJpC5tzWctaTB/5+dT9bf1uhPJbAn/za+iMlkr399ri/pvXYth9EhLJZ8tplSs7mSP0E8Wsep4HNnVsMFQNVS815RQmMl4Kfg1FJsA1hJrbxHdZzJ2zCFZFxRwH90O4/MTK4SlKU/OTNhHJWB8ygtfRhFuJhDnJA33SZVAPTD0NG9BytvStNbdj9RDv0T3cuovFDQGhaGhVSYanm5wqO4bLVnMyewedxUW/om2y2VAbnJ5HOc+zDCtvKpDfSrEwBmqD+zn2jv4ldOaGl6rHTkHpGESakWmn3Zvdq04RT01c8742TUPf2ja0Shw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0EThwu+N8z8edP7jiWd3LH+J3xAYs2vWsRfmw4C+N8c=;
 b=EqOVsExl+sXx2kVOJnhsFfB389dVRe2sXNEMvAKMC6PbNZcZ7KFjrjxkE3oEwLeSG3fECFv4KuiUcuJqK60caEKyajqIAl1ZYHihRL1g/13yDn9M9RxHDQuaK9Y7Fiak2GcG4b4Meswx0mikpAra/JCf02QsewLhcMTA2gdM41GampAhbmKyEDQrvUFAUc30AQomvBacQV6eT/00hDGne44LulEAWhmI7NZIawjl01bU4r2QJet7+Usw4NrM51ZG+gI1i0sRY2So+Ej5EzkhSsolPNDedRf4Y/iZFatHG1d40wfmgfSFu1ruCJeCYmbv6eG+YGgZhU5Rcvq1n0w/sw==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4235.namprd12.prod.outlook.com (2603:10b6:5:220::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 19:40:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 19:40:48 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 06/18] vfio/mdev: Expose mdev_get/put_parent to mdev_private.h
Date:   Tue,  6 Apr 2021 16:40:29 -0300
Message-Id: <6-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
In-Reply-To: <0-v2-d36939638fc6+d54-vfio2_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR16CA0020.namprd16.prod.outlook.com
 (2603:10b6:208:134::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR16CA0020.namprd16.prod.outlook.com (2603:10b6:208:134::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 19:40:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lTrZ4-001mXB-33; Tue, 06 Apr 2021 16:40:42 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec2fd02a-9e02-43c0-8d7f-08d8f933de68
X-MS-TrafficTypeDiagnostic: DM6PR12MB4235:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42352FA9D1DA0E6C7A79351EC2769@DM6PR12MB4235.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l4i5xRas3Ah9rOThqImW2hpF2lyhDO2HER4ewqJHP78/aRVWW9476bZp1ley15HKQMQ0JmUyXrldaOWMJNbjtwuXuYEoHlwij0nHqF9eOkmF1+4i/hlkGXZJfIpRIvZMClmxHHI2UuCk2UlmVMy1U0DKNmhyjxdKk+idDfJnCmZElvF/UC9F4KoZshPpbuwXh1XCEquijpJ7OOFP77HSbB5J715o6ndn/PDpz0tbNR1D3pdwBZIRikxqnf9T6j0vNyMKEX0K3odi8arLbzvOyOmvAbiZrODXTUE7QHs0T0AMA4jS6WMcdJjLq9kpSCn8f5H3U5F6HhgD7qgyqwcGJQsda2jrMMETqlwG0SGKT/NHGpHGWW0HPAF2Cf/XnWIzEFrnO9cnTUI6PxldEwaV808OwqWYbVI7MdsW4FM1Q06MhUlWrfNUzuLJZl/ptfwrgQ7mGMrCRn6VGleGe6IAnokygJacIlI4wJcy/RZmE/2bSt2oLKEEDI6NImgRL3QqWl474g+OGNgYGxFXS1JAsANrOrAceB8Wm8CmaUIQDn3t+AsjIoDV4ANkLpdybXjQ2RugX6iQH0ld3h1b1/S8QCEwKU00qxbKvWtA0G6jqYOHXcYoTbTDqkJFVwStWbx+AvwlCNS/ZTyiTAfMea//+p9825bXSUQWSHRzXuBWZlGNVcTNdGVlj0juIuXFMmTB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(478600001)(54906003)(8676002)(2906002)(86362001)(66556008)(6636002)(83380400001)(6666004)(5660300002)(38100700001)(8936002)(2616005)(66476007)(316002)(426003)(110136005)(107886003)(36756003)(26005)(9786002)(9746002)(186003)(66946007)(4326008)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ciSpyJ1el7COqPEhnTlwPGXxemVL3+dahV+5TLKrl/SQBOyCW7X7Ll7imK4y?=
 =?us-ascii?Q?Ubh87qY5534kZ4/0Ew5hqJPGHL2pJjz2AK36Trg1hLoD24nL01ApU4f/ovg8?=
 =?us-ascii?Q?1Iv4cnVAgzLR31TpKPRYhULSX5NGsR53g/4z0N86Qse9TaFsdurhJjWygI2i?=
 =?us-ascii?Q?OrEj4UKuQ8zsGUst67n8r72znl3A5FFRoxeAFHRcV5dbVKp5vY9WiDuOUmwP?=
 =?us-ascii?Q?ndQ21rKcNBWTmp1pJ63SyhbVHFKCTZVxjQJq1sNiHj51sqdODU46LS/Ru4Pj?=
 =?us-ascii?Q?iPHZJK7VmHWaZHFTi6y7qdVcIpa+iV5niEeZyRuquiN8ht2J+NKp5jiSg+2q?=
 =?us-ascii?Q?KYQR3zwLDYeSADWPl5sXsrPRHImIE15viMJPLMb7dVGTK7usaKuLE6dK0PDn?=
 =?us-ascii?Q?WUyBCTxjCi1sGDJMlh1395geN4BGH6EoR5ire9bWzmM1MFke17F0ObRiJsp3?=
 =?us-ascii?Q?Y0LuhNeeo3DMAY2jfZMxIAmcmVohK1g9GThX3GaA2qExBSd6sGY0xtNjaEot?=
 =?us-ascii?Q?V8/Ldu7n+xiJSm8L2VdjL3ySjkHufo6f0aPgmwvB9jjZytkDHPXK624wounB?=
 =?us-ascii?Q?uv5iPDZBQy1WiEvXsHIazQANaiOjbTpKFTCOIDOi521JvAdnzPbCrxNkbQZ5?=
 =?us-ascii?Q?bkJmXjNRNzRs3EpCTGBWg5tDWSWj4kQVgCnftcAauqSrhiwg/BrmpakVYhya?=
 =?us-ascii?Q?gEWT/xQ/SvLYVWxuCj8GZ3zDMnEVyzGPtrteA8B00qM/yWtzF83jD/jMniRT?=
 =?us-ascii?Q?NO6uHjd2G8tRLv6P5iy+KcwLzbSI45Ai57QHsJY1ARHERZLIgaoXGg0dvxfh?=
 =?us-ascii?Q?BISLyExz1Y9rPARO/Gg56w3ppwXEihqCWlb+Wev4M1Y+RfDkPNnGMDIqQS3/?=
 =?us-ascii?Q?whU+bp7Jg8pVWfagosb+7Ma21yuU6azfPyC2bgY1vt8XJPm4VOQcrNM3k+eV?=
 =?us-ascii?Q?8we5rtw/av7leCa9nKxOcZs4OSYqlsdDk4UvioH7uu3r53gLCTyxCdOKKnSD?=
 =?us-ascii?Q?m2yBAf/BmmkyceyMwxvm674P1rj4Vxl1zp5It/To4Rhv1XpXRs5oqlfAcHcl?=
 =?us-ascii?Q?r5XpQVDtQbZHgum1vsitT0ev1ddl44+7yxv8GZo6Z6nx9uhp0ioWCoVOxfA8?=
 =?us-ascii?Q?8ayOiJDm87Z9RC4DaFYkH2q/0CZHjtO3ydXRrnLKvxNIVUAqSmOmet38xTd7?=
 =?us-ascii?Q?XiYIDLV0yegMHfHb0Kp2UvLGoqnbD5JC0BqbIwGVeyGQfgkNwDeSM4i+1Jkq?=
 =?us-ascii?Q?a1sdbJ65JSFVmw8XcmrRs2Hb852YSNQXhpS0NHzOy4cUoGAQMt+o6M0jxqUF?=
 =?us-ascii?Q?MOzN3WI/7GI/uFTcFUdsKw6vZpEQw5nLpJ5xQjYeVab9xg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec2fd02a-9e02-43c0-8d7f-08d8f933de68
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 19:40:45.0073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DdmhO/L3zDan0dHHnGr371ISDozgkqEdbn+x4ZF53zYTkDOYlrJw7BU4CtKtqfMP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4235
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The next patch will use these in mdev_sysfs.c

While here remove the now dead code checks for NULL, a mdev_type can never
have a NULL parent.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
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
2.31.1

