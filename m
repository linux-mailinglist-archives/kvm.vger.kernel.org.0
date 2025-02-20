Return-Path: <kvm+bounces-38623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A451FA3CE73
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 02:12:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 987BD1895F07
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 01:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B533514A098;
	Thu, 20 Feb 2025 01:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wgaMG/b5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B663C0C;
	Thu, 20 Feb 2025 01:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740013954; cv=fail; b=sxmW8BybjTwC4MvPqnBEPIYAbIPcdY5n8dc51l87ZbwMS1NkKpay+/51oE+VvW8LPj374SkbSGdMDG9qYMNuj4Un2VykmcXD1VFAgHJsSVopguLodMSV3pMwDzQcz8m9Jhx+J61R16msL7GHYYpwJ9FgvBXBjRqCreNuOhl2njo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740013954; c=relaxed/simple;
	bh=UX2P3LJV8wj04XqSyzKx4gU0P8IWvhm1JUVQ1JoWRTE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FLzJ5SVjVZE7Sp8vXN73dZ24db8sGp8HWjnuqawyGG2mFEuaxP37Simsmp8fgANF0gFE6/ZFS6T0s/NL3koFjsm0NGzU8fJkHm4QHpaRHC2OYAcu2VEJuNNm3BOkdQcQzOzB620BCvS/Lh16EmPCdvjvDKyQ9cPmOEH/aFdHnYM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wgaMG/b5; arc=fail smtp.client-ip=40.107.93.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N3oIbUhg1Qm7As8hevKoQb3Ya3if6uqoVLT3uSpttKNpqFFBx9jdG+0GGmIL2aUJu58FLcezBZ4KCO3QmP/c6Y4Vf5sdoeko7JR+k8/7BLKANj/tBnofiMv13lxzkE0l0KF2InTXjxfndsg5QuPC7O1mFFKBcZiX3HxN8CSaKTCAgj23HIpEvzaCyhf3FT2em8uZRH7TqDbh2BIEFwqXK0gr5tvuNvkI1odORVHkWHKpLsZ2bsxckRu7qeB7fTPPS8loU5R9vXgoR2tuLBgYNGRNyNCMxwT2Pe71SFwCcNwm7hqbsn1Cy0Oq9bcd/98+IUo0psRi/I8FeVKA+9j3Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/2FHULhc8GW4M0ahUjVCuRJCgiKzmDXNFfSfHzIv5HY=;
 b=Hq2Z6qyR2u6WvOw8wixCsRo8k54dQXSf37Nn0VIGtoQflQWr++BdQ8jOlEhR6VQQ9VpTBi7elNsOqNBQB7tfdSJcqwkL0MBfEa3o6GgqbXoxZwpIRMPpWXNdAQhtMFrnuNMlKvE4wua0CMyQFT/aMurVv8zJqR10ob1h+dosc9Dq5JgrJ5lOYQlgjVMVm2uM1HW6F4n+VMuqgkn26f6mTuO4DwYCcszOzVC2mkJW7wjeqgN6Y2jmjcwqYrKWLs0jwPIgc9xxTwuDGyyoP18icQ1TWm0yrcUuzFww57GZdrhhpg4YLcB1DyQc8qJR1B7W/sS0TFb2qs9IFOIjs6CMOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/2FHULhc8GW4M0ahUjVCuRJCgiKzmDXNFfSfHzIv5HY=;
 b=wgaMG/b5JrSJaFPj5nOFNz8EXqXDVKnGqeEjR86Y2txAhjWXR3Us9l6XIue5TmtFN0CRcWtyze8Ynh2HIrl4MyoT/L7e0SGZTsXDqdi+x6HDBXeFRwba2/Lxlfowyjz1PXUYdwV4qqGZubytl2s//I+YY8t4X9MDTDSKJkj5pFY=
Received: from SN6PR01CA0033.prod.exchangelabs.com (2603:10b6:805:b6::46) by
 PH0PR12MB8800.namprd12.prod.outlook.com (2603:10b6:510:26f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Thu, 20 Feb
 2025 01:12:28 +0000
Received: from SN1PEPF0002636A.namprd02.prod.outlook.com
 (2603:10b6:805:b6:cafe::f4) by SN6PR01CA0033.outlook.office365.com
 (2603:10b6:805:b6::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Thu,
 20 Feb 2025 01:12:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636A.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Thu, 20 Feb 2025 01:12:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 19:12:27 -0600
Date: Wed, 19 Feb 2025 19:09:57 -0600
From: Michael Roth <michael.roth@amd.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
Message-ID: <20250220010957.cueewk2qliqlpe45@amd.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <CAGtprH9ehiz+yKfQqj6JeObaPv0DPUsoAH+YVdSeuzL9zhw9tA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH9ehiz+yKfQqj6JeObaPv0DPUsoAH+YVdSeuzL9zhw9tA@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636A:EE_|PH0PR12MB8800:EE_
X-MS-Office365-Filtering-Correlation-Id: 36c08244-5334-4ba8-19f8-08dd514ba494
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjdzYmlIekpsMmZwUGh1aFNBVlFXNjNxakVLVXljTDdCQ0hTWUNMK2x0VE4x?=
 =?utf-8?B?SGcreGNnUFl5NVF1SjhaR0JLODZCUnVCWERhemg5Wnl1bE5yUDZvTlptS3FW?=
 =?utf-8?B?enRQem8yeis5Zjh1S21sT3hraW9YdFBxU0QwMytiMm5uVUZqQ0Y4QklTd0c0?=
 =?utf-8?B?MDZuMzllV0JJQXZHK252a2hsTVQ5alhua0NUNXhvSGduczBwNkZicDlIMVhV?=
 =?utf-8?B?RDRZb21ITXFmVUxJOEVnaXV5cnhzeFRKSnFlTWpuR25rUkpMODRTZEJRcjl5?=
 =?utf-8?B?N3pXamxKVysraUJ2alJJQXBYK3B2NmpHQWgrMWhVak9xM1JLSVpNWjJlNXh3?=
 =?utf-8?B?VUpmQy9YZUlZY2h2L1NyOEtJNHgxdTJGS3RFc0NqWThYMis3emJJMmJVdGlZ?=
 =?utf-8?B?T1pCV08veWg5Yk1BZzFKaEJTaWg5YjRqTWVFYzBLTXVYbTZkZGo2RTFtNTB5?=
 =?utf-8?B?UGRlZlNkcC9vTzRlNFBNcGkraEt5ZFdsUGViaVdLUDEyd2NhM3d2V1pRUXZN?=
 =?utf-8?B?bHI1UHVZQWFmQlpwUThhNWZqNUxUWGVXcjdjM3V1QjRXVE8xamVWVXpZMFRR?=
 =?utf-8?B?eWZ4Ni93ZHZQSVJDb3pTdXJueHJwZUxHMGFabFhwbUNnM3VvdWRPUE9Kc3Np?=
 =?utf-8?B?bFZIU2d6N3JsNGtYeGdBbDZnRzB4M1BvaXk0U1RxUlFVWXZOZjNLSGhpQ1ZN?=
 =?utf-8?B?aUIrdGg5R000ZnRJNjRHY2pKQTRIc2RiQlVrYnFJM21kU2RNN1dGYUFHY3Fi?=
 =?utf-8?B?SHlCdkpGMlBISXhxRGE5SlY5ZjBkVVo4bXllOWJIZzdZNno1bDF2RWFqb0sy?=
 =?utf-8?B?MXN1N1hBeWlBUXFPUEYzRFFWMGdQT0E4cVg0ZDU1RTdlZjBOSGN4bHh4OTFh?=
 =?utf-8?B?Sy9tcG5pVnpIVUNHM0kzb3plVmlJQXYxWHBXdjhRK1RWTEsva0lCQlJCNTBV?=
 =?utf-8?B?U1Fua3hqeXpWQy9zNTB0OFp2WmZxakRxOFlIQVlTZmp4b3ZGRzBtaXdFcUdI?=
 =?utf-8?B?NnB5ZThPOTNZTE9wREhGVE9PVFRGWFljSndWTXBhaDdMRllzSk9nRUQyYm5y?=
 =?utf-8?B?OStMVlArWHhGQWVjRmx6Q3dUWjV3SUVhbUVBTlNkNnRiOFlIQTNaeVhkTmlm?=
 =?utf-8?B?VUhjS2IwSVdqNmV1UGRiU3NLQXJKaWxwdjM2aVlEbUxwN3JDT2IrdDNhOVRt?=
 =?utf-8?B?cDFKdDk5RXRaUHZ4bGZNVWUrOGY3akg0UjFIQnBMa1Yzek1VTDlWYVJvdmdI?=
 =?utf-8?B?QVNwcGlPZ3NPREF3WXlCcnh4dVk1WXkxdlBXNVlBMnlMdUpaMDRObWp6d0pI?=
 =?utf-8?B?aiszWUZJTE92MGcvREYySFROdXFXeGJ6VThNOG8rSG5FWWZIWmFsVTJnTFVJ?=
 =?utf-8?B?cEVQYjBaVDYrRWVCYklveFRRVlFLZ0dsblB0RWkybyswa3BmanNiQlV4QUp4?=
 =?utf-8?B?MWNXNXlCVlB5MFRJbklodlhkSWR4Mm05clhZZm81MzBKek96Q2ZNL0djbkNK?=
 =?utf-8?B?YkxSQWVBc1FDYXV6c2lTeVZObitwVDgzU3VwdmNMQmNSZU55L2ExRVRLb0VD?=
 =?utf-8?B?YTQ3dTUydzh0MGFvUFlGc0FleEtyT2pxMU9tLzFhQm1HMEpRdlBGT2hRQzFE?=
 =?utf-8?B?OU9TSnRtaEhoa2puM2dINGxaM3Y2N01wQ29hVTVGcU5aRG5xYVY1aGw1ZXpL?=
 =?utf-8?B?RlNlMWRKZnZ5L3o3MWFhM0FBZFBVS3RYcUFVZTF5bzVJbTBNZlpNbldHSWlp?=
 =?utf-8?B?UUlLaEk1ZzhjM2paMHkrQmp2YTdtY3lZbzBiamE2MDZtV2dCMlhtcFM0bVkx?=
 =?utf-8?B?YjhPSmpzNGIwM1NrZFJ4UVZneFBtQnFHSlNDNVFCMS8wQjZQY2Qra3BuZk1O?=
 =?utf-8?B?eTBZaVhKY2NLZExWQm8vVWxZSnJFU0RWdllTNm9sK294YzdEQ25iVE5hK3k5?=
 =?utf-8?B?dHpBRWI0MDVqRTM4NUw4UmxqOTJNMlNjMkRJNUVmRUwzMTFZOHRFYWpKY2hJ?=
 =?utf-8?B?djFyZDBUc0FzK29XamYyd01SU1piYXBzV0o4YkN3RjVXbDBiTWlVN2hZOHVF?=
 =?utf-8?Q?aOsskt?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 01:12:28.1107
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36c08244-5334-4ba8-19f8-08dd514ba494
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636A.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8800

On Mon, Feb 10, 2025 at 05:16:33PM -0800, Vishal Annapurve wrote:
> On Wed, Dec 11, 2024 at 10:37 PM Michael Roth <michael.roth@amd.com> wrote:
> >
> > This patchset is also available at:
> >
> >   https://github.com/amdese/linux/commits/snp-prepare-thp-rfc1
> >
> > and is based on top of Paolo's kvm-coco-queue-2024-11 tag which includes
> > a snapshot of his patches[1] to provide tracking of whether or not
> > sub-pages of a huge folio need to have kvm_arch_gmem_prepare() hooks issued
> > before guest access:
> >
> >   d55475f23cea KVM: gmem: track preparedness a page at a time
> >   64b46ca6cd6d KVM: gmem: limit hole-punching to ranges within the file
> >   17df70a5ea65 KVM: gmem: add a complete set of functions to query page preparedness
> >   e3449f6841ef KVM: gmem: allocate private data for the gmem inode
> >
> >   [1] https://lore.kernel.org/lkml/20241108155056.332412-1-pbonzini@redhat.com/
> >
> > This series addresses some of the pending review comments for those patches
> > (feel free to squash/rework as-needed), and implements a first real user in
> > the form of a reworked version of Sean's original 2MB THP support for gmem.
> >
> 
> Looking at the work targeted by Fuad to add in-place memory conversion
> support via [1] and Ackerley in future to address hugetlb page
> support, can the state tracking for preparedness be simplified as?
> i) prepare guest memfd ranges when "first time an offset with
> mappability = GUEST is allocated or first time an allocated offset has
> mappability = GUEST". Some scenarios that would lead to guest memfd
> range preparation:
>      - Create file with default mappability to host, fallocate, convert
>      - Create file with default mappability to Guest, guest faults on
> private memory

Yes, this seems like a compelling approach. One aspect that still
remains is knowing *when* the preparation has been done, so that the
next time a private page is accessed, either to re-fault into the guest
(e.g. because it was originally mapped 2MB and then a sub-page got
converted to shared so the still-private pages need to get re-faulted
in as 4K), or maybe some other path where KVM needs to grab the private
PFN via kvm_gmem_get_pfn() but not actually read/write to it (I think
the GHCB AP_CREATION path for bringing up APs might do this).

We could just keep re-checking the RMP table to see if the PFN was
already set to private in the RMP table, but I think one of the design
goals of the preparedness tracking was to have gmem itself be aware of
this and not farm it out to platform-specific data structures/tracking.

So as a proof of concept I've been experimenting with using Fuad's
series ([1] in your response) and adding an additional GUEST_PREPARED
state so that it can be tracked via the same mappability xarray (or
whatever data structure we end up using for mappability-tracking).
In that case GUEST becomes sort of a transient state that can be set
in advance of actual allocation/fault-time.

That seems to have a lot of nice characteristics, because (in that
series at least) guest-mappable (as opposed to all-mappable)
specifically corresponds to private guest pages, which for SNP require
preparation before they can be mapped into the nested page table so
it seems like a natural fit.

> ii) Unprepare guest memfd ranges when "first time an offset with
> mappability = GUEST is deallocated or first time an allocated offset
> has lost mappability = GUEST attribute", some scenarios that would
> lead to guest memfd range unprepare:
>      -  Truncation
>      -  Conversion

Similar story here: it seems like a good fit. Truncation already does
the unprepare via .free_folio->kvm_arch_gmem_invalidate callback, and
if we rework THP to behave similar to HugeTLB in that we only free back
the full 2MB folio rather than splitting it like in this series, I think
that might be sufficient for truncation. If userspace tries to truncate
a subset of a 2MB private folio we could no-op and just leave it in
GUEST_PREPARED. If we stick with THP, my thinking is we tell userspace
what the max granularity is, and userspace will know that it must
truncate with that same granularity if it actually wants to free memory.
It sounds like the HugeTLB would similarly be providing this sort of
information. What's nice is that if we stick with best-effort THP-based
allocator, and allow best-effort allocator to fall back to smaller page
sizes, this scheme would still work, since we'd still always be able to
free folios without splitting. But I'll try to get a better idea of what
this looks like in practice.

For conversion, we'd need to hook in an additional
kvm_arch_gmem_invalidate() somewhere to make sure the folio is
host-owned in the RMP table before transitioning to host/all-mappable,
but that seems pretty straightforward.

> iii) To handle scenarios with hugepages, page splitting/merging in
> guest memfd can also signal change in page granularities.

Not yet clear to me if extra handling for prepare/unprepare is needed
here, but it does seem like an option if needed.

Thanks,

Mike

> 
> [1] https://lore.kernel.org/kvm/20250117163001.2326672-1-tabba@google.com/

