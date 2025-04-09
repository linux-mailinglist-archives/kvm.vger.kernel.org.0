Return-Path: <kvm+bounces-43005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3814DA82188
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 11:59:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B93301B83CE3
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 09:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34FE025D535;
	Wed,  9 Apr 2025 09:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lu92UDqm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962F51DF247
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 09:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744192710; cv=fail; b=dPnyiYguMRbbTFiRadPY4Zbp0BbFZNrt1sGl8io3rfZmT6/Fsx2TiJ5JUtEg8+GSwEz0iO1RQJBABfnuQdITYUKrK1mS6X8VFmYZbpSuLoVKCstnUJYmTKK/ZatwAr2TBBHgkWXy8i0mNxXXc2CXHOs7PeRyaeGIFSY/pvyb4zE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744192710; c=relaxed/simple;
	bh=s3BGj+zWJyvLMKzP34r0ih+ogeqrM9qYmwX8LT7AgUg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QG1Jf+EPXNCVQS3Pw5V+ba1A/de9cB5l0xKyoXCP3VVw0qCZqYhRui8eSwZ26vmqhHCkfyciJu4Iw6NKllAa1ZyrGMCmFemN0Rjwf5spnglGW3VjkRi2VLlS4Z/z1Rj8ZoR+YDtc0pCMoDD9Jjx1NGwSRM3IPW5epJ05aJwxZUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lu92UDqm; arc=fail smtp.client-ip=40.107.244.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N8oiR3w/AXw/FzgfIH/IS2W3x0eBpF1lI8tEv/LxrqhgmX8al8qTukFemsKNp3OPvyVhsmuWXbpTCEm9P5zyi1VcPI5Ihy+JX05WNK+SdCVGocbFsrJZMYPL54STJm2pACVeA2rttzbyMPpMvMUbAnzgDWgeN2PR7OlpjQKqWVDTS60q7TFBwIfH5NMWpjRAmsgb+HEqGGkB9oywLKXBVKX2d0ogWRVhALzNuIURl7tCVYc3FsgO+rJaE7m6OSDVzU65ppj1XUUV5QquMMSilG3j47cWu+WaZt3k7m0fyfU7von37rrBrNKv79nPNqsJqQRDolVm+DjxxwbvD0m3rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DbLLpxyqS5g/aB9ZRysWB6S375JHw6isuOhDsAaGHek=;
 b=VRyJAmUomoWXmMHELRGHqqvwkmPkS2rzRsFAsZSx7zbZNqB1rSNZSIWWp1d3IaGHJUYmoM/4vTm1G3U+daGq1AL+SebdJRzgshxCwY+5a7RUDFFfBxdb6VsEb6V3wQ2CGbyHMPvEvmYmNjuXL6ldEYuSqEmj3Av5TXBD62Vn3nrsTVRBAdRozd4Q24hGlMsEuUhqO9KKdyn+cerc5IS2BkHSY0Z5PEYPo0ARrtx1+Y/RCyyglzoQT5nU6KG7Bxq1uVusRzMLkSv3szS1ybboY04pZQElvOQ76562ooUxg4EklCN8u5taQ8giXXRryQraTDzuNO0R8NbvZCQlZGB9kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DbLLpxyqS5g/aB9ZRysWB6S375JHw6isuOhDsAaGHek=;
 b=lu92UDqmpL1srMMvrLI4NOYNABnxXzT7ZR1JSedry0WVbzVR94gL7bRtoh1vEjxVyj3bD+b3MA15F2JtaHI3no9YSrU4nBAwrk+Pu0cugNYL8Wha8WTBlcI3fb6p8DoNMeXWwCEGS3QHcElIMSZy/xd7SI5RBtONuUs5kXOtfsM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.20; Wed, 9 Apr
 2025 09:58:26 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 09:58:26 +0000
Message-ID: <5d35d719-4640-4c11-9691-689d5ef38887@amd.com>
Date: Wed, 9 Apr 2025 19:58:22 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 06/13] vfio: Add the support for PrivateSharedManager
 Interface
Content-Language: en-US
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-7-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250407074939.18657-7-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVPR01CA0054.ausprd01.prod.outlook.com
 (2603:10c6:220:1fd::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 614f43cc-3efc-4376-61d9-08dd774d12a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHBMTEc4L1BkMVZGaUo4WGFFWnd3T20rM0phZWlwaXA4c0dpWmUzSURhTitr?=
 =?utf-8?B?a0lxc2VYdmFSNXRMaXVvZlYwTG9qU1UzQzluZUZYRWVUbGd2NDlXZDZxOCtJ?=
 =?utf-8?B?VTF2eE5HckFSQlM2bStSZGtQdHdCNFpsV1FXVUNXQlBSMjRJZGFQWXlkeVhj?=
 =?utf-8?B?VjFPTkRsYTI0d09hQUhXQmsxeXcrbUdWSzVQUzVBcmRGUlJTdXdtV2ZyMi9t?=
 =?utf-8?B?MitFRjBiSzZsYmJEaVFSSjlDNHpQRytJeHVMODZjTmNvZ1h1Z1UwSnZzY2No?=
 =?utf-8?B?L2RmRWYvMzlyWWd1TSswQUJOZUJGY3ZRb241TU1WRDBmdXYrNnkveUtpQkVS?=
 =?utf-8?B?dStHU1dsQkMvMGVsL3lLSUVYeEZidXB5WkZpV0IzTkM3TE9JN3Q1OXl6Yy91?=
 =?utf-8?B?RzgzWDBJMFFtalgxeVk2SzlmMTlCWUZjbDh0VFZLMzd5RVplTCswU0I3MTNF?=
 =?utf-8?B?WS9wT0I3SzZXT0lZY1loQVA4NC9KbnU1NTJRVlJqa1oreUczNlhLRTZNUjBS?=
 =?utf-8?B?VVY1ZE5oL3VYYUFLTjNmd3VVeEFVN1dMNTVmTGlUNDM5aEFTdjdtU1Bmb2d5?=
 =?utf-8?B?QkdJazczaEZvbDd1bzJHdnFJMXpBT1RCNEpvbDFqbndpQ0N6d0wvNzJnSU1t?=
 =?utf-8?B?S1pMVHRzVUNGN2UwdFpWZFpGelBDMFJnSXM4NE5YWWxBcEZ1YTdEOG5EbW5L?=
 =?utf-8?B?c0VKc0FnaEVzSExsYUI1SXd6UW9KMlEwUVJvQWZ1elpESmVPeEJid001WFA1?=
 =?utf-8?B?akM0blNsUU1EaU9OQ3FMc1ZvWitUMm1JOHRLSTNjaGpUZklUSkZvMFM1UkZH?=
 =?utf-8?B?N1ZmS0NPVGd1TXZrVVQ4L0ZuaDk2dVJTK08rQzZDOTdjUzVwZWU5OEdDY2p6?=
 =?utf-8?B?Z09nNncwUEx0QWVEZ1cvYnQvbmVjNVFOdkpsYjFFajNncW9jWXNSdlZnVm9r?=
 =?utf-8?B?SkYyRk14eFZ2NldPWWFKOFFDWnpPK1FMb2Y0aS9icjZ1ellUTFVvZDlDWDBn?=
 =?utf-8?B?c2Y5WW5NTUN0WDBqWWZZeFozSVJsS0FpSHFXR3VnaXRVaVY1eE9KYytpWTNz?=
 =?utf-8?B?ZFVQczkvTmhrZ01oY0RkamNLWW1VV0ltNkFQRjR5c1R2MVhIRmFGZ2tKZ0RK?=
 =?utf-8?B?M05nSzM1S0JuL1BuMjdzbXdFMUI3YWI3NGliZGFTM0NieVhBNm1GeGs5akRP?=
 =?utf-8?B?M1FQbDJXakdkQmdQVURFS3JveEJrZzZXMGFTUjJkSTdvaStkNGZhQUNyOVNj?=
 =?utf-8?B?TDZna2FzbnhZRTA0OGJKSWRaSjc5bDdteDJJVERJYk5MWUlYcWpXZ1BWaEhs?=
 =?utf-8?B?c1czQklWWUkwUkJoK3d5c0xTMGZrVkZXR0pkemRRQTJKUHA3TU1oeWs2ZnJp?=
 =?utf-8?B?MlRVYkJxblpBQ0NTZjh3T3Fxci9jYTZZTnZabWE0MlRqQ2dxeVlhVHdManR2?=
 =?utf-8?B?Mm1NTXgreWlNOFAvWDh1b3B6aFNhdEQwQjgzekNWNVdkSVFMM0tnQ2cwOUZh?=
 =?utf-8?B?cDVTSzAxdlJvZWZkNXA3ZEx2WEJlb3REckcwNmM3cS9jRFM2OEdBblU3ZzFD?=
 =?utf-8?B?Q0pVYzk2enpxRjRzMHhOK0hkT0I0QWhsTng3MnNNK2NISTBrZGRhQ1NTSFhH?=
 =?utf-8?B?bE0rVFE1L2JoTGM2S0tPSUR4Q1Y3STBHM2prYmJjdEpZTm1QRzEyUy9PZ1h5?=
 =?utf-8?B?T0JZaVc0aHkxblRRTFI2NnBoMmordFNtK29qOHZwMkFGRGFJL3ZqZ3ZBWU1j?=
 =?utf-8?B?b2V1STBEOExCVS9UMnlWbzh5S043cXRMeXBxOXp3c2J2YUlWZVZHQzZiaHpy?=
 =?utf-8?B?SWtCU0tSMHRFcWNZcytoZ3ZUemFUK2lhSit6WE1UWW1lWDl5OUpGTDJSaGZI?=
 =?utf-8?B?SG1vSTZhVDZvOHJzR1NUQ3pCTUQ1Ylp2R21jVFJ1bGIzVi9tMGdETjZpYjU1?=
 =?utf-8?Q?8WR5gu9zdGU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXovOGIrUWJ4cHVMaThaODduU2loRmIzSk5GWFNZZHNqOEpMTlZPQUVDc2Vn?=
 =?utf-8?B?eXdXM1M2dFh2S1pQcEFwUG5NS3RqcWtESVp0RFVBajdWWWQxNUpRWDA3ajBH?=
 =?utf-8?B?VjlpTUdKVG1MWlJwbE1lczZuVmhVMzlQcjRVakViNXBpQ1JqRXRZc3hGWWJP?=
 =?utf-8?B?M0xlRng1L1N4TFN1WFR4aldSOFIxYU50MDFZbkZQZkw1VlBZZ0R5NXU4TTNq?=
 =?utf-8?B?WDFWUVdnSkZ4TkNtSmpvYlcvdXBIT0p2R1JxWWc1WFZHRlNtOWhLbHYzQnhx?=
 =?utf-8?B?UnN3OXg0d256QlFhTHRhYTVNZjNkdjJIRm1jbHBYdGpOK0tTRGZYRWNjaERt?=
 =?utf-8?B?bzRRaWNJc1FjS1NYQkxNdENPSUQ4OTNHMnd5R0lUbFY0OTZ5TEpVU3FtUmU5?=
 =?utf-8?B?YXBwemV0cGRKL3ZQUHBJUUN3TXBYQ3hYWjdzMjhtbFBhemR1ZzlQMkNDRDBh?=
 =?utf-8?B?cEx4SVo1d3VHTDR2YkIwaS9OQXpyMHdMSUszR1c3QUdiaDBTZUNwTGF0ZTRQ?=
 =?utf-8?B?cTV2cDMxeUQ0RjFYbUpSUzNocUIzNnNXajdHZHN3TUliYXh6MTJWR1VrYStj?=
 =?utf-8?B?MW83TlFybDAvejd4UGZPTjYxUFVBSitlNHRqM2ZqbzhaNkxGUFR0VkdCQWd2?=
 =?utf-8?B?MFNienlYaVRvenkrMTByWkhYZUw5em9FS1VxZjhYUFl6YVVNZXZSZHdpMHJQ?=
 =?utf-8?B?OHh3Z3kvdzVmNGhweHQ1bTUrZ1ZNNGxBVXhldnUvVklkUUhqeTlOQTV1bXUv?=
 =?utf-8?B?TVJrdUFvY1VSYkZVLzRoV1VZazR0cmNEN2wraGNJT2RTbmZHcks4RDJVcFRu?=
 =?utf-8?B?UW5BQ3BMb1Y1VlgzN2NTcTljcEc3dERvZGdLdkVCVDVrMitTYmVoT0RUM1Fp?=
 =?utf-8?B?SFRUbjFmUmUvYU9NVk50blBrVE94ek5kMHl5ZTlGcEVITDdDSHhMeWpwclAz?=
 =?utf-8?B?UWJTWU9OSVJUaTEzakNwb05tbW9jODFUcVpoT0w4c2xzcTBpRE9IdU13My9Y?=
 =?utf-8?B?SlRIZkNWYnZSTVZrSU5Bbi9LZVgvSUNSRlVWTjk0RHZieFU1Wll2dUs1OEFQ?=
 =?utf-8?B?QWVoWDBxSUdnWVBXMENiNjB0c3cxWk1uK3hRY2xNQWx0TTlYWFh0RmRpazA5?=
 =?utf-8?B?R0c5UmxxMmJxTG9XMldob3VxK0gzdE1NdWtjcVNpTlVrMTZraHJCM3l4Vmpk?=
 =?utf-8?B?RUJEZFVNKzFQU3ZUdVVnWjk4WVNHMkQyeDNMSFQ5cW82cHpla1hvdEt2UGN2?=
 =?utf-8?B?U3hNbTVmMXV1UFQ3UE52a284T0ZoNzltbzk5RTZuRHlLQUVxMmxXNzMyaHNj?=
 =?utf-8?B?L3JqVmFsbmxoQzB0MldNMTRFL3F2TmkxVmNOOHBPeDZuK3h0blRONCs2aWIv?=
 =?utf-8?B?bmhNWmxJRWpvM3gwQmxSSkp5RktmWUFiNFk0UDZHK3VrU1NxMEgyMDJxSVpv?=
 =?utf-8?B?NitFYlFIeTBwM3FMUkZkZjdaNWdMNE9pWjBZN3kwRjQ1Q3lOTFBxeTdZb1Nl?=
 =?utf-8?B?N0MreGlTakhDUkR1Wkp4WmdIZnVmRGtXQUU0MmRSREJmbEh5MEIxYWhlWThH?=
 =?utf-8?B?Q1FsZGhNYTkvYitmNFBOUDVwREFIYXRaTm90aG90MWdmbkFRbWdlNUU5TFc1?=
 =?utf-8?B?M2FMT3U2NTZ1STFlYVV2c1FTY1JBaE4veHRxeWd3b1lWUUZGVzE0ZjAzK3M0?=
 =?utf-8?B?cjVRKzhTMkN2NDFiZjYvV1JKbEJpb2hmSGo2cDlXUngzTVR5UDFBV2RYRExq?=
 =?utf-8?B?VVpoTXk5YkNLb1dRMXpPZDFpZlE3Y2N0S2dNUkJEME1wQ3FUb0FzYmZ0SGJM?=
 =?utf-8?B?N0dZelRvOUVHdFJCai83MVlSQ1owTnFIZkxWSUhWU0YvdVN1bU93VXVMNEdi?=
 =?utf-8?B?ZmFWV1FvOVU4bTlUNU1oYlRwZC9nbnRoKzNRZWRkdThCZ2ZXOUEwNmp0aWhp?=
 =?utf-8?B?c1VPNFhCYXF5aXdjbmdtM2JEWFVUanlmMHB4aWJPUTVDTXk0WUllZm1lcnRU?=
 =?utf-8?B?RjQ5Z2srWHF2NnNqSkhuQUdmaDdBNjZXblN3YTdQL1kyTWxYdDNIZnhiRTZJ?=
 =?utf-8?B?RHZjUnVZVWI4Z3FocDFQTGMwMTltWGlGSFViNVFIODAxV0Q4ZEhxTG83bTBt?=
 =?utf-8?Q?zUDMn4VWRQn1edz2snxbvweh7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 614f43cc-3efc-4376-61d9-08dd774d12a2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 09:58:26.6400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fb3VRrtYscAw7O0tjaunID1OqYFSvIiM3DLLMrTdS3hEVroSJklwcg0FBqZO5vbFOo+YEdL15BrneJBqGTfStw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951



On 7/4/25 17:49, Chenyi Qiang wrote:
> Subsystems like VFIO previously disabled ram block discard and only
> allowed coordinated discarding via RamDiscardManager. However,
> guest_memfd in confidential VMs relies on discard operations for page
> conversion between private and shared memory. This can lead to stale
> IOMMU mapping issue when assigning a hardware device to a confidential
> VM via shared memory. With the introduction of PrivateSharedManager
> interface to manage private and shared states and being distinct from
> RamDiscardManager, include PrivateSharedManager in coordinated RAM
> discard and add related support in VFIO.

How does the new behavior differ from what 
vfio_register_ram_discard_listener() does? Thanks,


> Currently, migration support for confidential VMs is not available, so
> vfio_sync_dirty_bitmap() handling for PrivateSharedListener can be
> ignored. The register/unregister of PrivateSharedListener is necessary
> during vfio_listener_region_add/del(). The listener callbacks are
> similar between RamDiscardListener and PrivateSharedListener, allowing
> for extraction of common parts opportunisticlly.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4
>      - Newly added.
> ---
>   hw/vfio/common.c                      | 104 +++++++++++++++++++++++---
>   hw/vfio/container-base.c              |   1 +
>   include/hw/vfio/vfio-container-base.h |  10 +++
>   3 files changed, 105 insertions(+), 10 deletions(-)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index 3172d877cc..48468a12c3 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -335,13 +335,9 @@ out:
>       rcu_read_unlock();
>   }
>   
> -static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
> -                                            MemoryRegionSection *section)
> +static void vfio_state_change_notify_to_state_clear(VFIOContainerBase *bcontainer,
> +                                                    MemoryRegionSection *section)
>   {
> -    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
> -    VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
> -                                                listener);
> -    VFIOContainerBase *bcontainer = vrdl->bcontainer;
>       const hwaddr size = int128_get64(section->size);
>       const hwaddr iova = section->offset_within_address_space;
>       int ret;
> @@ -354,13 +350,28 @@ static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
>       }
>   }
>   
> -static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
> +static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
>                                               MemoryRegionSection *section)
>   {
>       RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
>       VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
>                                                   listener);
> -    VFIOContainerBase *bcontainer = vrdl->bcontainer;
> +    vfio_state_change_notify_to_state_clear(vrdl->bcontainer, section);
> +}
> +
> +static void vfio_private_shared_notify_to_private(StateChangeListener *scl,
> +                                                  MemoryRegionSection *section)
> +{
> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
> +    VFIOPrivateSharedListener *vpsl = container_of(psl, VFIOPrivateSharedListener,
> +                                                   listener);
> +    vfio_state_change_notify_to_state_clear(vpsl->bcontainer, section);
> +}
> +
> +static int vfio_state_change_notify_to_state_set(VFIOContainerBase *bcontainer,
> +                                                 MemoryRegionSection *section,
> +                                                 uint64_t granularity)
> +{
>       const hwaddr end = section->offset_within_region +
>                          int128_get64(section->size);
>       hwaddr start, next, iova;
> @@ -372,7 +383,7 @@ static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
>        * unmap in minimum granularity later.
>        */
>       for (start = section->offset_within_region; start < end; start = next) {
> -        next = ROUND_UP(start + 1, vrdl->granularity);
> +        next = ROUND_UP(start + 1, granularity);
>           next = MIN(next, end);
>   
>           iova = start - section->offset_within_region +
> @@ -383,13 +394,33 @@ static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
>                                        vaddr, section->readonly);
>           if (ret) {
>               /* Rollback */
> -            vfio_ram_discard_notify_discard(scl, section);
> +            vfio_state_change_notify_to_state_clear(bcontainer, section);
>               return ret;
>           }
>       }
>       return 0;
>   }
>   
> +static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
> +                                            MemoryRegionSection *section)
> +{
> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
> +    VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
> +                                                listener);
> +    return vfio_state_change_notify_to_state_set(vrdl->bcontainer, section,
> +                                                 vrdl->granularity);
> +}
> +
> +static int vfio_private_shared_notify_to_shared(StateChangeListener *scl,
> +                                                MemoryRegionSection *section)
> +{
> +    PrivateSharedListener *psl = container_of(scl, PrivateSharedListener, scl);
> +    VFIOPrivateSharedListener *vpsl = container_of(psl, VFIOPrivateSharedListener,
> +                                                   listener);
> +    return vfio_state_change_notify_to_state_set(vpsl->bcontainer, section,
> +                                                 vpsl->granularity);
> +}
> +
>   static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
>                                                  MemoryRegionSection *section)
>   {
> @@ -466,6 +497,27 @@ static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
>       }
>   }
>   
> +static void vfio_register_private_shared_listener(VFIOContainerBase *bcontainer,
> +                                                  MemoryRegionSection *section)
> +{
> +    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
> +    VFIOPrivateSharedListener *vpsl;
> +    PrivateSharedListener *psl;
> +
> +    vpsl = g_new0(VFIOPrivateSharedListener, 1);
> +    vpsl->bcontainer = bcontainer;
> +    vpsl->mr = section->mr;
> +    vpsl->offset_within_address_space = section->offset_within_address_space;
> +    vpsl->granularity = generic_state_manager_get_min_granularity(gsm,
> +                                                                  section->mr);
> +
> +    psl = &vpsl->listener;
> +    private_shared_listener_init(psl, vfio_private_shared_notify_to_shared,
> +                                 vfio_private_shared_notify_to_private);
> +    generic_state_manager_register_listener(gsm, &psl->scl, section);
> +    QLIST_INSERT_HEAD(&bcontainer->vpsl_list, vpsl, next);
> +}
> +
>   static void vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
>                                                    MemoryRegionSection *section)
>   {
> @@ -491,6 +543,31 @@ static void vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
>       g_free(vrdl);
>   }
>   
> +static void vfio_unregister_private_shared_listener(VFIOContainerBase *bcontainer,
> +                                                    MemoryRegionSection *section)
> +{
> +    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
> +    VFIOPrivateSharedListener *vpsl = NULL;
> +    PrivateSharedListener *psl;
> +
> +    QLIST_FOREACH(vpsl, &bcontainer->vpsl_list, next) {
> +        if (vpsl->mr == section->mr &&
> +            vpsl->offset_within_address_space ==
> +            section->offset_within_address_space) {
> +            break;
> +        }
> +    }
> +
> +    if (!vpsl) {
> +        hw_error("vfio: Trying to unregister missing RAM discard listener");
> +    }
> +
> +    psl = &vpsl->listener;
> +    generic_state_manager_unregister_listener(gsm, &psl->scl);
> +    QLIST_REMOVE(vpsl, next);
> +    g_free(vpsl);
> +}
> +
>   static bool vfio_known_safe_misalignment(MemoryRegionSection *section)
>   {
>       MemoryRegion *mr = section->mr;
> @@ -644,6 +721,9 @@ static void vfio_listener_region_add(MemoryListener *listener,
>       if (memory_region_has_ram_discard_manager(section->mr)) {
>           vfio_register_ram_discard_listener(bcontainer, section);
>           return;
> +    } else if (memory_region_has_private_shared_manager(section->mr)) {
> +        vfio_register_private_shared_listener(bcontainer, section);
> +        return;
>       }
>   
>       vaddr = memory_region_get_ram_ptr(section->mr) +
> @@ -764,6 +844,10 @@ static void vfio_listener_region_del(MemoryListener *listener,
>           vfio_unregister_ram_discard_listener(bcontainer, section);
>           /* Unregistering will trigger an unmap. */
>           try_unmap = false;
> +    } else if (memory_region_has_private_shared_manager(section->mr)) {
> +        vfio_unregister_private_shared_listener(bcontainer, section);
> +        /* Unregistering will trigger an unmap. */
> +        try_unmap = false;
>       }
>   
>       if (try_unmap) {
> diff --git a/hw/vfio/container-base.c b/hw/vfio/container-base.c
> index 749a3fd29d..ff5df925c2 100644
> --- a/hw/vfio/container-base.c
> +++ b/hw/vfio/container-base.c
> @@ -135,6 +135,7 @@ static void vfio_container_instance_init(Object *obj)
>       bcontainer->iova_ranges = NULL;
>       QLIST_INIT(&bcontainer->giommu_list);
>       QLIST_INIT(&bcontainer->vrdl_list);
> +    QLIST_INIT(&bcontainer->vpsl_list);
>   }
>   
>   static const TypeInfo types[] = {
> diff --git a/include/hw/vfio/vfio-container-base.h b/include/hw/vfio/vfio-container-base.h
> index 4cff9943ab..8d7c0b1179 100644
> --- a/include/hw/vfio/vfio-container-base.h
> +++ b/include/hw/vfio/vfio-container-base.h
> @@ -47,6 +47,7 @@ typedef struct VFIOContainerBase {
>       bool dirty_pages_started; /* Protected by BQL */
>       QLIST_HEAD(, VFIOGuestIOMMU) giommu_list;
>       QLIST_HEAD(, VFIORamDiscardListener) vrdl_list;
> +    QLIST_HEAD(, VFIOPrivateSharedListener) vpsl_list;
>       QLIST_ENTRY(VFIOContainerBase) next;
>       QLIST_HEAD(, VFIODevice) device_list;
>       GList *iova_ranges;
> @@ -71,6 +72,15 @@ typedef struct VFIORamDiscardListener {
>       QLIST_ENTRY(VFIORamDiscardListener) next;
>   } VFIORamDiscardListener;
>   
> +typedef struct VFIOPrivateSharedListener {
> +    VFIOContainerBase *bcontainer;
> +    MemoryRegion *mr;
> +    hwaddr offset_within_address_space;
> +    uint64_t granularity;
> +    PrivateSharedListener listener;
> +    QLIST_ENTRY(VFIOPrivateSharedListener) next;
> +} VFIOPrivateSharedListener;
> +
>   int vfio_container_dma_map(VFIOContainerBase *bcontainer,
>                              hwaddr iova, ram_addr_t size,
>                              void *vaddr, bool readonly);

-- 
Alexey


