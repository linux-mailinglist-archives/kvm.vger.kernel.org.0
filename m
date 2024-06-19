Return-Path: <kvm+bounces-19920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2F9990E277
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 06:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E6D428436D
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 04:58:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D428D4C630;
	Wed, 19 Jun 2024 04:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cMfzwfo4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C44C1CFAF;
	Wed, 19 Jun 2024 04:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718773108; cv=fail; b=DkSV8UmRpgdz0EM2jw09hqjGB2yF7kI4aFqFQ650AE9ZnuzRSe/0QJO6RBVRDLR2ePnHoEs1Mp52VjqYAXIFH0xAIelMWygLbu2Y77WC2fAdN6ZZ63Qwos/0VfcLkDseVJWV8kr2APSqXRu20mXYAHEKwyXAf01Euf+BsbY1JMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718773108; c=relaxed/simple;
	bh=hjT+ru7/WXk+lDb6+eBOG3Sg7K2+eEMjHZD0IoaHRsQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ILUpHCHijWavLoR0p6M+vmlNb4OQlkbfvj18CpWYiseG5/msZlnK124DW/HiceNRwbVIHNtSgrbse6bYtZqF9SmVDAPTNU43YhtZXGTOPKlidbFmb803FrNxyDDPEjZNbmpD7krk91ej13kx5mLDG2Oer3RKXabUbNnqYzJaOnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cMfzwfo4; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718773106; x=1750309106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hjT+ru7/WXk+lDb6+eBOG3Sg7K2+eEMjHZD0IoaHRsQ=;
  b=cMfzwfo4zhB3hGCUKH+Nwc+vYJiqitagdN2VeqmGUMrMCZe/P0/Tw2ed
   /1L7GSHnmmMniE1pg/bEuA5jU96WWIxO7LIS37tp0GwwKshMagUv4QhU3
   S/z5FrIMtjLCkxqb8NudILXqoXz2GT9k48RvfNTgL85fQdO7azzVCaHTM
   t2VbNpZm3ud/nIG4XGd0eaxuOuLdFBMXAOT2kS89mlgLZ8gfJyDU7Wijs
   oW0BlwfMUc0/DhD1VZcItPn72zMkrevEQtmmBTi6fTxQdFAKoiRiLWWiC
   nkqsvbfWYPtfLjQMdktNXcZKOwETa06gen4hDUN2f2+PBYViaEN6o4/xN
   Q==;
X-CSE-ConnectionGUID: jhN5DGQvRRiWWsESLHxOEg==
X-CSE-MsgGUID: EvSoXSRLTouenxrPoSKzaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11107"; a="41096250"
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="41096250"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2024 21:58:25 -0700
X-CSE-ConnectionGUID: 3WQcDxGcS7GOrpQ8RSQcTA==
X-CSE-MsgGUID: VsCZ8gPbQ/CiTBtk1fpnGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,249,1712646000"; 
   d="scan'208";a="42497340"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jun 2024 21:58:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 21:58:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 18 Jun 2024 21:58:24 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 18 Jun 2024 21:58:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 18 Jun 2024 21:58:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVcq6AXhBkmlHT7osqivBOdlGbv7+0bmZx6CxtagA/SG9A918sBX8f5V/MKLDiWmR313FrO8yTZD2KP8XIE+GrJ+jSKzexHnBAzsde6c12PgOBlbekSawxAQw+HvXcNGZFuCjXy9+OVYxnFmXxPIP69CbClcUvUk6opgGTUrfxlgXo7TqBERlk4Q8OBb0OYsMjKrV6QKIaRlmmzZkGxyGAtmaWOCeoffVxCD28kzVFpwVoyjZ9XZ+ftwsoG6lxbIfj99G1gSsoFJq7bH3/+rwj+CXOeEratsshTICcPZviqzSWDNhgUUmT0KaAiF0Lxwa1BFoewxFJEGA8wUQypshQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjT+ru7/WXk+lDb6+eBOG3Sg7K2+eEMjHZD0IoaHRsQ=;
 b=GJdsH+Y9pr18ka/of/G/AfkW7sg94vgkV1eHzzCVMakLWnSDfHmlWJLH0xevOTxWbRzVZ/lmJ1xkRSsMe8H1VJSezbwxYMaJydH3LiwJX4FaO0yhaviHgJeHOHwQHK1L2bUTM4O9+KGGHLCiR4dRJd+/RSnnNo2465Gf4v2/2nkCdeEq+Egz11B1jNG4i7x3odJ8mYkiMKTvaa8ItgtmdNyhg7m9RI0vr35qjq5QWh/Enokug47WcAr0Vra6CGe/T5h2a9ZwLGF8OkSJUbHpcmHJHIdInqfCiDheUnz4ToAVl0A3/RvFsDat9MkxR5YjwksCKxdh7h1lZ6MJE2Fz1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL1PR11MB5239.namprd11.prod.outlook.com (2603:10b6:208:31a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Wed, 19 Jun
 2024 04:58:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Wed, 19 Jun 2024
 04:58:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "seanjc@google.com" <seanjc@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
Thread-Topic: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
Thread-Index: AQHav+UTEitueRT63E611vGc3hxz1LHNo3oAgACrYgCAADvvgA==
Date: Wed, 19 Jun 2024 04:58:17 +0000
Message-ID: <942bf87b650a687c8f4d421ace457a7f0bb8fcb2.camel@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
	 <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
	 <7809a177-e170-46f5-b463-3713b79acf22@suse.com>
	 <717ba4c65ba9f1243facfcced207404c910f2410.camel@intel.com>
In-Reply-To: <717ba4c65ba9f1243facfcced207404c910f2410.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|BL1PR11MB5239:EE_
x-ms-office365-filtering-correlation-id: bec37fd9-8229-43c9-0c21-08dc901c6f14
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|1800799021|7416011|376011|366013|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?Sm9lZVNacFlSN3pSZVZzSEJKZjFTK3pnYmlhSzgyd2pwNFkvRG9CQ0R0azcz?=
 =?utf-8?B?LzhzSi8veUJoazZSTkExakJpd0JUSVg4NHFWSm5aRWRSVHlGMlRyTDIvM1ZB?=
 =?utf-8?B?YkhuZFErZEJHVXRXSjVmRWJTWkQ4NXNsOGR1TUt2SkNYc3RBcDhVZ3UwVzhN?=
 =?utf-8?B?Z2dwd2RvSk83VFp0NUdqRzd0Z0xqRTZOZ2tEbDhoK1preC9aU3BvUGl1b0hq?=
 =?utf-8?B?VGE5YUVoWXRzc3AxckcrcnZ3Znlrdkl3MDBlcjNSaEJjNkxOMDk3K2twOUxi?=
 =?utf-8?B?MEFrQVI5Q01HbE9lL2xTWXIrV3FKNXBubHNzTzdZOFZ6NWdJbGZvb0N0TlJW?=
 =?utf-8?B?by9hTHBiTE1FZDZNY044dWpEUnVlTHdqV0szdXljbk1yb3h1NkNETnQ2L0dV?=
 =?utf-8?B?Vzh3Mk1neWo2eGl2UFE1V2dua1hlYVB2VHI3SW0rdHZLbnV2RXIxRTN5TnJX?=
 =?utf-8?B?TXFzNkMyWDM4NzFOQnJqSDhaTlRscGRsV3RvdGZ5NlIwck4ySFh3TmxXc1Nu?=
 =?utf-8?B?WGZzZXhjSlpXMU5FNTJsdHF6MEptakVxVndERnEwMXFjRUM5VFU0VndaanY5?=
 =?utf-8?B?VXluaCtVbk1ZaUtRN3pidDE4NGNaSWtQS1FlL3FVSlVTM281NE5uSzhMaTdo?=
 =?utf-8?B?TlFYWGhiVU1Oa2lrTUx4QkZVMm9jMnVPM09jUm56dkRhZ3RMOXRIYlM0NHZU?=
 =?utf-8?B?cVdYL0FHbXBzTzR6dGRiZjY5SnRqZjJucGVKTFNJV01KRWlFcDBtdk9LK2ZL?=
 =?utf-8?B?T0lycDRSOTVHM0ZBZFFzem9JK1Zad3VBTTRrc01aTDRGanViN09YbEdFUjdW?=
 =?utf-8?B?Mmd3NE8vWlRqb0JpY09lcUU3Y2lJMk9Lc0dYSFVYY1VBV052Ti96VEFlc1NH?=
 =?utf-8?B?ZTNlcjdhN1NQMDMwYW9wWVp5MlF5LzIxN3pKSmRLbmNTQUh5L2kvTzdXL2Yy?=
 =?utf-8?B?Y2tqb0VWSmt5MGVCNEQvSkdib2dKOXBzZVE0ZFFzbm1ZNmEvNm1xY0R1aFZs?=
 =?utf-8?B?aWxjQ3p2VmZvTkViZ0pROFBsdFpxTFR3UlQyWmpXK3AramRwWDE4NllsYm9u?=
 =?utf-8?B?R2NyeVRyQ21BcjNtemM4MW5rcTFXekRoN1BPOTE1TGtkVmVFWGFPRnlIK2pr?=
 =?utf-8?B?bUdhOTNFcGJCNnIzLzZ5U2ZndnR1a3o2R3lEODZWSHFmTzFwRGZYQ1ZqSDVs?=
 =?utf-8?B?ZkpkcWdzbHJUbjZ1NTU1N3g4SlJWV3g1TzZzQ3JvOFlPWUd0TFA1Tk8zODFu?=
 =?utf-8?B?dGFGTzJmYnJBdnZXTTA4dkR3MTVhemhHZHZOMEdlYThqZEN5SUpZM1RqTDRZ?=
 =?utf-8?B?RmEvcmdraG5uQy9Ka3JlQ1hTdlFVblcwTjZ2WVV2V0ZsQ0lBb0NjanQ5bHI3?=
 =?utf-8?B?MkI4Y210UVVnTU9FYVhFdTFFTFBsUjJ5SmVwZmRjNE44TVgzZHh3RXcvQXdE?=
 =?utf-8?B?ck1VWkVHcnF2OWpUQnVzanhIZHZyQURaeGZSeVBaRFdKMmZFakd2cmY1Z3dQ?=
 =?utf-8?B?czNpbXRRTkpGMzVGbzI2cjgzSU8wSE85WmJ1bENEcHBUd1N4WElEajQyRCtT?=
 =?utf-8?B?ZUY4TjFSZ0dKTEErdGxLc3ByRXI2MlFHeUhWS2lVMTBKRlFGS0tPTHMydjla?=
 =?utf-8?B?cUtLd01XYVFncUJPeGVyTkJGeVV1S3NpUHlzS0dkUk5zc21ieWpmQ1dvVXdG?=
 =?utf-8?B?M0dpNnJFdkpudG8vU3k0Wm9XbUk0dnk1TkNkVlc3b21xUUtqRnFMQ0JianN1?=
 =?utf-8?B?YUxEMlcrYTI0NVdVM05UY3V0eUlQNjMxNUF1dEVmNzY2SXhXSG1qSUJLZ3hL?=
 =?utf-8?Q?QopqrySuDM0RhoCqWwrzKNfYCbgBGxs9cmwVA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(7416011)(376011)(366013)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MzNPVXBWWXVNcWx1Z3dydHRyY3IvQzNja3RtYkpTTFpnWWx1bUczZjNiQnZF?=
 =?utf-8?B?RDcxc29yWFRwb0dMd09haUlsSHFEMWlWOVR6NEJQWnF6YXJSZzFhWjdzOUZG?=
 =?utf-8?B?UHl5eCtHZ2gyZXJtNlBuUEF5aHFwaHlrRlBsNWN1MFlaUklvM25PdTQ4dDE4?=
 =?utf-8?B?clphTFR5OE00T3pibEY5UjhjWnZjV0NrRjh0Z2pYeW9ZLzJEU3d3aTFQMm8w?=
 =?utf-8?B?V2JLaHgyTytIUmhkcFd6dmFpVjg3SllWL0Jpd0kraFhQYXNsc011SXpPTCtX?=
 =?utf-8?B?YXRuN09rdkNlZE5LNTBBbXBLVDgwV3lkeE84d0RnclZDemJ1Tlk3TzY4dyt2?=
 =?utf-8?B?Qi9YbEpRV3p1MUYzYzFNWk1WY0Z3N05CNThMcDdxRzlaN1F2WTk3TzlWRkpG?=
 =?utf-8?B?MmlKVDV3NXNnTTRxbktrK1ZHTjNucFlic3ZSNFJhVUJFWk9ONVRyV1d6RzNz?=
 =?utf-8?B?ZWJYaDJJUDVLUjZGMjFyNFd4WTM1UzFVNEVTcUVHdGlnYldqNFl1ZHlScUlX?=
 =?utf-8?B?UmlJVjU4V2hzTnhZaURDWDZHRTJKQ0l2R0ZYNjBLM1pFZTd2bVNXbndaeEMx?=
 =?utf-8?B?N3BpUkt2SkpDQnBNcXFVN1NaaDZWN1Z0ZUNUTTlQbGlqQncxK3FLSC9FcVdZ?=
 =?utf-8?B?ZWhPUTY2ZFowRzBZWE91VU81TTM1R0VMNTZYWTk5YmpCQU02WXYrZWJKbmhv?=
 =?utf-8?B?WWR0UUV3VlZsekZjMG1YdGFqeUkvZEdFS1lodVBlK1R2dmFrbEZuR3VOcXlY?=
 =?utf-8?B?bGNjUEJiNkNncDRqK2pBOHFqaVp5eWJGMTNmclVycmRuZjdiRmNuSXZBU0lO?=
 =?utf-8?B?K3lHOTZGZnQwWFpTRnFGOS9lcG9PZ01hZ05WckE1RlFaa2F4TGhtcExMTTFk?=
 =?utf-8?B?U0ZIWWpMMUxlNjJUZ0JldUdSejJGVDRLUmtWanZDa2xWVzUrT2JOK3ltU1VT?=
 =?utf-8?B?SkhNRlRDbm9XRHlodmVtOVcrc2pUcXNiMzVnMVJ1NWtJRkVkZFNPY1k3RFcz?=
 =?utf-8?B?Y2ZqQkRXL3ZaeU8yTnhEWkg0R0x4VjNRUVV0U1ZXN1YzRis2bHlxOG5EYXk1?=
 =?utf-8?B?bU1FaEdqQjN4ak9JMWcxc3BXR1pQK3pQbjlXQ0lQNHY4NUZSd2NrdzlDRkxK?=
 =?utf-8?B?cDg2Myt1NVlyK2RoSXVPK053NUdlQkdtcjlzOFI1MExQVExIWS9jdDBhUkF3?=
 =?utf-8?B?d05tNzVmS3NvU0dXOW1kdEIyZUM1QWhTTEI5MXhDMnJrSGVFOHBGcG9lclVu?=
 =?utf-8?B?NkFTYUY4OUM1MUlrSTRFWmprd2dWWWt0K29jd3JPdU9nSlJjU0p1VHViNnky?=
 =?utf-8?B?RERablhzMW5SUG1UZmMxL0JiVFB5bVdNdDI4VHREY1luSjFYOTFYUWtTdGZn?=
 =?utf-8?B?c01LMnpYMml1dWhsdGEycmZvUyttWktzYkp0eU8rSUR3VENnQk5jMXNKSFVz?=
 =?utf-8?B?b1lyWDF4eDBaMEpQa0Rnck1CZEpXWXNwUE9RNmpsdTJvV1djenh0WWVQakJm?=
 =?utf-8?B?NmMvVTFoallHRFlzMjZoRmtNZ3ZQbzNnSW5Rd0t3WWtJbjhxTnp1eVBSZnVr?=
 =?utf-8?B?RmRIQk9hcUVWbHVKalgxR3huMkNxc0xmMTlHb3k2V3AxdFpXSmxTYy9pbzI4?=
 =?utf-8?B?L3ZrTmw2Qnp0WE85b2JrQ2F5bURuWTM5K3ZlekVnU2kxL1QxZWg3bzlCYjZz?=
 =?utf-8?B?Tklmc2l4ZnpZS1BJeDIyc0ovN1R6R2JDaGFYNzdXWWNCSWs3cU9aZUZlRDdv?=
 =?utf-8?B?cGVkZEIraXdmZGpTeWZKclVsMkowU3MzTGw0aWFDTHpGMXd6MFJKcytnWlBm?=
 =?utf-8?B?YURheEJVSEk2M1Z0Q0xZVlVuRVRIa1hYSTZvRUllczVJenFLb0l4ZHpKMy85?=
 =?utf-8?B?Ym4ycVZqR2lIQjMzZldRSVUxUkJ6NVpSeWhTbGFVREhBUStUWk9qRWpiS0pC?=
 =?utf-8?B?cnpsNEJxSlN3WTVUbFcyMXYzcTNEWVJmMWZXNWZuU1JvYkoveTlWMkVsZEdX?=
 =?utf-8?B?eHZ6ZnhrVDM3bko2Tm9DcXF2aGZ6M0krbHF6dU5TTVlUSzdyT2VUYUpSN3NG?=
 =?utf-8?B?WG5UQ0NhR2JaYXhQeHhpeksrUVlWeTNTczlPZ2VOUkhtUUIyb3dJTFl5VEZ0?=
 =?utf-8?B?SmRZc2g5bExxdVV5R1lVcU5sQkt3SkVlMyt2eGxNY08vU1hIU2FXVlM1bmpO?=
 =?utf-8?B?V0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF722C9E9C3FF449938D49B64E103CE4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bec37fd9-8229-43c9-0c21-08dc901c6f14
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2024 04:58:17.6424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T4gXfRIeuoZQapaEMh2Vhj8OMf7S+00cas/0akDVS4XadwBPuNwZNgIgcnzVXMDI2yKnsNzqXVsjFDyKlHbg3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5239
X-OriginatorOrg: intel.com

DQo+ID4gPiArLyogV3JhcHBlciB0byByZWFkIG9uZSBtZXRhZGF0YSBmaWVsZCB0byB1OC91MTYv
dTMyL3U2NCAqLw0KPiA+ID4gKyNkZWZpbmUgc3RidWZfcmVhZF9zeXNtZF9zaW5nbGUoX2ZpZWxk
X2lkLCBfcGRhdGEpCVwNCj4gPiA+ICsJc3RidWZfcmVhZF9zeXNtZF9maWVsZChfZmllbGRfaWQs
IF9wZGF0YSwgMCwgc2l6ZW9mKHR5cGVvZigqKF9wZGF0YSkpKSkNCj4gPiANCj4gPiBXaGF0IHZh
bHVlIGRvZXMgYWRkaW5nIHlldCBhbm90aGVyIGxldmVsIG9mIGluZGlyZWN0aW9uIGJyaW5nIGhl
cmU/DQo+IA0KPiBXZSBjb3VsZCB1c2UgdGhlIHJhdyB2ZXJzaW9uIGluc3RlYWQ6IHJlYWRfc3lz
X21ldGFkYXRhX2ZpZWxkKCkuDQo+IA0KPiBUaGlzIHdyYXBwZXIgYWRkaXRpb25hbGx5IGNoZWNr
cyB0aGUgJ2VsZW1lbnQgc2l6ZScgZW5jb2RlZCBpbiB0aGUgZmllbGQNCj4gSUQgbWF0Y2hlcyB0
aGUgc2l6ZSB0aGF0IHBhc3NlZCBpbiwgc28gaXQgY2FuIGNhdGNoIHBvdGVudGlhbCBrZXJuZWwg
YnVnLg0KPiANCj4gQnV0IEkgY2FuIHJlbW92ZSB0aGlzIHRvIHNpbXBsaWZ5IHRoZSBjb2RlLg0K
PiANCg0KU29ycnkgSSBkaWRuJ3QgZmluaXNoIG15IHJlcGx5IHByb3Blcmx5IGFzIEkgd2FzIGlu
dGVycnVwdGVkLg0KDQpBbm90aGVyIGFkdmFudGFnZSBvZiB0aGlzIHdyYXBwZXIgaXMsIGFzIG1l
bnRpb25lZCBpbiB0aGUgY29tbWVudCBvZiBpdCwNCml0IHdvcmtzIHdpdGggJ3U4L3UxNi91MzIv
dTY0JyBkaXJlY3RseSwgd2hpbGUgdGhlIHJhdw0KcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQoKSBh
bHdheXMgcHV0cyBkYXRhIHRvIGEgJ3U2NCcuDQoNCkFuIGV4YW1wbGUgaXMsIC4uLg0KDQo+ID4g
PiArDQo+ID4gPiArCXJldCA9IHN0YnVmX3JlYWRfc3lzbWRfc2luZ2xlKE1EX0ZJRUxEX0lEX05V
TV9DTVJTLA0KPiA+ID4gKwkJCSZjbXJfaW5mby0+bnVtX2NtcnMpOw0KPiA+ID4gKwlpZiAocmV0
KQ0KPiA+ID4gKwkJcmV0dXJuIHJldDsNCj4gPiA+ICsNCj4gPiA+IA0KDQouLi4gaGVyZSB0byBy
ZWFkIGNtcl9pbmZvLT5udW1fY21ycywgd2hpY2ggaXMgYSAndTE2Jy4NCg0KU28gaXQgaXMgaGVs
cGZ1bCB0byBtZS4NCg0K

