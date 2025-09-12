Return-Path: <kvm+bounces-57405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED30DB550BE
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB48C1681F4
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9F378F2E;
	Fri, 12 Sep 2025 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BU0t4kKV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A822E40B
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 14:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757686638; cv=fail; b=coKK6SxVGiyx1+a2AeaNmiEdRegm1nw7pqbucuSRrwk1mFYbbnVVTdq/yCGprudG+7B8R+09Sk4Ot4MkfZHlQby7yQMxN9gkkC3ttGI2gi4trTwmcrgGYUW/cuJyBS/t56jlZ2ADUBIIeQI6GrJDvJBv1Y6iNQPu8eTCDxqRbfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757686638; c=relaxed/simple;
	bh=zArmYIipaEXjZX8HTRJTnN0bl1ExDDk+G5CifKqCbCo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z6Tt4mxcpvwaNP0YudDSmcoodK7lVzKXjwO6t5Xc5TFkvDbI2jMCbiYz40lMjG9iiaFI1gQALZD92T7uZSYiV9ut0R9lHTdQtaDiMmB1mgQoEooGnRlmapE/MQyRVDg4oJNJpBBFGVsQ+urhwf6HTzNwwSAVtQgaop/8j7cxCu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BU0t4kKV; arc=fail smtp.client-ip=40.107.236.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6JC7Ox9BUe7R4XrGx2ToiNCx/vnjmTuGCO/mJvswchTpUKwXEgelkCzNeHWI/0k9nglnIp81RlhoeY5i904vJ1cRp/ZgAktEjsuyyJsklcJMSD3MHC3+m1an7800ywkenDVJbH/JaewY+fXnjKroDmyqtejRfTeNF3Ju7OpwKAXbuZhQhH1t4izNZxhzII4PUv2PAxWsIGZDo3uWLWGR7nXgeIYyo9M6xArLNSjBDnxet1GnGx+n6MWlBANubo+47JhRA3IjjL7kDDwwlGMaLN6zzHrZoA9gQB7q+BC0eR9AM4FR7HQoUDWQgqXTM7beQm0uJGMF+cVjNlKC7FGWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WSZRd1RHheyuZ5kDKnVasoHLXrYSMwotYHGF93Zld8=;
 b=MVWTaXj435Gzu9TY8AwrH6CFGUNM22foUO16VrPWrPJMdxa5QfDNeErjYk3XIHlGkq8jiS6CqOLWROpsHncpgAomWU0w7716MPWseWBLgCCazhrLiPx3iQUK2dkoFE2zIbLCx45A+c8SrRN9mLVd94FF791Y/EtbItLIF1j5zaOS0HCEPRS15rJhMj1SpNsvn0n+fR6ijLMYaA9gCcfGFyuv5vD8TDyCwtYAPnnFKmSIdjdH56pCyjzDjmS2wa21AYnlERe3lwTTF3L26JQ3D5ORmI3sUBA/OMsFOci/NY4R03XamcNStOZRBQW+/CveUh7n22/iWVSzDXtfqs1atA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+WSZRd1RHheyuZ5kDKnVasoHLXrYSMwotYHGF93Zld8=;
 b=BU0t4kKV2O7p8srzQnhojgt3rniKlkTw+ti8xkI/9uTRZua719WNI/TOygljwkCfyJCVRZD+UkVbwqGm8c8PFctoIwggVBYQNNksAlNeNqx2Ytx62FNBxChqEsP0ao37LJZzvyIWQXEq8OY4xAiLEKUMGTCP68QN2I67/I5zlUQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by LV2PR12MB5798.namprd12.prod.outlook.com (2603:10b6:408:17a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 14:17:14 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 14:17:14 +0000
Message-ID: <46c73e5c-70b2-4700-97aa-e5ed06cc622f@amd.com>
Date: Fri, 12 Sep 2025 09:17:12 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 7/7] target/i386: SEV: Add support for enabling Secure
 AVIC SEV feature
To: "Naveen N Rao (AMD)" <naveen@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm@vger.kernel.org,
 "Daniel P. Berrange" <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, Zhao Liu <zhao1.liu@intel.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Michael Roth <michael.roth@amd.com>,
 Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1757589490.git.naveen@kernel.org>
 <632eaad0ef28943520a1285c8efb3d8a756e4624.1757589490.git.naveen@kernel.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <632eaad0ef28943520a1285c8efb3d8a756e4624.1757589490.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7P222CA0029.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|LV2PR12MB5798:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d56cbb-bb45-4c6a-4a71-08ddf2071246
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXJXRW1NbVQzZm1WRlZScFBRLy9WOXJjTk5WNTE3WGxIckJzUTNqMFJCOHYx?=
 =?utf-8?B?eTVZL1ZsUVFZL2hsVWNYZzNUTTF1YUhTcEROd0pPOG1xN0dXWWVIRUFCYi9j?=
 =?utf-8?B?dm54d1Z5KzdhNXpxSjRuSStwYzdFTjJNdDVNU0dTMms2dCt4dHl6dG9hSE93?=
 =?utf-8?B?K3hpNm9HdkVhTU5IL3pqUkFLRnVzSHY5RHM2UG5TdVdwN0VSdDBQd0hWeUpt?=
 =?utf-8?B?T0ZZTFhjNGFNcHc1VFpiVHc3aXgzMjZDc0M3c2l6UURGZmhUa3c2K29vRzIy?=
 =?utf-8?B?RFc3YmNyc1pZM0w0QS9HaE9reHpHYi9MVXJsc1d0Q0lhQ05LYmNhK1psR2Nz?=
 =?utf-8?B?aGR4WXk3ZW1GSysxM2Y2Z3FzbkY0QjdkaXkwcUprcnBjbjd2RHJaaFcxS0VM?=
 =?utf-8?B?QnRjZXJwYnJvQWoxeU8wR1VSTGZHY2phZXJRUFg2Z0ZJeDMwL1daU2g0OW9s?=
 =?utf-8?B?WXV1Sm1mQlpGRTNYNjc2NmJaSDFURTg5Zm9NYWJUVmU4K0g3SEMyMnBTVFBk?=
 =?utf-8?B?R0ZyVmxEY1ZSYzQ1UzZIZ3NIRlE5OGtMYXF2eWNGQnZOdHJWanAzSi8yQTh6?=
 =?utf-8?B?UEp0VmNVZUFrUkFxck9rckx6dzJibnI4eXNnNDlJK2FMSE8wc2Q2bnY2T3c2?=
 =?utf-8?B?QmM1VndYL3VxWlVDQ1NVMzUxc0dxaEpvaW1VbWdaR1BZeHQvNmpueGExZGV1?=
 =?utf-8?B?bEUwUEtkT0FvdEFJbkIzUTE4MmM5akRHMmpFZzJoajFnODQ5WVZTQ3VWZTN6?=
 =?utf-8?B?cHdSc1dobDRCcnN3eGUxMUxydzZrY2J6THp2OGVmWUZDRUlHN2c0RjcyYVh4?=
 =?utf-8?B?SGtKME9pUTRoek93cUxXbW5CeUJvc0tIbnQ0T0hyU3FEdzEvV3N3ZEh0N0xS?=
 =?utf-8?B?M0hFa0Y5UTVlQzkwdFFCcWZCNWc2VUN2Ty9iL2JEb0hFSU9UZEN1S251eTlR?=
 =?utf-8?B?S3NYM3hNMCtjNjVubjdYbFN0VXFoazhBbDBES1YwbmVBdzVSUFk0UmZBT2h5?=
 =?utf-8?B?TG5WNzBFTGNYL2h3MHhCWnFWdldjSW8xYmxpTFZuN3ZtMTdzKzVXQ0sxNUto?=
 =?utf-8?B?d2t0RldjTDBnaHhhYktHTlJtWllzK2JBZ0lRc2Q2ZG9uU2VRTWM0Q1Z4ZWM3?=
 =?utf-8?B?MTJQV0xkV1JTVTZyQWNOdjlQRGJoeElzNkNiV3RTcGRKMHZJNEp2ZFpvVXF3?=
 =?utf-8?B?Y21IQ3RVRUU4R2tXNTdscU16S3J0ZllwWHlYeW5nMVkySmlpa1JNTEhkazl6?=
 =?utf-8?B?OFF0THBzVUNtQVdYU2M3c08yUTRsSkNWYTVqOTF5N21DeHorblVTVlR3akpP?=
 =?utf-8?B?cEtYblVZK0VmN3RhNnlGeU5tZlBvaHpvUzNiZHoyRyt0bFNsdlhiRmtwUVFP?=
 =?utf-8?B?UTUxSlhpMDFCU1hVN08rL25VbnJzNWJJQ3N1eFhvVnBRQjgzbEIzUVAvcEt2?=
 =?utf-8?B?VUg4VzdsS0YyZDQrbG4vUndpaFNOcEFlQmJCWnNiTzVQbUlYWWs2OFdLV24r?=
 =?utf-8?B?YnozS2VHa3puNXZYZFo2WHNhVllFaityNjRjZ01wb2Z0YTQxN29BNjVhaWdL?=
 =?utf-8?B?RnF2SVdHbHlMekhGcG1wZTVsU09YeC9CVllGUHFSNzdoOWs4MExlTXNSUU5v?=
 =?utf-8?B?aFNlNUFNeXZtdGE4QjJKYm9vZEszd3BRSVh2a3RvUlB4VkxwdW5ZeHhVU0FR?=
 =?utf-8?B?NzQvTThiT0NYcEIrVjN2c2VydUZiL2ZqVzdrb3dWdjJ3cFFHeHBWb0crcFpu?=
 =?utf-8?B?Rkt5OU51Vk5aZ0JFVHJWbEU3S1lJUnpEeUZ2VWxKQU1rWXF5UjU0N0NjYXR3?=
 =?utf-8?B?Wk9uUXlIM0gzYXRoN21VSnVWeTdSTFBvZ05uZFBxNFBOWG9zcXZMYW1FczdF?=
 =?utf-8?B?UDBvbU5WNVhiSFluMUdPRlEzcmJvQ2NWb1A3bUJKamFQc3ZMUCs1VC83a2l5?=
 =?utf-8?Q?wzSEqamHT5Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UklCaXFSamRXT0Z4Mlk2Ly9vcURVZUFlcm1lUEVCV3Y1WXNwWlpxK1dqenpR?=
 =?utf-8?B?d255TEhzRWJHL2xsaXhrU0tyV0t5aTFIbTZuVUx2Q0QvR1FKWjRWc3JhSEJP?=
 =?utf-8?B?d3JZcVpiNnc5WEh4dHluUGoxQjdiSW5aVmIwTjV0dWJTalMvRE9WTmdBM0Qz?=
 =?utf-8?B?aEY5WUVNc0RkcW5qTFo2SHJVUm1HRFRmTzJUSk85N0h0WGZFU2w5RXdVSWpM?=
 =?utf-8?B?R1M0WFdkaWYwQmZZYVpqNk1RekhQcHl6QURKV2dFSndNaEszMHFZZWlCYkxi?=
 =?utf-8?B?aTV6RlBXMXRUWlljekRSSjNaYWNtcjEwcEFQQ2hOaFZ1ZG5jVm1uRDVGNVhj?=
 =?utf-8?B?Q3RrZGhtaWRCejNFc1pUWFhPamVXRVdTMkxCdTdXSTBXdEdaNDNJc1Jyak45?=
 =?utf-8?B?THg2aENnb1ZpV2VPR3ZhM2pKVURFZzZudWIwM1NpVGxva3E3ck1hU1lMeW0y?=
 =?utf-8?B?TEQyQWpicGZXazJEZ1o4Q3kvak1laUtvbmVtL2F6cjAxejZHelhleURnY0xG?=
 =?utf-8?B?a2xGTTlVYkhtZ3RpQnVMWWI3cytwekg5aDMwNldLL3pwdDNLNHppQnNtazFT?=
 =?utf-8?B?akRlWUlGZlViM1lrTjNWV0JlTHdyWXZHaFpXV1pycmZYRC9SdzNySkk2eW5M?=
 =?utf-8?B?ZkxSVDhYbWEwaDRnMzduYWd4MmVnRGxxL2JkbVIxc2FGYXBzWHNyMnR6Wjli?=
 =?utf-8?B?THA1NmpCeTRoaGYzZ1hIa2Z3MXM2aWxMUzlUd0lVNGxtMmVDQTc1bzZPK05E?=
 =?utf-8?B?YmxFM1RxVzhtdGg5a1V5eUhUclRvM01tZk10NnJ1R3hUeGZpNkdlQTZBVlN1?=
 =?utf-8?B?L0RNV0NCWXEyaXZOTXk4TWJUa0FERm5idnE0TklvUlB1RFBobkRHY0ZjdTVi?=
 =?utf-8?B?UkZwR3pWY0ErckkxbDluV01FVW1uK012VzBlbThMTW9BeW9zSlovbVN2cGJz?=
 =?utf-8?B?OUdnbVRnRkZNSFYrVG0zcEdYdW8waHhHeTE2Yk5POVRZVDFGM0VWY0dWMStR?=
 =?utf-8?B?ZVZhYzRQYXRoa2VGTjlQMk91TW9rZGtldFE3bS9lVlQxRnhQdFZwLyt2M1p4?=
 =?utf-8?B?UXJoeDA1Vk5CY2hDaEx6U1pTbTVUbTN4bDJxZUlKWW91dkkwWDBpNzRxc0di?=
 =?utf-8?B?b1ZSZU5lbmk3VWVJcnhCVTBTV3VzTmdObUV6Z1ZkU0Nsb2V5TUJML3Vkd3Fl?=
 =?utf-8?B?T0lMY0ZEam5YRExRR3MyRkMxVDQ0dWZQa1lzV2NvVk9FVWd3bkYvdFpsN1JJ?=
 =?utf-8?B?WHVMS1BTMnNTUXpuN0FHZmh4MUVIbjVDZk5ubERWWmlSOTY1ekJOVFhzL2JU?=
 =?utf-8?B?emhUQnFWMTFPNDVFaEJGZWZheWgzTTJqQ2huSlhHeGJLNVRHN2E2TTNScUJO?=
 =?utf-8?B?enF6V2VXK0g2dnZpd3ZRNjJVL1NSbXRoSGpnVDVTZ1QzbmdtK2RSdmgvK2lB?=
 =?utf-8?B?RU84b0RCNHkydXdaNDhibUxPY0RnQWE1dUVrVkViSEx0RVQyWGxYd2wxSTdO?=
 =?utf-8?B?ZUszeEdPa0ZLUEs0VW1JR2RydjF0T0tmeHFDVVBwRHdmSU51ZEVmM0g1OTQ5?=
 =?utf-8?B?K1dwMnhCa01SeGE1Tm1PSitCTWxLNDRVRE5xbkpFRW9IbzRDUkxERW90OG01?=
 =?utf-8?B?M1BTcDFTQ2I5blJ6UmtUQzl6bDBkcmZMNnh0akhGYmI2eDR3ZW5JcUxSR3VE?=
 =?utf-8?B?RGtOU014NmkyWEZqQjgzbXdmUk5yeVZlR0UweVU1eThPaTIza3p5TkRHcFVy?=
 =?utf-8?B?NXNrZnY4YVFVVDVVdjQ5UHF4MzdIeUVTcFNTOFlWZ3poZkYxdC9aK0hoTEx0?=
 =?utf-8?B?VFd4K08xNHJQM21CRXJUUWpUVFZvNEhlbTArbUg2TzRmeFl3Q2MwMk5wclBB?=
 =?utf-8?B?VVZsN3JROU4yV0VaTjFzZVhwTFhGdFQyMEEzVExFSjMvUFByc1VqVmVVc2VK?=
 =?utf-8?B?UXJFT0c0VnI1dWJYbmVWbHd1bXR4dlNrcEpuVmJsSDJMS0Z3bVVnR3hXZlhB?=
 =?utf-8?B?dmo0QkRNVTJpVUdhblE3QzVNdmg4bE1FU0Iza2tZbXdBMzVPN25idGo2dUJ5?=
 =?utf-8?B?bi9heC91K3VYbFFqUi9MSWIvVmJzeWl3ZVFReWJnVWJrR0hYbHYvK0Q4WU1E?=
 =?utf-8?Q?zIuQt8f5dduUlzAG1LBgg9n1/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d56cbb-bb45-4c6a-4a71-08ddf2071246
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 14:17:14.3281
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EVWExhSIM4b+sI95JO2Z9C/gMLd56FonNAdr3bsIALBlJSogYDlGIEDPtwGRvL1/Jv0dGeDJSL+EVIcvbTIfBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5798

On 9/11/25 06:54, Naveen N Rao (AMD) wrote:
> Add support for enabling Secure AVIC VMSA SEV feature in SEV-SNP guests
> through a new "secure-avic" boolean property on SEV-SNP guest objects.
> 
> Sample command-line:
>   -machine q35,confidential-guest-support=sev0 \
>   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,secure-avic=on

Since the hypervisor support for Secure AVIC is not accepted in KVM, yet,
this should not be included yet until we know what the full VMM
requirements might be.

Thanks,
Tom

> 
> Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  target/i386/sev.h |  1 +
>  target/i386/sev.c | 13 +++++++++++++
>  qapi/qom.json     |  5 ++++-
>  3 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/target/i386/sev.h b/target/i386/sev.h
> index 87e73034ad15..a374c144bccd 100644
> --- a/target/i386/sev.h
> +++ b/target/i386/sev.h
> @@ -47,6 +47,7 @@ bool sev_snp_enabled(void);
>  #define SVM_SEV_FEAT_SNP_ACTIVE     BIT(0)
>  #define SVM_SEV_FEAT_DEBUG_SWAP     BIT(5)
>  #define SVM_SEV_FEAT_SECURE_TSC     BIT(9)
> +#define SVM_SEV_FEAT_SECURE_AVIC    BIT(16)
>  
>  typedef struct SevKernelLoaderContext {
>      char *setup_data;
> diff --git a/target/i386/sev.c b/target/i386/sev.c
> index facf51c810d9..f9170e21ca57 100644
> --- a/target/i386/sev.c
> +++ b/target/i386/sev.c
> @@ -3147,6 +3147,16 @@ static void sev_snp_guest_set_secure_tsc(Object *obj, bool value, Error **errp)
>      sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_TSC, value);
>  }
>  
> +static bool sev_snp_guest_get_secure_avic(Object *obj, Error **errp)
> +{
> +    return is_sev_feature_set(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_AVIC);
> +}
> +
> +static void sev_snp_guest_set_secure_avic(Object *obj, bool value, Error **errp)
> +{
> +    sev_set_feature(SEV_COMMON(obj), SVM_SEV_FEAT_SECURE_AVIC, value);
> +}
> +
>  static void
>  sev_snp_guest_get_tsc_frequency(Object *obj, Visitor *v, const char *name,
>                                  void *opaque, Error **errp)
> @@ -3210,6 +3220,9 @@ sev_snp_guest_class_init(ObjectClass *oc, const void *data)
>      object_class_property_add(oc, "tsc-frequency", "uint32",
>                                sev_snp_guest_get_tsc_frequency,
>                                sev_snp_guest_set_tsc_frequency, NULL, NULL);
> +    object_class_property_add_bool(oc, "secure-avic",
> +                                  sev_snp_guest_get_secure_avic,
> +                                  sev_snp_guest_set_secure_avic);
>  }
>  
>  static void
> diff --git a/qapi/qom.json b/qapi/qom.json
> index 5b99148cb790..5dce560a2f54 100644
> --- a/qapi/qom.json
> +++ b/qapi/qom.json
> @@ -1105,6 +1105,8 @@
>  # @tsc-frequency: set secure TSC frequency. Only valid if Secure TSC
>  #     is enabled (default: zero) (since 10.2)
>  #
> +# @secure-avic: enable Secure AVIC (default: false) (since 10.2)
> +#
>  # Since: 9.1
>  ##
>  { 'struct': 'SevSnpGuestProperties',
> @@ -1118,7 +1120,8 @@
>              '*host-data': 'str',
>              '*vcek-disabled': 'bool',
>              '*secure-tsc': 'bool',
> -            '*tsc-frequency': 'uint32' } }
> +            '*tsc-frequency': 'uint32',
> +            '*secure-avic': 'bool' } }
>  
>  ##
>  # @TdxGuestProperties:


