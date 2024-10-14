Return-Path: <kvm+bounces-28708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA8E99BE3F
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 05:37:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 912421C221F8
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 03:37:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4896C84037;
	Mon, 14 Oct 2024 03:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KPtVStWs"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3C928DD0;
	Mon, 14 Oct 2024 03:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728877069; cv=fail; b=EM7a6pZdkCZw2HA7eMCkFNEh42Ey4k0ygYW9y4KmJvvekHrTun4HuejO7PiJWwXvPkGJZTp91WIQMM9rbw+hG1cEJtGQ0fyhSnUXH9LtBJOo0N8p9huWkULIgfSZER/gEWkjlaKTHF9ugdmnfP8vmeSN6X8quRGA8GKLEQL36wo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728877069; c=relaxed/simple;
	bh=QPqvdoZZmKaFvv0GXA1VEIdBaDvNTTivC/F/bwvCd7w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WBMyenEvUh7PPY+gBCFQyjgwx23mwuZKtBxmEaRvRr9dII151Krt6zBKOx7Xpwf1++EHrWNzsBaoTZG7QDVx+dkfmh5jAXT2HhibS4nm3bucdZXdk5W7r91kOpb/jSiKreiVckvz+sW3C2B5qXQdSxrJQzCusG3phvjLaj9xNgQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KPtVStWs; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C2zWuc3F6vhu1Svoc3hhL67/HEuGD+wlWRTLySiPT4UobBXA87c6XNj71vPxBVBAaZ5V4onmgI5/Ooil5cBbj+hwvq4gDSOzJMfBPXM6LbIXrWLI1SDQJkS5WgBN66N0t8AWie3CwIQrJoDETOuk3NDQhrF9YgMeRD26JQkyG7sO/QHMqFWnhBCcgDUVBaVqIwnwGwchaMYufe12gvYPA8gRmbtu890QOl4HT+Yd8VbGR81wc+4qC/d57KjwZAd3qqPoIG6/pL5PQrnwSKdQOy96/o2atIh/jB74dHwxBd3je3rHzKYLaLZANLuFiTirbq15DgNuXRgcrbOlHo8iow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HcvPNAUwjMi25d02/HAVqi3LYDV66tPC9Cym5rwp/M=;
 b=Fbh3qYUJU8r9jEJW49slb9I/r2BJdkuPE5TCfoetEacMT+7HZxjZi3MoVJKrfm+WQz2QwPLxfY7r9Icb6S4eNKSax2yOb2TlyGLkjGvor4GlWQ5+nySkOy9qyLowTTQ2lL0Z0A5P82BGSlFTVHga7qkNvPTfFLkG7C8y7Y+d4jFFRDGnF4KP7yArqaPGLvQazexgkmIOlBXuuZOe+Ibfs+iP/mi1cQBzOTO5yNkp2Adi3HEID7eeVueIHVx0q0q8kmk/YIwbS8zaDtzD8jp2Dx3mnD8CbKy+UVLfDOGoVsoZNhs81qqZgQiAVDaWqUPJasHiYirrdjg2EuvA5aRySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HcvPNAUwjMi25d02/HAVqi3LYDV66tPC9Cym5rwp/M=;
 b=KPtVStWsyAoNUboy6E8q2l3wzAu4C+Hm8pCVkoBtcZH85m9vUrqnI4Y60dihS++6KIHEzB1lYxWRFwkVpXypI3zKMvOfqXgKGs+ctH+SSgC4UmfljrDcmSJ0yN9h/B0K7p5MfC0oWZlqSYei3QG8rHFCQx35ctwKNA4WwQfHHUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DS0PR12MB7926.namprd12.prod.outlook.com (2603:10b6:8:14a::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.21; Mon, 14 Oct 2024 03:37:45 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8048.017; Mon, 14 Oct 2024
 03:37:45 +0000
Message-ID: <769c1232-f56f-12b0-9bfa-6c203889fbc7@amd.com>
Date: Mon, 14 Oct 2024 09:07:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v12 17/19] x86/kvmclock: Abort SecureTSC enabled guest
 when kvmclock is selected
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20241009092850.197575-1-nikunj@amd.com>
 <20241009092850.197575-18-nikunj@amd.com>
 <75780a58-5070-e111-5d77-d29093305c8b@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <75780a58-5070-e111-5d77-d29093305c8b@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0187.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:be::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DS0PR12MB7926:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c3e30b5-9157-4296-76d2-08dcec0190fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bXU4TTliMzJCUmlVb3FHNWVQbUh4RDh6NFlMTjl0K2pkSldMQzg3UTFkUDBS?=
 =?utf-8?B?OG9UQ01CNmFWSTF4TmIwL1ZlNmhaL2VCMzhxZmY3bVpuRFVsMm1KUXJnVmFo?=
 =?utf-8?B?a1J2THFFWEpxWWxGdGFzcWJSbHJlSHFET1NSZFpmVWRQN1o1U1d0NEduSUhz?=
 =?utf-8?B?cGFySFpwWGR2TGMvdUt0YkxxQlpTZUtjdTJ0aDRLdWdqaGNyK0l6N1dkT3py?=
 =?utf-8?B?VzVIU0txUnlFZCtwSThPbXlVK3AzYnQ1amdpWTdZNDNrWDRHOVQ5UWhwR3Q3?=
 =?utf-8?B?a01mRjNMUWdjM1Jpa1RMeHR0Um5kbWlXWkc2TUZlRjZ6eEVWalJLVlFjTGZY?=
 =?utf-8?B?S04zRFNrdG1LaUx4SnJlcHdJeFgzaHRTYjl0SGk2QWYvdExFL1ZvY01RODRU?=
 =?utf-8?B?T2IrNGd3Nm9wSmpiczY1ZDgySEtod05NSGloYng5NWFDYmRPejdLcFMyL3k2?=
 =?utf-8?B?QlN1NWpRa3JmbWhJeHJuMnFXVThNdGNMelNxTnJDTGJUbnQwSlI4RGdFVTRS?=
 =?utf-8?B?QkVUdmV3NjkrcWUzYkJmeWQ4cjZCQmlzbERMT0J6SHBveUpuSDlMUXViNUMw?=
 =?utf-8?B?cENmdEtTV2VGb2FJM282aFF0RThKT3R4ZzlZTC83TnI3Qm12RVpGaHhqZENE?=
 =?utf-8?B?UnI3VVYvVXM1ZFFWaGEwcW9IUzhBcy95clJEOHFGd2VmSHRtajRLaDVOdnkw?=
 =?utf-8?B?eE92RTRheGhjMmRnMUlJU3F6MGExbXdvOEtUUGlGVzJsWldpaFJBSnNvdVRZ?=
 =?utf-8?B?Z3Q3WTAwWjdzU0ZLWjVSaW9HeVdYSFYxWHRpRTN6WGNKTG1WRkdCbkJ1d1BR?=
 =?utf-8?B?aGNSU2xXb1ZnTHhvbnIxcmdCSHloSldPL0RJRDlVQU9ic0RlOFpicG9wbEd5?=
 =?utf-8?B?ZklsQitXVEd5cU1oSS8zTkJQTTBrck5nelplenNNTG01eWwrNlZqOVczdkN3?=
 =?utf-8?B?TzUyeG5wdjNpMUtjNEtXVmh3MVlMQUoxV3kyTjREeVhWa1A1ZTZvTmxNajFU?=
 =?utf-8?B?TC94NnlJcHY5aWx0djhxYkZsdzByVzU4MTNybXNuNzBtVXZhcUJxR0FlMDM2?=
 =?utf-8?B?ZWZ3U1dhcVRvUFJ4NTNlOUFQbmVkK3ptRy90S2d5OWxITHV2M2NndldhelhC?=
 =?utf-8?B?TDNoNXZ6OEMvU0Fqa1AzNzk1dVlFdk1sRW1yWkNKU0dSaHpMcDNRckJHbEZj?=
 =?utf-8?B?ZzQwVmlqbExyYVVzaFJLTzRURUxaN2V1UlpQcXMrQ25iVzBZN2JYZmhNcC9X?=
 =?utf-8?B?YVA1UWZhQ2kxdHFkZGxkYmFsRVBab3p0eDBEeWlBUFM5SE9VWkU4Y0NxdEdE?=
 =?utf-8?B?L2VVZ3FmYjVTSVZpeWtwZks0NGNWcisxaFlQYW5FN2RjZFpmcjV4dVB3eS9M?=
 =?utf-8?B?NWMvYTlGemxZSkJQeTdTRjZ1ZFF1M2FVb1lyNktOZ1VDakVueFFIclE5R05k?=
 =?utf-8?B?bm9yL2RLc3hmV2dJV3o0OWRuNHFNT3F6T2pSd2VjRmdQZE9pd2s3alo2TjhU?=
 =?utf-8?B?YWZnblduUkJIR0thSmlWOFU3QzFnVjZFcy9OTGdxN21MdFVLcmFMbk9NQXho?=
 =?utf-8?B?UFhoNkVmR0hsR2l0WlRZRjZsVlp5ZW9ldThLdnpGWTZtSzhlQkhmSGFIVDkw?=
 =?utf-8?B?TnBTWjcwVFJBSnVpRm5rb3pwMHRnWEt1VmNqRlBpaTkvaFNwQVZZeUkyd0Zy?=
 =?utf-8?B?dTk1ckdSekdnZGo5cjR3ZDJUWm5TLzduSGc0S2JLQ3R6d0lDdktHRzdnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elI4d1RNSS8yU24rODFad2t2RG91RUV3eGhCRk03NjJyUVdaOFNsckJBcDVW?=
 =?utf-8?B?OHBrMFpON28rUE5tdVBpODVxWk5zOTg5ZUpGYUR4SFUzcXBDYmxnVHZUT3kz?=
 =?utf-8?B?RlN6YXR0bTNQOTlXZU5jRm5HMWh5ZG44TkxlT1paN2t0TUcrODNhYkQ3VU4r?=
 =?utf-8?B?SnMwOUpIUGNlMis3NnI2T2Y5SGFpWGhkNk9MNUdsOW5ESjZUYTMrLytCbTE3?=
 =?utf-8?B?WHU3UjFrYnVLdHVSNjg2a29vbWJVc2cvVURYRCtSNEVHQzBrOS9tQmpFSktL?=
 =?utf-8?B?ckNodTJzRCtvT3FNc2RsOVgyMmVPbFRuTWlmWUQxaTIxbHMzOTIvL0lJcWFC?=
 =?utf-8?B?bmlBaFA2WU5EUDJwVG9HNlorYzlSbkw4Tm5qa3VpcW9EenRjMmd5RGZ6aDNr?=
 =?utf-8?B?VzNKTDViaUpuUUNzMDk0SmlQcXJmWHR1SnNySFYwVXpOdnhaTUFpWlgxdmt3?=
 =?utf-8?B?N29SS0xpU3R3YlhSTmZKL21SMVJyaVptUi9TNkg0NzJLbmgxa2Y3T1R6eGht?=
 =?utf-8?B?K09mY1hyRTFhRUFWOFcwOVNST3B6b1FwK0Y5V01Vb2VUMUxJV21kUUFGZ3Fu?=
 =?utf-8?B?dlY4a1BRZDNyT2pQL0JwZ0xCZW1JTjhoTjN6T1lsMmtKdExNajVxdzdpdEJw?=
 =?utf-8?B?Mm1RZFRtcTVaWVBTcjBJbEVnZ2szMUdkMnF2YUZkWUhmMlAzMEp0RGF2MXA0?=
 =?utf-8?B?NVdjTlJtbkFCZlYxc0s1cXhNRjBhdVpVL1dJb082VEQvR0hFQ2RRS2lSTGlx?=
 =?utf-8?B?V2FJbTdqZUsyZmhZc0xxaUlKQndOSDlNQldRVDNiay9qTmNMRmFCLzNHZHkx?=
 =?utf-8?B?T3E5ZEtCMjJVYmpzN2J1Z0RpSktXUDVwa2FSSDBtSmFKQlVXYzJsK3cyYk5n?=
 =?utf-8?B?OFVYSHRzVHk5aDArWjFCZW9SdW51ZXdOUER0RWFXdjBvYlJjS2ZiMkxnY0Zq?=
 =?utf-8?B?ejhsT3I2dnBrZzJicEJ2SkRMeWxDSmw5eW5iaFhITlFpbWt5Mnk1N2tmb2Yx?=
 =?utf-8?B?bzRJVzlObFB3UGxPRzdnQWhCakdqNlNMNCtCb1ZVcVNlQ3l4NUU3c1cwdW52?=
 =?utf-8?B?WXJUYkZ0ZUtBVGVvMEdHYWh6MFhGY2tnd2JxOVNLVVNWQytIM25QNEMzalJI?=
 =?utf-8?B?TTJuTGFlWFBzWDRPL25qbWJ6MmZsa3owMndhMEVBbnlYd0lCM05GWDlnT1Zm?=
 =?utf-8?B?UFhSWVo5cllEdDRkSDB3bExPY3JaMWJTcW14YXVaMWU1RmZ6cXZZL2lKM01J?=
 =?utf-8?B?cGNNeHNBUHR1bFRqYTZUcjA2aFlMRWg4ZFkzK1dFWTdVVEIwKzZXUm54eHJT?=
 =?utf-8?B?MkR5akhuR2xJN1hLVWdSQ3VLQjhudFhqR2xHU1VPWCsxRWFOTnFhTW9NYnk2?=
 =?utf-8?B?T0FISXZpYTJ4dExiaklyZkFpWjEvREpqVTFzaGlPTDltNlRqbCt3YUJJaVZY?=
 =?utf-8?B?ZjZEditWcWFZQ2hNVGgvL0V6aWY3SzVLZDVqNVdqSDZjcVQ0OEY0NVZaTkhn?=
 =?utf-8?B?bElpQXE2Ymc2NWVlaFNUYklFSC9QT0xsOEkySHhwSTFGKzk1SWJMK3NPMmNL?=
 =?utf-8?B?blZYQTR1T1BsVm9GUTNoTXh3TW5KRFB1V0NubjJIeWNJc2hKQ2xObUh0dTJC?=
 =?utf-8?B?b1pSbXBkblYva1oxYWl6QnFMaSt6VUE4NnhpTTQ3d0psOERDRy9TZzlOMDk3?=
 =?utf-8?B?R3V5dlBZbWk1d1AvY1V2b0p3VWcxb3A1dGRTTWhGK3puQ3VNc1hVVldyOThl?=
 =?utf-8?B?aWJqeUN3QkFZTS9xcHFhVGFycWVEVVZmVml6UVVyNFBwT2dsbmw0TnBreks5?=
 =?utf-8?B?L0J5V0NBREVnQ0JOUmpLRFROWlNwYk93QmZpYW16NDlJZkhwMDVYVmV4c3l4?=
 =?utf-8?B?NVZyUzhuYXdhN1RzUVpMTU5xZlE5RDBXRGxSU29tcGhDWmdnb1BMektJcEJK?=
 =?utf-8?B?MGdaQU42MHY0V2lqSFhjb1FBN0swMFRUNk5nOHB5TSt5WVlSR01wOHRZc0FG?=
 =?utf-8?B?NENza21KSDRWYnB5TCtoMjV2L2dQbmhVTjUwaFpRV29lNjJHakJyaWNLRmFx?=
 =?utf-8?B?ZERhTk96NUFwTUU1N2psWU9Qc25NWTZsSXpaV282SW9aUXhkbGdlMzB2NmZJ?=
 =?utf-8?Q?hYAKEQ5ccBq7fC6yjPeXo2VZR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3e30b5-9157-4296-76d2-08dcec0190fe
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2024 03:37:45.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1dwWMJiu0+qrrX6R7Nw8+V+DcZl03aNhswqNc0YMOKVkmJ7slsROn5IFf1bD9PZV2X7ZpVUlQPFOiutj9SiUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7926



On 10/11/2024 1:19 AM, Tom Lendacky wrote:
> On 10/9/24 04:28, Nikunj A Dadhania wrote:
>> SecureTSC enabled guests should use TSC as the only clock source, abort
>> the guest when clock source switches to hypervisor controlled kvmclock.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kernel/kvmclock.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
>> index 5cd3717e103b..552c28cda874 100644
>> --- a/arch/x86/kernel/kvmclock.c
>> +++ b/arch/x86/kernel/kvmclock.c
>> @@ -22,6 +22,7 @@
>>  #include <asm/x86_init.h>
>>  #include <asm/kvmclock.h>
>>  #include <asm/timer.h>
>> +#include <asm/sev.h>
>>  
>>  static int kvmclock __initdata = 1;
>>  static int kvmclock_vsyscall __initdata = 1;
>> @@ -155,6 +156,13 @@ static void enable_kvm_sc_work(struct work_struct *work)
>>  {
>>  	u8 flags;
>>  
>> +	/*
>> +	 * For guest with SecureTSC enabled, TSC should be the only clock source.
> 
> s/For guest/For a guest/
> s/TSC should/The TSC should/

Ok

> 
>> +	 * Abort the guest when kvmclock is selected as the clock source.
>> +	 */
>> +	if (cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC))
>> +		snp_abort();
> 
> Can a message be issued here?
> 
> Also, you could use sev_es_terminate() to provide a specific Linux
> reason code, e.g.:
> 
>   sev_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_SECURE_TSC_KVMCLOCK);
> 
> or whatever name you want to use for this situation.

Sure, will add.

Regards
Nikunj

