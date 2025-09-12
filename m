Return-Path: <kvm+bounces-57396-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 80970B54ED1
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:09:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DFEA1C83987
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5141E30BBAA;
	Fri, 12 Sep 2025 13:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eFUs6A14"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E65C3009CB;
	Fri, 12 Sep 2025 13:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757682567; cv=fail; b=sfRRY4ZS2Wn/N6BXU5W0yCBFHDW63XarRAyyQ1D4iUDhxeTb+OwY5jkJc5vDLIHoz9Bg7EihUSv5dpnHxDtqZZcVHskfBFrcWgXGSa8bFgxVSC0BIJHSNy6oq9Sqh0qBAFYM3TiRgyliBAaNKkEZIebplGRFbYwl0Lv5xPYtkuI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757682567; c=relaxed/simple;
	bh=M4GC3XJWbBtcRn07WeahiH/aAVbVqzyVBm6lscKzOw8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fXURpxW74DN2TEQOsPHGtmLXFchJ558rDfFSaW732dSQV6kzFdvepJMjD6NfEw3Hmcs1kIBtQTbqKP1HhTLpVRHrshuK8BpVfLu3rsNZVpRut8gmjwhuDaY86u77MlifmLOhBISAUNru/Cen88i/N29Rfu+CPA1zFtRq58I2KHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eFUs6A14; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ddFB6BDfIE8m7CvTVRrpHNiXtLYBgE4HbfE+h3BZ2WXRH+gb0Yg5cAWU7QpHN1YWSESYEX/1hVE34ln8mqgsiCy+6gwGV4MzQRpDjlm7aY93cb4OnC1WAh3Mnf+wCEc33giCK9t/gis038DPrIgVnXqTOjmrT23xgTAoTI7B1wO2Ibp+yrtMY/dVaHSjt1qeGW/eQ5rVATYQJ6VgmiOv3xmZRQLtabcDSO8ZEqCBDcp5eu9MaEMOH3yIWt2vLhiHNrVerVzCsuJfOForZssECxj3TDH9/Lm7jpK+8bPYxpsPnXizucJ++B+lzn/YikBIKTZXZm+EeYT/9/cuPcDIWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NYuHhWmHmKMR9rYYfOhkHLMnmM+JYEx5ZJ2LXwN/QaY=;
 b=cDSG8jJLVof3gt4nVmLZsehsT6L3p/v4SZq103UyI6votwMDpFVTmVg4XzHP98q3ctqA+VdL1svIwArZRqfeXfm2MaDVr3kkeUtjYWNz4W0MWq+5acuTIQwNldpJzhGyUYt6pnUXReh6n3MJqAkItpM9Rc8ou7SscsfXvb5Nhz/BeRt2oQFMLVs9wcy9+XrKZyLHWSjSTqCIFj5pOwZjj4q4QQ4KkH9ebN6lKDgVhAA50XnXMAutfXn2dgWgtC7Vy5TS5gznsPDmfQGusDl8fH8YtIj1LKSLWww63nIjDqWPE+3Okj5+PtRr7Pr3dVrrILN7ial0emOHHjkaGNbkOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYuHhWmHmKMR9rYYfOhkHLMnmM+JYEx5ZJ2LXwN/QaY=;
 b=eFUs6A142tXzXR/ITN9c8vFkdHlK+z//yJwu5b1LLZ5rfeTcPtZwsZKFpV2aEMu5MVJB7rRGtFXnCrvgbyfuO8DOLzd+Uuurb8dPLvzmhvH/KrSVZNWjqYR7Vm4Z98JkDyErpv1/7WcG7Gy8MAN+k9LS6QSC6w8dK3Dvcam2B0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS2PR12MB9709.namprd12.prod.outlook.com (2603:10b6:8:276::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 13:09:23 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 13:09:22 +0000
Message-ID: <8bfbf419-82af-4480-9f99-95fd2d205723@amd.com>
Date: Fri, 12 Sep 2025 08:09:20 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/7] KVM: SVM: Software reserved fields
To: Yosry Ahmed <yosry.ahmed@linux.dev>,
 Vineeth Pillai <viremana@linux.microsoft.com>
Cc: Lan Tianyu <Tianyu.Lan@microsoft.com>,
 Michael Kelley <mikelley@microsoft.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>,
 Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
 Wei Liu <wei.liu@kernel.org>, Stephen Hemminger <sthemmin@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "K. Y. Srinivasan" <kys@microsoft.com>,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hyperv@vger.kernel.org, Venkatesh Srinivas <venkateshs@google.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <a1f17a43a8e9e751a1a9cc0281649d71bdbf721b.1622730232.git.viremana@linux.microsoft.com>
 <67feoyvmmf2sl34kikk3btrfcedafax2pazht5tplxyeb5rtv7@eakih2vxt2xc>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <67feoyvmmf2sl34kikk3btrfcedafax2pazht5tplxyeb5rtv7@eakih2vxt2xc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0163.namprd02.prod.outlook.com
 (2603:10b6:5:332::30) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS2PR12MB9709:EE_
X-MS-Office365-Filtering-Correlation-Id: deef7271-fb71-42e0-a9c7-08ddf1fd975e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bE9tZWZPWFZBNXVNTHNJZEFoaEJHalI4Q0VFcDFzR3pYUUVaZ1VlekNVQ3NQ?=
 =?utf-8?B?allRK0VZMWNVMTRtTFVHR0RUYkxaSHdrUnN3OExNK0lweitHdExka0pXZ2Jr?=
 =?utf-8?B?UnVCUEFSOHVSTzh5SktvaXNIYkxLSkVUN0NyemJTVGJWQXdwSTlwN0F0aEtV?=
 =?utf-8?B?M0ZqY2U1a0JhaFdRTnVVdTVBTmdEMFVaK2Q4bHN1VDJuV3hDRzNaaXNVUmtF?=
 =?utf-8?B?NTZFVFJwY25Va3ZvT3VKYmY5aW1oWWErQU5uTEI1MFpNZG1DY2Z4L3ZEaGI2?=
 =?utf-8?B?WVdMWmRCS2tZbFBZRTA5ektNNFN6b2t1cjNpMys2TXlGc0p3RENOQ2VST25s?=
 =?utf-8?B?Kyt0SnNmWFB0MU94dkJCRG00ZVJFVnY0ckoxdm5EbktOOWtIRWtoNVY2UzhK?=
 =?utf-8?B?S2l1d1p1d2EzV25oVS93SFY3blV3REhoa09CWFFCR2dWa1ZMOVk3dE9SV3la?=
 =?utf-8?B?WnlSL2E1RldORDJrUFNqRkxjWXlOdjhuTUZWcXp2ODVwa0NYQW9ySHcrN0lC?=
 =?utf-8?B?aW9lYTJTUGpTNmE1K2I5cUhmenFvSGdpZW9ZOG80VVBnN0dNTnlibHoyRlh6?=
 =?utf-8?B?M05BcHZJRXhrUXVTN0FOMEtBc1MvZTU2cDlSYkd5OFc4eWR4Rk92ekd0eTRT?=
 =?utf-8?B?cWpDaGh3SEc5M0NTelllZGdpSjN0RklzNkVZekdhaDdPU1c0ME1NMnZXWFA2?=
 =?utf-8?B?U3k2UW1hUFAwSEM2aG9UWGJTNFhmTU9UYnlvSjRZYjZCS2IrV011bjQzUVdt?=
 =?utf-8?B?L1pvWkVsc0d1S2xwVFBuNnVWeER5L2hHdkZ6QVMwZGVXQ0xxR3R2TjJIVnhY?=
 =?utf-8?B?RklkNmxINXhoekJ4d3lQUUtlTDJMU3ovR1JMNFVEUjgrVFF4QW9JWFdyWXpN?=
 =?utf-8?B?MHVxMWMvUDRkd3h2dzEyWGtMWFVhaGxWUVZPbHAyMFgxTUpEWEs1d1ptRVpF?=
 =?utf-8?B?aUdyOVVOY1F4amxTNm5tdkx4TG8rU3JQYXlkN1o2RWljaGUvSkxUY0t6RDBx?=
 =?utf-8?B?SWQzSnlZK1dqcktlZ25pNlZNdGM4eGgwRkRXTitGMTVEY2lNYWVsSEd3YlVv?=
 =?utf-8?B?QW55dEJmUEMzVW84RzZFYWxXS2dVMFpBVUwwOVdlalUvODU3STd0U2FqNGNY?=
 =?utf-8?B?bENCWEpRR3RBaklXSkV4cVlOT29HRVdHVVU5R2g2bytDOEo1UUdWWklxTjRk?=
 =?utf-8?B?K3hpVSs1bG9rWmd2b1JVSkFZRlZDVWVaTWI4Z1FtdXUxSTdYWTA2bVhEMTZj?=
 =?utf-8?B?dmdnTEh1UEczZllxYWVLWGZubldRMU81cUV6aDBJWGE5UjJiWUszd29EMCs1?=
 =?utf-8?B?bytmN0xRU1FvYUhYc2tBdVdsSUtJZ1VrNWtYb2lLaFpjSFVGT3d5UVZ2RXJQ?=
 =?utf-8?B?RkYycWV2L0pJa2xKaFF0Tjdvb1VhbWxCc1FjaG4vcWFMQ3NRRnpvNjBLQmtB?=
 =?utf-8?B?WTA0MmQ0MWoyVFFmZG9hSkpvbTNZSkhReHp1NjVpLzNKTlEwaWM1TEZickF4?=
 =?utf-8?B?RExxYkx3VVlkUk5ZUWVzV2ZpSXZQOHg5Rkg0T29GMnhwUXZObTIxVVRpZnRC?=
 =?utf-8?B?OGJHay9qbnNWY2hlUTBwR0l6UXlaNkwraEVqVmZGRjZKeTlmaDNlVU1hM0Zt?=
 =?utf-8?B?TURFWnhKTTJZaFhjYytHMDFsNzVXVTRFWW9zby90ZGhZT293cm5EMndadzBn?=
 =?utf-8?B?T1JJYWpWOC95Q1Jod0xhbEUwRUN3LzVXcUJicmZqNDNBdlNuOEp0WG9CRDJF?=
 =?utf-8?B?VWY4NHo0THZhMVljOG1MWmg5UklZVnJlbjBadDNyM1pOOFhtT0hpa3pINy9o?=
 =?utf-8?B?eFk2NnVDNDV0d2tIRlJTbHZWMlJ6eTJoM3hEZGxaRFRIdmszaGJYNUJQSGdB?=
 =?utf-8?B?dHAxRVI2QWJiTEFwNHN5Uzc2ZlByRFk5TCsrZUFEcEkxR2tEOXpIbm9rdHk1?=
 =?utf-8?Q?KGKIAly98d4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SGs0U2NPalZJMEdQNFVyanR5L09sM2ZJNjFSZ1ltd0VYb0hDWVhJQzExSFV5?=
 =?utf-8?B?NjNESUprdHRDNGc0U0hIKzZyang4NW5lUzREWTNmVS9wS0t5d2VFTGRMaDhN?=
 =?utf-8?B?LzZ5RVUzTzYzZFltVFovME9QNlNobk5QQW5tRzVrc0FpN01GTEJVTTFteEpW?=
 =?utf-8?B?MDVQdUs1eFRRU20yRkJnemYySmUrMnRjTVkwbHZrTkNOcnc4YU9KNnFLc09l?=
 =?utf-8?B?bzhjbGZEdnRpOWJsUnJTa0hEZjVwcWJVS0lOQ0pJdTBvYWg1NE9VQW5kNWRj?=
 =?utf-8?B?OCtSTnU0dVlxMFFEMmVpcWg4VWc5Q2hudGlOS3JOQmM4TXVXam5RU2tpSTFw?=
 =?utf-8?B?b3lvQVdqdUhqczB1ZzBwODd1MlAxUGtlRlZDL3czSjVGNHA2YnU1L1lZanFt?=
 =?utf-8?B?cUVvc2ZMZFluZzZpQzlwRUV5L1IyQS9pZHdCeS9KVVVGeURNODRMQ2w5QjAw?=
 =?utf-8?B?YnhGTXVtZGJ5MHBhV0wweUJ6VGNXSUttanYzRGo1bmR6MVhrSVNXQkpkSitN?=
 =?utf-8?B?aHNDazVEMGRYV3JiV1BrdVBxNERKWEo0UCttWHZpYWY2T3QrZ3hQRGpBbjkx?=
 =?utf-8?B?ZDJWWUg2VkVSbFI2Z25QSkEvcy9WN2NwN1IyYXV1UXRncTZsSXJURDByY3JW?=
 =?utf-8?B?RTNuSi9SeGZMR1BRZXhkUzhLamZkQXRRTGZCTXpQNE9yUGZ4cXhYUXFNVTZr?=
 =?utf-8?B?R0tLTnA5VWU5dENOUlEybm1sNWxoak9ZWk16MWZhRFJpUnVxcUczY1hsVGRS?=
 =?utf-8?B?YnNKV2Y3VmUrN01JY0RaT1JaWUd0V1czSmsxaXY5N3V6bnVPL0F1V3ZyMVJS?=
 =?utf-8?B?SE1qNng1WHV0UXNGN3VEb2lNNlBEVnIvaTlFSG15ZklwMTg3VWY0L1YrMXI4?=
 =?utf-8?B?YXR6bllCd1JGN2JQRXA4YnJlejYzOUpqZStCeGZscXNLOWxKSnRHYUMzYmVl?=
 =?utf-8?B?Y3JXNDZKVkVyM01FQjEvMERBMDVYd1VJYXdQM0pCVDdCaW1qR1FKQkdNL3J0?=
 =?utf-8?B?eXJUUENWQjFOMTNrWk5YV2dMZTY5QTNBWUZSNEovcUVmOW9scklmSXN4c2RL?=
 =?utf-8?B?UVh3MXZ1VzRwRGt0R3lnY3NRVGNHN0VQbndjcUo5Y1VOdGxHZGp3N2NVVWtl?=
 =?utf-8?B?b0xTclRJVEorUVY0dmdvOTlMajkwb2Y4UjlMdFYxNnRmY2ZySjlCeWJwZnlL?=
 =?utf-8?B?a2lMbUNhR0U0RVltbklXSVFSNElwNkVxeDRDRTdpRVFFVG9lQ1pGUUFyUzVX?=
 =?utf-8?B?WTBFSkJVWDZyQnp6NlVIME5NK3Z3R1B4RXBxeWdQOVRNVG4way8wbGFPV1NN?=
 =?utf-8?B?ZytXTFpMVzJrb0dVRnVZd0FYcmRuU0Q1RlgxWVB3NEMzODRTZFdTbXZrbUor?=
 =?utf-8?B?OW9iSk11bSt5d09IdXovYkFncTkrM21sUGdHdW5vcFhPLzQ5SVNTRWVhWW51?=
 =?utf-8?B?S1FKK0FzZzh1TVBHZ3lIUmg4bTJsSGx4Q0srbTNCckxZTXdtZ2phcUxXUVRs?=
 =?utf-8?B?cWNSRXpUZzBTbDQxWTAxam9yaFhrN3MwQVFKb1RKeWN4OWZkRGhCMGRaWHlX?=
 =?utf-8?B?VHpKMXIrS1lBWFlhYUpaZHlBS1BGalhuM0VCZHRUNmNSNC9sM21tQ0J2ak5T?=
 =?utf-8?B?L2ZKYjBvRUR5dlRaS2E1d29XVExWSis4bkJpaEVjdGhJSktwMFNxN0Z5V2pr?=
 =?utf-8?B?TkkyUTFzWWRXem1UNWdVZ2w0SEVyR0REbHhIdEo1dWVnaWY1S1J6VTNMeFdH?=
 =?utf-8?B?d1FuVUwvVSs3WVE3SGRhRVFqakxScEM3OGNpQ0tHaFo2TG5tTlBKaksyeDda?=
 =?utf-8?B?NzRmeHRmU09LeHdjMXFpMGFWaW0yTlJ2R29rVG5yZWpWWlhQZ1ppbUMxd0JL?=
 =?utf-8?B?YmVOODJPb2EzSUg4YjYxYlJmQ1dmZ0lGeFFNZDJZTTNRdzdMbmpFWlVEaVgx?=
 =?utf-8?B?KzE2SkhIM2xRZk5BOUQ4aVhKRUd5WlFUZDlJNzFjdHVlaTZHR1huWWtCejR5?=
 =?utf-8?B?MzlZbVVYWnhBREF4ZWRyS0crcThUbU1UTU1yMjJFeStqR3h5clhFQnhEYkdX?=
 =?utf-8?B?MXFoWkNGZFl5TTJUNHorNDhRTkJXMzJyMVhmYkV4QUVzRld6U0lRTG9menRV?=
 =?utf-8?Q?qS1jBj+ObDWG2kHkGIE1g5isA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deef7271-fb71-42e0-a9c7-08ddf1fd975e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 13:09:22.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZMapxTYfrELaZmfRK1SnjfSTyuJyM246WbfLtWyQWhx8HCuV1yqb/RjqH7ObXZaH1tXrhTz+v7XEhiK2eikDjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9709

On 9/11/25 17:35, Yosry Ahmed wrote:
> On Thu, Jun 03, 2021 at 03:14:37PM +0000, Vineeth Pillai wrote:

> 
> Apologies for reviving this 2021 thread, but it seems like the APM says
> in Table C-1. SVM Intercept Codes that the host reserved value is
> F000_000h.
> 
> APM typo or wrong KVM definition?

APM typo.


