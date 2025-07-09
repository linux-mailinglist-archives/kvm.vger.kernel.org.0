Return-Path: <kvm+bounces-51976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79425AFECBC
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 16:55:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AF80646200
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 14:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 179B32E9ECC;
	Wed,  9 Jul 2025 14:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qu1N/xqV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6150A2EA14B;
	Wed,  9 Jul 2025 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752072763; cv=fail; b=eZHbtg4TFm/nduaEPVpO3ajp+0vr0xjyUp92WQExZCCm1aZjYQIt69IsGIJxEM5HF65CMdjiPfE6U2Mgq0YiEkBvjfRNAL1l7XC9H17gRFC4wqsScNdLY3kSdIyLpNWSLsAqVlhQy2MWKRjz2uCY3vOcNv7tmcw10NQXPMcAL8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752072763; c=relaxed/simple;
	bh=IUJwbSljjGPprPPrrxk07tF7P+cYDvOKWUv0tEf2Ktk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tfno9lKdMmPYBEoHvScNYiZ31epiYiweDaPRImJwT39Odgxnvr4IKKqbIPIT+zjmwnfWJRwfNFD2AJKF50YQi8sDasm3cjcv+Ui74EfJ08rc31GvcjS7rgeCYgWMW7qvwm0ektu8M3Zy9ujS7rbmyd4ViHrWukg88hOQ4I50m6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qu1N/xqV; arc=fail smtp.client-ip=40.107.102.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ezQPvGvRffhDF4XTVRUMiNHdNjscQlr+uvhS793Sqz8zCZbymmO+H2Psz7mds8tGQ8BkuR5cEn23dyiQr1xVpXb45ln84dKaWTTMxUwrF/uzFTtLZgZEMGRBovf0IldTyP3nd7LSCo8dPPwND7upI04IyfJ+dQ/AVnt+R2dVWIom+oJBy7jSVurKYDFp/+k7Y/VasklSd5hD/JumiTbepPiUTAq2mphg8v0RC/5pAaOlUECa4VtW7CbFURSCDH6Q5WTgqZWHZ+ITD9HsjC7LIO0J1gujgNzZX7rI16TOK05rKKv2q96LEMj9au0z4KQK9CPPER8upnVrZJ7GhVR05Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Kg82F7YuBWWH5s2f182ITetGjYNikELvPCgChldAIE=;
 b=lkKThrrLy5+IW+sxTX/+ctfsMUX/6sUTx7kb3DtJpHJ3uy/IpTgLo11lQPVckiQjd0MYT7/yD48ZOMcacHwMrnGwLUXtQCe9OUSQ04jixGprylSEVNkyIywWa90k2TlaCkk4Xo/bTX5/AMblLct6Ah2tG5L+E1oi6nCsSX6P+PfGIHsUmq+Pasl4WUkgAPF0y95IcqYUplUU2FPPNFilQ03Hz3qECxWtF+cI9L4DxW9iYCnZV7agl73RGLL/96IdlRsZL8yxtiOmTh7cr+ptXDMAtaIzAnXGew7iNPWYJl9QW2mGbhgnCDFUoUcSCAfedc/kFIBgHVpx2gDXaCpNRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Kg82F7YuBWWH5s2f182ITetGjYNikELvPCgChldAIE=;
 b=qu1N/xqVGbcjHyZc1gTGZyrJJOFMpYcXyYnk2kk/lt7gQQZOzAU11eUa5OoCNGoYmpVpjjgBJumUKz/skI/ABAhlyxcqTuuaxH+sMu4calPCFJWLqXAKReVjBAs16VghXGC689d2igunUOgYtywP561NmraJt+ieUtzLkAPGLA8kzWZaJxvpTSCw7gCz7qB3JeL3Ia25v0hHpTd7SyJkKQJ05GYNCsInMqh6T3FaTEmf+RTYQ1U4a13k9rhYs5PFIteowN2i01Ccpn8CZzhPJWTd3sy0W2/eFZuBRnl/mekQlethHbC1jspqmdWmbzb97spUpaEItY6iPTO9RxNeBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA1PR12MB6356.namprd12.prod.outlook.com (2603:10b6:208:3e0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 14:52:30 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Wed, 9 Jul 2025
 14:52:30 +0000
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
Subject: [PATCH v2 11/16] iommu: Compute iommu_groups properly for PCIe MFDs
Date: Wed,  9 Jul 2025 11:52:14 -0300
Message-ID: <11-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
In-Reply-To: <0-v2-4a9b9c983431+10e2-pcie_switch_groups_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0118.namprd13.prod.outlook.com
 (2603:10b6:806:24::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA1PR12MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: e0fec9c7-35ab-4035-40a7-08ddbef83935
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VFjNZsrVik4NAV+OT19euwjdw3vRh+uosDEimbCLQjwvkuTKZ19sMESEqo88?=
 =?us-ascii?Q?tqE8uuFSlvGLJofBpBeXE8KPoe5i1Hof6132auKb4Y+U/6sTJQ5NX+jgyQ5y?=
 =?us-ascii?Q?+8RZtFS+P6YxAe9kZfjg2H2JUoHeuGWGLQYhEgSMJV/X9sjbPSi6G0utTKtD?=
 =?us-ascii?Q?os1uYYvk0L55zQUyan5GrNEqleeFNW3gskXa7wiUH9GJVUDVVnV41+7EC7RU?=
 =?us-ascii?Q?XwF/HPKfNDepe4v3J4c8g9ti49UZbvkPzTV+dScmIN2C4i5+BWACPrOCxXtZ?=
 =?us-ascii?Q?FrStQZUmDdsPqywODPqEbq7EWNWbGaxBqweg6Dqa9qVyZ8ZdulP8zxtSBU+b?=
 =?us-ascii?Q?rn5nylt+L4JAjdh/s3oCyDiHUFtI4StPplYc38p3lXs67GEM39h/GAZ+RvuN?=
 =?us-ascii?Q?oCahRILBi0sUrx8bjDzSiLhQscNeIFuBZSmmQQZn5cpBPBatS1y4PKpHUm38?=
 =?us-ascii?Q?RYrDL464FmMBrLd0hZ6bGKIuLvDUgbffPcqpv/V/4eewIcUhuj8KTNWYuZug?=
 =?us-ascii?Q?pDRFlDs/78JzSHDR/jCdcqkNCfJzLeXr5M/AcRd1XkqI8iHJrFlhlsGDME5M?=
 =?us-ascii?Q?sPcjtxVSk8jLUnPqyePnLCjTdDg8bIX/Eoibcg9C/BpHdMpa6RbmBeHQdSOF?=
 =?us-ascii?Q?FDR93/aJCIV5YaPGUnwqP8c5+Rsf7Kd7eY/aadg45SOMZiLGVyMSKpO8iClq?=
 =?us-ascii?Q?pLO0A9fBTtdSJVcbbW0IQ/RHA0APE8pcel9dz1+6PG56DpGEXyP7LxfyvZcd?=
 =?us-ascii?Q?0N/XiIm/+X/VOuRd9qaut0qWFjP1Z2DT4INPOp98DjE2ETMdjiU9VN2KCqSw?=
 =?us-ascii?Q?swyBpbRENsGLeeZ1hHiu6PfEnUf4b4fzDHCrJnjbdESxOeAXGcTPLhx76fEj?=
 =?us-ascii?Q?mJ3YDyCoyQrqbal5JOJoeZlPuZ9hsZy6+f3mz3HYtC0bK3F0e0jTGsudf07l?=
 =?us-ascii?Q?tEmLbLpdMFyzLqqfw7NIfcDkvnatS7F74WDVpIabknkXhgodPr9J8CUlmVRQ?=
 =?us-ascii?Q?wqM/Jq+7Klr4nu4cXO8IU3bxlioTVCKA0ZZ1tL8MQ9pGvOhM1dAXd7uJq4bV?=
 =?us-ascii?Q?dC6qyTGEwYXANryP163noNyJkCFKuUFuVSOMe8mnSRPCWQeLJGoHyJ3TKAxM?=
 =?us-ascii?Q?MpOYYjCdazmBenYmbwqR7OhfNP19RH/gyVmNtfXq6dlMdG9fZZuAPTDgTl7o?=
 =?us-ascii?Q?HPi476irNHWawU4zlEvx1IYFWwQI7XAqYRvrbwiN8FrdGrT8KN/uKwVfx/el?=
 =?us-ascii?Q?1QKfT4kqro2dOwFFRjNUJ5nIG9J/+v1M8poLQ3DNKM/spv2IXXTicoEblcQK?=
 =?us-ascii?Q?/dz6pbcB1c8S8CT53OTO/vWS9Ga0ooVmBAz8NNz24jd7/cOOkBEJkDuqrIzp?=
 =?us-ascii?Q?cCs1uf80aRXiGR1k34nSqqqnhHuh1UDFxCDxfhybdI3TeJ/u8gnEr7M3zBPF?=
 =?us-ascii?Q?kjTh5uagf3M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ae5Lf1HEqz161OJ8vataamTl6DjmTcGwrTdR4i3xcow5gRCSAHHm3WYXKAXe?=
 =?us-ascii?Q?Nilj41HRxiHv2/BwMnJo0yEHHZXwR8l+C1LweQoQaEVT+AotX5IJTOIDwUO0?=
 =?us-ascii?Q?wngLe+/6N0haXfMuN2qe1eUi2mIRr3KFSMymR+4cx5eqbVWwfOvs/0O4grMw?=
 =?us-ascii?Q?Mj0qIfZzwIQzhKVj8I/u/0IfKUKwPMPuBH/8DX4PMQSknAGJ5GRsSEv7Q2FO?=
 =?us-ascii?Q?PGPf+gQsE2sVVyIsiNPtE+a5WWP849Ayw5Q2EknTiTLAMVj8TARFHNiCstig?=
 =?us-ascii?Q?L8fEIUP1cAKVGwOQS+xm9HAJCywyTpJVNjV+QYXs2K+c6qpPTZ+piGnCUJ2k?=
 =?us-ascii?Q?FNE1gtfr/3pVJuy9PfVWFW+f7fBTKN60FCXLpatLZ1loLRfZhn2q4dRWLqnw?=
 =?us-ascii?Q?jf20OhvS+I1zgDGUCoP2A7lBvoob/zyY8oEyrlsml68s4cCjO2q3MdWSysa3?=
 =?us-ascii?Q?+zf/Z4aV+O2bWWNuaxUKT59hD/Zz5SjTaEiTb12ST3r9JoK0tPxnUTAy1kQS?=
 =?us-ascii?Q?RP52x4m4yCue4Mjxy37LOIpcYlZa7BYZRbhb37w0PHE4u7r8ZHs3LOqi3LCU?=
 =?us-ascii?Q?cJLyIOXrKGMVamjsD70HD/WFo0n0LharhH4FRv02RRdvsPIsKqoHm8mIepW1?=
 =?us-ascii?Q?VoXQFnEjIV+DS4oWoUOdxMjsKOGuTvILNtiinkVFAyx04sX0HEkf4AZAuXWz?=
 =?us-ascii?Q?MXO3vrJaKrOGl6V95e/JpPzxlIczPbwn4PuJNYAKK+ar9jimvonHxDrxHget?=
 =?us-ascii?Q?2FfdHsfRpS7dRtxPVyntHNLa7aXm6phbQOsE7LCsCOh85X3CBDvgnL/rYQHs?=
 =?us-ascii?Q?OtO5F6r0d1SoW99y0laKpHf1B7gz2NQ4n3QL+Y0EPFvyWefI2rcFCkKiF+oo?=
 =?us-ascii?Q?ZKBPO7FxMpSGaMDiI+wkCgtGx4MBnnnN83noHFJ4agRYwdUaamamclYjS7bY?=
 =?us-ascii?Q?vihe6Mdzi1cASeqM6zSSc4awr9YtnPU1UNWY6s6iTb8bwUPBs+9Aw/GQkxyS?=
 =?us-ascii?Q?Q5JII2C46tuegHZGjiVBplKO+9pGhdbZIbGM+e4jttjg5LqnvWjujEqias/f?=
 =?us-ascii?Q?a1Ses+rtHsBh5S35r44kFPnHEW0tFwqUGkrNDYM9Pn72P6uSElZxGRQX+1vE?=
 =?us-ascii?Q?a5lF7CO6XcbWVYMdnmC5AcfTdyM3EgSn+6kpBWCRza5kBXZnnUH7XT3SOdDG?=
 =?us-ascii?Q?6m5SMkS3lxBqrtjjDpG1PYmyznvniJXUN8fDPohL9PDfFP8aFLtdInWQSPsZ?=
 =?us-ascii?Q?8uF1q3mBqB22qzW8WyNljXXWZZGfAkcWlRicbp1vvvusGEXDwkr09pEHhnz3?=
 =?us-ascii?Q?AcCFh1krqTxq9QEmBWdm3f7DiA40q7lRCl/pDJ5rm6dtEUdzQjcS8dRX2mTC?=
 =?us-ascii?Q?s8fsG2d5rJXdZwCw9pyz/R3kBS2MrmEq0G7S/pCyAY8newZ0z5bXFI8mY02V?=
 =?us-ascii?Q?RPAlivQoF8CgVlwu05BTC+pKQURsCmLpBKn8LG+HJAd646s+sUax4mqK0SSI?=
 =?us-ascii?Q?X3Kuo8XW/sAZRTY/w3rODzGZ2Jfct73R3vYYh7SAHYJwvHbYK5ayTjpO1GMl?=
 =?us-ascii?Q?eMUEDak4T/d7Ezj1AVGZNT3ZV3TP2Ls20txl0Ygd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0fec9c7-35ab-4035-40a7-08ddbef83935
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 14:52:28.0997
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDowoTeMiPvm6pNm8TCiKuwMi+fyC6mlmRxJZSYReKNeLN55dAC3yuLCkvQH2yuF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6356

The current algorithm does not work if the ACS is not uniform across the
entire MFD. This seems to mostly happen in the real world because of
Linux's quirk systems that sometimes quirks only one function in a MFD,
creating an asymmetric situation.

For discussion let's consider a simple MFD topology like the below:

                      -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
      Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
                      |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS

This asymmetric ACS could be created using the config_acs kernel command
line parameter, from quirks, or from a poorly thought out device that has
ACS flags only on some functions.

Since ACS is an egress property the asymmetric flags allow for 00:1f.0 to
do memory acesses into 00:1f.6's BARs, but 00:1f.6 cannot reach any other
function. Thus we expect an iommu_group to contain all three
devices. Instead the current algorithm gives a group of [1f.0, 1f.2] and a
single device group of 1f.6.

The current algorithm sees the good ACS flags on 00:1f.6 and does not
consider ACS on any other MFD functions.

For path properties the ACS flags say that 00:1f.6 is safe to use with
PASID and supports SVA as it will not have any portions of its address
space routed away from the IOMMU, this part of the ACS system is working
correctly.

This is a problematic fix because this historical mistake has created an
ecosystem around it. We now have quirks that assume single function is
enough to quirk and it seems there are PCI root complexes that make the
same non-compliant assumption.

The new helper pci_mfd_isolation() retains the existing quirks and we
will probably need to add additional HW quirks for PCI root complexes that
have not followed the spec but have been silently working today.

Use pci_reachable_set() in pci_device_group() to make the resulting
algorithm faster and easier to understand.

Add pci_mfds_are_same_group() which specifically looks pair-wise at all
functions in the MFDs. Any function without ACS isolation will become
reachable to all other functions.

pci_reachable_set() does the calculations for figuring out the set of
devices under the pci_bus_sem, which is better than repeatedly searching
across all PCI devices.

Once the set of devices is determined and the set has more than one device
use pci_get_slot() to search for any existing groups in the reachable set.

Fixes: 104a1c13ac66 ("iommu/core: Create central IOMMU group lookup/creation interface")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 173 +++++++++++++++++-------------------------
 1 file changed, 71 insertions(+), 102 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 7b407065488296..cd26b43916e8be 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1413,85 +1413,6 @@ int iommu_group_id(struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_group_id);
 
-static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
-					       unsigned long *devfns);
-
-/*
- * For multifunction devices which are not isolated from each other, find
- * all the other non-isolated functions and look for existing groups.  For
- * each function, we also need to look for aliases to or from other devices
- * that may already have a group.
- */
-static struct iommu_group *get_pci_function_alias_group(struct pci_dev *pdev,
-							unsigned long *devfns)
-{
-	struct pci_dev *tmp = NULL;
-	struct iommu_group *group;
-
-	if (!pdev->multifunction || pci_acs_enabled(pdev, PCI_ACS_ISOLATED))
-		return NULL;
-
-	for_each_pci_dev(tmp) {
-		if (tmp == pdev || tmp->bus != pdev->bus ||
-		    PCI_SLOT(tmp->devfn) != PCI_SLOT(pdev->devfn) ||
-		    pci_acs_enabled(tmp, PCI_ACS_ISOLATED))
-			continue;
-
-		group = get_pci_alias_group(tmp, devfns);
-		if (group) {
-			pci_dev_put(tmp);
-			return group;
-		}
-	}
-
-	return NULL;
-}
-
-/*
- * Look for aliases to or from the given device for existing groups. DMA
- * aliases are only supported on the same bus, therefore the search
- * space is quite small (especially since we're really only looking at pcie
- * device, and therefore only expect multiple slots on the root complex or
- * downstream switch ports).  It's conceivable though that a pair of
- * multifunction devices could have aliases between them that would cause a
- * loop.  To prevent this, we use a bitmap to track where we've been.
- */
-static struct iommu_group *get_pci_alias_group(struct pci_dev *pdev,
-					       unsigned long *devfns)
-{
-	struct pci_dev *tmp = NULL;
-	struct iommu_group *group;
-
-	if (test_and_set_bit(pdev->devfn & 0xff, devfns))
-		return NULL;
-
-	group = iommu_group_get(&pdev->dev);
-	if (group)
-		return group;
-
-	for_each_pci_dev(tmp) {
-		if (tmp == pdev || tmp->bus != pdev->bus)
-			continue;
-
-		/* We alias them or they alias us */
-		if (pci_devs_are_dma_aliases(pdev, tmp)) {
-			group = get_pci_alias_group(tmp, devfns);
-			if (group) {
-				pci_dev_put(tmp);
-				return group;
-			}
-
-			group = get_pci_function_alias_group(tmp, devfns);
-			if (group) {
-				pci_dev_put(tmp);
-				return group;
-			}
-		}
-	}
-
-	return NULL;
-}
-
 /*
  * Generic device_group call-back function. It just allocates one
  * iommu-group per device.
@@ -1534,40 +1455,88 @@ static struct iommu_group *pci_group_alloc_non_isolated(void)
 	return group;
 }
 
+/*
+ * Ignoring quirks, all functions in the MFD need to be isolated from each other
+ * and get their own groups, otherwise the whole MFD will share a group. Any
+ * function that lacks explicit ACS isolation is assumed to be able to P2P
+ * access any other function in the MFD.
+ */
+static bool pci_mfds_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
+{
+	/* Are deva/devb functions in the same MFD? */
+	if (PCI_SLOT(deva->devfn) != PCI_SLOT(devb->devfn))
+		return false;
+	/* Don't understand what is happening, be conservative */
+	if (deva->multifunction != devb->multifunction)
+		return true;
+	if (!deva->multifunction)
+		return false;
+
+	/* Quirks can inhibit single MFD functions from combining into groups */
+	if (pci_mfd_isolated(deva) || pci_mfd_isolated(devb))
+		return false;
+
+	/* Can they reach each other's MMIO through P2P? */
+	return !pci_acs_enabled(deva, PCI_ACS_ISOLATED) ||
+	       !pci_acs_enabled(devb, PCI_ACS_ISOLATED);
+}
+
+static bool pci_devs_are_same_group(struct pci_dev *deva, struct pci_dev *devb)
+{
+	/*
+	 * This is allowed to return cycles: a,b -> b,c -> c,a can be aliases.
+	 */
+	if (pci_devs_are_dma_aliases(deva, devb))
+		return true;
+
+	return pci_mfds_are_same_group(deva, devb);
+}
+
 static struct iommu_group *pci_get_alias_group(struct pci_dev *pdev)
 {
-	struct iommu_group *group;
-	DECLARE_BITMAP(devfns, 256) = {};
+	struct pci_reachable_set devfns;
+	const unsigned int NR_DEVFNS = sizeof(devfns.devfns) * BITS_PER_BYTE;
+	unsigned int devfn;
 
 	/*
-	 * Look for existing groups on device aliases.  If we alias another
-	 * device or another device aliases us, use the same group.
+	 * Look for existing groups on device aliases and multi-function ACS. If
+	 * we alias another device or another device aliases us, use the same
+	 * group.
+	 *
+	 * pci_reachable_set() should return the same bitmap if called for any
+	 * device in the set and we want all devices in the set to have the same
+	 * group.
 	 */
-	group = get_pci_alias_group(pdev, devfns);
-	if (group)
-		return group;
+	pci_reachable_set(pdev, &devfns, pci_devs_are_same_group);
+	/* start is known to have iommu_group_get() == NULL */
+	__clear_bit(pdev->devfn, devfns.devfns);
 
 	/*
-	 * Look for existing groups on non-isolated functions on the same
-	 * slot and aliases of those funcions, if any.  No need to clear
-	 * the search bitmap, the tested devfns are still valid.
-	 */
-	group = get_pci_function_alias_group(pdev, devfns);
-	if (group)
-		return group;
-
-	/*
-	 * When MFD's are included in the set due to ACS we assume that if ACS
-	 * permits an internal loopback between functions it also permits the
-	 * loopback to go downstream if a function is a bridge.
+	 * When MFD functions are included in the set due to ACS we assume that
+	 * if ACS permits an internal loopback between functions it also permits
+	 * the loopback to go downstream if any function is a bridge.
 	 *
 	 * It is less clear what aliases mean when applied to a bridge. For now
 	 * be conservative and also propagate the group downstream.
 	 */
-	__clear_bit(pdev->devfn & 0xFF, devfns);
-	if (!bitmap_empty(devfns, sizeof(devfns) * BITS_PER_BYTE))
-		return pci_group_alloc_non_isolated();
-	return NULL;
+	if (bitmap_empty(devfns.devfns, NR_DEVFNS))
+		return NULL;
+
+	for_each_set_bit(devfn, devfns.devfns, NR_DEVFNS) {
+		struct iommu_group *group;
+		struct pci_dev *pdev_slot;
+
+		pdev_slot = pci_get_slot(pdev->bus, devfn);
+		group = iommu_group_get(&pdev_slot->dev);
+		pci_dev_put(pdev_slot);
+		if (group) {
+			if (WARN_ON(!(group->bus_data &
+				      BUS_DATA_PCI_NON_ISOLATED)))
+				group->bus_data |= BUS_DATA_PCI_NON_ISOLATED;
+			return group;
+		}
+	}
+	return pci_group_alloc_non_isolated();
 }
 
 static struct iommu_group *pci_hierarchy_group(struct pci_dev *pdev)
-- 
2.43.0


