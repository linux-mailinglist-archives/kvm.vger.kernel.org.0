Return-Path: <kvm+bounces-38992-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6927A41EBC
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 13:23:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5D577A3522
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 12:20:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8213E233707;
	Mon, 24 Feb 2025 12:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PjfhETfR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2046.outbound.protection.outlook.com [40.107.212.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42A8221F21
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 12:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399550; cv=fail; b=rJ+VUtbFF7rdCbDCp6BMPeIAJJrslPa4oIa3eIrU08AWNr+JYxtb5quMtaOiMsfH6+LOf6fyxCuki8tnDBzXxmf5jOzRb6q4v1/pTbRJjtDq7aS1ECnH2jIyAXHkqe+h7tA2yl0+hpbPPCJU0dAQDKpW+0ikwAT3qb4SWvOM2Mc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399550; c=relaxed/simple;
	bh=AsG3v6+t9T/xo7WE6hvO5BVe3/fGU8xnb2vo4YxlXNk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qr0K5322pn1lSXpu1qcfJd5+mUEvtC44gtdJzCPiYWLwcfpeMXrQoB5WqtqHtu0eNTvv7Zdlf9ATKsvb4JcLqAbtxk4ZCMCaP8/531gKxQmpy1p6SW2n0sF01GHcX7LDKGHpCOcsK6FzYgv7sipebO+zeDF4vUfPUqvltEswlkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PjfhETfR; arc=fail smtp.client-ip=40.107.212.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ajKNKGRpmZv+LG9Kzb3uO/GkDzVz2h1lPCfTpD0M3tQLZefvytHVfSWAbQ/GiMq4CjgMn3wlJVtz3qlaibhsJlu3wAemoQn2AX8+PRdPYX8AT8i0jfoNXT42TSkTJjF+OaL0TCM0nLFMLoIZjAmEZoAtRBMyZ/JMrF+81cmdRGjJwAYQnRZgXakyI87pFLte9hGlyo0QTIDHp0gK6515iB3I33GEk8U84me/hCxafkOyeDKq82Is96jCEXEgz/H4ZTg7lAuv6/uNlyRv0LFrdrXndNcs3en+0K3SX3JDn2nu0cWbx5+VEt9D+Fa0XtFYc+6bYJE+Eh14BVn+d0dVBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KC93mkPLpw6G49PenUw0bnsfhM5sba03ejCruH89h/Y=;
 b=HXpuksgaHb+6WyD/dPglCjr+y+t1kK7VZZJVcPHe4mAS+piytstDpctD4okkpcpykxJKqZktZFgMMN3lZddTu/gCGfI5thh3JyhWpp/WCEsPWuGgaeltaW6bhchovdrah8ZxoBLb4D194Ovaxhh+iCF88Nc7simu+kV8mUMjlfKTT6habmkQVezKJXBfzR2OWRdEHlggiaDrjjCkBCSDDidnfjZsMkJBerKatzpnZbajylZZMkZk+G3SP8//bJyYy3KFPxzge54fhyNBHJj5/zUGpFr9SCefbe+Qc2+MUVbYj+U3tWrhXq26SRTHngrvoE+dpm0Rboyj3PmU05IEmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KC93mkPLpw6G49PenUw0bnsfhM5sba03ejCruH89h/Y=;
 b=PjfhETfRh+Lw6iYG4spuK2II5aUt3omsGN7iONYxphdwt8KLCoKvHuxC/LUsho5kOPnd4e2MabhLr8pzTqCiF4kHE3f7Jh93ImA6Xzz2HHkwBeSNPf0yWOFwlUwSx3r0Cv6WP2bppTnRuM8uPUh23OxNBRI1j+nQhK6zsyA6q6rLGEgmePm38eRCqvnrSkTovAPtaBLxBb0Jfgf+7AZEMYjQ6FWa+NJ2GH3fI+OTyT4h0CNScOKtmVU+JhiKa5u+jSWh/rfxEo/DLTjhwSHV9P9jU/ITtA8CZGSlSole0c/8T3FcFJe7B4zPVESRb0JZ8r1h3wtKqc995cXF+nauLA==
Received: from SJ0PR05CA0198.namprd05.prod.outlook.com (2603:10b6:a03:330::23)
 by PH0PR12MB7469.namprd12.prod.outlook.com (2603:10b6:510:1e9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 12:18:59 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:a03:330:cafe::1c) by SJ0PR05CA0198.outlook.office365.com
 (2603:10b6:a03:330::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.15 via Frontend Transport; Mon,
 24 Feb 2025 12:18:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 12:18:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 04:18:54 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 24 Feb 2025 04:18:53 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 04:18:51 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>, <mst@redhat.com>
CC: <jasowang@redhat.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<israelr@nvidia.com>, <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
	<yishaih@nvidia.com>, <maorg@nvidia.com>
Subject: [PATCH vfio] vfio/virtio: Enable support for virtio-block live migration
Date: Mon, 24 Feb 2025 14:18:30 +0200
Message-ID: <20250224121830.229905-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|PH0PR12MB7469:EE_
X-MS-Office365-Filtering-Correlation-Id: c79ade99-6609-4897-e1db-08dd54cd6b0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t3vo8LCg8Q97WD3vbbR4aYYYMkW6c2kwQjVkqod4rrr6EEH7nDTqzt7AiE5h?=
 =?us-ascii?Q?5HB2yxyVHrLzTdWfvwTUc48khS2Ac7iKYUKLDUWtd6rk/Ano69cFSld/V5JL?=
 =?us-ascii?Q?x/7h+3oyRFPVBHRxD7C24pv4p+fxApYdmaI7AG/7N4Qlk6qhX4kb0TFA3VDe?=
 =?us-ascii?Q?MfKlPKQ7YaYQQYrivAEM8IMvMVgAjRnZUvDLOYIGFvB3VsLWIOm3Zc3Os25A?=
 =?us-ascii?Q?v7Tz33uRqggElK+CXNBQUcFlALcnpYj3x5I4jTUfwIKNZM9+04p64TiqvPbi?=
 =?us-ascii?Q?7OO9JSFkP65WpDvM/SolC8eFwdMepTZNRTnhGAv37tMyjl5iz4cDwVBRq1DW?=
 =?us-ascii?Q?4+gdv8iMImLCb5V7Fq2K6URwzrtB319ruLVVrjeJ8zdgRlsCHqL7zdCsfn5B?=
 =?us-ascii?Q?GkFUSMZD82HDmfbBWG6/4w5+DALzlB1m57RqWS1FBDYkCRcx9xGJWQzHJWJQ?=
 =?us-ascii?Q?990oziX3X/9rCF2uXLI8dZimKuxyBnE2XnENK7t/XUXve+pa3gH7vALg3OQ5?=
 =?us-ascii?Q?9B1aluy2xyd49NUxx6qaC71GefDGvxsjZkeV0N0sxyphUFNKwK/OT9emtdiV?=
 =?us-ascii?Q?Zs7AgF5Jxc06O3amadZzfzBzYQe57jSWeb3/kp6gXIkFVsdLWaWByNRdXguZ?=
 =?us-ascii?Q?sv4ibAkcC3G2k/1JSK6iK9WDcv2fYDvoY/u8b7QAAC8pYuPacfFCD0S+Lu/T?=
 =?us-ascii?Q?8ssxiYDJFg/HE8cMnlagTR7ZpxZPuFf/3AItHeFQcpZhCWfuWBp0OOsbS8g8?=
 =?us-ascii?Q?svXXLkPG/2JKFRvuzfq4c6u2oTcI9njDxRyU8zblv24HHSDHAcpm4jFJ3fsR?=
 =?us-ascii?Q?gKNNaZr6aoBMGGZLxYSAr85IuOE+LX7/QpzXjz2t1FP/CGN3inAW43HHYhoz?=
 =?us-ascii?Q?pKecXq3bTVn5ft5KMDXUd4j0mVQo64G8KctkJMwCfrXHPFc+VVm9SbzN6P7e?=
 =?us-ascii?Q?rsrVZ+iWGLQij9Pjk7miHH85BAyICKbZhHKtG9xNaiZeOB8I54k2BL5VrSiE?=
 =?us-ascii?Q?uIT8+4K/ctNJcVlIORSdLMEuw6FEy/K5jf4WJlPHy5bfiFjwE9CyBgFiDq18?=
 =?us-ascii?Q?464w2ZDvsZrDBfr324bsgpvnteEtk4V7qp3OgwQopLNmZdKEGdB/suh9abZl?=
 =?us-ascii?Q?STxckYaSgpl0GIJQZpn9h+dN4JBBuh+dWp4rOT6jK0pgKNKnHgkRr66kSa0h?=
 =?us-ascii?Q?l0iv3AaYaKthH1RFIHjNd1W0dN6eXkVa/UW/zlPqv/sIcVaciCjJg1KKJMJj?=
 =?us-ascii?Q?En6ylJXOkuL2vBaFx9mV4raGDwdLqJ7l1x2BMXDyFnHJu9ZeUZU2Y2OUmJy9?=
 =?us-ascii?Q?ppVUU/mzNZYViyq3QSMNdqal7k3bBi79GCNS8SpGNWUz69C26LLp4001Gkjf?=
 =?us-ascii?Q?AblAbj/VM7s0K/9asBY0fZvkJ6iknpzOB6LTX9Is6aPGMXEjpWOW0TSzIaOl?=
 =?us-ascii?Q?OO2sB7wv440M9MAzFw1qB6JPczrDNXwsI9xesLNRUh8caGKIc3bUE9k5+h7M?=
 =?us-ascii?Q?z6eb9W7ClyznOvc=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 12:18:59.6641
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c79ade99-6609-4897-e1db-08dd54cd6b0d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7469

With a functional and tested backend for virtio-block live migration,
add the virtio-block device ID to the pci_device_id table.

Currently, the driver supports legacy IO functionality only for
virtio-net, and it is accounted for in specific parts of the code.

To enforce this limitation, an explicit check for virtio-net, has been
added in virtiovf_support_legacy_io(). Once a backend implements legacy
IO functionality for virtio-block, the necessary support will be added
to the driver, and this additional check should be removed.

The module description was updated accordingly.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/Kconfig     | 6 +++---
 drivers/vfio/pci/virtio/legacy_io.c | 4 +++-
 drivers/vfio/pci/virtio/main.c      | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/virtio/Kconfig b/drivers/vfio/pci/virtio/Kconfig
index 2770f7eb702c..a279cb2b8b8a 100644
--- a/drivers/vfio/pci/virtio/Kconfig
+++ b/drivers/vfio/pci/virtio/Kconfig
@@ -1,11 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config VIRTIO_VFIO_PCI
-	tristate "VFIO support for VIRTIO NET PCI VF devices"
+	tristate "VFIO support for VIRTIO NET,BLOCK PCI VF devices"
 	depends on VIRTIO_PCI
 	select VFIO_PCI_CORE
 	help
-	  This provides migration support for VIRTIO NET PCI VF devices
-	  using the VFIO framework. Migration support requires the
+	  This provides migration support for VIRTIO NET,BLOCK PCI VF
+	  devices using the VFIO framework. Migration support requires the
 	  SR-IOV PF device to support specific VIRTIO extensions,
 	  otherwise this driver provides no additional functionality
 	  beyond vfio-pci.
diff --git a/drivers/vfio/pci/virtio/legacy_io.c b/drivers/vfio/pci/virtio/legacy_io.c
index 20382ee15fac..832af5ba267c 100644
--- a/drivers/vfio/pci/virtio/legacy_io.c
+++ b/drivers/vfio/pci/virtio/legacy_io.c
@@ -382,7 +382,9 @@ static bool virtiovf_bar0_exists(struct pci_dev *pdev)
 
 bool virtiovf_support_legacy_io(struct pci_dev *pdev)
 {
-	return virtio_pci_admin_has_legacy_io(pdev) && !virtiovf_bar0_exists(pdev);
+	/* For now, the legacy IO functionality is supported only for virtio-net */
+	return pdev->device == 0x1041 && virtio_pci_admin_has_legacy_io(pdev) &&
+	       !virtiovf_bar0_exists(pdev);
 }
 
 int virtiovf_init_legacy_io(struct virtiovf_pci_core_device *virtvdev)
diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
index d534d48c4163..ab1129a20e4d 100644
--- a/drivers/vfio/pci/virtio/main.c
+++ b/drivers/vfio/pci/virtio/main.c
@@ -187,8 +187,9 @@ static void virtiovf_pci_remove(struct pci_dev *pdev)
 }
 
 static const struct pci_device_id virtiovf_pci_table[] = {
-	/* Only virtio-net is supported/tested so far */
+	/* Only virtio-net and virtio-block are supported/tested so far */
 	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1041) },
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_REDHAT_QUMRANET, 0x1042) },
 	{}
 };
 
@@ -221,4 +222,4 @@ module_pci_driver(virtiovf_pci_driver);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
 MODULE_DESCRIPTION(
-	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
+	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET,BLOCK devices");
-- 
2.18.1


