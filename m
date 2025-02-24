Return-Path: <kvm+bounces-39047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA5A7A42E8D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87539188166F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:03:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D571957FC;
	Mon, 24 Feb 2025 21:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZkYF3d2d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE531F5FA;
	Mon, 24 Feb 2025 21:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740431007; cv=fail; b=SfkalLS1F/c3M61D3EK2/3M0PQNMSDo+kDSRvvFxZ4L6w8/wVcvBmz2ionnZnAiPvP1nuh1/NuxJc2u0OkTcfPGHbbCFBrMTdYb0TE2wo2cCJ1VQiYCIACaOPnu0jNoXgcZPCxL70bTofq11iunTl/cFxJyUh14wCJ/yA3YQR5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740431007; c=relaxed/simple;
	bh=T4bM/N1mzlDJtzTe58Ixs7/YQ9D3cR1h/iZTdzlRJ9c=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=QttFvbXpg2VgDTyFbSq+1xNZ3wyFgfgLc6xIQOLVVgmfi0XKFInRquoyjsplHaAVpXNqO4QncmmpAvrHwDARta/q+/j43Hy8smRpDA4qUfd+vmrfSVHXkX1MgedLzS939Fw1/SfbNuBhMIoqSI+4CkAn0CotpxI04rvY+OW7Pyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZkYF3d2d; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rtj3vTjzmxPNnLTJkQNmdcGNVNKCGm7jkQ5HKOCUlX8/TYGG+kgRyT2SK4x2fnxWnhZt453D6+KhIppU9revXz6KH3AMLNy6CXYqocrwL5LTgBEY4ON5/pdJWGRXJ9uWvKj+tmug3UeC/9PzCdPbLIG6YG5g/s8YIgLfvrNQHG8v68FPFaG3ZX/edQDOFk7L2iJPmJCf24R5TinbvLjI3IPYG/DckRhDn2BYl0Fe12mkgBS74qizRYz0+MFnaNwsoKYRaIvLszpeaXkD4MJjAxV04fTxOwxZS8wmPDuZfZYGLi4P+kShKUaPkGyflzXbZ6IkDkQsTbH+8U4/a9RVww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RFZFWBF/vUAv7pI9XEu3QHhRL3zGwnM6Ii2zCydY13M=;
 b=NNIGofwx8sIrBkBQWS9adNF8JhXxZQ6kkLG+4/C7Be+4M32K54kPrJwaOEXqRICmZW9/STUwH+eYGV9BTa08iuxTMbn9P3eyft9LU3s/BiCF9wLl8bo1ZxOrhFqWbYeWfZahjU7Qwi/EdP5B5ogPO8Td9XWXO3eEuzvRXrlmxjfQuQRDN8c6/APQs3+mQBTXgiPh5kYzymRppKFDhkOgC/QsLEE1rcaNtfh02sTOBFdhxCH0Bqg33aFdV4eURxUODwS2uIKQ4UcCHKpjyFWXTrmSOvHAaeYyk9olSJvwkETiPUQMolj1BG82ORQkoP4Pr25uaCRJejmizfNHxa+njQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFZFWBF/vUAv7pI9XEu3QHhRL3zGwnM6Ii2zCydY13M=;
 b=ZkYF3d2d3mzhQ/9SFMthSecXzMv0hH408fZaqMx95+gBoYDCAwRQlyYg7t9j68m4Ibp6ZHrtwWQbi7fwuWQQVxi7HmebS65yWtH6ZxaKfbQRQih4lWGO8d88jhaB8FfQ2BS/s9F3TusG6MQ/LUiC8dK+1fdEOxpSZqqhazLYETw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BN5PR12MB9462.namprd12.prod.outlook.com (2603:10b6:408:2ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 21:03:18 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8466.020; Mon, 24 Feb 2025
 21:03:18 +0000
Message-ID: <4e762d94-97d4-2822-4935-2f5ab409ab29@amd.com>
Date: Mon, 24 Feb 2025 15:03:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Naveen N Rao <naveen@kernel.org>, Kim Phillips <kim.phillips@amd.com>,
 Alexey Kardashevskiy <aik@amd.com>
References: <20250219012705.1495231-1-seanjc@google.com>
 <20250219012705.1495231-4-seanjc@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 03/10] KVM: SVM: Terminate the VM if a SEV-ES+ guest is
 run with an invalid VMSA
In-Reply-To: <20250219012705.1495231-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0228.namprd04.prod.outlook.com
 (2603:10b6:806:127::23) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BN5PR12MB9462:EE_
X-MS-Office365-Filtering-Correlation-Id: ebbb19ff-ad5c-484a-9c9e-08dd5516a9a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S3MyZ29nWmhIem82RFVCSHFTZldFSkRzSjNIL0dmSC9Fa24xSUo1UUh0N2c2?=
 =?utf-8?B?S0Fka25xNm1QRC90VVlGeUt5Y2ZhWmlMakVxUm03dWRiT2tUVzNyc29sdmFQ?=
 =?utf-8?B?eWpHeDB3MGRTRzVGdFZEZTBmZFlOZ0Y3dlNud0czekVnS2dBaUVxTmlLOVB4?=
 =?utf-8?B?N1dXRTN4Q2FGMHI3MDVVd1BBWEU2dUticmJrdDRqL3A0NG02NGRoNU9wOElo?=
 =?utf-8?B?U1pvQ2xoWXVyZnBKN0hWWG1QZ1JoUFhKbmJxQnNleVlvaTNqRWwwbmNVRXhh?=
 =?utf-8?B?QzNJUnhPY1JmSzBEaVVyVFVNL3hxVXUwa25zbnVTMXJWTjFiKzFiTGhiMnow?=
 =?utf-8?B?ZWdRMUVoSWt0SGloSHdHb1BFeUdDU1RIMzZrNjdjdzgxVDc3MlBxSm9hY0t4?=
 =?utf-8?B?cHVtL1dxL0ZKRGR6UjVMdlVNQWoxS3RveS9qZjMzVFpFTnJKVVpXU3JTU0hF?=
 =?utf-8?B?QjNyNlRFMVNVL0kwQUF5OXhvL3FKQ2F6WjRRK1c5eU1UR3EyREVUbDhsVFcv?=
 =?utf-8?B?UStaYTMyUVRrM1V5eHBlSXJsUGJwLzFWekNXTFFEWXI0MDNhVUdhWThhU2hK?=
 =?utf-8?B?R0NIVU0rNzFGcUN4N201T0pnellFM0Faek5XUlBmSGhxNitUaVRBaXdocjhj?=
 =?utf-8?B?ZVlMb3hoZm1uZkJ2MlFaUVRVN2VVWDlCUFpQSklqamx2WlJQNEpMVVFFK3A2?=
 =?utf-8?B?VHZRd2dKSjdoajRCQ2NCcFJqbnhNYUlxWXZOM1V0Q3M2VUZqTjMya2ZSdm1E?=
 =?utf-8?B?cnBMazlKTGJBSVdFa1VldUdwSG9VQ1hONDBtN0xkQ1JvbnVTNkVoMFhGeFVZ?=
 =?utf-8?B?NkhkZEI3RGdkcDIrM3RKK1hacDRCSW1CUEMwREVPUDVDb1haSXp1WEMrYUlz?=
 =?utf-8?B?MHBMM2hTa1dGbER4emh1bytnWVRXOWpjSnd4QjV5TDB4eVJNeXlrWnIzOXlO?=
 =?utf-8?B?VWtPL1QzQWczRms4N0RUdkhvcGxncTlvMzNEK3UzZU5SNmU0dXhIQ2t3bTJt?=
 =?utf-8?B?WEpuTHpXbkk3NHZzSkN5VnVCbnRyTEdIWHQ1L1dRNnhJZEVSYjN4TVpEbDVl?=
 =?utf-8?B?S2hqT0I2L0h0UitsMHpiem9na3Nrd1lZSkpKbnp3QU9ocVlzWDd1VjVjMGc0?=
 =?utf-8?B?ZnVBQmZnK1V6U1JtZEEvNlk0ODRKazdvRzZmS3pYaW01cDM2QkcwSHYzN3BJ?=
 =?utf-8?B?NThyc2drbldCVllHMXNOMDdDR1ZnbTlFM0dDUDdJdHRhS2VoRXYrOUlUWkVj?=
 =?utf-8?B?WklHbURWWVNDalJ0bGVlZm9BQkNRM3VtYTZqOTZyeXFIWERiM2RMM3daczhC?=
 =?utf-8?B?ejZoUWF0QmRNb3ZXVUZ5dEZUUkxYb1hYN2o3bWJ3TUhvUlowUDdERlFkOFc5?=
 =?utf-8?B?SFp2UnNKdFpKR3dVU3UvYWJJVTJNd1E5SGM3aUQyMXVMN2dqZ3hQQnRJVi9y?=
 =?utf-8?B?UWxsTURPVy9ZaGl6bXB6NjV5TVpQdGxLWnd5TEh1bzZ5QUhLWUZzdnhBaWU2?=
 =?utf-8?B?U3hrTGptYklHVnRlaEJpZTFmbmFhR0wwVTdNRWtQREFDekVSMWVKNE10aE53?=
 =?utf-8?B?MHZwY1BnNlVGS1dvYmlvTFVWYlVLUCtOVEltRVVKb1oyc1ROMDJ4d0w1ZXlm?=
 =?utf-8?B?ZVBCTnB5Vy9tUWlSblRqWjZHSG8vZkVoMEk5WkxtWWZVdTVYdnNET2dLenZ5?=
 =?utf-8?B?ZFdNUHIxVVRoMndNVUs0bHJrVzA4THp5c2FjbUFXOU1WQzMvc29ObkQzNWI5?=
 =?utf-8?B?WHhmSTVKYW9XWDBSNnVmRGs5ZmtFejhUcnlTYVo0R0xjRVErSXQ2VENpajdO?=
 =?utf-8?B?TldjbFNwbFgza1FnRHpVUFJFeHI5eTZUdWsyMWlRSFRXTFlTeStjYzVZTjVR?=
 =?utf-8?Q?pB2J1haGVCEcd?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWgzU2UvaHZHc2RES1RCYkNHbWxEdUNNd21WUzBTTEFzWG00NTBzQ1dQWks4?=
 =?utf-8?B?NkJhcTdwSVZLT0QxemYrTXhZMW5MMzlwazd1RmxiRzAwdlA1WGNqUTlWZkl5?=
 =?utf-8?B?ZUJlNDFwR3NvNTk3ZDRlMU1kRzdjaENRSnRIeFp3UkpodHk2ekNXSnNDK3R1?=
 =?utf-8?B?OElUM0JDOXBtL0RpZ1k1WFNSQ2N0dTRWSGVYUnMrNUNHRk0zeGRnWHB1S0NQ?=
 =?utf-8?B?WkhOTWpYSFdoL2cvd1RVY0hjaUk0Mk13OTFLYjNtcWRVMURCbWlNMlExZUNu?=
 =?utf-8?B?Y3dwekFYZ3grREFuZDJIZC8wWmwxN1JvRUpBNm4wdjBEb0w3V2xBSjhsSDlN?=
 =?utf-8?B?bHJpNUw3ZkFmTmlGTUxTMFZtS2hVWGhLSjBZZFpjUkloczV3QVN6Sk1qTHNW?=
 =?utf-8?B?V1ZpdnRHTjYvOWQ0RGtaRVIwQW9yRjliUU5QMzJJemZZMk94THJ5U2pIeUxI?=
 =?utf-8?B?K0pmK2J0VHl4TkhlK29JSzNKdFFnZ3NwVmpyZ255SWFhMjBWSWRXb3dvZ1Z4?=
 =?utf-8?B?enFONCtSc2RDYTltQmZkNzY3WHVwQU1qT1Nva0diN2lQUXlBNWp2T3JNSmdX?=
 =?utf-8?B?b0x2M2tKK29iaGZGYzRxSTg3b0dOdExvcDFXL0YzamhQUmxNM21KZHdGcE9k?=
 =?utf-8?B?U1d0TE9GTmxra0JTVS80UnFzdnVPd3p3R0xzQVhWdDBtTzRaUDhYL1c1R2xI?=
 =?utf-8?B?MzNNTkVOdm5RSzhxelFQOWFQZWMyWFRmTDc5TU1OTkhjRXJtNDRVMEhmS1VK?=
 =?utf-8?B?T3FkejRMd2NyVHlzc1UvanQ2N2tZQm9UeDJMd1lybVpaL0JVSkl5V3U4ck9H?=
 =?utf-8?B?VVU3QUpaeFgyOUs2OG5aWEJUblArZHI4RFc2K0pHRGwyOGlqY2xrblhSL3dG?=
 =?utf-8?B?anF3SzJQWXV3YytpVWtPQkFDMXVaOHlydXNROVZVdTFQVElmUU1DWCtTY2dP?=
 =?utf-8?B?ZVdWT0hwMk8wc0RXQkxhS1cycG5jR1dPTUg0VTNYc05laURGc1Rvby9MbkFM?=
 =?utf-8?B?bzZKYmlPS0FIZ2xpajhoU0hJLzNxV3YzandsOFJXak0xRTh2RG9HK1c1R1NW?=
 =?utf-8?B?amlibTA5dndJTzBwZTJyc3NkWHZtU3lTTWg2TkErNm9oSzMvKzk4U0VnWTk5?=
 =?utf-8?B?ZTFTT3AwNFR0NTNqbDdNUTFpMjBQMTF4RnVlaW9sb245VVJsaWR0eXhISXdF?=
 =?utf-8?B?ZStvY00wL2k4dDIzS0JOcGZuU0xiUGlWeWVqS0YxUTBvbDRGZ3BmdmRCOVp0?=
 =?utf-8?B?eFg3dm9RV3pucUpMczZLeUFBRkp3UUQvYTRsYSt3d0l5amExRnNMZVVQZzVX?=
 =?utf-8?B?RXpkQVorRTRPeGl0ZjNFRm12Y2Jpc2FWUWRFRE0rSmErdGJXUDlIRFZOWUZz?=
 =?utf-8?B?amkzZDd6VDk1bDhVcUhCQkFSVy9BVUlsU3pGVTE4SS9DQVMrVjBnYU40dXVu?=
 =?utf-8?B?MUozTzJ6cmt3ME5BN1F2UzdvNVZnZ2pTTHRDWHVscm0yeW9MVkJmSmJ3cjJI?=
 =?utf-8?B?ZlpmV3VSeXBmbzAzSEh5ZXg3V0tjTUxtOVZEUnRwR2g3MVJPU090bnozQTlC?=
 =?utf-8?B?UWVlWWhIekpKTTJIMkFTdG1QVU8vS253MHgrMXkwUTBZS2trSlNhTE1yVFZh?=
 =?utf-8?B?aHZ1aWlTbkFoT1ZxbEh0S3Z0aVZXQWZRSkVrRUZ6eGFEWE1oTHo1ZlZLWlVN?=
 =?utf-8?B?Z1lKWWU3SmJGYkZRUGhvQXh3MWMzQ3p1VXI0eXl1Yk1WVVlaQlIxWG92dUpv?=
 =?utf-8?B?YzFYRWgxKytDbHRnWWZmY1FmREdCYzBXUjNRYWRUeU1zc2FQNkNTVktxK1c5?=
 =?utf-8?B?NVNzZXFMaXZkRW5wcVJIRmxKektpZXN2aVlLQ0U5Z2dhamlGMlN2Ym41YWti?=
 =?utf-8?B?L242WHR2bWFydGZvcjdydTFJZ3B3Q0VMSm1WYm5mYmE1WlVJS3lQYjhnV2Fi?=
 =?utf-8?B?ZG4vcFlENCtDMm9saEoySjlkSElTUGRPcDF3MVFKMDQwV2hGZkptUGhzRmIw?=
 =?utf-8?B?aU44MHl5RFgzaEt3TVZNMHNFc0dXd0dCdXVkZlIwMk1XZnZ4YW9hRzFMbnhR?=
 =?utf-8?B?L3NYd0xtSmlhZTg5bnE1MlBFWnpLQmhGOVk4TzAyL1Z2WlNRTXNKQUFXbGpT?=
 =?utf-8?Q?AIziHoM9IDHh6f6O1PmDYfF7B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebbb19ff-ad5c-484a-9c9e-08dd5516a9a6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 21:03:18.1914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MvxCiiRfcBAGmXLIferagJek72bmzGERMsRtpn0wkLOasZv3JRdSqgZbauu6d1DKOybW2wNCEIKiaPlRD583/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9462

On 2/18/25 19:26, Sean Christopherson wrote:
> Terminate the VM if userspace attempts to run an SEV-SNP (or -ES) vCPU
> that has an invalid VMSA.  With SNP's AP Create/Destroy hypercalls, it's
> possible for an SNP vCPU to end up with an invalid VMSA, e.g. through a
> deliberate Destroy or a failed Create event.  KVM marks the vCPU HALTED so
> that *KVM* doesn't run the vCPU, but nothing prevents a misbehaving VMM
> from manually making the vCPU RUNNABLE via KVM_SET_MP_STATE.
> 
> Fixes: e366f92ea99e ("KVM: SEV: Support SEV-SNP AP Creation NAE event")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 18 +++++++++++++++---
>  arch/x86/kvm/svm/svm.c |  7 +++++--
>  arch/x86/kvm/svm/svm.h |  2 +-
>  3 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 6c6d45e13858..e14a37dbc6ea 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3452,10 +3452,21 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
>  	svm->sev_es.ghcb = NULL;
>  }
>  
> -void pre_sev_run(struct vcpu_svm *svm, int cpu)
> +int pre_sev_run(struct vcpu_svm *svm, int cpu)
>  {
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> -	unsigned int asid = sev_get_asid(svm->vcpu.kvm);
> +	struct kvm *kvm = svm->vcpu.kvm;
> +	unsigned int asid = sev_get_asid(kvm);
> +
> +	/*
> +	 * Terminate the VM if userspace attempts to run the vCPU with an
> +	 * invalid VMSA, e.g. if userspace forces the vCPU to be RUNNABLE after
> +	 * an SNP AP Destroy event.
> +	 */
> +	if (sev_es_guest(kvm) && !VALID_PAGE(svm->vmcb->control.vmsa_pa)) {
> +		kvm_vm_dead(kvm);
> +		return -EIO;
> +	}

If a VMRUN is performed with the vmsa_pa value set to INVALID_PAGE, the
VMRUN will fail and KVM will dump the VMCB and exit back to userspace
with KVM_EXIT_INTERNAL_ERROR.

Is doing this preferrable to that? If so, should a vcpu_unimpl() message
be issued, too, to better identify the reason for marking the VM dead?

>  
>  	/* Assign the asid allocated with this SEV guest */
>  	svm->asid = asid;
> @@ -3468,11 +3479,12 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
>  	 */
>  	if (sd->sev_vmcbs[asid] == svm->vmcb &&
>  	    svm->vcpu.arch.last_vmentry_cpu == cpu)
> -		return;
> +		return 0;
>  
>  	sd->sev_vmcbs[asid] = svm->vmcb;
>  	svm->vmcb->control.tlb_ctl = TLB_CONTROL_FLUSH_ASID;
>  	vmcb_mark_dirty(svm->vmcb, VMCB_ASID);
> +	return 0;
>  }
>  
>  #define GHCB_SCRATCH_AREA_LIMIT		(16ULL * PAGE_SIZE)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b8aa0f36850f..46e0b65a9fec 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3587,7 +3587,7 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  	return svm_invoke_exit_handler(vcpu, exit_code);
>  }
>  
> -static void pre_svm_run(struct kvm_vcpu *vcpu)
> +static int pre_svm_run(struct kvm_vcpu *vcpu)
>  {
>  	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, vcpu->cpu);
>  	struct vcpu_svm *svm = to_svm(vcpu);
> @@ -3609,6 +3609,8 @@ static void pre_svm_run(struct kvm_vcpu *vcpu)
>  	/* FIXME: handle wraparound of asid_generation */
>  	if (svm->current_vmcb->asid_generation != sd->asid_generation)
>  		new_asid(svm, sd);
> +
> +	return 0;
>  }
>  
>  static void svm_inject_nmi(struct kvm_vcpu *vcpu)
> @@ -4231,7 +4233,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  	if (force_immediate_exit)
>  		smp_send_reschedule(vcpu->cpu);
>  
> -	pre_svm_run(vcpu);
> +	if (pre_svm_run(vcpu))
> +		return EXIT_FASTPATH_EXIT_USERSPACE;

Since the return code from pre_svm_run() is never used, should it just
be a bool function, then?

Thanks,
Tom

>  
>  	sync_lapic_to_cr8(vcpu);
>  
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 5b159f017055..e51852977b70 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -713,7 +713,7 @@ void avic_refresh_virtual_apic_mode(struct kvm_vcpu *vcpu);
>  
>  /* sev.c */
>  
> -void pre_sev_run(struct vcpu_svm *svm, int cpu);
> +int pre_sev_run(struct vcpu_svm *svm, int cpu);
>  void sev_init_vmcb(struct vcpu_svm *svm);
>  void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
>  int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);

