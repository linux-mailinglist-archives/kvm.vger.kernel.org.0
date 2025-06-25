Return-Path: <kvm+bounces-50596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F222EAE742C
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 03:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92B011920FC1
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 01:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97BAB136672;
	Wed, 25 Jun 2025 01:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oYiLt3cR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E7B2557C;
	Wed, 25 Jun 2025 01:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750814166; cv=fail; b=pYSS46KxxT3Okixx6esU1PxQBj/c8+VBKqYJVfZr9clmsMWFZOrNjNhill4IU6Jp5o9Q/LawfDVKEOfVY8nF+9jtjjskpLRj+gayKyNWl8mdYI9MN6U53d6Kyy+NQb8xwr3LtNjeP6nxCFvIlo3IB65Tlv/9Zymo0zm/gBhdD6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750814166; c=relaxed/simple;
	bh=ezI2b4bKBWQn5tubRtPR1UTy/t9b4lJgIJEAK4D9T6o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gLwfUktOpyZ9tIx3TZ4K958hysvGkOOzKggeljzbuD7MgSFj0Du+BL+BulHHJyesFtrVPGmkMHCurrzkpYlwt4H1X5zcrJ2PFhmbEGUzvbvjQ0Gx+a1fxWBmMDXsr4ksmq4cGMZdQPDzf5Z+zgvMfINN+JxLfiGpbNzVwKpmEoA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=oYiLt3cR; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g1NntRKf+uAvJ3C0zWTbUGQskEFxmMWzwLr6pmGmxtymVzTPKpCdHqy/z8rA2OH6AtTH8xTH/aDNePmUJB4rCC3VfirbZvL05OWE7dgifFPj3rQqBdnQH/kXQypsItDTkWIQznblFhoLeuhgFgk2ULrWX1zpXh/g5kvlQi8vJWXa3a/s0l3novsoJwU86ed+oQMoznfPnZjdVhQvaDRS+8TU/QQEPR2uGVL/4dTFr+tk6Tr3+HYcFRvgZzOWDtcfWuCigOHLEEVraMMeCoos11p9uEveN3d63kz7HehVDiFMjXUW0bIURBKukE77/azQ/S3wuBxpmoSG/REJRJLrAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZIeUQIh6JuS+dfdQQ4JSMjcOOMp3uTGtaP7CdJ9YpQ=;
 b=Puh49eLrFeKKPMlpdjSAX9+WLGvLa/M23aVlYmysUzwLCud0eztMbmiT06JmQ9xHpcmXUpprbkXAPnjrEVGNISiVBAa+/LJZ8V7FwFavwQ/5PIlbWu5AY1cA6CM9Q2GbjJNc67noXqAxXjMODd1ZnwUTd1bxEqcdlvj4dS3+d87K9M9UljJSmypfES8LYO/22WmsOY2CLsE1CxvArh4zvEcbksQlQa4VdYj+7G6d166swQWluJn35GesvyL8OIs834ryi/HztZvUysnoYUEKvn1pC91ySOn8+Ftzvz4RGx9yX27PKdcN2gl0gyBRKOWibXpUuRr848Xypy3zNNPI2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZIeUQIh6JuS+dfdQQ4JSMjcOOMp3uTGtaP7CdJ9YpQ=;
 b=oYiLt3cRn+M4fDx3ShC3DB7riFYW0o5jcaUdRsV3NzYCsQpyLd7g8pRxGghmGob3jz5Y+5maWCZ/SiNUDfJni1poCA9UZQU1BA7evPma53Z47dnEbiXgqwFDCdWJcV/t4K49DfjyY/5+5DAe4oFvuUdLtReu5qWfVvkPjGo95tI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SJ2PR12MB9137.namprd12.prod.outlook.com (2603:10b6:a03:562::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Wed, 25 Jun
 2025 01:15:59 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8857.022; Wed, 25 Jun 2025
 01:15:58 +0000
Message-ID: <62c17e68-8078-42da-a616-75cd0885001d@amd.com>
Date: Wed, 25 Jun 2025 06:45:46 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v7 17/37] x86/apic: Unionize apic regs for 32bit/64bit
 access w/o type casting
To: "Huang, Kai" <kai.huang@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "tiala@microsoft.com" <tiala@microsoft.com>,
 "Vasant.Hegde@amd.com" <Vasant.Hegde@amd.com>,
 "Suravee.Suthikulpanit@amd.com" <Suravee.Suthikulpanit@amd.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
 "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
 "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
 <mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "huibo.wang@amd.com" <huibo.wang@amd.com>,
 "Santosh.Shukla@amd.com" <Santosh.Shukla@amd.com>,
 "nikunj@amd.com" <nikunj@amd.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de"
 <bp@alien8.de>, "francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>,
 "naveen.rao@amd.com" <naveen.rao@amd.com>,
 "David.Kaplan@amd.com" <David.Kaplan@amd.com>,
 "x86@kernel.org" <x86@kernel.org>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-18-Neeraj.Upadhyay@amd.com>
 <05a9de6392a4ade9c9e70953be2a6a87a06044ca.camel@intel.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <05a9de6392a4ade9c9e70953be2a6a87a06044ca.camel@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SJ2PR12MB9137:EE_
X-MS-Office365-Filtering-Correlation-Id: 91088415-722e-4c8e-125e-08ddb385d786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGpMSjdYUk8vTkJjVkFmQ1lLZC93ZkliQmJPd29nTkd4cTRKKzdCNG9jVWNT?=
 =?utf-8?B?MnpTOERpQ1NNaEVtaS95YTJBMmJJZHVFOG80MThwbE9rS2g2R2M1ZkFobmlT?=
 =?utf-8?B?SFZyZm5oMTNpTmFkclRoaWJrYjZXZk4yakhvdm1qaThTQzV1dy9NVzlPSi9Q?=
 =?utf-8?B?RUpiWTE5RDA3RlQ0MkRhUWQ3MDZsdnlXY28zaVJwQjJhZ0g2Q3hrRnY5TlJr?=
 =?utf-8?B?OEtjNEV3OTJSMm1sZmN3d1lJNXIvSDVnWVhKSTlyalZuZFlXbS9wVHFaMVd6?=
 =?utf-8?B?WU9OaUFTT2tGcG0zZGxBV3k5SWpndmliRDN0OTI4eHJWWFJJaG9pRVhCMXhn?=
 =?utf-8?B?b3ZzNkFoWG1nTkpkd0hwTmd0bmxNV05lTTh6L3dJS0lmeEtsYlpjcTNacnV5?=
 =?utf-8?B?aVZ4QkxwVUlQN3Ryb2grRWozZitoWFZyYnJMb21nM0RuUmVjRVZUWWdtalpO?=
 =?utf-8?B?NkNDaXJMeFFhY2xTQ3hmWm9xeThKRnBUbmw0TE82OGZBQ1RDSjVlbjZnd3J1?=
 =?utf-8?B?VzBzSzJKaXBzUmlSUHBsTHI4V25pL21YOUlQNm1FOUhXWGdaN1JlYlB1ZE9N?=
 =?utf-8?B?SkxHc080RWxsemhpTEF6QTJWV3hPMU1XOXNNZDNFaTZVNjN6NHh2dmZPK1lN?=
 =?utf-8?B?Q2Z1VjZwQlVsWklFYkgycVhBR2tjZ2tmVHlDZFVJL0RpanFjeEduNitSMTky?=
 =?utf-8?B?TlROZjhoRVZPcmltYzUxYUYwaEthK3NGakNNaXF5NERPREhqaHoya0k2TVhm?=
 =?utf-8?B?bmJpSGNSS2EySXRiNWxsalVzQmtmVUZXTjlOZnV3TnBEbUoxTndQV0JQS0FK?=
 =?utf-8?B?QlBOdEliRVpxWk9PdWNldFZjaXlPbExNaVpUTlRzVWF1cXlJZ3hqOENkWXh4?=
 =?utf-8?B?TmlZLzQ4R3BxdmRqSTQ1UTZ2VlBzTktDdUlhL2xqamdUV2lwUWVoN2NoSlhG?=
 =?utf-8?B?ak10dnRGSU12QkVNSVNOZ3ZXL3YvYU9aVkluTmtXcWo1L1JNSEptS3BRbmRX?=
 =?utf-8?B?akNQRWM1TkNGWWgvalRVdEYvNmt2YW1Ic2tNTnl0ZmJxbjduOHFPdkdYempo?=
 =?utf-8?B?MWI4dUoyM3YvbldUQ1IzbDlNZnFhRlBpS3pLWTJxU1hndUhvUy91N2JZbDda?=
 =?utf-8?B?eE13ZlZaZFpVSHgzY3IvbHNpWGdlUWVSWWRnbDJpOHl0ODY5UEFBTHNiV2Z6?=
 =?utf-8?B?L0lScjVnVTYxWFJyajB4TEdrTXFHUXUzSXpKbnF4WUs0Ulpjby9zNlp3ZVlX?=
 =?utf-8?B?UTdLb0F1NldQNnkxdEc0NElabW43aFlZMkxPQm9PSXdoV3BYdlYxUExiQnhC?=
 =?utf-8?B?dFBQVjREempYQkkvLzh3YU1wQ0Q3OHBDMk5MOTEyekdVaWI1eUlLOW5GYmlK?=
 =?utf-8?B?dnlYSHMzclkxNGdORWZnc1diclBOWjdUaGlGL3BCVnBGREZDMmZRSnFkUTBm?=
 =?utf-8?B?M2EwYkx3ZjFJRUExTVJqdzlNeE1VR1NVZ2xZWDRaU1Zsd3YzTGIxL3RxYXls?=
 =?utf-8?B?dTAzRDdhZzEyWW96R1AyMnZnWlRaVWVDNkYvTXBibmNuM3hSUWRlL0VrNWVn?=
 =?utf-8?B?RFhzNmFlay80cTZhVldpZGc0aTFBQ3JjcEVnTG10aUErNjhYYmc3T081Umkr?=
 =?utf-8?B?a3dkYUluNjNTKzlrNjlhamR0QkhBVkhZS1NuaTBPMkJWcjZYbDFYNWxLT2VB?=
 =?utf-8?B?N2d6dFYrTUhleURrZVBaTk9xeFlKWTFpUWhrSTN1dXo1ZUhFY1BkVm0yMTVS?=
 =?utf-8?B?UFNxNVVoMUFsNlVDSzZINUxPZDFYSEZ4VTlUQmxQR0I0UVloektzdjNFcEJT?=
 =?utf-8?B?bW44QkVHWVpzc2dzY21JZ2tNWHBEM0c0VW42RVVnd1RjWmFlaEpTL0pTZEZL?=
 =?utf-8?B?M0pmSG16MUQxN2ZYdkFwWDBYTk5JVm9pZGZBV3ViWFNOcWZqU3d3dlQ3NzZk?=
 =?utf-8?Q?u8GoE8+WvVM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TmJsTTBYVE1TcTRiT2VFNHNNdXM3clZ6ZnVKQ00zN2RTNVR2ZHdWUEE3bjU5?=
 =?utf-8?B?R3Bnb2x5SjhhWGc4OTVCSW5abnZ3ZFpkbnBwMDNSTHNMTFpZcDlyOXpneVRH?=
 =?utf-8?B?cnhDM2JwWitvR2k4QUZIUUJFUWhEcldrRi80dnhSeWFCb1FxbU9LeDRiNDAz?=
 =?utf-8?B?aTJxVjVPcE94cXdKenV1Y3U5b0hHNFlpZXdvVFk2NTlXdXIybmpRMWZDNGNV?=
 =?utf-8?B?SW4rWVZEMm1sR1RPV0t6RjdhR0FoOEpsVkl4N2JQVVp6ZWI5R2l4eFE1L21I?=
 =?utf-8?B?eE9ta0xkRkM4VHp4NmJvaXFUVWI3ZlhZRVpKbkNZeTNIRlJ1aTBXaCsrQXhR?=
 =?utf-8?B?Zi82T3pHaU01cXZMNHhZeG1OMDdJMllYanl5Z0duanRZTlp4T2VabzJERG5W?=
 =?utf-8?B?WU5yMzFmcU45cisrUGt2c3N4ejFtamhDc1FGZytPaDZSd2RJbHdYdHVVWWFi?=
 =?utf-8?B?YXd6S2NMTWRxbVFDL1phTXdFZTd1TFRFdXYzVENOMzl4VTZ2OGUrTFBneTYr?=
 =?utf-8?B?SzZ4SHpDVjBzeGtJVzdNeFNuRXAzQ3czUm90RjFDRkF2enFpQVZPMHRVaTMy?=
 =?utf-8?B?SHFZc3ArMWQvSjA4QUxFUlp0MHF0TWxXWVBMZzkyckVWbzU4WWJ3c0tXWUZw?=
 =?utf-8?B?cnQrblhkdzJUVmRwSUtEaDRYbnRrK0VvLzFqdTFabXdYMnRMcjZteUpiSU5s?=
 =?utf-8?B?cTRJdSsxd2t6dGRCMXBiajFleXA2QkdtbHovTDNPZjlwOUh2WXBWUjk5dGZD?=
 =?utf-8?B?RFNLbXEzaXJsUXFJSmx2dSsreE1kK2JWWThZeVJjcVN0YVpxekhuTGV5M0Z5?=
 =?utf-8?B?bEhvd1FidndJRWMrUUVYOTZVK2lBSXdsaVJLcXdtL0wySXpYMWR3SktiU3RV?=
 =?utf-8?B?WWxQaXFoNDZ5VjVJUlhBdklxK25SM3dZdVh4UnlyTDg2ZEluU0ROZjl4UXhO?=
 =?utf-8?B?YUUrbmVKcXFyMXNpd1pOK3h1ZUhVbFlQR0JjUlNCMVhyUXN5c2dYUnFOd1Jx?=
 =?utf-8?B?RWxoSzFFSG9BNjE3UWJZU2xId3JvWUFGWnQ2bVVKQkhQYloyK3QyWm5uUHEw?=
 =?utf-8?B?WW40MDZsTnQzbHlPeTI1N0J1RWlHSk1PUG44MnRwQmhGQkxUOVRUK1dobldQ?=
 =?utf-8?B?c0lHalQwVTdLbnBsaiszRW82R1VRakt3R3NmdkJIU3kzU3RpdldST1g5eTBX?=
 =?utf-8?B?SEJOR3dDQ1QxdnVsV2puTWlZcnpieWIxQ0xLdXBpeFhMaS95a1lZMEg3TERK?=
 =?utf-8?B?OGl3QVkydE9CTlVNRHBNdzdjRXRDQ1VLV2E3bGFWY1Z3VXRuV0tLWHNtcjZF?=
 =?utf-8?B?aDYxRFpkKzcxSG91UkFydzNTMXljcW10blhjNkNsdVV6dVRXQzZlV1Qyc0Fu?=
 =?utf-8?B?ekRxSDUyUGZTdGkyRzE5ckhNSDJtcmJYbmZxTWVBSmtYN0xMQXc4dW1ja3pO?=
 =?utf-8?B?N1ZJTEFsWXNsd2JJSTg1aVpVVUUzWDVqekkyTDJmVmFkL3pyOVFjV2grVEU1?=
 =?utf-8?B?cEpaVlhIUmQ1czVLS2dxVlBPTnkxS1VjZGFVWUd1ZkpadXlxWnppRnZYVmwx?=
 =?utf-8?B?Z0hmM2VIcHEvb1pGbXUvVytxMkwrV1NiemRpcU1ZU04yMldzb1JMWDk2ZWQ2?=
 =?utf-8?B?OEtwMXJDaDI2dDJwQTJCRGIwYzdlemZER0tDdDBOcFNYTjQ3ZW5tcGg4Y2tj?=
 =?utf-8?B?MXpjTFh2eHJJSjNYQ0hLUG9kM0lrd1pMT2VMUjVmRThRSFpJSmowcVdMVlVh?=
 =?utf-8?B?RTdTb2g4U3lOSElocGJNeE1HaTFnb3BrMXAzWVZpSk81WEs4VUg4bFBKVDhx?=
 =?utf-8?B?N0VhTUJUM3VaL21MWGtnSm5zQkxnOVZYd3JJTWRON24rQWdObFJ6RktRTU9Q?=
 =?utf-8?B?Q0lRYjJtOVZwVjZ0T2tLaFRGMHllY3lhektOcDRkUFpGb1hhOGk4NGl4bHRJ?=
 =?utf-8?B?YjV6UUcxWGorZTVGQnNaV0o1SnZ0bUV0dm1RVERPZW5mL04xU2puV25aSFh6?=
 =?utf-8?B?dHlmTnVCMnZHRC82dWtZa0tqNFhKY08vQTVic29qeWRzUFl2UUVkeEhZS21s?=
 =?utf-8?B?M1V3WEpWYTdsS3hXWHNIeFFGOWpqdGVEVzYrYjVpd3M5V1c1cVArSnVnRmRu?=
 =?utf-8?Q?q3V3pexVgpCm+YHDPNP9Z8ZtI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91088415-722e-4c8e-125e-08ddb385d786
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 01:15:58.6817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zAOVgRvT+YbHGL8UDyefa/p4X3crw6E5UzOUqLY0JhOb656E6jBQJ0dJmSmXW4FP6mnhoiNPxgLIx8icmKzu6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9137



On 6/24/2025 3:58 PM, Huang, Kai wrote:
> 
>> +struct apic_page {
>> +	union {
>> +		u64     regs64[PAGE_SIZE / 8];
>> +		u32     regs[PAGE_SIZE / 4];
>> +		u8      bytes[PAGE_SIZE];
>> +	};
>> +} __aligned(PAGE_SIZE);
> 
> The 'bytes' field is never used.  Should it be removed?
> 

It's used in patch 25/37, in get_reg_bitmap(). I will describe
it in the commit log of this patch. Thanks for the review!


- Neeraj

