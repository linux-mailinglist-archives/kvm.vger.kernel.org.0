Return-Path: <kvm+bounces-59219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66693BAE505
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 20:29:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79CA27A5F1C
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC6326B742;
	Tue, 30 Sep 2025 18:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YTPW4pR3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D79920FA81;
	Tue, 30 Sep 2025 18:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759256981; cv=fail; b=DrsQkDqOBWSqMjIlpmc3FqLipQtNTw2wcxxHVoBkfiqY4NejFG81Ll3TvrV5MeFiUp9/srXwQf69AbmRnlpzN1+hr7W+rUWa4nhNpzci9XzaxEb0zuFg4p/ZTz4nk+AbcO24jAQ5MftXjyaDbl6LNPaWcvBacA+5alvMB3gitbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759256981; c=relaxed/simple;
	bh=wZdEY8dJKg+SV7Im7YDZD3PIAqdZVYPXJ25XEotfh9c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cpvBMPCLeKHHYU8/RjIHF51xkb0irlstpWFxf6pMhRK3uTauJbi9s84WUMHo6lY6ZECndmQXBI929GtiYkYJpYGA6ixl2IGafihMDGoEIruU+8O9j+JBi9HYy4KYaQfVPNd6Juxl4Zru8flqMwWXJWpvHAu8fcKJHfjKtKGisGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YTPW4pR3; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759256980; x=1790792980;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wZdEY8dJKg+SV7Im7YDZD3PIAqdZVYPXJ25XEotfh9c=;
  b=YTPW4pR3WDGh7DcrvLoy3Pef/7j0ll75A0FUNpoBuno7t4Lk3jcFNFgC
   kxRDCe3fxhQztYqxcZQk1fXNajcT+Z8pEsMnzCcaGa8HyeZMhfMR2KRhb
   ddf4LgUOJrbce/33mJpBzl8tHDS0D/IDMCbbl6y+saXc07OiCJVKlqYu3
   Kys+GujeWft/x4b2dcW8DCxh5yitP/A4MFyTClHTZacvfv1irYDTszQl/
   jPzLaAskRSz/QDdRtYXiNrEJ96wUu7ztfusmBd5IH6bcB+9J/Dw2T6Baw
   IkXZcTT9bO5nF3XgXa6dkOWjp7AOcPoLiyB+vUVVUMNuE0udS7NiGc1iL
   Q==;
X-CSE-ConnectionGUID: muyv8q8kSfurnZNrU85Kjw==
X-CSE-MsgGUID: 3f1JIEMKQ6OxXXo2ajFALw==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="72140839"
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="72140839"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 11:29:39 -0700
X-CSE-ConnectionGUID: YFy9Iy/8RpWrkp+NixP6tg==
X-CSE-MsgGUID: RJIRmzyXSmidwyipkbJATQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="215725249"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 11:29:38 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 11:29:37 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 11:29:37 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.18) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 11:29:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QnJqKnsZQFvvlKTYzFUpf824iNKqnYXOppIjRcVEVGppfpLMGegJBpbR2uOhy5mWsPLW8TMcvUXlga85Q7hfraV1+tqIU5xLxqNAY7xU92yQfMeFpUeBVQDmgGaVCyAcUu3E4Pu2yvugEZOhEOjuVLPD0J7CFgocedcCXaOOL46QqCwuRkzrwDr5tSVwDtXVuNZAvB0ls6W5l6Og7fiQ92OwabXoYNd9Ub0HC5+/FV5SUYzXHWJC/kZoewtJmQTbnD8EbBcWhw1sp8xa1FeNoiXjZ4FTrT1xNVIFBshJpjSWAHu1TKmyyXV7RJYV7/cZR2skOUA/ozhDULn8PvuFUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZdEY8dJKg+SV7Im7YDZD3PIAqdZVYPXJ25XEotfh9c=;
 b=PSh3kVjSjiGju2e5wb2HL8XCqxPI0yONN5SaIBRuULzzxsq/effYPCRu8ZUshr6/XJjnUZpBxrAN2mK6SZBES5+6/KHSMICXhFPlp06CsNaCR3xjyl0lF++g44423vfjfgBmMqk/p9dFCOdrv+NwjPN7Sy31jWgZPPIapL3KKItrqZLcaFZX0ifcka3ESTRzlBNFtgTCwjaTKbAMu00t4CUI8Xapjxzs0ULJAWSBICNslFpcbUgrp/JIJQOKC7Ot+epvYGWt3y6XUVBjxzOjgTXzEla8IhPw8ON13L7ji9IKbwQqC0dXp+WY0vQFI8eqo9D1d/3RESdivyWSiXLLqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Tue, 30 Sep
 2025 18:29:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 18:29:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Topic: [PATCH v3 00/16] TDX: Enable Dynamic PAMT
Thread-Index: AQHcKPMxbI3n4d0yEEyHrd2rA1fcBLSkyKKAgADDrQCAAB+VAIAAAsIAgAAvCACAAgBqAIACNVcAgABVQQCAAAn0AIABq8qA
Date: Tue, 30 Sep 2025 18:29:33 +0000
Message-ID: <c5115ecbf5b6e3b135f91a5ccc2bf1aa8cdcf0b1.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <aNX6V6OSIwly1hu4@yzhao56-desk.sh.intel.com>
	 <8f772a23-ea7f-40eb-8852-49f5e3e16c15@intel.com>
	 <2b951e427c3f3f06fc310d151b7c9e960c32ec3f.camel@intel.com>
	 <7927271c-61e6-4f90-9127-c855a92fe766@intel.com>
	 <2fc6595ba9b2b3dc59a251fbac33daa73a107a92.camel@intel.com>
	 <aNiQlgY5fkz4mY0l@yzhao56-desk.sh.intel.com>
	 <x5wtf2whjjofaxufloomkebek4wnaiyjnteguanpw3ijdaer6q@daize5ngmfcl>
	 <0fc9a9ed-b0ba-45fc-8bd2-1bf24c14ab7f@intel.com>
	 <9f12fd82fec7fb4fa99ef51a4a80b9fe08c0001a.camel@intel.com>
In-Reply-To: <9f12fd82fec7fb4fa99ef51a4a80b9fe08c0001a.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6366:EE_
x-ms-office365-filtering-correlation-id: a004cb10-8625-4c63-a25c-08de004f4dcb
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RkpvRFBTT25yTWlNaG1oOVhodGxoQnFZWHNYUXFnNHpPN0FOM3pMTlpMcVBy?=
 =?utf-8?B?bVJMcTAxem42SElaaDJPaWVLOUd0QWxZUUEvb0JVRVUwbVVOUUwvY2h2L3oy?=
 =?utf-8?B?K1F0ZTM1MDlEL08rTExuNDRmSFNIL01mb3NnbUxZelU1MzZYZmhNVFAxTkNM?=
 =?utf-8?B?d3pEU0ZveWFQRXlpM3BZRmVwZDJJV1ZZVi9ab1krSEdSTzYvM0hIcCtocWNL?=
 =?utf-8?B?ZmpRYmVGc1ViQjA4RFphMXJPRHpnTmdHVGwwdG1hOU5Ra1hxTUg2S0h0blV2?=
 =?utf-8?B?SXJBMVBRU29Fb29yQnhqNndzTGZ2YnNkTjdwc0tLMHpweVlWeklvbURTMzV1?=
 =?utf-8?B?T3RxR2JRc0VaaStPTlRmNmNoeFJscnlOem91VGUyWTRmZUhFc1FYelV1RzF1?=
 =?utf-8?B?VXVwWTF2VjNJVGVlU0ErNXJtdVpYTWtBay9OSysrZVZKajZYMXgwRE1FNENE?=
 =?utf-8?B?ZUhUendhZ1d2K2Ryb01Mc2tZazBMR29WY2pqWnJqa0x1SGY1RDJWVit1YmRF?=
 =?utf-8?B?bW4xdVdSTFU5VlhGNlVmUEhJLzhpMXI0eTJ2Wlh0QUtWeldPUHhjTjVwSlBD?=
 =?utf-8?B?K2hwSGhaMTZISlBMOE5ybTVGOFkydlJQaklnSWhzTUZFeEllTzdVS2hOY3J6?=
 =?utf-8?B?UkRvWTRZUnFMTU9CbXZYaTRZNXN2KzU2cTN1cG85dXVtSEQvRU5PenJhRnl6?=
 =?utf-8?B?YWtMdXA2cFE1Z3F6WG5uS0xGZTdKZ0s5aEFPc3hPOS9VNkx1U04vdGNrVXpQ?=
 =?utf-8?B?ajIyYmxwZW1RNWlWcFB5MG9UdHgwT1lUZTBMcWp4akR3M3Z6R0VEQWRZeE5R?=
 =?utf-8?B?V1EzUDFIT2paeGhMUlRrOFQxQmR2Y0F3RDJsVXlQc21wY3l4bmNGT3l3WmRl?=
 =?utf-8?B?eXIrNUp3a2NhbWYvTG9BMjl3aFNabFhSbnhLemNmTjJ4bHRDS2ZvT25YTGht?=
 =?utf-8?B?c2cvQ3h2N000aFowbms1djZqWXVKUVMwUWZiSWFmU0RtODlCdjFyRGFobVFj?=
 =?utf-8?B?S2ZZUlpyRkNLRm15WVdCVm5jRWptNXhOQmRwNW1ZbkZiRnlKTG10enNvaDZD?=
 =?utf-8?B?Wm55czEzZ2pmVUpBdU41Nll1V2dHRUEzRGwwMWxxOGNPNlEvZks1RkRiczNY?=
 =?utf-8?B?YzFPKzFDbEdxL05CMVJhNVpkNTFsZHRQWk1JeXRaZ212VjRKUnVmaXZsbEY3?=
 =?utf-8?B?ZEpaaHdtZ0pzck9JMVBUU05mcFVSQktBY0FHWVZSaEdvZEEvT3I1NzQxMjVu?=
 =?utf-8?B?SGRwK2M5Z1NiWHVoLzNJd3NHMUV1enAycFlIcVZSUk1SSVlUWlEwd2NFOGNl?=
 =?utf-8?B?Qlk2eml6NlRrb2ZoNzMyd0VTOGVtM2FMMGZaRkIwUWx0NU1YbnNYOHFsVXly?=
 =?utf-8?B?THd2MDh4d29XUmgwbmkvbDlDYmRzaURXUkI1MkZyRCtDVjd2TkxXREcxd09z?=
 =?utf-8?B?SE01SUhnOGVYRlpTWGR6RFYxV3JlTDlIRVpqZ25yemlmeXlhZ2ZScUpxMzlR?=
 =?utf-8?B?RjhjNjUvOXhoUVAvRXpPaXNyempRNldhby95eXJRWFY4eFdhWXU4aDlRbWF4?=
 =?utf-8?B?Q2tQWjBQL2hZU0lVYUZIRjRxS0lrTEwwbHIrWHhCUEkwZFBNQStyMGZMMkR1?=
 =?utf-8?B?NjNXSFhGeDhGM2xTb0F4b2Z1UjRiNmJ2ZG9mVW9OVXdkOW1HbWRINlNFbUxE?=
 =?utf-8?B?Vm9iQ3FMcm42RU1tYm1jT2gzbW5mNTNRQ0ptNjVaSUNIWWpEVm5tVTNIRkxZ?=
 =?utf-8?B?aW5POUFDUnZPZGJVUmFpenJpR2RKdnYxUm1xamJiNWN1OFdKYXUrTitwTHU5?=
 =?utf-8?B?ZVVJY3o0Y3IwbkFGWmtUNHFsYTlWVS8rS0toOUx1QVR2UTZIVms1QmxWbWYv?=
 =?utf-8?B?aEdEZDVSUDJoTWk5Y0xGeU1MSENEMzFqVFdrL0hVU21lbXRBTUxsZzhkRWxw?=
 =?utf-8?B?Wi9FWU0zRnVLektWSTh3L2NhQ0ZCNUFWS3lqTE5BYlJsZGxsdGFWSHliTHlD?=
 =?utf-8?B?YjFFcTI1UXhxNEN1ZE01YnpjV1FqTGZJMVBWSFVSM1RlSWR5RXhXTVFRRTlB?=
 =?utf-8?Q?a82uof?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sk1sbkFoUHZDaUF0N3JvUUJhUHo2cWtqMFhjQ0dZNURiUkpWZC9NQ2RTU29P?=
 =?utf-8?B?MmlCdzFkUXFHclZQTGVHRnZOS21leC9BNGpDV3JnMytEQVJ3b2ZNNzMrOTJ4?=
 =?utf-8?B?d2JBR29NcDJQNWNsUHdSeXlDanlyMWd2TXl3UU5QYjhTT1cxM1RuNnJsUnZS?=
 =?utf-8?B?aFVoL01nTmdGWEZDTUMrU0dJTUZHNU5MYThFNkVJY3R6ZStra2g5UGwydWZy?=
 =?utf-8?B?RjJOdDMwZFhOcEg4L0pCdWNNN1RYbXhsN3ZKcnZZN1VpdXI4MW1HN2Fsd0Vw?=
 =?utf-8?B?MVBrMkc0dmRGa1RQY2VqYW9vOUhYamlkRytQTXZzeThGaytHN1RXeUlBREhz?=
 =?utf-8?B?SmxYMS9UaWhEOVBVK1FRQlJqSFVOTlA0SjN2UzV1VDBYZmJwbmwydjBDTjUz?=
 =?utf-8?B?bFhhRFh5akdRdzFRdTU1WTFlREE3cEl2d1duYnIxQ2JIQ0hLM1RyZU5MMWts?=
 =?utf-8?B?bWxlZEc4UDVSeSs2eS95aUJicHhCMjlkem1ZeTdXTkVxdHM5RXpnUlBjbFY1?=
 =?utf-8?B?TEVSbFgrcHF6RXhaMWhONjc2OU5LRXhsd0NVcWFIV0ZrSGh6UlBmb0pKZnBy?=
 =?utf-8?B?aGxITzFmU29hNVRHS2g3NnhoLzN0QUhSc2UzUDNkLzBOTk5JUEpvYkRWcGUv?=
 =?utf-8?B?QU5VV2RNN00zWlg0S05hS3NlY0VhQ0kwSkdUMUxHYTRuYzVtNW1DeWN1RzFh?=
 =?utf-8?B?NmxycDdTWjd3dlovSDduL2Y0MUlMaWsvRndTZzVKOWpaUlZjTEFhcGMxZU5I?=
 =?utf-8?B?MnVFVTRLdDhiMDNIc1ZwMm1vdVJOUWNkbzVEY1hVTEtlUW9nSGxPLzFhYVht?=
 =?utf-8?B?b2g3aWJHSHNKa1d3M1h5NjRaS1NSVkRaT0ltZDRCSnpOMnZya2tvNGJGb1Jk?=
 =?utf-8?B?Nm1pZFlRTXNzN3ZwTFpxK3E0YVhTbmR2MWtaMVNacDJQSEI3SjFsOHVDYVdQ?=
 =?utf-8?B?QW04TUNvNmZBcVI2WEhDRHU0amZLNVdMd3hyNjZsaVpsVWtZOTZ0dnZOSklW?=
 =?utf-8?B?ejBJNVI3cFlqYlZvTVpOVGxQL2tVWTUrNUlpamRrUXU3cXZUSTVmTDEydklS?=
 =?utf-8?B?eTZXRkFLUlpUYk1rbTJkWEsvYnZ1Q3Z1a2hvNDNJQ21lMHhsR2ZQRE02SC9L?=
 =?utf-8?B?dXphbFNTZEJZWXlZQTE1bXQ2bnpJTjlVV0o5YWkvY3BOM2RWNzZhSVVWdURI?=
 =?utf-8?B?STNLVUxDeTNxc055cDFZUU0rdWVzY2syL0NCWllnSUtRR3pZQWc1ZTNkVVEy?=
 =?utf-8?B?a0JiRkxmcWNqM3paazZ3ZVZHamkyRTI3MkZ6VmM5UDg0UkxzL0Z4RERvbFZk?=
 =?utf-8?B?QmxSMnE3NEwzdkF0SEp2YmtqSWNFUkFtTURQSy96T3E1bzFCcC9razljQkZy?=
 =?utf-8?B?cHNxYkdjMWJmanpGeDBhNys4bHJDMWYrNE5KeG9aUmdEWmdhOHozbVhrS0Zi?=
 =?utf-8?B?NTd5Wkp6MFp6M2o5UnlQaUszaWlqeGVjVyt3NDUvKzdyUUc5S0ZTZWk2NUVV?=
 =?utf-8?B?b3BILy9WcnhQS3NWN0tMMlY0YnI4em44eEoxZkNQeWRRTTVzUDY0ajh4bkpY?=
 =?utf-8?B?RjhNM3Z4L2xob2Q3WS8yTWdxanI3S0k0N3ZYV3V6K2l1aDVkS2dnZnBJcTly?=
 =?utf-8?B?eUJ3cTdyMzFkZG1wVW9LVTZzK1dKNVJRZW1jOVR5Y2VzcWwyblh2a1lmaU93?=
 =?utf-8?B?dVVxMUE5bngyNlVENndzVjRqVmYrL1lUUzVhNWRBd2V0MXRsNTQxZ3BUK3Vy?=
 =?utf-8?B?SjBsU3R1L1lQUHVWZTk4ejdmVVVsclNRaFhKTXBXaDNEYU9VWTVsb1lEU2Z1?=
 =?utf-8?B?SXQvU1lMclAxWG15eGVMVThtTVpYZlVScXhzajl1dEpHLzdFY2hMUjZyZzVP?=
 =?utf-8?B?SGFYYU9GMkROVGhWUWI4UEpnM0Z4M0RIZ2g5NmpVaVJjYmNVZWo2aGorOE1T?=
 =?utf-8?B?NE1TUmwxY0JoQ2ZUVnc2TlZGUkhBemR6cmY3VGxSTDlBRGRKeW1NZ2dZMnk1?=
 =?utf-8?B?MVlRWStSVmt6UEhYaG1DSVlVRGV6V2NNWjZpbDZtdTRiVGV6R2lOSjg5bnY1?=
 =?utf-8?B?bXN0aTNDTHRzc3JPWWgzbG9rSUY0NjV5alJ5RTlXUENkT0dGcGVSOHRDMnZM?=
 =?utf-8?B?TWEzM3N6b1dyeUpHSGVKditRWXI2QnFEa3Z1OXdEeWMxUHVRNTl6RG5WM0R1?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <565F1F541AD3FC4E924E7A90DEEFDF43@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a004cb10-8625-4c63-a25c-08de004f4dcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 18:29:34.0188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RYBE/4OJYnQl77VkGIAMGXnT3x0Od1HRVW9Hh+pRW1yKaNH3RkXzAQEUqLrW/cdL2yMrmGuBPnovdumxvSmmAfFehaTb6kWE0IvGOeY7fWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6366
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTI5IGF0IDA5OjU4IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gSXQgbWlnaHQgc2VydmUgYSBwdXJwb3NlIG9mIHByb3ZpbmcgdGhhdCBzY2FsYWJpbGl0eSBp
cyBwb3NzaWJsZS4gSSB3YXMgdGhpbmtpbmcNCj4gaWYgd2UgaGFkIGxpbmUgb2Ygc2lnaHQgdG8g
aW1wcm92aW5nIGl0IHdlIGNvdWxkIGdvIHdpdGggdGhlICJzaW1wbGUiIHNvbHV0aW9uDQo+IGFu
ZCB3YWl0IHVudGlsIHRoZXJlIGlzIGEgcHJvYmxlbS4gSXMgaXQgcmVhc29uYWJsZT8NCg0KV2Ug
ZGlzY3Vzc2VkIHRoaXMgb2ZmbGluZSBhbmQgdGhlIGNvbmNsdXNpb24gd2FzIHRvIGp1c3Qga2Vl
cCBhIGdsb2JhbA0KcmVhZGVyL3dyaXRlciBsb2NrIGFzIHRoZSBiYWNrcG9ja2V0IHNvbHV0aW9u
LiBTbyBEUEFNVCBzZWFtY2FsbHMgdGFrZSB0aGUNCmdsb2JhbCByZWFkZXIsIGFuZCBpZiB0aGV5
IGdldCBhIEJVU1kgY29kZSwgdGhleSB0YWtlIHRoZSBnbG9iYWwgbG9jayBhcyB3cml0ZQ0KYW5k
IHJldHJ5LiBTaW1pbGFyIHRvIHdoYXQgS1ZNIGRvZXMgb24gYSBwZXItVk0gc2NvcGUsIGJ1dCBn
bG9iYWxseSBhbmQgcmVkdWNlZA0KYnkgdGhlIHJlZmNvdW50Lg0KDQpCdXQgdW50aWwgdGhlcmUg
aXMgYSBtZWFzdXJlZCBpc3N1ZSwganVzdCBrZWVwIHRoZSBzaW1wbGVyIGdsb2JhbCBleGNsdXNp
dmUgbG9jaw0Kd2l0aCB0aGUgcmVmY291bnQgdG8gc3RhcnQuIFNvIHVubGVzcyBhbnlvbmUgbmV3
IGNoaW1lcyBpbiwgd2UgY2FuIGNhbGwgdGhpcw0KY2xvc2VkLg0K

