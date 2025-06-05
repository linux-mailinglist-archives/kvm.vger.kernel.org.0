Return-Path: <kvm+bounces-48602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9033AACF80E
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:34:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 780EA189C121
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14D327B51A;
	Thu,  5 Jun 2025 19:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ypGFOfIW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1561C7260C;
	Thu,  5 Jun 2025 19:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749152075; cv=fail; b=btbFI8EW2RdcZZFvphSK1Sm3gSmPTZaCWxMuQ/Ktnorli17KdId7QnI6wcjfCIvcbMbAiUxmlIP7FT9cDty1fPbeTfRi8uSEEIQWcf4Thz8ZquOVhZ+BnDWhQ9YU9WsjPUc1PSNLndmS505ep2oE/2ka8OqjCUmFiFJaEZLAehg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749152075; c=relaxed/simple;
	bh=gaRZIAY/7UTfVfN9vckr63/4T1QCwq8PJf6YsE8yxo4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=H1yCPGS1LkP3nx1doYa5GiIf/YiKEScOo5u1hklmuMDIwM6dkEM716qhfCK3DIyvKPY4QxSmQhiyuL3PBEmzdaimchKnbExpNMlMb2RUPWgsCwQjBtulSsoaiqh0WHwKHXxU24zdsnu36YKUdzB2FZdiU7cx2S8E4UL/5SQl7cU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ypGFOfIW; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CjDszVmogCAdSUivSsGstYXDgwAC0+UpxkcbjvVjd/UK0drOZZpiFfqa/w8RkEeX1B9HEP0VhOaz7P0RiHAb/4C5y1ueUBVzr1CtVKHjmYTNShujpP3VEacT5WyC82CnO/qfVwkNN8yuZxtkK52RCMB/7h/KfNbkvx6QYkG0vpPBAKAzn6TRXPT6zj2tS9JPvsrO6R7N1LVK3WWSW5wxYUTBk+CpxypQtriI5nsYOeWlqhyKmvAD7q4CW4SpGmEf1ndsATXQUqPyrkw5zZZMFZ+kV5dkTyhxns9D3WOHXGG6zIJob7pni5oHuIs/XT8eluoJl8huJaw9/A83knvIew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uxvFrrV0uofIbY4n0/lBKxNoRhbLuq8JdhYcGkPxP/Q=;
 b=e9ItMmeonMCSw60c2P9HWNYw/zjXk6JAHzWZt3BenqPvql0KeSI+NRYI2wx8Waj/i+Tm+ADyuwOH2Tn1ljoAf/Q9JQqVlleq34iV7bZzfYdpLv2OMt6+WCtJFsUvi6cvgfRPUFClqM8l8DYYwn+zo75DnyxfXPqSjV2PePZQ9Ko9mNH7+urRe32T5eSgNvSA7rENWKmk46c7gJcEp6xBT6R7FkwPqjSSCbUTC2gqC30I9qZ0/OPq7CuW1TcfjDBzGSwlOpnAwaMNyscI8Yyph1i0TGATX7w10owBXMS+slEF8zhzNWZP7znVWINNMt9XMeSFh+0BRvIlJH71GXTrLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uxvFrrV0uofIbY4n0/lBKxNoRhbLuq8JdhYcGkPxP/Q=;
 b=ypGFOfIWSAmNpSBwN+y8x5xnYcMQvA1nnSa8gpXEamqG+Ip/N+J4hfz1/8JMhVZcjUoNNjwMajgsPCwOLgwSVM6GEbo8tTj+1+K9/MG+X0Zsln75/Ips1gtpo6sDIFeM5i4M1k5JHLaOhAnew3UYXtUGSjYxYf5K0isDPPJcVuc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SN7PR12MB8434.namprd12.prod.outlook.com (2603:10b6:806:2e6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Thu, 5 Jun
 2025 19:34:28 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 19:34:28 +0000
Message-ID: <9e4c44d7-30fc-4cb5-8a3d-75a989a6bda0@amd.com>
Date: Thu, 5 Jun 2025 14:34:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] crypto: ccp: Add support for SNP_FEATURE_INFO
 command
To: Alexey Kardashevskiy <aik@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au
Cc: x86@kernel.org, john.allen@amd.com, davem@davemloft.net,
 thomas.lendacky@amd.com, michael.roth@amd.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <61fb0b9d9cae7d02476b8973cc72c8f2fe7a499a.1747696092.git.ashish.kalra@amd.com>
 <48e2199f-37e4-4ea1-b28b-23eb421444cc@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <48e2199f-37e4-4ea1-b28b-23eb421444cc@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR18CA0018.namprd18.prod.outlook.com
 (2603:10b6:806:f3::10) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SN7PR12MB8434:EE_
X-MS-Office365-Filtering-Correlation-Id: ad232428-9c7a-4139-26e1-08dda467fc69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SG1EdFhGWHM0ZXJyMTdZMGcrZkRXUWNVY2VDdmJUQllURm9nYXI4WDQrSHBo?=
 =?utf-8?B?VGNLSDVYNm84WGcwS1pITXc2dmNCMHlkVC8xbzIvQmpReFFnb0t1dlcyVUxY?=
 =?utf-8?B?bllIRVNSOS9PV0xLYm5DTkw1bUlZU1Vwb0hjVHBYN0gyVUhNOEI3ZmhxQ2ll?=
 =?utf-8?B?TGQzWVg4RStEbHlLTkhWY2JLWTFtbjJKTVowdUloZ3cxT1NaSURHeFJ1TkFh?=
 =?utf-8?B?SFR4OVg1R3lwMnVnS3JGU0lHK3hETFhOQ1RlWmREd3VzdU14cVl5RW03ckdz?=
 =?utf-8?B?a2R3bFg0WEdsSlMvQStWNzBBSVJtZEZMZzR1ZTlMZXBNa3pUZHVOSm5aOVBl?=
 =?utf-8?B?cU5zanFsZ0svRzdnWERMb2lrV01OaWRDbnNybkx5WGxhT1dDV2xCOG9GSnZl?=
 =?utf-8?B?Q01YaU0xVGhpU01tSWdCSnU1VHJrMXlBQ3NjZHBqMXB6dWxyYzdtdGdzcGRU?=
 =?utf-8?B?ZUp5Y1FpRWEreFVzQStVZUp5N3ZTME9sTmh2bnhwS0FXU3lUeDZ0QUNBZHVK?=
 =?utf-8?B?T2RCdzExbFVUL1VaUHBUa3NTWEw1N0d5NldBaSszcmhIL0RUTW9KeEdHWkdm?=
 =?utf-8?B?WEFZcWZTWCs4djJMSjJFaE1DNlp4TG1vQ0tXMVdjd3U1dTFsNHJjYXkwbzZI?=
 =?utf-8?B?WjhRTmdGZzNZMFQ5TVo1K0k4NlZTUWFJanFDNHFRbm0rQTIzR2d1NU9EMFUz?=
 =?utf-8?B?ay93RXRNS2FNQmp5QjBlMUR5QjV0MXFQdUdaNmFrZ1BrK3F0TFYxVUhPTXM0?=
 =?utf-8?B?d3RlL2dOOHFGb2pqZFMrbVlzNVdsd2tVaVRocUxIQmQvWXEwUTNsTzA5QWpU?=
 =?utf-8?B?U1ZaQ3lDb2N4WnEvcW5kUjllalU0OUdheGNvbGJxcmNzRUl6VXZsaFZXWmdJ?=
 =?utf-8?B?Tm13N1pLN2FKR2xpZURpQ05FeVl5bDQ3U0lOYmtWYTREUnorRnVEVnMrR3Nr?=
 =?utf-8?B?Zk5YSzUyVG02MFB4aThReWYrZGdJd29YU1lzTnZiYkdTR1ZtbFBqOGFZeDRk?=
 =?utf-8?B?Qm5hUEFtNk5iT1ZTelpJenZGQzhyNHQ0cEI5Qk9aa1RkWGFINXBvNlhRSDZa?=
 =?utf-8?B?TEg5YjRZV1NIRURlQUc5UEE2cHUyQ2xHU2tVY2RmTkV3eWQ5QWwyNExyTzBi?=
 =?utf-8?B?S1FWMEErQnlHZXUwbFhiN2sxK3VLUjUzOTY1SS81Ukp4UmIwZmZTbFhweHh6?=
 =?utf-8?B?S2dnR0FQb3NMcE5jaXBIT2JkYk1HcGh4dzJhM0JSWWpYblNNdnNnMkp2b2Ix?=
 =?utf-8?B?dEo1OGVCMUsrV0p1ZXh0Smhib05HV2VSdmtWNzNRQXVuNmRWT0tMYW9sUGFj?=
 =?utf-8?B?VTNUMGxTRmRMSFBZMnZNd2pldWhYeUt1NlF4NVRJbG9JcmJva28veVFFSm9x?=
 =?utf-8?B?VE5ud1BETnRreEpVaHQ0Y00wdlNmcU9zSmt1Rk1jNGk5VElsWWZkdjRBTndU?=
 =?utf-8?B?VmNNU2xIa0R1NldTZGU2L0FQRllQcHhPRWFYK1UxenB4a2tZbWtwbThCWlBW?=
 =?utf-8?B?cEZjRVZ2MlZTd0xBVXlJb3B5NTIzK3U5OG1BU0Jic2t0OXhUaGFjbEtyQzc4?=
 =?utf-8?B?ZjRyRWk4WUtsV3h5TmRCMDhjUUpxQ2FtOGFzbXcyZEdSWHNWSjVKWTdsSzFy?=
 =?utf-8?B?TUhBdlYyMHRMaVZFdnNlZUVNTWVoWjU3aU10WmFOS1hUQlh1MGJ3K3RKZ3p1?=
 =?utf-8?B?SDJEZzE5d3FiS3ZCNmc1Rldmc2xiZk5hSjhTUmIyS25RWGl5cVYzRmptQjRs?=
 =?utf-8?B?RHBDc0hVbzdRTW1OQkRmTE05eTJJcUN5UjdidS9yK0xvM0k5bGx5bVVzYXl5?=
 =?utf-8?B?V3dFcitycEV1N0hqWVRGRGUzdlp2UG1VbmZHRVNDSUE2dCtsT0VnMldUR2ZE?=
 =?utf-8?B?Y045MFo0YW5vRDZCaGg4SlEwUGk4ZTVHeGg1MnE2UGlEc0YwWXVub1czMXpL?=
 =?utf-8?Q?vcfJIpn/yeI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0Q1T1l3WXQvZnFDeDJ6NUhsY01uTUF0WjBDVjQ4OGpWVjRqOU1XWGdDTGk4?=
 =?utf-8?B?blN1Si85MW51ZFFIcUU0WlMzYVFxN0FKalpvMUljL1c2dW8rOCtqTHV6RkNQ?=
 =?utf-8?B?L0huOGVDTGZjL2dUR0g2WFVFMVZxWHc4blRkblhleGJXYWFoOEFTMnJGRXoz?=
 =?utf-8?B?WjR3Q213ME5zQy9aWStJTDl5c0cydnNMZHdqZDZMWUFReW9WMVF5Z0ZwSGJP?=
 =?utf-8?B?TVVYaU9LKzA4NS96VTF2UzdlVGR5b2dzQU1DdUZjS1lkdE5qcGlqdzNqRUdN?=
 =?utf-8?B?K2R4aTVvbGYxVzJhYWExTlVsdkJ0U0lQY0ZGRFFEL1o4RkUwVjJsSHF6R1dT?=
 =?utf-8?B?N2grWDg5a0RhTFZvMSs0TTVDcW02bG1vQ2l2SDVLMjgxQlQxR0pVcjczTVlr?=
 =?utf-8?B?QkVFUUpmY2dVK2VxcTdNRy9zR2JUdXZDd2xBcWRQWDlLZXpyVWQ0K3pQQ0o2?=
 =?utf-8?B?NG83TkpoTEhrQU5CM254Y1JScWc5K3J5RG5mcHlsaWFDTWVoWjZPMkFDRU81?=
 =?utf-8?B?SVFkdXppK3hnSUR5eUNtSmQ0OTgvdDZ1M1BqRk13RG9xbU9JK1BlbzR3TUEr?=
 =?utf-8?B?NlY0SHNKd1NWMEl0U2tKSmc3TFBReEdBSmhqSzhUTDlRYUd5ODBXSGZGTjA5?=
 =?utf-8?B?SDhhM2VNb1NiWVpMOGs0c0V6ZVkwNHB1RXk3ZHB0Ujl3eElVc3BlRW5EWENL?=
 =?utf-8?B?WFFzWmZLeEM4M3hYc1diRFNsKzhaNTBsd3N5blNMczFRUDN2RUJmSStGUGdH?=
 =?utf-8?B?K2RxVmZqanFKejRTaXU3RGhsQ3ZwTFRHVENreGNiM0V0NzNjYWMyMW8xcVE5?=
 =?utf-8?B?K0x3ZTE2OUUwaFBqNkFoQzJ1WmExNTFQUk9UMHR0b09wbFdWTHhuUHJYVlRs?=
 =?utf-8?B?UDhlYUJ6L09hYkF3OUpkVmJNa0JNSkxJUzBjanlmczR0V0RNOGFBVXBVR0RN?=
 =?utf-8?B?bVVZOVBRSGFmWWlEckR6bnNDWm1zZDkxMS9KZGNxTDFtaXJaWG1PazZjbEdK?=
 =?utf-8?B?cU5sWFJIT0JveXptRytML3dMTjNIVEpLWUkrZDhoVWZLekcvc0RvelE4REs2?=
 =?utf-8?B?Z1FuT2p4SWNNVDdGQ0RwQ05WcjhUQ1ZQTlRQS0FzVlkxWDl0c2J3ZDBnZWxU?=
 =?utf-8?B?QXNDYkU5Q1RLaFZ4UHYyc0JoWnliaUgyQmlqaCs5VHJFTHU2N2orN2VMWXZt?=
 =?utf-8?B?cklEUVdZUGlwNUlOZ0xNZlFYbkZPMDdxbjJ0YmluYXRIZ0ZRNWVpUlVyYmJz?=
 =?utf-8?B?MUZpbXR6bW5kQzc2WDVOM3lzOS9UUHdSVG5MYjErTFFUMzFFSmt5aEZoeU1C?=
 =?utf-8?B?bUJZdTh6YmJnbkljc1FRU3ppQjNPOGVnUC8vTUduYWtvRUF6Szk3UHZLS0Fk?=
 =?utf-8?B?amI1THdBdTM3THNjM0tXY2dNamtPdGdnOVk0QWR2d0hKUVVLTGVzRmpPWkZ0?=
 =?utf-8?B?akJrTmE0ZU1aQlJZMGdzU1cvRGYreEZiY1ZIUTFJNHV4d0M1V2VwVG5KTzEy?=
 =?utf-8?B?U1oxbTRVamRpODd5bkNaQUs0L2xzWSt3blNkalJBLzJxTERYUk9yM1ZkbUdX?=
 =?utf-8?B?bUQ2TlNVUXhaWVRLejdkeHlqS2VnYjRVS3lZK2dJY0U3SUtvbXMzV01RZUlT?=
 =?utf-8?B?K1g1dzdsUU9yMERRQUlHVnczdU44aUt5b3FqTU01K2d5ZTRiNGg3ZHQweCsr?=
 =?utf-8?B?UlVSYUc4RjhLeWQwK1YzS1F3MWZSRzUwaEZ0ZGVWVUZKam8rUDk3aVV0VG8z?=
 =?utf-8?B?OG8yUTdMQS82RDNMMzkyTUNNem1qanhXRVNHSG1rYlVXbmswcWxDUWhKMm9i?=
 =?utf-8?B?SlJwVWFoYUsrM3JobmthbERTSEN3MjQyRzBQOFF5bFp5dGxvWkY3eG5mZUI0?=
 =?utf-8?B?V3ZrTXI1ZEM4T0cydmtzNUhBZWoyUGRNai82b2p0ZzJTQ2tCOG9HKzVSWDkw?=
 =?utf-8?B?eTVYSzdZQi9ETVZJUkxlVVh3UGFoRUhYVE82SHN5UjQ4NjUxMkhrUFJpU0tT?=
 =?utf-8?B?VWxGM0ZHNmVvN0Y1UElmekxidlBUSHNaNlJpYW5ZbCtOdDJMQ3RPdUtWWXpy?=
 =?utf-8?B?K1h0TUltQmJhQjlHNGQ3N3pMd01PNFoyL2tQdUlqbHpyN2xqa3V3UVhQN0xB?=
 =?utf-8?Q?bobkYZJguiTPjgBabm0aKQ9l1?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad232428-9c7a-4139-26e1-08dda467fc69
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 19:34:28.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6mVu8vn5ktZALyCh7lB9ZI4mPpV3hofl6hU9aRwynT5jm/u/Nq7qClHA3g2T92OJ9apJcqKXIeJFo59JfV3PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8434


On 6/4/2025 11:49 PM, Alexey Kardashevskiy wrote:
> On 20/5/25 09:56, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> The FEATURE_INFO command provides host and guests a programmatic means
>> to learn about the supported features of the currently loaded firmware.
>> FEATURE_INFO command leverages the same mechanism as the CPUID instruction.
>> Instead of using the CPUID instruction to retrieve Fn8000_0024,
>> software can use FEATURE_INFO.
>>
>> The hypervisor may provide Fn8000_0024 values to the guest via the CPUID
>> page in SNP_LAUNCH_UPDATE. As with all CPUID output recorded in that page,
>> the hypervisor can filter Fn8000_0024. The firmware will examine
>> Fn8000_0024 and apply its CPUID policy.
>>
>> Switch to using SNP platform status instead of SEV platform status if
>> SNP is enabled and cache SNP platform status and feature information
>> from CPUID 0x8000_0024, sub-function 0, in the sev_device structure.
>>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>   drivers/crypto/ccp/sev-dev.c | 81 ++++++++++++++++++++++++++++++++++++
>>   drivers/crypto/ccp/sev-dev.h |  3 ++
>>   include/linux/psp-sev.h      | 29 +++++++++++++
>>   3 files changed, 113 insertions(+)
>>
>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>> index 3451bada884e..b642f1183b8b 100644
>> --- a/drivers/crypto/ccp/sev-dev.c
>> +++ b/drivers/crypto/ccp/sev-dev.c
>> @@ -233,6 +233,7 @@ static int sev_cmd_buffer_len(int cmd)
>>       case SEV_CMD_SNP_GUEST_REQUEST:        return sizeof(struct sev_data_snp_guest_request);
>>       case SEV_CMD_SNP_CONFIG:        return sizeof(struct sev_user_data_snp_config);
>>       case SEV_CMD_SNP_COMMIT:        return sizeof(struct sev_data_snp_commit);
>> +    case SEV_CMD_SNP_FEATURE_INFO:        return sizeof(struct sev_data_snp_feature_info);
>>       default:                return 0;
>>       }
>>   @@ -1073,6 +1074,69 @@ static void snp_set_hsave_pa(void *arg)
>>       wrmsrq(MSR_VM_HSAVE_PA, 0);
>>   }
>>   +static int snp_get_platform_data(struct sev_user_data_status *status, int *error)
>> +{
>> +    struct sev_data_snp_feature_info snp_feat_info;
>> +    struct sev_device *sev = psp_master->sev_data;
>> +    struct snp_feature_info *feat_info;
>> +    struct sev_data_snp_addr buf;
>> +    struct page *page;
>> +    int rc;
>> +
>> +    /*
>> +     * The output buffer must be firmware page if SEV-SNP is
>> +     * initialized.
>> +     */
>> +    if (sev->snp_initialized)
>> +        return -EINVAL;
>> +
>> +    buf.address = __psp_pa(&sev->snp_plat_status);
>> +    rc = __sev_do_cmd_locked(SEV_CMD_SNP_PLATFORM_STATUS, &buf, error);
>> +
>> +    if (rc) {
>> +        dev_err(sev->dev, "SNP PLATFORM_STATUS command failed, ret = %d, error = %#x\n",
>> +            rc, *error);
>> +        return rc;
>> +    }
>> +
>> +    status->api_major = sev->snp_plat_status.api_major;
>> +    status->api_minor = sev->snp_plat_status.api_minor;
>> +    status->build = sev->snp_plat_status.build_id;
>> +    status->state = sev->snp_plat_status.state;
> 
> These 4 lines should be ....
> 
>> +
>> +    /*
>> +     * Do feature discovery of the currently loaded firmware,
>> +     * and cache feature information from CPUID 0x8000_0024,
>> +     * sub-function 0.
>> +     */
>> +    if (sev->snp_plat_status.feature_info) {
> 
> Could do:
> 
> if (!sev->snp_plat_status.feature_info)
>     return 0;
> 
> and reduce indentation below.
> 
>> +        /*
>> +         * Use dynamically allocated structure for the SNP_FEATURE_INFO
>> +         * command to handle any alignment and page boundary check
>> +         * requirements.
>> +         */
>> +        page = alloc_page(GFP_KERNEL);
>> +        if (!page)
>> +            return -ENOMEM;
>> +        feat_info = page_address(page);
>> +        snp_feat_info.length = sizeof(snp_feat_info);
>> +        snp_feat_info.ecx_in = 0;
>> +        snp_feat_info.feature_info_paddr = __psp_pa(feat_info);
>> +
>> +        rc = __sev_do_cmd_locked(SEV_CMD_SNP_FEATURE_INFO, &snp_feat_info, error);
>> +
>> +        if (!rc)
>> +            sev->feat_info = *feat_info;
>> +        else
>> +            dev_err(sev->dev, "SNP FEATURE_INFO command failed, ret = %d, error = %#x\n",
>> +                rc, *error);
>> +
>> +        __free_page(page);
>> +    }
>> +
>> +    return rc;
>> +}
>> +
>>   static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>>   {
>>       struct sev_data_range_list *range_list = arg;
>> @@ -1597,6 +1661,23 @@ static int sev_get_api_version(void)
>>       struct sev_user_data_status status;
>>       int error = 0, ret;
>>   +    /*
>> +     * Use SNP platform status if SNP is enabled and cache
>> +     * SNP platform status and SNP feature information.
>> +     */
>> +    if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
>> +        ret = snp_get_platform_data(&status, &error);
>> +        if (ret) {
>> +            dev_err(sev->dev,
>> +                "SEV-SNP: failed to get status. Error: %#x\n", error);
> 
> Drop this as snp_get_platform_data() does that too (and even better as it prints @ret too).
> 
>> +            return 1;
>> +        }
> 
> .... here, and drop the @status parameter. Which in fact is pointless anyway as ....
> 
> Let snp_get_platform_data() do just SNP stuff.
> 

Yes. 

> 
>> +    }
>> +
>> +    /*
>> +     * Fallback to SEV platform status if SNP is not enabled> +     * or SNP platform status fails.
>> +     */
>>       ret = sev_platform_status(&status, &error);
> 
> ... this sev_platform_status() is called anyway (not a fallback as the comment above says) and will override whatever snp_get_platform_data() wrote to @status.
> 

Yes, as Tom suggested will be moving to caching both SEV and SNP platform status information.  

> 
>>       if (ret) {
>>           dev_err(sev->dev,
>> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
>> index 3e4e5574e88a..1c1a51e52d2b 100644
>> --- a/drivers/crypto/ccp/sev-dev.h
>> +++ b/drivers/crypto/ccp/sev-dev.h
>> @@ -57,6 +57,9 @@ struct sev_device {
>>       bool cmd_buf_backup_active;
>>         bool snp_initialized;
>> +
>> +    struct sev_user_data_snp_status snp_plat_status;
>> +    struct snp_feature_info feat_info;
> 
> 
> "snp_feat_info_0" as 1) it is for SNP like some other fields 2) there is subfunction=1 already defined so need some distinction.
>

Ok.

Thanks,
Ashish
 
> 
>>   };
>>     int sev_dev_init(struct psp_device *psp);
>> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
>> index 0b3a36bdaa90..0149d4a6aceb 100644
>> --- a/include/linux/psp-sev.h
>> +++ b/include/linux/psp-sev.h
>> @@ -107,6 +107,7 @@ enum sev_cmd {
>>       SEV_CMD_SNP_DOWNLOAD_FIRMWARE_EX = 0x0CA,
>>       SEV_CMD_SNP_COMMIT        = 0x0CB,
>>       SEV_CMD_SNP_VLEK_LOAD        = 0x0CD,
>> +    SEV_CMD_SNP_FEATURE_INFO    = 0x0CE,
>>         SEV_CMD_MAX,
>>   };
>> @@ -812,6 +813,34 @@ struct sev_data_snp_commit {
>>       u32 len;
>>   } __packed;
>>   +/**
>> + * struct sev_data_snp_feature_info - SEV_SNP_FEATURE_INFO structure
>> + *
>> + * @length: len of the command buffer read by the PSP
>> + * @ecx_in: subfunction index
>> + * @feature_info_paddr : SPA of the FEATURE_INFO structure
>> + */
>> +struct sev_data_snp_feature_info {
>> +    u32 length;
>> +    u32 ecx_in;
>> +    u64 feature_info_paddr;
>> +} __packed;
>> +
>> +/**
>> + * struct feature_info - FEATURE_INFO structure
>> + *
>> + * @eax: output of SNP_FEATURE_INFO command
>> + * @ebx: output of SNP_FEATURE_INFO command
>> + * @ecx: output of SNP_FEATURE_INFO command
>> + * #edx: output of SNP_FEATURE_INFO command
>> + */
>> +struct snp_feature_info {
>> +    u32 eax;
>> +    u32 ebx;
>> +    u32 ecx;
>> +    u32 edx;
>> +} __packed;
> 
> (not insisting) You could even define this as "struct snp_feature_info_0" with all the bits from "Table 5. Contents of Each Subfunction of Fn8000_0024". Thanks,
> 
> 
>> +
>>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>     /**
> 


