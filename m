Return-Path: <kvm+bounces-70025-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLw0ElAmgmnPPgMAu9opvQ
	(envelope-from <kvm+bounces-70025-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 17:46:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4F3DC311
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 17:46:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E272830BA578
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 16:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577163D3309;
	Tue,  3 Feb 2026 16:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="326smv3s"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012048.outbound.protection.outlook.com [52.101.43.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A6A2C0F69;
	Tue,  3 Feb 2026 16:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136728; cv=fail; b=M+lDK2ZE11J6pFS2DBdpKgTXctyP6ksvMyZBhtHQG+47xX+M/8ovsQXqX4CAjAW0wvVTETeDv5ZxdvHgSliByGa67JHni55wqEZv011cFQn4gNgwXPIrjC53AC7qqzMybIu2YFaS5tExTRYtZxS8oYRqPyIlvRvyivhGTdxeYQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136728; c=relaxed/simple;
	bh=G+6Kv3Dds35uLNAefsiBVljRSoIzw7b1QlJjjrJEZes=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l+n40Zkuzx3uuQNoIJpwKwqK76OSx9tLVyW31gilhpfveh0mXACxqr7HFb1Qy8YdTqqUfwTv1DY6kLQ28oEu+Rz5mdpg9oeXV1wHx0c+7aoxTkpmHqQTAzrNtJR6k1AnWf2eR08+gBqKH29LLFwOFL18UhPaJuPSqZYT8XSgb2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=326smv3s; arc=fail smtp.client-ip=52.101.43.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ck+JfAU+T+Fv3C0spG7emLLTWcJcKLm2YHRf9IaeBMQb8Je7t8zQbzA7altJnucpsVrMFF6ZPJ8MOrVF1cNpXMnlzSiK+D824VFdOq7mSyU6irpgWf/5xPoV/PuDcGH/nvCXNKdOdG60rMhD3C9zuTNY+6NkxYr8nqCl49YwusT0tdazl9l2hQSszSbuqoAgiAsmnXojhyMiomoccvhe0thx/neDzfC3SOYk2cJbhIGoOr3FJU1TQzi1jqMb+ztvr89T9nh4qdeIzDRUngrk7N4Gau/hJnBBBMaqVab7rQ1qPWqBCfL3XX4ZixQUDB6MnZbBsREl3Cjgy6eGpvduSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJkhpFQuYk+h9CjwwHIt/GVVMo9JtZB5Eo0SlNI3598=;
 b=rk0W/CTXCQq5Dd68MwLg8osAUko38gBjzMaUSJWC1TezBoBnrUhNO0QLB5DvQtAk4f81QzkoU7iUi46p5i9t0Wlo2wH+SVFOEK4/pCBr8OZraWeIJnLXNFSBCq7Hq8ZFq16EV5yS6qLcHj34J2ke+haCBZs4udbec3f7mtV9DyrENo51NpSHuH0vgqWfIzC0/B2X4Ckyj18xcEz9V+sgDjVGjH6+nrk8ubYOsoS1H6fax31QqG//8VQHcTMpSfxKH/irhtsoG4SXgk8khisXHlYRLOlLv7S4M4Ye4ymSZLlHF0NfMRQeIKUjbzG4HrXsFF+f/BYlRt/S1wNNcjc72w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJkhpFQuYk+h9CjwwHIt/GVVMo9JtZB5Eo0SlNI3598=;
 b=326smv3s4sq/JmXlLXFc4Stqq54BlGo5fRuGMIzyFCu8I7gYavt0hSJc6Jt40/yhetHXEra6czOMkhPxoh1/OYAKulE6ibA4QH6em/cRfDhfvZeKrXJDHNZLDNXhVEcVPGDdmiu5/hHnRj4QM5Rq5KroKKCbTiiKPjjbeNA4lJ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by DS4PR12MB9563.namprd12.prod.outlook.com
 (2603:10b6:8:282::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 16:38:39 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 16:38:39 +0000
Message-ID: <e0c79c53-489d-47bf-89b9-f1bb709316c6@amd.com>
Date: Tue, 3 Feb 2026 10:38:35 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/19] fs/resctrl: Add the documentation for Global
 Memory Bandwidth Allocation
To: "Luck, Tony" <tony.luck@intel.com>, Babu Moger <babu.moger@amd.com>
Cc: corbet@lwn.net, reinette.chatre@intel.com, Dave.Martin@arm.com,
 james.morse@arm.com, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, akpm@linux-foundation.org,
 pawan.kumar.gupta@linux.intel.com, pmladek@suse.com,
 feng.tang@linux.alibaba.com, kees@kernel.org, arnd@arndb.de,
 fvdl@google.com, lirongqing@baidu.com, bhelgaas@google.com,
 seanjc@google.com, xin@zytor.com, manali.shukla@amd.com,
 dapeng1.mi@linux.intel.com, chang.seok.bae@intel.com,
 mario.limonciello@amd.com, naveen@kernel.org, elena.reshetova@intel.com,
 thomas.lendacky@amd.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, peternewman@google.com,
 eranian@google.com, gautham.shenoy@amd.com
References: <cover.1769029977.git.babu.moger@amd.com>
 <d58f70592a4ce89e744e7378e49d5a36be3fd05e.1769029977.git.babu.moger@amd.com>
 <aYE6mhsx6OQqeXG4@agluck-desk3>
Content-Language: en-US
From: Babu Moger <bmoger@amd.com>
In-Reply-To: <aYE6mhsx6OQqeXG4@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::9) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|DS4PR12MB9563:EE_
X-MS-Office365-Filtering-Correlation-Id: c1a79072-0a3e-4d20-7eb9-08de6342af06
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VG1jc0ZLUS9DalBNQStBUjJCQVhSeGRxRWtYQnkrazVtMnE2bTFVbFJvYWIv?=
 =?utf-8?B?M1dZTmlwWlpwbEJyeXNRbWx4MjgwZU1FdkticDZ0Z2Jmdi9DS1hnMk5tMHJN?=
 =?utf-8?B?a01rUXl5Tk9udjVzRG5ka2pEZWxKeEZrUW9yNnltRzhZUXVmYS90UnNMTGY1?=
 =?utf-8?B?K1lWTmJ0TCtyQUJ0ZW16clB1STdPOTlKTDFGWWtlMTc2QXY4cXN6QS9uNkxp?=
 =?utf-8?B?eEF4cU5rR3M2MGZzQ3BkM00xNkVuMzBDajMrdkFZNFVIaTZFS2w4Y2hEL3Bu?=
 =?utf-8?B?ZDNKV0M2NFJjenNnTzEycjNtT2VjZjR0cndma0ZTZ2ZPcHlzNkJjamNpMEhk?=
 =?utf-8?B?cFVORllkb2tiS1ZzTWJhYi9nWmdvd2N2dTFZOFczOTF0TzVlL1g2TjJhYkll?=
 =?utf-8?B?alZjNklucmxXN2doRld6clZPRmdQMnZkalhnREdrTy85eFVHeEhVTWtIUTM3?=
 =?utf-8?B?ejVYdE5BUU14YmtCclFLeTJZNjIwN1JPWlFQVGk3YmJxRThZSnFsR1hGT0R2?=
 =?utf-8?B?UkE1OW1RcTV4TXFPaW1teUxOQWdjNmFEUkw0eHpoaHJvVmh2cFdxTjF2cGh4?=
 =?utf-8?B?ZzVGQnI0TDNxaTZNRWc4Q2d6VzlPakdvMmo1dkVoNmpFdEs3VjNnZXBVYUxo?=
 =?utf-8?B?K0pGSzBJb3BEN21DTnA3UFY4L2dEL2pRMGxmTGcrcGx2bHNIcVBhTkxXRm92?=
 =?utf-8?B?aDY0bGRlNFRrSy96YkgwdnMxZDFSdU11VmppYUwwcDRBalZNWWxidThIN0ZQ?=
 =?utf-8?B?ek05Smc0d1Z6M0dKb1dIYmtnM0JhT2o2dlE2ZVlzTy9zdEhrMGVwWHdSMzdo?=
 =?utf-8?B?TWlnTmViRW5HV3M5aStxL2tnYlpRS2l1WHlCSXlTNnBwYzRrL2ZkeXhhTTZQ?=
 =?utf-8?B?eTMydXloc0FaTlY1ZUgrNUhFOHB6eG41Y0VFTFg0SXZVY3k2STNHelRpRTgz?=
 =?utf-8?B?RHE3OVM3VE9XbldjY0ZmOXNBSVp5UjRZR0NxOXRNaGQyV2N1bWVrazdFTGkx?=
 =?utf-8?B?Qlp2a1JQVmEzcCs3R1oxem5ZSmp6c3FQQmoyVkJhbkRTUnQ3SzNZWDU2OFEz?=
 =?utf-8?B?RGZjdWl1MlZ5a21CdThoOVdNNUExOU9wR29XczB5bzFCOGROS3liTGFMN2t0?=
 =?utf-8?B?YXIrU1pVUzg4TXhpK0JRM3E0cVBmMit0YXpYeEM3TVduNS90NVVaVmx4d1VG?=
 =?utf-8?B?dkl1OWJCR21rMlNmaklZWnZvWnhDdEhmWS9mcUx5Q3BrMG1PZjBsR28zMW5o?=
 =?utf-8?B?VVBvMjBkb1F2VnhKZkJKUUhvdUJCL01oZDFBa2ZkSmx5U0UxeXpFdVk3RkhL?=
 =?utf-8?B?MFZFTjYvVDVtcXBvRjJrQ3ZBM05OVW9taFZJVUxoSVRkbnEyazVLL2FUN2sw?=
 =?utf-8?B?eE9kcjlnV0p4SHZTUncraE91RDhVa1JEWUVEWXA1TGFrRmV1ZjhqeTdwWXRP?=
 =?utf-8?B?QjQ2M24wS0Z4blpHV1JXR1l0eUpHNG9kV1VCQS9NbytMYm14cjI4QUFLb3NO?=
 =?utf-8?B?OUhlNzZwWmp4cEtkdnVMeUlGQnM3dlZPZDBJVlhzaGJaNVBaRVdDQUFQZVFq?=
 =?utf-8?B?dFdtU0M3RjJzTFNRelZpcFFwYUtNREF6MUNHQjhzVExOWmRpUENrQXpNTkVR?=
 =?utf-8?B?VWNsb0hnWG93c1RIcHdEWXdNRlJoV2NGcWxCYUlZQkUydkRqZXY0UmozdzMw?=
 =?utf-8?B?NGk3YVZZSVJ5YmhNYUJCL3N0RmJiOGVtNDd3UURaanlFaEM3M2VPUnV6VmRF?=
 =?utf-8?B?QVlQdkJlRjNmc093WVc1ZTZUbXpJQ3Z0SXd3VGZQZDR5VWJiNHozYVJ2RVV5?=
 =?utf-8?B?bmc3T0dKbVNDVmI3TC9JVmg0SGc4MmhYR29DaW5nTFV0ZXgvQzM2SDgzT09h?=
 =?utf-8?B?QURmSWpUa0YrVitHazdvM1R4Z3lUalk2Ym10TnkwRnZ6eGhZVmp5aTFrbGtW?=
 =?utf-8?B?VnpIWEcwOEY3bmgxa3pvQk5KMWwrblhobXNXNCtESkFWenFyODdVVkJ1UkU0?=
 =?utf-8?B?bzcrOGtnQzYzMlVhSGV0bmlkMDJ5TlVVZkZIdG5oeTBUcFkwODJ4ZDkyZGNs?=
 =?utf-8?B?ZFZpMHJsa2MvY0o1OXoxMGtuN2VCNXg0WjZ0ZWRGMFk2RUtSSDZWdW84OTJn?=
 =?utf-8?Q?OFpY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2JTQ2gzSXpKSWlDemduTU1yMnd5L2dZTDJGNXBCa2N1NHNFVzdSamN4WjM5?=
 =?utf-8?B?M3krUHBzQmNZdWZwNnVpaG5LenJtWXF3WnFKOFlnQWd2UWtweWZaYk40bUQ3?=
 =?utf-8?B?Mm5IRTd0RGFRaFhzbU9LMWVXNTBZRnQ0dUhTcFNuWHJXMUxBRGxFV0hqZ1g5?=
 =?utf-8?B?S3k4dmVIQjY5VnZsMmI5M2tJL1J1N1I3Z0JYSVlObC85Z1lRMGZNZ1Zob3BH?=
 =?utf-8?B?cHNvMTI1b2h2SG1uRjA0ZDRnak5Md3NWQ2E1WXVhYmtJVFVlbkJIZ1EyVVlq?=
 =?utf-8?B?THp2ZUZrVGJleEhmUFEwVlh4VWE2ZVdlaDdOUXcvUzJtZ3RsZ3RQRGJ3Y1pv?=
 =?utf-8?B?NStLOUhzODVtaDlZd1FWcmk2TzZuNzlFWUNxd0hkdHY2QWkvUWlXKzFwOW9h?=
 =?utf-8?B?RUE2WWEyN2p2YnNNQlZrcCtnTUc5MXlJWGlPR21OUUZsb1JkOXVVZ2dHaTlv?=
 =?utf-8?B?N2N5eVlwRDBsZ0tHV3VieldYS3NjYnZHRlpBU3ZzdmlGcEo1Vzcxb3UxejRO?=
 =?utf-8?B?MldETHNLb3J2dGs5VEc2YmNndTkyMitRaHlOSjhVdW5nWWJGdEdiVWZKZ1Fj?=
 =?utf-8?B?VXhIZjF6T0xVYzl3WitPSDNBZVA2Zko4TkVVeEtnWm5VS1BNR1FVamUzNHRh?=
 =?utf-8?B?d1V0QU1WcGJNdTRadmJvaWlxY1Urekg3VXBYREFGY0hORGdCSitCamN2R0FG?=
 =?utf-8?B?SkUwZEpXWUtTa2hmNGtVUmdBV3p0Nk5tb00zMEpVSnI5RU5WbXQvakNGa21Q?=
 =?utf-8?B?WkEzSnJGQ3dwNEJaK3hzdUVmMmVaL2QwU0UvU2d2VGI3TzAyaVB3SEhDV1Vl?=
 =?utf-8?B?anhtTkRUV0wvRTltNndxRHREdkE5MU10SE04aFVKUUMyZzhnZnlVdGVpQjlN?=
 =?utf-8?B?cmhrY2NDdWlaZS8zc2tpaXQ2L1JNMElCVkpGR0dBcXdkRTBFYjNzRUJLcHh2?=
 =?utf-8?B?b3UxWHpIMS9OMksyZkVzcUlkRVE1Q2tjbnNhMHRuN0t6WlRhUFpRdXpvL2tr?=
 =?utf-8?B?VmIzay81T1JTV1ZyYzd2NWhWbEZjWGx3QUN0ZlhOU24zQ1dMSnlWTDVJVGdU?=
 =?utf-8?B?b210RmVUajBURjNKajgzL0ZDK0VZSzZndXZibkhYb3podmZqZ3FuTnh5SCtm?=
 =?utf-8?B?K3JueUxuamJ1dEdpMFpLcHVtL0JBTVoyTU9ycjRJdVRtRmpUSE5PcXhQK3Jz?=
 =?utf-8?B?VWtCSDU1NWFiS2VpQk9uUGhKbmxsRk1rN3VSN3NzTWFjZkhyQmR1R3BqSjkv?=
 =?utf-8?B?dmhJYXEvak13dlNyZlkwUk9kaCtyQWkwN056U0NRN2FCOWlLRThtcTZBV0dL?=
 =?utf-8?B?UkxhbENsTGFJeGpRUXVkOHU3bWZRWWZ3SXRnODVyeVRLNXFHSHZpdFZhQy9r?=
 =?utf-8?B?RnV3UzBVUnRkRXFlWi9zQ2ZEL1ZtMmxGbCtZZ25xelhvYkxVQ2pFNTE5MUx1?=
 =?utf-8?B?TklnektXamN4d2RadVM3ODZyRUR2NkJrYlBVa1lLb2tRM1ExbGhvK2p5aE9p?=
 =?utf-8?B?RmtOTUM5UndZUDBDeHFreFRzWG5YdkpUTG4vYU12WWZyS1IxbksvNjByZ3ZO?=
 =?utf-8?B?NEhoOC9PWDQzdzR4YXVKblZlZ01kSEdnNWlvYnhHTlo3dndDWmZFczNlNmQv?=
 =?utf-8?B?WjZRVGZGb3hocU4zL041cGQ3bnRoTEMyMmxSejlsYVV5TjF6Zkhtemp0Y1RK?=
 =?utf-8?B?Z3ZaNEFVaDVwQTlla1hJbUJwaStuVmVTcVpMU21MT0hxdHMyUW9WU0dSS1NM?=
 =?utf-8?B?clM4MVlSY2ZIVWxVUDdVNUsvcXh5Tk5tcDR3T1NXTnpCb016anZ1RElSb0VJ?=
 =?utf-8?B?YnVYNmN3NG1pWFpMeUVjcXJFV3ZvNDJzYURRWW5DK0wyaWJJSG5EdzdjUFFC?=
 =?utf-8?B?MUtIRmlYOGVMYUpQU2t4ZURsMTJSWXhremVDb2NzK0t5WUVMb2RjS2liWC9K?=
 =?utf-8?B?ZkpkaFdiNnBrTjhTbzVQYUttc1lPTHlONEE1bFUrVTB3Vnc0QWkxNXVvSkFO?=
 =?utf-8?B?RVl1dmNZdHFGSngwaGZUQ0xTS096KzRRdUtoYmZmTmlqdlR4NGNOQWJIRlF1?=
 =?utf-8?B?S2dzaXF1b0xIdm45Z0xNdTFXU1hWNkZROGFaazY4UXhJdEkwbDhPeXVWVktm?=
 =?utf-8?B?dmdrTThuVEZtcU9QQkh0MTFzN0E5R0NLK24zd2VrSUJvdDZwZFlUSStOZE5i?=
 =?utf-8?B?U1FKdkdNL25RcEVHZzFxYjRKK1ZUL2NiSW5UUFlVbFJ5S05saGRiYm9CUGxS?=
 =?utf-8?B?VWJRSzQxQ3ZzdTQyc2pHdEkrOTBEaTBCTTV2WE81VnNwdFZ4RW5BVEFZckhq?=
 =?utf-8?Q?fk3j48Icj2plebsEpM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a79072-0a3e-4d20-7eb9-08de6342af06
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 16:38:39.0583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dimdKhr3XpmFi8IXPUfXDEgdRQEAAIHXpeqgBwC2j2N+DBoiJpjTVOybU8D5KV3x
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9563
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_FROM(0.00)[bounces-70025-lists,kvm=lfdr.de];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: BF4F3DC311
X-Rspamd-Action: no action

Hi Tony,

On 2/2/26 18:00, Luck, Tony wrote:
> On Wed, Jan 21, 2026 at 03:12:42PM -0600, Babu Moger wrote:
>> +Global Memory bandwidth Allocation
>> +-----------------------------------
>> +
>> +AMD hardware supports Global Memory Bandwidth Allocation (GMBA) provides
>> +a mechanism for software to specify bandwidth limits for groups of threads
>> +that span across multiple QoS domains. This collection of QOS domains is
>> +referred to as GMBA control domain. The GMBA control domain is created by
>> +setting the same GMBA limits in one or more QoS domains. Setting the default
>> +max_bandwidth excludes the QoS domain from being part of GMBA control domain.
> I don't see any checks that the user sets the *SAME* GMBA limits.
>
> What happens if the user ignores the dosumentation and sets different
> limits?

Good point. Adding checks could be challenging when users update each 
schema individually with different values. We don't know which one value 
is the one he is intending to keep.

> ... snip ...
>
> +  # cat schemata
> +    GMB:0=2048;1=2048;2=2048;3=2048
> +     MB:0=4096;1=4096;2=4096;3=4096
> +     L3:0=ffff;1=ffff;2=ffff;3=ffff
> +
> +  # echo "GMB:0=8;2=8" > schemata
> +  # cat schemata
> +    GMB:0=   8;1=2048;2=   8;3=2048
> +     MB:0=4096;1=4096;2=4096;3=4096
> +     L3:0=ffff;1=ffff;2=ffff;3=ffff
>
> Can the user go on to set:
>
>     # echo "GMB:1=10;3=10" > schemata
>
> and have domains 0 & 2 with a combined 8GB limit,
> while domains 1 & 3 run with a combined 10GB limit?
> Or is there a single "GMBA domain"?

In that case, it  is still treated as a single GMBA domain, but the 
behavior becomes unpredictable. The hardware expert mentioned that it 
will default to the lowest value among all inputs in this case, 8GB.


> Will using "2048" as the "this domain isn't limited
> by GMBA" value come back to haunt you when some
> system has much more than 2TB bandwidth to divide up?

It is actually 4096 (4TB). I made a mistake in the example.  I am 
assuming it may not an issue in the current generation.

It is expected to go up in next generation.

GMB:0=4096;1=4096;2=4096;3=4096;
    MB:0=8192;1=8192;2=8192;3=8192;
     L3:0=ffff;1=ffff;2=ffff;3=ffff


>
> Should resctrl have a non-numeric "unlimited" value
> in the schemata file for this?

The value 4096 corresponds to 12th bit set.  It is called U-bit. If the 
U bit is set then that domain is not part of the GMBA domain.

I was thinking of displaying the "U" in those cases.  It may be good 
idea to do something like this.

GMB:0=      8;1=      U;2=     8 ;3=      U;
    MB:0=8192;1=8192;2=8192;3=8192;
     L3:0=ffff;1=ffff;2=ffff;3=ffff


>
> The "mba_MBps" feature used U32_MAX as the unlimited
> value. But it looks somewhat ugly in the schemata
> file:
Yes, I agree. Non-numeric would have been better.

Thanks

Babu



