Return-Path: <kvm+bounces-37539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E58BEA2B4C5
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 23:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 44EB87A5964
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 22:05:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50F30239567;
	Thu,  6 Feb 2025 22:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sbJfiLCR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C691F22FF5D;
	Thu,  6 Feb 2025 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738879530; cv=fail; b=be2qk/sx0XNjq2S4wdXwyGZN/0z0vPWcmzm8z0SHqFQJ4t5yd2ieRtc8iHat4+ToMzETFbmTnoWGYFxFDJGlmbWf5KipM2l1xjj4IhCpGznHtSQhaau5sxaAfJ6huCw7F1SND0KAroBwsntWt6E6ObpasLJckYIG9mw1czUoc/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738879530; c=relaxed/simple;
	bh=D2SJ5OhQ9jcaqVHMS39EHLFREBxkLwVgxKMGXQzzDlg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jp/5x3p62Nr8PlV9utPrbwBGKJRDsK8iQMbcrpI8Dc2BXd0IomgZTaiEMbTETkbYYvHXOO58D2kNSkgaqclt94cJJbu46nXPgVKW5VL1AH1HEFKOJ/cYma1Tny4V1IiNZ8v2Iw1Pu7qMPfBGQDYR/V7kgnok4sI3vjHLLDXbZms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sbJfiLCR; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pM/B+5GXjzU5bELEyQezV/OeKzGy6q6bdo5Cp2PRgir4mWzj2RWl4k4fdjYXiswzIYDidNtKw0bFpji4k0rCQlUZi4HU/v2RDraOZj0obuhOSpUTiLTVvYHkzLp+c3TmsUqB9zyu3BxQQ76cLw60LqyYtvlplTHwWHYmbG4kwKRssooBCg0WcQKzrZGNfczkZGdre1kX1wgoj3THzjAyBhLWtszdhdojQrdCoYao3Wo3DpwUf9wEDgqZac4fgxJnY0uJ1xkbR5BZRcaYqZYoeAsuf3XRzp796JvMxvlWQ2K7Kt8gldQ+YXXD0k2doYYZWqrlivRsUcZSdV1mh7HPGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3SMswaJdqej7UXJBi+08WPkYJFhhCmYu3oATSu/6aNQ=;
 b=Kp0clCs2f7ZHfRYhdCqAODelL7l9rO/AWWqfUxjXiMBFTeLLynl9pDMVD8tYwyiXysXE2LWFCa2yWFXJRdhOK/niny6D9JtfPqvhOVn4X/n6Jk6TjilgaLheheLmurKPayztWYYU3tx+isjzmUmMbmq3HhSJ54Jb0cyNzAfYsA5fvZUgj62iOoU+VipF7mdZ5q1JpGqEWplvwX6kw4KzoziG/rOAu1l7hlpFt+PydRGBzHgI+YZubg68cOi5Xnyt+gfUmpqxP5BLERjSc11ljpHLYRjIO/VLOzb5Zdmp4Gpjj8f6hjTzbJWWFci+HoQ8RyqF+5ejiF8UvvK5e0voOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SMswaJdqej7UXJBi+08WPkYJFhhCmYu3oATSu/6aNQ=;
 b=sbJfiLCRJKyqUqrTkzaxeYo+r+h8FR5+HKu20iqdkyNkXwKNgxCvzel7b4d/HiFwbD4lfglpoGXFNEjEkyyubXVYFtuqCv06UB0tumIgE+Y61IqVIlKAIo6yVnmlqF9XgZ7Rm9DMlS7KqZ78yhBcedQ8kB2OpvfKbT4lFUSHU4U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB7006.namprd12.prod.outlook.com (2603:10b6:a03:486::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8422.11; Thu, 6 Feb
 2025 22:05:27 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8422.012; Thu, 6 Feb 2025
 22:05:27 +0000
Message-ID: <fce6d203-6822-7bb6-ca9b-4427d0772312@amd.com>
Date: Thu, 6 Feb 2025 16:05:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v7 3/3] KVM: SVM: Flush cache only on CPUs running SEV
 guest
Content-Language: en-US
To: Zheyun Shen <szy0127@sjtu.edu.cn>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, kevinloughlin@google.com,
 mingo@redhat.com, bp@alien8.de
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250128015345.7929-1-szy0127@sjtu.edu.cn>
 <20250128015345.7929-4-szy0127@sjtu.edu.cn>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250128015345.7929-4-szy0127@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0041.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB7006:EE_
X-MS-Office365-Filtering-Correlation-Id: 071fd302-a49c-4ee6-5155-08dd46fa5cb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WjByY1ArZEdxWTVNZWNaY1lRTEx4UHE0aXFJVnFEYnNXaklDNW9OVy9pVStR?=
 =?utf-8?B?NUUvK0hNbkhMbGUwRHBSQ052TFBsL0Q4K1FpRFVCc01tTU5XN1RHZSszZ09R?=
 =?utf-8?B?UWxSdTBPdUNoV1hSUmY4NXdjZTlOMjdqMGkyVGlmbGZrYTNmSUh4MWFKUXNZ?=
 =?utf-8?B?Mm8wdDUwMjBidW03bFRXcHl5N3NLcUpNa2dmbWtsNG5ZYmpLUFVIZXhXc1Rl?=
 =?utf-8?B?dHpwZ2ljUDZlSEVRemQ0VzBpWFA4L2UyUTZpVEV5aE90dENTL2YvWUswUDRC?=
 =?utf-8?B?dkZxYld3QVBOV3lBenhpeXpKMjI2VERlTG5CUnZuS1RxalBJV00wRitHVlh6?=
 =?utf-8?B?dnUxN3hKSlUrTWVrcEM4WnYrMW5SM1EzTjRDV1NrZ2FMV2ZTSUV5NVNuVk9v?=
 =?utf-8?B?SFFVam5rcmJpTWE3OWl6OG15TWdmNTl4YlJaVlFGM29SSEc5T016cDVjQVNJ?=
 =?utf-8?B?dkVNREpNekl1RW9uWXpNZjh2V3lZSDdQUFZLU1VNd3pIYlVWc1BwU1JWUlVQ?=
 =?utf-8?B?VHRSNmp1NWxxcCt3RGl6RUtIclI4QmtjMTc0ekJLZWlJa0hUVVgvbGFzc01s?=
 =?utf-8?B?SitRZUFDL3FibTcyUlV1b3RFS09kYnJYTnJUL0hMbkxFbzF6ekNhSW9jTmhO?=
 =?utf-8?B?dkw2Z25ETFJhRVZwYXg3TjVFazVZc2pmdjhxN3pZcGFrNkxQZEErYXErMmxQ?=
 =?utf-8?B?Y2tKaiszZU84a3V1bTNLQjBiTU5LQUZNUTdMc1lRTkg4WkIvaVFkWWQ2Tm12?=
 =?utf-8?B?WTRXVktsMmp4eXBTNHRWRTJ3ZGZjNG5pNW9uMUNOdVJmZzBNN1J3QnlHVHhy?=
 =?utf-8?B?S05RS2d4YWpPV2dacGhNYjliZkpnclVubzMyRFVwdThERWdDdXJ6eSs4a21M?=
 =?utf-8?B?UUx0cTZ0MlJsR255RTE4Q1dTWE9pNnNHcjV3WjVLSDUrTXZxRFpvcHJjd0Jn?=
 =?utf-8?B?OUpnQ29uT2RTa3dDekZhdExncG5ZVHg1STNTMWdvQVFCV3E2MkwreTgydExD?=
 =?utf-8?B?L2VhS3NzZVk1OXhMMWlwM1NYL0dkeldnOHU0NWx6VzFHak9kcUo2NHRvRk0z?=
 =?utf-8?B?Vkszc1hnOERWTlhQZm93MkVnTGtmcG9LWUQ4VW42UFgxOVZZR21qSDJDYkM0?=
 =?utf-8?B?d1Q0Y3BoTTgydjZibFFSUHYyWkU5OVdkUXRLdVB3NnZmcUxwdkdxYVFzMHdN?=
 =?utf-8?B?MlNZMnlPdHFwM1pveXdlcUNNWm9US09kRFlMYStWVXpSY0lQeHFEbU5BOVE4?=
 =?utf-8?B?cmdCdzBScjUyWWU0VjRDU2VzekhyY1hYQjNSejZVZUFZTUZYMEtOU01FTHUz?=
 =?utf-8?B?RVk3aitEMGt3VlhPSTJvNndQazJzRENVaXpGdFBld2FPL2FDUCthdmVrbC92?=
 =?utf-8?B?RDZVa2l6d0FRRDFYVmVzT3Eyc0pVSUZEeVlNS2E5N0JrR1d5UWZRU0VNN2VH?=
 =?utf-8?B?VDMyRFRRelZKUEFZV0M2M2FQZ3lwR2tPUTJjMWxnYjMvVVZCV1FuTkNQZndw?=
 =?utf-8?B?cXRaNlpjYWUrS1BVMTFXZVBla3dQWHR6enNidHptdHVPR05tTEF2UTdRNXU4?=
 =?utf-8?B?VGhYeXMvR0FaK1AvODdLWGxwclpQOUVUaHZkbWNnMTFBeldLaUdxL3dIcmNu?=
 =?utf-8?B?dWNXOHVoTmh2R3Era1AyYWFrSkJVeHJWeXJ2Vi9BUDVIZk5WQm15QndzMzZF?=
 =?utf-8?B?UW5pVkh5MVBsYjJGN21Qa0dWMWJjUHJ0M29ucFdmSVpzZEo2STdFUkE5K0Nk?=
 =?utf-8?B?ZE4xUm4vSjlvOXZsdHJsdmRJaVZYRW9raG1VZ2RFYkFHbEhPdjZSa0g3NjlK?=
 =?utf-8?B?TnBYYWZJOTdvcVI0OFV2YXNzemRoamhGUk1NOWlhQ1hXcUdWNTBnTk1EZitm?=
 =?utf-8?Q?2Z1dYcaL66Qmq?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TWFLS3FaVGx2K2lBVE9qRmNkcU1hNkxpRm1uSFlwT0RCWWdHMHdDQk45OWs1?=
 =?utf-8?B?SDNEV2kvZno3ZzRYbHlpNGR3ZUc2RTZCM1ArMUpHb0VQTTFFTkpYcEVkK3N4?=
 =?utf-8?B?TTJUR0hKeEpMaW9OMzJOcjhaMCs1dWRtNmhxQlpvNm9Ec09ncnllMDB0akN4?=
 =?utf-8?B?dTcvNE1uZmhscGlHWjQ3dkdLS1ZYb2NVQUpxZHFmZ0Zuc1RrbSsyb3VZUTNo?=
 =?utf-8?B?MDVYcVR5L0VHdGJTTVBWSlFja3BZLzBlM1MxUWttR1JDUGRhVksxY2xuWjhP?=
 =?utf-8?B?YzJteTI1QzVDMTFIb3EvTkZGVkE0S2dnOGVXaEFKcmJpa0Q4QVoyOHBRYkt0?=
 =?utf-8?B?QWJuL0REVXFSYzZUekVTcHB0aTNCZmY5TVcwRG9USUgwUFhRaXZ6SzNTVzdr?=
 =?utf-8?B?d1k0WlhiZllZYUk4M09ZOFNseUhzMUU3WVFoaXo5WHo5KzlsRXlHbjRtdStW?=
 =?utf-8?B?K3VzOTlENmVlakZaOGIrWlVQTTVlUjZRRGtNNXFpcGJFczhJSG9HWmdGTjMv?=
 =?utf-8?B?ZmFrS0lGbThpZWpFYnc4RlhvTFZXTGh1VnpKR0lwSG8weEdBTmFEVS81ZHlV?=
 =?utf-8?B?NGpOOEMxWk55N1JpRnNKNEEyOVlsaVBCRnFPMlNQbnozbmFlNEhjUWt2dHox?=
 =?utf-8?B?K0g1YnowNDRaVmQ5Wjl3WUV2TXBJY2FCeWY4V01ORFJ6bm9zOVVyL3RXUCti?=
 =?utf-8?B?VkM3UVRLOTNxUUkrbzJpZmxzaEYvN0JkMTMzaEpicmxoM3pydnhJUUhBcTd5?=
 =?utf-8?B?TXRERGQvU1hFODRJVW1oVjBneVg1VnZDZVpHWnBBRU0xR2tWaUF3QXpWZS8w?=
 =?utf-8?B?YndUczFKUFpESUJiZThRUnF6aTlEdmMwQ3BDWVdzQ1ZibUVTWjJmeHJFazZy?=
 =?utf-8?B?N0pBdFZ6NzVidGRxSTJDNXFaU2lIT2VyOXM0SFdtWCs1a04wQWlNVytqdkZk?=
 =?utf-8?B?dE8zL3pzZ3I2QU5paGlnRHZZdnhBSVR5My93ZTQ5aWY5NEdkM09MRkRQSHE2?=
 =?utf-8?B?eVVEaWdHVVF0NmdYajRSbkF2STV4dCtveVFETjZTRDYxMjl1akdLQzFGV2Y0?=
 =?utf-8?B?T3FBUTExSE45UGlNcnNNRE9kWFNzWThMS2xyMlE0RU1GZHZOdjdZSXROR1Aw?=
 =?utf-8?B?eDBqS09UVkY1cVd5RlZ0cjZnd0tLOGtsa3JscGp0MEp4WWJlcTI0V0ZnNGR4?=
 =?utf-8?B?ZEhseU0vR3pIdjVvWThNZTEvODU4Q05rNWY1NEVGMzVQUEV1WXB1NXpwVkRm?=
 =?utf-8?B?eldVZjFub3k5aEVna3Y0SnZBMmtTZTBEOTJWcGZ6MHUyQzFhdzZjU2hvOUJv?=
 =?utf-8?B?Tm8yZjFkY1YzT0hUamJWRUpuTVdXZ1hRWTFFYjB0U1RSalVCbjlNZGdldlVL?=
 =?utf-8?B?ZE4xN2ZhQVI1SDJUdDUrSVdoL2t2aEZ4bmxFeXRSQlRVRE9qc2l2MGg2MTN2?=
 =?utf-8?B?MmRQT3g0REJDOGZsQVBJZkJhRDRCVUJKL044amZVZHQzaTVCa2I1TUJCTEVh?=
 =?utf-8?B?a0dkUytBSHVwcE1BcmQvbk5wYnZCekhQWW8xZytXQXJrUEg5T0FzK1Y4aXRI?=
 =?utf-8?B?WE93RXdVK05Jb3hWcXpIbW5scWw4T3pKM0xDNG9WMEhTdW5NQitPekZORU9Z?=
 =?utf-8?B?MS9jdkJhdVQ3NHVsbnJSajFEYVRZa3pTQlBZQ0Q1Y055dXplTEJEU0k1RUkx?=
 =?utf-8?B?MWlMQW5DbUczMFdmUGhKL2l3RWRlYWdtOHFUQVNpWEcza1p4WXNPVUZxSXBN?=
 =?utf-8?B?OGxUWkMzSVArTDJkZ1B4cEJpZnZ4ZjB0bXRuUjFwdGp4ek02ZUxPM3IyaUM2?=
 =?utf-8?B?NHdHbTZSdWxZdFRtaFM2RkxqbWdkaEJpNnFzNmNtam1YYjl0NENOQnowSUxM?=
 =?utf-8?B?bmpIek92SHY2NnlCY3F6SXpFakh2ZXA4aU1Cc1dhVHY1V1hFektrZXdVWmFW?=
 =?utf-8?B?RVMrTEl3eWdwa2VlQmxQTDNSOWVLK0ZSV0diVkFLSzlMVldqcXpxMW9Ccy8z?=
 =?utf-8?B?NStqRnlKMU1CSFY0OEJ0c0NDTWVVOVNkd1U2NTY1Y1JmUGJkVW5FS2U4c2xs?=
 =?utf-8?B?N2tCOWJkY1lwUTM2amJKMXVtRGN4YkxoNFBRYmpjTGl5VzhYTTh3bnk2Z3RO?=
 =?utf-8?Q?hLtSDrHBVFyhuaYwRD8SwAD14?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 071fd302-a49c-4ee6-5155-08dd46fa5cb1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2025 22:05:26.9634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fj4qPPeNyuPD2GFb2BY+KEIimUWog9vCfGz+CPa7gXFGp5+/w5+8X/vBxlrJsmd/qJ2cVUGz7klhKUAC/9cMjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7006

On 1/27/25 19:53, Zheyun Shen wrote:
> On AMD CPUs without ensuring cache consistency, each memory page
> reclamation in an SEV guest triggers a call to wbinvd_on_all_cpus(),
> thereby affecting the performance of other programs on the host.
> 
> Typically, an AMD server may have 128 cores or more, while the SEV guest
> might only utilize 8 of these cores. Meanwhile, host can use qemu-affinity
> to bind these 8 vCPUs to specific physical CPUs.
> 
> Therefore, keeping a record of the physical core numbers each time a vCPU
> runs can help avoid flushing the cache for all CPUs every time.
> 
> Signed-off-by: Zheyun Shen <szy0127@sjtu.edu.cn>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/kvm/svm/sev.c | 30 +++++++++++++++++++++++++++---
>  arch/x86/kvm/svm/svm.c |  2 ++
>  arch/x86/kvm/svm/svm.h |  5 ++++-
>  3 files changed, 33 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 1ce67de9d..4b80ecbe7 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -252,6 +252,27 @@ static void sev_asid_free(struct kvm_sev_info *sev)
>  	sev->misc_cg = NULL;
>  }
>  
> +void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	/*
> +	 * To optimize cache flushes when memory is reclaimed from an SEV VM,
> +	 * track physical CPUs that enter the guest for SEV VMs and thus can
> +	 * have encrypted, dirty data in the cache, and flush caches only for
> +	 * CPUs that have entered the guest.
> +	 */
> +	cpumask_set_cpu(cpu, to_kvm_sev_info(vcpu->kvm)->wbinvd_dirty_mask);
> +}
> +
> +static void sev_do_wbinvd(struct kvm *kvm)
> +{
> +	/*
> +	 * TODO: Clear CPUs from the bitmap prior to flushing.  Doing so
> +	 * requires serializing multiple calls and having CPUs mark themselves
> +	 * "dirty" if they are currently running a vCPU for the VM.
> +	 */
> +	wbinvd_on_many_cpus(to_kvm_sev_info(kvm)->wbinvd_dirty_mask);
> +}
> +
>  static void sev_decommission(unsigned int handle)
>  {
>  	struct sev_data_decommission decommission;
> @@ -448,6 +469,8 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
>  	ret = sev_platform_init(&init_args);
>  	if (ret)
>  		goto e_free;
> +	if (!zalloc_cpumask_var(&sev->wbinvd_dirty_mask, GFP_KERNEL_ACCOUNT))
> +		goto e_free;
>  
>  	/* This needs to happen after SEV/SNP firmware initialization. */
>  	if (vm_type == KVM_X86_SNP_VM) {
> @@ -2778,7 +2801,7 @@ int sev_mem_enc_unregister_region(struct kvm *kvm,
>  	 * releasing the pages back to the system for use. CLFLUSH will
>  	 * not do this, so issue a WBINVD.
>  	 */
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(kvm);
>  
>  	__unregister_enc_region_locked(kvm, region);
>  
> @@ -2926,6 +2949,7 @@ void sev_vm_destroy(struct kvm *kvm)
>  	}
>  
>  	sev_asid_free(sev);
> +	free_cpumask_var(sev->wbinvd_dirty_mask);
>  }
>  
>  void __init sev_set_cpu_caps(void)
> @@ -3129,7 +3153,7 @@ static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
>  	return;
>  
>  do_wbinvd:
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(vcpu->kvm);
>  }
>  
>  void sev_guest_memory_reclaimed(struct kvm *kvm)
> @@ -3143,7 +3167,7 @@ void sev_guest_memory_reclaimed(struct kvm *kvm)
>  	if (!sev_guest(kvm) || sev_snp_guest(kvm))
>  		return;
>  
> -	wbinvd_on_all_cpus();
> +	sev_do_wbinvd(kvm);
>  }
>  
>  void sev_free_vcpu(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dd15cc635..f3b03b0d8 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1565,6 +1565,8 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	}
>  	if (kvm_vcpu_apicv_active(vcpu))
>  		avic_vcpu_load(vcpu, cpu);
> +	if (sev_guest(vcpu->kvm))
> +		sev_vcpu_load(vcpu, cpu);
>  }
>  
>  static void svm_vcpu_put(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 43fa6a16e..82ec80cf4 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -112,6 +112,8 @@ struct kvm_sev_info {
>  	void *guest_req_buf;    /* Bounce buffer for SNP Guest Request input */
>  	void *guest_resp_buf;   /* Bounce buffer for SNP Guest Request output */
>  	struct mutex guest_req_mutex; /* Must acquire before using bounce buffers */
> +	/* CPUs invoked VMRUN call wbinvd after guest memory is reclaimed */
> +	struct cpumask *wbinvd_dirty_mask;
>  };
>  
>  struct kvm_svm {
> @@ -763,6 +765,7 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
>  int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
>  void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
>  int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
> +void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>  #else
>  static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>  {
> @@ -793,7 +796,7 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
>  {
>  	return 0;
>  }
> -
> +static inline void sev_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
>  #endif
>  
>  /* vmenter.S */

