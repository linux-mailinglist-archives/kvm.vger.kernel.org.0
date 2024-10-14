Return-Path: <kvm+bounces-28716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 550A699C47F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 11:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5B2C8B296CC
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 08:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DAF15697A;
	Mon, 14 Oct 2024 08:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rqMJRPT5";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="rqMJRPT5"
X-Original-To: kvm@vger.kernel.org
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE01487F4;
	Mon, 14 Oct 2024 08:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.20.43
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728896194; cv=fail; b=i3QeNAZQ/BWAl+mC+C84NvDeYaRLH2p5lucylRE16i5j0gUWT9Aycmd7zV+hC9fYU/nwQglgSOSGW9oRrX7CKQgHCRq1XvZToYSIXCWn5sjbMkHAQGcAFtE5NWa7pHM3+bbB8HqvhimThqmYcbIue4bfELw8xfyKQ9HhqtihE0Y=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728896194; c=relaxed/simple;
	bh=2eoOI3q5LEDLsLx+6KrYEkKYva2Gf3F23zpdQFClKPg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ErdVPQPsUfsAiaj/ST24GzZaudb4SBRT2vClZ1eJE6kZmi8PgjESzuZS0Y8QNYIrrcc4Fb+PT+sTNm1aZczVCABeth3mTJyE/btCEE+tctRm35sgF0R+Y3EYqOk9eqU+z7sWJnTr/MtcWJeFQlEWGoVZAOhD/1zgYWapJdUiyNo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rqMJRPT5; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=rqMJRPT5; arc=fail smtp.client-ip=40.107.20.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=vRlbNpmBi8Bv6XxWbk4Md4DOBWVU3++Bjv+mnKoLP1yZU6HYJ3ZL1iurkotbgEFgo6qrcwBuKEI6GiC9DnyWdRyWy0mP/8YNXqPTmDHiBhQ2yeTHZ+c4C8P8qc2pqd+u8UdkR3xApCOGIDZGf6nuzq7S1R4Hy1reVK/tjL6me6UmkxpVNCjFI7l4az+GMmywZwjptVkpZFIgfkJbM99u4Jt7PcdTEx1Gm99oyTbIszbwRpbk3Qzkm5E6xZ80LKc93BWzM9DDCeNqZ0gvxIYSgX5+e6OWGSJ2i73g7hdpa02ShjomA1eKvykQDvO5e2D3inPB3oFxr1Df5Q+XWyEaZQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hj9ulef/ECGcrazQrOsCM2HA8rJXxjA+D3YADl+rRpc=;
 b=qm/YHO7y/3tEV23ddjkWUGjAqCfLmMG04BkiKcmqXoPThcKNe2I3tduyheOw4J0tQtp6aKpvvRA9h/8RdtlDpxzVUyD3W6ZZeSinbo0czGYquaZX5pxqaZjKd8/h+9TPwnkrrUJ01HyRmxO4N79pFkVH5WYgKBC6jbmHlwk+ghA6hG+fB6cvGrvQaZs+l/GBWMb0Lcju6XOJyizm5EYObUNiMYinBeAjaVE/v5ZZq5HslVGmaAYECcw5yeZEGHqOu7F0Y+shB9PHgHx0eHYDAFya8iRhfHndDk1fZfNw+ygiuAecXXGvbV+3OgefY4J9rk3/TD7x8EQJIlNos2OZvQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj9ulef/ECGcrazQrOsCM2HA8rJXxjA+D3YADl+rRpc=;
 b=rqMJRPT5EZx2QuzL4Yv5JpE0/astDsMZ9ifWGxF57SqRajpOGKCw9fCYF6PrNs4a0yKXqwr/7g65Fy92aPcIDF3LXe4S8bj28ywxJr5QlgaxrBCbeL1LzP3U1/YNk81QTgWhg14Ye8vLyKhrHRAWqBhudXOuh47nrhyNQDCy3dw=
Received: from AS8P189CA0011.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:31f::24)
 by DB9PR08MB8740.eurprd08.prod.outlook.com (2603:10a6:10:3d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 08:56:24 +0000
Received: from AMS0EPF000001AF.eurprd05.prod.outlook.com
 (2603:10a6:20b:31f:cafe::be) by AS8P189CA0011.outlook.office365.com
 (2603:10a6:20b:31f::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26 via Frontend
 Transport; Mon, 14 Oct 2024 08:56:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS0EPF000001AF.mail.protection.outlook.com (10.167.16.155) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7918.13
 via Frontend Transport; Mon, 14 Oct 2024 08:56:23 +0000
Received: ("Tessian outbound cd6aa7fa963a:v473"); Mon, 14 Oct 2024 08:56:22 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 5604085107f330c0
X-TessianGatewayMetadata: W6TcyfcGyEb/Vei9lv8HJAMQDmox2ER3Xj/Q7v5gcGrudAF4tophR2DDHYk4E6jgVVNIlXoPhPV/+dWEfjKObt1KDzMDejO3FdOAh6NXlXzi9I06h/kh78ZIQqqHgmF4oMJIvLS2Mmh6DFpY3NgQn/CNty9XeonbYn1R2R1b4VU=
X-CR-MTA-TID: 64aa7808
Received: from L7b83a0262f09.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 5C623BA8-42A4-41E5-B140-CC887C14EC62.1;
	Mon, 14 Oct 2024 08:56:11 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L7b83a0262f09.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 14 Oct 2024 08:56:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yV2WQoR6LbK0ThR5Iiv1bo/S/tBCuPV+EE/kqW0CEk8qoGCtCQj7r60KP8cMGmlziO4uM0g1u0AC6TzaJ9YmFPlq8+8TreTV33G440xsMHF1gRyxX7DifWCAamanuTyU1fDCADAxRWWLWmgIacnUQDsRYerLRILoRgGKAEkoYDrp/caqPoE71PFzM2igjvn4F0X7O3Ukv4uzhHb9zK9QAKIOC2FTdMIy80ypWNrOS6cLMIiySIawJ0Gt+UXIy6Uong+CI4fV0Td0+ser5S2Yr8W5LkAmWxOSngSKVN5ZFvIJE2xE3rJH5j8ldpoR3GujviV9EiaKyRGO/n4u+EDkRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hj9ulef/ECGcrazQrOsCM2HA8rJXxjA+D3YADl+rRpc=;
 b=vOOfVkOUWcavzruWP2vIUJCxzIIZP04ZfTnA624yscqa4BpUBXDAjNOTi02JPueerX3aLW/CJZC3jh9Fb1OjkxwlyNh2yTsk9j6sfDuYIyN+TCsGNIh+/Xbz/z5vZJdI28OsmJnp1r3cicqZwOAQbyuPmvq5EaFaTYwJV0u3HHV6d+XE2DTSj+eLX1a1jccIGkm/l+fdg+sj5exLQWe/GFPmdKvdnP9oc/E6ZvuY8eOz9ShPD0nTwhyhAOtI9Dk8/xLQJWEAnOuZTj50S+KsYnsLLawFoJ8q5cJAo/WlknmTEgRVMaBMY/di8bWX2+JSc337Bquct5eiqs6Ype4tbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hj9ulef/ECGcrazQrOsCM2HA8rJXxjA+D3YADl+rRpc=;
 b=rqMJRPT5EZx2QuzL4Yv5JpE0/astDsMZ9ifWGxF57SqRajpOGKCw9fCYF6PrNs4a0yKXqwr/7g65Fy92aPcIDF3LXe4S8bj28ywxJr5QlgaxrBCbeL1LzP3U1/YNk81QTgWhg14Ye8vLyKhrHRAWqBhudXOuh47nrhyNQDCy3dw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com (2603:10a6:150:6b::6)
 by VI1PR08MB10297.eurprd08.prod.outlook.com (2603:10a6:800:1be::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.25; Mon, 14 Oct
 2024 08:56:05 +0000
Received: from GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469]) by GVXPR08MB7727.eurprd08.prod.outlook.com
 ([fe80::9672:63f7:61b8:5469%7]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 08:56:04 +0000
Message-ID: <11cff100-3406-4608-9993-c29caf3d086d@arm.com>
Date: Mon, 14 Oct 2024 09:56:01 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Sami Mujawar <sami.mujawar@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Joey Gouly <joey.gouly@arm.com>, Alexandru Elisei
 <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>,
 Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, Dan Williams <dan.j.williams@intel.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20241004144307.66199-1-steven.price@arm.com>
 <20241004144307.66199-11-steven.price@arm.com>
 <5a3432d1-6a79-434c-bc93-6317c8c6435c@redhat.com>
 <6c306817-fbd7-402c-8425-a4523ed43114@arm.com>
 <7a83461d-40fd-4e61-8833-5dae2abaf82b@arm.com>
 <5999b021-0ae3-4d90-ae29-f18f187fd115@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <5999b021-0ae3-4d90-ae29-f18f187fd115@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0197.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::13) To GVXPR08MB7727.eurprd08.prod.outlook.com
 (2603:10a6:150:6b::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GVXPR08MB7727:EE_|VI1PR08MB10297:EE_|AMS0EPF000001AF:EE_|DB9PR08MB8740:EE_
X-MS-Office365-Filtering-Correlation-Id: a4234b47-b686-4ac1-59cf-08dcec2e14b7
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?d2xIbC9oQkpQc3FKc0M1MEVuNWhUU3pGWmovS3d1UkxPcGJDb2t4ZVJ2ZXBk?=
 =?utf-8?B?K29SZzFtT3dFZFo5WGxIbG9IQ1NGR2U1M0NPYlgzZ1dKNnBNZktUTm1Tak1K?=
 =?utf-8?B?TFpqbXorWjVVOVVzelhvOEpCR3ZRYS9BOVl6SXRJSitlak11SXFhd1lQRG1M?=
 =?utf-8?B?OVlyZzVTc3h2cjlmOUhOSGgySzRsSHh6S0NURG5GbzNadlJsTnpadE03aWRV?=
 =?utf-8?B?NWtDN0JwOENpNGt0SU12MWJWZkprWDFwbElBb21qMnYrR0hhaDBFQnZpZkxM?=
 =?utf-8?B?aVFHOExzNWJydzY5NUc3R24zUGE2cDRiUEVFbVVSelBNMUtOdUl5REt6WnNG?=
 =?utf-8?B?MEdrdWswWXFESURkMDFYd2liZFFpd3VweW8wRTZaOFArNkh5SjA1TnFTRERC?=
 =?utf-8?B?VlEzY0syOVYzZDNsbU56UllRamYyUFh1ZDJxOGxxcEhLaHFkc2NMNU9VdlRR?=
 =?utf-8?B?a1dHTlJxOE0yZXN5d1ptem5NS1IzVy9xUkx5b2hUZmx1c1c0UGkrOEFVcDBw?=
 =?utf-8?B?WUF1cVhmVTdqOEJ6SDhYZzhHRHVPQXBvaGFZbklsMVlkeTlSa1NDOS84akdw?=
 =?utf-8?B?TnVEdFZ4QmphdDkwenVBRzA4Q1Q0aGJQam5objEvUEowbkRVNlF2c1REY3NL?=
 =?utf-8?B?RlF4cEV5WnBDNlNudGE2UjU2WmM5VkxyTHo5WXc2Z0E4S1ZMK2ZaVHlwU09P?=
 =?utf-8?B?S1poRnJ5ZnVvRENZS0lqVVVsOWE0U2Fqdncwd1NvWGtuMFN6TXlsVFVwQ0NU?=
 =?utf-8?B?WC83SGJCV0dBOFhHK0kyK05RRlRUcSt4N2x0U1NmS3cvZDNTSm5hcmpsV3JU?=
 =?utf-8?B?eDR0M0RiQnVCMWRvK1ZrM2dvV2haTUNxZGhWclU0YjVqY2tST0I2WG8vRWcx?=
 =?utf-8?B?czJTYkYwNS93MTVuY0psVEExZ1pSTlFHOS9zRkErdGY4dERJRDJITlRjVmFB?=
 =?utf-8?B?ZGlNTjlOZ1ZBbUFIMkdlNjZDMldEdUxKMTM3RnhvcUc0VGI3dzVjNGxOR3pF?=
 =?utf-8?B?aXBNY0R6T0duY3B2dlBxeHFJMGEyVVo1ME1vbXRsVzQ2b0cxa0o5anlPSkMy?=
 =?utf-8?B?Tzc4R2pTS2ZPN1BkMTMrRG1YeXBrWTFnOFdlb3VkQmVqeURxYUJFMWRhUG16?=
 =?utf-8?B?SFpnb1BHSzhwaFNWeUJmcndVVGJwZW5tSjNyK0p3UU5WRFNYamFubE42VGk2?=
 =?utf-8?B?ZEdvT0Urb0VXbXNsWlJ3SjhmaEhKaC9sN2FjdS9HQVpYempaa3pXYUF0SHlL?=
 =?utf-8?B?TkxPbjVCOE9McER5NG9KdE54V1hMRHFoTkRyaG1Wa0lQeEVvKzNtanNUYXM3?=
 =?utf-8?B?ZnUzeDZwRGJhL3VXalVnQW80SE8yY2pTblhTdFJYK21qbWtxYm1rN1drdFQy?=
 =?utf-8?B?THFsb3VwbWtxS2toYlA4Ym4wM1FyV3RtaFVEOC9OcmswVzBzaTIxamJ5aHVE?=
 =?utf-8?B?R2RGZnhDdE5vdlU3TGFuQ3JWT3M5RGFJN3hsWFdwMHpDaXExMldPUUdtd1BZ?=
 =?utf-8?B?S3ZEc2RKUjlrbUxJdTlyMUVmb2pZTFhoWWlxbE1ldUNNelNkY010eFJXZmhL?=
 =?utf-8?B?b245bUE2SnpJQUt6d1M4NTZPcEZOK1NJRmFBOWJXT3pIRDJQRkllUlgrSG8w?=
 =?utf-8?B?ZjN6YXlVcDVqRUtGaUx0dFJ2bzlHK1p6a1JON056TTU4c3ZrUUFtZ1huSUdn?=
 =?utf-8?B?WG95TnFTOWgwQjNBUzNqTGdYMksvT3pEQWtNYUZxTWVXMHozU1B1dkRnPT0=?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVXPR08MB7727.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB10297
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:6b::6];domain=GVXPR08MB7727.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF000001AF.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	c84eb775-37d5-4ef3-5296-08dcec2e08fc
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|35042699022|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N3VqdTBEb1RCOXh2VWpUc3JMOFJORGUrQlduaDhpY0JkVzlWNmVucUwwUWF2?=
 =?utf-8?B?NjlJN3luSTVZdUc4NEdNNEZseW5IaHZQdU5GemRQdXpEV2JoMXNtQUwvY1FN?=
 =?utf-8?B?N3luVWNiRmFpVCsxYndGMngrUlJiZDdVQ0NkNEZSZWxGUTBvekFwc3k0YS9Z?=
 =?utf-8?B?NTFmMzNhTnEzNzVvMk9WTHVQcDdkNnRhODR3Z0F1eFd1QlBOSks4RHhJNkY5?=
 =?utf-8?B?eTFnOFN2K2d6czYybWdCSmp0eGFIRk05VlNWVU9ETVA2MnJTcFRpUlpRTXpu?=
 =?utf-8?B?eUtXdHN1aFo5Ti9CSzREWWVYTUdzT0kwWjAxT0Q2M3V1NlAvVHgrN29xaEtW?=
 =?utf-8?B?WW5CdE9EZ1VJTkNIVkdVTFpINnVDQlRpNGNCcDdYWWsybXMrcW1kUlNGMi82?=
 =?utf-8?B?Q0VNQ1BNWGYrVDNEb0x6eVBKNFB2MTk4RGRKRXNjYkxjWDRGZDk3SnhaQkpa?=
 =?utf-8?B?Uy9LS2tsTjZtK0h2OTU2M2EyalFTZGpML1FZbWZ5YktpWUlObTBMTkFCUGRZ?=
 =?utf-8?B?T1RBRHY0cExYcGgrSThtbnF0YTh0RjZKL09TRXAzdDY1ZWdUcUxpdit1UjhJ?=
 =?utf-8?B?dXdDVzRFRVVRVmtxdUdiZ1Q5b2g1aEptUzc3MHo2Rml0RzB0ZmsyYldZVVlh?=
 =?utf-8?B?QnFZdXRod24xQ0VqclprcVZqZDBpWWY0NTlIMG5yYnZYYkhZY2MvWDV5cUR4?=
 =?utf-8?B?eUlsVjU0VDdMZGhFRyt0WlRrbjNLQWU3Ulg1a2o3UTRJc2JHUlliYktvcGcz?=
 =?utf-8?B?NkVQb0tmTEY0TkFhRzFaWkswNjRzTEtNd09jWkJYQlA0YmR0NHE3VWVNVDlE?=
 =?utf-8?B?OE5NTU8yWXlRaXFDVGdxMmpkMEhVZm1ydFZRRmUzbmt6RGZRU2RmOG8zVS93?=
 =?utf-8?B?b2lnd0hkSHFrUVBycEcxNVlXeE9CM0ZWUmpuazZCM0JLV0o4Y3ZoR2ZZMGZh?=
 =?utf-8?B?SkNpR0NUTWdJTVRsalJlS0JhVEhVajMvRkdIbFlIaHNZcXNTd2JsNklNdG5U?=
 =?utf-8?B?cnhualkyOU92czl0eEtqclN6QnRxMWtzejlFSmNieFJHeXQ4c1cvTHNIcmwz?=
 =?utf-8?B?eCtLaE1tYWRPb2xMd1I4ZXFPaVlTZnNDQ0cyZjd4c1N3R2N2Y29oaWVsSFBB?=
 =?utf-8?B?VWUzSEZlMUtpMkRSR1IycE8wUlN1K1dkT3hQNmJ4NU5INHRLT2xGZTM3QTlm?=
 =?utf-8?B?WHBOMU1vV2c4cUxhRHh5MUhTa0VlV1UxTEIrYjBtUzB3c0JlWW9saVVQOWNo?=
 =?utf-8?B?cVUyMjZBYTNLRGVRbmpVNkZtU2tMdEsydFpFc2RHQXNMSkpyNVliQWJ3Q1Mv?=
 =?utf-8?B?cTFKZm1NR1pNSm9kZ3d1SWZ6cEFNZXdiTm4rRWFERWYxblA2YTlyQ2JOMU5M?=
 =?utf-8?B?TTY5S05NQm9LaWdXZlVuME1JTzl2TXlUVkw4b2o1MzIwRjMrNVIydDVRUEVP?=
 =?utf-8?B?bmNZMUtMaDJjMHZJdDJFbno2QVdXU2JBdkUwbCszYXpRV2hzRFJmSWQ4OHA2?=
 =?utf-8?B?aE9DOThVNnAzbE1GYXFFR01KSG5FV3lrQkJYMTh0a0VQZGNXWWZ1T1lEZHJH?=
 =?utf-8?B?aDRIdlJWTXlaZC92UTlpUjZ0VjBWNEpuOHdLdE5MWUpsSUNvUTVSUkVRTTRI?=
 =?utf-8?B?VFE5NUxmVThIbkdHK0duQkd0Nk93QnZzdC9yYURONUtIUmFXRmkyWC9BZmVI?=
 =?utf-8?B?S3ZSWEFpNUpabkw1WDZIQjhFWmFCankzYit0WW1rMjBNdytQYjZEOGovajNK?=
 =?utf-8?B?THVwekx0ZFRBbi9xdXM0Mk5yTTZRRnNVbXhhelZEOFhFUlFJQUNjRVV5R3BV?=
 =?utf-8?B?KzJicTk3bzZOL0xtbUV6VGJYTXI4Ly9ZNTA3Yi8xUklSaSsxT2FReVB3L1hQ?=
 =?utf-8?Q?bWWLLkc4X8KFb?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(35042699022)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 08:56:23.7478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4234b47-b686-4ac1-59cf-08dcec2e14b7
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF000001AF.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB8740

On 12/10/2024 07:06, Gavin Shan wrote:
> On 10/12/24 2:22 AM, Suzuki K Poulose wrote:
>> On 11/10/2024 15:14, Steven Price wrote:
>>> On 08/10/2024 05:12, Gavin Shan wrote:
>>>> On 10/5/24 12:43 AM, Steven Price wrote:
>>>>> From: Sami Mujawar <sami.mujawar@arm.com>
>>>>>
>>>>> Introduce an arm-cca-guest driver that registers with
>>>>> the configfs-tsm module to provide user interfaces for
>>>>> retrieving an attestation token.
>>>>>
>>>>> When a new report is requested the arm-cca-guest driver
>>>>> invokes the appropriate RSI interfaces to query an
>>>>> attestation token.
>>>>>
>>>>> The steps to retrieve an attestation token are as follows:
>>>>>     1. Mount the configfs filesystem if not already mounted
>>>>>        mount -t configfs none /sys/kernel/config
>>>>>     2. Generate an attestation token
>>>>>        report=/sys/kernel/config/tsm/report/report0
>>>>>        mkdir $report
>>>>>        dd if=/dev/urandom bs=64 count=1 > $report/inblob
>>>>>        hexdump -C $report/outblob
>>>>>        rmdir $report
>>>>>
>>>>> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
>>>>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>>> ---
>>>>> v3: Minor improvements to comments and adapt to the renaming of
>>>>> GRANULE_SIZE to RSI_GRANULE_SIZE.
>>>>> ---
>>>>>    drivers/virt/coco/Kconfig                     |   2 +
>>>>>    drivers/virt/coco/Makefile                    |   1 +
>>>>>    drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>>>>>    drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>>>>>    .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 211 ++++++++++++ 
>>>>> ++++++
>>>>>    5 files changed, 227 insertions(+)
>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>>>>>    create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
> 
> [...]
> 
>>>>> +/**
>>>>> + * arm_cca_report_new - Generate a new attestation token.
>>>>> + *
>>>>> + * @report: pointer to the TSM report context information.
>>>>> + * @data:  pointer to the context specific data for this module.
>>>>> + *
>>>>> + * Initialise the attestation token generation using the challenge 
>>>>> data
>>>>> + * passed in the TSM descriptor. Allocate memory for the attestation
>>>>> token
>>>>> + * and schedule calls to retrieve the attestation token on the 
>>>>> same CPU
>>>>> + * on which the attestation token generation was initialised.
>>>>> + *
>>>>> + * The challenge data must be at least 32 bytes and no more than 64
>>>>> bytes. If
>>>>> + * less than 64 bytes are provided it will be zero padded to 64 
>>>>> bytes.
>>>>> + *
>>>>> + * Return:
>>>>> + * * %0        - Attestation token generated successfully.
>>>>> + * * %-EINVAL  - A parameter was not valid.
>>>>> + * * %-ENOMEM  - Out of memory.
>>>>> + * * %-EFAULT  - Failed to get IPA for memory page(s).
>>>>> + * * A negative status code as returned by 
>>>>> smp_call_function_single().
>>>>> + */
>>>>> +static int arm_cca_report_new(struct tsm_report *report, void *data)
>>>>> +{
>>>>> +    int ret;
>>>>> +    int cpu;
>>>>> +    long max_size;
>>>>> +    unsigned long token_size;
>>>>> +    struct arm_cca_token_info info;
>>>>> +    void *buf;
>>>>> +    u8 *token __free(kvfree) = NULL;
>>>>> +    struct tsm_desc *desc = &report->desc;
>>>>> +
>>>>> +    if (!report)
>>>>> +        return -EINVAL;
>>>>> +
>>>>
>>>> This check seems unnecessary and can be dropped.
>>>
>>> Ack
>>>
>>>>> +    if (desc->inblob_len < 32 || desc->inblob_len > 64)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    /*
>>>>> +     * Get a CPU on which the attestation token generation will be
>>>>> +     * scheduled and initialise the attestation token generation.
>>>>> +     */
>>>>> +    cpu = get_cpu();
>>>>> +    max_size = rsi_attestation_token_init(desc->inblob,
>>>>> desc->inblob_len);
>>>>> +    put_cpu();
>>>>> +
>>>>
>>>> It seems that put_cpu() is called early, meaning the CPU can go away 
>>>> before
>>>> the subsequent call to arm_cca_attestation_continue() ?
>>>
>>> Indeed, good spot. I'll move it to the end of the function and update
>>> the error paths below.
>>
>> Actually this was on purpose, not to block the CPU hotplug. The
>> attestation must be completed on the same CPU.
>>
>> We can detect the failure from "smp_call" further down and make sure
>> we can safely complete the operation or restart it.
>>
> 
> Yes, It's fine to call put_cpu() early since we're tolerant to error 
> introduced
> by CPU unplug. It's a bit confused that rsi_attestation_token_init() is 
> called
> on the local CPU while arm_cca_attestation_continue() is called on same CPU
> with help of smp_call_function_single(). Does it make sense to unify so 
> that
> both will be invoked with the help of smp_call_function_single() ?
> 
>      int cpu = smp_processor_id();
> 
>      /*
>       * The calling and target CPU can be different after the calling 
> process
>       * is migrated to another different CPU. It's guaranteed the 
> attestatation
>       * always happen on the target CPU with smp_call_function_single().
>       */
>      ret = smp_call_function_single(cpu, 
> rsi_attestation_token_init_wrapper,
>                                     (void *)&info, true);

Well, we want to allocate sufficient size buffer (size returned from
token_init())  outside an atomic context (thus not in smp_call_function()).

May be we could make this "allocation" restriction in a comment to
make it clear, why we do it this way.

Suzuki




>      if (ret) {
>          ...
>      }
> 
> Thanks,
> Gavin
> 


