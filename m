Return-Path: <kvm+bounces-12631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F2E188B474
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FAC51C3CAEB
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:48:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 831397FBDB;
	Mon, 25 Mar 2024 22:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V5ie5D17"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B146F7F7DD;
	Mon, 25 Mar 2024 22:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711406876; cv=fail; b=UR+5C7yiA07Y2CQY8VZaLnD+YVOW2yBfeoidu4x4DOv+/vsFsJPq/bTgkURQ7iMa5OYMQVNKadbd4ECbFd6JxDXLTxIYnYUrBHf2O7f8LYNii9wN1htKmvmXgIP95zQhnnC1Luns8xGLMgyeTFcV6lb1gzcVPEMnPHs28rjGmAY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711406876; c=relaxed/simple;
	bh=vx8QF1zslaLkocMfTpKK0RXEbbuulBYIlxSEVVsdQt4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CH3lBc7fIhkmRxq1nYQgQRLYTE7e+NA+iktcBmvwZiTbegLi3v/9ALqgKqNVokYs39L9jjWXfvM8vcyusjWLiXDA16fniDHjClMy4nrpQgK/AQxxal5iDvqsnkO+qUzNQ4RPjqnmu/r3vQZXLbhqfXfERfn/TuiLpjtyQyIMZ+M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V5ie5D17; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711406875; x=1742942875;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vx8QF1zslaLkocMfTpKK0RXEbbuulBYIlxSEVVsdQt4=;
  b=V5ie5D17ZzLRg0qt/OQ453VpQdJbaxeUyAx76pewXyEx939abWzNJACx
   7yRf2P4whPQfSDnivrb5+wK9wIYjYHeJOQM8qYqQbKMCemNEa0Pt9h6uq
   NAaG48Qo61WMDt/wbJhvCW+6qHMIc4pSJ8Fvbx4/6lT4WPJuQotB7K5xn
   u47ft1nGvPhPmoU2kD7kyFd/0FEshMLdfVEhz0UbfrfYiomEuymmD0SJl
   P5N5kbaFp1g6yYMEbN/i8JPOEEDZPkEWMKWyIOx3FqhnHDuf/TRFP124g
   xXz/0OfzTyx99aX+iETpxcPiGkqEST43gZTO1+x0KyZbFSkoEVyTWI+JR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="28915635"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="28915635"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 15:47:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="16150583"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 15:47:53 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 15:47:52 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 15:47:52 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 15:47:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rr6YRXlwjLMrlmSofbgQvfvLjwZSI9Csn+UvZI5HIuszcGYi5tsulysuTWsTcXdlBfOGu7NG+n1By4Qt+kvrOeiFy2t8r4vNi2TaPx05DbD4snFchtpV9g2LjNfRvpgwtKp7JkxV9IbYCUb6ZU4iiYdzWAiX3uLH8YgbOJ//5q94Q0XwxJfKCFmiCo4V4W5zjY+UYS29pGdcQIkv8Z2BCNdGF/hxTQrnIS1NUM8u8uqNzFFPDagl60FhL4cG1gWYdZXyvHGE0WnvWmEthEgNeDattww5cbMym5yRliUZAUbpV/wXLKIELpAGifkTJ0IMVvIOcZlxHIO+chS60EKV+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vx8QF1zslaLkocMfTpKK0RXEbbuulBYIlxSEVVsdQt4=;
 b=W9GblaHwPQW58KnvYReQIID5zFaC+MFiiXVNYWuFJbyetNNGXcnmtjQIE23oiPRaXs38DKZIkkfz+P9B5bSG53YDe0TQs4kGTqoYsW0byo6870RftfsyOv3aqL8vjBzB8FJOgkDTo2W1Ud4wJS1TApxExRRqjbMaHpvqw35UCzh/B/MwtHOAu6hbJyN0cvlZfmZd4f1akbBmc5cGwTNJGfDHSCaBDeFyg7L8ckynv6b26if52GrcQE1PAbfKZQQBpPdPdkSyuG3icVZjfZn8K9IlSrYcd45nYocbSdakuEbxbxF6RY4zQwwhPLqZmEkRqhv7jnIElOB1OYnufS2nbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB7101.namprd11.prod.outlook.com (2603:10b6:303:219::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 22:47:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 22:47:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, Binbin Wu
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: RE: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Topic: [PATCH v19 037/130] KVM: TDX: Make KVM_CAP_MAX_VCPUS backend
 specific
Thread-Index: AQHaaI2/dJkfmwuOl0Kzt5Q4G20a/rFD2hEAgADTe4CAA6IeAIAA1sUAgAAVH1A=
Date: Mon, 25 Mar 2024 22:47:42 +0000
Message-ID: <BL1PR11MB5978C5DAC10C962AFD1DB764F7362@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9bd868a287599eb2a854f6983f13b4500f47d2ae.1708933498.git.isaku.yamahata@intel.com>
 <a0155c6f-918b-47cd-9979-693118f896fc@intel.com>
 <20240323011335.GC2357401@ls.amr.corp.intel.com>
 <fde1729f-aca7-4cf8-a2cb-a7fde5b4f936@linux.intel.com>
 <20240325213118.GL2357401@ls.amr.corp.intel.com>
In-Reply-To: <20240325213118.GL2357401@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB7101:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o+o+5CbgnAWhWdZf4uTilFXcGqcrDx9MRqsimIgvPxOwP6Q1ZQmEqf53HZjxnVfJrkn9pC0auGyUOudCEr30akinQJaAU9N7i05Rn+ibOkZZU7FlZ3asrao4ebpQ4SgkO/V7EVP6Lg1LbipXJG2V8HJrW04Y6XIRmuBENahW7dLZyiOD5P/NM09HaO91FlHd7KC9Yq9ypUqfr5kDZFI3FMvdzz1e96NGeUWfITxzv4mibB4mHD8N7km/imUeZx4pnZp5m7ZimplqDbNA16fq8KAQPxZbt9BRZx1NREbAh2qVJGinT4liUEUFUoZxZ5FdqbAbMZ3hr4I+jnRjB1fp2G+spAT+PHSuA1XlRN5YGH2KQU4D76p9YwHFYBbSkNMMpzYYQoeypZ6RVoEd/TXrFcnKFhDuA32S+WHirliCHltTdujknYwAfuOJrzRUfx6LxHMGo6FKxyefbdpRL1a+u38D4Zzf/BX4B3XT85f3VPYFS0P6WKNFXG5Z1LOLsaV9TvG9WtKMzfPxiQ2e4FY0XYa4iRpDPN1j9Fv2tOyjflqMwsPn6rXULM33i/niOozz+3RrIiAL6Hupkfh8En8w00PdauJ+fpSyx1jHYA2vyHm+WpANfMdqXURU9PRxar5mFSlZyo6eBz+0rZtwG1aAdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDdwaXh5Y3JqdlYyb0pHTEFGd05ZSVJqYm9BWEVyY0Jac2psTThvcWFOdnZz?=
 =?utf-8?B?c0p2L3BMTDIvRHRDQ01rdW9ob2hKUlRCWGZvMDRscS9kYldqNEwxaEM4ZTBM?=
 =?utf-8?B?Wml4bHROQWpFMk42N2QzSktXRXRJUlVqb0Y1MEdhUUlRWi9aZXgxRlk2NUxs?=
 =?utf-8?B?Mjg5WHhxT2FadUFSMmgyQXNkc2NrWW5jNFZjZFcxOUd0bEV5VW40Mm9NeThm?=
 =?utf-8?B?cjRsaWhTWnpQQUZGSUxiYmFrOWlYVlZRNmVoMnhZYkdvTXZtQzRMS3cxZjBN?=
 =?utf-8?B?emMyb2hyUnA1YndoSFZweXhWQjZXTktzVWZRdC8zdHZneWRtRFlrdy80enhB?=
 =?utf-8?B?c0JkblZQcDJObXdtNFcyWmNLTER4WEZ2RU1aWkNNVU00dmZGc2h0NlFVcXJm?=
 =?utf-8?B?dGVnVkRlRmVqTjVFY0dDUG9TVys5YjkySWdyY2d5d2JVViszVTVvaDA0aWJH?=
 =?utf-8?B?cVVvSHNjMUVrSkxmOEdUcWh2b080UGljMExFa3ZNUDlXcEZyRnAyZ0s2T0tn?=
 =?utf-8?B?djRGcm0zM003U2JEdG01NjVjVk8yTjZBdHArRGNUclFOb09JQ04wNVVhV3dT?=
 =?utf-8?B?UWJiS2tLV0xlVk1MbktJUXhaN2dZSUdHNFkydklYR2FEMEEzQktaN1BucWRm?=
 =?utf-8?B?TTZlajNoVHVrODJVM1FsZ240ZHQxWmNPaW42R2FTeGRrQk5JbFl4VUppZFJD?=
 =?utf-8?B?RkMySHNBVGJ1SExZWVZYQ2NPYXRZemF5MGs5TDNnQy9acW83Y3c4ZnNqeEFq?=
 =?utf-8?B?L3JLeFE0SlJTaG0vS3o3MktUaHFqcllUeHNUeEt4U1BPS1Y1VlFwTUE5THZu?=
 =?utf-8?B?dXhIZndIRTRJYVFMMFVBbUN2Y1lYS0ZoU1d6K3lTbmRVMGNoK2Jia1BSbDhE?=
 =?utf-8?B?eURYczAyVzlkK2daa1h2V1hOelNOU2tVY2tyenNucC8vZXhqQUZvYjVrcFNL?=
 =?utf-8?B?NUZUemFkdEhYTFoybElWekVFdHkvVkljMnZFcFBJSWlUMkJGc3J4ck9JcTNT?=
 =?utf-8?B?eEZmMmV1YmhRZDAxaTlzaG5NcVFIRjl2enc3VkdxZDQwaFg2UG1RdkgyT3Yy?=
 =?utf-8?B?eXNObW1uUnpOZTAwSVVCTXRaR0dHY2crRm5Fb09qQklqZlA3ZnE5Q3N1dVlS?=
 =?utf-8?B?NW5HaFYzaTZURTNOMjdhVDR4VVM3c2hiWmM2akJmVnNWZ1RZMlFkdkQ5c1FL?=
 =?utf-8?B?em4rUmUzaDBKcFcxNG9paVdMNll0L0p5NVNJTWRaRnhUS3VGYWErUDJyWmZn?=
 =?utf-8?B?ZjN6dnR2UHhxRXlZcktOUWVJQ29YNUhLalNWbVBWV0I4NUtKanJlckorUW9M?=
 =?utf-8?B?cVRtbHovbDl0cnhESDZuVHhMbWtnZkVMS0tsbXBNSVlOMStzVzNNK25SdFBX?=
 =?utf-8?B?V29ScGhJd3gyZ0tNY2ZmMFhTSlZXZDlBL3p1Wi9GdW1sdXQwZkI4d0MzTFpQ?=
 =?utf-8?B?WW1YZkZJVUZnL1BkRjB1UDV0bkd6bUJvK2JCZ2xUdm1ZUTg5SG1QNS9kR3A1?=
 =?utf-8?B?aExUU0V3R2pGSlNDTkFWVWtnVmtHVXRNblJxRW4raTh3emlrRnFjRGducDg1?=
 =?utf-8?B?UkkxUGVaK294allqQk0yN1NzU3JaaVd2ZUJyMHRtQUdReW9BZkJPd0NiRkxu?=
 =?utf-8?B?bkl6TlppY25laXpYQ2NJNjlJWCtYMkVqNGMyMmFXTDlnNVRRNndob0NPUHBn?=
 =?utf-8?B?RmZsV1cvQWJWejdnNUtYajM4Q2d5ODdwc1hGZkppb0dFN1BPMWVrQmZPd2pj?=
 =?utf-8?B?SC9qeGhGellDZkNLeDVyUG5SeWh5bnl0cG1vdEpPb2I0bW5NV1IrZGZOL0hO?=
 =?utf-8?B?ckJncUo0NkVxTDZGbGRIUTMyeW12SlltTm1KYndxTHdjNVBXOFgzMWRKaS9Q?=
 =?utf-8?B?Tk14aFpJT0hBcDJHSFZ3NFNtVkp2SW5tQWZkWkN6SWhFSCtFSlpZOVNBemlZ?=
 =?utf-8?B?RTA0czg0S0ZoMlRoR3dROWZWTkJkcTZ1TWZEOTJnQmg3dXc5dmxVK0dyRlRQ?=
 =?utf-8?B?OVJlRkVVaVpqMVIzaFN1ZFJYUi9PVjdQbmhHN3lXWENQejF5K0k1cmsrTGlx?=
 =?utf-8?B?TVFTdzN2dGRJbEN6enlWemZzYkEvVWJIdzN0MnQ2K2xrMCtRRllFUEdJd21m?=
 =?utf-8?Q?YB1RP1QeXwPo2smjd9oMOISNd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ef838e-e46c-48fc-5120-08dc4d1d94f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 22:47:42.8151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6aItiuXpmvNgRppZhxB5j1lwHUhdL2kjO0PeFP8nByfVp8bZdHc3acKiy4CiEjtbsDE6BZJCJnZ7zf5bAGLcdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7101
X-OriginatorOrg: intel.com

PiA+IEhlcmUsICJ2ZXJpZmllZCIsIEkgdGhpbmsgS2FpIHdhbnRlZCB0byBlbXBoYXNpemUgdGhh
dCB0aGUgdmFsdWUgb2YNCj4gPiBtYXhfdmNwdXMgcGFzc2VkIGluIHZpYSBLVk1fVERYX0lOSVRf
Vk0gc2hvdWxkIGJlIGNoZWNrZWQgYWdhaW5zdCB0aGUNCj4gPiB2YWx1ZSBjb25maWd1cmVkIHZp
YSBLVk1fQ0FQX01BWF9WQ1BVUz8NCj4gPg0KPiA+IE1heWJlICJ2ZXJpZmllZCBhbmQgdXNlZCIg
Pw0KPiANCj4gT2suIEkgZG9uJ3QgaGF2ZSBzdHJvbmcgb3BpbmlvbiBoZXJlLg0KDQpJdCBkZXBl
bmRzIG9uIGhvdyB5b3UgaW1wbGVtZW50IHRoYXQgcGF0Y2guICANCg0KSWYgd2UgZG9uJ3QgcGFz
cyAnbWF4X3ZjcHVzJyBpbiB0aGF0IHBhdGNoLCB0aGVyZSdzIG5vdGhpbmcgdG8gdmVyaWZ5IHJl
YWxseS4NCg==

