Return-Path: <kvm+bounces-70592-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IKsuFfK3iWnoBAUAu9opvQ
	(envelope-from <kvm+bounces-70592-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:33:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C6EB210E2DE
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 11:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA2A73016D00
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 10:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55033367F5C;
	Mon,  9 Feb 2026 10:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TNLIeHBo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8C01A294;
	Mon,  9 Feb 2026 10:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770633197; cv=fail; b=OQ6kejR5c1BrvkFot8gByoEtc+Tlu5p4zcPspLMLoz8KzSdIrHTaZZ9yL/WoVgO2pYpHjDH7X0oXOJjNra8fDRcbry4RcFIMBCFcC97BLPwza6C5/KZrERQYxi9w2Em0yuz3BAlh5Bb+WMrShTq3Q62B+3ws0xCdIeLBDL8P5hU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770633197; c=relaxed/simple;
	bh=DkOJp6mkaeX6Bz0Vt3QBscBkBtno3b1CHVR+uhJegWc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RakmI+bBxF12bs3YKTy26DdwInA3phY/Lyh4ABvzxunDpe/Y/oR+2v2+taYf4dz6ywTlPPVUQb+HxaWbCxwsQCuHQs5n9HdFurYshXoNdd5Ys7CRya2DMTymLEoJusEsoEm8m7pOJeUJlPqaIMhpK3uURLitJ0xaOtS8+/g3r0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TNLIeHBo; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770633197; x=1802169197;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DkOJp6mkaeX6Bz0Vt3QBscBkBtno3b1CHVR+uhJegWc=;
  b=TNLIeHBo7WuyIMK0MrEDqqk7Ccm2lVfVhIABT+O/4FtXAVJirbQShYEu
   6aWooJAdRdowZkGRE2Axj4rYCZX9UazZKa/aALqY22sHyU4UdeP6EDkJ/
   v0GuXiCLcMk/jiohdv8omTsP9cpkkSoiKtK92QO4Qb5ZO3pL6Kg7gaZg8
   /5yxvGmCxD5CE1UBtNY/0e9spG2SAZeThALxtz7gru9bNYew4Vcopvyj+
   XmVt6LPo/EgNeCJH7o0Pj7g1vUH0ojuEpAinxmo6vc8AfeY5Ra5rxYw+u
   6TwjzNIEB7TW174PWJs1Ww+sML8ySLCISgUrcBeh+dWG3U9KPkPNME4JF
   g==;
X-CSE-ConnectionGUID: kiUjh63JTVGDSQYnZpdWnw==
X-CSE-MsgGUID: rnVoybywRVWbSS2RvYGaoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11695"; a="71634063"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="71634063"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 02:33:16 -0800
X-CSE-ConnectionGUID: TqFW7nwQTRKjSflTUc5sxg==
X-CSE-MsgGUID: KTjldWA5QWa16x+g+INBXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="215720808"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 02:33:17 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 02:33:15 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 9 Feb 2026 02:33:15 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.55) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 9 Feb 2026 02:33:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RhhQKE5PUma27rZvW5YHf7SAD4FSSLlZtyJsfIJB1fdjbgF17+PXflaoWqjDCWHFJaVYwWj8dKPkUwcg2+3D4VyZWkHwtvxJzFqEHALNKG0SjFkQKeQhccMppY7w2XGlRLycsHrNGwXZQvm1SlhPg0EitkEF9I2030FAuXIfhWzRlroCEPqQWCEFykvc4WzqMgtMszTI3ddDlDYPOaY9c53leGBFZJiXELbP+Q7ELskqdX7wz66cN10c1XvYWIA+eJukBxLr3VvrCpLRPPOGxg48J8etqcAhVTrMIm/2JEfYPfJYiUjsWFu5VrJpDT1/36WqTiokwsTWbDFzva4Obw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DkOJp6mkaeX6Bz0Vt3QBscBkBtno3b1CHVR+uhJegWc=;
 b=BJ59URT5iXrrGMedtp6tt/dowCKkjy5iadK6UM8IewYo+YbQyxI0ppidYLCqmyQy6xvId+7WGK7le1FTZSy0tCFfAooteJK6CUExolAFKjeT82TtbuLk+m/6aFIMSmUtycrHZGK6zBl2BOg9Gjqoyye2ZjkotlOYN7EsfaO5lSzzLzaB0WZG0VuJuUoGTsoyHQ1lOz6EinpJ8DIV1Ynb3hODlcKfEFS9Urc4JdHueRbaxvXRM/EEyWrUN2C/fHY5RSCpGJWwN5SMGm5TgzPijINLNxJ1E5rYXt6usZAOO9DUmtM7hph5rZzhqe5IVKT6ejdNYq3fQIRsI+cPSHXAEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by PH0PR11MB5829.namprd11.prod.outlook.com (2603:10b6:510:140::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 10:33:12 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 10:33:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "tglx@kernel.org"
	<tglx@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Topic: [RFC PATCH v5 22/45] KVM: TDX: Get/put PAMT pages when
 (un)mapping private memory
Thread-Index: AQHckLzwePp2LsFGnk6KJpD9rHxlFbV1gv0AgABf7oCAADjnAIAAQGCAgAPhSYA=
Date: Mon, 9 Feb 2026 10:33:11 +0000
Message-ID: <94f041b3aa32169fa2e1125edab7bd8fed3a6e59.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-23-seanjc@google.com>
	 <aYXAdJV8rvWn4EQf@yzhao56-desk.sh.intel.com> <aYYQ7Vx95ZrsqwCv@google.com>
	 <b3ad6d9cce83681f548b35881ebad0c5bb4fed23.camel@intel.com>
	 <aYZ2qft-akOYwkOk@google.com>
In-Reply-To: <aYZ2qft-akOYwkOk@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|PH0PR11MB5829:EE_
x-ms-office365-filtering-correlation-id: 2a49e92b-ba76-4d6b-a7fa-08de67c69fcd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VkJKNjlvT1lkNFdsdERsek1HTHZPdG5yNzBWdXlOWEkzRzNxdU85MjlEdjl4?=
 =?utf-8?B?Uld4SWNCQS83aVpzbFVzQVJPeWNkZ2N1d1JyeFdUS2c4eVVhYWFHWFVWWHJn?=
 =?utf-8?B?bTkzZ3hXS1hTSExGQ09OaVh1d2UwRjcrMkJZaERpUUNnalBsUDdHNEI3NldZ?=
 =?utf-8?B?NWNlZExiekhsMnZZZ1FyakdXdkoraitvaVBZNDdTVStiNEs2TUtLQTh0RmVo?=
 =?utf-8?B?SDVPZjMrdnduY1VRZTRUbnJUZ2FxRkVtQ2svMGRjVmZUd2JoRUVYUmtTdFRj?=
 =?utf-8?B?dWZwNTNhc3V1NjJ6eWUrU09YYm9VM2NUT1A3d2Jta3FlMDF2Ti80U3VRSFBl?=
 =?utf-8?B?dUcvRHphRUw5d2lPQUhvbjNaZ0dLYWxXWG1ja2dkZmtYQlVuemVhZ2ZMeFNB?=
 =?utf-8?B?TTY0ckszTnJDYzdQdzZpbGhlc2FhOFZYb2ZxdzFjcitxT0V1Zy9LcE1BMFdD?=
 =?utf-8?B?a1RVTzQ2Y05Ia2tlMFdaQXlaZXhsbVBiL1JNS29WalJFNE1SMzVBOHA2VWln?=
 =?utf-8?B?VHpQTTBrOEtNbkt3alNRbjBlRFFWUHNaajZ6Um5hYlpBclFMcU82bGZFWXRy?=
 =?utf-8?B?djZCa1Npenc2NWRqaVQzMSs2aGtHa3B6cmlsbGNiWFZRUVVRY0RlTngxVTJn?=
 =?utf-8?B?bGQvaFpHYWplR2hVNmNCR2FudmtnMDhuNC9nejBlMDN1MjdmSm5kU200K09K?=
 =?utf-8?B?M2o2dDdhaEVLNStkUGExbVF3UkRKNjQ2ZEh0aHhUNVBidnBkckZ2YTZ1R1ht?=
 =?utf-8?B?cjlPWk1ScFpkUGlRUExOcW1jSUxMZjJSWDJzYk1tNytIUzhUK21pcVZZQ0Jw?=
 =?utf-8?B?YVFUTzdBb2Nwd2NaYUErMzdDMmkvR2pzRkp1eUdKQkpLQU1UeTNLbFNLTzJw?=
 =?utf-8?B?bkJxRTBWZ0hNRFlMR3RCYUdMRzJSblY4NEpRamlWNFVWOGZIbHkyTHNKNHQ0?=
 =?utf-8?B?N2ozeWpmUHQ2RkZ3djVxNHFRSVpKaXVqMlNwdjl3VGV3dW9sQ0xvd3drd1I2?=
 =?utf-8?B?SDFwNjFBSGFadU14MytseEwzZE50VU5NS3NuV0ZxdjduV0s0Y29CYmdHblJn?=
 =?utf-8?B?U2JyMXYwamFwYThVaGtiWmVLOFl2NjZLR1J4QkZ4RUxkUUs1SEovNzQxUmtk?=
 =?utf-8?B?NldGLzZSSGdLZlh4cHFhRGVjUitWTWdVRG0rQzMrcVQyTlhlbUFkenQ2MFRT?=
 =?utf-8?B?Vnh2RXB5WHFZNzNQUk9ZVjM1VjhLcW54OXBFYmJpa1Eyb1ZMOUVYbmdmczVk?=
 =?utf-8?B?L1lEQVNVdnRlenJMVFZvVWMvY25pdUNRYjFYVlY1SmRKaFE4SG5GSUh0ckRz?=
 =?utf-8?B?c3Rta1VKV0dtTTJVZGNQT3RGOWxQLzNCVG5XY0pOdEUzdzVCR0hiRmtnVDl6?=
 =?utf-8?B?N2lWYkNWMWdwVW43U0xkblplSHNTRTc3ZUwyV1Z1ajVWVFlGUkcxUGoxWmk5?=
 =?utf-8?B?OFRNV0FuZlVYayt3clM3cDJONkg0Um50NWJGdGVQeUFuRlZEOXNaR3ExNFNU?=
 =?utf-8?B?ak8wbU5ldzVkRnlZVUpoMHZHSWJhRmJudG9GWHlFSkRGdFZ1NVFmK0VONitq?=
 =?utf-8?B?Ni9oMHY3WDM2Q1A1alYzU3VIWW8vUjNBMVRjU01rWlBTNjhHRFNieWVwNEx4?=
 =?utf-8?B?ckFJUzQ5REVXMmdUd1ZzemlSeGdLalZhdEl3bEhKOUhYcmgwTE0xekFrRzFB?=
 =?utf-8?B?bGFEV2Z6Tkc0bnFCSVNoVHo3cEl0M0N0SEFoNHR5ekVxdEhWZVV6eDgyNFdy?=
 =?utf-8?B?Z0VselFWSFRHTE9QN21Edkk3bHFVUTAvd0ZIdVhJRzVKeHh5WXFiczUvbEhx?=
 =?utf-8?B?TjNoRjlTQS9JUWhNOWxYZnBaMWc1YkJrMTUwb1JnSmxiajJxTXNTZ1ZjRHpn?=
 =?utf-8?B?eFpnVXArcnRpMElDUC9sajhCSmJkYzBTNGVqT0NUYWJOQUV2NTc0d044M1RR?=
 =?utf-8?B?VkdOeFpPZ1Q2d2RzTU9kUlE5amdRSzF3NW84Tm0xRzB2QW00NnBIb3plWXNS?=
 =?utf-8?B?UnNkYWhBamtiT05jZktJeGZBOFcwTm5kNTdoWWhPSW9qQW9IWmdJMW5LLzY0?=
 =?utf-8?B?YWpqUWkzMVhJeHNnYjlSc2JVeWdUUEtnN2FmdGpPMnNsQkpRQ2wwdTVYK2lu?=
 =?utf-8?B?cjlUOFlNWVNQV2RlN1ZuQW1rOTN3L3loVWpJYzRVU3F1bUNWdThKV005NUZY?=
 =?utf-8?Q?AUKCUdyrQiEfmehLokuziXc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGlsL1JIVXFuU3VHQTErTnhkOEQwTjdTNmsxY0E2YkQyUnlCMk5lcDd1RFVM?=
 =?utf-8?B?bTVQckxtajNiRitySnZPejBDWjNRZVpZMGlyN2tORlE2ZjMxNHd4SHYxS2hM?=
 =?utf-8?B?ZzdsdjBld1l4b050Q1lCZXpUaFNGNXRFVW41NEwyQ2x4VGRnblUrSWdEWk0r?=
 =?utf-8?B?TUlKSHNZTFdId0hjUmRyMjQ0ZTMzaE9ObUcweGVqYjRNSEp6T3pqVkcyQWc2?=
 =?utf-8?B?cmo4S3NDQmhZMUp6NGIraHdVQk1NK1hxR1g5REtnMXRhUnRUeGZzY05lcXZX?=
 =?utf-8?B?MnZ4bCtzT1RLSzNUV2plNjFpN1ZlTldoNnNTc2FvZURFRnpoMlZObSt0LzVm?=
 =?utf-8?B?dmFXZWEyNlhVb1oxWkp3TzZ4dW1ucFBUR1ltdWZhWTJBN2I1SE50bVFIM29p?=
 =?utf-8?B?bTBOZkRVOVAxU3Y0cENlTHM5RTVnbGpnZHpmQmlkSlpxbDRac2NTNTlTSWM5?=
 =?utf-8?B?ajV4cVEzKzQ4djBPK3ZPMkJraFFQUWpKVm5BNWgxMlYwMjV6YzVoTnBWNTJ3?=
 =?utf-8?B?QjE2UFFDaHIrR0RkWTZCQzhHY01nd3JOZUJEZUxhL2pYcDVMZzV1cElBd1Rz?=
 =?utf-8?B?UnJER2Zjd2VuQ242WGpQMUhubkJqdzl1ZlREMk9ya0hMU1R4OUFadzBJWkYx?=
 =?utf-8?B?TDBWT09ILzJZVmYrWWp4dXJKQzFjSFBidnFTMTFJaUpGSnQ4UjQvWjRzczQw?=
 =?utf-8?B?WkxoQU5La2pJWkNWdVB5NDR6cW1XQmdySUgzdWJYblhGQzFLMXhGMjNQK3JH?=
 =?utf-8?B?K2Y0bXoyc3dOZWxMeUpFZjBMbTU1MEJ2YmY2K2hhRWcwa1JrTWdIclIrUE81?=
 =?utf-8?B?NkxaeXNaajkybzM4RnNRZi9KQmJBRUFoY0xIREt3ZDRJdnVlOCtJTUFPOU9M?=
 =?utf-8?B?ZGp5VWM1ejdsWjVaSm9KQmE5NThCeC9KNHloY0d1Wk5KUWhxeHFVWlN4SlQz?=
 =?utf-8?B?TUJsdGpkblVJOEUrb2VRY1JQOWJscTVINm9KZndQelJmaE1FWGhjOGh6dEZJ?=
 =?utf-8?B?dVNYN3B2QjEyTU9nSWZBenE4cm13U2VTdTloUWJwNGVZemV6N3d2Yk1hUEJ5?=
 =?utf-8?B?NjRWTXJpTW1sY0Y3ejNtdzFnN0VtQnNuYTdKMEgxMFU3dWcybG9BTkZrNnBz?=
 =?utf-8?B?bXNEZ01IWGpBa2ZYNVkvNzE2MmtXdVFuL1lqQ0VmVFl1Q0hnYlc2aFFkek1z?=
 =?utf-8?B?VVJWQ2ZIZ2NQWmJWZndBZWpHbTJ0M2NRTDFabFBoVlgxdTBSYTZsSWdSb1Vi?=
 =?utf-8?B?TUVLSzVlblpqb2VicEl2T2xySHc2cHdXeWRqeWkyc0pCaUI3anh1YXIvYWtX?=
 =?utf-8?B?UGE4WUJpQ2NTK0JoQUtqVzE4TVZHL2I5Z01saUV0RUpvSlVOWUxEdFFIcThK?=
 =?utf-8?B?czdrRjRZUVJBVStiN2c1Wnljck1MQkE3STd6cDhZWlZ2eWhVb3JBVUNtMWc4?=
 =?utf-8?B?VkR6end3R1hJZGtlUGIvUDlCT0lGb3pYSkNWeG1ka1FSV21kRjRNeHF1ZS9i?=
 =?utf-8?B?NnI2YUtiWk4zZS9PRG5DUEhrTkZWSHdiNzQ3UzZTWGJtTkhxWk0wNFVMYjg4?=
 =?utf-8?B?SFBDMUJmMWttaFNaRSt2LzdwTnJFelVEb1h6ZG5CWnVockpCTUFSMFAyblFp?=
 =?utf-8?B?a0dMOHRyMUdhNG15WnRvMk9jWDlTMnRaYWhmdXN3REdZZzJ4Tml4Y1dhZzdp?=
 =?utf-8?B?ZVBFODUveXlaUDNaRXVzZVUrczJtaFo3WFU0L1ROT0M1QU5CUWYwV0ZGcDQx?=
 =?utf-8?B?aU1ORzFOZ2pvUE5FRUJ2V0tkdEhXR0dGdmFsK1NCZ1c3T2l6SkhjdGNINHJI?=
 =?utf-8?B?S1JibzNNdUJ0ZnYyRFFETHE1N3g4bzhDZlJ4a3hRSzkyK1ZHY05qUXQ2Q0ZY?=
 =?utf-8?B?SDRWMkJySUE5cWpaVndOMlZKUkNhNndTV244U1JNTDQrYkdEMnpPb3BCK3Bq?=
 =?utf-8?B?dWFCSjByZ243TzJRZ2JxeTBIUHdjUmlPQ0VsNGZhaEcyU283TzJLQUxmVUh6?=
 =?utf-8?B?TFZzWm1XdFlObTRVYWVibXhQZWx0VUkxOHg3T1JyTkpoTUxJY2ljckN0ZHU1?=
 =?utf-8?B?VWMvajJ0TlpTU3VMdnhWa1BkSGN2MXNtWUQzakx2akdFTHVzRUNOVkh1VlFP?=
 =?utf-8?B?U3liR1M0YXIyemlnZFJud1V4SXd4NkswanB4M0NWRzQzVk4xdVZaNFY0ZSsw?=
 =?utf-8?B?L1prVzhKVlVvWUFrYlVybVJSY0Y5enBRUTIzUThCSEEvbmVYQ2dXeG5adklt?=
 =?utf-8?B?QnNUQ09HVGRYM01NTWhaOWROWHI3SlRpR2tKQitPc0xYa1JlK3djclFqMkFV?=
 =?utf-8?B?a2FXdkE0bllIYXViR2JwdnhibTNYTkJ1UXlKWGY3Z0pNN2JabjA5Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAED24D6CAA1D5449710982623F90D1A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a49e92b-ba76-4d6b-a7fa-08de67c69fcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2026 10:33:11.4898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TOYiPmOtsN0QWVSHxOStVXiUApNFKfC6aTAhKawAX0PfDlxPwHkNIGKaP8JJUDk3YPqVnPubCA46LvWP5KLTDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5829
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70592-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: C6EB210E2DE
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAyLTA2IGF0IDE1OjE4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBGcmksIEZlYiAwNiwgMjAyNiwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBGcmksIDIwMjYtMDItMDYgYXQgMDg6MDMgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiA+IElmIHRoaXMgZXh0ZXJuYWwgY2FjaGUgaXMgZm9yIFBBTVQgcGFnZXMg
YWxsb2NhdGlvbiBmb3IgZ3Vlc3QgcGFnZXMgb25seSwNCj4gPiA+ID4gaGVyZQ0KPiA+ID4gPiB0
aGUgbWluIGNvdW50IHNob3VsZCBiZSAxIGluc3RlYWQgb2YgUFQ2NF9ST09UX01BWF9MRVZFTD8N
Cj4gPiA+IA0KPiA+ID4gT2ghwqAgUmlnaHQuwqAgSG1tLCB3aXRoIHRoYXQgaW4gbWluZCwgaXQg
c2VlbXMgbGlrZSB0b3B1cF9leHRlcm5hbF9jYWNoZSgpDQo+ID4gPiBpc24ndA0KPiA+ID4gcXVp
dGUgdGhlIHJpZ2h0IGludGVyYWNlLsKgIEl0J3Mgbm90IGF0IGFsbCBjbGVhciB0aGF0LCB1bmxp
a2UgdGhlIG90aGVyDQo+ID4gPiBjYWNoZXMsDQo+ID4gPiB0aGUgRFBBTVQgY2FjaGUgaXNuJ3Qg
dGllZCB0byB0aGUgcGFnZSB0YWJsZXMsIGl0J3MgdGllZCB0byB0aGUgcGh5c2ljYWwNCj4gPiA+
IG1lbW9yeQ0KPiA+ID4gYmVpbmcgbWFwcGVkIGludG8gdGhlIGd1ZXN0Lg0KPiA+ID4gDQo+ID4g
PiBBdCB0aGUgdmVyeSBsZWFzdCwgaXQgc2VlbXMgbGlrZSB3ZSBzaG91bGQgZHJvcCB0aGUgQG1p
biBwYXJhbWV0ZXI/DQo+ID4gPiANCj4gPiA+IAlpbnQgKCp0b3B1cF9leHRlcm5hbF9jYWNoZSko
c3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiA+ID4gDQo+ID4gPiBU
aG91Z2ggaWYgc29tZW9uZSBoYXMgYSBuYW1lIHRoYXQgYmV0dGVyIGNhcHR1cmVzIHdoYXQgdGhl
IGNhY2hlIGlzIHVzZWQgZm9yLA0KPiA+ID4gd2l0aG91dCBibGVlZGluZyB0b28gbWFueSBkZXRh
aWxzIGludG8gY29tbW9uIHg4Ni4uLg0KPiA+IA0KPiA+IEZyb20gdGhlIFREWCBwZXJzcGVjdGl2
ZSB3ZSBoYXZlIDQgdHlwZXMgb2YgcGFnZXMgdGhhdCBhcmUgbmVlZGVkIHRvIHNlcnZpY2UNCj4g
PiBmYXVsdHM6DQo+ID4gMS4gIkNvbnRyb2wgcGFnZXMiIChpLmUuIGV4dGVybmFsIHBhZ2UgdGFi
bGVzIHRoZW1zZWx2ZXMpDQo+ID4gMi4gUHJpdmF0ZSBndWVzdCBtZW1vcnkgcGFnZXMNCj4gPiAz
LiBEUEFNVCBiYWNraW5nIHBhZ2VzIGZvciBjb250cm9sIHBhZ2VzDQo+ID4gNC4gRFBBTVQgYmFj
a2luZyBwYWdlcyBmb3IgcHJpdmF0ZSBwYWdlcw0KPiA+IA0KPiA+ICgzKSBpcyB0b3RhbGx5IGhp
ZGRlbiBub3csIGJ1dCB3ZSBuZWVkIGEgaG9vayB0byBhbGxvY2F0ZSAoNCkuIEJ1dCBmcm9tIGNv
cmUNCj4gPiBNTVUncyBwZXJzcGVjdGl2ZSB3ZSBoaWRlIHRoZSBleGlzdGVuY2Ugb2YgRFBBTVQg
YmFja2luZyBwYWdlcy4gU28gd2UgZG9uJ3Qgd2FudA0KPiA+IHRvIGxlYWsgdGhhdCBjb25jZXB0
Lg0KPiANCj4gSGVoLCB0aGVyZSBpcyBubyB3YXkgYXJvdW5kIHRoYXQuICBDb21tb24gS1ZNIG5l
ZWRzIHRvIGtub3cgdGhhdCB0aGUgY2FjaGUgaXMNCj4gdGllZCB0byBtYXBwaW5nIGEgcGFnZSBp
bnRvIHRoZSBndWVzdCwgb3RoZXJ3aXNlIHRoZSBwYXJhbWV0ZXJzIGRvbid0IG1ha2UgYW55DQo+
IHNlbnNlIHdoYXRzb2V2ZXIuICBBbGwgd2UgY2FuIGRvIGlzIG1pbmltaXplIHRoZSBibGVlZGlu
Zy4NCg0KQWN0dWFsbHksIG1heWJlIHdlIGNhbiBldmVuIGdldCByaWQgb2YgdGhlIERQQU1UIGNh
Y2hlIGZvciB0aGUgYWN0dWFsDQpwcml2YXRlIHBhZ2VzIHcvbyBpbnRyb2R1Y2luZyBuZXcgZmll
bGQgdG8gJ2t2bV9tbXVfcGFnZSc6DQoNClRoZSBwb2ludCBpczoNCg0KICBPbmNlIHdlIGtub3cg
dGhlIFBGTiBhbmQgdGhlIGFjdHVhbCBtYXBwaW5nIGxldmVsLCB3ZSBjYW4ga25vdyB3aGV0aGVy
IHdlDQogIG5lZWQgRFBBTVQgcGFnZXMgZm9yIHRoYXQgUEZOLiAgSWYgd2UgY2FuIGtub3cgb3V0
c2lkZSBvZiBNTVUgbG9jaywgdGhlbg0KICB3ZSBjYW4gY2FsbCB0ZHhfcGFtdF9nZXQoUEZOKSBk
aXJlY3RseSB3L28gbmVlZGluZyB0aGUgImNhY2hlIi4NCg0KSW4gdGhlIGZhdWx0IHBhdGgsIHdl
IGFscmVhZHkga25vdyB0aGUgUEZOIGFmdGVyIGt2bV9tbXVfZmF1bHRpbl9wZm4oKSwNCndoaWNo
IGlzIG91dHNpZGUgb2YgTU1VIGxvY2suDQoNCldoYXQgd2Ugc3RpbGwgZG9uJ3Qga25vdyBpcyB0
aGUgYWN0dWFsIG1hcHBpbmcgbGV2ZWwsIHdoaWNoIGlzIGN1cnJlbnRseQ0KZG9uZSBpbiBrdm1f
dGRwX21tdV9tYXAoKSB2aWEga3ZtX21tdV9odWdlcGFnZV9hZGp1c3QoKS4NCg0KSG93ZXZlciBJ
IGRvbid0IHNlZSB3aHkgd2UgY2Fubm90IG1vdmUga3ZtX21tdV9odWdlcGFnZV9hZGp1c3QoKSBv
dXQgb2YgaXQNCnRvLCBlLmcuLCByaWdodCBhZnRlciBrdm1fbW11X2ZhdWx0aW5fcGZuKCk/DQoN
CklmIHdlIGNhbiBkbyB0aGlzLCB0aGVuIEFGQUlDVCB3ZSBjYW4ganVzdCBkbzoNCg0KICByID0g
a3ZtX3g4Nl9jYWxsKHByZXBhcmVfcGZuKSh2Y3B1LCBmYXVsdCwgcGZuKTsNCg0KaW4gd2hpY2gg
d2UgY2FuIGp1c3QgY2FsbCB0ZHhfcGFtdF9nZXQocGZuKSBiYXNlZCBvbiB0aGUgbWFwcGluZyBs
ZXZlbD8NCg0KU2ltaWxhciBjYW4gYmUgZG9uZSBmb3Iga3ZtX3RkcF9tbXVfbWFwX3ByaXZhdGVf
cGZuKCkgd2hpY2ggYWxyZWFkeSB0YWtlcw0KdGhlICdwZm4nIGFzIHBhcmFtZXRlci4NCg0KRm9y
IHRoZSBzcGxpdCBwYXRoLCB3ZSBvYnZpb3VzbHkgY2FuIGFsc28ga25vdyB0aGUgJ3BmbicgZnJv
bSB0aGUgaHVnZSBTUFRFLg0KDQpJIGtpbmRhIGRvIHdpc2ggd2UgY291bGQgZ2V0IHJpZCBvZiB0
aGUgbmV3ICdzdHJ1Y3QgdGR4X3BhbXRfY2FjaGUnIHBvb2wgaWYNCnBvc3NpYmxlLg0KDQpBbnl0
aGluZyBJIG1pc3NlZD8NCg==

