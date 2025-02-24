Return-Path: <kvm+bounces-39043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E7FF8A42CD8
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 20:38:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C223189BE4F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE509204F98;
	Mon, 24 Feb 2025 19:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="B7qOClVq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2051.outbound.protection.outlook.com [40.107.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390A31EA7F4;
	Mon, 24 Feb 2025 19:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740425902; cv=fail; b=SIQ5rnbRKuBEGJkIlMVwJ02gtlxccr34yhrMNgJW/qUoN0r1CcG+8gNMqZL3JaG++lln1n1HmYOWeQJchusAVSl10UeSkd/hVHQ5nhw/qwTES7wMaOrSkcxH4kA9NZT+Ua0eQLmUBX5Azsk5z8MFLDV2KXpsuS4sBYzY3RDu3+w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740425902; c=relaxed/simple;
	bh=j1vo1SpEneDxYPKU8xnfb1NFnQSD4VpyBMMVpZgajz0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F5DoFHleZflWjWBaHub8WgHvopfXWTD9nNobc36g+nWBt6GpjRh01HwFqgKA7P9IkpSsMmlfdrx+9DGWMnf5QAIWKeBrOXysskVZ/MO1CC2ET3I3unJXXt83+dXT/acu8s2gzR+mpWiX2Uu78OFfX4EIc9IzVmFgSEorw4K2htI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=B7qOClVq; arc=fail smtp.client-ip=40.107.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l/ntbzItwj6UAQckM7MHVHDYWRHwiGgyGGDesiHENj7Odi+bsd1cJpiDny2lJE6CQGQ9MZee6tjRg37emZmdlUIYWwAXbSA2FdddrmPGRWAuGZ4i9ZhD9ZrkDcZh8ezjgioiRlM7JSMKgqUGYL7Nl03faPMYAGdpanaF58K5LnaQpcJpvqh6rFlIDmp7IBqo2e0dDfk0bensMMp4IBTs8SFnvlsU1bl1MHbLSROULlWz6UZxpdhEQ/gMhYNejkLJfiRdAX9DbzPe6k14GFYH9Fr4BZP42oQGGweBHAZ/rJxDnM9gqKFVe1+kCG5htIaagfuu3FZ4UgN70+Osua8q0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ffpcsdw5f6j0SG+mEijuIwAMS7gbGELVQb0CuR4KNY=;
 b=PVXwyJ1kSfVqUOmShgPHAml+McDx12AHrAT6mGQ5l2a6I4d93TqkwHdJJf3cLVoTfRKTaEEY2JB3VcI2NarqON+26pjCPItyYPcRpvsgrQzn7LVKqzQDPUlAsUWQoW7tDUaPLn9pogH5+usd+yGwlAC/0RcTnQUk/GGiOYtPGeyPlJus3XHE7eLeETxeLnnS3lPILYGh5OHeyQoyFb3kySYiRMD5icv6sH6sUi2Y/uIubUirXrq/C7MUlnSuqyyoP7ONgaY6ATX2CicVWYV4SS1Ho6K9iR3eduvBO2I4bozw+RSbvZ9TxVnNJqx85spHqdZQ7jbuP/4CvCALCJpi3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ffpcsdw5f6j0SG+mEijuIwAMS7gbGELVQb0CuR4KNY=;
 b=B7qOClVqLIdDh2U55+xzIA4Alfbj67J5rsUIajU89nqtjUyXWPEg11/lUS8jx3ugyb0gOPig4r/nkF0gXEGG4CeaM2oFr/z8RU9O+FjMvahxNtX7xuW8pUCJlNm3zFYsgMTpG97ofDedezZ03Jo0KHHoSJI9P5FlFGU23VLNHao=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW4PR12MB7144.namprd12.prod.outlook.com (2603:10b6:303:21b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 19:38:10 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 19:38:09 +0000
Message-ID: <7d692196-f8ee-bd71-4118-af3a0663dbc7@amd.com>
Date: Mon, 24 Feb 2025 13:38:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 01/10] KVM: SVM: Save host DR masks but NOT DRs on CPUs
 with DebugSwap
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-2-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250219012705.1495231-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:22c::32) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW4PR12MB7144:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b49203-48c7-458a-6dee-08dd550ac4de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXB4QmxNVm0yMVZqRlNrejJxc2kvRG1VRnBVczB0RUFTRnJSV3R4T3BBWDNU?=
 =?utf-8?B?cWNNMDRQUlNQWS9nN2RDdXhpQjRpeWF4THJkMXZPTE1tRnp4cU43cW8zVVFl?=
 =?utf-8?B?MmVaK0xxYjVzWlRlR3FxQUF1VGxlT2docG9UL3pZend4dThCODE2UnRWdGp0?=
 =?utf-8?B?NDJscHB2SmJyNzBQcEV3bkxBTHBFMURFRGplcS8xTUk3a0lXNFkrU1pjcFNZ?=
 =?utf-8?B?TDBzaUs5Mm02QmNDSVorbm9iU3JkMjh2M0Z4WUVFZmlrdlV5enlXYmR0OHlJ?=
 =?utf-8?B?VGk2OXJQNFhGdEtCcDRnWnAweGlXb1NjRWFKYzQxV1VXNWVDSzBkTjhoaTdL?=
 =?utf-8?B?MDBReXlzRVNFSTB2MkI1MWFxMlcxekpvWi9HaGpYMVgzS1psamNncTlRNzVt?=
 =?utf-8?B?WXd2dFR6eHMvUVQ4amtJb052dHBXVUtGWFhyZzFNb2V3SXdPTjBzTUdMUmxu?=
 =?utf-8?B?dWd4TUVNN1lwd0Y5bHU0bUFzdmNLQzhTNG1uMXM2ZmI1dzA5WHErT2F3QktD?=
 =?utf-8?B?QzkwUHcwR3J1YlJYMkdtMC9lRnE0WUdhb3BYZ2pBWXNZWFZwbm5WaVVvMXM0?=
 =?utf-8?B?NG5JMjJuZ0NPa253ZzBjVGF5R3VSa1J1WnNPc2RUb3VHK1lTbXA4K1RGVVdk?=
 =?utf-8?B?L1p3NDAxZUxCMWREaE1lemt0RjU2SEhia3hKR3dDUTZpL2hDWFJSSlZVVHZV?=
 =?utf-8?B?NUZxdVAveUNEUFhBM0dXbXNYRnJOUVFZb2J1R2RoTUFqcjY5RXo3L1NXT1Ru?=
 =?utf-8?B?QUZWL09PTWRSVFJzd0FSRWVaWHFhMjhsTzcvNE9aZmRIYUd1bGhjTXFqUHVn?=
 =?utf-8?B?QnpLTTkvVU9yRGkxYk9jSmVkc2hqTk53RWNHYmVnKzhiWGhJQ05wMkdtM0tk?=
 =?utf-8?B?OUtidzFLK1FIbWNiZFRTdDJoWVlDbjJWcUt1WmNGQTFTaS9xWGxzR3ZWZE9H?=
 =?utf-8?B?MzFNRk5zT0wvWEhIZER5ZmpxMGx5a3hLT3greHJHajNid2x0YW1LcHh5Mi9D?=
 =?utf-8?B?V1YxNkI4VmJrSlFWajY0VXh3YzRzSit5dUhNaUZ4VktpNnAxMHNjK3JDbjhw?=
 =?utf-8?B?UmpiUGh6Q1RaM0RFZSsxcW1lRTJVbEdEeHFsakliK3hXV1VZUXcycjBMemFV?=
 =?utf-8?B?bmdOQTJxbU0zOTlVNjVKZmIxRkxZV2lPRHJyZXVGNGNnTHVrTCt4NkZXckkr?=
 =?utf-8?B?dzBRUFhSMFZ1UHRUeldRM1VmaVF2dUJuQXhEY2JUbytjQ1hRcEtNQStUd0hH?=
 =?utf-8?B?c3R4dzJjVGdEUlZ1bElCVDZyclFORkJOVUVZcTNWUnQvbmhVUXd6a3Y4ZlJ3?=
 =?utf-8?B?bUgrUmdUMEpld3dFWHBMVWhHQnNVN0oxMWI5L0tLYVgvWXpNa0JRZTdsL3d2?=
 =?utf-8?B?M2NEdzExUXY0d1RxdHVYQWRrUWpEOXVMOU5SZDZjTXRBS2NvNXNGUmpRTnFE?=
 =?utf-8?B?MmpPZTdEbFo0ZFYra3RwajFBNFdMdDFWMkRpNEcxWEdIZnAwb2pzYnNNTTY5?=
 =?utf-8?B?N1Z5elYySW9wVm9IY1MyRGRtT0JNUnI1alpvSHFTd0tZMDFQeUZwbkE1Q2Ra?=
 =?utf-8?B?b3VOczhKM0UxWXpnOXo0TUFGMDJvRy9jTDlkT04xWHhKeWsreTlPWDZJaGty?=
 =?utf-8?B?SytqZUt6VWIrcXkwbHlwNFdaaG5lYncxS3pUY2IyY0hRSSt2eGpyTFZoNFFX?=
 =?utf-8?B?WWN2RGpOdjU3bnBmSU51WU40ZHJRQ3FuQW9ETTBYN0hNWVh4d1dpektBRHJu?=
 =?utf-8?B?c3dkaVpoODhYYmpyZEJtZit2MmlFdE54ZFFUUkY2OERGeEszQytvY3dxc3Av?=
 =?utf-8?B?eFEwRjNKS01rQmRjOUJsSWhSTnU2NlNKbU5zQ3c3OXlDd1hXSXFHMmswRTFF?=
 =?utf-8?Q?yQBkZBa7e73AM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eDNJZGEvc0E0Uk51VG1uelMreGM1OHJNeGJHUTlvTE1DeWhpa0kzanZteHZD?=
 =?utf-8?B?Ylh5VG1PMy9FdDFRdTRRUXZKeVpXWkVwLzdROUhYNWM5RWQvdXBlQm5LaVVq?=
 =?utf-8?B?WFFReWR0YlBUS1hSZ3VrUnlkY05rM1BkRndoNXVnZ3I5QlRlTUgvc3JXOGlw?=
 =?utf-8?B?eUJSOFpBZnE5RklZaEovVkdoM011WWo0eFMrMWhQK29Hc0sxbXMrb3p4dDUz?=
 =?utf-8?B?VUp5R0NWQmlSaDJTMnM5ekErdVZ6ZEI5aUZQRUc0bzBHcnVXQnN5aE5qaHoz?=
 =?utf-8?B?S1RKZE81LzVWMjBwNXN0emVhQzBrUEZySGFiYjBSNHZrcWhWOG9VYmNGS0Mz?=
 =?utf-8?B?aE43blpyMmd3eUNsZ1pjd2xIYUJMSE1jenJJejJOMnY2NVpVVXJVZmU4RS9L?=
 =?utf-8?B?RVAvQUMrbUluY2sxTWZHN3RlSnFMNmFUTG1OSlJ0M1d3SkcweHF5VmpaWVVm?=
 =?utf-8?B?dGs2ZzVucGQ5cEZmRFRTamhENzR5Z3hCS3ZYRDV2NHFLM3JQRGl0cHdPRGFm?=
 =?utf-8?B?MXlkaVJzbythMk0vMUk5cjgyNDlIalg1L0lJWHpPVGJFQmt6QzkxTEtJNGhD?=
 =?utf-8?B?UkRrZEhKZWZVNWlpTjgyaEU3L2RhU2hxRjZaSUQyTzIvYld4eVAzS052bkpL?=
 =?utf-8?B?SHpmdWlFU0l2cmRKWFpBVmxIRHpNOTFvVm9pS2NsenpZajN3V2lWVGZOSmcw?=
 =?utf-8?B?YmdxZ25qWjQ1MkEreE9PRGJrdUlNTmRNVkVIK2NZanQvSjIzanBYMTkwK1Yv?=
 =?utf-8?B?d3drR3krRFBmWjRGK2F3b1BEd0ZuYithSEVjL3ZETm16RnVaNGRWdllQVGNK?=
 =?utf-8?B?RzdqeGhISWx5Ri9zWGl6aVRXcE9HTmpSNDJ5UGhmeHlWMW9hZlg3cU1udjVO?=
 =?utf-8?B?dnhOZTZzNFpvVXJRY2hiaHJsRzFkRG9KaUZyTmtTV3E4czdkS3dpQkF0OXJJ?=
 =?utf-8?B?VUJPeEtNZWFTY1dKbklRWDJuSEpseWJFaWpTVmlmUHo5TDI3eXU2ZUlCZkRW?=
 =?utf-8?B?WjZ3VVkvV1ZKMWJFK3lMZm9HSG55NEtxaFgvTlhMamVlZ08rdjNock1lVUFi?=
 =?utf-8?B?bTBwSUNNZG4xSVNrT3FzbVFENmN0dzBXOHN4eHhJTitNbXRkNjVwcTVRQzBF?=
 =?utf-8?B?eHk1TzNkMHM4QkRHMUdoelJQUytqNjZyM3p1Si9SQ2wwclA4MG9mVkxJTzk1?=
 =?utf-8?B?VitaMWhYdFNmZTJjZXIvOUdTZE9CejllcFQwaUdTSm5OcVBWM0pmb0J0RlRL?=
 =?utf-8?B?NXVLVlVTKytMdVg3dCtMaXJvUmlCMDhLQSt0VzNlUURoc0xwV2JsdjRuUkNJ?=
 =?utf-8?B?NHdtRWNKNEh6b2h1UUVhRkxZaW5VK0krTGFycG1wcTkxdThkWnVMSnJEaDNa?=
 =?utf-8?B?dVM2Y3lMQVVWd21FYjgxN3E2QXZEWCt2TlhNNy8vS0R4ZXJmajVpTytjbzI0?=
 =?utf-8?B?bkZMWkpMY2FLSzJIM0dnRS84WWlmTXkyRnpibE91QUlKcnFLSlp5UkRGb2FO?=
 =?utf-8?B?T1pEVDd3UDZhQ1Y1dS85U0h0cHZkSUtQd3VzYUJCZ0wrbmhnYlVUT2hwbFI5?=
 =?utf-8?B?OUpwREY0MVBoSnBqaFJ3V0RrWUFscjMyU0NrZk9oczhyNmtiZU1NMGVHYlYr?=
 =?utf-8?B?WWxzazFKUjE1TkwwMGV2WWhFR2RXY0NldmVkWjJuRzRMMGZVUFVTREc2MUth?=
 =?utf-8?B?VWI2a1k5QWdMWG9ISEp3WmNyRkFTQkFIbGtpQlpTTEFyTzFtTVdVcGkxY0Z4?=
 =?utf-8?B?WWdDR1Jpc1JKeks5bURjNC82c0kvWW55VUhxWkY2ajFXc0FzVVZ5MmYzajBO?=
 =?utf-8?B?UGlTS0hremU4RTVlejJKUEFpMTk5RnZxdlErenB0ZEdRMjJIZHU2d28zWHB5?=
 =?utf-8?B?OERDbENRT2RXdE5JK1JnUVQyYXNiQzJpT0QzMTA0bEk0a0RKUzR6b0ppTzdV?=
 =?utf-8?B?M3FPVm1rZHpaZWYwNjFuZlh0NVpqN1BCNGl5eFhTdnROTjYzcUhweHV2aHht?=
 =?utf-8?B?WVRuYmlOaW53WWhGczFjZDQ1aFRWQ0RzOFVPdERnYzRjY3BmSnAxYnk1TjZK?=
 =?utf-8?B?S3YyV1RRcXhMcjZjdE83Si9wMjNYcmF6YzlOUmdJUURydlExZG9jMUZSZWRL?=
 =?utf-8?Q?upSO0d30IZZqJoXuydgtmfYQW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b49203-48c7-458a-6dee-08dd550ac4de
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 19:38:09.9236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AwPtjCZT6rTN9JAp0kUvq+1a/xkTSQa70vB7o8VzBUs8VVHc0By9BeBQWwFk3clWYYBx6t09pwP0MZKok23AYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7144

On 2/18/25 19:26, Sean Christopherson wrote:
> When running SEV-SNP guests on a CPU that supports DebugSwap, always save
> the host's DR0..DR3 mask MSR values irrespective of whether or not
> DebugSwap is enabled, to ensure the host values aren't clobbered by the
> CPU.
> 
> SVM_VMGEXIT_AP_CREATE is deeply flawed in that it allows the *guest* to
> create a VMSA with guest-controlled SEV_FEATURES.  A well behaved guest
> can inform the hypervisor, i.e. KVM, of its "requested" features, but on
> CPUs without ALLOWED_SEV_FEATURES support, nothing prevents the guest from
> lying about which SEV features are being enabled (or not!).
> 
> If a misbehaving guest enables DebugSwap in a secondary vCPU's VMSA, the
> CPU will load the DR0..DR3 mask MSRs on #VMEXIT, i.e. will clobber the
> MSRs with '0' if KVM doesn't save its desired value.
> 
> Note, DR0..DR3 themselves are "ok", as DR7 is reset on #VMEXIT, and KVM
> restores all DRs in common x86 code as needed via hw_breakpoint_restore().
> I.e. there is no risk of host DR0..DR3 being clobbered (when it matters).
> However, there is a flaw in the opposite direction; because the guest can
> lie about enabling DebugSwap, i.e. can *disable* DebugSwap without KVM's
> knowledge, KVM must not rely on the CPU to restore DRs.  Defer fixing
> that wart, as it's more of a documentation issue than a bug in the code.
> 
> Note, KVM added support for DebugSwap on commit d1f85fbe836e ("KVM: SEV:
> Enable data breakpoints in SEV-ES"), but that is not an appropriate Fixes,
> as the underlying flaw exists in hardware, not in KVM.  I.e. all kernels
> that support SEV-SNP need to be patched, not just kernels with KVM's full
> support for DebugSwap (ignoring that DebugSwap support landed first).
> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Cc: stable@vger.kernel.org
> Cc: Naveen N Rao <naveen@kernel.org>
> Cc: Kim Phillips <kim.phillips@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Alexey Kardashevskiy <aik@amd.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 74525651770a..e3606d072735 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4568,6 +4568,8 @@ void sev_es_vcpu_reset(struct vcpu_svm *svm)
>  
>  void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa)
>  {
> +	struct kvm *kvm = svm->vcpu.kvm;
> +
>  	/*
>  	 * All host state for SEV-ES guests is categorized into three swap types
>  	 * based on how it is handled by hardware during a world switch:
> @@ -4592,9 +4594,14 @@ void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_are
>  	/*
>  	 * If DebugSwap is enabled, debug registers are loaded but NOT saved by
>  	 * the CPU (Type-B). If DebugSwap is disabled/unsupported, the CPU both
> -	 * saves and loads debug registers (Type-A).
> +	 * saves and loads debug registers (Type-A).  Sadly, on CPUs without
> +	 * ALLOWED_SEV_FEATURES, KVM can't prevent SNP guests from enabling
> +	 * DebugSwap on secondary vCPUs without KVM's knowledge via "AP Create",
> +	 * and so KVM must save DRs if DebugSwap is supported to prevent DRs
> +	 * from being clobbered by a misbehaving guest.
>  	 */
> -	if (sev_vcpu_has_debug_swap(svm)) {
> +	if (sev_vcpu_has_debug_swap(svm) ||
> +	    (sev_snp_guest(kvm) && cpu_feature_enabled(X86_FEATURE_DEBUG_SWAP))) {
>  		hostsa->dr0 = native_get_debugreg(0);
>  		hostsa->dr1 = native_get_debugreg(1);
>  		hostsa->dr2 = native_get_debugreg(2);

