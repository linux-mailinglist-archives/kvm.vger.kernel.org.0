Return-Path: <kvm+bounces-29329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AF329A97BE
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 06:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AFB21C23182
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 04:20:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F334484D0F;
	Tue, 22 Oct 2024 04:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="J51IpSfM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F53A7E59A;
	Tue, 22 Oct 2024 04:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729570837; cv=fail; b=F2py2P9bCP/hGusqIwfczuTO3P8Z9MRDfObcp9s5bWH/htcAKBo86CNMmrw6UDlHVJORz7mRt3qj3vW8s2fMCb8bnY5ZsAWepPWAtpS0faXXio7OXX+Hm4ewrm9viSN50rb1YUK52k8L1gUAwIZ5dy2ih/FePzowZFNcaVL5Dbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729570837; c=relaxed/simple;
	bh=DsQmmgLqY14i5Y08GDM7f29r6w8E2GdujdmvbunXn3o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FSr6CtfykYfxJyZ6SCx/9GJRhIC0JZZbxjpXWRiVZ9GllEsu0THaFCW5m1O3QCyu1Ulal5gouJtienGJXL0N4Ng/XkPdg8MSghOkqNDUDHWlFm+Rx8s5s1Xt9DtFXXtJbDe6kbeFHkfI0hd7bUzLHvzZ69Flf2qq6n2+XqZUSvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=J51IpSfM; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yE1StJfVw+44NHv6UHm6ytIWtNxQl8DJMmjH4dv7VWX/USJPIqv3x9e1dPDNPzB3TYeUfnnOLG8xNhzUwAVK8sLpqlRUFfmvK5TNzsU9tY3cYwwFRtKSRubO/83pyYsdX0fHVc5KF2FyJsF/rH42rqosfXk9kSgK8JTrbLU/kVgbWCwbTuaryLpwJVEZc6YxnMKodbDA0SNuuthT6gYk16vG8H7h6bePltI3fpkYzXJctWfVJxdhV0pocFEbv0InRl0yb55I6/9+zZH/hBoA24thttyukD/BcoUwuXMstxHRRfPvQ+4+5QAGNTYzkDGU/ll4i6cC2R+JH+lwARy3wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLoRWJff22sflT+XBHjBUq6LyqaER3hECVNK2uDgZ7Q=;
 b=bjvY+gYEikDE3bFC3vddmNeohurmnTmi5AG3g8qdRQqp4bdzgS73gSGHJaU1216LbJuHeEFgfaw7Fh2f0HUgydbN8Plrprg1DKjk1VGJC7a0oy0pSJkThy5NFHLZ5SwJShMKmcSxQFPqKy65o+mqNK4Ak/ivo3iaaRPlTJI0qSWEygxpbVKlbvWnYl6Wmu0CArJxd5zgdnq9MaE2uyn8mck6d8YhCZ0zmEGREcwoYBaqW92b1acoJnKzaqTNH+jo3szAPKlhYxfHVWoCNTHIemdT0hdt9jisZD6D6lYZtyor9y4W+EQ1kn5Dran7PZ0jLdOBv1A1ckgfpfVzLet3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oLoRWJff22sflT+XBHjBUq6LyqaER3hECVNK2uDgZ7Q=;
 b=J51IpSfMPJrClciSCzGbcKTO9XQhiACWHN5WieBet4P7O2MZ88jn2ydPGUyVi6CQzUJp4nKDYIbx3xF6V9it8QkTYReKyO3ZxCDR4bE2cPdYwT4Ha2GMNvRFMzaaCWnv+a+KP37txBt93tdguS2mkjH06z80weuGmSYCTq+GbP0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB9101.namprd12.prod.outlook.com (2603:10b6:510:2f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Tue, 22 Oct
 2024 04:20:27 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 04:20:27 +0000
Message-ID: <85964a1e-61e5-c75c-c670-c41f640a8e7a@amd.com>
Date: Tue, 22 Oct 2024 09:50:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v13 06/13] x86/sev: Prevent GUEST_TSC_FREQ MSR
 interception for Secure TSC enabled guests
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241021055156.2342564-1-nikunj@amd.com>
 <20241021055156.2342564-7-nikunj@amd.com>
 <a25377ad-27ea-3a45-2a42-4bd41bde783a@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <a25377ad-27ea-3a45-2a42-4bd41bde783a@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0090.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:23::35) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB9101:EE_
X-MS-Office365-Filtering-Correlation-Id: 33209fb2-e55a-4203-adb7-08dcf250db0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGtwb1ZvL0pvMHRHcERlUEY0dWVyc0o0ejVudzNrMmhJbURKOGNvRWF1L0l6?=
 =?utf-8?B?VkRQbUFJOFdSYi9MSHJ6dWVEdEJ0NnJZYXpoa01mT1RPcGROQi9ORU5XLzhh?=
 =?utf-8?B?RlE1WWJOa1k5Q3R5R3kwcXR0czhrc0VldUhsL2l6Tzhmb2c1ZkdYNE9hMWhU?=
 =?utf-8?B?VjZuYnFVcGx6dzU0ZERpWVVlQTlvVDh2Z3lvQkJCMXZvOWovSDF6cElpMVFH?=
 =?utf-8?B?QmJaSmFma3ZMUGJ4eHBvR0ZlZXhibGRsbCtwSHd6c3k2dTlmb2xmalpxUFNv?=
 =?utf-8?B?dHdwMnQ4SXdxRzg4K0ovY0h4NkF1VzhuNzlyaXlKa0Q4TG41K2NnOEJHbVdE?=
 =?utf-8?B?OUxwYUFkZm15eGFuL1lFZlhaWUtlU1JKRjlEbDQwNW1EN1RCZFJXdms2OWFq?=
 =?utf-8?B?U2E2R1dLWk9MRE5BUXpGNUx0ZGFMOFZVdlpyNHlxbTV2b3hJa01uaHF0a1Ji?=
 =?utf-8?B?V2E1S3ZHUStpM0pYMnh5ZnI0Sng1RFZIdDIwemVUSnlRbnVvbnN4Q2ZBb1lY?=
 =?utf-8?B?YzFoc2FOVGU1K25TVXNIWkcvdzhOVDR5T1d2SFppWmRiY0htSTlYUDQ2YU1z?=
 =?utf-8?B?a29wcWQxbEZpQWRPUS9MRzZPYU9PVmk2V1Z5RGJYQUppeXA0NFljK3Nydkpx?=
 =?utf-8?B?UVZKOUl5bzFnY0J2WlBwTzZkY2drYXBjdk00bjk5dXVIOGtKN01PcnRLVk12?=
 =?utf-8?B?UXFqOGYvR1FlejkrS1RpUTl2aVdPbGdqbSs5dHVVQnl5YkRoZC82UlFEMm93?=
 =?utf-8?B?Z1YvV3lrcTdKOERMSU9FTGRLT1dRRmpLM2xpOFZmdnZac2pNcFlNekxPNTVS?=
 =?utf-8?B?Z1QvSVhhK2V6Z0VUZzJQL0VFZWlzQW5oS1pzUDc5cS9kVHJxbmpLb2lIT0JI?=
 =?utf-8?B?bXRpdWtXd1VnMWVsZ055bEIyY1RyRjI3Ym1ZL0JTTUk5M2UxQTZxcnVRamZW?=
 =?utf-8?B?dkdiZWdJZkNrVTBTQndoVE04WktlT3FjbVNlQlFnWW81ZnB5cGNCTTV5WjV3?=
 =?utf-8?B?cVJjS3daOW1hMXVQTGRlclR5aFp1dHdIN1pLTGh6TjRVUm5lUjVJc2tTUUg4?=
 =?utf-8?B?NUpESCtsZXZDUnMrM05sMlQwcGJKUUxDVnhhbStkbnBmVWt2aWlxSXJ0Y2N2?=
 =?utf-8?B?QVRla0lCUHI0cmdRVjJubGFjdDNkR0Q3Ti9vU0M2djVna2RhMnVGU1FIM29t?=
 =?utf-8?B?cVBhdlY0K3JJZThRdU1ET2NuRjVYOU4rNEpIMGdRbW95Wm5Ha0RodDlTTWxa?=
 =?utf-8?B?NGVJUXhiNGxRaGNOYjloMk1tQm1ZcjV0b3haNW5ENU9oQ3BWc2t4VWVtSFIz?=
 =?utf-8?B?RENiQUdMa3h4d2NTVnBsU3o4cjQra0F4UDBvcDAyVEhibm4xd2lBSDZzQ1N2?=
 =?utf-8?B?c01YWFBnZ3U5emxRSkZPMTFmejJjdFVrSXIxbGJmVFhOQnBuV1BtRDJjTFcx?=
 =?utf-8?B?QzljZEZwd1ZNWS9ZSmcvem4rakJMTStPTzdnVjgrYTB2NVZkakZIQnJXSU52?=
 =?utf-8?B?TkpGb0dFRHMrTW5XUXZkTjEyaUNranIzdDhvNlZlbHRrdEcyejZGUStiRTJ4?=
 =?utf-8?B?KzN6dU16MkkvSFc2Rkpiek05dUZLdjdINlRQdUZFT21IcWpaQnM5MVc0cHc0?=
 =?utf-8?B?cGVuMHRNS1hhR21LTk13My94YXNidTVzQjdNa29SK0JLZjkwRkxWWWhOZjRo?=
 =?utf-8?B?RW1VMlI3WEZBYngvdWZqWWlvTERiUFVZcXhxTUZObFB4d0Y2OW5neXZmWFhK?=
 =?utf-8?Q?gTCifh+9wO/thv2TNqxqsR218FXzz0gPl6myvXQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MG5qMmc3YjBLVU1BaWhCRWlKTzlNK3dCcnR1czlEaTRrNlY4aEhpVDltMkRU?=
 =?utf-8?B?SXpEMGxwbHorM2lRZjkrV1BlQ3MvUFQ5OWdMOXUwT0p0ZG9DdE5yZng1MnlG?=
 =?utf-8?B?ZHNKd0lKVWpabjJXZ01Oa3QxMmg4TWdocmgzdXByY2o4WERNVWRBWGdoc0FF?=
 =?utf-8?B?RlZyeXh2RnBHNEU4ZGpqSVRxdU8rMmZqaGVUQjduSHBlcUllYm5HcGdFcHl6?=
 =?utf-8?B?dEN2MFhqQndiTDhEdjNmOEtWanlFYWh3MXo4RVhoWXhXT3phemZzYkVBUmhu?=
 =?utf-8?B?czVYdG9kZUlGQmdnMGJ1NlE3TVpaVXA4WjJXVzdwcEI1d2RZTEcxOElobUc1?=
 =?utf-8?B?S2hpNFZ2NE1OWmZwVWpMQ3JkODVReWtrcGVuUDFnWGYvcUhiOXk5Z1Ixckp4?=
 =?utf-8?B?bG9oZlNjdzRNenlGNzJMWG80SlBFY1R1Rmp3SDAxQldGTENVSVNlNExTQVRY?=
 =?utf-8?B?cVcycmV3NDB1aFpFNGh6L0lyRmF0aHdTMWtSUnNYSDhyZyt0b1RlaHNQT1U4?=
 =?utf-8?B?c0pSa3hEN2V3S0FCa2dlOGx5UmFkaHRWVkdsY3h6WS9CZHFrOEtvMi9pTzJx?=
 =?utf-8?B?Q1hNaWU0MUpub2RieVZBTlRQck9vaXFUemJxQmxHeFllS0srNi9IWGZrd3Uv?=
 =?utf-8?B?dXJETVFsN21jcFk5bTNXMWlwZGp1dE5wc1luNGQwcG85V04xU2ZhZ05HdU0w?=
 =?utf-8?B?clI0akkwN2dPQ1ZNeHpwWjZVTGc3ZTFuK2ZNazNmNTJZK1NKaFo2N3RROXph?=
 =?utf-8?B?ZHNoZWdQSG1IR3BUTFdLUm45a0hkM0tONk5OYmJDVFRNYmFJdFhsWVQ2Qlc3?=
 =?utf-8?B?a2piSEg4SGdjbWlQazZKVHdnTVN0NnlWcXhXZW9zeExmMjN1anlhTVRLQzl6?=
 =?utf-8?B?WUg0ek9MZEhvZVBDbTdlSkpZMml4bTBsRVNtZ252eGNLdFhSR3JENHZiZHRI?=
 =?utf-8?B?Y01jS3E4ZjN4WHdCS3N4Q251b2tlSGwvR3Z6dEtCQjVETUdhV00vd0hPMWht?=
 =?utf-8?B?RjRPQUNETk9sejVFUVVab2NDYjN3NFFobzdoQmZidGFuQ3ZObC83eVJOcmNS?=
 =?utf-8?B?TEdsV254Wm5JQTFsYW9BTmFHcUhWTC96U1p0VTYvQVpMUVJCdlI2VXFhc2hW?=
 =?utf-8?B?eDRFcnVBQUNmbFJmVjN2Tnptbi9BTzVXTVFCR0Z2WGRpbU5KNi90NWdMUlRO?=
 =?utf-8?B?U2pBZXdEM3lTY1N4d0FaR1NrenVpOHpEQ250eHhrdXljZUtHemNoS3Awbk9n?=
 =?utf-8?B?K1c2SVcvRlJPSFBsYWZ4RnkvUFQ2RTRFNk02bzh1cmQxS1ZOS0tlZkhZb2lh?=
 =?utf-8?B?TXpFNnZLVEtVSkZmRzRUWS9XR3hWeTEraXZTQ0ZhQTd1ckxDUW1KbUhXRHcr?=
 =?utf-8?B?aWJ0MTBYdktNWktMWlNJdjlLNHRNZisyTEtoeFVxTVBkZmVoTDRhb0ZiMTZD?=
 =?utf-8?B?aW9vek5jU3g1RFJGL20vdktoeWorMlZHKzJiZjRiYWJXSGxMWFZKKzh1emZD?=
 =?utf-8?B?OVVQSzJWZlh6QkRSaGNNR2JNSDBQUjJPaGo0QzZ2OEpKSDc1ZVg1S3Iyb2J1?=
 =?utf-8?B?Z1lkVFl3MVhMOVhxYlg2ODByQWtvVDByRzRaSVVPMFdQVFQ5aDVPZmt4ejl0?=
 =?utf-8?B?Z1pvV0hlUE14dlQ5cUp2V0ZkLzM3SlJtdFJ6SmtuSTVJam95VDMwTnp4dHc0?=
 =?utf-8?B?THByT3g5REFiVW5qMFZFWHJaSVBkQXJHTlV4b3VjbEZpTXBBZTdxaFBETFlP?=
 =?utf-8?B?eTBaeHJVWGZPd0RlN1lQYjErV1dBeEFRYzhJbzdlRFcwVmd4K3dvRTAyOEV2?=
 =?utf-8?B?MXVVYzZWN1Q1NUlXZE1pZEZDc3RacGJmYythV004dVVaOW9rZjllVzFyYzN5?=
 =?utf-8?B?djNDUlNmcElKYitCV01zS1BWWkpOYzErMEJkTmJrcGljSGlCL2pBcDhZMCtC?=
 =?utf-8?B?dnB3QUV6QlBYbVV4c1lyeXNJNXl5cFBkTHVlRFYvQ1kwN0dIK0w4VWZTSWpY?=
 =?utf-8?B?ZnpBei85Qy80YkszRGFBZUNOWDAxVXZIOU9tTTVnZUJIeXdYaE5TVFY3UnY3?=
 =?utf-8?B?Ni8rYTdvZExESHY2dU16VU0vMFgvYVlsL2Q3Y2UxV3pDZVYvb0M1ajJVTkZq?=
 =?utf-8?Q?kAraHA1/OPEBPakLKy1cLs8K7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33209fb2-e55a-4203-adb7-08dcf250db0d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 04:20:26.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WhNwgKJmOxNy0W4MyNoEgTkBVLyxNpo7BjdJukaGZP9u+flzvUO8rMkwzVVfw7e6QC+bPyEM3+0lIiqrl3QPtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9101

On 10/21/2024 7:38 PM, Tom Lendacky wrote:
> On 10/21/24 00:51, Nikunj A Dadhania wrote:
>> The hypervisor should not be intercepting GUEST_TSC_FREQ MSR(0xcOO10134)
>> when Secure TSC is enabled. A #VC exception will be generated if the
>> GUEST_TSC_FREQ MSR is being intercepted. If this should occur and SecureTSC
>> is enabled, terminate guest execution.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> Just a minor comment/question below.
> 
..
>> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
>> index 2ad7773458c0..4e9b1cc1f26b 100644
>> --- a/arch/x86/coco/sev/core.c
>> +++ b/arch/x86/coco/sev/core.c
>> @@ -1332,6 +1332,14 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
>>  		return ES_OK;
>>  	}
>>  
>> +	/*
>> +	 * GUEST_TSC_FREQ should not be intercepted when Secure TSC is
>> +	 * enabled. Terminate the SNP guest when the interception is enabled.
>> +	 */
>> +	if (regs->cx == MSR_AMD64_GUEST_TSC_FREQ && cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
> 
> Should the cc_platform_has() check be changed into a check against
> sev_status directly (similar to the DEBUG_SWAP support)? Just in case
> this handler ends up getting used in early code where cc_platform_has()
> can't be used.

Sure, that makes sense. I will change it in my next version.

Regards
Nikunj

