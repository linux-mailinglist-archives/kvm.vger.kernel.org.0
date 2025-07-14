Return-Path: <kvm+bounces-52266-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B3A0B0358C
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 07:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D51ED3B5603
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 05:21:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 493F3204F9B;
	Mon, 14 Jul 2025 05:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="EjTkJTti"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9C534CF9;
	Mon, 14 Jul 2025 05:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752470514; cv=fail; b=gZFre1EoDnsSR1lGAaEHlR3CVxt9QhsUc3wfyCl6EG1RNejeNmxw+Z0qfNlp6SwUICM3HO4h/Urnnv8VYhelBcJ586dp0NKOOhr2u4f+1S/4K+V/SWvbCtsuGMTVL3OKi3QGFKRYxAs1Cst2ycG6UA9/eeIDIyYm3fci1zhE0/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752470514; c=relaxed/simple;
	bh=Of2L1oGIgadAUHMGvMR5aQlchkkRlX/FB5IF3DAxzlw=;
	h=Message-ID:Date:From:Subject:To:Content-Type:MIME-Version; b=nRcmkJYjMUbccOL6ePnM66uADi9QqfJoQV2V5WMONDp2ynHnSOGGxBrIcoCJ8X049d3WaIsU4B+/g62j1EilwQLbZnWzzvB5jQvxOIAuN3yF1o7NovXCKPzOxEKCNlL8wYVA/d1TfEKzvyVV4hcVvNtWBv67jsHeu+I9keQbqWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=EjTkJTti; arc=fail smtp.client-ip=40.107.92.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=blv+f/0c+CPbcGlyAcEs6VDZtGIXnKu+nwf9qDbPIEd6GwzFLbI/FDjcrs4XzAUOseh5dfCT7Tjk6cLrnNCmWR3GQJo5bbt48LmQMDVX5NK4/6/51mKZD7hJ0vLdGH6q7wvc8jkueQhFRNO/opdq5IQXkCl3e9yFzBWdUOpk6VFC2hyrlK/WG09Kt9BM9HFJ6VneQLcvv0/tU8HZUFybrxWR1o3RZQXePmh6/hne7iy9BcF4dZKB/ifTdYfVVDGydTQ1Kb7S6UpemTpKMV8dEKRyLGTyDYsap63oLr3NnkVcSrKKYbYaEqw4ANtkIDtF74J+9Ej+ivgxJ3ae17WusA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XA+dc/Z6s2C5CmmLt0tSXsxmxjdo2T/aWVDPW/riUvQ=;
 b=c5q0MMFjkOLnRO+QI69/gbWDhc1SzkR/f/3ywvHv3+5Lu/uPna5AZzD/0VThBQbavjuUNYqaXEpBdfQRUKuM1fAD3tY+81oZeXtkeLX3n+b4CK4+qG/riYIg3QCbDyBjMR7d56t2vlzM6fadK8/skA0b0Hc6YXGFC4s1U+1fXIjPdkc3t+dRzdXP9nq7RSFQJ47UqRTLmh8Yb0YRU4+pxRToieiOSDOMYhxJqnd7gQEvVQGRy64VowVpgX7xjg176ftOQPoirpC+9y3yRVAlHM4wpOUtGu4GcCVGaBmpaEsmxdn/LXR8GUyASGugdYz1VCuuaPRbjUtK2GC0gq/Zeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XA+dc/Z6s2C5CmmLt0tSXsxmxjdo2T/aWVDPW/riUvQ=;
 b=EjTkJTtiQNSV0/fq+eJeA4abB+ZlqLiHQxhrW3Xm7/hfglKRBulXNI/sBEpQCaDGNmdeWjv+copDStpNNDIY8zsgI6XMmvnF4j5Tj6z6d74tOylyRNztdxWW+/LUKCtFcVga9QTXhRwNnUVGzpfw7oGcFZPNjbDDZtpSRYI/wgY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB6460.namprd12.prod.outlook.com (2603:10b6:208:3a8::13)
 by BY5PR12MB4291.namprd12.prod.outlook.com (2603:10b6:a03:20c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Mon, 14 Jul
 2025 05:21:49 +0000
Received: from IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf]) by IA1PR12MB6460.namprd12.prod.outlook.com
 ([fe80::c819:8fc0:6563:aadf%6]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 05:21:49 +0000
Message-ID: <935a82e3-f7ad-47d7-aaaf-f3d2b62ed768@amd.com>
Date: Mon, 14 Jul 2025 10:51:43 +0530
User-Agent: Mozilla Thunderbird
From: "Aithal, Srikanth" <sraithal@amd.com>
Subject: [BUG] NULL pointer dereference in sev_writeback_caches during KVM SEV
 migration kselftest on AMD platform
To: seanjc@google.com, szy0127@sjtu.edu.cn, linux-next@vger.kernel.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0078.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::20) To IA1PR12MB6460.namprd12.prod.outlook.com
 (2603:10b6:208:3a8::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB6460:EE_|BY5PR12MB4291:EE_
X-MS-Office365-Filtering-Correlation-Id: 19a89250-af77-4917-b342-08ddc2965583
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjhGUGdMbkpESi9kcTNkT3oxOTRjZEhTS0xMRW84WE8vbzIvL3M0RngrUTZp?=
 =?utf-8?B?VDBYenZpUWZEUnI1eE1sUndZZ1FhQ3Y4TmhGa1JHZXdxTFkyd1FiUnhGZVdN?=
 =?utf-8?B?QlNGUlY0YnpPM1JTNStNV1pFMUZld2VwbWE3U2x1QWpaRjV2ZU9HcnR4cEFt?=
 =?utf-8?B?QnN5K0NWK1Y0aVR0anFpR01BS2g0aGJIMjAyS3lIRk04UzRSdFdueml5TTBr?=
 =?utf-8?B?NXozYkpvTjBWY0preWJvTVlTQjlkeU5DYmFqNzBEd0padEpyZE1xZ0k0Z2xR?=
 =?utf-8?B?d0tvTjZYeS8rbzFFREcvN282SGFZTFVscGZtZlFkZFZKcEVPU1NFV2pudGQz?=
 =?utf-8?B?VHdRVExJS0h4MThMK201Z0RYczhMMlFhcGFXZTl6QllhL2N6NlFQRVgxd1A3?=
 =?utf-8?B?MGFOKzBWUUt0eDFQYytiQzlsWW1rRU9TT1YvUmtIWFprU1JmTTVYN2JuVmR3?=
 =?utf-8?B?Qjd2dUdPOHBub21hSWdpMWQzSmlyMEpGTnFDRTdmNzBmS3R5bWlVRm8wcTVI?=
 =?utf-8?B?aUFvSVdrRzhpQnl4cDQzL0N3Q0FkWXQ1MEkzVVlmRktxdHBqY0FEWUxZNG1I?=
 =?utf-8?B?bGwwR0U0NktWZEdPbFBuazRTQXI3ZHlHSTdBM1NDcGNUcnFsSHRVZE5hbFlz?=
 =?utf-8?B?ZTR6aGNsWURHcUo5MmQ3cmZsUEJONURiS2F4OXM4U1FSZGd0T2RBMDlQY1Nr?=
 =?utf-8?B?VTB6ckZBQ3B4bDFlRENqclVXL1M5V3R2b1dDOWtzVUplNHp0S3NlT1VOYTh6?=
 =?utf-8?B?eE14emdvVFZQL0Z3Z1dZbU0rNFM1ZTVKWnRRWVRDN0lQbGZHU3FnWjExTE5C?=
 =?utf-8?B?MzVqTC9KTCtiNzJZZUxQVXp3U2lGWkpTRDJYZEE5NHp6UlMzZmRnd3BDVTJD?=
 =?utf-8?B?Si9XTVNLY1dZK0o2OVlxdDd0WTBoU1Y0M3Zhb2RWMmsxV3pGeWdYbEV3dWxJ?=
 =?utf-8?B?RjU5YmhidUZLenlIOEJQSkFZOU9Md0lCRHZSenJ3STFBSFM3VkV5Z0E2RHlM?=
 =?utf-8?B?UDBNdW1KM2l4ZTNJVDFWdkpsMmJXa0hXL25tSCtEc1RTODJnUSszVGVWV0RJ?=
 =?utf-8?B?akpoZEQxZW1WWTZCaFlnRW03ZS9PWkFKR0xTMFBGdElJNGgxaElqaHUzNkE2?=
 =?utf-8?B?a0R3a3NLSEpCUVRQZFE4aSt5MU80SkdyaDE3MzBGWkJJTE9rcVdNVHpidVBS?=
 =?utf-8?B?UDdmSitlQXBsQWl0VFczaDVtME5Zc0x0alg5ZUpEZzBDdmcxMnFQTUxRejVL?=
 =?utf-8?B?WmovU01BQ0ltV2U4NklGVytET3hwYmt0UlBBd3AwaTM1UldoK0szaVVEUm9R?=
 =?utf-8?B?REE1NU9wMXBWTzBGbFlVcWZVVHhweWpuV3JHLzdRckFwcDBXb2pIU282Q3R5?=
 =?utf-8?B?Mm5NK054djROVkFtRXdzcjVvMUR0TG13aTE0UzN5dkNGaWdxcWx0L05rWU5p?=
 =?utf-8?B?TklhZFlBZGY1UnhvQzVZUURXNElFUmVyMDBlNFhwb0JScWJpSzVCeWNUdHJE?=
 =?utf-8?B?UGVIdkcxWFJEOVB6M0NnblRYYlYxa3NodXBsL3BHMUFsSzlsZlJSdW81MlZH?=
 =?utf-8?B?U3JTcHdKUGVUMUNRSHN5RlE1UEpkK0MyZktwTmhYSW5obXdrM2tacE9HRE8r?=
 =?utf-8?B?Ym5Fdnhac1EzWWE2TnVCYnRLMXlZZUdJQ1NHTXV4d0NzU0p6QmVrVGo4TzBO?=
 =?utf-8?B?M0FXRUM4akQrVVNBa1doSFhFSkpic3NUOWJRMVY5amVzVEZnOHdzbSt4Yk9v?=
 =?utf-8?B?WXhJRGJaMWc5UG1YTWd0Kzk1LzFOTVMrNnZhc0h5ODdxTm42blE4ZUFCTTdM?=
 =?utf-8?B?R01jUXhWM0JBczBRM2I0K05GaitrQktQNE9INXlVSE84UFlraUUyNCtjN2Nq?=
 =?utf-8?B?cG1sVWxUUit4UC9EbnVUcWhlZ1lPTlBjeGw4TW1OSld6YXkzWlFPU3hraTdC?=
 =?utf-8?Q?NXkeOfiALF0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6460.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzBNMmdtRjJVTzJwMFZPSHJveW54WEhHM3c5YkpoaFZpYW14RGo4UFFRbmw5?=
 =?utf-8?B?U3RWQ21kazJvMXRKclRjTWJrNGh5MVBmVGYrNS8zeUJRanplOGYrVkMrWjMw?=
 =?utf-8?B?ZzN2cTZkRERBUzdwbHlzNFk0dk1LNDFRZU5PbDFRMndJZk9mVlRhZnM1S1g4?=
 =?utf-8?B?M1BLYnQrRStHYmlNYXc3M3hiT25XNElNb2RBemdjVHNoRzR1UTdwcngycEx4?=
 =?utf-8?B?T01MWmRIZXMwQ3Zmb2plYXhyRCt6OGQ3bEE4QVMzUXpTOG5PUFNCc2laQ013?=
 =?utf-8?B?cDNzNFB6N01lUFZrd3NFem5ZbkRuRk9MalZxRE5vQ3VkanE4RzU3dElBTDE2?=
 =?utf-8?B?NFRKa215UzVySEM2dlAvdnVlb2RCdHpGYnhPZFBscUo4cUVieVRNWGwreVBK?=
 =?utf-8?B?VGJSVnRIaGhyRW42UmsvK3Q1QWdVRTR2ejRSaStVVlpXaG8raUhBeS9OM3Br?=
 =?utf-8?B?QWZobjI2M1RCa213OXRVOTgwK1FrMzRna0VyNnZ4THVoWE5BYk1Nc08xdHAv?=
 =?utf-8?B?UUhsbUdTOXpTOXp6bGNlMUdWTzNuVnpNOCsvWWlYNUtnSlc5VnM1RHB3WE1Q?=
 =?utf-8?B?ZE53TXh4YUx6M2liekx5TmRZOERDSXZSQnh4QkY1d1VpV0hWelI3TE1TaXVu?=
 =?utf-8?B?c2Y4RVFZK2pCVGNkc293cUNSTUpIVVVGOWNmWG9CcXBHRTR0bzgwVzUyd2RH?=
 =?utf-8?B?Z1FtQU90T1dOSGRiWk80Mk9CcUR6bEl1T1R0Nm9TbXV5azArK1M4WU1VNzZL?=
 =?utf-8?B?cHZ6WXhnMUplaTFIZjBWVXMvTTQ0bWhnRUd4QzY3aEVFUDZ1NkEyVms2RjJH?=
 =?utf-8?B?NlNjNHFXUjF1YXRSc1dSSURDTzQwKzlRdnVSU0tvbXA1WmNrWFVkalo0bm9w?=
 =?utf-8?B?aXdNL1ZJR3M4cUNheVVBbEp5OW9vS0N4REl3YzdwNk5vVDlWbE5kYm9iRFNO?=
 =?utf-8?B?d0ttZldxVHJoYmxGVFZidDN6dWpZb1BOZzV1bG8yTkJnVnRvM0ZITlBDOTlm?=
 =?utf-8?B?MXBCazU0bHUyOUxRVld0TGIzc3prUk8vNkxqVWRObzVCaURBak1sbHN1Tkln?=
 =?utf-8?B?ZTJCdVp6cUpySkpZT0hFUEUxU1puR3BVUnlkL012Yysyb0ZUNDFuY3ZzeTdy?=
 =?utf-8?B?M3JOMEI0czFIMjlRd1g3amZYOEhEUDdMYzdibXlKVFFzTkUxRVMxUUsvZE95?=
 =?utf-8?B?aTdVQ0h1V0kvV0xJQU9md0I5T2JZcDdvOGFLeWNoNWUreXdrazRCSUVCU0NZ?=
 =?utf-8?B?SlFKaXZNLy9lNWltNk5IWEpHQjNzQUd5TEpJZmJhakd4S0MrWlR5L25IMlRG?=
 =?utf-8?B?TGM2TkN6NW42VExqT20zdzF3cGZtZ2RuKzk4eWtFTnhOeGRhWDd2MFR1VG13?=
 =?utf-8?B?QWJVSnJLckdFN05ldG1EYWt5RHEyWnJiOWlYaE90RmpxYjJ4YmcwckRKRmEv?=
 =?utf-8?B?M1VuWjl0WEYwYzJZenN3YWxtUnVIWUFMZTV4alQ3ZGRPeGhTdnhocVlMUGtv?=
 =?utf-8?B?Z1Vzc0ZWY3duTGR0cDZldU4rRHJZL29lcDN1THpuY25sRlExVGkyVUlwSjV3?=
 =?utf-8?B?K0hXQlUzQTlxRVZYcXFXWjRIU3ZFV0NMUVVzNWt3eWxOMVZhNmhBbTRiYXhL?=
 =?utf-8?B?d0lOVURielJFVU1vZjRJcDgvclVheTdUQXhnWTR3dTlpSmpINU9KRU9ub2Z6?=
 =?utf-8?B?aDVHdUhpME02dk5ZdDVHZEJiZURCYk5LZjRKb25UdnpGZXpsZDRZZndRRzZE?=
 =?utf-8?B?M3d3S2RKQVdaVnZZY2RNb0N0dXE4dVdRdnptWW5MU2k1bGRMUFBPOSswVnFJ?=
 =?utf-8?B?QUJJZHJGRnZYSGJDaVRjbzVFcnFlYWtHWEozUXAyTU9lZ3VsZXZhc3ZjY2FU?=
 =?utf-8?B?aCt3SkJXN2ZXU1Y1eEJBTjQrM2pmc3VndFNHcGUzR2lJeEVMcDFROXVsc3pK?=
 =?utf-8?B?VUxKUHcwTHd2a0h4OTJHTFhNQ0x0SlltaEI4TjZGR1M2QXJuK3dnU3F6dVM0?=
 =?utf-8?B?Y1NUWnRCRHVkc0JvZzkvYUgwcVRmRzdObmtZWW91TUNIUHNZYmJvUE1KVFJD?=
 =?utf-8?B?WC9SeVBjTGFtTUI2WGZEaUF0Y0dtWm1wNXpVTDk1OWUzcjhPOVNvckJJUjZs?=
 =?utf-8?Q?+9+swhlelTTHleyMufPNC8eFy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a89250-af77-4917-b342-08ddc2965583
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6460.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 05:21:49.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XYCfQ8JEuSgLg9Acs1piy/fPeRfRMUoIJAC9oYjHaxw0MhrV4AzzfB3nu8awwsmZlTrifZsXCqHZLxZJ7rF7xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4291

Hello,

While running the kselftest for SEV migration (sev_migrate_tes) on 
linux-next (6.16.0-rc5-next-20250711, commit a62b7a37e6) on an AMD-based 
paltforms [Milan,Genoa,Turin], I encountered below kernel crash while 
running kvm kselftests:

[ 714.008402] BUG: kernel NULL pointer dereference, address: 
0000000000000000
[ 714.015363] #PF: supervisor read access in kernel mode
[ 714.020504] #PF: error_code(0x0000) - not-present page
[ 714.025643] PGD 11364b067 P4D 11364b067 PUD 12e195067 PMD 0
[ 714.031303] Oops: Oops: 0000 [#1] SMP NOPTI
[ 714.035487] CPU: 14 UID: 0 PID: 16663 Comm: sev_migrate_tes Not 
tainted 6.16.0-rc5-next-20250711-a62b7a37e6-42f78243e0c #1 
PREEMPT(voluntary)
[ 714.048253] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 
2.17.0 12/04/2024
[ 714.055905] RIP: 0010:_find_first_bit+0x1d/0x40
[ 714.060439] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 
48 89 f0 48 85 f6 74 2d 31 d2 eb 0d 48 83 c2 40 48 83 c7 08 48 39 c2 73 
1c <48> 8b 0f 48 85 c9 74 eb f3 48 0f bc c9 48 01 ca 48 39 d0 48 0f 47
[ 714.079184] RSP: 0018:ffffb9a769b7fdc8 EFLAGS: 00010246
[ 714.084409] RAX: 0000000000000080 RBX: ffff95e0a54fe000 RCX: 
000000000000f7ff
[ 714.091541] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 
0000000000000000
[ 714.098674] RBP: ffffb9a769b7fde0 R08: ffff95e0a54ff670 R09: 
00000000000002aa
[ 714.105807] R10: ffff95ff801b7ec0 R11: 0000000000000086 R12: 
0000000000000080
[ 714.112939] R13: 0000000000000000 R14: ffff95e0a54fe000 R15: 
ffff95e087e8ac98
[ 714.120072] FS: 00007fd51a0f5740(0000) GS:ffff95ffd53b0000(0000) 
knlGS:0000000000000000
[ 714.128156] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 714.133902] CR2: 0000000000000000 CR3: 000000014f670003 CR4: 
0000000000770ef0
[ 714.141035] PKRU: 55555554
[ 714.143750] Call Trace:
[ 714.146201] <TASK>
[ 714.148307] ? sev_writeback_caches+0x25/0x40 [kvm_amd]
[ 714.153544] sev_guest_memory_reclaimed+0x34/0x40 [kvm_amd]
[ 714.159115] kvm_arch_guest_memory_reclaimed+0x12/0x20 [kvm]
[ 714.164817] kvm_mmu_notifier_release+0x3c/0x60 [kvm]
[ 714.169896] mmu_notifier_unregister+0x53/0xf0
[ 714.174343] kvm_destroy_vm+0x12d/0x2d0 [kvm]
[ 714.178727] kvm_vm_stats_release+0x34/0x60 [kvm]
[ 714.183459] __fput+0xf2/0x2d0
[ 714.186520] fput_close_sync+0x44/0xa0
[ 714.190269] __x64_sys_close+0x42/0x80
[ 714.194024] x64_sys_call+0x1960/0x2180
[ 714.197861] do_syscall_64+0x56/0x1e0
[ 714.201530] entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 714.206579] RIP: 0033:0x7fd519efe717
[ 714.210161] Code: ff e8 6d ec 01 00 66 2e 0f 1f 84 00 00 00 00 00 0f 
1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 03 00 00 00 0f 
05 <48> 3d 00 f0 ff ff 77 41 c3 48 83 ec 18 89 7c 24 0c e8 a3 83 f8 ff
[ 714.228906] RSP: 002b:00007fffbb2193e8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000003
[ 714.236472] RAX: ffffffffffffffda RBX: 0000000002623f48 RCX: 
00007fd519efe717
[ 714.243604] RDX: 0000000000420146 RSI: 000000000041f05e RDI: 
0000000000000029
[ 714.250737] RBP: 0000000002622e80 R08: 0000000000000000 R09: 
000000000042013e
[ 714.257869] R10: 00007fd519fb83dd R11: 0000000000000246 R12: 
0000000002623ed8
[ 714.265000] R13: 0000000002623ed8 R14: 000000000042fe08 R15: 
00007fd51a147000
[ 714.272136] </TASK>
[ 714.274326] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set 
nf_tables nfnetlink sunrpc nls_iso8859_1 amd_atl intel_rapl_msr 
intel_rapl_common amd64_edac ipmi_ssif ee1004 kvm_amd kvm rapl wmi_bmof 
i2c_piix4 pcspkr acpi_power_meter efi_pstore ipmi_si k10temp i2c_smbus 
acpi_ipmi ipmi_devintf ipmi_msghandler mac_hid sch_fq_codel dmi_sysfs 
xfs mgag200 drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper 
ghash_clmulni_intel mpt3sas sha1_ssse3 raid_class drm tg3 ccp 
scsi_transport_sas sp5100_tco wmi dm_mirror dm_region_hash dm_log msr 
autofs4 aesni_intel
[ 714.336656] CR2: 0000000000000000
[ 714.339975] ---[ end trace 0000000000000000 ]---
[ 714.379956] pstore: backend (erst) writing error (-28)
[ 714.385093] RIP: 0010:_find_first_bit+0x1d/0x40
[ 714.389625] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 
48 89 f0 48 85 f6 74 2d 31 d2 eb 0d 48 83 c2 40 48 83 c7 08 48 39 c2 73 
1c <48> 8b 0f 48 85 c9 74 eb f3 48 0f bc c9 48 01 ca 48 39 d0 48 0f 47
[ 714.408370] RSP: 0018:ffffb9a769b7fdc8 EFLAGS: 00010246
[ 714.413595] RAX: 0000000000000080 RBX: ffff95e0a54fe000 RCX: 
000000000000f7ff
[ 714.420729] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 
0000000000000000
[ 714.427862] RBP: ffffb9a769b7fde0 R08: ffff95e0a54ff670 R09: 
00000000000002aa
[ 714.434992] R10: ffff95ff801b7ec0 R11: 0000000000000086 R12: 
0000000000000080
[ 714.442126] R13: 0000000000000000 R14: ffff95e0a54fe000 R15: 
ffff95e087e8ac98
[ 714.449257] FS: 00007fd51a0f5740(0000) GS:ffff95ffd53b0000(0000) 
knlGS:0000000000000000
[ 714.457344] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 714.463090] CR2: 0000000000000000 CR3: 000000014f670003 CR4: 
0000000000770ef0
[ 714.470223] PKRU: 55555554
[ 714.472936] note: sev_migrate_tes[16663] exited with irqs disabled
[ 714.479189] BUG: kernel NULL pointer dereference, address: 
0000000000000000
[ 714.486145] #PF: supervisor read access in kernel mode
[ 714.491281] #PF: error_code(0x0000) - not-present page
[ 714.496421] PGD 11364b067 P4D 11364b067 PUD 12e195067 PMD 0
[ 714.502082] Oops: Oops: 0000 [#2] SMP NOPTI
[ 714.506267] CPU: 14 UID: 0 PID: 16663 Comm: sev_migrate_tes Tainted: G 
D 6.16.0-rc5-next-20250711-a62b7a37e6-42f78243e0c #1 PREEMPT(voluntary)
[ 714.520593] Tainted: [D]=DIE
[ 714.523477] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 
2.17.0 12/04/2024
[ 714.531131] RIP: 0010:_find_first_bit+0x1d/0x40
[ 714.535662] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 
48 89 f0 48 85 f6 74 2d 31 d2 eb 0d 48 83 c2 40 48 83 c7 08 48 39 c2 73 
1c <48> 8b 0f 48 85 c9 74 eb f3 48 0f bc c9 48 01 ca 48 39 d0 48 0f 47
[ 714.554409] RSP: 0018:ffffb9a769b7fcd0 EFLAGS: 00010246
[ 714.559635] RAX: 0000000000000080 RBX: ffff95e0a54fe000 RCX: 
0000000000000000
[ 714.566768] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 
0000000000000000
[ 714.573900] RBP: ffffb9a769b7fce8 R08: ffff95e0a54ff670 R09: 
0000000080100001
[ 714.581033] R10: 0000000000020000 R11: 0000000000000000 R12: 
0000000000000080
[ 714.588165] R13: 0000000000000000 R14: ffff95e0a54fe000 R15: 
ffff95e089d95a08
[ 714.595296] FS: 0000000000000000(0000) GS:ffff95ffd53b0000(0000) 
knlGS:0000000000000000
[ 714.603381] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 714.609130] CR2: 0000000000000000 CR3: 000000014f670003 CR4: 
0000000000770ef0
[ 714.616260] PKRU: 55555554
[ 714.618963] Call Trace:
[ 714.621407] <TASK>
[ 714.623516] ? sev_writeback_caches+0x25/0x40 [kvm_amd]
[ 714.628741] sev_guest_memory_reclaimed+0x34/0x40 [kvm_amd]
[ 714.634315] kvm_arch_guest_memory_reclaimed+0x12/0x20 [kvm]
[ 714.640008] kvm_mmu_notifier_release+0x3c/0x60 [kvm]
[ 714.645088] __mmu_notifier_release+0x73/0x1e0
[ 714.649532] ? srso_alias_return_thunk+0x5/0xfbef5
[ 714.654323] ? sched_clock_cpu+0x14/0x1a0
[ 714.658338] exit_mmap+0x3b1/0x400
[ 714.661745] ? srso_alias_return_thunk+0x5/0xfbef5
[ 714.666536] ? futex_cleanup+0xb0/0x460
[ 714.670375] ? srso_alias_return_thunk+0x5/0xfbef5
[ 714.675166] ? perf_event_exit_task_context+0x33/0x280
[ 714.680307] ? srso_alias_return_thunk+0x5/0xfbef5
[ 714.685100] ? srso_alias_return_thunk+0x5/0xfbef5
[ 714.689890] ? mutex_lock+0x17/0x50
[ 714.693383] ? srso_alias_return_thunk+0x5/0xfbef5
[ 714.698177] mmput+0x6a/0x130
[ 714.701148] do_exit+0x258/0xa40
[ 714.704385] make_task_dead+0x85/0x160
[ 714.708134] rewind_stack_and_make_dead+0x16/0x20
[ 714.712951] RIP: 0033:0x7fd519efe717
[ 714.716532] Code: Unable to access opcode bytes at 0x7fd519efe6ed.
[ 714.722710] RSP: 002b:00007fffbb2193e8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000003
[ 714.730276] RAX: ffffffffffffffda RBX: 0000000002623f48 RCX: 
00007fd519efe717
[ 714.737409] RDX: 0000000000420146 RSI: 000000000041f05e RDI: 
0000000000000029
[ 714.744543] RBP: 0000000002622e80 R08: 0000000000000000 R09: 
000000000042013e
[ 714.751673] R10: 00007fd519fb83dd R11: 0000000000000246 R12: 
0000000002623ed8
[ 714.758807] R13: 0000000002623ed8 R14: 000000000042fe08 R15: 
00007fd51a147000
[ 714.765942] </TASK>
[ 714.768132] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set 
nf_tables nfnetlink sunrpc nls_iso8859_1 amd_atl intel_rapl_msr 
intel_rapl_common amd64_edac ipmi_ssif ee1004 kvm_amd kvm rapl wmi_bmof 
i2c_piix4 pcspkr acpi_power_meter efi_pstore ipmi_si k10temp i2c_smbus 
acpi_ipmi ipmi_devintf ipmi_msghandler mac_hid sch_fq_codel dmi_sysfs 
xfs mgag200 drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper 
ghash_clmulni_intel mpt3sas sha1_ssse3 raid_class drm tg3 ccp 
scsi_transport_sas sp5100_tco wmi dm_mirror dm_region_hash dm_log msr 
autofs4 aesni_intel
[ 714.830455] CR2: 0000000000000000
[ 714.833773] ---[ end trace 0000000000000000 ]---
[ 714.886371] RIP: 0010:_find_first_bit+0x1d/0x40
[ 714.890899] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 
48 89 f0 48 85 f6 74 2d 31 d2 eb 0d 48 83 c2 40 48 83 c7 08 48 39 c2 73 
1c <48> 8b 0f 48 85 c9 74 eb f3 48 0f bc c9 48 01 ca 48 39 d0 48 0f 47
[ 714.909647] RSP: 0018:ffffb9a769b7fdc8 EFLAGS: 00010246
[ 714.914871] RAX: 0000000000000080 RBX: ffff95e0a54fe000 RCX: 
000000000000f7ff
[ 714.922004] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 
0000000000000000
[ 714.929138] RBP: ffffb9a769b7fde0 R08: ffff95e0a54ff670 R09: 
00000000000002aa
[ 714.936271] R10: ffff95ff801b7ec0 R11: 0000000000000086 R12: 
0000000000000080
[ 714.943400] R13: 0000000000000000 R14: ffff95e0a54fe000 R15: 
ffff95e087e8ac98
[ 714.950527] FS: 0000000000000000(0000) GS:ffff95ffd53b0000(0000) 
knlGS:0000000000000000
[ 714.958613] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 714.964357] CR2: 0000000000000000 CR3: 000000014f670003 CR4: 
0000000000770ef0
[ 714.971490] PKRU: 55555554
[ 714.974202] note: sev_migrate_tes[16663] exited with irqs disabled
[ 714.980397] Fixing recursive fault but reboot is needed!
[ 714.985708] BUG: scheduling while atomic: sev_migrate_tes/16663/0x00000000
[ 714.992580] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 
nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct 
nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set 
nf_tables nfnetlink sunrpc nls_iso8859_1 amd_atl intel_rapl_msr 
intel_rapl_common amd64_edac ipmi_ssif ee1004 kvm_amd kvm rapl wmi_bmof 
i2c_piix4 pcspkr acpi_power_meter efi_pstore ipmi_si k10temp i2c_smbus 
acpi_ipmi ipmi_devintf ipmi_msghandler mac_hid sch_fq_codel dmi_sysfs 
xfs mgag200 drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper 
ghash_clmulni_intel mpt3sas sha1_ssse3 raid_class drm tg3 ccp 
scsi_transport_sas sp5100_tco wmi dm_mirror dm_region_hash dm_log msr 
autofs4 aesni_intel
[ 715.054914] CPU: 14 UID: 0 PID: 16663 Comm: sev_migrate_tes Tainted: G 
D 6.16.0-rc5-next-20250711-a62b7a37e6-42f78243e0c #1 PREEMPT(voluntary)
[ 715.054918] Tainted: [D]=DIE
[ 715.054920] Hardware name: Dell Inc. PowerEdge R6515/07PXPY, BIOS 
2.17.0 12/04/2024
[ 715.054921] Call Trace:
[ 715.054922] <TASK>
[ 715.054923] dump_stack_lvl+0x70/0x90
[ 715.054928] dump_stack+0x14/0x20
[ 715.054931] __schedule_bug+0x5a/0x70
[ 715.054934] __schedule+0xa0d/0xb30
[ 715.054938] ? srso_alias_return_thunk+0x5/0xfbef5
[ 715.054941] ? vprintk_default+0x21/0x30
[ 715.054944] ? srso_alias_return_thunk+0x5/0xfbef5
[ 715.054946] ? vprintk+0x1c/0x50
[ 715.054949] ? srso_alias_return_thunk+0x5/0xfbef5
[ 715.054952] do_task_dead+0x4e/0xa0
[ 715.054956] make_task_dead+0x146/0x160
[ 715.054960] rewind_stack_and_make_dead+0x16/0x20
[ 715.054962] RIP: 0033:0x7fd519efe717
[ 715.054964] Code: Unable to access opcode bytes at 0x7fd519efe6ed.
[ 715.054965] RSP: 002b:00007fffbb2193e8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000003
[ 715.054967] RAX: ffffffffffffffda RBX: 0000000002623f48 RCX: 
00007fd519efe717
[ 715.054968] RDX: 0000000000420146 RSI: 000000000041f05e RDI: 
0000000000000029
[ 715.054970] RBP: 0000000002622e80 R08: 0000000000000000 R09: 
000000000042013e
[ 715.054971] R10: 00007fd519fb83dd R11: 0000000000000246 R12: 
0000000002623ed8
[ 715.054972] R13: 0000000002623ed8 R14: 000000000042fe08 R15: 
00007fd51a147000
[ 715.054978] </TASK>


Below is the culprit commit:

commit d6581b6f2e2622f0fc350020a8e991e8be6b05d8
Author: Zheyun Shen szy0127@sjtu.edu.cn
Date: Thu May 22 16:37:32 2025 -0700

KVM: SVM: Flush cache only on CPUs running SEV guest
Link: https://lore.kernel.org/r/20250522233733.3176144-9-seanjc@google.com

The issue goes away if I revert above commit.

Regards,
Srikanth Aithal sraithal@amd.com

