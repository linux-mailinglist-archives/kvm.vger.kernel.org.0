Return-Path: <kvm+bounces-14803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 940488A71EF
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:08:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EDBE7B22954
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED6413329F;
	Tue, 16 Apr 2024 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n9T5VvIF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845FF131BC0;
	Tue, 16 Apr 2024 17:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287296; cv=fail; b=JtfaLptSWaejox+dLiLquii2VQgMR8ZtlvWkm5IfeU3hyzBE4L6oQwdkVy6IvlXq7zNQtTEu/Fm5BfCMtfJRcLM3NRyWKgoGrFDicEnRNFm4ni5POnRaHxSP3+Rst59P8sTf6GIU7PTy/4yDKRwq/hHboVkbATlP51ZsdZqZx2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287296; c=relaxed/simple;
	bh=iF6+YdhJG2DOUMRO7Ddopiaa9i6TT40O9useeC9VsJ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iUlrHx6IxXCOOZU5UNoUqf7lTC3Enn4diQKHtpeNd2jXI18VKdGid+G3nW6AeTz/buud3gd3h4BDpPoV9TRGUFJYlZZqT41no4vjaMy6K69AJlgFhUUL5eGmcUGh1Nw958JpOfesiaDWAbMPBUfo/8RQVCG7mgoBK4SBVBRD2k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n9T5VvIF; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713287295; x=1744823295;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iF6+YdhJG2DOUMRO7Ddopiaa9i6TT40O9useeC9VsJ4=;
  b=n9T5VvIFvisGcU4dZDH2vyDrkab2bpQEJMuVyKnBzL6mufvU784tdKyu
   Fv9EtiI6iVc7dY/Wqfc1iFNvz5eA20169Aqhkfzq4/Y9hTE4SW8zGjqC2
   bjbehrswROIeW72f/oKpvGQnBp1/+P/fV0WMW3Nseo2Et0bLDfB8xQ+PJ
   Sey33dMHcFeTu7QiDhE13Pa4RckNMmIqWwMlmgsWCI0+bl2ak++hhQDS3
   lE4Rc/edctsCwkW58VA7q1KTi6d5iRQQ/R8ORdYQ+V81QdqfvXVbUjLJT
   faZkBpLeshRtkaid9R+H/XqFR37UmVGCWglaxfxbvTMC8fCLA5jFpSkSq
   w==;
X-CSE-ConnectionGUID: I7mAuzzYQfiFM5vFmIyUmA==
X-CSE-MsgGUID: gMG5uIa1Qbm2N9X+w9OJIg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8857163"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="8857163"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 10:08:14 -0700
X-CSE-ConnectionGUID: zRvH3chZRLuzSKUIAFI+1g==
X-CSE-MsgGUID: UiASHpWjQeKe7hQbzYA3oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="27119763"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 10:08:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:12 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 10:08:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aQmdCnPKDu1i91RlR3MWUB2Ad72ksWp8UiZGH2TgwYuusxxjV6Za7bC9UQhilXqwmOY+NzJDab1WeZ5GPBP3Ftj55+3w8YOgGDYodWi6WL9N/62UywDhgcyE+/KmNnJvjgRlGQAAcgxRBRrusbxAZMy7eBxN8m2yTsHUgkWtH2ko5NZO5efcvg7cZTgrHjCUBw43U8lf4JGN5OYjLjs5k50Y6CIpv+ZSjzoAIXKa1wp0gBRaazFkNUknTkVCbrywC9XjXW6dxbx7QVvTqaVXpvH5Cd9XdcGbgJeqY5Plpjsu8eyH5RnqN7ac8XxRpY1ucqzLaJZv/BDo4fgkvESbhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iF6+YdhJG2DOUMRO7Ddopiaa9i6TT40O9useeC9VsJ4=;
 b=I6IzeD5ck2LpWEOmPU0DqxAk2mDu6eNKv5seR2QJ8eXGc9snrNhfJ5d6biilaDaqh9zuSc+wLy+teLzP78jOBVcLoYMxJYPLFg9PhPLkqvLw+UzM2IaHOZMPMLVO6VQxGqIcs0DyS2Jaiujbj4CCPda6yyHkGg+bPDgaktTjhRp8kd5SSHKAUYV74Dn4kK2h7JnQBMZTjVm6QXIVu1OCUr41BcLW/q/gGFgZ9JQIY0087NFKxNgznMP9XE6hcAxNhewOPt8NZtH/1p+6mzLZoMzfjX0MIVizwd8XduW9i9zlbhWetDMBAKX7iVMVSlZXhiBBBOFpsPVamupyUjmTqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6099.namprd11.prod.outlook.com (2603:10b6:208:3d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.29; Tue, 16 Apr
 2024 17:08:04 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 17:08:04 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jmattson@google.com" <jmattson@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 2/4] KVM: x86: Make nsec per APIC bus cycle a VM
 variable
Thread-Topic: [PATCH V4 2/4] KVM: x86: Make nsec per APIC bus cycle a VM
 variable
Thread-Index: AQHae64w7bfRxQga90uC3jcCecjxNbFrSeyA
Date: Tue, 16 Apr 2024 17:08:04 +0000
Message-ID: <731f9293ec99a7263f202abe6f8afabce71f6d40.camel@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
	 <ad986cc2eca0d37bee464e560263c0f7cd437bf7.1711035400.git.reinette.chatre@intel.com>
In-Reply-To: <ad986cc2eca0d37bee464e560263c0f7cd437bf7.1711035400.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6099:EE_
x-ms-office365-filtering-correlation-id: c3398962-287c-42e8-5d6c-08dc5e37c78e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nHBxvTr7V6sbcaiSyptpWe1Z+uyHh+6IWXsQzLS3GnfebewenNNej+BcTgFm/M+B0PspP4zKyICm33xSAbGDm4OmlXkRmBqRoqlDw0lU0fmRYFEtMrhiAPYT+kwMRebXknktO9KXiDuygP5mFLlOtbEntPvoC2qL5FLn89txhlISDaiLn78Vi6PCjK33ifc+TvTLKieXVdk/rLMWxaH/RPkgAkZ5JTpXQV0Xxrnbv31jXrHbtzC7PVTI3dVS0c7cfmDCjl7mQffJI5dTGpZI7MZk+pK/VYWK2i2JBpp3WFqgKsESy3BGTOOdhCC6B/QWtlQD64spqdlzDo/q0k5Oce8vm5Zdow94Nl2S7lOvezolCuWvBhnSRcciyLE3x3w5NGJM1GSEXwxAEhpkugTgmat3xr0OhbCyTa8Md7WTahVeWNfe+EkPYgtc2EgUYZ2wnSPSjI2tFvnk9BOLlxLxCI0c0VG49HRhwxDO/Uf0TG4gPm6YPqT7/Qc9wAGxUxyX0+R++Jqm59JUhiDz2SkKr5r5XrXwehbUqxAg7wx8KEkqoIWA4/dI15FOt5mdo4cvpPDNvWF1XNkhQ0WyxBMFdWmLOCGz2uimbZE/5GVd4chLjbdOE5pkS7Z5i0UY1zGOfxNIzaDb7g1AH/8iyhRw7d5x8Oce4KL5Yp8Cl0KV+h2LvK34I7TPSIN4/Z0eJzeo7Hs+TRp7QMjYOI0cBwyRzXhGhHGzziv33IH1i6vybSw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0Yzb0hzL2hNVzEzZ1dSVlNWa3F0SldNdzJsRThmQXVDRkgyMjdOTWtXcysz?=
 =?utf-8?B?TnQwTmNSUy9YdFVJRGIvRThTVkxleXRKRGxCMW5yVStnekQxQ3B2aGJMSW0y?=
 =?utf-8?B?K09kM1pGWUQzSDNnZVF2QVpNUFNBT2g4aktBWUJQZ2EwcXhEUjdJUTFEUGkr?=
 =?utf-8?B?V3NvNCs1L3VaNDhoN0JzanVLZjZ6SnJ4aEdTdmh1T3MrbERia3NjM0VzLzQ2?=
 =?utf-8?B?Z2U1YWZodm9mRkNNcXk3Tndkd2J1RGdVMnp2MGlBT2xZcndIZUFUdzBBMUo4?=
 =?utf-8?B?YUU2d05OMnBxNzUwNytTalBqWkRydFFlTXBvd1BNdEE5UmxOK1YyUVRjUTB2?=
 =?utf-8?B?YkdXM3pqK1huSEdSR0FBNm5RWnFvZWJuSnU2Y2prY25KT3RVWk9oaGsxa0ZW?=
 =?utf-8?B?VW5kYWdrZEYxZkcwL1pMMkRlN0U5MEVqUS8vT0U3a2pRTk01TlpBSXdseTFV?=
 =?utf-8?B?M0NTME5nN3JEa3FKUFFiOWlwSGlrbk9TRXNzT29uc2xodENvZWRzeW40aEhm?=
 =?utf-8?B?Uit0Uy93cUIwTmp2OHR2R2JzejRRaldSdnljbHRqRTRqRm5Dak9pMFk2SmMr?=
 =?utf-8?B?WkhVL2dVS1FxaDY5dmZGNFJQQ0lXZTBMeTF1K0pRZWduOUpxNnY4VnltNFp5?=
 =?utf-8?B?TTltVUdLTjQ1bnc2VHdMUWZzdG92QkF5Tk91VURsUE8xWWkwN1pCR2lUTi8x?=
 =?utf-8?B?SW1lTGNLbC9Xbmt4dWZvd1N5b3phdGpoMi81Q0VuRmlydlZsZXhzWktUZUU0?=
 =?utf-8?B?ZjJRWFhiOFVEd2tDMGFubE56c0FkVmNSZlhSNm41aUtNNnJER3dRNjJyWmo1?=
 =?utf-8?B?QUdwY2lxVU1jMEloK3ZRa3BwOFZzK3cvVTRjYnh1NW5BTzRWY0VMN2hFTlI0?=
 =?utf-8?B?d2pSS3ZwN2dWTGZ1RjAydlN0VGxoVUdrOW53M3BJdHpKNUI4WVE1c1ZOOWQr?=
 =?utf-8?B?UTBYODNQUGxPQnAvK1RkT0lKODRlSUI3cGc1SXorRDNNdk1Kdm11YmlZcVRz?=
 =?utf-8?B?VVRDY3JNU1MxdUVaWDVlRVhnWTRJejhYZDhGdmMraVZwVys1NHRjaTg3enBx?=
 =?utf-8?B?S082d0EyR3lQNG5mdVBodDRxb0p4RUZ1NkdlcmorNXJNY3dRMXhkU0pET1h5?=
 =?utf-8?B?SkNkUjFFaGhCbzZ3U0o1MzZSRVhQdTVaN25kRVAxS3BXY2VWOU1SU3VmSDZP?=
 =?utf-8?B?RjVmelB4bXQ1Z2JYdlF6c1YwZ1ErVzMrYklibmxMMDVNZHFKVHNFeGlFQkEx?=
 =?utf-8?B?UXlNUlg5VFFMVHJWaFlacWdJcXNsbUFqa0pDMzhad2JTdlI0b0RIc2RpaVNJ?=
 =?utf-8?B?eVFTcTdVcmYvbXF2NXIzbXFqVGR4OG5wcHRycjN0a2lPdS9DZW4xcWJDeitQ?=
 =?utf-8?B?aEdORDhwZWxlNUlMZTM3ZXo5R2ZUZ3ViQVlVMWZJcDlSbnEvajdBQnZOMVpY?=
 =?utf-8?B?MFJlL0VWaGtyZVNSTDRPdXJSNEhqd2lxbER5cGsvN3JSSmVDTkllWTJSckNi?=
 =?utf-8?B?a0ZuL3FBRjVlVDRGc0dSWTRXN2RKUFYyQXJQdU1OOExCUHRSTWRIYW1DWnYz?=
 =?utf-8?B?N2lESjZlZHdjVmNsZ09wMVp3YUt1NjFUNC90aGRpdktKOFAwSXArU1JqUTdM?=
 =?utf-8?B?OVFzaDhOMzc3T0ZtRlRJZnhvV292UkZ0Y3RZOVVITlIyMGw5UGV6RnhZTGtU?=
 =?utf-8?B?b2VSL3lzNTZpenhoNXJGRlBFNHB2UlptMXJzaGZwWVhhL0hKcU42Y25kTHJx?=
 =?utf-8?B?bWpCQzdzVFNNbWd1S3k4VmkzMGRlOGorS2d0ZzNURmNJT3pDUVBhWkhCY2Nv?=
 =?utf-8?B?QXc1Um5EcVdOcmdIVENGNlhEZFp6Vnl2M0RjUFd3bHZNdXdSSEhvZmI0TUE3?=
 =?utf-8?B?K0UwZ2VYY3Q0MDFnak1ESkNTT2J6V2dkblVOc2ZBRWgxdVl1blJmQnhrdFN4?=
 =?utf-8?B?RlpiNmViODFaTnM3Z2lUdWVWMGc1YlU2TmdNNEtyNGxQZVkzYzBXU2VFSElV?=
 =?utf-8?B?RjhkSlhpSHRKeGtIN3Bjb0g2Qk1IMjFzSndrM0pBYU9zU2ZYdllLaGgwWmVx?=
 =?utf-8?B?OW40QXI4dmk5TlI0dGRnT0dtWTluVHRqa1ZndnJiWG9Dc3ZtWkpKK3E4UXZx?=
 =?utf-8?B?ZjFJUWtKMm5wUm5NZE8xMERIZnAxcHBjamNwK2RYTFUzeitJa0oxaWpHSDFa?=
 =?utf-8?Q?2PO0ud5LtRptVmQwz6WkMp0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <177BADC5AC08E34C89A10DF88562278C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3398962-287c-42e8-5d6c-08dc5e37c78e
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 17:08:04.3661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tp0zLdHw0lqsQ5b+y0QsfGatBwj49RjK3pTYbhbRE6PMOtPLMBCFrpSKwjIaiuYZKZwypwL+lUOV77FcrDJcg4Ci3mJqvZElp4XohusPu1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6099
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTIxIGF0IDA5OjM3IC0wNzAwLCBSZWluZXR0ZSBDaGF0cmUgd3JvdGU6
DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IA0K
PiBJbnRyb2R1Y2UgdGhlIFZNIHZhcmlhYmxlICJuYW5vc2Vjb25kcyBwZXIgQVBJQyBidXMgY3lj
bGUiIGluDQo+IHByZXBhcmF0aW9uIHRvIG1ha2UgdGhlIEFQSUMgYnVzIGZyZXF1ZW5jeSBjb25m
aWd1cmFibGUuDQo+IA0KPiBUaGUgVERYIGFyY2hpdGVjdHVyZSBoYXJkLWNvZGVzIHRoZSBjb3Jl
IGNyeXN0YWwgY2xvY2sgZnJlcXVlbmN5IHRvDQo+IDI1TUh6IGFuZCBtYW5kYXRlcyBleHBvc2lu
ZyBpdCB2aWEgQ1BVSUQgbGVhZiAweDE1LiBUaGUgVERYIGFyY2hpdGVjdHVyZQ0KPiBkb2VzIG5v
dCBhbGxvdyB0aGUgVk1NIHRvIG92ZXJyaWRlIHRoZSB2YWx1ZS4NCj4gDQo+IEluIGFkZGl0aW9u
LCBwZXIgSW50ZWwgU0RNOg0KPiDCoMKgwqAgIlRoZSBBUElDIHRpbWVyIGZyZXF1ZW5jeSB3aWxs
IGJlIHRoZSBwcm9jZXNzb3LigJlzIGJ1cyBjbG9jayBvciBjb3JlDQo+IMKgwqDCoMKgIGNyeXN0
YWwgY2xvY2sgZnJlcXVlbmN5ICh3aGVuIFRTQy9jb3JlIGNyeXN0YWwgY2xvY2sgcmF0aW8gaXMN
Cj4gwqDCoMKgwqAgZW51bWVyYXRlZCBpbiBDUFVJRCBsZWFmIDB4MTUpIGRpdmlkZWQgYnkgdGhl
IHZhbHVlIHNwZWNpZmllZCBpbg0KPiDCoMKgwqDCoCB0aGUgZGl2aWRlIGNvbmZpZ3VyYXRpb24g
cmVnaXN0ZXIuIg0KPiANCj4gVGhlIHJlc3VsdGluZyAyNU1IeiBBUElDIGJ1cyBmcmVxdWVuY3kg
Y29uZmxpY3RzIHdpdGggdGhlIEtWTSBoYXJkY29kZWQNCj4gQVBJQyBidXMgZnJlcXVlbmN5IG9m
IDFHSHouDQo+IA0KPiBJbnRyb2R1Y2UgdGhlIFZNIHZhcmlhYmxlICJuYW5vc2Vjb25kcyBwZXIg
QVBJQyBidXMgY3ljbGUiIHRvIHByZXBhcmUNCj4gZm9yIGFsbG93aW5nIHVzZXJzcGFjZSB0byB0
ZWxsIEtWTSB0byB1c2UgdGhlIGZyZXF1ZW5jeSB0aGF0IFREWCBtYW5kYXRlcw0KPiBpbnN0ZWFk
IG9mIHRoZSBkZWZhdWx0IDFHaHouIERvaW5nIHNvIGVuc3VyZXMgdGhhdCB0aGUgZ3Vlc3QgZG9l
c24ndCBoYXZlDQo+IGEgY29uZmxpY3RpbmcgdmlldyBvZiB0aGUgQVBJQyBidXMgZnJlcXVlbmN5
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGlu
dGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IE1heGltIExldml0c2t5IDxtbGV2aXRza0ByZWRoYXQu
Y29tPg0KPiBbcmVpbmV0dGU6IHJld29yayBjaGFuZ2Vsb2ddDQo+IFNpZ25lZC1vZmYtYnk6IFJl
aW5ldHRlIENoYXRyZSA8cmVpbmV0dGUuY2hhdHJlQGludGVsLmNvbT4NCg0KUmV2aWV3ZWQtYnk6
IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg==

