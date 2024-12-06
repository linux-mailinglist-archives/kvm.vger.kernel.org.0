Return-Path: <kvm+bounces-33228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1DB9E783E
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 19:41:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76D6E167F4A
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 18:41:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C001DA0E0;
	Fri,  6 Dec 2024 18:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d08CB+Li"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DB4195FF0
	for <kvm@vger.kernel.org>; Fri,  6 Dec 2024 18:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733510467; cv=fail; b=B+MWcpLIOzRscQkHWfm4Fs/7nU+vAM2N255ZYc1H0uVEpVQIIKllxjMEufwDOPwiRh94ovVqSNU+g2UcPL/mFtCop4QZrjdDXmE15KmxnzpEX2dTe0E7vEr7WsAoG4ob1X0CzobQx5vdpMF/JGAKNH6jfW9wDbWirfowZ2yLbi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733510467; c=relaxed/simple;
	bh=rgGcwU0N84EomiNymklwNp6OJ7QsfYy8O3o9Zs1+ync=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hWW2wjJXogsmD+XC3703beij9HVzTPCMUHDBGzG8rg78bOfQRhRAMEx3UrRJH5sIMp+XdmNEaIqajx0HZpEjY6d+jHX5biwhZ0yXAd+cTzB6jxySoY39XLZJKfQWs3OX0asF9GreYVk8NL1TzAut++xYOwBrqDWtZvMYvNlnBcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d08CB+Li; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733510466; x=1765046466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rgGcwU0N84EomiNymklwNp6OJ7QsfYy8O3o9Zs1+ync=;
  b=d08CB+Lil6KB2E+PZjvUPOG9aUXm3RRZAYpVRY+banz8EOR47fX/32Ir
   myA2AtemFpYrrr7U7NvVjQCXndI0FVHoFB/n9adbCImcjoGhbNRhG9Zhc
   3Rnh/hCXokHW397bPGFlOglf/ZvHrscb4vVdYOcxFfRDwnmu54aCoruSI
   UXww3cum9xMwe25eGJ1G9JEg1UHsAqv4y3+cbScFL4BM177ObiUz7x9Qv
   07vKFdFBbvMLfR76Q+aHdrWQloP9qNsVNc6n7c3AhW27WjHF1VA45I9bX
   lsdElpczbGiKiIji7qGWXIUMpsxALv28+mMmb3SiBVtVoCA86Vny90S2r
   A==;
X-CSE-ConnectionGUID: syKdvrr+TW69NUFNzanKwg==
X-CSE-MsgGUID: 1W4A4eGRRp23ENGfvu+ctw==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="33756868"
X-IronPort-AV: E=Sophos;i="6.12,214,1728975600"; 
   d="scan'208";a="33756868"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2024 10:41:05 -0800
X-CSE-ConnectionGUID: KQkUc5puRxaqlcgqos8+Vg==
X-CSE-MsgGUID: TUXGBWGrQG+05qW8iEJfRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,214,1728975600"; 
   d="scan'208";a="98927952"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Dec 2024 10:41:04 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Dec 2024 10:41:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Dec 2024 10:41:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Dec 2024 10:41:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cjvI50RC3LGb9xPC2VhLRa37JllGpJSsuV24XGIQMFcpV/yG5vUcOpiCwFpuhL9/HwmKMU8LRHFD3rvpWKZerfIO4FO4pjt4nl3NAkW/rOG+eneaezK36VM+AQNNW8aBiKcU7AEY2Jd8nK+r5/ccTLiiv6JmKPgpYKwT+oYwi9C37Vk8iZIJh8o6HRITqVuyv7YDe7/LYYQsdxYAY26+Qea+HXmLkh+k1Hiu+epprtOZFrBdCTGFSC/Hkan8dkjA98mQIiL7KHK+WpXxI3EwGtS+NNBzsmtzFMFYyevlK30CsS3JuP572xvXbjRtM1h9nYaSUJA0qM6SSsYfq852gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgGcwU0N84EomiNymklwNp6OJ7QsfYy8O3o9Zs1+ync=;
 b=NKyatJTVc6lLIs+obFFXnQMVH3HHfOaNjWexJsVLEC1CgURViZIZbEEIlBX6aylbdfPVX1rQjA/MJD/pH9yuQMf2YXj3EmywmnggixhhJKypQV/QbzPquxmavJBDgV9TBwIwQ+dSpLmRovOgqLtzNEEsqmiBTUQsmgQ6Wh/QABs0ZFEJz9VYDMbyizrPn9Ohsv2+SpUbFZgEuEpQi+6S2MFPYVOP19J0Dp+KoGg6fwOJbpUDT+gkEi6dZwZ0tK8McQ4MwSofU1sYKdQzYqakmg/z00T41CjomryRhrC4URdVx/sq6dJeUYW6uatwPLIC690KvO8hWg7HPYsfFAkHMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7755.namprd11.prod.outlook.com (2603:10b6:208:420::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Fri, 6 Dec
 2024 18:41:01 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8207.017; Fri, 6 Dec 2024
 18:41:01 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Thread-Topic: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Thread-Index: AQHbR4iHazsMJxPtGkeCIJI86qO187LZjbkA
Date: Fri, 6 Dec 2024 18:41:01 +0000
Message-ID: <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
In-Reply-To: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7755:EE_
x-ms-office365-filtering-correlation-id: d5e79e5a-eb32-4bb2-ecc1-08dd1625884c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018|3613699012;
x-microsoft-antispam-message-info: =?utf-8?B?MzEzaUxyQkFWZEM1VTEwSXdWV1hvVFp6WlA5RGYzejg2VklLRmVXMm5rVk5V?=
 =?utf-8?B?MVNHQ2tYZ3krN3VxNWU5RlIyUmpOWTFYeGxwOVpQZWpuQmgyOFpxZWFjRy9B?=
 =?utf-8?B?cS9LeTk4dklQQlFxVU5neWZOajFPV3RuenlLc3Z0Q2tvM3JqNUJpVndRN01l?=
 =?utf-8?B?bmxKZ0l5WWlSRzZSSFZCVTIyYmJIeURxRHJVR3NSc1ZhWm9OZjMyR1Z1Y0xj?=
 =?utf-8?B?QVlQM0p1MjlyVjVMdDdwQStZUVNHV1lYdWVDTXI4a0tpS283bGVZdE55QVJL?=
 =?utf-8?B?Q0VoblRmcktRUVZYREgvNm1YZXIwOEtKV0RWaWpVVVhsaUlFUGo1ZW1PZDBO?=
 =?utf-8?B?OEFNajY3b2prQnlva1R4eUZIWTZqWVVLUXg0V2JKYjNYcW9FV3BsMVJlWmxK?=
 =?utf-8?B?ZzJmTjFsOUl4cEJIeHNmRnBrOHp1Mkhzbi9ZNDVEZzNKZllxUGdkR2lmNFg5?=
 =?utf-8?B?SjdnSm54bWRCc25BK0pXeHczRTZVZ0dzUlhVZU1NRW5jWG5vMHYrdWt3QnZ5?=
 =?utf-8?B?N1hvL3YvSXdLM3pOdGFsZEFmbVdMMlpnVmN3WGRzSWVLWUhqck1vZU1LTTUv?=
 =?utf-8?B?R3A5dnp1bVNYeGhBN1JCd3NBaGJWaExKMlg5Uy9EVGJlZEhnUCtuRDZiMFdM?=
 =?utf-8?B?M0MvdTFZbHg5U3JwRDRwUWtVSDBESVUvU0gzT255WnVxNW9iS1FzOXpFR2FP?=
 =?utf-8?B?VHFieHdvWW9oOFJqdXNRQS9zaFg2aVRvRjNvUWp5UU5VY3JUcHZsSlFaM1Jt?=
 =?utf-8?B?ODJaTnM1cy9EZVZmTDlZMlFvYVJoejVlU25CTzl5WTkxMXFGZ09ubGRXNnlh?=
 =?utf-8?B?d0w5djQxRXFCQWdnQldMenBDTmI0bzV3c1J2Y1hzcG9tRXlZT2t2NjJZdjdH?=
 =?utf-8?B?VlNCWjFGcG1yMUtOblRtQS9ra3F0WkxZRWhCWkdMeVY3T3RSNGVtRzR3R01O?=
 =?utf-8?B?TStQRFhaMEFHQllTdWdnREJoa25LbGRqZzFXbkErR3VBL3hraHZmcXVLN29S?=
 =?utf-8?B?REZzaUhld1BpTVN2aE1YeTAwdUNKNi9VTnFZeSt3c3JNVWhDSFRiSlRPNkV6?=
 =?utf-8?B?T3VjTUdVL21PMUxIazY2Tk5hMlcyaUV5ckZRY2JaWHNkY244amEra2F0R2Nu?=
 =?utf-8?B?VllkU1REOTlJMERySFNkZzQ1UXk4V05POHE4YkVLM2VjR3J2L3dRZ3U5VFVs?=
 =?utf-8?B?dWFCMC95bzZqdE1HWWVjWFc4MFAwdWFTaDFvanVmdk1yNS9HTG9CUEdjTkxi?=
 =?utf-8?B?cndPek93amlyYkpDcEhUcE5Ed3hicDlnUmJUcUpyR1VtcFZ3cmkwZHZqSStI?=
 =?utf-8?B?d2tHQkFxRnVZSkYxcVhPNXlJd1d4bEl2bmFCa1hFNUl5TVExemdOdW83cDEr?=
 =?utf-8?B?cXBzODBXOVdjQTQycVpHWUZiUjJpdGlqUmREZ25wcVZpaUVrajB6NVlrcDl0?=
 =?utf-8?B?TlBVbHhKUUhWSXFDZTZTMXl3ZURJVHRqWSszU3pMM1pGVmpZWEtMbXY4MXYz?=
 =?utf-8?B?SFh1dnpnR1JFTjdUY0czdVdCK0JZeHJETEdsZWkwT3ZOZ2tOQWtVQmdUQUtX?=
 =?utf-8?B?Y0FSZ2NCc2xpaGZZVVRsZ2FleXI0RFg4b0tQRFloOWkxSmhwdHR3b2k3QUJK?=
 =?utf-8?B?Y05xU1FSNno2ZG9WL1BHcFZ0eDlmZU5oNW4rY1VLczI2RzhCWmZjdmNNR2ZG?=
 =?utf-8?B?bTBCN1JJanFyZ25aZ3pnT3ZteU0wSGd2c25GZ3hHZGhXSWZQNDB3bEp1Z0ZI?=
 =?utf-8?B?KzRVZlRsZzNVSUVzZi9ta25QcnBET3IzTnBYYWlDbTM4YmVHdno1THdYcXI5?=
 =?utf-8?B?d1FTYW5MbjhpWHJqOWN3Z2NvdEQyWmd5blhCMkRmWEN1M3JGRllqZWEwOFFX?=
 =?utf-8?B?Q0NNMmVkbDErT01Sekdqdkh6Z1NiTHNhaFF6SmFxb2xDS2JUelBtOWxsT2FJ?=
 =?utf-8?Q?04o59/OeoDw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018)(3613699012);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDBRbzU1RVlLWkIzeW5VOFU0ck1Qb2tpMDI2U0VjaWRrV281Yi9BWTJ5Mjcy?=
 =?utf-8?B?cDZBN0JpbnN6RlhXdXpEVlRIelBUMU9YaWwzZWl4Zkpvb1E3S3pCYjNZWjBD?=
 =?utf-8?B?VUlhK3FSQTVBRHBRenJZVjlkREQ5TE1xK0cyRnllTE9qQ0l4OTJIYUJ3UlBE?=
 =?utf-8?B?ZjZCc1VYVld5WCtNaExPQnA0dzNmOUVHQVhVZ2ZxZnpuOWdNMHpKYjZtQkJ3?=
 =?utf-8?B?YW1Ha3JwVjBDcVZuZU1ralFyMi9SNFVOejdVWEtMZ256aFdGNjRUNm1xbHVC?=
 =?utf-8?B?Nlh3MFdNTHZhcXVkb1UxYTNmb2FSQnZqWnpzaGY3MzgrdXFqVWNFTmtGSWFB?=
 =?utf-8?B?VmVkTnNqNjByZWozZ1Eya1ArU0FMeUIra01YZElVWmJVMktqM0g4SUhtZmN0?=
 =?utf-8?B?U3FxZTN4UGxOQUZZalBOako1cUREUUxvQ3VRb1lhVEU5WFgxVkMvS1JKczdS?=
 =?utf-8?B?OHVtOGtuU2QyTk9UeFBnQlRBUGFKVm1OSk4zeHlWTkl6SWlkMHYrRjczVUFq?=
 =?utf-8?B?NFl0TWI3N0ZMODNkNWNOc1F1UU9ENk1LZEY0OXpXZUM2RG43S3U5Y0Ivd24w?=
 =?utf-8?B?Y2Q2YjlMU0RXaDc2TjhvaHpsSldJby9HQjJvaENNSGhUd0loQjRCTk9iRFZ5?=
 =?utf-8?B?ZStjQzZkcUtiTjFKQkZJRkQyNWJBcXNDemVHei8rMDJPWGhlcXFCUVE1eERD?=
 =?utf-8?B?SGFPamsyMFZnUk1JbG1lSkgvZmNGbXdkRXpOekUzd1VldVhEZ21oTXhrYklB?=
 =?utf-8?B?Qy9HM1FGdzR6SzJvMHVwNHROMnM5QzY5cW9JczZiUGxmM3NSY1c2bk1uazli?=
 =?utf-8?B?RU9PcjVqNm4wenZpSDBWZlNoMzVobXJGeGlBR0VIOU5MYklmcmJFU2dCYWZ5?=
 =?utf-8?B?NGNSUVdSVlZRVGJ2NDg1Nm5keUl1ckJWSGJqWU92VllFNWc5Zk9jUFpTZVdT?=
 =?utf-8?B?M0hZUkxEK1A1bHVxbFBZOWtOV3lObHE3Y3hFVFJLTUQ0VlpEbDZ0dllxdWlx?=
 =?utf-8?B?T3hONlFHLzZkcWtCNnNXZFJ2ZmpEcWFZZ1lKR3FiTVJNb21EMmQrRGV3eFEy?=
 =?utf-8?B?cC83M2JWcUVyeDFOaTN0djVQdTZSdHByZjBGSmlMTFdXZjZySW12NWNpZWxl?=
 =?utf-8?B?Ritmd0dXSlM3U3p5NU94bEJtYWV0U1NSUUpBSzlVK3VuSHJrRFkwREp2dmNB?=
 =?utf-8?B?TXJ4N0JFOVk5RnlzbjltMmtkeStWWXBGNzhYWU42Uk51bjl0RGZ2UE9CR0J5?=
 =?utf-8?B?NzNtN2hDOGs5MS9FTktsZlhldFBLZnpuV1ZhRG90Tk5iVHcxMHg2NVRoVXoy?=
 =?utf-8?B?RDFsaitXdUhDTHk0VktxWFZ6RlJPN1RDOUpmS0E0RkQwRFhNZ1ZiNHMyMUVj?=
 =?utf-8?B?ZGs0YzFoOFAwdGtXQ3ZZVnk4MC83bWQxdU1kd0wyVlVCaVUwcG9tRVNNRDVQ?=
 =?utf-8?B?WnpNL0t6MU1yWDlVb3lGcG40cjdYQnBTSTNDOHFCWStRSzVnNXMyN0tBaWE0?=
 =?utf-8?B?Q3Rjc2UwdG1SUXFkWmUzTDErWUFZYTlWQW85c2FKOXROS05mUlhhVS9uSWZT?=
 =?utf-8?B?RDg5dEhzTUZITlNZbTExeEVpc1J4cmQ5MHFjRGdCdTlJQmc1QU5ZVThmdVpt?=
 =?utf-8?B?SDFTY3g5ZUdjNFBLZ1gybjZuRTZqcFQvdWV3U1lXYnd4ZGxQTmVkZTJGUXp0?=
 =?utf-8?B?ZHlvL3VmVm1qMHlIVUVXT0pneHR5WWVnREVabEE0dDdxTEVSOWN6UGxpVzM3?=
 =?utf-8?B?NDRVSFZZWTRBQ1ZiSzlsdXpJUnJyWmdCK1c0Z05kaG5EcExPRWQrb25DYTBm?=
 =?utf-8?B?citqWU5vcGU0VS9oMC9haTVYMVN5bm0yTm1va01iUXNBQ1NCaXpVRk5WVTF0?=
 =?utf-8?B?Y3kzK3ArVHZUbkltR01vYW84OEhBdjNaTFB0UkFuSVpVLzVWK3RMNW8va3dC?=
 =?utf-8?B?RERXeWpJNXl6L2c0d0dyNW0xQUVSdGt3Niszb01lM1R0ci9jWk1Wak1HMDZR?=
 =?utf-8?B?ZTRWd2VSK25uVC9hcEJ2VWwzVkp4TzBzMVhQbWZOaHJTR3N5Z2FXOVF1S3RS?=
 =?utf-8?B?djlLak9jNDJHcHZzbFdnaUNwdzh6enIvMC91MEwzUXM4ZjVaVWdRUEE1SStE?=
 =?utf-8?B?TEtJVjJEc0tZV1NzMC9pWlVGcWtKbmlCSTNadHI4QUUzdE5hV1JJYUhLYlls?=
 =?utf-8?B?Nnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23B1509539E45540AF5CEC49D95A49C3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e79e5a-eb32-4bb2-ecc1-08dd1625884c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2024 18:41:01.2618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Icfx5n7p5bb1k6ChIdepHgUigLsoG5JDia4X5cZSvXxJ8R5+ENvkP5ZofgJ/iuK3Pu4J5ML8BcFrYU4dctHw58VvAh01aiNYRHhESn3ugCU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7755
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTEyLTA2IGF0IDEwOjQyICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiAj
IEludGVyYWN0aW9uIHdpdGggVERYX0ZFQVRVUkVTMC5WRV9SRURVQ1RJT04NCj4gDQo+IFREWCBp
bnRyb2R1Y2VzIGEgbmV3IGZlYXR1cmUgVkVfUkVEVUNUSU9OWzJdLiBGcm9tIHRoZSBwZXJzcGVj
dGl2ZSBvZiANCj4gaG9zdCBWTU0sIFZFX1JFRFVDVElPTiB0dXJucyBzZXZlcmFsIENQVUlEIGJp
dHMgZnJvbSBmaXhlZDEgdG8gDQo+IGNvbmZpZ3VyYWJsZSwgZS5nLiwgTVRSUiwgTUNBLCBNQ0Us
IGV0Yy4gSG93ZXZlciwgZnJvbSB0aGUgcGVyc3BlY3RpdmUgDQo+IG9mIFREIGd1ZXN0LCBpdOKA
mXMgYW4gb3B0LWluIGZlYXR1cmUuIFRoZSBhY3R1YWwgdmFsdWUgc2VlbiBieSBURCBndWVzdCAN
Cj4gZGVwZW5kcyBvbiBtdWx0aXBsZSBmYWN0b3JzOiAxKS4gSWYgVEQgZ3Vlc3QgZW5hYmxlcyBS
RURVQ0VfVkUgaW4gDQo+IFREQ1MuVERfQ1RMUywgMikgVERDUy5GRUFUVVJFX1BBUkFWSVJUX0NU
UkwsIDMpIENQVUlEIHZhbHVlIGNvbmZpZ3VyZWQgDQo+IGJ5IGhvc3QgVk1NIHZpYSBURF9QQVJB
TVMuQ1BVSURfQ09ORklHW10uIChQbGVhc2UgcmVmZXIgdG8gbGF0ZXN0IFREWCANCj4gMS41IHNw
ZWMgZm9yIG1vcmUgZGV0YWlscy4pDQo+IA0KPiBTaW5jZSBob3N0IFZNTSBoYXMgbm8gaWRlYSBv
biB0aGUgc2V0dGluZyBvZiAxKSBhbmQgMikgd2hlbiBjcmVhdGluZyB0aGUgDQo+IFRELiBXZSBt
YWtlIHRoZSBkZXNpZ24gdG8gdHJlYXQgdGhlbSBhcyBjb25maWd1cmFibGUgYml0cyBhbmQgdGhl
IGdsb2JhbCANCj4gbWV0YWRhdGEgaW50ZXJmYWNlIGRvZXNu4oCZdCByZXBvcnQgdGhlbSBhcyBm
aXhlZDEgYml0cyBmb3Igc2ltcGxpY2l0eS4NCj4gDQo+IEhvc3QgVk1NIG11c3QgYmUgYXdhcmUg
aXRzZWxmIHRoYXQgdGhlIHZhbHVlIG9mIHRoZXNlIFZFX1JFRFVDVElPTiANCj4gcmVsYXRlZCBD
UFVJRCBiaXRzIG1pZ2h0IG5vdCBiZSB3aGF0IGl0IGNvbmZpZ3VyZXMuIFRoZSBhY3R1YWwgdmFs
dWUgDQo+IHNlZW4gYnkgVEQgZ3Vlc3QgYWxzbyBkZXBlbmRzIG9uIHRoZSBndWVzdCBlbmFibGlu
ZyBhbmQgY29uZmlndXJhdGlvbiBvZiANCj4gVkVfUkVEVUNUSU9OLg0KDQpBcyB3ZSd2ZSBiZWVu
IHdvcmtpbmcgb24gdGhpcywgSSd2ZSBzdGFydGVkIHRvIHdvbmRlciB3aGV0aGVyIHRoaXMgaXMg
YSBoYWxmd2F5DQpzb2x1dGlvbiB0aGF0IGlzIG5vdCB3b3J0aCBpdC4gVG9kYXkgdGhlcmUgYXJl
IGRpcmVjdGx5IGNvbmZpZ3VyYWJsZSBiaXRzLA0KWEZBTS9hdHRyaWJ1dGUgY29udHJvbGxlZCBi
aXRzLCBvdGhlciBvcHQtaW5zIChsaWtlICNWRSByZWR1Y3Rpb24pLiBBbmQgdGhpcyBoYXMNCm9u
bHkgZ290dGVuIG1vcmUgY29tcGxpY2F0ZWQgYXMgdGltZSBoYXMgZ29uZSBvbi4NCg0KSWYgd2Ug
cmVhbGx5IHdhbnQgdG8gZnVsbHkgc29sdmUgdGhlIHByb2JsZW0gb2YgdXNlcnNwYWNlIHVuZGVy
c3RhbmRpbmcgd2hpY2gNCmNvbmZpZ3VyYXRpb25zIGFyZSBwb3NzaWJsZSwgdGhlIFREWCBtb2R1
bGUgd291bGQgYWxtb3N0IG5lZWQgdG8gZXhwb3NlIHNvbWUNCnNvcnQgb2YgQ1BVSUQgbG9naWMg
RFNMIHRoYXQgY291bGQgYmUgdXNlZCB0byBldmFsdWF0ZSB1c2VyIGNvbmZpZ3VyYXRpb24uDQoN
Ck9uIHRoZSBvdGhlciBleHRyZW1lIHdlIGNvdWxkIGp1c3Qgc2F5LCB0aGlzIGtpbmQgb2YgbG9n
aWMgaXMganVzdCBnb2luZyB0byBuZWVkDQp0byBiZSBoYW5kIGNvZGVkIHNvbWV3aGVyZSwgbGlr
ZSBpcyBjdXJyZW50bHkgZG9uZSBpbiB0aGUgUUVNVSBwYXRjaGVzLg0KDQpUaGUgc29sdXRpb24g
aW4gdGhpcyBwcm9wb3NhbCBkZWNyZWFzZXMgdGhlIHdvcmsgdGhlIFZNTSBoYXMgdG8gZG8sIGJ1
dCBpbiB0aGUNCmxvbmcgdGVybSB3b24ndCByZW1vdmUgaGFuZCBjb2RpbmcgY29tcGxldGVseS4g
QXMgbG9uZyBhcyB3ZSBhcmUgZGVzaWduaW5nDQpzb21ldGhpbmcsIHdoYXQga2luZCBvZiBiYXIg
c2hvdWxkIHdlIHRhcmdldD8NCg==

