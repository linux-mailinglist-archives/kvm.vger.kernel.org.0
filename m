Return-Path: <kvm+bounces-26436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57D6E97472A
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:12:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 796CF1C21FF4
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:12:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496443C00;
	Wed, 11 Sep 2024 00:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BmI23mi1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB3D161;
	Wed, 11 Sep 2024 00:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726013558; cv=fail; b=t1ehxmCPeEtPxYBty+vckCknIxSxkBjQvXnH6MHXuQwT5DZDb3q145ymkF+S5IX2qQJBDmgZSJKtLyDAqM/51KjbVcxsXZpweCZdpABuMFrmdBOsp+t4jlFhddz6L2YoTpf43P+Bo0LY8Zm5ujGEsvKotKRQZ3aBxucJa1EsWkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726013558; c=relaxed/simple;
	bh=bZ9/cyiFizfbJFN+N3Je/MkmQzWbFIt8ed9F0a/OTmg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B51ryNSkLkjwvx/7Du+T3WOfBwmo9FVgWnGUTX5ryw1gHzuz+2Z59krTG9XXgsj9eHR5vGk0MVJAA7mCWYy40gtgkpNfrnYRv83MpGPGeKL7R5YTcCg3DgJOkX3JjeVUDnRJ6jJ09lnse+B0XTIlR6ZZAmr6ru5URR3oYAcio0M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BmI23mi1; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726013556; x=1757549556;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bZ9/cyiFizfbJFN+N3Je/MkmQzWbFIt8ed9F0a/OTmg=;
  b=BmI23mi1XBnTStoNl6tm2tC68UeOC+Ay5zyVe9Vvxb3E3BPB48Zf6UdY
   pgNwlbJSJgNjXSpz7YijQfwRuxHwWnazisriccexWPizpng9IJKuwV5PF
   vVlG5XfOXAin0hmW9jPC5axiZwkFf6D+r/SfqpDU7bRqsQ0llDEww+POP
   Epccvo5w3I1tF3huw/1A+RavnRh34q8ykddr/JEpq6/6ZMtr69RlEcjx4
   fCdRXAZbsVzFaO/36c1B0JD43PJOXnXxmJC7A99VD8vgz51o+ft1pZX59
   SbiFoxdr+6TIyWVwWh9Y352Hi1jVDU+WFGrDileq8rWca4OToOvuqDCa3
   w==;
X-CSE-ConnectionGUID: OJA53BhITXOJhKwY4biYUg==
X-CSE-MsgGUID: ZfP2SXvoThW7R61vUYg4JA==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="36169680"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="36169680"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 17:12:35 -0700
X-CSE-ConnectionGUID: XMNHqEfdR5WTZZrwRQf+qw==
X-CSE-MsgGUID: Uv/5lrGYRT+3OXnIggcmUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="71339079"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 17:12:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:12:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 17:12:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 17:12:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 17:12:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VdIFSXRTSA56cvQIzX91v1o1G0rnMrs3GcKwEAJmHIb43VskF2aN7nR0gzrOCPHXGT7Aq4JOnnx4EwkqHW2NrToirtZPzdCcc9WB31YJE1zDKSRSfW38lHjwAfA6YyTgbfdaht88QEZVrE6Xb8KzfXkNT5fQPhe0GsYCS7RWujIm2EPfzy/wYbbuRH45RpXf98Jnjg3wg+VunYFtMqFQGyJw3m9XO8obJuyWZBwiC2e85iGtML9pelIQDjRj7XBCp8WV1iu+ySTSBtD/42ypK3jFjhfoLvj9FLg7lsJrKRw11WfWikBkKG+PFsdkq0oU/QJ+5cQj9YwP7YFTw5PX1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZ9/cyiFizfbJFN+N3Je/MkmQzWbFIt8ed9F0a/OTmg=;
 b=FgJPYBN6gx51acehK7SUKCRlFEH5cNh1n66zXyc1X5Vqr8duhc3uZOaLR6HAfpCZ89gRdbRsPrJEtovMArRorSXaeVIyXbAhKAfmyWSa+grFHahvn2bidekV/y/N4ren8A6cW27o3Tc9VroOf1UfgBwnWsC46A9hdtHjOMGY+PhEqTrQwcO14CtbSnf24IDi8P59zYj1vXh0LAzjSIHeYtvW76vp2A9KHTSKFad3fzqzraOuwUeM1xb0zF7QncRv9WxLMFNnRdbmtE3nJHLKsBOclOD4/2Ci6bu5l93uzWiMmRdLGpGr1juOl81VSTcfAQJvc96P+PQr28JPFIargg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7309.namprd11.prod.outlook.com (2603:10b6:8:13e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.25; Wed, 11 Sep
 2024 00:12:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 00:12:30 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>, "Huang,
 Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Topic: [PATCH 19/21] KVM: TDX: Add an ioctl to create initial guest
 memory
Thread-Index: AQHa/ne7pTzhAEMIUUeBkR4uOlaw8bJQ2DMAgADpcYA=
Date: Wed, 11 Sep 2024 00:12:30 +0000
Message-ID: <06eeac269e55b6ee1d944d559dc6bbee1d98c37e.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-20-rick.p.edgecombe@intel.com>
	 <9dc3f31d-a7d7-4cf3-a86d-4266a5146622@redhat.com>
In-Reply-To: <9dc3f31d-a7d7-4cf3-a86d-4266a5146622@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7309:EE_
x-ms-office365-filtering-correlation-id: b068fabc-bda7-4e1b-8d80-08dcd1f66d4b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TWp0TGQxSlcwc0N6eTF2VWRtbjBjTHVwRnZLQUp1c0JRRjZYQ09NTENJd2JO?=
 =?utf-8?B?Q2hpWTZrRHhGZThoYm1Tbkh5OHQ5eFFJUEJUNmtNdUd1TTZLNHI5SkswUUpO?=
 =?utf-8?B?ZjEva0g4dzh3cDF3ZERnbUtGSkpETzFSeTVwUnFsbC9yMGwrOXhtYXhRd0Z3?=
 =?utf-8?B?NnZPRUhCUkU2UXovR0xERU44dk1MVVdDbmRWeTFOcFdLWUJ6WE1pcVkyRFh4?=
 =?utf-8?B?Tkp4MWtLVXhwMXAybkFMSW82aW5DTS92Q2pvTitZOVo0RitpTVIrTHdUdTNp?=
 =?utf-8?B?bExuMkJQbmdHWGg1U0J6TmlRUjlTVmZsNFNuWEF2M0RjRUZoR3A3NFczb1FH?=
 =?utf-8?B?bTVnSC9DRnZrdFVXd1JOUWd0ZVpRNXdTZlluQXMxWnRzaEtjWEo4WHA3aUVD?=
 =?utf-8?B?bEU1K3JyTXFmWDdBVWdFdFJQM2IvVVV6SEcyVUtodjg1Z1BkMitGL01SY1ZU?=
 =?utf-8?B?T2hCeGh6b25ESS9tbndqamdnVlhhWU1oc0VCV2tld3JML1lIOFFIUlZIVDJt?=
 =?utf-8?B?ckZISU9pYXcwVUZZUnRhMnRFQVJsK2JvaEE1Z2E4TUo1QzVlenVucE1BKzZ3?=
 =?utf-8?B?MHhpZnV5TE9mYTB4TGt2ZFRNdnZtNmNYK2EyRmRZK2xmVjBqa0VHa1V2aWE2?=
 =?utf-8?B?M040V1lFVjlUem4yYkZGczBaRlA2OXVzUlFPNjFyK3I2SDF1Z2Job1lJSUxr?=
 =?utf-8?B?dTFPQ1NsZUJBMUFSK2xGUDUxeFl6czYyTm1PNEd4eC84VzVYWEZPQ09ZMlhS?=
 =?utf-8?B?UjNabVRDd1htUE1lMlA3dWtUaUtwcTQ4M3BwaUFYWDJxUmxqb3kwOHA1aElJ?=
 =?utf-8?B?MEd6N1BkVDBMQ2VubW1td1RnMytBVVgxRW1CaDFNYnhMZkFLZ2FxSVdIT05C?=
 =?utf-8?B?UHF6OWxCamxhaG55VE5aRk5LZ2c2Wkl0OWlsU1BVbk1DMThoRk1tVXhPbWFo?=
 =?utf-8?B?bzhTcW9JT2pxNXYzZUIyZzBaV3lHYWpZV1RBSVRqcDBlSHpyNVR6WGRwQm0y?=
 =?utf-8?B?VzhicnFJUGFmY2dQWFhGTGdhbm9ybG5FbzRuNW5xZGR4ZGI3OGc3KzFTQ25Y?=
 =?utf-8?B?WU9ZRlZjeWE2aExhMGxiMUFneGtTR0d4QytRME1OOVZ3cmRQd2pUUkoyMTRZ?=
 =?utf-8?B?YjFITm1mSVFneFlXRC9JV003S2I5SzRPSWZValBCWExaTkJJRStyN29qT1Y0?=
 =?utf-8?B?YTdTVVVzL2ZoS3V4QXNpdGI0UkVrYXN0ZkRiaTM4QUt4OExPRDNUQTBHSnM0?=
 =?utf-8?B?UkQvb2I5NzBsMEIvQ0hMZnQzUUpQQ0s0V2pEbXV2TGszdWlPNGxhelc1czM5?=
 =?utf-8?B?MzFROW5RUlV1c2o2NzRmQVNYL2tpVjVWcGJWTXFFenA3akxPOHFzWHZnc213?=
 =?utf-8?B?cklLNjBwZVBLSU9aM0JkUlVhWEFoSTBKaTlqckdUcmhTQittUjlCNnJWaG11?=
 =?utf-8?B?aEJPZWFGS0JPdlFyMDR6SXZBU3lnMFFLeTNmd0Q1R0FJYjdZZE8wc0tkZTF1?=
 =?utf-8?B?UU9nSHBSTktFc1VYNklIWjdzMkg4NDl4blUzQTNaVXFJekw3eDluYUE3MTlK?=
 =?utf-8?B?T24vRUZVTHpwMm1tMjdyQjFhY1AwWDRKR0x3aG11SzBGc3o0TDBzS0YvSWpk?=
 =?utf-8?B?NW5YMDVsZmNObWdsMUFDSUIrZ0NpaDVYMmplWVpmK05RaW9vSUljbUFZQjNs?=
 =?utf-8?B?SmdtVjREY3lHbGRidGd2YVBva09vendLVjYwZW1kNm11anMvOXRERG1Bdldz?=
 =?utf-8?B?K1NPSHBjcytpd1NoY3k3Wjd6WU91dFIwRXJhU0p3Y2RkQkpDYjhIZUNWRGdl?=
 =?utf-8?B?eVJuaEJ0bUJZRDYzR2RlSmRwL3BiMHMwSmFXeHdpUlJKK2puNUUxRUNUdm01?=
 =?utf-8?B?V2h1ZFEwZXkxYTJ5Wnc0RlNmZnIxRFNqMnUrekUwNzhwNGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MjFtU3RxR0s1QTJzU3pEUmlYTDhiOHcvK05XaUp5dnQ3cVN0TXlQYmQyT0ht?=
 =?utf-8?B?UlZ0RUI5ZnM2WHZXQkl1YkpYTDYvTG8wTWZtVEo0ejArUnJnTTRjS3FHcFJQ?=
 =?utf-8?B?b284cHdhOTE5OWE2ZTcyY0Zmb3lrd2FoMHFqdnBnSXk4ZEJXWXVtMGVDZEFO?=
 =?utf-8?B?Q3Vod1FoZVA0blVUVDZMNXlYR01qYkREWHd1N3BDU0p2VHVIeVd4Nkp6U3JN?=
 =?utf-8?B?bjg0Uml3b3dxK3VKU1BPM3MyNm1jUThCZElMOUorbEd0TnZPdGljKy9laEhS?=
 =?utf-8?B?bW8vYUJsbnpNcVBMVk5CU0NkdEhPWGZCR0hTZU45SlpZR0ptS3J5R0JLMUI4?=
 =?utf-8?B?Z0djVFF5TGxycTl3Z0JrNTdpQTFKV2dCT2lwRm9EQytSU0EybDBCNUI0OVFQ?=
 =?utf-8?B?VCtsM2Y3UldUaEliK1hkanI2ZzRYamtrY3FZVm1ySENFdGNhVjZOeVBrVW1l?=
 =?utf-8?B?eWdPc2JRQXVaNk5JV0QwR2xmQUhTa1hPeEV5ZlpESUtrVFZFcGg0bWN2ZU9n?=
 =?utf-8?B?VnFjR0VSOU1tMnlZbjNXakRMSDJhRU1QOHRUMktBNE16UmRoK2ZLM2ZyVjJ1?=
 =?utf-8?B?L2xYTGRQc2Q3cVAvbGNDbEJnZVhxYkpjUFpwT2VXTGsrZ1hadUxOQ0NLaVFr?=
 =?utf-8?B?RDlDeDZmc3dobGJYemF6c1BvR2lDVlBSaG1JZ2k1ZWZkdXlrck5Nb0V5dlE3?=
 =?utf-8?B?ekVlZ0psWC9wZmRHa0RMMzFOemhmVFg0UWg5dllYNTJyd2Q5R2l1dGRCMGFM?=
 =?utf-8?B?MWRsNE5UV0lkakcvQW5NOXhoNHZSeUdxTVpPKzBzVGVmeDNRZW5MZWZIN2JT?=
 =?utf-8?B?SGVMVmM4RGZLc1o1UWpBekRvM2VvUy8xd1lNU1J3UkNsRVE3MVpERFVpMysw?=
 =?utf-8?B?TkhROUw2dDRqUGdRdVdrT1FTL3NEM3VnbnBoZjdENmQ4VmxjVE4rTnFhTGRE?=
 =?utf-8?B?VDE5OWZ2ZmNNY2ttN1lUaHZSdnUwN3NKYlJsSDdSOUU4VGY3MGkxeW91ZXFi?=
 =?utf-8?B?S2t4aVpLUnprNHlhNWl3SmVFN2ZkTnJ0QVd6bUsvNDd1MTRSNXlOZzlaMEVY?=
 =?utf-8?B?QUlFb1VoL25sWUZBaURUSTVJZlRaTlVSR3pTelFrbUw1bDh4QmRnaWdIK1Vx?=
 =?utf-8?B?akpjQmQxUjFhTTU5eTlseDZXN2ZjNnFZWUxTbUMwczFHT05KRWpiZFFuTnFI?=
 =?utf-8?B?NlFmS3cza21aV2ZtQ2lLUVkzZFBkTTZ2NXNJSXp3M2U1UzZYdnRMMCtGKzF0?=
 =?utf-8?B?L1NUblNnTFRsTUZncUNNZWVPZ2wxWUFYWUxoTTQvTGNla0piOWhzR1lBc0dH?=
 =?utf-8?B?QkNNWlkxTDVtRkpyV1RiTUZuVDZnb0lJSlEwVzlzd08xcmhUUXNJZkNvSHAy?=
 =?utf-8?B?Sjcrc3Bpd3ZWR3Exd2tzNDFBb2NjYlNINm8zTHk5c2N5L2U4cG1kZ0pJVFUy?=
 =?utf-8?B?ckQvbVJkSU9uSmpPUFFacFAxajFoL25vYTl2blc4MjNOWnF2N2NxYVNHdWxF?=
 =?utf-8?B?TkJCSmovQXhNRnVUSGpLRHlqQ0RjZ1c2akE5eFVmOGFwV0RSQnR2NlliN0hF?=
 =?utf-8?B?MDFDM2FEdUx5SXZJbGo2REkwL2wzNVdXMVBTZnc5NVJLbjYzRUlESUtEK29x?=
 =?utf-8?B?Smc4SUdwczgrd0JyelJ5VG5pc0pZazNCRmFzcmZ0TDdJVmxWK21Dd0tvWEhn?=
 =?utf-8?B?Z2FXeno1d05lL2ZqSGNMbGFxZ244UDZVTW9VU1Z0WXdVZ2JOSmdXVzhFM1g1?=
 =?utf-8?B?OFVOZi9uWldiejZIeDh1QkJacjVZeVFiRHJrbXVGSDZzTGR6enlHajM1M1FS?=
 =?utf-8?B?cTQ4Y2cxWnN0NFN0RXR1T1FFdjJkV3BiY0htQXJDMmFldE41QzlDREJTbDFD?=
 =?utf-8?B?bkQ0NTQxbS9QZTRkeEJoZ3h4RUh5RitneXJLVS9ERUxaOFg5NlM1UjdPWGhX?=
 =?utf-8?B?WG9vWFd6ZW9za0pkR2lhMXlna1poajJaNFJ3Mm5hUE5iTUFINzMyZTRXRkpG?=
 =?utf-8?B?SUNvMENRUWFxN2lRU3VrZDZubmY0QWZVU09PSllhRFJ2djRRcTAwNkFRRGM4?=
 =?utf-8?B?SE83RG9KZ3dQcXh0QWhyYkRpWEl5eGFpM1QwUjc4cERydnRWVllSMGRvNzZt?=
 =?utf-8?B?bDI2Z3VkbERudTEvN2lDNFZOdzlWV1dMZDRRQjR1d0dldmVkb1ZrQXhKSjI4?=
 =?utf-8?Q?Qxb5XnjZP8Xw2sW8+pCT7PM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <94226569C02ACB44883CBE098138762A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b068fabc-bda7-4e1b-8d80-08dcd1f66d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 00:12:30.5536
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sq/LFykCj8t/2b08nVFo2Dlv90n6u7oxVvVGS77tBJHLvVG7TZe6/Jr9IUzW77sctORmit1kTn8jdzhiXD7bVJ+83GZF82KlftV0SH1Cfd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7309
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDEyOjE2ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBXaGlsZSB1c2VmdWwgZm9yIHRoZSByZXZpZXdlcnMsIGluIHRoZSBlbmQgdGhpcyBpcyB0aGUg
c2ltcGxlc3QgcG9zc2libGUgDQo+IHVzZXJzcGFjZSBBUEkgKHRoZSBvbmUgdGhhdCB3ZSBzdGFy
dGVkIHdpdGgpIGFuZCB0aGUgb2JqZWN0aW9ucyBqdXN0IA0KPiB3ZW50IGF3YXkgYmVjYXVzZSBp
dCByZXVzZXMgdGhlIGluZnJhc3RydWN0dXJlIHRoYXQgd2FzIGludHJvZHVjZWQgZm9yIA0KPiBw
cmUtZmF1bHRpbmcgbWVtb3J5Lg0KPiANCj4gU28gSSdkIHJlcGxhY2UgZXZlcnl0aGluZyB3aXRo
Og0KDQpTdXJlLCB0aGFua3MuDQo=

