Return-Path: <kvm+bounces-36460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9059A1ADDE
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 01:15:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92F213A9BA4
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71336F2F2;
	Fri, 24 Jan 2025 00:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CqVNso+G"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2084.outbound.protection.outlook.com [40.107.236.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0320F4EB48
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 00:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737677742; cv=fail; b=ljMwzZ1vnWS7QtDq7i0Jnd5lDO4jFjwgaq0eUMdsRmM55obdDthEcvpA6N+fS5xc6C2+XerXtocA/8FEppARDaVkbYB1MUOVPE5Lg2bR6yv/Uro/Wft9WftrC8fIjs5u2SaI3Cz0YFAg6nnH8x9bygu55bM6DvX55RVqbRdRrgU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737677742; c=relaxed/simple;
	bh=1ySYeE1r3eYNyScHrsbeoPnMzA6i4afqsJ2AHGPfT/k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=S3CHiNWQ5PvtsGuA2uyqDYf1xVNtFX9/SUDZSBWZyPnyC/Q51gZZqzwKcOH0zau9RNLm/kjLrzsEEeO/rDqnGU0FvvtHq5P5w80DwDrbtzl4mt20d3X3cCERLXOc2fWpJdIrsQFmdZmjvCckDQw+eyb2M7u4vKPkyydKrCPTj3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CqVNso+G; arc=fail smtp.client-ip=40.107.236.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=akF5+gARVJgo7WE1muLH8R0yLeH8pMtBT0r2/eSDVxFfK3ZZZDtF4si12C/m5LP2YHbvveCwG7EQJdvWhHGD+eu+fckNcwdb7VpXqkKC+KrMuoi6GR61+tp3xqTysGGpKEWvKEFyFJEfO4sLFhlhZMKOb88CWpkeXgSuN1DvfndG1ZK/IDnFUuCAglneLG9JH1of4msYadohgu2lTX1LTifXuIXAhwGT5tNK/A1DXgioB2xZkTCRRjwoBALJ5bBVFhqTFEv8M7GnUOcxB7NeyGg0FzubZ/OiADBJ4hDU/WSwEeZ4sYm9GGwp0/zRlEEUXK8INjwi8mQ43zEvOWt7nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yqPoBFbLx4pLSn0+etEQlNEwB0le16gPQDXJzr4ofUk=;
 b=jAugFZNwozHM+uySNS+horjD79g2IP6YSAaJikpL4HXHU7cBwbCUZsBGTq5DhQKouTW2BkGRRRQNybDKov+3SG9a6KvwAonKxwv/UkSXc2+7Nfeg2v+mUWdvl4on5MxHOdomT426vsD9qb2gPstZolkSkcNea4ZKa1sUuQgEHVnmIeQBPd96N0cQm6lBQv/y+lITJ3lsQ6CQlcsX6F5x9VpWkiFY9svOIXAagCXUaHpqeCKndz6ig3DpN4HU2EhpojD7zujk8osGwqn77EjfDce5NrpAvMncGjFt6CQDTIcWPu5lKi+hQv0dNU58cuwgpMyVewuTST/x9zp1EDSwiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqPoBFbLx4pLSn0+etEQlNEwB0le16gPQDXJzr4ofUk=;
 b=CqVNso+GdaZd7w5FdvBQHSUTKemQhIc+6ND5ZxQ+qW8gE/k8vQ8LhUMxvQGlBUAqKpHxyaNbuYyFF/Oc5+IRvwd8suLz1lf3Li6TSIvzU7M3VgrI0Syem/SNenueL6YZZb+YY53/j2AOLLatum26pAztvchiWgkhy6DuANsIfWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH8PR12MB6889.namprd12.prod.outlook.com (2603:10b6:510:1c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Fri, 24 Jan
 2025 00:15:38 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8356.020; Fri, 24 Jan 2025
 00:15:38 +0000
Message-ID: <b11f240d-ff8c-4c83-9b33-5e556cde0bce@amd.com>
Date: Fri, 24 Jan 2025 11:15:29 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: Xiaoyao Li <xiaoyao.li@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>,
 Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>,
 qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
 <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
 <f3aaffe7-7045-4288-8675-349115a867ce@redhat.com> <Z46GIsAcXJTPQ8yN@x1n>
 <7e60d2d8-9ee9-4e97-8a45-bd35a3b7b2a2@redhat.com> <Z46W7Ltk-CWjmCEj@x1n>
 <8e144c26-b1f4-4156-b959-93dc19ab2984@intel.com> <Z4_MvGSq2B4zptGB@x1n>
 <c5148428-9ebe-4659-953c-6c9d0eea1051@intel.com>
 <9d4df308-2dfd-4fa0-a19b-ccbbce13a2fc@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <9d4df308-2dfd-4fa0-a19b-ccbbce13a2fc@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ME3P282CA0038.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:5::7)
 To CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH8PR12MB6889:EE_
X-MS-Office365-Filtering-Correlation-Id: 6524cd78-e097-4977-1aa7-08dd3c0c3ab5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RDQwby8rNWtpcDhzUTlWRitaeVZXeUhBemVWd2FWaHNwbUVha21ZVjhoY1c5?=
 =?utf-8?B?ZVN3SmQ4TmRCb1FnQ1AvR3VlSmJiZGhVdlovYTNHMjBPZUp3YTJPVi81aDVa?=
 =?utf-8?B?NlRqcHd1OHR1SlJ5WjAzeHNxUXV6L3NFVzM4QUxyNEhyMnZINUE3a3hWT0FP?=
 =?utf-8?B?UXZIbHVGYjRsMXIzY1ZVa3k0WWRZR2x3SG1RcjB4cXdYVkFlcE5SbUw1aWhH?=
 =?utf-8?B?RzFCTzRud09uWUZFbmZEMmRtV01YU1cxRm5Rb0kxUjFzVjNQWE5IZnFkR2dN?=
 =?utf-8?B?N2hzWXpseWFzMHdDbUsyaXlmYkpaRjdtWnNxNytXdlg3dFZmREYvQ3dkRHlB?=
 =?utf-8?B?MnFIcUtFb3JxWmRFYVgwUGJEQ1ZER0ptTHNTRUQ0M0VVWFdJdU95YUxkNlph?=
 =?utf-8?B?V3NDcmlWUTB1QjVmaVZjY25ISFkydjF5QVMrZ0EyWVJOVjFEYTFtbFBRMDZt?=
 =?utf-8?B?S0UxeXE2NHR0SUF5c3JYZFRtNVdaQ0VVb2lYYW5lR2Nwa25GcEhhUDg4OWJr?=
 =?utf-8?B?YkNtcklja3B0T3ZvaWpyMjdpeU9mb3FzMnBxeWNMM28raUY2VktjcUdzeGdM?=
 =?utf-8?B?Tjk2WTNjZ3ErTG9PdzdKRTJmSDdMTXVBQWdZOUoxZXZmU2ZtdnYyN1ZFdG5y?=
 =?utf-8?B?UzF3a1oxSlNqaXEyY3BacUpGd2taN0Q4ZTNEVFpMYzZDdGpkVmFuUm9CZHg0?=
 =?utf-8?B?YzgvNzBMTlJVQmltdFNuajRVeFZpdEF5aUVTOVlmTkhNV2ZlVUxTVGx3NlhH?=
 =?utf-8?B?WVBCYUUwNi9mOGJRS2lqSDN6Z2h4WmQyM2JYbnlHVGhHLzFkQUVjNzFXbjBy?=
 =?utf-8?B?KzlVdFlLWUdHdlV0Vk9hYVhSME1KenV6WkltUWZodUFkb2I0M3FnUEh4ZHBx?=
 =?utf-8?B?d2xrQ1dzc2s4Ykt6UHdWL1dHVjVnODYxSnVPMm52cDlyUlFId2FmWHl1cmVl?=
 =?utf-8?B?eE84NTFmNmFVQzZZdWloUGZ4ZGxWUU5lbDRTYlk3bXdYQVlsT3lJc3E4eGhM?=
 =?utf-8?B?T2tvYkFDREFUQUZpdDB5MTJUaTNnL3JzNDRKS1g4a1RaYVNPdElZUksyOG9j?=
 =?utf-8?B?MkYrck8zZTNnMUgxOVpMbm5URGRqSE9EVDZBMi9HQ1g3QU1udmxGYTZXeVZX?=
 =?utf-8?B?ZXFpVXFRWWw1b2dqRktJazFsRENzT3hoOWtvY0hSS2NRV25Dc0xXUTdJTzNL?=
 =?utf-8?B?b2pFQmcySnR5cG1IYTBPcEFsbnZhMCthRGlPRDdIcUpNc25mVU9yOGlvQ3B6?=
 =?utf-8?B?OEJad2hPdWo2bVpkZzExQ2E2aHVZTFhwS0pkY1pwK0lUNUsvYzUyeVRvU2Jk?=
 =?utf-8?B?eUp2ZDVnYy92Q1JncVozSkl4S0k0WkIwaGoza3dRb2xJdzRIcVA4Z0cvUmpB?=
 =?utf-8?B?b3RMTzVZOE1rMzYrZ2t3cExoUFUwSkpKM2ZUMFdIRmxHckNEYnpvYnhhN0R5?=
 =?utf-8?B?WnZOUU9MWmtuQUF0Q0JJbTVnRjlFV1BxSjVQSnpYUm54ZEx4bW8yaDhzeE1y?=
 =?utf-8?B?NGJCYWxlT1dadmdsSjVCRkQyOVBmZlpXQTlwQjdkZU9XQzlZK3BRcWMyZzBH?=
 =?utf-8?B?VWxVVUhYMEtQNko0KzVsdGVXS3J3T2NKaUR4QXY3ZWF0OU1vT1AxQzdrNkhI?=
 =?utf-8?B?WXc5Qmw0aDdMTzFyQTJpT1pjQkJ6ZVl3aXUyRlczM2lUcngvQnlUV3pNR0d2?=
 =?utf-8?B?SWtzRWVONkRVVTMxcE5SajlqZi8yU3ZFQU9ib0E5ak1mT293bHByRjc1RHFI?=
 =?utf-8?B?YlVaaXEwQXUvQW5VdExzNWtZTVlKSmd1MFBKRXZ1TE5IOC9SdGVwMUhtVXhx?=
 =?utf-8?B?NjM2emZzcmZxWllZcUZKZUt1RDhzZTlkNzFuSk16MVg5ZjFIVm5BVUI1dVFT?=
 =?utf-8?Q?z7V8E6YZV64pa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SmhCRlJyNzZFK2Jxbll1R0d1T3VML0QrTG5xZXh6ZzFXZ0VEQnplNnkrQnZ6?=
 =?utf-8?B?cEM5Njh6ZjNaMDRRellFY0xpcVBkeG5YSWZpZTFRUlZXcDVycExNSUZTYmFN?=
 =?utf-8?B?MXd6VUxQanhKVlRkRFAyd2FBOEc1N0NWTmpEUjh3VWZpMEVaUGkrZGtMTlc4?=
 =?utf-8?B?QktjVVFUanY1alNoZndHUDRJT3hWWHFSd0RSMjEvTjByVFhzQ0VQRDNaVlNS?=
 =?utf-8?B?aUJsNmJCY3ZHU3RmZWU1c01TTzRSakFENTRDRUFLSWdrQXkybXg1YnZ3NkNx?=
 =?utf-8?B?YWlLamlIbjgzdklrY2RuejNubVkxcm5nVHlHSER4bDd4S3Vib3duNzYrVUU2?=
 =?utf-8?B?UEVkR3hWaTdINzR1YzIrNjV5THNTR3VxWWVGKzlwQm5FbS9ZMFJaOGpVTEJQ?=
 =?utf-8?B?eHQyd0RlZHV2UWV5MzRwb2gxOU90NXN6c1J6YmZQUlNBcW5EZE1GZHJLNDc2?=
 =?utf-8?B?dDhnNHRZRXNnZDMxdVFsV25uNnVNMEtFajFOOUNPVTVKK3NNYlBNY3F6UlZW?=
 =?utf-8?B?NTV3UklyZ2JtYXM3Mk9sdTVpdmgrQXFTZHZoSzA3aUNiZktubWt4Wk5BbnRQ?=
 =?utf-8?B?QkRhMTdreGR2RTdrc3NzdUowYS84TjQxTzRteThwOSt2dU93aVpUUnBFanZN?=
 =?utf-8?B?MmFuRUNMeUdZTGJvZFdUWDNrV2poVFFQVWhhczVoL3lmNGlEK0lPVG5LTGtS?=
 =?utf-8?B?MEw3ZGpoMGlBZEF2aGVCSFlVRHhxNG1BQnl1L2ZpUWdOam5LZUFPczA0RFor?=
 =?utf-8?B?V2N6WjAyU3dXWGx4N1RwT0I5alN3ZFFkd25nRG5aYUJqTGxsdE9PZVRjZXhs?=
 =?utf-8?B?MlZlSlBxakErVmR3WmJuOStMSlpTRy9OTEtveCtiZUxuQ0JldTMzcjFBajc0?=
 =?utf-8?B?RnIwWUVCdVdwNExJVnhlcHhPc1V4ZHA4dS9oTWx2dDZtaFFTc3RzWFNYMDkv?=
 =?utf-8?B?Z2pjUnpuOEx5dzNiS2Rnb0dtbnYxMEhiRW9XWGxBQ0daRHdnWXB6eGpjUG4r?=
 =?utf-8?B?M3QyalBLU3ZTSzlRQm1XS2tsNWFMM0VCTFNDTE9KcHJzajI2N2FJa3VkemhR?=
 =?utf-8?B?Vm5vK2NJVHNIUC81UENGY1VXL1lBcWlibVQ2U2wxRnpSaUVyWlBRdTlmdTJ1?=
 =?utf-8?B?anZvL0Jsa2lkZ2ttczROSXZydGxwM0pYQUdmK25lblJQdFRLYkJMS1lWenI2?=
 =?utf-8?B?Y2FXY1dGbGl4TjF3UWkwQkJ2MFpUOWZBcjY4TkFDMTFXclFDYUl2MXE1S1J4?=
 =?utf-8?B?SVdQMjRPcitaaXRlck5QV3h0Nzl5bzJFTkQzTUhmc0hIaFprOVBpV2xEMXFq?=
 =?utf-8?B?MjM1YWVUQUVSV0JmU3hMd0FrOGpUS3Y2RG41TzdPeXpTNUsyQ2ZaeE1jN0JF?=
 =?utf-8?B?ektTSWxzQUQzSXRldFdWeHMwMUtURFJsWm45eE1ESjdYT1lmQno4dHd0cElS?=
 =?utf-8?B?cHBGdld3emlHSk05UTNrZXdSVCtvRjZHeldycHFwMUNwV2Q4TmVjRklhQ1R3?=
 =?utf-8?B?aXBRRjJucnh2V2RrSlhBSTRmZm5tL254eXJjT0VGSjdVNWxPdW1odng3SGlw?=
 =?utf-8?B?QU9ZVEN2MnlyU2tRWUp2L1hDWmF5eStpb1BhVmpnbUVOVlBiRVNTdHZsRlFr?=
 =?utf-8?B?QmlmQVJIcTJJb1RDWmdHcVlZZnNlcmJ4Y3o2L0NudUdqQ3ozbWhMM2VkMjVv?=
 =?utf-8?B?WlZ6OXJCcEhsZDZHRFNCL2puTEUrbEUzbmdnV2dGdmsyazFBWlNNb2gwVUZ5?=
 =?utf-8?B?bUlYRmdQMkZSMjI5bDRrR1h4dFYrWWQvSVVEdkJFQ0QzL0VTYVh0endiMEdH?=
 =?utf-8?B?R2EzaStORmVMaERHRmlNTXpLbnVyQ2hudjlZT1MyN1VmNjRTdXA1ZFd4YkhP?=
 =?utf-8?B?Ty9iQzlxd0k0SmVIOHBPNEptUDNReHB5N1RqWnZmMGtveWhGTHRlelN6bzlO?=
 =?utf-8?B?UkI5YXh6Qk5IUDlUYk9zZ3NpTlFSRm05MUpPSldFblNaMmc5cnA5dVh5Qjdi?=
 =?utf-8?B?NEhkTVc0QUJzbkNhZ2owZ0gyd0hHTXZMZTA5dXBpVHBTTnBseWJNeFo5Y3Ni?=
 =?utf-8?B?UkZWYjRmdHdXUlIvbnZCZGN5SXo5a085Q2pITTQ0OEVwWFFhZ3hkVFliQkxa?=
 =?utf-8?Q?E4gt7+cGIUWKWdDMv499p/YGc?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6524cd78-e097-4977-1aa7-08dd3c0c3ab5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2025 00:15:38.0224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOwuKtdlhlj7Xp4C1T5pR+iLKWOp7ivXcBwYolVCQlkZahqa2pSvcUu+lxgg7iFJ3WT5VgZVSDnRVvG4eCOvWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6889



On 22/1/25 16:38, Xiaoyao Li wrote:
> On 1/22/2025 11:28 AM, Chenyi Qiang wrote:
>>
>>
>> On 1/22/2025 12:35 AM, Peter Xu wrote:
>>> On Tue, Jan 21, 2025 at 09:35:26AM +0800, Chenyi Qiang wrote:
>>>>
>>>>
>>>> On 1/21/2025 2:33 AM, Peter Xu wrote:
>>>>> On Mon, Jan 20, 2025 at 06:54:14PM +0100, David Hildenbrand wrote:
>>>>>> On 20.01.25 18:21, Peter Xu wrote:
>>>>>>> On Mon, Jan 20, 2025 at 11:48:39AM +0100, David Hildenbrand wrote:
>>>>>>>> Sorry, I was traveling end of last week. I wrote a mail on the 
>>>>>>>> train and
>>>>>>>> apparently it was swallowed somehow ...
>>>>>>>>
>>>>>>>>>> Not sure that's the right place. Isn't it the (cc) machine 
>>>>>>>>>> that controls
>>>>>>>>>> the state?
>>>>>>>>>
>>>>>>>>> KVM does, via MemoryRegion->RAMBlock->guest_memfd.
>>>>>>>>
>>>>>>>> Right; I consider KVM part of the machine.
>>>>>>>>
>>>>>>>>
>>>>>>>>>
>>>>>>>>>> It's not really the memory backend, that's just the memory 
>>>>>>>>>> provider.
>>>>>>>>>
>>>>>>>>> Sorry but is not "providing memory" the purpose of "memory 
>>>>>>>>> backend"? :)
>>>>>>>>
>>>>>>>> Hehe, what I wanted to say is that a memory backend is just 
>>>>>>>> something to
>>>>>>>> create a RAMBlock. There are different ways to create a 
>>>>>>>> RAMBlock, even
>>>>>>>> guest_memfd ones.
>>>>>>>>
>>>>>>>> guest_memfd is stored per RAMBlock. I assume the state should be 
>>>>>>>> stored per
>>>>>>>> RAMBlock as well, maybe as part of a "guest_memfd state" thing.
>>>>>>>>
>>>>>>>> Now, the question is, who is the manager?
>>>>>>>>
>>>>>>>> 1) The machine. KVM requests the machine to perform the 
>>>>>>>> transition, and the
>>>>>>>> machine takes care of updating the guest_memfd state and 
>>>>>>>> notifying any
>>>>>>>> listeners.
>>>>>>>>
>>>>>>>> 2) The RAMBlock. Then we need some other Object to trigger that. 
>>>>>>>> Maybe
>>>>>>>> RAMBlock would have to become an object, or we allocate separate 
>>>>>>>> objects.
>>>>>>>>
>>>>>>>> I'm leaning towards 1), but I might be missing something.
>>>>>>>
>>>>>>> A pure question: how do we process the bios gmemfds?  I assume 
>>>>>>> they're
>>>>>>> shared when VM starts if QEMU needs to load the bios into it, but 
>>>>>>> are they
>>>>>>> always shared, or can they be converted to private later?
>>>>>>
>>>>>> You're probably looking for memory_region_init_ram_guest_memfd().
>>>>>
>>>>> Yes, but I didn't see whether such gmemfd needs conversions there.  
>>>>> I saw
>>>>> an answer though from Chenyi in another email:
>>>>>
>>>>> https://lore.kernel.org/all/fc7194ee-ed21-4f6b-bf87-147a47f5f074@intel.com/
>>>>>
>>>>> So I suppose the BIOS region must support private / share 
>>>>> conversions too,
>>>>> just like the rest part.
>>>>
>>>> Yes, the BIOS region can support conversion as well. I think 
>>>> guest_memfd
>>>> backed memory regions all follow the same sequence during setup time:
>>>>
>>>> guest_memfd is shared when the guest_memfd fd is created by
>>>> kvm_create_guest_memfd() in ram_block_add(), But it will sooner be
>>>> converted to private just after kvm_set_user_memory_region() in
>>>> kvm_set_phys_mem(). So at the boot time of cc VM, the default attribute
>>>> is private. During runtime, the vBIOS can also do the conversion if it
>>>> wants.
>>>
>>> I see.
>>>
>>>>
>>>>>
>>>>> Though in that case, I'm not 100% sure whether that could also be 
>>>>> done by
>>>>> reusing the major guest memfd with some specific offset regions.
>>>>
>>>> Not sure if I understand you clearly. guest_memfd is per-Ramblock. It
>>>> will have its own slot. So the vBIOS can use its own guest_memfd to get
>>>> the specific offset regions.
>>>
>>> Sorry to be confusing, please feel free to ignore my previous comment.
>>> That came from a very limited mindset that maybe one confidential VM 
>>> should
>>> only have one gmemfd..
>>>
>>> Now I see it looks like it's by design open to multiple gmemfds for each
>>> VM, then it's definitely ok that bios has its own.
>>>
>>> Do you know why the bios needs to be convertable?  I wonder whether 
>>> the VM
>>> can copy it over to a private region and do whatever it wants, e.g.  
>>> attest
>>> the bios being valid.  However this is also more of a pure question.. 
>>> and
>>> it can be offtopic to this series, so feel free to ignore.
>>
>> AFAIK, the vBIOS won't do conversion after it is set as private at the
>> beginning. But in theory, the VM can do the conversion at runtime with
>> current implementation. As for why make the vBIOS convertable, I'm also
>> uncertain about it. Maybe convenient for managing the private/shared
>> status by guest_memfd as it's also converted once at the beginning.
> 
> The reason is just that we are too lazy to implement a variant of guest 
> memfd for vBIOS that is disallowed to be converted from private to shared.

What is the point in disallowing such conversion in QEMU? On AMD, a 
malicious HV can try converting at any time and if the guest did not ask 
for it, it will continue accessing those pages as private and trigger an 
RMP fault. But if the guest asked for conversion, then it should be no 
problem to convert to shared. What do I miss about TDX here? Thanks,


> 
>>>
>>> Thanks,
>>>
>>
> 

-- 
Alexey


