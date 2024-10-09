Return-Path: <kvm+bounces-28278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1224997171
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 18:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB9462839D3
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 16:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BD5D1E1C3F;
	Wed,  9 Oct 2024 16:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V7q5zjFb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FDF1E1C28;
	Wed,  9 Oct 2024 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491011; cv=fail; b=HkgrATgsdneib3OUWEKmxe4L0AN48DWDhGGNRsXVFiFaPlW5jIacbEoGncPbZ6Z2fCDZQLlQIRucUuxp0J6bMHZFOKSZ4DBCiQNLo9HCrt1rGNCkA1MFqisgu5mIOnplE+5QZ2LAhck9736H85i3Fnu+SpKlX1MW3f+VhzXsGFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491011; c=relaxed/simple;
	bh=3jz28YyyQd5/ZNYYRfBnqweVwyJc7nPA4paLF//1img=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=QUuGJ5csbxHdbC938/E+qpxYuxQjqBoHXB3vteufq3UZub4eLEeJfmLv43rrv4xEwpQjXLkvJS9JpCbtFjB4m1yhjmsl4h4vk3VZocysOqn89uM9bT+9ffPanV9lccp7bx74l5dqiguh/PF/62eNhpsMQpk8A5BEQXk5NbJOnPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V7q5zjFb; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tUgyw9ez9jxQLw1qCjF6J0riesHhE6lIWJBczDDALm+GPMRzOWG9VJhWGksuLL8pgVPRenEqiyXUwcxGLOO3tyxfMKX/orZst/47gTLyg6Eqo7e3phHJSFLCTJlxWXatb0D/gqDRPG/O+1FwlW8o1MBd6uciZYhjZKdIlGlnYldg5gjq7p6XoyaWs1ay5WVB2y4ISt3ZXAhhyhThycydmp1PgiSNh4VQUDzDVMzb5ODfGr2acCig2uA3Tzt4nsAQ6vIHPY9nv4SjwaTDeM5jtwoOXWVPoWoyGjxGe5rS4hoUWcTOuHqppsu92h7k8Y1lT47A58mgvJSjx+n3+ppqrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xk2CXhGIdXZFhQVmG8kPggpJMFApNLdJjQxcql3PWp4=;
 b=sDDoeKVK89gQZWauHCmaAXVR30RR67sa+2ZjwBhd0dfQmJWnlP6Mwh1+ccWlh14oSnYC+qLPB0djvJOet3rXjvf98S+W25B9BdF9ZSHLePtL05T7ayPlqZEpiMIimkzmdn3hvF7R2XHIJElSknYIqFL96ydp9heE9Be03bWHLUq73nDaoj9Mjf3PDCUOdn4Z/VqdNy38JLhYADGBwTJsiawEJD5XD324Md+2zLrPxe6VnIiKEW6ulBvdRVhvT2yJgHD4Um8VlLPww1hMfpA0B/NW7HiQayV/ubBtf3DUaPMI9A6zT2oiJCbVO8r+zaKxBp+0jfaC0fQpppxCAkZbJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xk2CXhGIdXZFhQVmG8kPggpJMFApNLdJjQxcql3PWp4=;
 b=V7q5zjFbZUaXQoVgoc9QT5NoAEgthwlLBy7wL0oDzfyyIWP9/2CcZXCfoq4O8F3QOgBmodg/kMajALKCUvxrydAVr3bPWFn3U91CXZdz8Z1UiLV66dr833qmzJcpYOzQC99k0FR6mF2sM+W1Ic3mowR1XkNB9ZzOVMKfoH34NdwvdDpNCa/NKAAOnwlSd0VwQiOMiHdS6i1NzwfhIEiI7aAlV2COdDIoUDNUy+c7qH6zwr4xj7FvjJa9UoSZ0id6nwGUqRhr/ikosUL0ceVlu+0plNF5zjMwP2coNEc7CO62ESyS4LM4ANeDd+qwMN2l+5cJIF7GJ5GY/OUW4Xu8EA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ1PR12MB6073.namprd12.prod.outlook.com (2603:10b6:a03:488::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 16:23:18 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 16:23:18 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
	Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 0/9] Initial support for SMMUv3 nested translation
Date: Wed,  9 Oct 2024 13:23:06 -0300
Message-ID: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0124.namprd04.prod.outlook.com
 (2603:10b6:408:ed::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ1PR12MB6073:EE_
X-MS-Office365-Filtering-Correlation-Id: 7072227b-4d2c-4324-dfb1-08dce87eae5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0dFB5z+SqtzPj5y0MZ+uFz797hgnkjYiOmi+Ypke31bXBslqR1gY/D6YLAgS?=
 =?us-ascii?Q?TSkTm9XmrQS+h5Y0edU/WmXgQlTuN90+mA5BxaJTZ5AxEMQe8g4J9ltelvzc?=
 =?us-ascii?Q?QyeVqUWkx7fLD4CwQj8oZKtxpRCmeWFJ/bzF6TV0pgSzVTKMIfsbndE8kC2s?=
 =?us-ascii?Q?SIzDR3kaUgzr1xcUOOs/FoZuIKZQ8htu6+c6D2O2/7lhZ67VxO7yYenuxCye?=
 =?us-ascii?Q?NUS/vud0y+IbLgkfpgGEAw76PxNU9v/YewL83VRUpjSAuBjkRQwHWRxJJLOX?=
 =?us-ascii?Q?0fsuc+FVYFEoWzVoPCcirT5uPycnye410yREVmSA6UG1K6tYwyug+uGsSSGW?=
 =?us-ascii?Q?3FJGz1+cWDAVX9HVhXjy1B4DiZiVdC62N1/W/si0tFI6SRuogHWfR8uzLLwO?=
 =?us-ascii?Q?UdPJJA4rfnbp6ZekpcTQlje5RzA8qMaILrvY66NtkM5Nu68JOqXfEiJA7L9P?=
 =?us-ascii?Q?pt1ggSgley7RK6gdWk6+dfaYp2SWPAYDLiUv1vFKzn0LuED/8pA832IGLE0E?=
 =?us-ascii?Q?b91lr2PvP6v55Kk9JM2EDK7XgEWvzCF39wXuIfcxQNX0LoMWzUu2VuE0R13q?=
 =?us-ascii?Q?ETFSdR4/EdQpZSlmAfG3NgBSuLu2bV9TbkYGhFChJL8WWQNIbCg30BurQdM0?=
 =?us-ascii?Q?3ENIvV/EXHgNeU1Se5Eod97D3vvu/W4qkjeLPPt8PKFScLf7lokqcXG1JR8y?=
 =?us-ascii?Q?N7su+kJ9h6lxmmpKNpjHwbxJsyxXui2GhqrFdQSp51o8bL4DIc3tUM/d7qel?=
 =?us-ascii?Q?U4pXhE8OamiwiV40oSWJHNc5TavtG+e0MGpUwGdfRU26G4grCaZ8ZGgrnvzw?=
 =?us-ascii?Q?EB1N1PJgsazIOPkgeY3R8+YYOdwMQRvUQnJz77IToTjS6lY6x8Elc3xnNuCi?=
 =?us-ascii?Q?XKITfVfYE8BCJCq7JjmQ9275kHctq0SYoxaG7Z0t5RvSO8ZSjm0WgbBZIjB2?=
 =?us-ascii?Q?RsHE2Afxh/d4QulchzaUkTD32obW2pkoS5BUljYNNqeW5PIPxLaW0i4mmAES?=
 =?us-ascii?Q?201rO0QLAst3z6j/QZiGgee05GI1Lsb4AMMndrT3Ckgbb78Q4FNoynVSGh2B?=
 =?us-ascii?Q?tclpDX8Dwgyp3w3lYmz2dSO0oFYiAjHp8dfPwPGMl4IWnBUrKLHtx7Mjk+u0?=
 =?us-ascii?Q?w1/I2OJaws41dWRXNj9l5BY3WU+6zO4xLNuBsIjBA28qW5L6eAifXAImACof?=
 =?us-ascii?Q?qGuyi0XxzAjAl2xFmAfHScX1ziOuVW6+X8JYwfex5LtMarwPXQ40LU5GCR+n?=
 =?us-ascii?Q?FWJynuR1v5gNLi75qfXSOp6lD46rEvPgyY/6G6C2lmLgOp4FV4GD7EiJXQmS?=
 =?us-ascii?Q?wN1fqNHLVfR8M9ZoEZbRpg5G?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A/m0h+qcDS9pbCt8kdH2xcrVU9SWyNRlKfDgEun1sITGwRaBZMqXcgiM+IRI?=
 =?us-ascii?Q?584snE3wf0oZShmXBKYe0ZtTJ5eVTpXqJdUWMZE+swxrrHUWJGmfd4QG/JJM?=
 =?us-ascii?Q?FWEESP0Od6jDb6VRY0H09Oou2ZYIGulBx8t0gYOuXW1JYA1iT3qGCfZGMInY?=
 =?us-ascii?Q?raOIqyQdIchydgrYyc4TOl8PjgRia9NOxS2zrQtqqDTq0FHlq+Xyc7rVwTM3?=
 =?us-ascii?Q?Zh16hzFKXcPkqfj3aywzvDgy0wyeCIb4cq03AWZkxmMWfIxOnHiDm9vfyRlB?=
 =?us-ascii?Q?VY5J43wzrp03HJjepaPZ5rtlTiuD/gLtKAcof4cr/AWgUkps30kYfmqe8Qap?=
 =?us-ascii?Q?PJtarl/+OlFMgozdUGoyTyzQBXDEQDZLnFi66/K92S3XuAfEp+u9CzrNd47W?=
 =?us-ascii?Q?0AbnMlvWro+4ke/WMemF8KGRCijEVktJ2kMsqSNELLeaIEiicE0y+3HlFUmM?=
 =?us-ascii?Q?layC5zoiP25DoM1JLtpxfBt4PTqN2aT5qoAO7Nr7IJFC2uDQDsq12AUsJD11?=
 =?us-ascii?Q?9yf43D+KfsQoF9906vmC4Hj29C/z04ffDfyENdc7tkcWe+0OhW0SRY8RM+/V?=
 =?us-ascii?Q?Ch5BqUTUXiJfVB0maFBHInsbHkT2pno3oWG1/DvOq1FRtPRCZva5h+Mqdgsc?=
 =?us-ascii?Q?Bjf9NblrVpM8Gcwl77HZviewoGsoPfZ+ExJneeJSc+zkruO32XE+kZQnDAJq?=
 =?us-ascii?Q?PnYVJgVqUArbuzK8IcpvPBk/0oa44B6gDOee2Qp7DuBiAKrVGPi3Cng8SlI/?=
 =?us-ascii?Q?SXLNHnrvxAAuS9t/wMqhZpk1QEUmW94N8L56IeWko+6wvp6Aeo3rBm5IdMGs?=
 =?us-ascii?Q?frH4OANdtse3Le9R31wKKFB/UNbsxA3em35VpLea0XLK546HFnWWakXlvpCG?=
 =?us-ascii?Q?TVBYGyEXRcf0xLJL+TSxWDXrxeWdCv0C5SjQ/twLcNcsdxVdDvsqLtIPvYn9?=
 =?us-ascii?Q?G5eDqQdFATa59v3Q/8KDbEiSv3/O6Yvna6qpm4Sip+m5VjnEGcqW0icTmdxz?=
 =?us-ascii?Q?z+rwOWZLlMXMxJrJoKFBdt883vYX08sSIm/gSbhc7rKpkkKOezU0ZHTKGBk6?=
 =?us-ascii?Q?MptnKlDs7FKRFlwbCnBEkcxcZARF6C9+u+R35oVLRj3BVn+BFPdpfjzCCpVw?=
 =?us-ascii?Q?gIh+KJimR/pEHoKtKofIxRqdjAKtPcDvdq54R3c+V0uDAXeSZlqR9spGCLb0?=
 =?us-ascii?Q?v97JXgpJeHEf5zQ9muGfeWXcQOv8iXU+VoS6bKVPxSVmWI5HSlhqIWfPhhVK?=
 =?us-ascii?Q?fNRxsk9Ew2XxN4elPSOWR+5suTEHKPyi6fQXVk/aJp8Xj1U3qdA+YNtKH13j?=
 =?us-ascii?Q?dVjU9+5rxo45xu1uc2aZFEoX5S8aNiybUqHRWTHgwBrtfNbTSFr2PdWrCniX?=
 =?us-ascii?Q?eYON/r9AIlrH3R2ex+nJaHlE9JjUaDralRHlcWMySKbThtR57D3ak0p/FRM6?=
 =?us-ascii?Q?p0BG3AJCcq7PHUkKudGqUAWoJkL8CWivT0jYOwToCK90dwOjbXqOvxOe9ngY?=
 =?us-ascii?Q?+pU9vNf7J17LQ8emlAL1TI+ubATj3vyq18jsTOE+OB0Sr65p/S6xg/dgvBw/?=
 =?us-ascii?Q?LQwJvtfW+psehOMT2SA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7072227b-4d2c-4324-dfb1-08dce87eae5d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:23:16.9766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TLGTBpL+r3mzeH7BFltOmRbgp/RgNekWKzKXa+0QSyCx1mydxOdtlb78n1DNTihJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6073

This brings support for the IOMMFD ioctls:

 - IOMMU_GET_HW_INFO
 - IOMMU_HWPT_ALLOC_NEST_PARENT
 - IOMMU_DOMAIN_NESTED
 - ops->enforce_cache_coherency()

This is quite straightforward as the nested STE can just be built in the
special NESTED domain op and fed through the generic update machinery.

The design allows the user provided STE fragment to control several
aspects of the translation, including putting the STE into a "virtual
bypass" or a aborting state. This duplicates functionality available by
other means, but it allows trivially preserving the VMID in the STE as we
eventually move towards the vIOMMU owning the VMID.

Nesting support requires the system to either support S2FWB or the
stronger CANWBS ACPI flag. This is to ensure the VM cannot bypass the
cache and view incoherent data, currently VFIO lacks any cache flushing
that would make this safe.

Yan has a series to add some of the needed infrastructure for VFIO cache
flushing here:

 https://lore.kernel.org/linux-iommu/20240507061802.20184-1-yan.y.zhao@intel.com/

Which may someday allow relaxing this further.

Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
this.

This is the first series in what will be several to complete nesting
support. At least:
 - IOMMU_RESV_SW_MSI related fixups
    https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
 - vIOMMU object support to allow ATS and CD invalidations
    https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
 - vCMDQ hypervisor support for direct invalidation queue assignment
    https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
 - KVM pinned VMID using vIOMMU for vBTM
    https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
 - Cross instance S2 sharing
 - Virtual Machine Structure using vIOMMU (for vMPAM?)
 - Fault forwarding support through IOMMUFD's fault fd for vSVA

The vIOMMU series is essential to allow the invalidations to be processed
for the CD as well.

It is enough to allow qemu work to progress.

This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting

v3:
 - Rebase on v6.12-rc2
 - Revise commit messages
 - Consolidate CANWB checks into arm_smmu_master_canwbs()
 - Add CONFIG_ARM_SMMU_V3_IOMMUFD to compile out iommufd only features
   like nesting
 - Shift code into arm-smmu-v3-iommufd.c
 - Add missed IS_ERR check
 - Add S2FWB to arm_smmu_get_ste_used()
 - Fixup quirks checks
 - Drop ARM_SMMU_FEAT_COHERENCY checks for S2FWB
 - Limit S2FWB to S2 Nesting Parent domains "just in case"
v2: https://patch.msgid.link/r/0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com
 - Revise commit messages
 - Guard S2FWB support with ARM_SMMU_FEAT_COHERENCY, since it doesn't make
   sense to use S2FWB to enforce coherency on inherently non-coherent hardware.
 - Add missing IO_PGTABLE_QUIRK_ARM_S2FWB validation
 - Include formal ACPIA commit for IORT built using
   generate/linux/gen-patch.sh
 - Use FEAT_NESTING to block creating a NESTING_PARENT
 - Use an abort STE instead of non-valid if the user requests a non-valid
   vSTE
 - Consistently use 'nest_parent' for naming variables
 - Use the right domain for arm_smmu_remove_master_domain() when it
   removes the master
 - Join bitfields together
 - Drop arm_smmu_cache_invalidate_user patch, invalidation will
   exclusively go via viommu
v1: https://patch.msgid.link/r/0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com

Jason Gunthorpe (6):
  vfio: Remove VFIO_TYPE1_NESTING_IOMMU
  iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
  iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
  iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
  iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
  iommu/arm-smmu-v3: Use S2FWB for NESTED domains

Nicolin Chen (3):
  ACPICA: IORT: Update for revision E.f
  ACPI/IORT: Support CANWBS memory access flag
  iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct
    arm_smmu_hw_info

 drivers/acpi/arm64/iort.c                     |  13 ++
 drivers/iommu/Kconfig                         |   9 +
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 204 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 114 ++++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  83 ++++++-
 drivers/iommu/arm/arm-smmu/arm-smmu.c         |  16 --
 drivers/iommu/io-pgtable-arm.c                |  27 ++-
 drivers/iommu/iommu.c                         |  10 -
 drivers/iommu/iommufd/vfio_compat.c           |   7 +-
 drivers/vfio/vfio_iommu_type1.c               |  12 +-
 include/acpi/actbl2.h                         |   3 +-
 include/linux/io-pgtable.h                    |   2 +
 include/linux/iommu.h                         |   5 +-
 include/uapi/linux/iommufd.h                  |  55 +++++
 include/uapi/linux/vfio.h                     |   2 +-
 16 files changed, 465 insertions(+), 98 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c


base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
-- 
2.46.2


