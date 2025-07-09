Return-Path: <kvm+bounces-51973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DE7BAFECBA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:55:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FA263ADA2A
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471332EA15C;
	Wed,  9 Jul 2025 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nV5qY9M2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1292E92CA;
	Wed,  9 Jul 2025 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072761; cv=fail; b=LejzJmGGZxZr4sN3i6ssxw02UL2PgGEjbNwkYiRHsbqJBATrrnpVcmSjzOy+jJwKo3lE3wcElc+Eq6nxOBofAWldwT+9Kg6dWM3eUhgIHztp6j3vLsT1/Piot4rwsZFZh/b6azv2XJHpyV6aKchYVOcQLHYm2RJttHQjUyHeKoM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072761; c=relaxed/simple;
	bh=KzAofz6nT7avbkujNOY3Uq8cD2I5jZQpzdDOVju7f+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KE8/7WVFqgEPiSJ11nyy8eaEjpcWeKuDHRR5FU8imG4vsO4m7aRV77P89IxqpjHfVJ2Ty+Ov95RHO7vvtKPqMSQB0OG8SkTfbn5t+UnM98gWMScdryCGKBtrtylKM8qUwB6+uawBDkMKm2zPFK3INgc5pA6rw4d5MmS1UC/FBxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nV5qY9M2; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hBN9zvPRgldlGfC+scGVEECuav27LUc7sx4L0IuS6XxdxQrO+izlaAWabGySeRCkYGUl9An7BnnlOg6ZwIl7u7+QZkwMfXaIH6Tb7tTniepfiy/fTy87mSBlIioaQzbL5mQOaHEwBkxbdZsKT/2Hv8ON7NrMXYWEIeDu8jO2aLfQntRQ2It6Z1YGZLd76I3HoQ1rQ9CtN5Qvs/hLAd9P0Xn8CgUHvPRyqVw9aEwTPu3lO9Av6QPfTYdHCivXTGwvqPM32/LoUB95wMoovWA4/ld+qbAeT+3UmhRhYqVqqyr7AulOwkHHztesgGd+XLWS339feN8GGt6uJLbZTyJJ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=he2BcykNv/ad4Gy+54keikxM08BahmZeO+GAbqxN/Ig=;
 b=KfXi+H6oFK1q2m8iHzXkM800mT9rHuGPq3Nr4a0lrWMPFL6Cau8JekadyrmveAy8nZbEP8B7sH9kRFWCFURt8kL7vVU2eid9044aT9XO3lPaNL1GFth73eDU3J+yZMibDniRTE9exq57a3T84aCMr3Pwul4GSjCwIGr5LF83XeY/xKa8cLL+CkLkTbTY0vjo7MQsjnqeLhj9dDt1WsQDcb4GS+iOHo/0JFGvGT40X84Xq0jNyhMUYyPXPoC0REaZjF9AhVrGfAS3CeQqenVXT/X/rHrOETFmHanwbpMWkngqSENvcHTX/mU6jGFBr9UOzmAsQwwvkLM92bSuV/iZLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=he2BcykNv/ad4Gy+54keikxM08BahmZeO+GAbqxN/Ig=;
 b=nV5qY9M21I/Gg4B70PY0vcAJHjm9IR8NR34ctk1LX3b1U2ksQQtI/zcH2iEl+yFCrUdGgaK7jWCT01FNHTvlVlZ1oUOOP7+gNHLkI2kMBsuHJH8g38kOsw6xgCQmWxtm8orvcECUb50Hov2MiiJKaEcijLXCWz/JB3ySzBWJP7x6PXf/nelPzLzYmC0wAcu2dX5F4zG0OXpT15n0i9XLQtkCHbMKEve3T71qZoCrSgA95HAVqmEUBOA8Oum4/I648SU+sZ2KjzsCi/nQf93c2yZfCxWiISo1Ueab/BJaYROhBZBoN/NCYyj0LJ5nFWM/8iJIp0VwlL56G4/teMmWag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:28 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:28 +0000
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
Subject: [PATCH v2 09/16] PCI: Widen the acs_flags to u32 within the quirk callback
Date: Wed,  9 Jul 2025 11:52:12 -0300
Message-ID: <9-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0094.namprd12.prod.outlook.com
 (2603:10b6:802:21::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: f204fb77-cee5-4ced-1a9f-08ddbef83811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?it3rMy0kqsM3TrXYCmv94aLZY9sL4jQjaU0FHVDFnchf/kVjsA/sk0XhSMer?=
 =?us-ascii?Q?iZkoaxtIcbt2pcV9dq9qOLGDlxmDPf6ub5ffACges4Bli8LedtwgcDbsJR/q?=
 =?us-ascii?Q?uIhd8Q1G1ZUuC5EjRbcoXMOgggtkBWUU8wivyiFXMB8Bf12zx7TPIXIHJOWB?=
 =?us-ascii?Q?K3mWDwJGyni7flIcVqoFah/SBYhZ2LuAudhlUz3RNjSPOINe5hDsCCPddU/A?=
 =?us-ascii?Q?PgpFPQLQsV45wl9T3Fy07xa1bsJSybypplcSdYJsu5Fnx8vn176a9kDsws3Z?=
 =?us-ascii?Q?tM1XAPLa0d5x4kTZeqEsno4INXwL1HEIuFNJuPwAbU6iaNeqluxzs6alwK/c?=
 =?us-ascii?Q?zrfswA++rN9geAa96Psviira7cZ2wpUcfmSSzxcvmmz+60Vp24nCZHP0Bkd7?=
 =?us-ascii?Q?JgQaTj/IIOhlB1gEpF1fZFnsFRCgFrQAZWGNPzTyNmkwwNsOnP6sziLGm3Eh?=
 =?us-ascii?Q?s7In/3gNfU3posU3AHri9Gr9YWSSrHt2QznKlqzdr3DYKnRB2IZCPGdNu0M/?=
 =?us-ascii?Q?W6IZBFIbfVPlfeiYoWjKsJ4roizLOXO7hAFf8xV52nUDrP0sTEjVjfSFDP6O?=
 =?us-ascii?Q?E6wH7nAPXg6M/XRjcTQ1P+o+m1m7pgyIDsdb4g5nF7QyjUKkz+VrmA9bHJkD?=
 =?us-ascii?Q?cGuh+Jr2ntGh6CKDQFhEpnwyPmTa+qAgw9CJEZLh0OxOUOt42JgnD5y/mRKY?=
 =?us-ascii?Q?1RXB2Z4T2v2HbN73Ds2MwcL/r+YyUBSyNZScLj9MmAwHT/P016b5KKIn5is1?=
 =?us-ascii?Q?ycbxjRGD1vueLb6jg05KXLwz6S6ChSzXTuUtHkbhd4JqRBlcKW8eqFGGLM/5?=
 =?us-ascii?Q?ShStMpuRDe25RZbPFFcRD0UIuSuJONLJD6kr0wcoCvN3jrMsAbKIThdjTyqh?=
 =?us-ascii?Q?gX7RV5s6CogT/KUi9KD+/1JMCN+/QO9+NxbviPyVEuRfsAd26zXeJH2fBY6I?=
 =?us-ascii?Q?YVsU4+O73FWmlrSaoykcWD5SFxSPlTuxdfwNFmysBctC200Z2eNptyIepUdy?=
 =?us-ascii?Q?cFzUqf8MAUwCLGR/Wv0xePyBrQil2iRhjsgaWTAVejMq4vrDsAF8kVBUzQ/8?=
 =?us-ascii?Q?0V2/DYaz8VVMYjt8LBiYZFI3dm5fRp+q2FuKbMBUivLQj5SaGaiXjCbyinVN?=
 =?us-ascii?Q?lyi0KJ0MRUtpES7Kr2h0Jd26kcnRiNlDpgJ9pFjjQng3VLqhNLYcC2Q4WJ1i?=
 =?us-ascii?Q?3M3fIXJHMFxLpl5M3fT1vDwPFZ3WOhnmb2r5aR5E7Ds/rci22CZpTDUonkLY?=
 =?us-ascii?Q?2XpGaK6vAO7SvyjZ3CATiDUtnMQx0xKsm1+oTFofZeqKlDmvhD+zq/5EnEzJ?=
 =?us-ascii?Q?QeoAFqYkCxsrURo7N07w8mZYPvF3+U3yyPUpN5RRjlY2SZfICC4rdXQMUB3G?=
 =?us-ascii?Q?2dOKQx3FrQJpzu6krH5/bgvjlXq8EccugJZBpz5fDLW6Awk9Eg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tckwQc4CFZgvxs4ejvX1EHgOJxmSzhFQFNQSrs6NDLwa97M7N/xyh6Y8Ul9w?=
 =?us-ascii?Q?LOAoe4FfANg0n0Q+CWADoAhho0wF1+Ymp5Us9z9cONAcCJlo/7yG5Q6Phb+G?=
 =?us-ascii?Q?C4d9UkDIIMBGEO/FZcikYTQTFIGbDaU0K1zuTaL4NteA1EyeeRfPoQBYHzQ1?=
 =?us-ascii?Q?anpHw2VzYRk1tve4owRiVpMrWlDVySkxB8khaU6u2ogkj3IsisaZDfSUm9Zm?=
 =?us-ascii?Q?38N9y028ppbkdip5cQiH+yb+uvWn2gpOHdKPdWsIktz7Taleukko3S0iyKU+?=
 =?us-ascii?Q?kV9txEEeMGaU53efm7EUC1xBf/LuNHSQP1npSniNrK2jl94od9uQI6zzUpNE?=
 =?us-ascii?Q?bDluHjlvQ/3rMSjROUxA22wjFt+an43jrrLZgKo1qUP+Y/Ji+fyfXlCNALv5?=
 =?us-ascii?Q?EPAoe9l8mK9e9GA23N7ghpHhVOeiekpjua6mdEuDqr0c3E3mAetqZS5tSaix?=
 =?us-ascii?Q?vXLxyErnwiR4JC/992G4xt2IbQx5LreWbLCV3+Xa0OwEdK4d4mm66QQMTFem?=
 =?us-ascii?Q?arOSxGxPCYaNk/4rGQRNvKAMIVoxwZu+B130fjcJhHm91tJ9+hPyyJ0Z/MH+?=
 =?us-ascii?Q?5yECtd0lrDwMr2QV4h4lCMOQdxMNhUVorQdVp/6WcfsMfT5J8e4ekZL63c2E?=
 =?us-ascii?Q?CPjN1N5zr5gZR2pvtormHbVAOdzWpEuBrBZ5ZN1DFmD7iPZEBXu7plWreYgh?=
 =?us-ascii?Q?Ro/fiOUSAulDlfcwakHoDeCkBIIMHj6q66SunIzYomgmRTc6Q6mfTLR0Hw7Z?=
 =?us-ascii?Q?cuqJiCBGVaHAMlvhxnCle2X4uj9QufXF9O2nQBp/ncC+EAXRS/4lWtDLkTo+?=
 =?us-ascii?Q?hmHcwGJWLnMGqUize050ynCteiNOacTM+qHHb170zxA8EtEoxXstJG2cvcPJ?=
 =?us-ascii?Q?CrvRUTBF7Lb4whNT6xK+e7PjSgvqdhjvO2x2Ju3HlDGPi67jJLAoUEBHLnh9?=
 =?us-ascii?Q?fDfbyfK0tvvddTborqsHlXGthOBSS5SqASpVQZfTvG5WSPfRr+vh6boQfhM7?=
 =?us-ascii?Q?Eis9yBQRs+CprF58gvS/gNZEh91wkI96yyQU/mH+po2IExzTxZHWsiQCR4bw?=
 =?us-ascii?Q?hCxrYkALpYJE1+0OD6w31h4hY4i6ET8X9C6NZOf3vTw6iQWozvecL2ulh5I1?=
 =?us-ascii?Q?4Wey7qHohVhiy18DdjbWt8AlnxHMol3MUEXVzYKTKwUBS4LPUnhyQ0NnnXak?=
 =?us-ascii?Q?Sytfhpwz1aYS/L2EtTygRIMWy0w03/kFIITaiDl4oqYpkbupwYnF6IaJv3Bg?=
 =?us-ascii?Q?7mlu9AeqsClX2DWFCOdWSC0NMnxMv8/78N1WHAfTnFaB8GPpvsWbhXcmaPlW?=
 =?us-ascii?Q?sQJBft08X1O9BQ00I4Ytj3Jl89U79u5+Y08wtuoQ7ydPUTmHQV2n9776vYB3?=
 =?us-ascii?Q?4UoDUxO6EYgtsfoDdEJiMxT7oltu1JIaG49+dMNQXT27qOhPXSfugjer8dm8?=
 =?us-ascii?Q?qOE8lXJcsrTGBjaJejNnsOk5yFn2OOrkWaisa6NNobKInTbGUhQHmUXLZDPg?=
 =?us-ascii?Q?lvwk3FIdjBLZ0fy93Lk1BlWZtR0YB+jZePqL66eEe3nwSG6XmW9ZsW4da67G?=
 =?us-ascii?Q?XjL3eVCsS2Z7FI0Jt6K+PoZXZlB0U3wdcC+kZcSw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f204fb77-cee5-4ced-1a9f-08ddbef83811
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:26.0090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dN/wV1arNJBLHv/wp4aHQVosWptD/AkyKmAYytglLaUgy1iNJz6M9x7zdG5qcxOO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

This will allow passing some software flags in the upper 16 bits in the
next patch.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/quirks.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index d78876b4a2b106..71b9550e46eb06 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4627,20 +4627,20 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
  * in @acs_ctrl_ena, i.e., the device provides all the access controls the
  * caller desires.  Return 0 otherwise.
  */
-static int pci_acs_ctrl_enabled(u16 acs_ctrl_req, u16 acs_ctrl_ena)
+static int pci_acs_ctrl_enabled(u32 acs_ctrl_req, u32 acs_ctrl_ena)
 {
 	if ((acs_ctrl_req & acs_ctrl_ena) == acs_ctrl_req)
 		return 1;
 	return 0;
 }
 
-static int pci_acs_ctrl_isolated(u16 acs_flags)
+static int pci_acs_ctrl_isolated(u32 acs_flags)
 {
 	return pci_acs_ctrl_enabled(acs_flags,
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
-static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags);
+static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u32 acs_flags);
 
 /*
  * AMD has indicated that the devices below do not support peer-to-peer
@@ -4667,7 +4667,7 @@ static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags);
  * 1022:780f [AMD] FCH PCI Bridge
  * 1022:7809 [AMD] FCH USB OHCI Controller
  */
-static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_amd_sb_acs(struct pci_dev *dev, u32 acs_flags)
 {
 #ifdef CONFIG_ACPI
 	struct acpi_table_header *header = NULL;
@@ -4709,7 +4709,7 @@ static bool pci_quirk_cavium_acs_match(struct pci_dev *dev)
 	}
 }
 
-static int pci_quirk_cavium_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_cavium_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	if (!pci_quirk_cavium_acs_match(dev))
 		return -ENOTTY;
@@ -4725,7 +4725,7 @@ static int pci_quirk_cavium_acs(struct pci_dev *dev, u16 acs_flags)
 	return pci_acs_ctrl_isolated(acs_flags);
 }
 
-static int pci_quirk_xgene_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_xgene_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	/*
 	 * X-Gene Root Ports matching this quirk do not allow peer-to-peer
@@ -4740,7 +4740,7 @@ static int pci_quirk_xgene_acs(struct pci_dev *dev, u16 acs_flags)
  * But the implementation could block peer-to-peer transactions between them
  * and provide ACS-like functionality.
  */
-static int pci_quirk_zhaoxin_pcie_ports_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_zhaoxin_pcie_ports_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	if (!pci_is_pcie(dev) ||
 	    ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
@@ -4810,7 +4810,7 @@ static bool pci_quirk_intel_pch_acs_match(struct pci_dev *dev)
 	return false;
 }
 
-static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	if (!pci_quirk_intel_pch_acs_match(dev))
 		return -ENOTTY;
@@ -4831,7 +4831,7 @@ static int pci_quirk_intel_pch_acs(struct pci_dev *dev, u16 acs_flags)
  * Port to pass traffic to another Root Port.  All PCIe transactions are
  * terminated inside the Root Port.
  */
-static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	return pci_acs_ctrl_isolated(acs_flags);
 }
@@ -4842,12 +4842,12 @@ static int pci_quirk_qcom_rp_acs(struct pci_dev *dev, u16 acs_flags)
  * and validate bus numbers in requests, but does not provide an ACS
  * capability.
  */
-static int pci_quirk_nxp_rp_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_nxp_rp_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	return pci_acs_ctrl_isolated(acs_flags);
 }
 
-static int pci_quirk_al_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_al_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	if (pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT)
 		return -ENOTTY;
@@ -4925,7 +4925,7 @@ static bool pci_quirk_intel_spt_pch_acs_match(struct pci_dev *dev)
 
 #define INTEL_SPT_ACS_CTRL (PCI_ACS_CAP + 4)
 
-static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	int pos;
 	u32 cap, ctrl;
@@ -4946,7 +4946,7 @@ static int pci_quirk_intel_spt_pch_acs(struct pci_dev *dev, u16 acs_flags)
 	return pci_acs_ctrl_enabled(acs_flags, ctrl);
 }
 
-static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	/*
 	 * SV, TB, and UF are not relevant to multifunction endpoints.
@@ -4962,7 +4962,7 @@ static int pci_quirk_mf_endpoint_acs(struct pci_dev *dev, u16 acs_flags)
 		PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_DT);
 }
 
-static int pci_quirk_rciep_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_rciep_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	/*
 	 * Intel RCiEP's are required to allow p2p only on translated
@@ -4975,7 +4975,7 @@ static int pci_quirk_rciep_acs(struct pci_dev *dev, u16 acs_flags)
 	return pci_acs_ctrl_isolated(acs_flags);
 }
 
-static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_brcm_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	/*
 	 * iProc PAXB Root Ports don't advertise an ACS capability, but
@@ -4986,7 +4986,7 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 	return pci_acs_ctrl_isolated(acs_flags);
 }
 
-static int pci_quirk_loongson_acs(struct pci_dev *dev, u16 acs_flags)
+static int pci_quirk_loongson_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	/*
 	 * Loongson PCIe Root Ports don't advertise an ACS capability, but
@@ -5006,7 +5006,7 @@ static int pci_quirk_loongson_acs(struct pci_dev *dev, u16 acs_flags)
  * RP1000/RP2000 10G NICs(sp).
  * FF5xxx 40G/25G/10G NICs(aml).
  */
-static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
+static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u32 acs_flags)
 {
 	switch (dev->device) {
 	case 0x0100 ... 0x010F: /* EM */
@@ -5022,7 +5022,7 @@ static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
-	int (*acs_enabled)(struct pci_dev *dev, u16 acs_flags);
+	int (*acs_enabled)(struct pci_dev *dev, u32 acs_flags);
 } pci_dev_acs_enabled[] = {
 	{ PCI_VENDOR_ID_ATI, 0x4385, pci_quirk_amd_sb_acs },
 	{ PCI_VENDOR_ID_ATI, 0x439c, pci_quirk_amd_sb_acs },
-- 
2.43.0


