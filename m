Return-Path: <kvm+bounces-24820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC0595B804
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 16:09:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E55E1F2490B
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 14:09:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D8A1CB325;
	Thu, 22 Aug 2024 14:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4+tbAJeQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FAABA45;
	Thu, 22 Aug 2024 14:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724335787; cv=fail; b=BXpJdnGt4BVigE0eDU/y/YnLFLktH0Hc7qg1zKwnTQy+AJg4yCS0SY3r0XLr2TIuEj0VUH88Dik07+Tc23sIHOwiYpnhfwvObpGj1EVeGHD2CA9XrddTsEEkYHr5gq0FZKdZfvYOsh9ZjkAKKVXBmS2JgfdzfwpW+lqYn04Txm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724335787; c=relaxed/simple;
	bh=gN1/pKEk8xlLjFqs+p5dJwqHLsstDsKbXQWlN6McdxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=t7xUEA2oc/RWAvTKrkx5s8WNSKZVgF2iQcBEzvSLM+ucVQOdbprxACblSyJOHTbQfZDOWwDukZK/IyD/EAbgY8HBIxYE+sMwop3pUfpPOqEg0LYZWJcx8qkjawKMuddWpVeUteUP215zhiXQl2QQYKh2FZpidNZ2EdSt4VVsHgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4+tbAJeQ; arc=fail smtp.client-ip=40.107.244.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CvjXz32c1nlq6BUJGD4TNAa96RiC77AHf+Lh6gu6Z4kY9F23uEOn+/3UpnX9a4wCRF7BtcDyqI/kbX1z3JL8EfFD+VH7bkZo2gJ8bJEl/pluap3HWOm6e1G5Ajp/nfKT5GIYBvXuW+cE+C+pPoETuWwu53ElP8QSoijQFKkk9C6HcpzXdcpg4I9kR+zmBUJ/mbRUXDFwwZ1z2k5/syIsh0iXtLzOlx69/HKAZzm/OXJhJSQUTTTavofYksl95PyXu6Ke9/bbtkh55HsHjRKoEWFwqjckHZE++SLxgZWHm3fZHXUZeid21LX4sLcL+WNw5bq7chm5Vx/5NffMnauX5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gN1/pKEk8xlLjFqs+p5dJwqHLsstDsKbXQWlN6McdxE=;
 b=BuD6L07DLKAFiMAODOpHjK/VukQw4MVZeTfE4gLZYbOMAkORuGE4rCC+LUHf56xnb8bZGQHXyZjhRwUUZkv1LlfCCbsEdKv+WV53pNLnSeM8POc7uNa4C2FbCUCWQ9u2Z6BIjCFqLBuZKw+l+giIb3odiOpe8ElxnV0nd6i2MQ5olwjXH/NJZdznpY3371KyLyxCvZm0nyh6fCb1ZMMgMeARwnKYr+2Su3HbW3TI6T+090hNISR+s0vsChSQ/tDvrHFZWHAi4s2BpG6Q03EOnaSbKemaMmt/pPoskmy16Bh5RPK+Anrh49+jV/+9NxF+KF/9EtZnDFExNeoP+0F9QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gN1/pKEk8xlLjFqs+p5dJwqHLsstDsKbXQWlN6McdxE=;
 b=4+tbAJeQa/kq9PtrFtYMdJaZVOtXzV+y/uzWGMvF6wdJjTHCm14YJOYPHRhN35oPG5Jr7L/P4JdxOOb6qGSXtdcksm+NZsiL0H1RhMS6M0wOVeaydERvHNq0J98u+SeBLiBgfqnIype24Oq1ZDv/jhNDFpPmJB+TxdO+d1Cuo8g=
Received: from MN2PR12MB4438.namprd12.prod.outlook.com (2603:10b6:208:267::23)
 by IA0PR12MB8714.namprd12.prod.outlook.com (2603:10b6:208:488::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.29; Thu, 22 Aug
 2024 14:09:42 +0000
Received: from MN2PR12MB4438.namprd12.prod.outlook.com
 ([fe80::bc6:9dc9:92cc:a162]) by MN2PR12MB4438.namprd12.prod.outlook.com
 ([fe80::bc6:9dc9:92cc:a162%4]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 14:09:39 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "Kaplan, David"
	<David.Kaplan@amd.com>, "Phillips, Kim" <kim.phillips@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
Thread-Topic: [PATCH v4] KVM: SVM: let alternatives handle the cases when RSB
 filling is required
Thread-Index: AQHa6MZfumm/O8TCg0+i14Q0sHUhR7IzaEwA
Date: Thu, 22 Aug 2024 14:09:39 +0000
Message-ID: <2d3f3b45af726bd65f081819fbfe2ae2a9eb6b76.camel@amd.com>
References: <20240807123531.69677-1-amit@kernel.org>
In-Reply-To: <20240807123531.69677-1-amit@kernel.org>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR12MB4438:EE_|IA0PR12MB8714:EE_
x-ms-office365-filtering-correlation-id: 05052e52-d2d7-4acf-dc80-08dcc2b40f99
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RlJWUFFodWt2cjVPb3o3b0ExNWF6Zm9KcE80RnZOdmNXRHJrcXJUZncxZDJ5?=
 =?utf-8?B?T0NHZVpSaTZrd0FPb1lMY0lZNlhvTnZhYkFYaU5qMGM4T1VGU1ovaHVFOTRB?=
 =?utf-8?B?cDJON0RtOGVaMmprVlZ6bWhyaU5xM05oK3FTWk5XMHZMcThmZDZLTlZQTGZ0?=
 =?utf-8?B?QVJDN1EyN0lwUUhWNlRYVEx6RDJiQTRvZE51UDdmQUprVjRaVnVocktHN015?=
 =?utf-8?B?WkdtRkRnTEdROUJRNzZUTGRDOHNSZ3haZ1lkb2laRXBjVE9zUnJLU0Vsb2RQ?=
 =?utf-8?B?SnowTDRBUkFjN1dPWDZocXU5a1N4NUMvSE0vdmEyQysvcVpjeVJwbC9neC9M?=
 =?utf-8?B?dnByNng1Y3FRL2dkMUpveGVIZDZoL2hhamRnblF4eUR0MkVVQnBkdVpFSFM1?=
 =?utf-8?B?aUFxcGlJeHJFZE0yd01Ta2RwNlBGdlVNaWd6NDRRQ3ZSa21ScnRDVk9GRUE5?=
 =?utf-8?B?NENjOVUvMTh6K3lDU3pwTWFjMzRmcGFyc0ovb2pWMlF3SGtOVkZWeGMySnB1?=
 =?utf-8?B?amgyU2I1UDFzaG5KMk9VTjY0WXRZOXVjSlhUZFUzbDZQS3NRRHdSZG40NmY5?=
 =?utf-8?B?UmJuOEFPWERyWjV1Um5BUUU2SEo5dFBQMmx4M21sZDBDcSs1d281eUMyU3gw?=
 =?utf-8?B?VG8zOURmZXMzUGcrK2JwUzNQZGFsODVJNlhPQ1gwS09tUy82OTJYZHVBNGda?=
 =?utf-8?B?eitFWDkxWExzMDBkQVEyc2lvNVhlZDdKRGxJUTFTL3lRWXlCekdxQjBIaFdx?=
 =?utf-8?B?Y1lXaCsyR0ZzL1I4TWpCM1F3N1pTYzErRzdycU1YM3Azd25mUlQvYk5jaVRT?=
 =?utf-8?B?aVJTMjVwNXJjbW03eDM5VFAyeUlhR2ZnTUVYbGx4ZjJLTzkyWTBJVWRaS0po?=
 =?utf-8?B?Wk9lQ25kbHhCNHQ3QS9VM1Y5TEl2VlJYdk1KcXZKSjkzeWNabzI1MEgrU3VQ?=
 =?utf-8?B?ODVYVHprRjhBQzB3bGQzMk5DZmNsL0p1Q281ZmR1UHArempuOFBVYnpET0Fp?=
 =?utf-8?B?YVpHQzMyK2NwTm5ZSDNVaHZSdjVWbnE4VzNFakRWNnlkUlUrQnd6V2dnMnBk?=
 =?utf-8?B?Vi9GcS9WL2Y5K21CR0dHRlVwNVNVQ0t5anhtRnJGWU5FRzFkVldnVDRkTDJO?=
 =?utf-8?B?aGN4WXhyTjFJVDdpVDRvNXJwRXA2N0phdGh1eTdlZG1lVnk5YTIxM3ZYTk5s?=
 =?utf-8?B?bEJwZWo5akJIWU5qT1BwOWZGN1h3RlpYdkVBRUtxMVh3NVdsTU04Tk1rRzAy?=
 =?utf-8?B?SFpBdGY5cEE5RUxHemNmaWpjR1hjNUk2TVVZQlptaWcxdVQ0eis5eGVJSnhI?=
 =?utf-8?B?MEVBd3BaNTVvdmVFREtUK2FudWsxSUFlYjdvaGxuTlp4bElVQkhUQlpaUTFP?=
 =?utf-8?B?c2tzWEltZG9Cc09PRGxtTDh6OEkybDlUTGdPeXhrTDVjN1h2emhiSXJEejlV?=
 =?utf-8?B?NERteXhwMW91S0w1ZFZPWDBTa3NGSGoxWVZOSkRlZnMwOCt2YjNHbkFSNWcz?=
 =?utf-8?B?MUc2cWNlN3dzR1E4RmRMcVdVR0Q2NUdtNVV0QXVON0RwL2pabmlzeHZaKzFl?=
 =?utf-8?B?aGViT3RMak1NKzhhalAvNTZMOEFlSWJ4bGVBdzRncTYrV3BxNS9PaHpXSGoz?=
 =?utf-8?B?bDBHODhvdVMxZGplUEdqRi93UGJHUkgwajdkUk5jOVA5MDI3YkIrcTBLOEx0?=
 =?utf-8?B?UTBsN3JFWThRQVdwTnQwQ3lRWHIvdkZiSncrUzNzNlJzaHF5RGZkSnVCd0U4?=
 =?utf-8?B?RnRSaHdzNTBTRG5XNURNOVgxZ2Qwa3dhaVhBVE9xVDJodkhGT0tMT3NVaG1L?=
 =?utf-8?B?anAzU0ZCTXBTMDBXeHF5M3VER1ZFRVFkYUcvaFBxRThFOTJlMlJUYXZHeXda?=
 =?utf-8?B?WUZueDBFV1N0MENXNnpsTUNmWE9SaWNCcThzTTVGWnFIT3c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4438.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TE9LRzUyYThtYmJZRytGRTFMUjdhTCtqcEhEbWZjV1BNRnRVWVVJc1FjY2d4?=
 =?utf-8?B?d29LcmpEQ29BSy9iOS9YUUUyYjNVaDJHQXNsQVFVUlBjNFFIS1Q4UDAzMzdF?=
 =?utf-8?B?aTZCb2UvYjhrN1F3WU5ScjhXa3pzT2Z1UkhLT1FmZDRGb1h4OWR5dUhEZFU4?=
 =?utf-8?B?WWh0SnoyOGdjZ2U4cC9rczhIM1lxeXRFbVNxMUpMcXBkSWZLNHJXRWFWakJQ?=
 =?utf-8?B?OHpDOHhaM0hnNTBXUDM3cTdxN1FUclBOUGFwdTliQS9XOENFeG5ab1pQSUxr?=
 =?utf-8?B?eFp6N0dqMzVmTmVCMzJJNGV2YjdxVmtSOFBoT3lndDVGTTRBdUMvSU5kOUxN?=
 =?utf-8?B?ZGthd1dsQWIydDVoRUZxWUdLczdKWnVTOXBVV2tLN3B1cTVIWStzSkNSNUhl?=
 =?utf-8?B?Vk9jWmZmd2dRTXhCYUF2Y1dXQ3NGTGFYVC9kYWJkUVlMK2NZTGh2WDhIaDZ6?=
 =?utf-8?B?d3k1bkZzTjI0dGVFeUUwN3FjbWQxVndVUmFHcTVtVnVYRDRpZjlybnBPcS9x?=
 =?utf-8?B?V0tFTGJRRmRXb2sxYzE5eXBZSkZBVVcxSnRnU1huYmU0NHJma3Z5MHU3SEI2?=
 =?utf-8?B?c3k3TlJ2TlpWRU5JWEsyaHMwMVcxc2xXck5jeHN5d0Y1bTB3N0VGWkxNVWJU?=
 =?utf-8?B?OXppbjRBV01MUFAxRHF5c3V0TDVFVnpmZVpmMnYweFJIRElzNStPbUpWSXFQ?=
 =?utf-8?B?V0RUa1ZSQlhNS1JCVTFVemV6ejZ0Z2Q5bUVxVk0rZDF5VTkzZCtkaXRHLzJN?=
 =?utf-8?B?SlJHSHpEd1k3cUpEMDZzcThiNEtQU0JyS3MreW1ZWDJZUXZyc081ZjNvR2Yr?=
 =?utf-8?B?YTJQUnBIWUtXc2F5dUJQTVlGWFdOMGxqTTJKdTRTSkcyWnhnVVpSNXJ4Uy84?=
 =?utf-8?B?RFVoOXRMZ3d0QVBLRGNIOXlmSlZIUnZ3S3N3Z3Q0QUdyR21jOEY1QkdqNEU4?=
 =?utf-8?B?Uk53eExrczNzanl2L3g4U2RSWmNhcCtkRnI4bGpMbDR0dmFudEZmKzk1MTh0?=
 =?utf-8?B?SEs0SDlOTXRGUXpKUW50YnRDTVlpSFhWYy9RSzdJRHNZdFNGRnB1U2dmdnZ4?=
 =?utf-8?B?OFVqWE5CUmZtZFBocjFZRDdWbnB3cEpCWVBTVDk4Z3grWTFZVExkU25TT0k1?=
 =?utf-8?B?UFVhaE1KbW4zdGQxT2k0bUZXRWRSNkJmWkR6WkZ1Nkh0WGw1OHhnb01HUTJH?=
 =?utf-8?B?MEhQa1dQWkZxVXFMbkVXZXJ1WG5pY09zdGJtZzBrU0UvVFVOY2FRblFMSXdW?=
 =?utf-8?B?cmMvNDVmSG9YNlFyN3lzWXRoRC82VExWajN2S0lweklTVW95NzhBanNyZzMx?=
 =?utf-8?B?Z21pelJiTWtxeE91YlVSZGtPZHhCZ1VsMDd5YXB6VGxJU2pqTmZQenVORGcy?=
 =?utf-8?B?dUpnY0xna3VyNlRVUXVrb21UWjlJN3BQTUQyWHozUVJUempSbENONGdKeEZ2?=
 =?utf-8?B?SFVpeFVLdmpMNzF2SDZOcU55TXVCYUJBaU9TdmIxb0pUVXhYaWJHWkZ0L01G?=
 =?utf-8?B?eWYvdmRoc2N4aFpTRS9hUXNqZ2tXdG9LOFlTb01QQ1hNRXlMYVprc2poZTd3?=
 =?utf-8?B?aFNKL1RFNy93OFBJQlJWTUtlQlh2VEpFZzljSXdMeTRrUUhnZE9vM3hYN0RD?=
 =?utf-8?B?dTk1dTk4WG1QZVRhTGZIbmErei9ZSVo3NkdUYWYwRndibkNhcllISnNQYlpD?=
 =?utf-8?B?R3pmb0RrLzRuWXBLWlYzL0xFcFgxaG9rdlcwKzM4UEViZmkvcnhtTDA2OGhF?=
 =?utf-8?B?ZDBtcXhuclloaXczZ2hQNW8zWldiQ2dBeGE3ME0xVHIrQlVDcTFpVWhNK2Jr?=
 =?utf-8?B?L29rN093Z01vZzdlWDZaaGNYSXBITW5GL2hWRE5YY0tYb3k0aUJmVHh6NXlj?=
 =?utf-8?B?eVYwNVMxSHg4SnBKRTBlb0tadlBFUk1jbkJJN0lMdTkwS3NHeEpjT1B4anFX?=
 =?utf-8?B?MGtqSHE1TFp3QmxsYWNMZXluRCtmS0pOWS9mZCtrejhpUU01bC8xNXBLMm5w?=
 =?utf-8?B?QnlaZkYrbit1b3RqbzFjL1ZGV3pQQjFBL2RFSHZ2bGJMdGZYRzNqZ3BHZEU1?=
 =?utf-8?B?aEtObXBZTG1hRjZhaGlHbHdUUEVrZ00relR3Mmh2WDdhTkZoallKZ2RoSHpY?=
 =?utf-8?Q?4P/tpkTWpqBc0XqISABT0LbXh?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BABF6FEC8A9BEC47B91A0F8E29B5801E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4438.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05052e52-d2d7-4acf-dc80-08dcc2b40f99
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2024 14:09:39.1338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dyqj5iQKGR1ti+sVi74xH45LNvdW0OSe/LS3Z+cHDP9Ko55Dy3lc0ddRNC8PMgLOvGDMmSGqHYT/1D0pnf+/Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8714

UGluZ2luZyB0byBicmluZyBhdHRlbnRpb24gdG8gdGhpcyBmaXguDQoNCk9uIFdlZCwgMjAyNC0w
OC0wNyBhdCAxNDozNSArMDIwMCwgQW1pdCBTaGFoIHdyb3RlOg0KPiBGcm9tOiBBbWl0IFNoYWgg
PGFtaXQuc2hhaEBhbWQuY29tPg0KPiANCj4gUmVtb3ZlIHN1cGVyZmx1b3VzIFJTQiBmaWxsaW5n
IGFmdGVyIGEgVk1FWElUIHdoZW4gdGhlIENQVSBhbHJlYWR5DQo+IGhhcw0KPiBmbHVzaGVkIHRo
ZSBSU0IgYWZ0ZXIgYSBWTUVYSVQgd2hlbiBBdXRvSUJSUyBpcyBlbmFibGVkLg0KPiANCj4gVGhl
IGluaXRpYWwgaW1wbGVtZW50YXRpb24gZm9yIGFkZGluZyBSRVRQT0xJTkVTIGFkZGVkIGFuDQo+
IEFMVEVSTkFUSVZFUw0KPiBpbXBsZW1lbnRhdGlvbiBmb3IgZmlsbGluZyB0aGUgUlNCIGFmdGVy
IGEgVk1FWElUIGluDQo+IA0KPiBjb21taXQgMTE3Y2M3YTkwOGM4MzYgKCJ4ODYvcmV0cG9saW5l
OiBGaWxsIHJldHVybiBzdGFjayBidWZmZXIgb24NCj4gdm1leGl0IikNCj4gDQo+IExhdGVyLCBY
ODZfRkVBVFVSRV9SU0JfVk1FWElUIHdhcyBhZGRlZCBpbg0KPiANCj4gY29tbWl0IDJiMTI5OTMy
MjAxNjczICgieDg2L3NwZWN1bGF0aW9uOiBBZGQgUlNCIFZNIEV4aXQNCj4gcHJvdGVjdGlvbnMi
KQ0KPiANCj4gVGhlIEF1dG9JQlJTIChvbiBBTUQgQ1BVcykgZmVhdHVyZSBpbXBsZW1lbnRhdGlv
biBhZGRlZCBpbg0KPiANCj4gY29tbWl0IGU3ODYyZWRhMzA5ZWNmICgieDg2L2NwdTogU3VwcG9y
dCBBTUQgQXV0b21hdGljIElCUlMiKQ0KPiANCj4gdXNlZCB0aGUgYWxyZWFkeS1pbXBsZW1lbnRl
ZCBsb2dpYyBmb3IgRUlCUlMgaW4NCj4gc3BlY3RyZV92Ml9kZXRlcm1pbmVfcnNiX2ZpbGxfdHlw
ZV9vbl92bWV4aXQoKSAtLSBidXQgZGlkIG5vdCB1cGRhdGUNCj4gdGhlDQo+IGNvZGUgYXQgVk1F
WElUIHRvIGFjdCBvbiB0aGUgbW9kZSBzZWxlY3RlZCBpbiB0aGF0IGZ1bmN0aW9uIC0tDQo+IHJl
c3VsdGluZw0KPiBpbiBWTUVYSVRzIGNvbnRpbnVpbmcgdG8gY2xlYXIgdGhlIFJTQiB3aGVuIFJF
VFBPTElORVMgYXJlIGVuYWJsZWQsDQo+IGRlc3BpdGUgdGhlIHByZXNlbmNlIG9mIEF1dG9JQlJT
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQW1pdCBTaGFoIDxhbWl0LnNoYWhAYW1kLmNvbT4NCj4g
DQo+IC0tLQ0KPiB2NDogcmVzZW5kIG9mIHYzIHdpdGggc3ViamVjdC1wcmVmaXggZml4ZWQNCj4g
DQo+IHYzOg0KPiDCoC0gQWRkIGEgY29tbWVudCBtZW50aW9uaW5nIFNWTSBkb2VzIG5vdCBuZWVk
IFJTQl9WTUVYSVRfTElURSB1bmxpa2UNCj4gwqDCoCBWTVguDQo+IHYyOg0KPiDCoC0gdHdlYWsg
Y29tbWl0IG1lc3NhZ2UgcmU6IEJvcmlzJ3MgY29tbWVudHMuDQo+IA0KPiDCoGFyY2gveDg2L2t2
bS9zdm0vdm1lbnRlci5TIHwgMjQgKysrKysrKysrKysrKysrKy0tLS0tLS0tDQo+IMKgMSBmaWxl
IGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva3ZtL3N2bS92bWVudGVyLlMgYi9hcmNoL3g4Ni9rdm0vc3ZtL3ZtZW50
ZXIuUw0KPiBpbmRleCBhMGM4ZWIzN2QzZTEuLjY5ZDk4MjVlYmRkOSAxMDA2NDQNCj4gLS0tIGEv
YXJjaC94ODYva3ZtL3N2bS92bWVudGVyLlMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3N2bS92bWVu
dGVyLlMNCj4gQEAgLTIwOSwxMCArMjA5LDE0IEBAIFNZTV9GVU5DX1NUQVJUKF9fc3ZtX3ZjcHVf
cnVuKQ0KPiDCoDc6CXZtbG9hZCAlX0FTTV9BWA0KPiDCoDg6DQo+IMKgDQo+IC0jaWZkZWYgQ09O
RklHX01JVElHQVRJT05fUkVUUE9MSU5FDQo+IC0JLyogSU1QT1JUQU5UOiBTdHVmZiB0aGUgUlNC
IGltbWVkaWF0ZWx5IGFmdGVyIFZNLUV4aXQsDQo+IGJlZm9yZSBSRVQhICovDQo+IC0JRklMTF9S
RVRVUk5fQlVGRkVSICVfQVNNX0FYLCBSU0JfQ0xFQVJfTE9PUFMsDQo+IFg4Nl9GRUFUVVJFX1JF
VFBPTElORQ0KPiAtI2VuZGlmDQo+ICsJLyoNCj4gKwkgKiBJTVBPUlRBTlQ6IFN0dWZmIHRoZSBS
U0IgaW1tZWRpYXRlbHkgYWZ0ZXIgVk0tRXhpdCwNCj4gYmVmb3JlIFJFVCENCj4gKwkgKg0KPiAr
CSAqIFVubGlrZSBWTVgsIEFNRCBkb2VzIG5vdCBoYXZlIHRoZSBoYXJkd2FyZSBidWcgdGhhdA0K
PiBuZWNlc3NpdGF0ZXMNCj4gKwkgKiBSU0JfVk1FWElUX0xJVEUNCj4gKwkgKi8NCj4gKw0KPiAr
CUZJTExfUkVUVVJOX0JVRkZFUiAlX0FTTV9BWCwgUlNCX0NMRUFSX0xPT1BTLA0KPiBYODZfRkVB
VFVSRV9SU0JfVk1FWElUDQo+IMKgDQo+IMKgCS8qIENsb2JiZXJzIFJBWCwgUkNYLCBSRFguwqAg
Ki8NCj4gwqAJUkVTVE9SRV9IT1NUX1NQRUNfQ1RSTA0KPiBAQCAtMzQ4LDEwICszNTIsMTQgQEAg
U1lNX0ZVTkNfU1RBUlQoX19zdm1fc2V2X2VzX3ZjcHVfcnVuKQ0KPiDCoA0KPiDCoDI6CWNsaQ0K
PiDCoA0KPiAtI2lmZGVmIENPTkZJR19NSVRJR0FUSU9OX1JFVFBPTElORQ0KPiAtCS8qIElNUE9S
VEFOVDogU3R1ZmYgdGhlIFJTQiBpbW1lZGlhdGVseSBhZnRlciBWTS1FeGl0LA0KPiBiZWZvcmUg
UkVUISAqLw0KPiAtCUZJTExfUkVUVVJOX0JVRkZFUiAlcmF4LCBSU0JfQ0xFQVJfTE9PUFMsDQo+
IFg4Nl9GRUFUVVJFX1JFVFBPTElORQ0KPiAtI2VuZGlmDQo+ICsJLyoNCj4gKwkgKiBJTVBPUlRB
TlQ6IFN0dWZmIHRoZSBSU0IgaW1tZWRpYXRlbHkgYWZ0ZXIgVk0tRXhpdCwNCj4gYmVmb3JlIFJF
VCENCj4gKwkgKg0KPiArCSAqIFVubGlrZSBWTVgsIEFNRCBkb2VzIG5vdCBoYXZlIHRoZSBoYXJk
d2FyZSBidWcgdGhhdA0KPiBuZWNlc3NpdGF0ZXMNCj4gKwkgKiBSU0JfVk1FWElUX0xJVEUNCj4g
KwkgKi8NCj4gKw0KPiArCUZJTExfUkVUVVJOX0JVRkZFUiAlcmF4LCBSU0JfQ0xFQVJfTE9PUFMs
DQo+IFg4Nl9GRUFUVVJFX1JTQl9WTUVYSVQNCj4gwqANCj4gwqAJLyogQ2xvYmJlcnMgUkFYLCBS
Q1gsIFJEWCwgY29uc3VtZXMgUkRJIChAc3ZtKSBhbmQgUlNJDQo+IChAc3BlY19jdHJsX2ludGVy
Y2VwdGVkKS4gKi8NCj4gwqAJUkVTVE9SRV9IT1NUX1NQRUNfQ1RSTA0KDQo=

