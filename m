Return-Path: <kvm+bounces-47764-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 196FCAC49D2
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 10:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E6701881CEA
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:02:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E79323DEB6;
	Tue, 27 May 2025 08:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QW6+IwHh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F1B35973
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 08:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748332900; cv=fail; b=p6A1nEWx7v5oW6T5UItWXJRgHKZU4z1hAwqRM50DaQbAw6E//AQWke4lV0G9hOw6JdXTBSYzNQzl/yQLb0NKrsZRVEgbmFp0jlMKqjKE0GDnhqcTvyvgkXzXzusvTbFPWvyvzPeNf9rOX3QXP56tBws1l7EsF9S6jM1xhvF29zA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748332900; c=relaxed/simple;
	bh=5gdNHv7sJihecIRFkQqEEAmHONarqIsowzhsIdWcL34=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=p2FLOJC1ajXbgFym5Q8e/cRGlVWNEz8+uGlB8zFhrUD4ydg7p3eMU1G1Szut0hsEH2lCkrG9HbhstQt9mBjcAwm7p/eGPQXmb1LqkSa8aDH26uYASzeaYZIC4pcT9OrUGaQAml6xgJI//AOGcjzGeOkx/JbP/GADK6ayy/wrGvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QW6+IwHh; arc=fail smtp.client-ip=40.107.92.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fG1tCOeKJJ+coi/9/OhGq0lpxTt58bX/C5i1aYkavjY3P0UxWD5nIC+y+aqZef0zKGQuDyeqoSN56RfkDKA6a634dG1bkt6HA596yyvXOX+AKUDdHINvFzVb/tVsPLjupJOevVYiST0IX1z0sL8VusxXUyPGG7oefu9l8GUZJHGs7kvjqC9tTIdn2yD0sJ7Gmj6K7ZQrVX0kaa3T7Ej0mviRXiztfblvM/+NuM4GkohV9y58iJVV/y/SEvMjQbglcLBRdf5B6o1QFV3xjnEDs2O7acTnM1uc+9zq228Xor8VNiwHNJ8rDhcKLUfpKErW7RNO5Vi279pYtkWGrCYeHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMSQUhlOMH4ztAw2FWDdTKslV+d7QstuuoCLOzEAPUs=;
 b=f/Fftj+O/NVhZGyAMpcoMStynoh/eTNNAblS9GJLCPyM+tVD4kTwk7Euq8SjeSfdvwPwM/pAmKT6iWg5Sx0k4L+djMAhj12QFuLl6xYO18aVuYSPkwgOAfxLqQlS4FuRVX2/7oLte1Ri8FSyLW3XV1+wsb7a3NjuuCM9DP9fjWez+xuXMOlBH+HTazMakRX7nzOPW2GQyqltC1J0VaZeht446HXzq7APul/OItI070HJjzgxFeEYYLhLOQ0BlRK7IDxJlS6ImACeEy4ys4paV+2Gq9SR0/NdHpkqx9qXVF6IKs1BH9GMsRJEOdpovZiSeBjkkHJbFTjDh1Q671kiBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMSQUhlOMH4ztAw2FWDdTKslV+d7QstuuoCLOzEAPUs=;
 b=QW6+IwHhddwkf71tl5d+E7wdFURJGR/bBvoXwVCd3GMq/8UWifDDFFtWhaMTD+ygSEkqTshfaCSCbUnV8NipN351is5AcQw/DDlqAituSkleYnX+31/3+Y5ZFd4/75uSbQWNSYJSt5EucfmCYkuv7+I2XhgpIQl3RIEbtwB2zEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DM4PR12MB7549.namprd12.prod.outlook.com (2603:10b6:8:10f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Tue, 27 May
 2025 08:01:35 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 08:01:35 +0000
Message-ID: <577cff65-bc20-48f1-a776-999ee96a7035@amd.com>
Date: Tue, 27 May 2025 18:01:27 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v5 09/10] KVM: Introduce RamDiscardListener for attribute
 changes during memory conversions
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
 <20250520102856.132417-10-chenyi.qiang@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250520102856.132417-10-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY0PR01CA0003.ausprd01.prod.outlook.com
 (2603:10c6:10:1bb::13) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DM4PR12MB7549:EE_
X-MS-Office365-Filtering-Correlation-Id: a9113510-d88e-43af-851a-08dd9cf4b340
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b2srZ05ZT1ZqbGVrV0c2bnhjdDg2anZUT2p5M2FyalQwQk1vTFlaaElqUHhG?=
 =?utf-8?B?OCsrUHBWOTJyU3VqMExLRlpTVy9kSEdOaGV5NzFMS3kzejBjR1VxWmc0T3gw?=
 =?utf-8?B?Z3cyVk01c054VHB4UVlxcUNZbWFBQlJFa0hIZ1hqeFVXM3NoMWVhTmNJb0FZ?=
 =?utf-8?B?UnJlczBRd2hzMDg5TkhMd2s3MFZDdW1QN1NyWTEvVzlkZWVieEdaekRmTnM0?=
 =?utf-8?B?WnM5WVFXbUM5L0dqcmdpaHF2dTN3eGF2Z0YrbzB1aWwyZDNjL1RYVmNyNUFk?=
 =?utf-8?B?cHd4T0NndnhkaXlBamNYRlVwTWJkMTVmYWRqUnBUWTFIR3NFWWZJM1RleWlY?=
 =?utf-8?B?blpOM24ra1ZHOHlFREo0SWE2cjJ3d1lKcFVPTXBRd1FySjVNNWJleW5HQmNm?=
 =?utf-8?B?OU9OelQrUjFoeEFSYkVmNHZxOGlhYUhGNytRR1FSeGFDNFpKU2hyRXdMdUsz?=
 =?utf-8?B?YUNRdm9XSEUzR1FCTURtaks0RFVmQVR1ZjdNbG5vM1FubjRHaWlWSVFRdjd4?=
 =?utf-8?B?M0owKzNKcGFTYTFxY3FpbkU5cHJkNTdXL1R0WVJkVVRxdGY0bDVsajY2UEto?=
 =?utf-8?B?MTVpKzEzREJVMlV3V0hhRkxjeTNLZjJqU0lUb2FiQlhnTkhEd0gxNWtFeFBI?=
 =?utf-8?B?ZXZZRlh5Y1lvZlI5b2k2WFpHM29CR0R5eE41QURoV3ZPTWxqamRkUDM5THJL?=
 =?utf-8?B?akw2b0Ntd09LUjdnZUMwUG1DT004ZFE4UC84Y2hDZUhwN09YdVNRS2ZHZVpJ?=
 =?utf-8?B?U1llZXk0ODE5eDdBRDZ3VjMxd09QU3lGTG8vQXdRRXZxSU9sakFqSUMyMUFS?=
 =?utf-8?B?d01RWWJPRFNuS2FXRnhzZjZhaTREZHh6M1UxNGpRUWYxL25ya2d3N1R5RFNG?=
 =?utf-8?B?MHFVRWpmUmNUTEt6NUdWc0hja2kzNmhKRVNzMlIzZVZJLzEwRC9sOEo0RW1h?=
 =?utf-8?B?bm5udGJXdmtPY09nQkFXa2U0RzhkVmQ3OC9CMDRpU2tzNW84cWpPdDB1YVJj?=
 =?utf-8?B?NGM3ZlY4SHNlKzNzMEhpeWIvb0lERC9ESE1SM0EyU2xzc0VTZ2dnNXdsN051?=
 =?utf-8?B?K2NXd2l3cWhxWFk5MjZ3S2tTQlZDVFdJdGlaOGQ5ZENHRzY3ektKSm5iL1RH?=
 =?utf-8?B?MlUvR0JBQ1Y2WHJxVlV0WlRzS00wcnNlaXQzVURmc3J2Yzlvc0pMSS9rTmM3?=
 =?utf-8?B?QlJlakNiUEFQWkFYZGJ3STd2SWNXUzdrdDR3dDVMOHRJd0hvNGZzZVNEL1Rq?=
 =?utf-8?B?MEFhcUQ0QXJSb2tlVXVEZzNuY3l0bVNZN1J1N25pYmhTcUxNcUxEZVZvMmxL?=
 =?utf-8?B?Sk9Yb3AvN1VUT1hYSWV3ZFovaWhGckFCK0tEdGlzd0FMRzliWk4rL2tidzV5?=
 =?utf-8?B?Z29CblZybjJ5YlZKUFhzaHFIcFZCZW5iUEdRZnZLU2lYTXVHQUd5MGo5MzV5?=
 =?utf-8?B?NEJnQ0ZSbVZzcGhJUjVXNkY4am1qYjRrWXoyb1AxMVBLMEYzQnIzdHJBd2JH?=
 =?utf-8?B?V1NCeHN0TmN1RUNTV3pEMTk3dWhNYlpBcVpHcFpER1pXbkFWd1Bic0x2T0F0?=
 =?utf-8?B?dURKSEw4Z0htL3FmVjkvUWlNR0V1ZDh4YVNQUUFkN0RJRzkxSmY5UVZheUJw?=
 =?utf-8?B?ZDZqRUhqWWN5WE42MHVoTDN2TDdxclZ1N21aQ1VvMXhSVWhrd1JEV1dsM0cz?=
 =?utf-8?B?eUE4aC84TXhPTEgvZTUyQmQ1RlNPN3haYkF2UHI5UWFTbEQvRndPNGZDZzBG?=
 =?utf-8?B?TDV0SHJBanBQdDVPVWhJc0hUcWQ0Q1JSVzdPVHJEZTdEUHhncGtRb252bVRB?=
 =?utf-8?B?RnNiTWZLakFFaWdUejh2VWhKWm1ISk1SOS9Bbyt3N1FycklJd3BmVnhXVys1?=
 =?utf-8?B?ZlZjaWorL3V6bkR1NUNVSVlvSDA4bzVQdEw5d1daRVZSajFwc1VUbmhUcS9w?=
 =?utf-8?Q?tQugehPzhNc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkcrVGQ0elZJUFFCTnB3dllrdTRJUVR2Nm0vaDQxR2hTWlF2UVhLSU0xTkpM?=
 =?utf-8?B?T3BmTGl6M3RrajdBTmFRYXowTWNvWStTV2JBM2RLSWwvaEIreUoyZy82RjB3?=
 =?utf-8?B?Uk1GaGJudWVYSFNlODNNb2NyZk1QN3JyRldTWHZ0ZDdhWlk5eDVsTVQ0ZXRN?=
 =?utf-8?B?WmNwM0pHd3M4aGFNWjgwd0F2VEZNc3NoTCs3WThUaEFWSE5GeFJReEVMSzk1?=
 =?utf-8?B?eXVTSEZkRFBFYkxiZXZHaHAvK1I4VVFFZmtlSDJ6L2xId2FURUxWSGE1V3lr?=
 =?utf-8?B?dGE4dm9ObGlLZDllMElmWXdmb05HaVU1REt3NXh6Q1BvTmJ6bUpVYW5uR0FU?=
 =?utf-8?B?ZHJWOEtoelh0cmhuck9iakNjaE9YaVJGbHU5Z1JMQjlZZTVOanBnVDB1U0hL?=
 =?utf-8?B?Uk5jT3BmWkxQeGgyMGc0ODZudzJJWEJiVjREVnhuVDNKS2pGTkpPRlRUT1cr?=
 =?utf-8?B?dFRrZE1NQ282a2c0NEpwY2cvOERhdlZJc1FPVTYrVFJwVGl3R2srZjB2NGZD?=
 =?utf-8?B?RElZUnpoNDJkUEc5Sm5uelBYZEdYOW81L09jUGt1RU5Bd2diMU43ZEZhK1RR?=
 =?utf-8?B?aXcya3pCOXkyU21SZ3NjaCtGeFd0N200ZlVEV1pyQ2U4VkV2QnJTUCttaEtm?=
 =?utf-8?B?ZEJVQzkyeE1mQVlQNVFXaEIwekZjV1FqNkQ4aEU3L3ZmVHhITklNMXpraE5D?=
 =?utf-8?B?WlFtOVlReGxMSXA5bC9CWTBaUlBrSDlZdjhpNW9hY2M3VXprNjNMY0xES2d6?=
 =?utf-8?B?MFRTckNnMFNidlZDVkFKODJ6SGxidzA5bmZOby8rM2xTSnJtVVYvMWZZRjJX?=
 =?utf-8?B?bUFLZjkvSzJPa0dzakpnR0lvM0VDN1dVaHUvZnltcHUrSVRiWEJUdVVGcXc4?=
 =?utf-8?B?WlZ5Y1VMQnNzRU5tWWoxb3hiMWJaeUoyTU9oclJPNWhsVVlCVnYxOFdJWSt6?=
 =?utf-8?B?WWJkdUNTTGFJblVMUzNuUU1xWk1oL1R6Y241OFF5TU1CQWdqd0NiK1E5Rlpv?=
 =?utf-8?B?QWMvRFhwNmY3bkVIQ1Z3SS9Hb256d3BCa1dTVGZpUlNTRDhIby9oSmZ1cFhz?=
 =?utf-8?B?QzJQakVBd3lsN1psTkxLR3UxZzI4Um0rZUNDZVVhcXF3Q2FBV2pYbi9sZnlM?=
 =?utf-8?B?b0tuS08xZGJDYUlFWHFsamRnNHZ1WHZMc1NCVWxFZ3pBakRyUGNpZG1BUDZh?=
 =?utf-8?B?WjNoa3EwK1kwWHphWmdFcnpLOGxFME51bkRrZ1F4OG4yYWxnSmtqMnlwZnBM?=
 =?utf-8?B?SGh2Y25EalVrZkdzd3pMZVRMU2ZzRXhENTBzQWphZTlTU29XZVRCQUlCQ2RL?=
 =?utf-8?B?b2JxbFhabWc0T2tXZDdUSGdCTk9XQjBUZGM0dUszdVphWGpka1pJZVZITzly?=
 =?utf-8?B?cU9HT0JGL2I5RTdIYXl4bUVKU0Y1cDRLZmJxTFoyQXdKUXZvcTdOOGpGaTZx?=
 =?utf-8?B?dmZ2L1p1Y1ZVQXYwWlRxcFhNZWZJek9mZXphYjhGZVdNM1VPWlU4RFV3S080?=
 =?utf-8?B?OWVWbUFGSEl1WTNQYTZHYkVYMFduRGt1UHlhSGdybWZLdHN2NGtGa2ViMVFw?=
 =?utf-8?B?SWVyOERNdDN3MndHOXlpZXlobUlmVGp4RG02aldtUTI3eVJieWhidU1aTC8r?=
 =?utf-8?B?SVRQdGEzTUFjR0xkN1BlNUx6QWdHdm1MeHA0SHE4aHdFOW43NlppbiszS1NK?=
 =?utf-8?B?M1FOZWIxT2V6SVNaOFBXRjNpRUJUWHk1UFlKcGlKYVR1Vy9JUDFKZmV3alhx?=
 =?utf-8?B?dnpjT09RTkJKVUM1b1J3VGVKRkc0dFJneVZLaXFxWElpV0NaaEhpdm1OTUpO?=
 =?utf-8?B?aDU5em91MHhVOUJ3MjFLR3JPL3dzL3Jza2lTc0RYeUVHdm5WSXl2QmtCSmor?=
 =?utf-8?B?dkxCNk0xSGhsTHpsd1lDZjJOelRnZUhaRk82ajNJNXl4RDhCYkxqZU51QUxk?=
 =?utf-8?B?ZUZUWXp0NFYyTS8va1VYQ3dFK1dqMHV6V3Y1K0hRaXdQbmhBci90YTRQWkY0?=
 =?utf-8?B?NFRzZXdCWEVSM2t3N0loSU4xM2YwYmE4MHBFQWU2dVdndHpYbmJ4N0dOVkVW?=
 =?utf-8?B?RHhSeERCOGwvRVJjZkRaRmVDYkVUL0d3SUg2QXE0UHloWlN0SGNPWlVJYWxx?=
 =?utf-8?Q?jJ53FMg+MG5excSP6hgxEbsHY?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9113510-d88e-43af-851a-08dd9cf4b340
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 08:01:35.1343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u8JdOUD+E1EGs9og1xQfK5Pm9CcrhqmOBRyVIHm8YHEBfFAabGU3a59CzC+bSThkbR0BmhAvabBtqb5MJLtMJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7549



On 20/5/25 20:28, Chenyi Qiang wrote:
> With the introduction of the RamBlockAttribute object to manage
> RAMBlocks with guest_memfd, it is more elegant to move KVM set attribute
> into a RamDiscardListener.
> 
> The KVM attribute change RamDiscardListener is registered/unregistered
> for each memory region section during kvm_region_add/del(). The listener
> handler performs attribute change upon receiving notifications from
> ram_block_attribute_state_change() calls. After this change, the
> operations in kvm_convert_memory() can be removed.
> 
> Note that, errors can be returned in
> ram_block_attribute_notify_to_discard() by KVM attribute changes,
> although it is currently unlikely to happen. With in-place conversion
> guest_memfd in the future, it would be more likely to encounter errors
> and require error handling. For now, simply return the result, and
> kvm_convert_memory() will cause QEMU to quit if any issue arises.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v5:
>      - Revert to use RamDiscardListener
> 
> Changes in v4:
>      - Newly added.
> ---
>   accel/kvm/kvm-all.c                         | 72 ++++++++++++++++++---
>   include/system/confidential-guest-support.h |  9 +++
>   system/ram-block-attribute.c                | 16 +++--
>   target/i386/kvm/tdx.c                       |  1 +
>   target/i386/sev.c                           |  1 +

imho this diffstat disagrees with the "more elegant" :)
+1 for ditching it from this patchset. Thanks,


>   5 files changed, 85 insertions(+), 14 deletions(-)
> 
> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
> index 2d7ecaeb6a..ca4ef8062b 100644
> --- a/accel/kvm/kvm-all.c
> +++ b/accel/kvm/kvm-all.c
> @@ -49,6 +49,7 @@
>   #include "kvm-cpus.h"
>   #include "system/dirtylimit.h"
>   #include "qemu/range.h"
> +#include "system/confidential-guest-support.h"
>   
>   #include "hw/boards.h"
>   #include "system/stats.h"
> @@ -1689,28 +1690,90 @@ static int kvm_dirty_ring_init(KVMState *s)
>       return 0;
>   }
>   
> +static int kvm_private_shared_notify(RamDiscardListener *rdl,
> +                                     MemoryRegionSection *section,
> +                                     bool to_private)
> +{
> +    hwaddr start = section->offset_within_address_space;
> +    hwaddr size = section->size;
> +
> +    if (to_private) {
> +        return kvm_set_memory_attributes_private(start, size);
> +    } else {
> +        return kvm_set_memory_attributes_shared(start, size);
> +    }
> +}
> +
> +static int kvm_ram_discard_notify_to_shared(RamDiscardListener *rdl,
> +                                            MemoryRegionSection *section)
> +{
> +    return kvm_private_shared_notify(rdl, section, false);
> +}
> +
> +static int kvm_ram_discard_notify_to_private(RamDiscardListener *rdl,
> +                                             MemoryRegionSection *section)
> +{
> +    return kvm_private_shared_notify(rdl, section, true);
> +}
> +
>   static void kvm_region_add(MemoryListener *listener,
>                              MemoryRegionSection *section)
>   {
>       KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
> +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> +    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
>       KVMMemoryUpdate *update;
> +    CGSRamDiscardListener *crdl;
> +    RamDiscardListener *rdl;
> +
>   
>       update = g_new0(KVMMemoryUpdate, 1);
>       update->section = *section;
>   
>       QSIMPLEQ_INSERT_TAIL(&kml->transaction_add, update, next);
> +
> +    if (!memory_region_has_guest_memfd(section->mr) || !rdm) {
> +        return;
> +    }
> +
> +    crdl = g_new0(CGSRamDiscardListener, 1);
> +    crdl->mr = section->mr;
> +    crdl->offset_within_address_space = section->offset_within_address_space;
> +    rdl = &crdl->listener;
> +    QLIST_INSERT_HEAD(&cgs->cgs_rdl_list, crdl, next);
> +    ram_discard_listener_init(rdl, kvm_ram_discard_notify_to_shared,
> +                              kvm_ram_discard_notify_to_private, true);
> +    ram_discard_manager_register_listener(rdm, rdl, section);
>   }
>   
>   static void kvm_region_del(MemoryListener *listener,
>                              MemoryRegionSection *section)
>   {
>       KVMMemoryListener *kml = container_of(listener, KVMMemoryListener, listener);
> +    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
> +    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
>       KVMMemoryUpdate *update;
> +    CGSRamDiscardListener *crdl;
> +    RamDiscardListener *rdl;
>   
>       update = g_new0(KVMMemoryUpdate, 1);
>       update->section = *section;
>   
>       QSIMPLEQ_INSERT_TAIL(&kml->transaction_del, update, next);
> +    if (!memory_region_has_guest_memfd(section->mr) || !rdm) {
> +        return;
> +    }
> +
> +    QLIST_FOREACH(crdl, &cgs->cgs_rdl_list, next) {
> +        if (crdl->mr == section->mr &&
> +            crdl->offset_within_address_space == section->offset_within_address_space) {
> +            rdl = &crdl->listener;
> +            ram_discard_manager_unregister_listener(rdm, rdl);
> +            QLIST_REMOVE(crdl, next);
> +            g_free(crdl);
> +            break;
> +        }
> +    }
>   }
>   
>   static void kvm_region_commit(MemoryListener *listener)
> @@ -3077,15 +3140,6 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
>           goto out_unref;
>       }
>   
> -    if (to_private) {
> -        ret = kvm_set_memory_attributes_private(start, size);
> -    } else {
> -        ret = kvm_set_memory_attributes_shared(start, size);
> -    }
> -    if (ret) {
> -        goto out_unref;
> -    }
> -
>       addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
>       rb = qemu_ram_block_from_host(addr, false, &offset);
>   
> diff --git a/include/system/confidential-guest-support.h b/include/system/confidential-guest-support.h
> index ea46b50c56..974abdbf6b 100644
> --- a/include/system/confidential-guest-support.h
> +++ b/include/system/confidential-guest-support.h
> @@ -19,12 +19,19 @@
>   #define QEMU_CONFIDENTIAL_GUEST_SUPPORT_H
>   
>   #include "qom/object.h"
> +#include "system/memory.h"
>   
>   #define TYPE_CONFIDENTIAL_GUEST_SUPPORT "confidential-guest-support"
>   OBJECT_DECLARE_TYPE(ConfidentialGuestSupport,
>                       ConfidentialGuestSupportClass,
>                       CONFIDENTIAL_GUEST_SUPPORT)
>   
> +typedef struct CGSRamDiscardListener {
> +    MemoryRegion *mr;
> +    hwaddr offset_within_address_space;
> +    RamDiscardListener listener;
> +    QLIST_ENTRY(CGSRamDiscardListener) next;
> +} CGSRamDiscardListener;
>   
>   struct ConfidentialGuestSupport {
>       Object parent;
> @@ -34,6 +41,8 @@ struct ConfidentialGuestSupport {
>        */
>       bool require_guest_memfd;
>   
> +    QLIST_HEAD(, CGSRamDiscardListener) cgs_rdl_list;
> +
>       /*
>        * ready: flag set by CGS initialization code once it's ready to
>        *        start executing instructions in a potentially-secure
> diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
> index 896c3d7543..387501b569 100644
> --- a/system/ram-block-attribute.c
> +++ b/system/ram-block-attribute.c
> @@ -274,11 +274,12 @@ static bool ram_block_attribute_is_valid_range(RamBlockAttribute *attr,
>       return true;
>   }
>   
> -static void ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
> -                                                  uint64_t offset,
> -                                                  uint64_t size)
> +static int ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
> +                                                 uint64_t offset,
> +                                                 uint64_t size)
>   {
>       RamDiscardListener *rdl;
> +    int ret = 0;
>   
>       QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>           MemoryRegionSection tmp = *rdl->section;
> @@ -286,8 +287,13 @@ static void ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
>           if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
> -        rdl->notify_discard(rdl, &tmp);
> +        ret = rdl->notify_discard(rdl, &tmp);
> +        if (ret) {
> +            break;
> +        }
>       }
> +
> +    return ret;
>   }
>   
>   static int
> @@ -377,7 +383,7 @@ int ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t offset,
>   
>       if (to_private) {
>           bitmap_clear(attr->bitmap, first_bit, nbits);
> -        ram_block_attribute_notify_to_discard(attr, offset, size);
> +        ret = ram_block_attribute_notify_to_discard(attr, offset, size);
>       } else {
>           bitmap_set(attr->bitmap, first_bit, nbits);
>           ret = ram_block_attribute_notify_to_populated(attr, offset, size);
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 7ef49690bd..17b360059c 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -1492,6 +1492,7 @@ static void tdx_guest_init(Object *obj)
>       qemu_mutex_init(&tdx->lock);
>   
>       cgs->require_guest_memfd = true;
> +    QLIST_INIT(&cgs->cgs_rdl_list);
>       tdx->attributes = TDX_TD_ATTRIBUTES_SEPT_VE_DISABLE;
>   
>       object_property_add_uint64_ptr(obj, "attributes", &tdx->attributes,
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index adf787797e..f1b9c35fc3 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -2430,6 +2430,7 @@ sev_snp_guest_instance_init(Object *obj)
>       SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
>   
>       cgs->require_guest_memfd = true;
> +    QLIST_INIT(&cgs->cgs_rdl_list);
>   
>       /* default init/start/finish params for kvm */
>       sev_snp_guest->kvm_start_conf.policy = DEFAULT_SEV_SNP_POLICY;

-- 
Alexey


