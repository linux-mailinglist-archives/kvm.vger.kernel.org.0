Return-Path: <kvm+bounces-32430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 921819D8517
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 13:09:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 519E728ADFF
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 12:09:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D7B5199FB0;
	Mon, 25 Nov 2024 12:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TtkVLZjh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CAF19992D;
	Mon, 25 Nov 2024 12:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732536545; cv=fail; b=DKguCoZZXILjkbXRtWZreG6tPdy33evI4IpH3fFrX2c+U9/Rr/BaDz3f75eryocKydvx8enoqfooStRtIA0XhV8A1P4thchbD+teRPnBBDV9v16m1HfuziAEiQTNgGZ5Yd4YUbkA+ez8nfRzrlSUSZsZBDFhPmAdfDAeyx3seOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732536545; c=relaxed/simple;
	bh=Hqhad1JB78Xd3suGHfZkQYV19sg/WnLkP1wPP9fj1Sw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YPPBgfowI6O1lp4QEpJQ10KJGoLKPlFokN27NKUkUj0jSE3hBxWUQmEqtnM9Io930/l8clsYI1jVPicGbFre7yUSiC+evSoJI4UeVO/RRl+ZVn4LsMmcRfAendYFXcNIBcllbYCUcCP1bRpOGpeBYxH5ryHZ15jcqU8FJ+6mYGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TtkVLZjh; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732536544; x=1764072544;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Hqhad1JB78Xd3suGHfZkQYV19sg/WnLkP1wPP9fj1Sw=;
  b=TtkVLZjhS3nFCLR3+QVSA0qTTKRh8JYiyaekz8NMsY46izvtox/q3RBF
   Y6g8D5j6Uoj6bbXY5Dl1qSSZLgUct0NtRN98yzizB7dNnVW0l4oN5cp79
   jPQOjqtZEz1pkB5e/qe3VXZqnx+AsjeLJ1i+TSZtKIi/nV7A7RsTY0iyJ
   4YAEyS8wLHUY/e/82Jy3xjmP7YFmPiFJYffwkWqTSvVpJJY6CCSFeRtqK
   CRn4l2SKzfyDsX1atl/ACM+E1Pixb+d4TDfcCRdqKJpg8l9w1qSNSXR+R
   6pQ6+Rx2lFFopOvs7NyQNCgHtw1uPqhAAgo2pmEamsN4VIGajjjodQrrV
   A==;
X-CSE-ConnectionGUID: Ie/NrF1MQj2C+o2npHkG+g==
X-CSE-MsgGUID: xiJq2qhtSyiFiVeXfvQNQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="32576603"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="32576603"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 04:09:03 -0800
X-CSE-ConnectionGUID: wdlc4/8oQEK6j5sahKLASQ==
X-CSE-MsgGUID: n5VOAKiYT16i+C7Lo/Lk7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="96025579"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 04:09:02 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 04:09:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 04:09:01 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 04:09:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VTERnHWM1gtRasid4i+70RClOiLOfJHzEtrVLUA0aLiMU8HkuXYINUsGGkoLhUHJMqXx1R7QTLcBDOLMjp54EWEKaTkHdcIv9Ue/ozI+NV9mjQDBqI7RcOx/Dc10vHkRarfaaYRWZ2K7BN6G+3J8yFfsyI82j593u83EazB7tzge37eszDK4kaMbZK0XioGC66n4j268Up+jRuweuAd/8AkCObZTi+qoWEaLx728GAkhxecPMrxP68gp/xD3QoAfVREeN0AdJjLXHtamWrq7s6YrHr2DZHlbcjI21VhrMgRWvOl1oplFrgyHugccpUCHo1vVUHcr2T6z2CMYj+EgTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hqhad1JB78Xd3suGHfZkQYV19sg/WnLkP1wPP9fj1Sw=;
 b=a4bAqVkYswGtB5ErpCWF5zeraWOoZ4VJ4ViuqZJRaJsnGzqoFNwPcYsUyB3qkclCo0govlSR6ur4gp9116v79glZbQua0KpC5rAigHoN2YByk7jUwx42p4lRHb0wcefbgv/F5jCt+LBU/LV9p/yE4/EFlpx5FYOi/M/Nu2RypDg1pZD822CQVWSfBRJk7/7n9s2S1Bbg+wz1sl/JIXR1NQQ/FbKNdS23J0V1IMoLlw9lWlpguzz7phUqSJYbFEe/BFSrq9elAD3rfCNDXSOk5hqq2yMwHSLPrJso8o74z2nivZCGRVbeRko+tpNvBoQ40fUB9Borr1dhvdh6AVOkJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB8184.namprd11.prod.outlook.com (2603:10b6:8:160::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.19; Mon, 25 Nov
 2024 12:08:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 12:08:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Topic: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Index: AQHa916mLjHQn3A27kaE3wVAzihpyrKgK5iAgABDH4CAAOwxgIABUlWAgABdLwCABDPdAIAAEjwAgAEWjQCAAHIYAIABhPKAgAAGFgCAABWOgIAAWQeAgB1KPoCAAFnVAA==
Date: Mon, 25 Nov 2024 12:08:59 +0000
Message-ID: <f02bed39725cdf9bcdc77e7f40cfe99cbc57861d.camel@intel.com>
References: <ZyLWMGcgj76YizSw@google.com>
	 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
	 <ZyUEMLoy6U3L4E8v@google.com>
	 <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
	 <95c92ff265cfa48f5459009d48a161e5cbe7ab3d.camel@intel.com>
	 <ZymDgtd3VquVwsn_@google.com>
	 <662b4aa037bfd5e8f3653a833b460f18636e2bc1.camel@intel.com>
	 <cef7b663-bc6d-44a1-9d5e-736aa097ea68@linux.intel.com>
	 <e2c19b20b11c307cc6b4ae47cd7f891e690b419b.camel@intel.com>
	 <b7fd2ddf-77a4-423c-b5cf-36505997990d@linux.intel.com>
	 <ZyuLf5evSQlZqG6w@google.com>
	 <57d308a8-0ce5-41f8-aef4-33d36723c434@linux.intel.com>
In-Reply-To: <57d308a8-0ce5-41f8-aef4-33d36723c434@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.1 (3.54.1-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB8184:EE_
x-ms-office365-filtering-correlation-id: 271209b8-120a-419b-4de8-08dd0d49f1a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cE5WTndoem5XY0ZzQnNXdncyZ0dnbHlndndDNEEvWWRDWC94RFJWNHFjTUVL?=
 =?utf-8?B?VWhQb3dqdlo3c0Q1aWVrUnRLMUFEZFVIL2NNT1BocmZrL0dJUDl2cC9xdk4z?=
 =?utf-8?B?eUIvN2s2ZThuWWczczEwRnZoT0RwWU92WkxuSHRUbG1aNVRPQ2dYTkRFNXc2?=
 =?utf-8?B?cmZ1dzV4cWJ4RHV1Y3BTWWd6dC9NTFdNNFZOSXo0SmRkSURlVUY4R2UwbDV3?=
 =?utf-8?B?SDRKejJFL2hZa3dHakhjTVE1V2w0enNwRDNPUUxSRTB4NUN4NWh4WE1ZeEd1?=
 =?utf-8?B?RW80UWtYajVaMzVTVXppaWI2NGRIR2Rja3hOTnNjTmxxaW5iV3g0MS83OUFq?=
 =?utf-8?B?Q3hlUXl0ZXZDeVNBNkxqUUpOMXc0Mlc2OG8wM0x2ZlpuK0xkcTNScmRaZ3pa?=
 =?utf-8?B?aDA2R292b000dWszRUN0SW16SFZDcmJBbitFTFY3Vm8wZ21seDhmVG5OdEtI?=
 =?utf-8?B?eUJLZ3k0N2c0RVNFbnlqc0l2RmNHMVJyNVZJM2FEOXpKOWY1WXlHdjd6R0da?=
 =?utf-8?B?alhDd2d3MU9haTMzM3ZCUDl5M2tPaVVORlVBQk9vb1locmdKaXFzVXpCVFF6?=
 =?utf-8?B?YWFSeWxFYW92c0FnZU1weEt3Z0FLaDBIeXhySExXWWZmbmthUHNmbktQV1Vn?=
 =?utf-8?B?RitZL3Jlc0tteFErMVZrVWdsaXNWMUNreGxaQ0VMY1JEUjNEVFNlcWVJQ1ZW?=
 =?utf-8?B?UlE5VXVPTnhDRU9VVVhlT0tKaVZHLzVhbHpLSWRvZ2dzNjl6N0ZxWlBtc3Zv?=
 =?utf-8?B?TTY1TWdRWXpMVWZwYzlsY0xDRlY5dVJoZlpnSXlaOFdvNzYwb1lFSHR3ZnNB?=
 =?utf-8?B?VVU5VTM5c0lrempKYjZnZit0Z25KSnlUNzNnL3FjMllUZERhTmU2N1FmMGpu?=
 =?utf-8?B?UWVlL2gxZDRuNHdqd1pWOTU0ODJwZndqdHE1Uk8yUU1yaE93Nk15K1lkalls?=
 =?utf-8?B?alZ4ZFRRNVZMWHAxdnMwdDJqeGdWSUJOdjNURlhPanJxWkhrT3B5dU1rZ2tO?=
 =?utf-8?B?dkFlamJRMHJiaXZlU1N4dmZqc0NZdE9vTkpybkdQWjhlTFowQ2FOMmNBVGRq?=
 =?utf-8?B?S2oyZVVia1ppZm16djN6SHhpVzBEWWZLSUZTZ3paREpCcnYwUk5mWDBTeTda?=
 =?utf-8?B?M1YxOXNZM2krM0hLMlZ5QjJSa1g1YTAzZm11OHcyalR6cklIdVVocEpJbHNt?=
 =?utf-8?B?M2FUK09LWDVHUThKTXl4UkpEZDB5dmY5VjgzNXdwVnZTTDh0REFhcG5UaUhR?=
 =?utf-8?B?Um9vSVZWMUQ2RDhPOWpzS284d0hlMDFCMjZWOExCbjNrb1lJNVYxUlU5eVR0?=
 =?utf-8?B?OU5RQTZHRHhwcUt2QVNhQUJDTUJTZVNlTTJmYTRqamRZekdSZEJmd0V5SHpF?=
 =?utf-8?B?RzhjQlczQ0V2S1BsWmllcDg4RmgzaTZxQ0tQem5SejVOaGpscU5JSUVTT1ZI?=
 =?utf-8?B?UDEwTGNHaVhRMTE0MTBhbitOU013NkQ4TVlpS2RicWQzYTc3RTJ1RWk4MGtt?=
 =?utf-8?B?Z0s3MXpzeHRBd1dzSHp1RE1jSzdleFhoU1ZBL0FTd0ZpMndlZUc3M0pTc2x1?=
 =?utf-8?B?MmJrS3ZlRW83WEEwWEdkZnR1SW9JcXRNMUMwYmhUZ2xDaGlxMmVFdmVxUUd2?=
 =?utf-8?B?WFovd0U4czMrZkh3ZHJ5dk9wVEpvMkM2cmFEUkswYjV3L2VYYlZpUXZYNElh?=
 =?utf-8?B?OHE0MGZEUGdFckpodWxMZkplNnVRWFFGdmZRUDB1eWhsbWliY2NXWGthMDNV?=
 =?utf-8?B?THZKeEU0R1JmVXhXd1lnenErdmkzc2NCczBZbHUyM282MzNPUnpuWERSc1Zn?=
 =?utf-8?B?QS8zWVE4RnV0K051aHYzY3QzcnBycXNOczdEQmE1UGZPZ05SNjdPR2Vucm9s?=
 =?utf-8?B?VS96TXU5TGNrbHRNT3h6M2lOemtlTnZ1eEhLN2FqRnBVTFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cC93a1QxbzBQVmw3S1BPWVJ3b2UwYUx1S0crMnp1cGs2cGVGOFFiUFNwcjhK?=
 =?utf-8?B?YVFRWnN3VlgraHZ0b1llWTdJVVZNd3lJQVVSRWxNaWowek5NaXFYNENLY2VC?=
 =?utf-8?B?NjNaUFhaT2ZWSDVuTWd1VlVRZ2x4K3RyMnZiNm1JbjZhbkdBRVlLMi8ybXpS?=
 =?utf-8?B?TUNDTDllUHk4K3dpNnNSTjNyd3ZLZWtuUkt6T3JpSjVVZ0FIcTFLWDVzZjA4?=
 =?utf-8?B?Zmx3UEN2dmVVV2JGN2ZhbWFuMTZNM1J6bXlHTnBnbWs5WjZpM3gwenpxNm5i?=
 =?utf-8?B?RytrazBXSHQ1MjgrWm91NHFmdEJRRkF4cWllZnhVQTlwdDYwQVhMMGZFY1Uz?=
 =?utf-8?B?Qis0VVpGY1FGaGtkYmVQdjhKVmlSdUNNbkxCWlpoeUZHT0RiVUlpeDVsWE0w?=
 =?utf-8?B?Q0UvS0gzVldRVFd4aFZBQnFyaG1GNzdiSE0yYW4ycHhNWnluVC90TEJPYVlz?=
 =?utf-8?B?M28vMWY5YmpnNkxka2kxdkxiYU5lakFCMUFJVkhiN1ByeGhiaXNvK2s5S1Q4?=
 =?utf-8?B?Ym5Fb2l5TnhDSVJDNjJTTnJNSUxDTmg1cTROVHB1WHQ2ZDNFci8zaWZFRDJm?=
 =?utf-8?B?cWlPRDRSQ1lrODdoUk9tdGJxakthd0NVN0d5MXVSZXFlaEdrc2RiVVFTRmRH?=
 =?utf-8?B?bm5HU1BUUE95SXF6eTJ5VUpNdDh4dFZhUzdkcTdyZGkydDhpbGxnM0J5a0tK?=
 =?utf-8?B?VEc4YURNYnFJUkIvZUY2d3dkS1JkWU1scURlczVINThhUnZibVNuQ1laQml0?=
 =?utf-8?B?WWNjWGd5VGFtd0JKZ2tyRGM4cGxOR0FBbUVvQWtpV25KTmFZSjUvaVdHZjhR?=
 =?utf-8?B?OGRxNzZzalpWVUx6cExLakd3b1Q4aytYbHdEaFpPUXl6Q0FjaVVIYXExaTRy?=
 =?utf-8?B?MWFITCtaUWtwNVBtMEFvQjNZaWs0QXh3WHR1SHpYTDJ1UG1EMTVudUNEN09r?=
 =?utf-8?B?WEVjamV3SmcwcUlWYUN5UWxSZzYrc1krUUVjMFlXNkdQMUFqRGZoR01WVFRV?=
 =?utf-8?B?MWdtODlram9SZHY3QlRodXVHS2lDTm5GL2w1dVFvT3g3K1JieUhhQkE0SEIr?=
 =?utf-8?B?L2ZSZXNDMk1NQVNTMDYvbG55emlNSEN5amJGNGQ2YWZsbDBUdWc1ZUkrOTRX?=
 =?utf-8?B?T1c3ZGRDYWxpNWVpVDlxZkFjS0YwYURlRDVzN1orN0p1dXMveFJFbEFKd1B0?=
 =?utf-8?B?VTdsQUt0MldXVGgzN3pvWFl2NVdERm5WZjRwbEhzQkdaYjN6K0tKK01CQmMz?=
 =?utf-8?B?Q0FXQmt6NndFVzA1clpCYk84N2d1NkR1WWJoK1YyZ0lKSngzcG1nOGdwTXZD?=
 =?utf-8?B?bHBLR1EzTERBeXdYdXRSbzJjZkNpVTUxcXZVelYvSWE5T1Iza1ZFL3RXNkJY?=
 =?utf-8?B?VmJlYkhrQlRZY25WUHV2eWJTL1l1d1lTVE5ObUFRMzN1YzhnWEM3SWhoK3Zi?=
 =?utf-8?B?VFlGRG5Ed1NZNEV0c3FnM2ttb2lvbXNpeWV3bGkzT1JFdlNWZmgzZXZsUWxR?=
 =?utf-8?B?UTRwcUNYK2ZmdE1hc2lrSVRTU1lqc0pBYVpQcWJZV1ZGcEc2NXZNRHh5NjF2?=
 =?utf-8?B?dXZuWDB2Nndrak5wTDliMno5d29TKzl2ZlQwa1lHMWtoUDBFZXllcGI0U3JD?=
 =?utf-8?B?b0dSS3Q5eDgzR1hESG1IOExMUkRVQXpteDkxaklZR3dqQzROcUVYdGphNytq?=
 =?utf-8?B?MWcxUzdDeHdlYnMyWkc0TFlIWWJoRFVjVE5CWStDSnBlQWdBbTZvUmRjVHhG?=
 =?utf-8?B?ZVF3YXlBZFBFRmpCZUFkN1BBQmtLMDdGczdVYkR5OFY2ekQxT3BjZ1NJN01m?=
 =?utf-8?B?cGdOaE01ZWNhanJ3citsVFhjWGRVUWhNdWJkR2hXR0xkRnluWDNiYjFjYkFx?=
 =?utf-8?B?eWw3aTVtYzQ5RlBtcXhtR3ZEZ3Y3MlZlSjZqb3RWSi9YaUlxRnZpVmYwV21n?=
 =?utf-8?B?eWNlVUl5dk9HUjFQamZhNlpnM0JpVHNHMWo4U2p5NGpyQ282YnQ3Q2ZWaW9S?=
 =?utf-8?B?c2dyZkZtM05LZVVNd3RZUS9mN2dQVWlGTDVEVjhRd0NhOWlWMkpkVVJEb2R6?=
 =?utf-8?B?K0YvcmpyWE9IMjBUTTZFNmtnenRQaW1lZTBjWlpyemdhOXFBdWd5ckVWa1FE?=
 =?utf-8?Q?+utawIDrbF9S6vX5hB33LdEJV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A09E595B7B654D4F8260A4E8CA3F8665@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271209b8-120a-419b-4de8-08dd0d49f1a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2024 12:08:59.3807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8vFxL2+Z2KtcLaa5OXNjFfbWmm6x09LkQXOnNMHsr0tazP51WifQgPfy5uYVgEuaq8W6C/DVmeNUaMZqStK4uQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8184
X-OriginatorOrg: intel.com

PiA+IA0KPiBCYXNlZCBvbiB0aGUgcHJldmlvdXMgZGlzY3Vzc2lvbnMsIGlzIHRoZSBiZWxvdyBj
b2RlIGV4cGVjdGVkPw0KPiBJZiBzbywgSSBhbSBnb25uYSB1c2UgX19rdm1fZW11bGF0ZV9oeXBl
cmNhbGwoKSBhbmQga3ZtX2NvbXBsZXRlX2h5cGVyY2FsbF9leGl0KCkNCj4gaW4gVERYIGNvZGUg
Zm9yIGhhbmRsaW5nIEtWTSBoeXBlcmNhbGxzLg0KPiANCg0KTEdUTS4NCg==

