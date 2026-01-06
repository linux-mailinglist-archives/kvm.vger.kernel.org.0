Return-Path: <kvm+bounces-67172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A20DCFA956
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 20:20:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EEA973097B7E
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 19:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21A533FE2B;
	Tue,  6 Jan 2026 18:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="Ygmr46ix"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012036.outbound.protection.outlook.com [52.101.53.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A472D3727;
	Tue,  6 Jan 2026 18:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767725549; cv=fail; b=oBjmbzm0WKSG4c2s3/uDd/wpy2aKwR+Q1/ACIZBXKMjX8eAL5u75O6nVHNDRtmSrGhx9jKDHIS9JxEZpBP2OlZbzEcidHYYo7rNlAB3SLyrjdPOEwW0uVFpM5sm+s7+XAK/wsFW3DFFTz/agYk37wReevJFpYuARxcoubobFHKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767725549; c=relaxed/simple;
	bh=B0f1idFmpF4n6KuwY6sjxDT35Sy0paFKHdza93i+91I=;
	h=Message-ID:Date:To:Cc:References:Subject:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MbLWMRe5LiXJZQ8SY3A/XRBzWM2ycQVy4vA2fC/1DjVLILPaUbJpa6swjT0xFl3DY8t6OyJUlsW2EUG3SmGwfG5/liDvfYwIpp4vHnJrNWvvLiaLXcpDkBSF9m8r4cWvQJEhvCA4SdMKa0CVvCqi/V0f7QcAqIS1i7Z30a7L54Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=Ygmr46ix; arc=fail smtp.client-ip=52.101.53.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MrggCcUFozHR89sdJ9OstrMfYaqTZM1LosnYXu7SCNBsH9cyf+UG+dHlbmeeWJKWHukW0/eZZzGNBTIJL3icEiW9VWyv8CFPHLN75V68DfDXNyYqUQLvWnrcjo/UWw9BcQMec/m7FftKJBqrEj450qq78MFTyb9xSAHSPAOsg2cErzjBiY360MdJu2ZXBV2z0AkakUxJ2rZegfLwhp48Tb1DlWABTA1H2JzR09XBJ1+jqMF3MsGgpAhaFr/MAWrYKZu4HwzQZYLgY4aQ2EcUIUm58Pw2hpT216SNbXpjESSt63Wa9Z4YnPyap4vK4B5geNevyp+q/ADxm1yF1+MzaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f1qfOOPSwjDLzbSuweXTfIYGCbY4bY4otoReskbQneI=;
 b=yHH+wqFcbUhsrDQdCZm9PKRSKL3RKor5dj9MGahvvGmGlX3IO0JLTQKnV/unNlwvr5+ESUNMtAxC0uywPUIIiMmSSWBEUr3hO/zNJLn3wsFP47wvyAOTHFTnmh1gqkb15onMUmIG9zifSr/c2kBH50QgiFIgEs6E3nfQLlJOuhvpGgRVx269n7tnK74IKTyCUtYXM5MR8itxZMxlnjktVS8bMA+5ApgVXWmfjpSqYlJvOFsvC1Ayi5YPVag2hcwDNPIcuKeShT4bHqabe12nPNv/2z5s37sPoC5zj5cpGjaNJP/BderETLZmp28fufIepCSQ09tFZ5BpBq5ODdQBtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f1qfOOPSwjDLzbSuweXTfIYGCbY4bY4otoReskbQneI=;
 b=Ygmr46ixHJPXgHBYFBJoS/wxqTz2akowc7Z6upLPTi6q+OpYeBriHx1Pm9sIXAUVDH1fQg2GzYhNq/C9q8DTK/BIzrQtgCzK+iD3bqndtrYaGDkNxsuEtqXGWCfg/DI07AzAGOXQDv4JEZsbjzzBBD5rugzSea658ZYGUKdQ5NQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Tue, 6 Jan
 2026 18:52:24 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::a70d:dc32:bba8:ce37%4]) with mapi id 15.20.9478.005; Tue, 6 Jan 2026
 18:52:24 +0000
Message-ID: <4c45344f-a462-4d18-810d-8a76a4695a6b@citrix.com>
Date: Tue, 6 Jan 2026 18:52:21 +0000
User-Agent: Mozilla Thunderbird
To: seanjc@google.com
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, chengkev@google.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
 yosry.ahmed@linux.dev
References: <aV1UpwppcDbOim_K@google.com>
Subject: Re: [PATCH 2/2] KVM: SVM: Raise #UD if VMMCALL instruction is not
 intercepted
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <aV1UpwppcDbOim_K@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0116.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::16) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_
X-MS-Office365-Filtering-Correlation-Id: 90d0eec8-8ddf-4c2d-0501-08de4d54bae1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TjYreDd4dEZJOFdOd1hyY0JzZUp0czBYTmlBeXpwYnFvSkxrTUNMTkNUV1hU?=
 =?utf-8?B?SEdqNmZGZ2JKdWJ4ekVMQisxYkY3a2h3WWtZTUphbG5XOHJSSkR5NUJaTGxI?=
 =?utf-8?B?YnZ3NmtpdDEvb2p1bVlWaWl5U1pBU0xibnBLL2poekhqOG0wZEk0dlRMVG1X?=
 =?utf-8?B?d2pkRlE0YzlDSzVFN3RYVTFVcFdlMi9Qc0J2N21pVHk2ajlObWo5YmlWblhK?=
 =?utf-8?B?d0k4Y2IvUTdMV2ZIQnNCNnp1M1dWNklIQk9sMXc0V1dReHF3YlZkNmNpbkdm?=
 =?utf-8?B?WHI4akE4MFNobHhMVkxubWZZWHNFVlAzbmNVelFyM3FISDJmZnhHb0VYT0Iz?=
 =?utf-8?B?UE5KUUF6T3ZQRUw0YkZRU245SXpFY0pCQXlIQlhGRlJBOWtjNk5tYy9ieVY2?=
 =?utf-8?B?bDlZSi9OYVEzcjdzTjdGYUZ1aFUrOENMb2tqK0lPZFpmZEkza3c0eW5PS2tv?=
 =?utf-8?B?SmZTTmZaNHhKcFNaQkxyb2xOYklGajJHOXArWWJHa05TTXRTeEJDQzNBb0JQ?=
 =?utf-8?B?WlV4aDFabFR5cUhiMG9YRVNTdHVxVlVEWkl0Y2IrcmE4MTZxZXNIWDZ3Q0sw?=
 =?utf-8?B?ZWEvejR5cXVnVUNJVU05ZDkwemh2MHd0VXF1M0V1QytjODhybG40bjdlQkJT?=
 =?utf-8?B?b1ZYTVhJUFNxQTR1cFpyTkVZWTFhVTVSSHQ1amV3eXMvSWpKVEQ4MW5VV2Ry?=
 =?utf-8?B?V05JSWJITldTNlBnOHVzVzFQUjZqTnBiYTlOd0Z6UTgvMnZwcVRCOUZwbWx3?=
 =?utf-8?B?Z1krdStmTkJsUkNuODQrUHNBZFkxUk16eUtMU25Nd3VHYUI3ODJZMTFMUnBD?=
 =?utf-8?B?YWMzTjg0bkI3UHF4R1ZkVWRIWkxJK0NWdXQwaDlZSW9WZHZyTGtXajZwZ1Fi?=
 =?utf-8?B?ckRobzZkNDdCOTBONU12YndTemFDcVk5RnlvSmZWd0VRZFpPQW41U25kWURy?=
 =?utf-8?B?QzFmdzR0M1Z4RCsyNWNueVVKQ2tYbjMwRWo4Vk45S1RDMThGWm5PTGR2QzQ2?=
 =?utf-8?B?Z1EvWEdZTDJBbDhsTlFjQTBVM01kUDR0ZjNHRk1kaVA2WThYTkdqZ05CRUNO?=
 =?utf-8?B?RHlEWXhDbG96cTZET3pHYzdRMWVEeXljTG9wQU1sKyswaldTbVN6RkNaVk5z?=
 =?utf-8?B?K0ZKcXZUT3VJL0cwUzRsWlR4Yno4ZkZVbzIzYmRyVGZHSEtKcnkwMlJpRGhD?=
 =?utf-8?B?QzVTdUhLNlNqVlVseVhCdWtRNG9zci8yQlRlOHk5ekc5M2VZcjNXaEVSZ1pu?=
 =?utf-8?B?SkZobTNYalpKNm95bG1aRmh5QjQxOENVSHBnblE4OHZXTDZsVENLaGdCRHVH?=
 =?utf-8?B?eTk3ZW9pRnMxVTdCUjh5K3h6Qlp1Nk1XbUhHR0gyV3kyTGRuYll6MURjQ0wx?=
 =?utf-8?B?UzF1N0o1Zk93NGFHNVA1QnFZYmpEOVY2RmhucFR6RnpzS3l1RW4xQ05icXBR?=
 =?utf-8?B?cmNvTHhtNE9BUVdWLzB0QWgxSHJvR3BBdTZxS20wTUFJak5zQkRpaDVZMXA1?=
 =?utf-8?B?TzRveWJrSGdVeDV4T2NKcjYvcE1LUXlTZVVhRHNZVzZZaVpVZUsxYTdFM0s4?=
 =?utf-8?B?b1B1byszRzBWcThRMGpQTHIyaDZCa1JDY2ZyMHQrVWp2OW9lVDRHM1RvS0sx?=
 =?utf-8?B?bzJHY0NkODYxcHQxbG9hTW1mcDcyWm5GU29VQkhKOFZ5SlNIZ3RCWFhPTjJF?=
 =?utf-8?B?UG1DWDRxR0Q2OTd4b0JqYkdBbm0vRWZBYlhWdFBMTGZyL1dXRVNtaVJpZ0kv?=
 =?utf-8?B?Zm5ieTcyVTFsWFExeW80bUhaUWwwcjgzTDJnMUhjOGl2aEljMjR6cGsxL2tH?=
 =?utf-8?B?MnB1NWZyTUx6MFpCU01IVzBnTFVoZTZoM0VhNHZnT0J6MUpZWDdDU0N4YWU5?=
 =?utf-8?B?Mzlham9oKzg2VGpRR0VzcUdIMjZRT2VEK1BUYWpIWnIySm93ajJ6R1oxWGhN?=
 =?utf-8?Q?Lqj7JCbFelCCA5CTLPTOKrFNNFQaO2eT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cnNoVGJGZVJvY0NjSGlCNUlOSEJuYTJiQ2N6aU0rb1Zqbm5pVkhIMGhLNGxo?=
 =?utf-8?B?ak1xbXNRWkFoZzEvR1NEM3lvNC9xdWVjTERxeDZhb0k1NTlhRTFIM0tkQmMr?=
 =?utf-8?B?RGhEdGZHTm5MbVFPbHJtZnNHSkx0YWJER0JhSlJkWk9TT0FPV2U0c3pDTFRG?=
 =?utf-8?B?MWRyVDRjSGovOXYzaGxXSHhMSi9xYkJYc1p2R0Zla3hwMUhmTm4wU0hTVG1N?=
 =?utf-8?B?cHNQVFpsS2hHRkFXUFpHVmdVSDM4VkZyM1hWU3lIZmpIeE1BY0tveVVDbHQz?=
 =?utf-8?B?UnRVV29lMndFZDNEelZIeXBhQnd1cGNUbmhrVm9CdUhrdDk4ZCtQcWhhOFRl?=
 =?utf-8?B?anJ1N3IvMDUzdk4wOW5nTFNGelhlbmxJeGVSeDY4bCtHQVZrOGFWVFcyZFVq?=
 =?utf-8?B?RVpqSWJIbUl4Nmd5NG5vWmFDdE02aFRUU1lIaG9JNmIzckcrekxTTU01T2dV?=
 =?utf-8?B?aFRvUEVPcWVtUmcwRDNnZEhHUGdIVHRrYWoreER6bTA3NVVUeGhEU0taVXM3?=
 =?utf-8?B?QW9pQzFERkxneituMVpMaXFVdVNEaDNXVzQyYzBSNzlxMXEyZ2hyNFJXaWRW?=
 =?utf-8?B?VzU5ZkRydXc4Y1YxU3plNGRrbi9seVdVNm1UY2w0TWJVOEJLSDRBYUhtK3ZP?=
 =?utf-8?B?dXlCY0hTbW0remcxQ3F5N3R5OUZMR0V2dDdxY3M4YW9NUnJUZ3ZRQkFxUHJM?=
 =?utf-8?B?YlUwV2NlOVBoSCszeWkzcEZkaUtWbkVnVkx1OUx0UGRtSmhuZi9tb3ExYlVw?=
 =?utf-8?B?QXdBYi84OENMZ3o2WXNlenJjemFzMklpZ25qUndKSnRGRzNwUXVQZ0g4RkJE?=
 =?utf-8?B?cHFIODcyYWgrL2NDTW9SaU9BSFFVUkhUekNZOURMWEdYTGpzeWI1eGVwU3pI?=
 =?utf-8?B?dmZOeHI3Wmw3ZjJIaHQ0T0crTHFlWHExTENsSG03ZzRpbURack82Zm95MTFD?=
 =?utf-8?B?Mmk3VFEzRFBOamJVMzVGRzNIWDIzMlVHbjNuR2tGSDZVSjdvNmpzTG1kRFF0?=
 =?utf-8?B?dVc1SVc3dVVVQzNwaldBMUZDM2VqTStVdlVQbmovZE5Ja0VZdVFLejFvbjhv?=
 =?utf-8?B?Y1MzcDlvQ1JPK3E1MFdrNEdrWW5QSjJnS0FEQUN1NzJndndDVE1uaHJGN0U2?=
 =?utf-8?B?MGdScnVIbFdQU3BSUGQzZDNmd2RqVDRGR3hhbnRMT3VJbVFIR0JYcGtXRmR4?=
 =?utf-8?B?NDFDZzNoRjVaQzRxN1BrcWRUMHVxU08yS0d5OUp5SWNNcVBiS2diT2pnREpq?=
 =?utf-8?B?RGRMYlBoV1J3NzhLdm1GeEpJSTlzWVpRZmQzL05rUWZVOUZUeWtHdEwyTm5k?=
 =?utf-8?B?b2YrclpSK3dVUm8zaHkzZk1adlBha0IrTkUyVEJNSXBPYUdVTWRJd3ZpbGwv?=
 =?utf-8?B?aUY0R1krZ0lYNlhYMTlBNmxIeXlzZm9zdkk4UTZhMURLNGlqR0NOMUhTb0NJ?=
 =?utf-8?B?WENFSlJDNXV6RVczUDZXVlpnR0p4cEdRWnlUOGZtT251d3YxNWYzN2VNT0RD?=
 =?utf-8?B?bTV4dGo1b2NpS0t5eTZUL3MwZ0xhSHh1YUxJVWl6dWtCT1dpdDdDUGN6U1A1?=
 =?utf-8?B?VzlGd04rVGpkdEtjUVZWMEhJU3I4bndVVXBobFRrQ1J1MTZ0S0V6dXRXSGxm?=
 =?utf-8?B?OU9hMmd4WDdpcndjRSs3UkxJV0R1dGtScTFSVmt1cDNTUm5tT0dZaGRRZzJ5?=
 =?utf-8?B?K1FkNXlFb1ArNlZxL3B1NFpRTU9MUnJEdDY4ajBEdkE3THRUbW5QTUZ5SkRM?=
 =?utf-8?B?anJZNGpIZjRMZG02bU9GUDloVVVmTlVPWFFjRW1rSWRiVmZrd01CM2dEVSsz?=
 =?utf-8?B?UHNxRjc0aDBtbFAralEySnA4elZzUGZ5cWM5bFdSeTg2UWlFRHpNOUVhRVdY?=
 =?utf-8?B?ejVBNFdYa2VXKzl0TGNLZG91RmJrSittSitwNDRNbzZ3M25mQkZWaENVWFVI?=
 =?utf-8?B?WGZoRDV0Q3phYndjVkpRZHQxKzZoQVVtd0l3dWJYVEJkWFhmWEhoRGdMQi9q?=
 =?utf-8?B?QjU4dmpnSDNGU1pjVXhxNVM1YVIyWDU3TitETi9CUXF6R2ZDd2xlNHNPNUpr?=
 =?utf-8?B?b1V0OGVYQU1oZFp6bGdQOWkrcVpMUm9aZ2hZR042Wm5qZDhoZGc2ZVBUdSs5?=
 =?utf-8?B?K3lGNS9KTHhzdlVTa2ZVZlJqUFgxTUVKVjdNZkV2b2cwbi9RK3kvL1M2YWto?=
 =?utf-8?B?L3JLY1kwOFQweFVKVEJCbUJrdUM3U1YrSXhtek4vY2VjYkx5blZuZ3hLQUJs?=
 =?utf-8?B?VUxpdE04Vzh5U0xHT3E1UDluUjhIcno2Q1pXRmVpU3VlWVhOTWIvVVdtdlRi?=
 =?utf-8?B?SmttaFFHK1pZcWhNaTlNYUpRVkVBZ3d5cEJqY1c0VWNLU2Z2aldGSnN6R0xo?=
 =?utf-8?Q?o8u2iXKTddfcibt0=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d0eec8-8ddf-4c2d-0501-08de4d54bae1
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 18:52:24.3115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2vuc1IyKYeLCzv9Rzey+vJE+c+Lq/X4Ym9RaSPWBtX9v3+dooeRPaoY5JKmWphSazDuu0fEYHzGzg94HYxyAupMKaktnRWUy98lQQwBoUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR03MB8275

> Mentioning L2 and L1 is confusing.  It reads like arbitrary KVM behavior.  And
> IMO the most notable thing is what's missing: an intercept check.  _That_ is
> worth commenting, e.g.
>
> 	/*
> 	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
> 	 * and only if the VMCALL intercept is not set in vmcb12.
> 	 */

Not intercepting VMMCALL is stated to be an unconditional VMRUN
failure.  APM Vol3 15.5 Canonicalization and Consistency Checks.

The "VMMCALL was not intercepted" condition is probably what the
pipeline really checks, but really it means "in root mode".

In most nested virt scenarios, L1 knows it's in a VM and can use VMMCALL
for host facilities.

~Andrew

