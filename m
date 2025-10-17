Return-Path: <kvm+bounces-60288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B5D0BE7D6D
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 480A1563563
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 09:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF31A2D7D3A;
	Fri, 17 Oct 2025 09:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="o2xc9se3"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010054.outbound.protection.outlook.com [52.101.201.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD91B2C15A0;
	Fri, 17 Oct 2025 09:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760693475; cv=fail; b=fQfDenROLn76OLLSiPtKob/f4TAO57nzWEtL/rOrrw1J0VVEqCo/jg3J/LmGogZJjhvijUFRzFlZma73046BQtsPMBQrMNJGdxuUR9U79tyvzx3WOKkxPxDQII1b+tadL6DXwFHg1VHusZ1QceinLsuqHAjfWd37aI2v2EehZ/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760693475; c=relaxed/simple;
	bh=yF0m1ojRf4LoeW9V4ry8LisUSGr+24ALTqExkAe9UD0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HwFFx3R98FJ0xt4WO4GxKc+93a1MPlqQuseMrAfoDKFOHinOSPzccCzY0Il+cE4T3JOIVVRvoKHtHGBB//6r6CIY9iT1pDdz2p7g3xlOdA4LYpuH0TDybyEpTRKDMvLFfyDYyi4/9f2Uz69gPSb7QRrfHSakqHcGKY2EMddCuP8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=o2xc9se3; arc=fail smtp.client-ip=52.101.201.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nw1aaVnLzHAu28PJR6otE8Bcf8KGQLha+fzOy1pHU0AMU7VGTUedzRy89H+R5Fz7Rob0XPiHTZheKkgUuaaqcZuyylp0304eSISdobqMImym1PR8dfyCdYJ80MzZUn2KrDl2bWsvImVsOBNJwMYnd7Dbzg8dS5Vf7mSh1ixLiSti/4rlYa7gLChxsyiufCO/KFsh8/w2Q+e3K+Vhfahu7Brcxx8PovUO+ED5DRcsWhkaYvmgkKI+RBDpYAl1V88gJYcVjmjIRH/nR7L2jBVvhOXD0SdC4Jh0sKKWtp1R80IHpHESyKXp0cg2xtndq0gJkSXzdZ997sGYFRCmsCJVDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Ld4RpYwyp7L7omSs/7xfVuC+tAGHwBAO0bLr7XEMsQ=;
 b=P48SgP3H5E/pN7LRHjrhqTKwOi8Mpyo3a+qEl4HexJ4OTTBtZuS9aBUPD0TtQrpfGRXfLdVviCQH7hLngXn4nsepi51kBH91yAWHMK60TcR4aNoq5WWGc0nrWHpFwZgMVkktyoylW3frq+YHU4HW309uGZZaTuUzGcBXlYBf2eT9L368qCYEwqxGZfSxVdcrXS9Wp9JWNguo0tk5ir3X0sBK8vs4ay70UqUeVrPxVFKO5zoxWGGvlrjdfo1Quk0AC3RL5b63JgOljVsZZ54/twc+siPwAiBynDDu1xpdwlG3jMw/6CdYslqYXaklq33hPNdkdcy0d9406B7nDCmu5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Ld4RpYwyp7L7omSs/7xfVuC+tAGHwBAO0bLr7XEMsQ=;
 b=o2xc9se3JOIVfRuZldymrZ147suR/2YrC2YSYBLT7zMkjmAKev+yw3xKCc+ef8c91hi2rCyzoM9EnyhcZmyFVGcTM/TJB/a3BDD1bjJoTlSovIRT5GOPPYPR/Cta4Tnw5QRlXlKqZYLa8k2cz9LOEmOr+epCnYP1065O0gaZYGY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by PH0PR12MB7471.namprd12.prod.outlook.com (2603:10b6:510:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Fri, 17 Oct
 2025 09:31:11 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 09:31:11 +0000
Message-ID: <566dfff5-11b9-4ea1-9ee2-8db2f676dd18@amd.com>
Date: Fri, 17 Oct 2025 15:01:02 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 01/12] KVM: guest_memfd: Rename "struct kvm_gmem" to
 "struct gmem_file"
To: Sean Christopherson <seanjc@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>,
 Fuad Tabba <tabba@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251016172853.52451-1-seanjc@google.com>
 <20251016172853.52451-2-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251016172853.52451-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0191.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1b6::7) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|PH0PR12MB7471:EE_
X-MS-Office365-Filtering-Correlation-Id: a8a42537-9fcc-430c-431a-08de0d5fe857
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bThxUGNGZzBualZiak5QSFZ3V0kvbks1YVA2NnpMei9OOWZ2aWxlQ1lId25h?=
 =?utf-8?B?QXVtaWFxeXVjdlRROCsyYzZzQ2hQU2xHRUNvZ21LNGNkQTA1UjRhMnRUTGtW?=
 =?utf-8?B?T1lDTmdPM051dVNJQk1LeEgzcVZlTjZSRHA2cUxjai80K3pRak9YM2VJTWd1?=
 =?utf-8?B?RUdIZGhXcWNlTVpKbG53MVFMT2Nzcjd3VlBYb1RzdXR6Ui92Rm5wR2N3ZzRH?=
 =?utf-8?B?bUI3Zk9pQTB6cGYveEo2dncyWkVSQjRsNUFQOWFoWHd2cXVyeFdNZmtERzkx?=
 =?utf-8?B?UDFORGhTaWQwNGI0RGpGZ1FGenJrNGZOWXlIb2EraUtHSEtXY2RmNXhCeU5i?=
 =?utf-8?B?VUQzN20xVlppOHh5czF0Y2p3ZjB2V01xZ2Mza25aTmVqQThmcVA0VmZudTR0?=
 =?utf-8?B?VnFEN2ZHZVlLTmRlNkNPNnZqd05ZdlRvU0xReWZQMExSWmE5Q21vTFdKUTd6?=
 =?utf-8?B?RHZmU3FHblBiQWxqeVBDWjJqelJ0Wmh1Rmk2YkozUWlMbEJ6ek1IelhrL2V3?=
 =?utf-8?B?NExacXB6aUxibEUzdFlaT0RIdWNFbHNjbzNDTEhsMUpBOG1uRTJFdGpDa2pQ?=
 =?utf-8?B?bFlZNis5YXpDd2VqZkIwNlE5MkFkTC9Pbkd6eHRlMmtIK3Q5RlVvN2tUazAv?=
 =?utf-8?B?TSs2ME5ZSlovTjljdTJtbDFqNXBkalRObXJObUtSNGN6NXo3UU1oOVROd1Mx?=
 =?utf-8?B?NjFuSUFkWjNsRDllb2kvaFFHdGU4Vnh0OXc3OU1YTzBQclcxWmgrVHk2clRa?=
 =?utf-8?B?NFJYOUxFdElpbytRVXhEQ3lLOTJ6aWtUbkdWS1F2N00zOC9vZy9VeFY2MDZn?=
 =?utf-8?B?NlZGbEpNa1ZMaXJBZnB0ZlNGQXdXVU1iYVBrY0REQUJjOWdrRVhGYjhRMU9n?=
 =?utf-8?B?RDBTR2R2U2FYMGhkY1c0N1BIN3UrU3dDc29tQWdmMkVZTkpjblE0cTZFMWlB?=
 =?utf-8?B?N1JCemNIYlRvMlBKbG81MnQzclNLbmhhZ3IzTmZzWmVxZkpHWG9KWXZGaTF5?=
 =?utf-8?B?U3VkZnk1WnhuWm1jcUpRUTJYRnFhZ2M5ajgzWmRYNEdWMGJ6czAwL2dEK3BT?=
 =?utf-8?B?bWZVdU0za3lZRU0xckl0Y3lLT1BXMFI2OFRWZEgzdTdFUGFmd09WZ05ZbUk0?=
 =?utf-8?B?OHVVZ096cEkybkw1Wmdqc3ViVlVheUV5b2RQeUFnK1oybVNydEZWK29JQXVN?=
 =?utf-8?B?N3IxMUo0Q0ExaGFoWnRxVmhpM1IzUzdUWnIzSG0rM1kzUDE3QTRTYkpWZ3M5?=
 =?utf-8?B?QjdHei9WbVM5bHlBRTljQVRDSGxGQ1Y0clF0dHQ5RVlGKzd6K2lOUGNPUGI2?=
 =?utf-8?B?Y2REakl5RDlRK1VhcVJOMFZDSnVHcEt5RHE4V0Ric2hSY0V6RWE2aERKeGZR?=
 =?utf-8?B?ZEdhb1o2TkdyTDBiOUUwNklKNzNVdXFJT0VXS1RmSm50aTRQUWR2TFgycGJF?=
 =?utf-8?B?Mkh3bUhMUGRCdExZZnhNcm9DM2JjM2NlbXRyckdBRzNkd3E2bjQrVmRPWEJw?=
 =?utf-8?B?UWhET0lJTGt4R0R6d0w5MzNqaWF0UExCN29mUm1zMTFkc25FaWtJdnBVQU5a?=
 =?utf-8?B?TFhrTU5XZVo4ZzBlM24zdUp5VzZvcGwyOEUvNXBDZDRIUFBrYUU1RkppazlT?=
 =?utf-8?B?cCtSQ0Vjem9TcWpkTmRFMG5rNEdnOHQvbmJLcGZla0UzMFdxbmhWUlBqbXd6?=
 =?utf-8?B?L2wxVEh1aE1VVGhCZ05qUjF1dzRUTGx4cXZ5cmMyWWVObEovcUlBM0I4YjNo?=
 =?utf-8?B?R25XY203Zlc2dGwwM2lNZDkvc2NNcmoyeXRncjJ4OXgyblJqS0hWbkxSZThG?=
 =?utf-8?B?ZG5iblZ4ZFRnVTdlSmpVT0lCT2lGUUowVjhqMnBDTWNCRFhaWC9nN3g3RXVC?=
 =?utf-8?B?NUFPU3p3NVU1SzlvaE5TQ0d3MUVvL1Q4Y1BHaDByTHFRazJ1MUQrazR1cndK?=
 =?utf-8?Q?kbT3LdVMPTvBosZ2ZH8Bxic2vSu3aqfj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ejNZeExSWlhOSWtqOWVqYk1Cd3AwdElzc21Ya2hWTGlhaDVMclUxdjdtaXVp?=
 =?utf-8?B?eFcwaWdZRmsxUENHR0hubitnU2w2b2phWjVteUViU0ZQa3pYTzVZaUowbk4w?=
 =?utf-8?B?NDEwTGV3dHdxMnBSZXBoSGRwOEt6SCtUVGpJOEZaQk1WdnBwdkVwRU9hbXVW?=
 =?utf-8?B?cUMvQ0tuUGVzcldtdDZJV3J4OUJyMnlmbHpDOFgxTlhueVZhM3MvU0pVWlNM?=
 =?utf-8?B?UVJJaHoyOStWbUVyV2hIMTRra3VkYWw2WHBsbThadWFhOFdXVHl3V2d2d09M?=
 =?utf-8?B?aUxuWi9DVllUOWtEa05HNWFXM2ZUM3FDK2VUcVJxSEx4SDIvYmpVR1NIRVZV?=
 =?utf-8?B?czh1RUptSjQxS0tyeEtaTHJRMzFhOUlHcHNSckYraDd5YjhTTEJqY1dqUGZ3?=
 =?utf-8?B?NDkvQzB3WVFiYkxFY1BwV2xtQ1FNYVlEaVp4d3d3UWg2Y0ZzeGNaWExtaDAv?=
 =?utf-8?B?N1NqM25sbUo5N2kzbXhyZXBlV3JCS0hZQUhaNFEybDRDc2tmWmMxZmhlVTBI?=
 =?utf-8?B?RWlLOERISHR6Uk0yS3pMZjVqeXVMMkJPK2VaQ29rQmVPNVd4MmxyVUZXdTJt?=
 =?utf-8?B?TEF1bFpTSTM3QTByVDJTcU9oSzJxRDJDeVhnR1d4ay9KZ2VJcmtReFVSWXRS?=
 =?utf-8?B?RjhrV2dJb2FaN0Jsak1zWXoxZjl2SXM0RGdya3NEN1piZFhIcExrRG13WE9F?=
 =?utf-8?B?VTBDQmJHK0wrRG81aVlsdlViUUFubWsrR0Njais5ZytWTmR5QUxFNjhtUXZ6?=
 =?utf-8?B?N0lSWUVxNXNHY1I2ME9VOHAxNVU3bGlqUERkZFg2bzZHZkI1bGs3Ym5JOXcy?=
 =?utf-8?B?WlRRNUREYmRweWcwbkFtWVdhMy81M0lPTkZMeVQ0anE4T3BpRGJna2FiYm9m?=
 =?utf-8?B?RDh4cEg3OThraTVTdG8rU29YSy9wYjZzNHBmU3FnZHdlZHpXeW14d1hiR3Fw?=
 =?utf-8?B?ZFFDM0VMMUdwKzUzcTlvUldPNWdFNGZnV1F6dld1VlZlMlVOWGN0Sm5zbDVp?=
 =?utf-8?B?VFg1ek9nbjM5V01GOFE1eEdUbnZRSFNMUnAxdWYzdG1ZcHB5NkNqY0VSdnh1?=
 =?utf-8?B?Z2VFQ1JQRFAvcUhSSTFjSGlZSkFYNDNnNm80SjJVMzJMaHhudGIvRTB6WnBQ?=
 =?utf-8?B?QjMwOWpzSG1UVFhtUEFINXNER1IrQXhQQ1YrdFh1eC90QVFGN1gwRHQwYk4r?=
 =?utf-8?B?eCtjVnV4cytFc2NZbVc1eDRERlFQT255aVhyZnNBRG5jK2F5RmdYSlA2MmRi?=
 =?utf-8?B?cWRmSnRxNTNxRmM1TytCTjQ3dG52U2hmeFpJb0NzQmJsR3pLQm1PVmtKSmY4?=
 =?utf-8?B?alNyRHJsOEsvQ3FEUWVPMUJSWVpCYVFURDFvaEZtL3NSMktnRUlJMjg3UlJm?=
 =?utf-8?B?UHpHdVpITVUyWGNuUGFLVGxpbXNRc3BCTVpBK0hnQjltNEtYU2tScno1dnVy?=
 =?utf-8?B?WEtJOHJtZTBVa0NEOU45c2MyRkRHZENVSkUzZU0yaTBMMEtISlVSQ1RoSjJh?=
 =?utf-8?B?R1VxdDhCUUhMTzlsM05hSGtUbDB5c0tOTkhLR2VESVpPclBQb0VsNTZiTHlv?=
 =?utf-8?B?Vjh1RkEwYUJ2OVo5OUVTaE1zR1JnVkI4ekc1WFBuMEtmNmNMdzBzZkdDQjd1?=
 =?utf-8?B?dStiQW5TMnIyZEE0dmsxcDZtMVR0L2U0c3lnWXB0NExLSW1yRllGT1dSWDh3?=
 =?utf-8?B?Sm4rLy9xMzRzd3V2ZFZVMTY3eTU2T0NGK1p5VTZQRDN0TFgydWFpRExLRE5N?=
 =?utf-8?B?UlNNVDIwL1c3dVBBQmlVak5FSXYyaTZVM0NDbFhGZFdiVE85ZnlPeUo1dDU0?=
 =?utf-8?B?MUVqNkhpYWRsakZXUHhsNkVxMTh0V1k2ZnJGWmd2eGtkZlRWb3pHSGVNQnNj?=
 =?utf-8?B?bFJYNkhZeXozcGdyWUtxbDVYRk8rUTFEdit6blZRaTZwZERwNHczZ0U2dHNy?=
 =?utf-8?B?bDNjYktjZFNJZkJKSWhpeTZsZVlnT08yNTUrOGZhdXEwZGI3Zm9ML1VkSlJG?=
 =?utf-8?B?RjBVT2VDV0lQUUJzVzNCdUVVNDVoOXdkWVI3NDBnZDBUOCsyN3QreXIrNUpJ?=
 =?utf-8?B?NHMreHBqZmp4eHpiRVVoN1VqdEg3UjhESU1sRG5GeTExRm5Jb1dDNS9QVnFw?=
 =?utf-8?Q?pN3OJNJ6AOzdB1ae4NOVvuV50?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a42537-9fcc-430c-431a-08de0d5fe857
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 09:31:11.0050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qfhdn7CNwkXcIPsBFa390PxA3CpjtCosDt1yTYC7GUGqfywgXMCV+8DsymHJL7tgmKNT1gi84HbNT+q9/0L7dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7471



On 10/16/2025 10:58 PM, Sean Christopherson wrote:
> Rename the "kvm_gmem" structure to "gmem_file" in anticipation of using
> dedicated guest_memfd inodes instead of anonyomous inodes, at which point
> the "kvm_gmem" nomenclature becomes quite misleading.  In guest_memfd,
> inodes are effectively the raw underlying physical storage, and will be
> used to track properties of the physical memory, while each gmem file is
> effectively a single VM's view of that storage, and is used to track assets
> specific to its associated VM, e.g. memslots=>gmem bindings.
> 
> Using "kvm_gmem" suggests that the per-VM/per-file structures are _the_
> guest_memfd instance, which almost the exact opposite of reality.
> 
> Opportunistically rename local variables from "gmem" to "f", again to
> avoid confusion once guest_memfd specific inodes come along.
> 
> No functional change intended.
> 
> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
> Tested-by: Ackerley Tng <ackerleytng@google.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 98 +++++++++++++++++++++++-------------------
>  1 file changed, 53 insertions(+), 45 deletions(-)
> 

Tested-by: Shivank Garg <shivankg@amd.com>


