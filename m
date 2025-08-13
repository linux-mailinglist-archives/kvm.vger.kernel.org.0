Return-Path: <kvm+bounces-54570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD282B2453D
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 11:20:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 13A747B992D
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 09:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A7042F0C7F;
	Wed, 13 Aug 2025 09:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="urJ8vcrx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D1A2F0C6F
	for <kvm@vger.kernel.org>; Wed, 13 Aug 2025 09:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755076746; cv=fail; b=dEJYlNMrukuWNZKQVSH0FMMBaTu+mq/sdxv142/KPKf1y4+b08/xEHgvxPiHBfLEN4I1xetLZMn/Okr46HvsDXE0yOZVjzRzLDEmyQQlCmJ3xawB4DAHScLWdl9reNXBgtoNssKeA2an+xevtr5uTc7xvw+iMPGGIPAlHZET1To=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755076746; c=relaxed/simple;
	bh=hykTu1LvOCJ4Z9wn9A5cGahZu3UkkX9bAO/NnLKiTNQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nkur0gggGw6NAzSNOCkgfQER1aO27FbFjWDsoLdGlAJgUxIiFmnTRYJxrGZ0G7gxM2hqT64iatA4P5HWcAFlr8rPesKtgrsOhRV2Ul4f+C7rcxZcV+6fZYo112UFxRHRAj4FjXqRVcF0+w8cDmJBq3qv4FJYyEwthK0lSnjBT0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=urJ8vcrx; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iTSXf0+Lh+M+e+f+r7P9rW8zoAFQfJjdgcB2btH2KMbGPOBPKTMyTzQt5hflkhRsa8d+9qRa0FLZ4ztapyHQgaDKjh7xR+MS9aC1m9icTquuJq8FyybDdHo8E6hiSoGKP97ZDx1GZMHfgBiwsGHV4rAWe7kF6wnQJbeswLDW4rChatebSSoLFLYibeGJLKVlHOk7Ve2rG8Ms+cTvhf+p7p3v0HU1gVUQ/+xMiJc+Pyl8kVXDQBpGP7fdJwJgIPPBfGImjUH/R7xqMCHNdApmBxcspREupWYe2f0EF0zPZqbBdbm2sZZBpbYu4qwaSFeiUVY+X4NAgjcLbEZgPo2yyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lQ9dzf8rYdUCoX94aGGsbp77KaV73w46ptia5m19/E=;
 b=np8RrBM6VltBlMhaB9LJRO1kR+8GRc48RuogLxoDqosGtgQu1SpYYldy9qjvvnTcDIb92AovSFRs1cYl7ziItQGVTneH4BfcPCivT9JrfF4Fp5h9NmhhrILiE6Z2/q2tlhEtvrljFMjAHjJ9ead5cX+y06C4MWAyg4fXoVS5yNME5DK4wEe4Y3dwDu2+xEmsPUmxwQjwoxUbgdIrY3ratMu/WM89+Yo4yQTmvtZ/QK18w1giIqGvotlBAqXXjjYY+I/DrtyVe063OT+FqcFuhlkJ3Z3JSwNa091uOdPNyZ0vngsoEtpYCP3fSKAre3PsQwZpxNHPfaGLclLvA4+tBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lQ9dzf8rYdUCoX94aGGsbp77KaV73w46ptia5m19/E=;
 b=urJ8vcrx4MVzA0yYPiHfnflmuiUamqiMSlf72VBwu6dwWtQlTbxtWBwy38im7kNOC9Jv2Zqe1YZplnZpU+xteenPUPkgF4mz5u/JGUNGMLBueVDRVI9KgChMRf2Ev98GB6bu0gJ8xqARRuY48sJOpo8q7lzLTkVQmDZ3unfyklc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by BL3PR12MB6474.namprd12.prod.outlook.com (2603:10b6:208:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Wed, 13 Aug
 2025 09:19:00 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.9009.021; Wed, 13 Aug 2025
 09:19:00 +0000
Message-ID: <a51fc2fa-5fc5-4e63-ba53-575ef143d062@amd.com>
Date: Wed, 13 Aug 2025 14:48:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 5/9] target/i386/kvm: rename architectural PMU
 variables
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
 groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
 den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai-oc@zhaoxin.com,
 ewanhai@zhaoxin.com
References: <20250624074421.40429-1-dongli.zhang@oracle.com>
 <20250624074421.40429-6-dongli.zhang@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250624074421.40429-6-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0023.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::36) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|BL3PR12MB6474:EE_
X-MS-Office365-Filtering-Correlation-Id: cc612fae-507d-423f-1ac8-08ddda4a7037
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eXVJdW0vbmhncUhiRjBFUDQyR1o1Yzlwckd5d1NKWnhuL1lNYjlFb0g0b0s1?=
 =?utf-8?B?MzdIS0w2SkdUZXlmZi8yblVzUmRWUWdUYnpNWWpVS1lWQkh2NWJDck5vcU1O?=
 =?utf-8?B?N3R0WmZWV3AyZkFkWUFvQXdENlZzd3NXZm5uWjh4UDFQY05zNDYwUkhRZ1hQ?=
 =?utf-8?B?UmtvaHVQZkJaWVljQ2hPRWtwZGxTMHdIK0xldlNlZjB3dklpbDdUYkE3bzY1?=
 =?utf-8?B?d2tZNEFZc1BCaWhYQWRsZVlpQzVrcjZtSUpSRmluNzlnem1waWNxcHkzSHBV?=
 =?utf-8?B?M1F4MTV5Sk55YTRzNGRmcG00Tk1SeFVUWldYdEx5bytNK3ZtSW4zVkNVWUg3?=
 =?utf-8?B?VVZ1R1NQMDQyRXJucks3alJVa0VyR0h3T1ROYmpCclZBa1RoeDJYYXRxYy9I?=
 =?utf-8?B?MFlRQk5rczI1bElrWTJ5UkR2RURDK0hVYkdvMHE4dGI3Z0lGKy9uZmtZd1Jt?=
 =?utf-8?B?RXhiUDF5N0JiYTg0Zi9DMW1La1lUZ1Jzc3BxdldBMUVqWVNwcnhqajBuQWRl?=
 =?utf-8?B?Z1J1eVBQMEtXT0xwamk3ZWJla3JIcmthaEhqT2dDcTE0VGdydzVMVUc5cTJZ?=
 =?utf-8?B?bmgzdnZZeGR1c2pMTmN5ZHozOXFTVTJHU3NSUEdRanJEeGtwbWxOK205ajA4?=
 =?utf-8?B?OHpHRGNyUGFtYkIyd0ZmZFpIekk0VUVVaGx5Mk5DSzNzeVBMSEp1b1FkQThv?=
 =?utf-8?B?blpMakF6RFh6bS9wWmxEUGdUNjVUVUh6RldXUWdnVDVmd05vNTFCM0MwbWdN?=
 =?utf-8?B?RVkxZjM5VGNYRUw5Y0h6OTU1SUxwV0xMeEgyQ2R1R1JoTDVGZG1wTHZqVkZ2?=
 =?utf-8?B?V0ZFNkpMaVdKTHRweEt2WHZQWE15dVo2cm1uN212SlU5cnd2TTJ1dFdpbkln?=
 =?utf-8?B?NVpNTkhHNDNycUN2a3BFUjQ2VWxxQ3hZazVvQWhkMkNaLzlxT2UyZ1g5WmNp?=
 =?utf-8?B?U0x6ZEtuUUVqemVZbm5NZnFDeTdQdlRCdGVSU25Jb2ZFMldWMExFRERzcDR1?=
 =?utf-8?B?a2FNdE1oamswbHFnQWVTb3ZMNTlmVnZtYVR1VDhuNUlQVk92UDFmUldnOFJP?=
 =?utf-8?B?SjNaOW1uN3VpYUJPcXN3aXZGdzIvNnQwcncvVnJ2K0Yra21MRHN3WVZPUVRq?=
 =?utf-8?B?RW1xMW92SEJ4dkFZbXZoSlBQUERkZ1RWcDFQN2x6MEI3aFdSUjdhdlN4Q0c1?=
 =?utf-8?B?MzU2U2hFQ252SExodGhlZlFxeW4yL2EzcGNRWFVtRFVNNUNMTm5BL1FjZEQx?=
 =?utf-8?B?TC9jcmlYMmJaeCtZbDlaaUtTcWh0MG1ZaVdtT1d5cy9pcWFmRDNVay84ZHRh?=
 =?utf-8?B?bDJxWVQyQVA1bjNRa3ZiNkhHRXhuSmIxMU1tNTRSVnV6cUZPRWc5ZFRpTlMz?=
 =?utf-8?B?QklpcmpPdjVxQmMydDRCRFZBTTVUb3NTOTR2TVdYd0pnOUVWeTRGenYyVVZI?=
 =?utf-8?B?b1VMQmdVanhnWWhKbTc1VHdDWlY2MWMvbHVDMkVudFJPZVNUS1BsRkZSYW40?=
 =?utf-8?B?OHhFRnc4SFU0WFc2SG5sNVJBOTlhRDdmVEdKbWttZzVXbjRHa2lmVDlWRVZa?=
 =?utf-8?B?LzZJNDEwaFV3ZyswZzR0cE56dFhqeU9kWEpoRmxkNE4zUFVPay9nMlBEbnRQ?=
 =?utf-8?B?M29PYU5oR004Y0JGay9RQWNWU3hubjF6bWxtbHltN3o0ZW0yU2QzUVQ5YzlP?=
 =?utf-8?B?UkxuQUVESnZNWXpmOVpyRlFObFArVFdFZnF0cjgzV1p3SVpYa0p1T3pXOEF2?=
 =?utf-8?B?dEFxbWF3WjFLbENxSVUzTFR1Q3BDTGlIZVpQWmIyWHV5eDZuR2JYdlNuaXlt?=
 =?utf-8?B?QXA2Q0V5RHlPcXRNOU1DNjliYndjQkcyZzdsMGVxajhQRVlRczQvanduWlpR?=
 =?utf-8?B?MVRyRFMvOWxDTXJQb01ROGVXS1IyRzk2eXlYcHUwV1gweHVoZW1ZMTVHdGRO?=
 =?utf-8?Q?NMSmDeA8Ljo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzhyYTBEMER2T08zVmQyTHBMNUJHZG1hbmFvSjNuNVBqWHdBbEpVcnhjdWNC?=
 =?utf-8?B?RlhiNnhqbkdzc2hCWnFoaUFwRkJSM3BVNHl4bGpDcWZWV2lRNFBqWnhDZ0tO?=
 =?utf-8?B?SEpQREpLS0FIVVZlRFVkdTNPdTUybGo3bUo3eTY1bUk4Z1RNVXZOb2xOMi80?=
 =?utf-8?B?K0pGTU5pSUVuZ2VVbWZPVkNkeDFURVRyQ21mWlBUdU1GcXdEdFdibERCVkVx?=
 =?utf-8?B?UHFKRnRCVE1uN29INjQvVnZjYStRWWZsMUY5NlFXSVI2QUhMcTJsVUlzSDRv?=
 =?utf-8?B?bGZmdXNic0RwY2pveGpQV0JkcFRtcVo0ZzZUV0gxMXM2R3pmdDY2ekNaVmR2?=
 =?utf-8?B?RkJvWlZFSDBzZ2s4aWJFZU10V09Ic0Fjdjd2MTlnNlhKVTFVYkp4WDJXSjc5?=
 =?utf-8?B?aFlHc3lRZTdFa1ArZkhqeUJBMFoyLzI1VXdVZ0l0Y2NPdWZMUzh4NTFOYlZk?=
 =?utf-8?B?UkRSeFlQOVE4ZWR4dkJ3dHcwNXI4NC9MSTVEeHMrd2psd1Z6a2Z1cDVJY3Rh?=
 =?utf-8?B?OXFqU0kxSVVtMVBQNUlkc3dQWEhBV2VBaE9PUytvUVVBVTJjdEZyajhmUnJs?=
 =?utf-8?B?QUQ3bU9PUVc5ZGp4TjArYlRVZ2JPeFExRWczTW5INUdrRlJhdlhKY043cDVm?=
 =?utf-8?B?MUZiN1NDM0VMcGxpYkZ1Wm1QMmRkaHNncG9JTGlwVk9MTVE2QWlTZ3FydUdq?=
 =?utf-8?B?Wk56b3lxbzA2cnlHV3ZxRDdyOEkwUmd6UmpGOTBkRkg0ZEJaYm9OTXpmeURt?=
 =?utf-8?B?b1I3WkxYK3hjMGo5Um1WVGQzbEZkVk5hM2ZlRG14b256MDBWVVlZaHM2MWt5?=
 =?utf-8?B?NVFEbEhGWlNJV0pYODRWWGc4Mzk0ZEJFbG96L0pPWFR3dkI0MHFTRVJwZnNL?=
 =?utf-8?B?eThtMFR3NGF3Tlh2ZEhieTFaaURZZHBiYVNIQVNpZUR5K1ZqVXFvUFFEUjR2?=
 =?utf-8?B?c3NONkhBd2o1SStuaWVNR1pXSmFBQmVET0ZiQytsWTRrZEJsYW5uYUNBS2FB?=
 =?utf-8?B?Zm9lczIvdEJaRE50VGRtQ1J3T085WVcwdFQwYi91ak1wNEsreUFhYXdyMG8v?=
 =?utf-8?B?VFo4WndYRkFYTnVScm1SbjhHdnViZ1o2cXQwNkdUS0ZFZTZGM1QvOFVlaVlV?=
 =?utf-8?B?R3RCQmFmb2ZoRkFqSm0xRktFd0JRVVMrMTYyaUk4ZFNTLzZ3REVQejh4NVZ1?=
 =?utf-8?B?dmJOK3cxcmhES2cvN3NsRmpJNW5HTTVSN0tzT0hNei9ldjZ5MHRVNHRwMkpZ?=
 =?utf-8?B?VTRjN29FR1J1NFJMWHUzdkNueHZUTnZPQjdhMlZQeGJyV0hqRytab0FsdlRO?=
 =?utf-8?B?VXpJTVNYMUdkSXExQ0hIS3JJVWxXcGF0WHVvRGVVL1Y3YlcveDFMOUJhbEkr?=
 =?utf-8?B?cFg4K0l3RjJZckVBOGJ6RW0wbi9CNmxCR3dyNDR6WFY2d2RORkV4ZEdjWHJt?=
 =?utf-8?B?VHd1RG4yclhXeDVVVWozTnpqVW5wZzVkV3dITSsxaGdkOEtIa2F6c2g5bHdx?=
 =?utf-8?B?Ky9uSVpEdXh6ZWNSSnZmZUJJd1pXdU5lWlp4T2E4Qk91SXJHUmJ1S1h1TFpz?=
 =?utf-8?B?SWxDYTk3QVhUTCt4Zm54Ky85YUIxWmJSWVVTNVVCV3REY3Z2My9iQU1aUFZ2?=
 =?utf-8?B?MXB6c29oTStUSk8yRXFxdU1VZnJ4NFZYR0FRRERiR2lUbXZLV1U0N3VxZld3?=
 =?utf-8?B?SWVsd2lhK1hiY1lreThZWGZ2TXZEOVJsMGMwQWVrQVdnQjFWdmFOTExoYnVK?=
 =?utf-8?B?QndyaFNLc0ZHN29mNnNiZG05N3RHcm56K3lMTVN2MlhMQW9vcWI5SjA0VHk1?=
 =?utf-8?B?MWs3ZVV4OUVQaXZ3RW00L3lEUG5vYnFhRVJudW1YWEQ2Sjl4TXNFOTl4WmJF?=
 =?utf-8?B?cTludG1BVUJRaWREVTJYMmhjdzlrWnppaGJYSW1FN3BZYVh2RVZiQmtZbjZ0?=
 =?utf-8?B?RnVITnpSMVFkcjh5cXdMbWgvbEhFeXR3VGptNUlwWkM4aGxOWjMxNmV1TEtR?=
 =?utf-8?B?ZDIyL1FnZWQxaGZxU0VrODJ2d1ZudjRGUXkxZURRNHRmU0U4cEZJSGowc2xO?=
 =?utf-8?B?VjZoK1ZWeTB3Y053dkhTUWFqTEFZaDlCZUJBRkZucU83M090cWkyNnNTdVRs?=
 =?utf-8?Q?bGK0Y0apyj7zuUIAiCahz2VDO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc612fae-507d-423f-1ac8-08ddda4a7037
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 09:19:00.6500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r8FrfSp8LyPpUJMHMdR8ZdfuBfrRl6vg4rE0HAO37J8PBaJ+qPV2H7vm3ZSP/0H2TK2aK4qrhoIFKJpULL+l4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6474

On 24-06-2025 13:13, Dongli Zhang wrote:
> AMD does not have what is commonly referred to as an architectural PMU.
> Therefore, we need to rename the following variables to be applicable for
> both Intel and AMD:
> 
> - has_architectural_pmu_version
> - num_architectural_pmu_gp_counters
> - num_architectural_pmu_fixed_counters
> 
> For Intel processors, the meaning of pmu_version remains unchanged.
> 
> For AMD processors:
> 
> pmu_version == 1 corresponds to versions before AMD PerfMonV2.
> pmu_version == 2 corresponds to AMD PerfMonV2.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Changed since v2:
>   - Change has_pmu_version to pmu_version.
>   - Add Reviewed-by since the change is minor.
>   - As a reminder, there are some contextual change due to PATCH 05,
>     i.e., c->edx vs. edx.
> 
>  target/i386/kvm/kvm.c | 49 ++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 4baaa069b8..824148688d 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -166,9 +166,16 @@ static bool has_msr_perf_capabs;
>  static bool has_msr_pkrs;
>  static bool has_msr_hwcr;
>  
> -static uint32_t has_architectural_pmu_version;
> -static uint32_t num_architectural_pmu_gp_counters;
> -static uint32_t num_architectural_pmu_fixed_counters;
> +/*
> + * For Intel processors, the meaning is the architectural PMU version
> + * number.
> + *
> + * For AMD processors: 1 corresponds to the prior versions, and 2
> + * corresponds to AMD PerfMonV2.
> + */
> +static uint32_t pmu_version;
> +static uint32_t num_pmu_gp_counters;
> +static uint32_t num_pmu_fixed_counters;
>  
>  static int has_xsave2;
>  static int has_xcrs;
> @@ -2081,24 +2088,24 @@ static void kvm_init_pmu_info(struct kvm_cpuid2 *cpuid)
>          return;
>      }
>  
> -    has_architectural_pmu_version = c->eax & 0xff;
> -    if (has_architectural_pmu_version > 0) {
> -        num_architectural_pmu_gp_counters = (c->eax & 0xff00) >> 8;
> +    pmu_version = c->eax & 0xff;
> +    if (pmu_version > 0) {
> +        num_pmu_gp_counters = (c->eax & 0xff00) >> 8;
>  
>          /*
>           * Shouldn't be more than 32, since that's the number of bits
>           * available in EBX to tell us _which_ counters are available.
>           * Play it safe.
>           */
> -        if (num_architectural_pmu_gp_counters > MAX_GP_COUNTERS) {
> -            num_architectural_pmu_gp_counters = MAX_GP_COUNTERS;
> +        if (num_pmu_gp_counters > MAX_GP_COUNTERS) {
> +            num_pmu_gp_counters = MAX_GP_COUNTERS;
>          }
>  
> -        if (has_architectural_pmu_version > 1) {
> -            num_architectural_pmu_fixed_counters = c->edx & 0x1f;
> +        if (pmu_version > 1) {
> +            num_pmu_fixed_counters = c->edx & 0x1f;
>  
> -            if (num_architectural_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> -                num_architectural_pmu_fixed_counters = MAX_FIXED_COUNTERS;
> +            if (num_pmu_fixed_counters > MAX_FIXED_COUNTERS) {
> +                num_pmu_fixed_counters = MAX_FIXED_COUNTERS;
>              }
>          }
>      }
> @@ -4051,25 +4058,25 @@ static int kvm_put_msrs(X86CPU *cpu, int level)
>              kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, env->poll_control_msr);
>          }
>  
> -        if (has_architectural_pmu_version > 0) {
> -            if (has_architectural_pmu_version > 1) {
> +        if (pmu_version > 0) {
> +            if (pmu_version > 1) {
>                  /* Stop the counter.  */
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>              }
>  
>              /* Set the counter values.  */
> -            for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
> +            for (i = 0; i < num_pmu_fixed_counters; i++) {
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i,
>                                    env->msr_fixed_counters[i]);
>              }
> -            for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> +            for (i = 0; i < num_pmu_gp_counters; i++) {
>                  kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i,
>                                    env->msr_gp_counters[i]);
>                  kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i,
>                                    env->msr_gp_evtsel[i]);
>              }
> -            if (has_architectural_pmu_version > 1) {
> +            if (pmu_version > 1) {
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS,
>                                    env->msr_global_status);
>                  kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
> @@ -4529,17 +4536,17 @@ static int kvm_get_msrs(X86CPU *cpu)
>      if (env->features[FEAT_KVM] & CPUID_KVM_POLL_CONTROL) {
>          kvm_msr_entry_add(cpu, MSR_KVM_POLL_CONTROL, 1);
>      }
> -    if (has_architectural_pmu_version > 0) {
> -        if (has_architectural_pmu_version > 1) {
> +    if (pmu_version > 0) {
> +        if (pmu_version > 1) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_CTRL, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_STATUS, 0);
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_GLOBAL_OVF_CTRL, 0);
>          }
> -        for (i = 0; i < num_architectural_pmu_fixed_counters; i++) {
> +        for (i = 0; i < num_pmu_fixed_counters; i++) {
>              kvm_msr_entry_add(cpu, MSR_CORE_PERF_FIXED_CTR0 + i, 0);
>          }
> -        for (i = 0; i < num_architectural_pmu_gp_counters; i++) {
> +        for (i = 0; i < num_pmu_gp_counters; i++) {
>              kvm_msr_entry_add(cpu, MSR_P6_PERFCTR0 + i, 0);
>              kvm_msr_entry_add(cpu, MSR_P6_EVNTSEL0 + i, 0);
>          }

Reviewed-by: Sandipan Das <sandipan.das@amd.com>


