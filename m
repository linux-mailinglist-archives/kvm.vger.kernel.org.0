Return-Path: <kvm+bounces-47201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D745ABE846
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 01:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FEA04C81C2
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 23:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A7192609C4;
	Tue, 20 May 2025 23:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SnZvq7yA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1D0217733;
	Tue, 20 May 2025 23:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747784829; cv=fail; b=us5to/9143OulZz6dUnAMaiaZauTdGT0e0cx9fi+IFe0/s8AbHaCZlrQpzIfkJSvbYCyhi9H9DJjloGzfodmPzbWlBg3EmR8srooKNxOncEjS/61gS6jnivq5uQDVv9DhcIiLhTzep4skS/mKXDdknEw2JHP09zV4gIFMyD1cTM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747784829; c=relaxed/simple;
	bh=vp7a4TuiPwRUyp+FVNEf50gYSgUeMsSXjShfP3clSv4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b8UtnUDOMpXlZZP9m1gzVzbIBqmwpqZxpeUv/tQsqmqrgU/AFqk3MPbVk1bHdSdGKYVC6IbAWd4qSH0RTmB5gNzh4JkWjzFA6gN4of0O9Tfha/6L/sP29gg8J/Tf5YLGtdsxf8UZWnZYnlHpG+F0T1g93ckxC2KotNJ8p0zd9jE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SnZvq7yA; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747784828; x=1779320828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vp7a4TuiPwRUyp+FVNEf50gYSgUeMsSXjShfP3clSv4=;
  b=SnZvq7yAScjSJAOfc9UGk5zPmwKVXMIyCuH7yHKv8jbdLeRakMoQ/Vzn
   1ua6dpv0qTU8Njes3qajgB3Ow13RD8ZJw9C9vI2oAXDJYxRicLND5azB3
   00WwaljCZRC0DbGGPQ0pl6EGhop6pVSg0C0GbcjG3EoTtaPX507ZclhBc
   yOUZ2RcSYmnHBYTtCK1zfYDdnOhQ1RgbczkFugyPpNVh+f2p6L4cvmKwl
   incC/pb/d7HL7mV/9i6c7dtJvmr3IawHZR6sM5f33zxsU7CKKA5AlaxTr
   Hl632q3F/h5aRGgea2p/belneUCkFEDDTLy96u8FHDRF/CRN+B51dqLV/
   Q==;
X-CSE-ConnectionGUID: V7gPiRWaR9u0TnMDencGfA==
X-CSE-MsgGUID: lVJ+JWG+TYiKIM4x30yBOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11439"; a="37359460"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="37359460"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 16:47:07 -0700
X-CSE-ConnectionGUID: DLrDlDiLRTyHd4+m3TZ6Sg==
X-CSE-MsgGUID: ofnf3PXsQY6Lm3LHpGcQsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="163127507"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2025 16:47:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 20 May 2025 16:47:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 20 May 2025 16:47:06 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 20 May 2025 16:47:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=B2zq1yeNcZUDgc1gB28RWzEq3Q3DRV+5xilaQOzOMFwNPG8V+wqsvcC57Go0wsMEM8C4zB2qQ04BAmQVCRF6zg8W9b0qUbgtImIf/V4ABroqf8nWEGQ3FkuYcuGFjn5FXWcQpA4xDFbvvtt/sD+WdYNBeh+feCN5XiOY/PXy6lKfVDzW+q/qodPhErVviZ1epIlCjcArfhHuwXJh0DFRy2z5SeYOXcJkAnZRFgZg9wjox4WkgxA8C/x0vmTRimeF1mNE9Ui+3yo4xZhuZpmley45NE+u2LATVx6Xq9eHFob46gzsRcpt+zrKuyvS+Cb2ikqeCbNE+SdCwPfBxnvijw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vp7a4TuiPwRUyp+FVNEf50gYSgUeMsSXjShfP3clSv4=;
 b=iG6YjbbchQUIlfmhdIRUBBVq5qd6nc4Ku62IOEJSPDmWquFPRx8L8tWacASvpc9207YMvyeJ/oPueGFxox7sO2lSc6C8aDSesuUXkRvdCbz/JBtXyOBpPrpOavwyqWOqSSk51Co3SD4h3FxeQp/LP2Ot0PjYSplAZ36WRRVIC9PwO4TPxeLjI5Vj+NQZl0PPLx/aUfBZyEOY9U+r0uwV8yiXQnTijz7/SbmmKlfZzmcD8q4JAsOUmOg4KJUw3uxNF0LwGkPPghKnZDzno52/OViFfzRkxlsVSaNgu5tKpy7DDd6O0v/aH3ZNKBEPmxeSWJ2NqpOpY/A+/DzXpokDKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB6760.namprd11.prod.outlook.com (2603:10b6:806:25f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.31; Tue, 20 May
 2025 23:47:03 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8746.031; Tue, 20 May 2025
 23:47:03 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMZBhA49+LJMgEuvNu90MMjg/bPRHIEAgAN/lACAAIg8AIAA1+cAgAPLQ4CAAIwUgIABF70AgADuG4A=
Date: Tue, 20 May 2025 23:47:03 +0000
Message-ID: <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
	 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
	 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
	 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB6760:EE_
x-ms-office365-filtering-correlation-id: 5cdbab8b-2915-49ad-5e51-08dd97f89f12
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UDhuWXZCbE12YzFXbXJOQmZWTUY4WVJuQUJkZVJuaFVlakNjWlpiWnF1cE1N?=
 =?utf-8?B?cHlTMUVtUWRUZGxZVmZxaGdFTHoySzlsNnBGdzVqZ3YwTzYyWEJTWEdPdWNy?=
 =?utf-8?B?MWV1dFJMbktVZStGOHhuRWJqeUI2ei9jSlFyTytSRDJNZ1REaEdWUUxSZGNB?=
 =?utf-8?B?VHo0T2NuOUxZRk1ndmo2RGFGV1RqWGxtTmxYZXY5akhIY0J6dlBDS25aRU5D?=
 =?utf-8?B?T2hyTFcxOGRVcGZzVVg3cGo0TlFlQjA3TUUxSHB3ZzZ4My9RTDBXNDMxeW11?=
 =?utf-8?B?OTlNZFdmZWJaL2pzV3dHZ0ZrZ0M0YzZxQjcxMGRCbStLM05UZDQzdkNTVnF6?=
 =?utf-8?B?c01pa3ArQVBDajhVS3dZL3R2bG5wVjlSMy8xMllWRWlLOGRJeDlhUmJWbUNF?=
 =?utf-8?B?clB0T2Y0d0FVQk5qWGdEazhZZ1NpTFJHRzFKOFZWVHFnS25ZdEVZRnVZTlpY?=
 =?utf-8?B?TnpYelJhMGM1M0ZNbkpvcGFqajV1NC9rNnoyTW9ITHN3MVN1L04wYm5BeWFh?=
 =?utf-8?B?NEd3S1dxRG54aS9BczUxSE5qTTVlMFptbXlEdWxYamZBdmFod2E4elViWlNp?=
 =?utf-8?B?cDFaUlJOTXVWbmgrVGdQdiszUFBlWEJ0VHhyN0lmL1MyWk9Rb3dWNlk2STNi?=
 =?utf-8?B?UXk3SFZCZUFubU5mbmk3ZC9TUDFzTFgzMzBNS1JKY081TlhMSFJZK3RIVHMy?=
 =?utf-8?B?K1RzNHlTSkNnRmIzclc5VXJKOTQ2clI2d0dpZDZOK3NHMEtTdzJuOE5pYXVQ?=
 =?utf-8?B?L2F2aWpFQXFDaDdMckRuTnZQWG0wVUhLeFhoT1drRHhkZlhDajN2TGJLNGtD?=
 =?utf-8?B?R1NPWlRJSTdydWYzaVVPa2lpamd3dm1xdUsyWE9GeFZXbnZ6bjBNMjcxWEdO?=
 =?utf-8?B?OU1qTUVCRmM1czlsTzdQcW1Bd2MxZkFuSTNId3dWdUh1WU8rd0pqdVZzUkxk?=
 =?utf-8?B?VEgvazkveGZORU11MU9oL0cwRnVZenhTVHdsV1BqTFF3cUdPZzI3OVJXOUgv?=
 =?utf-8?B?eVlqU1JNTkhiTXY0YVpRdkFPcW45NGxrMlJzQVlvdk1jQ2ZWcStXRE1SWC9D?=
 =?utf-8?B?T1kxUlZmSlhKejY1SlIyL2o4djUwS2IySml3bm1NUDJJWnJyUmhSZk03QjFE?=
 =?utf-8?B?TVNxVTZCRnk4VTRWTVJ1UHZzMWtRSjZuNGc3Zngrb3BaUUZMTG9ybjhXWWIv?=
 =?utf-8?B?MWhEc0xDeVFwQk85WUFGODgwa2F6eXoxeEUzUkVEWnRKUVNiWmlBai9TVDEx?=
 =?utf-8?B?OHNaaDExRzRkNzZmWFYwTkRxY0N4V1lrYTBndE1nSnFqWElMaGdNZmxZRU1B?=
 =?utf-8?B?ajlnSStqVy9WTHdpRVQ4UXozZ3NpTFZ1KzZkUDRoay8ydFJVU3Uva3dldVZM?=
 =?utf-8?B?dnFwWlZrM1RlemlIQVB5UFh5aDBqbExjYXNpN1Q4MmozQllXQUtqdldHYkQ2?=
 =?utf-8?B?eGpManVjRmc5WnNYdWR0WDFhRno4cXNhcUJHMU9CdUFuNUdvOTZUaFR3ejlU?=
 =?utf-8?B?azAycVExSS9tNGwxdmh3T3I3OVRDYWtGKzkxWWtBbzJ1bGJEVVN1VEFTTkVX?=
 =?utf-8?B?UWM0d0lVUWczdlhWNThjUm13V2tNWjNBMk8vaW1zeWt0aVFIamRqbXBSVTdH?=
 =?utf-8?B?WStROXljVVcyTE5oVHNXNXNFYWhWU3RqQVFrSjBBcGJtSUI1K2FXUVN1UElo?=
 =?utf-8?B?ejNPNVZoSjlsdXgzUkY4V0N3c1FJZUR1TW5Yb1JoZFlScG5QVkY1R2lvQ3dK?=
 =?utf-8?B?NEJ6anJ3ZUt3ZU41cjh4RGdZRnBMUTBORzM1VzhMSHRTd3h3UFdLS01MSW1p?=
 =?utf-8?B?UC9NUUdFOEladk9LVXo5amtBaFlPVFNWOFZrOU9KU0FjSkYyZUVMWWdZVDcw?=
 =?utf-8?B?UjVkS0JFZW1oVFNDU3FKOGFsVGRIQmpXclRMSzJmeGtCMGdVVG9jQjhQcU1E?=
 =?utf-8?B?aVM1Y1JHL2tiZmJENE1Cd21BWEdhTHZuWjl4WHdWZ0o4cDVjWFplREhQekdq?=
 =?utf-8?B?Y0ROK2FsK0JBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L29ERVBlSFhDdW9MWmR3OEtneFZGNVozOTV6R2hDMnlTRzMyb2pGMHZrMSsr?=
 =?utf-8?B?anBublFjRFdxVytpaHJseVBWUmlMbEJNTU9jd0JlUmY0Nm54eXF2Ylo5Tm82?=
 =?utf-8?B?YUxhVGxPQ2k4WkV4K3BDcitjYVZWNHRBNDZOayszVi9yRUp1VUpTZEZqOHd2?=
 =?utf-8?B?MlVhRWJBK2NKVXNuUzBHV3VnOFJhemdGd1F0K0NDRlhVSGNyOUFpYXN2azdC?=
 =?utf-8?B?SjBOaUVudUhjTGkyVzVjeFZhOHJsOUNWblYycndRakg5c0NDWlNFWmpiYWl5?=
 =?utf-8?B?c2pxQUkrKy84blpKZUlrd3U2OFdSaDA4S01LRTVPV3pSbG8yOTRiMEo0RTho?=
 =?utf-8?B?ZkdxaWd5S25HaE1FUXROc2tPRWpPRzltVExnTFNEZFRoeHMwc0JHd2MxK1Jj?=
 =?utf-8?B?VXovcmdNV3drYVZWMy9ocWx1VWp6UTFXQjBlNzh5OUpGRkRwdk9kb1A0bEE5?=
 =?utf-8?B?YUtTQUJhM0VYaFBBaXM3ZVNBVDhSMGJ4NnpOYU9CZHNuMVU1ZmNmcXI1eW0z?=
 =?utf-8?B?L3hoRGdDTGk3UWRhRTZzbElpK2ttUlU1b252UHRya1FxandVTjZBK0gzNC9z?=
 =?utf-8?B?L0ptWkI2cllWNmV5R1VJUFYrcVd0a3BnUE9qblZnMmlSSDZSTU9hdTZDVE5Y?=
 =?utf-8?B?UDlkRmpBa04rM1IzVGpwdlZVQlQ4VmJQT2cxM3FiQVVKcE4vN0F2SHhQNXU5?=
 =?utf-8?B?OUs1MXdmSDAySTgrMTFQZ2t1U1ZjRUtoa043SlkzZ2FaOGRBL1NGcVhjeVA0?=
 =?utf-8?B?TmZYSlNwMFBzRWRPczB6eWhWTWd0N291OXFJUnZsc1gxU1dWZmQ5ajNHYXhj?=
 =?utf-8?B?R3JhbmRTT0tjZER4d2QwOHRObmtsczFWVG1keEoxdENUNDlndDhkTW9WZ2Z1?=
 =?utf-8?B?a00zU24xUXpXRHRNVktzN1d6c2ZmUUtGT1MyczFpV1lGZGdUTWpwejc5OTU2?=
 =?utf-8?B?dkZvMER1TTM0OG42VWtySTNBUDdLR1Rjc0JHN1NmUERLN0M1eFAwTS92ZlY0?=
 =?utf-8?B?MzhJQTVueVJZeVRKVzdrU3l4cnl3ZFErSGRVWmpaTXZ1TzBqOE00alAyZ24v?=
 =?utf-8?B?T3Q5Q2tzU2NVcXFEeWY1bkpPUUU3U0ZZY2dvakdOaWQ0T1RrSDZDMkltUFVZ?=
 =?utf-8?B?UFg3T1NwQlBFRVVWZW8vSlR4Uy9XSEJvbHk3SGcvZWY0YnV2czRGeEhFUjhs?=
 =?utf-8?B?Q0IzaHQwckR4SURkeWVHWk9hSHNEMnRUeG1CNHhDdk1lTVdNQmJtK3M5allK?=
 =?utf-8?B?ZHNPQUJQSzVHVkFNc0R0OTRLeFJYUFpVVEtEZFJRUjBpbHNNekp5TUdYVVFR?=
 =?utf-8?B?OW5ndm9xM043Y2IwT1ByYndzQ2JmcUVGbTRJVE5DNHMvSS9tSjRHT0U3dXVY?=
 =?utf-8?B?TDEyaG82NmhEZEFkVUtmeW5zTUJtVVV4MWx2b2RRZTlTaHQ3Mmx6YkhZb3BQ?=
 =?utf-8?B?ckhSMEp1TjBjTlp2R2cyaGVFa0lWK05qOGhHbVhBSTNkUU93R0FMRzBzRzAw?=
 =?utf-8?B?dGEyYkl2OWVsL1hOODNVZm5vVVZEaldpYWNHQjFzNGlwc3Q2RkdGV2J3b2xY?=
 =?utf-8?B?V0dQd1pmS3BOVUl0SlIvZkVEYWQ5RmpvRmxUWVBNUjNIajNtSGNjWlUwQWY5?=
 =?utf-8?B?eWF2U3ByRmp1MUlsSWRIOHpLcVFVcmFHeTRaRDFQaFBrVldOS2hITWN0bjlL?=
 =?utf-8?B?NGRyTHRQWTZUSEpHakM4LzJhYUx1UjZyMGNCUVp5bkNaUFR2aUR4UENnVGhH?=
 =?utf-8?B?VUZvdVNOL2pDajc1eElsWkxvZCs1dmFlSzI0aVErTUlwamxFM2Q1bjdMdEFK?=
 =?utf-8?B?VlI4M29qWnAyY2JFUzYybEUwOE9NSXRZbnRDZkNBVks1U2JtY1RwbnE2MWkx?=
 =?utf-8?B?Wm5URU04UHRTeWJMakoxbER2RTVjd2lUbDQ5bzQwS1J1Ny9BQjVRTTUreUR2?=
 =?utf-8?B?RGxvMmE1Z2V0TGx1dU1iRktiT2U2N25pTnBtNmtPaVR2RzB2eXR1YmJGQmxW?=
 =?utf-8?B?ZGNVMkFFb3V6VGhRdm82WndGVnpka2JaeTFySE9pQ05jYUFkMmxYczQyci9K?=
 =?utf-8?B?TjUrMVlyMDNqTEZjVFQrNG5DOFRUajVjWnh3TTJTMndDWXRCRXR6ZWZWWStN?=
 =?utf-8?Q?jxbLBIKYJj2LuTXPdH9aLeCOn?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A99DB13C631A0E4697DF9D3C0605FF24@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cdbab8b-2915-49ad-5e51-08dd97f89f12
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2025 23:47:03.2903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fzLcnjiDm5MuuYyYVW1ijqr2WiQi2wDK0MjwA2xk5he4AO2aZU0Su9PPkw8ZUkKPnin6J3TQLsO+ckhuq3cXeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6760
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTIwIGF0IDE3OjM0ICswODAwLCBaaGFvLCBZYW4gWSB3cm90ZToNCj4g
T24gVHVlLCBNYXkgMjAsIDIwMjUgYXQgMTI6NTM6MzNBTSArMDgwMCwgRWRnZWNvbWJlLCBSaWNr
IFAgd3JvdGU6DQo+ID4gT24gTW9uLCAyMDI1LTA1LTE5IGF0IDE2OjMyICswODAwLCBZYW4gWmhh
byB3cm90ZToNCj4gPiA+ID4gT24gdGhlIG9wcG9zaXRlLCBpZiBvdGhlciBub24tTGludXggVERz
IGRvbid0IGZvbGxvdyAxRy0+Mk0tPjRLIGFjY2VwdA0KPiA+ID4gPiBvcmRlciwNCj4gPiA+ID4g
ZS5nLiwgdGhleSBhbHdheXMgYWNjZXB0IDRLLCB0aGVyZSBjb3VsZCBiZSAqZW5kbGVzcyBFUFQg
dmlvbGF0aW9uKiBpZiBJDQo+ID4gPiA+IHVuZGVyc3RhbmQgeW91ciB3b3JkcyBjb3JyZWN0bHku
DQo+ID4gPiA+IA0KPiA+ID4gPiBJc24ndCB0aGlzIHlldC1hbm90aGVyIHJlYXNvbiB3ZSBzaG91
bGQgY2hvb3NlIHRvIHJldHVybiBQR19MRVZFTF80SyBpbnN0ZWFkDQo+ID4gPiA+IG9mDQo+ID4g
PiA+IDJNIGlmIG5vIGFjY2VwdCBsZXZlbCBpcyBwcm92aWRlZCBpbiB0aGUgZmF1bHQ/DQo+ID4g
PiBBcyBJIHNhaWQsIHJldHVybmluZyBQR19MRVZFTF80SyB3b3VsZCBkaXNhbGxvdyBodWdlIHBh
Z2VzIGZvciBub24tTGludXggVERzLg0KPiA+ID4gVEQncyBhY2NlcHQgb3BlcmF0aW9ucyBhdCBz
aXplID4gNEtCIHdpbGwgZ2V0IFREQUNDRVBUX1NJWkVfTUlTTUFUQ0guDQo+ID4gDQo+ID4gVERY
X1BBR0VfU0laRV9NSVNNQVRDSCBpcyBhIHZhbGlkIGVycm9yIGNvZGUgdGhhdCB0aGUgZ3Vlc3Qg
c2hvdWxkIGhhbmRsZS4gVGhlDQo+ID4gZG9jcyBzYXkgdGhlIFZNTSBuZWVkcyB0byBkZW1vdGUg
KmlmKiB0aGUgbWFwcGluZyBpcyBsYXJnZSBhbmQgdGhlIGFjY2VwdCBzaXplDQo+ID4gaXMgc21h
bGwuIEJ1dCBpZiB3ZSBtYXAgYXQgNGsgc2l6ZSBmb3Igbm9uLWFjY2VwdCBFUFQgdmlvbGF0aW9u
cywgd2Ugd29uJ3QgaGl0DQo+ID4gdGhpcyBjYXNlLiBJIGFsc28gd29uZGVyIHdoYXQgaXMgcHJl
dmVudGluZyB0aGUgVERYIG1vZHVsZSBmcm9tIGhhbmRsaW5nIGEgMk1CDQo+ID4gYWNjZXB0IHNp
emUgYXQgNGsgbWFwcGluZ3MuIEl0IGNvdWxkIGJlIGNoYW5nZWQgbWF5YmUuDQo+ID4gDQo+ID4g
QnV0IEkgdGhpbmsgS2FpJ3MgcXVlc3Rpb24gd2FzOiB3aHkgYXJlIHdlIGNvbXBsaWNhdGluZyB0
aGUgY29kZSBmb3IgdGhlIGNhc2Ugb2YNCj4gPiBub24tTGludXggVERzIHRoYXQgYWxzbyB1c2Ug
I1ZFIGZvciBhY2NlcHQ/IEl0J3Mgbm90IG5lY2Vzc2FyeSB0byBiZSBmdW5jdGlvbmFsLA0KPiA+
IGFuZCB0aGVyZSBhcmVuJ3QgYW55IGtub3duIFREcyBsaWtlIHRoYXQgd2hpY2ggYXJlIGV4cGVj
dGVkIHRvIHVzZSBLVk0gdG9kYXkuDQo+ID4gKGVyciwgZXhjZXB0IHRoZSBNTVUgc3RyZXNzIHRl
c3QpLiBTbyBpbiBhbm90aGVyIGZvcm0gdGhlIHF1ZXN0aW9uIGlzOiBzaG91bGQgd2UNCj4gPiBv
cHRpbWl6ZSBLVk0gZm9yIGEgY2FzZSB3ZSBkb24ndCBldmVuIGtub3cgaWYgYW55b25lIHdpbGwg
dXNlPyBUaGUgYW5zd2VyIHNlZW1zDQo+ID4gb2J2aW91c2x5IG5vIHRvIG1lLg0KPiBTbywgeW91
IHdhbnQgdG8gZGlzYWxsb3cgaHVnZSBwYWdlcyBmb3Igbm9uLUxpbnV4IFREcywgdGhlbiB3ZSBo
YXZlIG5vIG5lZWQNCj4gdG8gc3VwcG9ydCBzcGxpdHRpbmcgaW4gdGhlIGZhdWx0IHBhdGgsIHJp
Z2h0Pw0KPiANCj4gSSdtIE9LIGlmIHdlIGRvbid0IGNhcmUgbm9uLUxpbnV4IFREcyBmb3Igbm93
Lg0KPiBUaGlzIGNhbiBzaW1wbGlmeSB0aGUgc3BsaXR0aW5nIGNvZGUgYW5kIHdlIGNhbiBhZGQg
dGhlIHN1cHBvcnQgd2hlbiB0aGVyZSdzIGENCj4gbmVlZC4NCg0KRm9yIHRoZSByZWNvcmQsIEkg
YW0gbm90IHNheWluZyB3ZSBkb24ndCBjYXJlIG5vbi1MaW51eCBURHMuICBJIGFtIHdvcnJ5aW5n
DQphYm91dCB0aGUgKmVuZGxlc3MqIEVQVCB2aW9sYXRpb24gaW4geW91ciBiZWxvdyB3b3JkczoN
Cg0KICAgIC4uLiBUaGUgd29yc3Qgb3V0Y29tZSB0byBpZ25vcmUgdGhlIHJlc3VsdGluZw0KICAg
IHNwbGl0dGluZyByZXF1ZXN0IGlzIGFuIGVuZGxlc3MgRVBUIHZpb2xhdGlvbi4gIFRoaXMgd291
bGQgbm90IGhhcHBlbg0KICAgIGZvciBhIExpbnV4IGd1ZXN0LCB3aGljaCBkb2VzIG5vdCBleHBl
Y3QgYW55ICNWRS4NCg0KQW5kIHRoZSBwb2ludCBpcywgaXQncyBub3QgT0sgaWYgYSAqbGVnYWwq
IGd1ZXN0IGJlaGF2aW91ciBjYW4gdHJpZ2dlciB0aGlzLg0KDQogDQo=

