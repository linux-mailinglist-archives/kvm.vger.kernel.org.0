Return-Path: <kvm+bounces-70585-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WJlKBfeQiWlz+wQAu9opvQ
	(envelope-from <kvm+bounces-70585-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 08:47:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B38B10C95C
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 08:47:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 439D7300D97E
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 07:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40652338925;
	Mon,  9 Feb 2026 07:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Y58rdtil"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010068.outbound.protection.outlook.com [52.101.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF941C2AA;
	Mon,  9 Feb 2026 07:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770623188; cv=fail; b=LQOYIKGGtM5eRM2roGBQnAqMwaCWJjCif8fH9ASNyOYZNuORIxhTnG7PdJlqIGykcorNGticOyRn8S7ewB4aOSI/fdpV4bMS/VUMDEYA/hrjSR7RmG4K/JzFIcjUjZJc+AXkOP6zIO6ytvLqNf6dB7cFDkGoR4Pw7f5GZGBFdEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770623188; c=relaxed/simple;
	bh=nFGAkImCNRrH0drvMr9Yli4GdXl6k7UyUoqPfxcTg/M=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c/UG9epYgOwqGhf6r/7DtQbSp4S228pWV5ewoYv175+vUD8AGJ7SBqaRGV65H/9fCk6RvfPEMmhKzsh5zCKBCgRf36jdY55OEMXfDUFhSrj+nhtKN+djMmYR4FFaGjmC7kOganI3QT/m5dIBhDGiiFNvpASeN4mcTW+0XOjWwuc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Y58rdtil; arc=fail smtp.client-ip=52.101.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLE0y4kFB/uZPaFMoVdIVqHWi/mQKevEoRPqVDAtDN/oqy0+Vbwwf/qpSo7281ijs7HRMJPUXiEENPjIRWF5EFboWMq0z1/+0QZ92wPPVies/p0JbNdFwX9LWyKBskLaxXdswXoaaENQS++9mT58Rcn9aDnEYi+gSggTFqQkjlDjbGNb8MtRgfsAVzzpcbnM9bjfoKlR21gfG1l7BD1VOLOGP1c9eXnjFejW9EJ7yCLIR5s0hXVasw8wQV8+mQTAU84O0N0qj/tX8pCFdtT7Y0jEjHCvkEzfMTHGA9ZcJcg0ybuyRwjz0zjS+mlXV0qeJ1KH0a7oyn7Kf+3ndtmdBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7jiR3FyHLPFVOO6so5e4GqpBbe3aiyMi3tfhcR3XgM=;
 b=tr0SpIcxHt5cJC5Nz5LD6V5k/SaVeVGLLeEVqxcn+WzYJsZY7jw3tnVm5weDgI56hEdKW1QsuvcmgW8aMr3Ry04NgJS2fw9D5FGzyJ6HmYg+PyJWYXOVkUWKqxEJ5eEZ5EV2cYx0SRVOrN8vhCI3/sWmy3aQA6yrsaBmXNoEv4E4CTiUaXvo9JUHklnfAuVdu1LW+aTjavIO988C7Ao0OUDGTuPhgZiLbzg67pyELIijfVqkPEOKDeXZeLfiV4lDagM5MMM6a0cKV8Xm4hgnAGKyLiP9VMNuFllEC3JS+u2s7ibHOG3m5sF0TxUeWbOWyNeaqReAHMLKqTFC6cJ1LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7jiR3FyHLPFVOO6so5e4GqpBbe3aiyMi3tfhcR3XgM=;
 b=Y58rdtil/6eEYFVojcgxX97zujEQIQ6EZn6Ic433d/hYZOjQkij7y92ijSZj6WzjtoX3tPzFGNMDXDeG0IwFLXd1Xr1ZmOIOP3/jWud3whRwrAIEP4KRysc34lev2CUxRNRrwkY2gb8EFOchneaw205arXoMpvRXkHdoiFpkcl8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5712.namprd12.prod.outlook.com (2603:10b6:510:1e3::13)
 by BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 07:46:25 +0000
Received: from PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::afe1:7dd0:ea71:b7e7]) by PH7PR12MB5712.namprd12.prod.outlook.com
 ([fe80::afe1:7dd0:ea71:b7e7%4]) with mapi id 15.20.9587.013; Mon, 9 Feb 2026
 07:46:25 +0000
Message-ID: <8e032a54-1444-46ce-8ddf-371ca74debc9@amd.com>
Date: Mon, 9 Feb 2026 13:16:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] KVM: x86/pmu: Disable Host-Only/Guest-Only events
 as appropriate for vCPU state
To: Jim Mattson <jmattson@google.com>, Sean Christopherson
 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Yosry Ahmed <yosry.ahmed@linux.dev>, Mingwei Zhang <mizhang@google.com>
References: <20260207012339.2646196-1-jmattson@google.com>
 <20260207012339.2646196-3-jmattson@google.com>
Content-Language: en-US
From: Sandipan Das <sandipan.das@amd.com>
In-Reply-To: <20260207012339.2646196-3-jmattson@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0144.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d7::16) To PH7PR12MB5712.namprd12.prod.outlook.com
 (2603:10b6:510:1e3::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5712:EE_|BL4PR12MB9723:EE_
X-MS-Office365-Filtering-Correlation-Id: 91348ab8-b0b4-4107-308e-08de67af5362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWZPdXRDUWdUUkJIRC9zeFdHeHB6NzRRTGN5bTVDU2o4U2s4Yy9RTmY5c3Nl?=
 =?utf-8?B?b2tVRDBaejVkeEU4NVg2dWlVY0p4dHhVQ0xDemYzK0FjTkxXWSt6aVZSMHNq?=
 =?utf-8?B?c2IwR3grQm9PRWw1RkV2OFVXQ0piTFRXQW5QcUZybDE0MnJIb05VRHJSUThw?=
 =?utf-8?B?M1o0a25SOHVSa3FhNmNuY2g4WldMM0ZsaDZ4b3ZjcVBhbDNja0J3eWhPK3pR?=
 =?utf-8?B?WFljc2ttMDh6Tkp2WmdFUEUvaWZrNzhGZnpYNGxWV3hRSTJONlVNTU40dkhV?=
 =?utf-8?B?MHdrN3RtZDRPMlZsRmVTNnNOdGlucDdVZEJQL2RZN1lGdHo2eTJrTVZQN1VG?=
 =?utf-8?B?dVpYWURDZlFmMlVuSWwrcnMrU2tSNytwamZQRG9CeU5pNnlzc2hOTjBDclMv?=
 =?utf-8?B?WFdsN0lYOFlONUZRbnpIcUdoSHVqNXE4TXBrblExRUI0bUxDS2lzWFgvdnNp?=
 =?utf-8?B?RHNyL0I3V2U0emhJSjFYSitNckU0Z2tqL2Fhakl3Rm53WUMvMWc0eU04enBl?=
 =?utf-8?B?T0ozQ1R2VENSNnVZMGxTc1BGSDVmWXcraExOTFArZmR0K0g0YnViUnhlVGx5?=
 =?utf-8?B?TG1HTVVXOTlFQm10RWVKeDQremI2eWR4SEdBRGtpWFcwN012a3l6N1EwWnp1?=
 =?utf-8?B?WklOT1N6TFVHMDdIZjlXWDUweXpNZHZrS0FiczE0S0NxbU5STHplS2MrT0Zl?=
 =?utf-8?B?NjBWdlV0aWVrcjAvNWdjSVlhY1lBVEhGZGh5c2lkbWd0TG1vRFlOcGJ3SnJG?=
 =?utf-8?B?Ty9mdTVnSUJZdHN6cjgxbi8vNXRhL2xnVXhkSVJXTUhxeFFzRzJUNHRmbUNj?=
 =?utf-8?B?YmRodGpVdVNqTVNnbFJEUDdXLzFNNCs0NTBCeUt6R0VwSCs4SFZ2SFdUK1VG?=
 =?utf-8?B?TzRtODZZTDdYRnlCWW5OV0xXQTlHSnQ1SlVHbDBsZEIwLzNOUDhMK3U4MENq?=
 =?utf-8?B?WEFibHJyUDdUclQ3eUxCMzNyMlBVZWV3aU4ySHFkQjRpQXI5WGlyRkcwZGlC?=
 =?utf-8?B?V2ttMGEybGJ4UWlPQzZUWHI3WUVvWHFsT3ZoUWg2OTlsZ0ZoUzB1YXY3TVhy?=
 =?utf-8?B?N1VzbEcybnFpbC9oZzAvSXFxU1dJUU4zbmRPSTV4am1MRU11cE00WTBsQTRv?=
 =?utf-8?B?VjlEbW0rbStZdC9SeER1bjFqOVpTRFZVZWI5bVU2SitYM2pTM0ZhUFlsZW8z?=
 =?utf-8?B?MlRSL2pCaFBUVGRLRDVUSzZyVFlYUHNHeEEwUFNkaWw3L0RlTGM0S2Q1aDdU?=
 =?utf-8?B?UUJ0cElsMWh4R1ZuS2IrTkp4TXN2Ynh0aW84amxWcDRzLzEvK0JRS3VQelV0?=
 =?utf-8?B?ejl2b2ZKK2VCbDdNanhWTStZY0NHS0VNQnhqM2U1WjRLR3RaZzZXTXB5anpt?=
 =?utf-8?B?OUdmcXk0WlZrYkpUNUtTVFlOdUVBK1JYZVZ3cjkwZER4MDhDaDFJTkowbWE4?=
 =?utf-8?B?TTV3V2JBcXEvRjBGTG1EN3FOZDR5S2YrVHB3UGcwTXdGRDQ5ZDZUdWpxNmd1?=
 =?utf-8?B?SFllL1BsNmcxVTFvYjZyWTNHMm9kd3NtaVE5Tk5KYWRGM3NPMno3SEFjUW9Y?=
 =?utf-8?B?dDBhQmZ6MlV6RnI0bFNOZEFFMTlndjB2Sm1XMEtzd1ZBckk2eWc1cFRweWlu?=
 =?utf-8?B?dGR4b1o3M2hkS3FjaGpiSlpDeG5OS2ZyK3BDazNJcFgxNUl0Q0VNRGMwRWtn?=
 =?utf-8?B?OC92aFJBTHlXSzl0eGlzZDlqcU1IRFd0dkpzT29DTnBXQ1Q1LytoSHM4VlZS?=
 =?utf-8?B?eHNOM2xTaXI0S3JCc3BXcnBFMVlFb0tTSXZWMkJrUkExcFMvMEtqa3hiZDBo?=
 =?utf-8?B?NFNHZ3J6T2xKRlRwMldhZi9EeHR5Z2xDZVRYeDJIb1NBbFpJVmo1UkwrNTdl?=
 =?utf-8?B?UTVmZkhQbUxvWFFpQ0NBWStCY0RCVEJDcm1qUExWMGJqNUVFVkkwZWhmZmFq?=
 =?utf-8?B?bURKU3hMVVYzd3JrWjRwOFhlMjQxYkNYY3BIcHNBK094MTZKRXMzYlNnVkE3?=
 =?utf-8?B?Q0xTS3c4a0ZtbTVJTDFXaUMvOUxuVCtjMlhqc3JzS0cwenRKWWlGdFdYSDhN?=
 =?utf-8?B?MU5Id2EyUUtUZmZ0cU80RXFydnpYRTZCZ3o3ZzFYczFmbWlMNFRSTzhTRFdl?=
 =?utf-8?B?YTZwMFRHMjhqaEhGSlBHLzdDWVFQSG1mRGZEVGF0cVVmTi90TGp0RG9uZURJ?=
 =?utf-8?B?bFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5712.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V0E0N2FVMnkyWkdtWENzb0FGQjZ6RXJXNTZsTXVMVTd6d3Zzenk5dnlQT2RN?=
 =?utf-8?B?K2NCRXFuNUFaWUwvby9Na2c0QUp2cDVqU0EwMU1GMzFUdHFoQ2ZzRjUxR24y?=
 =?utf-8?B?c3JZWURVLzd0N21qZVErYjllODZLMnMxYTdlMzBjU1dqd1ZVUEdPZStLZTVU?=
 =?utf-8?B?N1FETzFRdEVZT3B6QUdKdXJKM3F6c3I2dG4rVm4rMDYyNG94RllKMlBDWDk0?=
 =?utf-8?B?YkFZeFRDMnZzb1FmUHo2UHcxMzVFZlQrY3J6MjcwNkVyc2FwWEJ3R3N5dkt6?=
 =?utf-8?B?aXUyNHJtU0JnV3dORlJERWVlMzZYM1p0UFp4US8ySzM5VnI0dW1LQlkwa1Ji?=
 =?utf-8?B?MmlzbXhEYks3eFRiQ0hYL3NVVkZQam1hZEFCK3JjWlZ6Y3dhQlZndmhEWFVC?=
 =?utf-8?B?alM1QWZaOGExQTdGRDZpcm1MM2p3dk5zREpNYk1zL3ZrSStPcnc3bXZDYUlx?=
 =?utf-8?B?TzV0MW9kZ21BMGVRTFN6dDJMcWVTSEdOQUNWMXVGYWJ1ZGcxeHU4RjBnbDRj?=
 =?utf-8?B?RzV2VldaSWFpOTNpdFlnSmRVMC90RWdFL2tkLzFveFpGWmllMEJtRUVhOVZk?=
 =?utf-8?B?Y0l5azZhU1BEVWxhZzBWclVMVFZsY21rZ1IwcXhXQWxXOHN3dVRvdEdMa2xP?=
 =?utf-8?B?UnVZbDNVSTEzZzVZRExNU0ErVk8yOGRNYmRPU0Jwd2Y5UGdManFYNHVYNGh5?=
 =?utf-8?B?M1hvOUluMEZvQ1U3TkZPdjFVN09wOWMzY0RXdWcvWmVvSU0zY1RDQVlqVmJn?=
 =?utf-8?B?SEJjWWFzQzNjR1JxVkphQVhrS2dHaTFOK043MEpWTk4wTTNOcE9XVWVWZVBt?=
 =?utf-8?B?QTYrMGpUVGxESm94b3hjWEF5TVV0WVlFcCtYTmtub1o0VExISi93UDBwWm54?=
 =?utf-8?B?N2w1bXRZN3dNZStFb0Rzc0dqUjlKcGI3ZFlJRTZOTkZXV2k3WGtrV3FsZVRz?=
 =?utf-8?B?MnFERGFBTHZVOURQU3RaV09mNFdvMmFCMHp5aCtCbTlKMjg2WFpmb1hrcE5M?=
 =?utf-8?B?bFhKajVycEhXTXNtL0krZmNwU0tsSXJNU1Q3ZzB6SVJPbmhCUUJWTHFuZnBD?=
 =?utf-8?B?RE9uYlpsSTA3RXlHMXd4NEEyUkkxUGNKSElyY293YThHRmZBZHRBWS9oYUJJ?=
 =?utf-8?B?ZnU5TE9jcWpkRGNzZ1kvZ0dKNlp3cUhYeDhaRHBsbkVTR045STI4NnM3NlJO?=
 =?utf-8?B?dlJXRHlwM3lLRm9FZUVEdnkyL1Y1WnFvZHAzeXJsRzgwQmM0SVpCZnRjY0Y4?=
 =?utf-8?B?RUFuQ2lmZG45NXZLdkM4WUVmc05VZHFPRHNNZFpRdGZzeDYreXJlSWpQOUhN?=
 =?utf-8?B?N3IvZ08xNGlBZzFIZ2NvV0NmSzF2RHRwZEFnZFlLc3l3V3BJSTNhQThtcUtt?=
 =?utf-8?B?TnRxcUUwUVRJT090dWtaalZjMHNDQ29aenlqSU84dHd3L0VnWEJZL0tTRUF4?=
 =?utf-8?B?TzlNUENWdUxkN3FvYmtFWmJTZlJPS3lkaG1RYzRrYko0N3BoblFtYjQ3ZFBi?=
 =?utf-8?B?Mm1KSUZvaXZ0UlQ3YWxxOUdGOXUzays2QkM4U3hDaHc5d2l3Y0tkQ2tSQWsx?=
 =?utf-8?B?Vm9zWkJqc0J5V3ZkTlBCQWVQdlo0VUpUN0JTOUxXWDgweHpaVGZZQ3NxWkp0?=
 =?utf-8?B?K3FieU0xUVN5WE45WWVpeDEzWU1ZdnRpMUhXcUxPQjZkeGIxNkhtQWd1TDUv?=
 =?utf-8?B?aUwybWkyWkQ3U2ZxMnprWk5udlVRZHV1Qzhza2czb05nUWtUODhPUXFNTVN3?=
 =?utf-8?B?ZkpHeTlMaWQyMUlqeUNVZXpsWFpxRzA2WmRRYTYwczE0VVBBMlZUcEZKYkN5?=
 =?utf-8?B?TTF0a1E0eHUvZTRISlRxdGdVU2t0b1ViN2wrdE56WVBXS00vNGhCYzQyaUxM?=
 =?utf-8?B?bFhQOEVCYkJVVWRrbkRsckg2UVFtNTRWRVVnQUZsOXh5bW8rM3BabTFackRl?=
 =?utf-8?B?S2p5d0JVNFJ4Z0sya25sNmErSi85MWFYUURET20rVUxWOUhKMVA2aUw2Y3NH?=
 =?utf-8?B?NWk5dHY5blVMSnJueStFR3A3Q2JINnlTTG5BSnEvbE9YY2oxcUxReDFOSklS?=
 =?utf-8?B?QVAzZ2hnUENYbnZYNG9SbnpWU0JYZ0pHNEg5QTRSTmFGeXhoNEh5anVMdkJM?=
 =?utf-8?B?VUxzcjZZamhLY3lNRFBvbi9UbnEvS2pHd3JpU0JITWFvUG05amVmS3dScDJa?=
 =?utf-8?B?ZEZKcElTYXROREI1a1BHOGVQRGZXMnZxc0VCeXZBQ1pHSUllRkRmaWdCUEMy?=
 =?utf-8?B?aFNtQjA5eWlINjR3ZDBjR0hYcG9qUkFZSVFBWjl5ZWJoMFJJbUc0ekZQcmNR?=
 =?utf-8?B?aXJhREx3U2xYbThjdWxyTTJKYis4VUFMSHFFeXFVeWJJTXhkZ1MxUT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91348ab8-b0b4-4107-308e-08de67af5362
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5712.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 07:46:25.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0J91MMfId9DgfoouZo3L1hETaA4cVn0rxUfn2SqUCKal+0QGszrQsgmaXvi0EWvJcQ81VptA8+VN2d0jRHK/Ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9723
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70585-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sandipan.das@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 9B38B10C95C
X-Rspamd-Action: no action

On 2/7/2026 6:53 AM, Jim Mattson wrote:
> Update amd_pmu_set_eventsel_hw() to clear the event selector's hardware
> enable bit when the PMC should not count based on the guest's Host-Only and
> Guest-Only event selector bits and the current vCPU state.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/include/asm/perf_event.h |  2 ++
>  arch/x86/kvm/svm/pmu.c            | 18 ++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 0d9af4135e0a..4dfe12053c09 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -58,6 +58,8 @@
>  #define AMD64_EVENTSEL_INT_CORE_ENABLE			(1ULL << 36)
>  #define AMD64_EVENTSEL_GUESTONLY			(1ULL << 40)
>  #define AMD64_EVENTSEL_HOSTONLY				(1ULL << 41)
> +#define AMD64_EVENTSEL_HOST_GUEST_MASK			\
> +	(AMD64_EVENTSEL_HOSTONLY | AMD64_EVENTSEL_GUESTONLY)
>  
>  #define AMD64_EVENTSEL_INT_CORE_SEL_SHIFT		37
>  #define AMD64_EVENTSEL_INT_CORE_SEL_MASK		\
> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
> index d9ca633f9f49..8d451110a94d 100644
> --- a/arch/x86/kvm/svm/pmu.c
> +++ b/arch/x86/kvm/svm/pmu.c
> @@ -149,8 +149,26 @@ static int amd_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  
>  static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
>  {
> +	struct kvm_vcpu *vcpu = pmc->vcpu;
> +	u64 host_guest_bits;
> +
>  	pmc->eventsel_hw = (pmc->eventsel & ~AMD64_EVENTSEL_HOSTONLY) |
>  			   AMD64_EVENTSEL_GUESTONLY;
> +
> +	if (!(pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE))
> +		return;
> +
> +	if (!(vcpu->arch.efer & EFER_SVME))
> +		return;
> +
> +	host_guest_bits = pmc->eventsel & AMD64_EVENTSEL_HOST_GUEST_MASK;
> +	if (!host_guest_bits || host_guest_bits == AMD64_EVENTSEL_HOST_GUEST_MASK)
> +		return;
> +
> +	if (!!(host_guest_bits & AMD64_EVENTSEL_GUESTONLY) == is_guest_mode(vcpu))
> +		return;

This seems to disable the PMCs after exits from an L2 guest to the L0 hypervisor.
For such transitions, the corresponding L1 vCPU's PMC has GuestOnly set but
is_guest_mode() is false as this function is called at the very end of
leave_guest_mode() after vcpu->stat.guest_mode is set to 0.

Is this a correct interpretation of the condition above?

> +
> +	pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
>  }
>  
>  static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)


