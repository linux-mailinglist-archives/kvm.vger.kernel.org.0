Return-Path: <kvm+bounces-13332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1329A894ABB
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 07:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9405D1F24616
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29AC182C3;
	Tue,  2 Apr 2024 05:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TtldvYer"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260FC17C7C;
	Tue,  2 Apr 2024 05:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712034113; cv=fail; b=cwllzD4SjjHKGcweu0s2F6f/g6f5PyVjMO+1h8r6xEh1LHW91KIFNMam0DAax2bx3sraNCd6NyIP9cqWlXqN4+UAHhlTxfiDdAMiUoCRruvKhE5CkPH1bozxQO73Au8ALe+AlGPHjSW0KDh9zTWrPP0nZHkLtkjwk3W/dRKxjF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712034113; c=relaxed/simple;
	bh=A+9HuYjriOSEh3drnKMb1eWAfpUqDvDBDaKSMRH9Qg4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=btWSIk5d4WPe1zz68GXZPyaNt4ARUkOG+JXO0u0Mt90YAxX1SSoBsEmRjXeCIxE8O4dmfSk6Q7BE/mJft3JR60DxVIppup8FztApdvbCJE+7hFpnjr5ohM3BtUal7DnidlMjHcRpLvQMxGuHvKpW9JOH7cbf6/Jkf15P0s7XZSk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TtldvYer; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712034112; x=1743570112;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A+9HuYjriOSEh3drnKMb1eWAfpUqDvDBDaKSMRH9Qg4=;
  b=TtldvYerOPtSzzzCGElk0nh594QBfc/ZfCn8TQcbOVlP5ltXjwrzzvhu
   eDz2q3jjxNPSijgDhzto2Aa0LU+FyDdMDcGC+OnFzLNdEx9xwDj3SABQr
   qf0o5Z3ll+QLxW+S4cCrF7kSY7kGfgRSmU9y37GMz/7nW2u66TkFb9pVs
   1+bdXUG6045E8eZTSFC1UYDZ7w9L1Yp64i/1XDf9/UY94ZmGOXyg+ht/+
   5sM/2CkMSVHTkfuZTsSWSWda41hY91IX/tkijyFLLUYqEkSI+0X1+ncx5
   Q1DCJET3CvNNFQ+Y2bHrhfP2ek35uaFUuloMXVM9ghQIiisbRXRUOf/5q
   A==;
X-CSE-ConnectionGUID: 3Ryy5l7QRW6ZgidhAbrA5Q==
X-CSE-MsgGUID: zL9fNudoTzyH5QXGdW/YEg==
X-IronPort-AV: E=McAfee;i="6600,9927,11031"; a="10967277"
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="10967277"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2024 22:01:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,174,1708416000"; 
   d="scan'208";a="55389539"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2024 22:01:51 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 22:01:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 1 Apr 2024 22:01:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 1 Apr 2024 22:01:50 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 1 Apr 2024 22:01:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOYSaDocbd2IW61VOnMbwyaGdaLBAeCWfSGzq63ehpD002a7VlyblmnnwtdWRZX/Kl3N/0n+HCCPDEwAKQ+74IkaOKfxgOwwOsyN/glPy0gi85HB9ArTzj9ICmqHwcfoZYT0Wrao17EqWUHkjh6dvmpucMLrd0chgbjf2BQpLfWkTyfbz6nqiaedJ0fRXX58+Lx2lgzb/Wpn28AUWjj2NOvJhCpBfZYLaeez1oSdToxH4k9n6WYmm5Z9otOR0bo3Qn4G8PL0mlHZhvYIimgl960z+g1awXa7hESNUMVZ3uAFueItC8+7BHmuurPSZjsv/z7LFH4pM3VKRWDPYh86wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+9HuYjriOSEh3drnKMb1eWAfpUqDvDBDaKSMRH9Qg4=;
 b=UGEvBeQuc+fxgJIKB2XmqY+OCz5NlbZDbH01L5hZxiOj63+oVzGoKSbB3pSThbzbVF+MnC9oks6jkyzFO7S65N7f5IIJ4YfbRf9cn3CoU0ewQ7R7MNBnqVD+nucCjWkdKRtwgVYmgZzir+HXzKfoU5TltfzaMu5M7TibTDDWjTCs3iGFQAoOCzh+crRO7KmHsJQJvvmCUo+L4vycr4RgWoLhkFRIIey85x1s+cp6m3I9t2RPrpA3LFba7UgEZKJDXUtmq7VxRtzJ+37JJcyKQZ66tTaLfyIAalDl6bSO7XcwneHIedkQRXQMOSOiCtQvtc+z/0SmmRBzlnjKZrAKTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by PH7PR11MB8035.namprd11.prod.outlook.com (2603:10b6:510:245::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 2 Apr
 2024 05:01:43 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::1d15:ecf5:e16c:c48e]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::1d15:ecf5:e16c:c48e%5]) with mapi id 15.20.7452.019; Tue, 2 Apr 2024
 05:01:43 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, Sean Christopherson
	<seanjc@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Kang, Shan"
	<shan.kang@intel.com>, "Huang, Kai" <kai.huang@intel.com>
Subject: RE: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
Thread-Topic: [PATCH v6 4/9] KVM: VMX: Move MSR_IA32_VMX_BASIC bit defines to
 asm/vmx.h
Thread-Index: AQHaccET9zfa++2ePEy7c+UBb65GX7FTFAkAgAF5EWA=
Date: Tue, 2 Apr 2024 05:01:43 +0000
Message-ID: <SA1PR11MB6734752BAB8F6E77FE6F9082A83E2@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-5-seanjc@google.com>
 <05484613-0d02-4ab6-a514-867a0d4459bf@intel.com>
In-Reply-To: <05484613-0d02-4ab6-a514-867a0d4459bf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|PH7PR11MB8035:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O0ezfW2kl3IavdhMTf43hFHhizvapU6eb7RXDmCSGS83gXKtvT5XYBzba2MpvaM8kykNXPlWDL2MzbxksulFC3IDAA6j5XszGQAnJJwKT7IM/i1lJ+qNnCx0GPtDjRvyul26nl/fs/hAdRgxzz9X9lNgIaJLd277NHMZunlIy4dTrdmPJ62feBbOSL4GAZZNvfgyN0ZhslkJTvv1oxqTBqtmLfERnh4WQ1OUWlmesH1mruhNADjbCx8O/DOy1/nv8jiDxqlgWdNpE+erGRQx3zM2MCJmWhorxjV/jZgHemW/1nlPWbMsS2uZ/8idSX7Twbztsa4p1jBkxumd2FSP8eoDsJjTkoLdHE0Gcs5Bk2a3PqwuQTGftFEYd9yIAKaeJDQQom/uP9dzTebsB47jGDoDUn+jL7GbhEw6Vcuh109xBdXmo9vpqEsvSFjb1wDpEx6Kpw6krxjwkyEhP8qxou0EH3wGRNhcETyBZTCg6qwCotcVGWtqqX38W/rLvQabcpgxe20EWY1aqXrfEvxo7dA//ffggdkwHk25cd7U3tGaTLfILqv1apJ2fZQLH3p2dSC/bCFPL2qG+UWdc9KkFWo5uFHsmM8x0y5tpO0HIapzjHcfcb02U7+AgZTYsYELsPJBd3/Y45M2esIyUSGo7GEnbtmmxV7mr+B9qGay6iF6ya7FKzOmug3AiBd+/nx3iqHINOrNW4J/dFwmmfEZiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(921011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YUUyTTFNeUx5RWUrelNnOWNyWXhkWDR1VDBHUkpVd2Q4NWJTMi9ZQTdpdlhu?=
 =?utf-8?B?M2FaeFZmeTNISWVpeGE4MnhJZ0kwOFVGcVRZS1RhNFhFSTdjRmY2UlNSdmhX?=
 =?utf-8?B?VDU4dWZtZnJsZnN5YTlPalZCWjJGUWZWcHlzWmNxVXdoVitXT1Q4MHAvVEor?=
 =?utf-8?B?VnlKOGJoaW5NNjZjbHFHbXBucXZWc3h6U0ZPeHZLeFF1dUQyR1d2TTU0ZGha?=
 =?utf-8?B?QkJWODc0OERzZ1lOZk92OVZzeURMVkhEUi8zV2dXQktyeTVZbEwyRzNsWlRu?=
 =?utf-8?B?SDV5Y1hBamc0Ri9la1BiZEl2STM0Um9ETVlTYURBWk1HKzFIS0VFWEMzNytE?=
 =?utf-8?B?UnIxU0grN0ZNYkxRbnJISlVhUXphanVrY3gzOEE0QzgwR1hmcGdBU1RCMXlI?=
 =?utf-8?B?UkFORHRzSDV4WTB6NGRpZzZFYmE1aEdYcDdXUzZvRjBUdjlYWFFuM0dlWXFj?=
 =?utf-8?B?eHlobCtwYlhQSXZ2RjVGTHp5VXV3cFYrWXVoNGJOUC9SWVRZeVU1S1gvbmYz?=
 =?utf-8?B?VXE4bnhGSXppZVFrSHF5YnBCZUQ1TS83VHpPa3VLSWp4VDVJQi9YNTFvS21M?=
 =?utf-8?B?YmFuNVh3Y1VEdHpncHArRkgzaTRqUjNzSk9JdmxTNWtrM3NHVmFxSTYydm1v?=
 =?utf-8?B?N3l4WCs3cWU5bzlLUGZ4NVpSSXhFSFl6Y3pDT2lObXQ3QW4zTEVyaEo5UkdM?=
 =?utf-8?B?YzEzQm1PWGRBT3VSWmk5UXFCR2hNcytSQWd1UkhOaHR3ci8vVkFjME1hV0My?=
 =?utf-8?B?dEtjNXYzNEcxejZPdjJUVGF3OUVjQTg5eEpnS3YyMk82QjFZVG80TEYybGgz?=
 =?utf-8?B?aDYxWElVRjBJaUdjejRMb05YL3dXOTljNit1L1pPU09BclIwTVIzbDZFZTlO?=
 =?utf-8?B?dmlVV1BNUFNJaUZEdXN6Z3A2UnNXRytPd0c1VTNJeUdlNE5uek5lQmExQmJD?=
 =?utf-8?B?aXhxOUhKTEJUakhCbzgxdkZDZ0pkcWFXTnVwaU5VeGpCSU1YTXdZQ2lXZExU?=
 =?utf-8?B?WGVUM092OVZUNjF0Wmt3T1RzY0pmS1F5dzZyV2swbVl5ZGNUVWt5NzU2SWha?=
 =?utf-8?B?SCtOb0Q0TjhnbW0wOHh3M0tlRUJhV3Nib1lFdWZrZk01NHJyc1ZKbk9mUUxU?=
 =?utf-8?B?ZTVOSk9jNjJiR0NoaktvdEhjMXphbVRYU3UvbGM1S3MyOFIrVmx6MHgrcDN0?=
 =?utf-8?B?RWpKQjBmeTNad3o2UEoyZkZ2RFVZcytQZldNNllwL0NyYysyWVJVMmlhVWZm?=
 =?utf-8?B?c3FBOVU1YkFLUGlEM2ZmWFlwMTZiYmdsRFZrcEsxaFVRWE9rdlR5NVB3T1hL?=
 =?utf-8?B?dGl4cGRpL1U4R3p4Wm1Fb1FUYzk3ZWE2UGszT0piNllQQUZEMFRWMWZMUElK?=
 =?utf-8?B?TUNMclV1d01zdnc4VmR1aHdOeE0vTUp6K0pzV3J1cXpQdVl2RlpIeGZidUFW?=
 =?utf-8?B?RkZTUlhwRTJabGRYTlZabnV0YUNHYnZIclE2R3JSWTZrRkNVbTBBZEE2c1dm?=
 =?utf-8?B?dXNOaDlEV2Jra3VYT3RuL0xka2VPU25tV1I3OUFScElzSEJ4QnJrYU1odlFn?=
 =?utf-8?B?SVNQQ3FtREJZa1p3VDJlU3RiUFRqV2lVajltdjc4d3BLTGZ5VU1KN3BrYnVQ?=
 =?utf-8?B?N3lOSkJJT3MyQlR4MkpJV2NZYkxSZzhJdk5EWGFyaHZaY044eElTV1pjdGZ5?=
 =?utf-8?B?Qi9yWnMvQkJkeHd1blFyTGdVL00vSGlOUEp4dTk4VnJhM25oVUNhbGdhTEdT?=
 =?utf-8?B?T3hST24wTHNmR25mSlAraHMzS3QwS2txK1l5N2ExRUZTd0JXRGFxWHV1OGhQ?=
 =?utf-8?B?R29ZZVBRckJST2xOZ2RHbGkzTTQ4YU5hSHJUNW5kdDgvL3Y0TmE1OS8vZk1j?=
 =?utf-8?B?Q1dWODFaVkY4bk9OSjh3ck5tcSsxUkNyVlJCSUNXc2dvUURGTzRVeUhJZSs2?=
 =?utf-8?B?TFNFVFc2YVhWWDN5T202enlsQkRzeG81MmRmdnJPU0FQdjJaUWIreEVUNXRn?=
 =?utf-8?B?dlQzY09ZR21HTkVSNjdLZ1o3U1l0cHVrRTBQU1R3eDBMa1FManNCVWo0TGlr?=
 =?utf-8?B?aVE2ZFZpa3JpZUxlcSswVkMyNGhTZHd4ZzA0dklsMk5PN1dUT2xieU11bXZ2?=
 =?utf-8?Q?0X3A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb00b981-603b-4e9a-cb64-08dc52d1fd56
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2024 05:01:43.1526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tk76CS0d7laVvzpxcOs0PDxd+QS/ripabYtRxBUCc4ugpeZ68S2CQFxVRTXY7ASeOM//pV06UnWH85hfGG49rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8035
X-OriginatorOrg: intel.com

PiBPbiAzLzkvMjAyNCA5OjI3IEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPiA+IEZy
b206IFhpbiBMaSA8eGluMy5saUBpbnRlbC5jb20+DQo+ID4NCj4gPiBNb3ZlIHRoZSBiaXQgZGVm
aW5lcyBmb3IgTVNSX0lBMzJfVk1YX0JBU0lDIGZyb20gbXNyLWluZGV4LmggdG8gdm14LmgNCj4g
PiBzbyB0aGF0IHRoZXkgYXJlIGNvbG9jYXRlZCB3aXRoIG90aGVyIFZNWCBNU1IgYml0IGRlZmlu
ZXMsIGFuZCB3aXRoDQo+ID4gdGhlIGhlbHBlcnMgdGhhdCBleHRyYWN0IHNwZWNpZmljIGluZm9y
bWF0aW9uIGZyb20gYW4gTVNSX0lBMzJfVk1YX0JBU0lDDQo+IHZhbHVlLg0KPiANCj4gTXkgdW5k
ZXJzdGFuZGluZyBvZiBtc3ItaW5kZXguaCBpcywgaXQgY29udGFpbnMgdGhlIGluZGV4IG9mIHZh
cmlvdXMgTVNScyBhbmQgdGhlDQo+IGJpdCBkZWZpbml0aW9ucyBvZiBlYWNoIE1TUnMuDQoNCiJp
bmRleCIgaW4gdGhlIG5hbWUga2luZCBvZiB0ZWxsIHdoYXQgaXQgd2FudHMgdG8gZm9jdXMuDQoN
Cj4gUHV0IHRoZSBkZWZpbml0aW9uIG9mIGVhY2ggYml0IG9yIGJpdHMgYmVsb3cgdGhlIGRlZmlu
aXRpb24gb2YgTVNSIGluZGV4IGluc3RlYWQgb2YNCj4gZGlzcGVyc2VkIGluIGRpZmZlcmVudCBo
ZWFkZXJzIGxvb2tzIG1vcmUgaW50YWN0IGZvciBtZS4NCg0KWW91J3JlIHJpZ2h0IHdoZW4gdGhl
cmUgaXMgbm8gb3RoZXIgcHJvcGVyIGhlYWRlciBmb3IgYSBNU1IgZmllbGQgZGVmaW5pdGlvbi4N
Cg0KV2hpbGUgdGhlIExpbnV4IGNvZGUgaXMgbWFpbnRhaW5lZCBpbiB0aGUgbWFubmVyIG9mICJk
aXZpZGUgYW5kIGNvbnF1ZXIiLA0KdGh1cyBJIHdvdWxkIHNheSB0aGUgVk1YIGZpZWxkcyBkZWZp
bml0aW9ucyBiZWxvbmcgdG8gdGhlIEtWTSBjb21tdW5pdHksDQphbmQgZm9ydHVuYXRlbHksIHRo
ZXJlIGlzIHN1Y2ggYSB2bXggaGVhZGVyLg0KDQpCVFcsIEl0IGxvb2tzIHRvIG1lIHRoYXQgc29t
ZSBwZXJmIE1TUnMgYW5kIGZpZWxkcyBhcmUgbm90IGluIG1zci1pbmRleC5oLA0Kd2hpY2ggYXZv
aWRzIGJvdGhlcmluZyB0aGUgdGlwIG1haW50YWluZXJzIGFsbCB0aGUgdGltZS4NCg0KVGhhbmtz
IQ0KICAgIFhpbg0K

