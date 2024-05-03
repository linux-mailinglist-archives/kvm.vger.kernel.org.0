Return-Path: <kvm+bounces-16534-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 195D38BB34D
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 20:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AC99B20F76
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 18:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFED8126F33;
	Fri,  3 May 2024 18:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MiecLUmY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9266E2E646;
	Fri,  3 May 2024 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714761198; cv=fail; b=EygZ5iiyr++bC1odL6T1KFvOxsr/u/53Kfz9Qgarg58xcDFjn9e+pnjAgGGDeEU0L+VPYYAwwyMuO8aeBOn3cHF5JRC6TYCmBjJV5qqrG+2BD8ApUoEMt9SuDIy8uhhLB74mUqSHHBYLWFULPfx/39paKpR91DS9ZxhxSnpd9rM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714761198; c=relaxed/simple;
	bh=xz9O6eKTTDMR5xHoNm7xpJ70ixlh0EVc09cBCqD9OiA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qwql0tPDdtBbjwtRRRLJK3sPyWwaQFM3DFIeEMEtZhT9PGuH9+7zCOnooT+RLkX+yhb+Nk8VD0hX9MmM4p52QZi7AW7gvlq285dkfu0fccu9llmX3LtQJNt49lgghCvbg43rWISu2cW5Y47l8rqHgtQvCyOARVO+xx5AuwMrfmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MiecLUmY; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714761196; x=1746297196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xz9O6eKTTDMR5xHoNm7xpJ70ixlh0EVc09cBCqD9OiA=;
  b=MiecLUmY9EOJE4TZE5iWs8jhDXIRcyUEVMoMZrN8erWowHsEkcjwv3Bm
   yZFJn2kt0Z390IG7WqEgeCfr2XGKzgtgH/Obqvo+7pSNJFPU9boPek3b8
   m08lwD7kZmaa+FmBt5nfv1eQ3M3h5MYJfT3yct/YcsufBy6iGkxAmHoba
   GOhmNd6jkfze8ocs5S1L36SbInCfQiNzxS3BKsJjx2RsHx+wlAr9Pj5og
   ck23wMBFsC6naerSBJfJ+oKF94/n/H/nqiztvnhzbHXC5xpJbGXNx7ys2
   mEL6Q/5HhojVXNz2UaCAUKSLG3EduoUF8mpdXVwNmQSS9T80kxJqhZ7I6
   w==;
X-CSE-ConnectionGUID: JjvgP0coT0yVF1EItsnx7A==
X-CSE-MsgGUID: sqRItVn5SnGiqs9SzAbMLA==
X-IronPort-AV: E=McAfee;i="6600,9927,11063"; a="10412078"
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="10412078"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2024 11:32:50 -0700
X-CSE-ConnectionGUID: pYNYEpy8Q8y+7q2/P4e7vQ==
X-CSE-MsgGUID: rtdx7lY5RRC1lvgySIuT5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,251,1708416000"; 
   d="scan'208";a="27632835"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 May 2024 11:32:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 3 May 2024 11:32:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 3 May 2024 11:32:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 3 May 2024 11:32:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IqF2qkIBRJVPpjpRGW0gQ7gM20zJ/WN/e22dzDdQAuOSd1+e3xYAaGyiZ4xWpv/J4nqneFBwvVDDEwgEx56SwdSuKmlAJvVQKBhnccgPu0L1FzqtSUVAXIifW1SSWGGEUt1xYUiOAce0EsX5AhQoZg+FH2JpyG4WDETaWVTzbB4MP2FTWuhxPeXzqq2KDhsF6BNRTPiAchrZb5jguxjNHQU+LVkfTVJz2paFdZ/QSbWrrE2kj/NSZccmPr2NAPwkV6JwOno5KSSWGj6yTQ6c9MA5+Rdvh0oSBECDiFXoV603QlSEIHbpW+OTSxUPM4U9ITGuRG2Jilq9leqvuHDoMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xz9O6eKTTDMR5xHoNm7xpJ70ixlh0EVc09cBCqD9OiA=;
 b=f9Zaq5VzaLh6qaH5FHJjGy5apQEuf8QJuPtcs2jxCCfQN6npU4mrLL9/OEOEH7dkeL61CUXRARotyCKtNg90Gp/UK7eXGBwXUiCBnZNB/CH4Lzp8KNiIWoq3w3oWxAbhcZUgdd4bH8Ore/JiUsdCfEybTDVctm3qdVEWdypewPbcV8dmgGHog8qTKrc8E6Q0/7COa9keVfwZeTVE3pqNF0NeTjx6eKhj0VaBywkggjXqKRc7IA6Zq2Ub759clmBNCU+Gl6XgoD/68q4Fz3FpeubAn0F6OB4WnFe1slF8WGNelZ/BY8VwhlelrYE2djImJ3CwLEGX9MQPt3k9cx3wxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB7657.namprd11.prod.outlook.com (2603:10b6:510:26c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Fri, 3 May
 2024 18:32:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 18:32:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Topic: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Index: AQHanO1LV4iR6HM/g0OQuJggcdeiqbGEpTKAgAAPaQCAALdAgIAABIYAgABmWgA=
Date: Fri, 3 May 2024 18:32:47 +0000
Message-ID: <ba2b0efa804c26034118c61f1eb6f335fc4cf02d.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
	 <c4f63ccb75dea5f8d62ec0fef928c08e5d4d632e.camel@intel.com>
	 <45eb11ba-8868-4a92-9d02-a33f4279d705@intel.com>
	 <16a8d8dc15b9afd6948a4f3913be568caeff074b.camel@intel.com>
	 <fb829c94a45f246eac0dd869478e0dcfc965232b.camel@intel.com>
In-Reply-To: <fb829c94a45f246eac0dd869478e0dcfc965232b.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB7657:EE_
x-ms-office365-filtering-correlation-id: 269ead07-f8e8-4951-2c63-08dc6b9f6e1f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?bGN5MkYxMkozTDZJQ3FXbXhRUzJ5cVBzUWtOSUMzM2pUaGQramQzTnR2bGRW?=
 =?utf-8?B?eHVwQmZidlh0Z3BnN1J2R3pBS2F2ZFJuTE0ySWZmN2l2VWswMnJpRWNiZXdB?=
 =?utf-8?B?ZjVCMjErdkExZlF1UndmZzl0MTkvclZQRElOcXp4MUc5WUp6L0g0OEMxWEZZ?=
 =?utf-8?B?MUxFZjIxMlNKa2RVL1p6UkYzbUdUTDZSa2ZDM1BISUxIQy9YYis1cjNabCtI?=
 =?utf-8?B?cS9uQ1JNbnBYNVFBdkJ6LzYwUWFTeC84cUtDVFZiYi9qSktnbmlSbG5BY256?=
 =?utf-8?B?VkFINGhVNWk0RUgrQ1l1RVUwQ3F3M01tQ2MwZThSN1Z1alpBNk1lMDR1TjV1?=
 =?utf-8?B?bi9JYlBhbno2QWtWTDJGYlhINGxMUnNYN2xvUlVMTHpZWjJwUS9JNDY2citO?=
 =?utf-8?B?NmphNm5jRlA5QkQ1YTlRekpEdTZtUk5DRUFjUXgzMkJxUXFUa1kxd3FiM0hQ?=
 =?utf-8?B?eUFHVUszYkhxSVBKcU1ZVUE5Ym9GRGdTejdhdklmdTBDQ25VRTZNZ0Z4SmZV?=
 =?utf-8?B?eUZhOUtheVBaVlQrTjYrdTlYdWordmxtM3RPbEYzZ085OEhmc1Vmenk4NDN0?=
 =?utf-8?B?MitxaVJrVWRUU01vdmRablZPdjZnMkpuQUlXakRPc3lEYzVad2h5NVdrR3c4?=
 =?utf-8?B?clJGR1lPdU9oVExGLzRmenFUSHJmQUZuUjBLRGkrblF0aDVVTERrSGNIa2dz?=
 =?utf-8?B?TFFzZDZmSzNVanpsRTFmMUlGWXpTUFRoK2V4MC9WMytRRnBNUnJjN0x5VFZX?=
 =?utf-8?B?bWJMTFFBTXRlM1FScDVPanFQZEJvZ3haODBGOXRNNzNPSnlZOFg0Ym04Zmpt?=
 =?utf-8?B?ckVGVWh5a3RsNW9YenJpd29XQU5keVg3d2sxcS9TTUpyNjlEa0YrVmg3QzNV?=
 =?utf-8?B?STh1azlmQzh3TkZQTmpTYzRKVDdvSzNiclJwM3MvbXlLU1ppNVVTU3BqbmZS?=
 =?utf-8?B?MjMzRXZ4c0FuYXdqclhWZ1kzbzFhbDhyU2E1aWJzMW92ZXQwT0hCcDVZb25D?=
 =?utf-8?B?LzRXWHJJTXB0eVI3b0dCc1JYdVJ3MmdJTlVrRkYxbzlnZHNRVHdZWGcvMXRH?=
 =?utf-8?B?blFhSGQveUxNbzhQU2lzcTY4dG5Kb3d4SlVzQ05PR3JTWG9aOGk4WmRYaVBN?=
 =?utf-8?B?MnR2NFBlbHJSYmgwMWVYTEFCNWhkNnpXSnN4aU5VU0M5OUh0QWltVmI3cUkv?=
 =?utf-8?B?T1lIUVByYXEyTm5hb1l3eTBjTnQ0MEo0UzgweWRLQ2llVHZWWlNRRGV5UEQ0?=
 =?utf-8?B?OHdDQnd4dHFsbGJ6cVlzbmdETkV5Zm1qUHUwQ2kySndEVDU2OFB3TGVTdVd0?=
 =?utf-8?B?ZjZNVHNPa2JkQlV4VlRLY2IrUCtCdFVqYWk1bjB6cW44UFhLRmxTcmFoaTBr?=
 =?utf-8?B?eVdiOElDTExBbEVaSDBIL0p4OUJ5a0lpMHhkaEpqdzVGR2JwRk9qZDd2VUFE?=
 =?utf-8?B?blg5OHYyZGFta0cvb2xGWTRBZFpRK3pYQnc4ZkdBbVIvVEx4anlWb2g5eVVV?=
 =?utf-8?B?Uml5TnJKTFBIYlJaMUxFZ2kvTkVmSWxKMnJQMHRUMm95MGYyeDhWREpTUjJZ?=
 =?utf-8?B?TmVsNG1UL3JLclprcUYza3cwY2s5eS9VTnZoM3hkSGV4SDI1cnZ5YVFHTUFU?=
 =?utf-8?B?OGlOTVlyb0tRaUVVdmZKU3dja2thd0pzM1g4S2xRRUlCVy9oT3ZLRWp5dmNS?=
 =?utf-8?B?eXBRa2NmaEdDQzhHR1h4RnZ6MGkxSUYxdmhnOFhxK0pKVmxEdjlFTmVJNnJ3?=
 =?utf-8?B?d3hyWjRaQ0NsM2F2aGFqTk56S0IvRHdPWGs3R1pwWnZOeUZVaDlRTXdyTnhq?=
 =?utf-8?B?Q3JUK2pEWWZIV2ZDSVZuUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDhDeEFZc1VYRGpNbzFJam1Cc2thY2Y4WEJzWWtCTTlIdVk2OGswQ0VHcWll?=
 =?utf-8?B?K2E5ZWVwZjNwYWxobGRlOG40UC8vSWNHdE96NXFKd2pEZytiK0M2ak5JZlBP?=
 =?utf-8?B?dGovUnJQVDc5WDRienhSbTFaSC9HVG95aHN6bzRsOEtaTUlvcVB5MXYyZzFO?=
 =?utf-8?B?Zlp1WkpZSTBSeVRjS1E0TlA0QThncE1xQTFiZ3MxSWFYOHZlYXhPUVNucTY4?=
 =?utf-8?B?QTlONTl4NDQ4dC8ya2VpSU5rYmdySUI1UUtWMWxMV2x4VDh6VWJncDY5V2k3?=
 =?utf-8?B?ZnhpNSttNE1Sajh5cFVLM01mc1pZRnVRbWNYNVJ4QjJsN1RHMUxZLzZ2MkVW?=
 =?utf-8?B?d3JPNkRwYnJPNG9lT25KUklGUjJrTlgyVnRtSWRSeGIvaTFkaThMN2NsL1Ji?=
 =?utf-8?B?UHBPVzYyc05XMU45RDNVZmI4Yk1ON1dqNDZrcldhSjVremhHcjhiUCs5anI1?=
 =?utf-8?B?d08rdi9wNzBZL1JvNVNLU1ZOeVB5R21TbGFKd04xbEJjWlRBWEdnUng2Y3l3?=
 =?utf-8?B?OUI0UkhvSndnYTlhZ1NDWUtRQ3Fwc0VyWTRPdURPR3dIMDNMN3JINWRGaWRI?=
 =?utf-8?B?a3dXUm5JUTRTWStiYjlsSlpKbndRT2tQRk5GN0hkSDdUcWp0UkZmQmhUSjB3?=
 =?utf-8?B?emlsMUt1R1JFNFRsekhENVMwd0hUaXRmbG8zaG1ubU9kUS9OWE96N0VnVGJz?=
 =?utf-8?B?YkI3d3c5S0hhQ1ZxdG4wVHZhdXNWd05mT09sazIwbGpneWR6K3NGRFE4K1c4?=
 =?utf-8?B?WUVEajMyZGZObzh6dVhRWFlvSmlKTXZwVFRBbzJyUXk0dzlTM1BpWm1RYTlI?=
 =?utf-8?B?LzJwbHQ2N3RCNU4xenM3cHE0Wkdubkw1dTJHUG55NnlxU2dtNVhVZThuTFpw?=
 =?utf-8?B?T2VUb0hrVTNNOTZhU0N0TW4xVXFQOWN2TDhLTFpNTFYySGVEY1cvcG5CSVhN?=
 =?utf-8?B?UTFPT1BBNGRLaHNmT3I4VDlqWWJ2aktETXo5b3VsRGJVWTl3UjhpeFJyTDJH?=
 =?utf-8?B?MkthWWJ5bzFXNUdvY1Y3OUxCM09MbVZRWkNIZXhLcGdBQXBVcDRVYkpmTGlO?=
 =?utf-8?B?V2hMVURWc0xaeGpXNGgzS1YrZCtwVmRDWUx3VUZRTHFCTDIvU0dOcTdIV2tt?=
 =?utf-8?B?d0tUdGozVEFFbUxhUlh3TjhrNDBkcjdQYjhqQm1WMGRpSFFGbGhVUUVraG5P?=
 =?utf-8?B?eWxjU1lhMUQva1FTMWZiR3pPUjh3Q3Awc1g4NWQ2dTdleVBKeUdDZ1hBZWtD?=
 =?utf-8?B?WDdYMitTbEdqRWtrcjJLSGZkNUxuRUhITC8rQVpoVU1XSmpsMnJKTm5WK3Rz?=
 =?utf-8?B?OGhpT1hhcmhFQWFVQytRWlNaRTVvZ1kxL0wwVXFLT0VGbC9vK1pDdlFIcEFp?=
 =?utf-8?B?ckN1NEU3bnZDdk9DQXQxVEpYcXJXLzYvaUxJeGVWTGhQcmYxaUtIRXNobU1X?=
 =?utf-8?B?YjVjcktaVFlHaWxicDhmYjRQU3k2Q2hWMkM3Ui9KUjdzaDN3UmtGK3hkUVZT?=
 =?utf-8?B?Z25Pb2VMTTZHNjRuVURxMGJQVTlZeUR5SmhyV21DeW5SVWxsNmdyVTBNUTE3?=
 =?utf-8?B?QTl4ZjJ2cjY3Y3lMNnI5Szg4a0ZyVXBQaVVDSUZ1eld1VnlFQlFBZXcvZ0VU?=
 =?utf-8?B?ZGpiZ21jN3JkbGhzSmlmTVlKNThOR2gvdlM4QXlrNG5HbkpXd1FhcjAvMWhu?=
 =?utf-8?B?TFFvWGlGNmxNQ2s5TnJOWjB4M3JHMWpDaVZLL3FVNGhoN0tza0ZraC9KNGgz?=
 =?utf-8?B?dXRrN2JMaS9BVmMyRXlDVFJuTWZMZk16WUZadmowVTdhU3ZTektCM3pURERj?=
 =?utf-8?B?N2VmU0J2QlJhTGJJZ0ozMTRXZGtQQ2JreHk4ZHNuS1VHdnhlT1R1dS8yR0pU?=
 =?utf-8?B?MWZGNkhUZkczQXB1azJxanp4ZnF0UittaDVxSEtiOW5ndlBORTVtdnVYbjdC?=
 =?utf-8?B?RjQrM0pPWWN4NHhxeFVXSEo0UG1vbEYySUtudDAvbE1oV3hNQ0gvQWppeXRt?=
 =?utf-8?B?UUpIM2xud1I2M1l6RmxTc2dQcXRmUlhPekpuTlpQNzEyNHZyb3ZuQXpoMlNX?=
 =?utf-8?B?VUNaUmc2dmR6QWI2Ty9zOEpKRy83MmtnNlRQdGsrYXVTZVNUTW53aklvbEti?=
 =?utf-8?B?Nlh3bmMyNmtQcHdxbEJCMEhuTUVFanlueHJ1WVYwSU40MGcvQ2FKZ1l3cStt?=
 =?utf-8?Q?rRD5NpBHNzp3E0yDsSuaJXk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <881B833AAE3221448CFDF67A094B7A3A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 269ead07-f8e8-4951-2c63-08dc6b9f6e1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 18:32:47.0927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 42rO185gdgOzZdnSYLhB/tG76vOj35KeMZXAO/0QdsVoMEFffCTg35yMHffpohRkbZGQK8Vzt6NJIHBBZHpiJZ58Zb3pttHJJt7YZJw3b6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7657
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDEyOjI2ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gVG8gcmVzb2x2ZSB0aGlzIG9uY2UgZm9yIGFsbCwgZXh0ZW5kIHRoZSBleGlzdGluZyBtZXRh
ZGF0YSByZWFkaW5nIGNvZGUNCj4gdG8gcHJvdmlkZSBhIGdlbmVyaWMgbWV0YWRhdGEgcmVhZCBp
bmZyYXN0cnVjdHVyZSB3aGljaCBzdXBwb3J0cyByZWFkaW5nDQo+IGFsbCA4LzE2LzMyLzY0IGJp
dHMgZWxlbWVudCBzaXplcy4NCg0KSSB0aGluayB0aGUga2V5IHBvaW50IGlzIHRoYXQgaXQgaXMg
YWN0dWFsbHkgc2ltcGxlciB0byBzdXBwb3J0IGFsbCBmaWVsZCB0eXBlcw0KdGhlbiBvbmx5IDE2
IGFuZCA2NC4NCg==

