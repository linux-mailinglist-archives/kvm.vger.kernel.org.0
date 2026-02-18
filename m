Return-Path: <kvm+bounces-71275-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APQvIqwqlmkRbwIAu9opvQ
	(envelope-from <kvm+bounces-71275-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:10:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5E2159CAA
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 22:10:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 00AFF303CA6C
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293C434A786;
	Wed, 18 Feb 2026 21:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="jgVWrTnS"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012061.outbound.protection.outlook.com [52.101.48.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD06A321445;
	Wed, 18 Feb 2026 21:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771448986; cv=fail; b=umk33Sa33mxHUoj5SjxZP5lVUoc/eEBYgT4nCC8y3Az+zBQQdjR5RWXlWG3MbXMdpRVGTSYh1sJ7xwcILM1mMEfc6YG11Tc9UfQRI4fuo7D00GR5+GTQ4w0wKE2mzjVgKXz0OBOfZFUFAAzDzSqjrfsPtY4uJNRZdnBtel5YDKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771448986; c=relaxed/simple;
	bh=JDCr7YHkc8PHoGq7iAf628weepniPkAU+eGif6nzPfs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oKqjd3rOsNwt24XdqAa69b5DlqK+3F8D6ve0CxvVdErU4I+m2YDQUnoZv5mavAH0dzeYk2AltHHyfg3AFAtOWeJmLcHyoSPY6L0Z/2wWBwRE5zZNlgpdi8VM8y2hoo2vxl1JoazXiyIiOKjPe/g6n4O7EmemKVsaP159gWGDlTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=jgVWrTnS; arc=fail smtp.client-ip=52.101.48.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvyADWW3RvkAlvy8Z5O7SIeXwNsLEfyQLIZF7vqYKqV8UlLaKO2VEBsQO6AuEgWDoHX0dvRh8bW+SalotY5XQALpg+BPMEYdLYnxS35Qh9zAZ2P2nMUz2X60tRJ4FxIAkvxjk5WWQTgbnmR5dOEnQp7aCVLeR3dUXC5xlGNrV343xTci1U/jhNyURNEPvxzBiH1m09vtVeUzK7aXiYwhsS6FcZaynMupbOWXFlE0RGwKRSffrM5SEsPM45CU8LpLqbmdZkqgkLqTw0K9A73eGXCJBHfR8+6cA6qzDiScTXUHoShAceyDJ+mBsVzipI9pnEA24XTeKsMkQ3/Zu/ek1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lHMKjgceYpi104XChXdORPUsTi7pcQPlPCnBS3RszII=;
 b=GP50GrJOue85Hu3uyqIVTartt94btxvz3HIV8Nz6KYUEvNpUp2U9wlJ4q2bY7caVlmv6Gw8JCmZLYEG5Jclf7/qeWGWqoBReqCIPXC6wBf5fpEa1ps4abv3aVHeDmQ809szDRZ+K2y03A4IDw2GKBCXTgNUV/p3MgtVBUFL+ONrJPYKxTggeeGsHgo2fWS16/P2QI/hv2v/fFxHOZ/nxxQBXE0z8E+zMXlR/IxDRSp7JFmHie2E5TUlCydD4oGwi1wkb85fQGR969doidNYFswm6SJSaeSiGcbQLIumHB+6V4A3HopaRJp23sTOlTFR/HlSv8zTPCwn+lrPW3telNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHMKjgceYpi104XChXdORPUsTi7pcQPlPCnBS3RszII=;
 b=jgVWrTnSte77Mc7uCombs0Ultb9rH7UevxOLSYL/3VEbYXouEGub2mHDKI2OQVB0PnZxxjEpltPBYP1BRB5rkm78dIh73/9PsMYMJCHmul7gQc+SaijGbVEIXCjrQ0OG52AU0yKCHopDAUr6ZOpEc4iWhjuLwGfaH5ElPZJZJZ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by DM6PR12MB4217.namprd12.prod.outlook.com (2603:10b6:5:219::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.14; Wed, 18 Feb
 2026 21:09:40 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::f71e:4264:146c:b356%6]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 21:09:39 +0000
Message-ID: <69b4d9c7-5fc1-4562-865e-1388b1f40e66@amd.com>
Date: Wed, 18 Feb 2026 15:09:35 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] Add RMPOPT support.
To: Dave Hansen <dave.hansen@intel.com>, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 seanjc@google.com, peterz@infradead.org, thomas.lendacky@amd.com,
 herbert@gondor.apana.org.au, davem@davemloft.net, ardb@kernel.org
Cc: pbonzini@redhat.com, aik@amd.com, Michael.Roth@amd.com,
 KPrateek.Nayak@amd.com, Tycho.Andersen@amd.com, Nathan.Fontenot@amd.com,
 jackyli@google.com, pgonda@google.com, rientjes@google.com,
 jacobhxu@google.com, xin@zytor.com, pawan.kumar.gupta@linux.intel.com,
 babu.moger@amd.com, dyoung@redhat.com, nikunj@amd.com, john.allen@amd.com,
 darwi@linutronix.de, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1771321114.git.ashish.kalra@amd.com>
 <9c77e206-442d-4891-bb29-295bc8bffe20@intel.com>
 <65986f9e-59e8-4f1c-aaa7-1edf45af24d8@amd.com>
 <31b42ba3-dd0c-42e7-ad1e-800c5cd2bcf8@intel.com>
 <cc930514-b0c0-4b9f-8287-aaee2878e668@amd.com>
 <2398df04-082d-4d98-beca-f85de385941a@intel.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <2398df04-082d-4d98-beca-f85de385941a@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0077.namprd11.prod.outlook.com
 (2603:10b6:806:d2::22) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|DM6PR12MB4217:EE_
X-MS-Office365-Filtering-Correlation-Id: 1937ea0e-2cf5-4d92-19d0-08de6f32073c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVhMTmh1ZVkvUHdya2QzajhzakRNdXpwR0hrNHk4cHFMaCtUSnVoOHlYUVVY?=
 =?utf-8?B?NnJPWHZZenBTV0lyZlJmcFYybDJSWVpaUUFBdVpLVkFLTUZObE01dlFML2Ew?=
 =?utf-8?B?UUZaMDcySDkvQ3orS1V2amc4anBpTEtGOFdUSEp6ZkYzL2JVelhEK002VC9u?=
 =?utf-8?B?K0NmSmhva0JoNjFEbHMzWUJUdElnd2cwa3BMZXUrcU1CcXJzWWtZSE14NHI4?=
 =?utf-8?B?a2dmQ01Ka3BnMjcrRnhNWDY4M3lGNjg4WmJYUUhBVkw4aHE4S0dJSXRLVzJm?=
 =?utf-8?B?TkEzcXY1R3RiSm1PdDl6cm1ldWRpb2JHQyszZXFBeFZIclRlZXZmSi80bjlF?=
 =?utf-8?B?R1ZxN2U2M0NiL20reE1EaktINy9rS2lXYkIxcCtLRXgxbERoWlB6UE5YaUc3?=
 =?utf-8?B?TVU1TmdCY3dvdFQxQjJFUHFWYVNnbkd1OG0zazZudDc4WXk5bUVJNnRFWmcw?=
 =?utf-8?B?cU5RSkIwL1RpZ0VMMDJUSXZyYS9rWDFSeHNyQy9mZ3lPczA2a0NTUE1FNVV5?=
 =?utf-8?B?OEQ1LzRDS0dmZk5ZalpYNmsxczFsY3Z0c3l5Nk9PbkpxT1gzR04wZHNjaGFo?=
 =?utf-8?B?UzcwbHpkUWc3aUdBWWNCWUdMSjBnRXFMbWM3THpoUXpkMnY3OGhUeWtuNkg5?=
 =?utf-8?B?Uzl5c2t2Y0RmSi9sYkhWRVhnejh1UEFNZENVdEMvU0F3NlhPSGNCcnRnU1I1?=
 =?utf-8?B?MFdTS2pVaTh0QXpDWEp1eWMwNlNvVFljYkFFNGpKVUNvSkVKWGZ1dkVFRVpS?=
 =?utf-8?B?Rm1UYXVDRDdOU013K0NMTG15TFlQU3F4NUNwNGJpOVhLa2xiQ3dZbWJxajd1?=
 =?utf-8?B?UC8reUVjOGFnTy9jSkJJQWdSOS9Jb0R2SU5EMldQUXRaemR4bkVycllHLzVY?=
 =?utf-8?B?czhLbnpDS2Z1UEdEZHdoZUYyVnBzYXZtaG5yZzNtRWhlRGVuVGJaL1hJYmxv?=
 =?utf-8?B?ZDRrUmRIZ1N4VWJDSGpUb0FzYy8xRU5FYVVnbmYxazBmOWVnTk8vK1M0bVdz?=
 =?utf-8?B?a1NtVVprcnJyL3ZsWEFrY0IxVW41RXk2Zk9lcEd4V0J6ZzN1eXg2SHd2bU0v?=
 =?utf-8?B?ZnU0MnpvNjNoaHd5UDFrbStmSmd2THhYQndhemtqZHFCcDZNekZOQnpXUnVa?=
 =?utf-8?B?WDRGUDh1c3FXQ3orWUp5eWY1YWZyUXlTei9GdmgvL29jZnpvQStqeTlwZXRr?=
 =?utf-8?B?WXpzWXhDSk9ZK0NVckgvN1BLVTUyY3dvUlh3bmR1bVhKb1ZKTWpsTUQ2SXJY?=
 =?utf-8?B?anc5bFA5NHl0RXJOdisrWGVxL3NzSkdnY09qQVQ5VTBoZ0xBTE92VlYzb2sx?=
 =?utf-8?B?UmRNUjV6WXduNFZzenVWK3N3WHBuWkt2eGhIQlpqVjVYeGlEakVVY2prbko4?=
 =?utf-8?B?U2JNWGxNZDlQV00zRG53bmxoZ1pjZHlyc0kwRXd1b01NRGRTYzZCdDRSdzA0?=
 =?utf-8?B?KzVaZENPUTBkeEN1RVdTUjNFSVpkZDdPWUpmc2hQSnZoRXRqNjdsMTd1MkZG?=
 =?utf-8?B?M3ZqajArdEtzRHRCSHoxZEltbUY0NGJvRHY2MHRkLzEyazJkVjR6TlZuZi9l?=
 =?utf-8?B?d2ZGTTBIVGdYTkJQOXVIR01aZEpRTkNHVGNDOCtRVi9HMzFLMXFIa1hYbm5D?=
 =?utf-8?B?YndOZXNLNTZIMlM2WVhxbklYaVZ6bzAra1J2ZjM5MjFKMVY2Z3RRVHFpQ0ho?=
 =?utf-8?B?RzcybmwwN2MrQ2YzTGU5YVB0dzkxNzRkOXlDdVd4akh1Z2c3Z29YQkFSNito?=
 =?utf-8?B?WlpOT3MwOXpCc1FjbEYwcmdVVytYSUt0Wi84L3I5cGI2enBoUkxkWEhvZWs5?=
 =?utf-8?B?OEt2ZTArb0c4d3lpZkVCR0ExKzdOcm1jckQ3aWdzc1lpV25XeUJ3RHBBZGlF?=
 =?utf-8?B?RnF0anVOTm5WVUJJcldBRmh0Ykt4VDBRTVU0c2lES3l0dE1GRUcrYXd0NlBL?=
 =?utf-8?B?VzhjQmR2cHlJRlZrNEhXVDJDVWNlZmJaZFd6QXh2YU5RVll2dTBuRjlNeGxx?=
 =?utf-8?B?WVNQbE5neGF4RklScDhRVFhlVTNyYWZGYUdlSGNFMmpSVHdqeExEQmhHNkg2?=
 =?utf-8?B?Y0xjT0lqcDlCSEpkaWhhUmgvckhtT2U3dTZQb3pjVzlRN255dktadk1mQkZa?=
 =?utf-8?B?UUNqbU5RdC8wZ0ZiblRieGtTUDF4Wks5TXVqcXV5WGVCZStneVExeHVWNE5E?=
 =?utf-8?B?Ymc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?czNEVHAzR2JNWloydDFzSzZNNEVONEliQVBpSUx1VCsvRU05N1JUNi9ERDI5?=
 =?utf-8?B?Vk1YTnB2SWp0Q0NZNTNrcGlsWDdoL1FBVklkQVh4Z0VHanNVWEdoSmxxQzMy?=
 =?utf-8?B?WmU2UjkzY2wxVFJSQnQxVUU4TFFOdDVUNjlWcTB5NTh4MytZTEVYa1V4dG9n?=
 =?utf-8?B?cHNzVnVtQjIvOG83aXJrYU9iOUNFcXhEQTdJcnQ5Z0pXdk5uTGgzbU9xUmZl?=
 =?utf-8?B?dlBQejF3bFZnL0N1bE9BcDV6RWNVam5kVU5WVExqTTdqbUlMMmEvd0FVRVVx?=
 =?utf-8?B?TU9sMlFqSkFEZXVBa2p4SFJjZ0RCWG55dDArakFEaHFjQkxQMGdQWFlhREVn?=
 =?utf-8?B?elBoaU5HNW12eElqUUI2c0NPeTVLdlNxNmQxdU9jSXp0K2pVMHZuNlZ5RTFX?=
 =?utf-8?B?MFRZS2E0eHdUNDg4RDdYOUZwZVU3QjNGazRLbExobG5jM25qUXpSSDkyeTRJ?=
 =?utf-8?B?Z2huaGtTUjFkOEV6UndmUzMwUVJsTlUrdjhnUXE4Rk94eEt3T0d5Wml1bGk0?=
 =?utf-8?B?SmRXL1NDZm5qVVdKcmhYdXp6eWNrb1Z2dXhhcy9BQW5aSjhpSC92K2dFTEE0?=
 =?utf-8?B?alhLK1ZNVHl2Qk1qcnlUWlRjTXU5QzdteDREYWtZRjBnNW1GMU9IN00wc1l4?=
 =?utf-8?B?OXBZd0hrWGtNRkJ2L3dFQlowNE1xQ084U1U5cTgwQ1VMN2hnSUZsMHpNblJM?=
 =?utf-8?B?Mmsxd0RPUml6K2VTZzBVWGlidTJ4a0tDZ0FWSlhISEpFOENuVDFTTWs2eVNw?=
 =?utf-8?B?Ylo3ZGtSclgwVDNEL1B1dzg0VGpaMjFLeWJkVWdhNnJsZmNRQmtoK3JXL3J1?=
 =?utf-8?B?Z3gxUGs1cVN0MTg0N1lDOGVNa1BKUVBRS09tclVhWDZ0OVBlNFNGRmYvK2hh?=
 =?utf-8?B?Nk5xQ3I2dzlkWnBLNU5RTDlIdVdWQXhwancyOHFQYWRjODY5TWFUZndGcWtI?=
 =?utf-8?B?QUtybGJVR0JPTGJyR1JNd1RtUUxqNEN2M0VqaXNISHk5bHIrUXhGcStiUU9P?=
 =?utf-8?B?cmZZanNkRnBET0p4RTVoNmJBbTFPOHBCY3ZxeG9xanZuOTNITDlab3pXUXRN?=
 =?utf-8?B?Q2dZellERllsa1NKQU9RYmxSczNLVnJxRjZXWEJoTjJmQ0c0dnVOTnI1OFRX?=
 =?utf-8?B?bWIweTk5bjgzN0hoMU15UFp3ZzJHQmd6UTQ2bWJiV1pVMEtYbHdxaXVxOGJB?=
 =?utf-8?B?S2txZEtnVktkOTk4VUsxMUxESmlSY0toVEpqcVR3M1Q5R1ZNRERKeHhpcmRS?=
 =?utf-8?B?RWcyK2lVQ0MxRnZSaE1VZ3ZqeVdvLzc0bklhQnNBYisxRkNjejNpZENmNU9H?=
 =?utf-8?B?enU3ZXNTK0Yxemo2YSt3ZE9iWXV3eWUvU1ZFZWp0cW9McDdPbjErUll3dDNx?=
 =?utf-8?B?Y0pMVjdUYjFkNkVqQ0w4WC9IbmswOTYrSUE3UjlTdFE2blNkc1pVYk8zWmM2?=
 =?utf-8?B?dmNxR2ovT1F5SzZBV1FaTnljbXFzTWhPOENLL3MxMGhKZTlNNUhnNGpPcXN6?=
 =?utf-8?B?d1Zka0o2SDFhcy9BamZwNUtNY2dEcDQySnpOVzlhS3BHNWYrYUpxY1FvL3ZP?=
 =?utf-8?B?T3UybU1sdStNS1JoSU1sZDNyMWZCdWRlUDRHdE1nWVlraVBOR2oyMk11RVJM?=
 =?utf-8?B?bFJOZ2psbUFMdzc5U2hpdmlqQVNQT0R6MlFTL0lpbnJOdHgzTXZwRDBibWM1?=
 =?utf-8?B?ZXR0Rzd2dTh2TkZ3Vm03ajBGS2cwaTdPWkZ3YWxyRVZ0ODMwSXIwdUtidjRk?=
 =?utf-8?B?UWRtOEJiZFlrM2xObUFWdVkvUVZnN0hMdXhIcUsrZlJ3aDFvc01Id3J6ZXRh?=
 =?utf-8?B?cm5kbS8zQ0N5US9mdUZxVXNKa084SHpZVkJBZyttNGdFOC80Y2tNL25BV0Nz?=
 =?utf-8?B?R0F2QVBaZzh2MCt5Y0t1ODV1TlpyVTRWakxuVVVOOWhLdis1ZUVyaUFaYkYy?=
 =?utf-8?B?VGhtbjhiWkpHRFhDeWVJQzFxQnZLSHlzZmlTWEo5QzlEOEM2Rkh5QjdIL3dH?=
 =?utf-8?B?Ym9pL0dJM3JSUmViV1hxQmRDczdqc3gxcm5VRFZJTDE2SXhkSElMemg2dFcx?=
 =?utf-8?B?VlB2bGZ4eHBNODkrYUpFOGFCUHBIMEF1NDVVUllUR2lYRDlYZ0o1MW9SelR2?=
 =?utf-8?B?QVdOdzdobVVnaUZvRlhHT1ZOS0R0bWhxSDErUitXNkNUWTBxV3pncVJON2ty?=
 =?utf-8?B?NUNiZDI5dGpPWGVvOU5rQ2h5YUNyTDJlV3FoT3EzQlZLRVlVN01ZNXRNS2Yv?=
 =?utf-8?B?M2tCWlljK3VOSDhmYWFzcWFpeEdyQ2N1aVpHN3ViMWI3Sk53eXpLR3JJS01W?=
 =?utf-8?B?M0tEdDBLV1hKTHJQK3RidFlnWGtyNkdOQkdtMjRFMzlHV05RVHordz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1937ea0e-2cf5-4d92-19d0-08de6f32073c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 21:09:39.5550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: csgKZ/q8XX6D58WGFeiX5Wc7G8OQXz2mV9+sN7r6MItIslauKSr1AXpIGC7OCnp8DLA0J51iMbgurmN2wIO7NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4217
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71275-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[34];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ashish.kalra@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 0B5E2159CAA
X-Rspamd-Action: no action

Hello Dave,

On 2/18/2026 11:15 AM, Dave Hansen wrote:
> On 2/18/26 09:03, Kalra, Ashish wrote:
>>> They are known not to contain any SEV-SNP guest memory at the
>>> moment snp_rmptable_init() finishes, no?
>> Yes, but RMP checks are still performed and they affect performance.
>>
>> Testing a bit in the per‑CPU RMPOPT table to avoid RMP checks
>> significantly improves performance.
> 
> Sorry, Ashish, I don't think I'm explaining myself very well. Let me try
> again, please.
> 
> First, my goal here is to ensure that the system has a whole has good
> performance, with minimal kernel code, and in the most common
> configurations.
> 
> I would wager that the most common SEV-SNP configuration in the whole
> world is a system that has booted, enabled SEV-SNP, and has never run an
> SEV-SNP guest. If it's not *the* most common, it's certainly going to be
> common enough to care about deeply.
> 
> Do you agree?

Yes.

> 
> If you agree, I hope we can also agree that a "SNP enabled but never ran
> a guest" state is deserving of good performance with minimal kernel code.
> 
> My assumption (which is maybe a bad one) is that there is a natural
> point when SEV-SNP is enabled on the system when the system as a whole
> can easily assert that no SEV-SNP guest has ever run. I'm assuming that
> there is *a* point where, for instance, the RMP table gets atomically
> flipped from being unprotected to being protected. At that point, its
> state *must* be known. It must also be naturally obvious that no guest
> has had a chance to run at this point.
> 
> If that point can be leveraged, and the RMPOPT optimization can be
> applied at SEV-SNP enabled time, then an important SEV-SNP configuration
> would be optimized by default and with zero or little kernel code needed
> to drive it.
> 
> To me, that seems like a valuable goal.
> 
> Do you agree?

Now, RMP gets protected at the *same* point where SNP is enabled and then
RMP checking is started. And this is the same point at which RMPOPT
optimizations are enabled with this patch. 

I believe you are talking about the hardware doing it as part of SNP enablement, 
but that isn't how it is implemented and the reasons for that are it would take
a long time (in CPU terms) for a single WRMSR, and we don't support that.

And if RMP has been allocated means that you are going to be running SNP guests,
otherwise you wouldn't have allocated the RMP and enabled SNP in BIOS. 

The RMPOPT feature address the RMP checks associated with non-SNP guests and the 
hypervisor itself, theoretically, a cloud provider has good memory placement for
guests and can benefit even when launching/running SNP guests.

We can simplify this initial series to just using this RMPOPT feature and enabling
RMP optimizations for 0 to 2TB across the system and then do the optimizations
for/or supporting larger systems as a follow on series.

That will address your concerns of performing the RMPOPT optimizations at
SEV-SNP enabled time, and having the important SEV-SNP configuration
optimized by default and with little kernel code needed to drive it.

Thanks,
Ashish


