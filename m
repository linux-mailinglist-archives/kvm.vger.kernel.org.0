Return-Path: <kvm+bounces-42285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 771EFA773C3
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 07:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C4B73AC029
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 05:13:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 583AA1A3150;
	Tue,  1 Apr 2025 05:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KYp7a7CC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2064.outbound.protection.outlook.com [40.107.236.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999A915B135;
	Tue,  1 Apr 2025 05:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743484354; cv=fail; b=dNvio4u60ZjuhHVNtExSn4rVQHJ2kz3hvbGYUMLKRUNZAbfw15GluVIFmeLfAhz2Zt5ZQdPbD997ybgcIWmcv43CsRqli0X8inKiYcWJC6C7lsQlz7cPmNA5VmVhyPjH7c8GnaoYwy/bVYLvThzSvSG9gXinq910ix4mVFqlfQA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743484354; c=relaxed/simple;
	bh=9nwfrnICQswK+Vtbu1EEvFGVmte+2BSIzT9rnOH7MrI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oQw1h3rsqIIZnk62veccRlfWP9aqXDiXn3RaBzAAHIdL5C5WIWTqB6fkcSmo+apkfc4+gt8S+TGYac/FCN5FL/N2+TWgIBCR1ts9X+XXqLplhzipxxb1JC34E1NSaEJlMQXC/irpcif3xPJBuCKfyHWzjLz8kx5MLFlP2ax7E/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KYp7a7CC; arc=fail smtp.client-ip=40.107.236.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p9bqx8C7IMcbWnJKhhsUPR2R9UYYpTH+xEcDNaRy8NsmTMv4DZI2/Sex7vyGInDkGtvC1ZpPu7VtraY83CKMnYXd6Vaiax4hE+YiQLApIsk5wnvNfnQIhfaiGpHUsve0pO+Vg5dms1Ih/IwwRHFyMniz3U0oqkykvWGJ/UjM9+6O4dImorqw/LKAxlqYKJL9UllBiz4INqAsDtC60FS9ikt2QlBpo9YViYASjNWASNssPr1teOffmj1keW3tY6jSaOhavV21TtJ9e0eJ310E1Vwx1lOYwv/TYRGL7DX5xgaZbd21EbMVJMnMVIYfPyRFrVP5gXxhPLtulpBTun/b1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dpNIvxBFGNADof7Row5BCQgp4wkuQ34pUXQmgOTzzqE=;
 b=ZESz/qAENwo4qQK8gFu6+IRu2w9Y/90pQst7NIZmufTrThSioFiCIqJN9XjFnmaH/IGaPbXXuctAiBnsjnjWAr24CNHO5gH81qNAd69gpNXwcqC3+It1FblxsPlBlQJErLMBR1U/FoQ31JORTMwiFSNKXp1sg0DWj9dJpkI6J9Q8e+B0m26wfIhWIhO+f3fx6n+mssK/3hxQZr27hIrCwyqJHDqI2Pa/+kVLZVs/D+Z0qDSW67jg2TFRYYePoItGQGGCCf8JCmbxgPS5yceDj9S5ZQ8lwonu4IRscbqwCvGtzNuT1VPk8sfSncctWD0soUjiaFbCNCuEHfNUNDGjmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dpNIvxBFGNADof7Row5BCQgp4wkuQ34pUXQmgOTzzqE=;
 b=KYp7a7CCDd0hINHkf2KVtXRQW7E1iSDvW1vKVsMJOwEYxh2s53w3+iThzBhPygZK5pCRs+osFOwRAdadxkJHkBQ+5JYPqDM+9hhXLDCs9lzukjbfLnVjuhjImt+5Tgo8Pt5nGca3VAJShKxZNZtGt27s7hhZ0Eq9WpWiJtS/MYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SN7PR12MB7024.namprd12.prod.outlook.com (2603:10b6:806:26e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.54; Tue, 1 Apr 2025 05:12:27 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 05:12:27 +0000
Message-ID: <38edfce2-72c7-44a6-b657-b5ed9c75ed51@amd.com>
Date: Tue, 1 Apr 2025 10:42:17 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 01/17] x86/apic: Add new driver for Secure AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-2-Neeraj.Upadhyay@amd.com>
 <20250320155150.GNZ9w5lh9ndTenkr_S@fat_crate.local>
 <a7422464-4571-4eb3-b90c-863d8b74adca@amd.com>
 <20250321135540.GCZ91v3N5bYyR59WjK@fat_crate.local>
 <e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com>
 <20250321171138.GDZ92dykj1kOmNrUjZ@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250321171138.GDZ92dykj1kOmNrUjZ@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0112.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::20) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SN7PR12MB7024:EE_
X-MS-Office365-Filtering-Correlation-Id: d0abdc90-d3d4-4aaf-a789-08dd70dbcb3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlkrMVVwcytaT2hYYzcyOEN5M1dzd3JURzg0TFV6N0FhdHNxRnJRL0FSUVdw?=
 =?utf-8?B?UU5PQXorWlgwREpYUjM1VUV4S2Yxa0JvbUo4VGU0TXM2UnhoOXUyMURnSzlY?=
 =?utf-8?B?MW5hL1UraGhuNWVZY3VwRyt4ZURzZ2ZKOFNZNjdtMUlEUS9ZUVlCc2ZMYy8z?=
 =?utf-8?B?alp3NzZSUTdGdWUzd2hRUnZ3MkpoVG1haWJ1aHJqSlNRaU5qdFpTbnhsbDg5?=
 =?utf-8?B?bDdEU2R1MkpaN1drUmdGRThhemVYSXBpUmRrSURTSklTN2UzeUpnRFF6blJH?=
 =?utf-8?B?MFNoYThLdlVMQ2RzL3VZR3hMaHIwVnM3dnE1YjRwMllOMC9NSXQ3eldrTFJH?=
 =?utf-8?B?RWgzb1JqRTFIMzZXZWNQTGw4NnpNNjdBVU04S1EwQURrRHBWTmZnY3F5VUts?=
 =?utf-8?B?NzQ1S3lyMERaSHZXSk5YNmowR1ZMWWdoMC9oNjJJbVRXc3Y2YWtqVFVWSFBH?=
 =?utf-8?B?REpkVmhId1hNK1prWm1XamI4RU94WmVpSnhLQlZhbWhmMXJPY3BydUt3d3Fl?=
 =?utf-8?B?TlBtcml4Z29heTV6N3dIUUloRDdnME5DdnI3M1ZJR2NXbTh5dHJTMlVlbW95?=
 =?utf-8?B?ZEhqSEw2OVpMNVN3RjJwRkhlSVlkSVJMZU0xSTlGcXJ4YThQemEwbXhDc1RD?=
 =?utf-8?B?NWFaNkRCeGkxaGtMYUJNZVVxcXZYYzZyeFU4enBZVmtQS054em50YWhuT1BQ?=
 =?utf-8?B?ZlB3cE5XWlFjSUVyRWFIU2x4WWRyQ1VTQkJ3aDd2ZHZDdjVNVFN2RmgwOUpv?=
 =?utf-8?B?Y1VoMExaakR4aDVXbEc2MWhjb1VVVmd0RC9CRGFuNUdlQWt2ZVVnelZZOS9T?=
 =?utf-8?B?RFpqZ016NVFKTnVUZ2l4azd3ZFJLcjhEdFpaenR3eGQ3VERSbEhMUWtxSytz?=
 =?utf-8?B?YW9WczZTMi91MHpqbkhBUHo4bmZId0ZkMWZsMkt3Qkd5c2p1YzRLKzQyaVkw?=
 =?utf-8?B?bFJ2TzVvU1k0Ti9NL2w0OWpoNVQ4bEo3aWgvMWw5ZFhDeTFlbHJYWVFiTzhM?=
 =?utf-8?B?M3lCUm5KcHBHbTdWd2pJalp1Z2lRVlNIZUIvUzhjMEIxTjNEaE1UekYxL1U5?=
 =?utf-8?B?Ym4wOS8rVGlRQ1RXL01yeVl3L24yMGdON3oyVlNlRzVFSGZmeDNZY21XdHpq?=
 =?utf-8?B?dS9WY2UwMWEyTkQwVHFncDREWndNSkNMQUcwTXYxR2pwa0p3UTNuU0IyZVNJ?=
 =?utf-8?B?WS92QmpnTkR0d2luNi9tTTJReEcwWksvQ1ZPMnFrcXZtZzQ2MXZMdXV1RXhk?=
 =?utf-8?B?M0JaRmtzcFFEWTNTY29EcmxUbkNUeGdsNFduWGhxa0dMeTV0V3VpdmJEZVlR?=
 =?utf-8?B?SUdWN0QzY1lTcWQ4MERxekI1OWNpWDd6KzJnWWpUbzZLbnh5SzA4YVBvTjZP?=
 =?utf-8?B?QXoyZUg1ZDM4Z1BvS0RhUVBPYUt3VFRma24yaldrQS9wMmFmVlVQZVNrQ1ND?=
 =?utf-8?B?MS9qeGpNTkJXWXdwRDZYMXNqb3NKSXhkbktwZEtYZzE2NTNXbXZwRktRdWdr?=
 =?utf-8?B?blVKVDZlME9SNTdRK2ZoUjF6c2VVUUZwWkMvSEdPeHVKZldDc2xYZ3ZvRWRw?=
 =?utf-8?B?WUpOSFREVEFiN2hPd285UzhzZlFpZVdPNDNLV2U1OVF5NCtqdW52WXphNklv?=
 =?utf-8?B?LzVoZ29nNGJKT0tncGtBOFdYUnIrcTZKdFJKNGNQYVdWMUVyb09oYjM4VkVj?=
 =?utf-8?B?U1VpaTlQODFRamJQZnZaeWdEcm0wU0hZckNVN1VSTmtHTXJPT0xGYXZIZ0Fa?=
 =?utf-8?B?VCtwOUgwakRHOFhVOVhFaFdvYjFiWnkzYWxDQkxReUxWYlJUR2l3Q2lNNTNJ?=
 =?utf-8?B?YzBvT1NPY3lHYmF3VUwydnJLSitMMnY2N0RraXRDQS9lSGoyK3FBUlQzcXlG?=
 =?utf-8?Q?Zb7/7XEkg8C9I?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UExBaUVlbWd0d1NuL01aWnE0Y0QvMm1yWWlQaFZJemgzcS91WVBYbU1QTnpP?=
 =?utf-8?B?akl0dnBHWG5UUzEzZHh6VjdBcVVmUDFVODEvRU10S3FGZmhOcFJpT1B5Tm9n?=
 =?utf-8?B?eVduOEFZZ2lkOUkvQ3dEL0l3ZHFoVEZMWnhoV2VkMTlPV056NFozQnZiNHlC?=
 =?utf-8?B?NjVRcmNGVk40U29CMS9ORkhnTXFMUmVLbFVUYTNZdXhoQ1RhZ3QzdkRqWEN4?=
 =?utf-8?B?L2EvTmV2V2hDaTBrd1NxdEtoYXkwd1NER1lYUXV3WmpQNk5PQThET3ZLWlZj?=
 =?utf-8?B?NlNMdXlnQ2EyTmUyTUtYWDVLeklDU1AxZWIxY2kvc2dkKzcvMXBOWENQamtP?=
 =?utf-8?B?RW9aa0NJUStwOHNWS0dVamVQMFlLdmkza0RhVVgwM0s5eDZ0ZG1pTDBxdDVI?=
 =?utf-8?B?dXFCcjMrbzY3cXljbHVEZjZPbXFLQnpKK1AyalI5U2pUUXlBTWVKL25HbHdw?=
 =?utf-8?B?VEN1VHB6UHNDVnF2d3JGZ2JRTGdIZURLZFR0WlRFQXJlejBVWVNwaHhDSFc5?=
 =?utf-8?B?clVkRFRSa1ZmbHJDbEI4bVlZMURNV2poeW5TZFZsdyt1dCt0RmY3aXd0Tmto?=
 =?utf-8?B?SFYvM3oxbHIwbTEwY1VsQVpzT0EwTWJOMmJBZWpIVnlOVStPNUdIR0ZzYVlN?=
 =?utf-8?B?SnFySEYzWlp0YmR6U0c4RXpwaEZtTGhqcmZvQXpaUWQ0eFJDUWxNdnJQbTJQ?=
 =?utf-8?B?bjhUNk1hREY2QURYa3ZQcmxBb3c1Z25Ja3NxRlBYcUEyUGxvclNxbzZEMisy?=
 =?utf-8?B?QUlXNURzNEpCck04dmxQdEhvVkY0dXc2UW1oRnBlbnFWNXhQNU1FcHdaUFdH?=
 =?utf-8?B?ekJLVGZ5bkErdlpmT0Y5YmY1YXVyNzdEem1Oa2cvR2JOdG9WOWFLNUhiZTly?=
 =?utf-8?B?bHpubnhnakMwRWlvYkxiaDVNdVZKb1ZjWW15K0JGaEptdmh4ajFZM2cxNW9Y?=
 =?utf-8?B?VW5oT05RY3VaRGluQWRlc2gxajdiODk2SEtOZ1prUkZQS2JJTko0bGlkMG1Y?=
 =?utf-8?B?K1o0RXNzZEtJSFNQYWU0UERBbi94T2IvTWN5Z1p5NW1rNTh4bVNRcDArUjRn?=
 =?utf-8?B?SFd1YjNVbWY2Tm9UTW90M3BxSmVSZkZQNzFuN1hrNGl4UmpnUVo5UGtNZW5F?=
 =?utf-8?B?Y3pDMnhYZFN0UlhVWm5lUDl5aHRrUmRPMkRJZnBGdGduODZSMk5sckd4WW9u?=
 =?utf-8?B?WHkrbGhIYWJSdFdBVnBiVWlyTmZ6N2RxVmRiRC9oMjk1ZTA4bkthWmFVZU1U?=
 =?utf-8?B?U2ZpdGVob1NxMzZtbG1FMXZDV2hZYk9LVkhvZ3VhS3UyS1VLU01nVEhpS2pq?=
 =?utf-8?B?U0tYWkFoRHZBKzl0T0VoaGxLTS9KSnFZTk9WMkY5SlJzL3k0b25WWUw0cXRG?=
 =?utf-8?B?NktMVXJPZnBiei8zeUgrazVjYzZ1bVh3RUpITEpWOGtubkxEMU5mVWJ4cE0w?=
 =?utf-8?B?NG80TGNhcEUrdTVKZGZ1ekNXWGpneWRFMVlpSlUwZGpiZTlLb0swRjM4ZitB?=
 =?utf-8?B?NWFCdFJESDVFYXdWWWxxS2pTbGFNOEdXTVEzSHhtS3JSb0xjN3RNZDE3YWxt?=
 =?utf-8?B?YUJXdEZJTzZZWWMyd0djWlo1TnlKSTJzbGRzQUF6dWcwRVhaQ2NmbTVpTGdB?=
 =?utf-8?B?SHluajg5dEZMZGJJWkIyano1Vmtwa3hLUDgzSGpabE9ZQjIwU0ttVTRLK2cv?=
 =?utf-8?B?clM0cU1CT2dtM3E1TjZXR2FBM3RXbzFYaW9xRnhwRTJRMDZFY3UxU1lyaTk1?=
 =?utf-8?B?dVYrWWlzOU9TdUdvTGU0NTRSaCtwM1dRU1FyQlF3R09WZ3VPNVFqd0VHdzla?=
 =?utf-8?B?TEQyWWNHN21FSXVtUXlLOUxZd2FGdGlQa0RzR1ZnNXFJL2ZRRFgzSk5CUjVL?=
 =?utf-8?B?R3RLcXArZE9ITDdudGR0MVBONUJyZDk5OFBiY0ZGeXErVHQ2SUNDdldtQW4y?=
 =?utf-8?B?cEpOcUhzWkY4TVgybTVydDhOUGxHaG1OekZFYnFvWHJSNnA2ZjlXd2hSeis5?=
 =?utf-8?B?VktDMi9INFN3b2ZXT1V0U3BjSFh5OElDUWlZcWVWS2ZIWFRsdDZ3ZzQ1SVZy?=
 =?utf-8?B?QzdJb3NHQnczQ01WVzROazduTy85NUxPaGNJdE5kRHdLenFOTUwxTTQvNTJR?=
 =?utf-8?Q?4Cj0bhvRh/lcGn/HV+mwL0SMi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0abdc90-d3d4-4aaf-a789-08dd70dbcb3c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 05:12:27.0414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ye/mx1rjvxx1Fh/reKJFrkVZOqTvNOBnZE6+sWxit0ET/zpRPj1+5igj3NN+duh7DSHw0LwhBMgk1oV/x+TuMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7024



On 3/21/2025 10:41 PM, Borislav Petkov wrote:
> On Fri, Mar 21, 2025 at 09:39:22PM +0530, Neeraj Upadhyay wrote:
>> Ok, something like below?
> 
> Or something like that:
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 76b16a2b03ee..1a5fa10ee4b9 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -476,7 +476,7 @@ config X86_X2APIC
>  
>  config AMD_SECURE_AVIC
>  	bool "AMD Secure AVIC"
> -	depends on X86_X2APIC
> +	depends on AMD_MEM_ENCRYPT && X86_X2APIC
>  	help
>  	  This enables AMD Secure AVIC support on guests that have this feature.
>  
> @@ -1517,7 +1517,6 @@ config AMD_MEM_ENCRYPT
>  	select X86_MEM_ENCRYPT
>  	select UNACCEPTED_MEMORY
>  	select CRYPTO_LIB_AESGCM
> -	select AMD_SECURE_AVIC
>  	help
>  	  Say yes to enable support for the encryption of system memory.
>  	  This requires an AMD processor that supports Secure Memory
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index edc31615cb67..ecf86b8a6601 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -685,8 +685,14 @@
>  #define MSR_AMD64_SNP_VMSA_REG_PROT	BIT_ULL(MSR_AMD64_SNP_VMSA_REG_PROT_BIT)
>  #define MSR_AMD64_SNP_SMT_PROT_BIT	17
>  #define MSR_AMD64_SNP_SMT_PROT		BIT_ULL(MSR_AMD64_SNP_SMT_PROT_BIT)
> +
>  #define MSR_AMD64_SNP_SECURE_AVIC_BIT	18
> -#define MSR_AMD64_SNP_SECURE_AVIC 	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
> +#ifdef CONFIG_AMD_SECURE_AVIC
> +#define MSR_AMD64_SNP_SECURE_AVIC	BIT_ULL(MSR_AMD64_SNP_SECURE_AVIC_BIT)
> +#else
> +#define MSR_AMD64_SNP_SECURE_AVIC	0
> +#endif
> +

I missed this part. I think this does not work because if CONFIG_AMD_SECURE_AVIC
is not enabled, MSR_AMD64_SNP_SECURE_AVIC bit becomes 0 in both SNP_FEATURES_IMPL_REQ
and SNP_FEATURES_PRESENT.

So, snp_get_unsupported_features() won't report SECURE_AVIC feature as not being
enabled in guest launched with SECURE_AVIC vmsa feature enabled. Thoughts?

u64 snp_get_unsupported_features(u64 status)
{
        if (!(status & MSR_AMD64_SEV_SNP_ENABLED))
                return 0;

        return status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
}


- Neeraj

>  #define MSR_AMD64_SNP_RESV_BIT		19
>  #define MSR_AMD64_SNP_RESERVED_MASK	GENMASK_ULL(63, MSR_AMD64_SNP_RESV_BIT)
>  #define MSR_AMD64_RMP_BASE		0xc0010132
> 


