Return-Path: <kvm+bounces-56904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C710DB461C2
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:07:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 000D85A61DD
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:07:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA0F531C566;
	Fri,  5 Sep 2025 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ucwP5Qbv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9229B303A3E;
	Fri,  5 Sep 2025 18:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095607; cv=fail; b=PfVIvYw4H598BSxHxDCDP8o9gM7ph5Sl2YL5H8VLG23UWcZD764r0AMB+e/aa0lubRUKk0uUD+05LkKnpKuGeh9tWMeeVVb+ENbn1A8kT5u+nD+v2O/Yhwybd7ZHwG5JMXSG50+5EMWH8Y3oISUN3uczYolW+tGNodqqx+VBn/U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095607; c=relaxed/simple;
	bh=5lctgXf0N64vpjje8K9AvrikJm2NxBPNW5c8hHhKWsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jKmuaipLY5S6X5ncDz/nqe4V6IbGSNJd+nGyOzofC31trGGGp5VvTpTjBN5tgwaQ6E01nv5tRXtcHY6M/qjo3p4vhHG3AfV0ZPhLhv52XPwg5z9lnDAaVc0XW2AmuRjGtD9HljxET1X6S0HyKSJ1FDnt6aQ26S/otLfcctgSMz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ucwP5Qbv; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oX+FHt32gJHPQk1zAzgRIniXbFuZBkTrLr4VywbVh0p1nzawT5KP72T+NsxKFLajOp+tT34+ZB9pbStRlYNQjFpEC7GRHCO5TeY3h3VAX8BOWp6dM2McdRlppv7QxVcaFNQiyvByiExGi37jJeVWGQeXXqx/KTCWxXrzMpskKB+gVDL3P7xWBs6vDRIgBil8Q3AR4AoZgFhrcrxGUBBMVwrnyYmyAUp+VDqXM/dYOwPZgK5WAA89ry8BG/WBlR6hLhho6s14CGP6stmyB3JpuWm1C+gn4eO1Ac9WEng6Kyr234s9yZTikoIKhtfDLkT4/LIUevxGEU8wWeiglSUa5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kAYPB8md6TxHYk5w7P8o8GlldbZicc0heISzI8FqmS8=;
 b=KYp7+95oW3RlyJKbx3HfZq42lM6/vGl/OCpFXy0iwLCKU9AWo8DbWKTbcWCo3i7UaLwTtTAmUwVPKAgSKVi1wjZi5iWSRFALTbzJRU9YjIpoQsoCsvHCpzSgZyu9MzXQiiu0LhJio2M7Lsl3f2l6hLECu2rypqGq8vlBu8Y+/W3+4wcRRoErV6g9AeqBKAkTrZuOcWjp+pz4kU2iodH8Ep5grODZF7P6zijhTecfMfJJwmL+HDpZla/QxJFkBd9zc7/ykerJTQRyIOqQ6d5fEf3DhvpPHdLWmaYE1wimFp65LBdWO0IIL1uj5J3fubP9M08HnZBSWAISJF/AZOXmgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kAYPB8md6TxHYk5w7P8o8GlldbZicc0heISzI8FqmS8=;
 b=ucwP5QbvibFlpjj7IShoVdusxBNFTptCTjtlH2mFfurK1jH17F/lbFgBDI1ta6uoYVnldVjfxgNf37V8Bj75XiehXHTqBplKJ1CD3YA28JJX5TtR61XvWezela496uOktdp2gRAKlU6box449ZgiouL/M4vQELJJ2Pe4URkMNoTJErGPc9l/4PFzeiYML/3I1CBCwLBz8ygXlvYjmm5NSZ7i6cTcAreuNf4XAZ7wpa01UBhwtPCgGf3LsNCyEXjQOabGetiaPIZNQZTgOJwnQSpuBHgq33AX6yYiejsCCQ4+lRYMamXmuMnedE5LG/MVKRNrGN2Aasl+Kmmoew1x+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:36 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:36 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH v3 08/11] PCI: Add the ACS Enhanced Capability definitions
Date: Fri,  5 Sep 2025 15:06:23 -0300
Message-ID: <8-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0039.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fe::28) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: d4c66a5c-2811-4522-ac75-08ddeca6f1e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2iK93j/skDKGJQyVclejrrgm60dJc5CB+CzhohMNasb9UlRb4yhaCigAaC6Y?=
 =?us-ascii?Q?ieqKE22YkejtFATeWgomW75Trexyj0dft0l6Y8MgtNzKv0ALwL5fXKXjeGpc?=
 =?us-ascii?Q?IWA1V7OeyFlD9uPCEH/mSr/9/QYhfRAmelVz8BImb+eAtSxi0U0iHFRzGXg3?=
 =?us-ascii?Q?11tSiWe82W3Hq1fQCsmPLwROCj0m93L1Byd3Mht46iOVe2zwxJNnLkcecoFp?=
 =?us-ascii?Q?OmCoN0ykaZgngxnI5RSL5vovyduBEMwdfk36T2XWJlGpPjXKzhfHZyzKmrVa?=
 =?us-ascii?Q?7+wT3BRzZ11j+21ZM9RgFzea6S00p1uUUCCtzatIZdfVdtdSHfPTyHa3pQp4?=
 =?us-ascii?Q?CHUN6fMqyT1+Cwjzzpp8pgrV3swmZC8OCvPcP+hsCyMTrzaMG5mA5QcAmO9k?=
 =?us-ascii?Q?vPKfcaiU7UB6viU8pO3WhDpLS8SEbq8zSRN5VpflPqFRfh+mHE/VnovLxcfX?=
 =?us-ascii?Q?0UFN3y1yqBP2VaJiMdiCjz7tEggHlmb1/nxLzUJGm0/e4Y57pIKgi1oXmMVr?=
 =?us-ascii?Q?fS0zSzUPTgyEE6omW2P7wEG5cuaPhJdObsXeBTTGzclOqiErfbDo+UVsjC9H?=
 =?us-ascii?Q?g0YAUg/Ydy1+MEL+oDOWFkyqaWKzfSP7QDur9uOf+6OpHhlF2Q7HWsFvNpPE?=
 =?us-ascii?Q?kmr250K0Z7gT8hqIcEZ/3WeaeAV8PwZxXpWDp3FctJQF1UiC4lhAO9MfavaU?=
 =?us-ascii?Q?hgFTQNQyo+wMiLw0/eoizGE6oQFrxW5IbL6ieNllZ8Uo1GuszUsXtj+9DqWN?=
 =?us-ascii?Q?/Y8To+yvmcqn04n4HctV2lKmhbTYlDr73sZpZPeQ7yoU/GyjaO9ziENBSxGZ?=
 =?us-ascii?Q?6CGBOc8KHgnCuNoDsT2eVKHhOK+KQemhrYHBybNInM6C8jDhZFykkRE8XBoR?=
 =?us-ascii?Q?gq1QJSAb9Z//PV3Gzqx+U2z8rsI4hwmmUhUTvo0ZK3UPaZsNRZnZo+1DrBMp?=
 =?us-ascii?Q?68EO3CDmbgpvhTWKGF+tNVesks6Lf8ySB0VnBW0yo5fQyjFwq8uAhMNcVN6j?=
 =?us-ascii?Q?lUh5bf4rVKRAvGh+utWW9Go2zVCBxnWHqHIdmE9jNAnDkcWSl/CGIUg6r26Z?=
 =?us-ascii?Q?yRZ//tB7xhAI6zecGbs5EbO13gO9029CBlpntzK/HjgzrmQ0mGHsJkFNVHBt?=
 =?us-ascii?Q?gi12mTNpioLy0otxArYWaS8MNfvgP1UCTToTg+dZfVsdllfbdaioFW1ykoSp?=
 =?us-ascii?Q?VTcq0YBuVurUmLgTWgNkC37quu/cUYbwhLxNodXSnEJNp/anRAWapNg3pV44?=
 =?us-ascii?Q?le6TR7Ft3x6wUQeb4rgswGrDLRsOcAdIztLE5KYK4onbKcicz2YHHxgyo+xC?=
 =?us-ascii?Q?f8ltEMp07zk+a23jcFBABR117TK6mzj2NmRupY22PRMiOMdTjwrLU93rFtnx?=
 =?us-ascii?Q?60VwSucaZ5Wra74tX2feCw1ROUiE1snaI4wWOEjZE1S4hg69Lf95XNAwY3+K?=
 =?us-ascii?Q?zHJDNKTkkmo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X39zWY0DnTGl3p5QxKqkUQCl4qGZ+3Z0Pb6a1zbsClhLdQwWEiF3zaD4zttG?=
 =?us-ascii?Q?ZjMFg+yhJyt0go4JwCEI+sn8EZGzK61EIvjMPrLW9bDzHG85X2pcc1FzZLbx?=
 =?us-ascii?Q?zJr93YwjB6CzwnEEznFrafrfBhhLM3L7XiT7r6SBHwToJdyHrR4GmQ7uF1Ro?=
 =?us-ascii?Q?s/UD1fhk9xDjmkfARMbq1k59oERGMAYoZSd8LZ4pJbi+6NXSr0hy2y04hQzg?=
 =?us-ascii?Q?HqZhhZgKnW1jemejADNMqei/eqp/wURP6t0vb6LYalzS+g5I61s0xO3SJbiR?=
 =?us-ascii?Q?P+0SC/tunjEfV4r29ipXpq8VBK1hXrVpEcJA0EWX9E2BU8ioJ533/cSRlLcK?=
 =?us-ascii?Q?4tbZRjaDkRLv3iNB+Z5i/HgrS1C50R4rPLhowFXauoOR7BeNp9jj2+ee1DeZ?=
 =?us-ascii?Q?0tcvFN0Kp2DZu8wdqgijAJjUTTLOECCjQe6uc4PnkaVCB4GEh+JDRjCwvm3S?=
 =?us-ascii?Q?6YjYRCBDJkek86BuBU+XaZjOVgUraXR0SLBYC0s1LfUhnQ7PsjHMAj5Qs/IP?=
 =?us-ascii?Q?A5gSaNPbWEJlk1KPhHOygKRMHR6UA31STP3WZVGw9U+5qxZKg3QOKoNp98RT?=
 =?us-ascii?Q?bkM4yUWWZxERE/jo1gMFnleJUyzrYVDB9WbRJ4+XOPLiLCVnZXIRODolPQ3s?=
 =?us-ascii?Q?hfeKXOEJxHj6lf66O6y29DyCJ5cFOZf/nlaRahSfVSk4YHAq/YBb3JwjjiY3?=
 =?us-ascii?Q?NDI1NG7SMQlkWwVzN6CzzU7jsEgEzihR/s+zqH9jW2x+b/TPFYHNg6MGsK/q?=
 =?us-ascii?Q?+16aH8xjw68k0ImGJZRme1zkp0X0sL2km9VlklwzZjQKy6E5qfPpYGRp/SrA?=
 =?us-ascii?Q?3asAH0yXM1EzU/YTePKwWAQQvAajlpDEFzZ+t9++FfV52WCDk1pELUk+Gv+7?=
 =?us-ascii?Q?DhvcjAretn08sgjUMWrFvHNr7sgPciAsHDEah8ifIGw6X73XRM4qu4IbkMPB?=
 =?us-ascii?Q?K6KKLz4iV01WxlzN9Rg+aJCn1WJR8w+wygaawhoOOrCwQ44XCoVdexU9z4oT?=
 =?us-ascii?Q?Zti+C/4vTqVs9VGwkZTB4BZXbw7Jra0a08Obb0G4YJFD20lDBVWgynsnPGo0?=
 =?us-ascii?Q?cwFz2+3HfgehoKwpDoqeeOA1RlnbaTqHKRgObvj9i3sTjXhxMtgbpDywQiuZ?=
 =?us-ascii?Q?s7/XU/Mahszak6aBW48gwjQpmZKUCgukJM9saT1cxocvk6katk4sSaHmQuzl?=
 =?us-ascii?Q?aG9GgdJMWHJntMmWLRtjqIk1OTy34gUFsnkMvBjtuv9u6u7QvRO8UBRbg1r6?=
 =?us-ascii?Q?EE7aByZD7Nzko2Ea0aswSOl5jJmPMrWn6TCAJHWwnPzjrlZoA9Hu/U/+Jkkc?=
 =?us-ascii?Q?mQn2B5KIJWEiKs95mfOeZFJTkLCwNDDcGJ1qCMDOVEhoLj2idp/mceU7/jg4?=
 =?us-ascii?Q?usdQTtGsa5QpLRmejLF9DwmVt06jqQQ+DNpBZtilYw943urfGn2eQuwsy5Iq?=
 =?us-ascii?Q?BWXKQrlQtzv0vCjkKKZzM/ZQg0ZpR2WN1z5VhzXjVUruwfDm14t8v8C83aPM?=
 =?us-ascii?Q?t/9/QIn/BWQ5/Ry3wVKGv89J5JDDKd8icgSrtWMTCRrVnoFDUlN5k7MS6A/Q?=
 =?us-ascii?Q?lwI58ajon9z+7Zx5tbw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c66a5c-2811-4522-ac75-08ddeca6f1e3
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:32.4708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abqlOAeaLJEY5vFu67veUbg4Im45nYqXVYG28fkrA8dZZDrIv009KvkUK7gpGPxT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

This brings the definitions up to PCI Express revision 5.0:

 * ACS I/O Request Blocking Enable
 * ACS DSP Memory Target Access Control
 * ACS USP Memory Target Access Control
 * ACS Unclaimed Request Redirect

Support for this entire grouping is advertised by the ACS Enhanced
Capability bit.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/uapi/linux/pci_regs.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 6095e7d7d4cc48..54621e6e83572e 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1005,8 +1005,16 @@
 #define  PCI_ACS_UF		0x0010	/* Upstream Forwarding */
 #define  PCI_ACS_EC		0x0020	/* P2P Egress Control */
 #define  PCI_ACS_DT		0x0040	/* Direct Translated P2P */
+#define  PCI_ACS_ENHANCED	0x0080  /* IORB, DSP_MT_xx, USP_MT_XX. Capability only */
+#define  PCI_ACS_EGRESS_CTL_SZ	GENMASK(15, 8) /* Egress Control Vector Size */
 #define PCI_ACS_EGRESS_BITS	0x05	/* ACS Egress Control Vector Size */
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
+#define  PCI_ACS_IORB		0x0080  /* I/O Request Blocking */
+#define  PCI_ACS_DSP_MT_RB	0x0100  /* DSP Memory Target Access Control Request Blocking */
+#define  PCI_ACS_DSP_MT_RR	0x0200  /* DSP Memory Target Access Control Request Redirect */
+#define  PCI_ACS_USP_MT_RB	0x0400  /* USP Memory Target Access Control Request Blocking */
+#define  PCI_ACS_USP_MT_RR	0x0800  /* USP Memory Target Access Control Request Redirect */
+#define  PCI_ACS_UNCLAIMED_RR	0x1000  /* Unclaimed Request Redirect Control */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
 
 /*
-- 
2.43.0


