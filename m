Return-Path: <kvm+bounces-16994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18A4C8BFBDB
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 13:21:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 840181F22930
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 11:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4B782897;
	Wed,  8 May 2024 11:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Hbxv+Jv5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90958288C;
	Wed,  8 May 2024 11:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715167267; cv=fail; b=suBgesYHQrQaLvvXhfZ1lWS4ulVHgcyru1JEuB6P9B91MTn2XH/9LOtCMdMK0j7C13XOJC8bBf4Y3jiINRQZUlJFESeblU/B79xN2z1tsEQ+7ihbUCPLMhgeKJPWrB1l9VuwXK94EQUu5scFPfDfSfHOo4NqnEGrB1Kh/C7b5rw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715167267; c=relaxed/simple;
	bh=TL420BMJZ2zQfoZ8HOZPhTAUrEUTwdLFAMDpAH26BRE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tZA9Y4acPdCJIVVD8YinnDA6/G7hb+XvrqrZaKRlroHrAsYmbxNy9wjPNszzMCYit4aHcKGx+4syNc/WtTP9NpVzrhL5YOLokpDZkOkhcM/z63by9BAb5WMQhHhbVOqCBrqmSCUtHtaSge12LIBD/AOSixyjKHx6jgIiPS67Tt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Hbxv+Jv5; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7xLQcEnoCSb++PkR6NhWyqr2HYpAR7eVuofbKnyY8rY8aBP0sDIGD0QSGp8jQE7yXR+uAW/AaGbIxq39Yuvp7qGcmBctQmPQrrjnJ2HTrJHdAKeDbjAHtgBuu3Pu66TMdaxHB/WiqKOyPOplVFFc29l4Y6oWaAqFGPJIuk6Jt8J7dniZ5DXDSLiY+Glnxpo26nOuTYO+QvuiwFZ6uAh5/mWEHJYgW54B3G66MPEE7cARqmUjXO/dVulN/CEx1b+JejHOn5rZWDxBh4V7YdLGE61FK+i3Zwc0a0Epem9iwW0B6iHqYzGNgjtDOB6/i8pBFAe3W7ZFfglqJgOLZ7Nhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N1zlAdEao37cTUHiDl2/x0Ii7FMjEKFvNWSih3tJ97g=;
 b=OpwMgeOtfZ7wPWOTdkZW4qLzmWsHOzYMGdri3Hnphf3Ukcf4HgLtvtgzS/+YSImxACGCskY0gIqUtEuRjRvR/aBFqe5QKRiUf4t+UPz2yj/QIwBCwOdrOt6XXi+jRhyyv7ALWt2mKTPAjGeaL7fZw5rKGlkIVAl2lTgyg1IYQaVG8lkPGz1qiumP9Zn4voVvo/se6aiJzdLXxD5GEAmNAUyDpm8vJxHWC+jsfZN8KMTsHLIbzHAWoXciYhi+Par3eijyXEtb82pkg8Zy5a7C8D8/3IXp+GEH6AkdPAfvdKEincDNQL+Fa6A9Am1/klRDERIo8SBr2gKIhKh1hC7Umg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N1zlAdEao37cTUHiDl2/x0Ii7FMjEKFvNWSih3tJ97g=;
 b=Hbxv+Jv5sCT8+p+5NaQd1/agc87y3yv+eDPabkkm/WkkK6FjJ14HVTBhWkwie+o8E9qWdFfq9iz0oklVyu/qUNuhlX7bxudcwk7wYJ/e4uiUkx7r/4ynf6RUBe9o4n2rYLrC7qtxUgOsN4JoF9TQjH7hhFpe9wdLJ0WTihKp/lw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 SN7PR12MB8060.namprd12.prod.outlook.com (2603:10b6:806:343::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Wed, 8 May
 2024 11:21:01 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::af7d:5f4f:2139:ebd1]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::af7d:5f4f:2139:ebd1%4]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 11:21:01 +0000
Message-ID: <b6a30d30-95af-465b-9cc1-867c7bfdc519@amd.com>
Date: Wed, 8 May 2024 16:50:49 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] KVM: x86: Print names of apicv inhibit reasons in
 traces
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org,
 seanjc@google.com
Cc: pbonzini@redhat.com, linux-kernel@vger.kernel.org,
 joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
 suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
References: <20240506225321.3440701-1-alejandro.j.jimenez@oracle.com>
 <20240506225321.3440701-2-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20240506225321.3440701-2-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0167.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::22) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|SN7PR12MB8060:EE_
X-MS-Office365-Filtering-Correlation-Id: 342df1a6-6639-4bf0-b88c-08dc6f50f0a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UnJmbGxvakVCWElSdE41NEQ4b3VPcXM0QXZPc2RYN2VKNXJrdCszMVVtYWJl?=
 =?utf-8?B?YlFvcUx0cjlDZ1pBL24wdUtrbTZ5UFQwS0lXdW1lTnpEU1ZlaG1ndEtiaUl2?=
 =?utf-8?B?clluZHY4VlZDZjg1WU1mMGNrdFJ0RXhOV2dEVEpOU0Q5RnVCMTdCM1F6Z3ZE?=
 =?utf-8?B?bVdQTzRKeXZjR2xocDZKbEE4UTcwSDBKRXpkQ1RCMjlYeWZPVy9Dd1VZN1pk?=
 =?utf-8?B?N2krY0lrL3k1MzRQK3p4ZUNOZGFwaERJMEh2cEYvOWNDMFRDTjdEL2k1aDR2?=
 =?utf-8?B?S1hIVEt3Mzk5NC9OTkJ2VFpxQmFNdFEzMEd4NlZnTWFaNko0MVBsdWJEYm5K?=
 =?utf-8?B?Szdpb3FUWmRoMmo0OTBOYWRvckpLNHptOStGUStFVkFKaVJCMG9KKzh1Y1pZ?=
 =?utf-8?B?V1hFOUJxUDRsVFk4YlJpdTkyVWxGR3V0cnFSK01HMXdsL0xRRHBMQ0RJNzlp?=
 =?utf-8?B?eWhxQklKc0lYZUwrNW03WHIvNFhGdE9wbTZmaVVzUFFHam95dkdBY1lXMCtU?=
 =?utf-8?B?azBWUlpvaHc2bXc4eXhqK1Y2LzFFTytBUHQxWncxTFF3SXdMWkp2TXZ1N0xI?=
 =?utf-8?B?NUFDKzNZUHlJbW40bW5zT2E2a1pBNUtTZUxQUjNLZytlQW1sdktWYWdrTE1C?=
 =?utf-8?B?V3JDL3BKNDFsY1Zsd0ZoQm9ObU4vcGlxc0ltWnhucm9xMytHOXZnQm1DeGhl?=
 =?utf-8?B?Sy9oOEVmemprbllxK0Y5cllzclQxQkxDS25xWnpuTnhIWFYwdldXUlVyay9F?=
 =?utf-8?B?aTJSeHR4MUtBSG4zZFNtQTYxNXE0NXZhdGJyQVRrMW1HTDNWUDBIR2VhWXIr?=
 =?utf-8?B?d2pSa0s0bzN2dUxlU05sTktIYnZGZTlKcjJTa2RlNW9Sd040Y3dDOG05RzEy?=
 =?utf-8?B?bngzaFpGZGwwdVI5eGsrKzY2dytWR2Mrd1hYTXBsSmhUdUtxNFBaU1F2Nm14?=
 =?utf-8?B?M0U3NVJpRUxXZ2NFNGt6SEhzTnJ0eGNWUmsweGtHR1NFT1hjK3BpZ3cwVUNU?=
 =?utf-8?B?c0dPODRtL2hsWHY1OUxGcHZGQVREcjNIUzlTVFU2cWoxSHpZSnVSUUVoMUls?=
 =?utf-8?B?Yk1SS1JhbFBBTmlzdERwQ2p5MXZyWnBiVjBKV0YyeHhXcDQ0L3BaREZJT3Rp?=
 =?utf-8?B?TFMvRUo4c1k5VnhBU0hSTjY4emJsT3R6QldhTHVBM3Q5UEFoVDVhZGlqemsv?=
 =?utf-8?B?UTh6WjlKQnQ1eUhGSi9rZldmQUdaNGVPUStnRVN3ck1EUk8wVjloQ2lzZ1lP?=
 =?utf-8?B?ckE0UjA5MERmcnJudVIrY1BhbStnajV2d3o2ZFBaTkJ4YVMwWHYySGtnT3FX?=
 =?utf-8?B?bDNiUmtDWkR0WGw4b0VzRFZQUFNtQURVTHA3dElSMWVjd0Nvb0YrQjRjdUpI?=
 =?utf-8?B?VERFc1VDRWQ3OEcwa21BUXhnS3NHT0czWm16b25nYXJGV05adTNLbVpYQmdP?=
 =?utf-8?B?K0U3cGlVSXJXSnlLWDdRQTdFU0VibVJKU1N5eUprSzVVWFhIbm9CVXlrZWln?=
 =?utf-8?B?d2RjNUJlNWF3cHZSZjFKeFZZNjB2SXN3Y0tPZFZ2eDhqTW04akxCWElKVThp?=
 =?utf-8?B?dkQ0cDFmVDBST2lKVVpQUDBtMXZ0K1dsdWRqYllxKzdLN0F0eFJOR2RBUGFw?=
 =?utf-8?B?OUp2MGxtRWlENEwrTnJrYUhiUHIvaWlSVXNWN3gyTTFKZC9rQUx1MjM2ZzZP?=
 =?utf-8?B?RXZvT3FCbmZ1cUhSeGpyOHAvSjdQOS9UWFo3N3d1azFSWTRHaGJCMW1RPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjlnZzJkbCtkUFhCbE0xUE45STZlOS9BNnRPbDNpQXdyZjBxZ3ViTjJGT2NL?=
 =?utf-8?B?Y1E3RElMekgweWNMcFFLV2dNdll3WnZnZnNIaW9SWndVYWRUN2p4VVg2WmNt?=
 =?utf-8?B?bjQ4b1hiRWlBTm5SQU92U3o5T3BYVEdQdEdYbHRmSXlvUzZjODNGVktJK0sw?=
 =?utf-8?B?ZnhEWm05VWpYRmZRd01IZ25RWmFqajhUWFFHVmJlRCszZCt0UkFJY01uVlo0?=
 =?utf-8?B?bkhVWlZkNVZUWW5iN0NZZVkreG5oUW91czhnQ3BnQWE0WTVLUTBmZDJMUjN2?=
 =?utf-8?B?cFM0RWpJK29YZXNzVjBpcm80bTBxWXpoRGtBTUFFZEl6YWNtQ3ViV0JPd0Rz?=
 =?utf-8?B?bEE3VS8reG1rNEVmWUw2cGZLM0w3RXcvcTZOTU42eHZmNlhubzVOVS9md0VW?=
 =?utf-8?B?cGJxbFV6aDhsUWJlUkdGK2YzNzVyTS9seFFnKys5b3ZiNit2V1dXWUZvWUdr?=
 =?utf-8?B?dGJoMU5xSkFxMHFmOTlVSmJiN0lXVFBQVzM2UnJnMEtPNE00QktoZ1V0Yld3?=
 =?utf-8?B?cVd0MVJYc01DZGRVbDhwdGFWQkZ6UXFQblhlZitIa2ZTYTNmeFN2MnFhaW1R?=
 =?utf-8?B?OVl2aXM5VFNVa0p4QTZpL01JTCtjMTY3ZmdVaUpWdE5WWG1kYk5vSlVQTFFW?=
 =?utf-8?B?Y1dYbVFhVUs0MVhJa2dFdkh0OTBuNUxhbHZPZExlN0l6RmtQWWtiZkRtRnli?=
 =?utf-8?B?R0o3RC92MWU3WUR0b25tbWVSb1daSXZyM3UyaWhZckVuZkl4VStiNCtrdXZm?=
 =?utf-8?B?NnNNS1A1dStXWE9RVklEOERpdGlKTjArQVZpcm5TcE5XWi9HUGFmQWlzd29i?=
 =?utf-8?B?Mmd2TTVVZ09CZjc5THpxb1htUmdMdmhoeVFvUjU2ZVpCMlBpZitBdUF1RFhu?=
 =?utf-8?B?ci9UVmtzQnRWeXRDYTBTSzRhOEJSc1BEbU1sS2NORFh1VWwwSk9zZlA0VXdG?=
 =?utf-8?B?RmtuVnF3QzduWFlXdDk3TE8vcU1td09QRUJQTVVlMUliNWdxZ3VONEtzSmxS?=
 =?utf-8?B?SXNoSkZGd1IzMHdFK1hJYWtpRGJTams3cVVvS25oemp4ZTJ0eDVqMDB1SmxI?=
 =?utf-8?B?WjB4WjRwWFJRQWg1UnUyUTNqMFR0dzVjNlJwZnhvWDB4SVF3WXVWTjZ1RnEv?=
 =?utf-8?B?T2ZtdWl0ZElBTnhCUng1blNNZ3M3R3FJYmNzRmRBcHBDWXk2YUV2dmRPdEVC?=
 =?utf-8?B?NnpUZGxCaHl4ZjZWSGdYZW92N2ZCOUExTXp3Y1BoWnhqYmFzOHZ3c2x3TklK?=
 =?utf-8?B?VHJ1SUZaOGc1dVlJNzk1VC9hMXhtRVd6b3ZieUhrMzkybnRHNVZWM0Jhb05m?=
 =?utf-8?B?emZkRnlTWUhXTEVHaUJCQ0paM0hRc2hzOHBUU25oS0pSc2pGSnFhazNpZ0tG?=
 =?utf-8?B?TzdPbWdkZEZ4MXV2RXd6WXV4SElnNGxKOTZ5dXR0M0U0Y0c2Y0ZQaSt3TDF1?=
 =?utf-8?B?MTFLbStDMVlON1RzMGl1NG9Nek1YRFA2OE1WenNTbGFJL3p0aTkrMUpJeHBs?=
 =?utf-8?B?VXJKUzMvSkpVNStVTDFqWTRlZHZQdzdMTXBZVDQ5clQ0SkVYRStLNlNLeDVa?=
 =?utf-8?B?L1A1d2pQazF1MGVnMlNMaVkrZ3Rid1NiVk5SYXRDQnN3Yml4WUszcS9VUjJK?=
 =?utf-8?B?QjArTXFZOXN0T1lYSmNvZ2I4elFRUkFxdUhJZHc0RWhBazVyUGNmOVovYzlW?=
 =?utf-8?B?TmtXTGUvR2c4R1NQMW5LM1R4b2t4K1RUUmc4QSszRjY1bmxIMHVQR0FCeFpO?=
 =?utf-8?B?eVJXTWdGSzlVLzE4RU5NOE95NWdoeEJ1cXl4MDlIS1FEazlkSUVxaS83cG45?=
 =?utf-8?B?MzNvdUx4anlsa3dpV25aai80SXU5czZpdTRENFpyVVF2S21sT0FFaEdaOUZn?=
 =?utf-8?B?Wk1mVC9PMXNWZmFFekJNQjBobmc2am00ZTkwcFRvOXBuVGoxVlZqUTlaUytD?=
 =?utf-8?B?dlZXMmxHVi9sK21UMkJQU3NCVDRZSDFpaDRtNDJQQXBUWldtNFBNMHE5VHhw?=
 =?utf-8?B?ZFJzbEFBSUFKSE1peUVUUkJlQmQzSjJwL0IvNENDZTlTMDZFQVA4L2g2NzJG?=
 =?utf-8?B?ZkF2S2RHTmFsNGljRGYzaURGemtRQlZTQ1JJUlc4NGVnYm5IbTdPY2R2MEx3?=
 =?utf-8?Q?nasqppjeL5cIi8ZLvugreubcF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342df1a6-6639-4bf0-b88c-08dc6f50f0a3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 11:21:00.8895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fzw2eozedeGG4QdDnTel/qrRqYb0JL0q3lFUqghovrqpaTQg0Wd74Tb1DGobGr8zfCyRTNLvhZOGZlSUcD6I4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8060



On 5/7/2024 4:23 AM, Alejandro Jimenez wrote:
> Use the tracing infrastructure helper __print_flags() for printing flag
> bitfields, to enhance the trace output by displaying a string describing
> each of the inhibit reasons set.
> 
> The kvm_apicv_inhibit_changed tracepoint currently shows the raw bitmap
> value, requiring the user to consult the source file where the inhibit
> reasons are defined to decode the trace output.
> 
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

Looks good to me.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant

> ---
>  arch/x86/include/asm/kvm_host.h | 19 +++++++++++++++++++
>  arch/x86/kvm/trace.h            |  9 +++++++--
>  arch/x86/kvm/x86.c              |  4 ++++
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1d13e3cd1dc5..08f83efd12ff 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1273,8 +1273,27 @@ enum kvm_apicv_inhibit {
>  	 * mapping between logical ID and vCPU.
>  	 */
>  	APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED,
> +
> +	NR_APICV_INHIBIT_REASONS,
>  };
>  
> +#define __APICV_INHIBIT_REASON(reason)			\
> +	{ BIT(APICV_INHIBIT_REASON_##reason), #reason }
> +
> +#define APICV_INHIBIT_REASONS				\
> +	__APICV_INHIBIT_REASON(DISABLE),		\
> +	__APICV_INHIBIT_REASON(HYPERV),			\
> +	__APICV_INHIBIT_REASON(ABSENT),			\
> +	__APICV_INHIBIT_REASON(BLOCKIRQ),		\
> +	__APICV_INHIBIT_REASON(PHYSICAL_ID_ALIASED),	\
> +	__APICV_INHIBIT_REASON(APIC_ID_MODIFIED),	\
> +	__APICV_INHIBIT_REASON(APIC_BASE_MODIFIED),	\
> +	__APICV_INHIBIT_REASON(NESTED),			\
> +	__APICV_INHIBIT_REASON(IRQWIN),			\
> +	__APICV_INHIBIT_REASON(PIT_REINJ),		\
> +	__APICV_INHIBIT_REASON(SEV),			\
> +	__APICV_INHIBIT_REASON(LOGICAL_ID_ALIASED)
> +
>  struct kvm_arch {
>  	unsigned long n_used_mmu_pages;
>  	unsigned long n_requested_mmu_pages;
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 9d0b02ef307e..f23fb9a6776e 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1375,6 +1375,10 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
>  		  __entry->vcpu_id, __entry->timer_index)
>  );
>  
> +#define kvm_print_apicv_inhibit_reasons(inhibits)	\
> +	(inhibits), (inhibits) ? " " : "",		\
> +	(inhibits) ? __print_flags(inhibits, "|", APICV_INHIBIT_REASONS) : ""
> +
>  TRACE_EVENT(kvm_apicv_inhibit_changed,
>  	    TP_PROTO(int reason, bool set, unsigned long inhibits),
>  	    TP_ARGS(reason, set, inhibits),
> @@ -1391,9 +1395,10 @@ TRACE_EVENT(kvm_apicv_inhibit_changed,
>  		__entry->inhibits = inhibits;
>  	),
>  
> -	TP_printk("%s reason=%u, inhibits=0x%lx",
> +	TP_printk("%s reason=%u, inhibits=0x%lx%s%s",
>  		  __entry->set ? "set" : "cleared",
> -		  __entry->reason, __entry->inhibits)
> +		  __entry->reason,
> +		  kvm_print_apicv_inhibit_reasons(__entry->inhibits))
>  );
>  
>  TRACE_EVENT(kvm_apicv_accept_irq,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b389129d59a9..597ff748f955 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10011,6 +10011,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_apicv_activated);
>  static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
>  				       enum kvm_apicv_inhibit reason, bool set)
>  {
> +	const struct trace_print_flags apicv_inhibits[] = { APICV_INHIBIT_REASONS };
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(apicv_inhibits) != NR_APICV_INHIBIT_REASONS);
> +
>  	if (set)
>  		__set_bit(reason, inhibits);
>  	else

