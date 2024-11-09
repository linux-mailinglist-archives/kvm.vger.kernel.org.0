Return-Path: <kvm+bounces-31352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C899C2E93
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 17:51:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51578B219C3
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 16:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96BBB19D087;
	Sat,  9 Nov 2024 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aTNkMe8s"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2079.outbound.protection.outlook.com [40.107.220.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EC413AD26;
	Sat,  9 Nov 2024 16:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731171092; cv=fail; b=Qb+AA7fSVXoX6xbpOPfanq+62Q+64kq2LqwfFOg0SwXrqCbQC91b2lksmIYEhExAgw4u/khwpKx3dSyUjiBPvnavGb/xgxaP/L4FHWCqEEfF41MTcsCA9av3Fduw2ZHbhHSW9BCSIU5xLivxqoyCSKUnHFw5DsZvbEQ0JIxjJHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731171092; c=relaxed/simple;
	bh=Skc+p2Cp7Tzou2Ocv189cHfnHQBGvwuk1FyvR9NE29I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CVfcZaYB2sL/6C4bvN+Z+nvugkTMpvwUv3jVkj749AtxbbzFEHqg3xGPhSiNW90fT2cMpDMTX+vonuy4Lj8+INJT1J/C99whbEUCmpqWQWFKIlZgeDz/nNUbOs5K1xJ+d8rQwL8sU8lAM1kpzDNV/QiLDKPpCSvVRNtg3cM1vn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aTNkMe8s; arc=fail smtp.client-ip=40.107.220.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gx3VT6+EOef8pTIt8BnZDeKJ8KJNNTxLL6cpwOjYUk6dUVwIN9JKK7nWBIzDrrJxoI6h/F/pCdYF3uIayDP2fzTkH/17fXHKh+frGOnpcakesSXomQBIqv7X9iwg5zmuG7BoauMXCrDBH+o0zNfrnWa8ZWWT97oxRO070h9q7EMPV7yy184O/3vKXs8GFTkpFUNjEA7lLylQOJ9Y3hDtFhUhLEwFnZg2fxPB5ca3/hx8JMwkQQHLRNwuayfi0UDqoJ4LwwVZUB50VVONCjT6Su8XWCvpmCq7wEO/mPKpaPwx9ABW6rl8tqxujsnUpJ+7qdoVv3qw5RLimqW9uRx2Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7U0wQU4zAhgtqZB8sKrcsrzvUvzj4yn8jKApqkwKu/U=;
 b=nAZAuw6NXkpVLItk47BzJ/BD/DPwRUqRa0lgtyQqxsgMIZnd4dOkyQCsNOMDbhiRG6o1Vhr77OAOedH1hgAqSGJ9V8Zzj8hu1+icCf05ONfYFIrvqAtCqaEHP/Q1e5eemfZvq4B2AxfYdbnB5ndJhCBN/2SQ35kvCHYpEm2Ckv2+ua2Ko4jcY2ItBGHmJgj1Vigt3cQs+iyvJP9w/I9IHNexopAaO3yieofpHiqP3ru59S8ygmKeIwdiFMCdS//RvSjdgGeVYMx6+2pGDMZFdJ95Qvlop9ikOqkSAL4mTA81YpSxufCtoAk9FdLhZqD1P17FtSCaLiA6BIHEjCeM2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7U0wQU4zAhgtqZB8sKrcsrzvUvzj4yn8jKApqkwKu/U=;
 b=aTNkMe8sb4m1J49FqOPADYJg6CXYRW5PE8CqLTqj8iw6VX9a2y3aySddn1HamRdW+nDiVvPMiPgtsbbaETtSeciCK/vYF8eNiQWQcOgSyEZk3EXdKE5sxqsVFvaNEhF18BEZ5+vLTRZnTkhrAizmIprGBtZgNdQjmdHHSqtHzgo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11)
 by PH7PR12MB6564.namprd12.prod.outlook.com (2603:10b6:510:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.22; Sat, 9 Nov
 2024 16:51:26 +0000
Received: from CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0]) by CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0%6]) with mapi id 15.20.8137.019; Sat, 9 Nov 2024
 16:51:26 +0000
Message-ID: <e4e3efc6-9389-4adc-b33a-475fb9ad7520@amd.com>
Date: Sat, 9 Nov 2024 22:21:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 04/14] x86/apic: Initialize APIC backing page for Secure
 AVIC
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-5-Neeraj.Upadhyay@amd.com>
 <20241107152831.GZZyzcn2Tn2eIrMlzq@fat_crate.local>
 <4af5212d-a6db-4f14-ace7-c6deb6d0f676@amd.com>
 <20241109162741.GCZy-NfVcTfOLNwzkT@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241109162741.GCZy-NfVcTfOLNwzkT@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0087.apcprd02.prod.outlook.com
 (2603:1096:4:90::27) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6599:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c332084-348a-4430-9e71-08dd00debf56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enNmNmJGeVRCd1ZRZlZWL1NwOU4wNjBNb0ZKVXlZZVh1RDMvOTdsbFFlKzBT?=
 =?utf-8?B?aDZDeUE3RTJiODVlYmMwUzN4bjdwd1B3Z25RQkIwczdTeXJzcitHZTJpZzlD?=
 =?utf-8?B?QUdzSlVBSTFZV2NtTTMxVDVzQlBvaHFqT2RzQ0RHRmFlWEg1MTB5dk1QbVhW?=
 =?utf-8?B?SzJBcDJtUURMY3Y1Z0JDTlk4bjBHSjU0czRYdHdjZ2duQ1dRSWwrQjYrR3gy?=
 =?utf-8?B?V3VVdWJGQmd3M201UWJGQjgwd2lBaTIwWGZQQlJkbms3eFpkNWU3SWlFRUQ1?=
 =?utf-8?B?MzVkL1VxaVNSa2szSVMvcjBEdzExMlNnMWtrYUR2UzJ6ZCs5Q0syeWFCbUVp?=
 =?utf-8?B?T3VVRkFvS1drVW8vNlJNenpuWUZqVG15U1Z4ODFOY2tHWjBkK2pRajIwc1Z6?=
 =?utf-8?B?MEQzbEVIOVpCMlRhMlFETXpSclBkUnd6aHFybldUNjFUKzNtRDVFWFFsTk03?=
 =?utf-8?B?MTB4WUo5OUs2TzVSVkR6MU9Ic1IxaXA5QmxMY1pYQWxCM211RUhHUjFOVXFR?=
 =?utf-8?B?ZURwZG9ndUU2cU5yaVdhNlhZVnNWaHhtQTREYlV6NWVMYVJvYXFFN1p2TnJT?=
 =?utf-8?B?ak1Hd1JnU2xBM3N2eHhHSnMrcnlLZ1UxZzBLRDIyd0dXZENOVHo1TUp6YkRD?=
 =?utf-8?B?M29OZjFpRFJNcmhlbCtDeWcxU2I4aHRGWTVDWVlYb0E4MFVGNWRYRTlpMERu?=
 =?utf-8?B?ZjNhd1NJbVJIVmpLZGl0bWhkTnIwOU1PZFQ1MGdDUE1zN2lCcFpScC9adlAy?=
 =?utf-8?B?c0kvUnNpN1BjVVoxNnRiRUpDajhNeXhwL3Z6UnRuSFFac0l6QUw4b2VUMHo1?=
 =?utf-8?B?bmxrY25GMDBuL1ZjbXBxamhDejM0NzhSS1Z5eXlYRCtydmxrbHFYNlJFSk9h?=
 =?utf-8?B?cWJTY01UT3B4N3dESC81dFIwbzVLdStsZ29Jd2NrRVpGT211N3JJQ0NzcENL?=
 =?utf-8?B?YW93eGIvR2wyWXpYamFDN1RuU1drYXp1VWU1MGg5SHZrRGJRNk5KUWlGM1Zt?=
 =?utf-8?B?b1NxNUJqSmVZdjhvOFh3VXJwa0RrSjFKVlppY2MrSHpMVi80bDJnWEJEODIv?=
 =?utf-8?B?UWJTQXdpSUFxYmZCaUVpMkVWemxoT2JvcTMxL1d4QTBmUjVLdkpCUk8yOXhI?=
 =?utf-8?B?Y25NRWNQNTk3N0FlM1RORTZkTEZyVnBYb2cxMkJMUnp1ckJqdjZkOW03eXFh?=
 =?utf-8?B?RGcyMU5pTHplcDVkR0o5bFBTazBvMkF4REhoeWJURVJlV3NiRElVT2IzeWhj?=
 =?utf-8?B?OWdBZkFQVE5yWWNrMlZEK2VMeWI5bzVaR3puS1NqME4rTys2VlhqclRsQWc5?=
 =?utf-8?B?Z0JrQmpWREdQL0Q2clZjQUI2TVF2a2U1OGUyOHJMeHdVL1I2Tk43bzlCNXl0?=
 =?utf-8?B?dkVGYlYremw2d2UzTlpBY1MxZXFmNjJhK3FMNUNpb2l6eElvakg0UjFiZTlD?=
 =?utf-8?B?WXlCN3R2ZjJncGpYZ1R6a0pYWVBEVjZtd0s5a0ZmbjhYRHhvb243MEI0UkRh?=
 =?utf-8?B?VUR1R210R2tBRWt1bnpTVDdIc0xvVDdyYmhubHlVZlpNUlh1VElSa2pGdHNM?=
 =?utf-8?B?M3NRS3J0aitKYXJDWkhXQ2diQ1Z5dEF3MUdXNVdxMCtpWDZlZWk0bFRjL0lB?=
 =?utf-8?B?L2NGSUY5YTYyNXcra2JRNzFObGtRWGtkd0NQRmdpUGxjV3BCWWp0b3RabExJ?=
 =?utf-8?B?cTBkQWdMcjhKMDZ3MGRseWUyTXBDaE5IUmQ3Z3BpQ2RsNlFNZXFMd1dXenY2?=
 =?utf-8?Q?o32AQZ9nKUycVmxJBWt4oMU3lhbHux5w3wBLlj+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6599.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d09LT0YxYlVyZDVzMVd3VytZNUloQmJuU210VW5yQitkdkRxM3BNWDlwL0hY?=
 =?utf-8?B?Y2NKYWZndnhRNkxEWTFHZzVqOGZSWkFqSFNpTGgvTEh4eHVQdjVMN1FPamNi?=
 =?utf-8?B?ajhSMXZoNlZZaUhFT0VtZEd1anNqR1o1UTlUcktHZWJOWEprWGExNEVBSkNu?=
 =?utf-8?B?a2tvTmxnUFRGMnNmM09Pcm44TnZpVEpIQ0JBM0d0N3hKelg3RU5iTEhRb1lF?=
 =?utf-8?B?b1B4bUovMU80VXUyaXJ5S1BDZmwxZUNDanZjNTM4OXh4QXQxZDN3c1hvVDhm?=
 =?utf-8?B?TFU2Uzg0ZGdnZThKUDB4cUdkaXdJTUFoNm5oWGlCZEdpWG9QNXEvMEJOWWtv?=
 =?utf-8?B?ZEJyYmdkVjRNbU9pUVlUbEVseFFTNjNEYTNYdzgzbElmalRPdmxTa0RjZ1Bt?=
 =?utf-8?B?NlNIcnk4S3NmQjZXem90Rjl5V29td3hDRDcvSFNCL29hRHFQZFB4aU1BaCs5?=
 =?utf-8?B?Z1Vza0hYUnFQUnp0ZEpnN2UrSmtvbytIZVpPU0xJaFZLT0gwOENlczN6dTBr?=
 =?utf-8?B?YWplM0t6M1NLTTdTOTk1R0JIMjNEU25KOUZnUFhQR1o2VjZCNS9lVzdnMzBN?=
 =?utf-8?B?SnpKOUs3WXlyTGE5VUcxNXpmMVpGTnIxbHpSemJyM3VxK3FPcTRFNzF0akF2?=
 =?utf-8?B?VUdpbkU4OXFzSEVQb3FVNW01WVRsOVVsVlJQYVZMQ1phTnVXOXN5T29qNlAy?=
 =?utf-8?B?Q29zdU9EOHhEOGttdDh4OWN2cFRtcVlnVzNDRDN5REFDU0x5MmNXcC9kN2xL?=
 =?utf-8?B?dXJQTXVnOUtVdkRRcVpYd0lYdTN4WW5HU3pHbG50QkFsMG5EYlMwalVQbWlW?=
 =?utf-8?B?LzRIaHJNcDZGTHFsWmZ0KzlGcjh3MjZXdVpHUUNrQW1MdHFxQzJ5bXNtN2tp?=
 =?utf-8?B?N3NZNEdIQm5RT0NzM09teTNBbDlNa2UwMWg4ZnN0dm13MlpoRGt0SWlXRm9P?=
 =?utf-8?B?TitybGZ0K0VtZ2lBSm14SXFSVlY5T0ZmL05PdHpmeG9NeVpyMTJRekV0emdP?=
 =?utf-8?B?aTcxaXJoZG8yWjh2dEZidDhHYTVabmh6SXV5UUYvUFIzNTFJcXZEZ2JQY2Vj?=
 =?utf-8?B?TmdMcGViOXFPQ0lhVytWMlprVW5HVXljaDRoYm1BZkFDdDFQdGJFUlNBeGI2?=
 =?utf-8?B?Q056YjJVTTh1NmZuRko4cEF2WXJvMDBhUm14Z0FvQUNCcnEyYkVIQllSOHM4?=
 =?utf-8?B?QTdWZE1XNDFXUUJzVlo2dUhGZ1RPL1FPQzMwS2MxYU1ZRkFlTlpzREt1Mk5o?=
 =?utf-8?B?NWZ2czdwYjVWWFVxVk5tTVJwVVpiVVdHYWZFUTM0ZW50VW9naFVlclJWOE1a?=
 =?utf-8?B?aWVmRU43V3RGRGhuQXMyekMrYUhKVFdzZXorTmhRZVVKVFExNnV1WXpIRnI4?=
 =?utf-8?B?RlRQYXFzZXZ4MWpuTEhBYlhmeGtsWHNaSXQrUG10bHZVT25wUEh5RFgzdUVJ?=
 =?utf-8?B?RDFXMUNrbm5ob2FuZFRTTmh0NitjK3FnTmZsY0dOU01BY1NzdTFveXZvL2Y5?=
 =?utf-8?B?alkvK0pQelFJMm9CTlRhTzFXTnM1RXVvcEZ1YllaTDJ0UXF6bG5UMHF1aGNy?=
 =?utf-8?B?ZTNaKzNCcVVJVkJORVNCaW95bFNHUGVkYWVLbVBpblpQSGZqTW5sS1MvVVh0?=
 =?utf-8?B?NStwQ2I3WDhCRUR5cU02RHJTeDJiQmU4b21Hc08yUlVxMGtpWitlSThVQ2hs?=
 =?utf-8?B?dTVXQ05rS0svWHQ1MTZtN0RHSEJ5cXIzcVArbExlbzdyZ01yamNiUXR4Tmor?=
 =?utf-8?B?dExGSDBidzNjU3Azc0FWY2xRZ1JOQWFmWnkrSGhIakZLY0lUOG1ueU9LVUNB?=
 =?utf-8?B?bVZiTzlHVENWWkE4VVFmb2lRVFIwY29qN1cvRmFNMktqWUllQ3k1d1B6T3A5?=
 =?utf-8?B?L0doRSs5dUlqa25aNWlBNHZLTmw4SVYxd1dCRnpoV0g2VUFEclpWQmwzY25u?=
 =?utf-8?B?bUFHN0tFc2MzZ0h2QjBQL3VBTDdBRXNMVCtpZkFYZXpCSnI3TXVSMmFESkZs?=
 =?utf-8?B?NmtqMitrWXhycWFpRnc2KzdLREQ0RU0vM3dGWFhQQnVsVkVzN1huNHNVVXN4?=
 =?utf-8?B?Mm9LcjVhYUdqcCs2bzZ6c1Q0OW1lVzA4MDFrZHpES2FLN3VXMDRseVF2SCtu?=
 =?utf-8?Q?UNDSDR5xkzBp7N0wMZDX2X4Ui?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c332084-348a-4430-9e71-08dd00debf56
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2024 16:51:25.9129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6zOupPBwfbWmM+2RxdBmDjr8rgU/cFvOC7YTJIDHqoqNGKDSMMXKr9DkOR4hVH6ghTp1EqhibYpMfFhPbfVIKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564


>> and provide a secure avic specific function here (will do the same for
>> sev_ghcb_msr_write(), which comes later in this series).
>>
>> "x2avic" terminology is not used in guest code. As this function only has secure
>> avic user, does secure_avic_ghcb_msr_read() work?
> 
> That or "savic_..."
> 

Ok sure.

>>>> +enum lapic_lvt_entry {
>>>
>>> What's that enum for?
>>
>> It's used in init_backing_page()
> 
> Then use it properly:
> 

I will update it.

> diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
> index 99151be4e173..1753c4a71b50 100644
> --- a/arch/x86/kernel/apic/x2apic_savic.c
> +++ b/arch/x86/kernel/apic/x2apic_savic.c
> @@ -200,8 +200,8 @@ static void x2apic_savic_send_IPI_mask_allbutself(const struct cpumask *mask, in
>  
>  static void init_backing_page(void *backing_page)
>  {
> +	enum lapic_lvt_entry i;
>  	u32 val;
> -	int i;
>  
>  	val = read_msr_from_hv(APIC_LVR);
>  	set_reg(backing_page, APIC_LVR, val);
> 
>>>> +		pr_err("Secure AVIC msr (%#llx) read returned error (%d)\n", msr, ret);
>>>
>>> Prepend "0x" to the format specifier.
>>>
>>
>> Using '#' prepends "0x". Am I missing something here?
> 
> Let's use the common thing pls even if the alternate form works too:
> 

Ok sure, will change to "0x".



- Neeraj

> $ git grep "\"%#" | wc -l
> 411
> $ git grep "\"0x" | wc -l
> 112823
> 

