Return-Path: <kvm+bounces-37306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0FFFA28498
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 07:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 662BC165E95
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 06:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE35227B9F;
	Wed,  5 Feb 2025 06:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zqnr6uX8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CD281ACA;
	Wed,  5 Feb 2025 06:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738738122; cv=fail; b=OfWlHtsv4KMV9/ds6nLn2OJ0O2lbswTy17XcGxATDxEVOsw0Hbjrp7x2rL2BWAXrxxBWuC5UymeiUk01cGfRMLH7QA23tS9KMvTJGZtNVGI7So+S4HIlmr8ia64q9D0ux2gibAluTXfpjtMwMae9AXSSeePeqzP/WP++JsefAww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738738122; c=relaxed/simple;
	bh=8n8IkKCS3in5WaAWhSucZ4RSOkNfjlBPnKzyG5K6F5g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FH/gJ/C1hO4jqOgcLV7FCPzBCljbNxGeQwSjXXVuJ8YC2ox1mmyJlUxeAoAsOPEZmOGLGpWWSurNCzlEV7g/IAhWgairIoYouxLpTkAXzi8i0nI1/ZRbavWi41L2oRBShGffIjpNSjU9DSzZJ7BRpv4VzhEvDLoIxGXwPW93baA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zqnr6uX8; arc=fail smtp.client-ip=40.107.101.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x3Xu6nqKOZmJ3OVtIYzG/dis14SSeQ+vJydceR22nRsChhN+oMAOKmWms4Fm3FUv8ySbXer06RrUwHfOkIKmgdtakKmptHFPfpGgnJl8TLLxUeVIteo9TDDBLCKWxufY7+pa29lrbdn7Lq8PHomHr6wWkHZPpWZ/suGo7VRMiGD7LSOA47y54kkXArp/yitnqR/hXA50rs3vyLHx5iokjJzfUXy/o9XaqEYKu+OtYj9b1YcIx6tZGY8cBa8DUOY3VuX2s7yC+6aZu1tLx+DE2Y+/H+RWxiqM57V+U12X9bmsQcCBmjQEEhORUfOnAQOoVbvxUC1KfmF3utO1Ku+lCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEFZPVGGhxBN9oKzqHZqZQZeqj2u785kcEbix+OXqEA=;
 b=kyeVivRu74h9X6ZS8gpaLeqC5hszMqG6MI/AL56FNAYa943GL/OKv5cB1eaqPyX7fnxlHdDayMIduT9rA1AJeNWOe1MNEjavbzKsTNwl/0i+zNCouYYbbyJSBIwIDr/HjwulcyTBEGPxhaMkCqHo4px7uuK0D4m8sWfOGsRyLCqT7oBWrcy/44ARuaQzb2ciX3xWgTYbjGMNZ9ZpbgedLFEUsVNv+RykKRRMU0lB+CxcmZgUdio+Sn8ysFY3+vSsLY61nktUpTAWqc5Tmxs3s5ZmCgef9Le0FeEGyU3SnM2EW9KGRDUW0wfvG6m7/d4ZLUEWlLCxCLRjjPW76u2wXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEFZPVGGhxBN9oKzqHZqZQZeqj2u785kcEbix+OXqEA=;
 b=Zqnr6uX8hYj8fFvEP90s5MQodkBvZsserFAXz2sTvIGLk8Bvt9rwusjzY6vnviwja/eFlcO1A1c8HsCMgxJ/ffURn1IVr5D8jGZpblUvJRxb676z5T18hmK0vEnnNHj6xdG2K47rpq60J4direMubMXfLnUI1g7p9MyH9H8S4dQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 PH7PR12MB7453.namprd12.prod.outlook.com (2603:10b6:510:20a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.23; Wed, 5 Feb
 2025 06:48:38 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 06:48:38 +0000
Message-ID: <6aa6777f-b7da-415d-b123-d49624008304@amd.com>
Date: Wed, 5 Feb 2025 12:18:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: SVM: Limit AVIC physical max index based on
 configured max_vcpu_ids
To: "Naveen N Rao (AMD)" <naveen@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <cover.1738563890.git.naveen@kernel.org>
 <b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen@kernel.org>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <b79610c60de53048f3fda942fd45973c4ab1de97.1738563890.git.naveen@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0092.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::7) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|PH7PR12MB7453:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e32b57c-a2f2-4e62-74db-08dd45b11e89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vnhod3M4RUZZZURYVGM3cStVVDByVWtsaUlOaHFkbkNiNUROS0FPUjhYMHVy?=
 =?utf-8?B?d2pSbXEralNHbXI3UUdQWnlpaGpBVjFKUm5IeVJFek51UTNIeU9TR2YyRUta?=
 =?utf-8?B?a2RsNFExUzd2UWhDSGZKdXpQbmdlNmtlVlVTWG93K0l2UzNuNUhjUmtFcGQy?=
 =?utf-8?B?d3ZMRlk2MjF3YmpvN0F3QTU0OFBxbk5qdFJQKzNXOElzeS9WbHl1OWR4SUVF?=
 =?utf-8?B?NjVhVjZTc2dyZGphbENUNU55cDl4a0VWTzg2WmNIbXNCNlFyelM4cUVza2tF?=
 =?utf-8?B?bnNENFhvYWRMRVB1Y1QrS2xFUmVLNUV1dDc3TmNTeWZ5c21vamV0djdIdU1R?=
 =?utf-8?B?V1UzYjNKaXgzTnpmMXJ3V3gvQkhkd3ZWZmRXdi9zMGYvc1YrVFg5WFM0N0h3?=
 =?utf-8?B?TGxUZEYyaDR4TVNDbnhoTVFBM0Q0SlFUUWZPb3RLeXc5TFpDVWwxQUxURDVB?=
 =?utf-8?B?a3dIMmNEOXZpOTBtZVM1Sk93TWpRZGZHdDdBekxSeXQ5RlRoek5WMkMwMytK?=
 =?utf-8?B?ajVkaTNvTnJGQVU2QTVUOVVDTnRlRGZVdnQ2YWc3bm1ZcnZvTUI1OGxBdmJ1?=
 =?utf-8?B?ME92QTdUQklEaFVaYUwyaEhWOHR3ZWNRdFNRRC9jVWx2elVoam01dGhDVVBa?=
 =?utf-8?B?NDN6RHlTU0dtalZqNSszMDFMbVlseTFFRThUM0h4bGoxc09rT211Z3hsTmh2?=
 =?utf-8?B?MWcvUytGWms0eW5OU1RQWWI1ZkJqb0wxMnBvUTdWSlFjUmh4UnU0b3Fkbmxj?=
 =?utf-8?B?WXNrNUJscW9HelU4MlNLamdEemE1N3JKbXN2S1Y5b3J0alU3VnZBR3Nsc2pF?=
 =?utf-8?B?dnc2WW1ZRkhwaFR0MmFoUktYZ2NQaitwTTVJNDMxR0FqK0NqZXAvaDMyLy9I?=
 =?utf-8?B?eWxnb002bEs2bW5sbUZRRUsxR2k4L05hUTNJUU9rQUNJRysrMlQ0dU1IZ1Rt?=
 =?utf-8?B?UmYxSnZTd0hYT1VEUW0zMU0vQ0hodEVMU2MrYmU3dUZGb3U0SHR4bDVnL1ly?=
 =?utf-8?B?UGNTZTZVZGU2RU4yOVFzZGRaRXVnNWsvcjdsb3RMWXJCRFJuRW1aaklFWGxJ?=
 =?utf-8?B?Q1ZCdEVMUkpORmlPdU1zNVRiM2tQeHorUkRJR1MwUHdPVVdyUFhsVW1KS0o0?=
 =?utf-8?B?ZkhXUnhQdGxWd2FnWHpkeVB1ODRocENuRGJzU0QvL29OYkdFZHNjNmlpb1JN?=
 =?utf-8?B?OWJYT28zc1JZOGtZaVpMZFpZSjNhQ01JYk9JbGxZaDZVaWR4cGlmdkt1L0Jh?=
 =?utf-8?B?YnVRWjNFZUpXSFd5M1diSGZMQ0ora2VJQ3VjU2ZMMVJaUkdFQ0NuR1pHdEo2?=
 =?utf-8?B?MHF5V1pTbGNPVkZwelhxS3dUQVNxMXB5Z0ZWZFBON29ZU005L3Z5ejhlSWpY?=
 =?utf-8?B?N0ViV25Qd2tPMVFEeElNSjJNNXJCVnFOMnlnWE43UWhFanZNaDdXMEVjOGV0?=
 =?utf-8?B?a3FyU0lJYklCRVpCZ0dZNWQySEdhbkU4VEZYMXg1bjFreXdEYUN2aEVMaDJ2?=
 =?utf-8?B?L2UwTGJhMDhiRXowOTJ4RTRIYjI1emJybS9EbHVhMGdmRGRxaE5kY21GOE1z?=
 =?utf-8?B?ZmRKQUdTYzVaTGprM2lobmhCNUR4bmF3eFN5enMyU0Z1YmszZzBaSGhwVSsz?=
 =?utf-8?B?YlpsTHROcnFNR2xiLzB6alBCL0RzSkFETHFlS0J6a0tuVHJrd3FVMm9sY25B?=
 =?utf-8?B?Y3AvZGF3QllUQmxXRXJ1bTBwZnl0YlliSklaek1mbWlsZ2x5L0NoZXdTREpI?=
 =?utf-8?B?d0swMktpQzViTWhWdGxGQUgrSnl3M1BVclpJbjgyVjlsOXBxeVVzTXNKQk1V?=
 =?utf-8?B?dWxwOUFrY0xsK1liWlNJd0ovQVhuaUdlUVlScmRsY2RNc2tiSUJwNno0NGpk?=
 =?utf-8?Q?uFSZmrsLG5UpU?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UjYzNDF2NTVlMUF2WFFwS0lTOHF5aHI4TXp6Y1RhTXkxU2ZCRkgwcFFEVlRt?=
 =?utf-8?B?dWRkOWhvNHdKT3RCNzcrc0VjY2h6TkV4MmgycDU4R3lxUlg0THZXUEUyTlMw?=
 =?utf-8?B?a1hFR3ZaTkUwbkRVMUxEM1krbFc5VndaQjRuVFZrSkQwdkJJckp5Q1Q1OVhk?=
 =?utf-8?B?WGJqcG1TVm5neHJwYVY2MlBzTyt4d1JBZlRHRHV1K05TWHdKQUVjQmtONkM4?=
 =?utf-8?B?SDJyejV3M3Z0bTcwTGpWaDFIV3ErUlNZQ2piY1VkNG84UEcyK3NyaWxYakdV?=
 =?utf-8?B?MmpzR216YXlqRUFVQlpuVVQxZTNlRlFQUStXOUJUZThiUVpCeHZPaFBuUFE1?=
 =?utf-8?B?empIZE9jZWtPcFUzY1o5Z3VSZXA2SnNIMWUrYnpqMjBxdUZiK2dEVDdEKzB0?=
 =?utf-8?B?QzlQczkrdnVGTGx1YzdXcjVvSkVXMDY5dVRVZmhtV1lEaHQ0cmFSMitxTHdH?=
 =?utf-8?B?aWdxZFNGUzFTNVc1ZStOWlFQS01YbkhkWGdnS1pXdmZDNFBUcjhlNkU1YXJn?=
 =?utf-8?B?cWpMV29maGdTN24xNVNnam5wTWxPNHRYQWNmcEtuS2EyR1hoTTJvbmNMODR3?=
 =?utf-8?B?NUI0ekhZcVhpdEwyWDdOTEl3cDgydWZmYUZqVUIxRXBxS0JJRk81L1J0UFpZ?=
 =?utf-8?B?NVhZV0M4MGx6b1hvTzVRcVBjWDk0NXprRm1WRVdHMmszUVJBUzFjRlR4UVJL?=
 =?utf-8?B?Mm9nRmx4dU9lV0lFYUZaNWQxMzBZdmNackdNS01yQXc1R29RbjN2dGYzbjNS?=
 =?utf-8?B?VlNQZ1JCVDRaNHVXdHRuN1ZQWTNzTjBoMXBJUGN3YXQxTU1YQWs2MEVXcXZQ?=
 =?utf-8?B?QllpLzJUcEhNdTFWcUw4Nkh4UkdLNDA1WkNnTWhXVjlpcHIzVmRRbHVnYkxH?=
 =?utf-8?B?Nm5hVVhTcExJZUNnTGxrVndsQ1Y4bjNDK0dzWlZ5U3FLQlkvWjdKWjF2YzRv?=
 =?utf-8?B?RFd5eHAyUnRzcnp4VVA3dVhqTHRRVm1oZzZBd3JFTm1xbXgvRFlUeWVwbFdQ?=
 =?utf-8?B?YnlMaEpncXJwQllacndZakp4Q04xSW9GK05IczBhaHpnTEN3Nk5HRmhaNFBa?=
 =?utf-8?B?T2JneDdCdlFrdFhlSUtCaStDcWlraU92QzNSQWNWcWRZSTBVZDdzQWdZS3k0?=
 =?utf-8?B?SXdWM2NINk1WNWQ1QUNPbDZjakNIVHlacXlUSU9qKy9aL1Y2dW1sa2tLN0FF?=
 =?utf-8?B?bGY0cHhpWWNUdHhNaGhSdjBBbHlZZE04bUxsSmN1SURJWWRiV2hKWEV2bE0r?=
 =?utf-8?B?MUtGWmxCbXZVVUIxUENtazRwOXVBd2xHQXNldWIyY3RSU29yaGFIbWtPQWlF?=
 =?utf-8?B?amRFMEthdUxkVllZYzNZczlGUVg3akpxak9XWDhzRllLTW1RUkJnQjRTekky?=
 =?utf-8?B?UU5EaUwyeEVsaXZ4QkNCR0hXM1VINzhreWF5VVVVUmo0RFFUQ3lVYmVVZWU3?=
 =?utf-8?B?WURyZ2VvV0VVY0lheHFmN0luVVFTbW1HMHNDQkRrUllZbndOSzFIdU1tUHRm?=
 =?utf-8?B?aW5TUjhtakNXSFU3L2U5eldCMmo4eUNJdXlRaDBqN0VoOEZCZFpDQ1Q1aGdn?=
 =?utf-8?B?eVZPQXZhVnREMEFrUm53OGthTTZ6ZDVEdDN1bmFzenEzc1RXa2JiSXBOZlNB?=
 =?utf-8?B?RzEvRHJzT0JZNkJBbFUrQkFoaXFZbUJPaVQrMXNqZEZBbmVkRWdUMGRsRXNM?=
 =?utf-8?B?M1JheUI3dkowZldOcmVWcHFyM05BVm1ERzNvRTFsSHBqd2FJQUxsdXlKYW94?=
 =?utf-8?B?TUpoSlFqM05UR0tPZEdRVWZpakI0RFlxMkl3T0tPQXA3cVIzYmFsMVhKOFd6?=
 =?utf-8?B?bHd5VHA3eFE3a0VFK1l3cEhJU1RmUmZUekNxZndGTURmVEhXbnFST1NuL0NS?=
 =?utf-8?B?dExkbHZXTlBIVWthdWphTlRYT2V4VmYzTXZsNi9BZGhpMm5ib0tpQVAzK2g0?=
 =?utf-8?B?SzZLejI2aDcvUUdvRldKWlFSNmNkTEdvSy9HOFBBeXliNnlPWWJIa083Uk1r?=
 =?utf-8?B?eXhVS29SVnlhWFpvYXdOajJhQ0hPUjFMQnBmdE1vdU5KQnVPMDh0YmE0cGdx?=
 =?utf-8?B?YldBY1plTmNCTDA1amNiSVM1UWgxVnNNR2hHYWd3aVR6Z1NvUGlFQ01Geml4?=
 =?utf-8?Q?RO9Vf3nSl7joH+iqoUfHS4SjZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e32b57c-a2f2-4e62-74db-08dd45b11e89
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 06:48:38.3569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjhZpuD99tCU8cDKXqz5mqRLA1xf8Nv5Fmo9xf8oqyq/opKgPwKkb3M5FExF21nToO7L5MWjJ8XQttsBm9eRSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7453

Hi Naveen,


On 2/3/2025 12:07 PM, Naveen N Rao (AMD) wrote:
> KVM allows VMMs to specify the maximum possible APIC ID for a virtual
> machine through KVM_CAP_MAX_VCPU_ID capability so as to limit data
> structures related to APIC/x2APIC. Utilize the same to set the AVIC
> physical max index in the VMCB, similar to VMX. This helps hardware
> limit the number of entries to be scanned in the physical APIC ID table
> speeding up IPI broadcasts for virtual machines with smaller number of
> vcpus.
> 
> The minimum allocation required for the Physical APIC ID table is one 4k
> page supporting up to 512 entries. With AVIC support for 4096 vcpus
> though, it is sufficient to only allocate memory to accommodate the
> AVIC physical max index that will be programmed into the VMCB. Limit
> memory allocated for the Physical APIC ID table accordingly.
> 
> Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
> ---
>  arch/x86/kvm/svm/avic.c | 54 ++++++++++++++++++++++++++++++-----------
>  arch/x86/kvm/svm/svm.c  |  6 +++++
>  arch/x86/kvm/svm/svm.h  |  1 +
>  3 files changed, 47 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4c940f4fd34d..e6ec3bcb1e37 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -85,6 +85,17 @@ struct amd_svm_iommu_ir {
>  	void *data;		/* Storing pointer to struct amd_ir_data */
>  };
>  
> +static inline u32 avic_get_max_physical_id(struct kvm *kvm, bool x2apic_mode)
> +{
> +	u32 avic_max_physical_id = x2apic_mode ? x2avic_max_physical_id : AVIC_MAX_PHYSICAL_ID;
> +
> +	/*
> +	 * Assume vcpu_id is the same as APIC ID. Per KVM_CAP_MAX_VCPU_ID, max_vcpu_ids
> +	 * represents the max APIC ID for this vm, rather than the max vcpus.
> +	 */
> +	return min(kvm->arch.max_vcpu_ids - 1, avic_max_physical_id);
> +}
> +
>  static void avic_activate_vmcb(struct vcpu_svm *svm)
>  {
>  	struct vmcb *vmcb = svm->vmcb01.ptr;
> @@ -103,7 +114,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  	 */
>  	if (x2avic_enabled && apic_x2apic_mode(svm->vcpu.arch.apic)) {
>  		vmcb->control.int_ctl |= X2APIC_MODE_MASK;
> -		vmcb->control.avic_physical_id |= x2avic_max_physical_id;
> +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, true);
>  		/* Disabling MSR intercept for x2APIC registers */
>  		svm_set_x2apic_msr_interception(svm, false);
>  	} else {
> @@ -114,7 +125,7 @@ static void avic_activate_vmcb(struct vcpu_svm *svm)
>  		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, &svm->vcpu);
>  
>  		/* For xAVIC and hybrid-xAVIC modes */
> -		vmcb->control.avic_physical_id |= AVIC_MAX_PHYSICAL_ID;
> +		vmcb->control.avic_physical_id |= avic_get_max_physical_id(svm->vcpu.kvm, false);
>  		/* Enabling MSR intercept for x2APIC registers */
>  		svm_set_x2apic_msr_interception(svm, true);
>  	}
> @@ -174,6 +185,12 @@ int avic_ga_log_notifier(u32 ga_tag)
>  	return 0;
>  }
>  
> +static inline int avic_get_physical_id_table_order(struct kvm *kvm)
> +{
> +	/* Limit to the maximum physical ID supported in x2avic mode */
> +	return get_order((avic_get_max_physical_id(kvm, true) + 1) * sizeof(u64));
> +}
> +
>  void avic_vm_destroy(struct kvm *kvm)
>  {
>  	unsigned long flags;
> @@ -185,7 +202,8 @@ void avic_vm_destroy(struct kvm *kvm)
>  	if (kvm_svm->avic_logical_id_table_page)
>  		__free_page(kvm_svm->avic_logical_id_table_page);
>  	if (kvm_svm->avic_physical_id_table_page)
> -		__free_page(kvm_svm->avic_physical_id_table_page);
> +		__free_pages(kvm_svm->avic_physical_id_table_page,
> +			     avic_get_physical_id_table_order(kvm));

Move this hunk to previous patch (1/2) ?

Rest looks good.

-Vasant


