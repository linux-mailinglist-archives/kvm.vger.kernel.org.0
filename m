Return-Path: <kvm+bounces-12284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 962E68810E7
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 12:27:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B66ED1C20CD2
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 11:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FF43D964;
	Wed, 20 Mar 2024 11:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CUbfdbwr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2773BB30;
	Wed, 20 Mar 2024 11:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710934046; cv=fail; b=R3stsrBaUYXKE02q32ISvMjwW58i9LlW44Eb+6fY0eHAiPHS+gyRi2mzjwT7FNj4Y9yalAvlTJjieR9LtJNZgtRICXETbxtd8MzuZIxxtJN9+wo5wDDkaCgzN1PpTXhUa438Fhzzs6EABEefq+svKmqA41Pv9xlgOapwVzywiiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710934046; c=relaxed/simple;
	bh=YS4Pzmg2jbN40LAwOqyvNcoql6tqIeumgmIOT2ZpGiM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oFYeB631y1wVgqltm66XQf8zcKCbhb6HjJriKFhXZzPzA5JXOJObQgXOhPqNpGJiXnJYXwn+nYQ3krdQ7DPsz+hg7VIytc27r4vDIhX2gey62lKMqMpxbyK9Fk1NNMpun/xvkjE2Ks4ZYlLbUUW0vn3CTmLIrcSP5CVe+Quu9J4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CUbfdbwr; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710934044; x=1742470044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YS4Pzmg2jbN40LAwOqyvNcoql6tqIeumgmIOT2ZpGiM=;
  b=CUbfdbwr5tl7JzP5lbtzFsyazWcC+C5neTw7uJgBsdy0PX+rdodTbtiX
   0hkI2ORJW9CAvIuwqXdIllLWJeS4Xo8sdbRdYUsG+jQ5jQs5aSh42r9Pa
   9D0qWOPyYVTPOeaWn0F/YtVRL4l3Fp5igpr4Nj6Ckv5X2eVA1U3h/mZp/
   NhkSbF1s5s+Ed7Doy9/0PrQ5PpOipm9SDH7dWVUZPjfxFjFGRm1y9iIWJ
   YjUXHagvf5rCd/PAt32fJEmxyzs2WDTOYcle3TnYqYgg+suFMOWoYgGs/
   +TEpZSAP+8R2d6wjKNPXMnv4HyZmmihbgQe8AXXrEQfEsrVhy5pD4D5+g
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="5974138"
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="5974138"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 04:27:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,140,1708416000"; 
   d="scan'208";a="18709621"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 04:27:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 04:27:22 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 04:27:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 04:27:21 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 04:27:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FS1bRxG/ZmNY8aydxh7NNESWh9XmG2OGxlopPHhBegNKJ/L1Tu1K/A6St+3BhKEE8uIIoXxIlrwZoEqAAvdnhix2rt1nZcUyWutNXYe5aMdt5pLXZVnnLC/f5GxIzuqfufTloRKQLH2fEij8+9doKDNLBNFB0flEG5pkBNV426yj3Sap9fYYEKsdDUN4Tgiw89c505f5uB3JIXGlifZxwfcHDVFTK4Z7X375p0fowYeDu+qrci8SKi+/OBiGTXYXSDfCIUkbcTUS70WPXQiVG8iR/Wt1lHWqEPDwc+Vpzqzx63sT0/RZs+sCHY7Jsi+/18krqK1+RNtsGOcHy4lbKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YS4Pzmg2jbN40LAwOqyvNcoql6tqIeumgmIOT2ZpGiM=;
 b=NCUQMFCynkrhj/1ydK+cL8BuwDfqoRVv2ojp00DULqw8P+MJ/QbI0woF9OWpxdsOspMZEGTH+pxPEAD1DOGUquCcm7RB70cJpPyHgXI9rxpQgIsBz9jrnyC8Vo6692QFZhqWTyGSCo4oLM/+oan+CFOceONeJeqEXZNUs3UA5Q88wRG3YHDqShBx31PdJyKxi4j6kDyz5yM329y5qZ1mzLQ028DXCXVoQacVJI5V2LOfdQbFrmUeLnLQhdR22ctmYj9IH2Qy/PlP8DuDnzIj4wT26zaEvFKMDUop1cwOnWiBVLAo7fM1kabRQCkJBumhEcQHopprpxdyv1W4iGEc4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB4797.namprd11.prod.outlook.com (2603:10b6:a03:2d4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Wed, 20 Mar
 2024 11:27:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Wed, 20 Mar 2024
 11:27:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHaaI2wTkj5owjSpkGpHZWdVA22/bE4BueAgAAU+4CAAASeAIAA+18AgAAVIYCAB3ECgA==
Date: Wed, 20 Mar 2024 11:27:17 +0000
Message-ID: <f4eb47d270cd617f2eb99b6eda6ddecb1a4c9438.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
	 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
	 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
	 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
	 <ZfR4UHsW_Y1xWFF-@google.com>
	 <6cb438ccf1ffea84d5e3ef48737552b06c474001.camel@intel.com>
In-Reply-To: <6cb438ccf1ffea84d5e3ef48737552b06c474001.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB4797:EE_
x-ms-office365-filtering-correlation-id: 54aeaeca-0536-41ba-37e3-08dc48d0b352
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: agin1VM8ZexYd/lK6gbU8kDXis2y1vS/Tzo59Z1FuVMjFBcdGF0HXK6o1XxghXdl23Fd6PIlLW1H8yJeZchJ1/x2YMQlCrhXUpSyZwwqDloyxtyyHQhHm16aRNNPkPCws1r5PTYrSRmYDSjieJg2is7Qhx1C5iUQ9SjgUYLuQOJ+Ei3Uv3g0AtpafzBerUolradxA9V1r8EYR7goI5P16gTiS+xv7H9/0WmkVkjuIRFPTWLStmtMdCt8lspbFEzYUHP5s/o902/+XIpg9Br1HXdKyxF2zqwm9z1YB5K5uF74T5CL34UvHKABQZsp9MfOpqg+eUu+4A0odZxhLEDgZXhVR6od9pYZib0PLysOlTOTMKK+fsYDJQn8Bm07L+0wjiezqaFDhuaouhb+ZB/AnwfQPpVzMswHsZw4jb7cFJvu+i3Z4bdE3C6bkwZT0K9jHnuZpPsF6KI0YwZXMQGkJwZTVvVuDeDCkMxsCIF2ZzZs5n8d3yMgdZSaNiDjjmx/mt1QBWR5plpowJG6/9/opy2cRCue2iRo91Tztc6xjyJtvfP3MI7neb5Amu4LEP53YAJuQi8eimQPmhOok7Cc/CqnNVF8duVAkJqw8Vu96cU2wGzQHKJodUfGImwp2Yz3oRpIZpUafHqjKpEpjmFPr/BJHc2YNWKTFIB3oO7JtcOy/6RjGAxlbsfth7FXpp7E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Zy9tQ3JuQnNNRjgyTUNiaUlDcGJ6Skcxd0lOQzN6cmMxcXVkZDlQOXovc1NH?=
 =?utf-8?B?MHFYeENZcEo5MUVyWXl6MG1DcSsyYUR3OHZUQ0VBZlBYdW5ySVNQSlJ3UGlM?=
 =?utf-8?B?dkRObkVld3pGQjRRR0RBODIwYlNFbHhMeVBWbHpmNllNMWFrcGtiOUNUWnVH?=
 =?utf-8?B?eWl4QWU5bGcxZmkzMzMvc3lzaVJsanFGZXl0MFZQcGpyamZLOUQ5ZW5JcXAz?=
 =?utf-8?B?MkhCWUdwU2RaTGxxTnNSdS9TU3ZSV3cvQUgzL0F0bnhlTTNoYWxZS3MzQzVF?=
 =?utf-8?B?THQ1M3BKNHJ2bGV0SElLdnA4SGZzUmNNa1ExNEtMaVA2clNya1l2dHoxNHFm?=
 =?utf-8?B?MWg3a1lSMU9vRGh5Zk1jZDhwY0xjbzJxM0VIYTJicmlyNHZISnhzczVjalAv?=
 =?utf-8?B?YXdZTTdnN2FET0NaOGd5KzhObXNxZ3ZnMG1MS0locnl4czFuSzl2NnU1RWJ1?=
 =?utf-8?B?d2tRcjB2RTc4YUJ4cDQwZTRUNjBMMDlVcDMxNWlwcXZ6eTJLakNZTFI1TGE3?=
 =?utf-8?B?bTZEMWdIeGpJTk4wM2J4QnM5alo4WEtrWGg4aHR4K3FmS1ZKOXlkNUY5bVFE?=
 =?utf-8?B?Q2cvTjFVQU9QVFZlM1g5VU42ZzRTWUszQWkzNXIzS0JUd0hvK2I3dGJwWFln?=
 =?utf-8?B?RGRCNDJnV3VoWHRTSG5QVUJ3eUIxZUV6ZTJFRjQwOE5LNWVaMlU3aThUU21C?=
 =?utf-8?B?TnU4KzZMTVEwcjl1YTAyYjJsS2dGS3pORFVJV0loaEQ3TjNzNWN4dnpUWEZq?=
 =?utf-8?B?TEpUa2FrSTZSdkQvMFo3dW9yMkdMV0Q5SU1hbUlOeTlKd0xIejh4OHlkOE5q?=
 =?utf-8?B?NHE2a3pGTEoxZFNvc1Btc3hZV2UyNGgxS3p6OVo3c0wzT0swYjVaWmMzWFR3?=
 =?utf-8?B?NTFqQllWdUNCdTFWRjF6TC9pVHlaL3ZjdXA3aFZxUHRFNlhZdThzWHFuUHln?=
 =?utf-8?B?Y21jSlAvVGtnUHZZTWEybHJibFAwNGFENFczU0Nld1ZzMTBiMEtIMDk1T2ds?=
 =?utf-8?B?d0U5UzlsTkpsS1RGM3JPNHhzaUxyQmZLUUpDOUt1cTFNalZvQytFY2dZdUFs?=
 =?utf-8?B?ZXlNZ1Q1eHRWVmxEekY2eEZqYzRmSC9iQjN6dHVQbTJSclR0TCtxMEMzQURs?=
 =?utf-8?B?Nmg2aXpmVHBtZFoxWm02UXBESFR5Sy8rcmtHUDdWMlFTaFZZZUhEZERjQWtB?=
 =?utf-8?B?ZVJnWUlEemU3M2hhZk4zaUtmcGZJOGl1V20rYzZZVzV5NDVENGRKSnRoVith?=
 =?utf-8?B?blduanppZkVQeTdKZlZJcjZXWkZCR3pWNGxoVnJFOGtaTUdhK1ZEejZKVFpu?=
 =?utf-8?B?d3F2dmR3czRoSSsxNUFtS1RSUG5Vd3pGOHdjRjdOT253OTBOaEROWlRhZFk2?=
 =?utf-8?B?WURSYm52Uy9iSi9qZU15U1lxOUJmV0Jrdk1NZjRBTVdUeWp3d2cva0xFdzhk?=
 =?utf-8?B?OHNNT2Z4alV6dExtYmdBU2IwNmh3aWxCY251M3lhQ21aU2dPaHRON3BDT0dv?=
 =?utf-8?B?NE1LZXYzWndrYzgyNVFFSE5RVmVqSk4ya1M0VEw4RnhKRWpQZlpVdkQ4U2Y0?=
 =?utf-8?B?SEg5cUFQbDRFTWo5WVJBdkR5TEovRW1ubTJ1UENmbWo1blI0c0d3ZUdhVGZK?=
 =?utf-8?B?R3IvOTRNeERkdmhrbkN6b1oyNlVGa0xpUVZKenA5b0NVUXVMUjJ6Q2tCWkpB?=
 =?utf-8?B?TVdtQmRKeFR1S2pac1l5QkZFeHcyZ1ZqVmRHNytoOTh4T3RvZDNpZnloN1F0?=
 =?utf-8?B?alp6bjlBYnBwYkVlTUtxVTZFazZ3UWFxWnN0Q05pRWM3RURJZFp0VXMva1Jt?=
 =?utf-8?B?aTV6RlNFai8ya2Z5MjF1TFZCZWJETmlUSlhia1d1KzNZWTFtdUY2ZHVvTGFu?=
 =?utf-8?B?U3JRZHUyUU8ycjNLa2pYNDNQZ05zVUJEdmNUcncrUmpKWTdpcUdmS3RoTmNS?=
 =?utf-8?B?NUZmVEtrR280UGpRSzU1dEozaUxvaFRDRTltUDR2Tzk1UmF3WjVtSndHeW1X?=
 =?utf-8?B?YUNucDBCYkdDYXlzTWEzRmVBb3pLMFlqYVRBME1FUGxPc0N6d0JKZmRyV3pk?=
 =?utf-8?B?Zzh3Rm1jWXY5clBTcGN4ZHNYTmRJc0Nuellja3FzVzNzMDIzVDhGcHlRUGpG?=
 =?utf-8?B?V1Z6QUY5VWpvVHRud3dYVVdPclAyWE9hTHNEZm5MSDg5anN2OGpibDRTRGNZ?=
 =?utf-8?B?eVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73717F2B01716043810588F7F808093D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54aeaeca-0536-41ba-37e3-08dc48d0b352
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2024 11:27:17.8103
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 78l6KiD7EsZUT9EPlnaDZWn2joec/tks5jo4KrffByXYlnxLgdBTN6eh99czCUHBDbHoqZbFAL3zLoiv6XyMMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4797
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTE1IGF0IDE3OjQ4ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gRnJpLCAyMDI0LTAzLTE1IGF0IDA5OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVy
c29uIHdyb3RlOg0KPiA+IEhlaCwgTGlrZSB0aGlzIG9uZT8NCj4gPiANCj4gPiDCoMKgwqDCoMKg
wqDCoCBzdGF0aWMgaW5saW5lIHU2NCB0ZGhfc3lzX2xwX3NodXRkb3duKHZvaWQpDQo+ID4gwqDC
oMKgwqDCoMKgwqAgew0KPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3RydWN0
IHRkeF9tb2R1bGVfYXJncyBpbiA9IHsNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoH07DQo+ID4gwqDCoMKgwqDCoMKgwqAgDQo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gdGR4X3NlYW1jYWxsKFRESF9TWVNfTFBfU0hVVERPV04sICZpbiwgTlVM
TCk7DQo+ID4gwqDCoMKgwqDCoMKgwqAgfQ0KPiA+IA0KPiA+IFdoaWNoIGlzbid0IGFjdHVhbGx5
IHVzZWQuLi4NCj4gDQo+IExvb2tzIGxpa2UgaXMgd2FzIHR1cm5lZCBpbnRvIGEgTk9QIGluIFRE
WCAxLjUuIFNvIHdpbGwgZXZlbiBmb3JldmVyIGJlDQo+IGRlYWQgY29kZS4gSSBzZWUgb25lIG90
aGVyIHRoYXQgaXMgdW51c2VkLiBUaGFua3MgZm9yIHBvaW50aW5nIGl0IG91dC4NCj4gDQo+ID4g
DQo+ID4gPiBCdXQgSSdkIGFsc28gZGVmZXIgdG8gdGhlIEtWTSBtYWludGFpbmVycyBvbiB0aGlz
LsKgIFRoZXkncmUgdGhlDQo+ID4gPiBvbmVzDQo+ID4gPiB0aGF0IGhhdmUgdG8gcGxheSB0aGUg
c3ltYm9sIGV4cG9ydGluZyBnYW1lIGEgbG90IG1vcmUgdGhhbiBJIGV2ZXINCj4gPiA+IGRvLg0K
PiA+ID4gSWYgdGhleSBjcmluZ2UgYXQgdGhlIGlkZWEgb2YgYWRkaW5nIDIwIChvciB3aGF0ZXZl
cikgZXhwb3J0cywgdGhlbg0KPiA+ID4gdGhhdCdzIGEgbG90IG1vcmUgaW1wb3J0YW50IHRoYW4g
dGhlIHBvc3NpYmlsaXR5IG9mIHNvbWUgb3RoZXINCj4gPiA+IHNpbGx5DQo+ID4gPiBtb2R1bGUg
YWJ1c2luZyB0aGUgZ2VuZXJpYyBleHBvcnRlZCBfX3NlYW1jYWxsLg0KPiA+IA0KPiA+IEkgZG9u
J3QgY2FyZSBtdWNoIGFib3V0IGV4cG9ydHMuwqAgV2hhdCBJIGRvIGNhcmUgYWJvdXQgaXMgc2Fu
ZSBjb2RlLA0KPiA+IGFuZCB3aGlsZQ0KPiA+IHRoZSBjdXJyZW50IGNvZGUgX2xvb2tzXyBwcmV0
dHksIGl0J3MgYWN0dWFsbHkgcXVpdGUgaW5zYW5lLg0KPiA+IA0KPiA+IEkgZ2V0IHdoeSB5J2Fs
bCBwdXQgU0VBTUNBTEwgaW4gYXNzZW1ibHkgc3Vicm91dGluZXM7IHRoZSBtYWNybw0KPiA+IHNo
ZW5hbmlnYW5zIEkNCj4gPiBvcmlnaW5hbGx5IHdyb3RlIHllYXJzIGFnbyB3ZXJlIHRoZWlyIG93
biBicmFuZCBvZiBjcmF6eSwgYW5kIGRlYWxpbmcNCj4gPiB3aXRoIEdQUnMNCj4gPiB0aGF0IGNh
bid0IGJlIGFzbSgpIGNvbnN0cmFpbnRzIG9mdGVuIHJlc3VsdHMgaW4gYnJpdHRsZSBjb2RlLg0K
PiANCj4gSSBndWVzcyBpdCBtdXN0IGJlIHRoaXMsIGZvciB0aGUgaW5pdGlhdGVkOg0KPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9sa21sLzI1ZjBkMmMyZjczYzIwMzA5YTFiNTc4Y2M1ZmMxNWY0
ZmQ2YjlhMTMuMTYwNTIzMjc0My5naXQuaXNha3UueWFtYWhhdGFAaW50ZWwuY29tLw0KDQpIbW0u
LiBJIGxvc3QgbWVtb3J5IG9mIHRoaXMuICA6LSgNCg0KPiANCj4gPiANCj4gPiBCdXQgdGhlIHRk
eF9tb2R1bGVfYXJncyBzdHJ1Y3R1cmUgYXBwcm9hY2ggZ2VuZXJhdGVzIHRydWx5IGF0cm9jaW91
cw0KPiA+IGNvZGUuwqAgWWVzLA0KPiA+IFNFQU1DQUxMIGlzIGluaGVyZW50bHkgc2xvdywgYnV0
IHRoYXQgZG9lc24ndCBtZWFuIHRoYXQgd2Ugc2hvdWxkbid0DQo+ID4gYXQgbGVhc3QgdHJ5DQo+
ID4gdG8gZ2VuZXJhdGUgZWZmaWNpZW50IGNvZGUuwqAgQW5kIGl0J3Mgbm90IGp1c3QgZWZmaWNp
ZW5jeSB0aGF0IGlzDQo+ID4gbG9zdCwgdGhlDQo+ID4gZ2VuZXJhdGVkIGNvZGUgZW5kcyB1cCBi
ZWluZyBtdWNoIGhhcmRlciB0byByZWFkIHRoYW4gaXQgb3VnaHQgdG8gYmUuDQo+ID4gDQo+ID4g
DQo+IFtzbmlwXQ0KPiA+IA0KPiA+IFNvIG15IGZlZWRiYWNrIGlzIHRvIG5vdCB3b3JyeSBhYm91
dCB0aGUgZXhwb3J0cywgYW5kIGluc3RlYWQgZm9jdXMNCj4gPiBvbiBmaWd1cmluZw0KPiA+IG91
dCBhIHdheSB0byBtYWtlIHRoZSBnZW5lcmF0ZWQgY29kZSBsZXNzIGJsb2F0ZWQgYW5kIGVhc2ll
ciB0bw0KPiA+IHJlYWQvZGVidWcuDQo+ID4gDQo+IA0KPiBUaGFua3MgZm9yIHRoZSBmZWVkYmFj
ayBib3RoISBJdCBzb3VuZHMgbGlrZSBldmVyeW9uZSBpcyBmbGV4aWJsZSBvbg0KPiB0aGUgZXhw
b3J0cy4gQXMgZm9yIHRoZSBnZW5lcmF0ZWQgY29kZSwgb29mLg0KPiANCj4gS2FpLCBJIHNlZSB0
aGUgc29sdXRpb24gaGFzIGdvbmUgdGhyb3VnaCBzb21lIGl0ZXJhdGlvbnMgYWxyZWFkeS4gRmly
c3QNCj4gdGhlIG1hY3JvIG9uZSBsaW5rZWQgYWJvdmUsIHRoZW4gdGhhdCB3YXMgZHJvcHBlZCBw
cmV0dHkgcXVpY2sgdG8NCj4gc29tZXRoaW5nIHRoYXQgbG9zZXMgdGhlIGFzbSBjb25zdHJhaW50
czoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC9lNzc3YmJiZTEwYjFlYzJjMzdkODVk
Y2NhMmUxNzVmZTNiYzU2NWVjLjE2MjUxODY1MDMuZ2l0LmlzYWt1LnlhbWFoYXRhQGludGVsLmNv
bS8NCg0KU29ycnkgSSBmb3Jnb3QgZm9yIHdoYXQgcmVhc29uIHdlIGNoYW5nZWQgZnJvbSB0aGUg
KGJ1bmNoIG9mKSBtYWNyb3MgdG8gdGhpcy4NCg0KPiANCj4gVGhlbiBuZXh0IHRoZSBzdHJ1Y3Qg
Z3JldyBoZXJlLCBhbmQgaGVyZToNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtbW0v
MjAyMzA2MjgyMTExMzIuR1MzODIzNkBoaXJlei5wcm9ncmFtbWluZy5raWNrcy1hc3MubmV0Lw0K
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8yMDIzMDYzMDEwMjE0MS5HQTI1MzQz
NjRAaGlyZXoucHJvZ3JhbW1pbmcua2lja3MtYXNzLm5ldC8NCj4gDQo+IE5vdCBzdXJlIEkgdW5k
ZXJzdGFuZCBhbGwgb2YgdGhlIGNvbnN0cmFpbnRzIHlldC4gRG8geW91IGhhdmUgYW55DQo+IGlk
ZWFzPw0KDQpUaGlzIHdhcyBkdWUgdG8gUGV0ZXIncyByZXF1ZXN0IHRvIHVuaWZ5IHRoZSBURENB
TEwvU0VBTUNBTEwgYW5kIFREVk1DQUxMDQphc3NlbWJseSwgd2hpY2ggd2FzIGRvbmUgYnkgdGhp
cyBzZXJpZXM6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvY292ZXIuMTY5MjA5Njc1
My5naXQua2FpLmh1YW5nQGludGVsLmNvbS8NCg0KU28gd2hlbiBQZXRlciByZXF1ZXN0ZWQgdGhp
cywgdGhlIF9fc2VhbWNhbGwoKSBhbmQgX190ZGNhbGwoKSAob3INCl9fdGR4X21vZHVsZV9jYWxs
KCkgYmVmb3JlIHRoZSBhYm92ZSBzZXJpZXMpIHdlcmUgYWxyZWFkeSBzaGFyaW5nIG9uZSBhc3Nl
bWJseQ0KbWFjcm8uICBUaGUgVERWTUNBTEwgd2VyZSB1c2luZyBhIGRpZmZlcmVudCBtYWNybywg
dGhvdWdoLiAgSG93ZXZlciB0aGUgdHdvDQphc3NlbWJseSBtYWNyb3MgdXNlZCBzaW1pbGFyIHN0
cnVjdHVyZSBhbmQgc2ltaWxhciBjb2RlLCBzbyB3ZSB0cmllZCB0byB1bmlmeQ0KdGhlbS4NCg0K
QW5kIGFub3RoZXIgcmVhc29uIHRoYXQgd2UgY2hhbmdlZCBmcm9tIC4uLg0KDQogIHU2NCBfX3Nl
YW1jYWxsKHU2NCBmbiwgdTY0IHJjeCwgdTY0IHJkeCwgLi4uLCBzdHJ1Y3QgdGR4X21vZHVsZV9h
cmdzICpvdXQpOw0KDQp0byAgLi4uDQoNCiAgdTY0IF9fc2VhbWNhbGwodTY0LCBzdHJ1Y3QgdGR4
X21vZHVsZV9hcmdzICphcmdzKTsNCg0KLi4uIHdhcyB0aGUgZm9ybWVyIGRvZXNuJ3QgZXh0ZW5k
LiDCoA0KDQpFLmcuLCBsaXZlIG1pZ3JhdGlvbiByZWxhdGVkIG5ldyBTRUFNQ0FMTHMgdXNlIG1v
cmUgcmVnaXN0ZXJzIGFzIGlucHV0LiAgSXQgaXMNCmp1c3QgaW5zYW5lIHRvIGhhdmUgc28gbWFu
eSBpbmRpdmlkdWFsIHJlZ3MgYXMgZnVuY3Rpb24gYXJndW1lbnQuDQoNCkFuZCBQZXRlciB3YW50
ZWQgdG8gdXNlIF9fc2VhbWNhbGwoKSB0byBjb3ZlciBUREguVlAuRU5URVIgdG9vLCB3aGljaA0K
aGlzdG9yaWNhbGx5IGhhZCBiZWVuIGltcGxlbWVudGVkIGluIEtWTSB1c2luZyBpdHMgb3duIGFz
c2VtYmx5LCBiZWNhdXNlDQpWUC5FTlRFUiBiYXNpY2FsbHkgdXNlcyBhbGwgR1BScyBhcyBpbnB1
dC9vdXRwdXQuDQoNCg==

