Return-Path: <kvm+bounces-56876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6F51B4576F
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 14:13:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EACBD7C2675
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 12:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E5034AB11;
	Fri,  5 Sep 2025 12:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b="lekmX+Nd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2138.outbound.protection.outlook.com [40.107.94.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB76B34AAFE;
	Fri,  5 Sep 2025 12:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757074421; cv=fail; b=qP7upNIIzq/MLOp7ZiI/zOXoPXw+qDwxhidN1/a4XgTXX8WCz+1C0N3SFDNQsb77qER3+GIbjxtf8sPyAKyKplpJ1EulLvEg4mJiHwddR5YoLGEoHtKJ7/I92wEkaIAIV/gkYSu0jnuFbUD022vBaTS91Nl3id+HEV6YJSyHmMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757074421; c=relaxed/simple;
	bh=9SMet40VtWL5IK4Ty8lO3ENksPCqPOGOlbuuLqYxN5A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qkF/pWr7rQhfBHfVD5lJmZeC/KdAdyF6LB27siTW3mY1cl4//kFHCOlsmbluWuyN+Icym5gCrJaZx77onJFq55CZe1RF0fmjdxRy6KpfE06bq1wzJw9nW78h+8b8k+zYsbONhhsupwGvDcez+sWUCy2MlFE4uWgqCi6InLxPnDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com; spf=pass smtp.mailfrom=os.amperecomputing.com; dkim=pass (1024-bit key) header.d=os.amperecomputing.com header.i=@os.amperecomputing.com header.b=lekmX+Nd; arc=fail smtp.client-ip=40.107.94.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=os.amperecomputing.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=os.amperecomputing.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yp5wBauZl2wePOwqkCgBKnOZR9F28Ce0F+2tC8MvYnLkFLykmm5pWpvdzPMLuWhws1Um07/2cB8p1XsIbJNaefSGgBDjigiVzqPyceYhShll3PiFEseZ8nkQ8lt8Z+ptG++qKzKmJjWjl1PMnQr5lw1aFO4nRDL9csb68OJURWp5sURKz8GmJW8fE1wdhT7icc8f3AtlG26mdzXpYunYNrgAa6y+HCuEChFi9qmR4z2IBdDrEqXpfeeUyqkt3vEj9WoaxD5MJREg7K1rPC+FXpQvMwqwR8lFr+rHg+lQwfPvvuMXE/+PgJOwXkmdIX5YzQEvD2lrxvg1RNUKps6Cww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tJg9WDoSwKsRtr66cabLbeXaiRmuLkG7x99iVOOulCg=;
 b=L34zr/mDL/A0ymXl3xcxZoX7uc0rQKc+/Ff2+6U4Z9qiVZtHm+nROCshI3gD5FHd3gKPrxQSr7KXgldNY3K7drhGjQQq/YYs9+NdYagUDlAZ5EGhVuQz+2kFmKY5Nf5uaiZyom1AgBXyc5jGBEKr3Ulqniml6sv8f/LpV05+LGquY8SvY0CDR0eXDkOnyAtfUXYoq0AY+IJ3nXDdOiPsZh8K6rF7JdT0r6mozrH9I38203NAO/1zG13jStiIU97jkZ3IHBfYFlt0hAFjSEkgmPr+Nxvrayd9KKLrMfDMKf7Q/HEsftF2bZJJ2zvbfVrJhcTbygRG7M5IVuacVUzTCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tJg9WDoSwKsRtr66cabLbeXaiRmuLkG7x99iVOOulCg=;
 b=lekmX+Nd78/mpo8LsH1uF+Yft8w4G4E3b248jTQScoBCcq0dyaIM/xNuzq53eZHy6XKzCZoCpD+QWTIeaby9b9bvwqa3fYPt0KZHX0zV4aN9tTnXpWfjqkLOSz7yQFUBNPyVA0+ZzkuGMh94Gw6N9yTp4PMR0N0If5K6goidcx8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from SJ2PR01MB8101.prod.exchangelabs.com (2603:10b6:a03:4f6::10) by
 PH7PR01MB7977.prod.exchangelabs.com (2603:10b6:510:27f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.18; Fri, 5 Sep 2025 12:13:36 +0000
Received: from SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9]) by SJ2PR01MB8101.prod.exchangelabs.com
 ([fe80::292:6d9c:eb9a:95c9%2]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 12:13:36 +0000
Message-ID: <73fa2e31-58bd-4461-a6cb-a269f22ba7a1@os.amperecomputing.com>
Date: Fri, 5 Sep 2025 17:43:19 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: nv: Optimize unmapping of shadow S2-MMU
 tables
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, darren@os.amperecomputing.com,
 scott@os.amperecomputing.com, cl@gentwo.org, gklkml16@gmail.com
References: <20250905062929.1741536-1-gankulkarni@os.amperecomputing.com>
Content-Language: en-US
From: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <20250905062929.1741536-1-gankulkarni@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5PR01CA0009.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:174::8) To SJ2PR01MB8101.prod.exchangelabs.com
 (2603:10b6:a03:4f6::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR01MB8101:EE_|PH7PR01MB7977:EE_
X-MS-Office365-Filtering-Correlation-Id: 565d7ea9-a3b7-407d-2ef7-08ddec75a41d
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NGdUZEN0b285Ky9jVXM1eDA0MDdVQVc2YjNmUlN1NVVDTnAxRmNLWksybXFy?=
 =?utf-8?B?cXA3em51UW9PcFZkUTFaUVg3dFU5TjhVTGJvYi83USs4VitLU2xtZlF3cDEv?=
 =?utf-8?B?c1pNc2E2WWI1aWZQNmVzK0pnb2UvVlZsM1FqdGtLaG5tNW11U05yTXdDTEZY?=
 =?utf-8?B?eEFKcGo5WFNzZlpWUXVaYVkwekYwajIweVVMNUdLcjdQYWt5T1FkSnVBcmdh?=
 =?utf-8?B?ZXhadVp1OTBvblFGbWEyZDZOVVN5WUswWTlrZElSNWFtUmZqVGs0d29rK2oz?=
 =?utf-8?B?a29NNEpuQnFvSGdzWENQZU5WNUp3Y1lFOGdQTmw4Zkw2dlVpNkh1TXg2V0cx?=
 =?utf-8?B?Q2dER3FVbXVkUnp4Tk9rUVBvRVZBQkt5Y1lOWnphaDVobk1JNWt4OG9LQ2xK?=
 =?utf-8?B?K3FCV1N2NHcvTU5GS25RVDFvTnFGSTFidytCSXdFRXFjTjFtaDlsRDhDTmp4?=
 =?utf-8?B?cTRYYmFkS01GL2xneE50ZjdGRDQ1cFJpbEwwNGhSNDNiQmsvT3Fjc1c4bHYz?=
 =?utf-8?B?NTBMOURXNU5TdFhrVHlzRDNjLzdpNzBFUVhoV0pLdW9vUzZpbjRjS25Bbm1Y?=
 =?utf-8?B?YUdxLzljdlRNM3R1dzArSzRENzF5ejhIaGgrRDIyd3h5NEtJR1UwNVE3QVNs?=
 =?utf-8?B?WjhxQ2EzSG9Qd1FNb2N6dUs5YVFzaXM1QUN0ckxxOWxrTTFJWXNhZGFzMkZa?=
 =?utf-8?B?RlUrdkMwcW5mSkRmdlF6TTVGSk5ON1ZRYlhHUUo2L3hENkgzWGFWUnljalRn?=
 =?utf-8?B?TVg5SlZodWtUQytHdlFXalBLbUM1azJhbXE3OEJXRG9tMSttM0tSRzcweW1v?=
 =?utf-8?B?alBWcmJiaUt1cit4NTBiT09idnNvV1Joa3hXcTBDc0hvK3RKY0JabVc3V0Jv?=
 =?utf-8?B?anpnbmtaalgwUWlpQ2hMbHU5NlhpRVoxVGRDZ1lkYjkwYmVTRGlYQ3UwcEVY?=
 =?utf-8?B?RFNkNjJyNUoyaGR0eGV5UXpXQ1Y1U1Jtb1NjN3R2RzBPU1ZXTEhFeGNDNVFk?=
 =?utf-8?B?UTBhbTRUUEtTQWdOSC9IS0txdnFHVGJ3UG1Oc0Nsb0NvMWFVM1lPWm1sOExX?=
 =?utf-8?B?YTNBenI5YlZnUFRxdFpaWWRwM3g2ZS9wVDlrOUt0NlF5NTYxYVY4UlIweXJC?=
 =?utf-8?B?MHllc3M1MUN4UHhyWDBsWXhGdWhyK0FydFIyRlNMQmh5WkdpYXJpNnRDWklN?=
 =?utf-8?B?ZDF4cWdQMWVjM3NienZWWEJnWlJYaDB6cVRUS09SWjc5VHE0RVk1Z3FnN1A3?=
 =?utf-8?B?OTZJK3Z4UGtpWGFEYUgrVHpDU1Z1YTlDcWswRmhSeGFiL1Z3Ty9jenJjU3pI?=
 =?utf-8?B?eGxwUjdUMUNqWFpVbVhqVnMxSm9JL3d1MDlwTEZPaFBveVh6b3haMnRGcDN6?=
 =?utf-8?B?SElSUVVTQXZLQTNhVUtyWVpOVHN5VEZhaUV2TkVoM3pEVEZHVEFHMFpVb2Nl?=
 =?utf-8?B?eW9PM29LeG5kb0hZVXJ5bkl0eDVBZC9DQ0J5L2ZmbkNoQnNMaDV3aFhnVWdk?=
 =?utf-8?B?OGlLd21JdFFRQVZxWnpNUjRVbUxNQWZMN1JIQ3VqTUpIRHVVZUl6M09tSk5v?=
 =?utf-8?B?bi9rWVhqM0dUd0tjemlpZ0xjZnNpVk9WZ2QyNEIrR0NzSEVTaTZYa0tqcTNi?=
 =?utf-8?B?T2JBZlJLWlB4b2dWRmdrbWRjWDZlU3kvODZkb3dOTjFZOElRaEN3R2RXNzZH?=
 =?utf-8?B?Si9hS1E5SExMcytES2dkM2pGT3pKR2JmRXBzSDhkeFlqWHhwb3cwcGlGRjFi?=
 =?utf-8?B?bS9GV2NjR2R0RmZ6TVJTQ2NwRWRvbm9NdWQxUXEyOENEYzRlR3QvRFhycU81?=
 =?utf-8?B?aFhCMFFoUzV6UGpkR25SWkVweWI2WTlGNll4QmRYdHFwOE9Na0tvMHhKSUFs?=
 =?utf-8?B?QTJsbXJHZnJ5TXJnRGFYNktkdWZuMC9nY2VBeFUvd1pNamJwSEdXNnQyWFMw?=
 =?utf-8?Q?7nKrlfghw3g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR01MB8101.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QzArSkY5dnl2cU1LYURaZkNZMU55clFsTzNKTlpZbmNybEVUMEYxMlprQXVo?=
 =?utf-8?B?QjJTK2pmOS9neEtTbXJWUjRyQ1VvWEZLWTJ4a3h3K1RrbU9FdXZ5dmtiM2Z6?=
 =?utf-8?B?WUVwVVdkcjhlUnMzQThvVFdDeW1tdElUeHF5TURmOE1rWnh0ZHdMUGUzNmQz?=
 =?utf-8?B?c21NRmZNbGxoQ3JJaS9HdDJJOU5kWGNwUm93WmFjWGNiaEZHdlVWLzlua2xR?=
 =?utf-8?B?ZEk0NUxOQms4bWErbFpBcEpVVDk4aklFYktaTnI2NTdBODFWS05EY3RRdG96?=
 =?utf-8?B?aWNnT1N5WHM2RkthOC9XazdyQ1lvM204SzIva2RyVjZIWk1BQVFkRmxreThz?=
 =?utf-8?B?UVBQRjlmNWpTV3ZxMGF6MG9wN2twUlB6TlhhN1pyTk1uUDU0dEhYcVZ6WGpz?=
 =?utf-8?B?S2tPYjNsZmpKTlQvcmlSTjZvaWxtdXRVeXQyNkZScWdEblN6NElIeCtYaE9I?=
 =?utf-8?B?YWdWaXRnaEVNTnpzd1M1ZlZ1UHFtNWRhSU9YZXdscjRwMWpoQloxTmtwRXV2?=
 =?utf-8?B?ek93bTFCblA2VnlobGNROXhUZGx3QlZ0eUNQc0NUbmxHWWdjdmZZOUFSVVlC?=
 =?utf-8?B?R3BMZ09sWFFWdFFhV2JpUElLQ0o2ZmhocXdMZURFVUxYSlVqV2Y5clQzSFQ4?=
 =?utf-8?B?eDFwcEJybGVBRjRJLzNuTFo4UXdPVk53THpMTVhJS2dmV3hmUm5DbDI0SS9Z?=
 =?utf-8?B?Nmtxak8vdWt1UnI2NXFxbnRxNEJmaUVaWmpPb2UxNXN3Ull3R3crYWU2cFkz?=
 =?utf-8?B?dHg2d2IzcFIrTEU4eFZheGFEbGdxNnlkaGJHSXcxTzZ3WGl3ZlI3M1RBdVJ5?=
 =?utf-8?B?SE9yRUtvOHd2aGpkZnNkVmtNNUgva1pEcDZUcGsrZnJqcVlzblMzdzR5OXpz?=
 =?utf-8?B?QUdVMCtuNEhWZmlwdFRUamxGSWtNMU92bkprajBPZXJ3Nmg3OExwS3dXVDRl?=
 =?utf-8?B?YTUwL3VIYzdESmxKTXpDeVlzYS8xa05XUExlRTRxRWJFaUYzbmRFYW42Uzdt?=
 =?utf-8?B?bW1zZCs0b3lGRWgvaXV4OFNEZGRXN2E0K2MrU29Rdlc3eTl3SjNldmUyNmk4?=
 =?utf-8?B?UFArN2R2eXRJaGovYmRZemt1akMzeDFna1MvUlRFQzZKUGtqUTBMN1NKamNY?=
 =?utf-8?B?cVN3dVJEUGZyVjd3R2VDaHIxVlpMKzNtMUtYYTV3Vmh5RlJmSVZBRGc2Y012?=
 =?utf-8?B?T01keGc4aHBaMjY4WkpnZXlsN005ZDNLU0dNWmZVQll4RkR6elRwK3ZmcHo4?=
 =?utf-8?B?dGwxY1J1bitHbitPcmM3M013MnBHNUhyK0lmZmFEUG5Ud1FYMkdyb3Nxb0hH?=
 =?utf-8?B?bE5lQ3NwNnc0NGlWa3hWZHVJWFEwYncyVHFwaE9mM3hvdmVxS0xDWC91RmFv?=
 =?utf-8?B?bGNXc2NaT0IweUY2OFlsQjlRcnpEVkhvQm1ad0w1Nm9ndUNybmxzWVFmclRL?=
 =?utf-8?B?YzB1ZkgxaDgzUFVKbVg1dE5xK0lqaHZBSWdDWFp1TFFrS1IvUlVRZmtrbVln?=
 =?utf-8?B?djdtTU8rNUNwdkVSOGd1ZVB3eFZQU1ErQlNxQ2FrRXZoaThub3BBQ2hrQ2o5?=
 =?utf-8?B?UFF2RU1lY29TT1ZMY3MyQ0VGSnJEc3BTVS9PV0srQ2xjVllXcTJGWVdsUFBX?=
 =?utf-8?B?eEFoZllJWkYrMTBTSVR3cldwM0VBbTBFT2kwZzk1ZWpKZkExQUpTdU8wOTZ1?=
 =?utf-8?B?QzVNVE5MOE1scEQ5UjRBaXZ5ZGIyMTZLR2gxRUNpV0VYYkhtVXd6c0s4Qk5v?=
 =?utf-8?B?SVpzNE1penlrMlhOSEt4aXFNNlhnTUVyM1NsOXRhWDJaWUNnYS9neGJja2Z6?=
 =?utf-8?B?YVk4N3p2UEFCTlJlVklyQllWa3NlZlBHU0UrR2MreldmWm94bGtSOHMvb3Z0?=
 =?utf-8?B?S05TWmMwWGk0eWVvKzBPcEt5SXVEdlZGNVZZaE1aalZDOWVsTkxpSmRQMUlN?=
 =?utf-8?B?Q3hkTTFBTWtlM2t2cExxSzh3MWE4bEhrSFRDUXBIYlBMajlFdUc1SU5Mczk5?=
 =?utf-8?B?bEZ2dXRCWUdkMitSeXNNc1lBVU9mK0I0SCtYWWlDYm9mOE5BcjRLaGRmNkdT?=
 =?utf-8?B?QlA4dUtvaCttZFAyVTUrSnBtaStnMU5NVUN6b3NRaXBjeCtBTUNES3Fkb3Nu?=
 =?utf-8?B?bHl6UTc2RDR2WkdrSGJLaXJqU2dMRkhrMTdaQmMxZVhtODAxajU1TWRSL016?=
 =?utf-8?Q?YjMcjfRjhUi/sURfRkVRYGw=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565d7ea9-a3b7-407d-2ef7-08ddec75a41d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR01MB8101.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 12:13:36.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HVlWhZoLNenkO6yG7dOz2MXoLED1GvLy55ZwBxxhgWAPiYHGkqVo6RI+fqLCjXczvAw8pAuBbMW+KUq1ooRqIiEiWRo2xAIkMdK8hb3JMfB3FjbnM2pZRIgO7VFCmdCQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR01MB7977


[My apologies, for using the old kvmarm mailing list ID]

On 9/5/2025 11:59 AM, Ganapatrao Kulkarni wrote:
> As of commit ec14c272408a ("KVM: arm64: nv: Unmap/flush shadow
> stage 2 page tables"), an unmap of a canonical IPA range mapped at L1
> triggers invalidation in L1 S2-MMU and in all active shadow (L2) S2-MMU
> tables. Because there is no direct mapping to locate the corresponding
> shadow IPAs, the code falls back to a full S2-MMU page-table walk and
> invalidation across the entire L1 address space.
> 
> For 4K pages this causes roughly 256K loop iterations (about 8M for
> 64K pages) per unmap, which can severely impact performance on large
> systems and even cause soft lockups during NV (L1/L2) boots with many
> CPUs and large memory. It also causes long delays during L1 reboot.
> 
> This patch adds a maple-tree-based lookup that records canonical-IPA to
> shadow-IPA mappings whenever a page is mapped into any shadow (L2)
> table. On unmap, the lookup is used to target only those shadow IPAs
> which are fully or partially mapped in shadow S2-MMU tables, avoiding
> a full-address-space walk and unnecessary unmap/flush operations.
> 
> The lookup is updated on map/unmap operations so entries remain
> consistent with shadow table state. Use it during unmap to invalidate
> only affected shadow IPAs, avoiding unnecessary CPU work and reducing
> latency when shadow mappings are sparse.
> 
> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
> ---
> 
> Changes since RFC v1:
> 		Added maple tree based lookup and updated with review
> 		comments from [1].
> 
> [1] https://lkml.indiana.edu/2403.0/03801.html
> 
>   arch/arm64/include/asm/kvm_host.h   |   3 +
>   arch/arm64/include/asm/kvm_nested.h |   9 +++
>   arch/arm64/kvm/mmu.c                |  18 +++--
>   arch/arm64/kvm/nested.c             | 102 ++++++++++++++++++++++++++--
>   4 files changed, 121 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2f2394cce24e..eac9405aee48 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -227,6 +227,9 @@ struct kvm_s2_mmu {
>   	 * >0: Somebody is actively using this.
>   	 */
>   	atomic_t refcnt;
> +
> +	/* For IPA to shadow IPA lookup */
> +	struct maple_tree nested_mmu_mt;
>   };
>   
>   struct kvm_arch_memory_slot {
> diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
> index 7fd76f41c296..89f91164bc4c 100644
> --- a/arch/arm64/include/asm/kvm_nested.h
> +++ b/arch/arm64/include/asm/kvm_nested.h
> @@ -69,6 +69,8 @@ extern void kvm_init_nested(struct kvm *kvm);
>   extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
>   extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
>   extern struct kvm_s2_mmu *lookup_s2_mmu(struct kvm_vcpu *vcpu);
> +extern int add_to_ipa_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa, u64 ipa,
> +		u64 size);
>   
>   union tlbi_info;
>   
> @@ -93,6 +95,12 @@ struct kvm_s2_trans {
>   	u64 desc;
>   };
>   
> +struct shadow_ipa_map {
> +	u64 shadow_ipa;
> +	u64 ipa;
> +	u64 size;
> +};
> +
>   static inline phys_addr_t kvm_s2_trans_output(struct kvm_s2_trans *trans)
>   {
>   	return trans->output;
> @@ -130,6 +138,7 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
>   extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
>   extern void kvm_nested_s2_wp(struct kvm *kvm);
>   extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
> +extern void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size, bool may_block);
>   extern void kvm_nested_s2_flush(struct kvm *kvm);
>   
>   unsigned long compute_tlb_inval_range(struct kvm_s2_mmu *mmu, u64 val);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1c78864767c5..e9bbc8275a51 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1784,6 +1784,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
>   					     __pfn_to_phys(pfn), prot,
>   					     memcache, flags);
> +
> +		/* Add to lookup, if canonical IPA range mapped to shadow mmu */
> +		if (nested)
> +			add_to_ipa_shadow_ipa_lookup(pgt, ALIGN_DOWN(fault_ipa, PAGE_SIZE),
> +					ipa, vma_pagesize);
>   	}
>   
>   out_unlock:
> @@ -1995,14 +2000,15 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
>   
>   bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
>   {
> +	gpa_t start = range->start << PAGE_SHIFT;
> +	gpa_t end = (range->end - range->start) << PAGE_SHIFT;
> +	bool may_block = range->may_block;
> +
>   	if (!kvm->arch.mmu.pgt)
>   		return false;
>   
> -	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
> -			     (range->end - range->start) << PAGE_SHIFT,
> -			     range->may_block);
> -
> -	kvm_nested_s2_unmap(kvm, range->may_block);
> +	__unmap_stage2_range(&kvm->arch.mmu, start, end, may_block);
> +	kvm_nested_s2_unmap_range(kvm, start, end, may_block);
>   	return false;
>   }
>   
> @@ -2280,7 +2286,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>   
>   	write_lock(&kvm->mmu_lock);
>   	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
> -	kvm_nested_s2_unmap(kvm, true);
> +	kvm_nested_s2_unmap_range(kvm, gpa, size, true);
>   	write_unlock(&kvm->mmu_lock);
>   }
>   
> diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
> index 153b3e11b115..07b7bd3f66fc 100644
> --- a/arch/arm64/kvm/nested.c
> +++ b/arch/arm64/kvm/nested.c
> @@ -7,6 +7,7 @@
>   #include <linux/bitfield.h>
>   #include <linux/kvm.h>
>   #include <linux/kvm_host.h>
> +#include <linux/maple_tree.h>
>   
>   #include <asm/fixmap.h>
>   #include <asm/kvm_arm.h>
> @@ -725,6 +726,7 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
>   	mmu->tlb_vttbr = VTTBR_CNP_BIT;
>   	mmu->nested_stage2_enabled = false;
>   	atomic_set(&mmu->refcnt, 0);
> +	mt_init_flags(&mmu->nested_mmu_mt, MM_MT_FLAGS);
>   }
>   
>   void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
> @@ -1067,17 +1069,94 @@ void kvm_nested_s2_wp(struct kvm *kvm)
>   	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
>   }
>   
> +/*
> + * Store range of canonical IPA mapped to a nested stage 2 mmu table.
> + * Canonical IPA used as pivot in maple tree for the lookup later
> + * while IPA unmap/flush.
> + */
> +int add_to_ipa_shadow_ipa_lookup(struct kvm_pgtable *pgt, u64 shadow_ipa,
> +		u64 ipa, u64 size)
> +{
> +	struct kvm_s2_mmu *mmu;
> +	struct shadow_ipa_map *entry;
> +	unsigned long start, end;
> +
> +	start = ipa;
> +	end = ipa + size;
> +	mmu = pgt->mmu;
> +
> +	entry = kzalloc(sizeof(struct shadow_ipa_map), GFP_KERNEL_ACCOUNT);
> +	entry->ipa = ipa;
> +	entry->shadow_ipa = shadow_ipa;
> +	entry->size = size;
> +	mtree_store_range(&mmu->nested_mmu_mt, start, end - 1, entry,
> +			  GFP_KERNEL_ACCOUNT);
> +	return 0;
> +}
> +
> +static void mtree_erase_nested(struct maple_tree *mt, unsigned long start,
> +		unsigned long size)
> +{
> +	void *entry = NULL;
> +
> +	MA_STATE(mas, mt, start, start + size - 1);
> +
> +	mtree_lock(mt);
> +	entry = mas_erase(&mas);
> +	mtree_unlock(mt);
> +	kfree(entry);
> +}
> +
> +void kvm_nested_s2_unmap_range(struct kvm *kvm, u64 ipa, u64 size,
> +		bool may_block)
> +{
> +	int i;
> +	struct shadow_ipa_map *entry;
> +	unsigned long start = ipa;
> +	unsigned long end = ipa + size;
> +
> +	lockdep_assert_held_write(&kvm->mmu_lock);
> +
> +	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
> +		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		do {
> +			entry = mt_find(&mmu->nested_mmu_mt, &start, end - 1);
> +			if (!entry)
> +				break;
> +
> +			kvm_stage2_unmap_range(mmu, entry->shadow_ipa,
> +							entry->size, may_block);
> +			start = entry->ipa + entry->size;
> +			mtree_erase_nested(&mmu->nested_mmu_mt, entry->ipa,
> +							entry->size);
> +		} while (start < end);
> +	}
> +}
> +
>   void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>   {
>   	int i;
> +	unsigned long start = 0;
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
>   	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>   		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +		struct shadow_ipa_map *entry;
>   
> -		if (kvm_s2_mmu_valid(mmu))
> -			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu)) {
> +			kvm_stage2_unmap_range(mmu, entry->shadow_ipa, entry->size,
> +					may_block);
> +			kfree(entry);
> +		}
> +		mtree_destroy(&mmu->nested_mmu_mt);
>   	}
>   
>   	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
> @@ -1086,14 +1165,19 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
>   void kvm_nested_s2_flush(struct kvm *kvm)
>   {
>   	int i;
> +	unsigned long start = 0;
>   
>   	lockdep_assert_held_write(&kvm->mmu_lock);
>   
>   	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
>   		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
> +		struct shadow_ipa_map *entry;
>   
> -		if (kvm_s2_mmu_valid(mmu))
> -			kvm_stage2_flush_range(mmu, 0, kvm_phys_size(mmu));
> +		if (!kvm_s2_mmu_valid(mmu))
> +			continue;
> +
> +		mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu))
> +			kvm_stage2_flush_range(mmu, entry->shadow_ipa, entry->size);
>   	}
>   }
>   
> @@ -1737,10 +1821,18 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
>   {
>   	if (kvm_check_request(KVM_REQ_NESTED_S2_UNMAP, vcpu)) {
>   		struct kvm_s2_mmu *mmu = vcpu->arch.hw_mmu;
> +		unsigned long start = 0;
>   
>   		write_lock(&vcpu->kvm->mmu_lock);
>   		if (mmu->pending_unmap) {
> -			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
> +			struct shadow_ipa_map *entry;
> +
> +			mt_for_each(&mmu->nested_mmu_mt, entry, start, kvm_phys_size(mmu)) {
> +				kvm_stage2_unmap_range(mmu, entry->shadow_ipa, entry->size,
> +						true);
> +				kfree(entry);
> +			}
> +			mtree_destroy(&mmu->nested_mmu_mt);
>   			mmu->pending_unmap = false;
>   		}
>   		write_unlock(&vcpu->kvm->mmu_lock);


-- 
Thanks,
Gk

