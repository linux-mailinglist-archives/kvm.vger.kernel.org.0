Return-Path: <kvm+bounces-60691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 509F3BF7BC0
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6188154662C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95322FD696;
	Tue, 21 Oct 2025 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P6EelfZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354882FD66F;
	Tue, 21 Oct 2025 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761064590; cv=fail; b=Q1MfHCOTJGPfrrqVD/uyeOb+qoyQTsxce9uzOsxTzIgUn4/ABTXM/DvKLqXy2Wt1JmWQJ+btDqcnVmQE+jLNUhbCLW186qc5ftYVF3t2qkO57/YE3kaVH9J6N66QCjgZ3mYo59i8i8FHhCckdz/akscbLPMq84f4gPxE+phd4y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761064590; c=relaxed/simple;
	bh=F1CtXH2iyQ6oYg/oi2mt10kvJ1MRjM82tFhWIMuAOjc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TpDav1uY+aoLjNw33v9EwtBvUrd1xW0wPx+MEAHchxM3UDgOvS6A6O9RLtArsCuuOSCDyvmLf0M7Yh3etgVnCjpHL60FxyzR/Xqp81E5/1c0rBHsbyB+YXn4tFtCWMb8WV2GjnccVKyq0uP3mRS81W3wv2KVi6CSYD+vwqdO/cA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P6EelfZ+; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761064588; x=1792600588;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F1CtXH2iyQ6oYg/oi2mt10kvJ1MRjM82tFhWIMuAOjc=;
  b=P6EelfZ+RgNJuEBe8dAvhZh9BxOwscdRm9uWNqRRi2wXI+dxjajHtHq0
   wAD2pe8cVwIqL1cUE3lwEWOn4RlP6997BnoQGVTmn0vMNYo+JpvIwvozm
   mY80a1+MWXZRXjcriZqPkgGlPGpVvbcTyYgnGVIHfEnJUuq42IAQTwHiW
   84oC0fpYLsP/xn8uuI3Ebg9UN5gCpeSbDEGhKXuVKzfYpyvgnbTvGvg8J
   wXC63S9TnPMUU/NHPHOpqc7EItyrrgGkwTIpIBv/B+5UUkKqZfdjrWfRE
   /+XEFCrFjtVvfZqvh8XuCKcSfvFSQd6746qpCIPsfg7ECXbpynx/Pwu8F
   w==;
X-CSE-ConnectionGUID: WHLZmZxBQEWt751ohwutRA==
X-CSE-MsgGUID: 2+LnfOa4QPCYhKz4Fbrtww==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74539509"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="74539509"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 09:36:27 -0700
X-CSE-ConnectionGUID: D9Zm36MVQ+KekHL4RWmoCw==
X-CSE-MsgGUID: u7zzTX8FRgmD8Vjh+/Eoow==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 09:36:27 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 09:36:27 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 09:36:27 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.10) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 09:36:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxH9HZg+j1RJ/8fo2KHk4pq2y21zmXZ+vNozgNO/YwawpFJUOy4/UNk8D6Z4P1I4wVcMMcAqvjjo3hmFprlx46ISAzYlyNiIKnZv2ZoNoXMXzXllhp2VwM27PxeI1JyqwzQsvOYE1Pxct8U8RBP8ipYE/cYI+HrO3jsXtPoA2G0IWMw7VMUaKJAyOelOrDVIfHWkG8HMA4+K1xA5RhkM3OVI9INDrCfBFe3vGRsNFpsro84hzvL6OIocxsbftg3gwijqfeRkqh0TteUniXW1Opr370iK+xpA8eLxyICu2o/5B0Etg0vaSknow1uGTlHy9ud6VQbAy6Pv+yaz+kJgCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjjoOn5GF21QzMPSSe8c5sduWzt3yrvUVT+OGdex24o=;
 b=B+YmP4tHaxq6pu1Z7Px9pA4uO1O+IXX32QOFQET5Tf/nmx3I/y/4wHqsfpIptES08+5CsmXrz43QqoNYiXOuqdllqSqOGonwNIv+UYTAdUz53OBqoDgaUb3aACxe4a7FmwbwmTTXixtlafVNE31iOs9R4WncW7HAoAhXDr312eTCRYDSk0kJKcO/kV2kaMGzsQCSEGpW1fbXVEzXe0z82I0kmXEAUCaInqSllQafP8TbkxocnQTqRP6+9bRSgp+GkSpvOX0IRJNa5rLVEH5HXTqhLHtO1zNYJOumtidg6++Qz/7DE1F1D7YeXMJBVfsx2Fkx8mkbQbTy9KpYDUFHyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 16:36:23 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%7]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 16:36:23 +0000
Message-ID: <4841c40b-47b0-4b1b-985f-d1a16cbe81fa@intel.com>
Date: Tue, 21 Oct 2025 19:36:19 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kas@kernel.org" <kas@kernel.org>, Xiaoyao Li
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao
	<yan.y.zhao@intel.com>, "x86@kernel.org" <x86@kernel.org>, wenlong hou
	<houwenlong.hwl@antgroup.com>
References: <20251016222816.141523-1-seanjc@google.com>
 <20251016222816.141523-2-seanjc@google.com>
 <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
 <d1628f0e-bbe9-48b0-8881-ad451d4ce9c5@intel.com>
 <aPehbDzbMHZTEtMa@google.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <aPehbDzbMHZTEtMa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU6P191CA0021.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:540::26) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|PH3PPF91320C45A:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bad4dc9-fe35-4de3-568d-08de10bff8ab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T2F0ajVTall6QkRBbElrWmk3THkwSndjY3JaZHJ0V21kOWVQZTVBcW5XaWIy?=
 =?utf-8?B?WE5lbk9kTk9pUEtvQUVVLytMRTc1SVRqb1k2eFF1YUpaQTVHQTljTVROODZx?=
 =?utf-8?B?U3hmeGdBdWZmcDhtU0d0M3RVaXJmRVdQTHJFeHZjSEpVQjk3elBITWNTd0wv?=
 =?utf-8?B?ZnZNN3lManY4eS9qb25Lc0RDc245VnpjTjhkWFkrMnF3cDc0cTRYZVhXc1pV?=
 =?utf-8?B?TUg5T1QxRjJmc0FFY3UyNklITTNtejl6OGJMMnV1b3laQ1VqU0RlNEl0dGd0?=
 =?utf-8?B?MVRuOStYdTFhc2o3WkZZYTQ3QXBEZDcvVmdWN25JTkFxQzRtUVhKS3dJSTFz?=
 =?utf-8?B?YWlMdzVjWlc1bHV4ZENEdHYxdEdsQVo5aHFFWmNXem43TkU1d1VxUStVT3c1?=
 =?utf-8?B?YjVQUW1vczNHUFJWR000SlhhalhwaUx1amFDNFNjVWg5eHN1akYycXg5cnB3?=
 =?utf-8?B?UmU0R25CQW1DZVRZdzg0VVFNU3M4VkM1R0c5OFRkVFR4azdTWTVSTWxxMlFh?=
 =?utf-8?B?MjBJbE1sRXRMcG5oSGpra0NwNDdvYzRGN1hWUjh2eHAwZXZxSVVwSVA4MFEw?=
 =?utf-8?B?S0hEejZCTWErS0FSUnBZZWRaN0NTMVpncEwrcjR6V2laeHU4OHI5eTJSekpF?=
 =?utf-8?B?OWthY0dFQ2xobFBpQmc5R3dadW9HRmE0d0NabjB3ZFBqaGpKbFd3TGZ5L2lH?=
 =?utf-8?B?NWFaOHZWNFVCODIzcUNKR1A3K0JoMWVqbTN3eGdTL2pVc3lOamwwMkRRRmUw?=
 =?utf-8?B?QzJrZW9vOWJuNUtweTBybGxBdVR6WjV2V09heU5ydnllMnJtQkRrcmxwR3J1?=
 =?utf-8?B?cHl2OXRGcUJZZmpMeWlxTW00b1E5c3VFU3A4Z05WTGFxbHFSQnlJZHEwV0Nj?=
 =?utf-8?B?WE5OUGk0M29MckdQRUg2cGhvVFBMRTRDVDU3V25BdkhoNzZKL3dFejlnNGhB?=
 =?utf-8?B?NUs5NlFiWWZyUHlMb3lTcDBFMXhiN200ellzcW80OGlVOG0wdzd1Z1E3NU13?=
 =?utf-8?B?YmtIbk9MZEdpZGxGbURGdVFyTEpCTzdWMHZqeFRWVTg5RGFjVU1xdDR1Nm94?=
 =?utf-8?B?c3d3SXBpUmJUV0xyTDFOb0lDL216bmhVUExPNGNkYXNzYjBpcUhvOU04ckFo?=
 =?utf-8?B?S0MrUGZyZG9ESFQ3d1NWWHIxRHZSR1dGRnlYOUY2b1JwOWpLU2pKU3hEM21k?=
 =?utf-8?B?Kzk5RWZDWVNiOVZvUGFFalFodXVJMmRBcDhjeitDQWphaGJvUVJFa0t4RzVI?=
 =?utf-8?B?b3JHaTVBbUJXVzFNWU9nUDROSlA4Vys0S0RkdldMeVpEd2ljVGY4dUtaYXQ5?=
 =?utf-8?B?UGx6a3VoUDdnRWtHSnFuMWdoOEs4K1pBOUtsbGs3c1gyWmlUek90QUJETE5E?=
 =?utf-8?B?QjZiZ0N1cjM3Vm5vSXUzOCtBK2FmN042VXRuMDljWEZTVUp3QVo3NFF6ZUpC?=
 =?utf-8?B?Z3hiTGIyaEI4NkYzY2FZWW9KcWZyaEtFM0wzeTNQbmd6MTRaTlVkcHJzWUhk?=
 =?utf-8?B?WW9CZUJJZFg5MHIzMGxGamlHbElCOVROZ3M3bmM5MkcvMENsQTJUendIRFBD?=
 =?utf-8?B?WHNQUjE5MHZ4YWpjWFBiMVBIc0FMV3F4c2VjMkFybGdaR1ExUHoyWTJhcnow?=
 =?utf-8?B?R0lEcW54VWs4SkhzbmQ3NzRtYXlsbkgxejZRRy9STjZOKzdQM2diZS82MjJH?=
 =?utf-8?B?TW9LU3Q4NC8wUVl6Z0xQeTJ0aGJZcmdETE0zZU5HR09BSGZjei94dUJXTEpY?=
 =?utf-8?B?ekRnOU90R09qY1NpWUFIcVVEazIwU2FOM2hjWTFzYXFadTUwN2N6dVpXZjY4?=
 =?utf-8?B?UE9yODlsS1pZZyt2cnEycHd4dW1lZmUxNk92d3JXRjVWaXlQRnA1bDZIUktj?=
 =?utf-8?B?K1RBK3dTVkYwTzg0QlhKVFBJUlFMQ0pUQ3A4UU5NN1o5TEI5b0NQdi9VU3Nx?=
 =?utf-8?Q?kJWNFjTHFummIMhvVGohD3yv2OThtbOs?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXV5eFZLNU1DMUZKY1pjTDRqcnAyUkhaK1EvWU81QURxbWFHdm1SWkxkQUdX?=
 =?utf-8?B?b0FTbEVTMi9DSlBJcXQ4T1AyNFlvWGI4RlljR1lEZHMxMUE3R0FrKzU5TVZx?=
 =?utf-8?B?c3FXTnczaHVmREcweTFIRC96WmxxYi9GMnNNL3VQQUpQdVNMNGlLYUVDbXpk?=
 =?utf-8?B?RVJVeUJPYmhRbTF5bURjVmhRTjc3Uksxcjhodi9rbXNpeHhnWXZ3eC83UHcv?=
 =?utf-8?B?aDJ6T05EaWJDdjlrYTB0WlFCMm5JaUlSL2pZdkpubGtmK0F4d29mOENaWlJR?=
 =?utf-8?B?TU5uNVduMEkwdXNCNVRjbkE4V1NqSFZMWWRPNzJaTzNBSHM3VEErM2tDOElz?=
 =?utf-8?B?bzNxWWZZQVI0dXdZMlBwZkFIMFBIOEJtOFJZSlZqUDJ4U3R1RUlpeE5wN2dV?=
 =?utf-8?B?cmM4WTQ3YWZkWDdnamlVcW9wZVQ5bGY3eFJaMFJpNlFrZFBCNWFUVndRZGdY?=
 =?utf-8?B?SkRTNlYvYWRjbkp3UHhaOHZSeWJ4Qk1Sc3c3RVBRYS9KUlhzM2ExNW04OHNG?=
 =?utf-8?B?czFVK0huQ0JDeG93dGdlOTFTeVpubktBREVxcFR3Yi9tbFdzMWN3VUJEUUFV?=
 =?utf-8?B?dkhlOFlIYUZVVDJLNUR3ZmNIZVU0VVE4UVcxcWN1QWZTN3k5VzErSk05ZUh0?=
 =?utf-8?B?OFErUjJpRnE4bUhmSEhrS1lQZUt2NUhYYU5nbHVxUEFVNEtSYXJWSUluNzhU?=
 =?utf-8?B?M1kvZm94NVBrMVlvSDZ3VjNNRXlqMDVJYlJlaXJRMU9OTTQ0b21qVFhobEpv?=
 =?utf-8?B?S2pyL0NrQjNOQm82ZHVtc2t0alNaL3ZSTGlZb0M4TEIwQm43NXBrS2p3clBV?=
 =?utf-8?B?aGF4bUY0dnlLWlRHcy9rYVN4bmFtQVlCaUppN1JTN3pYa25laWFGMXdJWVVN?=
 =?utf-8?B?UzE4M3dNOFV5OEZYRXJKUko3cFpkUHpsUDlTTDlSMzhMTk81dFFoeFUyRnEx?=
 =?utf-8?B?RjZLdk00bkxnOTcyTUV3YnYvb2VqQ0ZiWnY2aVRuTEZLWUg4RUFXNlljRDh6?=
 =?utf-8?B?NHNPS2dsQlRJTVdvenJnancrekhjWlphWDRHeUhBWVgvdVFFVTNJQy9VZHJk?=
 =?utf-8?B?emJkbjh1bklCa0lHVHlLK2pnMVBFYTM0bmFQeUpRc3VlYnc4QXpMS2k0b2g4?=
 =?utf-8?B?MzgrR2NBR2czclZFZ0YvUnY2ZS9YUVIyZUxhSGFHdUZEbXIvMlhHeERlRThF?=
 =?utf-8?B?T0VkRThLZ0ZGb3VYQjk0YkhVSEFZUUo5MXJYRzJoM1NLQkIwMFA0dU4zSXh3?=
 =?utf-8?B?VHBHTzNnN3hLUDJuemV3cFN5Ni8wby9wK2dRNERWMlV3U1ZIKzBkSEJCazRK?=
 =?utf-8?B?SFNSWW9pdmxNdWtjTnhHdnNMZ1ZMTk14V3h4WjJnZ1pCRXVhTzV3MFhHdXRu?=
 =?utf-8?B?aU4vb3VTNFpjcHN4WnBDYVFKWDY1VkZ0SXZNTWl2YlF2eEhPN05xbjJEVzFF?=
 =?utf-8?B?OEhhMG9QV3daMzBCR3dXaW9oZmI3K095c0cvRzc5dTN6bXNwWVlMQk5GNjJB?=
 =?utf-8?B?Y1NLUUFmYWR4a0tIRUhRdi9VOFlyYXE1UXV0T1lucWM5NlcyQ2lZQ3J5Slgz?=
 =?utf-8?B?b3A0VVhTalk2ODM3MDkraVdaT25RTmthM1dBOFpnam95MnNTMkpMdFpBUUVM?=
 =?utf-8?B?Q2NpZlFpTEJPbmllV2cwY0orSnNaTElMdUlrSjRRd2pnand4VWFtZVRadzFt?=
 =?utf-8?B?RmFlMkNhcjRFbnVadHVZQmQzcldMT25KRU43Y0F5bnR5WXNHUW5nOTc4TXhZ?=
 =?utf-8?B?SUN2c1NQRWFGVFdzN28xMGlLSlBzUWIrSGIzbWtRb0w5RW1Vd3BjN295WDg4?=
 =?utf-8?B?b1NjOHNscVJvQzZDRTUwSDl2WnlKelNOU29FRGtjTThrYWRIVzc4UXFaYVQ1?=
 =?utf-8?B?Rk1JcDNFL1VjQmVRcWpKdDEwN3pCV3ZvUjBDelR3aUN5UjZWaWtNREZGWkdY?=
 =?utf-8?B?bzMxL2FBelg0TzBmekJLRHNVc2V6cW9WUG5xNEdKaWVYblNWd1p0bW9uME8x?=
 =?utf-8?B?L0NlWTV4MjE1bmJxRkF6QnlSOFdjRUVnaGU3SGRzMUtoVkw1aGFOOTdEUGNI?=
 =?utf-8?B?aDlFdmcyRW13bDZzRENFNkplRW52by90Vk1SRmxmOFhhVEhBQkp5ay9RcEkw?=
 =?utf-8?B?aU5zRE05SVZoMmsrTDk1a2N4TXFHY2FVbzdPNnFVMzR2dlU0Y2FDZHFNbG1X?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bad4dc9-fe35-4de3-568d-08de10bff8ab
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 16:36:23.3074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qSXaSCwPUsENu2zuuo10BLMKoMszXIBDhQ6LCETbg+0ZTfqd+kBJbmdzDGKRVhkR1pyPmGiRJtiRioEstyQoHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com

On 21/10/2025 18:06, Sean Christopherson wrote:
> On Tue, Oct 21, 2025, Adrian Hunter wrote:
>> On 21/10/2025 01:55, Edgecombe, Rick P wrote:
>>>> +	 * Several of KVM's user-return MSRs are clobbered by the TDX-Module if
>>>> +	 * VP.ENTER succeeds, i.e. on TD-Exit.  Mark those MSRs as needing an
>>>> +	 * update to synchronize the "current" value in KVM's cache with the
>>>> +	 * value in hardware (loaded by the TDX-Module).
>>>> +	 */
>>>
>>> I think we should be synchronizing only after a successful VP.ENTER with a real
>>> TD exit, but today instead we synchronize after any attempt to VP.ENTER.
> 
> Well this is all completely @#($*#.  Looking at the TDX-Module source, if the
> TDX-Module synthesizes an exit, e.g. because it suspects a zero-step attack, it
> will signal a "normal" exit but not "restore" VMM state.
> 
>> If the MSR's do not get clobbered, does it matter whether or not they get
>> restored.
> 
> It matters because KVM needs to know the actual value in hardware.  If KVM thinks
> an MSR is 'X', but it's actually 'Y', then KVM could fail to write the correct
> value into hardware when returning to userspace and/or when running a different
> vCPU.

I don't quite follow:  if an MSR does not get clobbered, where does the
incorrect value come from?

