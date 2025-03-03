Return-Path: <kvm+bounces-39927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 05E01A4CD96
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:39:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EB5F3A72C1
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 21:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C83523643E;
	Mon,  3 Mar 2025 21:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UQ574O5O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2057.outbound.protection.outlook.com [40.107.223.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851C71F03EE;
	Mon,  3 Mar 2025 21:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741037953; cv=fail; b=naOo3pNWGZ8cjvg0YX1GSKWMVM5x0nPuqtzcPUT8QEgTQeI6QxlSdV5L7jGcTph3woQmfBVP39aG1a/11Mkagp9CvOdDjjR1t36vWhQTlUC+F4UHaPU7HQ3VSb282ld1RP9qqR8+caxPuu/j/y0AhKqEGEasZtPuHIz0R1Fd/sU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741037953; c=relaxed/simple;
	bh=Zg5/EHfE6imRrlJ3gCxaJV2H2/HP+11xWfbSWe9EhtU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jTi2FqH21wSbN74PVMgV1jw7fTVzv0ahksjy8H7MZMl8ireBiUdiKwqLLVAOYahHnFOt7dA/6IyqMAjQVuwrfGiNw242rO6G9vUNSqOr6TbKpUd0hlt5hRj8Fj+iXEP8+z+i6JMizmSNzhRjaiSbYe68fmiwpIXBP167k6e1vds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UQ574O5O; arc=fail smtp.client-ip=40.107.223.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nGYxhCjbU9o8xFDG/r+U9i1pdxJ0CVUHQGNP9YJLFQ3ot5pQCLzEnO1eUIH8t9egVUqpnGQiuPNS+ZiHOfEb/kyJxWFMjkMBQiJSaloIGw0wZPjeKOfaQxlT8uqIYionKLO+e0X//oUnsRYGuEYZGHZK+cE7P5wDgYkdteh1GCA4c6EoxNBd7vnHWgY1u8g7+1WftCxAuY0sAy58oi5t9Zea74rs3OlVGu/Y5iR1q/lM6m1N0CK2hTRQpbPYmW8XjGvgc4JLiLMZD6xIXv9x9hlLsk9q22lFsJbb+M6N/PRSSdKYYBzQ1uJqoivAlR4q0LE/2Lb2CMOu3omwL+30+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pbsv/wB4DSCzU+ILHj73GbCri1M/4zofM1JQQK35t1I=;
 b=nSOirw02FxGtWZ756md7r5OHN5lf7EcHlVXa618/NBzXBn9BRJWgYXiMpY+1Hjc9DBd7YHAky2/p4F27DCOtGUb6ZZVvXN3FC1TBXHXOuVyOsvv61DGUeF32eUFcFj0lRsXW0P34Fnueq/UdyAXDI9GuQw1GOVfSXENyf3DuAguZlncZu6qI+l5l5qYTY6lW3t2/Glz2ESrkAYXo3X1OA3Yc9+Nra8IFKgXox3sepxCgSguZz0YzR22umtoirLJAG7qq0M9wh9nNYJAJ8SD9Fj4CWSxDyxf0qZr3LasxqHBp9pbVS5UiDyx1Q6QrzLVai3wHlSAvfyfncvvbCSY8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pbsv/wB4DSCzU+ILHj73GbCri1M/4zofM1JQQK35t1I=;
 b=UQ574O5OT6GqUEu39m7bDdI4/PJX2wXaRgYJ9qwgQnZ7Nc3IOmB/zfhzKCXWb6s3i75h5MSdFrJ+I0JfGw5bPlOMEktsvfPvO4iDxSnl9SnAur+FAdhl0uyCpHyrQ5j1SEPefj0bvdKnQu28+xpya3fwG/rvUsx51BWaAa73FuY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by SN7PR12MB7934.namprd12.prod.outlook.com (2603:10b6:806:346::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.25; Mon, 3 Mar
 2025 21:39:09 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::c170:6906:9ef3:ecef%3]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 21:39:09 +0000
Message-ID: <217bc786-4c81-4a7a-9c66-71f971c2e8fd@amd.com>
Date: Mon, 3 Mar 2025 15:39:05 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP
 functionality in KVM
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 thomas.lendacky@amd.com, john.allen@amd.com, herbert@gondor.apana.org.au,
 michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1740512583.git.ashish.kalra@amd.com>
 <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
 <Z8IBHuSc3apsxePN@google.com> <cf34c479-c741-4173-8a94-b2e69e89810b@amd.com>
 <Z8I5cwDFFQZ-_wqI@google.com> <8dc83535-a594-4447-a112-22b25aea26f9@amd.com>
 <Z8YV64JanLqzo-DS@google.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <Z8YV64JanLqzo-DS@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0173.namprd04.prod.outlook.com
 (2603:10b6:806:125::28) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|SN7PR12MB7934:EE_
X-MS-Office365-Filtering-Correlation-Id: c32e917d-fbe8-406a-77d0-08dd5a9bd46b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjZrZDkwcEg3Q3BoRWxZK2lXTGcwd1ZsQ0NRam82SS9Kd1F0WVZtVGJ6VFVI?=
 =?utf-8?B?ZkE0a2JWQ2lhRGNPN01YNTI3MDUyUUdtT3RNaXJyTzl1NWs3M2Ztay85MXp2?=
 =?utf-8?B?dXA4VzNQcFpoSGs4eVh3QWpNbXJNWDREejhiZEhMSTUvSlZ1MzcwTUtFQ0JY?=
 =?utf-8?B?dkwxVkdNc3VzNENIR2N3TmprZkpNVEUwQzUrNTk3MnRzQ1Jmb0s4aGZ1cDNY?=
 =?utf-8?B?QnhPR2F2eG53NjBLZ04xTEd2QjBnbGNTV212T2VlTFM3SitwaldhZi9ZRkpo?=
 =?utf-8?B?OFkrN3NoNW8wUFQ5VHpHbytUTTdkR3IxMmdiWGVvUkFnb1BlRmtzWVljOVBW?=
 =?utf-8?B?RjRKOWU4eXl4SHR4VG9zdWxZVS9UK0JLZ2c1MldGMTZpL1J6VjV2Qm5JckxD?=
 =?utf-8?B?OXBUYjd2Z3dtQzNKV2xwOUhwN3RPN28rcmkzaGM1Wmo0TjdWYlhETGd4bHhs?=
 =?utf-8?B?UWRacDBoTWxUQUc3NEJsM1o0UFlnU1dFbkN3V0RnSlpoMktiUm1MVTM5R3pm?=
 =?utf-8?B?d3p6cXNqZ2haN1lIWVJRTUNPWndSMWJFaWNSdXh5Ly8wbXhnSFVxaHV0NjBy?=
 =?utf-8?B?WUhaL3d4QktDVzlDa21URStiK3NTZlF0MXRqeWYyUE9Wc1Yyb2l1RnNmUitN?=
 =?utf-8?B?ak9xWXFSRE9Xa2pOMmxrY2xMUWM1WFc2Mi94VHNsNjJKNWpVY0Y0OWhxK2hl?=
 =?utf-8?B?aTlqS21QNzIzM1M4NlZHZzlCQVdDSzkvRlc3eHFKVldEN200TW9hMzVXRDUv?=
 =?utf-8?B?cTZqditIVXBlVHBVblNhQ3E2bEp0WThJc2doVG5tT1pkTjF6QTh5b0Zyb0Qx?=
 =?utf-8?B?c2ZLRlUzdXFMNHZsN2c0RkZ2dFZxQzlxU1NUdjV5U0NrZjlGSWtZbThJVlR3?=
 =?utf-8?B?QjMrN3JKOFhrVU03OTcyK1ZQNWdyQWorWC9RRlVxNTRKVml5VFpTZmNzVy9h?=
 =?utf-8?B?amNJVVlDa2hsS1poWEI0TE9lNUFKOHlUdkYwTGxQM0tzK1hJT2ZpeW10R0Yx?=
 =?utf-8?B?NVIxZzZ2OHJ0Z3dUK3JYU1paK1NNMHZHZkdCdWtyQWpUWGNDN1ExaFFJZUp5?=
 =?utf-8?B?TE8yNzVPTy9OQVdINVd0ekVBWGZNMWJBcURucjBTUEtyMDZGWmdBZ090and5?=
 =?utf-8?B?V1pIb2pRalJzY2ozZXJDS0xYcGpRNDVMeFZLd3BrNXE2M0w2L2l0NzR6ZDNB?=
 =?utf-8?B?dW5NaWdhd2hsTG02T0d5K1FBKzllN05OSWxKbExCSVBpNENlYzFCTDkyc2R4?=
 =?utf-8?B?TkJscWIybjJabUhPeWRscnFhK1lyeFhuOG1mNG56M3hmQVVXWFhzdnBRRE4w?=
 =?utf-8?B?bE9hbDNxWlJ4UWxtdGQwRWNlNVZVWU0vbXdTbFpHdmNqTHNoK2M4TmpRV0hD?=
 =?utf-8?B?dzZiblU2OVZnRURZenlaQ3hZekFBQStrNWUxMjVwRHp3cnltY3JabTlBOXFZ?=
 =?utf-8?B?cGFXa1ZqT1NVRzNBM0l2a1pTZGw1c1oyZy9pNUVMQzlTcDhuQ0NZbEdkSW0z?=
 =?utf-8?B?ZzJ6Q3NjV2xGaTB5QTJhKzhvSGNSeUpTOWxYclV0WHc5L1E2ak5rbUN4WVNx?=
 =?utf-8?B?WDFOR2h4dDREWTd0MXhkNk5iYWdJZXc3WHpDdGJjQVRKY2ZReWdmcGM4QmVq?=
 =?utf-8?B?Q25oTGhWcGZLNUczbFNmZ2FsMHVyOElWazU0Ri8vbmZzanZuVWRIK3dEUFF3?=
 =?utf-8?B?VlMyemlXWlJxZ2IrMUd3Uk1jaEg5QytqK3VvV0QvLzBtaGVobWo5cWdWZmc2?=
 =?utf-8?B?MjB3bXExT3k3ZllmV0RYcmRQNXBnbUovdFNMckFXU2NFNFhKdVdRTnpFWHpR?=
 =?utf-8?B?NjZVSFYzS0cwRWlhY2IxM0xDWVp3S3o0ekNFalZOK0JWU3ljNTFocGFlQ05X?=
 =?utf-8?Q?PFwEWgSEQwtQB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MFJWWk5JQTFEdTkxRHZpNTAxTTZxd0Y5WEh2U3hFOFl2NlRxQVJLeUZLR0VM?=
 =?utf-8?B?WjFTRXpOUmlrOSsvb1Y2dXhqNjExait1NGR0bk5VUHJiMStJT2hWL3Q3Tmcv?=
 =?utf-8?B?T1UrUG5YdU1aTFM0QkpaZENvRCtwaXJJdG9yZmdXeTVXNlpicDUveTU4cldD?=
 =?utf-8?B?d1ZPNTdGQXhmTkhFeWRxSWJ0U01FTkFKZ1lLNjByelBoTDdreGxKNm5HMjQ4?=
 =?utf-8?B?N2t6QWxZWEtqaGZ6bU1ITkJWTnpYMzFOQm8wenBQUFRLOFFLbmVQYUVlejB0?=
 =?utf-8?B?Z2JLUnh6QmlIUnh6YXlhSThobWlwWE5HbGJ5UWY5OFd2WnlxZ3pDRm5GZE5X?=
 =?utf-8?B?S3pBSmM2VXFBazZ2clBFR1VGZVAxajhBS3l0WkcxcG12aFJMYmMyQnhURElH?=
 =?utf-8?B?WURJUmxHTitLK3NBQnFYa3A5RnNsTXBiZW5OQ3dQaG0rVk90dlU3cElIOGRU?=
 =?utf-8?B?T1JvK1lqMTcwQ1pJNVNnWmwrVnM2cHJDemtvc3V1RG8yZFU3NUFJdXdUZTBO?=
 =?utf-8?B?WnM1UmJUZ2Q1NCt5VFZaL2liOW5rKzV0aDc5ZjVyNjVMeWt4U3Y3VXFreExa?=
 =?utf-8?B?VGZsek5aY1FMRllzM0FBVW1La0RqQ1dFOTFZc1FUWGxnUlJOSDF2SWt3Ymti?=
 =?utf-8?B?ZFFPckdkM09MYzMzdDkrcHVZU3daUFJYTEtJd0dDYWgwTGJNdzk5SlF3Smt6?=
 =?utf-8?B?b2FPaWR0ZmVwSjB4SjdEM0xLY1BKYWZvR0JkZVRpYXdWMkFNeXhSWS9uQW9v?=
 =?utf-8?B?NGRGRnF5MWhKUkNDV1llNCtVT2ZqSjJpanZlUUVnWVM2TE52Tmk0eGNXU0sx?=
 =?utf-8?B?dWd4UVNJaG1FOU9xWjhlNEJya2NiQmY3MnhaRm13UmFmcW5DcHJObXZkdnBF?=
 =?utf-8?B?eFpFK0tOL0dVWVdNR2ZZZHN4UUxNWll5NFVnZk5WZXN4QTJuUjlPemhnY1Vy?=
 =?utf-8?B?UnBSNUdvckw4VVNjU01YTjY2ZlA2c0RCcmwxdSttTnh1VW85V094bEYvZEdV?=
 =?utf-8?B?amMwdEZDOHVFYlhzenFMa1h6bzZlYUoxTk9Hd0s0U1A4SHZmTFZCMlI3Yk9o?=
 =?utf-8?B?bC9lV3d3QWx2NElyVUZMYnFPSjA4L2JqUGVaZWkwTU9KNk1sUjFHUlU2NWRn?=
 =?utf-8?B?Qy9pZGgxYlpDNHFROE1RUXRMRGllcUNzeU12SklGTCtINkVtVlc2eGhMMUwy?=
 =?utf-8?B?NGxRWkRGWkhCWUt2UUF0bEliQWxYY3M1RStTcWJmRE5DS0NpMURRejJaQ0FN?=
 =?utf-8?B?QnJTQ3A1cXVNaVZjS3VaNjF6SWY5YUtUYU9Qbi9ocEVOdXkvRkpWajY0SEhh?=
 =?utf-8?B?UGVwSEZQazFYcUhZSEpiaU9iM1NUMVcwbldjZFJlZEg5U0c0L2ZBV3IyYzdq?=
 =?utf-8?B?UEs5OVNYc0EveWlTN2FxQkQ4YUdiemRybFJ1WEFESFYweDY1THZPV0lZNkht?=
 =?utf-8?B?WVpoRnhIelZFZndnRXJVVmFOYmZJbDdDcWphbzZ4UmxPR3RuZWpUTGhPelVS?=
 =?utf-8?B?cFEwc2F6ZlR4SHRYSlFJckdHMzJLSmR4VVNvcmxuNzhkZUFyWWczMHNROUh4?=
 =?utf-8?B?bVJnVUlibXFGU3lZK3VmZE92VnloRjlEVVhFcTVyOG5VSjRjWExka2xSTFFs?=
 =?utf-8?B?aFREMjRhZzBHNE1relRhVllOWEhVYkJ2akV4LzFndG14UnI2UW5PU1h5Zmww?=
 =?utf-8?B?aVVzUktqdDdMSFdXRFUrUm9ERWEwNUZlT3EzbXNyTE8xWjk1TjRpL1d6RDhH?=
 =?utf-8?B?eEVSOFpueUdIWEVGR0wwNkJEQjNqMEoxSzBKa3lkMUFxTGhUSkt1Mlh6RDlM?=
 =?utf-8?B?cGRRK2d1Y0VacEZhRGVrRkRMdmxiWml1bmdlWUJEYWJST2ZabmVmd1JOSmxt?=
 =?utf-8?B?dTVydjk2clREemg4Q2NUTTlzZ2wxdkhHMG94aURMdTJJWGh2QW5JZWRLaG5B?=
 =?utf-8?B?dWFsT1BCTHhleVZTWjNoV3ZaKytJSUdFR1BSSHRsK0V3aGNQNHVhcytZSlR4?=
 =?utf-8?B?aWg0RHYxN2FNMmRadDBXMjJDTGZMdUZNczN0ODlycUNLTDVpeFNrZVRvQ0cv?=
 =?utf-8?B?Nm5GV3lzUUQ0alVvVnJhLzIxY0k5Rjc4WXIxdjhtSHFnd1l4eE5Kcm8vUXF0?=
 =?utf-8?Q?bEf2IsHgPuaz70YUzsdkuLZHX?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c32e917d-fbe8-406a-77d0-08dd5a9bd46b
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 21:39:08.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3KBKwf/RVDG1b4wgsk2FNo+Vri0lMCTrVanm8mAtUyCmWUNB+uEDL+CztSWYXXniOKJtgTTaOOLb6ywQSOzSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7934

On 3/3/2025 2:49 PM, Sean Christopherson wrote:
> On Mon, Mar 03, 2025, Ashish Kalra wrote:
>> On 2/28/2025 4:32 PM, Sean Christopherson wrote:
>>> On Fri, Feb 28, 2025, Ashish Kalra wrote:
>>>> And the other consideration is that runtime setup of especially SEV-ES VMs will not
>>>> work if/when first SEV-ES VM is launched, if SEV INIT has not been issued at 
>>>> KVM setup time.
>>>>
>>>> This is because qemu has a check for SEV INIT to have been done (via SEV platform
>>>> status command) prior to launching SEV-ES VMs via KVM_SEV_INIT2 ioctl. 
>>>>
>>>> So effectively, __sev_guest_init() does not get invoked in case of launching 
>>>> SEV_ES VMs, if sev_platform_init() has not been done to issue SEV INIT in 
>>>> sev_hardware_setup().
>>>>
>>>> In other words the deferred initialization only works for SEV VMs and not SEV-ES VMs.
>>>
>>> In that case, I vote to kill off deferred initialization entirely, and commit to
>>> enabling all of SEV+ when KVM loads (which we should have done from day one).
>>> Assuming we can do that in a way that's compatible with the /dev/sev ioctls.
>>
>> Yes, that's what seems to be the right approach to enabling all SEV+ when KVM loads. 
>>
>> For SEV firmware hotloading we will do implicit SEV Shutdown prior to DLFW_EX
>> and SEV (re)INIT after that to ensure that SEV is in UNINIT state before
>> DLFW_EX.
>>
>> We still probably want to keep the deferred initialization for SEV in 
>> __sev_guest_init() by calling sev_platform_init() to support the SEV INIT_EX
>> case.
> 
> Refresh me, how does INIT_EX fit into all of this?  I.e. why does it need special
> casing?

For SEV INIT_EX, we need the filesystem to be up and running as the user-supplied
SEV related persistent data is read from a regular file and provided to the
INIT_EX command.

Now, with the modified SEV/SNP init flow, when SEV/SNP initialization is 
performed during KVM module load, then as i believe the filesystem will be
mounted before KVM module loads, so SEV INIT_EX can be supported without
any issues.

Therefore, we don't need deferred initialization support for SEV INIT_EX
in case of KVM being loaded as a module.

But if KVM module is built-in, then filesystem will not be mounted when 
SEV/SNP initialization is done during KVM initialization and in that case
SEV INIT_EX cannot be supported. 

Therefore to support SEV INIT_EX when KVM module is built-in, the following
will need to be done:

- Boot kernel with psp_init_on_probe=false command line.
- This ensures that during KVM initialization, only SNP INIT is done.
- Later at runtime, when filesystem has already been mounted, 
SEV VM launch will trigger deferred SEV (INIT_EX) initialization
(via the __sev_guest_init() -> sev_platform_init() code path).

NOTE: psp_init_on_probe module parameter and deferred SEV initialization
during SEV VM launch (__sev_guest_init()->sev_platform_init()) was added
specifically to support SEV INIT_EX case.

Thanks,
Ashish

