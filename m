Return-Path: <kvm+bounces-47966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 022A4AC7D44
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:38:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3604CA24DDD
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 11:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB65928EA42;
	Thu, 29 May 2025 11:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aQX7wlwz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5DB2749F3;
	Thu, 29 May 2025 11:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518709; cv=fail; b=IihrIfPmNUOG3zL+DTISsmUeiPZvOo9bMlfQn6RLU6Imx7nyKNXMsyGRi2HWKx4INvDliW/7/XlqTI1JB40Nr6O0SE5aWasJR+O5Z2NtEhbKk+yGeK3ffMT/WIWlxLLLjaTrCoZiuU6aKJlSM/4+WM4MQHgoX5Q+9n5mwqQi/LQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518709; c=relaxed/simple;
	bh=ITjNDHFV8wJ9RFbXAioV6ZIaxpNcfEhBpl7oNGcX9lY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W0vfxWV3ReRDxGykVbPCOxNXM4iKNAsTHmQf89SBRC4UTy4KHXydu/6QoXTLMJROdDim9YX1dF48c5SsIJm9eCgm8H57rbEJpsYJNf5hrajkkv41NzXCDnyFvw7+tUPBEqETbWyaXbwQo8GvY6RQTs3LJDKK2Du+dlWEBIIV6K8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aQX7wlwz; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748518706; x=1780054706;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ITjNDHFV8wJ9RFbXAioV6ZIaxpNcfEhBpl7oNGcX9lY=;
  b=aQX7wlwzmbn8jHb8XUVcVw3OrplgDdA+s+sLnORhQR2WEVa8AQf32HEa
   v24SM6zP17eEpc2jI1vTjs0IkNcGjQUNw5KfnU5m2ZfIa/ZXdciVcGaWp
   8uVV8zChJwlgIjRJ2wnqG/fH7Auj7BKVZBaM7JLofwFzU7ohQT48whDFz
   gut1bW1WuHfb2lu+a1qcPiqGsQkwLUqBqWFYKmlSRORb5Cem9rEf0lqmg
   QvUt+h5RBcBghv8JaMsjqO7U22xtkh3MuuaHyw569oOn8OWvJHxM2qHHX
   p8B2Te0BMi2cbkJCCj43+KIH5fWmaN16vaIP27EdFSUA/FJUVS9JBnKia
   w==;
X-CSE-ConnectionGUID: b35HwAXxQDuRqC8VEAJZqA==
X-CSE-MsgGUID: ZaH1cwgvRz68phg/4PwiIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="54379635"
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="54379635"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:38:26 -0700
X-CSE-ConnectionGUID: y91v5TZJQ7WcNK2RxD9RiQ==
X-CSE-MsgGUID: kZY1CkLxQ/i1PSlo2Uryxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="143568401"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:38:26 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 04:38:25 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 04:38:25 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.54)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 04:38:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gxqt9TXvTobCvCgWPoMHd2wQ6ro0cf53p+pMdRT6IhfxUq95kx6+DuMLlc2uDbuMUW1i1ntI9QTLD+SmAVkVHk4jVUbfbNPH5MLdQJVJ/iGwd2j5Ia1bebx0siAmN14y8UJrAXZ/3oi9YR2u2IrgFisA5aas519/ZVLIugllLmy2mjGTszwYFyoNvUoDzVyJcqOA3dqXX7upIz6wSFa/W9KU7gLrgvcmElhqm1F60Pcd6iqKu1L/anvS3kL7ISHwQHtej+RXaMrJBrlpvjLFLMO5RFVSOi7HTsJ93FVYQqyTTEYq1/4IX3LfgCDVgLRenCa1wNDISzWgRqwVDJDEwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ITjNDHFV8wJ9RFbXAioV6ZIaxpNcfEhBpl7oNGcX9lY=;
 b=x2vaSz+zMCrpGQN1H7hPjX4z5Zc5VIqdS4d+1sm7+9LinuX7lVESYIGw9bYcXFgewV3RuT+cwf89fwbT/ftJl1P+rt2YjpKwacSs9Hv9hoHAyHY76cHKS/w+54DW2wCpofX8SX+PwN0IMa3yxJQX1VRWO8TWHJsgD8MTx2NaULFBZBUZggS/RmAYAHcFSBhXEZeLjSLdUWVu7ibCQMS7PO1CGC8MECDk1gbk7QOEepVO0JJxSs7zSLIxjlURQIBkNaZcxeCn/gvHXZ0fUZzpehQCj5M42/bRQHJWRfqS0PtmofNR7FuiO2X2g2lpDOdgFhXsiNXz6MiBLQ+JEoIYlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB6538.namprd11.prod.outlook.com (2603:10b6:208:3a2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 29 May
 2025 11:37:50 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.029; Thu, 29 May 2025
 11:37:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/15] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
Thread-Topic: [PATCH 04/15] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
Thread-Index: AQHbyRXr46ysaQvN7Eq9mIGEm2qtCLPpigeA
Date: Thu, 29 May 2025 11:37:50 +0000
Message-ID: <100ec82b37b7ce523a12b81623613b71e72c8ba0.camel@intel.com>
References: <20250519232808.2745331-1-seanjc@google.com>
	 <20250519232808.2745331-5-seanjc@google.com>
In-Reply-To: <20250519232808.2745331-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB6538:EE_
x-ms-office365-filtering-correlation-id: 1c495ab0-41e6-491e-cb17-08dd9ea53e25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OCtxVFgzV3p1dVVlTExNTFRTK2VlbkxkdWcxZSs1S0lqSndCbDRtWWtrclFO?=
 =?utf-8?B?cXVJd3MrZ3lEU2F5R1ltc2RhdXAzQm9lcVBiVjNDME1sa2RJaVloaWI3bVlh?=
 =?utf-8?B?MGRpb3lNR0FBQzQrMkkzLzVuVjJwcVhnZkJDRnRLblpHTjdvUDhzVUJuUGZF?=
 =?utf-8?B?VksyYzNueWJoMXBldUdLU09vbVJjSzlDZ0hvR0kwYzZLVFkwS0t1QzhkQTN5?=
 =?utf-8?B?MWxhbEQ1N2NmZGFLbGM0WFNKOTV5NWJqQWhqV3h0MmxvU1RsMzN1bkwrWTd2?=
 =?utf-8?B?QUd1QzF6dWRDM2o1L1VzRS9MYzJZc2FQOG16cE1Yd01YOTM2Sks1ZmlvaVFD?=
 =?utf-8?B?MXd6ck84V1hRUTd0dmEzN3ZzYzB2M2J3RTJRaEZLQ2JMaDFSU3A3V2NKZWpW?=
 =?utf-8?B?bGFjV0I3MFRuaHpSUGswRTlNYi9LRzR5Rmp2K1diTlhoY2NtMk1zK1R3WlRI?=
 =?utf-8?B?SzlaMHBsb2ZteFFKWU1CRlVXSC9EV0NHWElhQlV4VnBVczhzQWgwZnFWc1RU?=
 =?utf-8?B?UFdMWGFxRG1TS24zdXpDOEFmN2g3azJRUEdDL1dETHFWNGF5VXVVdFdESmpv?=
 =?utf-8?B?dDYvR3FqVlRCZEZTV3ZDQlN3NytIbDBUUUZ6ZWhOZlJNTWtDTTBtc01FRGtK?=
 =?utf-8?B?RnVNbElqYmQ2cG5NYUN0RThvakxqalJRaVdDWGxOTU5FMkpHR2U0NDl3eER0?=
 =?utf-8?B?b3pHV21XWXprU3dmZHZSUENteFNsRHRhanRRQlg2Vi9EbUhvbVJkSzg5Y0JQ?=
 =?utf-8?B?SDVqSkk5d1NrTHJ3OU85WWpudEp0eHZaZVpRdGRDQ1VjWWMvT21ub2FodVhI?=
 =?utf-8?B?eHFQZkpuT3Mwa0N4dmlMRGlFTHlQL2dwNjBKWWJ0VzY2Sk9vZTY3SFhXMXBr?=
 =?utf-8?B?VEg5NFBkUm1qSFowbGdlZlRXUXpJcmJBejVzQW8yRlE4UzZVejgxNmkwQkRz?=
 =?utf-8?B?enc0MGpKeUxRNHBQZnkrakZJRWVhY05QVWRGcVZncGgxOHR2ZXhZNXptSHoy?=
 =?utf-8?B?UEFBZnpob0VINXdrdGlnUVpxUzR3ekozUUFNeWpBR05YNnNpWjlVYU1IVSt2?=
 =?utf-8?B?Yzd3WHRCU09QbTMwOG8ya0xCa3RmbHVEWk92N3pJL05NM3NyR1RiU0VnekNQ?=
 =?utf-8?B?TEJSYWJ3K2Y5K29acE41bmFGUEczZk9vK1NyenA2Yk81ZjNqdjBkR2pReHZQ?=
 =?utf-8?B?Qm1vM2V1ZTBaRmFjUUpLSldudnRrajdaZnNnQWtibjRhWjJMMlpuRlpUdkNT?=
 =?utf-8?B?djRZSTdSYzc0QXozWVZJY2ZUcTlBRFlXMG9yV01WSlByYWJMMWxlU3VLeG5i?=
 =?utf-8?B?c3FOSTcxS0kxaTVBTVA4VXNqS0JiRzhSbjFOQmRZS0dueS9aMWtXOEZIUldD?=
 =?utf-8?B?YzlkNnZMZDZ6ekt4YTE4WkxDVFZ1LytISXdMUG5ocExLS2VHTWNVd2RaV29a?=
 =?utf-8?B?a1BJalVmUnRwOXFzeFMrWDJPeFBqWTJOZlh4d0haOW5uVG5MTGtjaG5vaDlx?=
 =?utf-8?B?aVBNNDVYaVMxMDR0SVdreXZrcThveFZXT1FKTGdDdHZxUmNQK3lLekFNS1l0?=
 =?utf-8?B?ZFlpU0ZVSFprZGdlcTBhajNKVTQ4ZjJqL1ZNeUxPNmxORUlETVBFMEVuWmFB?=
 =?utf-8?B?SnpZcXdFSVpoNVpybnpXbW9mNGM3Mm9jeHZ2Nlkra2lVSSs3bi95SUpTYVZZ?=
 =?utf-8?B?NGIvblBLZThrL2hLeFhLemdJRkJVczI0K1lLZ09DQzZ5cVFWQVBOK0VZT0NK?=
 =?utf-8?B?Q0IrK2tUUkFDb1dTMUEvVW8rT1lmVFUyeEhXaDB4dGJ5V01xYXJFUGZRdzEx?=
 =?utf-8?B?eWY2bldjaEVIWXZkMFE5TEZQcU1hRWlFOCthTTJIc0Z1dFQ1anF0VW54bHN3?=
 =?utf-8?B?VlhGRUp0QXhMc1REN2NPUXR4R094c3NVYlZmVmVVWk00b3A0R28wa3UwbDhv?=
 =?utf-8?B?K3M1VFhRbkYwVkZUK1NLd0VoazJ3N3M5RUpVTlFGWFNxdXB1ekRoZDlCeGtH?=
 =?utf-8?Q?g/54oUbWXYsm5HNuA53T6+y91o+YmI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWM5Y1lwQzFJd2lPOTlJRDlpT2Q4eUpMK0FnblV2TGwveEdGSVF5SmJhMCtH?=
 =?utf-8?B?alVZWHNTOGdJOWthYXpFUDIxWVdBaFhSOUJiWlRheTBKcldWSG94QzZoN091?=
 =?utf-8?B?SjFRdngrTnI3MWlDam9TemZCWm5HU2hwT0p5OUxJdW9jaXhZL1pNQWxFM0tn?=
 =?utf-8?B?OWFPN1ZSOWwxdHRITmsxVzFmK0xJSGRKWENKcGJLeTBrNHgrY3BBWWVZaHBi?=
 =?utf-8?B?MmdLaEd3eE9rdG9pUGYwa2FuSE1QbHYwWmxnSGVxRWFZVVdUcVVGZFkvVUtZ?=
 =?utf-8?B?NUpCaUlDakdjNGl0ZlJWcUNIT3duOGw2QzAyanYzclVDYmZaeHcvR0k0U1VU?=
 =?utf-8?B?eEl0L21ob1ZidXU5UVZqamRTc0JoOHlrQko1TEJUSndydFI0UVhyTGIxMVNw?=
 =?utf-8?B?NW8vU0UvSzJGSGZldlZsMlpmZ0poelBjdW10VStyRUg3QTR0SXQrV2l6dEdx?=
 =?utf-8?B?U0V1MURhbHdiZHpESjFmT0ZoUlJQbFBCTVljYVFuNDQwK2ZseEsxY0JpbFdW?=
 =?utf-8?B?MkNPUU5xbUx1L0o3U2QxVENJUFcxYzZXbDZabFhaNytvbGMwOE53S0JHMEgz?=
 =?utf-8?B?SWF4ajk3c1NFN29TZzZKREwvSnJ3SXBVVGlvSWlFUUZhbksrbGpvVi9rS3Vw?=
 =?utf-8?B?cW01UGFoRnQ5MVQ1ZzhReEcvbjNVOGxYMjBkVU1NRFlJc0lyR3h0eWJwYUg4?=
 =?utf-8?B?QiswN3JWMW9MVlA5K08vZ0VBbS9yWVZoUXhKWEpIZDVlSWxVQVJzdUIxN3JI?=
 =?utf-8?B?TzdJZmc2WldlYzB4OW5LZm5odkgzOFByRnVPTUVkand4allWQ2JSMmlRSndX?=
 =?utf-8?B?dW9yMHJsK2RpM0Eyc2hHRkZMOHZldkhxR0VqZXRXVHdkMXNIS211T0lLdEpT?=
 =?utf-8?B?VXpGd1l1RFIwWEFVRzJML2FQZzlPMUk5UlRNQzZkNEc0T0N2S3NqR3VwaWd5?=
 =?utf-8?B?ZjdVOGxNVVRBa3pNYTgvVHc1c1p1b1lGbXBBdDRMVHUwVVdxRmVZTTVRVWdY?=
 =?utf-8?B?enVYZEU1Z0JwNTlNbDNHSndMaThJRHFlN3N3T29XcnU3K1VvbmxWZVJ0SGc4?=
 =?utf-8?B?K2JDbnNzcHZnaVl0WVNJdmUyRmxPSVJRV2lYMHZQVm9WcTg5SVRtckFaMEt5?=
 =?utf-8?B?c3ZQRTFaUFM2blFRQjJCemRlQWdWVXRLdSsvanowV21yZS9jWGlwSElma25G?=
 =?utf-8?B?dHBRS1VXRyt1WlVCKzVxWmF4ZnA5ZjBiRm1BUWQ0U3BDZmJpb0cyaTVyNUtj?=
 =?utf-8?B?NjU0ZU9heDBYcnpTTEh6bnRxdnVTbTdOSUtBQzhTeEt3ZmZnVXdJRnh3aGNi?=
 =?utf-8?B?Zm1XNjROMmRYdzkrNlhzb1VUQi8zd2RHc1FOTTFzb1ZkTmxLOTNXSWQzTGFq?=
 =?utf-8?B?TnZLZWExRERuZm9qbDJhU0tQcFBEZjViUVdrNjd1VTE2d29UNjJ3REhmTml3?=
 =?utf-8?B?eXVZcGFUWG5XRXlqU2o5SzlTbVFYdkFLc2tndGY4V3NHaU1zQi9EQ2NmdERE?=
 =?utf-8?B?dnIyY3hZcHVTSFhmNzlhTE9Tc1hpbGFmM1cvMTk4ejZVY0dXbFpUdUNuZ3Fp?=
 =?utf-8?B?eTRTVGEzZ25JNUwvL2JCY0Jwc1I1aWpmY2VjaGJHNXZlYmVBa0ZCUGY0dEEz?=
 =?utf-8?B?azNQQ1VDTnp5OW9xTE9UYWovU0trTDVUTEs4SS9lZXdRQThnTzdwRGRJRlQy?=
 =?utf-8?B?Q0JBNUM2QTd1N0wzQzF3RHR3bUVJZ0FOc3kzR01ZdnVnY2dNZXZZZ3MyY0Fv?=
 =?utf-8?B?eVc5ZUU1WXlkTGFuak8vV21PeFI0UmJxbUU5OHcyOUtwZHk1aG1DNS9VMzFj?=
 =?utf-8?B?RmwrNXdiUW5UalppWkFJb2tGbm9SajVQUHAwWS9DZldTZXdVWk8yb1NXMGxj?=
 =?utf-8?B?OW1nQjZwa0liNHEvOEU4eTRhOFpUemFWNXV3TTlEd1RaaWpqRDdKWDVHK1pD?=
 =?utf-8?B?blVqZTZRY0xLVm82Um1rRElnVGdxVU1XUG9qdjJvbWpjVmxOd0hIYXBOanVx?=
 =?utf-8?B?WWVUZHFka0hxYVZ5N3BIb3FuVkVFQUthblBzTHJtNm9NNjZhREdoNldnUDBM?=
 =?utf-8?B?Ukt0SlhwcUNXZVpTN090QzRyRVVYU2V1RlFQNlUxeENERnRGMmlwZmZvRkZu?=
 =?utf-8?Q?FNyPdNvJpKVjwROvr4N4vF2Uo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47C1B2619C1AE3469138ECD06D4E68F2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c495ab0-41e6-491e-cb17-08dd9ea53e25
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 11:37:50.5899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zkbyQO8eDnD0zr1caAEyoanoKYj2Z+O0GOjw70+fIE3Opc8+MngOyhpkYjyw5VnGZw9KMNGQHDNrtG8Eq+WhDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6538
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDE2OjI3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEcm9wIHRoZSBzdXBlcmZsdW91cyBrdm1faHZfc2V0X3NpbnQoKSBhbmQgaW5zdGVh
ZCB3aXJlIHVwIC0+c2V0KCkgZGlyZWN0bHkNCj4gdG8gaXRzIGZpbmFsIGRlc3RpbmF0aW9uLg0K
DQprdm1faHZfc2V0X3NpbnQoKSBpcyBzdGlsbCB0aGVyZSBhZnRlciB0aGlzIHBhdGNoLiAgRGlk
IHlvdSBtZWFuICJzdXBlcmZsdW91cw0Ka3ZtX2h2X3N5bmljX3NldF9pcnEoKSI/IDotKQ0KDQo+
IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gIGFyY2gv
eDg2L2t2bS9oeXBlcnYuYyAgIHwgMTAgKysrKysrKy0tLQ0KPiAgYXJjaC94ODYva3ZtL2h5cGVy
di5oICAgfCAgMyArKy0NCj4gIGFyY2gveDg2L2t2bS9pcnFfY29tbS5jIHwgMTIgLS0tLS0tLS0t
LS0tDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2h5cGVydi5jIGIvYXJjaC94ODYva3Zt
L2h5cGVydi5jDQo+IGluZGV4IDI0ZjAzMThjNTBkNy4uN2Y1NjU2MzZlZGRlIDEwMDY0NA0KPiAt
LS0gYS9hcmNoL3g4Ni9rdm0vaHlwZXJ2LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL2h5cGVydi5j
DQo+IEBAIC00OTcsMTUgKzQ5NywxOSBAQCBzdGF0aWMgaW50IHN5bmljX3NldF9pcnEoc3RydWN0
IGt2bV92Y3B1X2h2X3N5bmljICpzeW5pYywgdTMyIHNpbnQpDQo+ICAJcmV0dXJuIHJldDsNCj4g
IH0NCj4gIA0KPiAtaW50IGt2bV9odl9zeW5pY19zZXRfaXJxKHN0cnVjdCBrdm0gKmt2bSwgdTMy
IHZwaWR4LCB1MzIgc2ludCkNCj4gK2ludCBrdm1faHZfc2V0X3NpbnQoc3RydWN0IGt2bV9rZXJu
ZWxfaXJxX3JvdXRpbmdfZW50cnkgKmUsIHN0cnVjdCBrdm0gKmt2bSwNCj4gKwkJICAgIGludCBp
cnFfc291cmNlX2lkLCBpbnQgbGV2ZWwsIGJvb2wgbGluZV9zdGF0dXMpDQo+ICB7DQo+ICAJc3Ry
dWN0IGt2bV92Y3B1X2h2X3N5bmljICpzeW5pYzsNCj4gIA0KPiAtCXN5bmljID0gc3luaWNfZ2V0
KGt2bSwgdnBpZHgpOw0KPiArCWlmICghbGV2ZWwpDQo+ICsJCXJldHVybiAtMTsNCj4gKw0KPiAr
CXN5bmljID0gc3luaWNfZ2V0KGt2bSwgZS0+aHZfc2ludC52Y3B1KTsNCj4gIAlpZiAoIXN5bmlj
KQ0KPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gIA0KPiAtCXJldHVybiBzeW5pY19zZXRfaXJxKHN5
bmljLCBzaW50KTsNCj4gKwlyZXR1cm4gc3luaWNfc2V0X2lycShzeW5pYywgZS0+aHZfc2ludC5z
aW50KTsNCj4gIH0NCj4gIA0KPiAgdm9pZCBrdm1faHZfc3luaWNfc2VuZF9lb2koc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBpbnQgdmVjdG9yKQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL2h5
cGVydi5oIGIvYXJjaC94ODYva3ZtL2h5cGVydi5oDQo+IGluZGV4IDkxM2JmYzk2OTU5Yy4uNGFk
NWEwNzQ5NzM5IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vaHlwZXJ2LmgNCj4gKysrIGIv
YXJjaC94ODYva3ZtL2h5cGVydi5oDQo+IEBAIC0xMDMsNyArMTAzLDggQEAgc3RhdGljIGlubGlu
ZSBib29sIGt2bV9odl9oeXBlcmNhbGxfZW5hYmxlZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+
ICBpbnQga3ZtX2h2X2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOw0KPiAgDQo+ICB2
b2lkIGt2bV9odl9pcnFfcm91dGluZ191cGRhdGUoc3RydWN0IGt2bSAqa3ZtKTsNCj4gLWludCBr
dm1faHZfc3luaWNfc2V0X2lycShzdHJ1Y3Qga3ZtICprdm0sIHUzMiB2Y3B1X2lkLCB1MzIgc2lu
dCk7DQo+ICtpbnQga3ZtX2h2X3NldF9zaW50KHN0cnVjdCBrdm1fa2VybmVsX2lycV9yb3V0aW5n
X2VudHJ5ICplLCBzdHJ1Y3Qga3ZtICprdm0sDQo+ICsJCSAgICBpbnQgaXJxX3NvdXJjZV9pZCwg
aW50IGxldmVsLCBib29sIGxpbmVfc3RhdHVzKTsNCj4gIHZvaWQga3ZtX2h2X3N5bmljX3NlbmRf
ZW9pKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgaW50IHZlY3Rvcik7DQo+ICBpbnQga3ZtX2h2X2Fj
dGl2YXRlX3N5bmljKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgYm9vbCBkb250X3plcm9fc3luaWNf
cGFnZXMpOw0KPiAgDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vaXJxX2NvbW0uYyBiL2Fy
Y2gveDg2L2t2bS9pcnFfY29tbS5jDQo+IGluZGV4IDhkY2I2YTU1NTkwMi4uYjg1ZTRiZTJkZGZm
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vaXJxX2NvbW0uYw0KPiArKysgYi9hcmNoL3g4
Ni9rdm0vaXJxX2NvbW0uYw0KPiBAQCAtMTI3LDE4ICsxMjcsNiBAQCBpbnQga3ZtX3NldF9tc2ko
c3RydWN0IGt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50cnkgKmUsDQo+ICAJcmV0dXJuIGt2bV9p
cnFfZGVsaXZlcnlfdG9fYXBpYyhrdm0sIE5VTEwsICZpcnEsIE5VTEwpOw0KPiAgfQ0KPiAgDQo+
IC0jaWZkZWYgQ09ORklHX0tWTV9IWVBFUlYNCj4gLXN0YXRpYyBpbnQga3ZtX2h2X3NldF9zaW50
KHN0cnVjdCBrdm1fa2VybmVsX2lycV9yb3V0aW5nX2VudHJ5ICplLA0KPiAtCQkgICAgc3RydWN0
IGt2bSAqa3ZtLCBpbnQgaXJxX3NvdXJjZV9pZCwgaW50IGxldmVsLA0KPiAtCQkgICAgYm9vbCBs
aW5lX3N0YXR1cykNCj4gLXsNCj4gLQlpZiAoIWxldmVsKQ0KPiAtCQlyZXR1cm4gLTE7DQo+IC0N
Cj4gLQlyZXR1cm4ga3ZtX2h2X3N5bmljX3NldF9pcnEoa3ZtLCBlLT5odl9zaW50LnZjcHUsIGUt
Pmh2X3NpbnQuc2ludCk7DQo+IC19DQo+IC0jZW5kaWYNCj4gLQ0KPiAgaW50IGt2bV9hcmNoX3Nl
dF9pcnFfaW5hdG9taWMoc3RydWN0IGt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50cnkgKmUsDQo+
ICAJCQkgICAgICBzdHJ1Y3Qga3ZtICprdm0sIGludCBpcnFfc291cmNlX2lkLCBpbnQgbGV2ZWws
DQo+ICAJCQkgICAgICBib29sIGxpbmVfc3RhdHVzKQ0K

