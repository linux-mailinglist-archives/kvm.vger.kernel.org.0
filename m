Return-Path: <kvm+bounces-40681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3718FA599E4
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:24:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CEC5B188BF6E
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 15:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42FC522D7BF;
	Mon, 10 Mar 2025 15:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X32w3ZGa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76B722B8A9
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741620229; cv=fail; b=WLs73SSoKl04V84ihHnk8f7v9i06l1tEI/STVayWhXqyz3dwXG0JfbnzjNpTl/YJ+X9jD8zjAoHLivgEit6ar1KisU0iPozMv5XMFZlSHk0hVcyOVr7rdpN9aJZk6ZGXSQ4QQIZz9gWqk1y1m6XedWw3EoggBHIHFObEb+5Iw58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741620229; c=relaxed/simple;
	bh=Lgj+rpfg/u+dbesNBvz/mTpZgs9dlTlcK6VJuLYlHCA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=SwO9rgLK//CO7RrROY11Df0Kq3ZjtFWR+aOW5cVvTZ0qciwf1zLnc2amq8cOnpcBex+Gd0YelpOYGXpwpA3d2cMWdsN1E6uizuWhYwq5Cb0MnEL0dvvBFseoFnjLgSvjAqihk7yGCvxiHp6mznDe6cOGAlpMks1egv4f7SXPGOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X32w3ZGa; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fCVhWMR4l+ALSsI5UOsaLRuYXblA7i98IXuPMUB52PXuFIHC1LDMGU6m/tQdkVeiivZod+ReLfArNOmCOla1Kgu1DQQBcQ9W0JKfaLNqPkc3ylVOg6bnZpKee6dcwz1pg8yTyf9CP1zMYkhPFQDVvdIXDZcPmH0hoGNhFBTHvd3ymnxf+kTpZUAivZpvgDO/XM1PasYT3Laa7ultO0Rh/xLD2plLiqzVEjaVB8jPPI6gAlmxBfqqV3HhBBCyJ1HtD1PoOgA6NWBFnijyADPN0bQbL6GAQ5wB/1aegp9d6JjDsK7sn/uc8FOt03a7ivI4XvPW6XvucVRY/03ZBzpQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o4gSLadJ7CdGY5KYtDXGR7SO9sFm1dr2iCzyroRYIeA=;
 b=t+0ATPxejdmOTG2Rv097JsWL3Zq3MLnSpcY0YCYoBQ/Up1SE94dRhXb9P3S5nLw1MTGyhriWNatprFYR01weBRLivTQyBdvM4Cp9nZltqVmzSxiZUrUXoX48yr5lJ7QYQmRESVZNrVXGw5Lxl9TkMKPHoWFzgMZbbnoZxcud0zhMsbcul5ffCpaQ4loRfyH6M6uXLKfjbh3Mixd8N4w0DYJPoVMAsTpvb2tDB4m/BRp2V0bqgQYhbj0dZ9PidNgDxdl2Lieu0/2PxdRyaCksb3is93hOW3qjZsNaZkzwwzJaSJ9awrOrXaJ45DBqit23pQAlptKmm7W+LMAASmrtqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o4gSLadJ7CdGY5KYtDXGR7SO9sFm1dr2iCzyroRYIeA=;
 b=X32w3ZGath4Vmb7w6BXr/sJmKRmo6rZNN5WhGaEHJ+FJaygUq4SUot955aFopSZgO2fbkIXueEYcU24EUMQJIDUG3cljUys+FJPx5jlw1h6PKfYRDz/bfor943CaUFmy3j68Yu2BOwxjO1WfprxnFXtd8/JVgPTRL0oDSeCOI0Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by PH7PR12MB6761.namprd12.prod.outlook.com (2603:10b6:510:1ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.26; Mon, 10 Mar
 2025 15:23:43 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%5]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 15:23:43 +0000
Message-ID: <92a926b7-7958-f44a-fc05-7fa2c171e710@amd.com>
Date: Mon, 10 Mar 2025 10:23:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nikunj A Dadhania <nikunj@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-3-nikunj@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 4/5] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
In-Reply-To: <20250310064522.14100-3-nikunj@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0056.namprd05.prod.outlook.com
 (2603:10b6:8:2f::17) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|PH7PR12MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: f269c169-9ce6-4236-c01d-08dd5fe78b13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V29xS1pCZEZYZDc0MGdHV21ZYzhmQmZ0K2RvUUNTS2Y5d2hGR0JkU05GaWhy?=
 =?utf-8?B?czJxbW8rNXhEeWlEWlU4MklYcVB4ZkE4WVY4OFVtcHd3Z0NaN012R2dtR0lW?=
 =?utf-8?B?eW45R3ZMQU01NkdqM0w2dWplcGtxbEx4ZTU5cFZReVJjUWlNcFd4NzRFenBD?=
 =?utf-8?B?QmZMMG05a0dROUxYYnVXVWo5NkJrNnNXN1VCbkZXQmhFcU1NM0RLMWViUnRs?=
 =?utf-8?B?cmpDSDh2ODZXSk54eGVmQlRoa2xhVGN3ekxjL0dOaUtZZWhGV0ZzMHYzRkxX?=
 =?utf-8?B?ODRBVGo4T0pCZElQY3VqRk8vN1Y0NGN2QXYvQXdxd1gzVW9MZ3dkOUlGYWVI?=
 =?utf-8?B?UXNEM1ZYN2tSeXFpUVd5V1Q3VHVCekZIaXlhR1pjREVuVmg0M2Nta3JxRHBV?=
 =?utf-8?B?VVoyUEs0MnpoMVpJYWx4dG1UZ3lISFRGbnJZL1ZOZldjK3paNXNNNHRCNmZu?=
 =?utf-8?B?Uk9YTTc1QUVXZ2ZSeW5pbmY4ckJHYmFLMDdrTTVQVXJOZXluSkRkU2xzSnRN?=
 =?utf-8?B?SjlYN1diZjdkT0k0NzBtakVua0xhSkhtMWUzdWhHY1FHWFgrUVpLWGNlMWs1?=
 =?utf-8?B?L29paEtodUVzRjc5WjRuRXc2V01PeEN6WjdvME4xYk4xTUh2YkVaQTByQmx3?=
 =?utf-8?B?eGlqUFNBemd0dkRwQTRodkcyL2tybnFicGRmekpJaWNGWXQvd0N2VlNJUUI4?=
 =?utf-8?B?RHJWVjIxelo2TTFqTHE2KzFLaEdEMVBYZlExYlhVdllieXpCVW5VYi9JSkFn?=
 =?utf-8?B?N3hCdUJIWWkzbkljOUZXUlcyWklFZ0VzcE45WVZYS2IvVmsrdVZNVENpT20w?=
 =?utf-8?B?RkdKRHlEL2RPRW0vK29wWlJpVUpPOUE3ZEg2NExQOCt5TzZoTDRKKzZncnYv?=
 =?utf-8?B?OFJvSVNBejFpakMvcXoyRkIvWDNPWjhMNlhpdkJpeTNDQkQvSHdhdFRIRG9y?=
 =?utf-8?B?dkFURkd4ZWFGUXZvYmhxRW9qRklBYitONk12Rjl3Kys1ZnNQYmI0MWN6Q3pZ?=
 =?utf-8?B?R2tYVG92SXh6TEZmVnAyWHpBcEdwS2pNd3Y1Qnl1V2FlQ1p6MlJQdkFqQ0Fr?=
 =?utf-8?B?NW9UOEprSU9QaWhnQWU5OC9UaG42SlZ3eWxiWHVteHZqWU43ejV1UkxlSVkw?=
 =?utf-8?B?SituL3loZGlHOHVkTGo4SjljOWl4b2c2R05MNXE3YjhseG9ncisyZXZyRzF6?=
 =?utf-8?B?Z2E2M3NpQ1lodnEwaXFIa0VrU3FucVhCZlQ2UENuOUZFeUJkQmkydE0wamMy?=
 =?utf-8?B?Y2tndDJNd1h3OGZ6Ukd0dHBSK040WE14UE55eU53cjBseUJzQTBvQ1ZFTTNq?=
 =?utf-8?B?ZmZ1Wit2VzBieVRuQWp5cFdOUk1saUo5VXVPV1pUU3FrNjhvblFJNzNGM2Jo?=
 =?utf-8?B?SDUvekFzckplbWtMOE90QTJqRjF5dXZXWCsxak1KMDBZdHV4cVlKbVZCaWVQ?=
 =?utf-8?B?VVVibjJlRi90cllxSGNMcm04T1dzTlhoZ3J5c1dqY3NxZjlWVEREbCtTTitn?=
 =?utf-8?B?SlFrY3pNMGh2bjY1TmxXNitMRHdSN2hiMEIxSkRXaTg5a3NrczliczRXSFNZ?=
 =?utf-8?B?cnlnTVFwcXVicm1QWllwcStHQjNYUWY4dk82eW51M045bUlvZ0JBZUoxclhw?=
 =?utf-8?B?ZE9FVzZnRUpWbGJSUFcvS002YXpDNFZUS0JUVmhjNGNaVk9kbjVPQjlYM2Zl?=
 =?utf-8?B?ajdDMEVCM2R3NXRlR2lPQ0lzVnEvekI5TTBpOGdWOE9ad3BPM3RBbzhxajQw?=
 =?utf-8?B?eXRBU0hpM3ZOMkdBaTIzVVQrV3NpaWwxcHEvMnJGeWJWV3g1dE54V0tJWGF5?=
 =?utf-8?B?UEtxYTJiVGw4a1pCYU5EL0Nqc1V1YzVQTzFOdzZ3eVYySVJ5dXlUR0Fzd2JB?=
 =?utf-8?Q?z48S/4h++bMM0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHNvMDBocW4zVSsyOHk0bDFNZkR0ZWtUOExDdksxc3pDSUhNNjhhd2tTV1FI?=
 =?utf-8?B?dktKVjJISERCTjZ5Y0czUkJOdUpkd1h1bWpUb2E2S3U0WFdzSHMwTDgzTnlW?=
 =?utf-8?B?NFFKajR1RWlWTTBNdFJFd3lXeExhWU43TzA5dUtPTTNiaWN6b1NscDhYZm1a?=
 =?utf-8?B?cE1pQmdaekU5Z1d1c3VaOXlDVm5BMjdBeHhKRm52K2RvdWxHcDA1MDVUMmFZ?=
 =?utf-8?B?Q1ZSbmFuMnJ0RFpuUGYzL1lGL1lVcG5LSzl0S3ZzVzFZZ3JTZkdiRGRhdFZO?=
 =?utf-8?B?TlBXRXduZ20zV3lCeWhsZ1NvNHRQWW9LcGdMT1l6LzBhdEU0VVRQSFhUL2FF?=
 =?utf-8?B?OXpydGFCWUhEbmtzVXM3cGN6bjNxbUJJcnRHTlhUQlY5VEEyaUxYWkhzUmVo?=
 =?utf-8?B?Mzh3dG0rWW5Ba3RhSWhuWk91SkNFLzNtNm9CajJlWkx5bWUwbFlrRTFDMlIz?=
 =?utf-8?B?bldDRlIxb2pmbWZSZkFNbG9KY3N6bUttNVYrUDViSlUxSGM0RnhaL1ZQaGdQ?=
 =?utf-8?B?RVI3ZEdWdWNleFlKU0RHYTEwdDk5dnJtSnN3MkpLL0RtSm11MnQ1VDFZbU9P?=
 =?utf-8?B?QytXWWtkS21OR2RVVGRJSk4zdFJMazNUNjFuSUR6Yk94QW5XYTkzV0dQYlp3?=
 =?utf-8?B?UVZBbnRTZG1KUUYrMU1ZRzErakRoTXErKzhlbDVFZ01IMVp1Y0Mrc2lmR09J?=
 =?utf-8?B?eHN2VFhVejA2TFdRTHJ3MHN4aGMxZWQ2ZFk4eEkwRGlybUc5U3p2Tk9hVWgz?=
 =?utf-8?B?YUJmMXUyU3l4YkFvYTdZNXdnNW5mQ1lRSlM5Q1NtMUYzdzc3YmUzc1NhNFRC?=
 =?utf-8?B?THBGYnJteTJZZXI1WXpIRG1FQStMb29nT2dJWGVTU1hNcjY0OXBWaGk2bkVn?=
 =?utf-8?B?c0xlaENHTDY5MldaUS8razlWdzcraG1CK1VJdjZPZEFQSVcxRlV3dHdXcC8x?=
 =?utf-8?B?akdQb09DditaQ0VSK3d2VURkSU1tUE84a0pUU2FEM0tYV1hUWVpjKytnNnNG?=
 =?utf-8?B?UHZhSmg2UlZQWmhZanBRTzVZTGlmTnAzblNrbnRVNm5vN0lITktERW5nSWNZ?=
 =?utf-8?B?dS9JT0VCZ09pWWJ4b1ZsWVU5OW1MZDY0dVhRaGN0eGtYQzdSczQzZjNQTFBR?=
 =?utf-8?B?TXRxU09xVzhIQXV3TG0zQWlvV1UwTXppZnRaLzVVeGFnKzA5emNibysrdll4?=
 =?utf-8?B?MTZOY21CelBsY0FQT3VIOHc0UW8vaFB2d1BrdFdlUXQ3Tk9uU2lqeEhuRERy?=
 =?utf-8?B?VkVCSlhHRk5wSjVZcVFPVW5OKzlUVER6Y2k2dmxBRUY4cEdic2lrbHBSaW5s?=
 =?utf-8?B?TG52dE9VUHBQSWZtK2luYkZJUDBPWERLSDF6TUc0TTZXR1NicTVkbzNQTW1Q?=
 =?utf-8?B?Nk96R2xiZkIvcjhXU3B5aE9lbUhKSXBLVGZzWTVNSkFkTlZtU2NOWUJtdXZT?=
 =?utf-8?B?di9lODB6b2R0Q2h0RlZUcU1qNVlVdUo2TkNIN3VndjNEU0FFOStrKzRSaDRv?=
 =?utf-8?B?Y2R4N1hzU09Sd0RYOGpXMTZjR3U5VkZXamFOOE8vS2IwN3l4dllVR3dLd0lm?=
 =?utf-8?B?RkhZWnl1S2VtcmV5RUx0MHg2cVFPVlJWTWtFLzhnenhzbU8zbkpWb3kzY0hY?=
 =?utf-8?B?cTYvK01GeFlTOFRUMGhJbStGSG8rUjN0MU1hUHp0OVhCQ1RKbjQyM3AxRm0x?=
 =?utf-8?B?YzRJWFBReWp1NkJMYU5zOEVMS1VQdFNFbWtoUEhJQWRzVnNadHB5cGhCWW1v?=
 =?utf-8?B?M0d6ZDBUTDVOOFlHVzRiRmFLQ1pSNGtCVFgxVk4yOFZRUGZBV2dlN0FzZXZE?=
 =?utf-8?B?dzRBT3dmWFJPdU5jN05mWmpkdUxJZUxzdHZzYkJxL1A2M3JDRXpYLytuRFN2?=
 =?utf-8?B?SWN0ejd0WGszWjRsVm1uSC9pbG5vKzkzRG5pcnNNaGNVeWp0aUZyeVVYMElB?=
 =?utf-8?B?VVZWR0ljZEJjaHZrRlpxNnRhSFRFSjh4QlAvTC92ZnVXa0VwVm5iRm90eW0x?=
 =?utf-8?B?WUprV2JJR0hydUpkSEVEZkRYbDBCbUMyZFVZNGpjbUtlMDdlK2tiTkk4WTA0?=
 =?utf-8?B?VHdTTmp6VDB0UURnQ2ViaDlLb1VQdXRsU2xHb0pLaU8wOHUrKzRnRW1jdmxI?=
 =?utf-8?Q?hZkN+mWQxHthgZUfay7Nicrlk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f269c169-9ce6-4236-c01d-08dd5fe78b13
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 15:23:43.3474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dpUSlTQZnP5qx+uzX9txy7dZ3l7J6FJZXE0epec3YQvYM9ZiwqVh4kGgm5p1MastJdVwTnpzc2tYlazzyF9kDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6761

On 3/10/25 01:45, Nikunj A Dadhania wrote:
> Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests. Even if
> KVM attempts to emulate such writes, TSC calculation will ignore the

s/TSC calculation/the TSC calculation performed by hardware/

> TSC_SCALE and TSC_OFFSET present in the VMCB. Instead, it will use

s/present/values present/
s/VMCB. Instead, it will use/VMCB and instead use the/
> GUEST_TSC_SCALE and GUEST_TSC_OFFSET stored in the VMSA.

s/stored/values stored/

> 
> Additionally, incorporate a check for protected guest state to allow the
> VMM to initialize the TSC MSR.

I don't see this in the patch.

> 
> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>

With cleanup to the commit message and a formatting nit below:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/svm.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e65721db1f81..1652848b0240 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3161,6 +3161,25 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  
>  		svm->tsc_aux = data;
>  		break;
> +	case MSR_IA32_TSC:
> +		/*
> +		 * For Secure TSC enabled VM, do not emulate TSC write as the
> +		 * TSC calculation ignores the TSC_OFFSET and TSC_SCALE control
> +		 * fields.
> +		 *
> +		 * Guest writes: Record the error and return a #GP.
> +		 * Host writes are ignored.
> +		 */
> +		if (snp_secure_tsc_enabled(vcpu->kvm)) {
> +			if (!msr->host_initiated) {
> +				vcpu_unimpl(vcpu, "unimplemented IA32_TSC for Secure TSC\n");
> +				return 1;
> +			} else
> +				return 0;

You need "{" and "}" around this.

Thanks,
Tom

> +		}
> +
> +		ret = kvm_set_msr_common(vcpu, msr);
> +		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		if (!lbrv) {
>  			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);

