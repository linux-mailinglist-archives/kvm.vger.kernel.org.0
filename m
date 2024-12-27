Return-Path: <kvm+bounces-34391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B5A29FD27C
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 10:13:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D528A1883901
	for <lists+kvm@lfdr.de>; Fri, 27 Dec 2024 09:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3943E15665C;
	Fri, 27 Dec 2024 09:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nQz1va3e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2073.outbound.protection.outlook.com [40.107.92.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC698135A63;
	Fri, 27 Dec 2024 09:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735290826; cv=fail; b=Nut19YijD9lXyle5Bvs3F78dFnR5FOgvtNvEwbgwXHjUcJL0VNAi0U6RDFYg/409AOgyTkKtFlYiS30nvyQYRlUuaI5ZZ+aK48IpdLU9VhmQmvI1EqFFSPy8nKNh1kBUadSKm4ZzXSUSEYxV1O1eRc0qFx4bG+yGStTzVNPJB50=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735290826; c=relaxed/simple;
	bh=ScOHvzC16QqongpQjRvPmCTqwvwpspKmm9AOzw9yhuM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s8dAcOzErRtkptfK7vnQBjWhBBeGlnYe6BKOXp0vQKoZ618jMAeH9NjGxJ+lQlnJO9AbYpwrsJ+hqjkaVpf948dfC/wuIYEDAZvTcXiyqItVyCRl1A7Vkn1VmWdmecRs8feS9zz++p9uk+AHH5YXYnSYlh18Uc9hE+reX/WRcrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nQz1va3e; arc=fail smtp.client-ip=40.107.92.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xr3XGz4u91zz/s/dsJFXDIsMJ+Zs29vp3KpefYxRZU8hcWQXUGUH+TYrGI+rg5qJA3cHHfdzoYryCFbkA5RURxmoUGP1s0Hqbc4qCPJkbSeE6I4fSWHMruxEyXgBZe3FqBPnM70cLzPUWO6gLrvP3NJi54fW/HA3wHW2cidzzZ3Yt8EuRUJEhCHRSFvhufggbtbAT/yAiGaMiqOTfyvHCyWMv5aRYtjozum3I+0IanZz/nvpwnbTLH47ag0fMJfrqaJ4YI0rkhzg9jLid8rDossfGW+55bE8EvqR+bejWkdTwFwa5GlLlW8dJVIsfJibI2c/jq2cUlRZSXrzkbYOmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFKkykM7aUrxOkpWFxb2Kwpy+8zU8tYBd2g85+XS+j0=;
 b=ZPzAyGRkoLP1Me6Tukx5OqyKaKTS4XDRlkaSkIpGVJ6T29GHrNlinEQm0KWoMNp0Ay/vrTHLCSwhB6M2OimAtpo5/dskvV3nOfGvDDU8mj2hnC8cQWEtSw76QTWOSGew3b7QDhYHislUGj0GUiWMgjzGk25mH7uk0fIpv0KKJRaAlkqtxF9g34Ha6zsH9Th97a+ZcMTb9pq+f4eHU1NlIQR48WRuoPd9oILXGwG9WvBqeEJnvWIYhKk6zBq8X+rmr0AiyxOgaF8C5cN4pmwL6RxO7sQ1zUw7fq/SuB5zO4VZy++cGkfjcNbYJ5xm33kajdD6eDcD1s8MzWeGBdOsKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFKkykM7aUrxOkpWFxb2Kwpy+8zU8tYBd2g85+XS+j0=;
 b=nQz1va3epHbZzwyQXPZD8wQCBCjfxObVDyMiqQ88oeP6TPgH+O7+C+jXrqa8Rybkr6qqaQ7sK45kOV2ds3Rut9HTagoe9IPLRZXcs6Q4xnHS8O/2naTHV5gHMVHR6zKdPwKb3GTMCtde5JJxNgH6mbyrOknsOLs4RMhMVL3aj4A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by IA1PR12MB6233.namprd12.prod.outlook.com (2603:10b6:208:3e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.15; Fri, 27 Dec
 2024 09:13:38 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::53fb:bf76:727f:d00f%4]) with mapi id 15.20.8293.000; Fri, 27 Dec 2024
 09:13:38 +0000
Message-ID: <912eb75b-f756-4c9e-af66-225412f69488@amd.com>
Date: Fri, 27 Dec 2024 20:13:29 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 4/9] crypto: ccp: Register SNP panic notifier only if
 SNP is enabled
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: michael.roth@amd.com, dionnaglaze@google.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-coco@lists.linux.dev
References: <cover.1734392473.git.ashish.kalra@amd.com>
 <a148a9d450b3c1dfd4e171d2c1d326381f11b504.1734392473.git.ashish.kalra@amd.com>
From: Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <a148a9d450b3c1dfd4e171d2c1d326381f11b504.1734392473.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0075.ausprd01.prod.outlook.com
 (2603:10c6:10:1f4::11) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|IA1PR12MB6233:EE_
X-MS-Office365-Filtering-Correlation-Id: 108140bb-b201-425b-ff24-08dd2656bf9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K3ZNT2Q2Q2dGU05HN1M1WmFnc1RKWkxLZlpjRFZYS0NhWUdSTnlpSllYc3l3?=
 =?utf-8?B?T2ZVSG5yZ3ZFbnZLdEZzNjJsYkF5RHEzK1FtekdYc2J4VERTUkhWY0xuV1Ro?=
 =?utf-8?B?TTNUcUd5alZvWDlpQzArb3B2UzRNM0NKMldKQTRZZFhNWUpoNnVWMVROd2hI?=
 =?utf-8?B?Ti9DUDYwTmpsK1pXZTgzYTIrdEJHcDM0akFOcm84ajM1WHZMWEIwZGt2ODBG?=
 =?utf-8?B?OHlaZzV1aENoVnFRNlpzMkYxWnZmUGhNT3cvRktoclF6bnRvYjI0bEh3cFgy?=
 =?utf-8?B?djRuNEc2bk5zNVlCbk9kcG00eUNpa095enRtL1NKZG5Oa2FXRGtoM1ZWZnJD?=
 =?utf-8?B?TDFnb1lnZnYxQWU3bHdmbTBKdU1RNUZSSHJYZGRITDczRllBQjluZEJVZm1L?=
 =?utf-8?B?bEJNZnRhTVloSEZzaHJJNlBqbldyaXFHOUlOa1Q3alFLeEtTTlgxa1BMOFVT?=
 =?utf-8?B?S1hkalBzUklwWEdxeVJmamEyNUV3QjRKRm0yNHBpQjdDRTQ3SEg4eW0wNUxk?=
 =?utf-8?B?UDYyeUM4bllicnJ0V1lLQndKT0JUMU1XUXlza3FlTUpiMENtamdWYzRKWUxW?=
 =?utf-8?B?dGhlaURORGYxVk1DTWxlQW9SbldTd1hzWVhtVjFDMndJZFRlbzdoTGpwSEhH?=
 =?utf-8?B?Yk1HRURMNFBWbmo1WEc4SU93amtEOHNqWndqSDQvL2FNQndLWmh4T1JaTFNP?=
 =?utf-8?B?OG1HV3RjVUpKUHFrb2hZQVZZMHAyQWRGOUFkT0NRTjUyMlhoc3pIbWxmRU50?=
 =?utf-8?B?dmU5cDBxb2tKY3BIaVpCdXEwbGUrSWFXK0pWTThQRERIdjNKUnpzT2pEZENJ?=
 =?utf-8?B?YklpUCt3OGJVZlAzWGF3VEFOSXM5aU40WDFtdDhGaFF0RGtJMVZsRXJMcXRH?=
 =?utf-8?B?Z1duekt2SlNJKzRHdTRDc2VEVEcyeVphaEQ1dkVaV0hXSFExUU9CazRQRnA0?=
 =?utf-8?B?eDhxZkJYUUZsdEdHUGtTWWpKWHJ2M0MrWWNUN2JUWTlaUnN5NElCeTQrSzR1?=
 =?utf-8?B?ZzA0eHlLRmd3WmhsNW9jZDE2Rm9pVzVyMGlCRzNHdlY0eHUrYlU2UktUdWkr?=
 =?utf-8?B?ZHJLMlljTGR0cHdpQldzOEw1bDFBdFVZOXJhczV4d0N4enhOTUVYRDdTOVA1?=
 =?utf-8?B?d0tpVHQ4TWRGWDFRcHBNVzUya3g5bDF1SG1vbUZNeTBnS3ZmK0ZJSkh0dnFL?=
 =?utf-8?B?RTZ6UFdQRktXb2Z2ajJ4enQzNEZMK0NFN0wzQlhCVVNGemtJN044SlVleVE4?=
 =?utf-8?B?Vkt3N1VkelFQMnJPcCtEcm8xUjB0TEdodlhXWVN6V2IxdDg5aWE4YmgxRVlI?=
 =?utf-8?B?SmxDQzR4cjFHK245elZ4enJBbkRYam96WjFSRldMUW5VcU1qTC9zOG5EUUVP?=
 =?utf-8?B?cFU3NG01ZTFqNlFDQlFObVZUOUFYOXczVTVqWVY0aHk4dHNHcHM4dDZxQ3E3?=
 =?utf-8?B?dGdlQzFBMFNCL1F5MGZIZzdjZ3VkaS9lMWFPb1VVdTFCZkRtVFBVRjFQdFI3?=
 =?utf-8?B?VXcvMHBCb0dHS0hDak5TSmloMTVuS3lNb01XbE5sdWovaGZCdHRjNkpLNFB4?=
 =?utf-8?B?cUUvZXVjK3pqMHRTR3RNaXBEUDY5QitSRnpNYnA4ZU1MSko3MWFmdlB5VGFI?=
 =?utf-8?B?TjZ6VUUzaGNoSERBcDhIL3hSdElRSXk5dGJpdWE3cFRaNzYyVXZPbFBqSFgz?=
 =?utf-8?B?ditsczFMZnBBZXZMaFFzOGtFOHBzZkJUbjBZYklTSmNEcUlRN3lJamd5LzZE?=
 =?utf-8?B?TFcyQ214MmJ6ZlJoekdadFQ3VWttMUIxb2Q3NEgvTGM5MDhQOTlENW9QM0c1?=
 =?utf-8?B?NzNpdmxKZkRFTWN3Yk5SZU9OOTlIK0s3QU56WFZPazUvV0lLN201OGxrVTI4?=
 =?utf-8?B?WTZzUXFJa2xzV3ZVbFRZMFJTMFFLTVFjVU54V2VxVmhBTTRHdEplZklBVzZo?=
 =?utf-8?Q?DAQruit0JCI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dFA2eVBaK2xhWUU5bFl1K09mbVB3YU1ZWGpQc2ZPOEo1bi9kSUdWeVczdHhT?=
 =?utf-8?B?RjJGdzZjWjdIQ0JYU3JiTXBGMFJ4VFU2cUxkaFp0MFBrM1d4d2xIc2lhd2xY?=
 =?utf-8?B?OWhoanRvbGZOeUowcmgwY0JHdnA0dS9BRnFBdFBXMTRiV1RlUlFCbTBZT3E1?=
 =?utf-8?B?WHZJSm1uSW9vUWZRZ0EzMW5TWDFCQTlnc3pIVlYyekorWlE4bWF6N3ZTWmo5?=
 =?utf-8?B?NGNkdGRndFRSQlgzeVkvODhocjVaTkRlYi9TY1dlamtPZnUyZ2xDeWRFM0Ju?=
 =?utf-8?B?eXVkMWZPQjQ4QW9FRWtuUkN6VTNZZUZFN3pmVENaSHEwS2F3VDBWTGN5TEd2?=
 =?utf-8?B?WUR2T2tzYWplVG1RY0x1UHp1bk9qS25ONThiMmVxOWxSVGl4RmZMUXNPd2Zu?=
 =?utf-8?B?Rm5BcFJIcDVFdDRvdk5qOXB1eGptS0htSzVEN2FRMWV3YUd6YTNKZ2k4RjM4?=
 =?utf-8?B?QnJiOHdDbjQ2YllYTmJraWw2cUFSNGZLanJDdlB4QnhiTkZoeWhoaWxCcGpE?=
 =?utf-8?B?MkVsd05qNjhqdXFsckZ6YnhQaVlWaFJRdzdBblY1eFZLaCttQXJ2UVhZSUpN?=
 =?utf-8?B?bi9tejZadXVVayt5TWs4Qy85NEd2SUZwMFk1c2Q0bTQvNDlQV3VneTRvR3lR?=
 =?utf-8?B?aHZON2JpZlBHUm91TVlOWHFtRmp4WlBVU0hXRmpwSEFFTzJ0aVBUbW1CWGRG?=
 =?utf-8?B?V0pIM2dXWmhXb0piMzhrdkVNenB1MDBpQXJPc05BQ2dReDZyYTdCTVNkZFV5?=
 =?utf-8?B?dTJMTmZSSkl4V0tYZnpKeUw5NHZOOHI4ZVdRVTlZOVNySFZZWUlkbmltVG9t?=
 =?utf-8?B?MWZmZnBWZGNPNzZhL2VnK0hoOGdSM2NiR3lIeWNPTXNzNXloMFNtejhnZTFC?=
 =?utf-8?B?T1VkU0t1NzZadER5SWdGMnk4SE4vSXE3cHEzOUl5azVtZGVPaGhIV28ybjB2?=
 =?utf-8?B?Z0dOZ2RWdlI2K1ZqczltcU9Gbjd4Y3ZoWDFHSytHMFJkY21TTVRzWDkreXAw?=
 =?utf-8?B?TEN5VDBxMTZFY0NjWDkzTm9GUDJlTzJZbEZSRkw2dW1NK2lQNmExNExDN3M1?=
 =?utf-8?B?RUdZVVFiU3hhS0R6bnpMcHg4Tk9EU3ZFK2RWN01NS3FYR1Q1bTRIR1R5VDE4?=
 =?utf-8?B?dXVFWXJza01iSVhkSFRwR0NIZlVuZUl1MGVwTkZoR1pXYW9STDV2aXNEckp0?=
 =?utf-8?B?YUVFUlFQS2NaeEFKdVJBZTZmdE1seUh1dGMwYzBSVVFxQ3RNVmxMQkhJQm1p?=
 =?utf-8?B?eU5RMXZiM3p1NS91MlhMQnpiZmpyZlNBL3plUlRSbmNqREloOVZ5eU1OV1J4?=
 =?utf-8?B?WW56akZPUFNmUzc5ZG05TS9WdGljS01hSXFtQ2t0TkJoVUl0VmJ4TGRDTVZ0?=
 =?utf-8?B?Snd6MWlMQzhiWGh3a01Gb2kzMFVrbDlERkhwQ21ZcHNORFJtWjhFRGpCZ01v?=
 =?utf-8?B?dWJGayt1TE4vY01ZaE5HVSt6dk04SFVESjU3SHlRK3RZN2VsY3hrQmQvV2ZD?=
 =?utf-8?B?UHlLelFCcGNSaWRkbnV6RnZROXo1ckFTQTJuaXhIZUdkMVM5bWZ2NDhtUlBv?=
 =?utf-8?B?cERmNGZnR0MzWi9YcjF5SGFQYm1HVmZwZVdyYW9LUE1SSC9BaUVMd045dmxa?=
 =?utf-8?B?VU9VUUJSSlhHZDNlN1lZTk5PUUVweVZocjBIcXI3WHRpRzRCZ0pLSS9Wampu?=
 =?utf-8?B?WWNJQzlaT2RLM2pYWkpRaUZKYThjS1d2UDJMSzFXc21Ld2YxV29Ocy83cFE2?=
 =?utf-8?B?ZWkwZVZIckVSQlRBWnJGbzl0dDBNUXRnRVhtdnVLS3E5THIxVFp0TElJeWtj?=
 =?utf-8?B?YlBFV1VrUjFaSG8ydmdmNnNWa2Fack1RL0NXQmF2RUNEWk4vdDlWQ2V2K0pw?=
 =?utf-8?B?MGRXaDNOeTRJWHZUaFExZ0cvWXB2RVBpMzUreFlraG1YQzRhUWFXTzNwaTJV?=
 =?utf-8?B?RXZENi8yM3kyKzZMcDRRekYrMHVUY2ZEZHRSZWlwRFhNY2swdEN6MFRrbC8x?=
 =?utf-8?B?dENJdC9yb3hGR1JxOTEwMXVtZ1dobTFuK3ZYUDFMUk5ZVlpmTldRYlNmMzA5?=
 =?utf-8?B?WVNlUUNvNjc0Q0JIMFlmL2JFOVJSU0RrQi8wcHRla2hWZjhJVTVmUTYrTGFl?=
 =?utf-8?Q?lGat12zX6fqNGKEVH5+xN2GSD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 108140bb-b201-425b-ff24-08dd2656bf9c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 09:13:38.3415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J/0WmLJG5uPWf+rDCEUbUmiGkkdnOjF0Wjm8KiJfZ3bbHYIKlSf05Yfu68P7mnXHVYolYmp0biwMbM47VpBIJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6233

On 17/12/24 10:58, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Register the SNP panic notifier if and only if SNP is actually
> initialized and deregistering the notifier when shutting down
> SNP in PSP driver when KVM module is unloaded.
> 
> Currently the SNP panic notifier is being registered
> irrespective of SNP being enabled/initialized and with this
> change the SNP panic notifier is registered only if SNP
> support is enabled and initialized.
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++--------
>   1 file changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9632a9a5c92e..7c15dec55f58 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -109,6 +109,13 @@ static void *sev_init_ex_buffer;
>    */
>   static struct sev_data_range_list *snp_range_list;
>   
> +static int snp_shutdown_on_panic(struct notifier_block *nb,
> +				 unsigned long reason, void *arg);
> +
> +static struct notifier_block snp_panic_notifier = {
> +	.notifier_call = snp_shutdown_on_panic,
> +};
> +

A nit: I'd probably move the hunk right before __sev_snp_init_locked(). 
And the body of snp_shutdown_on_panic(), just to keep SNP code together. 
Not sure about the result though so feel free to ignore :)


>   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>   {
>   	struct sev_device *sev = psp_master->sev_data;
> @@ -1191,6 +1198,9 @@ static int __sev_snp_init_locked(int *error)
>   	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
>   		 sev->api_minor, sev->build);
>   
> +	atomic_notifier_chain_register(&panic_notifier_list,
> +				       &snp_panic_notifier);
> +
>   	sev_es_tmr_size = SNP_TMR_SIZE;
>   
>   	return 0;
> @@ -1751,6 +1761,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
>   	sev->snp_initialized = false;
>   	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>   
> +	atomic_notifier_chain_unregister(&panic_notifier_list,
> +					 &snp_panic_notifier);
> +
>   	/* Reset TMR size back to default */
>   	sev_es_tmr_size = SEV_TMR_SIZE;
>   
> @@ -2490,10 +2503,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
>   	return NOTIFY_DONE;
>   }
>   
> -static struct notifier_block snp_panic_notifier = {
> -	.notifier_call = snp_shutdown_on_panic,
> -};
> -
>   int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>   				void *data, int *error)
>   {
> @@ -2542,8 +2551,6 @@ void sev_pci_init(void)
>   	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
>   		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
>   
> -	atomic_notifier_chain_register(&panic_notifier_list,
> -				       &snp_panic_notifier);
>   	return;
>   
>   err:
> @@ -2561,6 +2568,4 @@ void sev_pci_exit(void)
>   
>   	sev_firmware_shutdown(sev);
>   

can remove the above empty line too. Otherwise

Reviewed-by: Alexey Kardashevskiy <aik@amd.com>


> -	atomic_notifier_chain_unregister(&panic_notifier_list,
> -					 &snp_panic_notifier);
>   }

-- 
Alexey


