Return-Path: <kvm+bounces-30956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FD889BEFF7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 15:19:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 004861F2274F
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 14:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 721F120110D;
	Wed,  6 Nov 2024 14:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nrDdUV7G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730051CF2A0;
	Wed,  6 Nov 2024 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730902762; cv=fail; b=isJWvt0RCB3aeogYhay4NX6APHqD25r0+KT4GPhhpI5jgb07A5i8sTjslU99R+fWF3daT2eBe4FXBuDDiCRIKwoFv1loq0n+9hj9sqp/BK37KmwZKp2X2Rm4WeqNjviSmpK/8HL77uTMOcwsW5TiS7ynI9Jpi3Juma6o5SaSX4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730902762; c=relaxed/simple;
	bh=x5QnXmiW/EK65y8N0caRrXMTYaybY7hZwlJa7ETfqhE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eUVll/sbYHYAjV70xD1YjQ3R0zmMuMbyaj3MHsn9xoT83MshspD54+a5gzHN10Wby8xup//cDkAVrOsIHr+zZhONkeVE4m++ep4EYCM2Sg4lVC6Hk5J6huEixhIP39do0ygGHRUsRDyWzSVy/xiFLzh7p7xnNBMa46mWViOn7aI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nrDdUV7G; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730902761; x=1762438761;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=x5QnXmiW/EK65y8N0caRrXMTYaybY7hZwlJa7ETfqhE=;
  b=nrDdUV7GbUIdsNJNoZwEC85OcPJVnilwyyLpyez4+Jw1xvYHPKoPa+6e
   kYrCwE8zbb2l8zCxwK+4KbY4HwPm9FDE2rRHuMJMzMwYeyFLzx4S4m3Oq
   43OYqbwivR98i4D0LToZNCzj8SKTEojBIzioWs22F0HWDVBW8d4W3g+NO
   tCt6We5L8NOqmpQgIcPX++4j6th6h2rzS/oDKD5Un6fsZyOchC1tnxvXx
   JXuTILxU7rDQmqObzqgHWcoq0Uibai0hrgRmqcvakuD9O8Mv4IfW4igFr
   8UuKNgV4EjzQau3XkYY+aNZOw2AP67a4JejtZT0eloNz0HSG1Ggiis0ec
   w==;
X-CSE-ConnectionGUID: OSjtJJe/R/CexdMAoO9pRg==
X-CSE-MsgGUID: Wxn2g8hHTcKeOlCfW/9CFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11248"; a="18325247"
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="18325247"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 06:19:20 -0800
X-CSE-ConnectionGUID: wD58m7BtTuiNfmMAuYKtdw==
X-CSE-MsgGUID: 1x/HIYdES46Vm5q+j5WKVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,263,1725346800"; 
   d="scan'208";a="107889283"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 06:19:19 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 06:19:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 06:19:19 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 06:19:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vf2+nN9PqNZuwFIoSmI9Fc62B8L3UwlJK/Tsm+Y6Io5octZi3aGDjHGqBB48LkOaY2mHuwVWLSUIR/gaIcoHXh9FiQlwAs9AstbGVBGECIEsRQqifeuC+YzwMpC7Tm32p9407cAF6q0ST2aizihNNgzJHg3hRxc7L8R78t3+Ci7mBkhDnMmmc8oEdX3Mcn2COdTp1D5i1dmLRf7Z4AfvyVEFBR8Fn2UdUuh3IBdUxsDzuVWZDocITwLxnH8A5pLSDHU+2rYKG/Pf9urYuuT77U47JmPKJ5XPh7lLK0U83Xn4MkYRg0k5qPF6wgQV/6uct+jIadseWtAPTws8sYXaeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5QnXmiW/EK65y8N0caRrXMTYaybY7hZwlJa7ETfqhE=;
 b=alDlWPSlC6CRx6KBZR4TaNNNaQfO/TVDdwSR3EVuEWMrDd0jg1sM39+LICjFSr77WwNOxMgCh534e5ZOGliYPIrLpjQaSusPQV6UL+cSt4vBlacbZZmRey/+S+x4X79Fiq8mt2MMEmAcBY+RTY3B91YC+U1ABwShoU5UE+satX7D5uTEEgqQCbZKX2JCAdHyeD78jIPdBWoftdeGp5UJVhOMO+5hhLZDzJOmKbraiP8lFtEOfHxn80jg4/ou4/5Ivye0uIIaAqbSSUv0WKXCK4MDF8f4gUs05BCascbZ1530rd2x3PucD9vNGmvij3IDm7KXklsf5wH0rcSAl3Nkng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB5767.namprd11.prod.outlook.com (2603:10b6:510:13a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 14:19:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 14:19:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kristen@linux.intel.com"
	<kristen@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbKTw/WuuSVUZ27UaZWQ3Th9tij7Kfa8kAgAFOmQCAAJhjgIAAEH0AgAACRACACPWxgA==
Date: Wed, 6 Nov 2024 14:19:10 +0000
Message-ID: <e96b2ec560c4b8461807334765a092975c67f501.camel@intel.com>
References: <cover.1730120881.git.kai.huang@intel.com>
	 <f7394b88a22e52774f23854950d45c1bfeafe42c.1730120881.git.kai.huang@intel.com>
	 <ZyJOiPQnBz31qLZ7@google.com>
	 <46ea74bcd8eebe241a143e9280c65ca33cb8dcce.camel@intel.com>
	 <ZyPnC3K9hjjKAWCM@google.com>
	 <2f56b5c7-f722-450b-9da8-1362700b77ef@intel.com>
	 <28d1c75da965c53b9162521477af5a966967125c.camel@intel.com>
In-Reply-To: <28d1c75da965c53b9162521477af5a966967125c.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB5767:EE_
x-ms-office365-filtering-correlation-id: ecfbbdb9-4131-465e-542f-08dcfe6dfbc1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dnVONklNY2NraFplK25ibkJWa1lNVkpaL1V0T0VtN20yeHZyWDdHMGM4YjBC?=
 =?utf-8?B?dHVUbkw5Z0FRYzZFTDV0WnAyb2ZzcHJENHRuQjRjcEhwUmI2T3RVY3BUWUov?=
 =?utf-8?B?eDFCa2JZT3huRFh5TTBxS1ZWN01yTVdrRTVKVmk2Wm1MUm52UUJ5TGNjZkpx?=
 =?utf-8?B?alUxYmw0bXRCaWZGcW5ObHF1ZUZmM1lVQnlMT0ZnUnFWMlk0NXMxN1ViTnJn?=
 =?utf-8?B?bWNiUVpuOEJHNjJyajZXTlo2SWJLRDFQZFRpSm5QUUcxYmpDMElRMWV6QlBI?=
 =?utf-8?B?ZElrVVk2aG9QOUtwbWtueERINXp1cnkvcG15c0FVT2h6Zm1ya3NURm5PekRQ?=
 =?utf-8?B?WkhBRWFmNWZtTzE4SFNYa3lkYjVZek9tbEJhdWlCbDZlemZiTHZqZ28rTVZV?=
 =?utf-8?B?ckJrSjZUaHdHcHRQK1M2MUVmeTBVV3ZMdm5XSDMxNmtUb0xyTVNIbUE1UDE3?=
 =?utf-8?B?SkpJYVZCN1FFbkVsVFdFd3RZOUtNVGgrTVY5b0xncTd2d3dDS1ozMEJqRGZS?=
 =?utf-8?B?TTlySUpSRGgyOWMvaG1jNkxqZThGZEVob2VQK0FUSVNNejF1ZGtVbnMzNWtO?=
 =?utf-8?B?cHo0OWpQYmxHcjhMdmE4RHUxUm1pYkgzZndUR3ZQZ3BibEMybkt2L3M3ODZU?=
 =?utf-8?B?NDgzSDFhRGNidlUzTmt6Z0tRU1lvaStJVDhacUNpaWl4cW95MDN4NkFOK3Vx?=
 =?utf-8?B?b2JPNnFYRTQ4cmNGcXQ1Tm96RVh5Vm1ua0orY3ZWb3JhbStUY0t4N1AvK2Ix?=
 =?utf-8?B?MXgzV29KSDF5YjFMT2NZaGpHMEJZbWRHQ3ZsN2g4OFgwMmthNWZrUkpBWEtG?=
 =?utf-8?B?OXp1ck1nMWlDK0JlTFlWR1FvaXdtRnFCRHNUSEpaVm92dEFDWWJiOUY3Z3V4?=
 =?utf-8?B?RDZSYjh0bEN0SDZjdlRmaWo1bmgwaURDcVZZUy84OG9zRjR1RWl4SkxSRE95?=
 =?utf-8?B?OGhBUWVSN3UycXdMQUlmeUFKaUhnQnhjSGFJRlRDSGk0eTZDQ2RZbndFZktx?=
 =?utf-8?B?SEdEOENPaVd3Tm5BRnExNHNmZTUwY0o2cktaajYwTDJ1K0tmeGViaXIvZ3BZ?=
 =?utf-8?B?MW9qOGVic210QjByRDdJTWN5ZXpwSFMyMnJ5R1hRaE9iRVU0ankvRkFhb0gw?=
 =?utf-8?B?NDQvVGprMklTSS94WXJqTW1ZSmt2dmhOdlVhZW9Ta1pVdFN6alQ5b1lrY0Zq?=
 =?utf-8?B?RFBDUjJKMnAwN3F0UUhsMFhiZytzWHhWZDB5d1ROMnprcVNNYS92cjY3cFF1?=
 =?utf-8?B?OEI5c2hwVEdIeWZqcXZhMW12V0Z6TThGTGRuU2dUdlZVaVU4VWtIV2wvRzFS?=
 =?utf-8?B?U1ozcE9BaExBbXozRy82YnQ3a1JlalgzbE13dE1ZWklWNTlYc2ZyUHdNdFZD?=
 =?utf-8?B?QU15ZkVxY085YnBsdlVhc3JTOXlqTHVZUVM1ci94akk1Y0hrMVhIVVdrRnVR?=
 =?utf-8?B?d3p4eTVUMWgrK1RFZTFIamVNYlpyNVVmOGhoV0NBRHdUc1F5R2E5UVY1bVdw?=
 =?utf-8?B?dCtObTJnbFlaNmU0ZjZSd0Iva2pJdk9oV2lCRFlMcDZacjBsMUgxZ1J0N0w3?=
 =?utf-8?B?WnNhVkZNcUJZUU9wL0xVdWJ6TDRDNVBBZWxHZ0g0R0daOU9UWHNIU0R3VjIx?=
 =?utf-8?B?TVZHck9mdDJOQytSR3B0dFNxT2Z2bTlnVzhjaDBpZ0RVeFl0dmM1bGJDQ28x?=
 =?utf-8?B?Y05FK2hzNHgrODhFRStVYyt4eXdKVGdSejc3Z3NSSkQ2eUNMRTA1QkxWZWx5?=
 =?utf-8?B?TkRKbnRqNVh6RnFyWEJJenZJa1doeDFSMVBMU2JiOWhGM2dJbDZ6UHcvajM4?=
 =?utf-8?Q?Y2VUyD/bC8Ik2WryG5VJEpumS2auMfTGNj8m8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MlZsWlp1YzE1RVY5Q3p4ZUQrMFVkdFRlWEdtOVdRdlprV3JiSUIwNzFpdU1x?=
 =?utf-8?B?WllIWndDb2Uwa0NoTUZKZWZoNmdaRXZaRDdnYU5VUjRMT1NYb2MrVTExSGpJ?=
 =?utf-8?B?OWFQNmxOSGQ2MnIyNHdxZWFyMytSMFBRTytlZ2pzQlpVRWVTSzYxNGk5SXFK?=
 =?utf-8?B?MFg1VERmY2lXc1BJeWpxWnNFWUUxQUZldEhNYURhc3krT2Nob1RnaFZHU28w?=
 =?utf-8?B?elZZV1R5TWJZWU00Nmp3dTc4ZEl0cEc3WFRyNWROcmlPMHh4bzRoNTUwL3Nz?=
 =?utf-8?B?c01rcFNJcDFJSFpRUlhyeWFaMFhBeEZYbm1PMHVhcWcyZmxQRmRXQmNzQlBi?=
 =?utf-8?B?TXRWTitRN25CWWVHdml4SXdYbEw2ZlNLdURKUGtLRWJRT1A1ZmFhcStpTytn?=
 =?utf-8?B?TkhNQ2lnclBkTU5WMHNyRjBIb1h2K3YvNkFTVVd0OWVtMExZUHdqVHdwUVBz?=
 =?utf-8?B?V2RaSHc5bW1rSG41TG54M1c2aFU5K0lodE15WkNJSXdGeWl5MEUwdDg2TWdZ?=
 =?utf-8?B?L2RDQ3FOR1prczE5dE1ORU43T01BTGhYSjljU3hBUVNSdjk2Ulc5Z1dheUw3?=
 =?utf-8?B?SzJSUmRkTVRtZjgxbnpSQzFPelRmUW1tNmMwWTNiL0ZKWlVqZkJ6ZVpZK0xD?=
 =?utf-8?B?SFNkanVMV1dCMU1FNTMvbXZNVTJTSGJiZXRZeEdSb09ObTZ6Z1ZsSXJqU0lv?=
 =?utf-8?B?WDVVVTJMcU5ObVdsUk9nNEdrajFYc2ZycFY3cDNPNEs2MS90cHhzWnpuQWxq?=
 =?utf-8?B?UENIditJSHhiWHhma3RrajYrTGEySm9FT2NZYThnYUNJbSt2alhNamRQM1lD?=
 =?utf-8?B?MlFYZ2w0WG9OVHQ1OFMrWk5sQS9sb0V0Q3BJTGIvY1ErdW05S2Jka0RPQ3lZ?=
 =?utf-8?B?STNvQk5sUGdVVEVIZlBxaU9NUXRPcmdsNEdGL0dEQ1Y2S1hSaVhVSmE3VWEr?=
 =?utf-8?B?Nzd3cjB2d1poT25TK1h4eUUxQWZaMTNQc203Ym16a01JdTd2ODJhZUp0WVdO?=
 =?utf-8?B?azhMKy9iblBtUFVYR1RzM3J1OG1jWU5vUzVkRGFaNjNTOVBLWXovWStrK2I0?=
 =?utf-8?B?Qko4NktFUmdsb3owcFBGb21pRDd1U3NFcnE2WHBXVURpUTRyTUNMR0k2Q3Bi?=
 =?utf-8?B?Q29qeFZueVl1VkRwdWRlNGpuZ0FuVmhDOW43VlFXaEp6R1MwWVZhVFBkMC9z?=
 =?utf-8?B?eEg5SUE3K05YM3J5S2pIV3AzRmdOQ2Zra040b1ZsQ1JYeTNnMXlXR1Z1SnlF?=
 =?utf-8?B?QTRML0ZlSnVZQURTRnlQVTVlZGhIUXhYWWVzcklMMzl6RlRSYUNoSFI5eU9u?=
 =?utf-8?B?MGpBaEhIdG01ZnhYTVlYZ0N6TlNTMHlYc1VLMjNNYlB6WHYvVGl2NURHMHBq?=
 =?utf-8?B?RW55aWxsV25kMldNenRZYXdMT1FxNmVJbkpHU0RKMGVLUVRYempXQ08xbFE1?=
 =?utf-8?B?eWk1dDBWQ3czdHVEaGlRWnVvWmNGQTdGZHJxb2t1RHBiY0Y5cEQrNW1haWkr?=
 =?utf-8?B?V3R3QUl1c2Z2MGQwblphM2JvMXVHdXY0Qm03eEFqcGZLdjhXRnVBNlhad09n?=
 =?utf-8?B?NktYM3NUVndjdHhHK0k4dUIyR3hPenlCM0JFVXdXZk9MN0tvZDhBSHhFZlJi?=
 =?utf-8?B?ZjdSTlBocUkyZFRFbDk4MzRCTDVKU09rdVp0aHpwWkFFSHRxbUxBbkl4Y0Vj?=
 =?utf-8?B?cEpqTCtSY3BWbzl6T3NZY0pUTmpYYVdqZjhMVHpibHJha1BaWENBblNEYzRD?=
 =?utf-8?B?eG9RZTc3bTF1cS8xZmVjU2lqczBYZTVhWDM2Q08xMjFwaUtJSFR2dXhnU3dD?=
 =?utf-8?B?dzR3aFN0bXZLU0R1Q1lZWEt6L0FkT3k2MUIrNm9kRHRhZDNKUFB6SDhEeDZt?=
 =?utf-8?B?RW5XeUI5QmZHOXRsZ0VMWDlEdXRiS1I2TTBNamlONUZoM2IrSGZ1NElzSlQx?=
 =?utf-8?B?b0lWZzFkUUFkVnZqem1CT0dwSHBiWU1PWnFaQitaeWN0ZEl1T2s3bWxmMFFE?=
 =?utf-8?B?aEJ0ejdIeTlvczltakUrcUlWSlp1UHFuTkgzVS9SNlgvN1FzaWhuSDJaU1ZL?=
 =?utf-8?B?VGNubnVQKzlQSWM2TWJ3dXVpSk1tYkxzY1hlVzY1R0VUT01YWERFS0d2K255?=
 =?utf-8?B?VTROb3ZLN2tXV3p5TnlOQjgybm41N251WlBpbHduNmdoQkJyNFdWaDYzN2ts?=
 =?utf-8?B?ZlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <020551A565AE4743ACB2D11B817CB34A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecfbbdb9-4131-465e-542f-08dcfe6dfbc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 14:19:10.8335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jdjc/56v+i4JAWVZii1H/P6Kw9d/ziIRn6i1s56WzTbxKm6b4DOnPg9G+obT/bzHAZK/aS0U8HzWhwS1KDulgHTdl6uU9u13qo3ahRY/8Gk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5767
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTEwLTMxIGF0IDE0OjI5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gPiBUaGFua3MgZm9yIHRoZSBjb21tZW50cyENCj4gDQo+IFdlIGhhZCB0YWxrZWQgYWJvdXQg
eW91IHRha2luZyB0aGlzIHNlcmllcyBvdmVyLCB1bmRlciB0aGUgYXNzdW1wdGlvbiB0aGF0IGl0
DQo+IHdhcyBtb3N0bHkgc2V0dGxlZC4gV291bGQgaXQgaGVscCBmb3IgdXMgdG8gc3BpbiBhbm90
aGVyIGJyYW5jaCB3aXRoIHRoZXNlDQo+IGNoYW5nZXM/DQoNCkRpc2N1c3Npbmcgb24gdGhlIFBV
Q0sgY2FsbCwgUGFvbG8gc2FpZCB0byBzZW5kIGFub3RoZXIgdmVyc2lvbiB3aXRoIHRoZSBjaGFu
Z2VzDQppbmNvcnBvcmF0ZWQuDQo=

