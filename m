Return-Path: <kvm+bounces-51119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 76B7CAEEA48
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D5B4188C233
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C91329A301;
	Mon, 30 Jun 2025 22:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fIp7Eae7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1670A2EACE9;
	Mon, 30 Jun 2025 22:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322532; cv=fail; b=Rj1vSasBoomnrkTK1Vlbg41d5tnXPhd2LBO35Y1PPNR86Pl8mIHlWU4hycquxuU1jxpxJA2W3Gn4SvA/JNTnv2EcdTgO15myqv3sJlxxYrgx4nhWNph9CZhoO8yVxh8S9QuUGWF37S+3v92K67Rv/UyUsrc9PPdG2nHg0DmUAg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322532; c=relaxed/simple;
	bh=9t2oOSnuV6a4X4ASEtsXZwK1yLRY95wyvZeOEy3StQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=B+xrgTl1pbiE/0bMTxAa6ETL1p4wFM58RMREGdtYg1adBVD/bhgzlFCCdNjTK5IXGdEDVflwB9JAy3DfvUYZgg8pFofp0jzdEP1a1fAsrF8tvEiDry5njCE1k+bqqBFtLGw+z5kw0Bkqk923jOpsjrkrNF6juB15LmeQNRR7+YU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fIp7Eae7; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VcYvxqk3FEqD0QR/IlR0uqUId9rNW+Psplrl6jK5Rz1Udi2xUavJDDDND2TjvYQ2gFP3Xqhx+IGydeQtvbS8Wn/FBp86pv4JZ66X0AYK8PLVxQzRWq2GJkHXncFGLkgVG9U7z0g01Os6pSR6M9dUMWaR1BiJ3/Jk8qNhle41BsUx9+HG18UaJfz6VpCK2XFje2n+TUeWjCE//C2WJOqCkN9I9Nq6uYCJsWINcsV/44/IvkHL5sEGEh+zII6cThKttOYUmaq+U2zkiu5wJ1AZtXB/iE8QYYJaz9fMsbIWUDuNPJxiWsF50iKEzc7WkzB0kQycihR1+js+Tm4iIv9Jtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GrPIQjskBK9bk+GAipPeiDUaWMs09cPMKX01pa0UbHs=;
 b=k1kmpRntC1sRBpn5kk0xUGxJCb+O6SnoDeSxNybXHBpCAmzTx7a32IWsmkmd/Xm+uSwrr63UqxAiO3ON+tQcYatMWdcno2Cs7JjllC41oQ2O1wvytQjVb2TYgusyDKMQ8TzcrdLIQKtxCjyRQLi5X0QZf/p2U0u9QNTWlOBov90RRojTHGubGbl5c+Z8CczGAMVRCbmwf1lXUGf+kdRJZMLepXG/jpPJggWAdzXfEVjXROTVFC2JzOsafJxwWHXx0ggDIrB0/F1sHOywYKvn3/48RHk4Z7vdX9t/e8Nh8UWdcHl2xPll2fVmG4bbry/mbtCaZPM95a35Zgeav2NotA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GrPIQjskBK9bk+GAipPeiDUaWMs09cPMKX01pa0UbHs=;
 b=fIp7Eae7f+GHahpqoI6SbYGacstgmwn41tIPvppDNgWhIen3nW6fWutGbOtB5cVy5802opHx+aNg8MRKhYsoO0aZaHG6H4a4mdHPskQGU2iA2CGulzrmL8JZCOIQ/W1NyrytTwICtBJtyBqdJguwXUcKYteMQlgC5oo6vnKYdGm6i06HpMaUmtEeRBXrHAMKHbqeXVimVRPjISKHOxRLOQ+rsmiHj1R1G5knPyK/Ybpn7/jUDjQJACJZIQAVFE2qZ81OCXGM9PNExozOwArAwe+ZDndXINhLT3fqZJSznZgNY1mYPyrPN8yVxDJVWiMuLJJ/cpO/edyZLQfcKg/xqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:46 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	maorg@nvidia.com,
	patches@lists.linux.dev,
	tdave@nvidia.com,
	Tony Zhu <tony.zhu@intel.com>
Subject: [PATCH 08/11] PCI: Add the ACS Enhanced Capability definitions
Date: Mon, 30 Jun 2025 19:28:38 -0300
Message-ID: <8-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::41) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b31bda6-793e-477e-d7ea-08ddb825794f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bSJ0+I+BshIjJ9UBCL3Rq7W2A4pH6M4He6ikX22AhYiuN9OYdf4ZtCIMP1M9?=
 =?us-ascii?Q?GtnncypsBiQGHXyJuVaPKwzEQ3zbMYSeid5kLuilBr26cN9djaf522qHzx+i?=
 =?us-ascii?Q?QckeMLjuhZURBiAJecqKkHj4SbAIIGnZkZ04Mt1xd+oCYRDyoB17pQcXUwrW?=
 =?us-ascii?Q?16KJcGzh8R4tlqcYc1T3vxWxportneERwlJhahWgnGoUKfS54xzGCqjIVhC6?=
 =?us-ascii?Q?cqQKTmi+/x7d3KP0VCTXz8kLv+CZffMGkp4cyCgbeJEW0LlZV7UX4WoGyky9?=
 =?us-ascii?Q?AynplsKzVBjYUxlL5LYKyZguyrvK9sLWbF2Urv7wbEVgtOXSB+Oo05er/J79?=
 =?us-ascii?Q?v0NfwYWEjsRNJ8ftXBVZMH9Q5YLC18fO0e6+yS4ZY9rJLXKVQlem3PSpIWqh?=
 =?us-ascii?Q?vJrhnIoLsdPAYMzbvxdJRyYA9/FrUW/Sz4CaK2WHz3BdEqHuO8fBoNHR9fvC?=
 =?us-ascii?Q?qgqjp9kDWrWmgQQTgQ+RfshiLCJ1BQbsMu6EvUpxp09p7ZmgZan+i5Ow17wI?=
 =?us-ascii?Q?DjfzXDfLA2Ci4nUGlN2tXjDsp/wh0Dpn6mpe0BneYcWoqz/Y3joYD+G8y6n0?=
 =?us-ascii?Q?1HXKbqwIwidOwFRUYbNwN+wRDkaVmEL4AEloWvwafylEkiSboN+tVZhvnNd6?=
 =?us-ascii?Q?lU1Fze+n60EaGqIgvgLChwT+e6W0nd19TIvRMYk3Q2DUvdNfFrD0kguNRVKT?=
 =?us-ascii?Q?tfi+wqNGN4oRlJeJkrMFJlsoT+xdDIXwe+ne2r6F2F7DjeCF2TI1A3sOTIVJ?=
 =?us-ascii?Q?mvF6p+YQb5zyv8ao6lSyqJ2zcHw4ljKXM31xcSh6B3+X0xlV3K2/lgsvrvJy?=
 =?us-ascii?Q?o98ef+KMm2qORevNXiFtNpA0DMTrZhkP9DTV433+F8wnnmG9ILOmPvOrcjqU?=
 =?us-ascii?Q?66UCXak0Tvyj/IcKk9SMTtJfrzCeER4dQS3puVd8jPBZ1XKWi7gVIEg+bon6?=
 =?us-ascii?Q?ZYYiPFYJbXzB060pFm8toPotxaLvVCKafHwJxYebkTGQ7XJ4tWzZcJhqIx+u?=
 =?us-ascii?Q?VmL6dhMep6Un9ITTCcmduwQtkLXk4iDbg/umbSir5D87XPEVqTQby99W8hQN?=
 =?us-ascii?Q?hJO9eb9Iw4dTlCFLq95pKxoOQby2xcYCQsmKtvlh8r31gEj4i7Z+qIcJYLb0?=
 =?us-ascii?Q?BsqYEX23vbxiUuUFrsRxvAfJVrIJsrmem1OrOuq1IPb1eD3VY8I6ZVDRNxgt?=
 =?us-ascii?Q?iqxReMn7N6TJ4XrwLxRUjxwxEE8HXppDm8PMr5tNHsNcn/wOz1cNwZvddXkM?=
 =?us-ascii?Q?RYB14MOkX43ZuXToE9OVCvGTdjoJFavuI/rvchwQmFGNXsLeYJtcXlU+tVr1?=
 =?us-ascii?Q?Cb+W3QfA2oRWZgVOO8aTyG5tECTa1R/CKYU5NRZiZ+6TsykPBTsRrFPEtggx?=
 =?us-ascii?Q?N3AKUtk8FZIFyzUEqBnxBefZOox0h7G7KhDRjVLaF3cDLZMC2PzFc8yabh44?=
 =?us-ascii?Q?qPGU4ZeEBMM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Ytimx3cN7R67JZjSViDY9lvMEZQkpVd9sWxWr5L3TbRCHwsZUzOv8FfHqQX?=
 =?us-ascii?Q?oabmhYBVrMn6jusxily2HO/eoSHoxp7pmcNFSFPRz5K67389c2jwl5ukZ7Qd?=
 =?us-ascii?Q?Q9aca78o62yL7Sr9ApFZwaJ1CXyNPh2U9PtV9KhZvooO10oejrvoMgDod8GX?=
 =?us-ascii?Q?UygTEy3HEkNf47zmycUxP9QUfxu7kMsxRxs+WbfSc6OX0h6KWSlccHe7Iuw+?=
 =?us-ascii?Q?tO1b+rSXcv4a2jU2lQ2HDDAQ2LsVsPtMRehQOLNxmkSvATuZrjXZJS3m/26I?=
 =?us-ascii?Q?qmuM4X5QJd3Nqw+Wr9bIBacjHD1JrWsz75DAc6vZppDECRVUKhMusYYt8ONa?=
 =?us-ascii?Q?+v93jQYx6Ad1dqPrsfc9lrO+zrwjQrk8W9uxnqORpqq0FsWqlq08xf9GB7Hs?=
 =?us-ascii?Q?YlsDoyczzRzpJkGjRZ3s9vncQXFZ8Nf/cTqsJQNaGNkxtj+FejBH6jlv+oFh?=
 =?us-ascii?Q?bLWils0p20yug9f01guYZHuYjDQeul71zaCDNFkLaZEOGL/gwkAazvBY5pX6?=
 =?us-ascii?Q?yJETk/0BAu8LnuZO2yejvZo1NUCKNqss7MLm9Ba2qry5BLBf6KmR/hZsr2bA?=
 =?us-ascii?Q?AbMpr8tfdWiRIwwm0WWH0Squ9LIE+WUR3Fu+u+LnB0Vfapxifzuuc58J39oa?=
 =?us-ascii?Q?uO8K4TuHcWkV13x4zF2wPilC4SnLoQqB9nvxfg7mogVoOzdJLzAJkoWx2V4g?=
 =?us-ascii?Q?bogQimImiJe6DgCEWD4UptRf/vG2vS/J0LVWX5r27XmGMXZJClBAUOsWybwL?=
 =?us-ascii?Q?JzzrFPh1W6msHsyFQbTUAZcHp/Pt7xmaA6+oQ+mMFFyUvVPc9TT3lM28+IC6?=
 =?us-ascii?Q?0EeVw7Smbrch3dbs7UF8BX3p0tONvosUpdMmDQ3j2Pdeq7B+Wh1FHoPpWiZJ?=
 =?us-ascii?Q?5+Imldc86QI3lSit8cwCHHhNhOCUabVJnhjw6jTuJkg+mDVx1XlS9w9kZxkd?=
 =?us-ascii?Q?1XV0Cy0pL0rO9j57GkWEvyXg5yn4o2VSvGduvBG7nit+nh90XTL16upA/KWs?=
 =?us-ascii?Q?yHCAtQUfCMbr3mSQxN79aYjm77bEj42u8Wbvx8bZ5pB5lozOeN51U1ELAdsE?=
 =?us-ascii?Q?5FVkkGKtrnu1SdgbFNQ3+aPoB5HQ/BIx2NWTgnyFN4yQsPmO7KcmfDv590tf?=
 =?us-ascii?Q?b5Qd1tXEPFziRbwh1mBkXYdx75u9nzqRgjNYanFDITKg/BAPy68pMFu0qWXV?=
 =?us-ascii?Q?IVJ3Nf6ZIT4PtQ+sahiRo6Cp6vmlnVuhTHWBkwjUZ3nD+ZO410RwTFAeWRCy?=
 =?us-ascii?Q?LqGw+/515WC7JQx89BspN5kfoyszyVlrMY12GVf6wKfSnrQFjFYIUtuK3v5P?=
 =?us-ascii?Q?nEtDAuZOb1YQgDcsrNAtHsGqQmmmc/dVkgxS4DozpPtGWggiAu/oplWS7h+J?=
 =?us-ascii?Q?69IJbZMrHLZHHpo4bAnP/uqM6JEsAaifMDqXNQrTBLVgU1mxOcRry0fRNm5k?=
 =?us-ascii?Q?PoJp5EEG4ofGnkrPp4ObY1xgynFXehIFG9N/D45X5wZYhHiEeQlU6/h3Yg1f?=
 =?us-ascii?Q?T8LhwU9xWRDr4mA+KrJ3fCd5gLX8LFcVce5EHSfTl90R58B5XV9Nq0pqdAGu?=
 =?us-ascii?Q?ISZTIvFRv3sXnl4JTrww6aIRTKiFfHlv43R66DMx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b31bda6-793e-477e-d7ea-08ddb825794f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:44.8063
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1PkUcY4V28btbaMJ6CW8S1VpWPBrhUyVOmVUX8e9qEKz85Y52Xlv553e4mdR8Xe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

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
index 6edffd31cd8e2c..79d8d317b3c17e 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1004,8 +1004,16 @@
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


