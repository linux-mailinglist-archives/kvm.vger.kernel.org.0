Return-Path: <kvm+bounces-32931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BBB49E2006
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 15:53:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09C12287025
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 14:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9A41F7562;
	Tue,  3 Dec 2024 14:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0Y2Oqx3T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3301F6679;
	Tue,  3 Dec 2024 14:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237569; cv=fail; b=pAwBraGAhaR3odLcT7qb4V07muC2U69YJvQ8uQFKI983sNy/GGEbScBsqwIx0Y6Txp0ua4chRzgXiD4GG9wut0Wth6rO7t+biuZIEShsePcQwMQzpj6RKD6T42C2TfTS0r7j/KqJl5lQR9fNPjbCGrMhdAtJBuMDGJwDZYICt1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237569; c=relaxed/simple;
	bh=7UuXBnZG7O4oi8vpnMscxMXPckVX5N+PGG/Q6ctOQMY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g6Lrs+wkKtGVjrlGKeqDDmJVpRqNkRmdjdoLm5OteAKZuw9JHav7ezbOgV4m4VSVwWFh7sF96wys/AekKQTWWcVlmiq1VeXS9NF7DY75pgV0qu4wTeqYYwqIDGHoniF2WcKCblwgU7+R85rEBj30H0MVcGLocOJ/1LS4gQuaCcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0Y2Oqx3T; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xRuYKno1v/E7lkmU2Ec1fu5ybyRa8XcMwtznSgk44krna/IJW6d5wp4WbzCnJDSq9ayJ0tShlpsuxL4FQHluD9g7lTpc6Uc/anXHtUHkCSPtYLda98JUihB+7sPqPJ/WcY/JkH7q7MufvpFobGyiYpoQoEenClBllov0Cu0OmRymMWP5yAEG2Mu2xxMjeoK6cOEp6DiH63jr4QZ/JpO009Gm1Z4RIOigc2q55qiNXGMXMUvgnZyoX0WOFr25IoBFIqy3wOzdDiriSVPkw+W6zoJRO4ciS0mzOR5lR9gDOQFii17J0egMBjQU0FOxPGVuNubY6V7qOq1ERURogZwvfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+p6JBzjjUkAFbqPvkNF7rW9QLu72kgdWjTBFG+wDcVY=;
 b=rKrr6CM3goq43WqSCjhCaaicskckCNHRqiRdkmE0xZxy8+TVZ+QcwE0jkminV9IEOiPgO7o8HKrGBpyGJjWeuRSRknQ0dk3/Q0ZL9ZvzM2AoxmPALR3RzNJ3mLOURfItZkiwHLAtIeRAsDh1jpXnIOAeF2R0zlrNf2Q6xq2ImUC/vddSFwewFYONxWVBnBrbR7slNhwZ/sit2KLq/MzeFvjMRGfnwVoPClbfiYVHAtHIKX/CwzBf0unQiNHlwBna3+Wm6+N6KYdHx4SskoVOveXxH9Q+hF5s1dCaYHBk8fpx5fSMWEgIkZbgn7f3aRVgY0j0cfhJKxa6gg1XHJ26Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+p6JBzjjUkAFbqPvkNF7rW9QLu72kgdWjTBFG+wDcVY=;
 b=0Y2Oqx3TJnATNFEL5AXHXehnhi1y2mV8bft7tMj+6LS6Cj1gQ8/0kB6G72txr4oyZFaY7fbsvK7IPp5OEbO1fxtVwbVT7BBvPlKd36/32uMb0sVPE13JVpdu2TFIzX3C9YIjTi6DeCSiixOdZ5yYAfhPMWGrPFFd07AEkS6UZik=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS7PR12MB5743.namprd12.prod.outlook.com (2603:10b6:8:72::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.17; Tue, 3 Dec 2024 14:52:43 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 14:52:43 +0000
Message-ID: <06ab9c99-614d-4d6c-8f08-2f4f257a9f2a@amd.com>
Date: Tue, 3 Dec 2024 20:22:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
 <891f0e65-f2fa-4e0c-a59c-ef97ea00ba3f@amd.com>
 <20241203145006.GGZ08anlXCntr8cjVu@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241203145006.GGZ08anlXCntr8cjVu@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0040.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::9) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS7PR12MB5743:EE_
X-MS-Office365-Filtering-Correlation-Id: c7db237f-5e22-4533-4959-08dd13aa245b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dmhwTXJRdGdoTldiWUt3eHBHK2Q3a2lvdUVSb0JJTk80b0FVUEVNOXdFL2c3?=
 =?utf-8?B?OWs2YUJCOFhsK01IWlQweDJpV3loSEFWeUdVVjV2blRUQmw0eTlwMTNJNU1B?=
 =?utf-8?B?TXN3S05PdEVKYnVYOEs1WmFXdk5wZW5Xc1k5VVlHbThhaDhpUTZLOEdsMk1a?=
 =?utf-8?B?dzhIWGdRd0NmT1FYSEErTzlXWEk3LzRPdVJGb0ZLWkQvb3BKSnFNK2MzL2hk?=
 =?utf-8?B?VlEwWGFSdW54WVZyTWlvcUY4ZXNoblNPaWhsTEl4WGdjRGJ2U1FiN3NFQzJ3?=
 =?utf-8?B?SVV4bHlFZDVtdlFjdGxES0gyN29hUXF3djY4ckR3Y1VMOHVpbHFTcEJDT2RJ?=
 =?utf-8?B?Q2FybVhtdEZZZTZOQ1ZvRnQxMmVpckVZcTlDb0ZmYm5aWHVHZ0NFUzhtbzkz?=
 =?utf-8?B?dU0xc2k0UWFIK0Y4M1ltV3NjMnVWajdVTGhXa1FYSjJWREwvZWhlWDBuVGYz?=
 =?utf-8?B?L0k2TUZYOVl6S3pFbFA1V1Y4Y1Q5VjZNMGxiVGRmbHZ1ZjZMNzkxN1dGSUdx?=
 =?utf-8?B?ZnlzK0ZQMU52Sm1mK0hCL1NPVjVUSU1CVm5yck1BamdTSDd3a0hmUkJCcWZR?=
 =?utf-8?B?cGNOa20xL1hzK2dMNW5yb2ZhdHprQUE5aWc0OXRzZXBpR2RwMHZYOWhISE9U?=
 =?utf-8?B?SithdFFwaUpKejJaenFBVllhSUF6Vi9aVCs3bkF0MHJhZzNjK3hjYTRUaUFK?=
 =?utf-8?B?WnFTK2JleGFlSzVGYTB6RnYzNjdiZzVYNWRUM3JJQU1rNGtMZmkrajlCMThs?=
 =?utf-8?B?dUVRL3hQdHIrelRQdzBTWFRqVEtKRExoM3RlY2NSMVY5ZElGbkxUTmc1TUdj?=
 =?utf-8?B?c3ZLWExlQkYrNkkxZEYrVFFoY2Z3ZmQxL2hoTXFXRmFqU1hHZDhKeHpqQmlS?=
 =?utf-8?B?SStxZ0FFemZKY1BxTWd5NTVJYVFta2NvSW5sLzVhQmY2UGs1RVpMc0ZLS3Yz?=
 =?utf-8?B?SEd2d3U2ang4SWhmMmVuRU9ZOUdRcXZJMURlRlBUaHZlNG1FcGhEcFJROUQ1?=
 =?utf-8?B?K1BmT2laQ0dZd0hYV2YzZUxVOE93eXNLcTBzTkxYTEwwdzZhQkdVQkxHeERy?=
 =?utf-8?B?N1Q3RGpremtSLzBnbUlZTk1BbHRuTWFZUFF6N3pLZXpJSGVISVNoamU0amRp?=
 =?utf-8?B?bGNtRUVPa1VibjZXN1M3RVRhQTZNeVJ0VW1uYUJXb0d3Rjc0YVdJM2dJYjdt?=
 =?utf-8?B?LzBXdlMyc0NoNTBnbHQvMlZHSlZ4WWI0Wk1PRFhPemZndXo2T3pLbW5KQndi?=
 =?utf-8?B?VWpXaklLYjcvdWdMYWw4M0laMExmN1RYRWNBR04wRkFCTkx1SCtaNmpndGE4?=
 =?utf-8?B?OFJFRENHN2F6ZTFpTGNmbXZBWWdLQWxqVnVMQXhrV1AzM2dma1FPRlo5V21O?=
 =?utf-8?B?L3dpa0padENYM01NbXluMDAvZWordm8xT1RjWHg3bUM0RkJyeXlyY09CUWhu?=
 =?utf-8?B?b0NtR3hVWko2L0FOTFFMZnBmaGMyVUU1RFZNVFF3WDZLTU93L296bEZ4cGNq?=
 =?utf-8?B?NlV6Z2N6UElJYjJSK2hlejVwbm1Zcy9XNjNzNkRrOC9zTnQ3MHljay9qZ2lG?=
 =?utf-8?B?T1ozczNIZHJqTVdaTm4vYUVtbmEyUVRxMVhleTNxdEZEbWR6Nko2QTIvNzBn?=
 =?utf-8?B?dFFYQUU0a0t6aVZIYTRtTGVQc1FMYVdSOCttZXd3aU1PODdtMTFrZ0FETlNU?=
 =?utf-8?B?SFNOaHdhdzIrK2pWMktvUjJGMUZXRUJBZHRFR3A4cElCWC9qRFhJeVNqNEMy?=
 =?utf-8?B?V1VYazRUSmNSb2svc1FsOWJqcGxGNlBPTDhBbUNpL3EreXg2eEhRMEJ6YmJB?=
 =?utf-8?Q?lKi3T5BCAx/UsqTBZr39uzyrH/M99fbCMasY0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWNubVZHd2tVNzM2N01wZHFrMXBvWkRDT0FJby9PVDdkY3N2eFFtcVJ1VUtr?=
 =?utf-8?B?RVc5UnIyWSsrQWVLMlo5ZGhrc2dnUDQxSkx0ekJneUF4NWplakNaTlczazZs?=
 =?utf-8?B?QngySG53TGFBTm5ZbVU5WG5sMklSUkk3VzNpQjVhcHJhVWNpWWI3OG9UTFZZ?=
 =?utf-8?B?aGw3SHlhOTczc25YdlhjMXhiSWN4RGhHcmFaYWwrRVJqRnJ1SURMZUpieDVo?=
 =?utf-8?B?bklxZUJaRTlEL1lwbDBjWktna0U1bVVab2cyMzlJcTBRY3dQZi9xOW5Mdk9T?=
 =?utf-8?B?TmdYZnBzb3FTTGtpZW9Oc3hMWklQZ0RVNnlYRklNdWFJL1dxdkd1MTNIdnVO?=
 =?utf-8?B?czcyc3Q3K0tUYWxseGFFVGt5d1NXMkxCeHh0M1JLMEk2OVpmSWtBdkJvanpW?=
 =?utf-8?B?ZE9mV0NXSFdkd0VXaTFIUTY4Yzc4Y3I1alNPNXl2Z3JnVlJjclkzSWJ1WENT?=
 =?utf-8?B?VmM1TUhvS3BBK3Q5dFRLakVodFl4MWFkVFlvaFVYYTY3UElLMlYxaTlMbUpi?=
 =?utf-8?B?NVgwQWtGbWJZeUxOM05lUHZjeHhNVEt3RFpSRFd3UDVGcWpMZ0JVRjQ1OTRP?=
 =?utf-8?B?TzBsVW0yVUFRTnZDWWFEOXpUcmF4WTdzOTVOYjZISUJPWmNLR2F2OG52MUdS?=
 =?utf-8?B?MU9DNWRmYUdEM1lTOExNSGw2alhpUUR1Slk2bFBxaVVLcXRFQ3cxZ091aS8z?=
 =?utf-8?B?T1UwSEZsZTdiVlViQnM5UDZoRkNiREJ0U3BxTC93Uzl3UWV2TldhVWhTV2pX?=
 =?utf-8?B?YXo2T0FrNVdVU2FyeGFuME5iRHV5QjkrTThJZFRSZjFjbUpZMkZJSVJjMjFY?=
 =?utf-8?B?MHl2cndma1NPRWhpYU5CeVUxdlBGcnlBZWl2RXhCSFdPNGFRWU9wSndyZVZo?=
 =?utf-8?B?RktUYUJpWHhvSlZudVppUUVqVVlBU01sNHR4YzBGd2tvVzR6bSthSEV4WHhh?=
 =?utf-8?B?Y3YvcXoxdlJMV3F5T2hJbStOUURiamdESSt4R2dWYyt3a1J4Zk9LMG1yUFpw?=
 =?utf-8?B?RXFVaHV2Wk9pYngzZElRSmVlclI2YW1kSDk4enZTUldETnBoZnY0SW13K1Bw?=
 =?utf-8?B?dktsQXl2cC9Jc0hEL2dpdzJzOWpzeVIxbUFleEVUZCtkYlZ4QyszWWZtL2J6?=
 =?utf-8?B?TTlvN2pwWFI5eFZ4TGMzZ2lSVldUWjlPanJ5b05kQ3hPVmtzRmpwTlZBV1hF?=
 =?utf-8?B?TlB2QTdrUStFQU5veXR1ZS9KQkZ4UXB4Y1BqSkxxZkdnMDZoSndmRk1MTGR6?=
 =?utf-8?B?SzFIM1ZqMXVXMlR6RUtpUjltbmNYUWVlZ0tnVlZKcjc5L2FMMFpiQlVwaGlV?=
 =?utf-8?B?M0JneldJTE5aRGM3cFYwYkc2Vk1CbEllYVl0d09NRGdoc1ZsUWJoNkdDT3BU?=
 =?utf-8?B?Q29mOGlzdmFWRnVMY013dGNMdXlNTUdFSThiL2NSdUtSSFdyeE9zcFNiMGZB?=
 =?utf-8?B?UVh3bnVKVCthUjBVK3F1djRIdFBHRDhRd3JCWkExZVgwaFRTRDJOZHppcHFr?=
 =?utf-8?B?NXBuTUdJcUplbUg2Q1NrYXZOVVJpQldZNkI1dUJmcUsrcGY4M01nTVJMTmZB?=
 =?utf-8?B?TEo5c2x2cXRxR0pndGYyNk9BWkRBb0cvekFaMnJ2MFI1bmpiTExpRmNvQkV4?=
 =?utf-8?B?bkVzTjdHK3JxaG12dUdMbUlYT3N6ejZyc2JjeXk4UGNkOUw5NHowa1JOaFNS?=
 =?utf-8?B?SlZlN2NSUEtrZ2N5VlVFTjNheS95ekwwVmtKejNGTmFNYUgxbitBeUxmQ2N3?=
 =?utf-8?B?SWxMVHdjWjU5WEFsU0VNVUk1aHp0T0I5MnZGUXRwUys5SzlycW9yOGQ0MExT?=
 =?utf-8?B?UVJMWTJhQlYwUGpQUjMrRXNuU3hMdlFhd0dzUnJDbWM4eHJzNEFyVm1XTGZt?=
 =?utf-8?B?aSs4K3JqQUsvNVdKMTB1Z2dwYmVCRVFvbkIvVG56RWZ2dkFLZE5lUUdqZDBO?=
 =?utf-8?B?Qjd0VzRabE82Tmh0TVdpZDgrRkRxc244MWh4Zi9OYWVtUmpYbWFxUytoMEtT?=
 =?utf-8?B?K3JJbnR2aWZuUFN5c2cweG1vcFcvNWxVK1lkeFZPQjRWYms1V1hDUStOenIx?=
 =?utf-8?B?NVNGZ2cwckpHV3dxcDgxQ3AyR2ZGRnhPY1dzcUN6cTViVlNXZXdnKzZFSjhR?=
 =?utf-8?Q?4kCjhc6cLG5ydw7t3YE8Y7/5w?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7db237f-5e22-4533-4959-08dd13aa245b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 14:52:43.5446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EfT9G3PtEJeDgSn30pPPNvRHpOOtnW02fNiM4Vpse02F/UvnUChCA7Vec7DEDfLPjvLVQoXdOGobL017WyvhyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5743



On 12/3/2024 8:20 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 08:05:32PM +0530, Nikunj A. Dadhania wrote:
>> This is what I use with checkpatch, that didnt catch the wrong spelling.
> 
> Not surprised.
> 
>> Do you suggest using something else ?
> 
> You can enable spellchecking in your editor with which you write the commit
> messages. For example:
> 
> https://www.linux.com/training-tutorials/using-spell-checking-vim/
> 
> Or, you can use my tool:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=vp
> 
> You'd need to fish it out of the repo.

Sure will give it a try.

Regards
Nikunj


