Return-Path: <kvm+bounces-17493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C99478C6F96
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:36:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DA29283BC7
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 00:36:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC70E3FEF;
	Thu, 16 May 2024 00:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KTZ4IyBW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B061854;
	Thu, 16 May 2024 00:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715819744; cv=fail; b=RSyj3naRZ+cFrzmc+PT6f6ku6+F7w6JY4oYrsGJIW3Jt61pvAlLiSWYQbtlUFPIium/Wd+JI0QQwVzM6SnzppkafRd0w4ZnS2Nr3ugVO/NU1nyTH7GCHpfZUrQh0C5MM7f1BKeGvxHtHgkCxbL2EuEYm4QRoTn9BBv4W7zlAWPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715819744; c=relaxed/simple;
	bh=vJOK0uF/Wvp7RURnh12z1zK36Vb817Oy1t45V/cfG68=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gvu/1TkQEqk3dJSsBTavdUV5Dmxjtu7qMXEVmceD2pVdPMYLwc2a/lUufDQGZcbbDcOJtehTmfvSQFCYcfBW0Jie8YUZBM5d+2Yib2qb4X5ijRKlNkR6Q+9YQhb/8hBHNAfM+uo8xvbmjq4SQyEkfUXazxk9fS7rjDcIEFUdc7w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KTZ4IyBW; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715819742; x=1747355742;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vJOK0uF/Wvp7RURnh12z1zK36Vb817Oy1t45V/cfG68=;
  b=KTZ4IyBWI9FeuCvZQDI08z3iwV6cjKJ6qwJSmWcpiCw1Zbwcjh7eRaHl
   Mo/92lpjBvqNfSPz+2xLGMnxK5GfiVUhfsON5DnscMHwlu1Iq4BP5aQtM
   pcDspjszFfaytXCWNcEgT7pQisBKDwZFO4piZLyh0E2opnPHe9qabj5xH
   2fvSG0OsividCzkHFmlw8h54vW1IrFNgYbm4on/vLHLWTBim4nYo+BsMa
   AqX/1JQQJLxD3hhxzLhRdNqPB83GjcSL7t5+MOy2Iz/V8K3j6FUfJ1Y6e
   TUQz2cZ48rgLSh0SIh0NHah4vx+McauG8D74kzsdfjLR4i2Ec6WxI3kNx
   g==;
X-CSE-ConnectionGUID: vTi7a0R+TDWNk0A6L3I4vQ==
X-CSE-MsgGUID: 8FkEdkBPSYek4sBMoPWbrA==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="11752961"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="11752961"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 17:35:39 -0700
X-CSE-ConnectionGUID: qVXvus7WSn6XHXNYIZhGkg==
X-CSE-MsgGUID: kJ4BtlHsQye/Ws8WvOBq/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31170860"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 17:35:39 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 17:35:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 17:35:38 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 17:35:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoZIhKq7VhW8WkoZqrVZF5d95FroB5w6S628hfueGnM4x9YC8kp8bObPozRg3P/DROJHQPceQckHx1hHfIkURFCKxvLHbLMzFBo/GlQDwLAkmFHsbH4GXgHwDmi/6vni4sk5AMNW5SpoV4apHwjYs8o162FZIjUc1tLjkFwEJ8ZK16gl9ztW2nPrlfnGD9NYBHDaHTnQe1XZHfzSKTc/Wa8qh0xlopBxdh2YPUPEUkm+gF0xb9D7kQDzhg38y8HLGQzFt5GVxRYWkaXy+jFSeYxxYjDzT3lhUVKhK6BLzmYIUkKu6Xit3kkz/emxGl5ib/rBMg86+83BZpiDj46gLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJOK0uF/Wvp7RURnh12z1zK36Vb817Oy1t45V/cfG68=;
 b=OdWqRGXC8qzrb3/UZ6sqvXhHawK2da8BXe3TJri37uwbMf+XdhEm/W7J2cCd2+Nsxp9n4xwK4VaHve2MlKq20O8bYr74nb5OpbKcsaVAscQcZromnKU+E6iJ0bfiotV9JOHwKMRgGRRTz6HHju9qMHLUPtc9CvLeJttDw+PxMI9TlgTDlBPzXui48hE4E+iZdhd8Zm4t2e+B+mB8yAFFPmtZtWvA1+MpM9e5abZ5VltgOpg078Lqf9o7mzdUHJYwy1u4KO2sb85t711aEcT+vhGbrqpUrz0cI/G9NXKmB57xcTbUWIl/7vZ91RGc4/h3vo/pSSeW10lToBsHEoWgrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7592.namprd11.prod.outlook.com (2603:10b6:806:343::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 00:35:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 00:35:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgCAAAKfgIAAAeaAgAAByoCAAAQqgIAAA6mAgAAB7ACAAAHNgIAAAriA
Date: Thu, 16 May 2024 00:35:35 +0000
Message-ID: <1270d9237ba8891098fb52f7abe61b0f5d02c8ad.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
	 <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
	 <eb98d0e7-8fbd-40d2-a6b3-0bf98edb77f9@intel.com>
	 <fe9687d5f17fa04e5e15fdfd7021fa6e882d5e37.camel@intel.com>
	 <465b8cb0-4ce1-4c9b-8c31-64e4a503e5f2@intel.com>
	 <bf1038ae56693014e62984af671af52a5f30faba.camel@intel.com>
	 <4e0968ae-11db-426a-b3a4-afbd4b8e9a49@intel.com>
	 <0a168cbcd8e500452f3b6603cc53d088b5073535.camel@intel.com>
	 <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
In-Reply-To: <6df62046-aa3b-42bd-b5d6-e44349332c73@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7592:EE_
x-ms-office365-filtering-correlation-id: 2ce0d1a5-58da-498f-ee84-08dc75401a1e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?b2xJS3V6MjNodGVONDZnRTNhMWVtUm9hNVc1ZURLY1RTOG9UTVhQK3NvTGsr?=
 =?utf-8?B?Zk84SkRENFpuU3BVbWtJb3JjMHYxWXNURE9LRkhQMWZyUlIrak5kdXJaYmRh?=
 =?utf-8?B?WWR1RXZmNmZwWk5FRkZRdjIxb3NSM1BvV3VhTkIvd2pabTJUaE9mcUdaQng4?=
 =?utf-8?B?dTB3ZVl0cmkvb2ppb3B6a0cwWkRzWGp5Qk4vTTJYMUcxVGxYYjl0SnliNCth?=
 =?utf-8?B?Nm1EWUdnMzNFb2NIcUtTaTBFL0JEbzZhNmp3Nlk0Mk1jMFU1Wmk4Z2lYREVw?=
 =?utf-8?B?SXUxWnpIV1A2THBmSlRRWkh5eFlGL0EwbEcxSmhqcFc3SDdubDVUQ1lVc1My?=
 =?utf-8?B?OTNET0VPQjJPQXdQOTlKTVRuYVRFUTJicHJPSURLZnFHMFhWK0thSTRxTnU5?=
 =?utf-8?B?d1l2MzZwc2ZiL2gyM2ZiZURYRGsrQ1lENDBLSkNXOG44NGZEeXIrQlRPWUNN?=
 =?utf-8?B?SDJkc3BjV2prNSsrSXIzWUZLbEN4Q3l1N1Fvc0d3bSsyOGFGNVIzWEVzQXha?=
 =?utf-8?B?N0NHQzNBY2JsQmN0WE4zWTkyNGs1bjU5N1pnalFRNFNQRFBaL3NnSndadTJI?=
 =?utf-8?B?eHQvUEJvN2g0bXpkK012M2dFcHEyVWZUWXp4Zy9BTG9QUW04WjA4TXhvR3k2?=
 =?utf-8?B?eVhOZXp2Sk1wQUpTb0YvcWRyOE5VZDJ0VlowbzFIZGJuNEJFam8rOC90L0Y3?=
 =?utf-8?B?MFZJZG1IWW8vTHgraTlDeXE1anNFUC9WZmVsc1cwZDJQU2xaRkt0a0ZNV2s2?=
 =?utf-8?B?Vmk2ZjJsN2RleC93STRGMGo2alpkVVhGdC9YUGhBclU1Q3FML3R0M0d6UnIx?=
 =?utf-8?B?UG9CRVBIZWQ1bjNMYi82aE4wK2N1cDNuNEtQbWQ1VTBFMlR4bTJrOHA4TWVm?=
 =?utf-8?B?NGY0cGx5RjlCb2ZFMDh6M0Q4SmlYTnUzSmlXcy9DZHdacVFyWHM5Ny9qZklt?=
 =?utf-8?B?ZjBGYXJ2KzZJQmwwWEd1UlhZV21SWk1JNWE4YlhXL1p4MDdCZ1F6eWdzWFBO?=
 =?utf-8?B?WVhxak1UMWpXNjErOTA5NkVMVDNzYXhvb28yTVZNaUlFNzNiQ29ERFJ0VUkw?=
 =?utf-8?B?bW5yY1J5RXk2SWdwYVB1aXdHRS9oSFU3TlFsNlQwRHErYmFrM09hd3ZSd21M?=
 =?utf-8?B?ODhmSUxYZUdWR2wrdmU2aVUyZ0d0aEpDa2tHSFp6aldVcEJQS2FSNmdhSDBZ?=
 =?utf-8?B?RE5ITlNXdEZhTUgxT3UxUGQrc0VyUWpqVFpzMjZVRjZlU3VFRHNtZ1hEVHJi?=
 =?utf-8?B?cWlMLzR4SjBWOEJnRHhRUThwcjJ4WHJmdTJBanNEd3Y1VDVha05OT20yb3Vz?=
 =?utf-8?B?SVUvSzZFaVVGeTIyaHFzMmZLL3ZlWURNYlViZXd2KzJtQThMdG9xaFVKNU1p?=
 =?utf-8?B?SnI3RXJ6ZHFUQXB0ZkhCQkRVSk01NHVSbTZsR25UNGJiRE5pRHBLL3o2NWxa?=
 =?utf-8?B?V0t6ZU04aXo1Z3VBUkRES2ZEMi96bWZrU1NiQjFEem1IOUdiWmlOMzhQNEdp?=
 =?utf-8?B?WkdvYjVoU2ZPZFF2ejQ2aE0zTUVYUGdTZjB1SGpVRU0xYlNxNU5wY3l5SzZ0?=
 =?utf-8?B?V3c3YStyVHM2WmtaMS9CdS9Rd0E2ZmdSaFQ3dzdLL05vMnpXTTlqMENZRHYv?=
 =?utf-8?B?WjFtc2JpcHphcGM3WHlEVnY4RTlkRFVwc0RZZzZORXZmSDU5SFBic1hVTnps?=
 =?utf-8?B?SHlUdVlLbmdRTm93K1daNGN3M1JtMTNVWnJqdzRqOWE1Tm5FbGZzVllDaVJz?=
 =?utf-8?B?UURBMDdxOUxyUlc4QzlPQnA2Y3AvMDVJNWViNkVXWHJrN1dOOFVCeFU2NUF1?=
 =?utf-8?B?aVhJanRObFJZTHd5c252QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3lRM0tHbkFTb0tBeVRyZmRqbE5ONlRDMVRUdDFheEozeEo0OS9hV1p4Y1E4?=
 =?utf-8?B?NjU0YUNBUUlJNTFqS212dnVub3N0WGQwczNEdTJ1cUNwdjVrbTY2OGpSRVpw?=
 =?utf-8?B?Vmk4RXc4VFRhNUxPeWF6clpTZmVNaXhDak91czZQcGs1Y0xra1phTDJIVzdj?=
 =?utf-8?B?YU5ycGxzYktzaGQwTjdyTGNjN2tIZzM3Y0ZIUlhKWVdXOHVPaXVVdjkrSnJW?=
 =?utf-8?B?N2F4cWZXRGRiSTVIdmt0aEtBM0JXVTNMVXZCY1NpaTVkTWpLdWRqWTZmV3U5?=
 =?utf-8?B?emNJTCtBODZHTUhrdVNxeWFIMlpTNFZiMTVvdVdSaUhkYTNoa0htYURaQU5k?=
 =?utf-8?B?MXF0R0NsWGtVancvNUZNbDRaam1iNDE3RFRaZHBydGR3UTdER01tbU9IUWV4?=
 =?utf-8?B?VEF5Nms3M2RUTENiZ2hReUY2T3FjRUxMejg5Y0x5U1I1TVFKc243dnhPMnMw?=
 =?utf-8?B?LzhvdndYQm1DZUNKbHR2T3RETWJOaUFGbkRqRXZ6ZzQwdlM5RzluY1VWSTlu?=
 =?utf-8?B?UjhMVDVqeHFPZGl4R1J0aUtVdlU4a3gxdEZpVStzNWdKL0RTRHM4QUZVYm5Y?=
 =?utf-8?B?dGZGeGIwM3FIaE1JWm5kcHRtcXF3MlBaQVRXRDRSbGg0MmRSSGNrUXpoNlVL?=
 =?utf-8?B?SndqMlg0cGd4dWJ2SVZOT24yeXlpMndWYU5HUVJGaFpWa0VYbEtmeFJjSFZ5?=
 =?utf-8?B?ZXRXZk9aejQwNU5VeVBVdGFQbmIwOHdiL2NSTSthT0dINVhaV0dqaGIyRkhx?=
 =?utf-8?B?UjlIZUIwcUlJelVEd2kyRDhEQnUydnQ5N1J5N1ZTU2hONjZweEpVTVlBaTZG?=
 =?utf-8?B?ZWZYVjNXN2xCWTlRZHZWWE1BK1ptVStBRnpEVlVGWUhWSkV4MlpEQW9DTnEw?=
 =?utf-8?B?QzE0TjZaUGszRzl6Z2J3TDlSQzRGRGVmTVQrL1lhN3NvZW5vN0haeHhoK3ZQ?=
 =?utf-8?B?Skg0eTNYS1MyWGFQMkwwWDUxRjc0Uk9BVFpWMzZRNmxWTWcxcTk2RTJjSlI2?=
 =?utf-8?B?TFNzNExsK2FYU3I1bFcvS3IzSWNlVldlemFrZG5NczMwYnpjaEV3aWxBempj?=
 =?utf-8?B?UjY4Q3g3SDIyeVdqbncxUkxMMWlHdlJPbmRnTnJXanZ6ZTZMck0xSEY1QU1w?=
 =?utf-8?B?LzBZY1FnZGxuNVo4MEtrdElhMks4Z1RBU2Z3d3F0SXNueVZxODIxTzBFa0N4?=
 =?utf-8?B?NUtnOTdBK3hOQmhxNm9Ea2VLdEF6L1NZY083UTRPK2svZ09YQ2FWOXlWYnZj?=
 =?utf-8?B?SVduM3Fzd0RMMFhFakZGbGp6Z0VzbUJ5WlVOOE8yeXpDaWp0anBuZVBicVFk?=
 =?utf-8?B?T2tCc0l5UXFNMzJ0aHlNTm9UZzlzQy9iWDBJbXlrOFRLZ3hPRER5RHZLanVv?=
 =?utf-8?B?SGhYTEVsbDZFU01qMVR2ZitXN2lZOTA5b2JPcjY3WXRwMXpOK0U0Q0lWQkZK?=
 =?utf-8?B?NG81OVFibDRWSnBDSS8yOGlJV3lRbE94L0kxUEtSOTZEbytkK2JMalliQU5U?=
 =?utf-8?B?Mk8xeWhUQTM0Zk1tOUtLUmphNDJTQjlpR1hVY1BFZndjN0ZwRVpueUxHMmNC?=
 =?utf-8?B?QnRnVkpOWWZmb3pGanJwcGRQakVON2tSOFlTdGhZUzhzYUpxOEh1c0NQT2Fj?=
 =?utf-8?B?MGdqWmdya29pMXdxeVlRcnZYT0lSSEptUU4zMDRGWXNYajE4RVQ1WEY3UHBk?=
 =?utf-8?B?UUVSbFNrc1BSdXRzOGw2cVNsZmZXbE1lMkZxejFQSUpubk1rb0k3WWZlMjl4?=
 =?utf-8?B?OGRUOUZmdHIxUkovZndieEwrTGE0QXBnT09YdjFyR05CbXJkMElENXk3eGdG?=
 =?utf-8?B?YmZCY1pLMlFGYjJNdnlsSFdNQy91aFBNTmgrNWY1bWsxdEJSWGlRdk9Xczhs?=
 =?utf-8?B?ci9wcXJoV3UzV3o1NzFmZ1VBMUxMcnc4V21DT1I0eU9MSExNV001UkFqTlNx?=
 =?utf-8?B?RlRBYXprQysxaUVUUDVFVjlyd2lqVjErSFVla2hzMkdxeFdmZEpwdWpCaitN?=
 =?utf-8?B?Mk9lYzIxRTY0ZFdKcjVLSWt1YXF5bm93RjdQUXBKQVJwWU9SWXlMVXZOM2pO?=
 =?utf-8?B?bWJGejFmemViaWZ2RlRMVVp0b1hMbG9IMGU2QndSNVpQV2VRM0JZbnorY2NS?=
 =?utf-8?B?d09UTzYySVM3dmpKZUlEdFRBbVR4SFpGRHRtM1NCUWtGRnlvWmZNTnFqN21X?=
 =?utf-8?Q?uy43euNX68wGcuOy1XV5mp0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CBB533FE2FBAF43811EBD60F4F9D00B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ce0d1a5-58da-498f-ee84-08dc75401a1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 00:35:35.6320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OHc29oOkXbpJX1MdVlNqPGbuI8IQ/tO2nAC+9EDmM4d89inLOl21zJcKZfGO3WkjH/3mB5oQsnVtpmUOjiEZ8owcecJju4DK4jKWh7/4So=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7592
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDEyOjI1ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDE2LzA1LzIwMjQgMTI6MTkgcG0sIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0K
PiA+IE9uIFRodSwgMjAyNC0wNS0xNiBhdCAxMjoxMiArMTIwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiA+IA0KPiA+ID4gSSBkb24ndCBoYXZlIHN0cm9uZyBvYmplY3Rpb24gaWYgdGhlIHVzZSBv
ZiBrdm1fZ2ZuX3NoYXJlZF9tYXNrKCkgaXMNCj4gPiA+IGNvbnRhaW5lZCBpbiBzbWFsbGVyIGFy
ZWFzIHRoYXQgdHJ1bHkgbmVlZCBpdC7CoCBMZXQncyBkaXNjdXNzIGluDQo+ID4gPiByZWxldmFu
dCBwYXRjaChlcykuDQo+ID4gPiANCj4gPiA+IEhvd2V2ZXIgSSBkbyB0aGluayB0aGUgaGVscGVy
cyBsaWtlIGJlbG93IG1ha2VzIG5vIHNlbnNlIChmb3IgU0VWLVNOUCk6DQo+ID4gPiANCj4gPiA+
ICtzdGF0aWMgaW5saW5lIGJvb2wga3ZtX2lzX3ByaXZhdGVfZ3BhKGNvbnN0IHN0cnVjdCBrdm0g
Kmt2bSwgZ3BhX3QgZ3BhKQ0KPiA+ID4gK3sNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoGdmbl90IG1h
c2sgPSBrdm1fZ2ZuX3NoYXJlZF9tYXNrKGt2bSk7DQo+ID4gPiArDQo+ID4gPiArwqDCoMKgwqDC
oMKgwqByZXR1cm4gbWFzayAmJiAhKGdwYV90b19nZm4oZ3BhKSAmIG1hc2spOw0KPiA+ID4gK30N
Cj4gPiANCj4gPiBZb3UgbWVhbiB0aGUgbmFtZT8gU05QIGRvZXNuJ3QgaGF2ZSBhIGNvbmNlcHQg
b2YgInByaXZhdGUgR1BBIiBJSVVDLiBUaGUgQw0KPiA+IGJpdA0KPiA+IGlzIG1vcmUgbGlrZSBh
biBwZXJtaXNzaW9uIGJpdC4gU28gU05QIGRvZXNuJ3QgaGF2ZSBwcml2YXRlIEdQQXMsIGFuZCB0
aGUNCj4gPiBmdW5jdGlvbiB3b3VsZCBhbHdheXMgcmV0dXJuIGZhbHNlIGZvciBTTlAuIFNvIEkn
bSBub3Qgc3VyZSBpdCdzIHRvbw0KPiA+IGhvcnJpYmxlLg0KPiANCj4gSG1tLi4gV2h5IFNOUCBk
b2Vzbid0IGhhdmUgcHJpdmF0ZSBHUEFzP8KgIFRoZXkgYXJlIGNyeXB0by1wcm90ZWN0ZWQgYW5k
IA0KPiBLVk0gY2Fubm90IGFjY2VzcyBkaXJlY3RseSBjb3JyZWN0Pw0KDQpJIHN1cHBvc2UgYSBH
UEEgY291bGQgYmUgcG9pbnRpbmcgdG8gbWVtb3J5IHRoYXQgaXMgcHJpdmF0ZS4gQnV0IEkgdGhp
bmsgaW4gU05QDQppdCBpcyBtb3JlIHRoZSBtZW1vcnkgdGhhdCBpcyBwcml2YXRlLiBOb3cgSSBz
ZWUgbW9yZSBob3cgaXQgY291bGQgYmUgY29uZnVzaW5nLg0KDQo+IA0KPiA+IA0KPiA+IElmIGl0
J3MgdGhlIG5hbWUsIGNhbiB5b3Ugc3VnZ2VzdCBzb21ldGhpbmc/DQo+IA0KPiBUaGUgbmFtZSBt
YWtlIHNlbnNlLCBidXQgaXQgaGFzIHRvIHJlZmxlY3QgdGhlIGZhY3QgdGhhdCBhIGdpdmVuIEdQ
QSBpcyANCj4gdHJ1bHkgcHJpdmF0ZSAoY3J5cHRvLXByb3RlY3RlZCwgaW5hY2Nlc3NpYmxlIHRv
IEtWTSkuDQoNCklmIHRoaXMgd2FzIGEgZnVuY3Rpb24gdGhhdCB0ZXN0ZWQgd2hldGhlciBtZW1v
cnkgaXMgcHJpdmF0ZSBhbmQgdG9vayBhIEdQQSwgSQ0Kd291bGQgY2FsbCBpdCBpc19wcml2YXRl
X21lbSgpIG9yIHNvbWV0aGluZy4gQmVjYXVzZSBpdCdzIHRlc3RpbmcgdGhlIG1lbW9yeSBhbmQN
CnRha2VzIGEgR1BBLCBub3QgdGVzdGluZyB0aGUgR1BBLiBVc3VhbGx5IGEgZnVuY3Rpb24gbmFt
ZSBzaG91bGQgYmUgYWJvdXQgd2hhdA0KdGhlIGZ1bmN0aW9uIGRvZXMsIG5vdCB3aGF0IGFyZ3Vt
ZW50cyBpdCB0YWtlcy4NCg0KSSBjYW4ndCB0aGluayBvZiBhIGJldHRlciBuYW1lLCBidXQgcG9p
bnQgdGFrZW4gdGhhdCBpdCBpcyBub3QgaWRlYWwuIEknbGwgdHJ5DQp0byB0aGluayBvZiBzb21l
dGhpbmcuDQoNCg==

