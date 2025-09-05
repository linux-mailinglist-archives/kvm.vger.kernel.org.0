Return-Path: <kvm+bounces-56906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B92C2B461C6
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 20:08:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66FDE1CC01E1
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 18:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3E731C588;
	Fri,  5 Sep 2025 18:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Cc+mn1oM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347A1393DE9;
	Fri,  5 Sep 2025 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757095608; cv=fail; b=Djrol+3aPc/5D3MRu85ySWlMBr4HOI8qDfjXcMeBOtulii7X8ANf6h0jBjBk/me753RKWjdTjVSszgcmb9hCag5ko5BWqUZEdNH0dW9ZN7cDAb3ZAAMKDp1s6MCRqhBllcMM0/fgbvqIRx2LZK5z0miWT+4wEg4VVVfcIu3mPZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757095608; c=relaxed/simple;
	bh=xQx/H5OaNpxS17whqVN9TR6k8sdXeWuMQSqA0Q8bDiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OD8jhMyPL16rDmOQA0Z3io/gkIQg3T73rmsrRFWP9RszfUaBnrTgCdinx3hgMHSE24yb6sJyeXbU5+NQUw5vFQxWgUZg3+3nPWFwUS7hL4f39Td/JE8ZfxSYdqKCAUFYIymFor6PaVdRuTLUy7nka/8fHHmT2JzGJw9ZdKUOduY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Cc+mn1oM; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RgZi92XvH5EdUSkDIHcJFbsJWdpY3iIuhYykknhFVdqEuDgeljcFonx/kSLNU/yGvqQkOk8PmixVJt/89Ycr/kW9wo8togWJHFBhDRiNGzv5loaIixPIRNeE9WwVSswI5H5AleBTPunl2dGez3gwLf6tTDQ/XJtUoy/lkzbZsAJFzQhXg8RHdvyjDwywTRXFQ1GO2f0v5Bs6+3mFz7rQMl/eP3KO0CYVEnvy7/kjsw0WEu9qge3SE5cOhFfDqPAt9wpCfS0Bp6cEzNXBWnLvho8j/ovM11XPtqBPp5lOKXRNbM/uisRk3IgcqaLn6ReoMnRYTW5CwD6Fj1LwHKkacQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PxQeluLSXhaNlnRzjl2cS8uwnCVKeGKWD1QQea4T4u0=;
 b=kzRd5uR/u1Je/wm0y+krQzBtR4vyPI4G5rg6Y2Dwtwt6ChYHKuiHfuW2IDCS1o1XlVLZZedyqC8YPafqV441HV/pFll9SWvoUcS7NT0IO7Yo/EmiZ1Mr2W21VNmT3+QtY10mj4S3w0skowP5U5uRFs1smF7Bjw/lv7zW9OHW3fikd8keZORC4QgqqUEGV9ZqVrIhE0yzfEVJ54XtDeKpy6DYUIAxV/sraAjh3lQUoUucKDpW2XS+gqcHoOSyWroeOn0M1MeLp9KJX4zEMvjwbxlmKUVXNQ/ygBz/qR9Mx9pIP06QTQOJ9QEMjwDwvIcuplWE74FpxTWR0oQRvZ16Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PxQeluLSXhaNlnRzjl2cS8uwnCVKeGKWD1QQea4T4u0=;
 b=Cc+mn1oMMaa7tod/ReN+RXHNzdrFYUGl1TGHogUgsO40EgBKrkefr5QX9+jmGyxQYevpBECG90KDsRaNgzEE1zjA7errC1UNH+yM7BLQhPIoNDPvTpYhB39JWtEMWjJMekOWf0RSy2g84hCnWIKr8eIFTxQfnZh47CZiCY2mGUlopEDFy+RGaSAQFXEGHc/O24ckQCjFjv8p/Ppu/ZFSzptRL317JOriimNrvAwvyvCpJTvU2+wrRa5WjXsbRaM0VtWHrawOUcpKSaMmPQ2oEA94ioI5jyT7S8J6RuSDHFUZ7oGIyYRN3mizPbPyJKKLNisrYq8kG6+2iXTyiMS3iQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 18:06:37 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Fri, 5 Sep 2025
 18:06:37 +0000
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
Subject: [PATCH v3 09/11] PCI: Enable ACS Enhanced bits for enable_acs and config_acs
Date: Fri,  5 Sep 2025 15:06:24 -0300
Message-ID: <9-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0015.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::22) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 38de35b4-4c34-4edb-241f-08ddeca6f2ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rjakxzJ7xZaA/rPuL8Pq0S2u6an8sBQKwZbgzFDvoZhH+xs6r8Nsw+xcOn3e?=
 =?us-ascii?Q?Zbk0ouAIcCzgjsQ/BLBJh7v+ZR1LUbnGw4eboDDmsbuIu6HtmLxnFurHbU/A?=
 =?us-ascii?Q?6K4d/T1j1SFcVLvy1L/kaM+5nQXPD25uS9kjkzMvyL3y+cmpt/+effSOdhRV?=
 =?us-ascii?Q?qhsgn5Lth/uW+DFTJeT6syJQ284v/s9CshwInwf+zGI3cuzjYyqL5gfGFvbf?=
 =?us-ascii?Q?J1tsBNkmI34dZEzA7Q8XN0IXqNcpugJcX9UaEQLdSFOybGxPdHha7nnUcrta?=
 =?us-ascii?Q?+5lyFvq8XqyGjbjezdikdyZzzOIk/aYA7vCrGWKvL6QfWBDTH+XShZFauKSY?=
 =?us-ascii?Q?L7FzHr8SfqFgo/E8+logWId9wu/3aS/gDjpQXvzfADfvBgRG9weohkatd/oH?=
 =?us-ascii?Q?2AFdGZ0zi3Ry5ephJIVmRLerBjh6Ck+lY0J85q2Ywrx40eR+9jgR3uctm9qQ?=
 =?us-ascii?Q?8+4xEDru62WSvDRIete1g3TlAtTTIak7d2vtat0IhJUEul76f556bc0dseRD?=
 =?us-ascii?Q?+uC0LSP+6WB+pdy6avptL5Y+jZYuyYRpydS0H7YsSYcbYR575mVQw2TygBth?=
 =?us-ascii?Q?DLaF3Xn3AZ21PwyPwL9BgXhWaSpDzc8r9dRJoqGp2g/lV4wPh+9jTchP+BJv?=
 =?us-ascii?Q?b7l4ZAyJ9s8wcAa3F/FhlTBIxfNYkbETmBdZPFf0LUicVcZnLWxcafIOAD7T?=
 =?us-ascii?Q?7WPu/6A+8YsDdaVhM1LUBpfoSg31e6dWErN76zA1X1Pn5yNo4lZ7GJi78zYl?=
 =?us-ascii?Q?cWagbSZZxna4e8irkMZsMtagQiDFb8YI4C++sN0GodHS2+nG/eqQjdfGdeZ7?=
 =?us-ascii?Q?GO7xu+o8zO55y0zAxC2h/gLFDpcewG8tYptm5TaozTnIrel2m2vX5S8a9rFS?=
 =?us-ascii?Q?EiFB2hJrZeNPgYllO5TnA4qSPlsN4EG/n9tfyfIK1jcTbP2Kd+jA+eD/d6pH?=
 =?us-ascii?Q?DttfWEEm5NB0m4BFjecwDsYTgvwMnde3iaZdVVdHn0L8u4l7DGvQyACXoHJF?=
 =?us-ascii?Q?Qa+3DZNfS4cU+l7kXDcPj5Y4xLebrgWeGO1s/FBNtWRbGzgM20CqINr4xH5u?=
 =?us-ascii?Q?V41Y+J/bw2DlwYWeoVsBlEmM76/ZjatfjeVEYiHoTh6qqZi2V5NIgrXq9dot?=
 =?us-ascii?Q?WTykuqPAqtWcTs9FPd8xIW6FXuHHm6cEdpL4+adXwx8DrsxftPcYALWQT6FF?=
 =?us-ascii?Q?xdbu/Cm2uWDbvlsZlNg3ucXQbZlQamDExWAP+p/dQyjH/aGGazffH8DI8J7k?=
 =?us-ascii?Q?AkaS+DuhyrCb5UuPy/LYtZuXG9y5M2IsJsURtIJtPr3xm+RwC5ubxGrxEeEE?=
 =?us-ascii?Q?P5YWcohKhRQKvRzQPq6WxkbHdwarvTE8wJuQN5ZoFxK7YGsuulIqjeFGJ7sp?=
 =?us-ascii?Q?fU56PlCEITPAikP19oUayLodvU+dE30BSWqzhAdZ8h8wFBrItesKJG32iZWi?=
 =?us-ascii?Q?c4TZuxPrkqU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ph/XSFSuFdP6AHGG2wHAYjixMshL0xsD6/zpXLCHIIWWWAtNCsiRNRKhapyO?=
 =?us-ascii?Q?I19rEtGPVxB/TXV5pXV0FDMVF1huibwDIazerELabbrgTUu+40Q27iM39yWR?=
 =?us-ascii?Q?yu7TBm/Hr6pqi1L0w4tOSuDr4U86QFsdLovthgI0Bnu9uu/f+W/BPZUp0eWC?=
 =?us-ascii?Q?iAPLGCaEHpS2Csa5qf4lfANDc4Q051vp7rhoxVFsnyYCbhROzAo8Itih3i5I?=
 =?us-ascii?Q?wzzpJQ+/7Mf3De3k17O78edLYXK9FzznnFMEDfM9AWc4v8VY7eGmkI4D2gZw?=
 =?us-ascii?Q?fGThjO2tDnIGfLCuj6yqjeVc7j0eUqoKphU/9hnGoONgFsdBzn0/KGYcOkBw?=
 =?us-ascii?Q?m4+43PCRx7OV+45ExXTf3s0y8q7eaUt3QgZRG62wWx6WFimDs/i1gsObsH9j?=
 =?us-ascii?Q?SfrzDPqwj8/qaSaoyJTDqJ8R3/JwaOVXLLeypU2zg4j2Vh1xW+g3gbkzZxb7?=
 =?us-ascii?Q?aU74XIebw7P8/dXD8UkhL8pQyrpQAcq1G+8KPLSQSzgLUXjPCE/L7kYQvuv5?=
 =?us-ascii?Q?ugvxvdYErkt+eVjvZqx8CIihL8G3rfq905tvkgcShmXlaccm89IF9kdbljXT?=
 =?us-ascii?Q?pj3LJGFQpcPViGdVvasAG/SFgc+niCYuQYea6FhyG8Sqc7Mfexo4k7AgNHv7?=
 =?us-ascii?Q?fVNP2mQ+0dX6uH46IPXaOox04FTJXGIgpovsnbTWcMdBACEQ/salpiCePbH7?=
 =?us-ascii?Q?wJIhQt5+zVRpBTwCiYig7BMICFIzwaf66Pwg8XuMV9Bun8JwwxZS/KxHsr9p?=
 =?us-ascii?Q?ga9QA+8PVMnLJWs88Iv74Tcql/3goA/3ZXTboq7NWKW58zcHPu1U5UW82EbF?=
 =?us-ascii?Q?oHpn3eYLRkjbgM2nMgk9WSorU89MTE10SXhZFD9KHaXWSrGdwI0/TZo093R1?=
 =?us-ascii?Q?5+UFmMwqaYO4HRBZ+KwblwrHFM//66wdD0XTiZtXxvnuFPnxT9iEv3RO+J5y?=
 =?us-ascii?Q?E3JBNIr25a2oF2v1Z6Fgjd4o1/2lnBeEVpVeRBvzmtAU3Ajdtx4lLOZg4lpa?=
 =?us-ascii?Q?VcogG8E9bnPJ6EK0Laaf7G85/HKNHDVeg6OOu0GtPE8boj1JGHdGmc/f71qc?=
 =?us-ascii?Q?NLTMfcu9VMV/yBjKMqhk448Ic/26R1SmWE7eNgz6gkCIM0RtGHGqwJcOM3yr?=
 =?us-ascii?Q?+rjGMqfN2qxz34mgZ/PwoyjgSu+kZAK7Za1P3s1DUsobDjaa9f3ORPbw10Za?=
 =?us-ascii?Q?lfVrX3s1+AusjZ5pRhVqz1B6QghJCaDwzrodpGIHXQC7/YK19ou9336tAvCX?=
 =?us-ascii?Q?Q4Ivnz7kmwCBv+YiHYwbZT3vdzHxIqXw/ULWstNdqzRQ5hC1bohwSOCGjmhC?=
 =?us-ascii?Q?l2rgeS1g4JNssnZtfhRWXnCagY2HG5SI/1ppovdROj4uoaQQPmZupzI8C+wd?=
 =?us-ascii?Q?WNSqPS91X6GUbHYhkhhdi1CgRPLmbOb0PuoYgP169lEI+qD2SEhZPWeZnJEV?=
 =?us-ascii?Q?hAvzzdvj5tuI2CE5c/FURsiyg1aoCkTFwOffo+9cs8iZgDk5wxGIhevxNE2o?=
 =?us-ascii?Q?83qjKd9DL11oSX18bykT0yo/2LbtY2LQiZfklb6h6p+RYLycudJ3WVLLAvbH?=
 =?us-ascii?Q?aDtVkd50VZQEppv4Eas=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38de35b4-4c34-4edb-241f-08ddeca6f2ac
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 18:06:33.7752
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b/ScR5QEycXmYfO5RyQryBD/jp9dobEged0o5hDkYm6BVHkRvRlovN0a04tELJZ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776

The ACS Enhanced bits are intended to address a lack of precision in the
spec about what ACS P2P Request Redirect is supposed to do. While Linux
has long assumed that PCI_ACS_RR would cover MMIO BARs located in the root
port and PCIe Switch ports, the spec took the position that it is
implementation specific.

To get the behavior Linux has long assumed it should be setting:

  PCI_ACS_RR | PCI_ACS_DSP_MT_RR | PCI_ACS_USP_MT_RR | PCI_ACS_UNCLAMED_RR

Follow this guidance in enable_acs and set the additional bits if ACS
Enhanced is supported.

Allow config_acs to control these bits if the device has ACS Enhanced.

The spec permits the HW to wire the bits, so after setting them
pci_acs_flags_enabled() does do a pci_read_config_word() to read the
actual value in effect.

Note that currently Linux sets these bits to 0, so any new HW that comes
supporting ACS Enhanced will end up with historical Linux disabling these
functions. Devices wanting to be compatible with old Linux will need to
wire the ctrl bits to follow ACS_RR. Devices that implement ACS Enhanced
and support the ctrl=0 behavior will break PASID SVA support and VFIO
isolation when ACS_RR is enabled.

Due to the above I strongly encourage backporting this change otherwise
old kernels may have issues with new generations of PCI switches.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/pci/pci.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b0f4d98036cddd..983f71211f0055 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -957,6 +957,7 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
 			     const char *p, const u16 acs_mask, const u16 acs_flags)
 {
 	u16 flags = acs_flags;
+	u16 supported_flags;
 	u16 mask = acs_mask;
 	char *delimit;
 	int ret = 0;
@@ -1001,8 +1002,14 @@ static void __pci_config_acs(struct pci_dev *dev, struct pci_acs *caps,
 			}
 		}
 
-		if (mask & ~(PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR | PCI_ACS_CR |
-			    PCI_ACS_UF | PCI_ACS_EC | PCI_ACS_DT)) {
+		supported_flags = PCI_ACS_SV | PCI_ACS_TB | PCI_ACS_RR |
+				  PCI_ACS_CR | PCI_ACS_UF | PCI_ACS_EC |
+				  PCI_ACS_DT;
+		if (caps->cap & PCI_ACS_ENHANCED)
+			supported_flags |= PCI_ACS_USP_MT_RR |
+					   PCI_ACS_DSP_MT_RR |
+					   PCI_ACS_UNCLAIMED_RR;
+		if (mask & ~supported_flags) {
 			pci_err(dev, "Invalid ACS flags specified\n");
 			return;
 		}
@@ -1062,6 +1069,14 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
 	/* Upstream Forwarding */
 	caps->ctrl |= (caps->cap & PCI_ACS_UF);
 
+	/*
+	 * USP/DSP Memory Target Access Control and Unclaimed Request Redirect
+	 */
+	if (caps->cap & PCI_ACS_ENHANCED) {
+		caps->ctrl |= PCI_ACS_USP_MT_RR | PCI_ACS_DSP_MT_RR |
+			      PCI_ACS_UNCLAIMED_RR;
+	}
+
 	/* Enable Translation Blocking for external devices and noats */
 	if (pci_ats_disabled() || dev->external_facing || dev->untrusted)
 		caps->ctrl |= (caps->cap & PCI_ACS_TB);
-- 
2.43.0


