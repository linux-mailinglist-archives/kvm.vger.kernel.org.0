Return-Path: <kvm+bounces-48776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD97AD2C9A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 06:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B44F6170394
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 04:26:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E90125E818;
	Tue, 10 Jun 2025 04:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PeMiy9ey"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0496725DCE3;
	Tue, 10 Jun 2025 04:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749529578; cv=fail; b=F103tybPu2GEAF8SWQw8ka1iRDoUJJVSnhvU4uauPtIYQg9kOYaP91krzwuv5Uqx72UK1G7QJbNKSUBLQup8RlPIolkHj4APqhYeBFcfY1tsEZRi6CX8rqQR/5ZJuQVWpunOOhrnAKh5kutr+OpvskU4ORjGkqbxkVqmYch2c8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749529578; c=relaxed/simple;
	bh=U2VO4AnxX+E2KqJPX/7lJZYJrbMzoSPJFEczNj7fLRU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rMijyMZnoeBJYfc4nJG1y1w27cBc5AkdFQpRnVJQswoFdua9R6aNYASQN75gnTgrfqiEeMvp3TqIMnFQM4ZtyS7GjJROiE3/u1otjsi1JVIqz7n29lybiWgLDrc5nluJsa4YoNuEhAu1JE/NtFPe/CvuR5grSOOXPhVj27o/XN0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PeMiy9ey; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tLH8R/FNhQnO1rbKXU+rV/17rl0IbWBvct/fY4N/o9nQIdyCZ3mffQTfEexdCLFOPoNQ4o5WxEyeNcbAr8/KDNmWiAnI4nP8+f2hOS+dz0WCYQuHmkDsBJuC+1EVvPjtqtWB7xpqqGjNusXMAfKGTlzO8ocuqIYj35ngSrMGIh7IGajxITWwOV6gAGa0Y/Gc09l75wffiWrBcFowilTVk+TtFuFaWGFVBnVsS2kIoNui/Me0T81zmDSf5OchVGboGBuw9tupznqhiCl09iVbzeeWo3UFQ8yQWg+x+CqonMprpaj3zKC9XTJzVB9ZSD6Xg1kpZsYzbvarF9dP2CNOLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=95m5lll3TBND6w23MqMdPywFL9WeqSEnL95qNYW9+iM=;
 b=KpCuhmrv5T11ggNpODI6iuMeEcONCQ8byQVtY0h1SST6vwoWz6ELNJnsSh0f9sP6JVD8WCYscEiF8wFUUFW5lncae7rfyFw3cOn7lTvYFXdOKYz+avN6oRQdZtSXFqfNusEvsUutVkwYzH0zMQ1MjeIQoSlLtFAshA+y2Vsr4W3rfAJg52VyzsU5Il7menkASbZvVZYYNUncBiuAQXSMZJztT5zNhCsjCdv4Hch2eVEloYvM+SJxbNGg7pIM9bCU7uGtrsBDVo/Sg/dPhwmqYfde9/H5bdXalvL5vVlqsqGiNv9/Ej8oAo4fmUpopWyuKM27HN0T5hzzTtdaltbeaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=95m5lll3TBND6w23MqMdPywFL9WeqSEnL95qNYW9+iM=;
 b=PeMiy9eyLVKk1RF9JSrNPJcePjeRxsbffHgqKUKSUXJbXn1t1BdrP1g2Wey0L/PphNOTVKZrVjLAdC3im9eCf0gxhU03lERH6ZSv4iTK0pDgB51l2Mawd4yJMnCQ7qZK8uIRtgj5vjQW31FuwCnKSEI8fybuQUubu8z0zdaLDd8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 DM6PR12MB4090.namprd12.prod.outlook.com (2603:10b6:5:217::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.37; Tue, 10 Jun 2025 04:26:14 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%7]) with mapi id 15.20.8792.040; Tue, 10 Jun 2025
 04:26:13 +0000
Message-ID: <175b29fa-40b4-46c7-b33f-ad6ffe89a33c@amd.com>
Date: Tue, 10 Jun 2025 09:56:03 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v6 07/32] KVM: x86: apic_test_vector() to common code
To: Sean Christopherson <seanjc@google.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com,
 kvm@vger.kernel.org, kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
 naveen.rao@amd.com, francescolavra.fl@gmail.com, tiala@microsoft.com
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-8-Neeraj.Upadhyay@amd.com>
 <20250524121241.GKaDG3uWICZGPubp-k@fat_crate.local>
 <4dd45ddb-5faf-4766-b829-d7e10d3d805f@amd.com> <aEM3rBrlxHMk6Mct@google.com>
 <aEM51U1RnYC0Dh_j@google.com>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <aEM51U1RnYC0Dh_j@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN4PR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26d::9) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|DM6PR12MB4090:EE_
X-MS-Office365-Filtering-Correlation-Id: 22d003dc-e364-4773-e3de-08dda7d6ef22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUdDaUFoL1g5UzBzQUtDL2xrVHhtQWF4TDJsckFFYmdFTXdoUXdKSXR4UG1o?=
 =?utf-8?B?MUs2ZVUxQVNyRUtBQ3RYem4vWHdlOWg5SEpQdTJuclhPamlDWC9zdmZJeWR1?=
 =?utf-8?B?QklsVFpRVVo2RzVSV1g3MlpKRTliMWo3QTNjMGN5bXpxRDU4MHRTRzNnYmY4?=
 =?utf-8?B?dDZCRC90K0o2VWNXeUtWRVdIOG01ZkdnRnhrdHdpemM5QXBGY1hRT21odk4w?=
 =?utf-8?B?Y1BpbDNGRk04anhkVWdlRVFLclR6QkxEQWhjUFV0aWlkcklJVTV0dlY4U2RB?=
 =?utf-8?B?MUo1RmlwRnhhUGthVU1HN2J1eHFzeThjMGdYdVpRREFadHlqUU9lTXN5WkVJ?=
 =?utf-8?B?YUEwL282YzJoeklZSjdQamxPTEdqMDUzOU5oK0hkZDZQU0hTQUp6cXZlSXlJ?=
 =?utf-8?B?MjR0TXVDa1dleWd5cFRienJKYit6SjFpY2E3dFIzQlRLb2NGVXZZSnRaTHhY?=
 =?utf-8?B?aU9vTC96UzloYU1QWWhJMWh0QmFZakRPVWpLTERaSll5ZC9GSXlaSlVNTDAx?=
 =?utf-8?B?bEtzWlZyb08yaGxQS2RBSUhId0hLanJhQjRLQVBUL3MycWNJUVJSdGphcWpS?=
 =?utf-8?B?cml1WDlxbEdiak10bmhlNHBFdlA5SVlkME9pVHhUbG1adUtQODRLQ2x2WXNj?=
 =?utf-8?B?Qm1BVWtKZ2dzaGwyVG1CUVNzOVk1LzNPWjhiU0J2SkNFYk1uNHU0eWZVbEk0?=
 =?utf-8?B?VjJpdVJlRGIxVTFaMjlFZFhWNzhUQURYQmhwRjNFdG5DamFNR3AzREV6aWdC?=
 =?utf-8?B?R0hJdlROaDRpSVZuSDU4M2dadktVdHZXcmRzUzNRb3l3RnBmQVhDV0FsQ0d4?=
 =?utf-8?B?U1lyUXNlUkVWYjJqNEIrMDQzOUVwQVRJZGgwbm5VSHp1SURYRkUwRTZkT1R5?=
 =?utf-8?B?L2k2cXZhMm1kbzZBV3M3RFlkMTV4R29vZHpTcGtOdE1JOTBuRDZrWGRLeDh5?=
 =?utf-8?B?VlcyQ1FQOHBWZCsrVkk4OXd6YzlDeXdqR1VoK1p1dWxjRVMxMytBd1JNbUZk?=
 =?utf-8?B?eUgyTjdYUDZ4YVZ3Z0gwZWVzQ2VMUFFhOFZEeEdSZm1uRnRJcG1nNDFpRjY0?=
 =?utf-8?B?V3ZMbXNHRElTNXN2R2JOWEpuaVNLay9LQndPWG1NekhpUzFIamswK3V5bjVn?=
 =?utf-8?B?eEhQTnM4aStYbzNPcDZVZVV3ZklHQ1MyamI2MmpNR2hCN1FJdWhZZFV2b3Ji?=
 =?utf-8?B?Q3JjcHA3Rkp0YW9VNENJdUJ4dCsvRmYwajVEQTJUbzZoU0ljUnpJcUZ6UmJ4?=
 =?utf-8?B?Z1NKR2tPOUFzdi9xSG0rSW0xT0VhelhLSGlrQ0pLYm85YTN5ZTdPWjAzY09a?=
 =?utf-8?B?RlhIYlZrS09hMExMdDNNdmdTajB6V096N1ExUGtvaGFNN0VGRmRSNmdlRkdh?=
 =?utf-8?B?cXJtWm1OdFFuWEMwZ3lsV3RsUExkOUNVUVZaV3N2ZVhGa043OEc2S0wra2Zp?=
 =?utf-8?B?bk9kTk52OXBkVjMraysyN01ZV0ZpUmhMamFTeE9aK0NQaUVMM1p3Qk5jTStt?=
 =?utf-8?B?RzFKTWhlc3NjR09Oem5YMUFYS0hUQ1VkSVJuSjhRdVA5TTBrcUNsQUFxVUFl?=
 =?utf-8?B?dFZFUElXQ041NW9ldmNLQTJTQ2t5OTJlclBUc0NKRFVaaW0wWU01WEN0ZlF5?=
 =?utf-8?B?K250RkNVdGJCMW53eUlvZnZHYWdnK2N0MHFpejhVcnFDc29PR1JFZ0YvZm9y?=
 =?utf-8?B?ajRyWXZDSmJnN0VPeVZHZ0hHVmZXUk90QkRzdEFmZlpMTjVNVlFnWmVUTUF5?=
 =?utf-8?B?WDNSWlYzZVZHQ2ZkSXlnajdsdDRrdDNUN1JIU3hXUHRlS1Q5c2tTTVdiRUhL?=
 =?utf-8?B?ZEdaa2FBSG9tZjd5V2NTRzh2UjRtUjNxK3RHSi8zRXVGQ1pNbWJ3RitaWk11?=
 =?utf-8?B?MVloT2FtYzZtejl1L3J4b0d1dmp0dDE4OEg5dGczYitQZDhOY3lBQzJQbU5P?=
 =?utf-8?Q?63h3hTueXOg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WGF2OVJ4MWcxUU5hZXp0c0o2dkZtSFlLWmoxSk9scDA4NDU0aFRLc3Ayd2ll?=
 =?utf-8?B?SVBLaFE5bERWTHdVRDQxbkg5bEJmNVZ0cHVsMDUrSUtWWHlKTlVCM2pvTHlh?=
 =?utf-8?B?SVMxR1BUdlVGSzNwQ3Qycm81OWQrNUdDb1lRUWtsTEpwNmlpcUdJTDhZZ0sx?=
 =?utf-8?B?Tk5LYndKWXJFdEF5WS9MaHVyeFcvVmhrVmZsWm5NajBoVDFGMzBRTzRVTk9v?=
 =?utf-8?B?bitCOGtxeGlYZGtMUmVETnNNYUpXemR3clgzd2ZjVk9pMWxaNDhrRGtFaHZY?=
 =?utf-8?B?QVE1YktBeTdDUnc5Z1g5YnloUHFPSnhianJYWDc5c2FuZ0M5Z3gvUEs5VWhF?=
 =?utf-8?B?dG16ZnYybTlwWitOdS95Qk5uVWdsM3JGL3hVVVVyQVR0bTRzNjErTm1aL3VX?=
 =?utf-8?B?eHp3Y3Mxem92NWlRRUFqNmxkbXoxMnMrWjhhWlhzTit2Umo3U2JPQTA2MlJ0?=
 =?utf-8?B?cmlYRGZmL2hYUzlCWGl0N25DT2J2ZWFGYWtadkVlT1c5Ny9FOHVFQmNpMkdH?=
 =?utf-8?B?cE5iR2FreFhHcG1YdjZ2T242eTBWcGh6QWRTK001YXV0SmJEdlNZZTVKOWdN?=
 =?utf-8?B?cHZ2c1NWZUhaUmNJaGhxajN0Vk4vbmhYZVJRRTVyTFVLNEFSa0V1WDRmZzJ5?=
 =?utf-8?B?eW1QdXVUNjROSUh1S1U0MHhMM1VvYllLcVpFaVU5Rzk0eGw0bzRFbEFYYm5P?=
 =?utf-8?B?cGZhNkFhdG5odmZSTGdjbXQrWExEaGdJdjE1Z2hYM3JPeHQzQUVEWG1HenZn?=
 =?utf-8?B?N2dFM0ZXNFBWQmF5TnhMUldtcWVsV1lzUFFVMjlyV0ZjbXh1dXp1Z3VvazBV?=
 =?utf-8?B?N0txbXlrcDdWa2pwT0JBUkhwRHl6TC94TWNpTWtrK0paSW8xRGl0bFY0NkQ2?=
 =?utf-8?B?SWUzbkNENWFSZk1HSFh1ZVlQWXM1em9ESFZKbVJJTTVPU2dPQ3BiKzJnU1JO?=
 =?utf-8?B?SDlnMCtNVVlTVlh3Y3hGTmpNVlk3czNVYjR6MDJodVMxaEowN1dkaFpWcnhE?=
 =?utf-8?B?UFRHR1lGZGxXeSt5d3B3RWFaNU9vL0ZMbW1hZnlQN1RSU3BsU0V3WWlyV3lI?=
 =?utf-8?B?eFpNL0Vla1d6ZDIxYkxsZmd4c0cyV0FFbVZRNVJrdmJnL1BPVlRuVVpxMkk5?=
 =?utf-8?B?VG9ObCtjZGllYW41REVJYVV5WVJHcCtpejBVNDRtcTJNVUR3TERLalNXT3BP?=
 =?utf-8?B?dUZ5bXBockcybUtJcVhOMWxZL1hzaDNSbWFpc1BCV2NJWGZhZkFXYlAxOXRI?=
 =?utf-8?B?WTJOU0xDVTBxM3pzbnZTS09zZVlCcjFtVGVkTDd6RXJ4SFRaRXVaODJuSllm?=
 =?utf-8?B?ckx6UUJaVUYxbXV4UVZ0L1ozcDNyZDRTQlVPc3pzSVUxdFlTblNmc1drSTQw?=
 =?utf-8?B?MjNtVjd3b05wVHhHRzcrSEErY0k0TnpuSHVOTEJOMjJhVXUxTTdjNFQwclI3?=
 =?utf-8?B?TEo2TzVHMGFXQUpORWpPL0p5ejJ3ZlB1RE13SCtSbnFhZlJIMHFTQjRtSm9M?=
 =?utf-8?B?cTFjbjVnclJrNlNsOHN3WktiZU5Hekt1NUFuU2lWMGQ3OTRuMWplTVBZdHBB?=
 =?utf-8?B?aWZEU3hnemRPcE1hMU9ZVGk2Uy9KMjRXZ2F6VWdyRmtEclVGdnRPalVuWWdZ?=
 =?utf-8?B?SWxpWUR0UG16UXo2R0doS1hWbWQ3aFNIWjhkWHN1N1pidzQxa2xISkw2NU5T?=
 =?utf-8?B?dktWcWJBNWY1dEV3V0QvVVpLbUpWK0RtSzFHczFjZkhyMjNqbVp5MWZyUmQy?=
 =?utf-8?B?NjJXcEFTMXJNcXVLeVluWUJqOFJUNGZTVU5PdEFrU2VPSTM4WDVUS3VrNThi?=
 =?utf-8?B?bm92bTc3eHVZSjBaeUM5SGVzajNnSGZEVFE0ZHJWczRjSEExMFpmaUVTak05?=
 =?utf-8?B?a1hoMkFqVTZJWnRRQTltV2NRbWhwYWFGRGxWakViZy9hUmRQRzJHVHgzVG5K?=
 =?utf-8?B?NUk3MUlzbjd1bi9pKzZ0TXh3TW02eTFQZ1o5SjRRRUV1em9RTEdnbkthZUJm?=
 =?utf-8?B?T2o4NGV5QVllVUg5TXZUekdVRmQ3MDBXTy9pdnluNmtOZmNMcFo4amxuUjVV?=
 =?utf-8?B?Zm0zRnp6ekRFd2MvR3pwVUtrRzhMSUpMdlF4YXlxc0NYV2gyb2dVVG4yUitK?=
 =?utf-8?Q?GFYxkvlc9qHghTwK+WGWy41s7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d003dc-e364-4773-e3de-08dda7d6ef22
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 04:26:13.7811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PFXmnYTO2teLEeUz1IVOL9G8jKmrVuEJxJQI5qHo5MieBm96gBLdQK9FkhVsmNEVWoSt5/IK/PJUtEngRBs6VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4090



On 6/7/2025 12:26 AM, Sean Christopherson wrote:
> On Fri, Jun 06, 2025, Sean Christopherson wrote:
>> Actually, looking at the end usage, just drop VEC_POS/REG_POS entirely.  IIRC, I
>> suggested keeping the shorthand versions for KVM, but I didn't realize there would
>> literally be two helpers left.  At that point, keeping VEC_POS and REG_POS is
>> pure stubborness :-)
>>
>>  1. Rename VEC_POS/REG_POS => APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET
>>  2. Rename all of the KVM helpers you intend to move out of KVM.
> 
> Looking at the earlier patches again, I vote to add a 4th:
> 
>    2a. Replace all "char *" with "void *" in all affected helpers.
> 
> Pointer arithmetic for "void *" and "char *" operate identically, and AFAICT that's
> the only reason why e.g. __kvm_lapic_set_reg64() takes a "char *".  That way there
> is even less of a chance of doing the wrong thing, e.g. neglecting to cast and
> reading a byte instead of the desired size.
>

Sounds good. Will include this in the next version.


- Neeraj
 
>>  3. Move all of the helpers out of KVM.


