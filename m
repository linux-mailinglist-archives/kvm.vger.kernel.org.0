Return-Path: <kvm+bounces-61302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CFDC15620
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 16:19:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5CE785639DA
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 15:12:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB6B314B80;
	Tue, 28 Oct 2025 15:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="opjo2xGf"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF5133A00C
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 15:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761664282; cv=fail; b=ko7i1wlbMpMINh20f+YAukAIhJLHYTAYQ8yWVKPRM+ZSTUuJoLP16S8vGtX9avIGzmlqPKAabkKdWD2Ev50MYXifSBQEj+i6soUZx3eCXX/1S4X+1dIJ7pK/d/RBvTNd4UXI9/LbtvwNYp5feYs7DEejyhGMqSdAWI3s7ciZ3Ec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761664282; c=relaxed/simple;
	bh=tgc5RXuEyNQzyuEphns8C1qei5MAWY8p262p53sYrpw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DT+1Blsuz42L0c6YcVDzp2GNS71ZuLtW48aMIriatwiuD+ivEuQkSL+M1kRRmUL6sSHCXJsnLpOB8Tdlo+mCeFFgTUCSv6ZjxuLyV/LdYmjiJYeAeNm2pvync7f4jYkxRlLjRZekRZqRZCORH8enZA7Cjn6KZmqtO34hWBApZfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=opjo2xGf; arc=fail smtp.client-ip=40.93.196.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B7vlF17hmY68JMfoXvdg8V3mE29OLkj6yeczBvObsf4UCjdo+/0B9JIZmyV7ianiR6GnqV2W/v5Dhfl6QNi51eCzFwqAE8XZyQzgocNaCStjQD+aPYSw8DtEyZh1hDU2FuqEYcv7kvaHJ/TdWYIOxx//PD9VJizQT2wmMMvzbOom0fQZ/DYGVrWPSf+SmCx9HzqNod4qy7PbLYNXae1lAVw/mS1AQc1hzZ8HQxEPZxdOcmNjhSkqxeBajfhRPxs9CtvUK66xuxQSh/F5rznj1JCJmLA7+xPJGu2/03asqKjP7ifoha+8g1fHERB1Ur9csjBUymfhrK66DPlTqfaUPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Q64VwV7iXwL5eBaLumfkQvRYsqQQWel7ol03J1YTMY=;
 b=xVRvJJVhPvjAdwMa/Zx83C9+AXMNE0EiemIThNY57ZBVPjExIqStS8yZGKKDVNU+NF6GPKJtSmwLS0QTu0n6/3/voEfZBPbVlX6V9w5iAfRuOW8ZtsYN8XEUCGl5KSfLbZ55uOSfvarY8INHlR/t0xq0PJ1fDMRf5XJYa4tljHJ7KGF2eCXesQtZiFZkU9kihkD+MEF+JF/Ch8u+fVHB8gjwUmL3nS+t++rGedSppqfvu6GV70SMw0Y9QJkighogYd3mWghugUm7yFz/ekkBWrGW/dzO3IEt15+SGiyX29koFYPqz4+5rptQUds7r4k4truKDZa+iwqauL7OkjBy6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Q64VwV7iXwL5eBaLumfkQvRYsqQQWel7ol03J1YTMY=;
 b=opjo2xGf2mmVBJ96cFvfHMBhTUe4psEkzh6TZJgs9FqdPoddTfJ7x5W9yjCMFCXX6OmAMTsoXzsaXIMZeyHKGI+Q1zvR/jxhDN3o0z56ZEq/cn/YSWU87R4lyv6xSfEEKot0Fse1ldchKG+MwRjIbJmnZfSGQC5vGmw5gtgz+dg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DM4PR12MB8451.namprd12.prod.outlook.com (2603:10b6:8:182::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.12; Tue, 28 Oct
 2025 15:11:15 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%4]) with mapi id 15.20.9253.013; Tue, 28 Oct 2025
 15:11:15 +0000
Message-ID: <acb88951-b46f-4a08-8cd7-4e2d20e153f4@amd.com>
Date: Tue, 28 Oct 2025 10:11:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] target/i386: SEV: Add support for setting TSC
 frequency for Secure TSC
To: Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Marcelo Tosatti
 <mtosatti@redhat.com>, qemu-devel <qemu-devel@nongnu.org>,
 kvm@vger.kernel.org, Nikunj A Dadhania <nikunj@amd.com>,
 "Daniel P. Berrange" <berrange@redhat.com>,
 Eduardo Habkost <eduardo@habkost.net>, Zhao Liu <zhao1.liu@intel.com>,
 Michael Roth <michael.roth@amd.com>,
 Roy Hopkins <roy.hopkins@randomman.co.uk>
References: <cover.1758794556.git.naveen@kernel.org>
 <65400881e426aa0e412eb431099626dceb145ddd.1758794556.git.naveen@kernel.org>
 <6a9ce7bb-5c69-ad8b-8bfd-638122619c71@amd.com>
 <uzfmnzzhz7a7lghdpazb2sphtctphmsj2nyfqnu6erjt44h577@bjj57um7n2ze>
 <a8a324ba-e474-4733-b998-7d36be06b7f7@amd.com>
 <boyf3kr7uo7jnlratgmgaklm2a4leg37hsgfno5ywsl6qvbcvo@5dwlbncvaogv>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <boyf3kr7uo7jnlratgmgaklm2a4leg37hsgfno5ywsl6qvbcvo@5dwlbncvaogv>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:806:130::14) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DM4PR12MB8451:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b7e694b-d2c2-41d5-203c-08de16343d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWJnSjJFVGE5NzY1Smc0UCttUWtPTXB3anJwWVROcXUwU002QVZrMzlLNE9h?=
 =?utf-8?B?NnBRNzNoNkIwdjhOM2kreGUrRlFuRVROVnRLUkpwTlg5anpnTzNzSGwzYVZE?=
 =?utf-8?B?dUwrNkcxQm9CZmZYU1FJWjBsb1dmYk9tdklJMTJEeWxJa3hRWHhQTy9nVXpr?=
 =?utf-8?B?WlRPbDRxUXY2WDdDMGdUYUxkVGhCZHcwMWJyNnpnYXpkSE0rTytQazBYUDdj?=
 =?utf-8?B?QVl1blIxd2szOUdwbjRScjBLSUF0TWJmY3dZYkhhSUtSZ29WTzY2bG9Yc20v?=
 =?utf-8?B?a25EOGFMU1QxWFlWb1BwSHBFaU1pSlo5K2JMUHFqd3NyYmJpVWdEZnJibkxU?=
 =?utf-8?B?OHJ1RzFURnpZQWU2TW9aM0RHMno4UVFROFlUYkNKaVJ4NG9VU0ZGcnh4aWhx?=
 =?utf-8?B?NXIzQUtmUFNQQms1eThNcUxTTE5CY0puWmN2Wk9seFNOYkcwUWVEVURDYlRD?=
 =?utf-8?B?NkJGWWRoejZXTzVLT3IxNXEwM1JZVVdhZzgrSDRQSi9NV0hDeFRkSFpnVDQ1?=
 =?utf-8?B?V0ozZTZKaG9wc1BRYTdxUUZ6eU0vWWUvczBlK3lwcS9kOEU4SEltbXEycENR?=
 =?utf-8?B?TUNsSk1NWDhXSkFNVkYwNEFtdDRRQzR5RDdnbmFKamlJbElLejRnZW5IUVZt?=
 =?utf-8?B?T3lHUTc1akROVW5WbWRhMFkwVW9Zc0pWTE9nbVFpMFpGbDh5d05uNjVsRkxT?=
 =?utf-8?B?VXF4NWo5MmhHbzQzSWUvLzNGeS9lWFI4cnNWTDU2aTVOWWc3RjNwb1ZsdWFC?=
 =?utf-8?B?dUIxcGJqejA5OEhSdFNvMStFd1pyeXRJNERQK0VGSnovREVOblZ4UDArVE1U?=
 =?utf-8?B?TWQrMW9vKzhBbTlpUTZFdnl1dFpCaHEzd0c2SVlJUDZiWVkwbVpFQm1mMjdW?=
 =?utf-8?B?bkVMMVcwWFZ0WjM0YUVqRDhQeU1IbVZOQ3BkQkorM3lEMkRkaXY2cVU1Vmc1?=
 =?utf-8?B?elQzUlFJbms0aGVmVVhzc0p5ektHWUxHbng3T0FscjdaNVlQOFM4d3lsSmRZ?=
 =?utf-8?B?aG1iK3gvTkIxQi83UkxEc0M5U1dkKzlOdzFzTDdPTUp1QXNTZWkxTGNYSFZn?=
 =?utf-8?B?Z3gvbTAxaUZobE53dFhMVHovWDBOSzh5YzY2cEhJT3c5K1BlZVFkbmIyVlVt?=
 =?utf-8?B?WU1qM2dkNXhGeDdyR2JGUllaYmJaQkFSdm93OGo1UDJlOUtvcXlaK2lDQ1Av?=
 =?utf-8?B?dUQrZENvYkl1YTNtVFc3MFpzQ1lHUnltZGRQaDhQZ0MvdDUyWmlMVlBubDQz?=
 =?utf-8?B?Rm4vR0hVYlp2MVhIUFpRTUErL3FGWHozM2RoS0ZqVEE4bDAvMlpDL0JKMllZ?=
 =?utf-8?B?L1dqc2VDMDcwbmNzNCtibnA5ZVdPdkN1VkVEakd6M0xxNUo4RU9PamFGQ0xB?=
 =?utf-8?B?SXYyYy9ESGgzK0paWjFjcEVkQitnVDYxTXNnUGRIZ1FrOFlEMVRYTnpUdldE?=
 =?utf-8?B?SjAzRERYK2lRdXpoRUZhRjdhenc4NzYycllXd1RXUjdRUzRnTWp6eTZqRERz?=
 =?utf-8?B?bXBPU1FxVHVYUEVDL0N3SHRyTngvbitSUEFmL0FIYzZxOTdXdlNZZjROR2xN?=
 =?utf-8?B?dDBmc1VlK3NsQzc0OUZHb1FOYXIycVhKOUsxWFNhT3R6VmgvM1J3UlN0ejVi?=
 =?utf-8?B?OWNRb2JqU1ZzVjVJUG4ya1FyNzdVM1d3WC9pNHNSbUgwZkpNeXYyZ0RWUzRU?=
 =?utf-8?B?MG5Ld3Z2akMxQU9SQUQwYjR5NGxzZ3dCNkFZdEFDbExYWEtIYkRIZTBqWHpo?=
 =?utf-8?B?YXNBWktubFpGVjlxMTJ6ZlVhOUh2Vno0d0tzK3d3UkQvWFY5MnBmVFpqZTZZ?=
 =?utf-8?B?VkRobWthSzVIY24xaW5teGpEbUJRcHU3Ym5oQWlmOG1hMmc1VDJyR0J2Mkdi?=
 =?utf-8?B?RitmbGJlbW8zK2VGSmR0Z3JOLzlVOE9VNUpwVWhEYWkzTTcyRkhYeDREdWFN?=
 =?utf-8?Q?dryVidhJB2nSs7Y5cbk3AL8aT2oJjJ9b?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWxUT2ZGd2ZnakJRZGZjcm9oc1l1UnRrTFN5bUducit5K1hPSkJEV05nU3Yz?=
 =?utf-8?B?RU9kOEtwTEE5bzRwY2tuWDZjZXo2TDJJalVvYXA0T2VvUDF6T20xVUx0TDUr?=
 =?utf-8?B?TUthVEtpdnlWVVYzVEZNbUl1U2dSdFJ0czZwNVE2dEkyOGJ3NVRML0RjdHVU?=
 =?utf-8?B?NzFBR3JQTHhxb0E3UG9RSVB1QlNQd1VRZ1ZNOXJiUGc5TFpkNm90V1JwRTRt?=
 =?utf-8?B?RDZvcU1FUWxocTlhTGFWZWlFVkdyb2ZKMlRzVlE5OGZ2bHM0OTRHV0Q0dksx?=
 =?utf-8?B?VTBrU1ZRMTNrMDhnZXBFamlhNWVZNjNUZWpHQ3FyTTNpbmFCVm5EWnRudk1T?=
 =?utf-8?B?Qi9mVGIvNld4SFpuT2Y1RUwwNmNsYUw5ZFFldm0rd1BVc1g1UCtWbEd2eWw2?=
 =?utf-8?B?b3VpTkEvNXBaVVJXbHRTSk1zSVNHS0NVMGNDRDRwV1J4emRiM1FISk44RG5a?=
 =?utf-8?B?RmRuMDI5Wk9JS1RpclQyV3FVTEF4TnliQ2xwREFCZEFPeU9pczlsWDVJRHY3?=
 =?utf-8?B?NWhNOXpJYnIxeGxRY3ZORGtTb0hTTzZzeU9EektoejJ0VWhjMUJCdHBON3Jp?=
 =?utf-8?B?YWh1bDBaU0NCbnJhRnBUV0JCRW5mSGI0WGtuZ0p3TTR4V3FOYlk2N1hkTUVQ?=
 =?utf-8?B?WmlZWEZiQkVhNmIxdlBsOExKTUhhNnRsNUtYSE1sUDFXdzM4czRkR0t4K2sz?=
 =?utf-8?B?UDFsTllLSzdUNzNFTVpKYXBtZUN6ekp2QVVYbUdUY1J4MFlkbGxZSVFXd0xC?=
 =?utf-8?B?bGllVEJhYW1nWW5ZVm53VnFwNXpPMEN4RUEreTRUQ2puaElvN2M0aDZEbFJ0?=
 =?utf-8?B?THE5YlNYN2J4UitTYkNiVWhkcmJmekUzOE5xaW1qT2lDUHhmL215WWxwaFZn?=
 =?utf-8?B?WjkxdVZsZS9qZXkrNlBxQzArVzJFditZVkMxd09VdG10bWdGZVkxbElTKzZY?=
 =?utf-8?B?bWVPanAvekdrUUxoc0N2bzg4ZGN5SmRra05SMVBBNFIrMGlWTDBiVW9CN1ph?=
 =?utf-8?B?L2xlS084UU1pejZvVHNFTjZremhKVlZtNUh4QlluK3Q2UnpjZHA4VGEyQWZK?=
 =?utf-8?B?N2g3dEVrKzB4SWhiWFdwL2QwWUtvS21xSUdmU1M1M2FwaTZnSGFreWZiM0JL?=
 =?utf-8?B?M2MzV0UvT0NOa010dmRMbWgweVVidFBsM0VFbUo1bjVLOWNJYnlzYzd5R0w5?=
 =?utf-8?B?aWljd01peHVwcEs3blcwSGFpT25HUTVwM2xuNFhDYjIwWG0reVRKTUpzUGJy?=
 =?utf-8?B?Tkt2NiszUDBtSlhRWmowWWUxbTZma01odHlKWE5GUG5pdGg1WThndElOemNT?=
 =?utf-8?B?ZXRkeFhvemlQeElaZW0vWHBkNTQ2b3ZubWJVb3hRZXBZZURyUHdvVzVab3Mx?=
 =?utf-8?B?REQxVUtFUlh6TUVhK1hIQlZJdnhyeE5oK0JINGx2alcxQjBFZE9oR2RlTmdh?=
 =?utf-8?B?WFREbWtCK1llOVc0S3ZWLzJxUGJ6dXY1UXNxOWdkNTlvSXdjcklrcklrSHhI?=
 =?utf-8?B?Y3UwVXVqR1ZINDhkQk1pUHowSjN4elVPWm5hcVBkUzFpQUN2c3VKNy9CdWto?=
 =?utf-8?B?V3JCVEFoU0M2SXpNSVY3RENXbHEyak1hSE1QVzhrVzJqeWI5dkNNeGVuUlhJ?=
 =?utf-8?B?OGlZMEd0T1NCNEtHYVE5aUZYRGFyNjBDRm5wQ3ZJdmp4NFBjYzRGUmtsRTlT?=
 =?utf-8?B?TkZaSVQyZzlIUEtnenc4NTNWMEpES2ZiTzg1WGI3RzRlN1pDMXRiSkJ6NXZF?=
 =?utf-8?B?V0VMYUMzRXBUTHhqOEluNEFzeHNlc3lBdzFXeTAwY0l0WDVaR1pFckJTdUMv?=
 =?utf-8?B?ZlZDR2V5OW1qNUJsUFpjUmpBN241V0p2R3pJNTR4ZkhvNHBZZTBDbGVLdGgw?=
 =?utf-8?B?T0JEbk81WEd5ZkNlaEszWjY2MlFhOUswL3VPRUtXb1pZaWplOTUrWjAzUzcz?=
 =?utf-8?B?cStrZTBKMW1ibDlWUjJSTE1MWE1ac2VJWExCYzJNK3BnYnNqVHBNSXNEeW1t?=
 =?utf-8?B?RXh0OUcxL0ZoelhhemJoWDdUMGMxTFpxbW9TSGZWYUVyOWVWQjUyR1pXVW41?=
 =?utf-8?B?bU5scjFKZXpuTUU3UDFKVzdtZGE3MjRQRnBkVUI4UWVGY2JkRUVCNWI5Tklh?=
 =?utf-8?Q?FUmRso77t6a1NJiONyvb06Bkw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7e694b-d2c2-41d5-203c-08de16343d0b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 15:11:15.4423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kUphqBOEx73rAZAR1pfTNpEmfmxAl3k0ninQRD0+G6O2wrJp7mjGndWTIOHYhD1znN2PJXdz2S5mz+S0IYKByg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8451

On 10/24/25 12:16, Naveen N Rao wrote:
> On Fri, Oct 24, 2025 at 10:00:08AM -0500, Tom Lendacky wrote:
>> On 10/8/25 04:52, Naveen N Rao wrote:
>>> On Tue, Oct 07, 2025 at 08:31:47AM -0500, Tom Lendacky wrote:
>>>> On 9/25/25 05:17, Naveen N Rao (AMD) wrote:
>>>
>>> ...
>>>
>>>>> +
>>>>> +static void
>>>>> +sev_snp_guest_set_tsc_frequency(Object *obj, Visitor *v, const char *name,
>>>>> +                                void *opaque, Error **errp)
>>>>> +{
>>>>> +    uint32_t value;
>>>>> +
>>>>> +    if (!visit_type_uint32(v, name, &value, errp)) {
>>>>> +        return;
>>>>> +    }
>>>>> +
>>>>> +    SEV_SNP_GUEST(obj)->tsc_khz = value / 1000;
>>>>
>>>> This will cause a value that isn't evenly divisible by 1000 to be
>>>> rounded down, e.g.: tsc-frequency=2500000999. Should this name instead
>>>> just be tsc-khz or secure-tsc-khz (to show it is truly associated with
>>>> Secure TSC)?
>>>
>>> I modeled this after the existing tsc-frequency parameter on the cpu 
>>> object to keep it simple (parameter is the same, just where it is 
>>> specified differs). This also aligns with TDX which re-uses the 
>>> tsc-frequency parameter on the cpu object.
>>
>> So why aren't we using the one on the cpu object instead of creating a
>> duplicate parameter? There should be some way to get that value, no?
> 
> I had spent some time on this, but I couldn't figure out a simple way to 
> make that work.
> 
> TDX uses a vcpu pre-create hook (similar to KVM) to get access to and 
> set the TSC value from the cpu object. For SEV-SNP, we need the TSC 
> frequency during SNP_LAUNCH_START which is quite early and we don't have 
> access to the cpu object there.
> 
> Admittedly, my qemu understanding is limited. If there is a way to 
> re-use the cpu tsc-frequency field, then that would be ideal.
> 
> Any ideas/suggestions?

Any Qemu experts know how the SEV support would be able to access the
TSC value from the -cpu command line option at LAUNCH time?

Thanks,
Tom

> 
> 
> Thanks,
> Naveen
> 


