Return-Path: <kvm+bounces-48487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C64BACEA2F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:32:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A37A164A5B
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 06:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67CDA1F8733;
	Thu,  5 Jun 2025 06:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TrB9AIE2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2068.outbound.protection.outlook.com [40.107.101.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6C48462;
	Thu,  5 Jun 2025 06:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749105148; cv=fail; b=iTGbMxxP3/Va4XCr87TghrJMdff1fA3lquGCSy60SXUQAN+tQqptZWc4nUbeh+01q9tczJyx6q342P53o8Yxq3ELp6RTqMoOsiSgynvi0MYCtIsX+B4poZywRbEIpembSIqx/R6Th1Q4AluKMnbnZRtmulzYB9KZdv400s192sY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749105148; c=relaxed/simple;
	bh=U/5eWCUUWlyk/MoSVjDBvUXRSyhjDWlJ6sy3sleiHNc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uaS+ve2pyyOyKZzc9fsB62nc1KlR7yzgfBRzK4BwsrVCy4Dughh8B3REP15lx+JTbQJDktAejgvs/Z5cozdHAbLYIMXJwMyiSFq1d19tzSub2vusQGK7ZACephf9r7pwFA1UsAtPXlhzz+/cHrbptJlUpzXZy9m1HcdbXO8O4Vk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TrB9AIE2; arc=fail smtp.client-ip=40.107.101.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JT2uwW7HH70yzO0IS+AjbBhooTTOZaAPA487wTJ/NeMk/EVU5pu2xRX3RPo2qlo2hvuLYECzwim9Lnykal9nU3nQlt9YObRbNVqT1AR5M44eopxi47h++4K3x8ZGmC6gsdKVh5QR3GQg5wa5Jgj7mlDs0WmeH8gRjSZFRBI3tv8LyGOmAFuPR7Y07CjHTwxWZm+0XnDpy5sO+AdtVEvKL9xJc0XJO81xBMWf++elSkxKYcwihyuluh7nejSaEHSYLUG8jqRLpvTf3dbnY7IkXsMybOt6bmokn1uUUy+rIvzb4LH3Iaw3tpK2w5O1p0NUB3JEj4KndxVV9jyY0g5ofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpcfuwA7nyM++vG7YTDoDd8oD11wklUM0C1EPtH3G+0=;
 b=NvoHOkyvwsBDdx6uLN3LrMJBlwcg7+PH//a1pwZdT+fuUf9xSxh/zbQdJdBPEYbiJwPGeMo6ZTPFbJ2KoHG05+/NfCG4P4Ay2bdl/ZyH3rfAbirJ9qKxSbMEH6cQIzrAqZGtbWck2L4Gf06sQeKNxVdUr+np9SVh46YQk5seyOvXH9L1IrwofeHyBZjHPsVM1HlU+075co4dH55D387Jc1kn/ZUJ+0V8hu18jvBtHqEuo5j8KyN67mBSxo6ZIyww/27o0pEPrEqMS+NcIkvrHCpFvRIEA0DZmLg2YD2brfiI2klHHB5m4RBxycOao8CL8RucoG+F5VzjBNOXIMWWoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpcfuwA7nyM++vG7YTDoDd8oD11wklUM0C1EPtH3G+0=;
 b=TrB9AIE2TJQYaocjyNVWIAiYUP2bBTBmdtdKXU8jkcbDSYhCAPAtIWXGBaUvmxzSM69uhkO9wM8PYph0xNHsT+xPj0VbRGN3RlK0MHm3V6voz7UWtteXqYzNWUFAFkKOFDLP5LaHuK+yUOsi0Z6YDHpnyGeaAcYPszLJ+t6prFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by IA0PR12MB7508.namprd12.prod.outlook.com (2603:10b6:208:440::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 06:32:23 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.037; Thu, 5 Jun 2025
 06:32:22 +0000
Message-ID: <cc8c6e32-f383-4ae9-8c49-5e61bfb0d86c@amd.com>
Date: Thu, 5 Jun 2025 16:32:13 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 5/5] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 akpm@linux-foundation.org, paulmck@kernel.org, rostedt@goodmis.org
Cc: x86@kernel.org, thuth@redhat.com, ardb@kernel.org,
 gregkh@linuxfoundation.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SYCPR01CA0034.ausprd01.prod.outlook.com
 (2603:10c6:10:e::22) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|IA0PR12MB7508:EE_
X-MS-Office365-Filtering-Correlation-Id: fe6c51ad-cc2d-477a-8230-08dda3faba9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVR4ZlR5YXFsSDNGcXlaLzl3UkNuMTRoellnYkxtSDNqNkhLbk4rTngra1kv?=
 =?utf-8?B?UUhtOXZtVVFicG1LWnV4bUdXUmlaSnBIQzdodTMvek5hckM3eDVtRC8zNjlG?=
 =?utf-8?B?Nk1nOS9vWU9nY0VPWXZVQzVHeDI5cFhNdDA4T05ZRk1tVVdWQXhJRWd6UzRt?=
 =?utf-8?B?M2o5TWU4eVM4eTJlR1I5WnFDUTNxaldmR0V6ZTJ1ck8xTlBuNkQvdUhIN0FJ?=
 =?utf-8?B?Wk5YQjRZb2VUK1VNeThXUUNqYzJKT1lPbTAvUFptbDRxTVNKTHpwV0d0c2I5?=
 =?utf-8?B?MGNmQ1F5RzgxV2RaU25jandJRkowdEFPVG5tM21wV0prcHVaRFJLYStIaFRu?=
 =?utf-8?B?SEt2bVhCNStyd2IyaFMzbmYvc2VVZS94YXZ1OWo0Z2FrVUNCamZsdFpFWmg0?=
 =?utf-8?B?UDlqSHlXWkdobUZWNThsZzdxcDhsc0d3SnUwYjJLQzlYcW5naFNaRlliYmIv?=
 =?utf-8?B?a29NZlNXRUpYSnEyK21MeXFBNG9mVExXVDNEd3VqK3V0Z21qOEoybGtydVNu?=
 =?utf-8?B?ZEFEd2p3RDVCb2xpUC9WUTNTd3VCalpyd29pRzdDUThjaE1OMWs5Vi9zNDJn?=
 =?utf-8?B?WEp2Zy9VaURKZTY4SmxYSEJaOS9WQ3NBZVlXa0lWOEpjTmczQS9jYXdSQ1BR?=
 =?utf-8?B?VUhxSENaTmJhNDNkcDRqZC9maFh6Y2Z1RXdudXY2OGZxWUUyUHZsdG96VUFL?=
 =?utf-8?B?NHVmNW51ZmU4cmF0TXJYSk1XaWxYa2piTnlmbnBHMHc5eGVuaGpmRk1KOURl?=
 =?utf-8?B?YW02YUgyR09NK2Z5NXlPdlUydXhhbDIrYThRUGVxbUM2d0pSdTZkWlZqWlhE?=
 =?utf-8?B?bnB2eGdld0FwV0w1d2RsY3RXMW5XR1ltY1MwTVJiaGg4Vm1IcmJVcFB1cVE4?=
 =?utf-8?B?dUhQOXg1aWFYTmRlQzhMOTNIa3MydUtheVhBS1V3K3ZUOEl4UVFBZlU4aURL?=
 =?utf-8?B?UGJFWlZEeGhRQUVtd3lNaUkzbkNTNzArODRpdVlSN2JMdHdzWEF2aHNQclVY?=
 =?utf-8?B?dkRJbkwyZDZOcERNaTNjdXdyaklsZU1SbFE1Yng4cng2OUdzbHVXWFJzbVhM?=
 =?utf-8?B?UzQya1FmR1RXS3Z2MUFRUlg3U3FpQ0pBUWF6RW5jWnliMnp0RVJsU2xLdWdi?=
 =?utf-8?B?S1RMem9zdXBtZ0xFeTRvZWZqR2NWa0s1MWd1S29xUlRxZXMreUJhamdhdjZ5?=
 =?utf-8?B?aWdVcnpzSERMbFVlVThNbkwwQXA3VFc3STZXY0ZUcHpVa2JuZ0IrSjNGSDJm?=
 =?utf-8?B?eTQwaTFiRUI0Y3Z0aEcrdk9CV245WWMrZWM0MXhlbzIwQ3IyQ09NaHA3TnAv?=
 =?utf-8?B?blZrVnZ5dUU0NkhsZ1ZINVBxMTU4V2gyZUJLbDdkQVIwWVRTQ3NUOFF5SnE2?=
 =?utf-8?B?SGVEV1llUXdBZmRQQmJsaUFPWWRRYjdURWtwV2NKRFZzS3FSaFlUVzZHM29j?=
 =?utf-8?B?VUNhRjgxdDl2ZVFlRWtlTEdZUnJpSWJLUkpvdUp4TUpZa0EySCtwSGRQdkVE?=
 =?utf-8?B?ZjQ2aDg4RHdYZTkwUHlBRllLZjJEMXNmeTVsM2VIVkNBN2l5dHhQc0l0TlBp?=
 =?utf-8?B?QS8yUTAraGtya0xrQ0ErUVF1VmNVMm9idFNjVGNkcVdzVHkrSW1zYnVzbzZV?=
 =?utf-8?B?dHRDMEo2OWM4c2ZMQWhrdlNnK3RNOW52bTBhOHdVeHJNei80SERtWnF1UGZ6?=
 =?utf-8?B?NUgyYU8yQm9VWWZLSHNjeGNpQWZoaWMxaHJPRXVra3FMem82d204eDNJRTNX?=
 =?utf-8?B?dWtTa3VqeEVUT3dpbE1MSmNnTzdiOVdneHBEK3BWTzNDYjllTVJGUldDZm9a?=
 =?utf-8?B?aWh4d3c2SnpSNGZGdDB4S1FPMy9KV2YvaUxhazlubkg3U1VoT3dOdDlWMml5?=
 =?utf-8?B?NkNZdlBibXcrMmVORVVxUUYzdG9UZ244aWNjV0k4UFpBZEFvcStGNEZBOWxi?=
 =?utf-8?B?TGVTa2FOZVF4VlgzTkxjUzhVU0RwUnVzQWhyMEZjMmhDL0tPYzlueC94SEsz?=
 =?utf-8?B?c1cxSDNjMzZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aFZmQTBzZjJQYXdnaW9vdEJxL1hNV3BibW9SK1h3ZGVIbThHQmNPVVBjQldy?=
 =?utf-8?B?RGVuYXFJSENiTEw1c0ttNTU5YnJpbTh0djR4anIyNy9hVFVNdnZ4YkhUZFl0?=
 =?utf-8?B?RGhza0JTZ01CbzZIamhzSnBYUjBmTlFqTklUSWNhd05Ebm5ZYXZRZnRORlBy?=
 =?utf-8?B?WjdEaGRhNlc4bEs0VEhyYlFqbDdXV0sxLyt6TmF1MkxMcVFhRjkxN2hqbXR3?=
 =?utf-8?B?QWx0MHpJL01OK0xzdk1RcG1sb0tQOHZWVWNUYjZqWUx3cnMwdlFmY3pPb1Z6?=
 =?utf-8?B?eUJtRXFwL2syQkg2bXdCaXBZaTIvWkFSRlk5b0FZQW13WG5CV0t1NndVbmVB?=
 =?utf-8?B?VUV2RFloOEpRTDNRWlRoRzZBYzlKTEt2em13bEo3SStERlpsbnhnTlRudUV0?=
 =?utf-8?B?aXNnSnlVYVhMQ0oyeC8xMnZNTzcyNlF5Q2RldlhMS1BEZ0NURzN5Wmx3d1lS?=
 =?utf-8?B?QVNza3A0ejRFV2VmVTVVcnlGdmNhODcvc3Y3WmMwM0ZKVEJsLzRNTXZoUG5o?=
 =?utf-8?B?TFlBaVJrOG8ydm8rYkliYzlCOWd2NDd5WVJEV1N3NThPb2xnWnRleHNaL2xG?=
 =?utf-8?B?YmhLMlllVC9zNit0clhYRmFqMnp6clN6UWFJanNOdDJsek5GejRwUGkrL0Fl?=
 =?utf-8?B?VUE4cm0zWEpWUEQzSk85MVordk1GNnczODRzVFN0ekNZRzhaZlFFbmFsRXJq?=
 =?utf-8?B?RGs2YVFta3JYRTV3YTNlUzdYVGt6cUs1b3p1d2tPWlkxQXNzMlRmUmF5RjQx?=
 =?utf-8?B?OG82dFJZREdINldPQ0xYRmdRMVh0dVN5ZTQ0MEVTRVZ3L2RzQjFPMVA4eTBD?=
 =?utf-8?B?dFFuenh3RC95Y3NDQ0o1NU5SaHgyUmhhc2NCcmpUTHg0YmlZTFJYaGhSVkZE?=
 =?utf-8?B?ZEZoaHZRcS9UVVhLdEZFdmYzbEczM1M0NHBIcTNZL3FZcnNjY1RUMTl5bk5U?=
 =?utf-8?B?OFpvMWdrQklGbTFXLzdFb0N3UUk2eWZJVGVjOEx1UmRUZVZkUWlNMGIva29m?=
 =?utf-8?B?d2FKby8wVm11aDVhRTBFelRyeUx0b1JpYXFaM20vM3drQXhIK2N5SS9taDVw?=
 =?utf-8?B?d21JUjlua2VTNzVwRmQwOUtLMmdVNnFoNEFMMHBKTWNuZ2doZ3Jubnk1WHlC?=
 =?utf-8?B?aXBLa2ZYRDR1YTdoRi9GWFN0Q0xsQ2xzU0I3NW9wNHFPZHJXN2dVMEMzMzhu?=
 =?utf-8?B?MTVFUVRxOUdBK1ZXOGJwc0RSYVJpUE9ZeEN5RW1NVklKcUR5NFNib3FLTmxt?=
 =?utf-8?B?cGtzYm8rV1hWajZ6ZGFBNHVwK0JsaWNtM0VJeDV5TkdweC9RVUpBMmNIQTF4?=
 =?utf-8?B?NjFoS3BCZG9qSVY1blJkVmNoSnhQVTkvMTY3MlZxMWdhSnZ6cVpwVXBRRDVG?=
 =?utf-8?B?VVd4QS9QaVd1NlV3NGRucEhucEMxVVJmNEZuZ0lBT3dVQnltT0h4N1B4RXBo?=
 =?utf-8?B?VGdPVHl3UitGNnBwemNGVUxFVlNDTlFwYzVLNmoxaDIyRHkvNGEvWlRLdnFQ?=
 =?utf-8?B?aFErckt4NFJLdGNOYnloL281S3d2dVhSYnlweW9wa3hHdm9rekJtcWMwSTZP?=
 =?utf-8?B?SUcwQ0NQc2VzQW5GSTYyL1Yvc3RkdlRBOEduWSttb3BOM1dONEdUTnVkMzRv?=
 =?utf-8?B?bDdUUVd6OFZEbnA0aHg1Z0xKL0t0Q3BLdzhBeWlKSHF3TjJxOW94cm1heEJO?=
 =?utf-8?B?a1Z1MDF2VUxwL3c2NEtGMjRzQ2NvYUpOVkhod2lyNFN1THVLb3hoUzJDcVdU?=
 =?utf-8?B?d05Ddm8xK21SMlZ0Q2NXWStTeitGSEtBNjZRRU9PQzJmMDM3MDNONElsc0NQ?=
 =?utf-8?B?VFVsdzZTTUZhazcyNzVVSmxJQStBQkZPaFBFR1R4QjRoRTRaUDM5dDJMMnUr?=
 =?utf-8?B?VGVXTUtta2xrT0VyWDBNRE9FQzJTcU9NWHYzSmZKWHBJZFRDdVJIcEd5NG9r?=
 =?utf-8?B?QUM2NHJGL0ZjQVZRMytVMUQ0YWEvVjRsVG5LejdSQTFNa3VsSG1BZVB4cUJE?=
 =?utf-8?B?ck5ZN2pQWlBVSEFqSkwwY3ZOOWtRVUwwa05BQmxUcTV3SVZ1c3NmSXA0U3Ra?=
 =?utf-8?B?bUJERWFMTlhQTm00S3hLb3ovVUxlR3NnbkxPWVBQZUNKUEdRT0VMTnRoRUZU?=
 =?utf-8?Q?OgsU8WSR/8GVsdTEpv5FWFlUy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe6c51ad-cc2d-477a-8230-08dda3faba9a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 06:32:22.7741
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +JfvslevQP+S9gpnkA69isYtY7ZMhdPqKaJcs496HfgYbu311ml3D+NnCTcqWDiuVuR8jfc9qTeYwDZs3cf88A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7508

On 20/5/25 10:02, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> The SEV ASID space is basically split into legacy SEV and SEV-ES+.
> CipherTextHiding further partitions the SEV-ES+ ASID space into SEV-ES
> and SEV-SNP.
> 
> Add new module parameter to the KVM module to enable CipherTextHiding
> support and a user configurable system-wide maximum SNP ASID value. If
> the module parameter value is -1 then the ASID space is equally
> divided between SEV-SNP and SEV-ES guests.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   .../admin-guide/kernel-parameters.txt         | 10 ++++++
>   arch/x86/kvm/svm/sev.c                        | 31 +++++++++++++++++++
>   2 files changed, 41 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 1e5e76bba9da..2cddb2b5c59d 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2891,6 +2891,16 @@
>   			(enabled). Disable by KVM if hardware lacks support
>   			for NPT.
>   
> +	kvm-amd.ciphertext_hiding_nr_asids=
> +			[KVM,AMD] Enables SEV-SNP CipherTextHiding feature and
> +			controls show many ASIDs are available for SEV-SNP guests.
> +			The ASID space is basically split into legacy SEV and
> +			SEV-ES+. CipherTextHiding feature further splits the
> +			SEV-ES+ ASID space into SEV-ES and SEV-SNP.
> +			If the value is -1, then it is used as an auto flag
> +			and splits the ASID space equally between SEV-ES and
> +			SEV-SNP ASIDs.


Why in halves? 0 or max would make sense and I'd think the user wants all SEV-ES+ VMs be hidden by default so I'd name the parameter as no_hiding_nr_asids and make the default value of zero mean "every SEV-ES+ is hidden".

Or there is a downside of hiding all VMs?


> +
>   	kvm-arm.mode=
>   			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
>   			operation.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 383db1da8699..68dcb13d98f2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,6 +59,10 @@ static bool sev_es_debug_swap_enabled = true;
>   module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>   static u64 sev_supported_vmsa_features;
>   
> +static int ciphertext_hiding_nr_asids;
> +module_param(ciphertext_hiding_nr_asids, int, 0444);
> +MODULE_PARM_DESC(max_snp_asid, "  Number of ASIDs available for SEV-SNP guests when CipherTextHiding is enabled");
> +
>   #define AP_RESET_HOLD_NONE		0
>   #define AP_RESET_HOLD_NAE_EVENT		1
>   #define AP_RESET_HOLD_MSR_PROTO		2
> @@ -200,6 +204,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>   	/*
>   	 * The min ASID can end up larger than the max if basic SEV support is
>   	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> +	 * Similarly for SEV-ES guests the min ASID can end up larger than the
> +	 * max when CipherTextHiding is enabled, effectively disabling SEV-ES
> +	 * support.
>   	 */
>   
>   	if (min_asid > max_asid)
> @@ -2955,6 +2962,7 @@ void __init sev_hardware_setup(void)
>   {
>   	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>   	struct sev_platform_init_args init_args = {0};
> +	bool snp_cipher_text_hiding = false;
>   	bool sev_snp_supported = false;
>   	bool sev_es_supported = false;
>   	bool sev_supported = false;
> @@ -3052,6 +3060,27 @@ void __init sev_hardware_setup(void)
>   	if (min_sev_asid == 1)
>   		goto out;
>   
> +	/*
> +	 * The ASID space is basically split into legacy SEV and SEV-ES+.
> +	 * CipherTextHiding feature further partitions the SEV-ES+ ASID space
> +	 * into ASIDs for SEV-ES and SEV-SNP guests.
> +	 */
> +	if (ciphertext_hiding_nr_asids && sev_is_snp_ciphertext_hiding_supported()) {
> +		/* Do sanity checks on user-defined ciphertext_hiding_nr_asids */
> +		if (ciphertext_hiding_nr_asids != -1 &&
> +		    ciphertext_hiding_nr_asids >= min_sev_asid) {
> +			pr_info("ciphertext_hiding_nr_asids module parameter invalid, limiting SEV-SNP ASIDs to %d\n",
> +				 min_sev_asid);
> +			ciphertext_hiding_nr_asids = min_sev_asid - 1;
> +		}
> +
> +		min_sev_es_asid = ciphertext_hiding_nr_asids == -1 ? (min_sev_asid - 1) / 2 :
> +				  ciphertext_hiding_nr_asids + 1;
> +		max_snp_asid = min_sev_es_asid - 1;
> +		snp_cipher_text_hiding = true;
> +		pr_info("SEV-SNP CipherTextHiding feature support enabled\n");


Can do "init_args.snp_max_snp_asid = max_snp_asid;" here (as max_snp_asid seems to not change between here and next hunk) and drop snp_cipher_text_hiding. Thanks,

> +	}
> +
>   	sev_es_asid_count = min_sev_asid - 1;
>   	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>   	sev_es_supported = true;
> @@ -3092,6 +3121,8 @@ void __init sev_hardware_setup(void)
>   	 * Do both SNP and SEV initialization at KVM module load.
>   	 */
>   	init_args.probe = true;
> +	if (snp_cipher_text_hiding)
> +		init_args.snp_max_snp_asid = max_snp_asid;
>   	sev_platform_init(&init_args);
>   }
>   

-- 
Alexey


