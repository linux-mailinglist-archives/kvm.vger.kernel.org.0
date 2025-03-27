Return-Path: <kvm+bounces-42112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C25BA72E8F
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 12:10:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 633301713EE
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 11:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B385210F6A;
	Thu, 27 Mar 2025 11:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="f8Yq59fo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2060.outbound.protection.outlook.com [40.107.95.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B41E20E6FD;
	Thu, 27 Mar 2025 11:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743073826; cv=fail; b=pHLk3k3i8D6VN35fasQBUROKZNnCHFkYmsnQ3e8UpTvD9omNKYNZcCwEgrqb/nD512NR2y9m0Y02ht1oa4m9ySVM5bD/WSnWTcVDp+b1ibrLGh0h8AE1Nduhi7Rw/JnD2nCtituIsau0gyddc7CHcEnqMN4tDZSAL3S6NF41omI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743073826; c=relaxed/simple;
	bh=YjqNghN78n12Fi+bmYzsB8Y/WbnlsyshWUtDvxqTyJg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fsIlcqYl0nPsewhl3HE/eu68wN0EMEDelRNXEcIscLxqh0kdeovYfpRne7xagVb+Fpmeh/1LeCKoYbqvIJi0h7CayJajkAP2AoNvffcyGo+S3lZPbedpgj6kub9bocerQI3FmlNhXkxk4TqPvTHzBE4gMonC201iuzqkr6lt+k8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=f8Yq59fo; arc=fail smtp.client-ip=40.107.95.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wsAFdHw4ejr4Bt/m3EWZCeFVXBuAj+hm6raKRSJ6EmCvp4jzonvZAohleaCOrkkb9f/Abfw1c6dLdlg6/+Q1RJDPDMcKplw91fAKjFVEOdloY9e/Km6Vte7+bwZ8hDLbrE20u8LCh7W7R8hvqfDC4FfM0riTK19YjG2EhZueOfauefnZ4Dvfl4QfawRTQlMpIOx3nIwL6s8h8x827GLP9fAPSiaKU9KHiDRX4F9BQgkxvaNczaI28jU45t6ylfsjevfNpsysiqTYEe/jsshaboFnF5Ig8RpTsmRBiyqY1nbKJkndfKh6a9K1C8IcpeDWUecXQt2EQrCMl0cGCYRYTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjqNghN78n12Fi+bmYzsB8Y/WbnlsyshWUtDvxqTyJg=;
 b=kjlW93R18Na2AE9svTfRm0FkLdtFlnKBlEUQlAMwYNhEAXdbEEjEHb4Xt7omnzjFsmLNHqP5nlQ/ghQrwUq9L5ki6b4bvE/Cg3XZXH2jg42uu5X6MOGHiOTLYNt6q8fl8xt7VOch8C5at8b7FyKjFKy0m4XS1eJjgxbIpP3856h3NJYojzQxqtYnRrgGEobpcEpZF6xFEuhbUMOKc27jYDJ9bH5JkIcWmzf81j8MdLJGa/wYNyvbl028UJyTb/YvR7cc8dRiGsTx107GOdeqYuNM9mIDDxZd07yOI3YruqJL6jkLob+X2vmAioqz8NzVrYQDs60YAutl5KjMDdlBog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjqNghN78n12Fi+bmYzsB8Y/WbnlsyshWUtDvxqTyJg=;
 b=f8Yq59fo0WbPI8OV8UgnnlcyFFPUISeVDu0tLKJWp9yMmiIxwTxAUuFx95m4Hi4T/1JX4K/0+J9/b44rE4g/6dmvyvInVonKx6jNk4lL6RMiDxARVzXkZ94p1/uyC0krGZ+wznuE1iCpYLgP4YY/dkzDwZ6DmaG4IN7603sqaOc=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by IA0PR12MB8908.namprd12.prod.outlook.com (2603:10b6:208:48a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 11:10:22 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8534.040; Thu, 27 Mar 2025
 11:10:21 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"bp@alien8.de" <bp@alien8.de>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "Kaplan, David" <David.Kaplan@amd.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v3 2/2] x86: kvm: svm: advertise ERAPS (larger RSB)
 support to guests
Thread-Topic: [RFC PATCH v3 2/2] x86: kvm: svm: advertise ERAPS (larger RSB)
 support to guests
Thread-Index: AQHbQZmCE20B2uR75E2iktH3myqEArLTTU0AgLRBJwA=
Date: Thu, 27 Mar 2025 11:10:21 +0000
Message-ID: <acfb986a9c6912fda33c51bb563ff5ee484ed1b3.camel@amd.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
																																																															 <20241128132834.15126-1-amit@kernel.org>
																																																															 <20241128132834.15126-3-amit@kernel.org>
																																																									 <Z038wBhWfVAFNhJJ@google.com>
In-Reply-To: <Z038wBhWfVAFNhJJ@google.com>
Accept-Language: de-DE, en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|IA0PR12MB8908:EE_
x-ms-office365-filtering-correlation-id: 6fd28c8e-c4b6-4db7-8e43-08dd6d1ff756
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WGlZSWhTVndXb3VtR1dOb01HM25jTllCRWhyVE4yaU5BUVJlVEZnaUNZRUZK?=
 =?utf-8?B?V01DRTVONWczT3J4bzQrQW9mU2RiVXNPZVA0OERUbEEvdjdsa0cyODJrdld2?=
 =?utf-8?B?U3hOZTJvQVE1bXc4R2VmdXJFM2h6bk5EK2tZYVF4Vy9WQWdJRCtpQlRYQ21m?=
 =?utf-8?B?ME1oZXFvb1ZzT2ZMVHdTemhKZmFFOGltNDdaUVJSY0VYQ2NHN0JDM2pZTE5v?=
 =?utf-8?B?TnhkU3BRd09WSXB0dEtudXJBcm1XZTRUSklvQjY1ZGxMeGgzckhhZUtFeEp4?=
 =?utf-8?B?S0F4VDd4cGJWNitDdTNUazMyZXVWTGszZ2xKeEtaVm5nWjA1N0VRZ3VzYTk5?=
 =?utf-8?B?SWphNSt0WlFvZlpRL1EvVHFReENNMkc4YUdsaW85WTZSSHp5K01jZ3kzNHVL?=
 =?utf-8?B?M2x6dTVEUWhNbFV0TktxMUo4eUQ2TG5BMlRTcFFBK1VLQmlOUEkzZjJnc2gw?=
 =?utf-8?B?VkNKSFBJeXhIc01xekQwMFRoTlNqV3VxbDJZV2hrc294dFMwbzdzenlzODQy?=
 =?utf-8?B?amo3R1Iva2FQdHdoK1J0cjFrWU5FUWMxTzJ1VndFbGErNjRjZitWUXpOWm9i?=
 =?utf-8?B?Y21hZ0tBOElBRnpyVHM4Y2Y3R080VEJJYlNwODFNZ2J2eW0zTjlRdlRSWmR6?=
 =?utf-8?B?a2pKQXR4UmVxWmsrODJDTVRsTTEyY0t0RFdnZmM2QTBWZFhHV0Z2dzJHcUk0?=
 =?utf-8?B?NUY1L2QvZENOdFZlWkk5MVBncTFsNnV3SWgwQUUvVEUyc090MHcvRlZqN0VU?=
 =?utf-8?B?cVVUQ0NqMkVheWRmbkxXU3c0Y3paTThVK0wxTFBpd1F6KzZXdllpUkVnUUNr?=
 =?utf-8?B?b3pVNE5WWWEyanM2cVIzOURmUlZ4ZXZmNk43RU1ReDZJWXVPSmZLS0Q0dkJt?=
 =?utf-8?B?TGo0UjliWGpYRHJSQVcxMDI0ZDRpb0dUSWZubEJKeHB1eStKK0ZMVE1YTkNa?=
 =?utf-8?B?bjNPUUFNWThrTlRuZ0Vpem5wcFNBcEhwMk1hZVFqa0VhZDRwQlo5NHZEV3I1?=
 =?utf-8?B?ZWNYQ1RSTVlFQVVUUXVPVUhWbWx4RXNGNWJGLzRtTWtYaFMwYXNDMjBiRnF0?=
 =?utf-8?B?NkpJWTlrV1kxekNYSjl5UXhrRWwwc25iV01PVURJZ0JUVW1ocVRuY2k2WWts?=
 =?utf-8?B?a0hKV2oyUC9aaWIwNlo0SVpJbG40QWpESStXWHh4MUpwQkkxVHNJTk82Z0xh?=
 =?utf-8?B?VXh2Y0ZVb2tja1VOMmVjL2VBWHNVUmxyTmQwN25udm9TTDJmSTFaeThIUGdv?=
 =?utf-8?B?TWl2dnVOQW96WXNabm5TY09iUzJrUEx1YVExZG5FdW5TSDZyeEdDeG5qbmNi?=
 =?utf-8?B?bm5tVE0yQmhST3V6WVc1VTVsZmN2MGZMNHk1bGdDeWU0cnUvNUVDYUpuTzUw?=
 =?utf-8?B?U1JQeno4OEJOZEE0MUFwbkhFdEVYTC9Ra0w3UzBJcFA1OHl6dkY0WGpIVmVj?=
 =?utf-8?B?VTJSRDk4eTI3YmpjN0JPbnEyaytaalE3OEJGL0JMeTlQdXp1Q1RJR2VsSnJm?=
 =?utf-8?B?Y1UyYjBqT21CcENFa2pZOFJ4MHVFVnZZQWxNUjRsODNVQ1JOOEl5RkFJUnZr?=
 =?utf-8?B?dnYvVmEybDc3VFhDMkZSSlVSdTBVOWxsVWNqWmpiU3dld2dnejhnNkN5NjdG?=
 =?utf-8?B?alI4T1V4aDVTOWIwTkZkbitQSXpnQkIwU1hSTFNZUkNDRTk3QllTc3F6R3hG?=
 =?utf-8?B?NmJoOXFScnRYcmNZdy9GeXU4VkJPYW9wL093Q1hDbHpwR2xWQlR1bXd4YXpS?=
 =?utf-8?B?NnEyaDVOemQ2aVNZTmE0ellzc1ZjR2hMa2xMMEU0SVVJaS9USVZ2b2lDWGNQ?=
 =?utf-8?B?K0NRaU0xN1QyVlI1Z1lJbVZEOHN2dG91bE1UWjkwcEFoMXY3UG5vVFR4MDUx?=
 =?utf-8?B?elpzNmZmWWt4L3l6QjY2dy9DZ1FwTnhDSDlYNVpRNFlyZ0FjSGljZnYzSGR2?=
 =?utf-8?B?RFpuUHhJaWFIUXdnNHZmL0pXaVd4L1lQME94aC9jYlY1Y2cvaTJTTnQ1RlJm?=
 =?utf-8?B?U1hFQUd2bzFnPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K3V4YmdNUmNoa0tseUlBbG85QjJSa0RnNE9rQnYrbm4wdmRBc3RJMUJEUUhZ?=
 =?utf-8?B?aDBzMEpkbW45Z25JMm95bWpsc0hZbytDNTNqd0p4U1JJWmpUZS9pRUlKU3Aw?=
 =?utf-8?B?YUhoVDZqQ2hkSURsbVI0SjBnRE1CaTRLdE5OSWFpdGNxZ0tld3M4TXRuV3BQ?=
 =?utf-8?B?bHRlMnFUWmliL25pSURBMHJBbXYxWmx4aDU1TkxZU0R2V25RRnBIaXlsaWQ3?=
 =?utf-8?B?RlppaVlreXFSMWo4eEdIQWliWUlVN0VxRy9OalNaZlgrZXBRdzkrdFVXdGcv?=
 =?utf-8?B?ZDZNM3VJaU9TYkVyVjFTQXI4cEVBRDNJOWpFZGFMMEF4b09FcjdJaHZqTjJx?=
 =?utf-8?B?eWJ3MTBmbGpEM0w3L0wzNEt4LzZ3Nk13QWt1NEtOdkVUeExOMHFGLzd3dFNN?=
 =?utf-8?B?K3VJbldOc21aRE02RkdyWENnY0tQMXc1cjA2TjlSSDY2bUlqZjhMRHE1enk2?=
 =?utf-8?B?TGh4UmprUXpHS3UvZEd4QXFiQldVdFhxK0tXczVxL0huSmpjWWoxak5ISlRE?=
 =?utf-8?B?TmVBRXRmS05nVFNGbFo2b0c5K2FkbWYvdFdMeXJ4N0VyazNDemUrVTlIb3cr?=
 =?utf-8?B?elBxcVRmOElYcXJYSlQySHY4RjVCUlA5cnZiT3VBSFhLT1BnTkozYkVlNndj?=
 =?utf-8?B?VERTR0FkMGg0VXJQQ3hJU1d0NkF5c0FrNmNvK1FjOU1yd1lYTGNCbm40a1Fj?=
 =?utf-8?B?OUxDVWI2R25sRW9NR21BS2dRSUxZa0hSamVzcUtkd2IyaVdHOE1Rblc2VFBY?=
 =?utf-8?B?eldxNzdXTjgvMmk4M1NiNjdld2FmWmFDa1IxTWhNYlM0c0EyUDVrcVhGYkxq?=
 =?utf-8?B?NGJtNVIvZmhwRS9lYnJLMGo2eWRtMEFDZm1zSDFMKzgyZ3VFVXJEWktPRnBL?=
 =?utf-8?B?bitDYS9ac294eWFUbHhYajNFWjUrdndmWDZXc0wwS1diMjBaWjUxdmZtd0xR?=
 =?utf-8?B?Y3RCZXJ0RHBKNGhqbkE1Z3ByZkJNdnRSSGt0R2ZmVXllYUZPTUwxSWM4dG4z?=
 =?utf-8?B?WUw5RDg0SGU1c1MyNVJmQVNZU2xGS3dVRFQwTE9pemZPbnRDRnUxV3JqR2F4?=
 =?utf-8?B?cG5iNlBNMjVKa2tROERmR1dCVXJrRmg3cUVaMm9GSThsS1lkRGljZ1FQRnVw?=
 =?utf-8?B?dHdCV2VrUEJWYllINFdYbWw5enhtVkRmVzg0VFhjMlVuMmRvckV5NFc3YURk?=
 =?utf-8?B?OFpBK3dURTg0V1NLQ0ZnSGhuUHdML0doVms3aG9JeWlzeWhCUkdJSThwNEJK?=
 =?utf-8?B?M2VNbEpvLzVaZUpVcVJQalpNUTV4ckNDbldBUjJ3dTBPUExMMDFHeVN5UWtu?=
 =?utf-8?B?T2FTUHkrWGxpN2UrSzhXVzMyaTFZUDU0WXF0WkZNSlNmT0dVRC9WY3pxOElk?=
 =?utf-8?B?ejNDRlg5Y2MxS1VEaUZDclFzNnA0UzhnMEZ4b0VlbCtOcFFUTFhQOVN5WDg0?=
 =?utf-8?B?SDhLR1duc2kyWXdsWlQxWUdCWWVlMzhsUWxKM0pLbmRncExWckp4WjljZ3Ar?=
 =?utf-8?B?QUxNVkdXYURPNE9wNXN1ZktTTmxIU0JkdFZ1WHhySWJjOE9BS1hYVmVLVG5Y?=
 =?utf-8?B?K043eFh1SDIveE9RUHk1MTFIb0ErdHlFM0VVWWUwYzJUZ0xKOWVQbDNQUTFx?=
 =?utf-8?B?eVBrdlJhMWxxbWRyOWV5ZWVadFFUMHdPQkZIMmdHUWJpd1JseWpWb3drZUts?=
 =?utf-8?B?Wm1KTXNvZFlVN3JiQ1dkZVFYWlNOYkpjekY3WHV3Ty81eUhWTVd6cFMvOExB?=
 =?utf-8?B?WDF1Q2EvM3FBWWpiVTB4K1orYzM3M2o0SmdiakZsSVc5c05EbFFHT1RYK1B3?=
 =?utf-8?B?aTAybHk1a2tIRGx5UlN5ZXI5N0lCd0lUaWdFK1lCSjRFdERwKy9INDNvTjVp?=
 =?utf-8?B?dTJmZXJXb0p0dU5lR0FhWnFzQjBlNzlxeitSNHRHVnV3MGtaaE1nb1J4dE9D?=
 =?utf-8?B?Q3hVcWJZMWY1aGdYcmFQaWJmS1RDMWVvNDRhUmhseUF1RzVwZEF6QVUrUkFH?=
 =?utf-8?B?QWJrSUVDZFAvcUtSaURxanBSY1RVaGIvRW1tNHhXQ3JWc0dUOHlyNE1yaENw?=
 =?utf-8?B?ZjBJNktyVC9ldGU1WXVVamRBQ1Ixb2FLc1d6MnQ4K3g4L2daeFVkbGVpejlO?=
 =?utf-8?Q?5wlpF9yOhW2B3AS0io77+LRNc?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D89FEDC478A16941AA3D10BFE3736DD0@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd28c8e-c4b6-4db7-8e43-08dd6d1ff756
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2025 11:10:21.6994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g+so62ECqWXmwuweXwz7XJLRHp1hUz0mmaSEJJtTD0pWN2HHxSiiWj5e9f6R8678ubSQQnRabUdBE/YHL+Lrog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8908

VGhhbmtzIGZvciB0aGUgcmV2aWV3LCBTZWFuLiAgQXBvbG9naWVzIGZvciBub3QgcmVwbHlpbmcg
c29vbmVyLiAgSQ0KaG9wZSB5b3Ugc3RpbGwgaGF2ZSBzb21lIGNvbnRleHQgaW4gbWluZC4gIEkg
aGF2ZSBhIHF1ZXN0aW9uIGZvciB5b3UNCmJlbG93LCBidXQgb3RoZXIgdGhhbiB0aGF0LCBJJ2xs
IHNlbmQgb3V0IGEgbmV3IHJldiBuZXh0IHdlZWsuDQoNCk9uIE1vbiwgMjAyNC0xMi0wMiBhdCAx
MDozMCAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4gS1ZNOiBTVk06DQo+IA0K
PiBQbGVhc2UgdGhyb3VnaCB0aGUgcmVsZXZhbnQgbWFpbnRhaW5lciBoYW5kYm9va3MsIHRoZXJl
IGFyZSB3YXJ0cyBhbGwNCj4gb3Zlci4NCj4gDQo+IMKgIERvY3VtZW50YXRpb24vcHJvY2Vzcy9t
YWludGFpbmVyLWt2bS14ODYucnN0DQo+IMKgIERvY3VtZW50YXRpb24vcHJvY2Vzcy9tYWludGFp
bmVyLXRpcC5yc3QNCj4gDQo+IEFuZCB0aGUgc2hvcnRsb2cgaXMgd3JvbmcuwqAgVGhlIHBhdGNo
IGl0c2VsZiBpcyBhbHNvIGJyb2tlbi7CoCBLVk0NCj4gc2hvdWxkIChhKSBhZGQNCj4gc3VwcG9y
dCBmb3IgdmlydHVhbGl6aW5nIEVSQVBTIGFuZCAoYikgYWR2ZXJ0aXNlIHN1cHBvcnQgdG8NCj4g
KnVzZXJzcGFjZSouwqAgVGhlDQo+IHVzZXJzcGFjZSBWTU0gdWx0aW1hdGVseSBkZWNpZGVzIHdo
YXQgdG8gZXhwb3NlL2VuYWJsZSBmb3IgdGhlIGd1ZXN0Lg0KDQpQb2ludCB0YWtlbiAtIEkgaW50
ZXJwcmV0ZWQgaXQgdGhlIHdheSBJIHdhbnRlZCBpdCB0byAtIGJ1dCBJIGNhbiBzZWUNCndoYXQg
eW91IG1lYW4gLSBJJ2xsIHJld29yZC4NCg0KWy4uLl0NCg0KPiA+IFdoaWxlIHRoZSBuZXcgZGVm
YXVsdCBSU0Igc2l6ZSBpcyB1c2VkIG9uIHRoZSBob3N0IHdpdGhvdXQgYW55DQo+ID4gc29mdHdh
cmUNCj4gPiBtb2RpZmljYXRpb24gbmVjZXNzYXJ5LCB0aGUgUlNCIHNpemUgZm9yIGd1ZXN0cyBp
cyBsaW1pdGVkIHRvIHRoZQ0KPiA+IG9sZGVyDQo+IA0KPiBQbGVhc2UgZGVzY3JpYmUgaGFyZHdh
cmUgYmVoYXZpb3IsIGFuZCBtYWtlIGl0IGFidW5kYW50bHkgY2xlYXIgdGhhdA0KPiB0aGUgY2hh
bmdlbG9nDQo+IGlzIHRhbGtpbmcgYWJvdXQgaGFyZHdhcmUgYmVoYXZpb3IuwqAgT25lIG9mIG15
IHBldCBwZWV2ZXMNCj4gKHVuZGVyc3RhdGVtZW50KSB3aXRoDQo+IHRoZSBBUE0gaXMgdGhhdCBp
dCBkb2VzIGEgc2hpdCBqb2Igb2YgZXhwbGFpbmluZyB0aGUgYWN0dWFsDQo+IGFyY2hpdGVjdHVy
YWwgYmVoYXZpb3IuDQoNCk9LLCBtb3JlIHJld29yZGluZy4NCg0KSGFyZHdhcmUgYmVoYXZpb3Vy
IGlzIHRvIGp1c3QgdXNlIDY0IGVudHJpZXMgb24gdGhlIGhvc3Q7IGFuZCBsaW1pdCB0bw0KMzIg
ZW50cmllcyBmb3IgYW55IGd1ZXN0LiAgSWYgdGhlIHJpZ2h0IFZNQ0IgYml0cyBhcmUgc2V0LCBs
aWtlIGluIHRoZQ0KcGF0Y2gsIHRoZSBoYXJkd2FyZSB1c2VzIGFsbCB0aGUgNjQgZW50cmllcyBm
b3IgdGhlIGd1ZXN0Lg0KDQo+ID4gdmFsdWUgKDMyIGVudHJpZXMpIGZvciBiYWNrd2FyZHMgY29t
cGF0aWJpbGl0eS4NCj4gDQo+IEJhY2t3YXJkcyBjb21wYXRpYmlsaXR5IHdpdGggd2hhdD/CoCBB
bmQgaG93IGZhciBiYWNrP8KgIEUuZy4gaGF2ZSBDUFVzDQo+IHdpdGggYSBSQVANCj4gYWx3YXlz
IGhhZCAzMiBlbnRyaWVzPw0KDQpZZXMsIGFsbCBDUFVzIHVwdG8gWmVuNSBoYWQgMzIgZW50cmll
cyAtLSB0aGF0IG51bWJlcidzIGV2ZW4ganVzdCBoYXJkLQ0KY29kZWQgaW4gdGhlIGRlZmluaXRp
b24gb2YgUlNCX0NMRUFSX0xPT1BTLCB3aGljaCBpcyB1c2VkIGZvciB0aGUgUlNCDQpzdHVmZmlu
Zy4NCg0KVGhlIHdvcmRpbmcgaXMgYm9ycm93ZWQgYSBiaXQgZnJvbSB0aGUgQVBNIC0tIGVzcGVj
aWFsbHkgdGhlICJkZWZhdWx0Ig0KdmFsdWUuICBXaXRoIFplbjUsIHRoZSBkZWZhdWx0IGhhcmR3
YXJlIFJTQiBzaXplIGlzIDY0LiAgU28gdG8gZXhwb3NlDQp0aGUgaGFyZHdhcmUtZGVmYXVsdCBz
aXplIHRvIHRoZSBndWVzdCwgdGhpcyBWTUNCIHVwZGF0ZSBpcyBuZWNlc3Nhcnk7DQplbHNlIHRo
ZSBndWVzdHMgdXNlIHRoZSBub24tZGVmYXVsdCwgdHJpbW1lZC1kb3duIDMyIGVudHJ5IFJTQi4N
Cj4gDQoNCj4gPiB0byBhbHNvIHVzZSB0aGUgZGVmYXVsdCBudW1iZXIgb2YgZW50cmllcyBieSBz
ZXR0aW5nDQo+IA0KPiAiZGVmYXVsdCIgaXMgY2xlYXJseSB3cm9uZywgc2luY2UgdGhlICpkZWZh
dWx0KiBiZWhhdmlvciBpcyB0byB1c2UNCg0KWWVhOyBJIGdldCB0aGlzIGlzIGNvbmZ1c2luZy4g
IFRoZSBoYXJkd2FyZSBkZWZhdWx0IGlzIDY0LCBidXQgZ3Vlc3QNCmRlZmF1bHQgaXMgMzIuICBN
eSBpbnRlbnRpb24gd2l0aCB0aGF0IHN0bXQgd2FzIHRvIHNheSB1c2UgdGhlIG5hdGl2ZQ0KZGVm
YXVsdCB2cyB0aGUgZ3Vlc3QgZGVmYXVsdC4gIFdpbGwgcmV3b3JkLg0KDQo+ID4gdGhlIG5ldyBB
TExPV19MQVJHRVJfUkFQIGJpdCBpbiB0aGUgVk1DQi4NCj4gDQo+IEkgZGV0ZXN0IHRoZSAiQUxM
T1dfTEFSR0VSIiBuYW1lLsKgICJBbGxvdyIgaW1wbGllcyB0aGUgZ3Vlc3Qgc29tZWhvdw0KPiBo
YXMgYSBjaG9pY2UuDQo+IEFuZCAiTGFyZ2VyIiBpbXBsaWVzIHRoZXJlJ3MgYW4gZXZlbiBsYXJn
ZXIgc2l6ZQ0KDQpJIGFncmVlLCBidXQgdGhpcyBpcyB0aGUgbmFtZSB1c2VkIGluIHRoZSBBUE0u
ICBXaGF0J3MgdGhlIHByZWZlcmVuY2UgLQ0KZGV2aWF0ZSBmcm9tIHRoZSBBUE0gbmFtaW5nLCBv
ciBzdGljayB0byBpdCwgZGVzcGl0ZSB0aGUgY29uZnVzaW9uIGl0DQpjYXVzZXM/DQoNCg0KPiA+
IFRoZSB0d28gY2FzZXMgZm9yIGJhY2t3YXJkIGNvbXBhdGliaWxpdHkgdGhhdCBuZWVkIHNwZWNp
YWwgaGFuZGxpbmcNCj4gPiBhcmUNCj4gPiBuZXN0ZWQgZ3Vlc3RzLCBhbmQgZ3Vlc3RzIHVzaW5n
IHNoYWRvdyBwYWdpbmcNCj4gDQo+IEd1ZXN0cyBkb24ndCB1c2Ugc2hhZG93IHBhZ2luZywgKktW
TSogdXNlcyANCj4gDQo+ID4gKG9yIHdoZW4gTlBUIGlzIGRpc2FibGVkKToNCj4gDQo+ICJpLmUi
LCBub3QgIm9yIi7CoCAiT3IiIG1ha2VzIGl0IHNvdW5kIGxpa2UgIk5QVCBpcyBkaXNhYmxlZCIg
aXMNCj4gc2VwYXJhdGUgY2FzZQ0KPiBmcm9tIHNoYWRvdyBwYWdpbmcuDQo+IA0KPiA+IEZvciBu
ZXN0ZWQgZ3Vlc3RzOiB0aGUgRVJBUFMgZmVhdHVyZSBhZGRzIGhvc3QvZ3Vlc3QgdGFnZ2luZyB0
bw0KPiA+IGVudHJpZXMNCj4gPiBpbiB0aGUgUlNCLCBidXQgZG9lcyBub3QgZGlzdGluZ3Vpc2gg
YmV0d2VlbiBBU0lEcy7CoCBPbiBhIG5lc3RlZA0KPiA+IGV4aXQsDQo+ID4gdGhlIEwwIGh5cGVy
dmlzb3IgaW5zdHJ1Y3RzIHRoZSBoYXJkd2FyZSAodmlhIGFub3RoZXIgbmV3IFZNQ0IgYml0LA0K
PiANCj4gSSBzdHJvbmdseSBzdXNwZWN0IHRoaXMgd2FzIGNvcGllZCBmcm9tIHRoZSBBUE0uwqAg
UGxlYXNlIGRvbid0IGRvDQo+IHRoYXQuwqAgU3RhdGUNCj4gd2hhdCBjaGFuZ2UgaXMgYmVpbmcg
Zm9yICpLVk0qLCBub3QgZm9yICJ0aGUgTDAgaHlwZXJ2aXNvciIuwqAgVGhpcw0KPiB2ZXJiaWFn
ZSBtaXhlcw0KPiBoYXJkd2FyZSBiZWhhdmlvciB3aXRoIHNvZnR3YXJlIGJlaGF2aW9yLCB3aGlj
aCBhZ2FpbiBpcyB3aHkgSSBoYXRlDQo+IG11Y2ggb2YgdGhlDQo+IEFQTSdzIHdvcmRpbmcuDQoN
ClRoaXMgaXNuJ3QgbmVjZXNzYXJpbHkgZnJvbSB0aGUgQVBNOyB0aGlzIGlzIG1lIGRlc2NyaWJp
bmcgd2hhdCB0aGUgaHcNCmRvZXMsIHRvIHNldCB1cCB3aHkgS1ZNIG5lZWRzIHRvIGRvIGEgZmV3
IG90aGVyIHRoaW5ncy4NCg0KSSB3YW50IHRvIHNheSB0aGF0IHRoZSBodyBpcyBpbiBjb250cm9s
IG9mIGhvc3QvZ3Vlc3QgdGFnZ2luZyBmb3IgdGhlDQpSU0IgZW50cmllczsgYnV0IGl0IGRvZXMg
bm90IHRhZyBBU0lEcy4gIFNvIEtWTSBydW5uaW5nIGFzIEwwDQpoeXBlcnZpc29yIG5lZWRzIHRv
IHRha2UgY2VydGFpbiBzdGVwcy4gIEtWTSBydW5uaW5nIGFzIEwxIGh5cGVydmlzb3INCmRvZXMg
bm90IG5lZWQgdG8uDQoNCj4gPiBGTFVTSF9SQVBfT05fVk1SVU4pIHRvIGZsdXNoIHRoZSBSU0Ig
b24gdGhlIG5leHQgVk1SVU4gdG8gcHJldmVudA0KPiA+IFJTQg0KPiA+IHBvaXNvbmluZyBhdHRh
Y2tzIGZyb20gYW4gTDIgZ3Vlc3QgdG8gYW4gTDEgZ3Vlc3QuwqAgV2l0aCB0aGF0IGluDQo+ID4g
cGxhY2UsDQo+ID4gdGhpcyBmZWF0dXJlIGNhbiBiZSBleHBvc2VkIHRvIGd1ZXN0cy4NCj4gDQo+
IEVSQVBTIGNhbiBhbHNvIGJlIGFkdmVydGlzZWQgaWYgbmVzdGVkIHZpcnR1YWxpemF0aW9uIGlz
IGRpc2FibGVkLA0KPiBubz/CoCBJIHRoaW5rDQo+IGl0IG1ha2VzIHNlbnNlIHRvIGZpcnN0IGFk
ZCBzdXBwb3J0IGZvciBFUkFQUyBpZiAiIW5lc3RlZCIsIGFuZCB0aGVuDQo+IGluIGEgc2VwYXJh
dGUNCj4gcGF0aCwgYWRkIHN1cHBvcnQgZm9yIEVSQVBTIHdoZW4gbmVzdGVkIHZpcnR1YWxpemF0
aW9uIGlzIGVuYWJsZWQuwqANCj4gUGFydGx5IHNvIHRoYXQNCj4gaXQncyBlYXNpZXIgZm9yIHJl
YWRlcnMgdG8gdW5kZXJzdGFuZCB3aHkgbmVzdGVkIFZNcyBhcmUgc3BlY2lhbCwgYnV0DQo+IG1h
aW5seSBiZWNhdXNlDQo+IHRoZSBuZXN0ZWQgdmlydHVhbGl6YXRpb24gc3VwcG9ydCBpcyBzb3Jl
bHkgbGFja2luZy4NCg0KWWVhLCBpdCBtYWtlcyBzZW5zZSB0byBzcGxpdCB0aGVzZSB1cCwgSSds
bCB0cnkgZG9pbmcgdGhhdC4NCg0KTmVzdGVkIHZpcnQgZGlzYWJsZWQgaXMgdGhlIGNvbW1vbiBj
YXNlLCBzbyBpdCBtYWtlcyBzZW5zZSB0byBtYWtlIHRoYXQNCm1vcmUgb2J2aW91cyBhcyB3ZWxs
Lg0KDQo+ID4gRm9yIHNoYWRvdyBwYWdpbmcgZ3Vlc3RzOiBkbyBub3QgZXhwb3NlIHRoaXMgZmVh
dHVyZSB0byBndWVzdHM7DQo+ID4gb25seQ0KPiA+IGV4cG9zZSBpZiBuZXN0ZWQgcGFnaW5nIGlz
IGVuYWJsZWQsIHRvIGVuc3VyZSBhIGNvbnRleHQgc3dpdGNoDQo+ID4gd2l0aGluDQo+ID4gYSBn
dWVzdCB0cmlnZ2VycyBhIGNvbnRleHQgc3dpdGNoIG9uIHRoZSBDUFUgLS0gdGhlcmVieSBlbnN1
cmluZw0KPiA+IGd1ZXN0DQo+ID4gY29udGV4dCBzd2l0Y2hlcyBmbHVzaCBndWVzdCBSU0IgZW50
cmllcy4NCj4gDQo+IEh1aD8NCg0KT0sgdGhpcyBpcyB3aGVyZSBJJ20gc2xpZ2h0bHkgY29uZnVz
ZWQgYXMgd2VsbCAtIHNvIHRlbGwgbWUgaWYgSSdtDQp3cm9uZzoNCg0KV2hlbiBFUFQvTlBUIGlz
IGRpc2FibGVkLCBhbmQgc2hhZG93IE1NVSBpcyB1c2VkIGJ5IGt2bSwgdGhlIENSMw0KcmVnaXN0
ZXIgb24gdGhlIENQVSBob2xkcyB0aGUgUEdEIG9mIHRoZSBxZW11IHByb2Nlc3MuICBTbyBpZiBh
IHRhc2sNCnN3aXRjaCBoYXBwZW5zIHdpdGhpbiB0aGUgZ3Vlc3QsIHRoZSBDUjMgb24gdGhlIENQ
VSBpcyBub3QgdXBkYXRlZCwgYnV0DQpLVk0ncyBzaGFkb3cgTU1VIHJvdXRpbmVzIGNoYW5nZSB0
aGUgcGFnZSB0YWJsZXMgcG9pbnRlZCB0byBieSB0aGF0DQpDUjMuICBDb250cmFzdGluZyB0byB0
aGUgTlBUIGNhc2UsIHRoZSBDUFUncyBDUjMgaG9sZHMgdGhlIGd1ZXN0IFBHRA0KZGlyZWN0bHks
IGFuZCB0YXNrIHN3aXRjaGVzIHdpdGhpbiB0aGUgZ3Vlc3QgY2F1c2UgYW4gdXBkYXRlIHRvIHRo
ZQ0KQ1BVJ3MgQ1IzLg0KDQpBbSBJIG1pc3JlbWVtYmVyaW5nIGFuZCBtaXNyZWFkaW5nIHRoZSBj
b2RlPw0KDQo+ID4gRm9yIHNoYWRvdyBwYWdpbmcsIHRoZSBDUFUncyBDUjMgaXMgbm90IHVzZWQg
Zm9yIGd1ZXN0IHByb2Nlc3NlcywNCj4gPiBhbmQgaGVuY2UNCj4gPiBjYW5ub3QgYmVuZWZpdCBm
cm9tIHRoaXMgZmVhdHVyZS4NCj4gDQo+IFdoYXQgZG9lcyB0aGF0IGhhdmUgdG8gZG8gd2l0aCBh
bnl0aGluZz8NCg0KSWYgd2hhdCBJIHdyb3RlIGFib3ZlIGlzIHRydWUsIHNpbmNlIENSMyBkb2Vz
IG5vdCBjaGFuZ2Ugd2hlbiBndWVzdA0KdGFza3Mgc3dpdGNoLCB0aGUgUlNCIHdpbGwgbm90IGJl
IGZsdXNoZWQgYnkgaGFyZHdhcmUgb24gZ3Vlc3QgdGFzaw0Kc3dpdGNoZXMsIGFuZCBzbyBleHBv
c2luZyBFUkFQUyB0byB0aGlzIGd1ZXN0IGlzIHdyb25nIC0tIGl0J2xsIHJlbGF4DQppdHMgb3du
IEZJTExfUkVUVVJOX0JVRkZFUiByb3V0aW5lcyAodmlhIHBhdGNoIDEpIGFuZCB0aGF0J3Mgbm90
IHdoYXQNCndlIHdhbnQgd2hlbiB0aGUgaHcgaXMgZG9pbmcgdGhhdC4NCg0KWy4uLl0NCg0KPiA+
IEBAIC0xMzYyLDEwICsxMzY0LDIyIEBAIHN0YXRpYyBpbmxpbmUgaW50IF9fZG9fY3B1aWRfZnVu
YyhzdHJ1Y3QNCj4gPiBrdm1fY3B1aWRfYXJyYXkgKmFycmF5LCB1MzIgZnVuY3Rpb24pDQo+ID4g
wqAgY2FzZSAweDgwMDAwMDIwOg0KPiA+IMKgIGVudHJ5LT5lYXggPSBlbnRyeS0+ZWJ4ID0gZW50
cnktPmVjeCA9IGVudHJ5LT5lZHggPSAwOw0KPiA+IMKgIGJyZWFrOw0KPiA+IC0gY2FzZSAweDgw
MDAwMDIxOg0KPiA+IC0gZW50cnktPmVieCA9IGVudHJ5LT5lY3ggPSBlbnRyeS0+ZWR4ID0gMDsN
Cj4gPiArIGNhc2UgMHg4MDAwMDAyMTogew0KPiA+ICsgdW5zaWduZWQgaW50IGVieF9tYXNrID0g
MDsNCj4gPiArDQo+ID4gKyBlbnRyeS0+ZWN4ID0gZW50cnktPmVkeCA9IDA7DQo+ID4gwqAgY3B1
aWRfZW50cnlfb3ZlcnJpZGUoZW50cnksIENQVUlEXzgwMDBfMDAyMV9FQVgpOw0KPiA+ICsNCj4g
PiArIC8qDQo+ID4gKyAqIEJpdHMgMjM6MTYgaW4gRUJYIGluZGljYXRlIHRoZSBzaXplIG9mIHRo
ZSBSU0IuDQo+IA0KPiBJcyB0aGlzIGVudW1lcmF0aW9uIGV4cGxpY2l0bHkgdGllZCB0byBFUkFQ
Uz8NCg0KTm90IHRpZWQgdG8gRVJBUFMsIGJ1dCBpdCBoYXBwZW5zIHRvIGJlIGRlZmluZWQgYXQg
dGhlIHNhbWUgdGltZSBhcw0KRVJBUFMgaXMgYmVpbmcgZGVmaW5lZCwgYW5kIHRoZXJlJ3Mgbm8g
b3RoZXIgQ1BVSUQgYml0IHRoYXQgc2F5cyAndGhlDQpSU0Igc2l6ZSBpcyBub3cgYXZhaWxhYmxl
IGluIHRoZXNlIGJpdHMnLiAgU28geWVhLCB0aGUgRVJBUFMgQ1BVSUQgYml0DQppcyBiZWluZyBv
dmVybG9hZGVkIGhlcmUuICBFeGlzdGVuY2Ugb2YgdGhlIEVSQVBTIENQVUlEIGJpdCBjb25maXJt
cw0KdGhhdCB0aGUgZGVmYXVsdCBSU0Igc2l6ZSBpcyBub3cgZGlmZmVyZW50LCBhbmQgdGhhdCB0
aGUgaGFyZHdhcmUNCmZsdXNoZXMgdGhlIFJTQiAoYXMgaW4gcGF0Y2ggMSkuDQoNCj4gPiArICog
RXhwb3NlIHRoZSB2YWx1ZSBpbiB0aGUgaGFyZHdhcmUgdG8gdGhlIGd1ZXN0Lg0KPiANCj4gX19k
b19jcHVpZF9mdW5jKCkgaXMgdXNlZCB0byBhZHZlcnRpc2UgS1ZNJ3Mgc3VwcG9ydGVkIENQVUlE
IHRvIGhvc3QNCj4gdXNlcnNwYWNlLA0KPiBub3QgdG8gdGhlIGd1ZXN0Lg0KPiANCj4gU2lkZSB0
b3BpYywgd2hhdCBoYXBwZW5zIHdoZW4gWmVuNiBhZGRzIEVWRU5fTEFSR0VSX1JBUD/CoCBFbnVt
ZXJhdGluZw0KPiB0aGUgc2l6ZSBvZg0KPiB0aGUgUkFQIHN1Z2dldHMgaXQncyBsaWtlbHkgdG8g
Y2hhbmdlIGluIHRoZSBmdXR1cmUuDQoNCkl0J3MganVzdCBpbmZvcm1hdGlvbmFsLW9ubHkgZm9y
IG5vdywgYW5kIHRoZXJlIGFyZW4ndCBhbnkgcGxhbnMgdG8NCmV4dGVuZCB0aGUgUkFQIGFueW1v
cmUuICBCdXQgeW91J3JlIHJpZ2h0IC0gaXQgY291bGQgY2hhbmdlIGluIHRoZQ0KZnV0dXJlLg0K
DQo+ID4gKyAqLw0KPiA+ICsgaWYgKGt2bV9jcHVfY2FwX2hhcyhYODZfRkVBVFVSRV9FUkFQUykp
DQo+ID4gKyBlYnhfbWFzayB8PSBHRU5NQVNLKDIzLCAxNik7DQo+ID4gKw0KPiA+ICsgZW50cnkt
PmVieCAmPSBlYnhfbWFzazsNCj4gDQo+IFRoaXMgaXMgYSB3YXN0ZSBvZiBjb2RlIGFuZCBtYWtl
cyBpdCB1bm5lY2Vzc2FyaWx5IGRpZmZpY3VsdCB0bw0KPiByZWFkLsKgIEp1c3QgZG86DQo+IA0K
PiAgaWYgKGt2bV9jcHVfY2FwX2hhcyhYODZfRkVBVFVSRV9FUkFQUykpDQo+ICBlbnRyeS0+ZWJ4
ICY9IEdFTk1BU0soMjMsIDE2KTsNCj4gIGVsc2UNCj4gIGVudHJ5LT5lYnggPSAwOw0KDQpXZWxs
IEkgbGVmdCBpdCBhbGwgdGhpcyB3YXkgdG8gbWFrZSBpdCBlYXNpZXIgdGhlIHRoZSBmdXR1cmUg
dG8gYWRkDQptb3JlIGVieCBiaXRzIGhlcmUsIGJ1dCBzdXJlIC0gSSdsbCBqdXN0IHNob3J0ZW4g
aXQgbm93Lg0KDQpbLi4uXQ0KDQoNCgkJQW1pdA0K

