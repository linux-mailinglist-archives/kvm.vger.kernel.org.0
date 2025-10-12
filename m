Return-Path: <kvm+bounces-59854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CEA0BD0BEE
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 22:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DBE354EA3DA
	for <lists+kvm@lfdr.de>; Sun, 12 Oct 2025 20:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76996221739;
	Sun, 12 Oct 2025 20:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HGVS7Wqf"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010045.outbound.protection.outlook.com [52.101.61.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0EE1F4295;
	Sun, 12 Oct 2025 20:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760299275; cv=fail; b=aKi2Wh/GQmreGdpok4PnEIGeWOx1R+S/+aBodLxNfRzb4BP7m4Uc3eI8uWjzpefI8J7uPZWsnM4xvtpSHWdMF3JZryoPgSjKOEq0DnV6uFggTvIlHUHKLmZc2MHbGYcLVbPF67MVLJVO0IfhL10VkmvxNRebS205UHlfJAfz6Hk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760299275; c=relaxed/simple;
	bh=jl/8X8fquBXDDUHpuHosQqYgW75/DtGbBIQEQK/gJBc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UwmTtq+F4+NAuLrVTvKoZkrhYcm6fq6QUgheczU+5KI1T3+PKHpvK2xIW1kOvrFnbk1D72u5uZkn8cm09uYRl7XeCZNzX9c7665iiiyVNZGsDfqdVEyNCyVbEdE89RrXXODrgkNL3KnWhBoEzDPdFSaMCa4hQ6efXLg63ytZB+c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HGVS7Wqf; arc=fail smtp.client-ip=52.101.61.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ruZfFViO9DPlTlOerphEUXZDq8Ep0Hvb2SM26V68ySUCQIgeOsvd6pDBlLzUntxStHPG4B9xHu1lNfZXmjCoCq1WWM5kv+PT91bOe6EX/rECqaleGdEZo1kQWiTVqfX1ZbJ2S9q5VkytN1FMOafngZLNN9wl1lYJI6HImGFV8Q8E9HhfptqHA7Br8trJjBurtz1epYSuz+a4G6Gqxj6uiyCTn6xY1pXBXDwDWSBvqlYiGNlftAU2K5t/KB5V+pzYJt7vgdl6Twe7I7hGsJHJJ+bQioLKnZ+JJOHFIKBgcTQnSvXwin8ryGS7UIMeWgn2RYJP5k3k2W/ju10LAIpQgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qn2HKt/m/DQo04HMIGuWo5ISWfc+6wBaeeNlJUrBTks=;
 b=G287Oj/PtxcLmSNVuDFVdTrTeXniV+IvU5UFd2Z3ClChbHVrYVQDCZxrK+HAT7IYegS4wx52JPWBi7GzdgfULFalO1qd26vkNzdLMYdUBAS+Du4RH0iridb0HaX/7r2IPzbhqjHD4F7GiK/rBs547Teex30evtzZRt14QCFlxmI1qosLgjWnbeMF/yw0oo1+Bhp7tHY+4n/isrGganSXYFMltsVmfTJ05qgtncHxuISXW7d0uatDwce0m6j3ZBlrAaW8FuwRn6aajOGPwYXp8DDSuqd6HcXVIkLAgB4eLIezYHxUQPmeZTve7zt+wa+nMY9qaqRMyWrG1IQ7W+MntQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qn2HKt/m/DQo04HMIGuWo5ISWfc+6wBaeeNlJUrBTks=;
 b=HGVS7WqffAsYQe8dfu2txhN54hCzdRrzC9xqB8bEWMf5VbtJIbTg7Qj1ZmGub8NZCgqY1WcW0iqTBI9FalUkRw8vt75SzVp1gP5KxJuiIJ1aFsVOYHD1Ix6E1K4rZlHaUGPaccTPxEs2Z4IlJQ211RwGi9mhEPUr4HXUe1dfLgg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PR12MB8301.namprd12.prod.outlook.com (2603:10b6:208:40b::13)
 by SJ1PR12MB6122.namprd12.prod.outlook.com (2603:10b6:a03:45b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Sun, 12 Oct
 2025 20:01:06 +0000
Received: from IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823]) by IA0PR12MB8301.namprd12.prod.outlook.com
 ([fe80::e929:57f5:f4db:5823%4]) with mapi id 15.20.9203.009; Sun, 12 Oct 2025
 20:01:05 +0000
Message-ID: <e9d43abc-bcdb-4f9f-9ad7-5644f714de19@amd.com>
Date: Mon, 13 Oct 2025 01:30:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 05/12] KVM: guest_memfd: Enforce NUMA mempolicy using
 shared policy
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>,
 Ashish Kalra <ashish.kalra@amd.com>, Vlastimil Babka <vbabka@suse.cz>
References: <20251007221420.344669-1-seanjc@google.com>
 <20251007221420.344669-6-seanjc@google.com> <diqzo6qfhgc9.fsf@google.com>
 <e9bd02ba-ff0e-47a3-a12e-9a53717dde9b@amd.com> <aOltikRvKzCy1DXN@google.com>
 <diqzv7kmfmio.fsf@google.com>
Content-Language: en-US
From: "Garg, Shivank" <shivankg@amd.com>
In-Reply-To: <diqzv7kmfmio.fsf@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0165.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::35) To IA0PR12MB8301.namprd12.prod.outlook.com
 (2603:10b6:208:40b::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8301:EE_|SJ1PR12MB6122:EE_
X-MS-Office365-Filtering-Correlation-Id: 12f405fb-b2aa-469b-8211-08de09ca13bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SDBnekZqMmRVQW10V2xRRFpUSURheHZ5R29jZ1Rtb2gwSm1nVFBtTTJFNzdC?=
 =?utf-8?B?WmsvVDA5R2MwejYxc2t2STJEK0tvQWpXNFJlb2dVVVQ5RW5wTVpmTVZrci96?=
 =?utf-8?B?alhYZW9NdVp1dzhaNEJDUlBKVVdTb2h6dDl6NVpsNG9UbldZOFZaNzlsaU9o?=
 =?utf-8?B?NTFYYVhML2wzOFRqUmQwZERNYzBzcllvc1c5VlAzZXFUTjMzWVNHVUt6ZWVM?=
 =?utf-8?B?bS9DdUs3QnJMcEJCVHoxUUUrK24rcnFlV2xVZUVIZVhRcHY3K3BCRmdmZVJk?=
 =?utf-8?B?TGhQQzFMTkxUWk01aU9LVWxsNmRHZDVxYlFHcWtjU09UUVFEWmRvSU9TbUFQ?=
 =?utf-8?B?N3NOVUcxSUIvYVZuZTF1UXZzU3VYL2gxbkNORWdWV1NvYTJSWG05NjZvMEx3?=
 =?utf-8?B?a2xwRFZ0L0xyQ1pkdmRqR3ZFZk5BR3o1UWJqdG1GYWdGUnRKQW1sN2JIOTN2?=
 =?utf-8?B?SWFxYTJnL1U1R0Z3OUxlMkRaUWFTSks2RXBqeVVCVkt5YTBvNnloNkxUZGUv?=
 =?utf-8?B?b1M5UXJKRC9lNCtNMmZ6TzJjdkFMUUMzOWI1bDhHT1lrVkQ3SlJaVVZsNW8w?=
 =?utf-8?B?dmwwYjAxZjJSWHBRaW9iOVNhL3Y0NmVJTUdtVDVqYW5vZFp0dTU0OVMrU29N?=
 =?utf-8?B?eVFzMzEyV1NMc2IwcW9ERXpaZWNaSndTaXlNMEdwZU81YldhYTQrK0hZYVRG?=
 =?utf-8?B?YXFTTnJtSDdoSzlJTUNpSzVQVS9rRCsxeHo4NkxYWExzT2hKanJZemlBVmZ1?=
 =?utf-8?B?TEEzNDBsN0xyMHVFblM5TlA5dXBCb3lQclZINTdHc21LR1FXM044Nklrd0Nu?=
 =?utf-8?B?SWR4dmZMUXBjRXNVZXI5K0V4cDhhQ1RqcDFFbkd4K1dlSkNjQ2EwYkxoOGZM?=
 =?utf-8?B?SGRxakRGVmpSMUhCUmZnblFQOU54dTZzYWh4a3hrYU56N3c4ZW5Jemp1dU5z?=
 =?utf-8?B?SDlMM0JMU0JhSDNERW5xNFQ3QWRDT1dJV3hudWwyanJQOTY4N3V4Y3hvQ2Nh?=
 =?utf-8?B?SE81U1JIOG9RajlpYnFZakV0ME1CNCtyRCtJc1JwL0R4NDNmdyt2V0dmbjJM?=
 =?utf-8?B?QUROazFIUTdvVGJOaWFNUnZENUxiT1RhQm5GK3FsOVBsTHpCanc4Q3RFUWdR?=
 =?utf-8?B?YlhUdU83d05qa3NydDRNSko2YmVEKzYzUXUzMEdTaVQzVXpSWU1VY1pQMjdZ?=
 =?utf-8?B?b3lvVW1hSmZwM0o2RGxQUE80R25OZWo2SEFiSnNKZmZPckx1TUVMZkVRQzlG?=
 =?utf-8?B?LzN1TWhubFJzNHU3cFNqYWd1KzJvSW1vUmQ2SWhybklGUWpPbjEwcGduMWRV?=
 =?utf-8?B?MkN2TWRtdU5XTXFCQ1VBdnVUNmFXMk91WURmUFBnVW15bFpnTnZCRlRWbkpW?=
 =?utf-8?B?c25TYTNSN0RMZ1ZBSkl2MDRaRkhESHdvZG53YllOMG1wa2xEdUdZdS9yVDVG?=
 =?utf-8?B?ajZybVhlalVZbkhSUFZybkw0Q2Q5TXRWbFJsUnFLMGlTOUhqQit6VFlFajJ1?=
 =?utf-8?B?RzJjTWNTMjJqcWFnbUl5Y2Z5ZytMY0lPUkdsc2lDcHdNMnYyOVZkZHRVaGh1?=
 =?utf-8?B?STNnSExaWUlOM1p0OFFSenlpd3hVQjZSbmR3WXFkaTlhV3BSbFJYMVIwL29j?=
 =?utf-8?B?SFZPQjJURDEzQzNwTDNidlNUUEdaYWI4ODdHbXFkaWtqL2lhTUU1NTNUV1Qr?=
 =?utf-8?B?eXN4YjRUdWJQNzN3TzM1b2dEdkRyeUdmMXpLV2U3TlJ6dEZZSGhnR1o3bzh6?=
 =?utf-8?B?cjNvRGpVYVl0Nkc1WjkwMDFITkFXd2g3ZDFIRUFra2tLUTJzQkhwalVKaDdM?=
 =?utf-8?B?ZGlsQS92ZitlWXJVT00zekdRZWcrbElWQ3ZSRXdBQVp6MXFkQVpaZDJXN05l?=
 =?utf-8?B?ejM0NkZ3Y0dXanNYbjFDc0dIT2IvSm9uUEZ4amRVVFVFYUg3ZDdQSkZrbFRy?=
 =?utf-8?Q?UifOCz/GJYaKNiArDhqVidibCeI/0CkW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8301.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SkxXVFlxa0N0S0Juayt2TERaUVZ1SThCdDIvUndCRFpTTVByeDQvNHdUbDdG?=
 =?utf-8?B?YkZPNTQzZGsxVjB4SHdKME5SZTNOd2d1c2JvaWJ5VkFWOUphN3FXa2Q3RGlE?=
 =?utf-8?B?b0Mvemw5ZjBtbVp4M2swOG1ac1dHY3JxSExhYzhObnQzVWZhc20xQW1VbVI3?=
 =?utf-8?B?dVArRUwwWGRoWTJ5V1BJU3ViQ0g3djJPdUp1UDNxTFZ4SGF6RW93cjdIcUFs?=
 =?utf-8?B?a3d6eW1aVkhtSHMwWGMyeWFWTmpRZG5RVXhsLzkvUWVUR3pZaitiMkk1REtP?=
 =?utf-8?B?NkUvYnE2WXJ2Y1JYQmpRY2cxcHRBUTlTeFIyejJ2SGd0VnZwbTUxcGoyRlVN?=
 =?utf-8?B?K3dDaS9VOG1hQXRZT0lHcyttRWUwTUMxM09ZMmFtelZGRHNBY3B1L0lLZERl?=
 =?utf-8?B?L3FQOUZuclBpM2FhblFMOHVLV3dKM0VkNXJLTUtRZWQxYmhwMWtoNC9vTEpr?=
 =?utf-8?B?WGhna1haNVVwd3NlVlRrU21PbDJyWnhsVTJPR2FHWWlBbXp2bldvL2d0SDNn?=
 =?utf-8?B?T3FMUms1ZU1ZM3pXWVg4UXVwOHpCREMraENMS2hQazF0SkFrSXIrN0V1akFJ?=
 =?utf-8?B?VE9kRkJLYWVGbkhUZ0FLd0p1YS9oYS9CSTVNWTlwUGR2d0V0ZEYwcHpPUzJC?=
 =?utf-8?B?bm5nRHIySjUwUitSYlNpZU83cDFDb3FiQjB6S0pzcTBmVDVnL2tuQWtjQ2d2?=
 =?utf-8?B?cVBub2Q3bS9TQmIxMUFObHZYSTBuR1lSVkQ5VFRJdnhZZE5lcXZycUtFaVpR?=
 =?utf-8?B?SGw4SFI5MWNPak5KYTlxQjRBODMzWXN2K1FlOFhPbXRQOFNHTjdOU1JXUHJD?=
 =?utf-8?B?bjRjV2FVTXEvdTVWVUF2cWxjTTRUdDkrZWFOaXNoWjlWRGRmMlpIenc5VDBZ?=
 =?utf-8?B?RE9HVXBqQWw1V05wK0tBU2o2Mzd5ck42Ykk4QlNZREE1OWloSW4vSi9DSzRi?=
 =?utf-8?B?L1QyVVYrZ2xublAvdXFnM2JuczllTGFLNVF6dkM2cStmalVoQzdIdjJrbE53?=
 =?utf-8?B?UUtFUHFGTFpJTEJvS3NxMHN6L0xCelZlQ0xGU0JWcVNFcTNPRGllOTI2ektx?=
 =?utf-8?B?aTZZMmlJanYzaFFINy9CY1dmQmlCWGtaaDUvNHFCSWpuQ1BZQ1d1QlFCWkMw?=
 =?utf-8?B?cjlGeTloTU1tMnlDdG9WRGh5WjB0Q1VkN21MeHlUOHVaUVVDWTkxT2thTk1u?=
 =?utf-8?B?SWwxcjBkaStUOGFXV3lBcURrNzJMZnRZc1FxY1o1Ymx4V3kzemlBdjJGdjkw?=
 =?utf-8?B?SzU4VU1OZlJiWEFiU3ZMQnZSeC9BbkRCZnREd3FVQURrUHk3YUlaaXZkNTFI?=
 =?utf-8?B?UHZoOE1LblBkUS83dnE2eERVVGg1MFRXT1J1UEVua1RsRE9JK1kvdkFDV3JR?=
 =?utf-8?B?S2VaZG15b1BxazBQNHNaUC8vNXdGalVQK3g0ZVYya1ZPQkQ1bzFkcXlBSUtC?=
 =?utf-8?B?S1YrUngzOEpSWnBnSzNIdDJXQ0k3VVY2RTU2UkZRT0w1ZGdEZno0MU9IS0FM?=
 =?utf-8?B?WG9SNHpPZ2N2ZTBKcGp1bXo2NER2elJXRFhkY3Nxc1pSazR1VDg2VklqRVhk?=
 =?utf-8?B?ZlpXYm1xZDd1OWlEV3dEVUVCdU80eHB4clkzT3d6eVJDd3RpK1lVdmY0NVVq?=
 =?utf-8?B?TEx1eVVCMTJyWi9XTzhyTEJHZVhLaU5EUERqc0lsaDZVT1NLSzRzTERTSTBW?=
 =?utf-8?B?TW8vSnhJeW54M05nSlNvRzRCaC9lUjQ1bFBqTTVjMk51RFBiNnRpVkFlVHYy?=
 =?utf-8?B?ZlNqUE1uZUNmQTEvY2kyQWZUYm0wMjhMK2U1ZXhicEdRc29zdlhkRVFhWTFL?=
 =?utf-8?B?UFNldmNPVzViOGY3UGN4WnhTdmQrWWNYYmVnMUowcGJPcUo3MFJodVYwOWdr?=
 =?utf-8?B?SmJwZnRuQnZwKytQY25DWWJVaWFCeXBncWlRN2FKS3RHU0xFZ3JEa3p1T1Nh?=
 =?utf-8?B?bjdQVnRuQXA1Z1dpMTd0ZDE1U0RkN2FFZnFwdm5sNktCOVV3NzBEelo1Ymk0?=
 =?utf-8?B?Q1dheW9PWmRiMTAzdzlGY2RTS2drdW9LNk4ycHJReEs5WG92R2RxVEtPemh3?=
 =?utf-8?B?SXByUFdERVplVC83bWpBeFJaL1M5aDZrWVIydzdqcXpTYWlCb1NvVktxSXd0?=
 =?utf-8?Q?EkULIBq+IKOSXgYJV319tsG4Q?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f405fb-b2aa-469b-8211-08de09ca13bb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8301.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2025 20:01:05.7729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3VXZDWr1zS2atIQhBzFgGyhsILdNPKoV3v8YADV8ntnuvFRE9KDkH5GqPrz838f34LgmCz4oMeK7mtDsRGOeqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6122



On 10/11/2025 3:27 AM, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> On Fri, Oct 10, 2025, Shivank Garg wrote:
>>>>> @@ -112,6 +114,19 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>>>  	return r;
>>>>>  }
>>>>>  
>>>>> +static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
>>>>> +						   pgoff_t index)
>>>>
>>>> How about kvm_gmem_get_index_policy() instead, since the policy is keyed
>>>> by index?
>>
>> But isn't the policy tied to the folio?  I assume/hope that something will split
>> folios if they have different policies for their indices when a folio contains
>> more than one page.  In other words, how will this work when hugepage support
>> comes along?
>>
>> So yeah, I agree that the lookup is keyed on the index, but conceptually aren't
>> we getting the policy for the folio?  The index is a means to an end.
>>
> 
> I think the policy is tied to the index.
> 
> When we mmap(), there may not be a folio at this index yet, so any folio
> that gets allocated for this index then is taken from the right NUMA
> node based on the policy.
> 
> If the folio is later truncated, the folio just goes back to the NUMA
> node, but the memory policy remains for the next folio to be allocated
> at this index.
> 
>>>>> +{
>>>>> +#ifdef CONFIG_NUMA
>>>>> +	struct mempolicy *mpol;
>>>>> +
>>>>> +	mpol = mpol_shared_policy_lookup(&gi->policy, index);
>>>>> +	return mpol ? mpol : get_task_policy(current);
>>>>
>>>> Should we be returning NULL if no shared policy was defined?
>>>>
>>>> By returning NULL, __filemap_get_folio_mpol() can handle the case where
>>>> cpuset_do_page_mem_spread().
>>>>
>>>> If we always return current's task policy, what if the user wants to use
>>>> cpuset_do_page_mem_spread()?
>>>>
>>>
>>> I initially followed shmem's approach here.
>>> I agree that returning NULL maintains consistency with the current default
>>> behavior of cpuset_do_page_mem_spread(), regardless of CONFIG_NUMA.
>>>
>>> I'm curious what could be the practical implications of cpuset_do_page_mem_spread()
>>> v/s get_task_policy() as the fallback?
>>
>> Userspace could enable page spreading on the task that triggers guest_memfd
>> allocation.  I can't conjure up a reason to do that, but I've been surprised
>> more than once by KVM setups.
>>
>>> Which is more appropriate for guest_memfd when no policy is explicitly set
>>> via mbind()?
>>
>> I don't think we need to answer that question?  Userspace _has_ set a policy,
>> just through cpuset, not via mbind().  So while I can't imagine there's a sane
>> use case for cpuset_do_page_mem_spread() with guest_memfd, I also don't see a
>> reason why KVM should effectively disallow it.
>>
>> And unless I'm missing something, allocation will eventually fallback to
>> get_task_policy() (in alloc_frozen_pages_noprof()), so by explicitly getting the
>> task policy in guest_memfd, KVM is doing _more_ work than necessary _and_ is
>> unnecessarily restricting usersepace.
>>
>> Add in that returning NULL would align this code with the ->get_policy hook (and
>> could be shared again, I assume), and my vote is definitely to return NULL and
>> not get in the way.
> 
> ... although if we are going to return NULL then we can directly use
> mpol_shared_policy_lookup(), so the first discussion is moot.
> 
> 
> Though looking slightly into the future, shareability (aka memory
> attributes or shared/private state within guest_memfd inodes) are also
> keyed by index, and is a property of the index and not the folio (since
> shared/private state is defined even before folios are allocated for a
> given index.

Thanks Ackerley and Sean for catching this and giving suggestions.
With directly using mpol_shared_policy_lookup(), the code looks much cleaner.

 virt/kvm/guest_memfd.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 95267c92983b..409cbfc6db13 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -114,19 +114,6 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return r;
 }
 
-static struct mempolicy *kvm_gmem_get_folio_policy(struct gmem_inode *gi,
-						   pgoff_t index)
-{
-#ifdef CONFIG_NUMA
-	struct mempolicy *mpol;
-
-	mpol = mpol_shared_policy_lookup(&gi->policy, index);
-	return mpol ? mpol : get_task_policy(current);
-#else
-	return NULL;
-#endif
-}
-
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -151,7 +138,7 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 	if (!IS_ERR(folio))
 		return folio;
 
-	policy = kvm_gmem_get_folio_policy(GMEM_I(inode), index);
+	policy = mpol_shared_policy_lookup(&GMEM_I(inode)->policy, index);
 	folio = __filemap_get_folio_mpol(inode->i_mapping, index,
 					 FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
 					 mapping_gfp_mask(inode->i_mapping), policy);
@@ -462,11 +449,12 @@ static struct mempolicy *kvm_gmem_get_policy(struct vm_area_struct *vma,
 	*pgoff = vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT);
 
 	/*
-	 * Note!  Directly return whatever the lookup returns, do NOT return
-	 * the current task's policy as is done when looking up the policy for
-	 * a specific folio.  Kernel ABI for get_mempolicy() is to return
-	 * MPOL_DEFAULT when there is no defined policy, not whatever the
-	 * default policy resolves to.
+	 * Return the memory policy for this index, or NULL if none is set.
+	 *
+	 * Returning NULL is important for the .get_policy kernel ABI:
+	 * it indicates that no explicit policy has been set via mbind() for
+	 * this memory. The caller can then replace NULL with the default
+	 * memory policy instead of current's memory policy.
 	 */
 	return mpol_shared_policy_lookup(&GMEM_I(inode)->policy, *pgoff);
 }
-- 
2.43.0



