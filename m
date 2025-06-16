Return-Path: <kvm+bounces-49589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 30446ADABEB
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 11:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33E4A16EF48
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 09:28:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05512273D99;
	Mon, 16 Jun 2025 09:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dX1mECJu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2068.outbound.protection.outlook.com [40.107.95.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8809F273D90;
	Mon, 16 Jun 2025 09:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750066071; cv=fail; b=huV3SCIwbbgW6JStJBAa8RTaoqB61TZrtoyJ01cyEpwKV33Zi2u4Tgtw6FFbZhPqUCjYuebF3hkrN2ux2YOik7OR9QI7ycnyVMPn8V8zilw8KFcE3m5q9YRqdMT6Hgk0Rb2glJfjCc8Gq/EjGKXH314WS9GxtkY1MyIX7LwiuSs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750066071; c=relaxed/simple;
	bh=wjvGc9r4CtHAjc5wB62jxnKnFYwLjIvtdsxWlWuVb/M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lg4g1ztbmQafBKM6xSfmAqViZ1v7Xitwn/g+Mu7O8XsQxyNlJHqgtyVI3yU7+k/HqjmOur1tANaftMbvi/gQa268t+IT7DthC4us1p38lcEO/LG7BzKVadiBP8kCrT04vEyHUxlfrThRPY+pBm8kQiZMJgMYDKjLt8svFl+Zagg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dX1mECJu; arc=fail smtp.client-ip=40.107.95.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F68Ryn6fcus4TSLAmxt2rgsaHgRxtyLQAglPyPxUE+vAH3qJYGxOGL95WZUcqQvA7dNo3TEl0VJt9wp3/dHXMniitnwUDWuqd8rBHc7IhziwOW3wG3T37/h3fZNoFl1uxvWoQuPqq+gMu5NQlgOSTOt9KMri5j1FdJTfFtn1Y7FK1QrZvj5w4FB+cQxFfKunoRUV5u6sicUXYIJ0X2b8ir6WPLBGdW6w/1hJsTgW6snq2iLvERaQJk1SZSCz4kHwqE6CIBB+JP4pMNhS7vSIk3h3JSuoxiStnJg1IOxTUdOGHPrRMbzmQgjVsME15fO/bu4HIMt5BY5nYMoBMb080g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjvGc9r4CtHAjc5wB62jxnKnFYwLjIvtdsxWlWuVb/M=;
 b=Dfb3RzTZnaMXqWBcIYkPQs7htK3dyq0BKa1Do4nuSvlbFmf/JvE+DdFBdKrwmDI6Dly5RYgpGMBGxIWNk5LKY6s3AFz8khB54C7g0tY92Y1HPlwdFGgCQgHE2QnFkaUCePlQVI9tajjZkF4aTJA3oUx5mFyQrtU3+fSMhX/G1AO8RB5+Ne/vkt3Bz9UL367w3VB6+GrsY3XBYJAe8aJnEMjWEZQqK3SPch8ww3gM+U+GddXt8oJBJvi/0Wl4jNYkX/AtX7gOIhM9K+FBBSuDxUVmfxozlVwwJqh6DNBDN3v87S4GIS3ULVPRYHUMBr7LVfs2/4i6LIl+kBPCOl716g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjvGc9r4CtHAjc5wB62jxnKnFYwLjIvtdsxWlWuVb/M=;
 b=dX1mECJujppoCmEMJTDI9gZKCY0gnAHZSjfxdOYZaNU2xzhNa2FVhLuzvqY23EyCX1xzatsU5tLdsAp6LJt6wTgNRhgCnfm1UlGHzckNbgHjWuua3NrFuLSD5pOTZJrNJFXApRLG9tmxYIX7pL8dOe/9XBNCKt9bqDNOmwKSwLs=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by MW4PR12MB7000.namprd12.prod.outlook.com (2603:10b6:303:208::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Mon, 16 Jun
 2025 09:27:46 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%4]) with mapi id 15.20.8835.025; Mon, 16 Jun 2025
 09:27:46 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"jon@nutanix.com" <jon@nutanix.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Thread-Topic: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Thread-Index: AQHbxM926MXs9CcUxkqIa02t4IOATLQFuDUA
Date: Mon, 16 Jun 2025 09:27:46 +0000
Message-ID: <7704c861ba54c246dc8e5f26113c6f84306a099e.camel@amd.com>
References: <20250313203702.575156-1-jon@nutanix.com>
	 <20250313203702.575156-7-jon@nutanix.com> <aCI8pGJbn3l99kq8@google.com>
	 <49556BAF-9244-4FE5-9BA9-846F2959ABD1@nutanix.com>
	 <aCNI72KuMLfWb9F2@google.com>
	 <6dd4eee79fec75a47493251b87c74595826f97bc.camel@amd.com>
	 <aCSSptnxW7EBEzSQ@google.com>
In-Reply-To: <aCSSptnxW7EBEzSQ@google.com>
Accept-Language: de-DE, en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|MW4PR12MB7000:EE_
x-ms-office365-filtering-correlation-id: 0ec486bd-3949-4029-b12d-08ddacb80dfa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?enFKOG9yQ09nbVhmSFZJdXBwbjVrMUVxZXZ4N0V2Y09IazRWZnB0eEhNa3Zm?=
 =?utf-8?B?TFpPZlpJd1RZZkU0Q0diY2k5SkZleWU4SUxDMnh3UmVGNm91dXVtQWNwK0tn?=
 =?utf-8?B?dENKVDRWQ2NWRDcyR2xqY0I0NzVZcmhmeEF5NkFnM3pTOTAzbUVPTE55cG9V?=
 =?utf-8?B?YlRwaXRyWE5lZUoyVThMSXhQVWRqQlMvV3RYcEFjcHRSdkg4emZFbHByL0Iz?=
 =?utf-8?B?NmM4Q0p1eU9Na1JQZGNsMENHK1d3M0l1QlBNZHBEZ0tCQXN2UWZOSHpRbVFw?=
 =?utf-8?B?eDQveU9nY05nRFhLbW5IM2o0cGIweGVLRXl4UHJsSndDYlcrSmIrZ2pZemVV?=
 =?utf-8?B?aE5HbzVJdjVOZUp0bDlxc1lTbmxTNmpMWVUyb0I1NzNhYURPOWJZWmZPUzJu?=
 =?utf-8?B?RmlMSmh5OEM1VDh4aHJEK244bUpPZEJsUFNTZFZ5NDdaUFhHYkhFdEpjM0pG?=
 =?utf-8?B?WThaKytpZnljYVlRSzRlL25TR2NnY1lEN1FBZ2VvcVFYTlZVNCtLN0oyam5r?=
 =?utf-8?B?c0ZNR0dtRnI3c1JHQ3B4dXdwdElhcVBkaFB1Vk90ekI5ZUdoM0UrTlBtbW54?=
 =?utf-8?B?SzE0b3VROE5IMnQ3S1QrOHVJTTdNTFNMR3NCQXRhak05Vm05VUI3cnFseXYx?=
 =?utf-8?B?eitOSGhHQWtWdGt0TlpRY21Ea05WbU5LaC9Bb0NGaGQ5cEEwTVdSekl4SDR5?=
 =?utf-8?B?bTNLSkZqbzd4UHZ6bzl2ZjNRRXErOFNCcXFhYmhYbXFBckoybDRjV3dkRjRi?=
 =?utf-8?B?N01ISExQdGcraVlYWWZ6WGVYU0NwVGVnWjJxemF2YUFJaVFGNEJ2UkxINGdQ?=
 =?utf-8?B?ZWV6eTZPcmlEekJPZXUzdWRuOFpsU0Y2bG9abjc3TFJveEhaWXpqcXUwZVk5?=
 =?utf-8?B?QlBnMWR1TUxnNzZhUmJmTHplNW5pbzdvWGRLaC90V1R2cjBkbHhvMmJyZktD?=
 =?utf-8?B?cnRzNkk2VGd4eStHeWVXTUV6bE5qdTBPY1FMTWFDZVNURzJSNHZEalFFaVBw?=
 =?utf-8?B?K3Y3OFdxZFFxOVVLaEFieStBV2lMUmFjejZMZ3RpWUNvWjZCRzBpcjJEZGVt?=
 =?utf-8?B?eWtPdlhYS1VQU1d1eU9uSjNyODBVbW14eFM1NlhvNXdXTXRGeW5Xazd2M0dh?=
 =?utf-8?B?b2xxZzhNQkV3cHV6RUx6YmdIUEsrNWJ5U29tYmN0bjJOakdJNGFpeDlISzZC?=
 =?utf-8?B?Zm9nNExCOW1RbkZSY211bVVjTnAxVHBxSURCVEZzV2RRNlM4dTcrUnl3SDQ2?=
 =?utf-8?B?ek93UXFYcUU1dGpKcDl0NDdHTExnb1VLSXgvcWx4LzhoOXliTTRGMWFaNWw4?=
 =?utf-8?B?cHh6clZDTUljMjZ5VXVLY1p0SjVpUmdtaW1veFhRN3h0SVV5MG40MDBBck1M?=
 =?utf-8?B?R0JrR24xQUM2eGZ4MXA3SVJvUFJ3cEEydy93OXE2czhFNER2UDRjNGxPWDUv?=
 =?utf-8?B?WVRVM2lXMmZpYlRxRkpsWUFOTWpVZjN0M0sxZ3BJL1lNOWdmKy9EcmQwUmk1?=
 =?utf-8?B?dlJPTGlXbWJlbE1KN0w2cFY2aFFqd0RkdDdBZlJubFBSMGxqc3cwSndLRWpv?=
 =?utf-8?B?bHBod0p5SkRrUzMxUGhGejdvVElmY0NTWFFUUk5jQzdrc1cwNUExblIvTWMv?=
 =?utf-8?B?amxORUVac0MraWhTbDVGUHdRWGlEdVZmL0JiSTBvdURWbEZ6eWRrR0RBMlhr?=
 =?utf-8?B?TDdqNzFZK2ZvSnJaVHZUMDJoZlFvNXkyenV6MnJQYTh0akpsQ29DTGJrTk1S?=
 =?utf-8?B?TnVlM3ZhK25CZEVGVnlEdjAxQVB3ODFYenlPNWtQMVRuNzJFdWo0ZitJQnRL?=
 =?utf-8?B?cmlockhNVjRFZnZuM3drei9HMUFnM2tWb0puNkUxM0ZxMnBnSGFCOU1MS1Ra?=
 =?utf-8?B?aTRtd0ltRGphaGdySEs0VHJYcHNiYmpyTmxSdGprdVc3SEsvZzVKbDVHT3Vy?=
 =?utf-8?B?eFZ4NzV5STBRdEcydCtYdGVMVHpoOU9xaXVtbVQycE92cVlyVHNFcUZ1dUVj?=
 =?utf-8?Q?pY9zXZJjARqcCYTJ+OAo93/HMRH8Y8=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cnpRQ3kySkFsd3BJUlAzMnVYb1VnK3cyeE5VQ05ZNURqdGp1bnZxVmo5MGVL?=
 =?utf-8?B?V2FuRzVTbmEyRUY4dDJFZ0xjZXptY3FjSnVac0xsWTFlUFhUR3BSalVwVnFx?=
 =?utf-8?B?QjY3R0tRVmZTeDE2dDZ5WDFKL0k0NW4xM2ZUYUh0R3BrWTNFWTBTSlV5VzZn?=
 =?utf-8?B?YlE4OWZFdFZKdkN6ZXgrV3dvN1BLYVQ0YmtuTDI4UHBGaG85WWhzUCtIc0pN?=
 =?utf-8?B?MEJZejJxQ2FUemNLSysySmh3MitwYXdrL29CeGo3N0wvMUk1c3QrR3IrcG1y?=
 =?utf-8?B?RWE3aHZNVVl5c3Q3SmlkQS90cGZWYi9WQ3NoWHlqL0YvdUhoWHVFMnZUMUNN?=
 =?utf-8?B?cGRJNEdpaU1rYWhPRjRlNXZ2YjZYckZUZmUwazhsVDJheVVwTnMxSXpoV1lK?=
 =?utf-8?B?VHgyM0RRQXEwNmZjMStSRkg2cUlnVFdjSWtDMHFsRkpZMkhIU3N4Z1dzOUdI?=
 =?utf-8?B?Zy96UUQxNllzbndKSUlKYmtHcGUzNW9FWVQvTmVlK1NhUlRkMFVRVW04Nml1?=
 =?utf-8?B?YU1OTEdXakNITERvQU9ncEcwa3pjY3UybmN0eHpBaXFsZHJGdDdzajN3emxZ?=
 =?utf-8?B?eVNDd2pRNmJiemlWOFdwV2pBdnpGY0xndXBxams1SlZ1MGxmWE5TQlRTVnZa?=
 =?utf-8?B?Q0pDbHdtMzhRQUcxYnZickpkSXBYTkRuQUpUbVgxWHlZY3E2T1VDdWx2Tkhm?=
 =?utf-8?B?T1BTUFB2OS9wNGJYQ1dKaDU4WGdDZUNrUDFYajVkUm1yU051b25xN3R5Yjly?=
 =?utf-8?B?eTZtdTdYTE5ydXk3VzhxdVZwMlhDWXlpN1RVaWFFajdKUFhkZWFZNmpkY1VQ?=
 =?utf-8?B?QzBjNGxNenhMaUFrUWJwUEFkamRFZ3Z4MXprOXFvUU41MktmZWJqMXRkMTcx?=
 =?utf-8?B?UE9XcEZaTnZqdnFEN3k5VTdncmZLZ1AyYnp1RlRkY3YzaTF5Qkxwczc0Q2l4?=
 =?utf-8?B?cThjYkpZUHNtd09zVExIVDh0WDZQeVpzVFgyMHRNOWVJVWRISnI2VktHSnpu?=
 =?utf-8?B?VzlyOWdCR0JKVnNJOVo3cGJ4YUNzaHg2Y3NtNTVVSzI5b1lGUkg4ZU9QNkpP?=
 =?utf-8?B?SVF0NlowWkpyQzRKM3lSSzc5dHMremR6NS9UNmxpYzZsSjlncHFwMyt3SDQ0?=
 =?utf-8?B?emhBNFlXMGcyaEd3cVc0amZNZzF4NUhvWE1HZzhwUUZsdzNkWEZBQUlYOW11?=
 =?utf-8?B?TUZYZGVWRlNOYTBJUDAzMzBYWHZlc3ZDQmlqSUt0UFl5OUt1cVFYZ1FENVRo?=
 =?utf-8?B?YlF5SHFEWEhQMW9TdmxEb3BUYWU3ZjlRbXBJLzJDNzd5aWszYmdTUFhray9C?=
 =?utf-8?B?N2d2NTJwTEhHRlNUdk5mMkJwVjhIdmpGZGlZM3NCNS9MMk9uUlFtc2piZnUz?=
 =?utf-8?B?eFJDVVdQaThEOGlpNWRXaVFBZDJJZER0aE04TlR2Y3FaTU1ONU5mSWlyeHZk?=
 =?utf-8?B?T3NrWFNKS2UvV1QweVkra3IyRVRtWnZzbU1lcVpTRkVxRDMxY3ZrUVh1bVZt?=
 =?utf-8?B?N1RzUzBnbnpPbEp3aGFpM3Z6UWNjN3VWbnlzMTcrT08wQU0vRUVEWm1jeXhn?=
 =?utf-8?B?V3JJU0FQYU5DNU02U0E0MWV4T01uQkl4Zmc0bHcwMXdTVWF1VjFzVkRvYmlw?=
 =?utf-8?B?M0FwVW1hanVvTGZjdTZySk04S29VS0k0czR6K1JVZWxzcXpoVkNBWWdJdWM2?=
 =?utf-8?B?MWFOSW5keU1aaXZsak1FdDh5QnhEQkJFSVlXUncrd2NSdGRDVUZOalBkMXRY?=
 =?utf-8?B?cEpmL3M5TWJUREd3S3o4U2tSQmpXU1l0a0MyWEpjZjZRaktjbXk1bnQ3TU82?=
 =?utf-8?B?OUZPMGFpem44NGhFNjBWS2tpV2QwNjN1alNsQUttam9sNHlXY296amZxWG4y?=
 =?utf-8?B?S0xhcHBaVjFxYU1NajJCd0dUVS9DSWtxaCs0NXQrcGtMcXRDcENIc25pWmJM?=
 =?utf-8?B?dEhhZVNkeWZiOXpIQk1adnE1SVRWRnVJZGNJY3d3SExDNHVFamdqQnNlTENq?=
 =?utf-8?B?MjRlcmlRRFU5U1ZSaGh3S0dTWUtUMW1ZUlpCc1hUbVYybE9Ca21RTzRkdEVY?=
 =?utf-8?B?ZEVmbk0wT2xUNVFDMnd1OFVxRHJyRjE2MXVwZEROR0RuRGR4N0Y5bDIwWUU4?=
 =?utf-8?Q?hCDm7qM4+KBWxEVHom6IEvnFg?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B7BF3226B67EF647B516282D5AC05F8E@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec486bd-3949-4029-b12d-08ddacb80dfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2025 09:27:46.4716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bhR2gXoYtHjK88muusNXG2LkXeCcCPBNB8ar+7ONL1zjdBcdem8n62e/u/Vo+Ro8PY1p5WHryPBv46RWDmE2MQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7000

T24gV2VkLCAyMDI1LTA1LTE0IGF0IDA1OjU1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAxNCwgMjAyNSwgQW1pdCBTaGFoIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNS0wNS0xMyBhdCAwNjoyOCAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFR1ZSwgTWF5IDEzLCAyMDI1LCBKb24gS29obGVyIHdyb3RlOg0KPiA+ID4gPiA+
IE9uIE1heSAxMiwgMjAyNSwgYXQgMjoyM+KAr1BNLCBTZWFuIENocmlzdG9waGVyc29uDQo+ID4g
PiA+ID4gVGhpcyBpcyB3cm9uZyBhbmQgdW5uZWNlc3NhcnkuwqAgQXMgbWVudGlvbmVkIGVhcmx5
LCB0aGUgaW5wdXQNCj4gPiA+ID4gPiB0aGF0DQo+ID4gPiA+ID4gbWF0dGVycyBpcyB2bWNzMTIu
wqAgVGhpcyBmbGFnIHNob3VsZCAqbmV2ZXIqIGJlIHNldCBmb3INCj4gPiA+ID4gPiB2bWNzMDEu
DQo+ID4gPiA+IA0KPiA+ID4gPiBJ4oCZbGwgcGFnZSB0aGlzIGJhY2sgaW4sIGJ1dCBJ4oCZbSBs
aWtlIDc1JSBzdXJlIGl0IGRpZG7igJl0IHdvcmsNCj4gPiA+ID4gd2hlbiBJDQo+ID4gPiA+IGRp
ZCBpdCB0aGF0IHdheS4NCj4gPiA+IA0KPiA+ID4gVGhlbiB5b3UgaGFkIG90aGVyIGJ1Z3MuwqAg
VGhlIGNvbnRyb2wgaXMgcGVyLVZNQ1MgYW5kIHRodXMgbmVlZHMNCj4gPiA+IHRvDQo+ID4gPiBi
ZSBlbXVsYXRlZA0KPiA+ID4gYXMgc3VjaC7CoCBEZWZpbml0ZWx5IGhvbGxlciBpZiB5b3UgZ2V0
IHN0dWNrLCB0aGVyZSdzIG5vIG5lZWQgdG8NCj4gPiA+IGRldmVsb3AgdGhpcyBpbg0KPiA+ID4g
Y29tcGxldGUgaXNvbGF0aW9uLg0KPiA+IA0KPiA+IExvb2tpbmcgYXQgdGhpcyBmcm9tIHRoZSBB
TUQgR01FVCBQT1YsIGhlcmUncyBob3cgSSB0aGluayBzdXBwb3J0DQo+ID4gZm9yDQo+ID4gdGhp
cyBmZWF0dXJlIGZvciBhIFdpbmRvd3MgZ3Vlc3Qgd291bGQgYmUgaW1wbGVtZW50ZWQ6DQo+ID4g
DQo+ID4gKiBEbyBub3QgZW5hYmxlIHRoZSBHTUVUIGZlYXR1cmUgaW4gdm1jYjAxLsKgIE9ubHkg
dGhlIFdpbmRvd3MgZ3Vlc3QNCj4gPiAoTDENCj4gPiBndWVzdCkgc2V0cyB0aGlzIGJpdCBmb3Ig
aXRzIG93biBndWVzdCAoTDIgZ3Vlc3QpLsKgIEtWTSAoTDApIHNob3VsZA0KPiA+IHNlZQ0KPiA+
IHRoZSBiaXQgc2V0IGluIHZtY2IwMiAoYW5kIHZtY2IxMikuwqAgT1RPSCwgcGFzcyBvbiB0aGUg
Q1BVSUQgYml0IHRvDQo+ID4gdGhlDQo+ID4gTDEgZ3Vlc3QuDQo+ID4gDQo+ID4gKiBLVk0gbmVl
ZHMgdG8gcHJvcGFnYXRlIHRoZSAjTlBGIHRvIFdpbmRvd3MgKGluc3RlYWQgb2YgaGFuZGxpbmcN
Cj4gPiBhbnl0aGluZyBpdHNlbGYgLS0gaWUgbm8gc2hhZG93IHBhZ2UgdGFibGUgYWRqdXN0bWVu
dHMgb3Igd2Fsa3MNCj4gPiBuZWVkZWQpLsKgIFdpbmRvd3Mgc3Bhd25zIGFuIEwyIGd1ZXN0IHRo
YXQgY2F1c2VzIHRoZSAjTlBGLCBhbmQNCj4gPiBXaW5kb3dzDQo+ID4gaXMgdGhlIG9uZSB0aGF0
IG5lZWRzIHRvIGNvbnN1bWUgdGhhdCBmYXVsdC4NCj4gPiANCj4gPiAqIEtWTSBuZWVkcyB0byBk
aWZmZXJlbnRpYXRlIGFuICNOUEYgZXhpdCBkdWUgdG8gR01FVCBvciBub24tR01FVA0KPiA+IGNv
bmRpdGlvbiAtLSBjaGVjayB0aGUgQ1BMIGFuZCBVL1MgYml0cyBmcm9tIHRoZSBleGl0LCBhbmQg
dGhlIE5YDQo+ID4gYml0DQo+ID4gZnJvbSB0aGUgUFRFIHRoYXQgZmF1bHRlZC7CoCBJZiBkdWUg
dG8gR01FVCwgcHJvcGFnYXRlIGl0IHRvIHRoZQ0KPiA+IGd1ZXN0Lg0KPiA+IElmIG5vdCwgY29u
dGludWUgaGFuZGxpbmcgaXQNCj4gDQo+IFllcywgYnV0IG5vLsKgIEtWTSBzaG91bGRuJ3QgbmVl
ZCB0byBkbyBhbnl0aGluZyBzcGVjaWFsIGhlcmUgb3RoZXINCj4gdGhhbiB0ZWFjaGluZw0KPiB1
cGRhdGVfcGVybWlzc2lvbl9iaXRtYXNrKCkgdG8gdW5kZXJzdGFuZCB0aGUgR01FVCBmYXVsdCBj
YXNlLsKgIERpdHRvDQo+IGZvciBNQkVDLg0KPiBJJ2QgdHlwZSBzb21ldGhpbmcgdXAsIGJ1dCBJ
IHdvdWxkIHF1aWNrbHkgZW5jb3VudGVyIC1FTk9DT0ZGRSA6LSkNCj4gDQo+IFdpdGggdGhlIGNv
cnJlY3QgbW11LT5wZXJtaXNzaW9uc1tdLCBwZXJtaXNzaW9uX2ZhdWx0KCkgd2lsbA0KPiBuYXR1
cmFsbHkgZGV0ZWN0DQo+IHRoYXQgYSAjTlBGIChvciBFUFQgVmlvbGF0aW9uKSBmcm9tIEwyIGR1
ZSB0byBhIEdNRVQvTUJFQyB2aW9sYXRpb24NCj4gaXMgYSBmYXVsdA0KPiBpbiB0aGUgbk5QVC9u
RVBUIGRvbWFpbiBhbmQgcm91dGUgdGhlIGV4aXQgdG8gTDEuDQo+DQo+ID4gKGJ0dyBLVk0gTU1V
IEFQSSBxdWVzdGlvbiAtLSBmcm9tIHRoZSAjTlBGLCBJIGhhdmUgdGhlIEdQQSBvZiB0aGUNCj4g
PiBMMg0KPiA+IGd1ZXN0LsKgIEhvdyB0byBnbyBmcm9tIHRoYXQgZ3Vlc3QgR1BBIHRvIGxvb2sg
dXAgdGhlIE5YIGJpdCBmb3INCj4gPiB0aGF0DQo+ID4gcGFnZT/CoCBJIHNraW1tZWQgYW5kIHRo
ZXJlIGRvZXNuJ3Qgc2VlbSB0byBiZSBhbiBleGlzdGluZyBBUEkgZm9yDQo+ID4gaXQgLQ0KPiA+
IHNvIGlzIHdhbGtpbmcgdGhlIHRhYmxlcyB0aGUgb25seSBzb2x1dGlvbj8pDQo+IA0KPiBBcyBh
Ym92ZSwgS1ZNIGRvZXNuJ3QgbWFudWFsbHkgbG9vayB1cCBpbmRpdmlkdWFsIGJpdHMgd2hpbGUg
aGFuZGxpbmcNCj4gZmF1bHRzLg0KPiBUaGUgd2FsayBvZiB0aGUgZ3Vlc3QgcGFnZSB0YWJsZXMg
KEwxJ3MgTlBUL0VQVCBmb3IgdGhpcyBzY2VuYXJpbykNCj4gcGVyZm9ybWVkIGJ5DQo+IEZOQU1F
KHdhbGtfYWRkcl9nZW5lcmljKSB3aWxsIGdhdGhlciB0aGUgZWZmZWN0aXZlIHBlcm1pc3Npb25z
IGluDQo+IHdhbGtlci0+cHRlX2FjY2VzcywNCj4gYW5kIGNoZWNrIGZvciBhIHBlcm1pc3Npb25f
ZmF1bHQoKSBhZnRlciB0aGUgd2FsayBpcyBjb21wbGV0ZWQuDQoNCkhtLCBkZXNwaXRlIHRoZSBk
aXNjdXNzaW9ucyBpbiB0aGUgUFVDSyBjYWxscyBzaW5jZSB0aGlzIGVtYWlsLCBJIGhhdmUNCnRo
aXMgZG91YnQsIHdoaWNoIG1heSBiZSBmYWlybHkgYmFzaWMuICBUbyBkZXRlcm1pbmUgd2hldGhl
ciB0aGUgZXhpdA0Kd2FzIGR1ZSB0byBHTUVULCB3ZSBoYXZlIHRvIGNoZWNrIHRoZSBlZmZlY3Rp
dmUgVS9TIGFuZCBOWCBiaXQgZm9yIHRoZQ0KYWRkcmVzcyB0aGF0IGZhdWx0ZWQuICBUaGF0IG1l
YW5zIHdlIGhhdmUgdG8gd2FsayB0aGUgTDIncyBwYWdlIHRhYmxlcw0KdG8gZ2V0IHRob3NlIGJp
dHMgZnJvbSB0aGUgTDIncyBQVEVzLCBhbmQgdGhlbiBmcm9tIHRoZSBlcnJvciBjb2RlIGluDQpl
eGl0aW5mbzEsIGNvbmZpcm0gd2h5IHRoZSAjTlBGIGhhcHBlbmVkLiAgKEFuZCBldmVuIHdpdGgg
UGFvbG8ncyBuZWF0DQpTTUVQIGhhY2ssIHRoZSBleGl0IHJlYXNvbiBkdWUgdG8gR01FVCBjYW4g
b25seSBiZSBjb25maXJtZWQgYnkgbG9va2luZw0KYXQgdGhlIGd1ZXN0J3MgVS9TIGFuZCBOWCBi
aXRzLikNCg0KQW5kIGZyb20gd2hhdCBJIHNlZSwgY3VycmVudGx5IHBhZ2UgdGFibGUgd2Fsa3Mg
b25seSBoYXBwZW4gb24gTDEncw0KcGFnZSB0YWJsZXMsIGFuZCBub3Qgb24gTDIncyBwYWdlIHRh
YmxlcywgaXMgdGhhdCByaWdodD8NCg0KSSdtIHN1cmUgSSdtIG1pc3Npbmcgc29tZXRoaW5nIGhl
cmUsIHRob3VnaC4uDQoNCg0KCQlBbWl0DQo=

