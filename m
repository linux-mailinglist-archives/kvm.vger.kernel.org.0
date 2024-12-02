Return-Path: <kvm+bounces-32852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 131F49E0CD5
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 21:13:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C50F1282B6D
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 20:13:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC261DED53;
	Mon,  2 Dec 2024 20:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="P/CwJAN6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893B11DE4C3;
	Mon,  2 Dec 2024 20:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733170392; cv=fail; b=AiyjHbPWP6YZ8zVw7hdVtNTh8KUjFvsANTWqH7++LsCbEDnHKCVqr0xmJH89CEzddUbHzwszPlkugtYo+8GqLwfrHHXVhN02jlR6UzzKUY5faHZmS/7DAa5rwUOLXKvh3b9jFYRCmpeiA+q66uShppPLUqn7ckw8+T5XeNU28Ho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733170392; c=relaxed/simple;
	bh=D6ofOy7nyOqH4LMJS9I2O6wuUnbI/wjJ6A5Afj2huZA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=TvOQmiZcDMJ4J5a5ZRFYNM2KxEZVsd51C2T8czFSJkN1IDapCHwiJWELwHkjv29/yZbn/xLdS1/0nh5v44vBN8+DMvpyexCqjKla2MV8OA5kK6+D4n2yGYeHEfwIOPRImykiZqVh+oST0/6cAb7c3dexVf1vTU8KWv6VwGYTlHo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=P/CwJAN6; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=itO6DzujLito9eyUGRl+/ehds7arQNhKDJlxWulN9ynniht03fHNF7M5sQdgsoww32X884nCmNvVjEv89hGLpqau2sIm5mOznRjCc8lW7XQP3/uQlKCe0dTDRZTbbgSnjVlWY035aWfy+1WX3G/qHO2CW7wrYAtDahLWkKKOAzFcGQ/YH8eY5GOP3M1M1QtmlcsOhou8S6rzl21phrhng2Mu7OROq0YIKloWxf4zYeoIu5Tgo/5XJOemLJcHD2TAV/8tXKyN5lezJKMA0uFUIFlDAuhzWLCb7QRI9C8anF2V/i0uY09USYJWOYDfpBS993zyh1vZQ5SkYi88wMGYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCa+QuD3I7+GLoa7TUybgZiQM2jJ2OFwGoFS/vipNjs=;
 b=R+SSRE/PdZBdHF873BY/B4vLb9f89uo7JuY9TGRdJPoHQZiEdGCHJCULczkN7dlPUc0vLNefWZejjOELjoETojKtF3brh6ctJ86QHuxBpiUrrA5scigYD6MXjYn+af1yHzaXAm9IrssQ7MJCjsBUWZMlw1hGG0y0vmxs/ebok5Tku8FmFKna2WXy+LFoZLflRKucjqpRRwzxBn+rIPJ81z8AopxDHJvxfUNZJXlvy+MgirbG4UiOIZSJc8Gs0bPjX+ShXKPcjGyWG6zxVdiIMJqqM4adu5OQfpqwhH5cfZANNQSOGHUHPAa0KqByO8K17U2JY7u2e5d+oaSDkBS9tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCa+QuD3I7+GLoa7TUybgZiQM2jJ2OFwGoFS/vipNjs=;
 b=P/CwJAN6ffFiwmSYXFkAm0hU1imR8TM9UeL/sy0e4rAdKud5i5hWnEshfUtf//iQQsddJ32Yk2GAwtZEGw0q4R1YKEInWseYveWQwC+Vq9Ojqm95OCOvYMNxGiyu6CcPweSmO23O3xZlPTHWZx5h2lbxgjdlP9p5nbLmj71Daso=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ2PR12MB8135.namprd12.prod.outlook.com (2603:10b6:a03:4f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Mon, 2 Dec
 2024 20:13:07 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 20:13:07 +0000
Message-ID: <30aa4461-b5bb-a5e2-4a1d-c02d88a2c916@amd.com>
Date: Mon, 2 Dec 2024 14:13:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Binbin Wu <binbin.wu@linux.intel.com>,
 Isaku Yamahata <isaku.yamahata@intel.com>, Kai Huang <kai.huang@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-5-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 4/6] KVM: x86: Bump hypercall stat prior to fully
 completing hypercall
In-Reply-To: <20241128004344.4072099-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0060.namprd16.prod.outlook.com
 (2603:10b6:805:ca::37) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ2PR12MB8135:EE_
X-MS-Office365-Filtering-Correlation-Id: d32a45ae-13c5-4f86-0705-08dd130dbc87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UkVaZlR5b2hWcG5XZXB3a0FFSktQdzAydHpGcnZxSlNsSHZqS21hd2tkdTFQ?=
 =?utf-8?B?TTI4bFdzcHBTWVMvZnN4SUhGZFJtc1ZZWmtPT1VjcHN0VzBZemMvMW4xSGo4?=
 =?utf-8?B?ZHFoK3hUdDVXUWFpUXhCYlNZYlhiY2I4U2ZyZVMvU29Ub1RvNnJQajFsclBJ?=
 =?utf-8?B?ZkE2TCtJWldBamVUa2d3STcvWVFFUFE3dUwxU1RPM0RzV3ZzMzY0UW1UNlR2?=
 =?utf-8?B?ZHloRVFuUCtsMHFjd3dGT3hkUzJxY01PblNneUJ1Y0hObHRCT2pHTjBtYTAr?=
 =?utf-8?B?SjBUOTgycVgwQXN5V1lESEN3RnoxZW1hNHoycC9GWVJPbjcvMDhBN2hnMGMr?=
 =?utf-8?B?dmw3UkdDMHFQVVhXQ1BFMWN5M3B5aW9yWnI3ZFp1UFZ2bURZazBoc0xkR1kw?=
 =?utf-8?B?K2FvOU1ZVm9yTXRsUUpkc0JHRWluN1E1UEhpZ3RtMk85aEtMNzVCY2tHd29p?=
 =?utf-8?B?aklkZ2hxNUJvaStSRzZZQ2hlbm4yU3J6dEdYT3R4R0lGWGpJMlRVMVBUZVBG?=
 =?utf-8?B?dmFONVlBMGpFMVBjdVpwbFBQZUM1Y0FIVFRzQ2RHcmFUR2dyaTNSV0xZZlMv?=
 =?utf-8?B?QUNHVDJ0WlY1eWdGcitqTnp5dTNMeTYvbEdSdE1McGl5aUw3UXUxejRiRlBj?=
 =?utf-8?B?NE0ydUp1VTlqRWUrNHJ3NThqV3VkMmo4MUJWcVVSbEw0QUpsUkZiZ2FaVTNU?=
 =?utf-8?B?YnJjdS95RDJieHJ6MEFBY3o0QW12YW0zaXVDNmhGd3EyQWxtbGZMakRheDY4?=
 =?utf-8?B?b1FpeTk2VWF3aDI0eUhlQWdzUWNuL2FKT2prSUYrbTdQbkc2S0dJYXpNVXBn?=
 =?utf-8?B?eGtGcFcxcGhTTEZUZVV5NDk1Mk5FWitWUGVzRHdVMUI3dTZCSERkV3pZV2ll?=
 =?utf-8?B?Z2RJUTc0N21VKy9mYlFoaWRWdGJ2ZVpZaFJReThkc3ZLY0dnVzhLNWVrMWtZ?=
 =?utf-8?B?LzdsOEs4OTdveTBONHIxYk1PbXJ0YTRJS0JMWi92d2NnaFVJSXprRC9PRXp4?=
 =?utf-8?B?LzFnRlFzMDdXcjU3VjJxUFpGOC92bEpZakdlMmNvWms0THFwYllKL09ORmVN?=
 =?utf-8?B?K2tZNGFBK0liWmtjazJQM0ZFeXI4RkdzclNKVUhqcDVyQ3YwZm9vZ0RLT1FW?=
 =?utf-8?B?alRuL2VRVHZBNGM2WTJDaFQxVmdwRndVNzVEOEtURWNOOHVqbUM4NmhIWHlP?=
 =?utf-8?B?eXd3M21ZT2hvcWpLdnJVcXBhbS9FZysvL2lDTE5JQmpDaTRJLzNUaHdaYWtm?=
 =?utf-8?B?OEJ4dGdIT25wV21xYVhJays4UFRvZkZMTFVaR1Exc3g5dVYzYW5TSEFnVVJ5?=
 =?utf-8?B?UlBOc0hjUDdKRUg5aFBzSkVDTlpQaHpabnR5OFVQRE4rQWUwQ1Y1OG1UNUZE?=
 =?utf-8?B?NEY4MEN4Tkk5MXhCQjBEeFUySTFGUmVpZFN6RzFkWFBkV2ttUXNGa2hRc1Aw?=
 =?utf-8?B?ZGo3TzNsTEhMSzExbFJSeEhEVG5PTllvWXhHQ0t2WDRSQjVsQkxxaVo5K3Zm?=
 =?utf-8?B?NE44RGh5ZGZCSXY3SFh3eXRLWmJxQ2ZoT0FVRU0ybGVqOEp3NmFLcFc5d2Nl?=
 =?utf-8?B?OU0rb1c5UGdES1krSFRRM20wTlhpMEZpZGtHWmZna1drQXd3bnc2OEpKdHMx?=
 =?utf-8?B?MTViWlRaeUdTWWMxdUJVbGZCT1NtYlRYQ0Fpb09weGpyaEd0ZlF1NTBsNHYy?=
 =?utf-8?B?THprWm9lU0NuTXJMbUF2VnBqaHo0L2g0R01nQlZlNERyNE1OeUxRYktjbFA3?=
 =?utf-8?B?OG9ybmdYRjNiVlBYemVtT3hNb1p0MVBoU0loaUFqaE9sU3p1QjRLRmQ2TFlO?=
 =?utf-8?B?a2J0bmJqdUpTTW12djl4Zz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y0c0N21EQlBaeHNkUkpTTTR3U01EY1dKT3VzSitDUFIwU2RoZUVoTTRzck0y?=
 =?utf-8?B?a1NrOXdPUU1wbUx3cUVWT0hQcmlXdWgvcS9ZUjdMNUpFV3c4bURFRXJiTDZy?=
 =?utf-8?B?NGpzRFJmbERXUjVnUjErNFJHVkRlWHNHQUd3MlYvRStYWHp1bUxWVFdYd0Ju?=
 =?utf-8?B?SCt4RnBFanZhcU9tMlBFQzJJSzlRcDRDRXZBbk5tWUplWXR4eW9QcU56MDlJ?=
 =?utf-8?B?UUlyTjF0RmNlc2E3SStLOFZySGwyd3lkeE9vTXFrb3lLYmp6a3NNSnpwQlFo?=
 =?utf-8?B?b05venJZSmlhdWxPWkh5SWJOekNwOXFacGRtbUhkVWVTRXdqdVdYR21aK3RO?=
 =?utf-8?B?UjkxdnhucGRCMG9HYS9Jb2d1SHRxbm81NFY3SlhoamxDYTFvMlN2V2ZOWlcw?=
 =?utf-8?B?eEI0ekFpZEFxMHB4bnFPSG5TVTFyNm9IY2lPQjNzUk50YTFBUWFGYVdZckxv?=
 =?utf-8?B?L1Vpb1poS1ZzeFdoNm1BNHdBb1JQdU9VamYzajNzOEszeDZoWjRTS0VvSWM1?=
 =?utf-8?B?cWYxK0FtY0dFeUVVM1FMRUFSSEU1VVllNGxaK1ZDd3NQbjhWT2VYZ0hSMHV6?=
 =?utf-8?B?N0NNYnpJTi96TS9hUHhaZHJXaWxtTHNwQk9HQThyZjc3TGtYU0dyUXdUU0FF?=
 =?utf-8?B?Ny90VFB2MDJseThSQWVETDZYWmlOeEt0QktJSnV1azlOaUowUDZvelpZeGcx?=
 =?utf-8?B?c1hzcnlVT0tQRCs4SlVIbGR6Z3RCU1g2eEY5eTJUbjFOUG9OaXpJZWJlMnNU?=
 =?utf-8?B?MVp2R1QwbmpsbnlmNWQwaXZYbHN0WUM0NE4zbGxONmcreklZL3Ewb0FGc2U2?=
 =?utf-8?B?dEV3ZEw0Njh5eHRPY1c0V3dYclBFMUR3cytpcTUyTkxaUFpyZW82bnR6cG9p?=
 =?utf-8?B?Nm5LRHhQNmNISkt6YjBNS0dXNllDZ0J1SVYzTUVqbTFYbHNIVWc2cEk4cU5y?=
 =?utf-8?B?K1E0NjdiZlQ4Z1hUb3RpUjBVN2dEZjJtNE81S1hrQzJZQ0tJQkFDazNLV1ds?=
 =?utf-8?B?Rnp2UUdqWnpvdC9udWExWENCSWE0VGJGTHlKb1BYQ2Y0RFFUMHZxYVptM0F3?=
 =?utf-8?B?QlVramFFQm1NOXhTRXpsVlZ6R0RSK1pQZUFzZHhpQW45SWdGbDdlUDgwWTBo?=
 =?utf-8?B?TmVQZ1NXY3NObUxMbzh1bVVPUG04SUJWazZmY2swL2lhaStabHNJMWtVajJh?=
 =?utf-8?B?OUZYcEdXWDRBOG9LcEl1Q0RxOGNLa2RjT2FZajJNeHpmODJxMWw2NWlJUWx3?=
 =?utf-8?B?NWQ3bTJidkVGKzlBbDdjWlN5Z3l3UkM0TFA5RXJPWGpDUU5CN0F0K1phZ254?=
 =?utf-8?B?dk9jSlE1ajgzbFdxRFJPTXdJWHR0WHFpWDZzSkJ2QkZOWFkwaEtqZGNPZGVH?=
 =?utf-8?B?RkxqY3Q1am4yYkRWR0x2TzhQclphQkNxVHE1djZjTjVEVXRyQVh0bUhkSE1t?=
 =?utf-8?B?WHpqbWhIMGQwRlZUUFh1NFpaM294OTNwbW1Dbkd2VnpLaHM4bXdXaXhxL091?=
 =?utf-8?B?OHJ3M0JxVGxBRXE0UzBoTjlpc2FMUU04Vjc2NmZ4dGl5bVA2VWdha05IREFk?=
 =?utf-8?B?b2R0Zk5tTk1KbzE4MDZDak4yYWpqcU9lVml3MlB4MmUxUXhNV0doY3phMWJF?=
 =?utf-8?B?UkNBY0ZrVjFiZnowMS9hbWhpem9jeGZCSFlvWFFBTHpRamZQRFdHakNaSHJQ?=
 =?utf-8?B?VDZUVzNpWHduaUNjNFQ2SWxWczR1bzhxcCtadGd6R1pnb2VLdWZFTFEzTGly?=
 =?utf-8?B?TlFJUTgzQUU1R2JlZytqTzdubUVoL284dU9ybnZISlB3QnJVZk9zK2V3MGlp?=
 =?utf-8?B?T0ZpSjhpdFZqY1hMR29YSlo4RVhDSHZxVDlESjBZRUY5ckpOOGFLUk9jVHcv?=
 =?utf-8?B?SzdMdVBqWHRqdWlxMG56bEhqUE1CczltQ2JucnlHbEFndlkxVGVMdWRCL2lD?=
 =?utf-8?B?Y2JzK1J2VXlIWjZGSEh4WkFCOWJvTnRiZWZjNUZDMjJHYUYvUzVFNlV5eDlm?=
 =?utf-8?B?NTNaR1dUY0kxeDdoMmljc21Udi8yRzN2emRLTGhJbHRheEpyWWg3bE55MDFB?=
 =?utf-8?B?Z3IrQmV6eW5mQTk1SGt0YXJYeUpzUjF1czBNdDZQTHExYTBDbnJwUDBPSEVJ?=
 =?utf-8?Q?9+gcqLuLX+Uy+zP633ePGqQjG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d32a45ae-13c5-4f86-0705-08dd130dbc87
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 20:13:07.6583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YCUPaOIOUNXbT+VgdWum2xo//7OsZZe+yDiwCsV5Z6Jams3YBa2aniaoEjYrt3PyJQGfF3/THDQOuZyzqbn4KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8135

On 11/27/24 18:43, Sean Christopherson wrote:
> Increment the "hypercalls" stat for KVM hypercalls as soon as KVM knows
> it will skip the guest instruction, i.e. once KVM is committed to emulating
> the hypercall.  Waiting until completion adds no known value, and creates a
> discrepancy where the stat will be bumped if KVM exits to userspace as a
> result of trying to skip the instruction, but not if the hypercall itself
> exits.
> 
> Handling the stat in common code will also avoid the need for another
> helper to dedup code when TDX comes along (TDX needs a separate completion
> path due to GPR usage differences).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

There's a comment in the KVM_HC_MAP_GPA_RANGE case that reads:

	/* stat is incremented on completion. */

that should probably be deleted, but otherwise:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

Also, if you want, you could get rid of the 'out' label, too, by doing:

	if (cpl)
		return -KVM_EPERM;

> ---
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 13fe5d6eb8f3..11434752b467 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9979,7 +9979,6 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>  	if (!is_64_bit_hypercall(vcpu))
>  		ret = (u32)ret;
>  	kvm_rax_write(vcpu, ret);
> -	++vcpu->stat.hypercalls;
>  	return kvm_skip_emulated_instruction(vcpu);
>  }
>  
> @@ -9990,6 +9989,8 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  {
>  	unsigned long ret;
>  
> +	++vcpu->stat.hypercalls;
> +
>  	trace_kvm_hypercall(nr, a0, a1, a2, a3);
>  
>  	if (!op_64_bit) {
> @@ -10070,7 +10071,6 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>  	}
>  
>  out:
> -	++vcpu->stat.hypercalls;
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);

