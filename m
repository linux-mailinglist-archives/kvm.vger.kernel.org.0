Return-Path: <kvm+bounces-71917-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBh6EKfAn2lOdgQAu9opvQ
	(envelope-from <kvm+bounces-71917-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 04:40:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AEFF61A0A02
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 04:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 79A3E302A2FE
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 03:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D05B83803FF;
	Thu, 26 Feb 2026 03:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PwWS+vD/"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD10E378831;
	Thu, 26 Feb 2026 03:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077199; cv=fail; b=UoD3ro/++ea/aIMSthyVXVYCbOz8k5dFRv7z1VuDOnet62t+WtPVDNY6s02AnFn0hbK+T3MzuYPFSCsTi4uvswK7TIW9c/BzKOezIYiLNSgJofBgosHe6rADq+qcLffSYNqcjIocVA2DcyEVgGl0fvmZHBC7jD3c3EPgfRMG9Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077199; c=relaxed/simple;
	bh=umaAVz26CgS2g+9Rnv2SRhYSigvUR0njvh9ty5QdEBw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IvbBrXEW2oWWlVsODOYNU1pNGP5wC7WWEUX+sH2OYnsTk+SeigyT4gMs+x+28gJ0LniqpE2GFfOgB2ODLcviLFV5X/lF8rWaQEG5n4pM2yqr2vHTYmb4U03D1tzXenU7tu7Rbva7gG3X7QXkn6fmTTwsgLHHPRdh+PWnCpvDRzs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PwWS+vD/; arc=fail smtp.client-ip=52.101.46.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wL0y28brtLDrLkcjqEu1eIzMGnoU/OTeG30YAm5fbhEdXTUko32A0eknPqWycA/tjvkP/1Cbc5wSpyDceapcNZq/nwmV5ZgSmEJrsUVDtPWFcMn+gdBIGNrsB96KZwR65JnVqhMqX84oP1tc0V54sAYJkmLk2dbiGI2S4aPPeimLPQTz3IfOeyy/QKm+uRwcJwjQDFhw0xFFSXP6et07k0SNVyo9wAgXfUkWmQQhSIoYFlYM8+fax/7+oxcJ6Mr6FrkbppIg1Wq/H/en8c5f1h0KElVIEuQtKquUifSlBm4CoEy2nPuAfQxkOEF1SYCy5oLHSOIRq79gO4sFQp96tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lb4o1EF45+0Ug01YaWxF9vXxS78CYRqkU0m/GX54T/c=;
 b=Papnts6IYoJQ4co1TF59NNOghlusFch+keNypdQVMta9BMfh6Y7fkqYUvIrcFUJmCrujwUG1A2v/CcHrZJSQDw7RPcnvuRHliC0T+EBbDauEAWYLL/UsDkBOhahgXMogUrnvymFKANYQx9PnmVovnIYEGJjcgNIM9P/tnflbuBUTMN07/Ov6joDrTgHQVVhQUQF4bJDJfBJDXIOVDWa8k3ufbgIiA4gYn39PtY7kN5QLilj5JOtRCd8Us42OB8sq1EXVGs5Dg1w4qhLf82B9PDjfj0AwSUWU4KDAERFotZ/J2qCAy+qOwSA+qatbp6mWmUrqmhEWnZEzjlwB2JXlGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lb4o1EF45+0Ug01YaWxF9vXxS78CYRqkU0m/GX54T/c=;
 b=PwWS+vD/iZzmX8Hbd52ZV59hNUu0SxKIdU8UfktJn2j4tf7YsnfqyA+PxUnO+RBWpzZmeC3SXMTR2M6bZ/3uJfLceGaa8seoGsUFCs5rXvcgRt90hGfe9Zxv67uLF7nUBf7lF/W4CjWPqCl3T4UOv47nJorGcVZkSWCQbbQh0EE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by CH3PR12MB9729.namprd12.prod.outlook.com (2603:10b6:610:253::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.22; Thu, 26 Feb
 2026 03:39:54 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.007; Thu, 26 Feb 2026
 03:39:53 +0000
Message-ID: <428d4373-1b78-4882-baf9-1df563f66a86@amd.com>
Date: Thu, 26 Feb 2026 14:39:37 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH kernel 7/9] coco/sev-guest: Implement the guest support
 for SEV TIO (phase2)
To: Borislav Petkov <bp@alien8.de>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Mike Rapoport <rppt@kernel.org>,
 Tom Lendacky <thomas.lendacky@amd.com>, Ard Biesheuvel <ardb@kernel.org>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Stefano Garzarella
 <sgarzare@redhat.com>, Melody Wang <huibo.wang@amd.com>,
 Seongman Lee <augustus92@kaist.ac.kr>, Joerg Roedel <joerg.roedel@amd.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Andi Kleen <ak@linux.intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Tony Luck <tony.luck@intel.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Denis Efremov <efremov@linux.com>, Geliang Tang <geliang@kernel.org>,
 Piotr Gregor <piotrgregor@rsyncme.org>, "Michael S. Tsirkin"
 <mst@redhat.com>, Alex Williamson <alex@shazbot.org>,
 Arnd Bergmann <arnd@arndb.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 Xu Yilun <yilun.xu@linux.intel.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Kim Phillips <kim.phillips@amd.com>,
 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Claire Chang <tientzu@chromium.org>, linux-coco@lists.linux.dev,
 iommu@lists.linux.dev
References: <20260225053806.3311234-1-aik@amd.com>
 <20260225053806.3311234-8-aik@amd.com>
 <ABE746F3-53E9-4730-BBFC-52111166A7B9@alien8.de>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <ABE746F3-53E9-4730-BBFC-52111166A7B9@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYBPR01CA0144.ausprd01.prod.outlook.com
 (2603:10c6:10:5::36) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|CH3PR12MB9729:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dfbbf21-72af-4090-edd6-08de74e8b41f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	Aw8xLrvO31yocoThGq5d3ec/MxRpZU2WsfayqsVH9nviIQopzWmMNyNxZ1hkQN70D4vrdZB9GgWcDlZhcVfz4p4PpZHR15cvC8R1ZxNnKSQbRpLQ9k1At9uc80Alm3RYDbqmbyUQIN5FLpngzi322a8F3IJ6sqrE0Ke4PhiSaU7M2Hd8J1xzjdlFHWXHe038vReflpzwSPWPPdRujMvAZoh657Mhfjg+DgQ9HnrAWflYpdhSk5znxv9PnRUhktkAZLL3MYpsfJZu7qyX/6ORL5QD9hp3nhf226fd1YY3haqE/WUIUHi7IXTqrfyF9DJHzjdEm3EgobSroBPkNuF548Co+z5E8pyl5JLYawD/tDPP07HcCAp1gbjRk/LgCZU5Ga2ORjnj5ytGSQajnnP1XUUWpNxEjDKxSgTklUKOYXHQVekh6sb7loonfPkrJam42MMOBA4+KJ8/Du8yD7N/uG2t8e5fLBQKbx4NdrWXOmWQhCGmzX+v7ANjQVduCDGFVKZf/UoFbU34LWwTNtseQ5zSYdaowrReq2BG8kRXbuVYs/UpsUL5u/jMxFcADMfC4Of4W1jtxGMqPEvRv7E353jcQAAxl7rKazagY27rZSMtAEuKDq32CJoMOOio7aMqN/WpN/mowZ0bCh3LZkSvdWqD9CIEopB7FFdV3NlaK4O/gSgLICtPLynzZ3U0QhKALXQ0+RyqE82b4ehsWxeAhP+EHPDM1CXBLkOqRghghRY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUZDVnJJcTh6Q1J6NWxHMXczMjlpanJ2R0ZGamdYNGdybnRNbHdLVEtzbEZN?=
 =?utf-8?B?c0grY204R2prRFBUUWszd2pFNVQraTJSQUQwVG1sb3NPOGxIcmUzV2hoalBD?=
 =?utf-8?B?SDZ6RWZWUnNyQTlqT0wxK3ZTZ2lzQk1PczFaVzZ0MWNSejRFRWlBTEhpZ2FH?=
 =?utf-8?B?bGN2NzVGQlFSN2ltdk1sUTZhbzI1QW5PTGFVOFp0cDBTZndVaWlkUlNYYnVi?=
 =?utf-8?B?aTcwdHA0Y1ZVRW5KQ2lmcWR5RGlVRVhaNVZFUkhTTUNDcjFnazZ4djhUYkd6?=
 =?utf-8?B?a3lPbWpUY1kzT0pkaXdOQVptTGQrUTBqamlYSmJpNGNGUlc5bGMwYlVLMzJu?=
 =?utf-8?B?eTZ0dmVvQ253Nlk3OFR4ZW5HL0xoaFVSbXhtVDZqT3ppaHdvcFI5MUgxN1Vw?=
 =?utf-8?B?V0RsSkZ0WjFUQWJDSHRaYm4zZGdzTnYyeC9rcXhRL2RyUERiNGYwT2k5cXhC?=
 =?utf-8?B?VUFzbmhrQWxjdlpNY215d0toK3FwbU5PL1IxcUxZTXY0N0x3VHYzOFJVQTVW?=
 =?utf-8?B?NFN4WXJzWEk3RWxXUG53WG9DcmMwdmhGd3VmSVZ3aTJ2WjdlWmVnam9mK2dp?=
 =?utf-8?B?WEpJbktUR0tYV3Z4ZXZsUDFaRy9YMW93V3VPQk4zaDdmWWJEZ2tKWVJjWmkx?=
 =?utf-8?B?VnNSbFJ6UW4zVWNveElnZGpRK09Kb0RZS3pMbkJtVVhRN3V4S2xYTXFEeXhY?=
 =?utf-8?B?RTRXZTdEUnJtbkNsTGFDdzh2ZkZLb01GWGpKNUhYNDlCUzBLY084KzdWRWE1?=
 =?utf-8?B?NTQ4L3F2VFhETk1kR01obUdkUVRjMk1BVGl1RWkxQ2pLSGpRclRvVGNxL3Ir?=
 =?utf-8?B?blkvS0dNRTdxTEc1WEs5dnNZaVE2Y3ZFRzdhOW8wQk9ram1IZnVVZDgyWUl0?=
 =?utf-8?B?UWVNQ2wrQWhKTUI0dkNQOFBBZHdlMFp1ZDNNa2VQNnhtK2tmQ2xEWnphLzN5?=
 =?utf-8?B?Z1dNUE1CUEVtVjlNUXhUUUVuam5vWFVOd2RzdDdrN0dGNHB1VG0xSFpna1di?=
 =?utf-8?B?dnJyTEFnZEpGd2cxKzIrQUJzSHRlWG5ueGVCRDhXRmVONFhzL1d0aXl3WTBl?=
 =?utf-8?B?TkNPdTduT0dwQ1BiTng1cm02MU1ZS2psd05yMU5CQnBJV1pWZVBKb3NTY3VK?=
 =?utf-8?B?RWI0N295TmQxaGQ1ZWFsMEtyemRzNFhWVVdQazdETklKNjRucU03OHNMNmFu?=
 =?utf-8?B?UGZ3cHNURGNLRzlHWm0rMFMzM3RLUk91RkNOZjg0bWNuUlByL3poSjVEUXRL?=
 =?utf-8?B?NnNycUdyclF5dVhSTWVHZEpiUmh4b2JYMHlzUTNiRG4xYnhCUk9uNXRKTnF2?=
 =?utf-8?B?cCtBaHlsWWRFTkZ3T3ZtWGtkM2pzWnM5enNVcjdXalJjeVU1dmtJVStDOXpP?=
 =?utf-8?B?cUMrTUtjU0ZNSXVCUHgraG95UWYrUjQwSEtTUzFpQ1JaK0xnY1R2MEZUWXlu?=
 =?utf-8?B?alJNU1BhLzN0aDVWZVNwMHE1L3o5Q1VaSEU5cHFzb3hlcGp4a24rOWVoWGJ5?=
 =?utf-8?B?U2xLSi9zWXN5bnBrTXNncHBEUW1TazFxSWd4MzFBbjl6eUF0dGZzWnJ0SXgv?=
 =?utf-8?B?eHVQdUwvN1BiVjFSZTNsMjFVVHR5SlhJbGc5a3h2aitkbDVxSC9LMFZ0djBG?=
 =?utf-8?B?THVFeW1kYVFOcDh3L2h6cll6Qk1SK0NvTWN3Q25PR0lVNlpGdDhBM01qMnBE?=
 =?utf-8?B?SVVycndWcEE4RWZlR3JVdVhjS3UvaFkySmdyeFhkd1F5T1ZZT3lxYmFybkYy?=
 =?utf-8?B?NnpXdXJRK096RE5sL1JjVU9oSVNkS0JhcVFoLzFVYjNPM0U0akNtOEFodTZC?=
 =?utf-8?B?SmxGVjNPSXBDczkwemx5NE1wdUdCOFdlWjBiTDJKOG5KYTZEdXVRWGs2RFlK?=
 =?utf-8?B?L2xYZTZYaTZrcUF0UnoxWDY5SzZsbUpmcTFab0p5eWdLUWx5WE1tajRudUsr?=
 =?utf-8?B?MFl0NUxCVkJYcVdCVTZmWndveFhyelVjL2ZvVThHZE1aV0xJSWJrK1pGVDF6?=
 =?utf-8?B?VlIrcDZCSDJCeHRGWCtGVEY1WkJnZjFIR2lFbHVibVVIcGlRU0hsRWxLc3FW?=
 =?utf-8?B?ZnNBUzdwdnBybmk4WWtLbFFKV3NUb003Q3NueGlkR1cyRTZwNXdKRWF5Zk1p?=
 =?utf-8?B?RmpZZmhtQ092bnhzdEVIY2ZlKzN0YnUxaWJDSU1zZy93YTZkZXc1bkdCVThs?=
 =?utf-8?B?dTZ0YTkzNWdZYXB6ZHNjWTVhNEI5QzBibkxrT2c4UUlNb1hCc1FJZGdKckhX?=
 =?utf-8?B?aEs1VjBSVkZxMXF1MU02VENVdXU2RlUvRnVDSFRUcm05L1hOc0dvT09CRjg5?=
 =?utf-8?B?YVlrZHZtS3BTY0s5dzFGZXc0Q0Z2NHc2a21qeHJiSThwRk5iMzlMZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dfbbf21-72af-4090-edd6-08de74e8b41f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 03:39:53.8248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WfAtARj84MyGeJ9k+qnQGb95s+FqHTciYAOio7Hv2dgaPsPKQjduMp16IcWl5vRUyba/cO9yMnwE7GGVdscR3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9729
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71917-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[aik@amd.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_GT_50(0.00)[57];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim,amd.com:email]
X-Rspamd-Queue-Id: AEFF61A0A02
X-Rspamd-Action: no action



On 25/2/26 17:00, Borislav Petkov wrote:
> On February 25, 2026 5:37:50 AM UTC, Alexey Kardashevskiy <aik@amd.com> wrote:
>> Implement the SEV-TIO (Trusted I/O) support in for AMD SEV-SNP guests.
>>
>> The implementation includes Device Security Manager (DSM) operations
>> for:
>> - binding a PCI function (GHCB extension) to a VM and locking
>> the device configuration;
>> - receiving TDI report and configuring MMIO and DMA/sDTE;
>> - accepting the device into the guest TCB.
>>
>> Detect the SEV-TIO support (reported via GHCB HV features) and install
>> the SEV-TIO TSM ops.
>>
>> Implement lock/accept/unlock TSM ops.
>>
>> Define 2 new VMGEXIT codes for GHCB:
>> - TIO Guest Request to provide secure communication between a VM and
>> the FW (for configuring MMIO and DMA);
>> - TIO Op for requesting the HV to bind a TDI to the VM and for
>> starting/stopping a TDI.
> 
> Just from staring at that huuuge diff, those bullets and things above are basically begging to be separate patches...

I struggle to separate these more without making individual patches useless for any purpose, even splitting between maintainership area. People often define things in separate patches and then use them and I dislike such approach for reviewing purposes - hard to follow. I can ditch more stuff (like TIO_GUID_CERTIFICATES - just noticed) but it is not much :-/


-- 
Alexey


