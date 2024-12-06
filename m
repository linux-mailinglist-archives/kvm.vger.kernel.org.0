Return-Path: <kvm+bounces-33191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CAE9E655C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 05:19:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1FBC6162F0C
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 04:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44805192B76;
	Fri,  6 Dec 2024 04:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2WyvUXZV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9637ECF;
	Fri,  6 Dec 2024 04:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733458772; cv=fail; b=VLiDcAeekdJ5IpbhBcXnNFjQKkk01JDjmDaxhmWhdG3L9Ka9g4TlmlSB9BlPsxSJ5d5Is/cu5lZmN5W1G9gAi1lolW5UFFNY1t9dwaHPW+aXiYM47ZMHVUoE4Iqh9qj/Cblm2o5r93Hmm1B//eDVa0/+CsoqGN9cSIKjnI0FJ+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733458772; c=relaxed/simple;
	bh=qoblRAJPBMWE7b4gftEqR3uro03C73ZLmA4u9LGCgI0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qKO7qrXWed4kWztAhU5r0dLMz2dgo0bHaOpIEyn2Dln2xiAFQECU960cXr8+O8vNy+elYLA9pMSpRtOK9WekI6078GmK+HDqRBvp6dTnwqMYLN6HU44hnvptcVWKd+dYbXkPGKwgLs4kY8GkebnkMS5bvEYIUnCtUxmnPbW2zVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2WyvUXZV; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=syCsFRSLNzuYpP4PdpVHtsjzukMgGpkSFRPT4cXrbuYA+9P29OSL52u99nNiy/Zjxwkx5zzjXkDMnfwo94+HaqzBAZz2RBFoa7uJgdGzZKQ/UlSS/LrkY3RGssH/CNJZQICCySUtd4am53x4JiWhUGI5l2KvEQMgq5YIXjWxuVLi1jV78Up8F48AflmUjzZVaf24vOXuGLYXb4Sn9bZkSd99L/cxSG5z4CApoUwGwHdCmiaL3YqnS2JkYlOvBj+FCSwDjQ3Pvhwte7OW/l6cDEOytVJXxlgPfkKUX4vXLrgRuZIo0ox02FQYdCGDncjkZqPoYQbDkUItTWpWYN+WXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gjmDhmDv9EpKZwXsFevDc5MKUxsK00tEGXC1Rsy6D6c=;
 b=ifoGXLzWIxgWn8m+B7GOdi/QfyhYwWbJhV9xrvzs47B2iDwhCcLlOIwBC8ycgTnuxmNxWdY3eAKlBBdGvpxfHEph24SyqgQj2xPMaOShETbrIn1XBkgAUjkn9Xpw/SEU1i+TlEbvc1oBy2hf7ZExvdcMJ73xJzluWkSOqa15erheQ8v9OG9Pf78oKotzkS344U/zsE8/xnO6GgAGT0bJ3RlKX/Ek1TewAzbtTHBd+Wv9bjQq8vVridMkimNOr1xmDBe07xDDDgaAE5N3/Sn206Yc+YoDqWZmFBsqnyKKQDeCVWi9WIkETVLBm/vqHdf6NPMoDsYidGbPukth+7z73A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gjmDhmDv9EpKZwXsFevDc5MKUxsK00tEGXC1Rsy6D6c=;
 b=2WyvUXZVc9W5sCMwKtvU/OXxDcwOI2w0Ix99Mwxec1aVV70ndGGgZbrtfktoa/lZM+lY050dtuXCe9RZ0ZSxOgAhsFOsTDbIm9EaS6ITh3La1NKaIJYx4qy4KuWfdHrkfggYRsCER9pPiJSoexLirE6/hUKY+QlImKWmPhFxR1c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN2PR12MB4438.namprd12.prod.outlook.com (2603:10b6:208:267::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Fri, 6 Dec
 2024 04:19:28 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%5]) with mapi id 15.20.8207.020; Fri, 6 Dec 2024
 04:19:27 +0000
Message-ID: <7925f569-f660-420d-abdd-32a3bbcde164@amd.com>
Date: Fri, 6 Dec 2024 09:49:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 03/13] x86/sev: Add Secure TSC support for SNP guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-4-nikunj@amd.com>
 <20241205110455.GCZ1GI1_vv5EIMJwXl@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241205110455.GCZ1GI1_vv5EIMJwXl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0045.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::8) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN2PR12MB4438:EE_
X-MS-Office365-Filtering-Correlation-Id: 1926bba6-f4e9-4adc-fd62-08dd15ad2c2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVAxL0VhcUFnV3NuM3lmaHJUR0QrTHFScmxHWjA1aVd4NkR0VzFmVE03LzY1?=
 =?utf-8?B?NElZMnJjRWZySG1oSnU0OVRwcEVCb0F6bGR4MjRHZVJJSlpYZE9xQWtlT3Js?=
 =?utf-8?B?WmFpQnU4MDBBb2FhT2JQY2lrTUwwQXVIT1Z1R0t1S1hkS1V0VnJ5NGxCdng1?=
 =?utf-8?B?RkpnOWFkSXZSMkM2VndNeHlMNSthTG1FWndDeDRrWlQ2S1hUZlkrVUxibDBP?=
 =?utf-8?B?VDBTQ3RZMkdVNi8xM0RJdElyaVJxTEtXVyt6cjd0YWdqdmZXNTY4djdVeXQ2?=
 =?utf-8?B?VmRDWlRSM0loejZYOHBOTmNhUmZHQzBZdVRUWFFkNEU5VWx3cUdtaFExZE0r?=
 =?utf-8?B?OFRmRmRwYmVnZU9xYmVFY2Vjdm5yRnovT0FHQmlaQnJjaCs1L1Y5a3l4RFJ6?=
 =?utf-8?B?cXFSdmQxN2pGRHp6dHE2OXhDM1VFaGpBOEFHaHpYMTIvK1h0SGU1bHp0MDRz?=
 =?utf-8?B?dFNkdFoybGZKRHJCYTVscnp4UERaNmYyN1QwSG9YWVVOWGZiMHdCWDN1VDNU?=
 =?utf-8?B?QU4rWkZQckNYRkFudFRTUTFhSkhRVlkzeFNSQWc2UXUzTmx1bEUyajlvK29h?=
 =?utf-8?B?cGJYQWxhdG1RTHdPc2c1cXZjUHI0SWZ6MG9KM2ZHRm16clovcFhoY0pUR2E2?=
 =?utf-8?B?YW5jSEsrK1RCVDhpb1JmVnRLc0FjbXcxV2lab3A3OXVIS2xsV3hXZ2RnQjdY?=
 =?utf-8?B?MjRSM1lwUHBqVFFQVlROR1Y5ZVg1ZTgzWm9EUHN2aFBiL3hqZC8zaFlLTURl?=
 =?utf-8?B?aUQrSHk1aURxdFRzZ0xFU0ZoamlPeS9oRUZ2VHI3dGFTNE85a29PZUx1b3M4?=
 =?utf-8?B?cDRUZlFtUnlCemtYa1RWbUhvcmZxSVc4Z1JGVjZzK3N6enZMV0xkSnNXam1I?=
 =?utf-8?B?SWhjVGhvQTVHMnFlVVhKenJYS3I1RmJORmZZaTZlcG51N2FvYU1aTmJURktT?=
 =?utf-8?B?T0g0NjJXd3RvcHU4cURWdlZVdkVhZmFkS0dhd0tJN2lYakpvSDFUcHp0cHZN?=
 =?utf-8?B?bDFrUHQvMUlrWDJyL2ZhSjhHS1pqemE4SlFCSVNSak91MnErbG1OUGo4dGM1?=
 =?utf-8?B?VDhSVHBhTnl3SGsxOEhYVUZZRzE3RTFMNXNDdHhLVXZIVmI0Sm03Ujc5eWRu?=
 =?utf-8?B?bkFhaGVaY0dhcUJQSGpoRWpUZFU2RE1VSVl2amVVTTI1VXNvcFFMd0h4TW1j?=
 =?utf-8?B?UXRSRVBtUEF5QjY4c0dyS1FSOHFNL3l3eFR2WHhzaStNc09ZSWhLSUtyS2xq?=
 =?utf-8?B?Yi9BTWZOWENpYnM0bmhONWNENFNBSk5wRjcvaThTbkN0R01RaUxsYk1jSlhD?=
 =?utf-8?B?a01Sa2E2SEZRb2VzdEhIUmZCZmpvN3dVYVpKcGo5d1QzSXRPdjRUdE1pbEs3?=
 =?utf-8?B?d2ZpdFZ3ZUUwZCsvb3dzSTFCd2VkdHpIMG11N2dkc1lxRlp5UitYaWpwT01L?=
 =?utf-8?B?US9nOG5KbXd3MFYvTDgxYzNlRnZ4ak10ZTUyc0FxK3RmNWM3WkxwL3E4Z0d5?=
 =?utf-8?B?YnZvMnh4MngxdmIrZDh6WHd4VlB1ekhJY20wVENOTGVDMUgveEd4ZFdESC9O?=
 =?utf-8?B?K1BLVUR3bTFlSzRGNTJ2eXBoWjZHYmdhblQ1ZFkrZzIwQkRLZzNUTU44VWRF?=
 =?utf-8?B?THZlVTBiQWxxR3NkOGYrbVV3OForckZFUWR4VTE2YjhwMDhVSjNLdVVjK2d0?=
 =?utf-8?B?eE5jTDVsK25CQUZub2piN0wxeHRJY3J3bW90dUlmdkMvWmxFczh0bk1iRWhP?=
 =?utf-8?B?OGNvSm1xZ1RkdjA4QTBKd2grMmgyaFdBUXM5M1NRQkFQN3dqT0hmYmJMakFH?=
 =?utf-8?B?MzlUeVdqbjlFN1k4UVpwZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UDI2QXNjbTNWQXI3cllGV0hSK25mOGQ0YWdpN1NFQ1pQZzE4MXZDaXVDNlFP?=
 =?utf-8?B?NDN0WnduU3ZJb25GeC85SnBKb0VFOW1yVFVGVlFINGlVSHUyUnpqaHpDdEc3?=
 =?utf-8?B?ZWNFUmZPNVBkelY0dngyb1dTUWNrZTlBbnBralF1NnJUdWpjYWI5ckVUbHBX?=
 =?utf-8?B?aHlZWjJHTWxDVEZTSjBHNDBNRW5zVkE2WjcwaWpnREZlallNVWR5MnRZbUhp?=
 =?utf-8?B?L2N3Yk9iNHZiQzhwaVBVZ1pBR3gvb1Juck1TQ2g1NUtJTlR6amRiMlZVMXJB?=
 =?utf-8?B?OTdUSjFhM21abkF4TUZGeC9sbXI2VjdocFZ0b3NPRG95UitjbkRBYkk5RDlx?=
 =?utf-8?B?RWJ0T2ZJMDdTUTBiaXIxRHI2M0E5TXI2eXNmRUVKVTAxTU5oSUdJczRCeGxx?=
 =?utf-8?B?TGRhYXBYU3I3VFQ0UVYrTnNqdWhqTUhkSXcxN3ZKbVc5RDZGbGVjTUNIVjVJ?=
 =?utf-8?B?U0UvYkUvMDExaXEvV05HR0VSbktWMnplbUtnaHNnb1lqclVMSnJMOWFRZ20y?=
 =?utf-8?B?ZVNnTWJlTTRNUHZ0RkE3VytTNnZZb0k3bzZkK3lCTUo1K3BLZStLaytIUTBH?=
 =?utf-8?B?czh6aGZKK2Q0OThhRFE1dVN5TlRRajNheEtRWVhEaGZqSDV2Mm96d0NHdDdi?=
 =?utf-8?B?MkVZSHZFQ1p5NWY2NnB5SENDam02OTZEcjdkUXZQUEZXaldaRFpFTmlqakc2?=
 =?utf-8?B?T29Mc1RxKzV4cXJmNlJlUUpvVERhZ1A1WVEydWY5enlTQ0hXbk15eGNKT3NO?=
 =?utf-8?B?QXFISGtkb01hUGtBcTVoaDNlR210TEFwSVRVSnNPM1BJdEV2RzE0V0VFUWtX?=
 =?utf-8?B?TFJmaDZGTUVxKzVIcEoycGNyWUhoU2lmWmxpekN3TExibjVCTEdocDBiZlJR?=
 =?utf-8?B?K1I5TEg0cVZCeVp6UGNSa1RtS3YwOHhTSENUV202VXpzU01VN1htaVJOTzFF?=
 =?utf-8?B?d1pvZjQySmJJQTBrK3B3SEJLOVljVTg2TUI1KzZaTTUvd0JzcTRncjBDTkJa?=
 =?utf-8?B?dDc0SnNJeC9PL2psZ25WWGttdUVvTFN3QmU0VHV5blptZUt3MTlqM3c4ay9y?=
 =?utf-8?B?Zkl1MWJ4QUxWUGJoWXpRTmFLbFZzeWQyL0NteWNPT2xReEtBTkpZRXpwc1lS?=
 =?utf-8?B?aHhUV1Fic1Q1MDFaRnp4NkVNYVZaNEJ0akdlUXcwRHQ4NXd5WUdHYnVmdVVs?=
 =?utf-8?B?VHN2aXVteXIwWWthZ1lSTk9aUTVZZ3RxUStDUEZRV0tsTXBDQW1RbWxHRURx?=
 =?utf-8?B?Tkc2Z2NhcnhqUWtEK25NQXNxSmNYZlNrNFZRTTR1L1BseVphMEJZS2dXa0F6?=
 =?utf-8?B?NmhJMVJUSEFQd01BL1JFS3BicHZhVlkzcUlkWWUrMEdYUXJROHdzdmF1YXl4?=
 =?utf-8?B?K2J4N2k3RlRBNnhKVkk2OGNiNE92dzdIbWNKcytab0w4ZVBLcStFU2JLZ2ow?=
 =?utf-8?B?NXgrZUVzemtIM3ltMlp5eElqajgyRHErd05JREU0WmVQMlFLOUNWMnNtQkZ2?=
 =?utf-8?B?bmdpbmxML1l4UnZKQlQxYlA5MlZrSWV4bS9FOEk2OUplNER2S09GMGpVcXkw?=
 =?utf-8?B?SVVqRmFCUlErdDRNeDBmcE44MHJEc2dCdUU5UUFDWFRQVzFlTGo3VUZZc3RM?=
 =?utf-8?B?cFhlZFExMitpeUN6T2RMTGxXaXY2RndYdmdlRFp0WU81bjZ5UE4yZ0F0WlY3?=
 =?utf-8?B?SlhOSFRmczZaRkp6VUY2d1BpL0pncTlxSFlJQ3VLTFFJemwwcmRkbW9nTHNU?=
 =?utf-8?B?QUgwN1I3Vis4Ukk0Ymo2bm1aNkQ4ZWNTM05DTjR6dmdNazExOXhMZmxYQUEw?=
 =?utf-8?B?TGt4eTJzRU9rQkg4TlVIeCtHNEdSR1RKb3VVbVh5YjBXUm1GK0ZvbzN3bnkz?=
 =?utf-8?B?WjlBZEpneE9YdzFaczB3aE9kMElGVEY0eDltcVJmQ2cwMysydTVubzhob3I0?=
 =?utf-8?B?ZnZaUmtycGpPQlI2UjR3NnJKaHJrRHVrYUVHWkJ6Ym5tK1JEbGpRTGhMbjE5?=
 =?utf-8?B?dWM5Z2pNWGRnUTh4b0IwWTMzd1IvMDJYRUFYV2gzLzB6cVlzOVJwbUUwR0lV?=
 =?utf-8?B?NWRicDRQS0FTU1ZGWENiaGt6eCtyYnp2YmN6Z2o3dEFabkN5WmNUOXFnckMv?=
 =?utf-8?Q?Akqn4n5tAL8w0gO8jwnpNRD6I?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1926bba6-f4e9-4adc-fd62-08dd15ad2c2b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2024 04:19:27.4532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uFjjwxevlVL+m1Vqz7cOVaFv0GwzOHCokZLBkmXN+gPGYVo0+a1FzIDt+bsObM5XE1i/QFbzXF8aDYIi72EsPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4438



On 12/5/2024 5:25 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:35PM +0530, Nikunj A Dadhania wrote:
>> Add support for Secure TSC in SNP-enabled guests. Secure TSC allows guests
>> to securely use RDTSC/RDTSCP instructions, ensuring that the parameters
>> used cannot be altered by the hypervisor once the guest is launched.
>>
>> Secure TSC-enabled guests need to query TSC information from the AMD
>> Security Processor. This communication channel is encrypted between the AMD
>> Security Processor and the guest, with the hypervisor acting merely as a
>> conduit to deliver the guest messages to the AMD Security Processor. Each
>> message is protected with AEAD (AES-256 GCM).
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
> 
> 
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> This patch changed somewhat from last time. 

Yes, most of the change was dynamic allocation in snp_get_tsc_info().

> When did Peter test it again and
> Tom review it again?

It makes sense to drop both.

> 
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index a61898c7f114..39683101b526 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -96,6 +96,14 @@ static u64 sev_hv_features __ro_after_init;
>>  /* Secrets page physical address from the CC blob */
>>  static u64 secrets_pa __ro_after_init;
>>  
>> +/*
>> + * For Secure TSC guests, the BP fetches TSC_INFO using SNP guest messaging and
> 
> s/BP/BSP/
> 
>> + * initializes snp_tsc_scale and snp_tsc_offset. These values are replicated
>> + * across the APs VMSA fields (TSC_SCALE and TSC_OFFSET).
>> + */
>> +static u64 snp_tsc_scale __ro_after_init;
>> +static u64 snp_tsc_offset __ro_after_init;
>> +
>>  /* #VC handler runtime per-CPU data */
>>  struct sev_es_runtime_data {
>>  	struct ghcb ghcb_page;
> 
> ...
> 
>> +	memcpy(tsc_resp, buf, sizeof(*tsc_resp));
>> +	pr_debug("%s: response status 0x%x scale 0x%llx offset 0x%llx factor 0x%x\n",
>> +		 __func__, tsc_resp->status, tsc_resp->tsc_scale, tsc_resp->tsc_offset,
>> +		 tsc_resp->tsc_factor);
>> +
>> +	if (tsc_resp->status == 0) {
> 
> Like the last time:
> 
> 	if (!tsc_resp->status)

Ack.
 
Regards
Nikunj

