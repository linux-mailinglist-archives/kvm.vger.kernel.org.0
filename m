Return-Path: <kvm+bounces-59627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30AC4BC3613
	for <lists+kvm@lfdr.de>; Wed, 08 Oct 2025 07:26:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBD763BD826
	for <lists+kvm@lfdr.de>; Wed,  8 Oct 2025 05:26:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F2962D876A;
	Wed,  8 Oct 2025 05:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yBiulb2/"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011054.outbound.protection.outlook.com [52.101.62.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629A729B8D3;
	Wed,  8 Oct 2025 05:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759901172; cv=fail; b=LuqbBpXMv+CFMIlahZx+HD0DMC7OWLmsd3HBMkPYUUduYnBSYrrti1gVLifO6sKrMEM0HOfTNfMrZd9anNN2wIwQ7mt2hzvoQYyc+o/PfirqJiL4T55HRCMr50pC9j8BlboHt3LmEqggMDjy9R5ulhPpU89qyCJFEo78mia1M+I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759901172; c=relaxed/simple;
	bh=PRdg8nffhWtiLDPSMJ2317qFcfqTOZPt0auz9XtkaNk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AlBlsPkske3RX8sEbp+4DQwAo1soPc4COJuwkFQXfamf0MjWxnlvfY5cL3a3cyNHYHzJl3FKdBTBA2+zvPf5cVfyHf0MXmWkUOPwqT54DD7uNB7Aq4m9cfoK/9vDdVCXJaMEU7CdmWOUV5Ak5uQVQqlVIj5OsV8m6bXlxSS9VQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yBiulb2/; arc=fail smtp.client-ip=52.101.62.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GuX/ePOG4s/5jeASl8Jly1cMG8tLW1COC5hodWtKWGhCMnMNq9DAto2MTsqgM3gAvrF/cS0nZQEdPoMgpxwtbAf5vtLkXSStExGhFq6LFpwPVmf/55QTvLOGP9G0qrncB10dmP1vcIXPhANsoRdtF3iaIA5gj63dyEyZ3blgbSYiFVjo3lz95fXZJ+L2TZn0dxeAS6IdJGts24DjvKVYYP+WmB3LD8Nir+nbtit5O2AB+JefMs968tIdTkuIA7GMtTdDQXhgyW6tpKlnPabS+zSFpMYXE3XaE2QFcEOpuBmAwZy1gn6C4eq+izRHhLn1Hn/mQ+j+jAFUS6HtoWA4rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JX/W1dFo6XygNXYJdEpRSmddYoXpHRNkDVKnOvQoF1s=;
 b=xm2XkDCMe+NUb0oA2mX2GUB7G0VaGesmFsReVwDOC+H94x2YPoUufxC13oiV3e2ZHDpGyQR7lpEBXtD9kb4pdGD+T7ioteDRyMlz69YJagFKnrze+a4NpxQCfFGPXXfXcUM/6OnqfOuzlFYT0U/MxGwpIhoC3+u147ZdH4D93TgZkMZd1gLcUkBKM8FE8Y+qgytMgZjptAffvtcg3KsoqqfhoC4H71RzE18E7fUwPTQuHYnabra1aaLaS/QI/zHuFrWfyxq0ruBSLUCB32UzAhtRS0gw1k1ZIHt1c21fxoU8F/IJesUgbgvl/saonUoX+c5zsqdSPcWpn1gXjBIz2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JX/W1dFo6XygNXYJdEpRSmddYoXpHRNkDVKnOvQoF1s=;
 b=yBiulb2/ChcmUd5FDQyZEspZRWoNl78aeLa8NfPb66/zKd5YvupBhMaRjdRpzYOI2Ib3LDvBtcVsDXLlM6YAb7OQ2XwLNL/LSIvFnEDC7tRG8AmRz27siyw4ty/TohLAb/0VjJ/jssmdCViA9+AZkgWsv5NJaVs91ZHBjHfvl2s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by SJ2PR12MB8740.namprd12.prod.outlook.com (2603:10b6:a03:53f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Wed, 8 Oct
 2025 05:25:56 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 05:25:55 +0000
Message-ID: <dd948073-0839-4f75-8cec-1f3041231ed7@amd.com>
Date: Wed, 8 Oct 2025 10:55:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 01/12] KVM: guest_memfd: Rename "struct kvm_gmem" to
 "struct gmem_file"
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ackerley Tng <ackerleytng@google.com>, Ashish Kalra <ashish.kalra@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>
References: <20251007221420.344669-1-seanjc@google.com>
 <20251007221420.344669-2-seanjc@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <20251007221420.344669-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::13) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|SJ2PR12MB8740:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f84438b-2219-4010-abe9-08de062b279f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WEcxT0ZTY0dMNEFzcmVvSGFPaGhBU3JMd1daQk9PZlNBdkV1MTFuMVRESjJG?=
 =?utf-8?B?cnZzOGJ3OFB4ZHpBVGJBSGg4R2dXcGJibjlWMWhzc2lSK2NMT2pIcXlpVEoy?=
 =?utf-8?B?MXhhLzA3dElQODN4U0FNZmJMWFlkUDB4MGYvMVdkd3lkamJLRHlGdkJVR3Bh?=
 =?utf-8?B?M2JEcWpBV3JBdjNnZlY0ZTNRUXJzZzBydzN5YUU4bkxDR0tyMlU4WDRFbjVr?=
 =?utf-8?B?ZmN2eFZuSEFXRVZuTlNubGxDbTdmMGgvZzE4d0d4WTNSQXhrSy8vL0YrOUlN?=
 =?utf-8?B?M2ZPTTBlTDZlWnhPclJjQTFGaE5FekFraW5uY0RXbHpzeVhuYTZITGZWUzV6?=
 =?utf-8?B?cWVCL1c0Uk9qQ1dRb0FZVStIWmx6ZWNZOW1tempOZTUyV1ZDbEN0ZTc2blZS?=
 =?utf-8?B?Q3Zhc1E2M3JkY2RPUjBVb3Z1ek9ieDdEQVJydlJ5cHA5SHpweXB0NURvdy9T?=
 =?utf-8?B?RW0wZENFaG5kZkFxakhKNjBoYUZpZWRIcjRWUHJwMk1sRW1iSGpTQVUxbzBv?=
 =?utf-8?B?aVNEckFXa3B4SHRJdTljRUl1a1MybldaWllmVEd2dVJBY1o2b1RSQ0E4aHA0?=
 =?utf-8?B?blkxbHhGVndrWWNtWlRvaUcrTUUrL29DOU5yUk9CM2hQT1hkRDlOMlVraEN0?=
 =?utf-8?B?a1FwTWcvUGZjME1JcGJ6SE5LM1YvUmFhdmxDc1A0MHlMUFRNb2RZWVpwdDR3?=
 =?utf-8?B?WU9RNndPaHBSeUlldlNqWjZqVzBkODh1bFRPdWhuU3JTMmRDWWJTZHZqbUF0?=
 =?utf-8?B?UUhGSVBiR00zSU43SGFPSE5ZUW81azRGMVRtVGFUYzJEZmRWcHV4WTlLYzg2?=
 =?utf-8?B?aFkvVlIvRzkwN2l3QmNzZDIyUlFDcXA2ZHptNkkva0t3bElnV2hDZkRHMGls?=
 =?utf-8?B?RGlncnBpNm8zbWxHcitnN0xSamo1eEpPb1VndStrNFVSMTM3YUluUjlrR1RM?=
 =?utf-8?B?WTBrVkF1R3BEb1ZlcXdYNnpUdzhiUmg0c0RNUE5uWFFMQmJKZkdBY3JaQzZm?=
 =?utf-8?B?NWhWcDNPR05oRUd1RkEwMGN5Q09NeHNWd1BBQ2IxZ0hjcnZqTldEU21zRzJ2?=
 =?utf-8?B?cm9xbmUyc2FneWN3QkhkRHRGZEpmZ1NrNXdvMGF2aDRtVDF6QUdyOXh3VGp5?=
 =?utf-8?B?ekE5TmZTeEVKcisyUHFWOVJ0NTlQQWh0ajgydFlGNG1BRnc4ZU9JKzNnSlJ4?=
 =?utf-8?B?SXd2QzFTZFJvMmdUa0R3Zmo0TVNwK2Q1TzU3a2tZdnVEWUN0bUFkbHJuaU0z?=
 =?utf-8?B?K21rZ2wrclFVYUQvci9UY1RkaWZnM3ZQQk5UL05FSzNUaUxJZlZtMTJhR0Vp?=
 =?utf-8?B?bEhjS1dSTDducnBjZDI5enRtOS91bHQ1UkE2V0hHMnY2YzZ1M3BDUjhhbXYx?=
 =?utf-8?B?MzJOc1NwcXdQNEo4aXlYd3ZMN3V5MmUrRG1RWkIvN1Y3RTFyeVg0MjRpa3Fk?=
 =?utf-8?B?Y0lHMHBPSFJ2TXJkamkvcjAvSmI0YUg5anFJWWNBK05CazJGYk8wZks2VytO?=
 =?utf-8?B?U2svclRtSE02SHFTOWdQVUtMUG5UdUhEYnd4UHJ0NkxhNURVeXpFN1Bva01h?=
 =?utf-8?B?aURFTnQxMm5uTDJ0UUpGWkFUdmphQzE0Y2Z3SWxjeFl0TzgxeEVIbUZSVSth?=
 =?utf-8?B?YnN2NUUvVFkvSTFwcVM5M1RRdTZ2YWxhdElQYU00aVNzSEwvRFR5Zm9Yd1ZN?=
 =?utf-8?B?bU1nc3NlL210M1FhMDY4dW00N3dSQjVER2d6elZHRVoxclladUIxbm4rNFZ2?=
 =?utf-8?B?VDJleHpnaGo3Y0NnOHliTjdncVF5YXpIMFFxZEg4ZjRYYzFiN0pFdjlQamRt?=
 =?utf-8?B?eEVRUlgwWlpoSkpCNzdSc1drTzVIOVB4akxBNVp0OHBIY1UyMjdtZXo1OVp1?=
 =?utf-8?B?TmZrTlVOQlhiSHJkNUF6T2RkQzZsenNhSlJFYmwyVFdVZmc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U1pXeTc0ZUFxaXhTWFJKcFRUK2N0MldMVWt1Y0djZ0VFM1piSDMwOWtjV3Jv?=
 =?utf-8?B?Nis3OFhjWnhNbVFFcFdycDliOUpnNTlrN2JvYk5weHJ1UVpYSThBV3p0NFFL?=
 =?utf-8?B?TXdrNkhmTVh5V2FoN2NDUXFTZXRmV3N6MDl5cW1uTDQwMGVCUDV1VGVVbjNS?=
 =?utf-8?B?TmxheGpBd1F0MTFmcVhIWlI1MktPSTlvcURnWXM0TE55RDZ3TW9XM3dtZlBL?=
 =?utf-8?B?OFFvQXdWbmtHMEYzdlo5TjJuNHZOQ2djZkQwTDVURXFUYWtweDZqai9uMWRU?=
 =?utf-8?B?cjNvMmV6OTNpQ29EanE5M21nNkdROGRjWUJlczA3Q0VlVU5ZR3JsUzdRWjMx?=
 =?utf-8?B?VGdxdndkZVpGdnBudGE0N0NNYXZxbHlYM1d0UVE0eUdJUTlNblExbUdtVXVC?=
 =?utf-8?B?dW1reG9vdHdaSXBCOHdYL0wyT1RaaU9ZN2lReWlFMWhuanRRZ29ydS9WdW5u?=
 =?utf-8?B?b1J5NlBLTmxyVG55ZVZjT3hEdWVaQzZvMFlPNUIvQnJIQUg2NFNpajZIamRt?=
 =?utf-8?B?dHhsRFMvd0FubmVOS2RXakJiWVFrRWQ5Nk1SOHI4SmlUQUhIRmhyUXRVTk5O?=
 =?utf-8?B?WEdIRXkvNFRQVXVsQnVVNFVVd2FPeE9pRy85SWdFMDdabUJTclV5VnVrWkZF?=
 =?utf-8?B?Wi9RV1BCdnNNcTlONCs5N2F4Y3IyYnhRbWVoVmM4SEdlTVNYWm9FbGZ4MXFQ?=
 =?utf-8?B?ejJUR0QvRHFEM2NnaUNYM3ViQ0ViTDZuaFgrTmRYVXlHQWdEMlRHNFNteGMy?=
 =?utf-8?B?enowOGFqbXIzcUgxZkZpTVhtZUxnYnA5SkltY1FGdDQ1dDF3MUorcCtNNFdQ?=
 =?utf-8?B?dkp2a1puZlBUd1VUU2F0d21wTGUvL3pDRVRWU1diZlhVeDZFeXVHL0xoQlUv?=
 =?utf-8?B?NFJJYmgwdGwrWlhjQmdvUlkvd3BzaWVSamF5NCtsWDhOS0dkMUVpK3hUVTdv?=
 =?utf-8?B?bGQ3ZHdKcHRxV3Zza1RhZ1VkRVRQYlZXSHZKb3RMMk9CTnlaZTcyR0JnSm1L?=
 =?utf-8?B?Rm9TcUlQN294RHNVNkQvR2lWWHZBYU04UDFZYnNLd0JadWN2ZjZLUkhvekx3?=
 =?utf-8?B?dU1iTnNMYWtPNVU3ZWxNSnRvWXd0TlFwSUJQN2Vja1NhSXh3Vk5Lb3RWQ3JK?=
 =?utf-8?B?aTdRaDBBbHZES0NTZEIrdjk1N0Y0c2F1MFljaUNKR2ZqQnZDSEw5RzVsS2NE?=
 =?utf-8?B?c21hbFc5STQ0cnVVWStNV0RMdHZPY0hHR2p5WWhpTFpadWN0TmwwUnM3bDlt?=
 =?utf-8?B?aEhhRzhmdDFsUDBmL0dIYURhTGJaWDZaODQxWW5mYU4yZURQaWZTUFc3NU9m?=
 =?utf-8?B?UVl1YnVMYm5Sd2lqOGIveFRVeE1OMWVTK2xHOVNIOVBtWDZyTS82V1YwZ1cr?=
 =?utf-8?B?UHpKMHRHMjhsekZiR0grUlh0cERrckRNOE5mM0h3V3VXajFWZThRL01kUkNh?=
 =?utf-8?B?ck1xMUl3TUNkamx3bkhjcnFIbHNJRGZKS05TYWY3dGY1OVFQNGtFQ1JrQ0tp?=
 =?utf-8?B?djhVeDk3WU1hdTZOTlFrS0Q1bytNSjZDOXpvcGJsM2dHUXhPc05ONFF2U1Jq?=
 =?utf-8?B?YUp0Qnp6clZXOS9XVFZaTkNlUGFFZGh1Q2x0SXlGUmM0cnVrQ1FNeWVuR0la?=
 =?utf-8?B?QzdCZTRhRUZaKzRTUjFwM2YyajJnTmNsWHUzWXQ4T3FyNjhQUU9QTEVIYUJT?=
 =?utf-8?B?L1FUOXJXd0Y5Q0xCQlNNTjlPWHYwRnJVbjFSc2R1RUE5RzYwUE9mQnJNcGtH?=
 =?utf-8?B?Tlk5bTZGcjVnd1gwTVROYU1EVm9qZnZianFKMXAzVjQ2Zy94bit2ODF6VnJJ?=
 =?utf-8?B?S2M1SzM2ZFp4QUJKME9PcGdtRE5ySXZzTU9KSzdrUDVkK05MSTNab3pyQlQ4?=
 =?utf-8?B?dkJGdHltNjRyWkEvUEU0UDhmc1Naamkra2NMUVpCaFNZTHNhQlZqUXI4Ung1?=
 =?utf-8?B?bzdKb1NhVWlGNkFXRG8wRWFCdzhpcFNqN0ZjelZ4RzFmQXlOb2Q4Z1dZanZO?=
 =?utf-8?B?KytGQURGazRaL0VGcU9YcjAyM2trM21hd2c2OElOQmlPNEI0a1phSDN4bmN4?=
 =?utf-8?B?elRTdy8xNjRwNWlBSldLVkcwWmRwbmRaNjlQMlkwa09xZnhJNWY4Z25Sd2NR?=
 =?utf-8?Q?iC0z0ePOpv+sqjQnpdm/VfTw6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f84438b-2219-4010-abe9-08de062b279f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 05:25:55.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZVqbNO3eOg5IlqJA6zi4R6kOX9AaYZDDEBeh3+McYqIgrVh1mJ4OPl1JyjZwEYnj+LRJxPgW+Fyl5QaRPA/vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8740



On 10/8/2025 3:44 AM, Sean Christopherson wrote:
> Rename the "kvm_gmem" structure to "gmem_file" in anticipation of using
> dedicated guest_memfd inodes instead of anonyomous inodes, at which point
> the "kvm_gmem" nomenclature becomes quite misleading.  In guest_memfd,
> inodes are effectively the raw underlying physical storage, and will be
> used to track properties of the physical memory, while each gmem file is
> effectively a single VM's view of that storage, and is used to track assets
> specific to its associated VM, e.g. memslots=>gmem bindings.
> 
> Using "kvm_gmem" suggests that the per-VM/per-file structures are _the_
> guest_memfd instance, which almost the exact opposite of reality.
> 
> Opportunistically rename local variables from "gmem" to "f", again to
> avoid confusion once guest_memfd specific inodes come along.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/guest_memfd.c | 100 ++++++++++++++++++++++-------------------
>  1 file changed, 54 insertions(+), 46 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index fbca8c0972da..3c57fb42f12c 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -7,7 +7,16 @@
>  
>  #include "kvm_mm.h"
>  
> -struct kvm_gmem {
> +/*
> + * A guest_memfd instance can be associated multiple VMs, each with its own
> + * "view" of the underlying physical memory.
> + *
> + * The gmem's inode is effectively the raw underlying physical storage, and is
> + * used to track properties of the physical memory, while each gmem file is
> + * effectively a single VM's view of that storage, and is used to track assets
> + * specific to its associated VM, e.g. memslots=>gmem bindings.
> + */
> +struct gmem_file {
>  	struct kvm *kvm;
>  	struct xarray bindings;
>  	struct list_head entry;
> @@ -110,16 +119,16 @@ static enum kvm_gfn_range_filter kvm_gmem_get_invalidate_filter(struct inode *in
>  	return KVM_FILTER_PRIVATE;
>  }
>  
> -static void __kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
> +static void __kvm_gmem_invalidate_begin(struct gmem_file *f, pgoff_t start,
>  					pgoff_t end,
>  					enum kvm_gfn_range_filter attr_filter)
>  {
>  	bool flush = false, found_memslot = false;
>  	struct kvm_memory_slot *slot;
> -	struct kvm *kvm = gmem->kvm;
> +	struct kvm *kvm = f->kvm;
>  	unsigned long index;
>  
> -	xa_for_each_range(&gmem->bindings, index, slot, start, end - 1) {
> +	xa_for_each_range(&f->bindings, index, slot, start, end - 1) {
>  		pgoff_t pgoff = slot->gmem.pgoff;
>  
>  		struct kvm_gfn_range gfn_range = {
> @@ -152,20 +161,20 @@ static void kvm_gmem_invalidate_begin(struct inode *inode, pgoff_t start,
>  {
>  	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
>  	enum kvm_gfn_range_filter attr_filter;
> -	struct kvm_gmem *gmem;
> +	struct gmem_file *f;
>  
>  	attr_filter = kvm_gmem_get_invalidate_filter(inode);
>  
> -	list_for_each_entry(gmem, gmem_list, entry)
> -		__kvm_gmem_invalidate_begin(gmem, start, end, attr_filter);
> +	list_for_each_entry(f, gmem_list, entry)
> +		__kvm_gmem_invalidate_begin(f, start, end, attr_filter);
>  }
>  
> -static void __kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
> +static void __kvm_gmem_invalidate_end(struct gmem_file *f, pgoff_t start,
>  				      pgoff_t end)
>  {
> -	struct kvm *kvm = gmem->kvm;
> +	struct kvm *kvm = f->kvm;
>  
> -	if (xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
> +	if (xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
>  		KVM_MMU_LOCK(kvm);
>  		kvm_mmu_invalidate_end(kvm);
>  		KVM_MMU_UNLOCK(kvm);
> @@ -176,10 +185,10 @@ static void kvm_gmem_invalidate_end(struct inode *inode, pgoff_t start,
>  				    pgoff_t end)
>  {
>  	struct list_head *gmem_list = &inode->i_mapping->i_private_list;
> -	struct kvm_gmem *gmem;
> +	struct gmem_file *f;
>  
> -	list_for_each_entry(gmem, gmem_list, entry)
> -		__kvm_gmem_invalidate_end(gmem, start, end);
> +	list_for_each_entry(f, gmem_list, entry)
> +		__kvm_gmem_invalidate_end(f, start, end);
>  }
>  
>  static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
> @@ -277,9 +286,9 @@ static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>  
>  static int kvm_gmem_release(struct inode *inode, struct file *file)
>  {
> -	struct kvm_gmem *gmem = file->private_data;
> +	struct gmem_file *f = file->private_data;
>  	struct kvm_memory_slot *slot;
> -	struct kvm *kvm = gmem->kvm;
> +	struct kvm *kvm = f->kvm;
>  	unsigned long index;
>  
>  	/*
> @@ -299,7 +308,7 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  
>  	filemap_invalidate_lock(inode->i_mapping);
>  
> -	xa_for_each(&gmem->bindings, index, slot)
> +	xa_for_each(&f->bindings, index, slot)
>  		WRITE_ONCE(slot->gmem.file, NULL);
>  
>  	/*
> @@ -307,18 +316,18 @@ static int kvm_gmem_release(struct inode *inode, struct file *file)
>  	 * Zap all SPTEs pointed at by this file.  Do not free the backing
>  	 * memory, as its lifetime is associated with the inode, not the file.
>  	 */
> -	__kvm_gmem_invalidate_begin(gmem, 0, -1ul,
> +	__kvm_gmem_invalidate_begin(f, 0, -1ul,
>  				    kvm_gmem_get_invalidate_filter(inode));
> -	__kvm_gmem_invalidate_end(gmem, 0, -1ul);
> +	__kvm_gmem_invalidate_end(f, 0, -1ul);
>  
> -	list_del(&gmem->entry);
> +	list_del(&f->entry);
>  
>  	filemap_invalidate_unlock(inode->i_mapping);
>  
>  	mutex_unlock(&kvm->slots_lock);
>  
> -	xa_destroy(&gmem->bindings);
> -	kfree(gmem);
> +	xa_destroy(&f->bindings);
> +	kfree(f);
>  
>  	kvm_put_kvm(kvm);
>  
> @@ -493,7 +502,7 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
>  static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  {
>  	const char *anon_name = "[kvm-gmem]";
> -	struct kvm_gmem *gmem;
> +	struct gmem_file *f;
>  	struct inode *inode;
>  	struct file *file;
>  	int fd, err;
> @@ -502,14 +511,13 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	if (fd < 0)
>  		return fd;
>  
> -	gmem = kzalloc(sizeof(*gmem), GFP_KERNEL);
> -	if (!gmem) {
> +	f = kzalloc(sizeof(*f), GFP_KERNEL);
> +	if (!f) {
>  		err = -ENOMEM;
>  		goto err_fd;
>  	}
>  
> -	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, gmem,
> -					 O_RDWR, NULL);
> +	file = anon_inode_create_getfile(anon_name, &kvm_gmem_fops, f, O_RDWR, NULL);
>  	if (IS_ERR(file)) {
>  		err = PTR_ERR(file);
>  		goto err_gmem;
> @@ -531,15 +539,15 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>  	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>  
>  	kvm_get_kvm(kvm);
> -	gmem->kvm = kvm;
> -	xa_init(&gmem->bindings);
> -	list_add(&gmem->entry, &inode->i_mapping->i_private_list);
> +	f->kvm = kvm;
> +	xa_init(&f->bindings);
> +	list_add(&f->entry, &inode->i_mapping->i_private_list);
>  
>  	fd_install(fd, file);
>  	return fd;
>  
>  err_gmem:
> -	kfree(gmem);
> +	kfree(f);
>  err_fd:
>  	put_unused_fd(fd);
>  	return err;
> @@ -564,7 +572,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  {
>  	loff_t size = slot->npages << PAGE_SHIFT;
>  	unsigned long start, end;
> -	struct kvm_gmem *gmem;
> +	struct gmem_file *f;
>  	struct inode *inode;
>  	struct file *file;
>  	int r = -EINVAL;
> @@ -578,8 +586,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	if (file->f_op != &kvm_gmem_fops)
>  		goto err;
>  
> -	gmem = file->private_data;
> -	if (gmem->kvm != kvm)
> +	f = file->private_data;
> +	if (f->kvm != kvm)
>  		goto err;
>  
>  	inode = file_inode(file);
> @@ -593,8 +601,8 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	start = offset >> PAGE_SHIFT;
>  	end = start + slot->npages;
>  
> -	if (!xa_empty(&gmem->bindings) &&
> -	    xa_find(&gmem->bindings, &start, end - 1, XA_PRESENT)) {
> +	if (!xa_empty(&f->bindings) &&
> +	    xa_find(&f->bindings, &start, end - 1, XA_PRESENT)) {
>  		filemap_invalidate_unlock(inode->i_mapping);
>  		goto err;
>  	}
> @@ -609,7 +617,7 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	if (kvm_gmem_supports_mmap(inode))
>  		slot->flags |= KVM_MEMSLOT_GMEM_ONLY;
>  
> -	xa_store_range(&gmem->bindings, start, end - 1, slot, GFP_KERNEL);
> +	xa_store_range(&f->bindings, start, end - 1, slot, GFP_KERNEL);
>  	filemap_invalidate_unlock(inode->i_mapping);
>  
>  	/*
> @@ -627,7 +635,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  {
>  	unsigned long start = slot->gmem.pgoff;
>  	unsigned long end = start + slot->npages;
> -	struct kvm_gmem *gmem;
> +	struct gmem_file *f;
>  	struct file *file;
>  
>  	/*
> @@ -638,10 +646,10 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  	if (!file)
>  		return;
>  
> -	gmem = file->private_data;
> +	f = file->private_data;
>  
>  	filemap_invalidate_lock(file->f_mapping);
> -	xa_store_range(&gmem->bindings, start, end - 1, NULL, GFP_KERNEL);
> +	xa_store_range(&f->bindings, start, end - 1, NULL, GFP_KERNEL);
>  
>  	/*
>  	 * synchronize_srcu(&kvm->srcu) ensured that kvm_gmem_get_pfn()
> @@ -659,18 +667,18 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  					pgoff_t index, kvm_pfn_t *pfn,
>  					bool *is_prepared, int *max_order)
>  {
> -	struct file *gmem_file = READ_ONCE(slot->gmem.file);
> -	struct kvm_gmem *gmem = file->private_data;
> +	struct file *slot_file = READ_ONCE(slot->gmem.file);
> +	struct gmem_file *f = file->private_data;
			^^^
>  	struct folio *folio;
>  
> -	if (file != gmem_file) {
> -		WARN_ON_ONCE(gmem_file);
> +	if (file != slot_file) {
> +		WARN_ON_ONCE(slot_file);
>  		return ERR_PTR(-EFAULT);
>  	}
>  
> -	gmem = file->private_data;
> -	if (xa_load(&gmem->bindings, index) != slot) {
> -		WARN_ON_ONCE(xa_load(&gmem->bindings, index));
> +	f = file->private_data;

This redundant initialization can be dropped.

I sent a cleanup patch including this change a few weeks ago:

https://lore.kernel.org/kvm/20250902080307.153171-2-shivankg@amd.com

Could you please review it?

Everything else looks good to me!

Reviewed-by: Shivank Garg <shivankg@amd.com>

> +	if (xa_load(&f->bindings, index) != slot) {
> +		WARN_ON_ONCE(xa_load(&f->bindings, index));
>  		return ERR_PTR(-EIO);
>  	}
>  

Thanks,
Shivank


