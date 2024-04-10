Return-Path: <kvm+bounces-14119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 602CD89F3C2
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 15:12:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E28351F2A5A3
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 13:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8D1E15E213;
	Wed, 10 Apr 2024 13:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="npHLzJPV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325B513D2BC;
	Wed, 10 Apr 2024 13:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712754728; cv=fail; b=pG0ffSm6ZgxPwyMKzw7sGtkII+Uk1fCTO8ndzwhE8jF5yV4El6NyDKpZKUDpkpx7/6vGOEw1fAZ7d626sSF7g8ancua2ypmdjrIp+F0i0deFdXj2SCtFLCWTzCSfvrD/RHKXj9fEHwu6LoYn3HQbHYyoj7I7zQULi8EodqndLiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712754728; c=relaxed/simple;
	bh=mKODKchrrAD1JUg1EUQBs0hYy8UYSfcBe7oRQDIuq4U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l3ft2dTDY/MTg/JgR5oEjXpGRX6pXLZKV9RY1Sqm7v0pqItg4I3w2St8kPmbm6bJxSvlQ5Y0601VBvUwgLfaoUTKh+n0hvEyjf4D/dI1+6P1fn54vCNd22c1tEVkxJz0g96XCldi/10KRSDNtqHg8h6dfcFHw2gBuSVf/H0mhck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=npHLzJPV; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712754727; x=1744290727;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mKODKchrrAD1JUg1EUQBs0hYy8UYSfcBe7oRQDIuq4U=;
  b=npHLzJPVFF0iyREF8O8FOampXSSpvMJX0/BH6jj4VB6h1iu7TOGd+/fY
   WH7YRKw5PgNTIUJMBg227zdRQ+P1BKPaqkzxUAr//a6PmN59k26my+S9a
   yIydPUf9GYQrd84JHtkNcIDqXhwIYKluc3yxk6EsFkExpA7SaPk68FQcv
   GzAl7bIqOKl9Kg4TVxAM6Hw0ynWvt8thzZE1nbgiDn8MielKwDm8DkqDa
   EH8z2xYVdtoKkD/hA+k5co1hlD3GO+Eg1ZApNzJl6c5K+DOxdXvuumeqp
   UQGBTyREzuadH4rgu4JoD80NbduiypMPAM9AYveYXHBf+a12xvsMsqXw0
   A==;
X-CSE-ConnectionGUID: +bTRm33rQO6L0w9ZNhQ6VA==
X-CSE-MsgGUID: puDCZQ7STu66lC4ym/nPeg==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="30597244"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="30597244"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 06:12:07 -0700
X-CSE-ConnectionGUID: 6Qsko+SdQXu3WMdQqvNRqg==
X-CSE-MsgGUID: YOhDIBdoSB+Y8XcSy5FAMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="20587392"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Apr 2024 06:12:06 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Apr 2024 06:12:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Apr 2024 06:12:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 10 Apr 2024 06:12:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 10 Apr 2024 06:12:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuV32Q1j1UxHQVK9NY3hO+IXhcP87dFqxwjv3XHT3SwQof+Two/Ic+RlN1VBXnQqCL3sdG4MHbBIm3LUNbSQ10CBzgMrRBCPu8TzQHaZfkVmrKcTKSW8f2IxBYD0Cj6xcKb/oYkLQZLQ81s7az8cGAroVg+8aW8e5eV27nlBL6ChlLxxdZ74n2sOpB6iPRNFFgO3cap82NjPkg1vCHIsJ19nhXDUflCI8NwiR7coPuAtzozJLFmYfp5lOtXrvaZPADqYPGWYOMNJ25Z+TngyzCZI768jQZqKTedfiE4k6pL9WprmMsg9t3nhqMzJgbNy7DeymQWKelg5qm4XHCwbVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKODKchrrAD1JUg1EUQBs0hYy8UYSfcBe7oRQDIuq4U=;
 b=CPom3Ds/56xTehGR+hneJzElYRVwHR09GxOiIz0ljrotenzKBTSaiTbDE3C45jNkBT0szbY0EFgTpNZbeEoxkBVMwo6fcj1gYbBvrPCz109zT/0jW/X7Nnn6+R5C4XHcVcQHCltHHRfaonjKb//WxFtrTEsb/pA8+X+vzWQLDOIoe57nhDAEoiwWsXeFTW13yXzmm8iximgm/2AJ6v6t+i4sgkgMolPLhxhWzk0zGO3lxSKvo0SDyIw07nIXQ1914Qxfi/CHVPFvnJCBcdNSEYOA6GGXScqsj18suVFOotyGo2oEvgf5dvdzi35+pCsjHtHKi/cxE0xspb67jo/qow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB5900.namprd11.prod.outlook.com (2603:10b6:806:238::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Wed, 10 Apr
 2024 13:12:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 10 Apr 2024
 13:12:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAA==
Date: Wed, 10 Apr 2024 13:12:01 +0000
Message-ID: <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
	 <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>
	 <20240322212321.GA1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240322212321.GA1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB5900:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +v3ydgtg6D/KYVNJyuzra3na5rKhyl5QMc7S3kVxSEaikp6mpCd/SuaFele/wqlCsErHVmEhzhc7I5XiaLJA3zQj6pcn+Xx6ly7Z9pq7yEVQ6UokRckWAMyqHdGOeRvqbZoKdNBJHqOGvYoDCGUova0BWHr3kXAb3eN8NuB9tc226XA4D/OZmdRicYAX5kRHFYUT9N3qEiuoWhNMCtWNCgnyf5sdwQk1rwauvsGPB16k1IQhZYDpz+8Az3n+AYoY1KO2nOgWsxu6gkFsln/nBLtU2Vvj1hqwDODRVoQ2dFu+blRqOYdB3GQDDIPpOCCyZ/bNbqDUbAcHQFrBH9e5XsYz8xZ6yGpmXdGQ0Y2gqS+CR+Ip01Nt/jmHMUxKKroIXLwznOlCdTD/7RAedDHYll3coe5GpPfO/nKYYPg/iSYVx29PbNI/22qO4a3PfdIypvSvjc6MBVuSbQkJLgC65o5yI6fVO9m9tgQtFYEoKlxhbhKLzM5dwCQNPmUXoPLk3e+8xWyaR9yzYbMk6gDBvbziTebEiMiz7OaCdG+OMVg1aQNUTb4KMGoaEMzyfRQqusus3F5mFpsSiIZFzFk3VE07/gY9ZvyXOIITUitKGGDbw5w6QvyWa4BP5IrcPL8PG8gmyDP3htOsPRcf5oKQO+8/R6TnHHJcPVjB0eHh8wg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aENHNDhvaHJHcDVrVEh3Zm5sblFGYk9TMEN4dWpjS1RsV1VRaGsrKytzcyt1?=
 =?utf-8?B?MnpyOXRHbnNLenYzUDlTL21ad1N2NVpJUW12K0hhOHNlSElOWkJRYTNoTnFD?=
 =?utf-8?B?WVU4WXRmZm5iL3RONk92N0FzYXRZTEd4eDZEbjhRSDl1TWFoRVBueWFhVGE1?=
 =?utf-8?B?RFA5dVplTW02Y2J3ZGhQcytyd1dwQlNYY3dUNUM4Tjh4Z1g3NmhJbHFuRVVF?=
 =?utf-8?B?WHJ4NlBIQnFKOUQ3VmkrOXhVaG5lcFRkZU9uR1YwVTJQZXJ4YkF3YkptMWUv?=
 =?utf-8?B?RHlFMG9QZW5qb2FKeVFkNW1JSFdvRWlSeGJNRGNOTlNuQlZueTU0czJKcXp6?=
 =?utf-8?B?Rm1NWHFyYUI1VWptSU1vUjhIYjkySXl6UTZ6WjB5S0gzeVd2Y1RBakFWYnMy?=
 =?utf-8?B?ZlgyTUJHU1VvdjdmVU1IZVVvci9tdE5mbXB6NURpdFpEREpyQ1FtWTNlTkhZ?=
 =?utf-8?B?YUFyelRWcHlGMk9wRW1lR2lueWhiNzJRb3pMcCt2UHdkMWZQcmh4KzZRUWQ4?=
 =?utf-8?B?OEs3TzlVQ3dEeUdNYUVxT1pCK2d2c3VJUW12YW90VGJGeGpRQWV0QUVBWGVH?=
 =?utf-8?B?b3FmbDNzTHptYzVnTEJ4VGdiNjFvRjRtUjhSRVBVVDBHUEVmZVFxTTBaSWlu?=
 =?utf-8?B?c3NZVkdaNUxFR1dVekZwQzJCRDdmWGMvcmdIaUlBMmhmQUFmTW13SURRa3kx?=
 =?utf-8?B?S0J0bGdnU0xrUDdUTVN5aldualkxWkIvcXlKb2d0VG96MEhKeVVTQlNNK242?=
 =?utf-8?B?Y0Y4Zjk0V0xSaVlyUlJIcU9EdjkxekN5ZVBrQVU2dEZwR3VHQ21Uck0yUlVv?=
 =?utf-8?B?VXcrUndQN1NoeDV0SXMxYnJNVFQrditYVm85bWlLYWVRNGJRajE4cDhIbHZI?=
 =?utf-8?B?RVZpV29sVWlGc0NxTkFMdzhON2MwNFh2WlRiV1h0OHFaTmdXQ3NHRWdhZjda?=
 =?utf-8?B?VWxjaGhpUEM4K1JnNVo3MTk3N0lSVU45S2p1VnZHRkpiUU9NZm9NeDZTMVFL?=
 =?utf-8?B?NVVReCtycUdOK0tvQlJkWEw2OGpDTTlIeVJza0I2Q0djbzhTcENNWGhTUXdW?=
 =?utf-8?B?QjRCOHFHcnR6Y0RmNDJUTjczNVdpQmc5NGdHaTlwaERiQnFkWW9jNUFsMmVZ?=
 =?utf-8?B?cGJFTGdhc2dpQUZFb1YyaGo5dEN5OGt4K2lKN2lSUmdadlhZUFV5ZEoybWoy?=
 =?utf-8?B?aEgrUDloTktoZUhiRkl6eVJBMTIwd2xlT2VZcjIra0VOV1V1aTYwd0N3aTdN?=
 =?utf-8?B?cE53MlNpYWdSRGVUVVhFK1pTclkwR1UrSWhmWkt5ejF1ajAwd2Y4N2sxV2Jh?=
 =?utf-8?B?SGk0aG1pZGFRdXhIdVlwbXJvZERxV1hGdkFNQ0llMW40TUxGYXlhSExDRndU?=
 =?utf-8?B?TjQ2L0VjMmJzVWNvcW1hWlp3RkNuY1FTZ1NZR3F6TnFRRmhCMnNzbnpwWnVs?=
 =?utf-8?B?YXUrTVVUL1BiQ0Ywb3ZkWTRWak9rM1hWMHM4VzVhRTREV1J3TTY0VWl4WXlp?=
 =?utf-8?B?Nmh3d3N3SGl6QUZHcHZKMUVqWTVWM3c0eCtRa290Z1dWYU1FVzZpZWhyb3NH?=
 =?utf-8?B?RnY4dkVDMlNkM1JZTkprdnljRXdiRHVwMVhRdXVrcXFlTUpRcDJ3YWRBd09X?=
 =?utf-8?B?dUcyamt4bkhCeGVNYjVPck1vRVMzcmVKdzlHL0NBNjFGVE1qWndaMlJxM1Uv?=
 =?utf-8?B?NmdkS3ZGQWR3MjhFd2ltQ0lxRUl6MlVwR1dNTXJaTnlGc0NIUUl2UDBEUjJX?=
 =?utf-8?B?QmhVY2VSZGRycmx5Tm9VT0tXbFdQZG83am9wY0VNRTd3d0ZoQ3VPZVp1Qk5m?=
 =?utf-8?B?cUNFRm9XcUhZcDV3L1dHQ1Rsd3A3RGFranB3VTJvNGo1bUxxUjhRL011ZVJQ?=
 =?utf-8?B?cDNCMXJONWpzNlI4YVNtdFBtMXg1MmY4d0ZTQTlaNEF5UGNpcjliQVFSTDVh?=
 =?utf-8?B?dVQ0bTlsK2R4VDI0S2VCYVgrMU15cHRNTTAvQ2t6cEltNEdzR0ErQUx6YjZW?=
 =?utf-8?B?U21jZlo2KzJVOFdnc1J0WFNLcmNzOXJUelNNbStzampEUUthWFBYTFBQUTJX?=
 =?utf-8?B?aUIxR2xmM3BJdkRBa2ZTMmtFdmNrVlV5cWpiRDZTM2p3bExWWi93Zm9JL3Rs?=
 =?utf-8?B?SmpkUVp3Y0lDTFM1NmtwR01JdmNSNEJlcU9COGZUQVRGQVUvSG9ZYUE5MkNR?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8B007AF3D125149BB8B42BE520E4DC3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdc7dd75-77f5-4160-54fd-08dc595fcf14
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2024 13:12:01.0499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 46rOAmycxehWgRkpd0OG9OyQg1B+WN2q5J2VijEbrjlUNPodj+IVj5YdFhAljZDIgCoZSLe94WwyvLJUvpJmaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5900
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTIyIGF0IDE0OjIzIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiA+ICsJciA9IGF0b21pY19yZWFkKCZlbmFibGUuZXJyKTsNCj4gPiA+ICsJaWYgKCFyKQ0K
PiA+ID4gKwkJciA9IHRkeF9tb2R1bGVfc2V0dXAoKTsNCj4gPiA+ICsJZWxzZQ0KPiA+ID4gKwkJ
ciA9IC1FSU87DQo+ID4gPiArCW9uX2VhY2hfY3B1KHZteF9vZmYsICZlbmFibGUuZW5hYmxlZCwg
dHJ1ZSk7DQo+ID4gPiArCWNwdXNfcmVhZF91bmxvY2soKTsNCj4gPiA+ICsJZnJlZV9jcHVtYXNr
X3ZhcihlbmFibGUuZW5hYmxlZCk7DQo+ID4gPiArDQo+ID4gPiArb3V0Og0KPiA+ID4gKwlyZXR1
cm4gcjsNCj4gPiA+ICt9DQo+ID4gDQo+ID4gQXQgbGFzdCwgSSB0aGluayB0aGVyZSdzIG9uZSBw
cm9ibGVtIGhlcmU6DQo+ID4gDQo+ID4gS1ZNIGFjdHVhbGx5IG9ubHkgcmVnaXN0ZXJzIENQVSBo
b3RwbHVnIGNhbGxiYWNrIGluIGt2bV9pbml0KCksIHdoaWNoIGhhcHBlbnMNCj4gPiB3YXkgYWZ0
ZXIgdGR4X2hhcmR3YXJlX3NldHVwKCkuDQo+ID4gDQo+ID4gV2hhdCBoYXBwZW5zIGlmIGFueSBD
UFUgZ29lcyBvbmxpbmUgKkJFVFdFRU4qIHRkeF9oYXJkd2FyZV9zZXR1cCgpIGFuZA0KPiA+IGt2
bV9pbml0KCk/DQo+ID4gDQo+ID4gTG9va3Mgd2UgaGF2ZSB0d28gb3B0aW9uczoNCj4gPiANCj4g
PiAxKSBtb3ZlIHJlZ2lzdGVyaW5nIENQVSBob3RwbHVnIGNhbGxiYWNrIGJlZm9yZSB0ZHhfaGFy
ZHdhcmVfc2V0dXAoKSwgb3INCj4gPiAyKSB3ZSBuZWVkIHRvIGRpc2FibGUgQ1BVIGhvdHBsdWcg
dW50aWwgY2FsbGJhY2tzIGhhdmUgYmVlbiByZWdpc3RlcmVkLg0KPiA+IA0KPiA+IFBlcmhhcHMg
dGhlIHNlY29uZCBvbmUgaXMgZWFzaWVyLCBiZWNhdXNlIGZvciB0aGUgZmlyc3Qgb25lIHdlIG5l
ZWQgdG8gbWFrZSBzdXJlDQo+ID4gdGhlIGt2bV9jcHVfb25saW5lKCkgaXMgcmVhZHkgdG8gYmUg
Y2FsbGVkIHJpZ2h0IGFmdGVyIHRkeF9oYXJkd2FyZV9zZXR1cCgpLg0KPiA+IA0KPiA+IEFuZCBu
byBvbmUgY2FyZXMgaWYgQ1BVIGhvdHBsdWcgaXMgZGlzYWJsZWQgZHVyaW5nIEtWTSBtb2R1bGUg
bG9hZGluZy4NCj4gPiANCj4gPiBUaGF0IGJlaW5nIHNhaWQsIHdlIGNhbiBldmVuIGp1c3QgZGlz
YWJsZSBDUFUgaG90cGx1ZyBkdXJpbmcgdGhlIGVudGlyZQ0KPiA+IHZ0X2luaXQoKSwgaWYgaW4g
dGhpcyB3YXkgdGhlIGNvZGUgY2hhbmdlIGlzIHNpbXBsZT8NCj4gPiANCj4gPiBCdXQgYW55d2F5
LCB0byBtYWtlIHRoaXMgcGF0Y2ggY29tcGxldGUsIEkgdGhpbmsgeW91IG5lZWQgdG8gcmVwbGFj
ZQ0KPiA+IHZteF9oYXJkd2FyZV9lbmFibGUoKSB0byB2dF9oYXJkd2FyZV9lbmFibGUoKSBhbmQg
ZG8gdGR4X2NwdV9lbmFibGUoKSB0byBoYW5kbGUNCj4gPiBURFggdnMgQ1BVIGhvdHBsdWcgaW4g
X3RoaXNfIHBhdGNoLg0KPiANCj4gVGhlIG9wdGlvbiAyIHNvdW5kcyBlYXNpZXIuIEJ1dCBoYXJk
d2FyZV9lbmFibGUoKSBkb2Vzbid0IGhlbHAgYmVjYXVzZSBpdCdzDQo+IGNhbGxlZCB3aGVuIHRo
ZSBmaXJzdCBndWVzdCBpcyBjcmVhdGVkLiBJdCdzIHJpc2t5IHRvIGNoYW5nZSBpdCdzIHNlbWFu
dGljcw0KPiBiZWNhdXNlIGl0J3MgYXJjaC1pbmRlcGVuZGVudCBjYWxsYmFjay4NCj4gDQo+IC0g
RGlzYWJsZSBDUFUgaG90IHBsdWcgZHVyaW5nIFREWCBtb2R1bGUgaW5pdGlhbGl6YXRpb24uDQoN
CkFzIHdlIHRhbGtlZCwgaXQgdHVybnMgb3V0IGl0IGlzIHByb2JsZW1hdGljIHRvIGRvIHNvLCBi
ZWNhdXNlIGNwdXNfcmVhZF9sb2NrKCkNCmlzIGFsc28gY2FsbGVkIGJ5IHNvbWUgb3RoZXIgaW50
ZXJuYWwgZnVuY3Rpb25zIGxpa2Ugc3RhdGljX2NhbGxfdXBkYXRlKCkuICBJZg0Kd2UgdGFrZSBj
cHVzX3JlYWRfbG9jaygpIGZvciB0aGUgZW50aXJlIHZ0X2luaXQoKSB0aGVuIHdlIHdpbGwgaGF2
ZSBuZXN0ZWQNCmNwdXNfcmVhZF9sb2NrKCkuDQoNCj4gLSBEdXJpbmcgaGFyZHdhcmVfc2V0dXAo
KSwgZW5hYmxlIFZNWCwgdGR4X2NwdV9lbmFibGUoKSwgZGlzYWJsZSBWTVgNCj4gwqAgb24gb25s
aW5lIGNwdS4gRG9uJ3QgcmVseSBvbiBLVk0gaG9va3MuDQo+IC0gQWRkIGEgbmV3IGFyY2gtaW5k
ZXBlbmRlbnQgaG9vaywgaW50IGt2bV9hcmNoX29ubGluZV9jcHUoKS4gSXQncyBjYWxsZWQgYWx3
YXlzDQo+IMKgIG9uIGNwdSBvbmxpbmluZy4gSXQgZXZlbnR1YWxseSBjYWxscyB0ZHhfY3B1X2Vu
YWJlbCgpLiBJZiBpdCBmYWlscywgcmVmdXNlDQo+IMKgIG9ubGluaW5nLg0KDQpTbyB0aGUgcHVy
cG9zZSBvZiBrdm1fYXJjaF9vbmxpbmVfY3B1KCkgaXMgdG8gYWx3YXlzIGRvICJWTVhPTiArDQp0
ZHhfY3B1X2VuYWJsZSgpICsgVk1YT0ZGIiBfcmVnYXJkbGVzc18gb2YgdGhlIGt2bV91c2FnZV9j
b3VudCwgc28gdGhhdCB3ZSBjYW4NCm1ha2Ugc3VyZSB0aGF0Og0KDQpXaGVuIFREWCBpcyBlbmFi
bGVkIGJ5IEtWTSwgYWxsIG9ubGluZSBjcHVzIGFyZSBURFgtY2FwYWJsZSAoaGF2ZSBkb25lDQp0
ZHhfY3B1X2VuYWJsZSgpIHN1Y2Nlc3NmdWxseSkuDQoNCkFuZCB0aGUgY29kZSB3aWxsIGJlIGxp
a2U6DQoNCglzdGF0aWMgaW50IGt2bV9vbmxpbmVfY3B1KHVuc2lnbmVkIGludCBjcHUpDQoJew0K
CQltdXRleF9sb2NrKCZrdm1fbG9jayk7DQoJCXJldCA9IGt2bV9hcmNoX29ubGluZV9jcHUoY3B1
KTsNCgkJaWYgKCFyZXQgJiYga3ZtX3VzYWdlX2NvdW50KQ0KCQkJcmV0ID0gX19oYXJkd2FyZV9l
bmFibGVfbm9sb2NrKCk7DQoJCW11dGV4X3VubG9jaygma3ZtX2xvY2spOw0KCX0NCg0KVGhpcyB3
aWxsIG5lZWQgYW5vdGhlciBrdm1feDg2X29wcy0+b25saW5lX2NwdSgpIHdoZXJlIHdlIGNhbiBp
bXBsZW1lbnQgdGhlIFREWA0Kc3BlY2lmaWMgIlZNWE9OICsgdGR4X2NwdV9lbmFibGUoKSArIFZN
WE9GRiI6DQoNCglpbnQga3ZtX2FyY2hfb25saW5lX2NwdSh1bnNpZ25lZCBpbnQgY3B1KQ0KCXsN
CgkJcmV0dXJuIHN0YXRpY19jYWxsKGt2bV94ODZfb25saW5lX2NwdSkoY3B1KTsNCgl9DQoNClNv
bWVob3cgSSBkb24ndCBxdWl0ZSBsaWtlIHRoaXMgYmVjYXVzZTogMSkgaXQgaW50cm9kdWNlcyBh
IG5ldyBrdm1feDg2X29wcy0NCj5vbmxpbmVfY3B1KCk7IDIpIGl0J3MgYSBsaXR0bGUgYml0IHNp
bGx5IHRvIGRvICJWTVhPTiArIHRkeF9jcHVfZW5hYmxlKCkgKw0KVk1YT0ZGIiBqdXN0IGZvciBU
RFggYW5kIHRoZW4gaW1tZWRpYXRlbHkgZG8gVk1YT04gd2hlbiB0aGVyZSdzIEtWTSB1c2FnZS4N
Cg0KQW5kIElJVUMsIGl0IHdpbGwgTk9UIHdvcmsgaWYga3ZtX29ubGluZV9jcHUoKSBoYXBwZW5z
IHdoZW4ga3ZtX3VzYWdlX2NvdW50ID4gMDoNClZNWE9OIGhhcyBhY3R1YWxseSBhbHJlYWR5IGJl
ZW4gZG9uZSBvbiB0aGlzIGNwdSwgc28gdGhhdCB0aGUgIlZNWE9OIiBiZWZvcmUNCnRkeF9jcHVf
ZW5hYmxlKCkgd2lsbCBmYWlsLiAgUHJvYmFibHkgdGhpcyBjYW4gYmUgYWRkcmVzc2VkIHNvbWVo
b3csIGJ1dCBzdGlsbA0KZG9lc24ndCBzZWVtIG5pY2UuDQoNClNvIHRoZSBhYm92ZSAib3B0aW9u
IDEiIGRvZXNuJ3Qgc2VlbSByaWdodCB0byBtZS4NCg0KQWZ0ZXIgdGhpbmtpbmcgYWdhaW4sIEkg
dGhpbmsgd2UgaGF2ZSBiZWVuIHRvbyBuZXJ2b3VzIGFib3V0ICJsb3NpbmcgDQpDUFUgaG90cGx1
ZyBiZXR3ZWVuIHRkeF9lbmFibGUoKSBhbmQga3ZtX2luaXQoKSwgYW5kIHdoZW4gdGhlcmUncyBu
byBLVk0gDQp1c2FnZSIuDQoNCkluc3RlYWQsIEkgdGhpbmsgaXQncyBhY2NlcHRhYmxlIHdlIGRv
bid0IGRvIHRkeF9jcHVfZW5hYmxlKCkgZm9yIG5ldyANCkNQVSB3aGVuIGl0IGlzIGhvdHBsdWdn
ZWQgZHVyaW5nIHRoZSBhYm92ZSB0d28gY2FzZXMuDQoNCldlIGp1c3QgbmVlZCB0byBndWFyYW50
ZWUgYWxsIG9ubGluZSBjcHVzIGFyZSBURFggY2FwYWJsZSAid2hlbiB0aGVyZSdzIA0KcmVhbCBL
Vk0gdXNhZ2UsIGkuZS4sIHRoZXJlJ3MgcmVhbCBWTSBydW5uaW5nIi4NCg0KU28gIm9wdGlvbiAy
IjoNCg0KSSBiZWxpZXZlIHdlIGp1c3QgbmVlZCB0byBkbyB0ZHhfY3B1X2VuYWJsZSgpIGluIHZ0
X2hhcmR3YXJlX2VuYWJsZSgpIA0KYWZ0ZXIgdm14X2hhcmR3YXJlX2VuYWJsZSgpOg0KDQoxKSBX
aGVuIHRoZSBmaXJzdCBWTSBpcyBjcmVhdGVkLCBLVk0gd2lsbCB0cnkgdG8gZG8gdGR4X2NwdV9l
bmFibGUoKSBmb3IgDQp0aG9zZSBDUFVzIHRoYXQgYmVjb21lcyBvbmxpbmUgYWZ0ZXIgdGR4X2Vu
YWJsZSgpLCBhbmQgaWYgYW55IA0KdGR4X2NwdV9lbmFibGVkKCkgZmFpbHMsIHRoZSBWTSB3aWxs
IG5vdCBiZSBjcmVhdGVkLiAgT3RoZXJ3aXNlLCBhbGwgDQpvbmxpbmUgY3B1cyBhcmUgVERYLWNh
cGFibGUuDQoNCjIpIFdoZW4gdGhlcmUncyByZWFsIFZNIHJ1bm5pbmcsIGFuZCB3aGVuIGEgbmV3
IENQVSBjYW4gc3VjY2Vzc2Z1bGx5IA0KYmVjb21lIG9ubGluZSwgaXQgbXVzdCBiZSBURFgtY2Fw
YWJsZS4NCg0KRmFpbHVyZSBvZiB0ZHhfY3B1X2VuYWJsZSgpIGluIDIpIGlzIG9idmlvdXNseSBm
aW5lLg0KDQpUaGUgY29uc2VxdWVuY2Ugb2YgZmFpbHVyZSB0byBkbyB0ZHhfY3B1X2VuYWJsZSgp
IGluIDEpIGlzIHRoYXQsIGJlc2lkZXMgDQpWTSBjYW5ub3QgYmUgY3JlYXRlZCwgdGhlcmUgbWln
aHQgYmUgc29tZSBvbmxpbmUgQ1BVcyBhcmUgbm90IA0KVERYLWNhcGFibGUgd2hlbiBURFggaXMg
bWFya2VkIGFzIGVuYWJsZWQuDQoNCkl0J3MgZmluZSBmcm9tIEtWTSdzIHBlcnNwZWN0aXZlLCBi
ZWNhdXNlIGxpdGVyYWxseSBubyBWTSBpcyBydW5uaW5nLg0KDQpGcm9tIGhvc3Qga2VybmVsJ3Mg
cGVyc3BlY3RpdmUsIHRoZSBvbmx5IHRyaWNreSB0aGluZyBpcyAjTUMgaGFuZGxlci4gDQpJdCB0
cmllcyB0byB1c2UgU0VBTUNBTEwgdG8gcmVhZCB0aGUgZmF1bHR5IHBhZ2UncyBzdGF0dXMgdG8g
ZGV0ZXJtaW5lIA0Kd2hldGhlciBpdCBpcyBhIFREWCBwcml2YXRlIHBhZ2UuICBJZiAjTUMgaGFw
cGVucyBvbiB0aG9zZSANCm5vbi1URFgtY2FwYWJsZSBjcHVzLCB0aGVuIHRoZSBTRUFNQ0FMTCB3
aWxsIGZhaWwuICBCdXQgdGhhdCBpcyBhbHNvIA0KZmluZSBhcyB3ZSBkb24ndCBuZWVkIGEgcHJl
Y2lzZSByZXN1bHQgYW55d2F5Lg0KDQpPcHRpb24gMzoNCg0KV2Ugd2FudCBzdGlsbCB0byBtYWtl
IHN1cmUgb3VyIGdvYWw6wqANCg0KV2hlbiBURFggaXMgZW5hYmxlZCBieSBLVk0sIGFsbCBvbmxp
bmUgY3B1cyBhcmUgVERYLWNhcGFibGUuDQoNCkZvciB0aGF0LCB3ZSBjYW4gcmVnaXN0ZXIgYW4g
KmFkZGl0aW9uYWwqIFREWCBzcGVjaWZpYyBDUFUgaG90cGx1ZyBjYWxsYmFjaw0KcmlnaHQgYWZ0
ZXIgdGR4X2VuYWJsZSgpIHRvIGhhbmRsZSBhbnkgQ1BVIGhvdHBsdWcgImJldHdlZW4gdGR4X2Vu
YWJsZSgpIGFuZA0Ka3ZtX2luaXQoKSwgYW5kIHdoZW4gdGhlcmUncyBubyBLVk0gdXNhZ2UiLg0K
DQpTcGVjaWZpY2FsbHksIHdlIGNhbiB1c2UgZHluYW1pY2FsbHkgYWxsb2NhdGVkIENQVSBob3Rw
bHVnIHN0YXRlIHRvIGF2b2lkIGhhdmluZw0KdG8gaGFyZC1jb2RlIGFub3RoZXIgS1ZNLVREWC1z
cGVjaWZpYyBDUFUgaG90cGx1ZyBjYWxsYmFjayBzdGF0ZToNCg0KCXIgPSBjcHVocF9zZXR1cF9z
dGF0ZV9ub2NhbGxzKENQVUhQX0FQX0tWTV9EWU4sICJrdm0vY3B1L3RkeDpvbmxpbmUiLCAgICAg
ICAgDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHRkeF9vbmxpbmVfY3B1
LCBOVUxMKTsNCg0KSW4gdGR4X29ubGluZV9jcHUoKSwgd2UgZG8gdGR4X2NwdV9lbmFibGUoKSBp
ZiBlbmFibGVfdGR4IGlzIHRydWUuDQoNClRoZSBwcm9ibGVtIGlzIGlmIHRkeF9vbmxpbmVfY3B1
KCkgaGFwcGVucyB3aGVuIHRoZXJlJ3MgYWxyZWFkeSBLVk0gdXNhZ2UsIHRoZQ0Ka3ZtX29ubGlu
ZV9jcHUoKSBoYXMgYWxyZWFkeSBkb25lIFZNWE9OLiAgU28gdGR4X29ubGluZV9jcHUoKSB3aWxs
IG5lZWQgdG8gZ3JhYg0KdGhlIEBrdm1fbG9jayBtdXRleCBhbmQgY2hlY2sgQGt2bV91c2FnZV9j
b3VudCB0byBkZXRlcm1pbmUgd2hldGhlciB0byBkbyBWTVhPTg0KYmVmb3JlIHRkeF9jcHVfZW5h
YmxlKCkuDQoNCkhvd2V2ZXIgYm90aCBAa3ZtX2xvY2sgbXV0ZXggYW5kIEBrdm1fdXNhZ2VfY291
bnQgYXJlIGluIGt2bS5rbywgYW5kIGl0J3Mgbm90DQpuaWNlIHRvIGV4cG9ydCBzdWNoIGxvdyBs
ZXZlbCB0aGluZyB0byBrdm0taW50ZWwua28gZm9yIFREWC4NCg0KT3B0aW9uIDQ6DQoNClRvIGF2
b2lkIGV4cG9ydGluZyBAa3ZtX2xvY2sgYW5kIEBrdm1fdXNhZ2VfY291bnQsIHdlIGNhbiBzdGls
bCByZWdpc3RlciB0aGUNClREWC1zcGVjaWZpYyBDUFUgaG90cGx1ZyBjYWxsYmFjaywgYnV0IGNo
b29zZSB0byBkbyAidW5jb25kaXRpb25hbA0KdGR4X2NwdV9lbmFibGUoKSIgdy9vIGRvaW5nIFZN
WE9OIGluIHRkeF9vbmxpbmVfY3B1KCkuICBJZiB0aGF0IGZhaWxzIGR1ZSB0bw0KVk1YT04gaGFz
bid0IGJlZW4gZG9uZSwgbGV0IGl0IGZhaWwuICBUaGlzIGJhc2ljYWxseSBtZWFuczoNCg0KV2hl
biBURFggaXMgZW5hYmxlZCwgS1ZNIGNhbiBvbmx5IG9ubGluZSBDUFUgd2hlbiB0aGVyZSdzIHJ1
bm5pbmcgVk0uDQoNClRvIHN1bW1hcml6ZToNCg0KSSB0aGluayAib3B0aW9uIDIiIHNob3VsZCBi
ZSB0aGUgYmVzdCBzb2x1dGlvbiBmb3Igbm93LiAgSXQncyBlYXN5IHRvIGltcGxlbWVudA0KYW5k
IHlldCBoYXMgbm8gcmVhbCBpc3N1ZS4NCg0KQW55IGNvbW1lbnRzPw0K

