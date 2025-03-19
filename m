Return-Path: <kvm+bounces-41484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B380AA68C35
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 12:57:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16EAF176294
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 11:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E997254AF0;
	Wed, 19 Mar 2025 11:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pKDpjXWY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2087.outbound.protection.outlook.com [40.107.237.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB43017A5A4
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742385413; cv=fail; b=JuUcmSBfPWjo/Kt5hZH0G65/qLMNX6bctg4QQSX8eGM/9IYjPzfFztSMYKQ4/LG/7rKSFd/MmpIltGgxk2FQ7vfqBYTZx77TziLPEaN2/4nwYnzxLqqhcn18NkytEmf2T8IaTxChQS5havIDMPL0dL2oeB12SQXHqa0jsL9ZxJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742385413; c=relaxed/simple;
	bh=tcyfrFySfOEkbsu4Vc+v5qdXmapH/BNJul6HJeRgNTQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MfDI/5g4iucdfxhuQuchvJD/7mH7apZv/o+fx3igLVtf3PCI7rls8EYttKzTRkig1ZllbvpaKkwSTxA9usHR7exyEKlhjyEkjNPy3GxR/QW33DkR//aWTXzS2W/ZDe/+/19NkMHfZNbhDujfpxlAKPsPrLqSwQ3OaYlnEqmSCO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pKDpjXWY; arc=fail smtp.client-ip=40.107.237.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aAnIMTFIqBIALETVqZm35x8IWM+kxqoK7RQp6+NRRScq8KMawHz/QUpIMCFZd/3Bks+lzlHPR5X06YPQIZPGOUD5JXGNWTJwws6wtoYdM40r6GXBU9OSa6V7WJqHPRXzhdnkvavRrHTrtBnTc3K5iQfpxfHE69wWY9pOwm9Tbya1j8oFZjzjSqbH9YLO9Izad8lUqL/4yYtUcm/LRqgbhghPYtGvWFuQ0eT2UBn8j5xkrCfp+8RNK9lz2/YHOOQVYEEuG++fMg+fmdzdkzhrE49Ke2d6xi7DbL35tpZTfEPaj871LQX8us1tzi88aVXgghreKEVR+Jxu7DbBzbUf5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P3W+Ra5chTERrtSDRHzCHA7shanpdgXBZfzKXrXVd/w=;
 b=l9yy5zfhPRkj31V8MAz6wsutAyO1UnEtdBzBOJVHL0hYy4CH2C2tFjPYHUQonfFVhRVt1EspN2baz4qgpCENiQ3ShpJLQEWH8RsVVfUk4LFvc0dtKMNr631cxeaZYA3LGUPZhonFz4XH2+3N/TJ5s2IdLbvn65VKrQt65Su7muyCZ5Q9lC4hQFnnKUnPaMkhp19GMFAUGXybNp7KpfwsPaZy78UOlvUlHoSOQaaH/agKNlhD1bA5DUmt8Ya1TQaDraVkRRkqKoQ28cp6byutQ+X87OVMGBno5d0TItBsH2YTmsjmltYR4GYrIeJImOrcRW7eb6M0yaX141vfo9qhWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P3W+Ra5chTERrtSDRHzCHA7shanpdgXBZfzKXrXVd/w=;
 b=pKDpjXWYecSIK5UjIorG+RG7aOduHGHOf2KYOoDiUqz3gpSRpQ71Q26jbz0USuId2PyGZ3GFfBX1niEYoW0rh9Uj00GpP+yWw1MLJMUU41CmyAOs2rryvKTzmdN6E2lasEvXpDZxMDcRL6RerwWzQUv0xvIZbTnWom8+6UD/XSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8189.namprd12.prod.outlook.com (2603:10b6:208:3f0::13)
 by SN7PR12MB8172.namprd12.prod.outlook.com (2603:10b6:806:352::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 11:56:49 +0000
Received: from IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48]) by IA1PR12MB8189.namprd12.prod.outlook.com
 ([fe80::193b:bbfd:9894:dc48%7]) with mapi id 15.20.8534.034; Wed, 19 Mar 2025
 11:56:49 +0000
Message-ID: <0ed6faf8-f6f4-4050-994b-2722d2726bef@amd.com>
Date: Wed, 19 Mar 2025 12:56:43 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: Chenyi Qiang <chenyi.qiang@intel.com>,
 David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
 Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Michael Roth <michael.roth@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
 Williams Dan J <dan.j.williams@intel.com>,
 Peng Chao P <chao.p.peng@intel.com>, Gao Chao <chao.gao@intel.com>,
 Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
 <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
 <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
 <58ad6709-b229-4223-9956-fa9474bad4a6@redhat.com>
 <5a8b453a-f3b6-4a46-9e1a-af3f0e5842df@amd.com>
 <9c05e977-119c-481b-82a2-76506c537d97@intel.com>
 <4fd73f58-ac9a-4e24-a2af-98a3cbd6b396@amd.com>
 <4bef4a8c-6627-4054-83dc-79d41ca03023@intel.com>
Content-Language: en-US
From: "Gupta, Pankaj" <pankaj.gupta@amd.com>
In-Reply-To: <4bef4a8c-6627-4054-83dc-79d41ca03023@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0283.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e6::12) To IA1PR12MB8189.namprd12.prod.outlook.com
 (2603:10b6:208:3f0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8189:EE_|SN7PR12MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 429ba22b-92b9-4e12-f8bc-08dd66dd2167
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T0VTSFV0VDVRVHptbWZVWlFmRWVQbkZTZjJucWdVNlJXL1ZEUDM4ZEZlRHFK?=
 =?utf-8?B?YmUwYmpOdmRiNDB5Nlprb3FBUUp0V0c1RXlCVm95cUNqWWxtcno5OUdNR2hv?=
 =?utf-8?B?clE3dk9rN01oSTJxMWc5b29VN1AxS0VudXhMY1JsRHJlY0FBaS9BWjROS05o?=
 =?utf-8?B?d2ozcTdPZ2pxb3hOZUpSOFRmdm85TUVPVWRqUWgrZHhPeHZlVm9PaE5uSFlp?=
 =?utf-8?B?bjFIeVh3VE9HZjU5RlFFVGtnVUdmeS9lN0JNYUJvUzJJNmpUSUFMSksxaHM1?=
 =?utf-8?B?VDRrTFdQWjdxV0tSWkJ3T01DQlZhNlN6QWJNbEVkY2pqUHdhcFJMbHF0cTNs?=
 =?utf-8?B?ZnpGZTVuaTRzYUh3KzJ5UHcrelROemd6U2ZaV1JuSm02eklaM0ZMQ0d3WjI5?=
 =?utf-8?B?TXhHTko3cXZlK05hdjFPM1pmVm9ZNVZ1bklWTmFFWFpRaTUzSkVKVzRKZE1k?=
 =?utf-8?B?TjRlSjNBaHMxRitpRnVtTGJOMUF3aEd4OWgxamdqNlNWSUpubzUydXd4RGFQ?=
 =?utf-8?B?NjA2bmQ2MUJrZjdibGdoZGV0R1d5eDB6RXRFTTUxM2RsM2Nod0FjM2x0am9H?=
 =?utf-8?B?a3dKb2FEaDBjWUVSSlFsOWVtY3ozZFdpUXhwbEhkVVR3MFo4aE9hU0QxOG9Q?=
 =?utf-8?B?alFGdkFTL2oxM3ZBK29WM0hweUVlN3VWNjc1cThpaS9NQnNPa2VpUVp5MlNH?=
 =?utf-8?B?cllRMGgvVzNGMEE1aVNVdlpEdnBVakNhVkdubTRFM1ZhUEhDY0JGSEc2U01X?=
 =?utf-8?B?a0FMdUFZY0xrY3pUSTlOUHFNS0IzVll4bjhuTFRsY2JtS2ZlR0F0cE13ZjYv?=
 =?utf-8?B?b1gyRUw2VHRvUW1nVlZDdXlJc003QlNPVE8wWVVlR01qcGNSSTNOZUZVdDMy?=
 =?utf-8?B?ZFB4bzN4TjJxdllLeTZJYmtUMmhxbWJSKy9MblEzZVlSanNnVEU3WGx3Ukxs?=
 =?utf-8?B?WXVoZjhlblZYR0NhaHdzNUg1TGx1SGt3aDJOQ0d2UnZpNlBWeFc0REFiSkNh?=
 =?utf-8?B?MHp2RUdHNFFyZHFDTEhrcTN4Q3hCVzhKRXRUem5FVjdDYTNEdHd5L0dhZkw3?=
 =?utf-8?B?TWFvRDl0QXg5SncxYnlHK1E2K01mY2pvd09ISzgrZk94Y3QwN3QycXFWR09y?=
 =?utf-8?B?S3lUZ1gyaWVOV3E5ZjlNZ2FNcDl4MmR6ZzlscnFjVTJNemhobW4vcXhDQWd0?=
 =?utf-8?B?TGwzOUQ3T3liSHpLODg5RW55VWRQNGd0TGd2T2w4QjQyekZrR2c0M0MvcTU0?=
 =?utf-8?B?RE4xTFRSSWhnQVc5eUNqUE1ibFFxU2VkZHRPODA4QUJSb1lvYVlEQVNIamZI?=
 =?utf-8?B?MVRlV25YQzNRVnhzekNSY2JMYXAydVJLNDZEVUxGUEVvRi94U2lacGtJOW5S?=
 =?utf-8?B?QlFpY2Fycjg0UERkeDcyQTlZQldTbnNLblFINUFsa2UzSkU0Y1FrYkQrNDRT?=
 =?utf-8?B?dmdwd0d6TVlDbXlpaWEydFV2YU5uNVp1VkQvRXlvdkc1K2VHc1MzNGFySGVZ?=
 =?utf-8?B?cTBWSjIramVFaGhXdXk0MDlxajRjano3Vktjbk9tRCtvbDl5SVhUYlBBcDFE?=
 =?utf-8?B?aEhJcG8xSkU0QUdLMTVlN3RleFMvRXQ0RWpSODczZmpuTXNGaklVU0s5dVI1?=
 =?utf-8?B?UXZFVTJId2hidjZJV0xZejRUdUxJNjZlZ0lwVXVyOEVtdXBub1Zpb1Nnc1dC?=
 =?utf-8?B?NnQ2OExJQmdqcEtHWHhYNEFIMmNHZ3lURWk5b1F6WW91Wlk0alk4LzFXeWEv?=
 =?utf-8?B?U0pDS3FhNHRQekJXTFZyeVVPTXVpMDNnNzZlTit3eVZIaTQ2ZFZOYnA3M3dU?=
 =?utf-8?B?ekNmU2JrQkFMMzFrZy9UbENOaGY2MWZxV0xpRXVkWEdKTjJ0cExUMjEvV2NI?=
 =?utf-8?Q?gcSrhS7TNQVXC?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnBXMXF6Q2ZiR0ZoMzRyd2k0ZHNUZUxYN2o2VHJLM0NOT242NmE5TkZaZTZl?=
 =?utf-8?B?emZHRE5tQ29ZTWZ1dENQb05YMU04cDBkWE0yb1BWOGZaaUdUNUY1SGR0VVUv?=
 =?utf-8?B?bWJIUmt2NElnVTBSa0tmQWdRYk8xTEVzMVA3c1dlaHlsK1NDZnIrMGJKRWtT?=
 =?utf-8?B?ZStpUnJaRnJLVlJ1eTNzcWJGNlhsdld6OWlFMWEvTVhsVG42cDk5WFJuQWd4?=
 =?utf-8?B?ZkY1L1NNWGN3YjlsUFNqNGI4WEN1Z0ZDUDV6ckc5UEpobWU2c21TOGl1RHpo?=
 =?utf-8?B?MzdYYVFSa0pabXk0ZHFONGlRMitac24yM3V6OVA1WFh1alNtRlV2c3N4ZTI3?=
 =?utf-8?B?bWxmYnBwbVk1Tm5DOHFkb1dMV241S2J2d1l6TG5nclFXYkMvUTBpZTNXc096?=
 =?utf-8?B?ZkUxaXdvK0tjZ0dzaEw3K1V3RWZBdEtpVjNxeVgxQmlya0RQR2xxR0k4cDhw?=
 =?utf-8?B?NngrTEJXK1JhZGpjK3hob1RLSXdKQml0cXpSQlRSZWgreXVvQUk2Sy9Id3Vo?=
 =?utf-8?B?NDZucjQ1OUVKMUlXTDVTQTNHa2R0OFlSWWFPZjd4QTJsTFR0Z1M0ZWI3UG44?=
 =?utf-8?B?WGtOMzNPVC8rYnl4R2RVTk80cW9Ea0FJYTVDMHRkdU16ZzlGQkIvY1RvTjJi?=
 =?utf-8?B?RWZuV291dUlQNGIvYVk2WTBlLzJENS8zb2lEbVF5NHRVb0k3R3JzN3RERG93?=
 =?utf-8?B?a1BFUk80ZmU5SDJ2TnFrOGtuSkNZV29KQUxTeTc3a3N2cjF2OHgwbTRHMHEr?=
 =?utf-8?B?SVZ5WTlpTXlYbkEyaFpWRFlOQ3B2SWhBd21GUWlTUkx6T3oxTjdlS2tpQ2Yy?=
 =?utf-8?B?Vk9aS1hBc2tjeVpHZnd6MFRGdk8yOGtlS1FzMW5xL2ZzQXZucHlFcTFzcWhM?=
 =?utf-8?B?OE5Da3FPM1RoeFdveWN5M2kvZkJHeGdlWm0rNnE0eFhpVm1YUDlveW5MM2dL?=
 =?utf-8?B?aCt0Z1FwU1FFQUlpSThOS1ZqbHlBamZHQko0Z1dkNUk2U2NXaU1ybU8xKzc0?=
 =?utf-8?B?cER2S0VKL3plV1FUemd1U2YrM0VCZnVhUC9xZUphNk9hNHhrd1pEZ3Y0eW1S?=
 =?utf-8?B?UE1FZVVTcHJFOERraWZtZ0szWkt0NmVGZnd0cWFMSkY5alpwK3I1SGZRZWNR?=
 =?utf-8?B?ZXM5UHQwS3JIL0gxVnJpaDdoRDVLakFXdDZWOFNnVGZtUWNMUFVLbXRZMFFu?=
 =?utf-8?B?UWpad2JEMWZ2cmJTc2t5ajJXRVRQQTFsanJkM01YTlQ5SDNrcWdmeEZTblFw?=
 =?utf-8?B?TmltS2tNallXZmNDSjVsbzFMWElxN2hRY3ZsaHU0WEN6WDcvczU2ZC9KeE9P?=
 =?utf-8?B?b1I0L2xocThXWXU4Z0t0akgrTWJNdUZLWGlMOEVMQlI3TGllcFBDN1BzeSs0?=
 =?utf-8?B?OXo4Z0ErSVdVNlU5NFl1MVMyNGI3QmRpamlrZlNzaXFSNkcrMzJRc0o4YWd3?=
 =?utf-8?B?VVdpeDRXczFkeUZuTWl0NDhYbTFXdmZ5ZzhFcGQzYW1OUVZONUNrTWhrd05m?=
 =?utf-8?B?ME9HWE1yT2gwcHdIMktYS2lIKzhvcU9VL2N5UnR1SXNOQ2tmeUZCRFR3MzI0?=
 =?utf-8?B?bjlJVVRDS3IxQXVRUFlITjBoclFyUUlpSDBKaUZuZGs3cFJZQ1hSM3hEdTB2?=
 =?utf-8?B?cHRqc0k5N0tnM3lmUC9OUkE0NHBtaHc1ZVRjVUhzYW5BYjYxK0h1UkF0cXI0?=
 =?utf-8?B?eXUwN0pOSUpMc3ExNTllMmdPZHk2YWhwajNTVGFhaWNIelM3aitiSmJLWjM1?=
 =?utf-8?B?d1BoN1c2TzlPYmhsUFljQ3lrSkcvMlpPRG8rUkdqRkMrNEJSdTRmYkYyV0ZT?=
 =?utf-8?B?SUtEYU0wQ1d0M0svWGhBdUl6dlVaZ2Q3RmJTZXZlNTd4eXFDZlFPWWREOFZn?=
 =?utf-8?B?UHI5L2lOU3B6cXhCRS9jMEh0TEtZN05pRWpacjA0ckQ0bEdUU1BCczVUVUxw?=
 =?utf-8?B?dEJSSlZxREdnVkd4YnRSOFZDRjZ6UWtiOXV0T1FzSzZuZ3kvcFpzRXZmVnI5?=
 =?utf-8?B?N1grTHA3Ty9LN2FKazVPR3BIWDBkL2F2YXd2MGdFM1ltOHQ0QzZLN3RsSUVv?=
 =?utf-8?B?Sk1Ja2lYNGxFUHA0SEtQZndIWGszNG01dDdMUzBzYUxZeWIyYnd4cGo0L2Nz?=
 =?utf-8?Q?owg65k3quElyZLL95YKAOBpf3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 429ba22b-92b9-4e12-f8bc-08dd66dd2167
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 11:56:49.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJTeeMXAWRZERiO16zDdDp1y8iKgqb/lCdsI6BTKssJfORZr+yA78syUEp1e6RoiPzBIV90FOiffMQssTmaQ4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8172

On 3/19/2025 12:23 PM, Chenyi Qiang wrote:
> 
> 
> On 3/19/2025 4:55 PM, Gupta, Pankaj wrote:
>>
>>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO may
>>>>>>>> disable ram block discard. However, guest_memfd relies on the
>>>>>>>> discard
>>>>>>>> operation to perform page conversion between private and shared
>>>>>>>> memory.
>>>>>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>>>>>> device to a confidential VM via shared memory. To address this,
>>>>>>>> it is
>>>>>>>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>>>>>>>
>>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>>> adjust
>>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>>> adding it
>>>>>>>> back in the other. Therefore, similar actions are required for page
>>>>>>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>>>>>>> facilitate this process.
>>>>>>>>
>>>>>>>> Since guest_memfd is not an object, it cannot directly implement the
>>>>>>>> RamDiscardManager interface. One potential attempt is to implement
>>>>>>>> it in
>>>>>>>> HostMemoryBackend. This is not appropriate because guest_memfd is
>>>>>>>> per
>>>>>>>> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
>>>>>>>> particular, the ones like virtual BIOS calling
>>>>>>>> memory_region_init_ram_guest_memfd() do not.
>>>>>>>>
>>>>>>>> To manage the RAMBlocks with guest_memfd, define a new object named
>>>>>>>> MemoryAttributeManager to implement the RamDiscardManager
>>>>>>>> interface. The
>>>>>>>
>>>>>>> Isn't this should be the other way around. 'MemoryAttributeManager'
>>>>>>> should be an interface and RamDiscardManager a type of it, an
>>>>>>> implementation?
>>>>>>
>>>>>> We want to use 'MemoryAttributeManager' to represent RAMBlock to
>>>>>> implement the RamDiscardManager interface callbacks because
>>>>>> RAMBlock is
>>>>>> not an object. It includes some metadata of guest_memfd like
>>>>>> shared_bitmap at the same time.
>>>>>>
>>>>>> I can't get it that make 'MemoryAttributeManager' an interface and
>>>>>> RamDiscardManager a type of it. Can you elaborate it a little bit? I
>>>>>> think at least we need someone to implement the RamDiscardManager
>>>>>> interface.
>>>>>
>>>>> shared <-> private is translated (abstracted) to "populated <->
>>>>> discarded", which makes sense. The other way around would be wrong.
>>>>>
>>>>> It's going to be interesting once we have more logical states, for
>>>>> example supporting virtio-mem for confidential VMs.
>>>>>
>>>>> Then we'd have "shared+populated, private+populated, shared+discard,
>>>>> private+discarded". Not sure if this could simply be achieved by
>>>>> allowing multiple RamDiscardManager that are effectively chained, or
>>>>> if we'd want a different interface.
>>>>
>>>> Exactly! In any case generic manager (parent class) would make more
>>>> sense that can work on different operations/states implemented in child
>>>> classes (can be chained as well).
>>>
>>> Ah, we are talking about the generic state management. Sorry for my slow
>>> reaction.
>>>
>>> So we need to
>>> 1. Define a generic manager Interface, e.g.
>>> MemoryStateManager/GenericStateManager.
>>> 2. Make RamDiscardManager the child of MemoryStateManager which manages
>>> the state of populated and discarded.
>>> 3. Define a new child manager Interface PrivateSharedManager which
>>> manages the state of private and shared.
>>> 4. Define a new object ConfidentialMemoryAttribute to implement the
>>> PrivateSharedManager interface.
>>> (Welcome to rename the above Interface/Object)
>>>
>>> Is my understanding correct?
>>
>> Yes, in that direction. Where 'RamDiscardManager' &
>> 'PrivateSharedManager' are both child of 'GenericStateManager'.
>>
>> Depending on listeners registered, corresponding handlers can be called.
> 
> Yes, it would be more generic and future extensive.
> 
> Do we need to add this framework change directly? Or keep the current
> structure (abstract private/shared as discard/populated) and add the
> generic manager until the real case like virtio-mem for confidential VMs.
> 

Yes, maybe to start with we should add new (discard/populated) changes 
with the new framework.

In future the current framework can be extended for in-place conversion 
for private-shared conversion (if require userspace help) and virtio-mem 
like interfaces. Important is to have proper hierarchy with base bits there.

Thanks,
Pankaj

