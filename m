Return-Path: <kvm+bounces-32928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF5D9E1F75
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 15:36:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FC42280D67
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 14:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09F7E1F7083;
	Tue,  3 Dec 2024 14:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XDwvM8nF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917583BB24;
	Tue,  3 Dec 2024 14:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236545; cv=fail; b=JYeaGJJTLZP22yR88zbsRjW4sswf6SsS9GR14IXIsP3S9zMSaf2RZ/NjJdegvaoluRVFtjGO8+ZIgfGP4KDd77h6V+IANg+BFff4KfuQt/u49aS3kMdIkZUjzDvHgBjDuuaV4zFqsEIlHhvKkkjLe+/hj3WG7g/OKwfvwBVVt5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236545; c=relaxed/simple;
	bh=K73PXyuX+BcvdoEUXfNag8dG7gjIdAHCxXEMSFDStn0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JCmTgyixMRJLSNXfr1vAfgrkQUcnhNPi/ePJgygX1QCVg0Fq8WK0n14NfWG7T31JtV3Xngvd2SZ37fA4sgn9565iA1xfQXKHZXxSzfog1QLIRGs9QzvDq+KBr6LpXkRCHfK3gDERqHH0PtdiRnj7uBXGnfIn/bciT93+rLcw2rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XDwvM8nF; arc=fail smtp.client-ip=40.107.94.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JvGLFdDPfrNvURWOOkd7+csCwwXQLtybEBUPgo+vC+AcaihNmvdxt4VELq3Kt22CnDgQiLFEqEJ5LWoapMTmR3/pt8nMC/BQev0WFLLqJm55H+UR53EKoJu663wJkEv7POrPtH635coF32z3PqwrR3WkSAVqX5XtNnrhhU1UPqknmo6Qrn1NQVrcnwsGq8w+Jy/Y2JkpH7Yzq7AEmlvkuhWCqpfhWWmCUwXFIqKARDYRbTbfIeO1mkPlM8sd6SGXx0iNUd5s/dn8VxP1LaVg2zEf/9+JsDQNefOCdnzhurLR9kBb5YnBkqHdnZon7oQNlUdMbAoum53cLYPmTiD3Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cajs3iJMaM07EulFIXiv570bjc0YWyOpaEMLTItDA2s=;
 b=f4dolwwuWHpgMcEn0v7osxpg64+zIQyE+HCdfooXl2kyX0Xt8ji0GV1ffDej78UIkgxoC9BJwxRJj/JfGkj2MMM4K0Npi/7rFSlHU6pMV+FOWkpm9CB1qpugCgg2fq7VlKoMxGOJaHzFsCq9qUlnCkMCVrNOVoi7K/MRw7BRuWjFiF14fAaiDCbv9fgG2juUZ8BvaSmqLZSXAPp7qYD96Q81xYJB39vH9K9NFHfHNTfisaf74VIBhvFZyrOLCsIP2nCc18jjImREhITDQbj3OIVypEiueNWEXn/dwRPPRbL0OP7vIfHsHT1brKM/TanOtDSSHhYJyOAarZzX9AVRdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cajs3iJMaM07EulFIXiv570bjc0YWyOpaEMLTItDA2s=;
 b=XDwvM8nF63TR/kqePXtq5YXH+H+XSTqU5jObYjkym+66B16UYhCinMxt0MOQsmPgWHXu4WUsyDUtvvxWDW8p723sN82WZLgMsO/XItLkgqXZEeDo7JgtDX8Sfzx92fvaj3ss4NiffNaam4xjW0+t4xErSCJGDkaCOcQ+EIgYjaQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 IA1PR12MB6017.namprd12.prod.outlook.com (2603:10b6:208:3d7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8207.14; Tue, 3 Dec 2024 14:35:40 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 14:35:40 +0000
Message-ID: <891f0e65-f2fa-4e0c-a59c-ef97ea00ba3f@amd.com>
Date: Tue, 3 Dec 2024 20:05:32 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-2-nikunj@amd.com>
 <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20241203141950.GCZ08ThrMOHmDFeaa2@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0214.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::9) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|IA1PR12MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: f419c424-1462-4e6c-41cb-08dd13a7c291
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWw1dUxFT2xvRlpGSTVNNkRFRVZXZVpCL1FWN01XZVJ0VERDSEpxMk5KZlE4?=
 =?utf-8?B?YkJaR3dLS2dFVWd3alUzZHlsOFVYbFdadTZ2Sm9FMml1U3Y5aW5WenlmZHNy?=
 =?utf-8?B?V29Zc2FEMmo1aFZrMjl0ZkFNYjR2TkJrTHJ6c3NKUlp6b3Qvc1B2KzJnUjdH?=
 =?utf-8?B?cFNZaFNVRnlQclBIUnY5TXBQZDB0dEVUTUNLVHFtOEFmYWJiSkNMR1I3ZTBI?=
 =?utf-8?B?cXU0VEJNR2R6YVBaYUFsdjFCdkNmWFhGa1RPNjI4b2hHOU5jeUZlOG5oM2tx?=
 =?utf-8?B?VFpFZjVKMFg5UzlMUm93SDBUdFhvZkhJZU9FSzNyK0FSTzNqczVWOGsrc1Nt?=
 =?utf-8?B?UkxrcFdBMW04NXNZZjh0Q2VhRDY2WFZoeE5HVDZvWkNyRjlnVGNpQzh3Z1Zr?=
 =?utf-8?B?VDA5cVdwQ2xLd1ZRNWg1UU1mRk5vRHpkckpFWlFCY0krZFNUbEZDY3IzR1cw?=
 =?utf-8?B?bTRHZTZCT2p1Z2VrTXpTTU9NdUVuYzhKOXc3UTlEbW0rd2VwK0Eza0tXaHNt?=
 =?utf-8?B?VDF1cG5XNElVZ01oRUcxWXVzU0drZFBZRHQ5ZmwyN3Y5M05jRGordi9OWFdZ?=
 =?utf-8?B?WEtjRG5pczgzYk5BNThZWDJWYkI0blR6R2swZDFJSHRadjh2ZjVBRkpOaU1n?=
 =?utf-8?B?NGtWZXFISkRnRXpra3dzSzZtVVZuRVFiQlZTVnEyQ2VqN29DSFNQSWdTWTNY?=
 =?utf-8?B?RTJwSkIwOXpBLzlicW1rMklZMk5UTUtaWkhMTzJEVGZxeFczbjVudUoxMTMy?=
 =?utf-8?B?QzFjV0MxTjdaQXJsTlM4bjR4a3A4VW9oWTF4WHNXSXdJRjFoZGpVRHRydC94?=
 =?utf-8?B?ODZKRzdJMFIrMFdheEJ2bThURjJETDJvMEdlSmJjL3F0U2ZGY2dzdWpqT0JO?=
 =?utf-8?B?eVM3ZVV3UUp2cC9JdHJVd1dEU0N4UkZxTWVOYlhaZ2s3eDlVeVZoRmIvWkoy?=
 =?utf-8?B?SDMvYzNIQmE4NHJxTzV6SnQrZTd1WGNHc1BnanlxTUNWc1RaUk9tbXlXV2N4?=
 =?utf-8?B?ZDhLamh3Sm9pRDB4NFRvaENBMWMySUU1bXRLSkVtNUZRY2hJTGdWa0lsa1Qx?=
 =?utf-8?B?dGJFbHRxVVF5V3V5cFg2b0wyQld6OHpQZXRlVDZIT3JhK0ROZzdodUtKZzg4?=
 =?utf-8?B?S1hpakRuYTc3bDJab0pKZzdqWE5NU2ZZODg0VnRpSE9vaWgwcThSZS9oYVRm?=
 =?utf-8?B?TTlWSFlQeHlkZngxdDN3eWdLNzdRMlNycWs1dzl3TmE1NzJkRlJnbEFyQjM5?=
 =?utf-8?B?WE56dW1OeWd1MDJYa1dNYnVIT25hTFprbHl6WUswU1RUOVozT0xOa1FYNE1n?=
 =?utf-8?B?dHdTaDMrd3MrckFGMGtNOHg0Rk5FaXBNZ3cyVnc3ZEZpa3dkNzV4bHFlMVhj?=
 =?utf-8?B?THVkWWVld0ZnMk5HdVplYjRMWndndFc0S2hxSkJLSmRncXlGOHdHWFRYWk05?=
 =?utf-8?B?SWdxSWllUlhBRGtySjJwdTliUlJnVng4NTZaUW9sUTM0MG5wbDBXZUFtdXFk?=
 =?utf-8?B?T0VjR2hTSU8yeEFPNUFmMjhvd0VnM0xxVUpkUEdFY0hONVRZZ1ljQmtLZmdT?=
 =?utf-8?B?SUpLTkc5Ujg1YVl3d1dvUHZrZ01iekp1TVVjVHBtenhyMmMxVWlHdjdTajI4?=
 =?utf-8?B?V3FUME04U01MWnh6MlpPaVowc0JyTkVsTCtRSVViU1BmTEx2dHpNNnc4dkZF?=
 =?utf-8?B?ZGoveWRWUVNsTTJCRytVUlk2cFNqRzNXSUJqdHlnUWk3NVVXQmdJUXNWaXRr?=
 =?utf-8?B?dWVENWh6Z1lLVENqY0tTNEpRazNOU3A2SWJ5VXFFQUFMdG9zenVodlp2SUhE?=
 =?utf-8?B?M0dyanN3SDdQTG1xc0FRdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHZ3amh6WnkwdVdVbEZsY0twdGwvTGY3MjhCcGlvZ0VmalBjMERvOUYzSkh2?=
 =?utf-8?B?V0U5ZTB1ZlYvM1VoNUY1ODVkRUlxd1JzTENBQXEwL1R5T0gvQzZpbXRIdlRz?=
 =?utf-8?B?Ym4yUlBCMnM4MWlCSUxVMmhMQTlWNVVYR3FzNFdjTEF1dk5JblljNzc4NUxI?=
 =?utf-8?B?SVNGVFA4Rjg3SGl2VkJwQTAvU3ZDcjNCSmRjdzRJNjRySnFOMCtGbjZDT2V0?=
 =?utf-8?B?MmNGMXBDaGc3NHV1WEtkQkE4RWZXK2pzQkpTY21xNzg4MEVxRGNJY1hNV1Ji?=
 =?utf-8?B?ZG5nRGd6UVJ3VGVtK0NEd25ob3RvNDBya3JkWXFCbElLVkpLa20vZlFnLzdR?=
 =?utf-8?B?TmgxUjhMd2czWTk2UXpkSDcyckludUhNb2pYaW8wN25UVVBWWkg0YnlNZGlm?=
 =?utf-8?B?WFBXUUhYM3dHUkdLYnpEUHJ2Z3V6ekVVeXQxRVZOQlFTT0pWK2JoTGJlWlQ1?=
 =?utf-8?B?UXJ2ejFOaWdZL2NFdVVCL2ozamtoN1RBbFROTUFDTXVWcld5UnRvNWhzU2g1?=
 =?utf-8?B?U2F0WStPajBId1ZlNzcwaHQ2Tk5lNTVqVWZWUXhYM1JaNmNUaWFlS0MyWlFy?=
 =?utf-8?B?OXIyUjJnbGUxek50cjg2eUVIYUhZT0pzcGl1QjVMSFgvVjZzVkxjSkkrYTQy?=
 =?utf-8?B?cWU5czlNWjhzYmp6elExUDlHakE0YWx2aXYyMGtNWUpnVzJSeDgvakNTVWRp?=
 =?utf-8?B?WTErQ25USSsreGdFeUFiNkFBdTRoNUxaMExhVXliZmVQaE9kbkJBSGhlQktE?=
 =?utf-8?B?TjB3ZXZjTFkxbEdBMTNPYmxXYURkQzFDQml1bWR1MzVtKzRHSW9HajJCeStG?=
 =?utf-8?B?czh4d1VlTlI0VFozb3hyZFRYTXRkZGh6T1pyUWdjRWJuUXFVVE1zSWYrRkdy?=
 =?utf-8?B?dU5ldVFOem5rWm5wdS9wN1Z2UUkwK1p3cEd3dXNpMVdycWlhdTFXbU03Zmd0?=
 =?utf-8?B?TFBuNHNXWFZoVi9FWU5qQ3BhM2hIMHJyR2phOWtBc2liWWVPSlRJbytPM0pR?=
 =?utf-8?B?QTI3V2RqYkllS1FtR3MvMlNHa1d2OVd0UzJ6eDBkd09vRitkamowUHRiVzcw?=
 =?utf-8?B?SkVBODFiN3lkMjdyc01oditReDNhbFpHOUpLOG5QcmhVcEdYbE1ucUpNai9i?=
 =?utf-8?B?NDkwODYvVFZmWEd5U2ZvcFBLdkc1UGE2KzA2Vm1XbjdRYU45eE0rbDdldUlR?=
 =?utf-8?B?d0RBU2ZjYkx5MWoxNE9oSDNxNWZjbDlLY0lyUy9sZlprdzNFVGp2dVA0K1FL?=
 =?utf-8?B?S3ptWmJHRG1JZVp1NEtZUDJDZEkrdzU1QWx3cjhaVXNaWEZSczVEVUhrMlFt?=
 =?utf-8?B?emluT1BaUmNSeExPSStyd0thWTB0MWhreFB2OE05ajkwSE9XSnVKVGFUYjRk?=
 =?utf-8?B?S1ZKNGhLeDVaMDcxamJBVnpwcm1VNnRkU05xTVgvdFN3d0dndHJ2ZkxqQVZi?=
 =?utf-8?B?SkkxWDdqTllZV08vYTk3emdiRmhwbGc2Rm9pVUhYNHcreG11R2pBVHZTT1dV?=
 =?utf-8?B?SjRvTlEwVjVNcmFMR2NGcmc0ZFpxSjEzRnNpMGxIdGZ1ZzF2bmRjb3FuWjMx?=
 =?utf-8?B?U0kzYTVZQ0VQY1NkQkVJbjNRSHltMUxxTzIvT2RUN2lvaE1pSE5ZOVV1SFBq?=
 =?utf-8?B?RXpLbmZYTU9FQ2pGNHQ5bWtGNlRUWGFjQUZYS0ZsN2dkbllQczIvMW5saG95?=
 =?utf-8?B?R2ZzTHVNdnVNVStwNTVlY0hwaFpocWtzZGd4MDl6ZFBTZ2xZZ0thVEMvTWpT?=
 =?utf-8?B?Nm5JeUtqVWdqRzFDSkwvZjZsTTlDeXlkQmNLU256M0p1OWY2S0NVbG4rdkRV?=
 =?utf-8?B?MGFqTzdaZEZmMS9ReHY2VzdweWYrMzZzU3ViZm1EdVh2L2xxNC9oK3VIaE5n?=
 =?utf-8?B?RlVtaU9TZWc4bXdsT0ZvVXlQbzZUbXlFV3NXSysyNnMwNVZwK1dRYU8wczhx?=
 =?utf-8?B?a3JQdXdxbi9EZ0FFUnlKUXF2TW5nbkZ4MjVPcmxFQVNudExMWWNndTlaTXky?=
 =?utf-8?B?enFlU0lkV0xNVlBWbDVFbXNNakVETFBaT3duWDNmdGtUOUVmNGlQL1Z2SGhy?=
 =?utf-8?B?QVZ0U3BLOTA1L2JucXNBRkphL0RvWlVlMUZRckowNFZRNzFIbWNjbUtyNk90?=
 =?utf-8?Q?d9xjh2Km4EUq7JMYVHGwFIkWq?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f419c424-1462-4e6c-41cb-08dd13a7c291
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 14:35:40.5661
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uj8s7BDi7nMZDUhxi1hoBKkAmJhnMUAKuKhNraSLYAQc1DJbQ3E0TrquPRtEor9ygKgbLO89aCkXPbZLfDOVow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6017



On 12/3/2024 7:49 PM, Borislav Petkov wrote:
> On Tue, Dec 03, 2024 at 02:30:33PM +0530, Nikunj A Dadhania wrote:
>> Currently, the sev-guest driver is the only user of SNP guest messaging.
>> All routines for initializing SNP guest messaging are implemented within
>> the sev-guest driver and are not available during early boot. In
>> prepratation for adding Secure TSC guest support, carve out APIs to
> 
> Unknown word [prepratation] in commit message.
> Suggestions: ['preparation', 'preparations', 'reparation', 'perpetration', 'reputation', 'perpetuation', 'peroration', 'presentation', 'repatriation', 'propagation', "preparation's"]
> 
> Please introduce a spellchecker into your patch creation workflow.

This is what I use with checkpatch, that didnt catch the wrong spelling. Do you suggest using something else ?

./scripts/checkpatch.pl --codespell < sectsc_v15/v15-0001-x86-sev-Carve-out-and-export-SNP-guest-messaging.patch
total: 0 errors, 0 warnings, 569 lines checked

"[PATCH v15 01/13] x86/sev: Carve out and export SNP guest messaging" has no obvious style problems and is ready for submission.

Regards
Nikunj



