Return-Path: <kvm+bounces-48787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B7DAD2DF7
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 08:32:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11AAE3AB2C7
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E81B279354;
	Tue, 10 Jun 2025 06:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IQmqjQ3o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2067.outbound.protection.outlook.com [40.107.102.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CE321C9F7;
	Tue, 10 Jun 2025 06:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749537143; cv=fail; b=W+WtGEcpQkqZQSnjE2m8xubrP4y4c+3A3KGgVdlHb6rvLLLv9EZY/niQEmG5Cx6xJRZ8xOb1vhMszeNpj1pAxoxdvue6iFSkgyfqsDkkvuNKJA6arMYkVvRjo7h1QUE9k14QwkXQYtuFDxJ7r7Qj6IZAO44aJWvfTRdwb8kM9l8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749537143; c=relaxed/simple;
	bh=mL+MPzuWJuqfxpOF4mIoOlMhFXTYHS15tqkprCkkcG0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Lz+yXmN6wdJAYzqj7lfdZh4frEJgvPKt2dCJikF4u15UjBCPG8pYt3Y7yacUY9PqRqdIK5FuuehgUOs7OMa5XwLZUuqsq//pgeLYPSiA7UR6YM/Hu9+19H94as5SA8rtHqN3G8bQvWUI6l99G54TJGsxASSeSMCE33i5ybtpMO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IQmqjQ3o; arc=fail smtp.client-ip=40.107.102.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uY1dHkyAzDfCdgDMU2i8OEdvTh+UNBigs5sGEs92a0ddYzWgAuxcsX4Qylz/sDGtyE+nMwfU2u0m8HwuP/2SlzZ+m8foPE75cUxC780xqfLTzEedDl1h/BeByzZ1IOZxyiAE0JKTtd1NqOWVRMspvKqulQVqwmKOhkiYXw+mECz27nMCYVbvKIWtspicJtiH9qMZQqwpEuh9+st2DW1fYyUcQJtaGrm2zJffT/QRINwjxR4V89jr+3hD5e3k+pIZcdL7+uSTQxigx5QkQxuxmBlQiddwhLy83Vhwk4cSIa/MQ5TdphPPm/LvATOIzGfr/EPasuVQILsWTkNSaJPpxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PY7o0wRNuKUjBPhf9ihGm6wqqWCaEHvwYls3cdE2XDc=;
 b=w73q6Z+ah3ccLilrvyFdSE1ggwOKK4gZPxym0hVUz/kSWXIHjr4CR01xpO0Ta+ze8oL4X7JY7HxFdVInyfrZeFtGmudovB6Dk6xZDQTTuJxLKaGQSK5XWxRcsQzU0fUUb42yIjzm8g5EMZE14z897yRHSpO5jlRGo1qu6Bvwovs5oduBptUVUd2Xa2FPensvrM/lWJKJ4GgaGsB61K5n84mVqUVwEB28D1fzf77UlkABPBClMD5q7yBgF5qeN+6bEpygbWcmS0G99XJ6/2TRAwauQA823T4PMOuc9xn7pLStNVEsCHgdXQrld++tAKJUtllgJOlPHxvY5hknvY6LOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PY7o0wRNuKUjBPhf9ihGm6wqqWCaEHvwYls3cdE2XDc=;
 b=IQmqjQ3oUJYRmyUIrlmncbkJpxFlLwj5uqR2t5tYJHI0nkW13/eqYUZXIgEAySuO/E0XfuHNogBKGQGvsMlsnibgHNo6o5unY8TjOQo69l01VqBhbPV1PNXcJPuKUmVtr72otoB0PV5JVbsTGirZGcBb7xkfx32YZuWPN53RZws=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 CH1PR12MB9574.namprd12.prod.outlook.com (2603:10b6:610:2ae::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.41; Tue, 10 Jun
 2025 06:32:19 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8792.040; Tue, 10 Jun 2025
 06:32:19 +0000
Message-ID: <cc3df866-9144-42f0-a24c-fbdcedd48315@amd.com>
Date: Tue, 10 Jun 2025 12:02:08 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/20] KVM: x86: Move find_highest_vector() to a common
 header
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, bp@alien8.de, tglx@linutronix.de,
 mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
 nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
 Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
 hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250429061004.205839-1-Neeraj.Upadhyay@amd.com>
 <20250429061004.205839-2-Neeraj.Upadhyay@amd.com>
 <aBDlVF4qXeUltuju@google.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <aBDlVF4qXeUltuju@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PEPF00000189.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c04::54) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|CH1PR12MB9574:EE_
X-MS-Office365-Filtering-Correlation-Id: 4813ce10-3560-4fb2-4d2d-08dda7e88c62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aU5TTWI2L1pzTVJvOW1pNlNKK0k3TUlLa2tzRDRUbU9WNXpaclV1bnVIbE1D?=
 =?utf-8?B?dWZnbDFvRVJZVjB5eHBXTU4waGhxYnpUMmc2WHBVQ2ErZXhDQ2hnMVVFMk5G?=
 =?utf-8?B?NzJRS2pyRUljVTgxa3d2MklGcm56MXlab2lpN2RRQnVFL082MjdWbURMN2Ez?=
 =?utf-8?B?ekE4alZHaERjd3VTY05xOWt3aDB0cmEzdzlrUGxUM2JoVTU3bTg2ZjRTdy9C?=
 =?utf-8?B?blVvQThsTGxYYjI4a25LaUl4RFE0Zmo0QzU0c3ZIZkxndHJYL3JRSk4rM3Zx?=
 =?utf-8?B?MnRiZVhvZld3cll3S1dLMFg5VkkvbHdZb2EwSXB6MFVzU0hsV3Z1cUd1NFc5?=
 =?utf-8?B?QnRWTHJZSU5raVczRnEvSGgvQ2JUL1oxSENIdUgyNTlnYUJHM1lKRlRsZkxn?=
 =?utf-8?B?OThsc0JoYzNCQzhBdUFTUExWWlE3WEFOUEkzUzZrQUNiS0NsbUI2dTRHM3ZV?=
 =?utf-8?B?aWpQQ0psbDB2MUdhNFB4Mnc4YkxBREwrNzBjOTJUd2F1ckdxYUtMa1ZZcFkx?=
 =?utf-8?B?ZWpIaEFZRzF6Wm1UU0VoTDVScVdsWm1OaUkwU2VvbGtWY3VlQ2hlMjF6ZklO?=
 =?utf-8?B?ZDhmaFg3c0Z4ZThZUXlNaWFUR0hrekxsMnI3ajdmU2hpa2k1VkowdGYrWDVi?=
 =?utf-8?B?SnFqVm5pbzJ5dTdIbHZYMVAzNW5QYUxrSkNTdE4wSVEyNTlYQ25WSTRJRFFO?=
 =?utf-8?B?dU9BR0YvSXFKZCsrcHZUK1JZcG9wcU12L2NZaDg5c1E2ZmQ0dnhRSXFxQlQ2?=
 =?utf-8?B?cSs5ZlVqZHRjbW1Ud1p0Z2xjNlhxUU5CTnJHRUEyZHljUmc4Tm5pRnFrYWdU?=
 =?utf-8?B?WGcwazBkRDFBTmpKN09iVUhtQkM5ZVgwcDlnVjlLNUkzcVMzNmxnTENKL3NT?=
 =?utf-8?B?QlNtRTY1WURhSVMyOGtnbFdOc2hKWDNzNEhBc1V0ZDYrNEl4alhveUFYTlZ6?=
 =?utf-8?B?c0h0T0hJZFlFNENhVzUxUy9WcUo5akpRRVlRTEFkbzl2bldpWE16a2h1U0pW?=
 =?utf-8?B?M3ZhMzVib1VhMlFmd0RmUU9SVlJOc2EveHpUdzAyVnBLRzRQSFQxOW5ERjJE?=
 =?utf-8?B?SUZFWlh2QXNXV3JrQnljNGhQKytoME5lMlRjSHgvMktyNzVPZEswWlErTm1v?=
 =?utf-8?B?Z1VvSDhpNWd6T2NjZ3ZzOUU4ckM3WGt0UHhEVktKeDIxSC9xaHhLdVdnTXZp?=
 =?utf-8?B?djJ5TTBmTE0weGF6UkNjNDR2RFpnTys1VUZneWc4dEMzbk82cVkzejNKVDRH?=
 =?utf-8?B?aHo3YXJTd3I5TUcyOFhHN202bzBaZXptWXNkUUpqN1IveUxxQnRBTDQ2ekh3?=
 =?utf-8?B?NHA4WXRoOWp1MERHOSt6WmQzNHM5S25NNktxcDJydzNITFNsVFlGWjh0OHEx?=
 =?utf-8?B?dG9ra1c3VEdmc0VuekhCVG9mL0p6cyt1eitpenQrU3VMK3J3VmlSQi9ROXFt?=
 =?utf-8?B?SG5NTW5EOHFNZEk0bVFJamZncUdhb21BQVNicEJIK0RnUDQyeHJ5S3ZOOFdP?=
 =?utf-8?B?VS85WjhLWjYwU0NCYjhiTThjNW5xeHRvMHNKS2RNQW1zSTZmYkYvQ2YyL1RF?=
 =?utf-8?B?S29QNFhzOHJhclVyZ3MvYWkySGIvbFh6aE40OUpDbWdlTEZzSVpiUnhPR292?=
 =?utf-8?B?VWJyT2s5SFRpY0k0K2VEZnR1bUpXL2hnUlhLdFhyNVVQYVR3KzNzcStxWVNj?=
 =?utf-8?B?Zm95R2lvU242aTlFb0pDdWUxSWJhbmVoWCt2aWJZZncrSmU1WnRHR2orOWo5?=
 =?utf-8?B?VkptdHhyNWNTaUxVbjF4TndwK0FhNlJKRlJUQUdNeVA2elM3VTBKczdycjAy?=
 =?utf-8?B?c3VGdDI3S3l6ZmpCayttUjRBTjhVWHRaR2tZMGllRWwzU2NLWGtseG9JWkFa?=
 =?utf-8?B?RE9ObVpaU3BlblQzTXRaK3pidmdYOWNtb0VIaWVZV2hCSjdpeUtUaEt4Z2xP?=
 =?utf-8?Q?dnB5+vlkjdo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QVJaQWFFNFRtNk5aS3hCSTcxQXFDbDBaTWszSHp2RVREbHVhV1ZTRjR6bFBS?=
 =?utf-8?B?MlRkcDhvTVBnYlloQ3ZKQnJyZHIyT0h0dGUwdzBxYjJscUJQajBKeXVMRnR5?=
 =?utf-8?B?V2pxVmdkTjFoRFcwS1IvSEsyTDhhbGlOdXJSM2NWeWFZNU5XWUpkZVRlMUph?=
 =?utf-8?B?TlZmcTlMRnNpYUY5ZGhPdEVjWnR1anBxTnlVNnJSTEZscGp4cElMVWhzcGIx?=
 =?utf-8?B?M1FKNkVLWGErN09uR2FCSHZzTGc2UDdCWlFIRmxoVFU2ZmgvR2dBNTlWVTN6?=
 =?utf-8?B?TjBYaTA0aytTQkxuUDBmK2dWemRQV3liQzYzVnJRNEhUWms0Q284cUY4YU5U?=
 =?utf-8?B?d0ZqcFF4dHVtVHpwbHNlK2ZrSDZVeXZURHpJeW9jeURyb3pWMEV1MFZlSkM5?=
 =?utf-8?B?TEw3UEtmMFBzcmM3WkpaUzdVWXhodlZ3R2N5UDQ4VG56WU1wOGhvQWtENnY3?=
 =?utf-8?B?QVBsR0tvR0REdm1Hcm0zMmc4Y2hCbXZoRUlxV09LVllJaFg0ZW9aQnAzUy9X?=
 =?utf-8?B?czM2d05OZzVsWktvN0JGMHFwUXAwUWpSWTZkUVJ3RDNkMGdQZ0VlSTJhY0Qz?=
 =?utf-8?B?L1hVRkNUWmEzM1JZUDduRHRpZ080bGcyazZIMVFIbDZ2YUZtRWlva0RaKzhw?=
 =?utf-8?B?RkdwVlNyNFZxalY2ZU0xbGN6SDY2UEhsVDZNenBBUmRleXBWQjc2MWt0eXor?=
 =?utf-8?B?dHdqVFQ0WVBJbElYbFZTRWMzOWVzMVl4bTh0eU9ZQVVRaVFuNkNZUkh5MVh3?=
 =?utf-8?B?RDl5bWg1UjZ5U2pyY3JoTWUwZFU3Z0NRa3RPQlBTVWhGZ2l1ek9yZ2VMR2dy?=
 =?utf-8?B?RnZpc1Q1bVMxVk1WdkhWR0ZybE94c3p2ZGFYdmZOSkovNjJRUXNzWktNTVdD?=
 =?utf-8?B?MXd1T0w3RVhabGpGUEorWEd3Q1Q2V0JPSFpkMGg4czZWRTVERXR3TGZpaW5Z?=
 =?utf-8?B?VnptRUhFTjJvQUhxQ0c1bFNqS2kxdWFIYm1jM0gvMkIxNW9VbStJREhJVE85?=
 =?utf-8?B?N1Jzd3lHTW1oM21tYi9MaEdQY2FWTFI4bWhZWGpNSTNrVEFLOE1aVVEzRisw?=
 =?utf-8?B?UzdWazJwOWRwM283cmlEbG05V3VDcVZISlZNLys0RE4yTFRaV1MwNWRKdW5L?=
 =?utf-8?B?ekJDeGhVL3c0TmdpYWMyd21CM2w5M2xoMUg4QWJBVXNqY1FQOWN5Z1Q2cnY5?=
 =?utf-8?B?dXlUM0NOT1krU1I1VlN2b2srMUpFODEyczBMaEppeDZreHVFWkp0VCtnZm5I?=
 =?utf-8?B?NzF3d0UyMzNHYVg1NjhYU0FKckNERFRjRzBJZ1E3ZkdFbENHVGVraEE2TUNP?=
 =?utf-8?B?N0hhZWNud1pQeG5MQjJxem9jVWhZMmpZdGo4Y2cvQTVKelpLeUFmVGRhZG45?=
 =?utf-8?B?Zjgxek8vbEZSREFZMEZYL1oyNXRVaVh6d3hrcC80TkN4RFNVSU5oTHRQakl6?=
 =?utf-8?B?M2UwZDBkb0EzaGhiQ0VMck5hVTBPY0g4MkFZMHhpb25CcmRTUEx3YmdISUht?=
 =?utf-8?B?QUV0YllOb3oxbG1OL0ZKYkNLem9ZeVJkVjJSSVVzcjg5N2hqckVYb3J4SVF6?=
 =?utf-8?B?VXAvRlN6NTlvU3BIZnZtNHY4bVdBLzBqNlVvNzNBQTkxcG04NFl2c0JLenhy?=
 =?utf-8?B?Z1JYbG5PN1V6Rk04a250SnRJS0N5U2pQRnl2VjEzcnVNWnhpaTB4eFlzb0gy?=
 =?utf-8?B?RFlTbU1VQ0x4M3B6YlJsRzE3bElUVmplTW9XVmpFZmR3SzZqTGhGTnJqL2Vx?=
 =?utf-8?B?YnFoWW1lN2tBdkx4aGQwNjVNNldRMXFXb2lOR09XSis3Mm1hQXNBVlNCd3Ri?=
 =?utf-8?B?eWRhQ0VjUjI4VzlXczYxTEpCVFlBUHFOZWU1SDJpdXByTXErU1EyUGE2OExP?=
 =?utf-8?B?OTljazZUMkFFdGxxTUY4dFpDL3VHckxtQW1Eb0ZVOTUzbnZyU3J2MXpFSTgz?=
 =?utf-8?B?dEZyYkgrM2N2Rzg3ZllWN054aEFBZ3VjZmJ1WmphaVNSM0swNFcxckJYNEJk?=
 =?utf-8?B?UVFxNldtWXNSSTVFNlp1S3l6TXFSekFsK1F4WE1YMGdnSklwYnpHZ0Eya2ZX?=
 =?utf-8?B?M1dGTUZGVmd1MkZ0c2p2R1ZUSEwwRzZDMXNkTUhKeDhBQUFkVFZ5V05uWGE3?=
 =?utf-8?Q?SiPRaUJWyyUrkVTGXK4R5lMjz?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4813ce10-3560-4fb2-4d2d-08dda7e88c62
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 06:32:19.0883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pnT6/LGdag3Nrr1KJYqklmRf5iYT5QfKhEumSAqlmVHfCxLK3IQ0OE7Iis9bBltcZTrgrllDk7e1T3h9aeTQRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9574



On 4/29/2025 8:12 PM, Sean Christopherson wrote:
> Please slot the below in.  And if there is any more code in this series that is
> duplicating existing functionality, try to figure out a clean way to share code
> instead of open coding yet another version.
> 
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Tue, 29 Apr 2025 07:30:47 -0700
> Subject: [PATCH] x86/apic: KVM: Deduplicate APIC vector => register+bit math
> 
> Consolidate KVM's {REG,VEC}_POS() macros and lapic_vector_set_in_irr()'s
> open coded equivalent logic in anticipation of the kernel gaining more
> usage of vector => reg+bit lookups.
> 
> Use lapic_vector_set_in_irr()'s math as using divides for both the bit
> number and register offset makes it easier to connect the dots, and for at
> least one user, fixup_irqs(), "/ 32 * 0x10" generates ever so slightly
> better code with gcc-14 (shaves a whole 3 bytes from the code stream):
> 
> ((v) >> 5) << 4:
>   c1 ef 05           shr    $0x5,%edi
>   c1 e7 04           shl    $0x4,%edi
>   81 c7 00 02 00 00  add    $0x200,%edi
> 
> (v) / 32 * 0x10:
>   c1 ef 05           shr    $0x5,%edi
>   83 c7 20           add    $0x20,%edi
>   c1 e7 04           shl    $0x4,%edi
> 
> Keep KVM's tersely named macros as "wrappers" to avoid unnecessary churn
> in KVM, and because the shorter names yield more readable code overall in
> KVM.
> 
> No functional change intended (clang-19 and gcc-14 generate bit-for-bit
> identical code for all of kvm.ko).
> 

With this change, I am observing difference in generated assembly for VEC_POS
and REG_POS, as KVM code passes vector param with type "int" to these macros.
Type casting "v" param of APIC_VECTOR_TO_BIT_NUMBER and APIC_VECTOR_TO_REG_OFFSET
to "unsigned int" in the macro definition restores the original assembly. Can
you have a look at this once? Below is the updated patch for this. Can you please
share your feedback on this?

--
x86/apic: KVM: Deduplicate APIC vector => register+bit math

Consolidate KVM's {REG,VEC}_POS() macros and lapic_vector_set_in_irr()'s
open coded equivalent logic in anticipation of the kernel gaining more
usage of vector => reg+bit lookups.

Use lapic_vector_set_in_irr()'s math as using divides for both the bit
number and register offset makes it easier to connect the dots, and for at
least one user, fixup_irqs(), "/ 32 * 0x10" generates ever so slightly
better code with gcc-14 (shaves a whole 3 bytes from the code stream):

((v) >> 5) << 4:
  c1 ef 05           shr    $0x5,%edi
  c1 e7 04           shl    $0x4,%edi
  81 c7 00 02 00 00  add    $0x200,%edi

(v) / 32 * 0x10:
  c1 ef 05           shr    $0x5,%edi
  83 c7 20           add    $0x20,%edi
  c1 e7 04           shl    $0x4,%edi

Keep KVM's tersely named macros as "wrappers" to avoid unnecessary churn
in KVM, and because the shorter names yield more readable code overall in
KVM.

The new macros type cast the vector parameter to "unsigned int". This is
required from better code generation for cases where an "int" is passed
to these macros in kvm code.

int v;

((v) >> 5) << 4:

  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

((v) / 32 * 0x10):

  85 ff       test   %edi,%edi
  8d 47 1f    lea    0x1f(%rdi),%eax
  0f 49 c7    cmovns %edi,%eax
  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

((unsigned int)(v) / 32 * 0x10):

  c1 f8 05    sar    $0x5,%eax
  c1 e0 04    shl    $0x4,%eax

(v) & (32 - 1):

  89 f8       mov    %edi,%eax
  83 e0 1f    and    $0x1f,%eax

(v) % 32

  89 fa       mov    %edi,%edx
  c1 fa 1f    sar    $0x1f,%edx
  c1 ea 1b    shr    $0x1b,%edx
  8d 04 17    lea    (%rdi,%rdx,1),%eax
  83 e0 1f    and    $0x1f,%eax
  29 d0       sub    %edx,%eax

(unsigned int)(v) % 32:

  89 f8       mov    %edi,%eax
  83 e0 1f    and    $0x1f,%eax

Overall kvm.ko size is impacted if "unsigned int" is not used.

Bin      Orig     New (w/o unsigned int)  New (w/ unsigned int)

lapic.o  28580        28772                 28580
kvm.o    670810       671002                670810
kvm.ko   708079       708271                708079

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Neeraj: Type cast vec macro param to "unsigned int", provide data
         in commit log on "unsigned int" requirement]
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
 arch/x86/include/asm/apic.h | 7 +++++--
 arch/x86/kvm/lapic.h        | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 23d86c9750b9..c84d4e86fe4e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -488,11 +488,14 @@ static inline void apic_setup_apic_calls(void) { }

 extern void apic_ack_irq(struct irq_data *data);

+#define APIC_VECTOR_TO_BIT_NUMBER(v) ((unsigned int)(v) % 32)
+#define APIC_VECTOR_TO_REG_OFFSET(v) ((unsigned int)(v) / 32 * 0x10)
+
 static inline bool lapic_vector_set_in_irr(unsigned int vector)
 {
-       u32 irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
+       u32 irr = apic_read(APIC_IRR + APIC_VECTOR_TO_REG_OFFSET(vector));

-       return !!(irr & (1U << (vector % 32)));
+       return !!(irr & (1U << APIC_VECTOR_TO_BIT_NUMBER(vector)));
 }

 static inline bool is_vector_pending(unsigned int vector)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 1638a3da383a..56369d331bfc 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -145,8 +145,8 @@ void kvm_lapic_exit(void);

 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);

-#define VEC_POS(v) ((v) & (32 - 1))
-#define REG_POS(v) (((v) >> 5) << 4)
+#define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
+#define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)

 static inline void kvm_lapic_clear_vector(int vec, void *bitmap)
 {

--




