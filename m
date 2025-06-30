Return-Path: <kvm+bounces-51123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D2FAEEA55
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 00:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2B1B422474
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 22:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDCA2EE266;
	Mon, 30 Jun 2025 22:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LhvLfX7L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2060.outbound.protection.outlook.com [40.107.243.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F762EBDD7;
	Mon, 30 Jun 2025 22:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751322537; cv=fail; b=clrJfbQRhHbpe65Eidp9xklDA2830dwU8C7OM3Ocgk86dQNq89p3E0weoruO5CqXJoTo8j8IdzhUy3so9B72Z4IFSuiJBsejtb/L6E0MYj7mcSr6pA3z1J5Rd7gESXcC8MGRn5tPY4Zb3XyyHbRqXsaBpOePGTEuxdj0QjZbmM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751322537; c=relaxed/simple;
	bh=ddHtrLaS0touooPDS+6DUzzvL3mROYftIQly382dofs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sagyjlF6imfQLNoBWbyZL91Qa02pihdoJwMK4DqZRc/0IbQ77Sg+5F5e2PbvNYA3HBmSTDAhHi651I/5HJn66oOUH8vKPKmBdJvLzDIslLi9sc0NPic6yDCfbS8tzRG2rwG84Fi3nWYdz4MthuzkeeenktqmhWv+Eym+xyqMlbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LhvLfX7L; arc=fail smtp.client-ip=40.107.243.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l2debKqN3yF516MWJl2VxoiueE4wVjR4W4GGYe8+3T41/d+xok4e79DH1xJq4n/fHJKv2AXpSeFtIfzHvcA0+YoLoqcyqNOuWusPYmCDwXpQHx77NG6YIwIB95aEfm5efIrA8Ew4DnLp1n1K1wRzpMMaZ/GDruWpPE3R6zba4nq8g6v1uuka+QD92inONhsR+rvulSkAVJy4yFDIDHSkOzgV0hp6tLrhmaQyfiW3YwlBYIIYr5meXNP8P084pyf5bnX7m1rMg0U1hfCaUr/y67kk7Uu/5rdATTA3eQA4iBXeooHorViWdwq2MPVwZGtAxFrmi7t957Q/VMA1csXqGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qAp5CTxqFxnpXliQlWWAenq4OuUaQH9PBpU3xijZBXU=;
 b=YJ258MuQqairHHSWDCoFBkhpdqbIArstJkzpLUgNYFiusEPMvvAsCZjJSRCkVMDyvIMa4q2Pbn0KbqXNox/DCZBGOyu6iLjf+anzPEhzAGTzkYIlRdA9+/mpZSYTVS5d1kyCWFTz9Y5zME6WHLh/pi91Vgdr1oTxiWnDPnssyZoOKNtjhvcYaIFhAJV2vyjVt/0v8TawffUKTM24dMIEthxIVoxcvkefeXxs2DXcPS0XVcp9NLlA9Q9sC7KQdLP7d1kr8REMm/LlDkH4g33Wtwl7IFGTGgtTX2bZRbJs80RKpWrW4NRMTMNJEC8q9Ylptg1f+pT7NHUWvbksiKYCAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAp5CTxqFxnpXliQlWWAenq4OuUaQH9PBpU3xijZBXU=;
 b=LhvLfX7LDhHXRmD1pjzycDq0x5GvZL/wje+iU2VehRRSPpPQx7TPASrPZJCF7gkl+WdkxgE5qNDMmNJPJZe2VXZwKi03Tu0A0K5JCH+SFh2x3SynL8ygsN9Yi0v3k/QrcNtl8cGXbu4Lt7El+x5nZEb2hGH+bQiTCyEH/3lOA95kxVRo4s5fiOz0rqpTQ7RVYL4zgYl2W4R5RBTTn8OdLNkN+Q0s+SpeilIPtll+TuDLLJGIjInqD+RvET6tKmToTCO/YzzhLxSCrnUhyHSFlAGvfoYsWzwwh3NNVOcJrp0q1DICr8EwvjwTHAM4MXyuTF/1d5hmqzi1U7v6Glun1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN6PR12MB8566.namprd12.prod.outlook.com (2603:10b6:208:47c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.25; Mon, 30 Jun
 2025 22:28:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Mon, 30 Jun 2025
 22:28:47 +0000
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
Subject: [PATCH 11/11] PCI: Check ACS Extended flags for pci_bus_isolated()
Date: Mon, 30 Jun 2025 19:28:41 -0300
Message-ID: <11-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0069.prod.exchangelabs.com (2603:10b6:a03:94::46)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN6PR12MB8566:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cbf6835-270a-4f81-4972-08ddb8257aad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0kvSv4AxpMVPq05FW/xoef9qEVYtjSm5XXiAznSAB2u2mzbj7N9wX/+4PTDK?=
 =?us-ascii?Q?5PmC/Kb0zf8Wpzqzq5qHd+zcjCKVV5E9bLUzXdws1Dst3h310ZvONK4puMjK?=
 =?us-ascii?Q?vJl8PDKJSsb4r9by7pEBWF2lOYGabOA9P4XEmfHZnRcLOwFe6CbnY4WpEBT7?=
 =?us-ascii?Q?18c4bywC+AruY1d4GpsnGm+UEpMJfp4hh0eU5zIqJ/khxNgJvYgZXZnG5ceo?=
 =?us-ascii?Q?fwodmT8eyMqmF2RjT0JwXEnepOgv2ZQ5V+0s16a/NcRm7kSgIneRLEgt9n+/?=
 =?us-ascii?Q?iTbESfQVga0QOLyxiQ69DccOqGtRl7wQ9WZn1jcnoIoQowy4/qIfKWCo2Niy?=
 =?us-ascii?Q?9x9yEwALefG+1j8ckY2HlVr7y4gEB+W3wa0Ui3T2oqPp/OiG1nB5uiR7pAim?=
 =?us-ascii?Q?9kNC7fo0VtP6iVlXc3JY7ENpicDShn6HMSCl3Y3Vw+4Q45c7FdsXkvAw5tJj?=
 =?us-ascii?Q?O8af5JO9E09h6MvpqhhlrcT5vBPm0lC35cWcQ22ddN8ErIdpe/7Wxi5jI/G1?=
 =?us-ascii?Q?6K8lNkwUZ9waMTIg7fQZUZ5sPwDB0M6nobIBum0rNnNrkKC0BHcPe5BH9533?=
 =?us-ascii?Q?iUZRCthIVc1G3tCjZOvCc9A+GO2JHLnaw1cY9oDwFSk/ebvAPoNm9t419U0x?=
 =?us-ascii?Q?wnywZRYpj8ds2pYqh/I8Q3fI7ajfjjNEg78ZyR8QzlCithhWXvg+xFMcTJtc?=
 =?us-ascii?Q?Dei4ktLOKrLJZ5bLsUKNWwGM8sPL0IJSO4jHJw8mZ1SiD5HeJI6e2qhZ9PRO?=
 =?us-ascii?Q?pUTw71Sg4B0j16ScGIRr9SgW/ukIaDkn3oo2P/qc26GNA+Nf7oE956mIlmMp?=
 =?us-ascii?Q?RG7ouJttVmpslMLzi5zv8o3WvBYG4dHKtbDjQV0q9lz9C06qTMdE2JBD1gx3?=
 =?us-ascii?Q?cbjmJeYH4D/dxD2cQwDLtMk+G8bzlPKR8dAyiAZD7/xvhleXlOwKw0lp9nZq?=
 =?us-ascii?Q?/UA07IbkfPKkqU3gp1QS7txjnZbWjZ7UaefxkbbxWW/UzkV23LpowpHWxgd5?=
 =?us-ascii?Q?jjvrfj/ntnXsEjv01tjEmMAZlwXraCUh/7Fi0r8iCzyLv8WUb7V3CHrU1b9Q?=
 =?us-ascii?Q?XMLr9laywkTEMFHSIhZtcf1D+Y5QBg4EBbHDE/vW5DOfgvEoOTsXmC223rB7?=
 =?us-ascii?Q?HRB8Lr/scWt1c+7CO9qaf6Ad2P/DntMB91DQQASGYBMaas2p2B1UP8nX4HFf?=
 =?us-ascii?Q?hpcvYNblJsyO0h9b/ML//xyPXE4AvACOlEv+dyNITCAEvFe2sRs3uxO2l51f?=
 =?us-ascii?Q?vfwPNUmUsWfTzoQaVFoAHXhUZmjZ1PaFZnCIXO7lXfYQKywDwaX2Yz1ZdiYx?=
 =?us-ascii?Q?kUAVJNOfYQkDXvHhw7Styr3tuHb/rXd+pkrNfYthkQzBCz5QvCDbN36DveqH?=
 =?us-ascii?Q?SQKmkqvuguY+q9idZXdqT5GpfrElAskFReU411TSTAeezJ/Q0A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UksA9Rg8FrxFm+mqjnZdmXhthRiApg9Y8Vzz3OpZT2uzTKKZHPZAIr2WkJuV?=
 =?us-ascii?Q?/bdbQlfokDksmf1jQcpGkRlEHd8Z4dfzJpyRyloPUdOxT8O1KuFOxfmV7M6U?=
 =?us-ascii?Q?c2XN8YE+om+YIDmXQtoLfVC1xoDFD3EpEb8UpXx26jmQ9AZ1bL8uzvyvw2Qu?=
 =?us-ascii?Q?Yo033voviJ3WWTXt+eNFrhVsFX1AwkHhdj0SDR/9KKey0SXRrzdCtnwNiql5?=
 =?us-ascii?Q?4yiaPEG4LqEWYYNfF4UyYfdfJLVp2f72tVFPjc1ftsgvhILC9C+cmM0pcZ2a?=
 =?us-ascii?Q?yiZ6Whh62EbKg6rIIWqJgxbz/bC0xzIg3rX4QKDagamu8VaucgOgcQYq/oQw?=
 =?us-ascii?Q?SNFs/R5a8bYVYeakvJ4zmFXSaheB9tUKfN/qe8gLSyekl1pFAjDaQV9XEedo?=
 =?us-ascii?Q?e0vF0/VGAsMvQUfVjX3kucfCW8MQrM4x0OnijDKJsIMGHM3wgVTQR7psqsFz?=
 =?us-ascii?Q?tgpF1pzflzT5Xn7Y9gu9WdfJaA0qyJb+lE8+joodMOsbO+YoLF36v6cGYb5g?=
 =?us-ascii?Q?Xr0rsLhCOKmTokPag2rUhHM2vqYa3z81430h2eghsEQKSttHfoUCh71Q1C4o?=
 =?us-ascii?Q?SckXNrfS4snEqEZQhropdol52PGo+kurdBoO7wnnnBXpGrcRZIpQvrQZbs4d?=
 =?us-ascii?Q?nnY5y7LawLzc2O/pANdxZ1ir5CYx2lwbcQ4bLJYlzjQlBYFaJqjbeQPe4pI7?=
 =?us-ascii?Q?yUYMW1FaGm8G9ZVpA1/qdIpBzDXcHMSxaR8Vb8upcANRaRK8uPjhfq724cAS?=
 =?us-ascii?Q?EhXZ+yZDH5/7zMfbZVEh0eEbgucQsjXOct1zroEYdDfHoB04fhrins8oMOQt?=
 =?us-ascii?Q?mG4OeuR23Vc3QhU0yW9JXa/ikT5wnnsm6Di/DivLFrgOkwrIMTvf3OAi5Nt7?=
 =?us-ascii?Q?w0lb0oK4hsmccYgOwJk3517SSigIKj+/tA/bz2tGJGatLcw7j+S18GGUjlJg?=
 =?us-ascii?Q?i4/ResFaUxzEvT+EAXZLcSFgCJqwY2g0/77vAYeTtBT5qL0lxy0OmFFqKboP?=
 =?us-ascii?Q?1hFMlA5h+BavDXNWfwwhIqEi8lew3BxrGQaqb27okSo9UJxf6K/V/Brby8xo?=
 =?us-ascii?Q?nK29TozIdY4Icw5ee3ltwGjJBWJ2SObPI4jZ1TJv7GoWC4JTM8oxZNke6p6R?=
 =?us-ascii?Q?fG/kNgvWg3XQCj2ikrsFehySkON0r37ZNrB5ScZ1FeTPK3amjaQ0y5DqIbQ9?=
 =?us-ascii?Q?OhOkWU6MaXvHFENfHndUYBcQONec3kkAmWbchUtshr6TwOVgv0fBEVDZQP2L?=
 =?us-ascii?Q?ecc69XhI0Wdbe+ATfdhjmh19o0JaC9q8A5ROiBv37SJATPsaZTnLsqruA9Z4?=
 =?us-ascii?Q?dIvs+4RaJbyL0mxy1gfNrZ8Y1LKbTMvYjRFmLt1ZUNgmFrQymgQgOjjlD5AS?=
 =?us-ascii?Q?dj5ZZ92qeD8qrlQLD4V6VSwLuhgV55mtPAkx3mLp6au5P8GZeo1kf1+ZIa4Q?=
 =?us-ascii?Q?6i6WKbw2rgAxWw2luL2xSL10ykKtm+WOcoBIRi4zxZiaOi8HDgKs9pvRJuxh?=
 =?us-ascii?Q?yT5oCgDhS0OoXx5KnkKbho/Jq/iz06TP/86HR06nhc/NfjkT3em2nan5sbqK?=
 =?us-ascii?Q?t2Yig77+Jctk8QKECrvU6gn2L1o0upiMwq5DUXB0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbf6835-270a-4f81-4972-08ddb8257aad
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 22:28:47.1620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C90QvMkRLncBiqV8Rm6+L0/qa269nRJFQ2EeqMGgpsSsOsvDJv15c+qhT/cVpx/+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8566

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
index 3bc20659af6b20..779c5979443def 100644
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
@@ -216,11 +224,13 @@ enum pci_bus_isolation pci_bus_isolated(struct pci_bus *bus)
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


