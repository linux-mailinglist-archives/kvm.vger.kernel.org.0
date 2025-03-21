Return-Path: <kvm+bounces-41658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD08A6BC04
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 503DA1894F5A
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A1A46434;
	Fri, 21 Mar 2025 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0tYcfXfW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2051.outbound.protection.outlook.com [40.107.93.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3233C47B;
	Fri, 21 Mar 2025 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742564988; cv=fail; b=svRE3GQkvkUnCuI5HxucwXOfXfQGtFV5YUAgcnxAGBfsvwRAuJBDzi3kcs+MiCwheQUrKTbpFHpTTsJEvOw2/Yyo+Ek0dyI9Lh2Ylt3Yp5O+BXI+Xkm8ydUXD17q0txhkosvkStB+zZ6rcbN5KYQLMhi3M50DlmB06Mny8WDsbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742564988; c=relaxed/simple;
	bh=C9EmP1HuKXrL1bfhYWw439OB5xatIX1p3ITVGGNcLLc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tMLSweXu/0w3CpRxwYwxj0Lgm7O/KBnZUra1ZB2g6i1a8hekIBpAMXS5h8UpbRBJGZVkE4iPYYyLMjY7Py+JB7buxc1SuKjRivoyhySDZnElA56l4dH5h06/gmUD3pZf12sCGzgRWn58No1GFE7xuO2H8uZuUAoEf3vSuM2gito=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0tYcfXfW; arc=fail smtp.client-ip=40.107.93.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t9Lq/bBnVsY3Z7YGkca6HOfShboTchFno3U7JUkLAisftZGaG6Ts9N+j6HxkTzfNqTGY/L5WBGqED1y/HzYsgsHN2lU5Tt3T1KEHWGeZpxDUbL036/na/YAv5VVPTJEXHlUFHgiP/REnuNv/rKNTSi09hDl1gYEawBY9fMJh4wyEmP6Z5Zc26EwP1VG0Gt+z8LZxW4v1P/ACEYTRqmmYlSmIkHm3xqIUm/IxbRUZ2Z+XAUMi+KRsUzu6fyYHMNbS8eqC8PDTNVfpFTVmwRU3BczWqM3useufgT384aSQH1S1C8cE3Ktq9DDhT4ouPdl57L6dxvBCBYKkqgxdLIhYvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/p/FhJG4MphQyTYhjrLxRrZNkSoRnMbmrhqAtBc/ztk=;
 b=YebkbvscYh4a0A/hv6s3Uvyx28e0KKO4XpBCvjoJPD+885Kyus9rOejGmZviFtD04sXl+vJi1wpdEy4DfQYfbWyG5Fpb/inHXRJ2zlaQlNVgySDS8sFxEvElWiKTlq7yA1bRrHj+rvKSr9L9TFeEx7W7CehQivRIpS1Gv0f67l/iXcx6jLhppT267dWnKyKGPyco5vTGS97liHYTysLfHVBxO913MUmPSRIBUEyi/6jdhkmX4sPgb/UXD93UXBw42FopUZjcNVvRPOEKcxNRpcnqTmk1Bb4cYIvB2Gas2olVzuYK4sjD5fFun7XKXIJsc0Pu9R3wv2LwLhnMpqsevA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/p/FhJG4MphQyTYhjrLxRrZNkSoRnMbmrhqAtBc/ztk=;
 b=0tYcfXfW17rF3HvnxQDOV5cvqRcZx+TFvcSLg8+0gL6zynQ3zJG54JBhA+ewx9jJqyy0c/uWPCItrSSP24KbPqazu7zUFyk2JJ3OGKm8PjK0WI8zZZ20/quDsq8sPeK4OygeZDa1w4xERZpjA02SzD1PR9t/cGl8qsXRJ4ul6xE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SA1PR12MB8161.namprd12.prod.outlook.com (2603:10b6:806:330::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.36; Fri, 21 Mar 2025 13:49:43 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 13:49:43 +0000
Message-ID: <a7d25143-ec72-42fe-b345-47ea0361c4b6@amd.com>
Date: Fri, 21 Mar 2025 19:19:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 02/17] x86/apic: Initialize Secure AVIC APIC backing page
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-3-Neeraj.Upadhyay@amd.com> <87sen63505.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87sen63505.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: JH0PR01CA0009.apcprd01.prod.exchangelabs.com
 (2603:1096:990:56::16) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SA1PR12MB8161:EE_
X-MS-Office365-Filtering-Correlation-Id: 485f302f-8321-4be2-454a-08dd687f3bec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vm1qN083YWcwZnh6aHZvKzd1OVNNSGVEbXllMkl2bkFRck9yUDMzUURtQkt3?=
 =?utf-8?B?c2xaeDNiSXNBb1JvMlRFK01meHg2YStIZ0tHemw1b3IzaW5ucy83a0Y5amJK?=
 =?utf-8?B?c1ByNXFua1FBZlhCMGw2SGVJUkZFM3VobHdxVWl5UEhkOE1WRys5UzZwYnRl?=
 =?utf-8?B?U2FTL1RzZDVLNnBBY25PQ0t2ZGJld3ZRL3hXcnlWNTdSQUFrcTJrMXFIc01R?=
 =?utf-8?B?SEhMaHUveldMM3BJR29mekx6bHlWRnpoaEpDanBuK29QdE92cHFGQnd3aUlh?=
 =?utf-8?B?Rm1uc2tOYzFwUVE1V2wzR241MjdFZ0tIMFk0S0FZL09LNHRldjNkN01Valgv?=
 =?utf-8?B?VER5elFWLzliWG1RN1VPZ3R4b0J5MHZ5V1owdUNYaURtcmR4YTR5aTFKWUts?=
 =?utf-8?B?aFg5MUsyVVFsZHhodmFUVGFxYzlKTzZiN3RGRzlva2tBRU0yMS8vaFNrdnJw?=
 =?utf-8?B?V0p6VXV5U2lSSlhLR2I3RE5YeEF6QjJJUTJyKzdEdjc0RFFBaXFNMXZseHRX?=
 =?utf-8?B?NlpJQVVmVUFpZEdXVjNBV3BEcllnU1ViL3JJVVBtNWxYM3lJQlErQWp2U0FS?=
 =?utf-8?B?YkxSNXpTY1pjWDJkOHdwVzZaalpKanJEMHd0ZzcxanhFZlpmY2VRTWxDU015?=
 =?utf-8?B?eVE3a3ZWclRGM2JIdUJ4WEZabW8wMUFoam1ad3RJbjBXK2tkUHFIa2dKc1dT?=
 =?utf-8?B?TE5XdzhnVXRKMGRFdnBVcExxaXExRmlUK1c5ZlUvbFY5aXAzQWVSZTY3a2pV?=
 =?utf-8?B?NVphSWpvSHhXNko2bmc3U1RIUjFNbFZHMUJmUDl0MXlsbmhVRTBRa21WNVVv?=
 =?utf-8?B?SXRMUWtyYm1DYUhBVDRjU0o0Ui9iSXN6M0JyS1Y5eXRaUGNSZXBSc0MrNWhp?=
 =?utf-8?B?QWo3RVIwSUhneVhST1pYZmZZUmJuMVZHUzdsU2VWamltKzdqSnViakk2cnNS?=
 =?utf-8?B?VW5FWjYrNnVMcDdvUTBKOHBFOWdzMzc3ekYvOHJtQ3Jyd0FJdHRwR253RjVF?=
 =?utf-8?B?WUswSVNvUHBoUWlUcHFWN29vLzZ1UDM2cXZQdnRqZ0lXbG5JNDZNdUQ3NmRB?=
 =?utf-8?B?aUVRR25MV1BpNU9IL0xleFU5RUxHQlRiTTdiZ0l6VnI4U0FTTTZGazhmdWVv?=
 =?utf-8?B?TEx3amlJcW55QVNnWlRCNjVOcXViWnB4TU1ncEdwUWRObE4wV3JLQnh1dUdQ?=
 =?utf-8?B?K1lLc0xjb09ObWMwSTJlVCtOeXVTTEROMUJCOGhrdkpjdXgwcTFhWjhPWWZ3?=
 =?utf-8?B?Y1l3VVV6V0pIWUVGNXBPOVRpY0E3NllLRTIzNE02MDZkMDRIQlg2SXdtY1Iw?=
 =?utf-8?B?ZWVyVDBmWVhITmJFNWgzR0RiQ1pKcHc5Q0NSU09SdjYvdUs1WmthazBNeE1t?=
 =?utf-8?B?SkNtQzlaZzc2dDFEdWF1QW9vUGhzY2tkaFZyRy9ZaDBrc29MdUFmT2FNdHBB?=
 =?utf-8?B?TkN1WDdQQy9MVXBOUXVqWmlHUlhVNm8zWkJaUEIyRmRJTXU5cFRLdG5oWjBl?=
 =?utf-8?B?T2x2Mi9MZDFpUzJGemZaWkJQcE16WllLb1BzM2NwSUdJem1mcTgzSnNIUEtQ?=
 =?utf-8?B?SlBaRmt3WGNaOTd1Z2p2K1p4RXN1OFJKbTM4aFArN2hNa2d0Nkoyb0R0eWZV?=
 =?utf-8?B?a3RTY2c3dGxjQ0FlYU8vNllneUg2R1gwei9sZ08vOWVydWJSb2Fqa2xRZmE0?=
 =?utf-8?B?ZmcvMGxqNE1tS1ZWdVdIUHhyZGVGK0hBMGgxVWdQcjlQeUJQSlBKMGRNRXpQ?=
 =?utf-8?B?QnBOOFBxZXk2ZVZvVldiWElpcHNQUFRadzZtbFE2aXlJRlBVWG5lcFNNQUhy?=
 =?utf-8?B?Z0E1c1ZzUEZtVTNvZDZiN0lQb2dQRHZHZGp3SjBkUUJ2TVNnVVhxQ24vaTlN?=
 =?utf-8?Q?uD+/q5cIsheBV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SEw1OGhqdmdmTGhlL3hEQ1hUUlRVUzR1ZzltdU90ZmlvV1p5VStRMThRcU85?=
 =?utf-8?B?YWxtRENWSFFHVnBtQkpmOXJIVUlmL3NkTER6ZS9QZ3Z5dmtyOTdNWUdLMEpu?=
 =?utf-8?B?c1gwd01qbFQ5TTF4cEFma3ZFNE9XcmV5YUR2aktNdUxuUHJBSG1qbTZYbGV2?=
 =?utf-8?B?SFh1R3NHSXVmY1J2MHUvbGRzOWdmZGlLdFdESDhydC9TVUpNRy9SWUJDdHN5?=
 =?utf-8?B?M1czTHFCV3pEcVlWWU9YbG9CVWpuZzJXblJ0OEpUZC9xVjdrTDUzZEYxMTcw?=
 =?utf-8?B?NlpoYzEvRWd2OFRxcExRMEFnM0MxaExROWNzYVFpQlJSNGlYSmxMUDk2QWJF?=
 =?utf-8?B?VVpOYVd3Y3N4bytPN25LZlBxVEVuZ3NEWUJjVkRjLzRnSG9JaVdVV1FQWFB0?=
 =?utf-8?B?TXVJQXZvVmVpK0VXVjJYSHhQbmMyL0x5aFZQUjkyL2V5eVZQWVRNVzZQU0hG?=
 =?utf-8?B?a2FjZ2N1aXoyS3ZIeVVkZWg0dGR1U044VnlqM242UW1NZFBrbFlLU2hrMEgw?=
 =?utf-8?B?cHhTaC90SlduT2lGM0RYQ3dFL2JYQkUzNjFsUkQ1Q0NGQ2pVRWhYcjZuMHVx?=
 =?utf-8?B?ajNpSWZSUW9rZHpDalZxM0FxN2pLclVQKzRCdjZ3bEEwRkY1V09FY1A1OFJC?=
 =?utf-8?B?cWhySXJKOUNkMGZUcEtTTWNwWE1JNzF6Q1ZYZzFDaVZOTFBPN2E0NlM0QTg0?=
 =?utf-8?B?a0lydTNZbnRnNi9ZbVQya0lTL0h1Y2VOdnNLRlRFWlZvV2lxczQxYU92L01M?=
 =?utf-8?B?VlRkNDF5Y1crYWZONTdLcGtGb0xwakh5akx6V1gremxpdmErbm4wcll1eXM4?=
 =?utf-8?B?K0tGRmIxVnlDU2JaUFhFVjNqNTcvTE1ITlFmWC9GUTRjWFJMMExCVWIxNUhO?=
 =?utf-8?B?QlBqbU9DRjdyeTByQXo2UDJKbVR3aFR4TU5UVXZ1OWZzOXZNVmZHU1lOWTJL?=
 =?utf-8?B?N3FOYjE1TkZrcHBhNXNlZEd3czZiYmZkbVFhellic0Q1QjhLbjRWOWNPckpJ?=
 =?utf-8?B?bGFjMTNEOVo1NUh0T3dYR1lHZmtNaUlQcjYySnloakdEd01Ia2FPZ21waGU2?=
 =?utf-8?B?QnVOU2o0T3NoZU95bmhIRHBuRUE1VzFaSitLRGoxUThJZXlXTDFBbFYrc2pP?=
 =?utf-8?B?aWdPdk5VVkhmWWN1STV0RnVRQVkrTUJxMFNPYW1XZm1KK05lSE1jdmN3VWdP?=
 =?utf-8?B?aG9XMGxsa2JTNnVUUEh5Zlg4NURuNllvdzhLQ2J1MXhvdHZiV2VUTzZWcGs2?=
 =?utf-8?B?cEJtMjlBYXlKcTlmL0puRi9ycExXTlRwWTJyRllvcmdsNWppMTVRLzJ0SWtB?=
 =?utf-8?B?V3FzZ3EyTVJncXhyV0daMk8rZlNnMHV6Q2grYmErVmkwckpEdDV1TW91NHpQ?=
 =?utf-8?B?RHJxM1lXYVVzT0M1bnUzdFowK0ZRZ2ZPRWo1RDdOaGgzRmZETFhtYnd4SDVp?=
 =?utf-8?B?Rm1VdnVGSkR2T0pUUVpla3lDUXhmQkFKZ3FBTHhlVm5VV05iK3VNaWVrT28w?=
 =?utf-8?B?K0hTTFNVekVOVm9GbENEZDNSa2ZWc0ZIVW92UG9pWmZpc0J6enE4cWFsZ0Jv?=
 =?utf-8?B?V1dNaEgwVDZZc0ZCbnpORm9Vbk9tMjZrT0hiMzkyR3hKUjdxckhXMzh3ejFp?=
 =?utf-8?B?S3pySHhzMWdOajdNeXVzWU5zbnljY2VENTdDR1Z0MHVxZGFYMGVTb1FDVW5F?=
 =?utf-8?B?bWFtcXozSTh3RHg3OTEzSWhxQVZyR3FjZUViTU9CaEpZRUROUndKdUJ5YXlu?=
 =?utf-8?B?OXpUQmpuTkVCVHdhOWFKV2VYa0lQKzhKREJZQmVJSUhPdE5iYW93TnRLTFps?=
 =?utf-8?B?SlN1eEM0djgwWjhYNlRVc1MzQWsvcitZK1A3a3dkM2RSU1hKV1FSMTNtcEl3?=
 =?utf-8?B?Z21YUGU4amNSejErUWtPK2EvdlVMV3ZadUs0MWUrcmpiYjRhM1lSNkFSR29v?=
 =?utf-8?B?UW1NRDVIaTMrZXQ5UGVtWW5lU3pKVXlPZlhzMG1oMGlCQmtsakdZVC9sSDlh?=
 =?utf-8?B?VU9oYXFLT3ZaN2E0QTVxL3ZOTnlVWVAwa0lnajVyUGF2ZDh0M1VIcmZUYXI1?=
 =?utf-8?B?TDNpTTc0VlUxakh6UDJSR2g3RW1ReEN4NEl0YTMvbGxkVkpvTVVKWGg0R0Ey?=
 =?utf-8?Q?6zDPRbjlccptw5IHPCBeXIZRb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 485f302f-8321-4be2-454a-08dd687f3bec
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 13:49:43.5601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hr0ucEyrTs80PHwtf3VZaa9iXy1JxoRdufHC7OtpZAv7aKutmsGz2Zj0Ux62bm4t1ieTRcXEmuxAybPyo2g0Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8161



On 3/21/2025 6:38 PM, Thomas Gleixner wrote:
> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>> @@ -1504,6 +1504,8 @@ static void setup_local_APIC(void)
>>  		return;
>>  	}
>>  
>> +	if (apic->setup)
>> +		apic->setup();
> 
> That's broken for AP bringup. This is invoked from ap_starting()
> _before_ anything of the CPU is populated. You _CANNOT_ 
> 
>> +static void x2apic_savic_setup(void)
>> +{
>> +	void *backing_page;
>> +	enum es_result ret;
>> +	unsigned long gpa;
>> +
>> +	if (this_cpu_read(apic_backing_page))
>> +		return;
>> +
>> +	backing_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
> 
> allocate memory at that point. This was clearly never tested with any
> debugging enabled. And no GFP_ATOMIC is not the right thing either.
> 
> This allocation has to happen on the control CPU before the AP is kicked
> into life.
> 

I see. I missed this. I now see warnings with CONFIG_DEBUG_ATOMIC_SLEEP
enabled.

> But the right thing to do is:
> 
> struct apic_page __percpu *backing_page __ro_after_init;
> 
> and do once on the boot CPU:
> 
>     backing_page = alloc_percpu(struct apic_page);
> 

Ok, got it. Thanks for providing the correct way to do it!


- Neeraj

> I talk more about that struct apic_page in the context of a subsequent
> patch.
> 
> Thanks,
> 
>         tglx


