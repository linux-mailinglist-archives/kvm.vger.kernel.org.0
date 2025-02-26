Return-Path: <kvm+bounces-39225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF55A4555F
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 07:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEA793AA961
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 06:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E883E2698AD;
	Wed, 26 Feb 2025 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="va/uymMP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC17D268C46;
	Wed, 26 Feb 2025 06:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740550568; cv=fail; b=HTD++1WnpoMd/LFifxPp6WXJIql+CpDcC3Kb2+o6OYSzz/6e4lQIQQdAdCRJVvQQDulMKcnXtQIwMr/PGhOlsZibDGJns6uSUFpwlO1QhE/hng8rSkm6sPh1LORp3HjbMZC54Zye1xqgTof7/DFNZ4Xjc11hbJJAPXPzQVgKlbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740550568; c=relaxed/simple;
	bh=tRKtxE3zsL3TTZZdvV5i8NB/+OciSxjT52yCA/7w4mk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mfUF8T8TOWJ4biCln3AKWMMf1MldbVmj32//bXiuNvAaef99HSok/zQVpTuPV6IaGkz3JqA2kLQa3kCYcXJAJYjVSIoaC+QcpGh9VV0JxNM5nZvxhzBpd9JqZdkQke4fM7EerERYRqqoZiCkJBTQMxCJFnP8OkKAVGqFK4GRl2g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=va/uymMP; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JPZwx+K/kQ8a5a4Xn9Tx9/uKRRWnOV5+BUyJOFh7eId19cEjAbTD+bzNb+fgn61/hVwjeAF72TjT19slaewLE60OnUTAKkcGBSjXwso/h67RovrfcEIjhjOsuayc7IqLqfuKCacOZbRTFE0s+i0SOWFk0G2PXx1+X57pP7C6DJiR+f4Z/tOs1bxt6p43WibALpIoCKcSrchxzlCfjnc/+TByl5/QvqCE80wS9IdhQ8QgoBVzjncAzphzlwXA8Lsx57nmuVbazW6h6XS8OmDD41ukCza8Zp8njEi7nN7fhwZSC8fU5nJdZ16igIxn2oKV3fk2TUOZyHWZCKmzhH6+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iEuOIQjT7+uHVa4gDh+5aOD1REEVXo31JZsbjI/R3lk=;
 b=Reg2eB5TVzuQFZy7EmB/dVR4zkFKpN7ehgHswYUjJOOQ5/HOdSG2ItO9wp37r+lMNsLj7bOlcAouonmRlKwJexhCDVHALJD3jWhQx+Twb6K0XmYjUktZHQPCX5UrJV+XS19N7oRrTejzl3gWOXz+s+NyZpiuvtirhb2fO2zdiMeNxgaDmyCDqhlh+Li0+87flYDZFYdsyZN4VZomLgAWrkFPOFmLdQ4cMppw5ZhcZzMN0upBp61oLY9KK17UiQHIu330oMq27yf6RS8tGWd8Y/3cjUETkcSLWxpXOkpVLPgfD6p1euh6WRGgmAxdM+sVl99SeQH7C7Eb4uCeD+hcVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEuOIQjT7+uHVa4gDh+5aOD1REEVXo31JZsbjI/R3lk=;
 b=va/uymMP078fQ1kPM0s7MFQhWOp5/YIyud80YFBFtECFBrmbHP6asXfnMwpFalDF12MVebEczm36afXKvij8MPp3fJOi0McMYq95iJco5xpTZbub8BcsQy3IN0S9PneaNPSHX2wmQOO7Q4tiaAkpA0K9bzsxpspLqjBSYuEeZ0A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by BL3PR12MB9051.namprd12.prod.outlook.com (2603:10b6:208:3ba::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Wed, 26 Feb
 2025 06:16:03 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.8489.018; Wed, 26 Feb 2025
 06:16:02 +0000
Message-ID: <27bd2e67-5e19-480f-8382-26969045d2f2@amd.com>
Date: Wed, 26 Feb 2025 11:45:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] KVM: SVM: Manually zero/restore DEBUGCTL if LBR
 virtualization is disabled
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, rangemachine@gmail.com, whanos@sergal.fun,
 Peter Zijlstra <peterz@infradead.org>, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20250224181315.2376869-1-seanjc@google.com>
 <20250224181315.2376869-3-seanjc@google.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <20250224181315.2376869-3-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0012.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:25::17) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|BL3PR12MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e92e8df-7aa1-4a08-b12f-08dd562d0b95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SzllbVg2TnJPNk1ucW9JK20vRkRZdmVMZXFDZUY2M2NvOStHb1hzVFBRRlFm?=
 =?utf-8?B?a05nNTBSTkhTOUhZdndSOHYxck0zYmhtY3U3NUJBK3hJYzBINktjZGFNWFdo?=
 =?utf-8?B?czRTTzVuT1h4NlU1M2tCeWY5WmxrNnViZzdyM3dNMklSVTIvRnBldG9oUWkv?=
 =?utf-8?B?ZVBKbHhNTWRKZ1pqTkRVM3cyQXVvWEtaRTVUa0pIVFRLTC9tUDgvRnI3NlhL?=
 =?utf-8?B?SG1rcGk1alZhUHBGcHM0dGlhNE1Xamo0Smt3R2JRQWFtWnZEVkF0MWIxN0lO?=
 =?utf-8?B?aGlZQ1ZteENXUENBZWptN1NLZlpqZ2xyWmNaZjZvV1gwUlRXM004MVhUeXlD?=
 =?utf-8?B?YWRielpoNVZJVHdLSC9lbWZxSW1NNmlkc1R3aEFsY28wZjRNY29jMXVINjVM?=
 =?utf-8?B?eThxRDRVS1dra1pKWi9EUnI3WEhPaUVMSTlPTjIrY3BpUTEvUVg3di82SWFZ?=
 =?utf-8?B?TGxJZ1pVNy9XU2lESHNYZUR3RS9ocDdsTWc3eDU5WUNFcndaSDNhVUd5L2Fq?=
 =?utf-8?B?SUQ0aTFNZmcvbFd0WkwzdlVBckcrSytUNXBJZkl5ZTRTSnBzOGNtby8wMzN4?=
 =?utf-8?B?WHVNby9EQS9zVW1uTVFacXkvOGZzbWk5am1hWVNDMklOdWdISFhhOVpGYzR5?=
 =?utf-8?B?b2Z2Q1BOaGZaenVhbjQ4SUlvbWRKNy80Ty80OFM0em1hd3J5QUR1NjNqNjQ4?=
 =?utf-8?B?NGdVY0ZKVVYzeEVHd2RlZERueWpRWU9SLzlyeFlFekkyZENWL0xrcy94bFEr?=
 =?utf-8?B?QzFraGNSQTFIb0NNNEcvMkI5dkdveVpuLzd3WERGb3lxaklzSDdxN1FuWXIv?=
 =?utf-8?B?SGVxeUV3Tk0rZUxmY3ZFUER4SHcyYmJJMXJtMElrTzRYOElPRllzUk5BTHVx?=
 =?utf-8?B?RDVZSHRsOXJSUmtXYUc0TFRJM1pPT1dKOGhGK2gvR3JIV1FSMG1mM05YemZm?=
 =?utf-8?B?OU5uT3pSUE03RERNeGtNYjgwNWNRZXRSdzN5Snc1eDlLZDBIcWJoU1ZWaktI?=
 =?utf-8?B?OGEvbWJaQU9kMHVucjhSNlZ6SVpRVTVRS1MwOWkwWVVjN1pMckdSeEpUMEY5?=
 =?utf-8?B?bFlrRC9laUViYWFTMFdrMzdrNHFUTitzNEllZ0lIbExHRjA0b3pQMmFPc2Qv?=
 =?utf-8?B?SUlUZ2I2TERLS2I3MGF1MHNoazJIY0Q4ODdxN3Q3ZmxVd0ZBOElqNXZLQnp4?=
 =?utf-8?B?N1F5Z21XS05ZSDN6TDhIYjFzcDNSaGdtMjRLOVR1ZkdYbTVtZkkzVStRL2pV?=
 =?utf-8?B?eWlxZWtIeTUyMSt1eHlDZWFjWVFobHN0VXpHWE5Oa3Y3V0l3ZmJnUmFBbkZS?=
 =?utf-8?B?TWI5Z2xCbytGMTA3RldsM1dTeWI3T2ZJVGo4Rm1ncGltK0YxaUhqTjJPWGR6?=
 =?utf-8?B?NUptMml0YzNkVFkwQjlhdHBkOVVtTGFyK29mTW04UCtCVTU0MDB3d3VNcUNt?=
 =?utf-8?B?bmNRaG5BR2FHT0tCcGJUbEpTeEYySjNLM1ZwVWFOMWN6ZEN4WTNvYUd1Rk1w?=
 =?utf-8?B?VDg3dVZVRm95T2xOYzZZZksyZ0RrcndVcWhkSldySCtNRkE1QVJUclo2ek5O?=
 =?utf-8?B?R0gwV3UxNGFWdnNoWFNTRHQ5TVliQTh2SnA2RldiR1JNdTBUWHpDTWRmbHQy?=
 =?utf-8?B?WkpZSGorbGp2SC9JaXo0RTdqb2VlMzhLUXZSVjd3RW9qRG5TYmFuejRlREVn?=
 =?utf-8?B?R01NY0JwL0hjZk5xV0N2UkQ1QUV6MzZ2NlBxQ2FKbGVJSmNINTdTT2owd204?=
 =?utf-8?B?OE9zeGwxYUxVRUM2cEFIL0NZNXBTczlqY0FZN2xWYlVPeWJrdllQbmlFWXZL?=
 =?utf-8?B?cFZRTk5vMndTYnB1YmtwQndQdVp1ZWUrdTdieUE2NUNzdno0clBKaWRnZkhV?=
 =?utf-8?Q?FJtjFprYgjS7F?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Vk54cHRnanQvM1pmN1gzTEJiS0U0Smp4cWdmcklYR09yZ2s0UUlhY3AxMi9v?=
 =?utf-8?B?ajJOQU9FQWRPWHBpWEtraVZnQnJLSmQvOVl3Zys1Q2U2ZUVlNU43MjQwelVs?=
 =?utf-8?B?UjVEclRjaWNTMm1EdStTV2E4ZEVsWGU2R2dsQWpZKzRpdFRiTkRDSEh2emNB?=
 =?utf-8?B?QW0wRTArYVZYNEl6ZmVJK3IyYWFIREN1by9WRTkzSVB4S2xjaWJlR0xLRlJH?=
 =?utf-8?B?WmpaOWtoUXVRdFBxRVdRNWRYeldjd09HcDFMZWdOeUlWdUN0dWw1czI3dmYv?=
 =?utf-8?B?amg0M1N2bkVPT1Rac3EyMTZXL1ROSit0cVZSVFZJVE8welY0cU8wRW41NExI?=
 =?utf-8?B?cktYdUdhblFsNGlMWjNDd3h6ODVFNFROWTk0Z3JBdSt1WmtBVXdsZThETHIx?=
 =?utf-8?B?clFKSEN0bVJ6cUdNQkQ1YVZUMElnUGtweERVR0lTc1ZUMXZCRmVVVFdzdUwx?=
 =?utf-8?B?T2ZFYkJhcnFlRGd2b2FuQ0s4RTc0UUN4dTEycUZpOEtTalYzbWhyVzhLSlBm?=
 =?utf-8?B?MW5aOVNKc3c4QXB1VUtTMEM2M1IwTDg1dzIzY0dLcUQwQWpQNkh4bFRqOUxU?=
 =?utf-8?B?QjhzOGI1aEJiYnpDdXVsMW8xeDVlaGcwL0JnZDF3R1c1MG5ycEdQaTJzYlhn?=
 =?utf-8?B?Zjc2OXVjS1hLNkFWTjFMbEswcldHbmZDWkZnQkg4aFJ1SXpMczRUc2lpQjlG?=
 =?utf-8?B?TkJoTmdvOFRFUEdQV0F4YXZsQk94S0VORWJwSXZxbVM0bkIxbVgxTGVBOTU4?=
 =?utf-8?B?VE5mSllLWDB6MkFKSGNzNUE0ZEs2TXRQQXFiNU5XNnM2eWhoQS9PWXpDa0pl?=
 =?utf-8?B?d1cvemR0VWZ1UHFrL2lXOW16bGppWlhpakdCTG9HTEN2M1J5V3Q0SjVHeE1R?=
 =?utf-8?B?Nm1NaUhpWTUrQVlvdUUzejVBS0tWTEI4bXcvV0ZDWWU4M0RSZllLUFA3aTFj?=
 =?utf-8?B?VWVPWTU1eEFLRk1pWDhJTVRRY0NtcGZsNG9oM3U3MEYraE4yTFFiVXNqbXZi?=
 =?utf-8?B?QU1SM2pvc0xlMkZnOS9MRzdybTJpZStraU9kb0JQRDkwQ2x1NlFuemprM0RP?=
 =?utf-8?B?dDBWZFQ5WDFOUkJneWtuVytyaHpmQit3UStxYStkcUtPaU1SMDFQOUJJMVlz?=
 =?utf-8?B?Tit1bFhMRS9FZmxPdzRSQ0twQ1pHSjBsbG4rS0dXNlV0MHdrVngwU3hxTEJI?=
 =?utf-8?B?cHNHWmo2WWF6S1dxTTZUZStTV2N5RE5lN1JHYmdvbEZqaFIvMXN4TDBHN25H?=
 =?utf-8?B?YlZsblZwUjZaMHhkeTBaYStiL2VEM0J3V0NYQ0ZiV2xUY2FaU2VmRm1PSzFt?=
 =?utf-8?B?dzRnbWdFbWJZOTRrUEtyYkpIbExIeGhQaTZzRS9kVG9ZSVU1VnBpMmlLWERG?=
 =?utf-8?B?RERPTzVaSStZYXNtQjNjV1BOWHgyYmxQOHZaa1MwNTFwSlpGbzF6M0tUb25N?=
 =?utf-8?B?Z1JXem42ZWx3emJRZDZYN0NOVmx6alNYYmVaM3V1VWova3ZWMHN3TjlyUzRo?=
 =?utf-8?B?RDZVbkxIbmZEYndEOUMyUjV4YlZwaHBXMUd2dG5FMStzaHpDYXFBK3B6VUll?=
 =?utf-8?B?c3JwbVREYlhMSnkyQzBobXdtamxUbkhCdm5XZDVXNnpDTFhaSVhOS2ZQTDlQ?=
 =?utf-8?B?MUkxYWsyd2lVaWFDVk1xQkMwV2pVb21RbTNRR2padGZMMnpSZmhkREdqSGlY?=
 =?utf-8?B?SmRDakFBbmk5dk04V3BBTERrOXBLS2gvNElJd3dIMkdvbWJOTHduekluZlh1?=
 =?utf-8?B?NVQxMUk0MnhZVUpHa0RxUWJPOUZhSDdaRWtPWnBYUWZOVC9pa3BrdXNUbm1V?=
 =?utf-8?B?SDE1SmdSanFuc3YzK2hadFgwK01NS2I0eEZxTFpxVVZuU2x0L0Z6OGpZZE4v?=
 =?utf-8?B?R29EWjlmNmlGTEhKTzc3R3IyL1pQYi8vZUI5bVlwYnZlYU1zRC9ONTFOV3ow?=
 =?utf-8?B?UXNHOVpUZ0ZvNTdSN2trM3J6eHVqZkVsNGRGeFZKZVFBV0tOSThCQjdyenRK?=
 =?utf-8?B?dmhHUVd6dVdRVUdZRGFyK3Ziam5keWlFMEkvZWRkQ2JRZE96UHBjNyt4eVBp?=
 =?utf-8?B?YWt4b3F5Tnl1T2I4YzFLeW15c0FNM2pOOStvNktHczdaa0pxZVQyckJVNStO?=
 =?utf-8?Q?obVyemxNAMYzHIb5Q1I3m6HFn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e92e8df-7aa1-4a08-b12f-08dd562d0b95
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2025 06:16:02.7835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqaSDisLdnyO0bALeAVdY7VlPhlX05O7w4BTFR1rauZZuH7KEQkYzOfGFfHKwR4Ybk+Qpf6/XTMYnDXeDedfnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9051

Hi Sean,

On 24-Feb-25 11:43 PM, Sean Christopherson wrote:
> Manually zero DEBUGCTL prior to VMRUN if the host's value is non-zero and
> LBR virtualization is disabled, as hardware only context switches DEBUGCTL
> if LBR virtualization is fully enabled.  Running the guest with the host's
> value has likely been mildly problematic for quite some time, e.g. it will
> result in undesirable behavior if host is running with BTF=1.
> 
> But the bug became fatal with the introduction of Bus Lock Trap ("Detect"
> in kernel paralance) support for AMD (commit 408eb7417a92
> ("x86/bus_lock: Add support for AMD")), as a bus lock in the guest will
> trigger an unexpected #DB.
> 
> Note, suppressing the bus lock #DB, i.e. simply resuming the guest without
> injecting a #DB, is not an option.  It wouldn't address the general issue
> with DEBUGCTL, e.g. for things like BTF, and there are other guest-visible
> side effects if BusLockTrap is left enabled.
> 
> If BusLockTrap is disabled, then DR6.BLD is reserved-to-1; any attempts to
> clear it by software are ignored.  But if BusLockTrap is enabled, software
> can clear DR6.BLD:
> 
>   Software enables bus lock trap by setting DebugCtl MSR[BLCKDB] (bit 2)
>   to 1.  When bus lock trap is enabled, ... The processor indicates that
>   this #DB was caused by a bus lock by clearing DR6[BLD] (bit 11).  DR6[11]
>   previously had been defined to be always 1.
> 
> and clearing DR6.BLD is "sticky" in that it's not set (i.e. lowered) by
> other #DBs:
> 
>   All other #DB exceptions leave DR6[BLD] unmodified
> 
> E.g. leaving BusLockTrap enable can confuse a legacy guest that writes '0'
> to reset DR6.

What if guest sets DEBUGCTL[BusLockTrapEn] and runs an application which
causes a bus lock? Guest will receive #DB due to bus lock, even though
guest CPUID says BusLockTrap isn't supported. Should KVM prevent guest
to write to DEBUGCTL[BusLockTrapEn]? Something like:

---
@@ -3168,6 +3168,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
+		if ((data & DEBUGCTLMSR_BUS_LOCK_DETECT) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+			return 1;
+
 		svm_get_lbr_vmcb(svm)->save.dbgctl = data;
 		svm_update_lbrv(vcpu);
 		break;
---

Thanks,
Ravi

