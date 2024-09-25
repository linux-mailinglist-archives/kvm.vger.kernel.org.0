Return-Path: <kvm+bounces-27411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D79C9856FC
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 12:12:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9735B1F21990
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 10:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10BE215C131;
	Wed, 25 Sep 2024 10:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="10SwvWng"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121BF14B07E;
	Wed, 25 Sep 2024 10:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727259138; cv=fail; b=halZ9ZJ4VSSC/m1TCvu911JnqIqhPSu9G3fdrmoLcrp7OdR2iW/u8WIihDHJVTcBKVo8AiInNmTOi9d//EPJgeYcI7ysIEf7kyerp+zKxcG1Sqc3gYDRuScRpG3ik11nyBvUDRVm9MiFd8g+lLgNF4BPSRhBfCizhV5a5tejLZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727259138; c=relaxed/simple;
	bh=AjDkFg173h0GreO5Pd9HMumnAgG/fkGnFIzAF3q6rjg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lLisobQhPKuzJhU4SQoCVNf+FS5bJPgmEpotuQX/KdIGeZZS5sLexNvZf73bBhzcIfP7+KJvFepqR4aVQexNKT/S01ZDVpG4aJ2k0Zuij69hygeRhRqOPSpaX+0XbUinKlhDYS02BWseKZ8SqfBaEolE4zON+8QgdA1AMX13xLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=10SwvWng; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RecxttdNAFiVzTaUQ6jJG6T/x+r6XsWuFwIAsNF3ystfBcNogX5rtpcf2QoApqXWbn/IgRhKUCb85DeFK/6kN0bfDHFMXIXTsS/ZSD+Y/0nP4BbxLwiJOoXOfYVlWsXhHyvd4ggmyLpwkFLDiG9AbMDycwnCvfa5Muwbyt655Bdn2FA1+jZhCPr9mm7/QwCdbdO1uh76kzw+n5xI//kFx3JP33x9gg6cb07/DL+QLmO6ldeLeZeyQiJQowpjjpw2ejiVvQGXY/nrfY60LTxGxqOYs0SqqN09hWokuRS1enqw8nzkGMrQUyZoxLCvUVkMeuP3Dc3VD4bfz4c+6xzNng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kdEnci752hiqczK6UD4iUaAih/5EL2u949HskLQW7eU=;
 b=dMhoLdbMp6T+wcv5qzxvgtQrOuswufW6RVsDlMKQFjHbgBkMClJlfPt/6ge84ANknKfJZzTraCd9KRt4kQq5IdzagSWEvkAuq4Fsfw1F/kwexIoAlKSHiqXDCpBjOFBHlHhEc0NuSb7mg6ePcHvRxt8W5TrstTBTf/SkZygatEE/F+vyfGEugq9EUPebE+3SbxI+FfxUFSmaoZM8oaS0uizWU3FXXAeFuAQvHydnptSjuCfauNv7dVhWC+riBdEDHzOBsy95+y6SG3gwjJQXUw/hyx8On+WpbceCaQydZ7dQJu/KC5DSQ+pYjx2jkP0Dr7qnbwFq5NnpPKRcvgAGpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdEnci752hiqczK6UD4iUaAih/5EL2u949HskLQW7eU=;
 b=10SwvWngUX8nzxXdsRUp4Qbt0nmy6MamqpY+XKnJeHcp+6xor3AqkYYkXmhiwafv94EcMgb0ci1CExX5eKVqNTiUbCNnmOADpqrwC+R8/3B+cC41Luzmt4BW7mKYyvtekebNihLdsBesRToPQn971PczVxLvxFrsARMbAtD/qVg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by MN0PR12MB6001.namprd12.prod.outlook.com (2603:10b6:208:37d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Wed, 25 Sep
 2024 10:12:13 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::f943:600c:2558:af79]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::f943:600c:2558:af79%4]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 10:12:12 +0000
Message-ID: <4230fba5-030c-49ef-799e-f4138b1c9f7d@amd.com>
Date: Wed, 25 Sep 2024 11:11:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC 00/13] vfio: introduce vfio-cxl to support CXL type-2
 accelerator passthrough
Content-Language: en-US
To: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org, linux-cxl@vger.kernel.org
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com,
 alison.schofield@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com,
 dave@stgolabs.net, jonathan.cameron@huawei.com, ira.weiny@intel.com,
 vishal.l.verma@intel.com, acurrid@nvidia.com, cjia@nvidia.com,
 smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
 kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
References: <20240920223446.1908673-1-zhiw@nvidia.com>
From: Alejandro Lucero Palau <alucerop@amd.com>
In-Reply-To: <20240920223446.1908673-1-zhiw@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0081.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::14) To DM6PR12MB4202.namprd12.prod.outlook.com
 (2603:10b6:5:219::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB4202:EE_|MN0PR12MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c72e812-7dbf-42aa-4c54-08dcdd4a8605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?a3cwcVBxbVZaR3lhaStKMFFOME82Ny9ib3l6QTJablcrV2VBSFBya0wzd1JN?=
 =?utf-8?B?VnFCLzA2U1NZcDhuV3R2bG9RcEhRSy9JV3YzVVArK2k0WG05SEc1QUhHb25P?=
 =?utf-8?B?MnZ6bUVuUDF6SzFrOWFSejBvV1pCblJ6WjJKeDlXWUNFVEQ1QVNqNGpZdktW?=
 =?utf-8?B?SmFsVElZekhVZGxYeFRTVU8zUWpNRVdhclp6S0NEZnNtMHp4dnVuL0xHamFp?=
 =?utf-8?B?OHRjWU5yMnVxdEJVSkFFanljbTVRUFY4OWlVQWNtQmpXR2RPbGg5dVM1aFU3?=
 =?utf-8?B?UHREK1BzVnU3SVRwWUZnT3AyQUNOZGVJTjdyaHYybmZCOXY5Y2JPVE9RVHkr?=
 =?utf-8?B?Mk40dlptdTM0U2NtTjMwSTM2VTFQL3JXT016REQrcm5RSk5vek1pazdkcGNw?=
 =?utf-8?B?YURNNUdadjVNYXdPdU9XME9ia0h5NUxnZWlHbGNacHd3K1EwaTgzUDM1ZzNn?=
 =?utf-8?B?bUtRTnFIL0FjK1dtNGhOSjI1WlNlcTJKcXllVENSU3NrSnQ3bCtUOGRDY1R1?=
 =?utf-8?B?dTM4SmFpb0RUU2p2c2hqNDFCc0RVSmZYVUdkUnM5RzJyb09MSlBlbzBGVmpJ?=
 =?utf-8?B?QnRJMGVjWVYzSUNMSzBqVEhYVHpCMTVtdEgyNUlpZHRJUm9uOGNXVHFPc1JG?=
 =?utf-8?B?dmNvdk52RkhkcTNlbEh5ZzRwdHdRdHBndzc4elFhZGEwVVp1ODB0RTliOWZ6?=
 =?utf-8?B?a2V1REpvV1VmeHF1Skpta1dOZitEMVRxd1J1WmlvS3cza29Pdk8wd2N4UURR?=
 =?utf-8?B?djlSbTNaY0xOTkQ2NWQ5ZmdGdkdtMXhWSTQrMjd2Z2lVdGJtaXFmYUl0NnJu?=
 =?utf-8?B?eUxBQUdWY1pzTFZjdUxIOGJuTGxxbDZFSVE3Z3Z0U2ZvbXMvaUNSTHU4ditt?=
 =?utf-8?B?NERrUlV1ZUtlcUR1algzZFg1dzNPdU8yN0JBQWJ2RlBGY2ptVkVSZ2NQSTkr?=
 =?utf-8?B?ZEFQRnhCVDZ5cVBGK0xYZFUwTm9MTXdEbThxOG05czV5eGxzUEtMYmZHVStG?=
 =?utf-8?B?OFM4Wnh6TnN0WGFCR091OTR1OWdodnBWS2E5RHVZR2ZMT0d5T25qY0p3cWc4?=
 =?utf-8?B?dXh2R0tDTy9KaFJtTWdCMC90ZFFseEVubHNXaGMwd0lGbXVBNVZiOERPZU9q?=
 =?utf-8?B?MmYxRjZsbm1NbE1QNHphNmgxeWdNVi9YNzlaN0NKb0ZsSUg4Qnhob2ZyeDdW?=
 =?utf-8?B?bi9GcStXK2dlcXM2SUU5ckY5MEE0ZTBGS1MzeHUzRmtDam9mWEdRb3grKzFI?=
 =?utf-8?B?UjN6TE1Iang1WVFHbjl0QVJoNGhqNTBDRHRhNURqRUlZZTdzRVBlYUZSSXhI?=
 =?utf-8?B?WjlaWUhrYTYzcW5QQUYyQU5sRHlKQUtLRk5YMUlUOGNuajRHVmxCZ05SMnJm?=
 =?utf-8?B?RnRHY3VIclN4cFpGOGF6aWswSUF5eDV0am0vcFIzclNuS2NNRG8vQVhLQ2Jr?=
 =?utf-8?B?U2xmaG5zQVE4U0RodGxjcGpycmovMTMybnRiTVNYYUpRNHlGTTRRZlVRUVdK?=
 =?utf-8?B?MHJYZFpLdmRoUHNkam5tZi9KOU8yckpMV2ZVZlNKa01xcGc3cnpEWkVBZGNm?=
 =?utf-8?B?STc1TDFVTHNxdzYxbGNKNlZ0TFREbENCM29FUlBjNU5GMjRDWmV2ZlNsRStY?=
 =?utf-8?B?K1B5d1ljQWluU1k4UlBGU3p1bHo4MW0vZU5uUnlWMTdWNVF4M2E2eTE4ZjNp?=
 =?utf-8?B?MjFtQWYwSVdFS2NGQTMzZVYvSXRlbFJJWXRkcXVINWc3VEVJWDc2ZzJVYU4y?=
 =?utf-8?Q?BEa019wXBKjsInw7P4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TytJbUZubzVTRDFVaDNwUHhKWS8vMXl1Mko2V2dhTm9PTDVTTVI5aHBSRm5k?=
 =?utf-8?B?U3IxRFVIMGlOQk90WnRlcnNyRnhISVM1SHU2K3RtdjhmL25iUGsrc25CRG9t?=
 =?utf-8?B?cVNuaWQ0bCtuYlNtWTF1UmNDQmZZRDk3V3NJNS9McHptcjVWeE1aWHk4VGNT?=
 =?utf-8?B?dHJQL1RtaHV3V0RXWktMejZNNk1pK0tIclp3NTE0UUM0WWd5RVYrcDBFSDdz?=
 =?utf-8?B?YzJjYVAyQWxIZmVmaG1uYlpUUytVa0pibkovcUtWRFo0K3VJczdob2FKc2pq?=
 =?utf-8?B?RVpEV0pWQTRNQjJNOWlFbENuQytGSElScU9mRXhhMWE0RnpVWmV0ODJucm00?=
 =?utf-8?B?ZWFHN0R6VDZIdHVkUGlFUlVXQXZic1hGS3JmenU4Q3cyS05ZdHdWR2R5dkVj?=
 =?utf-8?B?MEEvUExuemk4bFhxWHNkY3lTQnJ5V1BMemplM3lmb0hlM0JlN1FxUCtoalNG?=
 =?utf-8?B?bzArQk9GbVQwbyt0R1BucHpXK0dJLzQydlFJMXZ3TndSY09XV1F0eTFzdlhv?=
 =?utf-8?B?WitDay8vNkVIRjJpcmhsMDZlQ213OWlFWXNTWVpUc0RRU0dlcFRqcjVLNU1B?=
 =?utf-8?B?V0xsVTkvVDFjWndqb2JxellUNUxTMlpwUWJ0ZG13clZhcDc4QjhqeTJoV2hQ?=
 =?utf-8?B?K1Z3bFpNbWNKdWkxUXV0blNVWEdWYnZHdmlxMVk3Tzh1b1g1YkhocDMza291?=
 =?utf-8?B?c3B0Mm1nVGVVeUVRVDdhWENhRTFRdXA3TGZzZktNdzdyWmg1bmVkNmNISWE3?=
 =?utf-8?B?V2ltZVg4bFF1TTJMSy90bkdpZ3dYb3lma1ZWNUZrRzFseCtQMzgxNERWVlRN?=
 =?utf-8?B?QmVQSU9hYWR1MVcxK0ZtbTVVQzcxLzZQZExCOEl4SVZ1cGpiMzhtMVpTQ1Rq?=
 =?utf-8?B?VHZxK1ZQMGZhdm5CanVPTkZJbGRnM1R2TUhqS0lwL1ZFVDZicFlZc1BVZ2Vr?=
 =?utf-8?B?V00rR0lvWis0Q1MyRW1YVFV5czU5bzJqZnYvNHQxUGxLVzJZWGlYaXJ1UUUw?=
 =?utf-8?B?T1E1UnR3elJTV0J5Y0NqelJvbHdSTmVWcnlBNGdkTE85aEdXZy9GQjVyMk5i?=
 =?utf-8?B?cFdnTzM4b1lkMmo0Tm9YR1gzRXVIeENaUDRlaGFEMmVmcHhpRExqSHB6bi8x?=
 =?utf-8?B?SDlkY2VkT2F1WndQQXJaUGZ0eWxhT24vL3owWkdCZzIvbG5jNVNiWlRkdEsv?=
 =?utf-8?B?ZFhRZzN2RlkyYjJXN3VjdjMybm1qeFJKVFc5STRYcU9oMXpwSWZmZU93djhC?=
 =?utf-8?B?Z1VCNjBMcDJIUEp2c0JzU25nSVZqcmVvNDUwaExRQnlobTZEelRLd2c1ME1T?=
 =?utf-8?B?M0VydDQrRFVtdnpGK0NiMEN0ekdaYzV4bU1BbjFtN2dMcTRCRk03MExzTGVq?=
 =?utf-8?B?UGVzOURVeXdzL1hCZmc4RGIxdGlOZ1l1YzJPZFowZUxUYWkvelQ5WkZ5ZEND?=
 =?utf-8?B?ZUtpZzNrTWxBSDM1MVpWT3VHVStaZzdkZkQyQW1Xb3lHb2pUbTFXVmN4ZUZU?=
 =?utf-8?B?UzBxc3NaQkN3VzJWRGlKSytBekxzK3hrcjFoSE5wM2dYcyswNzJvbno4QzFI?=
 =?utf-8?B?UFBoUFdXUW11ZnpYZ2lQZXp2LzN4R3BPcHVtVG9yZjJkWUN3ZC82bThXYWxS?=
 =?utf-8?B?TmMvQW9lREdveng2UU1EOS9IcVZCelNKU0hFL3B4a0FlTzhidUxDUzdBVE1Z?=
 =?utf-8?B?T0tVUCtQZUY5dnRqamZCbFVYcGEyTCtrcWE0eTR6UTZqckppWFI1eS9aeENS?=
 =?utf-8?B?bjB5N0hVcWlpTVhzYUNiL1ZYTGVYL1RCMFBRRWNrZHJyRktMMzFPVGtVdlNL?=
 =?utf-8?B?ZzAxMFdONDRuZ0lUMmJmQnZLMjlUQUo2dXdIMkpBTzBRT3h2MTZJU0pkVkdz?=
 =?utf-8?B?V2c5WGZwUG9aS24vR3hTZVZqekYxWkRuNmU4eVFhV2pKWXVneG9rSXZNZFpQ?=
 =?utf-8?B?NDNNNjJJRytIaTdldG56cCtFeWV1Z3hFdTZjSDBmR3VaSVhwN3Y5OG14OEIw?=
 =?utf-8?B?OWhiYXVsWjhZQXlSWjFueW82OHZINzlhOG1CY3VHSjBnTjZiT1VZQW5UazVI?=
 =?utf-8?B?cVZYUXU0Z2VOaGNiQi94WEhxaTlSdWY0eUhjVkdZYVhxeWpSYjExaHR3bk5B?=
 =?utf-8?Q?NPPPEPuDqMClLqWvrwZVnQq/6?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c72e812-7dbf-42aa-4c54-08dcdd4a8605
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 10:12:12.7744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fa3gvbhSc5LkR5wou4HyK1j5pmE3BHBzRUkeN0IfawDkwyXEI1UmTNVKFrfonRRCDX/NjDyiHU4W5Knm7shFWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6001


On 9/20/24 23:34, Zhi Wang wrote:
> Hi folks:
>
> As promised in the LPC, here are all you need (patches, repos, guiding
> video, kernel config) to build a environment to test the vfio-cxl-core.
>
> Thanks so much for the discussions! Enjoy and see you in the next one.
>
> Background
> ==========
>
> Compute Express Link (CXL) is an open standard interconnect built upon
> industrial PCI layers to enhance the performance and efficiency of data
> centers by enabling high-speed, low-latency communication between CPUs
> and various types of devices such as accelerators, memory.
>
> It supports three key protocols: CXL.io as the control protocol, CXL.cache
> as the cache-coherent host-device data transfer protocol, and CXL.mem as
> memory expansion protocol. CXL Type 2 devices leverage the three protocols
> to seamlessly integrate with host CPUs, providing a unified and efficient
> interface for high-speed data transfer and memory sharing. This integration
> is crucial for heterogeneous computing environments where accelerators,
> such as GPUs, and other specialized processors, are used to handle
> intensive workloads.
>
> Goal
> ====
>
> Although CXL is built upon the PCI layers, passing a CXL type-2 device can
> be different than PCI devices according to CXL specification[1]:
>
> - CXL type-2 device initialization. CXL type-2 device requires an
> additional initialization sequence besides the PCI device initialization.
> CXL type-2 device initialization can be pretty complicated due to its
> hierarchy of register interfaces. Thus, a standard CXL type-2 driver
> initialization sequence provided by the kernel CXL core is used.
>
> - Create a CXL region and map it to the VM. A mapping between HPA and DPA
> (Device PA) needs to be created to access the device memory directly. HDM
> decoders in the CXL topology need to be configured level by level to
> manage the mapping. After the region is created, it needs to be mapped to
> GPA in the virtual HDM decoders configured by the VM.
>
> - CXL reset. The CXL device reset is different from the PCI device reset.
> A CXL reset sequence is introduced by the CXL spec.
>
> - Emulating CXL DVSECs. CXL spec defines a set of DVSECs registers in the
> configuration for device enumeration and device control. (E.g. if a device
> is capable of CXL.mem CXL.cache, enable/disable capability) They are owned
> by the kernel CXL core, and the VM can not modify them.
>
> - Emulate CXL MMIO registers. CXL spec defines a set of CXL MMIO registers
> that can sit in a PCI BAR. The location of register groups sit in the PCI
> BAR is indicated by the register locator in the CXL DVSECs. They are also
> owned by the kernel CXL core. Some of them need to be emulated.
>
> Design
> ======
>
> To achieve the purpose above, the vfio-cxl-core is introduced to host the
> common routines that variant driver requires for device passthrough.
> Similar with the vfio-pci-core, the vfio-cxl-core provides common
> routines of vfio_device_ops for the variant driver to hook and perform the
> CXL routines behind it.
>
> Besides, several extra APIs are introduced for the variant driver to
> provide the necessary information the kernel CXL core to initialize
> the CXL device. E.g., Device DPA.
>
> CXL is built upon the PCI layers but with differences. Thus, the
> vfio-pci-core is aimed to be re-used as much as possible with the
> awareness of operating on a CXL device.
>
> A new VFIO device region is introduced to expose the CXL region to the
> userspace. A new CXL VFIO device cap has also been introduced to convey
> the necessary CXL device information to the userspace.



Hi Zhi,


As you know, I was confused with this work but after looking at the 
patchset and thinking about all this, it makes sense now. FWIW, the most 
confusing point was to use the CXL core inside the VM for creating the 
region what implies commits to the CXL root switch/complex and any other 
switch in the path. I realize now it will happen but on emulated 
hardware with no implication to the real one, which was updated with any 
necessary change like those commits by the vfio cxl code in the host (L1 
VM in your tests).


The only problem I can see with this approach is the CXL initialization 
is left unconditionally to the hypervisor. I guess most of the time will 
be fine, but the driver could not be mapping/using the whole CXL mem 
always.  I know this could be awkward, but possible depending on the 
device state unrelated to CXL itself. In other words, this approach 
assumes beforehand something which could not be true. What I had in mind 
was to have VM exits for any action on CXL configuration on behalf of 
that device/driver inside the device.


This is all more problematic with CXL.cache, and I think the same 
approach can not be followed. I'm writing a document trying to share all 
my concerns about CXL.cache and DMA/IOMMU mappings, and I will cover 
this for sure. As a quick note, while DMA/IOMMU has no limitations 
regarding the amount of memory to use, it is unlikely the same can be 
done due to scarce host snoop cache resources, therefore the CXL.cache 
mappings will likely need to be explicitly done by the driver and 
approved by the CXL core (along with DMA/IOMMU), and for a driver inside 
a VM that implies VM exits.


Thanks.

Alejandro.

> Patches
> =======
>
> The patches are based on the cxl-type2 support RFCv2 patchset[2]. Will
> rebase them to V3 once the cxl-type2 support v3 patch review is done.
>
> PATCH 1-3: Expose the necessary routines required by vfio-cxl.
>
> PATCH 4: Introduce the preludes of vfio-cxl, including CXL device
> initialization, CXL region creation.
>
> PATCH 5: Expose the CXL region to the userspace.
>
> PATCH 6-7: Prepare to emulate the HDM decoder registers.
>
> PATCH 8: Emulate the HDM decoder registers.
>
> PATCH 9: Tweak vfio-cxl to be aware of working on a CXL device.
>
> PATCH 10: Tell vfio-pci-core to emulate CXL DVSECs.
>
> PATCH 11: Expose the CXL device information that userspace needs.
>
> PATCH 12: An example variant driver to demonstrate the usage of
> vfio-cxl-core from the perspective of the VFIO variant driver.
>
> PATCH 13: A workaround needs suggestions.
>
> Test
> ====
>
> To test the patches and hack around, a virtual passthrough with nested
> virtualization approach is used.
>
> The host QEMU emulates a CXL type-2 accel device based on Ira's patches
> with the changes to emulate HDM decoders.
>
> While running the vfio-cxl in the L1 guest, an example VFIO variant
> driver is used to attach with the QEMU CXL access device.
>
> The L2 guest can be booted via the QEMU with the vfio-cxl support in the
> VFIOStub.
>
> In the L2 guest, a dummy CXL device driver is provided to attach to the
> virtual pass-thru device.
>
> The dummy CXL type-2 device driver can successfully be loaded with the
> kernel cxl core type2 support, create CXL region by requesting the CXL
> core to allocate HPA and DPA and configure the HDM decoders.
>
> To make sure everyone can test the patches, the kernel config of L1 and
> L2 are provided in the repos, the required kernel command params and
> qemu command line can be found from the demostration video.[5]
>
> Repos
> =====
>
> QEMU host: https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-host
> L1 Kernel: https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l1-kernel-rfc
> L1 QEMU: https://github.com/zhiwang-nvidia/qemu/tree/zhi/vfio-cxl-qemu-l1-rfc
> L2 Kernel: https://github.com/zhiwang-nvidia/linux/tree/zhi/vfio-cxl-l2
>
> [1] https://computeexpresslink.org/cxl-specification/
> [2] https://lore.kernel.org/netdev/20240715172835.24757-1-alejandro.lucero-palau@amd.com/T/
> [3] https://patchew.org/QEMU/20230517-rfc-type2-dev-v1-0-6eb2e470981b@intel.com/
> [4] https://youtu.be/zlk_ecX9bxs?si=hc8P58AdhGXff3Q7
>
> Feedback expected
> =================
>
> - Archtiecture level between vfio-pci-core and vfio-cxl-core.
> - Variant driver requirements from more hardware vendors.
> - vfio-cxl-core UABI to QEMU.
>
> Moving foward
> =============
>
> - Rebase the patches on top of Alejandro's PATCH v3.
> - Get Ira's type-2 emulated device patch into upstream as CXL folks and RH
>    folks both came to talk and expect this. I had a chat with Ira and he
>    expected me to take it over. Will start a discussion in the CXL discord
>    group for the desgin of V1.
> - Sparse map in vfio-cxl-core.
>
> Known issues
> ============
>
> - Teardown path. Missing teardown paths have been implements in Alejandor's
>    PATCH v3. It should be solved after the rebase.
>
> - Powerdown L1 guest instead of reboot it. The QEMU reset handler is missing
>    in the Ira's patch. When rebooting L1, many CXL registers are not reset.
>    This will be addressed in the formal review of emulated CXL type-2 device
>    support.
>
> Zhi Wang (13):
>    cxl: allow a type-2 device not to have memory device registers
>    cxl: introduce cxl_get_hdm_info()
>    cxl: introduce cxl_find_comp_reglock_offset()
>    vfio: introduce vfio-cxl core preludes
>    vfio/cxl: expose CXL region to the usersapce via a new VFIO device
>      region
>    vfio/pci: expose vfio_pci_rw()
>    vfio/cxl: introduce vfio_cxl_core_{read, write}()
>    vfio/cxl: emulate HDM decoder registers
>    vfio/pci: introduce CXL device awareness
>    vfio/pci: emulate CXL DVSEC registers in the configuration space
>    vfio/cxl: introduce VFIO CXL device cap
>    vfio/cxl: VFIO variant driver for QEMU CXL accel device
>    vfio/cxl: workaround: don't take resource region when cxl is enabled.
>
>   drivers/cxl/core/pci.c              |  28 ++
>   drivers/cxl/core/regs.c             |  22 +
>   drivers/cxl/cxl.h                   |   1 +
>   drivers/cxl/cxlpci.h                |   3 +
>   drivers/cxl/pci.c                   |  14 +-
>   drivers/vfio/pci/Kconfig            |   6 +
>   drivers/vfio/pci/Makefile           |   5 +
>   drivers/vfio/pci/cxl-accel/Kconfig  |   6 +
>   drivers/vfio/pci/cxl-accel/Makefile |   3 +
>   drivers/vfio/pci/cxl-accel/main.c   | 116 +++++
>   drivers/vfio/pci/vfio_cxl_core.c    | 647 ++++++++++++++++++++++++++++
>   drivers/vfio/pci/vfio_pci_config.c  |  10 +
>   drivers/vfio/pci/vfio_pci_core.c    |  79 +++-
>   drivers/vfio/pci/vfio_pci_rdwr.c    |   8 +-
>   include/linux/cxl_accel_mem.h       |   3 +
>   include/linux/cxl_accel_pci.h       |   6 +
>   include/linux/vfio_pci_core.h       |  53 +++
>   include/uapi/linux/vfio.h           |  14 +
>   18 files changed, 992 insertions(+), 32 deletions(-)
>   create mode 100644 drivers/vfio/pci/cxl-accel/Kconfig
>   create mode 100644 drivers/vfio/pci/cxl-accel/Makefile
>   create mode 100644 drivers/vfio/pci/cxl-accel/main.c
>   create mode 100644 drivers/vfio/pci/vfio_cxl_core.c
>

