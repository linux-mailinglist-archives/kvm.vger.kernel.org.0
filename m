Return-Path: <kvm+bounces-16390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF82B8B931B
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 03:29:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76922283786
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 01:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171EA134D1;
	Thu,  2 May 2024 01:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Yr53fGAi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE2411718;
	Thu,  2 May 2024 01:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714613362; cv=fail; b=mYa7jX1/wcPb8XR8mOyQ9uOUQ96VWv23pzPwtzWIDT2Mc/Gc4s3806WxnHb3vPZAFh9TCUill4cAJUY0k25dgvysf9z0A0kL16ZuJDIjf+13gtm4IdoOhj/7MCgyKBDpRo2QJyQIKx7ixcTNdeyZdAQfmqvTFVYAh1DIg7XfPLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714613362; c=relaxed/simple;
	bh=tLWIWs/go1m1ugZ7pfvpslsuDeLkv3RuFoyHJ8S0UpA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lbye0kIE8ChvFg3zo3qsXEV0/2sJCWOaau46J2IPGsCjeLnQudiNlh0SLTOuvbzfdmwCBeaPNxkYdOu4vQbStgpJCRgSuFkalGyE3738XTfbam509s2aqGwdaKZfanqgSJb8g6WHPIaAeUOI7mxShzUl1u3tcGlPpoTNmzH6YUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Yr53fGAi; arc=fail smtp.client-ip=40.107.92.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QqXz9qF7L9MQGhHZTMuRMnQ42PL/EHjTeZffvPRhSnSqUQkAWKwY/kcaEjdxysH0IyV0b3T8INaET0ttNKS93tvE8Kpy2QHkJOs41kf5PtuL6GWvy6IGLlymyfuj60pq0RTZK+5O9SI7s4X/SpzdU+ZfrQbUV44GTZViGDaYlmjIjzXWyaJc9q52k0cfhpaPALBfo0NOKOzia+BjaEno9uLrzr31FVVSiwXEw8YAGuozc1S5mqXE0i5IDdmVqGP7HIOFlIyp2HxInYrNmSRnpNabvN0tNar6QdAiT3/yqvxTEbDQOPWjb4Q7TrbnJ7b9ELrAMXuQkruEIhfAgNz3tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ICYcWAetBNBoKvd84D5AWs4ByMEsvmGQelD4CHm+bhw=;
 b=Hio5RK5GQ1vEZqSZ17gg6BHL3Z/XWPRcz4+Fqo2BAeJrCwYevlxpc/bsIgMKxf+wjByXiLMqnXCGNqgwMOSgONKgngEauUmQVZ9eJ8bE4TdI5vdHe5p8FtMboJ6q9PYAmrfv43ePqR82/ecVk/kb6U9pHnhkyFW80gf9STGMqeZmY+wTmoD+brHAkf16u5FES2libWI++tcGuyNxENmC4YBCbPm5+SnITmR/qjpWXPph2hivga5fTd1+T/LrQ9AvujpyoyXG/XlwhiiALvYTVwPxchSQuPGHZyp8A2mBWOy5D3EwjUCBoWJWYoK3ibUt8TBpSr0rS7F8krukC65/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ICYcWAetBNBoKvd84D5AWs4ByMEsvmGQelD4CHm+bhw=;
 b=Yr53fGAiscNWe8c/n0BUqRkRVazfrSfIo5Qi0jitcF95u4M7OVcePHKQLmE7iPojdtUWy3vdg9jtETN3lZg72UVAGFsFqqSOPQou/6W17Sx8zuKjlcQQEbKAHYBZgWNCc7Uyx0iJHZatHZh+cVgMBxZxMc4bFQ2ia+pBKDD3Hwo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MN2PR12MB4422.namprd12.prod.outlook.com (2603:10b6:208:265::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36; Thu, 2 May
 2024 01:29:15 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.7544.023; Thu, 2 May 2024
 01:29:15 +0000
Message-ID: <703f15b0-d895-4518-9886-0827a6c4e769@amd.com>
Date: Thu, 2 May 2024 11:29:04 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [RFC PATCH v2 0/6] powerpc: pSeries: vfio: iommu: Re-enable
 support for SPAPR TCE VFIO
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>, Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: mpe@ellerman.id.au, tpearson@raptorengineering.com,
 alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org,
 npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
 brking@linux.vnet.ibm.com, aik@ozlabs.ru, ruscur@russell.cc,
 robh@kernel.org, linux-kernel@vger.kernel.org, joel@jms.id.au,
 kvm@vger.kernel.org, msuchanek@suse.de, oohall@gmail.com,
 mahesh@linux.ibm.com, jroedel@suse.de, vaibhav@linux.ibm.com,
 svaidy@linux.ibm.com
References: <171450753489.10851.3056035705169121613.stgit@linux.ibm.com>
 <20240501140942.GA1723318@ziepe.ca>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20240501140942.GA1723318@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P282CA0143.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:205::15) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MN2PR12MB4422:EE_
X-MS-Office365-Filtering-Correlation-Id: c20c89aa-b082-4c82-bca3-08dc6a474723
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TnR3SDBqQVV4VmVNbEwxR09XYXVFbWREQUl6RmxwVkgrVEhPSHV4UU4zaVFT?=
 =?utf-8?B?bURQWGUydzBKbzBBWm1veVAyN0FsNkhzMHhpOW1DQnJHSmNOZjdSMVM0VE02?=
 =?utf-8?B?UkgzcUM5QjdQWFBzTjgvMW80bXJ1anNIR2tRTXpFa1orYXA5TC9WcXREcmZF?=
 =?utf-8?B?dkZWamU3MDY2Y2g5RXM3M0c1QVVlajZJRiszb3AvT1VMWTR4TXVKN1Q3bHVp?=
 =?utf-8?B?cER6Y0FOb3Q4NlNOQm1YUlpmaHl1RDZaWjZrbm55Ym5RQWlhMjlLV3B6eFlT?=
 =?utf-8?B?UGZMTXhUbVViL2hvODVCeWtQL2NrQTVrWTVaTFZuTi90THdFVWpGYUJLK29a?=
 =?utf-8?B?a1dGelIwb3IyWW5qVlhyQ2Rzb2YwVDdVbjZDQU9pNUU1TkZFRFYvSVJBMnNa?=
 =?utf-8?B?N2lJUWRRZW45TmFCN1ZQMDhTaE1RZ085YlFJMXpvR2N2a1ZXOFB6K2VMZSs3?=
 =?utf-8?B?SDlnTUM2Snd6WElncERYNzlWR3N3Sk5NVzlva3gyQUhmUTJCTGF4RUZvVG55?=
 =?utf-8?B?RmRLNkZqU28xRmZVckpTVnFTcnRKTnk2a2prdlZCeUloVEV3bDBOcmFnYVNM?=
 =?utf-8?B?UTRNV0Z6bERrYXc3azl4SUlXODFkQllWU2ZWZlpUMFFzdTBVQ1NmUWt1dzZU?=
 =?utf-8?B?MmNrMGJ0a0lWTDNnRjAzRlBvQjhLNFE2dXh1bkx0VGF3emQ0d2NBYWh4Q0VN?=
 =?utf-8?B?SmE0U2hMZVVvM3pYd1hjd0ErZUdmUmpSTmZEbUcrQzFmRXJkdWtpRklhRWZW?=
 =?utf-8?B?dU9CZGR1amMrN2NjSnRVMUFqQkM2Sk92T2NDemlxSjVTT1pMM3J6UlplQmE0?=
 =?utf-8?B?M25HcE9qd2FqOTJNczZycnNnQ3NHdHUzTEpMOEhDaldPTkErcE1PSHMzUGRW?=
 =?utf-8?B?bVBMMzhGSklVRzFNSEVYU0szUVFQbXlzK0J2VE44NlJGSUg0Yk1hdEhPWmNr?=
 =?utf-8?B?OGUwbldOTEhyd0IwUjZVNFlxZ05XTmNmOEtYTWF1ektWNFBJUlRvcTdlM3p2?=
 =?utf-8?B?L1lrRE5haTg2ak82bW5icXdJd1FPYWdUd3QrWFNBZmxxN05ITzZpZ0dZOFpU?=
 =?utf-8?B?NjByZEI5UHB0YXBHZDFsaVJzdkdQNmhHTUloWUdBbXdBNmd6WjNiVkdQRHRl?=
 =?utf-8?B?WlAvc3ZFZWpIdkhlNmh2eGJoaWZNTHZDZ1VJT1RZSXRITVhXZTVFd25HMldP?=
 =?utf-8?B?S1U2ZGF1bS9VOXJoT0hoUHk5c29XcUtlRUZFNVVyTnJxNHYvWE93TjUySGJm?=
 =?utf-8?B?Q1dRRCtaczh0dGJLbkZSR01oNWV4UkpKbURGYnhJQlZ2eTYyaUY5YXY2TDYy?=
 =?utf-8?B?NnNsMkVOL21tZ0Y3Q3l3YnBUQ1BzK3VXd3pGeUNROGdjMXhrUDN1bWMwekJx?=
 =?utf-8?B?OUlvOW14ZlYyS1RYOHRxN1kxVzdIU01sRmhFRktEQ05McEFveEM0bTFxclds?=
 =?utf-8?B?Q3VYVFZxTGlYN3l1eVdoNllBQXc4QllSVndkVG53VUdLY3VqaEtvMndzdU5t?=
 =?utf-8?B?bVhyenRLTTloWHZNTU50TnE4amx2SjVNbGU5L3pwSHpnL0VuN0dMVzZUU3Zq?=
 =?utf-8?B?VTJzZEMzOVpld1ZETW9NOHlMc1YyNlByTXFDVFBVWTh6dnlWZThVU0VpZjdY?=
 =?utf-8?B?MHJZSWVacUlHT1BwQ2NiVFQrSzM1OVFSL2tmV045OU1LRlM5SE5aR0NQbXhG?=
 =?utf-8?B?SHk0aHlkY0J3MWNuWlJXOGNVbDVPQUZBZUgrM09KaEFZQ1ZYTVgwOEVBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlNWMWRkYnhHZC9xV3ROaUR1NVNvN0laZnBsWDBMdDRIKy9zQlhiY3VGa3JR?=
 =?utf-8?B?WVYyL205NlRQYUdyMlRubTg4Q1RCUnA4TWtrMU1DblA5RFV4WWUxWXY4VWpM?=
 =?utf-8?B?aXdTUHZ1V1JPQ09XUTlsb01YOEVNUWNJcFBhWGp5Z0VuVjhPeHdUdSt3WXlV?=
 =?utf-8?B?dkJMOVFKZDFEMDhKZWREbThWRzg4YlZPeXcwUjJ5T0wxYnJ0MTdDSG16aENB?=
 =?utf-8?B?U1dHRExzTHhJbndaMVdtaWhxZ2g5YkVZWXFyTzFxeU9vam1oNis0eEllWkhr?=
 =?utf-8?B?YWorNmtVZTdDZWp5VTZESFpiL3VkM2UzUU5JMTBQdTRDUW9RaXZkcEpKNEY2?=
 =?utf-8?B?aStTeE4wYTRDcmhITDBNcHluOEZ0YzRyUCt5TjBtSnhnTk9uTXJGL3Bqb0dy?=
 =?utf-8?B?RURqNnF3b2s4b2FmNGhYYWVsSWltMFdUWjZyVEhsSE9nRXlSbktkQ3BSQ1FN?=
 =?utf-8?B?NE1va3NFc1o0TklGUnBDaG4rby9SdmEyeHVucHQrWGhEQlJQUlBJSHQ2WGxx?=
 =?utf-8?B?d2hScFhpVk5NUVhvQnJoZDI2cmU5NTl3VGJlS2k1d1lPQkw1T21qMllIS1ll?=
 =?utf-8?B?VXkycU4wZlU0RnVUSmZ5WUw5N0JIOFZaVUduMXNiM3E4TC9jRGg0ejNvcXRj?=
 =?utf-8?B?RGNGeFMyQmlWSnpyeXQ3Y0ZraVFtMkNyVjl0ODhXYkg0NTluMmx2di93RzRS?=
 =?utf-8?B?bEVHb0tWTzhDT2pRVENRVFdWRWwxazNzNzM0QnhFOEx5b2h0YVRuU1hrOVVQ?=
 =?utf-8?B?anVUS0d4K0t0NDBEMllpSVVLNjlGWlgyM3NzSXprSGJ0ZDdDQy9PbGRLYk9J?=
 =?utf-8?B?RVFsV2E3aG53TjJaOE1mT0NwYVl2ZkZiOUE5RmdvTVJWRkI3Sk9hU082b1ZF?=
 =?utf-8?B?SXVUZjZPK3M4TzBYNHhUMnBtTjE2MU5LRVZjYnBIK3RHV0UyYmdQYXlCdHFT?=
 =?utf-8?B?YkJRQWM1WDRrSm1VSTRNS28ySnNCRTMrSUtrVXFndG9ya0NnalVuUFNlenli?=
 =?utf-8?B?ZFNCR2xxbzdnS2Z5ZTlSYmtmd2hiNlRJTEZ2d1dOVkpQSjlSN2l4ZDdmQzE0?=
 =?utf-8?B?T2pYTlFnTllPTVJrOFh1RlBBbmxoOHB6K3Y2bXRuN2lvaTNDTW1HaStnV00z?=
 =?utf-8?B?aGxkTXlObm5DcFhMbUxCMktsb0tmcFRJM2xOcG40cFM3T1lRSjNFdElyREJI?=
 =?utf-8?B?dmpDMk5UejNva2Z6RXRSL0pzUHJxZTRYb3RhTjlIdXZ6NWpvR3dMSkZSdHZY?=
 =?utf-8?B?ODFHdEQ5TzFWUHdQdW5Tb1lXaDU1YWtrRDhzOXlGekZxZ01EaXluVmw2VGkr?=
 =?utf-8?B?TDB4THhvb2dIbmtDaGxidjM5dE5yRVJaa1k3azZFTExCclBQQ2NIZzkydW9G?=
 =?utf-8?B?cDhrZnFKckQ3ck9JbFRRNXhCZW4xYk1rQkNCQ1VhbTRsMnQ4YW0zOGVsUFVi?=
 =?utf-8?B?YTRySkNGbVFiYmV5ODlQOGNpNVMybVNreVpUUk9QcTZxSzRoQ0RUZ0JjcVJC?=
 =?utf-8?B?aTdZTDRIc2UrT3dkcThKcklTcHZZOGJWVXowTWdXVWJRRFowWUpYazgzcWJQ?=
 =?utf-8?B?NVB2U1c0MDdpVzVCNFkvN0JZZDJsaWVrNW1YcEM1TlhaMHRVc2FEa0tYdVB6?=
 =?utf-8?B?Tmo2dGdsNVpkcnNvZEZLNlp2TEs1WWl2N2RsK1NGcGpDMjNQVGdSK2libkFO?=
 =?utf-8?B?V21ZTUhQT0lkUmp2UVZ5UExNdnFKa2JXRk13N09rSUdMSlV0RFAxOVVjOGdo?=
 =?utf-8?B?bDlhbVhsakJRdENQeTJVbktLMDZ0VEV6dGxGNmVxbi9yUTVIWTRiem4rMWdv?=
 =?utf-8?B?b3hDY0g3bU4rVTYzaWQzYTVSRHFTZXlMWE00NUowdkU0RlRNUGM2QzhlTmdQ?=
 =?utf-8?B?cUVhSmxZNzVPUFFDV3R2QUdoaDYyVkt3dlJkZldWUHQ0NnpMaXRCZ3BZelpo?=
 =?utf-8?B?WkdzTERIYWJhRElFOW9CaVhxNlVQL3NmbXpzMk1jcFdVbWZWUTJXVDV4UndR?=
 =?utf-8?B?bUZCNTJTOXU0c2RzSlRac0IvUVpPMmo2UEQ1SnFuSlBzclRDb1lmYy9RUVlR?=
 =?utf-8?B?ZDZPR3gyMTB4ZXZXeVRrV1h3MWJ5eExHMWhLcWtCZzYxNkNjNmNwVTR1bS92?=
 =?utf-8?Q?rEbs+KV2gAoio7Dq3NuUjUO6a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c20c89aa-b082-4c82-bca3-08dc6a474723
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2024 01:29:15.1648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GPb0AZVN/SwHPMcPivEWF0yvICGsJk6Sllq1QeLlWKZfvFZvP6hLXV2VmmBK3wybXoMRISNIfl2QD5EqEj86SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4422



On 2/5/24 00:09, Jason Gunthorpe wrote:
> On Tue, Apr 30, 2024 at 03:05:34PM -0500, Shivaprasad G Bhat wrote:
>> RFC v1 was posted here [1]. As I was testing more and fixing the
>> issues, I realized its clean to have the table_group_ops implemented
>> the way it is done on PowerNV and stop 'borrowing' the DMA windows
>> for pSeries.
>>
>> This patch-set implements the iommu table_group_ops for pSeries for
>> VFIO SPAPR TCE sub-driver thereby enabling the VFIO support on POWER
>> pSeries machines.
> 
> Wait, did they previously not have any support?
 >
> Again, this TCE stuff needs to go away, not grow. I can grudgingly
> accept fixing it where it used to work, but not enabling more HW that
> never worked before! :(


This used to work when I tried last time 2+ years ago, not a new stuff. 
Thanks,


-- 
Alexey


