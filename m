Return-Path: <kvm+bounces-35605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98B92A12E3F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 23:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA5A6188A13E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 22:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD98F1DC9A7;
	Wed, 15 Jan 2025 22:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ewTjMHMO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2056.outbound.protection.outlook.com [40.107.95.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0816435944;
	Wed, 15 Jan 2025 22:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736980017; cv=fail; b=CHuTFHTCj3Hsqjln3llldyFOdau9xeHgrJWFDFplKfPwB5OZRJyEaWbshL/6T1QordITXlkpTSQJOq42vYN6rFKzb3pgJIt2ZzTmd/LyWz3dlnFywOnNMlKGVmETOnlQBXxi2axhTUJX+O8wYxiKo23MBAtlTjaI3Fwg2Y8H3NA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736980017; c=relaxed/simple;
	bh=AdhhNJfyLFLlnBo99UtSQqThRWNXfBYgVNWlDe/sEqE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=szwD9YUqnjAjUcKpNlI4qfO7P3ux2Dd1hgLCoudEBoaUyj1CIc+vMYRVwErdi5FwJ3rrnCQR9QFwU5LPcds61QFZEcAjJaDGfIHS4I12HdWEG3BInGsliNzlEMN+xL2uBUuqrMSlKxO87DJklzwu6n4RGQqQNl/LhDKAgREpxfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ewTjMHMO; arc=fail smtp.client-ip=40.107.95.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h9xNu6DKAW7V6H4Q/L+7B4+7TNV4q7j1y3X/agQS1XfXSvySjHNG6FacuLXfIPX23dZGrz6Z5rGmrbfSLLPD6HSmcvHcajOHCHK5u4jBdW73Mwy0jxWxiHNg8AFYaExdk3Z2lhlPj05h/GFEzZ1AetRcBLjMmTckDER1DguXDdEMSyeD/a6q/SphuJS5S/bjKy/DcMLoCkfdVDMemDVRU9D1C/j4XBtSEWiAT75xTI17ykJwZWVrdQUccvxBXq7+8t6EDetRSGrbcrCvLqEF5us/2Hk0mzS0eie7VBst6yyx/2TSbjAZSbbTeicNGhjJyQUftqVo2T/su6CpGacu1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x92xltQjn+0e0X6p/gn/oBhwgxB7OMOSFK0kc/M2ZdI=;
 b=jlhqrHQHM6QYcWE7Yjd+5UGorlAV039jwLxDZBf2gAy7lwVNjRdocNyXcnj6DzvAzNRdJa0wTRlIIRcyIQtYE8rI/f2uGA8O4e6dganrXex/aKoBcApdUdOKHyqwxWg7rgHvW+mI9i3o/lb+ykf8T/Ctw6bIxGlRxuN5ubGuoVQEKx1y8wpCpsF8dgdB4byqNvo2NixAzUUNMBo1Gwu81u256xhEQ58hD933Vnz7gKb6hoCr7Tx0R6sd9VdsxI5pRCt6RdO0VTF+JxnuqmDdLVgX+d51IflevUeErMccQ44Pu2s+gjeWs9K9Y9xzG9eNrSINL/5GzJpqLqr2+yZWRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x92xltQjn+0e0X6p/gn/oBhwgxB7OMOSFK0kc/M2ZdI=;
 b=ewTjMHMOue2ZdaaOhNP8VKnY/+Ib7pWrdlLmfiCKVNzRO06Gb4YrwhAhAK9gfJ9cESdp09XX/CqVv7Fflqj0gWJtF2VtfCBBOhj9gF7SFg523fRvkphEm5so271HcWc1mldM1XRN2eQLTJiatGWvfnF6xZp7cxq4h/297+tl/LY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB8494.namprd12.prod.outlook.com (2603:10b6:208:44c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 22:26:51 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 22:26:51 +0000
Message-ID: <e37dcf89-e369-4cb0-bdac-01c930dfb565@amd.com>
Date: Wed, 15 Jan 2025 16:26:45 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, pbonzini@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1735931639.git.ashish.kalra@amd.com>
 <14f97f58d6150c6784909261db7f9a05d8d32566.1735931639.git.ashish.kalra@amd.com>
 <6241f868-98ee-592b-9475-7e6cec09d977@amd.com>
 <8ae7718c-2321-4f3a-b5b7-7fb029d150cf@amd.com>
 <8adf7f48-dab0-cbed-d920-e3b74d8411cf@amd.com>
 <ee9d2956-fa55-4c83-b17d-055df7e1150c@amd.com>
 <d6d08c6b-9602-4f3d-92c2-8db6d50a1b92@amd.com> <Z4G9--FpoeOlbEDz@google.com>
 <5e3c0fe3-b220-404f-8ae0-f0790a7098b6@amd.com>
 <f02fee7d-27e8-4ddc-b349-6d0f8c7919fa@amd.com> <Z4bl0D4CbtHgwGGW@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z4bl0D4CbtHgwGGW@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:806:20::18) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB8494:EE_
X-MS-Office365-Filtering-Correlation-Id: 9279a5b8-f590-49d2-084a-08dd35b3b507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WWxDVWJPMnNpc0xCd2oxdDRFMDQzVjZVNW9XamZLZGV6eE11RS85SFFyYmRN?=
 =?utf-8?B?VEp1NFVmNU9yM3dWNVArMzlDRzMwL1d4MXM2dEQrc2pPNndZeC9VNWpJb2Mx?=
 =?utf-8?B?Z2t1bWlVem51TnlhRllybGp3ZHlZTXliUW1aY1plOHJjZUplT2g1T0x1Rlh2?=
 =?utf-8?B?eGd4WjIrVXhIcFlxWTVXUDZPR1A2cFdOeC80RUM3YU4xVnQ4UDZUYTl0MXZS?=
 =?utf-8?B?VFV3Y2sxOUxEMDJNNFlrZkZpUGczOGtQWWhsQ0V3SnJZODFMNE9GTXA1Y3Nj?=
 =?utf-8?B?RmRMZE5ZbTRacS9udzh2NStRWDhXUy94T3FKT1JySXh3UkhFWXAyaW93S2t2?=
 =?utf-8?B?SlVXTnlteDcyWG9JanZrRmZ6bDhyOWFseGJaMGxaQklHZXB5WVVxUXM3UnNk?=
 =?utf-8?B?TFQ4cjF4ZGNPbTdmZjNlU2NXYnVKWmdkMDVvaEtxVkl2M0N4S1QrOHFHYVFq?=
 =?utf-8?B?d25UL3Z2STUvSTRoSTBHUTdNdUxJaEJIK1hhbU90dG9DRjdDRWhNRzJzMXRi?=
 =?utf-8?B?MHgxNnJWamhxKzNmd2lzeHFxZlczaHdVMndMMTBLMEdSR29nckxBaTZ2UE9I?=
 =?utf-8?B?K0lkaWNxRkhwSGxUYUtIOFVKNlArVkRqNXV3eWo5NFN4R0pUZWEwNUw4eFZa?=
 =?utf-8?B?UGRMYjVwVnBPSXRiUHU5SEVyZ0pZSXZ6c21VZUZQSzB6V1JNaFExWlVLWTZM?=
 =?utf-8?B?bjRNa0VBcktHMmV6S0c5UkVsMk9RUEVISDZGd2xncy83NExwV2N4SG50MGla?=
 =?utf-8?B?emwxb24wcm41MXpnMzVBMThURTBzdDM1bGZHQVI2aitSMkpFQ0VXV2RkWFdt?=
 =?utf-8?B?dDZrQUoyODF1YjdQVVhHRDRaN2NBem02MXdHT2VpR0tQM1VkS0ttTUJjNDJ2?=
 =?utf-8?B?S2dTWlNLUVBoSERodWFuNmkvQSs0SzhmMVNPSkIwWXIxc2ZPUGJFakQ2SXRS?=
 =?utf-8?B?TGM5SkovaEU5WWxEU2pJT1NhSENLVm9uMkFNY0g0RWFyVXNIc0huQTNKNFU1?=
 =?utf-8?B?QUE1WitsMlJ0SnhwVko4dGJoREUyeFFteE5UakVzOEUyQmRNbko5ZUpqMzBD?=
 =?utf-8?B?VmpxZ1hKV0RjWFFBQ0VhbmVCd1l4VDFVOXRNR2NOZnVkQkRLUm90dEcyWWQ4?=
 =?utf-8?B?dlFiZ1NkbUdFVkpOSjZqQnVJTklUQnVsTmFRRFpCMFlKKzFCZHNPVzlKTE9m?=
 =?utf-8?B?V24xQWlWdCtUYU01WnU1eDNibWV0aVVmbkNacEMrbGM0NjRkdFZjVDRCc21v?=
 =?utf-8?B?M1pGMXhsT0JxdUFmblNBanZiOHd4RHhZN0tQMTlCTld3SityeHVOa1hFaFZ3?=
 =?utf-8?B?S1FaYlg1cnlyWHdYR0VEeXZzckovRkxhWU1FdUx4c2UxcktnVEFGVEhWSjB4?=
 =?utf-8?B?T0FyVkV0elFsNUlmT3ZOUHdlTm9JYnZ3ajVHUU50VVZtVlpORDkxUm5lNFZQ?=
 =?utf-8?B?Y25FcEVpL0g4VmxKVnNWcGJHdThwMU5vYnBBMHJMQzRISWJvQlQxMlJLOWJB?=
 =?utf-8?B?aDA1aTJaWnVSa0s1UTZwYWorWWtIRnBoQVQ2ZTV3WDQwK2gzRzJUZG5SS0FC?=
 =?utf-8?B?a2JZSnVnbnpCUE9TMlZiczhyNGErQnZPRTFObUpVY1dyY2V1anJoeHYwKzA3?=
 =?utf-8?B?NWZTemc0SU8ycjVybk5GRCtIY0pxdy8vVTkxcC9MSElVYlMwQ0hoZFRPejdu?=
 =?utf-8?B?Yys3M3BhUDVnWlZGNkVVQjI2dS9oZDQwSGdHQmtlbUQ3ejZteFc3eUwvUjRu?=
 =?utf-8?B?TkNhbWl3aHBmRlRyZHVuc29SUzFsT0lnSkt1d1lKd3R3UGMvemNvMHNENUJF?=
 =?utf-8?B?Zjd2dmpFT280R1RXSldobFcwMHI3ZUtGcndiWFVZcDdIR1JuOUd3SUpvcGRh?=
 =?utf-8?Q?Bw0rkQK4t4RM/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bnBXNERuZDdEQXh3ZDlLd3Z3QmpWQ3YrRHVhV3NNNzRuYkI4elhSc25PVFk5?=
 =?utf-8?B?UnVteXJ2MVdqOWhmeTB3NjQwWFBldTBNNE8zRFh2YjJtRThLaksvYUduSW9k?=
 =?utf-8?B?Yi9QclNHQWVkT0pHQnQwOE10M21PUjBjZnpoVWxvc01KZlhTSWJ2YzVoc3Uv?=
 =?utf-8?B?NWx1eXYzZndoS0pPYWtoTm5TdVNQeDNwK2hYWHd1Q1JEeTNoMDlCWUYrY0Va?=
 =?utf-8?B?aDhUSGw4dXREeGJDaUFuc2tqRjNrVkFmNlR1QU02bVZpd0hzZXJjamR0SFFy?=
 =?utf-8?B?ZkhEQWRZNmpoc1J6QU5JY3BkQXdqQllkWjZ2UjduUDZBS3dueVUvbzZPcklV?=
 =?utf-8?B?S1RMNXEwYkVIUER4eUFoQThWZEdYeHZmeGtwY2N2ZDJaZitYUWZOeEZqL1JU?=
 =?utf-8?B?enNmd0RSYkd6cW04U1N4YkpkTVFlZFc2eXJ5Y1dCR0hMek1IQlRjSG9UaTNk?=
 =?utf-8?B?MmF6S0NyV2RyZnB5K1dHb0ZBVEF4QjhtYnlmUDFFRDhXV2twd3VvUVdoUVRX?=
 =?utf-8?B?MG1HTzJEalBDa2h4V2Z6eUpobFVMc1l0djlBQTQyVWtlUGJ3MG9ndG1LYlJh?=
 =?utf-8?B?SzNOZSs4NkxkVnlIVGRJSnVNcjBxQWZMU3psSE01eENzbkxiOWZ1OVVYNHVr?=
 =?utf-8?B?VXVvZVk5bXorZ2hQN0tEMDNoSGZwTi90VWhhb3M4N2ZrOVdnQU1yMHg2TC8w?=
 =?utf-8?B?OXRzdjNBNyswS1dXMFNqTlB2NjJrVndCSTBXZlpna2xFZWFaYW11QzVEQ1VH?=
 =?utf-8?B?dTlTbnBGdlVQWnIvZkIrSmZDQTJsR0cyQ2Z3TnlxcGQ5TFNMRnZvc1AwSEZy?=
 =?utf-8?B?OFRrVlV1Z3p1UmQvSk9mZmpmTFhOYlBLdEg3cWt2QXhXNDNPd2s0NzUzMmtx?=
 =?utf-8?B?TVo4aTFYWWtzaUFFK0xIMDUrMGRoMUk2R3Ewa1V3VjVVT2J2ZFRTeG9xZG5S?=
 =?utf-8?B?RmgvZlpqUmtTYVlFN2p4dHpFTitYSytvODJUU1ZVa01yL2hwZFhzR1F1Y0Jv?=
 =?utf-8?B?UlRRUnZRNEdUT2Rzd2liUmZWR1k2OWNVbU9qTWtJM2htM212MWllczZmckZL?=
 =?utf-8?B?WjNKa0d4OTdCOHIrU2xISXZIOFdsWndwS3lnaWRVd2JLSE44R2RzT09TUU1U?=
 =?utf-8?B?UVBTVW1JMFBFWFZWTktnUnJHWkM2azI2NFNqbGlGR3lMMmIrN1d4L1dWdGg3?=
 =?utf-8?B?NURGTjZYZEx0VnQxaG5RTjBYRnhOdEtGWGRyT3ZYYTdnbGFKSzNpWkZCb1Bn?=
 =?utf-8?B?M1lyUzZFQzNNVTBYYWYzbnFRNmQ4MDM1Z2NkZ3NCRFpuN2dFQTVIODMzSGkw?=
 =?utf-8?B?N0dzbkxaVjhGa1gxUm1uK2pLUFlKVmNYOFd5NmN6N1NkVHNLT2lGS2tPRUJ0?=
 =?utf-8?B?MzN0Wm5tZGdoQVo1eU9Rbmo0RFoycXNWV2pwNHdLREk3MzYyNXZocWhma0Fa?=
 =?utf-8?B?UVF6RDdwSGNyMTRKaERhV2RiZG1aZXFiTHJCZWJjLytGQVNXeVRDTjZlYjV0?=
 =?utf-8?B?WndJWTBHTERxTmk2Z29XWG9LNUNwTFpXTEdOaDVhVFRNTzNTZWtmcTBWNTR0?=
 =?utf-8?B?SVNrQTB2ZzdyRWpCcFpxd1gyUlZXQjNlb3JqK3VxRmJ1ZDZGeXZEWTlQQStL?=
 =?utf-8?B?VTVSRjVmY0RtMWJIN3F3M0FPMHNpb0V1Szd1YXFVRWlxckZCV3VMQ2VxVE0x?=
 =?utf-8?B?N0ZkcEVnVHVwUURjdVpBUjBCNGVaWHBMSHJhbGVLekNJVzB0Tk91RXlpNTFw?=
 =?utf-8?B?N05tQkNPYzFsYkVmaElnUjdObDZZOUp0dTlpQXNuZVpmN1BTK2JCeTVTeTFm?=
 =?utf-8?B?T3pCT3ZuUXN4RHp0WjVWb0ZxdDZ4TW1pMUpMN2lobGJZSmU2RXlPdE5rbEhi?=
 =?utf-8?B?UGJQY1d5dHZDMXRmaHVPNFFLcExMNWZ4YkxiRkNqekFHbzM4OVFLWDd1MW5x?=
 =?utf-8?B?ay96WEJiTG1wQzZtUWNNZE43ckRHdzdkZ2huOTNML1FkaHU3NThEQ05ibDMz?=
 =?utf-8?B?d0xscW9QWlRPVVk3WEpYQnhtZElvVnNzQnNOclE2c1ZlZUxlbHBPVTJ3QkNi?=
 =?utf-8?B?YW8ybmtDYk5FV1g0a0xGVmpwUGl5UllyQkNrQjd6eWJqOG5TL2tLVjl1QVdC?=
 =?utf-8?Q?uvH6Fqri3LA7Rbxkv1SmWbKPI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9279a5b8-f590-49d2-084a-08dd35b3b507
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 22:26:51.1169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0ML3r1fSAiPw0eCcxQTNeaRcNdh+jYwoUikr66k6GyqO6iJTytpqx1lVSttOuNiw0aEtH0khtZrO4n/mew+QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8494

Hello Sean,

On 1/14/2025 4:31 PM, Sean Christopherson wrote:
> On Tue, Jan 14, 2025, Ashish Kalra wrote:
>> On 1/13/2025 9:03 AM, Kalra, Ashish wrote:
>>> SNP host support is enabled in snp_rmptable_init() in
>>> arch/x86/virt/svm/sev.c, which is invoked as a device_initcall().  Here
>>> device_initcall() is used as snp_rmptable_init() expects AMD IOMMU SNP
>>> support to be enabled prior to it and the AMD IOMMU driver is initialized
>>> after PCI bus enumeration. 
> 
> Ugh.  So. Many. Dependencies.
> 
> That's a kernel bug, full stop.  RMP initialization very obviously is not device
> initialization.

I agree.

> 
> Why isn't snp_rmptable_init() called from mem_encrypt_init()?  AFAICT,
> arch_cpu_finalize_init() is called after IOMMU initialziation.  And if that
> doesn't work, hack it into arch_post_acpi_subsys_init().  Using device_initcall()
> to initialization the RMP is insane, IMO.

Currently SNP support on IOMMU is enabled via the following code path:

rootfs_initcall(pci_iommu_init) -> pci_iommu_init() -> amd_iommu_init() -> iommu_snp_enable()

And, smp_rmptable_init() needs to be executed after iommu_snp_enable() and that's why we can't 
call snp_rmptable_init() as early as mem_encrypt_init() or post arch ACPI callbacks, etc.

But, there is a patch from the AMD IOMMU team, which calls iommu_snp_enable() early after
early_amd_iommu_init() is executed and this will happen during AMD IOMMU driver initialization
with the following code path:

apic_intr_mode_init() -> enable_IR_x2apic() -> irq_remapping_enable() -> amd_iommu_enable() -> iommu_snp_enable()

This AMD IOMMU driver patch moves SNP enable check before enabling IOMMUs as certain IOMMU buffer
sizes may change depending on SNP support being enabled. 

With this AMD IOMMU driver patch applied, we can now call snp_rmptable_init() early with a subsys_initcall(). 

That fixes the issue with SNP host enabling code being called later than KVM initialization
with kvm_amd module built-in.

I will post a fix for the SNP host support broken with kvm_amd module built-in with this AMD IOMMU driver
patch to call iommu_snp_enable() early and the subsys_initcall() change for snp_rmptable_init() fix
on top of it. 

> 
>>> Additionally, the PSP driver probably needs to be initialized at
>>> device_initcall level if it is built-in, but that is much later than KVM
>>> module initialization, therefore, that is blocker for moving SEV/SNP
>>> initialization to KVM module load time instead of PSP module probe time.
>>> Do note that i have verified and tested that PSP module initialization
>>> works when invoked as a device_initcall(). 
>>
>> As a follow-up to the above issues, i have an important question: 
>>
>> Do we really need kvm_amd module to be built-in for SEV/SNP support ?
> 
> Yes.
> 
>> Is there any usage case/scenario where the kvm_amd module needs to be
>> built-in for SEV/SNP support ?
> 
> Don't care.  I am 100% against setting a precedent of tying features to KVM
> being a module or not, especially since this is a solvable problem.
> 
> Ideally, the initcall infrastructure would let modules express dependencies, but
> I can appreciate that solving this generically would require a high amount of
> complexity.
> 
> Having KVM explicitly call into the PSP driver as needed isn't difficult, just
> gross.  But for me, it's still far better giving up and requiring everything to
> be modules.
> 
> E.g.
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 943bd074a5d3..a2ee12e998f0 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2972,6 +2972,16 @@ void __init sev_hardware_setup(void)
>             WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_FLUSHBYASID)))
>                 goto out;
>  
> +       /*
> +        * The kernel's initcall infrastructure lacks the ability to express
> +        * dependencies between initcalls, where as the modules infrastructure
> +        * automatically handles dependencies via symbol loading.  Ensure the
> +        * PSP SEV driver is initialized before proceeding if KVM is built-in,
> +        * as the dependency isn't handled by the initcall infrastructure.
> +        */
> +       if (IS_BUILTIN(CONFIG_KVM_AMD) && sev_module_init())
> +               goto out;
> +
>         /* Retrieve SEV CPUID information */
>         cpuid(0x8000001f, &eax, &ebx, &ecx, &edx);
>  
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 7eb3e4668286..a0cdc03984cb 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -253,8 +253,12 @@ struct sp_device *sp_get_psp_master_device(void)
>  static int __init sp_mod_init(void)
>  {
>  #ifdef CONFIG_X86
> +       static bool initialized;
>         int ret;
>  
> +       if (initialized)
> +               return 0;
> +
>         ret = sp_pci_init();
>         if (ret)
>                 return ret;
> @@ -263,6 +267,7 @@ static int __init sp_mod_init(void)
>         psp_pci_init();
>  #endif
>  
> +       initialized = true;
>         return 0;
>  #endif
>  
> @@ -279,6 +284,13 @@ static int __init sp_mod_init(void)
>         return -ENODEV;
>  }
>  
> +#if IS_BUILTIN(CONFIG_KVM_AMD) && IS_ENABLED(CONFIG_KVM_AMD_SEV)
> +int __init sev_module_init(void)
> +{
> +       return sp_mod_init();
> +}
> +#endif
> +
>  static void __exit sp_mod_exit(void)
>  {
>  #ifdef CONFIG_X86
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 903ddfea8585..0138d22b46ac 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -814,6 +814,8 @@ struct sev_data_snp_commit {
>  
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  
> +int __init sev_module_init(void);
> +
>  /**
>   * sev_platform_init - perform SEV INIT command
>   *

I have tested your patch for KVM explicitly calling into the PSP driver and this works well, with this
patch applied as expected PSP driver initialization completes before KVM initialization.

So we can continue with the approach to move SEV/SNP initialization stuff to KVM.
I will add your patch to the v4 of these series i am going to post next.

Thanks,
Ashish

