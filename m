Return-Path: <kvm+bounces-27333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4823498400F
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 10:12:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A3371C21B94
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 08:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8A614E2CC;
	Tue, 24 Sep 2024 08:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kqTnFsLQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC7414B084;
	Tue, 24 Sep 2024 08:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727165528; cv=fail; b=YyXp8alOUe4NrcrXQ7odb3rspv1Q8HLJHHkJd0pLN8fetWLeasMFLkgUdr8y3J/NtHaExN4LEKuOzdlIeezmPyQyclMTGfj8YlhjTl0zH3s7+BjVR04hzlVewhA7LeC4HThjJ9/D8yu5vf3Y2mP2DJe4XIIRLxuCtsA3vfhCN8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727165528; c=relaxed/simple;
	bh=VMEYgPxc7t64wSQtdis2YyYGZw2UpqgmEA7akPQ7W/g=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NvpM1d5xVW5uwdbjVMa7mq2GvYfMFOO4QEMwqRSFvQ2ITZDHnKPheafK52scrTTU/YzcwI29TFkZLA+uNyftYZSWFZMQ/V8NXoTk6W3CMxIh1Bwia5Vpaf8Li5QLdMC/NUfrAJrq9bgMuO8wDZ/R1/WfjHHW3yYA98xY81OBhXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kqTnFsLQ; arc=fail smtp.client-ip=40.107.244.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Atz+HGi1a1DkxEwtdSu5iH2DOQgPbInyVYhNee92vkImWyboigyMaqTW+9ABbMlfPTAaS9Gp2hjyP14LBL5JRffeq9FG2UnfagezU1NeaUA25s7um3JdRLNOM4NxtcQeNWrPbIfw7TL5c+AkWgg8O8b0zC+N2+EDfPxoNQyGF7diEaFeFG/yftBavgDMzA5tLa1BIMISdsHL3KkAX1cbVVGq8Q6UJm7daG+UaOlh773kfWvKRCmvc0/2RBQuzvqYDFRBYaUY7hPAnw91vkYoQGob3eXAULXkqyXxorUYxqekX2jJr9aRtlbJ+k5SDoAiIMvqM3fywyzQQm7ToXqp2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t1mGhWDFdk6dTlK9+sWQkvs02aEtocvOOi9ru9WDWQ8=;
 b=RLUuLr0b6rhEkUsE0r/n38eNjdlYUMTB3aXREMrUpn+6eKErNiV89NN7C8l7ZXhj19dPNIOHab+Zzht6Of7k75ONtylZrdut0gJW1Ls/uH45fj+C2XXzFXkMeJzNWQCXs0M0Jwd+IKa/W1D6jWqOlrpUJHgwrpJ9eodAyhDf7DEjEfzO0WbRGw3lNZhf/RJbIjm51zhf8kOYpZEX+bI/4atN4iNom3FFHAwTMCAmB5Vo/gUI+RBB7lK4NbbV10TYWybt5AkYiK2alydPAW6ugh4vwFbHQ88l9oznWrhSPlz571F1iy1d+3vePCjU0eHHDga0ku8mCyXWRvW9qhBxMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1mGhWDFdk6dTlK9+sWQkvs02aEtocvOOi9ru9WDWQ8=;
 b=kqTnFsLQtJQchKa/+or1iHjqAsHeFUY4VtqOIWdfEMcu8PqKs8NPiKre8/v0VYmXO8colsFGqc+kA+LPKmbd9h5hmsRcosbfcX7m1tVLCpgVwr8bik4UoGsrXDFht/MM1ZCn5EvWgbdxuU34hHGTuSz0Qx8PssMlkuYKVj0z/g2/LYeD/PaEaPeyFYROaojRImY1Tfw/Y/zf3ublZPp2Av1PmW22GU4GflIjzqXpbyU93eervIJ9MmNn1aMjVGKB3ot593Pv+ieOaYHho4I81UljFA5yqY8sVx+XJFyErPA3cpmtv2/YuFXXbZUsbmAsZRxUmgandkgosrglEyzx+g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by SJ2PR12MB8062.namprd12.prod.outlook.com (2603:10b6:a03:4c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.28; Tue, 24 Sep
 2024 08:12:02 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 08:12:02 +0000
Message-ID: <125d22ff-fa81-490c-94bf-c7b10394f922@nvidia.com>
Date: Tue, 24 Sep 2024 11:11:55 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
To: Francesco Lavra <francescolavra.fl@gmail.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, stefanha@redhat.com,
 virtualization@lists.linux.dev, mst@redhat.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
 <CGME20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a@eucas1p1.samsung.com>
 <fb28ea61-4e94-498e-9caa-c8b7786d437a@samsung.com>
 <b2408b1b-67e7-4935-83b4-1a2850e07374@nvidia.com>
 <5e051c18-bd96-4543-abeb-4ed245f16f9e@samsung.com>
 <17b866cb-c892-4ebd-bfb9-c97b3b95d67f@nvidia.com>
 <f786e134a018004820fd147053e4eae722a6004f.camel@gmail.com>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <f786e134a018004820fd147053e4eae722a6004f.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0209.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::29) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|SJ2PR12MB8062:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f012fc9-9170-465e-3f15-08dcdc7091a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eHNSeWZVYUozUUNEQ2hXaSs0cU1TRUZIUU1yUjRPZWd1U3ZUSmJvSUNZV05r?=
 =?utf-8?B?M0MreGM1ZXlWblVLS1prTnhXUVlVQ0d2eTk3TXVWY1RJMjA1ckRUcmNLWDN4?=
 =?utf-8?B?THdjS3krMWlma1RTdkJkdDNZOC9Kc1dueSt4WFcyZ29pbEJFRjYrUVRjYk1k?=
 =?utf-8?B?OEVaRXliRStIN1ZRN2FiZ1ZqZDdSaFZKbURmeEVWOEtiUW9PRU1IckIrdTIr?=
 =?utf-8?B?SDk2OFZuVkh4SzJjVDRldEU1UHhVdWZEZTN4ZmVoWjY5Vk5XZStYWlhnV1gw?=
 =?utf-8?B?cURTWmRNaUwyOXpmalFBbEx4Uzk4RW0yKzFrdVNlaFNKVG1hNDdVOWRYeWJG?=
 =?utf-8?B?dDBZa3lSdlZaUzVHMXdVY3pEeGJYTHllZlNFTCtFaHlQUUdGUkVzOFJWNlB1?=
 =?utf-8?B?NnFMLy8yTjA5WWRRL3RUaHdNYzR6VjAyZ2UwUG82eDdyOEdLM2Q4TGg2MFJV?=
 =?utf-8?B?clhVMEFkaGpVSXllR0pqTXFxN21nRVNmbm9Vc1BpOFRQYm0zNDJQZjMrV0Vu?=
 =?utf-8?B?ZVh6eVkyeE03WEhYUDBlN00weFJVdlNZYWRQYUp3N1VqZ3AvZlE3bzE4emJL?=
 =?utf-8?B?bmluNWUyNFJnMStFNXV5cndlRzJHRDExelRNK25iWGtBVzk0MkpvOElUMzNq?=
 =?utf-8?B?V2NuaDVBeDJDYXVNREtzSyttTDhRL21kMkNmemFtaXJXbnFVNFZRblpock9u?=
 =?utf-8?B?QmlZUjNZU0lsdmVPKzNjY1U2UVowVzI1VlFiKzRoZXNxQ25aWVpWVmhFYXo3?=
 =?utf-8?B?WEg5blZoczBzbHdVUFhkWkczTnh2VllCczB5VzRDQlpQVW1PSTB2NjcvMFBy?=
 =?utf-8?B?SmNma3owSmQ1VEFmUnhNaHBWVnlkZGxkdzNyVGNGVWxmMjZZTE5CaUZmSDdl?=
 =?utf-8?B?alo2eEZNSC95dXRXMFVPV29HekhSVk54cDFTR1FaWmV1ekNXUVRqV3VsWXpy?=
 =?utf-8?B?UFBPRlJIYUh0ZlJSWUxaRS9CdHh6MHp2ak1tVjFtTWIvWXBmdkM4b3BoVk5Y?=
 =?utf-8?B?L3ZiNVRaYUNqYzNUUWdIaGVFZU9VRTFKMDRUZUlnRGI4Yk9NWU9IZnRicy9I?=
 =?utf-8?B?d2tRS1NrZEpuTU55YWN4TVV4ZUIyZlpURTNpMXdUdXZNckdpWVIveitLOVZx?=
 =?utf-8?B?MklqOVlrenpXVEZPTWllNXdoc2t6b3hkOWx5bkRFY0w0Wm5FZDF6a29zcjVk?=
 =?utf-8?B?dzRBRVRZMXRlQ0RvQi9xZVhXbVhrZXZmUTZFRXBxVlRNd0FJcmxQYWQ5OE0x?=
 =?utf-8?B?eVFLZC8zQ0F5WUZWRGIwWXBwQkE3aVRhZUM0WUsrZ01TU3d3SXVOMGgvcDRQ?=
 =?utf-8?B?cVYvcVo0T2EwTnQwc1pUYWY0ZHo2NjRCc2U2NUxXR0FXT0VGOUFFR2tBWm9k?=
 =?utf-8?B?OElwcjJqaENHTDc2Y2VzSGZBUWFEKy9YRG1vYmhWaTFzd2k4TTNVSlRMVGtN?=
 =?utf-8?B?K3hQekUyaW9peVJWcWhGMTdsSzFmMnhNcTRiOS9JSURUeTl2OXR3WVZuS1R0?=
 =?utf-8?B?bkNJRmhybnpmOHRTNkYwUTFVNFJmbnU5ZE1nQ2E3d0J3cEdzZzhUckZ4UWR3?=
 =?utf-8?B?NVdaY05IMi8wNHlZZjhLOFhwTnZhL1c4RFBhYkhtYldBTVZuaDVQcE5mVWhn?=
 =?utf-8?B?emdtMHRuS0FoT2lhb3FKNnNKV0oxSlE5SlhieEI1QTFDdFVsM3BrOGhsemZI?=
 =?utf-8?B?RjZiWThCQnMwQnNsRjJOSjhYSXRUWFVJbGhiT2p1dEswMS9odXlTVG1BPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXJwbnNQVVFBdTBCcGFqYVFGNTVMcUpxR3g2NllobDViTUNFQmJjeGZSTjJM?=
 =?utf-8?B?dkwyZTFUM3l1Vk1RU2o5M0xvOGNablRNNVdCL1NnU3Z4RnAzYnJ4cCtiUnZk?=
 =?utf-8?B?YjE5K1JIREF6dnVRU3VCQVV2eG01R1l3WkhHMG9hemIwTkpjbVlqNU92ZVNh?=
 =?utf-8?B?M2IvdXR4ekl5Nk1VTmNLZXNzKzZkQmZxUHRXeHpMOFJFUTZLWi83Z2ZSMTU0?=
 =?utf-8?B?dUxhRWZXTU8zcHNLTVNDS1VsTjRTNkNQWURuS0V3bjh6TVYrV09LbUFHY2Mw?=
 =?utf-8?B?bUlMZ21WRWE3ZER0S1BQWDVqWGZoYkNUemw1K3Nxd3NHSzU0TVo3VHltU1pi?=
 =?utf-8?B?VlVVTUlXbml3ZzVpY2xrSTBjZkZ4M2wvMCtwREQrTGZTTCtBVGFFWlVvRGpm?=
 =?utf-8?B?WmljM0lQOGt6bGpURlJVOTJRWCtzQTkycXc5dk9XQjNSQUpmVmF6dDRIdk1O?=
 =?utf-8?B?NXVQMjJBQU81ZWNmZ1NTUkovdFJmaDZPMS8xcHhCdTRFbTZhWGR2U3NheVlo?=
 =?utf-8?B?cU5DT3FPMjdqU3ZiR2RHOWtqZk5oOEppMndoY1BmdHFFd0I5WExmK3kyV3Zm?=
 =?utf-8?B?RkNZd0dHei9PNXRSWEVzdjAzSWFGT0l2bjUwYnoveDJJZnhiWnZ5UkRBM3Zl?=
 =?utf-8?B?VlNsZUtsaE1MR3d5U3NBQXpxUmc2MlVZcUlJSU44Z2VmRXRIZkFpSSt5ZWRM?=
 =?utf-8?B?U09Wcjk3S0JSNkNPOWdKWTdwM0xCYVljYTNIbXduckZaQ0lzaGhHeVdFWkJX?=
 =?utf-8?B?bGpUbTNQWG1PdWI5NnBQTjBtUkFDTzk4dkZLbDNBS1lHWXhvTnM5MEZsWlU2?=
 =?utf-8?B?b3AvWnN0R0poQlJlSm5MZUVqU3Z3ZGtLQmwzaThvcW5BRTRhQmk0WUpuWVRp?=
 =?utf-8?B?SENBTzFJbzNTamg1MWhoRk1rVGh3dHBRWS9hVHdnbzh4Rkt3ODg4aWxzWU5k?=
 =?utf-8?B?MlB2RTRuSmNnRm5oTkRDTkhnNDM1RTBVY2EvemM5eUNIVHhuaTRCc0JBTWV2?=
 =?utf-8?B?NUNRNWtBdWl0dkN0eW04MngwcUpNQm5jMXp2WE93dHpLb2E1M0FoWWUyMkxG?=
 =?utf-8?B?U1U5OXRST3lMRDNtUVBITTUyZkN3bDdHT05wS0Ewd29FVE9vQWlOUisraWFl?=
 =?utf-8?B?YndLaG9TbDIwN0hEWTRFemt3RU40NE1STGJjMFFCUGtUeCtOZVptMXQ2ejZU?=
 =?utf-8?B?dFJsWXpnMXRKV3IwREhUVlRWT1lLU1NlbHMxY2J4b2M5R1BaMDhybXZnN1hj?=
 =?utf-8?B?OTdRTVdpMjNGa1pLeEpxRGRiYTQ4azJUaUdTd21hdHhxWmZZRWFKdmxvTDJk?=
 =?utf-8?B?WURZZytubmR5YU5KMm04U1JKRm9aaUFLWlZJb0VKVzNtMUEvdm9XMVpFbTBN?=
 =?utf-8?B?Rk9RSXZmcDZqREVFV2tkeW9ZNUVJUEFlZEtONHpDTktoMyt4WHZZMXpUTVRC?=
 =?utf-8?B?KzFKV1dneGN0NGlMakxyeFJianBxUkVTWWUxV05EUkF5amI1NjQvSzk1RTNs?=
 =?utf-8?B?Rnp3bmtsVktodXZIL3d3RVNDUHBrd0IwT3RUNEdlZWdBSm1pNnJ4emg5UHRl?=
 =?utf-8?B?Ni81OUtqVUk2OFdCOW4vc0dBb29XWDlwTUxzVlM2T3U2L0M5ZFAvTFJPM1F2?=
 =?utf-8?B?bHA5YXN2M3VERnpVU2pMSUI2T1Y2UkpsR2xpTEpDZ3pjU0d2TTd5MlF0UWZm?=
 =?utf-8?B?aWJiRUZsTUNBYitxZXZLQWRmUy85T2F1NFpBaW1xNCt6dVJUSm1KUGVOQ0Nv?=
 =?utf-8?B?VGcyRy9SYXdjb0ZSQzJvV3NWb2lUL1gvNmdWeW1FN094ZzNCKzhYSHlLdUdT?=
 =?utf-8?B?aXEwMkpoRHhLSnBkb0x5ZlhkOTdycUhyd093MkJHazJKRCtVU0U5VWVNMlk2?=
 =?utf-8?B?azMvc0lSUXFHeXVQeHdpQ3UxR0Z4ZHpwYllzQldsVWVwRWhtcWU2djlyOGIv?=
 =?utf-8?B?RURNbllZTTAvN2JpS3pSRThwbDk2OHY3bEVDTFh2aHcwTHNuUmIwWDAzZ3h1?=
 =?utf-8?B?eWg5bmVaeUFZWm1kbGxVQXFIQ1Z1R05DM1puY2RVNDJUcnNrY2IxQXJGaEEv?=
 =?utf-8?B?NHl6aWo0WGZQL1ErSXk5bzVxbTFPR1NjVnYyNGtqUnpaYjJ0UTA2dW90ekw0?=
 =?utf-8?Q?JGauVIPlI9IbrrHqpU8SiQpGR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f012fc9-9170-465e-3f15-08dcdc7091a0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 08:12:01.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7VrTtLsjtC2FbFQf2C3Hk6TQMU24mBJAflbPfxDsUoduJ9nzz/6kQJ16iwCGdxxx3wxqUB01EwlXe5F1yPEmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8062


On 24/09/2024 11:06, Francesco Lavra wrote:
> On Mon, 2024-09-23 at 01:47 +0300, Max Gurtovoy wrote:
>> On 17/09/2024 17:09, Marek Szyprowski wrote:
>>> Hi Max,
>>>
>>> On 17.09.2024 00:06, Max Gurtovoy wrote:
>>>> On 12/09/2024 9:46, Marek Szyprowski wrote:
>>>>> Dear All,
>>>>>
>>>>> On 08.08.2024 00:41, Max Gurtovoy wrote:
>>>>>> Set the driver data of the hardware context (hctx) to point
>>>>>> directly to
>>>>>> the virtio block queue. This cleanup improves code
>>>>>> readability and
>>>>>> reduces the number of dereferences in the fast path.
>>>>>>
>>>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>>>> ---
>>>>>>      drivers/block/virtio_blk.c | 42
>>>>>> ++++++++++++++++++++------------------
>>>>>>      1 file changed, 22 insertions(+), 20 deletions(-)
>>>>> This patch landed in recent linux-next as commit 8d04556131c1
>>>>> ("virtio_blk: implement init_hctx MQ operation"). In my tests I
>>>>> found
>>>>> that it introduces a regression in system suspend/resume
>>>>> operation. From
>>>>> time to time system crashes during suspend/resume cycle.
>>>>> Reverting this
>>>>> patch on top of next-20240911 fixes this problem.
>>>> Could you please provide a detailed explanation of the system
>>>> suspend/resume operation and the specific testing methodology
>>>> employed?
>>> In my tests I just call the 'rtcwake -s10 -mmem' command many times
>>> in a
>>> loop. I use standard Debian image under QEMU/ARM64. Nothing really
>>> special.
>> I run this test on my bare metal x86 server in a loop with fio in the
>> background.
>>
>> The test passed.
> If your kernel is running on bare metal, it's not using the virtio_blk
> driver, is it?

It is using virtio_blk driver.
I'm using NVIDIA BlueField-3 Virtio-blk device.



