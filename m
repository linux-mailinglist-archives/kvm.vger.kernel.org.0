Return-Path: <kvm+bounces-16773-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0D18BD853
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 01:54:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 320C71F23DE1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 23:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874FC15DBA5;
	Mon,  6 May 2024 23:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmBFo1lF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E3C15B116;
	Mon,  6 May 2024 23:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715039606; cv=fail; b=uAQ5M8ZqQNk/phKER+qkZYCvQSD0qZVES9Ocw1lZyD3Q6QvWh3/qhg8mG7474Ry5El1gFFq19ItbgkyMaXw8NlMmaT3Rbb+GfVO1xi+MGLjv/3AKf7N6J/AUagpY4gXb2usZRpJ2f+ZAk1vzZU83OUhih6kQiydOQRmjpkZm1SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715039606; c=relaxed/simple;
	bh=QLa5acB8M2W8voVE66h72zH/ZnsK9dlrWFh+mHW9ofM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aLsQrjQw7jmRDbCVmFDPTBg6rlAkKB2BLfgq+yNdYF0xkQ1LQ9oQgTeDAESd4UDED0iZksDTcSaxs+eoz3hmPDLJLbFgaT+f3llgCOOxrZaMYKhvYZr+kKK3qAxvaHC2V7BZlrdyK3g+bHqb75f5HNFUqx3YApPBta9LQjnHG38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WmBFo1lF; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715039605; x=1746575605;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QLa5acB8M2W8voVE66h72zH/ZnsK9dlrWFh+mHW9ofM=;
  b=WmBFo1lFyVXliC8fUhUeDg3sTfqbULY0CQZHn78bdYc8xIrUvqMw9PJ2
   UqG0LyY5cvwnDD/mL7gT2UF+0OHOjoEIwqT1TRJwr27EUVgj841+PfO00
   6i3Bqerd2MxdkOb/ORf0vcQSeFvCugNL7QCCvgdPl3w67K/R37M1mnW+Q
   nULLUkZJTnpKyOX7Cp3+kk2vl9U4BuO+Z2mlpalv7LwrPPjElpKEuKhrM
   2dldavWS82nwcGRMxYgIqCTqUN3Twux6HtJ4aMR9mCdRGfwMgWMwxL35L
   VvFcObqkyphNeOWcAkcqGlrdJgHkpP2rAoUr+KQWbXRIm/uOyr8U1lyUa
   w==;
X-CSE-ConnectionGUID: F24hJ96wQD2mXUk6ZRbHlg==
X-CSE-MsgGUID: +5U9LNM8Q/e6p50l/cBSKg==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="10972513"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="10972513"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 16:53:24 -0700
X-CSE-ConnectionGUID: Sj6M8N7LQ6qr8WV70vGCTw==
X-CSE-MsgGUID: USNRoSgzRFycnaJTjp9NUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="32903081"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 16:53:23 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 16:53:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 16:53:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 16:53:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehN1q96W6HG7i+MYuqWVK0Ir+3h2hsjZWwskaVD0wSYg5To1AHqpSu9rVE/hUJFKlvRsH2XUuSvUa2h7kDGWuyHGcWStSkKgUY2zqihaOvzMBF9ZD1JTQWzEW7n3WFFHExUxtpY4wA/pZ8cQtEysiSohuDaevs8yS7YdiOYcN37k9oj5OvtXrvuFiuiBdsE3EcrLR1AC9FSKdfvREUYwliLuJx42epa1c3xAfMRPJ4m3Pmpty4AHBDqEMbTycEg3g04K3nzh4N3JtGthLElbiW9o66K3AsAtOxceanmezns32NytX/FaK+HMzYpXRuPTGoj0l+VC8u7Srgwk4B46vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLa5acB8M2W8voVE66h72zH/ZnsK9dlrWFh+mHW9ofM=;
 b=bycgZ0+MSs7al9XHYW5gPXVqTOxNwMSwyJnAt++JBvANvy/cZaj8x5JAFafj26/6m04zXPph4+hl62RcxNIU2moSRfo86lYhas2OLyhJXV6xTeN+3Th2S6mp9+S4ACMow+CoXyBtaA/5fKTW1k7D6QGEobdTHwAXKe+zk4Misir9XRuio1kWay7POx+yu1PWzCQqcXVYPzTVTjr7ZjbwanQ2+mX5+8/06L7rYfO/2yoJ0OWRfSgnZrQaXo43SW6n208ppLXf/tZwfz+dj5L81hmj5lbdBixrbyrcSC+IZemZDOByNc7k5Yxi4elNCRAdSwpyuHgQIJCBkfxSFhBt5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6291.namprd11.prod.outlook.com (2603:10b6:208:3e5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Mon, 6 May
 2024 23:53:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7544.036; Mon, 6 May 2024
 23:53:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"john.allen@amd.com" <john.allen@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yang, Weijiang" <weijiang.yang@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Thread-Topic: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
Thread-Index: AQHaYwfynhk8CrwGC0ayixDi2U+bW7GDdNgAgAbyCQCAAIJfgIAAbDuAgAAFmYA=
Date: Mon, 6 May 2024 23:53:19 +0000
Message-ID: <8a6c88c7457f9677449b0be3835c7844b34b4e8a.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <20240219074733.122080-25-weijiang.yang@intel.com>
	 <ZjLNEPwXwPFJ5HJ3@google.com>
	 <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
	 <038379acaf26dd942a744290bde0fc772084dbe9.camel@intel.com>
	 <ZjlovaBlLicFb6Z_@google.com>
In-Reply-To: <ZjlovaBlLicFb6Z_@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6291:EE_
x-ms-office365-filtering-correlation-id: 4b61bd6d-5526-418f-b06f-08dc6e27b507
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UVpDZ1Z3Q1VQRmVvTmI1b0d4b1hDcU1DdUhqVEhTQ1VhNmUxOTZLTTVRODNV?=
 =?utf-8?B?RVU4T3pZSHlieE9WcEE5dU5OOC9vNCtHV0t6RjFxRzhEZUZUMWRMRFRlQUhI?=
 =?utf-8?B?SlVRenZYdE94YVR5WDlVeTdNc2hxV1hrZ3RvNndkM1RCbUpHVWdNeFdnbjJU?=
 =?utf-8?B?OGpXZDBiSHhSUDFZNlZvamF0RlBEeU9WUmZYKzB4bnhUbXRldXRuQ3dhVW5G?=
 =?utf-8?B?NzFMZXlnMVViUEk1cVlyeVNUaWRoRGtQdkF1M25DMmtQKy9QbXlKRFNPQXdX?=
 =?utf-8?B?UmpMUUNxQnBrazgrWU5CMVpobU9UVUFNWlU3ZGhCS21ITDhaSTJUZllEK05D?=
 =?utf-8?B?M3hiWU82b0cxMS9qMnlROFpINVk2aGlOUjFTUFZqUHZoV1lBWGZaK2JGOTNs?=
 =?utf-8?B?ZmJKN21ZSGVqTzJDM3IvMUdGVlRWYjJOWWRiWnBqUkdlMmd0Y0RzYnI5RGgv?=
 =?utf-8?B?TjZqd2RiZHRMZXFXcXppRTFWdWMwUFRUdmdaUnNnYWZMOGZ4RGJtaG1pRnM5?=
 =?utf-8?B?VS9TODlRUkRPb2NOeDU1YUtibHk5UGs0TmtMaUxHeTZEcml1OEpLZE1OZld3?=
 =?utf-8?B?Sm5qUVA3WjUwNHZiZm5yRGVtYmN2ZFh2TVNqN21ESEQ0eW9tS0dPekFMaVh0?=
 =?utf-8?B?NjlpemhuNkgzMXFLeURWM1VZMXV6VlNFVC8yKzd4QUovdXpBWkhWZkx0bTJp?=
 =?utf-8?B?T3dYSmxjMGdaVzl5Lzd3VkFCZFRxdHBlMGVudXRJR255bzdWeVh5NnZtc0Qy?=
 =?utf-8?B?TEI4RjBuMFZFZzhkKzV5SWlNcFk1YlViMUhEWlM0QkJ6KzArNW9zTUludXlt?=
 =?utf-8?B?MjhRNngxd0FSS1RVSTBhMHdMbnRTamdzalAvc3RBbUFhS1pqekp5WE93TWFE?=
 =?utf-8?B?ckNncGd0VUdXOVZWVnZ5MXlhZStKT0NvVzNqeW1VQ1ZicWxwdzRJZUNRMlVk?=
 =?utf-8?B?UGxCdkIwSy9MaWVoUm4yQ3hWY1QrSVhwWnJXVkRPdnVWYlJsd2JuRVZaM0F1?=
 =?utf-8?B?WHRYdWdYc0Y4N2Q1K0RHMXFkWTBNZkhrN2dSV1JTa1RBYVpHQUVPUmpNR2ZD?=
 =?utf-8?B?SklEODJ2NDBEcHlFQVZvNzdEcE10TUcxeHpWaDRyQXVOVFRFYTRaWXowWThq?=
 =?utf-8?B?bnRPT1RSSmtOZ1JJU2lIYmRFaWk5MHBuWS9mazdKajBjR2EyM1Q4WllvaFA4?=
 =?utf-8?B?OWRESFJ0bHR3cllhQ3JEN2xoeFJoYVh3ZlEvWFR2K2xTWnhMOVlma0Y3UTlJ?=
 =?utf-8?B?aFJBZG9LTUppeTlvRzNkY1k5R0I4L3FZMnNVb0NqdTdZMnc2Z2JXakVqc2N2?=
 =?utf-8?B?R1hSVS8yZ3BvMHhLT040WURXQ0xhUW1OQXA1TGRpb29mOHpJZWN6aW1keVhP?=
 =?utf-8?B?ZUEvQy9FQmg0R2xWMSs0QWNybmw0aU9OSjJWNDhCTFRGTE1VUmEzTXZZV1dw?=
 =?utf-8?B?UU9KNVBDYWdFeCtoUnF0Y0FLb3RVRmtCaGF5NkI3QXFIbzFnK2NuMWJRUW96?=
 =?utf-8?B?M001MEJkK1BaUHBTMTJRaEp4VW9CZVEvWG1SbjloL0dMeDNGbThNTzhJTHR5?=
 =?utf-8?B?dVNLWGszNG0vUWdpMVhPeGtoWDBPYjNwK2ozRDQ2TVdRMVcxWHUwL1RkWjc5?=
 =?utf-8?B?emFHNnU2OXVlSVNOMWtyWGN1aVRUakdxK25CRTRHRzNscjBUSnljUXB5YnIw?=
 =?utf-8?B?RHd5cksxY1MxVWtjdzlJNFQ5VitRSlcxMnU4eWlwT2E4U3cweUd4bXZTTjJH?=
 =?utf-8?B?ZnJraDVZU3N1NlZzQSt0K2RMME5ybjlCRFdsSVR6Nnc2RkZNZGowb1pDeXZY?=
 =?utf-8?B?TUVBR3E0cURPV3FNVmRKQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWJ3R3NKd2dqeWtzUDRmSXZHcTl4Q2VQd000SHdHWXh1VjBMcC82SUt6VDlY?=
 =?utf-8?B?MytSSkR5RHBSdHVHMWR4SmlQcmhoYjVIVjlUN2xyY1RmZXpYU0I2cndwM1kw?=
 =?utf-8?B?WVMwWU0vZ3ZBbk11K3hhT2dySUpnTmppMHN5ZjJMV2ZZd3BmVFFQMjdHZHM1?=
 =?utf-8?B?V0xvenhHeitVcituaU1FR2dMVCtQQVJEcE44RFBWc09USHZkR2FNWDdTN0JT?=
 =?utf-8?B?M1BCS01mUldHVnFzeU90elNXNTJPSmZTYWZxdTJtUGhmRjlIVWtCV0d2RllK?=
 =?utf-8?B?YzNpb3dGckVvMC83YlFjNWZnTGI5bUpoZHQxRzhNSGFNZDU5cDJqN2FMS3Iv?=
 =?utf-8?B?Q1k5TmFoVTl1cUc4VjRzRGlTVVVBVkZQRzhzck1BMFVCcXlRZk43UVZ3NXBF?=
 =?utf-8?B?TjFCNWNiWHluQmUvZzIvZ1B5S2VUQjVRSVBxTnBqQkoyTHJxZVVCNW1tRXY5?=
 =?utf-8?B?dWFxS21nSU5CWWhyek1YTGIrOGJVMFFQdDZtZWs0WXYybVlJRS9zT0NFN2I1?=
 =?utf-8?B?OHkyWnI3VUUxVjRpdjAzZndsZExtejk4RE93YkNBN21RNENQSWRiL2J5TndI?=
 =?utf-8?B?SlE3aHJqZzJVM3dMU0ZKZXErTnAvd2FTanJlYWFEclBGb2RYcm44eFo2Qlh6?=
 =?utf-8?B?a0FsZ0MzUXJrUEk4SXVoUVY5NHNnQkQyb0RsYlpHOVl3VnFuSDBJY1h1Z241?=
 =?utf-8?B?emRZOU1ZKzcrYytjMmlBSm4zaUh4QklYdldTWXNER0x1L2V6bi9xbXNlTzFi?=
 =?utf-8?B?OHNtTGcreThITXZoTnNqZ1I5NHR2alBGRldsT3dsMkJPWHpxdENSS3dNNkFZ?=
 =?utf-8?B?WDlaUGo4Q2RPaC9RTDhCYXAvTHNFTWFNRlJKUms1RFhvR3pFQlVUZ1N6WDZs?=
 =?utf-8?B?OGxacHd6U056aUdtalhGekpaMnNJSVhxN3JDcXJqMnVrdENZeGV1R3NhMDhS?=
 =?utf-8?B?Q2d1R3pTL0ZKY2VRVFdoRDRFRzlyR2dwbmNqMGMxLytmTVk3WTN2UndRR3dN?=
 =?utf-8?B?TmI2YXp1OS82MWJyRHF3WEttTWtTb0NLcDB5YXd1MzVDT3dzTDc3TjE1UU5Y?=
 =?utf-8?B?azJwZXFiOEhxaFNxMlZ2ZlpNUWRmQ3Y0VUNDbFdHdXQxaUlSN09XQzk1aEVW?=
 =?utf-8?B?T2Zkc2g2SnRNZmVqQVFpV1hvZEQ3c3h0YndhaGRPK2pOZE9QZ2xNSzZwSzNB?=
 =?utf-8?B?dFBFSzkvSUd2MnhzU3NweUF6S08yU1Zrejd0M3E4TjhlRjFwNU5uRDNoRmUx?=
 =?utf-8?B?bHAzRVpYWGIyeThWY1FRb1FtYWNRYTNJcUJxVHplb2JScTEyOXNmN0Q2ZzRz?=
 =?utf-8?B?SkZJa0VrUGlCV1VHakV5bFVOZDlKdldaUFFsRllwZjVGdjRkeFNQb3FtRkRj?=
 =?utf-8?B?ZUdpbnZOZ2lXZmVYVkJCMlhhaDE3K21LK0sreSsyQkxzWUROMUdtUGRXTjBv?=
 =?utf-8?B?RUYrYU95eU94d1BTeFFReHUveldRem5aQXF5MUh4SUs2b0F0dVNEZ1ZQeWZZ?=
 =?utf-8?B?bUQ1bVV2Z3BaUTVkdVJCTlludno2Sm9FcE53UVUrYVJ0b2RMc29vOUFXTUhH?=
 =?utf-8?B?WkJkcG00OTJkYlhkLys3MXFJZWdxR29kS1JDclhKb1NPanpaVWNXdHU1b0xU?=
 =?utf-8?B?MDRGS1J0bFkzS1o1V0lnZThCQXdHOUQ0T1dCemFmNUxnSzlJS1hJSkxKYzZ4?=
 =?utf-8?B?VEpjZGh5bVVnamUrc1BmVVBYUjdtNWNZTlpmSkZMeU1uZGZmNWt3di9ZQ05U?=
 =?utf-8?B?Rm8zVjVSbDhzN0dtak8rM3hoOTBmbHpOQmI3ZTZMQW1oMUlBTGRDRXlWd1lE?=
 =?utf-8?B?S1NaZ1B6UVd1b2pYNkhEeEZXL3pqZ1Bsa01Cb0xwOUxSZytkK2g0bnhYY056?=
 =?utf-8?B?a2FremRUaXgrSnhUNVVYWGg3Z3VqQzQ1bVRBcExyb1JOTFgvZjZ4YTRQWnhp?=
 =?utf-8?B?Z2lCbHU4RWI4WjFaNko4cjdVM0pyYlhBeStRS2N5S1ZZK3ZMb0xzeUdFNE1r?=
 =?utf-8?B?Y25aN1B0WlFsQUl3RVoyVE0yUDJRTGVXZDVRaVdMKzB0TzcySWUveWFPOFVD?=
 =?utf-8?B?L2FicHFjbm9yeVJLQXI4QVl4T2FjSmhZc2IwMERZWmlqMENrNWVTbnJkdFVp?=
 =?utf-8?B?SkdoQjNOc0lJVEdHNkJHa25VcmhZc290UVZoMnZtSU1ub1pDUkZnN1ZJYm9j?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A677E254727314FAE94295D72EEB81A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b61bd6d-5526-418f-b06f-08dc6e27b507
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 23:53:19.9552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zY1FzyDnZ/eqCVuZJzCX1RlRtWIKl0cpIaOvwUQN7+GT2ZiqKOl6ASNXuejVsRT3jQlLvj43nJHc+5f9gQKZ2iDAFWyGa8cJHbVF/so1LY0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6291
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA1LTA2IGF0IDE2OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gSG1tLCBJIGRvbid0IGRpc2FncmVlLCBidXQgSSdtIG5vdCBzdXJlIGl0IG1h
a2VzIHNlbnNlIHRvIHdhaXQgb24gdGhhdA0KPiBkaXNjdXNzaW9uDQo+IHRvIGV4ZW1wdCBJQlQg
ZnJvbSB0aGUgIml0IG11c3QgYmUgc3VwcG9ydGVkIGluIHRoZSBob3N0IiBydWxlLsKgIEkgc3Vz
cGVjdA0KPiB0aGF0DQo+IHR3ZWFraW5nIHRoZSBoYW5kbGluZyBYODZfRkVBVFVSRV9JQlQgb2Yg
d2lsbCBvcGVuIGEgbXVjaCBsYXJnZXIgY2FuIG9mIHdvcm1zLA0KPiBhcyBvdmVyaGF1bGluZyBm
ZWF0dXJlIGZsYWcgaGFuZGxpbmcgaXMgdmVyeSBtdWNoIG9uIHRoZSB4ODYgbWFpbnRhaW5lcnMg
dG9kbw0KPiBsaXN0Lg0KPiANCj4gSU1PLCB0aGUgb2RkcyBvZiB0aGVyZSBiZWluZyBhIGhhcmR3
YXJlIGJ1ZyB0aGF0IG5lY2Vzc2l0YXRlcyBoYXJkIGRpc2FibGluZw0KPiBJQlQNCj4gYXJlIGxv
d2VyIHRoYW4gdGhlIG9kZHMgb2YgS1ZNIHN1cHBvcnQgZm9yIENFVCBsYW5kaW5nIHdlbGwgYmVm
b3JlIHRoZSBmZWF0dXJlDQo+IHN0dWZmIGlzIHNvcnRlZCBvdXQuDQoNCkkgc2VlIGEgZmV3IHJl
YXNvbnMgdG8gdGllIHRvIHRoZSBob3N0IGNwdSBmZWF0dXJlOg0KMS4gRGlzYWJsaW5nIGl0IGJl
Y2F1c2Ugb2Ygc29tZSBIVyBjb25jZXJuLiBJIGFncmVlIHdpdGggeW91ciBhc3Nlc3NtZW50IG9u
IHRoZQ0KY2hhbmNlcy4NCjIuIEhhdmluZyB0aGUgY3B1IGZlYXR1cmUgYmUgZGlzYWJsZWQgYnkg
c29tZSBrZXJuZWwgcGFyYW1ldGVyLCBhbmQgaGF2aW5nIEtWTQ0KdHJ5IHRvIHVzZSBpdCB3aXRo
b3V0IHRoZSBuZWNlc3NhcnkgRlBVIG9yIG90aGVyIGhvc3Qgc3VwcG9ydC4gSXQgY291bGQgY2F1
c2UNCmxvdHMgb2YgcHJvYmxlbXMsIGd1ZXN0LT5ob3N0IERPUywgZXRjLg0KMy4gQ29uZnVzaW9u
IGZvciB0aGUgdXNlciBhYm91dCB3aGljaCBDUFUgZmVhdHVyZXMgYXJlIGFjdHVhbGx5IGluIHVz
ZSBvbiB0aGUNCnN5c3RlbS4gVGhlcmUgaXMgYSBmYWlyIGNoYW5jZSBmb3IgY29tcGF0aWJpbGl0
eSBpc3N1ZXMgdG8gc2hvdyB1cCB3aXRoIENFVC4NClRvZGF5IHRoZXJlIGlzIGNsZWFyY3B1aWQu
IElmIGEgdXNlciB3YXMgaGF2aW5nIGlzc3VlcyB3aXRoIENFVCBhbmQganVzdCB3YW50ZWQNCnRv
IHR1cm4gaXQgb2ZmLCB0aGV5IG1pZ2h0IHVzZSBjbGVhcmNwdWlkIG9yIHNvbWV0aGluZyBlbHNl
IHRvIGp1c3QgZGlzYWJsZSBDRVQuDQpUaGVuIGJvb3QgYSBWTSBhbmQgZmluZCBpdCB3YXMgc3Rp
bGwgZW5hYmxlZC4gRm9yIHNoYWRvdyBzdGFjayB0aGVyZSBpcyBhbHNvDQpub3VzZXJzaHN0ay4N
Cg0KU28sIG15IHR3byBjZW50cywgaXQncyBqdXN0IGFsbCBlYXNpZXIgdG8gcmVhc29uIGFib3V0
IGZvciBldmVyeW9uZSBpZiB5b3UgdGllDQppdCB0byBob3N0IGNwdSBmZWF0dXJlcy4NCg0KSSBk
b24ndCBpbW1lZGlhdGVseSBzZWUgd2hhdCB0cm91YmxlIHdpbGwgYmUgaW4gZ2l2aW5nIGtlcm5l
bCBJQlQgYSBkaXNhYmxlDQpwYXJhbWV0ZXIgdGhhdCBkb2Vzbid0IHRvdWNoIFg4Nl9GRUFUVVJF
X0lCVCBhdCBzb21lIHBvaW50IGluIHRoZSBmdXR1cmUuIFNvcnJ5DQppZiBJJ20gbWlzc2luZyB0
aGUgcG9pbnQuIFNvIGxpa2UsIGlidD1vZmYgZGlzYWJsZXMgYWxsIElCVCBpbmNsdWRpbmcga2Vy
bmVsDQpJQlQsIGtlcm5lbF9pYnQ9b2ZmIGRpc2FibGVzIGtlcm5lbCBJQlQgZW5mb3JjZW1lbnQg
dmlhIGEgZ2xvYmFsIGJvb2wuDQo=

