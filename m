Return-Path: <kvm+bounces-51682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E09EAFB8F0
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 18:49:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20D6A4A59F4
	for <lists+kvm@lfdr.de>; Mon,  7 Jul 2025 16:49:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093CD22CBD3;
	Mon,  7 Jul 2025 16:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PMUbdx/e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B06224B1B;
	Mon,  7 Jul 2025 16:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751906971; cv=fail; b=r/jryWjVCPVhgW88/o1fj76ekxIUFhbfzyXXDQ0N63ytXWzlFViIQsf3R81zX43nhR+6M3E7FVkPGnHjEIS/WmgqYaWQds60ablq3z+KjHakYVDW6hZ32m1oGmz76KHp6NY0+M+3pGircrSjSB9IxP3VHgXqou08B0ZfzfP7C1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751906971; c=relaxed/simple;
	bh=6xKFPDXYR9wLSq1aeWdTkJd1QZLOZSUdfS1rT5syuMU=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=qoLcwij4JcVHBOO7zRynz2TfEL86qsQQYQopcIIBo2u1fjGCZn+Q7cie0AG/lz3Om+Rf/ta2BzH4jrWZQJUSyo3ScfQYTfoc2l8X9YdQcan9IfcKW6h3+AqlZQjmc3dWT9iX+OwMSoZdnQkfoaAqZXjCx0U61zE0pYWC8MHREuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PMUbdx/e; arc=fail smtp.client-ip=40.107.244.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RAJjbbMkJk6sI+DV74WTCFUVaQgMjD0S9gz8I9jHI767panhsWXE6fVxVaZvJSijAlHzLtbZPYvnUITOoY7Kl1KZYjTmh/RPJo1kSOuo9PeYEgcs24+wD3fDxuOSWxXAY4zY7hG9SnUYLyAy2pL6cWIOCZEv3RFokcrDWpJwTKNupm+lrJto/ECCiIe8Wc7H0e4bB2EIH+V1zC5CMRjLkD1pW1TXPMIj9FVj6ACk5dnidieZTJLd8aFil0lzHYY06zGDYjaVUjiiCpTD0R6SO7hHrs9HlzyENHbMRETrAmW36kjy8d7o0ft7QPux+A+VJLp0Uv2uhG3X1bPO5AQIxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJ4VxPg9CXPHd6TtY6Gpvw9Z3z/lUQrciRexBDs+xNs=;
 b=aVpmyJxFSwJNkOqZZAauqekgtOrpEAdyUbmoPgiZPE8X6nGm1mIVcLZy+U4YvOrcNKo/UGdRpl4oNE8Pb9VUq3cTpyCdJHHD4IOJ68An4FSxlJ6ML74rCGsZrTFZH2I85B+lhgfDnxKxrnG5P+JsBhWz43xkQDq77aNywZwl4U74C0e+T2CazYTqaPhdNCZ1Ee+IfnOE/pyJ9vUscrg0smFfa7bfZncg7HMBkeFC308ogApm05zDdEdry+LSdrBJ5c4xG1Io37XszNVHW1cCdbzz5jG/edElBVA2hTLTC2Z+clvfaPvD17x1R82a/yeJkMe2GruqDRDQGK2ld7VdpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJ4VxPg9CXPHd6TtY6Gpvw9Z3z/lUQrciRexBDs+xNs=;
 b=PMUbdx/e/yTFUoJp+EB6e/i18knlbWYOdm8o5hrFKrKDyRUs7afmbFb3EvbST5jr2zBESywImiYUVpJKrIzqtSpayQPd9kXAFYZgT5cj0fUlSZa6iqy2+Tn4YlYfLBvJK2hkMQ98a/he6F6aJ/46nVxFomGDnVhFJ/q7Kaa9dBo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ5PPF1394451C7.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Mon, 7 Jul
 2025 16:49:25 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8901.023; Mon, 7 Jul 2025
 16:49:23 +0000
Message-ID: <a3c5017f-d9bf-828f-90e1-61d0c1add14f@amd.com>
Date: Mon, 7 Jul 2025 11:49:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 akpm@linux-foundation.org, rostedt@goodmis.org, paulmck@kernel.org
Cc: nikunj@amd.com, Neeraj.Upadhyay@amd.com, aik@amd.com, ardb@kernel.org,
 michael.roth@amd.com, arnd@arndb.de, linux-doc@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <cover.1751397223.git.ashish.kalra@amd.com>
 <68885411fddfdba2fe0c3ab023dc5d5eb108689b.1751397223.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 5/7] crypto: ccp - Add support to enable
 CipherTextHiding on SNP_INIT_EX
In-Reply-To: <68885411fddfdba2fe0c3ab023dc5d5eb108689b.1751397223.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0005.namprd05.prod.outlook.com
 (2603:10b6:803:40::18) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ5PPF1394451C7:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b99792c-70cd-439d-0376-08ddbd763991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M0phamRDS3FpTWJ4LzhjUGU0OGVNODhadTV4c2hpTThzVU5XQytGd3FhekNh?=
 =?utf-8?B?Y3VJWjcwdG1tZFdzdWIyekZockhqYXJSbll5TWVxQVhsYzVUVElnVGlOUDRk?=
 =?utf-8?B?NjBPNm8rTVdrRnJ5MER1SjRqUWsvMWcvTTduOGRXblZCcWIwcE5INm9iU3l0?=
 =?utf-8?B?VUxjTkNBdlM4Tk1qYkRGSzVSQzc3MGZjejhabGFOaGhHcWpqbGsvSU90d3dS?=
 =?utf-8?B?bGJENUpCakZDQzZ2c2EwL0JKa0o0UFBQamxxcVQzOUdybU01TldTWWJLdnk0?=
 =?utf-8?B?dnlJaDE2TWFkRTNlZ2RKSW8zelpBeGJ1ZG1MallKTkZMOVNaek1WbDEybkxa?=
 =?utf-8?B?QnpBcHZiRkY0QUhBQ3RPczBLOUQwZ0tvL1JxK0phOVd3cHF2NFFJZncxV2xs?=
 =?utf-8?B?aCszZUdzSlo4NHVzUTFObVpDT1hYWEpPNWtidHFxeVNmcy95VE1ZT3VIMXMw?=
 =?utf-8?B?OE0zVGRUZnppeU1BTitrOEI5bkRDWmk4YU0rSFhMbVVjQWE5RjU3bTlORVhJ?=
 =?utf-8?B?WGc1YXR0U2JFeVVqdVhUWkY3b1JVWTlUNVkrQ3ltV1BNcDNLd2NyVmlBQnIx?=
 =?utf-8?B?RGd5Q3RsMFAydUM2SlRtUkdMQjI2Sm4rU0hna2c2bnVyVEVJellHMktsOFdQ?=
 =?utf-8?B?YmxJb1J3UDlrLzdoSzU2VVJxcURKOFRRanlhRnM5dkZjTFUvaytyWjZwTDVL?=
 =?utf-8?B?M1BzVzF4RGk4THc1aFhBMER2RFhjeXpraGNWSHBramRnV3pURituMDMwWC9X?=
 =?utf-8?B?Sk42SmF1blZyajJQMVpRaTYwMlpRN3ZZYkZBb3ZPU3FrYk0yQmpCWmp3aFVE?=
 =?utf-8?B?bnlMaXR3LzhSYUdrSzBoUjdLSUkwdFhCRXlUTk9pOFZDUjlTS0R3YlVUcFZL?=
 =?utf-8?B?WkJ3Y0ZPd2Z3Q3lEcWlPT24vVE1mUlVHQTFKdStuWmFmdEptMmhoLzQ0Q1RB?=
 =?utf-8?B?SVY0cGRGYytuY1dLaTNyeDIzOG5zQTNXdUcwWUNveTV6Q3VDakdjUVc0V1lP?=
 =?utf-8?B?Z1BGOGcvOEVHTlhlMTNrZ3ZTaUp2Z1dFbEg2bElPak5HaDl2eGZBMWlqU0Nx?=
 =?utf-8?B?U0NWbVNMamhDZmdTb0JZNTUxamNhaXZEOVBkMjIxZFhCV1lBaU5ZQXY1Um5n?=
 =?utf-8?B?YlZEUlgwNG5XRlFyTFo1SFkyS05JRjdISnVPb2xtTnNldS95czhKR3Z3SWU1?=
 =?utf-8?B?a3pmeHNnaHc5SEl5UW5sSG1NZ01NbHJ0djdQQStiSi9lRFNTZmdpeU9JcGJS?=
 =?utf-8?B?bEVVWFMra2wyV0hWQ2krOWtIcXJ4ZTVPRktWOTRuV0RLN1ZFVjc4ZUdhU01O?=
 =?utf-8?B?UkVTQTlrdDJWUjVyZEJDa29tdUlWSVNnZTZxaGxLN3UxTHBUdDY1c0FOR25i?=
 =?utf-8?B?SGorTW5QcFNBSmh4aUN6Unp1YWFTY3FVOUF2NkNBT1RuY2tvZnlEWWNGY2Ix?=
 =?utf-8?B?VzdiZHRjZ2dxMzFmZWlLay9idjg1ckYwZE53WXJoM1MvQStndDVOTUhkWWk0?=
 =?utf-8?B?S2JIYzRlRUk1UFpuNDdhMHl1c1QzQndCYWg3VmVlblRjN1VOaE9MQ3hzY3Jt?=
 =?utf-8?B?K2t3aDltcjlYUS9DZUJMU0w4MFkrQi94Z29wUGxNcWRuWis3MmVtejVHSmsy?=
 =?utf-8?B?aDdRNUZmanNodkFVK3ZWbnVINmJ0b1kvWUFVV2tDSkl3Uk0rVU9HYmNCLytV?=
 =?utf-8?B?NUhIeDA1VG1xNnJRSDhZcklpNVVEWmZRUHkraStteWdPSElBRXFSMjRrbS9O?=
 =?utf-8?B?UTZtQlBTRDlKaVl6cG1sQWkxNGJnQVhDTkNBMHk2TU00UDR2b1RBb2FLM3Ra?=
 =?utf-8?B?Q3VKb2hhMkM2MHN2MWtySE03RjlmNk5aZmh1YjQxUnJyT0lnM2dTT1d0UC9S?=
 =?utf-8?B?dE5ndHJPYzVTbytFbEhlc01xb0UrTThEZ1p4WHZ4QWVyUUVOUVgyLzVTUDVC?=
 =?utf-8?B?TEVvMEhleWZOb21nS2VzaWhsMkJxUHV5ZDkvcEdjclpLWmZOQXc4M3Z3bjdG?=
 =?utf-8?B?Q0RlRkh3U21BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UllBVURtR0RJMHVzT1ZGNis3Q1hnYnhuY0hBWVFaUUpnbmdyRGg0NFBjZjJw?=
 =?utf-8?B?UzcwVXZGK0ZnUUV4bml6dnBnOU4xNDV6NmxvU2NteGxrN0dhcVVsNWRXdmxQ?=
 =?utf-8?B?bFNVVVZqT2hLWE54Z0FHUUs5UTVjczJLRnhRczNHR0gvUzhhdkxHaUZEaGJJ?=
 =?utf-8?B?TE5BNUd5VkZmMEFhUVdPNTlabzNOSktKRWY4TzNBbkFQQVlTU2htUjBmdzQv?=
 =?utf-8?B?cFVyUHgrazIzMTVidTVlZkwvTC9ObEJKYWQ3VWhNVTJmUGYyRUZtdWlGbldT?=
 =?utf-8?B?bktDU1NOODJ2TzU3V3RGbHFQajhYbjhxckhkaHZoMnR1NU56TU50bjdNZEJZ?=
 =?utf-8?B?N2VWaUMxWktvOUJZSnNWWU1Cb3NEdWZURHo4aEF2Sk5Wdk9vK3hJdGpjTmVG?=
 =?utf-8?B?YzMvRU02TjhGaDZlbU44dnN5Z1pzMHZaNlpNdjIzOHF3VVVsYVpsYXVDcXFD?=
 =?utf-8?B?bHU2MDVJVHZNVHg1MnJyQnFHWHgxZURXM2dSRG5pb3ZyZVEzeGl0NjBsRWFN?=
 =?utf-8?B?ak5Od09LaVNkZWxqalVnNkVyTWFHRkxaT3hQbjZ3dFpqS1JIU3lMSWxFYTBO?=
 =?utf-8?B?Qk1yRjYzeW1tNTRtVlQ0ZldWcUd6Mk04bXJ0akRjSnZCdjdBNDFQelB5M2Rh?=
 =?utf-8?B?NTBITzR0SysrbmFhclVZSVlzN1JxVUFUV1h6NGJQcWhrNlFFUmJkcEtSRHJ3?=
 =?utf-8?B?dzVxS1JWWUJQcS9hVmdzOHNvV2dSY3gvVTRkOTNvRis2dGtUUlFMeUdGUUY5?=
 =?utf-8?B?WFdrbnFTWUM3dkszdWQ2a2IyblJQRUxXbmFjTi9LU2R5Z053cEc4WHNLL2li?=
 =?utf-8?B?MHhoNW9CaFFPTGZ5WEdWNjRVVG1rMTA3bmVvR0VTMWlNUjNuTU5YUDBnRXcr?=
 =?utf-8?B?YmV1cXF5SlNVL3VicmhMMEN2M3ZCZFV4a3I2VzJxbldpY05zM0xLSGx0VWZE?=
 =?utf-8?B?ejhGZVFYcCtSa2RZY3NITEhDR3ZMQ2NmM1VtOTEyUnJNV1pYS1dSOTVKRVMr?=
 =?utf-8?B?VjdTYkg3QWdSTGJIeHVQWnV5dEtEYTNqUzhldW9jVGZRMlZMcW0xT2dwUGVp?=
 =?utf-8?B?MitGTEltWE9jeDNOdHo3Mzc2bWliQnMycFl3NUxQalFKVVhjOWlQNnlKZHJl?=
 =?utf-8?B?Vkc0eG5sSkswd0IxOTl2Q3RPTElIYllBdkFsTDZkMlRKbnVCUW8wMUxOeXEr?=
 =?utf-8?B?SXBQQ2ZLQ3dUbVFQVkZVTkhOL0lEeTlxcXJ3YWV6Z0hqZnJQbXg1NmlDZTZG?=
 =?utf-8?B?T2NLTXNVUWdEVGxoY0xPWERjUmE3SnV6WlJJYWs3QUp6RldDelJ0dG9WbDJz?=
 =?utf-8?B?WGlVNTVVclN2Z1VpbExPM054ZkdRZGVFV2hrM0QxRk5TQ3pzcFdtVFVJcHBu?=
 =?utf-8?B?YVBNd2tGZzlFK1N4bkZ6Y01oaHdxeE5mTHBxaitrSmxTeWhzUWpWWHR0NTZG?=
 =?utf-8?B?QnJ2cDNEZnFrdUdYeFErK1ZxUTl4R1cvZU9GRzNtT3JJSkt3cmMveE14aWJu?=
 =?utf-8?B?NmsxUElCR0ZtQm0xM21UNnByNHRlNE1ySkZGK3MzTFlHZFNFQVFmOTJBQUVY?=
 =?utf-8?B?ZTZ3SFdKcmpxcjVNNXlzZmxsUGdJSGlBY0Q0MUJBY0J3bDFlc1ZYSDY5ajhi?=
 =?utf-8?B?MFVmNVB0dGZoWjBNZGJYU0tjc2VlS0JkektEalhkTXhNS1V3WWt5L0VCNG53?=
 =?utf-8?B?RVdQL3VkbEZzaENIMjJvSVEydjJZTENMQzZ3ZkpmcHpsNC9OajBaZjRpZ3dW?=
 =?utf-8?B?VDBiNEFlQW81blpUc2R2RzBkTFJwS2toMmo0N1hrOFRISTVmd0Via2U1aEI3?=
 =?utf-8?B?V0FIaW9YZGZBQnFaVXpSSTA4UUJzOTI0NUs5T04zcGROelg4R3M3TTZJRW52?=
 =?utf-8?B?K0hGZ0RpRm93S1J4VXkwck5DWVp5YVFyb1czR2l3K0xvTC96K0hudHdMUGx2?=
 =?utf-8?B?L09XQVBEeWFhM0FFenhCWjJ4VWNtTTg5eFJ2cWt0d1JYSzIzSjNiaW8ySDZn?=
 =?utf-8?B?eWRjdDNVbURzMzcyaXdBa3czdEFjelE2Y0txaGdiM1JXcGxTUk9JaENVQkFy?=
 =?utf-8?B?YWhMcGpsZGFOU0Yvc0pza3plM1E5YlRjUkF6QVZuTFdUdlJKVk1mTi9FTjRF?=
 =?utf-8?Q?nOFPB5kXzLsGXSM648UoTN29z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b99792c-70cd-439d-0376-08ddbd763991
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2025 16:49:22.9307
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5IC8D3D4O1ZeKZ2SeCh1YLva4uRYBxWqz/z+8zJ3HzHA2J8wFoUhmGhY98YTgrvdgMS9y8RRZnJ/ezl3TzAypg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF1394451C7

On 7/1/25 15:15, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding needs to be enabled on SNP_INIT_EX.

How about:

In order for ciphertext hiding to be enabled, it must be specified on
the SNP_INIT_EX command as part of SNP initialization.

> 
> Enhance sev_platform_init_args by adding a new argument that enables the
> KVM module to specify whether the Ciphertext Hiding feature should be
> activated during SNP initialization. Additionally, this argument will
> allow for the definition of the maximum ASID that can be used for an
> SEV-SNP guest when Ciphertext Hiding is enabled.

Modify the sev_platform_init_args structure used as input to
sev_platform_init(), to add a field that, when non-zero, indicates
ciphertext hiding should be enabled and indicates the maximum ASID that
can be used for an SEV-SNP guest.

I think that reads a bit cleaner and clearer.

> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 12 +++++++++---
>  include/linux/psp-sev.h      | 10 ++++++++--
>  2 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 3f2bbba93617..c883ccf8c3ff 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -1186,7 +1186,7 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>  	return 0;
>  }
>  
> -static int __sev_snp_init_locked(int *error)
> +static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>  {
>  	struct psp_device *psp = psp_master;
>  	struct sev_data_snp_init_ex data;
> @@ -1247,6 +1247,12 @@ static int __sev_snp_init_locked(int *error)
>  		}
>  
>  		memset(&data, 0, sizeof(data));
> +
> +		if (max_snp_asid) {
> +			data.ciphertext_hiding_en = 1;
> +			data.max_snp_asid = max_snp_asid;
> +		}
> +
>  		data.init_rmp = 1;
>  		data.list_paddr_en = 1;
>  		data.list_paddr = __psp_pa(snp_range_list);
> @@ -1433,7 +1439,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>  	if (sev->sev_plat_status.state == SEV_STATE_INIT)
>  		return 0;
>  
> -	rc = __sev_snp_init_locked(&args->error);
> +	rc = __sev_snp_init_locked(&args->error, args->max_snp_asid);
>  	if (rc && rc != -ENODEV)
>  		return rc;
>  
> @@ -1516,7 +1522,7 @@ static int snp_move_to_init_state(struct sev_issue_cmd *argp, bool *shutdown_req
>  {
>  	int error, rc;
>  
> -	rc = __sev_snp_init_locked(&error);
> +	rc = __sev_snp_init_locked(&error, 0);
>  	if (rc) {
>  		argp->error = SEV_RET_INVALID_PLATFORM_STATE;
>  		return rc;
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index ca19fddfcd4d..b6eda9c560ee 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -748,10 +748,13 @@ struct sev_data_snp_guest_request {
>  struct sev_data_snp_init_ex {
>  	u32 init_rmp:1;
>  	u32 list_paddr_en:1;
> -	u32 rsvd:30;
> +	u32 rapl_dis:1;
> +	u32 ciphertext_hiding_en:1;
> +	u32 rsvd:28;
>  	u32 rsvd1;
>  	u64 list_paddr;
> -	u8  rsvd2[48];
> +	u16 max_snp_asid;
> +	u8  rsvd2[46];
>  } __packed;
>  
>  /**
> @@ -800,10 +803,13 @@ struct sev_data_snp_shutdown_ex {
>   * @probe: True if this is being called as part of CCP module probe, which
>   *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
>   *  unless psp_init_on_probe module param is set
> + * @max_snp_asid: maximum ASID usable for SEV-SNP guest if
> + *  CipherTextHiding feature is to be enabled

when non-zero, enable ciphertext hiding and specify the maximum ASID
that can be used for an SEV-SNP guest.

Thanks,
Tom

>   */
>  struct sev_platform_init_args {
>  	int error;
>  	bool probe;
> +	unsigned int max_snp_asid;
>  };
>  
>  /**

