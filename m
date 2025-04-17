Return-Path: <kvm+bounces-43563-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D18DFA91B52
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 14:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43AC219E39E0
	for <lists+kvm@lfdr.de>; Thu, 17 Apr 2025 12:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B76223F419;
	Thu, 17 Apr 2025 12:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IRNvrTBb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F6A18787A;
	Thu, 17 Apr 2025 12:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744891231; cv=fail; b=aZxSWVvnL47y9ZvU1+FD7mvQelXRbiTeSjZig2jgE/b2X+zT4mbce35SbZzkMWl0bS4sHIaT843KJhz2NOXsSiZad5Cx0SbZ1TSu8uUvrEmLq8zRyO+jbSJrCVyF7SP4b3vMOynvPGVL30r0EtQ8TQAET25aWEyQsEEmSGPVysk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744891231; c=relaxed/simple;
	bh=H97AZeKk8aMPsvMg2d1Owz3W6Qmc2ON4dYSaiNOAJVg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oNHAy8sIvRv1raeaJLHWrkSdX8P/o4yUgW2WAuLI3fXFpiI+trCsqdSqXtg4h+5xAUcPq9HW4TcNtXAyCxPbRzHUa/rWfU/exguj0+bKnobIwIW5iEsz3UiI70gBaias+fwhjs+E9YyK1gb1QnWyT6BSPEtZ9rXUoyNSR48bxa8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IRNvrTBb; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IUnZ4RUYOigF1FvYPkBP7pPe6HXQ03u5ifXrwiIA5x+EOja1dCbY9cgYMq4ZTbx7Cc/bJU0WDUTPSDr6lL1ftBoTXV2+lJn6sBGRMLe6SkB5Ni2NVvP8WNlu8Cgz3jFzLAb9+kQ0nVONVoprsizflDkVDEPu4heEKwgSjxzQ2ODhOke0gxtzUZL4NVjRoNzT9G+yx5i8XIsaqCTct4Otz/9OYWCxQIqG/HoAfrXunC7iQogfAqINQIFVkrN1jSDD9IgcFF2uszUFrKTCX5g6X+iujMrymP3Be2rxl/EsyNM+FNU6/C5ydcK4K/RveiK7IvWXAZcaS3o7nxoKFHT0ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7hoZT4BxKvYWIgLPR1t8iQ2sfHMKaHcnvCWPkBurJM=;
 b=Z5becw/y8BtVFmKkdYlYM9pBUPZ0WOvQaQmFFOUGLw5myyMQ4Dc62sSz3qe+VIynVt0oOEXzXhjY3ocsta+k12esYY65Tpnsfb7jOTRW+6ux2acUHbFJcqRTMwY9/UdDzfJrT0zj6RPYLPSgQZ57WyUCGX58UYCkjlUt85+D1VEafxBlSr7pmvwZF43ASXzwlSKAbyCajgoGMI2mKxnfK7Alb3YQnW1XFdMvhElrMK0uIpAmnTlPKQL0MgtZiQfta08K2fUOpAj2v+uHH2sTwIFeVRy0jOyhVDBeH908vv7j5LQxgoHqLfWfU227MhV/0E4TXLYJNWftVAxz2Sqjhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7hoZT4BxKvYWIgLPR1t8iQ2sfHMKaHcnvCWPkBurJM=;
 b=IRNvrTBbmrrdYvkTvi6OkTuHQzDCEZcxh5oQYgZVEJt5ISjOgCl0JrP7Gc6cQgmWqqfJEvG4Qy9Q54MWekBPoIQusNnyWjG2yzk8owBAlaPectYBMhB9v3Bi7+5iTjlvKijBGD+MXIWq0ihulGSC/uOkaZ5u2skt0BTb2P/pn74=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11)
 by SA0PR12MB4448.namprd12.prod.outlook.com (2603:10b6:806:94::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Thu, 17 Apr
 2025 12:00:27 +0000
Received: from CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0]) by CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0%5]) with mapi id 15.20.8632.035; Thu, 17 Apr 2025
 12:00:27 +0000
Message-ID: <be31db14-9545-4d11-9392-458782e10b48@amd.com>
Date: Thu, 17 Apr 2025 17:30:13 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/18] x86/apic: Add update_vector callback for Secure
 AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com, francescolavra.fl@gmail.com
References: <20250417091708.215826-1-Neeraj.Upadhyay@amd.com>
 <20250417091708.215826-7-Neeraj.Upadhyay@amd.com> <87a58frrj7.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87a58frrj7.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4P287CA0105.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:276::8) To CY5PR12MB6599.namprd12.prod.outlook.com
 (2603:10b6:930:41::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6599:EE_|SA0PR12MB4448:EE_
X-MS-Office365-Filtering-Correlation-Id: 767106db-157e-4e43-97d7-08dd7da770c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U3kzQkNVMmN4NzlMbEtmeE43Nk5OM1N0d1IyU2lzMWRwek9wWjltWi95Z2N0?=
 =?utf-8?B?bTliSFk5MERodXh0VE0xdENCTG5qMVhXakZhU0FIampLVTYwcjRwdkZJTVQ4?=
 =?utf-8?B?SjVJWlVtTmdya1VQaC9NRms3aXFkY0tieWFWVlRBUGp5NG80ME0yazB1NUo1?=
 =?utf-8?B?cGg5MnVZYUN4YXpLN0ZaSkl1OGkzeElyZ1Z2ZGxaZ1dNWmVpMjM4VUxXM0kr?=
 =?utf-8?B?ZGUxMUlvTlkvd1dSbWYxMU4zQWNTRWxDbHVjRlZ2L29WWGprN2M0N0F4NjAv?=
 =?utf-8?B?V2l6c3Q1UVNzQWJua0pyWEs2dFY2S2xFWnhXc09HRmExUDJwUzE3bUpDMnZP?=
 =?utf-8?B?L3VXb3VCdkFqUytjdFpqWXNBd05RZnQzTUxlNXFSdkl4VWN5SklJbVhVcU1w?=
 =?utf-8?B?cGVGN1oyT2d5VVlJUUFhZ2U4OGMrWXFodDJ0QUpYSTk3M0R2dHVNQ01ocnkv?=
 =?utf-8?B?b2hpY21RL3V4TUNweURJbCtRRHpLTDY4K1BhVGRYaHBUbFZ0d2xEVU0wcUZU?=
 =?utf-8?B?SWNZeHJCVmE4d2dFMGJUOElodXpBeGgxYnBUVmFSM1VOdFh1bVFRYldBVWN3?=
 =?utf-8?B?ZXBHUWI1UXQvQmtWelY4akd6YnIwSWZnRi9ZZU90ck8wYU9wemtJekMxaGRN?=
 =?utf-8?B?ZGlkSmhibEVDZ24zTzVDV3lrNVdjTVpOUWZOMEZBU0JkK1l0TnM0SFJHSzdV?=
 =?utf-8?B?MDI2RFZrcmNqU0xGbXFKYStJTXBlYW90VERDZmhxa2JxdENYamUrUks4QWJ3?=
 =?utf-8?B?OXpQY29mVGg1Z3hwMnluRzFsV3NHbnk4UDZHSjBCblJNSHVMY0ZLNFBUNjBK?=
 =?utf-8?B?OXVadWNoVDB6aDNmOG9FQzllUjQ0eTMwY3hENFpIazJVakg5bWhVeENYVVV4?=
 =?utf-8?B?aHNNNU14Zmkvd0lEZnc4clZWUWpNWS9ZOHJ5ZllJaUV5eWpTQlJzd2JSbHFy?=
 =?utf-8?B?RlNNVTUxdUJBZGFZdHAzZmo1dEdvbFMrR0loSDErZTF4bW9VZWpPQllYRnQz?=
 =?utf-8?B?YU92VDcxWnpYRGJtZGVjZVRCYlA4Y3ZsU1hSZU9zWm02bFpOVEk2d1kzKzd2?=
 =?utf-8?B?dFR4WXI3ZUR6Nlo0L2p0TFQyZEljUWo3YXF0Nk9KU0duU0FCL2toMERPSHdQ?=
 =?utf-8?B?U01VbW1Tcmk1bHdhald6WmNEWDlvN0FyVFl2OFkvYlJPY3IvY0YyRGFrWVlQ?=
 =?utf-8?B?SmE4Vk94b3hlNVRISk1qVFpoNEpyRjJVUFIybVEvZVJpaC9NUW5vaFN3emlw?=
 =?utf-8?B?MFJ1UUpJRzNteHBCZjgvOTBCODFNMGVXU0FlakdjUklQOTM4dFhIRVgyVmtV?=
 =?utf-8?B?dXF5UXVBUGZSR0ozR0JjNkYyQzVybG5NUkxHSTlOMUFaZEZ2V3Y0N21oNGJy?=
 =?utf-8?B?Ny9sVktpUzExYWpkeE9hdHQxQ3grSlVOd1pWSmRseU9DZ0tyWTZjdVU5UW5B?=
 =?utf-8?B?UVBKSUxxdjl0Ri9JcHYyeXorOEZuZkRLSHprakkrMUU5ZjRwMXJuYkY0TXll?=
 =?utf-8?B?dG9LU01IMVNDbjV6bUhuTk1VaHJTMENmTlczNnFJZjk0WHg2TWhDVENISmVk?=
 =?utf-8?B?cW1hTEFPeTFjZEdhNkFhZnR1UUcvdUlLdnoyTzFpR0NNTXlaQ1NaSFRlSmlE?=
 =?utf-8?B?WW1yR3NIcmV5UkQ2bzllNFc1MjFRRjJLYkdVNlJLR1hCRkwyN2ZhVlVXT1Ns?=
 =?utf-8?B?d3cwUk5tc1ROTUo4RFp5Y0FPZkNOU0J1N1Ezc3ZrYjUzcDNDZTRULzVydytq?=
 =?utf-8?B?V0puS2Q0UllqcnNEL3B4bStEczhjSEpoQWVUL3ZwQjNiUjhlaWdOWEphUnI3?=
 =?utf-8?B?UFl4VXFNQUw2ODFjWUFUUmJ6OUtRYk9HbTZEbTJja2htSnpRYm8xZUdjd0Rs?=
 =?utf-8?Q?kM0EW3QPH3vDe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6599.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjdScEhQS1BpSnBTR0sxWlJvTVVlbHJ4OUVtSm03NUJoSTFwVHozQndOWG9N?=
 =?utf-8?B?UWdzazl1SlcwNGdNZGs2MHpibDJNVUw0aVNIRG1mZ3lrOXJKZWFoNjJlTjFS?=
 =?utf-8?B?SnY4aTEzR2xZUytPblhqTm81ZU5BZytpRE1QNkQvbGtMMVNxak5MSHp0YlF3?=
 =?utf-8?B?UVQ2c1lQdndFcHlEL3pCeU0zZ0JzR0lkRUo4UEJTZGdTbkRVTXZrZHFwY0Rt?=
 =?utf-8?B?R0pvTEdQbDhiN2oxUGJrNFIva29qMmZjdnVEcEg2cVJMWUFKOFhXaERTODQ4?=
 =?utf-8?B?ZmpOSEFiZlBrQ0tweVU4VThXYXRSbWhrR004M2NYMThnSFZKaUtYcEIyQWN6?=
 =?utf-8?B?UlFNYm04YWxySE1CVUdrL0Fack05dHFGaXVab3MvM1Y5bVlzeDBIN0FhZVlv?=
 =?utf-8?B?VCtnUG9kTDErOXBLaWFsRS82ZVRDS2dpOTVNTllsQlZSUFByZWFSYXZMbzgx?=
 =?utf-8?B?bk45MlRkVTFqVDJJTTlncFpBZSsvZjFxTjFNb1JYeG1lMnV3OFNRL05CamVp?=
 =?utf-8?B?TjF1ak9WMlUyaDRUNUpDN21weC9nYlVlWHFBdC8yaTZnN201SjNmTlZMK2pG?=
 =?utf-8?B?Smt1RzdUSFlEenVYTGRodDJackNjVnRUR2ExZk04MjNGVTR2OVJaVjkvd3M4?=
 =?utf-8?B?MldEUEtaWEt5bVJVa0lscXZoTjhmUE9UTm5xeTVid2puOEVKVlZrTHdGRHRT?=
 =?utf-8?B?bUYrbEpLcndJTFlianpXWittWFA0QjZ3WmVVT3dWNEtvR1ozUFA0cmllMHE2?=
 =?utf-8?B?NTUzRThxRmM5aEJIa2VMblVDTUFNcnQ3eE1TQS9qbGZLT294Q2x3VVZ4b1R6?=
 =?utf-8?B?OEsxaVdjUmdNaXZ3UVZDRzlGMU04S3pYRW5rUmxZTWwrV1hXNlkyeHpPZkR0?=
 =?utf-8?B?MUF3YlRKV3RkZENKVWJrQWdyclNwU3lTSDhuc3V0SVNYUG42Yk92K1BVcWdl?=
 =?utf-8?B?dzlhVXQ0MVozN293L3QrangrRDVVSisvMmU5aHF6MEV1MFNQNUhoUzcwNktU?=
 =?utf-8?B?MGhrd3gyc2taWE50ZUZQaE9JSEVLaFBmeFE4eTczTHYxYWFWNU1oYnViRkty?=
 =?utf-8?B?K214eUd1M3ZtWXNQWUZaUldCcjF6aS9VbjhVanhjMENNZk8rY3FDZi9HODFB?=
 =?utf-8?B?NjZNdUxlYS9QSk15aG00N05uN3pIQzZQbXRwdmN0czVnSjZzcTdpZTJRVmRs?=
 =?utf-8?B?RmdLMCtZb3oyV1ZFWnlrcXBFQkx5bWJ5MVJXZFNjaHV5L1dxWnVpQ0dVMDhW?=
 =?utf-8?B?MjlNQXVSWTJjRVh1aEwybGVsY2xTQnVxcFllMkE0MGJVQjFra1p6TlgwbWhC?=
 =?utf-8?B?bHQvYWtEdkcvL3V5RHRyL1U0b00zN2gxbnR1TFpGckcxVGJBRmxock5TL3Zw?=
 =?utf-8?B?dGJ2YS84Q1NlQW13NFkyNnB3Nk5zZUduaVVDcW43eUdOZGhzeW1oUE5Na0s4?=
 =?utf-8?B?cnlqcCtSaWJlOUtJeHhEOFFvTzZUQmJCdDRvR0R2bnNBK2UvYkFOKzlKTVp3?=
 =?utf-8?B?K3BvOVhhSGVSYVM3SXFsSUxIM212K0FSeExVeHVINVVUM2xneW5TV0ZCMVc3?=
 =?utf-8?B?Vkk3UXZEU0xDcllTWmdweVNsK003eEtGQ2dmRzM0bTZSdmVlRlpmZ1hiUUdB?=
 =?utf-8?B?d1ZmRWR0aEdob3JjdE1GVEJadjM1WmhvSFNqeFpoVmhsM1U4eElGbDQxTlpJ?=
 =?utf-8?B?RXg2b1BkazBSQUlSRHBKbFRpTVF3amN0MS9TQmRjcFhQWjlTeXJCSFZZc0ZF?=
 =?utf-8?B?TS9jVmJTK0NGOGlZQVAvaEpyYXhKQk15T1FWdDBoekIxeEMyKzhIQ09jeS9U?=
 =?utf-8?B?VWF6K043L2JSM1FwQnhwYytqT0l6RzJzNDlUT05LYTQyY2VVblFqalFIUVlT?=
 =?utf-8?B?anUva3hFT3Z4QkRhWGVoTEF0WmJtSDltVnVQcXB2SVoxaGhPTHlkNU16a1Ar?=
 =?utf-8?B?NkVBZUd5aXR4T3FXV2NxN3NZNytCMkNacnBDYitKanVLZGlQS0tDOFdvVE5B?=
 =?utf-8?B?L3Zya2FOSnFHZ0FvN0dPY01xNkFYY0liaExBL0ZGSWdjLzlOcVpTZFFJV1NG?=
 =?utf-8?B?NVR1dm42dDBWWjFJd3c1VVRtMWdJZkNRMVMzSlpEK1Z1Q25OYlpkR29ZY0du?=
 =?utf-8?Q?jxhcdhtqsaqheBukud2QuRU0h?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 767106db-157e-4e43-97d7-08dd7da770c5
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6599.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 12:00:26.7107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCsxZk8NYbXOTFAOyGGvuuQUJsF9NLapnOln9oeIBA2AgrZ6c0iZXiyu3l91hrVlbScFyByvudE1qViyVedVWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4448



On 4/17/2025 4:20 PM, Thomas Gleixner wrote:
> On Thu, Apr 17 2025 at 14:46, Neeraj Upadhyay wrote:
>> Add update_vector callback to set/clear ALLOWED_IRR field in
>> a vCPU's APIC backing page for external vectors. The ALLOWED_IRR
>> field indicates the interrupt vectors which the guest allows the
>> hypervisor to send (typically for emulated devices). Interrupt
>> vectors used exclusively by the guest itself and the vectors which
>> are not emulated by the hypervisor, such as IPI vectors, are part
>> of system vectors and are not set in the ALLOWED_IRR.
> 
> Please structure changelogs properly in paragraphs:
> 
>   https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#changelog
> 

Ok

>>  arch/x86/include/asm/apic.h         |  9 +++++
>>  arch/x86/kernel/apic/vector.c       | 53 ++++++++++++++++++++++-------
>>  arch/x86/kernel/apic/x2apic_savic.c | 35 +++++++++++++++++++
> 
> And split this patch up into two:
> 
>   1) Do the modifications in vector.c which is what the $Subject line
>      says
> 
>   2) Add the SAVIC specific bits
> 

Ok

>> @@ -471,6 +473,12 @@ static __always_inline bool apic_id_valid(u32 apic_id)
>>  	return apic_id <= apic->max_apic_id;
>>  }
>>  
>> +static __always_inline void apic_update_vector(unsigned int cpu, unsigned int vector, bool set)
>> +{
>> +	if (apic->update_vector)
>> +		apic->update_vector(cpu, vector, set);
>> +}
> 
> This is in the public header because it can?
>

apic_update_vector() is needed for some system vectors which are emulated/injected
by Hypervisor. Patch 8 calls it for lapic timer. HYPERVISOR_CALLBACK_VECTOR would need
it for hyperv. This patch series does not call apic_update_vector() for
HYPERVISOR_CALLBACK_VECTOR though.

Given that currently this callback is not used outside of apic code,
do I need to add it to arch/x86/kernel/apic/local.h or just remove it and use
conditional call in current callsites?
 
   
>> -static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
>> -			       unsigned int newcpu)
>> +static int irq_alloc_vector(const struct cpumask *dest, bool resvd, unsigned int *cpu)
>> +{
>> +	int vector;
>> +
>> +	vector = irq_matrix_alloc(vector_matrix, dest, resvd, cpu);
> 
>         int vector = irq_matrix_alloc(...);
> 

Ok

>> +
>> +	if (vector >= 0)
>> +		apic_update_vector(*cpu, vector, true);
>> +
>> +	return vector;
>> +}
>> +
>> +static int irq_alloc_managed_vector(unsigned int *cpu)
>> +{
>> +	int vector;
>> +
>> +	vector = irq_matrix_alloc_managed(vector_matrix, vector_searchmask, cpu);
>> +
>> +	if (vector >= 0)
>> +		apic_update_vector(*cpu, vector, true);
>> +
>> +	return vector;
>> +}
> 
> I completely fail to see the value of these two functions. Each of them
> has exactly _ONE_ call site and both sites invoke apic_update_vector()

Ok, this was done to associate apic->update_vector() calls with the
setup (irq_matrix_alloc()) and teardown (irq_matrix_free()) of vector,
which was my understanding from your suggestion here: 
https://lore.kernel.org/lkml/87jz8i31dv.ffs@tglx/ . Given that there
is single callsite for each and vector_configure_legacy() calls
apic->update_vector() outside of alloc path, adding it to apic_update_irq_cfg(),
as you suggest handles all callers.


> when the allocation succeeded. Why can't you just do the obvious and
> leave the existing code alone and add
> 
>       if (apic->update_vector)
>       		apic->update_vector();
> 
> into apic_update_vector()? But then you have another place where you
> need the update, which does not invoke apic_update_vector().
> 
> Now if you look deeper, then you notice that all places which invoke
> apic_update_vector() invoke apic_update_irq_cfg(), which is also called
> at this other place, no?
> 

Yes, makes sense. apic_update_irq_cfg() is called for MANAGED_IRQ_SHUTDOWN_VECTOR
also. I am not aware of the use case of that vector. Whethere it is an interrupt
which is injected by Hypervisor.


static void vector_assign_managed_shutdown(struct irq_data *irqd)
{
        unsigned int cpu = cpumask_first(cpu_online_mask);

        apic_update_irq_cfg(irqd, MANAGED_IRQ_SHUTDOWN_VECTOR, cpu);
}


>> +static void irq_free_vector(unsigned int cpu, unsigned int vector, bool managed)
>> +{
>> +	apic_update_vector(cpu, vector, false);
>> +	irq_matrix_free(vector_matrix, cpu, vector, managed);
>> +}
> 
> This one makes sense, but please name it: apic_free_vector()
> 

Ok

> Something like the uncompiled below, no?
> 

Ok, makes sense. Looks good.


- Neeraj

> Thanks,
> 
>         tglx
> ---
> --- a/arch/x86/kernel/apic/vector.c
> +++ b/arch/x86/kernel/apic/vector.c
> @@ -134,9 +134,19 @@ static void apic_update_irq_cfg(struct i
>  
>  	apicd->hw_irq_cfg.vector = vector;
>  	apicd->hw_irq_cfg.dest_apicid = apic->calc_dest_apicid(cpu);
> +
> +	if (apic->update_vector)
> +		apic->update_vector(cpu, vector, true);
> +
>  	irq_data_update_effective_affinity(irqd, cpumask_of(cpu));
> -	trace_vector_config(irqd->irq, vector, cpu,
> -			    apicd->hw_irq_cfg.dest_apicid);
> +	trace_vector_config(irqd->irq, vector, cpu, apicd->hw_irq_cfg.dest_apicid);
> +}
> +
> +static void apic_free_vector(unsigned int cpu, unsigned int vector, bool managed)
> +{
> +	if (apic->update_vector)
> +		apic->update_vector(cpu, vector, false);
> +	irq_matrix_free(vector_matrix, cpu, vector, managed);
>  }
>  
>  static void apic_update_vector(struct irq_data *irqd, unsigned int newvec,
> @@ -174,8 +184,7 @@ static void apic_update_vector(struct ir
>  		apicd->prev_cpu = apicd->cpu;
>  		WARN_ON_ONCE(apicd->cpu == newcpu);
>  	} else {
> -		irq_matrix_free(vector_matrix, apicd->cpu, apicd->vector,
> -				managed);
> +		apic_free_vector(apicd->cpu, apicd->vector, managed);
>  	}
>  
>  setnew:
> @@ -183,6 +192,7 @@ static void apic_update_vector(struct ir
>  	apicd->cpu = newcpu;
>  	BUG_ON(!IS_ERR_OR_NULL(per_cpu(vector_irq, newcpu)[newvec]));
>  	per_cpu(vector_irq, newcpu)[newvec] = desc;
> +	apic_update_irq_cfg(irqd, newvec, newcpu);
>  }
>  
>  static void vector_assign_managed_shutdown(struct irq_data *irqd)
> @@ -261,8 +271,6 @@ assign_vector_locked(struct irq_data *ir
>  	if (vector < 0)
>  		return vector;
>  	apic_update_vector(irqd, vector, cpu);
> -	apic_update_irq_cfg(irqd, vector, cpu);
> -
>  	return 0;
>  }
>  
> @@ -338,7 +346,6 @@ assign_managed_vector(struct irq_data *i
>  	if (vector < 0)
>  		return vector;
>  	apic_update_vector(irqd, vector, cpu);
> -	apic_update_irq_cfg(irqd, vector, cpu);
>  	return 0;
>  }
>  
> @@ -357,7 +364,7 @@ static void clear_irq_vector(struct irq_
>  			   apicd->prev_cpu);
>  
>  	per_cpu(vector_irq, apicd->cpu)[vector] = VECTOR_SHUTDOWN;
> -	irq_matrix_free(vector_matrix, apicd->cpu, vector, managed);
> +	apic_free_vector(apicd->cpu, vector, managed);
>  	apicd->vector = 0;
>  
>  	/* Clean up move in progress */
> @@ -366,7 +373,7 @@ static void clear_irq_vector(struct irq_
>  		return;
>  
>  	per_cpu(vector_irq, apicd->prev_cpu)[vector] = VECTOR_SHUTDOWN;
> -	irq_matrix_free(vector_matrix, apicd->prev_cpu, vector, managed);
> +	apic_free_vector(apicd->prev_cpu, vector, managed);
>  	apicd->prev_vector = 0;
>  	apicd->move_in_progress = 0;
>  	hlist_del_init(&apicd->clist);
> @@ -905,7 +912,7 @@ static void free_moved_vector(struct api
>  	 *    affinity mask comes online.
>  	 */
>  	trace_vector_free_moved(apicd->irq, cpu, vector, managed);
> -	irq_matrix_free(vector_matrix, cpu, vector, managed);
> +	apic_free_vector(cpu, vector, managed);
>  	per_cpu(vector_irq, cpu)[vector] = VECTOR_UNUSED;
>  	hlist_del_init(&apicd->clist);
>  	apicd->prev_vector = 0;


