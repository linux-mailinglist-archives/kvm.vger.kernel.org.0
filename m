Return-Path: <kvm+bounces-31054-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBD99BFCFB
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 04:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF5801C21D6B
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 03:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B3A1885AD;
	Thu,  7 Nov 2024 03:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="W+IziQOm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360B436D;
	Thu,  7 Nov 2024 03:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730950356; cv=fail; b=tP8KfaGT24r1U2+BfP+FoOeBPDfucx5p4OlZltahksULqn95pxNYBzAkU7Z9E3f1tGFFp9z0khZ3glzPpXQ9OsCB1Y39wc085nImlMPZRvkoq27uldRTIBwrS31u2x3mTFnsqS87g264R4DPhWpso1oXFwKKi5C9xa8sY+tyN/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730950356; c=relaxed/simple;
	bh=hDzCVB6LX2XV40QRVbmu7BjYuUmhm2n3d0LfRsHuoM4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oY4/q7wJjxWEOCH5g7335C7CuM0hX0TpVNt89Pm7edZ0AGPKJJIAzHeUAc1bOWnSPqtwigcfpOyAewi5y9seFy/KZn/lq5RyS3JteD/KFMXcZ/GN+KL7TUqLD6Tu2avs5mFkIbc7sNhL/Xf0S2xuQrRW+7/FMGBpL4XOd6lq1X4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=W+IziQOm; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DG1AUq08+NBYfJUs4OQNmvLNTwx/4FkshUp2LbGGjPKdNPiyvc8MnPePKpGpL5Tku1t/KcWInQ1ThTM3RLpWgb5ZvW66zskZ4bC8ZpSIZaJal41x9/X77HSh66xH+L2cREpfbEO5TomtVJfecApzq5tfnUTIF/oRnwM1CSSl4q8pk+dCXccXP3QLzLE4ri2wwv1jkV2ZOjJCfcJf3b13v1yQrkX2bD7gE+txyXNM4qItStzxYyNZmLAthMUtwIR3ZTRT9bEFKDw6Sr+6o4Vo8w1xKeCW5no3xTqxfFB6RaVKA/BEbnrupfXB5AjL21GdwckV427Z436YOB4aByUokQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aDJzsvLp3NjSfv5k6QxZ0G5nWtsJfwzTF7xJwoOILw=;
 b=LWqp844IFBAREgA9dLA5auXc4ddar+uPt1pE/KBML/nKfezJSUIHMjugVh7+8WFgzqxYykVo+zfmvhJiip6NOP1JnW6aCchPltNpLeiVDQ3tI4NHkGDIGikzINhz+NVZvTUPess/vG6VCEk57g0nutsUKwBqK/VxKvDMArCkANXAlKtrDVlsg8pvXHuwPAvTeiIYmHC+ScrlG1rTf5AO/K+/q/mcd8LPQgCmnzZdmM9U13ogggqS1NtsFg/7sEfwGZSnb+oxM3zFznyfTl9EGhZw9DU+ellIgLH7SiSg7pGCA1+4Yd9FmGRPhGUvEbhr4M4G0uexl3HOdxIx3is9uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aDJzsvLp3NjSfv5k6QxZ0G5nWtsJfwzTF7xJwoOILw=;
 b=W+IziQOmr+BGQ9657FEfAvSDhr41dfOM3nO0OlEBczZBzdcOkXee2jGSieUWW8FQNRhXlkYaYVVdAcnaPkcrLhP9dfAclrZNXleg+DQIhySZ6LayN5ETW29C30mvGRmXUuA3LH4FMHx2Ouqk2hH2lDsdXEyCQYeX5plxIero+30=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 LV3PR12MB9117.namprd12.prod.outlook.com (2603:10b6:408:195::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Thu, 7 Nov
 2024 03:32:30 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%3]) with mapi id 15.20.8114.028; Thu, 7 Nov 2024
 03:32:29 +0000
Message-ID: <72878fd9-6b04-4336-a409-8118c4306171@amd.com>
Date: Thu, 7 Nov 2024 09:02:16 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, nikunj@amd.com,
 Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com,
 David.Kaplan@amd.com, x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
 seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
 <20241106181655.GYZyuyl0zDTTmlMKzz@fat_crate.local>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <20241106181655.GYZyuyl0zDTTmlMKzz@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0143.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:68::13) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|LV3PR12MB9117:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eab8173-5a6c-4ebf-6aed-08dcfedccea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cys2Nk9VYk9LNWpHWENrUzRHdlJVM0E4NUcwWDF3R0dBdEdwVzVXSnZlMGxx?=
 =?utf-8?B?UzZmS2t6S2NMdk55RWpDSVROQWswUyszNHFjN29qL2NHS3ZnSVZkZTNWNXlV?=
 =?utf-8?B?SDNNS0w2QlZFRDgwdTZzTzNmKys2ZE11aFY1akZrUlltWTNqK3RzdE4vdzJs?=
 =?utf-8?B?aGdHTzVhWm5LUS80SzlPMWN2Tk1oMnd6ZmVvUVFpakRpa3RMaWNoS3hiUVVy?=
 =?utf-8?B?bkUwY0Rwb3AwUUZRU3Jxck16bk5BK2dVTENjcEh1VVpGMGp5YWo0SlFQVTVP?=
 =?utf-8?B?c2RLNWYwZ2xiVVluUzBFTGpreCtFNi9MRlkzajRXcVJrZkVza0ZQeDV6UDJ6?=
 =?utf-8?B?TG9ZMzlwMGpkdHBqc3Z6MWk2ZUJscUdWTVp3b1IzL1F4VGFQaU9pbVIzamVa?=
 =?utf-8?B?Tklqa2hiQklRTzRVS1A0T3IraUNMbWlJZy9iaDlIWmU0WkdOQlhGbml5R216?=
 =?utf-8?B?dXc2SlZIQktxYUNhUWtjSDNVbUxlUXM5a0U5TGFWNy81QVZPNFJaL2FrQmMv?=
 =?utf-8?B?Zy9EUXp6NDV1Rkd1WnZSYTBoeXNGbmRrZEJwcUp0Y0tmOU5XS0lCTnFhZzkx?=
 =?utf-8?B?VzFWTHJMREpiRmU4WDlPbUc5bmZ0ZDFjQlRydEZxSVBzckhrTVRyMUQwSTI4?=
 =?utf-8?B?VWM3eUFiR3AxMURqV0ROYU1nMDFBdnRVWmo2Y2VmTzZlTXQzYWRSaGpNZnJa?=
 =?utf-8?B?TVBoTXl3TmVyRG43MmZaYy9EUm1yd0dYZ3YzalNGVk5uZmRETEg0WnI2bDhp?=
 =?utf-8?B?QXVEUFBDMUwrUUxWdkFnSyt1NTEwem45cnI4MkdjUE1wejhwcks1QXFUMWlq?=
 =?utf-8?B?WGFNRERaSTFORm45c0hLZ0VPZWFHT2N2V3NoSlhzY0oySkhKcW4vNTdOWnVR?=
 =?utf-8?B?eUphV0NWUThJUlpoV1ZFdzRQTkVoTUpEKzhJMTNiRTBOc2d1WCs4TGVoWEll?=
 =?utf-8?B?T0RMSS9PTWFiOHphNVlRQ1piQXpMeUdPeGVQVXhMeWFqbGlxRzRKYk9sUzNG?=
 =?utf-8?B?YTdpMktORG5CYkdnZmVPRFdYVXNmU1VEOTZiMVJVb05sR0loQ0VSTklxbTQ4?=
 =?utf-8?B?UExTR0l4UDVVKzB2WERVaDdFZ081SWhzNnVHRmNyNDNsZWR1alVGL0dyOHhS?=
 =?utf-8?B?UGQ4am1OZXM2azVjb3IwUzhGRGtXR0EzL3B0SDhKNktFNlVmVTNvL3N5dkVq?=
 =?utf-8?B?YmYrRmFCT3pYdUV1dUx3b0hXM0Q0S1FqVmQ0MTBRYUYzQWV2NUh0MFh6NmFZ?=
 =?utf-8?B?Um1VVlJJN2xocW1QN1ljd2l4U0ZvbWZZSWRheExPeFBKaytYN2ZoU25iZko4?=
 =?utf-8?B?aGJPU25UWUhzSng3YXNkM1ZwTm9HdkhScndvZW9Ha2FudlpMK2xpWDZmYjQv?=
 =?utf-8?B?ejhtTTBjNkF2VHNOQWkzbWtzeEIySCt6ajYxUE1qbDFEM1lBRjVzbUx5NVFZ?=
 =?utf-8?B?Ukw5T2grd3lEK1ZySFIrbWJ6SEEyNjdaWDh2ZVhkd1pBOVl4OFR3ZmNHZ3ht?=
 =?utf-8?B?czY5SHBPZkZBQnZJcUZyTW1Za1c3eHpBTHdKNWFxVE1sRzRLWkowUU1BNTUr?=
 =?utf-8?B?a2pkYVJXQkNpVGZtU3FvWk12NzhZcEc1WG1OUnR1V0VlSnRHcklqcE4wd3hE?=
 =?utf-8?B?MGtteCtZYnZod2Y5VDdjbnBpdExKeWxXLzRRQjR0OGxlSmN5djVsRWx4TzBo?=
 =?utf-8?B?S2Vla3R3YVN3Q09OaFZEOEpndlRUMUNJdlk3OVdNeEk3VTJXYUdlTjB5L2Vl?=
 =?utf-8?Q?DNNz3EnnVnYuwYv53+8tcvUnQw5RZ/4B4dnO1vD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlBPMmIyVVowZjRic1M2TTF2M1AyQkR0KytXSkdIRTZodnRaY29ycjlLcFBl?=
 =?utf-8?B?a1BkK1lmQ2RhTmFYaVczWkVZbEEyVnVReUNiazVOdm1qcEdYdzk1eFFJMHFF?=
 =?utf-8?B?ZlBGY2Zwc2VjdEtjZ0RsUnFpZUhDWFBpUHRZOCtrSUp2U0tsU0NwKzNWZ0Zr?=
 =?utf-8?B?SXB2QlFTWDcxcXRRVE1VZmpTTGFWTFJDZ2REblBwb1VmSlA4ZlNHVGtFdXI1?=
 =?utf-8?B?bHlGczJXT2hDVTFJN09EZ3VVZlJJcEN0SVNJYnZUNGhVT0dreHFCWktweG9Y?=
 =?utf-8?B?dnU0VlRkZWZzakJwbU9nWm1UNzIyL2c2M0tvRkU4YmVvODVNSGwrelhra2VW?=
 =?utf-8?B?YkZ4aXVZU3NJQ2FNRE9OV1dheUlabDYxamJpMWFzWEFDemNxNCtrd3dvZkFC?=
 =?utf-8?B?eXE4bUFqaUJxZldWK1VoaUY3LzhWYXBncHNlbnN4VjVJTHVzOG54Z05NK3JL?=
 =?utf-8?B?MXFYaDBLMGJLNWpiemxweWUrbGRYQTZZQm15THRjNXZHQ01pS3NLWldjZjFW?=
 =?utf-8?B?bXRYQTlWZjFUb0svK1U3S2VuSE1lNytKaUs1WTg4VG41UElSUDhhc0lvZ3dD?=
 =?utf-8?B?YnovN2JPNExnNGRUaDRvUU1meGE5REdlemRwSUluOURCV3l2UjYwQ2cyeFd4?=
 =?utf-8?B?dTJHNklaTGJieGpzNm95SjVYSVBwTUZreXFSZDl0YTNRVTF4RDVNeWEzV29X?=
 =?utf-8?B?K3FnRkw4d21QQVRiNU5qSExuN0RRZHlaRk1JYVNMWWxkUjBIeXRjbmlXZ29S?=
 =?utf-8?B?OHBNejVUQzM3VEkwNTJxZms1cjN3S1RSTVloYjgrWW1salRnb0owUURCTzA0?=
 =?utf-8?B?elo0U3k0dWpFQ1F1WWRyQyt4eEdodXBwUTVtSHRPZDg1THlGUStYWU5kYVRa?=
 =?utf-8?B?M0tUbHZySjg0TDlhV3BjbDhhd3c1L2kyM2FQWmlFK2pjcmFGZUF6T0I1R1Jw?=
 =?utf-8?B?NHRhYVp4b1FLVGJMWEtEc3JiV1U0aDNmMjMyTlo1S3pjV2xEZmo2YllPWU85?=
 =?utf-8?B?SGcxbkJzN2ZIU1h1dzlnSmtpNjY5cXdXR1hTWDlGNVBhbHJzQVcxWWNpNk9i?=
 =?utf-8?B?Zk50b0tnZ3dudThURmZ6SHhNTGRjeFgrNTEzbXRjRU5TRytncmRKL3lwckVZ?=
 =?utf-8?B?TDdlYS9idzJtR1U1MWlIYWQwT3dCbVhIdGxXVUZIRmJFUU5UbmhlOWx5a0xW?=
 =?utf-8?B?SncwNlZzb1o0dXAwTHlSbEtJbHRPbnpNN2VndzJnemNQZ1I2MmFvVGdEaDZw?=
 =?utf-8?B?Y1V0elRMNFhiVCtvRTdLcC8vRWp3dU1HTm9YOG1BbDRjbEpydXVGbVVrdHAy?=
 =?utf-8?B?VFg1WDMvWldPNm9wbkREQ0NDaitoL3hrYjhuWG13bktXMVZTNElwSVJ3OVAw?=
 =?utf-8?B?ek9BNDBiZE9XYXNXOWYyMnhxT0FXY3FBekVQNE1yWVdycXZVOVkyaGNMNVdI?=
 =?utf-8?B?aVJsdGFuTEV1L1E1VjlPUFZlNHdwUDduMndqcm1GS2ZlK3RPV2p4c2MvUC9G?=
 =?utf-8?B?MjVpOXp2NnJSUmFNSGVzenNJQTlLcFlTWEdHakVJY0txdkh0Rk1ZYTZIWGZr?=
 =?utf-8?B?Y1FQVXFicWEzRVoyOWs4ZDFpL3NSaWZjSVFBRCt5ZFlnMkVDY1BVQkJMRW9Q?=
 =?utf-8?B?MjB5SnV5MWVSUEEzZlcwbldvaWRiYm1yYlFBVDJ5eWNIaGRkb05YNndYN210?=
 =?utf-8?B?b1NDQ25rK09GNDVkWDBRWXFXRzRIYTh6SENNVnIrYTZ4Z1VIVStZMytzMmh0?=
 =?utf-8?B?eHNQODdsdWZpNlBjeWpnNlR5UTFZeDFuNDgyejF5MExOaVRqd2tWS3lMVi84?=
 =?utf-8?B?TlprTk0rK2VZTkc0WGp6VFNOc2xWeUkwenlUbzd2UWVoaWt4OHNnSytoSlV2?=
 =?utf-8?B?bUpoVmhPYXUxQTh2TzBORmdaRmxIbEQ2NXo4dCtIOVhiQ1hnM1dLNGpDaVpq?=
 =?utf-8?B?ajlmSDNSOHozWGd1V0hjUGw5cnMyOVE3SFMwRUNwc3V4SE9TSkI4ak5sem1Y?=
 =?utf-8?B?UnNTQTVZTVVwQytmSlJKUjQwaS9JTWdEQXh1aEJFeWdQYlkyTzZWQUlPL0F2?=
 =?utf-8?B?ZVY5Wm9od0kvV1crL2hCYlhzMk9KTE5VTzdqbGVhbUN3TmZ1a3dBa0M3c3hB?=
 =?utf-8?Q?9f7JCseuWqBOeeDWwZzKmD7h5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eab8173-5a6c-4ebf-6aed-08dcfedccea8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 03:32:29.6751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBB4OijGl8AYAYuTnpeURVRwuQGsweZF+lE4lDkBRb03rGIrxp4f4SccZrM5MPCkfInRYPGvMD0FOnGclGL3Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9117



On 11/6/2024 11:46 PM, Borislav Petkov wrote:
> On Fri, Sep 13, 2024 at 05:06:54PM +0530, Neeraj Upadhyay wrote:
>> @@ -24,6 +25,108 @@ static int x2apic_savic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>>  	return x2apic_enabled() && cc_platform_has(CC_ATTR_SNP_SECURE_AVIC);
>>  }
>>  
>> +static inline u32 get_reg(char *page, int reg_off)
> 
> Just "reg" like the other APICs.
> 

Ok sure.


>> +static u32 x2apic_savic_read(u32 reg)
>> +{
>> +	void *backing_page = this_cpu_read(apic_backing_page);
>> +
>> +	switch (reg) {
>> +	case APIC_LVTT:
>> +	case APIC_TMICT:
>> +	case APIC_TMCCT:
>> +	case APIC_TDCR:
>> +	case APIC_ID:
>> +	case APIC_LVR:
>> +	case APIC_TASKPRI:
>> +	case APIC_ARBPRI:
>> +	case APIC_PROCPRI:
>> +	case APIC_LDR:
>> +	case APIC_SPIV:
>> +	case APIC_ESR:
>> +	case APIC_ICR:
>> +	case APIC_LVTTHMR:
>> +	case APIC_LVTPC:
>> +	case APIC_LVT0:
>> +	case APIC_LVT1:
>> +	case APIC_LVTERR:
>> +	case APIC_EFEAT:
>> +	case APIC_ECTRL:
>> +	case APIC_SEOI:
>> +	case APIC_IER:
> 
> I'm sure those can be turned into ranges instead of enumerating every single
> APIC register...
> 

Below are the offset of these, as per "Table 16-6. x2APIC Register" in
APM vol2:

#Reg	     #offset
APIC_LVTT - 0x320
APIC_TMICT - 0x380
APIC_TMCCT - 0x390
APIC_TDCR - 0x3E0

Above timer related registers are read from HV when we reach the end of this patch
series.

APIC_ID - 20h
APIC_LVR - 30h
APIC_TASKPRI - 80h
APIC_ARBPRI - 90h
APIC_PROCPRI - A0h
APIC_LDR - D0h
APIC_SPIV - F0h
APIC_ESR - 280h
APIC_ICR - 300h
APIC_LVTTHMR - 330h
APIC_LVTPC - 340h
APIC_LVT0 - 350h
APIC_LVT1 - 360h
APIC_LVTERR - 370h
APIC_EFEAT - 0x400h
APIC_ECTRL - 0x410h
APIC_SEOI - 0x420h
APIC_IER - 0x480h

These are few registers like part of LVT (APIC_LVTTHMR ... APIC_LVTERR) ,
priority (APIC_TASKPRI ... APIC_PROCPRI), extended APIC
(APIC_EFEAT ... APIC_ECTRL) which can be grouped.

Intention of doing per reg is to be explicit about which registers
are accessed from backing page, which from hv and which are not allowed
access. As access (and their perms) are per-reg and not range-based, this
made sense to me. Also, if ranges are used, I think 16-byte aligned
checks are needed for the range. If using ranges looks more logical grouping
here, I can update it as per the above range groupings.


>> +	case APIC_EILVTn(0) ... APIC_EILVTn(3):
> 
> Like here.
> 

As this case is for EILVT register range, these registers were grouped.
(I need to add a 16-byte alignment check here).


>> +		return get_reg(backing_page, reg);
>> +	case APIC_ISR ... APIC_ISR + 0x70:
>> +	case APIC_TMR ... APIC_TMR + 0x70:
>> +		WARN_ONCE(!IS_ALIGNED(reg, 16), "Reg offset %#x not aligned at 16 bytes", reg);
> 
> What's the point of a WARN...
> 
>> +		return get_reg(backing_page, reg);
> 
> ... and then allowing the register access anyway?
> 

I will skip access for non-aligned case.

>> +	/* IRR and ALLOWED_IRR offset range */
>> +	case APIC_IRR ... APIC_IRR + 0x74:
>> +		/*
>> +		 * Either aligned at 16 bytes for valid IRR reg offset or a
>> +		 * valid Secure AVIC ALLOWED_IRR offset.
>> +		 */
>> +		WARN_ONCE(!(IS_ALIGNED(reg, 16) || IS_ALIGNED(reg - SAVIC_ALLOWED_IRR_OFFSET, 16)),
>> +			  "Misaligned IRR/ALLOWED_IRR reg offset %#x", reg);
>> +		return get_reg(backing_page, reg);
> 
> Ditto.
> 
> And below too.
>

Same reply as above.


- Neeraj
 
>> +	default:
>> +		pr_err("Permission denied: read of Secure AVIC reg offset %#x\n", reg);
>> +		return 0;
>> +	}
>> +}
>> +

