Return-Path: <kvm+bounces-17509-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC56C8C7040
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 04:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1AC071C2095A
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6261854;
	Thu, 16 May 2024 02:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gny8jgYC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E6F79C0;
	Thu, 16 May 2024 02:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715826111; cv=fail; b=laQsFWtmSgFsROs6cEMRr5dJngRd+FHjlHsemLptcRVQIJlu5PQvNsM6/in1chpvsMOiGMMXzFZ1e/Zvio5yKkCE2D+jj0pUhT1SyGzQ3Qg+niHJpEHON11zir3SfeXrfDX5A6qlhk+DY1/wRpjdn/6aIA1Zhe+olDSH/j5TPkE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715826111; c=relaxed/simple;
	bh=/KzweVtZXVtE/euAVRPZhMRyS2tWgb7hGik40fmKI4E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L5Ssci6y/Bu/zvmwIVeIhzDfOwZKrNPDFmSV30mUNPHdp0OzdJRe1ImZa7o5UP/Ftt/AQl5A9uyaP4zFzS8wZUwZtRSL7hpMwUhbQNb8tQuOqOuEpF8IatSRmulWpeQ4wDll1W4evazLnthoKtwbA3yz7SHBCIrunxn7+i+BR8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gny8jgYC; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715826110; x=1747362110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/KzweVtZXVtE/euAVRPZhMRyS2tWgb7hGik40fmKI4E=;
  b=gny8jgYCdWcCnXbI2up3Ljf1Pxw/w38lr1ED02sPOowqIL385p65gubN
   HBIk24fYhWW0xOYbuQglwBXYQ+RPFUJA89iLpmNgzlETE9paEIttUS3Fb
   aLXk1vkYY04kYcaN7wP9y1cuqtg5v3auYrq8Uk2+fP4PrZ10IYNIPwZm3
   JpVJEIUUTJNpeQSV5uQiZxIQ56aKlWQauZFebJySvlSboobbDXgqcEHjU
   /pP/XEFO7YxW83ElI8fC6Yv6zF278zggi5RuIJA0cxQliblvbAt/TEz2b
   bsyBruKGmwuzN3wos8mJcKsAY/0oOnK9+TnJ8/WfGftotF4dFXaWiCmr2
   A==;
X-CSE-ConnectionGUID: xbiwynn5RWiXQR9rgafF3w==
X-CSE-MsgGUID: 6fbp/4snS8q6YEwecos92w==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15735169"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="15735169"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 19:21:49 -0700
X-CSE-ConnectionGUID: XU9kbl8/R4GQxARR+9B3lg==
X-CSE-MsgGUID: KL1at0KFQGC/Tjf+3eO3Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="31835276"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 19:21:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 19:21:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 15 May 2024 19:21:48 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 19:21:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 19:21:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QSvMTAVUjOeXY9cbwzEVTOnwEmx9q9mR1e5eZkDxFH5PDf2gY9se/8gj65bGRGk8Gk5iesODhtIBA90go3u/l90qONPOtZ5VOBlanXVOdZgAPKvqzys39Ec/Xuo13J1+RHyeTv1hoS3xp6+qc1Yiy04bxKtlMON0lSa2N0c1RBzUw/mI0L1ALYks/cUrbV3bfO4LOY2o7IRyPh6rQijE2IXySWnLn/ym3ASWNWDaHW7S0Vu38nkBdGdldBcdkIgsLm2HTV1tuQMdCVVkwoDdc9KZEHs4aHHvD/fIRSgYnBUWM2hRDREHZvBrqMX1HBZavOfmqy+mRCccPC1DIMS02Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/KzweVtZXVtE/euAVRPZhMRyS2tWgb7hGik40fmKI4E=;
 b=PAXKUJxQRx9fu1Phj2Hnmw66wguYS1jycBYb4cmEQOSy26sC920JcrO2DhScZGHwyMKDUUoGDxGHjBpXJqaeR9JsKZ5tREoclQVKTeWPoh7rZHtmXOhDH8HUGtxbGTZ3rMOmOPNfMp23kSbrKVf1Z4EOjJzK2fH3irIcv6U9D+QKFCS7S+xXK3Od4rnNsXaBo8lUtj70xwyATSmghRI0lgth5XrhyQ+apBhT34cailqzR9JSWibdKz6e4teA7glkOdJlar8zLSty5z7lR9PzuHVh8nN17skZdy9pPFOHJclQvSSIGYcQdzWAqUhTDAVpxviu54Xip/ISTq0D5C78tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 02:21:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 02:21:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Topic: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Index: AQHapmM+V0hpZvOG4Euj+PM9FPWPubGYSbqAgABgPoCAAAP6gIAAC9oAgAANSYCAAB/SAIAAE0QAgAAon4A=
Date: Thu, 16 May 2024 02:21:40 +0000
Message-ID: <a69d1a1bca645fbcc450e2ded425cc3ab8f3d145.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
	 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
	 <ZkUIMKxhhYbrvS8I@google.com>
	 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
	 <ZkUVcjYhgVpVcGAV@google.com>
	 <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
	 <ZkU7dl3BDXpwYwza@google.com>
	 <ec40aed73b79f0099ec14293f2d87d0f72e7d67b.camel@intel.com>
In-Reply-To: <ec40aed73b79f0099ec14293f2d87d0f72e7d67b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7272:EE_
x-ms-office365-filtering-correlation-id: a5137185-3a06-46d7-6336-08dc754eec09
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ODUzdm51NlpVV21ieDBWRE5DcXhhN3kxQlJtbmtGaTZDZjhKSjF6a1RzVlM5?=
 =?utf-8?B?NEJtYzRWakEwYUtNZnlDMzhMWUk5Rm5odm5qTFN5YlRUa0JNMWQyWC9JU2J5?=
 =?utf-8?B?elV6TFFMUEJCR3RYcWtmQmR6MjBJaG05czZwbGt0WWsrcmEwbW5FVGZ2REN0?=
 =?utf-8?B?WDUzNTlkV0FTSUlWcmpTdnlBZXdGUEl3eDh0R20wcHIvQ1doNnNVczc5ei91?=
 =?utf-8?B?cWlCSFFDbnJLMnJqUE0wNXM3S2xZNXdMdFdhT0JrMVlFcERVRVI5SDBOaHZP?=
 =?utf-8?B?NUQ2OHA4K3Q1MVJqU1VMc1R4bGdIVkV0dEo1ck9xa3pGYmZFUGp2SzdMRzF6?=
 =?utf-8?B?cHIrYlJua2RQbFFoUFBxM2M5R2ExY2hndm1kR21kVjY1dEFpV09Fb1JiU1JR?=
 =?utf-8?B?RHlhZ2lrMmZYMmE0NkR6QVlYMkxwZ211OEdiWm12dUx2TThkcGM2VjB6dEZL?=
 =?utf-8?B?VlVrSUNCK0s2UDNBOWJIdTUrNnZHN3FuaUY5aGpPTFVBTndNZVpSU0orNEdm?=
 =?utf-8?B?dTBZUCtTNm9sNFdTdXUxRG02cWFoMHY0bW9GRlRiVll0eWdHS1V1T3piVUs1?=
 =?utf-8?B?a1AxMmVzcndpYmg2OHo1Z0NUdWdzblFVc3llMktwMlY4bVpMZ011ZzZQSkdq?=
 =?utf-8?B?UktMeVVOQ2tJTWVkbDhFbzV4dWNwS09ieUxlK3VsV25YTHZ4YjRSQktoY3VF?=
 =?utf-8?B?OWdSL2l3RThJekIyeTNsRThKMFNEUnVEY0N5OEt5S0lUWEZHVlFGR0tIcWpw?=
 =?utf-8?B?bUoxekNXSjVPWVliOEk3SUlORG5iUlRyc3lDUDBEMnVZbC95bkNGdDJGUFgz?=
 =?utf-8?B?c3FNVEZJY2c3UVJEc242NEZ5RTdDTVdoNnVVK2FjWGtxSnE0bTZBdEUvVXJj?=
 =?utf-8?B?Vi9aZzlvcmNjZURQY3lzT0pycVVLbmowWnByZFBuODcvSGxTNUwvRVpodzNI?=
 =?utf-8?B?T041L2xpNVhBR3ljdGZld3EzK2lYK0RXU29SOGRDVEJVbUVQeVBmYTAyMlh1?=
 =?utf-8?B?RnpYUzU2SW4zM2dYMS9Ib285cXJCLytIQ2NtWG5GeWFaaGM5Q1dvRnhHL0Qz?=
 =?utf-8?B?UlBiT1NJMTJaemFCU0drcm1sMUw5Y0ZhQnM0RS9EaUxRMHFEeU5zamVVQWlI?=
 =?utf-8?B?a1VTbGtIRUYvQ0lvd0pueHAwdUNFSWNXejlrWkJncFo2b0k3am5udnFiR1BJ?=
 =?utf-8?B?V1NsVDZZOUhiWW9sMWR4NVFLUytCWHVnVm9pd0Q1cTEzV29oR2p3NFdVUkZy?=
 =?utf-8?B?d2pWR3M4NDN3VGtEWjdtY3RkQnVZdWlwWjhJUmNLWjJQMTgyT09qRTZlSTRy?=
 =?utf-8?B?Y3ExUFJIRVdUOVI3ZnEwZHMwajN3MW9uN2VxY1ZBdmtiVHYyVlA2RXpzVmZY?=
 =?utf-8?B?Q0JiZks4a2VuWXR1cWtHT2xXSm0yS3hZNmJOR0dkUm1FVUxqTGt5YlJKbjBS?=
 =?utf-8?B?NDB3ZE5lUVVjTnRFSFNyazdNR3hSNVFZWDU3NHlOY1p4dzNEMHFQMDB6OS9H?=
 =?utf-8?B?ZnlwQkV6UWNzYmV2MHg0enhBNmNldUdnMlVJVG9RRmQzS1gxaDBQU01uOURB?=
 =?utf-8?B?Wko5aHFvc043bWV2M3UrbUU0NUkreTQyNy9IY1dENXlBbVBUZGhlb3RTL3Nj?=
 =?utf-8?B?VVdNM0VGRnViK0lUajN0QWk0Ui8rTFpOeTQ1VnVTYnRmV3R4QXEyenlMK2FG?=
 =?utf-8?B?N0FFR2tKU2MxNXg1bVlNdEZwbXdIUUhDbXkxaGVQOGd2TkhUL2t4cGM4L3J2?=
 =?utf-8?B?WXVSd1Myd3V3SzFKTzJyeTNoU01VMG15RmJVOGFuMVYwWFJ6NEJjaG1ER1VU?=
 =?utf-8?B?Y2FsVHZ4SUR2OHpiNUhQdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NEF0RW9rdXI2ckRkK0ZMbDBSUTRraFBsQXdtL1ZXVkpZS2V5d0RaZlcrNWth?=
 =?utf-8?B?czFWNzdGRjN3OURQcjVXekVzUWFZSDN6aHI3Ry9sUmIyeFhISDNmd2J2Qi83?=
 =?utf-8?B?RGdmVU4zdGtGSFNTdGgyVlR2RU9mMkFjVGJ1NDN4TGhWS1djd2RVZkJDOHA4?=
 =?utf-8?B?emlxWW01a1pMSm1sR3BmQVVHS3hVeWkwMzZvNUNOMTc2bHpuVC9Xc0YyaWdC?=
 =?utf-8?B?OW5tWG50MGpzMmcwakIxS3ZvWGpYTDB4YVlzR0huLy9KaitRS3ZzTXZ2cHox?=
 =?utf-8?B?Tjk2Vy9KeFU3ZERyY0N3UWhvMDVNOStwSWJPKzFxUjNibDFteFBuVjhIRUph?=
 =?utf-8?B?NzlhV1JLK2taNitIbkdMZWNmSzRlN0VsODFqb0NjVVl2TCtFQ1hHWmtBUWl1?=
 =?utf-8?B?NzhrMkY0YlUwTnE5RVZjcjY4THlYdFYwQ0hpZzQ2OVBLY2hVcnRiOWdBd1lJ?=
 =?utf-8?B?UmFkYzM4TVl5ckhJcWRDbVNvcUNIOHJKdGJ6VmxLbm4wcTZBcDljRTNmby9L?=
 =?utf-8?B?bGZNZ01QSjBFUlAwR3loRDdyV0FkNGJpSW53VDBnbkl4amsyUzI1blk1QTl3?=
 =?utf-8?B?NjFnQ2plOHo5bFRLb3QwVFpOMjllM3JoS3lMSW9aSnJDcmkycktONXNzZms5?=
 =?utf-8?B?S0toTGFBVDc0alRiOXVRNDhoVVRRdnRlL3l2MVJTbDJndEF6K29rWmoxVlJ1?=
 =?utf-8?B?blphNFdaVTZRU21TZG52SGI1aldLcGxSRGZrNDJwSGhnbEJBYUE0TlRISCto?=
 =?utf-8?B?TitScDUrbkRoQzc2dXBBMFFTa24rM3E4dDIzWE9TYk1YTyt1emtOQnl4U2tw?=
 =?utf-8?B?eExBbFpHTWRkdExackIxOEpidWNkbjU2MFIzS09WeS82OWEwa2JpY1E0VFR3?=
 =?utf-8?B?WU9iWWw0d2dHdDI4bUJqMVc0SlBldnBJL1d1R1Awcm5ra1pzeDJHcWE1S0Z1?=
 =?utf-8?B?UG1IUkRNTWxjOU5DZm4wUXpGcVYyR3VmbzhaeGVPYlJwblZFMlFYdWowajQr?=
 =?utf-8?B?Z2VrUjQxakc2a0ZtVlB0RzVOU1pQVXFsSXFBSE5PQkVxOUVhOERLN0t4ZytV?=
 =?utf-8?B?WWNYbURvNVhKMVlHSVEyYXg3U2VURTg0d2xhcFlsNE1FaVJLV3ZhSTE0c3Bk?=
 =?utf-8?B?M0JrdFU1dWhqUVQwRXhxY1B2NWZ1NDhTZlhYRTVOSjgvUnZlbm9QOENXbzV4?=
 =?utf-8?B?QThOSmwyU3d4VUdtUHRDVG5MYXQyU0xLYVJUSk80NVFDVWZIS1Z2TkVZMlN5?=
 =?utf-8?B?N2oxQ1lESm5qQXRnUDFtNncvWFgrT1ptU2t4MHVTejE3UGVmYXhZaGhhelkz?=
 =?utf-8?B?clZQNTRtdzJEYmc3eHVvRTJ2c0VJQnJxYjdmWEl6Q1dVN0gyZFdhNUtkYmZQ?=
 =?utf-8?B?bGpxL1U5eGR5WmVVdUYzeDJHaDFRbEdNTXE0Q2ZVOGZEck9qQXpkMkp4Sno4?=
 =?utf-8?B?ZmFXWE9UZGdzMEo3SjhUOUpjcWFZTGJGb3JiVWRXTXpKTUtXRWs1cmZGZTlK?=
 =?utf-8?B?OEZRbkpjWFM2YWRJK0duZjRPN3hhQUZ1c3VjcTVFdXRmNS9PWnBpYU9zUWpI?=
 =?utf-8?B?YnBoa1JRdHNsblFqQ1NMY1lObTFFSGpBUGpSSWFnNXRHTlF2bzFkaHhvUUFC?=
 =?utf-8?B?TFlpTDhLUWltbW1XaWNnYUJCMmVnbVV3TTBueCtTYUYyL3dDWlUvTHEzRFp5?=
 =?utf-8?B?QlB3UmRYdlFhaUhla0wwYXlITU9TQ21Dcit0bnlkc1gvcG1xcXREWldKZTVv?=
 =?utf-8?B?NWp3SDZqdC9iUk1wSmxXcVdjSHJGb25DOEFIc1VDc2NSeHY0eVgrbHUyckxF?=
 =?utf-8?B?RTdTWGExRnlvT1NQMnJtL0srdGU0U1RWOERHREJ5Q291TXZKcGowWGpDeHZt?=
 =?utf-8?B?aWpKdGNaMmRMTUFmNTB0WWNRWGhMNVQ1enRJNmt4eHVrQVpXbkNISmpMNms2?=
 =?utf-8?B?UGY5M3NvOWxtTTFTdnpMbHlOQzRvK0plOUhBRTByK2FnOW41QWZublRZdSs3?=
 =?utf-8?B?SDlQMkhIL2VIaVB2VEU5a2l0ZnAzQ0RRSGRyRjg3Q2dSajA2dnRQK2JoUHl3?=
 =?utf-8?B?ZGIzT3Q3SUI1VERiTVpTYjMySWhoYTRZU3pVdCtLZlppT2k3K0xVRzI3QTVW?=
 =?utf-8?B?c0Fua3oxeEx5OTdIZTFYT2dvSFppK0RlRmdYTEl0WndQVFZ4aUQwdHFnSU4r?=
 =?utf-8?Q?iiDPDGNSnG0ffhGPi0Ni9Ww=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10A705299A420748AC5A7D93355178E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5137185-3a06-46d7-6336-08dc754eec09
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 02:21:40.7553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cW9AIaEfeHmcBJ4VmJJc7K0kJtTP1t6lX0Y6kIBgv8240r+jiBWEzsgoBF89wpyLQwW1lFQYRgmdxO1pl7zya8x2MjMaC3FihQN2D5dgdKs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDE2OjU2IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gDQo+IElmIHdlIHRoaW5rIGl0IGlzIG5vdCBhIHNlY3VyaXR5IGlzc3VlLCBhbmQgd2UgZG9u
J3QgZXZlbiBrbm93IGlmIGl0IGNhbiBiZQ0KPiBoaXQNCj4gZm9yIFREWCwgdGhlbiBJJ2QgYmUg
aW5jbHVkZWQgdG8gZ28gd2l0aCAoYSkuIEVzcGVjaWFsbHkgc2luY2Ugd2UgYXJlIGp1c3QNCj4g
YWltaW5nIGZvciB0aGUgbW9zdCBiYXNpYyBzdXBwb3J0LCBhbmQgZG9uJ3QgaGF2ZSB0byB3b3Jy
eSBhYm91dCByZWdyZXNzaW9ucw0KPiBpbg0KPiB0aGUgY2xhc3NpY2FsIHNlbnNlLg0KPiANCj4g
SSdtIG5vdCBzdXJlIGhvdyBlYXN5IGl0IHdpbGwgYmUgdG8gcm9vdCBjYXVzZSBpdCBhdCB0aGlz
IHBvaW50LiBIb3BlZnVsbHkgWWFuDQo+IHdpbGwgYmUgY29taW5nIG9ubGluZSBzb29uLiBTaGUg
bWVudGlvbmVkIHNvbWUgcHJldmlvdXMgSW50ZWwgZWZmb3J0IHRvDQo+IGludmVzdGlnYXRlIGl0
LiBQcmVzdW1hYmx5IHdlIHdvdWxkIGhhdmUgdG8gc3RhcnQgd2l0aCB0aGUgb2xkIGtlcm5lbCB0
aGF0DQo+IGV4aGliaXRlZCB0aGUgaXNzdWUuIElmIGl0IGNhbiBzdGlsbCBiZSBmb3VuZC4uLg0K
PiANCg0KV2VpamlhbmcgZmlsbGVkIG1lIGluLiBJdCBzb3VuZHMgbGlrZSBhIHJlYWxseSB0b3Vn
aCBvbmUsIGFzIGhlIGRlc2NyaWJlZDogIkZyb20NCm15IGV4cGVyaWVuY2UsIHRvIHJlcHJvZHVj
ZSB0aGUgaXNzdWUsIGl0IHJlcXVpcmVzIHNwZWNpZmljIEhXIGNvbmZpZyArIHNwZWNpZmljDQpT
VyArIHNwZWNpZmljIG9wZXJhdGlvbnMsIEkgYWxtb3N0IGRpZWQgb24gaXQiDQoNCklmIGl0IHNo
b3dzIHVwIGluIFREWCwgd2UgbWlnaHQgZ2V0IGx1Y2t5IHdpdGggYW4gZWFzaWVyIHJlcHJvZHVj
ZXIuLi4NCg==

