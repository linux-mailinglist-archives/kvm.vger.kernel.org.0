Return-Path: <kvm+bounces-69174-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELNHE2fYd2mFlwEAu9opvQ
	(envelope-from <kvm+bounces-69174-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:11:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C56088D929
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 22:11:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0E986301DBAE
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 21:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFD02DECC5;
	Mon, 26 Jan 2026 21:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y6RnlX3H"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010000.outbound.protection.outlook.com [52.101.46.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78DCF2DCBFD;
	Mon, 26 Jan 2026 21:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769461814; cv=fail; b=h1j9QwmoS/IRUfn8hIi7aY1OLBxNy07A2X/IV82+/V+g6aoF5rOyXbSIXmnqmGcswZuQhc0RgAxvn2pnfHcE0m3cbGRuFdhdtN1DmJP+mJHzuukozfjSHzMBcyOXIxqnlRFTymaKD+8EiaIL7k5JS3QBVxWVLzsyuH/v8RNDJdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769461814; c=relaxed/simple;
	bh=Ztx17AEMeMo3sqeIHgUJfDXQ9nZRdxmFGElUOKQgwfs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h4v7pxaCiZX5Vg1zyNVfphdbnOdUSG20H05NYqJnglv7oOdt7Vw/3BNU1IokAChQXIWkFTZ1LD6HstnF4MZPgl+Am/wnlsRYuVwzePAhKyHFrCQaLVWWieMxsdzM+fndveIoJcg9NDzfxsWyNrSXRrezg4iHgzrA+iPee772FTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y6RnlX3H; arc=fail smtp.client-ip=52.101.46.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GLQ++1gS4czbKfzxfIIVsEkIddMMi+59pqdeSa+frMZLZ3rMlHjLvfsDwA432okW9PXYB5QrJxpIQTjziTJWKcpgUdTUgyhhXiaFmxdr4xAqMgsEl+pWh9nWZrd3hknH8rkzvrSsmyp7DzUtojRbk0RlXAou5HX6DNYD0lcMni6aqwVmXm+Ip6aM2bFGmozwYEEBIkkQLlFLlePKBiPr1ox19FN+Q/OymWASMvrt7vhDcgJBWCAlk0QA2LrX1SkNExjxaaHX31JrslwwRelA10mW+5FacgZRVSHnK9wuDUR8qjoMhtIiJmblrAHMWYeEyaaJtJGJ1rerrnRjgeIcBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3IS3I46La8n15KUsrROu0vZk+39lKZ7SNqM8mIADbg=;
 b=G1al2CpBeTiBscEYogwk3Sq4iA7u86TclX6f+Iv8bfCqX/j3SFWs2sRIpbPWfUJZs0jIcbWxS0co9olBO6ljcgS6IooTKj+9ulU3zUOhlLivwoxOG6+tud0sYknbiveZfPqJRXtVUHJObWjvpYQ/YWB3qKwWCqssYDUxk7yKRbXZl2TXZJ8kvk9bGwDTev3b1OMT1qzoesKu+AOMOMQv+Beqx7kIo15vwnX5QwHzek3ffGXJz/GZB8vF7pOCF3WT2CylYKuc9zE6WPQHs79WHiYgsvid6FooJogOWXCL9Haz5pIiP9D0Zv1Cb6UDoOlMH+w3A133U6PRqNYvHIBMKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j3IS3I46La8n15KUsrROu0vZk+39lKZ7SNqM8mIADbg=;
 b=y6RnlX3HV1DiyDkiYrfrb63wFvd80kkxBAIO7W5mGimm8AZSlrDn+URVBC5Qegxj8RVAtMFkZ9T0iEnGBVyFpdG1+3egdu/QaOY04whd2ndeLenwMMzEtMelV1G5BSL68gpo0qathzQwQJuT/4zmgm9ywL3o/GYepb9/0bBwOkU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by BL1PR12MB5731.namprd12.prod.outlook.com (2603:10b6:208:386::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Mon, 26 Jan
 2026 21:10:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.9542.015; Mon, 26 Jan 2026
 21:10:08 +0000
Message-ID: <a15238e0-54a5-4acc-9b01-017422069d2d@amd.com>
Date: Mon, 26 Jan 2026 15:10:06 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@thorondor.fr>, ashish.kalra@amd.com,
 corbet@lwn.net, herbert@gondor.apana.org.au, john.allen@amd.com,
 nikunj@amd.com, pbonzini@redhat.com, seanjc@google.com
Cc: kvm@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20260125110629.43096-1-thomas.courrege@thorondor.fr>
 <20260125110629.43096-2-thomas.courrege@thorondor.fr>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260125110629.43096-2-thomas.courrege@thorondor.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR01CA0018.prod.exchangelabs.com (2603:10b6:805:b6::31)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|BL1PR12MB5731:EE_
X-MS-Office365-Filtering-Correlation-Id: 046ec7a0-7e87-42a8-8565-08de5d1f490e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0dBWG4xNnNVUDdzQWdOeDR5bWtaNllMN3MwZHl5SHBuUmpGZFRmR2JuMThF?=
 =?utf-8?B?cy9wV1FaS1pDc3ZyY2JYbkZKVDIzclpVNkg4ZHh4NGxtYUI2NGJ1K2RGZGE3?=
 =?utf-8?B?OTFHTHVVbFRlcUlxeG1RZkFWYmlXOXVkSDI1b0VITENxMGR6T1IwcVdHVHVL?=
 =?utf-8?B?dXNLRTJoMnlVRU0yTi8rQ1E4WmZlODdSd3BHY2RVNGs4aXJqanN2SWQvVHQ2?=
 =?utf-8?B?aWNTLzVMelRvc05BTlN5MGpKZXVWWmJhcjRza0hsU2R4dVRIMHgyVjN1ZThz?=
 =?utf-8?B?Sy9TN1UwY1drc1g4Z3cwaDVDMWt0U2FBeVpNRk1vV2Y1M0VKaVdoOEYvY1BC?=
 =?utf-8?B?RjloeEQ0azdxelRHYThMS2JnUDZ0aU5saDMxT1VBWFJRQ2Q1ZDI5VUYxU1VF?=
 =?utf-8?B?NldKY1VJWXg1Y2F1NkduWXFJZlNOaGxBbklvRTVLaVVIbFRES1BEMkhXS09t?=
 =?utf-8?B?SXh4UHh4WTI1eVZsNS9NK1M5SHBINlI1T3BKNEhSUDFURUFUL0k1dnpkL1pa?=
 =?utf-8?B?L1lIeHB6ellxNDVUbS9aeU9yTHZBVTFUS0NSOGRzWjFHRFdVRncxcXpsQlJQ?=
 =?utf-8?B?KzRXOTAxb1Y1MkpaZU1odzVzR0ZjUFRldlRGWXVpajNKUFJFQzFxMllHOENW?=
 =?utf-8?B?eHFUbXIvTlYvSFhKaXhZdmwvbHVvQ204Y2VMUFNxVFhIdU53WWFCdEYwRnF0?=
 =?utf-8?B?ZXozeVRocTk4TW43alplUjhrdU9CdndwWHNDM2szRDNCNXpVQkZkSVdua2ly?=
 =?utf-8?B?TFNlUUZyejVYQjdETWJqayt0b2poYi9RQm5rZWlTazdMTXlLZXVYaWYwYWwy?=
 =?utf-8?B?azU5TXJVZ0xrYU1zb2c2ZFZSYjBBemE1VlhORWZmd1NyTWtNcEVUTk81K3pN?=
 =?utf-8?B?SGczZ051ek1JWFhnTTQzT1VjSW1VZEo5YVVaTTBiVU9qZnY3clphejRQMktJ?=
 =?utf-8?B?S1kxZ0pRM3B1aDNId3FYYjJVNDhMYTA5RVFISldadWZLUkgybjJuYy8raXdx?=
 =?utf-8?B?V2VNWFJnSlV0Tm04allHd1hYbFJqM0JnblZPQTVjaDYrNXlpcFRkZjNrcnpr?=
 =?utf-8?B?TTQvZWpYcXdFRS9hOWpVMDQvUVlQaXJ3NjNaSjJVZ29pcHdBRFRnSFh1QXA2?=
 =?utf-8?B?QlQvcW4zSTBOdTg1Njk4OXpvZms1bzV3RnZVOWFQSHBVQkQ0Qm44VHBaRGds?=
 =?utf-8?B?Q0JHMm5GVjZRSFlIWnAzRUxkdmNFVFBhZjlrbEdUamEyU0FYMjFXb0h3SWNX?=
 =?utf-8?B?Uk5COWZKZ2JlRUFicUxKdytmNU1UajRLb0padXpzN2VWOUphci81bUtBUDNC?=
 =?utf-8?B?M1pqcjZqTEJ3SkV0dytLM2ZReS9xVGlqbUc2UnluWWJScVdJZUkxeHR4SnhF?=
 =?utf-8?B?MENDNGQyU05mQzBOMGlqR2l5SkFpTzdkMXprdC9xR09PSEZCMi90N3hoSkRM?=
 =?utf-8?B?VTZHWk5DSzJVWnBtbzFFZFlWS1ppT1hRM3Q2NTBTL3ZKNzErbld6UUFEYnE4?=
 =?utf-8?B?QzNZSmk0QXdUV3VFRTdJeTIrZ011RVllanhvRW5EbGZ5Q0JyQ0tRSzQ5dUZm?=
 =?utf-8?B?dm41Y2J0U3Z4VDhhd2VRVmVZVVZQYzlOdHBKYloza0xucWtGcmhtdmcrcVFS?=
 =?utf-8?B?b1VmemRETmozODdlclA4c1Vpdm84dmhZNUlEckFsV2RoTjY2Zmd2cjdjdTMz?=
 =?utf-8?B?QVhqSS9oZmc1MkRaR0hOK1VkRGxNMzMraWdvUnF3bUpjajhPSFJqMCs0L1RY?=
 =?utf-8?B?MjRsZ1Fta3YwMnpmeEx4NmxMeWNZUEx1ZzBLbkN4VDZFcjBJaVlqNzRFdS9B?=
 =?utf-8?B?Mk01elpjSXBLQ2lzTmt2Q0hVZXNiNlhmSWNoMld2M3p2ZWR3ckNyM1hOZnJz?=
 =?utf-8?B?c01hdzVXOGRYeWdEYjYvZ1FKMWhvcGhZa01JdVI5RU9nV2FEWllaK0QzejBZ?=
 =?utf-8?B?ZnJPRThaSFpydkNtU1l0VlR2SGtpRzJXRHQwOWZ5TlpNYWtJaWRnVE9lRnZo?=
 =?utf-8?B?dUYrQlNrK1AxTTgrVm85OVVqTUNOYXpMcHlyc0xNWExZQmhEeWFwR2EwN3Bm?=
 =?utf-8?B?NDdLYWF1Q1RSZE94b2VjNW1wTTkxZmlPY3NSYk5rdXpBVE9XT1RVcHhxeVRV?=
 =?utf-8?Q?BgoA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TlVRRlNCLzRsT2FWcnZGTWp1UVErb1VRMUNLTDY2eE9LVTl5bGlaWnRNY0du?=
 =?utf-8?B?VisyQVExRGxZRGRLUml5NVlzQWRwdUdXQVlkQzIyUm1wbHJXWk95QXpaVXlM?=
 =?utf-8?B?MjNqV1pGdE9iQzc2THVUaE9LQ2lmME4vVlN2cjc3RXlVdmRueDFkQ3NLTUZw?=
 =?utf-8?B?dEpnZHNoVnFmdXJxTUNrUEFvaWhRVUZsY0Mrb0JXSVpoMUM5b1VhV0EyQUhl?=
 =?utf-8?B?TXUwRGVOUVVSWTY1NzdrZ3kvdzNzUDQ1MTFWN2xpRVJSdXc4SWdYR1VWUDIz?=
 =?utf-8?B?dmhWSDNNY05wb0hyQm41YUlqYndqai9uNDc3bGxCRnJtMDNKWiszRERpZlJB?=
 =?utf-8?B?TFU5RStuQ0ZoU0VaTUpwY2tMMSthZ1ZIWnBiVlRVZUlzL0pkaHhoNG93bFl1?=
 =?utf-8?B?Nk42UHlRcEJsa2VKUHpZaXl5dmVxaUhjRzI3bzQ1Z2JVd1lqY1JLeEFETnQ0?=
 =?utf-8?B?eEVSSG02TytKNnFoMjUyWGNtcTE4WFQzaG1zVkVDbG8vdEVYaWl3OE1XdTVs?=
 =?utf-8?B?d1lkRFZ2Y0Rjam45N1J6aXlPRkZCQnNtZDc1OHN2aER2eGR0Y1dNaFRPOVdU?=
 =?utf-8?B?UjdBdXpMck04RDJNTFB6QzMyN2VQa2drNzBweE0rT1c2eEFMT05Tbm5zbUtX?=
 =?utf-8?B?TVFNSlRGNWJNN1I5NVNtSTRjT1p1ZVp4YkZCQTJYUlpSNS93dXA3R3FWVWlL?=
 =?utf-8?B?TlZvMkFuVXFkWGpnWnV2K292S29tNU9ac1RyTE9KclYxeFp4bHJWMFJBTEh0?=
 =?utf-8?B?YnBZc3RBWEc0ZlBrY1JsS05KMVVlb25JKzZCSHpQdTRvaEdBUDduQ1MwNWxZ?=
 =?utf-8?B?SWZkaG53MTBpcWlpeitjMnRDcG80YXlzZVNtL0svVjNPc3c5U0dBd2w2WHNt?=
 =?utf-8?B?RVB5cE5RM2Y4WWJhaDJXYWhPalpRVzJ6YmdncUNqWUZmNlJERUVmbi9XNUlx?=
 =?utf-8?B?eUJOWGpmNWhtLytiNVVIc2Q4b2EyWTRkNnRkSGg0aFMrSFBqY0tJc0pxRlJk?=
 =?utf-8?B?NVdBOTM5UU1MRGlVbldmZG81LzJMVDIxdkFLVkVySElWdDlVWldDZi9hTDFO?=
 =?utf-8?B?QnhJVGFuUjQ0d1BLbzNGdmRiQlBhdjJJNEt1aEg0ZHNUTlF6WEVzdUs2Q29O?=
 =?utf-8?B?TzdFNkltaUFITkVWVkdHWE1aeWp5WG5qTkJhR1o3eFNLeFhKWERYOWwvcEtp?=
 =?utf-8?B?c0ZWWjRlNzRQWHJUbjdwMHdZaEJUT1dETnFqTVcrUnR5VlFKazR4NWJoNGdP?=
 =?utf-8?B?MnlZK1FLVUNHOFJoVVA2a2NjemN6VTV2SWRBUGlwbXl1ZWx0OG5oSDVKMnVV?=
 =?utf-8?B?SmJ5RjAyK3VlOWp2NHVYOFIyaUMyRFVIYVIvd1BiRlo2V3RsdndXU043MDVI?=
 =?utf-8?B?YnNtcTNwNC9WT1lzOW5FK2kwWUFmODFhVGFSVjZ0dWxLcUk3QWJDN3lGVHFZ?=
 =?utf-8?B?YWVYem9zUE5uY091UFY5YjlaVE4zcU5HcmVMeGRZL1djVitGYmdwbTdPNVBx?=
 =?utf-8?B?ZTh4SmxQN0cxMkpVUTZoMXg1OXRjYVJaZ0d0STRWekhFVjNhQ0lBWlgrVlJp?=
 =?utf-8?B?eXpEZFRyOFB3M3FCaEkyOWRTNkp3K2l3YmJHV2prOHVrM0tvQ3lkQnM1WG82?=
 =?utf-8?B?U3A2cC9ZenUzcW9LTlZ2bTdiTmVJanF3UDF5WWYvZGpER0I5Q1A3ckVZbHZZ?=
 =?utf-8?B?ZmllWi9KRmJaaFVNTURuL2VjUzJoVTBLSzdXSkhjQ3prSU0wZHQvaFdiRUdQ?=
 =?utf-8?B?UDBmNW9kVjBRQ2xVMXYvbExRT2EvSklVVFdqdVYwdXltWkdwblJMN01UU0tH?=
 =?utf-8?B?Mk9XbkxHYnUxaTRqcVVnMFJWZmZhaVJocmlpTVlPUjlpdWRFOGVUbmxyVEVp?=
 =?utf-8?B?NTZPNWlaWWs3SEd1R0RqRTBJekdQWURtb0d0SFREVHpIN2x0Q3N1UW5WZ053?=
 =?utf-8?B?ZnlSaGlJdHRRTFFPK3VEN3owU3U4REhZemM1Tk8yQmtHSXVpSTl1UDJJTzhJ?=
 =?utf-8?B?R0ZuRWhPZksyZFN0MkltTkU4VWRpbmtmRDRYakI5cHhlbXA1RHpCeXdIbkdv?=
 =?utf-8?B?emZMcG9SN3lQTFpyUUhFYzkrbUV6dXIxWFoxc1phN1FkeHRCcW1tb2UyTjJO?=
 =?utf-8?B?YXBZRGlSMU5ZL01GT1hLMU5pSE5XeGExUXRacnhYcEozSEo3K1U4SkxhMkov?=
 =?utf-8?B?ckVERWhDYmM5RG1TdzRFemlPaEd5VmhNYU1sVWdOUFgzY3NXeHRkSVQzZDZZ?=
 =?utf-8?B?OFJPa1h2dFUwRGp2anhHVmlhbVFYMVR6L251WlRQZDZCQSsxRk94cGl0cjRm?=
 =?utf-8?Q?DjZ6AGHFxao3G02uoR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 046ec7a0-7e87-42a8-8565-08de5d1f490e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 21:10:08.5629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nnG3U3FBZdZi46/+GdGRVJTHwoQxKRtvaHSiGy8VGUv/ebHXI5T2lrjBOj5/9Asv9CxjOmRtAzVrqrb45gC44w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5731
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69174-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email,amd.com:dkim,amd.com:mid,thorondor.fr:email]
X-Rspamd-Queue-Id: C56088D929
X-Rspamd-Action: no action

On 1/25/26 05:06, Thomas Courrege wrote:
> Add support for retrieving the SEV-SNP attestation report via the
> SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
> ioctl for SNP guests.
> 
> Signed-off-by: Thomas Courrege <thomas.courrege@thorondor.fr>

Code looks good, just some minor doc comments that I should have caught
earlier, sorry. With those changes:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 28 +++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  9 +++
>  arch/x86/kvm/svm/sev.c                        | 63 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 +++++++++
>  5 files changed, 132 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 1ddb6a86ce7f..78b59c91f21c 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -572,6 +572,34 @@ Returns: 0 on success, -negative on error
>  See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
>  details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
>  
> +21. KVM_SEV_SNP_HV_REPORT_REQ
> +-----------------------------
> +
> +The KVM_SEV_SNP_HV_REPORT_REQ command requests the hypervisor-generated

s/requests the/requests a/

> +SNP attestation report. This report is produced by the PSP using the

s/SNP/SNP guest/
s/the PSP/SEV firmware/

> +HV-SIGNED key selected by the caller.

s/HV-SIGNED//

Thanks,
Tom

> +
> +The ``key_sel`` field indicates which key the platform will use to sign the
> +report:
> +  * ``0``: If VLEK is installed, sign with VLEK. Otherwise, sign with VCEK.
> +  * ``1``: Sign with VCEK.
> +  * ``2``: Sign with VLEK.
> +  * Other values are reserved.
> +
> +Parameters (in): struct kvm_sev_snp_hv_report_req
> +
> +Returns:  0 on success, -negative on error
> +
> +::
> +        struct kvm_sev_snp_hv_report_req {
> +                __u64 report_uaddr;
> +                __u64 report_len;
> +                __u8 key_sel;
> +                __u8 pad0[7];
> +                __u64 pad1[4];
> +        };
> +
> +
>  Device attribute API
>  ====================
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 7ceff6583652..464146bed784 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -743,6 +743,7 @@ enum sev_cmd_id {
>  	KVM_SEV_SNP_LAUNCH_START = 100,
>  	KVM_SEV_SNP_LAUNCH_UPDATE,
>  	KVM_SEV_SNP_LAUNCH_FINISH,
> +	KVM_SEV_SNP_HV_REPORT_REQ,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -871,6 +872,14 @@ struct kvm_sev_receive_update_data {
>  	__u32 pad2;
>  };
>  
> +struct kvm_sev_snp_hv_report_req {
> +	__u64 report_uaddr;
> +	__u64 report_len;
> +	__u8 key_sel;
> +	__u8 pad0[7];
> +	__u64 pad1[4];
> +};
> +
>  struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index f59c65abe3cf..63026d254ab1 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2261,6 +2261,66 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return rc;
>  }
>  
> +static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +	struct sev_data_snp_msg_report_rsp *report_rsp;
> +	struct kvm_sev_snp_hv_report_req params;
> +	struct sev_data_snp_hv_report_req data;
> +	size_t rsp_size = sizeof(*report_rsp);
> +	void __user *u_report;
> +	void __user *u_params;
> +	int ret;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	u_params = u64_to_user_ptr(argp->data);
> +	if (copy_from_user(&params, u_params, sizeof(params)))
> +		return -EFAULT;
> +
> +	if (params.report_len < rsp_size)
> +		return -ENOSPC;
> +
> +	u_report = u64_to_user_ptr(params.report_uaddr);
> +	if (!u_report)
> +		return -EINVAL;
> +
> +	report_rsp = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!report_rsp)
> +		return -ENOMEM;
> +
> +	data.len = sizeof(data);
> +	data.key_sel = params.key_sel;
> +	data.gctx_addr = __psp_pa(sev->snp_context);
> +	data.hv_report_paddr = __psp_pa(report_rsp);
> +	data.rsvd = 0;
> +
> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
> +			    &argp->error);
> +	if (ret)
> +		goto e_free_rsp;
> +
> +	if (!report_rsp->status) {
> +		if (params.report_len < (rsp_size + report_rsp->report_size))
> +			ret = -ENOSPC;
> +		else
> +			rsp_size += report_rsp->report_size;
> +
> +		params.report_len = sizeof(*report_rsp) + report_rsp->report_size;
> +	}
> +
> +	if (copy_to_user(u_report, report_rsp, rsp_size))
> +		ret = -EFAULT;
> +
> +	if (copy_to_user(u_params, &params, sizeof(params)))
> +		ret = -EFAULT;
> +
> +e_free_rsp:
> +	snp_free_firmware_page(report_rsp);
> +	return ret;
> +}
> +
>  struct sev_gmem_populate_args {
>  	__u8 type;
>  	int sev_fd;
> @@ -2672,6 +2732,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_FINISH:
>  		r = snp_launch_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_HV_REPORT_REQ:
> +		r = sev_snp_hv_report_request(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 956ea609d0cc..5dd7c3f0d50d 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -259,6 +259,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> +	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
>  	default:				return sev_tio_cmd_buffer_len(cmd);
>  	}
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 69ffa4b4d1fa..c651a400d124 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -124,6 +124,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
>  	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
>  	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
> +	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
>  	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
>  	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
>  	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
> @@ -594,6 +595,36 @@ struct sev_data_attestation_report {
>  	u32 len;				/* In/Out */
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_hv_report_req - SNP_HV_REPORT_REQ command params
> + *
> + * @len: length of the command buffer in bytes
> + * @key_sel: Selects which key to use for generating the signature.
> + * @gctx_addr: System physical address of guest context page
> + * @hv_report_paddr: System physical address where MSG_EXPORT_RSP will be written
> + */
> +struct sev_data_snp_hv_report_req {
> +	u32 len;		/* In */
> +	u32 key_sel	:2,	/* In */
> +	    rsvd	:30;
> +	u64 gctx_addr;		/* In */
> +	u64 hv_report_paddr;	/* In */
> +} __packed;
> +
> +/**
> + * struct sev_data_snp_msg_export_rsp
> + *
> + * @status: Status : 0h: Success. 16h: Invalid parameters.
> + * @report_size: Size in bytes of the attestation report
> + * @report: attestation report
> + */
> +struct sev_data_snp_msg_report_rsp {
> +	u32 status;			/* Out */
> +	u32 report_size;		/* Out */
> +	u8 rsvd[24];
> +	u8 report[];
> +} __packed;
> +
>  /**
>   * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
>   *
> 
> base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00


