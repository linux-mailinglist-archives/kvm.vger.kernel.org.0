Return-Path: <kvm+bounces-72225-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBGwJs38oWl4yAQAu9opvQ
	(envelope-from <kvm+bounces-72225-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:21:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40AA61BD8E2
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:21:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 20A983070BB4
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 20:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86310451066;
	Fri, 27 Feb 2026 20:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R47cFplz"
X-Original-To: kvm@vger.kernel.org
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012023.outbound.protection.outlook.com [52.101.43.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2681361675;
	Fri, 27 Feb 2026 20:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772223573; cv=fail; b=Sgm9eqBknHtE50rm56TND5DpqdYKygQ0vd5/r8Vz7FicEjUfs0zsbbWOP4TaPIY9Ui8jp5HcLu4I8ifQXgpKv2931UacWMnPylfV9BUKAKHTqnVg/O0kKv2jwbLYdVRWEf8GKCmwSXA7D96Ab9DDW0ZceD8OtwWObOVyWOGQ7FE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772223573; c=relaxed/simple;
	bh=1fEGZ04+s8IkXz3kyZaYRGjk2IaI81ohKR2aU8cfWnU=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=taBsvmLDXmDE9M+ZZIKQfwyRXtxMBR37R1pUChWYT4GyFLsjLlQlCNJjj3i0CdUNZzx1ErWT9FJZd2Be7oupBkXfnqF0KgQigfGgNRHaFHV/MNpKoO8pmayYsq9j9EJZZqJ8o79RhRoR8w4y07opTTROsE0islG5+/PuztNEtVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R47cFplz; arc=fail smtp.client-ip=52.101.43.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GrEVIImPD11igasJnxexmC1kzK7ox8B46hBtyJxMJCztOShPPK+9WBUSZFnM4Eya8SiFguPW+Lwio6nEZlUjY/AWQnfNRqcz/KgghP8xgkQ+74jt5yQuhQ9TVOk3peA5cNJ5HNU95U2jnJOh0yd/jyOKVxc+lWjyQx3HUMxUFXLXkErSMf8acr42FfsWr5NAABpRjU/AERQY8Cj3ueB3NNghvFJ3AF9ffUnZ6ioIJHCx9vPSDE8WlAl4fWBUaabEeamFFg4vzYfQMdFrP9X4rMlkkYn1XZ/u90Lak+odApTeujAr43in9hzWbfobO0C3xXI0TARhz7qVvlXstIKlSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mzo1W6GZ3gPRSGV/mmowCtV3RAO606M3C2aXz3XxbLY=;
 b=dOO/6HuAxK2IOyGphTJcRv6/kIQgfyngSOTfyLrarxf4Fb7frI4mPzhwOw+BFrpfknfp2khS/5r5C4c399QiGE49wNzlS3B50HpnSf02mXpe0MEXFlqua/TWvmFVFjnlOiZYl58VyS9KjKniPyPGQY3IzO0GesWIDl5KHckFherajBs5iX117bGFOdJ0HRfMAv0KNbbaEKsN8AxrKVc7+TZ1Vl/t9lYyX5mxXqt1I7DFffkwRdwBlsAWgr0TWh/Pv1j9G94tZjeoeOCYJrJoDg1AyhIjIChBZVWUq7YpsEYc2Eqk+gE2M6FhfYeNbTaBDu6z1xSBIqyio5zJevfMEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mzo1W6GZ3gPRSGV/mmowCtV3RAO606M3C2aXz3XxbLY=;
 b=R47cFplzj0tYPqPQJHEULiuBM63SYDD14t1OUf+erkKyqPvOX/MWu84265vjlp1lSr5fWhmW/H8Cyzedtiw9N7JScC3sK2OqSS+F4hRE31fGeN7lMZm9CohCv+5cEjcnpFRghLTohTL/lGhKyW4JANQuOcXUdwY+2Fw2lEHVHxw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB8438.namprd12.prod.outlook.com (2603:10b6:806:2f6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Fri, 27 Feb
 2026 20:19:29 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9654.014; Fri, 27 Feb 2026
 20:19:29 +0000
Message-ID: <38b67698-9a93-4a68-9ee4-9a8f955d650d@amd.com>
Date: Fri, 27 Feb 2026 14:19:27 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/14] KVM: x86: Emulator MMIO fix and cleanups
From: Tom Lendacky <thomas.lendacky@amd.com>
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, Yashu Zhang <zhangjiaji1@huawei.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Michael Roth <michael.roth@amd.com>
References: <20260225012049.920665-1-seanjc@google.com>
 <3bf56d54-a459-48e4-b1c8-4b2630ec8714@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <3bf56d54-a459-48e4-b1c8-4b2630ec8714@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:806:2ce::15) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB8438:EE_
X-MS-Office365-Filtering-Correlation-Id: 4717debd-2093-4cea-9f69-08de763d82fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	rqfyUtwZtadfgDi2igv8hf+uk+Jvwz5QU7mOL6vuipdrzZUXzO1uePrZhYt2Nx5gYnEAdg4JnFfPD1le9N9yqJ1LlPne3vp4dKdKll1V7BeHkkF/G0sJx7oFmRAKiDhVGYmxFDS+r81bw3zGD+I0t2Dg3LTdxXVMiO08zpqP974pJdPJc3YSzBj2PMwUi30H5yyeNhAwHNuZa+MYvZTGoCOVLC2TBBeLigzg3ixAfn0yPmKyqvjZU+P+T7RavxY9diVN0aWu1Aw3UGvC/G4Alr/katqQ8/Y6QctwVe6THfYzmuI+smXGbcuvHIu9xaRoQN2odkm71N0GhimcRtJaJMfNudQD1o2nqK3LwHdT7Xa7K0eBk7oMcMp+FhtWOir7qFcRLuQ4DFkiuuM8y3QE8XKQVB9n1m/jI3YGKIu8on15JTHFnUSp0ettm67UzkXSxfhC4TJ9m13/4ruN8W40BF3i7mYLLWYFmGdJxGyK/ZiCpZbq/7UHz2htu3bk4KTr408375RmU6cDaR5WtQWbsrY/OLU703pady+D4xf5iIK69rh0nl/jD4k7cKuNVbPOfstgrB7Q14eNqF1hb42d0ykuFsyA7PN+2kOHx9/2t3ey3JhrvVm7IRTQCyBm2x3LyJrKsc0XyxScrDAtrG6cvqpDpH5CN0wRW9Q3FCEoIK19E5hsG7qdfb+bsKOKYnsyZ/APgxSl3srWtsBcGST9G2w6e5cZ8Ipw2OQT3+AO1b8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bXZaTE1MNlduVkY1dktGenVMcGpBUjNSaE9FSUM1WWRtdDl5Njc0Zi8vTU9x?=
 =?utf-8?B?Yjc3dDFZajJET1JVVnlSYkJpSzhGQ3JrWTZiTnVSYlRUNnMvZHRoWHQ1VUtC?=
 =?utf-8?B?b1FxRDhVSDNqWi9RaXZpUW9nZ0swM3FpdThhZC9LV014L3gwcnRRUHEvY1NQ?=
 =?utf-8?B?a0wrbFRtMUlLS2ZjYVZMYjh6S1U1N2E5amlrTjB6SzAwQTNpdWNESXRhZUNi?=
 =?utf-8?B?V2cyZERQQ0VjREJuTmJuRjk5U3VrU1hJUk5wU0h5c1RtMmEyUmJtRWVUT2hw?=
 =?utf-8?B?QVoyc2tEcmx1dnR1Q3J0NXo0RVplUzRSeUFOQWt0N0Q3M2ErK2dwdHp4N0c4?=
 =?utf-8?B?LzhaR3U0bFl1N044b1A4Nk5OaWtCenZodEVpV016UUFqRk94L2ZjUk4zemt3?=
 =?utf-8?B?eTZMUUhKb0FSbFI5bVNiZEtyam0wOWRZSjhIcDMwS2puTm4vYzZsMUY0RTJ1?=
 =?utf-8?B?RUlNTzhmUExuNU8yTXY0cTJZVnRJbkRVTXlRaUJMcURBZHNkdXYvQ2hreW9Z?=
 =?utf-8?B?RVZ6aEx4aGF6Q0RFaS9wNTFNZ1QrSnU1MGZWZFV2Q0xRUjFLbHdZcVZJYU1x?=
 =?utf-8?B?clFiK00zODJ6UUdVOURyVjM5TXc1U0g5R3JTdkdTc01zWUlTRXFlenlZWXhE?=
 =?utf-8?B?VGYyQVFTSkljUzFSdGdWdWhrUUJYSkNwOW9qVmlybURCRktWcFpHVkljTWhB?=
 =?utf-8?B?WlVwNlJFVmFiZXNWNEN4UWVkY2xiMlRlMitydzJOZEJlWFJtSStUdk5NLzBS?=
 =?utf-8?B?UUJFR1llZnlsUXZtM1RDWXg0alNwMCt4ODRycFo5WnNtVkQxQlZ6cWRHdXB1?=
 =?utf-8?B?Q2V6Z1VEak5HOUFnVlV2R01YMWpYZ0RCN3dtM0xHMXNFUEkrYmNBTnFvWno0?=
 =?utf-8?B?RXQ4QjVLR1VqK1JmelREODA3RkJWM244QURQZmRCWkdHd0RaRFZIN3VJVFJY?=
 =?utf-8?B?ZXRvWGpXbXZZVzFzTVI1MS9KZEgwYVpVanpabXd1T3dGTGpjQldVbWVLcXBP?=
 =?utf-8?B?aFhtQnp5U2NiR092Y2J6dGR5L1VoNlMxL2t1M05LYnZSbWpaYmkvODJCL0lS?=
 =?utf-8?B?WGpxQVFYNEpSY2k1d1Fqc250dUJLWnVYMzAyZ0lxNXdEQi9HaVpIU25kRW9W?=
 =?utf-8?B?RGJkQ21SQmE1d25sU2ttY0dYOXR4RlFOeGRvSDNNNnlIdHpEUmlCdXhrM1Br?=
 =?utf-8?B?RXFmRWNadTQwZ1pMUnhtTlBGN29TYlZjcnFXN2hjUml5UXNPTWkrSlgyMk14?=
 =?utf-8?B?Sk9DY1BsY1hsNnZjU0prdU5rNEdDRmFTY3NPQjlzTFdlSER3TzZwcDJzSHN5?=
 =?utf-8?B?RS9SbEFZeTlGMi9XV0pzM21qUnN3cG5ReUpVM3dtV1B5V3pJaDd5MXMvZnRq?=
 =?utf-8?B?S3pueU80SjRNemRJWnhVZFYyamhyZWk5NFpzVFNjWEM1b3ZaWTNuMFZmVitp?=
 =?utf-8?B?eGZTUzYwWHJrRU1mUmp2K2VCcEk4RWVJZmQ5R29ZbDF5QWlKV3lOYzRYZWVj?=
 =?utf-8?B?MnZrb1Y4Zk50V0JwSkMyQ0tEKzU3Zjd4cks5dFBFQWtwYUp4b3lLczliWG1a?=
 =?utf-8?B?REtKL2JKZG1QdGZRZThQaU9LMWpwU3lyb2FWVEkzUUNnS01NR1RSc1BOVFcr?=
 =?utf-8?B?OTdzSUhDSVl2dzB3RVdkdjVUdTFDLzZhc3hmVXRYQ3M1MlQ2Y1VSb1ZHT295?=
 =?utf-8?B?ckYxdGZtNnFReThpUHVJMVVZQTVhSVMxNWQ1empXSkRNQktnYTc3ZkNOQmg0?=
 =?utf-8?B?VlZMOEZneUpVY2JYOFYwMlMrVGt3UEZ3ODl5aWZ0dEdaN1RFWURhamoyMWEz?=
 =?utf-8?B?dmthZk5oQUg1dENENUlTRXhCMXh4M05VTHFiRkFyTTBTRjJkNXRnYjhTWkY5?=
 =?utf-8?B?ckd0ZGdxWkhLaXlkNE9XRHJPMlFBdnBEc0dXUEJHK2ptVEg0S0xMME8vMnZE?=
 =?utf-8?B?bDVXOVA2V0JLbmx3R05PUU04S2NHMkx0QW9pS0hVTUMxRWtrUlJuY1RsaDhT?=
 =?utf-8?B?ZEs0ZmZjdHhHUld2WXEwQkdxcU5YNk1iWCt4dHU5bHc2a1A3enQzYWlyb1Fu?=
 =?utf-8?B?QVQ5MjVYdnBZTkIxek80d0gzYUUrU3Zib3RHektRalkxd2Y3aXNMaWplVTUw?=
 =?utf-8?B?ZE5oQk9mbVRJbzhCeTFYTGtIejZwY0RDd001WXNZa3hxZVk5RTBRQUNRU0Ft?=
 =?utf-8?B?aVlpRjM5cFdNZUJQeml6QUIzN2dpZ3dGVkxuRTRqOWcyV1diRmFUazdoZWh6?=
 =?utf-8?B?MkpURUV4eitBL3dQMGl6ak9ETTB3cXRXZS8zRUhUZjYzTVpwRE0zSlNncmZo?=
 =?utf-8?B?WVEyQzIzaUFsRlIvNlVYSnMwUUI0L2kvL2hRVXJYdWJ3bnBKQi9Wdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4717debd-2093-4cea-9f69-08de763d82fc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2026 20:19:29.7145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OW467bJgMqoR0ZmwChkUmtdWZ6e/YPepY8q+Pn56xgDcTHEO7dQpBFYzuei3JYjxkUyQ2ztsRAN6wVmAfvwTwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8438
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72225-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[thomas.lendacky@amd.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:mid,amd.com:dkim]
X-Rspamd-Queue-Id: 40AA61BD8E2
X-Rspamd-Action: no action

On 2/25/26 14:19, Tom Lendacky wrote:
> On 2/24/26 19:20, Sean Christopherson wrote:
>> Fix a UAF stack bug where KVM references a stack pointer around an exit to
>> userspace, and then clean up the related code to try to make it easier to
>> maintain (not necessarily "easy", but "easier").
>>
>> The SEV-ES and TDX changes are compile-tested only.
>>
>> Sean Christopherson (14):
>>   KVM: x86: Use scratch field in MMIO fragment to hold small write
>>     values
>>   KVM: x86: Open code handling of completed MMIO reads in
>>     emulator_read_write()
>>   KVM: x86: Trace unsatisfied MMIO reads on a per-page basis
>>   KVM: x86: Use local MMIO fragment variable to clean up
>>     emulator_read_write()
>>   KVM: x86: Open code read vs. write userspace MMIO exits in
>>     emulator_read_write()
>>   KVM: x86: Move MMIO write tracing into vcpu_mmio_write()
>>   KVM: x86: Harden SEV-ES MMIO against on-stack use-after-free
>>   KVM: x86: Dedup kvm_sev_es_mmio_{read,write}()
>>   KVM: x86: Consolidate SEV-ES MMIO emulation into a single public API
>>   KVM: x86: Bury emulator read/write ops in
>>     emulator_{read,write}_emulated()
>>   KVM: x86: Fold emulator_write_phys() into write_emulate()
>>   KVM: x86: Rename .read_write_emulate() to .read_write_guest()
>>   KVM: x86: Don't panic the kernel if completing userspace I/O / MMIO
>>     goes sideways
>>   KVM: x86: Add helpers to prepare kvm_run for userspace MMIO exit
>>
>>  arch/x86/include/asm/kvm_host.h |   3 -
>>  arch/x86/kvm/emulate.c          |  13 ++
>>  arch/x86/kvm/svm/sev.c          |  20 +--
>>  arch/x86/kvm/vmx/tdx.c          |  14 +-
>>  arch/x86/kvm/x86.c              | 287 ++++++++++++++------------------
>>  arch/x86/kvm/x86.h              |  30 +++-
>>  include/linux/kvm_host.h        |   3 +-
>>  7 files changed, 178 insertions(+), 192 deletions(-)
> 
> A quick boot test was fine. I'm scheduling it to run through our CI to
> see if anything pops up.

Nothing popped up in our SEV CI, so...

Tested-by: Tom Lendacky <thomas.lendacky@gmail.com>

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>>
>> base-commit: 183bb0ce8c77b0fd1fb25874112bc8751a461e49
> 


