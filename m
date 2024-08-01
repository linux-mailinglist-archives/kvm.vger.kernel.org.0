Return-Path: <kvm+bounces-22952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F036944EF3
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 17:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 923541F23D13
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 15:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 957F913C80C;
	Thu,  1 Aug 2024 15:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Dc4aFWGY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81041EB4AC;
	Thu,  1 Aug 2024 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722525468; cv=fail; b=PPtu+mQuoI/eHyaYq+ixOxQvuMI6AttK8kyqG0thj2bbTWNTmevyZ+eE4MdE+Kq1Kds6JbJ7KS+W7lxKSz/3HwG9O4eFvZDZqgYzxbS1ysN7NQs8dtCH4Mz/ZfSe42aKoGtnB0hFBX9MIk9wgqiXJcY6Wnm7TxuvOglr+OZRsFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722525468; c=relaxed/simple;
	bh=W1+cTQUkN/58W7oq1SwTGrlqt8UmPMlLx+RztFAGpcw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DrQKLvhGKDwC3+xWNLVMu2dOMPo6Kp2KPaE5Nfzp8PQC73NkJWvu/JU5tJ8DYRQYOgsaufnV9w4VKUGM4Xibb9BSTiRhAyekJ7myxEwNpRNwI9cxSVMan0Zo/j23KxtnNhcSzm5j9mnGqiSMMAvqdNO2YPmIc0gUCwSST5wa+Qw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Dc4aFWGY; arc=fail smtp.client-ip=40.107.100.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wFndk9acZFaYlrZ6rWdSNLvoU8dOONqxUxceHuIVqz+Qye4qEPOqhkV6UUUb8RE2sXzhvwrVFRd5j2521J+QVI6eI4pNYLqOpCjxOqAhD39IWTyJdLfRCWl083588iAQfBLoACDY9SWy+XkPXUyRHEqSJJVR8ED3fP7bp5/5++t1NOYZyaLjs5qH7R1qe05ng3HlL/HpGQXkcAdxy/aC8pY4AETd+eravsrQiVqa5Rtcu7Nj+eAWl2wlNvEuqzN1OrDB9eIPsOIVkxaDoqCtiQFb9n8LogVLcRzhz5LmcuMN9Fskva8AiJ5OYqRPjIiusL/8D1/XFrBOojq14AlLAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o6wVGxF9C+uLxTK+WcKTaWO8EIwrOJwe8xy+9MXabTY=;
 b=kD2inIIU7W2RoickCkyn7bhWthfu+m4n7BEUFntVSyl851f3/dGeSHL3i/igHCKhI0/j2otwEqmKLAALd8bTo5MVEmWOXZ2aRpx+2YNYN61zXl+mQtMgqucyLY1bZmgzh6XhDyPvz1uvIKAaqx/kTC6RvlyWQuxMxLYoEePcg+J8b/sWI2x2CtyQakBE7c2InrXUcgRz55B8ayIT/cWClv8r/+wnTHLk5aPKm6EJ3rM/cRvAdgZEpoeHjDkPrqnAQWGGS/RP6slQ2/LtKMGuB3P2/6RqK56uXP8+rHUK2jtFADTrNjzU3lzcWCBNEsVBaf7m3/otb4wMr+7OvLhKSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o6wVGxF9C+uLxTK+WcKTaWO8EIwrOJwe8xy+9MXabTY=;
 b=Dc4aFWGYValqet/K549EnbAoXWdIaQHtIMASHzLN3EAEuWkLsIarmf7L4Ww6Lt3nJmblg2YEhSf7G9F+T6vLeeAfE31fntLJincv9hGlmnz5Qi4vXOraUcLjQEjUVEsvwb+Q63IzZ+mKx2Ib+H5mF9RSKmjtlalfoQS5NZ3g1FAo3ZPx/R/CZpD9iCPt94DDNL81FW3oGYRW0OKUSmpYT8s93pH9L625mrOzKpt1z5KjMC/zUbaYYH3JWcGL+o28GmeeJbVgU/aWKspY8bZw8G6O3u+Ks3g+AUh14h4as8OYCB/64qvJ81CinbyhLUUYQKhMeG6EE23ESWc4Z+LW6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by DM4PR12MB5914.namprd12.prod.outlook.com (2603:10b6:8:67::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.19; Thu, 1 Aug
 2024 15:17:34 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.7828.016; Thu, 1 Aug 2024
 15:17:34 +0000
Message-ID: <0888da3b-3283-405b-b1a8-a315e2623289@nvidia.com>
Date: Thu, 1 Aug 2024 18:17:21 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] virtio_blk: implement init_hctx MQ operation
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: stefanha@redhat.com, virtualization@lists.linux.dev, axboe@kernel.dk,
 kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
References: <20240801151137.14430-1-mgurtovoy@nvidia.com>
 <20240801111337-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <20240801111337-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0182.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:311::12) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|DM4PR12MB5914:EE_
X-MS-Office365-Filtering-Correlation-Id: d0217171-59fd-4c2b-a0f1-08dcb23d120f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qm9NeDJpejJOVG05cWxYeGhTcTdCUGN5N1VXRENwU0prVnpyTEFmbG5oSXF3?=
 =?utf-8?B?cTVRN2ZGYmsza2paeS9ZdnkxcXZwSm9pMFBGUzAwekREQmtrVWtKVzFlVlhZ?=
 =?utf-8?B?R2NOeTBFSTBpUGlpSUtERmpzQjFWSUhFZ0xYSHNYTGJmRi9BcTB6aGNZR1VG?=
 =?utf-8?B?R1creitTRTV0Q0Q0bnRCOThTY2Q1SWxiZ2NFQkpCWjVNQzJpUXdrMXlMVzFt?=
 =?utf-8?B?UW9ZbnhvbUJ1Qlh1MzBCQTBuRGFNSU5HOWF5bG9iNVhVT3NtTVJFNXp3Mk9F?=
 =?utf-8?B?Ryt4WUh3azlIV1B2SE1rVG9kYU5qYWNxWVVSeGNPbmNkUEVHVXVZOTlaRE9o?=
 =?utf-8?B?MDQvc0ZEclJjNHhBMWNITndyYTA4MURNVEVzbGZFbHZPNVdkSmZIUkFVNnRx?=
 =?utf-8?B?TDhRQUw2WmdyS0ZRMmhVV0I4c0VHVXIvV0h3NlJlUUw5WjVrWnFoaWRkcjFh?=
 =?utf-8?B?Q3Z0cTA2MkZteW5CQlQ0c1NBS085ZDVRSlpmc3JiZ0pZOHRwZHA5OTYxemJJ?=
 =?utf-8?B?Q29USEVXaDRwT1c1N2NWb1Y4azI4U1RjS2dYb21pc09Ia1FJOS82d0ZLRERG?=
 =?utf-8?B?NHdtbFEwZVlocEN1ODdBZEFXWXBSTkU5NTFmdHdGQS9TWnNET1hsV1lvMzNT?=
 =?utf-8?B?QjlNbnV5VUhPT1pXMWRCWXVRMlI0WXhJLzJHWHMvQmpHckc1dzVkbmhkaWh1?=
 =?utf-8?B?czd6M0dIS3p5Vit1L1ZuYVhVV2NVUCtEL3c2VUd0elRMUUpxUzRlMWZzYytr?=
 =?utf-8?B?azAvOFhTd3loWG12MW91MXBnVXk4WVVmMGxiMWRoWlBmcHRUSWtZWUljbE4y?=
 =?utf-8?B?K3V0a0VldExNc0FoSldKcG9IcXRObURyTk9LQUFQYUE5WTJCVmh1QmxLcmFO?=
 =?utf-8?B?ck9XR0JUb0JzdE9Iak9LNEZwWE9TQ0x1NlJuanJJREIrQ0FqZ0IyVUhvemtS?=
 =?utf-8?B?YVdPcTdzZ3ZMbld1dTFBd041ZGpOMjVqZ0ZsdUxlbU5oR1dJZHUwRmhROG9G?=
 =?utf-8?B?MktQNEdycUVyS21XdVA0RkZ2c1pjT3hrcmYvRjRDQ1J4RUVvTmFRS0xjejRL?=
 =?utf-8?B?V2pMMzBHYlFtMHpQNFpEZWk1djNseGs2eUk3UmhBVGpqeW9WWEc4aDNMTXkr?=
 =?utf-8?B?LzBwNExZanJsTFhOZ1U4bFRWeWgvRUFXMUNtNFRXcW5MYThyUFRHUHF1VnpC?=
 =?utf-8?B?VWtLQWtYd3IvMXErWERReGNOYTlLVHpaREEwNCsyRFlzdU9pRlZHeEI0ZzdQ?=
 =?utf-8?B?YWNFaXZ1bE1LclN5NEpLVCtmNGVyTklzeWI2amhPRXowZjF5N25ybkg2cktx?=
 =?utf-8?B?SVBVNDlmOUdudEVvd3AvKzdNdEZtb1hQcHg5QUZlQjJjLzNjRFltdlFZcG5F?=
 =?utf-8?B?U29DWGVWRXhzL3YwdHlUVUFXRElFeDJLb0prN1Q0WG5oWTNHOG04TGN0TzAx?=
 =?utf-8?B?d3IrVENjSzNDQTY0UUtnc2YyVXJUTy9lRjcxOUk1YS9tSlNJaHl4L3BaQ0NE?=
 =?utf-8?B?WUxoQ2NJY3N5aEJqT2hmOER2R3pzSi9SNEdKNE4zR1BFRlByM2NKYzFYNysx?=
 =?utf-8?B?OWZ6bUduOTVvcVpWSDJEQ2pISnE1cm9Ta1d0TW9mZ2pQMTRGdzFYTHhhQ1ZX?=
 =?utf-8?B?MGRXajNOaFl0NWcvb3MrV1A2ZEw3eUVmczdwajVENWxLSDMvdnh3c1lxajFD?=
 =?utf-8?B?U0ZYU2ZUdVB0MmFGNjV1b1c2bGxVUks5aU9LajhFczh5WlJ5bnZmcjh5NWVF?=
 =?utf-8?B?cGdQcEx6aUtha2tHMVNmUGFaTWg1VjRrcW5uTVhOOTFyWkpzWldqdXY2MURv?=
 =?utf-8?B?VCtSRVB2ekdYVkJWWXp0dz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2k1QlFCY28wRnVWbnY2MWpWUFk4VWVmU2ZGTWN4UFNQRUVBVC8xZkRhaUY4?=
 =?utf-8?B?ZThiVmpUdnFBQ0pNbzI4WTRyZ3BRSkUzSlRjQUNPMTRteTB5cm9PdDZ5QjFk?=
 =?utf-8?B?UlNHMzdPY0Z0aGFmVTArRDVTSmZwK2I4aGhiNlJWM2hpL1J3cnRDdENYaTcw?=
 =?utf-8?B?ZVJrY0lBYzVoQzVQNEU3U0tHWXJVdUtzTnZSZWduTTBOVUhUWGxrZXY4dUVH?=
 =?utf-8?B?MUY2LzF3SlN2YVhIdjlaN2xQbmpsRHdWQUhwQ2kvdER1UzF1U09sWmZYM0RJ?=
 =?utf-8?B?dmREU3puL3hpb0NxYWM0cFh6M20wWWZUS1JRdzkvdkNiWFdZcGNENEhxVGh5?=
 =?utf-8?B?Nnp5cFJOUHFtSFdIdDBwdXdtWnNwTkhnTDVWQ0wxdWJWQ2U5UHhvdjNqRE5C?=
 =?utf-8?B?SzlRYS9OOXVmc3owOUJkMW5vNUN5N0gzZGVxZ1lJZFF4L3p5KytzZmRkQ3Zq?=
 =?utf-8?B?Rk5ySklSa1h5dmI4N0Rkb3JTbmlnb2szeHY3N1NUUzE3WHdkOXZ6aW5BL2Iy?=
 =?utf-8?B?RzcxMmMzd1paeXJKbk1xeTlBeGZsd2xneEpqL0l1UTlyMytCQ2k5UUcrMTFk?=
 =?utf-8?B?eDcwenhud29IN1UrMzhPaFlseldvOStMYVdHZ2JBMXI2MU1IT28zUzAra0N4?=
 =?utf-8?B?bGNtdjBVYU9HR0FPc1UrWGpXU2NNd0Y3azB5VkN3YnJFbGR5djhabzRSdHNj?=
 =?utf-8?B?bkRzWDUzRTljSStEbkpmWlFBZjlNRkxwWC9GMWJKM0s3NUJxTlBzNUkrYSt2?=
 =?utf-8?B?eXl2YW5uMWNjaFE0Q2doaW5oNWJqUzJrWkZwNHk4V1RXUks3bEVvNWx0UkIz?=
 =?utf-8?B?Z2RnT2pnd0VWZGhEMnNQSjFrWlR0Wkw1SE5ZcmplT2pZUndNN3l4cXVTcThl?=
 =?utf-8?B?TXVtYW5kdGc2NGdVM2JUKzNYY3l0UlNQSGp5R3o3YlRGeVlGNWsrZVZ4Ri8x?=
 =?utf-8?B?Lzk2aUpQOE1XTXQ1dUFkd3NCUmVMdTRYOS8xNUkwRlFpWjgxdjhIa0hOVUZ4?=
 =?utf-8?B?ZVpKd3ZSc3dEaEFXOUg0Z3RKclgyT2kxcW9vY0xicnNqY3FOTjJpdGNOaVcv?=
 =?utf-8?B?aDh2d2tFYk95NlVRTFNGL2c0NXkyRk9LSGRaTU51Vlo2S2hFajNoczFsZmRk?=
 =?utf-8?B?TEtydnJmV1BrZENyK3U2VlVHVEdUSEFteG53b2VNMm5KTndKbFVCa1hKVUNJ?=
 =?utf-8?B?OWhTNnBNaWFRSkhOOEg2dnZqTm0ydUIxc2tQNittTytzbGhlNy9uMWcwRzlN?=
 =?utf-8?B?aWhnK0dxbkl6aktyOWMyZEppdkFxcU5SeVQ5ZHZJU0VmVm9yTlo1aEtFeXVI?=
 =?utf-8?B?cnIwd0Q0NmhHNzMrem1CQ2JRNDdsRW5IV0hpdUZnS3pIRitnazhyeFJJWEFq?=
 =?utf-8?B?VHpaT0dVWVBGbW9pUUNoUGg2MWZQWEQ0TE1Tc2s1dTcvbDZNZkFiNXZIZ0hZ?=
 =?utf-8?B?WEV2eDJ2QWNOS0JBZkw1T0RpKzBRdW1yMzhkMjY3TmNwVkhQc3ZpcTNaeUQw?=
 =?utf-8?B?cE8yTi9SV1MxTUZuck1hTUtIN2toSTlpQTNKYkVNMjl5MS92U1NoL2pwV1px?=
 =?utf-8?B?clZITnl0ODRLZ1cvVWpBb0pxZDlheHJ2cnBCbTF5c2I0Qyt3dnU3akxCU2Ix?=
 =?utf-8?B?ekVnZzRadzNQbFFNdHFtbk9yWXpQemlQemFzZWlkL3gzVkdzZ2xQSjJkYVRu?=
 =?utf-8?B?b2dsK202eDI1QThrTldIblR6d3ZPUEkvK0c4QkZYNXVodWg5aVhhYWtrVXEv?=
 =?utf-8?B?TkUzUC94Nk81ekF6bVFWeFFpdUlDYVhkTmpETFAyM3JVdmNteUp1RUlSdXkx?=
 =?utf-8?B?YS9WK2NqUGdWTmpvOUtXWmx4eVZjK1NPbmtybjVEcmhCSkJtdmxpUjF2YTJu?=
 =?utf-8?B?VFcxRk9hVXRubldmZTdUaEhoblhhaks2MElQZmZKT2IyZ1cvNndVaUlrWFA0?=
 =?utf-8?B?bWJyUkRSTjZjbzlBZ3Q0SlFMTTR0alNRTUNHRW1JaEZQN3VjSS9JNnM1S0xF?=
 =?utf-8?B?U0VJTnpLMllsQlE3Q0ViSUdMZ3JLb3FmRHBvRVV5TEdsei9tTThJVnFZYXlw?=
 =?utf-8?B?aFhZQ2NNSVlHWnZDVjZPMnY3MVlFWFpaU3BUekxEVmt4cTczTFVTQU1Jb2dn?=
 =?utf-8?Q?8S8Rm10OxzvRW0Qw47aXPjyLm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0217171-59fd-4c2b-a0f1-08dcb23d120f
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2024 15:17:34.7924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RMHH3oY72tRjMFyfR6Ib1NfM7hAydXTgKWj8yKMaJjhlIL5DxA+B6OtwGVmRD5TfbCU/Y9MPh2EmKMJfkNeWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5914


On 01/08/2024 18:13, Michael S. Tsirkin wrote:
> On Thu, Aug 01, 2024 at 06:11:37PM +0300, Max Gurtovoy wrote:
>> In this operation set the driver data of the hctx to point to the virtio
>> block queue. By doing so, we can use this reference in the and reduce
> in the .... ?

sorry for the type.

should be :

"By doing so, we can use this reference and reduce the number of operations in the fast path."


>
>> the number of operations in the fast path.
>>
>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>> ---
>>   drivers/block/virtio_blk.c | 42 ++++++++++++++++++++------------------
>>   1 file changed, 22 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>> index 2351f411fa46..35a7a586f6f5 100644
>> --- a/drivers/block/virtio_blk.c
>> +++ b/drivers/block/virtio_blk.c
>> @@ -129,14 +129,6 @@ static inline blk_status_t virtblk_result(u8 status)
>>   	}
>>   }
>>   
>> -static inline struct virtio_blk_vq *get_virtio_blk_vq(struct blk_mq_hw_ctx *hctx)
>> -{
>> -	struct virtio_blk *vblk = hctx->queue->queuedata;
>> -	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>> -
>> -	return vq;
>> -}
>> -
>>   static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *vbr)
>>   {
>>   	struct scatterlist out_hdr, in_hdr, *sgs[3];
>> @@ -377,8 +369,7 @@ static void virtblk_done(struct virtqueue *vq)
>>   
>>   static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
>>   {
>> -	struct virtio_blk *vblk = hctx->queue->queuedata;
>> -	struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>   	bool kick;
>>   
>>   	spin_lock_irq(&vq->lock);
>> @@ -428,10 +419,10 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   			   const struct blk_mq_queue_data *bd)
>>   {
>>   	struct virtio_blk *vblk = hctx->queue->queuedata;
>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>   	struct request *req = bd->rq;
>>   	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>>   	unsigned long flags;
>> -	int qid = hctx->queue_num;
>>   	bool notify = false;
>>   	blk_status_t status;
>>   	int err;
>> @@ -440,26 +431,26 @@ static blk_status_t virtio_queue_rq(struct blk_mq_hw_ctx *hctx,
>>   	if (unlikely(status))
>>   		return status;
>>   
>> -	spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>> -	err = virtblk_add_req(vblk->vqs[qid].vq, vbr);
>> +	spin_lock_irqsave(&vq->lock, flags);
>> +	err = virtblk_add_req(vq->vq, vbr);
>>   	if (err) {
>> -		virtqueue_kick(vblk->vqs[qid].vq);
>> +		virtqueue_kick(vq->vq);
>>   		/* Don't stop the queue if -ENOMEM: we may have failed to
>>   		 * bounce the buffer due to global resource outage.
>>   		 */
>>   		if (err == -ENOSPC)
>>   			blk_mq_stop_hw_queue(hctx);
>> -		spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>> +		spin_unlock_irqrestore(&vq->lock, flags);
>>   		virtblk_unmap_data(req, vbr);
>>   		return virtblk_fail_to_queue(req, err);
>>   	}
>>   
>> -	if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
>> +	if (bd->last && virtqueue_kick_prepare(vq->vq))
>>   		notify = true;
>> -	spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>> +	spin_unlock_irqrestore(&vq->lock, flags);
>>   
>>   	if (notify)
>> -		virtqueue_notify(vblk->vqs[qid].vq);
>> +		virtqueue_notify(vq->vq);
>>   	return BLK_STS_OK;
>>   }
>>   
>> @@ -504,7 +495,7 @@ static void virtio_queue_rqs(struct request **rqlist)
>>   	struct request *requeue_list = NULL;
>>   
>>   	rq_list_for_each_safe(rqlist, req, next) {
>> -		struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
>> +		struct virtio_blk_vq *vq = req->mq_hctx->driver_data;
>>   		bool kick;
>>   
>>   		if (!virtblk_prep_rq_batch(req)) {
>> @@ -1164,6 +1155,16 @@ static const struct attribute_group *virtblk_attr_groups[] = {
>>   	NULL,
>>   };
>>   
>> +static int virtblk_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
>> +		unsigned int hctx_idx)
>> +{
>> +	struct virtio_blk *vblk = data;
>> +	struct virtio_blk_vq *vq = &vblk->vqs[hctx_idx];
>> +
>> +	hctx->driver_data = vq;
>> +	return 0;
>> +}
>> +
>>   static void virtblk_map_queues(struct blk_mq_tag_set *set)
>>   {
>>   	struct virtio_blk *vblk = set->driver_data;
>> @@ -1205,7 +1206,7 @@ static void virtblk_complete_batch(struct io_comp_batch *iob)
>>   static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
>>   {
>>   	struct virtio_blk *vblk = hctx->queue->queuedata;
>> -	struct virtio_blk_vq *vq = get_virtio_blk_vq(hctx);
>> +	struct virtio_blk_vq *vq = hctx->driver_data;
>>   	struct virtblk_req *vbr;
>>   	unsigned long flags;
>>   	unsigned int len;
>> @@ -1236,6 +1237,7 @@ static const struct blk_mq_ops virtio_mq_ops = {
>>   	.queue_rqs	= virtio_queue_rqs,
>>   	.commit_rqs	= virtio_commit_rqs,
>>   	.complete	= virtblk_request_done,
>> +	.init_hctx	= virtblk_init_hctx,
>>   	.map_queues	= virtblk_map_queues,
>>   	.poll		= virtblk_poll,
>>   };
>> -- 
>> 2.18.1

