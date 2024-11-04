Return-Path: <kvm+bounces-30465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9699BAEE7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:00:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68E222816F8
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED981ADFFD;
	Mon,  4 Nov 2024 08:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FdXRfLET"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E94D1AC88A;
	Mon,  4 Nov 2024 08:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730710725; cv=fail; b=fJd2vdQn4u47fjrccOCDDriolEiA+VzNBRPO/gtDKiXnIfle6gcNIdqNkZEG2VyCmz4ygJ0theAxeKWYsH0PElTZiFyPphoTzkyPaV4/fSGQUKQOM5Uv6TwpQALsKjy/0MrIW+cUh/Y8zlrNi8k0eByDP+aqABqctPEG9etNFHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730710725; c=relaxed/simple;
	bh=0AZ9QfNoPamJrkFzrUxjn2X2D00PR3UXhMT+8CcnC4o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TonwPV2fLAuT8EtSQdzPMPJnlq9CJk38D8FTsAicx5K6CVafvFwqnamp7DRNRW6mbJHJMg17Sfwf5dLoPxCF3dBP6EUi788d+6pOe9aMXuLrrXJUizqrSVUF0ztPsM8oj6/9OJS/47stH9Uimt0ohKESxGBAmbywe9WQ/o9LRmU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FdXRfLET; arc=fail smtp.client-ip=40.107.220.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NKOLu/TPT6cMz+BKZhWgROPtIfK9E3YNDD27B8d6tWVZgonhACGgdr9+kUzjwpfGCuKSmWkY7AXyyguE8ocwGlNZ7/p7LOWsDAU5hgzgU1viAGozPaGi86XSZ2zE/X/xH26IlGiYMCGLa92P3/9mcmZ/KM28rfEArQmdagSDAX/Ko2XF/SwJE8x7G6twTfM4PFTKkYukwB8o1WdKzX1an6TmEo4lr6ARvCPGDC2b8uuCfizV0mUiFrbMfwyzE3FdIpoLl12xyZQlqIAEzZ0+pJe6Ym8k/vcVLKsPMMRm5iKBDdAKDPTeWzDOphzId7cI/ZU04rnAcrIkh5RcZ1bIbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0AZ9QfNoPamJrkFzrUxjn2X2D00PR3UXhMT+8CcnC4o=;
 b=g/okN7DdFEtGKQYgMvAvJzB8Vgqwxj+yZN8YZb4IqVW0rC0jkl4wGheQTWOw/fBVi8h3wSQtZdLuoLhwLRL1SJOpW73mJLbNWXfV8wJ6MfJdyNracIwW50MORrwSp0iwNvOzus0DtBr4kUQWLTVpo/wTXnOB4V/b2CJ9FOmudq9LhGbtoEWJ9axq9jZJH0zwOiljmJjUGAGWuT7rkgUp9VqRQT8p1MbofQgj+zDYOqNemal5CuZWV2AsQ1ilcTBtX6LobASqRIASKOvxsxJjVn3dSWwoW46iFzstP2h1qGCDjNCLq/iRbJmXkPjlwaqBvMHoyx3HoU5NPOVNs1YrVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0AZ9QfNoPamJrkFzrUxjn2X2D00PR3UXhMT+8CcnC4o=;
 b=FdXRfLET57WKKCyo02trR4khqNx4BUq/pAL2kHZjGHlHxmLa9HzHISgWWv7AflhAQE74+blVHyyJd6hs1nRM4FHRCh5EQ92/koeTs3+zExiYCsEYPlPIVWtYA9tZRnWRfxwqxTVFfdzVhQiORUGQ535GdVOqb6jtejMql8gMGPU=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by MN0PR12MB6032.namprd12.prod.outlook.com (2603:10b6:208:3cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 08:58:41 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%7]) with mapi id 15.20.8114.023; Mon, 4 Nov 2024
 08:58:41 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dave.hansen@intel.com"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "kai.huang@intel.com" <kai.huang@intel.com>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"jpoimboe@kernel.org" <jpoimboe@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "Lendacky, Thomas"
	<Thomas.Lendacky@amd.com>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "Kaplan, David"
	<David.Kaplan@amd.com>
Subject: Re: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Topic: [PATCH 1/2] x86: cpu/bugs: add support for AMD ERAPS feature
Thread-Index: AQHbK6w5P1k2kYbMrUGkcWui1gHZ+rKhfTCAgAVa8wA=
Date: Mon, 4 Nov 2024 08:58:41 +0000
Message-ID: <4b23d73d450d284bbefc4f23d8a7f0798517e24e.camel@amd.com>
References: <20241031153925.36216-1-amit@kernel.org>
	 <20241031153925.36216-2-amit@kernel.org>
	 <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
In-Reply-To: <05c12dec-3f39-4811-8e15-82cfd229b66a@intel.com>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|MN0PR12MB6032:EE_
x-ms-office365-filtering-correlation-id: e2e28033-bcb8-4b60-a576-08dcfcaee185
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Y1VFanFjTkNoSzNuUWhoRUNhM3BIODlGYmorQ1N6Vjd6VC8wZjcybFVoTmRT?=
 =?utf-8?B?N0lTaEZOK0RtTUp6RS9ZVG14UnZNVFhzYm16M1NDRHRtazRCSGhORHdCTHFs?=
 =?utf-8?B?UHUzTUNSMGNrQVpUSytzU3lxbHlSdDdxRHprUEpRNXpKWHp3VlRibnZ6UEQ4?=
 =?utf-8?B?U3BvdG9OcDdlOFJNbVM4TWZuTGpjTjhwc0VUeDNwaklURW5ucFAwcEkzWUFT?=
 =?utf-8?B?a3luNksydzNnOVZVKzZQTWxIc3VRWmJSZGkrSk81aW1TVW52SnVLTUplNkFS?=
 =?utf-8?B?eVpiN3Z4K29oVk1hOFhvZUUzOWZXRW9RRkxhNm80VExMSlJDVk5FTmxZZXlG?=
 =?utf-8?B?MkRzbEZUb2QvNlJaYUVoZk9QQ2xQc2ZqdFlGVFEvb2Z3eHlxcnkvcFBqSWcx?=
 =?utf-8?B?YmIxdDdnV2VYSTZkOWE4TkVIUjdpdVhqSXMvdTNLNDVTa3NVZzVyUXRCNDIv?=
 =?utf-8?B?UFdFUHBpUlZQSlBjWk1wODVXRUNxUWhoYklhSzAraEpBcDNlaGd3bmNIZzlX?=
 =?utf-8?B?MzVCbGRhVmtCMDNNSXlwdDQvR3FMQm5CKytGbkEyMmxZdGM1clo3aXFyZ1ht?=
 =?utf-8?B?aTZSVDVaNkROa2lBK0VLRlcrcHA2N3l4eGdKcmU1d0JiY1lvRHY4N3JyT2xG?=
 =?utf-8?B?a2Nnek03bXNXdktDRGRoNU9CUGxEcklCNFI0M0F4WlljTVpPVDBqdG1zem9B?=
 =?utf-8?B?U0JwMEtGVXlDa2pxbHVoVVFSazNvbFpTZ2xMVXZTMTM1T1hUNFdBU2hFaFVG?=
 =?utf-8?B?MHY2Z3ZGV050Q2tLRnFHY1RHMEo2MEcrY3ZnWlJ4NjlGQnZDTm9CcXZIQ0p5?=
 =?utf-8?B?QkNKWUlwdjhBQUZCTkhWOFBabXEwcjdzTnpySUFkYm9wNWlQQWNHc01HMDF1?=
 =?utf-8?B?VGdIbTlLR3JVZDFjQVIzSGRBZlVKVnRDSEtNa2pWRGJyaVVDTGh1YTF1TnJO?=
 =?utf-8?B?SmIvdXZlejdXUkhlYTlsS2NRR2JiMW1HZ0lLbmk2SFpSRDIzVFZXSEtYWld6?=
 =?utf-8?B?ZGRmSCsydENERkcrc1J2OGZieDFNK1F6bzNqOHpwK1A3akFpQ2ZWZHJzNUpL?=
 =?utf-8?B?Yko1QWNIcE5ILzdqamRjVU00N1pEYUZoM0NqYUdzZW0yUFEzUXJKTmF6aDZU?=
 =?utf-8?B?K29YdjZqRDFzRUNXMzgzakhtY3Vxd0VkV3ljMHVPME1XUDVFNzlWK09DOU1P?=
 =?utf-8?B?cmZmeVRSNnlwREM2S0JWODIvMHNmbkIwclJHRWNPL3FPVkJOanJYejlYUnlP?=
 =?utf-8?B?MktxZmJFd3J1RjZETFkvVUthVjBiNUJJRTArL1hoNXFmRHpPaUw2WFFXNkdT?=
 =?utf-8?B?WkNyMllIZm5YNHhaYkxiMlU3TWhlQkcydnBQUzRRNDd4bGwzcmp3QTFVbitD?=
 =?utf-8?B?RDVBSk0vZVRLaEo4cDNyRHdqZzZQK2s0WnhZR3o1MHovUGdaNzZFMXV4WWZV?=
 =?utf-8?B?WVpxWk9IRUZ5TVhlVmZtNmEwazZEcXgwQjRRcWpqUFZPV0NQeTMrQXJvMTNm?=
 =?utf-8?B?aGJVNXpVUGNUTU1zNzFvVVZBaUVsdkVYTUxJL2J6YitqOXhDdnlyNCtqcTRy?=
 =?utf-8?B?dmxXL0RWTkZxcCt6RWJWNGwwa0wzODFwYTBpTXZvT2pDVElBM0NxSFVXc3M4?=
 =?utf-8?B?UkxwbTlDVUJ1RVM2ckRWb0c0VXhlcXZ6YjBHWlJYd01OUFdrdHkyaVZ6UHhr?=
 =?utf-8?B?SUU5K29VQWpnVFEvRnozL0ZPVmJWQVJzek54bFhuOHlwckJXZ1NRZzg2ckFX?=
 =?utf-8?B?NEk3SXhRZmZIaGUyL1dTb0ZNZE1FVFRCN3ZNcTFMUzBmUXhiSnFnM0pTRjlr?=
 =?utf-8?Q?RArZkgqmdkcalpKXkU9GDKQY8wpZrZqg0itbM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QlVCUytCM3M4RkR3dmc0eFg5clBodi8raWw5bUlqU1d2b1pUUE9vNDJQNDI2?=
 =?utf-8?B?b1VQZERZemk2NDNSK1o4bXhPcFUrRFo3TmpiT1pOQllBVGZacUx3L2RqS09w?=
 =?utf-8?B?c1lsTnB3ZnhEU3U5K1BKS0dML1ZWZ1lTMldWNmluYXlMWkZLaE91Nk53N2J5?=
 =?utf-8?B?d1pOMHhkeCtxcjF1VWhTeUxyQmdKbUlqQTlKRlpDZ2tkRUFuUE1SQ1BSclhX?=
 =?utf-8?B?ZkdXS2syK0lmQkgzYlBFK3d4NklNYXQ2cGJmakFaczNQcFJDZHRtcW9kcFFU?=
 =?utf-8?B?T0dvbTYvVFJXSTY1NXFLZzJjY0RqY1BVREtvRWdPQlcrRGZML2QwellGQWUw?=
 =?utf-8?B?eitjRW5WRk13bmNXT3ZoQU1QRGlYV2h0OXpSNzY0dVdLZmVQbU0vWDhsWEF6?=
 =?utf-8?B?cGozZC8rWXhYSWFkU1M3TG9UQ2x3U05BMFg4ZkphRUFTeGtueHJRckVFSS9U?=
 =?utf-8?B?YUV3eG9TdEpxLzVvbTBOblhkU08zYlVHQ1g0bzVjVGpKOEdXekhKUXdHaGZp?=
 =?utf-8?B?WWtFVHZ4SytZbGxJWlBhTFVDeTM5S2dRNVFYS3Myd082eFpmdElsK2tuUDhW?=
 =?utf-8?B?Uk1Ra2pPOGhEbVdkN0J3SFQ2OTFSMnpwQ1RjOHVGM0xIeTc2TlV3WTA5TTBy?=
 =?utf-8?B?Z2NIQXk2TER5c1dpSHFEaW84WEoxTEhGWjA2Z05ZaTdOMmEwVjFEdFF3Umpm?=
 =?utf-8?B?YVVYTVgzQmMvcFR6N256VUtxdUlHS0treXhtWG5YaEtXNHFEWlFsOXlCck1W?=
 =?utf-8?B?Wk14dVozS0lTQ3RvTW9yeFN1YWgvdHl6WXNnbmh6eUkwUUxvMWpuSEloZUZN?=
 =?utf-8?B?R2RNU2pXZ1RDdFkvNEU4SXRvQngvN1daQisyZU4vblBRSjZibDVjcnNOcmda?=
 =?utf-8?B?NVk2NHZuR2hEa3Y3VDVaZm1lQ2tBMjhES2ttWGlsM1dDRFRWOHJHZHZqZVBL?=
 =?utf-8?B?NUZmdkJQTU9CTTFiNkxLUU1FL0NZcEJBSnUyMUt3QmNKNUFwTkJXY3lBQlBN?=
 =?utf-8?B?M2x2d0pMV2xkVTFNVU54VEdpUTlneStHbEF4V3FXNi9XTW9xY0hCUmk0Mkc5?=
 =?utf-8?B?ZnRmbEtyREdWYTNjUnkwQkdpL0xTVnZocnl2RjJlVklVNUgzeUpTakFVV2l6?=
 =?utf-8?B?eFVDRTk0ak9SVVpBV2FWYytCSGdVcGxMN2J5Qi9DNUkxNENKV1o4SGpONVBU?=
 =?utf-8?B?KzdsUmphVVJ1TUxNNXRSb2M2dS9yaHpXVzZSQlZKNVZqZUZYREcvVGZYdU9I?=
 =?utf-8?B?RkQ1dVRxWFZacGVtQk4yT3hnWkYrdUhpQVZGOEw2Qy9CRWNOMjhYcGJ4Qk1W?=
 =?utf-8?B?aTl2LzlEUTFMVjdiZ3pnYzVEc3gvaWY5Y3k1U0xENGp0Q3pVdm1SSmF6OTdT?=
 =?utf-8?B?ZGhQVGJlK2VNblM0UEJJUjJkWm5Pd00wbGk1eCtVOWFQVGtNdG80L21IajBN?=
 =?utf-8?B?WGsybkFzajVpeUloM21VbzNBLzBsaTQzb2FhbEM4bnVyOW1mWWN6LzQ4eTNq?=
 =?utf-8?B?dDE3QnAwRGIxZHhFMkdLbllWR2dnOHk0MDRrUWRBZFozbS9wMElNWXhFTGQ4?=
 =?utf-8?B?RElYd3ZEbzNHZ2tMVFd6N3VYYXF1MFE2WjBaMW1MUStjazlIeVJJZWViZFVp?=
 =?utf-8?B?MXdDOU11cFZZR0szUmwyV0ZoWG9sVVZZOHlCVjI2R21JVGNvYkV2ZTI5Qm5E?=
 =?utf-8?B?SkFSd0V0UXFuR3VaVW1NclducERzQjdyYVBPYjdROXpsWEx5cXlHcm80TUpN?=
 =?utf-8?B?SjFXN2JJbEpkY0N4UURzRGJWcXdrbGw0QlVFWGg1ZHoxSDB0WXU3MGl2aEJN?=
 =?utf-8?B?S3BnU2xFcnVQZk91Q1BUWDZqMXpmemhCL1NNeUJYK0k1ZUwvMDNZbHJJQUhS?=
 =?utf-8?B?N3hVdTlWSndrN2RORk9NVWNDeHBKanhLU3ZXallGME1tWVFqcTZIdkorS0hT?=
 =?utf-8?B?SHNZdmxuNnpMV2RHUmVLRTh0TnB1TDZxeEY1dnJVV3lpS3U1bEpmTjkyN1NP?=
 =?utf-8?B?Ny9WSHR6TkZmVjFHWWJjeHcvV0xaL1VwR0RvaGlnN1Ewek1CRTM2WUJKYzlw?=
 =?utf-8?B?cWlndGJvUEdpWjQwMFQxdzhsWXg1MEo0ZkwyVGQ1TDBkb25DUWVWWGlIM0Qz?=
 =?utf-8?Q?uvi35vULMW8OG2c8TAKgYvumK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <454176EAADF3E6458779849FE8178056@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e28033-bcb8-4b60-a576-08dcfcaee185
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2024 08:58:41.7451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C0DGEz7GV9RLYXgnk/GfCuGpFsjEBL4OaTJqRaxbdi5bmV/ri91Blr/W1lN0ocRS4PETm6tx76JfYTyvUfBDGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6032

T24gVGh1LCAyMDI0LTEwLTMxIGF0IDE2OjExIC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMzEvMjQgMDg6MzksIEFtaXQgU2hhaCB3cm90ZToNCj4gLi4uDQo+ID4gV2l0aCB0aGUg
RW5oYW5jZWQgUmV0dXJuIEFkZHJlc3MgUHJlZGljdGlvbiBTZWN1cml0eSBmZWF0dXJlLMKgIGFu
eQ0KPiA+IGhhcmR3YXJlIFRMQiBmbHVzaCByZXN1bHRzIGluIGZsdXNoaW5nIG9mIHRoZSBSU0Ig
KGFrYSBSQVAgaW4gQU1EDQo+ID4gc3BlYykuDQo+ID4gVGhpcyBndWFyYW50ZWVzIGFuIFJTQiBm
bHVzaCBhY3Jvc3MgY29udGV4dCBzd2l0Y2hlcy4gDQo+IA0KPiBDaGVjayBvdXQgdGhlIEFQTSwg
dm9sdW1lIDI6ICI1LjUuMSBQcm9jZXNzIENvbnRleHQgSWRlbnRpZmllciINCj4gDQo+IAkuLi4g
d2hlbiBzeXN0ZW0gc29mdHdhcmUgc3dpdGNoZXMgYWRkcmVzcyBzcGFjZXMgKGJ5IHdyaXRpbmcN
Cj4gLi4uDQo+IAlDUjNbNjI6MTJdKSwgdGhlIHByb2Nlc3NvciBtYXkgdXNlIFRMQiBtYXBwaW5n
cyBwcmV2aW91c2x5DQo+IAlzdG9yZWQgZm9yIHRoYXQgYWRkcmVzcyBzcGFjZSBhbmQgUENJRCwg
cHJvdmlkaW5nIHRoYXQgYml0DQo+IDYzIG9mDQo+IAl0aGUgc291cmNlIG9wZXJhbmQgaXMgc2V0
IHRvIDEuDQo+IA0KPiB0bDtkcjogUENJRHMgbWVhbiB5b3UgZG9uJ3QgbmVjZXNzYXJpbHkgZmx1
c2ggdGhlIFRMQiBvbiBjb250ZXh0DQo+IHN3aXRjaGVzLg0KDQpSaWdodCAtIHRoYW5rcywgSSds
bCBoYXZlIHRvIHJld29yZCB0aGF0IHRvIHNheSB0aGUgUlNCIGlzIGZsdXNoZWQNCmFsb25nIHdp
dGggdGhlIFRMQiAtIHNvIGFueSBhY3Rpb24gdGhhdCBjYXVzZXMgdGhlIFRMQiB0byBiZSBmbHVz
aGVkDQp3aWxsIGFsc28gY2F1c2UgdGhlIFJTQiB0byBiZSBmbHVzaGVkLg0K

