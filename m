Return-Path: <kvm+bounces-70849-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4OnzN4+KjGmHqgAAu9opvQ
	(envelope-from <kvm+bounces-70849-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:56:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6554912500D
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 14:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C469301E959
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 13:55:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D44C331235;
	Wed, 11 Feb 2026 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="VfQFmH1O"
X-Original-To: kvm@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010008.outbound.protection.outlook.com [52.101.61.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A43244186;
	Wed, 11 Feb 2026 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770818142; cv=fail; b=aNUla1c3ZSGnPR90zaI6nztNY5b97y+/gG4fTBzsZRVXIdJ+q8qy2JgGe/5ligknozGr1wVoIRbDbPJf9BeduHhqHg8yRcOS7W6X7hzNbRWHeN5kLbte+UChA8TBEfCMp0ioUEb/LOI4YuxnOsXKRcycrBn9v9MjkuvsPfldx0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770818142; c=relaxed/simple;
	bh=DBJKVaNvizl76RESdHDkKujbU53hQiiNsvMddljfI78=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=a1A5CJI/7IvPOwyGtnURw8jgmc2ea9JIULEQMazkXer0KmV9H9puFON1Cno8H9RRrm+p6BEwPu9luAa0rwkm38UV+iFRIczgK+cGVuxb4KuMx3/OEGijVUuAgxb6pnoYqYcDWXq8qDd3chfO5OhQ7TPJNUPvmrMWCOfKFnOhho8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=VfQFmH1O; arc=fail smtp.client-ip=52.101.61.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OSzGV34ig9JQ0jOfFFWR8AyRxkLYasq6KfajF7WhpHASoRQ9VniFErAOWhp7v7498sgMA3YAK3UgYp7UvfrOpY/5TmGllxokUOibQkigv+xtC8cFUGiv/op5b9xSu+PJHCzy/rA3E69XW7IrzxqrE8WIE8FJJnqciy+qfjjfcimh1gJ2RbYSq44dXtH534QUppdgZnNHaGOo6CF82kKAZKSNxNbaiMIkQGS+mv4KPT8SJRklqScLLpIGUkSul05dYzqPxFndfIaf8H1gUmaknuE028JUOcjg4QEZ340Ljq8sPOSkv2GhH/vD7zW1oIU+hnrJMypQ+31xsOvKEnpSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFE/VyLzaRZk58CL54Ep7h3C+X3F/lrAhGfoAYNAzWg=;
 b=pRL/7V4JqKfNoL0RoexWcXN3CYCd9HTq642iM6hnbbylwzH6uBORLO0oX6LC3TgC7GrxJvPCl4lrWenGJgKamvQa+c1mMJUfIv/dOne74TV+hgW+16wPg9T8HPGwkeQhLqRxJKsDcPbf83uzKuCuKKr0/niJ3ocYIqV2auCJxwTW6bGfsLLsoqLHV8WtnADme2qPeYq1vlds65QhbuoovAMqWO1liZ+GbYXQc7YnukXNG+vDRvI196o6wCBNoLSblYKpm4IE4SD8f1gN6RBPnOi+LiqjcyJWwZUbjo3N31FCH1vJy1Swo56lRJ+ShrfkNurOTPFDIEordLntGwgnnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GFE/VyLzaRZk58CL54Ep7h3C+X3F/lrAhGfoAYNAzWg=;
 b=VfQFmH1Oo9huXczCLKANlbLIrNrMYzLgsHTEYjeEyx5VYr8ZItOD39fo49h+pRKRGJGu3o6b9AB354Q0k1GP0j1SDQuJ7gNghCTGHhIc6CCu7nUk7ShiVN+WDYIkNB1ltBw0FhQzGg0QDZ/UIVkY1v/c42TKT+iLzsPB7aNYCGE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by LV4PR03MB8236.namprd03.prod.outlook.com (2603:10b6:408:2e0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Wed, 11 Feb
 2026 13:55:39 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%6]) with mapi id 15.20.9611.008; Wed, 11 Feb 2026
 13:55:39 +0000
Message-ID: <5276256b-9669-46df-8fcd-b216f3d3e45b@citrix.com>
Date: Wed, 11 Feb 2026 13:55:35 +0000
User-Agent: Mozilla Thunderbird
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, ubizjak@gmail.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, tglx@kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/2] KVM: VMX: Drop obsolete branch hint prefixes from
 inline asm
To: David Laight <david.laight.linux@gmail.com>
References: <20260211102928.100944-1-ubizjak@gmail.com>
 <2af5e3a8-f520-40fd-96a5-28555c3e4a5e@citrix.com>
 <20260211134342.45b7e19e@pumpkin>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <20260211134342.45b7e19e@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0646.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::15) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|LV4PR03MB8236:EE_
X-MS-Office365-Filtering-Correlation-Id: d175fc1e-a4ad-4637-588d-08de69753d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cytKK2JOc3JXb2doQXovRFhKWUtjelFRQ0h4Z1RJWUkvYy8rL0FDdXQ5akVG?=
 =?utf-8?B?Qm4xNkl1eDFNejVXdnJKY2pJc1ZUdTRUZG1ySVFpYzd0Y1N1cXFQQ1pVaUZJ?=
 =?utf-8?B?SXNCYjZ4Ym0vK1I3YTJmMjdGOTZFNEsza2ZKd2RIY0JmVHdXOXNXSXBwNisv?=
 =?utf-8?B?Z1pMUmhzMmJHMWpRQTZPY2pYOW9iWEpJVXdGZWN0YUpseXBMY25OVVZjSDNm?=
 =?utf-8?B?UUEyNlRoWFZvbzFyYU5Ua25YbjdpNTB4dld1ejBsU1hLY0diZHhLRUFxVzJV?=
 =?utf-8?B?Q3dSNytNUHJPVUd6dldxS292MHRzektiYUdlR015cEZrWkVFdVptSnZ5UEpF?=
 =?utf-8?B?L0Y4NDFCSUthaG5RSXNsU2l3UVVOUWoyZ2gwbEh3Z2JYdkRLS05MQWtORzkw?=
 =?utf-8?B?WnozNlJ1U2UwOFFrZGFNeFFyeUtNK1QrRktUZEx6UEx0QXloK1Z4TkQ1MXVQ?=
 =?utf-8?B?WHpPZFB5T2E0QlBhbWpacVUrTU5tNUVYNkhjWnQ5MHZVejVmdW1EM0JYNVpS?=
 =?utf-8?B?UUprNXJhclp5YlFEZWdNUlJMMTFuZ291VG9jeE9mOVRXZE8yNTBIRi9DMnRU?=
 =?utf-8?B?M2VDS3ZNOFF1OGJJZ3BSV203Ujdjcm9pNE9aWk9nZjNLd2xVeHRwMGVlNEJ3?=
 =?utf-8?B?ajZ6THZjTDNqTHhXUGtxMnlNdUZNVVNHd2J0amh5TkhCQjNpMk9DVjVETmhy?=
 =?utf-8?B?NzU5ZmdQU1ZLYzFKcjdudFNaeDdzYkhoNWtEamN2ZlhoTk1jKyszTlp3akkr?=
 =?utf-8?B?SmRyS1FWUUhBU1JrRjU4RWVrUFVnUjJYYjdPTFl4TGp2Y2hxWEJhM1JLdTBj?=
 =?utf-8?B?dFh3azBVazUyaWhLNUFKZC9IdTNlTVJtSHNYRS9lbkpYaWwrank3NHpaRXMx?=
 =?utf-8?B?dDJHZHR2MWQ3WHM0dmkyMGZBRTdwT0IySVc0VGM1ZUVnaXF5U1RURlYyUi9Y?=
 =?utf-8?B?cFdoOE1EL1NqMVBjQWswMmtZcy94L29pb3lVdGNoQ3grdWJQWlBJTGdwVmhJ?=
 =?utf-8?B?SWNBRFd4UUpTcGtiMXV6d2tyM1pyY0E3VUgxMU1qOU02a29vRFI4WDhrMUQ5?=
 =?utf-8?B?cTFmVERFeTg5cXk0SXZTMFNUSnY0Qy8rY3hTL0RlQjBVell5M2FWcGpZNzhT?=
 =?utf-8?B?dTNUTTlrOE1FYjNsOFZmbTVhVUV1RG5zYllrek83SGlENnJHY2J0RFg4YzBh?=
 =?utf-8?B?YkNpWXo1TEZWbEZnWkZodTJFT1RtQ0tJL2RPd01hZVVsYTNLQk82L2ViRFJ1?=
 =?utf-8?B?dFE1QlVBaVdwVHZ0K1NBYXc3MmlFaFV4WnhRVWFSdndySUR3LzV6MnZONjNx?=
 =?utf-8?B?SnY0SktnQS9NdjZPL3doRmYzTnpGb3kwOVM5b0NnQm4xMDJDUFVYN1IvMllE?=
 =?utf-8?B?Q2FnWWFXVXh0Z3RTMjBnSXFPdHNuUUVhK0hrZXdIMlZyQUNZS1lCbWVUWS9y?=
 =?utf-8?B?Wjl4QWswbURtcnJIQ0hhanRHM3RvYWhiK0FjMUFhU2JLN0VMNFA5UWNBK0JK?=
 =?utf-8?B?dzRiNlN0bklyMS9pbVlEdVBoWktSbEpNR1pRMExsc3lSdENHWDFmSzJBcWRx?=
 =?utf-8?B?SHRLQkdteXY5Mmg4VGVMSkhPMnpGM29yd0w3S1hVNm9IcUErcjMyMUhBcHJ3?=
 =?utf-8?B?dG5ML1h6Ly96czZjTFdDRkpUQVlxdlZRbHBNMWE4VXIrOThrU3kwTlpFbjl1?=
 =?utf-8?B?QUVXeXJ0d201K3BqejRkTVhtTjVaMXhwQjIwS0YrYjY3cm9QWnc5SlAwTGZp?=
 =?utf-8?B?a1BGd3RnUTNOS0Q2YmwzQlpwZWF2NnlHb0NqWHd5K1RjanlVMkZhS21RZXlT?=
 =?utf-8?B?YURkSVZ5Nk1uVWJLbEp6NjdZNFNZZmh5cW5EcFl6T295UFdadkR5RUFGTXFa?=
 =?utf-8?B?VmRJcVpiendRMmo5dmxBRDhDbTFsb0ljcjRvMzR3dnVEUGVtSUh4a2dTSWNl?=
 =?utf-8?B?UUVUY21PNTl1UGNQV1NpbjFtcmdzWkVHcVQ5bTA5a3dhNzVxdGlFcFdLYmNL?=
 =?utf-8?B?aUFLZFR5bERLaERjZXhvY3U0NzJkdURoZU9MUmhWalZqVGxlb2Y3Rk0yYkZy?=
 =?utf-8?B?aWdxSDJzeWpCZE5CMGdkVUp1UXBWMWM0N01jQ3Urb1pvb2FkaWRxcGw0cEZy?=
 =?utf-8?Q?0tH4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZTZhOVNzWlM3ZUU2V3hKT0lNTU9XcGw3OWdweVZPUHdKdVdwMU40Zk5LY1Nl?=
 =?utf-8?B?WGVySVd5VmZsdTVGdFNIaXVvU0FOekF4dXA3VFlYV2FQZUF1VGkwNVRtTGw0?=
 =?utf-8?B?aXk5ZlBjcU0zUXFaRmFqT0owK1o4TThsUGFTbDNUdnc2VWJndkhHZVdiQ2ZS?=
 =?utf-8?B?c0NqNm04ZDdUdGpGK2JWVzdjVEZ6WTZrc1ZXaDUzcGpON1V3MmtDeEk0WWNu?=
 =?utf-8?B?dlJ1L2pWS1htcVpXY0hyUnAvSWdtNWx0M2RKbDk3SUwyenZNZk1CaVZDQ3hl?=
 =?utf-8?B?N1B0MlJndGEvY1d3SUZMVDkzVm1GbUNUTENLWkc2YUJxV2UwQnEranoyY3JK?=
 =?utf-8?B?aFd6MFVoSC80RjRGWW9ZR2ZNNm9jc0NFWmlYSTRSc01IczNSd28zZkc0R1BM?=
 =?utf-8?B?aDkyeitRSnpOL2lVK0pBRThvcjJNU3Bscmo2UXFIYkh6akJzNVJnOEZ1Umc0?=
 =?utf-8?B?dzBnMmh0QS82ZllBWWFyOTAwOVl4ZS9OUmJES053TVpXYUthaUhXSmdHM0d6?=
 =?utf-8?B?R00vT2M5LzUySkMzWStRV2g1RHh3NWc3RnlXS0Y3dmVhOVNTaWhrK0J6MHZJ?=
 =?utf-8?B?aG9DVEFsRXMwWDZtZE1raXlWL2xyRzNkVWJra3YzN1grK0VyNVJWc2NmNWEz?=
 =?utf-8?B?VCtlM1hJN2kzYXFiSFhsN2FqSjQ3UFIzaXRmRTY4Tnp2Q0tsL29lZkh1TnlW?=
 =?utf-8?B?UEs1RE1GdHpiRlZFOVJDQnQvdTBnaHlXanhLNDFZZkVQcWVOZzdOUHExUml5?=
 =?utf-8?B?UXptWW9kcU9NWEVkNkc4cEEvZUd2VHAzaGYyWmtpQjlLbUx0WVJTaXQzRW9o?=
 =?utf-8?B?Y3BZVkZnSkhJMTBvZldPN2ZPeTZEdlp1ZGIxT2N2aVdGcUx2TjRGSWRwakFy?=
 =?utf-8?B?MFV3V0EveVUzcWhOVW1HYVR4Rm8yMFB2bERPWTdYM05TR3V1U0I4eW5Vb0w1?=
 =?utf-8?B?YWs4bm10TFhnY05ZeEQyenJuRzk2OFhWcUpZWVJ1NFdyc2ZhNndzaVN2c0pN?=
 =?utf-8?B?VnBkYUU0bkxhWE52SkZOa012SE5vY08rVjdYYjBqdCtIbXBYL0Fnc1Z5NVJG?=
 =?utf-8?B?aXJpa1Y0czBoNTdUQ0ZiSFpxdEEzMGpGVEoyQkc5WlhQZ2t4V1JkOTFpY0NL?=
 =?utf-8?B?Y2V0SWhNd0xlNHZXTDFDcEZkeUxFZURFelgrbTBzM3J2ZnQrSWtKUHZMNEQr?=
 =?utf-8?B?SDh0UEhTUlY5eW1wMFE2UC9qc3U3YkNUdTZuN2NBVDVXa3BpWk54d0NsSklz?=
 =?utf-8?B?YmdCRDVJd29pYjVNZHFBcWkvUHNTUkxiQ1hGMTM0a1g4em1DUk1OSzZpSENN?=
 =?utf-8?B?aVUxS2Z4cTVPdTlXMmhrS1N1aVZ1SzdUTGNwOFdua0xTODd3VnhnL05GT281?=
 =?utf-8?B?Q3MxY1ZiOTRRTkl4Ylk4T1FWS3dZaTU2NllqRU9PYU51UFRyMnR4Zm04QTRS?=
 =?utf-8?B?UmpZS1pHNUZibEVRUGgraE9Fd0t0bnBlMVhJMHQ4UXdxallPbGZzY2Jad0JO?=
 =?utf-8?B?T3p4NEgvU0ZLazZ4ZWYzakJZUGJKenBDZmw0c1JNRk5EeFBLM2VNbncwVzgw?=
 =?utf-8?B?UHh2TE5WWFhSN2lvdUphQlNRK09KcHM0RzdIMGdCQjQzeGNyVW9mNDBIMHNG?=
 =?utf-8?B?REVPMEpyMXRVOG1GSWhNSXptU1IzVG9UNUoxcmw4dUZRbWVhdjR2d01RMEZj?=
 =?utf-8?B?ZStxQjVNZndrejc5cmhpclluMUpGKzhtMkFKMERvUnJiZjFOcXhHVGJ3RWYx?=
 =?utf-8?B?ajRNUVJQSVhEYzVLdC9seitOdmNia0JBMXRMbXg1Z216VXRkc2dXTWV4VmhI?=
 =?utf-8?B?R3hFbzRTMEFSaE4zeXl1YnFFcjgvSzB3YXhFRlJzNVJ1dEZVTjg0YTg4SG1v?=
 =?utf-8?B?VFllZjQxbXlXeFl5RWZlUW0wazhKN0ZKUjN5SS9Zc3p4UjYyQUtGQmZJcExN?=
 =?utf-8?B?dVZocmRvVUhIZEpKWitNZmlGeXBBekJQd0cvR0dXSFBlYktSaUpLRVVORzFu?=
 =?utf-8?B?dFBXTnIrRm1uaXJrNm9DRnBWMVI3VDFrOXVNWmYzamhZNWVCaU5pem5Db1FO?=
 =?utf-8?B?akRFMktXQ21KWmt3OFJhOCtRSURKTlBaUDM2RUlYVFM1WWtrYTVpaXRpZVND?=
 =?utf-8?B?Tjk0YWZaZnh5NnU0aURQOGR1Tyt3TzY5Ujc5bGlxcWdDRHgvdW5kWEFVQTBC?=
 =?utf-8?B?eldZUHBIcW5NOVhTVy90MnpqVFZwa3pJbzI2R3ZRQVhtYnJuZXZEdTcra0Zw?=
 =?utf-8?B?eGhibXFVdmVCdExCbDBiWlBIejJEa2JNUmxoTGM1UFE1VWI4Y3ZRaGhPMkUr?=
 =?utf-8?B?UEZpRnU5WW5MQmRjbURiVnJNcWFqVEIvMjJoNmJMNUlYZ0p3QTg0QT09?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d175fc1e-a4ad-4637-588d-08de69753d0b
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2026 13:55:39.1117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iuNfwDVYbcyvkHiIy9f8TamcLiO0Pd6A+I2CJFccY4jjCZpkhyJi76NSGBGfrdL2U/FZ+LlKkYnKmIJro1ZSbHKLFxVjava/DEVjyg+iyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV4PR03MB8236
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[citrix.com,reject];
	R_DKIM_ALLOW(-0.20)[citrix.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70849-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[citrix.com:+];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andrew.cooper3@citrix.com,kvm@vger.kernel.org];
	FREEMAIL_CC(0.00)[citrix.com,gmail.com,alien8.de,linux.intel.com,zytor.com,vger.kernel.org,kernel.org,redhat.com,google.com];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,citrix.com:mid,citrix.com:dkim,citrix.com:email]
X-Rspamd-Queue-Id: 6554912500D
X-Rspamd-Action: no action

On 11/02/2026 1:43 pm, David Laight wrote:
> On Wed, 11 Feb 2026 10:57:31 +0000
> Andrew Cooper <andrew.cooper3@citrix.com> wrote:
>
>>> Remove explicit branch hint prefixes (.byte 0x2e / 0x3e) from VMX
>>> inline assembly sequences.
>>>
>>> These prefixes (CS/DS segment overrides used as branch hints on
>>> very old x86 CPUs) have been ignored by modern processors for a
>>> long time. Keeping them provides no measurable benefit and only
>>> enlarges the generated code.  
>> It's actually worse than this.
>>
>> The branch-taken hint has new meaning in Lion Cove cores and later,
>> along with a warning saying "performance penalty for misuse".
>>
>> i.e. "only insert this prefix after profiling".
> Don't they really have much the same meaning as before?

Architecturally yes, microarchitecturally very much not.

For a branch known to the predictor, there is no effect.  If a branch
unknown to the predictor gets decoded, it triggers a frontend flush and
resteer.

It is only useful for programs large enough to exceed the working set of
the conditional predictor, and for which certain branches are known to
be ~always taken.

Putting the prefix on a branch that isn't ~always taken is worse than
not having the prefix in the first place, hence the warning.

~Andrew

