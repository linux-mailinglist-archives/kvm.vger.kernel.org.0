Return-Path: <kvm+bounces-25894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D90296C319
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 17:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 029D02820B1
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 15:56:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB621E00B5;
	Wed,  4 Sep 2024 15:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="XhFCaBOx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2059.outbound.protection.outlook.com [40.107.93.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B7E1DC72A;
	Wed,  4 Sep 2024 15:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725465128; cv=fail; b=BwNRPwkkATF2rH7Cj6mH0rYuJ5wjQy7a9acdNO/HcW55j5l698ROVVNaMp4qfj1ex7ZjpWuFqw5qDai7XwNwVbJkZKXMHvGQdyt3B1pKh2Wyzriw4HTDQyvXDfKDo3FgILYMRnyyfwGzddudyD/EQmjTZsDhKh0meCb7jdCgq5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725465128; c=relaxed/simple;
	bh=64QtsT5m0DCHgEkT/aKq5URlPcE3kSqxZ6+FU+6qVqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=d7dL6Nrwi0dpAb/BAFYKYYCIoeMppl25NuTtulDOIbfS4bR0/OPonxOEeCsVl40NRTRHFCglf8Ef0TyZl/FugbKUt7bPJPy96f/SXwMg3IjlDQgKzxFuOB3tKH22ODat4BRXhVTABqY9aAPuw2iUgQKfQej+SIpCQgZbU9xI0Dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=XhFCaBOx; arc=fail smtp.client-ip=40.107.93.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D6B+RWdAbQzUrjDKx668dd29COLqmtvWe7kAFDwcR6ZZzJQp4hYtxAjWGLpPtjcTMY1VNgBV4kokKpzm7SCA6u+/Gp0TNrt5frQRF+EHL7GHdsc8biWsGQ3f3SBh+yvL/lRn9ZEy2qc1fEKiCSOGWye4nmNg/Kffy1GpX1iei9iSdbp3fi4uc12VAGLNlQVeRIvhVVr+SUglV5izBNN3kjUCbdtd0TN9HzwsO+6pUtzRr4iBU7i63svsH+9Ukhpq9QPQqsPNZ48Jdm1bD4WyFbuJI1CTM/iM4Hf7BkS7pQWw2IodHh9Xqod9DtFdkxmTKiqKzZN1NvnpAyYXchxoXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64QtsT5m0DCHgEkT/aKq5URlPcE3kSqxZ6+FU+6qVqI=;
 b=OwgcGqldzSIco5tJcEH7lCYmbgsLlyKYo0jPlFp5+VOcPiofFLxMtnvceXsKi4NAKzM/ZF2Vf/xBYr8zofT9vRuRObD3C8gD2ASNuL9Nw3iily/panB+VJPFKqmuADaM3ljUsxqE53yKnGA+Sz/7akRHJi1JWOGXdvHF6tyd+7ookaF3lbGrn4BTI+ltzIVMBKVQGwg6QN3r59EKGrKfVQAm/aUNJZT9tp0vdX+qHtm7QQdTtTeUwcsnF2vvTwaFo6HLQ5tSj+DA8UfAPMIiIbA1RhsM8+uv14oGNnovckohWcL4jzzzBXyvTa802P8JYwAVWLYMiKEFofdJnuefwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64QtsT5m0DCHgEkT/aKq5URlPcE3kSqxZ6+FU+6qVqI=;
 b=XhFCaBOxHkE/JjI++Rdy8wOAlxNcGyjVxeE2ERqKhXmLHWrz2gSn2rbExnkPDt2uq4xigqoIrH6RO81ypqajNrRdwq1+cjnTjpjEX9ohbu/B5MIUVX9V1b7f2JW9Sj2rD24NWB7jBodaSKXAVmAXGZsSxgdZKQEKGcJRmvlRnFRzDiwBUlD/r3CDWqNwEofzGLmEDfGs4jBviMx8gPpt32rOTk3NkHsxxiCajcM/likbnjAoSmAO86c45ws7OQhw7iwcIWI3VquSZcPKxID/djvrE4dqZPH+USsq5py7SWSc+yrLDaUIS0EK25I1+X1ycYg/fDVpea6ipxKzuz7xXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB6769.namprd12.prod.outlook.com (2603:10b6:510:1c4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Wed, 4 Sep
 2024 15:52:04 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Wed, 4 Sep 2024
 15:52:04 +0000
Date: Wed, 4 Sep 2024 12:52:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Gavin Shan <gshan@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Alistair Popple <apopple@nvidia.com>, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>, Borislav Petkov <bp@alien8.de>,
	Zi Yan <ziy@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>,
	David Hildenbrand <david@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>, Will Deacon <will@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>, ankita@nvidia.com
Subject: Re: [PATCH v2 00/19] mm: Support huge pfnmaps
Message-ID: <20240904155203.GJ3915968@nvidia.com>
References: <20240826204353.2228736-1-peterx@redhat.com>
 <CACw3F50Zi7CQsSOcCutRUy1h5p=7UBw7ZRGm4WayvsnuuEnKow@mail.gmail.com>
 <Zs5Z0Y8kiAEe3tSE@x1n>
 <CACw3F52_LtLzRD479piaFJSePjA-DKG08o-hGT-f8R5VV94S=Q@mail.gmail.com>
 <20240828142422.GU3773488@nvidia.com>
 <CACw3F53QfJ4anR0Fk=MHJv8ad_vcG-575DX=bp7mfPpzLgUxbQ@mail.gmail.com>
 <20240828234958.GE3773488@nvidia.com>
 <CACw3F52dyiAyo1ijKfLUGLbh+kquwoUhGMwg4-RObSDvqxreJw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACw3F52dyiAyo1ijKfLUGLbh+kquwoUhGMwg4-RObSDvqxreJw@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0316.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::21) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB6769:EE_
X-MS-Office365-Filtering-Correlation-Id: e6f76a51-f549-4ffe-bffb-08dcccf9859d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AauT01HvmrrU/u5lQWr26hUTnN9wOPf5d8m2wUIgVDMJNZrg3dze/eJmHOi7?=
 =?us-ascii?Q?PXSlzxN5IpruBjELgNEcBtqo6DiXt5Y/pSgBzwwMQmZz11emw1uv+p2e6EAq?=
 =?us-ascii?Q?gkxcJvV0SAuXu7ZUCGgQWuRcraY08eVWtnUmsyWzUEhZYqxgs5Dwq8WeKIXL?=
 =?us-ascii?Q?nlS0uqz1o0TU04ui7RX1I4GtuVLpudu3NBwot2OU3axy71QlQI/bS/szbJS9?=
 =?us-ascii?Q?Vje3Ox/FmnOdh6gZmVseo0faBofwk1RKNAu/OqdE5my7h5ONH5p1f1iFl6Iz?=
 =?us-ascii?Q?7Mffar63EoU1hBA2YWg3YLUhN4gQt61PUukOQ8XlwIW4+fYhjD/WHk4w+TYM?=
 =?us-ascii?Q?/BUw6+bR9XviYtsjukNhYzJNrVT5W8cq3BsEWecCfMgfrHRRH4QZD0KeAAuy?=
 =?us-ascii?Q?h/7oomvgMjiPyM9mXoZ0nat/ibnB7cb2ksgb7IVpWM30e7T0jfsaQnI/hg/9?=
 =?us-ascii?Q?9Dbe3bKfFnjJ1Ul6/tVrIvKVy1nLfrOmrmFff/2MQkf8EezK9P8evtc2w+tx?=
 =?us-ascii?Q?vFMKOKx4Sk2MGs2EmnZKv0NnxF2g5ufIU+1pIpESPC1LyZoGXaFRw6O5KUov?=
 =?us-ascii?Q?W8y9nhPBLw8SEyBdBdr19PVA5JFtnbcF4CQpUWKZWPrKPVXXI06TpGADvjCk?=
 =?us-ascii?Q?Eilyw4LwkZCMdwtKDD1n7S9ZQ/WiAOcr6U65Az6Xjspls1q4cfBqeETkhoeI?=
 =?us-ascii?Q?eU76XQskKgsx6rz3oI8xoHYafdmWC0kGjwK43onTmDaCjGdYDhW9nnIEL+hl?=
 =?us-ascii?Q?Dd5jNhwjYSj3npjoFZcrLP9CwYpNu9mO0sMAWJDoB+WIPgIMd2JKFshzRXn1?=
 =?us-ascii?Q?9VMphKTs8bWtPk+RFxitQPw1kiRXCVOERQOkWGFa0U5rZyEQtOdMQD1/C6NO?=
 =?us-ascii?Q?9g1BlRFhvYoFL6TqG5wATYr9e9POwEoDV4hMM8Kl95h8ecNaCfMBwxGdPm8o?=
 =?us-ascii?Q?3SnYViFPfcP3HG2k2L+ab13egiCyQjumCOcLA/o354agaDWbWZ0vHasTKeiP?=
 =?us-ascii?Q?qC+CIil2J38dA6CjfAsiBrmRmb9A6CDn55WZ87YQlr+dM8j80ncgwxaTxKID?=
 =?us-ascii?Q?HfMBDubFgHdv5MDpVcRxXKAXrYfna4GPhJzej3WJUnLU0BuoXnfgYvt7QF6a?=
 =?us-ascii?Q?epnPqCg1Erwrt/m8O3DKzJIFZCm8GD05kJBn+S5EpTeGhLz+ey9sBrTyfQcc?=
 =?us-ascii?Q?PPU8Hun45WRr6XdbP69iggxfff8bdEyiSPICj3P8046zW0h8k0G0xbJNMaa2?=
 =?us-ascii?Q?Foly6tbKR3CMFlUtJ1eP/1yOk0G/F0rF0v5Zb50LFk0ojLqrMllDLwgHzfHz?=
 =?us-ascii?Q?tGJc2UzAHxB6P8uRVSbqfWzSAeZnuwR573vxHk2VGMqb+A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yj6sNXWNf3vFrdietyt2t7CCR8R45j5oj2vKD7ofVjvcByei/MhUfSrOzzfV?=
 =?us-ascii?Q?QHz6wr5ddpaBmj703Pd5a+IsKmf3B8w2FarYsncjBXn7lHSiMk1QYVkD6RRm?=
 =?us-ascii?Q?brZ2Ib5J8SP30KjeNszxgQVII6VwRUeEVVEqEFH4RItQYF9W55xJwdoVOrKn?=
 =?us-ascii?Q?hHR+Mn1d6bB9LVg/r3seP4vxCL6TkAY/RbFlN4/SF0Je+mqObFMDayuz1d1i?=
 =?us-ascii?Q?rnWUDLGh4xeyk8+AAIcI1fGz6XhABXV59mnBMjSkStGAh3WNUpqcXdRFDkbn?=
 =?us-ascii?Q?76oCyZftjwgj7bEtHTRT3sUXu8oixecPpq3RsGcmR08qf8GfHxdNchDMSA8N?=
 =?us-ascii?Q?8EAK5RPL34vma+jSA6ITH9L4DfuxsZogtB9tfn3/ylDRH7KVVMqL7bJV3zMV?=
 =?us-ascii?Q?77J7PGpvIurcb8tHWI2jz2t/ywvxv32OxI8m7bZUK/nq66Qmq5MDW9JSKF0m?=
 =?us-ascii?Q?Mjy8Rw1xtJJRKwiuBCZ5LpGX6yZbrJviqbvVRVqmj7OkK/BJE8jbvDUYg/uZ?=
 =?us-ascii?Q?5xv3IbDVKbBWxb/Q58WfERLC8bSGiH7+8YJcBEmcdVae9+8+XDw9d2wAxIFS?=
 =?us-ascii?Q?RozhbtBkf7qJopqIHb8emKEDTOQtbYOsqLIRrX3bgwh2D5jMxOR5s2GkGpKx?=
 =?us-ascii?Q?8WaQwiLY3B8JuxTLkBqukwAz9Oar0CUNzf8LyfPD2Ui4S3CcCUasoOxgwEhm?=
 =?us-ascii?Q?jojESWh6GZFr/YIGLpG0dt5fkK51Dp+OFNI9FdHjYTIs3WOTzm0MnZcHaqpG?=
 =?us-ascii?Q?bqiqTXKOuGo35maLNchAybrmZSdjMh2wmLS/eaykNx9GfuPM89wKq31cDbYQ?=
 =?us-ascii?Q?aJ28ncKj3zBX2OTDZQcVRdzWs4Ak9478iqRqjAVwSoPEW8+bwTM13kWotULc?=
 =?us-ascii?Q?feEnvEQ6K6Ue695MHUu+j2n/dF/02VtNu3fkwpTxabpowD+6jcbmQ/h1AiF5?=
 =?us-ascii?Q?mV9ChPdcP/sdqhEAbBsaEaR67C74e+B/CODj5sDCbTo2AQgWthHb7OREeBK3?=
 =?us-ascii?Q?bYHo/GdfsE9cdZvPYsGyrDkwhW5sNGTZN4XtzE1rXnpG6Jq2ovJtBIfRVExv?=
 =?us-ascii?Q?bMZ5HqsgabY4BXk/uRtU1gm3FHiyWQPUWGhfYgj9T93tX2pNqIUArSigmG6R?=
 =?us-ascii?Q?aJvak6fWJgIbFbzHHQ8OspZWAR7qhZS+fpVKxnBNUmAHibqWUhb8TQxufvkk?=
 =?us-ascii?Q?4TJiHpJ/vkrCzDjKlL/QwZ2/hwx0XBWDUAx+/vzrCISTmj9KmuIIjJyV7M3C?=
 =?us-ascii?Q?FfCB4cUZ0xq/eAWBSSvRQTHUp/JRjpvBrLgkmaaKeGtcX6B0NyPRz6m+garx?=
 =?us-ascii?Q?xOpuCndo6WGo93UNLjb7HMiagot2KzS4ltPdQeMmTUXkRksnNCuEan2kNjU7?=
 =?us-ascii?Q?b3fAPSXuXUv/+8FEv73FuUnZxSa4mcYFZPBtrnec+F/VbAIdRjtK5WcRRKCf?=
 =?us-ascii?Q?Js9mlIqN4lRROWkSP9v0TE6m3UaeioCtqtCWpnseyyIaxhrISwdITgaSKmeI?=
 =?us-ascii?Q?ErkLWFntdUA/aQctce0jorf8ZJ3l+RcBWuRTjSyfrR8mWtAaI6xQKfs85YZk?=
 =?us-ascii?Q?PbcoKGJa+c+EXpbth5vVp6OHulGLMmYYuDfbm/Sv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6f76a51-f549-4ffe-bffb-08dcccf9859d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2024 15:52:04.2230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ly6aetKEkrI4O5NhZUJFCTWLkmv+thhf9cEnj72Van7YCbx/y+uSVr57aN//24Wz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6769

On Thu, Aug 29, 2024 at 12:21:39PM -0700, Jiaqi Yan wrote:

> I think we still want to attempt to SIGBUS userspace, regardless of
> doing unmap_mapping_range or not.

IMHO we need to eliminate this path if we actually want to keep things
mapped.

There is no way to generate the SIGBUS without poking a 4k hole in the
1G page, as only that 4k should get SIGBUS, every other byte of the 1G
is clean.

Jason

