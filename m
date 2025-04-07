Return-Path: <kvm+bounces-42855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD87CA7E682
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 18:30:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 805F43A854E
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 16:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2312F209684;
	Mon,  7 Apr 2025 16:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4cjksH0L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2081.outbound.protection.outlook.com [40.107.236.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE776206F02;
	Mon,  7 Apr 2025 16:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744042669; cv=fail; b=oWbOgugUzIzNvwKvCCT9XGuSN6S2kR/UB4r9t4zyF/MIhpVEKBB2SMQ/dzN1eN8R8OBZFjhwV9ZC51VDlEjYCWq6ZSNWVTriMkgptyKnxxrIDZEtEoH2lmodQDb1/TXyZ1CJqfA3CFionCt5ZASeFIhx8THCRGgN+D90IlMP5Dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744042669; c=relaxed/simple;
	bh=Fvb/kueorG4vQIWldouX8L1HuRm20UfPMCYRxFy8C9Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JMwzGqIK3yqieVYdl/M/cBhd2cVPD/C/hG7lU/Gnb1ddqSLeGPvKpOWNgnRE2p4zjtR9mdX/wIDGA0wLjGyMvGckYqEmTHgLyeaJLV6jl+3IUxH73VSHF4mywY/cTAWxaaoE8iNoTIJkkbZesfNhLlev3MR1mlTntTBUfVe/3G4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4cjksH0L; arc=fail smtp.client-ip=40.107.236.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2H/L+xT7D+TDFTDuP8fFmaFQVXQTOTSG/o6n7eUE/5ruOUnM0oJJOhx1MlXkigB4uy3o2f8pvnQ8e0ezSHoudCf4dcECLW+P9h4DK9rTsGBnnutUiGxSs/GrcIOaPcIteJHGDYHO0m3nKVJQcJPIt9U/vuQ9xRaF8bqDCl/OeddxJOovCU0kPdwbS4VWPkbOalRb86HLKxOMcDdQ6/+xNeCZQ4lqVp73jXDzCgnE99lX6QI/eLGzAmwwNIAusbloPL9Cd9FLdO43P4+6fZ+0CfRcj41mZ3PF7UubD1nuMtGIsSjqDRbCBfh97ZvyFeZhSS+AFK2lDVhDpm7RvDJyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zmtRm658UiSA0oaecVgJDYAoZ9F5G+d3xb1ZPD6928A=;
 b=DxNInBCJPPfSrmw5uGO98j6nDUeWiacARrcDszvasuf67QPUg7nvKbo2BEYA0mKZG4k7NCjThIwgazH2gvH0jfSyUi7aQzEoqmgLa26a2PmOaPGZMj/e0qJKKQ2hSZ25SiQ7gNBLgQNvQ6aKlnKlOdXz8ZavyaQ6cedhGyLeEqYwClQ3zQCw/1onspTMb3CJIEyJ6gAZBO+IuLVGW/UDBeIvx1k3lsuh0ZIBYTNRVgvIjLF8RFSq6PwFMD5FnLuGkRQl4u+Wi4qou+R4r9qu/8HMXP5lEc8aLlOyPSwK8xdCKcUUkF8fjhhFZ04UpNTaZ9jPIthvil2QqsBthPYQWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zmtRm658UiSA0oaecVgJDYAoZ9F5G+d3xb1ZPD6928A=;
 b=4cjksH0Li2lN+WbMzAS0JfPh2/9xa1ABTX5r+NOE4KkTM5pRGMS6Qlb+00mlFTxZtmYa/vGj0WEDghIFHseIgKGytKgrUkLYxaSGRBENnggelKYenaUrQJGt6JTr/u1ijzJ4PQK7EZfNBEoH+ORjmMbiNhLqbXfkZZm8i5iZUjo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CY5PR12MB6153.namprd12.prod.outlook.com (2603:10b6:930:27::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.34; Mon, 7 Apr 2025 16:17:43 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8606.027; Mon, 7 Apr 2025
 16:17:42 +0000
Message-ID: <51437ee4-e3cc-461b-8317-f20a4711a06c@amd.com>
Date: Mon, 7 Apr 2025 21:47:33 +0530
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
 <38edfce2-72c7-44a6-b657-b5ed9c75ed51@amd.com>
 <20250402094736.GAZ-0HuG0uVznq5wX_@fat_crate.local>
 <18538e70-aadf-4891-964e-4f8a06d85e5a@amd.com>
 <20250407131716.GCZ_PQXC9Gkc-LzS33@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250407131716.GCZ_PQXC9Gkc-LzS33@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0005.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::11) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CY5PR12MB6153:EE_
X-MS-Office365-Filtering-Correlation-Id: f22bb04b-72a8-42a9-496a-08dd75efb954
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OTdvcFVGZldVTXBWOFpzaHEwSkJYTnAyMGx1SGJaTVBBWnBTbFh0SUFVOHUy?=
 =?utf-8?B?dkZYeEhDcFJNaC9DQzF0VU4wOHJaR3YvU2lqQnlDK2ZyVTZ5V01hVGxJQXRv?=
 =?utf-8?B?eE9VbVJDaFFRYzdnWFNuRlBSUVk2bXVWVHJhcU81ckppRTM3dy9lQ1k0L011?=
 =?utf-8?B?ZjhLbGpjbkJXT2JWYWxjMmNwV2VFZndONjljeFk5bkdIUDlXUjhRZGZpdUpu?=
 =?utf-8?B?OGgxanQzMUZWRVAzY1B5aFplUlhwTEp5MEhSTS96V1paTkhaZFpwdzJtY2dm?=
 =?utf-8?B?U3dVN3JxKzVrNHNtbjVmM1pnbGFyUEtPbzg1clhLcjNGRitXc3NXaTdXdlJt?=
 =?utf-8?B?V3RvbWhIcWJsZUozNVZ3bm5rRlIyZ0VCTkYzNE5ITnFxa2lBcHNUTE1iMTBv?=
 =?utf-8?B?OTZYaFBDQ0ZobGYvcDdYR2lHWTdqN1JXUXgrM1ZTQjR4a0UwRW1tZHJiOGZV?=
 =?utf-8?B?Qk5uRUpORnZ5ZnZSdW02Mm9SV01UYUdXbWRicnV2VVh1UWw3Z0MraVMrcDVl?=
 =?utf-8?B?SmRwZDNZT0pZZnVVeldGRUNTWlJ2RWt4Q1J6ZjRHZUhVK3RBYWRIVXhDMVgy?=
 =?utf-8?B?dCtRM3J1c2JrY3JnZlpkVVFJakJXVXdxL2dvT0cvMEhQeCsrL3JuRDZXbFJD?=
 =?utf-8?B?dWQ0Nzd5anl1aXp1MFlzSk5IZG1HU3Q0TGd1SFlUaTlzRFRrcnNLZEhNTWNX?=
 =?utf-8?B?bGlTSTFlK2cxdjFZYm01ZjhuRHlla21mWXhDVmZHNHFYMVNOL0lnemd6R3A4?=
 =?utf-8?B?TXpMcHJ5cDg1OWJlSzhCVXlrdEtjdk9XRzI2YklOaUM2dDlycVlrb053ZWNi?=
 =?utf-8?B?R2V4TXhDYnlYWEdORzhXRnBzVlZYbTZ4NDF5MFRCbm4zTmlzbnd3c2xFeW9V?=
 =?utf-8?B?aDBVM1VTZ2t4c0sxeGl0amtBT2I4K010dFBIMlhoZ1hDeDI3RVd2UVFVSjBX?=
 =?utf-8?B?a3Z3TFhQd2ZST0d2ZDdHZUl1T2c0MTgvbTVUcEN4bVR0M3NILzBxVnVTTkov?=
 =?utf-8?B?aWV1NkJpa0MxZmVWTWsxQk1IWS9mRCs3QU1TSU9MU2UxT3MrYWFBdU5KTWhI?=
 =?utf-8?B?MXpJMjFDRHNaUms3UWp0QmRFVGtaa3dVWmw5UmtDV1dKZHVscTB4VldmeWZ1?=
 =?utf-8?B?Q1ZXb2dIOUFrRnI1WVpMcWw4TEozL3hYSlNDbHZiUldXdlM4TkdYVGIyU0tC?=
 =?utf-8?B?VTBsTkJKM1YvL3IrTU9zQUQzN1lDeUdSZ21TTmpuVEdrdXE0Z0gxVlV1U3NK?=
 =?utf-8?B?L2hja0J6WUFZZGlJcFU5VHgrWUMwcG5nRm1CT0NkN0pZK2Nuai90VDZXL2Fx?=
 =?utf-8?B?YjRiYVk2LzlMY201RkM0VCtEajBFQkoxN0w2V1RaU05CemhGQjZ5cDVmdFBO?=
 =?utf-8?B?YWJiUHN6OTM0NEJKSTVwQzdlMC9xa1c5Q3p5dUZxTnpveTQ3cm5TQ3pVYmNF?=
 =?utf-8?B?NElhZWRCckQwd0pJdGdXVE0xd0NHWFk5VCs0MDEzZk43Y2x5MFAvL2UvNmFO?=
 =?utf-8?B?VEx3MFNPRVprZkg0NXN5ckFxdG1Wc04yYnp6UUFaaW5TUHZXWDJiWmpzd29p?=
 =?utf-8?B?YkgwYStuMno2ZTNQQ1JDcEpzK251bEVVcU9yNloybzNBMDlRQUZyQ2k5V29V?=
 =?utf-8?B?eHhpVnRaNmNJY3ZVVWF6ditaamQrYytIQUo2YWhDMnJWK2hFOGZTWGNpeXB0?=
 =?utf-8?B?YzdqcjZwS0lHNE9MRGIzZ0gyT1dOWUFzSjNIS0tLeEl6MExjZU95NkJlY0tL?=
 =?utf-8?B?RUJUamRXdm1wZE9vL2xLTi9GdHBwY0hEaldkNXErWVdIVFB0dFM0OVNaTmhy?=
 =?utf-8?B?aW8wRUo1N3kyQ0ZaVnRRTjduRHJHREVvTEcxWjJGUWQrNzc4Q2xvYkRqR053?=
 =?utf-8?Q?gRx3MW9SNOZU/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M0p6SGppemlEM0xKWm1pazRkajRDZWtiMXM5ZTUyR3JYMk5URFZkQ2VqMmlm?=
 =?utf-8?B?NzBlUjh1NzVUakRVRlRLWGNFMXd5bUNoaS9GZFB5R082ZkYrSUN5dWMvblRm?=
 =?utf-8?B?TEZlOHZ1d0ZQVVJUNmluWmNjWlR5YUY2UkRDZTlWZTBwTVEyazNZdE1Gd2VW?=
 =?utf-8?B?UDd0c3N4QWpZRGNlVnR2TE1RUmNselFvL1BzOEMraXBlUWNEWnFRWUdSbkhz?=
 =?utf-8?B?VWMxOURpNFJucHk0VDdUamJwbUNGdWhXVGhSOTZGblN6TExhZXFjNUdxS0U4?=
 =?utf-8?B?a25GWmdSMVFkcUdwUXA1TEM5eHh1R2ZwTGJVaFRSMFZuSTlFdGNqZG5tam1y?=
 =?utf-8?B?aG9JT1BEWjBvNzRaTmdoNWljZEtPR0dIekhxWkZ3bmI2YlZoUTRRY3RDam9l?=
 =?utf-8?B?M1Btcnpsa3U4OXFoalpaVUVEb1kzY2FNNlo2UXNYR050aU9iWk5iaVlHMU5q?=
 =?utf-8?B?S3VLejRMbUpxQXRKRVkzbFpPZnpKZW5aT1BBSGJETFBQZkJXYXBZVW1UbE02?=
 =?utf-8?B?TmFubXNXNXI3Q1MvVlNRbmVlV0pqRXdBd3RkVDZvZlduWm9jTnVZY0w2eXBT?=
 =?utf-8?B?ZTlNQzNSRW1LZmdQbStFUkZtMDJDcjJOOGtyZytSYkJsMGh6ZlhNTmhpNkFK?=
 =?utf-8?B?UWN2SEJ3bktmcHpoMC9KbDIxTG53Vk8wYUtOM1hwYXpmdHhtREcvZWFpbk82?=
 =?utf-8?B?MWdtM0t6T25TbHFYNlpqVW9ndmVwVDI4QVZ1RjR1aDM1dmZiVmtkaE42VWFy?=
 =?utf-8?B?SGQvc3lRVFZWUmNGdGJaYVlNTEVKU1ZKTklmYmhCdjJiajd6NGVWZEZSeFpR?=
 =?utf-8?B?aDllY2FNb1Myem4wMDRFVllkT0h1QmppNGtpV21zdDFaNXhKSmlJZmhVVEEw?=
 =?utf-8?B?czlNRkQvMEpwOTJKdWg4cHBKZlZKdjJ5VDJvbjU1c0JEdkpSVXpIcEphRlA0?=
 =?utf-8?B?M1Z2MDZiTmdTbXJ2NkRMWjZRWDZnY3dDRDdsekFYdmxhTTdPNFVwSE0zK0sx?=
 =?utf-8?B?T203SmRreWt3d0g3aE1BUnpSazg5TWtabW5WUXNtOEswaE1wMzhRaXRBSUN6?=
 =?utf-8?B?bGdpcVFXc01YZzFaTzlIdlVraEVTVldLOEFUR1pjQTU0emFxZFhWdnhWS0N1?=
 =?utf-8?B?cnNvNUlDSktucTY3KzJodUZaNU9IVEN6U2JGSDYxVW1xR0dLbnkyTkhscGZ0?=
 =?utf-8?B?RlNHMFBDd2ZyS3I3ZE40enRNRDhLVDVKQ2hyUTczMGFRNTVPRUVWU0hvenY0?=
 =?utf-8?B?c1BieDhNVzBuQVNYR0lXcUNhWHQ3cnh5ZkhjeEQzYitFUHgyV05zWFhsemJm?=
 =?utf-8?B?L3VmR3Ewb1JHQnNMZDF2ZGJ1NlNjeXk0NStzVWhyZ05uRXdsRTNnaDhzQ0VB?=
 =?utf-8?B?VWZaM1RjL205c1ZndGhWQVhjQkdPN1lua2JQRkNHczRxTmsrQngySDhENlY0?=
 =?utf-8?B?ZGV3U3FoRUFPdHZOZjVSQ09vaHJreUFjanErK3Bmc2hvdmNoK0kwTklWdytL?=
 =?utf-8?B?TFVVeEMxSzNhVi92TDZteGs3WVVYNWdwMld3RkFwVzNqZ3dUeVpsUmp3RDNq?=
 =?utf-8?B?VDFieVJLek1QQXVpMjcrc1V3b01kclI0V2tmb01zS05hQnFQV3ozYkluRVBk?=
 =?utf-8?B?bzJYbUdieVFOUmoycXlHbG1DQ3E1NHphTkJtQUc0L2NxcVZIYVNVYmtDV0FB?=
 =?utf-8?B?ckRnQUhBcWlobkVNcDZBVktqTzZPOWJkQVd0OTZyVHNCN05zd3pvOE1yOHZU?=
 =?utf-8?B?TlhnWFd0bk5ocTE3aXVyaWN1YjhjMnRBcWhlZlV0U1lOalFPT1NMUmVJYUt5?=
 =?utf-8?B?YW5GV05LcEZsMVpBNXk4MTZKYm9Rbk53NW55OWhtUlQyZmIzMmNmakpNeHdI?=
 =?utf-8?B?cy9nQUxlMzEzdEIrbHVyVHF6U3VISGV1OWpPdTZBNmtyVmppZjliUG1waW1i?=
 =?utf-8?B?UjZhYjN2UkR5T21TV0x3SjNHbFJHeVJ1ektZTUYxdkl3OWc5bmxveFRiSElk?=
 =?utf-8?B?YzBLVzNWY0Y2VzQ5a3h5TTFrL1RaNlM3MU5tVkpGSWs1ZzhnVmR3L0lZZk15?=
 =?utf-8?B?RGhDMHlXOGZnaXZnQ2pueHlsdytHcVRoNnBvYVpTZVhmcE1nck0xVk9PcGJw?=
 =?utf-8?Q?B+W3VdT90WOSNitadXkEH8L90?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22bb04b-72a8-42a9-496a-08dd75efb954
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2025 16:17:42.6536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqPJKbw/f5Zt4Zwvp2c+Iu1B51qUhixChDM42A+NHu1H8KxV7BYCy+3/4floGTbg772gbVIp35DN5PKEtMoDNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6153



On 4/7/2025 6:47 PM, Borislav Petkov wrote:
> On Wed, Apr 02, 2025 at 04:04:34PM +0530, Neeraj Upadhyay wrote:
>> - snp_get_unsupported_features() looks like below.
>>   It checks that, for the feature bits which are part of SNP_FEATURES_IMPL_REQ,
>>   if they are enabled in hypervisor (and so reported in sev_status),
>>   guest need to implement/enable those features. SAVIC also falls in that category
>>   of SNP features.
>>
>>   So, if CONFIG_AMD_SECURE_AVIC is disabled, guest would run with SAVIC feature
>>   disabled in guest. This would cause undefined behavior for that guest if SAVIC
>>   feature is active for that guest in hypervisor.
> 
> Ok, so SNP_FEATURES_IMPL_REQ will contain the SAVIC bit (unconditionally,
> without the ifdeffery) and SNP_FEATURES_PRESENT will contain that thing you
> had suggested with the ifdeffery to denote whether SAVIC support has been
> enabled at build time:
> 
> https://lore.kernel.org/r/e0362a96-4b3a-44b1-8d54-806a6b045799@amd.com
> 
> or not.
> 
> Right?
> 

Yes, that is the intent here.


- Neeraj



