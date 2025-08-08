Return-Path: <kvm+bounces-54333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E4C9B1EE35
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 20:07:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A02877B0B69
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 18:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B82226D1D;
	Fri,  8 Aug 2025 18:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WkU975I1"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263151F2361;
	Fri,  8 Aug 2025 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754676434; cv=fail; b=Qh08HM68N2NbrmK2TSMWeN2EvOQjxjl4K5ssXbPhmt7cXyCQUdV64YKdhX7aL7LlhSXDCrDvD1KDYk/Hx/4G4CmxF26NL4UoHKe2ACiqIb6I2uCrrzNRDAATA96ujIxNdsT89PqcJu5GGD2C2fDLBPS4i2SJJaHQZZTiZIJ9Sm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754676434; c=relaxed/simple;
	bh=7BUIcbvFdTLKfSb57KSHbxQSBF0qAk/Mge6T/I1MNdY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sdv2WJqM5bd1yoOxgJPelF8iaG2CnoXJkCulwQFy9xlTGl3AgROAmr+GMq+68GvcLgoG3fhfcagniW+OGxmNDFD8sfd2z9V/8904t7pb2OEw+bw9xTVLUKc9/9fHNbA1gLa+PBQtG/oqWHPflQmXs+7GC9mlQdArN086j4QZLrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WkU975I1; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wi9Qn3ygtEcHqzy8dzwxnVdpcgCZZf2jIriOsvSlJi5IJgWPaIlpYUINroz0G+wF8QzMIx08h6P0O5/OcP1Xb9BJWWyZRx7SgXCZ/4xjZFw5aO90WViV1hkE+gpC+R2BizrisuDKavb8DQn6IAiIRu2uqkvla5JmBSDl7Pp9xQ70ppaMsj2M6x2poVqoFp53D53FxdLc9+JN3oKYd7DBg+D1fAAjHiRW2KYz0V5OqgR8FoyKEb17GqeQE4XmlF3T2kd50VkRmeabhU2r6HnbiJrNpx5gwKTBtm0d2WDcbTw137zW43JvAlA4GVDtNLDhCGdizYye26iX+CxCk8spkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8cSirXfs2woaeS3jni5U6DJiA7ibfCKsQUNkGPbEunk=;
 b=nLiJUQ8VxjtuV6T2FA08djp6A+6AKeprmGAHnNw5b+3Ke6GSai5y8+/UpdwDgY+aJZxfr2i+G4ZHW7SUd8WWgJKmS1UasCnNoXjRu3XxDBsigUT8OMVYl4r1vrea5kkIcvFaTWI06vbx3P4cv/j/Y0mOGH7WVK75H1BMSEW+WQOGh8T2fRmlO/IB/r+YOFAfY3+LtIwpeXBEAbW55jSSQPgDGpscI5uoMPWol9/BBfDz7lUs3ZecOPOf0799nYDAxWuusHPUkt7A9ejW4nM/5tpcTfkzuTRkB5GAlc4UEchozT4DpfZ25m5/9uiy8JATLO6HtS1hnpwXvNknZTSBLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cSirXfs2woaeS3jni5U6DJiA7ibfCKsQUNkGPbEunk=;
 b=WkU975I1hjsFRo34fjEAv1+6LKKy7qVjY8jfsdFujG76Nh7XYfZesKcDJvYVgvSh2sg9a5gNvY09qMwxu/tmDZxFdg9OsiHLaUm9kRGDK8Pa5Hd+5B9V70C6gbZTkkGpwX0aa5beQstKNAzpNK6kt3BhdRjGAD9qXZzwm72ZTWU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS7PR12MB5838.namprd12.prod.outlook.com (2603:10b6:8:79::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 18:07:10 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%6]) with mapi id 15.20.9009.017; Fri, 8 Aug 2025
 18:07:10 +0000
Message-ID: <5425721a-b33f-4309-abae-a1687ad55f41@amd.com>
Date: Fri, 8 Aug 2025 13:07:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/boot: Move boot_*msr helpers to asm/shared/msr.h
To: John Allen <john.allen@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org, seanjc@google.com,
 pbonzini@redhat.com, dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com, mlevitsk@redhat.com, weijiang.yang@intel.com,
 chao.gao@intel.com, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
References: <20250806204659.59099-1-john.allen@amd.com>
 <20250806204659.59099-2-john.allen@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <20250806204659.59099-2-john.allen@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR07CA0022.namprd07.prod.outlook.com
 (2603:10b6:5:3af::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS7PR12MB5838:EE_
X-MS-Office365-Filtering-Correlation-Id: 221d3033-df75-4001-1914-08ddd6a6648e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WDBaSHRyK201RDAzaE1rNU5vdTQ4eG05azFPWHM0ZjE5WlpRSmJsWUpNOXps?=
 =?utf-8?B?RkRpVjFqVTJacVd1RTFDSHBBNjhlc0hIVUQvNGorSVFQSmhSQ3JLLzY2SnBy?=
 =?utf-8?B?bDhxOHNKd3dnUlJsbGZCYVM0UVZsa3R1OHVvcEV1cG1uWHRHbFVia1BmSlF2?=
 =?utf-8?B?MWpRM014eEhvY0NIaU1LWU5NVVE3Y3NxVjZWWGcxcmU2aTUwME9Gd3RhWDhr?=
 =?utf-8?B?YllWUCthMDBSdDRvaEd5RVFQYlVZVWJ0azd3djJQOHI4TXhwWi9lRVkwMXhO?=
 =?utf-8?B?VnBpNHVUQ0hwZUYyTXpqMkI5QzhkWUhjQTljSDVHTVRMa1lDMVhaTzRNa3RY?=
 =?utf-8?B?eVNGVE1JaHV6cUZZa042L0pUOUY0WHFBQ2IzbjNuVDBVc205MTZyNnZMd3Ba?=
 =?utf-8?B?MHF6SDRvSHZsTGorNEpHcW9pTlpGSWlpMnNoRjZKdEltWUMrVjNMNGgybExW?=
 =?utf-8?B?bDVUMWk3SGlxUCtzd2pZb2U0dXgwK3JWc3ZPMEJTU2dkTTlLaXkzMnZiNFhO?=
 =?utf-8?B?YVZZMzVVczkySlB2dzVPWWQ0bW8wZmpyckVMWURDOTFTN3h3Q0ErVWl3eUxS?=
 =?utf-8?B?RkJKRC82WFZ0RG8xY2VPVEprV1FXSmhja2RTSjh3Q3RlcEl3cFBHekpWK3FJ?=
 =?utf-8?B?OHh0cldlV0dZSW4yM1pEQUdJTFNxTHJLOGx3azIyeXlrODBhblpNc1VrUWl2?=
 =?utf-8?B?WGpMb3J5RkFBQTFuTXh0VHhXWGNJZ1FVOTRvQzFlSi8ybWp5TXV6ZG0wbEJV?=
 =?utf-8?B?V0w5aFQyRzBTdnhTZm5WL0pDUU83Y1BzTkxLZFIzWDI4ZDZiL2R0Nk4wWlRz?=
 =?utf-8?B?SmltRkhydW5vcWYwVUhBdkVQdURralJ4ek1kekZ4LzlYYitoNCs1M3l3RDEw?=
 =?utf-8?B?SXZwOG1sdk5jUDVJOGptNWlMMlR1WXNJKzlxanFXQVk5dnhIdEE5NFdDcGt6?=
 =?utf-8?B?SzNrelFWNHRrM21MM2t2UFNRV1lVTEtBd3ErZkE4djV5aUd6NWFjWEk1VUJZ?=
 =?utf-8?B?dWQybWRvRUg3d2svRVQzYTMrUkV3SytjaTdnNnYrek85ekVGSUpOMmMyNFU1?=
 =?utf-8?B?TlpGeWh5Znh6cGtXVSthdFY3dGxSeDIrRWs5SFBFQXZQbExLQmV6d2hweHM2?=
 =?utf-8?B?ejhnblBqSkpoZjZJQml3MjE4RmRQOTl5MEFSTG1oYlpwNkNQcEVpYmZNb3F3?=
 =?utf-8?B?RlUvTGJtOXJTOVI1WEI5eVIyTmx2L1R1cStJNWdHZWVFQ2t2MEpJTHVPQlRR?=
 =?utf-8?B?djFua1U5ZkFpKzVuZDF2dlZYb3NCZko0Q1BYTWdqdlVTMGMvNk9jNUdURFJp?=
 =?utf-8?B?VG02WHo0VWZRdVI1c2VEa2dxYWh5aVZZTXAyd0dHVm9sMXc4U2tMSTBNbjgx?=
 =?utf-8?B?M3FJMEtqWjR1UWErMFU5eEpHOUx4N0ExbkUwTlRiZkM4eHl3TnlvWHVIWTVQ?=
 =?utf-8?B?V3djM2UzbEtMeENSTldIQ1ltRlc2T2pObEVWdmxneVJzNHp0QUxkbkJBYVpn?=
 =?utf-8?B?VTRLRVIvckZ2WjhCRGtzSXNSZDh1SFJBQm9yR1d4Z0hRQmNlcXRYd3hhd2VF?=
 =?utf-8?B?US9TSS9tV2twTm5WT2NaL0dmdFFDVytSMHljNjd0ajZCL2d3K2g2R3c2S09x?=
 =?utf-8?B?R0ZUMXVHb28zUUR3cm94ZW5kaU9OY3ZnWFlCMStocDFsUXg5SjNzSkhRV2Zn?=
 =?utf-8?B?ZHVxMHVLN2pRRyt6TnYrd2JEN0dWUWFoSGlldXhTQldBSWpCMjVNVFE5SVVU?=
 =?utf-8?B?bHlSVTlXYTNPTW5YdEc0SXZ5S2NaRW1XOUxUU2Vna2lHQ2xxSC9JaE9tL1BG?=
 =?utf-8?B?aTZhQTdseGtoZTZOVm1tUDBQTFNoY2lzWFp2ZEJIeUtBV2Qvb1I2d3JuWWdD?=
 =?utf-8?B?aHJNOXNoVnlHVy96V0xzN0ZQeVd1T1kxblFUU3pYZUluNlE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGRuYWw4N0Fzdk1HaE9uVWVmcmRCeHQyMmJNUzkva1VYaWF2Z0pHb25GQjI5?=
 =?utf-8?B?RWJOSktnTVVmR1l5VHVVRXhyZVRkeGhMYzE4OTV1REVMK3U0ejk5dkQ1WTA1?=
 =?utf-8?B?REZmUzJuV2ZFbXRNRklNa2RCSTlkVFVJZkNKczNXTmdRUXNKTDdWQkVEcmRn?=
 =?utf-8?B?WTNSMkp3VjQyZ3pMRFloQUx2RWhNUGtPT2UydXc5dndGeGdjeEp0NklTYjZU?=
 =?utf-8?B?Uk1jMXB5R0xyS0hzZkpXbFJGSnpUb3NpbitZY0srQzhBSEVoWUtQTnRSblpU?=
 =?utf-8?B?bDVlKzZ4STRsMzNtUXpQSE5qZG9yaS9SMHFrSVJhK0ZKVDExOVpicDVlRU1H?=
 =?utf-8?B?WkdlRVhubkJuelJScEJhQXJLVTVlRllFaVQ1M2lsUzkzVDFHTXJHK1hNVVc5?=
 =?utf-8?B?V3o5ODVTalZJbjgrS0tMQjdpT1UvVW9zYWNIcXVoVTVBZ1BycFg1MjZnVHJp?=
 =?utf-8?B?UkREN2QySEFVWDc4ZVZhNUFvOEJMUDVyMzA5aWp0Ym0raFhkNmluQmhjdDlq?=
 =?utf-8?B?cDBLY1FWRGdPZGxUWTdTRlhqWlY4NUpTa0ZadkFoM0VEZGV1WUdoWFAwc2w5?=
 =?utf-8?B?ZGxkS0hTY0dtZjRUd0orMEFUZE9zdmFOd1RRSFpDT2NhdnBxSW94L0YybzZG?=
 =?utf-8?B?djR4dCtVUi96djdiM0tvUzNGcElUTDlvS2gwN2tBcnRsaFoxRndmdUhUKzdB?=
 =?utf-8?B?ZjJleWtMbDNYNHZhckh1SzVoUGZQZnM0eThjNytKbXNUelo2Y0NJM0k0aGh6?=
 =?utf-8?B?WGkwK1NEWmxiNmEvMXVZWDVFVDhYc3UyUWlpZFdLdWd4akpML0s0UlU5Vmpw?=
 =?utf-8?B?LzNvV09sYis4NldxYzZvdE9LdU1sY3VQY0l6UCthSWJLMzdnUXhlTEhjQitk?=
 =?utf-8?B?YkljVURNRmdoNWdMQXg4QmZzWFV1V2lBT1dadXZiemxtVnY5WjlvS2s0YURK?=
 =?utf-8?B?c3R1WHFqaTltZFF0Ty8wek10TjlpNmhzVE9wMjQ0NlZrdzFYSklsUittNFhD?=
 =?utf-8?B?TjlwTUFYaDgrb0JWZmdDMVkybm5aL2hmRnlOdkhNL3U0R0IxQVVZZkdYRkli?=
 =?utf-8?B?UGhXK2dzRlQxdXA1Ry9vNUNleXc0SVYrbXB3U0lFaXRpTklLcTY3TU1Ncm4y?=
 =?utf-8?B?UGtlTk02ZW53ckxqY1FVUFM5SUJ6eHNicm5Ja3I5Ujk2QXVaZU5RbW1GRy84?=
 =?utf-8?B?LzBncmhLbDdSRHRENVExdUlqM0g3aTJkMUwxTkx4ZHhlWFR5U3M0VlB4SDBz?=
 =?utf-8?B?SndSd2FHdi9EOEhQZFlmMkcxUjN0aDBYZUJrWWpIWVNybGIvbnRwTTBpSXpm?=
 =?utf-8?B?Wk5DbGVOWjVJUnJ4TE4zZW44aDBZNEEwRGxIOUE4S2FxZXV0emJGK1NnWVho?=
 =?utf-8?B?cG1IbDVudGFKV0pOV3JMWERUdjBBUnV6RkY0U3VPb2R0SVVUYU9LOGRxcGlM?=
 =?utf-8?B?Ry94djJibytac3BtcHJtUlhTYk44YW4rTE13Ykg1akZCVWI3eWwrRnVlMWQy?=
 =?utf-8?B?UGE2OUREUW56V0Y0aDJqOWpLdjZhVW80U3laS2xCQlg1TW9nMWFhWk41OHlN?=
 =?utf-8?B?cVRaZ01nSmJheDBEUE9aeklGT2I5QVNsOUhNcExtNXphY2YyM0k0UGJ5UkM4?=
 =?utf-8?B?M0dhc3FVUXNLc3NJMnlWQTF5Z1dNWUpReXdTaXkyT3FTSGhNWmtKMnJXSFJH?=
 =?utf-8?B?aFJWOGhjNjNwM3E0Y2tLU0ZNREorUktRUjZ4eWl1R1VPelBNU0kwTG11aHll?=
 =?utf-8?B?azFOdHRSM2Y5U2N2Sis3R3Z0UFZxOUZUamxreVhvT2pCOEZycjhDSjV6Q2hu?=
 =?utf-8?B?MGQwMlBoL1ZCc21mRFg1Mm9RUzB6RllFTGhsZ05rTXZ3OTJGTkRpTGswdFVN?=
 =?utf-8?B?MHA4OHlLQ0ZNR21BSUtrZmJKY2xXSS94dEZZS1ZHejF4ajk4ZnRuY3gzWWVD?=
 =?utf-8?B?cVJXak9WN2l5djE1NzRqaFdyNTBJUGpEanIxTnBkQUNPRENkZFFoYkR3eDFF?=
 =?utf-8?B?eStNbDlCNjRCK3p2VkVPQ1JXZmVWQldDWUFaOWlzMVBGczNtRFphYnh6TFRq?=
 =?utf-8?B?M1JUSE1FYm1qTElMcGJOUk1JMnFLUWhhVG95eUZ3OUNUZW9BUU01ampJejMy?=
 =?utf-8?Q?YVDrT72bdb1C/OHMAnb4vM//N?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 221d3033-df75-4001-1914-08ddd6a6648e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 18:07:09.9462
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 31YbQDvQqH0YgiR1RU/KRwK/J5nOp3b5S1qJ9ziyBxFcGGsFMlkC6A8icfJXBU1svTa352Mm99YjtRLWN8BHgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5838

On 8/6/25 15:46, John Allen wrote:
> The boot_rdmsr and boot_wrmsr helpers used to reduce the need for inline
> assembly in the boot kernel can also be useful in code shared by boot
> and run-time kernel code. Move these helpers to asm/shared/msr.h and
> rename to raw_rdmsr and raw_wrmsr to indicate that these may also be
> used outside of the boot kernel.
> 
> Signed-off-by: John Allen <john.allen@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/boot/compressed/sev.c    |  7 ++++---
>  arch/x86/boot/compressed/sev.h    |  6 +++---
>  arch/x86/boot/cpucheck.c          | 16 ++++++++--------
>  arch/x86/boot/msr.h               | 26 --------------------------
>  arch/x86/include/asm/shared/msr.h | 15 +++++++++++++++
>  5 files changed, 30 insertions(+), 40 deletions(-)
>  delete mode 100644 arch/x86/boot/msr.h
> 

