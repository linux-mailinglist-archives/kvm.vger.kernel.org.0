Return-Path: <kvm+bounces-24279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 267B09536BE
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 17:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1ABC11F21C71
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 15:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 258ED1B29A2;
	Thu, 15 Aug 2024 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="uo2LMgq7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB5B1A76C1
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 15:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723734712; cv=fail; b=awZhoRkATB9kJYidNnRrXJy/fB1EJAdliR87MzYpz0nv0k0DvcVj20nt6EbP0Dlp3YtEGGumSMLke0Zk9tt3hUrps7iaXmo1QXV+HFZKyGFLhvXeorW259hdJEbJXlifp/tbR+PeGbAsg5tfpKGt2LEi2Q9eHyHzMR7CU/JPlYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723734712; c=relaxed/simple;
	bh=8cna2in0HBUaUTGhbHodCo0Gz77C+6NzH/AUC5spjjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Tb80ualHIPAZAujTul7Z+dPVQRd2ZKI2gyKSUdJ6IAfkHpm/WwQCYgWD0Njs4yBwN0x4CEWkQ+7xVH01sEQNJr7aLCvcqssw0wfV+ZP4roJpGYhRz8cJXCVvlE0CaM4vR0IUC6RE+ASBnlL6qM+8hlxfjde3S8Mcrl6HzCA4cOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=uo2LMgq7; arc=fail smtp.client-ip=40.107.92.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ODfj9GEPwCG0EKXhB68SkfI87cw5pSnzDRz2EDNn1hsnj5kTs1Ll5t/gFyqNPDXsbRMWj8Wv2DC9rQo9rZmQAldbx/Ho1HffWn96shLRT1PGAk9YBnvYZdEp+RD/0RlzWU8RExkscuaNiLYiGtGMW1VFxSEdMMhzJHRpgpViZwd8f9M0w8FsoYD1AkdBYdAafanKkoPc8lhafA+L7X3HmvTqv9XcqPoGlYoHpShqtXnS3eWYCcaL7l33kY4gu0RGIZVrXf39RaVgt4EnXh6ijmldvU+m6YGPi/0mvERxZ1R63WJVFurxbZDjLjB9gDgnnNQijx5DJDA/mwvG7fZ1HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4i3+91myaSeMKFwRWjAwIQMVPNUJoAHh9k4U94hNes=;
 b=y3Y+HrIrMYC3tkIEV0LcU5s183cAUYxYT1CMM3Lv/0Q/Hqmj2v9sYap65iz3x/thxxew08jH/Idb0zPj6cbiYIfdZXkKBWOvIJXoAwkNGVFIBFJxd+eUHT5D1geL1ISxMCqpZcCyuU2LX3LcEVMc7918FeF51/f9JHqRMOUB3/DWAExfy8ai89wMLb1R9OzcIhq+q2m+WlFjYGI+MwEfNKp/lqDz4Az3sCNeT/NVmttVjCNvSmzJW6bcjAjw8Wx96dGHSbVLatwQ1tsQbEQYlLy/rgng4gqsuhDAfi1iqWBcoG+ZPbuX+cwWth477bijUPvAIEemzrhF+UjTB65NXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4i3+91myaSeMKFwRWjAwIQMVPNUJoAHh9k4U94hNes=;
 b=uo2LMgq7EWR7pTxnWYMw0kGRpEDBGH0lDu17bAmSwzaNs0NGqg8w9PjePTtC2a1Ro14Fqdb/Fvi4cwAOaEfZ2QlGSND7+OEnzO3inok8bLkTlzoGd8a9OUovRS1BBrWG6w28auq9AVdD47bckD/6zF/vKnFnYobLYZXYZ0mWgqvIFkkTtz/jSxp1QtzQQAH1pI0IoLRAivHmwISPJR9jhkKR1BylPBjnHkAP7GM0lIahk2+CQHceBX8g81U3GYF47RBDgjxyVrhVa15opYSOlIpNS743TDjDTmWEQ5YsKVHJmfwVBP17sC9kJbL0/EVjghYJHrPxd18fr18R3SDpbQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB8146.namprd12.prod.outlook.com (2603:10b6:806:323::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Thu, 15 Aug
 2024 15:11:35 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 15:11:35 +0000
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
Subject: [PATCH 01/16] genpt: Generic Page Table base API
Date: Thu, 15 Aug 2024 12:11:17 -0300
Message-ID: <1-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
In-Reply-To: <0-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0066.namprd20.prod.outlook.com
 (2603:10b6:208:235::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB8146:EE_
X-MS-Office365-Filtering-Correlation-Id: fc2709e6-b664-4d8b-e8e5-08dcbd3c8d3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IH05gsQRs+G42/f7gbGlN4AE6vp4cgdR/9hOooGGUoSHv1eTudBEw7Qu6eza?=
 =?us-ascii?Q?gIinfg25HUu9Hyg/TXvJCpx2ifclurpkTWYROPdhor7+e5o8n+YllIgDmnAD?=
 =?us-ascii?Q?AOhjPq4H88eqzjM1H0sHHAeqBUKou7yuy/mlY97lfwPhqkPXvOf3ELl2uHY5?=
 =?us-ascii?Q?2Z1StIA70N9K0hrYhakM1eZP5h16lY/iAXAuphSnaK1PBbYgrAQ81EbB5LpX?=
 =?us-ascii?Q?+LVlJp4sP7Ctidaq+GhTRdLiRcy7JH/fCO1UFkTpcC9HfVYPyNfXgPrUvoVH?=
 =?us-ascii?Q?S14h09nv7iPgekjbFzee0D8irOY5zmrn53ZpR09lVbLXrPZ9Kw+IKtnqkZ5F?=
 =?us-ascii?Q?pcufK04WlGFiftv0ILiB1IY2bbxfvd4CWnD2CgXTT88nmtLFD7Ei1//LDe8c?=
 =?us-ascii?Q?cYASvlC+cmsU+YMarhuy+UoLYr/HcDgewoZvH299qCMqrMpWyCJAd3Az2uCK?=
 =?us-ascii?Q?BNfGNSV7K/2IzvDyvxdBrljlYCdCHnfCNQU62njkX38TrPQV7hpv7P2gZedw?=
 =?us-ascii?Q?O39bz4escb9sixAxTOugX2UF4MtRhn8kRrG3czTq/DUL31Ay0qt7om5L5MEi?=
 =?us-ascii?Q?Ra3maCjEPWwMO+JQ3pji4GvuPBIwP4KtkJT+NNx8JRq5qEWZ2Je5dJdL/RKw?=
 =?us-ascii?Q?O40Gy5i7VwZas6rjgdzS5+a7pTo/m125pqixFslLYXClOBNFWLYdUQVebKHK?=
 =?us-ascii?Q?Odk0weFnUfuPioH6EW3/1tHpHNeLUK1Yv65UfwnDkv7jmPKyOEoGotirzb3N?=
 =?us-ascii?Q?QV+B5vTrPy+SI1f3P4slU/OU4zVIYQu33QvPNSObrjJ1pw9dYF3kf/opxaGv?=
 =?us-ascii?Q?VOdAZ+SlPcMbm2DjMG3RsT97PDJUEqWvx3yNp4Qn/P2QtmoaRfdVVWqKpQMM?=
 =?us-ascii?Q?7ZUHX8eLQAW+38dIdNcqCf7QcD+vp+vJdtHTqbXEkFGS/+Na+tMyLzup5SdV?=
 =?us-ascii?Q?ddPZd9oNYRS6XJ5TjTJkSJeP82bDjm8d1utqbEcIU9jlqhXRsR5iMKTKigJ1?=
 =?us-ascii?Q?CZgAViZYKMOqzg9/pX7toUUDHMYrKXpqtEKzO/VXOrkrcntHQbNtoHFSER41?=
 =?us-ascii?Q?mgicpfDZPqFnmLbsEn7gvmEtpBRttT+CQKPNK+p3vRZ83lJjpyakH2r32+KL?=
 =?us-ascii?Q?zM+lmJtOwGp5+AeHwb/+e/re1gM1vLpyR+IDqB1pv2I1bUDNXOnhc0BXe52Z?=
 =?us-ascii?Q?hz3gdExO9vHjvo3cpqO1TLVmHflAib3a0LZdMXJXpUm5LyYGgOxeSfu3DNX3?=
 =?us-ascii?Q?OsZbwBw3M0n1ikwLvDlpGqRFwFG2EN3yIsCOefFGurpennYadtnmQgXHAAFi?=
 =?us-ascii?Q?AWZhLOyU19QqtmvVzepLDlxbqy1/RlaMZZ8COoZ8gSpmRA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MCU7w3/UPheOyuuIlLVbnefCYwGCaL/qyfx0ulTfXxcJ0WnYtUHSGprJR06H?=
 =?us-ascii?Q?ilQCnzpeL47IEbzvO5dgX9OJjOBagdbLvne1KiLdeuTP5pXwvuXv5sJ4wtcq?=
 =?us-ascii?Q?7rvqFW4Rk//f6rxuPRXEziFKpfxNq2sYPbrMHabn33df8ptSOSD1saIFDywK?=
 =?us-ascii?Q?kFVP8mI49m+uRNpzyAsY8DNOWawB/4NXl87M6pmRewMb0Uip7iPj4NsVvJE7?=
 =?us-ascii?Q?h0uKMSjBOCtSn8dOGtb3P0kekX2JmdYx9I874l1NHfOCDfA4GfBenkdDH5pQ?=
 =?us-ascii?Q?nN9p5R1Mq+y6Jal/0OvV5ynfIja5nvM/r00XQc2zEOOPL8rMuuCbX6uWVPEf?=
 =?us-ascii?Q?K81xdw3UakyZpxQ+J976DhgbEKpUqgKVa91+CZiw3HCOW/O9I3u+YRM2P2sb?=
 =?us-ascii?Q?CzDLyW58Fr/jx8Vi9XxTQZpsxX2PY6nMQaA2K5QoeYOyIaXiE6GXpf3/Ucmu?=
 =?us-ascii?Q?S2hDt+Q2lwTA6SbGKNp5UVppW3CgqHz/D7OOjqS6+TndjostlF/DXTRwt2lp?=
 =?us-ascii?Q?FZOJpV2b7+Atg7jZyEP+dkXnVbRsNmjxbCObsVmR15llCeuk9ySoOYEzQA0M?=
 =?us-ascii?Q?Wk2mzAFElhPxM6cFOs0yDI89pYmXHQ/ujG4EwnkSI7RBsspBueUVd6+TDSgT?=
 =?us-ascii?Q?UBJt6cHlgMoxs3c2sorBYQJ3f7u7I6J6vKRzlRrujqZ0rYxNirHgm7b15xTT?=
 =?us-ascii?Q?H5HjHuwhNYCLjfSu/c6X8UytgNBDRvvrqLziCB+RYvUCvgdCanc8iP/zOpjj?=
 =?us-ascii?Q?6VwzA1XJWKMpfoPqDUa/VMrbEcY/XMFAP+koi3A1V66fYWSZkjGGL4CzBZWk?=
 =?us-ascii?Q?uovwkigVbRSlaQNFuWm8OU1flYFH6s/d+lgK+kUa3Fl9MW537BGNufGfRzjT?=
 =?us-ascii?Q?4mJ7VKIjVrMIR8kONxuP5/A05bNIV7SB99ni8x0FF9QRA1XkODlG53ET/GFD?=
 =?us-ascii?Q?vr3jFzw63++BlW/tscxQapHrTWzOfcj5xhPne6K8DU0jd+kDMjWVBNp/gONx?=
 =?us-ascii?Q?BfehP1oYoEdOHH9wceAJrisa4W1SMcaBj/SNONUmL+AzqSrmqeAtx5QMr7j+?=
 =?us-ascii?Q?7ktjXVfjOosf1p/PAMgAFspptaodhb3IFuu0pNEJ+ZKo7mbc9dYTRtEeIXES?=
 =?us-ascii?Q?/oXMJddjETqkp3/Tj+HzFDvFLwPRUU2LW2bQrIU1O3MEs49hD7jjLKCg4Lpe?=
 =?us-ascii?Q?1tBrgNwdoAdsP3QvGL6p5byYt70qPxzENoLOWm0YpBfbCcc0LaWRz9pn7dvV?=
 =?us-ascii?Q?aNyNsEs+mdrvwAf2AXh77OCN4ms0pVhrUYAbqQkENyVSUBgTACuR6yiqOb2x?=
 =?us-ascii?Q?q03sUGiR8QbvyGT69UlyDktZQtFwpEVFoXqhxCEpAYzwpiiQvd6vCT1N1oZD?=
 =?us-ascii?Q?AFeBvgchzFxwZS3NTQ29LAbOy8k4obCIJEg46fazvSxi9x6xXEkB1UmsEMIq?=
 =?us-ascii?Q?uxx3wJ7HlANffINUVyxxRm+8VwEPx3CVCzoFpWLYc+n0Ld6+YWErwKVsqxX7?=
 =?us-ascii?Q?/uunWS+zLu3k5fbdDal18K9EtIr+oS5cZy19l+hnLJbnGvvWOSsg8z1aBWNv?=
 =?us-ascii?Q?nRIO5eUxGqy21lxxpcc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc2709e6-b664-4d8b-e8e5-08dcbd3c8d3d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 15:11:34.8110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K7dzTaOVNkFtM51YWRbXpXSKcVHxYUkA7YQTAwZWuncBi/Y75r0vQ72QKCWybrpx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8146

The generic API is intended to be separated from the implementation of
page table algorithms. It contains only accessors for walking and
manipulating the table and helpers that are useful for building an
implementation. Memory management is part of the implementation.

Using a multi-compilation approach the implementation module would include
headers in this order:

  common.h
  defs_FMT.h
  pt_defs.h
  FMT.h
  pt_common.h
  IMPLEMENTATION.h

Where each compilation unit would have a combination of FMT and
IMPLEMENTATION to produce a per-format per-implementation module.

The API is designed so that the format headers have minimal logic, and
default implementations are provided if the format doesn't include one.

Generally formats provide their code via an inline function using the
pattern:

  static inline FMTpt_XX(..) {}
  #define pt_XX FMTpt_XX

The common code then enforces a function signature so that there is no
drift in function arguments, or accidental polymorphic functions (as has
been slightly troublesome in mm). Use of function-like #defines are
avoided in the format even though many of the functions are small enough.

Provide kdocs for the API surface.

This is enough to implement the 8 initial format variations with all of
their features:
 * Entries comprised of contiguous blocks of IO PTEs for larger page sizes
 * Multi-level tables, up to 6 levels. Runtime selected top level
 * Runtime variable table level size (ARM's concatenated tables)
 * Expandable top level
 * Optional leaf entries at any level
 * 32 bit/64 bit virtual and output addresses, using every bit
 * Dirty tracking
 * DMA incoherent table walkers
 * Bottom up and top down tables

A basic simple format takes about 200 lines to declare the require inline
functions.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .clang-format                              |   1 +
 drivers/iommu/Kconfig                      |   2 +
 drivers/iommu/Makefile                     |   1 +
 drivers/iommu/generic_pt/Kconfig           |  22 +
 drivers/iommu/generic_pt/Makefile          |   1 +
 drivers/iommu/generic_pt/pt_common.h       | 311 ++++++++++++++
 drivers/iommu/generic_pt/pt_defs.h         | 276 ++++++++++++
 drivers/iommu/generic_pt/pt_fmt_defaults.h | 109 +++++
 drivers/iommu/generic_pt/pt_iter.h         | 468 +++++++++++++++++++++
 drivers/iommu/generic_pt/pt_log2.h         | 131 ++++++
 include/linux/generic_pt/common.h          | 103 +++++
 11 files changed, 1425 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/Kconfig
 create mode 100644 drivers/iommu/generic_pt/Makefile
 create mode 100644 drivers/iommu/generic_pt/pt_common.h
 create mode 100644 drivers/iommu/generic_pt/pt_defs.h
 create mode 100644 drivers/iommu/generic_pt/pt_fmt_defaults.h
 create mode 100644 drivers/iommu/generic_pt/pt_iter.h
 create mode 100644 drivers/iommu/generic_pt/pt_log2.h
 create mode 100644 include/linux/generic_pt/common.h

diff --git a/.clang-format b/.clang-format
index 252820d9c80a15..88b7b42c7170fd 100644
--- a/.clang-format
+++ b/.clang-format
@@ -381,6 +381,7 @@ ForEachMacros:
   - 'for_each_prop_dlc_cpus'
   - 'for_each_prop_dlc_platforms'
   - 'for_each_property_of_node'
+  - 'for_each_pt_level_item'
   - 'for_each_reg'
   - 'for_each_reg_filtered'
   - 'for_each_reloc'
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index a82f10054aec86..70ee313fb3fe93 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -509,3 +509,5 @@ config SPRD_IOMMU
 	  Say Y here if you want to use the multimedia devices listed above.
 
 endif # IOMMU_SUPPORT
+
+source "drivers/iommu/generic_pt/Kconfig"
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 542760d963ec7c..b978af18b94598 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y += amd/ intel/ arm/ iommufd/
+obj-$(CONFIG_GENERIC_PT) += generic_pt/
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
diff --git a/drivers/iommu/generic_pt/Kconfig b/drivers/iommu/generic_pt/Kconfig
new file mode 100644
index 00000000000000..775a3afb563f72
--- /dev/null
+++ b/drivers/iommu/generic_pt/Kconfig
@@ -0,0 +1,22 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+menuconfig GENERIC_PT
+	bool "Generic Radix Page Table"
+	default n
+	help
+	  Generic library for building radix tree page tables.
+
+	  Generic PT provides a set of HW page table formats and a common
+	  set of APIs to work with them.
+
+if GENERIC_PT
+config DEBUG_GENERIC_PT
+	bool "Extra debugging checks for GENERIC_PT"
+	default n
+	help
+	  Enable extra run time debugging checks for GENERIC_PT code. This
+	  incurs a runtime cost and should not be enabled for production
+	  kernels.
+
+	  The kunit tests require this to be enabled to get full coverage.
+endif
diff --git a/drivers/iommu/generic_pt/Makefile b/drivers/iommu/generic_pt/Makefile
new file mode 100644
index 00000000000000..f66554cd5c4518
--- /dev/null
+++ b/drivers/iommu/generic_pt/Makefile
@@ -0,0 +1 @@
+# SPDX-License-Identifier: GPL-2.0
diff --git a/drivers/iommu/generic_pt/pt_common.h b/drivers/iommu/generic_pt/pt_common.h
new file mode 100644
index 00000000000000..c5c09ea95850b5
--- /dev/null
+++ b/drivers/iommu/generic_pt/pt_common.h
@@ -0,0 +1,311 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * This header is included after the format. It contains definitions
+ * that build on the format definitions to create the basic format API.
+ *
+ * The format API is listed here, with kdocs, in alphabetical order. The
+ * functions without bodies are implemented in the format using the pattern:
+ *     static inline FMTpt_XXX(..) {..}
+ *     #define pt_XXX FMTpt_XXX
+ *
+ * The routines marked "@pts: Entry to query" operate on the entire contiguous
+ * entry and can be called with a pts->index pointing to any sub item that makes
+ * up that entry.
+ *
+ * The header order is:
+ *  pt_defs.h
+ *  fmt_XX.h
+ *  pt_common.h
+ */
+#ifndef __GENERIC_PT_PT_COMMON_H
+#define __GENERIC_PT_PT_COMMON_H
+
+#include "pt_defs.h"
+#include "pt_fmt_defaults.h"
+
+/**
+ * pt_attr_from_entry() - Convert the permission bits back to attrs
+ * @pts: Entry to convert from
+ * @attrs: Resulting attrs
+ *
+ * Fill in the attrs with the permission bits encoded in the current leaf entry.
+ * The attrs should be usable with pt_install_leaf_entry() to reconstruct the
+ * same entry.
+ */
+static inline void pt_attr_from_entry(const struct pt_state *pts,
+				      struct pt_write_attrs *attrs);
+
+/**
+ * pt_can_have_leaf() - True if the current level can have an OA entry
+ * @pts: The current level
+ *
+ * True if the current level can support pt_install_leaf_entry(). A leaf
+ * entry produce an OA.
+ */
+static inline bool pt_can_have_leaf(const struct pt_state *pts);
+
+/**
+ * pt_can_have_table() - True if the current level can have a lower table
+ * @pts: The current level
+ *
+ * Every level except 0 is allowed to have a lower table.
+ */
+static inline bool pt_can_have_table(const struct pt_state *pts)
+{
+	/* No further tables at level 0 */
+	return pts->level > 0;
+}
+
+/**
+ * pt_clear_entry() - Make entries empty (non-present)
+ * @pts: Starting table index
+ * @num_contig_lg2: Number of contiguous items to clear
+ *
+ * Clear a run of entries. A cleared entry will load back as PT_ENTRY_EMPTY
+ * and does not have any effect on table walking. The starting index must be
+ * aligned to num_contig_lg2.
+ */
+static inline void pt_clear_entry(struct pt_state *pts,
+				  unsigned int num_contig_lg2);
+
+/**
+ * pt_entry_num_contig_lg2() - Number of contiguous items for this leaf entry
+ * @pts: Entry to query
+ *
+ * Returns the number of contiguous items this leaf entry spans. If the entry is
+ * single item it returns ilog2(1).
+ */
+static inline unsigned int pt_entry_num_contig_lg2(const struct pt_state *pts);
+
+/**
+ * pt_entry_oa() - Output Address for this leaf entry
+ * @pts: Entry to query
+ *
+ * Return the output address for the start of the entry. If the entry
+ * is contigous this returns the same value for each sub-item. Ie:
+ *    log2_mod(pt_entry_oa(), pt_entry_oa_lg2sz()) == 0
+ *
+ * See pt_item_oa(). The format should implement one of these two functions
+ * depending on how it stores the OA's in the table.
+ */
+static inline pt_oaddr_t pt_entry_oa(const struct pt_state *pts);
+
+/**
+ * pt_entry_oa_lg2sz() - Return the size of a OA entry
+ * @pts: Entry to query
+ *
+ * If the entry is not contigous this returns pt_table_item_lg2sz(), otherwise
+ * it returns the total VA/OA size of the entire contiguous entry.
+ */
+static inline unsigned int pt_entry_oa_lg2sz(const struct pt_state *pts)
+{
+	return pt_entry_num_contig_lg2(pts) + pt_table_item_lg2sz(pts);
+}
+
+/**
+ * pt_entry_oa_full() - Return the full OA for an entry
+ * @pts: Entry to query
+ *
+ * During iteration the first entry could have a VA with an offset from the
+ * natural start of the entry. Return the true full OA considering this VA
+ * offset.
+ */
+/* Include the sub page bits as well */
+static inline pt_oaddr_t pt_entry_oa_full(const struct pt_state *pts)
+{
+	return _pt_entry_oa_fast(pts) |
+	       log2_mod(pts->range->va, pt_entry_oa_lg2sz(pts));
+}
+
+/**
+ * pt_entry_set_write_clean() - Make the entry write clean
+ * @pts: Table index to change
+ *
+ * Modify the entry so that pt_entry_write_is_dirty() == false. The HW will
+ * eventually be notified of this change via a TLB flush, which is the point
+ * that the HW must become synchronized. Any "write dirty" prior to the TLB
+ * flush can be lost, but once the TLB flush completes all writes must make
+ * their entries write dirty.
+ *
+ * The format should alter the entry in a way that is compatible with any
+ * concurrent update from HW.
+ */
+static inline void pt_entry_set_write_clean(struct pt_state *pts);
+
+/**
+ * pt_entry_write_is_dirty() - True if the entry has been written to
+ * @pts: Entry to query
+ *
+ * "write dirty" means that the HW has written to the OA translated
+ * by this entry. If the entry is contiguous then the consolidated
+ * "write dirty" for all the items must be returned.
+ */
+static inline bool pt_entry_write_is_dirty(const struct pt_state *pts);
+
+/**
+ * pt_full_va_prefix() - The top bits of the VA
+ * @common: Page table to query
+ *
+ * This is usually 0, but some formats have their VA space going downward from
+ * PT_VADDR_MAX, and will return that instead. This value must always be
+ * adjusted by struct pt_common max_vasz_lg2.
+ */
+static inline pt_vaddr_t pt_full_va_prefix(const struct pt_common *common);
+
+/**
+ * pt_install_leaf_entry() - Write a leaf entry to the table
+ * @pts: Table index to change
+ * @oa: Output Address for this leaf
+ * @oasz_lg2: Size in VA for this leaf
+ *
+ * A leaf OA entry will return PT_ENTRY_OA from pt_load_entry(). It translates
+ * the VA indicated by pts to the given OA.
+ *
+ * For a single item non-contiguous entry oasz_lg2 is pt_table_item_lg2sz().
+ * For contiguous it is pt_table_item_lg2sz() + num_contig_lg2.
+ *
+ * This must not be called if pt_can_have_leaf() == false. Contigous sizes
+ * not indicated by pt_possible_sizes() must not be specified.
+ */
+static inline void pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+					 unsigned int oasz_lg2,
+					 const struct pt_write_attrs *attrs);
+
+/**
+ * pt_install_table() - Write a table entry to the table
+ * @pts: Table index to change
+ * @table_pa: CPU physical address of the lower table's memory
+ * @attrs: Attributes to modify the table index
+ *
+ * A table entry will return PT_ENTRY_TABLE from pt_load_entry(). The table_pa
+ * is the table at pts->level - 1.
+ *
+ * This must not be called if pt_can_have_table() == false.
+ */
+static inline bool pt_install_table(struct pt_state *pts, pt_oaddr_t table_pa,
+				    const struct pt_write_attrs *attrs);
+
+/**
+ * pt_item_oa() - Output Address for this leaf item
+ * @pts: Item to query
+ *
+ * Return the output address for this item. If the item is part of a contiguous
+ * entry it returns the value of the OA for this individual sub item.
+ *
+ * See pt_entry_oa(). The format should implement one of these two functions
+ * depending on how it stores the OA's in the table.
+ */
+static inline pt_oaddr_t pt_item_oa(const struct pt_state *pts);
+
+/**
+ * pt_load_entry_raw() - Read from the location pts points at into the pts
+ * @pts: Table index to load
+ *
+ * Return the type of entry that was loaded. pts->entry will be filled in with
+ * the entry's content. See pt_load_entry()
+ */
+static inline enum pt_entry_type pt_load_entry_raw(struct pt_state *pts);
+
+/**
+ * pt_max_output_address_lg2() - Return the maximum OA the table format can hold
+ * @common: Page table to query
+ *
+ * The value oalog2_to_max_int(pt_max_output_address_lg2()) is the MAX for the
+ * OA. This is the absolute maximum address the table can hold. struct pt_common
+ * max_oasz_lg2 sets a lower dynamic maximum based on HW capability.
+ */
+static inline unsigned int
+pt_max_output_address_lg2(const struct pt_common *common);
+
+/**
+ * pt_num_items_lg2() - Return the number of items in this table level
+ * @pts: The current level
+ *
+ * The number of items in a table level defines the number of bits this level
+ * decodes from the VA. This function is not called for the top level,
+ * so it does not need to compute a special value for the top case. The
+ * result for the top is based on pt_common max_vasz_lg2.
+ *
+ * The value is used as part if determining the table indexes via the
+ * equation:
+ *   log2_mod(log2_div(VA, pt_table_item_lg2sz()), pt_num_items_lg2())
+ */
+static inline unsigned int pt_num_items_lg2(const struct pt_state *pts);
+
+/**
+ * pt_possible_sizes() - Return a bitmap of possible output sizes at this level
+ * @pts: The current level
+ *
+ * Each level has a list of possible output sizes that can be installed as
+ * leaf entries. If pt_can_have_leaf() is false returns zero.
+ *
+ * Otherwise the bit in position pt_table_item_lg2sz() should be set indicating
+ * that a non-contigous singe item leaf entry is supported. The following
+ * pt_num_items_lg2() number of bits can be set indicating contiguous entries
+ * are supported. Bit pt_table_item_lg2sz() + pt_num_items_lg2() must not be
+ * set, contiguous entries cannot span the entire table.
+ *
+ * The OR of pt_possible_sizes() of all levels is the typical bitmask of all
+ * supported sizes in the entire table.
+ */
+static inline pt_vaddr_t pt_possible_sizes(const struct pt_state *pts);
+
+/**
+ * pt_table_item_lg2sz() - Size of a single item entry in this table level
+ * @pts: The current level
+ *
+ * The size of the item specifies how much VA and OA a single item occupies.
+ *
+ * See pt_entry_oa_lg2sz() for the same value including the effect of contiguous
+ * entries.
+ */
+static inline unsigned int pt_table_item_lg2sz(const struct pt_state *pts);
+
+/**
+ * pt_table_oa_lg2sz() - Return the VA/OA size of the entire table
+ * @pts: The current level
+ *
+ * Return the size of VA decoded by the entire table level.
+ */
+static inline unsigned int pt_table_oa_lg2sz(const struct pt_state *pts)
+{
+	return min_t(unsigned int, pts->range->common->max_vasz_lg2,
+		     pt_num_items_lg2(pts) + pt_table_item_lg2sz(pts));
+}
+
+/**
+ * pt_table_pa() - Return the CPU physical address of the table entry
+ * @pts: Entry to query
+ *
+ * This is only ever called on PT_ENTRY_TABLE entries. Must return the same
+ * value passed to pt_install_table().
+ */
+static inline pt_oaddr_t pt_table_pa(const struct pt_state *pts);
+
+/**
+ * pt_table_ptr() - Return a CPU pointer for a table item
+ * @pts: Entry to query
+ *
+ * Same as pt_table_pa() but returns a CPU pointer.
+ */
+static inline struct pt_table_p *pt_table_ptr(const struct pt_state *pts)
+{
+	return __va(pt_table_pa(pts));
+}
+
+/**
+ * pt_load_entry() - Read from the location pts points at into the pts
+ * @pts: Table index to load
+ *
+ * Set the type of entry that was loaded. pts->entry and pts->table_lower
+ * will be filled in with the entry's content.
+ */
+static inline void pt_load_entry(struct pt_state *pts)
+{
+	pts->type = pt_load_entry_raw(pts);
+	if (pts->type == PT_ENTRY_TABLE)
+		pts->table_lower = pt_table_ptr(pts);
+}
+#endif
diff --git a/drivers/iommu/generic_pt/pt_defs.h b/drivers/iommu/generic_pt/pt_defs.h
new file mode 100644
index 00000000000000..80ca5beb286ff4
--- /dev/null
+++ b/drivers/iommu/generic_pt/pt_defs.h
@@ -0,0 +1,276 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * This header is included before the format. It contains definitions
+ * that are required to compile the format. The header order is:
+ *  pt_defs.h
+ *  fmt_XX.h
+ *  pt_common.h
+ */
+#ifndef __GENERIC_PT_DEFS_H
+#define __GENERIC_PT_DEFS_H
+
+#include <linux/generic_pt/common.h>
+
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <linux/bits.h>
+#include <linux/limits.h>
+#include <linux/bug.h>
+#include <linux/kconfig.h>
+#include "pt_log2.h"
+
+/* Header self-compile default defines */
+#ifndef pt_write_attrs
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+#endif
+
+enum {
+	PT_VADDR_MAX = sizeof(pt_vaddr_t) == 8 ? U64_MAX : U32_MAX,
+	PT_VADDR_MAX_LG2 = sizeof(pt_vaddr_t) == 8 ? 64 : 32,
+	PT_OADDR_MAX = sizeof(pt_oaddr_t) == 8 ? U64_MAX : U32_MAX,
+	PT_OADDR_MAX_LG2 = sizeof(pt_oaddr_t) == 8 ? 64 : 32,
+};
+
+/*
+ * When in debug mode we compile all formats with all features. This allows the
+ * kunit to test the full matrix.
+ */
+#if IS_ENABLED(CONFIG_DEBUG_GENERIC_PT)
+#undef PT_SUPPORTED_FEATURES
+#define PT_SUPPORTED_FEATURES UINT_MAX
+#endif
+
+/*
+ * The format instantiaion can have features wired off or on to optimize the
+ * code gen. Supported features are just a reflection of what the current set of
+ * kernel users want to use.
+ */
+#ifndef PT_SUPPORTED_FEATURES
+#define PT_SUPPORTED_FEATURES 0
+#endif
+
+#ifndef PT_FORCE_ENABLED_FEATURES
+#define PT_FORCE_ENABLED_FEATURES 0
+#endif
+
+#define PT_GRANUAL_SIZE (1 << PT_GRANUAL_LG2SZ)
+
+/*
+ * Language used in Generic Page Table
+ *  va: The input address to the page table
+ *  oa: The output address from the page table.
+ *  leaf: A entry that results in an output address. Ie a page pointer
+ *  start/end: An open range, eg [0,0) refers to no VA
+ *  start/last: An inclusive closed range, eg [0,0] refers to the VA 0
+ *  common: The generic page table container struct pt_common
+ *  level: The number of table hops from the lowest leaf. Level 0
+ *         is always a table of only leaves of the least significant VA bits
+ *  top_level: The inclusive highest level of the table. A two level table
+ *             has a top level of 1.
+ *  table: A linear array of entries representing the translation for that
+ *         level.
+ *  entry: A single element in a table
+ *  index: The position in a table of an element: entry = table[index]
+ *  entry_size: The number of bytes of VA the entry translates for.
+ *              If the entry is a table entry then the next table covers
+ *              this size. If the entry is an output address then the
+ *              full OA is: OA | (VA % entry_size)
+ *  contig_count: The number of consecutive entries fused into a single OA.
+ *                entry_size * contig_count is the size of that translation.
+ *                This is often called contiguous pages
+ *  lg2: Indicates the value is encoded as log2, ie 1<<x is the actual value.
+ *       Normally the compiler is fine to optimize divide and mod with log2
+ *       values automatically when inlining, however if the values are not
+ *       constant expressions it can't. So we do it by hand, we want to avoid
+ *       64 bit divmod.
+ */
+
+/* Returned by pt_load_entry() and for_each_pt_level_item() */
+enum pt_entry_type {
+	PT_ENTRY_EMPTY,
+	PT_ENTRY_TABLE,
+	/* Entry is valid and returns an output address */
+	PT_ENTRY_OA,
+};
+
+struct pt_range {
+	struct pt_common *common;
+	struct pt_table_p *top_table;
+	pt_vaddr_t va;
+	pt_vaddr_t last_va;
+	u8 top_level;
+	u8 max_vasz_lg2;
+};
+
+/*
+ * Similar to xa_state, this records information about an in progress parse at a
+ * single level.
+ */
+struct pt_state {
+	struct pt_range *range;
+	struct pt_table_p *table;
+	struct pt_table_p *table_lower;
+	u64 entry;
+	enum pt_entry_type type;
+	unsigned short index;
+	unsigned short end_index;
+	u8 level;
+};
+
+/*
+ * Try to install a new table pointer. The locking methodology requires this to
+ * be atomic, multiple threads can race to install a pointer, the losing
+ * threads will fail the atomic and return false. They should free any memory
+ * and reparse the table level again.
+ */
+#if !IS_ENABLED(CONFIG_GENERIC_ATOMIC64)
+static inline bool pt_table_install64(u64 *entryp, u64 table_entry,
+				      u64 old_entry)
+{
+
+	/*
+	 * Ensure the zero'd table content itself is visible before its PTE can
+	 * be, be careful about !SMP
+	 */
+	if (!IS_ENABLED(CONFIG_SMP))
+		dma_wmb();
+	return try_cmpxchg64_release(entryp, &old_entry, table_entry);
+}
+#endif
+
+static inline bool pt_table_install32(u32 *entryp, u32 table_entry,
+				      u32 old_entry)
+{
+	/*
+	 * Ensure the zero'd table content itself is visible before its PTE can
+	 * be, be careful about !SMP
+	 */
+	if (!IS_ENABLED(CONFIG_SMP))
+		dma_wmb();
+	return try_cmpxchg_release(entryp, &old_entry, table_entry);
+}
+
+#define PT_SUPPORTED_FEATURE(feature_nr) (PT_SUPPORTED_FEATURES & BIT(feature_nr))
+
+static inline bool pt_feature(const struct pt_common *common,
+			      unsigned int feature_nr)
+{
+	if (PT_FORCE_ENABLED_FEATURES & BIT(feature_nr))
+		return true;
+	if (!PT_SUPPORTED_FEATURE(feature_nr))
+		return false;
+	return common->features & BIT(feature_nr);
+}
+
+static inline bool pts_feature(const struct pt_state *pts,
+			       unsigned int feature_nr)
+{
+	return pt_feature(pts->range->common, feature_nr);
+}
+
+/*
+ * PT_WARN_ON is used for invariants that the kunit should be checking can't
+ * happen.
+ */
+#if IS_ENABLED(CONFIG_DEBUG_GENERIC_PT)
+#define PT_WARN_ON WARN_ON
+#else
+static inline bool PT_WARN_ON(bool condition)
+{
+	return false;
+}
+#endif
+
+/* These all work on the VA type */
+#define log2_to_int(a_lg2) log2_to_int_t(pt_vaddr_t, a_lg2)
+#define log2_to_max_int(a_lg2) log2_to_max_int_t(pt_vaddr_t, a_lg2)
+#define log2_div(a, b_lg2) log2_div_t(pt_vaddr_t, a, b_lg2)
+#define log2_div_eq(a, b, c_lg2) log2_div_eq_t(pt_vaddr_t, a, b, c_lg2)
+#define log2_mod(a, b_lg2) log2_mod_t(pt_vaddr_t, a, b_lg2)
+#define log2_mod_eq_max(a, b_lg2) log2_mod_eq_max_t(pt_vaddr_t, a, b_lg2)
+#define log2_set_mod(a, val, b_lg2) log2_set_mod_t(pt_vaddr_t, a, val, b_lg2)
+#define log2_set_mod_max(a, b_lg2) log2_set_mod_max_t(pt_vaddr_t, a, b_lg2)
+#define log2_mul(a, b_lg2) log2_mul_t(pt_vaddr_t, a, b_lg2)
+#define log2_ffs(a) log2_ffs_t(pt_vaddr_t, a)
+#define log2_fls(a) log2_fls_t(pt_vaddr_t, a)
+#define log2_ffz(a) log2_ffz_t(pt_vaddr_t, a)
+
+/*
+ * The full va (fva) versions permit the lg2 value to be == PT_VADDR_MAX_LG2 and
+ * generate a useful defined result. The non fva versions will malfunction at
+ * this extreme.
+ */
+static inline pt_vaddr_t fvalog2_div(pt_vaddr_t a, unsigned int b_lg2)
+{
+	if (PT_SUPPORTED_FEATURE(PT_FEAT_FULL_VA) && b_lg2 == PT_VADDR_MAX_LG2)
+		return 0;
+	return log2_div_t(pt_vaddr_t, a, b_lg2);
+}
+
+static inline bool fvalog2_div_eq(pt_vaddr_t a, pt_vaddr_t b,
+				  unsigned int c_lg2)
+{
+	if (PT_SUPPORTED_FEATURE(PT_FEAT_FULL_VA) && c_lg2 == PT_VADDR_MAX_LG2)
+		return true;
+	return log2_div_eq_t(pt_vaddr_t, a, b, c_lg2);
+}
+
+static inline pt_vaddr_t fvalog2_set_mod(pt_vaddr_t a, pt_vaddr_t val,
+					 unsigned int b_lg2)
+{
+	if (PT_SUPPORTED_FEATURE(PT_FEAT_FULL_VA) && b_lg2 == PT_VADDR_MAX_LG2)
+		return val;
+	return log2_set_mod_t(pt_vaddr_t, a, val, b_lg2);
+}
+
+static inline pt_vaddr_t fvalog2_set_mod_max(pt_vaddr_t a, unsigned int b_lg2)
+{
+	if (PT_SUPPORTED_FEATURE(PT_FEAT_FULL_VA) && b_lg2 == PT_VADDR_MAX_LG2)
+		return PT_VADDR_MAX;
+	return log2_set_mod_max_t(pt_vaddr_t, a, b_lg2);
+}
+
+/* These all work on the OA type */
+#define oalog2_to_int(a_lg2) log2_to_int_t(pt_oaddr_t, a_lg2)
+#define oalog2_to_max_int(a_lg2) log2_to_max_int_t(pt_oaddr_t, a_lg2)
+#define oalog2_div(a, b_lg2) log2_div_t(pt_oaddr_t, a, b_lg2)
+#define oalog2_div_eq(a, b, c_lg2) log2_div_eq_t(pt_oaddr_t, a, b, c_lg2)
+#define oalog2_mod(a, b_lg2) log2_mod_t(pt_oaddr_t, a, b_lg2)
+#define oalog2_mod_eq_max(a, b_lg2) log2_mod_eq_max_t(pt_oaddr_t, a, b_lg2)
+#define oalog2_set_mod(a, val, b_lg2) log2_set_mod_t(pt_oaddr_t, a, val, b_lg2)
+#define oalog2_set_mod_max(a, b_lg2) log2_set_mod_max_t(pt_oaddr_t, a, b_lg2)
+#define oalog2_mul(a, b_lg2) log2_mul_t(pt_oaddr_t, a, b_lg2)
+#define oalog2_ffs(a) log2_ffs_t(pt_oaddr_t, a)
+#define oalog2_fls(a) log2_fls_t(pt_oaddr_t, a)
+#define oalog2_ffz(a) log2_ffz_t(pt_oaddr_t, a)
+
+#define pt_cur_table(pts, type) ((type *)((pts)->table))
+
+static inline uintptr_t _pt_top_set(struct pt_table_p *table_mem,
+				    unsigned int top_level)
+{
+	return top_level | (uintptr_t)table_mem;
+}
+
+static inline void pt_top_set(struct pt_common *common,
+			      struct pt_table_p *table_mem,
+			      unsigned int top_level)
+{
+	WRITE_ONCE(common->top_of_table, _pt_top_set(table_mem, top_level));
+}
+
+static inline void pt_top_set_level(struct pt_common *common,
+				    unsigned int top_level)
+{
+	pt_top_set(common, NULL, top_level);
+}
+
+static inline unsigned int pt_top_get_level(const struct pt_common *common)
+{
+	return READ_ONCE(common->top_of_table) % (1 << PT_TOP_LEVEL_BITS);
+}
+
+#endif
diff --git a/drivers/iommu/generic_pt/pt_fmt_defaults.h b/drivers/iommu/generic_pt/pt_fmt_defaults.h
new file mode 100644
index 00000000000000..4532a1146c5eca
--- /dev/null
+++ b/drivers/iommu/generic_pt/pt_fmt_defaults.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Default definitions for formats that don't define these functions.
+ */
+#ifndef __GENERIC_PT_PT_FMT_DEFAULTS_H
+#define __GENERIC_PT_PT_FMT_DEFAULTS_H
+
+#include "pt_defs.h"
+#include <linux/log2.h>
+
+/* Header self-compile default defines */
+#ifndef pt_load_entry_raw
+#include "fmt/amdv1.h"
+#endif
+
+/* If not supplied by the format then contiguous pages are not supported */
+#ifndef pt_entry_num_contig_lg2
+static inline unsigned int pt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	return ilog2(1);
+}
+
+static inline unsigned short pt_contig_count_lg2(const struct pt_state *pts)
+{
+	return ilog2(1);
+}
+#endif
+
+/* If not supplied by the format then dirty tracking is not supported */
+#ifndef pt_entry_write_is_dirty
+static inline bool pt_entry_write_is_dirty(const struct pt_state *pts)
+{
+	return false;
+}
+
+static inline void pt_entry_set_write_clean(struct pt_state *pts)
+{
+}
+#endif
+
+/*
+ * Format supplies either:
+ *   pt_entry_oa - OA is at the start of a contiguous entry
+ * or
+ *   pt_item_oa  - OA is correct for every item in a contiguous entry
+ *
+ * Build the missing one
+ */
+#ifdef pt_entry_oa
+static inline pt_oaddr_t pt_item_oa(const struct pt_state *pts)
+{
+	return pt_entry_oa(pts) |
+	       log2_mul(pts->index, pt_table_item_lg2sz(pts));
+}
+#define _pt_entry_oa_fast pt_entry_oa
+#endif
+
+#ifdef pt_item_oa
+static inline pt_oaddr_t pt_entry_oa(const struct pt_state *pts)
+{
+	return log2_set_mod(pt_item_oa(pts), 0,
+			    pt_entry_num_contig_lg2(pts) +
+				    pt_table_item_lg2sz(pts));
+}
+#define _pt_entry_oa_fast pt_item_oa
+#endif
+
+/*
+ * If not supplied by the format then use the constant
+ * PT_MAX_OUTPUT_ADDRESS_LG2.
+ */
+#ifndef pt_max_output_address_lg2
+static inline unsigned int
+pt_max_output_address_lg2(const struct pt_common *common)
+{
+	return PT_MAX_OUTPUT_ADDRESS_LG2;
+}
+#endif
+
+/*
+ * If not supplied by the format then assume only one contiguous size determined
+ * by pt_contig_count_lg2()
+ */
+#ifndef pt_possible_sizes
+static inline unsigned short pt_contig_count_lg2(const struct pt_state *pts);
+
+/* Return a bitmap of possible leaf page sizes at this level */
+static inline pt_vaddr_t pt_possible_sizes(const struct pt_state *pts)
+{
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+
+	if (!pt_can_have_leaf(pts))
+		return 0;
+	return log2_to_int(isz_lg2) |
+	       log2_to_int(pt_contig_count_lg2(pts) + isz_lg2);
+}
+#endif
+
+/* If not supplied by the format then use 0. */
+#ifndef pt_full_va_prefix
+static inline pt_vaddr_t pt_full_va_prefix(const struct pt_common *common)
+{
+	return 0;
+}
+#endif
+
+#endif
diff --git a/drivers/iommu/generic_pt/pt_iter.h b/drivers/iommu/generic_pt/pt_iter.h
new file mode 100644
index 00000000000000..a36dade62a6f32
--- /dev/null
+++ b/drivers/iommu/generic_pt/pt_iter.h
@@ -0,0 +1,468 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Iterators for Generic Page Table
+ */
+#ifndef __GENERIC_PT_PT_ITER_H
+#define __GENERIC_PT_PT_ITER_H
+
+#include "pt_common.h"
+
+#include <linux/errno.h>
+
+/*
+ * Use to mangle symbols so that backtraces and the symbol table are
+ * understandable. Any non-inlined function should get mangled like this.
+ */
+#define NS(fn) CONCATENATE(PTPFX, fn)
+
+/*
+ * With range->va being the start, set range->last_va and validate that the
+ * range is within the allowed
+ */
+static inline int pt_check_range(struct pt_range *range)
+{
+	pt_vaddr_t prefix = pt_full_va_prefix(range->common);
+
+	PT_WARN_ON(!range->max_vasz_lg2);
+
+	if (!fvalog2_div_eq(range->va, prefix, range->max_vasz_lg2) ||
+	    !fvalog2_div_eq(range->last_va, prefix, range->max_vasz_lg2))
+		return -ERANGE;
+	return 0;
+}
+
+/*
+ * Adjust the va to match the current index.
+ */
+static inline void pt_index_to_va(struct pt_state *pts)
+{
+	unsigned int table_lg2sz = pt_table_oa_lg2sz(pts);
+	pt_vaddr_t lower_va;
+
+	lower_va = log2_mul(pts->index, pt_table_item_lg2sz(pts));
+	pts->range->va = fvalog2_set_mod(pts->range->va, lower_va, table_lg2sz);
+}
+
+/*
+ * Add index_count_lg2 number of entries to pts's VA and index. The va will be
+ * adjusted to the end of the contiguous block if it is currently in the middle.
+ */
+static inline void _pt_advance(struct pt_state *pts,
+			       unsigned int index_count_lg2)
+{
+	pts->index = log2_set_mod(pts->index + log2_to_int(index_count_lg2), 0,
+				  index_count_lg2);
+	pt_index_to_va(pts);
+}
+
+/* True if the current entry is fully enclosed by the range of va to last_va. */
+static inline bool pt_entry_fully_covered(const struct pt_state *pts,
+					  unsigned int oasz_lg2)
+{
+	struct pt_range *range = pts->range;
+
+	/* Range begins at the start of the entry */
+	if (log2_mod(pts->range->va, oasz_lg2))
+		return false;
+
+	/* Range ends past the end of the entry */
+	if (!log2_div_eq(range->va, range->last_va, oasz_lg2))
+		return true;
+
+	/* Range ends at the end of the entry */
+	return log2_mod_eq_max(range->last_va, oasz_lg2);
+}
+
+static inline unsigned int pt_range_to_index(struct pt_state *pts)
+{
+	unsigned int num_entries_lg2 = pt_num_items_lg2(pts);
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+
+	if (pts->range->top_level == pts->level)
+		return log2_div(pts->range->va, isz_lg2);
+	return log2_mod(log2_div(pts->range->va, isz_lg2), num_entries_lg2);
+}
+
+static inline void _pt_iter_first(struct pt_state *pts)
+{
+	unsigned int num_entries_lg2 = pt_num_items_lg2(pts);
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	struct pt_range *range = pts->range;
+
+	pts->index = pt_range_to_index(pts);
+	if (range->va == range->last_va) {
+		pts->end_index = pts->index + 1;
+		return;
+	}
+
+	/* last_va falls within this table */
+	if (pts->range->top_level == pts->level ||
+	    log2_div_eq(range->va, range->last_va, num_entries_lg2 + isz_lg2)) {
+		pts->end_index = log2_mod(log2_div(range->last_va, isz_lg2),
+					  num_entries_lg2) +
+				 1;
+		return;
+	}
+	pts->end_index = log2_to_int(num_entries_lg2);
+}
+
+static inline bool _pt_iter_load(struct pt_state *pts)
+{
+	if (pts->index == pts->end_index)
+		return false;
+	pt_load_entry(pts);
+	return true;
+}
+
+/* Update pts to go to the next index at this level */
+static inline void pt_next_entry(struct pt_state *pts)
+{
+	if (pts->type == PT_ENTRY_OA)
+		_pt_advance(pts, pt_entry_num_contig_lg2(pts));
+	else
+		_pt_advance(pts, ilog2(1));
+}
+
+#define for_each_pt_level_item(pts) \
+	for (_pt_iter_first(pts); _pt_iter_load(pts); pt_next_entry(pts))
+
+/* Version of pt_load_entry() usable within a walker */
+static inline enum pt_entry_type pt_load_single_entry(struct pt_state *pts)
+{
+	pts->index = pt_range_to_index(pts);
+	pt_load_entry(pts);
+	return pts->type;
+}
+
+static __always_inline struct pt_range _pt_top_range(struct pt_common *common,
+						     uintptr_t top_of_table)
+{
+	struct pt_range range = {
+		.common = common,
+		.top_table =
+			(struct pt_table_p *)(top_of_table &
+					      ~(uintptr_t)PT_TOP_LEVEL_MASK),
+#ifdef PT_FIXED_TOP_LEVEL
+		.top_level = PT_FIXED_TOP_LEVEL,
+#else
+		.top_level = top_of_table % (1 << PT_TOP_LEVEL_BITS),
+#endif
+	};
+	struct pt_state pts = { .range = &range, .level = range.top_level };
+
+	range.max_vasz_lg2 =
+		min_t(unsigned int, common->max_vasz_lg2,
+		      pt_num_items_lg2(&pts) + pt_table_item_lg2sz(&pts));
+	range.va = fvalog2_set_mod(pt_full_va_prefix(common), 0,
+				   range.max_vasz_lg2);
+	range.last_va = fvalog2_set_mod_max(pt_full_va_prefix(common),
+					    range.max_vasz_lg2);
+	return range;
+}
+
+/* Span the whole table */
+static __always_inline struct pt_range pt_top_range(struct pt_common *common)
+{
+	/*
+	 * The top pointer can change without locking. We capture the value and
+	 * it's level here and are safe to walk it so long as both values are
+	 * captured without tearing.
+	 */
+	return _pt_top_range(common, READ_ONCE(common->top_of_table));
+}
+
+/* Span a slice of the table starting at the top */
+static __always_inline struct pt_range
+pt_make_range(struct pt_common *common, pt_vaddr_t va, pt_vaddr_t last_va)
+{
+	struct pt_range range =
+		_pt_top_range(common, READ_ONCE(common->top_of_table));
+
+	range.va = va;
+	range.last_va = last_va;
+	return range;
+}
+
+/*
+ * Span a slice of the table starting at a lower table level from an active
+ * walk.
+ */
+static __always_inline struct pt_range
+pt_make_child_range(const struct pt_range *parent, pt_vaddr_t va,
+		    pt_vaddr_t last_va)
+{
+	struct pt_range range = *parent;
+
+	range.va = va;
+	range.last_va = last_va;
+
+	PT_WARN_ON(last_va < va);
+	PT_WARN_ON(pt_check_range(&range));
+
+	return range;
+}
+
+static __always_inline struct pt_state
+pt_init(struct pt_range *range, unsigned int level, struct pt_table_p *table)
+{
+	struct pt_state pts = {
+		.range = range,
+		.table = table,
+		.level = level,
+	};
+	return pts;
+}
+
+static __always_inline struct pt_state pt_init_top(struct pt_range *range)
+{
+	return pt_init(range, range->top_level, range->top_table);
+}
+
+typedef int (*pt_level_fn_t)(struct pt_range *range, void *arg,
+			     unsigned int level, struct pt_table_p *table);
+
+static __always_inline int pt_descend(struct pt_state *pts, void *arg,
+				      pt_level_fn_t fn)
+{
+	int ret;
+
+	if (PT_WARN_ON(!pts->table_lower))
+		return -EINVAL;
+
+	ret = (*fn)(pts->range, arg, pts->level - 1, pts->table_lower);
+	return ret;
+}
+
+/*
+ * Walk over an IOVA range. The caller should have done a validity check, at
+ * least calling pt_check_range(), when building range.
+ */
+static __always_inline int pt_walk_range(struct pt_range *range,
+					 pt_level_fn_t fn, void *arg)
+{
+	return fn(range, arg, range->top_level, range->top_table);
+}
+
+/*
+ * With parent_pts pointing at a table this will prepare to walk over a slice of
+ * the child table of the current entry.
+ */
+static __always_inline int
+pt_walk_child_range(const struct pt_state *parent_pts, pt_vaddr_t va,
+		    pt_vaddr_t last_va, pt_level_fn_t fn, void *arg)
+{
+	struct pt_range range =
+		pt_make_child_range(parent_pts->range, va, last_va);
+
+	if (PT_WARN_ON(!pt_can_have_table(parent_pts)) ||
+	    PT_WARN_ON(!parent_pts->table_lower))
+		return -EINVAL;
+
+	return fn(&range, arg, parent_pts->level - 1, parent_pts->table_lower);
+}
+
+/*
+ * With parent_pts pointing at a table this will prepare to walk over the entire
+ * the child table
+ */
+static __always_inline int pt_walk_child_all(const struct pt_state *parent_pts,
+					     pt_level_fn_t fn, void *arg)
+{
+	unsigned int isz_lg2 = pt_table_item_lg2sz(parent_pts);
+
+	return pt_walk_child_range(
+		parent_pts, log2_set_mod(parent_pts->range->va, 0, isz_lg2),
+		log2_set_mod_max(parent_pts->range->va, isz_lg2), fn, arg);
+}
+
+/* Create a range than spans an index range of the current pt_state */
+static inline struct pt_range pt_range_slice(const struct pt_state *pts,
+					     unsigned int start_index,
+					     unsigned int end_index)
+{
+	unsigned int table_lg2sz = pt_table_oa_lg2sz(pts);
+	pt_vaddr_t last_va;
+	pt_vaddr_t va;
+
+	va = fvalog2_set_mod(pts->range->va,
+			     log2_mul(start_index, pt_table_item_lg2sz(pts)),
+			     table_lg2sz);
+	last_va = fvalog2_set_mod(
+		pts->range->va,
+		log2_mul(end_index, pt_table_item_lg2sz(pts)) - 1, table_lg2sz);
+	return pt_make_child_range(pts->range, va, last_va);
+}
+
+/*
+ * Compute the size of the top table. For PT_FEAT_DYNAMIC_TOP this will compute
+ * the top size assuming the table will grow.
+ */
+static inline unsigned int pt_top_memsize_lg2(struct pt_common *common,
+					      uintptr_t top_of_table)
+{
+	struct pt_range range = _pt_top_range(common, top_of_table);
+	struct pt_state pts = pt_init_top(&range);
+	unsigned int num_items_lg2;
+
+	num_items_lg2 = common->max_vasz_lg2 - pt_table_item_lg2sz(&pts);
+	if (range.top_level != PT_MAX_TOP_LEVEL &&
+	    pt_feature(common, PT_FEAT_DYNAMIC_TOP))
+		num_items_lg2 = min(num_items_lg2, pt_num_items_lg2(&pts));
+
+	return num_items_lg2 + ilog2(PT_ENTRY_WORD_SIZE);
+}
+
+static inline unsigned int __pt_compute_best_pgsize(pt_vaddr_t pgsz_bitmap,
+						    pt_vaddr_t va,
+						    pt_vaddr_t last_va,
+						    pt_oaddr_t oa)
+{
+	unsigned int best_pgsz_lg2;
+	unsigned int pgsz_lg2;
+	pt_vaddr_t len = last_va - va + 1;
+	pt_vaddr_t mask;
+
+	if (PT_WARN_ON(va >= last_va))
+		return 0;
+
+	/*
+	 * Given a VA/OA pair the best page size is the largest page side
+	 * where:
+	 *
+	 * 1) VA and OA start at the page. Bitwise this is the count of least
+	 *    significant 0 bits.
+	 *    This also implies that last_va/oa has the same prefix as va/oa.
+	 */
+	mask = va | oa;
+
+	/*
+	 * 2) The page size is not larger than the last_va (length). Since page
+	 *    sizes are always power of two this can't be larger than the
+	 *    largest power of two factor of the length.
+	 */
+	mask |= log2_to_int(log2_fls(len) - 1);
+
+	best_pgsz_lg2 = log2_ffs(mask);
+
+	/* Choose the higest bit <= best_pgsz_lg2 */
+	if (best_pgsz_lg2 < PT_VADDR_MAX_LG2 - 1)
+		pgsz_bitmap = log2_mod(pgsz_bitmap, best_pgsz_lg2 + 1);
+
+	pgsz_lg2 = log2_fls(pgsz_bitmap);
+	if (!pgsz_lg2)
+		return 0;
+
+	pgsz_lg2--;
+
+	PT_WARN_ON(log2_mod(va, pgsz_lg2) != 0);
+	PT_WARN_ON(oalog2_mod(oa, pgsz_lg2) != 0);
+	PT_WARN_ON(va + log2_to_int(pgsz_lg2) - 1 > last_va);
+	PT_WARN_ON(!log2_div_eq(va, va + log2_to_int(pgsz_lg2) - 1, pgsz_lg2));
+	PT_WARN_ON(
+		!oalog2_div_eq(oa, oa + log2_to_int(pgsz_lg2) - 1, pgsz_lg2));
+	return pgsz_lg2;
+}
+
+/*
+ * Compute the largest page size for va, last_va, and pa together and return it
+ * in lg2.
+ */
+static inline unsigned int pt_compute_best_pgsize(struct pt_state *pts,
+						  pt_oaddr_t oa)
+{
+	return __pt_compute_best_pgsize(pt_possible_sizes(pts), pts->range->va,
+					pts->range->last_va, oa);
+}
+
+#define _PT_MAKE_CALL_LEVEL2(fn)                                             \
+	static __always_inline int fn(struct pt_range *range, void *arg,     \
+				      unsigned int level,                    \
+				      struct pt_table_p *table)              \
+	{                                                                    \
+		switch (level) {                                             \
+		case 0:                                                      \
+			return CONCATENATE(fn, 0)(range, arg, level, table); \
+		case 1:                                                      \
+			if (1 > PT_MAX_TOP_LEVEL)                            \
+				break;                                       \
+			return CONCATENATE(fn, 1)(range, arg, level, table); \
+		case 2:                                                      \
+			if (2 > PT_MAX_TOP_LEVEL)                            \
+				break;                                       \
+			return CONCATENATE(fn, 2)(range, arg, level, table); \
+		case 3:                                                      \
+			if (3 > PT_MAX_TOP_LEVEL)                            \
+				break;                                       \
+			return CONCATENATE(fn, 3)(range, arg, level, table); \
+		case 4:                                                      \
+			if (4 > PT_MAX_TOP_LEVEL)                            \
+				break;                                       \
+			return CONCATENATE(fn, 4)(range, arg, level, table); \
+		default:                                                     \
+			break;                                               \
+		}                                                            \
+		return -EPROTOTYPE;                                          \
+	}
+
+#define _PT_MAKE_CALL_LEVEL(fn)                                          \
+	static __always_inline int fn(struct pt_range *range, void *arg, \
+				      unsigned int level,                \
+				      struct pt_table_p *table)          \
+	{                                                                \
+		static_assert(PT_MAX_TOP_LEVEL <= 5);                    \
+		if (level == 0)                                          \
+			return CONCATENATE(fn, 0)(range, arg, 0, table); \
+		if (level == 1 || PT_MAX_TOP_LEVEL == 1)                 \
+			return CONCATENATE(fn, 1)(range, arg, 1, table); \
+		if (level == 2 || PT_MAX_TOP_LEVEL == 2)                 \
+			return CONCATENATE(fn, 2)(range, arg, 2, table); \
+		if (level == 3 || PT_MAX_TOP_LEVEL == 3)                 \
+			return CONCATENATE(fn, 3)(range, arg, 3, table); \
+		if (level == 4 || PT_MAX_TOP_LEVEL == 4)                 \
+			return CONCATENATE(fn, 4)(range, arg, 4, table); \
+		return CONCATENATE(fn, 5)(range, arg, 5, table);         \
+	}
+
+static inline int __pt_make_level_fn_err(struct pt_range *range, void *arg,
+					 unsigned int unused_level,
+					 struct pt_table_p *table)
+{
+	static_assert(PT_MAX_TOP_LEVEL <= 5);
+	return -EPROTOTYPE;
+}
+
+#define __PT_MAKE_LEVEL_FN(fn, level, descend_fn, do_fn)            \
+	static inline int fn(struct pt_range *range, void *arg,     \
+			     unsigned int unused_level,             \
+			     struct pt_table_p *table)              \
+	{                                                           \
+		return do_fn(range, arg, level, table, descend_fn); \
+	}
+
+/*
+ * This builds a function call tree that can be fully inlined,
+ * The caller must provide a function body in an __always_inline function:
+ * static __always_inline int do(struct pt_range *range, void *arg,
+ *         unsigned int level, struct pt_table_p *table,
+ *         pt_level_fn_t descend_fn)
+ *
+ * An inline function will be created for each table level that calls do with a
+ * compile time constant for level and a pointer to the next lower function.
+ * This generates an optimally inlined walk where each of the functions sees a
+ * constant level and can codegen the exact constants/etc for that level.
+ *
+ * Note this can produce a lot of code!
+ */
+#define PT_MAKE_LEVELS(fn, do_fn)                                             \
+	__PT_MAKE_LEVEL_FN(CONCATENATE(fn, 0), 0, __pt_make_level_fn_err,     \
+			   do_fn);                                            \
+	__PT_MAKE_LEVEL_FN(CONCATENATE(fn, 1), 1, CONCATENATE(fn, 0), do_fn); \
+	__PT_MAKE_LEVEL_FN(CONCATENATE(fn, 2), 2, CONCATENATE(fn, 1), do_fn); \
+	__PT_MAKE_LEVEL_FN(CONCATENATE(fn, 3), 3, CONCATENATE(fn, 2), do_fn); \
+	__PT_MAKE_LEVEL_FN(CONCATENATE(fn, 4), 4, CONCATENATE(fn, 3), do_fn); \
+	__PT_MAKE_LEVEL_FN(CONCATENATE(fn, 5), 5, CONCATENATE(fn, 4), do_fn); \
+	_PT_MAKE_CALL_LEVEL(fn)
+
+#endif
diff --git a/drivers/iommu/generic_pt/pt_log2.h b/drivers/iommu/generic_pt/pt_log2.h
new file mode 100644
index 00000000000000..8eb966e31c3afd
--- /dev/null
+++ b/drivers/iommu/generic_pt/pt_log2.h
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ *
+ * Helper macros for working with log2 values
+ *
+ */
+#ifndef __GENERIC_PT_LOG2_H
+#define __GENERIC_PT_LOG2_H
+#include <linux/build_bug.h>
+#include <linux/bitops.h>
+#include <linux/limits.h>
+
+/* Compute a */
+#define log2_to_int_t(type, a_lg2) ((type)(((type)1) << (a_lg2)))
+static_assert(log2_to_int_t(unsigned int, 0) == 1);
+
+/* Compute a - 1 (aka all low bits set) */
+#define log2_to_max_int_t(type, a_lg2) ((type)(log2_to_int_t(type, a_lg2) - 1))
+
+/* Compute a / b */
+#define log2_div_t(type, a, b_lg2) ((type)(((type)a) >> (b_lg2)))
+static_assert(log2_div_t(unsigned int, 4, 2) == 1);
+
+/*
+ * Compute:
+ *   a / c == b / c
+ * aka the high bits are equal
+ */
+#define log2_div_eq_t(type, a, b, c_lg2) \
+	(log2_div_t(type, (a) ^ (b), c_lg2) == 0)
+static_assert(log2_div_eq_t(unsigned int, 1, 1, 2));
+
+/* Compute a % b */
+#define log2_mod_t(type, a, b_lg2) \
+	((type)(((type)a) & log2_to_max_int_t(type, b_lg2)))
+static_assert(log2_mod_t(unsigned int, 1, 2) == 1);
+
+/*
+ * Compute:
+ *   a % b == b - 1
+ * aka the low bits are all 1s
+ */
+#define log2_mod_eq_max_t(type, a, b_lg2) \
+	(log2_mod_t(type, a, b_lg2) == log2_to_max_int_t(type, b_lg2))
+static_assert(log2_mod_eq_max_t(unsigned int, 3, 2));
+
+/*
+ * Return a value such that:
+ *    a / b == ret / b
+ *    ret % b == val
+ * aka set the low bits to val. val must be < b
+ */
+#define log2_set_mod_t(type, a, val, b_lg2) \
+	((((type)(a)) & (~log2_to_max_int_t(type, b_lg2))) | ((type)(val)))
+static_assert(log2_set_mod_t(unsigned int, 3, 1, 2) == 1);
+
+/* Return a value such that:
+ *    a / b == ret / b
+ *    ret % b == b - 1
+ * aka set the low bits to all 1s
+ */
+#define log2_set_mod_max_t(type, a, b_lg2) \
+	(((type)(a)) | log2_to_max_int_t(type, b_lg2))
+static_assert(log2_set_mod_max_t(unsigned int, 2, 2) == 3);
+
+/* Compute a * b */
+#define log2_mul_t(type, a, b_lg2) ((type)(((type)a) << (b_lg2)))
+static_assert(log2_mul_t(unsigned int, 2, 2) == 8);
+
+#define _dispatch_sz(type, fn, a) \
+	(sizeof(type) == 4 ? fn##32((u32)a) : fn##64(a))
+
+/*
+ * Return the highest value such that:
+ *    log2_fls(0) == 0
+ *    log2_fls(1) == 1
+ *    a >= log2_to_int(ret - 1)
+ * aka find last set bit
+ */
+static inline unsigned int log2_fls32(u32 a)
+{
+	return fls(a);
+}
+static inline unsigned int log2_fls64(u64 a)
+{
+	return fls64(a);
+}
+#define log2_fls_t(type, a) _dispatch_sz(type, log2_fls, a)
+
+/*
+ * Return the highest value such that:
+ *    log2_ffs(0) == UNDEFINED
+ *    log2_ffs(1) == 0
+ *    log_mod(a, ret) == 0
+ * aka find first set bit
+ */
+static inline unsigned int log2_ffs32(u32 a)
+{
+	return __ffs(a);
+}
+static inline unsigned int log2_ffs64(u64 a)
+{
+	return __ffs64(a);
+}
+#define log2_ffs_t(type, a) _dispatch_sz(type, log2_ffs, a)
+
+/*
+ * Return the highest value such that:
+ *    log2_ffz(MAX) == UNDEFINED
+ *    log2_ffz(0) == 0
+ *    log2_ffz(1) == 1
+ *    log_mod(a, ret) == log_to_max_int(ret)
+ * aka find first zero bit
+ */
+static inline unsigned int log2_ffz32(u32 a)
+{
+	return ffz(a);
+}
+static inline unsigned int log2_ffz64(u64 a)
+{
+	if (sizeof(u64) == sizeof(unsigned long))
+		return ffz(a);
+
+	if ((u32)a == U32_MAX)
+		return log2_ffz32(a >> 32) + 32;
+	return log2_ffz32(a);
+}
+#define log2_ffz_t(type, a) _dispatch_sz(type, log2_ffz, a)
+
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
new file mode 100644
index 00000000000000..6a865dbf075192
--- /dev/null
+++ b/include/linux/generic_pt/common.h
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024, NVIDIA CORPORATION & AFFILIATES
+ */
+#ifndef __GENERIC_PT_COMMON_H
+#define __GENERIC_PT_COMMON_H
+
+#include <linux/types.h>
+#include <linux/build_bug.h>
+#include <linux/bits.h>
+
+struct pt_table_p;
+
+/**
+ * DOC: Generic Radix Page Table
+ *
+ * Generic Radix Page Table is a set of functions and helpers to efficiently
+ * parse radix style page tables typically seen in HW implementations. The
+ * interface is built to deliver similar code generation as the mm's pte/pmd/etc
+ * system by fully inlining the exact code required to handle each level.
+ *
+ * Like the MM each format contributes its parsing implementation under common
+ * names and the common code implements an algorithm.
+ *
+ * The system is divided into three logical levels:
+ *  - The page table format and its accessors
+ *  - Generic helpers to make
+ *  - An implementation (eg IOMMU/DRM/KVM/MM)
+ *
+ * Multiple implementations are supported, the intention is to have the generic
+ * format code be re-usable for whatever specalized implementation is required.
+ */
+struct pt_common {
+	/**
+	 * @top_of_table: Encodes the table top pointer and the top level in a
+	 * single value. Must use READ_ONCE/WRITE_ONCE to access it. The lower
+	 * bits of the aligned table pointer are used for the level.
+	 */
+	uintptr_t top_of_table;
+	/**
+	 * @oasz_lg2: Maximum number of bits the OA can contain. Upper bits must
+	 * be zero. This may be less than what the page table format supports,
+	 * but must not be more. It reflects the active HW capability.
+	 */
+	u8 max_oasz_lg2;
+	/**
+	 * @vasz_lg2: Maximum number of bits the VA can contain. Upper bits are
+	 * 0 or 1 depending on PT_FEAT_TOP_DOWN. This may be less than what the
+	 * page table format supports, but must not be more. When
+	 * PT_FEAT_DYNAMIC_TOP this reflects the maximum VA capability, not the
+	 * current maximum VA size for the current top level.
+	 */
+	u8 max_vasz_lg2;
+	unsigned int features;
+};
+
+enum {
+	PT_TOP_LEVEL_BITS = 3,
+	PT_TOP_LEVEL_MASK = GENMASK(PT_TOP_LEVEL_BITS - 1, 0),
+};
+
+enum {
+	/*
+	 * Cache flush page table memory before assuming the HW can read it.
+	 * Otherwise a SMP release is sufficient for HW to read it.
+	 */
+	PT_FEAT_DMA_INCOHERENT,
+	/*
+	 * An OA entry can change size while still present. For instance an item
+	 * can be up-sized to a contiguous entry, a contiguous entry down-sized
+	 * to single items, or the size of a contiguous entry changed. Changes
+	 * are hitless to ongoing translation. Otherwise an OA has to be made
+	 * non present and flushed before it can be re-established with a new
+	 * size.
+	 */
+	PT_FEAT_OA_SIZE_CHANGE,
+	/*
+	 * A non-contiguous OA entry can be converted to a populated table and
+	 * vice versa while still present. For instance a OA with a high size
+	 * can be replaced with a table mapping the same OA using a lower size.
+	 * Assuming the table has the same translation as the OA then it is
+	 * hitless to ongoing translation. Otherwise an OA or populated table
+	 * can only be stored over a non-present item.
+	 *
+	 * Note this does not apply to tables which have entirely non present
+	 * items. A non present table can be replaced with an OA or vice versa
+	 * freely so long as nothing is made present without flushing.
+	 */
+	PT_FEAT_OA_TABLE_XCHG,
+	/*
+	 * The table can span the full VA range from 0 to PT_VADDR_MAX.
+	 */
+	PT_FEAT_FULL_VA,
+	/*
+	 * The table's top level can be increased dynamically during map. This
+	 * requires HW support for atomically setting both the table top pointer
+	 * and the starting table level.
+	 */
+	PT_FEAT_DYNAMIC_TOP,
+	PT_FEAT_FMT_START,
+};
+
+#endif
-- 
2.46.0


