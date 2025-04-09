Return-Path: <kvm+bounces-43002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 464A5A82176
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 11:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6210C8A6F2A
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 09:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569B525D535;
	Wed,  9 Apr 2025 09:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G1ViZ4XZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4739B25D54C
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 09:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744192626; cv=fail; b=OPwdMwtE8DhASFmMWFQKbZYLNq97G97AsH60dAGhWzKqsICli5LLgd/YUewi5Ca1/042hDR2KGj4Xw1gYPvGiiGatw9Vj2kVjrPzmVS3k8e01c5uR156wNsMJIlktsgDirwDNrI1wZ+EKDOmNAFOxvPfMhf0XcZLomW54ptMn8E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744192626; c=relaxed/simple;
	bh=bd2PiPE7KWtALoAGL3jimj7FEqehBBpxtup5kKCQ4yQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c42nwHvvNgQjIbPdprskvIhqPm7uNk4hsXorsN7m4VYCW0W9CReJxOHp02Wt8X8r0xAzSetKFg97FvQKUF+7q75QpltjDjy66MKnUSjV5/PihmyXUCPkOHD5fr7jeMWTKeaEiT9BI0jSbKsb7hiHefj+6XZN+9JaOSpTwZ94jC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G1ViZ4XZ; arc=fail smtp.client-ip=40.107.94.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zTK6hcYDub9ApfjmotEfuhN6uXzyJBbcE5eBgpK2DimrWH/CxRSuytHFQlQVnrE69lY/yGOB3xwQ4exNufZbYqZX8c+uxFd/aH+Js8k6lZ3Fmi1GG15TyoIh/NyPdl1eKlvt3AOjR2nwH0x1y0UXCySjMKUcxaU75NENoqyCvYxF53QYrTnMQxj/dGp/XibzkdiPUZbBs58Gnp8j3Ofnks76+dZ+YBZRxGFefMd5RQ+VGy+oebYUsygsgT10P7XVbpvH2PJZKxSGSrSIaA/7Zib4zixY4mGZz3ZjAJSxSOTWUOPr3o1d1/1OGHPogF5UFv9HEXrrN2CVz203/0HGtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Os/JNHV+NVutgv/nDmKvB5sSo9Qxwh+Sy+SANlPWgAI=;
 b=zWmrNsryZQHQWZ1xuCE8f4mDXeTEyCFLACmUjDbbflPNakxkpcXj41uKgWvnneCRqb9QQEIXJXn77xMWrj50zg20aJ9aP1UdGMVbD8YO30O1p/Y1YVvaf4NKpDzj12fRZnfXzCFwVqAoLG+kW5VJninsccgtkPIkodatnvSm7ye0krFuN4Duw2x91z2JVMxjXtPaNlkP6jh+0bkyroO5YzuC/vKfbIB+Cf9XHauSUO6gsGb2qadid1iufg+dRqIgLoOYTVeYroODRu5GkPRJMm6Gupb5XNiiadI/smiNwujBNE5hMnE9sgPTVJqzKG7x3myDsw4iE5rjP/OFlRBZgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Os/JNHV+NVutgv/nDmKvB5sSo9Qxwh+Sy+SANlPWgAI=;
 b=G1ViZ4XZsTyJy/0Bl/uvP17HJtMi181AncNzRTepXzGkSYo9Q/G6W4oet4C5JJUO2OBX/Wvo8J2wmPyeEtmd9LC2EJn/odQAhR07KkH7Pu7DPFw8SYoyaS9KhAMDvSdGdsEYabj3WZtqTE6fk6mHzY+dgVO943Es5YeZdlbdfXQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by PH7PR12MB5951.namprd12.prod.outlook.com (2603:10b6:510:1da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.20; Wed, 9 Apr
 2025 09:56:59 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8606.029; Wed, 9 Apr 2025
 09:56:59 +0000
Message-ID: <402e0db2-b1af-4629-a651-79d71feffeec@amd.com>
Date: Wed, 9 Apr 2025 19:56:50 +1000
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v4 04/13] memory: Introduce generic state change parent
 class for RamDiscardManager
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
 <20250407074939.18657-5-chenyi.qiang@intel.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <20250407074939.18657-5-chenyi.qiang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVPR01CA0055.ausprd01.prod.outlook.com
 (2603:10c6:220:1fd::6) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|PH7PR12MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: ee55bc82-5be6-498e-31c3-08dd774cde4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0RFbTFuZkluTHdvOHBOWjdDUTFPbkNVN2ZleFNZYWFKOFRsTEc5Y29jR0t5?=
 =?utf-8?B?cWszcUVpVjNZbTRvUWYrbzdGZXRvQzFqN1V5NElaT2xDR1pWQ0ptNlAyRDFv?=
 =?utf-8?B?aWVsOFlxYmk4WFR1aVBjTEd3RjVycm1tdlNmMlE2TC83T3dnU2JDR21UUm92?=
 =?utf-8?B?ZHg5OXlIOGJRSlp4a2JlQm1TQldCa2Z6M3BPallzclY2L1VvWVV5RzRpOHZK?=
 =?utf-8?B?bXNDK0lRMWRETUN6cFFhN0ZqMjVOY2ZYbW9QOE5UU0NrSHpaK2ZxMTN0Q3J1?=
 =?utf-8?B?Zng2UHVvQWExdzVUVVYrd2liWGNrUmloSW5HeXYrekVTS0JPZlhXMWpHOVM5?=
 =?utf-8?B?U1dFc2xrc0syL1FPazV2dE13REp5dUc1MVJ5Q0J5aExCWGZ5ZjdrQmF5NjVj?=
 =?utf-8?B?RGtOVFp5YlFkeVgwc1E4RnBOL001aEliM1RkZkFUMHdkeVR1N3pyT05KdzBs?=
 =?utf-8?B?ajBmOFZwZ0JsK01mUU9vYy9PM2JJYy9zdnhpVWtPRTlDVlRuc3VFTHRORmN4?=
 =?utf-8?B?eUhsSHdBcnRKVlhMYVRzUHpHUnhLRUVINm9yeE9nclk0UzNTWXFKRmtkQ0Fy?=
 =?utf-8?B?NjQzanpncWNGMm1oaVlOUVdqVW4vQ2l3NklwWFJCcjRYUVVzZ3VvQWxNbmIz?=
 =?utf-8?B?VlhUVkREV0hWbnIyQ2dYeUU2cnI0OHhOZXEvUnpxZUkxdFUrWitGV0xPTFFR?=
 =?utf-8?B?Q3J0MDBieXZSQnVTcnBYYjFkMlh3enRsUWE3THZTUUhJTnZHc21HWE8yQ1VO?=
 =?utf-8?B?c3JMencwamxleTdIV0lGRkl0U3ZEMm1VdW5KZmtNNXhXd3VrWUcrc2JVUDNn?=
 =?utf-8?B?T2lubVlaNy9kS0JLemtkK1lsQkFnK04rS2RqUi94YytkNE1jYUNDanlWcVNN?=
 =?utf-8?B?OHVhZDlnRy9yQkptMWpvTVlEaXBEYmxMeFpSU0lFbzhvdmlOMStEYlVBUHgz?=
 =?utf-8?B?aS92MFNtekQyVkxIUUd0WkdEc255NnpGVWJzWWtzT3JSaFM4ZVBnN1JGWTVm?=
 =?utf-8?B?ZnhhZWVaWUs3emttZEU5bmRrUmhGT3FNMTdQSlF2bmpMdkE4dHZTYUh5Wkl4?=
 =?utf-8?B?NHJDaHlUMkFkcTYxUmJJTjVibno5dytrTG84NUIydk9oUzZ0Y0ZKM0t6eW9I?=
 =?utf-8?B?ZERuL1U5Zy9VMXQreUFib3Y5eUtRaC9pRytzSGJPZmptUnFtOVZDSENDQmhU?=
 =?utf-8?B?V2dydlgvUkRiaFVBQ294b1Z5MWNQaEJoWjkzOEs0bHpUOEdhQ2xtUjVQemZ6?=
 =?utf-8?B?MnVpQUVhQjFLeWJxbSszbHdQbVJPTXloT1VoZXFNdnQwVU5zYURLN0JLTGhN?=
 =?utf-8?B?MmhncUxrTmh2bWM3U3NCdkF0b1JNTytHRXovQjAwZnErTysrNkErcHFhMjI0?=
 =?utf-8?B?RmJRUFZWSWJOOEw3NkpvZ2VOZ1lRSjlSUUNUVklVaE9iUlNpcVFyeklGbXRW?=
 =?utf-8?B?ZldCNXppbWF3bEoxWFl3SkJJbFU2Zy9pZjhmOGgyc0hOYUdkeitZaDlSTEJh?=
 =?utf-8?B?clBvM3FKMlpGODcvbWh5ak9jYXRlNWpwM3E0UnB1aE5vbTlLa1ZSTGlFdWds?=
 =?utf-8?B?VG15ZjdhT21SaHBCVkFjVlRWZVZXWjRSOC9XTmNvNzNyZXAxUFNJa1VNSVlT?=
 =?utf-8?B?OGpxczhLVC9VVGxiQXBZSFR4VTdJMzRDU1RIRExrbjFrZXJ2RTQ4UW13dEph?=
 =?utf-8?B?cm5vU2lXUWdDYmtjT0NnYVVXeUZpblBpamswVEZNYzRtbm1uWGp2QzBQS1pt?=
 =?utf-8?B?ZVRjQzJhQTRZSFdjWGJhZW1vSzBKVnJIdXpkdlFlY0pCQ2ZYMTRGNVlEOTdB?=
 =?utf-8?B?ZWlDN1IxMFJuZklTUW1KNzRlclZSV3B1VjRyOFFiakdMYitlSEhkaThEa2ds?=
 =?utf-8?B?WmFacGZ6NGFNN2IxcHNaUkdIdmNGUmlzMlJGWDBFRm1qdEJyUUliVE9Zbm41?=
 =?utf-8?Q?BrtPmyEzqRc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWJGYW13RitSYkQ0M0hSTGN2TFk1d3ljaURzL2xNMS92QlNtbHE0Y3VOblRs?=
 =?utf-8?B?SkVtZEFiaElMamZkanBxTUF6cnEwSm80RzRKbFF6WnhGUUVQYTBTTEQzZ2pP?=
 =?utf-8?B?NnppVDh0dzlMQmlmck9BQnlxTEtET2xLYVY0aGg5V2w4NnVHZFoyaG1yaFcz?=
 =?utf-8?B?Wk41MUFTYWNHY0tFMHNROXNsSkUvYnZlSUV6S1p6Tit2RElaSTg2TVh0Yksv?=
 =?utf-8?B?ZlBFeThhaWpPbHZmN0dlNzJlUUlMUTRYLzkxOVBrcFh1Y3JCK0tBUG91QTAw?=
 =?utf-8?B?YWdVVS9SbDNpcE5xUFBwcnFXTTJxTTJjWGhvUjFXT3Npa1RqWGVGbXJuWkJa?=
 =?utf-8?B?WlU3Ynpoa2MzRTVsbisrUzZxM0dZeGlkOGdjRmM0QVVwL2lnRHNGU3NQWndh?=
 =?utf-8?B?eGo3UUZTcjNuSDRMaUhhYzlwY3pHRnZ1K005ODV1WTBDekxva2d0WW9FbTlH?=
 =?utf-8?B?dGwwRko1TzJCWGZoSGlKZGVNKytFMDNPQ0tsckF2aTFSbGJvQmlsei9uTjVj?=
 =?utf-8?B?ejVlYUR6RWJxbE9oQUJEV21RVEliajhBTTErTnNKcEYvU0JjT0N1WG52Qnpt?=
 =?utf-8?B?emlhK3pPZ1Jxd1plQzRHRlhvV0FHUWJHakoyaThZb2dnNHlFVTU2dTJEcEI1?=
 =?utf-8?B?SHRTd1pRS1crb3liQUJqTi9yUmVCdFVMZmc0cks4bVZ5YzZRU3M3aXRlMmNk?=
 =?utf-8?B?VkF5VEMvc1FxZmZZc0F0WUZBME5lUVlrSFNDOXFwY3VqK05YZDh4NGZJaXRl?=
 =?utf-8?B?TW9VSmd1anZMMkE1bHZVckRnbXJwd0w4dkpYK0Z3RTFjd1hyM0xPQWN3amV3?=
 =?utf-8?B?V2I2RG1ncVpWQ2krSzRGOTQyVlJST1NicGlzdHZMR2ZSKzRtaFdFMGVLRFYr?=
 =?utf-8?B?di90L1dTSTd3TFZHK1pjOU5FVlhXd3hzOTJuL3h2NGMwMnlPT3U3UVk4TENr?=
 =?utf-8?B?RXVHRmVyRDBuN2FlSEUrZUF3SGhCN0hjNlF6cGRoUHJDWlFMYUVYaDJ2OUtn?=
 =?utf-8?B?cGkxU1BFdFYzaktiZWhlcmlocmZWT0wyZVBUVXZmeVBOcnhuajJ6cFVvYStP?=
 =?utf-8?B?M2t0VHNQUFUybTF1cXhQR1grOEI3aGIwZjIvYktTdElVbXVRb0Z3dG8yV1RT?=
 =?utf-8?B?bCt5aHlpL3djVXo3b1BHdWUrVmhUSFc1ZytjSzFpWHpORnFqYi9GQ0k2bUJa?=
 =?utf-8?B?azgyWDBicVBaMStEbUg1WjhHVE8yTDV1RGxxcisyMVlOK2lDRFlteFZRZE02?=
 =?utf-8?B?dGx2Z2FSSEtTZjRTZEZnZThnL1g3dTVTQXBrVHpGWkpBeGlpTWxuK1VzUmMr?=
 =?utf-8?B?bEFsaHEyN0lxb2FoNVNuZnZsKzdySFpmN1pidkdoeWV2dm0ralpEc2FRVys4?=
 =?utf-8?B?VFdNdmtvak9UbTlFTGVFOVhLUGFaVTlPQ1lIOXJ4aUpDTC85SllnV2RiczYy?=
 =?utf-8?B?M2xMUzlSWTZjWStWWEI5eG92eVpGMHZQQXVBaFhpd2FqY29Md2xYeVdlYTlJ?=
 =?utf-8?B?cjgvdXFZb1FjdWk3bE9idisyUkh0SEJGdU9rdmpqUjQ1Y24zM0krb2Uwb1kx?=
 =?utf-8?B?a3hrOEQ2VU9sU0h0bjREOXA5V2tJMVQrRit2K0dORmZXQWxhOTdWbVN4UkpS?=
 =?utf-8?B?VHlUSENvY3pHbUU3aHgydml0S2lnc2puU1M4RVVBUVU4WW8yL0JhMlU3OW1M?=
 =?utf-8?B?YmFvT2tvYXdKSTQzc3M3OUN4NjRKZk80ZmZkRmk3QXIzMXJNR3A4OUR1THpC?=
 =?utf-8?B?Rk9ObGhTMk5vMEFHN29ubWFHSUVZc29Sb2tUQjdLenpPcCtreEh1NVVsLzNN?=
 =?utf-8?B?ejZvNG9qRmxhTVBjd2VEVXB6bmRGZXlHL1hicTljQzF5K1ZIdGt0c0NhRXFy?=
 =?utf-8?B?SkxmemdSdmwvVDlyaGxpUWREZDE2UXdIUzB6K1lwb092R2xVREpoU3JaWUVX?=
 =?utf-8?B?Qmc1a09JNERNZi8vcE9hOHJWU2tDcHBaRmFLbk15Z3YvdndadTYvWFdwMUV5?=
 =?utf-8?B?K21SVVJsTUhYTFdScEExUzBWREJodUgwdDZhSDJucVFINFphN2cxMXlHeFc0?=
 =?utf-8?B?eXpBU0VBTkhqOGw0NllETnE3WTg2K2RsVUVsY0drL0FiWmo2aVBzdVpLZ1FD?=
 =?utf-8?Q?qheVkZ9ENyAok7a2eIVyYE4OF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee55bc82-5be6-498e-31c3-08dd774cde4f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 09:56:59.0872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GM1HUYPUljTaaHvtZn7jLid/ofYmLP4X/f4DR0gwgEu5VT82xunrXPsd6bEZhOxb8sk096p7stEfas/QzvtyJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5951



On 7/4/25 17:49, Chenyi Qiang wrote:
> RamDiscardManager is an interface used by virtio-mem to adjust VFIO
> mappings in relation to VM page assignment. It manages the state of
> populated and discard for the RAM. To accommodate future scnarios for
> managing RAM states, such as private and shared states in confidential
> VMs, the existing RamDiscardManager interface needs to be generalized.
> 
> Introduce a parent class, GenericStateManager, to manage a pair of

"GenericState" is the same as "State" really. Call it RamStateManager.



> opposite states with RamDiscardManager as its child. The changes include
> - Define a new abstract class GenericStateChange.
> - Extract six callbacks into GenericStateChangeClass and allow the child
>    classes to inherit them.
> - Modify RamDiscardManager-related helpers to use GenericStateManager
>    ones.
> - Define a generic StatChangeListener to extract fields from

"e" missing in StateChangeListener.

>    RamDiscardManager listener which allows future listeners to embed it
>    and avoid duplication.
> - Change the users of RamDiscardManager (virtio-mem, migration, etc.) to
>    switch to use GenericStateChange helpers.
> 
> It can provide a more flexible and resuable framework for RAM state
> management, facilitating future enhancements and use cases.

I fail to see how new interface helps with this. RamDiscardManager 
manipulates populated/discarded. It would make sense may be if the new 
class had more bits per page, say private/shared/discarded but it does 
not. And PrivateSharedManager cannot coexist with RamDiscard. imho this 
is going in a wrong direction.


> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
> Changes in v4:
>      - Newly added.
> ---
>   hw/vfio/common.c        |  30 ++--
>   hw/virtio/virtio-mem.c  |  95 ++++++------
>   include/exec/memory.h   | 313 ++++++++++++++++++++++------------------
>   migration/ram.c         |  16 +-
>   system/memory.c         | 106 ++++++++------
>   system/memory_mapping.c |   6 +-
>   6 files changed, 310 insertions(+), 256 deletions(-)
> 
> diff --git a/hw/vfio/common.c b/hw/vfio/common.c
> index f7499a9b74..3172d877cc 100644
> --- a/hw/vfio/common.c
> +++ b/hw/vfio/common.c
> @@ -335,9 +335,10 @@ out:
>       rcu_read_unlock();
>   }
>   
> -static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
> +static void vfio_ram_discard_notify_discard(StateChangeListener *scl,
>                                               MemoryRegionSection *section)
>   {
> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
>       VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
>                                                   listener);
>       VFIOContainerBase *bcontainer = vrdl->bcontainer;
> @@ -353,9 +354,10 @@ static void vfio_ram_discard_notify_discard(RamDiscardListener *rdl,
>       }
>   }
>   
> -static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
> +static int vfio_ram_discard_notify_populate(StateChangeListener *scl,
>                                               MemoryRegionSection *section)
>   {
> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
>       VFIORamDiscardListener *vrdl = container_of(rdl, VFIORamDiscardListener,
>                                                   listener);

VFIORamDiscardListener *vrdl = container_of(scl, VFIORamDiscardListener, 
listener.scl) and drop @ rdl? Thanks,


>       VFIOContainerBase *bcontainer = vrdl->bcontainer;
> @@ -381,7 +383,7 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
>                                        vaddr, section->readonly);
>           if (ret) {
>               /* Rollback */
> -            vfio_ram_discard_notify_discard(rdl, section);
> +            vfio_ram_discard_notify_discard(scl, section);
>               return ret;
>           }
>       }
> @@ -391,8 +393,9 @@ static int vfio_ram_discard_notify_populate(RamDiscardListener *rdl,
>   static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
>                                                  MemoryRegionSection *section)
>   {
> -    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
> +    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
>       VFIORamDiscardListener *vrdl;
> +    RamDiscardListener *rdl;
>   
>       /* Ignore some corner cases not relevant in practice. */
>       g_assert(QEMU_IS_ALIGNED(section->offset_within_region, TARGET_PAGE_SIZE));
> @@ -405,17 +408,18 @@ static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
>       vrdl->mr = section->mr;
>       vrdl->offset_within_address_space = section->offset_within_address_space;
>       vrdl->size = int128_get64(section->size);
> -    vrdl->granularity = ram_discard_manager_get_min_granularity(rdm,
> -                                                                section->mr);
> +    vrdl->granularity = generic_state_manager_get_min_granularity(gsm,
> +                                                                  section->mr);
>   
>       g_assert(vrdl->granularity && is_power_of_2(vrdl->granularity));
>       g_assert(bcontainer->pgsizes &&
>                vrdl->granularity >= 1ULL << ctz64(bcontainer->pgsizes));
>   
> -    ram_discard_listener_init(&vrdl->listener,
> +    rdl = &vrdl->listener;
> +    ram_discard_listener_init(rdl,
>                                 vfio_ram_discard_notify_populate,
>                                 vfio_ram_discard_notify_discard, true);
> -    ram_discard_manager_register_listener(rdm, &vrdl->listener, section);
> +    generic_state_manager_register_listener(gsm, &rdl->scl, section);
>       QLIST_INSERT_HEAD(&bcontainer->vrdl_list, vrdl, next);
>   
>       /*
> @@ -465,8 +469,9 @@ static void vfio_register_ram_discard_listener(VFIOContainerBase *bcontainer,
>   static void vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
>                                                    MemoryRegionSection *section)
>   {
> -    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
> +    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
>       VFIORamDiscardListener *vrdl = NULL;
> +    RamDiscardListener *rdl;
>   
>       QLIST_FOREACH(vrdl, &bcontainer->vrdl_list, next) {
>           if (vrdl->mr == section->mr &&
> @@ -480,7 +485,8 @@ static void vfio_unregister_ram_discard_listener(VFIOContainerBase *bcontainer,
>           hw_error("vfio: Trying to unregister missing RAM discard listener");
>       }
>   
> -    ram_discard_manager_unregister_listener(rdm, &vrdl->listener);
> +    rdl = &vrdl->listener;
> +    generic_state_manager_unregister_listener(gsm, &rdl->scl);
>       QLIST_REMOVE(vrdl, next);
>       g_free(vrdl);
>   }
> @@ -1265,7 +1271,7 @@ static int
>   vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainerBase *bcontainer,
>                                               MemoryRegionSection *section)
>   {
> -    RamDiscardManager *rdm = memory_region_get_ram_discard_manager(section->mr);
> +    GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
>       VFIORamDiscardListener *vrdl = NULL;
>   
>       QLIST_FOREACH(vrdl, &bcontainer->vrdl_list, next) {
> @@ -1284,7 +1290,7 @@ vfio_sync_ram_discard_listener_dirty_bitmap(VFIOContainerBase *bcontainer,
>        * We only want/can synchronize the bitmap for actually mapped parts -
>        * which correspond to populated parts. Replay all populated parts.
>        */
> -    return ram_discard_manager_replay_populated(rdm, section,
> +    return generic_state_manager_replay_on_state_set(gsm, section,
>                                                 vfio_ram_discard_get_dirty_bitmap,
>                                                   &vrdl);
>   }
> diff --git a/hw/virtio/virtio-mem.c b/hw/virtio/virtio-mem.c
> index 1a88d649cb..40e8267254 100644
> --- a/hw/virtio/virtio-mem.c
> +++ b/hw/virtio/virtio-mem.c
> @@ -312,16 +312,16 @@ static int virtio_mem_for_each_unplugged_section(const VirtIOMEM *vmem,
>   
>   static int virtio_mem_notify_populate_cb(MemoryRegionSection *s, void *arg)
>   {
> -    RamDiscardListener *rdl = arg;
> +    StateChangeListener *scl = arg;
>   
> -    return rdl->notify_populate(rdl, s);
> +    return scl->notify_to_state_set(scl, s);
>   }
>   
>   static int virtio_mem_notify_discard_cb(MemoryRegionSection *s, void *arg)
>   {
> -    RamDiscardListener *rdl = arg;
> +    StateChangeListener *scl = arg;
>   
> -    rdl->notify_discard(rdl, s);
> +    scl->notify_to_state_clear(scl, s);
>       return 0;
>   }
>   
> @@ -331,12 +331,13 @@ static void virtio_mem_notify_unplug(VirtIOMEM *vmem, uint64_t offset,
>       RamDiscardListener *rdl;
>   
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
> -        MemoryRegionSection tmp = *rdl->section;
> +        StateChangeListener *scl = &rdl->scl;
> +        MemoryRegionSection tmp = *scl->section;
>   
>           if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
> -        rdl->notify_discard(rdl, &tmp);
> +        scl->notify_to_state_clear(scl, &tmp);
>       }
>   }
>   
> @@ -347,12 +348,13 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>       int ret = 0;
>   
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
> -        MemoryRegionSection tmp = *rdl->section;
> +        StateChangeListener *scl = &rdl->scl;
> +        MemoryRegionSection tmp = *scl->section;
>   
>           if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>               continue;
>           }
> -        ret = rdl->notify_populate(rdl, &tmp);
> +        ret = scl->notify_to_state_set(scl, &tmp);
>           if (ret) {
>               break;
>           }
> @@ -361,7 +363,8 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>       if (ret) {
>           /* Notify all already-notified listeners. */
>           QLIST_FOREACH(rdl2, &vmem->rdl_list, next) {
> -            MemoryRegionSection tmp = *rdl2->section;
> +            StateChangeListener *scl2 = &rdl2->scl;
> +            MemoryRegionSection tmp = *scl2->section;
>   
>               if (rdl2 == rdl) {
>                   break;
> @@ -369,7 +372,7 @@ static int virtio_mem_notify_plug(VirtIOMEM *vmem, uint64_t offset,
>               if (!memory_region_section_intersect_range(&tmp, offset, size)) {
>                   continue;
>               }
> -            rdl2->notify_discard(rdl2, &tmp);
> +            scl2->notify_to_state_clear(scl2, &tmp);
>           }
>       }
>       return ret;
> @@ -384,10 +387,11 @@ static void virtio_mem_notify_unplug_all(VirtIOMEM *vmem)
>       }
>   
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
> +        StateChangeListener *scl = &rdl->scl;
>           if (rdl->double_discard_supported) {
> -            rdl->notify_discard(rdl, rdl->section);
> +            scl->notify_to_state_clear(scl, scl->section);
>           } else {
> -            virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
> +            virtio_mem_for_each_plugged_section(vmem, scl->section, scl,
>                                                   virtio_mem_notify_discard_cb);
>           }
>       }
> @@ -1053,8 +1057,8 @@ static void virtio_mem_device_realize(DeviceState *dev, Error **errp)
>        * Set ourselves as RamDiscardManager before the plug handler maps the
>        * memory region and exposes it via an address space.
>        */
> -    if (memory_region_set_ram_discard_manager(&vmem->memdev->mr,
> -                                              RAM_DISCARD_MANAGER(vmem))) {
> +    if (memory_region_set_generic_state_manager(&vmem->memdev->mr,
> +                                                GENERIC_STATE_MANAGER(vmem))) {
>           error_setg(errp, "Failed to set RamDiscardManager");
>           ram_block_coordinated_discard_require(false);
>           return;
> @@ -1158,7 +1162,7 @@ static void virtio_mem_device_unrealize(DeviceState *dev)
>        * The unplug handler unmapped the memory region, it cannot be
>        * found via an address space anymore. Unset ourselves.
>        */
> -    memory_region_set_ram_discard_manager(&vmem->memdev->mr, NULL);
> +    memory_region_set_generic_state_manager(&vmem->memdev->mr, NULL);
>       ram_block_coordinated_discard_require(false);
>   }
>   
> @@ -1207,7 +1211,8 @@ static int virtio_mem_post_load_bitmap(VirtIOMEM *vmem)
>        * into an address space. Replay, now that we updated the bitmap.
>        */
>       QLIST_FOREACH(rdl, &vmem->rdl_list, next) {
> -        ret = virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
> +        StateChangeListener *scl = &rdl->scl;
> +        ret = virtio_mem_for_each_plugged_section(vmem, scl->section, scl,
>                                                    virtio_mem_notify_populate_cb);
>           if (ret) {
>               return ret;
> @@ -1704,19 +1709,19 @@ static const Property virtio_mem_properties[] = {
>                        dynamic_memslots, false),
>   };
>   
> -static uint64_t virtio_mem_rdm_get_min_granularity(const RamDiscardManager *rdm,
> +static uint64_t virtio_mem_rdm_get_min_granularity(const GenericStateManager *gsm,
>                                                      const MemoryRegion *mr)
>   {
> -    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> +    const VirtIOMEM *vmem = VIRTIO_MEM(gsm);
>   
>       g_assert(mr == &vmem->memdev->mr);
>       return vmem->block_size;
>   }
>   
> -static bool virtio_mem_rdm_is_populated(const RamDiscardManager *rdm,
> +static bool virtio_mem_rdm_is_populated(const GenericStateManager *gsm,
>                                           const MemoryRegionSection *s)
>   {
> -    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> +    const VirtIOMEM *vmem = VIRTIO_MEM(gsm);
>       uint64_t start_gpa = vmem->addr + s->offset_within_region;
>       uint64_t end_gpa = start_gpa + int128_get64(s->size);
>   
> @@ -1744,12 +1749,12 @@ static int virtio_mem_rdm_replay_populated_cb(MemoryRegionSection *s, void *arg)
>       return data->fn(s, data->opaque);
>   }
>   
> -static int virtio_mem_rdm_replay_populated(const RamDiscardManager *rdm,
> +static int virtio_mem_rdm_replay_populated(const GenericStateManager *gsm,
>                                              MemoryRegionSection *s,
>                                              ReplayStateChange replay_fn,
>                                              void *opaque)
>   {
> -    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> +    const VirtIOMEM *vmem = VIRTIO_MEM(gsm);
>       struct VirtIOMEMReplayData data = {
>           .fn = replay_fn,
>           .opaque = opaque,
> @@ -1769,12 +1774,12 @@ static int virtio_mem_rdm_replay_discarded_cb(MemoryRegionSection *s,
>       return 0;
>   }
>   
> -static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
> +static int virtio_mem_rdm_replay_discarded(const GenericStateManager *gsm,
>                                              MemoryRegionSection *s,
>                                              ReplayStateChange replay_fn,
>                                              void *opaque)
>   {
> -    const VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> +    const VirtIOMEM *vmem = VIRTIO_MEM(gsm);
>       struct VirtIOMEMReplayData data = {
>           .fn = replay_fn,
>           .opaque = opaque,
> @@ -1785,18 +1790,19 @@ static int virtio_mem_rdm_replay_discarded(const RamDiscardManager *rdm,
>                                                    virtio_mem_rdm_replay_discarded_cb);
>   }
>   
> -static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
> -                                             RamDiscardListener *rdl,
> +static void virtio_mem_rdm_register_listener(GenericStateManager *gsm,
> +                                             StateChangeListener *scl,
>                                                MemoryRegionSection *s)
>   {
> -    VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> +    VirtIOMEM *vmem = VIRTIO_MEM(gsm);
> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
>       int ret;
>   
>       g_assert(s->mr == &vmem->memdev->mr);
> -    rdl->section = memory_region_section_new_copy(s);
> +    scl->section = memory_region_section_new_copy(s);
>   
>       QLIST_INSERT_HEAD(&vmem->rdl_list, rdl, next);
> -    ret = virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
> +    ret = virtio_mem_for_each_plugged_section(vmem, scl->section, scl,
>                                                 virtio_mem_notify_populate_cb);
>       if (ret) {
>           error_report("%s: Replaying plugged ranges failed: %s", __func__,
> @@ -1804,23 +1810,24 @@ static void virtio_mem_rdm_register_listener(RamDiscardManager *rdm,
>       }
>   }
>   
> -static void virtio_mem_rdm_unregister_listener(RamDiscardManager *rdm,
> -                                               RamDiscardListener *rdl)
> +static void virtio_mem_rdm_unregister_listener(GenericStateManager *gsm,
> +                                               StateChangeListener *scl)
>   {
> -    VirtIOMEM *vmem = VIRTIO_MEM(rdm);
> +    VirtIOMEM *vmem = VIRTIO_MEM(gsm);
> +    RamDiscardListener *rdl = container_of(scl, RamDiscardListener, scl);
>   
> -    g_assert(rdl->section->mr == &vmem->memdev->mr);
> +    g_assert(scl->section->mr == &vmem->memdev->mr);
>       if (vmem->size) {
>           if (rdl->double_discard_supported) {
> -            rdl->notify_discard(rdl, rdl->section);
> +            scl->notify_to_state_clear(scl, scl->section);
>           } else {
> -            virtio_mem_for_each_plugged_section(vmem, rdl->section, rdl,
> +            virtio_mem_for_each_plugged_section(vmem, scl->section, scl,
>                                                   virtio_mem_notify_discard_cb);
>           }
>       }
>   
> -    memory_region_section_free_copy(rdl->section);
> -    rdl->section = NULL;
> +    memory_region_section_free_copy(scl->section);
> +    scl->section = NULL;
>       QLIST_REMOVE(rdl, next);
>   }
>   
> @@ -1853,7 +1860,7 @@ static void virtio_mem_class_init(ObjectClass *klass, void *data)
>       DeviceClass *dc = DEVICE_CLASS(klass);
>       VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
>       VirtIOMEMClass *vmc = VIRTIO_MEM_CLASS(klass);
> -    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_CLASS(klass);
> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_CLASS(klass);
>   
>       device_class_set_props(dc, virtio_mem_properties);
>       dc->vmsd = &vmstate_virtio_mem;
> @@ -1874,12 +1881,12 @@ static void virtio_mem_class_init(ObjectClass *klass, void *data)
>       vmc->remove_size_change_notifier = virtio_mem_remove_size_change_notifier;
>       vmc->unplug_request_check = virtio_mem_unplug_request_check;
>   
> -    rdmc->get_min_granularity = virtio_mem_rdm_get_min_granularity;
> -    rdmc->is_populated = virtio_mem_rdm_is_populated;
> -    rdmc->replay_populated = virtio_mem_rdm_replay_populated;
> -    rdmc->replay_discarded = virtio_mem_rdm_replay_discarded;
> -    rdmc->register_listener = virtio_mem_rdm_register_listener;
> -    rdmc->unregister_listener = virtio_mem_rdm_unregister_listener;
> +    gsmc->get_min_granularity = virtio_mem_rdm_get_min_granularity;
> +    gsmc->is_state_set = virtio_mem_rdm_is_populated;
> +    gsmc->replay_on_state_set = virtio_mem_rdm_replay_populated;
> +    gsmc->replay_on_state_clear = virtio_mem_rdm_replay_discarded;
> +    gsmc->register_listener = virtio_mem_rdm_register_listener;
> +    gsmc->unregister_listener = virtio_mem_rdm_unregister_listener;
>   }
>   
>   static const TypeInfo virtio_mem_info = {
> diff --git a/include/exec/memory.h b/include/exec/memory.h
> index 3b1d25a403..30e5838d02 100644
> --- a/include/exec/memory.h
> +++ b/include/exec/memory.h
> @@ -43,6 +43,12 @@ typedef struct IOMMUMemoryRegionClass IOMMUMemoryRegionClass;
>   DECLARE_OBJ_CHECKERS(IOMMUMemoryRegion, IOMMUMemoryRegionClass,
>                        IOMMU_MEMORY_REGION, TYPE_IOMMU_MEMORY_REGION)
>   
> +#define TYPE_GENERIC_STATE_MANAGER "generic-state-manager"
> +typedef struct GenericStateManagerClass GenericStateManagerClass;
> +typedef struct GenericStateManager GenericStateManager;
> +DECLARE_OBJ_CHECKERS(GenericStateManager, GenericStateManagerClass,
> +                     GENERIC_STATE_MANAGER, TYPE_GENERIC_STATE_MANAGER)
> +
>   #define TYPE_RAM_DISCARD_MANAGER "ram-discard-manager"
>   typedef struct RamDiscardManagerClass RamDiscardManagerClass;
>   typedef struct RamDiscardManager RamDiscardManager;
> @@ -506,103 +512,59 @@ struct IOMMUMemoryRegionClass {
>       int (*num_indexes)(IOMMUMemoryRegion *iommu);
>   };
>   
> -typedef struct RamDiscardListener RamDiscardListener;
> -typedef int (*NotifyRamPopulate)(RamDiscardListener *rdl,
> -                                 MemoryRegionSection *section);
> -typedef void (*NotifyRamDiscard)(RamDiscardListener *rdl,
> +typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
> +
> +typedef struct StateChangeListener StateChangeListener;
> +typedef int (*NotifyStateSet)(StateChangeListener *scl,
> +                              MemoryRegionSection *section);
> +typedef void (*NotifyStateClear)(StateChangeListener *scl,
>                                    MemoryRegionSection *section);
>   
> -struct RamDiscardListener {
> +struct StateChangeListener {
>       /*
> -     * @notify_populate:
> +     * @notify_to_state_set:
>        *
> -     * Notification that previously discarded memory is about to get populated.
> -     * Listeners are able to object. If any listener objects, already
> -     * successfully notified listeners are notified about a discard again.
> +     * Notification that previously state clear part is about to be set.
>        *
> -     * @rdl: the #RamDiscardListener getting notified
> -     * @section: the #MemoryRegionSection to get populated. The section
> +     * @scl: the #StateChangeListener getting notified
> +     * @section: the #MemoryRegionSection to be state-set. The section
>        *           is aligned within the memory region to the minimum granularity
>        *           unless it would exceed the registered section.
>        *
>        * Returns 0 on success. If the notification is rejected by the listener,
>        * an error is returned.
>        */
> -    NotifyRamPopulate notify_populate;
> +    NotifyStateSet notify_to_state_set;
>   
>       /*
> -     * @notify_discard:
> +     * @notify_to_state_clear:
>        *
> -     * Notification that previously populated memory was discarded successfully
> -     * and listeners should drop all references to such memory and prevent
> -     * new population (e.g., unmap).
> +     * Notification that previously state set part is about to be cleared
>        *
> -     * @rdl: the #RamDiscardListener getting notified
> -     * @section: the #MemoryRegionSection to get populated. The section
> +     * @scl: the #StateChangeListener getting notified
> +     * @section: the #MemoryRegionSection to be state-cleared. The section
>        *           is aligned within the memory region to the minimum granularity
>        *           unless it would exceed the registered section.
> -     */
> -    NotifyRamDiscard notify_discard;
> -
> -    /*
> -     * @double_discard_supported:
>        *
> -     * The listener suppors getting @notify_discard notifications that span
> -     * already discarded parts.
> +     * Returns 0 on success. If the notification is rejected by the listener,
> +     * an error is returned.
>        */
> -    bool double_discard_supported;
> +    NotifyStateClear notify_to_state_clear;
>   
>       MemoryRegionSection *section;
> -    QLIST_ENTRY(RamDiscardListener) next;
>   };
>   
> -static inline void ram_discard_listener_init(RamDiscardListener *rdl,
> -                                             NotifyRamPopulate populate_fn,
> -                                             NotifyRamDiscard discard_fn,
> -                                             bool double_discard_supported)
> -{
> -    rdl->notify_populate = populate_fn;
> -    rdl->notify_discard = discard_fn;
> -    rdl->double_discard_supported = double_discard_supported;
> -}
> -
> -typedef int (*ReplayStateChange)(MemoryRegionSection *section, void *opaque);
> -
>   /*
> - * RamDiscardManagerClass:
> - *
> - * A #RamDiscardManager coordinates which parts of specific RAM #MemoryRegion
> - * regions are currently populated to be used/accessed by the VM, notifying
> - * after parts were discarded (freeing up memory) and before parts will be
> - * populated (consuming memory), to be used/accessed by the VM.
> - *
> - * A #RamDiscardManager can only be set for a RAM #MemoryRegion while the
> - * #MemoryRegion isn't mapped into an address space yet (either directly
> - * or via an alias); it cannot change while the #MemoryRegion is
> - * mapped into an address space.
> + * GenericStateManagerClass:
>    *
> - * The #RamDiscardManager is intended to be used by technologies that are
> - * incompatible with discarding of RAM (e.g., VFIO, which may pin all
> - * memory inside a #MemoryRegion), and require proper coordination to only
> - * map the currently populated parts, to hinder parts that are expected to
> - * remain discarded from silently getting populated and consuming memory.
> - * Technologies that support discarding of RAM don't have to bother and can
> - * simply map the whole #MemoryRegion.
> - *
> - * An example #RamDiscardManager is virtio-mem, which logically (un)plugs
> - * memory within an assigned RAM #MemoryRegion, coordinated with the VM.
> - * Logically unplugging memory consists of discarding RAM. The VM agreed to not
> - * access unplugged (discarded) memory - especially via DMA. virtio-mem will
> - * properly coordinate with listeners before memory is plugged (populated),
> - * and after memory is unplugged (discarded).
> + * A #GenericStateManager is a common interface used to manage the state of
> + * a #MemoryRegion. The managed states is a pair of opposite states, such as
> + * populated and discarded, or private and shared. It is abstract as set and
> + * clear in below callbacks, and the actual state is managed by the
> + * implementation.
>    *
> - * Listeners are called in multiples of the minimum granularity (unless it
> - * would exceed the registered range) and changes are aligned to the minimum
> - * granularity within the #MemoryRegion. Listeners have to prepare for memory
> - * becoming discarded in a different granularity than it was populated and the
> - * other way around.
>    */
> -struct RamDiscardManagerClass {
> +struct GenericStateManagerClass {
>       /* private */
>       InterfaceClass parent_class;
>   
> @@ -612,122 +574,188 @@ struct RamDiscardManagerClass {
>        * @get_min_granularity:
>        *
>        * Get the minimum granularity in which listeners will get notified
> -     * about changes within the #MemoryRegion via the #RamDiscardManager.
> +     * about changes within the #MemoryRegion via the #GenericStateManager.
>        *
> -     * @rdm: the #RamDiscardManager
> +     * @gsm: the #GenericStateManager
>        * @mr: the #MemoryRegion
>        *
>        * Returns the minimum granularity.
>        */
> -    uint64_t (*get_min_granularity)(const RamDiscardManager *rdm,
> +    uint64_t (*get_min_granularity)(const GenericStateManager *gsm,
>                                       const MemoryRegion *mr);
>   
>       /**
> -     * @is_populated:
> +     * @is_state_set:
>        *
> -     * Check whether the given #MemoryRegionSection is completely populated
> -     * (i.e., no parts are currently discarded) via the #RamDiscardManager.
> -     * There are no alignment requirements.
> +     * Check whether the given #MemoryRegionSection state is set.
> +     * via the #GenericStateManager.
>        *
> -     * @rdm: the #RamDiscardManager
> +     * @gsm: the #GenericStateManager
>        * @section: the #MemoryRegionSection
>        *
> -     * Returns whether the given range is completely populated.
> +     * Returns whether the given range is completely set.
>        */
> -    bool (*is_populated)(const RamDiscardManager *rdm,
> +    bool (*is_state_set)(const GenericStateManager *gsm,
>                            const MemoryRegionSection *section);
>   
>       /**
> -     * @replay_populated:
> +     * @replay_on_state_set:
>        *
> -     * Call the #ReplayStateChange callback for all populated parts within the
> -     * #MemoryRegionSection via the #RamDiscardManager.
> +     * Call the #ReplayStateChange callback for all state set parts within the
> +     * #MemoryRegionSection via the #GenericStateManager.
>        *
>        * In case any call fails, no further calls are made.
>        *
> -     * @rdm: the #RamDiscardManager
> +     * @gsm: the #GenericStateManager
>        * @section: the #MemoryRegionSection
>        * @replay_fn: the #ReplayStateChange callback
>        * @opaque: pointer to forward to the callback
>        *
>        * Returns 0 on success, or a negative error if any notification failed.
>        */
> -    int (*replay_populated)(const RamDiscardManager *rdm,
> -                            MemoryRegionSection *section,
> -                            ReplayStateChange replay_fn, void *opaque);
> +    int (*replay_on_state_set)(const GenericStateManager *gsm,
> +                               MemoryRegionSection *section,
> +                               ReplayStateChange replay_fn, void *opaque);
>   
>       /**
> -     * @replay_discarded:
> +     * @replay_on_state_clear:
>        *
> -     * Call the #ReplayStateChange callback for all discarded parts within the
> -     * #MemoryRegionSection via the #RamDiscardManager.
> +     * Call the #ReplayStateChange callback for all state clear parts within the
> +     * #MemoryRegionSection via the #GenericStateManager.
> +     *
> +     * In case any call fails, no further calls are made.
>        *
> -     * @rdm: the #RamDiscardManager
> +     * @gsm: the #GenericStateManager
>        * @section: the #MemoryRegionSection
>        * @replay_fn: the #ReplayStateChange callback
>        * @opaque: pointer to forward to the callback
>        *
>        * Returns 0 on success, or a negative error if any notification failed.
>        */
> -    int (*replay_discarded)(const RamDiscardManager *rdm,
> -                            MemoryRegionSection *section,
> -                            ReplayStateChange replay_fn, void *opaque);
> +    int (*replay_on_state_clear)(const GenericStateManager *gsm,
> +                                 MemoryRegionSection *section,
> +                                 ReplayStateChange replay_fn, void *opaque);
>   
>       /**
>        * @register_listener:
>        *
> -     * Register a #RamDiscardListener for the given #MemoryRegionSection and
> -     * immediately notify the #RamDiscardListener about all populated parts
> -     * within the #MemoryRegionSection via the #RamDiscardManager.
> +     * Register a #StateChangeListener for the given #MemoryRegionSection and
> +     * immediately notify the #StateChangeListener about all state-set parts
> +     * within the #MemoryRegionSection via the #GenericStateManager.
>        *
>        * In case any notification fails, no further notifications are triggered
>        * and an error is logged.
>        *
> -     * @rdm: the #RamDiscardManager
> -     * @rdl: the #RamDiscardListener
> +     * @rdm: the #GenericStateManager
> +     * @rdl: the #StateChangeListener
>        * @section: the #MemoryRegionSection
>        */
> -    void (*register_listener)(RamDiscardManager *rdm,
> -                              RamDiscardListener *rdl,
> +    void (*register_listener)(GenericStateManager *gsm,
> +                              StateChangeListener *scl,
>                                 MemoryRegionSection *section);
>   
>       /**
>        * @unregister_listener:
>        *
> -     * Unregister a previously registered #RamDiscardListener via the
> -     * #RamDiscardManager after notifying the #RamDiscardListener about all
> -     * populated parts becoming unpopulated within the registered
> +     * Unregister a previously registered #StateChangeListener via the
> +     * #GenericStateManager after notifying the #StateChangeListener about all
> +     * state-set parts becoming state-cleared within the registered
>        * #MemoryRegionSection.
>        *
> -     * @rdm: the #RamDiscardManager
> -     * @rdl: the #RamDiscardListener
> +     * @rdm: the #GenericStateManager
> +     * @rdl: the #StateChangeListener
>        */
> -    void (*unregister_listener)(RamDiscardManager *rdm,
> -                                RamDiscardListener *rdl);
> +    void (*unregister_listener)(GenericStateManager *gsm,
> +                                StateChangeListener *scl);
>   };
>   
> -uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
> -                                                 const MemoryRegion *mr);
> +uint64_t generic_state_manager_get_min_granularity(const GenericStateManager *gsm,
> +                                                   const MemoryRegion *mr);
>   
> -bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
> -                                      const MemoryRegionSection *section);
> +bool generic_state_manager_is_state_set(const GenericStateManager *gsm,
> +                                        const MemoryRegionSection *section);
>   
> -int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
> -                                         MemoryRegionSection *section,
> -                                         ReplayStateChange replay_fn,
> -                                         void *opaque);
> +int generic_state_manager_replay_on_state_set(const GenericStateManager *gsm,
> +                                           MemoryRegionSection *section,
> +                                           ReplayStateChange replay_fn,
> +                                           void *opaque);
>   
> -int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                         MemoryRegionSection *section,
> -                                         ReplayStateChange replay_fn,
> -                                         void *opaque);
> +int generic_state_manager_replay_on_state_clear(const GenericStateManager *gsm,
> +                                                MemoryRegionSection *section,
> +                                                ReplayStateChange replay_fn,
> +                                                void *opaque);
>   
> -void ram_discard_manager_register_listener(RamDiscardManager *rdm,
> -                                           RamDiscardListener *rdl,
> -                                           MemoryRegionSection *section);
> +void generic_state_manager_register_listener(GenericStateManager *gsm,
> +                                             StateChangeListener *scl,
> +                                             MemoryRegionSection *section);
>   
> -void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
> -                                             RamDiscardListener *rdl);
> +void generic_state_manager_unregister_listener(GenericStateManager *gsm,
> +                                               StateChangeListener *scl);
> +
> +typedef struct RamDiscardListener RamDiscardListener;
> +
> +struct RamDiscardListener {
> +    struct StateChangeListener scl;
> +
> +    /*
> +     * @double_discard_supported:
> +     *
> +     * The listener suppors getting @notify_discard notifications that span
> +     * already discarded parts.
> +     */
> +    bool double_discard_supported;
> +
> +    QLIST_ENTRY(RamDiscardListener) next;
> +};
> +
> +static inline void ram_discard_listener_init(RamDiscardListener *rdl,
> +                                             NotifyStateSet populate_fn,
> +                                             NotifyStateClear discard_fn,
> +                                             bool double_discard_supported)
> +{
> +    rdl->scl.notify_to_state_set = populate_fn;
> +    rdl->scl.notify_to_state_clear = discard_fn;
> +    rdl->double_discard_supported = double_discard_supported;
> +}
> +
> +/*
> + * RamDiscardManagerClass:
> + *
> + * A #RamDiscardManager coordinates which parts of specific RAM #MemoryRegion
> + * regions are currently populated to be used/accessed by the VM, notifying
> + * after parts were discarded (freeing up memory) and before parts will be
> + * populated (consuming memory), to be used/accessed by the VM.
> + *
> + * A #RamDiscardManager can only be set for a RAM #MemoryRegion while the
> + * #MemoryRegion isn't mapped into an address space yet (either directly
> + * or via an alias); it cannot change while the #MemoryRegion is
> + * mapped into an address space.
> + *
> + * The #RamDiscardManager is intended to be used by technologies that are
> + * incompatible with discarding of RAM (e.g., VFIO, which may pin all
> + * memory inside a #MemoryRegion), and require proper coordination to only
> + * map the currently populated parts, to hinder parts that are expected to
> + * remain discarded from silently getting populated and consuming memory.
> + * Technologies that support discarding of RAM don't have to bother and can
> + * simply map the whole #MemoryRegion.
> + *
> + * An example #RamDiscardManager is virtio-mem, which logically (un)plugs
> + * memory within an assigned RAM #MemoryRegion, coordinated with the VM.
> + * Logically unplugging memory consists of discarding RAM. The VM agreed to not
> + * access unplugged (discarded) memory - especially via DMA. virtio-mem will
> + * properly coordinate with listeners before memory is plugged (populated),
> + * and after memory is unplugged (discarded).
> + *
> + * Listeners are called in multiples of the minimum granularity (unless it
> + * would exceed the registered range) and changes are aligned to the minimum
> + * granularity within the #MemoryRegion. Listeners have to prepare for memory
> + * becoming discarded in a different granularity than it was populated and the
> + * other way around.
> + */
> +struct RamDiscardManagerClass {
> +    /* private */
> +    GenericStateManagerClass parent_class;
> +};
>   
>   /**
>    * memory_get_xlat_addr: Extract addresses from a TLB entry
> @@ -795,7 +823,7 @@ struct MemoryRegion {
>       const char *name;
>       unsigned ioeventfd_nb;
>       MemoryRegionIoeventfd *ioeventfds;
> -    RamDiscardManager *rdm; /* Only for RAM */
> +    GenericStateManager *gsm; /* Only for RAM */
>   
>       /* For devices designed to perform re-entrant IO into their own IO MRs */
>       bool disable_reentrancy_guard;
> @@ -2462,39 +2490,36 @@ bool memory_region_present(MemoryRegion *container, hwaddr addr);
>   bool memory_region_is_mapped(MemoryRegion *mr);
>   
>   /**
> - * memory_region_get_ram_discard_manager: get the #RamDiscardManager for a
> + * memory_region_get_generic_state_manager: get the #GenericStateManager for a
>    * #MemoryRegion
>    *
> - * The #RamDiscardManager cannot change while a memory region is mapped.
> + * The #GenericStateManager cannot change while a memory region is mapped.
>    *
>    * @mr: the #MemoryRegion
>    */
> -RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr);
> +GenericStateManager *memory_region_get_generic_state_manager(MemoryRegion *mr);
>   
>   /**
> - * memory_region_has_ram_discard_manager: check whether a #MemoryRegion has a
> - * #RamDiscardManager assigned
> + * memory_region_set_generic_state_manager: set the #GenericStateManager for a
> + * #MemoryRegion
> + *
> + * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
> + * that does not cover RAM, or a #MemoryRegion that already has a
> + * #GenericStateManager assigned. Return 0 if the gsm is set successfully.
>    *
>    * @mr: the #MemoryRegion
> + * @gsm: #GenericStateManager to set
>    */
> -static inline bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
> -{
> -    return !!memory_region_get_ram_discard_manager(mr);
> -}
> +int memory_region_set_generic_state_manager(MemoryRegion *mr,
> +                                            GenericStateManager *gsm);
>   
>   /**
> - * memory_region_set_ram_discard_manager: set the #RamDiscardManager for a
> - * #MemoryRegion
> - *
> - * This function must not be called for a mapped #MemoryRegion, a #MemoryRegion
> - * that does not cover RAM, or a #MemoryRegion that already has a
> - * #RamDiscardManager assigned. Return 0 if the rdm is set successfully.
> + * memory_region_has_ram_discard_manager: check whether a #MemoryRegion has a
> + * #RamDiscardManager assigned
>    *
>    * @mr: the #MemoryRegion
> - * @rdm: #RamDiscardManager to set
>    */
> -int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                          RamDiscardManager *rdm);
> +bool memory_region_has_ram_discard_manager(MemoryRegion *mr);
>   
>   /**
>    * memory_region_find: translate an address/size relative to a
> diff --git a/migration/ram.c b/migration/ram.c
> index 053730367b..c881523e64 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -857,14 +857,14 @@ static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
>       uint64_t cleared_bits = 0;
>   
>       if (rb->mr && rb->bmap && memory_region_has_ram_discard_manager(rb->mr)) {
> -        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
> +        GenericStateManager *gsm = memory_region_get_generic_state_manager(rb->mr);
>           MemoryRegionSection section = {
>               .mr = rb->mr,
>               .offset_within_region = 0,
>               .size = int128_make64(qemu_ram_get_used_length(rb)),
>           };
>   
> -        ram_discard_manager_replay_discarded(rdm, &section,
> +        generic_state_manager_replay_on_state_clear(gsm, &section,
>                                                dirty_bitmap_clear_section,
>                                                &cleared_bits);
>       }
> @@ -880,14 +880,14 @@ static uint64_t ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
>   bool ramblock_page_is_discarded(RAMBlock *rb, ram_addr_t start)
>   {
>       if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
> -        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
> +        GenericStateManager *gsm = memory_region_get_generic_state_manager(rb->mr);
>           MemoryRegionSection section = {
>               .mr = rb->mr,
>               .offset_within_region = start,
>               .size = int128_make64(qemu_ram_pagesize(rb)),
>           };
>   
> -        return !ram_discard_manager_is_populated(rdm, &section);
> +        return !generic_state_manager_is_state_set(gsm, &section);
>       }
>       return false;
>   }
> @@ -1545,14 +1545,14 @@ static void ram_block_populate_read(RAMBlock *rb)
>        * Note: The result is only stable while migrating (precopy/postcopy).
>        */
>       if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
> -        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
> +        GenericStateManager *gsm = memory_region_get_generic_state_manager(rb->mr);
>           MemoryRegionSection section = {
>               .mr = rb->mr,
>               .offset_within_region = 0,
>               .size = rb->mr->size,
>           };
>   
> -        ram_discard_manager_replay_populated(rdm, &section,
> +        generic_state_manager_replay_on_state_set(gsm, &section,
>                                                populate_read_section, NULL);
>       } else {
>           populate_read_range(rb, 0, rb->used_length);
> @@ -1604,14 +1604,14 @@ static int ram_block_uffd_protect(RAMBlock *rb, int uffd_fd)
>   
>       /* See ram_block_populate_read() */
>       if (rb->mr && memory_region_has_ram_discard_manager(rb->mr)) {
> -        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(rb->mr);
> +        GenericStateManager *gsm = memory_region_get_generic_state_manager(rb->mr);
>           MemoryRegionSection section = {
>               .mr = rb->mr,
>               .offset_within_region = 0,
>               .size = rb->mr->size,
>           };
>   
> -        return ram_discard_manager_replay_populated(rdm, &section,
> +        return generic_state_manager_replay_on_state_set(gsm, &section,
>                                                       uffd_protect_section,
>                                                       (void *)(uintptr_t)uffd_fd);
>       }
> diff --git a/system/memory.c b/system/memory.c
> index b5ab729e13..7b921c66a6 100644
> --- a/system/memory.c
> +++ b/system/memory.c
> @@ -2107,83 +2107,93 @@ int memory_region_iommu_num_indexes(IOMMUMemoryRegion *iommu_mr)
>       return imrc->num_indexes(iommu_mr);
>   }
>   
> -RamDiscardManager *memory_region_get_ram_discard_manager(MemoryRegion *mr)
> +GenericStateManager *memory_region_get_generic_state_manager(MemoryRegion *mr)
>   {
>       if (!memory_region_is_ram(mr)) {
>           return NULL;
>       }
> -    return mr->rdm;
> +    return mr->gsm;
>   }
>   
> -int memory_region_set_ram_discard_manager(MemoryRegion *mr,
> -                                          RamDiscardManager *rdm)
> +int memory_region_set_generic_state_manager(MemoryRegion *mr,
> +                                            GenericStateManager *gsm)
>   {
>       g_assert(memory_region_is_ram(mr));
> -    if (mr->rdm && rdm) {
> +    if (mr->gsm && gsm) {
>           return -EBUSY;
>       }
>   
> -    mr->rdm = rdm;
> +    mr->gsm = gsm;
>       return 0;
>   }
>   
> -uint64_t ram_discard_manager_get_min_granularity(const RamDiscardManager *rdm,
> -                                                 const MemoryRegion *mr)
> +bool memory_region_has_ram_discard_manager(MemoryRegion *mr)
>   {
> -    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> +    if (!memory_region_is_ram(mr) ||
> +        !object_dynamic_cast(OBJECT(mr->gsm), TYPE_RAM_DISCARD_MANAGER)) {
> +        return false;
> +    }
> +
> +    return true;
> +}
> +
> +uint64_t generic_state_manager_get_min_granularity(const GenericStateManager *gsm,
> +                                                   const MemoryRegion *mr)
> +{
> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
>   
> -    g_assert(rdmc->get_min_granularity);
> -    return rdmc->get_min_granularity(rdm, mr);
> +    g_assert(gsmc->get_min_granularity);
> +    return gsmc->get_min_granularity(gsm, mr);
>   }
>   
> -bool ram_discard_manager_is_populated(const RamDiscardManager *rdm,
> -                                      const MemoryRegionSection *section)
> +bool generic_state_manager_is_state_set(const GenericStateManager *gsm,
> +                                        const MemoryRegionSection *section)
>   {
> -    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
>   
> -    g_assert(rdmc->is_populated);
> -    return rdmc->is_populated(rdm, section);
> +    g_assert(gsmc->is_state_set);
> +    return gsmc->is_state_set(gsm, section);
>   }
>   
> -int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
> -                                         MemoryRegionSection *section,
> -                                         ReplayStateChange replay_fn,
> -                                         void *opaque)
> +int generic_state_manager_replay_on_state_set(const GenericStateManager *gsm,
> +                                              MemoryRegionSection *section,
> +                                              ReplayStateChange replay_fn,
> +                                              void *opaque)
>   {
> -    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
>   
> -    g_assert(rdmc->replay_populated);
> -    return rdmc->replay_populated(rdm, section, replay_fn, opaque);
> +    g_assert(gsmc->replay_on_state_set);
> +    return gsmc->replay_on_state_set(gsm, section, replay_fn, opaque);
>   }
>   
> -int ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
> -                                         MemoryRegionSection *section,
> -                                         ReplayStateChange replay_fn,
> -                                         void *opaque)
> +int generic_state_manager_replay_on_state_clear(const GenericStateManager *gsm,
> +                                                MemoryRegionSection *section,
> +                                                ReplayStateChange replay_fn,
> +                                                void *opaque)
>   {
> -    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
>   
> -    g_assert(rdmc->replay_discarded);
> -    return rdmc->replay_discarded(rdm, section, replay_fn, opaque);
> +    g_assert(gsmc->replay_on_state_clear);
> +    return gsmc->replay_on_state_clear(gsm, section, replay_fn, opaque);
>   }
>   
> -void ram_discard_manager_register_listener(RamDiscardManager *rdm,
> -                                           RamDiscardListener *rdl,
> -                                           MemoryRegionSection *section)
> +void generic_state_manager_register_listener(GenericStateManager *gsm,
> +                                             StateChangeListener *scl,
> +                                             MemoryRegionSection *section)
>   {
> -    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
>   
> -    g_assert(rdmc->register_listener);
> -    rdmc->register_listener(rdm, rdl, section);
> +    g_assert(gsmc->register_listener);
> +    gsmc->register_listener(gsm, scl, section);
>   }
>   
> -void ram_discard_manager_unregister_listener(RamDiscardManager *rdm,
> -                                             RamDiscardListener *rdl)
> +void generic_state_manager_unregister_listener(GenericStateManager *gsm,
> +                                               StateChangeListener *scl)
>   {
> -    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
> +    GenericStateManagerClass *gsmc = GENERIC_STATE_MANAGER_GET_CLASS(gsm);
>   
> -    g_assert(rdmc->unregister_listener);
> -    rdmc->unregister_listener(rdm, rdl);
> +    g_assert(gsmc->unregister_listener);
> +    gsmc->unregister_listener(gsm, scl);
>   }
>   
>   /* Called with rcu_read_lock held.  */
> @@ -2210,7 +2220,7 @@ bool memory_get_xlat_addr(IOMMUTLBEntry *iotlb, void **vaddr,
>           error_setg(errp, "iommu map to non memory area %" HWADDR_PRIx "", xlat);
>           return false;
>       } else if (memory_region_has_ram_discard_manager(mr)) {
> -        RamDiscardManager *rdm = memory_region_get_ram_discard_manager(mr);
> +        GenericStateManager *gsm = memory_region_get_generic_state_manager(mr);
>           MemoryRegionSection tmp = {
>               .mr = mr,
>               .offset_within_region = xlat,
> @@ -2225,7 +2235,7 @@ bool memory_get_xlat_addr(IOMMUTLBEntry *iotlb, void **vaddr,
>            * Disallow that. vmstate priorities make sure any RamDiscardManager
>            * were already restored before IOMMUs are restored.
>            */
> -        if (!ram_discard_manager_is_populated(rdm, &tmp)) {
> +        if (!generic_state_manager_is_state_set(gsm, &tmp)) {
>               error_setg(errp, "iommu map to discarded memory (e.g., unplugged"
>                            " via virtio-mem): %" HWADDR_PRIx "",
>                            iotlb->translated_addr);
> @@ -3814,8 +3824,15 @@ static const TypeInfo iommu_memory_region_info = {
>       .abstract           = true,
>   };
>   
> -static const TypeInfo ram_discard_manager_info = {
> +static const TypeInfo generic_state_manager_info = {
>       .parent             = TYPE_INTERFACE,
> +    .name               = TYPE_GENERIC_STATE_MANAGER,
> +    .class_size         = sizeof(GenericStateManagerClass),
> +    .abstract           = true,
> +};
> +
> +static const TypeInfo ram_discard_manager_info = {
> +    .parent             = TYPE_GENERIC_STATE_MANAGER,
>       .name               = TYPE_RAM_DISCARD_MANAGER,
>       .class_size         = sizeof(RamDiscardManagerClass),
>   };
> @@ -3824,6 +3841,7 @@ static void memory_register_types(void)
>   {
>       type_register_static(&memory_region_info);
>       type_register_static(&iommu_memory_region_info);
> +    type_register_static(&generic_state_manager_info);
>       type_register_static(&ram_discard_manager_info);
>   }
>   
> diff --git a/system/memory_mapping.c b/system/memory_mapping.c
> index 37d3325f77..e9d15c737d 100644
> --- a/system/memory_mapping.c
> +++ b/system/memory_mapping.c
> @@ -271,10 +271,8 @@ static void guest_phys_blocks_region_add(MemoryListener *listener,
>   
>       /* for special sparse regions, only add populated parts */
>       if (memory_region_has_ram_discard_manager(section->mr)) {
> -        RamDiscardManager *rdm;
> -
> -        rdm = memory_region_get_ram_discard_manager(section->mr);
> -        ram_discard_manager_replay_populated(rdm, section,
> +        GenericStateManager *gsm = memory_region_get_generic_state_manager(section->mr);
> +        generic_state_manager_replay_on_state_set(gsm, section,
>                                                guest_phys_ram_populate_cb, g);
>           return;
>       }

-- 
Alexey


