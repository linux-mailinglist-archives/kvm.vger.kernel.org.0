Return-Path: <kvm+bounces-34457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A4A59FF3A3
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 10:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5342F3A27B3
	for <lists+kvm@lfdr.de>; Wed,  1 Jan 2025 09:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83B3F76035;
	Wed,  1 Jan 2025 09:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="X0fAHV02"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199DBEDE;
	Wed,  1 Jan 2025 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735724669; cv=fail; b=fWN8Js+k6vi7moQPkXHnjWagIjm+iJsO3jsvoS9zvJg6nZDRZUMqjmz8eO9b0VCjvFNVf1C6FTDkBr5STYcUuXitGnhdzo15AnbZ0h9im0HASoiD0k4tzSXH1b7C5WimELCbItWJRvc3HUavvYeP6arp3KsLxi/NIKOkpuBOiK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735724669; c=relaxed/simple;
	bh=H07jE2li6NzRVCTjYcpSxuVRhBwGBkhVKrwlMhzLDfY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jMa3LOWPRwjUlOkbqozblCW5XqOIXArtUxBAz5E6oxW3l6LzKBcr/2kskaXL9ccrN+xoWqatA2KlV1qqvnKm4u3Aik9X55k/8QO2RlmoI9eVQ+QMFcErQi08V9swDtOTScA+5RncZj10ZzKw7szmvuRQ+Iaz9F/EAZ85wssGgXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=X0fAHV02; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cRxvWlQWnLdxgTSwMdTLD/xe3m+DcIroJdSfIWNb0WQf7cF/y3JaqK+QU5AxUy1gYyUTxlUA+E6MtWs2qthRmo8RXlQg68MDYi6yws0dss+HOY/MBZ/WJPAkk2QYVEqhSH7QaukKCyQv/fSubqj+jRKPvCDf8oK7ZT3mrOErR3xcvtt3+wn+QhpgGaf8qhC7AKCYHF79jcNtOtjTZI7v2wKC78rgCvObZnUGim0jEcEkB+nHxXh7y4benBJIhaF4nQPJISMxTh6Qv48ignq3No7NF4Tfhspa1HMvnvCrIdkeOuzWm1bMZLXhtKfObVs5OoxtXzjc2nUQEuB7GpC4Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PCDHCic0nJcAzZmeefjM0YakH7lPSi66bLANLGqVnsY=;
 b=wjVPm+eQu+AOdcUkV7H+jmS7bi0Kr4OKkbegkP9EFgvu2rMe9t0PvIASBxu+0akjkCO7Jcd2nJJ21+BJrHj40EqbgHKvzBoKLR8UhAdzGAHe2zx6ezog1DwvQ0HE6NIyUUs4bTQP47KfINAcxnt5GjjX9aD5YKw6/WUTnitTbVDJYo+wVAAPdIyX5Sx0mME64ax33iFSlksQ2WoSRYXGGcO3TJj8J6ehlR8fiw50zwAIjCXqGcnNOC/euwG6gCV0vP4aAp0YZDH3mPUGqkh6GRsD8cDCOCduzHexGJfCaPkUsk3yChhXXXRiK0W1L3d/9Fbz1WqgFLymvp8eDu2pAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PCDHCic0nJcAzZmeefjM0YakH7lPSi66bLANLGqVnsY=;
 b=X0fAHV02bO3er/AFHbPJ7RBpev9EDTmH9N9EnwIISV9vt8lNw0tflOCsbcwbvq/mCsaIjh+G+1iOXC5OLlVpSFjdNSyYF0qbyoApAlf3D+nZxza+bfWkwUA8uKticmpL4yGg7GKCKMrSp5RduHJzob+zC/YzCye8F/r/ushe5lw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.11; Wed, 1 Jan
 2025 09:44:21 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8293.000; Wed, 1 Jan 2025
 09:44:21 +0000
Message-ID: <f46f0581-1ea8-439e-9ceb-6973d22e94d2@amd.com>
Date: Wed, 1 Jan 2025 15:14:12 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 12/13] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-13-nikunj@amd.com>
 <20241230170453.GLZ3LStTw_bXGeiLnR@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241230170453.GLZ3LStTw_bXGeiLnR@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXPR01CA0090.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::30) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SJ2PR12MB8784:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c329686-815f-459a-3909-08dd2a48de66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dE9DQnNsOTBxbjVmcnVKY3c1NVBmN3E4bUJ5ZHR3bDZZUE0vekp6eUNEYlcr?=
 =?utf-8?B?Y0l4cE5BVGF3M2lHN0RCN0F0Um4zRXNkQm5sQ0tXSi9ZdURPRGNwUklOeW1C?=
 =?utf-8?B?Z0FzYWlyM3dqLy9KUENnVUk1OHhxVSsxOW1Jc0NUR2hmTUswTFdBYUNHaDhU?=
 =?utf-8?B?ak1Ydk1oVDlnUzV4V3FxTHpIcHR5NlVsUXpmaVFSU21XS0JGWXdVYUIzWmdY?=
 =?utf-8?B?ZE9ka1ZCK3pNM3RjQXRJSE81Q0wyNmphK3RwYnJTYWJWalNpb1ZZSnpMeHA2?=
 =?utf-8?B?NHFWemVQV3dPZnVveHRvOEtMRFJteWFMMjJ6SHJtWmQyclJaY2xuRUNQUkkx?=
 =?utf-8?B?Zk9nNWw3TmkrS3U0MGxFWml6SnhvZXNQVFRjNWhsaTJGendwMFh1QjJYL3JB?=
 =?utf-8?B?Q1Q1M3RCZm5RU0J2M01CKzdxdVFseWVoUU5hK21wSjZUN3pDQjZldHIrUnhF?=
 =?utf-8?B?MFZDNVhxcEVDS1VSdWtzakdjK0RwR21lRFhiTUpnNWJrRXpHbVdScldNK3Z2?=
 =?utf-8?B?V3BrTFNxMGdacnphU1dBdTdjRkQzRmdGNytaZzVMVXNRdFpxdGlMQVEzTDRo?=
 =?utf-8?B?dWxNa3c1ajd6TExBN3pjS0kyVHM4OVVJSGc0d1Q2UVBYVTIvVG10dnYxT1Fx?=
 =?utf-8?B?SzErTU5VRG41MVlrblRLMHVCdmlmQzdyVjRxWkhVaWd5NUkrUkJ0eHdsTUVX?=
 =?utf-8?B?bWltakh4RDNNa3JDLzlQSjFwR0lpVnVjelNKZ3RNSXB0T2VEZFY0MTBHYU9W?=
 =?utf-8?B?MXp5UzhEYUN1aDNIQ0poNmEveUlNeExEMHJiSytUUWk2NG5WQVRyamdxNVZx?=
 =?utf-8?B?Q09hL2VBZ3hxdWtLNGtpb1QzV2JPVnNzVkJXSG9NN0dYUlg3UEtmdTBxMUtJ?=
 =?utf-8?B?TEV3V1NXd0dXZnpRQzJQb1k3S1RMb1pwd1FUQVRDclArSXpyaWpOcklSSmoz?=
 =?utf-8?B?Wk80MG9iY25MUDZYMHM5bzBEckthaEtrcUR3azd2YkhwUWx1dGpWRlZWVzRR?=
 =?utf-8?B?QWViVTREdkNncDEvMnYzNXlUdjFVT2lQSkpMRjlyekZVVk1ZbDBpaER1Wncv?=
 =?utf-8?B?M0w1ZENtQXJtQ2UwVXI2dkV3N3Z5ZFRKcmRQU3BQN3VKRUdXRFRHMW16cWJi?=
 =?utf-8?B?Rm5vSytaazZmb2dPaGVlL00yNDE4K0djZmpSbnk0UW1MOHFtV280TG0yRUVN?=
 =?utf-8?B?ak52eUZyTVRBNXFNSStCWGZ3b0tSYXcwWDJIcGNtRVNhMGc4UndDdUN0ZTU3?=
 =?utf-8?B?Kzc2UjdmYm1iUWlDd2tubHNHQVdJSUtvc3FQa1dNTW9sSWxDTGtJQkxxUVBz?=
 =?utf-8?B?eWZPT3FTR1A2akVRdE96aU5hZ3Y3dE1vUU5tWTZRZmxZVVQ4RUlMQVhNZDMv?=
 =?utf-8?B?d0lOb05OaEpqdTRJYTgyRWE4dm1DMGd6ZlJUSGRoeVQrU2NPZ1dkQjY3TjUr?=
 =?utf-8?B?WUhuYzZrc2RGdUpVQzZXZVIrUEdXa1ZaNzl6dWZDZjJzVlFwcTVKWUgwK2hY?=
 =?utf-8?B?bSsvZjdDb0Rha3l4M0tEclNRYkdqS1d6NFZ3ZUZZRHV3ZjZCTDFmRzBGbERR?=
 =?utf-8?B?VkdwZXY5V1hXVDgwcWtDWDhoS3Qrd3R6NWFhY2kyVVAvNkVrTUcrTnUvQW1C?=
 =?utf-8?B?RytuZEJ0b0xoM2Q5U1B4RXRhWnJlaG0xRGkwSy9HRVRVZmgxbG1INHVwOVhG?=
 =?utf-8?B?ZVRNYzZtWjNSTVBEMjQyaEZTcHNnanZpdFUrRUU0UzlmbVlvSXpmMW54aktQ?=
 =?utf-8?B?QXNYekdidkdaSzZCdC9wRk5HRTJZaS9xbVlWaEwzMFhrNkF3SThUaFhxWENp?=
 =?utf-8?B?SW9DNkZwYzg5dnJNRHJBN015b2VxbW1OTk11NENrNVZhV2M2KzRWdDFhSFkx?=
 =?utf-8?Q?IgofVY3YcXn9B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aCtnNDVMTC83V2dXdkpnN3QrVzN3QWM4QU4wUHFYTHRkazViQ3BVRVVEU2ps?=
 =?utf-8?B?S0ExdWVCSmo2SXZMUi9RMzM3UTFHaVM1M3RaR3JLd3lFOTNTV01jREZzWU9q?=
 =?utf-8?B?YzlnOVNQR3RWbjNkMWtWTEh6MERFeUpZQmhPaytseWdINHRRcU8wa2cvZTA2?=
 =?utf-8?B?QURCUDNFVHVYOVZ1bDlLMlB3QzlxUXh1eHZQVmxJWFFLZ2R0cWt4YjExeksy?=
 =?utf-8?B?VnVmQVUvV05IK3VBZ0tZRWIwbWEvQmphbVI1RVRYRXBFcWtnR1VQbHZzVlUx?=
 =?utf-8?B?SDFqcG41RmNBMnBvOU5uMFhhdytwbE1iRjhiRTk4K01ianc1YmppQTVlSGlI?=
 =?utf-8?B?VHFQLzVyTjB1ME5vc2Y5eUMxTitRaXdCMjJka1d6TTNHYWRVZkdSUThKQ012?=
 =?utf-8?B?MUJWYjhtQ01ZZVgzcHFwM3F0Mjd6OU0zb3Fzak94OTl1aTlOaVZaa1Z3eDAy?=
 =?utf-8?B?Zk1Kb0NMbU0wT1Z5U0x3TXp3bWhYVUxlOWRIYS9nOGtkbzBRZFpESUlwV1Rx?=
 =?utf-8?B?RTZHeHFvUkpXZCs2Q0ZLUkhoUXZyZ3BLQWhuVnVDcVpxZnRBTGpoczNkSkJ6?=
 =?utf-8?B?QjVjZFpMektnd1A3Q0VZcit4QjlPVTZUTDNEbko1ZEZUZHRNOUYyMWpVbC9R?=
 =?utf-8?B?cUlvSmRDdzJ3RDF1amdaQzFXN1ErMjZjSEpLVVdDQ1BRNmVVbS9oQlVwZ1Vs?=
 =?utf-8?B?bnVhTzA4Q3FQd2k1NFpFV2lkR3JmNHU5bjg3Nm9EdGkwakpZUEJPRlVJYzZZ?=
 =?utf-8?B?QmViRWtFcFdNTnBNMUxLN3ZPY1ltTnRVRnVTcUlPYW9kZ1BYOURrRVZWSk03?=
 =?utf-8?B?UzdGc05JNVNuZXpJUnJobldLVWlCenNDRm05VkFKQUNGZHBzOUFyL1hUL2Nr?=
 =?utf-8?B?TEtwb0thbEh1L0xKOE96S3V6RThZbTdCenFSZFEzdjRuZURVaVYrb0ZuMTF4?=
 =?utf-8?B?YUZBWVh3WFkzbk12MkhIY0Z6L3dYMTZ6QWhtKzhybWFXV3J3cXA0OU1ERWYz?=
 =?utf-8?B?b2laWEczU2ZQeUNPQlorWHIvTk52bWR0SXFBS1FGbjB5LzhLcitIek5wWXQ2?=
 =?utf-8?B?NE1iZDM4b2ZqdlU0elhiMk0wU1gzNnpTMm5yMk9DY3hYSjVaVGhZSElxZFRu?=
 =?utf-8?B?WWtpd2xzcVlrMDJiMGtaUTZRRXpzR0ZqUEE3bzUxT0Z5Y084Qk1IY0NaMVE2?=
 =?utf-8?B?eng2WFRZald2MWg0TDRZaWNYaElmTGljbHF2aFBSY1JERXR3dm1YQUpQS1dn?=
 =?utf-8?B?RXF5NEttcU5pZmhXZlAvM2lzRHJJdlN2UW5hMTQxUEg0dzgvWk1kRVJZQm1j?=
 =?utf-8?B?N0RxM0k0MytNQ0F5TVg3S24yZ0doaS9JM0g2dDNsbllCL3ZkdEpOekFlcUZk?=
 =?utf-8?B?WHc1VnkyUThUa05RM3NCaWZ4UURXUndIYVo4V0V1ZzhEZkZhNEVTQjk3TDBj?=
 =?utf-8?B?RTVVcW5IL01ZZ2xSeW1iYys5aEdUWE1PWWM1MzVaRXB6ZWFpWVhkRFhSUXM2?=
 =?utf-8?B?ekJ5UGZ2SGhWQ1E1YmlFZnhSVU1qeUlkZFlPdmM5c3NRREljSUZvem9QTExL?=
 =?utf-8?B?ZTIzbmRHT2hCTDZUZC9xLzF2V09uZVlkZlREanNITlZmSmxRSVNjUitHKy9z?=
 =?utf-8?B?b04yZDl1RU5UT1dPb3kvSEdDTGErOFRJOTdFeWN6WnhSbXAweGZLbzNkSjdU?=
 =?utf-8?B?WUZvLzF1STZ1Y0dpT1lRdURtM3B1MlJzcHYrQTdGaWh1eWpzMlhwdjM3VWR0?=
 =?utf-8?B?UUlDa1gxbTlPcG15MHpPWUN3WUNaR3hRdFB4dWtlcURXNWJnWDhadUoxc3dl?=
 =?utf-8?B?M1RmNXJyaUhERW1SYStia2VxVEdGU2loeXVPS2ZUYlFxalBlV2J3YkhBVVdR?=
 =?utf-8?B?Z3owdmlvNStKYWpLNlNGbFlFMzVMTDhsTWRrUkpCU080ck4zeGxaNEpwV1di?=
 =?utf-8?B?aHhHdmY5NjVMVHd1bUtGQWJWQm8xckRKOFpWVDRBbDJ1dXBQYXBOZXM0cGN4?=
 =?utf-8?B?aTNlQ3ZkM0ZNWFM5NmhKYmk4bTVram9TRlJrdHNnYU1ZUEVUT3kvMFRsSjRO?=
 =?utf-8?B?WjJmSFgram84L1lJZHl4Y1ZiUVJkaGFlUno5c1BFdWxhWTFPUDA1b0VKMVY0?=
 =?utf-8?Q?fD7md7R0mXEH5HHl6N5rezQaH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c329686-815f-459a-3909-08dd2a48de66
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jan 2025 09:44:21.7505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KoakbAiYyvYkHBVJUzHcHqJdfjV73Zc5lsMLP8MB+uloSTL9ZZt33YrhIvZGD4uObDwJDWeXKUMaxJVUSjZgCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8784



On 12/30/2024 10:34 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:44PM +0530, Nikunj A Dadhania wrote:
>> SecureTSC enabled guests should use TSC as the only clock source, terminate
>> the guest with appropriate code when clock source switches to hypervisor
>> controlled kvmclock.
> 
> This looks silly. 

I can drop this patch, and if the admin wants to change the clock 
source to kvm-clock from Secure TSC, that will be permitted.

> Why not prevent kvm_register_clock() from succeeding simply
> on a secure-TSC guest?

Or we can have something like below that will prevent kvm-clock
registration:

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 39dda04b5ba0..e68683a65018 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -151,14 +151,6 @@ bool kvm_check_and_clear_guest_paused(void)
 
 static int kvm_cs_enable(struct clocksource *cs)
 {
-	/*
-	 * For a guest with SecureTSC enabled, the TSC should be the only clock
-	 * source. Abort the guest when kvmclock is selected as the clock
-	 * source.
-	 */
-	if (WARN_ON(cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)))
-		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC_KVMCLOCK);
-
 	vclocks_set_used(VDSO_CLOCKMODE_PVCLOCK);
 	return 0;
 }
@@ -352,6 +344,12 @@ void __init kvmclock_init(void)
 	    boot_cpu_has(X86_FEATURE_NONSTOP_TSC) &&
 	    !check_tsc_unstable())
 		kvm_clock.rating = 299;
+        /*
+         * For a guest with SecureTSC enabled, the TSC clock source should be
+         * used. Prevent the kvm-clock source registration.
+         */
+        if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
+		return;
 
 	clocksource_register_hz(&kvm_clock, NSEC_PER_SEC);
 	pv_info.name = "KVM";



