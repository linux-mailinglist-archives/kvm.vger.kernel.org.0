Return-Path: <kvm+bounces-55027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DE7EEB2CB9B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 20:03:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C589C4E3F6C
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E331E30EF9C;
	Tue, 19 Aug 2025 18:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TCfqp8xg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5415D30E0C7;
	Tue, 19 Aug 2025 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755626625; cv=fail; b=lGTyFz71fJ1xe3o58bMSBhT8XfHJdj+2w7/lgWa03i/Hp2Qy4oM2Rf3enzhLUDM5LnSMDJ0PiU1yGyIVY0ej7if68jwQ61UhgvslLXU03tpAqBu7wBVQWr50xzoGHSI21l76gimNFvw5Dh1fRG4CnqnZAvO3ah2rPHEBP2QuUFQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755626625; c=relaxed/simple;
	bh=DAJdLEt+Z3CuZWoaONJjysNzO4i/UjncgH6ji4VClz4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NP354tiZSmfaruekwHSME04+sO2IOoicPrU/5q8+tZU8gp1p6crPzKiq4BZKbjQBegR0U151hjAbgJaHkqiRP6hsKse2V7KU0jGmR9+LmxWHO5qe4JX1fKgZkBA0RR/eMTEhG51tSAFDcklwMFB8bRL051lC61fJGzc+LOTA5+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TCfqp8xg; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755626624; x=1787162624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DAJdLEt+Z3CuZWoaONJjysNzO4i/UjncgH6ji4VClz4=;
  b=TCfqp8xgE/K9ELyE2j6zJfhTBggqbEoKdSODn1HMcgfM0kreRsI7ZPzX
   Lb+PQeGqfjD2eWcdTWG80B3YZO50XIvmpiMf7kzpQKibaXeT3Llp79kjm
   ea6Xogxw9BdrsoyBfJB17TNt6RfcSXdbTH81gF8FC362WYdQqQHOLKRvH
   iUt9IM75Ud9Bs3fc3QXn6br+AXaDu0b1DiSbMgvT/qXGIaAzDwCgf5M7J
   FMNgBprBCVEE3wd35hPd5jC2W4iBuiBqPXBeujuECKJBzT8w0Cy9FPmv0
   8Rf1DnOa56q78jNHFV8YyYfWvUUo8juP0znfVij2QN0lbJu8gbocmefl8
   g==;
X-CSE-ConnectionGUID: wmfISxnLSHuMhliD+WQrJQ==
X-CSE-MsgGUID: sKJpYSI2QjSK0ANEowr/hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="68149505"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="68149505"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 11:03:37 -0700
X-CSE-ConnectionGUID: vvBSEEctQKWNsZe8kWGHmw==
X-CSE-MsgGUID: pCr+WKcDQEaZxMSJcKtgWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="173157194"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 11:03:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 11:03:34 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 11:03:34 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.87) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 11:03:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XGp8Tauxxno3guwq9Ba7RDTKTo+3zLz9K7XbcdX6s2PY2VGqWbQHkCUw59SEyZSWz/n4TY3Lmp7lFe30YYBUPHyLlvhGxNIo5k3tpcLBiZILBkXr20QTctX3JemI+E8zQAqhborCT5spmnX/Czi1LINBNolInBdzb8XM+OtMoYRckJusyCJEk7+RatNp/2fijQXWBgbcA8d+mOckP8I0xM7T2ScXmG/DriaqMfv5dDSonX8AHrsX0DTZqdK55uYOfVLXODCJXEg6upDIya4yPUAGdq4bI2hVeVe00yEjc3QQ/YOoobXK07IsfMUNgaHU5IOmZO/DM4vnbX/PiBeJNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAJdLEt+Z3CuZWoaONJjysNzO4i/UjncgH6ji4VClz4=;
 b=qM//DQenYb7HVL55CChDerteZNUdAamMO1kfzI87yikSEw/xGJKh97Z9yrSV4oKNlEHpHOEK10mM0U9cAgImCbhlzfS+fv9cIyAl7KNxua2hw6dfE++Vg0FNYRax9vxpFQA7hujgP30Nkwt8YImfow6chWs5BZ/cha7nk6bnRA60mdSzuW0+A7Zn9P1AkMfS2UqUedkXOEsCGzhc/FXcXVhDKKTUxT/qZtuyaj/Nf6fnEP29TE9neSSvBDd6bqwkUv8HDTRInnXX26nXdZHxIfdZPBLFtgNZzxv3me5n7ZCid9ncoiwOM9KIPPWK//x0Ry9eyzW5RnELbRFOaL1LAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA0PR11MB7741.namprd11.prod.outlook.com (2603:10b6:208:400::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Tue, 19 Aug
 2025 18:03:29 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.9031.014; Tue, 19 Aug 2025
 18:03:29 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, Yazen Ghannam
	<yazen.ghannam@amd.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Du,
 Fan" <fan.du@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>
Subject: RE: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
Thread-Index: AQHcESXT796xUqT8/UuG513Iic+TV7RqOyMAgAAGP4CAAAH0gIAAAMYw
Date: Tue, 19 Aug 2025 18:03:29 +0000
Message-ID: <SJ1PR11MB60833C7AE2FA8D8200EA3645FC30A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819172846.GA578379@yaz-khff2.amd.com> <aKS5ixhgtCYIvErL@agluck-desk3>
 <4b8b5c89-e8b7-4eec-91eb-1fe43a68cf9c@intel.com>
In-Reply-To: <4b8b5c89-e8b7-4eec-91eb-1fe43a68cf9c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA0PR11MB7741:EE_
x-ms-office365-filtering-correlation-id: 534a82f8-7099-482b-abdc-08dddf4ab3da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YkpEOXh4TGV1MjlzdG9Hb1RyWlg5SlhEMmo2ZkVCYUc4T0hxdnNBL1N2ZS81?=
 =?utf-8?B?L0xqT3Jua1pZZmhVdUtBMnNkaTZHUGgxdGFtNzh0SngvRnhueFo2UEZIU05G?=
 =?utf-8?B?YWRCSGVDVHNCZU4xWnM2Z0IvTlVmZ2R1NUE1SlZSQXVKc1Z3ZTNFUmNGaDMz?=
 =?utf-8?B?cTlCTUtvRE02Rlp5c1M0aFY3b1k0ZnArbm5sTWVzdUxCZTdTbDI5T1ZLSXpI?=
 =?utf-8?B?Q21BbW93RVpVZ2kyWGVwTTVnK0NpbXUxekRxRm00bHZuMnNjWk1EdEcwVk9l?=
 =?utf-8?B?RmRCRUJsSjVCK1Nac2kyVzlmOUFNNVlER2pvOU82eGVrNittVkNzc1pWazFH?=
 =?utf-8?B?d2l3MSs0TnY4d1JuV0o4eUJXVVhrTjIyQzhob0lyc1VtMTdZdk1PUzZTV2NY?=
 =?utf-8?B?a2pnb25GSEp6T1M0dEJEUXhDa2Y0Mm8xNHlzc2lTNkY2M2wyYjJ5bFRlMDhZ?=
 =?utf-8?B?WHRKT3FicFIvVFNSczdGYWRNUzRTM2VjY0N6ckFUTEYweUplRkhCQlZxR2tQ?=
 =?utf-8?B?YkFnclVQd05kTUVyWkk5U09QMEJPdHhoaTVEY3VzcjVZOGhDUnh2eUlmK244?=
 =?utf-8?B?Z21oSWs0K0hTaVdqcnNGeVluQTVuOUJLOUQzdS9DMlJaY3F6MnpzRXd1eXBm?=
 =?utf-8?B?clRGbVFzTHhIc2Vkb0tzWmI1N1JMUTdKS0xKdlRQWmtLRGZzdjNsRHdGUmFM?=
 =?utf-8?B?QWsvS0ppMytlV0pRTGhNTVFJVHBDYlJ5K2E0MWJVWnJkdEF5NStndEdNL1dh?=
 =?utf-8?B?QUc1UWU4K1NhVmFRRTdBWDlYZ28waDR4SHFpWmZhNHdGSDVVMTltbkxIbk9T?=
 =?utf-8?B?RUxKTnBKbVZjZ0R6TjRkM09ETldkd05KeHJPV3BPeFVZZVRSMittelFSSlg3?=
 =?utf-8?B?RkRjZ2N3R1RaMGNWSmhtSU1WTXpyeFd3L1V2ZmpoM2w3bXRWd0ZGcWNhVitR?=
 =?utf-8?B?QWh2cncyVUViSFcxQ3kzV29OS21FVm81MVJNL3JGRVFoN3J2OGZ0S0s4S29a?=
 =?utf-8?B?aHR0aDdET09rWGhWd3UwRlB1ays0NHFnVlBTR0ZsNDk1ZFVrRXFjRno4NWtF?=
 =?utf-8?B?OWcrWUlnOVR6WllnWVFCT09WaDE3Mk1OckNUTzI0dC9FSGRla1VkdjltNGtS?=
 =?utf-8?B?RHdOMm5HSmsybzlNN1o0dnRMWTZJOHdWNTdaYzNOb3pCY05ubGVCSFF2TWZC?=
 =?utf-8?B?SDNkUXk0QUJCSEwvQU8remx3Zlpia1NSTzNwOVF2cC8rREplbW5nM0xwaXdi?=
 =?utf-8?B?VUhlSmdxdmRGYW9DRnVWNytwVXJ3c0JKMDFKZVZGMHcwdFNSalN0b3NabCtY?=
 =?utf-8?B?Z3N4QTNvSlV0VUJ6UW1oYkUxYlRuVHZOVEhvVnhhYW1tdmZ5VGIrdE8va2Fy?=
 =?utf-8?B?TE1tL29YQzJKQ2lQMzJOVFp4TVNvUTZwMHdzUzlnNDdyQkdWU1FqUEdBWndR?=
 =?utf-8?B?WG9nKzRSYmNjUTU1cVJ1bzFYV3ZuS20yV0tWU2lNbDNxTmp1aTFxU1Z6bjB6?=
 =?utf-8?B?QzlwY2NOcjhYdnU2Y0lCZUtOSEZPK0NVaFBlMTE0b3BINmdiL21LRC9LdVhT?=
 =?utf-8?B?elpjRGZTZk1DekE3SjRjV1JYMWZOQkpVcnk0QS9JMW5pQ1lac0NQS3JWWnd5?=
 =?utf-8?B?MjJDQ3NOYjFYZjFCVnZQOExoUEp2U3RDajR4MExXNFh4V0FLUkNabHh3R2Ft?=
 =?utf-8?B?c0tQU0hqSmc2eWdQck11QVNkZEh5ZzlKcFhmS005Y2F3MnNCaUo0YWNuTFBC?=
 =?utf-8?B?eStNRmtleE9YWTBmb0hWaXczYXRhZ1FzTW9hMThJakI5OVZ5Z2NLN0hpcks4?=
 =?utf-8?B?OEZOMFEyN0VZbzc2aFB0RWtqWElnMkNub3hGRU9TZ2FHSTFOeTh2aFUxQS90?=
 =?utf-8?B?TWpPZmVsSWtxbjJpaWJyLzRLU1JabGN4R0UvdlBZdG84WTJ6SjdyTTVWYko5?=
 =?utf-8?B?c05sanZsWmpwV1hCcDB6bjhIdE5SemFnVmt3RmVCb3ByUXJmZ3NlNVE0SXBJ?=
 =?utf-8?B?L3FHV0JsRzF3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnFqNGtwNTJRc2NOOVZiS3FsTDdsaklybFBnRFE4NTlqTWxuWDZxRm9DeVl1?=
 =?utf-8?B?YVI2SEY3cUg1aFkzNWMxRzFmd2JCWEFaaDRPSitobGFtemlkbmpkY1V0Y3Jt?=
 =?utf-8?B?cS85dXBBaDlTVHBOVG8vbCtHS1VkRFRrUHcwZWRpT2pTaFlpRWVzVGovY08y?=
 =?utf-8?B?VU95cUltYjJKWE1Hcm5RWnVrcWtQV0RZaDZ3TUFydDlWdVVoZnQvWTRnYzhJ?=
 =?utf-8?B?M3JubjJoMlZCMnkweWJJeElNK2hCTFhuM1YxekFoN2lzVS9XcGcvck00THJV?=
 =?utf-8?B?VGdGY3BUYklmeFNIbXFnWWR5aDhQZitQUDhTSzk1TmpOV0t4TGZmaXNrMytl?=
 =?utf-8?B?MlJENjJtSk1CdVRrcXIwM1lCYW9VYWJLbWZEeG5jTUM4QlI4NGpiaTA2OVlw?=
 =?utf-8?B?aFM4b1ZrRUJURFBrWTZhWXpRWGI1cEtJd1hHMDJwUHMwMVRBNTRhSVVwYitF?=
 =?utf-8?B?UkRaa24vTGlIT1VoK01hVythTjlHMmkvbVhuYzNIanRtTzVZOElVZWIrYTAz?=
 =?utf-8?B?ai9DRlJ5QnhFT0orR3lobnVJeitIdHZFL0wrNHpVZVJPRHFGaHZZd3ZYZHcy?=
 =?utf-8?B?UlZweTYxdjlBanBzTDFLdGkydWdLUUtYWGljb2lObnluU3ZqRTY5OEhaTk1z?=
 =?utf-8?B?VldLcGdRdkxGeXZ0VkFHVGpGVUNwU0x3TVpqbHBWMkxaS0s1Qnl0aVBLb045?=
 =?utf-8?B?cUtUWG4vWmdCaDdYNUZMM1c4MDBRQktERlhYZitCdEVXN2YxWlFqUVBqeVNQ?=
 =?utf-8?B?ckZhRXQ2TzI1S2pQOGw5ek1KSzJZNXI1N1FaZ2ZqUWVSWGdNZEdncmpINDJy?=
 =?utf-8?B?V3dvM0VLQzlFR1MvMTNKVkdTWEVJcm92bUdsZVdFdjU4cHpXWmZjenlaUVEw?=
 =?utf-8?B?cEZsbDVTQXRoMlUzYW4rQllvRkhVUTloOE4zTEs5VE1TOFVaeklNa01BdHUz?=
 =?utf-8?B?TGdKSnAyTzhXUnRobzdEMW51VnFDZWp6bHJDcUp2c1dDYXRDZ3d3WDRIVTM3?=
 =?utf-8?B?VjFMRW9JL0NXSmRuM3J1MU90RFB4enBNZHJwYWZnNVlTdElWOVlwZk5RbXlh?=
 =?utf-8?B?V1dXQmNNeU9uV2Y5bzFOVTNKMG1rNlBpczVBbTU0UEFHR1lHUm0yRVBRNmdU?=
 =?utf-8?B?bmdlZW5tSnEybXFQWTkxTHI0Y3FsbkJaR3NkL1daclFjbTVkaEdTMXAxRVpj?=
 =?utf-8?B?UzY3aW91R3Jtb09LaXBveS9wSGNqMHZaeXc5MVJlVlExT1hyVk5tOWNBcE1i?=
 =?utf-8?B?UzR0UVc4RFk0K3FoOGpzbFhkcnU5TjUrZ2FEbUZ6cHhtUlVRU2MxeUZ4cTFj?=
 =?utf-8?B?cDBsemRURFBoREtuU0VOQUhFQjc4WVRSajl0bDdLOC9EZEFadEgzVG1zbjVV?=
 =?utf-8?B?cGVwTCs2WXh5aWhzZm5iRWNROUcyakxQaFJPTFNCOUl3VG9zMTg5MnQ4ck9R?=
 =?utf-8?B?elRKV0NhZzBCUExyRnUxaGVIU000MFdsSVA1ZE0wVGphRnpOZjc1VWFUUy9q?=
 =?utf-8?B?MEpaekJVV24wNExydVlkaDUyZFdrckZuaWo5RkNwVlFLOVlaYTg0aU5VdTlN?=
 =?utf-8?B?Rm95QytqUlZ2TThzR0JGMG5UWlRwekFBd0g2MXE0ZVNyeXo2NjdubU5FWFpM?=
 =?utf-8?B?MnZzUXFGN1ZxaG1xYUFOcTh0OGZlQWg0VnY5cE1HbHBab0tiZVZqM0xFc3l5?=
 =?utf-8?B?YWhjdFZpTER4Z2NtOTNRU1puZ3VubTR5UXcwMkRuS0daNUJrSDVtTUxqZ3hV?=
 =?utf-8?B?c2xUdDJvNUhjdWh2ZGFnYlR5MkJaVnI2WmI1NVdCWi9BaXZpREpBaU1CTnZj?=
 =?utf-8?B?NmwvN1FaSGtSZkJkUWlPdlRBM29sY08ycjVUTFhvWjBjVXpqcUR0b1c2NTdM?=
 =?utf-8?B?NEtNdmhsTDlPMHF4TTV6OWJTWmNKMFlrM05KclhqQWdVUzBES0RseXpQdDlY?=
 =?utf-8?B?V21CY2dBNUEvSW1Lay9OeVg3VmdlbHhxRVo1S2dsbFI1L0xiblNjY0FDbjBW?=
 =?utf-8?B?S1NqWTBleW95bVhQbWlrUlJ5cXp1Rlc4SWRnRDF0Q0RvWGRvSDRlYk5peW1H?=
 =?utf-8?B?RDNNYWJyUVZmcXFWeityM0k3V0FOQ2FvdEEwVDliVGQveXRNVCtzVnRGaytE?=
 =?utf-8?Q?Jci4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 534a82f8-7099-482b-abdc-08dddf4ab3da
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2025 18:03:29.4136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n4gQ+/GYOdN5zhWzFocc6ilk9j+GHMKWsIPhxcPSjUj3bK3pNG0mYiF3lYZeCOqUDO20fowFp3cpPjJxhPVVdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7741
X-OriginatorOrg: intel.com

PiBGb3Igc3RydWN0IG1jZT8gIE1heWJlIHRoYXQgc2hvdWxkIGJlIDIgbmV3IGZpZWxkczoNCj4N
Cj4JX191NjQgYWRkcjsJCS8qIERlcHJlY2F0ZWQgKi8NCj4JLi4uDQo+CV9fdTY0IG1jaV9hZGRy
OwkJLyogQmFuaydzIE1DaV9BRERSIE1TUiAqLw0KPglfX3U2NCBwaHlzX2FkZHI7CS8qIFBoeXNp
Y2FsIGFkZHJlc3MgKi8NCg0KV291bGQgImFkZHIiIGtlZXAgdGhlIGN1cnJlbnQgKGxvdyBiaXRz
IG1hc2tlZCwgaGlnaCBiaXRzIHByZXNlcnZlZCkgdmFsdWU/DQoNCi1Ub255DQoNCg==

