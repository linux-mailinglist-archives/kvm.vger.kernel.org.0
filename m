Return-Path: <kvm+bounces-43656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6FD0A93707
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:26:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6FD8A1B66189
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB5C02749F2;
	Fri, 18 Apr 2025 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zqk47bIW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF0C2222D9;
	Fri, 18 Apr 2025 12:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744979166; cv=fail; b=H0prZb/m0kh8j3D64vNi1h/7fEA+HMqMdHtvS1eQMaaqlNJbhgvbY0GFo3I8FFCq8eoD2A3PsJf0inHJTZ0wbC3LaS6dKxUbDTxj1HCzm+LMAAKBo26mfJfdK7gjkPigGqiL4LDamsh68kQx2P7Ewi7ICwUn9kfJ+rUdE8Dqmlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744979166; c=relaxed/simple;
	bh=M06WAYVejhu3ZKieXjI2pYkLiHh7ELZvHWVZbYy42mU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Vech4e7kjVCd+HUKG1lxAwyzCXT56HglmaxC2jpKVHXXvpCTGtAtFFLKj4H6rQNKYzdF4SsbojMoeXWksFySwozGUjw77nMfaroJ8l4OrU6yds8pZen8GAjz+Zka1f2+fnsvAfePbNIslyZ7mMJ8pMAV0Rlz6doBBTBdbAs7wSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zqk47bIW; arc=fail smtp.client-ip=40.107.101.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SNbihUAGNtDXZpi9oCR8ffLnbALYaAxxsrjzYqgTXcB6DRSDBDAUMJnOqFE7toP3Qxsywihz6tJLF4gv5JLb3GuSC5ZAJgXuVLyo1mmk05SKO8yqnP8a20lRbovY0e/a4NYgRvDgstWvkT2Pgo4jrCWjc34khcaKTbm1wt0NJobCtEzu9yySshn+2ZnlnAglmJdUZpcf0FFWwqqdi1PIQMOMEEI0fq2EMnJJu1TRvB3dyMouV5v2hzUylBkKmXnCc4MpxK+UCdf8Gfu59DBWofaLwKWnvo05HPCDWZvVmDf0JIpFGM9cv4/Z8I1pLYkCtsJzZuA/K1d3VTFJ8NkeHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAA2YkTzNt8npdZ8jPEjvr1/PwKvtMh6jxwld0vbYlQ=;
 b=MqHGE+riE3wTK726jm3EHMlq3rhJXrPF6pJiKNBGBn0Vw1rt/IXBTthdFADggwccffO1ZD751icgFSQSgYOYy46o5Bq6lkTdfwg8P6dLrZ8ea703IsO0Gf8EpEVc8DBD/cQcvw65tra8qdDov/CVMb4osfR8fShdaeUuPcxuECqzhpGy00S9D8/sDWIgD0Q/2NLWBUjs2Xx96f7troNjR1+ypMwmFsVKDlTute+IxdOoveLlDJM54IS4oiCFN/gi1biVtnSoj/+IKquLaxoZVC65BUDQFmzRS9jCRBuNoy4h2TWKrV/ZLVqhY4IqvGIACMqdtVvBxzpafjjTmEANUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAA2YkTzNt8npdZ8jPEjvr1/PwKvtMh6jxwld0vbYlQ=;
 b=Zqk47bIWjAuw3AUHceJqAW000GWjUPLxbQXdVCIdQsZPuU07rB4CRHOvwnXLlf7hebLmv3MJEjXN2Uw2QfqExZjA4j0DDbO6VlD881Eqpd7NBkRNdDfSxCQbHk7U7nPLCvXKuL8aEV/bS8IjP0K9Ql2eiTQXuZU486DFgyDCg88=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA0PR12MB8422.namprd12.prod.outlook.com (2603:10b6:208:3de::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.34; Fri, 18 Apr 2025 12:26:00 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%5]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 12:26:00 +0000
Message-ID: <fa133913-21ab-4d61-beb7-fb2106d5fc5f@amd.com>
Date: Fri, 18 Apr 2025 17:55:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/67] iommu/amd: Return an error if vCPU affinity is set
 for non-vCPU IRTE
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-6-seanjc@google.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <20250404193923.1413163-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0093.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9b::21) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA0PR12MB8422:EE_
X-MS-Office365-Filtering-Correlation-Id: 400867d4-c013-4c61-5daa-08dd7e742d4a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SGRKWTZ6ajZTVjhXY0dCa1hhR0x2c0ZWUDFzU0treWVMSXd6cWhKVjJxMjU3?=
 =?utf-8?B?RERrSUxOVjVSS2QrcjZXMEhDTy9Ta1k1aWlYWTgwZnFEMVlTcEhzbEV4RzFx?=
 =?utf-8?B?a29qL3lQSENDWmlxcWFianZ1MnIwWVJqREQ0OXI3N1JaWVdMRGNBVmNMd2JS?=
 =?utf-8?B?L1FyNGFSNlE5OGdkVVZabEJCT1JaaDdnNEtOTzVMU1l3S3gzd2s1MjBNWFVU?=
 =?utf-8?B?Zzg3cW1wZTMxRytJK3puNlgxRk5FZHpmUzlQTVRLWmVuaUhFdE9pZitBbXNs?=
 =?utf-8?B?RU50MGI1amxDMEE2T2pwNjYzQ3BKdWV4dVc1d3ZGT1AwRmp2a0hxRENKVlZv?=
 =?utf-8?B?YnBqUUtWY3NZSlZsY0JMVWNEbFE1cERNZE1zck9KWjllclVWWmM5UzJ0azFa?=
 =?utf-8?B?dk81czdCUDJOeU1XOHpMWXFnWHkvd2hNNCtaRWtOMVNhVjJyanRJSm9qREFB?=
 =?utf-8?B?TzcwcDRzMStzeGgzRDJCNE1hMHFud1FKQ0tGOCtWS1prbHJTVFdYRzBzY2Jx?=
 =?utf-8?B?bU15RHg1OU1SZVU0cmpNUm1LK3hoMzdITVVIdFQ4eW9OOHlXaXZsVGwyNzlH?=
 =?utf-8?B?ekJyVzZaU3grWTdWbGp5blB2dmY4alAwcVlsTzdVN2NJRmlyem4xb1V5S2xs?=
 =?utf-8?B?Q3RudFhkNndZQTVVZ1JPa1RkUFo1YlNOZjZ2ekQvb0RtQUZwbGc3aVJjSlha?=
 =?utf-8?B?bWFqV0lWZnB1NStQaWVOSTdXQ2lvOTh0d3ZOYnFDRHBFcWdtdFhFeG8vSDVr?=
 =?utf-8?B?cGViN0ZOV0RVNUN3NVBuSUY5UHVZVGFRVkFMYk1lMTZIdGpMc0l0T1R1WnAy?=
 =?utf-8?B?M2Naa0FiaTBhT2F6ZDZsc1ErTmZ3cWxyQ2lyRTFyTFl4d2xoTEZRK21kU0VG?=
 =?utf-8?B?ZVh0UXRlLytXZjFrdit5eG1XOWxkMkNPcXlGNHJxdVVzdm1rQm4zMDNBWHp5?=
 =?utf-8?B?OWNkM1hMNDg4ekJqMDZhaDBuRFBTK3p2QmQ3V1hnZThiTEFKMXM2YnBzUUhV?=
 =?utf-8?B?bmEzS2g1STF0NHRyNEpBUDRiQllta1JQc2RCY20ydFFNalZ4U2U3Ylg5TFNh?=
 =?utf-8?B?akZYbURBWjJXNEJoclhVMkxvWmxQL04rS3Z1K0VObm5TWGprTVBQSlRXRnFa?=
 =?utf-8?B?N1o3bk9jV3VPYjBvbTh6YzRmYXRWWEdibU9vZU4yT3JzaVRuR3FmenRlK1VJ?=
 =?utf-8?B?MlZRSXlEL3JmSElERUcySlRhRmJ4OHFGYlRrd21ISURVb2h2UG9Lb1hXS3BF?=
 =?utf-8?B?aHZuMk95dktSWnlsek1pQ3FJOUtNT0tIYW1aclQ2ZUZaVnd4TXhsaFVKQjE4?=
 =?utf-8?B?eTVsVnFKdnk5OEdPenlOY00zdmFCUklsUlpVM0pHWjhCa2ZyZXRGODZrZDRN?=
 =?utf-8?B?WUlZMzI2TEdOUVVLUG56SjYvWTY0Qm9XR1BzWkNHeWRtQ29NTTV0TTgwY01F?=
 =?utf-8?B?RjdnU3pEQ2JyV2ZBNGFUN2crb1VUdnZTYXpQYVRMVU5MWlBQLzJxK1lRdUtS?=
 =?utf-8?B?Nm5SblltczRWL1BPQzZ5VkE0M0ZqcHgzdUo4MVo0WW1EVVBna3M5UFBWZ0to?=
 =?utf-8?B?Vk5kaVdzRjNaRkI5dlN2anY0VHNZZkptWEhVenNsaUNBL05rTHdwdUtub3RQ?=
 =?utf-8?B?aHgzTWFGRHhiZFQwOUF1OTM4QUxIQVFjcmlGSXZEQmU4TmZrN2ZPUkhVT3J1?=
 =?utf-8?B?b3hLM0pvYVcvR2JaNlpCTUVwUlRzTlJYaXFTYyszZXpaNlBGbTRsUGZSenBF?=
 =?utf-8?B?MmphYXJnWFAzSFpvU3NNak44elRhL2FjS2J5WXBmRlhWaFZveURwS2llUTZp?=
 =?utf-8?B?S2lLOG0yNVozOTlKYUFPdHdsRFBSUGxvRVFEN1ZIc1IybkJHaERlLzBYVjJY?=
 =?utf-8?B?OE5VMlpLd1FjL3l0UE5yRXB4N2tQMU90M3J3eFZ1WHhOL0E9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDdhU2MyYWJob01ZWFNUN2tnL0lnaDkrRHplb2g4V0lFUHQxNUJHNjBzTkxH?=
 =?utf-8?B?RnBxellMQW5zamZJdDFsY0FTSDBDOS81VWZDRjhsa053OTliK29ZUmNXd0RS?=
 =?utf-8?B?U2c5bEh3QkxnaVlUajY1SFFpT3E4YkVDS2o3eHc4QUJzd3NGUk0xZHJ2Sk54?=
 =?utf-8?B?OHZaY3pkd0dESmloV2FiSWJCOGlCZ1VSU1FyT3owYmdRRjh0dWpWOVFyNE54?=
 =?utf-8?B?WGtyNmRCQ2plaXlwN1cwaWN1YllzRUZKZ2VraVZCN29Bckd3UmhiTFJSR1RI?=
 =?utf-8?B?UXY4MjU1NVUxNW9EMVhIb3FYWWpGbTVCVjJ2eVNBWGZwLzhuK1pvbHFUeFhl?=
 =?utf-8?B?Yy9PeEJTaTBGK2VjN2F4NndYOFA5eU1OdmkvR2oxNHZOdW5lYlBQa3cxNDVK?=
 =?utf-8?B?bldweTBLM2ZLSm4yT0hIRFBSU3dxQ0ZENGMzNUpsWmdVQXY1NnQzci9kSEhJ?=
 =?utf-8?B?Y1JpdC9FQklyQVJzRzNqQjRrUXhxckJyUDNMcFFTbWs5RTBRd0NGVms2Ri91?=
 =?utf-8?B?MnEvbGlRZ2dzYzQyTUtRYWsrZUlzRVdlek9MS0NoSHduWUNnMXNucEl2OHpq?=
 =?utf-8?B?Z2JMVW52K0VKQUV5R25ra0RDYjhDZWtzSUZSTzh3aXJUZEJEUmRSbkNXSDBx?=
 =?utf-8?B?bEJmdjJpNk1Xck0rTk9PTElmaE8rREdiRit2Q21UTExESGNwbXFBUGJFbWto?=
 =?utf-8?B?Znd6UDI3UHpyYUxSMHd0NXB0Ukh5LzdxZktpbHM3Uzhtd2srRnFZUzBEUWhv?=
 =?utf-8?B?WkQ5TncrYldtZXA4M1A5RjBBUEZOcjFlcGtDMGN0ZXVWNDZsdkVKQnRVMEhF?=
 =?utf-8?B?dnNWUG1MK2ZMdmVPZWZBbXF0WCswWUpqM1pZcnI4eVAxcmJ2cDdqdzlsL1cy?=
 =?utf-8?B?cVl6czhHbkpBKysxeFI1a0Q3RzVzTUJoaWthTisveTRzbnljcFNJYXJtZ1No?=
 =?utf-8?B?ZlRVWFV2Ri9WYnBQMXZZZXFaYm1BTmIyTXVOV2hEWTRJSDdlcEdjb2VMaXcv?=
 =?utf-8?B?TWhZb0xlVjBlUzBDcE9IdENPS09NY1k5MUtaSThoQXNIZGZJZXVIdXIrUTJL?=
 =?utf-8?B?ZVF1cFE4MTVUcHkyeEFuYzV3NGpzZnBMSE0zTzgrTHk5R2JpOWZWbmhNOGVX?=
 =?utf-8?B?Q2dxYWdCZjc3Y3FRYWZ0Z3pYdkdacGJmMUl6bURLWFdkeFFKRm94R2tPQUQ4?=
 =?utf-8?B?dWYxWnQxT2Q1dktCd2kxaUpmbHFhajZKRFZ0STN1bXNnRHRwQjJkK3NqOVpM?=
 =?utf-8?B?K0RVZ0tDOWhYV1ppY3NLWUlEbUFNazhEcXZnYzhwOERuVjlvNkVSSGF4K1NV?=
 =?utf-8?B?Rko5R1UyVGxpcUptRGk2TFBjaithcmNETlJyb1FLYjgzWUdtMkExajZISitL?=
 =?utf-8?B?S0tCTG9TQmREaEtyZXNkSUowVDJjU2w5UkZ6Vjk5cDYzV25xTEFOejd3aDI5?=
 =?utf-8?B?NGRrMUdLbytJOWEwZFBBVlBZMVlXMmdYRVBjQkQ0NDVPZ0JEYnhOczFyeUIz?=
 =?utf-8?B?d25ZblE5NXpCeHBLTzBEczZzRFVacTVFZFZQdXZWVWxSY2dOa0xUY0d3ZmJK?=
 =?utf-8?B?Mlo0M3dqV0VTaVp6NFFrVWJUd2xrbFRndG53aVd0QnpCVkluMkFYZFovalFm?=
 =?utf-8?B?S0ltWUczTklzWDdNSnpVMUZ3NTN1aktPYzd2WEZObXlrVFJWQ3VUZzM0ZjNz?=
 =?utf-8?B?QUFjN0kwanNVQ0FyWDlTbENoTGsrVkdVQXJYbU91YytQeUN3TFFxaTRjZmJi?=
 =?utf-8?B?b3hZMFBEK2Q2UnprYWowb1ZDSEJVczdOQXBVZjVtVGxmY1JVbUdkMloyY3VT?=
 =?utf-8?B?WEk0NkZ4SDRGQ01KVmpuTGJCcjFkWklNNlV4N1ZDMWZkbnVZZGpET0NjOHJW?=
 =?utf-8?B?bzExT290Qzc5ZlgzZmxKZTZzWFlEYU9UeGJxTG9KUmFucWFpY09sekVnK29a?=
 =?utf-8?B?MnVHbk45Y29wWkQwbzZIa0EyS0NUOWNSQVl2NUtEZm02VU4vb25Rc3RCL2Ux?=
 =?utf-8?B?RnhqbUFFRG1uOHBpdkRGV1grR3VIdTd4a1dnQlp6a1BiYk1Db05wVWRXcTNt?=
 =?utf-8?B?elpYL0lkQTdWb1pCTVkycmZsOWllcEdXYktYa2E5SVR2UFVlQTFyRVM1REo1?=
 =?utf-8?Q?4+6w2LybxvzGLso7hynskNNQO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400867d4-c013-4c61-5daa-08dd7e742d4a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 12:26:00.0898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gdFRuuIaWUZMtiwPxwQfl4WZMrXlGyAj+KOT3Ad4ZORBRgbfa5R1+x1kZD3Rp/+gg7/KoQcZrXgLsWoMq7IWpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8422

On 4/5/2025 1:08 AM, Sean Christopherson wrote:
> Return -EINVAL instead of success if amd_ir_set_vcpu_affinity() is
> invoked without use_vapic; lying to KVM about whether or not the IRTE was
> configured to post IRQs is all kinds of bad.
> 
> Fixes: d98de49a53e4 ("iommu/amd: Enable vAPIC interrupt remapping mode by default")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant





