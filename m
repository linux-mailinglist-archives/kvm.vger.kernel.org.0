Return-Path: <kvm+bounces-48305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E44F5ACCA07
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 17:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E53F3A647F
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 15:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED97723BF8F;
	Tue,  3 Jun 2025 15:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ynf83FFC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9284F22AE65;
	Tue,  3 Jun 2025 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748964113; cv=fail; b=rv+3sPG+DcXwZjL150BRQfhZiDhz9+BS2pNaSiUSIYUSk0NTMW4PFmowZEVgAi4gSNqac2f3MtzVENiCXGAxEYtfPpq7Oc0CW/9f7dXgKtUl6KY1vEFtVek0S6CoZ3bMYAAUdEnWZzSxB5c0s58ewrZeQBuVgofPO+YXSxa/KLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748964113; c=relaxed/simple;
	bh=0J5j9P/ldecOIxINNkqHtrRpjcoAfGQRzTVYGU4mWsQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nXnYhvvBVse7dYuwHrfArUCTqdTPVemNBX0I7ppSkkZnMNA2V9OJW/TIIBg13446gwMWcNW0Z5vz2hkhWiaamNRBH+kuW52vR0XLxYMv0vto8UKWXPnhGHI7Q3G3TczhIxHtSO0c2RcV9qkQVP4W/CFXjxH/uyeRhFYIXnMNRQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ynf83FFC; arc=fail smtp.client-ip=40.107.92.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fute4H1XnQqGWzNJLyxY+0wd3lz72THvc9ijW9WD2bsXG+g882mxFATHX8qVbd5rL7t/h7KcpyE53/I2HsKBeaoc6MHmxt7/zT7tB4qApw8ayCUWTxBdHZIAmcGDyqh/Cstdz6tnqdVHwgC3b3eZ6m08VlxFu3Aw8eUX8s3PVGYpz4wGddBeMrUNCTFeuTBWmGEvHz9F2lkrC3a74aNubIkzonkwnEhrC/fADwxl3rn9mG+9pjODxPWsOQNY8U4bDbLLIsNne7oiWnE0gtc+/70kX4Pat91di9X/f1lM4bDCzZo19JcZRhZJGiQiZpvr5miCzgmMt9FAR8ahzWJ2Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hplhIM8nbp0D5GAKI/j+3jny5+dg12Cm57/QwDp5wBs=;
 b=PMD2AWOPS5iQujuvK/xchoERo4IgI8An8XKsOi+iW7/TegPtAMYy1CbqWrr0UZ7smEfBXK2+LMPoRWhtRpbDayjpfAamrT01CiqhvK+opd+eyr3WVUExunT7T/MgMy6iDY9V1PTYIk9UTUAg2sEG+M2E+bR0M71238l2PwLP+hBgXMzTb3nWveK8FqyJripnRLYhyj/8wZKoonYKg2Gs/JOMz79k9qzWtUN/KMiUAM7zjeY/u1DiGS08C2/1EHaeLuFekVmo1cj9Uty2o7c5Nu+QN6noA/bqkIssiSinisHsHavhjZyx/SSE9wlvV5C/AkhZlBi/S6JqRn4AhO1isg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hplhIM8nbp0D5GAKI/j+3jny5+dg12Cm57/QwDp5wBs=;
 b=ynf83FFCP9/foHqmVBzyLeF+pQLHo13XZKNTQKl3Q7oggYibYPg7v0YWhuYC9gJkKgc4cxnyu+E5wl2MzIkO7R3UVboO5sAPa+7XLfx74EDNhxIU1kgfdlKluD2neVJv9o5jgVGK+kOX31XYbhK0bGcNG7F1DDz4EQd4N899nUc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB8978.namprd12.prod.outlook.com (2603:10b6:a03:545::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 3 Jun
 2025 15:21:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 15:21:44 +0000
Message-ID: <295dd551-522e-1990-4313-03543d22635e@amd.com>
Date: Tue, 3 Jun 2025 10:21:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 2/5] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <61fb0b9d9cae7d02476b8973cc72c8f2fe7a499a.1747696092.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <61fb0b9d9cae7d02476b8973cc72c8f2fe7a499a.1747696092.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0048.namprd04.prod.outlook.com
 (2603:10b6:806:120::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB8978:EE_
X-MS-Office365-Filtering-Correlation-Id: a08f3db9-069a-43da-96e7-08dda2b2595b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXZMYlVLTnFjVkE5bThDQUEweDk2MXpOMDVwU0xXNW0wMHNaOHVUYzFZc2Ra?=
 =?utf-8?B?dDNBWWwrU2Q1YTdtd011QitHNzBrV0RjVXErdjZqT0V4bTlkemtqQnNuOCti?=
 =?utf-8?B?VytrdklJWmQ4TVdydmU2WjF3dU8xT0VteUFFMnVqUkQzUUs3Ujd5SU5LUnZz?=
 =?utf-8?B?ai9ZcVppd3ZqOEQ5Z1JPRUMvYWFPRkhzSnZtV3EzdDVCcElHaFBVb2dDMUdo?=
 =?utf-8?B?V1ZsNGRuditXWDhXcnlwMFJPSDhQY0lIQ2VDTnVJUXpZQ0ZydkJpckt4TGR3?=
 =?utf-8?B?UWppQXBKVW1wd243eFdybFJUOWZDWkIvV3NwdTFMaXpNdkoyUjB6V3BWL2ZL?=
 =?utf-8?B?RnVVZloydjBUenphbDh6M1dWWWI4ekxhT0JKZlNuU0RGZ1FRSEZKejhpMnRl?=
 =?utf-8?B?UTVXMTJQS3V3VlpkdGRqN3ErOWx3NitoRlZEVTV3d3lZdTRoNnVWZWhTcHNs?=
 =?utf-8?B?cW1IZ3k0SGhSNEtrbFlicGFsQ2dlbTVLNC9zLzladjhESlM0TnpFUXlWUHRC?=
 =?utf-8?B?R2xYZkxCR3I2VEJXVHBRQ1E5Q0trSXV6c0RXTnd2c1kzU0lCVVNML2hBVkJa?=
 =?utf-8?B?cENFdGVjSzVIV013a04wRS84WFZtSTh5Qk1UYWRPWHJqZGIrbVhPcDNhSE1m?=
 =?utf-8?B?MFNGcG0rT2tZV3A3VTc1V1FVOUUvV1drREVpNlk4b1lVbk1qakFCekJidXQ3?=
 =?utf-8?B?bUc2NzJCMkJWWWJaY3BRMUVJamZmck9ZbmxQc3Z0Szk2c29sTlR5ZytJNk1M?=
 =?utf-8?B?YkIxZHNpcExFQzVaMXpRVGdBNGd2VTZyaG5MaUttSTRMSkgvWUd5eHp0bzdx?=
 =?utf-8?B?RDk4RlJxVUwwU3lrdUZhWG9qQ3JaaDVvclR0RnRMZ3VhanE3SWNRcjJ6bFhk?=
 =?utf-8?B?NEM4bnI0WVRpZ3RPWDBGaEIrK25RcVloekJPdzQ2OFVUdmhtL0NCdkhXc2dh?=
 =?utf-8?B?ZlZLbjI5ZU5VZzc1Y0F0L2ttZm4rVVhxTjU0dVhCZ0N4VnJwNmJmK2MzZUNN?=
 =?utf-8?B?SWxmUjlHYW4ya3FEMW1TS3psM2R0L3RsZjVnNWxJU3o5YWJXL2V4VEdLeE1s?=
 =?utf-8?B?VUhRcnpnbUFBSTI3MTNqNndIZ3lRSkZjRitGLzhtRFJSMnlGaG9sNVpvK3M4?=
 =?utf-8?B?Z0V0NThwbDlWclE5NDdSa2drRUxwWENpREFMMDU5Y1V1Zm8rR1VIV3gzbFFJ?=
 =?utf-8?B?VTJRSWhkSGQ4UW9penNGR0E5WUMxNXp2T2RLNG5uVTBLUmc4SGNKUDlpdEo3?=
 =?utf-8?B?V2tHc2hpYjR0RTAvaHFRVEZMNkJCSjNHRnhPK0hsVXVVK291RXpiTzhBS3Yz?=
 =?utf-8?B?RmV3U0wzalgvL1gzcWw0U29oMTdPaTYrNmhUd0NXV2J1bjdFV28yMEQva2ky?=
 =?utf-8?B?NndEU3RzbmlEdmxmKzJkLzhSRnJpWmxnVUhBTllyWkVMZ082ODFPQ25yWGt4?=
 =?utf-8?B?b1VtUGRUUExLRTRCUEc1dnhYMFJ6VjZoWUF0SVY4amNpNS9MMkNrYmdnTUF2?=
 =?utf-8?B?SUd0blBUZjRqUW05MUVlTnNES0hxUFE3MnZHR1RJVkJpUDhUajV3OXFTVzVM?=
 =?utf-8?B?SG1qdWVhQWFNS2RUMHVWQlJ2cmwyWFFOenZWT3UwMXJvdHNWRGVDMzgvcnh2?=
 =?utf-8?B?WFI2VGhmejk0OHJhcFQ1amNnakZOYTNocVc1ZnoySVFpMEFNbkprNzZiMGll?=
 =?utf-8?B?QThTMDc3VEZrVUtFSlZpMDhLWEZKNytVaGxIeUcwZmhZWk9RcG4zTFlGNVRE?=
 =?utf-8?B?NXpXVTg3YklGS1ZqcjB5ZTdKOSt2SXhLeHlXdXZoaHk5UWlOL1AwZEs0TURH?=
 =?utf-8?B?Y1JCRjFHSzhaWE9xWHpWTWsxaXNERlJhOGtVbGkwL2lOYVllNGFFM0cxMTVS?=
 =?utf-8?B?TXlFVlFMY2tPeFRsWStuektqWFZXOVZiWDNHUnZISDJaWXVZYmU0ZTh6Q2gv?=
 =?utf-8?Q?UoPKnXCzWFs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3BuTFMxbGdpWTI4N0VDQWdNeGVUcUg0Z0w3RUpQU3pmcTFNQ1ZLQ0plWEN6?=
 =?utf-8?B?cndhWS9UdUhScHpFZDlBeUV5Y0dFTTVSYVAxWjM4YTJZOU9YMlNtZnpRZStj?=
 =?utf-8?B?QmxtTERPdTBhOEMrUHhMeTFveENZMGJLUXpoSjVlbTJ1eXo2eGxjK1lSSGlD?=
 =?utf-8?B?Z2EwKzFLdm5xREJlbzZBalBoaVVaVjN5eWpFc20xQ0dOUlpmdEtjMUU2am9V?=
 =?utf-8?B?ZjlORGM5UWdrQWVLeWNVT2pZR2d2QjZxT1Y2OE4rTHd3Y3NsRkhlbjlqNUpN?=
 =?utf-8?B?aENvNGZVajcyNW9zNHFXbHpPRitPS1dtUzRhUG9tN1VPSUNIRWVacHhjK3Bw?=
 =?utf-8?B?c3lmUzFRc1EyTTRVSjZYV2JTQzFBdkRXMnhGTWw0VE1WNWYwV0Zld0dlbGhQ?=
 =?utf-8?B?blhJSVpwSklqN1ZVbmJDRTA1SFNoNHlvdWdPeU5QK3JxSWdhdWljb3hBVmNF?=
 =?utf-8?B?Tm9iM01oM2xSSUVxbTZRTmhEbTVocHAzYVlIek95VmRLYTlTS2ovSnhVRzdF?=
 =?utf-8?B?TTNJekpwMCt2eWlMQklxcVgxbTh6NXJJRnBJeFZpdVp4MG9CaGh3TmY1ekR5?=
 =?utf-8?B?MGlXOThGRml1NTdsaUFGbmhmeTBhU2c2REJRZTJwcG9YdFdVYkVYeU1MRXFl?=
 =?utf-8?B?Z3RZSFFBUjRPRXhIS0xrMFY2UGJZbmo3NitQY1RlUjNhT0NaNHMvcUx5QkVZ?=
 =?utf-8?B?N015SW1GSjBUTHAwNFUwYi9xdDlNajNQY1BTZFlrU2dDNkwvdVpwQTNsanhQ?=
 =?utf-8?B?QjFMTDMvNjJ2d2pFNmIyMGFkZXUwTXJERllZMjNleUNIT1kzTGIvN0JFVDZy?=
 =?utf-8?B?MHpFZGVveSszbjFjVHFpZHlCM3hoUzZHZk5QQ3VPS1hFM0RoR2lVWURmeDFE?=
 =?utf-8?B?U3Q3dUYzMld0ZGxQUEtKL1lhVXRvc0hFSTkvY01IejlFWWJBOTlSdHlkNTg1?=
 =?utf-8?B?VURxVnorZ3JwS1IvN0lyb0FNdFRraUtxbnlYTzczQy83a21iV2hZcGlrQnZD?=
 =?utf-8?B?NHRYZUpvanNodUh2VWFMd3A0VzRxaUVoZlJkNWc3YktWY1hEdmFNY1dwQzc3?=
 =?utf-8?B?MUQwSWxPNmFuc1lnaVl1eEFJK3ZpVktqa1diNXErZExEVkZNM3QySWJmVGJr?=
 =?utf-8?B?azFPOHNUbS9ZdEFvaWUzS28wdlJhdUV1M3pVUGdydEVXazgvNXFHR3VnZCtp?=
 =?utf-8?B?a2NWK2RTcmtScWhGc09VOC9TRUdpZHBWRzVTcjlzeUtWd1pkVUV4T1dUcXFY?=
 =?utf-8?B?VEsreUdZVVJIeDVGTTFFS0pPODFOMlpUV1ZsNmFGTFJJSnRpZXNlOFJ1bGhS?=
 =?utf-8?B?MjY1UDdQd1drd0NnVSttdmJHWkZ1dXZHV2dhaUp6ZmFmWlZ3T2RHQXJVNWZL?=
 =?utf-8?B?cENSY08zMWlucGV1VTJ3Ulg4V081OGY3LzVXQVFxSVJ0R0F5cCtMR3Z2Ymhv?=
 =?utf-8?B?WVlZRS9mUG45c2FnczhoRDRaZEFUOXNielp3M1FPUlUyTUdkcnhqcjd4dkYz?=
 =?utf-8?B?NENVWW0zeDhna1RFTzhsWjRaeTE4anlvZFVLblUrbW94WURZeHlvYzY3SnVl?=
 =?utf-8?B?TWwwdDh2UnFHRTV3RkJxVnk1Zmd5TXpueGNIbVlnWGJQTWdRai9WbHFQRzA1?=
 =?utf-8?B?RjA5ZEZsZHUwN05IbGJoRHREc3RvRDJGc3B1ZzhWbFhRS28zTEwyK3NGMzIw?=
 =?utf-8?B?VHdRUzVIS3RRT1pUNGEwU2djenRHRU5NQVJFSDN5d1ZLcVJUdE52SGRpcmln?=
 =?utf-8?B?bzVpa3I0U0d4ekR0a2ZTZW83T25rNHJNR3VxTGRPUmozczhMVGg0amhueTRi?=
 =?utf-8?B?d3JueHVrbVJRNUE4SzB6Si9Ca2lMUFdXQjM0b2E5VkxMSXhFSCt1QktBQjc0?=
 =?utf-8?B?em5IOFJRN2xSVVo4UGQ0ZDc3b1NQUHFhZ3VLRUQwMzUxRDdzaXN3em1UWGdM?=
 =?utf-8?B?SXFpbkc1TjcrdkorMXpJb0ExN0Fwb0tVYVRPZEkvTnBoL1FEb09DNXJBYzNM?=
 =?utf-8?B?Q1BSaFV2aHppMEpkUlhGbEZXWU1FNG1jWTB1c3ZJaHFCNEpFZkFXdVJ0c0Zh?=
 =?utf-8?B?QjRvcDB5UmZxamcxeUlpVnVRYmQ1Y0hUSS9yL0w3Tm5IMjYwS3pBUzBib2hu?=
 =?utf-8?Q?tHzO0O98jFV0OHJYtAKEBiWrX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08f3db9-069a-43da-96e7-08dda2b2595b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 15:21:44.5146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k04WNlOiXMovr2SlZGLmgwBTmsB0h3aX3mUsFZjU7nIBb3x3bokFtRFKfg5r/jwB+a30kcu5TPa3B21l87WbJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8978

On 5/19/25 18:56, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> The FEATURE_INFO command provides host and guests a programmatic means

s/provides host and guests/provides hypervisors/

> to learn about the supported features of the currently loaded firmware.
> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
> Instead of using the CPUID instruction to retrieve Fn8000_0024,
> software can use FEATURE_INFO.
> 
> The hypervisor may provide Fn8000_0024 values to the guest via the CPUID
> page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
> the hypervisor can filter Fn8000_0024. The firmware will examine
> Fn8000_0024 and apply its CPUID policy.

This paragraph has nothing to do with this patch, please remove it.

> 
> Switch to using SNP platform status instead of SEV platform status if
> SNP is enabled and cache SNP platform status and feature information
> from CPUID 0x8000_0024, sub-function 0, in the sev_device structure.

Since the SEV platform status and SNP platform status differ, I think this
patch should be split into two separate patches.

The first first patch would cache the current SEV platform status return
structure and eliminate the separate state field (as state is unique
between SEV and SNP). The api_major/api_minor/build can probably remain,
since the same value *should* be reported for both SNP and SEV platform
status command.

The second patch would cache the SNP platform status and feature info
data, with this status data being used for the api_major/api_minor/build.

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 81 ++++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |  3 ++
>  include/linux/psp-sev.h      | 29 +++++++++++++
>  3 files changed, 113 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 3451bada884e..b642f1183b8b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_GUEST_REQUEST:		return sizeof(struct sev_data_snp_guest_request);
>  	case SEV_CMD_SNP_CONFIG:		return sizeof(struct sev_user_data_snp_config);
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
> +	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	default:				return 0;
>  	}
>  
> @@ -1073,6 +1074,69 @@ static void snp_set_hsave_pa(void *arg)
>  	wrmsrq(MSR_VM_HSAVE_PA, 0);
>  }
>  
> +static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
> +{
> +	struct sev_data_snp_feature_info snp_feat_info;
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct snp_feature_info *feat_info;
> +	struct sev_data_snp_addr buf;
> +	struct page *page;
> +	int rc;
> +
> +	/*
> +	 * The output buffer must be firmware page if SEV-SNP is
> +	 * initialized.
> +	 */

This comment should be expanded and say that this function is intended to
be called when SNP is not initialized or you make this work for both
situations.

> +	if (sev->snp_initialized)
> +		return -EINVAL;
> +
> +	buf.address = __psp_pa(&sev->snp_plat_status);
> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
> +

Remove blank line.

> +	if (rc) {
> +		dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
> +			rc, *error);
> +		return rc;
> +	}
> +
> +	status->api_major = sev->snp_plat_status.api_major;
> +	status->api_minor = sev->snp_plat_status.api_minor;
> +	status->build = sev->snp_plat_status.build_id;
> +	status->state = sev->snp_plat_status.state;

This may need to be moved based on how the patches lay out.

> +
> +	/*
> +	 * Do feature discovery of the currently loaded firmware,
> +	 * and cache feature information from CPUID 0x8000_0024,
> +	 * sub-function 0.
> +	 */
> +	if (sev->snp_plat_status.feature_info) {
> +		/*
> +		 * Use dynamically allocated structure for the SNP_FEATURE_INFO
> +		 * command to handle any alignment and page boundary check
> +		 * requirements.
> +		 */
> +		page = alloc_page(GFP_KERNEL);
> +		if (!page)
> +			return -ENOMEM;

Add a blank line.

> +		feat_info = page_address(page);
> +		snp_feat_info.length = sizeof(snp_feat_info);
> +		snp_feat_info.ecx_in = 0;
> +		snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
> +
> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
> +

Remove blank line.

> +		if (!rc)
> +			sev->feat_info = *feat_info;
> +		else
> +			dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
> +				rc, *error);
> +
> +		__free_page(page);
> +	}
> +
> +	return rc;
> +}
> +
>  static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  {
>  	struct sev_data_range_list *range_list = arg;
> @@ -1597,6 +1661,23 @@ static int sev_get_api_version(void)
>  	struct sev_user_data_status status;
>  	int error = 0, ret;
>  
> +	/*
> +	 * Use SNP platform status if SNP is enabled and cache
> +	 * SNP platform status and SNP feature information.
> +	 */
> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
> +		ret = snp_get_platform_data(&status, &error);
> +		if (ret) {
> +			dev_err(sev->dev,
> +				"SEV-SNP: failed to get status. Error: %#x\n", error);
> +			return 1;
> +		}
> +	}
> +
> +	/*
> +	 * Fallback to SEV platform status if SNP is not enabled
> +	 * or SNP platform status fails.
> +	 */

I think this comment is incorrect, aren't you calling this on success of
snp_get_platform_data() and returning on error?

You want both platform status outputs cached. So the above behavior is
correct, I believe, that we error out on SNP platform status failure.

Thanks,
Tom

>  	ret = sev_platform_status(&status, &error);
>  	if (ret) {
>  		dev_err(sev->dev,
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a..1c1a51e52d2b 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -57,6 +57,9 @@ struct sev_device {
>  	bool cmd_buf_backup_active;
>  
>  	bool snp_initialized;
> +
> +	struct sev_user_data_snp_status snp_plat_status;
> +	struct snp_feature_info feat_info;
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 0b3a36bdaa90..0149d4a6aceb 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -107,6 +107,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>  	SEV_CMD_SNP_COMMIT		= 0x0CB,
>  	SEV_CMD_SNP_VLEK_LOAD		= 0x0CD,
> +	SEV_CMD_SNP_FEATURE_INFO	= 0x0CE,
>  
>  	SEV_CMD_MAX,
>  };
> @@ -812,6 +813,34 @@ struct sev_data_snp_commit {
>  	u32 len;
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
> + *
> + * @length: len of the command buffer read by the PSP
> + * @ecx_in: subfunction index
> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
> + */
> +struct sev_data_snp_feature_info {
> +	u32 length;
> +	u32 ecx_in;
> +	u64 feature_info_paddr;
> +} __packed;
> +
> +/**
> + * struct feature_info - FEATURE_INFO structure
> + *
> + * @eax: output of SNP_FEATURE_INFO command
> + * @ebx: output of SNP_FEATURE_INFO command
> + * @ecx: output of SNP_FEATURE_INFO command
> + * #edx: output of SNP_FEATURE_INFO command
> + */
> +struct snp_feature_info {
> +	u32 eax;
> +	u32 ebx;
> +	u32 ecx;
> +	u32 edx;
> +} __packed;
> +
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
>  /**

