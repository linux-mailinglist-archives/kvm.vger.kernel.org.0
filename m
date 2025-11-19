Return-Path: <kvm+bounces-63642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C380FC6C31F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 01:57:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5472C3677FE
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 00:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F52F255E26;
	Wed, 19 Nov 2025 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="M/Chmop6"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010061.outbound.protection.outlook.com [40.93.198.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575EE23EABA;
	Wed, 19 Nov 2025 00:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763513583; cv=fail; b=qflDLvjOw4iRYjDdYeSFT+pk846j+b11rQK50lAxHC+HMz3UvXQW2P/z9aThCJ2Egl/bntkjkuR/0gpHxjg+dhnI73utcHCkc9Pl6nLeTELwi67EZNQ9h3DqFjYdHS3d65P56rEoSVEX2vwyNwVda+F7VCXMSAfoCyPbqGfphAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763513583; c=relaxed/simple;
	bh=sfxaRBp6IO4QwJzbH5/VqJZC7aPC2FlhuFyO+JCTM6Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cz5UPAHzbFzIldsygv39I8IwPH1m0uIb4BIflyo8eabxhFb/RVOb3wDSyrWtqbeVUCnb8iy7AVVvVDmPppzBFoyNRJiOM+1oklGReqYZbXzci6hJYaTPkMkJtqljH24UqWvugt8kMzBx4RTonfk3eg0xK7YUtUlp6cNGwHda5bQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=M/Chmop6; arc=fail smtp.client-ip=40.93.198.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q7PKLBR3DBXwI7JGNBV8qE54WToN2fOVLoKOBbEBUXz1mbmKSD3SYaJgqmAht2tLsI2QhIZNX/C+iEwNr6Gj1Y1Sn7F6twi8xkeZ9cPK6SrwzIYxZ+SWNz7gDCd4c4/9ToL0xNU2yxsilyiMWO65poTcx0jFE0sITmjB8/wPSk7AkLCVBPfCMfTE0Toh/Dq8mSiceO86VCRfFAhZ2napyjL3wdLfMfdF/47jklM7TShORlE7YrffYuQUgknW7d1JPjTGVEWLGNxoadyJdB5aYkL37OWarD5Eow13c/4M6G5muzYpEr2771d+PdW0HsxQgbGgpvTEfh7wpbYfrgvY0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P2RZoJeiO/wzYVN6aLSDXyB9pNixf6BEfx0QGkauHzg=;
 b=i+MkKfpeATrLm2GrMf68Xcu4QF+vifrrAy7uisjte36ji1mjgC3vWptclCP7CK5hQRW7Zkba9jnJ/fw1tOyqKicV56zb+Tv8rOZzXRVKTIMdbM2uufD5RrhznvfP1fCoVig+x2G0IQnSvS5L5RHyR5oYdTakBtYBQQGa3SKxBbUYl+mCzT5OKNAZWYAiGPx5t5TgriUKjqnI5J6bWM5Yal6Qy5H6tqXNEhP/rQSETvOnIByvI/JfSdESSTFtqHtzxEfyBGNTBTiIMfkE0W0C0yO5L91PcZokPSXCi4HNpx2E3oQ0b3u2JHRwPrELfR+9CsG0Ql33OCp8sF+atgSs6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=arm.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P2RZoJeiO/wzYVN6aLSDXyB9pNixf6BEfx0QGkauHzg=;
 b=M/Chmop6B19hthSxYbZ4BGq3XifhhckVaqGGrCc88AUuLmik8rlv/pF/qByxEQXZlOsi9RCE2b6cToLcycix7kMPAmn90uzk3b5IDy7XS5RNJiD2afo9xr1uIHLKqur+yW5/+fU48Aa1nCdI/jVqsSm/Q08Q72OO661dwKvKFlarH2NcjlphkwQKax8Q85aONWGo4s0AKlwHpSMgTnc8+xSpkBkH5kUYo9TggXuEs0/dBg7+/ewbKxGa+mooAjmAuEo1nWu/TpTbAmIFH2UEZdRj3wlXBSwz+Q0REjaLU9XjW4CpgVbJSSQfYg+Fww/uGrh2i/K4Tis50+jJKhjjTg==
Received: from BL1PR13CA0079.namprd13.prod.outlook.com (2603:10b6:208:2b8::24)
 by DM4PR12MB7742.namprd12.prod.outlook.com (2603:10b6:8:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.23; Wed, 19 Nov
 2025 00:52:53 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:208:2b8:cafe::7e) by BL1PR13CA0079.outlook.office365.com
 (2603:10b6:208:2b8::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.10 via Frontend Transport; Wed,
 19 Nov 2025 00:52:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Wed, 19 Nov 2025 00:52:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:31 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 18 Nov
 2025 16:52:30 -0800
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Tue, 18 Nov 2025 16:52:29 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: <robin.murphy@arm.com>, <joro@8bytes.org>, <afael@kernel.org>,
	<bhelgaas@google.com>, <alex@shazbot.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <will@kernel.org>, <lenb@kernel.org>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
Subject: [PATCH v6 4/5] iommu: Introduce pci_dev_reset_iommu_prepare/done()
Date: Tue, 18 Nov 2025 16:52:10 -0800
Message-ID: <246a652600f2ba510354a1a670fa1177280528be.1763512374.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1763512374.git.nicolinc@nvidia.com>
References: <cover.1763512374.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|DM4PR12MB7742:EE_
X-MS-Office365-Filtering-Correlation-Id: 70a0411c-bb56-4ef9-093b-08de2705f8aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eiUQ4DOeHZUFqsO2pOXbfTYU3YZY+2iUaDMedQ/saealC91S/gxy6RHWr74s?=
 =?us-ascii?Q?k0BvbDiDVsSR4kGRM/03wrrpCz1hjkuUg6k7kGPuNvofXSq72iO1cPaU9Kde?=
 =?us-ascii?Q?8/VRUDjF/9jkGbjOvAiEmM/ENN0bLa00q5ca3WskowYlsPBUeyuAuOoosHfT?=
 =?us-ascii?Q?6SRQWqOTWWDBaxqsQD77NfKUbSHxWXDR+WmLM9a3or9ytVAPzbcnE5SPmvu6?=
 =?us-ascii?Q?+X5SA9jcCmSsoWUCs8IXm2faak4RRvpzryLfBIZwXpkTw+MJlpDGSagWaV5a?=
 =?us-ascii?Q?wNyzf6bvPguVww+pUROGeQ4gZGkgDm/3xi2Fv7IA6YqrvpSB5Jy/r4mhncrk?=
 =?us-ascii?Q?9eRtcTyqIlbKOlVDE5+n02+akkOC8egkPA5qi39zsUewDMyVCEgGpiAtAp4D?=
 =?us-ascii?Q?bjB9SueeatdINmM1LRisGPU/dvQgJOgJTxyIsJBTfRD+2fHkmT+t/EuUlYZl?=
 =?us-ascii?Q?hjeue7dKtXhOqFzvcfu8rcDrU3n8GmmnvCoxDNBRAfHfDKZyXQPUMehxB2bL?=
 =?us-ascii?Q?jzoOOTVmYM5KaLRKap9ndbA9p6qqpZAELzRVTaInZY2tBQ5V84MS39JW7+Fa?=
 =?us-ascii?Q?SOHynYuj+ZUmZiqVXpwS81mgW655PT6OEAUS8jf8LnQPTPcOV0l9qRbloV5J?=
 =?us-ascii?Q?GdDfI1Tz7oxgNDM97VjKJdkk6lse4zpYSeLFXi97uYhxc/WvaaGVrA3dzXpb?=
 =?us-ascii?Q?puppwCn1T+JH5eRb8G4q2lSSd7q9BPB5lvyQmTavL3LapKpY3wWhcvW3SN7s?=
 =?us-ascii?Q?WnESSM/LANrF+malC/YZCTGnIW1g1xIUaL8ZgTwEjwfnxsNwKtjtOfyVFinK?=
 =?us-ascii?Q?jhDm6NIUO9S2QnovrFis6FSTC43LHLfzSbBMOgnqLL5FcWQM7Mmppt4u57Hg?=
 =?us-ascii?Q?d8HMtZo4Oz3Zm3nGLOBaM8iB0rGQAt1afvaBvP2Aqe+avuT5g5jnA1VQYRur?=
 =?us-ascii?Q?+wUq78q2XcJnHXue7MOJqXR5N8vJAzPYEP2jCLREl7qKd58TzcxtEQZXQXN2?=
 =?us-ascii?Q?lOumhydg1hHcd3M/W3Ex6nTJIt8Qc29ELu9BJ7mHViUahwIVJ0Uou5ESXRJU?=
 =?us-ascii?Q?D2O7IX6EmCGwp3Q8LMDFuVqsHqI6oeC3eDUUjktKYofdlGZFv+OdwxVJkKrF?=
 =?us-ascii?Q?XB1JKk4Rvbxv+cWdD10+FqDGnVcd7fYuJehgsFCoqJR5xXceGSWqLuw5Huan?=
 =?us-ascii?Q?cHQLi0rpNuf8iplOZe67/OnpLsZ0xXuDtHGxDT2jF5xmM/us3jB22vEQ+hoc?=
 =?us-ascii?Q?JvlyTkhAnNlUAmNk3/UkykDiaBpXG+vpn8JLtfnvaHOQrTxA+2l1RI4YADsE?=
 =?us-ascii?Q?Kqc3MFcfkdGtMQW4rM2kcRu9ER+kFF+6WM1zLPdSEi5yNj6B+99dTaQf0yzW?=
 =?us-ascii?Q?LeK2Ne0Wg/EwFf2L9gYidxuvkB4n3fw92v41fHlx5Ex1/YIY//Nl3KRUTa2W?=
 =?us-ascii?Q?ung4+hhPxCmzoS229eZjEHLulrTfmMQ6h4b2olDQquqE1zsxYqX8LG3S3ViJ?=
 =?us-ascii?Q?nZYXH/K/U1HH1drBBeVixCEWxXkgtBICiSkqwF3UGmPQkZvisJ7qBBba0fwr?=
 =?us-ascii?Q?Wo1GQXJjCiORZHYYx+E=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 00:52:53.1093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a0411c-bb56-4ef9-093b-08de2705f8aa
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7742

PCIe permits a device to ignore ATS invalidation TLPs while processing a
reset. This creates a problem visible to the OS where an ATS invalidation
command will time out. E.g. an SVA domain will have no coordination with a
reset event and can racily issue ATS invalidations to a resetting device.

The OS should do something to mitigate this as we do not want production
systems to be reporting critical ATS failures, especially in a hypervisor
environment. Broadly, OS could arrange to ignore the timeouts, block page
table mutations to prevent invalidations, or disable and block ATS.

The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends SW to disable and
block ATS before initiating a Function Level Reset. It also mentions that
other reset methods could have the same vulnerability as well.

Provide a callback from the PCI subsystem that will enclose the reset and
have the iommu core temporarily change all the attached RID/PASID domains
group->blocking_domain so that the IOMMU hardware would fence any incoming
ATS queries. And IOMMU drivers should also synchronously stop issuing new
ATS invalidations and wait for all ATS invalidations to complete. This can
avoid any ATS invaliation timeouts.

However, if there is a domain attachment/replacement happening during an
ongoing reset, ATS routines may be re-activated between the two function
calls. So, introduce a new resetting_domain in the iommu_group structure
to reject any concurrent attach_dev/set_dev_pasid call during a reset for
a concern of compatibility failure. Since this changes the behavior of an
attach operation, update the uAPI accordingly.

Note that there are two corner cases:
 1. Devices in the same iommu_group
    Since an attachment is always per iommu_group, this means that any
    sibling devices in the iommu_group cannot change domain, to prevent
    race conditions.
 2. An SR-IOV PF that is being reset while its VF is not
    In such case, the VF itself is already broken. So, there is no point
    in preventing PF from going through the iommu reset.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 include/linux/iommu.h     |  13 +++
 include/uapi/linux/vfio.h |   4 +
 drivers/iommu/iommu.c     | 173 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a42a2d1d7a0b7..364989107aca7 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1186,6 +1186,10 @@ void iommu_detach_device_pasid(struct iommu_domain *domain,
 			       struct device *dev, ioasid_t pasid);
 ioasid_t iommu_alloc_global_pasid(struct device *dev);
 void iommu_free_global_pasid(ioasid_t pasid);
+
+/* PCI device reset functions */
+int pci_dev_reset_iommu_prepare(struct pci_dev *pdev);
+void pci_dev_reset_iommu_done(struct pci_dev *pdev);
 #else /* CONFIG_IOMMU_API */
 
 struct iommu_ops {};
@@ -1509,6 +1513,15 @@ static inline ioasid_t iommu_alloc_global_pasid(struct device *dev)
 }
 
 static inline void iommu_free_global_pasid(ioasid_t pasid) {}
+
+static inline int pci_dev_reset_iommu_prepare(struct device *dev)
+{
+	return 0;
+}
+
+static inline void pci_dev_reset_iommu_done(struct device *dev)
+{
+}
 #endif /* CONFIG_IOMMU_API */
 
 #ifdef CONFIG_IRQ_MSI_IOMMU
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 75100bf009baf..4aee2af1b6cbe 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -963,6 +963,10 @@ struct vfio_device_bind_iommufd {
  * hwpt corresponding to the given pt_id.
  *
  * Return: 0 on success, -errno on failure.
+ *
+ * When a device is resetting, -EBUSY will be returned to reject any concurrent
+ * attachment to the resetting device itself or any sibling device in the IOMMU
+ * group having the resetting device.
  */
 struct vfio_device_attach_iommufd_pt {
 	__u32	argsz;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 672597100e9a0..0665dedd91b2d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -61,6 +61,11 @@ struct iommu_group {
 	int id;
 	struct iommu_domain *default_domain;
 	struct iommu_domain *blocking_domain;
+	/*
+	 * During a group device reset, @resetting_domain points to the physical
+	 * domain, while @domain points to the attached domain before the reset.
+	 */
+	struct iommu_domain *resetting_domain;
 	struct iommu_domain *domain;
 	struct list_head entry;
 	unsigned int owner_cnt;
@@ -2195,6 +2200,15 @@ int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
 
 	guard(mutex)(&dev->iommu_group->mutex);
 
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 *
+	 * Note that this might fail the iommu_dma_map(). But there's nothing
+	 * more we can do here.
+	 */
+	if (dev->iommu_group->resetting_domain)
+		return -EBUSY;
 	return __iommu_attach_device(domain, dev, NULL);
 }
 
@@ -2253,6 +2267,17 @@ struct iommu_domain *iommu_driver_get_domain_for_dev(struct device *dev)
 
 	lockdep_assert_held(&group->mutex);
 
+	/*
+	 * Driver handles the low-level __iommu_attach_device(), including the
+	 * one invoked by pci_dev_reset_iommu_done() re-attaching the device to
+	 * the cached group->domain. In this case, the driver must get the old
+	 * domain from group->resetting_domain rather than group->domain. This
+	 * prevents it from re-attaching the device from group->domain (old) to
+	 * group->domain (new).
+	 */
+	if (group->resetting_domain)
+		return group->resetting_domain;
+
 	return group->domain;
 }
 EXPORT_SYMBOL_GPL(iommu_driver_get_domain_for_dev);
@@ -2409,6 +2434,13 @@ static int __iommu_group_set_domain_internal(struct iommu_group *group,
 	if (WARN_ON(!new_domain))
 		return -EINVAL;
 
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain)
+		return -EBUSY;
+
 	/*
 	 * Changing the domain is done by calling attach_dev() on the new
 	 * domain. This switch does not have to be atomic and DMA can be
@@ -3527,6 +3559,16 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	for_each_group_device(group, device) {
 		/*
 		 * Skip PASID validation for devices without PASID support
@@ -3610,6 +3652,16 @@ int iommu_replace_device_pasid(struct iommu_domain *domain,
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+
+	/*
+	 * This is a concurrent attach during a device reset. Reject it until
+	 * pci_dev_reset_iommu_done() attaches the device to group->domain.
+	 */
+	if (group->resetting_domain) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	entry = iommu_make_pasid_array_entry(domain, handle);
 	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL,
 			  XA_ZERO_ENTRY, GFP_KERNEL);
@@ -3867,6 +3919,127 @@ int iommu_replace_group_handle(struct iommu_group *group,
 }
 EXPORT_SYMBOL_NS_GPL(iommu_replace_group_handle, "IOMMUFD_INTERNAL");
 
+/**
+ * pci_dev_reset_iommu_prepare() - Block IOMMU to prepare for a PCI device reset
+ * @pdev: PCI device that is going to enter a reset routine
+ *
+ * The PCIe r6.0, sec 10.3.1 IMPLEMENTATION NOTE recommends to disable and block
+ * ATS before initiating a reset. This means that a PCIe device during the reset
+ * routine wants to block any IOMMU activity: translation and ATS invalidation.
+ *
+ * This function attaches the device's RID/PASID(s) the group->blocking_domain,
+ * setting the group->resetting_domain. This allows the IOMMU driver pausing any
+ * IOMMU activity while leaving the group->domain pointer intact. Later when the
+ * reset is finished, pci_dev_reset_iommu_done() can restore everything.
+ *
+ * Caller must use pci_dev_reset_iommu_prepare() with pci_dev_reset_iommu_done()
+ * before/after the core-level reset routine, to unset the resetting_domain.
+ *
+ * Return: 0 on success or negative error code if the preparation failed.
+ *
+ * These two functions are designed to be used by PCI reset functions that would
+ * not invoke any racy iommu_release_device(), since PCI sysfs node gets removed
+ * before it notifies with a BUS_NOTIFY_REMOVED_DEVICE. When using them in other
+ * case, callers must ensure there will be no racy iommu_release_device() call,
+ * which otherwise would UAF the dev->iommu_group pointer.
+ */
+int pci_dev_reset_iommu_prepare(struct pci_dev *pdev)
+{
+	struct iommu_group *group = pdev->dev.iommu_group;
+	unsigned long pasid;
+	void *entry;
+	int ret;
+
+	if (!pci_ats_supported(pdev) || !dev_has_iommu(&pdev->dev))
+		return 0;
+
+	guard(mutex)(&group->mutex);
+
+	/* Re-entry is not allowed */
+	if (WARN_ON(group->resetting_domain))
+		return -EBUSY;
+
+	ret = __iommu_group_alloc_blocking_domain(group);
+	if (ret)
+		return ret;
+
+	/* Stage RID domain at blocking_domain while retaining group->domain */
+	if (group->domain != group->blocking_domain) {
+		ret = __iommu_attach_device(group->blocking_domain, &pdev->dev,
+					    group->domain);
+		if (ret)
+			return ret;
+	}
+
+	/*
+	 * Stage PASID domains at blocking_domain while retaining pasid_array.
+	 *
+	 * The pasid_array is mostly fenced by group->mutex, except one reader
+	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
+	 */
+	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
+		iommu_remove_dev_pasid(&pdev->dev, pasid,
+				       pasid_array_entry_to_domain(entry));
+
+	group->resetting_domain = group->blocking_domain;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(pci_dev_reset_iommu_prepare);
+
+/**
+ * pci_dev_reset_iommu_done() - Restore IOMMU after a PCI device reset is done
+ * @pdev: PCI device that has finished a reset routine
+ *
+ * After a PCIe device finishes a reset routine, it wants to restore its IOMMU
+ * IOMMU activity, including new translation as well as cache invalidation, by
+ * re-attaching all RID/PASID of the device's back to the domains retained in
+ * the core-level structure.
+ *
+ * Caller must pair it with a successful pci_dev_reset_iommu_prepare().
+ *
+ * Note that, although unlikely, there is a risk that re-attaching domains might
+ * fail due to some unexpected happening like OOM.
+ */
+void pci_dev_reset_iommu_done(struct pci_dev *pdev)
+{
+	struct iommu_group *group = pdev->dev.iommu_group;
+	unsigned long pasid;
+	void *entry;
+
+	if (!pci_ats_supported(pdev) || !dev_has_iommu(&pdev->dev))
+		return;
+
+	guard(mutex)(&group->mutex);
+
+	/* pci_dev_reset_iommu_prepare() was bypassed for the device */
+	if (!group->resetting_domain)
+		return;
+
+	/* pci_dev_reset_iommu_prepare() was not successfully called */
+	if (WARN_ON(!group->blocking_domain))
+		return;
+
+	/* Re-attach RID domain back to group->domain */
+	if (group->domain != group->blocking_domain) {
+		WARN_ON(__iommu_attach_device(group->domain, &pdev->dev,
+					      group->blocking_domain));
+	}
+
+	/*
+	 * Re-attach PASID domains back to the domains retained in pasid_array.
+	 *
+	 * The pasid_array is mostly fenced by group->mutex, except one reader
+	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
+	 */
+	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
+		WARN_ON(__iommu_set_group_pasid(
+			pasid_array_entry_to_domain(entry), group, pasid,
+			group->blocking_domain));
+
+	group->resetting_domain = NULL;
+}
+EXPORT_SYMBOL_GPL(pci_dev_reset_iommu_done);
+
 #if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
 /**
  * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain
-- 
2.43.0


