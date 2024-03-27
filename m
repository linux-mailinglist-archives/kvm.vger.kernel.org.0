Return-Path: <kvm+bounces-12894-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB2588ECA3
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 18:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2AC829501A
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 17:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF8BB14E2F0;
	Wed, 27 Mar 2024 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxJjXpvN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5BCF4E2;
	Wed, 27 Mar 2024 17:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711560491; cv=fail; b=ZgEm2D+5jMEpbB3omN5WgSEg10agkAio2HRU3jZ5900z8kD7llyKa3jSbe7ZCU76R+vfRPrPXl0xO8AH5Rcnn0fEUbHTTFMZvrg7e23+E6NrHMmX17MXGtS7h5sEblemDxp0yb05N7YAgOUmBOnuPcAfQIchSPi8F3M8AxAMPyU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711560491; c=relaxed/simple;
	bh=jO9/6swE+GirOrqFLwglS+L598HKJevGTQGTsMKeLd0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BaPsLe8kHZXC7LHcSe9RrswFLfoVf1Sq1Ihz44eBWpKNQy64KUbzxeVDFZsqE3ECugllZfxAKTsNXRgI7p038zgyK/0QgjdonIHpN4zY5K+XtZEYhwcTGl4LYPxshSTcKsoXJd7hV5x84qef6ol/sSEnbSZ18hPH7A/fYi2L+Qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxJjXpvN; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711560489; x=1743096489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jO9/6swE+GirOrqFLwglS+L598HKJevGTQGTsMKeLd0=;
  b=NxJjXpvNuQRCRSdWdpLmRAX0mhQuYs/zr555I28NRqfdLlisz+7jnVZU
   i8Odeti0Fet14OqtYuiMSKO2qKbcBFQVvw/+DQi43swKsAOavEhifD/9g
   Ln9AyC8lCtSoSZlhlQVFtDkWs44a15UkxrwcFhaoy9Ud33OrvqG5fkNiY
   PirBPkg8DwzarIYQxlaw8NNq1GX38E8PrtuuieNOD3MhnAsqwxV28j5T1
   lYviXnAZxcUrVrkAtEVZiQ8GtnKs7f6B9r5zNinAcmp0qc/O4huXhwD8/
   FgjiOqkxa72yUE85cEBCU83kEDXjeUY1DwrNMmxD47wClhlN36yLFP3QU
   g==;
X-CSE-ConnectionGUID: 5Gba+MBOSSGRbiwWI3KECA==
X-CSE-MsgGUID: 1Gq73kbwTXWETmWCwAZTqw==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6869419"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6869419"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 10:28:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="39500382"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 10:28:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 10:28:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 10:28:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 10:28:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 10:28:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aRUo7HysGeviYCQyecSltKq7rdse8q6qyrb/wI6buIPY1TQ/jWhcZoJ6htO1PRDguA3piwg8OKdRnFMjVKYuQQk0pDeBEyv/2Zf9BnoZCCNvNaeW/gMSkLqX25wwmp3XgUZJjoLw8rp60AumR0xUJnfaroueCEH+UhJRqqWoJMpgPPIi22EA3cALsWwZ8hcYx4rujYh06Js00XL4QrgpkXUpsVKzpSYCHPHXmLkfCo4P2bT1CXHzrOvZRP+R40Q511zZJQ28GNz6/prshZZ9BUE5uzm59ZTogzWf5rVPknXQ2Mzui3rGJcQ03WGxsmY6A54h4Kg29U3+wNo7chMQmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jO9/6swE+GirOrqFLwglS+L598HKJevGTQGTsMKeLd0=;
 b=aoUtqJRTgiL4VIMos9BsGb1CbYavKAw0RcPA7DI/ps5RENk3/RXapIPsBfgk3BQ0UJXO+ir/S/u6ixCJPX58tLRWt14W6eyboG3Wo4BOtN/gduKuNZxPjqMOFG/CuSCSZM3BvO4Z4yhyVPwEgkiIlHDP3XjuMPa95btA/EbumVv6QJVaggsTBx1C9dU2Zhvs81ntpTa6ocrL1thnJjDzPTJ286N60n1k1RS1NNYu791mRMrdU3N52QwD+lIULbzgTIQKXOn25vzx+Wa+D4Vg6kxVoZl+eIGs56MNBI3WuhO+FDbTx1xU/bQiinPugA5pdaDrUyaiyPbDEvgbLCZEIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB8284.namprd11.prod.outlook.com (2603:10b6:806:268::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.36; Wed, 27 Mar
 2024 17:27:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 17:27:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yuan, Hang"
	<hang.yuan@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 018/130] KVM: x86/mmu: Assume guest MMIOs are shared
Thread-Topic: [PATCH v19 018/130] KVM: x86/mmu: Assume guest MMIOs are shared
Thread-Index: AQHadnqai1juAAI0fkueX9MsZ8q4G7FJLxSAgAK6pICAAAGCgA==
Date: Wed, 27 Mar 2024 17:27:52 +0000
Message-ID: <f7d0a8475c9d2e18a12f9da286163c75b11282a8.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <b2e5c92fd66a0113b472dd602220346d3d435732.1708933498.git.isaku.yamahata@intel.com>
	 <3c51ec38e523db291ecc914805e0a51208e9ca9f.camel@intel.com>
	 <20240327172227.GE2444378@ls.amr.corp.intel.com>
In-Reply-To: <20240327172227.GE2444378@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB8284:EE_
x-ms-office365-filtering-correlation-id: eadeb3a4-303e-4d02-fad8-08dc4e833b6f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: STnrEERL8R4+ohbRf2pjurRgprCO+Wc6iQWk/StXpfnEl9XSYOx3FpXoXEiNifb4PPjRYPHF6CXu1CrkNA67EGMrWucyGuyVwsOoWVUqa0cEEpaTihmZ80Erki16F82mJEpcB6NtGJWlaiRdLc22WXl2OpxQTUphBxLp27PBjh5J7bx8zl4DtS7YSrArt2W3XlFf8/Y9Ol9GPsnkfylYKDoXna4nbS/rkcQ+MxPHFtSS2oNNF1hRi/pZisu3gCIG1DjIxZoOnX8qWxSON6qHAyw65JfcTcgE5aG6/ET/jxWxOdEpa7kYXLRmvQDZpeo7/xUTYTFFZFiJCvbXVoftIsQd1b+JRFZ9cuxYA6brnzEht4vd48Cs0qVId/MhzVtxGDD0eyHFhVhyn9Cwm0xGQiGcmJ09CxM+c6ipKIUt0SSdkZe3gSc1vsHOfxag5+hbuzQI4JOd653LDGF46DtT+0s6b+AXAK/rBsjHR2F4sEN5gvM2PBi5KDQ3jPVFXwsPcNHlgz68jiCqgnXJosGklvkCVRHfKef7ezBYjI+RkMvKevelIGGDpEgK5Fqj1fDlkE0DROu4fGNdNuibAdnKItOFiBecShErGAuZYRVC3pLadq7LzCeyIeFSkyID6F8Rw1bzPgI+LQ3CCLWuqDZ7tkj1iCxCzghnZkv27u8oTS0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enh6UG83NWlBWmdlMGJSY1FhRnhySzl4R3hsa25oY21qdVVISnFiNG40eDE2?=
 =?utf-8?B?VEVKaEhJSnI4dDVvR1lhNGwwd3NKL1NRUVlyK0prU1M1NkttOXc0STQwMWs5?=
 =?utf-8?B?clF3UlFVZS9Ody8vOWI1NU1Vb3Z2Z0xXS1FINFh3ODNEN0t3cFp4ZGpEVUJP?=
 =?utf-8?B?ZERxdDFxWng0UUFpOGFZVVhCSU5GWmZrS0hob0pwNUVvaERhWXI0bDNtcGxW?=
 =?utf-8?B?RjdsME1XV1FzN3BKWTBuUHR2TDFWRmo0aElDWEVtOFExK3MzQkZBdGdqRjFY?=
 =?utf-8?B?Mm1IVm11SjRVMzFRbHROVXk3L283Q3NMY3psR1kvd2ZldVQxZEd1K3FVeEFX?=
 =?utf-8?B?cExXUTFMY3hxdzFEdnN2VGlGYmlwTTVtY2hMdm1DbVdEUzFueHpYVXZFZmh3?=
 =?utf-8?B?UHptWndMNlA5Mk1QQlpuTmQ2c0dFNWhkc0ZZcHhRR1NjVUpkQ2Q2V0FJbWV3?=
 =?utf-8?B?UmNlZFZpVEJSZFFVWlFTZElsbmR3eGg5Y1NmbzRPc1d5aHJCK2tsQmtEYkJG?=
 =?utf-8?B?NzJjUjhaODQrUVh0ZW16Y0U2TGxLZlI2M2VCb3hSQlJnOHZIcjJOV3J2TG00?=
 =?utf-8?B?djgrUDdvcFZ1dWZWaU9KRDFOR0xHemVGNEd2RSt2eWhlSGRzcmY2TkNDQ3kw?=
 =?utf-8?B?R3pyQ0xOSzRvWHhQa3l1WHQ5UElZcUtUS3NHazhEV0hBOHJFdVVOOWF4ZkxQ?=
 =?utf-8?B?R3AyaFNHRkQ0eExMWFp0UVNmWDZWSXVWM3NPZW5uT093Zkpwc0gzSjRia3B2?=
 =?utf-8?B?N2VKTHUxRjQxZEljSWpybkRLRGJOMGxVbDJ6SjM5OWsrQjF1RFExYXZzWjZC?=
 =?utf-8?B?NkdOMkFJRmJJUjc0TkluSkp2MGdtMHJoZW5NNXJoM3VWOHIzTkF6V0s4VGVx?=
 =?utf-8?B?Tm5IUE5OTGFncHpHbHhNMTFKTmVnZnF3TEFuME9QVkJwaitMU2EvbVhLRUk3?=
 =?utf-8?B?SXVTNjUwODgzMEdOL3ZYWEl2Yi9WMkF6SkZQeXdZT2dTY253a01yKzZ2Q0kv?=
 =?utf-8?B?M1J6elU5bDVsWEdEQlRVOUtUWVN6YkNlNU9UU1Z2R1hkU2grZkwvMzVldDA4?=
 =?utf-8?B?TEJQd3dSS3FWdGlkMkVmQ0tvU1JGd3owM0lkRis1RXdTcWRSQjFnNjAwZVdG?=
 =?utf-8?B?QTdCK1ZJQkRDVWhhQWtUaXVvdk5jN3VBUklLN25kRG1TR3lTRWoya2J6VGtp?=
 =?utf-8?B?eUxraXIyOS9oVEJPdThqMGR2cDlkY25oekJhTmF5WFlHdFhDVVJlOEZUU1Zn?=
 =?utf-8?B?N2I3YVBOdGRmc3J6SmxXWi9RakdGMmV3ZDkzWlJrdGdUd3ZIY0tqSFVhNEhI?=
 =?utf-8?B?cmU0QnpTdHlOb3lZOUM2S0l2Kzl2QUc3dE9VanE0MWs4bnQreEV0alVBZnRY?=
 =?utf-8?B?ZVNSN2ZiSEFBci9ZRkFxeE1SVXdhcWdXZ3AvTzlsQjZiYmxIV0ErQnV0Tk0z?=
 =?utf-8?B?VkxYcVZoK2lxLzJGbHZEWkp3WU5PVXRLU2pDMVkxczFsa1NEeWkxQXFhb2xl?=
 =?utf-8?B?MFVGcXp4QUVrRDlLZDZYd0pBT3ZUTjZYMlRZSHdIbFFaR0luMGhpM2I4c2k4?=
 =?utf-8?B?Z0VmYkJseVNpMjBCSUViYnowTndkWFNYc1UwRytRUi9LNTVRUkdZT1JMWHdO?=
 =?utf-8?B?ZVg0bEkyb3lnVCtEVFlMaHUvbjUrQUExRVdsTVNybXErc0h6ZFVteDNmalJp?=
 =?utf-8?B?QzhybGlGZ1l4d3RJY1J6NDZNK1FKb09DbnNjeGlyK0VXYUEvVGZLdUdrczBP?=
 =?utf-8?B?ZEVtZ2tZQTUxcXFwUGZGYXBPQVdNSkZxSWxmYmFTZ3BlUkNtVWFndjFOaVVi?=
 =?utf-8?B?RUNwQW5GZnFKVlp1SmduOHJUdFV2U3BCQ2xlY3ZyWVhjM0p1b0Q3cFBFZmls?=
 =?utf-8?B?M2kwMlFIVkdRVDlubXJMdS93d0ZscWtKREV6bSt3YVJCbGVxVlE0Ykx6ZVlU?=
 =?utf-8?B?a1NOeUlXS3NzeDNaUEtnTEdJSVlNLzRhd0ZPMWxNUExISzM5MVdkYitQR011?=
 =?utf-8?B?Z1hFZUt0US9BTmYwdmNPTklseEErUy9mZU1WcW10QThmMG02dEZCQ1hBRVQ1?=
 =?utf-8?B?ckJUcDRFdkQyL1JEZWgxZUFGSHVvaUxFTWFhVWRKSHlyQUp4TDgwS3hsMmNR?=
 =?utf-8?B?ZDB4T1RDQyt5Q29DeWRMZUJtWTNIV2VBaDJzdjBtZTFCa0tuVWJJYzhsVXVH?=
 =?utf-8?Q?Z7NO3Uj6hwguXEIMFPm1UyM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <06716D47A1BA0646B58566A073B28D44@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eadeb3a4-303e-4d02-fad8-08dc4e833b6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 17:27:52.4436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IWVfVGSiDkFfHC0xfb6Up+hngxavZjrT+cus0j+it8NrBs4dxGmS5kmOnyPaywZ9NL6h/noUweRN4RvzLqy2a85NHbIJK/J/oedaXV5pp+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8284
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAzLTI3IGF0IDEwOjIyIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gTW9uLCBNYXIgMjUsIDIwMjQgYXQgMTE6NDE6NTZQTSArMDAwMCwNCj4gIkVkZ2Vjb21i
ZSwgUmljayBQIiA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiBP
biBNb24sIDIwMjQtMDItMjYgYXQgMDA6MjUgLTA4MDAsIGlzYWt1LnlhbWFoYXRhQGludGVsLmNv
bcKgd3JvdGU6DQo+ID4gPiBGcm9tOiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiA+
ID4gDQo+ID4gPiBUT0RPOiBEcm9wIHRoaXMgcGF0Y2ggb25jZSB0aGUgY29tbW9uIHBhdGNoIGlz
IG1lcmdlZC4NCj4gPiANCj4gPiBXaGF0IGlzIHRoaXMgVE9ETyB0YWxraW5nIGFib3V0Pw0KPiAN
Cj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1pjVU81c0ZFQUlINjhKSUFAZ29vZ2xlLmNv
bS8NCj4gDQo+IFRoaXMgcGF0Y2ggd2FzIHNob3QgZG93biBhbmQgbmVlZCB0byBmaXggaXQgaW4g
Z3Vlc3Qgc2lkZS4gVERWRi4NCg0KSXQgbmVlZHMgYSBmaXJtd2FyZSBmaXg/IElzIHRoZXJlIGFu
eSBmaXJtd2FyZSB0aGF0IHdvcmtzIChib290IGFueSBURCkgd2l0aCB0aGlzIHBhdGNoIG1pc3Np
bmc/DQo=

