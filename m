Return-Path: <kvm+bounces-40743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64901A5B962
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 07:49:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95453170F3F
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 06:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C301EE01F;
	Tue, 11 Mar 2025 06:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mJlPb8CM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81607156861
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 06:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741675754; cv=fail; b=UnCrkyNRRHyp60p2o0Yq16Bx54yVLkWcYC1OtEXpYTbTehTgwwPprsCg4qLmQSvezFFOMroqgnGmBx7BJhc8rg9z6skawJIXV6R/UvW0qmM3TzbrEnFnF2TFn6P2Zdec17iOVAaI/HE42wHy9b/PRserzK7DqYdQEYnesLBzsVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741675754; c=relaxed/simple;
	bh=abpv58BlNjJYATetij/t8E5ylagCEB0LZYc4LpAfJnI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bdvT2xy8kNx8Uae8FDuuz8VuCrBsENsi9eVIqHEW1tM77gd9jxGrsHJWZX3AeIMDF3o92ci9Oy5U9dUAHhCdYRMzBRCzaqX1h9WlczKORJrmkmyjitPb06dEZh07B54utEDlBpTUdw/cYTWG3Uf0LFZnvzFvTxPNNAM5I6EJCmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mJlPb8CM; arc=fail smtp.client-ip=40.107.243.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wke4k27HFsv5D6cTY2BzVuBQSSuuTskPLQXJB2vk4nbAV3IXR4x6JjCEoZsO6u9YH7TSWNjg/Rw+wYlXarI+YNV9uMdF29BpOtz/xX6uHGyy8FQNvkGLxCSuQR9coIyLw0fGppxBu8CjqM/Pzfs8ez8/v6LsYVeCi9KPk08EYOQQgq/Iuzh2PI4gIkcODiSZntX9udIgM3lLuhYrvxAhcUu8WgV+XGu9OO1h4e15PZtE0qegOIAh4haKaxTz9HE4wnq0woWqgr2quBYK8c3dm+OxtP4Ly83Hdj0JoBbeagtcdwXdzeLdD2M13xWGBRvic9whxEJ0Zzf+V1rfYETJvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6zf4GgXS12BCbAUcBZI/hXp2rECNckA6U6EUrta6/I=;
 b=Rwc0uQXrWpWbFHSKUev9cSzjhLEW4doyKWRF0aKmr5WSGlBxoWAs1oMcMQh7aDESd0YMGtpMnbqmj/ml/lH+eEpkJ4L0XLSa9g16fD96uBI4RBbzsMAthtt0Gcd8IfzBY7zSV4JSyDwNCDxGdwSFE+DSTGQLMli15UXHSEIPo5MTr+bw1id0EOX9ny0S/sVExrFRUcTFY2R53Z66+5ApBUtWQbzKYH15+QBxpHjpqpeIyNEp96u0Gwl4jvj/7MeBndtc8+qWQTSL+ak2tzWtilyRXnPXT72Teuk/QivzyKJ3vOTQ30VCOXK7rVgZlAAVneJ6+k9ekUQQBs3C7dxZ3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6zf4GgXS12BCbAUcBZI/hXp2rECNckA6U6EUrta6/I=;
 b=mJlPb8CM/jVED0kaHZk4mY2w7Sojdx8ZxCwEV9dI0aSdqmn2T3g/ZEFuoZNnbioqnthDUZNXnnwrZwMAevrcSg1k9AbllJfm8RBd/i/05BsmxH1b42YWn+fgi4etI8dZ2CzEBDhrOiJsZaY6mpm1SfrM4c1iB6NwodIZPlkPjgk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by DM4PR12MB6543.namprd12.prod.outlook.com (2603:10b6:8:8c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.27; Tue, 11 Mar 2025 06:49:10 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%5]) with mapi id 15.20.8511.025; Tue, 11 Mar 2025
 06:49:10 +0000
Message-ID: <1186d28c-5788-4b4c-bf22-d86f21b7ceb9@amd.com>
Date: Tue, 11 Mar 2025 12:19:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] KVM: SVM: Prevent writes to TSC MSR when Secure
 TSC is enabled
To: Tom Lendacky <thomas.lendacky@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
Cc: santosh.shukla@amd.com, bp@alien8.de, isaku.yamahata@intel.com
References: <20250310063938.13790-1-nikunj@amd.com>
 <20250310064522.14100-1-nikunj@amd.com>
 <20250310064522.14100-3-nikunj@amd.com>
 <92a926b7-7958-f44a-fc05-7fa2c171e710@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <92a926b7-7958-f44a-fc05-7fa2c171e710@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0239.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::18) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|DM4PR12MB6543:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e43a1c0-31ae-4b5f-6e7f-08dd6068d392
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mk1RRUJFd3ZxQm1IRnlhTGdGczFHMFFTN1I2cVR4VVRqYWw1Q2RFUm1HVHNz?=
 =?utf-8?B?OENyd1JxZjRCRGlVUG5KdmhSTlJwVVlRd08vWk4yRkM4bnVYb2tZRFRzMFhZ?=
 =?utf-8?B?OHVTYTdTLzlwc01yRCtSd3ZPT3ZuR05wcFI2TnVGZHVwMUZZVTJnbGg1azNT?=
 =?utf-8?B?RUFxaG95clErWm0rUjkvNWEyWi9LQU91aTdsTTFnSzNZYWZ6Ump3RHdmZkpw?=
 =?utf-8?B?dXJiTWdQV2dLUnlRZENwUnFUZE1yMmVzei9tTThnYmhoZXJmRzZpTEphbE96?=
 =?utf-8?B?RWV4TTBxcmtHVXZ5UnA3SXBzRTBhVEU0ZnowU090b0RLVU9hTFREYVNKbENM?=
 =?utf-8?B?YXI5QTlqZ0pyQTBhZnE1ZGNiNlNYcVlFcDUzZUdhbEF1YVlza0tNUXVnVWhW?=
 =?utf-8?B?UGFTN1lURHMyRDJGN0dyNG1ZUmpFNXZsY042dnNIUkxzeXNWZFdDUTRKRDgr?=
 =?utf-8?B?UkZoMVc5S1pGUUlKNEpxNXlpMjJ1WU9pUXFrZlhNMXREWTRFVVUxYjZFUDhD?=
 =?utf-8?B?ZFpMTFU2enNrK2N3YUJNK0NUaXNlSDZnU3lSaHU4WTZVNW1vWmtLYm9lNmsy?=
 =?utf-8?B?eXlzK29TblJNbHlObzRiWDVGRVpWdVJOL2NkV1FJQ0h2S0lLbi9NSk9NZlJ2?=
 =?utf-8?B?WDk4dzBlUjFEQk9FZ2dJOW9jaFFEOFZ4L3p2VzhpVnFXMTFrZ3dJWGV0VkZq?=
 =?utf-8?B?eHlZM0YrT0c1Vk51cWovNUpoZ2lTSDJ5YXh3N1NkbC9GaVcwVmhlcElrYkRQ?=
 =?utf-8?B?MEZRN2QzZG9KZHVqWTc0NlhEQXM1R0RxVGVXQWZPcW5HN0Z5SnIvdTdxa3dI?=
 =?utf-8?B?UG9UdWZFcXNvWE8zRDBRSTlpdDhpRTJxRlViYi9zVU1IR3hkSHYxRm9SWGRl?=
 =?utf-8?B?Nzk2NWV6UVFLM002c2FicFI0dTdZUXpSeG43alFwckZKeFZnK3V0bVJaZ2RZ?=
 =?utf-8?B?YUUwZmVITUQrSk8rK3V2UWhUUGFwL09OY29hRDlDRFFBeFVnNkYrdUtkOUlv?=
 =?utf-8?B?dHExRWx2bEcydTRUam11NWtOWnlpeTRNcG1leUh6K1hteFNvVmx6Y0dHdHNv?=
 =?utf-8?B?cFFCZmhMbW5DaXJYQTFwZ3hnNDU0Y1kxS21OalUvcmw3Q21SZS9PSlBIbG5T?=
 =?utf-8?B?alJkYnFzdjBKMnM5UTZySWpnYTNYclBzNlFDNmVMS0pQbVg4TEVWajlCaitG?=
 =?utf-8?B?YXIxK2UrTFJQOGxmVGdabGpHOWI4N1RSUy95SHhkU2VjMmNiVXRWZGxsMWpo?=
 =?utf-8?B?dGtyQ3lUWXBHekRPSDRQTDFZaHlqWTljWXEzMFRrdTlhUTZ1Qjk1bzJIZmZ2?=
 =?utf-8?B?SVJ1bTBlWHlkelNQcXZ6VVNCUTFTcjR0ZEtHTnAzSDZ2NUJCOFhrSGFMcmVi?=
 =?utf-8?B?SU54RUticUVjcVZOMGpOaXJ5bkNySVZFWmU5cmlUTFVHV0hBN0NGYlRKeFBD?=
 =?utf-8?B?U3FkODFxWjFBVUlzQWVSQ0pxZXN0N0FGeGNTOWg2MDJrQjd4ZFlHd3REU1dI?=
 =?utf-8?B?aXNUYmdta3RmeEFhNjQraVdvK2FSb0NJODlyM2lDcWV2cXN4M25BSXFyZnho?=
 =?utf-8?B?b3dZT0lWSkYwczBOazB1b3dDY2NEd1lZY2xzWU9IUVhROVB5SzBtQlRXQ2ZE?=
 =?utf-8?B?ZjNRMmh1UjJzUXprekcxY0ZmQTB0ZzJJanlvdTVsU2xYRHJOa1NhcGh3bENx?=
 =?utf-8?B?Q1dKOGdPeWg1QXY0bGtxK0gxbUxEc0hzem56cDhwdmVtNXhBZlh5Q1lQT1FX?=
 =?utf-8?B?RHpaYW9ITDdHMlFIYW41T0dmTk1lYXFPS1dCUmp1V2xvWTExanpiYVEvNXVH?=
 =?utf-8?B?aVV4em0zRHd1bmQvYkJ2SU8rVG1yeHhnd1FSYldSU1ZUVDdnWk1lWElWTUtx?=
 =?utf-8?Q?o32yj7HrdLw4c?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVcyYUU1WEdFUXljYjM4Y21PODFCcVpFbVprVTcxek5Eb2lpaHM4UlNJT3Iy?=
 =?utf-8?B?Wjd1MnFlcnF0cE5ZR0lRbEdLUlN3QmlZQndpSnZkY3l2NmVmYW9jTmN1Wjhv?=
 =?utf-8?B?NkNjZ0kyWGJIZVZqSFpoSTd2ZHRkWjU1UTlKdXJRaFVZNnlvOXlTdVpTeEZO?=
 =?utf-8?B?dHVBTzV2MDY3ei8xWDB5a1dvVmJxRlJQUm9GeU5nV3dIYVNmakJnZ1YxcG1C?=
 =?utf-8?B?SWErU05iTWsrNm9NZ1VSbDdibWU4NTdiTVQzZlp3N21KdktFbmNtN1dTS01t?=
 =?utf-8?B?d2VteGZKdytHbldZR0pzMWtDMmVuenNQYzVoNGlYUVB4YWVVRVJzeWsxN1Jy?=
 =?utf-8?B?SERBV1F6eE8zMjFodldyQlE5Y1BNU3M2YTVneXpuMXlKbVRKUmpnYkxnTEk2?=
 =?utf-8?B?cEphei9kMGNVSHJDV3NVRjFjL2tCcTlXL0dIZHFEamRoYU03SVZSNEowTW9h?=
 =?utf-8?B?REloUmtGRnZZR3hPdkUvVXlMM0k3NDdNMk9EYTduYzFaMWNsNlV2Rk9tUDlU?=
 =?utf-8?B?K0JUZnVBVjl6SS9oYUdUOXBySm9JTit2WmFrTnJyQlhMYWdOUHRGWW1Qb0ta?=
 =?utf-8?B?RklzaUNxWW1lQnNMZ0JsSmJudGx5VnVmTG1hYVRYWWhjQmM0QVd0K1krTFNa?=
 =?utf-8?B?VTlIZEppTHhEd2dtVENEQUh4QitIbFVOVExyN1BJcmhrRDV5TnUyWk1JYnVU?=
 =?utf-8?B?RmRsaitEMFpuNjY3cXJTVDllYmp5dXFZQ0paWGI0OVV0VVhwQ2pMVTkydTFE?=
 =?utf-8?B?YWo1RHRCckV3UHBkdTZaOFpTaDgvZFFiZWtick43Y2ZVN2lMdkkxd3RvMjFx?=
 =?utf-8?B?dHgzV1FCLyt0NzRYREU5RlQyYllDenEvTFpkYzZhL0xkaGxpNitCQXVZamZB?=
 =?utf-8?B?NzdCUDRYRkJha3lSVlI3dWl3anNORWF4V1VsZ2N3dWhZakt6a0lJSjRNZ3JF?=
 =?utf-8?B?VzlqM3NiZmZOSmdnMVFaUTJBM3hDUytaUjdmZDRlcjVLOWZHMGd2VEFVdzQ3?=
 =?utf-8?B?VFZwL3FnT2JrdS80cjVxQmFhSXF5emExZStJM1lqbGl3aXZNZklPT1FHSUF5?=
 =?utf-8?B?S2s5QnlDTjZrSnoraUZlTEJHYXgyb0JYSlFweUtWZHM0WXNodWxRT05rSDd0?=
 =?utf-8?B?QUhySU50a1pZOW8zdnJQb0Zmc2NVZkY2NHJLR04rRjUyZjFhWjVVRU5oTytL?=
 =?utf-8?B?SzVhVDlXeER5N1dsS2srQnRlOHRwZXBxYWx0ckhYV1J6MDhreFFUQ0xsREFN?=
 =?utf-8?B?Y0F6YWE3cmw3R1AzNm1Pa1hEM281ZVVsMHVMeWtSUXZVYkhMd3V6bHNoRDBK?=
 =?utf-8?B?d243aUhMUTRXZVN4MEloaUZRNy92MUVOTEdJdTlaNU02K3pLUXhlL2lzVDl3?=
 =?utf-8?B?aVlzZDRVR0FxT0JaNmxkQ0NseVorWnhqWU55dnVPR3hlODIxejAyOTlhM2k4?=
 =?utf-8?B?SUVKOHRmdjVGQm9JTG5UZWU2Vkw2eG9ubDQySmRIbGFRVkRZcU9uK0VjbEI5?=
 =?utf-8?B?QlUvYlhNaC93TkxpaXlZYkVwMVZRSFBaQjUvTWxCak9PQ05GQnNnWDJUNkFZ?=
 =?utf-8?B?amVKZ2cwckZyNlFBcUdKYjB3TTVMaGV0bHVrbXVoTlZ5anZXVXo4NEkyaWgw?=
 =?utf-8?B?OFRrendRSUpyUEU5K0djVEtvdW5wL05zbFRkcE5Bd1pKUzZPaksyZUhzSHdV?=
 =?utf-8?B?cDgwMW5ackFVQ0FwUUJVbStXK1ZqWWVtbElRd09wcDd2ZVZ6aXJXblJ2bHpt?=
 =?utf-8?B?UjV1L1JGQ25MRnFyb0cveWlXVmVaeUFuQ1ZzOEdTeXhrQnozT0ZSNndmTHV1?=
 =?utf-8?B?NVRSL2VtemY5WHJxQ1VuZG5NcytKU1JubnQzZjhBTHZyWlAyNnc1cTYyMXZE?=
 =?utf-8?B?VFFvTnpQQW0wcE5TRU9SNElHZ3dwR1hsUEF5aGI2WlZzMEx2aXhCYm1PM3d2?=
 =?utf-8?B?cU1NWjJtYUF2cUdmRWlzRmd5aHhiTGVtUURWZFg0Ni9IeFRFU3prempkTTRh?=
 =?utf-8?B?NGsvTkJtRlBWKzVkV3gvQktsTkJJWWVKb2hLaEZDem5GY3A0OFVpQ0E3V29V?=
 =?utf-8?B?MVlKSXBOeEhKUUY3SklVQTlHbkJBZFhQZzkyOUFNS2lWeXNxVGt3eE1Bdldz?=
 =?utf-8?Q?9KEPJkaVc9Lk6z0tJgDn7Dxx3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e43a1c0-31ae-4b5f-6e7f-08dd6068d392
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2025 06:49:10.2310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+AlY1v4vUUFivvFn7jA9RBMnfto5fcs4aJ47Z8ei99MY/egsgxLcpgFwT5NtQ7LVjPzxb6Y5CaEXAT4pYIz+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6543



On 3/10/2025 8:53 PM, Tom Lendacky wrote:
> On 3/10/25 01:45, Nikunj A Dadhania wrote:
>> Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests. Even if
>> KVM attempts to emulate such writes, TSC calculation will ignore the
> 
> s/TSC calculation/the TSC calculation performed by hardware/
> 
>> TSC_SCALE and TSC_OFFSET present in the VMCB. Instead, it will use
> 
> s/present/values present/
> s/VMCB. Instead, it will use/VMCB and instead use the/
>> GUEST_TSC_SCALE and GUEST_TSC_OFFSET stored in the VMSA.
> 
> s/stored/values stored/
> 

Ack

>>
>> Additionally, incorporate a check for protected guest state to allow the
>> VMM to initialize the TSC MSR.
> 
> I don't see this in the patch.

This change is removed as we are differentiating between host/guest writes
and host writes are ignored. I will remove this.
 
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> With cleanup to the commit message and a formatting nit below:
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
>> ---
>>  arch/x86/kvm/svm/svm.c | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index e65721db1f81..1652848b0240 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3161,6 +3161,25 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>  
>>  		svm->tsc_aux = data;
>>  		break;
>> +	case MSR_IA32_TSC:
>> +		/*
>> +		 * For Secure TSC enabled VM, do not emulate TSC write as the
>> +		 * TSC calculation ignores the TSC_OFFSET and TSC_SCALE control
>> +		 * fields.
>> +		 *
>> +		 * Guest writes: Record the error and return a #GP.
>> +		 * Host writes are ignored.
>> +		 */
>> +		if (snp_secure_tsc_enabled(vcpu->kvm)) {
>> +			if (!msr->host_initiated) {
>> +				vcpu_unimpl(vcpu, "unimplemented IA32_TSC for Secure TSC\n");
>> +				return 1;
>> +			} else
>> +				return 0;
> 
> You need "{" and "}" around this.

Ack

Regards
Nikunj


