Return-Path: <kvm+bounces-25799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A2E96AC91
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 00:59:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 747CB1C2478C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 22:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1B41D5CC6;
	Tue,  3 Sep 2024 22:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1Gtyrltt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C78126BE8;
	Tue,  3 Sep 2024 22:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725404332; cv=fail; b=eWfDcjhUXMpRDO5P1H60Jghy6RWDxeyS2vQcFu0MH3/54h0qspoOfvIKEZq+gUp+R+M5yomPEoxvy5LxzYv6iZ1KmzR7Np9+7QDYx4vwfH3qpH3gTSiTFUnZMALmTBChXxpcKbvNMJvbTA84ZEK4mwGBdnFXt4HfRJ06cCciLaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725404332; c=relaxed/simple;
	bh=vGB1gawiEcnkl3hQgVNZp49ifnkCdaOZy0La8ar4V5w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CYy+0W3EzQ9B7TP9zxczJk2N9dIphtbjjUufajE6gvOnDXM5Axfiy8HCI6gKplZcpKZiOEQ9TSh6ucxdcX9QsZx2eHyFS9muI03KgRcjcE2VAYF9tPvjgwDKfNlOwsU1Illiv5Cfkzu8U/7VtShxAfL3ZCAM8IvGlz2GqIw+ogo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1Gtyrltt; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YnndKO18zx+gbR89KVyb9P0Y+T7n+ghEa5C/uLD1P4vwpr3BBL/YM3xO2rcYqAXQxUvhanNUvKpKtD9joU1QZ7GTdxIS9GAvOfmkFI4QFarYx+pQ+kc0DeykPYG0yz5AhAU3Xz8r1p6hTSe7QEUXLZ/Z83PPWigwOGwEx7LdTTDKU4BZNuRyQ8JzqUUcn2ovmqzCPHHmceQFy5bPOG6mYqQ5fdNrcPxjr82Bzb2ugsmAOjCdT7KYGIDA+EPoxgVIExYCsRAXL+1FDVmmlT/mvIDhtxVJxXVDnP9q6Hvw4g2tQesmr91tJ3D85kBy6P3iBqxE+rQ2NIh6MfD9sTS/rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oiA516XHq8NEIpYKYb2pw92MONMjL1AihOluMb5ho+E=;
 b=lQHI9POcV2uZ7DxQr2+PsPB+gcjasZXNkxjoAkb4mjpsQvJr/oK8fZaq2cThQfFj5MYatDTVb2ugiq5Q77FJJm5YbIBT3hcUKQql5bBL0XcpV8rx+Oanf+yfsCiptYxiHSbp33smoFAUwEWu5LYWx69m1+3h6B/i8yR52yvsE2TcDB48rKYHuGoQ0f+1coUT8Hi04/CH+TmuIiPVQW8ldUTrDxVYWWFZjJMlUsWr4ncDDavCNhxwYGrerMwcVaka+4u/J8HaHZxjjWgUVxiZUULC916Q+pQcQ+TqzDzFvxmC4qNSuAE0QXKsarCuugOQ+x56redmyZgcn/7NfVkrfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oiA516XHq8NEIpYKYb2pw92MONMjL1AihOluMb5ho+E=;
 b=1GtyrlttgZcMjSfI5y66L4MAeZ0azt2w1oI0h3xw0KlkWn8GfEZBjIIZApLyGX9PIkJ4EO2acNSK44AoTCoD2Z+KszZzr7pSSRUt92dxnwHHDWzrTbB3aHE1HWWGje21CKfGLzLYqV+zQ8ELCRW0zEekdND/a4LezoXtwRAQK0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Tue, 3 Sep
 2024 22:58:47 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 22:58:46 +0000
Message-ID: <fbde9567-d235-459b-a80b-b2dbaf9d1acb@amd.com>
Date: Tue, 3 Sep 2024 17:58:44 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86/sev: Fix host kdump support for SNP
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, dave.hansen@linux.intel.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 thomas.lendacky@amd.com, michael.roth@amd.com, kexec@lists.infradead.org,
 linux-coco@lists.linux.dev
References: <20240903191033.28365-1-Ashish.Kalra@amd.com>
 <ZtdpDwT8S_llR9Zn@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZtdpDwT8S_llR9Zn@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0211.namprd04.prod.outlook.com
 (2603:10b6:806:127::6) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|CH2PR12MB4133:EE_
X-MS-Office365-Filtering-Correlation-Id: 135a9c13-cb1f-4766-6fe5-08dccc6bf76d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cy8vSHpPck13eGdtRWlxNi9NN3FjSUl6OThqM3lZMFAwRG1VRG9pY0dxNUFM?=
 =?utf-8?B?TEM2ajBiN0lpSElhSWZVc2psNzdhaVp3KytOS1VTQytadENkcElhUEVUTE9Z?=
 =?utf-8?B?dXlLN05LTTZrTjF5QjFlQWVtR3phWW5SZmlvaHh3UlFVUTdBclo1ZlpEOGI1?=
 =?utf-8?B?dnpVVG9ickpTRUF4RXJmNkRJSUMwcEYwRHBib3ZMSkZ1NXNuTzgrclpQYzhx?=
 =?utf-8?B?ajE3ZWxWYmI2NFZ6THpoWWtQZWczSUhVaW1Mb21wdVpOakhWVEZKVEhuUXU0?=
 =?utf-8?B?akhQeTVINytjVVJaemJYWExxWWQrOTJJdnUvVlNOQlpaNGVGZm1CeHF6OHpG?=
 =?utf-8?B?ZjNxZWh4N1E3YnRDeDZGcUpTVHNDSHhsNzNIVWpqZUszaW9iL09mYklUQmly?=
 =?utf-8?B?Tlk1VmY3MXdTNE1TWko4MXlCcE94UmpBcU41UHBPZkVGa0lOZmpKU09kSUFC?=
 =?utf-8?B?Um5HRW1ES3BVb1JLRUJKUWxUZWc1NnRNK3JucUV3bG1zL2NRSVRlcDVsRUR2?=
 =?utf-8?B?bG1Oc1NHWmlFdDNhVm9PWHIzRExlNkNkRjIxcEJEK0h5QTliNXVGSElaYWpG?=
 =?utf-8?B?Q0JFV0RJcUpuK2Z6S29NcEdabU1LT081Zy84bXp4SFFwaFoyVHQrL0thcmhw?=
 =?utf-8?B?SGxLVXVzQUNOc1JaVHdkRFZsbjcremQ0NnExcHR3QUJ3WFUzdVhOalRzNGpl?=
 =?utf-8?B?RGRDdkhZRWxzNDV3a28wcnFzV1ZQeGlTMkhtQ2R2LzBoaWtQS3UwVDNSTkdD?=
 =?utf-8?B?STJnVnlJRVdWU29LYk11eVZTdUVWb2VkcFY5TUI1ekFGNmtLMFFrZFZ3VXBK?=
 =?utf-8?B?Mks4a3YrcFlUSzFxSjZXTG1vSVlINkNncVp3dTE2ellOTUZMNmp6Y2xodkZp?=
 =?utf-8?B?OGkwVENmZWNMdzJEV3g3RzlscmF5M1JIdEZDQk5LNHh0c1NtNlNiL2JFbWY4?=
 =?utf-8?B?WGUydVJZellFTGI1c2dnbnRQZmhaN09RWDZSTTkrbnF2NTBOT2Q1b2o5VFA2?=
 =?utf-8?B?UitKdHoyOW04eGcwU0tiUXJCd3FBdUl1OFFVRmhwc0tyY1dRSHV0Z2trdllP?=
 =?utf-8?B?NUR4TUJMMVA3Tjh6RDkxbnFoMm9oYkVrZmdSbWw0d0lQNURGSVcxVUowRjlE?=
 =?utf-8?B?RDl1azIzbWU2Q2JicmhZVEl5akovSG5ERnlpTlZrZGNqQ3YxcXZvckRMUldt?=
 =?utf-8?B?Wm1mVmpxaEhTQ2VPL0g0N0ovNVRKMFJGOE5kUmdwd2dHQWFpd0JLZGhNSm1r?=
 =?utf-8?B?SjlDWUZZMlR5MksyaUphdGpxcGExV2Q1cjlkR3Y1WEk0SHM5MVVKam5HdEk2?=
 =?utf-8?B?MmRlRytIR1YvOGxYY2Z6VlJFdWVZODY1MjFHalVqaFBDbjNvN1hqTDRieVRM?=
 =?utf-8?B?S0FWYmtVcDFmK2o1cmZlZ1luS0JyT0NMUEpQMkZlR2tvUlg4c2NBU0YweHlX?=
 =?utf-8?B?eHVienUxMU5pRkFTVWdERGNjNFJKY1JGWnJ4UUJSdWpybGdWNGJtYlhkM2s2?=
 =?utf-8?B?M1N6K0hwUElWNmNaUEw2VVVrdEJ2VjNFSUZsUVBuK3VoQzNUeTByakdJdGcz?=
 =?utf-8?B?dDZGOHErR0tsV2JTZHM1SjRJKzhjQk5FQVJneU4venJMZWZJbUQwU3RHMUZT?=
 =?utf-8?B?N1piOFp5aXJyQVliQU1iKzFnNDJlU0M5ZWdmRk5lY1ZEb1lBL2U3dVhwRVVx?=
 =?utf-8?B?WEtlUWhlZjlneUszejR3ODhuTXNMOHlMYlFETFJaaTZMdnlQZkdSNVJOQ1My?=
 =?utf-8?B?eGhpZndGT2FTdDgwanJ1TVR6Ylc2L3pGaExIcmJsS0Q0Z3BIQW9rR25VVzlh?=
 =?utf-8?B?U09SZGpVVVM1cEJqRWtFUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bS8vbGpteWRTUGZBeHBLakZTdmx2STV5UHJYY1JFZUZMK00wc2g2OCsrQ2JQ?=
 =?utf-8?B?ZFY4STZZellpaGlOdHdqYmxLeUhNdkU1b0Vlb0N0MlArM3NlZ1UvNUhwZ1NQ?=
 =?utf-8?B?STNCVk5SY0RISFJRbkxXcEVvNnRaYlpvNllrVzNwaE5TVStZb01DSVRHd3dQ?=
 =?utf-8?B?VWhaNHlVUW1jWnVzUXVzODIwZ3gwTnRiM21Ic0pJMGZad2NhMEdRWkhiTllY?=
 =?utf-8?B?SmdOUHZzS21yOFpwTFp3RlVyc3Q4WjBRTkF0eXpVZ2FxRVlPQU5TaExBTEFI?=
 =?utf-8?B?VTdvQ3FyTGJiazNSbkh2bzBaWTZMbzVZSXJUOUdNS3hMNi9jWElEUGlPL2Vs?=
 =?utf-8?B?bFJoVVUyMldUU3A0RTJjM1F5K3A0cS9qcXNCT1d0Um9XYm43NVNNdkRoNXVm?=
 =?utf-8?B?VWdwR2lSSnZFaENNbmVyUThrWnRyVSt6aE5WR29BOTJoaTVRNlRhRlZrQXJs?=
 =?utf-8?B?b3hTRm9SdlYza2dYbkt2RHkxRjR2QTV6SUlNaUFsY0tFV252eSsrMVNDL2Nw?=
 =?utf-8?B?SVBkSHAwWkZtejgyVEtqaXBDYzA4Z3I5R2Y2U1RrWG5mNUp6amlDc21sMlFs?=
 =?utf-8?B?YjVqNEdqWlRzV1o3VnVKZnkzM2ttMTdZOHVDSlJsdE5FYklPWmlCN3FUYnND?=
 =?utf-8?B?THBPeDZ4amtnWnQ1YWlxNnNWMStXUDlIVTg3SlY3SU82SlpFMGVNWlFObWF6?=
 =?utf-8?B?T0ZSZ3RRRDN1ZU53UkgrREZFS0NxUDMyOFRrQnhVems4ZE1NQkp5TWY3cXRy?=
 =?utf-8?B?bjQ0UzdVSDNnNVdvRnRzekFLbS9neHM2NW53NHpPVXh6Q3E1TWRPajEra0Rz?=
 =?utf-8?B?N0Exdk1qc2FiU0lIMFBmZXkrS2xvMEVzMWF3S1MwbCszdFAydnVKeUF2TFVO?=
 =?utf-8?B?TExwbGMwK0pjMkROdGVFVUVJNE9lS216VU5GdEJobVFwcCtoeWRTQmx5RTgx?=
 =?utf-8?B?MHhLVEtJY3ZVd2QydnZnbTJvOU5MTml1eVF5azFaZUt1MTVJaURyYTlEanUv?=
 =?utf-8?B?Q25icFY3TkxLdVJ3M0tJdVVEYXVtMU96ci9IaHJQdk5nVHB2UDVReGdEYzQ1?=
 =?utf-8?B?NXpOemFNMlNTdGJ2elhqcGRjTW9zdU8vZy85TVEvSFJ1ZmNDalluZ2ZjN0I2?=
 =?utf-8?B?Qnoxd2pDM1lPTEhQUzV4MHdsNmJvbXJUQmhBaC9HQkg0SHRIWFFMV2lkM1Nu?=
 =?utf-8?B?VWt2V3djcXJ5a0tWQTFnSlc0cUdianpMb2JRYzlZMmVPWGxmK3Z2amVycXBG?=
 =?utf-8?B?VE51Z29ZUWFRSEdMbWxIZmVONVVTQ0YrYjM3dFFUQWI4aWIyZEZHUS9Ic2p0?=
 =?utf-8?B?WUF2YTYvY0l4ek4rTStRMk9KRVJ2Nm1UdFNGKzJhTUVoVEEzcUlrSGFYQWNa?=
 =?utf-8?B?UzVWM1VBb1dtWnQ4aFZ6SEQ1ZVhHbFM2Qi9Kbnh6d0JpR0EwUmZNc25QWUpI?=
 =?utf-8?B?Si9UOTRObExnNzJacldSOE1WMU94bFFjU1ZSSkVFeHZYY3RCTHgwaFFOc0VO?=
 =?utf-8?B?UFZEeVBxeVpQQ09McXA4ckl5L2U1dERsNkcvalYzbFdSRzNhbG9yK3VNNzY1?=
 =?utf-8?B?T0RWMUpIcU54VnFQblFUWGxoTGg5cExiRzJaV2hDVitoTWZvRnEra1J6ODNr?=
 =?utf-8?B?WE8rdzBBYlB4UHNMeFYzWFMyOEVveU9IaFVTb3Q4V1ZmNE12bW5iMm90bk9I?=
 =?utf-8?B?NVRoT2t3ZG5GcUtDaXJLdlJXUFFESWE2ZkptK0ZqWUh1eXpyUGw0TWtISTFB?=
 =?utf-8?B?WHk2UTB5Q3NWMWVqNDYxZmJOZlJHK3FtQld5NWJDNXM4bkJCcHNpZ1A3M1FL?=
 =?utf-8?B?ZkNQVzdmMlRVUFk5ek1tblY1VTRiY0lSOWZuR2tDbXRiWXBmbFhzU2RLb3Ny?=
 =?utf-8?B?eHFKZElZNEhiZjZxSUdVZHZ2Q21lQlJaMmxTQkRKL0h3UlZXWTBtMGFPMXRk?=
 =?utf-8?B?dVVXTFpETUtvakxxam5EOVJCdWNzM1F4SjlLVy9XeU82NGl1U2RHM3ZHTXNp?=
 =?utf-8?B?ZjN4c0RLUURXSFhOdHg2TTJHY24xZmNEcGYyVjQxaTRDdjZObU0xWU56QzdG?=
 =?utf-8?B?b1E5b2xMVkFDNFpKUmhpYzlqMko3Qks1OGpGUDU3SkhCbkE4NEdnSlY1d2Zl?=
 =?utf-8?Q?VLUU6nchc8zYHJbI36Q76q0x7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135a9c13-cb1f-4766-6fe5-08dccc6bf76d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 22:58:46.6934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ApayoxXxr7JyaB6YPladAr5TDcHxsT4yRzbQwsh79wLz7J3p2JVymFDHc1eVO3+XO5ZYCFsAMATn8AQGg1DmWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4133

Hello Sean,

On 9/3/2024 2:52 PM, Sean Christopherson wrote:
> On Tue, Sep 03, 2024, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>> [    1.671804] AMD-Vi: Using global IVHD EFR:0x841f77e022094ace, EFR2:0x0
>> [    1.679835] AMD-Vi: Translation is already enabled - trying to copy translation structures
>> [    1.689363] AMD-Vi: Copied DEV table from previous kernel.
>> [    1.864369] AMD-Vi: Completion-Wait loop timed out
>> [    2.038289] AMD-Vi: Completion-Wait loop timed out
>> [    2.212215] AMD-Vi: Completion-Wait loop timed out
>> [    2.386141] AMD-Vi: Completion-Wait loop timed out
>> [    2.560068] AMD-Vi: Completion-Wait loop timed out
>> [    2.733997] AMD-Vi: Completion-Wait loop timed out
>> [    2.907927] AMD-Vi: Completion-Wait loop timed out
>> [    3.081855] AMD-Vi: Completion-Wait loop timed out
>> [    3.225500] AMD-Vi: Completion-Wait loop timed out
>> [    3.231083] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> d out
>> [    3.579592] AMD-Vi: Completion-Wait loop timed out
>> [    3.753164] AMD-Vi: Completion-Wait loop timed out
>> [    3.815762] Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC
>> [    3.825347] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.11.0-rc3-next-20240813-snp-host-f2a41ff576cc-dirty #61
>> [    3.837188] Hardware name: AMD Corporation ETHANOL_X/ETHANOL_X, BIOS RXM100AB 10/17/2022
>> [    3.846215] Call Trace:
>> [    3.848939]  <TASK>
>> [    3.851277]  dump_stack_lvl+0x2b/0x90
>> [    3.855354]  dump_stack+0x14/0x20
>> [    3.859050]  panic+0x3b9/0x400
>> [    3.862454]  panic_if_irq_remap+0x21/0x30
>> [    3.866925]  setup_IO_APIC+0x8aa/0xa50
>> [    3.871106]  ? __pfx_amd_iommu_enable_faulting+0x10/0x10
>> [    3.877032]  ? __cpuhp_setup_state+0x5e/0xd0
>> [    3.881793]  apic_intr_mode_init+0x6a/0xf0
>> [    3.886360]  x86_late_time_init+0x28/0x40
>> [    3.890832]  start_kernel+0x6a8/0xb50
>> [    3.894914]  x86_64_start_reservations+0x1c/0x30
>> [    3.900064]  x86_64_start_kernel+0xbf/0x110
>> [    3.904729]  ? setup_ghcb+0x12/0x130
>> [    3.908716]  common_startup_64+0x13e/0x141
>> [    3.913283]  </TASK>
>> [    3.915715] in panic
>> [    3.918149] in panic_other_cpus_shutdown
>> [    3.922523] ---[ end Kernel panic - not syncing: timer doesn't work through Interrupt-remapped IO-APIC ]---
>>
>> This happens as SNP_SHUTDOWN_EX fails
> Exactly what happens?  I.e. why does the PSP (sorry, ASP) need to be full shutdown
> in order to get a kdump?  The changelogs for the original SNP panic/kdump support
> are frustratingly unhelpful.  They all describe what the patch does, but say
> nothing about _why_.

If SNP_SHUTDOWN_EX is not issued, or more accurately if SNP_SHUTDOWN_EX is not issued with IOMMU_SNP_SHUTDOWN set to 1, i.e, to disable SNP enforcement by IOMMU, then IOMMUs are initialized in an IRQ remapping configuration by early_enable_iommus() during crashkernel boot, which causes the above crash in check_timer().

Also, SNP_SHUTDOWN_EX is required to tear down the RMP CPU/IOMMU TMRs.

Additionally, if IOMMU SNP_SHUTDOWN is not done and all pages associated with the IOMMU are not transitioned to Reclaim state (and then subsequently by HV to hypervisor state) there is a really high probability of a fatal RMP page fault due to collision with a new page allocation during kexec boot due to collision with one of these IOMMU pages.

So we really need SNP_SHUTDOWN_EX with IOMMU_SNP_SHUTDOWN=1 for kexec/crashkernel boot.

>
>> when SNP VMs are active as the firmware checks every encryption-capable ASID
>> to verify that it is not in use by a guest and a DF_FLUSH is not required. If
>> a DF_FLUSH is required, the firmware returns DFFLUSH_REQUIRED.
>>
>> To fix this, added support to do SNP_DECOMMISSION of all active SNP VMs
>> in the panic notifier before doing SNP_SHUTDOWN_EX, but then
>> SNP_DECOMMISSION tags all CPUs on which guest has been activated to do
>> a WBINVD. This causes SNP_DF_FLUSH command failure with the following
>> flow: SNP_DECOMMISSION -> SNP_SHUTDOWN_EX -> SNP_DF_FLUSH ->
>> failure with WBINVD_REQUIRED.
>>
>> When panic notifier is invoked all other CPUs have already been
>> shutdown, so it is not possible to do a wbinvd_on_all_cpus() after
>> SNP_DECOMMISSION has been executed. This eventually causes SNP_SHUTDOWN_EX
>> to fail after SNP_DECOMMISSION.
>>
>> Adding fix to do SNP_DECOMMISSION and subsequent WBINVD on all CPUs
>> during NMI shutdown of CPUs as part of disabling virtualization on
>> all CPUs via cpu_emergency_disable_virtualization ->
>> svm_emergency_disable().
>>
>> SNP_DECOMMISSION unbinds the ASID from SNP context and marks the ASID
>> as unusable and then transitions the SNP guest context page to a
>> firmware page and SNP_SHUTDOWN_EX transitions all pages associated
>> with the IOMMU to reclaim state which the hypervisor then transitions
>> to hypervisor state, all these page state changes are in the RMP
>> table, so there is no loss of guest data as such and the complete
>> host memory is captured with the crashkernel boot. There are no
>> processes which are being killed and host/guest memory is not
>> being altered or modified in any way.
>>
>> This fixes and enables crashkernel/kdump on SNP host.
> ...
>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 714c517dd4b7..30f286a3afb0 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/psp-sev.h>
>>  #include <linux/pagemap.h>
>>  #include <linux/swap.h>
>> +#include <linux/delay.h>
>>  #include <linux/misc_cgroup.h>
>>  #include <linux/processor.h>
>>  #include <linux/trace_events.h>
>> @@ -89,6 +90,8 @@ static unsigned int nr_asids;
>>  static unsigned long *sev_asid_bitmap;
>>  static unsigned long *sev_reclaim_asid_bitmap;
>>  
>> +static DEFINE_SPINLOCK(snp_decommission_lock);
>> +static void **snp_asid_to_gctx_pages_map;
>>  static int snp_decommission_context(struct kvm *kvm);
>>  
>>  struct enc_region {
>> @@ -2248,6 +2251,9 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>  		goto e_free_context;
>>  	}
>>  
>> +	if (snp_asid_to_gctx_pages_map)
>> +		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = sev->snp_context;
>> +
>>  	return 0;
>>  
>>  e_free_context:
>> @@ -2884,9 +2890,126 @@ static int snp_decommission_context(struct kvm *kvm)
>>  	snp_free_firmware_page(sev->snp_context);
>>  	sev->snp_context = NULL;
>>  
>> +	if (snp_asid_to_gctx_pages_map)
>> +		snp_asid_to_gctx_pages_map[sev_get_asid(kvm)] = NULL;
>> +
>>  	return 0;
>>  }
>>  
>> +static void __snp_decommission_all(void)
>> +{
>> +	struct sev_data_snp_addr data = {};
>> +	int ret, asid;
>> +
>> +	if (!snp_asid_to_gctx_pages_map)
>> +		return;
>> +
>> +	for (asid = 1; asid < min_sev_asid; asid++) {
>> +		if (snp_asid_to_gctx_pages_map[asid]) {
>> +			data.address = __sme_pa(snp_asid_to_gctx_pages_map[asid]);
> NULL pointer deref if this races with snp_decommission_context() from task
> context.

Yes this race needs to be handled.

I am looking at if i can do SNP_DECOMMISSION on all (SNP) ASIDs, and continue with the loop if SNP_DECOMMISSION fails with INVALID_GUEST error as the guest has already been decommissioned via snp_decommission_context().

>> +			ret = sev_do_cmd(SEV_CMD_SNP_DECOMMISSION, &data, NULL);
>> +			if (!ret) {
> And what happens if SEV_CMD_SNP_DECOMMISSION fails?

As mentioned above, will add additional handling for cases where INVALID_GUEST kind of errors are returned.

But, if errors like UPDATE_FAILED are returned, this will eventually cause SNP_SHUTDOWN failure and then lead to crashkernel boot failure as discussed above.

>
>> +				snp_free_firmware_page(snp_asid_to_gctx_pages_map[asid]);
>> +				snp_asid_to_gctx_pages_map[asid] = NULL;
>> +			}
>> +		}
>> +	}
>> +}
>> +
>> +/*
>> + * NOTE: called in NMI context from svm_emergency_disable().
>> + */
>> +void sev_emergency_disable(void)
>> +{
>> +	static atomic_t waiting_for_cpus_synchronized;
>> +	static bool synchronize_cpus_initiated;
>> +	static bool snp_decommission_handled;
>> +	static atomic_t cpus_synchronized;
>> +
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> +		return;
>> +
>> +	/*
>> +	 * SNP_SHUTDOWN_EX fails when SNP VMs are active as the firmware checks
> Define "active".
>
>> +	 * every encryption-capable ASID to verify that it is not in use by a
>> +	 * guest and a DF_FLUSH is not required. If a DF_FLUSH is required,
>> +	 * the firmware returns DFFLUSH_REQUIRED. To address this, SNP_DECOMMISSION
>> +	 * is required to shutdown all active SNP VMs, but SNP_DECOMMISSION tags all
>> +	 * CPUs that guest was activated on to do a WBINVD. When panic notifier
>> +	 * is invoked all other CPUs have already been shutdown, so it is not
>> +	 * possible to do a wbinvd_on_all_cpus() after SNP_DECOMMISSION has been
>> +	 * executed. This eventually causes SNP_SHUTDOWN_EX to fail after
>> +	 * SNP_DECOMMISSION. To fix this, do SNP_DECOMMISSION and subsequent WBINVD
>> +	 * on all CPUs during NMI shutdown of CPUs as part of disabling
>> +	 * virtualization on all CPUs via cpu_emergency_disable_virtualization().
>> +	 */
>> +
>> +	spin_lock(&snp_decommission_lock);
>> +
>> +	/*
>> +	 * exit early for call from native_machine_crash_shutdown()
>> +	 * as SNP_DECOMMISSION has already been done as part of
>> +	 * NMI shutdown of the CPUs.
>> +	 */
>> +	if (snp_decommission_handled) {
>> +		spin_unlock(&snp_decommission_lock);
>> +		return;
>> +	}
>> +
>> +	/*
>> +	 * Synchronize all CPUs handling NMI before issuing
>> +	 * SNP_DECOMMISSION.
>> +	 */
>> +	if (!synchronize_cpus_initiated) {
>> +		/*
>> +		 * one CPU handling panic, the other CPU is initiator for
>> +		 * CPU synchronization.
>> +		 */
>> +		atomic_set(&waiting_for_cpus_synchronized, num_online_cpus() - 2);
> And what happens when num_online_cpus() == 1?
Yes, will add fix for that.
>> +		synchronize_cpus_initiated = true;
>> +		/*
>> +		 * Ensure CPU synchronization parameters are setup before dropping
>> +		 * the lock to let other CPUs continue to reach synchronization.
>> +		 */
>> +		wmb();
>> +
>> +		spin_unlock(&snp_decommission_lock);
>> +
>> +		/*
>> +		 * This will not cause system to hang forever as the CPU
>> +		 * handling panic waits for maximum one second for
>> +		 * other CPUs to stop in nmi_shootdown_cpus().
>> +		 */
>> +		while (atomic_read(&waiting_for_cpus_synchronized) > 0)
>> +		       mdelay(1);
>> +
>> +		/* Reacquire the lock once CPUs are synchronized */
>> +		spin_lock(&snp_decommission_lock);
>> +
>> +		atomic_set(&cpus_synchronized, 1);
>> +	} else {
>> +		atomic_dec(&waiting_for_cpus_synchronized);
>> +		/*
>> +		 * drop the lock to let other CPUs contiune to reach
>> +		 * synchronization.
>> +		 */
>> +		spin_unlock(&snp_decommission_lock);
>> +
>> +		while (atomic_read(&cpus_synchronized) == 0)
>> +		       mdelay(1);
>> +
>> +		/* Try to re-acquire lock after CPUs are synchronized */
>> +		spin_lock(&snp_decommission_lock);
>> +	}
> Yeah, no.  This is horrific.  If the panic path doesn't provide the necessary
> infrastructure to ensure the necessary ordering between the initiating CPU and
> responding CPUs, then rework the panic path.

The issue here is that panic path will ensure that all (other) CPUs have been shutdown via NMI by checking that they have executed the NMI shutdown callback.

But the above synchronization is specifically required for SNP case, as we don't want to execute the SNP_DECOMMISSION command (to destroy SNP guest context) while one or more CPUs are still in the NMI VMEXIT path and still in the process of saving the vCPU state (and still modifying SNP guest context?) during this VMEXIT path. Therefore, we ensure that all the CPUs have saved the vCPU state and entered NMI context before issuing SNP_DECOMMISSION. The point is that this is a specific SNP requirement (and that's why this specific handling in sev_emergency_disable()) and i don't know how we will be able to enforce it in the generic panic path ?

Thanks, Ashish


