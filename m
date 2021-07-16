Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18CB3CBBEE
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhGPSmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 14:42:12 -0400
Received: from mail-bn8nam11on2079.outbound.protection.outlook.com ([40.107.236.79]:26721
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229462AbhGPSmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 14:42:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B42mEX5h+d2B48JCRBYMVWh7eNBx3r4ypphIT+6AVAzfO1Cwqi0DOnUij4BGdtyvijGoVotcZHTIQ6WfSARJuK1DxNtN1zNcJksfBUCLcw+d3REs/PCOm0CZnnHXE4pGdOIA3eBDtYlfCrGddCRmmC15aEhe2BsOt5DUVcdUpR+X6/QOr3Ms+KHwqxVbF9dBIEgAARe1al17rKxhEg4TgdrA2H3rSH2O6zfLFtLpvQkWGUhIJdnx6ntQNzVB8jtD/H6BFQeu+AM/XZ4tRwGevkm0iQq6Ic7EZDYyYS+C5WlQBE/rWq0/r9R0bIoI8eZYQVN1uvKn8LrvndWTDYGmvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Sk++40m69fQNAvhh6d39fkwcQYWu0fOS/xzbYliBtE=;
 b=lhIYiAgbMFSY8r42N4QZx4rK2+OH4w+WhWUEgN6yoMNeHXtcSNO/i2GYey9YFQ01mLPW0YRFvZqgWYpdBr+chCOzWbPGnvHJKCAohmDCbbalAvtVJkimn4RIq4N3AJNNN33fzUEp7Q2TgHT4hWvWT2dggS6pVI0rcjoGFtlwsoRqYO1w+i1+VftWfORvefxYyCqnWoAqZInvbY8U1OoOf0ad/hlZ6C+gDkURZRgpvqytiUgqiR3OpFuhVvOGx10sU1cW2dwEsBPqIPf8dvVgtRQr+uJ2XojzTH+ws+q0+k27fBF8eGrKM18f8D6mp1DArjirHWXzcPw/3+hycj4VlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Sk++40m69fQNAvhh6d39fkwcQYWu0fOS/xzbYliBtE=;
 b=a+4PJJ1mJOs/MdSlV+kjPso1T+kZNN+Zzh7qVwqVsa6Dste+v98wviAKnha6hb2NNaCZbrs1gFq0S0AAtrAsGsWbRIYzqlTcBetuRdwmMtGJgfs3NGOTpFu5p1sHHFog6pK2drR40k09aVZoTR9T4xbxnXYe60LAsUW/ihuDor5m3GP+hfl5f1w+WfcOQELjDDqFMjOm7P18K4N13IXECVVTtP2N49VfCIX6IQ3Nx1VwnQXRIuBANqHbXRfPvC0VRgcbgr6uaJv9XrEOmYmyysSFKmpDyursQBv3RTu182hUte14FAukKf88rq+oUGT1X47/IA6dYGWyJEt+OEzwfQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 18:39:13 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 18:39:13 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] vfio: Use config not menuconfig for VFIO_NOIOMMU
Date:   Fri, 16 Jul 2021 15:39:12 -0300
Message-Id: <0-v1-3f0b685c3679+478-vfio_menuconfig_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR10CA0028.namprd10.prod.outlook.com
 (2603:10b6:208:120::41) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR10CA0028.namprd10.prod.outlook.com (2603:10b6:208:120::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 18:39:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m4Sjw-003PHT-4C; Fri, 16 Jul 2021 15:39:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7341575-0143-4aa3-9232-08d9488901ef
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362EEA1FE032650D324CF10C2119@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 43YMF64cnbBVVU2bvv9bESu9eeOPguYkaCM7UFSFqNKjhjBRdAIF5aIxFi1hNQm5ef4YtBHgs+8PRwUdMWseDFHuEMEQCeW0lsIf6NEQ3OQ30Ejm9JHYPxyj4t+yLR7EwABzCcjzoP03nI7DXQoT4GvLOgZtztSLNNA44Lz6deTWc05BIyienNZNh2VwiR0UhrCIH9TO1cImTFlRIpw6mrZejEmElK5n1pPfbTTq+l5xWMzKjC3NsaoW172QRQ9EIIol0g2x0rRefiMso6zB3Ou9lpwikq/9tEC/Cwx3FUP1yGfAye7+KmlYYfrar24b1WXr23fuFhs84Lup21JC6EeGT44epzJrgKLqHi5ReskQvDy0DPMQd7Ntg+lZsWZyjL2JvVK/dM+pHs4oZBsEctjmdC9ZNdJo/iSKxhlZkSZl6MwXoemkOQvoVz1zM07NGWwDHZ8b8V7kV+RBYzMxpTZDs+9KLJcawjYlFmvwmHiabCdS2BD8C5FfCal+9MulDkgyzN93a5ZBqhTdfnFmjSpg7+JDReeGYBEJsSVEZpa2xdSXBs7DLNtDSFhym53wkgFfDezw+/P87GOEv4KAfh4nISt/uXtLhGBWzr/V9ckhL4t1JN+tvTgYLMNdY4UjzjMfvVPRo19E4SSOb3PUeF+6zXnB5dWOzJNMQMSFk2R57/QsKPEawfA3xrjZ/XMw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(66946007)(426003)(66476007)(2616005)(38100700002)(66556008)(86362001)(478600001)(8676002)(186003)(83380400001)(9746002)(316002)(9786002)(26005)(4744005)(8936002)(2906002)(110136005)(5660300002)(36756003)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UtNCJ4pJpwCClUD4AJJCnbN7md/5v91/bBYpXxCm9YtqoMi9a1A8cF0U5Ras?=
 =?us-ascii?Q?0kH8runaynrZfW+tAN1rzBTqUGYrLTUWoOqz9lenE3Pjk8bMiliWfhMwPUYY?=
 =?us-ascii?Q?VSbVRNfj5XEWEDUcDOHzdbSYsaNeW/xBP/wTcBaSdrV5C0KYk6opi+4O8s+p?=
 =?us-ascii?Q?CM0q5KE0uSvrFYVJz6GDGjra4H39MnAneJ4Rn2N90hMTAT7pcN3nhaoNmtSs?=
 =?us-ascii?Q?DkonP8HMe0ktl3ZwgfXyaEy/X6gnfayA8q6gpREAHoQsU5lW5I4UR1VxMo8O?=
 =?us-ascii?Q?TTsvQmzBP6pwtJmMycS+ZFFTCW9zgfCw7dvMqMZkW9dn2G5lqLDqbuEfLbPx?=
 =?us-ascii?Q?Inh61jdq4CAKY0Z6X1OmDzdtBGG3R4rUn0QnP5/HBH1I1cVlzgrBTRTCHXoi?=
 =?us-ascii?Q?cvWYS+HAWV0Z8SlrCQ05uMQpEAiFqBa4m+Y4GlpGCeFGv+hVfOsbqCPrO/OI?=
 =?us-ascii?Q?k1xbB7wFZwdvbt05JIrUUzODgmAOc++bse4DKwXwM8by3F+vOKXsq6jqL1/q?=
 =?us-ascii?Q?3Aw/SrRgH4OhFOch8KysYYrJhOsv7D8oIFbmXFo5jFerorH7OAefNd0DKeZl?=
 =?us-ascii?Q?6ptTynEamLfGiz64xf1i2yVnTwMMjgamAQdQAznHDKOwcWlSlyjfYXb0RWDc?=
 =?us-ascii?Q?rYfwK2b7m/+oGvz3JlgFJrjQBIn2uNxc1rIXO2Wj6iQnBfl3PZ2Ot1F+Cd53?=
 =?us-ascii?Q?dZPV3HG/RkSIpDoGLvhcG5qcfatkDMqFbrN4y4ACu5x3AXzsilpOvjjLpOm2?=
 =?us-ascii?Q?lFxTUg3MjD74pO0AYdIlLKAf4Mi3VVdJzmsYznxKuvAJ2RECsH3+FXKSMiRh?=
 =?us-ascii?Q?rlYOwrujpuWCGIsT46Xylf8+IwZ0dEqBL9GRy4vu1jB2PeRFsAPD2sCyujED?=
 =?us-ascii?Q?LJ6oLU3QyMKQq4VLB5WDPhgFAf+jnpOeVfJsrz1UnYOdPkTVs5CRw2Ifrw6g?=
 =?us-ascii?Q?r8gYHSWY+nCACGp9OOLmx6X2c4IEaoGGewQLNb3AL+U/uIjwo6kRV0yxiqRW?=
 =?us-ascii?Q?H2oFM+VBly9zpMbGnZ7m5cdSXBvXd5IBs7HYiu+5YF96bdk/jp4Wjmaj4r48?=
 =?us-ascii?Q?NHtAlJmFlg8URrjYtHKgeXxTomDsMKfST/BRp9/eFLQKL5daab9Fp2Dh1xwa?=
 =?us-ascii?Q?eH8NHDJ9pwPgEqLyggbPuvv/QzTopiDhrCIwhu+S6sAayRkD4wVDjuuPTNtr?=
 =?us-ascii?Q?1tTzZaoWQ9nW5PQk9od5Roo8psGgqtQXHdKsePJz8QAX4OctYaWgJgkQ70K3?=
 =?us-ascii?Q?Q0nrC3AnPbpSIQ3lvRJjOOon2Gi0czK5y8WcfykSL1GHXXGT1nnN+9FJn7xR?=
 =?us-ascii?Q?P9LHm+M+jLGW/v1+kGmltKZa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7341575-0143-4aa3-9232-08d9488901ef
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 18:39:13.1256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EX0K5esq/xCA0c7Kjuyo0gvWjzpTv4bQ+8HFrm7QybgartrLd6PuwJybmrpxk1mr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO_NOIOMMU is supposed to be an element in the VFIO menu, not start
a new menu. Correct this copy-paste mistake.

Fixes: 03a76b60f8ba ("vfio: Include No-IOMMU mode")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Just a minor loose patch to get out of the way

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 67d0bf4efa1606..e44bf736e2b222 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -29,7 +29,7 @@ menuconfig VFIO
 
 	  If you don't know what to do here, say N.
 
-menuconfig VFIO_NOIOMMU
+config VFIO_NOIOMMU
 	bool "VFIO No-IOMMU support"
 	depends on VFIO
 	help
-- 
2.32.0

