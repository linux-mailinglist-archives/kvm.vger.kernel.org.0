Return-Path: <kvm+bounces-51969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A50CAFECB4
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED395486DC1
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:54:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974E12E9754;
	Wed,  9 Jul 2025 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WZsoLH91"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCE32E92CA;
	Wed,  9 Jul 2025 14:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072757; cv=fail; b=Ayqv7eh52RvB7Z4vMl2FsAmGNehfSfPqO4ZEcWQJ6KMjnt0WWyDCY+H/qJcvxQeFfmzXHOYaMLZHBF0ERmad09jT4Stu4uEkxkSD8MdQnefBdA8Sv0GvBL8avtJBjwMDYwrUpuU5T2VTq+hPfJlEiAJkmUbo2H/gwTXRxeaqblw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072757; c=relaxed/simple;
	bh=fFIr0ZhXhH/xiIiJDuMWyzIaG7noCyCxYOTYmQzCGxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tIqKw5+DYKt1SbnIepGZj2xPm1Pd4oKj4WdJqPZFmCUQNtHEDp3H4rZTrpDrAjwi6naVT6rzdNr0C2zAqdzJhNg2YyA6pIIBUVtQj3ab1BlUTxOcuchMo/ryEfXzgaJmAEVkoYzhHEovHE9z8MBzrCNZJJm2AXWwSxEJa63mnQs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WZsoLH91; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cCijCke1JovowSpd5+La1yj5tkDemjVre7YOfknmyNa9b5X/FQeXY+dUTyQtJKI+gQAOjnmEXqDUEp9DiztDHcAyGBJCKSC/yt8K6f9vMqcaFQSI7zDjmG9IHzrqCpZB3btHpVxSvU8/HBkkBK+RZAqZBEDZUJ2HB+foRbpwn4nXkqPjRYBiv288ELNDZvP7lDCb2mRJdKPVNCQaClOsudksPvtWxm26Xp3xEnSL+2333J3daTa0Ey0p3Nt3ciYy1Dq2jp0stEkbCwYlrFn1LMvUbVuf3AUpDw2ldMWgO98FnNMbBQlsHzaTcEDEpMPrRIyIkaDLjScB0hCjmTeerA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9jy5FYpnHOBI93NJaptDM0IBN6O7YyF+jM9XirEqwM=;
 b=j7o/L7DObw9X3NL8qTXivvAc5I7LbXooVbdnYdDaiAy+/XNx9NdWDq99WwvTnBjDE6DnPFodT57Xd4D05O8BOrKJ7tMFsO4bc+LIgbR5C/lH0/gR76KWlY+WVcw2hbofOsSrqUMtch7dd1mfhBNipDJXx06SriLbCIJRDZQQm82WzyhAl2XBHcXygxr+WsIKrAMkSbmmqXp9JoH9grLVrgqWH/rA4CGi6FSonoSoEAdDqOmxtukWObYwdtsXJH65FfFIOk0Lhk/vHnkOmNGaf0cH9EvPeEie4mBKLQh52q2CTToYiRQ5IKqwjrECkcYQO5US4htoKRMESCEYY9R6xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9jy5FYpnHOBI93NJaptDM0IBN6O7YyF+jM9XirEqwM=;
 b=WZsoLH91x3cVru31Tygn93abgdaPqXhfUf6SebKiwVdfjP2n1wFyxUW7GccATwBsNzCIQjZo3Q+FDnf7TuNGR1pWrhKhwwqUpoJJFgLML2YNbVhG+wt+iXegWj2ZOKuCzZ78iaBKuYgD/tKDossDdXsYvx1hMtWqwLTVeJICOamlVy/a4GZJWudvRpZ3Shwtoy4ppAv0oLJbMu4Xq1wB5XzE2rvc2AG1B5rP+5OIBj9b61tyF9tYEVGqDgKpDUgbYXIVTWk1R7GURZm7y0SxJRM5v6OT9eDTEZNmO+8QoxCTB0SXCrlpic6/d0ibubpSSW4+Cw9nQb5w8x4eQCRH6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:27 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:27 +0000
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
Subject: [PATCH v2 15/16] PCI: Check ACS DSP/USP redirect bits in pci_enable_pasid()
Date: Wed,  9 Jul 2025 11:52:18 -0300
Message-ID: <15-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:806:6e::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: f90c4863-19bc-4893-ef0f-08ddbef837c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?m6OeH6D+X/YJUAsc3ix4wmI3v5vWt59dBb3jv4Jy/POOTYXkhL0DhrPFitDg?=
 =?us-ascii?Q?RHRJQagYipCOXGZpSM0jEekRFxmS3iRbS+TC5SXn8dfB1vwkvzRkgt+7Rq7x?=
 =?us-ascii?Q?X7uE+OY7iLHoGl/J5JZXesjTAFutuoLD1n9z81S1kLuX/nQ4Ij5d4H0avxhn?=
 =?us-ascii?Q?lavLwB2nshjX8xOo8UiF09qEfiuSAOWWWoYpirJZuCdcOGLyxM02/tgelUhN?=
 =?us-ascii?Q?jzWUGsBm4Hp98U+prsQfsNzayCvGGkzkNXpAiIzIKwhq1VmHuiH5SzKFEOGE?=
 =?us-ascii?Q?8azJJaUZLrSCBWH59XrK8djb3lsY1ffGSKd+Y2sv6oqLxmuv6ggz3tL8qH0O?=
 =?us-ascii?Q?tdlsP0u0qaeOqw2p8MbRswl7mSJJ4pmqS0H501ib4ieO/ycDmwXklApHDbD/?=
 =?us-ascii?Q?HZdqOxvKi57fz5s0yj6URc/8hWzraU7ofIoCRPjKy1TnhzHSsDPHDj4kG4jn?=
 =?us-ascii?Q?vlFiYTz8JuJ382hCTwaVFSkRYvhdjwT+UsMqgRzJVoaDF8ar81QAeR44XHHt?=
 =?us-ascii?Q?NR7x1Weq81anv9yc9iFvp2dXQ2FEFhdpjhCflLm1ucXl4EzmcuNZMR5eb7pN?=
 =?us-ascii?Q?LqjzOwxFbO0m/UPFNZX5Q4WWjKthnw5LvYaQD+8rIrdyRiBZT3WHjOWNb4vc?=
 =?us-ascii?Q?QnpGwiWW7sDtKOVg05mFjnBkLzGOyOo+BkD/fftWLJY278umWPbZuGHDLdwa?=
 =?us-ascii?Q?ODUXcl9dYbMdy1WNX6Hd0QL8XWU4cB8QO440SB+Jlx1g0BQpZQOZj9vGH47K?=
 =?us-ascii?Q?BPHPZ7WNYvPnHe59Yaz44XPhOQUPvk/khpVSBuUMBciSTrG0JJ0pxmB9kvdn?=
 =?us-ascii?Q?+A8KnYGpEDCehM6LH6eXqwWRMm4lS2KE/ABGLCOD1Wq/IGfj7cpw57VnvI9q?=
 =?us-ascii?Q?U8IQxHq3wf3uN8WUNHXMraK55YAswmPWu7OTWjN5R4uLyMVhBUD89jIYYYs1?=
 =?us-ascii?Q?vts7BhNdA6wuQoJkfJjg3PHeMG9/OdjY+P2Tjb7SY13KOB+e3RHBXPMKd8fY?=
 =?us-ascii?Q?cbuxh5ISTTIo0GJ3k+6CQhDZ4SDKb7FBzePV6Dsz2fCrM7dOhR+dgE03nxNe?=
 =?us-ascii?Q?E/8VZ0usl209WJSGeG3nGoFVMtBL0xWb2aBkH7raLcuKAmGx5BWwNilvfY0e?=
 =?us-ascii?Q?bRiG86vqRLJwM5VKu/FGjTFyGvLAIXalgvSE7Fg1MDN+KLbHo+fDVAxLED7Z?=
 =?us-ascii?Q?zvykuRjizb+HYmYORUfDRoZGwPVuo70Eunc/K/7gEyDd52tdqV+mKpAaPOH3?=
 =?us-ascii?Q?4JqEgu30z9UeQqwpu6nAGqN8urvj5jgsKyqYqxQ563/exOR83gSQjizUoPAU?=
 =?us-ascii?Q?k1T6DqnFXMDEa8E7sPqbpS7/SFvhBSoiNsQmDFCGrcSu5WVCXhhrPbYdWHa2?=
 =?us-ascii?Q?Q/SHR3QEYuSWIBgV2TZF8RW8Fev/BKL5Cq0X2FeI1JLKf0s4InehIPqY5dde?=
 =?us-ascii?Q?CE+U1E8S/1Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ia5NY9R3+b9nta4zXA1VtFniCRxymTzccUpYu3NlZn8WlUv4aDWFwMJyyxbC?=
 =?us-ascii?Q?V/GPAU3abT5FCuY1pNG1wCiu9Y/QVS5Ex9OWbbm70x0BD+Oy8jTAIpy5VHcQ?=
 =?us-ascii?Q?VbwmnRSXJjNY1a8our9lAQZayDHoAPLKK2EiO48q2XXBoa1aMDZWi2XS6s7y?=
 =?us-ascii?Q?iWUKv0Vv0ICnACyBU6T4HCvdl0M+NBB9eTg8cJYAccjyqrSa98uLJYCBwjC1?=
 =?us-ascii?Q?rGFpU0L5ChuVP71DXLi8CXbILYvv2YOe3pVJ964fj5sBb6ZC+HST6JiigD9W?=
 =?us-ascii?Q?3laOLX4f9B+gifYqvlqRUnH9Zq41IiwZyKpUUIwDyt6LJ1bN28PF/C6oc09h?=
 =?us-ascii?Q?ZAHPtGFAUk8S/RW3cZCa7+EG4/g5nMru9579iU/hUctgeYnck2iPEFLLlO5+?=
 =?us-ascii?Q?t1kmZjvU4cv/APlJZ/zfnE6BxxXMFBYZYTJjgDtab3ol+tw0/SD9MR4uiOb/?=
 =?us-ascii?Q?ykMcPsN+ne8WCv766xZCncy9YlVqwt/Mze+w93llArsbLG7B+lurpZZncv0g?=
 =?us-ascii?Q?l04rqdJSevPnZL+r/PLh1eUhsikOMYFTG7Znf2lnI5YXBB+2eJ7q9I0+iFPs?=
 =?us-ascii?Q?RR3it7HL95mTC7I2ZDi7BF1i+xTZEw1Re2LE5L0dL+mpQbR+gbYz4TGV7JmQ?=
 =?us-ascii?Q?Z7400E6KJe6A/O61UqteGI0MidLNkpTC2+M7XAm89AizDgE1g3ZPp1oCKE+N?=
 =?us-ascii?Q?hS/JU5IeRXIo1QUq9YmkZTrka8F7gT03Fg7QQQWhnM4gUz+Rjndl7YSpTCGT?=
 =?us-ascii?Q?CQ2kr0+UZUquo4a57cFSY7KvZcvE7s6xzJa/0IqNh8auKFfmFXD5CKvbrK5e?=
 =?us-ascii?Q?vM2kkP+xZ6zgEQQH0bmNWW9lGJrszJMWvMV0dzoWdcYocOTzdqUFg6y4U8b9?=
 =?us-ascii?Q?ieThVWtT03kSOSOcIvNL0LOwrLt9X+WbuCtzDHL8rVNJyY5OYCvvlYQCNmmQ?=
 =?us-ascii?Q?VNsLjff55pArKAaoPwXBgaaPI7zac5D2u15Hm03l+gZfSWN2mjWgv/wXoYfg?=
 =?us-ascii?Q?QBhIvUQGlGRZAJFnNTQr3wpVy9Le+DuOkpTDgmPQlLkB9K+/jWjagtyN9DHX?=
 =?us-ascii?Q?owJ5SuCTpFQC51HeWVfMUosr/eJU2MzHNNKGTv+Pu7mQl7KhclBJ5l5EixyB?=
 =?us-ascii?Q?qCzf8RYPNuyTdVGl83rZbrpeAlrYm64gxfICD/zFBrNpp93WFKrJRULQwf6r?=
 =?us-ascii?Q?LvNLr4JipsESE9CFSy4Hw298kXEUd7yUn9Z7NOrSudsr5nOEOitxcwq7a0M+?=
 =?us-ascii?Q?CE4HVTMDTxsrBUMtImGZYcFBe/JaHvZyCko9lZx0u+3ImViQLRproYJIaT4u?=
 =?us-ascii?Q?hoLnfHL98GquCfonae4Y90moGxUa5HcTJt+6jphgz79ETkG1o9h167GFuj5q?=
 =?us-ascii?Q?avWmzRL8GRrSwTm2lUP+wM1sOs6Hme6Z1UDLOxf0rlyiFYUKr7pHUmxNdlN3?=
 =?us-ascii?Q?O7igLNyELxqoKObMto1xRP3YQnK4VQGyfzn+Cf7fmQMbkZeQaiy7l+02knA5?=
 =?us-ascii?Q?dqL27Divx7RRHPPnhOUnq5wbOcM/IAZBwWuqlhN5T+J/MLYzDFNo1kRKhndD?=
 =?us-ascii?Q?LBCUSLMeTTiLCEnWGriKs1AsalreFD0DK6OFwjG5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f90c4863-19bc-4893-ef0f-08ddbef837c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:25.6427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5gdhZsLlHOoDnBx3s1SBmdeXbZtX3FAo3oRQPIDKlo9gzvHoLr1DKnNwpru/In8z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

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


