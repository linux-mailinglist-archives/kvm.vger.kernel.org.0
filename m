Return-Path: <kvm+bounces-15579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 413D58AD780
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 00:47:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5346B23617
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 22:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 976E328DCB;
	Mon, 22 Apr 2024 22:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="acmwrzly"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112B91F922;
	Mon, 22 Apr 2024 22:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713826044; cv=fail; b=giuY0ZzdT3tGo4qQ0PQhonesPYvwJ5CZlNEl3dlBgPKeN52y5GhyNsiSzVwJ28vDJXjABejymThH1BZ/zX9zV3Kp4c8QCJp86NGDjnaRjIG0kOZXcHYrqN91tEeOwmQS+r627eCJF+JTGQFQuisj1JOoyEIRCZCoI+T1BGYXr1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713826044; c=relaxed/simple;
	bh=f34KmX1ZoNBAi/qqA8nnkTeto+PWmKWgggKMCo6w11A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j5JhcJKZGF+1ycJItDpIaMj7uymbQHPhK5FPMKSg9XmLXA8YR5KUwAYWGNDVACEJ7A0USrKBQO/9/9FLD3SAPSOtfMOQdqi7CBiu1v3bq7sPy5OisOnQaSJPqgPgHGPafyJt4ydPRu5JNS4KfBsLeysRitOcKl9y8vdZXpbQa44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=acmwrzly; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713826043; x=1745362043;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f34KmX1ZoNBAi/qqA8nnkTeto+PWmKWgggKMCo6w11A=;
  b=acmwrzlySH/kivXpJZvqljdbekJ8CSZhYxctaXtxmI8QvBjLrtIyacop
   1FREXDpHp2rLtaNUJmNfCL457P2o0r8yWyrRG8fuZzNa8iF2RTbbOgXMs
   3XzBRlV7M8qWWRNHfDj3incwloNrVh56JvRiWBg/j46CHPCgmmOLS6DGL
   8krYb5A3Lg6sKh0JQh+6+t8o77PV2InH78xrTLg8vKErL/BDR20obT9If
   i+ElTmWovV0Pqhiu6LX30oDHlv6pN1H6qyl45v5qhIihWjUpu3LetqNVx
   sR0Nr5Q3LSshZrWh5NZDb1DO+8hgdbIlE615/QchU7olA0YRWvxNxC1Bo
   g==;
X-CSE-ConnectionGUID: CuToOEHtTaWMWFPRN0qgQg==
X-CSE-MsgGUID: CJjo8FRIRxyR/Z/1e81jYQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9559695"
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="9559695"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 15:47:11 -0700
X-CSE-ConnectionGUID: AV0LQ3VNSn+Pzz2WCCwLYQ==
X-CSE-MsgGUID: Fho42hngRZ+ytkEfxbZwbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,221,1708416000"; 
   d="scan'208";a="28828796"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 15:47:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 15:47:09 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 15:47:09 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 15:47:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e6A72arRyTZH5yH7Qa2WPuo8oc/eqpmWHieC3UHgc0g5k2fucOb7TQbCGXDJOm6WbhlQO8Zd79rqIf1zItcLFctjCZjZPvqHuxtky7qpbLw4YTAU0VDsby5psxp11M4b9pBntxvbJiD97mV1DIa7KqfkAAdMk0nB4d4hA4ZTpcuLH06s74/4u5NZZxnP4f1jWEP0PogiNNVtPmhm2ZxcRN5EY2cCdVfpEOgF/y+6v+eRjRcoFNdABcTq1sZNIAw+tBF+9vJap4rMZ2T0Cspce4zhoekg+SObk2UUxvVNLSvFW8Y3gCkprUpzrt2fPCngKcBjcLXMANxnsUnOoOcQ3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f34KmX1ZoNBAi/qqA8nnkTeto+PWmKWgggKMCo6w11A=;
 b=a8oPlqywPZdHnfIF4Ux3BNLl9rrqi6IGrD+O5G+Qz+FXWb8cxLJRxMdiUCfYug7vQzWrxQ0lTIEvbdTb1zm9CAicU2VJJ/t/1WGoveuej9e4r4eX4NyBtR5wC1H+/9EyiH/SL2pbz7i1vhixlunF11Ps36D+FDBlAcGSZjVRdjR0uHjqW3fDOUzyjGZckPAOfKkn3bRr3Ntm+OgqLoAZIOUmyC+xvxrGY3pcBZS+tsMGIma2Z2KNhpC4g0GVF2LxXg3EuRClOgrAt1q4OPsORYk/5GZJJQ4G8OHY9KVIZ789iXDAQSf1RlBGPzZcduxFzhij85ikufT4VAO14AiPqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6478.namprd11.prod.outlook.com (2603:10b6:8:89::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.21; Mon, 22 Apr
 2024 22:47:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.018; Mon, 22 Apr 2024
 22:47:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQA
Date: Mon, 22 Apr 2024 22:47:05 +0000
Message-ID: <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
References: <Zh7KrSwJXu-odQpN@google.com>
	 <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
	 <Zh_exbWc90khzmYm@google.com>
	 <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
	 <ZiBc13qU6P3OBn7w@google.com>
	 <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
	 <ZiEulnEr4TiYQxsB@google.com>
	 <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
	 <ZiKoqMk-wZKdiar9@google.com>
	 <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
	 <ZiaWMpNm30DD1A-0@google.com>
In-Reply-To: <ZiaWMpNm30DD1A-0@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6478:EE_
x-ms-office365-filtering-correlation-id: 4e9db767-c5af-44ae-cc7f-08dc631e227b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?dE1vbGkyeHNhZDVxNkY3djJBUzdOaXkvL2xnV3ArdWc2cHZWVm5TY3plN0M2?=
 =?utf-8?B?Y2lIWEx4bmFXN2lsenRPK2ZKVlhSQkFaM0xhSm9ESWE3MTNFS3dhYlhOSWlY?=
 =?utf-8?B?V0d3UC9HOHU5ektydUtoQWNjQVo5N2h3anJXSURhVy9RdkJXcytLbml5clAx?=
 =?utf-8?B?ZTlKay9YdmZaNkY1dEFIRGVDUlg4cVgwcFZqQlZvU1FjWkt3R3VyZVduckpj?=
 =?utf-8?B?QXgrZXEvTENJMDNOOUVlazlvNXdQS2x6QmFiM3BkTmhQK1phbEpsUkFybDBS?=
 =?utf-8?B?ckltVVlMRmQyS2RQdHdiN3ZVL0xXTTR6eVRMN3VGK1FGdXgxQjdXZkdHVzdq?=
 =?utf-8?B?MHJSWlZkTkl2S056VmZ6Zll1VjhPazZnQ0hEWUdtcTNIdmlhanR3enZ6a2l0?=
 =?utf-8?B?cmF1WDdKd3NiUnQ1T1poc2FWOWh0Y2FyRTBMYzNOZ0JQVjcwdFNuc1BKeVo0?=
 =?utf-8?B?dS9qUllyL0xCelU5YWtlTlc4RVBwSFgwQWxTT2ZiN0xIeXdadXNETFdJbU5m?=
 =?utf-8?B?cW0rVmkrZ25sVHozblBxN0QvOGplUkpPQldwRVIxRVNITEZkb2M3QjZaT2th?=
 =?utf-8?B?aEFpcXU3Tkg0SFJwdWlRdUlDbzMwQmliT01JcUZJOElSbHRFYW1CdTV5eFhh?=
 =?utf-8?B?OUpBV1ViemswMjQ5ZVpYSDQ4MEFBc0FzamRkTXp6MXBIanJXNnQxbmtmL2I0?=
 =?utf-8?B?VVBsTWYxMllwNThwTy9GbUxSVFBid1BIYk5VTnVHaldZcEc2TVFBd2F6ZnRL?=
 =?utf-8?B?dmcvYUJNc3h6SStFL1FvQ0xSQkNJeXNQSS9XelZzY1huSko0N2ZjUEVOSGZQ?=
 =?utf-8?B?TWJha2wxeGlqSlVnQjUyeXg5OHB6WHc5MGFxMFI3RjAxMmd6dzBaQlNBZUJ0?=
 =?utf-8?B?bkZjWmRtSHIvSHI3cmRpMGYyeTk4NERCSTE3Um1lU2pYa0hLdWU3OW04d3BZ?=
 =?utf-8?B?TXJaWVExL0h5Y3hCcFAydGlGaGV2MGVQZStSWDBCYnU4bE9iZ210enIvMFdt?=
 =?utf-8?B?SjRhajFaNENKc3pxQ21GL0JLcVlJdjB2SnljSk14V2NDZkJ2TENzMjEyT29r?=
 =?utf-8?B?dEl2T280eUxzcTZJTGtzcThaRERYb0xtQit5OEZhR3ZKYUVOVW1HZlZDdVFN?=
 =?utf-8?B?RzVWeXNVOGZ0TzFKc0IzRzcyOGpJbUtKVWZLRGFKRGZxSGh1azF2MjFKUXpH?=
 =?utf-8?B?bDEwL2V0VUFCcmQ4L0gwQVJHYjVqOVBXNEo1OURuYlA1bkRQZzZvemF5a1B4?=
 =?utf-8?B?a0ZHRFJmY2dDRzQxY3JRaFVXTTIvS3VLaVdOUnRQeEJiR2VRSElTRXREalN2?=
 =?utf-8?B?K3M0bGhsQVZRd2FDb2hZRk1Xam14L21QQ2N2a2VyMkduL2pZM05JbmI2S2xI?=
 =?utf-8?B?SGZ6aTFsT1d6YndvVE9EK3hQdXNIcGF2SnVHdG5IOEZQZDB1M3FMcWkrNEll?=
 =?utf-8?B?WnpPb05UaU5SWjA3SFk5OHppMFRWWk9qZW9nVElJblp0MndrL0wrQ1kycm0r?=
 =?utf-8?B?Lzd4b1A3SWQ4RzFob0RGNlBVRDlZZWIvNmZ0SkZKNVhFZUdaYlM0anF1bjZM?=
 =?utf-8?B?WlRMUm1MUExOWjJQdzVWdEJzVUVhd25BRU41VXVxNTB2SFczSnJTM21DajRG?=
 =?utf-8?B?cWh6SUpXWWxUMUc3QzRSRkhFVFlkeUxSaE9CTkRoNUU3SU1XNzJZOGorOXMz?=
 =?utf-8?B?VVc0SElSS3RxeXo2VnJvcGJQRUNPUitXU2RUNUI3WUdyYlIrdFdFWmtqckZl?=
 =?utf-8?B?a01SNVdXTFhQbm9scUEwMitHSi90T20zUmxrMGxCcDBXRzJUaTB3YnZEOTRq?=
 =?utf-8?B?OWNvS1hTZzBRSUx1RjFJUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mm1EQml6Q2ZwczdLS3VhZ0k0QTRZNFJSVkcrd2tiYVB2TzVlYlNaaG1ENlRE?=
 =?utf-8?B?NHlHZjdBc3IrcVdmdVYrZjlXaVZEakpxSjJxYWNvbXdyNG5NUmJDb0c3SUNT?=
 =?utf-8?B?SHEwcW9MdTJIZldrY1pHVnJRM3MwM1ZlMVJQcmoyRTVwSXRsZWh6ajZDZUsz?=
 =?utf-8?B?bnQvV0RjUW9JY0Viazc4aEZkZVpzbXdTUHNCc1NFY2dYZ2YzelFKQjh1NFV2?=
 =?utf-8?B?aDdMTFZ2amJuRVRRWmZ0SnJRR2hxUW84aU1seDRjVm1sUnNzMkFvNGthUlkr?=
 =?utf-8?B?K2JaaGt2Q0x5Q2tMTC9WeGVSMjJuZ3lMelVPbUZIdytqQ1h6KzNOOFgrR2RR?=
 =?utf-8?B?QzRVZTV4QXAzMnQ5MzF3LzZlRGh1alFJa3p2c2k5UjRJekU1bUtVa3ZxK3Ns?=
 =?utf-8?B?MGxaOE1lUEtqUXZSVTdrZDhWbUk2SVQ2Vy94YS93UHBxYWkxend3YmNRbVFR?=
 =?utf-8?B?ZkNaK014ZEdyUEIwQ3VUYnIyY3FOTXNtWk9FbmgwL2ZNU2s1ejMwRTJCNFJz?=
 =?utf-8?B?ek1Bczh6TzJsc1hwSndxdmdpS1lCTTM2bmp5NTFKMmdzRFEyVjdvc3Y5THk1?=
 =?utf-8?B?cmF3TERyZHM4dTJFQUN2S0c4cytES0NmWGgrOGtRWjBISzdEdmtHUHZyeWY3?=
 =?utf-8?B?eDNwMGhiUUIrWW1RNVdOSkJ3NVZYbnV2T0JNOGVrM05NbktiTHFHWFVEYzFs?=
 =?utf-8?B?WmVFM3BHWFkvRFMvaGlMMUMyQzhkOTdYYW5ZMDhHUzBwT1JxQmdLT0hYV08r?=
 =?utf-8?B?d3FUa1R3bGRDeGVVZWZnLzJ4dW5HS0FuaXJXd1k3UGkyYWVxaWViOTFsUEc3?=
 =?utf-8?B?OVQ5WlcxclFvNU1UT3ZMQUluMkVTQm5peC9NakZGMU1iRE1Dck54RnJBNHEv?=
 =?utf-8?B?dTc4YkZQU09naGVqZkhxN3oyMlJTNHhpbmdMSHM2NDE3Z0xvOEtobnlndm9Z?=
 =?utf-8?B?OVZSRlprdk1xMDV3M3JEbFNMS3BTWFVNYTAxZWwybkFaM3NpMXd0dTRLRHJV?=
 =?utf-8?B?MXJ1YXExTzgrTVY0b3NCTDVWL3c3SklMVTMxSjZ4R1F3b2JjUkdBdnhXa1Zs?=
 =?utf-8?B?N1NCOXpkU1FsbzV3QkhNalcrczViRHUzWXhKOGl2QU1oamQrSWpPQkNtU2g5?=
 =?utf-8?B?K0o1ZW9iZ1pCeENYcVVQMGNpRWJlUnNoWXBGRkhRUUFGdXUvMkxiU3U5Rk5K?=
 =?utf-8?B?Vkd1b0k1c0puQlB0MFhZcXh4eHI1SmE0azE0UWVGOFdrR0JoMWJkZEZ5aDBH?=
 =?utf-8?B?QWw1ZVZsZlMvbEdZUkxTMTlGMzUweEZ1YkFwR2JTK01tbndtUVlRRlVma09U?=
 =?utf-8?B?dDA0WXVUc2cyOGQyOUVPZTh4S3M4RWwxYjRreDVjOW40U1JObHQrL2NrRFdm?=
 =?utf-8?B?NVg0eENTVGRJU1d1N3VIOHZGbmhnM1ZMTmc5cC9jdTBma3djMGNVbUlERGdV?=
 =?utf-8?B?dUpyK0E4OXRyeWl0cmxTSU9lc1gydnk2SG5hSkNCQ01CTHB4UnlaY0tidmht?=
 =?utf-8?B?Z212SDdiRFNpK09PVGV4SXFEVjFtTlVIOXl3Q0F6b0xxTlBPRFBRYzAya1p4?=
 =?utf-8?B?NGVpVWlRY1NpUjZEOEh1a0EwYkZ3eXAzS2Z6eVRZWUxub0V4eVVVR1pKVVRN?=
 =?utf-8?B?YWNaN2JyMEtjTytrQzdCTUxpUG5udVR0NEdqWFJRYjlDekc2TXVWTGVCNmNZ?=
 =?utf-8?B?b1UyMnJJRDRMUi96V2JudnI5TGZHblE0N3RLeWVsWmlHeXVTbWpmMjZuNGhB?=
 =?utf-8?B?YVhXQUZEUjlwakhvR2g3bHpOVHA2bmxmMGt4M25WVEs1a2d0eHc2ekNuOHlL?=
 =?utf-8?B?RVY3TmZ5ZVd4cEhvZDZ1WEpmZm4wbXcxcjJJaGxTMi9uaWk1MFF5dzkwcHhO?=
 =?utf-8?B?a2haZ3htcnBOVUNVNGFrVTBWeStaOW5EeVpVSTFlWGxPRFJvcmRWbHRIOTUz?=
 =?utf-8?B?T3lWQTgrNjZrb3RHekloZDVFVzhxLzgvZEQyekZvbXhnM1pVZjI0WmRPOUVC?=
 =?utf-8?B?TDJWM256RzRPWVlvd2RweXA1Zys2L293OE1MT1kwMTYxY0ZoWGNqb2dZcFVw?=
 =?utf-8?B?UytBcVVyaDB2QUZyOVpETXZ2ZGUzOS93NGtFZWcyK1gyd3pGRUx0d2xZcDdY?=
 =?utf-8?B?VnZ4R0F4eUs4OHVtSUJwaUtRWVFWUWpLaXFXYlNKQzRBVjJyaHd1a3V0RTBa?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56B71233A1FE4148808B3884F5864CDB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9db767-c5af-44ae-cc7f-08dc631e227b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2024 22:47:05.7955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vjVNszZHzLZXrN+xmAU2V9XxtEUDfdB7v3gEzVVwCXc4HaflC8Syu6u6VCVSYKBDiGcjXbD7WKoxXXayRbI11Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6478
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTIyIGF0IDA5OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIEFwciAyMiwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMjAyNC0wNC0xOSBhdCAxMDoyMyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIEZyaSwgQXByIDE5LCAyMDI0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiBBbmQg
dGR4X2VuYWJsZSgpIHNob3VsZCBhbHNvIGRvIGl0cyBiZXN0IHRvIHZlcmlmeSB0aGF0IHRoZSBj
YWxsZXIgaXMgcG9zdC1WTVhPTjoNCj4gPiA+IA0KPiA+ID4gCWlmIChXQVJOX09OX09OQ0UoIShf
X3JlYWRfY3I0KCkgJiBYODZfQ1I0X1ZNWEUpKSkNCj4gPiA+IAkJcmV0dXJuIC1FSU5WQUw7DQo+
ID4gDQo+ID4gVGhpcyB3b24ndCBiZSBoZWxwZnVsLCBvciBhdCBsZWFzdCBpc24ndCBzdWZmaWNp
ZW50Lg0KPiA+IA0KPiA+IHRkeF9lbmFibGUoKSBjYW4gU0VBTUNBTExzIG9uIGFsbCBvbmxpbmUg
Q1BVcywgc28gY2hlY2tpbmcgInRoZSBjYWxsZXIgaXMNCj4gPiBwb3N0LVZNWE9OIiBpc24ndCBl
bm91Z2guICBJdCBuZWVkcyAiY2hlY2tpbmcgYWxsIG9ubGluZSBDUFVzIGFyZSBpbiBwb3N0LQ0K
PiA+IFZNWE9OIHdpdGggdGR4X2NwdV9lbmFibGUoKSBoYXZpbmcgYmVlbiBkb25lIi4NCj4gDQo+
IEknbSBzdWdnZXN0aW5nIGFkZGluZyBpdCBpbiB0aGUgcmVzcG9uZGluZyBjb2RlIHRoYXQgZG9l
cyB0aGF0IGFjdHVhbCBTRUFNQ0FMTC4NCg0KVGhlIHRoaW5nIGlzIHRvIGNoZWNrIHlvdSB3aWxs
IG5lZWQgdG8gZG8gYWRkaXRpb25hbCB0aGluZ3MgbGlrZSBtYWtpbmcNCnN1cmUgbm8gc2NoZWR1
bGluZyB3b3VsZCBoYXBwZW4gZHVyaW5nICJjaGVjayArIG1ha2UgU0VBTUNBTEwiLiAgRG9lc24n
dA0Kc2VlbSB3b3J0aCB0byBkbyBmb3IgbWUuDQoNClRoZSBpbnRlbnQgb2YgdGR4X2VuYWJsZSgp
IHdhcyB0aGUgY2FsbGVyIHNob3VsZCBtYWtlIHN1cmUgbm8gbmV3IENQVQ0Kc2hvdWxkIGNvbWUg
b25saW5lICh3ZWxsIHRoaXMgY2FuIGJlIHJlbGF4ZWQgaWYgd2UgbW92ZQ0KY3B1aHBfc2V0dXBf
c3RhdGUoKSB0byBoYXJkd2FyZV9lbmFibGVfYWxsKCkpLCBhbmQgYWxsIGV4aXN0aW5nIG9ubGlu
ZQ0KQ1BVcyBhcmUgaW4gcG9zdC1WTVhPTiB3aXRoIHRkeF9jcHVfZW5hYmxlKCkgYmVlbiBkb25l
Lg0KDQpJIHRoaW5rLCBpZiB3ZSBldmVyIG5lZWQgYW55IGNoZWNrLCB0aGUgbGF0dGVyIHNlZW1z
IHRvIGJlIG1vcmUNCnJlYXNvbmFibGUuDQoNCkJ1dCBpZiB3ZSBhbGxvdyBuZXcgQ1BVIHRvIGJl
Y29tZSBvbmxpbmUgZHVyaW5nIHRkeF9lbmFibGUoKSAod2l0aCB5b3VyDQplbmhhbmNlbWVudCB0
byB0aGUgaGFyZHdhcmUgZW5hYmxpbmcpLCB0aGVuIEkgZG9uJ3Qga25vdyBob3cgdG8gbWFrZSBz
dWNoDQpjaGVjayBhdCB0aGUgYmVnaW5uaW5nIG9mIHRkeF9lbmFibGUoKSwgYmVjYXVzZSBkb8Kg
DQoNCglvbl9lYWNoX2NwdShjaGVja19zZWFtY2FsbF9wcmVjb25kaXRpb24sIE5VTEwsIDEpOw0K
DQpjYW5ub3QgY2F0Y2ggYW55IG5ldyBDUFUgZHVyaW5nIHRkeF9lbmFibGUoKS4NCg0KPiANCj4g
QW5kIHRoZSBpbnRlbnQgaXNuJ3QgdG8gY2F0Y2ggZXZlcnkgcG9zc2libGUgcHJvYmxlbS4gIEFz
IHdpdGggbWFueSBzYW5pdHkgY2hlY2tzLA0KPiB0aGUgaW50ZW50IGlzIHRvIGRldGVjdCB0aGUg
bW9zdCBsaWtlbHkgZmFpbHVyZSBtb2RlIHRvIG1ha2UgdHJpYWdpbmcgYW5kIGRlYnVnZ2luZw0K
PiBpc3N1ZXMgYSBiaXQgZWFzaWVyLg0KDQpUaGUgU0VBTUNBTEwgd2lsbCBsaXRlcmFsbHkgcmV0
dXJuIGEgdW5pcXVlIGVycm9yIGNvZGUgdG8gaW5kaWNhdGUgQ1BVDQppc24ndCBpbiBwb3N0LVZN
WE9OLCBvciB0ZHhfY3B1X2VuYWJsZSgpIGhhc24ndCBiZWVuIGRvbmUuICBJIHRoaW5rIHRoZQ0K
ZXJyb3IgY29kZSBpcyBhbHJlYWR5IGNsZWFyIHRvIHBpbnBvaW50IHRoZSBwcm9ibGVtIChkdWUg
dG8gdGhlc2UgcHJlLQ0KU0VBTUNBTEwtY29uZGl0aW9uIG5vdCBiZWluZyBtZXQpLg0KDQo+IA0K
PiA+IEkgZGlkbid0IGFkZCBzdWNoIGNoZWNrIGJlY2F1c2UgaXQncyBub3QgbWFuZGF0b3J5LCBp
LmUuLCB0aGUgbGF0ZXINCj4gPiBTRUFNQ0FMTCB3aWxsIGNhdGNoIHN1Y2ggdmlvbGF0aW9uLg0K
PiANCj4gWWVhaCwgYSBzYW5pdHkgY2hlY2sgZGVmaW5pdGVseSBpc24ndCBtYW5hZGF0b3J5LCBi
dXQgSSBkbyB0aGluayBpdCB3b3VsZCBiZQ0KPiB1c2VmdWwgYW5kIHdvcnRod2hpbGUuICBUaGUg
Y29kZSBpbiBxdWVzdGlvbiBpcyByZWxhdGl2ZWx5IHVuaXF1ZSAoZW5hYmxlcyBWTVgNCj4gYXQg
bW9kdWxlIGxvYWQpIGFuZCBhIHJhcmUgb3BlcmF0aW9uLCBpLmUuIHRoZSBjb3N0IG9mIHNhbml0
eSBjaGVja2luZyBDUjQuVk1YRQ0KPiBpcyBtZWFuaW5nbGVzcy4gIElmIHdlIGRvIGVuZCB1cCB3
aXRoIGEgYnVnIHdoZXJlIGEgQ1BVIGZhaWxzIHRvIGRvIFZNWE9OLCB0aGlzDQo+IHNhbml0eSBj
aGVjayB3b3VsZCBnaXZlIGEgZGVjZW50IGNoYW5jZSBvZiBhIHByZWNpc2UgcmVwb3J0LCB3aGVy
ZWFzICNVRCBvbiBhDQo+IFNFQU1DQUxMIHdpbGwgYmUgbGVzcyBjbGVhcmN1dC4NCg0KSWYgVk1Y
T04gZmFpbHMgZm9yIGFueSBDUFUgdGhlbiBjcHVocF9zZXR1cF9zdGF0ZSgpIHdpbGwgZmFpbCwg
cHJldmVudGluZw0KS1ZNIHRvIGJlIGxvYWRlZC4NCg0KQW5kIGlmIGl0IGZhaWxzIGR1cmluZyBr
dm1fb25saW5lX2NwdSgpLCB0aGUgbmV3IENQVSB3aWxsIGZhaWwgdG8gb25saW5lLg0KDQo+IA0K
PiA+IEJ0dywgSSBub3RpY2VkIHRoZXJlJ3MgYW5vdGhlciBwcm9ibGVtLCB0aGF0IGlzIGN1cnJl
bnRseSB0ZHhfY3B1X2VuYWJsZSgpDQo+ID4gYWN0dWFsbHkgcmVxdWlyZXMgSVJRIGJlaW5nIGRp
c2FibGVkLiAgQWdhaW4gaXQgd2FzIGltcGxlbWVudGVkIGJhc2VkIG9uDQo+ID4gaXQgd291bGQg
YmUgaW52b2tlZCB2aWEgYm90aCBvbl9lYWNoX2NwdSgpIGFuZCBrdm1fb25saW5lX2NwdSgpLg0K
PiA+IA0KPiA+IEl0IGFsc28gYWxzbyBpbXBsZW1lbnRlZCB3aXRoIGNvbnNpZGVyYXRpb24gdGhh
dCBpdCBjb3VsZCBiZSBjYWxsZWQgYnkNCj4gPiBtdWx0aXBsZSBpbi1rZXJuZWwgVERYIHVzZXJz
IGluIHBhcmFsbGVsIHZpYSBib3RoIFNNUCBjYWxsIGFuZCBpbiBub3JtYWwNCj4gPiBjb250ZXh0
LCBzbyBpdCB3YXMgaW1wbGVtZW50ZWQgdG8gc2ltcGx5IHJlcXVlc3QgdGhlIGNhbGxlciB0byBt
YWtlIHN1cmUNCj4gPiBpdCBpcyBjYWxsZWQgd2l0aCBJUlEgZGlzYWJsZWQgc28gaXQgY2FuIGJl
IElSUSBzYWZlICAoaXQgdXNlcyBhIHBlcmNwdQ0KPiA+IHZhcmlhYmxlIHRvIHRyYWNrIHdoZXRo
ZXIgVERILlNZUy5MUC5JTklUIGhhcyBiZWVuIGRvbmUgZm9yIGxvY2FsIGNwdQ0KPiA+IHNpbWls
YXIgdG8gdGhlIGhhcmR3YXJlX2VuYWJsZWQgcGVyY3B1IHZhcmlhYmxlKS4NCj4gDQo+IElzIHRo
aXMgaXMgYW4gYWN0dWFsIHByb2JsZW0sIG9yIGlzIGl0IGp1c3Qgc29tZXRoaW5nIHRoYXQgd291
bGQgbmVlZCB0byBiZQ0KPiB1cGRhdGVkIGluIHRoZSBURFggY29kZSB0byBoYW5kbGUgdGhlIGNo
YW5nZSBpbiBkaXJlY3Rpb24/DQoNCkZvciBub3cgdGhpcyBpc24ndCwgYmVjYXVzZSBLVk0gaXMg
dGhlIHNvbG8gdXNlciwgYW5kIGluIEtWTQ0KaGFyZHdhcmVfZW5hYmxlX2FsbCgpIGFuZCBrdm1f
b25saW5lX2NwdSgpIHVzZXMga3ZtX2xvY2sgbXV0ZXggdG8gbWFrZQ0KaGFyZHdhcmVfZW5hYmxl
X25vbG9jaygpIElQSSBzYWZlLg0KDQpJIGFtIG5vdCBzdXJlIGhvdyBURFgvU0VBTUNBTEwgd2ls
bCBiZSB1c2VkIGluIFREWCBDb25uZWN0Lg0KDQpIb3dldmVyIEkgbmVlZGVkIHRvIGNvbnNpZGVy
IEtWTSBhcyBhIHVzZXIsIHNvIEkgZGVjaWRlZCB0byBqdXN0IG1ha2UgaXQNCm11c3QgYmUgY2Fs
bGVkIHdpdGggSVJRIGRpc2FibGVkIHNvIEkgY291bGQga25vdyBpdCBpcyBJUlEgc2FmZS4NCg0K
QmFjayB0byB0aGUgY3VycmVudCB0ZHhfZW5hYmxlKCkgYW5kIHRkeF9jcHVfZW5hYmxlKCksIG15
IHBlcnNvbmFsDQpwcmVmZXJlbmNlIGlzLCBvZiBjb3Vyc2UsIHRvIGtlZXAgdGhlIGV4aXN0aW5n
IHdheSwgdGhhdCBpczoNCg0KRHVyaW5nIG1vZHVsZSBsb2FkOg0KDQoJY3B1c19yZWFkX2xvY2so
KTsNCgl0ZHhfZW5hYmxlKCk7DQoJY3B1c19yZWFkX3VubG9jaygpOw0KDQphbmQgaW4ga3ZtX29u
bGluZV9jcHUoKToNCg0KCWxvY2FsX2lycV9zYXZlKCk7DQoJdGR4X2NwdV9lbmFibGUoKTsNCgls
b2NhbF9pcnFfcmVzdG9yZSgpOw0KDQpCdXQgZ2l2ZW4gS1ZNIGlzIHRoZSBzb2xvIHVzZXIgbm93
LCBJIGFtIGFsc28gZmluZSB0byBjaGFuZ2UgaWYgeW91DQpiZWxpZXZlIHRoaXMgaXMgbm90IGFj
Y2VwdGFibGUuDQo=

