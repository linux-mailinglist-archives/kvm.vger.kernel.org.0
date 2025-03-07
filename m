Return-Path: <kvm+bounces-40309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E9BA561B7
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 08:25:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C75C1893CF1
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 07:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF5E1A3147;
	Fri,  7 Mar 2025 07:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="14oDh6e8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A227219AA5D
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 07:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741332303; cv=fail; b=kObNmkBiFWkSXm9oH1RaonH2MaBZhr4Qs58x89054Km4r/UTvmwk/XEWviEuXEs/9ITZCDCzi66z+iJVOs0PTwk7yOVnRyxXiHSdZ7A3K+bVEnyNZtnHYwe2Zsb78QyHiWiWXOqFaO9wUzn+AbCbWKryeW06xQ/H6nvMZy6lbVs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741332303; c=relaxed/simple;
	bh=OdItHhyxWPvtcVHcDcMj7PaGeWZAGloGrf6Tv+IfNvU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NFKQ7j+r8JTMnWZjUSDtwNGsPkm1DGcDWPv1yKyKMuRZfN/YdlS+IY8z47H7M/7soZLMWZVRJdS79QeytTEFUNuH+tk+jvEFM4wh/PZmtJ4M326/1OOo8g4HDd15T8yPFwSfE+0B1opV1EzRZv8ZHBh3+3j4106lervjiApnc0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=14oDh6e8; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZcVS32MKEf7If3DaRuZhJ4Wc5MmJmaeAF7rtG/fk2nIiSEXz64aIVWMow+NbToUQq4dGj01qPmMUihlzDrWiON98WQf469F80b8A/LEv72ST5Tf9XMN1QKHyaTqHBB/w+HtihLcNHP7PHbr/KBEk7VJNN2M/rQx1GsPvVB6yBlxqMBKPCn7jmQNS0Lin9z4yZO15vH90EyzVbl+6d1gzhEwqYdYG03oIU2hQKaW0ayx+r2qnsxeRtBBTiO/rguwuyKuFiFzp0cVE0zWQRCBCeGpIPDiEJkTdXuIvrcgUnBOfsL324TvLeUKBLH496A0i5cFB2iGKy2PknIfxB2kDsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jKAJty6dq1aJc0uLp00hOaeKjaBRUKQTNxM0fVaeUg=;
 b=a+uUg93tyONQ5L15D2QeNC24+pRHsd7UZMKGVf1fdZptwHlSNVdz9I6IiDZWYL3TQ/xMuqTr3djtAuwTR0S4V+S1BRRYVR/BkW+RV8e5O+3COZx0GFZRYWddvvGLgbN70O8O0lMCNRLAEGKYWNTSHu6jjz81Jq8BcmOJIcZo3imDqJkQ5/0Wb/EZ6qYcgbChKi9FX9TX/ytX4gpVeUES5rX6j3EBPUA/M883ajOILWJOgqYo3pv99SRwJHC+4+U2NgMH3mhIG7NhHf4JGR2XVrgVnuoQqPdNFF4L90ON2KaQs0qDgIipO/yyBAyldNBJxY/onNDcpMrdWyfVlePCjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jKAJty6dq1aJc0uLp00hOaeKjaBRUKQTNxM0fVaeUg=;
 b=14oDh6e8waiTWn1TIhlBUDQ1tbfPkoK2jE3NP2t2d0+iOa3wHL+D9nzCEZro8VgY9Vkd2Vol09JBRN72ta33Od0Yo/VhD1/NddwOeMVUUAaaWIU2bYamq6xikdvbK+YQ2jSpJuor2P187boSVoicVu08pP+MpgZZLat8ryC8318=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by SJ2PR12MB9085.namprd12.prod.outlook.com (2603:10b6:a03:564::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.19; Fri, 7 Mar
 2025 07:24:58 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::2efc:dc9f:3ba8:3291%4]) with mapi id 15.20.8511.017; Fri, 7 Mar 2025
 07:24:58 +0000
Message-ID: <9e3124eb-bc08-427a-8ee2-4e81dda899a1@amd.com>
Date: Fri, 7 Mar 2025 12:54:47 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/10] target/i386: disable PerfMonV2 when PERFCORE
 unavailable
To: Dongli Zhang <dongli.zhang@oracle.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
 babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
 zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
 alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
 davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
 dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-2-dongli.zhang@oracle.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20250302220112.17653-2-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0211.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::6) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|SJ2PR12MB9085:EE_
X-MS-Office365-Filtering-Correlation-Id: f0ebce80-60fc-452a-1b4a-08dd5d4929ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1VFSkNWMmpuaFZUazk0aTBNSU9HSFVZTlNLZ1dxRDU5dVNKQ0JlZlRDQndB?=
 =?utf-8?B?WjI5MGVBSlJsNm56N1lVZS9pU1BHcWQycG5NWm40U0FHc0FuNWpoUVZ3MU8r?=
 =?utf-8?B?YjBjdkk1RHJkOUhUNzd3SG5ZMlNSaThHNnpBb2ZGWHBOVXgyN0k0VjBvc3Q3?=
 =?utf-8?B?ZTczT05ERXJyQXBhMFFwdzdxU0UzdzFtWCtXT2k4L20zRmZxRlkyR3E1R3Zj?=
 =?utf-8?B?ckFGMnF3dXdja1FCSnVRY2NhS2RxZjd0dzJCY2ZXSmNJdUVBVEk1b1ZUeEVo?=
 =?utf-8?B?anFOQVpsaXdRNVFHQWt6MG9RdEg5RE5NOE9GUkxGQ1lFRUROSDM0QUpLR1hT?=
 =?utf-8?B?RDFtRjBpVkVqS2dtcWdVMUlpN1JaK05SYmdlYzZObnRUQzZwQUpjRnNoa0dO?=
 =?utf-8?B?Vi92ZW0ycExPKzJEcXM5eVNRY1hpdTZyUUNIak9YOXRnNkNXN3d4cDlySHVV?=
 =?utf-8?B?aWt4QUxjRlpJNzFZQ0ViTWxRZW9mVmVvbGk0eWYyTXlvR2dwVEFYUGxIcFFp?=
 =?utf-8?B?Mlg2VmlubnBxMFFWQUk4dk5pMzlBOUhLQ2N0SWxlbm5zVUNwVkhRakQzcnlr?=
 =?utf-8?B?UzNXY2xGSkFWTUlhL1I3RXB1aDhTNTJjb05yRE03VmpBYWQ1ek0zeTJqSmYw?=
 =?utf-8?B?QjJyZmcrRk9GTjZVQjVTUDlOU1JjRFc1NnQwS3lSTHJqRktFWEhaRGVZMGth?=
 =?utf-8?B?OVMveXhhcVBnTjFabHhQckEvbFg5ZlorNHFnbWt0cFE5M2RyenZWejBOb2xQ?=
 =?utf-8?B?Vm5ZQ3N2eCtNM01jSzRHN0gvTEladm1OR3ZsRDVJWXVIeHRYRWtyU0xod1g0?=
 =?utf-8?B?YnNSWE13cUxKallsYytKTHhpRlFWcWJiTTRpb2hHMHNya0wxQ1Y2OGlNd1Ny?=
 =?utf-8?B?RkxWcU5nSDJVSWtLeW1NT0hqY0I5M1JuYUFxbFFFazJ0b2I0ckkrNkJnb29F?=
 =?utf-8?B?cUpwelk4NVk2ZEV3ZHFTTGVGVXA4dGQvZk5oNSs5TXlpRVQ3T3UzTEsxb3c2?=
 =?utf-8?B?SE1qNVlNdEJSQ2lObU00aUt5ZWNjdzBxSkgrUGZqdUNBWFRWNEt6NktheG8x?=
 =?utf-8?B?QnRDMDZYV3cwRGRlQ0JacHlocEhESk9Db0pOalZ5a003UTJDSWRVU0p3NlZG?=
 =?utf-8?B?MHFGeVZXRU5zM2tjbnNsYVZ1ekFtaDVnbmdGQWlXNHB1WWxDaWQ5ZWhucVNJ?=
 =?utf-8?B?OUNVV3lTMWdvREwyMnppemtNR3M2c1Zya3FLZEhoa0pNT2lldmlnOUt4Skh5?=
 =?utf-8?B?SjhhaEhlRndCd0VXUkZSUHhQemFpenJVSk1tbW1IcXNBUXJUcjdGTVNNOTNq?=
 =?utf-8?B?NzdseHVMSFVUQW1YK0doVHRIRFE0NitaKzNJaEZtM0N4d1ZSQnMvZmhqdFFT?=
 =?utf-8?B?dE1KeGh2Q2h2cDFsMGZtME4yYnhVdlppU1FMN0hIY3JSYnZmdTRTb0luaytC?=
 =?utf-8?B?amNRbk5NeFA5SkhJTHhBT0ZrUFA4d3MrRWtnUFpWQkpsUk0wZEZ0eExVVGFy?=
 =?utf-8?B?dTAvUW9PM3RjUkZBdHJjZEtNYjRKSTMxemZZWldkdk0yQ3ZMK0I4a3BIc1A1?=
 =?utf-8?B?NjI5YVJ5U2JHTnJ1SDExY0lIWC9GUnhNNkhEUG5DeVZidS9wUXdvRlVNN0w2?=
 =?utf-8?B?VXRMWFRvNmZ1dURLWmVSSzRXRlVTdnA5RkQ2VXJLVmZjWGg5cVA3TUNFVS9O?=
 =?utf-8?B?NVhydUQ1RTFldTZRM1hnNGNOOEROc3pSQmcweldqZWtaSkdtZVJYcXZOamJW?=
 =?utf-8?B?TGlvRGUyS0djdTVJbjhUczNubllDbVdxSGw3TThRL052Y0FFdVZ0ZE5nbldk?=
 =?utf-8?B?aTlRMm5oUWNIcVArN0xwN2F0eEJpNFMvQWp5QWxVS0FGVHhXazRNa3NrN0VQ?=
 =?utf-8?Q?jr6cbe2HulayS?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ujd5VVNUSWtHYW51SXZVdjFuNzFSWEw0dmNsdGtXdE1YVmdGNisxK1BVSzcy?=
 =?utf-8?B?dTNHRE9ibnp0MXg0SzdjMEQ5L29vRS8vWjBhSVdxLzNPOE5ROG54OW53N0xi?=
 =?utf-8?B?b2ZBa2xJZDJNT2F5LzdnR0MvQUszRks3Um5KbFVIcE5DOVg1Ny91VFlja0hy?=
 =?utf-8?B?Q2JldGI4cDVXcnVBa0w2VERqdzBaYzFWZVgzY08rT3FmdGFxaTBCRUFTODVT?=
 =?utf-8?B?WVhBNDhaM2xGZXlWRnBIWm1Ic2I4VGFVYlpGdTdvei9nZWxiSE1uVUE2dnF3?=
 =?utf-8?B?aDU4VXFmSWV3ZVNWK0JCc1lyVi9pYWFSNW1hNjNjejI5dUw4UG5YYllnMkhQ?=
 =?utf-8?B?WlhDMW5MUnBmNVpaNFVwQjJIWkdDMnlVdXp0UEJmRi9sSVJHMUU0RGQ2Y243?=
 =?utf-8?B?cmczb3J3R1dhRytqSXlkdmlzbndaNmljbVo5ZS80TUpPc0VxWG5TT1REYzZ4?=
 =?utf-8?B?djlOaG1sbzZPR1EzeUcwVjAzdkdnbENrOTdDNXErbmc1SXlUVUpBM2lVenB1?=
 =?utf-8?B?VENJQW45UzZwcEl2dWtLTG9TdzJ4M0k0RzMxR0R4Y2YwcTREQTR3dHJQMlZw?=
 =?utf-8?B?SDkycCtmSkFtNGFuU0xJTXhuc01zaktnWHlXTlRaeXBLbmd2YVcwaWV6NnhY?=
 =?utf-8?B?QkZnWE5oNTgyQVRFNlhxcFNxdFVlNXk0NGN6TnNYTXRlWWpzUHRDZ2hEVFNJ?=
 =?utf-8?B?ZFltNmxSS1pjaTZqc0hpbGpsQU9CUFN6bWRmMnJIQlAwenBrcHB1dkYyZWlG?=
 =?utf-8?B?SEZuU0J2UFZVQXE5ekFaQjMxNjRzR0VCV3N4NjZxT05MVitnR1V4RjRNU1NJ?=
 =?utf-8?B?Uy8yTkdmSStwUUhWZ0RNaUJrSlc1bWpoMjJSd2pJbGVPSWZSVi90VmxqS3ZK?=
 =?utf-8?B?TmZoRDB0eTlFczBodkN6YTZwL0tTZlB2VWljMS9FSkpLa2Q2WWpsSmQwbTI2?=
 =?utf-8?B?dWt6eDJOTGQ4TElUN2d2eUM5d296VFJSTVBzMVdEZ3NCWXNWdGl0bUdBQmJN?=
 =?utf-8?B?dys3WUdVTnRmcDVuZ1o0YWtVTy90SEhiTlNlY2pmWldFNFo3MDI4SDNudlRi?=
 =?utf-8?B?ZThpQjcybGdXcG9nK1MxdVVYREsvOEE1b04rOVZpbjBtWExhVzBkN08weFpH?=
 =?utf-8?B?akRqZ2ZHcXZmN1Frc1h0VzdCcEYvcUpzanBtMlQreWl3YkFJMzMzOU1jL0FE?=
 =?utf-8?B?R2FZSlUvcHJRb0luYjdnRGZEempROFI2MEY1dERISVYzRU1CcFZhajVGTWdP?=
 =?utf-8?B?OE1Ld2JSZlZUcGpNcUNoOW1tK00ybGNhTE03MUtCeDIwQnJmL050QzN2di9B?=
 =?utf-8?B?eG5DSElMUUlXS2l6eUVvUnlac1h3VHhUMkVYaEk2YW4rMHpPQzF6SURiS3Yr?=
 =?utf-8?B?SDZTVG96bFpUMC80Q2dsT0VnTXMyb3ZpQmxJUHRwKy9Cc2FIcDhMck9qRnFw?=
 =?utf-8?B?ZE5KcVpXTlNJdENqTkpBNWZ1RC9qdGtBZmMrOFFOSjBETGltWEtCTUZGdG1T?=
 =?utf-8?B?VzVrcEErT2MveE15N1BJTmxFekRiSzR3MGxwUUlSeWZnZjcvQmZCT0JKTHpB?=
 =?utf-8?B?b3M5WVNLSjFCUkNZYnFUb2JVdFk5eEpSMUZXOUMxYmkwMmlXdUpRTUFNV1ht?=
 =?utf-8?B?VXhUTmhLQlZuZlFuRUlKR2tCK0c1cFRtQ1AvRTRDbERrc0hyaW1zckFmYjlN?=
 =?utf-8?B?YXkwVnVLdTF1R3FKZTFSSEFWakczcEJTVzY0RnBSNmdkVmRMQmIyZUtnZnlh?=
 =?utf-8?B?STA1bjdCZEVCbnErZW93eTJBWmhPeWcwQVZHN0tpM0lobzFVeTB5ZG1QWFJD?=
 =?utf-8?B?MlBRVXcrd3V1L1BYQ2M3ZUJCSHVPZkl5WTFrQzhzWjZDZEtUeldrMlJjYlR3?=
 =?utf-8?B?MXV3TUlVWmVSNDZGZkUwSWFYMmM5NUlkY3BXb1NpSHZ1V1RKRmZlTWVzR2I1?=
 =?utf-8?B?cFdUdncxUmg1TThxaS9MOHRHL3BwUGJYdTF1U25INnhsWXgycnk4Y3JoTGMz?=
 =?utf-8?B?VHpCUHUvL2ttZmF1VjdoL3VvODRFYVRkV01CeFJGeHd1c1hqbXFvRGRWYlJx?=
 =?utf-8?B?bDgxMUpYNExZcU1ORldLQTZITTBIcFRaUHZBc2VCU3oxOVNBMjRQa2xrVHdM?=
 =?utf-8?Q?Y8cneUID63D6GfQeUeq2a9q72?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0ebce80-60fc-452a-1b4a-08dd5d4929ff
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 07:24:57.9484
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nv5w05tjhTWY2D8Ej1xqZF0TdIcptEsi7AiVcq/ExDWvqxqxm++DTUMVOhe6JAWyHlD/3a79+X+G3PkDOMcjjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9085

On 3/3/2025 3:30 AM, Dongli Zhang wrote:
> When the PERFCORE is disabled with "-cpu host,-perfctr-core", it is
> reflected in in guest dmesg.
> 
> [    0.285136] Performance Events: AMD PMU driver.
> 
> However, the guest CPUID indicates the PerfMonV2 is still available.
> 
> CPU:
>    Extended Performance Monitoring and Debugging (0x80000022):
>       AMD performance monitoring V2         = true
>       AMD LBR V2                            = false
>       AMD LBR stack & PMC freezing          = false
>       number of core perf ctrs              = 0x6 (6)
>       number of LBR stack entries           = 0x0 (0)
>       number of avail Northbridge perf ctrs = 0x0 (0)
>       number of available UMC PMCs          = 0x0 (0)
>       active UMCs bitmask                   = 0x0
> 
> Disable PerfMonV2 in CPUID when PERFCORE is disabled.
> 
> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> Fixes: 209b0ac12074 ("target/i386: Add PerfMonV2 feature bit")
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Use feature_dependencies (suggested by Zhao Liu).
> 
>  target/i386/cpu.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 72ab147e85..b6d6167910 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1805,6 +1805,10 @@ static FeatureDep feature_dependencies[] = {
>          .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_AVX10 },
>          .to = { FEAT_24_0_EBX,              ~0ull },
>      },
> +    {
> +        .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_PERFCORE },
> +        .to = { FEAT_8000_0022_EAX,         CPUID_8000_0022_EAX_PERFMON_V2 },
> +    },
>  };
>  
>  typedef struct X86RegisterInfo32 {


Reviewed-by: Sandipan Das <sandipan.das@amd.com>


