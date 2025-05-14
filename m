Return-Path: <kvm+bounces-46491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 549D8AB6992
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 13:15:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD9201B451FA
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 11:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5387E274668;
	Wed, 14 May 2025 11:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TuiH3Kjf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B575025DD09;
	Wed, 14 May 2025 11:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747221303; cv=fail; b=UIs/ihVepkv/s0ghCsg2Ek9oUrXmm67e2cOs7RJszTiqf6ykjrFGjcL2CvogcDl3CguldMksS1Pkzjag59E3pARB+VcTdCOKXrWvh8zZFDAuwwOx2tcNVPazq1aFe6RZRJA0xfPK7YoTisGRsz3GNVTjOog7hzPQvI3ebEo6e8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747221303; c=relaxed/simple;
	bh=VBtziDGsTmbuOGYgKcmoIh4nkhZifnHq9sYUXsqHI5o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gHLoa2fleO1kPDo8a+b9yFmXS9yVC0fVhKLssf+1WKr+AjC6groapJCRjUsE0wkDckJoDB+upEChNLn8ZS/PuNNRgemmmAHK1pLmSxWeIgcwJcsPQ+PMd3OS8Ml2aLHSZjD2mMWXWsmKFYyFaRFlscvac9JF/xofw1JOogVO6n0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TuiH3Kjf; arc=fail smtp.client-ip=40.107.223.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VRwPeplsqoe0l7SfJQWig+j4+1U+tomeEAqrsUKXHqB8s+9lIJiByS2wGAtJdMgm2VvfAQMfoGswRolSzACut5OF6+HBQUUaes/TBRCA+WlhB6ESGbIfvLsUDy9G2mntvshlPHXmKK9X5uXPpibBSa14BiRFQ1Uqb8xUXGwP5IMVS7Wk7uVcNJgcyQZm7dEbP/TRLqICaoW+LL5eu7kkB0qhjGQo+zk3LJwFboTEJGf5xFoATFjbtxYdP1QPlpn0j4HEB5gEN0j7XLFOLPLW3hl5k4zoovbHcKAJIu0vHpuK34/JVMGVfDu9+uT060BL8rOF4Ey8a9FQ3mWtMrP19w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBtziDGsTmbuOGYgKcmoIh4nkhZifnHq9sYUXsqHI5o=;
 b=pI3zhagbtmPMZX3uS50dbVN76H7hfG2boEZJ34IqBGC0Gb/bz9xD5J/sGW5TZIi1Al1MoTR+jQ7mMvNoHchFuxeEajlgBa3k/OT0uq5pdVUSvSuxSQIlurhT8dRuCHxwrLKE9rMszoouVR6aTB7vtulf/+58bSEKFq8YzsSBveTIa210N3lOyePnejE6hh+Tw1HDERzzD2jEu+gOXQ+H8q2R3nFaihw9rVUbffi9BXXHFW/AoBwFdZ+49Wnu5QgYd9h/46zCn+09WAQSEzi3d6lPW5BVPcYRO9YbLkbazbfCjUJgml0PEax0xjeBQWQ1Ufk2baPr754x/1HKTEtgEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBtziDGsTmbuOGYgKcmoIh4nkhZifnHq9sYUXsqHI5o=;
 b=TuiH3Kjfc4LzVotKVEy+wSVDRTJDZCBfgMgqmNv8OBWmdrGIoYyxogrJoxD5gJjjARkvQbYOhuMjlY21q5O8UZ44ETo6WH6x0q5PQSnm169Ac6N684u1KfRaRZYptbr5uDANJkcjEnCYwVTtWLdDtdpJkwFqbdfAHW8R230wqO8=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 11:14:59 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8722.024; Wed, 14 May 2025
 11:14:59 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jon@nutanix.com" <jon@nutanix.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Thread-Topic: [RFC PATCH 06/18] KVM: VMX: Wire up Intel MBEC enable/disable
 logic
Thread-Index: AQHbxMFtWyUBuEz1L0e+rLeQCWrihA==
Date: Wed, 14 May 2025 11:14:59 +0000
Message-ID: <6dd4eee79fec75a47493251b87c74595826f97bc.camel@amd.com>
References: <20250313203702.575156-1-jon@nutanix.com>
	 <20250313203702.575156-7-jon@nutanix.com> <aCI8pGJbn3l99kq8@google.com>
	 <49556BAF-9244-4FE5-9BA9-846F2959ABD1@nutanix.com>
	 <aCNI72KuMLfWb9F2@google.com>
In-Reply-To: <aCNI72KuMLfWb9F2@google.com>
Accept-Language: de-DE, en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|DS7PR12MB6008:EE_
x-ms-office365-filtering-correlation-id: 0f2c0514-62f7-47c6-2786-08dd92d89087
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Z3pxdzZnMlA2dmhzUlRucDU3REQ3a1V4RXloSFBFVzFmdGVGZ2YzaEREcUk5?=
 =?utf-8?B?RXpBWHh1K1RBZkhockNMV3BNNEMyd2hycTlWZlNVOFdzOWJMTURpb1dNS1BG?=
 =?utf-8?B?V2NhMDh5TXhVNGNoQ3hicFpCUXBxcTBkSGJNbFl4UGc3MkFDS0hHNlFxT25w?=
 =?utf-8?B?YWJVZE5HSjFBRGhMOTZwRmZVbk5jK01BNzQ2bTJYZzErNHpiemttTzBBa3NF?=
 =?utf-8?B?TjVLL2c5VDNqMWwyQk1HOFZuS3Arbi9IRGRweUZVOVF5bFRIYjJvK3VPSDdv?=
 =?utf-8?B?V2xDQUVRMXFXdEhmM1lFOUt5NmorZERtellPcGJXdTllOXFGb3pwZk1TOTN6?=
 =?utf-8?B?UytUUnZjbThpM3E5RU12UWJ6dzEwTVhVT0dtbVJEZWIrcVo2dFBuRGp5LzdP?=
 =?utf-8?B?NEZKN1ZoMi84VkVpSkJqT1Z2SDFnTGErUS9lUEQrWHVkcm5yem9TN3NMemQ1?=
 =?utf-8?B?dHNNcStqZVFBdC94K3ZNRHU2ZUJpd0Q4QjFCSXhkampCajRLNFh4TFhzdy9Y?=
 =?utf-8?B?NGcrZTZNTC9PSEtyRlRIcVpaU205aUNrRy8vY214YUhyNTJKVk12T1l5RGxY?=
 =?utf-8?B?U0Y4cnJCbjB5NmdkTHR3ZUF5NC8xeEJRdGg2TlZlT3NHYThOY0FjbmVoWnMr?=
 =?utf-8?B?a0JYeVRBZ1lLQk1JRmd1dERDaVlhcHlhNW9EVXBHMlpidnowTjNHd2F5N3NT?=
 =?utf-8?B?SldlNCthNzkwZEZWWG5ESjR1b2pDendhdXduekFiMmRnSlh4dzZuYnNINUNS?=
 =?utf-8?B?S3pqUTJaYlVIUGVzOGl6eTVrZGc2cFZkZXBFOE1SR0tOeEFPSGpUREcyMllm?=
 =?utf-8?B?NG51NzZhWW9BRTRjeDFzUE96RnFsU3IwUS80WWlpNzVGYms5eUgxSm1pTmh6?=
 =?utf-8?B?eUJKWTZEQnFEMzNVOWZlelAwOExVTWQ2OWV6UXNvd3NmR2xCSEZlOXpydG5P?=
 =?utf-8?B?N00vaGFtMnp4ZERsL1pZbzUvZ1FOS0RYWUUzSmV0aDRiNko1SGJRdVlRSXFt?=
 =?utf-8?B?TVQ2bjBnQUxFdXo3SklUaysrbWRwb1BZcVJ0YmRUNThHTnA4MU9ES3g4ZFo1?=
 =?utf-8?B?bXMxUUc5VUJTaUl5M1RVSDBGZWZ4RlRreXJZamdzZEk0aWtmV0VxYjB3VDNY?=
 =?utf-8?B?V1RLc3RSQmZLZGxsNUgrMm1Ndk5temsyQ3ppMnUxY255WXV6cGRHbGg4d3Az?=
 =?utf-8?B?MXk2SmlhSGZPcFVaU3lGZG4wWkl6NEhMTEhlWXJnaTJtQTNwWFV4RStFR0ls?=
 =?utf-8?B?b3djQSswR21qelFlcVFwcXhHUjk5aDV0bUtzUGU2U0hLY3JsaUxWMzRSV1dV?=
 =?utf-8?B?RkFGRzU5N2pnWStxOG9pZG4rdWwwV25IQ1hoVXdrbkh3RzduazZLWGV4S0sy?=
 =?utf-8?B?V213c3JxajdIaCs3eVVFa0Rob0FyN1EwTFpOVUxmZEFCNGJkZWxSNzFwMlUw?=
 =?utf-8?B?cno1czBlczlZMUwvQ3IzcXNsc1hNaVY3cDZQRmFaZWhWNk1oQjYyVlBrRlRo?=
 =?utf-8?B?UkZBZzFOdUtnTEFSQXU1aDg3VjJFdDhjYjdQTG42eWdCWEZVYzFqRXh1U2lh?=
 =?utf-8?B?cEpmU1lFTXpmNkQ2TUE1Y3hqdE1EK1pFSGFTTjJpWWlFYkxQS0ZDYm51Nlov?=
 =?utf-8?B?aFBoeXpneHBkbEpwcWdablFLZTNaUUdaZnFCZmZMcHZwMWhXak0yUExOaU9y?=
 =?utf-8?B?cURNU2VGWDVQVXZBVWJLT2dVUVFlaUdTQStSajRVQmlyRExZdXdnNzZVY3lw?=
 =?utf-8?B?OHMvMzNFNzRNSCtKaGkxT0Z1UUR6MEhGOWJqSUdXMlVHNDQ3b2VFeXhCcTJh?=
 =?utf-8?B?azY5WmNMaFVIU3hvenJ1ZGxBN0FHSHpNSnd3M1ZmUEN5MVB1TjNUSnJtd2RR?=
 =?utf-8?B?SWhjR1E1Vnh2NU9PUDRqNld3dXF3Z3o5UThjZlBYZkM1ZExVakovbWlWdmlm?=
 =?utf-8?B?MHVWdkdMVkN6bnE1UGY4ZmN2bVJUNS9IZjR6V1VkdWoxWVhNSkpoaElWQXRM?=
 =?utf-8?Q?nfhKq+aAY2gjTQNa9mkGqa72wFMHsI=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b2hmTGhkcE84cGUxSWg1b0IvT2UzTitvTEdXYWJFbzV4ZVc1YktPanNnaU9j?=
 =?utf-8?B?ZHpsOU1nRGJ3N1NpRkNKTU1rQmlVUERNWVlWVk4rdEloSmpwbmZrZTdTUEoz?=
 =?utf-8?B?RmNHZFY3Q2ZYZk11ZkJSZm9aSjV5OHBGdmthVWN2K1d2UWpiZlBucHZKb2xK?=
 =?utf-8?B?dnY1Sk01YXVLS3MwYmZRWCtoRWl4NW5nQ3Y3RWxvT1l6N3NyRTdpRmVVU2dF?=
 =?utf-8?B?VHpvWTBGS0VGTC9wSGUwQ0ZvY0NJZWMxSTVuNmJZcDNTVGVrRFdBN0YwS0xT?=
 =?utf-8?B?K2pyNzRPQWRodCtLK0YyTnkrOWxMcC9zUVpzTjR0djZ5aDVja3VYWXU5MnJN?=
 =?utf-8?B?NU0weEdrRkM3QnBUTUFQY1g4OEczS05TbnEwV1EvSkVhL2tUNndPMVdpcWQ0?=
 =?utf-8?B?a1hNUnpXSFAvQ0RRTlBKc0ZQMVpCTnphdlhjZTIxZnB1Q3hhTSt2VTVHc0Rz?=
 =?utf-8?B?dVAyaXFwb2VMRUo0WVhRWGgwVEFhZXp1RCtGOTBqQWNVZzM0aGthU2M2S2Jq?=
 =?utf-8?B?OEg4cmlrOWhreU9LdkhEdDlWSmdSSGx1eUxqSGR5OXNnUm1jeGVYY0srTGpQ?=
 =?utf-8?B?UWxZZjRxZEFPd2x5OERzUFZBSml0MVB3RTFZMmsxdFNMUThzeUp1dTlqK3l3?=
 =?utf-8?B?aVNFL01nS3c1Z3RVRGNOUkNNRTlZMVFvdUVtS3V1RHV1K2hvV3lsTGd2Qi9V?=
 =?utf-8?B?RVVkZjRQL0JLbDYzMnpvdFhyL0RNM3lYSGxjVzFUeVBaZ0xZcDNQaElNVWw0?=
 =?utf-8?B?ZUEvRTNKb0h3MjBLWFZ6S2Ztc3VweXZyMkd0RC9ya0JrTm9HaTRSWmdoNVFp?=
 =?utf-8?B?WENMVjl5UWREN3BMbWJpNkE3TlFoQUtYaCtuWDlKNWswVldvRzExRkNyMEZJ?=
 =?utf-8?B?cGtRUUtEYTZFS1M2VGJlOTlQeldSYW56UmdXbnJMT1QwejlNNHBGcmsvTklO?=
 =?utf-8?B?cVJPdEp3TTBjR2dGKzBuTzhvUWpCTUJDM0ppeE4xMWFrczQ2ZDdwTXJiVlZE?=
 =?utf-8?B?TU9NaFUwZDgzNXhLTEk2MXlhV3hBQjFxbmZld1hOcXJraW83bG55WjlvaFQ3?=
 =?utf-8?B?WlQ5V1pVSVFxcjQxUzVQY2VrZER2UHFSYi91WnBwWFl2Tk1VWDFGNUZOaWZ5?=
 =?utf-8?B?cy9YTDFHeG80YWptQkk3b0hXTHIvRTNjU0RJU1hjRG51QVpOcnIwQ0Y2NTdo?=
 =?utf-8?B?NkdLeGRNclFXd1BjcnRSaXBVUHlrQ1VJZ3YyR251SnpDdXB2NnB5ZEI3ZmRX?=
 =?utf-8?B?a0R5Sjk4cys1WkI3OGlOQXVtd3Q3RGc2dTlUaGRVMHlrc09KY3puZ2RiejZk?=
 =?utf-8?B?WHpIdUJjTXNDeFJMSjZaMUkxbzhaS3BrSFRvemZSak1HNys4V2JBYkgvUUo4?=
 =?utf-8?B?ZlhVSGJTdDlob3dlbG1WVENWVzdWd1p5L1o1a1E1TXBCaTNYYm1IT3VqWjEy?=
 =?utf-8?B?UG9uazNzUFB3K2hhc1pVeFhQR0tnNmFvMWVFSzJOMXNsZkxpb0JpM2lBcVgw?=
 =?utf-8?B?Q3Z5OEVaMldBR3FHb1BDU2FwNytJaG8rbG16SFZRdTJWaWh2WEFORkF3Z1ZQ?=
 =?utf-8?B?WFlQOXc1UE9yNk45SlBRcC9nQzF0UXNBUzRZaUtuZElNSHlBYi82bXVEdTNj?=
 =?utf-8?B?NmxzZ0dmMWNpNEdnNXVwM3NzUkNLYnIrWWlORVJyczFuT3FoYytHM0FieW13?=
 =?utf-8?B?eVhYcXQrVmthbUd1bHVrVjI4VkJ3ZU9XaWVQS204WXhTdWFrdktTaDViTGd2?=
 =?utf-8?B?b3JVYUp0NFkyRVhLckVhKzJ2VkZxaFpYeHd3S2hzZzUvc1M5ZlF6RlVBYndN?=
 =?utf-8?B?V0YzKzNackVLbmdmb3RYMldIZEgwZS9uMzFZNFl4REtNeTJ4ZkRSc0NFNzBn?=
 =?utf-8?B?L2hDSjBUQnRabWJzM1RlMnZ6Z3RqTjhlL0hFZlRQWFpOUnBjaXhMQkFxT0Z6?=
 =?utf-8?B?TXRFSTVrc1h6QUdXSEFTSWE5bkdmTGt4dDVwaW15NUtSOUpoVW5MYjhNMnFE?=
 =?utf-8?B?Wkxvem9Ya0pKMDFJS0JvcURyRjd2QUV0QXR4QVhybHdIK0xycW9vQjd4OXJX?=
 =?utf-8?B?UzFQbVdqMHZOVDNvQzZ1Ylp4TXdvdy9LWEZIbVYwQTh0WkY2bjc5RXVrN2sw?=
 =?utf-8?Q?iDr0CvpVEBCGeyj0isfZv6M0x?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73C65AEAB5F912488BB41574BD894A03@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2c0514-62f7-47c6-2786-08dd92d89087
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 11:14:59.1432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u6v06WhzskRTWsto5oPsPnlaQZ0XqEhog2W+hG0/G5U/auJfPSc2c8AGgrwRlNwL0zA4bUGjAB2oO/E6lRVa2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008

T24gVHVlLCAyMDI1LTA1LTEzIGF0IDA2OjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1heSAxMywgMjAyNSwgSm9uIEtvaGxlciB3cm90ZToNCj4gPiA+IE9u
IE1heSAxMiwgMjAyNSwgYXQgMjoyM+KAr1BNLCBTZWFuIENocmlzdG9waGVyc29uDQo+ID4gPiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiA+ID4gPiBPbiBUaHUsIE1hciAxMywgMjAyNSwg
Sm9uIEtvaGxlciB3cm90ZToNCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgv
dm14LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+ID4gPiA+IGluZGV4IDdhOThmMDNlZjE0
Ni4uMTE2OTEwMTU5YTNmIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3Zt
eC5jDQo+ID4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiA+ID4gQEAgLTI2
OTQsNiArMjY5NCw3IEBAIHN0YXRpYyBpbnQgc2V0dXBfdm1jc19jb25maWcoc3RydWN0DQo+ID4g
PiA+IHZtY3NfY29uZmlnICp2bWNzX2NvbmYsDQo+ID4gPiA+IHJldHVybiAtRUlPOw0KPiA+ID4g
PiANCj4gPiA+ID4gdm14X2NhcC0+ZXB0ID0gMDsNCj4gPiA+ID4gKyBfY3B1X2Jhc2VkXzJuZF9l
eGVjX2NvbnRyb2wgJj0NCj4gPiA+ID4gflNFQ09OREFSWV9FWEVDX01PREVfQkFTRURfRVBUX0VY
RUM7DQo+ID4gPiA+IF9jcHVfYmFzZWRfMm5kX2V4ZWNfY29udHJvbCAmPQ0KPiA+ID4gPiB+U0VD
T05EQVJZX0VYRUNfRVBUX1ZJT0xBVElPTl9WRTsNCj4gPiA+ID4gfQ0KPiA+ID4gPiBpZiAoIShf
Y3B1X2Jhc2VkXzJuZF9leGVjX2NvbnRyb2wgJiBTRUNPTkRBUllfRVhFQ19FTkFCTEVfVlBJRCkN
Cj4gPiA+ID4gJiYNCj4gPiA+ID4gQEAgLTQ2NDEsMTEgKzQ2NDIsMTUgQEAgc3RhdGljIHUzMg0K
PiA+ID4gPiB2bXhfc2Vjb25kYXJ5X2V4ZWNfY29udHJvbChzdHJ1Y3QgdmNwdV92bXggKnZteCkN
Cj4gPiA+ID4gZXhlY19jb250cm9sICY9IH5TRUNPTkRBUllfRVhFQ19FTkFCTEVfVlBJRDsNCj4g
PiA+ID4gaWYgKCFlbmFibGVfZXB0KSB7DQo+ID4gPiA+IGV4ZWNfY29udHJvbCAmPSB+U0VDT05E
QVJZX0VYRUNfRU5BQkxFX0VQVDsNCj4gPiA+ID4gKyBleGVjX2NvbnRyb2wgJj0gflNFQ09OREFS
WV9FWEVDX01PREVfQkFTRURfRVBUX0VYRUM7DQo+ID4gPiA+IGV4ZWNfY29udHJvbCAmPSB+U0VD
T05EQVJZX0VYRUNfRVBUX1ZJT0xBVElPTl9WRTsNCj4gPiA+ID4gZW5hYmxlX3VucmVzdHJpY3Rl
ZF9ndWVzdCA9IDA7DQo+ID4gPiA+IH0NCj4gPiA+ID4gaWYgKCFlbmFibGVfdW5yZXN0cmljdGVk
X2d1ZXN0KQ0KPiA+ID4gPiBleGVjX2NvbnRyb2wgJj0gflNFQ09OREFSWV9FWEVDX1VOUkVTVFJJ
Q1RFRF9HVUVTVDsNCj4gPiA+ID4gKyBpZiAoIWVuYWJsZV9wdF9ndWVzdF9leGVjX2NvbnRyb2wp
DQo+ID4gPiA+ICsgZXhlY19jb250cm9sICY9IH5TRUNPTkRBUllfRVhFQ19NT0RFX0JBU0VEX0VQ
VF9FWEVDOw0KPiA+ID4gDQo+ID4gPiBUaGlzIGlzIHdyb25nIGFuZCB1bm5lY2Vzc2FyeS7CoCBB
cyBtZW50aW9uZWQgZWFybHksIHRoZSBpbnB1dA0KPiA+ID4gdGhhdCBtYXR0ZXJzIGlzDQo+ID4g
PiB2bWNzMTIuwqAgVGhpcyBmbGFnIHNob3VsZCAqbmV2ZXIqIGJlIHNldCBmb3Igdm1jczAxLg0K
PiA+IA0KPiA+IEnigJlsbCBwYWdlIHRoaXMgYmFjayBpbiwgYnV0IEnigJltIGxpa2UgNzUlIHN1
cmUgaXQgZGlkbuKAmXQgd29yayB3aGVuIEkNCj4gPiBkaWQgaXQgdGhhdCB3YXkuDQo+IA0KPiBU
aGVuIHlvdSBoYWQgb3RoZXIgYnVncy7CoCBUaGUgY29udHJvbCBpcyBwZXItVk1DUyBhbmQgdGh1
cyBuZWVkcyB0bw0KPiBiZSBlbXVsYXRlZA0KPiBhcyBzdWNoLsKgIERlZmluaXRlbHkgaG9sbGVy
IGlmIHlvdSBnZXQgc3R1Y2ssIHRoZXJlJ3Mgbm8gbmVlZCB0bw0KPiBkZXZlbG9wIHRoaXMgaW4N
Cj4gY29tcGxldGUgaXNvbGF0aW9uLg0KDQpMb29raW5nIGF0IHRoaXMgZnJvbSB0aGUgQU1EIEdN
RVQgUE9WLCBoZXJlJ3MgaG93IEkgdGhpbmsgc3VwcG9ydCBmb3INCnRoaXMgZmVhdHVyZSBmb3Ig
YSBXaW5kb3dzIGd1ZXN0IHdvdWxkIGJlIGltcGxlbWVudGVkOg0KDQoqIERvIG5vdCBlbmFibGUg
dGhlIEdNRVQgZmVhdHVyZSBpbiB2bWNiMDEuICBPbmx5IHRoZSBXaW5kb3dzIGd1ZXN0IChMMQ0K
Z3Vlc3QpIHNldHMgdGhpcyBiaXQgZm9yIGl0cyBvd24gZ3Vlc3QgKEwyIGd1ZXN0KS4gIEtWTSAo
TDApIHNob3VsZCBzZWUNCnRoZSBiaXQgc2V0IGluIHZtY2IwMiAoYW5kIHZtY2IxMikuICBPVE9I
LCBwYXNzIG9uIHRoZSBDUFVJRCBiaXQgdG8gdGhlDQpMMSBndWVzdC4NCg0KKiBLVk0gbmVlZHMg
dG8gcHJvcGFnYXRlIHRoZSAjTlBGIHRvIFdpbmRvd3MgKGluc3RlYWQgb2YgaGFuZGxpbmcNCmFu
eXRoaW5nIGl0c2VsZiAtLSBpZSBubyBzaGFkb3cgcGFnZSB0YWJsZSBhZGp1c3RtZW50cyBvciB3
YWxrcw0KbmVlZGVkKS4gIFdpbmRvd3Mgc3Bhd25zIGFuIEwyIGd1ZXN0IHRoYXQgY2F1c2VzIHRo
ZSAjTlBGLCBhbmQgV2luZG93cw0KaXMgdGhlIG9uZSB0aGF0IG5lZWRzIHRvIGNvbnN1bWUgdGhh
dCBmYXVsdC4NCg0KKiBLVk0gbmVlZHMgdG8gZGlmZmVyZW50aWF0ZSBhbiAjTlBGIGV4aXQgZHVl
IHRvIEdNRVQgb3Igbm9uLUdNRVQNCmNvbmRpdGlvbiAtLSBjaGVjayB0aGUgQ1BMIGFuZCBVL1Mg
Yml0cyBmcm9tIHRoZSBleGl0LCBhbmQgdGhlIE5YIGJpdA0KZnJvbSB0aGUgUFRFIHRoYXQgZmF1
bHRlZC4gIElmIGR1ZSB0byBHTUVULCBwcm9wYWdhdGUgaXQgdG8gdGhlIGd1ZXN0Lg0KSWYgbm90
LCBjb250aW51ZSBoYW5kbGluZyBpdA0KDQooYnR3IEtWTSBNTVUgQVBJIHF1ZXN0aW9uIC0tIGZy
b20gdGhlICNOUEYsIEkgaGF2ZSB0aGUgR1BBIG9mIHRoZSBMMg0KZ3Vlc3QuICBIb3cgdG8gZ28g
ZnJvbSB0aGF0IGd1ZXN0IEdQQSB0byBsb29rIHVwIHRoZSBOWCBiaXQgZm9yIHRoYXQNCnBhZ2U/
ICBJIHNraW1tZWQgYW5kIHRoZXJlIGRvZXNuJ3Qgc2VlbSB0byBiZSBhbiBleGlzdGluZyBBUEkg
Zm9yIGl0IC0NCnNvIGlzIHdhbGtpbmcgdGhlIHRhYmxlcyB0aGUgb25seSBzb2x1dGlvbj8pDQoN
CgkJQW1pdA0K

