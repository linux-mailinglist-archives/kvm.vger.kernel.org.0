Return-Path: <kvm+bounces-32376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A9549D6314
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 18:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D9ACB23CD5
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 17:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5CF1DF730;
	Fri, 22 Nov 2024 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mz5csps9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491F58BE7;
	Fri, 22 Nov 2024 17:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732296594; cv=fail; b=SxyOcKvgRUR+Dmxqty9+AKtF+zcemvmx78hOircYMGeoa3g/WkEgNEV0RL2VA89qTwih80KtK7Qtwnyf8jj+FJ3rfBr4lw3J89u23IFfaBEYDHmL1EdrdE97MHqznv1rqP93mFm08iFfR1wDB2Vh82cPCNoJDiqO9Iakruw226g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732296594; c=relaxed/simple;
	bh=hmKKOXTaJdRnezrU4wXfHbbs2J61so61gwoLE2OEv28=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NdMPXCezowY2mW8HH897d33/tugtYtJN6VI6jYKYZdt0rYldexrUH3OWGysgp0ijOl1c+rAN0k6kbooWsfSLln9LP4a/h5Zydd2nXNwNySWXKk1ChjWHr2bwfCu0ghUvM7epD/XuLYssRXrrVNsKoWdoUtf9yPwf/pvVHyHFFjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mz5csps9; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732296593; x=1763832593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hmKKOXTaJdRnezrU4wXfHbbs2J61so61gwoLE2OEv28=;
  b=mz5csps9lfv2l0w8k2cXHrWZNXVh9tzpyQncSh1p6Bh3iqc/5eDEUz8g
   8cka/W2Z6XJtycAO96JngRDJOveruYTyrtJtZy13W4d9yK5vqPWGOEdad
   T3GGaN5rtKj0UlSyI/uPY6YM+rPUmBdZBn5xFNpyzPvmtXDIgnKcX3LA3
   FTlhtSOT1YQZLJpNsE1VAPSB2gdboD7yA7ty2Q7YQDW38ZdHzI7+OHZy6
   R2J4kPKFxG5X2oT+B7vFSPwcm0CvK7z3tW0da0oVIRzmiWkTDoF2OTsRu
   RtMarGRPyufqk3Ss01qs4RrL3q9gG/GRkkY8mjtWxtIfcBSagPo0TFKGf
   A==;
X-CSE-ConnectionGUID: W2S+F30RRtuCGGdNQQ9sXw==
X-CSE-MsgGUID: glcs9dbfRNydmAMfhwIOVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="43839052"
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="43839052"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 09:29:52 -0800
X-CSE-ConnectionGUID: X8Th0biaQlSgmjKTha8GKg==
X-CSE-MsgGUID: ++2ZvcZhRq+SSkELYN3AhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,176,1728975600"; 
   d="scan'208";a="91059824"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Nov 2024 09:29:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 22 Nov 2024 09:29:50 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 22 Nov 2024 09:29:50 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 22 Nov 2024 09:29:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mBQYl4X2hW9+kPiOAz/YLLpemtUKv4KnwZjL6bh/QOZlai+slPdu5NLiL77pXrqQMfdny2DfcIfMN0Q/0+HnP4x7Ceh2xIWeofn9ceE/5boAnykzmwoAmzqLXoxG4MPK1HU70Nmi3qo6Ppx7sxBBA/BeUjxbNc5g9efk+qV2MB+b7ao5X9R2IUQOGL9BiJVWcQGMg9gNZW+6at+J7/eAjr0/2BsStK/wPBpO+xqFiSO5b8MQk98PpX29oBEY9hhZ5tU6fOJeD045AwosnYn8JyqaYZ57fryFUA6xL8sJo/NxUZl5AYx+NLv9/ThSIRQeiJPQtm6zjs6MbaWHcbC5ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmKKOXTaJdRnezrU4wXfHbbs2J61so61gwoLE2OEv28=;
 b=IAlL73eFo0EIYR9k2rbICAMUoZQwEpKRMUaRo5i54zRWauw0ioiiKTC8IB4EDLsp5lyqpzP0yMcCfwHwU0NdfjAzyX6FS8T+HUZTnhsBWSKYEY4tY/74AS2jVOmOmSXgjEr6D1+aMrpLT9xQKtOpRnl7q1HwARSG1GtHzihps3BATmyxcyv17vi/Oo+krksY1MAowA/Bv9vcVB7Jmm57XX4P3jkLb+nm+wfAzjwp0+Ez0zDMn7CL0cxbhkzZqCyZGanP5Jl6ay71mLI43nsi4smZrn1AqUT3p18Vkpfm5m0g9uY363XEkB8zTqckgny2Lw7A6YMV5ZqIqEnBCh3IwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7863.namprd11.prod.outlook.com (2603:10b6:208:40c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.27; Fri, 22 Nov
 2024 17:29:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8158.023; Fri, 22 Nov 2024
 17:29:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Yang, Weijiang"
	<weijiang.yang@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
Thread-Topic: [PATCH RFC 1/7] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit
 TDX guest
Thread-Index: AQHbPFIqg93OSP/8hUeVPghB8n8PLrLDfg0AgAARjYA=
Date: Fri, 22 Nov 2024 17:29:47 +0000
Message-ID: <018aad4190bc7e8142606dce2d3ff9fad9cf9b4c.camel@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
	 <20241121201448.36170-2-adrian.hunter@intel.com>
	 <83defc08-c05f-438d-9c64-a46f4112333c@intel.com>
In-Reply-To: <83defc08-c05f-438d-9c64-a46f4112333c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7863:EE_
x-ms-office365-filtering-correlation-id: 38a5cd9a-39ec-422d-a649-08dd0b1b435d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z3N6TnRJWFB1dzdHb0VzN3hKVGRhV1doaHZ6OUJVTHdDb0ltTXFLVkdZWDlC?=
 =?utf-8?B?UGhuMm5NL1hlcUlvUW1CTFhQTFhkUUs2bEdKcFk2enhiOEg5NzdrL2NUK1Bx?=
 =?utf-8?B?N3RsS3JEcVR1a25EUmFZQzhLY3o0YXZ0blpWVUdIN1pBOHpmcDM1QUJIY0li?=
 =?utf-8?B?RThzKzRvM2twY1prQ3c0TXQ0N3F4MERjOWtpZjZEbXVoVjFIUHliUlNrcHlu?=
 =?utf-8?B?SWhBajdNOHlRL3dIQXpYRExkTEdBM0RPLzJlL0ROSVZYdGQxK01iUGU0YytR?=
 =?utf-8?B?Q2cybVdJczdvZkw0NVpFbjk3eFlBQ3p2K3JtMDI1azRnWDRCamV5eEJuVnQ0?=
 =?utf-8?B?SSs2aWhCWU9FMkF4dGlDOE1CMERNb3E4UDVCaVF6YnBxT2dya1ZDdVB0eHFw?=
 =?utf-8?B?aEhrajg1ZGpuZ1FkN29xS0l4SUk1UkdPckgyY014YWJUTXBQbXdHSEpack1w?=
 =?utf-8?B?S3dQNkkzSm1WK0NKSWRnUEt5Z2FxQVo0V0w3bmtId2RoRHJnWlVCVkdlMGJu?=
 =?utf-8?B?RkhoYW44ZVA3U3dTS1JQcEpsRFFKd1dHVFlSNGNtaG5OQWErc3l4M3VKTUt6?=
 =?utf-8?B?S0gzbjZuTFltc3pVZGlIaDdtY1dqQ083OVBXd0psMjhXcmx0Y2t4aG5ZaWkz?=
 =?utf-8?B?THVWZVRUZzdEYThEZHREcmgrdVdFMi96Q2pMM1lmMDYrUis5TWthVjlxUStY?=
 =?utf-8?B?K2dLQ21rR29rOXRCQ0VMblVCYXF3d0RzV3VVZHRIYnRka0lKVEhmbGFhbysz?=
 =?utf-8?B?NmJ1cDNyczQxQ1M5eXRaTmpmOWJ1L3U1Uk10VkV1SXI5eXptMTRldHp1ZUU0?=
 =?utf-8?B?akJXQ1VZd3lWTGw2R0c4d3RyNGMxanJ1ZTBIaGlFVElnbmJlZkpnTHJoQU4w?=
 =?utf-8?B?bXB6SmN0Z3dRMGFkQmhaQWRaWHlRbGNnY1AyTXFiMFQvQ1UyOGNrc0JmOE5W?=
 =?utf-8?B?MXp4Q0NkYTFXYVJXLzY5ZERoTnYrcVBBWGpQQ1RjSktEbElEbVJCeDJFZ2t5?=
 =?utf-8?B?Vmg5R0RUL1RmeDdpTjdGb0ZYeW9YK0xkaW50MStpZ0g2ck54OUkzSHlOVmtZ?=
 =?utf-8?B?N0pkSkwrMHlUaUZ4eU9vaThGRHFUUkgyRE1zUVhWOHR0NFYzTlR1LzQ3Lysx?=
 =?utf-8?B?OENuQU1zbWdEODl6YitvL0ZZaHhGZGh5Y3V2TUNXNTRyOURmU2hQNnZXRUQv?=
 =?utf-8?B?UXJ2ZGl3NjQ1QnpBeU1vYUR0TXZRREpEeWVWTU5waHgwR2t0cUFqdXVwelR2?=
 =?utf-8?B?M2dRRFAxM1FUdnl3RGZ1eVl2MmlJc2NoR2pwbU5QWWdrVktmZlQ5SmZmelRj?=
 =?utf-8?B?MDF1ZHppdnJkQ2xSZ2ZSdU8wS05FZEE0SUVUSFVWNy8vbzBCYU5zajNGYnVl?=
 =?utf-8?B?MnQwQzA3Yk94MldRVFVjbUtqYm45eEtkZjU0dnhYZkFTL01sQ1htSTN0RGkw?=
 =?utf-8?B?b3BVaU5MUVpKb1orNFJwNFBxM1Y2WUI3YUVGK3NrdWRqSFlCczFBeklXalcx?=
 =?utf-8?B?QnZLL3NLQlJ1TVhQak1JOFZJYWlOelpPQ1BOaHlsVmdSaEVmNUhpcXZoQXNN?=
 =?utf-8?B?WkJzcEdSanpwZThCditKU2k2ZmVrcHZ6dW5zN2ZUM3pYRHVQdm9aeDE2RFRn?=
 =?utf-8?B?L1NQcEpsNlJHckxTVEFrL2J2cGE2cjloRnQzWmFONGd5WVRYYUlNd21ueW1x?=
 =?utf-8?B?YjN2RVFvM2NjT0RhQWhwQ05NbmllaTlVeStFWkZ5NzZDRVdGNTQ1SzcrSGo5?=
 =?utf-8?Q?Bsoa9SasiLMfXcccNxTbPKMGvihI+W+EVhnDTm3?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1VXVVZWd1NFK0d4R1Y0UTdWaXBIcHNjSkhmbVhaTkREaVdyREpmcG56OGJh?=
 =?utf-8?B?UU5xNDZzd0JXdGFrTkVBUzRrN3RHbVBtaGtFUWMzb2pkMUp6a3ozSHRVVEx6?=
 =?utf-8?B?ZG4wM0RLUXRNZDVhcW1jQ2lsWFFZU25RbENiZ3NxSmtWODlycVZYc0IvYXFC?=
 =?utf-8?B?YUQ2UVFpNUw0ZnMrekNzcWxrNlI3SEJDWVZjUXRocXhmd28yaDMrZ2l3MkJM?=
 =?utf-8?B?UUZyTE1uMmYxSjZISExHZEJGcEtWcEZ1b0JDMC90NzIrNmNMcmJSZnIrekVv?=
 =?utf-8?B?anlWWFI1cUJLZXdlRHNXUW5KY3JoN1pzM2pJa0hQODhDbmpuRXlNTm5RU0xi?=
 =?utf-8?B?ZmVwcVdRSXdOVWxWRVNub0g3Sld0MzdxRDRiUXRmOHQxRWM3R1I5U2N5ZkM4?=
 =?utf-8?B?UGI3eGFCM3ZrZXBjUEdVQnUwKzBYMCtCVEhpeGg0SkU2anBkdTVMZCs1TGdC?=
 =?utf-8?B?L2I4QTBnT0NuaU9hZVo4MnkxL0NJbVd3aTIwbXVTU2s2UStXZk1icWZ1NVdr?=
 =?utf-8?B?Qkw4RkxWcVJxbG1kb0RtakttUFlKWEpKam12Y3c2WEl0R3lPVXlXeU40RU5S?=
 =?utf-8?B?OE5WdGZWYU90amJjQm9yQTl4UzlZOXlvWXg0YkMwaEsyNDlOSmdZWmI5a0pL?=
 =?utf-8?B?bWtOWDQvRXRaVnh4endwVWxBd01tSk9uUlA5bE1iYVZPTHFocHg5KzJwc0lM?=
 =?utf-8?B?Z2szbytVZ1dLclk3clQ0YU5WRElLM0p2K0k0WDJXYmpVZUpSZlFvdW53S3hr?=
 =?utf-8?B?dlZ5Uk5aRHVjbTAzQ3hxTENpdlZOVi9jWVpJdFNlRlZTQ1gvVTZDY1cwZFVV?=
 =?utf-8?B?ZXJKSlpLeWdGTHROYkpxeFJ4ZkdEajEzRk9HZDhlblJZc0Z0RlkzeEJGVFQ1?=
 =?utf-8?B?WEJ2OFVzUHR2YXAxMkJlUXJuQTE2VXJGQXNTc3FJQlhwajB1VmJMRzNJOGJY?=
 =?utf-8?B?dStkOXdyVkd6U29YWFJhOU5CckpVVS9wWjFPRm85eGZ5Snl1WHB3eXQ3YUVx?=
 =?utf-8?B?R09tTWFUZEhQT1ZrbUUwRURwMUhzaWpMc1ptdDdZVjROcUpaY3ptRUJsT0RQ?=
 =?utf-8?B?U2NENUdobE5xVlNUN3pZbmU0dzM5T3h6NlNMd2g4bGkybDlRSnVLbWdPOG1r?=
 =?utf-8?B?V0ZLMzM1V3JlVEdkTnJpcnE2MGF2ZG5iNjVFYTVtZmVRSUthMm5MV09nRHgy?=
 =?utf-8?B?YUhKaDRodVJvSkNoQUM5Q3BXanVXa09nd2ZpWlltREhWeUc4VEJPQ1hMcDJn?=
 =?utf-8?B?MGY2L3l6cS9tVzNmeW96U3MrRWtFT0RLMEdUZ3F6SWJBekt6RDBDZk95THZ2?=
 =?utf-8?B?Qm9wUFhENUpGVmhXcEVrVDBTSnVUV0NOUCszMTVGTytCRFEvOFhBa0tLejZz?=
 =?utf-8?B?dE14N3U4UG84WGM4RzZIeW9EdW9mVksrVENmd2w4ZXYvQmU1dUVDMVlPczVW?=
 =?utf-8?B?SUg2OXFaVnIrcTBsQkxVTm50RVFrZTVwQnpjeFBtWGliUE1sY3pLWkVPSXk0?=
 =?utf-8?B?UFI3TkZmOFBrV1B5bE1BYk00RHVBblp4R1FRb1MwaUpKZXFYZDhPampkaFA3?=
 =?utf-8?B?dHBOblVvN1lsMzU0a3hKbnFSbGF0MUhNZDh0aTArY0ovQXlTSjhMZ0tFS2Y1?=
 =?utf-8?B?MVR0aVhsdHo5VGRSclRGN05NZmszRVNLQlUwanZhYXV6anJxRGVzV0QrR0tX?=
 =?utf-8?B?a1lRTHkvNGlNd3dnbkJ2QUN4Rm1SMWVnYWc4TDhBZGlqc3RzSHpnSVlSY01r?=
 =?utf-8?B?dnk4VUJJUitMdmVxa29Wa3NDVUlkZ1ZINHhhM0t5Um9uNEpNZzhHdmRKQVJN?=
 =?utf-8?B?L3hVMkNVYlZoZ1VCdTFJM0taa1pRNmp5ZXNTV0lydVFhMnM0aG9IMG5QNWVM?=
 =?utf-8?B?dnpDdzlSUWlRMm9DZDVhMWtSSmhQYWNjaXRubk52eGJHODhXd0lYZFpjcDFC?=
 =?utf-8?B?Tjg1VkV0aE5JMVJsREFMcUNBZHZhQzJmZXBhZHBETUU4Q3hvSkxJSzUwU2RK?=
 =?utf-8?B?dDY4YnMzbVFQR0NQYTBoVjVCTGFpOEF4WDh4SnpSTHdCZDV2cUR1SmlrRnZv?=
 =?utf-8?B?cUROZHA4aTI0L2lLS2wxN2Jab0RZMmNjYVFtK1p3ZjhIU1FxcXlwa2ZSSEl3?=
 =?utf-8?B?SjdidXNWTVJzSFljRGkxQlJKd1E4aHZKR0psNGJKVGt0elcrdlVKdGhOd3lU?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6385F16348C40D4491D876EBABD0DE74@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a5cd9a-39ec-422d-a649-08dd0b1b435d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2024 17:29:47.8489
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QVuxThr4LXE08Y4qCF0jPrDZqbnLTcu7NDJrobLrmgQO9btbPHDD6XmM186r8pS/rT33F+sS2F+5H1PcUIdU/q4tKrQyMhBwRSl0VstSNO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7863
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTExLTIyIGF0IDA4OjI2IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTEvMjEvMjQgMTI6MTQsIEFkcmlhbiBIdW50ZXIgd3JvdGU6DQo+ID4gK3U2NCB0ZGhfdnBf
ZW50ZXIodTY0IHRkdnByLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKQ0KPiA+ICt7DQo+
ID4gKwlhcmdzLT5yY3ggPSB0ZHZwcjsNCj4gPiArDQo+ID4gKwlyZXR1cm4gX19zZWFtY2FsbF9z
YXZlZF9yZXQoVERIX1ZQX0VOVEVSLCBhcmdzKTsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9M
X0dQTCh0ZGhfdnBfZW50ZXIpOw0KPiANCj4gSSBtYWRlIGEgc2ltaWxhciBjb21tZW50IG9uIGFu
b3RoZXIgc2VyaWVzLCBidXQgaXQgc3RhbmRzIGhlcmUgdG9vOiB0aGUNCj4gdHlwaW5nIG9mIHRo
aXMgd3JhcHBlcnMgcmVhbGx5IG5lZWRzIGEgY2xvc2VyIGxvb2suIFBhc3NpbmcgdTY0J3MgYXJv
dW5kDQo+IGV2ZXJ5d2hlcmUgbWVhbnMgemVybyB0eXBlIHNhZmV0eS4NCj4gDQo+IFR5cGUgc2Fm
ZXR5IGlzIHRoZSByZWFzb24gdGhhdCB3ZSBoYXZlIHR5cGVzIGxpa2UgcHRlX3QgYW5kIHBncHJv
dF90IGluDQo+IG1tIGNvZGUgZXZlbiB0aG91Z2ggdGhleSdyZSByZWFsbHkganVzdCBsb25ncyAo
bW9zdCBvZiB0aGUgdGltZSkuDQo+IA0KPiBJJ2Qgc3VnZ2VzdCBrZWVwaW5nIHRoZSB0ZHhfdGRf
cGFnZSB0eXBlIGFzIGxvbmcgYXMgcG9zc2libGUsIHByb2JhYmx5DQo+IHVudGlsIChmb3IgZXhh
bXBsZSkgdGhlIC0+cmN4IGFzc2lnbm1lbnQsIGxpa2UgdGhpczoNCj4gDQo+IAlhcmdzLT5yY3gg
PSB0ZF9wYWdlLnBhOw0KDQpBbnkgdGhvdWdodHMgb24gdGhlIGFwcHJvYWNoIGhlcmUgdG8gdGhl
IHR5cGUgcXVlc3Rpb25zPw0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vMjAyNDExMTUy
MDIwMjguMTU4NTQ4Ny0xLXJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tLw0KDQoNCg==

