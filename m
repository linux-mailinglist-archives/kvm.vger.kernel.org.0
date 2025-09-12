Return-Path: <kvm+bounces-57411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CB3B5525D
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 16:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 065DBA060AE
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 14:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B68930F927;
	Fri, 12 Sep 2025 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ufgIOwlC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2193B30DEDA;
	Fri, 12 Sep 2025 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757688771; cv=fail; b=R5nQgT7l+qOm2K/8SLJ4EbO/v+EahXmOEDT8D/0wxDwFuHqlYs/XkUvuU8RJCmhrEQu89q4hI7aiq7V6NWqXkb9Pt2r3OJxKv9UtWhodNRIOPzhwCDX8Q7pwq9KCDTGwRQyux1zMGj91KkLQoBxZLP4+z1wqyDva2j2pJ1xP6NU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757688771; c=relaxed/simple;
	bh=ZbxugUaL3KDRWprT0lFn7nZrlj0EZ0duiBDIyAXM+KE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GjBfZIzPH13dOWg0VuM4fSULDVohKRuYz4tvzipOeJXK9jdTkrF+P/kwrefg23hJ3Fwvc7tH89S7ZCT3rmWHFusiUL6yEiJtdWKmF0jgAKxdA0fqSS+E/a57J1LTh69Pma+lOsrvfm29TVZQAz28Xoh1ASQ2RPM8y36U2L5sUiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ufgIOwlC; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f+FXeLMKt216MHqkYe1UJVrECBb1jwKJcW7qWJlGxzk/BZOBPF49VeZOKerj3DPGuJXFe8yFXpkT1ccrkGgKzUDXJw+UqdLPspUoeQV2gOXl6OAgJplGGIuS79IxbkzSowEq9uSRWQclSer/muRDWgPnbOkqOXIkHDuvdDgPeaHOgrZBKPhUnD3Ax4mumtzptxBOYC9yKK5rwS4XKqh16b9KqKlfF7WhEIomwmRq4YrkGPxG2Dl8KOf3lxhQZZIKvHDrVxxzy4Iux207mdYSRySTzh0oKgXExgCan4OGdqy5a7862AuOJPgnk1MOo20i1uF15fyMCybTlhHuYJdl2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PwV56vsLhKyGisYbbHQdqr7t/MhInHOplk4/InqFWBY=;
 b=Qa3TSmeYmahPqzvbE0ZL3IP0qH/HFNdodQgZ7tJNussHBW6zP/W5ITwBP3U7uWJ3cEnbN5lFNWdN65CzZlbu7ase7Mi6thCv/cX2aur97Gv8PgM9MXksqRCrSxML/M438gM8fCYzzLq2QrUCPsbEMm0axBxhSxQ3EzZ+fGErnzzXx3SspDbGhI015CRsbXcdxl7UfDrlIyfGRDGv6kgkKTItGqOFd3Hlujcy/Qxd4oxHFEg8DMVu+96wRZa4OHQZDoJC5V9PfX/H75qV0YBbO6gHtuIq2fQzx51/SMpbpr8bYzVm3IH7B3Uik9uvjWRrpA06LULAI6qNOc8hOwD3Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PwV56vsLhKyGisYbbHQdqr7t/MhInHOplk4/InqFWBY=;
 b=ufgIOwlCxGxU32JS8QfqZeCrEUcnE6Wl8l8PF2zdNwOeYNhyuIiaHtQO5uY+xQzk2J6mW7I878ijrLwtzE9mzdIm6AP2DerR3t6x/gY2UqIX0cNyqiVt8faFHzpdPCYKWPKokjoXWmkQmjjTb74qkfFwN9mws12tSJyK9ONEk9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by PH7PR12MB5758.namprd12.prod.outlook.com (2603:10b6:510:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 14:52:46 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 14:52:45 +0000
Message-ID: <7132d855-d855-43c4-83a7-a6d165fc1a75@amd.com>
Date: Fri, 12 Sep 2025 09:52:40 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
To: Ashish Kalra <Ashish.Kalra@amd.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
 herbert@gondor.apana.org.au
Cc: nikunj@amd.com, davem@davemloft.net, aik@amd.com, ardb@kernel.org,
 john.allen@amd.com, michael.roth@amd.com, Neeraj.Upadhyay@amd.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0022.namprd18.prod.outlook.com
 (2603:10b6:806:f3::21) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|PH7PR12MB5758:EE_
X-MS-Office365-Filtering-Correlation-Id: 69b286a3-658a-41be-0b00-08ddf20c073b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MjNhbWEvd0laL0JlQXRwY3hlMXIvU2ttZzdYODVsNVpPSGp1SUx5VUVzVnAz?=
 =?utf-8?B?OXo1UysyaSthYlZBeXUyL1FCTkhuM2ViQVE3OGVQQ3lMN3dzQzRKSE8yQ3hD?=
 =?utf-8?B?ZkRnZDdiTUlsRGRrZkNSQU5HcGg4YmZpTDVML1hqRUFRZEh4ZzVRbFZ4TDlJ?=
 =?utf-8?B?dUNBY2RId2tzdkdyMmhnN0pQL0dDK09LYXlJVnl5QjI0aDMxMGVNeTZ5UldX?=
 =?utf-8?B?bEY3WEpQaDRrRHB2WDFlTjZ5WEpaeGs3OElFQ1NZNm1vRGxZaFJqSk1JaWJr?=
 =?utf-8?B?S3FDUDRodmJtRUxBOXQ0RHJOQUlVaTl6ZXc0eDFLbmZDQzJkL0dZSllQUCtj?=
 =?utf-8?B?QmxHdWpCd241djBYM2tXdVlJUEpxVTYvakxuZjlibUFlMFc1Q0REVjg5UW9S?=
 =?utf-8?B?eEVrOUp3dWVpWk1UbHJ6YXp0MWxXNXlKbGI1MEFGWmZ0a3U2cHVKQU56U044?=
 =?utf-8?B?citKQXU4NGpNa1kxQmlHeC9uV3NIekZEdEtPQXZNclJnU1cwbHA0c2k1c2xT?=
 =?utf-8?B?cHlDd2J5bFBzdnVNaEdPR2l4UDVDVUpoeVlDc1plRUtzWExVaDg3azJJV1B1?=
 =?utf-8?B?b0dPOW1qaWFLaUtDZ29BRDU5VXU2TUFhVXR2SnYydFF6U3J1L1Fua2xyM2Mw?=
 =?utf-8?B?MkxhSllNRFZXeUJ6OHd0aXMvQ3NabnUxNnY3MUJ2MlhlZEhJREFNdHcyNWU0?=
 =?utf-8?B?RHdGWTEzRGNNVGtVOGxtcC96SVMvSjdnNlAzT3ZqYXNzd1RBU0N6S3FYbmJT?=
 =?utf-8?B?blVpcmRpMjRRSFRLbVI2WFpRL0JjdzRQT1Y2V0xnR011bzR4bElxdFNXTUxo?=
 =?utf-8?B?dzRlVkRTb3ZVbmEydTBOYXNzbjdpcXlJb2VTY1QxMlRSM3Bpbms2clJWVjg2?=
 =?utf-8?B?NWp0NWdXZEQvWFRjcjJ0Wlc3bjQwaWQvZUVwTGJLTCs4UmRVYUJzdHcyODAz?=
 =?utf-8?B?bkRpQStQZ29oaks2TEFhOE9zS0FvWUxQSGhxTHVXT1dDT0gvWXNJTTI5OUtw?=
 =?utf-8?B?ejhUc21Rd2s1MUovTHl1RUNsQVlsQUpNMm50d2orRS8zUU00RUw2dTVsZENj?=
 =?utf-8?B?WWMxMi9tMnBKWmZUS25PWGN6K3dHU3RPRS9aQWhsd3JWRHRTdTZuOG1RVzFU?=
 =?utf-8?B?WGMvRlVMYTVKY01vQWYxSWthSVB1N0ZlNTAyQitVeUpnb1NPNzJDRGlXWVo2?=
 =?utf-8?B?Q2c4RnpDeWh0L2gzMzBZblM0QlZCODBzRktrQTB2N2RUL0gvaDN1NWxVdk5K?=
 =?utf-8?B?TnQzVDZoaENxVHN6aUwydU1jbUZnc3E3VFNjZ2FqUkJvcktsOFRkYzhnc09x?=
 =?utf-8?B?WXdzS0hOdnozRlY3YTV5TFNxK0hwczdPV3F0ODlrblNrMkwxTnBIazlOS1Iw?=
 =?utf-8?B?eDlCSHRFRjRxemdKRi9zWmF1aEpVQTA3eTlCVVA3VnY5dTdrYW4xM1J5VzBh?=
 =?utf-8?B?WFZHL1ErS2RPZ216a2sxSlNyZ3Jib2loNkxBQkMrYmM5TnNlUUhKbDQ0VVlz?=
 =?utf-8?B?alBiZjFWMnE5bWtEUS8xUGR4cWZRNTJXN2E2a3o3YllEYnRGWUlXVmZ6TzNJ?=
 =?utf-8?B?ZmdyMzVzcmdrbHpMZWljRjRsMjVGeXc2WHlpakRGVzhKWmhsZjl3eTE2aG1w?=
 =?utf-8?B?bTBSTW95ZE1WeGJFOVJZNzRIL0tFT0w4M1FSWlVoRU1ITEJDL0FjbFlVeVdz?=
 =?utf-8?B?OGJFT2VpN3MzOWhXUGVvdHMxYVp0RHhqU1ZnNHFHcHJIK3FaMW13bno0RWFh?=
 =?utf-8?B?WDRSbGRPdEtORGpwVFJ0emlQR1F5aGloN3pidnFsSHZRZFUvOG90ZFdYSit0?=
 =?utf-8?B?M2tFK3JzM2hycHZ1cFRSMDFDRGI5Z2RCUVliODNaMklFaGg2MTk1N0dUVlpC?=
 =?utf-8?B?NDd6WFZzWEpXSTBEdjQxSTh1c2R2cXp0QXR6dUNjMGFBTW5NaHVuQjFxY3lD?=
 =?utf-8?B?QnYwd0t2TlpJcm5wR0JpYVJPcXFEcmpnNUdyQVZsbHNSbW00cUZoaFRraExQ?=
 =?utf-8?B?Y0E5bnZrbUhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eCtSamcrM0lYbE9HRk1henFTcXpTSmxuK3hWZHVoc2VSdWd3L3dDMnYyeFov?=
 =?utf-8?B?dGFwQlB3ZEJhS2RFYWxkRGxXMzBENEFmdk5DbFRtenlPSTNxV3VLdTFCY21V?=
 =?utf-8?B?RmJ3ZDdac2pLNU12SnJBREYyaTNzeC91b0s2ejA3S1Nad3Y0S2Y3QUppbFVr?=
 =?utf-8?B?RElSUUVWWWt2WCt2NURaVGd1VGN3dlcxWmFUZnNhVHhQM1NyZDA0czJKRUxI?=
 =?utf-8?B?K0pSQmVNVXlDdGVWaXNuQml2L0hIeitlY011MG0wT2RxMUc1eHAycXh6TkxX?=
 =?utf-8?B?ZHUxQXJ4b1dJK2pTbzlxNVJ1Q1ZFbnNvdnFiZHlqQmJMMzVsMHdjY2hRVFpY?=
 =?utf-8?B?VElWaFRKMEVBMm1IR3Fsb2x0aythTnZkM3pqcXVXb25ESkpva2xwQVJMZ01S?=
 =?utf-8?B?ekc0bFROd0thVjM2U0s1MDVleGRTNHA4RjYyMWtVYzdKQnk5eGZQbWdFTGRr?=
 =?utf-8?B?QXdEbVJ2US9jM280QnQxNElTVEtVR2kvQ2x2MW0vdmR6YzFPWks5MVBOUFNF?=
 =?utf-8?B?WUpnVjJsdjFBR1JiK2t1QW92ODE2QVRTUENpRFp6b1I0VlhxWXFNWTlITkxo?=
 =?utf-8?B?UjUrRWNaS0RBdWRrNTdzaDdsRUE4djA5cHpYWlE2bmFzRjdzZmZQb2RJZ0xQ?=
 =?utf-8?B?R0RRTDVLMlVuQlpObjAxdDNoQ0dxNFBadkFqYXFTb0tnSzQzRnRJbVRNb1Fi?=
 =?utf-8?B?VEV0cWRYOG0vT0tyTy9rZDZERlIrMzUzSGZKZW5WSzZwZzZUM3hKVGwyV3V1?=
 =?utf-8?B?c0lDSXVtemNKNTUzbU5HR1YxNmJ2UXZ3ZUR3a0Z4cmlDOFhCdkJ0eVBGaS9Q?=
 =?utf-8?B?L2NPQzFHRFVyT0xXRkxUZkpKdVpzYWd4MDhiWmxhb3BLK21Vc25jVHh3QTNK?=
 =?utf-8?B?NkFOZmIrNzRXRkQzeU1oWXY0ZksxdklabEZOS0d6TDF3NWkyb2hiUHg2dGZQ?=
 =?utf-8?B?V0Fad29IRkdYREJ3T25KVTRZVHJxcGxvZWhjVEswNHFDMVE5a3Q1QysxUFBa?=
 =?utf-8?B?NTkrcGhBeVhHVWZGdW53dmQ2cDBDWFRmTm8yVDRNZ0VCZzBEdTN2S1lDV0Vp?=
 =?utf-8?B?MTh0cWtmQ0dGRWdwWXY5N1NRcXc2UVlLTk5CT3RLTmREOEkrekxtSTNucTIr?=
 =?utf-8?B?dnJ3TGJsUVh0UzVRUXRzRkRvSkIvLzZXcEROUUR1cTZuTGdmOFdXdW8xT1pU?=
 =?utf-8?B?Q1l0RmljdUZ3aDBZWW12SktyNndWaytHQW9iMzNER0dlVG9RWEtmeTl6YVZh?=
 =?utf-8?B?cW1haGRua0h4dU1tZWVpUWJtc29UU2JhS3kvUXNqOXJMckgwMGZzTHNmRXNp?=
 =?utf-8?B?d1ozSW9FS2ViQTNHempoMy9ISUJ5VXV3Wlh0NU5NckxzTU1ML0dhL244ZzRu?=
 =?utf-8?B?SmptYnozeUpuSTY4R1F4blVJZTZRWVBUczZkR2tMV1FuS3QwZkp4d0ZxNU1P?=
 =?utf-8?B?TWt2ektaTVZpV2dUNEJoUUpRYVpnOCtRSmt1WVJ2YnBhbGtSbkJXOUpaSGNN?=
 =?utf-8?B?SWJjS2c4d1M2em8rSFVlTUI4MVBFT3NjY2s1TGJCdlFtRjNubnlGMFl4cno1?=
 =?utf-8?B?Q1E1c041b2k4Q1VFMElmcjhyTUpDVTRkeXdCVUtXaDUySUo5Ny9ocFpicjRx?=
 =?utf-8?B?VUI4aUhMUmlJWGdVdDN5WTBzWWc5dkZpKytVR2tPUWFDeEdtV1d1Yk1uYVBx?=
 =?utf-8?B?VmFnV2F1SmF4b3VpZE44R1dZSXFJREZHc2NPWXNCYW9QNFcxRmZuMXp2VVVU?=
 =?utf-8?B?MGhyNkZTbTVGd3Q2UGtJa01vbUw1M2ZKMnlTc2F3UGtYWmJZL0R5djBNczlV?=
 =?utf-8?B?bE5TaXBmOHFOM1ErV0ZNRTFJU3BMd1M3Mm9YRUQ0M2RBNnVZUGNTOUorR2ZK?=
 =?utf-8?B?akJzY2E0SEIrQjluRnpJRXVjbDkrNVN4Y0tmMldWVlRaWlhCcis2eW9LKzJE?=
 =?utf-8?B?eWNkZElndTVicmw1c1pqZFVyVjlGYjBLSm1oSUVFNHJSOXZhQWladXh1azZn?=
 =?utf-8?B?MGpHVGkxMGg2eWtnZTAxQUFDbEE5aDZrQzdCRTc0MVdiL3RuYkwrUUNGdjdT?=
 =?utf-8?B?UU41UkZYd3kyamk4UXB4WW96TVpSRllmTFZ5Um9pMFAxNzRFdWdxN3owRG5K?=
 =?utf-8?Q?ER4Mt1hUFfD79rzfDZ5vpfVKR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b286a3-658a-41be-0b00-08ddf20c073b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 14:52:45.5953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9CCPPX1syZ7FVXuPryGKJ0w5nNIDInWJvOm28ysBypsAbsNIGm43HW4bCnOWStfQKjTeX716qDVF1amIUaZ2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5758

On 9/10/25 17:55, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> When leaking certain page types, such as Hypervisor Fixed (HV_FIXED)
> pages, it does not make sense to dump RMP contents for the 2MB range of
> the page(s) being leaked. In the case of HV_FIXED pages, this is not an
> error situation where the surrounding 2MB page RMP entries can provide
> debug information.
> 
> Add new __snp_leak_pages() API with dump_rmp bool parameter to support
> continue adding pages to the snp_leaked_pages_list but not issue
> dump_rmpentry().
> 
> Make snp_leak_pages() a wrapper for the common case which also allows
> existing users to continue to dump RMP entries.
> 
> Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  arch/x86/include/asm/sev.h | 8 +++++++-
>  arch/x86/virt/svm/sev.c    | 7 ++++---
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
> index 00475b814ac4..7a1ae990b15f 100644
> --- a/arch/x86/include/asm/sev.h
> +++ b/arch/x86/include/asm/sev.h
> @@ -635,10 +635,15 @@ void snp_dump_hva_rmpentry(unsigned long address);
>  int psmash(u64 pfn);
>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
>  int rmp_make_shared(u64 pfn, enum pg_level level);
> -void snp_leak_pages(u64 pfn, unsigned int npages);
> +void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
>  void kdump_sev_callback(void);
>  void snp_fixup_e820_tables(void);
>  
> +static inline void snp_leak_pages(u64 pfn, unsigned int pages)
> +{
> +	__snp_leak_pages(pfn, pages, true);
> +}
> +
>  static inline void sev_evict_cache(void *va, int npages)
>  {
>  	volatile u8 val __always_unused;
> @@ -668,6 +673,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
>  	return -ENODEV;
>  }
>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
> +static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp) {}
>  static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
>  static inline void kdump_sev_callback(void) { }
>  static inline void snp_fixup_e820_tables(void) {}
> diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
> index 942372e69b4d..ee643a6cd691 100644
> --- a/arch/x86/virt/svm/sev.c
> +++ b/arch/x86/virt/svm/sev.c
> @@ -1029,7 +1029,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
>  }
>  EXPORT_SYMBOL_GPL(rmp_make_shared);
>  
> -void snp_leak_pages(u64 pfn, unsigned int npages)
> +void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
>  {
>  	struct page *page = pfn_to_page(pfn);
>  
> @@ -1052,14 +1052,15 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
>  		    (PageHead(page) && compound_nr(page) <= npages))
>  			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
>  
> -		dump_rmpentry(pfn);
> +		if (dump_rmp)
> +			dump_rmpentry(pfn);
>  		snp_nr_leaked_pages++;
>  		pfn++;
>  		page++;
>  	}
>  	spin_unlock(&snp_leaked_pages_list_lock);
>  }
> -EXPORT_SYMBOL_GPL(snp_leak_pages);
> +EXPORT_SYMBOL_GPL(__snp_leak_pages);
>  
>  void kdump_sev_callback(void)
>  {


