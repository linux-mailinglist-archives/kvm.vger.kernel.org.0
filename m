Return-Path: <kvm+bounces-19046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E59CB8FFA45
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 05:48:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FDE4B229F5
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 03:48:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40DE918AF4;
	Fri,  7 Jun 2024 03:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nINMU7aP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B0714269;
	Fri,  7 Jun 2024 03:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717732122; cv=fail; b=B/UUY7JELR7JM+X5pn6dDvc0MV9+eXKZMOcEuRhTaRPwDQO9XJ41DpPlLaKLGV3+Tk4o4eXwbf5E2x+PEmO2OXTV47e36VbPDQopImbxo6kSz2ZIFBSjVe5JI/tHu+ytL/P9Q1YF+HvlDrndGK/6nQeku+8SJj+fCFeNtCohDBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717732122; c=relaxed/simple;
	bh=sTKvhsYO4S7gd1wxE+zXuIsdRJfIzO5SFmUVDW8Eudg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j18Tr7neGHJxrcXAK/Cw0Xt+htyEt+T09FyFK4eoQaC3bYTELoH+kVpcsI+cQQvs08ntZILYED9LxC7j+GGff+ILwgubxKbsty5v/mFfj6j6UcbLml0tMlp3/x2Kp063NkVgsCA3OvRpEROvTzoW0olgJC7a42QhxLUxlTcNvYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nINMU7aP; arc=fail smtp.client-ip=40.107.102.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/9Yd6Eb8WusrS56AsNjEK62E2xCNqxqRFlqO8qht3tMibKVG2AmPtKHx0RjZ4lrbMcdmhlGbjfafG+/t5iVO6S6/0Siyoh/JjzHL/QWcz1iHQHe3ao8+IKQcCOh4W7RkzPD837o6rb+k+DXhlNXLFj6ABpOPm/nwxDnk9J39+KFpWt9NVt7yoiDRa+d6no6Z0tTqTK4sP/f0U/s9i9gV5GsHIEZ4jd+3SgZd21bHj7D84nNrLTEayFL3Oj3IzLgbmdnF6b38IzieSGIxXn9s9OBg7ubrQVwRiui26BbvPBl1sbTgVM+aOYKq4hgLCb9NpbRJwLm0a5TEuNy/C8rLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KLnE2pfTDqT7d7OsyQbkmkVy+uep2dnjab3q0wvwhuk=;
 b=WQTsQRN8hqENSC+FdzT1iGzTw0PEWEd7Mf/cRWvRBnN22HTLY1WGNW1fCqhHMbRJMWb0TADVJkcrvzhx7BbfKgQav5n1JewGJbCbmbWq4DQCEflD9bQesDqN3fPd4COv3F1TZrGj1phGXG1j8CKj2bKeRWs14FXekxD24sFFydK6rRTRC4KhUxlypU91r0tz9e7TB1eABP55svXL7aKeQdbtKvGoBTcIesVrc8Ftv80uaNMNebJcw/hf1yWYi1dGlrGYSnvuDjRUL51uEDuIhZZdW9OPqJ0/ne+K0JMA5X05BT2siNBl9WRZnT9YUwIb5PT9MeIb8kVUC+X+r6cTmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLnE2pfTDqT7d7OsyQbkmkVy+uep2dnjab3q0wvwhuk=;
 b=nINMU7aPYP1oGDicMj4lq5aytTr8rkF+CsAqMilNDK/rUng3HgqzjuWe/ir8gT/FgmIsbyN2nrRvmGAy0/led4Q10mSp4MPdk9t59mte9ib6y+tfwMBnDIyUfLmyCMqFQbtuJYhhlgXs9gKvOKGaqBMoL3ikawO3BFb17RdKEpY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by SJ0PR12MB6992.namprd12.prod.outlook.com (2603:10b6:a03:483::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Fri, 7 Jun
 2024 03:48:38 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7633.018; Fri, 7 Jun 2024
 03:48:38 +0000
Message-ID: <fcfe8637-01df-4c0a-a2c1-1243dd5f32a4@amd.com>
Date: Fri, 7 Jun 2024 09:18:28 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: SEV-ES: Fix svm_get_msr()/svm_set_msr() for
 KVM_SEV_ES_INIT guests
To: Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
 Nikunj A Dadhania <nikunj@amd.com>, Srikanth Aithal <sraithal@amd.com>,
 ravi.bangoria@amd.com, kvm@vger.kernel.org
References: <20240604233510.764949-1-michael.roth@amd.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <20240604233510.764949-1-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0119.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::34) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|SJ0PR12MB6992:EE_
X-MS-Office365-Filtering-Correlation-Id: 51f1d06b-d3df-489a-ca66-08dc86a4b6ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFA2bkF4cGh3dXFiUEdqUEFEa1AvM3pmTnpFbFd1M29WUW1UL21USEdRcmZm?=
 =?utf-8?B?UDc4REV5ODZrOThNTUt1dm1Ebk1laXV3czY2RG5oUzhlMGxVZi9ZeTk5Z0xj?=
 =?utf-8?B?NmMyWmNzRGM1Q29sL1JlWE51dWp6U0wvcUVaWDIwVjBEdWRYbjhsSktlUHdT?=
 =?utf-8?B?emQ2UlVmQm5HRExtOWV5NlBIWnVzckErY2FPTTcxeEZJamVRcGxlQjRyK3Fw?=
 =?utf-8?B?ZDNaMXpJdDlVaEkyTHR5THVBNi8ydlE2OXhPOFg1T1B4RGlUeWczVnpST0tQ?=
 =?utf-8?B?NjZVcW1kYTRpZmRLSDA5UHQ0NGdRUHhIdlJjLzJWUFRIVDR6Qi9iUisxcmMv?=
 =?utf-8?B?SEVOSkJVZ2c3QVZoNFMrRXJVMkwybUxSdlp0TUlNYTRPenZ3QmtBNlRheFNn?=
 =?utf-8?B?QVF4Y1lycFVGYXUyeTdNUXpXdmx4S3g3QTNkekxTZXR4SDZMWFhuS2dzUTYr?=
 =?utf-8?B?aTFrZGdxZFYraU1tTE5GdzRxTkxiaHlEdmlFZlovT3BuOTNXZGdmZSthOXZV?=
 =?utf-8?B?RkcxWGlCbkNzNkJDRXFRRHBSeDZkS2g5bi9NTUVsMncrMlRFNEdQMGw4TXpq?=
 =?utf-8?B?UFVqR0trUWF2THo3RjN2VllVd0JLdE5nQWVZNEVuNy9LU1BPSHM3bnROTjFK?=
 =?utf-8?B?VW96WCtZQ3BxRkNYWnZiekpzcC9iV0tOYnRWaDM1Z0U1R1FEZXlxYkZxMHVF?=
 =?utf-8?B?TEl5ejlrczhseGNpV0NqcVFhRVMwbVlLSDQrS3Bkb0VUOVFxdFhKWkg1elFv?=
 =?utf-8?B?ano1REhjMFBhNmx4VDRidk9ncVhCU0VCZVRsUWtXMFh3dDcvZENwMmVKVnBZ?=
 =?utf-8?B?N2JXY2swSDdEZXQxWElKZ2s4RkdmV3VUdkRvWEVCMUhEWFJUZUhBTlR0cHlT?=
 =?utf-8?B?WWhpbFU5SWcya1JBc29SK3RyMHFYZ20xcTFrdWNKU2x1TDlObHFIb055UVo1?=
 =?utf-8?B?RjhxSEZTUnYwTVhnRU1DalN6dVEyTE80TjVNUmFZcnZ4bGthODhyUXVkUkc5?=
 =?utf-8?B?dG01aXQzL3RCNHQzVTdiM3hIZjhJRVVxT3l4TG1DTkhJQ2NqOXduT2VBUTBM?=
 =?utf-8?B?emttalBQUkgrUE1hL0xPQStQdmhUdy9JcUk1Vkx0c3R2NWZKUHM3THJwZEtQ?=
 =?utf-8?B?d0JsbHY5MlF0cjZOVzI5MnJySVhlVHg0cWRUblZ2YTE1VlMrVnBVcXNOdlVa?=
 =?utf-8?B?Uk12QS9Wa2dwY241bGVzc0FNRWRoSkc4N0dZOUZZMXlJKzhlbXN1TUgrMm1I?=
 =?utf-8?B?cGljVXg0dDhacjRSSnlkclJQUk00aC9oQUtZTDlyTm1tMTZ4MjFnNklQOVFC?=
 =?utf-8?B?cHNlcEs3d0poeGsrdVRCUWZzNmhMeFZ3bXB5Mkc2dy81czlldW41clRqS3ho?=
 =?utf-8?B?b3Yva1ZSNE5tY0g5SjFWMzRxM0luUE9VcjJYR0JZdk4ybHNsNXNlcWJXSjNJ?=
 =?utf-8?B?U3VWeEFNNGlpYUYwMGhNenRNRDVBZmM1dVJmckJLM2kzdEpzcTQyejhYUGZE?=
 =?utf-8?B?Ry9LZnJFZHBzL3I1dGdtSVNLVVJGQXNPcHhHZ0htTHdIZUdPc2QyMFJ4UWFw?=
 =?utf-8?B?V1U0S2VPWTRTL0wveHJGLzhjTDU4dFFmbGRmU3dzZkMyMXhnRWQ1bXVSSDNz?=
 =?utf-8?B?RWVwY0Vhd1lBOG9DR08wY2RSWkd5azYwQVJzb2ZsemJBZUt0TTBWNWFWTU5m?=
 =?utf-8?Q?D0B7qqG50w9dUul1wpeD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTRLZjlva1Fud0swZ2VUQW9LRDliQWZnSDVqODlKbnY3eUpnQmovczBiNGMw?=
 =?utf-8?B?V1NrZm1UTVZ0MjZMa1pRQWc2ZDhQY1MwOWNRMXB5dWIyS1lCN1lFajFnYWF0?=
 =?utf-8?B?OEdXUXlGOFRyNVZWZWJLNnJ4Q0w0ZUxFTzFSNFBheTdNamQvalBsS2s2UWoy?=
 =?utf-8?B?bnhBOXE4MGdTUUEwZU85VjNoRnBidkxhc2p0VTdiYlBvNmJlYS90akFqU1Ir?=
 =?utf-8?B?SGFsd1BtRWhKMzBoMU10aHdZd2Z4ZDFBU1JRUngreUhzbERXYStsSDFic3dm?=
 =?utf-8?B?VncwaHhsVlEvdWxrMVFwUURBUWxjaUo2cEFlMWthK1VXWHRMNkhXdjZiRkVM?=
 =?utf-8?B?STJnczV6eWVGd0dVS25xaUNhRk0wN0tKdHJacUw4Riswem0rTnArUXhsQVlv?=
 =?utf-8?B?MnJjUUFyTlI4eWgzYU9rOGtmbmY5T2R1SGJUREJJY0xieGs0VU8wRW1mdVo4?=
 =?utf-8?B?Tmw3L3BiRG5JU3E4K1FnZFNBOGR5R0p2eFpTTTUyNGhQTS83TythUWJmRlll?=
 =?utf-8?B?RHdpNjFyNnFXQyt3N3c4SFBFajZ0TVZBZjZhV3RUWWpFaDdIaUp5eXNIK3kw?=
 =?utf-8?B?L2szVWE3ZE0xNWQ2anRqbUk1L3JiRVRUL3hmaHBXODNtd0wrWExqQ0NNTUZT?=
 =?utf-8?B?UXd2OHAwbnBxTTQ4SjArbjRWV2VkSitMTE1jQ0tGVTFTZ1JGQ2t6TkIzSnly?=
 =?utf-8?B?SkhFVDJ0ZkVEdU5SNytodXE4S00yb0lzVG5tUTIzR2tZSEErUUxGcjdpaUZV?=
 =?utf-8?B?WTRiZDVFb1hyVWI3WHZwZTRqWUcra2d6ODdneHBIWmlHWnhQV1pBbE1KUU5z?=
 =?utf-8?B?amZUS1NRMWEwNDJBa00yYU80R1dLdGV0aTFpVHY4RzRGS0dibTg5QUMzQSti?=
 =?utf-8?B?WnI1WExTZkJkYXUvTWxjalFhc3E1b0xRNSs0ZGw0WUxzOFpHUDNyTXBJTEZs?=
 =?utf-8?B?V0RFelhkS3hUbVlxMlozeWdsajcwNmh3VEJrTGdnK204WDdsZ0FNaW5HMGh0?=
 =?utf-8?B?cnNZV0ZwY3V0Lzh1ZmZCWSttaEJiQUpiTXYwV1BCWnRkL2VpWnQwaDFNcFBS?=
 =?utf-8?B?bkFVZEVXWGplUjVlb05DUGRqVjdCZkpMWUdkN2VZQ3Y0K1Nta3FoZnl0aURs?=
 =?utf-8?B?OW5BYk41SXQrR1JleXR0R011U2I0Qk54MU4yeHN4aVZVaE5BVkFxRW1iMjJQ?=
 =?utf-8?B?d1ZZOFMrcXQyRElPQVNKT08rNTRjQVlYclN6am13SDhPbjZnaFB0bkVlVFQ0?=
 =?utf-8?B?Q2hnb2R5WUZZQW9sUXB2VGsvbHM5dXdKOWgxZDF6VE1RTUVsSWJJdXlYVVN5?=
 =?utf-8?B?TkxxRnJ5alZWcytGN200ZFhLWU5LQmVuYTFGVlozMVZoTXJRSFQ2Y1FTQzhC?=
 =?utf-8?B?M1V5NGlPMmlXSHl4djVIWHJpR0ZTVVNDNUJ6YUkwdmhFeVBYSzE1djVHcmF2?=
 =?utf-8?B?WkpQL1NubFBqUTlGemNKcit2Wkd1SUQ3cHI5TVpCbFA4RW5nTEo0MzluL2xK?=
 =?utf-8?B?VmI3aFRxRjR3UTRDN0FnbHhtL3VYVFVNS2VmTFlCWituQTRiRHNaUE1sS1JL?=
 =?utf-8?B?MmpZZEtYcWlSTkdXWEd6aUx6SVpPUlI5dCtVTWt1U0M1a29RQk9udjZUaHc3?=
 =?utf-8?B?cEJhcWxEWTlUWmJMSk1LMjVTMGhsT3hVQTlhZHUzZUJycGJQVWtXMTJjZFBy?=
 =?utf-8?B?cWltU1drZ2xVa09KOVBDK2pFZXE2d2hHR1pNcTc3dnZFdFo4UE5sVTIxaDhN?=
 =?utf-8?B?R0hvMDBTNEhxcjR1RUtJTHhCbjRSb0t3a0cwRVlISjVFYUVkSGFOUEpvVmM3?=
 =?utf-8?B?OFJoNlBvMnhCWFRibFEzRlRKL291eXRZWW9NbnNiKyt0ZWFySWc3dFhSQ1Rl?=
 =?utf-8?B?VzF1RXZuZFpJMjFtNFI3ZkVRdExVSEpBL29hOWV6R2RNY3VRek1ibFprSFFF?=
 =?utf-8?B?eW1IUVlGb2Ryb09BT3kvSWdzV3JVTHlSMlprdzRXTVJtVitqT1Q3aEtsS0Vt?=
 =?utf-8?B?OTlXb2UranF5SE5nL1ExTjN5SFhjS2xPZE5hQ3hHeGpOTTlSMTFFRmI1ei9q?=
 =?utf-8?B?Z1hLdGpXdEhubU40alZTRXZJOXplVS9WYXZwbXNBU2pMaFdrWHFJOGJETzIy?=
 =?utf-8?Q?Wj89YP/40Mk2MiwyLEAUdEyXn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51f1d06b-d3df-489a-ca66-08dc86a4b6ab
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 03:48:38.0485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxCDz+uEj7Ow4YJceq777wOdGXsoefCInMoHZhnQ2cfQCu+aA7Z92w3C9FLWEVcMvOF/nXAOjPImL/Cah+xXAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6992

On 6/5/2024 5:05 AM, Michael Roth wrote:
> With commit 27bd5fdc24c0 ("KVM: SEV-ES: Prevent MSR access post VMSA
> encryption"), older VMMs like QEMU 9.0 and older will fail when booting
> SEV-ES guests with something like the following error:
> 
>   qemu-system-x86_64: error: failed to get MSR 0x174
>   qemu-system-x86_64: ../qemu.git/target/i386/kvm/kvm.c:3950: kvm_get_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> 
> This is because older VMMs that might still call
> svm_get_msr()/svm_set_msr() for SEV-ES guests after guest boot even if
> those interfaces were essentially just noops because of the vCPU state
> being encrypted and stored separately in the VMSA. Now those VMMs will
> get an -EINVAL and generally crash.
> 
> Newer VMMs that are aware of KVM_SEV_INIT2 however are already aware of
> the stricter limitations of what vCPU state can be sync'd during
> guest run-time, so newer QEMU for instance will work both for legacy
> KVM_SEV_ES_INIT interface as well as KVM_SEV_INIT2.
> 
> So when using KVM_SEV_INIT2 it's okay to assume userspace can deal with
> -EINVAL, whereas for legacy KVM_SEV_ES_INIT the kernel might be dealing
> with either an older VMM and so it needs to assume that returning
> -EINVAL might break the VMM.
> 
> Address this by only returning -EINVAL if the guest was started with
> KVM_SEV_INIT2. Otherwise, just silently return.
> 
> Cc: Ravi Bangoria <ravi.bangoria@amd.com>
> Cc: Nikunj A Dadhania <nikunj@amd.com>
> Reported-by: Srikanth Aithal <sraithal@amd.com>
> Closes: https://lore.kernel.org/lkml/37usuu4yu4ok7be2hqexhmcyopluuiqj3k266z4gajc2rcj4yo@eujb23qc3zcm/
> Fixes: 27bd5fdc24c0 ("KVM: SEV-ES: Prevent MSR access post VMSA encryption")
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Thanks for the fix.

Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>

