Return-Path: <kvm+bounces-31939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7487B9CEFC0
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 16:24:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85DA8B2C342
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2024 14:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CF41CF5CE;
	Fri, 15 Nov 2024 14:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wRz33bEj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD4E1CD1F1;
	Fri, 15 Nov 2024 14:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731681857; cv=fail; b=EA3wblrDNm7HHu8PnuGxqotJUgLebGwK8WRM8xFpUqBRSQhEH6v2Savx6Ub642SnKfpyS9NQhNrwvinUIatqbtCzE2gXbeANhx5X71iF1YeKlOLKd331epFubvYp3FNBUdxzzKtmk+RM6CAdTPzbf2JVsMvssDpHgw2Ln4eUeB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731681857; c=relaxed/simple;
	bh=AkWFzZcxPRuDnXxyJMK53m3WsZy+lh53rwFgsY6cglA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HQVR5YEuD7Uizwo1p7bjiC2dLuV0RAOnlgg7ZFC79UVnbFGF9b3Misy64Zjfi3rdG4ddJnIqaTqn+ev/hvgRBsfpFKczOPP/ajdPqMT/Zei7X977y1EcHtHrA71H4ZyFbDqkFfu4gVVg/fKau2Z+mBHrE5R2J+Q8IVmZLGKuwuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wRz33bEj; arc=fail smtp.client-ip=40.107.94.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uGlB8hyQGq0w/1U0oc85wTBvFo+lpX0OxtGs3Nuccd2/Il5a59LPXq/UQqd4DMgP8pNHJrIsONaU8Qh9cTwcegAm5Mdxv4wxuqxJBaY5WsI1p73torpu3OiobKWGA5qmSxk/xTpxTDmoafNkT3iGq9gE6mTE3ecJXQ7CVWZrMgGnAytAOzngdk6cVTl7IBIy7r9pt5ay7w2L77ZhWbfCt7teWSbvYD3zIv87bBqNWB/eKaZ8QFn/IodOgzNCXcS6iQSSG+glohOeURS4Bz1p39EGW1fjxPGPS+vtmlMtzB4rmVXcSMXqV2CZ9jQtNgKaOHpxcSfOzCsHONr5DyLDbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AkWFzZcxPRuDnXxyJMK53m3WsZy+lh53rwFgsY6cglA=;
 b=x17VfmdqH7/ntQSWnE5dtcmTtKE27sS48+k/h1VIGGdghLNSrhult3rlgLaviGmY9KvmF/qOW29foKeOUj7Gs7RFXKWzdqNi6/uUGOOnvzVP2eDjhUgUDL1jG4vyPsLtQSxLBXOQCKY3ZXhd/S564Kr8eWMLQURqEKPEZJ7//k9ESG8R5FisdiL4RY2gI0uKu256m5e64hLpxV1zvOLZAfA7CuLba7eUs46vj7iZQuIwfaxk2JzmDfI8WHf1edg2ZReGRdjzNn7xiNmx1EL1QtBLJyeuHWgs6gm9yRWyGMUIcMfdLgqEbiZJOUUeHM4xEbgzcRvm+Qvu14BgVnHPpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AkWFzZcxPRuDnXxyJMK53m3WsZy+lh53rwFgsY6cglA=;
 b=wRz33bEjwq3fj5ntMPdbhM7aM/mY6ICgliGvxe1E/H1qaKOJX7hnws5oIWFFsMKQzcOrrePst+/jmTaTN9phA30Xlr8ebNdaMlWVWrSzeaowDB5wLeccPSfMlZ8EmOQvGulANjpiSet8ROZCYr1iTxPFSNvGObn+sJITC553DlY=
Received: from LV3PR12MB9265.namprd12.prod.outlook.com (2603:10b6:408:215::14)
 by CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Fri, 15 Nov
 2024 14:44:12 +0000
Received: from LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427]) by LV3PR12MB9265.namprd12.prod.outlook.com
 ([fe80::cf78:fbc:4475:b427%6]) with mapi id 15.20.8158.017; Fri, 15 Nov 2024
 14:44:12 +0000
From: "Kaplan, David" <David.Kaplan@amd.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>
CC: Andrew Cooper <andrew.cooper3@citrix.com>, Amit Shah <amit@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "x86@kernel.org"
	<x86@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"Shah, Amit" <Amit.Shah@amd.com>, "Lendacky, Thomas"
	<Thomas.Lendacky@amd.com>, "bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "corbet@lwn.net" <corbet@lwn.net>, "mingo@redhat.com"
	<mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>, "Moger, Babu"
	<Babu.Moger@amd.com>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>
Subject: RE: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Thread-Topic: [RFC PATCH v2 1/3] x86: cpu/bugs: update SpectreRSB comments for
 AMD
Thread-Index:
 AQHbNFhQEwe18XGdBky6ffKbqr/GHrKyeFwAgABS0QCAABWWAIABTnUAgAF7OYCAAF1RgIAACjqAgABcFgCAAW1DAIAAklIg
Date: Fri, 15 Nov 2024 14:44:12 +0000
Message-ID:
 <LV3PR12MB9265FC675DE47911654E605E94242@LV3PR12MB9265.namprd12.prod.outlook.com>
References: <20241111163913.36139-1-amit@kernel.org>
 <20241111163913.36139-2-amit@kernel.org>
 <20241111193304.fjysuttl6lypb6ng@jpoimboe>
 <564a19e6-963d-4cd5-9144-2323bdb4f4e8@citrix.com>
 <20241112014644.3p2a6te3sbh5x55c@jpoimboe>
 <20241112214241.fzqq6sqszqd454ei@desk>
 <20241113202105.py5imjdy7pctccqi@jpoimboe>
 <20241114015505.6kghgq33i4m6jrm4@desk>
 <20241114023141.n4n3zl7622gzsf75@jpoimboe>
 <20241114075403.7wxou7g5udaljprv@desk>
 <20241115054836.oubgh4jbyvjum4tk@jpoimboe>
In-Reply-To: <20241115054836.oubgh4jbyvjum4tk@jpoimboe>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ActionId=2fd2c14b-b35d-49f4-97d8-dbe1eec42478;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=0;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=true;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2024-11-15T14:32:17Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV3PR12MB9265:EE_|CY5PR12MB6060:EE_
x-ms-office365-filtering-correlation-id: bd0ef6d3-8c74-4b22-1a15-08dd0583f896
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?REhSbEJ6ejRrTGR4MXhZanBHT2xjbkRXYzdPTTVnL3JvVHNhcFpMMEw5cndB?=
 =?utf-8?B?UENUY25nb0Q2cENYVS9ONHBHYWVtdFFqZkpLaUE4Y1l6elhscnJSQ3I5K0xJ?=
 =?utf-8?B?SzV1RzBmZytnNC9pYWg3M0YwcGlkMzc5cW81UUZqVXVZY1phaG8zZ2l0S0Na?=
 =?utf-8?B?OGR2aHZ1UjVVMDFpTWt3Zm44NHBHcDhwYXRPUU5ZNjhiKzdPVWhsREZBYWh6?=
 =?utf-8?B?OHdndlZON0p5K3hka1ZlNllIbEhpRG8rRlM2alFPakhIaytXcU1iYUFxRlc3?=
 =?utf-8?B?S0o4VmNuNUlMR3lnY1Z3UVFpV3RiMkplQlUzb1FrMmk0TkRLdkcwUXA0cWhq?=
 =?utf-8?B?QkNNdnpidldDQm5icjYvK2Z1VWgraFVRZTQrM2FRY0ROSy8xQlZCWFkzNTR3?=
 =?utf-8?B?VWZMODhkOEJSLzRrUEhLNTdXbURtbVIvZE1pbjhNZFBmY0JYRTBXRG8yUXgy?=
 =?utf-8?B?UVNNNXpqS0N0bkp1R2ZRKzNKNVovV1lvNnZBTEM2aldnN2ZzU1N6YldiaTZ4?=
 =?utf-8?B?T1VOemF6Y3hoQzNtQkp3MXpTTjhtL2d4NnozbWZzUGxlSkVIR1FpSlRGdWJZ?=
 =?utf-8?B?c2E1ZlJscVV4aVJxeGlkaDVTa1Q5WnRBU0NpVWpEeHJLclhKdUFDTCswVldT?=
 =?utf-8?B?UyszWEJUTnQ0Sk5zOTNmTllTRnNRaFBXUVo5eXVVK3JNSGQrc04xeXpPTjFO?=
 =?utf-8?B?b2tKbHlkdHBZMGhXOVBEL3dJVktLTnZXdXl2WW9WcXR3d2hEbXpBMlFpNlNP?=
 =?utf-8?B?bE8xVDVXR1pycEhjOURCYU8xU1hIV1FzUW92UTlyMVVOVEVKbndrcExYRjFE?=
 =?utf-8?B?T0xYUnZHVExpUlNvWjR6cmhCZC82RGxmZTJVemgxdlVrRkFPak9WT0ZlaDVo?=
 =?utf-8?B?N2dsbzRrbDUxU0tZT1doOUp6MnRaWkppcThlbmZkd3RQWFFLQndiaXdxdTIr?=
 =?utf-8?B?Nk8vRUdFd2VTT242OGFsSjVVK2d1Q3ZJU3BqU1pGYTJ1N3ZVRVpOaGpvSktn?=
 =?utf-8?B?U2Zselp6WHZsUFNxMzNJQmgzRmloUytYZU5OQVR2NmR0RVUxUkpFY0NQeVFX?=
 =?utf-8?B?YVNQbDI2SFovTUlBbnFpS3ptQ3pjUlh4dU9zSHBiWVlGSko4NDl2ZXpaaHNp?=
 =?utf-8?B?d0psYzMvL2J4b1BQVHFCaDRIcXJRN0IzNnBlUzRHbG1LK1Vobzk5SjlNaFRa?=
 =?utf-8?B?LzB4VFFUQWlIcWdLWnl6NVZxb3Jxb2dqWWhKdlA2Z2YvanZDem9BaFd4ZXdo?=
 =?utf-8?B?aVdUQTg2aTVTdDZzUktWazNWUXIrTVl3Z1Yra3RLZ3czWkpXM0x3cE1tbk9I?=
 =?utf-8?B?bTl6MmEyc0kxUXUvNm1ScjVpSDNEcWx4WlF0S0lRVkg5QWRBYVpUSWJBeERw?=
 =?utf-8?B?b1J4TjJ4MEJjQTBwTGlod1hrcWE0bzR6ZDRYTVRCWlg2OTY1ckdNT2NLaFdX?=
 =?utf-8?B?Ym1sdlhoWHNwL0NtVFlVa2FkY1RsaU83dXlTc3pXSXhIaTFNdUo5NXI1UitQ?=
 =?utf-8?B?TmFyQjRCKzFpS2lXbS9mVENKZ3VuY2NOSDRjSHJjWGgxcE5NVWhzcnU5VjJh?=
 =?utf-8?B?d0JndU9SRWhRRmdEaTNUMU9yQnBVQUNSVlpWSkc4SnFUbDZESE1sZ1MxR25H?=
 =?utf-8?B?dzVWU1RyWUxld01ONUg2em41VGJodlpvZERRL0hSbUQ5WkFoVjdVTnFiclJx?=
 =?utf-8?B?S3lFNGkwZDlYN29iRk8rYmVJSzZSMmUzeDZZRElHRWZuY1ZwcytOdXE2eHNT?=
 =?utf-8?B?T0F6R002cndlZGV2cHQ2OThPMUpxYVI0ditXUUF5RCtVQ0dia2lNOUdnOHk5?=
 =?utf-8?Q?9qteGMXaMGwOQAKHM8vVaCYnYxC9sHpydCFEA=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR12MB9265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eW1UcjVEQWMrVWtwS3hGdko0K0pmTXhZQlhoMjdSRmhORUtvUldpeDlqbWZS?=
 =?utf-8?B?MElXU21hVzE3UllEcmx1Y21OZGUxYjgzSFQ0TFVWU0RrZVh2VkhxRU0wemJU?=
 =?utf-8?B?cXRnbFNiVUM3K3I3cmdWSjljV2hBUXRrK043WmJyQ0VOeENmV210R3VRVG1n?=
 =?utf-8?B?UjQxSmdhZHNRRlFMK3NTV0ZISEJQZXRQRG9tZVluZWhZQnJYbDRpZ3JUYlJm?=
 =?utf-8?B?NUlUN1ROYVM3VysyaEdUZW1HdWRxTzk3cmxKeDhUOFNTUHkxb200OTZZSmND?=
 =?utf-8?B?WktXSFB5UWZNdU1MaGxtTFhDbm9xNExWR0JKeG5zUHlYVWRQZTlkZmg3WVBW?=
 =?utf-8?B?eEkyYlZiUVlvaVRCUXlydmUrcjZkYVZOdW5SQ05wSUwvSGZGU1EyS3g0ajZ3?=
 =?utf-8?B?bEtTdWpkU2FTckhPNFMwS2JNd0dGaW5TTFM2UlV3WVJZMVFQUUs0dXlzVnFJ?=
 =?utf-8?B?eXhEOEJTSGNCZC9scW1pOEdVaEZyOGxyUzFrZjhzdy9HdlhBWmdZM0kxTkw3?=
 =?utf-8?B?VDJkamx1RGIxMDdiZzZ3SlBaTS9mYUYvUkdxbU5mcS9UQVAzbDc3TmYwaUc4?=
 =?utf-8?B?REMydlRYei96QUhtLzJac0ZSTlpVck4xVFpVVmxCSjBiQ2NXU1NpVXY2U3or?=
 =?utf-8?B?TEVYRHVkcGtMVk1RcFpnbGJNcWtZM0g3cXlsZlI5VVFtWFNRTEpKNisreDh6?=
 =?utf-8?B?Q3p6bU5NMjIzeUFlcVE1OFYvL01WVU9iUjVvRlQrSmpSQWJjMDZCLzBUSmh6?=
 =?utf-8?B?MmRaenNFN3J5a245elplN2l4ZUZaaEN6V3BoZVlsYVpBYlVSa1ZOdlNtSGJ0?=
 =?utf-8?B?dU1vSTNsOVVpcjdGblJHQmFscjJKcElWN1Rqbk9qMkcyMElTREYveGpKUmFn?=
 =?utf-8?B?WVU3Z1JBSWdoZjF1SnNEeWtRRmRzU3NVZG1ET1dHcnAxMCt3S3lORjhWZURi?=
 =?utf-8?B?WmIxdDJ5NTUySUtkTFBSWldGbmpPTmJzNlZycElodnlZd3htdHZlYTJZaVNQ?=
 =?utf-8?B?T2R6MEhJOS9FS1ZBMWVMQUQzRHdzRmNwMkE5UUFjZ3F1UTRhZ2U2cVVtVUhR?=
 =?utf-8?B?eHp6cWtPWW1XSGtJcU5NSjFnWkh4YmhIT2dmbUZaMmdsejlPOVFjVmQzYllC?=
 =?utf-8?B?MzJTUUhnNDZXalk5SXczSjkvOHBHY2dERk5WeElTZUh5MTQrcDc2ZThjYnlk?=
 =?utf-8?B?cG4vMEhlZmR0VEdTVDNWVkg4dUZYMGVuZTZoRmlwY0lLTEtCb09ORnREYUZk?=
 =?utf-8?B?SW9vZytMTzlwQ3BTTmlWelhIRUVwUExVckJmTEFobms0YWJXY0l2ZUMrbld5?=
 =?utf-8?B?VThVTzdrZ1Yzc294SDhBRWRraTF2a2haeGRBZlM3dHFIem9mWlNReFhadW01?=
 =?utf-8?B?UnpobEVGWE9ZTDN1bEZUUkR1UjNVeno2NUxaUkhtSzE3NkZJK2xvM09ySFRG?=
 =?utf-8?B?K2FvZTdjSmdjcUJQRlFkSEhJcUx6TzN4Z3ZyOC9rMDI2cHRLVjBJUGlkREdM?=
 =?utf-8?B?bk1zTEgyd0RCSExxK1kzNVZNMFAwWllaN2xjNjRldk1TellXVVRrVWQvM1dX?=
 =?utf-8?B?ZHNWd1BJUjErcTdEdGdJYTRJT2JZS3FFeFhuZHhhRGhrTjduejdjVGp0Qm5H?=
 =?utf-8?B?L1dmb25ndFh4NjVuREg5WmFrZzRRYjVkY1Y3UVNlWWdmTDVnZVdGQjFGNFVI?=
 =?utf-8?B?UXZlVXVkSWVaQ20xUnpTc2NXR2RPa1orNFBDT1hlRkxldVUxdktpcjJGN3hy?=
 =?utf-8?B?Q3NrL20vaFVoVi9SVUtSR1lZUm1zN2U0ZlpKN1F6VW4wUjl4ODRia3NGVThn?=
 =?utf-8?B?TjBmYzVPaTF5bXovRWMvQ2c2YXlhOURwb044bzIrYXlEMUZ4aFN1R0RaSjRt?=
 =?utf-8?B?eHZ3bDlzbnhHWG9WcVhkU3hNMWc4dzdXdjRxejRiUnBINDNQcXRQcmZTSk5G?=
 =?utf-8?B?NVczMnFBT1AyVGNMOFRCTjZxN3AzM1N3R0NuREhoMVI1QjJybFNBeTRnL0cw?=
 =?utf-8?B?Wjk5Vlg4QzFQdUVCQXpkQ2syOWV1aE5PY09HVU15dFh5ZmE5bG1LVEtkRHEx?=
 =?utf-8?B?eC9zVUV5clU2U2w0QTR5R0pkUWllc2lZSEdqWFVadGpnNnVOUmdORjBjMm40?=
 =?utf-8?Q?7fyg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV3PR12MB9265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd0ef6d3-8c74-4b22-1a15-08dd0583f896
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2024 14:44:12.5648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NL1N0b+vHpw+cQqKkl5slHFtPRNwsxBSfIkLfSEfReTFK/IC8Ewu0gmSwhFXDNl8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEFNRCBJbnRlcm5hbCBEaXN0cmlidXRpb24gT25seV0N
Cg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb3NoIFBvaW1ib2V1ZiA8
anBvaW1ib2VAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIE5vdmVtYmVyIDE0LCAyMDI0
IDExOjQ5IFBNDQo+IFRvOiBQYXdhbiBHdXB0YSA8cGF3YW4ua3VtYXIuZ3VwdGFAbGludXguaW50
ZWwuY29tPg0KPiBDYzogQW5kcmV3IENvb3BlciA8YW5kcmV3LmNvb3BlcjNAY2l0cml4LmNvbT47
IEFtaXQgU2hhaA0KPiA8YW1pdEBrZXJuZWwub3JnPjsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZzsga3ZtQHZnZXIua2VybmVsLm9yZzsNCj4geDg2QGtlcm5lbC5vcmc7IGxpbnV4LWRvY0B2
Z2VyLmtlcm5lbC5vcmc7IFNoYWgsIEFtaXQNCj4gPEFtaXQuU2hhaEBhbWQuY29tPjsgTGVuZGFj
a3ksIFRob21hcyA8VGhvbWFzLkxlbmRhY2t5QGFtZC5jb20+Ow0KPiBicEBhbGllbjguZGU7IHRn
bHhAbGludXRyb25peC5kZTsgcGV0ZXJ6QGluZnJhZGVhZC5vcmc7IGNvcmJldEBsd24ubmV0Ow0K
PiBtaW5nb0ByZWRoYXQuY29tOyBkYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb207IGhwYUB6eXRv
ci5jb207DQo+IHNlYW5qY0Bnb29nbGUuY29tOyBwYm9uemluaUByZWRoYXQuY29tOw0KPiBkYW5p
ZWwuc25lZGRvbkBsaW51eC5pbnRlbC5jb207IGthaS5odWFuZ0BpbnRlbC5jb207IERhczEsIFNh
bmRpcGFuDQo+IDxTYW5kaXBhbi5EYXNAYW1kLmNvbT47IGJvcmlzLm9zdHJvdnNreUBvcmFjbGUu
Y29tOyBNb2dlciwgQmFidQ0KPiA8QmFidS5Nb2dlckBhbWQuY29tPjsgS2FwbGFuLCBEYXZpZCA8
RGF2aWQuS2FwbGFuQGFtZC5jb20+Ow0KPiBkd213QGFtYXpvbi5jby51aw0KPiBTdWJqZWN0OiBS
ZTogW1JGQyBQQVRDSCB2MiAxLzNdIHg4NjogY3B1L2J1Z3M6IHVwZGF0ZSBTcGVjdHJlUlNCIGNv
bW1lbnRzDQo+IGZvciBBTUQNCj4NCj4gQ2F1dGlvbjogVGhpcyBtZXNzYWdlIG9yaWdpbmF0ZWQg
ZnJvbSBhbiBFeHRlcm5hbCBTb3VyY2UuIFVzZSBwcm9wZXINCj4gY2F1dGlvbiB3aGVuIG9wZW5p
bmcgYXR0YWNobWVudHMsIGNsaWNraW5nIGxpbmtzLCBvciByZXNwb25kaW5nLg0KPg0KPg0KPiBP
biBUaHUsIE5vdiAxNCwgMjAyNCBhdCAxMjowMToxNkFNIC0wODAwLCBQYXdhbiBHdXB0YSB3cm90
ZToNCj4gPiA+IEZvciBQQlJTQiwgSSBndWVzcyB3ZSBkb24ndCBuZWVkIHRvIHdvcnJ5IGFib3V0
IHRoYXQgc2luY2UgdGhlcmUNCj4gPiA+IHdvdWxkIGJlIGF0IGxlYXN0IG9uZSBrZXJuZWwgQ0FM
TCBiZWZvcmUgY29udGV4dCBzd2l0Y2guDQo+ID4NCj4gPiBSaWdodC4gU28gdGhlIGNhc2Ugd2hl
cmUgd2UgbmVlZCBSU0IgZmlsbGluZyBhdCBjb250ZXh0IHN3aXRjaCBpcw0KPiA+IHJldHBvbGlu
ZStDRFQgbWl0aWdhdGlvbi4NCj4NCj4gQWNjb3JkaW5nIHRvIHRoZSBkb2NzLCBjbGFzc2ljIElC
UlMgYWxzbyBuZWVkcyBSU0IgZmlsbGluZyBhdCBjb250ZXh0IHN3aXRjaCB0bw0KPiBwcm90ZWN0
IGFnYWluc3QgY29ycnVwdCBSU0IgZW50cmllcyAoYXMgb3Bwb3NlZCB0byBSU0IgdW5kZXJmbG93
KS4NCg0KV2hpY2ggZG9jcyBhcmUgdGhhdD8gIENsYXNzaWMgSUJSUyBkb2Vzbid0IGRvIGFueXRo
aW5nIHdpdGggcmV0dXJucyAoYXQgbGVhc3Qgb24gQU1EKS4gIFRoZSBBTUQgZG9jcyBzYXkgdGhh
dCBpZiB5b3Ugd2FudCB0byBwcmV2ZW50IGVhcmxpZXIgaW5zdHJ1Y3Rpb25zIGZyb20gaW5mbHVl
bmNpbmcgbGF0ZXIgUkVUcywgeW91IG5lZWQgdG8gZG8gdGhlIDMyIENBTEwgc2VxdWVuY2UuICBC
dXQgSSdtIG5vdCBzdXJlIHdoYXQgY29ycnVwdCBSU0IgZW50cmllcyBtZWFuIGhlcmUsIGFuZCBo
b3cgaXQgcmVsYXRlcyB0byBJQlJTPw0KDQotLURhdmlkIEthcGxhbg0K

