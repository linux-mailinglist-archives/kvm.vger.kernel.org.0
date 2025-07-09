Return-Path: <kvm+bounces-51966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CC8AFECAE
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:54:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8BCCD544EA6
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2AF2E92C3;
	Wed,  9 Jul 2025 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i3jxUiF4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFD12E88BB;
	Wed,  9 Jul 2025 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072754; cv=fail; b=M/nf1wSUyJX6D4wxyHs5DwTjw6+zIUwW5b5tjc3j+cXCOitVnvwmm7L53NLsIQ/RAGauFi9QgA4K7B/lIVq1Jdm7KDd4Y+1e59QxjoUojkk8fmKYGYUeI2Wri56PFYtMaZZu4MvjN3WCPrNbaTuKdw9NluDK5PoUNDdJoIx3FK8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072754; c=relaxed/simple;
	bh=w2dO5Q3NygYiGcU+DQU9AKzM4BryCrhbdKcJfSotd/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Mi2y28YKVPEbIGWP4vB1z/P9RL0XlIxBE/kFjP+u34xd96D8mPg50USArtXO6kmTcQOPXpFm4P7vjbEsYTl6nVnEikEDBNpPqjSA5JHKtZsRQCX3TTtdp3MWFQUQs4CIN5RRV5OmM2hFbD359pyhJkLwd/KoTjQ8x2klaZCLBHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i3jxUiF4; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V4nBIsWLawwjMlXujcQ0mo9Cot+DGeQpyd8kt4W7BjdtB4oGh8xt5uEtUL5zW+PtwXEJOL2TJdLbsulx+j9krwAtxE0TlU/AUk6f6B092CMmIvoNQb9OOstiu8GU8OjQnI7jVTGqGpyHVHzK7B3hxx6XtyN1jIcZebWBrS0p3egMcPIlavawk8B6GqbJXb/0QnaQK9AV48lymjYpCgHF9ppMiwCMEGTS0DK4aZx8BHy121dYr1kAPoSZAhaUXJNB0G6MC5GPhozurcrRW6qTVxKLHM4zIQkEOpjRW+K1mhvNXlyq3gRdAV82oor61GqHesCEwCDcoCVNrGNpDqfGCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9eChUcLElPLXFp8Y4tChQPK+79mOueTzGDxAPi0DicU=;
 b=McWpTse0THyqRoiwAvG9iRWRCX07RiMVlJ1U9ttw44IDLMcJHmsnDt7XWJqir3dvU9UB/e0ejsyM3mO5IFXC2JHrm3V4Kzrc2iOpQn0RRG2jSKzmNLGiao9r5ln2xoaBOIXqfv+mzug47mLLzgV0H8sVSaytfDK1sTk2w7eP9NCbYn32moT4drQwiLlQKaBy1ZF5UIX81bq7d/s5ZzD/ikdinn6pDKcam8RcDfdTBgrZydLjqMiOfFKQ3fuhqFAf6Tk9cx6ZoXURqiJGE0nI2wNKzyGmVoICvgpxn6zeLZH/DuNlM+PbJlNzX6ZCDIWNab7PUcL5anCLoDnl4eAJQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9eChUcLElPLXFp8Y4tChQPK+79mOueTzGDxAPi0DicU=;
 b=i3jxUiF4tEfIO5KZ1VKDiICNADZxlOBBATkHKPCFrCHn+KN1A5oWPcFaoM98HcpXyjxFn5Ia2CvVjx7YqGfMedMZba3+ifrDDZNWij55d4b9+SKtYBXIkrdHtNbbbuXQ5WobUO8SLiUGIHa9nOjB6ISvVfDEqaQ+sJTnv9hy01lr5TnMTr+AZAw6Z0EEuiQ7YphiP5Be/K5BMWhuJJ/WyXIhhz3hgyTNlbPTnUek54sFBuYzPlI5yJSt6K7wQrAApC8udYkLd4DRYDAbmFTOY0qPxljSLipwSfwRUxW+uAVoyhHLsgk5GSjvl+1K0SbcFo4gZ5mKl7woOW6Fv9Gpng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Wed, 9 Jul
 2025 14:52:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:23 +0000
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
Subject: [PATCH v2 16/16] PCI: Check ACS Extended flags for pci_bus_isolated()
Date: Wed,  9 Jul 2025 11:52:19 -0300
Message-ID: <16-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:806:28::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 81115552-b875-4807-01ee-08ddbef835d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4n289W9yq3oaapTogA6qFq47wPg1TpiTlyvmK+Nu7Svs6ljaLHCBpLYXMjlp?=
 =?us-ascii?Q?kMOaVzqkVGTU1sYhkoJkw72qcUaiW5MFF0GJ93PMSExbNAzQEmHVqCfQyB9m?=
 =?us-ascii?Q?ZoykwN5+XHyeykLPNmv+uhaN/g/tRzwrL/TpNKF8TT4NfXSvemlLwzk2PYNa?=
 =?us-ascii?Q?vHKxZVYYPlihrw53dLAk+wYgmz1PJocQYb4EDme/aElnWMwa1idiBXQq5kq6?=
 =?us-ascii?Q?7Dt6EusS+tlB7Xae7B22nQ+BaheaMgh1q7y60U8FVf5zqlZluFZOKomFVk5E?=
 =?us-ascii?Q?zYv+hay8XT5CjTVF228JxsIqs7dUTPxlTtiXv9WgAq/T4/LyXkZXgNm+Wqc5?=
 =?us-ascii?Q?TzYYTL8kvuhdcQEXYWRr8mT+nW5de4ipyCBEjHJbN6jRNMBRIussg08Pb3Ho?=
 =?us-ascii?Q?UkEASMTQc6jW3+UvhyAnmajfBhJ8L9Fv+IgIErOdqqa+6MDlPoqjNH3BT7Rq?=
 =?us-ascii?Q?mn/EyoHKIEbm51z4OnJtUORCnfQEMcvdhohjnq4gzov/tg3pcI6ILz/R4uy5?=
 =?us-ascii?Q?rNX0apuy2571Z3CfyWlT/ltbatkoP1+P7QS4UPZ0qzEekOcFB/Ghx3WoipIF?=
 =?us-ascii?Q?RdA45QTUhf2Cbz9yH2Ygpc7CL0e/q9VPuKwV/MCrxg/ELEedhVvnltHg29n2?=
 =?us-ascii?Q?b24BLih39orY8rX5egLXcYZ6L9uG4JH5M2sd6TiXK6mWPdHj/JpNDsQIaKMS?=
 =?us-ascii?Q?ARMgsRvzND91uM0CgHXouPkkj5VstP6/ZwzRbcE4j5OmDoutYEatWfJR7oAi?=
 =?us-ascii?Q?jb7e/53/L9YraP3RTC8A50NlfapPWANDkk2I++8siyeEzNi6RDWFdNmgcj47?=
 =?us-ascii?Q?5ivi0OamneXJVE+rp1y4Cq/NqpUh9TnekTfPeGaZDC5ujvZygp4ALdiGFI55?=
 =?us-ascii?Q?EZnuFSLE9qlcrhlsEcwKr8/v/2dErslhbAbBZOIW54mJgNfriXF57RjkAHUQ?=
 =?us-ascii?Q?Z1pmpaXwYRsmBlWc9kko47KbtWG7cBP2HrkkeEb28s+5SwtKsJsWZImt+roO?=
 =?us-ascii?Q?5vqt+DI2KELyf4t0fUkYCWlzS+As9jP8H+7Ra/8vpXoiFA2rA/GoEvovZEp8?=
 =?us-ascii?Q?OW6rQ/MoB7/ubFb13vmzd6HWndmPzly0GYOqpG9QJSapyP+RqUaji5Sj44an?=
 =?us-ascii?Q?1T/6ve2CoSYPL0k3eaDiOHa9335Ia2jEjvuMw+6bhfEGznrR++JG8f3Bf7zj?=
 =?us-ascii?Q?JKmQAn0EYfWvvv1zSbiaDiGNGYD0oZ61tFe87JIy6v/wHTRGWjnRQwrAMe6N?=
 =?us-ascii?Q?o1DmNWDHoUKNsECRBCz4Kh0EB0eAhr5wVnhqNMcMB4yMZIF2jfrCUFG45pSM?=
 =?us-ascii?Q?EwG39wVyagPNRxLzYNIZhtM6QJvD0MHzbEf9y/X6UcgVQZmBvFlj/riZ1dNb?=
 =?us-ascii?Q?qAIzaQ9R4X3eEBJmEqeZNC7FgowjJbyFv4d68df4MjaedLVLVpgdVunJlcaT?=
 =?us-ascii?Q?l401nfesoTA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+FoKeeBAXTC1/84DRFxVPKg6Yuz+o5fXbPTYo343yTxBbRNxy6du5o4HV++M?=
 =?us-ascii?Q?232QybW5llu5mqlysXtJL/Y5B5VYcaRW7nyHUAgWIR1zGRQQitssYsn105K6?=
 =?us-ascii?Q?QsiCQQXiypQvmVBw/7ldOGpbqx7ADTWNU4rBQ1qiuD1XmfbFVXICD2FRGqw4?=
 =?us-ascii?Q?eblSBRmqFUKwIJresx1Ai2InPlDlE/6U+tToRxC47qqghgpuKMuU2gA7XAzb?=
 =?us-ascii?Q?GriejXoZU4ZKjEq7SK8BQvOX+9NbJU5KCcisRVjBD9O33Rd6yoUvTjHaR0vU?=
 =?us-ascii?Q?G/Adx3BEN4hfda9NzHeBclOFodNaJPUhbB3UILxeLn7JqVdUxPhQ8ZnfML3f?=
 =?us-ascii?Q?sOJZK4qecNLQyXI5dcA8jt7gS/Wk4N2EMvzZkahE5zu1N7lsApFZdvZVwq2V?=
 =?us-ascii?Q?qgG0o5MrEmk7UtzU1J9d1RlaKrpANonCsiUcB9FbEDP9S9wUZafI/MLf+4Lb?=
 =?us-ascii?Q?3FPu0fQ9o/33hSD1tPzQlUuwYwK1wgDlrwukAAIAdAsZyghRxl0naoP+NUmz?=
 =?us-ascii?Q?Oz8nxyMclYGSxKIybI7ZNAT8FogjDTEDcZBsHzyNKaPbYSUkQV9LmRiwu3PI?=
 =?us-ascii?Q?WlhRU553+ssn0A13wHbSdzQAe0lhcwaj3BxpKF6fWi5HYCnea9/u3zitMqR4?=
 =?us-ascii?Q?zWTPr+MsZn/cw7FFcVXSV1jYssOvqyCn4VHIZ/EUtjjuzU1BAe3bIZ+3/Ic/?=
 =?us-ascii?Q?vzIntiWnSCC5FrEnieVHhDC5c1wVx7YESELCKtuJaVZtdTIdiToHmvDy/3f6?=
 =?us-ascii?Q?ixaKErBxJ1Sf5JH1k46dQ6JHuP5LRirk0OEbvnEIFbLmdFZQV5JWBkOyJoME?=
 =?us-ascii?Q?V1GkwYdRC2yDPHxT2MkwpLA17Qtn4vVCJNiiOS1C9De3uDxoAe/ORy+8yW1i?=
 =?us-ascii?Q?z3I6K6lmUjKVA3v7uiFmdmIXYwD3MFqjj2GWqU+2rFVPOiTY9EK1nkzuK1TW?=
 =?us-ascii?Q?PRvgd5Qjc0++4QN/F39GG5P80xW+8SId1Sumjs4zr16pM11w5z1bUPJdGkLo?=
 =?us-ascii?Q?UMU35HHT3T89/1rQJXCwJGaQ3KIGGLcV0kvnq0SYNigTzL0q7Pe02Q0v6VuC?=
 =?us-ascii?Q?Zcyef+0Lh0Q+ZOg8RxjWVT5Qa3OjIjB1wDT38AfRMgR8oDZtYhpHH/nwNkeR?=
 =?us-ascii?Q?/OKoWDDzxazREl8gSUyRNGzPDQ+J24iTR/IaCNwu0pcwhA7dwpMNp2Mf0IYZ?=
 =?us-ascii?Q?vw1akpu8HXSzQDNK0KBlnKtfXgGfgT9FmTobc9ipdrdoafKCrVe1p2hAswsA?=
 =?us-ascii?Q?A/pQUlU2Wle4YxXMNiUB6YByTY7ZD7Bos0aOPBbjcEcMaq8DF6fZonQw3hzL?=
 =?us-ascii?Q?gC52ielWZYNfU2dIbkBHu9nfmKaNDJnpxLzCz9pYInmdh8W0J0zGHMZVf08w?=
 =?us-ascii?Q?4GQRQ9gX77qNqs8EY5+N0byZ5PtWr4t3nPBN6MnQJzQmbbUC3/wFQU+o8v7E?=
 =?us-ascii?Q?3kADsvS8PhV9iqh3118SXS+LQSi3+GQcei8HxHH523K+4YgwGAd+W45c1GU7?=
 =?us-ascii?Q?rKFQlnTpLKfXSwPbOuCpkXW0RYp0el0/SJAWk0Cyc/0Ckw5jrHU3TPgLHzFS?=
 =?us-ascii?Q?9HyN7t1TTdyy3UICyfPJTuadnmFsUcZjhRw6kOth?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81115552-b875-4807-01ee-08ddbef835d0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:22.2722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xtE324kw0qe5ELMB7+ZTysLZhqCIX3VVSEVCmswby77q4wBtCyhC6qCSW1T9EuXN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125

When looking at a PCIe switch we want to see that the USP/DSP MMIO have
request redirect enabled. Detect the case where the USP is expressly not
isolated from the DSP and ensure the USP is included in the group.

The DSP Memory Target also applies to the Root Port, check it there
too. If upstream directed transactions can reach the root port MMIO then
it is not isolated.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/search.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 2be6881087b335..7425680fe92d60 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -127,6 +127,8 @@ static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
 	 * traffic flowing upstream back downstream through another DSP.
 	 *
 	 * Thus any non-permissive DSP spoils the whole bus.
+	 * PCI_ACS_UNCLAIMED_RR is not required since rejecting requests with
+	 * error is still isolation.
 	 */
 	guard(rwsem_read)(&pci_bus_sem);
 	list_for_each_entry(pdev, &bus->devices, bus_list) {
@@ -136,8 +138,14 @@ static enum pci_bus_isolation pcie_switch_isolated(struct pci_bus *bus)
 		    pdev->dma_alias_mask)
 			return PCIE_NON_ISOLATED;
 
-		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
+		if (!pci_acs_enabled(pdev, PCI_ACS_ISOLATED |
+						   PCI_ACS_DSP_MT_RR |
+						   PCI_ACS_USP_MT_RR)) {
+			/* The USP is isolated from the DSP */
+			if (!pci_acs_enabled(pdev, PCI_ACS_USP_MT_RR))
+				return PCIE_NON_ISOLATED;
 			return PCIE_SWITCH_DSP_NON_ISOLATED;
+		}
 	}
 	return PCIE_ISOLATED;
 }
@@ -231,11 +239,13 @@ enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
 	switch (type) {
 	/*
 	 * Since PCIe links are point to point root and downstream ports are
-	 * isolated if their own MMIO cannot be reached.
+	 * isolated if their own MMIO cannot be reached. The root port
+	 * uses DSP_MT_RR for its own MMIO.
 	 */
 	case PCI_EXP_TYPE_ROOT_PORT:
 	case PCI_EXP_TYPE_DOWNSTREAM:
-		if (!pci_acs_enabled(bridge, PCI_ACS_ISOLATED))
+		if (!pci_acs_enabled(bridge,
+				     PCI_ACS_ISOLATED | PCI_ACS_DSP_MT_RR))
 			return PCIE_NON_ISOLATED;
 		return PCIE_ISOLATED;
 
-- 
2.43.0


