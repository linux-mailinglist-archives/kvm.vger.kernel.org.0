Return-Path: <kvm+bounces-16033-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 691808B3464
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 11:44:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CFBA1C2293A
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 09:44:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C37213FD8A;
	Fri, 26 Apr 2024 09:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dm3OsAiR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C11F13F420;
	Fri, 26 Apr 2024 09:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714124681; cv=fail; b=SSXrmeAgZvtdjn+y1mNMxFv+vMk9YUfDO/5X2OqXgJwt/cyP3RWSCFVIErZ2tn4XZMYdj6Gzs099JwxdEFSEhnYDHw2fRqzkdlbFNeca0ZCdPMF12U2BEsjADdcndSE3Fk4tG5Qsa0p3sd5yingfQmh5bqNYXh76xfHk/bypp0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714124681; c=relaxed/simple;
	bh=TPiW9dp3pl9y2lJD44+Hn9+qF+a6li60dHY0E8VQqE8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PYZjXSZuV1fX15t6dgzZw/Zq0m69AhjmF5qJTh7r/toM97ISvPSeDqDmUzIjFtPK2cQJFITVHDHsfl/J+GJ2OIC6lXm9epW2vUzvpIq1YHrJ7qy/4qjDg0+icLhEsleOxTI2D1Crg0DKtxSr7M26MygZKNIYhLMNHq2/lWNVBQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dm3OsAiR; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714124679; x=1745660679;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TPiW9dp3pl9y2lJD44+Hn9+qF+a6li60dHY0E8VQqE8=;
  b=dm3OsAiRSEzUyql+i4hbShTI83HpL5OMOo+V3OdDykCg/xKf4BHKb68b
   a0CN/lIqgOsR3Eez04SaVXzZPhRI15JTGr0Fm/Uy655DQLhnXOv+PovQ4
   rlDbVmQ1s1A5Zy40jY/tI52ifQ1WGtdHily4ZIQcXAfrcunTnS9vY8QP/
   WHkYj5KyMwR3fZqUQS5GsiQi55tKASIS96qonyYwRv3IqyCGzbtNqeZkL
   TTrtxUvk5U/3meEsPvKbon6KUiZ2J4gkr0F/kLj85wytwWUqtwHydcEtu
   BbCmQIgOU/QgV8w6f9ipAFZ95yC+K5FDDfomX/rKZWs5S7LRKuc8kc5iz
   g==;
X-CSE-ConnectionGUID: QJIJ8zpeRK+HdHiL+HFETg==
X-CSE-MsgGUID: xmEJHOstTXW5QHLp9XrnNw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9973059"
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="9973059"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2024 02:44:39 -0700
X-CSE-ConnectionGUID: iWzUokwCS/i0Q3xKsv3O0g==
X-CSE-MsgGUID: wHSpRpuiQDGviL2m/jPx8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,232,1708416000"; 
   d="scan'208";a="29817867"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Apr 2024 02:44:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 02:44:37 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Apr 2024 02:44:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Apr 2024 02:44:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Apr 2024 02:44:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+P0nmnOnIaUG0r/+n1WKzGP8vBpkXxS1LrN0G5XCXkEwL5h2bDtt8SjpVJNG7BsP2ZuqJRbtKp6jKZtRtWuWT1A62XftLuuz4oyj2BU4hyr7CAdccECTbFbEinvtOMeqj3pqWfOu5Ws524hGUjR+S1NBNxtmAIwJ1O6YYgPlDGWgpcyy2yqzR7nlJizHRWjKM+W9GmLTTSzLw8Y2wd5i1BsdLFUfn/UYpomFf0VLu4m3edWGQX7Y0b1Kq/Fc3ErkiJMj2qprdzojPBvYUGlDj4EDkHrAirJVQLyKQ5xc6v5WWmiOw8b9SK041VDsOpTmm0SzAuGbzKnD3l7UGodTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TPiW9dp3pl9y2lJD44+Hn9+qF+a6li60dHY0E8VQqE8=;
 b=JImX/eeOpelqh63CbBI/rPfrbM1A9IYGWXp6jzYTJ+zF1ij38LEbJBjr/+frLfiVLD0pLv0VyV9Uji/REU1z7WBJvQB0ttg1nYpNYuC2mT6imuEY5cSX3KYtDvOT01nZK99HuktSl1sdzUS6KTAKt9OthOmGM5m1oywd378P70BX+D01WTZCZB+Od5jNXzw0/l4L7BzWKV8ashkQKEgwcqpa/GvXTc869YBfQWlk9bK9NJPTBtPuvVo86hvNzp3ERZdlOWRx+h4L0DY/W/OK/UzWbi3IUdgL6EKbz1FiNcC8Ol2MJNiF4tpnfE8jKrmvXm/aT2j0P3cEYkfqYwroHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS7PR11MB6126.namprd11.prod.outlook.com (2603:10b6:8:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7519.22; Fri, 26 Apr 2024 09:44:33 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Fri, 26 Apr 2024
 09:44:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAIAAAz+AgADiNACAAIG7gIACuUQAgABYxACAAAQogIAAJWeAgAAyNYCAAGrsAA==
Date: Fri, 26 Apr 2024 09:44:32 +0000
Message-ID: <1fd17c931d5c2effcf1105b63deac8e3fb1664bc.camel@intel.com>
References: <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
	 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
	 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
	 <ZifQiCBPVeld-p8Y@google.com>
	 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
	 <ZiqGRErxDJ1FE8iA@google.com>
	 <22821630a2616990e5899252da3f29691b9c9ea8.camel@intel.com>
	 <ZirUN9G-Y1VUSlDB@google.com>
	 <2caa30250d3f6e04f4e23af96caed0f92bf5f8c3.camel@intel.com>
	 <ZisdtTJoqe7yxnvI@chao-email>
In-Reply-To: <ZisdtTJoqe7yxnvI@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS7PR11MB6126:EE_
x-ms-office365-filtering-correlation-id: 522bc97c-d89a-4f4d-1ae1-08dc65d57a14
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WDd0S0NNa0J3QXNDUWNrbFdET3B1Zy9wWUJVa2hEZy9EdFVmTlFhUEI5ZDkw?=
 =?utf-8?B?ZjBYUDR3dDVMMzlUQzdnaU82Z1JtRUJEQWNHaE5HbHR0K09rNTJDRmRxa0w0?=
 =?utf-8?B?OXBoNUpWaEJoakRUS01rOXQzWllqcWRVN2RNanpYdzltZ3pDL1B2UG40Rk1W?=
 =?utf-8?B?TUZoZWxwQVNUTWhxem9MRklKckV4dnlHYnVYZTNDUGVmTUQ5UkJvYjlWVnUv?=
 =?utf-8?B?UXBYb0JtMVNhQ1B5Y2dkZkNvdmdUOGlNRXNIVVlEbTdwc3diZ3JHZlpPMXBV?=
 =?utf-8?B?UjAySHA2cnIxNXNIcndoak1LL2llQzlLWng3NTZTNEl4bWZIRE9RSldjUGJu?=
 =?utf-8?B?STZFQXl1Zzh3UXErZ2J4M3RLdElTSjVleFdTR3dubkE3WXdMVGVvYUEzc1JO?=
 =?utf-8?B?L01yWEJoYWtQZkJkVmhWanNiOHpJNTBERkNYNW5WUE1YaExQeXd0VlIrZ3lX?=
 =?utf-8?B?SHZCQXQrYnY4TVdUbkNXbTA3aDhUNkZkY3piMnVDTVEyWFJKVGN5L0NHVWpa?=
 =?utf-8?B?aS9waUQ2MDVUWlF5T2ROUTY0VWg0TS9NTmRiandlRmd4cEM5OXZlckQvdTlP?=
 =?utf-8?B?dDFaTGtxTmZ1KzlGTDJyRWwreWcyR1NnaDZqMDZ3U2RPbEpuZTN1Uk93SmxB?=
 =?utf-8?B?YTZhZVVERFQxRC9wWnhzc003aFFmMFl3cEM4LzZCSlpJMTZRY1VWUkZrT3Zm?=
 =?utf-8?B?SUh5aWREd1FxOTJ1c2hVUmtiRmJldC9pSVZHbHo3dUllSHJLcEhaMElTUXpR?=
 =?utf-8?B?WUNwTlpJaFUwUDVtVmhJWlZzRkhaZ2EyMjQvUWVnNTkxWkdUUnA0a2pyZ05L?=
 =?utf-8?B?WVJCeFpRVGFGYmIrY0FSNWZWOHBPbTVxbWtHb0p5UmJSeHc0KzFpNFhMRGps?=
 =?utf-8?B?K05qTUl4UEw5TlVZRm9oQ0I1eU8vZkhmekcvcHFNVlNWOEpjcEh1Z3FOMWRR?=
 =?utf-8?B?ZzBGcmFlWmFoZDN3K0hrenZmaXFoNGp0SUVPNTVkRDU0cXJyV3hsYVpCK0Ex?=
 =?utf-8?B?RW9pd1FKdysycFN3TWhKbThJbWU2b2o4aFMzOW8zNW5CRGUvL0NTRGFLVUdn?=
 =?utf-8?B?Y0NBOS93REJXVlhERm1pUnk0Ykhhd2ZGUEc0V3lidEMrbnFPY2l1ZXMxSzFk?=
 =?utf-8?B?c2JQM2JhaE9VcXhqWjJOSWJNQUNjV1ptUU5sOFFWVmdJb3l2cEkyL2t6bEcr?=
 =?utf-8?B?RlpsVTVnL29jN0dRY2k5L2lSV0ptaVFkL0kxQkw4LzVPQUdhQ1ovUlc0V0dW?=
 =?utf-8?B?VjcwMUVnaFUxMGh1T1lCRk1LVXMzWlFnbDQ4MHB2cVZTN25PWC9aR051Nitk?=
 =?utf-8?B?Zk1UVk95ai9jQXMrb0NsS3F6dGlLY29ZRU84MWo0NmNZTzdLV01OK1hVY0VX?=
 =?utf-8?B?UFRJY2V4OU5vMHdKUzJ0Q2NCNWJpajdpNHJsejBSNDBBUDZMRmFKbHJsZERH?=
 =?utf-8?B?dFcwNHRFa1cvMVNoRUxaaDV3c25SZS9vZERqc0tIR1pzbEVWN3l4Uno4cG9i?=
 =?utf-8?B?aytxQnZKaHhhbEZWdTB3VW9IQWF6OFVoV3YrODBxMTFSY2NMZkhVTXJ1TExI?=
 =?utf-8?B?TmE4NU5FcUFQVzFGVEhrSHVPTDhBWitaV21JZ2JXajR6OFhwTXVhYjNYOStn?=
 =?utf-8?B?TUM1MFg0V01tM2w3ODM5UXZnUUlUa015UXZHVGVXbHdiRzR3WEQ2NkxUUGpI?=
 =?utf-8?B?UVZ0VE0vcmxqQnV2TDU3L0pNTzFUakI4QytzUjYvZFR4aHdDQ1daSkJ3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QklWaU42VjJFS01CaC9CaVhvUnhSVXpqTzI0ZDArZzkwbUFVampycEx2MGhw?=
 =?utf-8?B?U3R2d2dZazZYUW40b1UyYktMSVoxdUhvMmhsUVUvUjUvbWxBS2M1LzFnd0F2?=
 =?utf-8?B?OXdmQ1loMTVJOXViQ0JlbVdrU0Q3cDJLeXo0cFMxc05VK0JMMmhTbFBxaDVU?=
 =?utf-8?B?cFh4WG96OFZCaTh2UmovK3ZRaVJFMFAySWlBVHpwb0pYTWtYUlpLVEtCeisv?=
 =?utf-8?B?VlRrcC9WYnhMY3BqOXRPM3pYOGs4SnNTalZFUkw1S2R5NWhyVC9nNnJsb0tl?=
 =?utf-8?B?ajlVb2hzY3FIN0hVZ2p5bFBMUGJueklBbkhyR3J5bTBYZTZSdFdzbWpBK3l6?=
 =?utf-8?B?M1RLUDZxdGNYZHBKWGFBZzNzMjNsUkx2NG91ZzBrNU92Zk5kcFlHU2tsaWlm?=
 =?utf-8?B?UTJDNEFBa0lickQvaEk4c0JDSk95SXRGOXQ1T3cxU3VyZGpxMzVhbkpDa05R?=
 =?utf-8?B?aHgxeE05MzNXUDFiU3pkUXRoTVZmT25rSlEwWVk2MDBlTEZwUy9tWVNnVW5o?=
 =?utf-8?B?dVZJWDVRdzNMOXZsWklPdEM0SWl0ck1sdUtWY3MvK1JpNkVlSlZXUWZhQVlO?=
 =?utf-8?B?QTJHalVPK2gxaWQ2UmZzYmZyVzRkZkVBMGFKaTBzNE4zK1huZGlCd0dlVzRP?=
 =?utf-8?B?WUhIUGhXb1djVENhYzNHZDRwbk1Vb09MQU5seW1kZGJGZzBDRW1WT05SUEVG?=
 =?utf-8?B?S1BQOGlKYTI2anBKa3lMNmxYaGZvYTllTUlOVDNJSmxERDBuam5hWlcwVGJ2?=
 =?utf-8?B?OHcyUU1zM1h4ZXRYL1RsYnZZU2puVUlQL3dHZm5PbEFJeWtzQzJLSXpvRXNT?=
 =?utf-8?B?VExIaU1SbVZlNElNeUVHTndKeTZnNFVNb1VrNmwvbGJjb2pIM3A3anhvNit4?=
 =?utf-8?B?R3U0QjhjZW1Wam9OSHJZZExQaGJINkc4aU9TcXpTVlhBLzhIZWlzNXEwQ0R6?=
 =?utf-8?B?QUxPeTdidGpKZUVjV2dMNHpjaG9OTTJ0MzRoQnlZNXNPMVErRUFveTdmaXd6?=
 =?utf-8?B?cjliYkpwaHVDRTFpZitGN1dFS0U3LzV3N2ZDa3M0U1BJay9MV0RuWkxkdng4?=
 =?utf-8?B?YzdscWZPSTVxTld1NDE4YTV0ZUNPakhXSnRadml3SGFGYXN3eG9CN0Y3TTFm?=
 =?utf-8?B?cG16d3V4bGNZN00rb1k2ZVNaTy9ob2hzZTJqc1B6NERUVVZtdmV3cDRnend0?=
 =?utf-8?B?Y2k1dHN5UmExRnFzMUY4TUdNWjNYMlRxZ3JIYURlV0NhUnNMcmo2M3A4c3pJ?=
 =?utf-8?B?REVGZG9DUDRXVWZtV1BjcnpUTExVVXl1SmZ5QUxaRTJydHlEMzBuMVNpRjJY?=
 =?utf-8?B?VHhRTlNTajliRWRabkZJYWpkOEh0NHRVL09KSkFTMXFvM0xwcFdpWkU3NHlT?=
 =?utf-8?B?eGdnUCtSWTduRUNETnFaZFlPY1JtY0wvMGlVYk1wYU5xeWVENWxyT3ZnQzhP?=
 =?utf-8?B?bzQ1WGRMRlVCUVl1bi9iRWlJellJNyt6cmY2a0NHQzBZUlZaVTdBNDJiOU5h?=
 =?utf-8?B?RkFBSjl4MWRFQXc5Z0YxUEhNSXdWV3FsTHUzejk3MzJSOG9oY3I0QlhZWmVk?=
 =?utf-8?B?MVFPRkxjZ3cySEl2WXlldWhYWS9NbFd3bkJMTGV3QTlZU21ZZFdqdEkzck1D?=
 =?utf-8?B?ZVEvcitpRDZ2WURyeTNyV0ZzZDhiaXRhVWkzd1BIL2tlc0FNdXVxNWhqcGdy?=
 =?utf-8?B?Rzk5blZwZ0VtczQzclYvWmVhaG5BQVY0RGQ0b0NJUkJONFl4OG1xYVl3WHUz?=
 =?utf-8?B?YkJCY3NyUlRPWjk1NS9LU1dScE1mM090Z3NmbzVYY3pCYWRxM3NramZmMzEw?=
 =?utf-8?B?WUsxNERGem9MNTVFNjdtMS9jTGZVSzdoa3RXT01YYXdvZm56UTVmaEFmUXEr?=
 =?utf-8?B?TFRPWVY1ZkNxZ1ZHM2tveDRIWkJUL2Z2RWRYNHZpTWJyc2xKbEc3ZFNjbXBo?=
 =?utf-8?B?NXN4SWNWUDBWRVRqeDB2UnhUMHhha2MxeFJzSXU4K2dVaVVuOW5EbDNlcWdE?=
 =?utf-8?B?NHNCa2ZVeWd1R29yd05wcVdPZ3dZa0s1SkhiSVdzMTR3aHVhRzQ1b2t5UGNP?=
 =?utf-8?B?dzFyUlhtS25Rcm8zZ1AwZkhmdnYya2Y1SFBKdWdBUmpOMkd6Qis5akVBanQv?=
 =?utf-8?B?VEVySTJnWk5WS0FQcXpMTG04VUNuTnRuZUdZcXJNVlBMWE9HbFlBRnJjL2Za?=
 =?utf-8?B?blE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <991AF6257ACF184E808546843E073460@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 522bc97c-d89a-4f4d-1ae1-08dc65d57a14
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2024 09:44:33.0265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8qTWNl/TSOk7E9HVpp0QlPL9fDkh5i/vHY0SaYvYYKsJ1gf/Gp4ho8wW9085re8slThqttvO02QMQPs34wFWhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6126
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTI2IGF0IDExOjIxICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IE9u
IEZyaSwgQXByIDI2LCAyMDI0IGF0IDEyOjIxOjQ2QU0gKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6
DQo+ID4gDQo+ID4gPiANCj4gPiA+ID4gPiBUaGUgaW1wb3J0YW50IHRoaW5nIGlzIHRoYXQgdGhl
eSdyZSBoYW5kbGVkIGJ5IF9vbmVfIGVudGl0eS4gIFdoYXQgd2UgaGF2ZSB0b2RheQ0KPiA+ID4g
PiA+IGlzIHByb2JhYmx5IHRoZSB3b3JzdCBzZXR1cDsgVk1YT04gaXMgaGFuZGxlZCBieSBLVk0s
IGJ1dCBURFguU1lTLkxQLklOSVQgaXMNCj4gPiA+ID4gPiBoYW5kbGVkIGJ5IGNvcmUga2VybmVs
IChzb3J0IG9mKS4NCj4gPiA+ID4gDQo+ID4gPiA+IEkgY2Fubm90IGFyZ3VlIGFnYWluc3QgdGhp
cyA6LSkNCj4gPiA+ID4gDQo+ID4gPiA+IEJ1dCBmcm9tIHRoaXMgcG9pbnQgb2YgdmlldywgSSBj
YW5ub3Qgc2VlIGRpZmZlcmVuY2UgYmV0d2VlbiB0ZHhfZW5hYmxlKCkNCj4gPiA+ID4gYW5kIHRk
eF9jcHVfZW5hYmxlKCksIGJlY2F1c2UgdGhleSBib3RoIGluIGNvcmUta2VybmVsIHdoaWxlIGRl
cGVuZCBvbiBLVk0NCj4gPiA+ID4gdG8gaGFuZGxlIFZNWE9OLg0KPiA+ID4gDQo+ID4gPiBNeSBj
b21tZW50cyB3ZXJlIG1hZGUgdW5kZXIgdGhlIGFzc3VtcHRpb24gdGhhdCB0aGUgY29kZSB3YXMg
Tk9UIGJ1Z2d5LCBpLmUuIGlmDQo+ID4gPiBLVk0gZGlkIE5PVCBuZWVkIHRvIGNhbGwgdGR4X2Nw
dV9lbmFibGUoKSBpbmRlcGVuZGVudCBvZiB0ZHhfZW5hYmxlKCkuDQo+ID4gPiANCj4gPiA+IFRo
YXQgc2FpZCwgSSBkbyB0aGluayBpdCBtYWtlcyB0byBoYXZlIHRkeF9lbmFibGUoKSBjYWxsIGFu
IHByaXZhdGUvaW5uZXIgdmVyc2lvbiwNCj4gPiA+IGUuZy4gX190ZHhfY3B1X2VuYWJsZSgpLCBh
bmQgdGhlbiBoYXZlIEtWTSBjYWxsIGEgcHVibGljIHZlcnNpb24uICBBbHRlcm5hdGl2ZWx5LA0K
PiA+ID4gdGhlIGtlcm5lbCBjb3VsZCByZWdpc3RlciB5ZXQgYW5vdGhlciBjcHVocCBob29rIHRo
YXQgcnVucyBhZnRlciBLVk0ncywgaS5lLiBkb2VzDQo+ID4gPiBURFguU1lTLkxQLklOSVQgYWZ0
ZXIgS1ZNIGhhcyBkb25lIFZNWE9OIChpZiBURFggaGFzIGJlZW4gZW5hYmxlZCkuDQo+ID4gDQo+
ID4gV2Ugd2lsbCBuZWVkIHRvIGhhbmRsZSB0ZHhfY3B1X29ubGluZSgpIGluICJzb21lIGNwdWhw
IGNhbGxiYWNrIiBhbnl3YXksDQo+ID4gbm8gbWF0dGVyIHdoZXRoZXIgdGR4X2VuYWJsZSgpIGNh
bGxzIF9fdGR4X2NwdV9lbmFibGUoKSBpbnRlcm5hbGx5IG9yIG5vdCwNCj4gPiBiZWNhdXNlIG5v
dyB0ZHhfZW5hYmxlKCkgY2FuIGJlIGRvbmUgb24gYSBzdWJzZXQgb2YgY3B1cyB0aGF0IHRoZSBw
bGF0Zm9ybQ0KPiA+IGhhcy4NCj4gDQo+IENhbiB5b3UgY29uZmlybSB0aGlzIGlzIGFsbG93ZWQg
YWdhaW4/IGl0IHNlZW1zIGxpa2UgdGhpcyBjb2RlIGluZGljYXRlcyB0aGUNCj4gb3Bwb3NpdGU6
DQo+IA0KPiBodHRwczovL2dpdGh1Yi5jb20vaW50ZWwvdGR4LW1vZHVsZS9ibG9iL3RkeF8xLjUv
c3JjL3ZtbV9kaXNwYXRjaGVyL2FwaV9jYWxscy90ZGhfc3lzX2NvbmZpZy5jI0w3NjhDMS1MNzc1
QzYNCg0KVGhpcyBmZWF0dXJlIHJlcXVpcmVzIHVjb2RlL1AtU0VBTUxEUiBhbmQgVERYIG1vZHVs
ZSBjaGFuZ2UsIGFuZCBjYW5ub3QgYmUNCnN1cHBvcnRlZCBmb3Igc29tZSAqZWFybHkqIGdlbmVy
YXRpb25zLiAgSSB0aGluayB0aGV5IGhhdmVuJ3QgYWRkZWQgc3VjaA0KY29kZSB0byB0aGUgb3Bl
bnNvdXJjZSBURFggbW9kdWxlIGNvZGUgeWV0Lg0KDQpJIGNhbiBhc2sgVERYIG1vZHVsZSBwZW9w
bGUncyBwbGFuIGlmIGl0IGlzIGEgY29uY2Vybi4NCg0KSW4gcmVhbGl0eSwgdGhpcyBzaG91bGRu
J3QgYmUgYSBwcm9ibGVtIGJlY2F1c2UgdGhlIGN1cnJlbnQgY29kZSBraW5kYQ0Kd29ya3Mgd2l0
aCBib3RoIGNhc2VzOg0KDQoxKSBJZiB0aGlzIGZlYXR1cmUgaXMgbm90IHN1cHBvcnRlZCAoaS5l
Liwgb2xkIHBsYXRmb3JtIGFuZC9vciBvbGQNCm1vZHVsZSksIGFuZCBpZiB1c2VyIHRyaWVzIHRv
IGVuYWJsZSBURFggd2hlbiB0aGVyZSdzIG9mZmxpbmUgY3B1LCB0aGVuDQp0ZHhfZW5hYmxlKCkg
d2lsbCBmYWlsIHdoZW4gaXQgZG9lcyBUREguU1lTLkNPTkZJRywgYW5kIHdlIGNhbiB1c2UgdGhl
DQplcnJvciBjb2RlIHRvIHBpbnBvaW50IHRoZSByb290IGNhdXNlLg0KDQoyKSBPdGhlcndpc2Us
IGl0IGp1c3Qgd29ya3MuDQoNCj4gDQo+ID4gDQo+ID4gRm9yIHRoZSBsYXR0ZXIgKGFmdGVyIHRo
ZSAiQWx0ZXJuYXRpdmVseSIgYWJvdmUpLCBieSAidGhlIGtlcm5lbCIgZG8geW91DQo+ID4gbWVh
biB0aGUgY29yZS1rZXJuZWwgYnV0IG5vdCBLVk0/DQo+ID4gDQo+ID4gRS5nLiwgeW91IG1lYW4g
dG8gcmVnaXN0ZXIgYSBjcHVocCBib29rIF9pbnNpZGVfIHRkeF9lbmFibGUoKSBhZnRlciBURFgg
aXMNCj4gPiBpbml0aWFsaXplZCBzdWNjZXNzZnVsbHk/DQo+ID4gDQo+ID4gVGhhdCB3b3VsZCBo
YXZlIHByb2JsZW0gbGlrZSB3aGVuIEtWTSBpcyBub3QgcHJlc2VudCAoZS5nLiwgS1ZNIGlzDQo+
ID4gdW5sb2FkZWQgYWZ0ZXIgaXQgZW5hYmxlcyBURFgpLCB0aGUgY3B1aHAgYm9vayB3b24ndCB3
b3JrIGF0IGFsbC4NCj4gDQo+IElzICJ0aGUgY3B1aHAgaG9vayBkb2Vzbid0IHdvcmsgaWYgS1ZN
IGlzIG5vdCBsb2FkZWQiIGEgcmVhbCBwcm9ibGVtPw0KPiANCj4gVGhlIENQVSBhYm91dCB0byBv
bmxpbmUgd29uJ3QgcnVuIGFueSBURFggY29kZS4gU28sIGl0IHNob3VsZCBiZSBvayB0bw0KPiBz
a2lwIHRkeF9jcHVfZW5hYmxlKCkuDQoNCkl0IF9jYW5fIHdvcmsgaWYgd2Ugb25seSBjb25zaWRl
ciBLVk0sIGJlY2F1c2UgZm9yIEtWTSB3ZSBjYW4gYWx3YXlzDQpndWFyYW50ZWU6DQoNCjEpIFZN
WE9OICsgdGR4X2NwdV9lbmFibGUoKSBoYXZlIGJlZW4gZG9uZSBmb3IgYWxsIG9ubGluZSBjcHVz
IGJlZm9yZSBpdA0KY2FsbHMgdGR4X2VuYWJsZSgpLg0KMikgVk1YT04gKyB0ZHhfY3B1X2VuYWJs
ZSgpIGhhdmUgYmVlbiBkb25lIGluIGNwdWhwIGZvciBhbnkgbmV3IENQVSBiZWZvcmUNCml0IGdv
ZXMgb25saW5lLg0KDQpCdHcsIHRoaXMgcmVtaW5kcyBtZSB3aHkgSSBkaWRuJ3Qgd2FudCB0byBk
byB0ZHhfY3B1X2VuYWJsZSgpIGluc2lkZQ0KdGR4X2VuYWJsZSgpOg0KDQp0ZHhfZW5hYmxlKCkg
d2lsbCBuZWVkIHRvIF9hbHdheXNfIGNhbGwgdGR4X2NwdV9lbmFibGUoKSBmb3IgYWxsIG9ubGlu
ZQ0KY3B1cyByZWdhcmRsZXNzIG9mIHdoZXRoZXIgdGhlIG1vZHVsZSBoYXMgYmVlbiBpbml0aWFs
aXplZCBzdWNjZXNzZnVsbHkgaW4NCnRoZSBwcmV2aW91cyBjYWxscy4NCg0KSSBiZWxpZXZlZCB0
aGlzIGlzIGtpbmRhIHNpbGx5LCBpLmUuLCB3aHkgbm90IGp1c3QgbGV0dGluZyB0aGUgY2FsbGVy
IHRvDQpkbyB0ZHhfY3B1X2VuYWJsZSgpIGZvciBhbGwgb25saW5lIGNwdXMgYmVmb3JlIHRkeF9l
bmFibGUoKS4NCg0KSG93ZXZlciwgYmFjayB0byB0aGUgVERYLXNwZWNpZmljIGNvcmUta2VybmVs
IGNwdWhwIGhvb2ssIGluIHRoZSBsb25nDQp0ZXJtLCBJIGJlbGlldmUgdGhlIFREWCBjcHVocCBo
b29rIHNob3VsZCBiZSBwdXQgX0JFRk9SRV8gYWxsIGluLWtlcm5lbA0KVERYLXVzZXJzJyBjcHVo
cCBob29rcywgYmVjYXVzZSBsb2dpY2FsbHkgVERYIHVzZXJzIHNob3VsZCBkZXBlbmQgb24gVERY
DQpjb3JlLWtlcm5lbCBjb2RlLCBidXQgbm90IHRoZSBvcHBvc2l0ZS4NCg0KVGhhdCBpcywgbXkg
bG9uZyB0ZXJtIHZpc2lvbiBpcyB3ZSBjYW4gaGF2ZSBhIHNpbXBsZSBydWxlOg0KDQpUaGUgY29y
ZS1rZXJuZWwgVERYIGNvZGUgYWx3YXlzIGd1YXJhbnRlZXMgb25saW5lIENQVXMgYXJlIFREWC1j
YXBhYmxlLiANCkFsbCBURFggdXNlcnMgZG9uJ3QgbmVlZCB0byBjb25zaWRlciB0ZHhfY3B1X2Vu
YWJsZSgpIGV2ZXIuICBUaGV5IGp1c3QNCm5lZWQgdG8gY2FsbCB0ZHhfZW5hYmxlKCkgdG8gYnJp
bmcgVERYIHRvIHdvcmsuDQoNClNvIGZvciBub3csIGdpdmVuIHdlIGRlcGVuZCBvbiBLVk0gZm9y
IFZNWE9OIGFueXdheSwgSSBkb24ndCBzZWUgYW55DQpyZWFzb24gdGhlIGNvcmUta2VybmVsIHNo
b3VsZCByZWdpc3RlciBhbnkgVERYIGNwdWhwLiAgSGF2aW5nIHRvICJza2lwDQp0ZHhfY3B1X2Vu
YWJsZSgpIHdoZW4gVk1YIGlzbid0IGVuYWJsZWQiIGlzIGtpbmRhIGhhY2t5IGFueXdheS4NCg==

