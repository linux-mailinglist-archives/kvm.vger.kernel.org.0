Return-Path: <kvm+bounces-57432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E194B556F7
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 21:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED3E03BFDE7
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 19:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73D32BE64B;
	Fri, 12 Sep 2025 19:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bAAkZvz4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2053.outbound.protection.outlook.com [40.107.95.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4C926561D;
	Fri, 12 Sep 2025 19:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757705841; cv=fail; b=HVSmWkk/9D8yqaYy1ZTxZ2xLDd/0UM1RJa9qGToM/Lr9WoxTpf7w7RJFaBDO8mjWbxWbhQvYH2lrFRejkdErFdq1H9QhHEZj61YT/SeeD/UT9bFyear9DAliiBj0HuToDKcjCEeaaj3vYTChwedK7i3Bbe6U59KrSR9UR3otuQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757705841; c=relaxed/simple;
	bh=kr8e8pQZMarMFE4DV/eUtjaEwKSlQj2gvbImPBowhEg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JTmU07WHf6Ojs0BYEwNkOdSOMuRXHzwEvsFgz/y/UYRXuxjn+SyVmO4Unrjk5s2ezDejXIXzHaK2+eNY5J5GFyHEwJtVn7HmfbrU6+9juRw7ZFI4uFDYbAeP+QgvtobNcWf0ScAQGWRooe/Gz6JcGxg110+/kWkSceuLRpHhIds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bAAkZvz4; arc=fail smtp.client-ip=40.107.95.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uc5GbcMVG/9NnnTIYGju98+vEo8xxEyBHOJF0U5duB6VsqFpv1gTNBy9N81FausLeDNVA2A4AD1jXw1SJxU3UrE3FLaikAGXSbOycIRmTNrVuhsfhpgiGt5ZKFP6mi3MKRBfV9HIUTNdSAhJ8GBuKMeo/K1vIiKlCIvIIWnXTSUOKqcEp+Ephgy0Yr5ZHbj3Is8IaPYI6RQb/LClN2atrNQBSrlm90NBDFkPAYXRAiAGUiwG91uXBReNS4nwMO2CzsGR3yNh1Rc1RvfvivFg8yh6+kiJSGggYJshKoordnb3vsKPII+nW9THVH3b7MZNlSNabF0VwEjjKu3SYzJhAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3kzXAU7k648mVpoC74BrTglnnsk1aEbRHAt6TBw07Os=;
 b=HvdOcksuvtp8qOffvCX6ewkMoTSMJmyoyywzyt42Jqt1RAQg7SCIuoowRMSMGKf92fw9Tc98CfvAfyrvQbf266O1JnHrFfZHf9uhoKKxc6YRUtTRtPUNFao02gQ54Sc83yW6btuqJ/Yn2TTAa4pbsBpI9d5r2ZEVNB1KV2lKWkRZSDmj8ncT8Bagms0BPWN3Hx0c+tqxfBKz4xvn5Oic0g9hNMZ+noMjv5ugy+c2W2f7q1te75snKEa8ITIoxkiT2BJ2T+L9mJQKmCKD8ANe+Z4kYPw6srp25Hcs7bzf4kJApayfeoSniVEbx/fMJJaVPRBEElsYpFqmUded85s1ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3kzXAU7k648mVpoC74BrTglnnsk1aEbRHAt6TBw07Os=;
 b=bAAkZvz4ZR7IPkE6lEReuUyX3h0eg8bjmWf9QzZtS/8lzRmIVLxu78/uwauxTwN6UvDS2n6814HH4/keAz9VQyTrniyCBusEFbvBcehVskzKtWx0UkP0UyFgyDPHc6wLL4svzb0k+9L3K7NKmj6BKxu64235pfHhcxidivuTo7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5062.namprd12.prod.outlook.com (2603:10b6:208:313::6)
 by DS4PR12MB9796.namprd12.prod.outlook.com (2603:10b6:8:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 19:37:16 +0000
Received: from BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a]) by BL1PR12MB5062.namprd12.prod.outlook.com
 ([fe80::fe03:ef1f:3fee:9d4a%7]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 19:37:16 +0000
Message-ID: <df357d87-3b4b-41a4-acdf-31289590b233@amd.com>
Date: Fri, 12 Sep 2025 14:37:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to
 snp_leak_pages() API
To: Sean Christopherson <seanjc@google.com>,
 Ashish Kalra <Ashish.Kalra@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 pbonzini@redhat.com, herbert@gondor.apana.org.au, nikunj@amd.com,
 davem@davemloft.net, aik@amd.com, ardb@kernel.org, john.allen@amd.com,
 michael.roth@amd.com, Neeraj.Upadhyay@amd.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <cover.1757543774.git.ashish.kalra@amd.com>
 <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
 <aMRnnNVYBrasJnZF@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <aMRnnNVYBrasJnZF@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:806:24::17) To BL1PR12MB5062.namprd12.prod.outlook.com
 (2603:10b6:208:313::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5062:EE_|DS4PR12MB9796:EE_
X-MS-Office365-Filtering-Correlation-Id: 17e7375d-f769-4a49-79db-08ddf233c7b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SVVpb0tqTUc3RmJtZEZ4YldwVGl3eWNPY2QrdVFHWm9pc0tQMmtJSGhOQ3Vi?=
 =?utf-8?B?elpXVXErdzlZRlpFYTZLYWsxWFZHK2JRSEJrWW9ibnd0M25EUTl1K3l3SDJw?=
 =?utf-8?B?K0dCSlp2bmpIc1NoTEZVYzk2SjJMd2pHcWF0RnQ4MDJWYmhEYitxeEtJUkJL?=
 =?utf-8?B?ay8rMThOdkFYOVFyRE1lQ0tMdDM4SWpHcW00ajViNVA1akV0VzRhT0QvZ2xq?=
 =?utf-8?B?TXY3ZGZ0NjJXb0xvUjArM093WUoyRFFaZG93RUVrV0NJNHUyY3RFSzViblhV?=
 =?utf-8?B?WjBPOWlHckVjZFRxMmI1dWRwMXZ6dmFDb0hyYi9XYmZOZjU4clczZGI0a1A0?=
 =?utf-8?B?d0NoQzY3NS8wblhYVCtEWTV2d2lPLzlpTzJEbGZjMUxBYmFzWUZBeUxPUlkw?=
 =?utf-8?B?Um1ZaU1RSjhxcExaQlRlazFDL1JYT2JoRE5mWFJBaWkzR3VUUzlhVmE3L3NL?=
 =?utf-8?B?VXI3a3pNZFlVaFNVcHdGOEZta1B1d24rQWQwaUVFVnJIc3BjN2s3WkdJSVBK?=
 =?utf-8?B?ajhqOTF1MXgxQnZSSUE5TXJJSkdFSWdOSVBzVHNLV2NBb0JiQW5OR0hlOVFu?=
 =?utf-8?B?SnJ0L25NeVA2dm1pUUxuUWg2TGR1K2RZLzhMY2dkck1YUDdlWGN5bHlKUkU4?=
 =?utf-8?B?L2Q0SHV5QUl0Vm55WkhBTHVQWjhENHdScWFWY2x3TjY3SXpGcnFtb0xzNE14?=
 =?utf-8?B?MVpacis3MXF5aXM0eTVzQThhUE5FSkdOa2tSR2ZVL2F2L1Fqa2dQbVNZc3lC?=
 =?utf-8?B?YVg2V2czdTRZVkhhUFVhT2tITXlqZCtLUVowQWIyZWc3bDlvNWlxallNT292?=
 =?utf-8?B?UEFzRWtOanpwaWY3WTZlNGMvWHkrU3RWeXFSM2VycE01d1FXbmR6Uzk5ek16?=
 =?utf-8?B?Uk51ZWtLa0kvOTFYd1pnZnJqdzVBcHRHbEYwR0l2aHRGMFR2NUFSUDdRbDBM?=
 =?utf-8?B?NkJkTThucUJyQWZsQjd6TWJLa1RqNzRvNkVSRG1JVEFNY2Nqa1JLVDNjak80?=
 =?utf-8?B?dzc0ekh0V20xWFo2Zy9ONDFIRkVQZ0FHV1U1L0poK3JYNHAyNjJxZkFLTWRi?=
 =?utf-8?B?S3pGMlNMTzhZRmVQeENvWWJLVzJtWWRkSWZ3SS9KbnYvdy9tMzNaNGVXSWd6?=
 =?utf-8?B?UHlZRjg2cGFQc3htQzRFbUtHZTJyaVZyOVFQUUsrbVI3cDJ2Q3ZZRlVVSUJm?=
 =?utf-8?B?K3NEVVlLcmROZkFFRnY5cDc3Q1hmTDdyTWpXQWZSZnNCSEcrbnlnWUxsdWlh?=
 =?utf-8?B?TEZjYkdQTVNaOURBbG5CQ2pVcjMyS1p2WVAyL25rejVMVy80UU1sWWdwUkEw?=
 =?utf-8?B?QktybEpkNFB4SkNxdUd4eVJZNEVuZXA1cFFrZDhETyt3enIyVkd4YkZNcEdU?=
 =?utf-8?B?S3pZdHNrSytFQlA4Y1MvbG44ZUExdTM1eCtSZ3orcXRrb3FPRkFEK1FmYXly?=
 =?utf-8?B?MFMySEQ2TTZlNmxoTzkxSUNnT3hIY0NuWHhHVGM5U0JoZ0JsV3RRRTIweWNs?=
 =?utf-8?B?YlpQajNlK2hqNC91SUtJOTZKRlpWcFNBbVY1U1RZV2N6TlVVK25mUlY1VEhi?=
 =?utf-8?B?ZHJmK1Yra01Md0gvVXNvaWtMNWpVb2U3R1ArazU0ZFQ4d0ord2dydCs3R2hI?=
 =?utf-8?B?b005MFZCWk5MWlFWUUpqZHBzUm1MOEZROTNUUjhNbDE1cjNBMzhQUjR2VHNR?=
 =?utf-8?B?ZmgrNjEzb3V6S0luYUdiQ3lSSkR0Tk44QXlzK2loc3QrZ2NWNWZyVVUyYzlK?=
 =?utf-8?B?MkpOUnNTSy81L0VoTUYrTi95R0dMTHJoeTJUOWNRVlJZNVlZNmJDbzBsTEVD?=
 =?utf-8?B?QTZLRmw2WEx2MHB1cU1lU2lMbGtWUms5Q3pZTjdoV3NRZmhXY3ZORitlM05u?=
 =?utf-8?B?dnM4TzVKRVVCcFBNeE5NZ2tRUElaNTM0MnVZbndoQWFFVFdVY3RtaSs0R01Q?=
 =?utf-8?Q?yTBDjWuIvAA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5062.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFJrL042c0VYclhWNEV0VCtuZWdUQVhJeXNVZS9RSUdJY0RNNUZSREF0d0JP?=
 =?utf-8?B?YSt4WkJ4cTRGaFR2Ny9TcWFZQkpsYzk0aWNkZVJmYmZUSFVSaTQzOTJiMjdJ?=
 =?utf-8?B?WXVlUlRCamZSTFlIN3NIM3pNMkNEVVYwN1dHRjVyU2tvQzY0Kzcvb1RITzdL?=
 =?utf-8?B?aVQ2cFdtTVFkcWR3RDhsNEdqbFNnUDdUcEtBOXNNN01XYmcrZjE0Szg1WSsr?=
 =?utf-8?B?clBzeEVOdTVvaENSZnNQeHRXdzhOK0VMK2pzMGNPY3hHZm9kbGNseldvOFhz?=
 =?utf-8?B?Y2Y2Q3lwZ0VRa05qVXByWmczT2RhWDFvSmJOQTZlKzhlMnFFeVRvWnEwOCtv?=
 =?utf-8?B?Y09leFZFWHVDQklaOWhmeFR0YXFpTE9uMW5GRTdsbWpsNVJVckZtVVpsZ3FJ?=
 =?utf-8?B?cjRtbjNabE9IanhYSGpZd2VMUk9YVEtHTXVJYmFsbXRucFo1a0tyRTZHMUVa?=
 =?utf-8?B?a0hEeVY5N0p5N2RsNEt4OWpRZmVUaUFzSGdkb294TUVlMGFFeWVJS3NYZXFl?=
 =?utf-8?B?MEFzQ3p6TU9VVjdCcE1aZ296bTloTVAreUhZQzZRb1MveGd3aXY2M0l6cW5D?=
 =?utf-8?B?VWM0NkMrL0NERWRVdERGa2NKN1pGTXhKU1hhSWJuTmI0aWRDSkNaVkd5SFB2?=
 =?utf-8?B?c2VDQXlBZFp1aVRmTm5QVnhXeFFKamhvdGlXeEl2K3d6eXJ5a28zcWNHejly?=
 =?utf-8?B?WEMxRFdFV3k2a0Q5eUltQ2ZVVjdYYit5ZWpMYXRkV3JCUEo0RldWMW1ndkxi?=
 =?utf-8?B?NTRmZUc5YjBTQ2F3VzhhV2dXdTFWbVFaUlR2VU9UWUNTVFVyUmpoSVU5NmZD?=
 =?utf-8?B?QkRnZDZUUmtjNlB1SEFkS1ZDL3VRdmJseFVKY21UdnNiRGsya1ZuVU1TT1R5?=
 =?utf-8?B?b0JPNlREd1JpTTRuREFKd2t1OEU0eWQyVWJld0lHeHRzRkQ3L3FNdmpGNzhE?=
 =?utf-8?B?RTUzbHdRV2ZIZHVrNUxJQUNjRGJMTzA3Nkg0UnhXd2w3aElWcmNLb3lrVENl?=
 =?utf-8?B?MHJFYzUxZmpVYTQvZXRrcm5XR0FEY2EzRjhQclBXbDJVY2h3bE9USXB1TlRo?=
 =?utf-8?B?SFNna0xVQ2tLdEwrVlZLZGIzK1lUcGVtT25iZjB5ajEwTGV5alBwVk0xa25C?=
 =?utf-8?B?YUFSODFZZUFQSGJBTEpSVUtoYzd2VTQ0c1VVWU95eGVvemg4N2NhbW1iL00w?=
 =?utf-8?B?NDZBbXpmbzMveTNPWjFhU29yN3RkZEJyQXhPTVo1MmFoM2FvejVEdUZHRmx4?=
 =?utf-8?B?UG00dVVnSTkxaVp5QUFsK08wUDJlNUYzazE2RzVCK3BoNWdWODhuWE0rSHo0?=
 =?utf-8?B?b2hPYkl3M0UvTkdKVEk5S2xKdTBKbzBYZU5FQ0ljRUphMDR1dmdKUVgrYTQv?=
 =?utf-8?B?TFdnZkpBRkNvSEhKVEZvVHhvcjlMUkFPeGlkRUVtemF6WEtyN0tvSW5yN3VI?=
 =?utf-8?B?UDdkcVBYcFB5T0w3QUxNTHJkVTQrQUQwVG02MDdwRzZxV1BZaml2cW9HYW5p?=
 =?utf-8?B?bEVLdnJ0L21BOE5TSkxYK2Rtc3NmUVhXWGZ4d0dmbmlRaldpTmM2VW04dU5E?=
 =?utf-8?B?YXQ4OWU5M3ZaWmNqOTV4bnZMMXQ4cG84ZFJkRjBCUjdiU1ZXREpBRWpnMWha?=
 =?utf-8?B?U3RqbUUzdkZDTk9HL2ZGZm1zQ1cwNHhCRWlYOUFkN3UvOWI4QmFmQmpZOGpM?=
 =?utf-8?B?TVhNYjhuNEFaOTVCTzBhbGxvRHlVbmtGMEsyUXVHZm5KTis0TWsyK2RXSUFt?=
 =?utf-8?B?aitnYVFGVXRLNUpuTDh6a0pBM0lSdk9oZnFEZVRVOTFUR2ppRUhnUE5lRjl2?=
 =?utf-8?B?YktPT1o0RmxHdWVKd1FhTGpBWjVlVmx0cExVNFpiNDdsbmxvMVN1M2lCU3lQ?=
 =?utf-8?B?Yyt6a1VqU3kwM3IwSy9acERvZ3FzOUVVbXpRL2pncmM3YlhqemFHQUNWRDRF?=
 =?utf-8?B?UE1pdk1iVFFUSmtGZDVIRHBmZEFJRnI2UFk2UkJhV09kUzN2OW5yQUx1blN2?=
 =?utf-8?B?ZEhZR3VOOWlFZ29RU2ZiOXQxcHd6SjNoSnFUWWNha2ZNa01oSmV6S05LZS9K?=
 =?utf-8?B?NlYyL25kRG5EbTNxc0Irb01uVkd5R0Ribk96M2hQYmF6amR0eFpKbmFTb2Nh?=
 =?utf-8?Q?4JODBelGxiQ+lLOOVSbJKiIh8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e7375d-f769-4a49-79db-08ddf233c7b6
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5062.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 19:37:16.6554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eggZjL36pP3hn4hLNXmz/k4NKhcbTykrD9YMqm0i71MVoKOl9XJtexjuXMGJUdscEdiBv/Bcyp4p8AJ8N7cXIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9796

On 9/12/25 13:34, Sean Christopherson wrote:
> On Wed, Sep 10, 2025, Ashish Kalra wrote:
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 00475b814ac4..7a1ae990b15f 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -635,10 +635,15 @@ void snp_dump_hva_rmpentry(unsigned long address);
>>  int psmash(u64 pfn);
>>  int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
>>  int rmp_make_shared(u64 pfn, enum pg_level level);
>> -void snp_leak_pages(u64 pfn, unsigned int npages);
>> +void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
>>  void kdump_sev_callback(void);
>>  void snp_fixup_e820_tables(void);
>>  
>> +static inline void snp_leak_pages(u64 pfn, unsigned int pages)
>> +{
>> +	__snp_leak_pages(pfn, pages, true);
>> +}
>> +
>>  static inline void sev_evict_cache(void *va, int npages)
>>  {
>>  	volatile u8 val __always_unused;
>> @@ -668,6 +673,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
>>  	return -ENODEV;
>>  }
>>  static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
>> +static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp) {}
> 
> This stub is unnecessary.  As pointed out elsewhere[*], I'm pretty sure all these
> stubs are unnecessary.
> 
> Oof.  Even worse, the stubs appear to be actively hiding bugs.  The APIs are
> guarded with CONFIG_KVM_AMD_SEV=y, but **KVM** doesn't call any of these outside
> of SEV code.  I.e. if *KVM* were the only user, the stubs would just be dead code.
> 
> But the below build failures show that they aren't dead code, which means that
> kernels with CONFIG_KVM_AMD_SEV=n will silently (until something explodes) do the
> wrong thing, because the stubs are hiding the missing dependencies.
> 
> arch/x86/boot/startup/sev-shared.c: In function ‘pvalidate_4k_page’:
> arch/x86/boot/startup/sev-shared.c:820:17: error: implicit declaration of function ‘sev_evict_cache’ [-Wimplicit-function-declaration]
>   820 |                 sev_evict_cache((void *)vaddr, 1);

Yeah, this one is on me. sev_evict_cache() is guest code and should be
under the CONFIG_AMD_MEM_ENCRYPT #ifdef.

>       |                 ^~~~~~~~~~~~~~~
>   AR      arch/x86/realmode/built-in.a
> arch/x86/coco/sev/core.c: In function ‘pvalidate_pages’:
> arch/x86/coco/sev/core.c:386:25: error: implicit declaration of function ‘sev_evict_cache’ [-Wimplicit-function-declaration]
>   386 |                         sev_evict_cache(pfn_to_kaddr(e->gfn), e->pagesize ? 512 : 1);
>       |                         ^~~~~~~~~~~~~~~
> arch/x86/mm/mem_encrypt.c: In function ‘mem_encrypt_setup_arch’:
> arch/x86/mm/mem_encrypt.c:112:17: error: implicit declaration of function ‘snp_fixup_e820_tables’ [-Wimplicit-function-declaration]
>   112 |                 snp_fixup_e820_tables();

This function is only meant to be used if we're going to run SEV guests,
so being guarded by CONFIG_KVM_AMD_SEV was on purpose. I'm just not sure
why the stub didn't get used...  or did you remove them?

>       |                 ^~~~~~~~~~~~~~~~~~~~~
> arch/x86/mm/fault.c: In function ‘show_fault_oops’:
> arch/x86/mm/fault.c:587:17: error: implicit declaration of function ‘snp_dump_hva_rmpentry’ [-Wimplicit-function-declaration]
>   587 |                 snp_dump_hva_rmpentry(address);

Ditto here.

>       |                 ^~~~~~~~~~~~~~~~~~~~~
> arch/x86/kernel/cpu/amd.c: In function ‘bsp_determine_snp’:
> arch/x86/kernel/cpu/amd.c:370:21: error: implicit declaration of function ‘snp_probe_rmptable_info’ [-Wimplicit-function-declaration]
>   370 |                     snp_probe_rmptable_info()) {

and here.

Thanks,
Tom

>       |                     ^~~~~~~~~~~~~~~~~~~~~~~
>   AR      drivers/iommu/amd/built-in.a
>   AR      drivers/iommu/built-in.a
>   AR      drivers/built-in.a
> 
> [*] https://lore.kernel.org/all/aMHP5EO-ucJGdHXz@google.com


