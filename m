Return-Path: <kvm+bounces-54544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A84E2B235A5
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 20:52:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22B3E7A806F
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 18:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED17C2FF14D;
	Tue, 12 Aug 2025 18:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hj3Zf3kM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2A920409A;
	Tue, 12 Aug 2025 18:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024753; cv=fail; b=SWQvYIii61RWuxOnQT/xjT+LCbo24FQV5Dc51Sc/knPm2D2GZGlFO14bavVxRDCaNj9GSBfUIMeOahTONM4O9yla5IOAynfX+5NDITycoS6kCP18u/4x+eZfj8jdkwyzbwtQVejPWx8TDhLMkFRI2ZiKgH1PqlYLfDe1bOdeNVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024753; c=relaxed/simple;
	bh=oq2JuXCDQejDxwCoWgOUkN4LsKxsDUD+zqcHlae2r3E=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iBFgp+K8yaHP5cxTW2dLdQBlWaB2um8uaEMDD8NDJUGZxlN7FtpUdm/8kCeCSAUYxWnS+8pNE9jTWdx62wIG1GBEi88fbjtxM3o+qr778qr1rHdk5spKq/1thjHWrA3nByGgrd144CCi9YfVV9KkSutemQTtex0IO+JHdKhe8CI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hj3Zf3kM; arc=fail smtp.client-ip=40.107.92.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bzCnrIGj/bpFGKI8sNRzR+Mdhm/5ypJh4QLgP1oJhA6pGSGXHLzwXLPnXH9aPv7wvaO15lROcqViqQopVNldtK78HFLKv/aGlA97n33TRTCdOLgp0Izc81J0Ey7GctYxSJVQoNULStU6XL0aR7ArMxDT1PrIyFDOVZQCLUhvXv8d+/xF1Npv2JX42dOqkvF/gxVB2m5yS5STohAQDEFhOECVOOrX1UPgNS3Fsx7gon35mJO4nvUA0IHyR7s8z7fwlwbpHQXHafOEdSpghl4EhpWug5vrnqHPnS2uejmCCL/o5SMGokLQJ80cHa3hQZ/T5pEoo7D68bA76gTCbUjE2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+NO7HDzRhBu9wPJUiEQmPk1Nos5687tqou5pvfeqkA=;
 b=K52nH94nUcdoDA2q70TaS9Bx79j7Du3hY+X9UrZJEzsOoGtUaP161C9y7N60X6xki9VS4MjVOGO2hO9LH0BDHDUVVT2+0N1M6f/oSaxrPJ6htjXsJYQrTXZKdGdQtgalpHdUT/qDkiOOfchaEwEO9WQgk5kYALfjVZkYrIIdxlXdQbkv77nznvbVB9zwUtrwP58UCAnY09jX2wjvlOtW4+SziYDpseLabOY5I66gpcxq2zDzR6dMrCxTpdR0eQTJGf9mF2BUXpAioX0D2iiB+q6KQSF2JETDZ3a+4EPFzWn6jfF/O2WXMxYzFzSHgUxxc8uGmsRIL7D3wsaWuS4YbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+NO7HDzRhBu9wPJUiEQmPk1Nos5687tqou5pvfeqkA=;
 b=hj3Zf3kMizrUse9vArRsXJmI9YwonyEGNFSIRzwzvfzWj/K4iklKt9aAfyHvIsIlZrvr0as4cZZatiMmz/NgEtfxP2YZq6im4MTGY1a+Ux0C+Q6OGaJR8EhQt+EunxYIxqiinVnCbZx0RFD7kgZe/ZqyRPXgYIqzCHwM7RuxGfQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5)
 by MN2PR12MB4439.namprd12.prod.outlook.com (2603:10b6:208:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Tue, 12 Aug
 2025 18:52:26 +0000
Received: from PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f]) by PH7PR12MB9066.namprd12.prod.outlook.com
 ([fe80::954d:ca3a:4eac:213f%4]) with mapi id 15.20.8989.018; Tue, 12 Aug 2025
 18:52:26 +0000
Message-ID: <5eed047b-c0c1-4e89-87e9-5105cfbb578e@amd.com>
Date: Tue, 12 Aug 2025 13:52:19 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Kim Phillips <kim.phillips@amd.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
 <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
 <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
 <29bff13f-5926-49bb-af54-d4966ff3be96@amd.com>
 <5a207fe7-9553-4458-b702-ab34b21861da@amd.com>
 <a6864a2c-b88f-4639-bf66-0b0cfbc5b20c@amd.com>
 <9b0f1a56-7b8f-45ce-9219-3489faedb06c@amd.com>
 <96022875-5a6f-4192-b1eb-40f389b4859f@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <96022875-5a6f-4192-b1eb-40f389b4859f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0134.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::7) To PH7PR12MB9066.namprd12.prod.outlook.com
 (2603:10b6:510:1f6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB9066:EE_|MN2PR12MB4439:EE_
X-MS-Office365-Filtering-Correlation-Id: 99dd5db2-f4de-4b4a-de4a-08ddd9d16115
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QTUxcVNYTVJCYTZwUmdlMWgvb3RzN0ttdjJvYzRGUk80YjZSWkRlaklWL1B2?=
 =?utf-8?B?RlM5Ym1Kelh1bjZGSmlQelpPcStmV0NNMEljUGUzUUVUZkJ2R0dqWlk4M3lu?=
 =?utf-8?B?Z1NzOCsrMjZYZWpGMXJ2aCtlK21vUk5ZaDgvbzBuU1BBNDM2K3RMYUY3RGFa?=
 =?utf-8?B?RTRMSTNmOEdPc2xWcEpWK1pCR2d0UEx3ZS9wOGdmeHA3NmVLZDNtVGFsbWdB?=
 =?utf-8?B?UTNnR3FtR2djMlhIZ0JYRVozb1VHd2JJZEdJbnBmMGMwT3pIcTlmU2NsdjMw?=
 =?utf-8?B?cjZhRWZMSjUxdUU2MG1YZjB5cGozTmZYQ0tpWDlaTXpXZE5NNlNmV2Z3Q2Np?=
 =?utf-8?B?c1d6VThUQ1htb2dvT095RjFXU1JDdzROSTlMaEVYNEtPamROWjByQkNEajhr?=
 =?utf-8?B?UjUvL1RQTWpTem51RUZRMXJUbUtYSnBvd2E0M3BTYnF2VjRpa0E1cVgxT2I5?=
 =?utf-8?B?dGZyQm90VEVQUXA1bThXZjhEMXVmczZFc1Y4RWFkcVhvWEg3Q2NsYmRKZjNZ?=
 =?utf-8?B?ZnlRTTRLL0pUQ0pRWTY4RmpraG4zSnpsM0dwbUtINUdMQ1VZQ2Y3d1VwNlRX?=
 =?utf-8?B?Y01ZWWM5dWZqcjl0MGJ6WE1ON0sveEtLakpvcFJZbHpVakwzNzNaOVpmbW1o?=
 =?utf-8?B?SVpkRlM0aUlTYTdPNklqVjZFNS9YbHlJeUNFOGVsRklaaU9LdHBJdHZHcEJ6?=
 =?utf-8?B?UCtZN2lVRWQxUXNCR0xqOE1OaENPeEc2WUthbGlic1cxbkVzeHJ3aGRmQy9Q?=
 =?utf-8?B?Y01mTFQvaWdGUXNSTjVTUXc0S0loZm5jVFNkTUxsR0U3RVF5VzdLVkF6K2sx?=
 =?utf-8?B?cjZrUmh5TU9PRHR6eURIdmZYeVlSNnVQUWplSHZmTGRsMkNWV1pLWjM2M1Fr?=
 =?utf-8?B?Z3BmMzJQRzhFMm5RVytWdVBYUnNra21TUXlFUHB5MTMwN0xCK2YwbTNWaXd3?=
 =?utf-8?B?VVp3NmMyeE5IT2VnL0NIOVFVNFFHYWEyM0hXWEVXa2JXaU1zblRKTUpISS9N?=
 =?utf-8?B?QWNFY0VBWjBKYXA4SCt6SnFBMlZaYWRjYzFRcm13WmpiekN5NngzUEc0Q0pG?=
 =?utf-8?B?bkxDSnd6K1o2L3RMMG5FSFNwTW9NNUZsR043eTArazNnaWJDakpBS0EweHZJ?=
 =?utf-8?B?TnJ1UFJ4dkZQQW9hMlo0bE9XMFBYZVhLYXdCU1huMlRTbjdJend0QnB3djFv?=
 =?utf-8?B?NldZamhkdFBhcGF5REY1Z3M4SFF3a2VIQUhwRXBnWXMzU3NsTDl3eG1XemhC?=
 =?utf-8?B?VTR5SDZ4MEFqOWlMeE55YW1CUU84c1VhVkxSUUFuUFBuZ0RBOFl6ZUduZWZs?=
 =?utf-8?B?T3lKeHFtNjRFQzFEVjRBNkNhcmZnODhQempITGdFVW1KSlA2aGV0c1I1cTZk?=
 =?utf-8?B?RlcrZUlpL1MxOE1jWmh4VEh3Y3pSVDBiUXkzSGlqYmdDOG0wL0lxZHI2NjRO?=
 =?utf-8?B?NG9WWUFhdTI0SlJETzJETFhlckJIaUVIRTdsblBYUFBUTk1zK05xVGo5dlI0?=
 =?utf-8?B?L0pxVURQT3NjOURWTXdrMlVLOEI0eDFLcVNJME5ZUUl2dGdCRXQzN2hFdjJF?=
 =?utf-8?B?NTA1ZzZmdTAwR3hQdzNXY1R2NmxKdTZuVDE3Mk1VWmpZMFkyVEQyY241aW1k?=
 =?utf-8?B?MFAxakt3b3FUWm92eTc4cGxNNmdocVdkOEtsdnlqQWtVdGdTUXlUcWMwa2lp?=
 =?utf-8?B?cEtQQkY0QnVNM21qZlJPdnFmN3lzbTJ1cmZ3bmVrbkxSNVZBTHkvcTl4ckUx?=
 =?utf-8?B?RjQvMjZsd08rdnp6OEhHV20rdzBIbVdIU1dFb1djcGVOWFpVZDBRWHpVZHhS?=
 =?utf-8?B?L1E4VFNPNjlDcTdCa21pajFXOUFaLzF0Y2pQdE00Q2xXU0Z6NC92eWdmRWVM?=
 =?utf-8?B?YlN6SzNBRFRnUHN2ai8yU1dXYmMwTnM3bEJxRjljRmI3MDVLT0ZZU1Y2V3lP?=
 =?utf-8?B?RWJiOHovWUs3RFYrQ2RjTFhxRDJZTUVYcGVua1YvNTN3bkFiUWQwaEhaU3J4?=
 =?utf-8?B?S2szUmgrQUtBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB9066.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVR3eUZRKzFKNDd2Mk4rSWtlOEdLdy8zZll0K3dzaFltUmRNQkRUekpZcGpu?=
 =?utf-8?B?cjRNaE90TzhVVlVYN0ExOU5jZDhBaUhzd2xuaEpHWXJKUFZLcklhQ01hSVpi?=
 =?utf-8?B?VmdJTDRTTHBOeVY5ZGZEZU1XVWJLeTFqcGJCbHVtMUFxcGkwenJEVDVYOEkw?=
 =?utf-8?B?WDZnNnA4T2YzOXBianZWcW0xdU5YamMxY2N3bm1QaUtBaEIyQzhhLys5K3g4?=
 =?utf-8?B?VWROM2lFNnB4TEtOMGlSQVVWMzIxTDJWZEtjTXovMEVZY0t5cWtLUytqYSt2?=
 =?utf-8?B?R3JieHowQ2RVTGQrTmltbUl0UXdjTmhINDJFQVVEVjM5Z25zVFR2SW4zclk0?=
 =?utf-8?B?SFRSQy83dU4va0pSaGFBYkZ5WnNaMnFPSUNKVlRRNmVHVzYyVk5Ja214dmc0?=
 =?utf-8?B?Z2IwaUpOUE9aYTlPd25IempwcGd5Q1pRdmNjY09QeTBGZHFmQVhUQ0E4SjF2?=
 =?utf-8?B?TDlVOXU2d2s3bHRJcnZMdXVmU2JkNnF5alJxU0tuTHArZFRpM0ZpTExBMWRH?=
 =?utf-8?B?djRkbEhmR3pCM1pIUCtNNS94eDZTNkZFaHdJVjJUWklHbzlsWHJsL2IyMERT?=
 =?utf-8?B?SFJDNWlBZEJseUl2TDk2ZXpXTWlmK25uV2Iyd3pHcFB6eDNoK1RHTmtJYnp6?=
 =?utf-8?B?dklxZnRFMzhvTFZEV1ZKTk5zbkYwMW1LVm05SFE3ZjFocE1jSnk3UXptVnU3?=
 =?utf-8?B?UHlMbWtJNDV1SHgzM2VVdStxNUR0VkduWjZrNmxSR01oSXQ5ZG5FTDlVOGJS?=
 =?utf-8?B?b2pFVEQ4bnY3aVdxUnhqMFc4SXRNVHJZeklxaE45M0xEUHpKY0lZLzlGbkRV?=
 =?utf-8?B?OWg5dVZGV3R5d0Rlc1BUVFppUmtKanZXUWpUOG1jYkF0QlR5Rzd5UzhqNzhr?=
 =?utf-8?B?NkkybnB0ZVZkOVJjUjhqdHdTaE1zNEhueVhISW1GTjdHbDhjOGtyaC83ajIz?=
 =?utf-8?B?YU12ZHVRMXpnWVJqWU1TYmlZY1l4dzVHamNPYmxJZUZYZklxQ3VJUWhYVC9u?=
 =?utf-8?B?bU1idDJoSXhPcXUrOVJzeVdDYkR5ZjlhUjU0ZndvZDBnTm4yUXBNcHRHNmJ5?=
 =?utf-8?B?K3ROWC90K0MxRkR2Wm5IMGlQcmNvbUcxQlc0OXRqZDRPTG03UHhBSU0rbWFL?=
 =?utf-8?B?V0ZRQk80bEpGQjJobU9ZanM4KzlaRGZkUlBHT0N1QWxLaW9PeHJSL1I1R2hR?=
 =?utf-8?B?eDVtOG1ZMlE5dGc2akRsU01zT245L0ZLRW5zYmNoTFdhSUM0NjhIUHVtMzZZ?=
 =?utf-8?B?aWlRbXFrT3JmM0lEL3lzS1M4VnVmNmF6YTE0elhxbE5ZdW9URlFoUGFma2Fi?=
 =?utf-8?B?c016WVEyL0JLb3RWMFRLNDhMUkNoZEVoZ0JoNlFnMDdsK2Q3YjcxVmt6aTFT?=
 =?utf-8?B?QldoT3JDS3k1b29PVGtnRU1WaEN1QTk1TlZrdVAzMGRTQW1DWE9TVVNxUkJU?=
 =?utf-8?B?Y1dsMWs4Qm1ZT09RcDlLVGkySCtZdnA2Y0hvbDlEQ3dpaXNFK1RxcU5rQzVL?=
 =?utf-8?B?VVRDMi9VRXFGV285RENnelN3K0F5c1oyQUlxMVVEVzd0cHBoWmE1STBpYTRx?=
 =?utf-8?B?aEJWSEEvb1ZTdlhEeDJSbDYwV1M0Ukh4bkxkSXlXWXh3Q1ZURG02MmV6akVy?=
 =?utf-8?B?czRUV3o4cmlSd1JVOHVaOXp5aUVCcjNTWCtad0lkMUFmTlg0L2xrV05VMlpR?=
 =?utf-8?B?dDk3N2RZV1VYUTZBQUV1YjY2RXZGS28zMDg2eEdxYmNvdEZucG9BNys1dFY1?=
 =?utf-8?B?QzZ4ZW9oa2VoaUNFSjlWdGdmZjNmcVZRYk45UFNmSU5SVnh4Mkt6d1RMUnp1?=
 =?utf-8?B?TGZxUFZSVTlVQWM1VHZXVXFmcmNVSXBibmJEdFlGVjBBYzRrdzJ1ZDg3OWxS?=
 =?utf-8?B?NkdQSDNhTFYxYVh6cmx3UFFjTFlOWGt3Qk4vZWtwSUVrOWtGdGkzTDliV0lv?=
 =?utf-8?B?SkZreUJYRU9aNjljZ09nQTFaUUZZQ0o5c3djRzk1WStWV3RXd2dtS1gzVnJ4?=
 =?utf-8?B?VnNRdDI3eXhlWXpBOUNZUDhseWFFcXVFMFVPZUgzeUxmalV2cUFXMmtZbVVo?=
 =?utf-8?B?TmdKV0tVTDhBOCtheDk2UTU2a1UvWmVaTDRqSUNQNkpnUVN3QllkZ3V0QThD?=
 =?utf-8?Q?hk4emXFEraOWXDiGNwmmZ3nS9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99dd5db2-f4de-4b4a-de4a-08ddd9d16115
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB9066.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 18:52:25.9154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFGKnq/51XVuBbpxsNrHHeWg5bBeU/bdJjP50YpzbLhcvp1qEpId3umVrCsrk/wGrRTT+xnXhCy+XDsizXMOVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4439



On 8/12/2025 1:40 PM, Kim Phillips wrote:

>>
>>> It's not as immediately obvious that it needs to (0 < x < minimum SEV ASID 100).
>>> OTOH, if the user inputs "ciphertext_hiding_asids=0x1", they now see:
>>>
>>>       kvm_amd: invalid ciphertext_hiding_asids "0x1" or !(0 < 99 < minimum SEV ASID 100)
>>>
>>> which - unlike the original v7 code - shows the user that the '0x1' was not interpreted as a number at all: thus the 99 in the latter condition.
>> This is incorrect, as 0 < 99 < minimum SEV ASID 100 is a valid condition!
> 
> Precisely, meaning it's the '0x' in '0x1' that's the "invalid" part.
> 
>> And how can user input of 0x1, result in max_snp_asid == 99 ?
> 
> It doesn't, again, the 0x is the invalid part.
> 
>> This is the issue with combining the checks and emitting a combined error message:
>>
>> Here, kstroint(0x1) fails with -EINVAL and so, max_snp_asid remains set to 99 and then the combined error conveys a wrong information :
>> !(0 < 99 < minimum SEV ASID 100)
> 
> It's not, it says it's *OR* that condition.

To me this is wrong as 
!(0 < 99 < minimum SEV ASID 100) is simply not a correct statement!

Thanks,
Ashish 

> 
>> The original message is much simpler to understand and correct too:
>> Module parameter ciphertext_hiding_asids (-1) invalid
> 

