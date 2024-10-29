Return-Path: <kvm+bounces-29924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A67179B4177
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 05:05:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 357711F2196D
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 04:05:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA7A200B96;
	Tue, 29 Oct 2024 04:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BcHCYhT+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E879E1DFE3D;
	Tue, 29 Oct 2024 04:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730174712; cv=fail; b=bQFBVvbD8aWowZP1W3xg9XDlcIEL4CzMziOIlTHQNOqryBzLaK91+8j0al2YD6KTRZf6ANfhqaY+UOnLFACdji2Rnrgx2fc7qgE7GYrxzaiqK3KDLypQ6qym3Ak13LpgddYrSAbCq2SirytFxEgaAd5+J97jgwlUqummY7AM/no=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730174712; c=relaxed/simple;
	bh=feD/vPIxxgsDki/lZmDx8D/Sm6bkdCMCchGcX3sWk8Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nhD0vJulTVUm1dToeurd3KrcsTz9vPYavm2F9JTJHNSJVfe/20get6N8m/MwMQpLIgu1oNkmwyHh5BnbFY81TIqAbN2LE1ThPI1C8CXvoaI6vWBS4t4lha/FMoBqmuHdcbY0tzpHAnFDXsXiGEtp5g3RgsWCkNRjmSMEEQp0h0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BcHCYhT+; arc=fail smtp.client-ip=40.107.93.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSOD1sAO8x53ORI2NvK5atAytEXfo1ZscpT/wTX5R0BHMs4RcT44f78BlbQJG+K8S0EYvqQBPBbz8wzXws25c/pComkDyKh91xrf5gCVKC69E0Don40tKNNUZ0FtnlZgz9ejv7U+zsT5fW/kb8RKkP7rA+z/4SGu0hFPdU3w80A4TIqVolaxoapg6bioJYM0FI5Lm8sD1Qo9fx6Kfws5XCQJPfjGEOHBf3NANXk93KjDnyDp7cGlUlDP+0SLJX+DkudAQcsASMRiwkZmC8ei7yZ75T9TyKlwS3hN1Ka2vfvQqy8fFywNywv4kkL5zilWuCWccXC0OPo74Oe0kke05g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jpPSpqH4zJeY5ssVH8XTh5jf/PRzxs0j/FNwqYEVBE=;
 b=w2fXIfsqXMn8kZvC1TPuLynJIf09s/88hd4mZegYYy3J77Zi8bhP0qXlTw7ulpOP4yH2PBWObNMQA4YS3q8uUznKdF+ZpJNn5yoH2gA8d3+El0p7qHB+w9gRpcHBAlV6llYNLiEMBMJQ6A2nvXrSHULL5UNIyv4Q4atTUW/Mxa6JOTU0U7YIglDQLw9xVyrXIwGRPJnK/XLu3HZ0uxkbrfe/9pGbnXwR6bP9FO53WMr3eF6ZHqvkrDCjET4cNiNfuB5gDlh5S422DsxPH1JTUDJYPISi8/vblU+8PjBV5vDPBgvglN5aAmAtMRhBszH2bukB+A27BaoiYWs+hXKXEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jpPSpqH4zJeY5ssVH8XTh5jf/PRzxs0j/FNwqYEVBE=;
 b=BcHCYhT+xzMHHnQv5QzMIcfVgRYa8l7mtOYUH5NwElmizaw5ruN4BLBqE4Dj/GnvwiTne+JBFY6IljzqGy90VUse/o36PNTmlOsMkB8VhT8y99paMPB1beOfwwuu0f0VY4BlkeeUrfp3P5TrrbygIAxWC4uXVdWTJHeZvGmtjvg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN0PR12MB5715.namprd12.prod.outlook.com (2603:10b6:208:372::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Tue, 29 Oct
 2024 04:05:08 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8093.024; Tue, 29 Oct 2024
 04:05:08 +0000
Message-ID: <714ab7a2-69fa-b08d-deae-6eb91ecba95b@amd.com>
Date: Tue, 29 Oct 2024 09:34:58 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH 0/2] KVM: kvm-coco-queue: Support protected TSC
To: Marcelo Tosatti <mtosatti@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
 pbonzini@redhat.com, Sean Christopherson <seanjc@google.com>,
 chao.gao@intel.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com,
 linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
 Tom Lendacky <thomas.lendacky@amd.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
 <c4df36dc-9924-e166-ec8b-ee48e4f6833e@amd.com> <ZxvGPZDQmqmoT0Sj@tpad>
 <81e6604b-fa84-4b74-b9e6-2a37e8076fd7@intel.com> <Zx+/Dl0F73GUrzI2@tpad>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Zx+/Dl0F73GUrzI2@tpad>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0204.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::14) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN0PR12MB5715:EE_
X-MS-Office365-Filtering-Correlation-Id: 601ea5bf-0557-4a44-a2ef-08dcf7cee066
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d1lZYUg3MjVXclF0QlB2eW94cVpGSlZDWGZPUE0xQmhYcHpUVlJ1WHVkMVNk?=
 =?utf-8?B?cGljRkRVNDNCTnNxOEJPWHlraTJhUFFzeXczU3VhcHVnMDRtdUNWaEVueGM0?=
 =?utf-8?B?a0Mrd0ljejlKdlRNWTc1ajVueC9wdkxLWHR1S1BmeTRwSzBVd09wWWRxVHQv?=
 =?utf-8?B?RXhVN0lBRTBLR2hvUys0bnR5V1p4ZkFuRWJUM0NnY1V6Y2YyeW1jVUJuM1BC?=
 =?utf-8?B?VnFZMUpTZlp6ZmViMHZVRUZ4QnppNnh2cG9JZVhoSHdkS1RqSEplb1FBMXhj?=
 =?utf-8?B?NmdDZlNMa28xVWpQVXYrd1RYUXV0eG81R3d1RnNIVkVTRlF5REZwcHhuRTZw?=
 =?utf-8?B?NC9QaEdiSzI3WmM3b0dWeElaMWlJWEc0V0dXc201SkJDMlVMVi9ZNzRVVmpN?=
 =?utf-8?B?WkJ3VzU5ZW1QZFB1eHA3R1BNdmdJSjVETzVvTm82WEprSW9UUlZpWnBjVlBK?=
 =?utf-8?B?eThZeWdkYktHa2NRSnJxVDBUM3NGaXdwcHdaaXJXU1VQMndDMHR3OUE2TU1u?=
 =?utf-8?B?NlhZRXdPeDhZUmxCUGUwcGcxZUxvbzJlcFlRaXI2VkdkdnB6M3dsc3Z2QVN2?=
 =?utf-8?B?UDViR0tUYkVUbVNQLzhUV2tWSE9aTDZQc0lzai9Hd0hrNkU1aVhLMG5KRmlu?=
 =?utf-8?B?bm1xR2FDVjdDVTg4eFFDajlhNjRHNFU5RG5mZUxpYTN3bmlkR1Rwd2QrNE4r?=
 =?utf-8?B?RFYrRlR4VU9pMXZqVVpmSVBlejg3T0kwVG1HV3hZWFVoRm1ibjVHaWg5eWNo?=
 =?utf-8?B?S0VhSjZGZ2JpSjJZaHo0bU5kc1RDU2RpTkhmTndYSWdudXUrcHlLNGJ5NDdK?=
 =?utf-8?B?L3JoWWhlM0lEajhzRVE2UGhhdnBka3V4MUx6UjJSd01xUm1HTU9iaksvV2ZF?=
 =?utf-8?B?bjd2UXEvRy9VRStXOFhJejVDRlJONDQzazJPRHFibzEySmdOdW9zZTZCRGxO?=
 =?utf-8?B?MC9EMTJ0S1pkdnhhVzU0Q1pEbnBVa0psZVVocFFEYnZid1lTNE5FYzYrSW5T?=
 =?utf-8?B?TmxCWTNrdVU2ZjNCQ2ZPcjY1bTZ5NFl1a2QrTEI0bHNTMnlSZHFyejlidzA1?=
 =?utf-8?B?c0xML1R0SFpxNWFaQUd4RXlBdGcrV1UrSG5uTUlRT0ttNlZnZm1VcDhIUmhK?=
 =?utf-8?B?ODJ4K05lZU1UeEd2aytBZnRFd0hrUXI5K3huc0NLNVd6SkYrYWxTQXRsVlJx?=
 =?utf-8?B?YzNqa2lubnFTc1VKMUNUTEUxeWxsODB1dG1rUlZLTllxbjQvdEpFbE9wNVpz?=
 =?utf-8?B?a1hkL0xzdFRPZVpqYTM0S1FYSlBYQ0hKVnRveXRORVYzN0RMdzNrRXJkWDVW?=
 =?utf-8?B?d2NQQW1OTFI5ZjBMRFRYNnZTTmxjK3JwWEU1eG5iUnY2bDl4MW9YSmRyeEw4?=
 =?utf-8?B?WXNFUGhwQzJkSmdhMklhY1Y4WDNuNXVzSm03VHhrSjFkQlpXUEYwYjVCM251?=
 =?utf-8?B?SWZWTnpremhHQWRmQTQrancyaHVvK3FLTC9qQkMzczluMkt5K3duc2ZNdnE5?=
 =?utf-8?B?YjV3eW9rWERhRjBIMm1aZjhEY21jRXpQY3Zrc0hOLytvd1RFTnozTFUycGEw?=
 =?utf-8?B?SUdvSHJOcS8vTUs2d1dHbFNJQ1lqMFA3L2l5amtZZGVrbER1OUhzSlNzcmRH?=
 =?utf-8?B?aWV1SkduYXpOa2hldXJJcmlpMGYvaXhXemdwazVCdUgxb0VtRnpDMS9ZeldJ?=
 =?utf-8?B?WWZReXpVQ3FnUnZlK2dncWdTUWpPZHBPejBzZUQ2RU9KdDJtK1hOa25yZVcx?=
 =?utf-8?Q?JICoJ3xKR+XBI9pAuWdiIny4zBqfXtsPagkxbud?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VXRFdjRoc2c3ck4xSlZLM2dLN1ZrNi9BNHQ4bFJiVFU5cHpvbFVqTmJuc2tR?=
 =?utf-8?B?cDRRTDRoaldYRUNNM1ZwV3ZmTGJxbG05RzliWjVjbzRuRkRtam1FOHZCam1m?=
 =?utf-8?B?WUpzUDVUM2FTa0paaGdwelhOaXlBc1VtajA2TE5pOUlwVDBNR0hhbzR0ekdO?=
 =?utf-8?B?c1pGNyswN3doZDFEeW9nN3BVODBKekdNRTU3N0NGUncwZWxuZVlnbkgxNG5k?=
 =?utf-8?B?TWJwUk95UEZzUU15SmVjSFR5SFBQKzVSOTd1SGhBN3JFYk1pRHV6K28zTEt5?=
 =?utf-8?B?TEdTNG1SUmdkaFpSNjN0cHd4RktpenU3bFcyTFhlaWtNanRKMklqY29UWGtR?=
 =?utf-8?B?S3A2RWw2RUwxRUlUMjRQMXN6d0NvQ05YSldya2lKb2hIL0ZTbFdIYTVMSW53?=
 =?utf-8?B?ME0ydDQ1U2M3eEFWVnA0bVlQNkRQRmlMaFZIZjBmd1pTdWwxeUQzbW1Ebzcv?=
 =?utf-8?B?Ti9kMnp1TklrcVRYcGEwblEzQUVnRUViWEJKSU9vb3FIa0Uxei9nSXJBV3Rx?=
 =?utf-8?B?WEdHaU9VYmwwQ2FMSFNrOGFLa3NJN2NSb0REVmxpOEkreXpsTFNGd3JmaXpx?=
 =?utf-8?B?YTZZbENNTTU5WE1qcitaWk9LYmZQaW03VnF0THZhSVVzcjl1VVgrVVg3dlVs?=
 =?utf-8?B?QXQ3bjMzTHF1Y3ZTSW5SdWVmaUI2SkNFdkhURGVtU0tPdUQ5V3VYcTBOdE9k?=
 =?utf-8?B?VmtQU1AvTjlkSTJaT0NJZTlJQ21YU2xyRnYyelZ0eHJyS0tTUXA2MTNyOExT?=
 =?utf-8?B?WTBUZVBkU0h5ckVRQmxERjEzVWNKTDR0RjdTaEcxejRrM2dLUm5nTHo0NGd5?=
 =?utf-8?B?SDQwMXIvNFlEOG1vTE92R0tlNmY5Y25XNmw0Z1I1UHRxdUpzd2FBUzhCMDQy?=
 =?utf-8?B?WU5WckZGQmhmbHlHb3V0cFpwSWovWWRYbGdWMmRKVk04VWVkUTA0OUJVTWFk?=
 =?utf-8?B?ZERSK1loMUpsSWM4eUdQSGxXZkZRMFoxVis4TTg2NC9ORHNDcmV0OUV2YXNM?=
 =?utf-8?B?SmtDb2lrOElhUzN6R1hvUGN3VlZxWVZFZ1NSSEJKNHIzZGNYdjdqc09nYlpT?=
 =?utf-8?B?em9NY3ZuOFdzL3l1UUlMSjVyQ2J3ZU96VW5uQjNNRjYyMVFneVVPWnhTV2Yw?=
 =?utf-8?B?UkdMaDhvSXVYdU1VMlpSZFE2NTA1akpyYW95YitRd3grRXVMdllWT3dRZDUw?=
 =?utf-8?B?MHpvK0ZvYTdIYWppY3JQN3ZWbldEU2EzS2pxbFl4T3VxMG9wRTNIZjZJdkVK?=
 =?utf-8?B?Vi8vTC9nK1VXeXFrYWhKdk9PcGpDRHdjRDJzL042Nk9wSW5iVDJQNWUwK093?=
 =?utf-8?B?d3p0UmNTY2tZT1JUVkJ0dVdEcHV5ZFVCUlpWVDN1bE5zZ2RVaU4rUm5XYWRi?=
 =?utf-8?B?eFUrSTVSaDlBdmlISW9oRTBIV3JyUk9YeHQ4Z0xSVU9XREVGaW9BRmc5Rjkv?=
 =?utf-8?B?Q1A2MkRaeFd5M1ZTRHgvWm82WnBiVUpSOE5UcXpRQlBsb0lBcUQ2VldCWVZM?=
 =?utf-8?B?d0NiTWtrUEw5NmdhWU9NcEhaUVhialExaTFxTEo4N3BwV0h4L0JST3UwS0JM?=
 =?utf-8?B?d1hFZ3FtMS9aY2dqaEFNdkFpVDlvamQ2eVIzeWRxMzFMSU12Vk1USkdFRExu?=
 =?utf-8?B?N2orM0U0UWhWalVoUTdodUhYRFl5bU8zVkNFR28vR1EzSEVKYWpoSHM0YkFx?=
 =?utf-8?B?MUJUdjJxMUViNTROc0VReUNPRVRGREVWbGs1OUFXd2Vrd2lDaTFrVCtMRTgx?=
 =?utf-8?B?VWR5ZnJoVEJXQlFKUXRxQ3k1cGJUNGpidm03bmVuMWMzMkg4c2w0QVgrdzla?=
 =?utf-8?B?eUZZUnVEaG5ybzFncnNGOE9BbUZXSVoxUkhVRERNRG0rNGswOFM2SENpVUg1?=
 =?utf-8?B?bEVKaEZ6R0VwV3U4L3lYaGlCaHV6SDdNRlFCRHl6U09jOVVDd0hVVzRYZE43?=
 =?utf-8?B?UTNPS2psTDVBeHBDS0tJaWcyVjc2dCsrNFE1TTJidXlubFRPVW1oSTVyZUl4?=
 =?utf-8?B?dEoxYWtqcFMxdjFBLzZMSVVHNjB2ckU0VjA3T2RVSEdoOStvU3ZKZ0Z2NlRx?=
 =?utf-8?B?VWFEczZBQW1pTnh4eTJyR0hlRXV0bFZXaDNPRkRKWmRSMDBIK1hUWHAvZDJt?=
 =?utf-8?Q?bjZG8rAugPuX9w5/B0btswhQ9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 601ea5bf-0557-4a44-a2ef-08dcf7cee066
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 04:05:08.3098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VZOErdfW/XsGegMHAMfXcmDT2xiU6TpuN1JcvGRBcTKZkBtBlkicVzw17rfKNVa/5wRqW+eLiNbzMGcWG2lbig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5715

Hello Marcelo

On 10/28/2024 10:12 PM, Marcelo Tosatti wrote:
> On Sun, Oct 27, 2024 at 10:06:17PM +0800, Xiaoyao Li wrote:
>> On 10/26/2024 12:24 AM, Marcelo Tosatti wrote:
>>> On Mon, Oct 14, 2024 at 08:17:19PM +0530, Nikunj A. Dadhania wrote:
>>>> Hi Isaku,
>>>>
>>>> On 10/12/2024 1:25 PM, Isaku Yamahata wrote:
>>>>> Choose the first one.  With this patch series, SEV-SNP secure TSC can be
>>>>> supported.
>>>>
>>>> I am not sure how will this help SNP Secure TSC, as the GUEST_TSC_OFFSET and
>>>> GUEST_TSC_SCALE are only available to the guest.
>>>
>>> Nikunj,
>>>
>>> FYI:
>>>
>>> SEV-SNP processors (at least the one below) do not seem affected by this problem.
>>
>> Did you apply Secure TSC patches of (guest kernel, KVM and QEMU) manualy?
>> because none of them are merged. 
> 
> Yes. cyclictest latency, on a system configured with tuned
> realtime-virtual-host/realtime-virtual-guest tuned profiles,
> goes from 30us to 50us.

Would you be ok if I include your Tested-by in the next version of my Secure TSC patches?

https://lore.kernel.org/lkml/20241028053431.3439593-1-nikunj@amd.com/

>> Otherwise, I think SNP guest is still using
>> KVM emulated TSC.
> 
> Not in the case the test was made.
> 

Regards,
Nikunj

