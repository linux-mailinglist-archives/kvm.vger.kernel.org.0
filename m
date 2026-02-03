Return-Path: <kvm+bounces-70091-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKf6E+togmmETgMAu9opvQ
	(envelope-from <kvm+bounces-70091-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:30:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6162FDEDCE
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 30966300B9C0
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 21:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD72336E497;
	Tue,  3 Feb 2026 21:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iVsODh2H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E250369988;
	Tue,  3 Feb 2026 21:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770154207; cv=fail; b=to2dqHBm+EwCMvSzV/qzyCRR88E5ml4yYeyILuEru1TkyR1pC51wjqtTyqIjdLIno2BqW09gIioJZehG8NXMQJTn5pXTA53lHNBhW8mlB6+Rn0RGbOo7gpQ2JpW6s+TA9jNRftvj8Syv7kr8fLKQ9eAuEpi2SYKObka5IYcE03w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770154207; c=relaxed/simple;
	bh=pY38Q1euf5f0/sma9gbq72xgOEgyD2mxv3DJFZkGPhE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r3oDL1towwM0vS/7bM9+gp/Ft+fCHFFVUN6OEPzhzjP2nmgoryYs+d61E1yLQmZox63J3zl4Xnn5pyHayQkqP0/583y15WURbxtm7m45NbXNOsk3bzesaWEFcs3P7Atny5zofJp6dy0xKnRFCqNJ95HSy57ifpzNZunBz/p4Bws=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iVsODh2H; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770154205; x=1801690205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pY38Q1euf5f0/sma9gbq72xgOEgyD2mxv3DJFZkGPhE=;
  b=iVsODh2HmlcJlGPEdobbGEUTGEQ9TY2//qh7DMK3ctXOAUeqxh+vna4J
   08j0xECWT1C9EpiSynIrmcuVYG2OZMCl3nk8cB5k0lWV2WlWHSMIUjjPq
   vEI44Mu60R9fuqvevOHxH3eQqw91LjhfTcI/vSrINZ6sdmmsbFEmZD4Qd
   8Kb5jglKLsg9+bawK0e8avj8UOrgUqZHwqMY1XlBoEvcv50zsYI0ii6iK
   Vkf4/H/+Kv1yi1xIeb/kVjUsTslyqxfq0B9dGBqU67N2EIsrn0LL8a6A6
   30tyXbGlY4WbCsAB60KkuvNAvoFG9icDeKe/NFkaZcfb8pczapQDZzAx8
   g==;
X-CSE-ConnectionGUID: d3dXrywES5WqY2AOlFpGXQ==
X-CSE-MsgGUID: b2ulvTovSoa3SMivzMIpMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71397512"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="71397512"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 13:30:02 -0800
X-CSE-ConnectionGUID: CDSZPmNUQOCsswTrBSAyVQ==
X-CSE-MsgGUID: 9CdDeGS2Rm+A6OvhrRukKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="240868369"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 13:30:02 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 13:30:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 13:30:01 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.27) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 13:30:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x4vpdDFth5o8OmrqQr1IPjFdnT40eVmWOtGifAsSfVV8rTE1mDKXzyFI5yIeVBdkJTW+Vt/HHN4JrDgmOOT3OkbDrKRGjFstyMn7UyXYHGGIwH2rd/nGczHUjeXkRXQiK51F6VzqsEhvpL+7UU0Y2eVab5IUxVfVtgWuATwtWgHzLRHLWVUGSaw5IZUd6hyIP2PmriguKTMIKxW+wLsiFrtW0CZAsmqTs1+ZBOTYrjNZLcWrX/gaiChoGXY7JcLIL/S4XU3PtZgomtz+SxX5o9f2ljKR/b+g3hJ3WqzTLutIQAD95uLRyrWOa59znHvJjF1Gbvu8TEIWZ2ph83nXoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pY38Q1euf5f0/sma9gbq72xgOEgyD2mxv3DJFZkGPhE=;
 b=CwFJ0gjdEXUt+FKoaTl76zrqcr76WoT20WU+ZM80OiSHGTb/2Zf++IU6Z93I21zeeXNYHprHsyO+rFdt199rMUKpe9KqZx77Ta2Q8hufP3ZrLEk0PDIs1VKvAIAu+6lbBWDHOVv2XH0OKYsuhb7i8yv7RyzqAa5qkOXuMClUpB6gWdbn2dw9sWvhCdt5GQSzTTqKnFnso6vyfuxz8FTt6xeRVYZFpTEs/4B+zx3hhok6PHcpvFn/o3gTlkBWMjBxwck+eUIM347MmZh9KXCl7T3izanbiiq24WgIfOfKElSo3HwyIf70WD9sAfqiArLsTkYKMdrj1OPB5AuEDaRmLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by DM3PPFF28037229.namprd11.prod.outlook.com (2603:10b6:f:fc00::f5f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 3 Feb
 2026 21:29:53 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 21:29:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Annapurve,
 Vishal" <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
Thread-Topic: [RFC PATCH v5 19/45] KVM: Allow owner of kvm_mmu_memory_cache to
 provide a custom page allocator
Thread-Index: AQHckLztHxU2OO4T/UW0cV8EUajfk7Vw1fCAgACbfwCAABWLAA==
Date: Tue, 3 Feb 2026 21:29:53 +0000
Message-ID: <a2bf6a8d9f9b61ae7264afc37d9925cf2e1f3ea9.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-20-seanjc@google.com>
	 <de05853257e9cc66998101943f78a4b7e6e3d741.camel@intel.com>
	 <aYJWvKagesT3FPfI@google.com>
In-Reply-To: <aYJWvKagesT3FPfI@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|DM3PPFF28037229:EE_
x-ms-office365-filtering-correlation-id: 74fb8b91-a907-421b-5643-08de636b5e9e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Qy92dGJ1SmgyRlJPSGI5UWl3VTZxUWV4T1Ura2Q1eVNRTXM2WmsxSDhOSTBW?=
 =?utf-8?B?bVRpRDNYN1hseS9OODN4WWpXZjE3dDlqRHdNSlJxMm0rVmhENHlXWnd2TC8y?=
 =?utf-8?B?SHpGTFpiN0tkV0o0V0laalFvK25IcksvZXp3MW1qUEFGNVVJVE5nd3Y1eXBY?=
 =?utf-8?B?SkxpRytOSGZDZkpJR0M4T1BOVHV5TWdNUVRJbEZvcTJMM0ZFUjg1dkRvUkFF?=
 =?utf-8?B?UDBnQnVPUklESW82M2xLdlZmSFl6d0swMGRqYk9hcWNxeVBWaWVLKzdnMEFR?=
 =?utf-8?B?bk9IK2lvY0hYSGU1MnZjc0hWdnNDR0tFY1ZucFU4NXF2YWxuMUF6aXA4WlhM?=
 =?utf-8?B?TmllRWVqS2R0alV3TEtnVHZucUhjajFBUzNHb1YrZlMxKzZEQ0g3MlU0QnJO?=
 =?utf-8?B?NzA4MnhFRHJCOHRmSTdHMzZQQmE0ZzJyU254bXNzN0h0Nk5rcEJlOUllUDFh?=
 =?utf-8?B?TXZRSGZlcXY0d1FwWkIwUDd6clhSbTFXV21oeEFTVWIzRTRIRExwVk1pR1VD?=
 =?utf-8?B?aUxIU1hKMGJNaFRhZUwwRkdDSnorcE5FRmtKWUgwVUxDdklxNmttTXVHOUFy?=
 =?utf-8?B?anNmWU9PaFdrSDhQSjJrd1V4WENKL0lEZ3lPVWZmSGNqQ1Q0Q0kvMERVS01y?=
 =?utf-8?B?Wkh2S0xaVTZaRkRLT0hIdFE5aXhZcUhtU042aXpyOFc1N1lzZko5ZmNYYk82?=
 =?utf-8?B?YzFhWUtqcXQxbDc3MWF2YjNhKzFwTWVjaU9yM3IzS1NFWkZ4WUJSbnM5bjY5?=
 =?utf-8?B?dnJ5cTZPbHl3OU0wbFE5cTl5bXloR2RONVAwS3Z5alpYWWhmbUlBSEl3RlZI?=
 =?utf-8?B?Z2IxejVkS2xHSFBNQnNxOU8yVHZMVFlOOXBXZWVtRExLZlBDbW02TUZPTFAz?=
 =?utf-8?B?TmZLN2VBQUFqRHR0Rm5qM1JzZExRbnA5c0wzWVFQclpyNkt4RkxMWlFvQ2Q4?=
 =?utf-8?B?SVd6S0wyYWVzS3FzYzVhWXd2UG5yaTNtTDNqekExcytqWWd2RWt0SmFVS0Y0?=
 =?utf-8?B?bjVHU2JmWWJmWklaUlE3dXFkSUpWY3U1TE8zMG5vT2NlTkg1clNQRWFhYTZS?=
 =?utf-8?B?cUZZblZZTkM5NXlGK0Q5SDB3Q29EVE5ySVdWbEZvK2w0ZUpyM0VveDdlTnh3?=
 =?utf-8?B?bDJqRVdJQ3BsYk05aVlUM0sxR0l6Z1ZIT002U3dOSVpFYXV5Z2I4b3piSVR0?=
 =?utf-8?B?WTJQZ0hRNzhTa1hrTEhtMGVSYXBjRFkrQTNOWUlSV0RPelVkeDNwOVh2T2Jj?=
 =?utf-8?B?T3FmVkNJV0Y4b1p2VXYyWWVDY3U4Z3NPMTVWN1NxOHpCZm1pN0Q4akp1ajha?=
 =?utf-8?B?WE9VdlJEbnVIM2dDSSt0TWY3VSthM05UUzB0eExtMkFGS1NmQUpQK2NTUnRB?=
 =?utf-8?B?Z3FoWDd2MCs3cXVuRHVDTWpYdHA1L1ZIMU5EV2NKM0c0b2VOc0dPYkFVVlZJ?=
 =?utf-8?B?QkRxd2hhdXlwbWNWVkx0Q2s2b1h1ZnhNYTV4elJ3cVFXSkNxdllSaWZ4L29Z?=
 =?utf-8?B?ZVlMcVh0RmhpZDh1bEkxdkRNdmFteTh5ZUw3TThYVEdzcVVLcnBaZCtxOGty?=
 =?utf-8?B?dGpFNkpwZi9NQ3pKbkxCZWFRdjk3ZzJoazVNQWVVdmpyOTBHSmJFSWV0RWxp?=
 =?utf-8?B?cTRWQjUxVkFURWRpNnhKbHhMd2NFcytMTmx3VklSSFlSMnBvcG91d2hPdFov?=
 =?utf-8?B?dUZIUTBHUVNPbUEwQUs1WHdZckRJeVJSb1MvYUFvQWlYV3Y0ZkhMOHd2a0lF?=
 =?utf-8?B?bkw5N3VROUNvUDM4NUQ5S1R3cGZHYUZ5MnNEZTBqTUtRemt5UU1zVUVjK3B6?=
 =?utf-8?B?RWV3dzJYQkJPWDJ4MUlpckdxU1B5SnJnVkpja3BFQVVjd0pjWVhrK1Jra21w?=
 =?utf-8?B?SlJTeTI1VE5SV0dWYXV6b2JqUytKNVd1Q0w3ZnpKM0R3bnZVbVl6WlhDVW8y?=
 =?utf-8?B?dXZYL1JqcFhkMXN4d1c1VXdxRWRrbUZpT3lwVWc0NlNXNjhHRkxnN3V4V1RD?=
 =?utf-8?B?cHdwNjJoWENWMnA1amdMSllXM3NUenhHTzArVUxlSUJ4Y2dadVJpbmR0V1Ew?=
 =?utf-8?B?UVJ1Q3ptb3RhRmhxZkZVbi9jWU1zMXRyNk1yMUMvdnFTbjVpOE55SXNITWpL?=
 =?utf-8?B?Z2NxdXdwek1DdnNXV3ZQU0Z1NERSN1RQcjlIZzF5S2dJdzBlRXRMeWdGQlkr?=
 =?utf-8?Q?SaAT78rVIyWonFPpgT44OF0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dnZaTnpuWkU5RWdNUkNYaVVVSzUvcWlXK3pWbDhTUWwxT25pb2prdnNUaTIz?=
 =?utf-8?B?cXpnQU1DejUxUHQ2OWpkNGpiMHZTOTNXeE5jS0dpUUJEY1pxdndrS1NhMU04?=
 =?utf-8?B?MDJZVUpJNkxDUVV0ZGk4bnMvVm5Mbjk2RmtzWlFoYjNlS3JtenNOLzAyOUxN?=
 =?utf-8?B?MjVKMTdRV21LS3oybWswZ05tbFFkKzRLTWZNbW81WXBEOXZTUG1heTllK3VR?=
 =?utf-8?B?K2laQWplQnQvbFR2WWI1NFkzSkFaMWtmM0plWkZJU1dYa3BwNk1ybUdMRXRW?=
 =?utf-8?B?ZnhmWmpHU3JGb1NaSUx0cGlkQXNjY1NxWm1ObVZDTW56WUJ5bmhHNlZaUWVH?=
 =?utf-8?B?YndNcmhuMzNRNnExTnZJL2xjNmFFVjQvWUJxaGJZbTRyUjBneGRKVFBKeFc2?=
 =?utf-8?B?M1FKcklqUzVrblM4N1ZLTlZRdW1RZm8rMFFOazdPWTZxZjZqU001bWx4am5E?=
 =?utf-8?B?R1d5U24rOXVJUkswa2IycWFEVDNQSEp2TXlWQTVMckQxWlJxU0VuU2hCZXpL?=
 =?utf-8?B?YmhqZGNlZXFETTFZRDBxSWpIN09KU3gralZPNW5lSmZFS2I3WWsrbnQ3Tms3?=
 =?utf-8?B?TEMxQ3cyelZ5ZVpWdGExQTY3Qjlxb3Zjak5uRm1iaElQb3cvU0l0Z0RmWE5O?=
 =?utf-8?B?aHRUTWU0SnFsZm5LTzVMYnFGTFJYT2t5OTFUWVo2OFJrNFY4QzhLWEk5aURB?=
 =?utf-8?B?Q1FZY3NaaFNGOWRTamR5cG12VFRVdXhneWlYWWIrOUNYR0FzaFR1Q25jZXh3?=
 =?utf-8?B?UHZTWnZUdkZMYmMzQlFBVmYyYmRqTnp0MDZJKzJ3ekgvVG5qUWdOSmN1cjVK?=
 =?utf-8?B?WU80TUJZeGo1Vk9IV2MzN0tPZzdZNFZDUXlrbHhSbUpsVTUxaTJOQitQdUpB?=
 =?utf-8?B?MkpKNG1xdFFDRm0zNXh0Vk56WGY1UzEzVVdJZnNhU3gxenovK0xkTHhJS1V6?=
 =?utf-8?B?TDh4UC9BQlEweUVEQlV0QjZONmRhdVFiNTlLN0E5cldVMmV4K3F0TWZIdGhE?=
 =?utf-8?B?Q0tRNlgxeFVvU0I5UExaUU40MWl0OWNmbnNXdG5NQmdreU1YR0FBZkJ3U2ls?=
 =?utf-8?B?WlVnaHhlaERQTkZJY3lzb1RCQXJSdmd1OVcvbWp5dC9LNlV0ZUpoYlFYbEE0?=
 =?utf-8?B?VU4xNDA2TXZUbG5EUWxFTGZVSUdNc1ZlNW9mU3ErZGJRV1hjZ3Vxc3hGZ0hD?=
 =?utf-8?B?cHRaY2J0ZW12bU1BdFBBOHZ3bTVOQ1hBYVlJV3VNbjVad2NpQUpiWlRBc09M?=
 =?utf-8?B?MG1hdGgrb2lSc0h1bDZiOTJhVjh2M1JCc1k5czZVVTU0SHgySWNqb0I1RE8y?=
 =?utf-8?B?d1hYUkRpbGJZWFJMcUxQUXorUzA2bXJzQVY5QURVUDZoTFZ6TVhrdzRDd2Vh?=
 =?utf-8?B?VXNBblpkeUNjeFR1QmlGWVg3bWdTM3RUcU55Mng1S1I3SllNdFFISE50YUxO?=
 =?utf-8?B?TGNaMW9KeEJGUllITGxCTnFFNDI3QjNFdmxxREc2NjFrM0VGSFNINUhIK2ds?=
 =?utf-8?B?SUJoNnVabGdOUDFtdjFGZkhSOEtRWG1QQlZvWTE5M29zWHBRR01DbWh6b0tG?=
 =?utf-8?B?RUxtbWVkcGU0bFdqNENyT2pYVHVRTlZCaS85Mzg5NXI5cytpYW5GZGU2ZmRw?=
 =?utf-8?B?RHFUZjlqR2ZQeExUL1A4VnQvWlZQd0hQWnlWYm9rWTBwbENCMnhPckZ4VkQr?=
 =?utf-8?B?V1dHT1ZqSEdnQUN3OXp1VTFNSDVjdGh4MDFnZWV1akVwQnQ2TWE4M3dRaFJv?=
 =?utf-8?B?aUtsd3U0Sjc2UTJQS0svSkYxdDNHeW1ZcjBGZWhUWFZ5b2tLelVWaisxNzRm?=
 =?utf-8?B?K2c4dEQwVnlBTnJySWh6M2wrZUFpUjUxRzgzUEcwWVhyMnIxeHREaVZSS1Nw?=
 =?utf-8?B?RnpzcG44L2tqMFI4WUZ3ZjNnS3B1dFdOTFVFRzQ2Nk5MbG5UTzZOazdiMW90?=
 =?utf-8?B?WUVsYnJNSjROMzFWSXJYUDNHWE1NOEQvKzQ1NU41cnZOL0pVN0M1cHB2MnBv?=
 =?utf-8?B?Wm9GREdBMFZ2TDNpVkJpQVpBWk03bUx1NkFNNGZXenp5d3VSeDc3WnhsTHR1?=
 =?utf-8?B?VVRmYVlrT2Rkd001ZjhPcGNyOURPcWtkM24rSTBZaE52WldrTUhsT0R3WmQz?=
 =?utf-8?B?UzdObjRzanl1TDlRRHFQQ1RmTGFUZlpldVVJcXFrOHhQUFRqMnJnYWFoR2xU?=
 =?utf-8?B?QTk4VTlnelpRUmwrTnpiOUxWNWxwSHNkWVJQZC9odnI5M3gwaHRneUtuTDQz?=
 =?utf-8?B?dWgvWXZGV2pkT3hLSVBFeDJRWlNGYndiazcxNlp6VVNPczFqTGU2Y09Pc0RY?=
 =?utf-8?B?RSs0Mmd3Wjlsb2ZOODNNTWFaQzlYa21xaXJDemlqZEpBbnZvaGdSZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFED75531347484EBC6268B2616A9183@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74fb8b91-a907-421b-5643-08de636b5e9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 21:29:53.2457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y2td3V2SbcfPWnIjg1dBfgJFmCJtHHSN9W4P1/qwC7lLeG3pjk3iA2mI5xESAWX3z3VFF8jNIqPHFrYTn03vtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFF28037229
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70091-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[19];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 6162FDEDCE
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTAzIGF0IDEyOjEyIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEZlYiAwMywgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNi0wMS0yOCBhdCAxNzoxNCAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEV4dGVuZCAic3RydWN0IGt2bV9tbXVfbWVtb3J5X2NhY2hlIiB0byBzdXBwb3J0IGEg
Y3VzdG9tIHBhZ2UgYWxsb2NhdG9yDQo+ID4gPiBzbyB0aGF0IHg4NidzIFREWCBjYW4gdXBkYXRl
IHBlci1wYWdlIG1ldGFkYXRhIG9uIGFsbG9jYXRpb24gYW5kIGZyZWUoKS4NCj4gPiA+IA0KPiA+
ID4gTmFtZSB0aGUgYWxsb2NhdG9yIHBhZ2VfZ2V0KCkgdG8gYWxpZ24gd2l0aCBfX2dldF9mcmVl
X3BhZ2UoKSwgZS5nLiB0bw0KPiA+ID4gY29tbXVuaWNhdGUgdGhhdCBpdCByZXR1cm5zIGFuICJ1
bnNpZ25lZCBsb25nIiwgbm90IGEgInN0cnVjdCBwYWdlIiwgYW5kDQo+ID4gPiB0byBhdm9pZCBj
b2xsaXNpb25zIHdpdGggbWFjcm9zLCBlLmcuIHdpdGggYWxsb2NfcGFnZS4NCj4gPiA+IA0KPiA+
ID4gU3VnZ2VzdGVkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4g
PiANCj4gPiBJIHRob3VnaHQgaXQgY291bGQgYmUgbW9yZSBnZW5lcmljIGZvciBhbGxvY2F0aW5n
IGFuIG9iamVjdCwgYnV0IG5vdCBqdXN0IGENCj4gPiBwYWdlLg0KPiA+IA0KPiA+IEUuZy4sIEkg
dGhvdWdodCB3ZSBtaWdodCBiZSBhYmxlIHRvIHVzZSBpdCB0byBhbGxvY2F0ZSBhIHN0cnVjdHVy
ZSB3aGljaCBoYXMNCj4gPiAicGFpciBvZiBEUEFNVCBwYWdlcyIgc28gaXQgY291bGQgYmUgYXNz
aWduZWQgdG8gJ3N0cnVjdCBrdm1fbW11X3BhZ2UnLiAgQnV0DQo+ID4gaXQgc2VlbXMgeW91IGFi
YW5kb25lZCB0aGlzIGlkZWEuICBNYXkgSSBhc2sgd2h5PyAgSnVzdCB3YW50IHRvIHVuZGVyc3Rh
bmQNCj4gPiB0aGUgcmVhc29uaW5nIGhlcmUuDQo+IA0KPiBCZWNhdXNlIHRoYXQgcmVxdWlyZXMg
bW9yZSBjb21wbGV4aXR5IGFuZCB0aGVyZSdzIG5vIGtub3duIHVzZSBjYXNlLCBhbmQgSSBkb24n
dA0KPiBzZWUgYW4gb2J2aW91cyB3YXkgZm9yIGEgdXNlIGNhc2UgdG8gY29tZSBhbG9uZy4gIEFs
bCBvZiB0aGUgbW90aXZpYXRpb25zIGZvciBhDQo+IGN1c3RvbSBhbGxvY2F0aW9uIHNjaGVtZSB0
aGF0IEkgY2FuIHRoaW5rIG9mIGFwcGx5IG9ubHkgdG8gZnVsbCBwYWdlcywgb3IgZml0DQo+IG5p
Y2VseSBpbiBhIGttZW1fY2FjaGUuDQo+IA0KPiBTcGVjaWZpY2FsbHksIHRoZSAiY2FjaGUiIGxv
Z2ljIGlzIGFscmVhZHkgYmlmdXJjYXRlZCBiZXR3ZWVuICJrbWVtX2NhY2hlJyBhbmQNCj4gInBh
Z2UiIHVzYWdlLiAgRnVydGhlciBzcGxpdHRpbmcgdGhlICJwYWdlIiBjYXNlIGRvZXNuJ3QgcmVx
dWlyZSBtb2RpZmljYXRpb25zIHRvDQo+IHRoZSAia21lbV9jYWNoZSIgY2FzZSwgd2hlcmVhcyBw
cm92aWRpbmcgYSBmdWxseSBnZW5lcmljIHNvbHV0aW9uIHdvdWxkIHJlcXVpcmUNCj4gYWRkaXRp
b25hbCBjaGFuZ2VzLCBlLmcuIHRvIGhhbmRsZSB0aGlzIGNvZGU6DQo+IA0KPiAJcGFnZSA9ICh2
b2lkICopX19nZXRfZnJlZV9wYWdlKGdmcF9mbGFncyk7DQo+IAlpZiAocGFnZSAmJiBtYy0+aW5p
dF92YWx1ZSkNCj4gCQltZW1zZXQ2NChwYWdlLCBtYy0+aW5pdF92YWx1ZSwgUEFHRV9TSVpFIC8g
c2l6ZW9mKHU2NCkpOw0KPiANCj4gSXQgY2VydGFpbmx5IHdvdWxkbid0IGJlIG11Y2ggY29tcGxl
eGl0eSwgYnV0IHRoaXMgY29kZSBpcyBhbHJlYWR5IGEgYml0IGF3a3dhcmQsDQo+IHNvIEkgZG9u
J3QgdGhpbmsgaXQgbWFrZXMgc2Vuc2UgdG8gYWRkIHN1cHBvcnQgZm9yIHNvbWV0aGluZyB0aGF0
IHdpbGwgcHJvYmFibHkNCj4gbmV2ZXIgYmUgdXNlZC4NCg0KRm9yIHRoaXMgcGFydGljdWxhciBw
aWVjZSBvZiBjb2RlLCB3ZSBjYW4gYWRkIGEgaGVscGVyIGZvciBhbGxvY2F0aW5nIG5vcm1hbA0K
cGFnZSB0YWJsZSBwYWdlcywgZ2V0IHJpZCBvZiBtYy0+aW5pdF92YWx1ZSBjb21wbGV0ZWx5IGFu
ZCBob29rIG1jLQ0KPnBhZ2VfZ2V0KCkgdG8gdGhhdCBoZWxwZXIuDQoNCkEgYm9udXMgaXMgd2Ug
Y2FuIHRoZW4gY2FsbCB0aGF0IGhlbHBlciBpbiBhbGwgcGxhY2VzIHdoZW4gS1ZNIG5lZWRzIHRv
DQphbGxvY2F0ZSBhIHBhZ2UgZm9yIG5vcm1hbCBwYWdlIHRhYmxlIGluc3RlYWQgb2YganVzdCBj
YWxsaW5nDQpnZXRfemVyb2RfcGFnZXMoKSBkaXJlY3RseSwgZS5nLiwgbGlrZSB0aGUgb25lIGlu
DQp0ZHBfbW11X2FsbG9jX3NwX2Zvcl9zcGxpdCgpLCBzbyB0aGF0IHdlIGNhbiBoYXZlIGEgY29u
c2lzdGVudCB3YXkgZm9yDQphbGxvY2F0aW5nIG5vcm1hbCBwYWdlIHRhYmxlIHBhZ2VzLg0K

