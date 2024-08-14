Return-Path: <kvm+bounces-24131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2594951AFA
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 14:38:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C717E1C20C0E
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 12:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 108AF1B0124;
	Wed, 14 Aug 2024 12:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KetWinYm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2052.outbound.protection.outlook.com [40.107.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883DA15C9;
	Wed, 14 Aug 2024 12:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723639102; cv=fail; b=mXqc+FZFKCUeH0gH8zmaIUDe0/sYtR6Llix2WcWi7I7Z1bOsPlKiBAAQBw/lC4k2THU1qiQJzzxqyepoQMFU/OnipnPET+6lLhA44EvfTOFelsyvTFby+p1WzRTZA5cHP/Qxrg5VTYVt7TfGeCPqrXz/e4PLdexntT2LlnY2+MU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723639102; c=relaxed/simple;
	bh=IGIMdPx/RkH6pWYMpcnrGcv89VEAKHvE7uABAjiN0uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t7PCI1ZNPyTBgOiWVCWL+xbz+ewqTBRRVo9I1sGJWE1UbOXNQHuabW11Gq0qCMg6Uiu8XrwILVa4KxZSw5aSPLp1BrvfxrQAPEylnfaKHWLTl3HiIieWN8WkOO6TyBqikQxp32PaDnDE3n4KePZ94dXLFUgJWvgJU+dWetIT7Ow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KetWinYm; arc=fail smtp.client-ip=40.107.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K5Se9D72D96o6aEUmaTzczcMiB13IOX2rCaytU9is1R9UkEpx+ZSQ2l9uAyx+pH5G0URUYjIXwEfarL7y3El3lXsV6SR849F4ipA9mFDO6zrEqqGWvFo9YSk3JxazMDLGYLypOQvwJRcwhnPiSpMFhxLNb18a35USazKKw0XXA6WeOk0HqvM83SlTkCPKeJQLyipDjJ5Z76hdxfzT7H8R61cxzzXp16dEFF81kTqDOx9pPFT7iVUNNl7/5TsqYtrWiy+uSsEqPe5cMzXebCIo1NvJlfoPdBURoaAuqbb0xYUF6H6ka0y3s2m/F10ObhXF1XktzVAbKg3E7Jd8IdnKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TI/xJKmvPskUhaGHwu/rQdFH7tweOqp9PESayZJNILA=;
 b=fOVwDCo9gzW0+69h50ng0Howge+zS3gr7y91L0gg1ZNoLkoD7+0pV5G87Aqud4U8QdJ7pKi15mWaKCcYjaO80KCnEvsGO8RGIJJ918RuooH1a8cIoV0kU/ga/c12DjEBuW+7qCk0ztjwE4xN5mZ43+5jsZ7r7ENvLYG+Ga3o4qfEHRJHsrBHyZmuBOOAekrrHtX3f4VDqbi9aBhnV+ZBSx9mgSywJIgqhDZjrQ+655Wfy/gFQWNo/dH3pMoQSBQwsMX2Amz6NKBfPqMgdcDJhW4vPdNELTE3y35MbsNgyKJC+1+QJ7Qyd8WtwOQO9Uk3eeOLYKVmCbPqKsW0QzRgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TI/xJKmvPskUhaGHwu/rQdFH7tweOqp9PESayZJNILA=;
 b=KetWinYmBXl8v+khvsRhs4Qam2MXfgTUoyv6vTFXeBeDCzOaAYHP/NXkizUZT3E0z/Ub0ECTQW06ybi7k0L0LapHtNdiII4HafZwezlSRTLIC4IqVxFp8+8XnVGebd1cjoeIBXi4dcOy9FjQs/abwN8ZgRmnXLFLg8ldfRcWU/X6iYgwcCGky6mUJfUgSDrLum6H54MTZ6QcF3pI4OjRs5ro+TL90ZqjKdVhuwJLCJ7bpFqhiu1+8gWXMI21AhZvk6uQXJXu8cikJ2q2ySIXYp7xFW6MD/pUw3MMkZWAdXxQ1ijqAYc8diBaWm3WL5oL8WR83/DldSAoo5B5Gr5PCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB7767.namprd12.prod.outlook.com (2603:10b6:8:100::16)
 by SA1PR12MB7175.namprd12.prod.outlook.com (2603:10b6:806:2b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.20; Wed, 14 Aug
 2024 12:38:17 +0000
Received: from DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52]) by DM4PR12MB7767.namprd12.prod.outlook.com
 ([fe80::55c8:54a0:23b5:3e52%3]) with mapi id 15.20.7849.021; Wed, 14 Aug 2024
 12:38:17 +0000
Date: Wed, 14 Aug 2024 09:38:16 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	Will Deacon <will@kernel.org>, Gavin Shan <gshan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	Borislav Petkov <bp@alien8.de>,
	David Hildenbrand <david@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
Subject: Re: [PATCH 02/19] mm: Drop is_huge_zero_pud()
Message-ID: <20240814123816.GC2032816@nvidia.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240809160909.1023470-3-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240809160909.1023470-3-peterx@redhat.com>
X-ClientProxiedBy: BN9P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:408:10c::25) To DM4PR12MB7767.namprd12.prod.outlook.com
 (2603:10b6:8:100::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB7767:EE_|SA1PR12MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: 42fe2eb7-228a-489f-94e2-08dcbc5df902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?od5cK4zh0Zyeh8fH8jELx5bbw25EcOeNnm0vd0wqfK2/xk/tpamFXRWYwuM7?=
 =?us-ascii?Q?OSiUUF5SU5N7MXlfDRORmu73eRlgx30FEkPIvnloW4c2fa7x0Nc1I95k3R4k?=
 =?us-ascii?Q?TWHs1/OS0VGrNcFdyhzvYHJZRrj+ObZgr1u3myRcgMJKVfYA/iyrlonea0C/?=
 =?us-ascii?Q?ZpIe4rnxNUEid1WiGMUVNoKX0mhpcZpfJvC98qbBjfkTQFgQuhD/sxK7kTcH?=
 =?us-ascii?Q?XLotjM05WQrRoRJso2w7RZSypFonXtd5zNcw12aBylFvWJYCI4o4kx4ciDbX?=
 =?us-ascii?Q?FbsjoHlqVK8h2se1zA2OCQ04QpfRhKE1wtkxSHqNydCmPGoT5ayQe4eSUmKW?=
 =?us-ascii?Q?di2xmAIrBoQdDRp8y1F7sS6nKDsgWXhokgvdKEiywHhVgGuz0RxV/lt95dFM?=
 =?us-ascii?Q?CERa8VtBylrGOQc3dFt1U2SXONhnsE6E0MvElPzjO2TaDtQ366FEPWIx2Syi?=
 =?us-ascii?Q?14dozPfuDxqHgUdWYm+SfJwDecJxtgdV+NWdR1FdIX2chOM8OzGh0GDG7TO5?=
 =?us-ascii?Q?ZlQmrgASmAAeTy5iqxoQjXonPIvlR8DwS7jN6LH39Kg7zx5ZCzGPEhiSf028?=
 =?us-ascii?Q?ZnBkFNtmBqm+CRhkMTQ/eKGUTkebkC1b53HJZ6GzD+sAaEuS+Pnk2vtEH+Tj?=
 =?us-ascii?Q?8ErHN+zywu592MZe/89B7En3Ri5tbmhzrEdDGiDmkQK2jPlFbYgWDEt7WFED?=
 =?us-ascii?Q?6HLyGQF+6dgYLPEP/F9SblpvaSi6a97hYl+1niq7MCWnjTiEfCG6xFi+6GZ9?=
 =?us-ascii?Q?iAQc+KuzyX2DBkRYwGRDh/lwGSqeX3Nibj/b7pDuHkQoey956Rc3igb11Fxx?=
 =?us-ascii?Q?gPvSCDQttxgzsb+TcOtbz9k4DECibSwxWeXxZY5OkYBsuXKNcb5RdJmMS1bx?=
 =?us-ascii?Q?LMUXYAcTOoqE48TiIt/De+awLN560iVmrWibh3Ma4P3TA9LX+zj1MfhEAmV0?=
 =?us-ascii?Q?OTC7aQekK5Da9HbgzD7UXzIE3aGQnH8nKUIWFObRR52Bpi7u1VgUiFj+6vj4?=
 =?us-ascii?Q?73DIAj1lFDdcaLee5UO2546s2PsZjPSmEack8RchTTBrG6yF7eLrc9gK5POm?=
 =?us-ascii?Q?0wfgG36GbcT1KWA2YeeWY5FQYMgMJCrJcSG5YrD0zM+Sm69Jbchm+WgYMrvi?=
 =?us-ascii?Q?f22V/q4tupbKVRVu6m2TF+6sBN3UD5AaLfde+mFfPnoCx2ARnZzqbEIQYrMN?=
 =?us-ascii?Q?iE92NivdtUbPCJphiF9SmEa02kg6IL4CZ0GIweuTxblC81ZlNPMYRXPOd9bE?=
 =?us-ascii?Q?wt50ykfRakqbt8JgY1gm5cHEXcJPWEIG/u4aD9iggp/TwTVxg6SKJaeVZrC1?=
 =?us-ascii?Q?ZCcv2wNZFApal1LnR9apeCi8bH/qVBuvwcAktododKsI2w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB7767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?miYu87Br26hFf7+8MYB29ddVIkIYLFOLeJQehJWQ1QFuUbLDcCj8YNDzyBa+?=
 =?us-ascii?Q?HCUcz6NDtfqAEC5htsSmg5ua8a3cajJ+2zPBhb7KEHkr+GxGKqqZYgoAGtQb?=
 =?us-ascii?Q?fVCoUk90D+5mm6M2FJwFmsx1G3nBV9GDsvNRJDRy0M6vK35gA+vWKHkIEAMO?=
 =?us-ascii?Q?RodfegzXa9EVEfPmOhRbh4IG78RjuL2VQwjLNMAMbvB11jD0H8Zr1VOQymHe?=
 =?us-ascii?Q?+TVTdo6CiQAoG/AuVGjoD3QGFbIOgJIynLKA78MEdNvsB32xQ4yFq9G7Zvz+?=
 =?us-ascii?Q?B4lZywJdzyrHSYkRgFrQVUsgnNPJ+Rr79UwV8fL2dY2ZBuH7wpkVgI8MRhA6?=
 =?us-ascii?Q?RbdtMK0Dcs8JxHAQCkLEvsTQ38fHU9PEVXI0HYXjFgcLc4MTaTUDDXqFTSU8?=
 =?us-ascii?Q?gEHBrLL/qfEJSj/DWnciGbV2GEgyVf0cGQgj9SIDxHqrBR2F8QrJyNSkGou0?=
 =?us-ascii?Q?eTIIm/ZW8vUbbFjLSh+6N62SS9O3sK9v8oXx7PTYkVUmaGIFvFBcqivVSKEh?=
 =?us-ascii?Q?skpHy4LHmTDPRVub7jW8YC035Q4/uF7+5md7fkKv9a5Ixo4UDLVqcCrFjwjc?=
 =?us-ascii?Q?ccQjgZn0EMi/eYooM7pC49hl+qsf7KOy2zsz2l6XPsIUxWsQ6/P6naV5UU4A?=
 =?us-ascii?Q?ztlUpFbDjE/pXSrHk6DMwu356IbYcecTRaoJrEbIKcMg6S5RQ9aJGhyXmPJA?=
 =?us-ascii?Q?FcSJVblQfNGUhOjsfkk0VHSKVjywqYPI11j5YksoTJBymGXX0W3DHUWA/Z2n?=
 =?us-ascii?Q?DPKJ5K/lYc0QlYdCehXNkL+BLxwfzknQPX2jV0NoFjE6veNAyeH8QWzofC1t?=
 =?us-ascii?Q?lwKY3RfYQ/OCkP/OLQSyN2JJLMmF/X6bZP5e4KdxKJNPeo8zgE0f0IK0Q+r0?=
 =?us-ascii?Q?uCwfpXSukulJccfsP1cmXYncnv0U5yw++GqL1AbGXUsD7oLNqsmaAlYTtSKG?=
 =?us-ascii?Q?eepPt3J/gGpFM9bn/tijtAMxX/wGRJVK+BXxXl3XcjffktJunCfXIO5T7e0h?=
 =?us-ascii?Q?70WuwbU2S0vSkqStI+hyEl6mPh2WyRSYkNoy+a+y39huR8DRlHjxPjMGFENf?=
 =?us-ascii?Q?gsWEVoAUizfYDynZEjTCZ9pe7jsZ1vYWQYY+CD3uLmLgBIBrOajP9hPBDpJW?=
 =?us-ascii?Q?uui/w8MW6fRPYUPvJE3NV5XlYw7FEtpNoVvmXlFoel+KXu52eB2R+9VvyRfP?=
 =?us-ascii?Q?Q4EgzHi9kJGyd7EhNZXS9x/VTovcNIBckit9IFFQKCpxM5X+XatcUenNnOFI?=
 =?us-ascii?Q?84tBGiP7LyDryUqdS7IdaHqqe4oPvtblXJqA1WOiet0YDc3402fsNeqMG4Vv?=
 =?us-ascii?Q?X6MiM+Wscj6yYOlHR3OfjJtKuSxxuDUieaPpqQoWdBFw/xyqdgvCo3KsTj5Y?=
 =?us-ascii?Q?mSyyI/bsTtB7GFWYQWpvO7nmh3ZRI4RXExV+/42bjxxJ5CXSJ4pjIJ0KLgGK?=
 =?us-ascii?Q?AeM5CncPf+OeNRLTiDw1sM4ffhLsOC0ydLJuLzKGMS5pVodGMWAFSRflcpOi?=
 =?us-ascii?Q?Mbauf202cc7L8d1aNyUt3od0Ubfhcfl75NSferL8TK68K60B5ixa9g8flv3g?=
 =?us-ascii?Q?kEE0gqLR1eIhVDQS5wfdPL3X9A8q93r84wz03cla?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42fe2eb7-228a-489f-94e2-08dcbc5df902
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB7767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2024 12:38:17.6696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQuKH1BwJMdqfj4xr/cDMC1/iGHUAZLZYOQkN96hajgkzFu0XoX+ES7w8RBvTBkB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7175

On Fri, Aug 09, 2024 at 12:08:52PM -0400, Peter Xu wrote:
> It constantly returns false since 2017.  One assertion is added in 2019 but
> it should never have triggered, IOW it means what is checked should be
> asserted instead.
> 
> If it didn't exist for 7 years maybe it's good idea to remove it and only
> add it when it comes.
> 
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  include/linux/huge_mm.h | 10 ----------
>  mm/huge_memory.c        | 13 +------------
>  2 files changed, 1 insertion(+), 22 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

