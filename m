Return-Path: <kvm+bounces-69187-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CJ6SK9w3eGmmowEAu9opvQ
	(envelope-from <kvm+bounces-69187-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 04:58:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EEA58FC35
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 04:58:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8139D3016ED9
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 03:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B4AD31619E;
	Tue, 27 Jan 2026 03:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BR3MONR2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0656191484;
	Tue, 27 Jan 2026 03:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486287; cv=fail; b=jBgkUbO1igif/N25AkSa1f2Sb6A86FxRpnghNk5i5uV/tzy9b7ds8CpAwQz3hME3q0vcnfZJgAKl0rw2uD/tbaIllSQ5YKjSS2CFRb4So2sv4IwJLGWjNI59aFvXkK2QVg/MR5+Dy4JWqkcIi0wHVJRsJtrAvA1CesIgu8bxDwM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486287; c=relaxed/simple;
	bh=BzxUn0N9cUwwzvZTHUuOtvOW0iQWMBn5LpjVcbl+Llw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oOfHU/LISGYLRE16GGtaP4cE7ewZ5/YAlSiyjUJFRzYd+K1vl1oHmdCKj9/gMJEgIwQCPmzWaYFdBH8xLIO2uty+0WMC40ndpey3edW62IeNRRxkPNaN8faYWuss6Mx8aiEZnE773RW+HSWzXV6f/CVG3FxShPb1fjt5QccAbvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BR3MONR2; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769486286; x=1801022286;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BzxUn0N9cUwwzvZTHUuOtvOW0iQWMBn5LpjVcbl+Llw=;
  b=BR3MONR2eTHelDnZ6bpIKAUkKKiiXyH5O/WLPHcM8eaywFIgx0w3Ijhw
   4EGWp2GlV+C8Uh1L4aOiEVFKInT00XT6RxvaNvR6rzFjo17Jh0+ntlCga
   MA30RUztIwdI6kTpKKIYX3qKnd2kttdP+yZszcjyre5ycaOH1PrigMwYX
   ehrrBu6I3/KfCetCXRtVVygZzp49UwumOgGD5WxIoJuGhgMumizRzKB6H
   jb9d+rBnz7vr2gvZZ0w+mVe9WfuDOC0VvuH9d2j7eJD5j3+xPa9eSvZgy
   pDlvjSpmqdoNAIcb2w+ckZcfgOrQBKPj9bwCQ2cvJnpuWtafK71WELxxK
   g==;
X-CSE-ConnectionGUID: TbAQ/d2sQp2b09PzUfl5CA==
X-CSE-MsgGUID: 4r6Md5KiS8myYcH43fkh3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70730412"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="70730412"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 19:58:05 -0800
X-CSE-ConnectionGUID: Nf95xysmSg+tBhtpREGPTg==
X-CSE-MsgGUID: yNoB1jaBT/SxgrDpiDeVAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="239121404"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 19:58:05 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 19:58:04 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 19:58:04 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.56) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 19:58:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FsrwWEfrmjksEKbxO3DrP8oD3+vBkJz3TPBIP+cS6zJOHRlUk2LUEFeaDHrPOLZ63XbOQ66R1Og9qc35zNsJJY+/yt+SOjz0vyc4YYMM3ZTimOGsUukXtJ2tM0Q1k63cxFjkR3sjTX5M1HUX/FvqKuuv9zmKnnKAHGRC+XqyYXEELabTBDr+TBQuXn3bmK2kGUn2tW8/8e0XOen0mqszePXtHKwr2b88svCZMtX4v+miA2WkrxKD0mBE5QFCaIo/fRk6J2+xEwTYS2M/2xObPkDLKqahDi+WovG5ujvujzm5rJp3fJGtB2lIYnbs/uSfaAy0xr4UDD+hw7GNVte16Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BzxUn0N9cUwwzvZTHUuOtvOW0iQWMBn5LpjVcbl+Llw=;
 b=gi583bh6zQrJ5dLvdbNnGoiAKw5BVoxRXqNrtAfqLCOKEXBEGRXn58L9BvlubRnIlWf412Quv0GwC1Y6vb7w1CBR3o2DbNgrQr1Zi83Shmb88zUNYt/sNsgY5nXc4gLvM7jUrUpiVG9bv/ebG61jfwuTMLb+SHhQS8T1DLDu05BMuVYP0buUmsWs2J/SMUZYFQePvptji/BIcwFGNzEgWOx9rO8DzKRQDyi6eTX4qhYnNOaEBzRO/rr/7KW0U1KRJ8hXiI90Ll6H1F5gXmSp/1Zc1oL1ZzBwb48XxaJsOEHgbqTZe1lYwTt0PEnVfnomBu8s0YHS+G1eBib52ghMQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by BL3PR11MB6386.namprd11.prod.outlook.com (2603:10b6:208:3b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.14; Tue, 27 Jan
 2026 03:58:01 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 03:58:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "nik.borisov@suse.com" <nik.borisov@suse.com>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"sagis@google.com" <sagis@google.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "paulmck@kernel.org"
	<paulmck@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Thread-Topic: [PATCH v3 24/26] x86/virt/seamldr: Extend sigstruct to 16KB
Thread-Index: AQHcjHkW6CQuWkGBfEmIiCBzsHzvk7VlaUoA
Date: Tue, 27 Jan 2026 03:58:01 +0000
Message-ID: <cec76b847a6261cfee14899aaf04ccb41b852aa8.camel@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
	 <20260123145645.90444-25-chao.gao@intel.com>
In-Reply-To: <20260123145645.90444-25-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|BL3PR11MB6386:EE_
x-ms-office365-filtering-correlation-id: 708bcf58-3753-4438-496b-08de5d584400
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?QVZMTk5zOGJmcTM2SnlhdW1kd0RPNnpYWDlaTUhFWGZ6NW5wMXZZUUlCSzUx?=
 =?utf-8?B?Tzd5RmxIdlpPWTRCMk13TUVyTTF6R3RRZjVNOXNzaXVQRGVnVUhLNnpwQ2hW?=
 =?utf-8?B?UXhtYTYzUUdDcG8vL2FNVWxCSzZjUTBTeUkzczVHZGRaRWJBejd1elBiY0hh?=
 =?utf-8?B?c0tpanJPWjVnNitkNTZNcDd1QXNML1JNUk9lR29tV0tXamZhS3AwSTVBMm40?=
 =?utf-8?B?ZnRCZ0U2YnQzSEkzblM2U2tKZS8ydVQzR1E5MXVwRjRyRTkwVVVHUU1UVjJ3?=
 =?utf-8?B?MmZ4SWVsYWI0Z0hpNXZSdEdmenkwNFl5TEw5VmdhUUZvWE9hN2NmRTBvVkJ0?=
 =?utf-8?B?UnFtSjV6R3pubkZ2LzdBRkVORk95OHhTUW1Oa3hkTG00cGlXRStRU1lCVTlR?=
 =?utf-8?B?MC96YjVxY3FMS3JZNDNYQUhPb3QvNUdKWE9QY3I3eEhpNUZpY2ZQd0FjOGJQ?=
 =?utf-8?B?dkl5aEYrNVVpRldXMVp6cXBobkNtemtQVTF2NGFPckE2SW9DRmFNNlFPTnRp?=
 =?utf-8?B?YUNtelNMRE4wUXZDRVJwMThnVWlLdHd0UWJsN2JzNi9kaHRLQXpIbzRYU0d1?=
 =?utf-8?B?ZWJMUyt6RXhtODF1eXN4VjNOcW9HWE11SmEwaVc4eFdzN3lTZ3E4dWwvUmtI?=
 =?utf-8?B?cm5XQTFOZWpXcmF4Z3NXNWQxWUlNM0hVd2lEbTdvMUdtR1MvZ2cvaVBac0No?=
 =?utf-8?B?STliK2JuOUNPSzdVZHd5aGx1MnkydzRKQjRYMUJTMU40VVhRQkl3K0xxU1hX?=
 =?utf-8?B?bis1Mk9tTlNhOC9CZHhEdVJtcGptdUNXcERuMjQ2dVRWcHBxTzFyRWhsME90?=
 =?utf-8?B?NUVmcGRKOUhhYll5b3ZEZjlBSTRBdGVqc29zUHBoZG1rZklJOFdpL0h3Ynd0?=
 =?utf-8?B?U05zZUJxREwwU1FDQmdzdFJDZUg4Uktxb2NYTS9SOEZTSGxIbVRtakwrb2tz?=
 =?utf-8?B?T2VmbzFEeHNEMnJmbzRoSkI3djZyU0w0UzJwU1RadnMyNk1KdTdnRithVW1s?=
 =?utf-8?B?SFdLT09rYk94Vm9JVG55ejVZcWZ4T0VLWldBdWVnK0pkbjVzOHphVjhIWm4y?=
 =?utf-8?B?b1V4cm56M3hsaTVBLzJ4ZHpMaTRXRXgxYUdLNzZNMC9sV1dPUm5OTCtwOGNI?=
 =?utf-8?B?Z3Z1OGVqZEl0bVp3VVZ4MVdLRHpkTFdjOXp1OHJ5MFBOWVkzOGx5UWI5Sy95?=
 =?utf-8?B?Y29OUllnZm1PWWhoUURkdmg1WWpzK3NIanFCOUlGWmN4N0o3SmZiYm1tdDVr?=
 =?utf-8?B?b3Y3dWh6aUlrVk5NNUtUZ2lEUm5xMUJLWitLN2hsQ3M2emdyd2RmMGhGbDBF?=
 =?utf-8?B?Qk5zR3ZucVBoWVRuRUtEZnMxMGQ2NHVoUUUwZWhYSE1DVTVyUUJiQnU0TWI4?=
 =?utf-8?B?ODA5VHoveXVwZkFBNFp4SzgxaFpRdTJjWDd4eDd5dmRDMHZjZ0pLT2xFdjJo?=
 =?utf-8?B?RGg0ak85MEtqSk9wU1IrNDFDZzJWRkdDL25tWmJYYlRIMHRiZ3JoejdIUUlX?=
 =?utf-8?B?R1h0TzdDeTBDeVIzRGx6WFdFUzU3NVBXQWltOTZidHlBcDdwZDZ4Wk5QenlD?=
 =?utf-8?B?U0NmYTA0KzJlYkZtZjNmZ1NQNWV5Qk1xUmwxMW5VZEFvNTJkckRTYmY0Ymo4?=
 =?utf-8?B?TU9RbHU2TlBtUGg1M3JJcFIvb2tpZGozT1NwSVFKV3ZwUThQK2ZqUDh4bWhD?=
 =?utf-8?B?cVRYRGMvblhXbkNyR05LdDhuUWFkN2hZVE1nNzhDZVBuYXNXL3BENWxRemVv?=
 =?utf-8?B?a2ZGSFhWOC9YMGsxS1hjWXdCTTh1Z2ZmdytnY3g3eHBER0VhNHMzQVB0cjBH?=
 =?utf-8?B?V3oyZlRyMWlNNlAybjNtV1kyejNOL2xkeDhwVzRuTjRKOTNYbzc5NHRGZW5l?=
 =?utf-8?B?dGZ1dUdyK3B1SGFUUnhVK0poZzkxVnBNY1Z5bVRqN2Q1Zmcwd2d3cDN4OStB?=
 =?utf-8?B?QUprSG9rcXM2L0pvTE5rcE5uQXpZMjRESDhOdjZ0TTdYZi8xaW5kSWU0SmFG?=
 =?utf-8?B?alNWaWhDUXA1WE5MNjU4UG5iZWh3bGp4amJ6aXMzcThXam04Y0RQL3djbU5K?=
 =?utf-8?B?VktUL05nWUZJR1kwejlMQ2dNS3pyM0NveHpwSkZWeVUrSGRqQS8wMzlVSHVk?=
 =?utf-8?B?ckh6c1NyVEdhdmVUUkVudTFoZ3p5V3g0K21qRGdHblFGcjltYUlTWjk3TUpR?=
 =?utf-8?Q?67x1Id+QZ41s972Q3i6qUgk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEtOb0pNaVRGRXhFUnFEOFpPS1REUFdFR0w3K3lWb1NmeFhoNU80WXI5M3kx?=
 =?utf-8?B?UmxwelFCU1kyRlpTMmN3TVhSWHFDTFdJcExVdlRmVTdpWWlPRGNUdk5LK1Ix?=
 =?utf-8?B?MlpvSE10TGdiWkdJUTZldHRjRXczU2wvd256MHJ4bTUwdVczZ25jZjRkU2VN?=
 =?utf-8?B?Vndaa2o3RXB6aEV0enJHeEFDT05PamlBY2J1Q2k2TG13MkoxdFA2ZW8zQUZ1?=
 =?utf-8?B?cVhDZ2MvYjJTdExnYnhXZHptMjdKYktMOERrdDRyR3o0UzJYeitZSSs1bmpl?=
 =?utf-8?B?SCtYelJjR1R1Z2FFcVNtSFV0cTFyT2pCRlpoVEliTWpZOXhiaS9XNWVsWjlt?=
 =?utf-8?B?cDJ1c1NHQU1oNDE2dDlveC9tcUpQOUVMUHg1dUh5V0xmNVpCUk8xTHJKN1Jo?=
 =?utf-8?B?bWtFeUpSNTJKM3M0b3F2WjRyMngzc2pXZkNsTzFMb2pWSDM2TnM1RGg3eE5r?=
 =?utf-8?B?L2pXM1dJUnRIZUNjcDlqelBQNHFqeW9NZzBXK2dsSDZPSEUzQWdQMnNOdllp?=
 =?utf-8?B?Z0JwTmhRVWwvczc5MDFINFZJZlZVcEVWNHdaYVBKSmRhdmlXVmpwaTNiVGwx?=
 =?utf-8?B?cS9Cc083NmtuUkxJUnp1R3ZKaGQ5cTJwNkphc05CbEpmaGNLMmxtMXZXdEVK?=
 =?utf-8?B?UWlROU1LMGZwbFlpODRaSjY0d2NUdmhpd21uZHB3amNpQjdJcnRESzIrSTI0?=
 =?utf-8?B?cjJBWnNUSUt3WmRDa080bHR3YlNLWG56UWcrbWpjYzdxNXdDU21lYkdWSHRX?=
 =?utf-8?B?R2lhaWdjOHdTT2tOQjFNeWlscVVTUm56QW05a1N6WVdSVXZPUFJiSWZKTkVW?=
 =?utf-8?B?bUhaR3dLVjV4aTA5QTZmUFppcE1DSFgrWDhhUjY4TGROV2lBNXpnOTFzOXZX?=
 =?utf-8?B?VkJPSFRQcERaKy9wTyttMkxCMUZQMmRSYTBPOHpFOTZkcVRXU0dnV3pnQlRy?=
 =?utf-8?B?NkdWVlBvaFpkY2FVNEJHNjJWbkdSL2w1c2thNG42U1VUbXBGcnNEMHI1RFBJ?=
 =?utf-8?B?STdSc3prZWt5UUd2Z2RNaEpiQWJLOUVxczNSNzlJSnpFN2tIVmdnSHVUc0xo?=
 =?utf-8?B?U00vK2ZDbVUwQ3pHNXEzWEtxRmhKZ1Fibkh4TVFjamNZdzI5M0QyemdDM0RK?=
 =?utf-8?B?UUV5UlV6bktaOFYyMlhjQTNIS2NEaEZoeHZTdVAxcWRLY3RqTXQ0K051bThw?=
 =?utf-8?B?c1p0dzdvMU5SeWhtTDRpK3gwMmNRd3dkbDhBd05ob1B1MjFkZEVJbVpKZDQx?=
 =?utf-8?B?ZDlWUE5ocFZyMEh2Z2tpa2JiUm1ZT0pOSkIyYU4wQVVrYlZ5Zm02MG1pT1dT?=
 =?utf-8?B?d3RKVExTTFFHQ04rYmpSWjU5UkJnMlJQbEREZDFRL2VDMUduUktncnNOWDU3?=
 =?utf-8?B?Y0xXZytMdkNrd2t1bXJkUmliVTQvakQ0eHhydFByeFVMS2ExWGZ6bXpuMGFR?=
 =?utf-8?B?UVphWVpQcmlPMUNEeW5pTHo1cXFleWIyd0pIc0FSZ3Z3OERjaDVnVTAwMCsw?=
 =?utf-8?B?QjJKcHdiVE0wckxGRENkSnV6bUdTQTRraVlOVUtiM0hYb2tmVHArS2RIbHM1?=
 =?utf-8?B?UTlyTFRYTTNXS2pTbnMvajQwdEcyNUxqKy9FOGZrdzVrSEQ0R3BSNURvcWps?=
 =?utf-8?B?NjFzQXZIaVRqeEwyY3JlS0gzU2tGUm44elVPd3B0U3ZxaHRtaWluQ0lrOVpE?=
 =?utf-8?B?T0R0OTJLbFNCaUdkbEJzT1BCYWlWQzVxZUxEY2RUeitaN2dHZ0phMjZ4aGFI?=
 =?utf-8?B?WFVmQmN5N1RKNTBSMGoxRUtXSHRtNDBrR3cvYlJROWpMZEtCZmRpTnN3UjRW?=
 =?utf-8?B?OWZMeUlvLzdLN0tqQmdQN2p6RWhjN1BmS2h4eHgvS2UrKzU1VUZkOGs2M20z?=
 =?utf-8?B?bE5IU3YxM252Zk0zYy9FZkJINUZibHZmVFcwQ1RFUWJYR0N4ZHh1a2dPVmhq?=
 =?utf-8?B?SUMzaHRhR280YXo1NTZrSHR0eklkZmloOUlJVlZpSnNFUEltaTlOV3ZQVnE1?=
 =?utf-8?B?TlF1NzBiMUFzaVpNdURxU20ydmFmMzlwaUgrbGV5cFRRaFlSVUpNK0hLb001?=
 =?utf-8?B?NVpub2MyeUwrMGRYczNaVWhvQ2g4WTl6NnV4dWVMeTAzdG5qUnplb1ZwVWRS?=
 =?utf-8?B?bThudUJTckRVbXF4MTVjYzFYYjl3SkVyVE5oTEdab2hMNDF3ajBVT2hkN2Np?=
 =?utf-8?B?US94YkVVR2pXNVBlY3JaNE5kN3hrNWxobVpORWNnMzJKc3k4V04xM01DN044?=
 =?utf-8?B?QlQ5M3pQQW5ROWJXOGVEV05QYTJMc3RvcXdjdXpveTVMc0VITUUxR2hIK1pB?=
 =?utf-8?B?K0hKZVJTcFZJYmlYMUVhWk9kWjF1TFdEaFIrYUc1T0k5VFJGeVFnUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <282C96333E3FF44E877FE00F56195931@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 708bcf58-3753-4438-496b-08de5d584400
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 03:58:01.2134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+za5bTDrKFYb6OA5CdfPYYv3U9CJEfg+0/gMhVYGJUwXyWhhWAN6I3vHgOStpn+TPFGKw48bUixYNtks+kcaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6386
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69187-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 1EEA58FC35
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTIzIGF0IDA2OjU1IC0wODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IEN1
cnJlbnRseSwgZWFjaCBURFggTW9kdWxlIGhhcyBhIDRLQiBzaWdzdHJ1Y3QgdGhhdCBpcyBwYXNz
ZWQgdG8gdGhlDQo+IFAtU0VBTUxEUiBkdXJpbmcgbW9kdWxlIHVwZGF0ZXMgdG8gYXV0aGVudGlj
YXRlIHRoZSBURFggTW9kdWxlIGJpbmFyeS4NCj4gDQo+IEZ1dHVyZSBURFggTW9kdWxlIHZlcnNp
b25zIHdpbGwgcGFjayBhZGRpdGlvbmFsIGluZm9ybWF0aW9uIGludG8gdGhlDQo+IHNpZ3N0cnVj
dCwgd2hpY2ggd2lsbCBleGNlZWQgdGhlIGN1cnJlbnQgNEtCIHNpemUgbGltaXQuDQo+IA0KPiBU
byBhY2NvbW1vZGF0ZSB0aGlzLCB0aGUgc2lnc3RydWN0IGlzIGJlaW5nIGV4dGVuZGVkIHRvIHN1
cHBvcnQgdXAgdG8NCj4gMTZLQi7CoA0KPiANCg0KWy4uLl0NCg0KPiBVcGRhdGUgc2VhbWxkcl9w
YXJhbXMgYW5kIHRkeC1ibG9iIHN0cnVjdHVyZXMgdG8gaGFuZGxlIHRoZSBsYXJnZXINCj4gc2ln
c3RydWN0IHNpemUuDQoNCk5pdDogdGhlcmUncyBubyB1cGRhdGUgdG8gJ3N0cnVjdCB0ZHhfYmxv
YicgaW4gdGhpcyBwYXRjaC4NCg0KQnR3LCBpcyB0aGVyZSBhbnkgc3BlYy9kb2MgdGhhdCBtZW50
aW9ucyB0aGlzIHB1YmxpY2x5Pw0KDQpFLmcuLCB3ZSBkbyBuZWVkIHNvbWUgdXBkYXRlIHRvIHRo
ZSBURFggbW9kdWxlIGJsb2IgZG9jLCByaWdodD8NCg==

