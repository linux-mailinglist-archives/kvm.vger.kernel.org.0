Return-Path: <kvm+bounces-25650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7A4967E68
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 06:17:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA268282190
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 04:17:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FEC1494B3;
	Mon,  2 Sep 2024 04:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="L61+LWbh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A244625
	for <kvm@vger.kernel.org>; Mon,  2 Sep 2024 04:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725250629; cv=fail; b=Ytg+BSp+cdc0teteWG2tHvsNn6BZo78NFe2evVM4fncokgIAl7y9bg5npjqZApyynDXLMsX5PyGX4otxo3oTn7u+UXH4SkEmYTfOxYI7m3nn73iWtlc0QqNDn7AjKD0INSuq6iNUhB2GiZtJJ3WWBBCO/mICo0k37eTKUjMjZac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725250629; c=relaxed/simple;
	bh=QYrvxd6Y7ltQHyqVIXTbKzzZqSQgmFWMhh8TIyJWuCA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JtzxXwqC61NA0G/ObcHJDun57WoFZQsIqsqxTRvBP1Jcc33iCPzl1MrRZpUid1dV8f+KloqFNqMU9AHyCxiLDpulT4nwJvlFyij9SRI67o+Wj39V2ip5HGaBJ5MlvLXlGBFZ4K1gKapIaBQlzG9ih5bcyrl+EzD2OGeOp/pJ2VM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=L61+LWbh; arc=fail smtp.client-ip=40.107.92.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ArbQ9EqPWeya6GBzko2+D6tDVGJLrGNeyFTxGHbWjxJ8JiOhPMGCel/9m1zZUbzJcWWQt29kMCpQO4/DquVdJzMJ5XPP3UKniOsUte9AYTFVel+lxlFGOC04zabka0jP7AeJmOQR8i9x1TsFdHFuSK7uHkNwURbP8dD10Q3dqR/O9SM5icYOJdVd6eq5wLse4zYEzA+Tbea1NsURSn8csWOWooWZfKIE6krEhQlmClnNrrD14vkBbS9sjz/5jkqhTTjA4BJWA4cGvWxN0h104bzod6x3qcAbe9qCis/eqy6IOwrxEmVKLmek5+fA+tl7pDZeyQMLsZJh8vXrl75X1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqFxM4RehLAi66fvw3NRt+c4ixqCgmJ7tpRH3ko/XeE=;
 b=FAn45oGg7f611M50tM0Uz0HBJ26+NIOwHnIuILWJW3Vrj0erIkdDbyQkd9gFYPMdMwapyZs/Z0Y9U4CS2lVsrQ4h/G/ondV/WZaLmYUjxio205SrKsXdoinfpaaPcmYRxtbsnDpttBZ/J364Vu5Kt+CALMQ7P2q8yb5WvipQ102SBtZh/ID5UklqUyPVuZFDLhgholY51RQ1W+1fnts94/vOxFoLtQPG7O5DALpyTbsYPhbpUEkPo2CDMOOW/sI5+DS9d1hAOPQPoFJ3g6egJZYX4lo3VY+W7jDs8zBQpKiztwSbmWXHUiIsoOrpD9wn/D9dYBhYSpOwry6yU+V+fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iqFxM4RehLAi66fvw3NRt+c4ixqCgmJ7tpRH3ko/XeE=;
 b=L61+LWbhGap94GECx78XrMpthpzAlSuc9o/3H5PHRK42xvBj5tmX7sZRskpBHzyVsOUveCPpe3SjyyrHyULNtqYsIRv/EcJlCkOzEDyv0tN1zg5//GfwGrEOJszsWeHplS9q+MHrg8YyeTynvvRk/XT1O64SQcE3ncQyC7BVF1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6317.namprd12.prod.outlook.com (2603:10b6:208:3c2::12)
 by MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Mon, 2 Sep
 2024 04:17:05 +0000
Received: from MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4]) by MN0PR12MB6317.namprd12.prod.outlook.com
 ([fe80::6946:6aa5:d057:ff4%5]) with mapi id 15.20.7918.020; Mon, 2 Sep 2024
 04:17:04 +0000
Message-ID: <1bea8191-b0f2-9b22-7e7b-a24d640e47a2@amd.com>
Date: Mon, 2 Sep 2024 09:46:57 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [RFC PATCH 1/5] x86/cpufeatures: Add SNP Secure TSC
To: Borislav Petkov <bp@alien8.de>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 thomas.lendacky@amd.com, santosh.shukla@amd.com, ketanch@iitk.ac.in
References: <20240829053748.8283-1-nikunj@amd.com>
 <20240829053748.8283-2-nikunj@amd.com>
 <20240829132201.GBZtB1-ZHQ8wW9-5fi@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240829132201.GBZtB1-ZHQ8wW9-5fi@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0107.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::22) To MN0PR12MB6317.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6317:EE_|MN2PR12MB4335:EE_
X-MS-Office365-Filtering-Correlation-Id: 4880adb6-3f6c-4274-fce3-08dccb0619f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWlGNk5kVmgxWFZBeWszMzhxbDltRHJLdnNONE5GM3VVcFNacXdVa3NhaHJY?=
 =?utf-8?B?ZjBjelBVUFlEOUwwNklJMVZuV0pWNWttdmlXRU1JUHVRaEI3RXJEcUwrbjhE?=
 =?utf-8?B?WUZOU0h2M1RvWFJITFQzdjN4QTRQaU0vWFhNeURIK1VGTTY5dzdvMXBoKzE5?=
 =?utf-8?B?aHVrWTM4TkViaUR2MEQ5dE9DZjMyWnBjUk91SW9SNTJRTUVXYTNFcHVaQXli?=
 =?utf-8?B?djlNYWpnL1hTODRFbkhYSlowRFVzMG9iU1BURUJNWWc4QVhHMm9INzNsSkM5?=
 =?utf-8?B?V25SR3ZBMSszOWFpMlNmb0p6Mms2UU1RZGZndXlUTmdzVkljSGwvZktZUjFp?=
 =?utf-8?B?UUNhRTc0STlqbTQveWs2SWl5NHBtWWR5RkJTWW12d1F5VHlsRnJDQUg5Vmo2?=
 =?utf-8?B?em56WHRMMy9KYlBYWlM3dGsycUt5UHZtc2RLWnhTQmNPNHcxUDNLdUFJMHM1?=
 =?utf-8?B?blFBT3E1Ync2T1dxUmRWeXpmODE3U0FUdlhVa05lNTk2QkZFa3hob083bHhE?=
 =?utf-8?B?bUdMNXlqQjNJazMxNG82Skx6UkdkcmdQaUpOczQxRDUxS1NqbWFtVnBoVW5K?=
 =?utf-8?B?WlpGZXhrelZsRHJIekhzN2dlNHdTMmtpRnh2NjVMQi85K053MlVtWlhRV3pU?=
 =?utf-8?B?NjhST3doUTc4WlJuK3NtdkxYc2kvRGVQMnViYzN3YndwMlhHZEhvVHZvV3pY?=
 =?utf-8?B?VWFJcTNKVDdZVmhISWVJcWhPUXpWcDhsK0hMRVZ2VVp4Z2ZQbkw2cWFyOUwz?=
 =?utf-8?B?MkdPTWFUYk9IeGlkaHUwV0RsK2VvQ3ZaWXlVUENJUDRtYSs5STkxZHV6UGh4?=
 =?utf-8?B?Z3gzaDhiZW90TFFNK1R4VElZNXBJT3dKdTFYaVQ3dUlLQnpsZXQrYWlwK1ps?=
 =?utf-8?B?S3VpQ3E2RUkycHhiMnBQZUd4M1doUml5TG51K0ZjNmlYSWtiZ0MzcEFNNndY?=
 =?utf-8?B?Y3RUNkMwZVp1YTVSU0dULzJ6QUVUQmxOdlRxTFA1aEZHN0M1MkpJU3haSEl5?=
 =?utf-8?B?ZnZjK2IwMGhteW1oM2NjUUtVWitZZnpEQ0x6WTUxSnQ5QU5ySVFBMnhrRFpy?=
 =?utf-8?B?bHBkb2EzRVQwL20zR2d1cExHMURkTkIvSGcxZkZBVVo0VUFsWnYzd0NNck5O?=
 =?utf-8?B?bmtid3RQeWcraFZoTXVzdlY2aFpnSy9SOCtScFRuTmxhVXdUREJmY1ZweThK?=
 =?utf-8?B?dG1BQjQvdlJMWlViSzROR0pqZVdKL252T0VxL09vWEl1cWIzbnZjNVBJZ1hO?=
 =?utf-8?B?TnNZaFBpTlpUNTJFY2xLVzV2ZE55Um9CUkhOQUtBU3ExMXJTdTdXVVpFVmNS?=
 =?utf-8?B?eDQ5emVkKzVYa0RWZUVMcXRqcnYxRDFiZmpuZjNzNjlNSmc1aUZ1ODlFSkhX?=
 =?utf-8?B?N3lnZGF1WGhIcWgxWENqZUVmYUo1RkpZTUZXcTZyUDdoLytWM3JTanYyMG9a?=
 =?utf-8?B?RGE5YmFUL3hHLzBFNGJqbzlRWXUzYUxpb1RKS25nRVBab1lDUDRqaWpHUzBy?=
 =?utf-8?B?K1g0WXJNTHRWb1kxWUM5VUk1ZWdvNFcwMjhRck13KzJteitBTEdOZDYyNlJY?=
 =?utf-8?B?Tm5rWXZXOVR2YXZXYUhTcW9rczVSd0doRStCVTlUVm9ibG5WVzkzWWlCMHFW?=
 =?utf-8?B?ZTU1dDQ5akd0MlRtcUhoTzl3eC9VRTFmL01xMithMFdGdXkyMWtTN3RRR1Ft?=
 =?utf-8?B?ZStXRyt5c044aC9RSWVZOElYeG5NZERPdXA2V1E0eHFQeWJFc3ZyTXlhck55?=
 =?utf-8?B?TXp2OFUvWVVxUWpZRjNZNEszMTZ0QzNQMjJoZjU2a2ExaUpjSnhZTjBNbmJY?=
 =?utf-8?B?QjNlOFZhS3lTU2RFZ1hsUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6317.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHcrRCtwSnFMaG5yUlNIU216em1WMEY0dVhEWXJLNzJWd2E0N2tZN1EyZHh5?=
 =?utf-8?B?NVJhNnlUNmtzdi9udytpK1JYdXgxVzFqMUV5dEcxRVJlMkJSY2RKU1g5T3ZF?=
 =?utf-8?B?dVllQVZCa2c1Z0twcWhrM1JzQThUOXlEL0hyRlBKOGxJbW41RmVybDFPQXJn?=
 =?utf-8?B?RXh5amlsL0ZwYkNESnJkNm9weDZ5MUVCS1FCaVVZSDd4RXJrcTZpdFJHNlFr?=
 =?utf-8?B?bkV3NWNiNTU3NmFkeTJoUGZNRWF3cVdUMU5CYm81T2JEb25UbXBYTUdEREVa?=
 =?utf-8?B?STMrOG5TYmppR2xkVE91YTRvK09mS3pNTk10b1V5WngwMGRvOWNGSm1NTmt4?=
 =?utf-8?B?QUVuZGcxUzRLcFhPZWQ2dlVkTElJYUhuY2N4MTVkUU96R1lkMjRSenYycDVN?=
 =?utf-8?B?UlJhbWZWYTBaYU9LbldiOExidml6azNlVWRmWU84c2RpWTZmbGJJSk90Mk14?=
 =?utf-8?B?SnBKUUlnSGlGOFFqL0o2Qklia0xqNnZOcnp5V3B3RysyNEt4azN4cnVZOTlq?=
 =?utf-8?B?YUMrWHVBeDJmSTF3WjI0amxDMFA2aUpBelQrbjY0b3Q4OVFIc01CR2Y5YkpZ?=
 =?utf-8?B?aDBCMDdxMXo1cGo2eGZhWEROM0pLTlJIWWNHNFh4T0RCd3hxTWkzVVZwNUhZ?=
 =?utf-8?B?VnhNYk8vbUIyU0dncVZlbEs4eWErRnFWZGlLOE9nVXQ3VThFMkdWY1pqOU81?=
 =?utf-8?B?QVhyWkcxK1pmeHM2bmpjalUrUHNWMTF3N1NmQVVHcVY3bUFZT2ZjVm50aDJi?=
 =?utf-8?B?bG9FT2tCbERIRElWY3ZydDNteU40VkFDZXJrS2tWUHo5djhOblZsbG94T1JI?=
 =?utf-8?B?N2NjOUI0dkpqd2I3NVlDNndNQUpCUnVDbG5BMElrTmFkUmg2UjlzTjFUNXhM?=
 =?utf-8?B?YU1XblB4amdQYTM3VmR3VThrQVZvR2MxOGVRK3pEWlpyLzIwZmNJUDdzZm96?=
 =?utf-8?B?YnR6RC9YeC9pdmhIdWdiRHg2VjVvZ2J2WDlsZTEwL3VGeTVYVXozT25MUDhX?=
 =?utf-8?B?Um90WmtVcDRaZURJYlZHSTZ3SWRPVnByYW1YWEthZWJ3L0ZVdjI2blV0V1cz?=
 =?utf-8?B?NTU5SERRbWpxL2VtVmxDbWJZR2h3YnBqL1RqVlRueWtFOFptRDF4UkZlbmxu?=
 =?utf-8?B?VUQyNHNwaVhKWUZtckR2WVpCbEhES1BsL3MzQzFLbTl5ajdQa2FxWm4xTGRC?=
 =?utf-8?B?NWNrS0swOU5nZjR4M0xERXZLSGgyVkxOUHhTblBWVXR5ZDgzK2FhaFRoczNz?=
 =?utf-8?B?ekRKdzMxRmhBZEUwekFrSWdsVjkyNmtOL1VVTlhpSDZHRUV0RWhnN1VRZk1R?=
 =?utf-8?B?Q205ODZnL1oyZ2pWemlhZFUxUVd5dVdZcWJhcWxrblVuV1kxWFB4MEtoMmFk?=
 =?utf-8?B?dERsYUFKWG53WER1K1IzM2hjaUFaUFlCYmlEclZBeVYrZWF6Syt4N2VUMzRJ?=
 =?utf-8?B?SE03N01RUTNoL09xaDhMVjZhdmYreXpubFBxbHJ0eldLYUpKZ1VhT25iendO?=
 =?utf-8?B?a1E3aGNmUk1LT3dhQkNTZisyUWJxR1JQckpsUTdYTWgrR0lXUjl1K081NWhN?=
 =?utf-8?B?a2tvUW9rc2dYa3Fqei9BcWd4Ym1VNGhFUmVuTmtsays0S2xOUHZGUDc4cDZV?=
 =?utf-8?B?cjR4OGdWdDR6bFFmTFhMdnhyeVNHR3B5SnZnc1ozMnBHRTkxNk8vNk1kb0Fq?=
 =?utf-8?B?VXZXbGpFMGp0eDBWWEt5TVh0bWRjeWxocnJ4WkJ0akxmSW12RDlhSGR4dyt0?=
 =?utf-8?B?MnRwMjNmNFV2MnNhdjlWaUx6WUpTUndHeGhjV0JscU5aOU5oUG5BcXdWa3Vv?=
 =?utf-8?B?TUh1THFzZXh0aUpsNGYvWFJKRkJvQ0wvTExQTFVuMFdvMnpsRDc4SkJSaUJM?=
 =?utf-8?B?WW90UGlWUXVuTDNMK29XbEs5eDBLd3o2M0g4R1h6ZGtWeStPQVdBckI4ZVVz?=
 =?utf-8?B?dldWNStRamhQM0lqS0hvbktkYnJyMFBJRDVMREwvdUQzV0NFMmtCVSs2YzBs?=
 =?utf-8?B?Qm9RZlcrYjl3MFpVeVlWcGZYK1dDNXNNNDREbW1FWW9TK2crSzNtM0VacUcv?=
 =?utf-8?B?RG1nMGJ1MVRmTWhYam1qZHFkcTAvaUIvL05CL0pzUW83dDNmaUV6OGZiU29F?=
 =?utf-8?Q?DMbqNfnUqjzJoWFukZIBAa256?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4880adb6-3f6c-4274-fce3-08dccb0619f7
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6317.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2024 04:17:04.8489
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m98/iMNafCwoiq39FDPyi0neEK4e3WNabMCWpfW/XPUDLTZcqipPhjxS8Gb/2nbHQ2avV0irXkVtACSkzASq7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335



On 8/29/2024 6:52 PM, Borislav Petkov wrote:
> On Thu, Aug 29, 2024 at 11:07:44AM +0530, Nikunj A Dadhania wrote:
>> The Secure TSC feature for SEV-SNP allows guests to securely use the RDTSC
>> and RDTSCP instructions, ensuring that the parameters used cannot be
>> altered by the hypervisor once the guest is launched. More details in the
>> AMD64 APM Vol 2, Section "Secure TSC".
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index dd4682857c12..ed61549e8a11 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -444,6 +444,7 @@
>>  #define X86_FEATURE_VM_PAGE_FLUSH	(19*32+ 2) /* VM Page Flush MSR is supported */
>>  #define X86_FEATURE_SEV_ES		(19*32+ 3) /* "sev_es" AMD Secure Encrypted Virtualization - Encrypted State */
>>  #define X86_FEATURE_SEV_SNP		(19*32+ 4) /* "sev_snp" AMD Secure Encrypted Virtualization - Secure Nested Paging */
>> +#define X86_FEATURE_SNP_SECURE_TSC	(19*32+ 8) /* "" AMD SEV-SNP Secure TSC */
> 
> There's a newline here on purpose - keep it.

Sure

> Also, you don't need "" anymore.

Ok, do we need to add an entry to tools/arch/x86/kcpuid/cpuid.csv ?

Regards
Nikunj
 

