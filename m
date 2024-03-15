Return-Path: <kvm+bounces-11874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF1EB87C707
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 02:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ED1F2821B1
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 01:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E81AD517;
	Fri, 15 Mar 2024 01:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RilVKYr7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD31DD266;
	Fri, 15 Mar 2024 01:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710465434; cv=fail; b=LqDu3deizFkjEJZRBV6TuylbW6iwJ9KdmtNKwsxqBrxcG/DhpgrEhx0AY9K582/8dy2IzDh2YocAyerYNXih7zWEPuPQarBhvAlWH0HdooYaWuc/mUUL5H0GlAi3TNo25Ok0dUq1ygdtEEP1gSd+OD68ZnauGMZzQZiCzmRzF1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710465434; c=relaxed/simple;
	bh=M4k5C9pPQ2UtaifDPz6qtxve2rNld+GA8e/TTSyZAmU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OMkxRh1n+XzJN8tUtTnQnby0/GNV7sUo+P3SMzcWtihCIWGKELFhtYFT17nY0tVw6J93aW5iDthZCLwoZROR28TU/VGxBbKKgKnZWS16OY+JLE6WloGc0udlh5V/hcldpTwfidkENeBmPFum1oyW0J9uXJp/wVtEPLAzz3kK1s4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RilVKYr7; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710465432; x=1742001432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M4k5C9pPQ2UtaifDPz6qtxve2rNld+GA8e/TTSyZAmU=;
  b=RilVKYr74O3cJVoLJ7EYNRcIM/xWBkw8oEaNL6I7uKwYu+uZimsAiJEK
   T/18bl+GTWR+STVrSm1MytQylDUkVsaP5RBxMUEBvDLgKjpMB4glVioqz
   Teub8Appe8CIIhlFxsWepMUdvFeevUh8c+RsEhKPU7fCHHbaTE2fiF/Q3
   35usFeJVGmXo3H9TFnOaP1s+PLcHd1Jezvg5J03fMk/HlyvE7T7s+bX+I
   vplEbKcsJIWaF7UmlCr+eE9Vh/LZGrzPYOTwJSsHp7+wH2ce0B8JAnL7Z
   ax7bipCzG56/5Cc9FX5HJxENVcVpWXYZyEffVS+ximK4VrkfnajQeSCGa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="16718569"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="16718569"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 18:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="12533308"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 18:17:11 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 18:17:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 18:17:10 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 18:17:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezFWTYDamXhJs48Zm/EsVWF25lkFtYbecC9k4ctf0fXRTDMiWbUuy+wliHTxoEz7V9NviORuw+r88jJK5odOwUn9BjfmRdCb+XcI7xxh6x1XoJVqK1s+qG+c6Mcbmn9o7l0VY2oKjmZAgaCSL69fgPQut9pULIbmMbj+NQD7Y8NMd0wYGUJstI8Netu8QOZ/OWSnHOCle8e4EQPQ/tAib8EKDJeR2gc1GPP4XaqzMMGSOkNrzAiGcEUaPzZJkpM5L+iUJkm4gHt3JueqhiclrWponHD+sJtVsOBIo5Y9rEt4JX2KRwkOqlynTL1R4j3nFJIeucEzIk4eYuUdYghkRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4k5C9pPQ2UtaifDPz6qtxve2rNld+GA8e/TTSyZAmU=;
 b=O1Vqt2Iu7+I24V9Hh9yGgZzVQqCEwCh0l3z8ic+IAyRew+sk16yvJwlTvwjdkMbMuPkcOtk5xveyf6NQl4nKkejk74YNy5wGnenOxnjEk1BAsam/Mdyz3kOjo8HbtWTUntLgJkfHNrur6Ap/qx2LVEjPgncNxLs9pbrGVoV5+oAM+bHsQ+GoIcz9Shwo6xt77c/qNkB3eAGkoapsJbBZke69TI2pA+qxyGLK10cUlkN/YjHFo9CK19UPyTdKC+NARpYSYDtDY2T5QZ1B96N9i9ZMi6LUGU4O9unVvgUyNkAkeCerSI/tqo2MwptApeugdvWM/BdIr3RtY0Py1gN5EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by MN0PR11MB6255.namprd11.prod.outlook.com (2603:10b6:208:3c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.16; Fri, 15 Mar
 2024 01:17:07 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6%7]) with mapi id 15.20.7386.017; Fri, 15 Mar 2024
 01:17:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Huang, Kai" <kai.huang@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "x86@kernel.org"
	<x86@kernel.org>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHadnZ/Qf0yAsUauU2/h9YYap6riQ==
Date: Fri, 15 Mar 2024 01:17:07 +0000
Message-ID: <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <8f64043a6c393c017347bf8954d92b84b58603ec.1708933498.git.isaku.yamahata@intel.com>
	 <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
In-Reply-To: <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|MN0PR11MB6255:EE_
x-ms-office365-filtering-correlation-id: 95e0923e-1e36-4028-5afa-08dc448da1fd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xQ30Nte+R7CCkYUD3HNrsPg/vdA/0nWuv+7/rDzFx7UY8UVUsbkmFnpvHR3zc893cyOwTsBAE8d7kNamipnk0EroSYQyaDDvUCP9EDLbFQwywBh4Rtb1XyfG34ll2N8zUT3lO9NFDPGF5vFY0pVHviyBEIO0U64pfxQou63L82gcyfSLCmrGvnqb2BrXEl4BoHfmd4wHa6TGgIGF/BwjhebpzDJ7ltvBLxQ7XxS6xHhA8EK7bgkttuxBDM9MEXtrUVaZUtae5N+VFDW43901MmjUseQomlAD5AE2y4EG4bJQdnHG0nc93+yWlbdFKcEv4FJnu3xKeRdVZXctX4XhXsz1S/ZvNpaYe9TrywHt7gxEtFaDI5XCWp7r9HxgiI223Ih4HuGmUqHavTCjmRt4ookItIBE7Jzka8i9TP1A9ZLWJ3C3+hzmE74MNEn/jH+kmPaGUHqpSJV2+jXhxTITtQEqnB4lncdFpkAmIaxusQ6C44y/DX6HpPv+GC2WhsVvJTGlsJc8IHFxLiLBrhj8SoUrIDxVhYwWmpoMSpJNvgTJw+4Jcu8OFAqoVe/FmOhf+YK/c6XmAaNVBIIDhytCFEAVaFSPZ7P6SSYxzYB9YAOLGSoS58V9mKH/FPTZOJ8jXdLPT+P9L8yBGKWUNwh0aYI+e9VU6ptZgfymjqgs/RY6IxUiCBuW00+NaUy+bq4T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXpqVXZvVDFGWXFGUS8zNnpTWDBkcDhGdGt4UzZhNEJneW1MS3VnemxBWXR0?=
 =?utf-8?B?YkJPallQT0VWQ2I2U0Y1bU5YYlRUb2I3dmxsdU9zWmFnRTkxVFA4T0d4VFd6?=
 =?utf-8?B?dThpU0U4RGZFSXc0bmpqTmxFZWVPVVNIOG9UT0tDamtNNlFiY3cvSDcvK0xu?=
 =?utf-8?B?YkpqYUFMUVZLNTI0eG9MYjhlU2NEQmlEbHVta3dkSWp0cFo4bmxHd25BbE9T?=
 =?utf-8?B?My96Z0lNTUIrUGJIUjNwdFY1MnJlZ1pNZWFPbDFIWkRaTzdQVmhGS051WjF6?=
 =?utf-8?B?dmpWLzVsSUJ0Rk9RNSt0dEFkbktvSDBnbGEvZGlLUjJkaDFncnp2V05PZ2Ix?=
 =?utf-8?B?L0U5VGl5dW9RU2pqQ01ZcVV1M1A4VTZiMERNbER2VmI3M1pnblNWRUlZM3Ur?=
 =?utf-8?B?SlNTVGRWTGwwcTErck5SSHVoZ1dPSElIMlJvcmtCQVRtL1dEUUtlc1BEQTB2?=
 =?utf-8?B?czNhNUJaMFUraFBPSkp6Ui9wdXB4bWw3VmRBdUtTa3BTbXhvd3ZnckpoMHRO?=
 =?utf-8?B?NUJoM25qU1R1dlJ3UUF1M3lzTWd4Sko5aWJXODYwQVVDVEJWbWhsaWgyb3Jn?=
 =?utf-8?B?ZkJ0Wk0rS21ZQ3AydmdLem1BbFNjdS9xRVdVUW9KT3ViZCtBVTdlMkp4MEZ0?=
 =?utf-8?B?UW42NTNjNEpJeWtoMDJGZGpMWmkwVWk2K1Y0WWxQc0JxcmF1alBoQUJkc3BW?=
 =?utf-8?B?c3NKa2oyT0FzVldVRWZ4aTdselpvSHI1YlhBdVppMWoxUjR0eHBnWUJmSU5K?=
 =?utf-8?B?NFFpVjdnRVFBQmdOdmM2cVFNa0lNaG9qd1RSR3pMV3l2ZHZQVWpkZTQ0TkZl?=
 =?utf-8?B?SnhHVkNZaUpmT3VPbXI0THFDMk9OS25JelQxRW5icUpwanVlMm4wUHUrbVEv?=
 =?utf-8?B?WDJvUEdsdjJRS3hNM1RTMWtpdlR5MnN6cjNENVBXQy9VQjd0MUREVGpCT1hq?=
 =?utf-8?B?aVhiZmVkYUhCd2ZHekc4dVVEbzBaWFlFcWowS0xzaFhuenFxbEVqTEMreGJN?=
 =?utf-8?B?ZytrdFdYY3M5bTNKWXpVK1N5QUZXTGVaNjRmZkxZakw5RVl1UVB2akpIUFJu?=
 =?utf-8?B?WEtyb1YxakljYnRqWHJYVzlrRXJzLzE5Vm1qS2JWZ2M0YmhXemVzRlhxRy80?=
 =?utf-8?B?QkxtT3FSb05aYmE5L2xhQ04xNDhjV3R0b09EQjV4NmFEVGc5cmpVRjhUUnVn?=
 =?utf-8?B?QzhUcjdYcVRyK0xOL2p0aDN1TVMvOTdzc2dJVWQ3UmRHaUdGS2R6VFZGWHN0?=
 =?utf-8?B?Y2k1NTJXK044UTNUTDM0L3RXSkdPdWVhTEVWTkFxUFZoVWN4SXRtbkhRTE5Q?=
 =?utf-8?B?Y2RsaUk4Qi9CNVFlV0FjZitPY05qQldMN05CWC9hbFpBVFdLRFpsRGxpcmVX?=
 =?utf-8?B?V09pY0pzR3FGOFNPMHBYM2xyczZNZURMVEUvVUN5UUcxQ1BjcTJUcThvcXFF?=
 =?utf-8?B?UUphQVNJQmFPUlhWODFteFh0MUlUcGE1S2FsZWdzcGdPN212bzdES0F2UVhT?=
 =?utf-8?B?USsydll2SHFHK1o2WnZuMkNzUWdRQ1NBL0RQTmtiOFpjZ0o0ODB4cGw1OWJu?=
 =?utf-8?B?Y3RxNnFyVGxLV29DMWZDbXN0aEUzVHQraXo5YzBOV1FmTFh0Y21Ubm1FS0sy?=
 =?utf-8?B?ckZGU25qaU1odGNmNXdHVzE5bHlkNFJqUDVIWFhlUnpIWDhxNzg4VFh6clh2?=
 =?utf-8?B?TjR1SGZ4ZUNzdVptMFJiMmFRQkZWWlBHSVRFQjFEL28zTG5RMzBta1NhUTlQ?=
 =?utf-8?B?REdWQUw0NGZQQThWcjZiQUQ3YS84MHpIUjJKN2FVdGxEVDdqRjV3UGg2eHlz?=
 =?utf-8?B?dzNVNjRTdEFTYVVkMzYrMzlWajhjUkhyWkQ4bHFxZGt1bU1xRDRCUFV0R2lj?=
 =?utf-8?B?aG5tckFhUjl6bGFFd3VsL2w1UVBJd05xZGJZMEZhNVJwT3dHRzhJY3FocHl2?=
 =?utf-8?B?UTdibFRJSjVrZmZmVUMwZ2lsVU9WSTNXZ1hkYW0rMXNYaW4yekZ0VWlHZGJP?=
 =?utf-8?B?V1hPVHd0YlNkc3lmb0p2SE5EVmZSanNnbnVoa0EvbXJ3RmJFUTNFVHowOGtC?=
 =?utf-8?B?d0lkMjcwZ1FidkUzODg5NEJMNWpDT20wQnJnSmIxVHpMQ0g2eTE2K0wxOG9Q?=
 =?utf-8?B?NHJSeU5IQUlrRXFNMzlJVEdOUkdPZDlMRWlrODRNWnJST21RMTZhazU0S05j?=
 =?utf-8?Q?A0qNsuYwdUFvveMfJwzaN1k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A5243C3253E38E40A6599D34D87B760D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95e0923e-1e36-4028-5afa-08dc448da1fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 01:17:07.8450
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z9OKvxKLteZYg4IEwu5pvEuM/9AH+MJ4GTZ4auPfqYrgiIQKod6vhoM61NF/V3iEHor7gppl62kLy7QD7D7VBesEAOu3zhaxLTWXuOeMU5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6255
X-OriginatorOrg: intel.com

RGF2ZSwgY2FyZSB0byB3ZWlnaCBpbiBoZXJlPw0KDQpDb250ZXh0ICh3aGV0aGVyIHRvIGV4cG9y
dCB0aGUgZ2VuZXJpYyBfX3NlYW1jYWxsIGZvciBLVk0ncyB1c2UpOg0KaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGttbC9lNmU4ZjU4NS1iNzE4LTRmNTMtODhmNi04OTgzMmExZTRiOWZAaW50ZWwu
Y29tLw0KDQpPbiBGcmksIDIwMjQtMDMtMTUgYXQgMTM6MDIgKzEzMDAsIEh1YW5nLCBLYWkgd3Jv
dGU6DQo+IEtWTSByb3VnaGx5IHdpbGwgbmVlZCB0byB1c2UgZG96ZW5zIG9mIFNFQU1DQUxMcywg
YW5kIGFsbCB0aGVzZSBhcmUgDQo+IGxvZ2ljYWxseSByZWxhdGVkIHRvIGNyZWF0aW5nIGFuZCBy
dW5uaW5nIFREWCBndWVzdHMuwqAgSXQgbWFrZXMgbW9yZSANCj4gc2Vuc2UgdG8ganVzdCBleHBv
cnQgX19zZWFtY2FsbCgpIGFuZCBsZXQgS1ZNIG1haW50YWluIHRoZXNlIFZNLQ0KPiByZWxhdGVk
IA0KPiB3cmFwcGVycyByYXRoZXIgdGhhbiBoYXZpbmcgdGhlIFREWCBob3N0IGNvZGUgdG8gcHJv
dmlkZSB3cmFwcGVycyBmb3INCj4gZWFjaCBTRUFNQ0FMTCBvciBoaWdoZXItbGV2ZWwgYWJzdHJh
Y3Rpb24uDQoNClRoZSBoZWxwZXJzIGJlaW5nIGRpc2N1c3NlZCBhcmUgdGhlc2U6DQpodHRwczov
L2xvcmUua2VybmVsLm9yZy9sa21sLzdjZmQzM2Q4OTZmY2U3YjQ5YmNmNGI3MTc5ZDBkZWQyMmMw
NmI4YzIuMTcwODkzMzQ5OC5naXQuaXNha3UueWFtYWhhdGFAaW50ZWwuY29tLw0KDQpJIGd1ZXNz
IHRoZXJlIGFyZSB0aHJlZSBvcHRpb25zOg0KMS4gRXhwb3J0IHRoZSBsb3cgbGV2ZWwgc2VhbWNh
bGwgZnVuY3Rpb24NCjIuIEV4cG9ydCBhIGJ1bmNoIG9mIGhpZ2hlciBsZXZlbCBoZWxwZXIgZnVu
Y3Rpb25zDQozLiBEdXBsaWNhdGUgX19zZWFtY2FsbCBhc20gaW4gS1ZNDQoNCkxldHRpbmcgbW9k
dWxlcyBtYWtlIHVucmVzdHJpY3RlZCBzZWFtY2FsbHMgaXMgbm90IGlkZWFsLiBQcmV2ZW50aW5n
DQp0aGUgY29tcGlsZXIgZnJvbSBpbmxpbmluZyB0aGUgc21hbGwgbG9naWMgaW4gdGhlIHN0YXRp
YyBpbmxpbmUgaGVscGVycw0KaXMgbm90IGlkZWFsLiBEdXBsaWNhdGluZyBjb2RlIGlzIG5vdCBp
ZGVhbC4gSG1tLg0KDQpJIHdhbnQgdG8gc2F5IDIgc291bmRzIHRoZSBsZWFzdCB3b3JzdCBvZiB0
aGUgdGhyZWUuIEJ1dCBJJ20gbm90IHN1cmUuDQpJJ20gbm90IHN1cmUgaWYgeDg2IGZvbGtzIHdv
dWxkIGxpa2UgdG8gcG9saWNlIG5ldyBzZWFtY2FsbHMsIG9yIGJlDQpib3RoZXJlZCBieSBpdCwg
ZWl0aGVyLg0K

