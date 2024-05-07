Return-Path: <kvm+bounces-16787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8CFA8BDA0B
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B0F61F2364A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 04:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E9C4F1E4;
	Tue,  7 May 2024 04:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="auPnwPXk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4FAA93C;
	Tue,  7 May 2024 04:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715054900; cv=fail; b=XE6gtQekZ46ylb9+b2eMXN7rvSlv7foLHatYhAYEKlqQwYNx2PwJ+624482oigXiEc9HXa1wmncNybr65YEoxak08iJJ/xtoj7Ws1PcsKZNoCYPl3hr3chXEAXNhr1KM+Rw2U47zbszsoAE3nL07uYu7sAwNHy6/N3j/KkvoOXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715054900; c=relaxed/simple;
	bh=p5FZuYFxKWoeaeD5susLkn1hWc0wttuCjXOC7IIWGKs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HIVaqgPxqNYXMooNzBekz5VyaONTGHVVYBgAMerJmEGWcs2bcWoAW+FVtLNrEufEZ6IaVy4emx9tBsrYX+oa/29yseiUpkaNRccz39fu8qmbXWWx37kLC1Kqqu/YpJ37DqfOJzRqpgmUiPs1sbBdOXdiVrP7bL7wG+AjUSBzfdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=auPnwPXk; arc=fail smtp.client-ip=40.107.220.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=daS6ebGNHt5FuDbwYplzSZNqIfylygktYf0tPzvHqOAwLISoRgj5d35LwvvcdYhcUnFWO1QuD2+vIg3AYRKLiADieS/2vMydNvRr1y3DqQgrriL35epQaDEErLHmvCrKUBkB/VfQGC0QrvAKBd+cK7tSqfu+nnVqZJTw+BGRa4gp5ttDA4zRSFhTodQx5OMlvGohAkyzcW9NurPurrV6BKr2CPGAgY5aT3/6zYDfL43mJnFk8pnsLVucJ/NAn2/ZjxjN8/pR06RXk8Io7iDFE3Ct/YRMsCX+DE3t0kZ7OY2s4lqYVUQyivZdUkKo+dAbWQIIv7yPs4XB6Bmwb5zTfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dwrE+dbEL+ER/64raeKFoPRJf9APb+esD5gPxCKTr7Q=;
 b=fzjPx0S7ZPXs9U4DbHmrsZF69WVR1vjdgJQezJ8iWmNK0hkm2DHSxCNB02tuHFOAdhHxijLeJkInwCIC4qM2F1mCEQjfoyzB6Yf3wka8Fe8psomk8aK6pAzKM5U28PttUKf9J+rg5M0JO/aKJLENLBRFPgTdyr2wI647KNqv/YVmnp6mnv7gmxQcgNEDRROeiJXnJ3i9rAeDCnzPwDRBmadLA9hjlWN8y50TmDQtcb76xdbSfE7tiWH216n5swHnN4+7LjmV7mvwvn6BsmBdym1H/IH4ATTQakSlDya9U9QncsUaJPRarHXbafWKt3evzpQUiwzfWEolZgcwX2yCog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dwrE+dbEL+ER/64raeKFoPRJf9APb+esD5gPxCKTr7Q=;
 b=auPnwPXkImk9i6VeIvf3k7Olw36FKGubHBBg2Ij6Ek43Uo8+EyfqVR+hG5g2QEXdvZqfdvaZjjS9qBV3TiJzsrHJ0F00nMxvgbobDndnO/YHpmMJVH+0l8pgxcbn6e8kWXwFlQ4NgIls/EM5Nx0kbsa/ok8Ewlr13q4PvhFXEuY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by DM4PR12MB6496.namprd12.prod.outlook.com (2603:10b6:8:bd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 04:08:17 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%5]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 04:08:17 +0000
Message-ID: <0b234729-c971-ebe3-e3f7-22413e1a5b12@amd.com>
Date: Tue, 7 May 2024 09:37:52 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] x86/split_lock: Move Split and Bus lock code to a
 dedicated file
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240429060643.211-1-ravi.bangoria@amd.com>
 <20240429060643.211-2-ravi.bangoria@amd.com>
 <20240506125847.GTZjjUB6D_cClwghMc@fat_crate.local>
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <20240506125847.GTZjjUB6D_cClwghMc@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|DM4PR12MB6496:EE_
X-MS-Office365-Filtering-Correlation-Id: f2b3467c-d024-4ee0-48b8-08dc6e4b52a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qm1pU3R6S1lLeFc0a3RIUDdIc2NOZStCZDZSSDZPdlhhK1BjT0lHeHlPMmFz?=
 =?utf-8?B?ZUJnU1ozRVpURG5SU3IxNVc0TVk2UmoxdHRwbmlMTVZMbFFmT0dNU1o5OHBJ?=
 =?utf-8?B?SS8vOVFhWnRaNCs2K3IwUG9PdkJNNEYwT0JaVjNCTXUxNXVzV09ucWtmbjNn?=
 =?utf-8?B?Mm0xdWovTXhuVnI3a2laWlJFS0dVSitjUnJ0ZnZnaXFkbko0Nk1FZ3g4ZE45?=
 =?utf-8?B?U2duTUlWZWRmRWE4QkRjQ3NPTnR5a2U3TnZ4UWh6VjJoM0ordUNKSkRUN0gr?=
 =?utf-8?B?V29za0d1cTA3Z1kyUWpGcENCR0ZKNnhRQmM2SnpXaUlueHBwZUZZWHdGSXp4?=
 =?utf-8?B?aFR6dnRqazR3QUJ6OG1wcXZYNkprU3I1eDlXSGZyYXc0U2RzKy83Z3IyVEVz?=
 =?utf-8?B?Q1FTL2tCK3A3V2liQzI2R1ZBWTFwNUt0Z0M4NitwczdwZm1lV3BQNkdhVlJK?=
 =?utf-8?B?UWFqek1zTm5mWnRQelBpN2JheWR2WXFpT0dWYTkvMTFVSXR1a1U0NkFKM2Qz?=
 =?utf-8?B?WFF0RytIUDF4QlQ4Nk1tNjJJeVE2cE5iMFpZb25DcnpzTU14RWc4emxQcTVi?=
 =?utf-8?B?TjlBb0lqUmJra2hpOGcxaCsyaCs3QWwyaHVBakR0QkxOQXprSlVqK1VHT3pE?=
 =?utf-8?B?YmNtTjVFSTNxWDk0ZzNwRVB6emphWjl5QWhyTFZDWDY5d3pKRXpRVGVnYnFn?=
 =?utf-8?B?UjZGNE1yZHd2dTc3am55a3Z5RWhjMlg0THVHbHREWWxXdWNkMUtPL0tsMkNl?=
 =?utf-8?B?RVlpOXZWT3N1K2FtWEEybHQ2ck9VOTVERloxYVJpei9UNGgveFYyak4rMzZQ?=
 =?utf-8?B?WmhPdVE3QjBueUY2WkNXMkFOUmtSdEM0SjhaM1J6VURhenVVOXI2Mi84QlVF?=
 =?utf-8?B?d2JiMHRSd0Q3QmtxWklkVEpmQm5ENUNyeDZWTGdSY3lvVS8wOWM0Y0ZYK2Q2?=
 =?utf-8?B?QmhBa3Q3aHpPYzQ4aHZvcHJaM3NvTVhkbnY5eVluU0dNcnJIbk5LV2lpL3FJ?=
 =?utf-8?B?N1EwTU1MUXNzditCWVFXZHYvRTkrQjBhcENWRmRuekhsMVNpa2RuSWw5RUpN?=
 =?utf-8?B?dzJaMytKQTFLVGg2aG1BdGU2cWdUb25QQ2FLMzJJV24yZUpibGovaTJNSTdZ?=
 =?utf-8?B?VUw2N2M3b1UyU0hITElxOXJaZURkSVVlU3dxU1laYTB2QkJHSlpQZHA0VTdk?=
 =?utf-8?B?SkFjQTd6elIzK01QTG96QUpuTlNOQndWRVk1emg4b0xiNUdtdHd5K1JrclJO?=
 =?utf-8?B?dStac2p3L2R5OTgwNUowNldIQlI4R2RYL2h5QkQ2RUR6YW14bUdTaFJvdnFo?=
 =?utf-8?B?M0JxZVV3ODF1cnlDTnYwN3FUZkpJa1RqcmtmUkYyTEtuYUhldFg1N1E3MEVa?=
 =?utf-8?B?dzUzWXVUWWwyeFJKa0Z3QXY0Y1B6a0RZSWR1Y2U5bEV0cWk1Rkcycnk3bjhQ?=
 =?utf-8?B?SnQwU2RYelhSek5kU2VDbzRaT0tLVUJ1OG0yWnZSc0E1MEc4RDNXUzRDdDVU?=
 =?utf-8?B?Y1pkNUZmWGNMOHV1RlBQeXg3UFdiNVJDMWl3VDRxVWpWYktGaUMwMnJ4ZFFm?=
 =?utf-8?B?YUxCZEpkZ3ZTOWV0ZDV0SmtNQys5UVI4R081eEY0dEhHTExhMGJhd2ZTSlh5?=
 =?utf-8?B?NW9tanF2UlVCRGFWZEdRa3lMOEtjSTVZa09sZVd4QVdFa0dQUzNUNlcyR0hn?=
 =?utf-8?B?VXQvZmJvZVVteDdHU1pkejN3dFJIL2xoSHdlTnJHZGg3MUhrelNWYldnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RTVGdjR1R0hiV1VnUGY4c3ZtRDRwRVo1R0c5Q2pzWHJvaGdIeUdoVTlVb1Bu?=
 =?utf-8?B?N1V1b2ViUnE0dlRmQkd6dTVYWVNBcXBQcW9mbXRpUWUvYWw5S3lSWWVqQWtS?=
 =?utf-8?B?VER4ZEJxbXNiSmRGdlYzWEVMaWlZaFZ6QVZOcXlRRzJkMVp3UytIK1UyTVpW?=
 =?utf-8?B?WjF5OEYxQjFLQjlub0pSWjNlM01EUjlDVHhNS0xwNUJYbnc4YkVrL3lzbE90?=
 =?utf-8?B?Szk5VXQwakt2OXI5Y2pJMXNmOVhPa2lzVThBZk9QbFdqNWs5YVRkbEZCRzRi?=
 =?utf-8?B?RGJNQkZEZTBPSVZoN054NlJKMnc1NndaN0dDVzVITUNEbU5JbU9YTHdiMTNE?=
 =?utf-8?B?akFXb2RzWlhnUGYyQ0ZhYUoyZWhsVVN1d1VvMzdva3dtU29TdE5mVXhrc1JJ?=
 =?utf-8?B?d2p2TWUwYWJ4TnNOT1pjTW9oZUZCN1grZVFEbVlEdFgrSkozYUg1WGc2L0g5?=
 =?utf-8?B?UmNoOE5Xd2RaelFRSXQwaDA4NzBPMWNmY1d3WTVHQ3VBVTV5MWRPYkRPODhh?=
 =?utf-8?B?bFJPR3BCNWxqMVdqRXRnemthb1ZkSGt4VW1kYUc1bDRDbHVUNnFWR0NPWnVr?=
 =?utf-8?B?VE1RRk93SGJRRVlqUzYwa3Q3MFRaZEdkSHVCbDJlSk1GVUxuNHhwbnFqend6?=
 =?utf-8?B?d0NRbU1jSVRPdnRuUG5BWWM5WGhCUWVOWnEwS0l3MVlETGVFbTRjamdoZlNF?=
 =?utf-8?B?UkZyQXE1SWJ3eEhoeVV0K0VqVm1sTVlJb0VLZ2FrcnN0UGxwdGx2QmVxOTBh?=
 =?utf-8?B?Ti84dWxnWUJScERiMy9YUXM0ankxSW1PWnZsY0p2MVIwdUs1T2ZiRzRWZEs3?=
 =?utf-8?B?TDNuY2NNczNIWmU4ZHhkQWl3L0h0S3NJYjRZbnk0ZXVMczhtQXlNdUoyZ09R?=
 =?utf-8?B?eUR6a2dFdnloaS9rYmNHRVpscjZwY0ozUE12Y2UxZi92VHBMS3FoWlFCSHEx?=
 =?utf-8?B?aVZFZU9KZzFhaXFjOTZ4SnMrTnFmektOZFBleDN1UWFsT2xkeUxCZzdsOUFS?=
 =?utf-8?B?c0QzU2ZMYjEyZTl2K24xWUN0YUxkUG5zdFZ2VUR6WGdjdWx1a2c0N0t2bG5S?=
 =?utf-8?B?cy9sVFg2RTRvclN6UTdZUVBiaURhU2RqV3VyOHI0eWVTY0ZUQnhTS21mUXBW?=
 =?utf-8?B?b1U2MjN3V00xdFhYQXVEVTlkb3Q3TEw3WEs2OFpMZWljamVqTlk3NytSZ2FV?=
 =?utf-8?B?eUlxTTFMcTJqZTJFcklKNVY0bXQ5dEU0UDJaZnVzanJ3VThpYTFJYkcxTFVw?=
 =?utf-8?B?VHJVdEFITVRZWUhkcWpZOG92K2liYXNZTkN1UmdqdHI4UGpEVEszci82ZUxU?=
 =?utf-8?B?S1I2TlZlK0IwaHRGZFVBblBSRzdjblFab2hON2pqOWtzeTZ4Z25aU1NNZThY?=
 =?utf-8?B?WXZnVUJOTHJkd1A3dUQyRjVjakY1Sk4wUDFWbHYycU9kS3YvbWRISWtrV0Fh?=
 =?utf-8?B?ZDBIaXpKVDEyNGV6ZDg4VjZRMkNBS0ovYm5sUmhXRzY4TnVVUVdXVVJXaEFC?=
 =?utf-8?B?alBvN1ZTUTNXWDBSRzNibklTNitGYVFUaTJDa1pGNklKWFNtQTFhblpqYk1u?=
 =?utf-8?B?R2R4R3FnWjVPV2sxQzFMNHJaVzJJdnQrUUtBMm9VaUFtaEliQjR4M0xMVy9m?=
 =?utf-8?B?RWd6Qi94NC9meTNXTnhaL0s0S3crVExFQVVJOGh5dnJCQkRjNlFRZnRYTzBj?=
 =?utf-8?B?Q1MyUUV0WVdpaHNyM1g2WDJITFR2YXgvNzBHU2hFYVRtT1EzVHlHMHI5L205?=
 =?utf-8?B?UTVKZ2t3L3FmbW9NM1dqcTd2RitUaU9abFp4NXZ6enA0ODlIMU51L1pmbjZk?=
 =?utf-8?B?ODdUUlg4R2VFTlBWcVJsdDdWbTdlVHBlenBNRHB3Mk5JYktTaEd3MjA4NFJ3?=
 =?utf-8?B?TnNneXV0UEgrRnZJWFNlbERyS2ViY0VVSXFhQkZHa1EwYUJTbXd6ZkZacGxu?=
 =?utf-8?B?MkNsbEVxRHVJTGxCL3VLczVQWXdOb1Zsa3UxdVE1dzhHRERtb2xCQlIzcmJZ?=
 =?utf-8?B?MGE2K2prZzFGbHhSUGJ3N1h4Qy9xOGt3b1RIeTVrbjF3c1h3Njd3WDVOWjR5?=
 =?utf-8?B?YjB5c1FsbWpqQkFmb2ZqWmRWNXFsc2ZEMkNTaHNpN0NDcFptSFlGb0RVbG9a?=
 =?utf-8?Q?nPzwcwYRKxKERbPbD4gNPKNE3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b3467c-d024-4ee0-48b8-08dc6e4b52a7
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 04:08:16.9065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+JmAbjUOEyi4qKtm/fctKR1c/aPUueXvCOfzpDU7jHLaWX0L9nInkfbFHi45enWDresmrHwE4smJtwL8Sf6ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6496

>> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
>> index eb4dbcdf41f1..86a10472ad1d 100644
>> --- a/arch/x86/kernel/cpu/Makefile
>> +++ b/arch/x86/kernel/cpu/Makefile
>> @@ -27,6 +27,7 @@ obj-y			+= aperfmperf.o
>>  obj-y			+= cpuid-deps.o
>>  obj-y			+= umwait.o
>>  obj-y 			+= capflags.o powerflags.o
>> +obj-y 			+= split-bus-lock.o
> 
> Too fine-grained a name and those "-" should be "_".
> 
> Perhaps bus_lock.c only...

Sure, will rename it to bus_lock.c

Thanks,
Ravi

