Return-Path: <kvm+bounces-39686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B4E1A49516
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:33:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26EAA17256A
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 09:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBA782580CD;
	Fri, 28 Feb 2025 09:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Se5RWO3m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96708255E3C;
	Fri, 28 Feb 2025 09:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740735121; cv=fail; b=cOXbXQ0rXOOllndn8vLoA8HMcAUu1JHp3yuNlBw5DhLyMDuJMCNHCh9Zk/JRYqn6RGzCdN4+FZBxw8uPQwuco6gwrEU2r4D2fld63MByKNKzHI03CiS/o37+w8g+f5b9kodKXtFVxwX+Qlnqdw0l9GayRN34jb2shHBs6z0YzTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740735121; c=relaxed/simple;
	bh=vnTidWeawQUhv0PcSUUioS7AHKY78nH9thzr6K+/hko=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UqlVmnciEX+H3Ue5KwS7RqQsY7o5lKFzjFDbQ7RpE29KqE9msdtMx+zAx1yW2dEdhRYapEDMCpEuO+qUyF0in0F+rZm6Y/0+n5HhrRf5ZL6saUzcr/0W6isauk+NmBLYhKJBGMJy8V4gxk+tTxgs8i/tAfmX1XE2rmJ9sbbr0TQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Se5RWO3m; arc=fail smtp.client-ip=40.107.243.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vnsaQinTccfTme7MRW5MfuEEU5di9nK+aM8S9tY3FFotIq1q1PpjjNszawOGF02Rd3Jqg2HED6sovsHT66m/srCB4JkprQKsg7Na5wl3Qj59URf6IKr7YhFWIMeGAws3yeF7A2nuNhWDncr2o9JxYn+53cfNQcj+DI5tVan1IgcswgDf/bk5Qk7Dl65ot9hEqK0ecUYN2YU0LxEF3zgz6+BI9hax+P2NmUl6GR3B4HQ96FRxXg5jg6aWoOruDP2qHeerq7loM/LvlUg3crDPsm0P9U5Xf4B3WqVWdW/rjMaYl//W/8d9qzVqFvL3/1MbC/PtcL/UKI/0ai3KryQfqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oz/DOSdgZlz9uQKdDoIRGWFw0ffZ4QWlpTk7vY2Bffo=;
 b=Y6/Epi7C5V0C6sEX+yG8IBBH9oaNBwbvNrt6p9gr9DiiwrPvVPgUkhHnGWHN34aERK4qVoana86cT6FEDXDcVajQpUexnbZwBEzIYTVCt3/G2BBzijFpydh++9gbv9qv3Arh9wcSlV6NsyPbwML675WThH9t4nFG+YEHCoBhlmOTZtXTa8dLOSO50pdLTJmnMFHIWsSrZZys3KuqQiNtwUXSsVUHavZLjZynFlnk3qIzTSbag9cRNxehO/wk+L9QL9RPFOPW0d1feUL178z9VwfkwGuLTycYdy5LyOqBxixm37RRmA/O7a3EWGpS2P/c33H/Iuzu4ahs6win/UZr8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oz/DOSdgZlz9uQKdDoIRGWFw0ffZ4QWlpTk7vY2Bffo=;
 b=Se5RWO3muKGAn7js0EVorgc6RzI5xn77UqU8RvJZv8zUdnPmi7JWqpc2FQfweU+aKwF7UZG+zZHBv0+ENjj6pyh41EMWeUIV7euNAJr+dX479bqt6d3B9s4WhKjrZVW6PlbrbsgLp3q6D4eeSBkxkwtLaQKpAI7phCibST/99xw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Fri, 28 Feb
 2025 09:31:57 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.8489.018; Fri, 28 Feb 2025
 09:31:56 +0000
Message-ID: <653c3c6e-bdfc-4604-bda0-3b67970a0c62@amd.com>
Date: Fri, 28 Feb 2025 15:01:49 +0530
User-Agent: Mozilla Thunderbird
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH v3 0/6] KVM: SVM: Fix DEBUGCTL bugs
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Xiaoyao Li <xiaoyao.li@intel.com>, rangemachine@gmail.com,
 whanos@sergal.fun, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20250227222411.3490595-1-seanjc@google.com>
Content-Language: en-US
In-Reply-To: <20250227222411.3490595-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0172.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::27) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: 97eb4c66-38b4-40e9-f1d7-08dd57dabe3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QVNDTXZJMElzY2s1L0RjMzMyUmQrK3FIb0FpVzlBZkZpcWR4QTRHTUZ4M0ha?=
 =?utf-8?B?SldydkM1UEptQkIzOVErS0pFa1c2eGd4L0owODc3bmRxemw1empKNUYwRkZz?=
 =?utf-8?B?NlFYQmlCbzRKVFRpTmVLTzF2RFd0WGpLTU0zKzlvYmk4MjNYdnRiOGlvdHc0?=
 =?utf-8?B?RnN4b2FmNWlSS1FiNjUvenNDWVcyeUhhdER5V3RPT2k2Tlk1RFoxUi93SWVW?=
 =?utf-8?B?Tk9RRFlveFRZSVRwN0hTUWJlb2J4S25EWmlwUSt6clNWY3E1N04vcmVHbGg1?=
 =?utf-8?B?UHVBa2F2NE9XTmowWEV5VERKZGR0WHpiUXdhbDJTZ1NRUjdBbDZxQWxENnRj?=
 =?utf-8?B?dWptSm5POVJvYVZla0Jqa0RRdklyL0p5T1cvK1RxeGhrckRtbGcyWllhUVo1?=
 =?utf-8?B?VHpGYmluQk0vTFJLMHoxQWRSMFdsczYxQlVxSkM4SmUzZWNSeVNpeWk4RWM0?=
 =?utf-8?B?SlBwZC8reW52RzdYc1JaZEdPWTJqZmJMN2h2eFZkSkEwZkJaKzYvNHUzTWt3?=
 =?utf-8?B?Rm8zYVovZHBOSFpxSE9nZi9GakdvcTZ4VGpscys5aHVIUkl4bHhYTmlmQ2s1?=
 =?utf-8?B?dWRPOUl3U1RKVEM2WWpkMzRpMXZYbmdVbHJuazhUWGtJWkV0dmtmd21IT1dG?=
 =?utf-8?B?ZXkyeklnekpnUHhuV2NSVE1hakZQQ1d6UTdIQnBLVmFrVXg0NTM2U242bG02?=
 =?utf-8?B?dUQxVE0vS1ZDaXB2S3FIQWpNWjFhcDZsTEkwcjUvODZIYlZ3Q2ZrUVBEbEFu?=
 =?utf-8?B?YWgrYXJmbHN3V1VTRTZMdUZHYk5HbEVyZlFueVk4Rm1QNTFsdlI2aEpvVlA2?=
 =?utf-8?B?ZnVUc1hzZDdwcndGS1o0M3FoS1NBdHJWVU13OGdsNnB3eGl2LzcwRHMvaHU5?=
 =?utf-8?B?Q1E4bGdhUjZQYjd0US9odzBYL0p0N0JQSXNLK2EwZWdkSXZVbHZwWWlCZENK?=
 =?utf-8?B?YzQ5MUJuUkZSUFNJeDlSbGVDS1JVeXU4OHFyUUdSdXk4ZmZQcXBsVThNRDJM?=
 =?utf-8?B?anNtT0FKMEUycHBCU3k4T0ZLbFZ5UXNIbUs3MzFnWmFpYjE0TDBWeHV6R1FN?=
 =?utf-8?B?bFlaYmVQNk1WTXY1NytuRGp3Sk1EeWI3ZHE3THgvRlU1ZDdSd0pPWmM5b2hT?=
 =?utf-8?B?UjE2VTBFR2NGVEIzUmFvSmZQb3VhMXRxVVlwd0pkVWV3N3FoZXNiSHVkM0ZS?=
 =?utf-8?B?c2RneHJkOWVEMzhDWkMwcmQ2SStySk4wSVRxQmtTSy80ZkpRcENvSFZqN2pM?=
 =?utf-8?B?NFVGRnFUMnZ3SVErRWkvYXMvNXdyYXhvcDRxQkZPUitHVS91M053TFBINXhl?=
 =?utf-8?B?TWIzMW9ob2dZWG1WTzFrRUVMdVV5aHZwT1dvclB4K09id29mN0dpU3dPaGJ6?=
 =?utf-8?B?TWNlRlJhb3JwdTB0MXhWbCtvV1VIVi9meXVqT1NHKzhheXBQWFF6SVB4NGls?=
 =?utf-8?B?MG5DT0xxdlBoZURxM0VUMEZLQmNKTWdTcGZvUjZWbmhVY2hTSmJPVEtvTVZy?=
 =?utf-8?B?NnVzQWFiL2h0bjQ4aklhRzNvdEV1NFdQQjhJVThBSGg3Tk10ekROUTArdDNL?=
 =?utf-8?B?b0NZbnpHODMxWVpxdjczeHdWdU4rUEJiRnk1SUJ6RVM1V3czU0NXdUpiMHVM?=
 =?utf-8?B?MmhidmZneGUvQjZZNTRRaS9OTlJtRHFtZnhEWVdrS3hLZlJpVklZVXJMSHNE?=
 =?utf-8?B?QTkvaWRXVHV4UG9GQ1hVOGRSdWJVdFhNeXQ0THNjRm1oYk5wS0t0bVJXK1dR?=
 =?utf-8?B?NXd3dU5maVZWL2ZXeUlqd0lqQ1d6SHcwc0JyVWZ5b1ZBOXR6Smd5dmlyWUl2?=
 =?utf-8?B?bnRJUkZVYUtGSFY1ZDdPdWhTNjNldDVXSmVYWm1hbll2ZXNmZW9IYzVFbzFo?=
 =?utf-8?Q?KqW55wCGRz0yU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1h4TFkrWmZYS3hESTcvdkEwblJhdHdnMVZVeStjSTR6WHU2S2s5c2RqV1Mx?=
 =?utf-8?B?Wm9zU2s2L1FZVU5YRC80bVBxT3M0dkZLVTVKVlpzUkhySW1lUlVZUWtKc09j?=
 =?utf-8?B?Q1daYkExUGpYQjJ4OU1HNzAxT2RVeHRiQVg1ODhoU0NYVWo3Ym1YY1lxMXZk?=
 =?utf-8?B?ZkFzYllHMFRXWVdHNkMzcjRxM3JkUnFWL0lTVk5rcTJyOTFpbkxTckI2VDBa?=
 =?utf-8?B?RDlHZDVNdGs1Vm9zVG1oOU1JR0ptQVozN3p6RnczT21Qb2htanVCYnhvUFhB?=
 =?utf-8?B?UlppNnBCbUp6SzcrSVRUc2xyQ053T05WZDI3Q2FiUWtEMVdNaitNc1M3a2RH?=
 =?utf-8?B?eFJtTjBDZkRLSnk2RXlRUSs2WnZCVjRwZUtXOEZzSDgwN0dMaXNFS2JVWWd5?=
 =?utf-8?B?ejZBcHo5Wkt0b085MzhRdHNlOENCdjJITEgva2UvdDhCNDhDQmhlaVBJZ0F4?=
 =?utf-8?B?Z3VzZytJOFJvajkyUFlkbklJVU9SKzJPR1BYNzl1WStaLzZtNU1JVGs5RktM?=
 =?utf-8?B?NGUyWDNGVVJINklUZU5Ram9jUFZFQzJlKzY0TUkwbEdOTlUybnk4MCtkNG4r?=
 =?utf-8?B?Wm9RZnFBMVRlT0ppWWZJTzBSZFVURE1Xa2FFV1M2SXphT3R4dEdLWkZoQjRJ?=
 =?utf-8?B?cHFNNkd6cGdNWEZKaGpxOTNWakxMNnRmcDNab01vM1JMc0dkQWk1SHVuQ21t?=
 =?utf-8?B?WXBjcHN5NVVmNnBaeHZHYXowZTlaYnJtaXlLdllWeUJIWGo5K2hqaUhtVXJU?=
 =?utf-8?B?eGFEdlg1QkZFcmdiWjFXL3J0OHIrM2VvVWc3bkVwTjdSUEFNaS8yeE5RUVFr?=
 =?utf-8?B?Vm9GdXJKV0lJRnAzaWhsWVZTQy91Yk16bVV1TjdxSVd5WU9zYnZ0bDdQRlEx?=
 =?utf-8?B?aVBYUjNDT1FDM3dETXVYcG1TMEIrdE9rYmN4MGhFQ1kzVEFHODZ6dlkyRHRw?=
 =?utf-8?B?eGdqU0dLR2tqdy96VSt3RFdPeGdQRjJ2OUl5anhlUXY4eitjTUVKYjdBYWdR?=
 =?utf-8?B?RDhDN0cxQU5odlQ3aHdNdEtWblVnWHJNbCtCOGRSQkdEUEhya0dQRE1EQ2p2?=
 =?utf-8?B?bmdKSHRGSlRqYUZqMHVvQk1TR24zamFGWGVvR0NKRUpSL1hsMmdCcWNsVG9N?=
 =?utf-8?B?Z3U5eWxOYnNCMmtoa2I4N1J3ZFA5Vm5JUnVqcnh0UDVPU1Q5Y2ZFQVFLZGtQ?=
 =?utf-8?B?S29QODZtVEs2WllRNUtZcXRQZXNrUVNSRU8vdytTZ1J4RmtacnFiTHJrd2la?=
 =?utf-8?B?QnFVbWtwY091S25XSDBrVlc3OVdZQ2FlVkhDMC9CUnh0MTR2V3FCc3hkRHl0?=
 =?utf-8?B?bkJnTXQ2aTY4MEZpQlhndEtHRG11cVRJOVh1b3pFNndtQnNJZXZlTDFzSlMx?=
 =?utf-8?B?OE0zTFh4MUlJWVlVZkRqejlHK2ZqVnYwYnRHUUdiV2RlcE5qR0RqQzZsZ2Zy?=
 =?utf-8?B?V1Zkc2oxQWd6azltVGlJSWd1V2ljaXFQc1VMRlM4bWdibWdLZlZyQ2xiYmJY?=
 =?utf-8?B?UCtXMnpmU3RUbG9vaWtmc0liL2M0L3Z4cXdycEFZT3VEbVdSTHo5ZmxHdEFG?=
 =?utf-8?B?blozYjBTeXVIRno1OFZ3aGo3NmE1U3hyYlMvdjNMWHpGN0JIS2NrUmFrQkZj?=
 =?utf-8?B?VmNaWGowNnAwdldlODVrbXZyL2ZCMXY5a3FoWFh2Tm42VStsTjRFWCtPL3Zy?=
 =?utf-8?B?RGlJb0JzWUZCOCtlR3c4empDNGd3MzJ1allGTnlIeGRvdkpLZERjVUhSSkNE?=
 =?utf-8?B?c1hPbnhxMnl5VWtVUHRRcUJKQUVSYWhEekNjM0UxQ0xBcjNkdUl3Q2dOWFBv?=
 =?utf-8?B?T2dlMEVaNkFkWFlHOHFETGp0QjlCMWxFMllTNmdiN2NiNHgxeDc4cFFvV0NX?=
 =?utf-8?B?RnVabzdkRUl1bFpHSmJpVzNvbEU1eURUYWhTcGJlNm91QzdDYlR3Q3R5R24w?=
 =?utf-8?B?R0pGOEM1M3NPTmRIb2JmdjFEYjI5bXhiaWE2SzhNTUVaTmgyc3VBWWxtOXBW?=
 =?utf-8?B?N3RlSThtTFpkT0FoWXdUcUwxME8wMFNkL1RJRUJmVHdLeUNYbFRXclFHZ21D?=
 =?utf-8?B?dmJKRkNTUTlSY1RsekV6QXRHY3lwRlNOM3YvNG5pcmMzNXNuSkZ2UGdGZjN5?=
 =?utf-8?Q?iBQ2wYgBAOxTIrFKDEErCPVMD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97eb4c66-38b4-40e9-f1d7-08dd57dabe3d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 09:31:56.6307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mrYtQvCPwrWFEu8sj0vLKNXCeIDcSmum8otmYlxwd/1DheGUZ5TXyVnQtgp3UMGAqmcV1x8VbxBELZOf7yWh4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060

On 28-Feb-25 3:54 AM, Sean Christopherson wrote:
> Fix a long-lurking bug in SVM where KVM runs the guest with the host's
> DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
> context switch DEBUGCTL if and only if LBR virtualization is enabled (not
> just supported, but fully enabled).
> 
> The bug has gone unnoticed because until recently, the only bits that
> KVM would leave set were things like BTF, which are guest visible but
> won't cause functional problems unless guest software is being especially
> particular about #DBs.
> 
> The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
> as the resulting #DBs due to split-lock accesses in guest userspace (lol
> Steam) get reflected into the guest by KVM.
> 
> Note, I don't love suppressing DEBUGCTL.BTF, but practically speaking that's
> likely the behavior that SVM guests have gotten the vast, vast majority of
> the time, and given that it's the behavior on Intel, it's (hopefully) a safe
> option for a fix, e.g. versus trying to add proper BTF virtualization on the
> fly.
> 
> v3:
>  - Suppress BTF, as KVM doesn't actually support it. [Ravi]
>  - Actually load the guest's DEBUGCTL (though amusingly, with BTF squashed,
>    it's guaranteed to be '0' in this scenario). [Ravi]
> 
> v2:
>  - Load the guest's DEBUGCTL instead of simply zeroing it on VMRUN.
>  - Drop bits 5:3 from guest DEBUGCTL so that KVM doesn't let the guest
>    unintentionally enable BusLockTrap (AMD repurposed bits). [Ravi]
>  - Collect a review. [Xiaoyao]
>  - Make bits 5:3 fully reserved, in a separate not-for-stable patch.
> 
> v1: https://lore.kernel.org/all/20250224181315.2376869-1-seanjc@google.com

For the series,

Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>

Thanks,
Ravi

