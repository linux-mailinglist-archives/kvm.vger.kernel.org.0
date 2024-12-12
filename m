Return-Path: <kvm+bounces-33549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6FBE9EDEB0
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 06:08:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16585167856
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 05:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 725A217995E;
	Thu, 12 Dec 2024 05:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Akzz8KeD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188ED1DA4E;
	Thu, 12 Dec 2024 05:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733980095; cv=fail; b=aLS/jAh0wFci2xGukoN3yBWtwbzMr87jcCqmg1wx8G7Bw26aA+y2Y1/IGnkpUEPgfWJIVlYtlg6Nm++UCEo0ZhCGUQFv6+1tVHJLt06fLzXsGvTeq5nVLo/c5vdFo3tn3GXPQ+egpFmouSRIaZ0TVb0kJPK1ZzYWwFvtgT6bKqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733980095; c=relaxed/simple;
	bh=ZmYNcaEtn1GezKjrnCiExNkitMS8WPemfcIOl1PE/YQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uaQxfeD1m4IjkWMUXLnWxb8VZPoJvptB85kFwa7FdcsB9X6dZxMCVRAbboZtvDzMxkYcUD4vqt7b0XqY/6gR9Aj+S2sm41o9jZmbY2yzzVz9BbpI0+UVSCDqr8A/vonAqD7ekkD9Z/3I1QJACt4NnW6mOo5MZkKuFdQ/eTyRX1o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Akzz8KeD; arc=fail smtp.client-ip=40.107.92.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7iENrtFQAmBA5mgNEu5hrw+AXxEqDxS6tr1jdvO5sMtgi2JmOs1zESMmgEF3Cg6qVYgvLXLI4CW/bxKFftlt9DxILMSoDGtJRsYTM4q4IYUbkKaGNkdVl1UJiyZBnUfznUiUtJY7KlvYxmBxUrTwVExPqWSYeliGqM4I65rSWHX1A3DLGHG4s5i4PrLJn9E6/tbjagCMJCmLnSIwrHNROwf4scB2ZRmeZYAX9u6M8ez4x7PT1HsU+Jur7cZnyU7gPKQxeGMWGAWPIcd50ZEwsBC7/6ZHZF7NNmzTuIaPo/pkV7ICdeLimuP4dC2wm1upFjDsVONjZIHfdDUXd2BTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egj3LIjI/5f32NYPFHGvkFjpCEFiZAfx/8ogqKJO2vU=;
 b=ok3QSx+dCIGOCjsmyE62/KGMw3PU7y3AKoQbXojV+0UPgYhcaOZqw4L2OjaJNSCdsr2t4si5sdRxOyAyWbwC2/jsYlvnvFMgGQOiYSyaZ9cdR8Gz47HOh6yHS8RtEc9CCMaSSJRjKYloiGlBB1NEajup5zQyn/ywUXNSvwRH9l51XtKeanA8Vhx8UHvAF/HuRlMQSlP31wr1Un9bQy8TKQADfJH+Aw9hGmGgc5+zcywlqWZQj0HWfqBvmS9JCR6/V1S7RnqGbZLDAZxE1TFHaUk9PT5wnAcoKPAjZDR4qvZ1utqtTk0jM8r+iXgGW1TQRkeOEI4Pyos8zBixnNtl4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egj3LIjI/5f32NYPFHGvkFjpCEFiZAfx/8ogqKJO2vU=;
 b=Akzz8KeDG6ri2z6IW8n1tNfXS2ZZf6LbvZ/o+Zpgq67g37R8VpaToKzg2LtsMZQEOL1bO5WvURdNKtKyORmpPfoKNZSku5WQEi2xPRyjGC2nx3v2C+uwOVlc1kyvAn1lrVI30NtNPdZfFctgBDpvQ0ILMConfkeSmpBA+8K/B+U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by DM4PR12MB6064.namprd12.prod.outlook.com (2603:10b6:8:af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.15; Thu, 12 Dec
 2024 05:08:11 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%3]) with mapi id 15.20.8251.015; Thu, 12 Dec 2024
 05:08:11 +0000
Message-ID: <bb4d34a7-e303-49c7-9bd9-3b97909e9ed2@amd.com>
Date: Thu, 12 Dec 2024 10:37:29 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 07/13] x86/sev: Mark Secure TSC as reliable
 clocksource
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-8-nikunj@amd.com>
 <20241211203214.GDZ1n2zvfqjYj4TpzB@fat_crate.local>
Content-Language: en-US
From: Nikunj A Dadhania <nikunj@amd.com>
In-Reply-To: <20241211203214.GDZ1n2zvfqjYj4TpzB@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PEPF000001A9.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::f) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|DM4PR12MB6064:EE_
X-MS-Office365-Filtering-Correlation-Id: 22697f59-1be9-4e1d-b6a6-08dd1a6ae7bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T052TDd6akhDUlRqWDBYUGlaQmZSZ3JTZ3FxRWhBSFlyaEQzckZFdlltOTBq?=
 =?utf-8?B?dFVPVE1KOTlITnJrSWNwb0JWUHF5cFRGb1EwcGZXRWszdHlWVktFTmFYTjc3?=
 =?utf-8?B?dWR4MnBJRWY5STI4RUFNaGlRNC9CS09xc3BUNVA1dzVMUjBpYmRMYXZIYzlC?=
 =?utf-8?B?ZFhNVDJtRE5PRUwwdi9GTGFpMDJJV2tJNE94c1g5bm5CT3JDK3lzOU5lOEhL?=
 =?utf-8?B?UWlTREo2NXVSNTMzeS8raWJQMFlEL2Q1M0lldHhFTFh1Yi9IUk9pd0VObGFL?=
 =?utf-8?B?NUVWQ1dKWkhNcmpTaDAwcHZYT1c2YWJQL1dqVzk0M203RXVJYkp4cXdtQzBt?=
 =?utf-8?B?b29IdHJhRGY2OUZ4bTdKMENML3hmSUFTVW1FaTlmZDhUY2F4LzUwV2dTTFht?=
 =?utf-8?B?TEFoajBId0dSLys5eDJoT1FpWmdkRFh0WFRHQ1h3VkNjcGJlWUgvM3BNZlUv?=
 =?utf-8?B?QnJ0WVJaTWhnalBiNDJJaklCNERwblM0TWhNMklFWXY1aFYrQkdSUlpGeTVp?=
 =?utf-8?B?c1o3LzRPZGlJRENQVkkyckhvUExhbnhORXFlbWNOR0tyazFxNXlOUjBtalhG?=
 =?utf-8?B?NU4xZ1RXMzNCMW9GZGo2OFhFUjdiY0JvVUxvSU56ZWpLcnlhWkZtbHpzblJM?=
 =?utf-8?B?cVNIbkp1dk9UUDFhU3NtSURnRkgwc0tWdis4VjZSZ1JzbUltc1JrSHlZbjhG?=
 =?utf-8?B?UjVSR1dHOWZ2YjVFVGhGZEQwNmFkYkZBVVVHREFpZTRxbURGcFI5N3U0L2Fu?=
 =?utf-8?B?ZC9qVDd0Uml1eS9aS0pYK1pRS09LMkh4VGE5RFREekJyZytkOVBLd3FIOWRt?=
 =?utf-8?B?K3pPaXJzZVliYWR6b0VwTXVPRDhwNVdYOXBVbGJiTnhQdWtkeHhXc2JUYkdN?=
 =?utf-8?B?M3ZyRGZ0Rk5CdkFzcklzYlBaZzN5WmFtVTlFZXp6N3dQUHpxZ1I1R01zVnVX?=
 =?utf-8?B?ZVJ5bXBwYXZsTjk5Vk9KM2o0S2xoL2s3NjhKQkRRaTE4eUxsUmV2MmdpdXkz?=
 =?utf-8?B?TTFhSkZ3bGJJNmJGeVFKYWdEalJZbVhpOUNvUHdKaFYxZ1Z0T1dvckpWZlVV?=
 =?utf-8?B?c3RnTkpNMmdjWDMyNTNIMlZWeDIxaHdmWVlRdDdCVFEzTHMwK0dZZEErRmtX?=
 =?utf-8?B?eVZJcitDNjAyVVl3VTg4YW5BTkFzWmMwaWF4Q291bnpON1Y4VVhDMHZKalJW?=
 =?utf-8?B?a3ZQMTRULzNmRFhISUNCQVE2TENqZTlUbk1RMGQvR01PYnBTYkt3ejV5UUV4?=
 =?utf-8?B?RTlSb0NYdFdnL3lRQVU0bXJEM205K2orZHpqa0tUVUNEMXlQaFBIWDBkMERB?=
 =?utf-8?B?RG1vWkVhZVRuQWVkMXQ0UXo2bUNTbnpRaWZhNndKeU1vd2pVRTI4MFV3TFFV?=
 =?utf-8?B?RHR4a2dlbWJnREIxcDNCV1BJZWtWUVZrZDJTdUJkRjlJNmNlOGszZlNvbHR0?=
 =?utf-8?B?M25QMkorNWhPeWhhOVNZMVk5RU1jazZqVHdwdzNWRUJ4K0I1SlR1a1Iwczdn?=
 =?utf-8?B?MWlOcWpyL0hnd3BRVnlPaExXYnFPSzhyUm1weDNtVHVOUHZ4RlFwVFNIaGxN?=
 =?utf-8?B?czRFWHZmS3FHb2hnK3ZDRENmdVI3RXFqZm5HWDQxT3podllrMmJweHdOUW81?=
 =?utf-8?B?Si9WbVEwQ2JMNENNbmV1ci9mYm8rR09EWTQ4QWowNlluaGM2eks0djhxUWt6?=
 =?utf-8?B?ODYrS2Z1RmVXY2NqdnliTjY2c1RXdWNxamd3bEl4M2pXblh4REhFcmRRdWNM?=
 =?utf-8?B?SjFRaXJrbUxwTHlNelZiRTBTeXJJc09tWVNYUVVHdDJHYzVCbEJNMEZ3RUpV?=
 =?utf-8?B?dHVSMTgxRFIramNxR0hiQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MU1mbWJGV21pSW9odnovclo1WXlVbjBQWktGNzZhdWp3NXUvdWVvU0o0dmE0?=
 =?utf-8?B?N0pUOS8zVGNNL05yVkhtbzdRRlBVTEV4RzNKSHhObzQvUStXdStobVVVK2dS?=
 =?utf-8?B?RGNhRnNodWs5VmI2MW1qUnUzWExLaDlMejNabld0a3plM2w3TVpOaDY1YWZC?=
 =?utf-8?B?U1gwK041dS8vc2pHYWhUbjRSdHNtU1djU3NLTXZhSmhBUmlrL05rT1MrN2VV?=
 =?utf-8?B?RlBGUFhoV09RRGR4NWFYM0xjVTZwZncyVzV6a2JaQnplekRrYmJCalB0TTAx?=
 =?utf-8?B?QmpweEJLSkd1VEg3Uk40bENUVUMxRW9sc3ZmK21zQ1pBK2JtZG9xK2pXS0c5?=
 =?utf-8?B?K3ptM3VjaEN4c0VHS0hvL05wMjJaYTJpVnZNVC9MQVBpa1FnTS9NZldHd3pD?=
 =?utf-8?B?SG5jeSs4R3BQemNrUndLUTMxa3liU2tnclRHNGxrY3pyOW5wbUVYQTBXMXBz?=
 =?utf-8?B?VHR1VXhOZlo5Vkg2T3FiVkVYd09XTG8xRHdSR0ZSQTJURXJ3SFExM1lkalk0?=
 =?utf-8?B?blNtbEZYVHBuZVRvV0JuYXlKWHEwL2dIS2NNdlNHMXpTVlZBZTFkL2UzMjdI?=
 =?utf-8?B?eE9YOVNXY3QwVWNNSDQyVGh0V2RLYXJsaGtROGRjMXYvRWFyVjJBNzhDRnpi?=
 =?utf-8?B?M01CYWh6Ym5pd2VrRHhzSVlHTThTM01jOGNtdkR4aWRocjN3aEl6akRackxO?=
 =?utf-8?B?VDRzOW9ycU5EVVNEbjBRYm54YmxHZWxQaVMwV216UWJReUFaaUZITlFTYndW?=
 =?utf-8?B?NU5pcVUyakFja2l3MjBKc3l4QVBqem5PY2xKcmxaRnFObUYzeWlWZmV1cUZE?=
 =?utf-8?B?YlNTQ1k2bWN2S0lNbUdWVS9SMDhvV2dsRHM4d201Ujk0Q3pqNm90OWVidFds?=
 =?utf-8?B?UmJydFg5YVFYVnlzcmZHalZKdUcwNjFFUGs1VEQvTDEvdXFpNkJ6L2x4ZGVO?=
 =?utf-8?B?Uzc3WkdPMXIrZWtjSUlIaktpcEpJTXJGZ2FQMkJPVEhuNmdPU2hLN3lCQ2pq?=
 =?utf-8?B?SFlSU3FySWl2cVhwdE1UWDdycWZJdTR3K3pWK1hESlZjOFNTWGdrU01mZ2wv?=
 =?utf-8?B?V1haYmRvUk04aE5lWDNadnU4c0NsKzVsVS94TG1scVd5cE5JNzNkZ1RSamx3?=
 =?utf-8?B?dEI4Vll2citxM3pLbE96UVM2U0VReHdnTkdnKzJ4eHQrUXVBYVJ1SGlIQ3cw?=
 =?utf-8?B?RytLSU9Gd3NZbHE4eVVCRWczcU5SK1B3Z3J2VE9HVHRQZWV5blJyR0JjcVI4?=
 =?utf-8?B?QmVaWEZ3RHZKeS9KVEZBTVpQTHpvRHRjeGZJVlBuUGhoVmxMZHZGUTBZeFZo?=
 =?utf-8?B?Y0IrRTZ4QmV6d2NIRmMxY3hlMHVoNjY3a24xUlBSdWdMUENxU3RJN1BiWFBq?=
 =?utf-8?B?aDVlYnlMdEhxY0ZZQzVGZ0ZyeHVqa2xaZXl0SnFRZkI0K3poV3BZRlJvSUFZ?=
 =?utf-8?B?ejExQSs2TGs2bVROL3I5c2FZd2dHckRIa3JGSGpMMG82RDM2bENJcGMrcHNR?=
 =?utf-8?B?aHdVTnoxdklzdEJhZ1hEa1FnSE8vUnkyTk9xZnJoMzBhaU0yZ3E4YnpsMUMy?=
 =?utf-8?B?K2JWbmtWNi9wdjdLemVMWGFJb1dtVDFTaUxzMUFjUjBZRGJ6TG5taHFnU1Jz?=
 =?utf-8?B?S3o5ak5zTHdKREEzZi9WZ1FpUzBmc2FRSHgrWlZ4RWJ4NGxPZDdhT1ZtV0dX?=
 =?utf-8?B?c0hLeUdud1lrVGVLbys2ZG80TzgyOVFwaW1vbGI1aWpZUWNMUWg1SXNEeFU3?=
 =?utf-8?B?alM5WjJVWVBoeUJrK3ZGZ0JqL3pyckZGazdNSkMyUzMwZmFEWmxVUlVwa0tN?=
 =?utf-8?B?MFc3U1ptQXRUdGdrOXNCclpibEViYXQ2NXBCNzZETUFDR3FGRm5GaTZ6eUwv?=
 =?utf-8?B?VW5wVGV0SW9ZUHE2TkpoOE9nbk9pMEEyZ2xwVE9qeHdpL1JqMkdXV2JITjVI?=
 =?utf-8?B?cTZhRWpySVpMNTZaNThvUGRlTW9GTjA2RVd1TjdSUUJxMTJtVHQ2czFVWEU1?=
 =?utf-8?B?Qmh4ZFlVY3NmUDdZOGlkd0MzRmNSRW5aRVdxU1BSVjFEN2htc0YvT1U3bi93?=
 =?utf-8?B?eDV3Wi9QQmNqU3poVTQyYnJ6OGZuTkVxNWNxQTh6bkVuUEhodWpSeUFPUE9u?=
 =?utf-8?Q?N9rFWzdidE7SvhSKsBxEL1YtQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22697f59-1be9-4e1d-b6a6-08dd1a6ae7bd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2024 05:08:10.9398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7o7DILmTpHfVcsg3cXjfVGx2HIvzoLK0337X4et6rL7E8gj+TdmvcLTVsZoxjV82WMV6wWpF2K56mIamSOnxBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6064

On 12/12/2024 2:02 AM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:39PM +0530, Nikunj A Dadhania wrote:
>> diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
>> index 774f9677458f..fa0bc52ef707 100644
>> --- a/arch/x86/mm/mem_encrypt_amd.c
>> +++ b/arch/x86/mm/mem_encrypt_amd.c
>> @@ -541,6 +541,10 @@ void __init sme_early_init(void)
>>  	 * kernel mapped.
>>  	 */
>>  	snp_update_svsm_ca();
>> +
>> +	/* Mark the TSC as reliable when Secure TSC is enabled */
>> +	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
>> +		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
> 
> What happens if someone writes MSR 0x10 on some CPU and thus makes the TSCs on
> the host unsynchronized and that CPU runs a SecureTSC guest?
> 
> That guest would use RDTSC and get wrong values and turn the guest into
> a mess, right?

No, SecureTSC guest keeps on ticking forward even when the HV has written to 
MSR 0x10 on the CPU where the SecureTSC guest is running.

I performed following experiment to confirm the behavior:

1) Started the SecureTSC guest pinned to CPU10

host $ taskset -c 10 ./bootg_sectsc.sh

2) Read TSC MSR on guest

guest $ sudo rdmsr 0x10
8005a5b2d634c

3) Set TSC MSR to 0 on CPU10 on host.

host $ sudo wrmsr -p 10 0x10 0
host $ sudo rdmsr -p 10 0x10
4846ad0

4) Read TSC MSR on guest again

guest $ sudo rdmsr 0x10
8005d18a7144f

Regards,
Nikunj


