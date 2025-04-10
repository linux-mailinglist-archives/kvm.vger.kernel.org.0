Return-Path: <kvm+bounces-43056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F38A83A90
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D7593B213F
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9ABD20AF99;
	Thu, 10 Apr 2025 07:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nTngYPHO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073FC204F80;
	Thu, 10 Apr 2025 07:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269143; cv=fail; b=hhoG0pxrzkHFXmZqj0C5hptZndCtiAIsgHab9SSMhJd7TOxk+S2Es8s0dSe12NHv9JixCP0/AMD7L1eEL2Cj5Z4QbIhO6eP3lqMf+/wsrJ9etnqIUes1zZ4r8GildwZHcCi6qZkNjo1beHy+lCl0JjpxXtgnq8byfsxUL7Odwf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269143; c=relaxed/simple;
	bh=Rf/boW7BujMnl/a84OvH0nA/PZXLtY7Vw3qiRmC5aYc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AXqvCZ3LzvS3g5Eum9luvlkFljpYpTnffNh1H7r97P4eBF9chJ8mmwvwIzv+XhIqA/sP5qf687h9zaQ15P9kNe788RVuwi/pwYoi3xHqU6eCcGWDyJ/3CwueUanS4gNoc7Hd/eA7nBBMvAD8F032OIy/CZecyijmigl6z72pYbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nTngYPHO; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269142; x=1775805142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Rf/boW7BujMnl/a84OvH0nA/PZXLtY7Vw3qiRmC5aYc=;
  b=nTngYPHOj3YFDXeNnOLSerg9740wMWzW5u1f9Mpphig54VXaiFV3vmCF
   eCGjH5ac2Px2GxsLMjVK0V1aSqIoUMUTPFKc2IlRhzLS41eFLjuWGOxdH
   qm1X70Vl/SwvfXL+K9UXFTf4/45W1rRkQ19y4uBA9r+gZ+/yqM77yfLN7
   FZsdGfozJtjvJMX+4SETB3aKdtDFckycWEP0pzgFFk2dxKwmpZ5Gdy4Va
   XXDFXkAXssJlGDtVnO+yQUWAKHcNsZNUeIr5aNkiJ10XPUzPPAjhoD13s
   a1S7DZEDMqEYZMi/X+muSPc1lE9ZbQIrjqLTq+7wZv7F33mOfNq8mMz7o
   g==;
X-CSE-ConnectionGUID: /Jl9JTDJQqiXLkrXdY4Q5w==
X-CSE-MsgGUID: mfqWjqu/QF+qqI2WzxCaiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="45864813"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="45864813"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:12:21 -0700
X-CSE-ConnectionGUID: jyP8jy2oSNSkBTLLhuLWqg==
X-CSE-MsgGUID: Ams2IR6VQTWvWV003ZAARw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="134007723"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:12:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 00:12:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 00:12:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 00:12:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccev6eDSebRfY4mHajQMmMaSsKjjFR3q7czQ7AMJbMGutWb4DvDXrrDKGgCTo2pNRmHKQVnGNm2w/XOf18A7eKYpDViZBBenVuUYIZq0ILpklEqxbh2iqJTYRiEwmv5/2y1sVMVRcQm1WWf1p5C803c2Hw/Sj9KOSYjTlRW/ytxbslDrWsoo5XDx6sx2+ir5B6DGoG2l5FhFMsmOQAdXaZtmyOBZmihZtc+r0vTwclji2PLWFNvW58j9yLjqyMxFZkR2vDjOo3Hst1xzW8Eo5ndUyZZspQazOND1ijb35s4XdzQ6tIqeKYieoOwO3CxHyfYmvGhSO59lh/BpWlgJtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rf/boW7BujMnl/a84OvH0nA/PZXLtY7Vw3qiRmC5aYc=;
 b=I/sZMLihykz0ZGo+4/pO74B0fQ4dEInLHETwsFbQd4r06UklGyLaMhHSVRLManTCM07adryvBb5Kt7BtvSakczkBnyf7MZ4X6ueR73z1H1Z0q3mli/KwD6Us1E33BgWowFDpD5fhcwbJAfLIg9q5JDUqa6fGdEJJ6PKcqtMJxLaUnLHLWGO1pVC2NiCZpjWZLB2FEIhoN6HxTzCADOaS7ulC+5Ofacay/JtdFdyF2EUQIwVD6FwdyQAJj7IWoTdC+VIeV2I8KCDGEn5ZUfIM1m+0bPfskmZEYc2lUiO4fpbJVBwQoNQyzql8VJ96r4oeu3rFP/Fp+pN355uOpf+P2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM4PR11MB8159.namprd11.prod.outlook.com (2603:10b6:8:17d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.22; Thu, 10 Apr
 2025 07:12:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 07:12:17 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: RE: [PATCH 1/7] irqbypass: Drop pointless and misleading THIS_MODULE
 get/put
Thread-Topic: [PATCH 1/7] irqbypass: Drop pointless and misleading THIS_MODULE
 get/put
Thread-Index: AQHbpaa7i9NEBE8TQkOm4nLW9DD0lbOchEmQ
Date: Thu, 10 Apr 2025 07:12:17 +0000
Message-ID: <BN9PR11MB52768809C6ABA6EE31A283FE8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-2-seanjc@google.com>
In-Reply-To: <20250404211449.1443336-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DM4PR11MB8159:EE_
x-ms-office365-filtering-correlation-id: 26c94683-ae35-4492-801f-08dd77ff06f8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?c3haMmZoZFRHWDBpSVZ2Yk1XSkR6L2d2KzZTS1pjZzIwbW5WWWRPUVJnak9w?=
 =?utf-8?B?a3RvYU9SUTBveEIvTERabytDcG5uc0d5cmtYbW53bTZ4RFVVVVZxZlRIWTVI?=
 =?utf-8?B?V21jcHJyU3JWRytNZnJ0L0VBQ3JsSEY5d3pZbmxIcUhyNDhXbjhBdklsVTJ4?=
 =?utf-8?B?Z293ZjRvQWNRaE5WYVpHWUZRNy8zbmgyYStNWGNCdk4vYTRtbVJYQTU0Q2FW?=
 =?utf-8?B?eitJZHJadDY4Z2lJaExrUDMxK2lpZ2xZTlZsZk9nZ2FRcnlmeHlrTzBLU1JF?=
 =?utf-8?B?Um5BcUxmbmVtRDZBMmhHeUx2Yy9aSVBPeGlZOWlWV0ZUbTN1Mk5Da0IzQytE?=
 =?utf-8?B?QlZjdFVqYW1rSlYzQlY5MXFiSml0enpHQVliZVVyUHdZL055NWdZVDYvT3Rz?=
 =?utf-8?B?Z0dzZmJJbllZVTZGQTZmSWlOMTV1TEZxbTdybUh1L1p2TlpiV1JIaGdJZXNm?=
 =?utf-8?B?KzhYcHpHN1JRUmd5c0RSTWY1S2xkQVJ3SS9oQ3MrWEducktwZTNTTndiL3VX?=
 =?utf-8?B?cEtTcWt4SzB6Q2FOeDRPYnMwMmZoaGFpWW1OYStuK1dHNUIwU2x5eExUQXJh?=
 =?utf-8?B?aUZQSXdMTmhlQ2JCenlkd3Y0OXZrRlN3cGRYZDdCU1hkN0lUZzVuOTZLWjJu?=
 =?utf-8?B?OWRIZzVCd2ZnOXNJakFSSTJ1dy9aSllkSnJUNkRIa1NCOVlObVd4WTlFTEdm?=
 =?utf-8?B?TGRmTXRCczF6SllicE9rTTErTUxEU0N0WklHWi9IR2tJSXNWMGZraHMvWjVP?=
 =?utf-8?B?U3YxVXBUWmUxR0UxOE5oN1FkOWliQ2VndVkvZUFMT09FOHF6QWwvQTJ5Z2pD?=
 =?utf-8?B?N2lNT01TOFlTTFJjWmY0T2NEVmwvTDk4dU5MaHBlSjlvM0daeklCbFFRb3Av?=
 =?utf-8?B?bE5ybnA4YWFobnZMVkUyeDBnUWdBZytlaGd0aVFTNzBBMUxocHc2QXVUWTZl?=
 =?utf-8?B?Y2FHNWV2OEl2MS9xcW81MkgzdWJTQklpTlQ3bmtVM0lNYmx2aFhlNG9lWkRu?=
 =?utf-8?B?TUQxTXRqNnk5UWNLcG94NTBQSjJ4TVZxMU9Ld21tdHpxUkUxeUhPYWpiUHZw?=
 =?utf-8?B?amREWjMxUDBzeVJFa1VKbkJ5cHRMYWpCcmxEWXpkay9rRUdNK2JTNWgxVEZj?=
 =?utf-8?B?OVlEOU9XUlU3ZmhYaHREUTBjejd0RnNtTFRsUWZGbVFPY2h4QmxqWmprbmha?=
 =?utf-8?B?Z2xBNTkwbjYvZ2NJNlRFR1F2cE9xajYvODc3cTZMb081NDVzNHNjUi9lRit5?=
 =?utf-8?B?MXZ0T0YyT1VOT3dhSjhXN1NQMXlaYmhtWGplczloN3Ftak4yK0hNVFNBbG5R?=
 =?utf-8?B?c29yMEFDbzlzS29UNUF3ZDVtNHVtZDZsZWxpR0dEYm9oYnBOTjJzRzV3bGlp?=
 =?utf-8?B?Ty9EMGRKS1BRclpCMUQva3RTN25rRFlmVUZwNUJRNGxzQTh2TG5rQ2pYVWpT?=
 =?utf-8?B?dWsyRXNSYkt1NGxpb3NMbFJBdjRmZDVhZFNMKzE4bGd4aHl1QnZ4MlpKU2NQ?=
 =?utf-8?B?bUtUeUlHTlFRd0NrdGZqQzVPR0p1R0JQeHZxRkNhNENpVS93S1FIVjVlNmp0?=
 =?utf-8?B?aUJ3ejhpUkg4YS9OK0h0L3dGRHczYzU5TTJuSnNmeUtrOFdvMUI4dXlURFBi?=
 =?utf-8?B?dmRVQ0xTQktBSG5RbmV3RzUzZnh4V21IS3R6VnBPZkpBQldGU0MrOGh1QlJ4?=
 =?utf-8?B?UExVTzgxNHRtUXZyRWxxLzVPTmd4ZmplR21BWTFnWm9idVZkek5RMDZUbjRJ?=
 =?utf-8?B?VU5NeHhNRWpaK21VK2FZY3drR1p0NXlVMU12c3FmSktERUhETVVqR25zZmJ1?=
 =?utf-8?B?NnVQQzlKQ0ZnUFhmY21KbUZGVjN3M1VPSW1aRGF6Y1VGd0EzTHJUbW9OT2hr?=
 =?utf-8?B?UzIvLzlmTzlWUlZUWkxQNTNRNFRSS1doVi9UeWlqVEVGMlZ5WG5VZ2pLS0Ft?=
 =?utf-8?Q?OwFtGWmjVMHIDZhqeDud3KPM1OJvWwIr?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aThxa1VOeW4xMngxTEZabjVTV28wUFdIcE9IYTNSVTRzRHcxeTRQZ2pWcFpm?=
 =?utf-8?B?UkZ0TXFxSXFOL0dBa1Joc1F5cmRBS0xPcnRpczYvaGRieG5WUU5CeFY1eEcv?=
 =?utf-8?B?YXlUWHFldURZN2VjSkRuMjlpajJPdS84TURRNEhYTWN1TEljU2Z4UVM4KzJ4?=
 =?utf-8?B?dGhQYVExeGlFakV3T3VZSDhna3dwN0U0dnNwcXBGVHhzRGh0SUtHbk53WWlJ?=
 =?utf-8?B?VStjS1hMSXk5ZEg0dWI4UEtKMmRlbFBuOE1qSkhwWFM0YkJlYkRlRUdYamQ3?=
 =?utf-8?B?M1cxNXdqdmFsWUVNQ3IyekM5UFdMUkoyNkNRRE1Kd0pIYjZ3YU5UcTkwZGFR?=
 =?utf-8?B?SEprV0VsR2swVm1CNzM0V0gzcDBMMm9wSkI5b2ZKZzdTYkxwWXloYlpuTTlP?=
 =?utf-8?B?R3VBVytFUFV4bERNTEhwdnZUcTBaVUVjTW5YdDkzdEEvUHJ5MVJveUVOT1Bu?=
 =?utf-8?B?KzVGSUFjRFdHRmZhRU4xOFJSbGJFZXJTbEUzYXVjY2Y3V1lDZkNvbTFRY2NQ?=
 =?utf-8?B?OTNmTEM2M0RSdXVYSVAwWXZvSmxNK1l5NGw3bzJHellTYlR3dWYzQkE2TlY0?=
 =?utf-8?B?L25FVDNPbUFhM2xrTFJrVVJrc1VhMFQrN0llRkVzR1NZbHpKZ2RhZ0RISFha?=
 =?utf-8?B?TTZqTWdEVWhSSmNIUW9Vc20yWEUvQXpMYVk0VHY2cUVwcUZiSlJVZ0UzVjhj?=
 =?utf-8?B?L2FUeTlBbXg1QS9MV0w5cDRnMloyUGZhSXRML0ZKK2lsS1o4N3JZOUtnYlFh?=
 =?utf-8?B?WUJlZFVGRFZyOGFqNmx0ZVZzbmdYaFpLT0NMSGZvR3pGdFozaFRHdEdpR1Nn?=
 =?utf-8?B?Y1dNK2w3cHlSN0VmWS9xTnc2RnVTYWFDQThSaUVOelZGYXdheGN5VXM2ZU84?=
 =?utf-8?B?eE9uUjUzb1hycHdMZlNtd0tiQnY3d3lZc1A5aHhqU3hIbERST3pHMTRmWTh2?=
 =?utf-8?B?dkJuWWV3UXJFUkpYdHVwL1F0ZDlKaDkvUHdWcDh0eUpLeTMrWVNIOU42aW8v?=
 =?utf-8?B?cmhtaUpRR0VNWGJqb29KSGNKNGFLWTJZZldOc1EwRVMwbnFUeVhkUGwvNHpT?=
 =?utf-8?B?M0krQjhoUW9rdW81QlRKdFhFZkd1U1lMVnJ4SmRhNXpuYi9taHNQT1ptc09T?=
 =?utf-8?B?bmRyVGdYRDNUSnBObW84ZFJJYnNFWVl1dUNBZGRscjFnanZkQ245bHNMTWVT?=
 =?utf-8?B?THpJSmsyWFNzZmFpMHBZTGIrNEk2NUx3UjFnM2ZqNUFQVUh2eFlQWURLMk1Q?=
 =?utf-8?B?L1RTcWh1Vjh1ZWtXWTlkbkxWdWh0V0lsSUVOa2pSY1VhOW9xOFliWk5lSHNh?=
 =?utf-8?B?TnUrRU5IZHZXTGJmZFdCSDlDSGVFajM3K2hTTDVsTWphSW1tQXJwY3lGTW9k?=
 =?utf-8?B?ZFF5Yk85SlRJYm1ENkh0dXAybW9oUXBFazZJTmNXYUJqRCtMOVNuM09SMFF3?=
 =?utf-8?B?MGd5MHRudzhabUQ0Qmd3QVR4N3habGRMNm91NVRZSFVwTm1OZnBXL3pzK0lY?=
 =?utf-8?B?TkY5SzhrN1F1aG5LdWdxNnQ4a2hMWnJOeG5VTDVWRnVYK01YaXZDZngwd3ha?=
 =?utf-8?B?WENGZmZQZ3VBcldFbHFxSnp2MHRDMlJ1ZFNBNzdiWk1QTzNwRmJNeWJXVEhq?=
 =?utf-8?B?YVpmM0FhYnVUQU1pYi9saDRaRzl5R1VTTnlHQmwzck9mSThZNHh0VUxxUGdP?=
 =?utf-8?B?M3FOb1VWbmVQWmJTblM1ZC9EcHlPamNxd0FvaDQyRXZxS2ZUSGhtSElDK1Rn?=
 =?utf-8?B?Wnp5czVMdVZGeDUyOUhTenNINEFBc0Jma0hZYTNRMTB6ZUo3cVRkQ0tXN1R0?=
 =?utf-8?B?M3ZORkxnWXF0VWVHZTNxK09PTzFRVFBDRVBkZmtLeE9CMlRkR3lRaWxDcVdT?=
 =?utf-8?B?emF6NW1wbFpkdUE3TDFQcXhJZmtwZ2RnZDk1WkJaT05aaGlzRVpLS1puVVg4?=
 =?utf-8?B?SUI1bVpjcm5ZdlVqNXJ0MEk5THQzWll6ay9OazdtWklsaklMaVZHY3ByMkZD?=
 =?utf-8?B?UTRhQkNBbU9mLzZBbGkzR29sNEp3VUQ2eXZ2dk0rcDBTSWNOd1htajFTRFBz?=
 =?utf-8?B?R1BhM21sOGxGN3VBS1RIa3lma3FBWVZTb3FYQjY2TDdQMzgwYW9rR2dYMmxQ?=
 =?utf-8?Q?/8vK5+xdcQlc26m5jXkXZxVUX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c94683-ae35-4492-801f-08dd77ff06f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 07:12:17.3638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CBN7An2TI8SdafH9UqOiy9sZDjVqPZXBTlQn9lpMze3F10Wjk4PG8BQT7WLdw6nVtegi5n1YM9CKvaUzvauAmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8159
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
U2F0dXJkYXksIEFwcmlsIDUsIDIwMjUgNToxNSBBTQ0KPiANCj4gRHJvcCBpcnFieXBhc3Mua28n
cyBzdXBlcmZsdW91cyBhbmQgbWlzbGVhZGluZyBnZXQvcHV0IGNhbGxzIG9uDQo+IFRISVNfTU9E
VUxFLiAgQSBtb2R1bGUgdGFraW5nIGEgcmVmZXJlbmNlIHRvIGl0c2VsZiBpcyB1c2VsZXNzOyBu
byBhbW91bnQNCj4gb2YgY2hlY2tzIHdpbGwgcHJldmVudCBkb29tIGFuZCBkZXN0cnVjdGlvbiBp
ZiB0aGUgY2FsbGVyIGhhc24ndCBhbHJlYWR5DQo+IGd1YXJhbnRlZWQgdGhlIGxpdmVsaW5lc3Mg
b2YgdGhlIG1vZHVsZSAodGhpcyBnb2VzIGZvciBhbnkgbW9kdWxlKS4gIEUuZy4NCj4gaWYgdHJ5
X21vZHVsZV9nZXQoKSBmYWlscyBiZWNhdXNlIGlycWJ5cGFzcy5rbyBpcyBiZWluZyB1bmxvYWRl
ZCwgdGhlbiB0aGUNCj4ga2VybmVsIGhhcyBhbHJlYWR5IGhpdCBhIHVzZS1hZnRlci1mcmVlIGJ5
IHZpcnR1ZSBvZiBleGVjdXRpbmcgY29kZSB3aG9zZQ0KPiBsaWZlY3ljbGUgaXMgdGllZCB0byBp
cnFieXBhc3Mua28uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEtldmluIFRpYW4gPGtldmluLnRpYW5A
aW50ZWwuY29tPg0K

