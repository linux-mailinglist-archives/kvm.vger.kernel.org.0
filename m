Return-Path: <kvm+bounces-12794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C6088DB5C
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A4121C23CA8
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6362A45BE0;
	Wed, 27 Mar 2024 10:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jtC7qnQR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10DDB18E0E;
	Wed, 27 Mar 2024 10:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711535922; cv=fail; b=sRQpEVnDaPZOq+qgqE8QfiD4GYD8KxKTkDOZkMgIr/ctz32lK0J4C+EhAgi4iqLEpeds5f3LW13o9H3kP2VTQcwZGGE1GA6QphNAlaLuvi6NSxs+0NFpae+na3k6I5qW9HXFwXutqgZK9q00GsZhgYG/k8pvZV1z9Yh8YZG5cMw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711535922; c=relaxed/simple;
	bh=6xKbBQ3jgAWbTIEp6L7fXq7gPDMKSpCL19VmrikMydE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ak1BwMVM7LFdthY9Ch2/bvYF+5IQJ5PRpu34CtuMV7fsIaFVC61i7+qT41zo+JwOAyRlxFXNDPWC16zvDfGV6EaKZ5BoGdX/A+StwfdSdhaCsLkXmKoCUCJOD4mR7GxXmB0iv5gRwUONZHX8T9sSiMcnSTyk/DcfHKIY2I+vMKE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jtC7qnQR; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711535921; x=1743071921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6xKbBQ3jgAWbTIEp6L7fXq7gPDMKSpCL19VmrikMydE=;
  b=jtC7qnQRKAbRxYDL6Ehgq+FGOJLTCuQG82iYUEIZzAPYlbU6d0j6xcjk
   E5qBljKd1j/4TorCLr80gjF16qvFADAOGVvleoIFJ4aFVqZXhiVlYfgHO
   jElhfoh49h0TWpdBr3QOtKGkZu0tUcO9Lac3LO58mbzdXrrT8Ck8mZ1g5
   JrzN+wPx6zvF9Wqp31dSq+tY+ONTwvhiIyCBBx1fpcFaBUSY+iZNaOMzS
   G5b3Gr5O1W4JbKNs2hFXDVpikvhJHbox9Rn+o6Zpxr6XmjYRxAwcCwWxU
   L9kldegEALN2NMTjewskSZWIgrPGzHG5+dBt0Dnxd4rw2HO2uisdgC0Sp
   g==;
X-CSE-ConnectionGUID: iWRU3FxFRCyHoDx0pFkr5g==
X-CSE-MsgGUID: ToLaN9P1Rt+DiuTn4LxnQA==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="10427961"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="10427961"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 03:38:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="20903582"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 03:38:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:38:39 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:38:38 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 03:38:38 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 03:38:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IYyvriWUQg31mqk2h3r899STZtVvoXqULykT3b0chPWU7D1HtFg3OfV8wV/MwTkFbF0PQokV+wa9Z5WQLF8rPSBe5I8qR0BMDwmmvwG/2Etff0vYSEdqsl8nn0D9WFIFZ1huoEWQBn9evOf7Vt3JOthN8SP2WeCCAUHiDJfvUxb3KWz964FXFdzUDF4QUPTX1aqzjokqHcgl6THpjX+adzzQKRxE7GXAMUdurINnejGKyjcfY6lwTtwG05WYN6Ag1HGZHw5A2/MYAwVmx6RHaq23Wgl6Gt2bZbgjjcn+9wHJs3r3xZu14YZLyIrFE6jkYqrp/dSQAMuj/4c1IzOaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6xKbBQ3jgAWbTIEp6L7fXq7gPDMKSpCL19VmrikMydE=;
 b=DmbGSbSAsKJQJHDdRqgonPzKMO8x9Rden4VMeQlmICo7L2vcNE4JzPFsRYSGcpW9HUcd6a74M5HSXD9Y2lojttZYGV0USEaik06L5hI1TMu59PYRpUrLbjfFf9ECXJcvrLrwR5h4qWEA9hIQ+KC46r3T3eSqVXFfLOrEMf/j545eogpXQa3DJMtafEX/gvx+9EYPSf3qU4QUj+DaX+dK6zdG8Vfhuqn4wBh0hob2ziSs1hgA/iDWuC78UaXeJEAuqe5Y+mxCBo3sjjFycVE8/hkSQK//w/dr6GrpcQ0qE/QX2E3JNbNzJbgI07OUmBAJwk4pPhVatBOzYqobZvyQ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8521.namprd11.prod.outlook.com (2603:10b6:806:3ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 10:38:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 10:38:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 5/9] KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a
 single 64-bit value
Thread-Topic: [PATCH v6 5/9] KVM: VMX: Track CPU's MSR_IA32_VMX_BASIC as a
 single 64-bit value
Thread-Index: AQHaccEQi2bK4f5tYkO2W3Fi3NXhZbFLglMA
Date: Wed, 27 Mar 2024 10:38:36 +0000
Message-ID: <2f1189da63fb06b766d19ca5f230497fa44b2667.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-6-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8521:EE_
x-ms-office365-filtering-correlation-id: 5e0908f2-5b2c-4fe9-28fc-08dc4e4a0f38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pu2G4D5wQ0+ImPFkZNERk2+WMiQmqD4sPuX6zU3KqNjafluj0Zcyfz++IqAjkAJA9V3m0125RqVi8WRWi6i0t6pH4NKuCUBZD+WtbvzARvTUzN9dZb875Wsh7vFbAKevdEuWi4I1R5PM0Uyz/YM6HwXmzVTvrGCj7ETiVE7qVVTqtQfBU+6B+GA3wVTen3sD4T59grksh+3KNnnmHPr1R9/O1tQzB84ML/l1TK4yxfSmB9JZgWcRVglMjfd0g6YCbbwjvL/LlGYkUYd8L0YXhr231tSQSw/dsGIvwcSkcSxW1WG3PAlzyHyuDf73VnJ7Cagim/jYg4C4H5uwzhCCU8OPPNIJezAGhFZb0pqbzUxI06LqrKBg70dU43eqmdsKkhN8O+3nWxnyIDkW80rM4bDBPtzi488um3zK+EFZrViUu2LW1ilThjyBQeF5l0Tkcz76va5tnhpFJtd8N237MuFWwYxMTg6dw/8LEbwOikr34VBIFnc+MNDj8H8hq/HEO3tUXAXw398I1P6lZgMtYfyJn0NuVJVepFV2Xr5lqnO02Ga7tpc91yQG/YpJAMGNUlTczpoyMglpl+QbNhMZNgpWywEyyngBdgneIknxYP7kkgqRUjIb1l9xioJ1fZE6iBBRsOFhF8Oy3rT4pdll1GjNNtE/g3fLjcTRAXd45tCQZrkIDX9KfCpmxBlx6R//iq72XKrRC8WAlUwEr/XkCe7x1D/KtdLcJNhedznsWK4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mk1wN1JpTnZYYkpNUVhHSFRXREFudmlEaGVhVWh6Z2NpK1M5VTJKSm1jeGFv?=
 =?utf-8?B?eFlqRXpxZDdQMGNMMFBnaXUwK0NiQ3lTS1JnbzVWTjFoci8rbnFXcmhiWU5P?=
 =?utf-8?B?ZlF0RUFvVlB5OXdDZE80Uit6QlRqZnZTUG1PbmxjSXd0WmMzQk15bmt5R2tj?=
 =?utf-8?B?TEpWWCtJTVRtVWJSbVhIbXQxVTdhczRBK0NhdHoxWWJYeDl6OXFsV1NLT2I0?=
 =?utf-8?B?RU5VaU14bVhmM2hCbE1Qbzl4c3hBa2RZR3lRWUJLbXV2ZkdQRjQ3Q0FXNWp3?=
 =?utf-8?B?VVBXek9ObC9oaysrN3NDUCtHSllKajVmWUdMZkdvSGxjSzJKSDNUNUpIdUNG?=
 =?utf-8?B?QlVNWWlJamVhV0pMaFBBb1dRNzB1dnFwSzFDZkVMZnBSaVdVV2tLMmJVYVYv?=
 =?utf-8?B?UXZiWE5QMkxKMHhSTXRSalJ1VVlKY1k2cTVhS2g0MGVpTEVqcXozcEhXWC9W?=
 =?utf-8?B?V1NaYlJmZnZOeStCK3M1TkIrSU85QlF0SENTeGxFUW5PcVpQU3kxUnAvNVpI?=
 =?utf-8?B?UEtZSGpBZHdWcXVhcTIrbWZsUjFRcXdDZ2VuU2h2clJIcVo5UVg5S2ZwQmlz?=
 =?utf-8?B?cFVnM2k5M2FZaVdBVEpSQjdZMXhtZlZaOGZpbkQzVjRJVGNxY3Fvc0NrV0gv?=
 =?utf-8?B?bytRRkNlM0lGcEdFNkphODF4Q0lXcVNwdi8xOEJHbWJvZkpVN2liM0Y0SXhn?=
 =?utf-8?B?MThaMk9DMlhYczY0SkUzK2VGaDg4RFJQNWhIU1FCQ1IvMzRwc24zdTB2dnUw?=
 =?utf-8?B?Y1hwNUVuYzNiU3Y3K0F1N05xOTVrTGRVNDJKdEduRjRkaEUrL1FZUFhqRTEw?=
 =?utf-8?B?VFYvVXV3UXJxL0p2Mmt4d3VnL25BSmdNTW9IencyT0grSDlxQzZoNGhianFi?=
 =?utf-8?B?Uzd0dDJHQzhnZUlLVmlXWjUzRUpZZHB2NjhkY0JmclFZQUFzL0FKd3kzYjJs?=
 =?utf-8?B?V0c2M05LdE1sWVJEWm9iOGQ3VS9wcmc2Q2xWZTBvRmF6RWQ1VjJpRmR4OTM3?=
 =?utf-8?B?S29XZE1UK1BTbjErSUJpdHIrYmpUOEZxMWRWcUgvSFUzcHFLK0plQnlqcXp4?=
 =?utf-8?B?T1U1cjRFdHZCb2ZwVW5DSzE1WW1zYlhLMG42dzZuK2p3ZTdONERENktWK3lq?=
 =?utf-8?B?K0l4S0dFM0o3bkpVVHMvRDVIWkI0T1JXRVl6Zlp5SjdrSG9mNXIrSlV6ZkU3?=
 =?utf-8?B?cTQwVmU4dWtFQmVzczdVZm03bkZkdGtUb3d6bFlWTVd4WnZjaXRtMi9nVmlh?=
 =?utf-8?B?dlVwVW9PeTVhOEhtSWhySWxrRXZtNWdpRHlJNlB4bGRPZk4zckFlZWJaTlhH?=
 =?utf-8?B?dXZlS2hoODRvTWJwRVJETUVuTC9FeVp0V3Y2OXJFMllMejJNeFAvQ0cvOElF?=
 =?utf-8?B?L2Q3eEJDNjV0REEvRy9rUmhpdVI2eERKRGxCTUtWWHhUQ0VkTlp3aHQ2aStH?=
 =?utf-8?B?L29KUHZyeEtvVldUcEx5SzBXS3hreUdJVWtTUXNzRWpxTTBPcjVJMTUvTHFs?=
 =?utf-8?B?MlBWTGRGK01DYkRwZzdtZnBwek13YithNUM2TVBLeFk1Z2tZdDJtMzM2eG1O?=
 =?utf-8?B?WVg0QXcwSkVDOVRiZDlZaGhpaEN2V1FuYlZEaytJNlRHa3NST25QOXJjZ1hq?=
 =?utf-8?B?S3BGbWlqellsTEsva3c0YzFVU1ZySlN1K1lFWHNrNlQ0TTBmTGd0Vy85ekx2?=
 =?utf-8?B?T05YUldDS1h5VGwwTnpid3NVQVpQZkp0Tktua1BLRGU2V3JHKzZVQTN4U0RF?=
 =?utf-8?B?alVUSEt6ek5ReHhvbzBFSStqNGwyaHRXKzdJY3YvWDNja0ZBblAvekJxcFFp?=
 =?utf-8?B?ZkRjMXhVN0IyalVyZHI3bk8rZGVra3M4S244c294UHZIV1hhWEtkSmlWSitP?=
 =?utf-8?B?WVZEOUlnMi9XQ09pZDJtRlJuK1c2QVlHSkhZaW5NTUlJRzlCdzZ2Qzd4ZDVo?=
 =?utf-8?B?SDdJN1I2OS9GVFZueC9RdHA0U1hSUmtSTndtTkFPYytEVFpPcjQ5UkdSa3RN?=
 =?utf-8?B?dWtMZ3lyZ1lvaTBjaE00M09LeWNTbkFBRVRma3R5WklMYzlPNHJRemNUcWNN?=
 =?utf-8?B?QzdVLzhMRU9oY2F5VGJzNkhOV093TjIxNGgxc3RtV05xYmFwYjRWRFltS0Zl?=
 =?utf-8?B?SktSNml3dnpqNFc5RjNZUjc3MFRaRmpKSjJWUVJNKytYZ045MURVUlYxS1po?=
 =?utf-8?B?QWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53518829F99F4B4B80A2284E31577C46@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e0908f2-5b2c-4fe9-28fc-08dc4e4a0f38
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 10:38:36.9284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4QfKxmkuifIT9nDhIMUP1K+A7F7WZW1a+tV1x5ImJ8yhrhBvGZxkldF5DvhkdlZ7TNZZ+/0dYw1/4AF3yxmF0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8521
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUcmFjayB0aGUgImJhc2ljIiBjYXBhYmlsaXRpZXMgVk1YIE1TUiBhcyBhIHNpbmds
ZSB1NjQgaW4gdm1jc19jb25maWcNCj4gaW5zdGVhZCBvZiBzcGxpdHRpbmcgaXQgYWNyb3NzIHRo
cmVlIGZpZWxkcywgdGhhdCBvYnZpb3VzbHkgZG9uJ3QgY29tYmluZQ0KPiBpbnRvIGEgc2luZ2xl
IDY0LWJpdCB2YWx1ZSwgc28gdGhhdCBLVk0gY2FuIHVzZSB0aGUgbWFjcm9zIHRoYXQgZGVmaW5l
IE1TUg0KPiBiaXRzIHVzaW5nIHRoZWlyIGFic29sdXRlIHBvc2l0aW9uLiAgUmVwbGFjZSBhbGwg
b3BlbiBjb2RlZCBzaGlmdHMgYW5kDQo+IG1hc2tzLCBtYW55IG9mIHdoaWNoIGFyZSByZWxhdGl2
ZSB0byB0aGUgImhpZ2giIGhhbGYsIHdpdGggdGhlIGFwcHJvcHJpYXRlDQo+IG1hY3JvLg0KPiAN
Cj4gT3Bwb3J0dW5pc3RpY2FsbHkgdXNlIFZNWF9CQVNJQ18zMkJJVF9QSFlTX0FERFJfT05MWSBp
bnN0ZWFkIG9mIGFuIG9wZW4NCj4gY29kZWQgZXF1aXZhbGVudCwgYW5kIGNsZWFuIHVwIHRoZSBy
ZWxhdGVkIGNvbW1lbnQgdG8gbm90IHJlZmVyZW5jZSBhDQo+IHNwZWNpZmljIFNETSBzZWN0aW9u
ICh0byB0aGUgc3VycHJpc2Ugb2Ygbm8gb25lLCB0aGUgY29tbWVudCBpcyBzdGFsZSkuDQo+IA0K
PiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZCAodGhvdWdoIG9idmlvdXNseSB0aGUgY29k
ZSBnZW5lcmF0aW9uIHdpbGwNCj4gYmUgcXVpdGUgZGlmZmVyZW50KS4NCj4gDQo+IENjOiBTaGFu
IEthbmcgPHNoYW4ua2FuZ0BpbnRlbC5jb20+DQo+IENjOiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFhpbiBMaSA8eGluMy5saUBpbnRlbC5jb20+DQo+
IFtzZWFuOiBzcGxpdCB0byBzZXBhcmF0ZSBwYXRjaCwgd3JpdGUgY2hhbmdlbG9nXQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gDQoN
ClRoYW5rcyBmb3IgZG9pbmcgdGhpczoNCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1
YW5nQGludGVsLmNvbT4NCg==

