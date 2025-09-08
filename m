Return-Path: <kvm+bounces-57018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2167FB49B52
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 22:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3E1D4E4863
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 20:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F14AC2DCF4D;
	Mon,  8 Sep 2025 20:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mE7LVxrw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2059.outbound.protection.outlook.com [40.107.236.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D41B1C3C11;
	Mon,  8 Sep 2025 20:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757365172; cv=fail; b=T0pgmuG1XMEvXuCH0xwjTakpH+kia8xVAYyjSJ30OJdf/OZAmQ8wsGXCV36UWJ0EAhqnP7lqUSoDbb5lP+uMLAQESWD1Ae45m8kNORvYVkC+Id0l8vFnJqXgcXOHRXOqjon+7MqLcMYtALvZHdKwAFZ4vimoHpXj4lE6mPJO9EI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757365172; c=relaxed/simple;
	bh=O4HMgLxEsieIREdsTNI3985uPVl2uYYEydJfIEHIbb0=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=WBC3y7zlaeOsBnWnhKOlnTg7MGiCcRgXkCZ9vDyxOh2lIUuTsZA5f9xZAw1W1ziiYEHNLQEoL0sJMO0HPhcVUqtVbEY0mLzdtA5cVBYm0mQHTGpzGIV3kzUrHHN/yzwG56rRCUVEdE+aDOzS+38oLmgwPTEhcfhPmDE+LhZCFXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mE7LVxrw; arc=fail smtp.client-ip=40.107.236.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b24Qr9l1+riCFl+3AGSxRFsYM8zW3s4vz5N9Bb6VBwAIVLPVB62VaD7KP+c1mg037IwKgvPg3Ad37O2jwmYQm1Hw5ekcCga46tN7EeVylA0Hgc3pGWUzs3lMjP00CrltJCX6eP/kjdTq33vZV25J5gxBNGjjqJwVhv7GCbk+YHmgvQ1jUTr32aKo7TWPoy+6ujlSHfM6CNfeq9s6Sns8hNpDut4kAAbhYVdDGrTuPQRKq9Oy0X01N/9AoAuqkAxJWLrJJ6jrBff+QdESWabw8QRNJgsEpGM52OoJG9pasnwu1fkDpcHJ/1owzGfdU8m2cmzbGthEmNtFcKBN/smr+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oD8ReJlQCK7ZmEhrd3Ay2LkNcaYwMWkrebDPWHd0ilI=;
 b=uEmlaP8spdnwJP5bd6AJs5L7ilE/nZz0/wId2jSftMmAZugYPGQ1CQCGc8xbjABfPpx4TXppFr59NwJ7FfNVAukM29eNkx4gRcj20bHuUKlQbbBhcGozFZaCU0APdJsq3A1fbC/zBgY4CwGLI9P33g2/0euz5w0Zaf1ybBvs54mxFTeNVm8Hr8YeyQJza7nbBa+e3NW5YbvhTVysJ8SiHAVTQySrtTk+LMak5BpA44gGv7y9E0aUD3EOQoLhZVhasGw/TQNFMhPxcRD6H5rLVEmjLerMmTs6bUAft/DwRzH1rXaOV/gBjrF4nJ4QcjcImAo91hPNCdGcM94zjOz4jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oD8ReJlQCK7ZmEhrd3Ay2LkNcaYwMWkrebDPWHd0ilI=;
 b=mE7LVxrwolh+VTvuUxsMQQUmFzJTnSdccs0bLtueRwYM3C/xRz12DczsGS3l+WvxR62cWZwZy+WudSg8wkGRjVzENm/HZP35Ulo0CtgOAngtklxZOcUH/X6BNxQpN7tu75FRRBjdbQ9qa9kEbaKh0+0bXyHToiZOkaTRa39qpN0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH2PR12MB4199.namprd12.prod.outlook.com (2603:10b6:610:a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 20:59:27 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 20:59:27 +0000
Message-ID: <486a17b0-94d9-779c-941a-848ffc7dfaec@amd.com>
Date: Mon, 8 Sep 2025 15:59:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 herbert@gondor.apana.org.au
Cc: nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
 john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1755727173.git.ashish.kalra@amd.com>
 <52ae3debd194536afcc0173e562cebb60eaef13f.1755727173.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 2/3] crypto: ccp - Add new HV-Fixed page
 allocation/free API.
In-Reply-To: <52ae3debd194536afcc0173e562cebb60eaef13f.1755727173.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:805:f2::49) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH2PR12MB4199:EE_
X-MS-Office365-Filtering-Correlation-Id: 04a1e317-3d0d-4d85-7f40-08ddef1a98f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S1lhZGJqNmJWOTlsaUNGUHJJZ055UFhFRDFDRllmeWZmTFppOW1mQXZDOVhK?=
 =?utf-8?B?bHp3ZC9xcU5kNGNpM0FJdjJZV1BrNTBCZ0RUSXBSeWhoZmRxVEJ2eExoTnNH?=
 =?utf-8?B?dUg0aHlsUTBLT2pTdXMxd3hPVHVucG9yVFdiWkxuOHdlMEhuay9CNDhKaC9y?=
 =?utf-8?B?bC91MzNpMEQxQnNYL05tSU9veVd3anNvZzUrdWw0cmRkSUl5ek5KaWpwb2x6?=
 =?utf-8?B?WHFFVHBFa2dlMUdBNWtBbXlRTXhvcUt2ZmNLR3QwekFhczErQU56dW1vak0w?=
 =?utf-8?B?cVR4cGhOVUdHVzZXMW0xcUpPQTUzbU5SMVhwaTB6RFZCZGNjN3lQY3BUQ1Ey?=
 =?utf-8?B?WHNCWnl1N0xUTUZkN2VRcFBIVUlDVWpqTm5LY0E3aDNRemNCZUVjbTFBbFZp?=
 =?utf-8?B?UVFPSHdvNGxObWI3aHpzR1BOMldxWkd6UGJLSE56VVRKeXZXckd0ZlRpcklY?=
 =?utf-8?B?OUsrQkVBaFdMTmhPUDRwT21NejREaTY4RldnTlhJczE1T0RpRjBSNXYyQTk1?=
 =?utf-8?B?amk3eDJlTE9yZEhOZFdMNmJpV2F2U2k5RUEraWhQRSs3WnVhWFpadVN6eXhz?=
 =?utf-8?B?TTNVK1RkKzZPTWRyeXNMazR2UW0rSnVnWFBrWEUwcGlZaWl6ZWhiOGM3U1Jj?=
 =?utf-8?B?dEpXbkFuVWRPaitKR3Y3elBSQ1BRVGRpN3RpekExcjVjT3VzZUpsL1plcTNY?=
 =?utf-8?B?eUcvbHlveDd0Z3ltY2NnY3BZcGFOQVJLK2IyS2tZZkh5ZTdQTExNU0JBTTUx?=
 =?utf-8?B?RVRHbWtiWjJQTlcvaDhFZTFEK1pBa3NPUTlyWlVDbVpORTZORTEwR2NDNzk0?=
 =?utf-8?B?Z0ZId04wS3JPVzhZOU1FalZFdE9ud2ZyeTd3UUQxdkZRb2ttTE53TUZaOE1o?=
 =?utf-8?B?bWVSRHhlRWpGMGNEOFdCdlY1VE83NWRBdUJ0aWNlVmZkQi9UQmVsSDhNSFBr?=
 =?utf-8?B?TVdKa2xYaE5MN2p2SFZ0M0NoMVJNdVh5UFdWQlZta002RHMvblJyalBrVUdX?=
 =?utf-8?B?dUcvQzROQXNzc0tWRUVUTlBIRWhTN2FPVSs2TitSOFR6UXloVEJaYkN5T2lj?=
 =?utf-8?B?SjVHL3JjRHkwZkxyT2VaUWZLS0NXdHNXZkZjOXFzVFFpSUhBOHRjRmRDWmMw?=
 =?utf-8?B?b0dwZlJRTERRUlJNTlgzUHBEWk1hS3ZLYnhCNzgxSHY2eUMyVHVCY0IyWGFI?=
 =?utf-8?B?K3g1WnZwbUtROEp1dDRoL1ZXQlU2WHRoVldVa3paaHZBa0pNMzVLc0xZUmwv?=
 =?utf-8?B?VmZjNWU1Qmh5aElENGE0MFYwVGV3bUhLS09ySE40d09zMWRwZXJLMjZWYVRI?=
 =?utf-8?B?RVZWODVqeTVBbmRwT25IbTM4MnU2aDhFbnhxVnJNanA1ZnphL0hPSHhzblNq?=
 =?utf-8?B?UENQaEpTUGVHTGNQYkhWN3ZCR3gzUk0vZUNYRmNzRXQrWFpEeVRRQi9NTjBt?=
 =?utf-8?B?bXdkajRYN0VnZnRvV2hvbit1TUMwOXJlbUJtVlp3MnZnRTdMWXdRWGRpMFNP?=
 =?utf-8?B?anV4SktwQ2xZa0ZsdG9PTHRtYjlMcFFzc2s3dTZQNzNEWU9QTTBNakwzNDg3?=
 =?utf-8?B?ZVd6aGtHZ1JmYkZYL3hRS2Q4dnRQaHhDZkl0VHh3dktRM3RXSmdyTStvNkhC?=
 =?utf-8?B?U1NybFhhWTROZlhnL21ZbE5PaG54TkN1SzNnN2VzQUJFbXd2NHI0RDZiUkcw?=
 =?utf-8?B?dkF0SzNKQWlhNkcyVVZEaXROSEJnazNJSjRKY05kWkxFTE9JdWkrZzdmUEdm?=
 =?utf-8?B?Rk5tVGxEMzVhZEphc0FQTXdaaWR4bS9ZUXpjR2t4RWVpbDczMXF5STRIWkFj?=
 =?utf-8?B?aE5malJ5WFRZNTN4RFZtTE9ITWY3Y0NRQ0dUeGh6S05hVEVGcVlHZHdZR0dM?=
 =?utf-8?B?cDZTTGx1V3p2WlZnRFdxcVp2bnFEblFpT2plaitLanVtVDlRNnpBOUsxWEdC?=
 =?utf-8?B?VmVGRS95NzczM0JIQW5CUHhRSG1aUFFSTlNyaXVsN1dxdE1nbVRaeUV0ek1n?=
 =?utf-8?B?KzFydkJLeE93PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eVdaVXk4SjlsN2Z6a3BpajVqVnp3b2xPemV2SWoxSHFONnlWRXlOOHk0WFBE?=
 =?utf-8?B?aHNHRTZYb1ZsbGcrWEhBbks2akNiVTJpNWFFaVJxSDhTNTdKTjZ4bkhNVit0?=
 =?utf-8?B?Y0Q4akZ6Mld4OE5mM2xMR3hOSnA3R2dVemRtY2VHTHVYTVc5Sm9zZmZlU1JI?=
 =?utf-8?B?SE05ODllL2RhQUd6THorQkNUajZySlhPekFGd1FmTmNzemYzSnJGRGplc2Rz?=
 =?utf-8?B?ZDhMSmV0SDZXSmVIdk4xS2tXaVVXd1R1d3lNaWdxTmxWVXVvZm1pbkYrNWgx?=
 =?utf-8?B?MEVscjA0SFQ4S0U4bU9oN1VLYm94eGd4cGRCTWJRRUhEQk5ybnFLT09aWXJ5?=
 =?utf-8?B?RFVZSEpIK1YvTnZUajFXMG45Z1FSM0I3RUNJbjhQWlMxenlsZ1gwb1g2N3ZY?=
 =?utf-8?B?V0NUL3ltQnFHRDVGL2ltMU13UTM3T2dWYmsxSlBIMllRR0MwejJwOXd4V2xC?=
 =?utf-8?B?NjhteFp2M2VoOFRIQnVDTWRIWG5nYW9oZ1RSWVFOWURXOHFTOUFydFRMZGps?=
 =?utf-8?B?VFlKeGV1bmg2RVRZNFRKOUtQYlNKTy9HKzVYQjMyOHZVQlp4eWR4Z1hSSGZz?=
 =?utf-8?B?UmlvTFM1c0libnJRRHVRSFF0ejhhUjNCQVpMbnVLZjM0aXlIK0NqSG1kVnlQ?=
 =?utf-8?B?akx1VlBNeXlxcVdRNU5WSENIa2o0RzYrcWxqeEZmTUpzWjc5TERHK0VmQUNw?=
 =?utf-8?B?cjlPSUZmd1EzWUZoR2VTMFI3Wmg2b3BDR2lGVE1MWndENndPcDF6NnF4dVIz?=
 =?utf-8?B?U3d1a0ZVbE5CRmRLQ3E1SXhjdTY4Vm1oNHUvK0dLV0xDcE9EcXVtSkVhV3FJ?=
 =?utf-8?B?T0Z3OHdXUk40eHBiMGljSEsrdG1jUzR6bVlQM0RqMkxGczN0ZjNsc2ZsY29v?=
 =?utf-8?B?bDVWZlIrcTJZZ3hiMzMvOXE0UGhCWXhYNmNoSkk4UENFcGZySGtNVlUzVGtr?=
 =?utf-8?B?d1RXRTR1Vy9RMUp2YzNDU0F5K0VSZC8wQ2p3NDhpY082VFZSMU1kQUExTFpX?=
 =?utf-8?B?M004aXdVOTZTVEpJZ3IxVGtuM0FFVUJ1d1ZRaHhHSHp5R2V6Z3Z5aXl1N0xk?=
 =?utf-8?B?d21Cd29GbEZkNjk2S1JXSmFmTUx4UWtwaThPTVdSMFlkN3VhUTI0dmJMWS95?=
 =?utf-8?B?OFJiV1VSYWUzYnhIV2tQRVZpdElreFRqdzk1V1ppdXpSNUEwU2RLOE9PYWZ2?=
 =?utf-8?B?Q3dPM3ZjMmdzalBjUllpVVM4ZFl4YUZrdisrWVVPQnMrL0NtMVFzcW9VaU9h?=
 =?utf-8?B?aGhGQjNrdkRyZUY3TmFnQnFla0VVM2FRazNyVzhHNnMwa2I5M05TelZvZ0xC?=
 =?utf-8?B?ZUp4VExsMEVMVElNaXRYNXliYUp3S242Ykp2QkFyZXRscVhicVZ5VTk4ZVY0?=
 =?utf-8?B?OXc4em1iZnNESE1UWGIzSE5tb0hYRkNSNXM1aGZHL25yVGJDN0FaMTlUR3B2?=
 =?utf-8?B?SThQRzAvL3JwK1FjVkMyWklPZGlIWGgzd0FYQmdEMExSWlRualFsY0trcGxF?=
 =?utf-8?B?TzFiNUV3UVVlZEp1dUxCWGhTMVZVMFpxaWd5azJETGJrU2JtVkxXd2RBeWVi?=
 =?utf-8?B?TnJZWG9MbUFVR1ZHNkdtVEhSOUxIcmhKQ0ZwNDhXYVhDa1krd2VEaC8vQitZ?=
 =?utf-8?B?dDZzdG1mUmlJRFhKQi9oNFVkZHdZMHNVMjlPc0VuRThnWkdHbExjZ0V4c2lq?=
 =?utf-8?B?d1Vtd0xVWWo3Ny9iN3J6QjNNbGxDbGoxdnZDVG15K0IwdEhzL29WNE14Q3hC?=
 =?utf-8?B?WE9uZFZTWEFYYjhtdWMxeVIrUGJQZGNEQlNybUc5eXlRV0xQWERzaThUUHV2?=
 =?utf-8?B?dTFRUG15NHdxTzFEZWUyQ2ZXWlBBclMzMVlRUktUVEFhcmJQNXRKMmRKeWd5?=
 =?utf-8?B?cUtSNG00UkhwZ0ZJd0RKalliNWxyYmd4dXpBQStHa0pxUDFaNk9UdUc3OXZY?=
 =?utf-8?B?ZlNJeVpQWjRCaC8xbEJvejhsSnE3MC95MTVHZ0UvYUh4djY1a0ZHYlkzdzBj?=
 =?utf-8?B?QWRYUTBaOGJhT053OEVnYXFTVE83YnovdHozNy9KaFJtVThtU3RKUzNGWDdM?=
 =?utf-8?B?eXl5TEl6bzRoOEZ4Sk84L1FxdEVEZDdkZjN4MFlYb2p0SGI0ZUFZRWd5YlJU?=
 =?utf-8?Q?hPjpO1thAvuIZbIqnsE7dW7sH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a1e317-3d0d-4d85-7f40-08ddef1a98f7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 20:59:27.2866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0e/B5bTG2wj5t1jLK1IZ+T6tf0S9YzpLzLXpeaGhKePH8yRtOmDtC/fPcBrKhhQzipCv1+KvS5OZ0taCvfQndg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4199

On 8/20/25 17:19, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When SEV-SNP is active, the TEE extended command header page and
> all output buffers for TEE extended commands (such as used by Seamless
> Firmware servicing support) must be in hypervisor-fixed state,
> assigned to the hypervisor and marked immutable in the RMP entrie(s).
> 
> Add a new generic SEV API interface to allocate/free hypervisor fixed
> pages which abstracts hypervisor fixed page allocation/free for PSP
> sub devices. The API internally uses SNP_INIT_EX to transition pages
> to HV-Fixed page state.
> 
> If SNP is not enabled then the allocator is simply a wrapper over
> alloc_pages() and __free_pages().
> 
> When the sub device free the pages, they are put on a free list
> and future allocation requests will try to re-use the freed pages from
> this list. But this list is not preserved across PSP driver load/unload
> hence this free/reuse support is only supported while PSP driver is
> loaded. As HV_FIXED page state is only changed at reboot, these pages
> are leaked as they cannot be returned back to the page allocator and
> then potentially allocated to guests, which will cause SEV-SNP guests
> to fail to start or terminate when accessing the HV_FIXED page.
> 
> Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 182 +++++++++++++++++++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.h |   3 +
>  2 files changed, 185 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 4f000dc2e639..1560009c2f18 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -82,6 +82,21 @@ MODULE_FIRMWARE("amd/amd_sev_fam19h_model1xh.sbin"); /* 4th gen EPYC */
>  static bool psp_dead;
>  static int psp_timeout;
>  
> +enum snp_hv_fixed_pages_state {
> +	ALLOCATED,
> +	HV_FIXED,
> +};
> +
> +struct snp_hv_fixed_pages_entry {
> +	struct list_head list;
> +	struct page *page;
> +	unsigned int order;
> +	bool free;
> +	enum snp_hv_fixed_pages_state page_state;
> +};
> +
> +static LIST_HEAD(snp_hv_fixed_pages);
> +
>  /* Trusted Memory Region (TMR):
>   *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
>   *   to allocate the memory, which will return aligned memory for the specified
> @@ -1157,6 +1172,165 @@ static int snp_get_platform_data(struct sev_device *sev, int *error)
>  	return rc;
>  }
>  
> +/* Hypervisor Fixed pages API interface */
> +static void snp_hv_fixed_pages_state_update(struct sev_device *sev,
> +					    enum snp_hv_fixed_pages_state page_state)
> +{
> +	struct snp_hv_fixed_pages_entry *entry;
> +
> +	/* List is protected by sev_cmd_mutex */
> +	lockdep_assert_held(&sev_cmd_mutex);
> +
> +	if (list_empty(&snp_hv_fixed_pages))
> +		return;
> +
> +	list_for_each_entry(entry, &snp_hv_fixed_pages, list)
> +		entry->page_state = page_state;
> +}
> +
> +/*
> + * Allocate HV_FIXED pages in 2MB aligned sizes to ensure the whole
> + * 2MB pages are marked as HV_FIXED.
> + */
> +struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages)
> +{
> +	struct psp_device *psp_master = psp_get_master_device();
> +	struct snp_hv_fixed_pages_entry *entry;
> +	struct sev_device *sev;
> +	unsigned int order;
> +	struct page *page;
> +
> +	if (!psp_master || !psp_master->sev_data)
> +		return NULL;
> +
> +	sev = psp_master->sev_data;
> +
> +	/*
> +	 * This API uses SNP_INIT_EX to transition allocated pages to HV_Fixed
> +	 * page state, fail if SNP is already initialized.
> +	 */
> +	if (sev->snp_initialized)
> +		return NULL;
> +
> +	order = get_order(PMD_SIZE * num_2mb_pages);
> +
> +	/*
> +	 * SNP_INIT_EX is protected by sev_cmd_mutex, therefore this list
> +	 * also needs to be protected using the same mutex.
> +	 */
> +	guard(mutex)(&sev_cmd_mutex);

Does the guard() need to come before the snp_initialized check (or the
snp_initialized check after taking the mutex)? An SNP_INIT_EX (which
would grab the mutex and make this call wait) can occur between the
check and obtaining the mutex.

Thanks,
Tom

> +

