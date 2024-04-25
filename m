Return-Path: <kvm+bounces-15991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C24428B2D32
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C4CFAB2122E
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF5B914D707;
	Thu, 25 Apr 2024 22:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmyR/VzU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95476CDC1
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 22:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714084881; cv=fail; b=giM5ift3cQoEhOnJopzegGav0+0EJoz6tlMvHgvvaPYbMWzzhVBuWW3mVPK/4SO7ZDm3O56C+z9tvNFO5abRYnrBKNuRfgwLISJJZWkGnaIgO8wQqAPYYb/HKWjNneWHCesCXk6isuqF962+rsWhY9JPYQawpL85nOvo8K+A/jY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714084881; c=relaxed/simple;
	bh=CiMmK3LwiBy2zWFXM7AoxKOv7x3+GGQdHsoK8G4iDRo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DPxB+xCsKXSNxK5tjuY9xOtOyj2+1LDucVBJrLEJZzT10H0VG5Wxak2Ys6kQotfkkwXJ+/qvOqmjj/yKyVxojKl9oWWsAQ5m0ydBK+l4fB0sYa3fAc9VmMG+6P7IjmtotcklDOYoJn3Kn4FIiSScNd9Y4JvGnQ1n+jrl/tVpcz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WmyR/VzU; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714084879; x=1745620879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CiMmK3LwiBy2zWFXM7AoxKOv7x3+GGQdHsoK8G4iDRo=;
  b=WmyR/VzUtglpz7ZfE2B7F38VjXjR/dhQYtBiU8C71zEArQtDNSw1X8i3
   g+kYEHaKP+KOOqgSEiASBrDsJJaLFWv4OdIa99giUNCPy1fJTsZ2HigQu
   iqsKo8cJNjU2mr1e7V1Dxh4yYyFxtyGSl52TWRfECzcFZQgPi0NrtwX62
   Lq+jlfOmpM6pYiMfjVRn9B7OBE4CsO/XtyZA9mc1TYq5hBAQRiSMa5HtP
   Tr4Oj0g/fMcHhqGQLJTgKHVLEZZc0vZhtk5/egt44NwF1wJe4umz1pHPL
   NAlhEdGlYpNpN5+RUPieH0KXjLmrs0gNaj72ubA0jy0kOQSjNHoJBsoZn
   Q==;
X-CSE-ConnectionGUID: sWza0HeJTJSv0u9SVBJbeQ==
X-CSE-MsgGUID: HVrx9OEETZWoAtv64a/Cmw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="20958422"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="20958422"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 15:41:19 -0700
X-CSE-ConnectionGUID: v2pw30v0SS+NvVzplz17FQ==
X-CSE-MsgGUID: qgc2gDdSRiiEMHWIh6V3kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25728574"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 15:41:18 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 15:41:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 15:41:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 15:41:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5skadQtChI/EU6oqQfKYUPDm+Cmrj+EtAnO7875txgA8Pzv2Hi3ghPh/q6T5OHVoUf3BgW6umxXNn4SboHywXswLfHh4FNPwnqDgExsb14z+8jn3mzbW6hz6Jc14wtbIGF8BkkQIa3w97ELHCyBet3KGEOq7jovjC/AEX9X4GvqidQtSMh2qoMTTc1XYLlvKi9wec61l19alxuDwGBFmlXV5lITX5NCGkyzuUxyrl/nWPZBovh3fUoB2jxiKXqh5WHvsXayI3JwCCzNJAFcA5pJtMt5BuB0l3VM2Hds2LJRHEWEWG101ucUx5cPhWUwIs3gR6mrn+VWbrL5z7e8FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CiMmK3LwiBy2zWFXM7AoxKOv7x3+GGQdHsoK8G4iDRo=;
 b=TWT2VDHRHX6xJ2u9I1Wh8uktDid8e6OeUipZ/kK3C+MWYBHpeAoikCbRniq4LKCT3OXOxSK1CIzBw2eRA2s9jZ1/c59lSqW+dYZqjKwkCS68ZhSQYnb2gv4o89MF13PF9G/LCXvIrc9FdTiJqO7BF5syvdnuRzziPTDpjHNgWObFY7fgV6S0J9KV4fMUlspmgs3oXfX8FXBB5pgU92xmTbNqnPXCamR8DWWXmTtA2AxOEPYwjgU8ptODuGYNvP1/beAXopUnp2Fj1lPLNSR1F8pBvQ34wQKG8/2CTAG1um1S08bOyQkWEjiFMFkepJn5KwRpFRdv7simhXv58qh53Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB5942.namprd11.prod.outlook.com (2603:10b6:510:13e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.24; Thu, 25 Apr
 2024 22:41:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Thu, 25 Apr 2024
 22:41:09 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
Thread-Topic: [RFC] TDX module configurability of 0x80000008
Thread-Index: AQHalmgoAfxgxP49QEefWZUch1OWdLF5GFQAgAAXAoCAAAekAIAAFtYAgAA3YoCAABFSgA==
Date: Thu, 25 Apr 2024 22:41:09 +0000
Message-ID: <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
	 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com>
	 <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
	 <ZiqL4G-d8fk0Rb-c@google.com>
	 <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
	 <ZirNfel6-9RcusQC@google.com>
In-Reply-To: <ZirNfel6-9RcusQC@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB5942:EE_
x-ms-office365-filtering-correlation-id: 85e9675a-8b68-4745-08f3-08dc6578cd96
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VmRvdXV2WWNibUhEU3FvUmRrNXlGVUVpa0lHWWx6bFUrQTh4WVoxMGtyOUFv?=
 =?utf-8?B?cXFEZ3ptbWcyaVZCYlR5MUhCUG9EVEVJNFlBRGUrZTJDM3dHcGhyRVNhMmF0?=
 =?utf-8?B?cnBVTmFla0cyeGNvU2FDNk1RWmpMRnNoMVh5bzZLb3pSenBaakloK3lhNk5l?=
 =?utf-8?B?emgzMVBvdzFkNTlUc1N1Rnc0TmdsY2x1N2libW5lUGppaSt6eVNFaGY3blZL?=
 =?utf-8?B?MXJPeUpsL3Bpd1BSMFZZczRrMDdLVnIzTHVRWUpJQ3V6L1pPYzJDVWhVQTdE?=
 =?utf-8?B?QmxhK3RQRjh5T0l0SmdRM2RQa25QbTFycXFpUVpISUNId1BOVzB1RlNteHk0?=
 =?utf-8?B?NytWTGo0SzJobDJUNTRGblhwVUtxeU1TalhDYlVLTVdoa3B1Z2xZVVUraFRG?=
 =?utf-8?B?YTN4RFlxa3BTVFZMRkFVZlB5RzRWek8rT3FaR0FhNnNpSmZuaE0zZS9ZeVNE?=
 =?utf-8?B?b1ltS3pJQmJuVHVWRFNkejMvU2JuNmwyVjdYbXV3eUtmeEtlRlFSSUZCd0RG?=
 =?utf-8?B?NGs3U2RuWVA1WG5KMUE5am5ObU52VnU0NWE0UmRIcHFoRFZ3V3VKZnBPY3Zw?=
 =?utf-8?B?eHFCOUZNUGVFakI0aVorQ3BWOTRmNk85SVFXeDhpUXBUOG9CNnRHcHZmUURD?=
 =?utf-8?B?WlBCbHZhNFBub28wR1FHUXZRQkNHczJLd0dMbklzMml0L3hLTEtjbThVMUxx?=
 =?utf-8?B?WGZLRDVrdHRmbFVRV2Y2WFBtWGh0MHhWUk5sZjdsSS92TEkzMXBuRU90bTM0?=
 =?utf-8?B?QUFsTHFHN0lCWms2M1h2TlEzMzBiUUttMHRCZlUxaFJWb05wYm5lVWsrSW4v?=
 =?utf-8?B?Zm10RFl6NWI5WmN5M2NXY0JBQVdtdUlyN2d3MHVBQjA5am0vZDdmUnppaHBZ?=
 =?utf-8?B?UUt2RVgwQU44UTE3R1l2dUxYcjh4MzIrc2RRdDMwNnRJUERlczBKWDlxUUE1?=
 =?utf-8?B?M2FnbklHOCtuaysveittK3poTVlDcTVTSTFFZGx5R2hUZkl4SElLZVkxZWdi?=
 =?utf-8?B?NDNyNTMvS0U2NXNXL1F2UU9NekxKTm9KS1c5dmY3TEtTUXRkQ3VhQ0JCSlZB?=
 =?utf-8?B?ZCs0bUY4UDJncVJaT0NKdlA0cU5ZNFIxSHVIbVpRV0NReGdtU2xIQWRIVm5v?=
 =?utf-8?B?WW9SZjloY2NvakpFTjUzTWJTYnpKUFB2OW1QaGFSanlWbU1PZHhZZFZoajBl?=
 =?utf-8?B?UlNvZWFGdS8wVXM3czBOWXhDZnZVSkxjRVNlMlFzWjcrNnJscW5kTmptMnNL?=
 =?utf-8?B?aklJdCtpT0h0ei9CQXMrN3h4Mko3ZmlUQXllcGpHNTJlRnVTdEtlSTBqeHlJ?=
 =?utf-8?B?NDhudWJGanhUV2hyZUNqM2pGT1R3ZW9zUlhwcDg3MGJpTmNRUnlwWHlnOE9p?=
 =?utf-8?B?ZFlGNXA1Szk5czM4L1lqbzlaL2Z3SHFNclAvK3BUTCtwamxBOFZyUFRHdFZS?=
 =?utf-8?B?RTFoaXJpQnlNMEE5SGgwd2lIYWhIaU9ac0I1R1J5ajVrdlFUOVdHakludUVV?=
 =?utf-8?B?UmxWTGhtWjA4enY0Tkt5VkNTUlk4UjRmeXVvc2pvWGo0OXo5Vjg4V1g0L3lz?=
 =?utf-8?B?Ni9LUmVMNmRxVTZxc2kyT1lwRUdLTU9sb1A1VHUwU0xIakIrV0xjZk8wektC?=
 =?utf-8?B?eG53NG1tZmhVUXBqUHpnejEzZVF3bFdkSWhlaWhGcUZ1NmlWaldQM2djT3Fz?=
 =?utf-8?B?c21EOTR3VzJyOGRERGJMT0k5ellkV0VUYngvMS9kYllIbHluQTRFU3B0S2pU?=
 =?utf-8?B?TS9iY1E3YUhKUTJhT2YzcGJHMVFldzAvYzhqTnpQMUJ4T0I1K0xHMFNvL3k5?=
 =?utf-8?B?b0FJVHB1bldMR2drVnZ5UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHVneFYyU0Vpd1RTaXFmOXpobUpZeGJ0RER0VVFIaGVCWnkvZ2dFWEhRdEx5?=
 =?utf-8?B?SE1qSFVUUnp6NVJNSEVGeVNnU1V0dlNUKzJISDRTWHp0c1BRTnIyQ3d6bWRW?=
 =?utf-8?B?ZDdUSldaS2lOUENKSkwxZ3pWZDhVMDZCVGpWdThycmNyNjAyZEZqZDIwSWxE?=
 =?utf-8?B?ZkF0U3pGdmUzaklrSjNZTWNXZEExclZJRlhibGhTQVk0aW81dUNkYUVyeXhp?=
 =?utf-8?B?VmdrVjVUR1hxZHhOK3lpRERYYnBRTVVFbEIrVTJsK3VCc3FTY0d3WnkvRTlH?=
 =?utf-8?B?cE0vMGNqcTd4clNjc1ByQzNLWjU5SW1GeXlmek50KzF5S3pZM2YwNGRvMmd0?=
 =?utf-8?B?N2xGUTdwMXY3MVVHN1N3TG80V1AvZVc5YmQyc0d3dFMxcTNybUtTY1lZYTdw?=
 =?utf-8?B?dzcxOXlkK0hJdEJXUktlakdHNHdtenNLUm1BSDFyZjBwS0FYekU1UGZFNGor?=
 =?utf-8?B?aXprNEhpbG9wVnFpSTBWUGRGQlpyeVFPclRkc3NXelZ0akJMV1F5bVBUZW9j?=
 =?utf-8?B?SktmRTN5VlhxQ01MYmVENEdJTFBUTmoyU0NNQWt4THhPUkNxdGxhM1hnNjJh?=
 =?utf-8?B?TzBpLytZdXEzdks4TUt6L3A2Zy9keDU1Y0l6MWtJSFBYb2xyQVFFWEJ2em5U?=
 =?utf-8?B?VTdyRExkcTJRcHhYamplSGZ1eEY2WCtNMlBqekcvNlMrUWVHQmxhUE1yZVY4?=
 =?utf-8?B?T2p1ZVduYm1pWWlOWktSQ0orTWg4ZU84bnlnaVJZbno0R2JpOTV3eDdpNGFM?=
 =?utf-8?B?Z2RtQWg3NGRWaUJVQ3ZkNzhsNWJGNXV3NGlrd3czOTdoU1U2V2lsRzBoUFRt?=
 =?utf-8?B?OGhXOGlsYmFvVDRWaWdIa3lGMm1NRXZTSmZZUElKQ0RoZ1FrVjBuTnFoaWJS?=
 =?utf-8?B?SDFUZHlJQ3l2OEtUNzZUVUhualBoQU5YelBWZjZvajAydkdFdUNBVnBicmhl?=
 =?utf-8?B?MDZVMldtcTM5RWgxc3NvejBpektSZGFFa05xL1ZKTVB1bURvZlZ0YkszaDZL?=
 =?utf-8?B?VmFzNmpudVkvdENXS04yci9ad25rY045L1QvWVdWNkE3WnBhWnRRa3gvbTBN?=
 =?utf-8?B?ajVOK204bmlOT1RRT3ZyUDFBRmhOenlIK3dqYXR3Wms1cmNOSjhZN3BZOTJU?=
 =?utf-8?B?Qk02bWtRN3BZblFuS2l5ajN4eStuWlE5TjluSE9uN0plMHVMbFNzL3EyNWlD?=
 =?utf-8?B?d1IxS0V5N3c3cU02a2duLzNja1I0OCt1TjJpMFVtcjdHbEhlKzZ6djUzY0l2?=
 =?utf-8?B?L3ZReXdJSnV4OXpxMVhTdlRlNzRDWCsyRisyK2lmejJhd29jbVZhTWYzN2My?=
 =?utf-8?B?YTRHU0k1cTlielhzUENnSktQeFRUSk91dUI1bkJ0aEFYTW5NMnBOVDFSTlI1?=
 =?utf-8?B?K3ZiVUx5cG42UnlBV2lUbTcvNnN0RzZtZWlYdmpUVVo2R3NWKytqdUVqUEhs?=
 =?utf-8?B?bk05bU5zZ1dmYU5xQ01EUDVDQitVVWpZWmpnV0dCUUxUOW5XdWQ2VG9lT2Rx?=
 =?utf-8?B?MStnSEM3UytwMnVXUDF0cUJnYTdCTE1SK25xa2FyMmx5Wk1sNzd5ZERuOEZO?=
 =?utf-8?B?TDlxRHRCSFRScnNlblZCRit0aXVzSWxBU1hFRFNnY3lYemZYek5PR2FZUHNo?=
 =?utf-8?B?R2I5SWpPY3lhQVlWcG5WMmpzYk5kOHZ0ZVdyVURZSWRYV1NLTlUzNkF3dE5m?=
 =?utf-8?B?MFovTGE5ZENzdCtmcjgxMmNibS85OFlpbGNEbUtPdHFUVHUxZEpBdlozQVk4?=
 =?utf-8?B?SVRYb2FPWnBLWllTdUM2cTB1Ujk0MlZWaHJFS1p5TkdvZVRDMlFRaUJrU0tp?=
 =?utf-8?B?R2ZuUjgxV2lGRzczWElvSVBlbnNaZzMvRSsvQkFiajNla3NjNytWSWhLZjdR?=
 =?utf-8?B?NHdHM2I1di9HZGpwcU9nUHBBd2VzQy9rRUlaZzRsVHg2akRhKy9WeVBwcjlm?=
 =?utf-8?B?MWpQcXVvZ0tlU0xsQlJmWDdvVTd4SnFrQnB3Z2JiblU1NC92ME9LUGg0TWtv?=
 =?utf-8?B?ZnBsWTgwUm90NDRjWFNqNGVLL3FScUdKTFVYT3VpZTVnSWFqOTVrWTJwR0Yy?=
 =?utf-8?B?TEExR2QwTXVkbnFaTEdscnhkc2YvV3c2QWNQYitlL1dxOGV1V2RWSFBDQitM?=
 =?utf-8?B?Zkk5cUNPdEw2S1hVeXloNmRkcUNhaU5XU2FGUnNzZjNUZzErSjZwU2kxUDND?=
 =?utf-8?Q?o5hv325FL4YCScRF0NaVXCw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DCC873557EB18498695F9CED741A607@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85e9675a-8b68-4745-08f3-08dc6578cd96
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 22:41:09.9331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EtpNxducHjk1n7Sl0ozu+SI+qG/L7vYsGAkXFgu2CAspyTdUn+o23jK1Acoj9nMlyk9kHein6SaMcbB6D0v6f2Zhf9Ggpxu9E8B66KFFIj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5942
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDE0OjM5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEFwciAyNSwgMjAyNCwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBUaHUsIDIwMjQtMDQtMjUgYXQgMDk6NTkgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiA+IGFjY2Vzc2luZyBhIEdQQSBiZXlvbmQgWzIzOjE2XSBpcyBzaW1pbGFy
IHRvIGFjY2Vzc2luZyBhIEdQQSB3aXRoIG5vDQo+ID4gPiA+IG1lbXNsb3QuDQo+ID4gPiANCj4g
PiA+IE5vLCBpdCdzIG5vdC7CoCBBIEdQQSB3aXRob3V0IGEgbWVtc2xvdCBoYXMgKnZlcnkqIHdl
bGwtZGVmaW5lZCBzZW1hbnRpY3MNCj4gPiA+IGluDQo+ID4gPiBLVk0sIGFuZCBLVk0gY2FuIHBy
b3ZpZGUgdGhvc2Ugc2VtYW50aWNzIGZvciBhbGwgZ3Vlc3QtbGVnYWwgR1BBcw0KPiA+ID4gcmVn
YXJkbGVzcyBvZiBoYXJkd2FyZSBFUFQvTlBUIHN1cHBvcnQuDQo+ID4gDQo+ID4gU29ycnksIG5v
dCBmb2xsb3dpbmcuIEFyZSB3ZSBleHBlY3RpbmcgdGhlcmUgdG8gYmUgbWVtc2xvdHMgYWJvdmUg
dGhlIGd1ZXN0DQo+ID4gbWF4cGEgMjM6MTY/IElmIHRoZXJlIGFyZSBubyBtZW1zbG90cyBpbiB0
aGF0IHJlZ2lvbiwgaXQgc2VlbXMgZXhhY3RseSBsaWtlDQo+ID4gYWNjZXNzaW5nIGEgR1BBIHdp
dGggbm8gbWVtc2xvdHMuIFdoYXQgaXMgdGhlIGRpZmZlcmVuY2UgYmV0d2VlbiBiZWZvcmUgYW5k
DQo+ID4gYWZ0ZXIgdGhlIGludHJvZHVjdGlvbiBvZiBndWVzdCBNQVhQQT8gKHRoZXJlIHdpbGwg
YmUgbm9ybWFsIFZNcyBhbmQgVERYDQo+ID4gZGlmZmVyZW5jZXMgb2YgY291cnNlKS4NCj4gDQo+
IElmIHRoZXJlIGFyZSBubyBtZW1zbG90cywgbm90aGluZyBmcm9tIGEgZnVuY3Rpb25hbCBwZXJz
cGVjdGl2ZXMsIGp1c3QgYSB2ZXJ5DQo+IHNsaWdodCBpbmNyZWFzZSBpbiBsYXRlbmN5LsKgIFBy
ZS1URFgsIEtWTSBjYW4gYWx3YXlzIGVtdWxhdGUgaW4gcmVwb25zZSB0byBhbg0KPiBFUFQNCj4g
dmlvbGF0aW9uIG9uIGFuIHVubWFwcGFibGUgR1BBLsKgIEkuZS4gYXMgbG9uZyBhcyB0aGVyZSBp
cyBubyBtZW1zbG90LCBLVk0NCj4gZG9lc24ndA0KPiAqbmVlZCogdG8gY3JlYXRlIFNQVEVzLCBh
bmQgc28gd2hldGhlciBvciBub3QgYSBHUEEgaXMgbWFwcGFibGUgaXMgY29tcGxldGVseQ0KPiBp
cnJlbGV2YW50Lg0KDQpSaWdodCwgYWx0aG91Z2ggdGhlcmUgYXJlIGdhcHMgaW4gZW11bGF0aW9u
IHRoYXQgY291bGQgZmFpbC4gSWYgdGhlIGVtdWxhdGlvbg0Kc3VjY2VlZHMgYW5kIHRoZXJlIGlz
IGFuIE1NSU8gZXhpdCB0YXJnZXRpbmcgYSB0b3RhbGx5IHVua25vd24gR1BBLCB0aGVuIEkgZ3Vl
c3MNCml0J3MgdXAgdG8gdXNlcnNwYWNlIHRvIGRlY2lkZSB3aGF0IHRvIGRvLg0KDQpLVk0ncyBk
b25lIGl0cyBqb2IuIEJ1dCB1c2Vyc3BhY2Ugc3RpbGwgaGFzIHRvIGhhbmRsZSBpdC4gSXQgY2Fu
LCBidXQgSSB3YXMNCnVuZGVyIHRoZSBpbXByZXNzaW9uIGl0IGRpZG4ndCAobWF5YmUgYmFkIGFz
c3VtcHRpb24pLg0KDQo+IA0KPiBFbnRlciBURFgsIGFuZCBzdWRkZW5seSB0aGF0IGRvZXNuJ3Qg
d29yayBiZWNhdXNlIEtWTSBjYW4ndCBlbXVsYXRlIHdpdGhvdXQNCj4gZ3Vlc3QNCj4gY29vcGVy
YXRpb24uwqAgQW5kIHRvIGdldCBndWVzdCBjb29wZXJhdGlvbiwgX3NvbWV0aGluZ18gbmVlZHMg
dG8ga2ljayB0aGUNCj4gZ3Vlc3QNCj4gd2l0aCBhICNWRS4NCj4gDQo+ID4gPiA+IExpa2UgeW91
IHNheSwgWzIzOjE2XSBpcyBhIGhpbnQsIHNvIHRoZXJlIGlzIHJlYWxseSBubyBjaGFuZ2UgZnJv
bSBLVk0ncw0KPiA+ID4gPiBwZXJzcGVjdGl2ZS4gSXQgYmVoYXZlcyBsaWtlIG5vcm1hbCBiYXNl
ZCBvbiB0aGUgWzc6MF0gTUFYUEEuDQo+ID4gPiA+IA0KPiA+ID4gPiBXaGF0IGRvIHlvdSB0aGlu
ayBzaG91bGQgaGFwcGVuIGluIHRoZSBjYXNlIGEgVEQgYWNjZXNzZXMgYSBHUEEgd2l0aCBubw0K
PiA+ID4gPiBtZW1zbG90Pw0KPiA+ID4gwqANCj4gPiA+IFN5bnRoZXNpemUgYSAjVkUgaW50byB0
aGUgZ3Vlc3QuwqAgVGhlIEdQQSBpc24ndCBhIHZpb2xhdGlvbiBvZiB0aGUgInJlYWwiDQo+ID4g
PiBNQVhQSFlBRERSLCBzbyBraWxsaW5nIHRoZSBndWVzdCBpc24ndCB3YXJyYW50ZWQuwqAgQW5k
IHRoYXQgYWxzbyBtZWFucyB0aGUNCj4gPiA+IFZNTSBjb3VsZCBsZWdpdGltYXRlbHkgd2FudCB0
byBwdXQgZW11bGF0ZWQgTU1JTyBhYm92ZSB0aGUgbWF4IGFkZHJlc3NhYmxlDQo+ID4gPiBHUEEu
wqAgU3ludGhlc2l6aW5nIGEgI1ZFIGlzIGFsc28gYWxpZ25lZCB3aXRoIEtWTSdzIG5vbi1tZW1z
bG90IGJlaGF2aW9yDQo+ID4gPiBmb3IgVERYIChjb25maWd1cmVkIHRvIHRyaWdnZXIgI1ZFKS4N
Cj4gPiA+IA0KPiA+ID4gQW5kIG1vc3QgaW1wb3J0YW50bHksIGFzIHlvdSBub3RlIGFib3ZlLCB0
aGUgVk1NICpjYW4ndCogcmVzb2x2ZSB0aGUNCj4gPiA+IHByb2JsZW0uwqAgT24gdGhlIG90aGVy
IGhhbmQsIHRoZSBndWVzdCAqbWlnaHQqIGJlIGFibGUgdG8gcmVzb2x2ZSB0aGUNCj4gPiA+IGlz
c3VlLCBlLmcuIGl0IGNvdWxkIHJlcXVlc3QgTU1JTywgd2hpY2ggbWF5IG9yIG1heSBub3Qgc3Vj
Y2VlZC7CoCBFdmVuIGlmDQo+ID4gPiB0aGUgZ3Vlc3QgcGFuaWNzLCB0aGF0J3MgZmFyIGJldHRl
ciB0aGFuIGl0IGJlaW5nIHRlcm1pbmF0ZWQgYnkgdGhlIGhvc3QNCj4gPiA+IGFzDQo+ID4gPiBp
dCBnaXZlcyB0aGUgZ3Vlc3QgYSBjaGFuY2UgdG8gY2FwdHVyZSB3aGF0IGxlZCB0byB0aGUgcGFu
aWMvY3Jhc2guDQo+ID4gPiANCj4gPiA+IFRoZSBvbmx5IGRvd25zaWRlIGlzIHRoYXQgdGhlIFZN
TSBkb2Vzbid0IGhhdmUgYSBjaGFuY2UgdG8gImJsZXNzIiB0aGUNCj4gPiA+ICNWRSwNCj4gPiA+
IGJ1dCBzaW5jZSB0aGUgVk1NIGxpdGVyYWxseSBjYW5ub3QgaGFuZGxlIHRoZSAiYmFkIiBhY2Nl
c3MgaW4gYW55IG90aGVyDQo+ID4gPiB0aGFuIGtpbGxpbmcgdGhlIGd1ZXN0LCBJIGRvbid0IHNl
ZSB0aGF0IGFzIGEgbWFqb3IgcHJvYmxlbS4NCj4gPiANCj4gPiBPaywgc28gd2Ugd2FudCB0aGUg
VERYIG1vZHVsZSB0byBleHBlY3QgdGhlIFREIHRvIGNvbnRpbnVlIHRvIGxpdmUuIFRoZW4gd2UN
Cj4gPiBuZWVkDQo+ID4gdG8gaGFuZGxlIHR3byB0aGluZ3M6DQo+ID4gMS4gVHJpZ2dlciAjVkUg
Zm9yIGEgR1BBIHRoYXQgaXMgbWFwcGFibGUgYnkgdGhlIEVQVCBsZXZlbCAod2UgY2FuIGFscmVh
ZHkNCj4gPiBkbw0KPiA+IHRoaXMpDQo+ID4gMi4gVHJpZ2dlciAjVkUgZm9yIGEgR1BBIHRoYXQg
aXMgbm90IG1hcHBhYmxlIGJ5IHRoZSBFUFQgbGV2ZWwNCj4gPiANCj4gPiBXZSBjb3VsZCBhc2sg
dGhlIFREWCBtb2R1bGUgdG8ganVzdCBoYW5kbGUgYm90aCBvZiB0aGVzZSBjYXNlcy4gQnV0IHRo
aXMNCj4gPiBtZWFucw0KPiA+IEtWTSBsb3NlcyBhIGJpdCBvZiBjb250cm9sIGFuZCBkZWJ1Zy1h
YmlsaXR5IGZyb20gdGhlIGhvc3Qgc2lkZS4NCj4gDQo+IFdoeSB3b3VsZCB0aGUgVERYIG1vZHVs
ZSB0b3VjaCAjMT/CoCBKdXN0IGxlYXZlIGl0IGFzIGlzLg0KDQpJIHRoaW5rIGl0IHdvbid0IGV2
ZW4gY29tZSB1cCBpZiBHUEFXIGlzIGxvY2tlZCB0byAyMzoxNiBsaWtlIGRpc2N1c3NlZCBiZWxv
dy4NCihhbmQgdGhlIGN1cnJlbnQgcGxhbiBmb3IgcGlja2luZyBFUFQgbGV2ZWwpLg0KDQo+IA0K
PiA+IEFsc28sIGl0IGFkZHMgY29tcGxleGl0eSBmb3IgY2FzZXMgd2hlcmUgS1ZNIG1hcHMgR1BB
cyBhYm92ZSBndWVzdCBtYXhwYQ0KPiA+IGFueXdheS4NCj4gDQo+IFRoYXQgc2hvdWxkIGJlIGRp
c2FsbG93ZWQuwqAgSWYgS1ZNIHRyaWVzIHRvIG1hcCBhbiBhZGRyZXNzIHRoYXQgaXQgdG9sZCB0
aGUNCj4gZ3Vlc3QNCj4gd2FzIGltcG9zc2libGUgdG8gbWFwLCB0aGVuIHRoZSBURFggbW9kdWxl
IHNob3VsZCB0aHJvdyBhbiBlcnJvci4NCg0KSG1tLiBJJ2xsIG1lbnRpb24gdGhpcywgYnV0IEkg
ZG9uJ3Qgc2VlIHdoeSBLVk0gbmVlZHMgdGhlIFREWCBtb2R1bGUgdG8gZmlsdGVyDQppdC4gSXQg
c2VlbXMgaW4gdGhlIHJhbmdlIG9mIHVzZXJzcGFjZSBiZWluZyBhbGxvd2VkIHRvIGNyZWF0ZSBu
b25zZW5zZQ0KY29uZmlndXJhdGlvbnMgdGhhdCBvbmx5IGh1cnQgaXRzIG93biBndWVzdC4NCg0K
SWYgd2UgdGhpbmsgdGhlIFREWCBtb2R1bGUgc2hvdWxkIGRvIGl0LCB0aGVuIG1heWJlIHdlIHNo
b3VsZCBoYXZlIEtWTSBzYW5pdHkNCmZpbHRlciB0aGVzZSBvdXQgdG9kYXkgaW4gcHJlcGFyYXRp
b24uDQoNCj4gDQo+ID4gU28gbWF5YmUgd2Ugd2FudCBpdCB0byBqdXN0IGhhbmRsZSAyPyBJdCBt
aWdodCBoYXZlIHNvbWUgbnVhbmNlcyBzdGlsbC4NCj4gDQo+IEknbSBzdXJlIHRoZXJlIGFyZSBu
dWFuY2VzLCBidXQgSSBkb24ndCBrbm93IHRoYXQgd2UgY2FyZS7CoCBJIHNlZSB0aHJlZQ0KPiBv
cHRpb25zOg0KPiANCj4gwqAxLiBSZXN1bWUgdGhlIGd1ZXN0IHdpdGhvdXQgZG9pbmcgYW55dGhp
bmcgYW5kIGhhbmcgdGhlIGd1ZXN0Lg0KPiANCj4gwqAyLiBQdW50IHRoZSBpc3N1ZSB0byB0aGUg
Vk1NIGFuZCBraWxsIHRoZSBndWVzdC4NCj4gDQo+IMKgMy4gSW5qZWN0ICNWRSBpbnRvIHRoZSBn
dWVzdCBhbmQgbWF5YmUgdGhlIGd1ZXN0IGxpdmVzLg0KPiANCj4gIzEgaXMgdGVycmlibGUgZm9y
IG9idmlvdXMgcmVhc29ucywgc28gZ2l2ZW4gdGhlIGNob2ljZSBiZXR3ZWVuIGd1YXJhbnRlZWQN
Cj4gZGVhdGgNCj4gYW5kIGEgc2xpbSBjaGFuY2Ugb2Ygc3Vydml2YWwsIEknbGwgdGFrZSB0aGF0
IHNsaW0gY2hhbmNlIG9mIHN1cnZpdmFsIDotKSANCg0KWWVzLCBtYXliZSB0aGlzIHByb3Bvc2Fs
IHdhcyBiZWluZyBhIGJpdCBsYXp5Lg0KDQo+IA0KPiA+IEFub3RoZXIgcXVlc3Rpb24sIHNob3Vs
ZCB3ZSBqdXN0IHRpZSBndWVzdCBtYXhwYSB0byBHUEFXPw0KPiANCj4gWWVzDQo+IA0KPiA+IEVp
dGhlciBlbmZvcmNlIHRoZXkgYXJlIHRoZSBzYW1lLCBvciBleHBvc2UgMjM6MTYgYmFzZWQgb24g
R1BBVy4NCj4gDQo+IEkgY2FuJ3QgdGhpbmsgb2YgYW55IHJlYXNvbiBub3QgdG8gZGVyaXZlIDIz
OjE2IGZyb20gR1BBVywgdW5sZXNzIEknbSBtaXNzaW5nDQo+IHNvbWUgc3VidGxldHksIHRoZXkn
cmUgcXVpdGUgbGl0ZXJhbGx5IHRoZSBzYW1lIHRoaW5nLg0KDQpTbyB3ZSBoYXZlOg0KIC0gRXhw
b3NlIEdQQVcgaW4gMjM6MTYNCiAtIEluamVjdCAjVkUgaWYgZXB0IHZpb2xhdGlvbiBpcyBmb3Ig
Z3BhIHRoYXQgY2FuJ3QgYmUgbWFwcGVkIGJ5IEVQVCBsZXZlbA0KDQpTZWVtcyByZWxhdGl2ZWx5
IHNpbXBsZS4gSSdsbCB3YWl0IGEgYml0IGZvciBtb3JlIGNvbW1lbnRzLCBhbmQgY2lyY2xlIGJh
Y2sgd2l0aA0KVERYIG1vZHVsZSBmb2xrcy4NCg0K

