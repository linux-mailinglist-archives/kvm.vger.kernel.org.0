Return-Path: <kvm+bounces-71138-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCflGNafk2lf7AEAu9opvQ
	(envelope-from <kvm+bounces-71138-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 23:53:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A31C147F99
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 23:53:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 75EB1301D309
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 22:52:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 558D32D8378;
	Mon, 16 Feb 2026 22:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GxfmdVGX"
X-Original-To: kvm@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011050.outbound.protection.outlook.com [52.101.52.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC5023BD06;
	Mon, 16 Feb 2026 22:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771282376; cv=fail; b=Bth1t4q0mQKP7leAe/u0PGtdENvDVc4J4BoBRDRmoaVdRa8+NGzfRoLVMXScxWhJBE4saif3ysyLbhUQG8uk5deg9hWibqq45VPlBk4OLFTSGOzMctIQIsiTdCzKjt8h9a8IHuioKraJIZBSiFNF6G1VyZgEEzO4QqdwYeWhBNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771282376; c=relaxed/simple;
	bh=ZpRBCnSlyL8F6lmT82fCmeNhV7BH2H4sXyGB+7MqbjM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R4UR+MYKILC5Hy9AnkVeyNwM4XF0jVNyaPn6Q8ypbIxBqX5L9apFRwt0B1FSelEBaL641IH9gWY5x0Bb/uxBNVJbNrNig24l0QqYQtMylQL8M9i6Qpa2BJDDKUAy0vuLm+WT839+ZE/AXM9ioGKTxyX6GfF8RB2jQtLhf8WkCs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GxfmdVGX; arc=fail smtp.client-ip=52.101.52.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGYj/CAcGFtd8J1gGYGFJtez5wIsThalWwORWcW5fSEVldN7tr+sxdN9b1uuaqWuoX6PfZ1nmM62MhKMayO79h5zKhK4Ns8cWXznHxnCQhReHRc8IYCzVzC8jR7+5o+42y1guxiz9Alitv/roxIrFyYElJjWkfqjzQkDxjJOBiaOQlBpDb5gb0dWzIIKqvf34+DCSCemkqm2k2RX5XD6HW/CUIaiiMi+PCC5W9beSQ4RXCqBS2e/JKkj9P9ibVePHcMgEKKilTQA3eN8jzoGAlk34WWJ9XfNn/YpDLYNdYCQlyg9fo5Sp7t9z2HHRShOlOyt1sLwM9JYCuTjA5laRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqzkryIyFMEoEpXUyqEMWVyI+6HsXlfgfeTe4tQ96jo=;
 b=q21SgeE2EwOOtLpcJo+GM4HvO1vAizp6f7XTXtvff4zxeqtgN3QAumM+BHdNLZOG/CU1ng8X+Rk7/0+1HEoQFd0iICXdmMtTkO6/MmYISHANbEUsPPiDQyO23Lq4ZfTtyr4hh5lt0NNHMS75twjLcLjyscjZ1Nf7r68l1ftB1yhJiALf/hQYy+FvdpBlANce+ZnM14yMc0xTj9cEtkkPLldBGZAggAbnO19smr21H0hXPH7QCP4EcPYkE2ABrh6AEuu2bagRhbmlgPbbw7yIzdxENgk9SE8IqFIfYNZ82iPDSosMqGQM6UQBIWNslo0cs79Yo8qXCYeOudGbthR95w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqzkryIyFMEoEpXUyqEMWVyI+6HsXlfgfeTe4tQ96jo=;
 b=GxfmdVGXqy/10w8ZMrmdlZZ6+q9huUbpMctDj5pw1m8+ON4/g9AbflMsnlORFk1MCZq0Fd0RwTyhploTTHMhfAy0fssCQTXfwTouRVeZnYCLCkPzCz/8PjpNRnThggfrNqm1zKAne2F+rYC29n8DRy7jfDDn0QP3/+FWcQE7jpw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by CH3PR12MB9393.namprd12.prod.outlook.com
 (2603:10b6:610:1c5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 22:52:50 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Mon, 16 Feb 2026
 22:52:50 +0000
Message-ID: <fbaa21b3-d010-4b89-8e87-f13d3f176ea3@amd.com>
Date: Mon, 16 Feb 2026 16:52:44 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: Ben Horgan <ben.horgan@arm.com>,
 Reinette Chatre <reinette.chatre@intel.com>, "Moger, Babu"
 <Babu.Moger@amd.com>, "Luck, Tony" <tony.luck@intel.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
 "james.morse@arm.com" <james.morse@arm.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
 <mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
 "kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
 "fvdl@google.com" <fvdl@google.com>,
 "lirongqing@baidu.com" <lirongqing@baidu.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "Shukla, Manali" <Manali.Shukla@amd.com>,
 "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
 "chang.seok.bae@intel.com" <chang.seok.bae@intel.com>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "naveen@kernel.org" <naveen@kernel.org>,
 "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "eranian@google.com" <eranian@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
 <1a0a7306-f833-45a8-8f2b-c6d2e8b98ff5@intel.com>
 <fd7e0779-7e29-461d-adb6-0568a81ec59e@arm.com>
Content-Language: en-US
From: "Moger, Babu" <bmoger@amd.com>
In-Reply-To: <fd7e0779-7e29-461d-adb6-0568a81ec59e@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1ef::11) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|CH3PR12MB9393:EE_
X-MS-Office365-Filtering-Correlation-Id: f39e16a9-3990-4a1a-0e7e-08de6dae1c8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|19052099003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0lEV0ZyWUl0UmlkWmk0VkxHdEkvTENhdGdZR1ZKRXlkUlN4NmVlbVFKWGR0?=
 =?utf-8?B?VVp6WUNZWlRPQ3RBTjlEQlVOenFLNnRKQmZRVWdXNlhtczZVcUxwZHBoZk5n?=
 =?utf-8?B?ekUvMjZkUG8rNG91WjJrbDhqNEJxbWNHL0pHMkZBYk9mcjJ4ZlhxeC9JdThn?=
 =?utf-8?B?OS9qMExrcE96WG8vN0lMVnNDUlFXTUxwOU9TSWJxUEg2eVhCS1paUHQyd0p3?=
 =?utf-8?B?QzFURWt4bGszUkR1V3RHeUp0bEI5c29BL3p5SGgwbkhNNXhKWFhQcG5nSkNu?=
 =?utf-8?B?TnVBMUwwT0Joc1VYbHZyc0hjRk04MVN3VzYrVmlGN04vUVp5TzBFUFJhTTdI?=
 =?utf-8?B?aWtWNGhucWx4bUpQTVVhL2JDZ1VrUlFJMjV6S1gxaExoUWhzaWw1TWo3OWZq?=
 =?utf-8?B?NHJ3ekFXejdBKzVlM2ttU1NCVXBmdzFFZXlpSytRL2ViUDVYZ1NKajdLZE02?=
 =?utf-8?B?TE5RV3JpODRndTVtY1VuS2pIeklRV2dIZFZvMFprZHVndTJIODNLRVJITC9p?=
 =?utf-8?B?ZHFSNWoxUS9Xai9TT3N6QmFJQlF0VndFYXFSTnJMdUVYUC9WSlp3TlFxQjd3?=
 =?utf-8?B?OWxrYXl4eC9RMzJwMmxjQzgzazltSHF5Z1dabmp5VmhmK21Vc2JqRHh2QU5u?=
 =?utf-8?B?RWdMV3JJZEFHZXVUOXJjZHY0ODN1NnFsaVB1TitkQlJDRGcvK3JpempEODZO?=
 =?utf-8?B?Q0l1bHZRTURVWi9qVEpiYW84b2JJcWs3WkNMUUtURjZxY2xwYUdVZGhyUnpN?=
 =?utf-8?B?NVZNeTJCRCtmdjM0czVvN2FMRVNQcmdiTFo5d1hmRERmRXg3L1NrQlJkR2Vo?=
 =?utf-8?B?ZmRpUk9sdmpMSDhYY2Z6aFJLM21zNGErNk5TdjBENnpLaUlWVHNLT3lUSkR5?=
 =?utf-8?B?dlNzT1V6Nmw1aXVtZE9yWENENU1oaFNmWmN6WlZqRG5IaWpIbUVIekJjcUQ4?=
 =?utf-8?B?ZGNGNGVoaER0bUhtSEFyWkE5YklwRVNiUjlrSkFpU1dGa29ZczV6Y0ZwcENa?=
 =?utf-8?B?NEpiSlhYenhHYnpsc0hxS3FWR1dWeDR6cGxxQ1pQUXFhVW81bzFNdXI2VXJm?=
 =?utf-8?B?WlVTdlhvK1gxVEl4ejltTXZadkVSVXM0M2VWUStkaU04eVMvaTRmOGdNRFl0?=
 =?utf-8?B?RXd4dEwrMlBHY1djcUorSFlVUm9ha0tUUFl0ZjdkRk5CUnVhbW13UE8vTnYw?=
 =?utf-8?B?eU1zbjhiTmNkQm4zc3VGNFRlUGlZY3VUNEhjZW5xTDVpWTFJZ3ZzbXJjUFdS?=
 =?utf-8?B?RjNsM0dTYjIrTDkzSjN6anF1dVFPOEczN2dTVFhITjVodS9DRVVHSVdFZ0Fj?=
 =?utf-8?B?Ni9kSjRtMFFPZEZYSUhCRG1SV09SdTlLcTZBS2tVL0VsQWpLeEQ1YkZFNk9P?=
 =?utf-8?B?enVMOEtDSThBMnZPOVh5QWR0UlBFd3dkdi9YeGQzMkhocW84MEkxL1gxeU5u?=
 =?utf-8?B?Ti8yZnFUSXZVL0xNcm1UTHRaVGd4aXRkVjlaeGdzWGo2RjZyaDhIZkdCRGor?=
 =?utf-8?B?Y2Q4RWcyYll2Y1k5YzVLdkFSQW0xOFpWNDNjc1BpTndJcVBxV2IyMHlYS1NY?=
 =?utf-8?B?WDI3UlRrKytwYlljem0xeXpqdUxidDByTXlHdnRIS0l2ZjdOWjk3ZUw1Mmlx?=
 =?utf-8?B?R0ovb2J1bHZGTnpubWlUNVIzOU91eFMyYVJhOFNSdUQzVEt4U2E2WWtiSDRC?=
 =?utf-8?B?S1ZDN25tc3FWNDJDdHk3M0pFN0VlNVl1ME1URVFTcVNmemI2TFkrS3IxR2Fv?=
 =?utf-8?B?QTNVbXA1Q21iS044ZGVWa3RPcG1yTGpzV1NiM0N1eE9qY2hTbWxObCt0Mmdy?=
 =?utf-8?B?SkN3VnNkSlJxRFFIWW51aDhzd0twVjZxdjg2UHNpZWxNeWRmVURGR0ZheHhQ?=
 =?utf-8?B?eWNZZ3lnWWJIZWV4SDhHdG5TUzV3dXprcUpuYUl5cUJVL2xINmw5SDdlNWhj?=
 =?utf-8?B?NDhvdzBPbFV0ZUVrdVVibkdoc3JhSHI2S24wUVBndzlodStnckNpbDVaOGho?=
 =?utf-8?B?MVJhbk1uUWxtT0gzSllTMXBnQVp1NVNzUllZdTdBSHFVTVhwUU9YREJsNGxp?=
 =?utf-8?B?NHpBdFpaUENLSS9vRzJKaVdFTGNYQ3FpVG04S250NE5PT1VqM1Zxc3NZNWNm?=
 =?utf-8?Q?M/oQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(19052099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alZuUE1TSjZYNXZubFAwSlRreXZkTmNkblljVnlEb2x1SkdVYmI1VWlyWitn?=
 =?utf-8?B?N3pzN2ZIV0JzVzhxVzIvRU9DSWo3TGxlLzlqWDc2VlVRSXJoOHpMTmQzRTR0?=
 =?utf-8?B?T3FtMWthc2l6WTU1TjkrV1BoREg3L3YxdCs2N2lmWG1qYldKWjZiMWhaK0ts?=
 =?utf-8?B?cUVGbU1qM3J0UTZxdFhXT3hLbWh4c2cwVjd1Q0JiS1ptRzNWS3k5UHE5c1pW?=
 =?utf-8?B?aFg1a1AxOUlZNlpVMndCTzI3eEhnVmt2amZJYlYzZlF0amJXU2IwejZURHpr?=
 =?utf-8?B?OHdkUzU2cVVTU1o5cE0waU55VmtSWnNadTFYMnBweVVMTi96b1JhN1FtUmZp?=
 =?utf-8?B?dTNGMHozS3lSTDhaSnZ3S3ZzUVNuZDVIUktuQWtiSURIU2NLa25PV1ZNSlk4?=
 =?utf-8?B?M0o1NWdKclA3TXJEenkrdEExM2NQcHFHaFl5ZlRnelFJc083VTJlckFVeHJO?=
 =?utf-8?B?RFhPSlh5Z3loOWQxWTIvZzVpcmtyU0pWNEErNkNVTjV3ZXdjYytyZzV3OHRj?=
 =?utf-8?B?dUZENEpJaVRVdEt6ZlZ1V0tpNk5PQTFuQlAyZVNSUE1NYjhSTk8vYmdpRllR?=
 =?utf-8?B?RVg3cmNrTm9EWm9HdGcyUGxRcDNQeU8zemRHL2xnazgrT1dqZUxVRUd6b0xM?=
 =?utf-8?B?UThISlF0TnlqVWdiazFhazkxd0FNR2hFcEh0NlJjZFZiejljRTVRb2ZHOFBU?=
 =?utf-8?B?Z2xiNDJHMXZhcTF2VzdpcVIrb1gzbS83eUx2WlVkeGFaZ0M4WXNtWVFIV0lW?=
 =?utf-8?B?Qlp2VVNEdVljclE4aWJGR0dSdmMwd3hJRU4yK2FXbld6ajVlVm5hVmV2Zk9z?=
 =?utf-8?B?RkxBblVNeGMrVlBwUEllVlFwRVpTaWI2VFR4dkNLa1Vxc01KeFhuNWFvQ2li?=
 =?utf-8?B?RjM5NTAwcXNOSU1rNjNpVTJXNHY0ckVyOHdwMnBtelpabHlyU2M5cmtSMTJr?=
 =?utf-8?B?SkZMSlZTWnNqTDZsMWJ1cTZCNTNRdjQvYmRiNDVwdkU4dVVwVU05UDNaU0FR?=
 =?utf-8?B?MTlnUkZ4VU1uZVZqeU5ubk1Hb1l2dUtraVVtbzRiaEtqSHNaVkw0bVJ3QXdN?=
 =?utf-8?B?bkhua1prenJoODYvQ281TGRudWt2VG9maFRkdmErOFV0NkN3c2R0cHNhY0JY?=
 =?utf-8?B?VlNEUnhIU3YvNDd4eXNpVDdiakJOcE1FaVRVQ2d1SzJnV25rYktpSXB5RDB3?=
 =?utf-8?B?T0M2VWZBM0MvNWlZVGdhcExaTXF4dVpnQjFBVGpUQys5Rkp0clMwa1hoUVA2?=
 =?utf-8?B?MURLNWRDS29ud0RHcHNqdEViVUxyVjYwMzYyUGhhbDNGLzZkUXBtY1pVdEFV?=
 =?utf-8?B?aVN6YTEzemt4MkpFMkl0ekNFbG0wbHR2LzdPYTZSNlVTOWw2QUVXSkxaSVBx?=
 =?utf-8?B?YU1vY3pGZ2dsMG5IMzhBMENjZTAvaUdpcjVTeFBnaFpQbTZXcHpFamo3UTZy?=
 =?utf-8?B?TUNaUSt6aVFkbmJxQjhtTSt3ZGJqcFhxamIwWVBzbXFueC9Zc1ErOEVtcllN?=
 =?utf-8?B?UXVCWitJVjN3emZBSVB6WDY1RkY4R3RSUTA4cVh5OTNOMWRPdDVrRFdEY3VE?=
 =?utf-8?B?Z0pCOUNXb2N2U3hFSmkzVlhvZnpkYzFKZzY0c1dCOWxPZUJYQlJaaC85bWlI?=
 =?utf-8?B?ZTY0Qk9ON044dll5Z0ZvbktUWnpOR3VVR1pNZWQvN015VXZkRmZwdXBGZ3N6?=
 =?utf-8?B?emZESENsSnlMZ1Y4TlJGUktWSitiOUxxSXpCSnNicW1LSmpXam9GaHNyaXRp?=
 =?utf-8?B?dEVwY1pSYUVQUzFTQ0s1c0RYRVFqRHoraUxYN2lIMS85OFJXZlE2TmdwbUhi?=
 =?utf-8?B?RndaNDExbllOR2JFdlVIdnl6ZmZPYkQzRUVYS2NMNXRWaWV3N0JnNDRvdVl6?=
 =?utf-8?B?SExpeXgrc1ZEWEZubEU0cHY1OGU5MlJUTWtMRW5yRWlPbGNWWkx6SzdiY0Nt?=
 =?utf-8?B?eVdTSEQvTGduUUdHUm95dEppRENIbVBpWnlrWDIwN2FYRWt2dEg2ckNrY3Iw?=
 =?utf-8?B?MmlJM0VDVTNaNkhReVBOdENtNkt4NnZENFRQTmpvd2RFcElIMEs4SWcxS05q?=
 =?utf-8?B?dmR0S21PRDUxcWh3Zk1aVzYwVVpGS0VWUFZiakpBc2FRdUp0Z0k1UTVub2wz?=
 =?utf-8?B?T0Z0NGNuck16b2tyM1IrZ3ZHajMrYys1V1VGcjdIZndjajF6dmw2eElNQ0xV?=
 =?utf-8?B?NXJ2TkNnKzZsNFl3Y0hWTG1CVEgxMERIUWRub0w4Z3BKMGpwTkpDa3FHQXBw?=
 =?utf-8?B?UDBNSzNrQ3BuNTZ6c3ZhTzZIc0plVVAyVStUbmRTOFlwdWVEM0RBZ2M1eDlq?=
 =?utf-8?Q?otoU7NHnsdh54Ikoym?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f39e16a9-3990-4a1a-0e7e-08de6dae1c8e
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 22:52:50.5703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IimQ68u78jz/mmBPAcZBEjWySyJyjgXDANigynfFuoNn0aw02q5LktYMRGkuYt/C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9393
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71138-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[45];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bmoger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 0A31C147F99
X-Rspamd-Action: no action

Hi Ben,

On 2/16/2026 9:41 AM, Ben Horgan wrote:
> Hi Babu, Reinette,
> 
> On 2/14/26 00:10, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 2/13/26 8:37 AM, Moger, Babu wrote:
>>> Hi Reinette,
>>>
>>> On 2/10/2026 10:17 AM, Reinette Chatre wrote:
>>>> Hi Babu,
>>>>
>>>> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>>>>
>>>>>
>>>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>>>> Babu,
>>>>>>>
>>>>>>> I've read a bit more of the code now and I think I understand more.
>>>>>>>
>>>>>>> Some useful additions to your explanation.
>>>>>>>
>>>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>>>
>>>>>> Yes. Correct.
>>>>
>>>> Why limit it to one CTRL_MON group and why not support it for MON groups?
>>>
>>> There can be only one PLZA configuration in a system. The values in the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID, CLOSID_EN) must be identical across all logical processors. The only field that may differ is PLZA_EN.
> 
> Does this have any effect on hypervisors?

Because hypervisor runs at CPL0, there could be some use case. I have 
not completely understood that part.

> 
>>
>> ah - this is a significant part that I missed. Since this is a per-CPU register it seems
> 
> I also missed that.
> 
>> to have the ability for expanded use in the future where different CLOSID and RMID may be
>> written to it? Is PLZA leaving room for such future enhancement or does the spec contain
>> the text that state "The values in the MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN,
>> CLOSID, CLOSID_EN) must be identical across all logical processors."? That is, "forever
>> and always"?
>>
>> If I understand correctly MPAM could have different PARTID and PMG for kernel use so we
>> need to consider these different architectural behaviors.
> 
> Yes, MPAM has a per-cpu register MPAM1_EL1.
> 

oh ok.

>>
>>> I was initially unsure which RMID should be used when PLZA is enabled on MON groups.
>>>
>>> After re-evaluating, enabling PLZA on MON groups is still feasible:
>>>
>>> 1. Only one group in the system can have PLZA enabled.
>>> 2. If PLZA is enabled on CTRL_MON group then we cannot enable PLZA on MON group.
>>> 3. If PLZA is enabled on the CTRL_MON group, then the CLOSID and RMID of the CTRL_MON group can be written.
>>> 4. If PLZA is enabled on a MON group, then the CLOSID of the CTRL_MON group can be used, while the RMID of the MON group can be written.
> 
> Given that CLOSID and RMID are fixed once in the PLZA configuration
> could this be simplified by just assuming they have the values of the
> default group, CLOSID=0 and RMID=0 and let the user base there
> configuration on that?
> 

I didn't understand this question. There are 16 CLOSIDs and 1024 RMIDs. 
We can use any one of these to enable PLZA.  It is not fixed in that sense.


>>>
>>> I am thinking this approach should work.
>>>
>>>>
>>>> Limiting it to a single CTRL group seems restrictive in a few ways:
>>>> 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
>>>>      number of use cases that can be supported. Consider, for example, an existing
>>>>      "high priority" resource group and a "low priority" resource group. The user may
>>>>      just want to let the tasks in the "low priority" resource group run as "high priority"
>>>>      when in CPL0. This of course may depend on what resources are allocated, for example
>>>>      cache may need more care, but if, for example, user is only interested in memory
>>>>      bandwidth allocation this seems a reasonable use case?
>>>> 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
>>>>      capable of in terms of number of different control groups/CLOSID that can be
>>>>      assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
>>>> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
>>>>      MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
>>>>      example, create a resource group that contains tasks of interest and create
>>>>      a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
>>>>      This will give user space better insight into system behavior and from what I can
>>>>      tell is supported by the feature but not enabled?
>>>
>>>
>>> Yes, as long as PLZA is enabled on only one group in the entire system
>>>
>>>>
>>>>>>
>>>>>>> 2) It can't be the root/default group
>>>>>>
>>>>>> This is something I added to keep the default group in a un-disturbed,
>>>>
>>>> Why was this needed?
>>>>
>>>
>>> With the new approach mentioned about we can enable in default group also.
>>>
>>>>>>
>>>>>>> 3) It can't have sub monitor groups
>>>>
>>>> Why not?
>>>
>>> Ditto. With the new approach mentioned about we can enable in default group also.
>>>
>>>>
>>>>>>> 4) It can't be pseudo-locked
>>>>>>
>>>>>> Yes.
>>>>>>
>>>>>>>
>>>>>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>>>>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>>>>>> need to change.
>>>>>>
>>>>>> Yes. That can be one use case.
>>>>>>
>>>>>>>
>>>>>>> If that is the case, maybe for the PLZA group we should allow user to
>>>>>>> do:
>>>>>>>
>>>>>>> # echo '*' > tasks
>>>>
>>>> Dedicating a resource group to "PLZA" seems restrictive while also adding many
>>>> complications since this designation makes resource group behave differently and
>>>> thus the files need to get extra "treatments" to handle this "PLZA" designation.
>>>>
>>>> I am wondering if it will not be simpler to introduce just one new file, for example
>>>> "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
>>>> file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
>>>> task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
>>>> resource group to manage user space and kernel space allocations while also supporting
>>>> various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
>>>> use case where user space can create a new resource group with certain allocations but the
>>>> "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
>>>> the resource group's allocations when in CPL0.
>>>
>>> Yes. We should be able do that. We need both tasks_cpl0 and cpus_cpl0.
>>>
>>> We need make sure only one group can configured in the system and not allow in other groups when it is already enabled.
>>
>> As I understand this means that only one group can have content in its
>> tasks_cpl0/tasks_kernel file. There should not be any special handling for
>> the remaining files of the resource group since the resource group is not
>> dedicated to kernel work and can be used as a user space resource group also.
>> If user space wants to create a dedicated kernel resource group there can be
>> a new resource group with an empty tasks file.
>>
>> hmmm ... but if user space writes a task ID to a tasks_cpl0/tasks_kernel file then
>> resctrl would need to create new syntax to remove that task ID.
>>
>> Possibly MPAM can build on this by allowing user space to write to multiple
>> tasks_cpl0/tasks_kernel files? (and the next version of PLZA may too)
>>
>> Reinette
>>
>>
>>>
>>> Thanks
>>> Babu
>>>
>>>>
>>>> Reinette
>>>>
>>>> [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
>>>>
>>>
>>
>>
> 
> Thanks,
> 
> Ben
> 
> 


