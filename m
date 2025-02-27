Return-Path: <kvm+bounces-39577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 861BCA48043
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:01:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 426563AB7F8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 13:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29693230272;
	Thu, 27 Feb 2025 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hncPcFpl"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDB7270040;
	Thu, 27 Feb 2025 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740664796; cv=fail; b=swL5nkkDJro/kLl+uKixJCxIc4KtYI8YQudpQMKTwtlDQaq3ngxxn+Ygw8yuHO2o5eXA/2qExSA8FUoHctggWrl8Z87fgVGVafd1QBbOXde+l3m2vephabpMm58g8l8TVrm2/I18jIRCDKluDfyaHzbAfw00pu3Q6svuiidA9f8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740664796; c=relaxed/simple;
	bh=ABchOyxaETJT2IGfrQQceEoHt2Bj1SjyREwU90s02Pg=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sWonJmyM+jOBzQfSvsx6snVu8Xb22NdLw9GwCc3ag0cbGdJ5eyR2le2QuQhk4HOzO0Bnmgk7lT8ZhXBRKBZnD2jLd5urHk4H2f+T6JXafDbdpi6pIMttKSr4DO9Zb/9z4IqBhwQoTAQPPNP4yJHNt7jz85eTFsoO7B6Oa+3SIvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hncPcFpl; arc=fail smtp.client-ip=40.107.94.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=joRmc1GnwrdLOQL8g95Mty17c0S2rZt9jTaRFNWMDxWqo0OrmEmDC0DxNZewytBv/fIm6bkP5efyLf8zAwcbfAe/fIHhq3E6t2GFICL10PKGpN519q19DN0VekvYmO0aPbM1KXpXTLWPLnZYzXAQ0AzQTwsn7m3kA7gwaObscXf/rhGoHwn2c3WdC+v0yPa3oniUe5IvsfUB1IBeKW2WMbxR+8L7JH5dloUuIPDaaAecR8p7OyNveVcPXvV1cIQWDolJ1ZQYJELaOHZVJMNd7kZee7iVJPjF44/lMcFKNUMOLnTxRUao6nkKjYsNx4Cr6JBq6+gtuWuwGVq/aiILag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a5Vph5IzwlCAjeR3dcpI3bxuXc9lcxXOb4blKgtw+R4=;
 b=hnONixj7brCZrTWTbjt6cnEoQsttaqRwvMQ7s4cneIFGWBNOaEeSF32vUz5M5/2QHI8HazttJ33kEU/XfVe8X2pkkm2OzBnfYkhZx9R2oMXHBnyUgV+kVPk3B/N092U7srJKCfChztIDGa48LQtxgs85B64rZmRwvqbPH6hoaZ541XJam49KBKtLOSEVAHdDOple1HdedUN3P+B53EgcMOy0NRWyIgoHpjGuXVnloMB5vLAA0pb56Zemnptuxysf277ASEIeDSzhF1dduxNgx/fAZp/9fJ7SOlIEfIiWVIo4ly6wtv78A21Ad2vCdMIsU43wYmWH7TLNDFATI5Pmsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a5Vph5IzwlCAjeR3dcpI3bxuXc9lcxXOb4blKgtw+R4=;
 b=hncPcFplza5355RieYA+n5hm+xcr8hTRrSN8GDweSxeAcCuwzz7l8WwXcVn4nPaemjKzl7McOH/CU8AWG7TnWU4UOrUpD2O3A4T/Ls68qEmosm+NyyjVPtidcxIzeAnQOttKuNhjAaWR3QO47eK+O/hq7CNLTog7mBy2/sZc44Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by PH7PR12MB7212.namprd12.prod.outlook.com (2603:10b6:510:207::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Thu, 27 Feb
 2025 13:59:51 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.8489.018; Thu, 27 Feb 2025
 13:59:51 +0000
Message-ID: <095fe2d0-5ce4-4e0f-8f1b-6f7d14a20342@amd.com>
Date: Thu, 27 Feb 2025 19:29:43 +0530
User-Agent: Mozilla Thunderbird
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH v2 3/5] KVM: SVM: Manually context switch DEBUGCTL if LBR
 virtualization is disabled
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>,
 rangemachine@gmail.com, whanos@sergal.fun,
 Ravi Bangoria <ravi.bangoria@amd.com>
References: <20250227011321.3229622-1-seanjc@google.com>
 <20250227011321.3229622-4-seanjc@google.com>
Content-Language: en-US
In-Reply-To: <20250227011321.3229622-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:22::10) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|PH7PR12MB7212:EE_
X-MS-Office365-Filtering-Correlation-Id: 05746a9a-c5e0-4e62-1a1c-08dd5737015e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?emdaMExqTGFpVU5GTVRUKzVMZWVaM0ZadEpMc2U2Y0t0N3N1QStSMXdIdzB0?=
 =?utf-8?B?elpuTmN5NHJ4R1pzbzU1KzgxMzdkUUV0cGhacGVIOUViVjRDQlRjWStsS29t?=
 =?utf-8?B?SGNIdGZ4NUZQSUljZDNZUy9YRVFqQ1ZuVDZreWIwbXhGMytvd1EvMUo1MmZi?=
 =?utf-8?B?UXZzQzRGQUxpTTVLaHpDb2g0N3N3MCtrZDMzVDVORzVlYnVkS0R3MEFCZ05K?=
 =?utf-8?B?NGdCMy8xbkEyb0dGdHNqZVppaDJtN2RvZ1dXc0RUdWd2K3lxZHVNeDkzK2hs?=
 =?utf-8?B?eGNNaWFXRDhRc0I3T0Vxb2xDQ2NEYmxQSFdvaWlhN25HZVplN29GU1NBaWo0?=
 =?utf-8?B?R3VTNUZhaWRtbXdXazhqWlluNWREVnRNZnd4alBSQWJJSEhKbi9KZEFua0RL?=
 =?utf-8?B?RnhLWDBtcjRNaEZDUUZ0VTM5d01WY1dvZ1pZQ1lCNU5tRklOZmJWTStLdDE2?=
 =?utf-8?B?MDFiOWFsSlIyNUhpT3dCUFZwSWFIdE5FclZmNWNhMStOQ1NTNXRPVDVDZ3Z0?=
 =?utf-8?B?amVCakZCMHQySlViSDZUUHJOZzludEhoZmV3VU00N3B1SkFvaGh1cG5HYmdR?=
 =?utf-8?B?dlBWNWErMnlBdE9xSXZWdExQYkdySTcwRTJYMHY0WTN3ekJ0blpvWXRaSWxk?=
 =?utf-8?B?Y1g4cGY4YnZDVHlPdVNoS1pPVy9XVmEzOU5SOCtHeUx2V1J0WGI2UVBzTzNH?=
 =?utf-8?B?dXV4MTB5VEFiclZaa2F6cDNPRjlTcG1HRW5lM1kvTlRLUG1NLzJCNnJQSWlt?=
 =?utf-8?B?MExWQ0JnR0crcHA4QURaVE5JQzBTY2VicS9zRVJMS05pRFErNFRTT3FtNDFY?=
 =?utf-8?B?K1dYb0Q2L2FTb0Y0b25ubHRNTFZBRkdOR08wRDdWTmxLR3dISG1HRFIwUFFh?=
 =?utf-8?B?M1hLQjRnSHFvNkZyWWdMdGZhdjlzVno1a1Jza3hiMTltYTdSL1VRTmZLbzFK?=
 =?utf-8?B?dG9jb0MycGt6bWVyT0dnZHFtNWhXNTRiTkYwNEwyYmZjb0xVQ0hrT04yUEQx?=
 =?utf-8?B?eThEcng0NzdpYldONEtld0dYOTduQUJ0aVNBeEl3R05KcmZBVStJc2NSSm1s?=
 =?utf-8?B?cHV1ZUUrUG83SkhHMnRSdFVuYkR3K2FwWTE4MWZrd214YVEza1BqU2ZKU1FJ?=
 =?utf-8?B?NlFSK2txOFV5L08zK2k5NWNqbG9GZEVEWHRYdXk0ZGRjRU1XK09IckV5TW5y?=
 =?utf-8?B?cUJLNWZENjAzSXBTRzlUaTJBWk51NWI4TDZFRzRoaXBUU2J2aDdxcHRBbTFI?=
 =?utf-8?B?VzdyVTJPT2YzdWR4c0xHK3RpNXJ4SCtTL0VjNHRCc3R5UDJ3VytxanZVR1FZ?=
 =?utf-8?B?N3ZnSWZTOTNFdjM1SG5ONzUvc2RYazIrZFYrTHhjZjBWZ0hLa3doZnBRSmQx?=
 =?utf-8?B?U0FVQ3RyY2htZzI1azA3L2RGaVZMejRQUHJjVUFoZXVGZWYvWEJCL3JrKzgw?=
 =?utf-8?B?RU4vb2dobW5aMXF0VzN3T1F4Ri9JMUlrSGtJUkVwajUveWhJazNFQ2ROS2p6?=
 =?utf-8?B?ZDZ6bE1PQnp5Y2w2RDBSYTJZUEgwWTYzV0wvT0RCTHMxV1RqSzZaTm1kSXlK?=
 =?utf-8?B?emovQ1B3dmxHbStKUXMrdC9CTkJHOGM4ZGhTNHlQOVY3N0pIRG1DajE2ckJB?=
 =?utf-8?B?OUg5TDNLWklyRjR4SFE4SEMvUmJ2S3BZMmRYdnhSemE3RTNXY2Jzb3F2YW1O?=
 =?utf-8?B?aWtlOEE5N29tSjBrSEgyZ3l6b3NGeGtvRnRabFF0aW1WTExvckJQVERRUlhW?=
 =?utf-8?B?SC9DbnZaU0tqV1BTMGxhb1NzMkpheCtHb0dPbE04aW83R2o0RDlFYmg1U3Vi?=
 =?utf-8?B?UFFRSFhKaUZBOXd0WTJvNlBta2dsUm1JRmIxTXZSWko4R0taMHFiT0JRWEkr?=
 =?utf-8?Q?Cd2e8D/GID2aJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bWdCU3A5ejNvZUZrN0hGczJjbks1SytjV0V1UksrNVl1K1RZWHNBck1aVzd6?=
 =?utf-8?B?Q1VTdnlseElpTVIrMUF3N0ZvNXc5L0hoSjVFdW9tdGE3RkNPL1pGaEdwQkQx?=
 =?utf-8?B?SmR6UnI3QTROVWRDNkVNMVhMWGpodmpjVzN6QmJiTlVYZ1YyQTkrTXFMaU5X?=
 =?utf-8?B?dHVRaEMzV1NQSVRhUzdqcHpINkNoNUk1Z1VkQ3dneUVJUktTdGlIVmNmT0Nn?=
 =?utf-8?B?NmhPelZhaldiU1BKUmhZR2RZU3JwdDNKYmtmOTc0T3V5cTZ1VUZHOVJsMkQ5?=
 =?utf-8?B?MHJycUd2R0hVUHo5eWVyQTVZYVZSeWlPRWJSQjFEY25CSFpLVU9Od2JWQjZi?=
 =?utf-8?B?dnh1NS9veEl0S21BUXhqNU9oT2t1L1ZOemt0Q29iNFdVSUlsdjViRC9MNVd2?=
 =?utf-8?B?SnUxeXE2ODYvYjVhMHJQRXdUREdQSmp1cFFMc2U3aVdObWVQRDJmbmJ5OU9u?=
 =?utf-8?B?Sm0yUEJwZm9LY0RjUFBzODIvYm5OTUFHNHl3MWR0UDVXUnc0V0t4cHVCa0Rs?=
 =?utf-8?B?K3AyLzFTbFR1RFN2SXV4TStoRTNQRGQ0VjVzRmpWeWVqMGw2ZWEzenhub0Iz?=
 =?utf-8?B?ZUozTUFtcnVNRFBQaCs3M2RKQitwNVZ0L3VTQXVQS1JwKytmZlFuOWNTR0ZB?=
 =?utf-8?B?RDhuZXJVczFxaE9ySFB0T0JTZWFuekNzZTloYXBzb0c1MG8vWFNwWUxtRVlH?=
 =?utf-8?B?Ry9GZGpKWU9VRjdZdDl3eUlORXVtMzN1cjU1ZlNrYStsdFpyUUVvZ0FBQkI1?=
 =?utf-8?B?NnM2ei9EVWZUL3QzS0ZKU0pEcU1YcklKbVJLSEVVZk1VeU5oZmtHYzJJTDBD?=
 =?utf-8?B?THFXOUR5SnRpdCtsanRhaW5STHFUQWxVakxoaTNTaE4vVjk2TjR3OGJNV2lm?=
 =?utf-8?B?NEVTTlJEZkhKclgzMXlCQ2ZKcjAzbWp1RGxXM3FhNVcrRFBBUlB3RjNwS05z?=
 =?utf-8?B?MUVLdUVZcUM0cWtueHRuTHA2NTg0OTNpSWdLWDVqSmF6VStGbzVIaTJNcFl4?=
 =?utf-8?B?ZU53OFBZWDJRZVhvQTBjWkt2V1dUMm5tVWVielZWOXMweDFIdEJGbUZXSjhQ?=
 =?utf-8?B?YzdZWjRvOUlSN24wT2VRL3plOE5aRmFWWFd3RkFGVWE4Y245TjNITDF5R3F6?=
 =?utf-8?B?VEk0ajdoYWtqU3JiRWppMTZYODI3TGY5Q3RDRkdWejF2dHhScXJaRGVjNkZo?=
 =?utf-8?B?aDhSMzFhVlhnQXlYQ0o2eHRFNTJkcWdKcVpSQzhQeFN6aXRwdEdqa1I3SGhS?=
 =?utf-8?B?YklGbU1kZVNqNjl5VFFJWkJLc3VhZnpxcDJpSUN3U0YxWTRQSTJHUU5Gc2FI?=
 =?utf-8?B?SnhUMTJjS1I1WXg4bXh1MmlTSFE2b0V3c1paVmpET3hwNHhRVEpjKzhJbkFG?=
 =?utf-8?B?c3Bqc3IrWEJaQVRKQTZaS1hneTNxMnIycHRlNkFYYzJWK0tQNVRUUnlGRnpZ?=
 =?utf-8?B?eEFwK29uR2NQUXZLNFIzNlptQmtUMjdEdUlMTFRPM0JkeDlYVTFQbGY1ek9w?=
 =?utf-8?B?ODJHcDRLT2YxUG9hOElLaFozWm1KUHhONzRLekhTNEwzYXovTnNtQnpGVFNy?=
 =?utf-8?B?QUVGSXFHcWF0TFAyZkJQQXE1SUpRS0FRME9ZM1FkaFVqK0JLNCtnQThOZDFz?=
 =?utf-8?B?M01RaTA3a3pKVmhHSkIrcUhmQmVYTXdIWWZ2c3NmY1BzSXBkakUzQ29aQmEw?=
 =?utf-8?B?eXBvQUtYbU9WSTUxNUsyaHVha3pXc2RUZjNVVDV2ci8xZnpzcTZWRWt3M0hu?=
 =?utf-8?B?TWdoZ2F1bENadmorU0M1dHlRWUZETHRKWit5ZFhkUkxHNUY0amFKYnRMMFFs?=
 =?utf-8?B?a3BRTnFMdnc1bDRWSytVMEcwRjRNMnRTZDJoNVhRRmpHKzNWOU9maGhaUXpI?=
 =?utf-8?B?QTJMU21uMGViYlhJTHByZkVJbHhRb3lWdENoeDJCSVJxYjloMUxuRjh5S2Nu?=
 =?utf-8?B?SEFlc2NrdWdTczN4Mm5EY3drb09IRmFUVGdDd2xXc1FpREJUaFFjRmFGbVJz?=
 =?utf-8?B?R0RYdGpLeUphbVd1dGYyY3FkZjg5UHo1WDhvL3Y2WUY2YVZmK3FGYnRVZi9X?=
 =?utf-8?B?WGdVOXE4NVFvQ0VJSVJFL2VpNy81eFVXQmFJUkRZYzZ5bE9sM0xESEUxQW5U?=
 =?utf-8?Q?dawgffrZ4HRE/jRQO5QDPxEg/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05746a9a-c5e0-4e62-1a1c-08dd5737015e
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 13:59:51.7587
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLGMbdvxZ0zdngpSFzj1OkEmvIS54BJqcgD5VbOI6/GkMYB5p4Fno9wzcLMj5L1GK7brI5nv0CwquOjGjEdbgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7212

Hi Sean,

> @@ -4265,6 +4265,16 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>  	clgi();
>  	kvm_load_guest_xsave_state(vcpu);
>  
> +	/*
> +	 * Hardware only context switches DEBUGCTL if LBR virtualization is
> +	 * enabled.  Manually load DEBUGCTL if necessary (and restore it after
> +	 * VM-Exit), as running with the host's DEBUGCTL can negatively affect
> +	 * guest state and can even be fatal, e.g. due to Bus Lock Detect.
> +	 */
> +	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
> +	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
> +		update_debugctlmsr(0);

                ^^^^^^^^^^^^^^^^^^^^^
You mean:
                update_debugctlmsr(svm->vmcb->save.dbgctl);
?

Somewhat related but independent: CPU automatically clears DEBUGCTL[BTF]
on #DB exception. So, when DEBUGCTL is save/restored by KVM (i.e. when
LBR virtualization is disabled), it's KVM's responsibility to clear
DEBUGCTL[BTF].

---
@@ -2090,6 +2090,14 @@ static int db_interception(struct kvm_vcpu *vcpu)
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
 		u32 payload = svm->vmcb->save.dr6 ^ DR6_ACTIVE_LOW;
+
+		/*
+		 * CPU automatically clears DEBUGCTL[BTF] on #DB exception.
+		 * Simulate it when DEBUGCTL isn't auto save/restored.
+		 */
+		if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK))
+			svm->vmcb->save.dbgctl &= ~0x2;
+
 		kvm_queue_exception_p(vcpu, DB_VECTOR, payload);
 		return 1;
 	}
---

Thanks,
Ravi

