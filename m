Return-Path: <kvm+bounces-48145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 40A91AC9E2B
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 11:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E8421897098
	for <lists+kvm@lfdr.de>; Sun,  1 Jun 2025 09:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA71B198E77;
	Sun,  1 Jun 2025 09:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KsZbS1n5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A53C38
	for <kvm@vger.kernel.org>; Sun,  1 Jun 2025 09:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748769690; cv=fail; b=gj33fNfGXXl3wp3x27ed3EH2/PWMQ4tOzbKQyKtcY2/jqSGmy6bFNOh9LLwm6/pXpTBDuV/Jd58/36R58KJA9oWnL5GOka789tn4zg4v0KpuWJT3obNvn3aK2iuJeG6eAPXzWGLW/2TUiz/Y0nJ4eR2TPp9z4VEY8xb3WzrMGsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748769690; c=relaxed/simple;
	bh=LEmmmCFN04IjgnL1IoupI4nW/vOkb+80U8xyNRstHsg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BTRstfZnpwjfP6DLKRApos017BELlUu1ZVwbm5VFrTAXTXZAPShGuqJvR3OUc4AMnxM29NsLxnuPWidh23UdWMF771eMimjYPmp/3mJKYH+/063Vfg3LwqVC0fjCweoKxaRZYxF36o77yBbzcluAtzO9faL6UtfB7I+Q2fZ2iIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KsZbS1n5; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LcXSp36UDCiD7DI4b/yaA8U9/Q+npZfcvJs/5BqOC7tZ1u1VTRluguKFzjh+wrpaoi0TXTjDOl52ru3EXhbIaPXbXw+NpCmZmbiLe5tD6Z1udzNPqgQCzfLcnLOAAu7PNqnSPSd17wCCxi5od3sr5MFWHsDgtv4UADgJzN7kpWaQUojQNyKkclVL1lE47BpuZIN2fHwQ4tdyP1oUJe7olJ+xrxdW/zOLJWyu7udspic4kvHnP09zkCngOjJhb+Wn4xlgUU8uvZMmLe4iKry16cbX5V4caWhXuVF5t6B8zN3ovkUF4TEA+lVXuQrvY8mAQ+NCTwf45RhNzbHXfDwjAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SJLj0oFh7XCMQqqGht59EaJy38oXetX+DQsBuDxGGqs=;
 b=ZXnIZ/0K+2z85agRbnuHz8IlAf4vsL0EJjb9qFUasQIUGK9j3sKc5My9dmB0OaIvv7OjHvw9LRadixR7iE4xkktWLGI4xo5JrbDiuASCo/LZ7KRAuW5874f2MK5szCnC1ILrhBbIS+6uSD3b2PZzF6Lg5WTdUL7OER67+53GZPSmfTnMRvhn2bySmq4KeSYAisYr1wGj9nzdMK9wpslk3PmXRVy4hSnuzuPoQ/exGq+zwQ3YSkJ3RwaIAdfAxQhHaZv0SEkC4XKZ+fAZTE2AR584ynOCo0RjsgppF+UTxgPHiOQnXBwpfuSX4Lgb2CSEP0M2/i3zMrbeRH0uBNTFNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SJLj0oFh7XCMQqqGht59EaJy38oXetX+DQsBuDxGGqs=;
 b=KsZbS1n5Z2Q7Z6bgiTAJv2sTsKAaIZhDyMYjrlUmJCLIJLhjL7gF/YUDUt0vyq4NwyMIef6ZHpjLuVgsRhFavIYMVu+aej5s666jOr+Qcf/756wG1ZY74sOdt4RacISRU/MNdJE/2mb4tHl2vOLmOPqWh0x4iaqyC1VVUKtJBRg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by IA1PR12MB6435.namprd12.prod.outlook.com (2603:10b6:208:3ad::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Sun, 1 Jun
 2025 09:21:25 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8769.031; Sun, 1 Jun 2025
 09:21:25 +0000
Message-ID: <c059609c-9f09-4058-8776-66b664e23445@amd.com>
Date: Sun, 1 Jun 2025 11:21:21 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/5] memory: Change
 memory_region_set_ram_discard_manager() to return the result
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>,
 Baolu Lu <baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>,
 =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Alex Williamson <alex.williamson@redhat.com>
References: <20250530083256.105186-1-chenyi.qiang@intel.com>
 <20250530083256.105186-3-chenyi.qiang@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250530083256.105186-3-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0261.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e8::17) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|IA1PR12MB6435:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ef0b0ee-fb7c-4857-e5ec-08dda0edae55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmFBbVd6TFRMYTIyTFRIczBwZTF2dENDRVMzdGN6b2htRnNMd3JDeEVKRldr?=
 =?utf-8?B?dWFacjdCTm9RZTNMWHRDcDREWXVqQ1l1VkZ1T0ptT2tqbk1TU1RYZHl0VlhN?=
 =?utf-8?B?d0hjUWhOR0VjZkpuQ2dwNUNCL2kwVXJjTVdFZCtYRytLZW5tYWlXSytHaERV?=
 =?utf-8?B?QVlUbTl4ZTFpL1BobktKcGlnblppNW9jaDEzUWZJd29TeHQvTFdla0FWNVoz?=
 =?utf-8?B?QUxtdk9mUm9keFFUcUZxd2hRK0VPVVN6WE1IOXN0TFBJcUltcmxkdlB2TDlZ?=
 =?utf-8?B?K1orL3o4YWV5Rk1sTjg5OFFiV1NXVkFabnZIR1RCLzBzdHhnTnFPTEFndHVL?=
 =?utf-8?B?QnBrTmxDUVRha0ZoZ1oyOGZmVWI0MkJLRHVaZ3M2WjRXMFFNTFJoemxYSmlC?=
 =?utf-8?B?STZRenJGbjU4QW00YnpTcDFWdXEzN0kvSWh2WUFObW9hUXN0Zi9rbUxUa1Ux?=
 =?utf-8?B?MTZiSkZIcnc5K0w2RnFxRVdmZnlxNWZacXRRTkxvRUIyY3YrU2tyZUFLb1Jl?=
 =?utf-8?B?c0ZKcXE2VUczcDFOazlwdFEzQVJPRVI2TC8zd0pHcDZkZmZKdXlNQk5WUGpx?=
 =?utf-8?B?MkM2R2dVd21PVmFnb2U4dmtpRGFpUlQzOTFtQ0pmZGltdUdmVUxXSWNqOGI3?=
 =?utf-8?B?Qm1WVzl0QjBhcHdaMWQ3bU9rYzRaZno0R1NCb1dyU3BKZ3VrVVZKbDE3SzQ5?=
 =?utf-8?B?MmpkVmdRQ1JldGRrbDBINzVLSTFQZkREeElwcTdNeWcvYjZwRm00dThRMk0x?=
 =?utf-8?B?UE5tQ011NkVsVjFBbEdIZzJZd2ZGNXJFNmhEeHRhS0xaY1VzSExSb05qY0NG?=
 =?utf-8?B?Rmk4Y3V4OE1QdUFrYUZQRVR3TDJGWVF5RkhqRTdPYml6SHF0R2JWMXRCYUNU?=
 =?utf-8?B?aWhhSERwbjEvZHdYclpnOTNnRzdyb2xJZEl4cllYVGFrSzFpSEd6QmZGaWhI?=
 =?utf-8?B?UzJtN1NJUmMzdkx0Z3I1MmxaQWhsMmRodlE0NUZmM2tUSkFPUDlxNVRvTGtX?=
 =?utf-8?B?U3gwZ3o0SDVUN0dBVDRJbWhwTnc0VkIyYnVPd1lyaWpBZENJMXl2SFA0a1F6?=
 =?utf-8?B?emhRZU51RzJvSTAzUG94VGlnaFVIbTRnV2RUNzl1U2FZR1NzNkNqNUszVG83?=
 =?utf-8?B?Z1ZYTzdaQnFPblM3bVpJT0oraXJTWERYdjdsWWZET1hxNEJTbElzM3lxcmlZ?=
 =?utf-8?B?S0hFWUQzdGZacFhhWWx1cEsyWGhMOStCVWJMSDdLYzZBWHJ5WXBKNkRzaGE0?=
 =?utf-8?B?VFQ4NmlXOC9LUjE1cVZyblRHM1Y2dCtJZ0YxdFQyckxibStGUHF2ZnBZZHdK?=
 =?utf-8?B?ZUwzRmdnSXFyc08rbkVlZ255dkUrZ1BmTGs2MU92bklyQjluUVVFKzRoMU40?=
 =?utf-8?B?Ymh3VmlyeVR5RnQ4Yi90a0QzcGtxVlhWN05RZ2pNUGJVNXZ6UmEyOGQrQWIx?=
 =?utf-8?B?b2dqNll3MGM4ZzkxdWUzc3hxcklUVmVxL2Jxc2xpM3pXTWgxelpHakdqdzl4?=
 =?utf-8?B?ZWxnTTA1V20xNmtvYUpEM3ZLTHlIMlFwZjZCS28rNm9Fakg1NnlXYkJ5M0pp?=
 =?utf-8?B?MFg5ejcyQ2FVU2FBdkZpdFpOclMwQTJrczgzVWxaY0tFcHBkU2l1YUtveWpH?=
 =?utf-8?B?RDA5Y0xOSlI5WDNFUXAwTW9sZjhlVFcwR3pxNGdhZkpDckxxV1JEUU9IYk1Z?=
 =?utf-8?B?TU83ZlZUZlhhYlNubHUvZ1FQK0huclNYMHhXWGlSeDBEN1U5VXF5ckl3Y3Fs?=
 =?utf-8?B?Zndqd0FiS2p0UnB4ekI0VUVHMW9xZ2QyUmlOVXZOcXJUK1RnZnliU0w2WWZa?=
 =?utf-8?B?VVBOUzBLRldCZGF3Q0pnc0Z5MGhpZnhXd2NFeVR0bFZJY3lDT283OTlkak4z?=
 =?utf-8?B?QlpiNk95ZS9jaGNvVXVHUzJPRlB1YjdmSHBtbmpqRGFGQ2toa3V5aEFndERR?=
 =?utf-8?Q?X3W7QJ23lpI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUgvSnRoSFQxZjNHSHVlYlJoNnpJcFlCM1ZzQjFJcDlibnF2V0NJTkVVRXFY?=
 =?utf-8?B?TXljeTFKeWN0S3F6aUNxeG9RYTNJNGErMGx2RWhZYlZhMlkrNVNXcXp4c2Ey?=
 =?utf-8?B?aytqb2Y5d0lVQUpyNldaT0tMdHhIdGlwdDdhbmhoYWJOd0RsRk43dDByS0Vi?=
 =?utf-8?B?S3FMdHNPVnlGSUlxWWJZN3E5S2hDNUlKL2NubFMrbFhkTGdRNmdJYXI2Uklm?=
 =?utf-8?B?MmVySm1VeERxQzF4NEc3bVNKdlZTQnQ3My9vcTVGT3p2a3ZaNFdKcWtpblpx?=
 =?utf-8?B?MzhkMXNzWU5jMUk0VlBIVy96QjNkaTVKRDdWRXVhUnFZQS93TXFsR3lwZFFK?=
 =?utf-8?B?enVUbm5nUHlnbWFMeTJ4aXd6UVAreUQybTkxbEhXOXBub1VrUGNlRkVFbkti?=
 =?utf-8?B?dTlWOWJYYysrU0RpK2gxSzlVb3VoRnFRZXZybWVDWHFYN3REYkNVYkE3VnN6?=
 =?utf-8?B?L0xhcEZPejJiT2JXRjBvc2FEQlBkak5NOUVyeHQ0ekJNL0FqeDZyNWNBMmRt?=
 =?utf-8?B?MEVPQ2w1M1U5azJJdmJpTnlsVGZkYnRnQVhDeWhVOTJwU2VNVXhhWFkrRGxv?=
 =?utf-8?B?MWNNWkVuRnpOeVh0eklUSmZ1dkJYMlg3aHpodnZiNExCc3h2ZlBJYm5tcXVs?=
 =?utf-8?B?OGJzb2h4RnRQMTdzNGhsSXQ5TEloVWVrUTRiSGE3Z3pJWHFUNGY1SXNRZVBx?=
 =?utf-8?B?bXV0QS9HVTRMbnhhSDVETTF5N291bG1HWTViV1RnVkpJZVkvTGROTjZoTGp0?=
 =?utf-8?B?b1dNNkFqN1A1NmVIM3AySXY4c0d6emlFdlF5bXBlMDZkYm5mdkpVMThvRUcr?=
 =?utf-8?B?RUlOMkpHUkpMNVUxcDZFZENCckVaYlVHdzBNYkxoSXB3NkZuN1FuNWxXWnVk?=
 =?utf-8?B?c0RhL1hQRW5JSGs4c29yeTJ6ZXg4azZvNFdqZFM3cTc1aVVZemI0TVNQRS80?=
 =?utf-8?B?YXpvaGdyWW0xa25pRzNJamJ2aE9tOHY4bFR4ZjIzMVZvS012M0E1M3I5SnEv?=
 =?utf-8?B?Q0ErcE1WMFVIMkhCVDl4VXpmOC9uSXFiM1JCZ0tPTFVuQUlsNkpId2pxRWRL?=
 =?utf-8?B?SkRkQlFCelljTDkyak9JK3hMbEljMmY1Wlo0OHBVMVI4VmRFcGZWcVhEZGFJ?=
 =?utf-8?B?bE0rVW9qNkM0ZlBaZWUyeWx2ZHl4Um55azZGNWFqZ3pibnlkdnNvakpBYXF3?=
 =?utf-8?B?R3NCUW5tQkdvWGF4c09PMi9xdVR2SjgzN0hxS3BsNDhpWW9Vb2F5bTI4TENz?=
 =?utf-8?B?b0swVmV5YXVBME9nWld5K0Yrc2x0enFua0QzaWhpL1cwQlBlNVZydStXTjJs?=
 =?utf-8?B?cXFFUWswM0R6djhKVStWUHhwb2VIanQvZnlZZEE1OUduNHRicmx3Y1pkb0k5?=
 =?utf-8?B?UzFIRDN0SXF3RThZRUY2OXRwUzQ5a1Z4aTVYTjkxMWpHNHF1WnplMytyQ3lv?=
 =?utf-8?B?aWZTOEU5dTlRampKZ3dGUm1KODZXNVZMVmVXVFM5QW9ndnAvRnFWa1k5WWdM?=
 =?utf-8?B?Z3o4NldMc1JxV2NoMzkxVHhJZjZ5d1Q3a25kenQ4V1ZhUGRVWVFVRmJyTysv?=
 =?utf-8?B?WkZiVnJRbCtuOTRwQlFkUnROdGx1Z2dZZ1k3c2pkZTR0QWIvVkhGNkYzZXgx?=
 =?utf-8?B?YU9nVCtEdmNIVkdIU0lhMWdXaFpObm8wZ1l2Rktpeis0dGczNVlvYjdSeU9T?=
 =?utf-8?B?S3dUYlRUSjY1S1QySGlVSHZmWkRaT0t1WkJ3SFpkcEFuc3E2WHpqNDN2QjNO?=
 =?utf-8?B?a3lPQytkcGt5Z0tHMEVrTTl5Qk5YVU1vTmlWUEJyR3Bib0kramtKMUtwQU1k?=
 =?utf-8?B?ekh5bm43dUZXNTVuZ0pJQzJaQnFQVlExUktVNkNkOThWUkpjRitQdENhN2hL?=
 =?utf-8?B?aHhmNkdXdFhNd2czNUVZQ3ArdExhQ1gvVDYrRDk3UW9QZkEwb1lWeFVLRXla?=
 =?utf-8?B?cndYUVRLdVc0QllEajQza3AraTNqcncvaENsV09PQUpuU1lqV3YzZ24xbXFp?=
 =?utf-8?B?Z0EyVDJkTDhwWlM1ZVdPYklKejFqL3FkTkcwdXN4VkRERzFPRHpKSUV0dEJW?=
 =?utf-8?B?M1EyY2JKdEVvaldUQ2VnL0ladklxaTVMMzhxdEpORlVHNUpuRGJGUWlwdEpD?=
 =?utf-8?Q?5JenTA70lXAZIU9OaAemdSLVI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef0b0ee-fb7c-4857-e5ec-08dda0edae55
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2025 09:21:25.2250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcYu1et2Qpp3T1jnaHtAf+aPaJygecYZHbGg2Q3zLRTxjhjD8K/6Ot0oIn9asorSI8UjmENO+ejIN3VPYldFlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6435


> Modify memory_region_set_ram_discard_manager() to return -EBUSY if a
> RamDiscardManager is already set in the MemoryRegion. The caller must
> handle this failure, such as having virtio-mem undo its actions and fail
> the realize() process. Opportunistically move the call earlier to avoid
> complex error handling.
> 
> This change is beneficial when introducing a new RamDiscardManager
> instance besides virtio-mem. After
> ram_block_coordinated_discard_require(true) unlocks all
> RamDiscardManager instances, only one instance is allowed to be set for
> one MemoryRegion at present.
> 
> Suggested-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
> Changes in v6:
>      - Add Reviewed-by from David.
> 
> Changes in v5:
>      - Nit in commit message (return false -> -EBUSY)
>      - Add set_ram_discard_manager(NULL) when ram_block_discard_range()
>        fails.
> 
> Changes in v3:
>      - Move set_ram_discard_manager() up to avoid a g_free()
>      - Clean up set_ram_discard_manager() definition
> ---
>   hw/virtio/virtio-mem.c  | 30 +++++++++++++++++-------------
>   include/system/memory.h |  6 +++---
>   system/memory.c         | 10 +++++++---
>   3 files changed, 27 insertions(+), 19 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index b3c126ea1e..2e491e8c44 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -1047,6 +1047,17 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>           return;
>       }
>   
> +    /*
> +     * Set ourselves as RamDiscardManager before the plug handler maps the
> +     * memory region and exposes it via an address space.
> +     */
> +    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> +                                              RAM_DISCARD_MANAGER(vmem))) {
> +        error_setg(errp, "Failed to set RamDiscardManager");
> +        ram_block_coordinated_discard_require(false);
> +        return;
> +    }
> +
>       /*
>        * We don't know at this point whether shared RAM is migrated using
>        * QEMU or migrated using the file content. "x-ignore-shared" will be
> @@ -1061,6 +1072,7 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>           ret = ram_block_discard_range(rb, 0, qemu_ram_get_used_length(rb));
>           if (ret) {
>               error_setg_errno(errp, -ret, "Unexpected error discarding RAM");
> +            memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>               ram_block_coordinated_discard_require(false);
>               return;
>           }
> @@ -1122,13 +1134,6 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>       vmem->system_reset = VIRTIO_MEM_SYSTEM_RESET(obj);
>       vmem->system_reset->vmem = vmem;
>       qemu_register_resettable(obj);
> -
> -    /*
> -     * Set ourselves as RamDiscardManager before the plug handler maps the
> -     * memory region and exposes it via an address space.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> -                                          RAM_DISCARD_MANAGER(vmem));
>   }
>   
>   static void virtio_mem_device_unrealize(DeviceState *dev)
> @@ -1136,12 +1141,6 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       VirtIODevice *vdev = VIRTIO_DEVICE(dev);
>       VirtIOMEM *vmem = VIRTIO_MEM(dev);
>   
> -    /*
> -     * The unplug handler unmapped the memory region, it cannot be
> -     * found via an address space anymore. Unset ourselves.
> -     */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
> -
>       qemu_unregister_resettable(OBJECT(vmem->system_reset));
>       object_unref(OBJECT(vmem->system_reset));
>   
> @@ -1154,6 +1153,11 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>       virtio_del_queue(vdev, 0);
>       virtio_cleanup(vdev);
>       g_free(vmem->bitmap);
> +    /*
> +     * The unplug handler unmapped the memory region, it cannot be
> +     * found via an address space anymore. Unset ourselves.
> +     */
> +    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
>       ram_block_coordinated_discard_require(false);
>   }
>   
> diff --git a/include/system/memory.h b/include/system/memory.h
> index b961c4076a..896948deb1 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -2499,13 +2499,13 @@ static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
>    *
>    * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
>    * that does not cover RAM, or a #MemoryRegion that already has a
> - * #RamDiscardManager assigned.
> + * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
>    *
>    * @mr: the #MemoryRegion
>    * @rdm: #RamDiscardManager to set
>    */
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm);
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm);
>   
>   /**
>    * memory_region_find: translate an address/size relative to a
> diff --git a/system/memory.c b/system/memory.c
> index 63b983efcd..b45b508dce 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2106,12 +2106,16 @@ RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
>       return mr->rdm;
>   }
>   
> -void memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                           RamDiscardManager *rdm)
> +int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> +                                          RamDiscardManager *rdm)
>   {
>       g_assert(memory_region_is_ram(mr));
> -    g_assert(!rdm || !mr->rdm);
> +    if (mr->rdm && rdm) {
> +        return -EBUSY;
> +    }
> +
>       mr->rdm = rdm;
> +    return 0;
>   }
>   
>   uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,


