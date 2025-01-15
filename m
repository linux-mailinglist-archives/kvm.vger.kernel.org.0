Return-Path: <kvm+bounces-35500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E4EFA1183E
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 05:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 974CD161F6C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 04:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0110722DF82;
	Wed, 15 Jan 2025 04:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HnQifrQI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44022054E9
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 04:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736913970; cv=fail; b=RKfsWtwV8Qlftpybj8Bvz64U4LeFIcIq/siQ92kGW/DmdxxAtTvCEf7yDaRX0/VWHStX6cxm5zMXfIR8WzVHjWvtExE6Bnk0CcDdegxcyHwfCKHIboYFgCSgvRZNmpQj1FvtKtO5UUXN7jw/g32FCI9hxHVV8YJUs70RGeCE2vU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736913970; c=relaxed/simple;
	bh=sKhqh4Md5kforhifguJmV7eIGw6sV+EO3lBGfiHImlE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HsAv1RIZpu+9pnctpgzIYJhLrIEbfQid/rBqU6UO9x/5D79TTqNzmWX6lg9x8EFvHtSN0sPiN2OVgsbbqvUmZw7dlS799qsVmWfmdW02ggYtkK5ywlPhty2dL8SJ+2MLFtIclUiu1hU4ep4M3ZinCEJIAeZrnc2nXLu01bHwQbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HnQifrQI; arc=fail smtp.client-ip=40.107.92.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6yOeGJRz6Fufrbfe7GdkBXof1va2YdgVOAUNR6zTOMbMtfpm8DCe9ctyh+paPmiw/JxYmdaaKDbqsbsjdQkub6lZzAfINlRlt1kQwFut/kGUdYQ2wYmnVX5M2PJYWF8UI2sPOqeTf34X+ZACpHZZ28bdCiNXKcExyUWXoEHxWxw/RuPgt7YsefakzdARGxPvUPp6WACNCzUejL5dU6d+l9ckVNfGlqvtD/A/hvjjXu2nBLKjcGaODA12BcW7vQSioM3xXFQUG5SHyZjBgzV+hBmxsTMGCwMatRYEv9tI+k+v+pQYl0v14U9N3avtD6FARnWLcwMb33GukZXqhOxSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAhllwBcLhchcWR4CgdXzZkxl6GzNDdAACbspfu9hFE=;
 b=mey+dG8N/xoyoKUf8E0+iusRDHjY47rsJ0NqO9uh7smFTC2vZjsB1C1uFy9/LNMIf4YswhJujF2X4W11CqJrmFnjuv6+hV5UMmICMoKK1/tplTRw+8rGB4EZ0V8zxkESDTqmy64OZUs6XnthNxzbHCcHr/pAJk06474ytBSsWOmMWAetm5qg9Ki++NlXW8X0vGPzYwc1UqbB2JkQ1eA+0IfHN9wiBUFSHmDHYGshfk4DperZXe6FKl6Ufuhsmx+I8mBik7Fxsf+S2wXggvERvJvz7VKxiyFx1hNCuY2PtCR3kwK4PxfV8aT4poSoKp3locqO6QGhKl4izPj2zZBwkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAhllwBcLhchcWR4CgdXzZkxl6GzNDdAACbspfu9hFE=;
 b=HnQifrQIR8553XAgkfbrZcHtYzaA8bg848ZMUrLm1+AfRIdOVBNNBRWzNKlgT9iueBnXl+yNQyc6Sr5FqTr0ce9HI+n+iNbqw2h/U/pVPgFrGYTok2blm8+zriqwnvVY/ZpRwIM9nD39Qw3I9ljxeUjMOsxJ5+5ijExJGyJxrMk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH8PR12MB6915.namprd12.prod.outlook.com (2603:10b6:510:1bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Wed, 15 Jan
 2025 04:06:02 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 04:06:02 +0000
Message-ID: <c1723a70-68d8-4211-85f1-d4538ef2d7f7@amd.com>
Date: Wed, 15 Jan 2025 15:05:53 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>,
 Chenyi Qiang <chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-3-chenyi.qiang@intel.com>
 <d0b30448-5061-4e35-97ba-2d360d77f150@amd.com>
 <80ac1338-a116-48f5-9874-72d42b5b65b4@intel.com>
 <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <9dfde186-e3af-40e3-b79f-ad4c71a4b911@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: OS7PR01CA0190.jpnprd01.prod.outlook.com
 (2603:1096:604:250::12) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH8PR12MB6915:EE_
X-MS-Office365-Filtering-Correlation-Id: cabb585a-3883-44b9-2ba5-08dd3519ecf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bUdaQ1VmVVBraWtka29xbTByWW5Nc1NuTmhHb1A3RlF0dWw2QUJSK0Q3ZW1B?=
 =?utf-8?B?VDlvejdKSDZTTDJZV2lTNi82NnVWSm1IMTc5dUZ3anI2VjhveEUwMC96YU1S?=
 =?utf-8?B?aWtVU0c0cmNUZFZlNUR6NzhwOThibThwQ0dlUDFtdkZlS083NXJCK21Vanh4?=
 =?utf-8?B?U1gyT0RRTys5cWZRTThZeS9QVzNmVnRHZC8vdUU4QkVMZXBZQ2wyc0JxTGlm?=
 =?utf-8?B?cTZwUHlTUnVyN0lMWlU2a0Y2YVh2RWMrWTZISXlVQkIvZkRLUTRRR0lHcm5h?=
 =?utf-8?B?MkJDeU5VdGlCT0xKTlphY0Iyb1doa3M4QmhPL3NMS0tsb0lpVDAxWlFEYjIx?=
 =?utf-8?B?M05xMlZ3bEh0akkwQXUvaDlTMXF0Um1CS1o4STlsdXczWkFKSlo3R0t3Z3NQ?=
 =?utf-8?B?QWFGL1NYMzh1ZWhXVGZrbDlsUG5YdnZvbjRBeVJ3REFkNi94VEFacElSenY3?=
 =?utf-8?B?VW9vZkM4R1JCNVIvVmpZZjRLZzV0S01MVUNoaEduZEw5czVnMjdnSHRCRDhy?=
 =?utf-8?B?UFFWQ0F3MlJ0bHovMGI1aW14bkxiZzc3bDdNYVA1ai9OSmRkK2d3aVpJQmtG?=
 =?utf-8?B?cEdtUHV5bkNYUW9XSWNaV3YyeFprYVlmbU1wZi9KTlRUeUNZZ3lrKzlFUi9R?=
 =?utf-8?B?UlUxbENlQ3YrZFFJenBSY29lRHhIYWFOODlsNTBrSWVnZCtVdlJTYXNxalB4?=
 =?utf-8?B?SHFpZytVdVdEcWZsUkxnSGRlVm9UYVUxM3NRRXNLZzlDbk9HNnVzZWdNUUFG?=
 =?utf-8?B?VWRaZzcwU3Z0SEludThWWTlBQjVrcU13dE4wVFlSWEtuNjZiSENhL2FtM0ln?=
 =?utf-8?B?S1hLV3d2MmZab21NOFVZNW1ZQWVoSW9WeGNUWnp4WGNrc21IdUhsZDlXWFJL?=
 =?utf-8?B?V0ptMmFEekJnbStWNTRtZGlTdmMvTG8vWEJiRWo1Q0NYakFhaXVmRnNrYlZE?=
 =?utf-8?B?MjFjTUE3WmxFVCtrL3RBSmR3aGVVNi9hUHZGUjIzWG1TbjZKY1d2WG9wU21X?=
 =?utf-8?B?Wm1zQ1VrUGNxRXNKOTZBc05iNE15RWJYT0ZGZ3pVbW5PUkNNRm1SRlR6bWYv?=
 =?utf-8?B?WThHRzRiN1JVd2g2WDlMNVAwbFFYT0c0ZDMwdHFDNFAwWExYL1VCMU8xdjdi?=
 =?utf-8?B?Y2F3YWlrcjZyUzZrblUzaDkwMzZIUXpFU3JPbCtSdVdOczhPRUlLcG84NHZW?=
 =?utf-8?B?NEN0VWltZ2VPVEVBYzJrWTl0TDUyTDQyWlZJSlFQMHV1VGcvdU4vcTN0a2Zl?=
 =?utf-8?B?UHowMmY4b29VVUp3alBwMi9lbWhtNzhUVzFFZnJsUHovQi9LeFpYYTBsS2Ev?=
 =?utf-8?B?ek5xc3VYcG5TTUR4MVhtR0NmaFFGaCszOWNRblRWQmVDdFZMbHdBSXJQRTRE?=
 =?utf-8?B?TFVLa0J2Q3RrV3ViT09XQ0lDUFRkVElPT3ZjK0QvZG9maGlTbTM3L1dLanMv?=
 =?utf-8?B?WWNvQUdSR1JRUVZveXRkd0xicmtLTkRONXd6ZElIcHN4NVZpMVpVN0g5c1N5?=
 =?utf-8?B?cDVvb1p6V2lJVzM2cVJJT1JoUzRsbE1VR29vSk5wbjlxTTV3WUIyclJiRVUy?=
 =?utf-8?B?VDlGZUJlM2VXK3NrUGxZY0xYT0cxbU1vcWVCWnc0Zi9CaXJmNFhSRThyVXBt?=
 =?utf-8?B?Q0pUVTVCSTBLb3ZPcHd3TWdBM2ZOYll6TTE3SGY0S1hSMisrZ0NXajY2d3RG?=
 =?utf-8?B?VElGclNXRXBHRlkvdDVzRDNobEkwS3N2ZGtSVitMa2c3SkIvZXpENHpVR3Zk?=
 =?utf-8?B?SkNEeVRqa1hYQTNBU1c2SExXcGxiaEt0VVA2a0lmOVhKMEEvRzljM2N4MkZt?=
 =?utf-8?B?SDE3enI4YkhaTDRjWUdiVk5JWlRCMVRFN1VVRUxwTU0zR3YwWkk0ZHlXYTBH?=
 =?utf-8?Q?bqT2PUrOvYgrP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDVLVWFlN1BJNlNZY1RDUzlnbmg1QjlhcGE2Y2c5Q1g2eFpLa1lPN2J4ZnlE?=
 =?utf-8?B?Q1hEUUhqbXh6QTBJdHZ0cnpSOWJ3L3BQOXo1azk2ejh5WkRBeEJaRXRwWWNG?=
 =?utf-8?B?N3Y2Zm9sU0h2bkNpMEx0dHVqQnhjaFhkSDlCNG1FdzhEV1Rsd1ZXKzNZcEJQ?=
 =?utf-8?B?by9zUS9JWHFUTE90Kzd4a3VndEVOcTFpNmc3dzIzY0h4SUVHV0dMSXdpRHgy?=
 =?utf-8?B?TEhyWmRjZExsQWpuTzdOZG1XOENNenpqRER2YzgwNi8ySEFZeDVQaTlqQS9I?=
 =?utf-8?B?c1BBUmZTWWlmRVB4S0FYTXRVWjJwMnk2dXJYUk5sbUFxbU5pVU1ZVTlRMVY2?=
 =?utf-8?B?T3p0ZzVvVWNTeXIyYmcrd1BxVDdEZEZQSVoxYzZzMjd3bjRleTFCZ2p3TzNO?=
 =?utf-8?B?eDc3R3B0bjNRb3M4T3BtQ1FjL2NYTUNXaFpZRkdIWmpGeXphRWdhbnhqeWZE?=
 =?utf-8?B?YWJNMEM4b1FBa1pRcUhxY0pPODJlSC9UdnVnVU45ZFFoM1B2Y0ZJRlE3ZTlh?=
 =?utf-8?B?OTAvL2ZGTldPL0xsL3ZudExKdW0wc3c2MGxMY3RzcDE1azJFc2k0REEzZEk1?=
 =?utf-8?B?RDZPRjVuNk1wMWFDNmdNUEwvVnhUSGtmdDY0bmZEeDRaUlF2YW9Mc2VhNEww?=
 =?utf-8?B?ekdObWhHS1FFNUJtVUVhdW1RaStMaW9DNWk3VzRxTXhpSzdKWk1pSjhRYXJL?=
 =?utf-8?B?cFAzOE5uaXhpbFpNRnlxT0VpckthTXYzTHoxQ0gxL1BsWUc2S08wUzh3MEZ4?=
 =?utf-8?B?SkdLNjY4YUNSaHRBaEhoT21xTjV0QTdRU1gwMk9MMXJsRUlsUW4rSEh1UDNy?=
 =?utf-8?B?SUJhWURGV1E0NUUvZ3VYM1RSK1hVYm5BaWFxUm5yV1VIdHdQZ3E0OU1GbHBG?=
 =?utf-8?B?aVlQWmNkOW90dVRsU0UrRTM1SE1WVTJwSElpZFJGOEtQekdhOUgwT25aOWNV?=
 =?utf-8?B?c3lwakQwTWZLekpPVWNDODUrQ044OWJHQy83UGc3c3VNSWpwdmdHcDhOdFAy?=
 =?utf-8?B?QXRxR1RMcVhvZ2NOd0Jrc2pCZUFJekRkRTRZUG1SL2lNT05jWnIrNE5UNkg4?=
 =?utf-8?B?ZUN5cEIxamxPWUtyL05Zb0NEbmZOU3ZkODJwMnFWZTh1bC9URUpBMHpYUm9T?=
 =?utf-8?B?dUxCZWxrZVlpbS9DNloySzMwZWlVRnF6dmdnU0N6ZFhPV0RJazdrL2tqNmFB?=
 =?utf-8?B?UFpsTTRCU3hVL1IxYzIvMEVkYlNkR01QL1FxemhQanRDendoQ3dsM3MzcWdY?=
 =?utf-8?B?ZDJ3dWFjc2RYTkJYYVdlc25DY2dRQ3IreVN2c1B3aXZzc1BRZ1Ara1Z5NmNZ?=
 =?utf-8?B?a3B1WWJGUG9LeUhCQTYvYWZRNHB5K29IYytEQStLdGQrYXAwOW9zS2grR3lK?=
 =?utf-8?B?VHNKU1kyTTduV3JETjBtN0ZrN3NhMUlNOGVZSEswaG05QnJ0ZkNmRE00bXlz?=
 =?utf-8?B?MVFZV0t1NW0rNzVnZ0JGQnlzbzdGakJwRDJ5citCNTI5SXNpTFZHQklrdmxI?=
 =?utf-8?B?dzVKRHpKSVZmVUw5c3RFMXhWZzBJUFUvY3RxTmRXbERPZmhubWNiRG5wMEdL?=
 =?utf-8?B?eUEzUDZHeW9PZlFubzNNbU5PQ2hSWWlkZFg2Tk1wQzdyUUZiR1lVc09IMjJ4?=
 =?utf-8?B?dUo4bjVyQlcrdW5YRTVEMkJBUVVCS2tvRktsVnlENGE5elRSa3dkTE1POXEx?=
 =?utf-8?B?TUFUYUVzd09RY2oxYnNQdXV1OTJ2T3Ivd2M0d0lHaWVsbWxFa015clFRdkxX?=
 =?utf-8?B?M3VTS3pENzFqWGxHelpIUm5mMXBJak10T3lZeVIrd0gyWThmc0NCRi9YQ2x4?=
 =?utf-8?B?WHUyRUxMQVlJVnh6SE5KS1h1cDJLL0NZd1dGNy9UTGs0TCtxN2NzR2FTRERD?=
 =?utf-8?B?Q2QxTkpabHVFSWZKbFVmdDNVd2JvODFLOUx3NEROVmlNMklOT0wxUTc4TDFS?=
 =?utf-8?B?UDVsRDJaZlltMTZsa3gwTlhxSkJ6TkdRWExKRzVNL1VSb0o2K2pIZDV4dmxO?=
 =?utf-8?B?YmtUWTJWcWhoNWJVdWVCK2x2WnlHRk9qcThsc1N3cCs1UXdKaHE4ZDNYT25S?=
 =?utf-8?B?U2I2Z1EyTldHay9HcnpteFNTak9OeEtNLzV3WXNtNGtva0liSWNmYjVNMzhR?=
 =?utf-8?Q?aTlpluYp0prweibVTX5c/1cDz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cabb585a-3883-44b9-2ba5-08dd3519ecf1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 04:06:02.3486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5W0/8tGcnY0mdBEnfkkmoM12AtBwiFjKuWS79B8xR9Lb+8lgkL6M9x7pWP1MHRsJnMcLRkut/WWE/giqBU2d/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6915

On 13/1/25 21:54, David Hildenbrand wrote:
> On 08.01.25 11:56, Chenyi Qiang wrote:
>>
>>
>> On 1/8/2025 12:48 PM, Alexey Kardashevskiy wrote:
>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>> uncoordinated discard") highlighted, some subsystems like VFIO might
>>>> disable ram block discard. However, guest_memfd relies on the discard
>>>> operation to perform page conversion between private and shared memory.
>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>> device to a confidential VM via shared memory (unprotected memory
>>>> pages). Blocking shared page discard can solve this problem, but it
>>>> could cause guests to consume twice the memory with VFIO, which is not
>>>> acceptable in some cases. An alternative solution is to convey other
>>>> systems like VFIO to refresh its outdated IOMMU mappings.
>>>>
>>>> RamDiscardManager is an existing concept (used by virtio-mem) to adjust
>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>> conversion is similar to hot-removing a page in one mode and adding it
>>>> back in the other, so the similar work that needs to happen in response
>>>> to virtio-mem changes needs to happen for page conversion events.
>>>> Introduce the RamDiscardManager to guest_memfd to achieve it.
>>>>
>>>> However, guest_memfd is not an object so it cannot directly implement
>>>> the RamDiscardManager interface.
>>>>
>>>> One solution is to implement the interface in HostMemoryBackend. Any
>>>
>>> This sounds about right.
>>>
>>>> guest_memfd-backed host memory backend can register itself in the 
>>>> target
>>>> MemoryRegion. However, this solution doesn't cover the scenario where a
>>>> guest_memfd MemoryRegion doesn't belong to the HostMemoryBackend, e.g.
>>>> the virtual BIOS MemoryRegion.
>>>
>>> What is this virtual BIOS MemoryRegion exactly? What does it look like
>>> in "info mtree -f"? Do we really want this memory to be DMAable?
>>
>> virtual BIOS shows in a separate region:
>>
>>   Root memory region: system
>>    0000000000000000-000000007fffffff (prio 0, ram): pc.ram KVM
>>    ...
>>    00000000ffc00000-00000000ffffffff (prio 0, ram): pc.bios KVM
>>    0000000100000000-000000017fffffff (prio 0, ram): pc.ram
>> @0000000080000000 KVM
>>
>> We also consider to implement the interface in HostMemoryBackend, but
>> maybe implement with guest_memfd region is more general. We don't know
>> if any DMAable memory would belong to HostMemoryBackend although at
>> present it is.
>>
>> If it is more appropriate to implement it with HostMemoryBackend, I can
>> change to this way.
> 
> Not sure that's the right place. Isn't it the (cc) machine that controls 
> the state?

KVM does, via MemoryRegion->RAMBlock->guest_memfd.

> It's not really the memory backend, that's just the memory provider.

Sorry but is not "providing memory" the purpose of "memory backend"? :)


-- 
Alexey


