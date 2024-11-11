Return-Path: <kvm+bounces-31497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB299C42BC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 17:39:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F1FC1F219E3
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 16:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0192E1A254E;
	Mon, 11 Nov 2024 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GsonBwy0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2045.outbound.protection.outlook.com [40.107.96.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76DD339ACC;
	Mon, 11 Nov 2024 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731343147; cv=fail; b=hph6G0FthBVSPpw2LCQBcjEFPSsgU4sv4RhpG02M0szwgdopomXUxlGEu7euuOz11Qxpj0IZDBqryzTiwqButGBs1JlwezdDyqUEyniwM9nXwbd8BCE6k0lFh+AEXV2Jpwcn85RSzOkKqEDwhMaJw9YZnBtQSwrWfH0KaWW9FU8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731343147; c=relaxed/simple;
	bh=nYHPokqqCjf8kc3RPDzpdhREfo9EcFa/0oSOwAqg+YM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=A12LmtFzhX+dNLQiwQ5FKHQPwC/z6wTodEEwEyRqZoZdop+iWUOIft9CgSXor57UjCNDn7zYAJahvjfUhQLkghjATr9areGLMb2sJixOm5J5It8xOEBQTJwx9hdZ5Ux3pIqOXkWtnTZbDfGb9DH6InbBw6PBd/KDBC1ppAqj+qM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GsonBwy0; arc=fail smtp.client-ip=40.107.96.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H57hWKlTF2K/xB9lpQ3IFyJyGwDmA7ejHRhCfYLFCUF4auIgdIKvZ+cJ9hsnmjfsFpMBTLIey38TbxSTvLy97UkVEy++esCpQv+PLs5k9oAYaWB4PLntp2nNKc+tozYwzvonolTvS0yA+2eI37DJvf7d8f6RzswX00yIklw/m3E6wX2oez9HFuBlsNGqruHX1Y97aXYDHrARTGMDUB0/pb1mMiqSUQUB164xLRm16V4oSucwxM2vbxsJk5VH4FGPdi7+qtsWKTptShZWnzzzeuZedrtNiFrC9idsEEbH26ELlVxGVJtsi7EWyfPu/5MZqpXv4BBXLqfLECBkrbVMIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mfNYq9SICn7+CdpTgSaHSn5HIj96QOMdGj/STyZhxzc=;
 b=fbkDmxrmhdMASCYK+thj2bo80Ha7B1SJUkkYgwt2jLpzT6y8GyCQXGtj0Que9QdAVwnjeqQhrOvmwtRuA0nj7adEhEcdz8/iPcUSwHHMV3/hQgLwuOsVSUvtj4vB6lOdevvbLiOLKroiFjex2NU8VtkqzOOvbHRj3TIDLjEwo9zUq2GTg50r29BUnCZssGhdRkWQET5fiAt+ayRpuZY3wcXgvLqoTkG3dfdIswEVD3jOPngF1IXoHsqPWzIMudCtQCB+TNvUzH5TYQamGKZipAguL4A1lyEg3uG/jemQErNxfW5xIdwb1ydyf9TFWx2YtVF/xRqv+GPdxh2g6vy+kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mfNYq9SICn7+CdpTgSaHSn5HIj96QOMdGj/STyZhxzc=;
 b=GsonBwy0heI8Npsd7pY9uHCErVFScXODvflC+YV3Kkgc3ACfeyTZvmxuRg0l15DQiiyL8WYSrnPr1e+61u0U4vrf9hrLD5j14d6O/PsBTo1PKM9FKNE2t2ad1Ix64GfbfAFKx3dC7mRcIe+/p3YLjFy91F9Skjqg1KG1Z/ZCuyU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SN7PR12MB7227.namprd12.prod.outlook.com (2603:10b6:806:2aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Mon, 11 Nov
 2024 16:39:01 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 16:39:01 +0000
Message-ID: <638034b7-5c1e-d261-058a-79d795580410@amd.com>
Date: Mon, 11 Nov 2024 22:09:14 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v14 05/13] x86/sev: Prevent RDTSC/RDTSCP interception for
 Secure TSC enabled guests
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241028053431.3439593-1-nikunj@amd.com>
 <20241028053431.3439593-6-nikunj@amd.com>
 <20241111155355.GDZzIok9eRWDPKnmS_@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241111155355.GDZzIok9eRWDPKnmS_@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0033.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::23) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SN7PR12MB7227:EE_
X-MS-Office365-Filtering-Correlation-Id: af83aa4a-db98-457a-ca04-08dd026f587f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWhLWVh6UVNKSTlENDFHVDhBTzRiQUVEWEdKZDVXOHVuVzFKTVhWZXFicFNQ?=
 =?utf-8?B?d3FtVW5mUWRUZnBjNU9sV2VhNFQwaldzK1JXNVJyeUxESjl4OXE4b3BXb3F4?=
 =?utf-8?B?VGRCOEtTcVczQTVpUkhaQ1lyMjljVzlBekJmREZyMklWRmovNzVMeGx1YWhZ?=
 =?utf-8?B?VnZGeTZWR2JJSTZxd2FCQkR2ZENXVlVzbVhqYm5oTzR5Y0NwclVHVjB0YjNp?=
 =?utf-8?B?YVNxOGVjVXBVdFBCbnlmTWxGTVVSTWNXbzNVQnBDZGFWMWFhUjJRNk90QkJS?=
 =?utf-8?B?TjJFVWs0SXdlclBTTmk0TGFPNlZVM1ZkQ0xSeXZzZTk5aW1UL1BGS0UyRVJt?=
 =?utf-8?B?UUZJTzZnNS9YTitnTmRONzZNTXRrOXVCbDZDRlFwQW9MK1B1V1VZYVJoWUxC?=
 =?utf-8?B?bmlhV3hmb1grNzdPNHR2NS8wQnBYYnhZTDZGR1ZTRHZuWnNwcEdWZmNXalpR?=
 =?utf-8?B?TFA1SWgwbnlFOWlhaXBpZlc0dHhnRCtVWGdXaHhvVlZIaHRpcm5SUnFwTFd2?=
 =?utf-8?B?MVZqRFJBVW8yR0UxUXBvY3krOVVBb3J0Vi85c0FWVDI1RlN3NTNpdUcrSjho?=
 =?utf-8?B?Um1tYm13Z25pYU9UWUxJV0pWYzZvMkZQcmYrcnV0U0UrSGpmVVFURE83cWxJ?=
 =?utf-8?B?RG42eld4SkhmaTZlaGhvSHV1VkRmdkFwRlFJYTBlNFFWZG15YlQvQzlBZEtW?=
 =?utf-8?B?d1c0WGowOUFBUjN5T3BtNXppKzIxODRxazZrNzdhTHJmM0tlaEZRbEhQRStS?=
 =?utf-8?B?M0szNUxYYVJoRjZFU1BEbWJ4MHU0Z2dybzN4TGV4ZERlTGJoL0xyc0dQdW9J?=
 =?utf-8?B?RHRhWUdvRVdhS3czK3ZuT3IzL1VHbk5LLzgrWHh0NVZFMk1KQTcxVXRnZjVY?=
 =?utf-8?B?clpNeEp1MjJoOEdmWTlQcnJEYlZXN1N3dEdFWUlEbkVWcFR0VkRZTmpNS1pT?=
 =?utf-8?B?SHY3cFJPVHlPZ1pKTUZkSksydXhlVnVHTTRLWHcram0vcFRqYWwvMFpKMDEv?=
 =?utf-8?B?eVR0aHFrendQTURqTVhQY0g4QkswQ3Vvb1pobUp0R0luOS8yNXNkQ1E0bm5m?=
 =?utf-8?B?RFVocy85UFQ0ZUJQdGtJa3hUbHNGeExQeVV3cXFtYkRrZXY2d3VBaHcwekJh?=
 =?utf-8?B?WjNPOVpBQ3hVczBueTVZSG1yOGVkVTdSem5kK1B1aC9kUXEwaVowTUlTdkhv?=
 =?utf-8?B?dkNtN040RFNvcmZBQmRGSjc2VWdDaHZXR1JEemFKVFlLTExHL3VIZnlzaHNW?=
 =?utf-8?B?Wkx2NmJWRjVrMnhqNmljZG5aRXJEcG5vTDRkdXc3cmM5ajBaMUlocjBydTdq?=
 =?utf-8?B?eHFrT2RrYm14N3Bid2ExRXVpOE5VSCtGMGpmNjNNa0lEc1R1eW9HcDEya01F?=
 =?utf-8?B?QTZ2STJ4bktsa05Tbk5pZDBpVnl0SUhMQU0rLytsK2dudkVWYmVobFIvRFRV?=
 =?utf-8?B?M2ZLRmxFYWRCRnZPTzhrQmxGemkycFkvSUZkYm05ODJiMUpvWkJqcGVSeTBv?=
 =?utf-8?B?NmVxbEEwNVVxdVFjZ2pRK3czckMvMUNvQUFTa2g5WTAxVjNUOGRCVEYvdXpG?=
 =?utf-8?B?dVp3S2Y0Q1FPU2k4S3dqV05GMk1nVWMyL2VHTXorSENCU1V3N0VxYXBxSWRN?=
 =?utf-8?B?RmpaRHVJUDdUeXJZZ2JqY1pvOFJjR3o3WE51bG9yS29DRnJOelJKMlB5Qk9H?=
 =?utf-8?B?TTh0ZXlBNldWWHIxUG5jeXN2ZjdmejBUemlnWVlkK3l5SFkzemZkN0pxcm5V?=
 =?utf-8?Q?+Gq/V6eE9xtyQ+xyAK/ESfS+Mugy2Cwvjqb/Etu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Tk02OGlmYzZLR3N3bUEzVTZ1K2p2VzdDVzZKVC9TQlpQeEl3UzdwK0NZRTlr?=
 =?utf-8?B?YlVTQ0lCNnVHRlZzR1IzMVp1RmlTNEJCMkNiUlRsU2Z6dlhIWlRLSWxWVlcy?=
 =?utf-8?B?V2JleGFOZ2l4d3l2NmM1TmRQUjBlbDFSbC91Z1QyVFJ1dlc0TVJ6ZXp0ODAz?=
 =?utf-8?B?T0daUTRoYnYvTVJxRExtak50VDhreGs5RWo0bWdRMnA3Qzh3aEt2UDRJOXVv?=
 =?utf-8?B?Z281bDU1VmZEalNNTXB5WlJKTndkaTZ1VkNYVUJxbmZGbmRYdS9UdFBoSndG?=
 =?utf-8?B?b3phRU8rWi84N0cyeDZWT21Db0JaWVYwV0JjOTBUV1BiTjE1bFBiMHExVy90?=
 =?utf-8?B?c3lQeUE4KzFYQURwZWhSRURqbGdvWWsyY1J1ejdhdnNWM0llQitlb2pqenQv?=
 =?utf-8?B?cFpVWm5qVU5sR05NaTNYZ3h2dkN5bHVRSVFhVUpKR0Q5aGV3WldPQVpCRmRD?=
 =?utf-8?B?NGVCMUwybmN5WE81YnNRTldjL0Y2ZTNBZzl5R2tjclpPYnFoTUlmcUdRWTZj?=
 =?utf-8?B?TkgwTEpiNVVuOS9TV2VHOVVLNktOQ0NJS3Z2cFNvb2kvRVgySmZReHdhaXlH?=
 =?utf-8?B?b3YyWE04am4vTFZhaHNpanZ4S00yVXRoeE4rNWFuSUQyendrNnArVm82ZVd3?=
 =?utf-8?B?WWptSlo4OHVYemFZejRKYkQzR1NBeC9Jb3ZhcS9nOHpHUHVTRU9nWnNzZnZ1?=
 =?utf-8?B?T0VTWXFKZ1RUejRyQTNyUkhsYWpWVW55UTYxK2NkcWdqczZjUTF0bmZVLy9J?=
 =?utf-8?B?WWtjWmczOHY5a3B3UDFucXhCWSs2MGcxb3ZBRm44eXdsZCtxNDRCaVIwSUFB?=
 =?utf-8?B?UVNPb1o2bmFDSmErZFA1eG5tMnkyOStKc2JmNXNpanZmL0NkcFQ0NDlaRlFi?=
 =?utf-8?B?NzY1S1MyMGVCMENCV1BNSW9ZSXUyT3ZKUEg0VlF4RUNacm1GWkpqWkpuVUxl?=
 =?utf-8?B?b3hldlpCK2xJNkp3ZFVGdkpIc0EyQW9tSGpYQ3NYZGk4VnA5Y1JuSUhzZXRp?=
 =?utf-8?B?NnQzMkRLMldQZ1FMSTkzOElQU29WNUVBQnFsK0pUQk0rcWhUSjQ1QVA2Qnor?=
 =?utf-8?B?UksxMHlOQzJlelR3bmZPR1VNZTBEb01UdmxWL21zS283RFJvS0NqSUk0bTdH?=
 =?utf-8?B?amJsVXUvUUZqZ0lJd3E4ejJ5UlJPQTJtcEtpQlNxdFpVeGE1U1dveUNaSmJV?=
 =?utf-8?B?eTZLYi85S2s2NmUxL2JDUjhPRlhOcXdIZVAzOHZLTi9TVWdFdHhSZDBSZ0NJ?=
 =?utf-8?B?Y0RvbGFUQTlVOWx0TURlb1ovVFl5WENjQVlORXpvUklPUG1XaFU5SEtFanU5?=
 =?utf-8?B?cDVTdGxYRzBMck1uWUpVR2FpOG1kaWZKQVZIZTUreDhFR0ptVjBrcVJFeVdD?=
 =?utf-8?B?ZjJRcWJ5L3NsRkhTVUdta2V5eVN6VU8rbXNDelY4ZEdSMjhodmdmLzFYanlj?=
 =?utf-8?B?NVd4a0xUNDJnUm9GekF5K0tTeTJuL1l1cWZ0TzFWMTJMM05pVEVNRmtsN0hz?=
 =?utf-8?B?SHFuRU5RbEkwbzdodWcyQmJVZTBjajJUSjFEMkNBTzcwOHVLcXZUK3RvTUF0?=
 =?utf-8?B?elRiekdoWUhqWW8zVFBiNVJ4VGpCV3lYL2ZhYzNWZDJGdS9LbTh0L21SMWJz?=
 =?utf-8?B?M09BRmVab2ZsTVdxTklJTmZQV0M3SDAvWEdDSnhHVkVFU0RhSFhwRUMraG42?=
 =?utf-8?B?Lzlmb1lVeW9wWnpNUFBrZlo5VzE0ZWt2cnJHaUpIVnM4RVNxVk1VTWJkU0F3?=
 =?utf-8?B?NWtLWHg2RjN3bEV2VzBjd00wYm13bzlyV1hXaTg4SGJjendXSEpBSDQ1Mzhw?=
 =?utf-8?B?VldzSk5pTkUzNkFZYjRFMHVteGQ4LzA1dG44K0htVnpTSm5DSWdTUWx3S1pt?=
 =?utf-8?B?Ny9DWS9MWUF0YmhwZ3NoOVdlblJnSVFhS2xta00zZWZISXBIa1oybllnaU9p?=
 =?utf-8?B?UUx2NjkwdlJEWkdPUSs2ZVZPVERFRGt3K1lodW1KVXBZNHhxRHM5V2NYTjlQ?=
 =?utf-8?B?QWdQcW1XMHZOd3gxZHhRN0RyMzdNUTJ6SlduWEJxdkoyVWtkK3RPbWJhOTRs?=
 =?utf-8?B?SCtXRkFKTytGMFR5ZjgvSG5RamZiTjFUUXZzblB0K2NXU3k4T0F3dm9BcUVJ?=
 =?utf-8?Q?pmlBvMLcjda7VNJVx/t8xlc7p?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af83aa4a-db98-457a-ca04-08dd026f587f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 16:39:00.9901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMBTpveRAtng8EgXaToF3jndDB0bVhf7wIIflyL3vV+SrZSn3N9TyXVOZ4grhh2fl1ScVjkAe3J4fyC9hhUB6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7227



On 11/11/2024 9:23 PM, Borislav Petkov wrote:
> On Mon, Oct 28, 2024 at 11:04:23AM +0530, Nikunj A Dadhania wrote:
>> The hypervisor should not be intercepting RDTSC/RDTSCP when Secure TSC is
>> enabled. A #VC exception will be generated if the RDTSC/RDTSCP instructions
>> are being intercepted. If this should occur and Secure TSC is enabled,
>> guest execution should be terminated as the guest cannot rely on the TSC
>> value provided by the hypervisor.
> 
> This should be in the comment below.

Same message in commit and the code comment ?

> 
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Tested-by: Peter Gonda <pgonda@google.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
>> ---
>>  arch/x86/coco/sev/shared.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/coco/sev/shared.c b/arch/x86/coco/sev/shared.c
>> index 71de53194089..c2a9e2ada659 100644
>> --- a/arch/x86/coco/sev/shared.c
>> +++ b/arch/x86/coco/sev/shared.c
>> @@ -1140,6 +1140,16 @@ static enum es_result vc_handle_rdtsc(struct ghcb *ghcb,
>>  	bool rdtscp = (exit_code == SVM_EXIT_RDTSCP);
>>  	enum es_result ret;
>>  
>> +	/*
>> +	 * RDTSC and RDTSCP should not be intercepted when Secure TSC is
>> +	 * enabled. Terminate the SNP guest when the interception is enabled.
>> +	 * This file is included from kernel/sev.c and boot/compressed/sev.c,
>> +	 * use sev_status here as cc_platform_has() is not available when
>> +	 * compiling boot/compressed/sev.c.
>> +	 */
>> +	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
>> +		return ES_VMM_ERROR;
>> +
>>  	ret = sev_es_ghcb_hv_call(ghcb, ctxt, exit_code, 0, 0);
>>  	if (ret != ES_OK)
>>  		return ret;
>> -- 
>> 2.34.1
>>
> 

