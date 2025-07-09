Return-Path: <kvm+bounces-51961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 929CDAFECA9
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E29FF6420CA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0FD72E8894;
	Wed,  9 Jul 2025 14:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LlCfk24X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D392E716D;
	Wed,  9 Jul 2025 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072748; cv=fail; b=W1cs6YVwyMuYfQbxIi7i5Br1XG7IJbZ8810BUsa8p8a72icD9vvaYFjc43PvQTVz9zxpinknNvVVSGpMSdodPjUYFORx3SuN0Vw+ZzFGDr53anYSMYdnbYdMFBAzasZfq5t5dDgdjNIntOn5GtSXNgHp5dOaVJ47adHXN/QDkXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072748; c=relaxed/simple;
	bh=4hI6SsvsV7h06iwWSKVcjODMFqPGT+FLddDvEbQFyPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g6NCccW0yXvxDzpRbCzHUqkqhouq/05Y63iZ2V1kxE2u1Fd78NN01kXgIvCfFkwwZQkjKiGa7UVWFyAyHgaz+YkryyC5c+4mHJm8BYSL1LRae7YHBvV1hyBzu8MI7ia5Tr6eKw+OhYtTetuq/Zg3/X2zXVz55SeN/0yDTl2ngRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LlCfk24X; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mVIvQ6wVuKMeXq3yqXyczbfyEFvdUjU+q5aXa4k+C3h+0sjHgWp+6XBpaU40FY0FQOsJmcrFBqcVodj4V9rVFZJQxr5URPGPaZM7fX9M3R6CEO6goHC6FYR4WcneWx/O2jKBqUJQQ7g0Jr+EVhElQDe/HsjjjgNkqev+y50OoYyVseUSdlcZQoGrZuW+QSjxuXI4riBix3xw0xQ6wjj+XQoMmcOu4AjVfqQxQLC5wXojizS5MceI3XE0xhQrY0J5kW3jKF1hv6yBQSi5Oz7Z2Pj4MN6CF4QudY+op2M7XW0ytJCRHrmuk4IljDqtaybx7hOEqhNtrF7frriCf2Dvmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46uUM5XuGdNNt6sbkJiTCFosCrbPxfnJiEvg6rvW5Bg=;
 b=GG7xpNTg7GvPmlbTDVOz18brmluP0R6Wmlzjawq7bETW9MmReDcQUq9s3YyhA21QcfJSFNI8oskzJ7Q/vlfeU5rQVeMSCNYSFCoK6yjVgMfHOMMU+znTizyI/NcUVKPAarJqCIFue/GQhJSb5tv00LiMFG8XFRZK4FRuv6laTy7rhe0OHo87lrBcHUWMKkbdt0ijKiJ036SlilpybK8lafOJ5kL8p+pl5JU8Nc1N2sRndGGd6yG5lgEX65DD9c5id5EBfhHVlvXS/LnhOuGMTLyfGhhjns8MX0TMjqII86Hx/Z2tCJPhfeqqemhk7XlPicXByrxZDT338pNuIfoG2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46uUM5XuGdNNt6sbkJiTCFosCrbPxfnJiEvg6rvW5Bg=;
 b=LlCfk24XBAN+3ha5pddvH4wQ/A5po3BfcErto2+iaFB4TTUmBoFyM5chxTHscazS5/uK9sUBNBTYR8EguEN6Dl5tI6Y8uxFa4KFXkyGURtH4rybHMljOx1aWi6B5wO4pgC5/sJ7TYWhFPjnH3DUdYV4xe4ZIRbNA+qTHfW9I9fjafmEpnKiv461s3jf39pUYyTB+Qhz6u4pV3x1fbY9th/bMwVKjq1qGLOxwl6j/8Nuh/rELroFHDZqBa45ypyMXJk9ajfnPWpjoM9fI2csLEMF5E5PWimqoZumQYHflbaFwViPFcDWmgS6wXygAiB+IVNztjlsOPPBCU0uzQwjIVQ==
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
 14:52:22 +0000
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
Subject: [PATCH v2 06/16] PCI: Remove duplication in calling pci_acs_ctrl_enabled()
Date: Wed,  9 Jul 2025 11:52:09 -0300
Message-ID: <6-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:806:28::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 98f3b927-526b-4929-5b8b-08ddbef8358c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AFKgxTmFRowI2ytTmYCjKr04tmf+88rNdX+fTVQUEn/25BGrzV/hRmekhlGu?=
 =?us-ascii?Q?6a4KnKFnarnZyWjXUEOexMf+N0obbU4m6007TWKUwrc4RTK9awt+O/9cgYIY?=
 =?us-ascii?Q?TQCp0vNK2i3CvbvtJe/EPgICLwFlcq9B5s17mde8WF+PH9Z1Soq9j8Fax2WA?=
 =?us-ascii?Q?mjQ6TPQut+I2zG0bJPExAJvOxZuQbYAxYxKFU1bGcxaJN6WqS2LQAqUN4Pyq?=
 =?us-ascii?Q?e6TU57k5VTIdqEJYNnSuRtidqzBO9gf5X7shQPt5lyu4HFt3WyavYvBoA9Pn?=
 =?us-ascii?Q?gRMOqGvK3BXO7opE25OtzrwiivjYTzDE7rv5y0dTiWW16iOInhNmjtzkuLvL?=
 =?us-ascii?Q?D66hmGgGL9ipGhfxpRjqfw0LqDOvmx17QyszYW+sl9eQelye1rV6NMY2EBZe?=
 =?us-ascii?Q?0eK1BObY2wyCoQoNhgpsJ1akjEKYg3sVcaWdO282CtXPyfLivRD35gqecwpZ?=
 =?us-ascii?Q?XyVaeg7OeI5ev8Kv3+Y2cOz8WjfCnszOeGP4dRunujGBOoq6ztsuvjUw4B07?=
 =?us-ascii?Q?rXUwF8R5eARAJxnj5MZhtIhw+14W7syXRVBOhWjV2uIPly1EsvLf+01zfnrq?=
 =?us-ascii?Q?UAIWzP5bIHqy5FHF+Bt4g1aDHv0lwKBsprXorP4cALWW89O6O5KhQK0CyTMG?=
 =?us-ascii?Q?wBTRkO+4zGtSoNoCzKPsUcBSK9tW6X1O+i5aJbCjGXn94EwbfRW+XJyAPjOo?=
 =?us-ascii?Q?VZSUQjN92vTbgZQIEI8YDM2FbT5ojOhfdepHBCXvbQu0D4ink0SuNFinTZ47?=
 =?us-ascii?Q?7p8+C5Wr8AMnz43V3By6bcj9d38MeaKroS4DvhB/KN6sP67cbcfmmJ0ylh+8?=
 =?us-ascii?Q?jjIUqoulyZ2QbgRraqcTdTvhSRj2JW2jAr002Mkil5zjQ200YzUYbNUpPhdv?=
 =?us-ascii?Q?ODbhQyah37jAC04+W5L1s0cAPfkqLZAKov/6nNsERqZV62y/sdSKRGfW4lcK?=
 =?us-ascii?Q?1AfsjUbuKeyuqt5EBQF+tTUvfhVkvICBskpC209A9HHFQq41mOr+lg0CHu5s?=
 =?us-ascii?Q?E6Cslsfin/YxEvQcfREOkX+lvJCE5PrUnBgP+mk3YddT/rCCjw7ceLpQDNQr?=
 =?us-ascii?Q?8yFFNfT8L9npbgoySriwEkulAe3bQgdYShzVS8MaGYrWerOWpnPzUQVGdQHk?=
 =?us-ascii?Q?SPEl9bJ2waNuiKaemdx7P8NMcw2TOzClXdN+H7yeyK2FjrGTYRy3Hexlm9U5?=
 =?us-ascii?Q?DIcpyFseABTzZMbsM6AY4cjCuY9uH9wUdVU/v1NDrJwr7TAxGF92CTW/1Jag?=
 =?us-ascii?Q?t80TcjiJZTIp+F1fXkw6r3OuconSVWnKJ5bL/U10YFh0edb4fUlWybdK5ca6?=
 =?us-ascii?Q?S8XTDeuzgGUGbqb7EGcWsk5lxjit1beLmZXEsZSqT88XHvYEtM8zh3NZC5P8?=
 =?us-ascii?Q?NBf970na+U9OrU7Bw/qOh1bWh+ZbJ2KeFTNRy9NI2wTldT50DK7nhkyOV4Fd?=
 =?us-ascii?Q?4HNP/lGcrfU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KKPT0800k3L/TSdOd2TFEKDmkJSiXQx1+v1GXIiS6j5slTi7w6zxhkD/QZK2?=
 =?us-ascii?Q?BxJ6DS0ABAOe7mfL90HZpxBtp+3ULIsjtP8tE+Fn+oN/tYnlGvqC1U85C1jX?=
 =?us-ascii?Q?mAqW1czj+/7sKiDySboeg+XVvgdHIYiSOEZAgCTpfHnCpeYfUuUQAJTrAbkO?=
 =?us-ascii?Q?YdgZ/MPo4FlWukSJw2ei/iMpLZZFoYlAFX3rfhYQ7+OBUALBGAb+5oL+rr9/?=
 =?us-ascii?Q?OtWyX6KDbPVGdj13Z8pCQeeRWZSELndOztrPGTeEJ0uUp559noMfY0aR07a2?=
 =?us-ascii?Q?9E2iEYkwD7Tw++esyK6QnwILJEfatMpL2NH3bl1wNLylND1A5tTmziVxv2/G?=
 =?us-ascii?Q?L005du4MfrFX8dJbx85rMQqIYZGbagT3KpHVZoZ9s/BhHHkyojNfR9ypr2xD?=
 =?us-ascii?Q?8E3H9l5zgLDwgPacY1CUQcmaP1Rm82LRv1PzS0WeYS3lNl4baOdATSlXp+dX?=
 =?us-ascii?Q?CIngwD6nmkGmLo5oQnEBUlY/WwSuAxPOO35ldji3lSvcGGdwmL3pLABNW+/4?=
 =?us-ascii?Q?nyLtykI56URG9vWYfzAyk8PfCfpMRltcENnBFOzWch3q6uYSmbyBNePQ2o5Y?=
 =?us-ascii?Q?x8Pu3Kl/XhN8n10Wl0BSdvWedcH00/8+C+kWvY5ugj59fTrm7THLOFQZYsO1?=
 =?us-ascii?Q?0VOHNEjbDCexdHOzQxH6jlGbvlw+TzKiVc9l5IgLbV8ehctCFuDKahCWn8tD?=
 =?us-ascii?Q?9EIt2Ylwctbv61D6YrIGFFN5eD9jZqEgUUqt2Gn3vJYYnor3VPVXdNc0hrmx?=
 =?us-ascii?Q?1V1mXkFi6tdF9pn/W2guBZnwqspTBlcS0MkKO/u6a+KMvSNWWd8dmWRQYxzF?=
 =?us-ascii?Q?awx8QooCJ9p76yqjrYpWXMeEwra2haTooFLD2Xf6p9yj2iRMgCz63QcOl60E?=
 =?us-ascii?Q?Dip9H6osW6PTYPfbKKB0XgcCLjp9T3l4hMSgmOtq2zsloAeAXL/gtacaLHQH?=
 =?us-ascii?Q?8T88iKjCH9BINHEXvbDqY5TUWa9PW5PI94yvxWKqbEZ7vnRPFZlVhjGQzQlj?=
 =?us-ascii?Q?ez4mWyl2IC67tOJHAPy75Ei9u+Y5laXaoSFEKl0JRKPywXI/QzkDc5LrhpsV?=
 =?us-ascii?Q?LqNwqfUUy1lCWIhMYf6nHgXnK7hYxG5zJsyuKfFuTxQAZ30WCUyuqRoapi+s?=
 =?us-ascii?Q?YZZe5bVowyb4m0bE1p5Ut5w6qHQ3G4heUFT5Q/+HcPymwflh2zSFyX6jJAIp?=
 =?us-ascii?Q?Wsim7RzUmMVYYupxZvoiTnhBagXzpO8/EhlFN6PnOH1VQOAA7Hhf9DMy11Nt?=
 =?us-ascii?Q?GDyXQmyP3RjHiJ+aogtDuHgBzlZPSD1qUT53GA4JPmK2p6AH+JTsf0HDMIP8?=
 =?us-ascii?Q?j0HscU5Nd0eM0RZpjXYe2rHAiRG6o5sDhLvvkDQQTg22FmNv1Sf2Nl5Y5A3U?=
 =?us-ascii?Q?mnIq4Zgtla5mcLDABeFGVchRve+EXqmlS/lvs5phfobCGpttfZqRNJL4eRJ1?=
 =?us-ascii?Q?FZV0yCIg3XpZUVy+epCDZ1MMZZYSk+NjFDvuy9UtPWKiYJaa7paGJjHsaMlV?=
 =?us-ascii?Q?V9rZbPsHPWCAJYSUqSgWMyRnPDzs2x+SiBXpVTaIxYLCiTHprZMt0a2Z6d/5?=
 =?us-ascii?Q?xPpRig+qH2BpR0o7LUTeZlTvx4R4TZ+8A/pUdeHH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98f3b927-526b-4929-5b8b-08ddbef8358c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:21.8657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FXRdHlp+FoNfRWzBUWNBb0K2bCmcRaBb5/+ZpVkztVh/i6EXond3roMUhISvOGyI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125

Many places use PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF
as the flags, consolidate this into a little helper.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/quirks.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d7f4ee634263c2..8a9ab76dd81494 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4634,6 +4634,12 @@ static int pci_acs_ctrl_enabled(u16 acs_ctrl_req, u16 acs_ctrl_ena)
 	return 0;
 }
 
+static int pci_acs_ctrl_isolated(u16 acs_flags)
+{
+	return pci_acs_ctrl_enabled(acs_flags,
+		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+}
+
 /*
  * AMD has indicated that the devices below do not support peer-to-peer
  * in any system where they are found in the southbridge with an AMD
@@ -4717,8 +4723,7 @@ static int pci_quirk_cavium_acs(struct pci_dev *dev, u16 acs_flags)
 	 * hardware implements and enables equivalent ACS functionality for
 	 * these flags.
 	 */
-	return pci_acs_ctrl_enabled(acs_flags,
-		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	return pci_acs_ctrl_isolated(acs_flags);
 }
 
 static int pci_quirk_xgene_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4728,8 +4733,7 @@ static int pci_quirk_xgene_acs(struct pci_dev *dev, u16 acs_flags)
 	 * transactions with others, allowing masking out these bits as if they
 	 * were unimplemented in the ACS capability.
 	 */
-	return pci_acs_ctrl_enabled(acs_flags,
-		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	return pci_acs_ctrl_isolated(acs_flags);
 }
 
 /*
@@ -4752,8 +4756,7 @@ static int pci_quirk_zhaoxin_pcie_ports_acs(struct pci_dev *dev, u16 acs_flags)
 	case 0x0710 ... 0x071e:
 	case 0x0721:
 	case 0x0723 ... 0x0752:
-		return pci_acs_ctrl_enabled(acs_flags,
-			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+		return pci_acs_ctrl_isolated(acs_flags);
 	}
 
 	return false;
@@ -4814,8 +4817,7 @@ static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
 		return -ENOTTY;
 
 	if (dev->dev_flags & PCI_DEV_FLAGS_ACS_ENABLED_QUIRK)
-		return pci_acs_ctrl_enabled(acs_flags,
-			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+		return pci_acs_ctrl_isolated(acs_flags);
 
 	return pci_acs_ctrl_enabled(acs_flags, 0);
 }
@@ -4832,8 +4834,7 @@ static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
  */
 static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u16 acs_flags)
 {
-	return pci_acs_ctrl_enabled(acs_flags,
-		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	return pci_acs_ctrl_isolated(acs_flags);
 }
 
 /*
@@ -4844,8 +4845,7 @@ static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u16 acs_flags)
  */
 static int pci_quirk_nxp_rp_acs(struct pci_dev *dev, u16 acs_flags)
 {
-	return pci_acs_ctrl_enabled(acs_flags,
-		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	return pci_acs_ctrl_isolated(acs_flags);
 }
 
 static int pci_quirk_al_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4975,8 +4975,7 @@ static int pci_quirk_rciep_acs(struct pci_dev *dev, u16 acs_flags)
 	if (pci_pcie_type(dev) != PCI_EXP_TYPE_RC_END)
 		return -ENOTTY;
 
-	return pci_acs_ctrl_enabled(acs_flags,
-		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	return pci_acs_ctrl_isolated(acs_flags);
 }
 
 static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4987,8 +4986,7 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 	 * Allow each Root Port to be in a separate IOMMU group by masking
 	 * SV/RR/CR/UF bits.
 	 */
-	return pci_acs_ctrl_enabled(acs_flags,
-		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	return pci_acs_ctrl_isolated(acs_flags);
 }
 
 static int pci_quirk_loongson_acs(struct pci_dev *dev, u16 acs_flags)
@@ -4999,8 +4997,7 @@ static int pci_quirk_loongson_acs(struct pci_dev *dev, u16 acs_flags)
 	 * Allow each Root Port to be in a separate IOMMU group by masking
 	 * SV/RR/CR/UF bits.
 	 */
-	return pci_acs_ctrl_enabled(acs_flags,
-		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	return pci_acs_ctrl_isolated(acs_flags);
 }
 
 /*
@@ -5019,8 +5016,7 @@ static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
 	case 0x1001: case 0x2001: /* SP */
 	case 0x5010: case 0x5025: case 0x5040: /* AML */
 	case 0x5110: case 0x5125: case 0x5140: /* AML */
-		return pci_acs_ctrl_enabled(acs_flags,
-			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+		return pci_acs_ctrl_isolated(acs_flags);
 	}
 
 	return false;
-- 
2.43.0


