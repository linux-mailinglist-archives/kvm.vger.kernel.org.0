Return-Path: <kvm+bounces-32485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE9B9D8F98
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 01:47:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE5B2B2496B
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 00:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D6910A1E;
	Tue, 26 Nov 2024 00:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OtvEzyn8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A7BDF49;
	Tue, 26 Nov 2024 00:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732582068; cv=fail; b=PamB8qhZMthFy7lCHjUl00/8blcf/lMrR6iV8cJlQXbqHO19JnXPW7eT0f7p4lF5P6PknfWhJNemNUWm2b4zv8GmblquLg9QCvN+bXPX8ej96yRpXjqAtmDZEL98VqOpdfy6kBCQCPIYsuNfGHUWOR5xorFQhcnFXrC4s354SEU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732582068; c=relaxed/simple;
	bh=WaTknMsc0vRTqPyu61OnwlWBHV0AQmDhuwStsA4QBrk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b0s5GziVtutswaq4hRYvE8FrDmebTItU46Mm2SnqEhm/QmYkagBXm2VyHKDufuRzeh4sp/jlNFCmw2IRKIsrtwUFbAaJLodSGet1AFvINIR1NviCdLWgocO40JCJl2k1sJw3SiCWx8PwXHTy8W+3f5wMFi+Te+OMQBEBZJCiApc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OtvEzyn8; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732582067; x=1764118067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WaTknMsc0vRTqPyu61OnwlWBHV0AQmDhuwStsA4QBrk=;
  b=OtvEzyn8+C7q1Oy/oKpRPl21XHqbSZovYvWT0VBs6g6em9O57AEj4Qqk
   aphlzdmcBsxB1eaIIuzV5izjUN4dDjFUO/VsB1nnxHT8DN+anpR82QHQt
   Er8fl+UmYQTY0eujLelXkR4PNaKUp5Tkl2XbRXkLgKXqpiP3f2bdinrUp
   Jr0FXYw9+rYpMsnV8PbK8DTjefIWnUnmb4uPO5pcE76XHXJLswRzG5HPC
   JgsroYrE4BXF4n5c/1zYo+MeNslXFmRZm1Ugk/GICPxs8yt2UbQF79u46
   NAZZHiWmbtsItVym1vVeWQJPqcxoDxhPySQ2q9CJQy6HhYEcf8aLrGSfv
   w==;
X-CSE-ConnectionGUID: NrkTpkIbSEu9J42LCI2j5g==
X-CSE-MsgGUID: rpBMF4xjTMa/N0kgqoOvYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43785899"
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="43785899"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 16:47:47 -0800
X-CSE-ConnectionGUID: EmCQ3A77RCiOEF4FdHSUAQ==
X-CSE-MsgGUID: xx44cPUKRNeuOW0SSBA32g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,184,1728975600"; 
   d="scan'208";a="122295523"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 16:47:46 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 16:47:45 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 16:47:45 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 16:47:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QIgdJBn26SYPYn6dXtw8BI6LY+2F86pR5mbE+ZEi3JzohJ91iIrCoYseZB7PSb2we3+6uWDobF194F1LBwdBggfz5AdY04/k3bf4aiF2nrJsIg/ckwkqjzT3rgq2SQfPRKx+o+A0H2ZPT5Q9QW5Cn5Wq2B5O6K/4dUMTSkC4WBWlnWanBk/DzGbEVh7UuYviDSWdN2yzSbrI3dFQZr9TL33TwBzrQlXnwG6tcbZdVJDRypuj+QRKqfr1W+9mX1JuKp6/NK6r9zdpoAS0oThC6G6d+wMN3K1FX/2Bpg+dqu1XQi36IsNiyUE4SJqmXL63i1NwGEDifAd8nGgXu7SNmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WaTknMsc0vRTqPyu61OnwlWBHV0AQmDhuwStsA4QBrk=;
 b=QOih/vUT61XX1Hyv2scGs3JGuDFMSLi3xShepEyy7uxqxfmV8Lg3FZmgFe314rHmUWjREA+ufE+W/zeOIoJAj1Cxhrv6Ij2xE6pfT5weYWX4VVtQEAyUZ0p/1j6l4Iz54tk0z/04f8KbwNRVdHe3/pPliO+cCO1eJ4EROlDmC1o1Gm/E5R/T5A2czkJ+NrXoK0GywzKLCYpLvBTwGILf0rZDkAVrZzPoan8VzHnoqVoMTbYO7P/8EG7rxHMiRn7B0afrQHjTf2pkRfWfMeOjRmd3u3lPf6sJea8SgHbELQSM50x/T8fJ8Ae7+FJx1DWF4phNW8mJWxLqzj+dQ0zz0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7705.namprd11.prod.outlook.com (2603:10b6:806:32f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Tue, 26 Nov
 2024 00:47:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8182.019; Tue, 26 Nov 2024
 00:47:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
Thread-Topic: [RFC PATCH 2/2] KVM: TDX: Kick off vCPUs when SEAMCALL is busy
 during TD page removal
Thread-Index: AQHbPAzfWm2P3b1GtEqX7sO2uNXwgLLIwX6A
Date: Tue, 26 Nov 2024 00:47:42 +0000
Message-ID: <0a99ef415e06ecd30b1c40b93bdec5923b9585f2.camel@intel.com>
References: <20241121115139.26338-1-yan.y.zhao@intel.com>
	 <20241121115703.26381-1-yan.y.zhao@intel.com>
In-Reply-To: <20241121115703.26381-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7705:EE_
x-ms-office365-filtering-correlation-id: d5eddd04-4057-4f69-fa8b-08dd0db3ef82
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V1dQM1cySnh6WGhwZmFBcWVqSmZHWnkzQ2hxKytYU1d4QzN0R3NTMThFNW1j?=
 =?utf-8?B?NEo2Zkd6SDlVZy9WSk55L3U4VGNQbVRqbjBMc3FRU3o2dzRaa2tOTkJMaXdq?=
 =?utf-8?B?d1JEMmE0M0k1K05kZWgrMEcvMVRmZVhvejB6YTRiVVBkSGFORFdHNnFVQjhi?=
 =?utf-8?B?WkZBVGNsWmptZ1pCb01qd0lMaFg1cE5aK3BQTGUveHNUdnplQUV2V09EaytS?=
 =?utf-8?B?eXZFWERHS29uUTVRNVhjV3J1ZjNyVlcxbExhN045cTVnVlhhVkpUZUR0blR1?=
 =?utf-8?B?TnpCeDFCMlN2aWcwY1pSTnFjQnlKVGRTeXVjM3lBZWNHTnIyTFF2NWpHMHpD?=
 =?utf-8?B?YWhhVFBuNXVEL3ppRzNUb1MvbHB0d3U3TEE2aC9oZk1PT2tUWVF3VlZYajdK?=
 =?utf-8?B?Unpxb29iZDJvTE8yYmovWFJoL3BHbVB1WCthSEg3NmpOUS9MalN3TkhaSzB0?=
 =?utf-8?B?Nnl2WW5Gelh6UUg1MzFRelh1b0hTcklFamltWEkzRXlkVWhYUUZ1YUpvbDVR?=
 =?utf-8?B?VkQ5VGNraDNrdEdONE43ZzNmWVdobjZIclhCdkM4NEIwZFZEVWRXMUF5cXJD?=
 =?utf-8?B?L1k0WUcyalRlQUJjL00xeEhSVEdVcnJHY1Npb0ZOMmx1K1FvK28reVRLbmJo?=
 =?utf-8?B?UVJWL1MyamE3VTdRR29nT0ZLVG8vWksva0RqYnl3TGw1ZTJMOTlXR3FYaGZl?=
 =?utf-8?B?WHdIQXpWSzNjWFZtN3lnclM2WVI3NUM5TlhQSWE2ZWx3ZjAxUUE0dGowMysz?=
 =?utf-8?B?WTcxTk5BUCtNNTRLN2N5S0xxdXVqZEpXVnplb2hFQytYUEdSM1BMTVN3V0ZZ?=
 =?utf-8?B?TTczKzJaemJWeldaTk5XbGp6dmdFTGUwOXA3ZkZUblVKWmp6bzZtNENFQkRq?=
 =?utf-8?B?bkpyYTZhUWtVWHpyYXJkWlh6UHpQSjF2cjJ6U0dNUG1meTRxQjR4cVVaalds?=
 =?utf-8?B?YWQ5TExqZGRKVVN5Z084d3FMaXh0VVFKaUFMUFlDcGxKajYvUStsY2RMQ0RG?=
 =?utf-8?B?THFHdUl1bmdaRndMSXBvZDlVWmR1RlM4Y05oc1A3R2gzUHpaMTlCQkZncnFx?=
 =?utf-8?B?MHMvRDNRSzM5Q1J3RmxGd2piaFNBUGYyYVg3ai95T1ZUR25aaHhjMElxZmZG?=
 =?utf-8?B?MXNnZm5TVk5FRVRBdncxYlYzemNCM1UzQmxBS2V3U05VTUp0YkVlbHRCQzRZ?=
 =?utf-8?B?bDhhNENtY3JiLzMvcGtzOUJCMzg4R2d1QzVlQk1lam9KTmYzeDlncHFrRlFQ?=
 =?utf-8?B?NktJd1N3cnd6c3NiVG9jWVB6eG1MWnlYV0VKQTY5RlFQaEFramhCTGQ0bWdt?=
 =?utf-8?B?ZlpZMVpDaktjVy9PcWtMLzBuQWhrRThBc0JDUFh5aWZuaDFpeE8wbCtva0g3?=
 =?utf-8?B?U0hWVHBTVzdDVFlMRnd0SGZZUXFabmJHeDJHK3Q5SzE5QTZpUk8yLy8xMm05?=
 =?utf-8?B?MUlQRWttTW00ZzIxWmxZTXNHNUZWbGlYSm9zZ0d1ODZHZDZzMU9XNUhUMW5K?=
 =?utf-8?B?QnIvOVIyS1pCVm9FQmpDS0I3cnFOZG5Tak9GM1FBOGhudlNkWDRMa2FxRkhB?=
 =?utf-8?B?N0lCY21BS3JEaE53V01WMEhlK2x5cHZHWVA4NzlJd21UOW54S0pBV1Rjay9K?=
 =?utf-8?B?OWtEbzhmbW1td2d3M1M1dm5kTThId1J1cjJ4OU02RGY2eHplVmFLQWJlZ3Vh?=
 =?utf-8?B?TFRzcWJYaGtkYlR6aSsyY3RRSlN3S1dkU0JaQk52eE1lRjZBMHlTdTIxOWlo?=
 =?utf-8?B?NkdZdFZneHlxNU1halMybWJoTXNiKzQ4QkRzQk5PNmJXc1FjTVFOMzR3Y2pE?=
 =?utf-8?B?bHh5QTMwZldOY01LMWVFU2llSkFqeUtnRHU3ejNlUEVhT1VZKzFuSDdOU1NV?=
 =?utf-8?B?b3hEWXY1UmtrMmpDT3FPRnBoaEhVT1JQNW50OU9GenZoNnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?M09GMDZ5MmNVQkQ2cUpPUE9nRmNyZkVoT1pGOHBmcU9YNGFkbzlROVptT1FJ?=
 =?utf-8?B?WVNhaElHbUgzRUFSOWlWdm1pVUNPR0FTZ0daMnBzSDRrTUJHbEZLbE1scU1n?=
 =?utf-8?B?VmEzQ2I5YnlLaU1vdjdneUxYMzdCQThZUjBFZFF3SmpXT1p3Q2xITjBrTjBB?=
 =?utf-8?B?YURPalFJN21KU0pRWFR6NVo5NXFOT0t1NVBjMVpJMTUxT1EyRjg5TVcrMGUy?=
 =?utf-8?B?dGVGakdpYkJmV0svMGRLSituNFRaR1RlUnBNMWZibTR5bVhqOUozNDZoOFhT?=
 =?utf-8?B?NGpaazBvRnRYbWpmRTBBNXc5a21KRmx1NFk3ZTdQZXlnSFMweFUzYW82UXNx?=
 =?utf-8?B?M01mcjdaOTNFcmQ0SDhuZWRzVTIzd1FVeEhaeEJ6Wm9rTHlsQU10RXZQRTZB?=
 =?utf-8?B?bkJCMHRZTm9sWHZ0TXBFWjBDNmVNNUtjL1BtS21XVDJabWNCV2VMeEZSNDlj?=
 =?utf-8?B?cFN2TlA5REFmYm5FVlR6VFg5ZERBMkZsYWxWODN3L3JRbG1mVStldVF5ektz?=
 =?utf-8?B?QURRckRCSnVsa3lGdWdLd3FhNTl5bHlUc2d5clo3SVhIM1BwYkZFQ2xnVFp2?=
 =?utf-8?B?a0FCb293cllvRkNQNlIxeHRWS21kVk5xU0RtM09KcStyNHBtYmxuOXF1YjBs?=
 =?utf-8?B?QUJTT1p2YWxValZHWUtnN2pWRFJWRnBJeng4c3d4VE52Tmc1RWN3RjNSTEFZ?=
 =?utf-8?B?NlJJZitlekc4QnFBTWJ3eER2eWg2Z0wvV2ZwaXlrakdRbitVaEJjMTdLdjNu?=
 =?utf-8?B?NHA0Kyt1NXR5V25IekNxaGpRL3MwNUIrSUZxMm04enJYdkpTaWZVeldJMzFu?=
 =?utf-8?B?dmhKcnVEN1B6d1VHRC96NXJ0dGdJTzE3b25neWVlNElZOGxzd3J5TU50dFoz?=
 =?utf-8?B?VXZKTDlZR3JjRDNUOW1FZnBUbkhOd0d0Y2hXajhtcFVkWGswcTNpYy9zTlJs?=
 =?utf-8?B?SEZmUVA3OFlmS3k3eDIzRkNDMFl2RnJEM3FEYmNQY2Z5RnhEUVlpb0toc20x?=
 =?utf-8?B?VlBRL2tDSUEvVWZqc1JSNDJ1QTRicXFTUHdxeGExdHlUSG5YbXFzN1hOdGJr?=
 =?utf-8?B?WjJ3VlBNOEdOeTh5RHRNQmN6dkNiTWw3WjFBemRibC8zWU9PSnpjL0F1NGc2?=
 =?utf-8?B?UDBuZnhrcWxDN0NuaVIvaFRMK1BtNjUzcW5PNFpwYWRLaUZZSGd4QmxSU2xB?=
 =?utf-8?B?MC8rclBwaVBORHNwSmdoZUdwMGxzR1FOK2FHU0d2MHpNSmxtU3IxeW44YVpL?=
 =?utf-8?B?VHdEWUhNNzFVZ01EQS9YVjFqT2lYdUJLZEFNdlI3NTNKTTJjWVdmZHVBTGhX?=
 =?utf-8?B?azMwcG9WRlI3MUxnVlBiNldiTjAxQkx1Y0lCQVl5TEdWc0VQWXJlMXp0amtB?=
 =?utf-8?B?UENFdlN3b2xFc2IwbVBvNDBlZUplWUpHNXQxeGNaNXVqQ2w2UVQwWWw5MkRr?=
 =?utf-8?B?QkV4NVp1Q3lPeEhPMUM1YktvV3lrakJ4d0ltZG9LNmxwREJkNnFralJqb1gz?=
 =?utf-8?B?b1hGNlFnblZabHQ5NVRHVWZ0WDhzTUtDVEZCZ2s0Rk44dGFSN2grZmw1VWhF?=
 =?utf-8?B?NGRSNnhSQXJBa2lhemF4UVNiOTBiM1gweG5GdFM1YmdaLy8xYW4zaWdmRnlt?=
 =?utf-8?B?QWtlZzZPY0hub1RCTjJQYk5RY1VDTDdXQmRibVNUcTlVTjhFQy9MRDloazdT?=
 =?utf-8?B?dkZ2by9mc3VNd2J3TUpyTzFvbWRQM0FoYWVXbWFBd1lVZTJHRnpaMmY4VWh2?=
 =?utf-8?B?b1BHZFJ4dDFjQS9uVC9PeE1nVXFlQ0JRV0daUktMbGZTdXQzRmZDcDRvTmRn?=
 =?utf-8?B?YVJ2ZTRYQUJCZ2FETXdGM3V6WkxObFN5ZDRmWXZCWDNnYndFZ1lIcjE4cE80?=
 =?utf-8?B?b1pSTGJjdk9aR1dpQWZYOG11MnpNMTExUUNNUUJEMmJPaGNDUjhCTU82SE9h?=
 =?utf-8?B?M1hQUXF3U0RnajJpL3h6Y1lQTjNwY0QydkRuV3pxMTBIc3NSajB1dFNvZ3lY?=
 =?utf-8?B?cW84RWhLMVFjbFVxUlNIRlhuMTk2VWp6TXJ1RlViK3JUd0VOZ2EyNGw1bGpV?=
 =?utf-8?B?dzZQVU5OMXp5K21jNmR3NnlBb0pzK2JCc3hETEhva1plaGxERy9KZUx2QVhz?=
 =?utf-8?B?Z1Y0L01Bam5XWjY3bnR3Y0hScVp6TWVuUUUrK3JZY1BveFc5bmMzZjlpbm1n?=
 =?utf-8?B?T2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FED0252A31D86846A796DC211091037C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5eddd04-4057-4f69-fa8b-08dd0db3ef82
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2024 00:47:42.4708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pyHBd1MVyov3y3woeqPAwpL284SjthaiVnkdaQBDRGIyov8ZCd1rpiQM2Fe6UFQVIXe4FluoA1ahpIYbOGf2F2NYlWhG0KX8a9Q51JG7naY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7705
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTExLTIxIGF0IDE5OjU3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gwqAN
Cj4gK3N0YXRpYyB2b2lkIHRkeF9ub192Y3B1c19lbnRlcl9zdGFydChzdHJ1Y3Qga3ZtICprdm0p
DQo+ICt7DQoNCkkgd29uZGVyIGlmIGFuIG1tdSB3cml0ZSBsb2NrIGFzc2VydCBoZXJlIHdvdWxk
IGJlIGV4Y2Vzc2l2ZS4NCg0KPiArCWt2bV9tYWtlX2FsbF9jcHVzX3JlcXVlc3Qoa3ZtLCBLVk1f
UkVRX05PX1ZDUFVfRU5URVJfSU5QUk9HUkVTUyk7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyB2b2lk
IHRkeF9ub192Y3B1c19lbnRlcl9zdG9wKHN0cnVjdCBrdm0gKmt2bSkNCj4gK3sNCj4gKwlzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHU7DQo+ICsJdW5zaWduZWQgbG9uZyBpOw0KPiArDQo+ICsJa3ZtX2Zv
cl9lYWNoX3ZjcHUoaSwgdmNwdSwga3ZtKQ0KPiArCQlrdm1fY2xlYXJfcmVxdWVzdChLVk1fUkVR
X05PX1ZDUFVfRU5URVJfSU5QUk9HUkVTUywgdmNwdSk7DQo+ICt9DQo+ICsNCg0K

