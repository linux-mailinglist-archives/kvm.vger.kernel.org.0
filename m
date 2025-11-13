Return-Path: <kvm+bounces-63002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E27C57184
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 12:07:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E4903BB087
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 11:05:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9724733A014;
	Thu, 13 Nov 2025 11:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QLlXPM7c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E95628466F;
	Thu, 13 Nov 2025 11:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763031921; cv=fail; b=SdYyuclfAE7bIhKvbaZsH/EBeL5yBM1Z5qKn0qZg+d27IwfL5u1euNTx8l2L1kkMze0XpuccOkAoUrXPDoDWqVMEpGlrQN1qe85sf5+1GS76GQFwdF3vQ+DXbYwz9jat1TmJykXH9mPjdAzdrsHuVpROPEkuuvAFoWWjyZWrYIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763031921; c=relaxed/simple;
	bh=v1GISdfieWOjuldvvv/0U4hVwqL5NzgMn+IocCAmN9M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J8KwGTELhrOJm7Qnn+gzf8mq7S2R9W1W2zphCZZIzmdS5utwVI8Yz0NrowUmi0QkavECLDn2EWqBwHNq0qJ6fUeh1bqR/qmlhrigwkK6enqp3t84QrMur3TDCn/QbFn3yZsk7GpwL0c63HPdMQZrCxX9sgEcqiWJorLpMX7kYUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QLlXPM7c; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763031919; x=1794567919;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v1GISdfieWOjuldvvv/0U4hVwqL5NzgMn+IocCAmN9M=;
  b=QLlXPM7cloQg/WQ5+Jeje2tdo5lwDMjBJuVxY2aa7DI5tBc/lu/l7uER
   wh49t6/8qmSvwKUYfw8uOJv8tMzJOlC6OlJTSGreqDk/MB09S1wfjGhXA
   N0nmp5bQceyu6MtGKDr/kE7akwxeY/sZMYjfrfsLc8YqL8uKghpGoeutj
   mJOB19MwB1O0cTVXFgC4Bxhme1tT5F/clfE7XBvNtGwoEUgq+vTI6QBMP
   /oP+o6XDe3N6d5kdAu0SOAX6G5bxcpvurr3wvOJlh30hketqU/iorFCpe
   6fs9joVYtKHakPq4DA/y6ytzjD9DyBwWbO8tALkIxor3zSLYO6QvVUh8S
   Q==;
X-CSE-ConnectionGUID: y9Y70JfzQoefDtsO3XQoEA==
X-CSE-MsgGUID: 7LHMdjoVSEGe4835wIRtUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="90581322"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="90581322"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 03:03:07 -0800
X-CSE-ConnectionGUID: XNfHSjrxQbSBmypg4pDMGw==
X-CSE-MsgGUID: Fv+0sxzjRWyoxHXBIq2zeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="193912422"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 03:03:08 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 03:03:06 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 03:03:06 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.25) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 03:03:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tq4c17sk6wVdudyJ+vgkUky/gKF3aH+nx97jJirmYNdoYEaSDPha2IxB5amb4gblt0VIZaG7s2fblNTz+l1k0aWZI1KnXyunf+LEv4Ht3jkI8tedf7JCUMTsooPSs6eu319TdCgOWpE35QJrGnH5tpyepAXkbiDw/yp/3cR/jiyE6+R/l6vd7aeFWEIscSNadR3xJRTXpwikl68HvhQS1CtigkYvZRLPZhWhS4jFcES6IVAdhxrHJ3C9k/HXrPU9Dybx+EIP3f41sThw57KeTuSCj/luwQwfB2ZVkIwbI3n4MAR+W2vxk2zfzVtgmkUlVP49cbgKa6XgMpiH2qhYjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1GISdfieWOjuldvvv/0U4hVwqL5NzgMn+IocCAmN9M=;
 b=aIhdEeLLaGP3jT5uAx/aq/FJAkT7kVZ3GacaVd3kiY5Eo+G6+NBM9Kp0rs6xrnpG71YP/C6nstsSxNR2+AuGXqlcI9T8xOytEg169690vyH8C54Re3IB9ioizAJ88HPNPhMb1yzdxsFWFVLoO3jQCZhOqFQHE6dr2MvpSMBVQ8acA5KzzCYOgrh5e5iMbkkr1jQNFwAYIi0qIbgzbh+v26njyjQcw8nt1hjr2g8DPXs9Q8HPqEHMB3zJAMYCx0NRbtJQr6TKNzq3LWa7W3CxDXL5m74x3hhI/sSk09r1UVArRjkZqWzPYig6mGMOKJk5VWPQ69S/KpZEUIleTzFJYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB5326.namprd11.prod.outlook.com (2603:10b6:5:391::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 11:02:59 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 11:02:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kas@kernel.org" <kas@kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcB4AQJSSoQW12Bkmtr+PwbHPEybTt4N2AgAMGZYCAACPdgA==
Date: Thu, 13 Nov 2025 11:02:59 +0000
Message-ID: <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094358.4607-1-yan.y.zhao@intel.com>
	 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
	 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB5326:EE_
x-ms-office365-filtering-correlation-id: 749c672f-2257-406a-4b20-08de22a434e8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UmhxMitLb3dmdko2dWV4YVNhenVYaVdwZnUwSlo4SUNXTUVoSlg1MG80aHZP?=
 =?utf-8?B?SGF5VHZQK3czbDJwVkFRNDc5by9KTXpnSzBpbzNSeHJMai8wcGlKNy9nUE1i?=
 =?utf-8?B?bERDbFN1UHluMXAySjJnQXk1b0IrdU05WW1pWG5NdG9INTRYeE8rZElkUGVQ?=
 =?utf-8?B?NDdNT2pFQnZRRm51d2VBaXNIK2pYeFlUU1FyZVFPdGZQMFpLQkszeDlteTJS?=
 =?utf-8?B?cW5mVVl6NlB6ZVAwVUFzZHNNUU91cWpadVdUbUdEQlNhL2EyK3JoYlJXT2hi?=
 =?utf-8?B?dTBmcWtKYVRwSVFkNnIwSnd4dVdRbTAyeERkZU1na014aHZiblFXbkJRS3d2?=
 =?utf-8?B?ZzErd2RtWVozb2dDMEpqMFUzM2psZ2lEYkFWZzgvTHdjTmdwR2cyWjIrZ090?=
 =?utf-8?B?TWo4dW4vMmkyQy9ML2pNb1lMRlZUbnV2YU4wbmJFVkx1TXY3MGRXSCtZYnhZ?=
 =?utf-8?B?QnBYWisreE5qNW5XVXI4TW9lM2M5Y1ZlcVE2NmxjN0EzM0xpUHIzczVXV0pn?=
 =?utf-8?B?b3AybzgzR0FOdDVrUGRLTmsrendqUnRKQlBIM2FucURsZXVqU0lva2d2RExK?=
 =?utf-8?B?SVZqeDFoS2hKUkJCWHJON21NS2RpQXF2ejRIQk53NkcwaEZUVkJTMlJZOHdP?=
 =?utf-8?B?bTc2YmRRQlF4MUM1VHFrNDBCWUhScWMwSXNUMUJkQ240QXpPb3VDRWZTSlVo?=
 =?utf-8?B?MmoremtuK25menhCK0plQmFacS8rQ25DcEZOK2dndlA5YTZGK3R1Ymw2eEZR?=
 =?utf-8?B?NjdVRjFoUndzbjQ5SUp6ZDl1enFLWGd5Z2EzVG1wTlNUcWhnbzN0azVuazFB?=
 =?utf-8?B?c0Jydk5WbUgwbXpvUm1aaW9NMUlUUjdVL2sybDhiL2NFZndLcVRHVVBuS0x2?=
 =?utf-8?B?aGdUaW94UkdVdmw3Y2lhdUttN0EvRWJNM3VnaTU2ay9icWdNQlpzVTJKWUE5?=
 =?utf-8?B?bXB5S1NXc0xYSm1WR3NmdFhLQncrUEZzazQ4dzFTVnZCRkxFOTlDVU9JMWFG?=
 =?utf-8?B?UkNHV1pFbk9UbHVsdHF1ekFZc1JCaTYvTTF4MEV0dUtudVFVOUlJeVo3VFNt?=
 =?utf-8?B?WXlpaWw2MnpLVk5HRWEyV3RDMnQvSVJHZzgyNzhjbkNoeVZwL3ZSb3duSWt0?=
 =?utf-8?B?VjJnQXViNE1YaW5EMHNwS21sSm9pRmNzcWI2em9JUmtGQ3BQODhQUjdKSWIz?=
 =?utf-8?B?emJVUHdEb3pQZ2gyMXRnTE1nd1h1Ym5ERkd1UlJhZE1rVlRsSXN2T29UL2xH?=
 =?utf-8?B?QXdmdHRGcmxYcEEvMWVpd3dPSlJFWll6Y0NMeEp6amRoTENJMm9VcWpZbTRL?=
 =?utf-8?B?c1g0NkttK1p6dnZIZ3htYXh3WFVpMEJSWXVLZERodzVmWGtnZFMrV2g1eG9x?=
 =?utf-8?B?cFBGQTZnSFpDNzRQL1psWlJhZVIxSHk4czU1UGhxdWR6YTFFV09WNnJISGVP?=
 =?utf-8?B?Rk91dFVIYVg5TmRlTlBxYmFqWmQ2aHZETm5XU0ZrRTVGZDBCK0tSQnpvNWhw?=
 =?utf-8?B?QU5NNFo4Mk5IRHprN3VDZ3FQYWZyQUdxbHpjaUZoL1p2VVJpcHhlMEQxSnNQ?=
 =?utf-8?B?Wm1aZHQyb2NIYkxENzIyMkdsaXBiT0hoeEU3NU40ay9DdkdBM2xSVFZZeVQ2?=
 =?utf-8?B?SEZ2Wk1JZzVNUThRNDFvRjhOVTR2WlJkdklDOHJJemRCNDNIYTVsNU4vcTZu?=
 =?utf-8?B?cVVCeTg3NVRMdDUyM0c0SHVINHc4R000U2toR0lxWnhFdk1vQTA5RmlFV2xr?=
 =?utf-8?B?RkdnamlSR2FWR1FydkhoSlVDMHZBZ2lKUGhEaDM2cFRqb2NGSkxEc1BzcXVW?=
 =?utf-8?B?dDRWRTdDM3BseXpOTzJSbk5JUExzelBndUYxb2pYeTRybGw4RjJJZzVQQmxZ?=
 =?utf-8?B?QVdmVzEvekpRcE1Qb0NHWElCUysvaU5WazNhSk9FZ0ZoZXlBbVRDOU9rZEdM?=
 =?utf-8?B?UmxuM1RpUE1BYmtZOUcyTnlyWWMzSnA1SmdOWjg1R3Zoa2tVV3VRNXdNMHhy?=
 =?utf-8?B?bDkyUmhWY1BtYU5sQXNlOGhtaHNHYk42Zm9Ob1dGVzh3d0ZaRDNXbmNnTytl?=
 =?utf-8?Q?qYOOIr?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2tqZmFCNk9rOXk5bWtPMmUrT2pmOUNadm5XSzZxT0lGRHNjWWF3NldiS3M3?=
 =?utf-8?B?UllJUUFQeXl6ZTlKaW5MbFN3OFVXVGh5R0hkS1pnSlJubFNVNnh5aWxKRDVP?=
 =?utf-8?B?QWZpNjBLWHNzMmlsbVV3N1lSM1FvSFdFcEhNUXNKejlnYkFMQnZHUk5JeXZn?=
 =?utf-8?B?TzJIajJNczhnazk1TFc4TVFwdDNmUEc5OWhkQW5XWi80Sml3akkyb0lVUkl4?=
 =?utf-8?B?RXQ1akJzVmhpdzErWHl4ckVUVUpHNXpjUXFPM05aN2NKb09QVGt4Q05zampB?=
 =?utf-8?B?eXZDRXU3a0Vjc1hneDdFVjRWelFqU25WOVBLUm9SOTJQRzhTVzIyalMxVlRM?=
 =?utf-8?B?VWZ2eTlYYW1RTU5Db08rRkJPZi9PTUg5Q0Q0Nm9PT1hiZXZ0MFJ5MW5EU3E0?=
 =?utf-8?B?N1VhTkhpeXVtMDdOdnUweTF0T1N1TTYrajBIS0Q3b0tXL212U01NZitpUGFJ?=
 =?utf-8?B?ZnZxWG1iWHR6Q2V3UE9INVk0THNSc0lzM0gxZmR1andqOHpnSjNSQVZXZ0NL?=
 =?utf-8?B?Wk4zWUpZc2NsM2R5UUJ1bng0Vm1lcDgwZzJCdlZ6Nm5ZeVA1cTdnR1hEbUpi?=
 =?utf-8?B?TkhUbDREQXY2QmQvRzlkL3UxMHp3K0pPL0VCMi8vOThHZEtOS3J3TXppNGoz?=
 =?utf-8?B?cmVFUERJcndCYWFtTzd3V1E1V2JKYnFRckxQd3I3Vy9GRitXUlc5dEd0WC9W?=
 =?utf-8?B?NFFMaXBubmtySkJoWlpRMmdrbW1KSEJ2T2tZZGxvWjNmc0RQa3NSZWFuWWZJ?=
 =?utf-8?B?MkZvSjVoQVhaTGtvWTZGSWIyUFcrd2Z0MFU1Z2paQ09aZ04rZHBzUFNLNXEr?=
 =?utf-8?B?TDlyTkFNUHNsb2NGZjlkWjNBakVjNXYwOXcyV081c0NyeW9YUmJXWGJBMGcw?=
 =?utf-8?B?YktMdUtSVW9vTEhPOTE3QVRRYVJLcGlSODJqM0ZUeEtuUCtqZjZPODMyOWNP?=
 =?utf-8?B?Y0Y2TXFWd0RVNFpBaWhkc0F0VUtpdVBGaHNTQVlCMlZod2ZzTHpjWjVtRHdQ?=
 =?utf-8?B?bzhjL3dzL21yK01LU1dvZ1EzMExrd1JiTHU3SEJUK0d1V1VSS2VicEI0YkZB?=
 =?utf-8?B?Y0dYN1JhZStkTW9OM2ZNQ3VJUHg2Y0NteVE1aXg0MzBlQjBxeDVRZmxSNC9q?=
 =?utf-8?B?OUpUbXVOOXBnRG43K0tHcVpLVVY0RlNBN1RpNWxBbzZWZ1IwakdLQjlqOEla?=
 =?utf-8?B?ci9IcWtObFlTYnJ6Q28rM3ZWeXdBay9qclNGSTQ1VGJyUTVDRFROMldrSEtI?=
 =?utf-8?B?N2NjbnpORncvVEZXSjZnQ1U3NmhHZmo2TXZNTktNQy9kV0t5LzRLYVVCbnpV?=
 =?utf-8?B?RnlOcStxZnM2dTFYUkR6ZEVWTVlLYlorQkI3Skl3aUFuYkdOeVcxSFpPQkNI?=
 =?utf-8?B?M0c3ZDJtUWQydzNBZERlOHdpUTBpMThES01ObDg4a2hFZ0R0QWNycHdFYTBx?=
 =?utf-8?B?OW1EdGFIS2V5dENMTEJKdHhlVEV3Z1hneGNqNUpmUUFJMFVjSHhFalVwSWZ6?=
 =?utf-8?B?WVVmc2NsQmFEQUtqYTFVd01zZ2tmeG9QR0t6am1NTXcvdWVRYXV2OVh1MTZW?=
 =?utf-8?B?K0oxTFBtdWFpS3R5ckVSdG9FN1pVTjZOWUZEVk90RStsV2g2UWkrMDZLNXB5?=
 =?utf-8?B?SzI1aUpFdFFQVTlJZGtzZGR1a2hFVzlSaGZ4Wk5HT0hQWGxJL3FQamt0T0pL?=
 =?utf-8?B?eHJwWnNPTmJqT2RIMDFiVzJ6OXEvTjVGN1VML2VZbTVkVzBoZHZqbmxzd0NX?=
 =?utf-8?B?b0pYQjduQnh1b1JRS1hkZUhHeTFYdzlUTUhIMDVhcUlGUHNsVkFheHFXQ1J6?=
 =?utf-8?B?V290Ry95YzdjQXorRjVXRG5QK1p3UzZJekNYV3NXK0RRZGdrOEtKemZOL1Bh?=
 =?utf-8?B?a0NYYU9uNlFEa2UzMzFPaWNYaExxQmV4TGIxYXpxMHBwVmlydEdyd0pTVkwr?=
 =?utf-8?B?T3dBS0hUcFIwejRzVXdBT0dDREFmOTN6NVM0aVFrZVdldmtxSXQvd1BrNXh6?=
 =?utf-8?B?aHlPQUg4dzhKanVxZ0Ywd2JSNHVwVE5qc1dnT0ptTUwwdVVuQ3ZYVXB2cEV2?=
 =?utf-8?B?bXp2Q0R2ZE5rVzFzNUJuNVJyVkh5ZHVvMWIzMkhpN1JHTEQ3RTNNTUVyZXph?=
 =?utf-8?Q?mZmjYLpbX9rcTcaWeYnXuVLsb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EF7CEA3D7679D49A42134BEF72A7DFD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 749c672f-2257-406a-4b20-08de22a434e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 11:02:59.0649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zhVnnG7VDbvXriNQO5rNGOqIr1ZKHk4MU+YiHinCScv2lZC0ZpQv60fyhZ/lv+/62NuGxu3Ob6vwrFZaFH9qug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5326
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTEzIGF0IDE2OjU0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VHVlLCBOb3YgMTEsIDIwMjUgYXQgMDY6NDI6NTVQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBUaHUsIDIwMjUtMDgtMDcgYXQgMTc6NDMgKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0K
PiA+ID4gwqBzdGF0aWMgaW50IHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KHN0cnVjdCBr
dm0gKmt2bSwNCj4gPiA+IMKgCQkJCQkgc3RydWN0IGt2bV9tbXVfcGFnZSAqcm9vdCwNCj4gPiA+
IMKgCQkJCQkgZ2ZuX3Qgc3RhcnQsIGdmbl90IGVuZCwNCj4gPiA+IC0JCQkJCSBpbnQgdGFyZ2V0
X2xldmVsLCBib29sIHNoYXJlZCkNCj4gPiA+ICsJCQkJCSBpbnQgdGFyZ2V0X2xldmVsLCBib29s
IHNoYXJlZCwNCj4gPiA+ICsJCQkJCSBib29sIG9ubHlfY3Jvc3NfYm91bmRheSwgYm9vbCAqZmx1
c2gpDQo+ID4gPiDCoHsNCj4gPiA+IMKgCXN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwID0gTlVMTDsN
Cj4gPiA+IMKgCXN0cnVjdCB0ZHBfaXRlciBpdGVyOw0KPiA+ID4gQEAgLTE1ODksNiArMTU5Niwx
MyBAQCBzdGF0aWMgaW50IHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KHN0cnVjdCBrdm0g
Kmt2bSwNCj4gPiA+IMKgCSAqIGxldmVsIGludG8gb25lIGxvd2VyIGxldmVsLiBGb3IgZXhhbXBs
ZSwgaWYgd2UgZW5jb3VudGVyIGEgMUdCIHBhZ2UNCj4gPiA+IMKgCSAqIHdlIHNwbGl0IGl0IGlu
dG8gNTEyIDJNQiBwYWdlcy4NCj4gPiA+IMKgCSAqDQo+ID4gPiArCSAqIFdoZW4gb25seV9jcm9z
c19ib3VuZGF5IGlzIHRydWUsIGp1c3Qgc3BsaXQgaHVnZSBwYWdlcyBhYm92ZSB0aGUNCj4gPiA+
ICsJICogdGFyZ2V0IGxldmVsIGludG8gb25lIGxvd2VyIGxldmVsIGlmIHRoZSBodWdlIHBhZ2Vz
IGNyb3NzIHRoZSBzdGFydA0KPiA+ID4gKwkgKiBvciBlbmQgYm91bmRhcnkuDQo+ID4gPiArCSAq
DQo+ID4gPiArCSAqIE5vIG5lZWQgdG8gdXBkYXRlIEBmbHVzaCBmb3IgIW9ubHlfY3Jvc3NfYm91
bmRheSBjYXNlcywgd2hpY2ggcmVseQ0KPiA+ID4gKwkgKiBvbiB0aGUgY2FsbGVycyB0byBkbyB0
aGUgVExCIGZsdXNoIGluIHRoZSBlbmQuDQo+ID4gPiArCSAqDQo+ID4gDQo+ID4gcy9vbmx5X2Ny
b3NzX2JvdW5kYXkvb25seV9jcm9zc19ib3VuZGFyeQ0KPiA+IA0KPiA+IEZyb20gdGRwX21tdV9z
cGxpdF9odWdlX3BhZ2VzX3Jvb3QoKSdzIHBlcnNwZWN0aXZlLCBpdCdzIHF1aXRlIG9kZCB0byBv
bmx5DQo+ID4gdXBkYXRlICdmbHVzaCcgd2hlbiAnb25seV9jcm9zc19ib3VuZGF5JyBpcyB0cnVl
LCBiZWNhdXNlDQo+ID4gJ29ubHlfY3Jvc3NfYm91bmRheScgY2FuIG9ubHkgcmVzdWx0cyBpbiBs
ZXNzIHNwbGl0dGluZy4NCj4gSSBoYXZlIHRvIHNheSBpdCdzIGEgcmVhc29uYWJsZSBwb2ludC4N
Cj4gDQo+ID4gSSB1bmRlcnN0YW5kIHRoaXMgaXMgYmVjYXVzZSBzcGxpdHRpbmcgUy1FUFQgbWFw
cGluZyBuZWVkcyBmbHVzaCAoYXQgbGVhc3QNCj4gPiBiZWZvcmUgbm9uLWJsb2NrIERFTU9URSBp
cyBpbXBsZW1lbnRlZD8pLiAgV291bGQgaXQgYmV0dGVyIHRvIGFsc28gbGV0IHRoZQ0KPiBBY3R1
YWxseSB0aGUgZmx1c2ggaXMgb25seSByZXF1aXJlZCBmb3IgIVREWCBjYXNlcy4NCj4gDQo+IEZv
ciBURFgsIGVpdGhlciB0aGUgZmx1c2ggaGFzIGJlZW4gcGVyZm9ybWVkIGludGVybmFsbHkgd2l0
aGluDQo+IHRkeF9zZXB0X3NwbGl0X3ByaXZhdGVfc3B0KCnCoA0KPiANCg0KQUZBSUNUIHRkeF9z
ZXB0X3NwbGl0X3ByaXZhdGVfc3B0KCkgb25seSBkb2VzIHRkaF9tZW1fdHJhY2soKSwgc28gS1ZN
IHNob3VsZA0Kc3RpbGwga2ljayBhbGwgdkNQVXMgb3V0IG9mIGd1ZXN0IG1vZGUgc28gb3RoZXIg
dkNQVXMgY2FuIGFjdHVhbGx5IGZsdXNoIHRoZQ0KVExCPw0KDQo+IG9yIHRoZSBmbHVzaCBpcyBu
b3QgcmVxdWlyZWQgZm9yIGZ1dHVyZSBub24tYmxvY2sNCj4gREVNT1RFLiBTbywgdGhlIGZsdXNo
IGluIEtWTSBjb3JlIG9uIHRoZSBtaXJyb3Igcm9vdCBtYXkgYmUgc2tpcHBlZCBhcyBhIGZ1dHVy
ZQ0KPiBvcHRpbWl6YXRpb24gZm9yIFREWCBpZiBuZWNlc3NhcnkuDQo+IA0KPiA+IGNhbGxlciB0
byBkZWNpZGUgd2hldGhlciBUTEIgZmx1c2ggaXMgbmVlZGVkPyAgRS5nLiwgd2UgY2FuIG1ha2UN
Cj4gPiB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNfcm9vdCgpIHJldHVybiB3aGV0aGVyIGFueSBz
cGxpdCBoYXMgYmVlbiBkb25lIG9yDQo+ID4gbm90LiAgSSB0aGluayB0aGlzIHNob3VsZCBhbHNv
IHdvcms/DQo+IERvIHlvdSBtZWFuIGp1c3Qgc2tpcHBpbmcgdGhlIGNoYW5nZXMgaW4gdGhlIGJl
bG93ICJIdW5rIDEiPw0KPiANCj4gU2luY2UgdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3Qo
KSBvcmlnaW5hbGx5IGRpZCBub3QgZG8gZmx1c2ggYnkgaXRzZWxmLA0KPiB3aGljaCByZWxpZWQg
b24gdGhlIGVuZCBjYWxsZXJzIChpLmUuLGt2bV9tbXVfc2xvdF9hcHBseV9mbGFncygpLA0KPiBr
dm1fY2xlYXJfZGlydHlfbG9nX3Byb3RlY3QoKSwgYW5kIGt2bV9nZXRfZGlydHlfbG9nX3Byb3Rl
Y3QoKSkgdG8gZG8gdGhlIGZsdXNoDQo+IHVuY29uZGl0aW9uYWxseSwgdGRwX21tdV9zcGxpdF9o
dWdlX3BhZ2VzX3Jvb3QoKSBwcmV2aW91c2x5IGRpZCBub3QgcmV0dXJuDQo+IHdoZXRoZXIgYW55
IHNwbGl0IGhhcyBiZWVuIGRvbmUgb3Igbm90Lg0KDQpSaWdodC4gIEJ1dCBtYWtpbmcgaXQgcmV0
dXJuIGFueSBzcGxpdCBoYXMgYmVlbiBkb25lIGRvZXNuJ3QgaGFybS4NCg0KPiANCj4gU28sIGlm
IHdlIHdhbnQgY2FsbGVycyBvZiBrdm1fc3BsaXRfY3Jvc3NfYm91bmRhcnlfbGVhZnMoKSB0byBk
byBmbHVzaCBvbmx5DQo+IGFmdGVyIHNwbGl0dGluZyBvY2N1cnMsIHdlIGhhdmUgdG8gcmV0dXJu
IHdoZXRoZXIgZmx1c2ggaXMgcmVxdWlyZWQuDQoNCkJ1dCBhc3N1bWluZyB3ZSBhbHdheXMgcmV0
dXJuIHdoZXRoZXIgInNwbGl0IGhhcyBiZWVuIGRvbmUiLCB0aGUgY2FsbGVyIGNhbiBhbHNvDQpl
ZmZlY3RpdmVseSBrbm93IHdoZXRoZXIgdGhlIGZsdXNoIGlzIG5lZWRlZC4NCg0KPiANCj4gVGhl
biwgaW4gdGhpcyBwYXRjaCwgc2VlbXMgb25seSB0aGUgY2hhbmdlcyBpbiAiSHVuayAxIiBjYW4g
YmUgZHJvcHBlZC4NCg0KSSBhbSB0aGlua2luZyBkcm9wcGluZyBib3RoICJIdW5rIDEiIGFuZCAi
SHVuayAzIi4gIFRoaXMgYXQgbGVhc3QgbWFrZXMNCmt2bV9zcGxpdF9jcm9zc19ib3VuZGFyeV9s
ZWFmcygpIG1vcmUgcmVhc29uYWJsZSwgSU1ITy4NCg0KU29tZXRoaW5nIGxpa2UgYmVsb3c6DQoN
CkBAIC0xNTU4LDcgKzE1NTgsOSBAQCBzdGF0aWMgaW50IHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdl
KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0DQp0ZHBfaXRlciAqaXRlciwNCiBzdGF0aWMgaW50IHRk
cF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KHN0cnVjdCBrdm0gKmt2bSwNCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGt2bV9tbXVfcGFnZSAqcm9vdCwN
CiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ2ZuX3Qgc3RhcnQsIGdm
bl90IGVuZCwNCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50IHRh
cmdldF9sZXZlbCwgYm9vbCBzaGFyZWQpDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGludCB0YXJnZXRfbGV2ZWwsIGJvb2wgc2hhcmVkLA0KKyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBib29sIG9ubHlfY3Jvc3NfYm91bmRhcnksDQorICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJvb2wgKnNwbGl0KQ0KIHsNCiAg
ICAgICAgc3RydWN0IGt2bV9tbXVfcGFnZSAqc3AgPSBOVUxMOw0KICAgICAgICBzdHJ1Y3QgdGRw
X2l0ZXIgaXRlcjsNCkBAIC0xNTg0LDYgKzE1ODYsOSBAQCBzdGF0aWMgaW50IHRkcF9tbXVfc3Bs
aXRfaHVnZV9wYWdlc19yb290KHN0cnVjdCBrdm0gKmt2bSwNCiAgICAgICAgICAgICAgICBpZiAo
IWlzX3NoYWRvd19wcmVzZW50X3B0ZShpdGVyLm9sZF9zcHRlKSB8fA0KIWlzX2xhcmdlX3B0ZShp
dGVyLm9sZF9zcHRlKSkNCiAgICAgICAgICAgICAgICAgICAgICAgIGNvbnRpbnVlOw0KIA0KKyAg
ICAgICAgICAgICAgIGlmIChvbmx5X2Nyb3NzX2JvdW5kYXJ5ICYmICFpdGVyX2Nyb3NzX2JvdW5k
YXJ5KCZpdGVyLCBzdGFydCwNCmVuZCkpDQorICAgICAgICAgICAgICAgICAgICAgICBjb250aW51
ZTsNCisNCiAgICAgICAgICAgICAgICBpZiAoIXNwKSB7DQogICAgICAgICAgICAgICAgICAgICAg
ICByY3VfcmVhZF91bmxvY2soKTsNCiANCkBAIC0xNjE4LDYgKzE2MjMsNyBAQCBzdGF0aWMgaW50
IHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KHN0cnVjdCBrdm0gKmt2bSwNCiAgICAgICAg
ICAgICAgICAgICAgICAgIGdvdG8gcmV0cnk7DQogDQogICAgICAgICAgICAgICAgc3AgPSBOVUxM
Ow0KKyAgICAgICAgICAgICAgICpzcGxpdCA9IHRydWU7DQogICAgICAgIH0NCiANCiAgICAgICAg
cmN1X3JlYWRfdW5sb2NrKCk7DQoNCg0KQnR3LCBJIGhhdmUgdG8gZm9sbG93IHVwIHRoaXMgbmV4
dCB3ZWVrLCBzaW5jZSB0b21vcnJvdyBpcyBwdWJsaWMgaG9saWRheS4NCg==

