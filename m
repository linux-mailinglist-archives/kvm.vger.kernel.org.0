Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2E13D0F29
	for <lists+kvm@lfdr.de>; Wed, 21 Jul 2021 15:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbhGUMZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jul 2021 08:25:15 -0400
Received: from mail-mw2nam08on2069.outbound.protection.outlook.com ([40.107.101.69]:30886
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231791AbhGUMZO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jul 2021 08:25:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCoQiZn5yGm1SQEF+z0nGTFxmXb/XFAmfkaMStsumVSKLDaCC0QGHuQ+80BlmiqzilgCszDS7f5ADQ6XZWQfO8tAVAmwq8szEVbiGQHnGeVusUmcRZZ60ghJU7rvvCJ1vUkEUWFzeArRVHQAg7D+5wJ1HNCcx/Cv3ceMi3o5eclxF90D7OfccXKIplX+iL7ZQlpGvg+P0F3JW8DZbJI6rXSFv+WpuBiMHKUGr5udp1WpzzA7YovAcW4E9T23MsGw5/Gh54Zj9yMQBjBd65NLMvRoCz+naac9z1VfRSxo71SqAvFzCL3zLEbatATLY+0I/EdvL3ZKhkRFGWMC0Q7tOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPA4frCsZCUdPF1lgc65MmG0CfE/dkXXHE01k9kbDYE=;
 b=Ee9B08lmryaihnuDw905Rlby8SqrdX21Qg9quqClEIXtlmkkdEHxeQCucm6Th20XPkB5VQ19/HpUzZ9K7n3VbU+4rx9afnWA2cgUneWKAoTUBF6jHT+imlm1eDhPhbBIaglKZNnx5I5eUpGJrWV+iqHiYBIZq3rlz4cdukhu4JDhSaQ0EQ1Zb933XB/6WmiT11HkJ4vCD6FY0IRyhiaKYXoPtlsyda6ifutS/ToS4tPKQAi6OAxEW8mEEsr5pq7ElBz31KT0fwT359WSPmA45ZrbJtqctsI1yyRC2E6QDPu3HzAmGsY4vpCQd9/qPI9Cu7qswhVtm0Gu0g8NfbT4nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPA4frCsZCUdPF1lgc65MmG0CfE/dkXXHE01k9kbDYE=;
 b=hXYoaGsau2r6+9S0VWZ6dVp1hkkJGva6gEZQI9IxQ3alr2X2NEog2QTJQhuuRSSr3QqntTlgTdFja5gQoaEniNDZvXcCAO+dOTbLdiNlCwI6x62/lZf1qR+HiaBJGEgJ0tfVXYucKigEGeibc55L4cWQiHN1uPT5FlmtFL74hAKqJ+l1KGF5+4EE/ImAQu2nggWVLRRlMDXrY/sJrKTUwzEsCv7GgULckfyKgCjgWfwn+N5dRaN1ESdNGp0KjajybwAVWKAHTXQgt0lBqW2H1qX5dzPUTZLNdKNmfuJC0oxvTIKyCCIe97p42r3qFfHfebMplxH9IMskGdHnS7MDpQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5553.namprd12.prod.outlook.com (2603:10b6:208:1c9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24; Wed, 21 Jul
 2021 13:05:49 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%4]) with mapi id 15.20.4352.025; Wed, 21 Jul 2021
 13:05:49 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v3] vfio/pci: Make vfio_pci_regops->rw() return ssize_t
Date:   Wed, 21 Jul 2021 10:05:48 -0300
Message-Id: <0-v3-5db12d1bf576+c910-vfio_rw_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:208:2d::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR03CA0003.namprd03.prod.outlook.com (2603:10b6:208:2d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 13:05:49 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m6Bv2-005Yol-QK; Wed, 21 Jul 2021 10:05:48 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ec5c206-a4d1-40b0-3873-08d94c484319
X-MS-TrafficTypeDiagnostic: BL0PR12MB5553:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5553CA5F936A1E12E224F0A7C2E39@BL0PR12MB5553.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:469;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MIGyPCbjSb9BJcSoJL9GIOnUxUbqE0cYk9MFDIBCiKIyKjaY0v4i4H+6aIPm/ttoM0Jyb7J0rRPLQBXGCQisaHPN4m3Qt/yznP3zvlnIjt3ci/7MNor6kUL5EG4Wmq0VhmtQHyNcKjbun7G2ptrUiFbUlO9J6z2HoNvRCAz4UiaUqiXu6QX51ehjkliD+8RsYbWwnBshopBgmKShU+LxnhKFnW8ul7ZsP1QeJNHCQt4Ddr/k3C5WZY6931P8Wp+pVW+YjzP8zAf5Duu0Cp9fICCtJIolsb9BH70swjy12nJihmKrB/amzrNL117e+Wj4XNGDHE/lwYqm8RlfsEDZNGeEaRu+goVWAWNqWsKI7/iY4SG/wkrXRaT9d3RL9U3NYYEVhK/LDvu4ktM1SDEL4LipIkEYgcgQ0gpggzrgfSyUjQGC/wmULoxR6gIcNapPjNRGzmK6LwyWFWa4luxkV05KvGaz1j1s0/RGfhkygJWJjU/nWB++L813XQHxIJ9DHmiVbp8yJzaZS3aIRqPQRDDGdkoNc27rgj8S8eQSBgG++UmOoDqSd1/V65RC1KnK/P3s95ePBBRNPZSl9KK3qN2ECHehDaxeaNsHfRV2uYINxEBawQgDEF0ScuUWT3SXniTHLUFOXvk+Xe/sj2bNheiprKFrPgD4m4LjT7hyh/4qaJqiwYE5dEvP0PtG6VNP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(2616005)(86362001)(36756003)(8676002)(8936002)(508600001)(66946007)(66556008)(66476007)(54906003)(83380400001)(9746002)(38100700002)(316002)(186003)(26005)(426003)(9786002)(4326008)(2906002)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G4mqn137HuFg250oPi5G6NVY83SHP0e5DFrDtfgeXGqJpZlIu3R8aLFUi3L+?=
 =?us-ascii?Q?QRR5UZXOCAZm+FXakmttf2/XydbCZ7LrrKCm7BfgEjWlcc98VDKidOPnzYOF?=
 =?us-ascii?Q?dAndzP7qv07WxG5ZDMonSOUXqCIrohjOjxPVjxix2WyxS/X5qOTi2FVI3XXs?=
 =?us-ascii?Q?SgqD2HoQE84JzJkznJg9+d/b6PKGRrbvcdFRvdjxYvIPG5TsVeDlK/+cqXv5?=
 =?us-ascii?Q?iZkZwZhC3ZKelLi/grqkMxUV1NaSPY8DecrHAUYt9Vy7EBJDdD3hu1MalGjh?=
 =?us-ascii?Q?DBp/ZORmRrOvkmhmpGbQeLEE41ZI2Iq+/e/yRVS9kt5Gu7HvazyqlKPpbQCO?=
 =?us-ascii?Q?lCLFBWtKY6JtTe1T4BNVwYQuP2XMK86vQDtiz8U7kClt0UL0KcjwmtRvl+1T?=
 =?us-ascii?Q?LMIsHa5Si1YjiURfPgqCwNRu/zGmlNOFkLVy7N85GGH1gnKR2CKkc6Q57VqT?=
 =?us-ascii?Q?ecjS4eUfh1aGQ1G+gWNxD/atB9nz+NxjNOaBGZGIrl+tx8vLK/JDqUOSULCm?=
 =?us-ascii?Q?jK299DDqfil5d22B0Dkvz4Xd4D+KrdWbmnaMT5imy1PlhVMAMtm0NEYqiSEc?=
 =?us-ascii?Q?fVT4++1niBPqLPCmCFueb2q0K0vjLLHH2WvImWmTi++PvwBbAkXvLi+4PNoA?=
 =?us-ascii?Q?8yuAVk7pFRahljyU4e8oDVBAgBoiFGY9Y6+qBQu29CUfo8Yjredq8zLL66Qk?=
 =?us-ascii?Q?i5Q/E5127DEn5hPYkSy3zGJWE35nXKGyvNuKu7UtUOaTgKGC+s41qnkaSEL4?=
 =?us-ascii?Q?Z6ps/mp89Er/AL/rZmI2jquTEv9HilkA2gbwWDazi6nUgfMgiBH1dtmaWQyU?=
 =?us-ascii?Q?ZCtzgkdHlvMhGIaDSpz2Sd5lWwXGUEL9wMIjg/2WW17WTsYzjBhX8oE1QzPT?=
 =?us-ascii?Q?jyGYDQHsGggvekIKnpPQrFUHay2KHYH8fjdYKBH1N1rCNqOJmBCUyMHuveuF?=
 =?us-ascii?Q?8b64RTYTOR1I/9v1clXB9auIiSVeEXxLZaMuzmCMUCOQYnUhPDZMCrJ03JfH?=
 =?us-ascii?Q?D0DZSu0g3Fu41G5tEewM0b3+XepBsfPps2af0Wrt1VUirhh1+B92SG9lDc7K?=
 =?us-ascii?Q?kNMQp+WC9RUNjsBVbVcKXVs6x6jwFjLtAZn6VSKdodCTXq55xtdgr2AlPg8F?=
 =?us-ascii?Q?bq4kMJMKmNDIECKuJPuSvmhBwFDK/4cRNX+fbT6S+uGvKIQbtqsASS83yc10?=
 =?us-ascii?Q?x7QKSm3KXJXdlE+DGLwQhZRndpAYKUX7k8AobtfuLkm6jNGsR5af8S3n3BzQ?=
 =?us-ascii?Q?XEZNQsm+fYPCR0YSnHFPo5rzwgSaZHW4Bl/cy7lQi6lVpcay8ITsLuMx9LCk?=
 =?us-ascii?Q?NVWt6P/spo+JoU3q6k3JBUIG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ec5c206-a4d1-40b0-3873-08d94c484319
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 13:05:49.8132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hzh/a+b/YKDcQfMsWAAG2hgMI7aCbyu4PvsHT9co66Sgj/l6cRetM3kLqqR22MwQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5553
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

The only implementation of this in IGD returns a -ERRNO which is
implicitly cast through a size_t and then casted again and returned as a
ssize_t in vfio_pci_rw().

Fix the vfio_pci_regops->rw() return type to be ssize_t so all is
consistent.

Fixes: 28541d41c9e0 ("vfio/pci: Add infrastructure for additional device specific regions")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_igd.c     | 10 +++++-----
 drivers/vfio/pci/vfio_pci_private.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

v3:
 - Fix commit subject and missing signed-off-by

diff --git a/drivers/vfio/pci/vfio_pci_igd.c b/drivers/vfio/pci/vfio_pci_igd.c
index 228df565e9bc40..aa0a29fd276285 100644
--- a/drivers/vfio/pci/vfio_pci_igd.c
+++ b/drivers/vfio/pci/vfio_pci_igd.c
@@ -25,8 +25,8 @@
 #define OPREGION_RVDS		0x3c2
 #define OPREGION_VERSION	0x16
 
-static size_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
-			      size_t count, loff_t *ppos, bool iswrite)
+static ssize_t vfio_pci_igd_rw(struct vfio_pci_device *vdev, char __user *buf,
+			       size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
 	void *base = vdev->region[i].data;
@@ -160,9 +160,9 @@ static int vfio_pci_igd_opregion_init(struct vfio_pci_device *vdev)
 	return ret;
 }
 
-static size_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
-				  char __user *buf, size_t count, loff_t *ppos,
-				  bool iswrite)
+static ssize_t vfio_pci_igd_cfg_rw(struct vfio_pci_device *vdev,
+				   char __user *buf, size_t count, loff_t *ppos,
+				   bool iswrite)
 {
 	unsigned int i = VFIO_PCI_OFFSET_TO_INDEX(*ppos) - VFIO_PCI_NUM_REGIONS;
 	struct pci_dev *pdev = vdev->region[i].data;
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 5a36272cecbf94..bbc56c857ef081 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -56,7 +56,7 @@ struct vfio_pci_device;
 struct vfio_pci_region;
 
 struct vfio_pci_regops {
-	size_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
+	ssize_t	(*rw)(struct vfio_pci_device *vdev, char __user *buf,
 		      size_t count, loff_t *ppos, bool iswrite);
 	void	(*release)(struct vfio_pci_device *vdev,
 			   struct vfio_pci_region *region);
-- 
2.32.0

