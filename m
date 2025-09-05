Return-Path: <kvm+bounces-56901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C27FB461B9
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A90311CC0264
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:07:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A11F7303A07;
	Fri,  5 Sep 2025 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hKAoer2C"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082EB393DE8;
	Fri,  5 Sep 2025 18:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095601; cv=fail; b=tObZ2/MxWDYqOrANKdBcmRt08QilM4jFunZl/WVUEraNHe5cQ9cXP928K8Fo+Tr87Pd8HDrwUUDohubTNYPRsb8Ukp5OcyOupHld1vfDY1OfPTKGGK/G/JLafFXma0WKexlNcNphJU12kuJwD9+SdTUwEKH7rv3KMSlE98tolh0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095601; c=relaxed/simple;
	bh=K8DoRAWqeVS50slX3aV13j6pQTBlasmpSer75l6pzZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gnxR+3WwnVnVb/ko1VsELfPHtjru80CmFkQOMqaUwshmQM0K/48yx9n/7Jth8J8pRi+GxWAxtUZ+LvDLlesjB8/8VLwhG8MbvdgLH3E32FAbDtxISFbLG8MXXOnrLebFCJyG6b9+VbglUKdxF/qghnHymA0ft8nuxu9kzuZ+6W8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hKAoer2C; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s9lIwW6IlklYcI66oDvEjk14ZdjIqC6gQzeSqa/xxuDuPR+jCZOSAM+I6e9pKhOSTJhE5vyvBWX8T/yiG7EwKAqfw7jyiUaa5xlYmRYxkt0xBLKpydbBCzOkuynOjTTP0jOWfaKneRSZJlq1CrGTQXqAVM4MHiJmpcA9fl4yPgVkP26GG8YZctC+nF8WKPjQz+86kuk7SMURUmzOdeEav2Noj2rA5emPcCLeXbjM2GkQgSNGgIiVVKCWnGvh4EJhG5zwUODBc/8tU1sLiHUlLiRPZ74YIOd74oJzT0A0s9lTYcXwwEf7kBp7z9lwkLsW860sMIXKg/FNhcLIN0GUCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jM3mXvK0a8A9R8zAXjY8xVPFryQ5lS98EBTqz9gf9SA=;
 b=DDeuvXjC1zKzRK7h53/iriOhcBs0J1oXHnl815Gz/L0BZIqMq3AeW3EX0QczRUcj6fbZ7QabIPyOGm1Ns1yDn5g5IVWk+T+3GNNo70H1RTSsBsgoS8IE0QzevNyOTyfcBoBgZwxzlrfgF2NhV4kiT59ok+BnODB0wxQagSvY060158z0R7SvAJ/rg/nT0pD3/taQtRWJdSUehCf3GwIq+3K9afF7eqlE32J31a3RKYapavL5Tsngp2hFdrMd3tS6f047+b++DtsOrN0HuJlU2zfu3MWfOWg2r6xrRmKJ4Eu/M5j6+jj0rLBWIFjlEtVF3Q3prh+3Uypz0f0GwKv5xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jM3mXvK0a8A9R8zAXjY8xVPFryQ5lS98EBTqz9gf9SA=;
 b=hKAoer2C20FNnnAhqAXUa1o3zk3+Oy6dZpNUwbEB8kKC4HnSalF012p/tCh1+4iR5x9ZCnYaORbKm4H8IvB6nKms+S2EUuWOEXBh9rrmKQcQ+J+wLZ+EZGb2AoWVIfN+G4+LnqBYlnkDIBKND+Kl6gshUhLShLzTYeZhXbgb7xOnHQ/NQ5Xdu143+VZ8hndyqFg8avAbSJCr/SbbRzI8rfeUIiz5k/7rf1HTy5EF4W9cW4eubi7zgi+sOwi5qv3pkw5tzCMv85HoFgYY5P8msixbyNz7EWyryyVwhr1vNS4V3zcHY/RKViucweRnzMpRJmmMRjcKphbIPzpyeC4qIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:35 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:35 +0000
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
Subject: [PATCH v3 10/11] PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
Date: Fri,  5 Sep 2025 15:06:25 -0300
Message-ID: <10-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0145.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::26) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: ea1dab57-80f5-4c9b-a11d-08ddeca6f1a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rnjXv9f9+5qC2lBISmbKPhWSwiDtBIeSh1hBI/e2ebY/7KXSK23b+mz+3Tn+?=
 =?us-ascii?Q?x9u5quc83OJqVn7BK09Y7SB87SF57K7CIKP6xSSNbvyVj8KLwTBb1TL2MDK3?=
 =?us-ascii?Q?xlBZ/M3d+B1ujDEi6hD7O+NEfp8Pu5vFKFsw0dGH/b+XslpxfbCyH1hGLHun?=
 =?us-ascii?Q?kOOhUWlt3wbNHtbjeb318dHAgbQNb5+R4hFcQOcEpDI8m04nnRuYbq1fp+WT?=
 =?us-ascii?Q?601ZkTRkQXQklubuoWU6nqNwgYeGeT6N7UKtEyEWQuO3JuvyaS3sdMSCNO8V?=
 =?us-ascii?Q?M73Wn8GhQVQQrzlute8sATItsB5oJUzE5vwXJVt5BmGKlVFth9DHX15mkI3k?=
 =?us-ascii?Q?12IFsKzXxZp1C6wCB//ZJiMLyFbl8O0nF+NVz88UOjNem5+Ux5uMWpZKDzB4?=
 =?us-ascii?Q?fQvCwfLPqXvTV9Avdn3/xCv68yq5ogfu+kmwckx6iFBvX4YJw+FLA+W2gzNm?=
 =?us-ascii?Q?0sUUdZQmKpjiskA0CSpDr0vLbtFGcIpX9xVZ4IP3RMTrbKx6S/lKMjKj5b17?=
 =?us-ascii?Q?l+5L2DR2LLGv7bs0qsyOHtyYcdYAsyPFh4ZvvlFFqxCml4Sh3iwlMXT297AU?=
 =?us-ascii?Q?wt25SvVmWJ7vbtgxA9QxCMaJSWG9LToQuT9WIAQ/sBAuwa3Cucs6/BICxFDb?=
 =?us-ascii?Q?teoE2M5qHlkviumfGolmTW4dBk3t+PfizO75d2oEsZeZgqEpcvojvQDNdbMY?=
 =?us-ascii?Q?9M+dPEgQDKXV3zj8lBTUS18TlPuys+4f6S68y7Hx78a7gKhZuLC++8Lw0SlB?=
 =?us-ascii?Q?H6cRIUkpYhKRfKbGkN1gSWkBy6nRzr60HVNbOh5ELdlCB5nUVOWO9djruEIW?=
 =?us-ascii?Q?jd3yTnNIujD+P6EcwrLwHVshp+MpxyPA9YdYoP4XgE2wGN6+JyLr4DPOBWdX?=
 =?us-ascii?Q?agTEZtqFj1Fu5E+hJH6UVedQZrgwQKAIDbQKvDtKuZPqglKl9n2z+fuMmnt8?=
 =?us-ascii?Q?DgtINMC49GLgRSHoQofSlsd/GWuVw6j2EBbQT/0stjxjFiE6I0Z7SDC35tEl?=
 =?us-ascii?Q?CkJzgftLzsYk+HiJeVAj8dJ4EvnX+VV6WPwZ5bhmNe3Pu4Sz+QNX+1JFMp9u?=
 =?us-ascii?Q?2xzwtrjSiRgNNxBCoAxDVUdF5kGCFJmOxnDP3xXnXZARCbkxKqSoDgERld2j?=
 =?us-ascii?Q?rQ9sW2yH75se8uCzxlLDLqNxcrlmZlSGC++m99vCq+FD8TlMOZapb6p2EwKq?=
 =?us-ascii?Q?XyRT67GT3YzBK98zJAyUAXcJJKq4LApLQQDY+F4dNV1aXbkD+aK8Wf7sa77W?=
 =?us-ascii?Q?XQzcO8HfqiKYWr1q0KPw/2DadV6j6tpXv4osEu7iyeP003WUr1vMklsc5pDY?=
 =?us-ascii?Q?D59vdcdtcjy0GTXPI9dyIxCkHXsDapEuUI7MKyKrynlKdNz+vVduWE76cdhf?=
 =?us-ascii?Q?wXm71M+Lk0W+otpZh+VxM4roFr5XUnJ4XZNAZWObkM83zIoHO8SC2i0afo3K?=
 =?us-ascii?Q?splgMMcA9H4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FJL0xS7QOT/bh9W6MXgbqi7GE/MfSiYKOtWnRJuDrtm1DUv/bxyLc6CyN9Zv?=
 =?us-ascii?Q?pXRTrNDD9PHwSZnE8SVjzePJFW+z8CLWMQeSr+qGYw1ey9AIfdvj6OIi+yfJ?=
 =?us-ascii?Q?NsEdk/Gl6eu4idoWzZ4Njy42vQS05SBOx7q8mvj5q70GapC4BKIuL3ihL0xG?=
 =?us-ascii?Q?rUjWV0LhL19jMs4QlnsAXXXk+n0V0kTutf9oCI0/iUEg43f3eMuevZCr5gIy?=
 =?us-ascii?Q?bx/tCAk1Qfecmu0vdwhiWQl1X8lh/nhhbCIuckDeUKK4pTc3dpOhkOPMh3Vs?=
 =?us-ascii?Q?i54O6EM/DSVnCjoN+lz9cVAUndgwKiij0akDIWF5m7SZdUVTUrum6nFb/POJ?=
 =?us-ascii?Q?BFW+5QkdCRlcnCvjB/STru6sAisWmn+k0/u/5/qvnSrtEURq4I90TUi6dJv+?=
 =?us-ascii?Q?hHDYXeeKuZ4WW6Y7Y1EXbGAB+0hs9bPlrA2VcoS7mBId6C5ZZtOq98NcqKh9?=
 =?us-ascii?Q?RDGXxQ5mhp18vuzmrVXmnoZtIUQh5cPezaMcPaaVlHZ2xMfzOBBaNBwrot6V?=
 =?us-ascii?Q?mWp8MTxtAnnu55pDjjVWKPKwszMqNxBtVbH8eXAMY+GxCBaUkIzA0v0b8SMP?=
 =?us-ascii?Q?IFtGQDK7O/jUSKTYVLlsBXlbQres9+ZmJ4NxS6RFwwUTvWgyJV0Ya685gGHV?=
 =?us-ascii?Q?+9YYLLolj53w538c9OKygq+/hO9Dc6kPXpZlz+xDR1ohj+/0/9if+96AvbyA?=
 =?us-ascii?Q?RGjvXKVDK2dqf08k5TeJMH1d61bdgx3eMvIUXzIVWUaVv2l9p3mPhrpb4KMf?=
 =?us-ascii?Q?KY3us7kGpy/WJiiSj1iF3j5grbhGQd49rKtzp+ga9cmNkPPMDdT1K/Jgca4O?=
 =?us-ascii?Q?0RwjYDXb13JzyGAv88fGyYS8m+/MwMi321DceR2B83mqCrzRzdlk/Ne8Z6Vy?=
 =?us-ascii?Q?S8WmlWcuR3zHWhfP9ymJuECgnm1i3b7hZKrInTdy4l22xG5psR4Os8c4pABl?=
 =?us-ascii?Q?RHdX/0ioToomdHXR5Rf3vmGQXKIUEYhZTc0cWTjucB181IaErMCWTPNGZv93?=
 =?us-ascii?Q?OcdCOG+P/zqozHjh8Ev4Gnahzntmu/jxuaJ3CgyYH9WHfl2qhsYw6/pPFwuI?=
 =?us-ascii?Q?hpTNojVvkykoZO4xHT3NwcBlfFNkjHW3nPoKIni1YlcTYFJjZxkRAHC8msKh?=
 =?us-ascii?Q?gkUrHZTUAp5IjRwsoyW5mpgsX5yC9MCuVhOJ6OYpY2t5m3c0gRlRpe6iSEtt?=
 =?us-ascii?Q?xANHQe7RkWrNY+otfoL237bGYihAEoQ57vRFYjMM+z/tEmel8z+MpqxksEUY?=
 =?us-ascii?Q?VDYLBPstZ8g/pRaCVTdxj/2RqpG6b9BSEBfR9L0DM68csYinWAQRxEMFP+T7?=
 =?us-ascii?Q?XYvfEMhpodBG1wb0cyG+3+Co6DF1os1uLmaeXpRr2awCntYVcRQnuhrHL8de?=
 =?us-ascii?Q?r7835vPYaH3P6+tkdY9+zKPRNOhZJFiuWGWMk11N/0SZgSsehViXskBtQMBC?=
 =?us-ascii?Q?UZ1DgyGh63reCG870uu42LgfA//LJLlg9uqQ2OtUddVngoa6gTW/XtzhBjDn?=
 =?us-ascii?Q?GPN8SQgeAJViuNR/0ih1uTXqcctxoPgDga+OjILLaOjp1n4YVJX8YDRwnTfe?=
 =?us-ascii?Q?y1cbxdR0IBaT/wLk4mE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1dab57-80f5-4c9b-a11d-08ddeca6f1a2
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:32.0513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: arI+IgyEi0GAjaXQckaBpt39VJGBisqeknmOl++QbOwJXPZZsLa01J5odfJMh1GW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

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
index 983f71211f0055..620b7f79093854 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3606,6 +3606,52 @@ void pci_configure_ari(struct pci_dev *dev)
 	}
 }
 
+
+/*
+ * The spec is not clear what it means if the capability bit is 0. One view is
+ * that the device acts as though the ctrl bit is zero, another view is the
+ * device behavior is undefined.
+ *
+ * Historically Linux has taken the position that the capability bit as 0 means
+ * the device supports the most favorable interpretation of the spec - ie that
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
@@ -3615,15 +3661,9 @@ static bool pci_acs_flags_enabled(struct pci_dev *pdev, u16 acs_flags)
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


