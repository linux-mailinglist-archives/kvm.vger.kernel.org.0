Return-Path: <kvm+bounces-64158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C34C7A8A9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 16:27:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9AD33A2505
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 15:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F9D307491;
	Fri, 21 Nov 2025 15:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="c272TSPm"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B4430594F;
	Fri, 21 Nov 2025 15:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763738495; cv=fail; b=Zzw4AY8iqjJntMCbuideLqWTUXsi6YG158m2kclKrxedqhdjLAT7URRFq0BMHIyjji2XDc31es9HSpTHVZk/NfHcUbmU1ooSSaYPJ+J+9pYXu76saQVJR9vRG+KD2e066iCwqsb7giPCVDWn4tv3EfJCJFUAzkX+DI5N6lm5Hr8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763738495; c=relaxed/simple;
	bh=mS8qMKN0cuoQ9IjL3+aomZrMvPvbi/OdjmTdouvS3YI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HZ4WPJrtRuhDBjCJaicfN24QNkE4eIoZ5t29BvR9D/Gj0lLfcb6km/eOu7DZJ96+58jic/Mcs5reZR4ESIXD0CcqGzLThYL2SSWmOC7LP35CF7dyCgMDU6siuVp1YH+IRLJuRG0W7aghfGX/o8SHVs1BH32KG8W8G9e8R73+86U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=c272TSPm; arc=fail smtp.client-ip=52.101.193.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aqJjwNKNX+gkFAOWI1DVs+QFzJ5q32+H7AluSjA10LGqOiOIWC9GDRVsh92d8whZyyAW5MuqXSWUPk8rZ6M7imCkzi9q6tk7HxGJGWCivk9msmKdx5128DIow9ok03FnoKetbp/foE4CzfzFrJog5tcrVnlBevX9SWM1janVwyfmZ+aTKQptjNtnGyuKB1wAfAho6hT69/w9ZdRKqYieMplqrk1UqzopktV7wtKHnvCAlHYU4YlqsNL4YjVHhf6sJV7W0x3aBb0S4056F9i2+Y99XSLvYlGSyiKxnkG3N8EjZENKRHOz9DLra8v9n8BTA0SOJRdei07NRO6HztoSbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Exw4zkUxWqbAn9Wklnb5uW/MHfE26N8rmt3O6jU/qwM=;
 b=QoDxdGevyfz2R5ub8gM0Pp4gehvcnylMWfaNmNcJrIZdWq0QSLUfsv98/an1xUPUiXl4kQoKkDKUyBeLZ+wk6jl2SoZo64CCjzQrNcWffb+fmdzwONnAL4OrHaZahOu8OdCymNqq+vnWkcpLb0Bqk6nauBJMrRkFvH5FMlL1OcKRcIWxj8ZYLNn0N614309T50i+lNHtBHAyNX1/we473qqLWFOM9iY0Mklsq6AZbgo/gf/gIBAtNjFe/w0/j2bWXvQvj5zFEA42/JwOPCUEjntpVkijZNjovkVDZYctTfwfelZMxpuLpuFNfkN103id9lZICa+KOlotYi5zn191ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Exw4zkUxWqbAn9Wklnb5uW/MHfE26N8rmt3O6jU/qwM=;
 b=c272TSPmkUsESVYyx6/MU1jAIDAcFN+IFxQJT1B3JR+a0Rk1s4uR+HCU73SHEcZDKlJs/3IMGAYWQEJPNPXQzTJ/IZ1w7/StZlNgnLACyuJJX0Rr+0HAsiUxr/cVLhx7+hbx+K9j78nw/jjBwOjzbd63H2EX3su1bR305Zn5Xlg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by SJ2PR03MB7380.namprd03.prod.outlook.com (2603:10b6:a03:567::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Fri, 21 Nov
 2025 15:21:27 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8%5]) with mapi id 15.20.9343.011; Fri, 21 Nov 2025
 15:21:27 +0000
Message-ID: <448e25a3-ff1f-4038-933c-66417cd6b7b4@citrix.com>
Date: Fri, 21 Nov 2025 15:21:21 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
To: Sean Christopherson <seanjc@google.com>
Cc: Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
 amit.shah@amd.com, thomas.lendacky@amd.com, bp@alien8.de,
 tglx@linutronix.de, peterz@infradead.org, jpoimboe@kernel.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, pbonzini@redhat.com,
 daniel.sneddon@linux.intel.com, kai.huang@intel.com, sandipan.das@amd.com,
 boris.ostrovsky@oracle.com, Babu.Moger@amd.com, david.kaplan@amd.com,
 dwmw@amazon.co.uk
References: <20251107093239.67012-1-amit@kernel.org>
 <20251107093239.67012-2-amit@kernel.org> <aR913X8EqO6meCqa@google.com>
 <1c76cb00-1fe1-4fd0-b7b9-86ddca6115ba@citrix.com>
 <aSB-LUfcyx8B9MLr@google.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <aSB-LUfcyx8B9MLr@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0305.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::22) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|SJ2PR03MB7380:EE_
X-MS-Office365-Filtering-Correlation-Id: 1711f216-a033-46c5-f8c3-08de2911a39b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmQ0UU1JdmZad09pOTROZG44bS9FTkk2TWs5WC92SkYwMW85WnRkK2l5aW1h?=
 =?utf-8?B?aStRbVlCa3c4V2RxR3VmbjBSS0xid0k1UTVBaFIyQnF2Rmw5QmM1VHgyL0Fn?=
 =?utf-8?B?UHJnQjdwZStxZDVsYkhTNG82c3prTXhoaDY5OHFPeFBZY3VxZmRGR29WYlpk?=
 =?utf-8?B?aEVUNithanpZOE9WS2xQaXBHNWd3b1E1bHQyVUVCb0NYNkJkcXFkR3N0bkZB?=
 =?utf-8?B?YUNLSVMra1YwbzNJaHkrVS9lcUZCc0Z1c3laempYNTAxcUlxWU85Mk9TM0Rs?=
 =?utf-8?B?YUNhSXJPVzg3YlJHZFByMEtxZGJRa2EzRWRZQjc4bzJlL2NRS1Q5cFFBY0JL?=
 =?utf-8?B?OFFiSXhIQXNmaUczU2szOHZhWkdPN3A5cEorUzdKUHlqTDJGQUpJUmg2TVYz?=
 =?utf-8?B?TjUxcnBJY0Q1aXRBMzdlOUdJSUgvaWFaVTNaY3JpdC83ZG00djkvOFlOUzVw?=
 =?utf-8?B?cTcxYzRDcDVuWERBVml5NENDOW5VNHhXNlVFTkw1V1FJbG9FTGp5YUM3ekZa?=
 =?utf-8?B?SWgwUy9YZmtmSWNPcnc4N2ZCZUNmUVNBQWlaQStwTjBoNmc0dVVjQ083MG1O?=
 =?utf-8?B?U21qL3AxTTZVQVVCLzRzNy8wNHdsd24wZ3g5dlFobVZ4Qnd6c0x0N1FWNkNp?=
 =?utf-8?B?VjVicFVVZHN4TzdvMTRQWWVPeTdHb1h0ais5bUVqRFZRVzRVS0s0TXgwSTVQ?=
 =?utf-8?B?QTV6SjhJQmFZaEJDaDVYK2J6TU5vbmJKbllld29UcUx3VEhsQjVpcWswUldL?=
 =?utf-8?B?cWRuK2g5YlNKbGY2ZGdTT3FHMmZZWVU4VWt1dFh3Tjg0STNxdGEyM1gzT0Rl?=
 =?utf-8?B?bUJOQXhhMythZlFORkp3WTRHOTZJQkFKdlJ1bWdvK3JYRGMrcHhHQzFnS0oy?=
 =?utf-8?B?b2huUXhjOEpOUk1IRzVBeDAvNlhsLzdMdFpORWJIcWpBNVoraUhwelE3TTl6?=
 =?utf-8?B?Z2U4VWlSYUdxaklzQ1J3UTRwRDljZ1NQZW1EcFRnN216YXR5NmhBSGFyTmdi?=
 =?utf-8?B?NDA1dUVhOTdiQUNhN3J2ZzBaSTFjQ3JYemhRTzBmL25VV0Uvb3VFS1B3WFdB?=
 =?utf-8?B?SzhVSmRvRFBxS1BRMUllWGVFYmxwQUFqTlVHbEtGNjRxb1hQd2N0YkI5Z0lS?=
 =?utf-8?B?L1ZtRUREOW9CQzYwYUJzSzdoNXpITWtrT0JJVHRIMDIyRHRDcHl4cTRtOVUx?=
 =?utf-8?B?Z1VvWE0zMUVINzJTL0NGOWlkSmZoTFpmdGhPOE16WFhvLzZ0TTNZbGhYbWhj?=
 =?utf-8?B?THVOa2ZwVVptNzI3UnhTNTErZGFDV1lzL0hwVExZVDZoT255TXVDaEFlU3hF?=
 =?utf-8?B?Tmp0SFFvRC9GWGZiMndsUjgxeDF3OXpHb0xPbTMzWVE5THFpOHc5LzJ3TFVM?=
 =?utf-8?B?UnBCUEVjYlhCaDNkSmhVUEtPVW1FTUpscjRpL2xYelRCSk9UeDlaL1hNSGJ6?=
 =?utf-8?B?RjhOTUdIQysxNHM4VDRnYk5raWJkTE9ucjZRUmZVdmUwY01IUFUrcmltS1FC?=
 =?utf-8?B?K3NGSVJWNXFtSWFaMnNsb1g0OVVWekZxZ3NEeGY5TjBNcGJrNEZzSDdnOVFF?=
 =?utf-8?B?RXBVcVg2aHFaYXk3WXNGYWIwd2lZekFRU3FOQnhKUTNyS1VqR2xjOVZ3WmU1?=
 =?utf-8?B?eDBSMFFPTUc4THpsRXR3UU5Id3l6eEJqZjd4YldSTmVFRjVwb2xqbXBsNU9y?=
 =?utf-8?B?L01yRUFKVXM3M0RQK0cyVk5yMkdadGVYVHZYL1JFMjh4SGxYbVdja3g1aVhQ?=
 =?utf-8?B?OVgvakYrSG4raDhKNHJlSUdWcjZqYnZ5RkxIWWxCYkxoRzUzbHBXSkVPVmN0?=
 =?utf-8?B?dENtYlhILzFpZzRSNXM1SVpJZkFiYW5DMTdUZ0prY0xSSFJCY1lML0RPaDdz?=
 =?utf-8?B?dmZib0tjc3RrMUpYNE5DSS85aXMyNmxOQWszWWpzZGlOMWl4NXQrTnJHTmc5?=
 =?utf-8?Q?+risL0fOwePO4dQbJnnyVTF9Hr7iQabK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bFYwZHJrTWxzZkJiL0lyWDFqYWFJb09xM2lYdFBvcFFtL1FHTTFzZmJ1TUFo?=
 =?utf-8?B?R0l1bCtUOWNGR1VmVG92SjJ2SFJYL3pZVkcrWFVJcXd0N3E5TTNmV3NQdzFN?=
 =?utf-8?B?dUkyY1ZOMkMzSnplVkp2Yjl2NGVwOUY4Um9BUkIrenN4RTZoS1FiT2QyVVpV?=
 =?utf-8?B?MGxGZ3A5NDJlMGJqNDFiNUNDSFpmaUJIYXBMZE5hUEFvR1BWUEFjdysvNGNj?=
 =?utf-8?B?MjBnNUF4M1ZFYy9aZk52cVh0NjJkaUFYSWxYQU5hMDVDbTNRTE8xU2llSWdW?=
 =?utf-8?B?Q2NBU0pOWm95a2VHRE1TdzVRTGxGZG1yOXZvYXUzclVNRVpPcUZsMnhzcEho?=
 =?utf-8?B?MnRkVVNRdFhXaHZGU1Q5aGl3MXhjL0ZnWm8zbzZqd2hkbWRvajlyaVo2Yk9j?=
 =?utf-8?B?dGs4V2U1Yyt4NU14T0lHRW84NUNmQ1J4R1Q0YjJrSVNDR0cvMVBYekczS3cy?=
 =?utf-8?B?cXJGcTlZNFcwa3hCR1JoUnRndGNlK2RTTHFlTjg2aHJsMk85WnUvTlZaQkIv?=
 =?utf-8?B?c0hMajNPbEFmdlhvUG9sTEZvcEMzcHBNUEhyN2lNSFJwN0N4NjRjTmNySkpa?=
 =?utf-8?B?NGVRazV1anRyVXBhQnp2Yks2cUZSeFNUN05MWTBHQVlSM0xwTkUyR1daY0Nq?=
 =?utf-8?B?cmJsalpFVW5STkVMMDdDYnhXbnVINzZIeUZGaDhBcHFwRitKMjZLci8zWDdv?=
 =?utf-8?B?QU5EZldRRVRQQ0s0UGw4NjlCOHNmWFRjMTdhenFjdno3ZEZzSzUzbWk5RVNp?=
 =?utf-8?B?ZkZqUWZqeW5LdDRuSSs1OGFYMEdWZndWVHVYOVNnSkpzQlFWak9qck5jMG5y?=
 =?utf-8?B?Z3NJZDB4T0g2UTEwNndRSkRCSmFKOTBsTkVBUjNoNnBoaVdVT0lPckJSY0sv?=
 =?utf-8?B?ME8rNU1obkZEa3JwVlQxZnVrSUY2OXZPdkZlWFJXVGMxY2l1VksvTzA2VE0v?=
 =?utf-8?B?V00xdGtKSTlxSFVPYjNVcFVnRFNCbUZHbFc4TWJQajlza1M5bWJUaFpUZ3Ny?=
 =?utf-8?B?Uk82ZW1XQTg0N2F4RE4reEN6RmQvUkxiSGovcXIzamxxRlhrZ3grbjZEU3Ny?=
 =?utf-8?B?Wk1ZSk1vVTNtR2lwclhNcktRaTUwaHlFR2VLUkYzS1p4MFU1ZnVxelV1Yjg4?=
 =?utf-8?B?aVRNL3h4c3VUa1djNTEwUlRBZExpQ1RtV2JZQ09uSGdCY3VxWHlsM2dwejY4?=
 =?utf-8?B?RE1vQTJzeUJLV0JjT0Y3RmVmL0dld09FMVB4emlEaFFsdDJhSVlyR1NGUE90?=
 =?utf-8?B?YVp6QVBjdVdoZEhPa3ZFZTRzQnc5WmlpWXJQMy82Ynh3MHgzMjU2TkZMY2dW?=
 =?utf-8?B?QVJPc3ZUUHB2ZVhEcGZmTkRnaEFqb2JyODc5ZnVxaTJHQ0lLOUZCdGdhRUV1?=
 =?utf-8?B?NUxKaUliM1kvcEsxaGFENlpxV1NKRTFMT0ljNUwwMm0wVnhROFhmd1R1ZmVY?=
 =?utf-8?B?eGZQZWJNOHpVbzdUZVVFL0pORXZtSnhQazl4a240d0JvSkwvSEFXT3NnaEVU?=
 =?utf-8?B?VEljeGZIWDV0V1Yzdzdhb1VzaFVZYXFRc29VUlFGNzR3YnhpVVZNR1Zac2pG?=
 =?utf-8?B?TmozZTRYWXUxSzlaMVViSmhZdEpPUUdJSFVXQUpLQ0JoQUVWTys5eFNCVjRr?=
 =?utf-8?B?QVBqK1k2QUlaRjkrc2RsYVhvK0FFMlpuRHpzYVM2TUxRSE9nQ2dWUzlCeHhQ?=
 =?utf-8?B?YzJma3BBRjhqRCs1bDVldm91QWZUSmlUZ2wrbjVkcnBFeXhpV3dSaVJDU2lr?=
 =?utf-8?B?R2dxWGNEWTgyRFJoS21wZWVFYk5mNy9JUnM1OHhaZjJVQUFVSEdIYk53bjN4?=
 =?utf-8?B?aWo1VHJVVXpwSWxzV2Q1OVQ2bGlhQm5sZWFGSEd3VWlPUHJJZERxdVdJRXlX?=
 =?utf-8?B?K21icmdGWWx2MHgyaGdRRTRGUTNXREgwV2JtcjVzWFA2dXFNVjdTV1ZMYURR?=
 =?utf-8?B?eGhpUkxrRUJzRGlOT1AyRjdRdXY4TTN2UFhLZlBWaStCS0d6Qy9WOTZIKzdO?=
 =?utf-8?B?NHRjNkwvbm5YMXBjNEk4QUdIWDhaWDdpL3FqZGdpU3pjWDNsU242RmtmLzZp?=
 =?utf-8?B?WGEzelpZWmpESzF4QnNLM3J4eFcwRk1DRjJoeGMwUG9WSW5HUzhIQi9LazVt?=
 =?utf-8?B?MUZZaGp0eitIY0ZRSTMwZWY1OEtIV3k3K3BqM2xjeVQwbWZtcThWYVNrWDVs?=
 =?utf-8?B?VVE9PQ==?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1711f216-a033-46c5-f8c3-08de2911a39b
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 15:21:27.0939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBASCz3KSQ8z+fx55dIp6oGdW7Y2s+34/SEIM/a+zRpcunA2NGlxPZ0wIgLMScMHVauXptWnKXz5AbqQKErsg39QomgQCcWTpGPB2Cgy1ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR03MB7380

On 21/11/2025 2:58 pm, Sean Christopherson wrote:
> On Fri, Nov 21, 2025, Andrew Cooper wrote:
>> On 20/11/2025 8:11 pm, Sean Christopherson wrote:
>>> The emulation requirements are not limited to shadow paging.  From the APM:
>>>
>>>   The ERAPS feature eliminates the need to execute CALL instructions to clear
>>>   the return address predictor in most cases. On processors that support ERAPS,
>>>   return addresses from CALL instructions executed in host mode are not used in
>>>   guest mode, and vice versa. Additionally, the return address predictor is
>>>   cleared in all cases when the TLB is implicitly invalidated (see Section 5.5.3 “TLB
>>>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>>   Management,” on page 159) and in the following cases:
>>>
>>>   • MOV CR3 instruction
>>>   • INVPCID other than single address invalidation (operation type 0)
>> I already asked AMD for clarification here.  AIUI, INVLPGB should be
>> included in this list, and that begs the question what else is missed
>> from the documentation.
>>
>>> Yes, KVM only intercepts MOV CR3 and INVPCID when NPT is disabled (or INVPCID is
>>> unsupported per guest CPUID), but that is an implementation detail, the instructions
>>> are still reachable via emulator, and KVM needs to emulate implicit TLB flush
>>> behavior.
>> The Implicit flushes cover CR0.PG, CR4.{PSE,PGE,PCIDE,PKE}, SMI, RSM,
>> writes to MTRR MSR, #INIT, A20M, and "other model specific MSRs, see NDA
>> docs".
>>
>> The final part is very unhelpful in practice, and necessitates a RAS
>> flush on any emulated WRMSR, unless AMD are going to start handing out
>> the multi-coloured documents...
> Does Xen actually emulate guest TLB flushes on all emulated WRMSRs?

Not currently.  I need to reassess in light of this conversation.

> A RAS flush seems like small peanuts compared to a TLB flush.

Workload dependent, but in the common case, I'd expect so.

>
>> The really fastpath MSRs are unintercepted and won't suffer this overhead.
> Heh, if an unintercepted MSR is on the "naughty list", wouldn't that break shadow
> paging schemes that rely on intercepting architectural TLB flushes to synchronize
> shadow PTEs?

Hmm.  Yes it would, if (and only if) the OS is aware of and depending on
the WRMSR for TLB flushing.

I doubt OSes are depending on model specific side effects such as this,
but we have no way to know for sure.

~Andrew

