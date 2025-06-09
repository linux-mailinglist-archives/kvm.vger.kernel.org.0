Return-Path: <kvm+bounces-48720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AF868AD18A6
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 08:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ECC23A7B0A
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 06:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C1D280305;
	Mon,  9 Jun 2025 06:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="irYoaUH4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2080.outbound.protection.outlook.com [40.107.237.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7065D36D;
	Mon,  9 Jun 2025 06:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749451187; cv=fail; b=grQits1fEAMgE+CZyKWygSHQtS8gj8doFqFbyayrrHsxI296Cy844GiT+3/8NYaWSSG0f1G5QIxMFAJeEKM4ZtHGUgtx8kvfM01xv5uDOBh+1iocSRBCI6uZgsJ1w9M7kQNrFWTMbBJO/0Qxszi3oHtY4MFKNa6he4Ar0ZEgLK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749451187; c=relaxed/simple;
	bh=3QawUGtAEFnUzAXGnzHoOSNslCZ0fVxPICVW3KYkNj4=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xo+jpdqY4lf/EwY2xAjux4Xc6H/9lXIUm1PIhJa1RMD5/WMu6jQesJqdixkChyNhO2LalQa+4A9nms1w9BQf8qQ7kwAhJXsgYF82VaFF95XBSGhGvqcSEykmCv27ZuXYoAM0Mk8E8yq2uChvnl0LryfouIR+8WvVnfOH1Rn65FA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=irYoaUH4; arc=fail smtp.client-ip=40.107.237.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lpNB/XzoYYOgtnP3RvYsQ0d/7MswlNZC58gSbzjMza7WujzzZrRkiaDxh+gjC0N/ZrCpdjpWQjuQBOdb+3wsvdxPpH98QWtbayFmoDg4qPQZ5KRbh9nhD79DsdA0Y/PP2ymvtnZ8+YLwgJ3XIb9paLymDKLcptXxv5LOd558NDXGP8xSZrdj8R/c0ZRNvmNK7C7bEiAOJIR8nqv236r/JX85Iob6HCurrChWhY7rgERqQMijHSz4scLzntK+8gkMDTOusL5PlnlZoe+fN16vYvowB9LOgGFczNmmozapgOWLsmpfmG/WGx6iJMMFKGHgvgyNydGGKKFLodOVnpxRJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dmHaMmY8QqHZFjcNokYXasT/rzC5ura1bO7Cd+LWcYQ=;
 b=QZAtXImYBg06h4XgxlZXzDnq9SvdIW9MpNdbdZkuVGBQ4j38FU6qBkmPhlCRWScFE8E7EEuuMR1Hs4kucFWzVHO0ZJp5nRd29pEJKh0532yVKVhmShJkxRuqBSDLCxwIKrI6EOSSmTiA/KuYP4D0ZVA1IR6o+vc7W32+/Fc2evAf+Xw4hoV/1DWDb9AEDhS/MtJ/b4A3jIdG3uTFscl1J3DXecrelsOehe89KBvJPtQvdTniJFmrviDBdySExHx45q1jR2aZ3HhsyVB6dtymTIjtyApw7Oy8N6eaLef1++PDaPDkHKfc8YvbAm5SKoXguDc0+7F11Nl3cmhiYL+q+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmHaMmY8QqHZFjcNokYXasT/rzC5ura1bO7Cd+LWcYQ=;
 b=irYoaUH4lhEufBk+QKM4fc4DVCjSj4nza6V8BYd0EsduLfUNSiHKRRLntJUTlDLD01YkV5NCpr1yvlM5pzTPp31/KVr9b56Zg0HGvqHMKuXK1LIBYj01oBD4Hld3hElfi/sEVYyMzeOTjv9CYaFcipkjHaqFv/ycQ6YQlhAzmiY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 MN2PR12MB4160.namprd12.prod.outlook.com (2603:10b6:208:19a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Mon, 9 Jun
 2025 06:39:42 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::17e6:16c7:6bc1:26fb%3]) with mapi id 15.20.8792.034; Mon, 9 Jun 2025
 06:39:41 +0000
Message-ID: <4f28e3bf-cbe1-42ce-b7f2-5cff86e635b7@amd.com>
Date: Mon, 9 Jun 2025 12:09:35 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm: preemption must be disabled when calling
 smp_call_function_many
To: Salah Triki <salah.triki@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <aEQW81I9kO5-eyrg@pc>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <aEQW81I9kO5-eyrg@pc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e8::14) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|MN2PR12MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: b479361c-fb8d-4095-2ba6-08dda72069b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NHFoQnoxZmpiUVRpMG1kN1ZLNG5oa3BPd3N2L3ZveWNycmlGdlU5Zk9FUGVq?=
 =?utf-8?B?cEdOMjhaNW5wSDBoS2hJWWVkakFtbnJNbTk0K25ZdVR0V05FcHE2anlyLzN5?=
 =?utf-8?B?U3JvZ0RqUkgwdHVGSjlnUUFyalg3d1U4U0ZoWFluTllLbXZHWjRpOGRXYjBn?=
 =?utf-8?B?aUJOZDVpSXBaZ09vR1hHa05uUUhtdnZaeXZoeUVGVjcyeGVoZW9ZM2J4Z2VX?=
 =?utf-8?B?TytuK0c2RVFHNmNTSHNkclBiQ3dBdzh5dko0aFBYYnhsQVdwMURRUnhpZFdF?=
 =?utf-8?B?RUNiQ3NHUyt0bmUwRVFvblF5S3AwdXdDMzVNV241OWJMalozMkFEeVJzTjY3?=
 =?utf-8?B?T0hldlhVR3ZOWkJMWUU5VllmL2hiajY4VkV2NVk1eUFkQUszNzVncWR1V2s2?=
 =?utf-8?B?QXowV05vNlRtOTJ5ajhLa2tta28vNnNSazJSVG1Ud0YveU1VVjFXQUFlUUU5?=
 =?utf-8?B?RUZNcS9MRWRHcFh6WVh0Wk5DOGVNM1dJSEdXeXR3SzBCa2NpbGRSMldxSDFq?=
 =?utf-8?B?cHFqZVg3S29FMHZEV2t5dS94MW5JY29ZQUtmZzUrWGFIZm9jeDlydjcvVi9w?=
 =?utf-8?B?WklWZFF2VjBCS1NxNmpqazFTRU5teWxvb1BTK1U3bzRLUUd5aWttYm45RTZC?=
 =?utf-8?B?dDg5c0VxUVB4c0x1S0gvdkY5ZEorTlBuQ3ZOUWhTRzBHRjUveEdWWG5zd2NB?=
 =?utf-8?B?dlR2cUgvNSsrbGZ4ck9IYVo3L0wvY3ZaZGRXVG5DcDh4N0FhSnBEc3pkdFp1?=
 =?utf-8?B?L3REeTJEbU9meHMxSytWdDVPUFhpandUaVhUTFdWVitPSVNEelR1WUF3VmxF?=
 =?utf-8?B?YXVpa3ZzNU4xWVI2R3dKVHV5WHVYQ3hDaEVCc2pFWjNlNDRjVDF3bHdlZVpm?=
 =?utf-8?B?aythKzhPQVcvRjFxV0YwOXU0a2xoa0RwRGZmNGg0NVRqL2YyWlRkMjJySDJ0?=
 =?utf-8?B?aHVKam5obmJXb200dEdHL2tjcEsreXMrVnExaHlveEVUWFZsRGRSSFNNOU1M?=
 =?utf-8?B?ZHpQbFl5QjI2S2pHLzNlVnhtNEkyWmJ0a0NzL0tXU0R1c2RzSHpWU0FHaXNI?=
 =?utf-8?B?VWwyZkpIeHp5V01IMDVwaTRHNTBpWGdMbXEzM3c2Z0I2SU0yVVpPRm9pTHZp?=
 =?utf-8?B?UVRvd3JsaThCeU4vY1dXdW9JOFh5a3lQekFFNzR1WGhock1LRVdCdmF5OGtN?=
 =?utf-8?B?MFBhUTR1UmpCbXhaQmpqSzh4SEk2UW5ZczVmdlk0eWtRSFZBT3lFNkJlZUM1?=
 =?utf-8?B?ZHlYOWo5MmljWVNXdFNpT0tVSlpWaDlwekgrbkgyQ1BIMVhZa3hPUVpXTC9P?=
 =?utf-8?B?Q1ZUQXowVVR0VS9kZEdPZ2NpZ2VieDBoSVBoNUFTVW1NdEtpeWE2NUZTdHhL?=
 =?utf-8?B?T3R0anBiTDRyQVJCM2N0WVRyZE1TZ2F6b3R2WUZ6VUhwVUdKcHF5Q3BHUFJm?=
 =?utf-8?B?V05kaW1naVdhV3prQ3prRGpyMjE2dDVoR0lac2lLeUtUd3ZuRVdXcTE2UGFi?=
 =?utf-8?B?K2w5c1VMZzRmY0xmL0M2Sy9xdWZneHFIMVJoY2I5VndDdTBNQTFOaGhOcW9x?=
 =?utf-8?B?RGhMN0ZkbHlXYTNrR2g1ZWRBWWJDV2pGSXk5bldMcFRSS3paNnMwaE8wMjMr?=
 =?utf-8?B?VU5NclR1ZkJiR2RCT01KckN3blI2UWNyTkpCRE1WeHJDL0Nqd29qbG9sUDhl?=
 =?utf-8?B?Q0hIczYxTEdsMm12YmNHZFRnenVRNVBvaHlZeGloeDlQTWR1WHhCakw3L1Rr?=
 =?utf-8?B?M3BwUHZWbkltM0ZJdjhqNlpKZmhsMTNPUG5TQzFPR0YxdWQyS05mMDlhaWw5?=
 =?utf-8?B?eFh4ZlczMEkraGlIN3ltRnMxN2J5RTNpcnVQV0YrSldjVE9xVUw1YnFQOVBt?=
 =?utf-8?B?cE5CL1daUGVibWxjNHVxM2VmMG5zM3Y4cFZIU1o5UzAvZm02enpYK2NDbzZF?=
 =?utf-8?Q?sBRi1NjXEeo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1p0aTdSb2dRTGlRem1ZZTJ0WGk5aGpFb2hpL0QyU2VwNGpLUHV3R0lqNXBK?=
 =?utf-8?B?dzYySUFrbXJjRkRlaEJhU25WSWpzN2JWRFAveHRndmUydFU5Uys3cVRpaDNC?=
 =?utf-8?B?SVQvMzRFVUp0SXRBTEg1bUZtclZLNExvS0NCSWlDOGZJM0FYRnR6RG5aS0lh?=
 =?utf-8?B?akVVa3pBZ1lKSlYxWXU2RTZ6UEpkYkRWYUpGbE9VR242OFBoRmZFL3dveXRk?=
 =?utf-8?B?Z0k5dFZrc2NqRHFJREZjcEpkaWo3REtYeXUrUitFRUFvWldZekxtMlpFTWhE?=
 =?utf-8?B?Z3NoeEhhN3JXNnk3b3BoK2FlRU1GSHRFZWhCa25EMVJmN0s3NXJlVWl3eThk?=
 =?utf-8?B?cXh5K1Bxd2xNVEhOVE1CKzAzTkJqcmRlbG8xYXdwTFM4QmFaU3p6Zk10Q29H?=
 =?utf-8?B?a2hRcXdCSHJmcmpkM2l3b3NsbE85SmI1Y1RuSEQyNEhmKzFtY0Q2azhJZjNy?=
 =?utf-8?B?d2xmeWUxMEdPWW9TZjJWVWxLQng3SEdyUGgrcHlLTENRbkhvRjVxRzVzaUZa?=
 =?utf-8?B?R25rdktoVDNZTVdDQ2lMV0FtdlNwS1l3WXdHM3IxTW9pVnVJVzlqbS9SR3RF?=
 =?utf-8?B?SWg0eWJpd0VqLzNpSWc2THBDSVFJOXhZTFAyaUVVVzFCNHZXQklLZWVBVFJ6?=
 =?utf-8?B?L3dhaHVidi9WendUL0hLbTlUS2F6ZWtHNFZTWkhWWnh5TTJqMGJIZU84c1I0?=
 =?utf-8?B?OVd1b205aE1jSWlZUFltbGM5VHpaL2dGckQ0azhQdkR3c0FGeTE4dVlOSXZY?=
 =?utf-8?B?dmppQUZJN0RGdW9JRkVMUkx4TEdQZ0F3akxiTjFxYm4zRUZqVFhiM2t3N09S?=
 =?utf-8?B?OXYxU2YzOTF0ZTBhb3liUngvN09hQmVCTWFpcXlhbFIybXcwY1BqenZMUVU4?=
 =?utf-8?B?K2lPWnhFL1RqTDg5T1N2OXFLWWpocmJESnVhN1NwTysyeTNKSzUybURsb0J0?=
 =?utf-8?B?RmlJdTNCaldMbzArWW9hTGFRcEtoVXRPdEpJR3dKeHljbGVidVNKM0wwTnll?=
 =?utf-8?B?cmRXMGRUdkkva0pSQUNkQ2ljd21UbjhPcG52Vjhkc0VWR1dlMzVMMHFaYkNN?=
 =?utf-8?B?M3NvNU1KckFHY0E1VlJYRit3TFJDeDUzdXkyR25icGZkRTBUdjI2d0dKaFdQ?=
 =?utf-8?B?bVl3NHRYaFd1WC9zU3JTc2RqTUtnSENueFNCT2xyaFN0dVpNQXJUaERSNTNk?=
 =?utf-8?B?dWRXY1R4WnVjY2hsMDhXNVJ2YTRualVxMTRpcUhuTG92ejc5bHVBb0o5VGJl?=
 =?utf-8?B?L1lDbFh4SG83OGU0eUdqUitFZ2xOUTVkelAzaHB2eG96TCtpam15V2dyeGVx?=
 =?utf-8?B?amxESXR0ZHZrb0JEazhFN3lpV3FVa2F6UGdqZDY0UnIxc3p3SnJNWE5ySW84?=
 =?utf-8?B?SXc3UWxNd1ZRUTZoSG1mVGlqcWU2bUxLTk5ma1JxRk16R3psVUVvSHFVTCs0?=
 =?utf-8?B?eEJpbm5MOHIwK2Z5dGpCUGhndGg5dnEyM09lRFJmUzl6R0MrS3FsWHdWK0pZ?=
 =?utf-8?B?MXExeElvVkY3WStiSThmZVNBSGFrR2ZuYUZqNkpucmpCYXJpUUhtMk50MXVQ?=
 =?utf-8?B?TFBNTXhIMVRJTkZ4MitOMEJGaFhUWWFSODByb0ErTm15M2s2ZndoN2FnZGNV?=
 =?utf-8?B?TU9yeG9zS1hEVE04V1B6UUJkY2VxYkZ3YW9ObmxjeThLM2dncmtWWTZPRGFj?=
 =?utf-8?B?clJQQWdTcTV2VzFXelRIdXNHS3VHejczTlJmT2t3a291N0V2VWdJaW94c0Zi?=
 =?utf-8?B?SzFLSFZ4S2k3Q3NnR3E0aE5lQVdJdmdWZDYwSldGU2JZb0E2N1BrVmlaREtt?=
 =?utf-8?B?eitIVk5qSitoWXZxcThvS1VGODMxVVZnNEFvU2htZGtIaXRIUWF5bUZzV1h6?=
 =?utf-8?B?NzhFME5QWmMybHQ1NlZrcTdlSzYvdmVCUzZORjNuWmFrbHduYU1IN1VQKzhN?=
 =?utf-8?B?N3lSN1JTalJ5b2Q3cWVEVzk2MWs0cGMzMncybUFTclp1aSt5SVllUk4xb0g1?=
 =?utf-8?B?RzROaEpneDdzMUIvREhzVWQyb1A2aEpRYlBMbnB4NjVmNjZBQXpsbFNLY2V1?=
 =?utf-8?B?bDNDblhRTzJBSDBYZXhQdml6RUR6WFNXSXhJZHk0T3JtVkpjY05iRW82VU0r?=
 =?utf-8?Q?A1vSPSixskBJMMImhBJFPyQV5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b479361c-fb8d-4095-2ba6-08dda72069b3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 06:39:41.5222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKUhkVPOZ7Gla6IF5Z+T3y4ZVVhqBc4aGZOZnArrR5/XuG5Z0GhhzHh4qtcUFs4u41QQ5bmZGGeBFeY+b475QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4160

On 6/7/2025 4:09 PM, Salah Triki wrote:
> {Disable, Enable} preemption {before, after} calling
> smp_call_function_many().
> 
> Signed-off-by: Salah Triki <salah.triki@gmail.com>
> ---
>  virt/kvm/kvm_main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index eec82775c5bf..ab9593943846 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -209,7 +209,10 @@ static inline bool kvm_kick_many_cpus(struct cpumask *cpus, bool wait)
>  	if (cpumask_empty(cpus))
>  		return false;
>  
> +	preempt_disable();
>  	smp_call_function_many(cpus, ack_kick, NULL, wait);
> +	preempt_enable();
> +
>  	return true;
>  }
>  

Hi Salah,

I noticed that kvm_kick_many_cpus() is only invoked from two locations (from 
kvm_make_vcpus_request_mask() and kvm_make_all_cpus_request(), and in both cases, get_cpu() is
called prior to kvm_kick_many_cpus(), with a corresponding put_cpu() afterward. Since get_cpu()
disables preemption and put_cpu() re-enables it, preemption is already disabled during the
execution of kvm_kick_many_cpus().

Given that, could you clarify the motivation behind explicitly adding preempt_disable() and
preempt_enable() within kvm_kick_many_cpus()?

-Manali

