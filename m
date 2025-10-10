Return-Path: <kvm+bounces-59766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F1FBCBFF2
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 09:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 145514067B3
	for <lists+kvm@lfdr.de>; Fri, 10 Oct 2025 07:58:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87FB275AFF;
	Fri, 10 Oct 2025 07:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uj1lN/zX"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010022.outbound.protection.outlook.com [52.101.56.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A89240611;
	Fri, 10 Oct 2025 07:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760083082; cv=fail; b=msOozpi4hYOighwEoX5TerL0WgNooUsqsedMBJmK6/lil3zV+yGfHkkh0z3sxD9+UGRqiHeKMoJ2vc0d95NYyy8YWvt7VFLPtzdZqpxiHQPR9MSDrhHqYFHnN4BfXckztCB0xMfQB8LO4wg9yXn/5lLwc4m9SP/BualrqPsXndI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760083082; c=relaxed/simple;
	bh=RSyiS3mnLafUgmAZmoR3rC+XufedYsZvSGR+tCECiR0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IJ4BPxXKWXlP0jMAj3AJorhM/FZYs+FFIjSG0kC8KM03tk88g2XwXuyIjs2i4GkdbG8s0ix6UXiUvT21vCvCFlkdsr5v6huj63TDBPdZPmCecTSwcuyVf+dts5nL8+UTVBfRxnXSWshDHOLhXku5nqJpIn4P29g58KnhEEIY7LU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uj1lN/zX; arc=fail smtp.client-ip=52.101.56.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=esER1L6tZGZXAMsJ9kOfulqq7JfE7LWodAZPHPBEmrxyZc2tFHRx8/JDUh6TW3RuU9vR31sju+FtLRiC2Uz+qqhttAn/dLFM3fR4JPirZCH9WjoOhjRpJSDYKJhVSdMmRazYA4udmgiWMp5Mc18kiBccAvJq3qkAsnSBepnUPXETwDT9Q8WIpQGNX/KR7Hyt0f829DTiqqJE2yjhI3Frq42yp5iXpbiGmt6bFyk9BqYiQsSVzFMd3eoKv5bbSiN8nRN2LXgvgaToK4GajWGjYHlp5Rsn4NUfRy7Tunt77liwSqtpFCY0Ef/yO5ZVk2s9aUKTtTW/lZchcbRyy0eN4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b34AaXwwXBJyVyZu1hTjS4F5L3KqPZtWrngtpPaJ+T8=;
 b=ETSQriBfiyD2ZR1HsOWU5zQ9+/qroLPry22YCYKlqtV9mXnM2Szsgs+mYQMaCs7iWvOcyjqWEo6NXXaXOJqgqM54bYBROua1nK901bn0ZcdwFSHuj1AVoue1fjd7U/eG+TR6fys2PtgthAbqcGLDUr7xg/4of/A6Aq+jfuPfLuI4FVJui7hxapDHhzpyvWMyyNnsPcE5XRr7kRxV9EUHaQPsjeM8k9GVFeaX3nIYpD0usbTJDXYUecQndaO16qirRHxB8yXEwbdStCpnPpMs4Osay4Ut0CbuM5rf5CTMaTQgour9pLKHQ84OpMxsszSa43d7wnhP9KM02LDUHJVzwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b34AaXwwXBJyVyZu1hTjS4F5L3KqPZtWrngtpPaJ+T8=;
 b=uj1lN/zXEummLqAaZJQQOnIxDaSLPuK9BxG3LEEsqdTCN/ZQrU8UQYyd1Mrmu0dg9UwF8ii7Mk/rUGB6gYXz6Eh6l+kGaYmhIZ/DdY6Iwk+F/NJFgEiOm0g73UpIXrto0v0KhkyHYwYrT0lKPQc0HygCkMQygSTPqRyZcAnkjLc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by MN2PR12MB4485.namprd12.prod.outlook.com (2603:10b6:208:269::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.9; Fri, 10 Oct
 2025 07:57:57 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 07:57:57 +0000
Message-ID: <e9bd02ba-ff0e-47a3-a12e-9a53717dde9b@amd.com>
Date: Fri, 10 Oct 2025 13:27:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
References: <20251007221420.344669-1-seanjc@google.com>
 <20251007221420.344669-6-seanjc@google.com> <diqzo6qfhgc9.fsf@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <diqzo6qfhgc9.fsf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0154.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::24) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|MN2PR12MB4485:EE_
X-MS-Office365-Filtering-Correlation-Id: c3f78387-e832-4744-6126-08de07d2b997
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qzl2YXRkSVpKY1FGU1NvaS9JVGZpd3VPYmNpT1NmM1NEeVZZcXB3cnRLcTdD?=
 =?utf-8?B?M2FRQm9rcFZma3lnK1F4VGVWUTkwU3d3WmZ2Vlo0MTNhRG5lbHhGdURZMytM?=
 =?utf-8?B?d3VMZ05yU001dzFOODBWYnZJUjRNK2xJZHFWYzMwVzRyUExYbkFFL2lWUCs2?=
 =?utf-8?B?ejdRelV0cUhycUhnT08vRmJFNTJmNmdheVFYTWdWNkVwR3g4TTdaakE4SG1V?=
 =?utf-8?B?MGt6cVc2WUZ2alg5VmtPbkJRdm5Gak4yUVhuRkFlbGZtK09SSXVmd3pEbHY4?=
 =?utf-8?B?K3JjM0VmWU84SlJHZThneC9rVzVLL09vemJXbFVLYTFzMktEVHZZZEtpenlt?=
 =?utf-8?B?eE1SbFd0ZndvRHlVK1VQNlVOSGRWUm1GYlNYbEF3ZGducXRvYXl5VGExQzVO?=
 =?utf-8?B?TW9QWHM2c0owbEVTMk9xeWVPMU52ZFlwK1NoWDRVMEVHMWZ6VkJXVFRLTFJh?=
 =?utf-8?B?b1VEOTIzL2plQW5LSGFZYVh0M0tqWU9sc3hQaytRdzdlZ3JXb215UDZ5TkxJ?=
 =?utf-8?B?TzhnSUdGMmVrZDlIRDRrVXQyend3YW92KytHNXFTc0JsVkhEUFF1cDBhNGZK?=
 =?utf-8?B?bTZvL1NycXB2MVhpTEl4OS8zRmdWTzJLdmZCV0ZScTdyOVkydlY0UGdXdUF4?=
 =?utf-8?B?WC95MjVzeEs5akw5Q2VRSU5HRWZOTGgrUTJjTWhFNHhxTW5qTE1RVXFKQVVh?=
 =?utf-8?B?cjNpREUrakdFSEJxNXljVi8vWkw3OVFaczV4YmNUOWh1c1hVWmN6ZXJOd2xx?=
 =?utf-8?B?aUZoS1orWFY1c3ZRSHNYZGFrK1RwT3hrdDB0T0lzaFpZd0JBemdxMXFXZVZx?=
 =?utf-8?B?VDZpSzFUN0xLajArT3orNWhyeUtVZXVweUxZVlRGWW16akdJYm5qWXhOeEo4?=
 =?utf-8?B?T1gzL1RJR1FDUEtkZDNMeW9wSVpYL1YzeGR0RDhyUEhmenFVOHBUdlk0R3ZM?=
 =?utf-8?B?bG9tVVlpYmJhekErWFEraElJRlhmbVpBTnZxam94dGFYUWE5L2d5QnhIMjIv?=
 =?utf-8?B?WXVEOW5WbDFQcTVubG5lQnFXN3pUaERsS0Vod2p4MmtHMFdkbDB2YXV0SkFK?=
 =?utf-8?B?Z1pWRGFqUDhnR1pxQXlNWGR1ZHRaTUhZSkZab1MrZ01Pdno3MHBRSjNyaGND?=
 =?utf-8?B?bE8wN0JOc0Qyb1FVNHVZcnZ6VGV3dkVtUUlqTzh5NERqQXJPVFlxTHlDN2dD?=
 =?utf-8?B?U05WNUE5QTdnWFpEK20xZk9VL0UwR2tPYk9EYW1xUDdBZnVFanZyaUNTaUQ4?=
 =?utf-8?B?TGlrd0s3L2EvT2NORjlibEJwRHpwUUpoTk1ldFM3SmtSSFVvNVpmb0IyVjJi?=
 =?utf-8?B?MEg2QVdXWkpvUWF6NzNrT0U4NkVQaXJHR3lXK0hZenI4Wk1Rc2h6SFlzL0hB?=
 =?utf-8?B?NWU2dUxDcERKSzNKSFFmbXgvOGhvZFF4eGtObmxzbHNpVmE5eFdkblp0aHZR?=
 =?utf-8?B?R1JVMW5OY2hKUkJOTHAxTGR1RGM4d0FDUFZvb3kvQ0VaK1lhUEhQeUxXUER5?=
 =?utf-8?B?eGg3MzY3T0NPOCtrZjhQY29oQThHS0tQYVJQTW5FVHlSOWRCRFI2QWJWR1Y5?=
 =?utf-8?B?dW9UMmRZek1xcDFhYVJNYmg4UXZQMGlXaS9XbWFsWjdmVzA1OXdvQWpuR3Nu?=
 =?utf-8?B?RC84NU5oSzVSZmgzcVZ1eHFDam0xT0N2a3lFNHZXZ25yUHM1TW95M3crVlZw?=
 =?utf-8?B?WEk1NDQxS0tNd1FaMVJZdVN5ZUFBVnBDRGhXVVJJSGJsQnErZW1NTVpSU2hY?=
 =?utf-8?B?WVF6RUpLdzJFSlJVZWdMYzIzeC9ONmdzNUx4V2tyVXlRdFNDaXZUM2dkY1Bw?=
 =?utf-8?B?ZEprcStod1dnNWpUOFFLRHJLK0hqalBoU0s4SjdOSGxkNUhzaTg2MHBDRGEz?=
 =?utf-8?B?RHRXYzd6YzNSek1VWThTUGlkU1QvMU5rNHJsQUJSNCsydyt6Q0c5eEQ1dVFH?=
 =?utf-8?Q?+yTBJCHLZAlyMAgDasyq6LCJuxkS7zFe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGMvU3ZubC9odEF4Y3RvZ1BtRDdhTkpXOVFQSFJxRE12SGNySUN1YVg2YU5K?=
 =?utf-8?B?dm0wV2JjSGZmZWlRNXQ1RExLNzNZWjl4SU5mbkwwVC9zWWpSMEx4VFZ1WnR2?=
 =?utf-8?B?TEtmWkFZcldhbW9NTFNkV0M5eUQ1ZkVxU2tROU9mcjh3SDFwUUs5WC96aHhD?=
 =?utf-8?B?UUtmeURIOTJJQ2ZsR3h6SDM0REEySEd3blEvcVlXZzBGMjAzTjlqRDR6TWZM?=
 =?utf-8?B?cEZqVG1Iai9aZnk1UWdEQ0gyREEyTGE1V2ltZHZ4UmVPc3JyMU9mNWVwUmVN?=
 =?utf-8?B?bmY2WTZhMjRaN3lmNHRXbnJ0dmJyUW1TeElzU3dWaVFPMlgzTTNNdXIxRStk?=
 =?utf-8?B?WjRaK21NU1liK1Vjemx3UTZmTUgveEF6eFE1K2p5aVZtNVBmZUc2YWx2OWU3?=
 =?utf-8?B?UVNaRDkwNmp1dFhmV09hcnpSK0pwdVlhWFJUYVdxbS9FRHZZNlZDbEtUSi9J?=
 =?utf-8?B?dDFBaXhKQlBWRmlCUy9peG96QU40KzRzUHhtVS9BbkM3bUdPRVpKZDlob0hn?=
 =?utf-8?B?aFN2M0Y0d2lmVmZCWXdtQmxGR2hGWnhlRHMreWMvQ3VCOU82cW9rYUFDcW9n?=
 =?utf-8?B?elRXdjVZakZLNnI1MVhjdUp4TDQ4dll2amR4eHRWTTlicDUwYnA0ckR2dEFy?=
 =?utf-8?B?UW5TeVRBb0h0bGZva3psZ3hSZEhveE9yRnRldzZRNWZCYUtLZWhZbmR4MWJp?=
 =?utf-8?B?NVJIN0xwUzBReUVCM3lxSjAwNXhmczFoczFnYjhOL0dtTEVXVEJQbmJoekls?=
 =?utf-8?B?RW1KaUwwNGlKdTNDWFVuTU5aaUZKK2pSTEMrS0VQOWF1NHg5eElYdjV5dXZR?=
 =?utf-8?B?bkI0dTl0M1JhejJQRFBUQ0xPSFRJTG5tZndYenVObG4vN0hnVktRVzNTWXNI?=
 =?utf-8?B?VlN1RElJYUlIUUcxRi91dDdXZnhybzJtdEc1UFRJQkJqN1J5SmN0L21HYkNP?=
 =?utf-8?B?T0tzTnRIYTZMcjZudjRDd1ZZVUdTN0xQY1hTNDA4TDNJVGNtK3FtckRZTkt5?=
 =?utf-8?B?MGRtM2xiTVZ3WUpaSXRzOVVJeDdqMmZIME5VQUZTemI1YzJuaTZobjhHOFND?=
 =?utf-8?B?ajFmOVRpdHFZREdDcEFvZFduY2x2aXM4RVVsRjEvZmtSUG9iRWhldWcyR3NH?=
 =?utf-8?B?eUxTZzJPMWIvaVZWeUhlNGxXMFJuVU5sMWZSNEtFOC82SUw3K3J4YXRCZlVw?=
 =?utf-8?B?cWVpZmdNL2FRbVhlN1gvK0VScWJ2T0I0QlVEdC81QTl0OHlILzVLSkd6U3Bu?=
 =?utf-8?B?UEFKYytnTENFeEdkaGh2RHFldkd2aGxvM2djMkcxd284N1BWM0Q5cDlyM0tT?=
 =?utf-8?B?VEltenRlVUNiamhsWG5NVHNraCs5clRydk9KSy9UMHhmNVJpZDlNODRzOUI5?=
 =?utf-8?B?bm50RVZIWnlJWUJyK2pjQ0hFaHBwQUpzcHRzeGduazgvVjdHbCtKY1NTN3kr?=
 =?utf-8?B?MWRmUzkxaURXRWR5YzNXWTIxdi9ISjczSExKYWJocUhuZzBxcmJrblA1UEpp?=
 =?utf-8?B?TDYrWWtJTm5EME95WlBSNXR6K1JNRHBDY1JtTnBZRjFvYU1kR29qdXdoSFV0?=
 =?utf-8?B?M3R2ZytjRGZyN0p0T1hiQm5oNlc0UHQyRngyUlcwUFlmV0JMRVczVU8vaUVY?=
 =?utf-8?B?NmJEbTZZSUREa3RRaXVuZWd4cWZ2R0QrTFlIUnhqM3VZay9SRnBRMkttNGtt?=
 =?utf-8?B?K3B4ZG45ZXpJRnl2eXJNN2pEalE5WlRkWkRnaldZQW1SUlpicVVVd1NRMmFV?=
 =?utf-8?B?Q3U4bTEzTldxNkdGdXkxUnlzNFVXcGV0OE53cHZMRDB3SWFpZlhCUzJQejkv?=
 =?utf-8?B?ZW0za2xPTWxSNkRWL2lsaXJlSStTLy9KRkdPZzR3WmcyL3dlQkFQbzVDeFJF?=
 =?utf-8?B?Ri9yakcwcUV5bzRZWE01V21NRGlVdmFrSVpKNW8yczJHT09IQjhnRjAzK2J0?=
 =?utf-8?B?UjgybTFJd2pyaWhqZ3B6eW5ianphSm85MExtSFM0MGE5bWMvSCtjSWVkSGdh?=
 =?utf-8?B?ZUJwSDl4WlBvYTdlemk4KzZUdVh6VlFuVjJGS0xNRWpYZ1BkblBwY3VLU0hi?=
 =?utf-8?B?SHNaN3ZPSFNaYkFucG43czdpTnU5VHd6K1IrYzJadExGQUFpN3cvZjVwZFps?=
 =?utf-8?Q?z1MwMPCSOKjG66sx+measMySx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f78387-e832-4744-6126-08de07d2b997
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 07:57:57.6059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldM4lAA9n+B+Jc3Uz6uUo1tkh7kGYCwe3Kt6oopQj/hXbd6Cwrq8LZVP3IF3sd4Uaz7FzbOUH/iPIwd2wvph+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4485


>>  
>> @@ -112,6 +114,19 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>  	return r;
>>  }
>>  
>> +static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
>> +						   pgoff_t index)
> 
> How about kvm_gmem_get_index_policy() instead, since the policy is keyed
> by index?
> 
>> +{
>> +#ifdef CONFIG_NUMA
>> +	struct mempolicy *mpol;
>> +
>> +	mpol = mpol_shared_policy_lookup(&gi->policy, index);
>> +	return mpol ? mpol : get_task_policy(current);
> 
> Should we be returning NULL if no shared policy was defined?
> 
> By returning NULL, __filemap_get_folio_mpol() can handle the case where
> cpuset_do_page_mem_spread().
> 
> If we always return current's task policy, what if the user wants to use
> cpuset_do_page_mem_spread()?
> 

I initially followed shmem's approach here.
I agree that returning NULL maintains consistency with the current default
behavior of cpuset_do_page_mem_spread(), regardless of CONFIG_NUMA.

I'm curious what could be the practical implications of cpuset_do_page_mem_spread()
v/s get_task_policy() as the fallback?
Which is more appropriate for guest_memfd when no policy is explicitly set via mbind()?



