Return-Path: <kvm+bounces-47758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 952EFAC48B5
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CB021891284
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 06:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29DF51FBCB5;
	Tue, 27 May 2025 06:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i5xg/OgD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2066.outbound.protection.outlook.com [40.107.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1A41AA782
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 06:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748329015; cv=fail; b=A8uf8sn5xPvta6yrCw3m6uneqWu9MnTHSEzjaFDPiG3mmYoYT0arCqZcSjueA3kFKzn3lcz55hgn/2PS1Xc7ANfYBfGA9ZbJyyID6lrhsQKzu0BxOPS2pTaUbU0f2g8VQCWdHUHEhNsDV+6+wHjnYF6Q/M86tV1mHHfUJHVTaog=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748329015; c=relaxed/simple;
	bh=IKKNJSQQnF8FiPUaHsTkSUiUzAnZUZT495imiwZNsn8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kDu7C0G7ZZJejrt/561HK/vS4UQHC3qcmuL5AXnN4cNNBPZkVGYIHR6v4k9HoxK/CzPw10MCA8B47kuuLvapQqPkEJJkuIvf8wYV8LHAntAJXEbU+F2dzLctJEOM3FHUQtVTiLm6pi7PEpbXYLhtBdWRhASngptCD9zVK946NSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i5xg/OgD; arc=fail smtp.client-ip=40.107.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwRNwMHc/DMeQ8vBv7/gYRbYKWuZIIQRIDAB/O7Aa9uNYHXAuyv3LGLcwspZXkq6ru0oiJkg+orUYXiJA0U9M7x+c8odca0gWTaLjCXvWGNOOa/swBF3H/Eh3dUEqNyQbTXWY9nPC47ovbK+qCxp5UmSWTHYiS2Uhg6mgqtT5BvMffKr8VYdHioZQRAFdd6MbbQKU4SZR8zFFfwJ++MhgQHLB7L7ssF11ZbSDPMmpH2yG5dIpKz17hC8pdrDTpTYT03Pg9Fnw/4EeN3CsQEC3AQAr+xVL9RHSRszdO49JxcaVKvJSSWzS8cFgnfX5WfgFLTScVQfnXOwbIJbNJ7qYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OkjWsNla4lvx3CcuI6nBnIx5aZyySCTnZZ5dk6PYQ4s=;
 b=TJcAIpGlG6C7V2sBROJCizUeHoJCinvZwYFQ5frC0O7V46jEeW3QZlgGJ7htGekmCH954HnPdsiS52vJ2X5AJXxh+0nXcXT+jywnjKV9YvakfAcpeC89stzgqqk/EW2XjJXsflsV2lFzqrbIKLSFb/LSZhlMlMzwg/k0bHjrLqWW7JOZL0h754X9YZ4/d1vm2/U8N0KcQYnTO0lJL+i9kZRwnapPIuqaE3Fdj6hQOpQvr0vQVlCxXoy5a2NB80GnaZgNkAJiF70Fp0UzTc3l/Rs+U0dQeG2Ke0E1YjgZCJUgGNib2wgAtYIQhIHfacgfFDbY+vvWNCHu6J7+V3B8Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkjWsNla4lvx3CcuI6nBnIx5aZyySCTnZZ5dk6PYQ4s=;
 b=i5xg/OgDXUNjUYDCwtSm77u4R2MuFw4P3LjEUjmZHxpaP/ii+dpmRT3xe0LlRj1xCW9VjVE96XEKCcKnu0uC59t18GRn03is4eteFvLK7rrNZwpMiN4iHON2UX2lndXrarQ3v7ahevz8cD68AUq1+U8hh/vTh88pN5Xjj/ifXn8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB6752.namprd12.prod.outlook.com (2603:10b6:806:259::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 27 May
 2025 06:56:49 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 06:56:48 +0000
Message-ID: <902c6f8d-cd8e-44d4-8b1a-cf0f374ea300@amd.com>
Date: Tue, 27 May 2025 16:56:40 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v5 02/10] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-3-chenyi.qiang@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250520102856.132417-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY6PR01CA0087.ausprd01.prod.outlook.com
 (2603:10c6:10:110::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB6752:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db5b969-15e0-4719-e296-08dd9ceba6db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHpLUEp2UURScW1uNUcxc3BHcmhYZlJVcWlVZlI1S2FtNmFnVTlCRkU4aEJt?=
 =?utf-8?B?aW9ZNnRNTXIzbjlLc05NeVY2Ymptc1pkSUxXTnZ0c3AybllPb3M4RTY0L1Nn?=
 =?utf-8?B?SWtIYUZod1d2VXd6VFZJVXk4YUVKcitJWGYwREtLbXcrOWw2elpZN2ZITW42?=
 =?utf-8?B?ejJyaFljQklGKzB1MlROSkoyY0pCNW0veG9qdlZxU05aRkwva0VGam5NTGJN?=
 =?utf-8?B?TzE0VmhMTjBkMGU4bVZZSHdvR1U2Z3J2TzVOZnRnd1pHRkhuRTU0UmFwL0Zp?=
 =?utf-8?B?OXdFbmFsK3lmRjIzU2JDeEhmUmJidGpiOURiR2ttNGNJQ3RkckZMOHNBb0lS?=
 =?utf-8?B?bTI4V2ZTZXl6M1BEM3dBVVBXbjRseVlJR1VaLytlUzRsbEQrRTFNd3gyRkVi?=
 =?utf-8?B?Ymg5Y3hDMWRTV3pNNmNXRFl3Yi9pUjJ4RW5aRkVQUk5XbnVncS9WUXlMTlJW?=
 =?utf-8?B?YUpuZlVUK01ienROaVJJRE9IeUhiY2VZdzVOTlhDRlF1cG8xSEJhMjd0T0xL?=
 =?utf-8?B?Vy93a0Z6RllTN24rdUtNWERObVQ2WlUrL0ZJL2ZtaXgyR1B5eFBLMy95RG9l?=
 =?utf-8?B?UFhIaisxWW9Pb3VSN0lWc2ZSZzBIbnN2c3F1eTc4ZXpSbm1SczFRMGxDSkRV?=
 =?utf-8?B?VEdiM3RjTDNmRjQ0MG83b0pZTk5KcHBvRCtabHhyVWVzSUlvNEl0ZHdCSUJY?=
 =?utf-8?B?NzY1N3dXN0poVTU4SFRoTWdKNEFwS0JQSjVpZ3pET0M5a2RTbmp0TithSGNH?=
 =?utf-8?B?MW1Ldk9oazNkUEp1MmYvcldZdUNtN3JodWZDdjNZNThtdHJBa3o5NWxSaHgw?=
 =?utf-8?B?bS9KRlRMVWVNZWhUTTFqSVIzWHExSStPVjBtaWZTYTUxTTBEYytrL0FGNlVY?=
 =?utf-8?B?K0I5aTNGbGExM0hEWStaL2dkeWUzR0hHSG5CMW1aNzhDdkc5bmcxUUd0dmRQ?=
 =?utf-8?B?RWZUWjczRHcvZkdNUUpmcU5TbytOV0xjdGVYekxOSDFrcEFsRkhHa0RnV1Ja?=
 =?utf-8?B?YVFsRHVYcExFVmN5enFRQjA3UVhGcnhwcjlLMUlCS2ZzRnBtalo0aEVjS3A2?=
 =?utf-8?B?TEFDcGRFWmZIY3pTYXlDaWR0a1JvbWg0VUN4bHQ5TDZJRUxhNFBpZkN0L0w4?=
 =?utf-8?B?TkNUSFp3N1JoaHFqbXJHMVpTbGRzbGhBUzFVNzRqM3lBc1d1dTh3Y1hZL2R5?=
 =?utf-8?B?NXhjMGgya0dNVFlidVZ4aG1TaDh0VjNPd2RkR0VVekZFT0hQQjB0S1QvZ2t5?=
 =?utf-8?B?Z0dzZk9ZeTRTeisyM09VcTk3ZVFaeG4yLzZ6N2Y0cDlzTHR1QUtCUmpFc3BL?=
 =?utf-8?B?MDB2bkZWaGhwRXdkb0hSMWRQWStsWjF1L0FBbEFGYTVlR2tNczJaNXVadUZi?=
 =?utf-8?B?VlRPOXptcWxwVHhCUU9kNFZRK1FrRDVvUnZRT0hIQVVVcVFoNEdCMUtRS20v?=
 =?utf-8?B?V2dieTZIMFUrTHpTa0FHQzlqdEs3MCtiRTVDY0tOQm0wczk0VHJJOFBTS04r?=
 =?utf-8?B?dGVrUHBZY29PMkxSaFl4SjZJbHdjRXJXMm85VE4wYlhkYUJmYUtZeXNRbzJz?=
 =?utf-8?B?VUQvSy80SmxlVEZLUGNRWEkySXNJMnZMMEtlOVVRN2Q0b2xRbzg5NTdhSTZx?=
 =?utf-8?B?RnFVeTQxT0tlcHViT0dBTDNKdEY2OU9JZDBNL1dic3hFbi9VR0tTR3A0czVh?=
 =?utf-8?B?M08wbUo0Z0xGcFp3d3hQU1Z3RFRIcFJ2eS9LYmhienljNzkvL0NMbnBOaHpN?=
 =?utf-8?B?cVVyMHI2dTZkVGtxNmxJSkNpclNVVFpxd0J4bTZWUXZuMHFOTGtXdGdVYWdj?=
 =?utf-8?B?TG5rV1diNXY5SVlxNnhzOTZVVURSSXkrOEtiYkdvUy9tQ28xNlZmTmprRzl5?=
 =?utf-8?B?QTVCWC9KbmIrcksxYjNaL3loN3cwODlSYWVVMGJWWngyWkN3dVRvSlh5WVNO?=
 =?utf-8?Q?vii/rduZk+Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnE0SHFPN0ZtUHg4aGVSL2FNek1VZC9reGg5Ry82VHRZM1htcTlKNGpiRXd1?=
 =?utf-8?B?RFJLNVVnNytCYTZ2Q1V6eEFRS3RVd2gyTzFLeG8xUWh2RGpad2FtYlFya1Nx?=
 =?utf-8?B?SlpWTEgzNXk5Zm9RY2p2YUpYRi9GQkxBRklTN3dvTFpYYkJFeFFpd2U5QlYx?=
 =?utf-8?B?bHI1YWQxWG0yTGRMNjBMbFZhZmhWeFhVUjhsZnNiNmFaUTg5Y0w4MXF5Wnly?=
 =?utf-8?B?N3Vrc2V4UkRhcTVoSjZVaDBwNWpzMTI2V3R4NVBOVWJBWnZxYVlzemF3aTkw?=
 =?utf-8?B?eC90MlpUcFNrS2x2d3kyL3FwYzNHZVVwMEtGVDB2ODhBaFZTZlg3My9mYSsw?=
 =?utf-8?B?TGxMVlJwZ0ZpNWxmVnRNWnNDeDRWalpZUVh2RDZPRFEzOUV0U2s5V3FMaVQz?=
 =?utf-8?B?cVN1YTBudTgzakZqUjkzd3I2eGIxNkY3YnYxZTIrRWtUT2dpbHREM3Z2Y0po?=
 =?utf-8?B?UEhSM2VDZ3daeE1NMys3bmg3cTFFNi9wTlJReGJRN0pGYjBWVWFJR1hZMWpE?=
 =?utf-8?B?OWpGTFJyTDh0bUR2QXN1RUFOdFJvU0QwK0Zqb1U5YVNudVdtWGFpUklqL2tY?=
 =?utf-8?B?ckhsWk5WYXBxVDRwQjJhaWJaZFgvN1VRc0kyNjBjeGltTFF1eGZIZkFPdlR6?=
 =?utf-8?B?MGtXMHBGQ3NYUFFpYUtPYmxqbXhycjF3WmJJTnlnQWphRzFoV0lIN3JGK1NS?=
 =?utf-8?B?Znd0VU5Mc3JuZWNPRFRBUzdTVkdXdUpMRUhWeEFBcTZUM2U0cCsyUXZuQ29T?=
 =?utf-8?B?ZkJsOC9SdTFzOSs2SDJHWSs3YWFtTk90MUd5ck5YV3hvUVJaL0R0djFvNURt?=
 =?utf-8?B?ek9QZmlvUUlhYjg2Wkd5M3I1U3pZYjlKTzMxcHliYm9oOGxnTmRvVEl3anNM?=
 =?utf-8?B?eVB1bFI3WlRHQlFqMXpYcWFzVkJhcGlPVXdNTUZ6QnJaaEpHQXNDaUVaOHJC?=
 =?utf-8?B?N0VFRC96NU14bHRZOGFQRmc3NWQ5dUlZRktuZFlZM1BRckdyd1ZsVWw0WDNI?=
 =?utf-8?B?ZW5ORnBFZm1MQVkwKzBGQ2J6SkZNR1NaYWdqSWQ4M2tvNUpaK1RYQ0IyL2F4?=
 =?utf-8?B?bzBZZVdlakdKN1VQTnJyODJDSEMvTERaNE9UVzJmZHIrM1ViNXRxV1RRQW0v?=
 =?utf-8?B?RXByay9peHdLU256Z04zU3pZc2cxZE1FalVyd2w5RDZhS0gwSUQ2SFlaRjhw?=
 =?utf-8?B?bFR1dm8rcWFaTHJ5RWFqRkswemlSNFBsUWlQZnF0YkhEUlpCeEJhUG92Q3F0?=
 =?utf-8?B?aHlVT1poSXRSMkZNSGs2amNjU3dLTFB6U1QwQllvMlJUNjBaWklWMjIycnlM?=
 =?utf-8?B?VmVnZ3ZsVjFlU3RNTHRZTjJoYUd0c0dJUitPOFd4azJVVVBTREtKSXhBYjFR?=
 =?utf-8?B?aFlCc29hRklwZjE0Z3RqL1ZwcE9MUWg0ZHFRM2ZHTVduTTFER0dxVm5QNU12?=
 =?utf-8?B?empvcm1jWU1XMWZoZjBJUmtrd25SMDJrbGtwQk8ya0dOVnRaTWY3dUgxRWhP?=
 =?utf-8?B?ZTVSMUxxYS9SQ3VRR3MzRGN0UTh0QWQxVDcvUzg0MGpOWUFmandLWXY1Zm94?=
 =?utf-8?B?d1FnQysyd1lQVkZhRzZvSUd5ZWdXOWpBK2VHMlhhWExZUXF1MjMzTGhmdHBz?=
 =?utf-8?B?UWVnaXFJNEVYWkpKbnFzOU9TeElTWGwrNWdwNE8vL09iVXJ0a1JiUFArQ1VY?=
 =?utf-8?B?TVdyR25BYnprV01oRE1nUnR2azgvYnRiUlRDbElyNW01b0daSE0zdzQ2TEF2?=
 =?utf-8?B?c01FWVpMb2ZHVEd0RGllNVdic28raFlnQWNXdVV1YnNLMWp2TjdES1N2TFRv?=
 =?utf-8?B?OVVGR1ZLN24wTWtZVVAyTkFrWEpiVDdpWk10aVZuNmd3dmp6WVFtelZXRkRE?=
 =?utf-8?B?VjE1ZjFjRFV2VENPSTNQbkI3bEowWWUvTzlOdityTHRydDB3MHo1QjlvRmVv?=
 =?utf-8?B?ek9uUzFuZjU2bzZldk9EbmxrWmd2RTN6YjhBWmhYd1plQjkwa2FyNll0YUE4?=
 =?utf-8?B?OUI3QlRqUXEzclBZdTFqb1ZmTkhRSHlOL1VDdTUwWkpFTlpTOFdwUEVTaFhE?=
 =?utf-8?B?NGFqalFwVDl5WkpSUTh3MnUvN0dqQlRVOHR0ZCtNbXZhNEJEK0ZkR2x2MXlZ?=
 =?utf-8?Q?dmZkfj4W7fhIbankXTIaaG0SC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db5b969-15e0-4719-e296-08dd9ceba6db
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 06:56:48.8633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0tsacmZ3hfUo2nuW919jBJb0F8pl8ICmpogYkwt0QVEe2QJ7iQa8fJNQMsGAHzakQ1n97zG0voyQJi5t7Hk/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6752



On 20/5/25 20:28, Chenyi Qiang wrote:
> Modify memory_region_set_ram_discard_manager() to return -EBUSY if a
> RamDiscardManager is already set in the MemoryRegion. The caller must
> handle this failure, such as having virtio-mem undo its actions and fail
> the realize() process. Opportunistically move the call earlier to avoid
> complex error handling.
> 
> This change is beneficial when introducing a new RamDiscardManager
> instance besides virtio-mem. After
> ram_block_coordinated_discard_require(true) unlocks all
> RamDiscardManager instances, only one instance is allowed to be set for
> one MemoryRegion at present.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v5:
>      - Nit in commit message (return false -> -EBUSY)
>      - Add set_ram_discard_manager(NULL) when ram_block_discard_range()
>        fails.

Reviewed-by: Alexey Kardashevskiy <aik@amd.com>


> 
> Changes in v4:
>      - No change.
> 
> Changes in v3:
>      - Move set_ram_discard_manager() up to avoid a g_free()
>      - Clean up set_ram_discard_manager() definition
> 
> Changes in v2:
>      - newly added.
> ---
>   hw/virtio/virtio-mem.c  | 30 +++++++++++++++++-------------
>   include/system/memory.h |  6 +++---
>   system/memory.c         | 10 +++++++---
>   3 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index b3c126ea1e..2e491e8c44 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -1047,6 +1047,17 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> +    /*
> +     * Set ourselves as RamDiscardManager before the plug handler maps the
> +     * memory region and exposes it via an address space.
> +     */
> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> +                                              RAM_DISCARD_MANAGER(vmem))) {
> +        error_setg(errp, "Failed to set RamDiscardManager");
> +        ram_block_coordinated_discard_require(false);
> +        return;
> +    }
> +
>       /*
>        * We don't know at this point whether shared RAM is migrated using
>        * QEMU or migrated using the file content. "x-ignore-shared" will be
> @@ -1061,6 +1072,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>           ret = ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb));
>           if (ret) {
>               error_setg_errno(errp, -ret, "Unexpected error discarding RAM");
> +            memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>               ram_block_coordinated_discard_require(false);
>               return;
>           }
> @@ -1122,13 +1134,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>       vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>       vmem->system_reset->vmem = vmem;
>       qemu_register_resettable(obj);
> -
> -    /*
> -     * Set ourselves as RamDiscardManager before the plug handler maps the
> -     * memory region and exposes it via an address space.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> -                                          RAM_DISCARD_MANAGER(vmem));
>   }
>   
>   static void virtio_mem_device_unrealize(DeviceState *dev)
> @@ -1136,12 +1141,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>       VirtIOMEM *vmem = VIRTIO_MEM(dev);
>   
> -    /*
> -     * The unplug handler unmapped the memory region, it cannot be
> -     * found via an address space anymore. Unset ourselves.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
> -
>       qemu_unregister_resettable(OBJECT(vmem->system_reset));
>       object_unref(OBJECT(vmem->system_reset));
>   
> @@ -1154,6 +1153,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       virtio_del_queue(vdev, 0);
>       virtio_cleanup(vdev);
>       g_free(vmem->bitmap);
> +    /*
> +     * The unplug handler unmapped the memory region, it cannot be
> +     * found via an address space anymore. Unset ourselves.
> +     */
> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>       ram_block_coordinated_discard_require(false);
>   }
>   
> diff --git a/include/system/memory.h b/include/system/memory.h
> index b961c4076a..896948deb1 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -2499,13 +2499,13 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
>    *
>    * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
>    * that does not cover RAM, or a #MemoryRegion that already has a
> - * #RamDiscardManager assigned.
> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>    *
>    * @mr: the #MemoryRegion
>    * @rdm: #RamDiscardManager to set
>    */
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm);
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm);
>   
>   /**
>    * memory_region_find: translate an address/size relative to a
> diff --git a/system/memory.c b/system/memory.c
> index 63b983efcd..b45b508dce 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2106,12 +2106,16 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>       return mr->rdm;
>   }
>   
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm)
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm)
>   {
>       g_assert(memory_region_is_ram(mr));
> -    g_assert(!rdm || !mr->rdm);
> +    if (mr->rdm && rdm) {
> +        return -EBUSY;
> +    }
> +
>       mr->rdm = rdm;
> +    return 0;
>   }
>   
>   uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,

-- 
Alexey


