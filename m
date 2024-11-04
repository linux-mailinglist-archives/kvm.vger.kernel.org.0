Return-Path: <kvm+bounces-30464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 574EF9BAEE1
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:59:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6157280E55
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E90711AF0AE;
	Mon,  4 Nov 2024 08:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MoQpjcIi"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2059.outbound.protection.outlook.com [40.107.223.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CBE1AB53A;
	Mon,  4 Nov 2024 08:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730710655; cv=fail; b=UhFXGHZdFp44UgM7XCVM71l4R3TnGJKY0BRidbxq9pzM3uOGIX9qmU39k5IZmF+mNIkpN7u9EO0Ogt6CokiXg8EKWSH6ElilfC9eZWTQrXyQgc5QHq8DtVhfaG9lDZiwpJd9gjBwNZrxeXydkp27YjhUbVw75iOr7k/CliLKcso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730710655; c=relaxed/simple;
	bh=10TOnf2xQYcgnWKMzFTmH/Pfi2l5tVjTG0ZJf+96HHE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pvkoj5nQdQ0/0bP4UbkVpUFGtW1tC/Or78FpqYZeG57JWy/uJHLww3/KVzlY1lYkXoXXSgYnOwyEgOS7CTm0nuSzYR/mTWSZQbwgo2RxHEGXtQczvJcH3AR63nvjnKqQYtZAQfRxBr8PGUNvD56eFKFXi9qOfg/68xNl0QiV70I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MoQpjcIi; arc=fail smtp.client-ip=40.107.223.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEbbwWC61gntPtokfVKhMoGrVqnAQP3TRqGDQIImNr/rQ+/KWdaB47xwQ2fNioqi9cuQyUedmxbT1BSjqK5AmOYnVwBpnQ+nTZKHX9h2J2sIQXqYPFEFhMUPwGz+0Vze+8hnl87nSQkX+wusAPOe1BtIpsyDfBa1Ov55jZYWyH1vpoPznuGXVHKsqhU+PeXHG7v2CQPuYv1ZcUvRO0XfIY1kRJiuyDvo74dq/ljtRMhG6B1LymsabGdyELPRjG00ApxzXafze/cG/W7e0yrCQlvmdlQ6rf0vqtLbrSewZIXLap24XNRPyVXaitr8OZN2PAMszIPLBTar/eOHmfyZXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=10TOnf2xQYcgnWKMzFTmH/Pfi2l5tVjTG0ZJf+96HHE=;
 b=diLD7NslMpDbZzzawmUkSm2IaTMp9iJQJNi6o6zGFtgwpZY8mvvlH142GvgZDhOwLXs0HXepDpcdeXyoOXQDt9QpZEzXFKLv8FZgfqGVUBQ1liDbY9LiI3mdM0MlfCjeNRfLddf+8nUpWshmQzetBrgrTybfSO1+JPAwoH17Uy6LLVIOCxnIMPH4uPG8Q28ROHA3ax/jq6+BFqgMRl7vjyS+1K1tYXvPRrdj1ONxKWpJDcNSiws2X+md9UpVUiynaeiJPNT/NLKwuAO0u4aqhK9uC2XpGye8ghMbHEoI0T4eHzyTsJRsntRgZzyYk7UmnpehTApB4BnYqmW+Iq7vSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=10TOnf2xQYcgnWKMzFTmH/Pfi2l5tVjTG0ZJf+96HHE=;
 b=MoQpjcIiCpOQh/Uj90xgvl21nRWqhMw9uVTJMVGsarMSRqwMRA8fICNKtdrSrI0aMuVZ7w3rQia6sVrnK9mRuXKKYqa/2NG8Y3gGj73bRqLe1ctuHHwxuqvJ9uGiHj41DA98HG8L6q71A5x1Z/jZ5RpToBno/0Mwe3aHSrHlMz4=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by MN0PR12MB6032.namprd12.prod.outlook.com (2603:10b6:208:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 08:57:30 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8114.023; Mon, 4 Nov 2024
 08:57:29 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "kai.huang@intel.com" <kai.huang@intel.com>,
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Moger, Babu"
	<Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>, "Kaplan, David" <David.Kaplan@amd.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Topic: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Index: AQHbK6w5P1k2kYbMrUGkcWui1gHZ+rKhevwAgAVc0QA=
Date: Mon, 4 Nov 2024 08:57:29 +0000
Message-ID: <c3fbf18a4ec015039388617ed899db98272cf181.camel@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
	 <20241031153925.36216-2-amit@kernel.org>
	 <20241031225900.k3epw7xej757kz4d@desk>
In-Reply-To: <20241031225900.k3epw7xej757kz4d@desk>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|MN0PR12MB6032:EE_
x-ms-office365-filtering-correlation-id: 4f3e07d3-b0b3-41d5-d1cb-08dcfcaeb66d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?N3gvd0M1T2pycWRjbGdseW1RMDRKVkd1KzdJSlZrZC91S04vaXBVdm4wOWc3?=
 =?utf-8?B?V0VHWjNIUFNBdTdSQmZ3MTB0UFB0NTVJN3llNXNINlBWTmxxdElYVW9NVmFi?=
 =?utf-8?B?a1UydllRNldmMnNCaHcxYXJrT0NmWFI3TU5WRUpOVFcwTGtybmxZS2ZsbVFv?=
 =?utf-8?B?WTJaWEM2blNxYnY2UzZpb1RteFRsN1ZWUkNPWjdHN2FmVDRWMUs3ckFlNWtm?=
 =?utf-8?B?WTdIQjg1NnpaV2RlY0FCaCthYjFkOVdTNTl4UXBxUVcxR2hzSUdlaHFpd0hj?=
 =?utf-8?B?UUh3M3dTbFJHZnU5a2lWMS9lWm9GeG9OMkJGNHFrSkc0MjY1OE1OY1k5eVl2?=
 =?utf-8?B?NkNLWmkrb2lPZkRSd3RnSlV3YUJwUmgvb0tvM1VFR212RnlQcjNMdk8za2Fz?=
 =?utf-8?B?Sy84TmR2Z3NYdkpxMFNuN3ZOaklsTEV1SWRMUVhiWjRZOTQ5OCtGMGpkU1N6?=
 =?utf-8?B?VGFkT0h0MzkrVlArUkRWRzFlYk5QTmlIUTh5ZWRvUXR3Wi81RGVvbTJHeXl4?=
 =?utf-8?B?c24zcDR0a1BkTkh1RXltb0F3VHNyWFFzTWlwQnl5bHRvUklkNHRlSUZvQU5i?=
 =?utf-8?B?aFJIWmFQcjRJN0VnZVdrbHdYWnQwd1hNR1NWeWtVczJKQ2J6eWphRUtjZzlU?=
 =?utf-8?B?NERJdU1uQWNjZE5Sc21GSTd6VmcyU0NsUGZLQW54Y2tVNlVxMTQ5dFZMRkRv?=
 =?utf-8?B?ZGZ5dDgyaUhlUzZKM1UwOThobmlad0FlWjIyQkE5M1ZjMkJ6U1hrYW1ISFlC?=
 =?utf-8?B?ZHY5bWFvOE5ENEEycTZ5WFFYNDhueHVlYWkvUmZCK3BPZmJZTEhORXZMMHkz?=
 =?utf-8?B?QStEUTlaSGpWb2N0QUpXazNnUkJWbWo2K2ZPQXFXejBVY3VKV0wybU1PN05z?=
 =?utf-8?B?dnpIdmYrenB5OVM2MmlWenBoRjZaRlBzSnZvMWlsZ3JBQldSQlhXWHorU0NF?=
 =?utf-8?B?ZWlPZUdhVVM0eVAzeUhsWTgvK2JuWWw4U1FvRlhVMTlUb3l0Qy96UHh0Snov?=
 =?utf-8?B?NTRGOUVrUW9oY0g5MnJvRSs4bGJ5WElBZlAzU2Jjejc2RTQwRENaVktwT3pZ?=
 =?utf-8?B?NzJaeENGbmx3Yk9mS3ErV0hUR0xZcGhzcWc5YVZrUlF0QmlmdXNZWXlkREh4?=
 =?utf-8?B?R3JObnB2akpyL0ZnTjI4ci9sN2xsRVV0K2I2UEd2djJhazkzRUFWalpHOXZr?=
 =?utf-8?B?Zzl2eVN1c0FRbldvMFpGeGdmWWxNa2Z0Qnl1RnRUSWZCMEU3eEVCbXpnOWtN?=
 =?utf-8?B?aE15TjhSbFl1YTd2amFvb21oUXhBV1NUcG12aEE0OWhHUDhzNVRwUG04cGE4?=
 =?utf-8?B?WG85UDBSVHJCWlhnSUJyQkRPZFNmVVdNQk1nSWtRV281dis4WlBHVkZwSDB1?=
 =?utf-8?B?ZTk2WGFYNEVUZDhhZUI1NzFEUHlGT0czdjNWQVhYWFNRTUFRdHYvOTQ0S2s3?=
 =?utf-8?B?VExHanlzWkY4VnRlSS9ZOC9qTTNJdTdHMGp6YUFLdW1leFlkNnFpWU9DOWNO?=
 =?utf-8?B?clBOci85N0I2TXFlay9Fa3IyaUZ6VUt4Zm1vUkR5RlRtOGF3STE4UElYUDlY?=
 =?utf-8?B?SWZ3OWk0SlBoSmJtYTV4V2dDUC9YYklTVWRVM3ZRY0NGdG50cjQzSjJkbjZv?=
 =?utf-8?B?VlEyNFZKOVdxQzZGViszaUZlVHREYVJkeDZkOVgzc2xzREhpQXNFMGNqVVVJ?=
 =?utf-8?B?OFF1Y3lIRzBTckl6cDl4UFpONkRya2FnY00wWlA0R0JiaFJmdzVQejNxZzJl?=
 =?utf-8?Q?OpTXRAOFJTkhN7/YjZ2fo4OhbggJAbIhDqdSMNL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?S2RZb3FyUklQK0YxNmMwcm5TQ1lqU0xwYWNRRnlzVXB2Wm9pTC9EeHJUS0M0?=
 =?utf-8?B?MjI0V3JyM0FmVXc5SldmT21hZ3h6UmNabTQ0MnFRRCtlWjdOQkhMM1NQcVYr?=
 =?utf-8?B?bVFpRFZsZW1xeUF1dEE3NVlkek9WdTNWS0tOOTBKQ2phRTFyTE0zWUsxV1VH?=
 =?utf-8?B?RC9rMXBXMzNKUzRDMk45NHZJZ3RHNVNaWTdudGhDbUttVkJ2cElsM3dFVTUz?=
 =?utf-8?B?QktIUllMUzFxblVNUW42NEw3SmFiUk1mQVpBSmRCVDdIVW83S1g0QUErRHhs?=
 =?utf-8?B?WVBTTEhuU0k1d2Z4SHArbVFvVXpYRTV4WGhLOWU4THdkU0wzSFA0TjBLaGk4?=
 =?utf-8?B?aTNsYWhVZzlaSXRmK3lFaGFLd3BzSldHOXJkZHpESGErckd2STJ4QnlVbEY4?=
 =?utf-8?B?cGRRRTZDZXRsNkpwekFpTzZXRkl1dzdZLzRwV0xMdjQ3aldCMzBuK25FeGgv?=
 =?utf-8?B?Z0NCTE0vY3VYcWRhVzJqMGdHakdJTTlvMzhHSDZKd0R5Z1I2RDBwQlp1OWk0?=
 =?utf-8?B?c1c1MGJkRDhSQWtiYlVwdFdpT05qWmlGSkU5WEZsc1VsVktNQXFFaVJpUU41?=
 =?utf-8?B?cWorNlVYNVcraDQxWVg3TE4yTmM1eVBYODk3alZvQW1DNUNxVHRjRzVhaUph?=
 =?utf-8?B?dlYzaC9OMnlOUkNsR3FzZnFZQXhJL0NlVlJtaVZJV2toZ2tPQU9Qb01JT1ky?=
 =?utf-8?B?c1hRbTN5U2dVT2xSSStXRUxacCtRQjZvUTNJZkFUaTh1SWNIZnRIN2tZNUZ3?=
 =?utf-8?B?NHE3a1JBbVgwOCs4TUo5SlV6MnhqNkhHRkVqaDU1MSttVDZmenprQXZ5RSs1?=
 =?utf-8?B?M0pOMS9UaDdkcVNoSkhEUlFjSWhsTkpndmhUcThXUXo5cHViVG1XKzdaVkV4?=
 =?utf-8?B?b0M4Qk85bjFRYm9MQVNXZytSYzdmbEEwSXhOOU40Mk1WMERJNHQ0d04wTlJ2?=
 =?utf-8?B?OUN2U0ZycWhxblBIeTZETzlPL0x0V2tUa2ZRQitBdUlZRW9wRkVmaE5HOU1R?=
 =?utf-8?B?c1l2SGg3c1JOeHFWUTY1bjM5VUZuZnNPNUdydnNTdEZXQWM3UjdGcDk3dmlY?=
 =?utf-8?B?QzR6N1ZoV29jWFpoSXo4Z0FLU2UzUzVaSXZPenBKTWdYOTZKN0dTenczVW9k?=
 =?utf-8?B?OTJza1ZLSzUwa01kV2lxVTRQU3FoU0kwK1lTVk5MRTFDV3FPQ0srNDNaZXA2?=
 =?utf-8?B?czZQRzJxTXNjVVZNVjM1eG5FMXhTSFpjN0sycEkxWWpMbFdNb2ZqV2tIR2sv?=
 =?utf-8?B?UzN4Y0JYd1JPZlZGeVhBbUoyVDNacDZ2QkltcEZQUEk4TWZuUHZmeTRCQzJQ?=
 =?utf-8?B?SGpvN3MrcUpwVG1mc3JpMVF5czNpZVZqQ3Vid2NDMCtvR24xVWw3a2o4QjBt?=
 =?utf-8?B?L1paNkZzREc3a29ucWZoemoxZU8zV0l5dXgwTHRDN2VuTlRiL1IwdlRXazRZ?=
 =?utf-8?B?NWd2R2wzRkZ0RlhMZVBXZXFJV1JJSldkSkJZRlQzZm81azlPVmliN1MyMUJY?=
 =?utf-8?B?NVZ4TlBxL1NnYnMvMnlqU0t5VWVuWHQzcWpWWVNydnF6L01PZG5iaGFrdDgz?=
 =?utf-8?B?amRqRUZ2dmU5aG1PWnNkUnJZc0NsNXRVallFdjJJM1NGdXpFaDRCMy8yb0xk?=
 =?utf-8?B?UFFLQ2RDdFRGV2I4RXNYVi9EMEJLQjlKVmFqUzBjaW1IYUZMWGIzV3ZST3dH?=
 =?utf-8?B?aHI2YXI1L2pYY1JKamN6TEtTRDMrbU1xSG51eEFOdGtzZmRRZEp0MjJqOUI1?=
 =?utf-8?B?T3k3c2ltcGEwNHVhVTNGQTBYRExqRkNiOXpaYUl5WE5aWlp0aHRJTWZ4Y29U?=
 =?utf-8?B?eWtndHZvdVNpdVVoampabmdmWTB5a2ZUQXdTVEgzVTZ0czU2ZzllMW1QbWFw?=
 =?utf-8?B?M2dnQ3R6SGJxbGRSUzJMV1d2N1pyem02bXlVWW0zN2lkS2FuNHBoQTJ1dGJH?=
 =?utf-8?B?QXhmRW1JQTRiNE12NmhyOExEM2dDenJTdklqMXhNeU9tNVJ2Z0lNcFB3MDN0?=
 =?utf-8?B?SWdSQUdlQ1U2bU5hR0hwWVY4WE03cjhBR1hTcHE1STZ0aUI5d1hrR3FWWnF0?=
 =?utf-8?B?cTh0citRc011enhvUHdEbXVqVGNjck5QVU5CcEZaa0s2NERrSUMrOFNabFN3?=
 =?utf-8?Q?QT8an3DkczLiODiPXlDF/43d6?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9BA4FC11BC949E42BA28C81327E1A8F4@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f3e07d3-b0b3-41d5-d1cb-08dcfcaeb66d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 08:57:29.4697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yr2Y9QdkbAR6FrfTDHxoc+UNikK0VaWSDgsgPMBaGEmBwONLujEcV9ZRpv3TEvKgpY1DmBnpj9hJZMdN4K9dUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6032

T24gVGh1LCAyMDI0LTEwLTMxIGF0IDE2OjAzIC0wNzAwLCBQYXdhbiBHdXB0YSB3cm90ZToNCj4g
T24gVGh1LCBPY3QgMzEsIDIwMjQgYXQgMDQ6Mzk6MjRQTSArMDEwMCwgQW1pdCBTaGFoIHdyb3Rl
Og0KPiA+IEZyb206IEFtaXQgU2hhaCA8YW1pdC5zaGFoQGFtZC5jb20+DQo+ID4gDQo+ID4gUmVt
b3ZlIGV4cGxpY2l0IFJFVCBzdHVmZmluZyAvIGZpbGxpbmcgb24gVk1FWElUcyBhbmQgY29udGV4
dA0KPiA+IHN3aXRjaGVzIG9uIEFNRCBDUFVzIHdpdGggdGhlIEVSQVBTIGZlYXR1cmUgKFR1cmlu
KykuDQo+ID4gDQo+ID4gV2l0aCB0aGUgRW5oYW5jZWQgUmV0dXJuIEFkZHJlc3MgUHJlZGljdGlv
biBTZWN1cml0eSBmZWF0dXJlLMKgIGFueQ0KPiA+IGhhcmR3YXJlIFRMQiBmbHVzaCByZXN1bHRz
IGluIGZsdXNoaW5nIG9mIHRoZSBSU0IgKGFrYSBSQVAgaW4gQU1EDQo+ID4gc3BlYykuDQo+ID4g
VGhpcyBndWFyYW50ZWVzIGFuIFJTQiBmbHVzaCBhY3Jvc3MgY29udGV4dCBzd2l0Y2hlcy4NCj4g
DQo+IElzIGl0IHRoYXQgdGhlIG1vdiB0byBDUjMgdHJpZ2dlcnMgdGhlIFJTQiBmbHVzaD8NCg0K
VGhlIElOVlBDSUQgaW5zdHJ1Y3Rpb24sIHRoYXQgY2F1c2VzIHRoZSBUTEIgZmx1c2gsIGlzIHRo
ZSB0cmlnZ2VyDQpoZXJlLg0KDQo+ID4gRmVhdHVyZSBkb2N1bWVudGVkIGluIEFNRCBQUFIgNTcy
MzguDQo+IA0KPiBJIGNvdWxkbid0IGZpbmQgRVJBUFMgZmVhdHVyZSBkZXNjcmlwdGlvbiBoZXJl
LCBJIGNvdWxkIG9ubHkgbWFuYWdlDQo+IHRvIGZpbmQNCj4gdGhlIGJpdCBwb3NpdGlvbjoNCj4g
DQo+IDI0wqAJRVJBUFMuIFJlYWQtb25seS4gUmVzZXQ6IDEuIEluZGljYXRlcyBzdXBwb3J0IGZv
ciBlbmhhbmNlZA0KPiByZXR1cm4NCj4gCWFkZHJlc3MgcHJlZGljdG9yIHNlY3VyaXR5Lg0KPiAN
Cj4gQ291bGQgeW91IHBsZWFzZSBwb2ludCBtZSB0byB0aGUgZG9jdW1lbnQvc2VjdGlvbiB3aGVy
ZSB0aGlzIGlzDQo+IGRlc2NyaWJlZD8NCg0KVW5mb3J0dW5hdGVseSwgdGhhdCdzIGFsbCB3ZSBo
YXZlIHJpZ2h0IG5vdyBpbiB0aGUgb2ZmaWNpYWwNCmRvY3VtZW50YXRpb24uDQoNCkkndmUgcHV0
IHVwIHNvbWUgbm90ZXMgaW4NCmh0dHBzOi8vYW1pdHNoYWgubmV0LzIwMjQvMTEvZXJhcHMtcmVk
dWNlcy1zb2Z0d2FyZS10YXgtZm9yLWhhcmR3YXJlLWJ1Z3MvDQoNClRoYW5rcywNCgkJQW1pdA0K

