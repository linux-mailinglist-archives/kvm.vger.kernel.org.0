Return-Path: <kvm+bounces-61675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 881E2C24C19
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 12:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2C36F4F485C
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 11:18:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1674025A35F;
	Fri, 31 Oct 2025 11:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4Ftxyp5+"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012030.outbound.protection.outlook.com [40.93.195.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA74E306B1A;
	Fri, 31 Oct 2025 11:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761909524; cv=fail; b=SUwcr7Ap9+hEMLmdgotRD6Qo9vGHXe866MqUQZYWhOcn5w4PYVtS5fQhSXfMTryXRaMbfOTvLivdwjk9Nc3zu0yFvKJWFfAB8+jhBYYW9ohGJXqisMlgPDszHglu1ebQNTSsjFN/oAPsk4JiaYSBOagixrEmh6/970ROMHUB9Us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761909524; c=relaxed/simple;
	bh=+1O9yxa3Qts/2jiTxwl9ZiIz4AGnSX5wwnS5h+g2hsk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kt1wgmnab5e49PZMbLZ0zPFv76Vwk0fujsSnUmLLDM7uR8eJzT98AiHG5fpaUH+xTr8AWD1o5cX59xAKQaHm9RnL3/cKpgUUXbByKPMzLXV9sR+AzFHxi1iFU1ApBeXbRAmUyW9BR4kVFjs8XFKHZ1x+RxacT0fEyn87allGtHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4Ftxyp5+; arc=fail smtp.client-ip=40.93.195.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q5CYpeXESF872cnaAYYNH1cIgu5qt9W7fBAXRMyDcHxN8LcgFaPSEaHwc8InXq7KBHW0YdXw3WGcNfKnpJ226381Ur+qb7ZjevkqxD40S6c3ACp81TZaSD3nogVJrw3YnJd0fe+19Zj9s/N7q2VOsdQvajTlcHesG1NnACujmCTt5lETXjyU/nhPoWaSvT39aOkGdX9bEe25e/Q07QLgRjS1Iy1NpNPGMmspysHQboBgSPdYZUWunEAhtYDxO7gJWy339uCbXOOW6NjbbtHAuXMNpMC3n9zgm7q6L1hFXv2AJdLGyBRvaE5MuILWWHjC7PVsdwxH3mb55P1FSxLWtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YtLdV01X/GaTA0Lo5CnmWWNbd551N8pgRo8L7bRUpWs=;
 b=YkfrjN/71Ri3hv6KRxmx+pwOBJTgZhB7zeSfy9RCYivOXoKffI22XmOvLcMJk5mledEynxausadahCPNH0yM+OOeSQLGE2anRLVQp2ce6srrS90iHxYPacxqUZHU4ffiKmIdJUSnJutWWwuVgP/BXnZ/cTavQO9GjfM7jpfrQa2pLdQkBKPnwLUveqkn2CliJGoqjqvgn5KSyCRVJXsy2xmKDuvKXKtLJWsXJgaexeC0K+AR//QLPSb+BxbTz6zoe9rRRUqCyma6zJPbSE9IAr3wt2nFgfkrfO6QxahUvk9WdDFbMUKMWZFsAn+Co9oK7t9zxcI+0LGOzvZU27yNkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YtLdV01X/GaTA0Lo5CnmWWNbd551N8pgRo8L7bRUpWs=;
 b=4Ftxyp5+U2T60eXxuNBqL4rqvNJBHi+KJ5lcYhFj82e0LUIpEUB5+ESe3aoABNfleW64I4usMLTIbdPeRPL/vTCCimGbCo3kZPpYWmcBBOjTfnNn+UvhvpLtWCY8gQq3QXVQYsMTLeH699dxDR4ZL2SWe9p+ihO+W4JD9eG2z+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by DS0PR12MB8575.namprd12.prod.outlook.com (2603:10b6:8:164::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.14; Fri, 31 Oct
 2025 11:18:40 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%6]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 11:18:40 +0000
Message-ID: <c353115c-81a9-44c6-b863-e5637670d0d6@amd.com>
Date: Fri, 31 Oct 2025 12:18:37 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled
 VM-Exits
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251030185004.3372256-1-seanjc@google.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20251030185004.3372256-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0320.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::9) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|DS0PR12MB8575:EE_
X-MS-Office365-Filtering-Correlation-Id: 41c33f56-be0f-4f4b-c43d-08de186f3e4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bVg0V2R2V3BOcEdCR1lVT1RQUHAzb0JRYXBzZVcwVCt2TzFZRUplcXVJMlpD?=
 =?utf-8?B?aUZxZWgyUVVGTk5QcmI2dGpxUVFicVQxVmxBVEo2ZlVJdWk2YUFVTU9mTW5y?=
 =?utf-8?B?WkpQUmdBNDBhNUtDNGlKNGtOV0ZFMm5USFIwZ2k4aWpOcW5QZjcyc0h6TjdS?=
 =?utf-8?B?YnVZODUwNjVZY0ZCcnNoU1k5bmptbFVuV1BBcFQ1R3VvckJCMURRQmNCMWtx?=
 =?utf-8?B?dWN0Z0VDVHBzeGJ5QWR0dSs1SnlaK0sySHFhSkJGQ0o0V1FqUHh1bkRhOGtm?=
 =?utf-8?B?K0pTSjFua1lyMm5XN1FjTDFkV1lTblorbStOQmJVeTg5YzcxNk9HSHEyWDFY?=
 =?utf-8?B?RlNtK29tM2N3UnpvL3A4dDhPc3FobWc5WmRhTGV3QWdNdXBVWWJUNVVVZ1hu?=
 =?utf-8?B?SFlJdVBacWJTQURUSlZicndZT1piVWZhSXNESU9ndWZVZTV2NkdBcmRmK3hy?=
 =?utf-8?B?b1ZDY3pJcE1NTU5uemFIMldFdTZWeHJpTkV0VWh5aTcxdjNvcXFTSEdwb21H?=
 =?utf-8?B?QSswdXpJa25RVTBBcnFENmhld3k4RGNUVVdtN1hMNE94dmwwNTlhMkNQTXps?=
 =?utf-8?B?UStpbnpLT0NESWp6YmtGYlQxcXJPSkdDZUJDU284K3lhb3BBbjV5TFh0cFpZ?=
 =?utf-8?B?NWY0OUM5cUZyNDM0V3ZobklpM2c2MndRZWpQNGtsRVlJcCtueXk1aWNOT214?=
 =?utf-8?B?SExJSjdBUHRyUG5VNHFaNjVQNk5TcG5ONENwZStOdHlhRWlIZjE0bTVCZG9I?=
 =?utf-8?B?ZmVRWnRGNUJ5WU5jOTdZb3FoTmhqZzFOWkwrVi9URWJmRk1tbEhEVGhGenJt?=
 =?utf-8?B?NHpmYllCVmFKL21uMC93UmNnSVBSMUNMQTdvYTAyaVhZYjNtcFVSNVdheitV?=
 =?utf-8?B?MXlYNndXUEtWamVvVk1ZMEhzN1hva0NTQTdDbGJRM3kzdHBrYmxkUFVNUXQy?=
 =?utf-8?B?VkRrMUVYYTFFTXZNYjliYUEyeGRwY3hpc3NMUXY5L25uWVRMeG1WQ2RFVjJm?=
 =?utf-8?B?Vk1uWjk0THYzMWl0SVRKeDlOWExic1ZaZzZnaEVWTE1lcFU4clovOFlSbVFP?=
 =?utf-8?B?UmlVcHpDczZkN1FOcTdNSm9NWlljaDZOMlJ3VlNwclNIRnRZWWxVSEVOWlF4?=
 =?utf-8?B?MGJoTGRKeUEyejRld3hQK2VJMHhnWE9xQnVRaVROZUFFQUVSQjdQRHc4amhQ?=
 =?utf-8?B?ZWgrTElqTXp5VENrajAxdW94dHd6U0dkdi9TMzNOVGtVc3Z5b1lkV3RXa3ll?=
 =?utf-8?B?ZmljKzdvZitHcFVRWnZYM0tSYzQ1a0JsNHhzUXppbkxQZmdBQXhCSTYvbk9G?=
 =?utf-8?B?OUp6aHBTTC9hQzJ5VHJZNnBHMTRoZHA4OUJzL1BWVm5DN0hDWEp6S2tUTXA5?=
 =?utf-8?B?Y01zc0tVaG1QOWdnYTJGdTBuRGl3c2RGeHEvVzliSUdJeDhwS1lYU21sak1r?=
 =?utf-8?B?QndNUUltWDFvYzJTOTB3ZkJHYkt3VkxRUzA3dE9SNjZXRnNnSUREeCszNkFq?=
 =?utf-8?B?Z1FteE4zRVBsRVA4T1VlRkh6U1NUalluVXZaYVhQSWRXQS9DdEVpWHVyUTlF?=
 =?utf-8?B?VWlHaW5jQmpsc1k2bkwrME5RSVM5RkhKVGxKMmpiVFFTTG9UMU81aFFlTFd3?=
 =?utf-8?B?cm1mOTA2OVlmWkN6US9jVGV3SENBMkFEWnFQVjRlYURCQk9QdmlJMGFTdEh4?=
 =?utf-8?B?c2loVGlCRk0vTGVzdTlXOUluWStzbjNEL3VWdmt4MVNTZjhMaWd5WWlEZVZx?=
 =?utf-8?B?UTd3WTZpM0g5MEdkYTZsb1lieE5Hbk5vcEJWbHBHZk0zT1JDOXF0dHFkeEl3?=
 =?utf-8?B?Vy9kRHB1cmtoVUR6OEJaQytHNFVXOWloVlRDUVdrUGI2ZEFQVlNra3p6ckE1?=
 =?utf-8?B?T29zd0hydGpOMk1tKzdSTkp6V0xscEZ0RHRTdkROek82RFlFTHdGanRIcGI5?=
 =?utf-8?Q?x1ILsXByqgkrZjMGSpsg6X2To1MtaaMq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z2R6UVJtaG0zR2VGbkZuV2ZkaVV3VDdMU3cvQmNQQk5Ic3NCdGZqM1VLdklN?=
 =?utf-8?B?OTdmanJsK2Q0TzdNVjJKNlpEUjJYUDNLMjlLSVd5OTZ5N2l0TkxtazNKcEoy?=
 =?utf-8?B?eEJEQk5LemwrWXVnMVI4ZVJxdGowRkhQYkVuODVLMzAzcDdYaHlkQzY5eEpQ?=
 =?utf-8?B?SFVIb3VOOEpVK3RDUjFXKzMzUjRJWnhqbEhRenoxUmx0R25YcGVpdjhKOGY3?=
 =?utf-8?B?RmxIRG9OcnlpZFFxVmQ2bDN4T3A2T2cxbUJ4dkRsWHpSMUx2clFpZ1VOajV4?=
 =?utf-8?B?RGtjRjExaTIyV1Y5SUZkNzQyTUhDQURwMjFWaWxXMTdvdHhQM3cxajV0ZjJh?=
 =?utf-8?B?b3ZMSW9EUzRGTXB0NDg3UXhXK2EwWkJXOExEUHhzc1BQSGsweHpXTWJjTG5U?=
 =?utf-8?B?cU1CZWxnMk1FaTVBRVZWWkRUR2MySHVORTh0cUU0NTRlemdhWE5PdjAyQXdl?=
 =?utf-8?B?RXZ4bDk3c0xhcW0rdmQxckFvREdSQSthbnZtYU5BRll1RHpTdnBVYzQ0eWNE?=
 =?utf-8?B?QXlJRTBkamVBZGlJZE1NalUwT1BPdTdndGFRMmEyVndWSmgvR2VseUNUNU9B?=
 =?utf-8?B?VHV2anRzVUR0ZXY0Q2VmL2tlS2ExRlFzRm9HT3VsN2tCMjhESUNyQVBqZmR4?=
 =?utf-8?B?MnNFdmlLckg3ek03YTdnRmZmV2t4allKdVRSWndBVE1DQ2N6ZUNBUmVDNlEr?=
 =?utf-8?B?QWwrZmdrQlJUZThKaDl6N3Yrakx4d2xJL0VNSTNTL3dmdllDSnNtZmxPT1hh?=
 =?utf-8?B?SkhnZTNnOFdsWFBVM3F3Y2tidlpPQTNuY1p5bm9QUUpWTXlMazdnYUIySFlv?=
 =?utf-8?B?aXFDNjlDdXozRmRaMEhHa2FzWFd5bE4zVEt1czB1Ni9UdmRCVHJGSU5aRk8w?=
 =?utf-8?B?VHYrTGlHQ3lJMXhLOHFDUThWODlzeUJoTjZGcGVqQ2NPdE91emM1Q1JsdlJ4?=
 =?utf-8?B?Q0FPSGY3azY5UFZYQklwRitOZHVndFNtN2d6VFA1MGMrcTlIRWNjTEVwOWtw?=
 =?utf-8?B?cjdxbXRUZkE2Q0tRNW9ub2dnaW9MQlRSKzg2Q2VGQ3lsQnhEWmdOajlCbVUw?=
 =?utf-8?B?R2xEK21EZ2crWlc0RGc4UDcwV2Z5SXZ4QW9hUEw5TlJMTjc4NzliNUNRZk42?=
 =?utf-8?B?VURybzVoWXJWRENMeDhzazFhVEFrOWM2ZXF5N1hYeVJqMDlZR1BaQ2NmbHJQ?=
 =?utf-8?B?Lzg2YUZIdGhybUhOcTZ6V2lOTll2WlNPOVdzUmNaTDJBN05wQ0VDYkhKUGlX?=
 =?utf-8?B?RVgxMmdOK2daQ3VYNzhSVmJlTW8yRDlSL2lpRjdObmQ1L1JQdjNobmpqVzRv?=
 =?utf-8?B?OUZUT0dwS1hOYXJWU3FvUExQQU0zRmNKTUlVUStXekxOL214RDhTY3A3Wjln?=
 =?utf-8?B?T1EyWHFmcWJ0M09tUE55UUpqSUtXZlNXNmdqcVRRbHJrUUIyL01URXpEdEZG?=
 =?utf-8?B?ZlVrY1hXY3h4clkxV0ZpOS9OakJaeEhxbDR1S244QVVHMmE1NDBPclRGd1pp?=
 =?utf-8?B?MjZCN0hUOFZLa0xMUHEvalNLZFdXR1hZN25hckJsbzhVSXRMd3BSc3ROTmNZ?=
 =?utf-8?B?ZGI1RHdMRFhHbHJsY0J2eHRpV3ZZVU9CU2JmbU8rOUtsbi9jNE5MSVN0MHdw?=
 =?utf-8?B?ZDE3T2tOSDNCYmxuWmIyaTFFUHE2b25Sa283T0dQL1UwV1N6TlBxajA2elRy?=
 =?utf-8?B?OHFacmhUdHhCdnVyLzlkenFPVU4yMnZsK3F5YUQ0d2swZUJQcDdUdmFJWkYw?=
 =?utf-8?B?NDQyakpJNWZUVkdhR013bDhKajl6a2JiQy9VM0ZTRXYwN3NTZEFyWExaeXdL?=
 =?utf-8?B?MFlETHFsRVdGejRHSlQweGMyU2ZHQk1XTUhFV1U0Q3RHbDN6NmNWSGNPUzRi?=
 =?utf-8?B?RVNMVmU1WUw0MVZkSXRYMVBXOVY4d0czVks2bWFLV0xmZ0pJbklVdnJYRzZW?=
 =?utf-8?B?YmxIUFQ1T0haOFdBbUV3bENOUW9HOTMrcE10THA1b0o5L0tPQWhoZHI3Unda?=
 =?utf-8?B?YVNZMHNXTE1MV25MSzBrbWpoamZaNWZWYm9rMFNNczFjcmRldXluNHN1MlFI?=
 =?utf-8?B?REZPb2FMZVNhMis0UXA5T0czdUVqTGp1T3kvbHJJVWNvMGt3eXdhSldneFNy?=
 =?utf-8?Q?Ww8LzhiuTgChR7JWjiBmqtW/3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41c33f56-be0f-4f4b-c43d-08de186f3e4d
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 11:18:40.1848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVCEebWV/nK4mqy6jmHgBKtba68zO54suF6SsA3vNFHsBGaAAk0m0wzT9JcyMNJp6GrXXgH3fv7gcgqdqtjR5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8575


> Add and use a helper, kvm_prepare_unexpected_reason_exit(), to dedup the
> code that fills the exit reason and CPU when KVM encounters a VM-Exit that
> KVM doesn't know how to handle.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm/svm.c          |  7 +------
>   arch/x86/kvm/vmx/tdx.c          |  6 +-----
>   arch/x86/kvm/vmx/vmx.c          |  9 +--------
>   arch/x86/kvm/x86.c              | 12 ++++++++++++
>   5 files changed, 16 insertions(+), 19 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 48598d017d6f..4fbe4b7ce1da 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2167,6 +2167,7 @@ void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
>   void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
>   
>   void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
> +void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason);
>   
>   void kvm_enable_efer_bits(u64);
>   bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index f14709a511aa..83e0d4d5f4c5 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3451,13 +3451,8 @@ static bool svm_check_exit_valid(u64 exit_code)
>   
>   static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
>   {
> -	vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
>   	dump_vmcb(vcpu);
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_code;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 326db9b9c567..079d9f13eddb 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2145,11 +2145,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>   	}
>   
>   unhandled_exit:
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = vp_enter_ret;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, vp_enter_ret);
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 1021d3b65ea0..08f7957ed4c3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6642,15 +6642,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>   	return kvm_vmx_exit_handlers[exit_handler_index](vcpu);
>   
>   unexpected_vmexit:
> -	vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
> -		    exit_reason.full);
>   	dump_vmcs(vcpu);
> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> -	vcpu->run->internal.suberror =
> -			KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> -	vcpu->run->internal.ndata = 2;
> -	vcpu->run->internal.data[0] = exit_reason.full;
> -	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +	kvm_prepare_unexpected_reason_exit(vcpu, exit_reason.full);
>   	return 0;
>   }
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4b5d2d09634..c826cd05228a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9110,6 +9110,18 @@ void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa)
>   }
>   EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_event_vectoring_exit);
>   
> +void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason)
> +{
> +	vcpu_unimpl(vcpu, "unexpected exit reason 0x%llx\n", exit_reason);
> +
> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
> +	vcpu->run->internal.ndata = 2;
> +	vcpu->run->internal.data[0] = exit_reason;
> +	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_unexpected_reason_exit);
> +
>   static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>   {
>   	struct kvm *kvm = vcpu->kvm;
>
> base-commit: 4cc167c50eb19d44ac7e204938724e685e3d8057

