Return-Path: <kvm+bounces-50581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C17AE7226
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 00:15:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 815D31BC288E
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:15:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9EA8238C3B;
	Tue, 24 Jun 2025 22:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HrLt9Mre"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92244A2D;
	Tue, 24 Jun 2025 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750803331; cv=fail; b=dcabip7FOy6iecVMF8Q4XE2r6M29ebPiE5p8LSRTIKkQig7at8UtAj5uU2zGeOyv8l2hE22vwORlznO1fZ0ujdeX/PZP1n7928JndQeoQRb/y5slSakO04a26WwwRiFCIe/9q+gBhn0+QSM3Ob5rJV658t/AYFzVc+kfIiqLe6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750803331; c=relaxed/simple;
	bh=mZDVaOv0LH8z3TpSY4Y+lVMEB3UD9psnMzbvgrRJuho=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lFiK9ipZppVSyu6hPDGzsj65SVmig4hEZbg7DCKjLTw+RnePJb0gEKF6fRfkie8Gb/emKwLmDzMq4AVoCL/bGML381YmzNniVY5O1l1gRSldxEmDHtJTljCyiIMydfJpTQI7HnCfwmhhCX4O8s8aBq841oFQEgHXt6cz3TXme1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HrLt9Mre; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750803330; x=1782339330;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mZDVaOv0LH8z3TpSY4Y+lVMEB3UD9psnMzbvgrRJuho=;
  b=HrLt9Mrex4CfKHShSrZVD8VWOsQl8fjek1Tev7a5wdCd7Ui/u8VBhJem
   09r9PLMfU4sT9WtwPw/HkZE9v1wwy3O6lNAZGSkJjtTPpz3dspojHVmlH
   x9b4cB5Xk4y/UW8YcNbVrm7usG+SrSRc52y8pwfSgekunIq+TTaaPKrWn
   QBGTWbuv7Lx0X//qT2Y7AZweUPVNlV+3jPQQILHUxv0UAjqANAWPcl8cP
   2+szs1UQRZbkENW3uniqTc7Y3xLcXTh8Z68akpe5BDDayifwNIslvigdC
   QGfbk155DFj95+YqpRs61CZwtOdJzp4pucsFgQJL+/j1rYT3bwp88JKFi
   Q==;
X-CSE-ConnectionGUID: m7AYibc9SgmUDR75ix06cg==
X-CSE-MsgGUID: 6ncuAZSlRs2DtyGafiu0uQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="40680644"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="40680644"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 15:15:18 -0700
X-CSE-ConnectionGUID: l8kMvVVgT4urwX16YMyn1w==
X-CSE-MsgGUID: qiBoNha8QWy4GwMHq3xo5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="189225415"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 15:15:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 15:15:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 15:15:07 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.87)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 15:15:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWXkm/lvf22u9AuMC6UTJyMrhO5WscYQjpM9122giZPRg3huP6KbDOw0hA0E1cF+SVwnYLuuFUoNogTpJWue0vmAl5e+dyPhKkwdyQLINgKrNNV2uk+0qBr6fLBDYhtBLE1jmkhIQld3NSGUY2Bm59owBzlOFy+Jqd552PZAWdYwtmYeiU3IKIrT06KnnklFd4u/qeedrHf5TGoGDz1AWLE7KKtAzAeBVL/RkJHoqijjRvCeCtyuwZsQantklMfsa7WkwfAozbecEo8hnWWnMNVdh5NXhFmEd4YtocA2TQPRjoeD+l1qxETXRkk2JHFx9avloMD8M1dw82RHBb/NZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZDVaOv0LH8z3TpSY4Y+lVMEB3UD9psnMzbvgrRJuho=;
 b=UPJbtwdctG+TLNWkuiYC84mvYxkcFmkDupSo6O69M2hXwNVgfxOsblagjIWsbbin0oWIqXllk+Ku3hfZeVwsdf9XX024y6zXzh8bDNsm0dd5dLJ5NAMMaKA9ChdsL9I2vEThPMXxhKkjMPkh7D20c1OyUqaK5Ttyb/x8pB1bEWT36StlFGUgT3WM0gxDOwLDmChe74xCCKfHS55zXXuAlU0Ek4sa5Ulo3B6E4QK9Orbm6W+/uMbo/Tflu5R4dayDJsdbeifcqwWBLRO73lkqyoRVJB0d/kutqT5NWvNhbAHpyjIVvWSx2pQsl5AdFVXrEt9I4GCjEgvxBTEMAbEbsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4999.namprd11.prod.outlook.com (2603:10b6:510:37::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Tue, 24 Jun
 2025 22:14:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Tue, 24 Jun 2025
 22:14:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAAAPhAA==
Date: Tue, 24 Jun 2025 22:14:48 +0000
Message-ID: <844399f8b16027b06eefc0ef145a3cbb5ae83bc3.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
	 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
	 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
	 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
	 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
	 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
	 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
	 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
In-Reply-To: <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4999:EE_
x-ms-office365-filtering-correlation-id: 6a9e85bf-bd6b-4ee2-ba41-08ddb36c88d1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?c0oyWUhzZmV0ZUhwN3hxN29FY0tQbFNsK2h5aGtFMWcrY1lVUjFQbzBEOFU4?=
 =?utf-8?B?OS9sTVdqR0txTTZMdlV5NlcxY3JieVpRblhuTFlUVE8rbXVWUTl2a3BoV3BY?=
 =?utf-8?B?ZElLeUt6NGZSOG9GZkVlb2ZsWHluSmFucGdCUHNDRnY3NjM3QnQramdpVDk0?=
 =?utf-8?B?Z0MzOHdSb0xyUE1kQmovYVk2UUIreE9RbWNGc1ZUQmZGS0hnd1p0VTVjeHBa?=
 =?utf-8?B?QVdhZVF5M0o1b3RDMkRtZTVKdHNzUmZLYlNmbUJSQ1VKbHpJQ0YxdE9SVFNM?=
 =?utf-8?B?WjhTdDVGa0MxdThhdCtiMjFSMEpnaHRBSWRsdjRsSHFhN0F5cmRCY2FSZHpC?=
 =?utf-8?B?NUxxU2MvZ01GYnRSUWcxRzl2MysyNzg0MkhIbGJhUVBGUlUreEEzU3FIWXJD?=
 =?utf-8?B?dityN3pyUitITjBqR1VhL2xjazNxQklMSWg3VmlxUDFna0NrN3J0OGdKc0Ru?=
 =?utf-8?B?K0p6NEptZzZMYW9OS3NmNzlQZEZIWVorRzdFTHczMWpSc1dBQkVoK0htclVX?=
 =?utf-8?B?TUMyL3l0VldCZmU4azYwVUEyUHJkc2c5bWZTMTdoVCt3NlhCTkNvcmFKQnc1?=
 =?utf-8?B?QVo3VUZRTkEvcklFNTdWbjU0ODJ2UXZseFdoQWFBOE5xbnU5SWhOdjVjcWNS?=
 =?utf-8?B?NmZaTFdPY1NXL2dNM0tRQW45Q2JvWU03ZTlpdmdLVWE5K0h3RFhZVU53NVJV?=
 =?utf-8?B?bC9PaUhKOTN0NGFwOEszaEx2RUtIREkrSk1KNDZOc3dnVmg3Ym9BYm10eHhI?=
 =?utf-8?B?MnNxQ0JRMHNTZHlXanMwajNwZjZXRk1EMzlhbklmbC9MS3BlZDI4VndxZUV5?=
 =?utf-8?B?RHFlTmt0ckF6YTZpVWZ4NUsrSnU4Q0pmV1NKekxNVDZpTWxuWnAvL0hBalc2?=
 =?utf-8?B?dmtjTkZBQUt3N3MwRHl0Z0VUTWNwZkxXY1h0dGU2VDhhTGppVGgwd2RZZlZI?=
 =?utf-8?B?MThOVXl6SU1LdTl4Y3Iyeng2Mi9jWVEySmVTODBHVTRjQ3JaVlNmelpZV0VC?=
 =?utf-8?B?Zy9rZGVIN0IzV05URlM2ZFFGb2F2VjBjQXYxNnJoV012bXEyUEpOaHkySi9q?=
 =?utf-8?B?TkNiazlybEpRb0hDV004SkhnNlJBQ3lGNnJQS2ZmbmtUblhDTUlaanpUT3hW?=
 =?utf-8?B?M28yallkc2ZvR0dzM0RsRjNibXgrWDlQZFRpVmg0dmlPdjUrSldXV2JWT2F6?=
 =?utf-8?B?SytrTEV4OVp6d0UyY2RUOUI2TFp3TElBMlJTU1VLM3RFYUJ6VVlOYUtHMnJV?=
 =?utf-8?B?SnNUaG5KOW4xNFFZZTRwK2pPSHpBR3dUdzJsNnY3ZDBjcGZ5Y0JzZno2OFdr?=
 =?utf-8?B?dW5Wb0hqeVV6NWdtNjcrMXVqTERwclNKZmh4ZTdyNyt3ZFc2TkdNM05KNUt2?=
 =?utf-8?B?ZU1IelBiSjJKV1grV2pyM3NpTDFOamV5dmNIdm9aVmNRblhHNmI0SlNURk1q?=
 =?utf-8?B?aUpJSlFlRWJlcDJNUnZ2M2RQNTMwZTdLTmhYREl2VFJCOXFNdXhsc3VETHAw?=
 =?utf-8?B?VDdaQWVFU1JlVGRpc1ZIaW5tNVBMQk5Rd1ZJeXNRcSsydVBnL0xHZmpKbmQ4?=
 =?utf-8?B?eVljTnVRcGZkdmF2NUNpMURsVjN3cUxCN1FwNmVtL0t6U3Zkb3F3S2s1c1lx?=
 =?utf-8?B?Y2RKQW5HK1BkeXhNL2NlYkJIbzJJaVpxS1RzVXJoWHRMSFg0a2c1T0diZzl1?=
 =?utf-8?B?OE9tZE8rSDF4NGFHQVEzbFgrZHd0V3lla1BaYTA4eVhHYlBISExLWVMyMzEw?=
 =?utf-8?B?YUY3aWdwdmhtMUdLM1F3MTI2ZkdXT3haSkJ5YTNqYVJJN1JsRjFzTHBmdnRw?=
 =?utf-8?B?V1BhdkNUWFRLaW9aU0g1cnQyeFJHNkkyK1Y4cjUwZTd5eGZWSFhmK0JRRWVl?=
 =?utf-8?B?S25VTGl5SFNCYUg2T21ENE1vY0MwRWQ5Ti9HY0hVT0loTGd0Q1hRak9TR1Yr?=
 =?utf-8?B?eUxKYWNmSnhUSUJJSHpTNEhnc1NlWFFsdGxzaE5yc0Y2SnpobFMzTnlKclZn?=
 =?utf-8?Q?4GbOhTjJawlzuh+xrl1/1mK2hgTNDs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q2hJRE1FS3YrNXN6eE1QMUl2bjFXNndQNTVJem0vM2ttdDFUWlNnZGZmZzVn?=
 =?utf-8?B?ZjZNQ1UyRS9UWFVMcGNZK0kzWWhaVHZzS08rZ3ROUXF3Y1FZc01LcTZ1dkd2?=
 =?utf-8?B?MDRzVEdmdDJnTEFDbnphelhsbHJIUER0NGtnYWtSVlV0NmNXKzRveEtXL1ph?=
 =?utf-8?B?aHdjSC9PZHovcGFEL3VWWVdMMmdUL1JjL0JKSFV5b3BYLy9MZzdnQUU2WG5a?=
 =?utf-8?B?c3dEUWdIUktGQ1ladEtVc3RpdzhUSmtRblNaRFV2TVlPZk9XTWM5aGxkaGZ6?=
 =?utf-8?B?c2RWSHZLRFNITTJ2RXg0aDBYd0Z2MnNSL3ZLVk5DN3l6RUZrZ2I4MWpPcW9H?=
 =?utf-8?B?WkRMOHdvb2wxQ21iTFYzNVJNZ0lXQ1NWRENsR1BMQlo1K1l3K1AzSStzb0Zi?=
 =?utf-8?B?b3ZsS0NYc1J3U2FEQlh5WG9VdWY5eEdaQmU0WVdyaTJxVU44TzdBaDRjanhF?=
 =?utf-8?B?alRhcHVIYzZMdnhEWiticmVXei9EZTM3ZVFUVWFZdzA1UVhpbDk2SGIvNGpj?=
 =?utf-8?B?TEJha2ptRnhyL1lBMUd5UU82VFZBWlByTGp3VnJSdDgrcSt1YjVPN0pHeit0?=
 =?utf-8?B?TldiZmI4VTBJKy9Bcm1sUUk5eXdkeDc2ZUtTcThobjQ1TnU2Z3ZONDVobHhl?=
 =?utf-8?B?YUhhSDFLczBRRGZ3RVJTR0lGMDdMSmFLQ0hBMVZya1VKMmU3cjZFYUtwNHVa?=
 =?utf-8?B?aEdZWG1TejMyQUk1S1F2OUpneXVOQ0VXTnhnV3hOK3lwZWdjc0paNWNSdDJr?=
 =?utf-8?B?Wml1TEVYNXMxZm5MVW9JOXVoY2E0ZmNaT2MzdlFhNjV2bWNXZlZiMHFnTkxO?=
 =?utf-8?B?UzljUDludVJEclZoZ29TdWdnSCs3MFcwZTFtUEZ1WEtJdHhzc1ZzSklyMkl4?=
 =?utf-8?B?TzlRNkYyMzZTci9RR0xweC9uZUlLbFBIazJNbm50TlE3eHZhV3h5S3liZzZT?=
 =?utf-8?B?eUtPYVg2R05LMXp5MFIzeFJKbGtnd0puQ2RGZlpyeHVySFRsR2hveUtBV1BQ?=
 =?utf-8?B?MnJiQlRMWHQ0T1BoVkx4eHY3OFdjSG9XZk1lRG85N1I0aitMUy8rQlhyMWVH?=
 =?utf-8?B?Q0p2L2JlK2JqUXF6MG85QUpjODA0bkhJWDJLTnRRbndoYmJRYndJTjlsc05W?=
 =?utf-8?B?bTZQRzUrYWlQVThqZEx2TkIvS21vZ2ZxRUJkQ3h0K1cxdGxKWUc1cjdNMTNV?=
 =?utf-8?B?SklBWnlhTzE5eHF5TERIUU5DeHlJUCt2QzFBblFaaDFjTnlrTHkzL3BxNVhB?=
 =?utf-8?B?a1orWHFiWHIwTDZBTnExY0h4TnRJOGxhZmxSMjhQam80aUErSXREako2QXh0?=
 =?utf-8?B?eUZwL2QwaWd3dTdURzFDbHgzWkxtRFdBVnFrSE13dGdYaDgwUjEzanplL2FE?=
 =?utf-8?B?R2tOQUVlckI4RlJSZEdRTW41M0F0ZVFqRTBGZUMzZmZ4NU03NlZlNVZwV2Iv?=
 =?utf-8?B?OGRTVHF3VUw4Z3hQWStqUXJRSVNQNElKbVZZMnVKV05qT29MNlYyR3RnQlln?=
 =?utf-8?B?bGk4L2l6VW9MZ3d0aHJsb2l4S0JBcVNBNkk5RFhaSmdzeEV3cUNlcjFOYm1w?=
 =?utf-8?B?cVZFV0g3VEZBNFBzRTZ0TnJyMDVyUzZtcGF0b1NOOFJ3aklNWStHQTlXcytv?=
 =?utf-8?B?dWZ2WFFoL2xCbkRkR2s2cWc1dDd3YTF6bC9qNjFPV2ZHRmxyNW1pZkx3aHlh?=
 =?utf-8?B?TmNKdTZCaktzVlRCdDYrQ1FEUEsrQ2l1cEpIc0Nmc0NyU3RkNjFYSEQ0Zk1G?=
 =?utf-8?B?SWpjTDNHM2w5M3g3RHN2dGtBOVdJeE5XMm0zOEF0c3dwYTU5VnhLcEVOOTZX?=
 =?utf-8?B?OXQrMzFMUnIxTVJReXJlZVNhMFlZYnFUR1V0QlF3c3hzSUFPUmdNUTJmSi9F?=
 =?utf-8?B?bFkzandIM2JoeVlJOHVWS3RJUUg1THpMWDJEWWplYlVObVJoVXFqempyS0t3?=
 =?utf-8?B?d0RROWhBbFpnaVphYjJIMXp2Wlo2ejdPbkUzclBneDF1blpSQ1VOR09NZEFN?=
 =?utf-8?B?aEoySHdycHJpazZOeUdLblVGaDNBMldhUlFBdmtiSTd6VzBYS3Fac05vNFQv?=
 =?utf-8?B?QnBaSjFDSWdJakM4aTdrZDVlcHJ0VVozVHB4ZEJaRVJvcFF0eGw3K1FZcHdT?=
 =?utf-8?B?d0cvVklYcnhML1NvbWFSeXVJemlLQTBXbXlQVkErRWhoclZmUWF0ZE9iR0x4?=
 =?utf-8?Q?SWy4kUsaOynZVEDNhbdr9zo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <001E3AF653DD3848B1A5A55F992717DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9e85bf-bd6b-4ee2-ba41-08ddb36c88d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2025 22:14:48.9357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O987SeFmjXjhJYh2a9dshLf+fDUllt0i7z8fLVtbh23o/CgEF1bkVn5wlX56OvUBquboPDHToHyU0Btd8+GbfZS0yzrdTWUW0ZkaPBUGgUo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4999
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTI0IGF0IDE1OjAwIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gTWlub3IgY29ycmVjdGlvbiBoZXJlLiBZYW4gd2FzIGNvbmNlcm5lZCBhYm91dCAqYnVncyog
aGFwcGVuaW5nIHdoZW4gZnJlZWluZw0KPiBwYWdlcyB0aGF0IGFyZSBhY2NpZGVudGFsbHkgc3Rp
bGwgbWFwcGVkIGluIHRoZSBTLUVQVC4gTXkgb3BpbmlvbiBpcyB0aGF0IHRoaXMNCj4gaXMgbm90
IGVzcGVjaWFsbHkgcmlza3kgdG8gaGFwcGVuIGhlcmUgdnMgb3RoZXIgc2ltaWxhciBwbGFjZXMs
IGJ1dCBpdCBjb3VsZCBiZQ0KPiBoZWxwZnVsIGlmIHRoZXJlIHdhcyBhIHdheSB0byBjYXRjaCBz
dWNoIGJ1Z3MuIFRoZSBwYWdlIGZsYWcsIG9yIHBhZ2VfZXh0DQo+IGRpcmVjdGlvbiBjYW1lIG91
dCBvZiBhIGRpc2N1c3Npb24gd2l0aCBEYXZlIGFuZCBLaXJpbGwuIElmIGl0IGNvdWxkIHJ1biBh
bGwgdGhlDQo+IHRpbWUgdGhhdCB3b3VsZCBiZSBncmVhdCwgYnV0IGlmIG5vdCBhIGRlYnVnIGNv
bmZpZyBjb3VsZCBiZSBzdWZmaWNpZW50LiBGb3INCj4gZXhhbXBsZSBsaWtlIENPTkZJR19QQUdF
X1RBQkxFX0NIRUNLLiBJdCBkb2Vzbid0IG5lZWQgdG8gc3VwcG9ydCB2bWVtbWFwDQo+IG9wdGlt
aXphdGlvbnMgYmVjYXVzZSB0aGUgZGVidWcgY2hlY2tpbmcgZG9lc24ndCBuZWVkIHRvIHJ1biBh
bGwgdGhlIHRpbWUuDQo+IE92ZXJoZWFkIGZvciBkZWJ1ZyBzZXR0aW5ncyBpcyB2ZXJ5IG5vcm1h
bC4NCg0KTm90ZSwgdGhpcyBpcyBzZXBhcmF0ZSBmcm9tIHRoZSBwcm9ibGVtIG9mIGhvdyB0byBo
YW5kbGUgb3Igbm90aWZ5IFREWCB1bm1hcA0KZXJyb3JzLiBUaGF0IGlzIHN0aWxsIGFuIG9wZW4g
cmVnYXJkbGVzcy4gQnV0IFlhbiB3YXMgY29uY2VybmVkIGlmIHdlIGRpZG4ndA0KdGFrZSBhIHJl
ZmVyZW5jZSB3aGVuIHdlIGZpcnN0IG1hcHBlZCBpdCwgdGhhdCBpdCBjb3VsZCBiZSBtb3JlIGVy
cm9yIHByb25lLiBTbw0KdGhpcyBmbGFnIHdhcyBhbiBhbHRlcm5hdGl2ZSB0byAqaG9sZGluZyog
YSByZWZlcmVuY2UgZHVyaW5nIHRoZSBsaWZldGltZSBvZiBTLQ0KRVBUIG1hcHBpbmcuDQo=

