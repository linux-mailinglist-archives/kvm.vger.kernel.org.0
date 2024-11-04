Return-Path: <kvm+bounces-30499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 797B39BB32A
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 12:26:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CB511C22182
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:26:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0871CB512;
	Mon,  4 Nov 2024 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hlHMhYSc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADAE1B392F;
	Mon,  4 Nov 2024 11:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730719016; cv=fail; b=mRwpOH4EAyubWU9pL4Yhv5J+dk0v95LZ9/iZAgKmPmlaeu06JKvKoDHG45UgErHaNvS2yrp16OC3SWQCLpeMNCumNa60YVbTl4ltUwdcTAXC4wxx2Wt5qhkG3VdDiAbmf9JyHA9C3cx6PvUz2ByyjEdKkn4QZ4QP06SPK4xALMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730719016; c=relaxed/simple;
	bh=zuYdeGld+ZO7PlERfp0qGM1EwBqSEIcU+Im9quaCtGg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j85T5q4oTjq9+3lpypWmzOpJCYuKaDB1Dq9P8fUyPYugxEPT+E17vYlqIt/iJBYakmGXkZeGDf6+Kn9WsXRpkCZ461FvQSLg78fAdLXlmMYINh+y8Ecu0+UKku128JhffHQ8nHiO6ieRphgSZ8MYWFgZgrle8U3vyik1STKkqCw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hlHMhYSc; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qhun1od/NmlKnbtH3BXfWp+mV+/jB2+BsIWsMGn6JekIaNpqdIA5id02wnEwGTLzy2evsOlV4oQeyH159zq+ucnieFpyXclTF0k69CwNDeBNogoFK3cMZgv5TVlmVWry6ZCGIbQbXPKDc3y2hFzG28q9zxU3nEVMt01D80yp7EVvTxV4nkb9TPkR9A53DTVo095+JCX5wkAeBx6mBkHTskorQ/voETcSgG2A1K2V2s6tdG7DSjsbMJyfgg5bIw+UQn6T8Qq5tHwo9d1MIbr22ZmnbFTw1dfMl1lMVxKG4gOx0jKFyJWaYtoOUVA53dTfAuZZACcCoK++9de6WzxETg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zuYdeGld+ZO7PlERfp0qGM1EwBqSEIcU+Im9quaCtGg=;
 b=nJvOTBGEWNRpxiE+dlTslOKehZtOr+LQDpvut15T9BBaVeCZ3fY/TFv4LXlAwMqLghdtFIyzTZrEmi3sX0NsVFBu8c+IuRWVIQcS4rJsZju4l66N1V+FJTwQ6GDV5BL23gCNy4tDfyyVoKXcTlDV/F34zto9DTl6qvQGDsN+jtEQgYqoJJ45z8FhTcsy7UZbjl8cVKZt3+2bvEs88vP+emYR8FioYPtSsEQ09wriR0HwQHC60bm4Oi+dz7QsWZjY5uu2JoG6dgazuJjAkoGM7oTFwFC5D1qNZkq0klyvvrm/jz7B3gmcccKfyjKClUKhT/Bm/DOkcZbDbfEDL64ySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zuYdeGld+ZO7PlERfp0qGM1EwBqSEIcU+Im9quaCtGg=;
 b=hlHMhYScJv1WjIQN6mLsEQEbY63I8qHH1LuOSjfz9GweJfBPnqSzkU46ejJnJo+EAC3N8m3CVBBEw86+SlXcUDd83FlE2Z9KPCEoMtlW1AtdRSoC4IBHF3yjvwnVw2CarqNVHI0nJowT10vHIN3HbGs8tFm3Qye199yvPEPoG7M=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by IA1PR12MB7567.namprd12.prod.outlook.com (2603:10b6:208:42d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.26; Mon, 4 Nov
 2024 11:16:51 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8114.023; Mon, 4 Nov 2024
 11:16:51 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "bp@alien8.de" <bp@alien8.de>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "Kaplan, David"
	<David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] x86: kvm: svm: add support for ERAPS and
 FLUSH_RAP_ON_VMRUN
Thread-Topic: [PATCH 2/2] x86: kvm: svm: add support for ERAPS and
 FLUSH_RAP_ON_VMRUN
Thread-Index: AQHbK6sjp68Pe3w8SUCLsPsm8cY/m7KmmsEAgABj/wA=
Date: Mon, 4 Nov 2024 11:16:51 +0000
Message-ID: <4b68e44861ea35bb463dd504bfdde0577b0e3cb7.camel@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
	 <20241031153925.36216-3-amit@kernel.org>
	 <20241104051856.GNZyhZQOvGlcWFn8Ey@fat_crate.local>
In-Reply-To: <20241104051856.GNZyhZQOvGlcWFn8Ey@fat_crate.local>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|IA1PR12MB7567:EE_
x-ms-office365-filtering-correlation-id: 1e4ddd2b-8885-4e6b-51aa-08dcfcc22ebc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SS9TQVF4blBZZko0ak1tN3JWRnM3NUFVRUZ1blpmRy9OSzRNU0MrQXZHY1Jy?=
 =?utf-8?B?dnpVcldKMFVmL3FuZFFIZklIV2JJRGRTQU1lL0lFR0lCNEs5N0ZaT2ZWdjl5?=
 =?utf-8?B?WURobkoreFFoOVRPcTd6bEVwR1pybnhialAwTzhtVEoyR01LWlBRTkdtUzV1?=
 =?utf-8?B?MXN0SFAwQVZsVldKSGt0TkFaUnRPV0Z4ajd1QlRZbFM1dEFNQnRJSDVOREhp?=
 =?utf-8?B?dmtEbVVrbEp5QlVDejIxMDYzR0l4YUFvZzMyeGQzb25MVCs5cldwbjN0S05j?=
 =?utf-8?B?dUZqZHkzNVR3QjljUVBrVGJBR1VTRU5Xc1phdWVRZEcvTkk4ZnBZV2FiRkVk?=
 =?utf-8?B?SEdQaWkrWkt6aHlZUERoc0g2ZUlHOGFueHBVMGcvNFV1NWFYZ3dDN1VOQlRZ?=
 =?utf-8?B?K2Z0blN4NFNQOUlWeWtxZWZ2WTdFc01wMUg5ZWhGcDhzSlFzUndsL2QrcVNX?=
 =?utf-8?B?YlNveWZFWktsZFJ2Y1hITjIvK2pkZU1meXRsU0s0NEF1TVVLMWVmSmJOZlVY?=
 =?utf-8?B?cGxPL1hCR2VvS08yOXhSWjM2WDlIQnlOdm5Sc21kbUl2ZGYvelpWMWViTC9R?=
 =?utf-8?B?ZDlyRUV3N2x1TXlGcm02STV6L01EeUNiVERXVFp2UXVZTXYrRE9PWHFycUFP?=
 =?utf-8?B?QzZaRGxrTzZLa1BNcDMyUXdiYkhReTNLQnE1MjExbVNwbHdwOThaU20vcnNu?=
 =?utf-8?B?SHBVSkgrOXgydnlob2hMSkNLQ3B1Y3RkNktLNDFZbllnMkt6djBNeWNLZjhL?=
 =?utf-8?B?UDkyU0huMGw4dTdQbFJiNFJvVGM0YUE0ZXlLWDJMSzFCc042SlRwOVNLR0hi?=
 =?utf-8?B?NzhiL1BaQlZFMmhwbmlwVExIVXBnNGVEZU8rTUF0Q2EyS0NzTTlWOVNYV0VQ?=
 =?utf-8?B?OU5mS1RXbzBYZVVqTG9BYW5jZEZRRWVLbUR3amtPRmtZUi9kSlhETGJqdmc4?=
 =?utf-8?B?Vm52M3RNa3JlZytOVHFRckVmS2JseU5ieUkyQWxzYVJ2eFdGSkRySmRLMzBD?=
 =?utf-8?B?dmNlWW9WNVBiUUFHRDZ4bmxhemVJc0JUMytvSDhPVUpJd3pQeFdsN0ZpSlV5?=
 =?utf-8?B?NkNzOVYwM3NWd25OS2ZVYlp5SGhheXk3eGk2QldFVU1KNXJRdGRuOUV6UWRw?=
 =?utf-8?B?bUU1Y2ZyVW56blkyc2pWbE14MEQ3Z0FuUkxQRVRVVS80OGNEcE9kaTU4N0Uy?=
 =?utf-8?B?cTJnQ2tOYUJqVGhHdHBUWlI1a0VaVjd2UFZEODZxZjRaNVBDaGE5bWJrNDEy?=
 =?utf-8?B?dFYzRDAzcGJCR1lhNW5EWDRIa2RkL0ZiYTRrSU1CeUdDdXh3YVJCMlYxVHdH?=
 =?utf-8?B?ODZwbHZUdEY3YnROTXM0VW1hTGluVzJ2N3hhbmorMmdSMVFwL20wSGlmR09R?=
 =?utf-8?B?OXFiYkFUWTBqSTNCTUFQZG5vNWUyRzlsVitSN3BtMDZzdVlWZmkxYkdwUU9G?=
 =?utf-8?B?VldTd3U0d1FFSFJqOVlNVy8wUmZyN3U0OFhFYVpleUxGWVcwZkJIZDVNSm5w?=
 =?utf-8?B?R3FpcDZDRUpEYTE1emZpNUpxVU9mdDI5Rlh6a3dyb0M1STMzN1FLUGxJWjA4?=
 =?utf-8?B?QTJqV1BmUkxaaVlON3ZxMmk1bUZNcmlMK1RBZlZXcjNSbXgrVDEwRVpWSlJs?=
 =?utf-8?B?Q2U5elRSeVJEZUE0OVdxb3JReDF2ajRULzBIb3Q3ZE9tMDJPV2dGRjFMZ1Zj?=
 =?utf-8?B?d1VLL05xem00RzBCSitjYjA2NmlzRG5RSmJVS1BWcG05c3F4aW1QdDB5QlBk?=
 =?utf-8?B?ejRZVVJGc1dPSTUxSmRka2trRFR1WWY0WUc3NVh1dTdibGN3NUR1SkZiY2NK?=
 =?utf-8?Q?pFy5WaMBoV2mbVAyGf7tVgD8g4O/4NWgxNlN4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?NzE5UTFrSDh1djZUNEpVMllnc2hGLzZSbFdiVHdOcUphQzFUaDNFT0dnMFky?=
 =?utf-8?B?WnY1WUswd3RZVFJrbWdvRktodzVPb1hhcTcrRFZOeVQ3a1Q3b04xcXVXNVhQ?=
 =?utf-8?B?QklKZUlVZThWTzlzenpVdzA5VThFcjZTc2Vuend3UkpXV3hVeWdmdjdOTEQz?=
 =?utf-8?B?Y24xUGtkOUMrc3BraGVTZWh3ZlgxWFhtQU9Jd0dkWm9GYTA1cDhCcW80N3dl?=
 =?utf-8?B?MXA3SFRLRUNQOHp2ME5OdGtTaU4zYXJOVW5CUGozdUhlMjNOamg4dHh5eXNr?=
 =?utf-8?B?MUpyL0lmUmdPRnpxYjVvNVVPdnBiOVBBMmRvSEwyMm1ZT1dRRjMzMWQxQkll?=
 =?utf-8?B?b2xXSUIrRm8zM2ZnOWRDOHFZS3N3a2VxZlYyNlhqVER2dGhia1o4cGwyeE9a?=
 =?utf-8?B?SDVuNk12U2xQL2tadXp1MVo5RXlPUC9FTy9XdXBDaXFUZXVQYkpZNEJ4YmdE?=
 =?utf-8?B?VjFEclJkSkl0SVlHT0VZTHIrVkxhcFZFaW5uZmsxK2hJQ1I2WjcyRkZqVHYw?=
 =?utf-8?B?NWw3M3VZNjdQTUZ1TjFUS3Q3VUR6MDdsY2xPbUtXTEpDUlcrZGxscUQ5L3l3?=
 =?utf-8?B?M1RGL29EMXorczdQb0RpZEJMUUZOMlRVTHJWMzhIMUxpVUZOY09JYnhFVjhC?=
 =?utf-8?B?aytwdlpRVjQyV1ZFY1N4WjBJWFJtU3NUNlNNMEt4clZVUGhsZittV3p1cUlj?=
 =?utf-8?B?SVQ4MEhVL0piRE1vem9rbXRwMEV3WVV2RmduMStlZjlMeUlYRnZ2dHZubTYv?=
 =?utf-8?B?OVduUDhGY3JmdGF5blZYVGZaT0VaMmJXNSszN3Q3SVRMQTNUak5vSlJ2TEc4?=
 =?utf-8?B?cU1JS1k1aUVxS2x6TXBMSXRZQ3dXRFZkRDJUeTJLbTZMWThNajVqNGEvUWho?=
 =?utf-8?B?SkVUOERpZGszNVFsUUExYldqYVJKc21ycm5uSWdWRU9wVisyNEVMclJXM1Jr?=
 =?utf-8?B?NFgvVlNldlptNHkwVmtMSFJpbmlQbHR0b2NiVndUaThWc013SkZQUWlLZ2Ri?=
 =?utf-8?B?aVNZYTZibS9XOGk0dWlmTS9sL2ZWeVJGUjdEL3I3N0k2RmY0UHgvbnlrQW5o?=
 =?utf-8?B?aTNPUFRPdUgzSTZ5NlIrMkhTRDBQK2dIZUwzbjJsbm1rREl1d1BWZXkxdkpq?=
 =?utf-8?B?YVpmenZKNWVac214MzNsOGRSWkIvUHpvVS9OWkhlYzJ5cDZPdDBKcE1PWU9K?=
 =?utf-8?B?djczeFN2VEZ0c1VYYjIySEMzT3BsUmdjZEEvOWd1QjRuUWFncE1FcStvZ210?=
 =?utf-8?B?WlZrd0NsRlRnSG9ZWGNXb0JJc25XNjZrNlpYSGh1UXVUMCtKKy9PcWRlWEVk?=
 =?utf-8?B?N1dmdTRqM1BNWm1yQjQxUWExMlY2QzhNOFZKS0ZCalNOZWpKMFUzSU9nS01u?=
 =?utf-8?B?RjUzY1pyWno4MUllbzR6UWtzREx6YnRVb3BlZUoxUGhYOTQ5bTcyc2JaNnJH?=
 =?utf-8?B?L0xqK1dUaS94dHBPZnpKNWJpbHFsbUNSWG9xdHZ0aVh2YmhicEpsejBoMnUr?=
 =?utf-8?B?YVdFTlkzcXNvdWVhTm4wTytOMENaeFdYQmVLNDVnY08vWXFjb0tzYzd4d1Qr?=
 =?utf-8?B?emVPaXdoeG1QbnBqMjlGeDJlRWVwRHJtd09Va1IyRks0WHRTUWt5L3V2M0tO?=
 =?utf-8?B?SkVpYXhLcmlpazFmSzFWWDJ4bngxcFZpR09scDlHTW1UcG84UmJzLy9oYXdi?=
 =?utf-8?B?SGNneUMzRGtsWmhubnN4V0t4cTFPekhhdkdZS2pROHhTSS9xVXZmWHpTK2tp?=
 =?utf-8?B?SVUrVWFsQlZKcVRTMTNBTi9MN0toWDlQcTdUdXBXeE00RThlZEQ0MDlRcVNq?=
 =?utf-8?B?d3VoUTh4alVhQ1BLelBOT3JKaDF4TEgwN3BLc0dxN3hVVmZneExmbmdUQTVL?=
 =?utf-8?B?dmcweTZ1ckI5YjB1TzBlR1M0aFl2SERodXgyMDJRSHRTRzRYb2VUQmxCcnFi?=
 =?utf-8?B?REhXWjdYQ1RieUJXNVRrMVhiUStwdjQ1SUpiNVAxenBaK3VjZlBJbTBmOCs3?=
 =?utf-8?B?STE1clByZVhicU5vVm5yYm9FOGJzTlJMVmpwWGhCby8rbFc5OFFXRTUvNmYz?=
 =?utf-8?B?S1R2bCs4UjdpMVRETE5Ed2ZNNTRhcnd6UmVUMzN6MHZ3V2IveFkrdi9ibFZJ?=
 =?utf-8?Q?ePl00B215rDn0J6c3UElEGEak?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B06FA6EDF857C04EBD54E2FFCB87D840@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e4ddd2b-8885-4e6b-51aa-08dcfcc22ebc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 11:16:51.7645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: actOzqQawQTX4a/+lUsboJG6CUg4cgMBI4/gsmHD7t2Oe8Av0G5p41dcIO1k2zg+ejqFuIpOO7zso9r1NbcFtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7567

T24gTW9uLCAyMDI0LTExLTA0IGF0IDA2OjE4ICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFRodSwgT2N0IDMxLCAyMDI0IGF0IDA0OjM5OjI1UE0gKzAxMDAsIEFtaXQgU2hhaCB3
cm90ZToNCj4gPiArCWlmIChib290X2NwdV9oYXMoWDg2X0ZFQVRVUkVfRVJBUFMpICYmIG5wdF9l
bmFibGVkKQ0KPiANCj4gcy9ib290X2NwdV9oYXMvY3B1X2ZlYXR1cmVfZW5hYmxlZC9nDQoNCkFD
Sw0KDQo=

