Return-Path: <kvm+bounces-10031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 062A4868AE5
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 804001F2323D
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593C6130E37;
	Tue, 27 Feb 2024 08:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MQLlwKn6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0614C537F4;
	Tue, 27 Feb 2024 08:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709023246; cv=fail; b=C+sOOLq/opzcgLl+NS/yNghjaVp7496khtBqvaqcT7vimaXdwVSNf1sFXuUy6cO9hIiaxed9oIbHpty0zcF192TnXptDg+gA/oKguKlL5QWgGKVKfu66ugUc8ZgPBbvA1Zw1QARCcQfmBC+OxLl+rVjxewnf1YkQVCQRrNlcRcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709023246; c=relaxed/simple;
	bh=Rkg3mY18qhyJuBwJIe/u+lBI/8+CHLDzUu2n63ZIP14=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ag/Egrxh/vGvZnX9+JjtqhmlAFbKLb9MAVlA0CQsUI2QeozOxdP4Pihod1n6bCKOAlHTTMVNd2d2yjctrK3fkst03C5wYvsSO3oguFkESlhw2x++7zYqLPUYzyWK6CWsMcwAfENuO7MR+U4DHmJ3D4CSzaXFon5v8IzblNdK2So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MQLlwKn6; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709023244; x=1740559244;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Rkg3mY18qhyJuBwJIe/u+lBI/8+CHLDzUu2n63ZIP14=;
  b=MQLlwKn6Q1MPtGfE197Cdvg0HBmd737xY0WesCfFMipSXSWeGJ79qMRF
   tP2cRpJLVPr4LI/1bMHzsYe9R+N4k7tn9H8QmpgG+k39dzOdknFzmqXDc
   /Jhf5kvXjQDZnniwP/YGpsRj6kTKH6K+EawOWhgAZAL5ETegHh1liya3Z
   DFCitczfQLrLwHLK8Fk668ef3tlhvkqN+OZPATmNub5Bo1lRR9i36FpFD
   GIkpAPnxrAvbMpw+bsgCpa13mcu2dPYgyIhc8vF/Mt8DxHeXsZlPR865k
   w3w9JgXV1Q8hzMYle7smOsNdOd1OTaQ1nk1tnrJALLEKIOwIS2WUlZQ7a
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3196987"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="3196987"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 00:40:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="11586531"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Feb 2024 00:40:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Feb 2024 00:40:06 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 27 Feb 2024 00:40:06 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 27 Feb 2024 00:40:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNtgP2tv356IgSf5f/TDKFEN+gy8CkBdeURnUrueHYPh2bl1sDtb56u0kTg1T3M5Uu6G5wb7jF+Biz5Z5Es5un8L2HsPVHuWA2EF+YsFT8DI7W3bkgdUryGBJt5Ran8XScf6yOcR8xN8OkXNEwCtfbTqdzRkNd01ZYcVhxL2mb2iKiRJ1qt3biaPdIdZGZxx3omBhstDrXrl2TS4EuHj51gYOlV4SeC6J5Y5/zNeupTzzNIdlxj3BObrrTmGYNYvayXPfh5HQBw7HOmPp1BKpY/1LQz60mTWX5TyB56Uc5eQOLecPlnQmUjFE6OUsQUvTVQJGMENA2YAABY1zQkVvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rkg3mY18qhyJuBwJIe/u+lBI/8+CHLDzUu2n63ZIP14=;
 b=dXrlq5f7nqWrjBVRnjV8b+oyvf+1a3r/xIUPo57H45ut2QnUd2VPClh1MAfCEa9bNkMuyJfcycUXh22J/MOIa0QQpDNTwmM2hJVnbAe9EGPCxKmdR7FAPP8unW1aeJ1OMQaPnCsK7NWtQ417GY8mttec/tLzqL9JtZyHE74rELX/nBfL3Udwf2k5xo7jMP6/cIQK9jvohporBz8FF10i2jdnxPL54dJdWRIT2rMkcKsyYTHRh0bvMHl0qFjz4N7q11uoEIllnfNPminBbZUHaBXSvOl7rFvvsc1ab2XpQptLDnDHvKFeCOB2gFCTgF1rwYLfcBPrNyYKURhnCseUfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6512.namprd11.prod.outlook.com (2603:10b6:930:40::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.13; Tue, 27 Feb
 2024 08:40:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Tue, 27 Feb 2024
 08:40:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "jgross@suse.com"
	<jgross@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 004/130] x86/virt/tdx: Support global metadata read
 for all element sizes
Thread-Topic: [PATCH v19 004/130] x86/virt/tdx: Support global metadata read
 for all element sizes
Thread-Index: AQHaaI2s6uNuX3XjIUan+X6EvilzKrEcsD0AgAEvwQA=
Date: Tue, 27 Feb 2024 08:40:03 +0000
Message-ID: <85c24fbdbc049cae9c5d6236369de2cafe4e4ad5.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <db0a8b2fb7138021fed7d740c84bd663025f4451.1708933498.git.isaku.yamahata@intel.com>
	 <b3f896bd-2931-4edc-b5da-3cc9561b897e@suse.com>
In-Reply-To: <b3f896bd-2931-4edc-b5da-3cc9561b897e@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6512:EE_
x-ms-office365-filtering-correlation-id: 2285abbd-d38f-4d4f-e3c3-08dc376fb172
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r+oHk8PGLiV5SmVsLWkYtsqwZQ6HH2FH3peQvSEA7b0PxXUrtdUShHwpkCd7rM3Nxsqun2hdl1X6+VrXUW02rPIq6ZnDipPvkKbMQIxQCNgsdb8Kjz27LSaWVZqezSEfwmZ+Pw+VdWIuTrRGxdsp9HDwQeBdgxP/8jZaa/ntykNzo3d56g7Y+7JBMrzM+3L2dOx8V5skYLqHWM/e4+4qGjqW2BGZywI8m2mHJhVptfeJh16FMgBgnc0jhJvtU5W8O6WbZn36MuLOfyfwlfMatPMFSluqy4h9kWUJudB7vb1bYIixyWBhg3vnWgVc7tCrFiTICDkomx2GQOerFOffaNvxhsGfTZpm9jCQyIBYOjfrlAtdjXR1xePmu7a9NAy/PxuWGrH6aBJ1xvIqeHpszyGiH8rHgSPYJpbr5Ss2AE4zVR7VAyrFc7Zyot7K+Mj4ti47v7yb2BZ90RefrvbRysb7b+6loE1P1l1b+Aq4JyfaYEl4L4v4lqfTriuAsaGu7N1RvpZVPnyDorDURNw1jSYtucO8isU4a/Ik+FhBk09KMvHjrAz8hxBI/6BwWkCnt8qUWWF75hAl/xm76ENgDTguKApFU11bdVa90is5MZ49F4oqvT5JsD3ttIT2Jci7H7uvPmGjnR1jlMkFcLzlAnAWbf9glF7lxBJIW32k7FZZ/3cSP8DC49/4Nx03ab+eoXg9N2DnoEGFlQ/wB/mWwszFwhNl/67wgqsZw8WmoPs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWZuSS92WXJVTFRkMDFjMDRKdU1WSFhGM2FQRk5hZjhDM0t5L05OUVNNZEZJ?=
 =?utf-8?B?alI4S3ZXcjYrREF3SE9TTFlBM25Kc3FSbTVXK3dNYW1ZYWRQeTBtc1g4bWpm?=
 =?utf-8?B?elJaTVpYYkRBTEF2RWNEbHRheUx4YU83ZzA1V0Vqa1p1a1lmOTBDSUpwa0to?=
 =?utf-8?B?ZldoaGp2K1NvWXFhRm5lQnVYRDFZZXgrLzNOVFBmS3NKYnh5S0Q3WWtqN05U?=
 =?utf-8?B?Z2YrYWFBSzAvT2Vzb3M1SG15YURZTEJGMm1uQ2lGTHlTdzJVOGcrN2VaR1Zr?=
 =?utf-8?B?akthV0ZyREFuaHNGWUZHVE56RDdqM1hDL2k0SmpOeSsvL0p6RUVNcW1mZnQr?=
 =?utf-8?B?K0QyK016TmpZL3BSUXRXZWt3YlkwZmRiRlI5U3Q0eFI4eGdwTU1MMW5tVnZN?=
 =?utf-8?B?b01UQ2Y3NkZTRjl4aGZWSnVUOFU2THlScklYV0ZoLzRaY0diNlNXM2hvUlgz?=
 =?utf-8?B?ZTJESFBSR0MyTFo2VjB3eHkrc1BPaXM4eDNveTZYdVBWMHR2dWxRZEl5UGYv?=
 =?utf-8?B?NE0rOHIwbXM1MnVVdkZSclVUOGxvZjY4K0dpLzh6NDl0bjh4a2NJLzBxQXhP?=
 =?utf-8?B?REJHQTBZYnBMSVJhQ0N3UEtFaTY0MzdQbmkrY1VHTjlTSFdybCt3bVJtRmVt?=
 =?utf-8?B?eHBMZXpxMkliRFVmVjhkSmpHMlMxdjErYzRjUWJIamhhanY4UlN0M3QvYzRS?=
 =?utf-8?B?RmJVTVFrWS9lOVpEVUVpb2Y2TVhoQVBrMk4vVkZoeVpxZ0swVUtFK3YySzRZ?=
 =?utf-8?B?UDYxRDdmN1pKUVUveFRoU2tBbWM3YTgrTDJ5ZDZBWnpwUUxyY2wzVmlIbnNx?=
 =?utf-8?B?YlBhdFNrdVlDOG13QkNDS1dSUDFTSStySkU1NVd1d09QR1ZpNENzcDFld2U2?=
 =?utf-8?B?RnFMbnZFU2U3YjJtTDBwdlN6N2VOTlM4RTgybm14VGIvSGpGS0lBQnNBYXJw?=
 =?utf-8?B?K2M2MFE4bzVQOXd6ZXZYM2JmM3lLbXFVOURGMDNjNGRMUFZ5azMxMS9sNk1P?=
 =?utf-8?B?UFAvV085Nm9ibkdMckUwTVFwelA2NDMzQ1dwdjNKbEcyT3dHUVpNMUkybHRN?=
 =?utf-8?B?S1AvclpWajhsckUvOUVHbVlDM1dibHlsbXNMNWpMUERiTFp3ZXV2Uy81S0tp?=
 =?utf-8?B?d3lTa3dJbEpxU0U3VDdtSHdHLzhaY1pMY3kzdTk5VlZ5Mmh0R1JKdGFHM1J2?=
 =?utf-8?B?TjBKdjFDZU1ieFZ2ajl3UEl4S29SU0MwclMxS2NlTDZlT2JUZm1VcDQyTXdG?=
 =?utf-8?B?dEE1RVFIU05vOUQwWmptWndTZnZPNjBXdkw1cGpUSU9nVjhYTGwrNmtzOTVW?=
 =?utf-8?B?aWV2dzcxS0gwejRDSGNlNEFSZGFtRHlWdzBOdThsY1RucmExUWk1WXhHUE9q?=
 =?utf-8?B?d1JNMFZiS3lxNVJ0ZFd1aVhOM3UrZkIrNDQrV2hpNWYzMGRld0tGQm04TG5T?=
 =?utf-8?B?eHQvOThhazlEN3dqcG03QWpqdmVTWkZYVTE2Tk4rdnZPWm9GWTRyeXR6Q2dR?=
 =?utf-8?B?b1YwV0ZMR1J2VmVEQ0puaWxUbTV0Y3dPUEg4Z1plZ1hDTTFRd21TSWZJbndp?=
 =?utf-8?B?U3dxaVhTQkNvNWZoaUlDSzVqdDJCU3U4YWdya0IyVE1lUUxJK1Z0aFBvV0lX?=
 =?utf-8?B?SE53UFhsbkt3OW12M2R2UUZMTy83cEp4NUM2MHhNQ05lL3NEc2t2Y21KTDN4?=
 =?utf-8?B?SFZXaTlXV0JYbkhUY0thZDdQNUNmYmFEYnRPd2ZadHNCaVNmNHdTcmxjTFhh?=
 =?utf-8?B?YjJTSDNGRWh2MHRRbzhvUVd2WTJ4V2tJNXNFY0FmbUhRTmRBREo0OHR6R0Fa?=
 =?utf-8?B?MjE0TDBaMlVWYmZORGdWSHdLdFBkRE5uK0sza2pFbVQ0MTI1U25BUkVTUDN1?=
 =?utf-8?B?SzBwblc3bTk3YkYxWldQbW9OUTdRZVVaUzVrN0tBVUx0S2ZnOVE1ZFYzN012?=
 =?utf-8?B?L1FweUI0dnI5VWR2Nk54QzYwUVF5YzIxMTIyR3dCbEU0NUJidS9qRmRvc0Nn?=
 =?utf-8?B?TWduN3k5cnRWc0xrS1UwVHVYZVFXTk5Tcml4RHp6Q0I0WEUvRTIxbXQyNEsy?=
 =?utf-8?B?dVhkUnFXTjQxYld1KzlDRjU5ZkdzTnlVQlg3b1hmODRuTk42cFV0Qjd0QmNO?=
 =?utf-8?B?emgvckZMOTdEcTA4b0FkOExWTjBETU9yemppdFE5MjNPbDBJck0wQm9DL1h4?=
 =?utf-8?B?S3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC3A35B8ADAB6C4787ADBDE1FDB769BB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2285abbd-d38f-4d4f-e3c3-08dc376fb172
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2024 08:40:03.7237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DywKKLyyoT5eZELulwAEzdUlVhIrO+SjqPHk0TLZmkRYRjwvOCRmnBmRTbTC5d5upPehNhOEj6tpxDvkUQdZqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6512
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDE1OjMyICswMTAwLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0K
PiBPbiAyNi4wMi4yNCAwOToyNSwgaXNha3UueWFtYWhhdGFAaW50ZWwuY29tIHdyb3RlOg0KPiA+
IEZyb206IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiANCj4gPiBGb3Igbm93
IHRoZSBrZXJuZWwgb25seSByZWFkcyBURE1SIHJlbGF0ZWQgZ2xvYmFsIG1ldGFkYXRhIGZpZWxk
cyBmb3INCj4gPiBtb2R1bGUgaW5pdGlhbGl6YXRpb24uICBBbGwgdGhlc2UgZmllbGRzIGFyZSAx
Ni1iaXRzLCBhbmQgdGhlIGtlcm5lbA0KPiA+IG9ubHkgc3VwcG9ydHMgcmVhZGluZyAxNi1iaXRz
IGZpZWxkcy4NCj4gPiANCj4gPiBLVk0gd2lsbCBuZWVkIHRvIHJlYWQgYSBidW5jaCBvZiBub24t
VERNUiByZWxhdGVkIG1ldGFkYXRhIHRvIGNyZWF0ZSBhbmQNCj4gPiBydW4gVERYIGd1ZXN0cy4g
IEl0J3MgZXNzZW50aWFsIHRvIHByb3ZpZGUgYSBnZW5lcmljIG1ldGFkYXRhIHJlYWQNCj4gPiBp
bmZyYXN0cnVjdHVyZSB3aGljaCBzdXBwb3J0cyByZWFkaW5nIGFsbCA4LzE2LzMyLzY0IGJpdHMg
ZWxlbWVudCBzaXplcy4NCj4gPiANCj4gPiBFeHRlbmQgdGhlIG1ldGFkYXRhIHJlYWQgdG8gc3Vw
cG9ydCByZWFkaW5nIGFsbCB0aGVzZSBlbGVtZW50IHNpemVzLg0KPiA+IA0KPiA+IFNpZ25lZC1v
ZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5
OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+
ICAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIHwgNTkgKysrKysrKysrKysrKysrKysrKysr
KysrKy0tLS0tLS0tLS0tLQ0KPiA+ICAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIHwgIDIg
LS0NCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgNDAgaW5zZXJ0aW9ucygrKSwgMjEgZGVsZXRpb25z
KC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBi
L2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IGluZGV4IGViMjA4ZGE0ZmY2My4uYTE5
YWRjODk4ZGY2IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0K
PiA+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiA+IEBAIC0yNzEsMjMgKzI3
MSwzNSBAQCBzdGF0aWMgaW50IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkKHU2NCBmaWVsZF9pZCwg
dTY0ICpkYXRhKQ0KPiA+ICAgCXJldHVybiAwOw0KPiA+ICAgfQ0KPiA+ICAgDQo+ID4gLXN0YXRp
YyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNih1NjQgZmllbGRfaWQsDQo+ID4gLQkJCQkg
ICAgIGludCBvZmZzZXQsDQo+ID4gLQkJCQkgICAgIHZvaWQgKnN0YnVmKQ0KPiA+ICsvKiBSZXR1
cm4gdGhlIG1ldGFkYXRhIGZpZWxkIGVsZW1lbnQgc2l6ZSBpbiBieXRlcyAqLw0KPiA+ICtzdGF0
aWMgaW50IGdldF9tZXRhZGF0YV9maWVsZF9ieXRlcyh1NjQgZmllbGRfaWQpDQo+ID4gICB7DQo+
ID4gLQl1MTYgKnN0X21lbWJlciA9IHN0YnVmICsgb2Zmc2V0Ow0KPiA+ICsJLyoNCj4gPiArCSAq
IFREWCBzdXBwb3J0cyA4LzE2LzMyLzY0IGJpdHMgbWV0YWRhdGEgZmllbGQgZWxlbWVudCBzaXpl
cy4NCj4gPiArCSAqIFREWCBtb2R1bGUgZGV0ZXJtaW5lcyB0aGUgbWV0YWRhdGEgZWxlbWVudCBz
aXplIGJhc2VkIG9uIHRoZQ0KPiA+ICsJICogImVsZW1lbnQgc2l6ZSBjb2RlIiBlbmNvZGVkIGlu
IHRoZSBmaWVsZCBJRCAoc2VlIHRoZSBjb21tZW50DQo+ID4gKwkgKiBvZiBNRF9GSUVMRF9JRF9F
TEVfU0laRV9DT0RFIG1hY3JvIGZvciBzcGVjaWZpYyBlbmNvZGluZ3MpLg0KPiA+ICsJICovDQo+
ID4gKwlyZXR1cm4gMSA8PCBNRF9GSUVMRF9JRF9FTEVfU0laRV9DT0RFKGZpZWxkX2lkKTsNCj4g
PiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCBzdGJ1Zl9yZWFkX3N5c19tZXRhZGF0YV9maWVs
ZCh1NjQgZmllbGRfaWQsDQo+ID4gKwkJCQkJIGludCBvZmZzZXQsDQo+ID4gKwkJCQkJIGludCBi
eXRlcywNCj4gPiArCQkJCQkgdm9pZCAqc3RidWYpDQo+ID4gK3sNCj4gPiArCXZvaWQgKnN0X21l
bWJlciA9IHN0YnVmICsgb2Zmc2V0Ow0KPiA+ICAgCXU2NCB0bXA7DQo+ID4gICAJaW50IHJldDsN
Cj4gPiAgIA0KPiA+IC0JaWYgKFdBUk5fT05fT05DRShNRF9GSUVMRF9JRF9FTEVfU0laRV9DT0RF
KGZpZWxkX2lkKSAhPQ0KPiA+IC0JCQlNRF9GSUVMRF9JRF9FTEVfU0laRV8xNkJJVCkpDQo+ID4g
KwlpZiAoV0FSTl9PTl9PTkNFKGdldF9tZXRhZGF0YV9maWVsZF9ieXRlcyhmaWVsZF9pZCkgIT0g
Ynl0ZXMpKQ0KPiA+ICAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAgIA0KPiA+ICAgCXJldCA9IHJl
YWRfc3lzX21ldGFkYXRhX2ZpZWxkKGZpZWxkX2lkLCAmdG1wKTsNCj4gPiAgIAlpZiAocmV0KQ0K
PiA+ICAgCQlyZXR1cm4gcmV0Ow0KPiA+ICAgDQo+ID4gLQkqc3RfbWVtYmVyID0gdG1wOw0KPiA+
ICsJbWVtY3B5KHN0X21lbWJlciwgJnRtcCwgYnl0ZXMpOw0KPiA+ICAgDQo+ID4gICAJcmV0dXJu
IDA7DQo+ID4gICB9DQo+ID4gQEAgLTI5NSwxMSArMzA3LDMwIEBAIHN0YXRpYyBpbnQgcmVhZF9z
eXNfbWV0YWRhdGFfZmllbGQxNih1NjQgZmllbGRfaWQsDQo+ID4gICBzdHJ1Y3QgZmllbGRfbWFw
cGluZyB7DQo+ID4gICAJdTY0IGZpZWxkX2lkOw0KPiA+ICAgCWludCBvZmZzZXQ7DQo+ID4gKwlp
bnQgc2l6ZTsNCj4gPiAgIH07DQo+ID4gICANCj4gPiAgICNkZWZpbmUgVERfU1lTSU5GT19NQVAo
X2ZpZWxkX2lkLCBfc3RydWN0LCBfbWVtYmVyKQlcDQo+ID4gICAJeyAuZmllbGRfaWQgPSBNRF9G
SUVMRF9JRF8jI19maWVsZF9pZCwJCVwNCj4gPiAtCSAgLm9mZnNldCAgID0gb2Zmc2V0b2YoX3N0
cnVjdCwgX21lbWJlcikgfQ0KPiA+ICsJICAub2Zmc2V0ICAgPSBvZmZzZXRvZihfc3RydWN0LCBf
bWVtYmVyKSwJXA0KPiA+ICsJICAuc2l6ZSAgICAgPSBzaXplb2YodHlwZW9mKCgoX3N0cnVjdCAq
KTApLT5fbWVtYmVyKSkgfQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCByZWFkX3N5c19tZXRhZGF0
YShzdHJ1Y3QgZmllbGRfbWFwcGluZyAqZmllbGRzLCBpbnQgbnJfZmllbGRzLA0KPiANCj4gVGhl
IGZpcnN0IHBhcmFtZXRlciBzaG91bGQgYmUgImNvbnN0IHN0cnVjdCBmaWVsZF9tYXBwaW5nICpm
aWVsZHMiLg0KPiANCj4gDQoNCkluZGVlZC4gOi0pDQo=

