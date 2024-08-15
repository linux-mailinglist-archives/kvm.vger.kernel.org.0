Return-Path: <kvm+bounces-24286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17CB89536C5
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:13:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8C7521F2376D
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:13:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821D61B32D5;
	Thu, 15 Aug 2024 15:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T5M2Luh1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3CF1B3740
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734716; cv=fail; b=Jn6jcZw11mtKgIVz4uJV77tde4xbHJW6kJM2a+Q4HDuVyPguhvcEhTvx+EkWeHdCW3YFsw38q9DFJUan+pw5vcDFPjCBZv/mbdS0k0lFdnqasnDqOqc4xCc3S12VCgjFSV2flGrvFRSADQPw0c9vtDeJnnpnoyz0iPAQv3zzAAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734716; c=relaxed/simple;
	bh=CwR9hoANP7Il6EfEizLmR0uj+9y6oks3YYIFklMaO6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i5x4WantZqdv9VPdvAzxTIJzRJs185pOodg9AeZ57yo3xI6oqiCwC1P0kVP76Z0cKHs2q8gvu4WY53C/56y9YVq3D9UcGdxGCMYNZub3eM/SwjZ7BH2plnLJA5HufdPLdVjgQxdq+agavf/YtkJxkgwdk1hOJH0MTAPl82xJM6U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T5M2Luh1; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yTscM4liO+R6nmvnPivwawETKgVyhRgZRhQgahehDU/bQEkhdLykjArDPFBBSVRgwfec+oL1a2MyoYWijVD3NhutN4HGw2jQA8lJPWj0EWKubbrzInlqP8Tjdv8Kl6W/am7FDHwNbBt33gnjKjU4wINQNRJntz47pN6qQhPZOBTcra6XQ8uan1wctXyCWCQOStuRSDj7CXVTcARKRrBSqOy8jlLoIpLZ0ljboPJdBLm4o0YJ6S+fMjnQZBW7fNbTd0Y35cgE59jMfwuATbui+1fR7bYP2Xge+l6hiJyI0Dlfug8e6ASZihbnrJKtOeyDgTEZivk0WXdXCtCVnCLR9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UMO+N4m33e4uKA41iVkBD8LJ8dCbYmDwvtksBzyKWAI=;
 b=NtHFwf63PH+tcXUO2C7bAxuOAn+Kh/U/kWRMJ5ap04LhrIblNKGuw+uqDwRetv8kBgW2no+aPUcSAnRCKWcwUBfak0f5BtkFVv3hF4SnN2EZNSv7hXYrwJWEvKJcT0iltkPvH/trTU0xmWDW/0oj4WvwdKELlB25cakZu7jk/asff4pfkF+N9001SxleeCapVszBPRIMoKEpsQJRfo0gCgvbK+L2e+gyWcTJEzHaPfrQHv+ywn/Vtsd4RK7UoAxcdOZpxwbn4nejORfcvxKHFXBsBDI3Kp3LHs7dx3HyKo+F8gbnSB1o+VZ9Q9hatzFmfUx5barusEsfEMwSCHralg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UMO+N4m33e4uKA41iVkBD8LJ8dCbYmDwvtksBzyKWAI=;
 b=T5M2Luh1mUhyZNSO2tXzTIkr2ck/JMOU7HZQz9sC1s5Emt9DyhcvSNLl7vkTpEXSEzL/U5IW0AUP47D8INxdw8m8CG6uhRHugmgoeKSRaDuWAQZij/bila6aFdtNarfamJF3gXoJK+yORfCInvzxuNlhaxoEoXaRW7NktkCGL++4N/gEDLbzmbtxupalvjCtMH8I0G205kSy570xSzEpP12HT//fVCI553E/pBhYCCWOND4waRgTznvgyf64Ss04kZmOwlB4rzii6Xejlj9si67L++igdJqyA3UDS/3lnt9kTNeTHYlOAQALybZ/w86wOq+2OWS8MlE2gnWLfSethA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:44 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:44 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To:
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	iommu@lists.linux.dev,
	Joao Martins <joao.m.martins@oracle.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org,
	linux-mm@kvack.org,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Tina Zhang <tina.zhang@intel.com>
Subject: [PATCH 10/16] iommupt: Add a kunit test to compare against iopt
Date: Thu, 15 Aug 2024 12:11:26 -0300
Message-ID: <10-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0221.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::16) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 4298e728-2e3e-40eb-64ca-08dcbd3c8f0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qBKw0ZmHC3j22Z1LC4shsphPj4WbwKntTamwvdFeJmKJtnsXC0vwC3arMV2v?=
 =?us-ascii?Q?h2vGs1nKzR2RsM2zjw7f2iP/7DKcDuYpKrJDWvQ5FUxJiBIoMxUgUtc/3hYY?=
 =?us-ascii?Q?1vvSwMYjVXuoOJkhTNMumsmupseercgy171ecyinbgPtpiPOnaig6w2v4aYi?=
 =?us-ascii?Q?CqoAUrwB5+oIQtYn8eZxPN+9tuTGN5Sx/Qlc70fqSf7WX4jeRA8V+pQOaDU5?=
 =?us-ascii?Q?ozpbJzcTGjfP+Wggp4U9Nu19E8J9c8FHFKDXMcMeTY3A65zRx2P4OyOxqXbn?=
 =?us-ascii?Q?lfpPi2pi0Vzjj6Fha4iaMogb5ME30vuVnEKCiOJG1shXN0cY5MgiWA5r9Czu?=
 =?us-ascii?Q?dElIBRDRihOHKhOQuJtI38BJyERAqM3H5td98s6QaJXNWRrk1PCJ5lIfoPUI?=
 =?us-ascii?Q?y4HSAJe/lAZVd4BgiP7elz367nElfDW1twBJJFZjYoone15qHlErprDyzH/0?=
 =?us-ascii?Q?4GRmY+/k4U6igpNOzATsBo9lp1tw/UkhFl7SRbphNf3Q8/6BD7mVXAYI4CG6?=
 =?us-ascii?Q?ODWdnwD++mrGNNZlx+EXMZtbiRdfOvzPt/sQtYuMqNcFpZeouHE2yvgAZNhi?=
 =?us-ascii?Q?WeiP64/qBR03UJpGx3mRKMZ2igNbhG+pwyVoNXMeB8nJVAhtUlLrefr6Rcvz?=
 =?us-ascii?Q?MCHPshC2yTmAB47qQY5gW9UfxVidCLU4ACiSh2Ik2HXA1ibIRCi5W6vU1Cnd?=
 =?us-ascii?Q?uQ8f4/LvxfVGaciM2d/OSO415jZg/G2xKFmmecKSLs899yLLcuWaZvOt8qP6?=
 =?us-ascii?Q?YWjwGFmN0XRnO8RbAH4hXF+6JNGkej5VjnFLPl1ZebnjFvtCK2rOgUQGUNVA?=
 =?us-ascii?Q?ojYlsIBufR3hmXnt0HnLbRqh+hq/4YQIxewLN0f0O0S1RWAnW/CUKoKagZYh?=
 =?us-ascii?Q?6RBbpvBKvFD8uCAhBhL+eDBunluF8qrSAtpv9CGOR9tV66HFFw3kshGnEkVQ?=
 =?us-ascii?Q?UD+CAyGnVY0Cxsl6aJiGVhKNlw4FRVveTT8R10+bZ6z1YfU+9LlPtEmeqo+N?=
 =?us-ascii?Q?A7rFvXPNt3QWkBxB1xQ8CCwC0rU4442/c/Ak2zrS6ZIKda3AW/Ey4x8lvPLk?=
 =?us-ascii?Q?cM7X+bEPWqvp3bkWNhUXqs8eoa19oPVG0N3GqhrbFdfv2VDsA30oYJSGWksq?=
 =?us-ascii?Q?gIjzdKfIynkVSFNeexuhdNmcYGUicu2/omeleIxqerd4GxZJ6wz2UaBj16Un?=
 =?us-ascii?Q?Xdbb8vcTLF7Be4DY1NqWvb8nZzXsSxHYzqMrDAyw/raHgzohisPV+kPqPkBP?=
 =?us-ascii?Q?m4HUwEJzUAnBL5P4a5PdESGPP3xb3oSxm/jtjZZPu0HDa5eD2+BSO6fogvJi?=
 =?us-ascii?Q?XzlAA/G4bjNxEtaFrhh9bjoUQH2KT5K5VJqKsWzk8Yq+UA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aFphMUVSByhSrseQm8pRD0s3DrnFDvkPMNsTAysKnErfSpvipNVdnLgsItfn?=
 =?us-ascii?Q?SFPFedHC+NgwNPKgrBSRcKBdT4cF98el3wAJRQhaL1FOobl5owBbNEUqmqay?=
 =?us-ascii?Q?VEJa6C5Uchj+Ys+u69kzyUzwDAyohNMCRveuxfnFz9UxaQd/CVz2TnTbNIfT?=
 =?us-ascii?Q?6QAffdcHRLveyPZnVRmAujbnuRianF/ee3y84czbUxq14Isjtg/PF0Gr+mO5?=
 =?us-ascii?Q?GMkBYXnZAXRh12UofuP+17kZiirbG4JvFazgyTXAHKZv725WThuY2vmBUqT8?=
 =?us-ascii?Q?2FYxD6uImLzjaj5CNGam8UFDjQ5Lb3iBP2x6rMYj5XClAQ5nYTNj5gnIxCrx?=
 =?us-ascii?Q?pXkm7ATjDnC1dZZgwTUYpV/q9nnodsUKsohKUP9xnB3FblGOy7azK544rng+?=
 =?us-ascii?Q?PotEOKthg4tpqCnFIqRtMiMOUHmnQtcn27RVeSPI21wl24YT1XvVmUO8OjWg?=
 =?us-ascii?Q?8wN3To3VO4CZEMkA80ATtBS3/K9gosh7FWI1m05vS6MlmbRhvC9/86lxnVkK?=
 =?us-ascii?Q?lS016pxWNqVzAKWDbRriqQ3LJDw8JTQgTuMRav57+oDbMiE0c110DKOaUaEo?=
 =?us-ascii?Q?f2bzQ9D/ue0UXnH/dzBasd2gclbjLuHM9yR468BKTeEjZJDejFI325Zw6Nt1?=
 =?us-ascii?Q?AqxU+AiBolhaCRFsobgzTmNGOVMp0lZEDuN5MTnmVTpnoJbLAcK3QjzTOsHV?=
 =?us-ascii?Q?y5/vEYTCqmWLSMeqhtREyhVzpg2JTDtCjqt0MbOxJvFmVPMsOS8p9mru7S47?=
 =?us-ascii?Q?fxDHG/tnMFPluRkHwNNPuzv6dHnYRm2Wrv+qFE0g8Qf0iMQV2awQn0Cq+2M2?=
 =?us-ascii?Q?hLeHkhm8flHxQwzfVC5EK7Zj/aWbT+GhFvdIbkFC1/gxZOD0N2HmzjbZ0ANG?=
 =?us-ascii?Q?FMhO6ofr6dvaV75NqxxSFW2PyytoKkY1MOv3LkH9m2cnVmQhQpjdaU/Y8/ih?=
 =?us-ascii?Q?blct5BnE7c5tpy/3obf7r2VisycAAZO2Jfg8sDfE/vSTr5VK2p9UtWIfEPLI?=
 =?us-ascii?Q?tMg8Sg765Q/d/4f2U1YhZ3PJnjhwZWxgZTscGALda7WWKMWY8c64rXReHWhz?=
 =?us-ascii?Q?EIszc+LxhANdESbhd+e6nftnXm4KGr3lgJj859XZlhtXdrHBTB2HKDtgMv5P?=
 =?us-ascii?Q?TUkSPmGpnd935HHk7RPdcAmh0UG69UFcomYHj1L0Kv5KQKb9vqFo/1ELQCkD?=
 =?us-ascii?Q?BJSnDfTUkvP/5PCVG19orU+hDmeomZU0SeKMcGuZQ6PD42IpCCfleAiQNH27?=
 =?us-ascii?Q?Vv77N1qoJlMCb5B/GeqXnQuCzNalHC4ilaz4LnU8KVT5PLjcN4Q6xXQpcIJO?=
 =?us-ascii?Q?XqsMkiHBZGFEW7W6I0whTHm78+sAhSaJ6NlEqLKylPGSbtyUXiaGU4Te6s7M?=
 =?us-ascii?Q?g+qy5B2je/XKhmUlxEH3XvJcpqxFb6c2iu5IRCkfCO1WWBb9lx4kGRvjXDmi?=
 =?us-ascii?Q?/GGZY7m2m6KJWsDC/Q3Zb/qFnAtpdB7pshSbYw1v58W66hhnXC/iGHavkKrG?=
 =?us-ascii?Q?Kl18JBJBefCrk5XYmHb4e9/4JHSTYd9ycuFpftGAsyzJR1c9AHIzS60RP8v6?=
 =?us-ascii?Q?FBjTj0dcljpTw+nUfS4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4298e728-2e3e-40eb-64ca-08dcbd3c8f0e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:37.7310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oyVI2z1T5JpnEMVflfMbYfMRmdgLkKXgMspwJeyF3Y7t6PjjYt9D88qmpr5r8e7f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

The comparison tests checks the memory layout of the page table against
the memory layout created by the io-pgtable version to ensure they are the
same. This gives a high confidence aspects of the formats are working
correctly.

Most likely this would never be merged to the kernel, it is a useful
development tool to build the formats.

The compare tests for AMDv1, x86PAE and VTD SS require a bunch of hacky
patches to those drivers and this kunit command:

./tools/testing/kunit/kunit.py run --build_dir build_kunit_x86_64 --arch x86_64 --kunitconfig ./drivers/iommu/generic_pt/.kunitconfig --kconfig_add CONFIG_PCI=y --kconfig_add CONFIG_AMD_IOMMU=y --kconfig_add CONFIG_INTEL_IOMMU=y --kconfig_add CONFIG_CONFIG_IOMMU_IO_PGTABLE_VTD=y

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/.kunitconfig         |  10 +
 drivers/iommu/generic_pt/Kconfig              |   1 +
 drivers/iommu/generic_pt/fmt/iommu_template.h |   3 +
 drivers/iommu/generic_pt/kunit_iommu_cmp.h    | 272 ++++++++++++++++++
 4 files changed, 286 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/kunit_iommu_cmp.h

diff --git a/drivers/iommu/generic_pt/.kunitconfig b/drivers/iommu/generic_pt/.kunitconfig
index f428cae8ce584c..a16ca5f72a7c5b 100644
--- a/drivers/iommu/generic_pt/.kunitconfig
+++ b/drivers/iommu/generic_pt/.kunitconfig
@@ -11,3 +11,13 @@ CONFIG_IOMMU_PT_DART=y
 CONFIG_IOMMU_PT_VTDSS=y
 CONFIG_IOMMU_PT_X86PAE=y
 CONFIG_IOMMUT_PT_KUNIT_TEST=y
+
+CONFIG_COMPILE_TEST=y
+CONFIG_IOMMU_IO_PGTABLE_LPAE=y
+CONFIG_IOMMU_IO_PGTABLE_ARMV7S=y
+CONFIG_IOMMU_IO_PGTABLE_DART=y
+# These are x86 specific and can't be turned on generally
+# Turn them on to compare test x86pae and vtdss
+#CONFIG_AMD_IOMMU=y
+#CONFIG_INTEL_IOMMU=y
+#CONFIG_CONFIG_IOMMU_IO_PGTABLE_VTD=y
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 2c5c2bc59bf8ea..3ac9b2324ebd98 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -31,6 +31,7 @@ config IOMMU_PT
 if IOMMU_PT
 config IOMMUT_PT_KUNIT_TEST
 	tristate "IOMMU Page Table KUnit Test" if !KUNIT_ALL_TESTS
+	select IOMMU_IO_PGTABLE
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_template.h b/drivers/iommu/generic_pt/fmt/iommu_template.h
index 809f4ce6874591..8d113cc68ec485 100644
--- a/drivers/iommu/generic_pt/fmt/iommu_template.h
+++ b/drivers/iommu/generic_pt/fmt/iommu_template.h
@@ -43,4 +43,7 @@
  */
 #include "../kunit_generic_pt.h"
 #include "../kunit_iommu_pt.h"
+#ifdef pt_iommu_alloc_io_pgtable
+#include "../kunit_iommu_cmp.h"
+#endif
 #endif
diff --git a/drivers/iommu/generic_pt/kunit_iommu_cmp.h b/drivers/iommu/generic_pt/kunit_iommu_cmp.h
new file mode 100644
index 00000000000000..283b3f2b07425e
--- /dev/null
+++ b/drivers/iommu/generic_pt/kunit_iommu_cmp.h
@@ -0,0 +1,272 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#include "kunit_iommu.h"
+#include "pt_iter.h"
+#include <linux/iommu.h>
+#include <linux/io-pgtable.h>
+
+struct kunit_iommu_cmp_priv {
+	/* Generic PT version */
+	struct kunit_iommu_priv fmt;
+
+	/* IO pagetable version */
+	struct io_pgtable_ops *pgtbl_ops;
+	struct io_pgtable_cfg *fmt_memory;
+	struct pt_iommu_table ref_table;
+};
+
+struct compare_tables {
+	struct kunit *test;
+	struct pt_range ref_range;
+	struct pt_table_p *ref_table;
+};
+
+static int __compare_tables(struct pt_range *range, void *arg,
+			    unsigned int level, struct pt_table_p *table)
+{
+	struct pt_state pts = pt_init(range, level, table);
+	struct compare_tables *cmp = arg;
+	struct pt_state ref_pts =
+		pt_init(&cmp->ref_range, level, cmp->ref_table);
+	struct kunit *test = cmp->test;
+	int ret;
+
+	for_each_pt_level_item(&pts) {
+		u64 entry, ref_entry;
+
+		cmp->ref_range.va = range->va;
+		ref_pts.index = pts.index;
+		pt_load_entry(&ref_pts);
+
+		entry = pt_kunit_cmp_mask_entry(&pts);
+		ref_entry = pt_kunit_cmp_mask_entry(&ref_pts);
+
+		/*if (entry != 0 || ref_entry != 0)
+			printk("Check %llx Level %u index %u ptr %px refptr %px: %llx (%llx) %llx (%llx)\n",
+			       pts.range->va, pts.level, pts.index,
+			       pts.table,
+			       ref_pts.table,
+			       pts.entry, entry,
+			       ref_pts.entry, ref_entry);*/
+
+		KUNIT_ASSERT_EQ(test, pts.type, ref_pts.type);
+		KUNIT_ASSERT_EQ(test, entry, ref_entry);
+		if (entry != ref_entry)
+			return 0;
+
+		if (pts.type == PT_ENTRY_TABLE) {
+			cmp->ref_table = ref_pts.table_lower;
+			ret = pt_descend(&pts, arg, __compare_tables);
+			if (ret)
+				return ret;
+		}
+
+		/* Defeat contiguous entry aggregation */
+		pts.type = PT_ENTRY_EMPTY;
+	}
+
+	return 0;
+}
+
+static void compare_tables(struct kunit *test)
+{
+	struct kunit_iommu_cmp_priv *cmp_priv = test->priv;
+	struct kunit_iommu_priv *priv = &cmp_priv->fmt;
+	struct pt_range range = pt_top_range(priv->common);
+	struct compare_tables cmp = {
+		.test = test,
+	};
+	struct pt_state pts = pt_init_top(&range);
+	struct pt_state ref_pts;
+
+	pt_iommu_setup_ref_table(&cmp_priv->ref_table, cmp_priv->pgtbl_ops);
+	cmp.ref_range =
+		pt_top_range(common_from_iommu(&cmp_priv->ref_table.iommu));
+	ref_pts = pt_init_top(&cmp.ref_range);
+	KUNIT_ASSERT_EQ(test, pts.level, ref_pts.level);
+
+	cmp.ref_table = ref_pts.table;
+	KUNIT_ASSERT_EQ(test, pt_walk_range(&range, __compare_tables, &cmp), 0);
+}
+
+static void test_cmp_init(struct kunit *test)
+{
+	struct kunit_iommu_cmp_priv *cmp_priv = test->priv;
+	struct kunit_iommu_priv *priv = &cmp_priv->fmt;
+	struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(cmp_priv->pgtbl_ops)->cfg;
+
+	/* Fixture does the setup */
+	KUNIT_EXPECT_NE(test, priv->info.pgsize_bitmap, 0);
+
+	/* pt_iommu has a superset of page sizes (ARM supports contiguous) */
+	KUNIT_EXPECT_EQ(test,
+			priv->info.pgsize_bitmap & pgtbl_cfg->pgsize_bitmap,
+			pgtbl_cfg->pgsize_bitmap);
+
+	/* Empty compare works */
+	compare_tables(test);
+}
+
+static void do_cmp_map(struct kunit *test, pt_vaddr_t va, pt_oaddr_t pa,
+		       pt_oaddr_t len, unsigned int prot)
+{
+	struct kunit_iommu_cmp_priv *cmp_priv = test->priv;
+	struct kunit_iommu_priv *priv = &cmp_priv->fmt;
+	const struct pt_iommu_ops *ops = priv->iommu->ops;
+	size_t mapped;
+	int ret;
+
+	/* This lacks pagination, must call with perfectly aligned everything */
+	if (sizeof(unsigned long) == 8) {
+		KUNIT_EXPECT_EQ(test, va % len, 0);
+		KUNIT_EXPECT_EQ(test, pa % len, 0);
+	}
+
+	mapped = 0;
+	ret = ops->map_pages(priv->iommu, va, pa, len, prot, GFP_KERNEL,
+			     &mapped, NULL);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, mapped, len);
+
+	mapped = 0;
+	ret = cmp_priv->pgtbl_ops->map_pages(cmp_priv->pgtbl_ops, va, pa, len,
+					     1, prot, GFP_KERNEL, &mapped);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	KUNIT_EXPECT_EQ(test, mapped, len);
+}
+
+static void do_cmp_unmap(struct kunit *test, pt_vaddr_t va, pt_vaddr_t len)
+{
+	struct kunit_iommu_cmp_priv *cmp_priv = test->priv;
+	struct kunit_iommu_priv *priv = &cmp_priv->fmt;
+	const struct pt_iommu_ops *ops = priv->iommu->ops;
+	size_t ret;
+
+	KUNIT_EXPECT_EQ(test, va % len, 0);
+
+	ret = ops->unmap_pages(priv->iommu, va, len, NULL);
+	KUNIT_EXPECT_EQ(test, ret, len);
+	ret = cmp_priv->pgtbl_ops->unmap_pages(cmp_priv->pgtbl_ops, va, len, 1,
+					       NULL);
+	KUNIT_EXPECT_EQ(test, ret, len);
+}
+
+static void test_cmp_one_map(struct kunit *test)
+{
+	struct kunit_iommu_cmp_priv *cmp_priv = test->priv;
+	struct kunit_iommu_priv *priv = &cmp_priv->fmt;
+	struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(cmp_priv->pgtbl_ops)->cfg;
+	const pt_oaddr_t addr =
+		oalog2_mod(0x74a71445deadbeef, priv->common->max_oasz_lg2);
+	pt_vaddr_t pgsize_bitmap = priv->safe_pgsize_bitmap &
+				   pgtbl_cfg->pgsize_bitmap;
+	pt_vaddr_t cur_va;
+	unsigned int prot = 0;
+	unsigned int pgsz_lg2;
+
+	/*
+	 * Check that every prot combination at every page size level generates
+	 * the same data in page table.
+	 */
+	for (prot = 0; prot <= (IOMMU_READ | IOMMU_WRITE | IOMMU_CACHE |
+				IOMMU_NOEXEC | IOMMU_MMIO);
+	     prot++) {
+		/* Page tables usually cannot represent inaccessible memory */
+		if (!(prot & (IOMMU_READ | IOMMU_WRITE)))
+			continue;
+
+		/* Try every supported page size */
+		cur_va = priv->smallest_pgsz * 256;
+		for (pgsz_lg2 = 0; pgsz_lg2 != PT_VADDR_MAX_LG2; pgsz_lg2++) {
+			pt_vaddr_t len = log2_to_int(pgsz_lg2);
+
+			if (!(pgsize_bitmap & len))
+				continue;
+
+			cur_va = ALIGN(cur_va, len);
+			do_cmp_map(test, cur_va,
+				   oalog2_set_mod(addr, 0, pgsz_lg2), len,
+				   prot);
+			compare_tables(test);
+			cur_va += len;
+		}
+
+		cur_va = priv->smallest_pgsz * 256;
+		for (pgsz_lg2 = 0; pgsz_lg2 != PT_VADDR_MAX_LG2; pgsz_lg2++) {
+			pt_vaddr_t len = log2_to_int(pgsz_lg2);
+
+			if (!(pgsize_bitmap & len))
+				continue;
+
+			cur_va = ALIGN(cur_va, len);
+			do_cmp_unmap(test, cur_va, len);
+			compare_tables(test);
+			cur_va += len;
+		}
+	}
+}
+
+static int pt_kunit_iommu_cmp_init(struct kunit *test)
+{
+	struct kunit_iommu_cmp_priv *cmp_priv;
+	struct kunit_iommu_priv *priv;
+	int ret;
+
+	test->priv = cmp_priv = kzalloc(sizeof(*cmp_priv), GFP_KERNEL);
+	if (!cmp_priv)
+		return -ENOMEM;
+	priv = &cmp_priv->fmt;
+
+	ret = pt_kunit_priv_init(priv);
+	if (ret)
+		goto err_priv;
+
+	cmp_priv->pgtbl_ops = pt_iommu_alloc_io_pgtable(
+		&priv->cfg, &priv->dummy_dev, &cmp_priv->fmt_memory);
+	if (!cmp_priv->pgtbl_ops) {
+		ret = -ENOMEM;
+		goto err_fmt_table;
+	}
+
+	cmp_priv->ref_table = priv->fmt_table;
+	return 0;
+
+err_fmt_table:
+	pt_iommu_deinit(priv->iommu);
+err_priv:
+	kfree(test->priv);
+	test->priv = NULL;
+	return ret;
+}
+
+static void pt_kunit_iommu_cmp_exit(struct kunit *test)
+{
+	struct kunit_iommu_cmp_priv *cmp_priv = test->priv;
+	struct kunit_iommu_priv *priv = &cmp_priv->fmt;
+
+	if (!test->priv)
+		return;
+
+	pt_iommu_deinit(priv->iommu);
+	free_io_pgtable_ops(cmp_priv->pgtbl_ops);
+	pt_iommu_free_pgtbl_cfg(cmp_priv->fmt_memory);
+	kfree(test->priv);
+}
+
+static struct kunit_case cmp_test_cases[] = {
+	KUNIT_CASE(test_cmp_init),
+	KUNIT_CASE(test_cmp_one_map),
+	{},
+};
+
+static struct kunit_suite NS(cmp_suite) = {
+	.name = __stringify(NS(iommu_cmp_test)),
+	.init = pt_kunit_iommu_cmp_init,
+	.exit = pt_kunit_iommu_cmp_exit,
+	.test_cases = cmp_test_cases,
+};
+kunit_test_suites(&NS(cmp_suite));
-- 
2.46.0


