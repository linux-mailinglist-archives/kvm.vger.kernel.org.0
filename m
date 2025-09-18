Return-Path: <kvm+bounces-58044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 480FCB86827
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 20:48:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DB395627FC
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 18:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBBAD2D63E4;
	Thu, 18 Sep 2025 18:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WBgUvbfd"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012023.outbound.protection.outlook.com [52.101.48.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED982D374D;
	Thu, 18 Sep 2025 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758221234; cv=fail; b=BpqhSI6AHxduEX6udPTU3uPfusJG1fWx9uIDxJ2/o4kPA4xF3p15epFovLDXnTC/I8xyI+Ct2FrVcUTMyAm9pWO1ZoDp4Mq9sXZFQwuQ3VbNoD/nGanAd0AR5YaNNsk8EtvcdZ4dVQdIea+BcrsIysQLaUXseR0ACvx3mZ6lmEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758221234; c=relaxed/simple;
	bh=2detyO4Cu8FhMNl8M2KVNu9I8bkPUb9UrgxaD4PbuAI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X6v44uqw4wgfxrDC/sIItn2hRFRRUuSJ4xcgC5aUN66brPsZQZk6pERWGUEOvI1HGGEZPttkq977jl+CbcStUTTAgWD6bx0uHJkp5q1Gr8YduS4J0Sj2PB2YtS5naIQY5cUtZNF2W9w339HIg1X6inbkKV7ub2x8Qjulwa9bpqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WBgUvbfd; arc=fail smtp.client-ip=52.101.48.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=etAvxVmwq+gDk7BAtnPXxkFb4ZeMfM0Js9X4wpG++QpQBeOIOqna0x8tlNMrR0qXOzBDw3zlJDYBml8yG6x2mWGmUvGQwUVeoeLPRB8qUOwY2atinsYgdom47jeYu12C+AKyokRoldxiYleA0HfO4GWlKpzxr9KUKON6TkbVbJsCNf6wHbxJbSa4VwQjdsx7s4S9m9h2FzdwGfoNB4ysAST8TwtFbEXX39DdrSVLJV23fXcdmX0lVtXM3GO4wwyshzEFJ3lXQHtRUixQdRHWPLrN1+QBa259uTqgU0tuD7IV70UZFcQ9jY/slwMnt90+8mw1A/TnH0BInG5WXNHHXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=090Te8lavCkY1z6HIwpTSs4fLtLBl6hfOiiu1Im0tbc=;
 b=gNjm268PgVZcViTQtMBxl65Q1FTJvT7+1LF7zhLtM27kbjOW0+NwV68PzqmY7/Yrmw4FKKjGRAxKQHWk69SPpnLrqnZiQsqFoojuF+e5+uPyDYBzkZDdzgqYF2JcdURsKbP/YZDSFmV3OlNSbLhGcI9wg6G6hisLSHXxR7ZMnuZbwUm3EDu+fnkCnG6QBF6AT8VPzaS0A5ITqXf3/zgMKE+CMbFROKxcyfC6a1aly+GxGd41Pp5duhsdIBDB1dZHyXIch5NXXHFmADz0v4VPNY7Ltv7GcGrjf3SkkYwMnmL2152OMAORBzBKl1/+uKylNqjn8q0kVFaUJa5Yl0+InA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=090Te8lavCkY1z6HIwpTSs4fLtLBl6hfOiiu1Im0tbc=;
 b=WBgUvbfdAq03ayXmAqOM6OROGZroTIVbIdzfBKBmo4qY0I3EXRPE1kssmcQvgbhCWeM/9x3L9g/m4ewSw3Ag2AlwHnY8wW7K2BnIWX/nM5MTi/a0tsW57K4X3nKjz/+lRQZs6ZzM0SBvzTfmtEFpUcB2nHSo2CCfMvPYRiudgzQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8302.namprd12.prod.outlook.com (2603:10b6:208:40f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 18:47:08 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 18:47:08 +0000
Message-ID: <9991df11-fe7c-41e1-9890-f0c38adc8137@amd.com>
Date: Thu, 18 Sep 2025 13:47:06 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: SVM: Use cached value as restore value of
 TSC_AUX for SEV-ES guest
To: Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <05a018a6997407080b3b7921ba692aa69a720f07.1758166596.git.houwenlong.hwl@antgroup.com>
 <9da5eb48ccf403e1173484195d3d7d96978125b7.1758166596.git.houwenlong.hwl@antgroup.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <9da5eb48ccf403e1173484195d3d7d96978125b7.1758166596.git.houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0068.namprd04.prod.outlook.com
 (2603:10b6:806:121::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8302:EE_
X-MS-Office365-Filtering-Correlation-Id: ea915d94-8e37-493a-f538-08ddf6e3c517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUhPNmY2eHRMblB5MVhkUXl4dGJnMmUrcEhhSW1RczA0VlVDbkZ4ZEdNQXFx?=
 =?utf-8?B?K0ZBMHhQTDk4Z2JxYjluYkEwZVYxSlJEa0lucWhYV1J2WDdGRVdxaEFXRFBj?=
 =?utf-8?B?SkZjMnZzN2plQ1hGRzZuTTRHR05qT2haQ1gzaEpMYk1TODFRSUQyRm85T0lq?=
 =?utf-8?B?WWlPWVRZaEZXb1REbnh3WEpPK05SOHZIUEVtcWNSZDAxeDMyb2VlNmY4WmZs?=
 =?utf-8?B?UHhRQWFzcmdJTHVOODlhWmN5Y2ZCZ3E5dGxicktNcFd5ZFRaa2cyT3l1aXJV?=
 =?utf-8?B?dE14cGcvWHlPWUdwU1JJK1lTRVlqOXRacWZESlpmU3hiWGNXWEV2T0JrZU85?=
 =?utf-8?B?RjlQUzM5anVkSnN2YlNiL094L21mQmtYUU9jcWliSzNYdDVodWFMTlJkUmVC?=
 =?utf-8?B?dVVPYkRIQ3o4RzdKMWtpTWJTaW1CUFh5dWZRdmpJUlRzblRuK29yNzM2OTdS?=
 =?utf-8?B?WmpRNXVDSllQdFpCRGxJSERCVkU1eVlDcmxvdU1FNmFzcFU0YllGUXFMMUxD?=
 =?utf-8?B?TlJwVUhid0lPYWxXUG1xb1F3NGZidlM2MkoxYnpTYjIzdUxXcmd1Mk0yQnhN?=
 =?utf-8?B?bTVGV0cwQW90ZzFNUzVmVWxJNTNITG9QNkNlNitFN0lNRGZ2YTMyUzJ5R1Jj?=
 =?utf-8?B?MU5GTTE5dFZzRmVZOVI4YW0wQUtjUWVsdVB0NC95cnpXTnBBOWQ2aUx2S3c4?=
 =?utf-8?B?TlJXYUlzL1BQSmwrVWUyWDJ6YWhvb2N0dmtKZk9uczZ0TzBBeTFCaUc5WlFm?=
 =?utf-8?B?YUFOVnhTV2VvelRlYkwzR2sxSDNHbllRbmRmbEEzTCtCMFBUMlhCVElCamw0?=
 =?utf-8?B?WThqZW9CZHl1VHhYL3hPOGVYQjBpZ29qK3RpL2x1MnRZOXh2M2MwNExWQTE4?=
 =?utf-8?B?VjlLcll4MVVBbGd0d01pT0hkNHlWMlQ5RjRmOXRRTVVKdkw2eWZWVElMTmVY?=
 =?utf-8?B?NVlOK3VOdC9zNnpocFdUd2NBWEJTcFNORUozMkpqZkZINE5pQTBFWVMvdkh5?=
 =?utf-8?B?MXJTNGR2L2hGZGZnMWVpY3Z4WnRndDhkcFNhYWszL3BUK2VyNmlJWGtKTVZ3?=
 =?utf-8?B?ZUxreDhmYldPSjJBbFVHbGNFNzJGSDExSy9vZENWMmZYSTlNRHY4ZlB6OUdW?=
 =?utf-8?B?cm94bzF0U0FXTmFoR2xCZVV1cG1BZkFCd3FJekZhYXI3UHVRV1F3WTFTbWJs?=
 =?utf-8?B?MWEwbGpoVEhRMFN6Zytzbk0zaHEwQ0s0aXVhek94SHRZZlRJTWlTVmw1ZU0w?=
 =?utf-8?B?WmwrcW9sckJTYlpVVXlsNjV2c2ttQ2lyOExBOEVXZ1l0Y0RvSkJNRXhVM0xt?=
 =?utf-8?B?Mit5Wk5FRjdYK2Fna2VWZGlqVFgwc2F2V09jbUgwMDJDK0sxMHc0RnZ0ZkRB?=
 =?utf-8?B?STkzQ2pRY2xJUFdNVW5HbC83YXBZWmt6bGxEMHBiMXZoZHhWSzkwNTdzSXgv?=
 =?utf-8?B?bVMvc3ZtblAwSU92Rk8xMVk4c2N0UndjejZnS2F1UmJTbkY2cDlkZ0FVc2Ny?=
 =?utf-8?B?bW45UGQ4NW0zYVZuRkxVck9rb2pTMHdLZWtWMndRc2E0WFM1ejhtVlhtS3g3?=
 =?utf-8?B?c1Nrcm93eWdWRUVqUHlMK3pGM3hCRGxvdlhLaDZTd2R0djNsdStkaDFTSEN1?=
 =?utf-8?B?YWZjeGthN3BxZU9kRUNUNWNHaEJWZTcwcndYb3J0U2UrK25GY1BIcU5aUGtt?=
 =?utf-8?B?cWRRL2ZnMlpnbGQ4NnVZcGhyOS9IbWcrWTlSWG5ZV0VrYjV6SjBZaENRVHVq?=
 =?utf-8?B?dk5VQm1SY2U5RTJTaWxhM3pTWThUNVhzZS96d1dqbS9XRzIxbUY3aEIxNmJm?=
 =?utf-8?B?cS9DUEFEWDQwV1RtcDRoeGVpRndsbzFXM01hVk1xbE1wcHNUR2pVVGhhNUdh?=
 =?utf-8?B?MVl1Y2pIK0kwRlBhMmpYaTcwMDd0Yy9XOXI4YVc3V0lJTU1zVzFYSExhZ20v?=
 =?utf-8?Q?wplxQqGSjMI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vk1ORDZkc0grRzBVZjhsTHZOdjVHN25nN2trSDNObkdIdkh0Qy95L1Zybm80?=
 =?utf-8?B?NnJSSDlINXp6UzdFNDJ2Y1F3N05IMGs1cUJld2NWOE5BU1h1Z1NQRWhxWWl6?=
 =?utf-8?B?T1U2UDZLMXVNVk1qK0dHZUpNV2piTG9SRzAwZjgyNWhZdDc5TjNOdkIwNFhu?=
 =?utf-8?B?Mlpsb2pESG15Sm1PTmw3OGliTWFSNVltN1BMVUdZZGt2TnFZOFBvRFQyTGpW?=
 =?utf-8?B?eTJURHRaT1RXa0k2eXc4ZWF3L2UwMSt5TWdFUHRoZ3hqbENXRVBsV3VHZjdS?=
 =?utf-8?B?NnBsMmlweExaZXpOK2xvSHNFRzNVNVBpL25pMGs2K1RSamtRN1NuaXNMQUd6?=
 =?utf-8?B?STEwNmRtdmw0Uk9mbFNUWkRSSURNL2JaTnhUOTh5MVY2Z2s0RDhHanFqeWls?=
 =?utf-8?B?VzQ4VkdnZ3pnTU14SGwxV2dNS2VpTWFqMFRNcVo2TWkrMFkwVmxmTzh2RjNS?=
 =?utf-8?B?bkRFL2NVcCtFdjRGVWJDM2k5RHd1aXMzUURhbURCcU1ZRFpkNjhCRENkakFW?=
 =?utf-8?B?aFdpeEROTExMaXNoNEJoSDhtTkNaWWFKRUFha1h6S3Z2b1VIZ1U2QWlYbGpX?=
 =?utf-8?B?Y0RPeW9BWnJZbzd3Rkl3azRCNTNiVzdXUWNsZ0FuYXRjOFQvRXI5bVc3b2Y5?=
 =?utf-8?B?MHhDS05IbzhndmduVFpFWWxGSTlMUks0SlBFSDJlMER3SHcxeVY1MXh5b2hh?=
 =?utf-8?B?MmNudjFuUWNDR3I0SkhxNm5GZFp4MjdPeHJ5cnhJLzFrZGNGSVJjWDJ0WCs4?=
 =?utf-8?B?d3U1WlhNeGZJSkxqeGIvcG5tTXFxa0c3aXdESFl0dzl2SldzWSs2VC9PcGwz?=
 =?utf-8?B?SHhhU3lXZ1dQaWx3OVlqOUE2SzlEVEpYRGk1dFprRGxnS3V4RHF4aXF0eHlw?=
 =?utf-8?B?dXh3N0hVLzBZOURHWnZ0MkpmT2crQ3JCRGhxQUtQa3lMVjlLNFFNSlk4TVJ2?=
 =?utf-8?B?S2tOT2ljbUprcW0renlyZFFGSWM1ZktlWUZiV0QyVEptNG9vc1JZVk1KK08y?=
 =?utf-8?B?V2p3eEZiTm9COVgwMkJaSFRycDhQNlhXRGhXdXB6OWJvOXpVOG1IazdZd25B?=
 =?utf-8?B?dzdDZldpa0d3bXhVMjJJSkR6cEE3VGRzTmhZa1BBbE1Dc2NUVUg2YWVLU0dC?=
 =?utf-8?B?WGw2OEQxRDBnZE1QcTI1L3lueGZUTG1yM1VPMWo1d3p2RURDcjBydytaVlRC?=
 =?utf-8?B?UHZDZklUZzE4SG1lVUk3TklrUU9YUFJML1JSeWFPVWxiRTN2R2c5UHZUZUJQ?=
 =?utf-8?B?S0wvZTIwZnVaODdyd1hvcEZvRGhJZmptWmYrK3VuQVJ6Rk0yNyttTzJ0RHZE?=
 =?utf-8?B?bDlPb3ZKcmJLSTBiK3ozT3BKaldnR1R6Q2xCcTVHYW9tL0FnalN2bDU1NUxk?=
 =?utf-8?B?bmVzUC9tSW9qaHV4amFCM0hYWEE2eFMrOTBaakpnZ0Q3UTBkZCtyTHFOS3k0?=
 =?utf-8?B?Qy9ENk5vOG5PVmw3S0kwcmxiQ1hRdmk2enJFeDl5cDJ4d0dRTVY5bWNvWW5X?=
 =?utf-8?B?UWo4T3J5Q0lybmxtWFFaUmxvb2ZyRFpzYVM2VkJyUk9OdzlReE9UWFhNVzNY?=
 =?utf-8?B?cDg0WDIwOHBGeEhOSzY4RzBrQ3dwemhOemZ0Q1NCQTN5anVMdnZiM0c2T2hP?=
 =?utf-8?B?UHZBaXZ6NjRnWkxwZm9JZzBxSEQ1bmIzbTI0dGRySk01T3RFcEdkMUxWaWFv?=
 =?utf-8?B?K2pJOFQxTnRyUllua1lNQXZKMDgxTWUrc2NGd1FKZFdqdEpSTUpoNDFUYXNr?=
 =?utf-8?B?b3RSVCszYk9JQXJLdkpZWEpoRXRSMWdZZjJUcHdMWll6T2VRVGJiN0RCUjFm?=
 =?utf-8?B?MVloOHBOWkRtSzJBRDlDRFpUbWVneHN5bG8wM1o1Z3hJNVAzY25pWXRSZVkr?=
 =?utf-8?B?N2dOYVgyeEFQZnJmQVJvNm9VZ29GekhQbVlCUEhjOEpEckxHWE5SaWpiaWZD?=
 =?utf-8?B?OStjM1ErNXkrQWFRVHFNTTNqRTlWVXUyWHdmazFscElHam1jZy90RHNMWUtB?=
 =?utf-8?B?dlljeTY4SHBCbEZFb1B3cjdnN0M5bnlPOXNtMXYxR29tRExINjdISnJBMklw?=
 =?utf-8?B?U0RYRzkzenBBWXBRUmVRQTJ3YjkzRFhNcFdydDR6bmR1QUpOemxNb1o4cjd6?=
 =?utf-8?Q?ceCyFGt8xLGnvmrklhWZ2AiSq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea915d94-8e37-493a-f538-08ddf6e3c517
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 18:47:08.3028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYC3ZVOjsXF24RWvKT9Gc20Hb+TMN/PVvLQDU8aLZ7BJuyG6T/i0DnZd1+mwXAbwR2zsLBqbQUJTtIAIwvp/MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8302

On 9/17/25 22:38, Hou Wenlong wrote:
> The commit 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support
> for virtualized TSC_AUX") assumes that TSC_AUX is not changed by Linux
> post-boot, so it always restores the initial host value on #VMEXIT.
> However, this is not true in KVM, as it can be modified by user return
> MSR support for normal guests. If an SEV-ES guest always restores the
> initial host value on #VMEXIT, this may result in the cached value in
> user return MSR being different from the hardware value if the previous
> vCPU was a non-SEV-ES guest that had called kvm_set_user_return_msr().
> Consequently, this may pose a problem when switching back to that vCPU,
> as kvm_set_user_return_msr() would not update the hardware value because
> the cached value matches the target value. Unlike the TDX case, the
> SEV-ES guest has the ability to set the restore value in the host save
> area, and the cached value in the user return MSR is always the current
> hardware value. Therefore, the cached value could be used directly
> without RDMSR in svm_prepare_switch_to_guest(), making this change
> minimal.

I'm not sure I follow. If Linux never changes the value of TSC_AUX once it
has set it, then how can it ever be different? Have you seen this issue?

Thanks,
Tom

> 
> Fixes: 916e3e5f26ab ("KVM: SVM: Do not use user return MSR support for virtualized TSC_AUX")
> Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/svm/svm.c | 33 ++++++++++++++-------------------
>  1 file changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 1650de78648a..1be9c65ee23b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -577,18 +577,6 @@ static int svm_enable_virtualization_cpu(void)
>  
>  	amd_pmu_enable_virt();
>  
> -	/*
> -	 * If TSC_AUX virtualization is supported, TSC_AUX becomes a swap type
> -	 * "B" field (see sev_es_prepare_switch_to_guest()) for SEV-ES guests.
> -	 * Since Linux does not change the value of TSC_AUX once set, prime the
> -	 * TSC_AUX field now to avoid a RDMSR on every vCPU run.
> -	 */
> -	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
> -		u32 __maybe_unused msr_hi;
> -
> -		rdmsr(MSR_TSC_AUX, sev_es_host_save_area(sd)->tsc_aux, msr_hi);
> -	}
> -
>  	return 0;
>  }
>  
> @@ -1408,12 +1396,19 @@ static void svm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
>  	/*
>  	 * TSC_AUX is always virtualized for SEV-ES guests when the feature is
>  	 * available. The user return MSR support is not required in this case
> -	 * because TSC_AUX is restored on #VMEXIT from the host save area
> -	 * (which has been initialized in svm_enable_virtualization_cpu()).
> +	 * because TSC_AUX is restored on #VMEXIT from the host save area.
> +	 * However, user return MSR could change the value of TSC_AUX in the
> +	 * kernel. Therefore, to maintain the logic of user return MSR, set the
> +	 * restore value to the cached value of user return MSR, which should
> +	 * always reflect the current hardware value.
>  	 */
> -	if (likely(tsc_aux_uret_slot >= 0) &&
> -	    (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm)))
> -		kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
> +	if (likely(tsc_aux_uret_slot >= 0)) {
> +		if (!boot_cpu_has(X86_FEATURE_V_TSC_AUX) || !sev_es_guest(vcpu->kvm))
> +			kvm_set_user_return_msr(tsc_aux_uret_slot, svm->tsc_aux, -1ull);
> +		else
> +			sev_es_host_save_area(sd)->tsc_aux =
> +				(u32)kvm_get_user_return_msr_cache(tsc_aux_uret_slot);
> +	}
>  
>  	if (cpu_feature_enabled(X86_FEATURE_SRSO_BP_SPEC_REDUCE) &&
>  	    !sd->bp_spec_reduce_set) {
> @@ -3004,8 +2999,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		 * TSC_AUX is always virtualized for SEV-ES guests when the
>  		 * feature is available. The user return MSR support is not
>  		 * required in this case because TSC_AUX is restored on #VMEXIT
> -		 * from the host save area (which has been initialized in
> -		 * svm_enable_virtualization_cpu()).
> +		 * from the host save area (which has been set in
> +		 * svm_prepare_switch_to_guest()).
>  		 */
>  		if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) && sev_es_guest(vcpu->kvm))
>  			break;


