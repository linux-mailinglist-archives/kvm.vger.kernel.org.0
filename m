Return-Path: <kvm+bounces-48155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3977FACAB48
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 11:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E4763AAAD3
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 09:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA671DF25C;
	Mon,  2 Jun 2025 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AZOZsmIr"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2074.outbound.protection.outlook.com [40.107.102.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942DB3FB0E
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 09:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748856023; cv=fail; b=S2BZwIWk8CH1WSVqmj1szgcnEAm/KXLjGSZBiobgHnjJXsoUNyZ+/EF+IdNSSHG3Xvi7lnNj82Gk4rzHoI2ukTsI9Epvyi8d5pSSuz3g3JEAnE3SgDllE2czT1esA25VmwL4FK2I8CZ2eNMIA144CnfY1bg5pDVohlH3d19sYTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748856023; c=relaxed/simple;
	bh=hp4xi2IGN0Svh076F8CbX7fqkcEXwW6wC1qKMylS4uA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Khl/dLhdtRaGOnMAN7uNdWJutX3DdGPy0s0LLalcCCBRVBb3ro8eUZv/nHrsF03qZ+6rcESiUryAA7f+7Sa8xFNXTTJL1eTfQ7W40Busrl1Aig9nW2cRh1i9CVch/jWxRL3o6bi3g3oN6MfWL6F+YomUIPqSJ7/8c057USY7q3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AZOZsmIr; arc=fail smtp.client-ip=40.107.102.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v8yi8Ak4lgNQPzUy/MmMDKCEd4PIRplEpUGk36Swp4zpq3h3t97mkHK5/68AJQLrCD5IKjqcX8T9zXW7tuk6tcJ1NdULii1sohUAulvzBTBHUBrK6Vdexlr2yedaHK81v7u8r3Ac5avB06iPKXIROt/kUomk1kCa8IxIyHvZvHqZRbdLWXY79ocQoKQqAPadQ6WSOXu9x8WF8/rFKdV5GE89xdTHTyvD8jvgtpSIb6+ugqLAw4+hvGLuD7xI70o3bNaKFH0ljpUPJrTjEOW2VXZODpsGh3wq4OMLACHnO8/F9f9nRDrMvb9ht1LlVEK2JO+hS+9M1u4jlnQaoONIJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4R1P9+iC2MRTy65yPJOgPUli9qOVOOkiIR5nJyM98bY=;
 b=RVqckiQgXng+6TLAa/IWjBXF1CZPdiQaqmGtLi57vcKk1nwLK92ie4jr8oL8svM6V8LsVMaU9ejZM1MZOYwr4Yb0ovZmrNjmkSWXXnfqKXjbQfOHkKYrRBEtQ4kLe1/PkvyUOfeibw8qIT8/NczohPy8TkzzTyHIBu6ngzFb8rNvlJ5Ju64dZlVlGQ8Qbqmzk0ESPdyaJ+TTVVXRuqq6wT7z6afKFsvu8elYRq8ARSq/KvsDVU70i3kBXYPhjF8ZG5XfCiPGcaHyAhOl9XO//mP9E5iBTyyHx5jMUCEOy8vjuHZbvIBcSVgpkzZMqjqBrgbnGRwe00nz3oR0iKEqXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4R1P9+iC2MRTy65yPJOgPUli9qOVOOkiIR5nJyM98bY=;
 b=AZOZsmIrmtWfmB5GQ83lfeqJTvnL4A/FfEY3QH3UxLOEGsgcp+DIV4octDfQIXJ1kObZBxb38xtl4e3BvuydgE9cIVowA0Q619HXcelOsLzyXpyV+n3wLrSUUCI2JN23OUXDy8LxZoLXy3lMFsOzFk6Bn8u7SlFOIcR3qxJfqYk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by MN0PR12MB6055.namprd12.prod.outlook.com (2603:10b6:208:3cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.30; Mon, 2 Jun
 2025 09:20:18 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%4]) with mapi id 15.20.8769.031; Mon, 2 Jun 2025
 09:20:18 +0000
Message-ID: <5f4464bb-c75c-43b5-ad86-fcd309568746@amd.com>
Date: Mon, 2 Jun 2025 11:20:12 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/5] memory: Unify the definiton of ReplayRamPopulate()
 and ReplayRamDiscard()
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
 <20250530083256.105186-4-chenyi.qiang@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <20250530083256.105186-4-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0359.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f4::19) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|MN0PR12MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: 356a3e3c-96bd-403e-57f9-08dda1b6b104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NCtEVlZjZUZtSEVLMXNtSUtQUGc2cEVxcHpHNzJsYTFuenpObXV2VFBJR0hi?=
 =?utf-8?B?cnJ4UzJnQXRBL2Y0cnpBaHh2QVpGbm9YZjdYSTBKNm1qR2poWlUvSFArcW02?=
 =?utf-8?B?LzQ4eEUya3U3L0FmaFg5eXFMMTNUdTJLNWNPWjdoVzlFeVI5NFIra21ianpW?=
 =?utf-8?B?bmtVajVYSG91NTFqZzg0Q0d6YzJyTmt3dWRvQklRaTVYME9wZUk4MDhIRWhu?=
 =?utf-8?B?NzMrMW0wK2xyUmxPNFh6RjF3b0NOZWlETGcxL1N2Mkp0UzBxRUd1UERmNWFn?=
 =?utf-8?B?SEFJVDdDb3R6NWs0cjZZYVlTRFZydjl1MGQ3QmtHWXBmcStkSngwb3ZNL0xD?=
 =?utf-8?B?c0NYOWdLYm9DZXJwL01lVnhjeUp2U0FxWDl3dEhmS09uNUxSZEl4Qk1hQkla?=
 =?utf-8?B?UXNid2NLbzRNWjJXSVRVMEU2TlpZMlBUVXBya2FJcUh5MHF0WHVwaW1lQkRS?=
 =?utf-8?B?dTdMNlFWanVkTzR3ZWs1Z1o3YUV1aEpCeVUwRngwdnBEWmhwWE05Z0NMTXR1?=
 =?utf-8?B?d3M1MmhzeGY1K3lEc0NSUmRXR2VKTi9YMzNWVldDRGFzdEVpRVlpa3RhTDNW?=
 =?utf-8?B?NmtIQ3F4bkFLMDRpSXhGNzVUaDBtd090VzhmOUZsVGhqZWthbDdnSlpLeS9X?=
 =?utf-8?B?QndlSExaRXdzK1hyejZyd09ITUtEdmE1djJTU2FXNVRVRWJ3Umg5VmU2RmVE?=
 =?utf-8?B?OVJvTzZEUG5yWkFqZ05uUVFTQlh0bjl0ai9YWGtrRTNKYzVrbTMvL0RFeis2?=
 =?utf-8?B?UzU2NUM1V2ZCZDk5QzMvYUpVMEJJZUI2MlBZUWZaa25KeXN6RjZ4VlNMOEFp?=
 =?utf-8?B?VGd3TXVTY1hkcUtkRno2cm5nZTJJMzhRL3gzcDc4aU10aUllM1ROYXF1SXFJ?=
 =?utf-8?B?TWRsdVIwTWRwbGNvYThjUEtxVHZNaW80NytJN2o1cWlOQ1pIajhCbEkwNDhD?=
 =?utf-8?B?MnpPOTFrSHZpNW5uYzJzRVBCYUFYTHZxWEtvVWRFeUdxU3ZqZEsyRCtVKzU2?=
 =?utf-8?B?YkZQdm5CbkFjaDVZRDdoMlpEcWpTWGNicFJuYmN2MDBOWTZ0S3Y4YU5INGZl?=
 =?utf-8?B?MzQxRytSRWllNXNrdkQ0SzJOQnBMaGkvUjErRDg3WU01R2g5NTB4eWtrbkpr?=
 =?utf-8?B?aTVrZUZXNFhIUnBpVHdjdXlRZ3JITml5ZUJRUzdwVVVBVW9BOC9iY0s5empo?=
 =?utf-8?B?TWg1VVdFaDJBNXRlV3hGT1ZZcHFVbjRhdUt6dGVtcUcvN2JJQU5rNHFIckhB?=
 =?utf-8?B?YlNEb25PMGN1SFZmL0JoK2w5N0JlUDdWOFBQdU9DWDNPeVorZmRBcGdoZU5o?=
 =?utf-8?B?RDhTOXhXM0JYMUpYN1llNkh5d1hReVJUMVgwa3dzN2loZGowL0h2dTcvelhX?=
 =?utf-8?B?Wnp2bHlLd3hjZEpQK29GVkRzYkltL1FvTkhVdFRWOGFCb0dueDRUeHlDQW5E?=
 =?utf-8?B?NDE1QWc3dWEzL2N5YyswTEtjRlRFS1VVRkh5bG1pM0xMSFFObmhYUGNneWhk?=
 =?utf-8?B?N09aL0xPK3o0RHE1ZEkrWkNOTjFtam1yWEtGblBBNTM2eENyZ3ZjMUtuS0N4?=
 =?utf-8?B?Z0UzeGdKYXBqVUpCb0I4eVNjR0U5NUlpYi9uVG1lVTBxcWdscnhBT0Nlb1No?=
 =?utf-8?B?ZVVSVkNQWGhaOG1RcWY4d3l5K1FHQkNyUHVtakY0WTB5cGQ2Nkx2YkhvdmJP?=
 =?utf-8?B?Vy9UejUrSEJKMmo1eFFKeFY4TUgwa0lyWXZpZmdJTXR0elBGMjFTSmVkVzlV?=
 =?utf-8?B?b2w0QjNScjdqcVkzOEN4N05WVVlSMFRGQ3ZSNFV3UWlFeVBNTjZMcXZwMG1I?=
 =?utf-8?B?ZTlZVmRmdmRyT1JXRzRqMGQxTGE3ck5ibnNhMWtYVDlpNk9CSDVQdWtibkFw?=
 =?utf-8?B?QThQc1NWcThMdG8xZDBTSTFrdUtDb2twTVZmYThoU0kveHZwd2VVQndZeU9N?=
 =?utf-8?Q?s8UCQmBXfN0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z0tWd08yWkVHN0s4ZjczcW9sb0EwdzNGVmF3Z3laa0huenhnQnZiNFRvRFM4?=
 =?utf-8?B?UjM0OFdOMjRTd1RNbXBiNFF1a0NacXRCa2dIYXZ5bGRsZC9tSVF1WEJpbm53?=
 =?utf-8?B?R3VRMmVCUG05RUFaL0t4QXpEK2ZETmN5NGZUVGNIRzNXZGdIWlgrL3lrTGF4?=
 =?utf-8?B?OVhsaXJCYW1uM1diOFFLYktJVmZTa29IY1RYTzlsamxlUFZLSVRrQVlyVGQ1?=
 =?utf-8?B?dFpwZHFyaW5RZk9NTlMzQ3JSOURFbndDQUtuYzJ0aE1QaDg5NXVGOHNBRkR0?=
 =?utf-8?B?RTZla2tiV1RONTROSmZ3bUw2UHZibDREVXQzdE9DOHZSU1lGK0lDaG9KdHZv?=
 =?utf-8?B?QlAxbk5vOFBYcDJSeFZSMURwN2pZbmpTMHlpNDMzTzNYK0xWTXNEVGorQStM?=
 =?utf-8?B?V3FyUXJDbGZjUG1ZY2g4aDZQOFNMVlM0WG9NZUxUMUsrSlkvRzJpMC9JRW0x?=
 =?utf-8?B?eFZuMEhzdUx0UEhNbGV2c3VrSmRTN1RFNVd0NlYzTS9vUk9xRkYxUFB6Y1cz?=
 =?utf-8?B?SS8rTGZjVTRGY3BDUVZoa09jQmJ5ZS9naXF0QURzOTFpNW02TWw4a0NkTXNM?=
 =?utf-8?B?akh0am1vbVU3Ym9lUTBBWnJRVEo5ejcyS052clJtN0hZNDFqNnNRRm8zSHBM?=
 =?utf-8?B?a3BDbDNkc2EyUWFhLzhmeHZTc2hrK0sxdEt3cG1wL3doK2twWnhjRFMxV1cy?=
 =?utf-8?B?MkloaExpUHVSdVIxRlR1TTJ3MWVWUmRRbFZlWkNEaFQvZ2VGOVZHTHMrNmJ1?=
 =?utf-8?B?dlZrVGZYcDNYUW92dE0wdzgwZ0NON2RzbEFyWklTZFl4MDdDbTZYVTJuazR5?=
 =?utf-8?B?dGFPRi8yYVhvNXZkOVJSUmhTb0J0aUtMQzl3VzZtYVIzb0RscjUvSDFwdHdR?=
 =?utf-8?B?Vi9qSTBDR0ZNS21HWEFKaGRBcmd5bzFBTlRhemVRZi81bnZ1NUwyUTZVZDhk?=
 =?utf-8?B?YmUwZHk0VVE1eXlHZDBHaTF6RWFuVGVQbFE1L3ZqZGwvWERwbm41YUlqYXYx?=
 =?utf-8?B?anErTXhDT3piZWNucWFISFBOZnE5UUMxaEJxcjdtMGpkM2plR2RoeWV1TEp2?=
 =?utf-8?B?SmEvYTVQTG5jYW1ERWdtUjhGNWlzQlB5STRjQktPZjQ3aXZ4NkVzY0c4SHpm?=
 =?utf-8?B?UVZGem5XLzBPNmxRVE0xOFpjdnpNMkMvcmhFYk9kWS82ZS9QeUx6ejZBbktT?=
 =?utf-8?B?ejN6TDZzeENVbmEvSnRiN0UybEp2blVQMWhaUTJ0aU45NEFBWTdYVi9od2dH?=
 =?utf-8?B?S2JrTys1RHNmMnp1QUFMaFI0b0tQbUNKbGloSzR5bG8xd09VUEtQaWQxczF1?=
 =?utf-8?B?aFBtMWZKMEY0cjZ2dGZHVXdzamxFb3NTZzhSV0xNM1RGcGpveDBwb21UK2g0?=
 =?utf-8?B?WjZpZ1BLbGFTZlpvcjFGYTJ1WFB5aG51a3NhdFdDWHhNZXNzM05wVVJ5dFhr?=
 =?utf-8?B?MjRpbTNMMXA0K0JVVlVIZGV5RlNNU2JCZ0ZON0llQmR2VGprempTcGNOMkxI?=
 =?utf-8?B?SFlVUldJQ0hDcGNxNGhJZVI4cWlQSDVneUt1ZWxtSDhYVkJWMzdtRi9uTWJw?=
 =?utf-8?B?eDhhZUVhdm5nTEVHMk9lanlVZjJyNkJHZnkxYWQ5QzJQdEJSVlNaeDdSbTJJ?=
 =?utf-8?B?NmYwTTFYN1o2Tk1ja0tJNG5ORmpHRVlTRG1JenJZRU94UUxnZlJsajhTNnJM?=
 =?utf-8?B?MFdkd3h0ZCtydm50RFJxMDF0S2VtamUyYkdlQU1DK1dQakJ4eC80em5oUk1w?=
 =?utf-8?B?bHY4SFpVcDArRThhbFpyQTFWWTRrdWY0Sy9IYm90UmY5aWZYMkNHWGRUUjZS?=
 =?utf-8?B?aGkxTjBGZ1FidUVySGVPTjRONFJZSFdHTzBqUDB5VkZIUThMdWFXb3FUb2xV?=
 =?utf-8?B?YzAyV0h5NmlKOURuSXR3RlZkbnY0TzMzbi8wMjl5T3JWV3U3WDhrcUZ3Q3BF?=
 =?utf-8?B?R1h0UUwxUS9NcnlwcCtKVHdUY1UrMUpXNWIzZmc3U3VuVVUxbFNmbjdmSXRx?=
 =?utf-8?B?NWdWL3hzMURJUHhtRnQ3bFFwV0VoSU5NK2JhMitaSnNFbjZhUFlnLzY5ZlZP?=
 =?utf-8?B?elZ1dERBNVFXU3B0SkpJRXdnYk1SUlZoZnBrWWVtVVo5Wm44eXltRmNFY0ZS?=
 =?utf-8?Q?AHh7b5zkC5nEqB576e6K6SPSu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 356a3e3c-96bd-403e-57f9-08dda1b6b104
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2025 09:20:18.5566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iT4qFHSutwsgjV544+4VPbhQy0AQwH+poNaHjxV/49ukbcbNCvqGretbGSarHDBmvhpxAA4NJIMACLpQQQPQ0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6055


> Update ReplayRamDiscard() function to return the result and unify the
> ReplayRamPopulate() and ReplayRamDiscard() to ReplayRamDiscardState() at
> the same time due to their identical definitions. This unification
> simplifies related structures, such as VirtIOMEMReplayData, which makes
> it cleaner.
> 
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>

Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>

> ---
> Changes in v6:
>      - Add Reviewed-by from David
>      - Add a documentation comment for the prototype change
> 
> Changes in v5:
>      - Rename ReplayRamStateChange to ReplayRamDiscardState (David)
>      - return data->fn(s, data->opaque) instead of 0 in
>        virtio_mem_rdm_replay_discarded_cb(). (Alexey)
> 
> Changes in v4:
>      - Modify the commit message. We won't use Replay() operation when
>        doing the attribute change like v3.
> ---
>   hw/virtio/virtio-mem.c  | 21 +++++++-------
>   include/system/memory.h | 64 ++++++++++++++++++++++++++++++-----------
>   migration/ram.c         |  5 ++--
>   system/memory.c         | 12 ++++----
>   4 files changed, 66 insertions(+), 36 deletions(-)
> 
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 2e491e8c44..c46f6f9c3e 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -1732,7 +1732,7 @@ static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
>   }
>   
>   struct VirtIOMEMReplayData {
> -    void *fn;
> +    ReplayRamDiscardState fn;
>       void *opaque;
>   };
>   
> @@ -1740,12 +1740,12 @@ static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
>   {
>       struct VirtIOMEMReplayData *data = arg;
>   
> -    return ((ReplayRamPopulate)data->fn)(s, data->opaque);
> +    return data->fn(s, data->opaque);
>   }
>   
>   static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
>                                              MemoryRegionSection *s,
> -                                           ReplayRamPopulate replay_fn,
> +                                           ReplayRamDiscardState replay_fn,
>                                              void *opaque)
>   {
>       const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> @@ -1764,14 +1764,13 @@ static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
>   {
>       struct VirtIOMEMReplayData *data = arg;
>   
> -    ((ReplayRamDiscard)data->fn)(s, data->opaque);
> -    return 0;
> +    return data->fn(s, data->opaque);
>   }
>   
> -static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
> -                                            MemoryRegionSection *s,
> -                                            ReplayRamDiscard replay_fn,
> -                                            void *opaque)
> +static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
> +                                           MemoryRegionSection *s,
> +                                           ReplayRamDiscardState replay_fn,
> +                                           void *opaque)
>   {
>       const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
>       struct VirtIOMEMReplayData data = {
> @@ -1780,8 +1779,8 @@ static void virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
>       };
>   
>       g_assert(s->mr == &vmem->memdev->mr);
> -    virtio_mem_for_each_unplugged_section(vmem, s, &data,
> -                                          virtio_mem_rdm_replay_discarded_cb);
> +    return virtio_mem_for_each_unplugged_section(vmem, s, &data,
> +                                                 virtio_mem_rdm_replay_discarded_cb);
>   }
>   
>   static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
> diff --git a/include/system/memory.h b/include/system/memory.h
> index 896948deb1..4f45a187d6 100644
> --- a/include/system/memory.h
> +++ b/include/system/memory.h
> @@ -575,8 +575,20 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
>       rdl->double_discard_supported = double_discard_supported;
>   }
>   
> -typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
> -typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
> +/**
> + * ReplayRamDiscardState:
> + *
> + * The callback handler for #RamDiscardManagerClass.replay_populated/
> + * #RamDiscardManagerClass.replay_discarded to invoke on populated/discarded
> + * parts.
> + *
> + * @section: the #MemoryRegionSection of populated/discarded part
> + * @opaque: pointer to forward to the callback
> + *
> + * Returns 0 on success, or a negative error if failed.
> + */
> +typedef int (*ReplayRamDiscardState)(MemoryRegionSection *section,
> +                                     void *opaque);
>   
>   /*
>    * RamDiscardManagerClass:
> @@ -650,36 +662,38 @@ struct RamDiscardManagerClass {
>       /**
>        * @replay_populated:
>        *
> -     * Call the #ReplayRamPopulate callback for all populated parts within the
> -     * #MemoryRegionSection via the #RamDiscardManager.
> +     * Call the #ReplayRamDiscardState callback for all populated parts within
> +     * the #MemoryRegionSection via the #RamDiscardManager.
>        *
>        * In case any call fails, no further calls are made.
>        *
>        * @rdm: the #RamDiscardManager
>        * @section: the #MemoryRegionSection
> -     * @replay_fn: the #ReplayRamPopulate callback
> +     * @replay_fn: the #ReplayRamDiscardState callback
>        * @opaque: pointer to forward to the callback
>        *
>        * Returns 0 on success, or a negative error if any notification failed.
>        */
>       int (*replay_populated)(const RamDiscardManager *rdm,
>                               MemoryRegionSection *section,
> -                            ReplayRamPopulate replay_fn, void *opaque);
> +                            ReplayRamDiscardState replay_fn, void *opaque);
>   
>       /**
>        * @replay_discarded:
>        *
> -     * Call the #ReplayRamDiscard callback for all discarded parts within the
> -     * #MemoryRegionSection via the #RamDiscardManager.
> +     * Call the #ReplayRamDiscardState callback for all discarded parts within
> +     * the #MemoryRegionSection via the #RamDiscardManager.
>        *
>        * @rdm: the #RamDiscardManager
>        * @section: the #MemoryRegionSection
> -     * @replay_fn: the #ReplayRamDiscard callback
> +     * @replay_fn: the #ReplayRamDiscardState callback
>        * @opaque: pointer to forward to the callback
> +     *
> +     * Returns 0 on success, or a negative error if any notification failed.
>        */
> -    void (*replay_discarded)(const RamDiscardManager *rdm,
> -                             MemoryRegionSection *section,
> -                             ReplayRamDiscard replay_fn, void *opaque);
> +    int (*replay_discarded)(const RamDiscardManager *rdm,
> +                            MemoryRegionSection *section,
> +                            ReplayRamDiscardState replay_fn, void *opaque);
>   
>       /**
>        * @register_listener:
> @@ -720,15 +734,31 @@ uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
>   bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
>                                         const MemoryRegionSection *section);
>   
> +/**
> + * ram_discard_manager_replay_populated:
> + *
> + * A wrapper to call the #RamDiscardManagerClass.replay_populated callback
> + * of the #RamDiscardManager.
> + *
> + * Returns 0 on success, or a negative error if any notification failed.
> + */
>   int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                            MemoryRegionSection *section,
> -                                         ReplayRamPopulate replay_fn,
> +                                         ReplayRamDiscardState replay_fn,
>                                            void *opaque);
>   
> -void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                          MemoryRegionSection *section,
> -                                          ReplayRamDiscard replay_fn,
> -                                          void *opaque);
> +/**
> + * ram_discard_manager_replay_discarded:
> + *
> + * A wrapper to call the #RamDiscardManagerClass.replay_discarded callback
> + * of the #RamDiscardManager.
> + *
> + * Returns 0 on success, or a negative error if any notification failed.
> + */
> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> +                                         MemoryRegionSection *section,
> +                                         ReplayRamDiscardState replay_fn,
> +                                         void *opaque);
>   
>   void ram_discard_manager_register_listener(RamDiscardManager *rdm,
>                                              RamDiscardListener *rdl,
> diff --git a/migration/ram.c b/migration/ram.c
> index e12913b43e..c004f37060 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -848,8 +848,8 @@ static inline bool migration_bitmap_clear_dirty(RAMState *rs,
>       return ret;
>   }
>   
> -static void dirty_bitmap_clear_section(MemoryRegionSection *section,
> -                                       void *opaque)
> +static int dirty_bitmap_clear_section(MemoryRegionSection *section,
> +                                      void *opaque)
>   {
>       const hwaddr offset = section->offset_within_region;
>       const hwaddr size = int128_get64(section->size);
> @@ -868,6 +868,7 @@ static void dirty_bitmap_clear_section(MemoryRegionSection *section,
>       }
>       *cleared_bits += bitmap_count_one_with_offset(rb->bmap, start, npages);
>       bitmap_clear(rb->bmap, start, npages);
> +    return 0;
>   }
>   
>   /*
> diff --git a/system/memory.c b/system/memory.c
> index b45b508dce..de45fbdd3f 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2138,7 +2138,7 @@ bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
>   
>   int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>                                            MemoryRegionSection *section,
> -                                         ReplayRamPopulate replay_fn,
> +                                         ReplayRamDiscardState replay_fn,
>                                            void *opaque)
>   {
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> @@ -2147,15 +2147,15 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
>       return rdmc->replay_populated(rdm, section, replay_fn, opaque);
>   }
>   
> -void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                          MemoryRegionSection *section,
> -                                          ReplayRamDiscard replay_fn,
> -                                          void *opaque)
> +int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> +                                         MemoryRegionSection *section,
> +                                         ReplayRamDiscardState replay_fn,
> +                                         void *opaque)
>   {
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
>   
>       g_assert(rdmc->replay_discarded);
> -    rdmc->replay_discarded(rdm, section, replay_fn, opaque);
> +    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
>   }
>   
>   void ram_discard_manager_register_listener(RamDiscardManager *rdm,


