Return-Path: <kvm+bounces-51125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00CECAEEA57
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:31:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 561343E1B8C
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BCED2EE602;
	Mon, 30 Jun 2025 22:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dIlHL0Vc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF5A2ED856;
	Mon, 30 Jun 2025 22:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322539; cv=fail; b=mdBzB6D3Qs7OXs4XI6Sco7/4wWYiIGe5bXvfDQOy2b5x3HTN6rKvJcPjidI+ojODDcxjiL93JcGxpbfc6xgyKP2Wp4UKfyOeyiZVXn9OYCQfHsexfoEQ3Oy/NXOd/wGief5oiRahAoSqq2Met7COtlhepw+UfAwEySY4tcae8FM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322539; c=relaxed/simple;
	bh=fFIr0ZhXhH/xiIiJDuMWyzIaG7noCyCxYOTYmQzCGxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pCKx2t0JqxmapDypJ1iDk6n1cXxRJ1ZYGNuCAfIRBey/Bdb7nG+sCy1a/xtAiR4qW0vdh+oYxm2pPmgTrpScsR9shyh52llN1jCLATk6MFAA/oHla/qnRa+U6wySEUWWFPgS0bH6XYOaE+st4lc2pD7Dx2mAxJF9QVVc83JDxbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dIlHL0Vc; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OsXdI0MVaBIZ8r/zUM223Iw6eMuHnfWZV3dm2Zk/6nZSmkTVgkeK8/BYff5Kz1E+xRsnpoXX4dheJ34ocut1PdxkIsnIJcCRCTn8XUHGYh5Jx3EDi7gTXmyvOqhGl8Gw5sZWzCLnw+9wFgspD1J0VuSwYXja+A2vYbLfIF7Hjz8mJtZZks9wlRhwKCj/VN5TBLx0Z2k34Jz44iSyvA6DNLTbsYmWYVPA9Ep2Xm7g2qPwEv9KDjrBi/3U0n+XwhyZLTbr1agGnNHHFkgXfy7R/lyKiIgNUNX6CJzkvDi77Xdr47S1Gwz9jITZNdZGy6DmyQ1M7uBnDOTdMk/gkZHmEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9jy5FYpnHOBI93NJaptDM0IBN6O7YyF+jM9XirEqwM=;
 b=kfVcFQMzjG8EijpddYW7w5BLH7I1uokees0g3ZI6r06WwTGbeHxRWbXZ8u8+mxa15ZjxbItdHOM5ZeWH9iQAIoLDkWiPuToA/TxRgWzBS0GYS4/nQxl8nbLFd7l4xZlJ3ada7qsfyjawWXj/5vlLQZEjsSwTPlJlwcPaekg67QhWNRQLojb+Ciu48m2m9Gfnw8C9LmXGw0pbCzPbnqDCSTo4kHi+muXryRoGjk7mzCqZ+PBQccAgk+yu4GZ1muKMk6Ef2fu2FYuubssP6nchKlhOQQFUf3ZTf6n6r6hMmM5XcVIo3rxpDrtS+iyp9jVlRrY8CtFYbDIFN3a53ILtug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9jy5FYpnHOBI93NJaptDM0IBN6O7YyF+jM9XirEqwM=;
 b=dIlHL0VcdBspdgu2skQgxw+nukKQZ9zJBECRzeHxFiLW6rZG8sAbrFDPfCeY4OD4oALHxgfOct7FyJLihcWkH8dhy+Mw5JJRITnRBk6tu/uIO1JUhhBgugfL0NTEKUkIhaEDNdMF7cAKnvYwbZhrgxwQGLSGDSavYQUJAm6H22CtqSl++YF8DnuvZiEXhQFvZUam7o1tJQPaFN1HxCuU8yt6ufKabSBmqwpeEEoTgWImdO3w7jgJP5Fd9a+g99w/T5OQ0cgzdnB0D2wKDJQwmnlRHMRIq8uZJ9y7bmd+DVOclOW6lr43BXQzQaK0Vj9n0iqgwuTeSwTXisWLvDSqyQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:49 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:49 +0000
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
Subject: [PATCH 10/11] PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
Date: Mon, 30 Jun 2025 19:28:40 -0300
Message-ID: <10-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0037.prod.exchangelabs.com (2603:10b6:a03:94::14)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 258a1801-7481-4cba-179b-08ddb8257bf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?b3OujMOzHYeZDpsmzvoppaFFRCtB1XD5oiO6Wt/Dhwq6N5HVDR1tA/KWHMK9?=
 =?us-ascii?Q?DRcOb7SNz8wmArfVYKXkajEiDAXUv+ogZaX/XaCcMe2VqBCitPFdSZD3QlAo?=
 =?us-ascii?Q?6eYcRG49Za2phR9Z7ZkpUpzCw1xezsJtpIJamTbWT5ZDel6xLI5L8kAgdsZx?=
 =?us-ascii?Q?FHrHYu8nR7mw5Q5Yb5vPr1qaHRetLaaAemDnd3lTFn7ijoP/sf3UjrrBfAMV?=
 =?us-ascii?Q?SxWptGZlu0D1ehwTNuyWeO5t10MrKypgkC6KX19qncQYN77+xkA+WL0Sycp8?=
 =?us-ascii?Q?jwwB6sRSAkbNj043BucDbxap/v/9v8lMWdWf3WVN28jyT0igSj5n2aihFQsg?=
 =?us-ascii?Q?3zNTJ6N7d1GU/KofKHugTfosZkk2s7OdSXsWxZSH17oJJLKKFjiTkOYqZ6+r?=
 =?us-ascii?Q?0ALFs94hB975kkIp7LCnhe/Rgl9aymGAx1gfskgVaFXRYlZLIwpRej5owwdP?=
 =?us-ascii?Q?cwreGaiDUCQR1tHMu/NYZTbZQOJwHvz1P++Fqd5Y1B8F8DB1jKd+aMWgdwzC?=
 =?us-ascii?Q?F91cPK6//2KE3y4H01+auPY55ScOVbadwS4qIyPKbmvl+E3OqXqdPAhRbNLc?=
 =?us-ascii?Q?ox7lGG3vRFqZ5VKnWlzBtoh6JO/dn22Y3V78UCAGqLXaVIFYgSdhYLzdA6KA?=
 =?us-ascii?Q?Zrx/d1tkh7a3xBD8UoaUPNltekIQqb+9VfZfxpffcpEmv8ERk+RSdmk2ODl+?=
 =?us-ascii?Q?tFtg1EtNRHOiMyU6yJIV54bcWAC19Ak8/8UH1uLP3NLM28nfl4U9mnVd62CL?=
 =?us-ascii?Q?7l4SeE83KHiOgSVibv1froh8rIIsNXy6q7imBgRkbBBGCcvyMio/GrPOVPMb?=
 =?us-ascii?Q?cfXSSwHucXnzv3BWDIy+4ArkO1zlbTUwUHmC0P4EAVV6jwiBxSLc2YZo9ohj?=
 =?us-ascii?Q?aPneXDuVZnjo7dB/uqoodQFhOrO+N3ERTXSbIPGq5MbqJzIcUJkTcLsHFo+P?=
 =?us-ascii?Q?RTAR8Mr8zZYc6kYiMzHW+8+RkmpXAv7FEufXpPvpbY7dBmFJdUrrKnEWkyef?=
 =?us-ascii?Q?cl0++u8bsMnquqPZ2SIVH+wWGjVhtvTo/UqQNt7HdixqUNm/6pqmxEyQIhc6?=
 =?us-ascii?Q?Zxh0VTADBpBSvDdr90gHnFYAWfzMI0RptNGMV/C9asVuBDzXvDx5nVFvW40P?=
 =?us-ascii?Q?KxeraOgU/g1MkcJnNKT92tOZUm3Yq5Hce+yn5DzM3Hr+6PSKBeGgl0gofPYn?=
 =?us-ascii?Q?7ySytbpN8w1KOmzmSay3TBVBAYL/hfc2Hw5cFir/oCziYl4DkfrQ2U/teY5b?=
 =?us-ascii?Q?psxpVIJBg4NQRBPrRs7P2X5L8UVHx1/gd21D9oBn5mSIvNcc0yq18ZCEYTUO?=
 =?us-ascii?Q?oYdMaeLRGyVVSJI/Xf2wujUuCCkN/GafCEdQUguX2Hhq+3cBTOv//ad92qiQ?=
 =?us-ascii?Q?xGoSWkbu1le+b6geCy5DCikgc5OqT+VYjzmMXXZxcvEVhxRBkEF17/nUxbO+?=
 =?us-ascii?Q?LhEmcNdzLrA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YwkMFgoSKeMgZiD8n47/KCwic6bMtVffm+nKol4YfYpcRFQFvOeMSdTq3tNe?=
 =?us-ascii?Q?NOkQrFyW2pvIFPlSWaPqmcbfYLQgOyQqGfdMUBYUVKCT+JTX2tVFCskQoj3b?=
 =?us-ascii?Q?QJpe/h7DN1A3vU9D7XzbzqeDdfjIOCv0mqx3n0dqEElxh9BXW9EvBHF2MqUU?=
 =?us-ascii?Q?kir9b7FiKn93vwGwhX17fFTJaZYabXJUO11LJwmkfO0eejLFnVE4R3ohZnVP?=
 =?us-ascii?Q?i5tP7OIcu+S9HDZBPC/E0iVVsvHKdkWbDkeYfb+d0DRIesjlmYpOFPz9HCxE?=
 =?us-ascii?Q?SIzIM7Zphpk2X7DWV5VeG6lRGoQ3AAf+kVxGFBrhGNkB6zXEf/1f5jBktErT?=
 =?us-ascii?Q?yJrj2/4Igb/vK2JtrIXoB/kQccmYvF3lYcr1YVCvZkraErt4T6jQ37NSGxxF?=
 =?us-ascii?Q?pamZKrbfnVX7bRsFk4zY58bhcpqGciOq5hwceDFwylSA2K09XelDZlV9ACPN?=
 =?us-ascii?Q?UOGggKin8ff1TbtJ9GG+dAXB/KuZ5Kp9J2x+hGuxBHIuN2LzTyEPGNgqqm/q?=
 =?us-ascii?Q?vyh/hmEsbtoMJD2ZmPFkPL5bDEcjvJenRIDr9l8RQIhwsozJvYy541pizmHt?=
 =?us-ascii?Q?VFSUYIJbzUdBDXxXDiH8IyVRfmeCj91CvTSuqMmP22bGkAQtmJuyWfhLTgtx?=
 =?us-ascii?Q?qUaS9U97Zgg4A8AUXyWoPe5pT2A4X+GeYhMDoLwgGeP/+6fMK5FGyUnSNU4j?=
 =?us-ascii?Q?N1qgkEOcimpKJT1a9+c2r0khsgzoR9ReRwSf7AGSWLUxHyKy9WtB4L8RqYfb?=
 =?us-ascii?Q?uoymihwsOEIFBifx+xmXv4V6K7wTYv7Gdw+xJGLnRc2kry9AkKqyZk52i1A6?=
 =?us-ascii?Q?bICZ3ngGlUWHuXwq6qwOXjg4b9Abnqts4E0y7ipq93oeqB1IxS8a3h2FVNgD?=
 =?us-ascii?Q?E0qcyk4tCncpm/bX85S6oNyySloi1dhS8O0TKzhFW4Brw+CmdGTKbjod9dme?=
 =?us-ascii?Q?64e1IVDP4wBBuVS9iNtWNv9YMuWVAuOznvU/QIM+so7QY8kYPW6pwfwxZ/cZ?=
 =?us-ascii?Q?g7UWlGXWjR7gqaW7I8k7s48aVWr3fMvNRkBvLx3IAt6kgMJZEYjNrck1dAPO?=
 =?us-ascii?Q?8iUvMti/CtrOUIC0Jgy1mPu/4U5Lm9eQCq+2nuxJdPEEM2zh40amdlTMcn55?=
 =?us-ascii?Q?1vK4pgImZX6YThu/MkhV4GThNS8csT4LNFCloAIozKpb7DWg2HzQ8J6ebcgp?=
 =?us-ascii?Q?V1CMz93tto6AwrHO7Y0d/em9uHGPgeliiDMtewhsmSdqpURgvSX5vY4rr8eB?=
 =?us-ascii?Q?AY3FhIxCaRR2eNaBix7jlGTlb1dN/Agkt374E7dqQ+D8CgMTxz5kZAONlZ4d?=
 =?us-ascii?Q?8FdvGKYYnFMolnLPoVTf2YNbLcBuHBDzsplgagV2f+G6aSf6ClnzrwMjYEEr?=
 =?us-ascii?Q?DdcqNY8CEIuYlk4hsHEcl74Rbx/q71TOQwTvXCAG/oGfS8mFbQFOnYvLZbJf?=
 =?us-ascii?Q?3fXenomqndjsFOXMtbADYERfpcL5VshRy7bRZveQbfNwKI1cO1Qvt5wMsECG?=
 =?us-ascii?Q?VFkJ1rQC/AqZT5sEGizCAiA+Y5EveR24O1k/LQf+ZVWkhXHcrZOAml0uZnmF?=
 =?us-ascii?Q?CPcBTWZiJ/n8uyTM0Aapb/QdzO69KQjsfFb8NHOy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 258a1801-7481-4cba-179b-08ddb8257bf6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:49.3564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eioRERF2zAY1Op6rWMpQ2i5gnOaUGyy3uDsHPw06sTacxYeAbs6YLvqLKaIWJbe0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

Switches ignore the PASID when routing TLPs. This means the path from the
PASID issuing end point to the IOMMU must be direct with no possibility
for another device to claim the addresses.

This is done using ACS flags and pci_enable_pasid() checks for this.

The new ACS Enhanced bits clarify some undefined behaviors in the spec
around what P2P Request Redirect means.

Linux has long assumed that PCI_ACS_RR implies PCI_ACS_DSP_MT_RR |
PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAIMED_RR.

If the device supports ACS Enhanced then use the information it reports to
determine if PASID SVA is supported or not.

 PCI_ACS_DSP_MT_RR: Prevents Downstream Port BAR's from claiming upstream
                    flowing transactions

 PCI_ACS_USP_MT_RR: Prevents Upstream Port BAR's from claiming upstream
                    flowing transactions

 PCI_ACS_UNCLAIMED_RR: Prevents a hole in the USP bridge window compared
                       to all the DSP bridge windows from generating a
                       error.

Each of these cases would poke a hole in the PASID address space which is
not permitted.

Enhance the comments around pci_acs_flags_enabled() to better explain the
reasoning for its logic. Continue to take the approach of assuming the
device is doing the "right ACS" if it does not explicitly declare
otherwise.

Fixes: 201007ef707a ("PCI: Enable PASID only when ACS RR & UF enabled on upstream path")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/ats.c |  4 +++-
 drivers/pci/pci.c | 54 +++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index ec6c8dbdc5e9c9..00603c2c4ff0ea 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -416,7 +416,9 @@ int pci_enable_pasid(struct pci_dev *pdev, int features)
 	if (!pasid)
 		return -EINVAL;
 
-	if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
+	if (!pci_acs_path_enabled(pdev, NULL,
+				  PCI_ACS_RR | PCI_ACS_UF | PCI_ACS_USP_MT_RR |
+				  PCI_ACS_DSP_MT_RR | PCI_ACS_UNCLAIMED_RR))
 		return -EINVAL;
 
 	pci_read_config_word(pdev, pasid + PCI_PASID_CAP, &supported);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index d16b92f3a0c881..e49370c90ec890 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3601,6 +3601,52 @@ void pci_configure_ari(struct pci_dev *dev)
 	}
 }
 
+
+/*
+ * The spec is not clear what it means if the capability bit is 0. One view is
+ * that the device acts as though the ctrl bit is zero, another view is the
+ * device behavior is undefined.
+ *
+ * Historically Linux has taken the position that the capability bit as 0 means
+ * the device supports the most favorable interpritation of the spec - ie that
+ * things like P2P RR are always on. As this is security sensitive we expect
+ * devices that do not follow this rule to be quirked.
+ *
+ * ACS Enhanced eliminated undefined areas of the spec around MMIO in root ports
+ * and switch ports. If those ports have no MMIO then it is not relavent.
+ * PCI_ACS_UNCLAIMED_RR eliminates the undefined area around an upstream switch
+ * window that is not fully decoded by the downstream windows.
+ *
+ * This takes the same approach with ACS Enhanced, if the device does not
+ * support it then we assume the ACS P2P RR has all the enhanced behaviors too.
+ *
+ * Due to ACS Enhanced bits being force set to 0 by older Linux kernels, and
+ * those values would break old kernels on the edge cases they cover, the only
+ * compatible thing for a new device to implement is ACS Enhanced supported with
+ * the control bits (except PCI_ACS_IORB) wired to follow ACS_RR.
+ */
+static u16 pci_acs_ctrl_mask(struct pci_dev *pdev, u16 hw_cap)
+{
+	/*
+	 * Egress Control enables use of the Egress Control Vector which is not
+	 * present without the cap.
+	 */
+	u16 mask = PCI_ACS_EC;
+
+	mask = hw_cap & (PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
+				      PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
+
+	/*
+	 * If ACS Enhanced is supported the device reports what it is doing
+	 * through these bits which may not be settable.
+	 */
+	if (hw_cap & PCI_ACS_ENHANCED)
+		mask |= PCI_ACS_IORB | PCI_ACS_DSP_MT_RB | PCI_ACS_DSP_MT_RR |
+			PCI_ACS_USP_MT_RB | PCI_ACS_USP_MT_RR |
+			PCI_ACS_UNCLAIMED_RR;
+	return mask;
+}
+
 static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 {
 	int pos;
@@ -3610,15 +3656,9 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
 	if (!pos)
 		return false;
 
-	/*
-	 * Except for egress control, capabilities are either required
-	 * or only required if controllable.  Features missing from the
-	 * capability field can therefore be assumed as hard-wired enabled.
-	 */
 	pci_read_config_word(pdev, pos + PCI_ACS_CAP, &cap);
-	acs_flags &= (cap | PCI_ACS_EC);
-
 	pci_read_config_word(pdev, pos + PCI_ACS_CTRL, &ctrl);
+	acs_flags &= pci_acs_ctrl_mask(pdev, cap);
 	return (ctrl & acs_flags) == acs_flags;
 }
 
-- 
2.43.0


