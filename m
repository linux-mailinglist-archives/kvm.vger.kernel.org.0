Return-Path: <kvm+bounces-25377-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7876E9649A6
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:17:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 640A5B2356D
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:16:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D134E1B14FA;
	Thu, 29 Aug 2024 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xPA9/t56"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2082.outbound.protection.outlook.com [40.107.96.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7335A168DA;
	Thu, 29 Aug 2024 15:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724944608; cv=fail; b=cIM33sFGtF6So3arYc6N1H7Cd3jHa2YA9MpA6H4F1BhxIuyJhLF2RXGGM9hZIGGaZxLj1m9VulFec7uDFu+ky2j6ocsTVvabYW5EXk85FtOeiBdcxKC/3G/scCLLcvueJ2thciUS3XJoSnALYaKep8Ho05TzTNLOJy/YggWXEtA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724944608; c=relaxed/simple;
	bh=CI3XEru7I+KJuu+UapTD2ibXTpda+K1iztMkUBNgSGk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OOZ9Pi5LvuglwtB6PXX2bbw4EtdLZW/7ptBu7lulpLvYTjBVUuIJa2dBCev90pGBt0cVP/tP+S9rZWou39nSHuIJccl+0d+LJW1scbdPp3rMQqjqckvhap2UiOEtJDCcK5Omc2EuLIGajddQth03ow3CsD3IHwFDEPF3WsJOhWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xPA9/t56; arc=fail smtp.client-ip=40.107.96.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tu41ul7WNVsxT2tQv7Q7f28Qchn/UAQYnShYspVoHsGlKsJR5qhV9j5eCe6y6XTvWiZFGUSbLfkO8CqR4Qa5Gm6055VzZIn3LqEWfLDN8LnjVkl8ynFt/DyHXHEVlq5cwKX2PHlk9jXvtwwAIiXPu7T+pEp/Z0G+g+w5L0klwhliw/i/MIAwfKcbjsQh4527Ok7+Rn07IuL3KQEbV+9twgfiCHW/aEk0rOccoYVUvGhMeGOQQ4rUnm/VQaOrNqq6lbiXZ4cu9EGtQOEKVcKhAU/lCpJ85rASOWGyieur72llOzTo+hwywCDYBXYXUaMXuCbSn0o8tWjtgyC73vhKjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ZvNG/BZ+zeiD5haLF9S8XOv+CL8bj8GavR1fkolK9Q=;
 b=VHZOjZecnJcPhWmMIT+6B26oIOV360GHb8wo7FXh+n6GK461bECqRq8ZQyf85m9mM8n/dj0kz79mkqYgNjbvZ0pjF4zBNxs8YSttIY9KyaSQo4sRFNnPLV8PNYoq5uZRvrjwOFypQraYNor5QtZu/i3LiAtSkivxQaGGWkGlTZpQGrGV9BCqjjlCw03dUTJg17vJ/VDJrebkbnKfZmMEv9s5zIeF/JhGSM77HNfL1aQ3Me6p1g1STkCTPjfrLyyN1CMyplSNSB0VjxCHnNzXZWpXGskSWUMVKIfCpCeboMv4gNw3le99gAwUk+MmJD0OAZAHFyHWbXA/j9HemA1RAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ZvNG/BZ+zeiD5haLF9S8XOv+CL8bj8GavR1fkolK9Q=;
 b=xPA9/t56tg48EnVidqj7u0aVKNabSJ+4FeRnxvu4qRvflqMce1NL/1FtY6cvZX0FOXfcu72Ah1dlt/aJE+yvbsqtks9dq4Bo2wpsCuKwjPRr8p06lXIZXSyGUmIwWHSqxJOU7ezPggZIDP/HZCHDVR0nJnu6osx2VmoJCGhPtZY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by LV8PR12MB9408.namprd12.prod.outlook.com (2603:10b6:408:208::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Thu, 29 Aug
 2024 15:16:43 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%6]) with mapi id 15.20.7897.021; Thu, 29 Aug 2024
 15:16:43 +0000
Message-ID: <155cb321-a169-4a56-b0ac-940676c1e9ee@amd.com>
Date: Thu, 29 Aug 2024 10:16:39 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/sev: Fix host kdump support for SNP
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>
Cc: pbonzini@redhat.com, dave.hansen@linux.intel.com, tglx@linutronix.de,
 mingo@redhat.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, thomas.lendacky@amd.com,
 michael.roth@amd.com, kexec@lists.infradead.org, linux-coco@lists.linux.dev
References: <20240827203804.4989-1-Ashish.Kalra@amd.com>
 <87475131-856C-44DC-A27A-84648294F094@alien8.de>
 <ZtCKqD_gc6wnqu-P@google.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <ZtCKqD_gc6wnqu-P@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0155.namprd04.prod.outlook.com
 (2603:10b6:806:125::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|LV8PR12MB9408:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dd2d8ee-cc02-473d-68b3-08dcc83d96cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aXJSNFdGWDczMThDd25vbjRjT3FYMlRyclVLeUc3N0xPc3prcU9TbkU1SHk1?=
 =?utf-8?B?VUFSdmNPY0hmRWk4ZmpUSElkNEt1REdQbG5OVkQ3aTB6Y1lReG5jRlM0UVZU?=
 =?utf-8?B?dmduSnUvanJPditVWXNSQ1V4aTdRR3Z4R2xWV2UzNnowMmtTQTFUWTZuTHND?=
 =?utf-8?B?UWkrdXdQaXZIVnA3N281M1ZwdzRsUXdCZGhOQm9tMi9sSW41eHhhb2c1Z3l0?=
 =?utf-8?B?a3hhNXJrWHk2bWlGVCtaYTR4V3hnVlFsbVFEQmNPSGc2aXlDT09Ka1IxczQ0?=
 =?utf-8?B?RHRKQm1oOC9jUWhjamc5a3B4U0ZzRWc1TFZkSDg0VjhMREkwa2MvOFdMb3hQ?=
 =?utf-8?B?UERENTR5MmxqUjRtYTdmdE5kMk5hU3ZLc1VWdmxhS01qT3dOalJOaE53ZytK?=
 =?utf-8?B?WCtkRFBsN3ZMckV0UmFpMlo0SldxY0hYZjR5NnhqUVMxeFdxOEhiOVBmeVBy?=
 =?utf-8?B?bFdOOWQ5T3hBQUZmc0JNUG9lUWJWL3lQWEMwK3M5WlBaODAxVzJ1ZkVhQVF6?=
 =?utf-8?B?aE9JMW5BS2d4NE1JaTFnV3RPWVpXSmdGeTVnQlVaZHAvcDR1bXNnbW82NzAx?=
 =?utf-8?B?a3JaQzl6RFl6dFg2dGdGL3NEdHd4cmt1WVFMQmJ1cXhENS85V3d1V3NicUF0?=
 =?utf-8?B?eGlCOWNQeEV2SGdnbFAxV01iT0hBYzhqWDAyRUlLZHE2WkN1OGpUOU14dzFs?=
 =?utf-8?B?V1R2ajVmZGk5OTU3Wld0YzBsNEZNOU9DeTJ3TUZYSlFXbWN5QUttTklyNWVR?=
 =?utf-8?B?bDZmd2hSS1BjMjRQMDhySlJnQzM0ZC9xNEFSbEV3S3UrSVU2M2k0SXA3UEZ0?=
 =?utf-8?B?V1grbmNJWFpxaWliNUszLzlXemp4NGdRNnN3VlZTdGhRTCs5TmxEank5N1Yw?=
 =?utf-8?B?bkx0MDZ0SEwwbzdkOEJ5bWVVQUg3Zk1GRGdXS2srZXdGVVc0dTVlTWtjQ2gv?=
 =?utf-8?B?WXorUThZVG5mUXZveUVacUhYb09hWDlQQVZ5cWkrcVIwZFZuazc5UzdJZDl4?=
 =?utf-8?B?VGVMRTlRVUsvR1hwRUd1K2liM1VoN2Y3ZEpWeE1pSk5IR2U5L0hZbkZyZjVj?=
 =?utf-8?B?bXFwYTBnblg1TDhKNmR2ZnVzdlNzRXovb3VJQ3AxUXJQTDg2VWQ4UHN6TGNQ?=
 =?utf-8?B?a1JieDRoRitkRlB2NENtWVhGUjJ4a3pKMFVOdTZrUVo3V2VmeFVjcW1SbWhR?=
 =?utf-8?B?clZEZk9ZZWVWQjcybXIzcXdvS1RSZVJCa3lkYjcydHcyZ1cyTGtKd3diNjlD?=
 =?utf-8?B?N3B2TmpZY1k5d2tuRWxNWG1FVXlYQkZFSExDS1Z6KzdJRFJ2anlQSkFTZ2kx?=
 =?utf-8?B?aFdmNG9UK2tXc2tWSytTMmRNY2dlQXZJZ0NWKzJhcUpHR1JPdkszeURMbTV5?=
 =?utf-8?B?L2NEY3MxOGtXakVyNU9BczJFUHRPRlZDdlJKaW9RNmF1YTRjSXJ6K1U1THlO?=
 =?utf-8?B?OG9jTkhYRmVNK0tHaDhIdGd4QXVOeUFwN0FlcWRDN1A3SmxRamMxdkFwRlVX?=
 =?utf-8?B?Z0FmVjlTZnk1aVVheWJvWjM4N2VKQkRTR0t6emdCMWxjSDhEOS93VVdJbUlk?=
 =?utf-8?B?V002MnF1Ym9ZSDkzWW9COWpYSVdoYVQ4VU54Rlgra2FSSEN1Z2tlOU5pa2to?=
 =?utf-8?B?V1ZIY0Y0RStNdWNINXJTajByNzduNU9aZ3ZIdHFWV25vbEpuVEFDRlh6TkRa?=
 =?utf-8?B?U0wyS2JHTEVBYkx1OXpLdk9Sek9maWhCZmM4ZS9xd2xFc0lTRmFwRzM2WGxL?=
 =?utf-8?B?dHVQQllWZjV0MzBpbUpVTVl5SU1FWFNkaExtTmhma0FYdTJzeDNPMEpLeVF4?=
 =?utf-8?B?anRjR1Y4aVVhTFhuU2dydz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YzJOdXNiMUNCb0JxeW1CR0VJZjJLNFVid25USE5HOS9zUlgzSnN2cHZWZldx?=
 =?utf-8?B?MlRISHV6dWVTL2lOQ0pacDNUSENkS1BqeHNybys0N2dPT1hhcmdPbEpNYUI5?=
 =?utf-8?B?c0psbjFiUUlaTWJPT056Y1dGRFZJTEtxblR3R2pjaEdmSEdlYW50SmJGeWkw?=
 =?utf-8?B?MXhOakx0dUVzODlmdjJ1NzF2K3NHRThhbEMrYUU3Ni9iZUNWbm1Xdy8wcy9G?=
 =?utf-8?B?cGFzY1cwTUQvb28xZy8vV1FDSVV1SHdUb2VNaldQSEtjaml2WFl4NithWjZI?=
 =?utf-8?B?UEIzQXJId1UzL1dOa2k5ZkM3Q2pzZ2xrMDFhTzEyNlJQWDJxK0lhemszMlRZ?=
 =?utf-8?B?dEJieGhETzNJVWdLbnFjanVsUGgrRVI1alh1b1J2RlN6YmlMa1NqNHZMWHdz?=
 =?utf-8?B?aUw3c1lyRlNkMGpKaUhjSGFFdU81WUdwL25mTWdQTVZqYkVBSzJVMEwwU2hh?=
 =?utf-8?B?SGIzV0JNR0tSK3JxcXlHelVnZ01iTWNPRmZGNlIvMW43KzM4eFdCZ3BQcTdl?=
 =?utf-8?B?OTE3c0FKNU54dWwwNVdKaTZ3M1ZHcldyZWlzR0dOaHFIUXAwNDZBUlMxV01q?=
 =?utf-8?B?ejZWa1kvYS80N08rc0VqMkVLMy9uUEZxbzJwR05zWEJTWUtuUzhnZStRdmpl?=
 =?utf-8?B?TzlYNVJ2MnZqdGh5R2J4MitYampFUWFBTDRwR1ZKSkc5b0tJSDJzSmJ0alpB?=
 =?utf-8?B?MVRYR2g4RVpobTJ5SWxZRElvWXI4Zi9vOUVZL0dVL0MrbG1lS2hnV2dpdTlV?=
 =?utf-8?B?RnV5WFZWekNEODNUZFRlNTlpMWRFQUVGSXhNUks1czNxcTY1bkREQXBlK1Jj?=
 =?utf-8?B?ZzJCTE4xK09aR01SRzZ5TGYrQkZTdFBwS0JKVDNNWUQrSy8vcE50T1pldjF1?=
 =?utf-8?B?djh4TUVJeFI1cXYzOVQrcjFPbjJrbVVRbVZWeG1BSTlXRHdxV2dsYVZSbytG?=
 =?utf-8?B?OGNYb1VsMmVhZEIyNEhPR1EvRjBaYkJKWDlKZTFaK3hMV0tUeWsxYUtSSWcy?=
 =?utf-8?B?cFIyR2ovUmNJeWJwWmZwL3QvR1NhMjR6YWdlNU1OaDdUakpoZWJEd2ZPVzZ5?=
 =?utf-8?B?dDhvUVFsUFNUVmFGVXNOeURmSzVsTkdvckdId0JWVGpVSERlL2tpbG00YXNh?=
 =?utf-8?B?VkRLZkZNQnBRUHRmejgvem5sYWI4OW8zTTA2YXUya0JGelJNSS9uTmxncHJN?=
 =?utf-8?B?VTVaSEcxZlB3TXA2LzZZelYzYVQwczE0b3ZtTURsbmc2ZUNYaXlNcUlIMHd6?=
 =?utf-8?B?RlVxUzlnd3dOemJ2NWxqOURUOFNlbFNzSXhLNzZVWER2YmYzZ0dWM3ViSWFl?=
 =?utf-8?B?MXFCMEJhWmN4ei9hR0pWQ3NMSnRSOU9ZVVVWY1p6RXZkdlk0TEdRcFVxeDYz?=
 =?utf-8?B?aTk2ZDhRM1RNQlNabWF5QXpBRjcwa2hlVWIrZVRZOEszbW1hOEFldEpsaDBB?=
 =?utf-8?B?UWc1WHBXT0FFaUd0V0JERjh4c1UxVmlIQXF1VjRqeTI3d3hGYVJlS0NVRXRB?=
 =?utf-8?B?Y1BtV0FXcy94eDd3NWdkaGRnL1RQdFZWT01VUUEwOVRFMStZNE11TXpwNytT?=
 =?utf-8?B?a3d0SFlObko5dTY0ekRjQXZzbVZMQXJrRGxJaURwZ042QlVlTHRwVkE2L1RR?=
 =?utf-8?B?S0I2cnpnVWNMVlk0ZFRJYlFHaTd1Z1BQcHIrU1NQZ0YveC9wTmlDa0tUNUZx?=
 =?utf-8?B?WVAwRDdWYlV4cnFIQjBPL2pzWVR1UUVZUit6SFJlc0dpbWVHbnZkNVFyTkMx?=
 =?utf-8?B?ckl2Rk5UTllpbzFpak5EQUx3Qjh0aWxhOVIyUDBNeHBjaUVreDBncHRUcVpN?=
 =?utf-8?B?UDhVOCs1ekdObzh5d2dnNVdkV2xhVEtPb05ENzhBSmV6bFdjSTBaQXB4UVc1?=
 =?utf-8?B?dWl5S0l5WWxjaEowekdRYXc5SDAwUnJrWTAvOEc0ZmRxbjVSaEIxdnVpcE9G?=
 =?utf-8?B?UURZOEZZb1hZbXp0M1V4a2UwN2x3VEdTQUxKVjZUeStYdU5zZjhkOFp1YVFJ?=
 =?utf-8?B?QVRXOFk3YlhxMmNhWE1yM09UU2hPVnNEYW9zdFpUL01WS1AvdmlaRytQcmhq?=
 =?utf-8?B?K1ZJVFQyMUUwazFlK3B3ck1mbDVxcGJaK0RHNXN1VXhSdEt1bk9yQ2hYeUVS?=
 =?utf-8?Q?iKfRGh1/739PFVC6CW3j5vZwt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dd2d8ee-cc02-473d-68b3-08dcc83d96cb
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2024 15:16:42.9915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWcNsd1s68bFRkm1ot6AyfLf56OozfyRspM57K/EFwIe5bQqGJF50NW8fMe70hZPAylMkLWIidSRGc9+UqwZCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9408

On 8/29/2024 9:50 AM, Sean Christopherson wrote:

> On Thu, Aug 29, 2024, Borislav Petkov wrote:
>> On August 27, 2024 10:38:04 PM GMT+02:00, Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> With active SNP VMs, SNP_SHUTDOWN_EX invoked during panic notifiers causes
>>> crashkernel boot failure with the following signature:
>> Why would SNP_SHUTDOWN be allowed *at all* if there are active SNP guests and
>> there's potential to lose guest data in the process?!
> Because if the host is panicking, guests are hosed regardless.  Unless I'm
> misreading things, the goal here is to ensure the crashkernel can actually capture
> a kdump.

Yes, that is the main goal here to ensure that crashkernel can boot and capture a kdump on a SNP enabled host regardless of SNP VMs running.

Thanks, Ashish


