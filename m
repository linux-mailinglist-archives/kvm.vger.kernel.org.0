Return-Path: <kvm+bounces-34618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1C4A02E48
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 17:52:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49A41165A98
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 16:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FFA21DE3A4;
	Mon,  6 Jan 2025 16:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BCZDnggy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3221D1DDA3D;
	Mon,  6 Jan 2025 16:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736182329; cv=fail; b=Q2KxpPqzHW+37XW3U+vNG4n7+KJ2NjqGgOzezKHSrnz1IqnFRcl61uhtezDjEpAqUy1OK11g3dBu48xgHfP4BHGc3fsREbGa3a4bpeKQPKIApfQPRuxW4crrvPaTAvSmpJNIYRiHOjF/QnD7uHm+f2C7bJTF8CKxElQejowCXSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736182329; c=relaxed/simple;
	bh=dREsgtcpNPXbwJgJPlJjiVU8kt5PWUbwBxFZHMqk5ZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UOEQuha0lA4xJbTltAVsnaY0wsAy77HhFXOb7o5nwlogB79h1wN+jtf58648ZrYMUuF9dyyWP7epMenJvKXeDsGAOLjskOZjFao/VqkN62Ux+aFc91sF5CdreYRJduy3o2sRM+8pNpcpHwas+BSJytwT3n+/IAZ9llpVamUquhM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BCZDnggy; arc=fail smtp.client-ip=40.107.93.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lzKgITSjGS5RR7/YhfTHdM9fCCYpbve13BJ8Pa5YDRH7tQoJjPKfJBwaIn5HJh3R0jNlqp0r1CGDccL7Scpl8nS7lqngzGKid4fBfCbJAwtDOh3sthkFiAcjj0Ng842GjonUe5G9jiIDh5HPQmdctlIVDifxhg7Oiiw81syTXap8AvYe7PTQVyJSZMV2/aR+MHiYwsrtNph3cfZr8X0lWWrI9tq/Pxxo8oG7rxK2GtoklUVhUDhg150Or/qTF601qmhzZ3p80VBhUw8Dig1GLOR7UPfB+BT62s1xWpF9UTtxWk4t5JKKgf1yu27VYGnZDYSgY7JNLQ+8gdOiTWJJFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clUskHMhFPqUOVCv37mMCEueSpKWFouFb32W06cU7xY=;
 b=KuosuMh35q9q9sRqu02rABxckpmEjEbLk8FycPReqZ5qEVvA0iLsWbRIirfTMXsCIKdk4J8PpoGYjoxnVr8Z0eCMZ7Fdby2VLY/LErGvbakRGf4omB0pHPY5mjhkaeFUgEKpN/64JbmKzzBTiyb6XVqKHoeZGDp+96d+gEJY7QEy8fIx8eErCxwFyXZx+rjMgDg/39KoItvZvY9swjT4uU6/J+EcmSlDNkFZx5AyQHn7QCnfVsq4iQzWECUHT4Ufv33Vf/18ps0gx1XlZobG6vzo6bdj3fULaLZA6UFKf3cWOSfuAa8uNH+0bN9wjIt25+2LDdjubZec9bQfVLO24w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=clUskHMhFPqUOVCv37mMCEueSpKWFouFb32W06cU7xY=;
 b=BCZDnggyiErrV9z7pLVPZSmYGFt05KIyB9SNZis1hQIiBkAcw44joCOeGowL0wkJ5rUbftTtl1wOscXgkNmJb4Vq9yce54vlDXYaZdMrHXKbzh5vTR8cb+s5pBL+XoUUrdIG6tGfn2LhDv7Vub88sVnDKHTMXN09fso2kAj05aHP/qB3q71NWSUYuh8tvSrTt7uwK5u2ABlZVuh+P2I3DaujVXFK3I9qsQga36M0olu9FUhjONUiVTkgiI+Gdc6ObJcpfqdODdCoDexweJbbtRnq+830eVxGmzNAh7B9aMfH4DN6eaw1CzBW52ABatyeX57Hnt2WmNdt2IBL5Dovag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH2PR12MB4184.namprd12.prod.outlook.com (2603:10b6:610:a7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Mon, 6 Jan
 2025 16:52:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8314.015; Mon, 6 Jan 2025
 16:52:00 +0000
Date: Mon, 6 Jan 2025 12:51:59 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
	shahuang@redhat.com, lpieralisi@kernel.org, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, zhiw@nvidia.com,
	mochs@nvidia.com, udhoke@nvidia.com, dnigam@nvidia.com,
	alex.williamson@redhat.com, sebastianene@google.com,
	coltonlewis@google.com, kevin.tian@intel.com, yi.l.liu@intel.com,
	ardb@kernel.org, akpm@linux-foundation.org, gshan@redhat.com,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: Allow cacheable stage 2 mapping using
 VMA flags
Message-ID: <20250106165159.GJ5556@nvidia.com>
References: <20241118131958.4609-1-ankita@nvidia.com>
 <20241118131958.4609-2-ankita@nvidia.com>
 <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2d95399-62ad-46d3-9e48-6fa90fd2c2f3@redhat.com>
X-ClientProxiedBy: MN2PR18CA0007.namprd18.prod.outlook.com
 (2603:10b6:208:23c::12) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH2PR12MB4184:EE_
X-MS-Office365-Filtering-Correlation-Id: a0cce8be-c0fe-420c-d37e-08dd2e727041
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JDdcPcghSPFc6yOukDQO+Ie1Czt8k4+dCN5xgGl/XcjrD4aBAnRHWrfK3OTr?=
 =?us-ascii?Q?8ICZAdyNkpSQpqqiwV3XaMH1bv+qzv1ZijvyP+PXlRqUb6RFQ55X1NWkOTXp?=
 =?us-ascii?Q?E4HRxTRxYKrt9RdxtqFT0fbas1PjenHXFPep2Ggr/R5kc9ANWxQnAeTw0LX8?=
 =?us-ascii?Q?TQ/d0wqrTIZ1kvN+kLRg+h0zEaGibodgAx3zuOVjoY6xeD/Ym1SGyOPA67rb?=
 =?us-ascii?Q?cVTaqRRvt8Ya5tarmqlX1LuliV66vm9A1WtRv/9FMxV8KlV+6iPzMuHtB/w5?=
 =?us-ascii?Q?jcCAW6nqE3sQbUYYRM8C1MLsyCXtYeE9GOXhCngJuhp/StJxWwH55wBcFptC?=
 =?us-ascii?Q?zdcO5FVKvzwoterprTWLqjyxYKTZ6eRT4Mm17gpOcsNoY0ns6C0hGHffRZCS?=
 =?us-ascii?Q?GRyQP+xcMvYe7gtIXtrbVcwivmItkF7idOtUHQfJ55YbjQ6bvaeSZuYzJWjM?=
 =?us-ascii?Q?loLdwIU6KWJqPcgyqUsBG2m9eO5Q/KozcXsSfWclJBkMUNMqo2cSz2NZLvcv?=
 =?us-ascii?Q?QXT9NVvkumkIOBqlUZqTLjQG6/dR5AmroKRqWGpIbPjnh/Q+IJLZE/zZyT4E?=
 =?us-ascii?Q?jdPEREXVnQmER/kEpYsyzlghL8FBPmJQeBcp3HRBkJQsea8Ods/XsSTvlKV5?=
 =?us-ascii?Q?rAIlEQ/zawXudWGQqpkoYJjKDOuf+Q+//ydeIJLrXtm4FI1DNgRnRHhAoLMJ?=
 =?us-ascii?Q?rLt0YEqSYzR+EPAgH2jbxxE3wtlsQQUdgN/Dxttl0MDuv9Ms4y5tc6T5h5Xz?=
 =?us-ascii?Q?wBbPoBkmZP6B6KdG237+tJ59XaCyiyOPX5OUW2nmI05GlVON3PShydTXjU9x?=
 =?us-ascii?Q?3OPqOK+WpHnwT50aYqLXUgfpFifiUi69odlXUesV6mY985XB33NIi87cMAco?=
 =?us-ascii?Q?EsyCNpfqfBenCqFCInSwKuAm3iuF4oO7mr3rPCiEkwlHL5X0OTB3DfY5mJEv?=
 =?us-ascii?Q?xAmQLLAplIVttVS0h2f8lAOdm2AxyA28OKelDXzekSYy5NKgdjCBFO0wnnc1?=
 =?us-ascii?Q?LKIXP9iooYE4Ze8lEoSYuDhM40sN8FsxEDRDeteg9gOO+8YoCK1DpE97Es0J?=
 =?us-ascii?Q?s6u6gRYZ8DQ0WWhdt5J45DmtJ31aQV5acGeBqbjUyB2o4PWJn5kffR9jJk/Y?=
 =?us-ascii?Q?sCd2gD+c3Cz96jOxJuhPN65n7O+qkyquBXpAK3VsCh3d2nAxRAzVe7PtjV7G?=
 =?us-ascii?Q?L4BNjc5PHmbzX6GkNRMY2IH2wtejHe4vPb9Rjslb/zjz1BHpQikbltd1wZ+/?=
 =?us-ascii?Q?CXFd8PqtY/hcAMUJg7zEaWtIR1C0L21FbEPq739FWTWFo4rqVL8wYzaDL1yq?=
 =?us-ascii?Q?MYjPilFEfY20dbQvFnZj29a+FqW0F1vAdNmxNTNA5z2N6tiCRjuomdiZevLg?=
 =?us-ascii?Q?ne3JnbYBT9qK+juo0QlCQhWSPORX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kN9p2+BOqKTR3x8RQDyYRF8HEbfNxmmc3qex1vtF/RwEulHqVtnZtoC5WsnA?=
 =?us-ascii?Q?bZrhyBb2xrp6e/wLgrMr1ZbNCbcRRlGwxdaw7LbcSlMwBuI/u8VJbkzItsrw?=
 =?us-ascii?Q?Eh9CTAGyEEhJCm/T7Fqr92U2iGl32iqMUg4FxUcZHUEka5mS7skWYigwTuUi?=
 =?us-ascii?Q?ec7YcvKqrGQyedtZ/A6KkJ3v3vlyrnjdfE6c7joHJzQl0VSmpKqORHB1sq7M?=
 =?us-ascii?Q?45FtYOhXfRBmZnUpgq6hfTngjs7JuOr4kzbSHhvvNBJ97Jzhxr+8rGCz5WOj?=
 =?us-ascii?Q?gphTrtkzesUPtKGLXbVSJ535Gp6etB7lgUJqmKGm6I0NiED87BRQ16mzaG+1?=
 =?us-ascii?Q?/yMaNm6lqIi6NijO6G83ynwFKsuItxF1mar9Inai2GxzYGlxicSPEEuI9c3q?=
 =?us-ascii?Q?TzKFUSRZZE1rOEaxpbaXeNDtRLaujvuJLzM4s3MzVRcGy1RjsBb5PzkjItRc?=
 =?us-ascii?Q?UMheZgPn9tUG19BcLiJuijWAA8l8fQav06YlCfwvSUZsHyn1pPqdTTO1K+OR?=
 =?us-ascii?Q?BdbkC7FUrtIkYmFoeHldxry2kqWNBCzMRlYVRlwif/sS5qSaw1k7QxuALBw7?=
 =?us-ascii?Q?nsMNeKUYcyLqav8QmcTj34JqaxsEQFN0rAOSJ4twh+sJGyQJKt/R/O7KviuQ?=
 =?us-ascii?Q?4kyiYy00kgpoNZT4JHxO3zgwKCj9+MfsgLmFgZuXuYztgaEZyJ066CHutaWJ?=
 =?us-ascii?Q?p/2wfC+nbHrluwP969lD02IzrKULYNuRxcs8MdBHygoKee85HgvRzLk5gRHm?=
 =?us-ascii?Q?F9leqO1F27/UGfmHY9wRRL6ZN4pXZdqmHiwQ+MxKKkn9v6KjuYLfVWKrDSmd?=
 =?us-ascii?Q?GHp8ugioKoo3db+5x6w4CYp/i+ITpfLrTL3SX1Bae1yjB6krf6ZLhrbijbGp?=
 =?us-ascii?Q?gH0NhDJ8pnbEhA6UI9cR5NY5fbtBt5CUQD1nuec6rB0m0+4TA155MKTk3DUw?=
 =?us-ascii?Q?cHHeGbiaRsfkojf/iOEMF//khrEBTRURYvDAcoctbYdHUngbbwwmf2Pv83tN?=
 =?us-ascii?Q?7ZUkge1vELyTDsvx8B4oQr6ri7vTjSTf+43rflYQMrHz6YF/d1evuUBdaWSx?=
 =?us-ascii?Q?xSQCJwSf+F+WUaE3NksGbTWK1PHVUPqAZMf9/Vdj3jTujGpMHknpiZit8GLr?=
 =?us-ascii?Q?G0nxYC5NSDRwB4JGFT5RxvgDAdf1YdLOWAvgnQ+Q6syMJj6ts9LReCWEM621?=
 =?us-ascii?Q?TdA3/fq1sS5MWhPl2vyus1njjwXg9diwEDbx3J8kYMuI2Ggp7ROpNccjprTk?=
 =?us-ascii?Q?DUXgNFlcllqxZSh2VhtpQ7wPCeN7qUKh9+Yy1jlT+Tq/D9e93xR7KWifCvtA?=
 =?us-ascii?Q?Cj9g470lbZwwLRlBWWKHYefhqcKfXtZbT9cTEO3HT/jq9vhPcwEP+/RHoolP?=
 =?us-ascii?Q?bKknscKuldk3vYXC776VC8pQLR02ne5ASI4tS2NKzsl9RGKxVwtBTBqbo2En?=
 =?us-ascii?Q?wZV+21ENqaOWXjyf2LBVE4DdVPMePnI4s9/1GZ9iFy9KkkrPw2w68MZM0ypW?=
 =?us-ascii?Q?t7r74HiJ3H5lBqR5+HSLleI5klxM2g284kHsmgQXicpjKj+OeBz9ET4VbgBm?=
 =?us-ascii?Q?c5eYcbGlQ4QSLWfFfY4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0cce8be-c0fe-420c-d37e-08dd2e727041
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 16:52:00.3435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: utoTbf03w92k0ykoFxc6uTmVQoS80ezaDUGqyCOF6VUGOa4rWBxR+iv0kTxOhIF9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4184

On Fri, Dec 20, 2024 at 04:42:35PM +0100, David Hildenbrand wrote:
> On 18.11.24 14:19, ankita@nvidia.com wrote:
> > From: Ankit Agrawal <ankita@nvidia.com>
> > 
> > Currently KVM determines if a VMA is pointing at IO memory by checking
> > pfn_is_map_memory(). However, the MM already gives us a way to tell what
> > kind of memory it is by inspecting the VMA.
> 
> Do you primarily care about VM_PFNMAP/VM_MIXEDMAP VMAs, or also other VMA
> types?

I think this is exclusively about allowing cachable memory inside a
VM_PFNMAP VMA (created by VFIO) remain cachable inside the guest VM.

> > This patch solves the problems where it is possible for the kernel to
> > have VMAs pointing at cachable memory without causing
> > pfn_is_map_memory() to be true, eg DAX memremap cases and CXL/pre-CXL
> > devices. This memory is now properly marked as cachable in KVM.
> 
> Does this only imply in worse performance, or does this also affect
> correctness? I suspect performance is the problem, correct?

Correctness. Things like atomics don't work on non-cachable mappings.

> Maybe one could just reject such cases (if KVM PFN lookup code not
> already rejects them, which might just be that case IIRC).

At least VFIO enforces SHARED or it won't create the VMA.

drivers/vfio/pci/vfio_pci_core.c:       if ((vma->vm_flags & VM_SHARED) == 0)

This is pretty normal/essential for drivers..

Are you suggesting the VMA flags should be inspected more?
VM_SHARED/PFNMAP before allowing this?

Jason

