Return-Path: <kvm+bounces-30134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9D1E9B7115
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:22:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16BAD1C203E6
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A27D2FB;
	Thu, 31 Oct 2024 00:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="sWDqy9nC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2061.outbound.protection.outlook.com [40.107.101.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AA92CAB;
	Thu, 31 Oct 2024 00:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730334084; cv=fail; b=e6vTginKNgU2Q/CuguC3tqFv4ix7SX59fKV/CL7dIJyXbEmufxHI6H0TzzD6aX+rCkhe2e+ZzQOqybnBoY4Y1jPRerS1FnuM3nrK2l/rGRvTd3/snEzVrn1IuvcqUiaklOWI23a1dK7I8ZT5Iw6r84tdetVMyVcAx6ynqSZxNls=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730334084; c=relaxed/simple;
	bh=QaGbGujuFtZmv/hvO9UxLuNTh8UPuO58642dLxH+zpM=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=pi3P02KmDWMzp96jqscpW56/QdXr2iUPDmVtnXW1/n3yv4o4PZH4ZQvyZj1zskTGY4167KiA7G/yKAATvKiYDWiwaZAglpUMN9/6Os9RNI5TPaItIdnyOs2D8gXa1y3B3bmHjsyqsFG2ty0TBvqunpJ9KXYPB1U7snXEk3BzDGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=sWDqy9nC; arc=fail smtp.client-ip=40.107.101.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u8xt6hXIl2VQlpJSXPWYPKXRYOY1cs/RNFaLVezylBamCl5V7rZ1j9ND9rknDfpd8vP48JyFnCghuK4Mv5zabcWwTwq+9SuiSTT8orJvJ3p464l6C4HoVCvtBXGypg9N+9FCx4AkKtOpbjxOGfqB6LIdorkfQMODlhi/Z1A5SjYnAY6nxvihRRBAItAK4XMZ296wfPQskeJm1lUiqcs9pYNJLR7mWwEjcJePdtDirXQBNdJstOBdF3OqrzKP2fBPWA4wEwHlIqidMx7zwH8yrESQjcTAAk9BUmC2b8TatTKI9dcnL7TqWDTddxGjvBYlEh07m0Jjbq/4kkperyryBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApablPWdZRedlpNbUkrkPL4rex9wYFi3vjncKGpG+IA=;
 b=BaCwYCDoMdoU4VeK5kKEPYp26RRTR174AwdFZPS0SuqOsXq5ENVxTUzWZHYVxuBY0iPtqnb/PJTqcf3OCLUwH5ElnOLCEfd/4LPjcdXN/JpqJk9uXcyZaIQWwBTa03CJdg5Z1f249if1WpXgyaouGSB2l+9ZdBhzqDWDopbkTbbvuTuoMmElPEKwaY7U79P5QFztcNv2mrKE2EbpKSoPta9OVAqOdhJPEud10FfobgQcPuaLUd8vVyy/Xp6cqBB6Zp9FEveSEwhAwDJq05HEfVW5OQriYJppOkRkaJQkuIjs6YzTRyS6OYBnSRNFQIs7ep9QiHwaYQGfJ/65Al7NDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApablPWdZRedlpNbUkrkPL4rex9wYFi3vjncKGpG+IA=;
 b=sWDqy9nCMhkZRlGVI99ykwxJE+QXlaOokw8yIGaben83rhn6HVOpRpqFQVTIeKw3fDvpPPyWlV5yTk9WcDRzDAaWi381ZUICQqobfbXfzpmS9hkNvo6HqFM0IOW+hrX4kiRfuO55QhBZdnf+Jf5rMaNEChK3KS6F6vwh3jFBtW/F32NKNuDlXxQ7nt8TPEtRWOLYm2wPn1mnca4/buLiWFHql8oflQ1M1NMpPiCSHA6esGeC5HUsMrEN/fKHTke4UHzDdXyqnoVWL3Em+9PMSD2voPl4a4DFCBGGzJTq7SDZ+R5tK7D1NTEabTfG4SeuKnuPfdJacdN1G6ro+30ZLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7573.namprd12.prod.outlook.com (2603:10b6:8:10f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:21:01 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Thu, 31 Oct 2024
 00:21:01 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: acpica-devel@lists.linux.dev,
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
	Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Date: Wed, 30 Oct 2024 21:20:44 -0300
Message-ID: <0-v4-9e99b76f3518+3a8-smmuv3_nesting_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0069.namprd02.prod.outlook.com
 (2603:10b6:207:3d::46) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7573:EE_
X-MS-Office365-Filtering-Correlation-Id: 588937fa-3544-424c-024d-08dcf941e49c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nHilo8lClFrHwtyuuCx/cAd9JaxF0e2o4teiB5G9X8brS9JSFnowL21IV9F2?=
 =?us-ascii?Q?Evvq+xEUgbesxtybqKsNoSJl5VBJVnSaBLVT3Bal/s7TU1hddMcMTA1gEjHi?=
 =?us-ascii?Q?DbNwhrQqoSrAETuyNukt5DPgCd/bHczLESV7ziDptEjtTyOa/AjAJYjKT/Em?=
 =?us-ascii?Q?yoplGDkzsCfBPGcoCMawq2WSXj7LD6YlliFtqSI/fjp2W+01B4Pl0h82NRwe?=
 =?us-ascii?Q?mI3liTON2VTuM1PXG1J8V/49z40PQIX7omZqJJWOEEX3I+MPaH1ZfLthRpBn?=
 =?us-ascii?Q?R04RXZh+CU70eSlnB7vj7Fo9+ROzgviid8PD5ccRd6IT3uTzdqUsmxbN8bZE?=
 =?us-ascii?Q?wQM2zN2JAuwAFPbExsDQmjNQWqBuodGzaCuU/a2QFVBjIRKQ3/emaV2iiD8b?=
 =?us-ascii?Q?6cFadnXQCt9EZ0vEwcNuUL9EBLBPp9OHrQd2x/4lZtONS8imJfAS47h7JL3A?=
 =?us-ascii?Q?vEhuDueo2A41+XGlvx7IF33oKXv+YTFcOVouJH7tEtNeriCsLzjugKqeLJiQ?=
 =?us-ascii?Q?OjdXNmYIHRedVd7IWm9gb1Hji2rwyvLQvZx1N0WyQtQT33FpiGAC8gzFAnCt?=
 =?us-ascii?Q?CaB+2pNH3XArIOSYYarZjL6qQc0nqerfExDi31Sz/GgqQ9HKof660fWbGtHZ?=
 =?us-ascii?Q?FWKE7PTb3iVDwAMIU5NCH7IvAVqJAAvjnQEFvO9ny+YIRBdDw3sU/hyMConS?=
 =?us-ascii?Q?iXiX5xOtuChjNBbwjdj2FOza/HFftOayKjkzwuB1yo+pRGzjn4Z5up/5nrf6?=
 =?us-ascii?Q?1tdRzycA/2AnZjPJeEmMKOhFkHMGE77ZUqFhVlsT3RVgfNt18qsL5vviwOEt?=
 =?us-ascii?Q?OW3HpbTHrfr+IQ++YUg4kzb8+50rVvn0z9AE0vMlx8o88U4L/w2axf2H8wkW?=
 =?us-ascii?Q?V9WQkU2bhOY7S7P3N0/S7ZEddnNx9HCSn2iHwHKLFVAgVdOkyT2UYibxGysr?=
 =?us-ascii?Q?GOb2WSUli4i6AgKZrxDcRV2Vz+QC+dkqXOhdDZRn59LuxUywgJ6vbUH4sbw/?=
 =?us-ascii?Q?kxGP8ZJcGq6LUpaw8y0j3NpnF06uJ6g4ZAYHw9gMAZAPw8pbSZKyuw/nFf5G?=
 =?us-ascii?Q?kxmGZ6g0B+otHpssWV6KWLrjNK28ss6Tdqhs2GVLTnydnE286rU8fow9bZI1?=
 =?us-ascii?Q?GyrGDXhLnJLfrPtsk2OE7BudEglITidi438LSi4rD9vaumHv+6PRkwnj0GkS?=
 =?us-ascii?Q?Ojzj5mVtqk+kI1IFz0QE4Q7mPST5+2a3rbiqFmc5f3sKE6kuQy6UeuMDoLGU?=
 =?us-ascii?Q?w19VMxVtEjy2hhp50FJ3aZHvptnvL4382faG576+V/7ikWm8o/D2ZJQp3HHc?=
 =?us-ascii?Q?+pXKhFkBCqGVngE6UlHwDj+h/Bb1jGOVO+2dA3TD5UbiJvjgh69pVCTkQ2Jf?=
 =?us-ascii?Q?CoHeHCg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JkGYOOOD08SQGErbeK4VNEKnXj89+XtSY4DhwSMze7C/jnjhrzmuCsA1gIxF?=
 =?us-ascii?Q?A5yKZ2OD8oSibiaBBpUtebOxf6EcDo1C50houPeyiRZM8lw8o1SEW7S/ZjMv?=
 =?us-ascii?Q?09AOCjCBOtjIvW4mwkWfnvbAyIigSHT7y42kwvFnGE7lksW1IB/Sth7nZS7j?=
 =?us-ascii?Q?9WIRIF/4aIi+XUXLRfQOKNuy165FMKZfwKf5SjOLVCjpnpmRJDxwWPREK7Ln?=
 =?us-ascii?Q?p16/LbkkB52bn0gdcuv8tCv12ClNs8M+RFZDyMTL52nXnMjpRMIK1YMKZ952?=
 =?us-ascii?Q?wMGMhHsjNSFEj0R+KKfCeHqj61CxV+Gd9/OUqMnkwi21K83qS6FQky4smPkI?=
 =?us-ascii?Q?holYDFn2UbZvsvu+ksLE2wLw5EwXAeEBSgQgA9nybigNtk5VcisxmYpipgiz?=
 =?us-ascii?Q?uAOvwAjpy8wBVTQpzNaVlzCOvJtva7GqcimegFSYxldbET5GI0Wg3AZTFrfi?=
 =?us-ascii?Q?OG6DmFgCXd9tLgrZi3NgIol+tCjb0aO4G/UdHqITO2hRczG9qGQ+mXKarpan?=
 =?us-ascii?Q?NCz3W9xuxsIcc/T1jXcY+kRn8NRyuWZgAA69UYXRWSV1sHtbdRCvviWPCti7?=
 =?us-ascii?Q?6QUOjYLTQc6V+ELytB1SXr6V9YDo7ivpYPAshN6Mo78FiB4i78nGQCBh5/7G?=
 =?us-ascii?Q?wiPVvglaCbNYJAj0q2I1C0wgE56kvaoVoeqb/5PhCMS2lrZ6wQWA7PbVSQ0/?=
 =?us-ascii?Q?VPeXrR6IDPgUNsLWK5GbOnECzbWoeB4LPBPmTlyj5GvCP9QR9vrQCrSDw4NK?=
 =?us-ascii?Q?ilAv0XbgVh9KpPFqgCs3Bg5mh66SZ4OZsDIHUZEUvDmgtDQbGta1RTvm4gK5?=
 =?us-ascii?Q?OdmSEsFngWEPkLH1qJZE1y5fpLkZg3/3WbIOycAtyMkvgLo7CHBSyOcbbeWU?=
 =?us-ascii?Q?6Ju2uRo/5Xjhzu120Jhz6WHWD/sukpq4fqCczPk+rAlzDpko/9jgU+NyspjN?=
 =?us-ascii?Q?/rfsCoOlGUFtkFcgFq3rcGj1xpTc9+SpsNQRwcUM0ikSd7TXw5F2caZTFf2j?=
 =?us-ascii?Q?PVrsptyS1jzEw8Fd7PbWQ/y5rjr1JQMxM0NW0ShWYo64vPeTHWaUYBd6Sx/i?=
 =?us-ascii?Q?Lf6B4cYWhkm4Xbte3JEvbyAJmgP2jJ2o9l0Jw4twCWLLigl5piFp00dNkpCo?=
 =?us-ascii?Q?4XsEzwVxnpD0NMxkr3pn59LAiW1XcrbjtQvdvmzeq//p+fVdQAqXj4ZXZraC?=
 =?us-ascii?Q?qtC2ZHCtcLzSv0oV+YHQvaKw2VK/N7qoyJd7Bq6YeDD0ylFL5s3qv0eNKPBw?=
 =?us-ascii?Q?tgxKCg1fXsdRq/S9iNmm1ZfD2akvDOSuSV3nEXtnMc1Q1fjuhCbmmbopUZef?=
 =?us-ascii?Q?mUclHIg601shO6EP00UxM9ezyJkVK1H3xkcaseG/YaAXvea9XwnsIF93hicQ?=
 =?us-ascii?Q?sOTT9dZZpptBmYUarPz1MJFhkrHkrPnUre/OWO+N45ajIsElerylYgYJm0Al?=
 =?us-ascii?Q?MCGccepIIv6rNB42HYhKTc1KMz17H+280CfwUqUOvj5V6dRzX8k8QxoHlxzf?=
 =?us-ascii?Q?JVQqQ3PZ4VDEg3xFfUD+BIEdf7x98IJy5AMbUdWFJRUR6bUA21sTEBOAL/Tc?=
 =?us-ascii?Q?pZQ5CkgrX7O3krG4jaA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588937fa-3544-424c-024d-08dcf941e49c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2024 00:20:58.4586
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtVWlhbDf9K+nv9ZAHozbKvB85jhrGf7wdfSOMEX/PJj3rwSNH2UJWwI/scDM0OF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7573

[This is now based on Nicolin's iommufd patches for vIOMMU and will need
to go through the iommufd tree, please ack]

This brings support for the IOMMFD ioctls:

 - IOMMU_GET_HW_INFO
 - IOMMU_HWPT_ALLOC_NEST_PARENT
 - IOMMU_VIOMMU_ALLOC
 - IOMMU_DOMAIN_NESTED
 - IOMMU_HWPT_INVALIDATE
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

The VIOMMU object provides the framework to allow the invalidation path to
translate the vSID to a pSID and then issue the correct physical
invalidation. This is all done in the kernel as pSID has to
limited. Future patches will extend VIOMMU to handle specific HW features
like vMPAM and NVIDIA's vCMDQ.

Remove VFIO_TYPE1_NESTING_IOMMU since it was never used and superseded by
this.

This is the first series in what will be several to complete nesting
support. At least:
 - IOMMU_RESV_SW_MSI related fixups
    https://lore.kernel.org/linux-iommu/cover.1722644866.git.nicolinc@nvidia.com/
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

v4:
 - Rebase on Nicolin's patches
 - Add user_pasid_table=1 to support fault reporting on NESTED domains
 - Reorder STRTAB constants
 - Fix whitespace
 - Roll in the patches Nicolin had and merge together into a logical order
   Includes vIOMMU, ATS and invalidation patches
v3: https://patch.msgid.link/r/0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com
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

Jason Gunthorpe (7):
  vfio: Remove VFIO_TYPE1_NESTING_IOMMU
  iommu/arm-smmu-v3: Report IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
  iommu/arm-smmu-v3: Implement IOMMU_HWPT_ALLOC_NEST_PARENT
  iommu/arm-smmu-v3: Expose the arm_smmu_attach interface
  iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
  iommu/arm-smmu-v3: Use S2FWB for NESTED domains
  iommu/arm-smmu-v3: Allow ATS for IOMMU_DOMAIN_NESTED

Nicolin Chen (5):
  ACPICA: IORT: Update for revision E.f
  ACPI/IORT: Support CANWBS memory access flag
  iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via struct
    arm_smmu_hw_info
  iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC
  iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE using a VIOMMU object

 drivers/acpi/arm64/iort.c                     |  13 +
 drivers/iommu/Kconfig                         |   9 +
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   1 +
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 393 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 139 +++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  92 +++-
 drivers/iommu/arm/arm-smmu/arm-smmu.c         |  16 -
 drivers/iommu/io-pgtable-arm.c                |  27 +-
 drivers/iommu/iommu.c                         |  10 -
 drivers/iommu/iommufd/vfio_compat.c           |   7 +-
 drivers/vfio/vfio_iommu_type1.c               |  12 +-
 include/acpi/actbl2.h                         |   3 +-
 include/linux/io-pgtable.h                    |   2 +
 include/linux/iommu.h                         |   5 +-
 include/uapi/linux/iommufd.h                  |  83 ++++
 include/uapi/linux/vfio.h                     |   2 +-
 16 files changed, 712 insertions(+), 102 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c


base-commit: 9ffbeb478d44c57b9b2e263750b1056e5faebc9b
-- 
2.43.0


