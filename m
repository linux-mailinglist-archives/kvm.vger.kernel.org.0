Return-Path: <kvm+bounces-33514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 574FC9ED942
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 23:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFFCE188528F
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2024 22:03:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A2C1F2384;
	Wed, 11 Dec 2024 22:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iFZs11u+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B185C1C4A20;
	Wed, 11 Dec 2024 22:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733954498; cv=fail; b=UIvmFIlm9YBl2FOCiylNYa5dmPygH9BQgNKTltU9DST/Cqm+ZmBqLetVNFtIciOtMe/uERbOMok6wABo5r0zoSNZuxF7aMc1KRE5z2OEIkG6IkHL/4HL80BJ7TS2G40Mua3yZMP0v+M4xUjdZHo/8Sc3FPaHlH+q5QOta8k/mYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733954498; c=relaxed/simple;
	bh=LrlmrtC9u7bXGwU4cYcPZPDfNc1V5POd1dPdw4GFSCI=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=S/+etVUNGlca+hIAMpAiUgxCuZqe+gjG4YFC0rhgRxc0e6rihs0EU0rseyv2LAKn/UqZH1HfvzvMcclfxPBvrKI/CMGksof9VRXplSo1ssetMVHSrPOPki+FfC1OfQa5jvfD9CJtRAErbHRnAiXnO3mVN15JjsoJMW+1GSlKLdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iFZs11u+; arc=fail smtp.client-ip=40.107.94.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AvZ4i+G/Xhj7TLc8pdbk9Dkk5fgO3UnPkIOnypRKzRSBI+e2rVIjzZxYQw88Tt3ZSOHEGsJCeCIf8BM+rHs3UOU5wvoA00ygSxJIfOqZakNGyQ7UdKjhkUGIeKL1Oz4T1GPd4ciQVhjVpha2LVWqvI0Xk/7cW+aVfkDWnvE+RwjIubtCPbjNIeO0px42knA7ST6KGgypSt4ubthnxFEELfQdiLwoGcuJIfq5abVRL9FSIF2Lyc2apNsGOyTXdPPgwgOv/lIzpEnP2L72Cso034phkX7WvQ64bOZJBpOkDET8L+cHD6nmwHweFDNufuIu0pXkBIII3wuYKdr9TRrNUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZanpAL/SHl9wehL2EcrAkqm+KS6K1/2askFpy8yBIM=;
 b=svGtvRICTaD45XIoE4W5BERRyjGIbe/dIcZMQhAvBOLYPAOvvb7cWwNnE58QyMSvQQ89dp9cEQQTy4TUKDhieIxh/Z/k2+ANlzRvr8lQSZ2MZkjUHXNEmhZOCOUhtRkXnk9+zifeY0cRTJ2a+VCYRGdXNi8tuGJyGoKLuGbXf7582bT1Ur1vk3ZjUbx0NaNSDImrHh2GJ9RTB/Xc18hrfBbueaQoAUij33v+mB5zwdxdP2uZJsELLmUVIedWg3A+99kUtTk2/Xz8qNACVmKwOheXuXM5rmETi7J7gc4pf+DpfDL840fCBZXvzxajxE/b2SLXdo3jVT7EJ+sSQe7JPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZanpAL/SHl9wehL2EcrAkqm+KS6K1/2askFpy8yBIM=;
 b=iFZs11u+v2UCldLfn39DEGZHYqd7g1X0CwTW4XeMDMJHKAJBCtHGL/uR/bV6Bjhb2Fbq90B2jhR839Gx4CMljdQEhQoMdLviSb331uPGJRp7zhr/Ne9MCBBt1d0lGpcf3olBD29+/LO640o5/T+Pho+qnpuuqrEozxsiQePChSk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CYYPR12MB8731.namprd12.prod.outlook.com (2603:10b6:930:ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.22; Wed, 11 Dec
 2024 22:01:33 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8251.008; Wed, 11 Dec 2024
 22:01:33 +0000
Message-ID: <984f8f36-8492-9278-81b3-f87b9b193597@amd.com>
Date: Wed, 11 Dec 2024 16:01:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: "Nikunj A. Dadhania" <nikunj@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-5-nikunj@amd.com>
 <20241209155718.GBZ1cTXp2XsgtvUzHm@fat_crate.local>
 <0477b378-aa35-4a68-9ff6-308aada2e790@amd.com>
 <15e82ca3-9166-cdb4-7d66-e1c6600919d7@amd.com>
 <20241211190023.GGZ1nhR7YQWGysKeEW@fat_crate.local>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v15 04/13] x86/sev: Change TSC MSR behavior for Secure TSC
 enabled guests
In-Reply-To: <20241211190023.GGZ1nhR7YQWGysKeEW@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:805:de::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CYYPR12MB8731:EE_
X-MS-Office365-Filtering-Correlation-Id: 039abb14-5e0d-46f1-85cc-08dd1a2f5fe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OHhrRjZoN2ZaNDFMMFVCTWVHRFU4cUhZY1h4ZHdYQjBoOFJxa2MzRG9JaHVB?=
 =?utf-8?B?OVM2Q3J6M1A1alpQVFNYWXJHV0ltQ1VCK1BuQVF3Vi9SVGVFT2twb29tRkZL?=
 =?utf-8?B?ejVSNmxoOUZJZExJWGxMc3FSeUFnV2JJYTA0L3VZaGpqNmIxMUpEVnNYc1Zx?=
 =?utf-8?B?QmtjQ0hMTUUrek8zQ1ZBY1VMcHJldm1keE01bDNQTUROcnp4bUtwOTBGNSts?=
 =?utf-8?B?a0daNXBuWkxxMys1eWIzcUNDVjNYSDJaNHc5aGJQcXFJbW5Eanl5TlFLMTZJ?=
 =?utf-8?B?L1FMZUlzWTFwRnBncUtkTnVtcFlqVjVRVXNqQmUwUHo5dG9pRU1Sa0lGdTdp?=
 =?utf-8?B?MEdsd2c4bTRJTC9Nd0hTRXJ3VEpEbkJySXgzNXdNa1hZSGg0a09uOHBFWFYx?=
 =?utf-8?B?RUFRKzZkL1JmYXZhQ2toM3BBcWpUZ1VIaHdLcXltSm9PTlFlZGRpdE9XbzlU?=
 =?utf-8?B?RnRPSk8vZmhtb1prdFoyMThMR2lWRkg0dDRQNGxyeFlBMHZEMmNDTU1MenAr?=
 =?utf-8?B?MjhTRVc0a0k3NG0zWDNtQjQyVko0anBEemRQcWl6dVRWWkxpZXh1Ly9obVZw?=
 =?utf-8?B?ajk0K3B4dDlyRUxWemluMUVmVXBvdlVvYnF2eVBDZmU5bzRDelc4RUdJVzR0?=
 =?utf-8?B?ek5EdUdVMWEwMitnTVNKYmhoaEI3VElqdjhzTyt3OU1IRlpWNzBDRVBhejF2?=
 =?utf-8?B?VFc3ZTBzTk9scldGR3dSTkg0bkc1Wlhrblp6WjlWVlpzek1TbEVhOHNkZnNo?=
 =?utf-8?B?bGNta2hORUQyemIvcUZuWW1PVjhPZEpIL0lSTjY1b3MvUS8vdmUyRmpTMUU2?=
 =?utf-8?B?UXk0MlJsK2orYllCMllCN0N3bjU1ZVRxbEx4c2FNL2MzaTA0YzZpV0wrUkUw?=
 =?utf-8?B?aUovaWFzTmpOcHlVK044N1gyYnRQdjVqWEo5dkhWdlE2YjQ1UEw1WkV4WjdM?=
 =?utf-8?B?Y3YvZUUwaE8wSDlsWmFDUlVtQTVvT0cwWVBKVisxUXpEbGpNQ0FiZm95NzZN?=
 =?utf-8?B?TW1lajJnK2tnd296a01VaTFYNEpqM3ZyUXFyblhwWDl6NkRIUHVOdk5jM0hp?=
 =?utf-8?B?aDRMYXJNWVFxVnZraTVFcXhqTU80TEo0cU05aGZNZ3FPNlFDSHR1NjRUbUhq?=
 =?utf-8?B?Q0FpWnN1UktOOStMQnRIVWRoY3RuTzF6KzRxNWV0TTRXNnFteFppc1kvQXRX?=
 =?utf-8?B?Rk5hYnMvT3dRcytRZUQ5VlVjdVRTeWYzUWRZR3RVcXJ4M0E3RjBMSGxWaGxO?=
 =?utf-8?B?QXR6QUhtTzhGZGhWTUZZY1BlMEVkSmpIK0p3dGlKUHAzVWZIZnVPYkpPVzM0?=
 =?utf-8?B?ajVTOHJqN2NkTDA0UnM0UEFNcmQ5TW13OHNTUDZHcDNzTGpZbmF1Q3JrdGxS?=
 =?utf-8?B?WFhBSjlaaktCTW5POWxhUUZnVGJuY0haUyt0TVgvekptU2dtbnlaeUppZEN1?=
 =?utf-8?B?YTBGVmRYM1VNb2JQUENoNnY0c1VwT0JrakY3elFMRUtHZEtVUGhtRnppeFAw?=
 =?utf-8?B?OWVVQWp6V0VWZGNUSlVNL0I4dFk5dWtIMVZtNjgwaFVtL1g2Mms5L1ZGVWM4?=
 =?utf-8?B?ekZDOG9FejgxemJRQWtQUFI5Rm5oZ0ZLR0xybjk4bGVKUHg1TTAyYVFoQ1pn?=
 =?utf-8?B?U0I0ZDJVcWxQYlNPaGs3STVIbUdXNDMwbHF2ZkVCOWZWUkFrRDcycFdyM0dT?=
 =?utf-8?B?cEQvbmtCQmorbm5uTHBVVEI3cWd3YXNrMnpZVUZ0MlpmZ1dlQ1dQbkdvdGpj?=
 =?utf-8?B?eEpGTkcvTFBuZTlqdjE4cDBjU0dpQjljQWFKc0JKbHA3YlkzcHRxSjMyRUJK?=
 =?utf-8?B?blJ5NDdZWDVMekVSVjBJQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UW5seW9FNGIzVnB3Vi9TVXEzT1NSZWdjcmRNUlQ1OU5wdlZRcDlrWmJOeUh0?=
 =?utf-8?B?Q0R1amFNaWpDeHBSRzlnc1FZcHhadHFCdHpmMDIwZU9sbmlwVnBqdWJ0RFJs?=
 =?utf-8?B?Z1h2YVFmNG9pZWw4alJSN0c3MUF1b2YrMENYSWViQ2U1ZlN4MmZnOFZpRVNR?=
 =?utf-8?B?QUpNWGwrRmduc3dpYnFoeE4zYnNXZWN6U2VldUZYaEVwb3g1d2NKRGxNTlBO?=
 =?utf-8?B?YTcwYUhqbTZjbEZUNm01amppeVVmUmQrbVhkNStTN25URCt0bVZsR05ZOHhr?=
 =?utf-8?B?SElZMnIybEJVR1hzMHN5dnEwMlI1OEx0cHNyZU9lNmF5MUJwUGluTllMdHRR?=
 =?utf-8?B?NVNsT1Q2WEJQS1VReDl6Wm9vaU9xaVcyZzh0RURFbHZIZHB1bWFBMVhleExK?=
 =?utf-8?B?blBCSHNvU25tM2s3WVh2MmMvU2E3aTBhRk51TnE2dklOR1lUWWMrTDErVGg0?=
 =?utf-8?B?Vml5Wk0zR0dWUEx1dW4zUVQrWHFubVNUb2dPOWxWUGFZUHdBZVhNMzRDcUMr?=
 =?utf-8?B?TW1LM09CeTJpK3h1dFZvRUhOZlo4eWoxOTVaZlRCcHBvMWVEUW1RKzk1Nzl2?=
 =?utf-8?B?QXBOaVNlZUE2elN0bFhDcW5vK1VoRUNwQnhETVV4QlBDM0pjSkE3NTlIM2l6?=
 =?utf-8?B?N3lYMUY0eWZPUlcvQkNJaGlaL0xsTkw4bjY3clhoZFZiZHFSMHJQcFJuNzNL?=
 =?utf-8?B?ZjB2cGMvMDI2OGNSTm5vT3RsUVk3VStHK2JGUGN3Qk9ZOFlVdFRnalk5cFh4?=
 =?utf-8?B?VmFnTHNaQW1yY1FGRFgxejYvSWs0UjkyRkZZRHFidStNYlUwSnNKN2xVNVk5?=
 =?utf-8?B?UmQ2NE5KeWN1aTdMVTIyOGVGTk95VjRDaStHNzRmWUQ4OFVlUGt3MVczTVk0?=
 =?utf-8?B?R1R5YjZVK1lxTElGRE5Nd3k1MGFXa0w3c2E5YUFheldZQ3FKa3hjbVRqdVVs?=
 =?utf-8?B?WldjUlM2OVFPcG9KNG9PalpWTi9xS2VtV1M2NXA2d1lYVU5kd0liY25UMzRF?=
 =?utf-8?B?QzRjM2h4UWd4VjJHMUcweU0xT1hrb1VRK0FRRFYwVTU1OHNuelBJZGZSYnNB?=
 =?utf-8?B?MUhPQVdWa29BNVlPTW8xUy9mUDFxMllibElGNkQrTnc3eENFSWhGRGtuTjNt?=
 =?utf-8?B?K0RoalZ5TURyRzBYdmtVdGVkZFRZRXdHNW5meTAzMnYzMTFNM2V3LzlGd09L?=
 =?utf-8?B?WllTN2V1ZTRqbE15aWpGOWZNMGNMem1reVdsNWFESXExUHd3RWlhNy9JTHJL?=
 =?utf-8?B?VDJHUW9TOTIzeHIycUtlVXlPQVlyT0ZCOCtBYjhrY1hpVmJkWFNyeGQ3Sms1?=
 =?utf-8?B?Y2JIKzZ0VE5HancvT3g5K1hkYlJYYlBtaFFOMk9uNDQzNFJNUEdIN1RUWUt4?=
 =?utf-8?B?NzYxeEFiZEM1NUhqcW5yU0FnOFIxcE1mYXpNaGxHTi9lczZ5WWdPZTBKT2FD?=
 =?utf-8?B?NVlLblV1NitOT3VFTUVxUjhia3RFbmNldHNrSW41b3JmSzNNNGZlT1N4d1Vh?=
 =?utf-8?B?V0cxTktEN290bTBVU3lERkRETko1TENOVUpwekpCUVNIdWhMWnRoRTZpaDBr?=
 =?utf-8?B?VjJGVHZNZlNGZnRmaUhkS3I0d0gySXFBSkpRTUNsM0xKUFo3Y1ZJbUwvRE5n?=
 =?utf-8?B?dDROVHJOUFF0eVpGQ044WmFNclRyV1N6Tkg5RGJGQ2c0eXZ5MjVlYm5JMVZO?=
 =?utf-8?B?eEtuUXViNlhocnY1OXNEdnArMkI5cWxDaVdEbjFzK3B0YkR6STJ5TGlyci9Q?=
 =?utf-8?B?ajk3MnV6VGhiNXduSlhIVk9aMExpa1phSGVmc1BQOXZZZktJWXlxRG1KOU9Y?=
 =?utf-8?B?UDFaKzVBZVRQRVRoblBqV0NHMk5QMjYxSDY2N1FrQUx6dGYvL29EVzR3bnNX?=
 =?utf-8?B?ZDRaK25uV1hGaWNEeUl3dU5ZWlhhdTUvRnFoVm9EMWdBVkxhNGlhUllkNVJH?=
 =?utf-8?B?L1cvdDlCNzRFWEhmS29LUE5EeDNWWlBsSEUwZGo5U2hmWHhRMFRCaG1kTFho?=
 =?utf-8?B?VUZJNEdkY2FHL1FjZ3ptVDF6UGtjZUU0UFVmbEpzZCt0NGVHc0ZWbFJ5T3Ba?=
 =?utf-8?B?UURpbTdpeUNiMmxZdG81ZzZsdTRmSk1CUURTb0NpWGJydnJOdE1rbllKRzgv?=
 =?utf-8?Q?hXKPiEINNxliB7ffieuRswwnP?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 039abb14-5e0d-46f1-85cc-08dd1a2f5fe5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2024 22:01:33.3535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYSZIkbpCjiFxUJixWSUmx9U3wZUju1VVOLwyvTUsM18Bc4yfU6Ln7BG0VKRVrWcec3rF8suTpIl8ePdJ9MMYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8731



On 12/11/24 13:00, Borislav Petkov wrote:
> On Tue, Dec 10, 2024 at 08:29:31AM -0600, Tom Lendacky wrote:
>>> This is changing the behavior for SEV-ES and SNP guests(non SECURE_TSC), TSC MSR
>>> reads are converted to RDTSC. This is a good optimization. But just wanted to
>>> bring up the subtle impact.
>>
>> Right, I think it should still flow through the GHCB MSR request for
>> non-Secure TSC guests.
> 
> Why?
> 
> I'm trying to think of a reason but I'm getting confused by what needs to
> happen where and when... :-\

It could be any reason... maybe the hypervisor wants to know when this
MSR used in order to tell the guest owner to update their code. Writing
to or reading from that MSR is not that common, so I would think we want
to keep the same behavior that has been in effect.

But if we do want to make this change, maybe do it separate from the
Secure TSC series since it alters the behavior of SEV-ES guests and
SEV-SNP guests without Secure TSC.

Thanks,
Tom

> 

