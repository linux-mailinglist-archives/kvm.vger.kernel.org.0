Return-Path: <kvm+bounces-17792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2761E8CA1E6
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FB9F1F2194D
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:18:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D411384B0;
	Mon, 20 May 2024 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="imOPZB3X"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FDD138497
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 18:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716229087; cv=fail; b=LgyRqfwYKFw71VfEZ0vXRLTaMz0tq1mOaWeU8vbQiCkr1mlPGo9gwzWXbe1KYyQH3O4J1I0u2Q2jnseTlTosw50O3N5AZbt5SHKvrGVhBmxqnmQFqxbTteJ6dZ6hJaPElBuYKbIpoGdQPWOeg+wUHszO/k+zXt+Zl8fVZh3Md6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716229087; c=relaxed/simple;
	bh=2s3tIPrEMGzP2LPY2MlnDAUFcocjzyTLLSp+EjfDLEo=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WX+JjSf6toEXPd1EHbzG6n6BuEzu3cje+WUWabjId3mnCVaE3VNhgOX7IBEOFtHccEiJTD1/DUwI33GcSePrYtm2i0s1CTEVe9lbDnCKSzQq5g6svfvPPSUSHfSI3BOBSDn+LHrx/MD0QMSGGD/NPlWX17mG6J8uKlqym3WTXL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=imOPZB3X; arc=fail smtp.client-ip=40.107.100.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R6Xay/o7sHkNQgH6rOJGfoJR2EHzGirqEePt8PnxvFimVc0leQX2RVGnUZgCD2GiZe/3DMy69AxPBMmBTcwBWsZTOlIDrDoqaINIndD2eB3POlIYTsMSBUr0gAVHtsm1aTsDFDF8/9lJD3ZlwlYEEgph8CNi7n2cSX9Fvv1wK8Q6bv1HpXFLQ+2ZtX+zW+WN44btvnRaZD2I0sbK6C+2+JnydrbklLu45DYipPIJiqt+9W8jWt0gOkEmAjX8XXCem40b+35ShHvtbWuYyNKumWjppL0l5YOLfmmaaRTW7TVrwTLybWPb3Fa0I+rmDjPRTIJDEP9sUWS06cbMCi1ylg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=flghxVTFFDYRMZyZE2pEdouR6EMHXBrANdzsjT/EF5M=;
 b=eF+bCjkyvttzOt/7SfOmF48EdQ4ofZ94dCb8rwCIY5qSYeAIZ8qtLGB42wTi9nvrQvfhaWaBwAEdSikFQmqU3RFJrmhW041M8UC7k2Gq6zyD5hG4Tzh1ttXIf/e2Z8fsJAuesYRM0lkV+P9KwyqM9jdjOVs1I4jsYQ6glWCAQ5bOpd3ei0p6MgrQpwzKUdjuFhifb73p+a3qebhl/M8MlF8LL5Yhp9R8YlLbeBNP4w6A0RX4xCjmShDx2JhrZB9Jw4uNWoRA3S7S1O+tJqRbl+vDP4FzDH4zicgdH4azzgJLSrHl/BPfzIhXHcOyPw810lV1Gvv4eh8JVFWr4KsQxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=flghxVTFFDYRMZyZE2pEdouR6EMHXBrANdzsjT/EF5M=;
 b=imOPZB3XkcCPVNjopTqRM1FdkICBPC1MrGZenAIbmVWfNqXau+4Gqlg+EVrfMf/e2xLgDOaz5piwAwJU6TwzoRDLe43qVqMlpyuiPsEb16IeGHjQRd1B7Qauyo57tLsKyQfVjgCtEZtqwwDU7OXyO/ggPq5j5XFkRur7Qcp0yfg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by IA1PR12MB6212.namprd12.prod.outlook.com (2603:10b6:208:3e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 18:18:01 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 18:18:01 +0000
Message-ID: <2bb83829-b9f7-dc2a-3ad6-f235e75c2c64@amd.com>
Date: Mon, 20 May 2024 13:17:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v3 2/3] KVM: SVM: not account memory allocation for
 per-CPU svm_data
Content-Language: en-US
To: Li RongQing <lirongqing@baidu.com>, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, yosryahmed@google.com,
 pgonda@google.com
References: <20240520120858.13117-1-lirongqing@baidu.com>
 <20240520120858.13117-3-lirongqing@baidu.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240520120858.13117-3-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0164.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::29) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|IA1PR12MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: ca407a5c-3239-4025-5f5f-08dc78f92edd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MXhPZnJ5OFU4cTlLWXVILzhqOUlIeG1nUUJtMGE5a0lWc3QwdFFnT05VNVNX?=
 =?utf-8?B?dkZiOGV6akJGMWVnWCtlcFMrWkVjY0p1a3Z0RVNYWk9DUXYzdHJOLzZlckg2?=
 =?utf-8?B?OU4wanh1OWcwNi82cmJxL1VqaUVMVFlVYWoxYkRDY1o4bFUvSzlkeUEvOUVQ?=
 =?utf-8?B?M2dDVWt1ZHVUdUw2QTBHNDgrRm5XTlB5K0l6NDAzL0hvOXc2SGxydHoyNVl6?=
 =?utf-8?B?WUZGNTJERWljeHJLUW85UnQ1TUdYZkVUN1ZPSnVuVm1PTEc0cE5Gek9Mc1lY?=
 =?utf-8?B?bUg0d09MWGlTUWtLbitiZVdEM3U0UDhFUDN4ZUtYRWFKODZPV0x6b3Jaa1ov?=
 =?utf-8?B?QldWVStTLy9qTmN4RExYdStEM3FIcEI1dERVbDEraktCdGk2WElMdDk3NTFG?=
 =?utf-8?B?L1ZNN1ljRWJVTFFJVzY0bTN4TFR4MmM1MnZyaDlGd3Q2eHpUVHFlWDl2UDJH?=
 =?utf-8?B?ME5pT2hFNHVQeEFqWTNiN20xV1RiQjNkOGpUWElZZnhwbm04eE1EWVBTTTlU?=
 =?utf-8?B?UFY2THJwT0RaYzZtb0FTRFdITWtNVGVuUVJFWWx5S0lUajVNRWsxR3hPb3k4?=
 =?utf-8?B?TzZQOWxOTXhHYVJVNEIxbk9FQW1pYVdHZTQ3SGVVY3ptWkVuZFhqM3prU1o2?=
 =?utf-8?B?MzBmZVZCOW1peXNCMnBzZk1rUENpOWlIUlR6c3hSOS9XMFQ0SkR2RDZzSXZW?=
 =?utf-8?B?TEhKLzRobHBLdzRJOGQzSFZGMzBuR2hEQzl5a0owN3E4YUk2OThXUG1peWJM?=
 =?utf-8?B?UHJoWHZuWk15WlF2YnpJLzh5QXBmS0llNWFzUGRBeDdpRys3UUFqQlU2Z1Az?=
 =?utf-8?B?WjJyZmM2Ris3cFdHWlJrM3JEcXFEZG4wL0QzL1RXMzJjSmc4WGZWbGVwcGVV?=
 =?utf-8?B?Y0hDTTlBd0FTeFJnM3lLQmxiVmhxc2oxRytTckRCNFcxYUEvRloyRW8xYjFq?=
 =?utf-8?B?NzBsbFIyOUp0bnovQXB6TlVpQ0UrMWVIQTdhc0JlaEJRV2xzY1JBeTdqa3o5?=
 =?utf-8?B?OHl5aHJNWVlDZXg3Z3ZPdHo1MTdXS2kyc0JEaDU2NWJIVEkya1FyTHo4RWJL?=
 =?utf-8?B?TWNMTTlYZjR2Vzc1MldVSHd4VHlxL3RTbVhOdXRiZUx5Qnppekp2NDRLLzVR?=
 =?utf-8?B?dTZtWTdDRzl3MW02aFNZWWgvcjdmRzFtaGpPUkl0cWdZNzJrcEtycnpaeDZR?=
 =?utf-8?B?UHdsU3VXdk0za0pLTnQ1MDRQNU9NdmhxblNRT2ZPOXJ0eldXV1BtbGMrOGRx?=
 =?utf-8?B?YmRaZ3pzWkVoTWRXMS9qNkhMWndvMm5RT2VtQUxzVnZHa0V5MHIyVU55V2lC?=
 =?utf-8?B?dDlFUndFa0l5U2VlYWJjNFQ3S0htYitzTjBSZmdKSDlZajh4UjI0dnoyeXRM?=
 =?utf-8?B?RThHR3FzWUNjTHVuaHNJbDgrQk9jK1VwVVJZSVR6Wnppd1VNMVpPRHBzc3ls?=
 =?utf-8?B?UUtMY2gvTk5EdVpSbHFXQVNGVzVWRjcwYXNybVRYbStoNWJqeTNVcU15Tmpr?=
 =?utf-8?B?ZTcxbFhuSFFJeDRJcnU0SG9PYTh1OVo3OFFTRXgxOFhBdFVTTEJPWitxeFJU?=
 =?utf-8?B?OTNRcWp4TTI0Und6ZnBvNnNnSk1xUkNDLzVuOExldmpDeG5DcFgzbSt0eDF6?=
 =?utf-8?B?bEVuUW1lRjQ4YzBvWENOeHZ3QlAwYjZFempaL2Z4dEJad0hpZmc1c2ZOMFRq?=
 =?utf-8?B?UllvaWoyN3dHVFZZUlBsTTVQQ2lsQzRqSzFRNUhWSVBvTjRqK3hiM2pnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WElyTjZpZmcwZm93RW9BWkEyRU9jUkwzZHBZUkkxY3JISkVrc3JCSUllNmRl?=
 =?utf-8?B?TXlaOXhjbnFpYWMwVkhzVWFhTC9QUEZNY2JzcTU0em1HZlJkZ3BqSWpQQzFB?=
 =?utf-8?B?NHlWajFOOTljVVU3OG9sdTlKbjZLUDBrMHVJTzZaMXdpRzhRVk5CVk5XWFhh?=
 =?utf-8?B?T1JjUllPQVdUM0NJMFp0cC9oSzk5SDhOajFEUEwxdSswZWZ0Qk1FdU1XOWFT?=
 =?utf-8?B?VE9Lcjc4TTFxY1gySnNONHFlSU0rNkgxZU1GYjdyVEtDSkk1VTBzcU5XakNZ?=
 =?utf-8?B?aDNmR3BFWkRKV25LQTZ0WkVSa2lTTTVEL29yQzhTYm9URTU0TllPL3NhKzgz?=
 =?utf-8?B?cW9JSDU4eWI3VGVpTDVkVXFZUnZZbGFIeUpuVDl3ZzdKU0dlaEYwN0diejNL?=
 =?utf-8?B?c3kxK2w4UjJobHpET2Q4OTBxY1JrREh1cTRwRFVKZmdrWW9rTEZiUEZvdFB0?=
 =?utf-8?B?UjJPN0dudkpNYnNRNVM4eUxVbFA5eGRnb0hkbHhLSWYxaTNaa080dEFlUGVM?=
 =?utf-8?B?YkdsbWI5QkFsa2NBT0xwSVFTZXUvL1FQdjV6N3VGRDFiUVM1NWhlZytqeWo5?=
 =?utf-8?B?RmJZMURGUFVoWlU0Zi96WUFXTFFBOXN6NTNoRktBMFNiR1g1Q1c1SUFtV2hZ?=
 =?utf-8?B?VGp4Q0JnZWZKZmkxQkh6Vzl3WHhmM3NDZVZ3aXlabUM1VGpMcmZQY2laWnpk?=
 =?utf-8?B?MkVJVW1FdTNrdENkMm5xTEZ3Tlk2d0NFMENPOW9QaHgzekZLRkdjTFg2UVNw?=
 =?utf-8?B?b09USXphOHgzb3oxYVU4RDFYYU10a0NrQ1V6bDJGNjZJU1huRGgwaUh4MDJP?=
 =?utf-8?B?QmppeGNxYU1VaWJiVE1QZCs5eXJ6dnVBeWFueUhlUGNJRWlJeXZZclNPbUtL?=
 =?utf-8?B?UVRVOUFhQmUxN1NCenJVQXAvUEF5MS9RSXo2UVAzMVZ4N0Q4VTNrek5yNGs2?=
 =?utf-8?B?L0xKQ3hyQVd6bHJ2TmhrZzNPb3YzVCtkQlVjU2R3TmxsKy9zMkpmdUVKMWtn?=
 =?utf-8?B?RFlYZVdZSURPZFkrWTJUOUhBVjRxQmgyQXFJUUdGQ0hwQmwwcGV6TVhNWUM2?=
 =?utf-8?B?ZVVNSlJnNWtCK0grZ0FiZVlLMVJSNUhvUnYxakZxeDRKWHhKQWczT1FnRHBS?=
 =?utf-8?B?SDY5SktUTnNxSHhPaTArbDRzREdwTEsrVmZLQ2ZqZVdQdDhHRkhKZUU4cG9V?=
 =?utf-8?B?bE9kc0E1NlhibmF6WEd0eVpHdmxWdW5qRmswNHhhMnhOazM3R0lNMCtpYXdj?=
 =?utf-8?B?dkJzdCtNRzlyMU55anRQQzNrU1kyVnlrYzdWY21pN1VqalJERmN5QUxVakJO?=
 =?utf-8?B?MUVUa1BNVWVYemdKTGZ0aDNBL1UrdmtLbWcvZWpZTlNzNGUyaTR3SFJyVlNH?=
 =?utf-8?B?LzRBeThpWE1paU1wMkZhcDFvT25yM1RGcVYwUDJCUGluTFd4N2hKSGdwUmkx?=
 =?utf-8?B?eHFJMC85UTZFb01hL1pacWMvbXplQmN5aUgzeHYvVlo4b0EwckNTTFVmR3Vi?=
 =?utf-8?B?MktodVFXRXd2T2E0QVJpSTR1L3M5UEJ0ajJvK2k5WVFyWVJWK0xXR0N6Uy82?=
 =?utf-8?B?ajh5RzVGQ0pYaFI5MVpNOHdOTUNrRDQ5Y0FqSjdoL29mWE5Wd2hvZjFwcDBj?=
 =?utf-8?B?UE1mOGFCMmd5SlAzNDFhOFRLRTJibXlCK0xyYkdGMS9FeCtIaWJubDFlejI0?=
 =?utf-8?B?bUlva2x3NWFJVkphbktYWCt3QmJsYjJxU0VEMGEvR1VkSEtDYStWdTNqcDds?=
 =?utf-8?B?OFVRekE5MlFSc2QrczNLS1lzdVMyREVsVFZOSXhkYVZUVVRvSjJicURpYWVp?=
 =?utf-8?B?eEFvMFVsT0ROa1A2QXZDNXdDMEU1RGZ5bFR0dWxiOVJXWjEzdjdxd2ZrUjJZ?=
 =?utf-8?B?ZEFQZkRZbjNVUC9wSjVWU0pJbUwyS1pvUmhnMXo1UDc4aEw3VHNKQjlaZDg3?=
 =?utf-8?B?anpTMmVrczJMaS9BNTZmbjZ4bnhoRkxkeW8vWVQvZ0oxMzNVZS9rMXNFNWN2?=
 =?utf-8?B?b2F1UGFNS25RS2JXTC9TeTdKNldzNFRoUk5OTHJDSjRaVlh1L2VLSzMwRmQ2?=
 =?utf-8?B?MG1IT1Nud0w4ZXdHTDFUcHcrZVB2ZDI1cVg0L256amF0c2tEbmRkRmJpN1JI?=
 =?utf-8?Q?Ib8JSTyAEwRj8LfPfP0o6U8WH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca407a5c-3239-4025-5f5f-08dc78f92edd
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 18:18:00.9445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euzovrpfK4ywiCYxKRxijzyT8mnyUsSyjdISR6o6IAOdA7y8abaUrrShPhEMJqv0dTfRKBM+pd7j02CIT/cZSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6212

On 5/20/24 07:08, Li RongQing wrote:
> The allocation for the per-CPU save area in svm_cpu_init shouldn't
> be accounted, So introduce  __snp_safe_alloc_page helper, which has
> gfp flag as input, svm_cpu_init calls __snp_safe_alloc_page with
> GFP_KERNEL, snp_safe_alloc_page calls __snp_safe_alloc_page with
> GFP_KERNEL_ACCOUNT as input
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   arch/x86/kvm/svm/sev.c |  6 +++---
>   arch/x86/kvm/svm/svm.c |  2 +-
>   arch/x86/kvm/svm/svm.h | 15 +++++++++++++--
>   3 files changed, 17 insertions(+), 6 deletions(-)
> 

