Return-Path: <kvm+bounces-71034-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNkyHsCDjmkrCwEAu9opvQ
	(envelope-from <kvm+bounces-71034-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 02:52:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DAF76132526
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 02:51:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 383723030EEF
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 01:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A06962253EC;
	Fri, 13 Feb 2026 01:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fzlkpuoN"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012002.outbound.protection.outlook.com [52.101.53.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19B546B5;
	Fri, 13 Feb 2026 01:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770947515; cv=fail; b=HOb5FfsnK8xRN5YaTIwxjGEZTFvxgl3XuIR1tKBA1Y1NnYi7pWw5xZcLGnTLiMSNxJSlBy/Vgjwom4PQCpaSLVsRQxq0Vk9eQAWqgfsYOcz1gCASzsUgNkkJbafqgTktZ/hLsgXfN75fLBCIsfUS6d37HOQIKDdJVkWIhXjO/GQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770947515; c=relaxed/simple;
	bh=s3vvwcVscF34YwtJJPq2/XOdUjnTFFcXyPI/6+QQAic=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h4ykT+51gU+fMrXcHjqJebexFB9BwFILPsfAzuqeE6wzG8gZi8/qhnfSOyvRFaaHCOi1LoitgJVjD65tWWjDM2xGy1duDNdAW8VdBZfJi4paHCGOPfiRIG9BD1hZ3gAI20+8/6HbUguT+JRCGcg1shRG0v0EavvfqKfpwSdELq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fzlkpuoN; arc=fail smtp.client-ip=52.101.53.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I8HJJrSQ6mg9Ej5USPltkokRkPdA/KnZQYdHTSZg2fKwXsVwxrCqrpVVpAQVunferSGhp/DWD+MMMCRnIYe8S7VRC7Y54y7Et9ZlFWKOZXwEd2n4+yKBoMmqrIVg320tVWDtKFA6n/2uOTc3L1NihQCkigpMAPy0AnUmLZLmjgVT4zS291TC9mXDIVRv+cefUgWTQSwQP5qFs47VXSFxKuFKa9RFEtOWry3uee4jP5of9jVLYZIhPgG6G/LjpedQVlj09er00A1dwQEPG/xdjPcCDjugvitD4EvPtTU7tIb86jdN3QQLoxmvD9wK6rCCnFTc/KUSVeDu2jo9+tWByw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VAZaI8NaGb7/Tq6WXh7MNidXlQ925hZI1bhkD/gjJxE=;
 b=NguwamRFe2u+zpu2a3yD4tzU387LfMpVbKhDch5mlBY3SWfx8A5lhhzCcgpWvTDdXL9VasAINzBEdkYqMIXRfY3/qb6If9SHko4uS93d5ledtbQ5b9lZMpWH8oYhFJitBRHfUd+B2fuSth1JfwHgDoex4O3C5/LUI0pd5oYaeCIKX5I/+BENTEqqJVZD5O61DuzfJP/QWx2xb1xgQybsjtnlQ2KMUcTMOWe8Chj18O43YlJSNpAIgHiUYnNkShc+iiHi0GL3WssAdKf4RyDPAXrO3tFm9XnYEPdCGDNF0d0z6V0gQOC4i47uLEFk6KsXpDEZxcNt1Qd5Af0o3v4hKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VAZaI8NaGb7/Tq6WXh7MNidXlQ925hZI1bhkD/gjJxE=;
 b=fzlkpuoNYwvmzXmKqTpqHLBJo2WYU2I6ori3ms2/FzRRpU9KkLbN+ZGkPjG0MjrEkjmKnpFPdFlcTAWHfE39U4qLrNuW5VI5UsI0f5fJSZs7ca50gG4O/mWkYEf7opCbwbE6oDPHjcO2ySVSf8TrI20IDlYVfzJo0Ldr4MPbA6c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CYYPR12MB8856.namprd12.prod.outlook.com
 (2603:10b6:930:c0::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.11; Fri, 13 Feb
 2026 01:51:49 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Fri, 13 Feb 2026
 01:51:49 +0000
Message-ID: <f72a62af-e646-40ae-aa16-11c7d98ecf03@amd.com>
Date: Thu, 12 Feb 2026 19:51:43 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/19] x86,fs/resctrl: Add support for Global
 Bandwidth Enforcement (GLBE)
To: Reinette Chatre <reinette.chatre@intel.com>,
 Babu Moger <babu.moger@amd.com>, corbet@lwn.net, tony.luck@intel.com,
 Dave.Martin@arm.com, james.morse@arm.com, tglx@kernel.org, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com
Cc: x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <aba70a013c12383d53104de0b19cfbf87690c0c3.1769029977.git.babu.moger@amd.com>
 <eb4b7b12-7674-4a1e-925d-2cec8c3f43d2@intel.com>
 <f0f2e3eb-0fdb-4498-9eb8-73111b1c5a84@amd.com>
 <9b02dfc6-b97c-4695-b765-8cb34a617efb@intel.com>
 <3a7c17c0-bb51-4aad-a705-d8d1853ea68a@amd.com>
 <06a237bd-c370-4d3f-99de-124e8c50e711@intel.com>
 <91d50431-41f3-49d7-a9e6-a3bee2de5162@amd.com>
 <557a3a1e-4917-4c8c-add6-13b9db39eecb@intel.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <557a3a1e-4917-4c8c-add6-13b9db39eecb@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR07CA0013.namprd07.prod.outlook.com
 (2603:10b6:610:32::18) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CYYPR12MB8856:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ebd4dc6-cf59-4008-5780-08de6aa273b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXdQa1kzMHFndCtrV0RJTzBzdldyRmFPNE5nSks4cW5DVzEwNWtja21yd29y?=
 =?utf-8?B?WnhrVm14Y3dPb0ZDL0dnS2dEeVBKNzB3SkNtb1hKRlN0cjhFOURIQ0tqTTNa?=
 =?utf-8?B?YUdYbUgwOEFNZDRQeDJ3TDJ5QTNZK3hONkRORG53Y2QzcjltbHA2ekJZTE1o?=
 =?utf-8?B?Sld2S21aZWNIQWFSeEpvY1BtV3pQaHdzeUh1VGl1a1A3bTlkdlczaXdMUHhi?=
 =?utf-8?B?eEFGWU8xWCs1L2x3QmUvSUhHZ3gyUlF2RElZMWVIOHRtWUh2eE1LaXd5QW9j?=
 =?utf-8?B?VVVMaUlqWkxrL1VGMmkzUzkxM05GbkdiWnd6N3V4WWx5MWgxQlpodnhCaW5S?=
 =?utf-8?B?Q2tKZmVHYWZGRFg3SUhkTFg0bktlZm0rNjJERFJCZzN1ZFB4YlJ0Z1ZXUEo4?=
 =?utf-8?B?OHA4ZHdJc0N2ZEVQRFVDYjlhZTVDV1ZwTVpYVGRnN2Y1TnZuVlBVeW9WeEZ3?=
 =?utf-8?B?RzI0dDJTZEpaNDFtamdQejB6R0RaZnNPd1hXNEVPMTBENVNxbUhxQnY1M1pj?=
 =?utf-8?B?cjJtRldub3BYK1VRdTdNdUQ1S254V1JId09TNlgwbHRoZEl1WDVJTHZiRmlG?=
 =?utf-8?B?YTBKMG52bzhDMFhUVnVvb1pGMkZBRVJRQkFvTWNIVnVTLzVoUENDVTU5a2tR?=
 =?utf-8?B?MlI1aXlVSVFRTmpWeFpzNFl2bDNTZjdnMWRUZm5lNzBjNW1PTEYzTjJmTzVj?=
 =?utf-8?B?OWFXNXBwTHpySnlHK1o5clhxWllMNE5sK1p6UkV6NWZTcm5yaTIyalpQNmsv?=
 =?utf-8?B?clhVWVg0bkdvMGQySy9HZ3dZRUxMVzVvQUs2N2RoZVlEYXpIWHVQUzdTU0ZH?=
 =?utf-8?B?Y2hIWEJiWXZaS0djTHJ3MHQxUlJZanM5ZFZLWlN3Y01lem1ScFc5SEVFMmJV?=
 =?utf-8?B?LzFVQkJtZnV6NUNLTnFnK1NzUWVMdUhxUHBHYWRJN1MxS2VTcnJ6RXlyTk1E?=
 =?utf-8?B?OTVxNkZhclZEMXpMdDMrYmN1eXNnUFMveU40aUsrMVVVcFdUQXBNb0c2Zy9C?=
 =?utf-8?B?MzhBWmtVU1pNSW9Ic2hZTjk1SzF1ZG1jSzhkZm93d05wR0tuSi9vMTZoWGRO?=
 =?utf-8?B?M2tIYlNMcldJZkJvM0lBeDVwTTM2RTUzaDRkYjV3a2prT1BuaGhyRUxaQ21Q?=
 =?utf-8?B?RUVHNksyRHVmeTFWY21oUzBIbTJPMCtlSHppWk9udDJmN20yRWZsMUV4c0VT?=
 =?utf-8?B?WVEvV0VFWVpSR2k1eWNKWUZzTVZSOEpaREtqcnhmV25jL2o4ZmhVZHI1Nmw2?=
 =?utf-8?B?Zzc2bld5V3RtSExVc0NEN0gxVUZnMmdxSmNqMHowNlhBRlIzSUZvRHdpWUJN?=
 =?utf-8?B?clFvUW9yeThQR1U2QksrTkI2dW90OTcyZXZFUFdjUlFwaXNYTnYvc1F4Q0Yv?=
 =?utf-8?B?c1Z1S3JGd0hXeVdRTkE0cDQ2RmhhWXpBWHdnZ01FVHlJMEhBWmpZVGZjSk16?=
 =?utf-8?B?d2poNWVlQXpiLzVzbmpCdSs1VnVsUW5yaHVXeENDZGhVQnlsZEhmTkhkQXlK?=
 =?utf-8?B?RWwrdkpVZ040cS9SM25MaElqMEdBdEVYVklySUdjbWJNRlErZGdha01ic0hD?=
 =?utf-8?B?RFltUjlOc0gySWliZVpVdWRFbUQvUVZ0cFV0RWc2Z1ZvckpydGJhVjc1VHN0?=
 =?utf-8?B?S1lGWithSW5oM1RBZEdwSHJhQng5UndBdk5wY0VXbkVKMjgwRnFPTFdzRFF3?=
 =?utf-8?B?cmFCYjVyZEtVSWhINXJLM0hESHQyamNxZllpcSs2ZFFxTnJQWUFHMWpTRWxl?=
 =?utf-8?B?UUJKUEZqMVhoV3VmZE9IVkNBdHV5UWJRdHpaNXZJMFNzT1dzTVRNN3VWbmo1?=
 =?utf-8?B?bGloSmw5Vk1YV0NTVGhuT2ZidmxkUkVBK1pEbmZYOGpsVnZmRzA2ckF6djRV?=
 =?utf-8?B?QzJaK2src2l1cUw3VlpNUW9zTzF4R013bmFlc3drbDRJNVBHMnA5YjIvZzE2?=
 =?utf-8?B?azBmZXFIT2lrNms0bWRRVkFWZzZxSlI0dUlUSWl4Z2REeVkwblBqVS96QjhC?=
 =?utf-8?B?US9GSTdYTXBha05XNFlRZ3VvZ0VnMzUxamhiTkpMTEZ2akdHQ1V4SjU2QWFx?=
 =?utf-8?B?VTFQdm0rK3NQaklqcUxpUnV2a2FsdFZpQ2JHTmtEZkowaFJTdEdCYjB2Yms3?=
 =?utf-8?B?NWI0Q0tXVDN6RTR3TG5oSW5MbjdsaEk3VHJUUjkyVzl0V2lZN2pHdFppQ1JF?=
 =?utf-8?B?TFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlhYTUUrOVFKdXhLakRXSTJVR1Z6Qk1ZNDZucnVML0xCNkQ4SFJWMjAvR3c3?=
 =?utf-8?B?VzQ4SGZLcmZRSzR4OHowc3RsdGhRVWhVa1pzRmU0Q0JZR1Q0M0tLYWpNSUt6?=
 =?utf-8?B?Yit3aUcwbFVTZUtWM3o4b1kvaW5wUGY2TE5pV1RxcTAxZ1VmRmlEakFwQ044?=
 =?utf-8?B?ZE1Wa2hGNTBoNGUwRzhFK1ZXL1JDaU52M1ZGclNFZjBRL1dGSkxncUlXY0M1?=
 =?utf-8?B?YUFBRUVwM25SZ1NWb1c2eXZzTnRWRTJjUml4TnRHVXhnd3B4cDRMRXpkb0RE?=
 =?utf-8?B?ak03RlVBSERxam9aVk5jU3Q4VTgvajhWNS9kVXhHUjNCeWpDamJ0NWE1YkJB?=
 =?utf-8?B?YUpSbTJRWGV5SktoWk5Pc3hSamErQS9kRXBrclE1L2F0NTh4SWM5VFhpb1lE?=
 =?utf-8?B?K2MvUFRNbGtkVXpSRkNZTUJPd0ljQ2l1UGFRaHlLeUp0NXFHWFArK0JaNWcz?=
 =?utf-8?B?RHlsUFJReSthcWNjaHJJbDlvL2RiQ3dMNW02UGVBYmswQThLL0R5V3hPSkRm?=
 =?utf-8?B?aURuZ3FkYVcwaUVmTVJ1bUIwUkhFaExQdEVaTmpINXJab3dBOSttZXAxSVB6?=
 =?utf-8?B?TmFEeWhWR05USEVOZlNHRnFXZC9KdzhUd3cwcE5GQStacTV3UmV3NERkbHh1?=
 =?utf-8?B?ZlZkdVFVZlIwNlRPL09TUDFWN3BVQzdVd3dDYlBMZExiRmlRS0FrRFhrMWlj?=
 =?utf-8?B?TTErVW1TVTUzTllrN0h6Rzd3d09XaUNUMjI5VjFFLzl0aDgxRllKK2xaMGVp?=
 =?utf-8?B?NkNuc1QwZWxJTUVLeCtLUjErSGdrVklVelFubkM4WUVKcklFb2xINUs1bFBt?=
 =?utf-8?B?WjYwS3k3RDhaeldZcTZwUGV3dkhua1daamt0SGw5a0ZNTUwySGpudDhrL2Rw?=
 =?utf-8?B?NW56c3dDSkZHendaNnkzZWN2OEh4UEt3SnJNS2dGMVRnNG1oZzFWbkRnRSs0?=
 =?utf-8?B?RE9ZcmFaV0RyZXhOVWgvOE5JRmwvZlVNUGU5bVh3VXNQdWQyTzdaUnV1dCtr?=
 =?utf-8?B?aDNOUHlqUXlrV3lQdlZyeHB3M3g5eC9xeHFObExJa1hBSzJOWVNUSWlDWW1J?=
 =?utf-8?B?KzNVK3ZDMTl3ZHJkcHFsdnNxRm1vUXZxbkRrWnBYNmZ2THVXUkxzUUtWQXM0?=
 =?utf-8?B?NDB6a3dWNEJqdWU3RDNGMGs3cll0TjFONERUa094MTNMUEhralJ0RjQrZU1X?=
 =?utf-8?B?OEE0NFdQRVBNdGUrUVVJcjAxSnF5Vk13ZFREMTdzK2dOL2JGVFU1WFQxZFhm?=
 =?utf-8?B?ZFhXaG9XMlc1VUg2Y3czVkVLMWFEY2FjU3VBcDhtaklQVHNoTlpuU1lYZ21v?=
 =?utf-8?B?OUFRUlpLNWFQbXBqTTM1MXEzVmFPcjAyUUs3U2crRVRZYVdBRHNpeks1RDNV?=
 =?utf-8?B?dHB4RkRPSGdRYTA1RHFQdjlUYVJWclE1MUN4aUpiaWdaOVY2RG0zMUpOdG1p?=
 =?utf-8?B?TngyN1Z2SE13VlNueUdZR3hXQzhwNDRUa01OS2JUdlNQTnVyZkhRSlNhZzNl?=
 =?utf-8?B?OVRkR2FEWDhZNVI3ellDYlpqc1g3TWQ5SkxqVUlSaXZWNDVQSVNSOU01VHl3?=
 =?utf-8?B?WFI5c1hxZWhtK25WcU9yT3YwcGJNclgvWHFEbGpmb2tlb0tSc0ZDS3d6d1ls?=
 =?utf-8?B?eHFDcW9WS2s3T2llWmRHNytSZ2kvNUVDYk81a1lnWGZMaFRIMmZnY3o5S2VY?=
 =?utf-8?B?WDJON2dwVm82cTg0Q2U0bEVhTGhRcEJ3QjlkQ0U5ZE15akwwdm96QlFGeTdu?=
 =?utf-8?B?MDRpMFBGekQ1cnF1dUFvTTFrR0NoZGxBV1E4bUdsZ2pCLzh3OU9sV2Q1cnVk?=
 =?utf-8?B?d0hqK2MvM01US3VXSXZOMjJkRi9mTkp1Y0h0a1orZW1lY041eUxJMkg3MzB5?=
 =?utf-8?B?N0R4aDVncHNrNnQ5MEpGODZMc0lNOUkyTVFaZ3VBaDBVTUVIU2VxWUM0VHZn?=
 =?utf-8?B?elNHQnFtTElZWG9DSFZyZlVEcVQxc1RRamoyZWo5ZWpzbll3REM4YzZFRDJv?=
 =?utf-8?B?dFdaMitUaGFJSnRYTS9aRDdDcWk1WkRhaG01MTFaT0lDRWkzclYzSE4ydlFD?=
 =?utf-8?B?cHVuMUR5SURZWG5aemt3cm5FdzJvZmljc25DWlRieVUzdDR1dmY2N0lUZzhY?=
 =?utf-8?B?a1paSGFRTlBqb2NRWUFZaFFmUDlISE9SSDJPUmpYZHQyZHk4N04yVUZhYkhS?=
 =?utf-8?B?ZmlTbEdxQnIrU0hsdUZqUzJUZWV1NS9KU2M0N3J5cXJUVFZ4alB4VzNKWDhF?=
 =?utf-8?B?ZnRLaEVmV0JRZ1oxcmt6eXBWTFFoTGJoYlgrZE9hd1RRT0ppZmw5cEdRMmti?=
 =?utf-8?Q?m6Q6neJBgsKVosRHu+?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ebd4dc6-cf59-4008-5780-08de6aa273b1
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 01:51:49.3434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Plh41LcrS5IsiLc2+VR1QHy/kFS9SHVKbnby77ojaesmTmcOY0iaj5ibAP4d47T2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8856
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-71034-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: DAF76132526
X-Rspamd-Action: no action

Hi Reinette,


On 2/12/2026 6:05 PM, Reinette Chatre wrote:
> Hi Babu,
> 
> On 2/12/26 11:09 AM, Babu Moger wrote:
>> Hi Reinette,
>>
>> On 2/11/26 21:51, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 2/11/26 1:18 PM, Babu Moger wrote:
>>>> On 2/11/26 10:54, Reinette Chatre wrote:
>>>>> On 2/10/26 5:07 PM, Moger, Babu wrote:
>>>>>> On 2/9/2026 12:44 PM, Reinette Chatre wrote:
>>>>>>> On 1/21/26 1:12 PM, Babu Moger wrote:
> 
> ...
> 
>>>>> Another question, when setting aside possible differences between MB and GMB.
>>>>>
>>>>> I am trying to understand how user may expect to interact with these interfaces ...
>>>>>
>>>>> Consider the starting state example as below where the MB and GMB ceilings are the
>>>>> same:
>>>>>
>>>>>      # cat schemata
>>>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>>>      MB:0=2048;1=2048;2=2048;3=2048
>>>>>
>>>>> Would something like below be accurate? Specifically, showing how the GMB limit impacts the
>>>>> MB limit:
>>>>>         # echo"GMB:0=8;2=8" > schemata
>>>>>      # cat schemata
>>>>>      GMB:0=8;1=2048;2=8;3=2048
>>>>>      MB:0=8;1=2048;2=8;3=2048
>>>> Yes. That is correct.  It will cap the MB setting to  8.   Note that we are talking about unit differences to make it simple.
>>> Thank you for confirming.
>>>
>>>>> ... and then when user space resets GMB the MB can reset like ...
>>>>>
>>>>>      # echo"GMB:0=2048;2=2048" > schemata
>>>>>      # cat schemata
>>>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>>>      MB:0=2048;1=2048;2=2048;3=2048
>>>>>
>>>>> if I understand correctly this will only apply if the MB limit was never set so
>>>>> another scenario may be to keep a previous MB setting after a GMB change:
>>>>>
>>>>>      # cat schemata
>>>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>>>      MB:0=8;1=2048;2=8;3=2048
>>>>>
>>>>>      # echo"GMB:0=8;2=8" > schemata
>>>>>      # cat schemata
>>>>>      GMB:0=8;1=2048;2=8;3=2048
>>>>>      MB:0=8;1=2048;2=8;3=2048
>>>>>
>>>>>      # echo"GMB:0=2048;2=2048" > schemata
>>>>>      # cat schemata
>>>>>      GMB:0=2048;1=2048;2=2048;3=2048
>>>>>      MB:0=8;1=2048;2=8;3=2048
>>>>>
>>>>> What would be most intuitive way for user to interact with the interfaces?
>>>> I see that you are trying to display the effective behaviors above.
>>> Indeed. My goal is to get an idea how user space may interact with the new interfaces and
>>> what would be a reasonable expectation from resctrl be during these interactions.
>>>
>>>> Please keep in mind that MB and GMB units differ. I recommend showing only the values the user has explicitly configured, rather than the effective settings, as displaying both may cause confusion.
>>> hmmm ... this may be subjective. Could you please elaborate how presenting the effective
>>> settings may cause confusion?
>>
>> I mean in many cases, we cannot determine the effective settings correctly. It depends on benchmarks or applications running on the system.
>>
>> Even with MB (without GMB support), even though we set the limit to 10GB, it may not use the whole 10GB.  Memory is shared resource. So, the effective bandwidth usage depends on other applications running on the system.
> 
> Sounds like we interpret "effective limits" differently. To me the limits(*) are deterministic.
> If I understand correctly, if the GMB limit for domains A and B is set to x GB then that places
> an x GB limit on MB for domains A and B also. Displaying any MB limit in the schemata that is
> larger than x GB for domain A or domain B would be inaccurate, no?

Yea. But, I was thinking not to mess with values written at registers.

> 
> When considering your example where the MB limit is 10GB.
> 
> Consider an example where there are two domains in this example with a configuration like below.
> (I am using a different syntax from schemata file that will hopefully make it easier to exchange
> ideas when not having to interpret the different GMB and MB units):
> 
> 	MB:0=10GB;1=10GB
> 
> If user space can create a GMB domain that limits shared bandwidth to 10GB that can be displayed
> as below and will be accurate:
> 
> 	MB:0=10GB;1=10GB
> 	GMB:0=10GB;1=10GB
> 
> If user space then reduces the combined bandwidth to 2GB then the MB limit is wrong since it
> is actually capped by the GMB limit:
> 
> 	MB:0=10GB;1=10GB <==== Does reflect possible per-domain memory bandwidth which is now capped by GMB
> 	GMB:0=2GB;1=2GB
> 
> Would something like below not be more accurate that reflects that the maximum average bandwidth
> each domain could achieve is 2GB?
> 
> 	MB:0=2GB;1=2GB <==== Reflects accurate possible per-domain memory bandwidth
> 	GMB:0=2GB;1=2GB

That is reasonable. Will check how we can accommodate that.

> 
> (*) As a side-note we may have to start being careful with how we use "limits" because of the planned
> introduction of a "MAX" as a bandwidth control that is an actual limit as opposed to the
> current control that is approximate.
>   
>>>> We also need to track the previous settings so we can revert to the earlier value when needed. The best approach is to document this behavior clearly.
>>> Yes, this will require resctrl to maintain more state.
>>>
>>> Documenting behavior is an option but I think we should first consider if there are things
>>> resctrl can do to make the interface intuitive to use.
>>>
>>>>>>>>    From the description it sounds as though there is a new "memory bandwidth
>>>>>>> ceiling/limit" that seems to imply that MBA allocations are limited by
>>>>>>> GMBA allocations while the proposed user interface present them as independent.
>>>>>>>
>>>>>>> If there is indeed some dependency here ... while MBA and GMBA CLOSID are
>>>>>>> enumerated separately, under which scenario will GMBA and MBA support different
>>>>>>> CLOSID? As I mentioned in [1] from user space perspective "memory bandwidth"
>>>>>> I can see the following scenarios where MBA and GMBA can operate independently:
>>>>>> 1. If the GMBA limit is set to ‘unlimited’, then MBA functions as an independent CLOS.
>>>>>> 2. If the MBA limit is set to ‘unlimited’, then GMBA functions as an independent CLOS.
>>>>>> I hope this clarifies your question.
>>>>> No. When enumerating the features the number of CLOSID supported by each is
>>>>> enumerated separately. That means GMBA and MBA may support different number of CLOSID.
>>>>> My question is: "under which scenario will GMBA and MBA support different CLOSID?"
>>>> No. There is not such scenario.
>>>>> Because of a possible difference in number of CLOSIDs it seems the feature supports possible
>>>>> scenarios where some resource groups can support global AND per-domain limits while other
>>>>> resource groups can just support global or just support per-domain limits. Is this correct?
>>>> System can support up to 16 CLOSIDs. All of them support all the features LLC, MB, GMB, SMBA.   Yes. We have separate enumeration for  each feature.  Are you suggesting to change it ?
>>> It is not a concern to have different CLOSIDs between resources that are actually different,
>>> for example, having LLC or MB support different number of CLOSIDs. Having the possibility to
>>> allocate the *same* resource (memory bandwidth) with varying number of CLOSIDs does present a
>>> challenge though. Would it be possible to have a snippet in the spec that explicitly states
>>> that MB and GMB will always enumerate with the same number of CLOSIDs?
>>
>> I have confirmed that is the case always.  All current and planned implementations, MB and GMB will have the same number of CLOSIDs.
> 
> Thank you very much for confirming. Is this something the architects would be willing to
> commit to with a snippet in the PQoS spec?

I checked on that. Here is the response.

"I do not plan to add a statement like that to the spec.  The CPUID 
enumeration allows for them to have different number of CLOS's supported 
for each.  However, it is true that for all current and planned 
implementations, MB and GMB will have the same number of CLOS."


> 
>>> Please see below where I will try to support this request more clearly and you can decide if
>>> it is reasonable.
>>>    
>>>>>>> can be seen as a single "resource" that can be allocated differently based on
>>>>>>> the various schemata associated with that resource. This currently has a
>>>>>>> dependency on the various schemata supporting the same number of CLOSID which
>>>>>>> may be something that we can reconsider?
>>>>>> After reviewing the new proposal again, I’m still unsure how all the pieces will fit together. MBA and GMBA share the same scope and have inter-dependencies. Without the full implementation details, it’s difficult for me to provide meaningful feedback on new approach.
>>>>> The new approach is not final so please provide feedback to help improve it so
>>>>> that the features you are enabling can be supported well.
>>>> Yes, I am trying. I noticed that the proposal appears to affect how the schemata information is displayed(in info directory). It seems to introduce additional resource information. I don't see any harm in displaying it if it benefits certain architecture.
>>> It benefits all architectures.
>>>
>>> There are two parts to the current proposals.
>>>
>>> Part 1: Generic schema description
>>> I believe there is consensus on this approach. This is actually something that is long
>>> overdue and something like this would have been a great to have with the initial AMD
>>> enabling. With the generic schema description forming part of resctrl the user can learn
>>> from resctrl how to interact with the schemata file instead of relying on external information
>>> and documentation.
>>
>> ok.
>>
>>> For example, on an Intel system that uses percentage based proportional allocation for memory
>>> bandwidth the new resctrl files will display:
>>> info/MB/resource_schemata/MB/type:scalar linear
>>> info/MB/resource_schemata/MB/unit:all
>>> info/MB/resource_schemata/MB/scale:1
>>> info/MB/resource_schemata/MB/resolution:100
>>> info/MB/resource_schemata/MB/tolerance:0
>>> info/MB/resource_schemata/MB/max:100
>>> info/MB/resource_schemata/MB/min:10
>>>
>>>
>>> On an AMD system that uses absolute allocation with 1/8 GBps steps the files will display:
>>> info/MB/resource_schemata/MB/type:scalar linear
>>> info/MB/resource_schemata/MB/unit:GBps
>>> info/MB/resource_schemata/MB/scale:1
>>> info/MB/resource_schemata/MB/resolution:8
>>> info/MB/resource_schemata/MB/tolerance:0
>>> info/MB/resource_schemata/MB/max:2048
>>> info/MB/resource_schemata/MB/min:1
>>>
>>> Having such interface will be helpful today. Users do not need to first figure out
>>> whether they are on an AMD or Intel system, and then read the docs to learn the AMD units,
>>> before interacting with resctrl. resctrl will be the generic interface it intends to be.
>>
>> Yes. That is a good point.
>>
>>> Part 2: Supporting multiple controls for a single resource
>>> This is a new feature on which there also appears to be consensus that is needed by MPAM and
>>> Intel RDT where it is possible to use different controls for the same resource. For example,
>>> there can be a minimum and maximum control associated with the memory bandwidth resource.
>>>
>>> For example,
>>> info/
>>>    └─ MB/
>>>        └─ resource_schemata/
>>>            ├─ MB/
>>>            ├─ MB_MIN/
>>>            ├─ MB_MAX/
>>>            ┆
>>>
>>>
>>> Here is where the big question comes in for GLBE - is this actually a new resource
>>> for which resctrl needs to add interfaces to manage its allocation, or is it instead
>>> an additional control associated with the existing memory bandwith resource?
>>
>> It is not a new resource. It is new control mechanism to address limitation with memory bandwidth resource.
>>
>> So, it is a new control for the existing memory bandwidth resource.
> 
> Thank you for confirming.
> 
>>
>>> For me things are actually pointing to GLBE not being a new resource but instead being
>>> a new control for the existing memory bandwidth resource.
>>>
>>> I understand that for a PoC it is simplest to add support for GLBE as a new resource as is
>>> done in this series but when considering it as an actual unique resource does not seem
>>> appropriate since resctrl already has a "memory bandwidth" resource. User space expects
>>> to find all the resources that it can allocate in info/ - I do not think it is correct
>>> to have two separate directories/resources for memory bandwidth here.
>>>
>>> What if, instead, it looks something like:
>>>
>>> info/
>>> └── MB/
>>>       └── resource_schemata/
>>>           ├── GMB/
>>>           │   ├──max:4096
>>>           │   ├──min:1
>>>           │   ├──resolution:1
>>>           │   ├──scale:1
>>>           │   ├──tolerance:0
>>>           │   ├──type:scalar linear
>>>           │   └──unit:GBps
>>>           └── MB/
>>>               ├──max:8192
>>>               ├──min:1
>>>               ├──resolution:8
>>>               ├──scale:1
>>>               ├──tolerance:0
>>>               ├──type:scalar linear
>>>               └──unit:GBps
>>
>> Yes. It definitely looks very clean.
>>
>>> With an interface like above GMB is just another control/schema used to allocate the
>>> existing memory bandwidth resource. With the planned files it is possible to express the
>>> different maximums and units used by the MB and GMB schema. Users no longer need to
>>> dig for the unit information in the docs, it is available in the interface.
>>
>>
>> Yes. That is reasonable.
>>
>> Is the plan to just update the resource information in /sys/fs/resctrl/info/<resource_name>  ?
> 
> I do not see any resource information that needs to change. As you confirmed,
> MB and GMB have the same number of CLOSIDs and looking at the rest of the
> enumeration done in patch #2 all other properties exposed in top level of
> /sys/fs/resctrl/info/MB is the same for MB and GMB. Specifically,
> thread_throttle_mode, delay_linear, min_bandwidth, and bandwidth_gran have
> the same values for MB and GMB. All other content in
> /sys/fs/resctrl/info/MB would be new as part of the new "resource_schemata"
> sub-directory.
> 
> Even so, I believe we could expect that a user using any new schemata file entry
> introduced after the "resource_schemata" directory is introduced is aware of how
> the properties are exposed and will not use the top level files in /sys/fs/resctrl/info/MB
> (for example min_bandwidth and bandwidth_gran) to understand how to interact with
> the new schema.
> 
> 
>>
>> Also, will the display of /sys/fs/resctrl/schemata change ?
> 
> There are no plans to change any of the existing schemata file entries.
> 
>>
>> Current display:
> 
> When viewing "current" as what this series does in schemata file ...
> 
>>
>>   GMB:0=4096;1=4096;2=4096;3=4096
>>    MB:0=8192;1=8192;2=8192;3=8192
> 
> yes, the schemata file should look like this on boot when all is done. All other
> user facing changes are to the info/ directory where user space learns about
> the new control for the resource and how to interact with the control.
> 
>>> Doing something like this does depend on GLBE supporting the same number of CLOSIDs
>>> as MB, which seems to be how this will be implemented. If there is indeed a confirmation
>>> of this from AMD architecture then we can do something like this in resctrl.
>>
>> I don't see this being an issue. I will get consensus on it.
>>
>> I am wondering about the time frame and who is leading this change. Not sure if that is been discussed already.
>> I can definitely help.
> 
> A couple of features depend on the new schema descriptions as well as support for multiple
> controls: min/max bandwidth controls on the MPAM side, region aware MBA and MBM on the Intel
> side, and GLBE on the AMD side. I am hoping that the folks working on these features can
> collaborate on the needed foundation. Since there are no patches for this yet I cannot say
> if there is a leader for this work yet, at this time this role appears to be available if you
> would like to see this moving forward in order to meet your goals.


I joined this feature effort a bit later, so I may not yet have full 
context on the MPAM and region‑aware requirements. I’m happy to provide 
all the necessary information for GMB and MB from the AMD side, and I’m 
also available to help with reviews and testing.

Thanks
Babu


