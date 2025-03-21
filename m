Return-Path: <kvm+bounces-41670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D44DDA6BE01
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:12:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 900EA7A5F24
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 15:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BBB1D79A0;
	Fri, 21 Mar 2025 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TNvp4Ou5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061.outbound.protection.outlook.com [40.107.95.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5218942A94;
	Fri, 21 Mar 2025 15:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742569934; cv=fail; b=D51hxNT8KT5Q9f0vguphFYuhiCVbF1wdFCWfh4zJ0Zz9vNPfiJfD44E3Np9IfMxfQWoVop2sr9TuNFfv7dtBK4QR7CSq/ZjC1KP0YNhrHmf/qzM1Vwqbtj8qpgK4LmqoBKqlxkooZNgFYeT1/sQePMwQ6TjrEDLvldbTRN6rOjM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742569934; c=relaxed/simple;
	bh=3FVT2140Y84UX6jNE+y7NUsj1ykaufkEGUzi73gi1e4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RQrf3zEv7eTMCRXu+v5kr6g5GDolmGyNOCKFqkECsM7jTVeJ0yLX8r7h+vILXidU/Oxihshh+FwWV1pCm/PTOhowsbxap9I3U9w3zjtTZhhBeVPqq6Rcoe/Ab/J0ocAMG+t1Zrn6ESqcZV0urZfXMAoF6QPsdFaHjnZlfhjeadE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TNvp4Ou5; arc=fail smtp.client-ip=40.107.95.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ny/uq3EJ54sLE2i5Qjb1XMJSIuoyDnfRvEdY0nuznGwnhhmm9fcloUltC09UYPM+MsFaGX69p5z06cAwFSfsJxKm7fxWXWdg+MG2Jlvyv43SCcVejDLCGF5lIiFuyprcPoSBWnQ0QAQeK7qZvTI+N5sgQHz8zAx9R90aDqacTZPboojLB5/UshJ7rpUN4AK5KLok+KERyVMBSRphNozLorX/ScabCr5Zk09ZCX3N5yV70G9UKpo1khWFBogNkrcxgOuhwfbn1uUGgxwRcfQJ+siCow11VgKUvXPJRmnCDTRZJtujAF0YWUSULxiPvuFAQErqDv8SwxeZmlGspYtrpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wS0AWsdB4gg8ujDUugGNNhGvTplzBfzLDIMOhmz45mA=;
 b=zE1gUnO38W4Hb34ZK1VZZGCVE73Am0VTAnl1GkjhcoCb/7gPv8iizEziYD069ky3nEAYZO+BIue5Ew/FKP1a22KP0Ga2Hei8/GIqMuULn3q2E42QIOw/ri97NiPSGwf68phGruJ2x/BM1Ard2MVGEWETrbiToAr7HFP7rFe/yuOazE5yLDOPk7zTDoM6i0Iul0gumX5hAnMxmAF8mvut3mB12iHYrngfFIUZ76xFwsMqj563UqV9Xa0Wvx2zxyYUfMMISvkWrb9XMDB9Rt1rjb9tQSIcDQeA8w+SeCdnMxit3jObvKNxKQDC20vBiPQ+WgWHJSHbuv5Ppcqe4NPsQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wS0AWsdB4gg8ujDUugGNNhGvTplzBfzLDIMOhmz45mA=;
 b=TNvp4Ou52KXTsx0hBigvLnU/QOxVPAxJZ5e0N3vOoDxY2J4akDdc+7NDEXIKVfYaw/rBMsF/1+Miz24CeSkC+f7+tskV+3CapXyiWid7xMCn0ZlaJAVoEFHni0C1clQtshSMfCUu90XjPJGXiiiPvxo+8rTkfBmFzZBR/T0uztQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6608.namprd12.prod.outlook.com (2603:10b6:8:d0::10) by
 SA0PR12MB7462.namprd12.prod.outlook.com (2603:10b6:806:24b::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.28; Fri, 21 Mar 2025 15:12:09 +0000
Received: from DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627]) by DS0PR12MB6608.namprd12.prod.outlook.com
 ([fe80::b71d:8902:9ab3:f627%4]) with mapi id 15.20.8534.034; Fri, 21 Mar 2025
 15:12:09 +0000
Message-ID: <b7097ff8-2a9d-48f6-985e-b190cb404156@amd.com>
Date: Fri, 21 Mar 2025 20:41:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 04/17] x86/apic: Initialize APIC ID for Secure AVIC
To: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-5-Neeraj.Upadhyay@amd.com> <87msde32z8.ffs@tglx>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <87msde32z8.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0126.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::30) To DS0PR12MB6608.namprd12.prod.outlook.com
 (2603:10b6:8:d0::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6608:EE_|SA0PR12MB7462:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e2d7bb6-49f8-4b06-cf68-08dd688abfe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2RZRFZzUUN6eVo4NmpNQUtRZk1CRXlqR2x4Rkp6SnJQN29sbGk1ck4zWjhD?=
 =?utf-8?B?SWE0S2VzbkRyaXY2UWM4L1VNbEh3NzZxY2U4bG1xTWcyYWE4dnhud2NNeHB3?=
 =?utf-8?B?TDBLSUwvMG1pdnRYbmxOSFFHVDZ0ZXZBTjBxVGlQa09acGtycm5BWUsxV3Rp?=
 =?utf-8?B?Zk00aVp6dmZlUE5WT2kyL0lXNGtPSlF6SGd1SExxS0U4a2JERVJpeE44eXBk?=
 =?utf-8?B?a0wzQ2Z0d2JuTzJMbmN3YlIzdzBjSHJ4cDREMGZmL2hqMnVvVldFa0R2MkJL?=
 =?utf-8?B?MU5KWU5NV0JzY2F4MGk3Sis0S3U1Rzg4eGh2bXIxeWFNeVRHQjdDbVpMTzJT?=
 =?utf-8?B?eG9USmdFUE0waWgxUUdlYnJwWFNiNXRvMXRUS2lPd2JhdXhYdU5Nb1piK3hj?=
 =?utf-8?B?VjVxbHI3VzFTdXJFM2RUSXpiZFpiZkhoNStXaXQ2cFFhY0l1STMvK0dtZ1po?=
 =?utf-8?B?OU9kQzdUZ2JMam1rUUpId1ozWGpLOWNRZWx4OFdjYjFDdmJ1NFBrUmdGKzc0?=
 =?utf-8?B?ano5c2EyREZremwwckN1QXhvTTZsTFFqSE9FWEdqdlpZYVJjczNSK2ZzeEw3?=
 =?utf-8?B?WnhkNDc3eXNwVXN0aXBiT29PelpuaGdRZE5wMkNkN256MkJwWkNKODZTZXJL?=
 =?utf-8?B?dk0wd1NmN3NyZ0JQT0hYSzQ0K0FpU2hBc2x4alR5eSswVVFOazJFT1U2QzdE?=
 =?utf-8?B?blZUNmVxZzczK0tJSldodUk4ZWduQ2tQeFdoSWNjWmlJakc5V0ljOXVxUlBY?=
 =?utf-8?B?am9BRVhsaFcyQkVkL3ZtZitkMUphK0xxVDMwS25RSmszR0QzNnlHWEN6ZEJU?=
 =?utf-8?B?Qy92SVhwZHU1VUo0bmZQYWpZQ1pabDg1YnBvaHZyalZMMUg4Qmg2RUNPOEow?=
 =?utf-8?B?c0QxRXRUbDNwK0RSYWppL1VjYW0rRlF0a0hOWm9NSWllenlSbWFnZFpHQWNI?=
 =?utf-8?B?TWxZZFBiWXltRlZEb25ya0hhN2JIeXdyQldGd1gyL2l6Vmk5cXFneStwdmVX?=
 =?utf-8?B?RzhBM3NxRXcvRDlMY0h0VmNUWk4zTFRCMXdGRlM4WkRDdlVOMkQ0eGtseW5l?=
 =?utf-8?B?aTNJb3JxQ0ZyaENtZHE3ZUlXTmo4RlJ1M0Rwd2hVaVhIWTdOTE1LV0REWHVp?=
 =?utf-8?B?RTNrWHNmeUkrY0JvUWNZTk9jVkI4UWl0V2w0SUlMdGRMRkptRng2dnpIbXlQ?=
 =?utf-8?B?WUJ4elJFR2hyc29qUmlQMm9uWFFxRVpmK2tPanViRU02eUxEbmNUZDcwTXUz?=
 =?utf-8?B?anZSWG9WMUNQUStrTysxMkhUNGhnKzNMNDgwSU1sQ1VzWm5ldHZaUWVFMTFv?=
 =?utf-8?B?U2k3Y2ZSdUticXhoclhXdUxNdEVQcGV6UjNYZ3B5U2JFZHh6cWJRbUJLbFBZ?=
 =?utf-8?B?bGJ3TkRkSkxTRmFhd3JmSWhjNzBEbzNJeS9qYTlOSmlqUFVRYXVWVUc5ZlZJ?=
 =?utf-8?B?SVM1L3hQeHFEUDd3SFZPVmVCZjBiNzdvYS9yekNzdW9wdkFFb0RTYnRJUEdj?=
 =?utf-8?B?YUI4SlYzYjNFKzV5TXVhRDZyQTdLSjlzek5KM2ZSNkYrRFJqMjhIcFEzR0xn?=
 =?utf-8?B?d3AyMTIyd3hVcWlSOUtUblI1Q2tWSmZOTy9mQmZFazFMWkMzZlUydjkveGJF?=
 =?utf-8?B?ZXdkQzFJMjZOdnVXKytHTEdFQ1RqWmp1blduTVoyU2JsZlR6SVBLTU1PNE1O?=
 =?utf-8?B?b0VpZE85TWg2NElIMGhuN2N1NGFqUGQvVCtBOWpmRG9ndGZGT21RUndGZElR?=
 =?utf-8?B?ZVZaOFZnSjl1aFhobmhGMWxqOGtkd1E0eEFyK1RNQi81SC9wejh6QzlOSnpM?=
 =?utf-8?B?dXBxR0IwOWNMdXhoUUdKQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6608.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEFGaGxENHFuUnNiWUJDQTRmRmIxNGgvRWhWc3dadzZVaFNOeHJLeE01aENX?=
 =?utf-8?B?aVZ6NXRnQmJHZjM4cnlxYzZRblJyY2xkN3dvdEtFMXdDVjFJZTlVTTZmd0w1?=
 =?utf-8?B?Q1c1dUxoQ01TUHI1VzEwU1V3MWNacmM0RVZDMEkvaHY4bkN0ZURsdFdWd1RD?=
 =?utf-8?B?QjhoUjJ2Si9TcnZUdCswRWJxdDVCR0dHOHJBTlVwTmZCc0ltNjZGM3k2MUtX?=
 =?utf-8?B?amg0V2VHUmYrNW83ekpBSmpRUUFmSDRJbmxIcE5vS2hyTDluR1RtZG1HbFd4?=
 =?utf-8?B?eVFVWFhTdURKa2RHMDVqK2hPTkJKR0RWMU5LcU1wdy9VaGVCRXlKaWVWUkxH?=
 =?utf-8?B?UENWaEJPeVIyZ3gvRUhtVzJKNzRqMkE1RWRKWXJLZWF0UGdoSzZQVE5oM3FL?=
 =?utf-8?B?eEI0TUc4N1JBdEJCK2RxSUluS1d1YSsrYW5vZTRyVjJHZ2FTVjhDMHJwK044?=
 =?utf-8?B?WmJQVnhIMGloYm5OMG9XOFJWMGdhc3ZyNUVNUFhLdDd6SW15SzVuSGJoZjBK?=
 =?utf-8?B?T2J1VmdkcFY3bFhJbUN4cnRxWnRadlZnMlY2UVJRRW5LS20rL2p6dDZVc0dN?=
 =?utf-8?B?RGtoMnZ3cjk5UWxGR0xqZGpxb3ROakVOZCt3NUpPYWZxMzJDbGtJQ2k2ejJy?=
 =?utf-8?B?RFJPOXFzaHQ0VnYveklKYUxyOU9lY2NCNkR0ZTlmamNYQnNLWXBac2IzU1RK?=
 =?utf-8?B?cGJWSlpyVmRGTEFwT2hLOUMwaWJJR1JNbHIwSm5TN1M5dE1iQUNOVDVXVkZv?=
 =?utf-8?B?RVU4OHVJa0VsKy9SYzYyNFBodzM0Nk5LZmFQL3RKenMwL1F5cVBEaGN6ZlF1?=
 =?utf-8?B?RC9sTlJkN3BFKzRLTmNORnRjMFdGZXNqYzgrTDNQUFJkN0NEZHBkS1VtTklo?=
 =?utf-8?B?eHFPTGt5RDBHcTBkN09VckFmdmpRemc0ZEgrenNMSWl0Y1BGUm9GS2t1Z3F2?=
 =?utf-8?B?RS83N2lhcEdCZUt1QXo0QVRLTytDc25OQ3IyWDh2SzlGbFFPMklIakZtc1I5?=
 =?utf-8?B?UkJhMHYzNHNGeEhvdUt3dEVlN0JNandlbjFNQmI3WnRZdGpYZFdINVRjWXly?=
 =?utf-8?B?ZlZ5SUFGMElpcktzaktUUS82VkNsSzdMWGErUmZzaHQvWkV3enZGUlhRTUg2?=
 =?utf-8?B?cUplcWhacUlxczl3dThhUFFHVGFoNGQ1NFh3dzRnNzVWM3VhNEwybHBCOG5v?=
 =?utf-8?B?MDNmM3hYbDR2NlJMcGVtcU54YzdnRkJDbURXTVZWdDNIVUVVRTZsVVlmNWVF?=
 =?utf-8?B?S3lBZng0ekxLZmRaV1ZoUVArd3FTcDloNEcxY1l6a0hTYndCcXk3NWVFekYv?=
 =?utf-8?B?ZWEwZWZRSnlhdXM1Si9LV3ZYdkVNRXRybXlNUzJNSkNDSkZ4b0NIZ2JUUkQw?=
 =?utf-8?B?Zm4yazc1U2FDOVJTYnJXbys4WklDUU82dy93b0VyaWtOeWFicStlSWE0VGRJ?=
 =?utf-8?B?clhCWXluVHV0OE1VOEMweGloeTIzVHluaEptL1IzSFNZSXhQbUtFejJhc0l2?=
 =?utf-8?B?TEtYK0tOaE5wcFowaGEzR1BZbGxsUjFaMWVEaXlsRHBvYUcwRzNNdkpRUmxu?=
 =?utf-8?B?V1UveTFjTjlQdDdwSlh1a21ReFMvVHByc0FybE5UVWxBZnZzUENUOE4zTUQx?=
 =?utf-8?B?M01zM29sMzlyNGNIN1YvQ1pUOHFiRnBYMVZlOFJ2UTd6c0NtR3ZqY2Jzam1r?=
 =?utf-8?B?S0U1bVhNSGd3TUdrdEVQTW1STVlRS01zcEdwQW11UExGQkZud0M2VkhLckJ6?=
 =?utf-8?B?K1FEcXF5d0lueFFKMEhJUktjUExlbHBYUjA0aUpEcG1iRFpEQWZSbXdBcTND?=
 =?utf-8?B?bkdvUnVYbFllSDBIM3IrQUtXTlNWK0s2VUlMdXV2dlVYMlZKRlJuS2FpUWh2?=
 =?utf-8?B?Vnh4VkxGam1xTTZNcjBMWU0reTdCVjJBcC8vOGpKMTlJcEtzdWcvNXUwbFdB?=
 =?utf-8?B?OXUvTWVySXJmY3hRdlRkcTB6YkVuUlZNUzk2VGEyWGpmdGtIeHZNa2RpS1JS?=
 =?utf-8?B?VDFJNVd6UGpaeDVwdFJIbEQxY1U0MmQwS2FGUDExTUp6b25RSmdGTjFVb1Mz?=
 =?utf-8?B?MHkzeDhDSWVNdzJHUHllSlg2L3FBTTlRTzBzMDNqRVZ3K3lVZGJTRVRicndN?=
 =?utf-8?Q?d9tTzibhhr/MF4NUAfEaq+f0i?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e2d7bb6-49f8-4b06-cf68-08dd688abfe1
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6608.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2025 15:12:09.3944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeS4v97Zh2o5YDttn+ZuOAu1g/slo6dLQx01MV+fTLwJAUZ2gfUytibWzcTq0X+3LShhZgUutmRapssgipV8Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7462



On 3/21/2025 7:22 PM, Thomas Gleixner wrote:
> On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
>> Initialize the APIC ID in the Secure AVIC APIC backing page with
>> the APIC_ID msr value read from Hypervisor. Maintain a hashmap to
>> check and report same APIC_ID value returned by Hypervisor for two
>> different vCPUs.
> 
> What for?
> 

Guest CPU reads the APIC ID from Hypervisor's vCPU (emulated) APIC state
and updates it in the APIC backing page which is used by Secure AVIC
hardware. As Hypervisor in untrusted, guest does a check for duplicate
APIC IDs. Guest and hypervisor's APIC ID for a vCPU need to match for
IPI flow to work.

IPI flow:

1. Guest source CPU updates the IRR bit in the destination vCPU's APIC backing page.
2. Guest source vCPU takes an exit to hypervisor (icr write msr vmexit). The
   destination APIC ID in ICR data contains guest APIC ID for the destination vCPU.
3. Hypervisor uses the apic id in the icr data provided by guest, to either kick
   the corresponding destination vCPU (if not running) or write to AVIC doorbell
   to notify the running destination vCPU about the new interrupt.


 
>> +struct apic_id_node {
>> +	 struct llist_node node;
>> +	 u32 apic_id;
>> +	 int cpu;
>> +};
> 
> https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#struct-declarations-and-initializers
> 
> and please read the rest of the document too.
> 

Ok.

>> +static void init_backing_page(void *backing_page)
>> +{
>> +	struct apic_id_node *next_node, *this_cpu_node;
>> +	unsigned int apic_map_slot;
>> +	u32 apic_id;
>> +	int cpu;
>> +
>> +	/*
>> +	 * Before Secure AVIC is enabled, APIC msr reads are
>> +	 * intercepted. APIC_ID msr read returns the value
>> +	 * from hv.
> 
> Can you please write things out? i.e. s/hv/hypervisor/ This is not twatter.
> 

Ok.

>> +	 */
>> +	apic_id = native_apic_msr_read(APIC_ID);
>> +	set_reg(backing_page, APIC_ID, apic_id);
>> +
>> +	if (!apic_id_map)
>> +		return;
>> +
>> +	cpu = smp_processor_id();
>> +	this_cpu_node = &per_cpu(apic_id_node, cpu);
>> +	this_cpu_node->apic_id = apic_id;
>> +	this_cpu_node->cpu = cpu;
>> +	/*
>> +	 * In common case, apic_ids for CPUs are sequentially numbered.
>> +	 * So, each CPU should hash to a different slot in the apic id
>> +	 * map.
>> +	 */
>> +	apic_map_slot = apic_id % nr_cpu_ids;
>> +	llist_add(&this_cpu_node->node, &apic_id_map[apic_map_slot]);
> 
> Why does this need to be a llist? What's wrong about a trivial hlist?
> 

I was not sure if the setup() can run in parallel on 2 CPUs. So,
used an atomic list.

>> +	/* Each CPU checks only its next nodes for duplicates. */
>> +	llist_for_each_entry(next_node, this_cpu_node->node.next, node) {
>> +		if (WARN_ONCE(next_node->apic_id == apic_id,
>> +			      "Duplicate APIC %u for cpu %d and cpu %d. IPI handling will suffer!",
>> +			      apic_id, cpu, next_node->cpu))
>> +			break;
>> +	}
> 
> This does not make any sense at all. The warning is completely useless
> because two milliseconds later the topology evaluation code will yell
> about mismatch of APIC IDs and catch the duplicate.
> 
> So what is this overengineered thing buying you? Just more
> incomprehensible security voodoo for no value.
> 

I see. I was not aware of the mismatch check in topology code. I will
remove this code.


- Neeraj

> Thanks,
> 
>         tglx


