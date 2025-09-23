Return-Path: <kvm+bounces-58556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A385BB968F8
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 17:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 584CF173882
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 15:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0782525949A;
	Tue, 23 Sep 2025 15:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="35fXjxXN"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012028.outbound.protection.outlook.com [40.107.200.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828E918E20;
	Tue, 23 Sep 2025 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758641162; cv=fail; b=kGh2UUz9OeiHFrYEA04OZcvS9QYDw0nt8QL4C6tSqs3T86CwVM4ltRh2irLOazyCLsi9adI6XqVRVn8fcHW5/zxNVIggSsHF7T2iujuNLZ0sHdQYS5AfFszyWj16F1jVGVAK85izOzGaSpm12r17yP/ET1o9PUFppqDuR/C/TkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758641162; c=relaxed/simple;
	bh=aWgS9tRxYPCFzoaH2vCVqzvoDnT/Mr4K+Ugvq/pEAZ0=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=TNmquRU5WB8vfl9UPTsOFU1nPPiLZvTdEvACsbFJu1WKMpHiaYHIxqzg6lWVH9kpsnWyqfg8weJdckSk7XkJCV672G/q6tIIirSoMPxah+N5nu4TaMJ/5dwPHEwK0rVrd6cO6iN50Let588dPzdmyJYDzCfRMgTp9Tj8hP57vHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=35fXjxXN; arc=fail smtp.client-ip=40.107.200.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DrqMEt98D+zlstwknnDUKVxe2q6WekK2trI1bhjNgJbIaE+ugaMvoeZlXmQc3hVGG3wxqgNVDs/m/li7Ckpk58UHw/A0rAMfEasFtIaNBphDr8sK9JhiG8Skbgmnsdt3q+IdWCjTzqWD/lzSQTRLXeT87CkwAbshPc0dT3M+5gHzlOPVKUcfMkoChFvzxPhSZJ5sNivlZcTNHIKkON8S9O/S66wbNm53VPGMw0qVJhFp+62nLVP9ySG5KheyVmxAaWiboT8ofecQ1bNR6R7klqldBUgCucE16vpe7OUjG+tZ15ss7KlWXUPUKXOVN139pFmDWCUXaebLylG8tNno6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQ1OkAuQKwUgjShik9SPGMyalWPgFbVVQgclaaKfWGQ=;
 b=jmWN9u82W/Cfx3NX2yqWsewdb6sLluFhzCIz0wMSKfFFZNl+bujJZRiEJ+FTrvF1hsFgzHRTEpA/LDgGcV3aHEUQ01BDr7duExBRIRmwOlg+4plRKJEvseEzccoBMUFf+VJ/fdROVd82NDcjdhp4YX7XfSZlJphM0Z0HmyONfdN920D88ZpDEiIlROxfQk1NtjuJrV2eIYyPg80YSWOjBSEX1ENltdVNA5neiT1T3f1ltw5VUlV/OvKEMBB8ERfHsjLgWEJzB4XTBEt4ZfwJw+lp+D90/4kgNgn2FlHkPzlVTW3IkZkkm0WN+4iWgcBUl0IEqvBk4Xyes1i42FhNyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQ1OkAuQKwUgjShik9SPGMyalWPgFbVVQgclaaKfWGQ=;
 b=35fXjxXNaWDAURzVoh4hI0rXTi10l6Ny1cyAwIxbTQklmHwZm2niOjBps6d9BU+0yBgx7TyjhpgYC0M2AhX85hoASJglf8siubLJ35f9+EXSdd0Pl9/T+b47Xd0UsXB7q8jXh9taWseHzmYqQOO9k/GurabAOwUy1Z0q/3o8LGk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB8195.namprd12.prod.outlook.com (2603:10b6:930:77::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 15:25:56 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 15:25:56 +0000
Message-ID: <37ce869b-b74a-5000-60b5-643a60443750@amd.com>
Date: Tue, 23 Sep 2025 10:25:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-12-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [RFC PATCH v2 11/17] KVM: SVM: Enable NMI support for Secure AVIC
 guests
In-Reply-To: <20250923050317.205482-12-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0168.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB8195:EE_
X-MS-Office365-Filtering-Correlation-Id: ea706904-5521-49cb-1fbb-08ddfab57d7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Yk01Vk95SXRxajVOYlh0Q0FKVGs2V09vN2xSS0ZzSEFGS2JXbEh5VFh0NTd5?=
 =?utf-8?B?RUp2Y21mZTAxd2ZvU3NVOHpFTklLSGxUaUVwdC8vQlZDOE40UmdsVzZZakh6?=
 =?utf-8?B?MHE4N3ZWWU5mVy9TM04zditvdVk2Sml0Z0dJVmtTdVcvN0VmZTJMeTB6ZHN0?=
 =?utf-8?B?SGpuZ1RDOWhiYWdheG1xSkd5ZmpoQ09tcTZyY0JHNlUvdEtDdXpOZ1haZC9P?=
 =?utf-8?B?YjF3Syt2QjZmWFI5S05OTUNBc1M5bExDQ1lwSXQwZWJkd3ZxV05SVHRVak90?=
 =?utf-8?B?VkdkME1ZMUtrWjFOTnhiODhKbnpETVJkaW5qMURYSmN6LzZvUmJ1elFsZTdk?=
 =?utf-8?B?RVk2K2lEdlhYbnJBK01WYUlJMFdITGhFSUgzUWdXeDB1UnFVK2ZmNjJVdFNo?=
 =?utf-8?B?K1ZSTldlK2pyS3o4VXJsUGhvMElBd255bFVMbkdtT1lLd1ZhN2ZsNmQ5U2pz?=
 =?utf-8?B?K3V5RE9pdkJKOTlobWplOWlpa3FSSTJiMFJCV0JRWURLdFc5ODBYaTgyR2ds?=
 =?utf-8?B?ZXIwZysvUk1ZUXliMTVQK29sYUV0NWM0Z3c1Q3p3T2FaQVF1dkkza2FzZ25N?=
 =?utf-8?B?U1RiRFdvSm52a21GVmFVNXlZWmdDY2pEU3lWSHVqRkxVQnRhcjUvRFI2YmZz?=
 =?utf-8?B?KzdSTnBuNG8vZnFDaTByZUpmMEpBQitMZmc4aXMwc0IrQWtHYXUxUVpHQ3lM?=
 =?utf-8?B?UjNiTm8vTXRFTlFuQ1B1dHh1RnByaTdhR0tKS0pDaHMyempIZElUR1cwNEM1?=
 =?utf-8?B?cVFFSTFDUUg5U1lZZURnTmwzSk9DbGJyYyt6TkQybGNaZGVpbTc1UXZjdjlQ?=
 =?utf-8?B?NzNKR2dGRlNYQW9Td2piZXEvNzdpS0JaRk1vWERKN3ZQZ0p6Zjl6OGwxY0R2?=
 =?utf-8?B?OGt5OXFsS3lHMlBBMGhCQWNjNXp3M2xLY3NsVWFnbTdzaDNWdUx4STRZOWM3?=
 =?utf-8?B?TldqNG5OTXVQMXJRZU9XZU1GdXVCWU1MUHZsdFBTM091c0c4QkNFdkZqdWU1?=
 =?utf-8?B?OTFDcnJXSUNsSEloQjhNa1Y1V2FDRU13NlE4TW9tcXlyZ0hnd1VzQ1htK2Mv?=
 =?utf-8?B?OTJXQzZPRDUxdkdBQjdYblFNS0UreHF0b2FvWlVJay9MRk1MNnJmZEw5RUM5?=
 =?utf-8?B?QU9EdTl3QTVwbW56RzkwQVR0dE0wcHAyUkN1QTR3MWVvTDRxRzhTT2JIbTFj?=
 =?utf-8?B?U3RET2hqcjlXVXdnemh2aXBuT0lCc0xBTURuME5XWTFMcEU4SWNmN1kyQmZu?=
 =?utf-8?B?NW1hQUFCUUJGeGYzWk1SWkJMcllDOENIMzZTOS90RkZPWHNaN2Y3eG1KSVhH?=
 =?utf-8?B?SHFGT2lJdVBvWEV4QnJPVTZmdE5RM0tkcUQ1Umd2Ym1adjFZNXRNTWcwMWtk?=
 =?utf-8?B?T05GanpEdDhGUldWOCtrWWdkaFlvY1U0eG93UG4yZ2hiUjRuamRRWGxtY1ZT?=
 =?utf-8?B?SXFjMXljK0ZFYUpRcGk3WWlkeHlJUEJ0UmFPRnVwQXVVczVwZ3NOUzVJajQ3?=
 =?utf-8?B?YjBaS1dQelFYbTRjSGxRRGxmOUVLQ1RSSTh6S0llMGNkK29BWWQ3ZWtydjUr?=
 =?utf-8?B?UDBWWjBVdlNpYzBleWVYeTNuOFFlK3p5QlYxT1NwZXJzMzNCVkhGWkpMOXh4?=
 =?utf-8?B?aE1DcFhSM25YRUFQRXh6eUdaRlQ0OEtDeGJ4V3B0eU16d1FIdnc2b1oyK1RG?=
 =?utf-8?B?Umc5WnRteGVRbFp3TER5WFBCL1JrYnhUWHVTVXVBdkFkaUVJSEtTS21nZEFJ?=
 =?utf-8?B?ZEpCdGpaWkdXeXVBaGhnYnlTb3pSODFDSWRlNzlBTGNuOVVSRVhqa3ErOENm?=
 =?utf-8?B?WnlGZzZOZTc1RWRsNTZtMzdsL1g0dHNCTUM4UmlibHlheXQ3cGhBWXdhNEt5?=
 =?utf-8?B?aHdLY0pRRzNadzZQSTVyTVQrTXptWHpSS2VITGZvOFMvOHh6L3JMY2MzMWFG?=
 =?utf-8?Q?j186nk2CAAg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXhyczQxMVBEQVZ3ZFlyS010N2J3dnZycjhvVTlLRWkzRHRRQkt4MGRNaUNB?=
 =?utf-8?B?MnVHOWg5a2g3RzU3ZWZqbFVZZzdQWFk0VU8zQkFIM2hqTjN5YTl0alZqSll1?=
 =?utf-8?B?TWdmaVBhd2RtVkFPdmlHUExxUWMzVXNkcytKdktWTjZlSXoxbXorNEE4T0lB?=
 =?utf-8?B?cW5ibzdKQlpHQ1d1djhYcTRqTjBGclZYRysrUVREclk1bEptblBaa1A1WFZO?=
 =?utf-8?B?TE5vbmJDYVo5MmtvYnNpTFYxRzNTRU1FY1NvcTFXZWk1SElqT2Q5WFY1TklN?=
 =?utf-8?B?Y0xxdnRuMko0dnBWaEg3YWRYeGZsRzByMkEvRW9mQUozZGVXL0hNVmNSS3VT?=
 =?utf-8?B?ZHNvaXVzUFQ1SEl0Mm5sVll5TDlMSE9BOHBhVHcyaUQzek1lUEVWNEhoUVpz?=
 =?utf-8?B?cEl4bUFRQUs2eTBsMzExNzhLaUw0SXo1Q2RscC9iY2xXaFg3bWZRRm16Mytv?=
 =?utf-8?B?KytKYm45a3pDcksyK1kzQjlRL25VcjJHcjdTdDJwYXV0cDlxR3d4UzJDNkZ1?=
 =?utf-8?B?a1ZwV2NWMzF0L0hiQlFjNUlzUW84amduS1l1bmx2UFRkSXFyUmQ0ZTlNWVla?=
 =?utf-8?B?NXJHM0hrNm9lekRTcllSeFk0YzBUcERPbnFseVcrVFkrczdOTDFhWDhFN0Jo?=
 =?utf-8?B?TjJjamlXUDBRMkRlR1FJblNNNjVwRFNWSStuWEJjM1YrL0UvR2J6bmErOHpm?=
 =?utf-8?B?cWp0L2dhL05aTzZBNHZsaEc2RnZuQWh1QU1hSExRTHRGdjdzUXdhQWw1N1FE?=
 =?utf-8?B?Zm5aMjdYeDlUdjQ1TUt4WWlBRW9SU1d0SitGcUxqOCs3cnROcXllSTNRUWFx?=
 =?utf-8?B?VEF2b0hyTXppdC93NThVUlY1RC9xSzlOM2xtd0ozQTZZendBbHJmTmtSTnJJ?=
 =?utf-8?B?YTgyZUo4T3Q1WFNid2pNeThFYTAydVErYlNVWDVYa2JmSEtpRkZuSC9LZm91?=
 =?utf-8?B?aFdqODZhZzFFOHBTdWVORU9oUU8vYWpRUXVTajYzbnhHZDVzS0EzNWtndW1B?=
 =?utf-8?B?VmpvT2Nwbm1nY3JwaW40SmdNODBFRDNQeUU4QnlMZ2FLbGF6SnY2TUtGNERx?=
 =?utf-8?B?VW1hNkdBeDMxTkI2a2JVZ2hZZjdlaktBbmRia0s0MEg0Z0dCTFg4ckFnaVdx?=
 =?utf-8?B?WEtSL1RJWlBzOFp2RXZrQkt6VlJjdDcxWWVHRDgwTGtqSjkrMWw0QVMrSE9O?=
 =?utf-8?B?eUNORm1FbEhtcERWZG1DNGQxNERNYlpWZVEzSjJ6Z0NSeVNqcjUvOFQ3TzUv?=
 =?utf-8?B?WlpBWEtkQzJWU1NOY0JpRkZJVkVhek96U2pVRU5uak5hNlpvd1FYTzNFKzgv?=
 =?utf-8?B?MHNqbzV1NmsrcDFnM1JoSnFGRDc1RFFESUdMSXV5c2pWeTdYcHcvNGwrZnZa?=
 =?utf-8?B?R1FEL1FQL0xLZWFJN2Z4a0ZlbjNxc2U1ZVFJY29ucGRYRVFOVFA4cjdXMUNS?=
 =?utf-8?B?RG9TTm5BSUc4cDdKWXFXWDE4ZDZOWjBUUy9oUktYekNmZlMyYTlkazYzVEI5?=
 =?utf-8?B?cDN1aXFUVllwWWZjQkVKZktCakpTeDlrQ3NyZ0hoRHRjNjVXTGpPSVp3eGJw?=
 =?utf-8?B?Ni9ITE56Z1QyeHQ5Z1V0V3pwQU5oOWk0QmRIdUtyOW8xcVZFUmw3c2xDOGk0?=
 =?utf-8?B?eWx3RjIyMUVzUEpjelNhV0MwN3lDc1JXYW1rYmFqeFhiOXZyWnZjUDgxRVhS?=
 =?utf-8?B?clRqcnJtS3N0NGxhTU9HZ2RJUVJCS1ZIL1FKZCttVW9BUVRMOG9Da2ZTOHVj?=
 =?utf-8?B?bHNkQXUzNENJNWNuaUJnZUpsUisvYldXNG9wOWZnUXJtL2c0aHhnZmxZcG5t?=
 =?utf-8?B?RHlqamNPNzNjM2lxZTJjU21ZZHZvV3lBL1MvakFJUWQ1VWU1NWZ5NVM1Q01m?=
 =?utf-8?B?TFJDWTdQMlppdlltbkdYNStiYnhTWUUrMkRWVnpuOVBrS2dISmxsUzVSWDhB?=
 =?utf-8?B?MjUwZk1jMENtY1ljc0hJUEZoN2gzL2lTL2J5S00yTWNHb3RQakhMcWk4U3V5?=
 =?utf-8?B?b0RlUmZuaStFWktIYVBnOGkyRlRCK25VL3dxekpyejFXVXQ0TE1lWHBSU3Rn?=
 =?utf-8?B?ZzlKNFY0cExVUUhUakNzdHZWWFRTTWZjRUN5MFgzcHFPalpnU1pmcUl4ZEdD?=
 =?utf-8?Q?E0VpXyWnmVZWnweb1Sd04fQxK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea706904-5521-49cb-1fbb-08ddfab57d7e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 15:25:55.9375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xh/mRVCwYiYaDnDlf9FOG8X30jd05DgE5t4F94G4WfaPVmJ633k3mU7nUF8RcT3EX9cckGz0fiDXUOl5Sk8CGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8195

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> The Secure AVIC hardware introduces a new model for handling Non-Maskable
> Interrupts (NMIs). This model differs significantly from standard SVM, as
> guest NMI state is managed by the hardware and is not visible to KVM.
> 
> Consequently, KVM can no longer use the generic EVENT_INJ mechanism and
> must not track NMI masking state in software. Instead, it must adopt the
> vNMI (Virtual NMI) flow, which is the only mechanism supported by
> Secure AVIC.
> 
> Enable NMI support by making three key changes:
> 
> 1.  Enable NMI in VMSA: Set the V_NMI_ENABLE_MASK bit in the VMSA's
>     vintr_ctr field. This is a hardware prerequisite to enable the
>     vNMI feature for the guest.
> 
> 2.  Use vNMI for Injection: Modify svm_inject_nmi() to use the vNMI
>     flow for Secure AVIC guests. When an NMI is requested, set the
>     V_NMI_PENDING_MASK in the VMCB instead of using EVENT_INJ.
> 
> 3.  Update NMI Windowing: Modify svm_nmi_allowed() to reflect that
>     hardware now manages NMI blocking. KVM's only responsibility is to
>     avoid queuing a new vNMI if one is already pending. The check is
>     now simplified to whether V_NMI_PENDING_MASK is already set.
> 
> Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c |  2 +-
>  arch/x86/kvm/svm/svm.c | 56 ++++++++++++++++++++++++++----------------
>  2 files changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 2dee210efb37..7c66aefe428a 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -885,7 +885,7 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
>  	save->sev_features = sev->vmsa_features;
>  
>  	if (sev_savic_active(vcpu->kvm))
> -		save->vintr_ctrl |= V_GIF_MASK;
> +		save->vintr_ctrl |= V_GIF_MASK | V_NMI_ENABLE_MASK;
>  
>  	/*
>  	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index fdd612c975ae..a945bc094c1a 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3635,27 +3635,6 @@ static int pre_svm_run(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> -static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> -{
> -	struct vcpu_svm *svm = to_svm(vcpu);
> -
> -	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
> -
> -	if (svm->nmi_l1_to_l2)
> -		return;
> -
> -	/*
> -	 * No need to manually track NMI masking when vNMI is enabled, hardware
> -	 * automatically sets V_NMI_BLOCKING_MASK as appropriate, including the
> -	 * case where software directly injects an NMI.
> -	 */
> -	if (!is_vnmi_enabled(svm)) {
> -		svm->nmi_masked = true;
> -		svm_set_iret_intercept(svm);
> -	}
> -	++vcpu->stat.nmi_injections;
> -}

A pre-patch that moves this function would make the changes you make to
it in this patch more obvious.

Thanks,
Tom

> -
>  static bool svm_is_vnmi_pending(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3689,6 +3668,33 @@ static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	if (sev_savic_active(vcpu->kvm)) {
> +		svm_set_vnmi_pending(vcpu);
> +		++vcpu->stat.nmi_injections;
> +		return;
> +	}
> +
> +	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
> +
> +	if (svm->nmi_l1_to_l2)
> +		return;
> +
> +	/*
> +	 * No need to manually track NMI masking when vNMI is enabled, hardware
> +	 * automatically sets V_NMI_BLOCKING_MASK as appropriate, including the
> +	 * case where software directly injects an NMI.
> +	 */
> +	if (!is_vnmi_enabled(svm)) {
> +		svm->nmi_masked = true;
> +		svm_set_iret_intercept(svm);
> +	}
> +	++vcpu->stat.nmi_injections;
> +}
> +
>  static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3836,6 +3842,14 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
>  static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
> +
> +	/* Secure AVIC only support V_NMI based NMI injection. */
> +	if (sev_savic_active(vcpu->kvm)) {
> +		if (svm->vmcb->control.int_ctl & V_NMI_PENDING_MASK)
> +			return 0;
> +		return 1;
> +	}
> +
>  	if (svm->nested.nested_run_pending)
>  		return -EBUSY;
>  

