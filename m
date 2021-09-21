Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02DC41333C
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 14:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbhIUMNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 08:13:31 -0400
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:43649
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231799AbhIUMNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 08:13:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LU9rZl0mFdrSSL6ogYwjoAYOKBKOAIAb0OWYk/h7QPnWcy/OTk3qu+wmDjgRHJwvuPyz10AukcrfrZzX6vItrX62NNRiDZf4Y/w3iIEH7pebVHBtbsi9wgchmk5i8DvIxcz3+B90AmmBwgvgJjmj3A4dPdCaVYMCFLEPNdEb9FtFGLX/M04d2hAtEprevjU7gF+OwFqEIMsX0v20sWf7dab15xkt1Vc5fdtSsBhKu+JTzRl+iGXRt67DiU8oJ53dy9KN1GpWyd1AnrT7aKxIcNVOYI5g6U5g3qNuRBgpfs1npgKXeQ2bb889DzYfeCON714S8oc3dLqrAGeL25Wlxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5EM4zEs4vYYmFnP4/IJu9xR+6Y8c9ohvogmdBc4UUJw=;
 b=OzqofAIcN6B8FxbmfxMYlqTzsYrcArf9uIEIoYDV+RHcgCKxJe2Pbt8FHYDQUYRqepS2/MRyaqVa+rBIDDXRlWXHgmw1EiZUtRMan0ICgZqn4x4V/ft367mW+5glqEteqazNhuOXo91ZHjUH74HQP5S46Ggmiq87akAh3j+rQ73C7yLvewimxLZjeGZhHm0vbevbyRaxRisCHW9QowVI1j6L/3EGYy/PxrOgPFb1a0I3gf3ab2U6Di9cAYo9EcxrtyfJzACAnTlg7KyVIDjlWeG9CMx8CREs82PwImFEL72s11/xJJIgT0zQiNs8HsE25Ktkx4ul0EcUsWQelbImcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EM4zEs4vYYmFnP4/IJu9xR+6Y8c9ohvogmdBc4UUJw=;
 b=uYfYF9iRhtw9wC8Z1sG3EtC2CsGC+iry8vPGPRSl5Ug4fIokb226IdoiGx/V5QcqSzlBzcupMM5pLVXfB1vsf5RJZhutM7N+lu1qfSYzW8mYNowdpSNwONLxhF/F/QePD1VEnyl5iKswUkVZKKvmK2Rbi8kPlO3m3opHDQqKsKqLxaXB6x96Pphw/5MrZoOOs2gf5ftyyBMy0hcClBzxplKSWDOtXZLUwdt1/EYTFV5KfkVG4qwR7wQ7E82xQMW4B2ROhhbCAtMC8K6vbGDH2XyuLRdEZ7L8oJEU+oZpxexKFC597ArK8a5q2QVM4Iarytv83BWJ64j/4SqmTUVo4A==
Authentication-Results: de.ibm.com; dkim=none (message not signed)
 header.d=none;de.ibm.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 12:12:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 12:12:00 +0000
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
Subject: [PATCH v3] vfio/ap_ops: Add missed vfio_uninit_group_dev()
Date:   Tue, 21 Sep 2021 09:11:59 -0300
Message-Id: <0-v3-f9b50340cdbb+e4-ap_uninit_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0058.namprd02.prod.outlook.com
 (2603:10b6:207:3d::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0058.namprd02.prod.outlook.com (2603:10b6:207:3d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 21 Sep 2021 12:12:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSecx-003IrP-6T; Tue, 21 Sep 2021 09:11:59 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9b62a6d2-b9ea-4d03-8bf4-08d97cf903da
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52869C2410303C7743F5E0E1C2A19@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfqTPzA66w5NjTzrL3vFm+FEaVbKFg13JUauZWQQlHh+KOaRZ6J3ujM3sPBro2MH9aQo7zT4E1li8ZZFhYiRKTUsVMfLEXYBufHxzqQFZJCB3u2I1GkHtczxSYmNapCoMZbQGETe9opleSottO+RnCugq5yL+VvVL+FPxdQvRdxvCTHHYhqiDFG+TSALeeA20fsHCCmtlSuMuIBIGMYqYOEphDEuwkPJuwIX8qzNXaChQZvJcmRQOkFZlLygnda/ymYaj3xs0dYdCoA2kTaW0hDormZwsijEqMNkVSUYu0T82hyik5hiVDQmwNybHNMUHk4NjdCUbjOmUbw9ZVQEuwR01gNTvjuLzjDHbRRSWUioW6fG52lCkRSTW2p7qja9wsWbwA3eUbmE2jf0A8fifMYkwMgXaXty/erQ1xNifj9e0S5qacMpciF+3oDvOnu1JCFAZ1TWNF24/Q70mU5xfAm1oi1lPspHssu1OWoTbJ3eJEJKE8Z/9LwjlWKdVIs12bBGm1UOGuGDTJZZ1tua2XFLt+qIK5uEkxcRrxT8862bX/Ci4THt+mWltKs4ewceXz4eODhZc4ks7mNOLmfecrp/imerGgcfRAOMen+Du1e2YB1DV5klaEl+Z33D6NyP+1V7NW3pvCEcU6haNX2jaC74IyNy1GJpf7aNfm8pOyo3EXb90nczoIzLCfzQrNoD0tuFfEeDqYJIU0pR8FiuAfyuJbCHi9yVpTf+v0NMwWaz98e0floMJDfEAnupKxC67Gvu755UeJ+VdNx+DHviC10gBxSr/fA2/OMWVZ5WYdNMmSNljNyejuRckZyPhKNp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(4326008)(316002)(66476007)(186003)(5660300002)(26005)(66556008)(7416002)(38100700002)(9746002)(9786002)(8676002)(83380400001)(54906003)(2906002)(508600001)(426003)(36756003)(110136005)(66946007)(8936002)(86362001)(2616005)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vG5fHbjNzuqYKtdMXIoFGeOOtUOuWaUjz00s0vqtg4G2Zf6gTdz1dkC8k4Zm?=
 =?us-ascii?Q?f8m/rllI6AZdTVVAEgwU3G+7Kc+FiUmM4En+PbrypuIrgQubSW6h+aV7g981?=
 =?us-ascii?Q?3iDseSwkOBKA4zr70uHx2X7TKIhJTa0oh3P8I1V7MEmL36+eIz8nxlkyv8cg?=
 =?us-ascii?Q?TTmuWxZzoPf27PN4Kx4CLGAmsu1u6qfjy1qbVylfWsbUUv5pDqshpaMAkkm8?=
 =?us-ascii?Q?K/XctstJY5h1nHt7+fbWLuumiuK5nIl+gLUE3JdybPLeRWAkBBf3hArRghfi?=
 =?us-ascii?Q?p2taFzscsSNKgTdTAFpiHD7q0dn8iinzr9HR+IZ6n20WX+OwyC+eFg1yzOWh?=
 =?us-ascii?Q?VRZBtVl6bZSPl90LLmATp2xA5gJCZVnKvoC9t6LDLCoEioExKbhOOep/9y2Y?=
 =?us-ascii?Q?Kb2N4Htu1wIH75xRsmhFSjWDumgwXKPE6uzIr45XaHHtj3RlubnVjRU2o8mh?=
 =?us-ascii?Q?pX3gLKC3kBiaUI3oMIoWSKJkPbV0gFBqXrDezXvKunP0S8D1crKOXWL/LPW3?=
 =?us-ascii?Q?Q/eNbH7iMA18UVzC+IWB6nYISOpClRk2mHucAXmBljKp9kvGgk2nNJCeA/4w?=
 =?us-ascii?Q?10K8nfKUyU+Hzz5QBP/J8yVeHWPI6TtN5AGmpL3LxraDHQbu2/Y9iV3DVIYc?=
 =?us-ascii?Q?njcCv1qSSGY0HGgocpq+3UFdZmuG15uhugBb4dTvIVyhgGk51ihmM31LG4Fi?=
 =?us-ascii?Q?PLjbFOFZJJpuYtqou9kHzo4SgOnydyz+M9qiZS1CEQPJOQpbFxDXs/iRMOCk?=
 =?us-ascii?Q?ZFSxZHtVPluvO4iOzy6wP/ZXhwiFuue4A+IqOWYy84oxXTxv3vGW4y1X/eax?=
 =?us-ascii?Q?mHWUFhVxs0qJQiqNyd3etM9sQT2g7EYYbX2LnM8wCahD2P0gZbwrR4Q8f92+?=
 =?us-ascii?Q?gf8CsH57rZM0k16c3RJ8jBSURiyK/At9sghsdEwwgXXh6puEoAcioD8qGwoT?=
 =?us-ascii?Q?7BD2Z/XJJpB6j5MdZE4cLDwhbyq0PeoZEGxrP9OonCA+3g6JoFM4Vr/REopx?=
 =?us-ascii?Q?eDWx9aA+HlOdyodqGsKESAGJod4YlooUzlWk8cMV/dBetCpfRPyy2UvXd1MQ?=
 =?us-ascii?Q?CEjHLCUohpvMOMaqqPMurnF9BESlNemIiZK4p0F59W11gFW9kFyvWmXtE3uj?=
 =?us-ascii?Q?/dnGtDDd74+hQrYTRanEAm60HI4cV8Te9L2IPpmvz+IlIUUDEuj01DoPU8fB?=
 =?us-ascii?Q?QqACG5AwoZCjH6wwmeQSuv8v1ttnMHfM54PYts+reUqKho0shAdtE3CWwCcN?=
 =?us-ascii?Q?857O9+XmQm3L4QcvWm5g7OU7Vp4gdgG84EuOflybE3XAnxKnIn1NSy1qx3DA?=
 =?us-ascii?Q?m8N/o5nayXb9ccQ4tKGkWmst?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b62a6d2-b9ea-4d03-8bf4-08d97cf903da
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 12:12:00.4713
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hk1f0swhUb6YMC6kttld7gGfpA5cl+gfsrCcagrMCtoFf42irXQBZeAmBu8RkCUn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Without this call an xarray entry is leaked when the vfio_ap device is
unprobed. It was missed when the below patch was rebased across the
dev_set patch. Keep the remove function in the same order as the error
unwind in probe.

Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Tony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

v3:
 - Keep the remove sequence the same as remove to avoid a lockdep splat
v2: https://lore.kernel.org/r/0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com/
 - Fix corrupted diff
v1: https://lore.kernel.org/r/0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com/

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 118939a7729a1e..623d5269a52ce5 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -361,6 +361,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
 	mutex_lock(&matrix_dev->lock);
 	list_del(&matrix_mdev->node);
 	mutex_unlock(&matrix_dev->lock);
+	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 err_dec_available:
 	atomic_inc(&matrix_dev->available_instances);
@@ -376,9 +377,10 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
 	mutex_lock(&matrix_dev->lock);
 	vfio_ap_mdev_reset_queues(matrix_mdev);
 	list_del(&matrix_mdev->node);
+	mutex_unlock(&matrix_dev->lock);
+	vfio_uninit_group_dev(&matrix_mdev->vdev);
 	kfree(matrix_mdev);
 	atomic_inc(&matrix_dev->available_instances);
-	mutex_unlock(&matrix_dev->lock);
 }
 
 static ssize_t name_show(struct mdev_type *mtype,

base-commit: 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f
-- 
2.33.0

