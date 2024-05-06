Return-Path: <kvm+bounces-16733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA258BD217
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:05:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A53951C221D0
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86099155A52;
	Mon,  6 May 2024 16:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Qp/WUtkN"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FE81DFE1;
	Mon,  6 May 2024 16:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715011526; cv=fail; b=efv2/2mZ4dUrkJFzQ0pfkyWS+YIhDENQSrYX74712ZEMpJpbdySbJwfarFQ5jzMxTzaY6neEGqRz4EUVxkVk4d4VCAOVl4tEMBkNHQ2jk5jgLFoxDiQulum/NYrLLYpr1lffU1umPxBmnaj/Wr9rKKKsOEU9qaT0mYGycTnp3to=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715011526; c=relaxed/simple;
	bh=sCgLlWsYLxaB/tvVVpZMX5FMWRpcl7X/kd95d1xHSGE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=W3+sys8qSM3pxiigEGdHbLpXdZ0/Z/dLZn4/qspwcT0MbVN/lcgYRMfpcTOwpjrsczhfgBdaCMN9zx4v1ewFeu2su1AkTRkd5CDDlnumbpieDJf5zhyVY7IuBQlAh5S0aL9yK4yAzdKJ3JRe44/FW7A9ice9glCaphjYOZfID00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Qp/WUtkN; arc=fail smtp.client-ip=40.107.95.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VURg9I6NZhi9n9zbJr4QkjECpfWBZ+hzH+cKQgpmpn0ByBmk7YzDdcrbPGpiTJlwL4Dh4huzQ/AdYF/riVOf5roBELJKVxO8N4roj43G14yv25ZV7DjEXYNdtQ2ikIot5Gt6NfMJVwMFOGU2E6JLOhBk71RtI+plXPVwMJCqzA6n1I1RDc40rLKrSoRrwHtXFfya8YRgizLrqlS2+2ld5RHzuWcWw24StVu3UNcFkyQETMjhmKd7o8pXxhD9mhXW8Ca++tMjvHNxdBnUszgJsL9Sw2bm5DAJ4h3bqRx2HQaze7e9eKtOz0wnCyWl/LdN0EUpajMli71rnjTE/HPyfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+sGLP4U+qB3XQCBV5sESJSwe+gOoT/FGYzgzn4DzYw=;
 b=SyDN3lxiPXW+IkMAV2eTEfslai8BEuLVZQIgiR/5emfiYjp4t4KV2rh7/ObCXAZQY+Ef6yZqRJu4Eq0mgU4Zts5EFadXcjCCscR4CmisMdniSfZ0tJTyxZ35a7Vb5MQydZFqYvyXMoSgA230B3RWShNugYn0kS5DbB7mr5z0jj/CTBywCWrVMxWOlBMKoGBhtPwviwBvHQEogFRplFle6eDb4XUhmPntD6akwBEOMKZJ9awhQrOyJfpL/8/adF6eLUtvWHfTxHZwx0Qbwg2xYxc2AclBVuRhlk94XTzd54CDAx4Y9KqEw4u6Je7LNZyG1uptplrfmExhX/40qkHTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+sGLP4U+qB3XQCBV5sESJSwe+gOoT/FGYzgzn4DzYw=;
 b=Qp/WUtkNRa6O8mVMz7+T22HLvCMbOAU0BXqZzqUsntWlUTTLJ5DC/DCd/Hb51JkhDvbuw26DF2zhwJ/ghcLqRhWzKzE00KQVP0zyN4NgU/wTOOowIvusuYVNmLhQCQF/iebECM8fvP6BUtOJEJdSC/mAsUCWYJym8t16uFzH5UA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Mon, 6 May
 2024 16:05:21 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 16:05:21 +0000
Message-ID: <bb6a554f-4823-59ce-16a4-48bd5b911d63@amd.com>
Date: Mon, 6 May 2024 11:05:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Ravi Bangoria <ravi.bangoria@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com
Cc: hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com
References: <20240429060643.211-1-ravi.bangoria@amd.com>
 <20240429060643.211-3-ravi.bangoria@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 2/3] x86/bus_lock: Add support for AMD
In-Reply-To: <20240429060643.211-3-ravi.bangoria@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR07CA0016.namprd07.prod.outlook.com
 (2603:10b6:5:3af::18) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SA0PR12MB4447:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e508524-5318-491d-1eb5-08dc6de65495
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vmt0bXFlMjQzNm1Ba2tFNEJXbk9SbVlYZTRnRGU5UlBQaEwxdU85SnNXT0U0?=
 =?utf-8?B?OE5QamIwSDJtSmx0TTZnY1pzVllKT2Zlb1ZxbnFUb2pHdUxmK2FBMWpvV3lU?=
 =?utf-8?B?Z3ovdm5QWHVmbzN2MFNmLzhYb2dRckc4U1lNZEY4Qk5FRDRUaHh2ZmFMcFNE?=
 =?utf-8?B?empaUHp0cHlnblY1L2ZRYWExNWFFU0JoYUFWMElrVW5ST0ZtWGd6NXRHWVhC?=
 =?utf-8?B?TmkxdWtVL3FQT25SWURWbnlXZHhkMXBaRnpnM3Jac21VZk14NDdhQnpGQ3d3?=
 =?utf-8?B?TWFmUWMwZmkvdDNGKzIxT205bEU1VGpWand2L2lrWXliNWJleUtyOXZCcjVR?=
 =?utf-8?B?cXpjWVU0VVB2Q3pndElLcW5TTitGS2lhcmY4SFd4QVRZZUZ5TWtWeEdKUkNJ?=
 =?utf-8?B?Mm5TUW8ybnRndGZicEtqczJyUmNIbVJxeWRIYWJqMXc4K1FhVkZvdFlGbWhH?=
 =?utf-8?B?TDlpNFdRU2kyV1FaTkpHTlJkelNlcnczOHppRzZ6ZG5jN2RCRkc2SEIwR2lO?=
 =?utf-8?B?R3lnQVhIdFNoUDhZUkJwUFJSNzBZNVdlYUhwd2xXbEsvSGF2ZDUvR20xZWlO?=
 =?utf-8?B?QmdCby81blZEMGxwcldRSHIwbFdDZTlOU05IUmxHQmpxT1BsaFVpN2ZaTnc3?=
 =?utf-8?B?REQ1ZUJTZ2ZrcEMvTnFsYmIzWXU2NFJIM01DSVVzNjV6bXlROGxBMGRLM1VJ?=
 =?utf-8?B?QTRLcTh2TDhaUlpWRVNKVnlGWktjaTFhclF5SEo3eWRUZklOM3E4STk3MjBs?=
 =?utf-8?B?SDRKd0tpek1Da0N5WThxVytUcFRMMktkdkxjL0ZSK09WTmE1dGozcURrTWpi?=
 =?utf-8?B?M05UNkJtUjI2ekFWcFJkSkc4Q0RCMGZTcEZZRHd0UFdMMlVGTmF3QWZmYVB5?=
 =?utf-8?B?aTJMUjVSdVRxMkF2Zlg0Y3hadXdZMG1ZeDFncFZtdGZha0JiOUFEYjV5TVJq?=
 =?utf-8?B?LzVDNi9zamk3TTB2S0R4S2tHU2ZkWmo5Slg5bThwem5pUDlPZEJ3TzBPS3RN?=
 =?utf-8?B?OHRRRTRRNEc4ZjRaQklYN1BOSDRZOEZ3UzRmTmlaK3k1YW0wVXJySytDakJn?=
 =?utf-8?B?eHhyOEl5M1hpRjl1RmVkUGdydnAwdnd6alFRVWM5QS9ndVVJU09MYXdqY3V5?=
 =?utf-8?B?QkhSdXR1OTEzOE9xdEdmY21TSVlKQUJkYlhTQTZKYWhKUUxKcWRaNEcrN0h3?=
 =?utf-8?B?WlhHcWZWTHVxWkpTTGpZaU5URVZtWFZ0ZzFsZkprcVdRWVVIL2VUL1VQU3ZW?=
 =?utf-8?B?djJMMHpzYUF0WXZXcmhuSEtXTkw1eEtWMFJGV1MrTzdwNUozbkoyajVrQ1lT?=
 =?utf-8?B?Tm0ycGY2cWMvM0k1dUhjUUN3YlcxYjJOb1haczBzbUEwTkZReDk2YVNiWGhX?=
 =?utf-8?B?akRCWGUrbWlFRU12YmF5U0M1THJUbGJIRGtYY1RweXhEZUcxbi8zSFZ5Z1VX?=
 =?utf-8?B?UlRIU2JGVWMxaE1NNFJvWWJwcU1JTHN5TTFobW16aUEvdi9BTFJ5bmt4Qjlv?=
 =?utf-8?B?dERyV1BWSXBOd2J1a0lvcThCL2Zxcjc3UWljK1UvMTFjajVjSVc5ZGZkME1L?=
 =?utf-8?B?UE9QQmZJcjZvNDJ6b3hHbmhZZi83ZHFQbUVLY01aZnhYY2lYQkVVbUsyU3Ns?=
 =?utf-8?Q?yR+PbFb6hYDwwggW8HDU7sCkQF4tr1r/MsZTbPwp50WE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M05NS0pqa0JDTmIvM1k0akxMM21MN1ErVEUvYi92NjZEdGdlQnNISENEM2VV?=
 =?utf-8?B?bzd2aDFEQm01RDRHc0VyK2Q4SEN6Y1NCN3lkMGh0YmladFNnWDg0ZDk4SW9G?=
 =?utf-8?B?WGlBNUxFMVk3aWk4a2RncTY1RHlxUHRncnB4dWFjYmNGSXdhY1VkWlJiSENF?=
 =?utf-8?B?NERnK09FLzRnOXBnUHZVY1JoeFRJZ3hUNlcyK0pyTi9Rc0ZYZ1BhUWZhc1pQ?=
 =?utf-8?B?Q2VxRVB5QXNTZXlMOS8wbDh5Z28zSGpUWTZKM0J3MWNYUU04Vjk3R1RWU3Yy?=
 =?utf-8?B?SzdobzFqdjdZQWJIaU1EWWJOVjJ4QjB0ZTY1VU1WQTIwOXJ1cSttOUlFRVBR?=
 =?utf-8?B?bHJ4c1RQcjFDTlIxYzdzeG1hT1d5ZnZ0Y2pNQzczc2VodVo5YjJBOEZSUHZN?=
 =?utf-8?B?Tjh0MVJDVnVCL01GaHc2blQrQ3puSGpuNnlBS3FEQm9aOG1Cb2h0aW5aNFdH?=
 =?utf-8?B?aFFUNFAvZ0swd1RLVmhzQnIwV00wblE2aVR4NVlVTHU5enJ5djdkaEJFQUZM?=
 =?utf-8?B?eHQyM3EvMlloRGU1NmR3M2FELzYwUXU5UkpIRlFSZDFsbFB2STl1dkhOS1VB?=
 =?utf-8?B?bGNJSDA3bGhaT2F5Tm5SQXhOdG1TSEZKVVZ3SGtIanNHY3V5dVhUZDB3TWhi?=
 =?utf-8?B?clpHVlB5NnloN08vUWJLUVhoSE80T0poTEI4Rk9heVMyWGxQSDZ2Y2QzS1BO?=
 =?utf-8?B?SG90dUpJK2d3YkFRTnE4SThSMXo5aTg3QUlUaEdvLzhEKzZOcS9SK2xnK0ts?=
 =?utf-8?B?QzhTT01McENSVEIzLzNxbE0vZ0lIWTUxdlgxMGhlOEV0d3kvZGF1SzIxNW9j?=
 =?utf-8?B?b1VjdEhNRzN2YkpjSXpXY1JDemh2YWJGUm1ZUFNqNGFTRUxTQ3Jia3FkMTlO?=
 =?utf-8?B?a21vcTlHNDVQUyt2UVZvSFNBRDlIY0RBeFRWZ2ExL09pRWRsUTROVG9HVlpy?=
 =?utf-8?B?Nmh0dkFFM0tJUU5UN3NTSk1UZUg2YzlNZE94K0V6ekdVVDBEVW0yUjcycXlR?=
 =?utf-8?B?d3FQcVVGcGJBYkJ3dW9wRFhtalh4em8ybTRaWDNPT0FwL01oZitUdmw1NEFV?=
 =?utf-8?B?Y1VFRzdzemh1M1FRWFhFUkxsUHhuSHYxYng1UFN4b0FWcHVPM1BvbTlmSUxM?=
 =?utf-8?B?cGZYU1Uzci9ocXEwdVBJZFBiR3dKMHppZm8xdklYYVJTQyt0SUIvNUZyZUhn?=
 =?utf-8?B?cnQ2dTR5REExTVBnMWwvMGJZd0h2TTlVSWtIRnVJNGVsanRKTk9XTnBpTmk4?=
 =?utf-8?B?VzRoRCtHOUFZdXVMWC9rSU9idXlUWFZGbWdJUTlKTStvM1didE1Gd3Bub1dY?=
 =?utf-8?B?Tk52b0JyOXRkY1lXN1F6Y1NQbVh6VkdEOFloVFhlTjkwWEErNEZLSytLMFBU?=
 =?utf-8?B?VzZ0MkJoQWVaY3A0N0gzb3dxQ1l3QStSYytieU9lcFR2SWZXV1A0TkN1dEV6?=
 =?utf-8?B?bCtTeHZSYnBtWVBLMm16V0M4WVV1SUcxTS82M3ZSbWFyenF5WUtWSnBlZmtV?=
 =?utf-8?B?MGJ4SUxZVEZrNHdYUEhnRHJUSEpqL3c1cWNIbC9rdlkyL2hyQkdyRXpOQytF?=
 =?utf-8?B?WE9YS2t6Z3ZVY25ZZWJtbG53Wm5LVSthVE5GKzJRYmFCQmVtL2FScSs5bC9T?=
 =?utf-8?B?aWU2S3U2VkkrOGlIWXB5U0Jwa3BNV0VuYkNTL2pHQ0lUcFdzVllSbUlNNHBL?=
 =?utf-8?B?T0o3bGJZYnowTzdJdDdCSE9qeG5EbzNTNVdZUVRMMytnV3MzQXFmOFlXMUVC?=
 =?utf-8?B?Z28wV3NrWmdtOHdQdGZhbU9JcUtCejAzaFJ4ZVlPUTU1UHNrY0l3Q05HQlcr?=
 =?utf-8?B?dTVJWUw4bXVQUFlicEZKUlA3NDlXZTVOT2FxN0xabnp6c2ZRei9jc1dnUUlT?=
 =?utf-8?B?Y29rVWJCVjQ2TkVFVEp0c0dHcGpPekFKZHFzY1lJazI4b3ZzTVNmdmJGbDVu?=
 =?utf-8?B?L1RRNGV4a2hWQS84ckZ1NzlCVUFqMk0xNFRGTHViQ3N2YWIzZHdlbVJXL0ox?=
 =?utf-8?B?TkJKd0RkUlVKd2JxZnhLZWpDdG41aFp3QXF0dlBPdHBrMm5XSytkSkFpeEdh?=
 =?utf-8?B?UktuTHJyeisyYkdrL1doMmxuTWY3bXdlc0Y5cGdEL1A3bmc4V2J5OFNJenky?=
 =?utf-8?Q?xwT8zXV+7jR0Y+WbkuAgJXYy+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e508524-5318-491d-1eb5-08dc6de65495
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2024 16:05:21.0472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LEqtCLFnWwnqbj24x251aJ7KDlEkitg74zRq+9GjQPsnNo9gR891MgQv5znrl9l8v1Ao79BMZ68q+y4W0jREA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4447

On 4/29/24 01:06, Ravi Bangoria wrote:
> Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
> in AMD docs). Add support for the same in Linux. Bus Lock Detect is
> enumerated with cpuid CPUID Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP].
> It can be enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware
> clears DR6[11] and raises a #DB exception on occurrence of Bus Lock if
> CPL > 0. More detail about the feature can be found in AMD APM[1].
> 
> [1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
>       2023, Vol 2, 13.1.3.6 Bus Lock Trap
>       https://bugzilla.kernel.org/attachment.cgi?id=304653
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> ---
>   arch/x86/kernel/cpu/amd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 39f316d50ae4..013d16479a24 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -1058,6 +1058,8 @@ static void init_amd(struct cpuinfo_x86 *c)
>   
>   	/* AMD CPUs don't need fencing after x2APIC/TSC_DEADLINE MSR writes. */
>   	clear_cpu_cap(c, X86_FEATURE_APIC_MSRS_FENCE);
> +
> +	bus_lock_init();

Can this call and the one in the intel.c be moved to common.c?

Thanks,
Tom

>   }
>   
>   #ifdef CONFIG_X86_32

