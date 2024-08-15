Return-Path: <kvm+bounces-24278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 543E19536BC
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 790D21C23C94
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D1941B14E9;
	Thu, 15 Aug 2024 15:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bc65Mgp8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B20A1ABEA5
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734711; cv=fail; b=ftNEbDi+VnYNfqIsZl+dCqerWsoAbty7mXGS4sQP65RBy3omOqWPudJWZIMc3LO9NtwV3ZdxYr8LtLFw5KT/Qx5z0aQCP9XIryQF2veq0GTU85E/FrXMRqGQ1EDgoFEijAVBVhYAWql9ujTYK673CG7c4Xb1HQLot4K/j+lzpUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734711; c=relaxed/simple;
	bh=6x+8hYLDQJj/xR78vQiydWLUc5Uv/3s7jaqfaXc/rC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=K1Cn1qU/sfGbqEscotdNOb84j7K04PzEI8TtZW5sUs9DglnDL0cASdQmQBLBfAeMgKQ7VGEkf2ub1ZeWRi1ALEcXAi7tiWR0hkfD380vSqxH/KXvObKx5PHmc5GD6yKCX4EGaBre8pXtE6v2hoaQSF2ryCgSe61PGa0Dlgq5fdY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bc65Mgp8; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XI1xVYjubtsxuOy3lzYwqbZx7uHBoPZ+7AlbBdl+v9t47szRRWEUAmXSI62B44oGtwjhOXd1w3T7o3af38Qg9ZyVJwy/ala2OB7/vYGVukW7aVobhX2YGvZ3j28YtOgDujbewShWk6QT4nBBcsHo2CpxgOiSn7zOgE1fabVowR8us/qU2mNExVADinRnsXjL33LfNCEPZapPG9VG4D+vmVL5Ef25FGLKyYonvdT4kTwYavQG2kAZnEt5tZcDwSquxGDp5ylwhIsWhJoCqpRzvHPpmuZp6vGZN6jnfzueRiWocqbE4SZyWP46sacju67npBHugtFVU0S3nfaYY2+x0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qFj7xNRRHlQCtrNxbLIFFl5Astekl53+NqQ4R/I4deE=;
 b=aWvOFuHRJRfX5x7Uw90xylcdiaoTFO1Cb/VPqVFo+9aH5w0o2aF/zVzui4ICVbmazaeTo8YvGWgiZyfAxCkDa2PCwJDRnk3Q6Su0jV7BaK46sQ0LcwR8QjQ41+UGBLJZyKJYJaGS0DrCnf/JBTv0fuJvACrCT1oxX7GaX+ueWim7iwpoXh6QJmceCETwXQVeHaZaUhM4rFNiDSOQKgLHq1UdSNDq04n4rkWNJxPgCd79Qp0w4aQpJyryiGk67tqX21KV/CL0ZshmOrT3A+BhWXIilhInVQruuP8h/E0449fmfQu+G5egekUEiZE6q/fq1LEoOEQ7VcB/LrrFaSLSkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qFj7xNRRHlQCtrNxbLIFFl5Astekl53+NqQ4R/I4deE=;
 b=Bc65Mgp8Xz2fRW5fN3Ea3VvmRvcXsTeRvM41Xg5PGVye1yku7nA06kG4f/3DIp/n3hcT9s9kLsiXqfBEe7jw9+Qx4jg4h4wUxqOTctoGsHIvX1TUGMoLh/MJoCkG4SFF7/gZNOpyT+amTSB3gNI6KCam0sS6m9Nz3mW3mOOrwWT0yGREj8OL2+iyBXYCvlST9dh0hk9i0XzaEnU9c3HqQyEYx6Sx848BtuIdaO6uI9KYxsvOfhLLlsvasosRKaDyHNuolcvCRw5hj3asnEGsx/EvG02K6rqfa0Z3/TJ3yZYM3IXFIka7TS0hszJnhS1xmKQsOYHX4V3jJIJwKJd/Ng==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:37 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:37 +0000
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
Subject: [PATCH 16/16] iommupt: Add the Intel VT-D second stage page table format
Date: Thu, 15 Aug 2024 12:11:32 -0300
Message-ID: <16-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:208:335::18) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: 73f6fd1d-1f60-41c1-c916-08dcbd3c8d6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pz1rRhuegmyh0kVy+yP1TEpUjYHMDeyYggJ4+ch/WkuRAFnpwhcVmtuJyYGp?=
 =?us-ascii?Q?c8fHlPTRGbH2bzl24GpUEfNVVXhWeA0gLzXgizNwxSQXmJyEs7v65J9VSpOs?=
 =?us-ascii?Q?thZvtzrhBsJMpzPV8CQyFJKKiSQK1hxopX8cRMLRfzXBErPlQlYYQm0KxolD?=
 =?us-ascii?Q?l8zBnZ7frZ8EISTSCcDEkLxfoQcoTAE3juEtfNEymT/LyqFEFbqphFRqwDpb?=
 =?us-ascii?Q?vW/Mci8LiFZ5FzP6eDzvB9olh7eV3El8GniNx39ReuGNtL1pfo0AHk1+nQM5?=
 =?us-ascii?Q?ZabkBhgKeYfk+AKaqvXOzHpObzztDkFHft3zd9RI7hzJbJrSJGE82qpcSutA?=
 =?us-ascii?Q?3LMcrT7otwWE1uvv481c1R+QkE/AkZHtp5rQOiz8RBEP+87RvknID6mi2HOw?=
 =?us-ascii?Q?4ZBKMffLTT3w1DYuRe0xHiA64LX2EGMqRBP9esrXZRV69RNoS7P/DQmZ4AN3?=
 =?us-ascii?Q?zvrMjNuqWe8iVCjcMPZ+O+sCkYn4FuX9oSdgiHe4bagYDnxtI85RvyWVT6ey?=
 =?us-ascii?Q?ihbgjLRJ1o5ALjHceYnWLGbSIfIj8csLxXnCXS2vQEePE5E14cd5whRBCiMm?=
 =?us-ascii?Q?N4BIBp8F9u1aHOyubRN60wlZNnr2YspGZxSXYKsQ/bOKnCKKwTrgoTJpQz+M?=
 =?us-ascii?Q?va4JMzabfxjmrdRLW8DHnSKsfcc4k61floTEq5sCxadO++keLgo8yJwXEeR0?=
 =?us-ascii?Q?WnEzBkfAWJLokuOI58v0/7zIv+D0SEU3J1qfM2KGlrTVPpYP+4fQvpzaKRs6?=
 =?us-ascii?Q?WkLFPIJDeDDSBMY1hCDE+hFfPmT2D5640XsxPx4ggaHfyBOXx7kqfw7JK6yv?=
 =?us-ascii?Q?62ZMoOgXYTgc0W6Oa1dJCNSQMBvmlrzCluWh3nEJ+m4TzF/ZuZAmohvjuPlZ?=
 =?us-ascii?Q?q93lTWt6lmSAh8jxsmLCyt5/OuU4d3FaPIw6lDBcbzvuumdYR23ohGnOuw4z?=
 =?us-ascii?Q?N2Of9mKzwPSHwqnqXMCX1Bv3et5nHko8C+oXtxQwMPUpJsZKOwm48iz1DiwA?=
 =?us-ascii?Q?W1zgmd1z/IggmyhmXXS7lzsE8/ubDqTvSm8pEOrOzl90lnuZ/WaghcQj5Csc?=
 =?us-ascii?Q?IWpCdg3zvypND3h3+LP4/W8p7HPbaWPGjewvGWRhzmsEgjDLp13If9zZV4LO?=
 =?us-ascii?Q?VskVb/idJviQQSgTdNPoLnvAptnWH8CTMKkPp+6oL09LX0qM6dSHG5Y7cTfD?=
 =?us-ascii?Q?7pEA2kafCKwll30gvk/HCjxkdcrPvGIpnyHLJIGw5Y5Dd1tE8vjzeHTGX1aB?=
 =?us-ascii?Q?XLf2Vj2rSlEE2cDwPlCkVRnqN7NEkKK6SIiL1IPjt/zf+Qjal5gOF+y0hetP?=
 =?us-ascii?Q?sXt1WUDI76Lz7DVKD6ZWQWN9dt47uXAX+4SZFmapLThDuQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0k6DbcVAv+9L2wkPVIvDXQ/gbn0bG9n/4g+LodFDNaxJqEUH/e6lRXc2dUjQ?=
 =?us-ascii?Q?DIDxd5ozoBdmmOUBXkq6oKCHHKiiKl6UkRTOzhlMqhKDm4CSyyOY7uIUac8G?=
 =?us-ascii?Q?u5e6wxJEPvv52jCHWQ7CgiAAph6dy5WvzxsR5lt0p9tqxHzPEWhwhP6xQ5VY?=
 =?us-ascii?Q?krBwOAG9HyvoYqXv+PBD6dHAiBU5LDnEDQr/lZKzTNkuVf1Awyt6H5tYqSd6?=
 =?us-ascii?Q?Y+8z2PRFV8fpFiEg0lwY5XOGNHw/YT9k5hyBp4l8Op/mmY2qQbT/pOLkeGOy?=
 =?us-ascii?Q?sStDEk1lDZ+tCZ+45TWtaOdebBlJJd6QmZOTRQLd1gnwZ9Wr96brejGIW2UQ?=
 =?us-ascii?Q?/6dd8iSCKjUd5AgETMsFCNMEu2vf4P/LJcaqJq0m5eoZgOD8Vh5FvqtwSWde?=
 =?us-ascii?Q?PVHByI3KjPCaufYiZrjZbiPVSxlsyG1Ujxjig7m+Gz0huf5Wlpaiu1Um4i3t?=
 =?us-ascii?Q?hZlxZZFFv5zpUCojlJgq40A00zUZs2zACxZB2Qg2cjPQjY6/1gIC/EGkkigS?=
 =?us-ascii?Q?EXpUGKV6PyUhPhhGqUsGJVCmfxNslrh4l9+STyULvGLwhadBw06ExGxIy8uE?=
 =?us-ascii?Q?4Ty/ITNvlhy19NUOE1Z/q/81wEkhRUqNs6jBrGV356U+lGUshzyRYxZPgbMK?=
 =?us-ascii?Q?YlbLS5fUxeB1W1S9apmJYLD8EqIjhhK5o/lIPoUof9laY5VfxtA0u22PiRav?=
 =?us-ascii?Q?T3zkQM4en+hCzyuLnyIV5RVPuUlNbBsdppdtAyQzC4J5lrUJjIOmSBy72FkY?=
 =?us-ascii?Q?/Jp/6u/5JAwkeZfvS9+hyZ1u/NoSXfHuEq+7RtWpmg4xgmKCB6ZOH4rseO5S?=
 =?us-ascii?Q?DhPrXKEamXvXsrYpOOtj02PvF4pQF+42AV3LmvQO/TY9uKBB/3eiTGLZSYYD?=
 =?us-ascii?Q?nZnEHr4yDjxTYjWMd7UVGjXMJHlqAJ6vaBpvimJkQgI3hjt1gqRT/ogf8xBb?=
 =?us-ascii?Q?yageR56UD2rvpJ1s/VvcZlqOWitNsUH91aV1UyBxU8Lue1sMKp+jA0t/u6Il?=
 =?us-ascii?Q?FR+yPxH7qLlHr7nCBaJs1iqOz7rrKJ3LNqiDafam3dDCPT9+0NbOdVlAvoNb?=
 =?us-ascii?Q?JrXbz2byN6dl5iIUokCoGn2s4p/ymLNmfhVcwR75Ia8AGOlWrmccho5ffs/P?=
 =?us-ascii?Q?xM/+GDV20l4cJ1XYPCd1NKzlzFUvKdh92a3CQHbWvAS7AzubNufwlCmzlX6j?=
 =?us-ascii?Q?0aVB/zxCHwX8oPmx5RppndzZzBCrZJcYIBpJx45lBmO7H5NpNQNf3DJwehqK?=
 =?us-ascii?Q?9rPA9fpUyh+2gJKnmiq7A0n3c8+XGZ2Rw3hqCFQ3ufoMd2usqiFrCmtl7XhX?=
 =?us-ascii?Q?Wx8GlIpHddkI3M8pjZhCCkZz1INQAXf9qjP133W92yLVQMsGYIsktsJNsyeZ?=
 =?us-ascii?Q?KsimnXIZMyOjU3DvJvltOdmeMsCEmpwBGoN3UJ0PPcd6cFVCcbm62tIilYFc?=
 =?us-ascii?Q?e8qdsny4UDChzip4OUJbQ47XorA5uVw52WFFmOdlon3kxn+PzQTOuIKRuDCo?=
 =?us-ascii?Q?d/6QGRwJWl/huhDN5voDlS5qC0UwU+aW1JquwXNztBtlHKPdVkHs1UZ1yNPV?=
 =?us-ascii?Q?cg7yUnTPVp0tkStQG84=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f6fd1d-1f60-41c1-c916-08dcbd3c8d6b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:35.0962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UEaFXZouKfoXY3YANYSTj9cU3jGNmRGDJ14bQBvQC0R9p5eFQV1DfLu0lb8Q7WWu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

The VT-D second stage format is almost the same as the x86 PAE format,
except the bit encodings in the PTE are different and a few new PTE
features, like force coherency are present.

Among all the formats it is unique in not having a designated present bit.

Cc: Tina Zhang <tina.zhang@intel.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/Kconfig           |   6 +
 drivers/iommu/generic_pt/fmt/Makefile      |   2 +
 drivers/iommu/generic_pt/fmt/defs_vtdss.h  |  21 ++
 drivers/iommu/generic_pt/fmt/iommu_vtdss.c |   8 +
 drivers/iommu/generic_pt/fmt/vtdss.h       | 276 +++++++++++++++++++++
 include/linux/generic_pt/common.h          |   4 +
 include/linux/generic_pt/iommu.h           |  12 +
 7 files changed, 329 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_vtdss.h
 create mode 100644 drivers/iommu/generic_pt/fmt/iommu_vtdss.c
 create mode 100644 drivers/iommu/generic_pt/fmt/vtdss.h

diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
index 2d08b58e953e4d..c17e09e2d03025 100644
--- a/drivers/iommu/generic_pt/Kconfig
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -90,6 +90,11 @@ config IOMMU_PT_DART
 
 	  If unsure, say N here.
 
+config IOMMU_PT_VTDSS
+       tristate "IOMMU page table for Intel VT-D IOMMU Second Stage"
+	depends on !GENERIC_ATOMIC64 # for cmpxchg64
+	default n
+
 config IOMMU_PT_X86PAE
        tristate "IOMMU page table for x86 PAE"
 	depends on !GENERIC_ATOMIC64 # for cmpxchg64
@@ -105,6 +110,7 @@ config IOMMUT_PT_KUNIT_TEST
 	depends on IOMMU_PT_ARMV8_16K || !IOMMU_PT_ARMV8_16K
 	depends on IOMMU_PT_ARMV8_64K || !IOMMU_PT_ARMV8_64K
 	depends on IOMMU_PT_DART || !IOMMU_PT_DART
+	depends on IOMMU_PT_VTDSS || !IOMMU_PT_VTDSS
 	depends on IOMMU_PT_X86PAE || !IOMMU_PT_X86PAE
 	default KUNIT_ALL_TESTS
 endif
diff --git a/drivers/iommu/generic_pt/fmt/Makefile b/drivers/iommu/generic_pt/fmt/Makefile
index 1e10be24758fef..5a77c64d432534 100644
--- a/drivers/iommu/generic_pt/fmt/Makefile
+++ b/drivers/iommu/generic_pt/fmt/Makefile
@@ -10,6 +10,8 @@ iommu_pt_fmt-$(CONFIG_IOMMU_PT_ARMV8_64K) += armv8_64k
 
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_DART) += dart
 
+iommu_pt_fmt-$(CONFIG_IOMMU_PT_VTDSS) += vtdss
+
 iommu_pt_fmt-$(CONFIG_IOMMU_PT_X86PAE) += x86pae
 
 IOMMU_PT_KUNIT_TEST :=
diff --git a/drivers/iommu/generic_pt/fmt/defs_vtdss.h b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
new file mode 100644
index 00000000000000..4a239bcaae2a90
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_vtdss.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_VTDSS_H
+#define __GENERIC_PT_FMT_DEFS_VTDSS_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct vtdss_pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs vtdss_pt_write_attrs
+
+#endif
diff --git a/drivers/iommu/generic_pt/fmt/iommu_vtdss.c b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
new file mode 100644
index 00000000000000..12e7829815047b
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/iommu_vtdss.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#define PT_FMT vtdss
+#define PT_SUPPORTED_FEATURES 0
+
+#include "iommu_template.h"
diff --git a/drivers/iommu/generic_pt/fmt/vtdss.h b/drivers/iommu/generic_pt/fmt/vtdss.h
new file mode 100644
index 00000000000000..233731365ac62d
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/vtdss.h
@@ -0,0 +1,276 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Intel VT-D Second Stange 5/4 level page table
+ *
+ * This is described in
+ *   Section "3.7 Second-Stage Translation"
+ *   Section "9.8 Second-Stage Paging Entries"
+ *
+ * Of the "Intel Virtualization Technology for Directed I/O Architecture
+ * Specification".
+ *
+ * The named levels in the spec map to the pts->level as:
+ *   Table/SS-PTE - 0
+ *   Directory/SS-PDE - 1
+ *   Directory Ptr/SS-PDPTE - 2
+ *   PML4/SS-PML4E - 3
+ *   PML5/SS-PML5E - 4
+ * FIXME:
+ *  force_snooping
+ *  1g optional
+ *  forbid read-only
+ *  Use of direct clflush instead of DMA API
+ */
+#ifndef __GENERIC_PT_FMT_VTDSS_H
+#define __GENERIC_PT_FMT_VTDSS_H
+
+#include "defs_vtdss.h"
+#include "../pt_defs.h"
+
+#include <linux/bitfield.h>
+#include <linux/container_of.h>
+#include <linux/log2.h>
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 = 52,
+	PT_MAX_VA_ADDRESS_LG2 = 57,
+	PT_ENTRY_WORD_SIZE = sizeof(u64),
+	PT_MAX_TOP_LEVEL = 4,
+	PT_GRANUAL_LG2SZ = 12,
+	PT_TABLEMEM_LG2SZ = 12,
+};
+
+/* Shared descriptor bits */
+enum {
+	VTDSS_FMT_R = BIT(0),
+	VTDSS_FMT_W = BIT(1),
+	VTDSS_FMT_X = BIT(2),
+	VTDSS_FMT_A = BIT(8),
+	VTDSS_FMT_D = BIT(9),
+	VTDSS_FMT_SNP = BIT(11),
+	VTDSS_FMT_OA = GENMASK_ULL(51, 12),
+};
+
+/* PDPTE/PDE */
+enum {
+	VTDSS_FMT_PS = BIT(7),
+};
+
+#define common_to_vtdss_pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_vtdss, common)
+#define to_vtdss_pt(pts) common_to_vtdss_pt((pts)->range->common)
+
+static inline pt_oaddr_t vtdss_pt_table_pa(const struct pt_state *pts)
+{
+	return log2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry), PT_TABLEMEM_LG2SZ);
+}
+#define pt_table_pa vtdss_pt_table_pa
+
+static inline pt_oaddr_t vtdss_pt_entry_oa(const struct pt_state *pts)
+{
+	return log2_mul(FIELD_GET(VTDSS_FMT_OA, pts->entry), PT_GRANUAL_LG2SZ);
+}
+#define pt_entry_oa vtdss_pt_entry_oa
+
+static inline bool vtdss_pt_can_have_leaf(const struct pt_state *pts)
+{
+	return pts->level <= 2;
+}
+#define pt_can_have_leaf vtdss_pt_can_have_leaf
+
+static inline unsigned int vtdss_pt_table_item_lg2sz(const struct pt_state *pts)
+{
+	return PT_GRANUAL_LG2SZ +
+	       (PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64))) * pts->level;
+}
+#define pt_table_item_lg2sz vtdss_pt_table_item_lg2sz
+
+static inline unsigned int vtdss_pt_num_items_lg2(const struct pt_state *pts)
+{
+	return PT_TABLEMEM_LG2SZ - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 vtdss_pt_num_items_lg2
+
+static inline enum pt_entry_type vtdss_pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(tablep[pts->index]);
+	if (!entry)
+		return PT_ENTRY_EMPTY;
+	if (pts->level == 0 ||
+	    (vtdss_pt_can_have_leaf(pts) && (pts->entry & VTDSS_FMT_PS)))
+		return PT_ENTRY_OA;
+	return PT_ENTRY_TABLE;
+}
+#define pt_load_entry_raw vtdss_pt_load_entry_raw
+
+static inline void
+vtdss_pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			    unsigned int oasz_lg2,
+			    const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	entry = FIELD_PREP(VTDSS_FMT_OA, log2_div(oa, PT_GRANUAL_LG2SZ)) |
+		attrs->descriptor_bits;
+	if (pts->level != 0)
+		entry |= VTDSS_FMT_PS;
+
+	WRITE_ONCE(tablep[pts->index], entry);
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry vtdss_pt_install_leaf_entry
+
+static inline bool vtdss_pt_install_table(struct pt_state *pts,
+					  pt_oaddr_t table_pa,
+					  const struct pt_write_attrs *attrs)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	/*
+	 * FIXME according to the SDM D is ignored by HW on table pointers?
+	 * io_pgtable_v2 sets it
+	 */
+	entry = VTDSS_FMT_R | VTDSS_FMT_W |
+		FIELD_PREP(VTDSS_FMT_OA, log2_div(table_pa, PT_GRANUAL_LG2SZ));
+	return pt_table_install64(&tablep[pts->index], entry, pts->entry);
+}
+#define pt_install_table vtdss_pt_install_table
+
+static inline void vtdss_pt_attr_from_entry(const struct pt_state *pts,
+					    struct pt_write_attrs *attrs)
+{
+	attrs->descriptor_bits = pts->entry & (VTDSS_FMT_R | VTDSS_FMT_W |
+					       VTDSS_FMT_X | VTDSS_FMT_SNP);
+}
+#define pt_attr_from_entry vtdss_pt_attr_from_entry
+
+static inline void vtdss_pt_clear_entry(struct pt_state *pts,
+					unsigned int num_contig_lg2)
+{
+	u64 *tablep = pt_cur_table(pts, u64);
+
+	WRITE_ONCE(tablep[pts->index], 0);
+}
+#define pt_clear_entry vtdss_pt_clear_entry
+
+/* --- iommu */
+#include <linux/generic_pt/iommu.h>
+#include <linux/iommu.h>
+
+#define pt_iommu_table pt_iommu_vtdss
+
+/* The common struct is in the per-format common struct */
+static inline struct pt_common *common_from_iommu(struct pt_iommu *iommu_table)
+{
+	return &container_of(iommu_table, struct pt_iommu_table, iommu)
+			->vtdss_pt.common;
+}
+
+static inline struct pt_iommu *iommu_from_common(struct pt_common *common)
+{
+	return &container_of(common, struct pt_iommu_table, vtdss_pt.common)
+			->iommu;
+}
+
+static inline int vtdss_pt_iommu_set_prot(struct pt_common *common,
+					  struct pt_write_attrs *attrs,
+					  unsigned int iommu_prot)
+{
+	u64 pte = 0;
+
+	/*
+	 * VTDSS does not have a present bit, so we tell if any entry is present
+	 * by checking for R or W.
+	 */
+	if (!(iommu_prot & (IOMMU_READ | IOMMU_WRITE)))
+		return -EINVAL;
+
+	/*
+	 * FIXME: The VTD driver has a bug setting DMA_FL_PTE_PRESENT on the SS
+	 * table, which forces R on always.
+	 */
+	pte |= VTDSS_FMT_R;
+
+	if (iommu_prot & IOMMU_READ)
+		pte |= VTDSS_FMT_R;
+	if (iommu_prot & IOMMU_WRITE)
+		pte |= VTDSS_FMT_W;
+/* FIXME	if (dmar_domain->set_pte_snp)
+		pte |= VTDSS_FMT_SNP; */
+
+	attrs->descriptor_bits = pte;
+	return 0;
+}
+#define pt_iommu_set_prot vtdss_pt_iommu_set_prot
+
+static inline int vtdss_pt_iommu_fmt_init(struct pt_iommu_vtdss *iommu_table,
+					  struct pt_iommu_vtdss_cfg *cfg)
+{
+	struct pt_vtdss *table = &iommu_table->vtdss_pt;
+
+	/* FIXME configurable */
+	pt_top_set_level(&table->common, 3);
+	return 0;
+}
+#define pt_iommu_fmt_init vtdss_pt_iommu_fmt_init
+
+#if defined(GENERIC_PT_KUNIT)
+static void vtdss_pt_kunit_setup_cfg(struct pt_iommu_vtdss_cfg *cfg)
+{
+}
+#define pt_kunit_setup_cfg vtdss_pt_kunit_setup_cfg
+#endif
+
+/*
+ * Requires Tina's series:
+ *  https://patch.msgid.link/r/20231106071226.9656-3-tina.zhang@intel.com
+ * See my github for an integrated version
+ */
+#if defined(GENERIC_PT_KUNIT) && IS_ENABLED(CONFIG_CONFIG_IOMMU_IO_PGTABLE_VTD)
+#include <linux/io-pgtable.h>
+
+static struct io_pgtable_ops *
+vtdss_pt_iommu_alloc_io_pgtable(struct pt_iommu_vtdss_cfg *cfg,
+				struct device *iommu_dev,
+				struct io_pgtable_cfg **unused_pgtbl_cfg)
+{
+	struct io_pgtable_cfg pgtbl_cfg = {};
+
+	pgtbl_cfg.ias = 48;
+	pgtbl_cfg.oas = 52;
+	pgtbl_cfg.vtd_cfg.cap_reg = 4 << 8;
+	pgtbl_cfg.vtd_cfg.ecap_reg = BIT(26) | BIT(60) | BIT_ULL(48) | BIT_ULL(56);
+	pgtbl_cfg.pgsize_bitmap = SZ_4K;
+	pgtbl_cfg.coherent_walk = true;
+	return alloc_io_pgtable_ops(INTEL_IOMMU, &pgtbl_cfg, NULL);
+}
+#define pt_iommu_alloc_io_pgtable vtdss_pt_iommu_alloc_io_pgtable
+
+static void vtdss_pt_iommu_setup_ref_table(struct pt_iommu_vtdss *iommu_table,
+					   struct io_pgtable_ops *pgtbl_ops)
+{
+	struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(pgtbl_ops)->cfg;
+	struct pt_common *common = &iommu_table->vtdss_pt.common;
+
+	pt_top_set(common, __va(pgtbl_cfg->vtd_cfg.pgd), 3);
+}
+#define pt_iommu_setup_ref_table vtdss_pt_iommu_setup_ref_table
+
+static u64 vtdss_pt_kunit_cmp_mask_entry(struct pt_state *pts)
+{
+	if (pts->type == PT_ENTRY_TABLE)
+		return pts->entry & (~(u64)(VTDSS_FMT_OA));
+	return pts->entry;
+}
+#define pt_kunit_cmp_mask_entry vtdss_pt_kunit_cmp_mask_entry
+#endif
+
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 558302fe1e0324..a3469132db7dda 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -145,6 +145,10 @@ enum {
 	PT_FEAT_DART_V2 = PT_FEAT_FMT_START,
 };
 
+struct pt_vtdss {
+	struct pt_common common;
+};
+
 struct pt_x86pae {
 	struct pt_common common;
 };
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index 351a69fe62dd1d..b9ecab07b0223d 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -317,6 +317,18 @@ struct pt_iommu_dart_cfg {
 int pt_iommu_dart_init(struct pt_iommu_dart *table,
 		       struct pt_iommu_dart_cfg *cfg, gfp_t gfp);
 
+struct pt_iommu_vtdss {
+	struct pt_iommu iommu;
+	struct pt_vtdss vtdss_pt;
+};
+
+struct pt_iommu_vtdss_cfg {
+	struct device *iommu_device;
+	unsigned int features;
+};
+int pt_iommu_vtdss_init(struct pt_iommu_vtdss *table,
+			struct pt_iommu_vtdss_cfg *cfg, gfp_t gfp);
+
 struct pt_iommu_x86pae {
 	struct pt_iommu iommu;
 	struct pt_x86pae x86pae_pt;
-- 
2.46.0


