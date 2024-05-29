Return-Path: <kvm+bounces-18275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A02A8D34C2
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 12:44:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E38CB287894
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 10:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BA917B438;
	Wed, 29 May 2024 10:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="43zRxywD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2076.outbound.protection.outlook.com [40.107.95.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7746C17B43A;
	Wed, 29 May 2024 10:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716979467; cv=fail; b=fJt9DdaYDvKdTfLxdAgWf2/6nhNzjbikGDt0jgtWodRJXuP2rDoGcgqYMNf7WX3JSbct9Z+b0l/rJsJ01hA/pYvcLHD8y5h7+q9Mw9ChO2Z3uFKzcRP/7EQ9p2BLonxjfKffRXGmjonbZBQVoL/Kr4wBnoRObNjbaocAF/stigg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716979467; c=relaxed/simple;
	bh=r8xcgiUvibXcnap3kVo6fGvYjX7nOaOQeqvz6cWCX8k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KryI2OM6MfKq94aPo8UK4NBZyAKI4fLAAkoMDkOwuFZrRJKC/1dwl/X/6e1IHRx1VXKKni0u14ibFPGGz/7xkNfo667xNkpmbORINuv92xPkmCjfhcMBPjlsfs5hCwvepKrT7RdFJ/x2UTfdYyaftBTVVf/cUoUM3IbDjYX44eY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=43zRxywD; arc=fail smtp.client-ip=40.107.95.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrZsi6i8P1etJx3PaA91+5n28wOTSx4YcC12zc0VyMcQC9vL4yBzEFjP2AYfHsZWlqn7Rdy+xFMyzgTNxNqULn91CLmmP2cJfpjURJomCI8ejYllD178GpotX/oBdOcToSOCOmMlCX028yIvjYXX0l/Pafag+S5LTqcjePpaV5pPoYhB4J2+8dXSvu/YVNO2UMvTtUwXwlb+jZbiVHRXSLQP05sn0cS7V0jspzn6hWa+FNl/3+aNcE5/pXUX7TxHghA7CyTaUt1E7LdFYMpvZ6dnF47ZpPnQHovpRJpkqR2oBjRsa0oBsI7rxV+qyubjA97ClZ+mNsOV4+PHnNLPKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6NGK2ZG49e3WKIGDAYQuscHvoaB6Pb2NoEkDv1xIf4=;
 b=NL2hfxPL9xkD4k0JLepRkM7wHVXywAaHCbjFXPfFClV2MBLsWIOJZTC+Q+izb2GDUTGlJejbt6YHGDvf4gLzAZQECHJCycG67q7PTsPwyMpbFrkPkPrtcNlNny8yAxytnctMpg1aOyR9A5y3ISlYfYE5XGWVjUxmamvT6JHEm9SRpWZPSe51X/qP7swc/DFWu6A8XmjxiSU+JlwrWF89BfqLlWbQtU80OkyHKvBAi0NenFszYb39ZWF/CInj7zp+bZlfRBupIqyanHzYwoAyQoURPWqL2a0chsvQVrKih6KQ3d3HqlRqv6Pg0sGuUXd5q7whL1GD4JyK+ejG06Wm8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6NGK2ZG49e3WKIGDAYQuscHvoaB6Pb2NoEkDv1xIf4=;
 b=43zRxywDcU6cWWU2Tbww/qES6pSmC2pQGiPLMTu2XAYqtRw4DVDFHlHgIwFRWRPmTZSY7PbFn8FvydwhMVsv2DvHWi+JVFzYSbkNuKxbi0cfiK2D7w2SxETw6PEzfBpC2rcpQcvXzZy6BXhwLLU7PBpygdPNaLe681soa+4ghZI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by SN7PR12MB7855.namprd12.prod.outlook.com (2603:10b6:806:343::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Wed, 29 May
 2024 10:44:22 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7611.025; Wed, 29 May 2024
 10:44:21 +0000
Message-ID: <f0de86a8-81c9-4656-862f-e229845d47cd@amd.com>
Date: Wed, 29 May 2024 16:14:10 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] KVM: SEV-ES: Prevent MSR access post VMSA
 encryption
To: Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
 nikunj.dadhania@amd.com
Cc: thomas.lendacky@amd.com, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 michael.roth@amd.com, pankaj.gupta@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, santosh.shukla@amd.com, ravi.bangoria@amd.com
References: <20240523121828.808-1-ravi.bangoria@amd.com>
 <20240523121828.808-2-ravi.bangoria@amd.com>
 <3eca1e7e-9ddc-47a2-b214-d8788a069222@redhat.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <3eca1e7e-9ddc-47a2-b214-d8788a069222@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0047.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::18) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|SN7PR12MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: 27e5c911-63df-430f-b354-08dc7fcc4c68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnpuUGdEVHZZUnFpcHowcTUyTDRTQ2ZMM2Z4a2V0eVBaczVwdHgrYk14T2x3?=
 =?utf-8?B?NDF4aHVLMzQwUFhQTnlrSzBBN2hOUVpTWXVrdDVvMjBOWmhhQzhpMkV0S1Vw?=
 =?utf-8?B?RmR3RkgySzExSXFKQ0VrYlZCZmVBSnJVTlFNUnlkdHpOV1NCMXFpR0hCcnpZ?=
 =?utf-8?B?UVJ0aG81M0M2UmZtbjNGT2N6TXNQaEY4bHZzZGdIaUx5azJlbUlIWlE3aUVQ?=
 =?utf-8?B?bkNrVWFPRU9uRW9hRkVQWXp3Mm9sMXZlVGFvR3RmYklBblFUWWF3cVd6RVZI?=
 =?utf-8?B?c1VuUWhLQzNPU0Y4anhXcGZmUnJFbG5qMFU5NXJZaEJYSVFpZWlKWGFkd3J6?=
 =?utf-8?B?ZzFIZjFFUFZ3NTgxSm9BUXJsNGtEalBXM0M0bko4VnE1dHcvNERNd0NkZUxv?=
 =?utf-8?B?OU9QZDY0aVptZEd4MStDNmF3amNWYUcwYmJUNk1abVR4K0ZnL25jZDNsV1FU?=
 =?utf-8?B?RmE2aW1TSStsUU45YWd2R2JsMGJxOWk2Z2l4TTlhT3lPdWlxMWlHZ0d5SjdE?=
 =?utf-8?B?N0RLekJrMWI4cjJDTlNiMkFrNmJtYWRYdHpiTmRRQUVFQytQODhuUTJyMTNJ?=
 =?utf-8?B?NzhZVEVlekMxVGhXMC8wbm1aS09IQ3J0ZzZPVlQrcTlFNlZBazFaOGExQ0tJ?=
 =?utf-8?B?ZWt1c1FzVzBFMURaL2UzaTlTVzMxZEdremNiYWxKK1k5cERUNEphMUYxYml6?=
 =?utf-8?B?QmU5TWNzVWZLT0F6WmxlUCthbUFxclNHUDVVRzI0UWtGM3lWUnVZVDRXcnRz?=
 =?utf-8?B?MjJJSndoWEVMbWtjQXpKK25WUFhQY1hTUUNJc0VreTE0VC9BSkFDUU0rTzBr?=
 =?utf-8?B?djNtaGdMMjBFdmMzcTJpRW05bzJFaGxBeGgyUm52SHVhS0ErQkkzMWp5czF0?=
 =?utf-8?B?aURRNGVMcnVHZ3NxR0ROOVJUdllKUk9rd2R0RDhPQWdjS1NoTklETzhocFRM?=
 =?utf-8?B?RCsyalVrNmF6aTRMQTB4VGR5YXNnSTJBNFBRRTBxVUl1SW9ETXcxOVkrWmVX?=
 =?utf-8?B?L0pYNCsybkpGQmxLUHJya21xTGNoR0hSajFFMHF0RFhvQmNoams2Qnh1dkYy?=
 =?utf-8?B?TlRURmFHVnFZcWtMWk1wbEhvWWtJOXZteU9xMEdhckpWQ3RXQ2ZqTDY2VzFC?=
 =?utf-8?B?TmtFdmtLMXpacExSaHg5c28vOTJXZiszbDlFNzRiaE40YjdMUTVrNjRsZnEv?=
 =?utf-8?B?UHJoQnZ0bVNrTFdkajJ1bkRQVjlZbFVmaFZvV0tmcGlMbFREay9GMU5JOGZV?=
 =?utf-8?B?TUZJZWhDcmJXanFoL01lKzBlMWc5OVFSVENwamwzZHVKTzFqbHE1NzJSLzJs?=
 =?utf-8?B?NERDL2NJYmpFQnE5dXdtRlVSalJqRjVtNHA0YTV5dG44U1dMeStUTTdLSVdD?=
 =?utf-8?B?ay9SeTl6QWRqdzRPKzVJMnZ0dHVjMkNmRzdGb2pUKzJkS0x6RkpNTnUxdHlL?=
 =?utf-8?B?bDkwWGQvZklVR1pCbE13YXp6YkxWV3E2Nklpa0J4c0pDcFNBYnhlVzNBWmha?=
 =?utf-8?B?TUEydXZ0ekphRGlxdzRsZjFKcC9kZGxWUUZkMENLS3dZOWt6d2k5OTZFRFBY?=
 =?utf-8?B?ZTBKVWQ0ZnZNLzJXMlcyNG1EZXRhczFJL0ZZdXhnQ3c0OGJxekxYakFzdTZN?=
 =?utf-8?B?RmV4MGVwb0pPaXovK2ExcWtJaDZYNSt3OXF3RTcybUptS0lzVURrc0dkOXBJ?=
 =?utf-8?B?TDMvWTBKaGJjUUlOS3djclJNNlpJR0x5TjQwakQ2WFo1WTRYRjlOL2Z3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0MwTGV4enhZZE5Qdkl0dy9NdXl1OVFjVFB0SG0wUnR2Skdqdnh4MlFJa0dQ?=
 =?utf-8?B?ZWI0dHlDMVUzb2NQT0tEbDBsSDBXMnZlMDE5Y0lzdjhBZHVGUTNIanJZMElX?=
 =?utf-8?B?STlzZTA0N1dFaFRmT0s5T2hERmdDUHAwUm96SjBOTjRkdnRJOHc3Y0lacEw4?=
 =?utf-8?B?QVkwNGx5RW9BZDBoS1BDUFNZRFJXYjYyYU93dWt5YW9Ja0lkT3VoVkZkUDJD?=
 =?utf-8?B?ZFJYV3hWMnBibkhhK1Fsd1ZJYW1CZzk2c3RHazU4eHBGOTJhY3Q4MVVUempr?=
 =?utf-8?B?bTdqSTBKVkw0NWp5dEczajBlV2YwbFBVK1NjcXVNdlB1bFlaUDBXTjg5RSsz?=
 =?utf-8?B?eUVHQ0NENE54czl0Y0RlaTY0cjdPSTBCcTc2LzN4eEhNS0w4NWxCRksrRHBt?=
 =?utf-8?B?aENidTJoNkREd2tMbzd1TVZRRGsvbGkzK01pOTB6RzlJNS9WbnZ6UVNDSlQy?=
 =?utf-8?B?cVFaYUhVTkxUZmpZT0tCcEF0ZjdESU4xUjZiOHN4UWdrOVFhSit4SXh2YTBm?=
 =?utf-8?B?a29Edy9pTVlwdU1iVEV1RUo2bHhjU25yd3dRRWZlTXIyOTRIMlA5S2tkMU43?=
 =?utf-8?B?K3QrMmV5QXJHVmJZOWVjV085Qlc2TzJHYTd1cGh3dXhuR0lFcFdnQnRrbWYr?=
 =?utf-8?B?dWRPVzNQamdNVXdnQWhYa3QvelN0Uk4wVkNJZnFaa21ZOG9CeXVSM2x5cnk1?=
 =?utf-8?B?WXpHOEhtUFBPaFhzbWlDb0Y3amZlVitENVFZWmd0ckp5ZHlqcVp5eDgrSHhH?=
 =?utf-8?B?VTdOQ1NsUFgvTXN4NXNXeFJmZUhhR0h0bHZZRDZiUHA1RXZGUllrWlVCWHJI?=
 =?utf-8?B?UUNyVFpJcDRJZ2xaSCt6c3U3QnFWQ2djYWFqYnJoa1BZVTBPYTV4UE9CZFhB?=
 =?utf-8?B?QWltRmRrV0FTRGhqSGpudFV4TVhQaVlGZmZPQkNnVHBVZzdVYkhIbEJob3lB?=
 =?utf-8?B?TGEwNXBkN3NsdzhVOGFlOGxqVGdYayt6eHVWRUtic05hcVVoYXp3eHZrb0Z4?=
 =?utf-8?B?Q0RNQjlFRVRTck5saUprazB5Sm5EdnE1YXNzdzNLNkRtTllhVDFJcFZlS1N2?=
 =?utf-8?B?KzNLamNjY1duZjZVRmtxcHBPdklKTzB3WmNOQ09jR2p0bTJ0WlFsdWFkditK?=
 =?utf-8?B?STJIbWpTZXU5M2xoa2h4UXplMWt6NTFzQlYrMFAwQW9IYTBob044L2orZ0Vh?=
 =?utf-8?B?aGNnT3AwcGVMMVlqbjVKdlp1OXd3M0xrRWhaK2hrMVNmbURhVFVQNDJMNmp4?=
 =?utf-8?B?RVp4cTEyQTNWQlQ1L29DNXZHWHJNZFJJbUtsY3owRXRCMFlUTzFqblhhWFRa?=
 =?utf-8?B?MU1FeXM3dEFqajZuTk9mT0Ixd0kxMTBId1Z2enlNK0xmTHJhZnpMSDhIbElY?=
 =?utf-8?B?WG1aWlprSUZkc3l6NGtEeWRkekxDL0VVdGZqRkhuQkk1T0FwWWV6enV0em1a?=
 =?utf-8?B?RFd0cmxBdVBQSVNnZDVqVlQxVmJLdndqWWhyV1pmZmR5VGpqOUJtME1kQjEy?=
 =?utf-8?B?MFEydE96WmwzVm9iY3hqWGU5TFVqOXZzUHgzMERTeDRyS0NmYzhWZnRFZmRH?=
 =?utf-8?B?aWVjZ0w2eDdER3orblVGMVA5NG0zd2Q1VXB2cXRZNGF0aDdQQVhDMGhZQTZF?=
 =?utf-8?B?Zldhd1kvRlZuM296R0NxMUxvOWVDdmZBS3B3a0szbGVjRzdpYlpUa3o3S2FV?=
 =?utf-8?B?eFo1VG1GeCtsYThiQ05Lam5kTGtXZ252MCtXOGZHSFFwcjl5WHNPTTNQWjRG?=
 =?utf-8?B?ZWZEWDFZTWV6YkVwTkNyOXJzMFVmaUNZRlpBajlNa00wbHpuZEY5SGJHOHVZ?=
 =?utf-8?B?c1p0Q2I2eFgzQkY4cTljblFnRzg3SnVDak8vSFk4MDJkWnBCcXVwaDhrMGdG?=
 =?utf-8?B?V2hlMlZxNGxhSDlFUHBEeW9TcHk1bmpONVAwSHRCN2ZPTEM5c3BLNWpEQjlO?=
 =?utf-8?B?akdrcTVZRThza29IR0tEbzZOQ1ZpYUIyRlhvcHBzdG9LM01zQ1duVElEWFZF?=
 =?utf-8?B?Z3ZFRWtTbHk1WWFQZk5KZ0JMbkZrTVowQ09yTFJIUGVwVDVDcldKUzM1Z040?=
 =?utf-8?B?YjJhYVBwZ25HUG9zaEpsRk02a2NheWJLY29SVFJoSFlPTWtSN2Q4RVNjV1V0?=
 =?utf-8?Q?+071HC4lRFU3KVA0ViO122V4N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e5c911-63df-430f-b354-08dc7fcc4c68
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 10:44:21.5046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2sf2YfFI77W0BZo4i0xt9lffwhMzcNpMTsoTMNad/T3bBqmjEt/4HizbT/Y6isHHuZ94d2TsOPziP1XOQiVLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7855

On 5/28/2024 10:01 PM, Paolo Bonzini wrote:
> On 5/23/24 14:18, Ravi Bangoria wrote:
>> From: Nikunj A Dadhania <nikunj@amd.com>
>>
>> KVM currently allows userspace to read/write MSRs even after the VMSA is
>> encrypted. This can cause unintentional issues if MSR access has side-
>> effects. For ex, while migrating a guest, userspace could attempt to
>> migrate MSR_IA32_DEBUGCTLMSR and end up unintentionally disabling LBRV on
>> the target. Fix this by preventing access to those MSRs which are context
>> switched via the VMSA, once the VMSA is encrypted.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
>> ---
>>   arch/x86/kvm/svm/svm.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 3d0549ca246f..489b0183f37d 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -2834,10 +2834,24 @@ static int svm_get_msr_feature(struct kvm_msr_entry *msr)
>>       return 0;
>>   }
>>   +static bool
>> +sev_es_prevent_msr_access(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> +{
>> +    return sev_es_guest(vcpu->kvm) &&
>> +           vcpu->arch.guest_state_protected &&
>> +           svm_msrpm_offset(msr_info->index) != MSR_INVALID &&
>> +           !msr_write_intercepted(vcpu, msr_info->index);
>> +}
>> +
>>   static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   {
>>       struct vcpu_svm *svm = to_svm(vcpu);
>>   +    if (sev_es_prevent_msr_access(vcpu, msr_info)) {
>> +        msr_info->data = 0;
>> +        return 0;
> 
> This should return -EINVAL, not 0.  Likewise below in svm_set_msr().

Sure.

Thanks,
Ravi

