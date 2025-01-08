Return-Path: <kvm+bounces-34740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D27DA05252
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 05:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ACED167B11
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 04:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E571A08A0;
	Wed,  8 Jan 2025 04:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RkvTHmh0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164192594A1
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 04:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736311678; cv=fail; b=gYVSdUke0PKmA3tGoPIZdYoIDaI6e1DKCddG0D0Hb95lDV9vTLI6kjr1nA3rKdVN/LBWs5agQarksFFQyVhsMzNUFQGiwBgxKaGNehjkuNvLU1NDl53An7HN1S6DrG1HrE6DocJOd36nasimmS6VE9LDJJVGLV6XQqjzSTh07R8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736311678; c=relaxed/simple;
	bh=Da1qY3tqrHcPFMoEs+j1YQGYfkfJgUurmwbCUkOZa5M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SEnW046WCSLVSvfxO362BMGoL4vVew6dD2QXwNEYBypXot63KW+/Ux68eVSNLld/oBkLMBKjRFm+Nrpytep41acsdz42U2i/Q3X1z4b9OZ1Oz0XHnRmYXhQ/Lpm4Wiap/MwMOmVyq8VTomhvjrz6XYJPboFuD5IMn+q3bOHKz30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RkvTHmh0; arc=fail smtp.client-ip=40.107.220.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZTgkFTvRx5Imomz0JtXTSpRsfGx81bCNRheMf+/KlL25z58vdOQFwrePrACHq8KqsI468AocsSLWvkX6qAAyy4D2rEEe62Fndz9VArP651Ywh5g6lLakfcVzAM5fbdJmi2x7Yyy+8y3UOWDR+Nw133FD8WCUQ4dkygc4mG2Zw1Bc/MZws6o6/J2XuvQh4TlTHo30qxCw4LSSmSAmn8dbz/2MKtvHEn9UNWlh9eLEf/G+FWbqQVV3ODUlSpLk3SRsAFwWePHtXaOZPy5kJ4Swpl6QLupq4dDl5t8drGWb6DYm1nWAOGV9+xoHYg4KPUVeqNbg1o/HLleOO+Rct1Qfcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzAly5QRUUCquuJ/VbIhURNhFiufLQl2CWVmjZos6Mo=;
 b=IYqxFfL6W0rVCVv0tGQ5uVHAneqBMWcd029rqXkj00Ol74fHKwzisQ/+VEgsAJ5+Tdw3Y5SjP6sGYsXvtjh4q3ItcoKwzDQbpSU3gNf3w5YxSYPaiM7Mzxx+DXyKtQ9dmVvax/rPAsCu3YkOjvTK77p1WN3ImlU+/Zxd0kr3edQucxkix8ZvVyOtseU+giDcE3csl/ojs9Z56Thaxhw5+71+a012C3FOTTzXl6evPnINj/uiSeTJumhdy9EXK9yiZaCJeKgvKZ4dUWZQANYo1nRDuoZJ+f9DpGanUB6W+NDYMvcDfMUWYivrUuGLwEiANFzPyRjyM4iT9cBfd6+2Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZzAly5QRUUCquuJ/VbIhURNhFiufLQl2CWVmjZos6Mo=;
 b=RkvTHmh0FGCJ6YhTfNHJpBsF2GNiMNtuW0gJ6sgfgZ0C8fqnOiNP2P72THUsk1i1JAUpfIo1YLJIS5bfkTQRpuoBeuaJZzPjnP521LjIeQh+9fRpE7+gvP8UUbE4fA4T4HkRHTUSCVgbR/wZSmdUon9tAv0ZPPI2AQR1eXIYGZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SA1PR12MB9247.namprd12.prod.outlook.com (2603:10b6:806:3af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Wed, 8 Jan
 2025 04:47:51 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%5]) with mapi id 15.20.8314.015; Wed, 8 Jan 2025
 04:47:51 +0000
Message-ID: <2582a187-fa16-427b-a925-2ac564848a69@amd.com>
Date: Wed, 8 Jan 2025 15:47:47 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 5/7] memory: Register the RamDiscardManager instance upon
 guest_memfd creation
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
 <20241213070852.106092-6-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20241213070852.106092-6-chenyi.qiang@intel.com>
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
X-MS-Office365-Filtering-Correlation-Id: d8007d81-bbf2-4d91-c27d-08dd2f9f9b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NEpNRnVXdnVxT2djUi9hWFFwTzEwSkhQaTZobXpIdjVxUE5zaUhqZmlSZCt0?=
 =?utf-8?B?NE4zZE1WYzVxVmxUTE16eStJbllsM0RDQ1JqSEtrakpjMHR6VUNCbzZLUXY4?=
 =?utf-8?B?SUVwWWVFc3JiUUdkWS9sR2Z4ZUFaRkdBT0s1VGlENlN4WTVGdnBkR1JxTXpO?=
 =?utf-8?B?clNLMzJYaG5mVlpRaGhSZVAxSkNESEl4aTN6bVJXQ0tYeDVKbFc5d0VaOWFx?=
 =?utf-8?B?YklDVEkzMXFIVDA5KzRhUVhyRTZvUytkblRucXZYRWFYSFY5Z0o2VGI4ODJm?=
 =?utf-8?B?ajlDMEgyaXNrL0VQRnVMcWZ6ZHc3cDVTdnpUQlN4VlFoU3E1cXJZSFpsYjVL?=
 =?utf-8?B?VzZYT1hYZVJueDZ1b0ZNVmk4OUhxSGc3WHloVzNzR1pxOEJ2cUx3aGRHMDFY?=
 =?utf-8?B?ek1XR2YvQlZ4cEpPSWNvUVlOMTRXZkRHS2I4UmRBSlo3cUdvZ1MraGRHc3Jk?=
 =?utf-8?B?YXRUL0tsbjRPS1didmxLY1N4SFJEYUxyZWhvTVpTTG1WZHIyZCtQM1JIdlFq?=
 =?utf-8?B?eFpZdmNhNjg3Z3BKUjNoVUFLdmtNZ2Rad3o3YS96emhONW1qUUVYRDB6Umlz?=
 =?utf-8?B?UWdZZDliQ0R4R2JxSVUvdGNtSE5QdE9WeVA4bW5jQytwZ1h0K1AxelJSZ2M0?=
 =?utf-8?B?RHZlMXNJaTFKL3pFd1djY3B4eVowYXlQdyt5WStHdnNGSjJBZVFqY3JieEY3?=
 =?utf-8?B?S1prTDJRTStaTUNZa0hhUUM3YUlSS2lZdG1pN3A1bnJ2dHBwZE9TcG5GNGVa?=
 =?utf-8?B?Z3drQUZFOFV0dDBJNlRWME1JcExNaTBleFBCc1BOakJCekZzQmZyMDBPRmhM?=
 =?utf-8?B?NDhWVW5INWtYVGtubXFSaC92NHhXd0FSM2x0QWJzdTR3L2UwcTRQYkt3ekFs?=
 =?utf-8?B?SGQ3UjZZaDBBUVBUamNiVXVvUkNIN25BVEJMT1BFdmZRNHpFeUtRYk4vM1NE?=
 =?utf-8?B?UWlhVGs2RkxuUXY2WHRUVDJxQWkxTHVuY0F1NUdMd0l0WWg3TzlqeFgyL2N0?=
 =?utf-8?B?RjNiSENpaVViRXlON3djKzZHTTZ4emVvNUNsZktLRWtQL08rNDJySnRMYkNa?=
 =?utf-8?B?bllhaUtlQmg2cmxlOCs0MnlWRHM0Y2kxcFhuZ0F6VUlxTjl3NUxrTWhyNWxh?=
 =?utf-8?B?SFRJSFJCY1dJem8wOVVIRGdzRVNsZndtQVJuTktldlIwU3hmbEpDUnBPaDhz?=
 =?utf-8?B?NzN5S1JUVHFONFFZcmFCeng3c2ZxNTN5Mzk5b2dsOGdnQWlDbS8yaDZSY3pT?=
 =?utf-8?B?ampacjIvV1luc3F5YVBzdC9UQUM2eFZQRFdRVU1UWlR4cFJzVHRlNURxd3I1?=
 =?utf-8?B?dTRyRWhheW9ZN3haL1IybFlOVDFsajZpamovd2prZDVNbDZyZzZYc2l0dFVF?=
 =?utf-8?B?RDJqUDNpajVmSWF2N1c4dTh4Q0lxTjNCem1CWGFDaDdPNzc2Y0ZJdEx3ck1U?=
 =?utf-8?B?dG0rNVhSbG9HckozT2h3Tmsvc0pZVHJQNHZVYjM0OW9MUmlCRi9SdFlXdHIx?=
 =?utf-8?B?dlZrdnB1UjVsQnhQOFRyWXVpWnk2QUZvbEZqMU1wK0tuaU5kNEhUa0pOWTJz?=
 =?utf-8?B?d3FUUTZJWXhseCtTeVd1b0JRV2pNQllKTVkweHpaTTRiUzJzdlhzSEtDYXdU?=
 =?utf-8?B?cUlZcmhxOGovbjhsNkhSVm9EUVdJR0xwY0JmUHRsZ2FQQkRFTWg1L0NXOHdF?=
 =?utf-8?B?YzRwek9ENVhFVXQ5VlNvQk5sZ21pUTVPT1ovZmMzVkwza0FLUUxjSmNrUDdX?=
 =?utf-8?B?Wm9KUU1rRHNxbStlN3pCWS9pN1drQzFSdmlaNFJ4L3VjZk90a2IzVUtLU0pL?=
 =?utf-8?B?aUlIY2toemlGaG5HdFFXbENXSDVLMWNzK1JWQ3lpalZHdHpseUd2QnVXc3E3?=
 =?utf-8?Q?Zs+XrQB1rhfPs?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?clhBWElycVZOck5Uc3crYTVaWkdWK1U4N2d4ZFgrM0VyN2JZL055bTNGTkps?=
 =?utf-8?B?OTFvSjBhTllkUzZsY0dPSFVPZGxvVjBXVGhKSXBYdWFZQUd5SWo5cXc5YS9s?=
 =?utf-8?B?c0pEK2lSMlM1OWFzVE9MaG1vbHNTeENySkhvTjUxMzJpOG5kRGlwVUlpS0E0?=
 =?utf-8?B?SWYrdXJQVnNWVm9VNzZjeW5aeE04OHIxaG5uZTNOY3JzY3hkVCtReFRjcHZG?=
 =?utf-8?B?WGI4ZU1WeE1Gcmo2N29mdG9ONmc5Z2M4NDlldFpxZU1OakJiZVQ4VGo1NDRX?=
 =?utf-8?B?eGNsTmh2SjZlTlF1VkphaFkwWmdETDVQM1VNbloxd0hrRTU4VmNJaG1ES1pR?=
 =?utf-8?B?QStsNG9PcGRnTzBLZGZXMmhzT3QvbUplQ1hrRVU4bHRUbDVtSjhNWkIrZlc1?=
 =?utf-8?B?aUZGb01JakwyR3BRZGNsaE9PVmV3Sk9jbmpyMnVIT2ErR0g0cGRUZXpYMmVT?=
 =?utf-8?B?YUR4WUc3SVM2YVQ5SnRvMkxsYlN5Zm45SWxVWDJhM1U1OGdrL1dGblo4VWZl?=
 =?utf-8?B?U1hOY3JFWDEzWS9mVS9Nbi9wbHFHdjJrSVArYmlUZi9NWjNHWUMvRE11b3FZ?=
 =?utf-8?B?L0xSUmhYR1BjYjd6R1hMcU1CUGxwR1cvMmtwNVd4czZBK1VRdHBkeDRXZ25T?=
 =?utf-8?B?MWpqOGI1MFp3WkdoYjhmb3pMTEpCUzROSjI2eWc5NnFZbCtCM2k2RXJtaVBV?=
 =?utf-8?B?a0M0bWdjbkZOUmVtSFlXNDZBK291bUxldXpMUTYvbVVDYWk1NHlBaU5acEIw?=
 =?utf-8?B?UHJuUHZVa01UQ08xV29lLzlPa1Z3S3hvNDNLN3o5WXFqU096SjVBQlRsQmls?=
 =?utf-8?B?STlVeDdhUzlweWR2aGlwTWdBeDFNWlhiUFpyN0pxSTdxY1podVBUT1JBVUZS?=
 =?utf-8?B?MDNidGJMelJOSjJ3aTQyUE11MTd5NUtXV1EzVlRNaHVpT2xjU2p2TUtUcHI3?=
 =?utf-8?B?aXNJLzRYcnhTUzhIN085d0ZEUC9heXVkbU9DblhhL29STkdkcnVPdWE0YU4v?=
 =?utf-8?B?dm9BcTdkZVZwMmdDdzJrYUNzeXcvV1BzejgwS2pOOXZtU1k4RXdYaHEyVXZT?=
 =?utf-8?B?V2VCL1l6WmFOQmNDT2JUYjFyODlwMWVMcUdvWjl4VUl5Uk5JeWxpc0xTODJK?=
 =?utf-8?B?WkxpWFFldmtURk9lOVozandsM0FadldPYTVoc2hjRWhBNG9RQkNpVER6WlVW?=
 =?utf-8?B?a0lmdks0blhQcG83OTVRRkNBNXpsaCtGd0pHOVA3YktodGtRZnpha3I5ZVph?=
 =?utf-8?B?Y3kxdnNJVWQ0K1kyUkV3Vm56Nm52VEJsdSs2bWtqOEt3em9jckpZTDdoMWdM?=
 =?utf-8?B?RFBZeHdDUjZGcmIwZGFvem1jdWpCZXltYnBEQkluWGczUnRpQ0NhaEcvZW9V?=
 =?utf-8?B?NHI3RSt2VWRsYVBzNzVsMSt6SVQ1SVJ5K3dCRkJMTGJKc2g4NDdzZlVNcnE5?=
 =?utf-8?B?SXVZNnFWWUdoTXNsd3ViTUh2eHJ0MXJqRGFDZmtDWVNmT3VWZUVwdlIzdmVM?=
 =?utf-8?B?V1A1OGpDQXRqU1I1YkpJcXhhR3p2TWRpclBUUTYvQWZvVlpiZE5IMDJwcDFG?=
 =?utf-8?B?ZHh5b1hOUSs3VVdPaGhQVVdDWERza2hGaWZ5WVZIWWtrM0Y0ZG43ODhlNlp1?=
 =?utf-8?B?SnpMOTdGbXdhZWdkeEd1N1IzTXczeFVWM2pUeHo0UkNTZkF4ZHVydHNpRFNq?=
 =?utf-8?B?OVBBcTkzVDJpaXJia1J2MEQ4MDlrYS9oazlvUXhtWkY0Ynd2QThMam9WcS9O?=
 =?utf-8?B?UFpnVWxaaklxT0VWRHJMbjFBQVNsR21aSzZubDZxbFl6U3hoTjljaGNQVG5L?=
 =?utf-8?B?NzVBdmRqd1RESEU5ZmxOcThWdzZtZUgzVGQ2SE9hRml3eTVwL2hJRHNmNzFj?=
 =?utf-8?B?VGw1WUtTMkNOc2NEMndOT05WdkhKTHpyZWJ3NG83NXBpbXdsYTRONCtkaXYv?=
 =?utf-8?B?Nyt4WWdQdHBhUTN5RXB4L2ZmUXZwTTYrSExINkQ2MkhoaG5wNjNGQW8rOGVm?=
 =?utf-8?B?ZEVidlpwaGZIL0RzVjBvU2xURU1BcmpnNHpmU2RVUGs0UUNmbkg3M2ova05v?=
 =?utf-8?B?WmR0VDNnSDZIczBEbzNUZ0x4ckVobHVlQ1JIRWh4YW5XSnVBU21RWWRYNWVU?=
 =?utf-8?Q?/RVPITi7OyCKwr85k/ekC70d9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8007d81-bbf2-4d91-c27d-08dd2f9f9b72
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 04:47:51.2239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yJd+afCPNthQUkYQNjvCIXvm1rHp1pd0ld3qgl1xxVW6XhRraVrDA4F01tTh18PpDm8uapo/3k8tToxb7g7z5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9247

On 13/12/24 18:08, Chenyi Qiang wrote:
> Introduce the realize()/unrealize() callbacks to initialize/uninitialize
> the new guest_memfd_manager object and register/unregister it in the
> target MemoryRegion.
> 
> Guest_memfd was initially set to shared until the commit bd3bcf6962
> ("kvm/memory: Make memory type private by default if it has guest memfd
> backend"). To align with this change, the default state in
> guest_memfd_manager is set to private. (The bitmap is cleared to 0).
> Additionally, setting the default to private can also reduce the
> overhead of mapping shared pages into IOMMU by VFIO during the bootup stage.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>   include/sysemu/guest-memfd-manager.h | 27 +++++++++++++++++++++++++++
>   system/guest-memfd-manager.c         | 28 +++++++++++++++++++++++++++-
>   system/physmem.c                     |  7 +++++++
>   3 files changed, 61 insertions(+), 1 deletion(-)
> 
> diff --git a/include/sysemu/guest-memfd-manager.h b/include/sysemu/guest-memfd-manager.h
> index 9dc4e0346d..d1e7f698e8 100644
> --- a/include/sysemu/guest-memfd-manager.h
> +++ b/include/sysemu/guest-memfd-manager.h
> @@ -42,6 +42,8 @@ struct GuestMemfdManager {
>   struct GuestMemfdManagerClass {
>       ObjectClass parent_class;
>   
> +    void (*realize)(GuestMemfdManager *gmm, MemoryRegion *mr, uint64_t region_size);
> +    void (*unrealize)(GuestMemfdManager *gmm);
>       int (*state_change)(GuestMemfdManager *gmm, uint64_t offset, uint64_t size,
>                           bool shared_to_private);
>   };
> @@ -61,4 +63,29 @@ static inline int guest_memfd_manager_state_change(GuestMemfdManager *gmm, uint6
>       return 0;
>   }
>   
> +static inline void guest_memfd_manager_realize(GuestMemfdManager *gmm,
> +                                              MemoryRegion *mr, uint64_t region_size)
> +{
> +    GuestMemfdManagerClass *klass;
> +
> +    g_assert(gmm);
> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
> +
> +    if (klass->realize) {
> +        klass->realize(gmm, mr, region_size);

Ditch realize() hook and call guest_memfd_manager_realizefn() directly?
Not clear why these new hooks are needed.

> +    }
> +}
> +
> +static inline void guest_memfd_manager_unrealize(GuestMemfdManager *gmm)
> +{
> +    GuestMemfdManagerClass *klass;
> +
> +    g_assert(gmm);
> +    klass = GUEST_MEMFD_MANAGER_GET_CLASS(gmm);
> +
> +    if (klass->unrealize) {
> +        klass->unrealize(gmm);
> +    }
> +}

guest_memfd_manager_unrealizefn()?


> +
>   #endif
> diff --git a/system/guest-memfd-manager.c b/system/guest-memfd-manager.c
> index 6601df5f3f..b6a32f0bfb 100644
> --- a/system/guest-memfd-manager.c
> +++ b/system/guest-memfd-manager.c
> @@ -366,6 +366,31 @@ static int guest_memfd_state_change(GuestMemfdManager *gmm, uint64_t offset,
>       return ret;
>   }
>   
> +static void guest_memfd_manager_realizefn(GuestMemfdManager *gmm, MemoryRegion *mr,
> +                                          uint64_t region_size)
> +{
> +    uint64_t bitmap_size;
> +
> +    gmm->block_size = qemu_real_host_page_size();
> +    bitmap_size = ROUND_UP(region_size, gmm->block_size) / gmm->block_size;

imho unaligned region_size should be an assert.

> +
> +    gmm->mr = mr;
> +    gmm->bitmap_size = bitmap_size;
> +    gmm->bitmap = bitmap_new(bitmap_size);
> +
> +    memory_region_set_ram_discard_manager(gmm->mr, RAM_DISCARD_MANAGER(gmm));
> +}

This belongs to 2/7.

> +
> +static void guest_memfd_manager_unrealizefn(GuestMemfdManager *gmm)
> +{
> +    memory_region_set_ram_discard_manager(gmm->mr, NULL);
> +
> +    g_free(gmm->bitmap);
> +    gmm->bitmap = NULL;
> +    gmm->bitmap_size = 0;
> +    gmm->mr = NULL;

@gmm is being destroyed here, why bother zeroing?

> +}
> +

This function belongs to 2/7.

>   static void guest_memfd_manager_init(Object *obj)
>   {
>       GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(obj);
> @@ -375,7 +400,6 @@ static void guest_memfd_manager_init(Object *obj)
>   
>   static void guest_memfd_manager_finalize(Object *obj)
>   {
> -    g_free(GUEST_MEMFD_MANAGER(obj)->bitmap);
>   }
>   
>   static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
> @@ -384,6 +408,8 @@ static void guest_memfd_manager_class_init(ObjectClass *oc, void *data)
>       RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(oc);
>   
>       gmmc->state_change = guest_memfd_state_change;
> +    gmmc->realize = guest_memfd_manager_realizefn;
> +    gmmc->unrealize = guest_memfd_manager_unrealizefn;
>   
>       rdmc->get_min_granularity = guest_memfd_rdm_get_min_granularity;
>       rdmc->register_listener = guest_memfd_rdm_register_listener;
> diff --git a/system/physmem.c b/system/physmem.c
> index dc1db3a384..532182a6dd 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -53,6 +53,7 @@
>   #include "sysemu/hostmem.h"
>   #include "sysemu/hw_accel.h"
>   #include "sysemu/xen-mapcache.h"
> +#include "sysemu/guest-memfd-manager.h"
>   #include "trace.h"
>   
>   #ifdef CONFIG_FALLOCATE_PUNCH_HOLE
> @@ -1885,6 +1886,9 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>               qemu_mutex_unlock_ramlist();
>               goto out_free;
>           }
> +
> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(object_new(TYPE_GUEST_MEMFD_MANAGER));
> +        guest_memfd_manager_realize(gmm, new_block->mr, new_block->mr->size);

Wow. Quite invasive.

>       }
>   
>       ram_size = (new_block->offset + new_block->max_length) >> TARGET_PAGE_BITS;
> @@ -2139,6 +2143,9 @@ static void reclaim_ramblock(RAMBlock *block)
>   
>       if (block->guest_memfd >= 0) {
>           close(block->guest_memfd);
> +        GuestMemfdManager *gmm = GUEST_MEMFD_MANAGER(block->mr->rdm);
> +        guest_memfd_manager_unrealize(gmm);
> +        object_unref(OBJECT(gmm));

Likely don't matter but I'd do the cleanup before close() or do 
block->guest_memfd=-1 before the cleanup. Thanks,


>           ram_block_discard_require(false);
>       }
>   

-- 
Alexey


