Return-Path: <kvm+bounces-27282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CE3097E41B
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 00:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DFF01C20FD5
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 22:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2047778C8B;
	Sun, 22 Sep 2024 22:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J1YHGq/o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2051.outbound.protection.outlook.com [40.107.243.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BA8EBE;
	Sun, 22 Sep 2024 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727045293; cv=fail; b=CZ7UlIgadv4WpY0LwBjngXAazKmUuvsuthLZYgy0bQ4nbnUFdqKRnc/A4b0FyFwkbHI5KbPkMHBuIYsC4yuE4vhQwU3I08Cn7Z4klTmzwNeGpBYq7oziXH0cMkso9o6LPk7XGFLNJj8pGZwDHjr+dHtSdroNQ3RN4X8AxiK2VWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727045293; c=relaxed/simple;
	bh=WBDgAkbReuz2yeMrAiZKYhM/5+bZDekINAfidNt5o6w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fQZOJJ4FOqXWnxBeYnd3Juvr7U9h2dJANKtmy2ssg0qqAguk2LZpG0L0RGFgfWyxy2AIyooBceVH9JNFuQ5Tu6jaxziQaf30pH7R99wwP9N5GBNYf8Uu+rlxJam7ky71gITQ8gz9mR9v2uvKg0dnXMp2pY6PS1kbkkUf2F5N0n4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J1YHGq/o; arc=fail smtp.client-ip=40.107.243.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tHEkyzJlDx3CStenyRXhro8jOw4VCnIChiCabX7udLqHEu7uPxK/RjmFSn3w+kdP+jH9XET9Bbsj+NGaOegtNS1ruVmVxMQ67jqlbhZXDJZi15JpygcOuENICC1B0T+f/7A0cVUAQI0bs7/8+Nt6Zwmmie59SAnSPm5RHp6A4Y9Jl4F++pf+3E+nLv7414ODg9VMvSwgg/hgeXshDgtRGOFeNCk+w5puYa3VTMYj2BPPidXdsbNl9sUTvey3fogQ7WOeK+xcW/TePjJ+zIu1kGccCdINgykUjQLo8NVhdMnqhpO9GVk3Fc6+R5Jfs0CTB8mhr7FuWt3cIKyQG99PYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hzXPF2+FYAALfuI7sbUqoxhi08GKj/Llc9m3RScMkiA=;
 b=rOZN/GlE7C7xlFaAOcd8X2TqB5KaMXqlBv9UIBHKzu/aN9sSoMJP9LqTsA2YkUNodNtWJ6YslnE4gaRovO7xYYbCw3YJZI94LRH0vWKG2Kkgg+KccABPnhcPR2lIH0aRElUVZ79pqquxag5nnrgj5WoN/QEr/qZVfqzQ9K2qZRjLBRF24cYaszTltkQKAWEP10r75Ln6tZIbMQEu5gcwFUNcCyjmKqGznznhows2YdQxWa+DXGYIJlAiC7wzW28cwq25IkCvvkaKxBtxDxqESvYz/kzW/2T9qiwUwEcUvyR1dRtQdSDQTxHqdZvAzBK94IEfZUfrhEB5YVj3a0QdHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hzXPF2+FYAALfuI7sbUqoxhi08GKj/Llc9m3RScMkiA=;
 b=J1YHGq/ocMCbLossff/Gwp04WZzKJFYzlwrNX8TL5GLaoNpqna5+eJot2EhKX+suC/L1wZPw5GWeM9enbPbhz5DXlImNr7OnP+xXm4KW6JsAobPb2Ynh4mFisA3YDa/h/kLLMdmTDUN+3kxW8egUfgp6/5FqKZbxSedOJpHFjefdBSnsnUMzo5hyzORFlZohoNQwrQm6QqcMbKfNWTgc4dTEUp7QicE2nvhqeZDGE6gCRWUC06nUNiXZ/AMT0470F4zk1tiTxmG4M0JNuLQ4ep9dohC+aZ/7KbMZP4mBrFcIlth8wOCKEXxXUF0nau83a20WDck5Xf5lg2jQmcXTIA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10)
 by PH7PR12MB6489.namprd12.prod.outlook.com (2603:10b6:510:1f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Sun, 22 Sep
 2024 22:48:07 +0000
Received: from CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6]) by CY5PR12MB6369.namprd12.prod.outlook.com
 ([fe80::d4c1:1fcc:3bff:eea6%4]) with mapi id 15.20.7982.022; Sun, 22 Sep 2024
 22:48:07 +0000
Message-ID: <17b866cb-c892-4ebd-bfb9-c97b3b95d67f@nvidia.com>
Date: Mon, 23 Sep 2024 01:47:59 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
To: Marek Szyprowski <m.szyprowski@samsung.com>, stefanha@redhat.com,
 virtualization@lists.linux.dev, mst@redhat.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
 <CGME20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a@eucas1p1.samsung.com>
 <fb28ea61-4e94-498e-9caa-c8b7786d437a@samsung.com>
 <b2408b1b-67e7-4935-83b4-1a2850e07374@nvidia.com>
 <5e051c18-bd96-4543-abeb-4ed245f16f9e@samsung.com>
Content-Language: en-US
From: Max Gurtovoy <mgurtovoy@nvidia.com>
In-Reply-To: <5e051c18-bd96-4543-abeb-4ed245f16f9e@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO6P265CA0010.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::7) To CY5PR12MB6369.namprd12.prod.outlook.com
 (2603:10b6:930:21::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6369:EE_|PH7PR12MB6489:EE_
X-MS-Office365-Filtering-Correlation-Id: 35771372-7762-4cf1-fa8f-08dcdb58a044
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YU9NM3dPU0NtWTJLcW9oVGxFam1PeFZiL0pYRnVmQ29wcnp1cjhDMUZRZ0F2?=
 =?utf-8?B?YnM2QjVXUS9tbVFLSWJFYjh6TDFiaU15OU0xcEZHUTFxYnY1dUFzQ2txdW9p?=
 =?utf-8?B?Q0ZWbjRkVG9scTV3MHJRWk13b216VmkrR1k4R2tXZkRTSnkwWmVISmlXUDBk?=
 =?utf-8?B?MFFKYTFLT1MvWW91VVRXY0lRNjdpN1BvYURkOFVsRG5vc0gxazR0OXFLbUxw?=
 =?utf-8?B?cktjcWE5ZFl0enNJRTYvczlzbUN1TFBWdXJiaThCNjJMeFY0ZWcwTGdhVUZm?=
 =?utf-8?B?MHJCdTAyS09HZ05zZ0Y0dk82dnJ0cjY0R1pFaFF6NHNvYU1RYTROTzZ0ZUxw?=
 =?utf-8?B?NjBTbmM3bUhHd2hRUkY1Tm5sMjdLUS85d2MxMm50bkxaSGFmQW5JNUkvOGlN?=
 =?utf-8?B?blJDNDZQaTEyeER2U1NCcFM2K1pqRy9kN0Uycm9PNXo1MjFFazV0cjlOVDRn?=
 =?utf-8?B?dU5GV25lSkM5bHIvV3c2RjIxcHlVUTlBT1gvTFJCZWtkWTNPT08vOGxTN1RJ?=
 =?utf-8?B?K1gwcDEyY2Y3ZS81THRyUnVYWWtscU5TLzNOcm9jb3cyclhESlkweEVEUjUv?=
 =?utf-8?B?clJnWG1TK2thQVV2T3lwNVptQ2JjSmdvU2FFTEFDZ2xvc1lCVjFtMjZsMUQ3?=
 =?utf-8?B?UnpwSlNsZjMxZnV3S2N5K2toT3VreFBWbjNIYlRvcExmQTZVU3VURTJjTG0v?=
 =?utf-8?B?VTF0a3F4L0xRRU1lQndES2NhSFB1R1lQWnhrbUdBbWJnVnc1MkRjMEEzSzlH?=
 =?utf-8?B?QnBEbWhJeERuaTAvWk5kZkNIL0hXVkYzNzFDaDh1dzNLRG5VTjBUdjc1T2U4?=
 =?utf-8?B?VHI5R3gzMVNnM1Vmc0VnRHAvSG90SmFrZEpKcVdyVUE5WGNsVHNmOURmMzAx?=
 =?utf-8?B?eFpFVjBWd1g2MkJKUm5WR3VUOHlpSnBSODIwcXhaWXBEWDczb2FPTSt4OUE3?=
 =?utf-8?B?UmFEZnlvUWx5dWhTQUJKSWtlSVJ2VGRmRVE5RnBER0lsM0FtRlRYYVo0L3JJ?=
 =?utf-8?B?T2Y2WTNCWnZXWUFJVjVNUVdnYTRqeFZuSHo3VmpRazRjU0d3VFd4dWNWZENk?=
 =?utf-8?B?N1d3S0dDdEtPak4rRFZPb3hWS3VaME13bjBoZ1Eybk9XNTJUbmV2ZjB5MGZG?=
 =?utf-8?B?ZnU5Z3BVVklka3NZS2hNVEVCN3dlcXdSZWRWOVdQeVFoRVk5ck9iY3gxb041?=
 =?utf-8?B?VTZMQTRlV09EdUgyM2dQTzBEOVhzMTd0d0x6QS9vWVVRU25hVUJuYkI3V3By?=
 =?utf-8?B?QUlOaXhQV3hYLzhFZXZYcmRwR05iZWwxMDZsVVZWQWJsSWVZRWRlK0pWdjMr?=
 =?utf-8?B?OXVHSDdNM1N4QTk3aDJxSTAyaTU2STc2UTM5eUtTUENlOTh6ODlOMjhVaERj?=
 =?utf-8?B?dEdqQlZsdk5OM3ZOellZbjZ6eW5zNWp6VDkvS3JZbkdOTW13TXRYcTBSTVk0?=
 =?utf-8?B?ajdOajNMbkFOR0g5SUFXTm5lOGlHQWxlSnAxOG1CZHZQc3lBNWM0MEZ4dUls?=
 =?utf-8?B?MnVXdXlxZER1NFNPZ3ZrQ3YvQlFVcnpVVktQd0o0dFZxdXBzazlNUG92M0Q3?=
 =?utf-8?B?VDd4WWdWa05WZjl3V1RVa21vTlJvUlc4OXlXcDd1bWlTUVV4bnZ3WE56VVZo?=
 =?utf-8?B?THN0Z3U1cHN5bDhLNVFoVVM5dStnYUZTb1F0b3FUYmNyTWtlZUt4UWhuTkNr?=
 =?utf-8?B?Y0xxSHZZb0RnSkdrNzBqZSt3SUR6Q1NFelh2UHFCMmt1N1BwQXJIN29TVDZD?=
 =?utf-8?B?WWcxWDNVREZSL2xVWU5RdHIxWVpBZThRNjd2WmpPMU8vQk9UUUhJTmIrckdn?=
 =?utf-8?B?amtZMkVCbUY3SGF0M2Radz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6369.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RCttOTdHSG9pdTE1Rjk1ZjNmSXduYkpJM3c0eVd6ZTVoS3UwTFVwWk8vdUhV?=
 =?utf-8?B?MUhYNVFHOGhaaWdpUXYvNTBlZDV3bXNYV3hUb3ZsclppTEhVYXlBcXBlaDZ4?=
 =?utf-8?B?VFRUNUlzZ3FzYlNxbXpqcDFDbTk4QlAyMWJ2aTcxRGRUZzhJRGRPOEdsSGpM?=
 =?utf-8?B?bWk4WFpUL3lpdHUwSHhYR3VIMHZGTGJlQjUwdmFkM3ZLNXdoWnB0MEhSbS9x?=
 =?utf-8?B?YW9VZklMQ2c4RmIrNkFWd1UrV0hlVGx1bkZvbkd2ZVI2UnF5WFRZejArdVh6?=
 =?utf-8?B?Mi9zV2lROFlJME52RnZWeS8yNi9TdTdqek16S2p6TWNDVXAzUmxKd2NqZm1Q?=
 =?utf-8?B?eG5NMjRPRGdVQ2JHQ2lMU1A0OW0xR01KV2xON3lKd2ZscE4vUGVoNXNzdHNl?=
 =?utf-8?B?WmJ2dHI3M2xyWWk3K2ZhelVwdm4yQUQzWGhjUWxiTnFXTmRXYUVqdlYyNXE3?=
 =?utf-8?B?SW15d0tNQkl4Sld2S3djUlZwSlZPN0huV1N6T005OGtjY1h5NE1xK1lwUElx?=
 =?utf-8?B?ODdBRng2MEpKblRILzJ2cUF4TEt5UVdVYzgwaHZqRURXSXpqS0huM0hITDZu?=
 =?utf-8?B?dFo5bEpXVGVaZmZLYW9GRWwxTjRpSzRFV0gxYXI3TCsyOTZsSy9iTWdIQXFV?=
 =?utf-8?B?aWNPcTQ2MTdXUTgwQXlQVXhWdFBROWg1OHhPTE04OGZ1d0ZhblVXQkd6bzNN?=
 =?utf-8?B?SlB0aEVzTVRMWjk2dXhrL1E5YUNZWTRsN2lJa0RmUnlSNlE1Q1lWanVQY3Zj?=
 =?utf-8?B?WXFhOHh6TGV2WHg5SDZpNmpNMVlOdVdCdHlYdTR1bmVZTGtGbXVKVmhMbW9N?=
 =?utf-8?B?VzlpT01DUS9RSFh3a1JVek0zeWROcGN3bjIwa20zRHNueFl6UjZ5dVgwTFU5?=
 =?utf-8?B?UkZZZFBUKy9SYTBIWnoweVBqR1QrUnhlY3NwWU95OEJodDkxUXFyY2dtekx0?=
 =?utf-8?B?YktXK1F1VEtkUUp6VllxTTRWZ0JCYnNSdWxGaW5ybnhBemNpeW9qS282cGo5?=
 =?utf-8?B?UGZDQzl5dHRtK0k4aEwrRlNBcmptYXFLU3BFWThPeDJBZjNXSGhaMjYxSVE4?=
 =?utf-8?B?UFlIRDVFYTdPc3BhNUY0UGF6ODIvM2RyNFhLcGl1dWFmQk8xZkxEVG00OStn?=
 =?utf-8?B?cGNUR0VwYW1CcWF3bk1QS05jeHV6a094eG90ZGtudUV1elVDcmNXSFlBOWhJ?=
 =?utf-8?B?dUdOR1l6cmdtZU1jRVBkWDlpdHVEdHJmcUl5VHZuOUNkWjAvTTZWM21acitp?=
 =?utf-8?B?dlUwNGErMFFKYzA1aDFxeURsc0UwWlVnTDV4MFdFejZKVzd4NTVtUHBwU1hZ?=
 =?utf-8?B?aUVEMHRCK0tMOUFaUi9ESUhxTXVwTUo1OVR1RVBBK1ZjSjZ5bWFJTzBWc2Jj?=
 =?utf-8?B?ZzVIZkg1VnVYbzV5d2ZTUUZLZnZrV1dYSTg1TE5zZ1N0dkQrTGlweWR3UmhP?=
 =?utf-8?B?MHlJRlRoZFZlT0ltT1pBTEp1R0xVQjhjY0I0S0xTaFdCYm1RRWhOcHVwZUZ2?=
 =?utf-8?B?clh5ODJxRTJ1NGdRYW9PU1R5dUxtVHJqMHBVYkd5bm4xMlJzRFZzeldzVmhU?=
 =?utf-8?B?cDJvQUxHdFpONEx6MGVuZUlUOE1rQVAxd0g4cU9FOEtzOHVpWisvTE9qMWlq?=
 =?utf-8?B?WkVVVjJ2L0owRHRXRjllWTBlVUZVT0V4NWVMemNSOGVuMVhKa1RUd0xtWlE3?=
 =?utf-8?B?bENGUmhaYzVlck5abG9IMVFjZDVnWkRzQnFEMjRKWXNZSnc5ZnNHcUxDdGNo?=
 =?utf-8?B?RktBemUya2RpNGV3dmFyYjZuekJvTDdWTERMZEtDZVdCM3dyWXQ4V0F6aEl5?=
 =?utf-8?B?TnZjbVZzdVdNQ0Z0bTdpWnhUVWFMbThPYnVVaThxSllLRzMzUlN5K3doNzdl?=
 =?utf-8?B?M0VIMU52cUNsd2c0LzBoV0g1c2lsczdNUFBRc2FzcmpVYWtOQzZ1K2k4SERS?=
 =?utf-8?B?R2VrNTlrazNoc1Vna2UrMzFtR2dVNW1EK0l6RWJEVnhVdXNiNUhEcE9JME8v?=
 =?utf-8?B?eU5XZ2pBUGY5Rk5Sak5lN2FLWlk3eDdLSUhwQmhrVkZvci92dUE0b1VjTXN6?=
 =?utf-8?B?NWpmKzJ0NkFQaGpGVmRCR3RCK1VzT0tBRXEvTk93L1VEL2hVemx5TWFnTDJH?=
 =?utf-8?Q?Hodr2A1LmH9NFy2DQsC1t8Ya0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35771372-7762-4cf1-fa8f-08dcdb58a044
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6369.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2024 22:48:07.4494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i+cy8nV5qCFW5Pj4f5yMLxz1nLhZahXdYrTDjC9016icAud47BiGMb/px1Tzr6iAcIN7lvXVE/aZtgvhtwlEGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6489


On 17/09/2024 17:09, Marek Szyprowski wrote:
> Hi Max,
>
> On 17.09.2024 00:06, Max Gurtovoy wrote:
>> On 12/09/2024 9:46, Marek Szyprowski wrote:
>>> Dear All,
>>>
>>> On 08.08.2024 00:41, Max Gurtovoy wrote:
>>>> Set the driver data of the hardware context (hctx) to point directly to
>>>> the virtio block queue. This cleanup improves code readability and
>>>> reduces the number of dereferences in the fast path.
>>>>
>>>> Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
>>>> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
>>>> ---
>>>>     drivers/block/virtio_blk.c | 42
>>>> ++++++++++++++++++++------------------
>>>>     1 file changed, 22 insertions(+), 20 deletions(-)
>>> This patch landed in recent linux-next as commit 8d04556131c1
>>> ("virtio_blk: implement init_hctx MQ operation"). In my tests I found
>>> that it introduces a regression in system suspend/resume operation. From
>>> time to time system crashes during suspend/resume cycle. Reverting this
>>> patch on top of next-20240911 fixes this problem.
>> Could you please provide a detailed explanation of the system
>> suspend/resume operation and the specific testing methodology employed?
> In my tests I just call the 'rtcwake -s10 -mmem' command many times in a
> loop. I use standard Debian image under QEMU/ARM64. Nothing really special.

I run this test on my bare metal x86 server in a loop with fio in the 
background.

The test passed.

Can you please re-test with the linux/master branch with applying this 
patch on top ?

>
>> The occurrence of a kernel panic from this commit is unexpected, given
>> that it primarily involves pointer reassignment without altering the
>> lifecycle of vblk/vqs.
>>
>> In the virtqueue_add_split function, which pointer is becoming null
>> and causing the issue? A detailed analysis would be helpful.
>>
>> The report indicates that the crash occurs sporadically rather than
>> consistently.
>>
>> is it possible that this is a race condition introduced by a different
>> commit? How can we rule out this possibility?
> This is the commit pointed by bisecting between v6.11-rc1 and
> next-20240911. The problem is reproducible, it just need a few calls to
> the rtcwake command.
>> Prior to applying this commit, what were the test results?
>> Specifically, out of 100 test runs, how many passed successfully?
> All 100 were successful, see https://pastebin.com/3yETvXK9 (kernel is
> compiled from 6d17035a7402, which is a parent of $subject in linux-next).
>
>> After applying this commit, what are the updated test results? Again,
>> out of 100 test runs, how many passed successfully?
> Usually it freezes or panics after the second try, see
> https://pastebin.com/u5n9K1Dz (kernel compiled from 8d04556131c1, which
> is $subject in linux-next).
>
>>> I've even managed to catch a kernel panic log of this problem on QEMU's
>>> ARM64 'virt' machine:
>>>
>>> root@target:~# time rtcwake -s10 -mmem
>>> rtcwake: wakeup from "mem" using /dev/rtc0 at Thu Sep 12 07:11:52 2024
>>> Unable to handle kernel NULL pointer dereference at virtual address
>>> 0000000000000090
>>> Mem abort info:
>>>      ESR = 0x0000000096000046
>>>      EC = 0x25: DABT (current EL), IL = 32 bits
>>>      SET = 0, FnV = 0
>>>      EA = 0, S1PTW = 0
>>>      FSC = 0x06: level 2 translation fault
>>> Data abort info:
>>>      ISV = 0, ISS = 0x00000046, ISS2 = 0x00000000
>>>      CM = 0, WnR = 1, TnD = 0, TagAccess = 0
>>>      GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
>>> user pgtable: 4k pages, 48-bit VAs, pgdp=0000000046bbb000
>>> ...
>>> Internal error: Oops: 0000000096000046 [#1] PREEMPT SMP
>>> Modules linked in: bluetooth ecdh_generic ecc rfkill ipv6
>>> CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0H Not tainted 6.11.0-rc6+ #9024
>>> Hardware name: linux,dummy-virt (DT)
>>> Workqueue: kblockd blk_mq_requeue_work
>>> pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>> pc : virtqueue_add_split+0x458/0x63c
>>> lr : virtqueue_add_split+0x1d0/0x63c
>>> ...
>>> Call trace:
>>>     virtqueue_add_split+0x458/0x63c
>>>     virtqueue_add_sgs+0xc4/0xec
>>>     virtblk_add_req+0x8c/0xf4
>>>     virtio_queue_rq+0x6c/0x1bc
>>>     blk_mq_dispatch_rq_list+0x21c/0x714
>>>     __blk_mq_sched_dispatch_requests+0xb4/0x58c
>>>     blk_mq_sched_dispatch_requests+0x30/0x6c
>>>     blk_mq_run_hw_queue+0x14c/0x40c
>>>     blk_mq_run_hw_queues+0x64/0x124
>>>     blk_mq_requeue_work+0x188/0x1bc
>>>     process_one_work+0x20c/0x608
>>>     worker_thread+0x238/0x370
>>>     kthread+0x124/0x128
>>>     ret_from_fork+0x10/0x20
>>> Code: f9404282 79401c21 b9004a81 f94047e1 (f8206841)
>>> ---[ end trace 0000000000000000 ]---
>>> note: kworker/0:0H[9] exited with irqs disabled
>>> note: kworker/0:0H[9] exited with preempt_count 1
>>>
>>>
>>>> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
>>>> index 2351f411fa46..35a7a586f6f5 100644
>>>> --- a/drivers/block/virtio_blk.c
>>>> +++ b/drivers/block/virtio_blk.c
>>>> @@ -129,14 +129,6 @@ static inline blk_status_t virtblk_result(u8
>>>> status)
>>>>         }
>>>>     }
>>>>     -static inline struct virtio_blk_vq *get_virtio_blk_vq(struct
>>>> blk_mq_hw_ctx *hctx)
>>>> -{
>>>> -    struct virtio_blk *vblk = hctx->queue->queuedata;
>>>> -    struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>>>> -
>>>> -    return vq;
>>>> -}
>>>> -
>>>>     static int virtblk_add_req(struct virtqueue *vq, struct
>>>> virtblk_req *vbr)
>>>>     {
>>>>         struct scatterlist out_hdr, in_hdr, *sgs[3];
>>>> @@ -377,8 +369,7 @@ static void virtblk_done(struct virtqueue *vq)
>>>>        static void virtio_commit_rqs(struct blk_mq_hw_ctx *hctx)
>>>>     {
>>>> -    struct virtio_blk *vblk = hctx->queue->queuedata;
>>>> -    struct virtio_blk_vq *vq = &vblk->vqs[hctx->queue_num];
>>>> +    struct virtio_blk_vq *vq = hctx->driver_data;
>>>>         bool kick;
>>>>            spin_lock_irq(&vq->lock);
>>>> @@ -428,10 +419,10 @@ static blk_status_t virtio_queue_rq(struct
>>>> blk_mq_hw_ctx *hctx,
>>>>                    const struct blk_mq_queue_data *bd)
>>>>     {
>>>>         struct virtio_blk *vblk = hctx->queue->queuedata;
>>>> +    struct virtio_blk_vq *vq = hctx->driver_data;
>>>>         struct request *req = bd->rq;
>>>>         struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
>>>>         unsigned long flags;
>>>> -    int qid = hctx->queue_num;
>>>>         bool notify = false;
>>>>         blk_status_t status;
>>>>         int err;
>>>> @@ -440,26 +431,26 @@ static blk_status_t virtio_queue_rq(struct
>>>> blk_mq_hw_ctx *hctx,
>>>>         if (unlikely(status))
>>>>             return status;
>>>>     -    spin_lock_irqsave(&vblk->vqs[qid].lock, flags);
>>>> -    err = virtblk_add_req(vblk->vqs[qid].vq, vbr);
>>>> +    spin_lock_irqsave(&vq->lock, flags);
>>>> +    err = virtblk_add_req(vq->vq, vbr);
>>>>         if (err) {
>>>> -        virtqueue_kick(vblk->vqs[qid].vq);
>>>> +        virtqueue_kick(vq->vq);
>>>>             /* Don't stop the queue if -ENOMEM: we may have failed to
>>>>              * bounce the buffer due to global resource outage.
>>>>              */
>>>>             if (err == -ENOSPC)
>>>>                 blk_mq_stop_hw_queue(hctx);
>>>> -        spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>>> +        spin_unlock_irqrestore(&vq->lock, flags);
>>>>             virtblk_unmap_data(req, vbr);
>>>>             return virtblk_fail_to_queue(req, err);
>>>>         }
>>>>     -    if (bd->last && virtqueue_kick_prepare(vblk->vqs[qid].vq))
>>>> +    if (bd->last && virtqueue_kick_prepare(vq->vq))
>>>>             notify = true;
>>>> -    spin_unlock_irqrestore(&vblk->vqs[qid].lock, flags);
>>>> +    spin_unlock_irqrestore(&vq->lock, flags);
>>>>            if (notify)
>>>> -        virtqueue_notify(vblk->vqs[qid].vq);
>>>> +        virtqueue_notify(vq->vq);
>>>>         return BLK_STS_OK;
>>>>     }
>>>>     @@ -504,7 +495,7 @@ static void virtio_queue_rqs(struct request
>>>> **rqlist)
>>>>         struct request *requeue_list = NULL;
>>>>            rq_list_for_each_safe(rqlist, req, next) {
>>>> -        struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
>>>> +        struct virtio_blk_vq *vq = req->mq_hctx->driver_data;
>>>>             bool kick;
>>>>                if (!virtblk_prep_rq_batch(req)) {
>>>> @@ -1164,6 +1155,16 @@ static const struct attribute_group
>>>> *virtblk_attr_groups[] = {
>>>>         NULL,
>>>>     };
>>>>     +static int virtblk_init_hctx(struct blk_mq_hw_ctx *hctx, void
>>>> *data,
>>>> +        unsigned int hctx_idx)
>>>> +{
>>>> +    struct virtio_blk *vblk = data;
>>>> +    struct virtio_blk_vq *vq = &vblk->vqs[hctx_idx];
>>>> +
>>>> +    hctx->driver_data = vq;
>>>> +    return 0;
>>>> +}
>>>> +
>>>>     static void virtblk_map_queues(struct blk_mq_tag_set *set)
>>>>     {
>>>>         struct virtio_blk *vblk = set->driver_data;
>>>> @@ -1205,7 +1206,7 @@ static void virtblk_complete_batch(struct
>>>> io_comp_batch *iob)
>>>>     static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct
>>>> io_comp_batch *iob)
>>>>     {
>>>>         struct virtio_blk *vblk = hctx->queue->queuedata;
>>>> -    struct virtio_blk_vq *vq = get_virtio_blk_vq(hctx);
>>>> +    struct virtio_blk_vq *vq = hctx->driver_data;
>>>>         struct virtblk_req *vbr;
>>>>         unsigned long flags;
>>>>         unsigned int len;
>>>> @@ -1236,6 +1237,7 @@ static const struct blk_mq_ops virtio_mq_ops = {
>>>>         .queue_rqs    = virtio_queue_rqs,
>>>>         .commit_rqs    = virtio_commit_rqs,
>>>>         .complete    = virtblk_request_done,
>>>> +    .init_hctx    = virtblk_init_hctx,
>>>>         .map_queues    = virtblk_map_queues,
>>>>         .poll        = virtblk_poll,
>>>>     };
>>> Best regards
> Best regards

