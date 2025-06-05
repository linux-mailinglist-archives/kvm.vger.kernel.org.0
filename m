Return-Path: <kvm+bounces-48458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 015A8ACE76F
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 02:17:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B68DA175362
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 00:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22777C120;
	Thu,  5 Jun 2025 00:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5uUsr4LO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C26417D7;
	Thu,  5 Jun 2025 00:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749082631; cv=fail; b=Tbi5j83sgDVJeGycFMW0B9ss8fzAmC2nJmIt0DxF0GcIky3izw8X6BqZDU5cpsUke6kpHkw24MJPRV1upEsIm3QKLPpJ32iLO+ZXjtwJqaoDetz3ui37O+TJU9E+ly42J6kRUB3nFzYWwKSNBUKbLC0iSpfrzPefRg0mB4/kLRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749082631; c=relaxed/simple;
	bh=tEsTkpeXuXPqKdwj9iIjigU9ON2O0WP7ZpnKj6LrC3M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aX0hbA6ZJ6WKjUUjuaNxocUbr7m9t4Smi2XLLfJRUA5u0AE3isev/tTDN+BP7rtES1eS+KseqUjvfwwTDIG4pwMjX1fYmx1E9eLTFfHuPJxgP6GDPqFls/TTphGCcJSBoOY3WTIliovGS9qUag5aV7QUrb7xl8Dyg9nHnqz4f28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5uUsr4LO; arc=fail smtp.client-ip=40.107.93.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bjm53kMXfTeFmAtcuzSMQlm8z446OCmvcMjltA5/64WeeTibbpBi8owud6z9W87FQs48DTra1QNfeLz0nS84uHdm3X0FR+0z48cygS4+14lizysyee56VxsPbYHuVYAHqmwYHgtoBrVTevXql3H3YpZAT+t1lBe/joSKXRiMl4nRmd5JQ5UFpd8erU4IYFIVf8iwjMkltOGG9DsBbKqPkrB+Q1MJXR/1nttQZR5h4Hk+5IY4wVJUJ3J52UfsryuiLaY/1W9AVY/Q82vf4FtIb/9Yo1j2oKyZMoAACLM2L+jDC1DuMxaEDE/aDtZfUnWjLK5Sn7ll5FSqo/q1TIK4vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6A6aBvxMIbwcXMni4lrgwalqVfB/2Pkoats0SayziNI=;
 b=c/zAfij6AMEIRDshNZzfWuVLptbmyQZocEfN5e1PxdzY3R/NCTA5LwUuYuifFCiwOzuyvgr0niBua9XgmqJeqLB19cZz1fLnWzbypOKBNwfSo6754pj55Wa/6f7vepSpxMk1yy0vRBfAElE8ms6pVwP8F1fZKsl9/r02f5VIeZCfT5fJB9AkHQQRXEbr5WO/ZKUTgd4Ff6utlx2TTz4ZSV6Y9tc+LRyWVRNKyWr/39LMAWPZkJWLtw4n8FUIpCUMH42BEpmZx9we5OdI5HZ8YPQGe2cEswovUl4/Bp4c6qjqFCKvpomM7avQbUthagMJYC/rOd8S+rg1xGNIdMtIkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6A6aBvxMIbwcXMni4lrgwalqVfB/2Pkoats0SayziNI=;
 b=5uUsr4LOjYrm2hujSvicrJEfMFFl5JzEIPeveo5ArY64lybqlDgG+CV/Y3aI5UUm1ptHXz+hkBP3N4wxAd/y83Boyj8EsFfhIxx2QVnfQkVmDoc5i+/zN+GvYufE/gscRLgSapP1Ogs3QRCSRMgQxZRcFSvDSTJBY6NM+Q2H9Oc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by BL1PR12MB5923.namprd12.prod.outlook.com (2603:10b6:208:39a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Thu, 5 Jun
 2025 00:17:06 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%5]) with mapi id 15.20.8792.034; Thu, 5 Jun 2025
 00:17:06 +0000
Message-ID: <11700688-98a4-439e-bcd3-44ca51fcaa14@amd.com>
Date: Wed, 4 Jun 2025 19:17:02 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: Tom Lendacky <thomas.lendacky@amd.com>, corbet@lwn.net,
 seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 herbert@gondor.apana.org.au, akpm@linux-foundation.org, paulmck@kernel.org,
 rostedt@goodmis.org
Cc: x86@kernel.org, thuth@redhat.com, ardb@kernel.org,
 gregkh@linuxfoundation.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
 <a6b39023-447d-67bf-9502-4340f9d41c81@amd.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <a6b39023-447d-67bf-9502-4340f9d41c81@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0103.namprd12.prod.outlook.com
 (2603:10b6:802:21::38) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|BL1PR12MB5923:EE_
X-MS-Office365-Filtering-Correlation-Id: 871b2670-336b-4a8c-b1bd-08dda3c64dee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RzhxNml2dlJFL3BYY3hTQkVET3F3VkFndjBXWUxTL1FUckwySUNtaUdjQTQ4?=
 =?utf-8?B?ekdpVWVDRlQ1c2RzT3FiVmpSWmxGMXV5SytWa0YvT2FINWU0MmdyVzVIUTVU?=
 =?utf-8?B?UC8zYkl4eEZzNisyR0w1ZDdRelpGZldyMFhXLzZMQ2tIMDNxTmJWb3dJWGhI?=
 =?utf-8?B?ek1YZ3hGUHpOcktoTWhmQ1BwUVl3WnR2Rk9uaXR1NDlrQnB1RitFSnRnQ3Js?=
 =?utf-8?B?UU41TlJBT1c2c210cDErSTZyanlHaExQcHlseWFlVUQ3KzByZWJ4Vnk2dDdo?=
 =?utf-8?B?UEpQSGtCVnNtOE9heGdZRUFwSjJqK1ltV043NGxrbnZObWhIN3JoMjZqa0R2?=
 =?utf-8?B?bTFxTjF6YWdDT3JQcFVCRlNmM2ROd21ZeHQyaUFrZFdIR1Rya094VlB6ZzVB?=
 =?utf-8?B?cmJ6Y0JEemRhS1FtYVVDOWFaQXMydTFDczhkR09YYjIvK0tGSjVPRGg0V3Nq?=
 =?utf-8?B?Z1UwbkZUcE1RVXJtWWJjN1lLcGZ0RHBCaXdmTXNMc0liSkxBdHFlVGZGdGk4?=
 =?utf-8?B?RHFiWFk0Z3VFVGZFUWFoWndkeitiWmlzeUhDNTRBazBnOGpDTzREZEtYWHJH?=
 =?utf-8?B?Wi9rOWpiWWc2Tkk5N2ZJSzBYclR2WUhjbmVsbVNnWVU4TElISHZIcDBZNEEz?=
 =?utf-8?B?TEZER3B6a0dXTWJ4ZGZZbWEvb2xQQXBJRmJPejZhdHdxTWZvTUJGKzI2ZjMy?=
 =?utf-8?B?WWxHL29UYlNaTnh4bnBpUTZVZUJodEh2MTFzTnBINHR1VzhzMUZzUFQxYXhE?=
 =?utf-8?B?Q29aTDRhTFhjUit3WERhV0lVbDkrbFErdVMwQzdGcGNKcW1XbkkrUmdOWk0w?=
 =?utf-8?B?eTdlNzJWeUhSRTY3bHA4S3d0eGFmMFZVUVg5TnZCMkNucjRnYjAyV0JxSWZP?=
 =?utf-8?B?Y2VFSXdvblkxNzFGRklWdmQ3N3FRTEtKZEN0T1FCcGM3QTN5eHZRNzNNeDky?=
 =?utf-8?B?WjZNUVNmMno4c0tWdUM2WXEzdVhEUHYvMDhJcVZqdUM0UVROWFFZMEFOMHND?=
 =?utf-8?B?ekhMeDZTVGpzeitoa0cvUXpLYm5rSW9WUTF1SzgwWjBFRGtrMkJGdnJnWXJt?=
 =?utf-8?B?bDVBV2JUWXBNWjJHRzFRK1BvS3MxMi9lcmMyM2FTS2phaTN5VGVSVGpQWHdz?=
 =?utf-8?B?N0l0K0oxcmZDZWY5SVFPaU5TTmM3cjc5cWZNS2VSVzBOeXNrbzBzWGo5UjAx?=
 =?utf-8?B?T2h6bEQzL21BNUgvK0phbjlvRzVoQTVLRlZzaWxmU3ZRaDhKMWREWFEzWEF4?=
 =?utf-8?B?RUhhZ0J1cW1GQTdNQ3UzS3hSdEo2cDhhSjBiS0lvalFvdmhMOGl5QTNqNHBE?=
 =?utf-8?B?YUJVWDhoK2t1QjQ5MjY4LzNTSENMRXVOSUkzY3EzeTg2Zm5XUFM3ZzVWZGky?=
 =?utf-8?B?bGJYWjBRVmliUGdQeE44Rlc0cDZjUk9ZVlg3ZmZmUEpKdll0MzFGYzdTMWY2?=
 =?utf-8?B?RHJZR1NCMUVhRkRXSDVFbVJaTERCNVdZTm5hWFd1NWhFbHcwaTRiSHVUQXFP?=
 =?utf-8?B?ZkZXNDlKNmdqOS9DSThvdDdHTjNRRjhzTFpBY1ZBam0rWEc1RUNRS0hEeU5R?=
 =?utf-8?B?VktWa3djMFVWY004clBsMDdxR0VhaE1tekdtNVV6UTJEM3dhY21DV3RnamVJ?=
 =?utf-8?B?ZUxsczNsY1lsUWJwTm9naTd2bFl3cWJKZ2t0d3BqMEx0VkRqcjVkcEg1UGZV?=
 =?utf-8?B?VHp2MVlxY1E2SEJpZVlPR3JHSVBxYTE1V3BkczNlZ1p0Q2s1UmVrTjFxZ2lG?=
 =?utf-8?B?aUQvWmUwVDZpeVJHK3lTRHg1M3IrNTduVnk4ZVIxVkhhMUlOWGw1RXlSVGFz?=
 =?utf-8?B?aXNta1oxMmk1QzI1ZHJmN3B0QzZGQVV4MDZOQU9KOGd4cERTME8rZE4wTTdi?=
 =?utf-8?B?cTkwamQwOHdSVHBVQkZXc3o5c1JyQVpOdzNWbktQQ1hpK1ZLSGdLczJwZzVr?=
 =?utf-8?B?Nm1iSE1oVHZUU29iaVB6bnhwekt6VUpDMXpEQXkvalpWUTI4ZitUSlNINmF0?=
 =?utf-8?B?UjJpMHNBWDhnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OU1sU1ZXQzBQS1VlNzRRTkZiTUpxSE1FSVMrUW50WXlLTXlhQitNVWlUZlNn?=
 =?utf-8?B?QW03YXJneHN5R3lzRENlUUc4UU5KS1VZWTljd1c3SUNxSDVCblVQUGpLd2hD?=
 =?utf-8?B?clZ1UU9QTzdXTm1ORk0ya1hrWnpjWWlOelFISDNra3M3dmxIZCt2UWRHWGVV?=
 =?utf-8?B?bFFZbTFCbzAzTE1jZlBmc0pNeENVS0R5Wkk0OVRUSTJ3QldUbkh2NUxIUFBv?=
 =?utf-8?B?NkRlZDVRb3F4bUVKOW5sYWtpcXVkQVNwNkQ5TkZ1dGZMMDVqN0xEdDdUeEds?=
 =?utf-8?B?YStFQnhOUW1NMUtPU3YzRVF2NEJPalJaeFZYaFVUNU9hNTdOMitUT3FnMVVy?=
 =?utf-8?B?UE9GcFdsUUFLSkZNcE9PdVBCN2wvTzFkcXZvNlBHV01la2psU1NXT293cjE5?=
 =?utf-8?B?MS9MQTBEV2tYUUVTejgzNEppK25zSlhrRmJ4UXozRjhhdkFKcFpHZFFmMjNR?=
 =?utf-8?B?elhMNk42T0swMGM3TExyOCtwTnB5Wkd3em9ZTHNVMVdLT09PbWJWanN3bmhY?=
 =?utf-8?B?bUtzdGVIVlhhZ0FrMmxZNDZMMjdnbzJjeW4rL09DRkY3akRISE0xMDZpU2Y2?=
 =?utf-8?B?eEY3VXV3SmxUZi9nQzJlcjRJN3psR1FXRzU3UmVVYjVCL0VSdHdYZ1I3em9M?=
 =?utf-8?B?Z004WHNQcnJJYXRrSDJ4YnZkZTR3QnZBRE5oMTBFUUQ5dlR3eCtPRVZNR25Q?=
 =?utf-8?B?ZitiaU9pdUxzOVpPMEU4eFdEbU4vU3ZKVjJwVERYS2hYZ0ZWOGxHRkZwYS93?=
 =?utf-8?B?ZjVLMWRRV25ZZFlLamJEYzhnSUVXcE1VTEdiei84VzZvcTdENUhjK3FVcHZ0?=
 =?utf-8?B?bUZweUpvdHZDV2dISGVnTUZlMnVSdHZCcEIyRmlYTnhyNWVOVjE2VU1Lcko3?=
 =?utf-8?B?Nkd5WlV4UkZrVklLc0tjdHpQM3dlTFFXSDZzVXRxOEFCajM2dm41YWlwakdF?=
 =?utf-8?B?VTY5Ris2bGNZTWluSUZBZm5hODlTOU5KcGNobWVzaGpJR1BrZzNXdzJ6SDdr?=
 =?utf-8?B?c1AySlcrSDF2S1N5ZFdodHpsNlpMKzVSRG1GQXFsV1VNZ05pY1NtUmFrdGFr?=
 =?utf-8?B?dnAvTTJrZXJ3NEh0bGdMNUYxL1FQSzZzSWtkSitoSHFpcy9wOVo0em1Qa21q?=
 =?utf-8?B?VHpzN0QwNFhqeW1sWk4zUkxuTDQxc0FWMWtsOHJUR1RKK09zVFV5YklhdWw2?=
 =?utf-8?B?T2FFMmFDRDBGVE9uVjNwNFFKOWZYL1pqVDZ2M3laU1VkZW43c0d4TUdlT2N6?=
 =?utf-8?B?dXVMUmI5aFpyVU91aXJrR0JJNzZ4b3ZNbnBGNlVTWFlhakZEalNLem9SYXlp?=
 =?utf-8?B?U002SUNXeGVZZHdEaUdkczhzQlA0NGExRWdlUnE5ejN3OGhCcFFJSVFtRXJu?=
 =?utf-8?B?dzlJdy81QXMzVWJtUlZjamJRNk9EMG5FTVNISU1MRkpZbnRkY0lwRW9HUDNM?=
 =?utf-8?B?Mnc3VHAvell4enNoNStyWEVqWEdwU1FjeGJWMS9kOVB5R1VDc2x2NHAzVmlh?=
 =?utf-8?B?WnNqaFVubktQMVMySFBSczJIcVgzOTJsRXZacjh6QXo5cHpiYlFjaXFhbkRq?=
 =?utf-8?B?Mk5IUUlNNzN6K1doV25GcFZvWWk3RFU0bHRiTzY0MERkV0ZtWkQrclphbFBJ?=
 =?utf-8?B?TGxCWWVsZnNRb0liSWpNMjZ2d2ZEbWtza3lpT2J2Y3pvWTQySGZQeXBoeWwr?=
 =?utf-8?B?Zzdmc0FaajdlNzVWUlZKY3VreVFrWS80clQ4VXlORGdTamNyY3drQkdvVVNN?=
 =?utf-8?B?ZE5vM2thb3BlRSsrYkdaWGdxTHU1WW1Sd215cHhTcXRDT2Iyc2swT1BvbUdw?=
 =?utf-8?B?UnJHd0F3VjhRT3NKQXlDNUNURy9mSlU4SzBJSlhQTk1ndHpVZnhDeUwwQmJH?=
 =?utf-8?B?TGtmMzhWUDVZelJCRjZka2d1Tk1RaXdrVE45YnZEMWMzRmN3VGVTMG41WlFG?=
 =?utf-8?B?dHcrVTc5NkZ1RWNYRS9mQ2EwZ2JrNjZnZkRwN1NKeEduNzNNcUk2a3ZXWEdN?=
 =?utf-8?B?Nzd3N1RuMVJzNnRIam5EOVVHVXJIbG1Ia09OYmI4R3Fhckh5M2s5eFRobVVN?=
 =?utf-8?B?dGxtUUNNWFdoOEI2R3lUd0tXQ2hOamFuTG0yRlFMeVI4QWRXU2t0M3lSSmRW?=
 =?utf-8?Q?4R7/sCV6RfkeVKSnoagoZ3ime?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 871b2670-336b-4a8c-b1bd-08dda3c64dee
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 00:17:06.4516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M7ixDJaRQ17ZIMl9QUcIYz3GcVpVGD2Q1k23Sk/68JvHlJkl59h4cDT7iHQJ8CY0dan8m5BNt0SqrKvhVD3cPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5923

Hello Tom,

On 6/3/2025 11:26 AM, Tom Lendacky wrote:
> On 5/19/25 19:02, Ashish Kalra wrote:
>> From: Ashish Kalra <ashish.kalra@amd.com>
>>
>> Ciphertext hiding prevents host accesses from reading the ciphertext of
>> SNP guest private memory. Instead of reading ciphertext, the host reads
>> will see constant default values (0xff).
>>
>> The SEV ASID space is basically split into legacy SEV and SEV-ES+.
>> CipherTextHiding further partitions the SEV-ES+ ASID space into SEV-ES
> 
> s/CipherTextHiding/Ciphertext hiding/
> 
>> and SEV-SNP.
>>
>> Add new module parameter to the KVM module to enable CipherTextHiding
> 
> Ditto.

Ok.

> 
>> support and a user configurable system-wide maximum SNP ASID value. If
>> the module parameter value is -1 then the ASID space is equally
>> divided between SEV-SNP and SEV-ES guests.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> ---
>>  .../admin-guide/kernel-parameters.txt         | 10 ++++++
>>  arch/x86/kvm/svm/sev.c                        | 31 +++++++++++++++++++
>>  2 files changed, 41 insertions(+)
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index 1e5e76bba9da..2cddb2b5c59d 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2891,6 +2891,16 @@
>>  			(enabled). Disable by KVM if hardware lacks support
>>  			for NPT.
>>  
>> +	kvm-amd.ciphertext_hiding_nr_asids=
> 
> s/ns_asids/asids/
> 
> I'm not sure that the "nr" adds anything here.
>

Ok.
 
>> +			[KVM,AMD] Enables SEV-SNP CipherTextHiding feature and
>> +			controls show many ASIDs are available for SEV-SNP guests.
>> +			The ASID space is basically split into legacy SEV and
>> +			SEV-ES+. CipherTextHiding feature further splits the
>> +			SEV-ES+ ASID space into SEV-ES and SEV-SNP.
>> +			If the value is -1, then it is used as an auto flag
>> +			and splits the ASID space equally between SEV-ES and
>> +			SEV-SNP ASIDs.
>> +
> 
> Ditto on Dave's comments.
>

Ok.
 
>>  	kvm-arm.mode=
>>  			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
>>  			operation.
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 383db1da8699..68dcb13d98f2 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -59,6 +59,10 @@ static bool sev_es_debug_swap_enabled = true;
>>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>>  static u64 sev_supported_vmsa_features;
>>  
>> +static int ciphertext_hiding_nr_asids;
>> +module_param(ciphertext_hiding_nr_asids, int, 0444);
>> +MODULE_PARM_DESC(max_snp_asid, "  Number of ASIDs available for SEV-SNP guests when CipherTextHiding is enabled");
>> +
>>  #define AP_RESET_HOLD_NONE		0
>>  #define AP_RESET_HOLD_NAE_EVENT		1
>>  #define AP_RESET_HOLD_MSR_PROTO		2
>> @@ -200,6 +204,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>>  	/*
>>  	 * The min ASID can end up larger than the max if basic SEV support is
>>  	 * effectively disabled by disallowing use of ASIDs for SEV guests.
>> +	 * Similarly for SEV-ES guests the min ASID can end up larger than the
>> +	 * max when CipherTextHiding is enabled, effectively disabling SEV-ES
>> +	 * support.
>>  	 */
>>  
>>  	if (min_asid > max_asid)
>> @@ -2955,6 +2962,7 @@ void __init sev_hardware_setup(void)
>>  {
>>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>>  	struct sev_platform_init_args init_args = {0};
>> +	bool snp_cipher_text_hiding = false;
>>  	bool sev_snp_supported = false;
>>  	bool sev_es_supported = false;
>>  	bool sev_supported = false;
>> @@ -3052,6 +3060,27 @@ void __init sev_hardware_setup(void)
>>  	if (min_sev_asid == 1)
>>  		goto out;
>>  
>> +	/*
>> +	 * The ASID space is basically split into legacy SEV and SEV-ES+.
>> +	 * CipherTextHiding feature further partitions the SEV-ES+ ASID space
>> +	 * into ASIDs for SEV-ES and SEV-SNP guests.
> 
> I think it is already understood that the ASID space is split between SEV
> and SEV-ES/SEV-SNP guests. So something like this maybe?
> 
> The ciphertext hiding feature partions the joint SEV-ES/SEV-SNP ASID range
> into separate SEV-ES and SEV-SNP ASID ranges with teh SEV-SNP ASID range
> starting at 1.
> 

Yes that sounds better.

>> +	 */
>> +	if (ciphertext_hiding_nr_asids && sev_is_snp_ciphertext_hiding_supported()) {
>> +		/* Do sanity checks on user-defined ciphertext_hiding_nr_asids */
>> +		if (ciphertext_hiding_nr_asids != -1 &&
>> +		    ciphertext_hiding_nr_asids >= min_sev_asid) {
>> +			pr_info("ciphertext_hiding_nr_asids module parameter invalid, limiting SEV-SNP ASIDs to %d\n",
>> +				 min_sev_asid);
>> +			ciphertext_hiding_nr_asids = min_sev_asid - 1;
> 
> So specifying a number greater than min_sev_asid will result in enabling
> ciphertext hiding and no SEV-ES guests allowed even though you report that
> the number is invalid?
>

Well, the user specified a non-zero ciphertext_hiding_nr_asids, so the intent is to enable ciphertext hiding and therefore 
sanitize the user specified parameter and enable ciphertext hiding.
 
> I think the message can be worded better to convey what happens.
> 
> "Requested ciphertext hiding ASIDs (%u) exceeds minimum SEV ASID (%u), setting ciphertext hiding ASID range to the maximum value (%u)\n"
> 
> Or something a little more concise.
> 

Ok.

>> +		}
>> +
>> +		min_sev_es_asid = ciphertext_hiding_nr_asids == -1 ? (min_sev_asid - 1) / 2 :
> 
> Should this be (min_sev_asid - 1) / 2 + 1 ?
> 
> Take min_sev_asid = 3, that means min_sev_es_asid would be 2 and
> max_snp_asid would be 1, right?

Yes.

> 
> And if you set min_sev_es_asid before first you favor SEV-ES.
>

Ok.
 
> So should you do:
> 
> max_snp_asid = ciphertext_hiding_asids != -1 ? : (min_sev_asid - 1) / 2 + 1;
> min_sev_es_asid = max_snp_asid + 1;
>

Considering the above example again, this will still be incorrect as with above change:

Taking, min_sev_asid == 3, max_snp_asid = 2 and min_sev_asid = 3.

So i believe it should be :

max_snp_asid = ciphertext_hiding_asids != -1 ? : (min_sev_asid - 1) / 2;
min_sev_es_asid = max_snp_asid + 1;

 
> 
>> +				  ciphertext_hiding_nr_asids + 1;
>> +		max_snp_asid = min_sev_es_asid - 1;
>> +		snp_cipher_text_hiding = true;
>> +		pr_info("SEV-SNP CipherTextHiding feature support enabled\n");
> 
> "SEV-SNP ciphertext hiding enabled\n"
> 
> No need to use the CipherTextHiding nomenclature everywhere.
> 

Ok.

Thanks,
Ashish

> Thanks,
> Tom
> 
>> +	}
>> +
>>  	sev_es_asid_count = min_sev_asid - 1;
>>  	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>>  	sev_es_supported = true;
>> @@ -3092,6 +3121,8 @@ void __init sev_hardware_setup(void)
>>  	 * Do both SNP and SEV initialization at KVM module load.
>>  	 */
>>  	init_args.probe = true;
>> +	if (snp_cipher_text_hiding)
>> +		init_args.snp_max_snp_asid = max_snp_asid;
>>  	sev_platform_init(&init_args);
>>  }
>>  


