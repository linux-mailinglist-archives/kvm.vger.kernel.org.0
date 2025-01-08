Return-Path: <kvm+bounces-34738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D7FA0524C
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 05:47:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8D6541889966
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 04:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0416819F487;
	Wed,  8 Jan 2025 04:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yelok3E+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE1B2594A1
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 04:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311662; cv=fail; b=qZitiEIImkVYAO/iwv5O6QwZuywa4q4zeGcaN/RL07tJR+Bl/Vsb0sj6XEdqr4PCxkV5dmlM0BMaIuZqXJlDdmycqgh2TZGiP26z3NX+TLS3p07bTPFT2y9KB1i6ys2+KZp7nDSZ+yeD2+zANQzwMOheBQH795iPdF9KEr7i29s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311662; c=relaxed/simple;
	bh=GVs/IHFq6vL4pMO7cStmcTE/O0YKVgq4JH3Jx/98P2g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bc1/sDiCDQXAcGqFw/exL2sEcx2VznMtDYO8JiujocZi3lC1KvTruWDCYRJwnfGlaXeOn/H9cDhNOeo65NZscC10APW2zY7ojRuicOMj1V/ml/LCd6/tNgURpH9KqDyDTHX85+RRRHwpxJM1pgb/xvwzzMM8G983ncYSv1gcCho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yelok3E+; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=acL6bBychLs0K2dR+odLiyLRSfvAQ81RswnWmA3p92VW12oLnwIoBpjenoKcyfTnlKHS2F6Qh+D1ccbmyz1SJYuXG0+VZ0j5nWdDEaQ52um6xKUx40cKb6RAUEms/SbB4bUY/RpEw4qciGfftPFqrfoRcaa8HUdh5s+uMvExD/7kZbtyRoycReA0fHIu7BKiLrneEZp/0ZFi8IC2hAhuUMggtCdM5oqAM+Yj4kcg2XMYitBz9O1mtwrRqE3jMZRu03+PWf2Og8gLHexetv/RrQSCZujQSDgrmM0+/6crsdLYmR/6Z1jolgfnPfZoQY7MP9O76iJAKs4YLokY1TFoxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pISHhBQp46Ro2ytR+uk4VMAUQbVAstO7vOFbJSCuH2I=;
 b=lT8SyuuN4WZIIbAx7f0ABqTe6hc8V3iwWXCzOh1Ix98SJ92zjas9RvlHE3/eTV+C+XY+vqEmO32tNjXpaMWyz6c3i9EJWokO2xQMqy+ND25/iq+ABj7+gWQX1Nv7B8vhXKyCJIfCb7da9DlZZ6N89PBs+P0Db9s3sL1U1CmjBKa8tcYkTXKZgw0GjtohSV8B5AnzaJ0HmRRxaAHdkUqAyB4mVlL8Wak0r12qVUhrxCahTrEh7wFTo6/wKIy4BfvLTqn3+a5ckHcin01pze7aLEV4h+yVibV+tsjyO+Jqj9ffEgoODpUfU8N8jeWGNl8G75WKuZc7gL+29EnC9BMWIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pISHhBQp46Ro2ytR+uk4VMAUQbVAstO7vOFbJSCuH2I=;
 b=yelok3E+7jlH81C2ikOR1hmBKlUk+e8K0jZSv75NeLt3aYidfhZ6fzDFUAGgaOivvG5XRkxxqYeYYOiPrJZfshVhAvS5JLZ5jJt9M+Gw5ZBHkpSBI//uqsXV0e+l3VWAJQaj4wJOsq9J+QygbKjL4L6d7Iu5gLkHQ8+W37m9vbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB9247.namprd12.prod.outlook.com (2603:10b6:806:3af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Wed, 8 Jan
 2025 04:47:33 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 04:47:33 +0000
Message-ID: <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
Date: Wed, 8 Jan 2025 15:47:25 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 0/7] Enable shared device assignment
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20241213070852.106092-1-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEWPR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:220:1e3::13) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SA1PR12MB9247:EE_
X-MS-Office365-Filtering-Correlation-Id: 9620a59a-47d1-4ebf-0055-08dd2f9f90a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aE5JaTlrbU54Vy9FWXl2WHcyUFQrYXYxek9VbEtFRGxFQ2lWaXBYV1BRL3Qx?=
 =?utf-8?B?eUZGak5oVklTUjVBTkJwc0xGNUlRQzQ5RzRXYm5EeGJ2V3R4WGxNNnZubWFl?=
 =?utf-8?B?L2Z6cWVlZUI5ampUczBuOStTcjJ2cE5ZV3F0bmdldGRYVG4rcGt4aEkzY2pQ?=
 =?utf-8?B?L2VlS0w0M1hLaTFJbkpVRVA2VnJtOXVha3AycFh3ZXVQZ2NhK256S3FoWXhu?=
 =?utf-8?B?R3VYdnQveVhPcjB0R3RLZDJpYzNmUUxaYjl4ZkhZQm5zWHNPTWhzUGZRQTdW?=
 =?utf-8?B?TndDdEdWbnlEbTR4MEZiSCtJQnkxV3R1ZEYvR3hEOGZEcUZ5QndHRXhpdXoz?=
 =?utf-8?B?UHRSMVlNaVRDam41cFFIOTdScDk5bEt2SER2THptQS95L2lOdEpOMzJYZ2ZE?=
 =?utf-8?B?SGM1M0VnMGx0S1dlbit6emJ6YkZDdE1jWDhvMkhLbFlOMmNMSG5CMmVmR2ZP?=
 =?utf-8?B?Lzg3TmU1eXlqUWVsS3UvdjhkYWFsT2t2YUExWUNTOW9SWmE2THBEZFVxTGFQ?=
 =?utf-8?B?LzZaZ243TW9lWHZuNHNQbDRyT0kwOUt1RVdhNGxLMnFNM2VNYWNKNk1SOE5i?=
 =?utf-8?B?Z3d5andKUjVVRkx4MzdHSWF6cEpvTWFoNVM1VXJ2Q2p0b2xFcm5ndFhvekEx?=
 =?utf-8?B?Z1c4MlF6NkQ5L21YbUNlVTA2UUVtK1BmbFllZW51eWV0eXFVVkJtbkxML3BU?=
 =?utf-8?B?U05qTkd5ZlRqekVTbXhzUW11RFBzZjB1QVhDT2ROYTJIQk5BZm9Qc1hFeVpP?=
 =?utf-8?B?RzZ5SXhuM2FjTEtUcmYyZFA0ZVc2TmpVYkE5NEEvVTBCRzdydUlvS1k4aDYr?=
 =?utf-8?B?NnpZN2FERUh1MjVsdWFVRlNEcy9TQWowVk9UemVyR0hYd0VDWGFoTU1WOVZS?=
 =?utf-8?B?VURqWjlETFRCU2ZMWkpCN0RLQzBrMzQ4QWtMdktkNmVJdm9NV0c2Z3lXYUtu?=
 =?utf-8?B?RmtwMUFUdmx2YWgyUkpKektwT2VrbVRmdWVxYXFDdjFnOGFzOHVFem5veWU1?=
 =?utf-8?B?ZFJueUdoZE1kRXlHOVlPaEhvZEpNYzl1c1R6Wmo2bjZvaGdENjllYUxrL2Uw?=
 =?utf-8?B?THNrOHBKc2s5TkNjakFmTVA4VGhaZWJiSGtLd1p0THZLTTZmallyVlBjTnBM?=
 =?utf-8?B?NU0reFZ3YVFSL2d4d2ozVzhpMzQ1WS9DTVhVSitpTG1TS3I5WlFaWU11aFY5?=
 =?utf-8?B?RURaN1V5cFg3b1REUldoMG51NlRaZXlqRU5acEJrUExUOWVOZlpEcFNJTHk3?=
 =?utf-8?B?WHFyU0pXYXJwOFMrcUtPZG5tdE5CdWk4bmZIVERJZUV2akF3WnZPRHNQTVJu?=
 =?utf-8?B?S3VOTC9PZ2VEQ0ZkNStDTnVkc25XOUo2QkJDUnJCb0FpUUhNZE1XZVVzOStu?=
 =?utf-8?B?Y3BDWE1iZXBhSnl5M0thZm4zK2xXTUdQdS9MVkhRbEtOalFwajNOU3pUVUti?=
 =?utf-8?B?cHlyZkk1VG9VZG0yK2NYUTdqRlJlMnRZMUpLZXlYRDIvbE4yL04yY1g4Wjhj?=
 =?utf-8?B?TWJ3d1NDeGhhNlBKUHNuaHZPOFJzTnZzcGZzTWZlRUJTMjdWbWR5R0lIdEJ2?=
 =?utf-8?B?MTYyaW5lNS91UExPZldPQ3NKZ3F4SXFpTUdpMjQxckJpdElVdWZBTnYwQUpT?=
 =?utf-8?B?dFliVHpCLzY1S3hrZUg5VG9YeWc2cHF6VEdoSCtNQWtORmVrR29ZYUNUNkF1?=
 =?utf-8?B?Qi9xZE51MlUwK1BKRkRUSlJnMmM3SVJYYmhHK2loUy9vSHlWRDhVYmdWa2Nx?=
 =?utf-8?B?N0ZtVWN6aTU3S1FwMnIycDFuSjNPc2hxNzY2TEMwSTZpTUtyRkpsbHNjS3Vn?=
 =?utf-8?B?aGRFRzc3ZWRzRFRZbnE3QT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a29GVHV6VlVJbGFsYjZJc0IvOWNXditWbE56eEZYTjBCTk9jbkRITXJxNC9O?=
 =?utf-8?B?Y21qVmpZOSsvTGJLUnJDd2FpNjBDU0VOMlhwb0N0RHNWVGQ0N3VDamFTVEkr?=
 =?utf-8?B?c1Q5YmVrYTlWZFQxZmdNandQQ0ZWdVV5N0VyKzNDczNTWTVZcXlOTlJhNENu?=
 =?utf-8?B?Qm1BQUZPdXo1Ykp0RFdTRzFhRWNqLzk5NUh0ZzZnT29sNmxRZS9DUXF2ekl1?=
 =?utf-8?B?TStWUmFzNjludVRWQ3lxRVg2ZVMzd3ZZNzM3ZnIrd0lLcnVIQ21EOGFjSTZz?=
 =?utf-8?B?eWl3djBudVVzTEs5OU0xc3BiQlhCY1FEVngrdU1MTWdhL0hvVmttczNQUXZ5?=
 =?utf-8?B?NGVVakRKMGpxaGFjRSt1OFIxelFPSjR6WUxTRHI0R3pDL0FIWHFobkU2MjU5?=
 =?utf-8?B?bEs2MFdOWmV3aE4wbVE0YjNYVFBNMUZJN1ZRdVJwY0pBMmNQOVgxNGIxTkl1?=
 =?utf-8?B?YzVFeXVyWFFyQUtZRGpYeHhMNWg2Q2k4WHJ5WHBxaC9YblI0RE1YS0tRZlg1?=
 =?utf-8?B?UmRDaldyUVl3SlBJc1BIMGx6TTRuYmJNdEd5ck92UkRJclJ0QytnbElqZVJB?=
 =?utf-8?B?RjhlUW9hUlVlbEVzMFlKUDdtSjZPdUxnWWFPakhPTkR1YnU3YjdCVk94cCtK?=
 =?utf-8?B?aG1QTkFKUW10b080NG9wbWtUREF3L2tSdGdnYXNwZEFxbGJxOXAweEtpWE4z?=
 =?utf-8?B?Znl3NUhrTnd6TERzT2F3MklKZU1ROTZyZVN2djN2ZkdnTVYrdnhsSVN4OEFk?=
 =?utf-8?B?M1UzZjdMcTJmMjVSOGd1VlBwZUtmVzQ2cVV5cFU5aGl0UnhsZGoxTzlSS1ox?=
 =?utf-8?B?MGtDdmJhdy9hOHNQNm5ya3pvZ3JEYll3NThmN0t2N25lNGpVa3kvcjc3WkNB?=
 =?utf-8?B?SFR6MjVnNGF4YUE3NFUwdGE1RjR6ZW9RUzVkSWZPWFFEckhITG9PNWpuTmgr?=
 =?utf-8?B?NEhrS244dlZybmhzS3FYMjdhWW9ORXJhbnN4Tm9zUVd5SWdXdGVQbjF2bEVr?=
 =?utf-8?B?VzJVVkRQazBrZ09sSUl0VVh5SnhaWlZLSDYrRklUMURxbndoVGcwZEpPeWxD?=
 =?utf-8?B?a0tWeDd0aGhvVHFFLzRZdE9EVHFHOHF5NTVrMEdJSXFZQXJGbDRhTjIrRkVz?=
 =?utf-8?B?T0cxbXI4VFpCWFV3VTZYVzQwSlZUN000T1d0amYzRkdabEsrYmlKMU50YmVK?=
 =?utf-8?B?Nk0yNjFvMmJ5RDRnRjMvbUVUbkpIc2txd2ZHS2VmUFkvRitkSGIvd2VZMzQy?=
 =?utf-8?B?dktieXVBbWxscnErSWhWNEgrbGRGUXZ4K0JNUmFBZnFEVHJTRFM5ZDFWR0VL?=
 =?utf-8?B?U0tLNHVDY0FwZWI2angvaUJIcGpaNEtZY0p6MCtOb3hTd3JDVSt2NUhLVFZt?=
 =?utf-8?B?T3plRFQ2MXlibDBaazJIU29ZYTdhZVpydnZEM3N3Q0xxOVJBMkRQSmFTT0VU?=
 =?utf-8?B?TUo5RzUrU2ozMTExaWtkWjRML2RyQzdzQTdvWnlEakFnZ0h2aG1pNDd5Q3pJ?=
 =?utf-8?B?aTFSOWV6MTIxQndYOW9wT3pBZkJ1UHRnT3BLdlpRSVU1eWE5VkhsRlZmbVBm?=
 =?utf-8?B?alZZdFJ6UlRJYnpxZXVDSTVUdVlhUmlmeUh3ZTltekhBWXljRDdLa1V5VVVp?=
 =?utf-8?B?c3FJV05JbEx5UTlpUVMyRyt5dXlOaU55d3h2ZGErTkhBSjNGa3ljMUdIb1l6?=
 =?utf-8?B?Rys0N3BnRU5yVkRSRnV0aTRyUFNJZG9RSzViM0tlcms2ZnFTMk80NVFQemFy?=
 =?utf-8?B?VmRJKzNpcGNxYTRHbGw0M2xnZy9ZZ0tGN3V0TXVUYjRMTWU0Nms3QndGVUtj?=
 =?utf-8?B?aFRTN3N6dWlFOXd5Uzgvb0xVOUorUW5TbmQzZjRrSFVJVFoxUlJSMktWeWdy?=
 =?utf-8?B?RG05UDdXeGtmSE11bDMvYnk5UTM5dFJnUkt5d1lXalZ2MUZ1ZDR2R01iMHdp?=
 =?utf-8?B?T3k3QnZvM3ZxNzVUN0JnQ0FBQzZsRkp0RVVBRFl0Q0hQMHNUblo2MjhqOERk?=
 =?utf-8?B?eU5NczdGODRlZ3NjNU52Q0NDYXFwemVTRVR6UTlud0pZTjJMY1YvWnovM2kv?=
 =?utf-8?B?SHl1YVBmWjZraEYzemlWbFpDMi9XbmxTQzZibFNaQVhGRHlad3NvYTJPNXIy?=
 =?utf-8?Q?2xqGiP2533f4YDPYD+KYFIJG7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9620a59a-47d1-4ebf-0055-08dd2f9f90a6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 04:47:33.2965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YsvQih2jo4/waG4+Ax/fGg1LYLtwpJKjwVGu8fPQXSkWOtmX3vevyNcD4Qo0Cc8NezKXVa3OWGXj1bxN+RZraw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9247

On 13/12/24 18:08, Chenyi Qiang wrote:
> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> discard") effectively disables device assignment when using guest_memfd.
> This poses a significant challenge as guest_memfd is essential for
> confidential guests, thereby blocking device assignment to these VMs.
> The initial rationale for disabling device assignment was due to stale
> IOMMU mappings (see Problem section) and the assumption that TEE I/O
> (SEV-TIO, TDX Connect, COVE-IO, etc.) would solve the device-assignment
> problem for confidential guests [1]. However, this assumption has proven
> to be incorrect. TEE I/O relies on the ability to operate devices against
> "shared" or untrusted memory, which is crucial for device initialization
> and error recovery scenarios. As a result, the current implementation does
> not adequately support device assignment for confidential guests, necessitating
> a reevaluation of the approach to ensure compatibility and functionality.
> 
> This series enables shared device assignment by notifying VFIO of page
> conversions using an existing framework named RamDiscardListener.
> Additionally, there is an ongoing patch set [2] that aims to add 1G page
> support for guest_memfd. This patch set introduces in-place page conversion,
> where private and shared memory share the same physical pages as the backend.
> This development may impact our solution.
> 
> We presented our solution in the guest_memfd meeting to discuss its
> compatibility with the new changes and potential future directions (see [3]
> for more details). The conclusion was that, although our solution may not be
> the most elegant (see the Limitation section), it is sufficient for now and
> can be easily adapted to future changes.
> 
> We are re-posting the patch series with some cleanup and have removed the RFC
> label for the main enabling patches (1-6). The newly-added patch 7 is still
> marked as RFC as it tries to resolve some extension concerns related to
> RamDiscardManager for future usage.
> 
> The overview of the patches:
> - Patch 1: Export a helper to get intersection of a MemoryRegionSection
>    with a given range.
> - Patch 2-6: Introduce a new object to manage the guest-memfd with
>    RamDiscardManager, and notify the shared/private state change during
>    conversion.
> - Patch 7: Try to resolve a semantics concern related to RamDiscardManager
>    i.e. RamDiscardManager is used to manage memory plug/unplug state
>    instead of shared/private state. It would affect future users of
>    RamDiscardManger in confidential VMs. Attach it behind as a RFC patch[4].
> 
> Changes since last version:
> - Add a patch to export some generic helper functions from virtio-mem code.
> - Change the bitmap in guest_memfd_manager from default shared to default
>    private. This keeps alignment with virtio-mem that 1-setting in bitmap
>    represents the populated state and may help to export more generic code
>    if necessary.
> - Add the helpers to initialize/uninitialize the guest_memfd_manager instance
>    to make it more clear.
> - Add a patch to distinguish between the shared/private state change and
>    the memory plug/unplug state change in RamDiscardManager.
> - RFC: https://lore.kernel.org/qemu-devel/20240725072118.358923-1-chenyi.qiang@intel.com/
> 
> ---
> 
> Background
> ==========
> Confidential VMs have two classes of memory: shared and private memory.
> Shared memory is accessible from the host/VMM while private memory is
> not. Confidential VMs can decide which memory is shared/private and
> convert memory between shared/private at runtime.
> 
> "guest_memfd" is a new kind of fd whose primary goal is to serve guest
> private memory. The key differences between guest_memfd and normal memfd
> are that guest_memfd is spawned by a KVM ioctl, bound to its owner VM and
> cannot be mapped, read or written by userspace.

The "cannot be mapped" seems to be not true soon anymore (if not already).

https://lore.kernel.org/all/20240801090117.3841080-1-tabba@google.com/T/


> 
> In QEMU's implementation, shared memory is allocated with normal methods
> (e.g. mmap or fallocate) while private memory is allocated from
> guest_memfd. When a VM performs memory conversions, QEMU frees pages via
> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
> allocates new pages from the other side.
> 
> Problem
> =======
> Device assignment in QEMU is implemented via VFIO system. In the normal
> VM, VM memory is pinned at the beginning of time by VFIO. In the
> confidential VM, the VM can convert memory and when that happens
> nothing currently tells VFIO that its mappings are stale. This means
> that page conversion leaks memory and leaves stale IOMMU mappings. For
> example, sequence like the following can result in stale IOMMU mappings:
> 
> 1. allocate shared page
> 2. convert page shared->private
> 3. discard shared page
> 4. convert page private->shared
> 5. allocate shared page
> 6. issue DMA operations against that shared page
> 
> After step 3, VFIO is still pinning the page. However, DMA operations in
> step 6 will hit the old mapping that was allocated in step 1, which
> causes the device to access the invalid data.
> 
> Solution
> ========
> The key to enable shared device assignment is to update the IOMMU mappings
> on page conversion.
> 
> Given the constraints and assumptions here is a solution that satisfied
> the use cases. RamDiscardManager, an existing interface currently
> utilized by virtio-mem, offers a means to modify IOMMU mappings in
> accordance with VM page assignment. Page conversion is similar to
> hot-removing a page in one mode and adding it back in the other.
> 
> This series implements a RamDiscardManager for confidential VMs and
> utilizes its infrastructure to notify VFIO of page conversions.
> 
> Another possible attempt [5] was to not discard shared pages in step 3
> above. This was an incomplete band-aid because guests would consume
> twice the memory since shared pages wouldn't be freed even after they
> were converted to private.
> 
> w/ in-place page conversion
> ===========================
> To support 1G page support for guest_memfd, the current direction is to
> allow mmap() of guest_memfd to userspace so that both private and shared
> memory can use the same physical pages as the backend. This in-place page
> conversion design eliminates the need to discard pages during shared/private
> conversions. However, device assignment will still be blocked because the
> in-place page conversion will reject the conversion when the page is pinned
> by VFIO.
> 
> To address this, the key difference lies in the sequence of VFIO map/unmap
> operations and the page conversion. This series can be adjusted to achieve
> unmap-before-conversion-to-private and map-after-conversion-to-shared,
> ensuring compatibility with guest_memfd.
> 
> Additionally, with in-place page conversion, the previously mentioned
> solution to disable the discard of shared pages is not feasible because
> shared and private memory share the same backend, and no discard operation
> is performed. Retaining the old mappings in the IOMMU would result in
> unsafe DMA access to protected memory.
> 
> Limitation
> ==========
> 
> One limitation (also discussed in the guest_memfd meeting) is that VFIO
> expects the DMA mapping for a specific IOVA to be mapped and unmapped with
> the same granularity. The guest may perform partial conversions, such as
> converting a small region within a larger region. To prevent such invalid
> cases, all operations are performed with 4K granularity. The possible
> solutions we can think of are either to enable VFIO to support partial unmap
> or to implement an enlightened guest to avoid partial conversion. The former
> requires complex changes in VFIO, while the latter requires the page
> conversion to be a guest-enlightened behavior. It is still uncertain which
> option is a preferred one.

in-place memory conversion is :)

> 
> Testing
> =======
> This patch series is tested with the KVM/QEMU branch:
> KVM: https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-11-20
> QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2024-12-13


The branch is gone now? tdx-upstream-snapshot-2024-12-18 seems to have 
these though. Thanks,

> 
> To facilitate shared device assignment with the NIC, employ the legacy
> type1 VFIO with the QEMU command:
> 
> qemu-system-x86_64 [...]
>      -device vfio-pci,host=XX:XX.X
> 
> The parameter of dma_entry_limit needs to be adjusted. For example, a
> 16GB guest needs to adjust the parameter like
> vfio_iommu_type1.dma_entry_limit=4194304.
> 
> If use the iommufd-backed VFIO with the qemu command:
> 
> qemu-system-x86_64 [...]
>      -object iommufd,id=iommufd0 \
>      -device vfio-pci,host=XX:XX.X,iommufd=iommufd0
> 
> No additional adjustment required.
> 
> Following the bootup of the TD guest, the guest's IP address becomes
> visible, and iperf is able to successfully send and receive data.
> 
> Related link
> ============
> [1] https://lore.kernel.org/all/d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com/
> [2] https://lore.kernel.org/lkml/cover.1726009989.git.ackerleytng@google.com/
> [3] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.jr4csfgw1uql
> [4] https://lore.kernel.org/qemu-devel/d299bbad-81bc-462e-91b5-a6d9c27ffe3a@redhat.com/
> [5] https://lore.kernel.org/all/20240320083945.991426-20-michael.roth@amd.com/
> 
> Chenyi Qiang (7):
>    memory: Export a helper to get intersection of a MemoryRegionSection
>      with a given range
>    guest_memfd: Introduce an object to manage the guest-memfd with
>      RamDiscardManager
>    guest_memfd: Introduce a callback to notify the shared/private state
>      change
>    KVM: Notify the state change event during shared/private conversion
>    memory: Register the RamDiscardManager instance upon guest_memfd
>      creation
>    RAMBlock: make guest_memfd require coordinate discard
>    memory: Add a new argument to indicate the request attribute in
>      RamDismcardManager helpers
> 
>   accel/kvm/kvm-all.c                  |   4 +
>   hw/vfio/common.c                     |  22 +-
>   hw/virtio/virtio-mem.c               |  55 ++--
>   include/exec/memory.h                |  36 ++-
>   include/sysemu/guest-memfd-manager.h |  91 ++++++
>   migration/ram.c                      |  14 +-
>   system/guest-memfd-manager.c         | 456 +++++++++++++++++++++++++++
>   system/memory.c                      |  30 +-
>   system/memory_mapping.c              |   4 +-
>   system/meson.build                   |   1 +
>   system/physmem.c                     |   9 +-
>   11 files changed, 659 insertions(+), 63 deletions(-)
>   create mode 100644 include/sysemu/guest-memfd-manager.h
>   create mode 100644 system/guest-memfd-manager.c
> 

-- 
Alexey


