Return-Path: <kvm+bounces-12630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D386E88B443
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:38:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 030D61C33988
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE3876402;
	Mon, 25 Mar 2024 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XD+IpT0g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED366E2AB;
	Mon, 25 Mar 2024 22:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711406278; cv=fail; b=tKDerAj9jeDGiQUgoOglxaW0JXqcNXSaoNzg2DccZtFbfpczExJe2d+92pIYmVIrxtFuoXvVqIxZzDQU9E5QsSoSaFldUNgeNFEYZ/kvgRrn4KQ+SiRZrIsBOcp1pyKYuu+rVRBVwRAeKx8eLotHb65J0CsJ7ZGcNZa/0Zp+x/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711406278; c=relaxed/simple;
	bh=5Pxgw9MEM79q8o+O9rzep7blC0KCOQ5WbGTl95HVknE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ANUoqP3vB5zsTUVdEcofd05DsgwtCboZF6QKhQ2QCEMJgqfaCvgteaauUAdFlANyQF2sCjOQdEDLRrqK4mdUUwV91q5LclDR94fH9qPtk6NrYu77qMQKg9Q35CH92/q55OTpEa9DpwdgwtPvJL2gSufDecBOcUd+T8M2l0024L8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XD+IpT0g; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711406277; x=1742942277;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5Pxgw9MEM79q8o+O9rzep7blC0KCOQ5WbGTl95HVknE=;
  b=XD+IpT0gEPLa3smPI1wXda6MgOrYuxl8+G3APYSjyVc9fWEVgQCKNdwB
   QTFWVkk8RyV/WGavab1K1xfxnU1lGYshH3cTLX6XyICzEgjONpn7jdjHI
   1sX4S5Vfj1A/nQzCuEfubFGrc2UPOkd0gy8Ji83nTR7hgPMFGv/397/Es
   aOzHN56jyZSbl8vZzd9Aljebm8MxyO1tm07/gSza8UC6m6pmGQAmRnLdw
   7Zl1aI+t6XlMRB1G7s1sY6S5oqRJfzZKDUwewEcSBugOyHkenbwWjw9eJ
   u84ME5ZT5V46Su6zfdnDQ6+CXZei+MMEPoZ7TzjwLyStRwIVJfOhaZ1/g
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="28914672"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="28914672"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 15:37:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="16148406"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 15:37:56 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 15:37:55 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 15:37:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 15:37:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 15:37:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gs18HygZoPqP/QBFCDFb61b6cs/nxkfM8KyGH/+OO3GA84dTxDkG+1XrfP5jQtX525eeO0aMmHejt+3NjbetBdMVAbLVsV1lSIhgCvIgd8d0MmpRVbjFGJl0owVSEenycGMJiVytWuc+IFUn04gmVaTUXwa9EpkeeSDxu6dEAEN3mZlAst9tNS5oXQJ+6Y/wzrAEpwOhniJyrL+dGbJAEq5itrVnK2pIz/TNjOIooCzT1nYp7lAT/21VOu3V3CiNKK4ZUOz32VqhaFfUr2XEiXET41U8+P3n3kyXD9TVQ1GDWLltahHd8jT452tEsDK5blmcZ8R/48YilJiZBHj7Iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Pxgw9MEM79q8o+O9rzep7blC0KCOQ5WbGTl95HVknE=;
 b=UyqVoj3nX+oh0ngPOjDEun+UDP75AaYAfuMYGlnPcnWe55cSa+WpU0259lM1Hl85+f4UOCaR3O+mMfOv05erZi/cxhxVk7M3Sn26keUK7/WdFJcNxrO2nKRsbgNKdpFE/tn7xk0QwxzUrXaFA3J1DC6kVMmw6kP3N0umID9g+Vs3GWKw6xX76qrxTZd+FtKrqxm1usc4yWpZ74RTrCJ5gDob/jTXUsZanjC8F0oRgR7gQ1zIZdwwPkGssAyZSx5H3cAujSaP/JMvZFEWHmxDhb0yRgSGwmqALkvNTkJ/Dn6maXTlvAnHKVtEv8vbnOkyAx5uf53y2zlvMXANG5/PAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5086.namprd11.prod.outlook.com (2603:10b6:a03:2d1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:37:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 22:37:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Topic: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Index: AQHadnriF1ZBxh+AQEWxyxeO2jbjmbFC3WOAgACFwQCAAJXAgIAEZVGAgABIQgCAAHUTgIAAAaIA
Date: Mon, 25 Mar 2024 22:37:50 +0000
Message-ID: <709577be23128aa02ae4f664f54b407113c4079f.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
	 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
	 <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
	 <f019df484b2fb636b34f64b1126afa7d2b086c88.camel@intel.com>
	 <bea6cb485ba67f0160c6455c77cf75e5b6f8eaf8.camel@intel.com>
	 <1f463eb3ae517ee8f68986ee4781a29dea3c5a89.camel@intel.com>
	 <BL1PR11MB5978F5ABCD661D22A29F04DFF7362@BL1PR11MB5978.namprd11.prod.outlook.com>
In-Reply-To: <BL1PR11MB5978F5ABCD661D22A29F04DFF7362@BL1PR11MB5978.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5086:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mCmJKjjrymmKUM0h1go70cClK205ccJ4qBbRbIqTpqyzKc5h0CPriTRS/jPUCe/z/WJyA0nGIHbUT6FzNrhFqUYXYzCdo0SsOEwddor1uOwknd8B8Ho615Z4CtaCU5oC6/McHnb7zGgK8BJUlaCMW9DDnYptl8OAg/oYHfAcOsvfcQvBZ0d9HxOzvew8kbDjvcMA0ZBx9Tv9AQaKr6tDFob160HO3RKAmWNtmgCz/RO11g17bFTFCTouIVSgrMiMIZa5ARwrzpPPx/l4qwFEaUwmRQV+kYonfWPpXBbRIWIMen+e7BwHSnLFFhc0QsfRqdBM/H6zpwXpWOcu3S1Dtt7OrIYDne2aZ+JHfRCrNj6BCf+ho3NGnEb6reYQFY9t46Ofbz7vN7x/+QocpzUXRDpG96IiOpAUeiKiORGrW0QlF00pYPaZpGW8BMiNJH3kE/FxGO/+mRO3baxMnsR2ZWmbe/7EVgIIMoVy6cOPQGE4iWUaVdnwPOi+bdUtgMgcSpwm2EC92s6MOB5oKmKq5fK0jfTk4Q+x/eJljOEJI5XRZn/ByporJuLKrYqTXaroXGvEGL3BC/ZEOL9d4+LjtpKnODs8X11Pn/XTlSTtSJHWP2zwWy37shU+WDxZfYBifw/bD1sK2l/7pi6v5OPkFaSygH6kq4pASr69Fc+r2xA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU1ybTk1VTc0Q29qbjBZa2ZiMlNtaXBUaW9KWjJMbnZVMkdXbzI5bkpGcG00?=
 =?utf-8?B?VGZqWEpiSzE3ZWZzTUpwZGxrdDlqRkxwOUhMajZMcDVvdDBqcVB5VEl4ZjQw?=
 =?utf-8?B?M0NSSmkwSzhseVZCWkxvaWlXRWczZ1dwMEt4bllrbGZFbG01ZlVqZlo3Rktn?=
 =?utf-8?B?em50SGZTT2V6WUwwUWM0ODJDNzBOOHV3WEQyYjBERVdSNHVxejlqSnozN3Mx?=
 =?utf-8?B?NkpOWW8wK1ptRjl6cGEzWFNDbVJ0MVZDcG43THJpMEx1aDJuU0EwYjZ0VkE0?=
 =?utf-8?B?d2d1cXcyMHY0RTZzdTBXLytEY2U4L2hFSE9yTUY5bjR3T2xMbDc5dVZtdzdi?=
 =?utf-8?B?aXpKaU1JQVB2YjFvbXVpSkpjQTZHTmhJK1kwMDFIVWp4TVd2b2R3dnlpVytP?=
 =?utf-8?B?aS83Zy81Q05kOWY4RC9jaWRJVnFtYk5ONXBuRE5UYXIxVmZaOEFoRWliK0Z6?=
 =?utf-8?B?eFg1aFNlOWZPYVMyUVQ0OW4xc0FyK25GYWhFSFNWaGtlN2t1R1UvaEV3aFRN?=
 =?utf-8?B?eFNsdlJsVzNZUmNmeEMxYTRqeHVjT1hhMXNWbHAyRytiMXlJSmxGdnNVOG9S?=
 =?utf-8?B?K00rWWxPR1BRZDl5dzhNOCtlQXlqRnVGM0pyYVcyK2IvMXJCTjlUU09LdUZy?=
 =?utf-8?B?SFJMZFNHWndqVzJvSjdRNTF5VS9Oa0w2RTkrNlVwZGxIam4ycGJwTkdVZGNP?=
 =?utf-8?B?Tld6dStSTnhnNks4U1NiWTlsek9EVTl6VHhlOHVqcmlPNjY2RGNBZk9xb2Z0?=
 =?utf-8?B?QXNDWGY5YWIzejVBV2V4bS9NbEZYaGRDamRRRTJ4d0M1bnE5N3BUcTRNNGZl?=
 =?utf-8?B?c2NOWHE5REgvQ2pJcGFvbXNlcWJ6dGJPSnQya09lY0tNNWNON0kycFBCZWF3?=
 =?utf-8?B?WUx0dEZ3eUZoQUkycmtzUit3b2xGZ2Y4TUxPbGhqVXBPYXQ2YkUzOG1RZDYr?=
 =?utf-8?B?K0JXejdXSm1WckwwdVV4aU9OR2lOV3NaUGhhbUVJeGRVNGFWTDhDeWdxb2lO?=
 =?utf-8?B?VmkzZEZFK24yN1VGc29xRnljL0NRMzhKRG5pZWlkYjFmeUNLYkV1NWhVS3JF?=
 =?utf-8?B?V1lNYmEyMGRRLzh4dVV5RmlrRHRaakExUE94Rmx5MHNTS1g5RXo4LzR2QkJG?=
 =?utf-8?B?ZS8vVkMwL1RNZ3RBdWlVNW9tekRtRXZtZEpvbGFYVnB6T1JqVmlSWjVJL01z?=
 =?utf-8?B?RDdGNjFOdmd4Vmdzanh3cFUxMU9yaEZmZ0YvcEZmNS9zWGI2M0tOVkNYd1Bs?=
 =?utf-8?B?MFlSZThCUnVBcWRwVG1MNzJNalJEVGQ5UXRmbGpzdlRlNjJZZ3NZa3RTeE13?=
 =?utf-8?B?aGZZTlY3SkswRHJHS05rTWRFb0VyWThBNDVRYWUrU2Faa08xVXVDTzhHRFND?=
 =?utf-8?B?N0gySkxEbWFkYnBwUnpBTFEvVm03QWNpUDhOaEs0UHpWMnRxeHgxcVRjUll3?=
 =?utf-8?B?U1lGTU9ZSFpMQ0ZwWnVOMmpUUk1WWnFrKzV2Q3hLSkVaYzJqYVY4cm9kbVBL?=
 =?utf-8?B?TDA4OGd2Z3lXdUdGOWpWWVB3LzFiUEVBQzlHakh6bThmZlJtWis4RHZFQk5a?=
 =?utf-8?B?SitTcm9obUZqdGFCZ2t1eitMMXJSUEFkTm1JMzQyTkdnS1kxWXlOTVlnd1JW?=
 =?utf-8?B?VlVzNXR1cnk5azVWckMyRVZyN1UybnhKUHNrdXQrNG1VR3JUU2NQWWw1dE5S?=
 =?utf-8?B?M2J0N1MyZmdLQmhoTVg3eWRmOWtGbHJvRzJ6UE9xMnUyMlFrOFZxV2VrVjBr?=
 =?utf-8?B?QjcxV1V5Tk9oNDc5cTMzV0xkNmNtYjJtd0Voc01wNm10NmFiTnB6UmptUjA1?=
 =?utf-8?B?c3pzOEpzQm1wTGRVdFc4TW5GZzIzWUJIRVdRNmRIR3RTbTd4WU5MVjFYOUk5?=
 =?utf-8?B?OTVSRm9UNVIrZ3JsU1BXQVE1NUp6S2x6cFBtdE5GNVBMem5pbE5RN3dJS3Bk?=
 =?utf-8?B?WDZqTnFZZTl5UUtwb09zR2xXbi9MZVpkWmp0dGMrUkQwbWQ5cXBva3JGdzJz?=
 =?utf-8?B?ai8rSk54a0NwcGkvRldiSXVwSUUrN0hhVVhJdUlQb1pGWSt4VXk3TmxQR2hM?=
 =?utf-8?B?SS8xaU5MOGF5TEtwbDZxNWhBbkJNMUE3UFk2Sm02M1RDd2d3b0dWNEMzRFZT?=
 =?utf-8?B?UDd5VlBram5JWDVKd2d5cVNkL1p6VzJGYVZXQzJWdTlIeGF0MTNmdHVkZFRE?=
 =?utf-8?Q?dGrCFeLvwAo6//93uGr3udY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FA170709AAF104BB773D943A55113EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c6b738-df20-4b28-1ef2-08dc4d1c3414
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 22:37:50.7868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3VSPSCMBxMRj2C/Qukqq+VMRykIXUqN9sb7vsZQnASDPLeVSi1b48CKjEROXrXOFPwJoBmpvsQzIrGFK9/HEweKK9kgCGlwbutotc7WB+sY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5086
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAzLTI1IGF0IDIyOjMxICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAo
c29ycnkgcmVwbHlpbmcgZnJvbSBvdXRsb29rIGR1ZSB0byBzb21lIGlzc3VlIHRvIG15IGxpbnV4
IGJveCBlbnZpcm9ubWVudCkNCj4gDQo+IEl0IGJvb3RlZCBiZWNhdXNlIFFlbXUgZG9lcyBzYW5l
IHRoaW5nLCBpLmUuLCBpdCBhbHdheXMgcGFzc2VzIHRoZSBjb3JyZWN0IENQVUlEcyBpbg0KPiBL
Vk1fU0VUX0NQVUlEMi4NCj4gDQo+IFBlci1TZWFuJ3MgY29tbWVudHMsIEtWTSBzaG91bGQgZ3Vh
cmFudGVlIHRoZSBjb25zaXN0ZW5jeSBiZXR3ZWVuIENQVUlEcyBkb25lIGluIFRESC5NTkcuSU5J
VCBhbmQNCj4gS1ZNX1NFVF9DUFVJRDIsIG90aGVyd2lzZSBpZiBRZW11IHBhc3NlcyBpbi1jb25z
aXN0ZW50IENQVUlEcyBLVk0gY2FuIGVhc2lseSBmYWlsIHRvIHdvcmsgd2l0aCBURC4NCj4gDQo+
IFRvIGd1YXJhbnRlZSB0aGUgY29uc2lzdGVuY3ksIEtWTSBjb3VsZCBkbyB0d28gb3B0aW9ucyBh
cyB3ZSBkaXNjdXNzZWQ6DQo+IA0KPiAxKSByZWplY3QgS1ZNX1NFVF9DUFVJRDIgY29tcGxldGVs
eS4NCj4gMikgU3RpbGwgYWxsb3cgS1ZNX1NFVF9DUFVJRDIgYnV0IG1hbnVhbGx5IGNoZWNrIHRo
ZSBDUFVJRCBjb25zaXN0ZW5jeSBiZXR3ZWVuIHRoZSBvbmUgZG9uZSBpbg0KPiBUREguTU5HLklO
SVQgYW5kIHRoZSBvbmUgcGFzc2VkIGluIEtWTV9TRVRfQ1BVSUQyLg0KPiANCj4gMSkgY2FuIG9i
dmlvdXNseSBndWFyYW50ZWUgY29uc2lzdGVuY3kuwqAgQnV0IEtWTSBtYWludGFpbnMgQ1BVSURz
IGluICd2Y3B1Jywgc28gdG8gbWFrZSB0aGUNCj4gZXhpc3RpbmcgS1ZNIGNvZGUgY29udGludWUg
dG8gd29yaywgd2UgbmVlZCB0byBtYW51YWxseSBzZXQgJ3ZjcHUtPmNwdWlkJyB0byB0aGUgb25l
IHRoYXQgaXMgZG9uZQ0KPiBpbiBUREguTU5HLklOSVQuIA0KPiANCj4gMikgeW91IG5lZWQgdG8g
Y2hlY2sgdGhlIGNvbnNpc3RlbmN5IGFuZCByZWplY3QgS1ZNX1NFVF9DUFVJRDIgaWYgaW4tY29u
c2lzdGVuY3kgZm91bmQuwqAgQnV0IG90aGVyDQo+IHRoYW4gdGhhdCwgS1ZNIGRvZXNuJ3QgbmVl
ZCB0byBhbnl0aGluZyBtb3JlIGJlY2F1c2UgaWYgd2UgYWxsb3cgS1ZNX1NFVF9DUFVJRDIsIHRo
ZSAndmNwdScgd2lsbA0KPiBoYXZlIGl0cyBvd24gQ1BVSURzIHBvcHVsYXRlZCBhbnl3YXkuDQoN
CkFoLCB0aGFua3MgZm9yIGV4cGxhaW5pbmcuIFNvIDEgaXMgbm90IHRoYXQgc2ltcGxlLCBpdCBp
cyBhIG1heWJlIHNsaWdodGx5IHNtYWxsZXIgc2VwYXJhdGUNCnNvbHV0aW9uLiBOb3cgSSBzZWUg
d2h5IHRoZSBkaXNjdXNzaW9uIHdhcyB0byBqdXN0IGRvIHRoZSBjb25zaXN0ZW5jeSBjaGVja2lu
ZyB1cCBmcm9udC4NCg==

