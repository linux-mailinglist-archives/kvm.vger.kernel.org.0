Return-Path: <kvm+bounces-39053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 723E1A42F76
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:49:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12C051710B1
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:49:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02AA61DF261;
	Mon, 24 Feb 2025 21:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sg444I4m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2054.outbound.protection.outlook.com [40.107.243.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30DF1A2397;
	Mon, 24 Feb 2025 21:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740433759; cv=fail; b=kf18CeHX8QkIolbt9/xTD+TmUHMHovggR4wDlSRxpUzW45uJ56O0x2qblIY3BX+54C7NWPBsFoKz6Ny8DcJoL0XI8xI2WOtfiajjFomt6ZndQrXmnD68k90rQG1paHWy87PCrOgbnYqawF6kzyX41HNXhXa85tolIllN4gWAtYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740433759; c=relaxed/simple;
	bh=0njU9X9LU+hU8h9ZQJIxhspAEmpAxuh8eA85iLRf+Yw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W/Pp3RGmAB47z3Lp+QSw5adyLj2gjxc7d2MxS4vbxS2isQEkkNvOOxXq+bHvzzjn6kq2Dy2gyVWBoFVUP8pMrOdamWAhZIliNEz6g8LS45gluySARjeBCVaaP0nsm1jBZUK/dGlmH3JUC39VqOwqeUA/wYby3bsH5svLfj6DuUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sg444I4m; arc=fail smtp.client-ip=40.107.243.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dKbRZ0mhIRjD5GCcrNL/Tl2JULl1esA3jFQgMpgoiGzmYV+BKJfQ8pnRPPr/D1Fdb1XyN6+DlJfakHRAIx/PFfhz47rEyLOYvrYzlmQY23EoHkgh6k0+WYmj4RvRGrzBqEHFhCgSSY2H2eXD6aj6hN0TZUITwNwet34GAaJKfdpOBRNkkKrS7XW6TM/Qz6ppGzxRqIv0tURMHX09d5nkgjV5b+/lXJJbHAgB+YGy4xDM/M41NKxq0wF6u8UE9ttO6h+Nyj1ACB4DMli8P4p4HyofpjSSB+l9yu/gUuN3wfyOXqP0qa02G7FXoDmgzYNcVrY3p86SA8EsBq50jcd2Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+ukKxsKVe9DD6zEtlbjJFj4iVh8ctHIEarVHBGTI2s=;
 b=P1KtqzcQrO5ROKWNSwuePB/pPEjw8KK8IlQPt7lnYzS+W/I8VlqHpWfxzlzzfjg7wDyKNOuXIK0Bc8/GAh/e2J5wJiahE7VqUNbq3OKjY2TmYfqNWSNJ6v1GOJ8WOwsbIpGJo9qUyT3bT+bA0eDb6QFtCS7YgJTtzdLMz2jQ2eva9MG0BQi4thPlMKumIJXJisf4W7RdteT82jESxiKbLTiFaMrT2QkBN0VpJUJP3fFbZrAT6j6eto4AQUjmlaOyF7fvjzOdgH0eMKKkqSQc++wYJ6qfzU32Bf+5Qk/2w4reOlGCYCpKId3SfDJ96QvMYlwm0TO2U9wjFXAhyEOZ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+ukKxsKVe9DD6zEtlbjJFj4iVh8ctHIEarVHBGTI2s=;
 b=sg444I4mV3UB2hI6+afcuylhVW4j3Cw0UY3VgaSLWKSe4r2iQRLciu7yR1yO33EHwsj2P7Ih0X+furEFky7hMX0SVR/HL5+r6SvzddcWFkaBHb+qTPnpm2vCqvByI4KOdoy/rBQy39J2rdoSD9MR+DkclIcG7KItvd3jEhUB/mQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB7681.namprd12.prod.outlook.com (2603:10b6:930:84::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Mon, 24 Feb
 2025 21:49:11 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 21:49:11 +0000
Message-ID: <c7fa2932-c295-8663-a3ca-840b63d72fc2@amd.com>
Date: Mon, 24 Feb 2025 15:49:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 07/10] KVM: SVM: Use guard(mutex) to simplify SNP AP
 Creation error handling
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-8-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250219012705.1495231-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:806:28::34) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB7681:EE_
X-MS-Office365-Filtering-Correlation-Id: c9c10096-348a-418d-b4c5-08dd551d1280
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OEc3VnZqVU9HVkdpdFFGeWNaeDZmZDZrSkVheXcxK1pOMW5PcWgzUm82ZGlj?=
 =?utf-8?B?bHYzRWxxM0Z2WTN0ZGF3YmthaFpJN3lZalNIYldGWlBMcllmQTFYRGk0akdS?=
 =?utf-8?B?dTZuZDd3bWxsK2FHOW44S3JtUGhoWGhFNmhFc1BzVXZTeUVwTXRSV1BRR0NP?=
 =?utf-8?B?VVZjeW9KT3ZrM21rUFVNYlBKb2xacjdHdWhWMUtHRmtDNDdmdGVXN0p1Umx1?=
 =?utf-8?B?bFdKTDV3czlqYkFqMW1weEpTVVk0bW1NcXMzbWRlR3E1VjA4U0p5VUNST2JV?=
 =?utf-8?B?Qjk1SjBsbGtGaEdSdFF6TUNSVy82U2V5cmgycXc3TXNjME1KSVIySE1oWFZK?=
 =?utf-8?B?b0tNQno3WHFISXdDTHZ0UDBGQmYvWDdaWEE2VklEQm9sckplNHNBbktZKy9T?=
 =?utf-8?B?S0twdFJ6a2hERURIamQ2Ri8rd2ZSOFJ1M2d3WU9oN0dQcFdSMENjdnBQL1FD?=
 =?utf-8?B?RnBRVUUzK3dxQzBkdzZ1aERTbWRiait2K3pVZzFHSUhPMlBmM28yL1BRSDk3?=
 =?utf-8?B?RVN6UHdHaHJvamJGa0IxVzh5aHR1TkU5Mmw5N3diTkV3SkJLTFVMYis5bEtQ?=
 =?utf-8?B?NlgvRnVjMkYrYllWU1VuUmZKWVQyV0NLdUU5N0xtdERJelZRN0xBOU4zUGdr?=
 =?utf-8?B?S2Y1WFFDUXhqNGJ4aXAvMHIvZkx5NkFBeDd1b2dXUFBaNmlIMkhLRmdmTUFm?=
 =?utf-8?B?dUI4VGYvWTkxMkk3U1NPL1RDZGo1L3p4REpvODVrZEZPSlQ2UUthdU5GRWNk?=
 =?utf-8?B?eklhY2hZV08yNGYxbVdUcUNXaUZlc2FzcnRha3ZweWF2RHQ2aHpxV1pkanQy?=
 =?utf-8?B?RXVYZkpEOXcwQVVCc083Uk4zSGRXbkQrdFZUN2YxWXJQOGExR0l1RE9FbEJz?=
 =?utf-8?B?aG1ucGErY1pnbCtJKzZndDFrU2J1MUZucWRWaGpBWDVVNElQc08zM3B4VnZE?=
 =?utf-8?B?V3hMQnhUZDlzUCsvekJwWkxJcjJGUFhRTmFCa3h2alhkM05PdzloamtDaExu?=
 =?utf-8?B?SEdmVUluVkJlb2llRURoUWVTWGZmWnEzTDBtRTBCdUJUMitqdXZPZlgwSXho?=
 =?utf-8?B?YWg4bnYwbEtKUWhpUmZmbVZmUFc1bkJGMWQ2VTQrM0FpZnJVbHlpQ2ZoRVdj?=
 =?utf-8?B?dDRjbzFkS1JMZzFmRVNTTUYrVkFKcjBINXdPaEdEMk81eWM3Q0toZVBjSkxK?=
 =?utf-8?B?STM4Rm51ajRlYURnTXFaK2FFbC83c0dEY0xZM0ZDRTZQcWJ0ckl0dHpCbktO?=
 =?utf-8?B?d0RzRnAyT0tFdUx2eXd5MmFrVHNDMVgyNnMzR3l0WE1Ua0s4dXoxYUlHQnBv?=
 =?utf-8?B?NVJ2d2lraGdmdDlTT3dWUUhMUlZRak5PYmtnUk5RZ24zdHhVQ040MnBIVSti?=
 =?utf-8?B?OS9TU0c5SXlmanUyQktmKzlsMThLQVdtRkwwRy91TCtNTXMwVUtTVURpbFJ1?=
 =?utf-8?B?ZDNMZ0V0YjgrajdoOUpjYXFPOHFCVXZuTUhyblloUXF4RzFrbUpyMmJWalpo?=
 =?utf-8?B?OVZmOU9PSDN0NXB2QjQ1VzBBZE52RUljYmFZSFpOTVJReGY4YW1tTVRHVnNL?=
 =?utf-8?B?YWYvOVd6TXp3UlZJNUVzd2xhV1RTNDVWMnAvVTROQ3RzeE1RU1lJbzN3VTMr?=
 =?utf-8?B?Z3NCa3hXanF1eWZvRXFKMmFsZGFCOUJTWXFkZ0R4YnZSMkdlam4yNEZtb1Yz?=
 =?utf-8?B?MVhEMjBQNHRZa2FwSDA2TWJha0cwMjJKdzR4c0NvTk4rRnp1TU9mM0xkK0NT?=
 =?utf-8?B?Q2dBSFNxdzBJRkVsZVZrcWpvanBTZitRbkd0NjdEY0VyMHljZ25DYUpZOTc5?=
 =?utf-8?B?ck1rL0d3QkVudUQrR3MvWXhuejJiTVZxcDk1RWJUYld3SDgyQWtBQldneTFN?=
 =?utf-8?Q?RFRIzGj2ux08k?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TjV1MTU1emdab3ZrWmJERExGdkdGZytjVGczWVphYVRPRFhqZmJia2NWMkd1?=
 =?utf-8?B?SExwRTZVV3BkSmVxYitCcFp4OWU2WHN2dmhFbTlxbnBsUDhUMitSb2V4bHda?=
 =?utf-8?B?RXAzTEZBTDkrNjRLcS9YQXkrc3ozTmFoVHJJNTRJUmdPVkdyNkdtcVEwNkdN?=
 =?utf-8?B?QTBNdjZZSGRVUFlERkgwTW1tSHVMaXZuVUlKaEtraVYwTE15aXFqdlVNdUEr?=
 =?utf-8?B?ZkU5M1Q2bWJYVWc4dGlHYlhralR0NE5sQ1d6c0krOFVsQkQrSnNZRDJLRWx0?=
 =?utf-8?B?K2lDaVk3Rll4RDEwWHFORTExQzM1YW5qQ09HZnh0V29QNzRPOEtCZ2psalZB?=
 =?utf-8?B?djN4c2wrdlBBamhWTXh6YVdoakltQ3ZneDNjV3IwRU9Ka0JGcHZXRlNJOERx?=
 =?utf-8?B?Z1RveHdBTHBJQ0p3TFFIR0Irb0Q1MUpqMys3ekxxdDlBbGlNU1ZiS1E3dlFs?=
 =?utf-8?B?ZTJVNE56d1JPcmY3R29DQnRER2ZwYjJXRGZTK1g0WFVSMC9NQ0o0QU9PUkRh?=
 =?utf-8?B?UThGR1BkTHFNUEQ5SThiWkVZQ0FGd2x3eTdOdG1JcSt4emRNZjdBek94aUtt?=
 =?utf-8?B?SXQ1d2dvS2pNeVE4MzZ3bml0c0lDUlUzaS9JcUtJQ0JnU2VFR09pTDBpZ0Ux?=
 =?utf-8?B?VGZ3eTYvVzl4SStjU1VuMWM3ZzNicW5pWnRkWEdSd0s3VHhtZ2oxdi90bnFj?=
 =?utf-8?B?NDBLV0xoVlBhVDdBOGpSQXdFYWoxcnd5VDFpTHFJR1p3RzFkKzNnM1dkTkMv?=
 =?utf-8?B?cFU3eFRtNkdIcGRYYmI1QWZkQ1ZQU28yanAyWjRNalJqWWxHUkdUaC8rOTZ2?=
 =?utf-8?B?d0FOcEJJT1hnQUhnZGVBOFpuUVczdTN1aFRRU29EQzk1TTJIQmp3cXF2YXE5?=
 =?utf-8?B?MzA4ZGcxQ0I5Rm1FQXlNQjY1S3U0Y25BbnNJMVdpeThJcDdaN05XYzNwYkp3?=
 =?utf-8?B?ZGhxd016WUpHRmFnaVdhbEQrYnExeWhjR2dXckxRaGFkck9YR0hDWGw4SWdr?=
 =?utf-8?B?NjJVR0hBSnMxQnBjT1RyRzZMVkNjSVFOQUJvZ2dQaVZCQmZiQjBJc3EvOHNP?=
 =?utf-8?B?QlpObmdsY0RsZ2pNMFY1N2dSRXFqZXU4NktSd3hDWCsyd0xRYkNGNHd6cjVN?=
 =?utf-8?B?MjhpUit3aFdQZ1dDV00rTndPRjNvQm0zV0toU0lZRUdhcFN5R1pMaG9LVllE?=
 =?utf-8?B?MzNqMmVoRFp5S24zb1BrVVBHWUJIYWRXR3BjQ3FGWU04T0hTdUVvN0xpeHdn?=
 =?utf-8?B?S0xmVHlVbWRLQ3dRVFpzMDQxd0hkWmpKaWFMbXoxaFllMXJWbnlqRGNrVyta?=
 =?utf-8?B?bENESWpnZFN2dEZtc29iaXI4RmxRRUdFNzFydWRabElpak9LWHZ2Nkl1WE5I?=
 =?utf-8?B?YzltMGFPdWM0WkdZWU5RQi9DSnZqeWNXaXBhTTZPZERDVlplOVQ1TlNwMzl4?=
 =?utf-8?B?THUzUzV2cDJUY1dpTXJtYTlTKzIyckpMZGg4UllOUHVLalorSk1teDQ2cDdG?=
 =?utf-8?B?TUZvRllFN0Jid0FJR0lJZnJNRjlJYWhEc3l0eFhCOCtCTEdSMWdsZUxYM0t5?=
 =?utf-8?B?a01pSVpFd2ZYZnZET1hyQXRRWjRGQ3JCdUljdVdCQXp1a01oY2hiRWRmUGxr?=
 =?utf-8?B?Um5xdFpmY1pVd3Z0TDRzcnQxWjhmQ3NCb0JaWklLczUzUDFGTEh4a2xaNmRU?=
 =?utf-8?B?K25lYjhEQndSZE9MTXd3aEk3NlR1V0N1S3NYaCtoaFMwbTdocDJVU21SSDhT?=
 =?utf-8?B?MklxMmRSZ2NxSTkvK3ByU1Fnak9hQ1dJalMyMGNwYVVUeHBkNnpnY3JaM2tk?=
 =?utf-8?B?cFFsWlRob1Y3VVdZRHZ3Ync3cGhlY0l1M2dNbmtoRUswOGhSS252SzM2NHR1?=
 =?utf-8?B?K2JhZ2NTaUtBL1FqclE1OEJQTXVNRGg2SEJrbGFzQ0JUT1RMMEdrQVdlY3Ay?=
 =?utf-8?B?RG5uSGpLSVBVOWJLTWdpZzRreDZScFluNms2U2Z3OGFLS0lkUGUraE9OOGly?=
 =?utf-8?B?MHlmSDd1ZEhRWjFXSmQwWEwyME8vRGtpR1R4U1F0ZisvaFdvVWE3S0tjOUVJ?=
 =?utf-8?B?SlJjakROY1hDdmZrckxCMFpsUSt6bUFlUHVuVXFQcXVrTWZaM3BxYkwyTHph?=
 =?utf-8?Q?xaZFcC6zFkvg4bzc7TETnkho9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9c10096-348a-418d-b4c5-08dd551d1280
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 21:49:11.0598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x0LMqYqs5vFpTPEEkDAY5CflR1jaOlvGOeCYZOnmWNRtFDTEFVXLpQAMFT3Nu5LM42eE5PWGaTszRHck02/ZPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7681

On 2/18/25 19:27, Sean Christopherson wrote:
> Use guard(mutex) in sev_snp_ap_creation() and modify the error paths to
> return directly instead of jumping to a common exit point.
> 
> No functional change intended.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 7f6c8fedb235..241cf7769508 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3940,7 +3940,6 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  	struct vcpu_svm *target_svm;
>  	unsigned int request;
>  	unsigned int apic_id;
> -	int ret;
>  
>  	request = lower_32_bits(svm->vmcb->control.exit_info_1);
>  	apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
> @@ -3953,11 +3952,9 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  		return -EINVAL;
>  	}
>  
> -	ret = 0;
> -
>  	target_svm = to_svm(target_vcpu);
>  
> -	mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
> +	guard(mutex)(&target_svm->sev_es.snp_vmsa_mutex);
>  
>  	switch (request) {
>  	case SVM_VMGEXIT_AP_CREATE_ON_INIT:
> @@ -3965,15 +3962,13 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  		if (vcpu->arch.regs[VCPU_REGS_RAX] != sev->vmsa_features) {
>  			vcpu_unimpl(vcpu, "vmgexit: mismatched AP sev_features [%#lx] != [%#llx] from guest\n",
>  				    vcpu->arch.regs[VCPU_REGS_RAX], sev->vmsa_features);
> -			ret = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>  		}
>  
>  		if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
>  			vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
>  				    svm->vmcb->control.exit_info_2);
> -			ret = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>  		}
>  
>  		/*
> @@ -3987,8 +3982,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  			vcpu_unimpl(vcpu,
>  				    "vmgexit: AP VMSA address [%llx] from guest is unsafe as it is 2M aligned\n",
>  				    svm->vmcb->control.exit_info_2);
> -			ret = -EINVAL;
> -			goto out;
> +			return -EINVAL;
>  		}
>  
>  		target_svm->sev_es.snp_vmsa_gpa = svm->vmcb->control.exit_info_2;
> @@ -3999,8 +3993,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  	default:
>  		vcpu_unimpl(vcpu, "vmgexit: invalid AP creation request [%#x] from guest\n",
>  			    request);
> -		ret = -EINVAL;
> -		goto out;
> +		return -EINVAL;
>  	}
>  
>  	target_svm->sev_es.snp_ap_waiting_for_reset = true;
> @@ -4014,10 +4007,7 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
>  		kvm_vcpu_kick(target_vcpu);
>  	}
>  
> -out:
> -	mutex_unlock(&target_svm->sev_es.snp_vmsa_mutex);
> -
> -	return ret;
> +	return 0;
>  }
>  
>  static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)

