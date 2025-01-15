Return-Path: <kvm+bounces-35599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 481F3A12BA0
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 20:16:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A8553A8542
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1F261D6DC5;
	Wed, 15 Jan 2025 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A0BDGl4N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB731DAC8E;
	Wed, 15 Jan 2025 19:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736968496; cv=fail; b=UHejAXLF6GSF7OUxguWkf1f58/LeUD9482/usa8xCkujQscnrl9PUjHkwkUFmOE986zxNCXkDQAZYXXeTLmIJOQlhQxVgWIn2cKRxgqVye9PqEbKKoawJ6Rn6GMiQl6+6R141eccW1wemT+rnspaqmRkNTNygHZhIjrEJMeJ47k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736968496; c=relaxed/simple;
	bh=m0F/49ptHi3M/E9KtFfaqHSR/fmnaKt2l32O3stNFms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n0WAMUeZwAxwfSIQNdY5xWBUUiMJHAbfN7VpPEq4fw8pB9l4F6zYhzG2r4z4+/DXIKXXIs+rfzFGfB+K0IR3GoPMjQJfx0O4tbZ1Tx8AufZBt4waACY7BKFNjc0Tjzl+yGYlAH0EczZ6cyEtpLY+LrvlEvLzGfWKqxbkdge0VNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A0BDGl4N; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736968495; x=1768504495;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=m0F/49ptHi3M/E9KtFfaqHSR/fmnaKt2l32O3stNFms=;
  b=A0BDGl4N2Smz+wT3MnBfJ3oy00VHtQrRSaLqNuVCw02Tk7TruDn6FGdD
   u6NQvtMe+jsTKGGEdmrB7c1tSht022MrhYShzn8dyXuodO98EE9elF6LQ
   BLJ0Pta3vYC4aNa7WUgM0LILdqm4yebYUQb9msVj19gY6xwrP16Uyiqlc
   TrqrQbk4CP1PyKJgx6OYN61Of1ttV97PlP0mLqGmrn60HZ6jEkxqXgDYg
   IruzVc8fUl1CQY2uLfIQrUor4HzJ9fc7B/a5MxWbUhBmMxF+aHdZshEpa
   f7OnzgVi+J2hePhwsB8dV+AEIir7ebluf8gJnr7EvUzQEYBUA7jAPsvDz
   g==;
X-CSE-ConnectionGUID: +nD9YOtBTbOn5kELVW5YVA==
X-CSE-MsgGUID: R7h9aGoYRcaG5UqveLr0iA==
X-IronPort-AV: E=McAfee;i="6700,10204,11316"; a="36599236"
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="36599236"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 11:14:54 -0800
X-CSE-ConnectionGUID: itHztF0nRcS01pAPV6xezA==
X-CSE-MsgGUID: i4ku3xjVRFuFIp8uWpOhCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,207,1732608000"; 
   d="scan'208";a="105410512"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 11:14:53 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 11:14:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 11:14:52 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 11:14:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qzl1hd1HqC9k1tpY3e8zbdN6Bj1ESyPOMuhlw+TWaNceGuZuUIEhIQ0wyqJ/wyiGHFLhu251OdGeh1SQH8N6b4jwXnYkJlWdOws4+n+TpvV0z+R/ZkXCOSJLcHqMbiC85FdEOgsMQ29MDFnikAgLbWDOmujXPihRy3Wu0+k1tBFiDiEM7OsizJIezxdn7V4zLr77UG0YW68jIG3SA5IcgbJ1TsnakMPNKq5E8tJBntYJe0n/EAtpq0vou+zBod6X4dSZ+Dd+dxbX541paISiXzKlfE7vI1zxoeUkGimDTP0jZXhpsm4Yr61tqj8H51LYBqfzJ8fLxOjiI1MNP7p1Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0F/49ptHi3M/E9KtFfaqHSR/fmnaKt2l32O3stNFms=;
 b=lyMHQe5VcDTtdGFl1Xrl4MAysC8F9IHdsmygqEfatKC0YnM+L35AhNC+prI4JFnVoYwkLoLs7hkG+cZJ3m779JpVgypqZmumG/VNK62glJD8m860fDwBetzYvv2GLu7nNzRx+E7Wm4/uYzN4V+/8jqi9gZH60Bl8FKU8LKwFLC1fxgRcSczwOxsYQfI+vCFYtCmp7HDp588RNb0dGAoKGX9HR0SderdBQNjU+j0hRfv95cQRL3b5BZn92UZDWcESwMB02cRRibqTBUOQJ6CyOC9/TLJnKGJcaqQnOoQZNnUEetK+fSyrgfwwB2A+NNFEdnEULMMIRAL24Lw9A0goMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by DS0PR11MB8114.namprd11.prod.outlook.com (2603:10b6:8:129::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 19:14:50 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%5]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 19:14:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3 00/14] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Thread-Topic: [PATCH v3 00/14] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Thread-Index: AQHbZ2fdmbRdWBZ26kOkd1tFP4ljTrMYNK6A
Date: Wed, 15 Jan 2025 19:14:50 +0000
Message-ID: <00ff9b4e7ff1a67ca43d4ecd7e46aa59d259733f.camel@intel.com>
References: <20250115160912.617654-1-pbonzini@redhat.com>
In-Reply-To: <20250115160912.617654-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|DS0PR11MB8114:EE_
x-ms-office365-filtering-correlation-id: 5711b541-ac6c-491a-d9e0-08dd3598e23f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bnFsSFVLUTQ0NklvQlZMczU5VUIvU0RxVXZKWmxuK1U2WnJKcGJXOHZ3V0sw?=
 =?utf-8?B?R2hpSG1sNTlDMzZZVkFNT0hRUEVUZ3hGR2tTaW5YZjZZSUFKTlBSa2lxN0RS?=
 =?utf-8?B?RTBuelBPL0dvL3VVVDhDQTg5VklXQlNhMGxiemxDcWx4ZUpqOWI2cVpWTHIr?=
 =?utf-8?B?OXU4MmRBZ0VHMWVHMEd3QzVWVTAwTVpjODNRYUkwbEl4M1ZvN1VpNlROTzlJ?=
 =?utf-8?B?MDJ0YS9XMFJkVzJLbDdHQk9JSzBUcFFYbkttMmtPM0xZYXNSOUtieitpTnJP?=
 =?utf-8?B?NFFiSzZCaVFiN3UxcWZFbjlNOFZaZ1JDcDhCSmh3bGNrdy9EWkEwSU1PbWQv?=
 =?utf-8?B?eXY4bXZDVVArenl6ampsSEd0bkI3d0JqNFNNYm1EcHVQR2p5ajJ1ODE2Uzhx?=
 =?utf-8?B?dTlnTzZjZHJ5VEFIcjBWQmRtamVVZG5kM0FvRFBIdHVzVVhHcXVmMnZHaE5K?=
 =?utf-8?B?QnNZQ2N3M1FOc3FyampCTHdlM3NTcVpqbHByKzJyVlFvOUZJd3dOSVc1TWdw?=
 =?utf-8?B?VTVmRThsRHM2WkJDTEQxYjFndlBiMC8rY00vVFVNV1NieENvTXk0TytaWkVO?=
 =?utf-8?B?Y2NCcHRTbS96czJWLzNUeUEzS0gwQlQwK08vdEFnZ1luWXVLSjNhcEQ2MGl2?=
 =?utf-8?B?VDNQcXQrWWVVVkxJMHIyOWt1Y2ZJbnBuMk8rVUxSa0NXTU4xZTJCQjQ4Mlhx?=
 =?utf-8?B?cWxqYmRISWFqVmM0cG5KbWEwOGxScHNsM1U3VkFDZEdPTDVXMVNKZmROQUp3?=
 =?utf-8?B?Qmt2ZjRhUnU5TVN3SjQwSTJzWnVtN2dzWHRpRWZWYmEzZ0g2Qi9OTlpBaWRH?=
 =?utf-8?B?U1B6UHF2Vnk0UGpLNU1aRjNxRCsrK01ER09wdlJkMEsvRlB4ODFTNXlkSDhD?=
 =?utf-8?B?dSs5Um1zSHRvd2NFeEhWdUsyanY0dUJZT1JlR2RnbjdTc0VIR0F2ZHJDNU1S?=
 =?utf-8?B?SEJrSXVROWRuV0JqaXltZk5tSStWTXZzT2kzZ2ZzU2QxT0doRmFDZEl3dWN4?=
 =?utf-8?B?ZFhQdjZRNWhWVXBhVVhtODB3c05BWUQ3YjNNdXE4NVN4bzdkWkpYaEFaMVZr?=
 =?utf-8?B?Unh5eHRQY1lsSVpNV285SXFEeVJlNVlyUEN6OHF5RHQ5RkRvVEN1aDdJVkZU?=
 =?utf-8?B?U0pBWnp2Z2RuZVVZV1JZUUw1TXVMVjR2bUUwUE85bzFUWUR2ZFNMNklZVm5D?=
 =?utf-8?B?M0QvUk5vN09sV25MQTl6SHBiVW55cWhKV2huSC9WNWZRWUkvVkthTnM1cHZQ?=
 =?utf-8?B?Ym1IUUs2ZlNqQlMva2hWak1Xa1hwbW1GcDFjMENKTzlQRDZFYmJBMkRCY0Q1?=
 =?utf-8?B?MGJnZWszR1V5MHpMN0RFcER5YnorSXl6NW5Ua2lSSW02RlR5c3k5aTFQVEty?=
 =?utf-8?B?ekY4TnhSSXQxTERBMlFGRDRweHcyeWgzVGJWMVdHT0ltdjJwVndlRzE2cmVX?=
 =?utf-8?B?UkZRVjF4T0tNYzhXV0tUb2dpR0trNStROTRMbzUwejdyNWV5b1ZCVGFUUU5p?=
 =?utf-8?B?ZG9FaEtNUWFZdlB0M1VQL2Z2U1d5dmN2V01Ody82Q0taYUg0djBOZUg5Zm96?=
 =?utf-8?B?T1dqRHRVNmJEZm90VHBmSXBYZ2dvNVVOcFRHd09zUDQxQStJTjFFSkFWT0Vq?=
 =?utf-8?B?S1dMQ0oyZnIyM01sd2MwMDM4dk5WdzZIWUI0Z3A2ZVo5bk0yZk5FbHEzV1E4?=
 =?utf-8?B?RmJPd1p0OWRZNHdHbDJSUE9xcWRUWk43cnJDUkZqaG15ajZ6d09sbmJXTU5G?=
 =?utf-8?B?MThEWnFZTFZVanNyU1EyRm92YTZnN1lRWG9HRWY4VUt5VmZjSUR6TTNVVUcv?=
 =?utf-8?B?cTlSaGxoN2wrUjI3NXhaTHVzT1ZoR1c3M2lVNHRsd205ZVF0eC80THZGUDlu?=
 =?utf-8?B?cTl2RE1QQmhYWFBhVk9OQ2FtbHR1WWdESFZqUVdqc013RHE4Tlg5Y3J3VUpZ?=
 =?utf-8?B?amRaUTJBeTFXa005dnBkR2NCRExQN1JJeDNueHBTeE1Cbk9MT3ZIblhlb3M4?=
 =?utf-8?B?akMyYTk0cUFBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGNOdVlmc0JpL3JSR2pJV3lEcEVqazlBejZITGxqMHRrOGJjNWkrcGpSNTQy?=
 =?utf-8?B?dHVSODdEZjUyMzdNemVWWTZrMU92VDdyVzFUd0dYbFRPRmhmd0J2ZmV3YWY1?=
 =?utf-8?B?ZUlrVjd4V051aVBFSzNWSEQxM3htSlVueTBBbC9SNWVpU21pQjIvRkNMejJP?=
 =?utf-8?B?Z2ppVTdmUDJEQkIrY3VmMHhTekJoMCtETUdRY3U3aXQyN3pkN1M5YVdPU002?=
 =?utf-8?B?WFlPM0wzMFZQUVdBN3NoWmNoZmVNWVl3RGRSRFgzcThQU09ZRlJ6aXJjTnRh?=
 =?utf-8?B?KzgyS2RRQm1Fdy81LytkaDB3VXFTTGVUM2hkSk9vRWd2bVpMWjF2WEdXTWhQ?=
 =?utf-8?B?RFJobjE3eU5BKzkzZTZXUHF0N3c0OWFtclM4dWVWU1FKcWphakZTdzV5OURx?=
 =?utf-8?B?aFVYZkh2NCsxaURibHlxYmgwaTlIcGhyOXY4UnhuaXBpd1A0VVdvb0VPeDNE?=
 =?utf-8?B?ejJoR1dwd1VzOTFOdFNPRW9JM0xTTTdET2o1WDJNN0ptRlY3UVZyUlk1dUZF?=
 =?utf-8?B?ZEQ4NW5QYnROMEM0eklYeHo0d0JtSmdEcEFOdVNMeHM0VlZHcjJUWENSQzZC?=
 =?utf-8?B?RzF1WnVURktrM1dyNUtuVUUxUXZuYUxxVjJzbSthYk8ySkJxemxvcGgvTThn?=
 =?utf-8?B?V3ZMSzU0cjhOdVJ0R3M5UVhOdHVkSkxHZWNtcEZ1TEFzMzJ6bUkwWWVBdjAy?=
 =?utf-8?B?MFVxWEhicllVWWxLdERaaUtUWjNDWmNISEtYV0JwdTlmSldXVjUvd2RXS2la?=
 =?utf-8?B?VUtFV2xPbU5vdnQ1R3RXYnhZWWJjNGdyL1NQZUNPTEMwcWFvZzVKWjM2RDFi?=
 =?utf-8?B?UkROWGRYOXRlSVdWUFVLcEpicCtBV1FjMGVFU2xxQ1JoQWZkdm94RGJUZ1lI?=
 =?utf-8?B?ZVVSbGhkY0RodGZTWHUxNmtweDN6ZGl2YVo3RTVnMk0vM0RLR2t0WU16YTE3?=
 =?utf-8?B?QWgrMW93b2tvaE5URFdpY21GV04walY5Y21ZV2dQZmdLanIwZjFpZ2RaeTBy?=
 =?utf-8?B?c3VQRTlJZEkzWW5XNTJZVjlDbzRjY0JxVlkyVGc2MlJaMU5LMjd4NzRxUk5I?=
 =?utf-8?B?NmdpVjJJYUdNTFQvcnN6dlVpTDlTdHpMQXo5bU1BZ1BLdVJUZE4vK3h3Nytt?=
 =?utf-8?B?TGJ4eWpvMXZwcDB5RGc4OGpMc1VQSmMrMDNtc2J0enIxTjcxTCtzNi9laUs3?=
 =?utf-8?B?R3RiR3NMRWlQQzVKam5FVVZQS2pJcHZGSmIwUk9WbUVNSUw4R1B4eHZ2bjYr?=
 =?utf-8?B?NnhRZkZ4RkR5NjU0bklhaUhMNjNsVUl2ZVlmQkVjZjlpcDZjc3RXWk5IQXZ1?=
 =?utf-8?B?UU5iRWgyc3dYVDdSQzZqQ2hudGdhUzVLNHRLUkdHbXpNME9iU3RHa0RyNndE?=
 =?utf-8?B?OUdJUXF1aW9hYU1HQUZEWi9LRHdDRDRvdFZ0TE95R3dkSkM2cnFKeHYzUEFP?=
 =?utf-8?B?cmg0QVJwUDA4NllZOEtsa3pFZm5nWlB6QnREQTNKRnBadDRhOG9PWTBqTWdj?=
 =?utf-8?B?a2F5TDVCWnhxcHdHaWllVi9pTk4wR3IzdTB1d2NZVEFuOTBxUVRuV05IV1Vl?=
 =?utf-8?B?QWUxNldIUHF2NDUzbURQVFgxQjFWYVV1Mk1zdkRZMHVlbG9JMGNmaVcvNkZH?=
 =?utf-8?B?RDUrRXgyTi9FdTc2eG4wOUVqNWk1aXQyZFhFMk1jYXFCd2dKdDhiYkQ2d1Z1?=
 =?utf-8?B?T2c3S2lnblQ0SDJ0QkZoY3NPNGVtUVZHN2N0aVg3R3NWU0l1dGdzQThXZkNJ?=
 =?utf-8?B?eXlIVVFxdEVLb3F5MFdHV1NRNzNhYWJ2cmQ5bDE1YUVrNEVXeC9mVzNNc2Iw?=
 =?utf-8?B?T0NvTlRkQlkvUTdYc09WNDc2MWpTM04xdXY2OWk2WDNGdDlaZ0drUlhzZmRv?=
 =?utf-8?B?U3BJc0M3V3JxMy90ckFlQlE1Rzl0QmlBWnpJMU1raVhpREFXcDhNOXJzcWo2?=
 =?utf-8?B?SjgrWGhvOGprUVJRbTVpeXZuS2dEVllBeVk5K0wrVlBRYmU3SnYzWmZpbUtJ?=
 =?utf-8?B?VnF2bXdoNmZ2aUdRS1N3WjZOSW12eHZJWDBPK1NPeDJKdE9mZnpPZVQvbktC?=
 =?utf-8?B?YkZxMHhFSDdHcFJvS25hQ3lpcUZFaVJ6ZkpJUmJDVjcrZXFldFNaOGoxdW5X?=
 =?utf-8?B?SnVMQTNQbzhkQlRZam5uYkh0SnZtK2huSUE4eEJDL09ESGp3WGJoMUMwcVRz?=
 =?utf-8?B?Y1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23F0736072B3644E88424CC2A0C394DC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5711b541-ac6c-491a-d9e0-08dd3598e23f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 19:14:50.3551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FUNNuI+JjcDnetJ1i+jERFyfOwsBaeXI1P2m/sr3lv0ozA2wmvWAfYZyWtVIEUogdGdT2E7Pf25eS45kj8V7hSe6jFLKZTsK/3Ic32qj3gE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8114
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTE1IGF0IDExOjA4IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBIaSwNCj4gDQo+IFRoaXMgaXMgdGhlIGZpbmFsLWlzaCB2ZXJzaW9uIG9mIHRoZSAiU0VBTUNB
TEwgV3JhcHBlcnMiIFJGQ1swXSwgd2l0aA0KPiBhbGwgdGhlIHdyYXBwZXJzIGV4dHJhY3RlZCBv
dXQgb2YgdGhlIGNvcnJlc3BvbmRpbmcgVERYIHBhdGNoZXMuDQo+IFRoaXMgdmVyc2lvbiBvZiB0
aGUgc2VyaWVzIHVzZXMgdTY0IG9ubHkgZm9yIGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3Nlcw0KPiBh
bmQgZXJyb3IgcmV0dXJuIHZhbHVlczoNCj4gDQo+ICogdTY0IHBmbiBpcyByZXBsYWNlZCBieSBz
dHJ1Y3QgcGFnZQ0KPiANCj4gKiB1NjQgbGV2ZWwgaXMgcmVwbGFjZWQgYnkgaW50IGxldmVsDQo+
IA0KPiAqIHU2NCB0ZHIgYW5kIHU2NCB0ZHZwciBhcmUgcmVwbGFjZWQgYnkgc3RydWN0cyB0aGF0
IGNvbnRhaW4gc3RydWN0IHBhZ2UNCj4gwqAgZm9yIHRoZW0gYXMgd2VsbCBhcyBmb3IgdGRjcyBh
bmQgdGRjeC4NCj4gDQo+IEEgY291cGxlIGZ1bmN0aW9ucyBhcmUgYWxzbyBtb3ZlZCBvdmVyIGZy
b20gS1ZNIHRvIHRkeC5oDQo+IA0KPiBzdGF0aWMgaW5saW5lIHU2NCBta19rZXllZF9wYWRkcih1
MTYgaGtpZCwgc3RydWN0IHBhZ2UgKnBhZ2UpDQo+IHN0YXRpYyBpbmxpbmUgaW50IHBnX2xldmVs
X3RvX3RkeF9zZXB0X2xldmVsKGVudW0gcGdfbGV2ZWwgbGV2ZWwpDQo+IA0KPiBUaGUgcGxhbiBp
cyB0byBpbmNsdWRlIHRoZXNlIGluIGt2bS5naXQgdG9nZXRoZXIgd2l0aCB0aGVpciBmaXJzdCB1
c2VyLg0KDQpJdCBsb29rcyBsaWtlIHlvdSBtaXNzZWQgdGhlc2UgYnVpbGQgaXNzdWVzIGFuZCBi
dWdzIGZyb20gdjI6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vNjM0NTI3MjUwNmM1YmM3
MDdmMTFiNmY1NGM0YmQ1MDE1Y2VkY2Q5NS5jYW1lbEBpbnRlbC5jb20vDQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vM2Y4ZmE4ZmM5OGI1MzJhZGQxZmYxNDAzNGMwYzg2OGNkYmVjYTdmOC5j
YW1lbEBpbnRlbC5jb20vDQoNCg==

