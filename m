Return-Path: <kvm+bounces-48386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 01749ACDC45
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:04:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B54C7A3EFE
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 11:03:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE4428DF15;
	Wed,  4 Jun 2025 11:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="xA8F+FhL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1A97262F
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 11:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749035055; cv=fail; b=twFOpemC/YGyEYfGH9CXZ2P7XeqSGub+UYnrzWjFXM8snuukXA2ws7uJG6eS8RRA2UT0rNMHnBiuFS7WuulBzVImon+MAq4DK4SD/k2SVM//cD/6f843SJnJbWm/gP7dojcHiLdG0P5UXyPiNDi1hD8XZBOze7N9F6l+m6hj8JY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749035055; c=relaxed/simple;
	bh=OgqJVljWCXaY3HEOfFEchYiHgBTZgA2YvrZ3BmZjnj8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=slx4CuxNjGXuHpIIMvkOLEp684f7eptxgRdG9buttEaTgkbTMAFce1GESl7qKdPLsx6WjxmPVLAoOdH4bUHwfLbvwPylxD8mHG0xG0x6HgrtXwAjqmlLWcI5pQ+yYdeipc8ut6BKLGrurLg7YUECJHNhBoniGc497sWFzGesTMk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=xA8F+FhL; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lAxyMGysc5xBrLZvkAvfbjp1nYGOxDQZUdmDWoK2BNqNa5dcMuzX4uSU8nl+Jl8p0qAtfIxWWDPE6L5lPxShmvvwQSlOQOOsvpIVtt9m/RrtsbQyr2/Th5ATArzstfHZOnzEd4Gu+GuEgkA8CCnSSm9EEoxGD2MGK8Jkn3yRcN3Q8kuBtE+mfMdsie++2TA3tBad6pZf4HX9bfpj9NueUy9EoDl2w+yf0YrnzdHAD+VEfJiurVTrbu/Bkz2zKnmZlckB3Gu/fcQ2o5suzv412N2EDo1oaGjxmttJTo9VnxD9EZN3auOVfLzjy8q6KO9SFjHV/lpZ1jsP6Kb3RZQ+MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDL2JJfGEob0QnOZ/jqKotc6TwIY/xHMxgnFXjLQ8YU=;
 b=gsBUtOoDJVjj3ISaxYvqpprU93C4J+5dAn4SJIM7y5uyt+A9D1X3to2oAbvfAM3d3xA16LFV9YhqPxMOoQ83xNjXfDXNm1T2ebKDCQpCq4A0IkK/O0LQhLTYU6Q5gQij+fZHVVqM5p1anaRaDsgWAn4JM7zh4m/da3X0h61i1mVSTnbF+yrxncDSzlHS5ifBuI7DcF2XbiWupdzEfhjY++KoXCBZXK51C0D5NYPNxIZZa89lpTgmez9dbomwKMcdaveg8wYCCE+1+y9QWHwZURWKALptTqTCGCEVH5snJj3r2lBxOcGlsrF6cMr0EAn1mt7tyjDZKx4RincdFcJoMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDL2JJfGEob0QnOZ/jqKotc6TwIY/xHMxgnFXjLQ8YU=;
 b=xA8F+FhLXOjiki0Xx3GehcHP/1ud0fCtwDUPzmPAb7rxlQ44MjGhXztV2G6y9hG6AtP68CXJKBHK3V+PIDCb9N+1VAx4m1Va1A1deizrH9rgjWCet0Z5PSKz1Kx+s2LIoMshioHOOLgeVi/5NImEGHjXtvfhYVhdCrDb65wHSDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 4 Jun
 2025 11:04:10 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8769.037; Wed, 4 Jun 2025
 11:04:08 +0000
Message-ID: <55ebb008-a26f-4173-937a-3bb2d8a6c972@amd.com>
Date: Wed, 4 Jun 2025 21:04:01 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v6 4/5] ram-block-attributes: Introduce RamBlockAttributes
 to manage RAMBlock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>,
 Gupta Pankaj <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-5-chenyi.qiang@intel.com>
Content-Language: en-US
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250530083256.105186-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5P300CA0070.AUSP300.PROD.OUTLOOK.COM
 (2603:10c6:10:247::26) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: b5e05108-a572-4b30-b287-08dda3578725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S3RCL0gyYkxqWEdOYk1IQVY5eEwzSUpMSXNJODFPdzR5dFNqNGYvUVliRFZI?=
 =?utf-8?B?Y1Azd1BWZVRVTkxaWEFoaG1CSWZSNWR1UnJ4WFBjbEZsZU4wYVdKT3h5RGRI?=
 =?utf-8?B?VmpOMzQzUkZsOU5YN29TT2dMNnBlMXduNnkwYU0xaWZzWXhrSlltN2Jod2Jv?=
 =?utf-8?B?QW54S3Y3ZVZPd3JZNy9JamlqbXl4MElOVWJCMmJOOUN6NDZaRndnMDE4ZTFv?=
 =?utf-8?B?bWQzdFNIaDFhTDdRTlIwSFh4ZkxTYTBMUnJ0ODlhUGVuUW5ZemVJeWJIVHpX?=
 =?utf-8?B?YlRGaGRGS0VxaW0zd1AxVmRCMjl4QWNZZGtVaFl3WUVRbHd3QnM2NE5Lczk1?=
 =?utf-8?B?N3B4TXlsU0ZCOHZOUzRxTnlRQzIxR3dDZEVxemV6ZkpGT2ZGcGZ4QlZjcVhX?=
 =?utf-8?B?endtMEl4WDZLT2dBdUtnY2dzeFpVeTFZanpOenl2S2M2ZkIwL0lNVVNSRXAy?=
 =?utf-8?B?RmlvQk5WSm02SkhiaTdCcmlYV3NZMWR3cm1wQklQa1dVTzFEMkRHbk0xTGxh?=
 =?utf-8?B?emJ0aHRHamgzejFxSFpZb2JsQ0lCV2lHQzFXWHZJTm1Ba2RkQjVOR29FcWJn?=
 =?utf-8?B?Rlg1RUI1dFFrVjBpT2oyWU4rL2pEcXdsTjJLTW5wUVZ4cjd3dGdIaFJLYTZi?=
 =?utf-8?B?MlhKMlF0ZlFUYUNGM1BTUng0Z29BWXhzaGhQaE45OEc2dUtORGJqdGpoM2kr?=
 =?utf-8?B?VU1PaEcrckxuZ21UN0licUpWbHp5azhBL3gwcUpjendpVVB5bCticEtEbnFq?=
 =?utf-8?B?UHYzekZXbkdCeTYzOVVPV3l4NThtWitTUzhTZG1KTmNUTllITWJ0ZGRrL3RJ?=
 =?utf-8?B?VUJBSHpOVnhzMkZ3ZjRrZ09RK0ZkcVkwSHcza2NtNUpoVWFrR0dSOG1LRCtr?=
 =?utf-8?B?QzlVcmZGNnpPZjU0dlVaRVoxUDRyaVB6OXNFTTBjd3l0dVRiRGhhVkl2ZkMx?=
 =?utf-8?B?Ym5wVm15N1hweDRCZDllb0haQUxmeTNQOFI3VDJuL1M5NXVlQ3o4WHVhQWlB?=
 =?utf-8?B?bTNPS2xpRWkzcmhZcjRwcit3VlBtQVRNdytJTjZtT0dlOVpVWWdXYzNFQXZH?=
 =?utf-8?B?dmIxbzNOdzhQV20zOERDcHBQRGNkRXZNRWZ0WjRKL2M1a3h1a2hhbnI4VStT?=
 =?utf-8?B?UE03R0RrVzd4ZTZ5K3JmYWxBb3VseStTcmZkVFR3bERCT3dBU0hhV1RzUGlk?=
 =?utf-8?B?SUhiYllnZnBOakZyVG93cks2R2REV2QxdVVsUmEvL2pLWTI2MnczMXdlUlFv?=
 =?utf-8?B?YVFMWG9JZkprMStJTENBOUpwWnA2aXFnc0t4S0QzdEI3bFdKSXpWc1ZhdWhl?=
 =?utf-8?B?dTFtN25RUFowVTZablpTWHRtYlViVVFXKzcydFNOQzlYOHB2RVV4bkdnaHk4?=
 =?utf-8?B?TTRVWHYyYlBrL1RmQzRjSHlTQlM2eGc3NGNiS2xheGsxaXFtTDVQazhYZkV2?=
 =?utf-8?B?MEg1WlllQ3lGYTFxTFJFZTVORWhHRkpTc3ZqNU84c1AweXRxSk5IWUllZ2Vn?=
 =?utf-8?B?WU1OZ3ovUUM2N3BrTTk0VzBxYzc2d1Zsc2c5MFhLSzQ3eTd1enlTdmJqaGFV?=
 =?utf-8?B?Ry9EbDJ5azFzSVlnTjc1c2tncnoxR0NMTmxKb3FQdHM4REVuU0RuL2FsOGNv?=
 =?utf-8?B?U0ZmVnFPbS9qdTZtTFM5c0FqSnR4bWxRazI1cis0MmkwcHlkWEM5YmpES0V6?=
 =?utf-8?B?a1BCNmpZc3NmU2FDeDhicTNDekxJaTZScUdUdTZ1SCtrazMvd0hjZmgvS0R6?=
 =?utf-8?B?bDdNNFU4SFVmcnJYbkc0V2NoRzhoaWQ1VDZIWTcrL0VSbi9YUGVPNHNDZVZU?=
 =?utf-8?B?UjRXQStTTytNako1bUYreTUveWUxVUo4dkRyZWFSVHBKQ3FFREl5allxVXo5?=
 =?utf-8?B?cnRoVWpYQjFLN3g2QUEvcTZQOGRiZnRWamtwUzVpbWc1SHhFQWRIenFFN1Bj?=
 =?utf-8?Q?YO9Elmm7sH4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWpnWWVWRElqNDhoNFk0dmhOSkJVWEdFZ1VYdTRHak9nWG5HYjdJSTFYTEww?=
 =?utf-8?B?NVF4QXUvNlFCT2c5SDF1K1MyM3NZczY4TGQ2QjFIZTdOemU2OFdzeXI1NHAz?=
 =?utf-8?B?UlYyaE5yMW5Yak5JK1krekZ4Nk80SG16Zm9uYTY5L1d5NFhHZlpiWmIrdGpE?=
 =?utf-8?B?MDBLQnJLbE96dndQRC9MOUFYSUpwV2FKWC9hUmFJMzEzeXVXQ3VwNXZFcWYv?=
 =?utf-8?B?RUVHYWMvcG85ZnBrMjlQMUQ3bDJRaEtsSUNaSkEwVlBUU285ZFcvUngwbVgw?=
 =?utf-8?B?NkNnQnY1akVHdTAva0xLd0pzcTB0QzlqZzlGMHd3T2c4T3cxYVZHU05nTnIz?=
 =?utf-8?B?bklUYXh5Sm0yeWdHeTdnSmQvU0JPbkFsM1JEUGpITHRNbDlkbmI2V1RGUVZ3?=
 =?utf-8?B?dEU3VVNIaXF3WWdUaStNN1NEWjVSMWRtZGpwSkxaSlV3b1NjL2lKYkJFa0Zx?=
 =?utf-8?B?V0kvdE9SZGtkTUJuT2lnTnpLNjNrVDdFcHBpWGJ6a2ZOM2VuTFRqMlIxMVph?=
 =?utf-8?B?YUYxenhzZ0IzbjhpMGhKcE1UdnhCcHNyZHZhR014aTVyZUw1aEpVMXlFWlF4?=
 =?utf-8?B?Ly9QZGUyZHNNRU1UTWFZT2tFeUlmYnBrdVY5SWZWU2ZTNTBQdDRnUk1ocm1u?=
 =?utf-8?B?Q3NSNnF3UHc5OVhYSnpnejV5SXlxUFNScTBScHhzc1U4TU82c3ovSmZkN2lG?=
 =?utf-8?B?S1R0NnQrZXVwQ0EyS3pqUHlrZS9YT3ZNZ0JqYUNWdzROQm9XUnRFajA2QjRQ?=
 =?utf-8?B?T1d3bmIrZ2R2aDNlS0ZtWHM3U1VrV28xOFNTK3Fld0FBR08yMWVmZGlIdFF1?=
 =?utf-8?B?SldITGhYOXpQSnp1V096NTFpV0dxWTh0TkY0cWIrQk1odzFIcUl2ZXUvdDcv?=
 =?utf-8?B?enhlTTMwNEdBSUswU2ZqR3g2a2FzWWVVajBseWl3S1YxMFlNWGlRZGtnRU5k?=
 =?utf-8?B?QVVSN3YwZ1R4Ty9BTnp5S09lQlRWZ3lRaVNvcndFdkhnTWZ0NHBJdUZ4dXBB?=
 =?utf-8?B?MXV4eUZ0aW51VTBJV1Npa0dHREVRVk90TXhDRlFyZUZqVUdudm9QUWxwRkJ5?=
 =?utf-8?B?Ui9CZTNxeWZZTFA1dEdIVTNMdGZQT1N4N24vcE9yQVA4OWttdGYvVkF0RVpu?=
 =?utf-8?B?OEU4ZmFrb2VnMVJnekp2MEd3K2hnRWFkWnNmM25pTFB0cGlJQi9YcE1wT1Vs?=
 =?utf-8?B?ckJqTWRmUUFHeklCalJxQVhCdnFJQ0pDN1NZdllRb2l0cklMTC9PQU5iTWtX?=
 =?utf-8?B?am9JRVV4QlNibUFIbzd5eGE5NGpFUDZHYmhWVkc0V28zd2tPTE9BSW5nSklE?=
 =?utf-8?B?TnhIK290ekxabXZpbUFKUk4yNEFFZFRmZHE1aE5ZR0JJbjN5cHBkcityU3JK?=
 =?utf-8?B?VUxiTkxiNHFzU0szMTR3NHg1SjJ1cTZMeHBpb0ZMYnZGVUxrbU5wd29jZHVX?=
 =?utf-8?B?L25UNHZVVURTekJkdW4rU0lYQ3pmaStmb3E3U3JzZXg0aFFsak1wYXFSbHV4?=
 =?utf-8?B?SkE4QW5Ed2RmZ1pqbGRid0JxbXJrcGtsa1FJS1BvRit0TGord2ZZSzgxRlU1?=
 =?utf-8?B?Qjh1WDkvOWxVdW1iVmNnZUxKYko1aURDT25Sa1JaRVRwZUdFeDlkaXZIdVFD?=
 =?utf-8?B?bEJXNnV5SERkcHpnNGt2TkJsU1pXWVBKNHJXZjd4WWVPS1NKc3FKejB6RXRI?=
 =?utf-8?B?MFJ4VyszUWFVVjlXVFZXdWMwdEtXbmZVNWx3ajlKY3dQTHZnUHdXL25oWG9z?=
 =?utf-8?B?dmZwSFlYZ2xMV0hSK3MwNExzZEpVbkpXdzBQS2hLZmsxVWRiUmlXamxFTXoz?=
 =?utf-8?B?Yk82ZkR5VXpIY0tjRkRMVy9CMEVxaFFXejlRS1NkRUxMN1pNZU1zVitOc25O?=
 =?utf-8?B?R3ZWNSt3WGdZamtvclVPNUNEVjdISkk4YVgvNGcyQ3JiNFBJSFBRdjc1NENv?=
 =?utf-8?B?TFdJb1VRVm9hZDdsTUNseTRHSUJUQno5MGFHbXIyTk92QWJmdnVuRHRrdFhl?=
 =?utf-8?B?K0VKTGNkRmdSV3BDQTU4bndjKzFtaTM5bGFsOHBQZDRlYmZoeGRtMVR6WkRJ?=
 =?utf-8?B?ODdhaStyalNkMUlxd1hZeDJ6a0RURmVQSlluczhSNWVKR2l4SXg1NjN4c2tQ?=
 =?utf-8?Q?hWbWDvxjXyQIqST44vMp8skFT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e05108-a572-4b30-b287-08dda3578725
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 11:04:08.5868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwCuCTpint1sToli0Uu+UeJ0QvDPC+i6zMRRWvuigZ9cgORvlwyHlnTxxiqOff7hQrsTJrxCEcxT/fKsQ5rHbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444



On 30/5/25 18:32, Chenyi Qiang wrote:
> Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
> discard") highlighted that subsystems like VFIO may disable RAM block
> discard. However, guest_memfd relies on discard operations for page
> conversion between private and shared memory, potentially leading to
> the stale IOMMU mapping issue when assigning hardware devices to
> confidential VMs via shared memory. To address this and allow shared
> device assignement, it is crucial to ensure the VFIO system refreshes
> its IOMMU mappings.
> 
> RamDiscardManager is an existing interface (used by virtio-mem) to
> adjust VFIO mappings in relation to VM page assignment. Effectively page
> conversion is similar to hot-removing a page in one mode and adding it
> back in the other. Therefore, similar actions are required for page
> conversion events. Introduce the RamDiscardManager to guest_memfd to
> facilitate this process.
> 
> Since guest_memfd is not an object, it cannot directly implement the
> RamDiscardManager interface. Implementing it in HostMemoryBackend is
> not appropriate because guest_memfd is per RAMBlock, and some RAMBlocks
> have a memory backend while others do not. Notably, virtual BIOS
> RAMBlocks using memory_region_init_ram_guest_memfd() do not have a
> backend.
> 
> To manage RAMBlocks with guest_memfd, define a new object named
> RamBlockAttributes to implement the RamDiscardManager interface. This
> object can store the guest_memfd information such as bitmap for shared
> memory and the registered listeners for event notification. In the
> context of RamDiscardManager, shared state is analogous to populated, and
> private state is signified as discarded. To notify the conversion events,
> a new state_change() helper is exported for the users to notify the
> listeners like VFIO, so that VFIO can dynamically DMA map/unmap the
> shared mapping.
> 
> Note that the memory state is tracked at the host page size granularity,
> as the minimum conversion size can be one page per request and VFIO
> expects the DMA mapping for a specific iova to be mapped and unmapped
> with the same granularity. Confidential VMs may perform partial
> conversions, such as conversions on small regions within larger ones.
> To prevent such invalid cases and until DMA mapping cut operation
> support is available, all operations are performed with 4K granularity.
> 
> In addition, memory conversion failures cause QEMU to quit instead of
> resuming the guest or retrying the operation at present. It would be
> future work to add more error handling or rollback mechanisms once
> conversion failures are allowed. For example, in-place conversion of
> guest_memfd could retry the unmap operation during the conversion from
> shared to private. For now, keep the complex error handling out of the
> picture as it is not required.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v6:
>      - Change the object type name from RamBlockAttribute to
>        RamBlockAttributes. (David)
>      - Save the associated RAMBlock instead MemoryRegion in
>        RamBlockAttributes. (David)
>      - Squash the state_change() helper introduction in this commit as
>        well as the mixture conversion case handling. (David)
>      - Change the block_size type from int to size_t and some cleanup in
>        validation check. (Alexey)
>      - Add a tracepoint to track the state changes. (Alexey)
> 
> Changes in v5:
>      - Revert to use RamDiscardManager interface instead of introducing
>        new hierarchy of class to manage private/shared state, and keep
>        using the new name of RamBlockAttribute compared with the
>        MemoryAttributeManager in v3.
>      - Use *simple* version of object_define and object_declare since the
>        state_change() function is changed as an exported function instead
>        of a virtual function in later patch.
>      - Move the introduction of RamBlockAttribute field to this patch and
>        rename it to ram_shared. (Alexey)
>      - call the exit() when register/unregister failed. (Zhao)
>      - Add the ram-block-attribute.c to Memory API related part in
>        MAINTAINERS.
> 
> Changes in v4:
>      - Change the name from memory-attribute-manager to
>        ram-block-attribute.
>      - Implement the newly-introduced PrivateSharedManager instead of
>        RamDiscardManager and change related commit message.
>      - Define the new object in ramblock.h instead of adding a new file.
> ---
>   MAINTAINERS                   |   1 +
>   include/system/ramblock.h     |  21 ++
>   system/meson.build            |   1 +
>   system/ram-block-attributes.c | 480 ++++++++++++++++++++++++++++++++++
>   system/trace-events           |   3 +
>   5 files changed, 506 insertions(+)
>   create mode 100644 system/ram-block-attributes.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6dacd6d004..8ec39aa7f8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3149,6 +3149,7 @@ F: system/memory.c
>   F: system/memory_mapping.c
>   F: system/physmem.c
>   F: system/memory-internal.h
> +F: system/ram-block-attributes.c
>   F: scripts/coccinelle/memory-region-housekeeping.cocci
>   
>   Memory devices
> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
> index d8a116ba99..1bab9e2dac 100644
> --- a/include/system/ramblock.h
> +++ b/include/system/ramblock.h
> @@ -22,6 +22,10 @@
>   #include "exec/cpu-common.h"
>   #include "qemu/rcu.h"
>   #include "exec/ramlist.h"
> +#include "system/hostmem.h"
> +
> +#define TYPE_RAM_BLOCK_ATTRIBUTES "ram-block-attributes"
> +OBJECT_DECLARE_SIMPLE_TYPE(RamBlockAttributes, RAM_BLOCK_ATTRIBUTES)
>   
>   struct RAMBlock {
>       struct rcu_head rcu;
> @@ -91,4 +95,21 @@ struct RAMBlock {
>       ram_addr_t postcopy_length;
>   };
>   
> +struct RamBlockAttributes {
> +    Object parent;
> +
> +    RAMBlock *ram_block;
> +
> +    /* 1-setting of the bitmap represents ram is populated (shared) */
> +    unsigned bitmap_size;
> +    unsigned long *bitmap;
> +
> +    QLIST_HEAD(, RamDiscardListener) rdl_list;
> +};
> +
> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block);
> +void ram_block_attributes_destroy(RamBlockAttributes *attr);
> +int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t offset,
> +                                      uint64_t size, bool to_discard);
> +
>   #endif
> diff --git a/system/meson.build b/system/meson.build
> index c2f0082766..2747dbde80 100644
> --- a/system/meson.build
> +++ b/system/meson.build
> @@ -17,6 +17,7 @@ libsystem_ss.add(files(
>     'dma-helpers.c',
>     'globals.c',
>     'ioport.c',
> +  'ram-block-attributes.c',
>     'memory_mapping.c',
>     'memory.c',
>     'physmem.c',
> diff --git a/system/ram-block-attributes.c b/system/ram-block-attributes.c
> new file mode 100644
> index 0000000000..514252413f
> --- /dev/null
> +++ b/system/ram-block-attributes.c
> @@ -0,0 +1,480 @@
> +/*
> + * QEMU ram block attributes
> + *
> + * Copyright Intel
> + *
> + * Author:
> + *      Chenyi Qiang <chenyi.qiang@intel.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +#include "qemu/error-report.h"
> +#include "system/ramblock.h"
> +#include "trace.h"
> +
> +OBJECT_DEFINE_SIMPLE_TYPE_WITH_INTERFACES(RamBlockAttributes,
> +                                          ram_block_attributes,
> +                                          RAM_BLOCK_ATTRIBUTES,
> +                                          OBJECT,
> +                                          { TYPE_RAM_DISCARD_MANAGER },
> +                                          { })
> +
> +static size_t
> +ram_block_attributes_get_block_size(const RamBlockAttributes *attr)
> +{
> +    /*
> +     * Because page conversion could be manipulated in the size of at least 4K
> +     * or 4K aligned, Use the host page size as the granularity to track the
> +     * memory attribute.
> +     */
> +    g_assert(attr && attr->ram_block);
> +    g_assert(attr->ram_block->page_size == qemu_real_host_page_size());
> +    return attr->ram_block->page_size;
> +}
> +
> +
> +static bool
> +ram_block_attributes_rdm_is_populated(const RamDiscardManager *rdm,
> +                                      const MemoryRegionSection *section)
> +{
> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    const uint64_t first_bit = section->offset_within_region / block_size;
> +    const uint64_t last_bit = first_bit + int128_get64(section->size) / block_size - 1;
> +    unsigned long first_discarded_bit;
> +
> +    first_discarded_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
> +                                           first_bit);
> +    return first_discarded_bit > last_bit;
> +}
> +
> +typedef int (*ram_block_attributes_section_cb)(MemoryRegionSection *s,
> +                                               void *arg);
> +
> +static int
> +ram_block_attributes_notify_populate_cb(MemoryRegionSection *section,
> +                                        void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    return rdl->notify_populate(rdl, section);
> +}
> +
> +static int
> +ram_block_attributes_notify_discard_cb(MemoryRegionSection *section,
> +                                       void *arg)
> +{
> +    RamDiscardListener *rdl = arg;
> +
> +    rdl->notify_discard(rdl, section);
> +    return 0;
> +}
> +
> +static int
> +ram_block_attributes_for_each_populated_section(const RamBlockAttributes *attr,
> +                                                MemoryRegionSection *section,
> +                                                void *arg,
> +                                                ram_block_attributes_section_cb cb)
> +{
> +    unsigned long first_bit, last_bit;
> +    uint64_t offset, size;
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    int ret = 0;
> +
> +    first_bit = section->offset_within_region / block_size;
> +    first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
> +                              first_bit);
> +
> +    while (first_bit < attr->bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_bit * block_size;
> +        last_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
> +                                      first_bit + 1) - 1;
> +        size = (last_bit - first_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s",
> +                         __func__, strerror(-ret));
> +            break;
> +        }
> +
> +        first_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
> +                                  last_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static int
> +ram_block_attributes_for_each_discarded_section(const RamBlockAttributes *attr,
> +                                                MemoryRegionSection *section,
> +                                                void *arg,
> +                                                ram_block_attributes_section_cb cb)
> +{
> +    unsigned long first_bit, last_bit;
> +    uint64_t offset, size;
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    int ret = 0;
> +
> +    first_bit = section->offset_within_region / block_size;
> +    first_bit = find_next_zero_bit(attr->bitmap, attr->bitmap_size,
> +                                   first_bit);
> +
> +    while (first_bit < attr->bitmap_size) {
> +        MemoryRegionSection tmp = *section;
> +
> +        offset = first_bit * block_size;
> +        last_bit = find_next_bit(attr->bitmap, attr->bitmap_size,
> +                                 first_bit + 1) - 1;
> +        size = (last_bit - first_bit + 1) * block_size;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            break;
> +        }
> +
> +        ret = cb(&tmp, arg);
> +        if (ret) {
> +            error_report("%s: Failed to notify RAM discard listener: %s",
> +                         __func__, strerror(-ret));
> +            break;
> +        }
> +
> +        first_bit = find_next_zero_bit(attr->bitmap,
> +                                       attr->bitmap_size,
> +                                       last_bit + 2);
> +    }
> +
> +    return ret;
> +}
> +
> +static uint64_t
> +ram_block_attributes_rdm_get_min_granularity(const RamDiscardManager *rdm,
> +                                             const MemoryRegion *mr)
> +{
> +    const RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +
> +    g_assert(mr == attr->ram_block->mr);
> +    return ram_block_attributes_get_block_size(attr);
> +}
> +
> +static void
> +ram_block_attributes_rdm_register_listener(RamDiscardManager *rdm,
> +                                           RamDiscardListener *rdl,
> +                                           MemoryRegionSection *section)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    int ret;
> +
> +    g_assert(section->mr == attr->ram_block->mr);
> +    rdl->section = memory_region_section_new_copy(section);
> +
> +    QLIST_INSERT_HEAD(&attr->rdl_list, rdl, next);
> +
> +    ret = ram_block_attributes_for_each_populated_section(attr, section, rdl,
> +                                    ram_block_attributes_notify_populate_cb);
> +    if (ret) {
> +        error_report("%s: Failed to register RAM discard listener: %s",
> +                     __func__, strerror(-ret));
> +        exit(1);
> +    }
> +}
> +
> +static void
> +ram_block_attributes_rdm_unregister_listener(RamDiscardManager *rdm,
> +                                             RamDiscardListener *rdl)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    int ret;
> +
> +    g_assert(rdl->section);
> +    g_assert(rdl->section->mr == attr->ram_block->mr);
> +
> +    if (rdl->double_discard_supported) {
> +        rdl->notify_discard(rdl, rdl->section);
> +    } else {
> +        ret = ram_block_attributes_for_each_populated_section(attr,
> +                rdl->section, rdl, ram_block_attributes_notify_discard_cb);
> +        if (ret) {
> +            error_report("%s: Failed to unregister RAM discard listener: %s",
> +                         __func__, strerror(-ret));
> +            exit(1);
> +        }
> +    }
> +
> +    memory_region_section_free_copy(rdl->section);
> +    rdl->section = NULL;
> +    QLIST_REMOVE(rdl, next);
> +}
> +
> +typedef struct RamBlockAttributesReplayData {
> +    ReplayRamDiscardState fn;
> +    void *opaque;
> +} RamBlockAttributesReplayData;
> +
> +static int ram_block_attributes_rdm_replay_cb(MemoryRegionSection *section,
> +                                              void *arg)
> +{
> +    RamBlockAttributesReplayData *data = arg;
> +
> +    return data->fn(section, data->opaque);
> +}
> +
> +static int
> +ram_block_attributes_rdm_replay_populated(const RamDiscardManager *rdm,
> +                                          MemoryRegionSection *section,
> +                                          ReplayRamDiscardState replay_fn,
> +                                          void *opaque)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == attr->ram_block->mr);
> +    return ram_block_attributes_for_each_populated_section(attr, section, &data,
> +                                            ram_block_attributes_rdm_replay_cb);
> +}
> +
> +static int
> +ram_block_attributes_rdm_replay_discarded(const RamDiscardManager *rdm,
> +                                          MemoryRegionSection *section,
> +                                          ReplayRamDiscardState replay_fn,
> +                                          void *opaque)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(rdm);
> +    RamBlockAttributesReplayData data = { .fn = replay_fn, .opaque = opaque };
> +
> +    g_assert(section->mr == attr->ram_block->mr);
> +    return ram_block_attributes_for_each_discarded_section(attr, section, &data,
> +                                            ram_block_attributes_rdm_replay_cb);
> +}
> +
> +static bool
> +ram_block_attributes_is_valid_range(RamBlockAttributes *attr, uint64_t offset,
> +                                    uint64_t size)
> +{
> +    MemoryRegion *mr = attr->ram_block->mr;
> +
> +    g_assert(mr);
> +
> +    uint64_t region_size = memory_region_size(mr);
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +
> +    if (!QEMU_IS_ALIGNED(offset, block_size) ||
> +        !QEMU_IS_ALIGNED(size, block_size)) {
> +        return false;
> +    }
> +    if (offset + size <= offset) {
> +        return false;
> +    }
> +    if (offset + size > region_size) {
> +        return false;
> +    }
> +    return true;
> +}
> +
> +static void ram_block_attributes_notify_discard(RamBlockAttributes *attr,
> +                                                uint64_t offset,
> +                                                uint64_t size)
> +{
> +    RamDiscardListener *rdl;
> +
> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +        rdl->notify_discard(rdl, &tmp);
> +    }
> +}
> +
> +static int
> +ram_block_attributes_notify_populate(RamBlockAttributes *attr,
> +                                     uint64_t offset, uint64_t size)
> +{
> +    RamDiscardListener *rdl;
> +    int ret = 0;
> +
> +    QLIST_FOREACH(rdl, &attr->rdl_list, next) {
> +        MemoryRegionSection tmp = *rdl->section;
> +
> +        if (!memory_region_section_intersect_range(&tmp, offset, size)) {
> +            continue;
> +        }
> +        ret = rdl->notify_populate(rdl, &tmp);
> +        if (ret) {
> +            break;
> +        }
> +    }
> +
> +    return ret;
> +}
> +
> +static bool ram_block_attributes_is_range_populated(RamBlockAttributes *attr,
> +                                                    uint64_t offset,
> +                                                    uint64_t size)
> +{
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
> +    unsigned long found_bit;
> +
> +    found_bit = find_next_zero_bit(attr->bitmap, last_bit + 1,
> +                                   first_bit);
> +    return found_bit > last_bit;
> +}
> +
> +static bool
> +ram_block_attributes_is_range_discarded(RamBlockAttributes *attr,
> +                                        uint64_t offset, uint64_t size)
> +{
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long last_bit = first_bit + (size / block_size) - 1;
> +    unsigned long found_bit;
> +
> +    found_bit = find_next_bit(attr->bitmap, last_bit + 1, first_bit);
> +    return found_bit > last_bit;
> +}
> +
> +int ram_block_attributes_state_change(RamBlockAttributes *attr,
> +                                      uint64_t offset, uint64_t size,
> +                                      bool to_discard)
> +{
> +    const size_t block_size = ram_block_attributes_get_block_size(attr);
> +    const unsigned long first_bit = offset / block_size;
> +    const unsigned long nbits = size / block_size;
> +    bool is_range_discarded, is_range_populated;

Can be reduced to "discarded" and "populated".

> +    const uint64_t end = offset + size;
> +    unsigned long bit;
> +    uint64_t cur;
> +    int ret = 0;
> +
> +    if (!ram_block_attributes_is_valid_range(attr, offset, size)) {
> +        error_report("%s, invalid range: offset 0x%lx, size 0x%lx",
> +                     __func__, offset, size);
> +        return -EINVAL;
> +    }
> +
> +    is_range_discarded = ram_block_attributes_is_range_discarded(attr, offset,
> +                                                                 size);

See - needlessly long line.

> +    is_range_populated = ram_block_attributes_is_range_populated(attr, offset,
> +                                                                 size);

If ram_block_attributes_is_range_populated() returned (found_bit*block_size), you could tell from a single call if it is populated (found_bit == size) or discarded (found_bit == 0), otherwise it is a mix (and dump just this number in the tracepoint below).

And then ditch ram_block_attributes_is_range_discarded() which is practically cut-n-paste. And then open code ram_block_attributes_is_range_populated().

These two are not used elsewhere anyway.

> +
> +    trace_ram_block_attributes_state_change(offset, size,
> +                                            is_range_discarded ? "discarded" :
> +                                            is_range_populated ? "populated" :
> +                                            "mixture",
> +                                            to_discard ? "discarded" :
> +                                            "populated");


I'd just dump 3 numbers (is_range_discarded, is_range_populated, to_discard) in the tracepoint as:

ram_block_attributes_state_change(uint64_t offset, uint64_t size, int discarded, int populated, int to_discard) "offset 0x%"PRIx64" size 0x%"PRIx64" discarded=%d populated=%d to_discard=%d"



> +    if (to_discard) {
> +        if (is_range_discarded) {
> +            /* Already private */
> +        } else if (is_range_populated) {
> +            /* Completely shared */
> +            bitmap_clear(attr->bitmap, first_bit, nbits);
> +            ram_block_attributes_notify_discard(attr, offset, size);
> +        } else {
> +            /* Unexpected mixture: process individual blocks */
> +            for (cur = offset; cur < end; cur += block_size) {

imho a little bit more accurate to:

for (bit = first_bit; bit < first_bit + nbits; ++bit) {

as you already have calculated first_bit, nbits...

> +                bit = cur / block_size;

... and drop this ...

> +                if (!test_bit(bit, attr->bitmap)) {
> +                    continue;
> +                }
> +                clear_bit(bit, attr->bitmap);
> +                ram_block_attributes_notify_discard(attr, cur, block_size);

.. and do: ram_block_attributes_notify_discard(attr, bit * block_size, block_size);

Then you can drop @cur which is used in one place inside the loop.


> +            }
> +        }
> +    } else {
> +        if (is_range_populated) {
> +            /* Already shared */
> +        } else if (is_range_discarded) {
> +            /* Complete private */

s/Complete/Completely/

> +            bitmap_set(attr->bitmap, first_bit, nbits);
> +            ret = ram_block_attributes_notify_populate(attr, offset, size);
> +        } else {
> +            /* Unexpected mixture: process individual blocks */
> +            for (cur = offset; cur < end; cur += block_size) {
> +                bit = cur / block_size;
> +                if (test_bit(bit, attr->bitmap)) {
> +                    continue;
> +                }
> +                set_bit(bit, attr->bitmap);
> +                ret = ram_block_attributes_notify_populate(attr, cur,
> +                                                           block_size);
> +                if (ret) {
> +                    break;
> +                }
> +            }
> +        }
> +    }
> +
> +    return ret;
> +}
> +
> +RamBlockAttributes *ram_block_attributes_create(RAMBlock *ram_block)
> +{
> +    uint64_t bitmap_size;

Not really needed.

> +    const int block_size  = qemu_real_host_page_size();
> +    RamBlockAttributes *attr;
> +    int ret;
> +    MemoryRegion *mr = ram_block->mr;
> +
> +    attr = RAM_BLOCK_ATTRIBUTES(object_new(TYPE_RAM_BLOCK_ATTRIBUTES));
> +
> +    attr->ram_block = ram_block;
> +    ret = memory_region_set_ram_discard_manager(mr, RAM_DISCARD_MANAGER(attr));
> +    if (ret) {

Could just "if (memory_region_set_ram_discard_manager(...))".

> +        object_unref(OBJECT(attr));
> +        return NULL;
> +    }
> +    bitmap_size = ROUND_UP(mr->size, block_size) / block_size;
> +    attr->bitmap_size = bitmap_size;
> +    attr->bitmap = bitmap_new(bitmap_size);
> +
> +    return attr;
> +}
> +
> +void ram_block_attributes_destroy(RamBlockAttributes *attr)
> +{
> +    if (!attr) {


Rather g_assert().


> +        return;
> +    }
> +
> +    g_free(attr->bitmap);
> +    memory_region_set_ram_discard_manager(attr->ram_block->mr, NULL);
> +    object_unref(OBJECT(attr));
> +}
> +
> +static void ram_block_attributes_init(Object *obj)
> +{
> +    RamBlockAttributes *attr = RAM_BLOCK_ATTRIBUTES(obj);
> +
> +    QLIST_INIT(&attr->rdl_list);
> +}

Not used.

> +
> +static void ram_block_attributes_finalize(Object *obj)

Not used.

Besides these two, feel free to ignore other comments :)

Otherwise,

Tested-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>


> +{
> +}
> +
> +static void ram_block_attributes_class_init(ObjectClass *klass,
> +                                            const void *data)
> +{
> +    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
> +
> +    rdmc->get_min_granularity = ram_block_attributes_rdm_get_min_granularity;
> +    rdmc->register_listener = ram_block_attributes_rdm_register_listener;
> +    rdmc->unregister_listener = ram_block_attributes_rdm_unregister_listener;
> +    rdmc->is_populated = ram_block_attributes_rdm_is_populated;
> +    rdmc->replay_populated = ram_block_attributes_rdm_replay_populated;
> +    rdmc->replay_discarded = ram_block_attributes_rdm_replay_discarded;
> +}
> diff --git a/system/trace-events b/system/trace-events
> index be12ebfb41..82856e44f2 100644
> --- a/system/trace-events
> +++ b/system/trace-events
> @@ -52,3 +52,6 @@ dirtylimit_state_finalize(void)
>   dirtylimit_throttle_pct(int cpu_index, uint64_t pct, int64_t time_us) "CPU[%d] throttle percent: %" PRIu64 ", throttle adjust time %"PRIi64 " us"
>   dirtylimit_set_vcpu(int cpu_index, uint64_t quota) "CPU[%d] set dirty page rate limit %"PRIu64
>   dirtylimit_vcpu_execute(int cpu_index, int64_t sleep_time_us) "CPU[%d] sleep %"PRIi64 " us"
> +
> +# ram-block-attributes.c
> +ram_block_attributes_state_change(uint64_t offset, uint64_t size, const char *from, const char *to) "offset 0x%"PRIx64" size 0x%"PRIx64" from '%s' to '%s'"



-- 
Alexey


