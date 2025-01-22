Return-Path: <kvm+bounces-36214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B41A18B03
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 05:30:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E01C188C6BE
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 04:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA1F015533F;
	Wed, 22 Jan 2025 04:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="k9TyZ6UI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45FD0ECF
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 04:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737520218; cv=fail; b=JYBFGAbKv1RCCLNuAktjd6RCqLGeARJqiL+JHQZEmlK105YKoJlzyclFVqJ9kYhIXRbc5W2FITPKVx7d+gjAZR5BzMJdFvfMw+mj5BQ4s6er0xE+hTW9otH01XugnzzDOJEIiYoIREKiqBX2T4lklVxlbxH9MDMaWtrajL3D95A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737520218; c=relaxed/simple;
	bh=wwVwgwFKRIDYuHTNRchsQhQmr9U3b17Wtp0Lj+lYIpI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aVmNM5N2NtyniOPKcBdapE4BpX5DxlygM/g+5djJadF0pUfNuXtSSwET1glV7kLReTGs2yM62EvaCKjr6t7QoB3HXxP/whsjdlUfz0lbAX+ZRTjJ7lqRY/pLfLOJs0Ym++MmFTcczGVhBE+coH0DuZL7C6dFJJavTgplEKZLXu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=k9TyZ6UI; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DtQbQaS/9NoIozTjWy5NhZF4NVvbEt/TdKCxHhtVyq+SylncmfPNF12Ls2ul7qp/336MdrOgP/DVPe4gygpRiruBy1sE7/uw4k4cgtER0WwXNGjBFVX9GYWCFw3+06Yr3qG63H1AhJOVFpQiHj4NqBttrfO7tRMkNyynUVOhzAxes9VWcAajjme+qV0WHarOD1ILCOCANUL+Utn2TLFYsY1OHNEpcgocddnS2rwxfIV+yFNSuND9x0NKJSJcAKR/EbObWZw8CsZSD+quHVugq8jYLYHU/AbpvmZnFTmsta9r06TWDR/ptU1TsinYjEC1HVruCMpKtaZsV6Pd6vCm/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64uswhVN7bUd+2R9FARw6iUIjC/kF9cauqV42u0dNSs=;
 b=fZmhD2oZU9UF09btOOGB2PkcBQxtfawB5MZ6DTFpevHKnOfSNAR981SHQvDwGvvkZIhlP9KoVr7Z0IQybC1w9NxM59HMN8z/y06xNvVV6TANLEOFWdgSjtd9M7kojYkLL1lV08PwsMC2aHRBbJuCXGSh3+6fAUwAgjZx2EJ2lsWCuk10w0/kb8Ip32335pFOFe6x+8B/jFo5K4aEkEVnDOSNopWd4jEsgg3a3VY4tBJ/DgQkuF4pPQe/IwcgcMz0VTct3h3fugsEZePfXNZoG6CDNeNwErL7FbkuVPj6NS5YLr2zsdc5MMOu9kFp3/L7suOOL2DCcE7rA6T9GHteKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64uswhVN7bUd+2R9FARw6iUIjC/kF9cauqV42u0dNSs=;
 b=k9TyZ6UIox6qL6a6wY3hmc6ywjf3jie5uzDRBtR0gcKMSYJovADKBs31UTPLA3ntEfSAxpfxK2bvbFh/WiBwM3smBFl9HLjSSc3iEqUSbW4mkS8sLDKau1PoqxU/ec34qU7HcrIB5DdjPGhv72cfUsFh1dOvsC++ZEj5GgwlEzA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by MW3PR12MB4347.namprd12.prod.outlook.com (2603:10b6:303:2e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Wed, 22 Jan
 2025 04:30:14 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8356.020; Wed, 22 Jan 2025
 04:30:14 +0000
Message-ID: <95a14f7d-4782-40b3-a55d-7cf67b911bbe@amd.com>
Date: Wed, 22 Jan 2025 15:30:05 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 2/7] guest_memfd: Introduce an object to manage the
 guest-memfd with RamDiscardManager
Content-Language: en-US
To: Peter Xu <peterx@redhat.com>, Xu Yilun <yilun.xu@linux.intel.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>
References: <58b96b74-bf9c-45d3-8c2e-459ec2206fc8@intel.com>
 <8c8e024d-03dc-4201-8038-9e9e60467fad@amd.com>
 <ca9bc239-d59b-4c53-9f14-aa212d543db9@intel.com>
 <4d22d3ce-a5a1-49f2-a578-8e0fe7d26893@amd.com>
 <2b799426-deaa-4644-aa17-6ef31899113b@intel.com>
 <2400268e-d26a-4933-80df-cfe44b38ae40@amd.com>
 <590432e1-4a26-4ae8-822f-ccfbac352e6b@intel.com>
 <2b2730f3-6e1a-4def-b126-078cf6249759@amd.com> <Z462F1Dwm6cUdCcy@x1n>
 <ZnmfUelBs3Cm0ZHd@yilunxu-OptiPlex-7050> <Z4-6u5_9NChu_KZq@x1n>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <Z4-6u5_9NChu_KZq@x1n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEAPR01CA0057.ausprd01.prod.outlook.com
 (2603:10c6:201:30::21) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|MW3PR12MB4347:EE_
X-MS-Office365-Filtering-Correlation-Id: bbc47d8d-e10d-4fe7-d501-08dd3a9d7701
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QSt3SW5oUzhSampVWnJlMG9SZUFZZDhwa3JaN2pScUhQK0l3a3Nudzcxemsz?=
 =?utf-8?B?ZkJtTlBMaktzY1pxOVd1Vjh6cVJRZmNsaG40alhhWTRvMnVkVE5VSUw0ZThn?=
 =?utf-8?B?azV2VmQyYjduQkhkQXBHcm5sTkdYMk1pdmRPWjRWQmpGazFHdk1HZ2dZNDFO?=
 =?utf-8?B?cjB0YlZPRHlPZVh0YXZlRTd3eTQ4UWh2UW1nMS8vcmQ3TWdwZm1haU1PTGJM?=
 =?utf-8?B?OVJFMjFnOUJzTFJxSzhJbXpPQTlyMGdmeEdXejgxemNlQ1pSVmVkSytVaVhr?=
 =?utf-8?B?Wlh6d1p6SjQwV2FTTDR4Lzd5cmZKdkFyT3pEU2wxY3R6OFJjcmVSOHVIVmxi?=
 =?utf-8?B?eXpHWWFUV0owSGlwOS91RjBGcXFnVnNqaUw1MWc0N3E2c3RTZE9QeTFEYm14?=
 =?utf-8?B?aTREUkJzT0hKS2ZRLzBiUG85cG5DTHh6SGUxYkpXdFRleGhQRXIvdU1WUW94?=
 =?utf-8?B?Vm4yNWZmTEhwYi9KdHZZVkZ0T0dpNUYrTWpqTCsvTTk4OXp5eHVJb1owZGU3?=
 =?utf-8?B?bVNQQ0xhaHZRaGx2SG1Ca2dkcWhzaENQbzY5R3ZYUjB4Y3JKbXl5cTFYdGR1?=
 =?utf-8?B?N3BQelpDYStWb1FqREpMaURtQlJZMFJ5OVpscUtvSlpVRk4yeC9aTURrK2M0?=
 =?utf-8?B?cU0yRVhrRDZRbm5zajVMYTJpMEVvVDFhYVpHSnNJTGpHVS83VzhlNjBSTUk2?=
 =?utf-8?B?d0RWV1puUGtMOFFORmdkTkdiTGt3N1BDUnZKazJLUDJWOHZaRVg3WWd5QmNo?=
 =?utf-8?B?R2JvUTBCY3YzdzdYb2VwaFJHSVpZMzdQU0ZNTzFtbHJkcnp0eVg0ejBkTTA5?=
 =?utf-8?B?L2Rnamx4K2N4eTdlUkM1bmdxMFRhR0h1ck03SE1MS2lWRGx1L1RvTkxVUVg3?=
 =?utf-8?B?RUViQVg5MmhqK0dHeGlSMVlUNWZLQ0t5ZTk3eVd3YkIzN0MrcnV3dCt3Vjli?=
 =?utf-8?B?T1E0OW9NeGJVelNEbmJtZENRd01JeTFJTE1qdytxOGpZeWZmM0ZsRlloU0Vz?=
 =?utf-8?B?U0NvQTY4VE92WXM2TEc4cW9KQ0ZiRnBaVzJPaFZ6NlRzOEF5c3kzRWQ0Q3Vq?=
 =?utf-8?B?aTh4S3pJMEVaNzVQN0lHZ0lPMzBZVmpNSW5BaTZaVVMyVXBVM2lqbmUvUkVO?=
 =?utf-8?B?Si8wd0lyRXR0dGN3L0ZrWkxxbGw4eXI2MXVMZmpkRDNkdGRnTmxkQUVhNXlU?=
 =?utf-8?B?alB3Q29ld3FLaHNxM2RYS1p0bHFYSHhsWlBJTG5BTXkvL1E2SXJ3blErT3Q2?=
 =?utf-8?B?Qm81QVMxUTliajZoeXk0cGpiSFdrbHpscUN0RzNsUHV5WGVFUU05WVl3aUha?=
 =?utf-8?B?RTlhRkE3N0poeGw1VTY1c24zYWNFOVpxUnJFNW5UQkgvRzBqR1Ywb3lhUmdz?=
 =?utf-8?B?QlRrUEwvOGR1Wkx4dTVTc1dBZkJGQTg0citaZlhrTUVBcFI5M09FcTlJaDZ0?=
 =?utf-8?B?c0oraWswS0NHRG9IYWcydjFpYkhvQnJTKzRZL0tkOCtPb3VBRDlwbXFhV0JC?=
 =?utf-8?B?SXpWb1Z4N1ZTU0R1SHpBS2JYY25SN1hxUVZuL3diVmNEWC9KSVNpREt1UWEz?=
 =?utf-8?B?ZTNPQWdOck15QVBaL1k4U1VWNi9sbmpERGxUYVQzdWhDV0NHazNiajFlbDZo?=
 =?utf-8?B?VHgrUGFCK1d3b2k2ZDJTWk05dVgyL3FSU0VSQWxORXdIWGVKc1BOQTlaN2lu?=
 =?utf-8?B?ZG5aMTlHa1c5UXVYV2huRS9VcFZDdDZDU09zeDVKc2JLMFBHNXlicFByUHhr?=
 =?utf-8?B?REhJdTc4V2gyTTRob01pUGJGakVpM1RLOEZ3RGFFbkFOOW50MzBZWER5RWpu?=
 =?utf-8?B?blIvaW1zYjQ5TWdpazRNNDlGYnRiZFBXbEdiWDBkbk95VGVyMkJ0eHIvcWNR?=
 =?utf-8?Q?7651gTR49vdO7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VWhvMkcxbnVoMDFtZ2ZqaFpmbi9GTWVTV1VNb3BXZFBWWHFBOTNuWFlYWnc5?=
 =?utf-8?B?OGNtLzh2N0tLUjg0WkFMSUVPK3hzNzlCTEFwSHExODMvUGtEVTZYVUdyeUdu?=
 =?utf-8?B?YU1kZ1FGQjFJUW5RTWUrOGk2YTFjd0pHN3RJZ3F3VmxFc1BIWFFXajhpU1BM?=
 =?utf-8?B?MFFiWlY4bnVKZmhuNFI1Z3NrK1RBVzhKUzVTQkdROHNnN0xlaTRlditLTUhG?=
 =?utf-8?B?azZwS1AxRjFwb2w0QnUrUGtMQWQ0Q2NuQXhlTmxReUVmL0NERXh3SE5hQTdk?=
 =?utf-8?B?cE5OZks2RnZ6OFNLdkxydExoeWtNc2Y1dkpRT01USHZLczFQRWpuNkFOT1FQ?=
 =?utf-8?B?M3diUWU5dDVMR0s4TVVLT3dvdHJ3N3VYMzkvOE4yT0xvaHRhZ0ZSb0d0Yzl0?=
 =?utf-8?B?WnNwaWszcU52UnJHbTQzQ3Ryc3JRQWpJZG9zZWN6cUJWQ1FTQ09QK2tDU2lM?=
 =?utf-8?B?aFIxZzkraXc1U245M0diZVU4SXovRll5L0hDTEkzUGQvMStMN2NHdlM3bjhm?=
 =?utf-8?B?b2pjekFaU2phMzRpaFQxb3F0NjMzMUM1REtLMS9sT2M1STQ0ZTdPL3pCWEM4?=
 =?utf-8?B?akViM3g5NDZaMUdvVnVPOGVlc3JwcXZzaHBCcnhBTElkNFNYSWEyZXJrN21Z?=
 =?utf-8?B?ZTB4blByYVR3NDdRejFJK0VJcU1aNzY5a3RYNFRLQzZ3czFkOGV1Q3lvd1RI?=
 =?utf-8?B?VTYxekVQWk5nZ1llbCtTbEZIS1N5cVdGRHBzK0xOblpkbTBOazZ1S1hDM3dG?=
 =?utf-8?B?WHQxcnF2NzlKU1A5NldnOFZWazE0bjhGc2tIc1VQVVJnSjJ2czJ5U21oT2NC?=
 =?utf-8?B?cXp4aFdDTzBVbktyelM5cmxlUk05WDR6R2dyaHpqNHoyZGoyYXA1SmxQY3Rh?=
 =?utf-8?B?akhzb3JWSmRYbVE4alVUeHJVNmZqZ1BXemc2SElyL1dybVJhWXA4c1BIOENN?=
 =?utf-8?B?NHZSc3cvN0I3aG4wM2Q2cklvanlZcG5jNzZLeHlVN05lUU0vRzJia2FuSEpu?=
 =?utf-8?B?RVhabFVvN2UxSmEwYVhpZ2VjY0VSUVhOUU4vZVNENTRiNDdkaG9ETk82S09s?=
 =?utf-8?B?YURwejlZQnlRb2lFeG10M253TGtuT2lqSWQ0R0hDRC9FK2Nham5BZFFHWFFj?=
 =?utf-8?B?Q21RQjJzamRxN2tEK2x4QnFvY3ZBdEhqeFIrK1FYSEd3Zkx3UE9nWE11OWs5?=
 =?utf-8?B?YTQvYUdkNTUrV2VXWERidUU4aWl2RHZtc3VLblpWQlpLaGZTMUwxWkpGK1lY?=
 =?utf-8?B?Sk10YUFYU0NZUHpRZGRMZkpTb1MzNXFjVHM5YUNtcnQ0RmJGNEFtUXdyU09w?=
 =?utf-8?B?MWxTOWs2cXphNWFtV2FHK1AxR3k0UzBhOVE4MkJVMGdyOHFDVVVFV0xONDdr?=
 =?utf-8?B?ejd1VFJTVmRSZmtFR2FRNjJDanZFVTBFSUplR2o2Rzdia0ZPbUhPT2F2RjVm?=
 =?utf-8?B?V0IzK1ZRSlJKdzZHdjE3Vi9JVFZ2QmRWS1JVNitFeUV1TktPeW5KVDVDSUp3?=
 =?utf-8?B?QmVPYjE1Szd5V0ppYlhzQ3hVYW95NlhMOVBwMm15bERtWlk1aDJrc0pUZW40?=
 =?utf-8?B?ZjdJSlBlTWRvV3ZsTlpqMG1FL1lPOG9seEl3dFA3L0tJd3lRV3NJd2k2Q0Ja?=
 =?utf-8?B?L3J3Nm5rcDA1TXNUT1gzcy91L0xMeEhLdzZmeGdNVFR6RnhnT2NRamFNQ3lN?=
 =?utf-8?B?VnlyUExZU0JpY2NRL2ZxQ3FueW1SaGhtVzlUL1QwOGIvMkpvc0EyUEZYNGxK?=
 =?utf-8?B?WGJrUUdScHlCaFZzUzUzYm1GbXh0ZXQxUEhEUzAyRk8xZ0pYRDRrRlJkYmcw?=
 =?utf-8?B?Z2gzU1dKMElmS0REUlhrOXJDNWVRVUI2KzNoL1VqdzFuTjcwWU03b1lzYzZW?=
 =?utf-8?B?YW1KWlArVGNjNExIUk81T1YwN3RvVm9PYVZ1RktlZnZVTTlFOXpaMGlTNjBp?=
 =?utf-8?B?cEN3d2FiRUNleUFzdjVwSlNSeXpkNXBBRGpyUHp6QlNCWW1EaWluR05TeTZx?=
 =?utf-8?B?YlhLcWJlK1p0RDVnd0ZkNjZVQ3lNZE12aG9qenlZcmQyQy82YlFrTEpxMzdX?=
 =?utf-8?B?RzlidFZvN1dxWm0rY24yL3BOeVppYWRnMWlqckhLS2tKekY1Z05sWStyd09D?=
 =?utf-8?Q?P9POFn2VEqux/zewWP1o4hODW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc47d8d-e10d-4fe7-d501-08dd3a9d7701
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2025 04:30:14.1062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RXRWEnzi+yd67A2QoXFtB6P+/T869Uxtlqkpna1sLj6Bd9hUHpq6U6VUUG1lZED0nmkglQ7bM0XVtskprBTYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4347



On 22/1/25 02:18, Peter Xu wrote:
> On Tue, Jun 25, 2024 at 12:31:13AM +0800, Xu Yilun wrote:
>> On Mon, Jan 20, 2025 at 03:46:15PM -0500, Peter Xu wrote:
>>> On Mon, Jan 20, 2025 at 09:22:50PM +1100, Alexey Kardashevskiy wrote:
>>>>> It is still uncertain how to implement the private MMIO. Our assumption
>>>>> is the private MMIO would also create a memory region with
>>>>> guest_memfd-like backend. Its mr->ram is true and should be managed by
>>>>> RamdDiscardManager which can skip doing DMA_MAP in VFIO's region_add
>>>>> listener.
>>>>
>>>> My current working approach is to leave it as is in QEMU and VFIO.
>>>
>>> Agreed.  Setting ram=true to even private MMIO sounds hackish, at least
>>
>> The private MMIO refers to assigned MMIO, not emulated MMIO. IIUC,
>> normal assigned MMIO is always set ram=true,
>>
>> void memory_region_init_ram_device_ptr(MemoryRegion *mr,
>>                                         Object *owner,
>>                                         const char *name,
>>                                         uint64_t size,
>>                                         void *ptr)
>> {
>>      memory_region_init(mr, owner, name, size);
>>      mr->ram = true;
>>
>>
>> So I don't think ram=true is a problem here.
> 
> I see.  If there's always a host pointer then it looks valid.  So it means
> the device private MMIOs are always mappable since the start?

Yes. VFIO owns the mapping and does not treat shared/private MMIO any 
different at the moment. Thanks,

> 
> Thanks,
> 

-- 
Alexey


