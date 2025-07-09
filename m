Return-Path: <kvm+bounces-51960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64289AFECAA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 061E21C43CB0
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CBA2E610F;
	Wed,  9 Jul 2025 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dA1Zufub"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEA92E5B21;
	Wed,  9 Jul 2025 14:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072747; cv=fail; b=CgnJQ9mYdb6gOg2JaPckpwydzdwjQvn/T29sJK/mBivqSZqhvUQmFhKSYC0wM7iuZKRhkvS+B6LDSGIpS/1P8Ua5AIEYVQ3pMhEe8GPYj9oP5/+JuFfPBWpglEBSo+Ve32goNmQtKU1oKVPQM4ldXeGWsGYXuR3w14Cq2+6ZU4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072747; c=relaxed/simple;
	bh=t8ZRLT4dAOJoi9qYvcz1aLUiTR1o0uH4yxQ5NuejWNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a3HnhrEdCCCGCCObY8IqEsukl//JYIyEqAgkMqBAxdarxKujjJFK60FRhnDfljTdaA3aSEPbH4l3umilbrJ19n/ZpPA36Qqjp3ejqfdFryHGxF4ctOnuYtubbcmu0Y2U1NBZsgI4+lX7mIYfEOWZS5xEzTVxAUQldQyRAhW1Vgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dA1Zufub; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W7vi41HM7bJilrfpHThb4ki5v4EbsMxJPk0d9KzP/uGQL2ZYiKtE5LyRdTVeZTwEByvWxUzdvMd+7bIE/tz/8zt/CBa+GYomZnxfr7zpPJ30EHN/jpuCCv23LtA7CIohElx09+EivZeI6SsgLlmwn+1yWDEUxG/lrKpHS0zxPg6h5d+DonCFYJurEakwhp0fSG/Q12FFGWTw3TvFfLVj8ecjcWLFlbkwuwMHRxj5E9Fxe673zN6Ryb9tzL8bgfFI5wS7AkfWRaNbgnnOg+FENtgRocM9pTahNTPvezYWYgjrpCrrqFmOzTtbg41TGtfZsaU0sX1KL2Uh2jl4+R41FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bShY+QBOEsWJJnJ5ZfAAWfxse45J8OkKk4hh6OQaaUo=;
 b=zAO4yv8LxYzlnCrAXCqa43FVIbc81FOALtY6t6e6soBjsNmTM5vHRuXoP836ehEPfoHIB/9MDuE79UXNkXYpYbYrTW5ZjcT3jADthhAgADRc5Wu16eDCBUcnG+PCELF6XE6Smtj8/1aJ60SbMoKC36YrTV7uOpi1aZYjrKXiwTQRClYlBBFtbfLBp5/GAxzBQTFv1wCOH+2LHM3CWiK40v7MCiowX4jbhD4Ns9DmQYYJGj9s1MizemJmo5dff6tAOimXN48l8RZaRxZEkmbQqyft43xcIhoJOGugHiXP3fmJHqfB7cXAphKGg6B4PMWSf6aqaPGLpaWjNK2apDZVKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bShY+QBOEsWJJnJ5ZfAAWfxse45J8OkKk4hh6OQaaUo=;
 b=dA1ZufubZuq+9/tMIGC8MITVRggUjwHiLKIpc+RzRp70DGiJkx9rRC9AxOGKH7VlMVJSGh/eA0Rzbw0/KX7zprgpnkJUw0wBIvRbzSrBH7VbtDA0x/A5boQr9P3SbTcql+ISV4aotuMMk6han3ZL2+LVialPUuv0Mye/GBYLVtqRO47KNrn0iHb/2ffRXUgYRx/UxHBgwRnayQLNBBZdhgstskB6RJgdjHNIzItFUKbRQ4H33EM0eI/zq1lBv/ivt2eygjQEoB/BPkXd1b5z/2ONpyITMNtqnqpBPiNogXMy/nrYXfzfSDTNKfGd48aYnFtzJ0VEblVnutFU65lUbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 14:52:22 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:21 +0000
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
Subject: [PATCH v2 01/16] PCI: Move REQ_ACS_FLAGS into pci_regs.h as PCI_ACS_ISOLATED
Date: Wed,  9 Jul 2025 11:52:04 -0300
Message-ID: <1-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 756b77a7-07bb-40eb-3b44-08ddbef8357a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2eUiFb4duytLcGCIy8dPVjwQw8o84zSeflfj+SyivsmCIgjCyT+PvfjkhJUk?=
 =?us-ascii?Q?d6NQqc6polO1PdgKLNffUV/WjteKJTJzYp9lnT3tcT8rdmlTY7GbU76uql1H?=
 =?us-ascii?Q?pHJNmhax6OgDV2Cnalb4t82Ju07z8jvkDsA571dN+iKawWkfAAV4xDITSsyJ?=
 =?us-ascii?Q?T985u0C1Gd1hUsKZUjjop1zFRuoojPjLjT6WeksV7EZBGi9Qg4zkL7Yo9vpm?=
 =?us-ascii?Q?Rc4a2QGJW+hOfmqxHiZJ/XEP3ef3qC1raRPWMqw79yVc87D3wftQmly+SWVY?=
 =?us-ascii?Q?U8CLgS+9Wb7rW84TsRYE0913c6M6h6SQ/Lg3+xd+oqFSVBpQwNBeBJ21MfVs?=
 =?us-ascii?Q?ji5iQjk3lbIs5qYxDwurGAi19/uZYw4T9HrcZ2B1Y0hjXNKKkusLc2CHeEoJ?=
 =?us-ascii?Q?dfUWpcvuEUtUSof0QGX/0IPOLulfLrk5c1xUvjltCgLT0kDcEe5ANwm2WDtZ?=
 =?us-ascii?Q?K/Cc36VJXlcQPwQgtQ815yAr0tFGC6ORpKrTAyfWN5Qu2U+UrdzLdgpSNFWg?=
 =?us-ascii?Q?mwIOVM5LlxCdyJN6Xj/SANUD+ZVz8yLpwoRIYPxgwa87LYbofieF5L2q1Sly?=
 =?us-ascii?Q?4EifrPB+gSUF0VyL8BFvtKYQdudvQL/+fxUb3dYxQwDYSbWYZ7Lrn5kRUZzq?=
 =?us-ascii?Q?zIzJ3HJlAPDFB2x2u1S9IWFlqkRX+zAEkQ3+Rz5xQqiFZitXy/7ToatYDA3z?=
 =?us-ascii?Q?F/CwudiE984UXONWjy2/I8i7z+5UQYbHhFGXL6shGmsJnF+lLxlHHOXW1HRp?=
 =?us-ascii?Q?uwNpjDI2DjWs87jv928+l3Sibvp6WF7hku0h4/zXwZVIeXltWoMO06YAoowZ?=
 =?us-ascii?Q?35Rj9th9YuFjFtB+XchQCO6unrQpTCAGUEhnuBl5UgdV3yAWP2CVgPLueATY?=
 =?us-ascii?Q?fJV9N3drF+wNPp+CaBxarvdEkvu0NEBksgRJ4Z1p/GHNCykskyY6rLP/mXK4?=
 =?us-ascii?Q?UhiKAL3oCUSeFUYf6LSZq/ug8fEQVa104cPZ2YphLEMQZAzYekz4C+XR+7ch?=
 =?us-ascii?Q?1SOhgdQM9be7RwR6VeYisygyudCMu5NpiIiFipNT8h4skjA0GrE2zqTuwYTs?=
 =?us-ascii?Q?kIgCbS7LdBqVvSornclt/JhPERJOH5ZTKKDiFe1z4saobLWvfQXVZT88kDIn?=
 =?us-ascii?Q?KLFlMgjb7XBkgMrBn+b7Wy8GHYPOJRpg00H8qkM6MbqZV49h5EpbiG44ROiI?=
 =?us-ascii?Q?eGpdySJqezFwzBAowHUaRHfTBJBgycEYwMrfVrcG3p8CVn+N6Bi3lKd9thaN?=
 =?us-ascii?Q?gsw25DXme2glYszoxzkSeQkj9ZPfilRkYF4wpvaHO0wAQZ9Ol6n+YLmSB2jx?=
 =?us-ascii?Q?N6phgKSm75VSszZXLn34EzSDkjs023Vgo15NQk0MYjO2qqIriptO9OKvDApG?=
 =?us-ascii?Q?b8v4jvJF4MkL9ImBvplNPKYpsVz/I05Aid486gTXYVQVvtWWAdIxCj+BW1gN?=
 =?us-ascii?Q?LM6yfbY3hzQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w6+OqMOdLZnefIyxChiZGcw7oCbiuEe+XXir5HeEcWQTRNBkNBwwvv9iCdjA?=
 =?us-ascii?Q?4h6l0+loIOiOhdob8GYaCQn+7/zEtdt299aLSNhoxCtmlPZh2ybxH80Y4+3A?=
 =?us-ascii?Q?+SfhkRc3tFI/Le+yEPPT/iLV6xs8QsYJ31r0ETiHYudy/vMhCJEbDaGtzHzc?=
 =?us-ascii?Q?afCFSDUCeTio3KnRxDpQRHndjTnuKUGnDEW61WeL5enapCNUGh21uENoUdD8?=
 =?us-ascii?Q?d3MP52W0e6XJr4HixufyuUpFZoHyvDrfDnqFlZBb1B7GSgktIwkA11yRtWX/?=
 =?us-ascii?Q?stQXgMEIVI6pT4Sx+ac3ccx0vvb1dH4rNCriAo3auWTVODfo/444B/NKj/6X?=
 =?us-ascii?Q?aUXReKoY6aj1JE6UHIXl6qIMjS4NQKmsEnrbSse5Sykz8uBHR1nZZpb9mqKP?=
 =?us-ascii?Q?JMFAknJA9vBSY125uz1ieGmUiXlBTA2BzGPhkg0AvWJjU/zLRdzDcOaLWDQG?=
 =?us-ascii?Q?bwF0zLuQeSA8hgVO4qnhgTGUNEl3bqIPpRpdqk6oA8UJZt8JniqOYvFMYfKk?=
 =?us-ascii?Q?g0xKnf3vpyHon2VCKa4JZGSfLSQzuBXwuElUakckoJ1xGIa4Qgg6O1wLkjxE?=
 =?us-ascii?Q?Z4JVO9yxWcSholzJO+vfaR58Hu2GhQP2nu6TdlnkicU6kpGp/AD0/191sMQh?=
 =?us-ascii?Q?Vlj8HMEfbR5zXqLa9LTa+rJFJ1Y+54yi2oVaNuufYhX77Ua/jqWxH9adeB3s?=
 =?us-ascii?Q?3AALMCpIUwtAiiO+DYpiHp378QrX6UG6j589Ho6ODt7dD5WEmJPXTeOpe5Cp?=
 =?us-ascii?Q?0hivqEF8C6WNvrunTO+HKKzsDYdJtUVkVvitDXdvtNd35Udu74CusM1jO77L?=
 =?us-ascii?Q?BXaWDMEbAefSAtZSjdFZ2TINBOyxum/8lECiAKSu91M1OdP/8XXnNLV5ev6W?=
 =?us-ascii?Q?A8t8qH0wWxcKNqjRVjOQ708xtnNGEGNUPm9khvqsw+wA9KuPbousg40XkNPQ?=
 =?us-ascii?Q?TEfn1B5aKARJT78TZxMuXKoOsS57nEXfuSWkcGcFPDKT2o6IQip3EamEfz2J?=
 =?us-ascii?Q?3PTIsxk4t6HetauqwcSnGGIpqH79q4PyxfiUH/uL07XJsiUQQZNHG2vrNJyS?=
 =?us-ascii?Q?7YHEsh8BYdzQnMOt0gAr91GwQCDGrLxaVoMBS8CEHS1hKItv3ozmZMjn+vbV?=
 =?us-ascii?Q?dOW5fCq99FeF7ko3eAO954ScZczcIrXMLbNZD+T7JluCdIEPr775epo8xDk9?=
 =?us-ascii?Q?mcKuNnNRjZzUEsQEuZIp0B8+kz1ckwcOIF7eg/fQGZWmwAa9EBGDeFENkKs3?=
 =?us-ascii?Q?9SzEZv0/GhrfZW6qP9yMPMQVdDo4PTleNLNP12jLkxsKFdilUA3vLaEfT3Xz?=
 =?us-ascii?Q?DJv48jxKoOyd6KczLoBP41HLp30MyXX2WYVIRlukO97Q0wXXNVDdyST4FxOB?=
 =?us-ascii?Q?T9JtYE0Z1hwK/3BcpNDcH8nyRHqujzIFrjnKMJ63Fid4dPCUXwJYw1IDJ1wr?=
 =?us-ascii?Q?dvK5BENyFahad1waraYZlT8XhrjCssUkpNXbDies3OamJp9X4VlEzBanR+XD?=
 =?us-ascii?Q?1+oCsZPw2IDpuO+Y3RK1ikatnGtWNvc+isYkR6f3wKB8gOVHbz2Qsg2ttCZU?=
 =?us-ascii?Q?fU05nEtcGT5sy8CrmiuC+QLIC3EeEzSA2hgaCvWE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 756b77a7-07bb-40eb-3b44-08ddbef8357a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:21.7411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: goAN5JMztkBEmtUNpTZo8i9ggD6cZdZbkJZ1C/Ju8dhG+odOo6K3s3xV9yhEOS/S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125

The next patch wants to use this constant, share it.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c         | 16 +++-------------
 include/uapi/linux/pci_regs.h | 10 ++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index a4b606c591da66..d265de874b14b6 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1408,16 +1408,6 @@ EXPORT_SYMBOL_GPL(iommu_group_id);
 static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
 					       unsigned long *devfns);
 
-/*
- * To consider a PCI device isolated, we require ACS to support Source
- * Validation, Request Redirection, Completer Redirection, and Upstream
- * Forwarding.  This effectively means that devices cannot spoof their
- * requester ID, requests and completions cannot be redirected, and all
- * transactions are forwarded upstream, even as it passes through a
- * bridge where the target device is downstream.
- */
-#define REQ_ACS_FLAGS   (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
-
 /*
  * For multifunction devices which are not isolated from each other, find
  * all the other non-isolated functions and look for existing groups.  For
@@ -1430,13 +1420,13 @@ static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
 	struct pci_dev *tmp = NULL;
 	struct iommu_group *group;
 
-	if (!pdev->multifunction || pci_acs_enabled(pdev, REQ_ACS_FLAGS))
+	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
 		return NULL;
 
 	for_each_pci_dev(tmp) {
 		if (tmp == pdev || tmp->bus != pdev->bus ||
 		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
-		    pci_acs_enabled(tmp, REQ_ACS_FLAGS))
+		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
 			continue;
 
 		group = get_pci_alias_group(tmp, devfns);
@@ -1580,7 +1570,7 @@ struct iommu_group *pci_device_group(struct device *dev)
 		if (!bus->self)
 			continue;
 
-		if (pci_acs_path_enabled(bus->self, NULL, REQ_ACS_FLAGS))
+		if (pci_acs_path_enabled(bus->self, NULL, PCI_ACS_ISOLATED))
 			break;
 
 		pdev = bus->self;
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index a3a3e942dedffc..6edffd31cd8e2c 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1008,6 +1008,16 @@
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */
 
+/*
+ * To consider a PCI device isolated, we require ACS to support Source
+ * Validation, Request Redirection, Completer Redirection, and Upstream
+ * Forwarding.  This effectively means that devices cannot spoof their
+ * requester ID, requests and completions cannot be redirected, and all
+ * transactions are forwarded upstream, even as it passes through a
+ * bridge where the target device is downstream.
+ */
+#define PCI_ACS_ISOLATED (PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF)
+
 /* SATA capability */
 #define PCI_SATA_REGS		4	/* SATA REGs specifier */
 #define  PCI_SATA_REGS_MASK	0xF	/* location - BAR#/inline */
-- 
2.43.0


