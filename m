Return-Path: <kvm+bounces-50600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD5CAE7439
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 03:19:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD047189A016
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE8B14A4F9;
	Wed, 25 Jun 2025 01:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sVUoGiYo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072.outbound.protection.outlook.com [40.107.100.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1B57D07D;
	Wed, 25 Jun 2025 01:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750814375; cv=fail; b=HkPct9PiF77I6xgPmAIZq/Wz6vC9fxoSLpYV6xgbSKm5cvQG0k6WOphxvUZAZ91I56xxhODwPq10QYLwOE9Wc2CmS/tSIHK5sU3if+uvq0ebCCRfKghoii1aVhTGCky4q9xtj33atK8mr1U5YoDjO8PkLDETwDPr2ZupVtwmF9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750814375; c=relaxed/simple;
	bh=5+3PJfG9PkH8TuZ7eNeilnH+HmLOUhPFvntP74f8faE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l+DIj+KJSVwuRBW9WXZzZXt6MItWYAt0uR7H934+8ZX6l74Wu3+7/6h3t3XuqztZhmbAEL1EQPPtJ3Wu0b+3RCQF5uP+Aexa/vZiSNLvTVbw1gqlBdx9pauhbKu4emHxOU5X866At3Kupjqai/IyCCTZamD4beVg/0PKFrf4CH4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sVUoGiYo; arc=fail smtp.client-ip=40.107.100.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BDY22QzFJQ+FAry9sb8wbM3/H6cbgm7bknmBg84OXzRRSrhast5jiIcB9gy15DIFmUpR1BWbDGatB+YTkqqXYYSvjjfiZ9vIuabpbFjWm4Pa3i3++nd58nT4B0fwbTP13ZUPjklxEgaiP+YUGl4iwYJZELO9nN2Ilt7HxYc/hYJ5vZOXDGIpCjG0drH+i64lMJBG/faSEV5qxGxYtCskmpt6yu4IteZXQxiJ8uNJ905T/EirjKUdlwQrs6rlUlBbePpAd91zbP+HoW6FZArR1GewaVEz6qxRkY8QzGavKuvz3nCTaPMwJDdMR5lVJbywpqG4GKKDK5MfUD6Q7NgnSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LE1bVO0gtnz61WxZ6D1D/P4EtXtHapcsv4EBZpE/y5A=;
 b=x2/dHXOR69PbA3EMbjwIpaS8fNI6/PIm+VNY7VNmoKv/kvBkr2iZJeAmcbKDls185DxQnq5ki/LchKP1kASk28sYG5M4gAK4JHH7bC3XkIMriQJ8HOKayTEmgmJHrIgimBnfFpKy8lsRKvYpxTO5F0BYhk+EKBsHphE0Uyb7KwKbW4LBNiFnD4JqleCNfap3z0bHGCXZsF9+iCcbZo2cWvgo8bzeREimSa6RGIInADx+g/YIpP3fI44OPTcBL7wekI4ng3vMJ0e+fVVp6oT5bViCcui9h1YoamF+41dmoOsGfkK2EeJDYr8ew1iu0iZOZLkfw+TvKuJ3Y504iqxxLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LE1bVO0gtnz61WxZ6D1D/P4EtXtHapcsv4EBZpE/y5A=;
 b=sVUoGiYoD30g/Wz33eFLEczgWsoBiyK5r3IVhSpcJmcgHGAPrkcvI+PKOn2wTpgmWTbnBYF38w/d5S6UyJyzyoI5ONmHmTh/8LkbcUdJWRU88kJVjnMsv+aPCMXH47QvgI9jGHnnH/9iHVzKM6r1cBCteNuMXhfnua70ycn3A3E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 MW4PR12MB7287.namprd12.prod.outlook.com (2603:10b6:303:22c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.28; Wed, 25 Jun 2025 01:19:29 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8857.022; Wed, 25 Jun 2025
 01:19:29 +0000
Message-ID: <9002f4d0-53dd-4c10-b1a4-5b3cef086451@amd.com>
Date: Wed, 25 Jun 2025 06:49:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 02/37] KVM: lapic: Remove redundant parentheses
 around 'bitmap'
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com,
 francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-3-Neeraj.Upadhyay@amd.com>
 <20250623114133.GFaFk9bRYpNeuSjXWn@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20250623114133.GFaFk9bRYpNeuSjXWn@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0090.apcprd02.prod.outlook.com
 (2603:1096:4:90::30) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|MW4PR12MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: 936ee4e7-743b-4bd9-bf72-08ddb3865523
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3ROUy85MEhZQk43SnNFV25MOUw4SFlyY05xbTBsYkxaaEVSMHRKZEFuUEh3?=
 =?utf-8?B?UmlObWNnU0UxUE1JZ1BvVGFPQ1ZTcTRwVFJhbjBGbFNyRkRUOXFqYVVuSkF0?=
 =?utf-8?B?YkVwK0VkcmZ0UGhxbzVWQU10amtRZ3NIb3JxTFZNWmlCeUtTTHJ4SmtKVjJm?=
 =?utf-8?B?QlhzbVNrWkxDVm1mUitLZnd4RlpOYVdnSXUvRnI5R2xSVm80a1NPRXNFNFB2?=
 =?utf-8?B?dGt2TTFVemgwNW5jSHo2VmxNN05rS2xOeWxKSERzK1RpVTFWVXJsWWNEN0ZW?=
 =?utf-8?B?NFR3R3lOUCtUc2hKcTlaQlNudmcwK0JHNjhlT0w5VGNHMWk2dkdTMklpNU8z?=
 =?utf-8?B?YlhIcjJ4S2dkYUxDOVkxTkRORDhkZFVkZExaaUdsYzI0QjZ5dnowdHVDTzVo?=
 =?utf-8?B?VEp2WFdMcW1qTDd3MFBaV0NPUUptZk1rUHU5MDJ6eVkzRnpWY3R4Y1JkdkJH?=
 =?utf-8?B?VkRpOUdmZFdMcUJMc05nZExnWWQ0ZXVGazI4aDdGdFpFWGVqRmMxZ0VQQTNM?=
 =?utf-8?B?Wkg5K29KTUZQcVBBYUFuTDZ4UFplLzUvdXVwdXpPU0VJOThvcklXU2RsVVc5?=
 =?utf-8?B?UVVVNEQ3ODNhcWNQTGpTb0hIamJqUzZEeVo0NUtOeUNYRHNzZHdJTUpsNkhY?=
 =?utf-8?B?TzV0OHZtNEhlQVZXY29ZT1FHbml6RFdZZmtIL1JJWFcyTElQYTFodHV2aDA4?=
 =?utf-8?B?WVdZM0FscVlSdCtRcWFmQVMrMFBvcGpUbk5MQ3A0ODIyTlAwWXArTFdvZHpI?=
 =?utf-8?B?MS9ERE85WG94a2lnSmgwWVkxZFRJOExxTWMrYkxkOUFlR2dnZmtDbXkyOWZN?=
 =?utf-8?B?YVFoTHhiSUhYSGJlS3k1L1ZPNjNWQmNmVTBOeWlHTldQZ1RGUzlzVmtKeXJH?=
 =?utf-8?B?YmdENHlIVlowY29CZlIya3gwdngxN3kxNGU5UTRTZHpoNjJhK3ZiT2NMUTlJ?=
 =?utf-8?B?Q3NrNjlQOW1uYW5yMUtCMC80QzVEWnVRaXc2OTloM1NyU1R0ZmkvbE9kSUZZ?=
 =?utf-8?B?QkM1QWM2VUxZZS9JT0ZoN1pGRFY0bmhDUmRpZ0lsSFhybnVWTm9yQmpHUGdW?=
 =?utf-8?B?Tk1EU0VqQi92OW5ybjdlZVhvMDE5UHZ3RWFpVUdISUJyQ2N5VEJaSHZUZVhV?=
 =?utf-8?B?QnpSWW8rbmtRWWxDL3dsOVVjMEE5R1RUV3FSZkhZT3BlZDBnVXJ3R1A3V2Jj?=
 =?utf-8?B?T2YzQVVyOEt2cGM4dEdrN0Eyclp0MnZ0RGhXaFdnRXhRVmNtaUM4bEFPaHBU?=
 =?utf-8?B?bjgvRGFNSkZ4ZURIcEdyTWM0MUxYbjJzeHFzbldkRmJBalRsNXBaclg3V2Vk?=
 =?utf-8?B?MnlCNElDbHBtdjlrUG5jelZOMVBURXpRa252bXJnV3NTRTlJVk5aSVVua1Y2?=
 =?utf-8?B?MkE3MXN0L09UT2lyRTR4L0FFbE1NZWtkdDFXRnpPS3lPNHBPa29YTmIxMWVr?=
 =?utf-8?B?R2dPN05JemdjejJYYWNGSzg5U2J0aWYybklPNEZBaGRHNENLK1ZFbXRRQTEx?=
 =?utf-8?B?eGRSR0ljUmMwK29OaXQ4Vmk5eU92YUdmcUFiTzk0MWYxRlhiL25OYkVsUjY4?=
 =?utf-8?B?VWxrS1R1L1Fwa3ZTNHJYNGd2NTlMNzE3dWVtZC8xRDN5OVBXN1FEblNCWFZI?=
 =?utf-8?B?U2Uvd0l0ZlkzZDhTamd2QzJuTHFTRXdUZzdUdFFKTE96c3pEUGMyaDBldGZR?=
 =?utf-8?B?S0hQb2tQSU5OdWlBTjZMbVp3TnFwQlBtYTgrTkREVmpzbkxBK0JZeHZTbE5D?=
 =?utf-8?B?YjVNTzEvbmR0NlA0SndvdXg5MGIxMmZId05nWFRXSllKUkRabjlsY21SLzFY?=
 =?utf-8?B?dVlzRlJKRnlEcHNpbHNMZFlienlNUXlPL3VMS1FRRGd4eDMvbVlhMGVpdi9H?=
 =?utf-8?B?TGQrbHYzMXlqSmJsb3daT051N0s1cnRSb1BWT2NnMkRtZkhXbGRiTmFhWU9T?=
 =?utf-8?Q?L4X2j4l7z44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NlNxQVZhM2NUeFFhUWJEaS9TMGtWUnNmTEpVaEZvNVVPR2ZDVGRSb2lJR3Fa?=
 =?utf-8?B?OXJybEJYUXA0OTNYNy9vckZsMGNtRHlTdFFwS3RKdzc0cDB3MlVXT1pidjlR?=
 =?utf-8?B?RkxEYWR2YkJHU1hzQ1BYOEZTeFNHckVKRlF0aTFsc2U1WVN5OVNlSjBWMkZH?=
 =?utf-8?B?MGdrcXdHRGN3dDNhbm5sSDFhbXNseEt1eG01SXNNU085N0FqTHN2NGlaTTZw?=
 =?utf-8?B?bm9JSHQ3NUVwbithdUZTcDJFTnkyL2FWU1Jldjk5VXgzc0pubW16c0hpNTlO?=
 =?utf-8?B?VjNqS3hPWFJreHI5Q2pxUU5aa2tpejc5N0dNc0lvQllYTTk4WHg5ekNTV3hM?=
 =?utf-8?B?allpWmVFS3pQL0tCMGlBTjZLR0x2VHFGb2xjWC80U3BMZFZEU1VrRTVJREZZ?=
 =?utf-8?B?aU9kRHlUSXVLam1Kb3dBTUs5MFl4U2VlSytOMHJmdEdRNlc3WDNIMXdPd2I2?=
 =?utf-8?B?VTJzUVBFc2d6cG5KWllQZnRKWXhkWUxGSEtmenA0WnRsUzhBQ0FsYUFBcWxI?=
 =?utf-8?B?SkJDODVjV3BPU25kOUNIWGJ1K2RrN2c4Q0kveWlhaHJlNW10VFB4RjlQY2t2?=
 =?utf-8?B?K2VDRDNYRGZpdG5KWGxLNzJlRERvUGFsZGZaQ3E0TGpkSmtweUZTTTRCR3Vr?=
 =?utf-8?B?eWJ4UXZLNU55ZzdrVlNjT04veXMxaVJQaElyMGNhRDIwN2YzQzZNaG1nWDQ3?=
 =?utf-8?B?QUMrWkVnbm4rRktIUnNrb2NGZjZPYTk0SlRvQXlIVzVZNnFKakQyR2RoWmlp?=
 =?utf-8?B?NVRxc2hDRmZIUkhIOUNCS0o2RjJ2SEo2SC9ydjBLQ3cwdys1d2JGd0JpRDVC?=
 =?utf-8?B?WDRQVUgzelFSdFVibjA0OVZSa0ZvbExrUW5ES09MWWRqSFlUWlFGZVIwMFZB?=
 =?utf-8?B?S0J2NHpFVXRIeTl0UVZUSGVHUXBwanFiZkZJVzNiZ3FpaFh2STRLUFQ3M2VS?=
 =?utf-8?B?a2UzRGhlWmVTTmpVUXg0Ym1EWGRLTUVBOFpJUmFNSXFZejUvd3ZzcmpQZDRX?=
 =?utf-8?B?Sm9hVGxXMjh4MExrS29LUjZoZkt6emxkazdjM3BXUkhWWFZhUGJlWCtVb3dU?=
 =?utf-8?B?Y2cwWmdVMlhJYjd5NUlTc3VxT1dKOWNsdXBVSXlLdjEvNjEyb1VnaE9NNkFw?=
 =?utf-8?B?TGVMOVpaMjM5Uk11aXp2UEVaaCttOGdUV3R6eTNCcXJ4eVF3RXZ6eEJWWXNC?=
 =?utf-8?B?NVk2ZlVUMk1Uc3F3MThzL2hTWkk0d2tlamdiNkFyUC9vdXZNeEFyejQ1dlJO?=
 =?utf-8?B?RVhlTWd1Zys1OGxXQ08vdmlOTmdnazZXLzljdURBUUtxV1haVWpzWmdhdnlF?=
 =?utf-8?B?bjR0N3htVkw1aDUzVStIV2I3bDNpWUVjVXRJWWtwU2JvTDN3OERqSjkyREZX?=
 =?utf-8?B?RUJycHM0TEp5TEI4TmlHNHJ6aVRuR2VrblYyWmVjVHlMNkJPanFicW14QXRs?=
 =?utf-8?B?YUJNVmJkZjVzeUhmQktsUVR2MVg4K3MzQVdtZUpOczNHREVoS1JZY3IrdUJu?=
 =?utf-8?B?UDRMWDRRQ3gvS1VFNXBhanFOMWZmZm9XKzVmRGtIdlJqemJBRUt4WlhjUHEw?=
 =?utf-8?B?YU5ON0xQdUsycXVPQWcrUWNpZ3VsZ2JZQVFHSENLcXJYTDlNSEFWYjRqRE9C?=
 =?utf-8?B?Q0g1SHJMbUNOcnRFSnhVYVh2bTJRbjQrV1E5cDZjTDhQT2tzdnlkZE1HV3VK?=
 =?utf-8?B?Ymp1bm9EcWFkODB4a3N3THdCNlhIQ1FxL1VPbXVrRlhsb0FMYXFISHcrNkNa?=
 =?utf-8?B?K1ZzTlE0QmpQSkFNd1Eyd2VnZE0zSWIzN2VZd0ZxdVZjQUJZQkhpamtrdTRG?=
 =?utf-8?B?OGwxVFhzaGlNODZlRDZia3dwTTVPVUtpcCttWndQamVkbzhYbTFqRWtFY2hN?=
 =?utf-8?B?MWk5UXFibTNaeTIxemVaSkxHenJEcDJUM0lqYktwWXdtamdEZHVGU0pRbSs5?=
 =?utf-8?B?MCtWZDUvSzI1MEczNHZsdUtBSzhxYnhJUlRsRGd2SkIzQkJtVU9wNUJ6NXND?=
 =?utf-8?B?QmVMZ0JCMXBOcXc1MUlLRzEwdXc2YW1XSkpBVktxbVVDZldKM1ZvNVVrSy9U?=
 =?utf-8?B?WGdibTdoYTAwd2xxQm5TeVpPZjVPcG1UWDhlcVQ0SUc3RExmMFRCRk1CZnFq?=
 =?utf-8?Q?dnZhcop/CcsivcPogH5gLyPgW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 936ee4e7-743b-4bd9-bf72-08ddb3865523
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 01:19:29.5531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2rt7wJkopaNsO8oyNrwbhml++ng+/yAvd315cuHtwGasr8VkT7IVADBnvlV9ls6eSDRuK33t3gg9lJiEo+Jiig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7287



On 6/23/2025 5:11 PM, Borislav Petkov wrote:
> On Tue, Jun 10, 2025 at 11:23:49PM +0530, Neeraj Upadhyay wrote:
>> When doing pointer arithmetic in apic_test_vector() and
>> kvm_lapic_{set|clear}_vector(), remove the unnecessary
>> parentheses surrounding the 'bitmap' parameter.
>>
>> No functional change intended.
>>
>> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
>> ---
>> Changes since v6:
>>
>>  - Refactored and moved to the start of the series.
>>
>>  arch/x86/kvm/lapic.c | 2 +-
>>  arch/x86/kvm/lapic.h | 4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
> 

Thanks!


- Neeraj


