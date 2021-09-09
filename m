Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB3A405BF6
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 19:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237163AbhIIRZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 13:25:15 -0400
Received: from mail-dm6nam10on2063.outbound.protection.outlook.com ([40.107.93.63]:44512
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232940AbhIIRZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 13:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcysXfsbp5Chi4fvKQbQMh5JsHRQKHy/9hdeU+B2iV8Eu3vS/fziaiEmiJfccLBcH902tgmyf+Xx3kUTlZfxE4AcpQ7pO5VmL2O/sU3YHjd8dynr0fGYFOHRJ7JwjLFCpt6F4lSfkTv+4+7H4U2KoPTbRsFzFhOiRPfp1Q0BLBUpgN6wc/xqUBzYi/c/ZBGMHwPF5ogfMc7zf+VyxMjAwBDaZEiAHCLcQLOpXSVsdiDxUaD7EfaffZAN166VPEI86cwCs1DbR9TvVjf6eilqDUDL7kuqugIOkWdpvmKktvSdlOz/1vUDzNmemjrUZYU9VbmEW2FuRjYRum/Xs0TxNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=kR2hINXafxIsl3ZTsk78cR6OMx7Hj/njmaGIlKXBt6I=;
 b=AXwKW/ZsJxJs6gDp5UtmTPAEOd34U/Y0EfBv9Ev7a1rHWxgDo8UlbxIZ+2n504p6cNfcmJ81n1QihkYJFIglA1Mt63z8l4TFtWQN4IjhWC3WHSR8A3F2/GlRuQXmdV1jo10q0LuEOmgqe2dqxJ2TFXZmqUxg4+vGD3zDo9cUtX82Yg1u50uiLjFn+4FdxMynJrPfvS4qIIXu1gPKAXJE95VyNL/9d0keQFxmfI3oFt4hrzOPfoNqIX8EI/DAh5Z5NVJ6AQXvaPYqaq4I7syVi2wfOuBJ4J4CuaEgTNulMoyILHD5wMqujCwFXyqDqcUowsij1PreyKxAkD0vzQw6rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kR2hINXafxIsl3ZTsk78cR6OMx7Hj/njmaGIlKXBt6I=;
 b=VVRpqa3u4NJMVH6o979EplfJYXR6XTXRVwGLLJ6/sD7TWbmFqB3tXfjO9h9o0h27gfr6xOB8jHTFq1zNCn5UgqyYrRIitrtwUfhzhud5p2shij45PzH8HGiQFL5Wmras/AdE0f+7eBQU8wpzfqIJQ9nOqsK/X6j3SvEa9l7q+ygYbX8ugmuF67c6uU8Xdt7kBwVtYRPr+LP3jArmI7heMltdK2WTs9w74l+jqJf1THuBsYq4xbMmbJzUcJHgcGTq4OR1OhptFFXQ/xsG+BxKEf8ZAx27GfzpCtzkX0+zOQvMdX7aNjN9luuhWkH65WlF/WOQuqipBEKZQ8WhYoBJog==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5064.namprd12.prod.outlook.com (2603:10b6:208:30a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Thu, 9 Sep
 2021 17:24:01 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4500.014; Thu, 9 Sep 2021
 17:24:01 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: [PATCH] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Date:   Thu,  9 Sep 2021 14:24:00 -0300
Message-Id: <0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0004.namprd15.prod.outlook.com
 (2603:10b6:207:17::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR1501CA0004.namprd15.prod.outlook.com (2603:10b6:207:17::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Thu, 9 Sep 2021 17:24:01 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mONmK-00FIii-K5; Thu, 09 Sep 2021 14:24:00 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 684d0fb6-6a75-4b84-5eb4-08d973b69d9c
X-MS-TrafficTypeDiagnostic: BL1PR12MB5064:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5064E4D10B6073E560A52079C2D59@BL1PR12MB5064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEsS61YhP4hTSXFVGifq+EiyQFCebaVgNUl+xUvQFqKVvma9N3CU2i+RYelqw2sjumUYpaxe9GHBt9A9BuEUUd+53GYKu4vFWtBqjbdmhhGQGoH6Rj8Jrh6m360Id+0igUj9iMjm44IcUwUkYcoNeVF/DQhlp08WiysBmHaDgrz9Izpw/32dkNKvANIKPfOGfHIhSg/yMQozcpQgPdhQzwxCdfZpFEavfjT9p9I7Uhjq0EC1/2JsDWR+ChJbyxj2s+LjHmpTTQBc7uhbxHAzAsS8jbOcS0s2v6trA9mwdQKZzldyrR7x7PrU4FuE+cweUn54vPK4Twhnf4n1asrBjojqhZ3CHSHV9OjJ1fa1hhDq5NY4MX4n8IdrIbtGBd9K9TlCA9Y++yiHn1GKnYU+mc2bD9mZbNjuEEOahgp/jHsr1cPzX2QSdiGWPL8M1wqDrMyaYQGkZYXgEu2uR45ZwKQEJX8YUP7UerNnksybIi8hPT6RNYdhC+neaQkRRR9MaBJXOvRHsSE1kf2v8nFpphcqkVML+iZf9/eZpRQ6n60xFdvtPdJuaYNKuS6xv517mo5zQNpoSsxNYJTMgE7fAnF9GfpRw1ptpFVTQ17vo0/p0ppajCKZfNWT1xVoPqfrrEFw9cleXv3880eZXyMHMeA5Nqx4MVKDhsWi/elcKL//41nS0XWHmup7vRQY1pla
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(396003)(346002)(2616005)(2906002)(110136005)(26005)(426003)(186003)(316002)(83380400001)(36756003)(9746002)(9786002)(7416002)(54906003)(5660300002)(8676002)(4326008)(66556008)(478600001)(8936002)(66476007)(66946007)(86362001)(38100700002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d3q+y0f2l7C7NSLUO6Au8vzscoqZsIxVGxJ0sSDnKXqNjR7VqyYN6i7Y2Ck6?=
 =?us-ascii?Q?c9YgJMCwIkGTlQNulZZiCzHVFXyFZQqGnoiO58arNBEqmZ9RwKc+YhLxgy1w?=
 =?us-ascii?Q?rwUo/orIrPVDBY635ldGAlyI3I0YxFEjJUTVvRzJLFxabPeTYRVwrS8b89Ta?=
 =?us-ascii?Q?O+tp36e3T8A98jXrmekwR8wkHE40mMIw8KKQBesF8rJrTgT2u1TU0WHduGtk?=
 =?us-ascii?Q?1HyuN8LDdfBZS27o3CGmP70h1y0PEv5bNoZgNHtLo2s4aN9JhxI3AwQj0UmF?=
 =?us-ascii?Q?LVv9/Rg4epDTknfQYVEdqWkeT/Z2qMgyqTzljJlMQSSDq1bBLuE6qgtecUYe?=
 =?us-ascii?Q?ZeExchEUz5K/dUajlYGn0uQjJDFjYVNA6P9uFjxVGhB3XHTbDYeQVySsZBct?=
 =?us-ascii?Q?1H1xxdPN9ZHZHKd+135hzVpds9BtCIy/9e/mhrCAtleyp+HvQ9rMSCSPb6UR?=
 =?us-ascii?Q?yhVcYSy7yQSpoF5todSnkegRfD+SWn84FgAf43a0k65er8D+LDGkz2fhYzSm?=
 =?us-ascii?Q?BG5qk04zjVR/sBuyxxRBR7Xdcc1lhjtfEcNgpVoM+gSU/RYEZUHI3rPV/aEa?=
 =?us-ascii?Q?D8FccbgY3m2KWo10WHoDGa7UUO+0pj/BgcJdY2vbtGj7nNvcxO88or31zB0T?=
 =?us-ascii?Q?IHr1ZVti0gq01wOoV/jPxEkYF+2IlyF9g1ZzqdCMcvOt8mQs3otDWZLzR8y5?=
 =?us-ascii?Q?0UPnYHfT5ZBvqzsGfy5HBp+cESWYsgm76oOmkAZpqNLfrdfVyugTqFB8c3B/?=
 =?us-ascii?Q?X+jd8ZMGnMaC84jooy2Uw6i7jF8qWZQ0aB/4lwuuR7ONY+yNiPWYoEKljo2v?=
 =?us-ascii?Q?oWhqaGGkBkrHHMLhz8exgxr92FePwKaqHAv7mpR+y3Kgm/7UuslPqKrzelxV?=
 =?us-ascii?Q?6xYPmud1uvS8lPAzGdmz3qiIFJ/t7Zk1jPdpfe//8nw/sZvYXAR59ic5S0m1?=
 =?us-ascii?Q?MtJ9gJB6Ipp+JabrlVKFnGLs2hLcSU2O5BrNVwSrtn5iATJbfyEgc6nOOZKm?=
 =?us-ascii?Q?ypc/AAVXWWIYe+w0f85wLaRQ4zq4FahzKPRILts1u7w0J0kd/NIkgdgfDCk/?=
 =?us-ascii?Q?emoPbJXb06vKuhAfJE3eKWCRf5EH7vVwS7C7RYmNCQ9Rh67zU7emSgg7xRMa?=
 =?us-ascii?Q?1C56MKDrONdQekgAs5rGZccpoVozOoesGHtcz8B2nRZN+anc2+/HC3eUj+AE?=
 =?us-ascii?Q?Z+BaN/cbKCRxgZEAZwAbW8bTlZuVhtaag8oVwPnU3sLp2PIk7R5nZojrqhTe?=
 =?us-ascii?Q?grUB8V8VSDiOH/XdA3pZAYU6CIyeu+yNPjEorBCfgIRtSggO1gCyIazHQfna?=
 =?us-ascii?Q?+HOpMTUx1Z1h+6MwugGQmk/V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684d0fb6-6a75-4b84-5eb4-08d973b69d9c
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2021 17:24:01.6363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t/n/LJUwBFdGH4sauUMgvze58OVzG+WH+KaRA+GvpUfm/Ev/m/s0HE+vqbxw6EgK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5064
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without this call an xarray entry is leaked when the vfio_ap device is
unprobed. It was missed when the below patch was rebased across the
dev_set patch.

Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 2347808fa3e427..54bb0c22e8020e 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -360,6 +360,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	mutex_lock(&matrix_dev->lock);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->lock);
+	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 err_dec_available:
 	atomic_inc(&matrix_dev->available_instances);
@@ -375,8 +376,8 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_reset_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
+	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 	atomic_inc(&matrix_dev->available_instances);
 	mutex_unlock(&matrix_dev->lock);

-- 
2.33.0

