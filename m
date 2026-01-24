Return-Path: <kvm+bounces-69039-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SCo3H/PydGlH/QAAu9opvQ
	(envelope-from <kvm+bounces-69039-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 17:27:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F9697E1B7
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 17:27:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5538F3012CE4
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 16:27:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3B2F248F73;
	Sat, 24 Jan 2026 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="visjL2Kq"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010040.outbound.protection.outlook.com [52.101.193.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7412288D5;
	Sat, 24 Jan 2026 16:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769272045; cv=fail; b=lxxj2zneZtsN21id5mzIK4uQv3vXd6buwZ0JEfJ47yyak2Ty66ow/Ph2JDi6FlmMSr4iOGJwgfVDbPe1wkVNey0PMiGuHT215D631h4eU2fLU+oir5H+jnZ3M+Qgul2+0K+1nztxElxGweudAwk6Gimc26bBiJxatjFrAh+bB7M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769272045; c=relaxed/simple;
	bh=M3Z2lrtrySCfzitbqGPheduSSyS6YvFZ5d14iwVShRI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=U5fQA+rWXsV4p9PM6scIeZS8Dp4m3nNAdcQMALMmvQ89K3n9++u8wElo9J2M2bM7n7xlvUt+QZPPNnHYOAGdmVszKHcQeRlwjbggFtp5h/vu/10z1K/Hj3p1kkEN2l+mtY0FT4QaSeQE4enVSQDRk4T9RXtTupFk+LF7TJ4RkWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=visjL2Kq; arc=fail smtp.client-ip=52.101.193.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fr9rneait5HBUTsLDLYQfnGQdSp5AfZC2BqUCgkVSPsgY2vnjT4BYI8FAnfZHlL5Qkb1J5MD2NwX1tB1KeAweAoBSAdI4qcab/Sz6XcGL3hs7YojdsktbL2cu+FdkuI/rEEagFgCdqCVZn628UC6BaEgWRYNAJfWk8fhcgukBAbOuzz27XHFvjxEdVcrftZnBkcV8uPmt0IFpeUInWEEB5B4bzt3B9fYAud0KBkebDw0Y87Gs8AX3e5TTTE/t7zeAihxRur+bd8ykSpjf0V2iLqDbo2NeqZsPS0MpB0h8mj/OHAq4C7arpYToYYkqKbRnk2l/XbCg/mq3Zo3fbe0qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=272f+v/9CKZ052dzfFwMO4n4LyRUntj4A06+o2x/fj4=;
 b=ZzSLtZx6YMMnpSmnagrn/DWrnLSujfELeg7iMcyYk2+D62rTY0yobgFucWXHhcuYe1U7IF2WPRikZfU5kWlXLQcwuJYQ/8AxGuFtSaJPbsYiF51IzyWJd3gwP9lF0nmPKC9lw3sOHhDOKAIyfM4ml2xztC+3gq1VjDERQONzlYNRpMf09AdaPGCprVgF2XYvCW5q58zVF8u5wY+ZBCokNFWWhMTqulrTFvy39RuGbZOiqLYsrtUzXp+YpSV2kJIwrcr5QS9MMhtrMKKSgsJjHB3K69SQBQufJaxkdO6wds7DX3DL4tkuBb9+H7j0i67UP6lGQoU8FmdoJhg9yiuTPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=272f+v/9CKZ052dzfFwMO4n4LyRUntj4A06+o2x/fj4=;
 b=visjL2KqtoDrofbE2Zl/tmxLgXK7S2Qo0DMBQb+5yAvc/zIJKFwPFc6tW/2KL7KQ8FaKIx5FEPuXs5FYcn/tNzZbTgIPdRxDCPuc6+OhIJsKEmQ6WQfAr8Ztg7pcMj5SM/F88pVzunvezWjNceSgWRvuvnyF0/LyLXrvl5MN4Wk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW5PR12MB5681.namprd12.prod.outlook.com (2603:10b6:303:19e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Sat, 24 Jan
 2026 16:27:20 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.010; Sat, 24 Jan 2026
 16:27:19 +0000
Message-ID: <2882b35a-89ac-4f91-abf3-a3b64e7770eb@amd.com>
Date: Sat, 24 Jan 2026 10:27:17 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@thorondor.fr>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20251215141417.2821412-1-thomas.courrege@vates.tech>
 <254d7d53-b523-452d-8c6f-d611ab08a9ff@amd.com>
 <879f354c-822f-4902-8cc3-6cf9557db969@thorondor.fr>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <879f354c-822f-4902-8cc3-6cf9557db969@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0170.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::25) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW5PR12MB5681:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7306a4-d5a4-4bac-affd-08de5b6571c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zm1PL0JQL3VFdXhkdFhrV1JmbWFSSEE5RTQvdTMvZ0RZYk9UZXJmRmVIZEw3?=
 =?utf-8?B?b3I0TnlFZGREZko2R3FnU2VUd0lBN3RCQ0xIR3l6V2pRb2QwKzNuTURvQTZi?=
 =?utf-8?B?QjgrTnc1RWk0dzJoNThlMTZaNzN5N0d6WWZTMGNVYTdpS1BYQVVHZnNjZ3JQ?=
 =?utf-8?B?VGxNR0g3Y0ZwTVJXamFtMFZLUWhqWkRPSGM2b1JQRC9jSGN3WmhLa1dmOVBq?=
 =?utf-8?B?VnNmZXVtS094OU0vTzVWbDI2VFR6bUEzYkQzU3Z5Mm82OWRJVmcyMitkNHZi?=
 =?utf-8?B?eVFsOFg4V3NtN2YyUUhvOUdzQWw2RDZKTGluejY5ZVVYQ0h5SlJtcHFqQVFJ?=
 =?utf-8?B?dmV6dm4wMjcvSjBVN21QeDRDaTZNTHJTeTN4RXJrcitRSFFhV3hOWUVtclpa?=
 =?utf-8?B?Zlp2aEtweG1iYUxrajJ3YXkxRmJsdndoYXFPUnUzTlptaWxjb01oQmh5eEFq?=
 =?utf-8?B?bGhQL0g5R2hOcG96MWdXRUdSVnp4SlVabFhJOG51SjU1VWRYVzB3a3N6YWN6?=
 =?utf-8?B?dENUVFJsNmlVanBVSHVWUUJsbjEySTdvcnoxeFhrRmVhZHFQb3hqamk0TElz?=
 =?utf-8?B?WTZNS2Q1L2V2TFRUbDUyNE1zaDg2cHBFSzhFVjZobG1CMHdYelRwWXJjQVdJ?=
 =?utf-8?B?akRWaDlSSlJ1WnRmc0NQaUpxQ3RTMkdKU0RxSmlBaTZKSyt0bmF6c3hWd00v?=
 =?utf-8?B?bWJaMUQ2eTNsL0NBaThoTXF3dXl1K21XYjBHUGlLWS9rS2Z2OFhna1BKOFhj?=
 =?utf-8?B?ZzY3MG9HTUIwa0x2TUJiZVhuMlU5eDZYb3BzaWhNUDJyV1NsWG03bk1sNGQ1?=
 =?utf-8?B?d1gxNXNVMlgwcFkyczhmTDNDWE1VTlNyZUpxdTNRZW5qQ0RENVNWcW5pVHlS?=
 =?utf-8?B?RExGY0NQSWdWZ1ByS0pNU1VEdktuT1NrSmowNE5LR0NoZ2UraUJHQWZuTjFK?=
 =?utf-8?B?RjUzbC94SWRiMDBtWHJFNHBCNDUxTStOWnZ6NzZkK21ZRzBtdnA0QXBWUFQ0?=
 =?utf-8?B?YnBzSkw4Q3locnJhUktNRTN6Mmd4TDFpYlExK1pZY2xYK2I2eGhuTVJ5TE92?=
 =?utf-8?B?eFlvUXdudHVGbEIzQWg4aDBuRDY5Mm82djBmUTlIODNDcmhIWEgzZHcrYUli?=
 =?utf-8?B?dDc3VjlxNEh1VXM1VXd5UFFvL3UyVEJjbGFRVk4xeUxOVXN0bSsxMUtFekVw?=
 =?utf-8?B?ODB0OGZFdkxEbzEwUVFNSmw3NDM3WWN0V0pBUm1ESm1jblpnbFArRXlYRlUv?=
 =?utf-8?B?U05xTE1KeXZIcVZWTWFiSi81ZXZBYThpYnV0YkZydDVFcjFuTUlyN2hhdHBL?=
 =?utf-8?B?b3duWEMwTDFUUHlvb0dMV3pVY1Z3eGsvZGJZR1lhQllUZ0t2K3VOck0zMXN5?=
 =?utf-8?B?VXVQdlBTc1ZsaXk0VGRHQTdZWFVvVm5FdEVVT0VFMXB2TVgxMDZ6K00wVms5?=
 =?utf-8?B?VmhoRTMrWE9YRDhiR1RkS3V5RGozV0ZBdE9vMDBkK0tBWUdyeW1uY2YxN1hm?=
 =?utf-8?B?dU8wWmFDZllHOWwwMXhYVWlYcTV4YmhQaVBuaThHd1hvUEJlaloyZWtFMzl3?=
 =?utf-8?B?ZUtKeFFaNlRyYnZHK1AzRFpxbTArRDVHeWQvNzdOalVGVkVZL2FpWHkrTUdi?=
 =?utf-8?B?UlNvQVpBSU1SUnZMOGFGdHpGMFdpYjd2Q3d2cmtYTHpUWWlUcjRNQkc0VGxr?=
 =?utf-8?B?MEs1UmJiVFQ1eThTa0g5M3UxczM2amlOZ2Y5SFdhOTFOYTV4U3VrbDZIRkhk?=
 =?utf-8?B?S2lldm5oQW1tK3IrOWtrUElWSmRVVld1dng0V3lqbnVVa20vVEVZRkNMdkRp?=
 =?utf-8?B?MlB2c3R1NHB2TzBVWmJRZEVtb1dYNHdJQ3FtS3ZvNGlTaEtZZWlWVUQxYm1U?=
 =?utf-8?B?MlF0Yk9SZ0dMaVQvSFpIWng5U09oNlUyc29OaEI0TGt6cWxwOEFLQXdtcjd0?=
 =?utf-8?B?TzlrNTB1N3BVUWlpOTYvbFU4S0EzbFFkY1lXeFM5ZVoybTlzb1l0dVdJNTd2?=
 =?utf-8?B?NmlPdVdXeWJyVXlEcnNKcjAwNnF5cUtnaUYwYmN0NThiaHpOZ0R4enYxSk9k?=
 =?utf-8?B?MzhEblY4bUZFRzliSTFGUUkrN3p6WDduNVhVaTkySEM4cjlUcDFHbWNVRERU?=
 =?utf-8?Q?8sD/cjrRDjAokWuo0d2rpBK3V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bElscG5PS21YMWxzcTBwdjBkaGdwbnZkRGJ5eksxQWF1c1MxQzVUenFidUgy?=
 =?utf-8?B?Ry9jSFR6OXVSeS8vK2RDQTFKUHNUR01WazRYaUdnNmFXYWRxM2FCeWdVTTNY?=
 =?utf-8?B?ci84SmhlSG5LYmd0NnlCTXgvRVhEb05OVGk0Mllpdkl0WUsxME5XWTNyeWJu?=
 =?utf-8?B?ZnBiRmdkS2ExS0xEMWVGK1VkckI3NEFtUkdpMGVSbFB6K0MvRkR2ZGYwRDN1?=
 =?utf-8?B?VXJzY0pUY0dBbXB1YnJnL0xkVHpLcVpZaVd4UnZpMVpLQXgreHgxNmhCUVRm?=
 =?utf-8?B?alhQcEFmOTlIUUhFOSt3MTJuVXdZLzdEZXdsUUVEYlcwSVd4aStNdkFsbUp1?=
 =?utf-8?B?cUZJOWxwNzZHTXJ3b3dwOVdJMWRzUlZHeTFCNW5CMnhMaEFwb1dKdVRabWpu?=
 =?utf-8?B?TERyelZRblZpZ1lZZm9GUTZSWXFwckdUeWhQa0xBckgzc3dOd20rVFRiWk82?=
 =?utf-8?B?aTRBTDdJOHFDaTgydDhxcTFkMCtTTXdvSGRSZCtnTml1UW9HUEtFZVU5LzZs?=
 =?utf-8?B?dURsS3NTdmswZU9wM3dPRzFEb0pRQVNtMHpOTTJuN1RuK0syY0h5bDRrcysw?=
 =?utf-8?B?ZWJyeXhpNFQ0cTYvdFFMOFpJSC9GUDRRMS9UclZSRGxxbHR2R3ZEaE1ZS2dv?=
 =?utf-8?B?T2dOM2NjU0xnNlUrT1o3NVBoa3ovSC84d2hRenhpSkRGVXZ6R2IwU3JXNlJL?=
 =?utf-8?B?Tmt1YjlaMnNsVXJKQ2hXbjNSVjVQNEFmTmxzekpDZkNCY1cxYUNRYVVaNFk3?=
 =?utf-8?B?T3A3dHRJbDRnMHpnU2hvWFhPRlJLcXJQaHVqRXlycWlVbTdDRUtpYS9CUWRx?=
 =?utf-8?B?eDd3Zk05Zm9ucitOUmRveFlqczh5V1RrQWZlanM3cVh6ckNuY3Y2c0NVeUkz?=
 =?utf-8?B?U1ZNckFIci85QldScW5XeGRJL2F3Ny8ra3pJaUZrYnZZY3J3ZExFV245TFZy?=
 =?utf-8?B?dm5uWkxTTnlMaGkyRGVuMTd1ZXRacXliRjlZa3ZwRlFFdzQrd0YzVFAzeHJ0?=
 =?utf-8?B?MHI2L1d3RWVrNWorNm1YUk9tN21jRHF5N1VyOFA5UFB6bTBkK2xUb1gzNTlT?=
 =?utf-8?B?bUN0Qk9FMG5TQ0NQNWZKbU1QSWRaanhVSlBzQXc4clBlSWdwSjFHOGlvOU1v?=
 =?utf-8?B?djNyWmUwNTNPMFNvMWVTcWlFMk1HQnBiNUN1ZXNiRVIvU2ZYNEtxcDU4U3pB?=
 =?utf-8?B?ZklhK0RFekRkMHVEUm4vNmFySkptWkhPbldrS3E3OHVuekhtbTkxbDdjVUZt?=
 =?utf-8?B?QnFsTmF2Rk1hVmxKeTJFWjlodFhFNThtOTcvcklWWFdJQzNXOXdIUThCWTJQ?=
 =?utf-8?B?dSttVjExSnVzVTlpL0w2dit4OWlBcmhIc2ZFQWFLMENUZ2YyeEVzdjZRQ3Nt?=
 =?utf-8?B?cytHRDc1ZENHL3FIY0NaRWUrTklvUzg3d0xNTGl1eUZSV0JlVTVEMWl4K1lW?=
 =?utf-8?B?azFSUDZaZ2hMcnc4NDltU2x2RkhlT25MVlhGSE10R2FpMmpwNmtlQ29Fb0Jr?=
 =?utf-8?B?RXZxVWc5NStpblE5TkxmdUV6L3RsYjluSUcxSW4vTzhDQk4wRVhvR0hrcGFN?=
 =?utf-8?B?aUxtemMrNTlENFkzYi8xdy9uakllYlNiUEVkSStxSjQ5OTZvVGg5b2s2MjRu?=
 =?utf-8?B?UEViZDg4T0E1eFFxWW5QcVdhWXgxNmpmSTdaTWpZREFYOVJWMHIyd3VqR012?=
 =?utf-8?B?UUI1cTI5SCt3NGN0OXVtUU9tcmpsaUtJRldoczBPTGM2SG9mMVd4aEhERkFY?=
 =?utf-8?B?ZmRFbVBhN1BNWEREekhBMjdmOHJrMVkxS2ZIYmNlSU1rK2RDOENxTjJvRVh6?=
 =?utf-8?B?dkFid282dTlwYXdnTlVVWG16bnpzaE5iNklINGxlK2YrbmdQNFFlc3VkWlBY?=
 =?utf-8?B?eGlIVmVWanJRVHB6TUFDWFdXckViM2pOYm9FMHNqMkQ0UURMdmc1N3hIY3lX?=
 =?utf-8?B?Y2pnYUN3M0d6Y2E3M00zNW5ONWJlQjF1Q0lVNDVUUDZOK2tSRHNmOTNva1lt?=
 =?utf-8?B?UGJqWlV0VmhDbVMwbU5Ld0JNTHNJeTVkUlZRMkZ2L2RtaUVCeStaQkh4VW15?=
 =?utf-8?B?cTJTSjQrYnBUR1owWDJiVmdlMG9GK0IxT0UrVHFROHBKVjQ1NUV2WnRXMUlD?=
 =?utf-8?B?QnJzMi81N1BkT2dOZmJoQzg3MGFjZ3dTbEFEUSsybTd6d2NYbWJHVG5XUm1y?=
 =?utf-8?B?Z25mQVVkSFI5SGdTVll0ZWlBNTRFSlp5ZjFhUElaMzVhN0pDN2o1QzNMTEh3?=
 =?utf-8?B?TmZKL2tzZHVqZ0t6dGtYLzVPUnlwTzIvaFEvenRabEczcVlJc1hCVkplazhO?=
 =?utf-8?Q?sh2UlM5qKBYWHpAL1J?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7306a4-d5a4-4bac-affd-08de5b6571c8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2026 16:27:19.4148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TI7x0yo0lb38D1XE7fjhr8jZ03T22ifRot95/9wlamOtDCQRG/F/vYVyUhBQpWcjH0xnsEN5+MR+g7+fVuoZ7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5681
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-69039-lists,kvm=lfdr.de];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: 0F9697E1B7
X-Rspamd-Action: no action

On 1/24/26 08:40, Thomas Courrege wrote:
> Sorry, i didn't saw the response, i changed the email i use.
> 
> On 21-01-2026 00:45, Tom Lendacky wrote:
>> On 12/15/25 08:14, Thomas Courrege wrote:
>>
>>> +	size_t rsp_size = sizeof(*report_rsp);
>>> +	int ret;
>> The declarations above should be in reverse fir tree order.
>     
> Like that ?
>     struct sev_data_snp_msg_report_rsp *report_rsp;
>     struct sev_data_snp_hv_report_req data;
>     struct kvm_sev_snp_hv_report_req params;
>     struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
>     size_t rsp_size = sizeof(*report_rsp);
>     void __user *u_report;
>     void __user *u_params;
>     int ret;

	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
	struct sev_data_snp_msg_report_rsp *report_rsp;
	struct kvm_sev_snp_hv_report_req params;
	struct sev_data_snp_hv_report_req data;
	size_t rsp_size = sizeof(*report_rsp);
	void __user *u_report;
	void __user *u_params;
	int ret;

>>> +	if (ret)
>>> +		goto e_free_rsp;
>>> +
>>> +	if (!report_rsp->status)
>>> +		rsp_size += report_rsp->report_size;
>>> +
>>> +	if (params.report_len < rsp_size) {
>>> +		rsp_size = sizeof(*report_rsp);
>>> +		ret = -ENOSPC;
>>> +	}
>> This can be contained within the if above it, right?
>>
>> if (!report_rsp->status) {
>> 	if (params.report_len < (rsp_size + report_rsp->report_size))
>> 		ret = -ENOSPC;
>> 	else
>> 		rsp_size += report_rsp->report_size;
>> }
> 
> This leads to an error in case the user wants to query the report size.
> 
> 
> Using params.report_len = 32, the nested if is true and thus the user get
> 
> back the default rsp_size (= 32), not increased with report_size (= 1184).

But isn't params.report_len set below to the proper value since it wasn't
using rsp_size? The rsp_size variable is only used for the copy_to_user()
for the report itself. Assuming you want to copy what's in 'rsp' no matter
the return code you get, then can't you just do:

if (!report_rsp->status) {
	if (params.report_len < (rsp_size + report_rsp->report_size))
		ret = -ENOSPC;
	else
		rsp_size += report_rsp->report_size;

	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
}

if (copy_to_user(u_report, report_rsp, rsp_size))
	ret = -EFAULT;

Thanks,
Tom

> 
>>> +
>>> +	if (copy_to_user(u_report, report_rsp, rsp_size))
>>> +		ret = -EFAULT;
>>> +
>>> +	params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
>> I'm not sure if we can rely on report_rsp->report_size being valid if
>> resport_rsp->status is not zero. So maybe just set this to rsp_size.
>>
>> Thanks,
>> Tom
> maybe something like this ? to avoid copying on ENOSPC, where this issue come from
> 
>     if (!report_rsp->status)
>         rsp_size += report_rsp->report_size;
> 
>     if (params.report_len < rsp_size) {
>         ret = -ENOSPC;
>     } else {
>         if (copy_to_user(u_report, report_rsp, rsp_size))
>             ret = -EFAULT;
>     }
> 
>     params.report_len = rsp_size;
> 
> 
> To test this specific case : 
>     https://github.com/Th0rOnDoR/test-length-sev/blob/main/sev_test.c
> 
> Thanks, 
> Thomas


