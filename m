Return-Path: <kvm+bounces-24925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0968895D267
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 18:06:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E9701C2090B
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 16:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED0518593A;
	Fri, 23 Aug 2024 16:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mctR9m6W"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3BB189538;
	Fri, 23 Aug 2024 16:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724429166; cv=fail; b=S7oeKk/2pk1Uck7CilggBM4fTOOMRiLcdgEjiWSToDBBM950XLQp/s+0KBUAsFwSX9xoBzm3QVIXj3LrM7KE6EbPWaGuibQ46aspvVxYOKNewcsc4QK2CfJcyURZG1pX+T4Dpxb9oa6fxGOJF20yrlM4h1am8wn+P/RfhEhBmG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724429166; c=relaxed/simple;
	bh=T6Vt/kE+jnD6//Slf6LQ386x2gWtjUQR9fegzk0m8Bg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=seM2LpzwkP/XFo/qdagbDB7Dbi2T6ZCHW1QBIeP36qALvXwBh5ZKwtO5fKtXDZaAyoJRgUIWC7nfV+hsyArVL8Wk7TUHlD2gmrFRyvI6NZ1+KlmbI3BYOuWKj1a8Z948sJEzOgFSOk38c001+VlgMjwUQfCenyRjeKM8nfu5WJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mctR9m6W; arc=fail smtp.client-ip=40.107.220.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VfaX8fqxB3PN8kPpRTrLgfyRlrnLpmVtEPXhgMNfWQcKT1Ns2ZXtsZYftJnrY/RHZhe+4vP0sKREMEk/YaydE3M3iBOaG5FdqXl8ZfW5MyWG6xE45TZBPNj4n0MRdlSPu+5b77olOL+wkMv5B49vunupWZ9YDoXuA4ryKNr6NaGTIDRW+UpeWbqepHCg/J9Omfp66kIpTxfj+bHR/W2haI4JWozNppZjcnlWMkvlOgadZqVxMKchX/H1DFr9Fw+RqwxhIZB0TPFQujLv3zZ6FeElM5ocC4WNbU/akIZWbCkRgTKOfLMKcOOZxJ771sQE0qQ1oT0trkA69B2xVaS27Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i3k14bUmP7Xy2E5kp5PyAASvojaaHzmDVRjVJFw17+8=;
 b=pZwfmF2RBtJS0v1GSqmC7h1R3v2BA3O8eyvm8UanCABsVTN0iANf5eHz3kVcLhVHSIyDmlKZZRjDD358+KrAGILH6gVkpuIa5rokt6nPxlWyt/HdVALKJtNr5U8+QKta0oIumEyStOTAHy67/07gJOmPm0Cw7iUHSoErWBdyTbpopusiGQbtBPaC6URdEtk2Rj3B/8uEjvqcI+jbJWz+NqcgFcujruecECYudxhi8xypsXjsP9F0zZ2mE7Rxn5zcIwj8btyv5ZvfDvDR+ftKBwbSe3gUIWDDwfNo8//D0W3FTrB0sATbk9YS+gyhBC9MM+C0ea3g+07V2EtZghxzJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i3k14bUmP7Xy2E5kp5PyAASvojaaHzmDVRjVJFw17+8=;
 b=mctR9m6WLFhDfXgPeF4O95r0AuZoDqFqvR75UUUD0bPQYab2UbEx/O+ZyQEnWg/pPP42aIISNjr9BbJaydtgRy7JBTBCf1TCvJ8+pHm5fanV9qe/JYbG7XE9k+VjF8D9HoY96po3Ji1s2bu8HI++HpB0zlxzMC7HpcgHDzxa4Lc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Fri, 23 Aug
 2024 16:05:58 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7897.014; Fri, 23 Aug 2024
 16:05:58 +0000
Message-ID: <93effd6c-124e-07fd-57ca-ed271fb50665@amd.com>
Date: Fri, 23 Aug 2024 11:06:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/2] KVM: x86: AMD's IBPB is not equivalent to Intel's
 IBPB
To: Jim Mattson <jmattson@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
 Daniel Sneddon <daniel.sneddon@linux.intel.com>,
 Kai Huang <kai.huang@intel.com>, Sandipan Das <sandipan.das@amd.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
References: <20240816182533.2478415-1-jmattson@google.com>
 <20240816182533.2478415-2-jmattson@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240816182533.2478415-2-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0082.namprd11.prod.outlook.com
 (2603:10b6:806:d2::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MN2PR12MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: b3e47085-339a-49ea-19de-08dcc38d79ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dnZrS2UreTRpbWdCY25KaW4yVDA1NEtveTN1K2dXVXZDZzgxVFdkb01VNDN2?=
 =?utf-8?B?WEEyZXoxUytycW1PQ1ZOUWY0MnVXY29aRVp1eCs1dWdGaWtjRjU5ZGdLODln?=
 =?utf-8?B?dURCUVIwN24vc0VhbHltWnBsdkRYNXkxc0VBTFVuTGtydjZ6MDZ5Z2gvM2RU?=
 =?utf-8?B?TGVEYkZja3FHTVc1THh0MHNUNnRNbGV1d3J0Vks3Zm55dFJLN1Rab2hlQjcw?=
 =?utf-8?B?dFJNMGtxeDdMNGU3L1FTa0xrVmYyY0VxRU5uUVliMWpmUHBJQk1vbFJQbmZW?=
 =?utf-8?B?MDlvZ3JON043bm5PL082aUQvSlMrRzVOZ0FXUmZwSDZ6Qk8vUFdIcWlJQlcx?=
 =?utf-8?B?UTRRRzFmTkVaNGpJT3V2ZTNPQThMcjkvL1ViRWVTWTFaeVNaMlh2eUpxRnZS?=
 =?utf-8?B?OVhETWRPYytsUldWUDRDOG1qNUZIc2hvaWl6cXBIL1U2enRpRmhmbjJQdktH?=
 =?utf-8?B?ekNNRjVKaHphS0Q2MEF3cXJ3OWVtSVYrVjZVUXF0ejFBcDNUelVUeHFwckFU?=
 =?utf-8?B?RWxWWElaWjhmZTZXQWVvWUJjZ1NqbVM4SVU1cE9tQ2g4VFVmeFFScXZCQ09u?=
 =?utf-8?B?Z3diLzlLejFXMHpWeEVtQnFIU2ZyZGRIR1ZuMmozWHU4Rkpvdm1EN3dGeFZK?=
 =?utf-8?B?NklDQUdQeVV3UEwrRjJnVHJjaDA0dG9YZnhCY0FodnZCemhPUGxxWTB6dGlM?=
 =?utf-8?B?MEE2OEtRWHk3cjZ4VURTdDZSdVdLZjdjRXVCWFFSbkUvMTY1eDU3b3hScTlh?=
 =?utf-8?B?aGJqZFBNTmxyVFA5SkpFRGp4LzJIczZDUzQ3QWtsYU9aRnRrYUh1cFhsRHZw?=
 =?utf-8?B?MEFnb3hVdUJCWC8zVVhwMjdSY3VERnA2OE5HMEthN1gyUFVpanVONzFBVmpu?=
 =?utf-8?B?MFBZeEx0dGZ6b0Jva2pSMUU0OGhtdUIvQXRmQ1pkcjFuZjg4QUhNOWJ4SW9z?=
 =?utf-8?B?Z01Pd2J0SlZkZXh1OVF3SXJ5VXVHa1BUUjhLLytQSUFVM09lYWtuUUZtTGFi?=
 =?utf-8?B?c0VSOHZWdDEraVdTa2JpcHhMRis5bSsxclNoYVc5NGF2YmpNRkRXRnBTcGN3?=
 =?utf-8?B?Y0h5bFUxOFMzS3VqUC9xaVRjdGF1VWhITGZhOXd3UjloSzY4SUJjanpjZGlH?=
 =?utf-8?B?V1psaWF0U24wekdOWU9HMytMejZUbWxRN2MzY3ZFRGN2TldGcWt1eXZJVVE1?=
 =?utf-8?B?ZmpXb1EwVkRGM1JtUEE1Z1JqNWROZW1rOEMxamU5SHlNckZpWXNtQWhxVzJ4?=
 =?utf-8?B?MWsrVEswelhIS3pzemRCNk8xVno5V3ovclBGT3c0UHp6V25FQU0rKzUvM1cz?=
 =?utf-8?B?anRVU01COS9sejR3dEpTTEpWQXdOaDNSL0VDT2Zzc2c2a0puTjZSR01mMVZu?=
 =?utf-8?B?emlKb3d1RDd2TEhjaXFkSU5ZRkN4Uk9vdG96NUlaa2U3WmpIWGQ2RkFkQmRp?=
 =?utf-8?B?NUVBNDRjUUNVVVIzMUdLYXo5UEcvVWlOVERuZ1Nja0tLRlYxZlBkUVhHckQ1?=
 =?utf-8?B?RE9obFRtaVNHYk1BZ0V5d0VLalhQdjUrbVlwU3hxSkQycWVTelFSZ1lKYzZs?=
 =?utf-8?B?UXFISkF6YVVtV093RXp5YmZFQVlWYjkyVVZwWlMzcHRJM2RrL1o5NVlLTXN1?=
 =?utf-8?B?UjE1Wm9ZK3hSU1pxVCtKY1VkMmxlNkJrdFNKM2VHTHpVOXQrV0ZoeW9xdGtN?=
 =?utf-8?B?Z09YRHNXL3VYSUhYK0hyNTdPTVVBQ2l5NjBKQm5ISGl4d0V5NnByR1VNblBO?=
 =?utf-8?B?aFQ0NExsbmxDS1pYUlVGYTEvRlZBRGxTM0hSN2FaWmN2WmE5RHBLWVJJd09Y?=
 =?utf-8?Q?GqWvpgUpfSKvthFg5h1Ud0BXncIKz/pBVVBa4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0s1dTRaNXdhcGxFdGQzdEpsYnlvVnlDU1d2NFk4dEhjNWVudEdpdUpBVkxF?=
 =?utf-8?B?MjJpcWNmTm9qY0lja0d6ZGg5L0ppUGxBUWZ0LzFOdDcrTWp4b1FmRnEzUTRo?=
 =?utf-8?B?TmE0SGw3RnNUU3dlTU5qdlhmanQ1SUhCekEwdE9RY1NyVjVNSDBDZGxVc0lr?=
 =?utf-8?B?ME9IUllnc041TktzMnJrUmlIOGV0bFI3dG01S3RiNjJ0dHNhaDU1WE9SMEVi?=
 =?utf-8?B?Y0pxWjYrKzd5L283Rm9HTy9FNDVadUk0eHNiYWpOZVlaUnhnbGlnYzFtaVgw?=
 =?utf-8?B?TTRzdHNpUStEWE5EWTNKZUdvNWlKSWJqT3dwc1BIVWJBL1ZmNTArejdmbGRJ?=
 =?utf-8?B?QVlyRC83L0c4RElJNzI1Mk5zZGVtcjJJemxqQ2R1YU9hQnBnRFVDaCtySEN0?=
 =?utf-8?B?a0ZrSUhESUdFZ1hoV0MxdEVFZlROZUkxUms5ajdoZk1BellqZ1MwbkwrMHNx?=
 =?utf-8?B?MG41RW05ZHlmbFJJVFYxZDB3cFB0NWRlLys0UTFoTGcvdmRoQmw4aHozc0kv?=
 =?utf-8?B?dkJFa01tTDM4NS9SNGVSTExzM3g0MElxSnhQcm5Xay9zUHR2NDNwMzBJVWdy?=
 =?utf-8?B?RWJ6bWhSbEJJakcybis3SEN6VXJ5SndPbDBKTFZ2Q0RCbUpqa3VaSE9ld3px?=
 =?utf-8?B?RHY4M0hsQU9ia1FHa3NtcDlBVThBd3cva1QzKzBJS2VNQU1ndWdnWHpFeEhx?=
 =?utf-8?B?b2xKWWJPRTBJby9hdVlPQzhPUDJJeXgzbVZLSnVIQVJUelJNcG9FWmdvbHR0?=
 =?utf-8?B?MnNoSG8wTXA0K2ZhRHZjVDk3REdMYWtqMlNvWEQrcFRqQ1BUSk5DMDZRSFpn?=
 =?utf-8?B?TGNXNForRjVKckdPclBWZGNzdFdQOUZwUXdOT2owekgvbisrY0xxTXJybFl6?=
 =?utf-8?B?ZG0zSmlUVkNXQy9wNXlIN2VMYjZOZ0FHMU4vR3h0Tm9pVjh2RE92bjB4RFAw?=
 =?utf-8?B?TVVhbGNycW50Yml2WG05blFsWTBnQTRGN1pXT1U1cG1MVUx3ZE9IWHRUMmZk?=
 =?utf-8?B?TFh2UXBFZ3p5SkVqWXNwSWtJVkthcy8vTm94bkZRTnlBVks0NkFtK2pTN0R1?=
 =?utf-8?B?WnQ4Sm1BTVV2SFFncEk5Z0JrVUU4YVMzR25YdUpjSEl1ZktmY292eC82N0lv?=
 =?utf-8?B?Q3Y2RnBpS0YrRzhSczFwT2V6dDE2RUwxYjZGeTV4Nk9oaE0yc1g1S0FWZTht?=
 =?utf-8?B?TkNPVEx5MHF2ZG1VdjdSaFpFL3hXNE9sclppODFIYUIxdmltdVd4VXhjVjNk?=
 =?utf-8?B?R2czenp6eEhuelZYTmZONVF2R3RraUQ0bkdBYVZWa0dBallWSE1lZlJpc29p?=
 =?utf-8?B?Q1g1czB0S0w5NkhaaUtTeGY1L052WXJiZTZvN0VsUXZ1TmcxWkdmbVAxZkhR?=
 =?utf-8?B?RUh6M1BnSWQ4WTFBL2oyQytOUW1kRE1VcWtLQ205Z2EzdEEwL3JDRHFoVmxt?=
 =?utf-8?B?dTE0Y3dTNGJ5TTlvMjhXVE05dnVld1Z4TnZmNjYxVUtRcFdHcjFiVGhOcFZF?=
 =?utf-8?B?MkhKQjgveWxHSlNsdmxCVHYyTW9YemNYU2pET0JHUGlPbVRIWENYbFB2bVda?=
 =?utf-8?B?VjNhZHgvSnVVWEtjN0NFeHBsTit2MmpHUkU0SGNIcEJVR3N5OWpwSVlBWXJF?=
 =?utf-8?B?YjZ1WGpzcGR4eXlHREQ0WnlVUTAwOVE4NldzRWxabGZaOVJVTGVLY09aZ1M4?=
 =?utf-8?B?NHRnUTdyMW9VbG45Z0VrNjFoT3czL2lBT3ZJL05heDJTUlZHdzc1YXl1MlpO?=
 =?utf-8?B?NUo1QjNjZEhVSmtvTEJMVStJMi9rSyt1ZzZFOHQxeFV6WjRVY1NDcG5BRllr?=
 =?utf-8?B?SDc2Wk1XTHp2QlZOUng0T3ZVYTlXMCtHcGxySFkydE92SmM1VjIvOTZCY3dR?=
 =?utf-8?B?anZJRldOVE5lanBaYXF3OFUxaFA5dnIvSHJUWllYWWlieE5YRTY4VjYzWnhQ?=
 =?utf-8?B?SEtjVWJHeDhobjFlNnk1d0IxdXNnK0xQQ2MzemRKcndXdW5LcVgvSEN6UEta?=
 =?utf-8?B?TTRFVTZ6dnpUS0V3TWxQS3dmYVRIMXlHeU00VEhROXhQOU95a3RJRlN6WmlS?=
 =?utf-8?B?NjVmcUtIa2pDZVpIVExhdnQrZUZ5bThWU0JZUmdGYkNoNnZEUEQySDJYakVV?=
 =?utf-8?Q?I3KHETNsb3C79GvxsfGUP5vip?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e47085-339a-49ea-19de-08dcc38d79ad
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2024 16:05:58.0426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFn0waujm30Bg7vf/YNCLemuYBNXTsRqRtGsgV+k2C9YfoieRgfKwAKnDDegNIeMoFQYxqgLMkMqZTnG/KbExg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175

On 8/16/24 13:25, Jim Mattson wrote:
> From Intel's documention [1], "CPUID.(EAX=07H,ECX=0):EDX[26]
> enumerates support for indirect branch restricted speculation (IBRS)
> and the indirect branch predictor barrier (IBPB)." Further, from [2],
> "Software that executed before the IBPB command cannot control the
> predicted targets of indirect branches (4) executed after the command
> on the same logical processor," where footnote 4 reads, "Note that
> indirect branches include near call indirect, near jump indirect and
> near return instructions. Because it includes near returns, it follows
> that **RSB entries created before an IBPB command cannot control the
> predicted targets of returns executed after the command on the same
> logical processor.**" [emphasis mine]
> 
> On the other hand, AMD's IBPB "may not prevent return branch
> predictions from being specified by pre-IBPB branch targets" [3].
> 
> However, some AMD processors have an "enhanced IBPB" [terminology
> mine] which does clear the return address predictor. This feature is
> enumerated by CPUID.80000008:EDX.IBPB_RET[bit 30] [4].
> 
> Adjust the cross-vendor features enumerated by KVM_GET_SUPPORTED_CPUID
> accordingly.
> 
> [1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/cpuid-enumeration-and-architectural-msrs.html
> [2] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/technical-documentation/speculative-execution-side-channel-mitigations.html#Footnotes
> [3] https://www.amd.com/en/resources/product-security/bulletin/amd-sb-1040.html
> [4] https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/programmer-references/24594.pdf
> 
> Fixes: 0c54914d0c52 ("KVM: x86: use Intel speculation bugs and features as derived in generic x86 code")
> Suggested-by: Venkatesh Srinivas <venkateshs@chromium.org>
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  v2: Use IBPB_RET to identify semantic equality (Venkatesh)
> 
>  arch/x86/kvm/cpuid.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2617be544480..044bdc9e938b 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -690,7 +690,9 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
>  	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
>  
> -	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
> +	if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) &&
> +	    boot_cpu_has(X86_FEATURE_AMD_IBPB) &&
> +	    boot_cpu_has(X86_FEATURE_AMD_IBRS))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
>  	if (boot_cpu_has(X86_FEATURE_STIBP))
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> @@ -759,8 +761,10 @@ void kvm_set_cpu_caps(void)
>  	 * arch/x86/kernel/cpu/bugs.c is kind enough to
>  	 * record that in cpufeatures so use them.
>  	 */
> -	if (boot_cpu_has(X86_FEATURE_IBPB))
> +	if (boot_cpu_has(X86_FEATURE_IBPB)) {
>  		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);

Should IBPB_RET be conditionally set? I would think that you would only
want to set IBPB_RET if either IBPB_RET or SPEC_CTRL is set on the hypervisor.

		if (boot_cpu_has(X86_FEATURE_AMD_IBPB_RET) ||
		    boot_cpu_has(X86_FEATURE_SPEC_CTRL)
			kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB_RET);

Right?

Thanks,
Tom

> +	}
>  	if (boot_cpu_has(X86_FEATURE_IBRS))
>  		kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);
>  	if (boot_cpu_has(X86_FEATURE_STIBP))

