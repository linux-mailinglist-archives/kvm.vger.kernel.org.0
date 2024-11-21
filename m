Return-Path: <kvm+bounces-32265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 460C39D4DC5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 14:29:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE1721F223D8
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 13:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF361D88D1;
	Thu, 21 Nov 2024 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BX8S4lHH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92AE1D79A7;
	Thu, 21 Nov 2024 13:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732195748; cv=fail; b=B79XtTvvDkjddxqH+KmilN5OkH/AZ93yTMh4jUCauCx7v0D5jT2f24HXo96O9TWIUxnKjqN8jeYtq+TrUDd9bLPWmJyQkSIF6NMvikcvHAbKqSp9yXSicMNKF79zRxj51F0XWbOovlBQoWmNX6sscNqDR/Ph/TK71iUMwSiDblE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732195748; c=relaxed/simple;
	bh=wURl3ndFGTTIMFOgloGGjptllEePhFecE/laNKpUnr0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=c/MEdHbv6Uso+67PJUt6vX7juTVDk1YIVo8BmLooUdGyUlMAqO8/UR6bea2AkXSMTa9/kPl8KXE7rjR4wx1dsjW2J2Y1Djp0C/0mwIziCKYF0BQ/2Ev1Zb8Vlu9Jrxy4hevm+beUycYQtbN5zNjC9qwmRsX1pGsTIxOhK2STHmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BX8S4lHH; arc=fail smtp.client-ip=40.107.244.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J0F3iDSVTgniCfeakoc4YbJDErhMO555zyRgM7RPi8RSQaoXCwF9PC0MXDojC+Syn1bTlIRhpV4WVK2b/xaka6X41tjonPtHbbN/O1NIteYFpoEAOzKaVI99Q0D0WrxiyrO34bL1a9ok1VjH8TCpyTjqCA9WXKVpWRqvP1mG/RFJyK1/xlXmEe0PKrk9GAYNy3p+dDf8imhl9N6Aw24n4UFRsb3UuVwFM/QTie1Lu6WLSfMnkOLnYpS729PYqKtjVJrzI0tADAFx+aNWEvgF1UQiUC/EicoejcINTBs5tJ7t0FOqKRF3mqnVLL0pcOjEVWs8GVjStK9cHsbopKAJvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wURl3ndFGTTIMFOgloGGjptllEePhFecE/laNKpUnr0=;
 b=n1BN37EBVr//G7eZ3hP2GNz4OuUm7x83HCjSo1WPRkjxBUxHJ9MOE9mYfOZ5ctP1liHo3cO2TbEmKQK5AwjxGzomhtYPgbjdxXJQ6hLernBUJY0Ad2WMBKx+PuQzrT7esDLU+gjR0AGjAExtdSUdVoaPIShbEqgAi3H/iVmC+W89xdOnNUHIkhWXC8e7d/Hd+pK6TnBPW8MNNPw1XthHvYCBcoLws4pYDRPtewl2GN+kkXOw43jRkGxMQEHjle6ks/YHG07UD2rt09A7zmsWGQYhmO055hLx7K/93n/dgqzk6VeMuqizAlxurnnvVDHvA3NL8SqOycThEJCDVrruaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wURl3ndFGTTIMFOgloGGjptllEePhFecE/laNKpUnr0=;
 b=BX8S4lHHU2mJ3HZa/QHerx51vWr4FdrBredikdGPZcWjKChzL1PDK1SMl8PYXiuxtvEdOJMO6xCdzF1eILkthKmz1DxfAitwP9Z46uwkty0znM9cVnXQ58VXMXler3oW/fqVz0UA7Ep7VpPXNxrDtfjaTKNunCenPh2tD3WYkkM=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by PH7PR12MB5736.namprd12.prod.outlook.com (2603:10b6:510:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Thu, 21 Nov
 2024 13:29:04 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 13:29:04 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>, "x86@kernel.org"
	<x86@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "amit@kernel.org" <amit@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "Kaplan, David"
	<David.Kaplan@amd.com>
Subject: Re: [PATCH 0/2] x86/bugs: RSB tweaks
Thread-Topic: [PATCH 0/2] x86/bugs: RSB tweaks
Thread-Index: AQHbOx27FHMEBwhGzUuBCXzw6TDYzbLBvGwA
Date: Thu, 21 Nov 2024 13:29:03 +0000
Message-ID: <96f4f510fe3bf21263b7d5f9f2ab14c5f8a3266b.camel@amd.com>
References: <cover.1732087270.git.jpoimboe@kernel.org>
In-Reply-To: <cover.1732087270.git.jpoimboe@kernel.org>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|PH7PR12MB5736:EE_
x-ms-office365-filtering-correlation-id: 9faa254b-7ff1-4794-866d-08dd0a3077ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SFJQaFA3N2d2TXZMUzlUV1poUlNGelh3Nm1JNjVjY2VKRngvRUljaEswY1BQ?=
 =?utf-8?B?NWdwMi80NHUva1FSZU02T0szR1ZyTk1hLzdJeHpkSHZ5dVF3V1RyaTZxTVkr?=
 =?utf-8?B?eXBqRVdKZnB3RVQ3dXZOUEhveit2LzJrbkF2OENiV0hLTlJvaUwxTU9Xd2tw?=
 =?utf-8?B?T2xvWkJLOGEzMEUwL2J4NjVWbkhyWWhRL1dTUTJ6bzRrVXhEOVNNMnlYclFB?=
 =?utf-8?B?MzNvY0daZEQ0TnFxWU10R2RYVStZSDl1K3hQenByWkdyMGtzY25ZZEF2QmN6?=
 =?utf-8?B?WURQaGs2YlFDVERUUnlsQm0xWERYcEtBanM0NUgxYm8wc0dOMlBmYnk2SERj?=
 =?utf-8?B?MUVvSitNVGlWVWVINzF6UkhXSGRtSERWQzgzMi9vOVg1NWg1VlYwb3diakgw?=
 =?utf-8?B?dUtwVExGMXIyNlNoT2kxOGR4L2I5MGI2YitPdmxmdUhYM21uVGtmbklpd3ZL?=
 =?utf-8?B?WHpwY0Y5Mk9KNzcxV2wxS0VzQlIybHk1K2N3RFJsajdkdlJGa1ZZcWZQVmx6?=
 =?utf-8?B?clZjRjZnOGRrWi9DWm11ckFkTFhvV2UzOFJMRXVycVo3N09OakJwMUJCelNL?=
 =?utf-8?B?Q2lZUGlNMkRLL05JZVF5amdvaHYzRW9RT1VyaDZEV3hPdmFKYWg0TituTWtu?=
 =?utf-8?B?aCtBRTV0S3BSQXhBclQwVnVTV1FLSEFzUnFXZHlHUEdMQ0N5cENrVjRQQ0wv?=
 =?utf-8?B?VnNaQ3hNakcyNldNT3EvMTc0a0ZuWndzdVBRckVpME9aRDR2cmQwbDRFMHBL?=
 =?utf-8?B?aFcyeDRYZDlIMjltTmZ6MHd6UkVrY1dPZytDdG9tVXRob2RiSXRvajd6RzFM?=
 =?utf-8?B?OVNIK2NQTGFmZ0lhbzBiVmxXa085Y2Q1aUd5N05sSmFyV1BPMDJTUkZ2L3pm?=
 =?utf-8?B?cGRYNW0wZ1JtVHB2am9XYUtacnovK0FKZlAxdFJCaVByZTg1R2d2L2xSU2pZ?=
 =?utf-8?B?dGsxS3dld1lZQVY3MzdTSWZGYy9ZaW1tTFlQMWRLZUZPUm96MUpPUHg0ejJ2?=
 =?utf-8?B?OE12Vi85U2hqcVdFcmY5MUJHbnlOV3pUMEJGc0ZQUkFKaVhBZHMvNGhEcWhz?=
 =?utf-8?B?RnIyWE54cUxmK041cXYxU1dnbHcvN2VQTndsZHkzekZHU2pIdFdKbisyeTlK?=
 =?utf-8?B?Ny9sbjg3U0YyaTJ2aWxqRndlb01YVE1EdTdNV3VKTWpDT1dVdmIwMk1EZWJa?=
 =?utf-8?B?N3VoTmtxZXRSK0h1MXJJSGZOaUQxUmdCbTQrVTQ1VlRkS05mU2F2aGZFMndC?=
 =?utf-8?B?anYvR2loSnNhZUZESml3SVJRSzBmUmgxVC9hVVg3OGtWV1NnUEk3ZE1sUGtI?=
 =?utf-8?B?ZUtRVDRxQTRRaXE5V1lJVWJqZXI2NEI0VTYrWXBtSFcrbE5YcVg5SHE0bUtK?=
 =?utf-8?B?SjcrWXJ0R1JNU1B6UEdYNUcyTVVxMXlKUUphaVhrR1ExOHRYTDkweTRwRm1r?=
 =?utf-8?B?YmdIb21rNGJzWHJWOTBTMWpyZ09ZWDZGVndGTG43YzA1dlBYOU1rdlArSUYz?=
 =?utf-8?B?alloUHFYdHBtRHFsNG53b09naUIrSjlrMEdLQnNXb3cya3ZtQm1CcHhQTXJm?=
 =?utf-8?B?UkdGRzV4dm5RT1Y0VmQra1YxNmlUSEdsSURhLzZCNGtsTTJGTnZWOWZUTEVM?=
 =?utf-8?B?TDJpMXhSeGQ1VDZleG5yZ1k5MzFIQTNoYWMxd1hicVRpMk1YRVczYlpubzBW?=
 =?utf-8?B?TVVOa1IrbmY1TTVCS21iak5aWnBTSk5NcFRMbUpYSHVJWWdpaFluSE9nc2h5?=
 =?utf-8?Q?dCmYeNpEHunOjfSmXSiHa2MPdtFdtBr/Ukxew79?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Z2hpQWtHVGJRK3UzSGQzbzUycHc5c1dJZHd4YlpkRGJJajdhZVpDUytIemc3?=
 =?utf-8?B?MUM0VUtzQkpnTUYvYnkyVFVaK0ZCR1hGeFVSa1VOV1Z3L0xkY2J3blhMQTJ6?=
 =?utf-8?B?L0I0bENtMzZ3a3dZREMzOVhPS0Rxb1VONFRSQVQvTVNUYWk1NE9ZSDk5bG1W?=
 =?utf-8?B?U2JIQU15WEsxc1huS0R3NE5EczVERWJManptQXRQQnFBQ2tpWFM0VWJCMTV2?=
 =?utf-8?B?RVY3Z3F1bDQxdzdGT0lBN0lFenAvL2VqY2gvSVZGY3JTTUxNL0x1R1NMZHQv?=
 =?utf-8?B?NkFHN2htaHMzb2pCWmh1LzAxQVg1VkdmYTZFd0ovWkJkYjZ0QzZ5M0srcDZ3?=
 =?utf-8?B?cDFwTTRZYUNpWHF6eGVCYzVHZnJkRVIxZjFjT3Z5ZkM0eUFqaHZSazgyOHBz?=
 =?utf-8?B?YThva09MLzFVYzByODlyOHFiTGhzTElneE1XU0xUUkVuUDlIelRuTnJGdFpL?=
 =?utf-8?B?Ym95VkNOaWtsRUdGbXZLNTZUNHZ1NUxhc1VmM2hQOVJrdE1WNHEvUGxub0Rh?=
 =?utf-8?B?RFpTTXVwcjNVeEpZWVNRVXZCT0E2U2tOWVlXY3VLYWtSRDZIc3h2SlRVTUpi?=
 =?utf-8?B?eFdsQW1aR29tY3NKazdqcmZuU3ZUZXJpV0ptU3MrZC9VYnJHNzB6VjJnSnQ0?=
 =?utf-8?B?eFBPaEs1Mi9WNFZUdlA3NTEybnBURFQ3MzlsZlkxZ2toZHdTVFVFbk8reGdI?=
 =?utf-8?B?ODV4RVZMMjFMa3FQQ0VWMHJEY2ZWSkV5bkFjQkVSRFVrejlCN2tibnZhUVFt?=
 =?utf-8?B?RUR2TjhyRnk3U2lFRzhJQTVaZ3hRYytSYkZjcW5hYzBOUHdpRzFoNEJSTDNu?=
 =?utf-8?B?Mk1NM1VYbTNiTmp4QVloTktYd2h0N3pUT2JPK0xFWEFiMXArWDBERDNYZGFi?=
 =?utf-8?B?L1IvRVdoVzVzWDFEeExROVNMUnkwWURZZ0o3RVRLb0w5Syt6SWkrM29XN0JT?=
 =?utf-8?B?dzlQaExWbDg3Z1M0TGVHZ1ZJVUpMYStHT3l0QS9ZOW1nQlpiU2Fob0g2S3FJ?=
 =?utf-8?B?OHNqMzRvOURTcC9DTGZkZzhEeVZpNXJhcUloVFJZSS9MSzZNa09jQUZsT25M?=
 =?utf-8?B?Y1FOSmMyVGVFVCtmTm8rdGhHUTNweDVpcEp3dU5LQUkxN1F5TEtHSkVzOVdV?=
 =?utf-8?B?S0tQUit5M1JqWXZaUUZBOHZOVGRQbHN2ekdkbHZueU51ZFNRbzRoUGdqczkr?=
 =?utf-8?B?SlRibEhZaFZZek94djZWbndENTZqNkxMcVJNMHlGRmZmWXFHQzdUNFhlOGJS?=
 =?utf-8?B?aXpYZHpyMzZnazgvL3VVRGszV2QwSkRkaFkzcnVVQ2xDY21OL25hV216Wmor?=
 =?utf-8?B?NGxRS3lmVjZYczQvTjFadjJUait0T0JIVkltRnRxVjVwRVBQbVc1bzlOazY2?=
 =?utf-8?B?VTBCWGY5eWg5c24rTi9qcE5LODd3Q09sSUpTVzdwTVVBKzkwSURrTjE2UVFF?=
 =?utf-8?B?TUdWYWZwaVI1VU0wVUE1SGdrVkFYOFlSbmFWQjdxTS9mYXZ4b3dXR1dmNkdW?=
 =?utf-8?B?STJTV3FlTVFBWjBGRSszUUJIQlVsV1IrUDM0WSswZTNmVUhyVXhGMUVPamYv?=
 =?utf-8?B?eXZpZ3VmM3pUbVhYclF6QzRaVWt0SEtlYnl6MUd2ZUo0R3hEd3lDZWhMWlda?=
 =?utf-8?B?ZUJ1Z25XVzRBMGUvUWwxZXgyZ2RnbHgycnJPaUtQMnIrRk9ZTVhFdE50aVZB?=
 =?utf-8?B?RitkbE5hcnN1c2xhNmdUWEd5TDF0TWw2QmhHMit0Q094cVpiN1lnTFZzTC94?=
 =?utf-8?B?TmpsRjZtdkxJek1IeEgzd2RxL29Zbjkycmt1NXYvcHFRNHE3S2NoYVdtMmRI?=
 =?utf-8?B?eDZLTlJ1YUdXc1FSSEQ2dzh2MkFCU3dKM0VFWHp6U0ZqQWs0VTF6RFNJMVpa?=
 =?utf-8?B?VEF3U0w5b1VRbDRXSUlud1FiSU5CZDExL0hFVWM5VUZZSWlFQUF3M3VZZTIx?=
 =?utf-8?B?aVNzRzNoYVlsYXVyRVZFYjZaZDJGSmtEZmFQeC92ZTBsb3BWcVlwMG1nOTZG?=
 =?utf-8?B?eUFNZDBBakhPaUJiOUNLTk5xaTd4bzU0L0lVU3ZyVzJONFh4dnQ2OWF1OWlH?=
 =?utf-8?B?RU4vaXBRa0RjS2d0aFNtY3ZlUWlYcjlldDBzWStmVkhZM3RXYmg2Y3JJeDZm?=
 =?utf-8?Q?OnetlrepWvs/+V/wmHzfxnbtW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86E7C8646227874AA9D9800DE73E7E88@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9faa254b-7ff1-4794-866d-08dd0a3077ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 13:29:03.9490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iqqsMnWaSCEkN97iZuP8Dor/qEpm+NRv5tjJIh5oh9EX1J4zIcYP4MVVp6cvjBGhISvm/+y6J7+djVkFaB65FA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5736

T24gVHVlLCAyMDI0LTExLTE5IGF0IDIzOjI3IC0wODAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gU29tZSBSU0IgZmlsbGluZyB0d2Vha3MgYXMgZGlzY3Vzc2VkIGluIHRoZSBmb2xsb3dpbmcg
dGhyZWFkOg0KPiANCj4gwqAgW1JGQyBQQVRDSCB2MiAwLzNdIEFkZCBzdXBwb3J0IGZvciB0aGUg
RVJBUFMgZmVhdHVyZQ0KPiDCoCBodHRwczovL2xvcmUua2VybmVsLm9yZy8yMDI0MTExMTE2Mzkx
My4zNjEzOS0xLWFtaXRAa2VybmVsLm9yZw0KPiANCj4gSm9zaCBQb2ltYm9ldWYgKDIpOg0KPiDC
oCB4ODYvYnVnczogRG9uJ3QgZmlsbCBSU0Igb24gVk1FWElUIHdpdGggZUlCUlMrcmV0cG9saW5l
DQo+IMKgIHg4Ni9idWdzOiBEb24ndCBmaWxsIFJTQiBvbiBjb250ZXh0IHN3aXRjaCB3aXRoIGVJ
QlJTDQoNClJldmlld2VkLWJ5OiBBbWl0IFNoYWggPGFtaXQuc2hhaEBhbWQuY29tPg0KDQo=

