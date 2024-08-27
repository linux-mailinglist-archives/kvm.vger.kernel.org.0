Return-Path: <kvm+bounces-25175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F097E961347
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 17:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32965B228C3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 15:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFF4B1C9EC9;
	Tue, 27 Aug 2024 15:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cqRlHPLh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7941C57B1;
	Tue, 27 Aug 2024 15:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724773908; cv=fail; b=Ad7Ibi2wBLlGHtkRCmx6+84aw9CGFNrGE8QQDEhe4RxSNnTFrseNetG0vS0ta2lrzGjp/LuvkdVdoGyhhuvippRbjQ8QGR+03LLYOD17K42jBCZqVheahqgQcYwNUhhBCMuNlupyQkPE1qxIhF4//HsgGIBnThOimN1axYDv5aE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724773908; c=relaxed/simple;
	bh=VTMcU0I+GQN0xFA97AQLmdsCWhAf2s3R0o/nRbvKEGY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oneUUSVwSbfpK4WjZaJMlxb/umw0Xz1fPeXVFh75ZsoKca9uChfDzDgdu6wm1B5fZ1MQw+HCy7A4q7IgT7gL8SXswzSvKRjXgF0GRJUV7jwaOmMFZ2LovsbKc7aVvQ5YEA/rjNAaZd1LwuuWddiSGycyXKZ3vOQwGAINoNoVggQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cqRlHPLh; arc=fail smtp.client-ip=40.107.93.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Li/uyxnU1yK0Zj3Svqoz5kQfwKGCp1w3kwYx7VYtfYY45oivNf+dAJss/g+jTEtkY4U8t8Hvb3ctiaQAJ082FFrwfY5qrYYGXaoEmYdP0+mSQsfg1GSlQRj0FyGVSZvaATaIDIRfzKS8OKqs+LTRxQrRy6VBBwxx22DdKl3M0NNeTTDisrxZpT/rYB3iXisvg+AY7wjx0MOweF3zUXSX0lWwUn582QER3nSX0whrBHhnfLB133/Ob+1k4YWxRC7kDsq3iSkRO9YaeOulmt+WQWw/kI+mFOoLf++wzbxyDv3drM2TtAfqLVnXxN1ZWUGAZ86EOgCCiu2cl7cVhTyYBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KQpV8aDQloMocqCLA6RADpQ+qQnvHzCvMYs6oKJUt8=;
 b=eBn2QQI+TSfzfvPP7I/0ISB+GpjtLoKas6o/CBJ0x6QoYTejL5mFBHVKOqTWP/s6ZSvFSxJ9FJ3MZ57R/tRp01rW6jjJQK+nSqJrekzEw8+DPmjj1oNMK4WBGYJGl5DwgBTAfXqEx3w8/14BJOwKxrZxUXhvnWkdi99RIIVLMCtChPXECUqD8zDpIBciwLeNFl1Xo7b/J92HSqn6CmjefjY0y+dM5nKREntXJ5ytf9Tyu9uhtw6PRGo+7APinvH0b3bG9enaSINWdoRWgS6U9SX+/0Swu8h1DkHsOCwhk9hQKGMvRPjmP86XX6T3g7/D6c0x9CUN0hUDzgb/Bx7+Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KQpV8aDQloMocqCLA6RADpQ+qQnvHzCvMYs6oKJUt8=;
 b=cqRlHPLhNO9SiS3YJ8qKN9tFdWS2JywXioJo7oalimTikXPgTEv6SkxvgeraLi1AfvUftJtHGaNMg/87rD+B8F8/z18ETB5v7vQXP0hWQVYN9wxUZ6UPXcelejCViRnXDdEn4VhB7A/T+DVSjuAbQaSMHSzNwq41uetmXgCvC++H8UfBKTh+2EjaUjy1EyOtp4PYiiO/KitvQFuWfTsBAjVgbY/kQ8s9CyDzH8nQrdwz6gTjEoILVPZ7E51qKNiSpcLOHwrqHIuxDeF08GThhqrk+DO0EsvRBroqw5RjxDI5qT8LOyVIVlShk/bcsBHueopbI9dWDFV7+MV4ucrkfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6790.namprd12.prod.outlook.com (2603:10b6:806:269::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Tue, 27 Aug
 2024 15:51:40 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 15:51:40 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 0/8] Initial support for SMMUv3 nested translation
Date: Tue, 27 Aug 2024 12:51:30 -0300
Message-ID: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0102.namprd03.prod.outlook.com
 (2603:10b6:408:fd::17) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6790:EE_
X-MS-Office365-Filtering-Correlation-Id: c02b689d-af14-466b-06e3-08dcc6b023d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FX6sVmjBzhx7LVCDmr0n4KiwcOVwxH834phPOAKluPfPsmrkVsAYxapRrSnw?=
 =?us-ascii?Q?6Udbt3CHSAiRbCArZMqEWffFF4Om88GJaFLRMFoHgXVTFHFqnhJBHfW0xqDP?=
 =?us-ascii?Q?jNn11hPhZgXkRP/fguajPP52BP3d7mmVDvmH/brusn4uebmZMuIG69X25rH/?=
 =?us-ascii?Q?nXCQQVhiDxB4dMr3Z6HiPDEmpjANdrTDQgoJcn6PD4fE8Oc3s7cGI/U0TEt8?=
 =?us-ascii?Q?vRRd2xh0RlLm9YRaq0p+E5UHdxNAmUl2FBcut9aP2ABTD3omxrijNSO2VUte?=
 =?us-ascii?Q?eU32ebLtNUJ2KzEs8NtsOExWKnufnul7o3r7xT9Tglg6PBhbpsPKpgnhDOKn?=
 =?us-ascii?Q?MCArLNB0l0NEmG0jHSfYHcdedlVizH+dmv7fVK6UIbfgz/QDTpqy1g+fUgAa?=
 =?us-ascii?Q?DB8DtylVM9knxCpHmzLv8fXYpBEyth9FFpQ30AtXn2r0m/q62H88C/XSbmVr?=
 =?us-ascii?Q?IeqLUhlE5ib3Q+rb4u0N3XJnmWNbBoTh7UU87n7NrrKk75mT+raIldvv4U1m?=
 =?us-ascii?Q?DtIcYzHVuZ/K+uvTv/9Vs7ZO0l2nDnWGF1U10uoZlQrS1DOf3f+9L/t7h0pn?=
 =?us-ascii?Q?0ks6bg51H/HHnZc8S7Kzpw8X/7MU4LvToQK/vaTLg5DHi5sEs7PZRe9HJsXX?=
 =?us-ascii?Q?ZQwi2fIg7a2FX5bIqBjt22obLoKb+bI98TQUkfuxYoLfvMIzPj8I4Sed7RpG?=
 =?us-ascii?Q?17bme2IQ9lHm+BwDi7o0Y+Yw/mevDXowQU7AF+KrPCLZAMvqMgyE/93sBszq?=
 =?us-ascii?Q?s8XzFvzfAtTx10XoIbd9HW5rXjMwxYB0XWG4Bujnse2dpDQB1754NeY2XbJh?=
 =?us-ascii?Q?jPhhVqVdCeDHLpmnI6+204n0G5/7ADoIw5D4ngvlsAiyLhb42nqWfWVSwlBO?=
 =?us-ascii?Q?3ZXBHRxpVHedscg7oFV+/LgB5pbNC3h1uRtkPbSnSk7NAwC4AjZ/adOPZYH2?=
 =?us-ascii?Q?GRBlTgEoLKSXq9SfdQWeHWTBVTVXUFUMGUJnuDMsx/MZLxqQJxyyRJRxWDj5?=
 =?us-ascii?Q?DFVSUSs48TkwMYh6oOWWL8q0sV4qusHxjfmtc+ehPbdZG56uQYPwzn2xcGrK?=
 =?us-ascii?Q?3+KQ4CMRJZnmG9VFaYQZcFSfOeKN1hGOSerOkpdsYDb/dzp5BWicRJa4K89g?=
 =?us-ascii?Q?lD6Y4qUFgF2271puNxFQ2Cw5GeR3UDYlL1yaP8rVx3LUPkZhmBB1uqYCEMgd?=
 =?us-ascii?Q?+gCFLQYe1IiX6Hs2aVwr0d6HepOuqcENxvQLyb/mpinHkI5FdxxxwChBS8CH?=
 =?us-ascii?Q?Sb0QJQLGLZUJJFH/J9JOj9TCdjPqFT751aiT27x8fxwNdLQJoErrAAcXvPVz?=
 =?us-ascii?Q?AC+MKgfp905C7eaI4uM0eudpOhlqjh4rvjpDa4ETVA8j9LTIofUBeN5ujrtJ?=
 =?us-ascii?Q?pUpytkLaC01PW4QuIB1Hyv6KNacipxzqDi6rTNVStALeUTnIVA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3kzCaILV4n1RiaUUzMDw2QvTLnvDtBJWbYQUwyFL7gNcL0M9ZrWDA8KH+TXs?=
 =?us-ascii?Q?vyi+EXLny8YourasqSdDuQGElsG9ts2V4Dn3Nc1VATk8MdGB/QTjW9fndNgY?=
 =?us-ascii?Q?m2mp/WZWYOfaaQ9nswmYn11Aqhi9tv1k/5yrnm9o+WsxkWw+jqqBfZCdCVis?=
 =?us-ascii?Q?6klPvEKqme6opW0kY9iGs3SxxmUtlVdGPYKNoBepnVnfeUf7+UT5PYhkR57+?=
 =?us-ascii?Q?s7dSAy2gPQMpJcRsrj/9IRzWxRp7K4Wdk6i2vNPOK2+Oeu28FmiUY1OhIDrJ?=
 =?us-ascii?Q?6j9k+0Gpi/OIer0sgzRlKcb2l6XtyriO05MLP9ddzOt70KgrWbmdRKufs14c?=
 =?us-ascii?Q?slyzTc1ok+iRZnbzX4ScXwLz2RyokDRzo7cDwod6NV1sMg5SdsBJ6bLHOA49?=
 =?us-ascii?Q?AruGKiPzXB5wN1PjOVmOry38Y+qiiSIU21s4cPHs5onzIn2ANg8XapIIvlqV?=
 =?us-ascii?Q?nylmTWbpvHA5MrXAHyv+h0+cq1hR2pLsSpR+cp+5XIK8rCve1NcDH5AJWht9?=
 =?us-ascii?Q?TgAa+NqXes5GeLtYaWFdTIo73388vYjUSZPaohmlWXXUP4X7nDj+ZnJZpVie?=
 =?us-ascii?Q?//RWba5SXknHDr5quhTs7AiyyWep9hjjbrakfbPZdOlH79ZxCfAC6NFTIXjc?=
 =?us-ascii?Q?S7hy4TI+ns1SKGWyOn403OGFVgea1RtxKF3WXHeZeNWAxMqFGjtiFn8WQDAJ?=
 =?us-ascii?Q?88qrSJPO2nSJEQKVOT34BHgQBcNpYnMqJ1XZq+JhKWR39yT+jMBrbHK0c22E?=
 =?us-ascii?Q?UGbxmhbMxZLdsJ0RE3hVfRJ3zt7sun+9O1BySciN4QEJbJlUE/Z57cjWq6yl?=
 =?us-ascii?Q?bQ5ruSvqPpizrKmEA3avrcKvJp/SnNxAFZ0U0QspAB+H4WDyZXjquLDnJs6c?=
 =?us-ascii?Q?E3LBp/aq4+DEco7JPg9O1qdSPGrAh13NqbJIUQm2S2D4csHectkSPE2e9o/3?=
 =?us-ascii?Q?9HNkF+ADamejrVUz+8AGK/tXsd302qtZCYDEUWbDorraOjAQalbOzwEzf147?=
 =?us-ascii?Q?M+OUQ0HZIMROlvBobh4c05iJ0mfX3wo7BxodFSaA2QPRC/7DczcTHddslItE?=
 =?us-ascii?Q?Z8igJW6gABA6tBsVme1QEdEC23pM5nB6eH36lcmlSfUE0xwKbux2b4d+6Bcy?=
 =?us-ascii?Q?KcMn2rI+1mjieAM01iAn0elUa9VCkMbx2jtr4qOe6p5uDyrRg1T4pTpmy1j7?=
 =?us-ascii?Q?UM7/LKrMnNrVTeawtZnRnBmyscOWJj5HXCYPMf+oiVU5/gf30QXL2Tmvn2KX?=
 =?us-ascii?Q?UYfLwKURfJ7jM/DjN/sxxUhqPCimrTgODvT1tu5CYav8EseDFQ2LpJ6X+Su0?=
 =?us-ascii?Q?ZJ9RMiF86TM6uFX+/gWTf+rpxn0USxU0kiV7gjHA4FPWbKeyHX8FwaEhnXqL?=
 =?us-ascii?Q?/+/TB71iYd8wEh53ssdwDZ19ShOTcuI/pzsDr7ZBmFYw3ROOviA1fgsEsU0y?=
 =?us-ascii?Q?J9MuqHsrwu1msvJt3qTxpjytLSVQjNqczKMROFsMcCzYYOd+oR67LZfyqXC0?=
 =?us-ascii?Q?PKPsbXqrWxcEPDI6xUAhzCdwe1lTpdTZ7HJQWpsYTPd9eMaVPGP40nslAkgx?=
 =?us-ascii?Q?EvmPAObFdDY+jwamtg94LH2b6CyywcslwUnDuFMz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c02b689d-af14-466b-06e3-08dcc6b023d3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 15:51:39.8947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xWdb+anNvHrookFk2eDNx5S0KfW2Z7Rg5xYcDrkgSlIBuEjvqpPNY7W08cTIyav
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6790

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
eventually move towards the VIOMMU owning the VMID.

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
 - VIOMMU object support to allow ATS and CD invalidations
    https://lore.kernel.org/linux-iommu/cover.1723061377.git.nicolinc@nvidia.com/
 - vCMDQ hypervisor support for direct invalidation queue assignment
    https://lore.kernel.org/linux-iommu/cover.1712978212.git.nicolinc@nvidia.com/
 - KVM pinned VMID using VIOMMU for vBTM
    https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
 - Cross instance S2 sharing
 - Virtual Machine Structure using VIOMMU (for vMPAM?)
 - Fault forwarding support through IOMMUFD's fault fd for vSVA

The VIOMMU series is essential to allow the invalidations to be processed
for the CD as well.

It is enough to allow qemu work to progress.

This is on github: https://github.com/jgunthorpe/linux/commits/smmuv3_nesting

v2:
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

Jason Gunthorpe (5):
  vfio: Remove VFIO_TYPE1_NESTING_IOMMU
  iommu/arm-smmu-v3: Use S2FWB when available
  iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
  iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
  iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED

Nicolin Chen (3):
  ACPICA: IORT: Update for revision E.f
  ACPI/IORT: Support CANWBS memory access flag
  iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct
    arm_smmu_hw_info

 drivers/acpi/arm64/iort.c                   |  13 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 314 ++++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  26 ++
 drivers/iommu/arm/arm-smmu/arm-smmu.c       |  16 -
 drivers/iommu/io-pgtable-arm.c              |  27 +-
 drivers/iommu/iommu.c                       |  10 -
 drivers/iommu/iommufd/vfio_compat.c         |   7 +-
 drivers/vfio/vfio_iommu_type1.c             |  12 +-
 include/acpi/actbl2.h                       |   3 +-
 include/linux/io-pgtable.h                  |   2 +
 include/linux/iommu.h                       |   5 +-
 include/uapi/linux/iommufd.h                |  55 ++++
 include/uapi/linux/vfio.h                   |   2 +-
 13 files changed, 415 insertions(+), 77 deletions(-)


base-commit: e5e288d94186b266b062b3e44c82c285dfe68712
-- 
2.46.0


