Return-Path: <kvm+bounces-11300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 11EA9874F5F
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 13:45:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97E431F2360D
	for <lists+kvm@lfdr.de>; Thu,  7 Mar 2024 12:45:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6878612BEA9;
	Thu,  7 Mar 2024 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYjgZ1fd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EB61D680;
	Thu,  7 Mar 2024 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709815524; cv=fail; b=LkDXxtOriGRpEInricPXphJwFHsoxDdXazlJzB5siGAd4083+e9ooxSDZeg1QvVjegSQka54Z3fUcnPbw0oFPHOXUs+9BfUEkZ6e5pWKq53gHaF1/ili4kHXaBt33i7fX1Z4eXfSzCS58lGkTnK1yDXhw51iX5jfXb4s2fStWoQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709815524; c=relaxed/simple;
	bh=GBU9Pae0kk9rLoL7tmTZoQC1NSA8qIhtJKCOs8sRaM8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IcC8v/zKNw71wXb3vJd9cAm42UlSexzAyEiuCkvnd0gfVd3ZoMq9wyx7eFyouH0kz0Q6bzpJYkAr1rx4LBUE0tp8RZu/9MgiMOMolcabEZ6Qne0gsuMocLaQcoJvwsUifr+BJYYA9jzp9U76ARCLirEg8OHiEjD7O3A5sEswyAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JYjgZ1fd; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709815523; x=1741351523;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GBU9Pae0kk9rLoL7tmTZoQC1NSA8qIhtJKCOs8sRaM8=;
  b=JYjgZ1fdpZaAYN5RGwEeXR9yX/H402LPk/b5IIxI20NbzD8ahwtBh7Hv
   WbIkCvjctj9jFxfssXNkwp+cHhElx6UOR+BuGJfqute8ztsMydocI3CDU
   +Kmnyj+3aBgUYrK6pwnR0xl503r34QXXazTxHK4Ejc1zMW7+RHvpwW1oo
   nJysD2vQWJD2UznwCuOqjZMkSugPVxw/ArsByr8U9OM5H1LYNi7fn6o4t
   S5iW26kK/BD9/3j6XdhKC4IwmZuQe7vZnum7AKSXXXSk7srCVqQdIulVW
   /WWcS7RPQ+JEL0FKVnwVurNPlOYmGTzZW+Oa3ddkPCgBaw3yPOANiqZRY
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11005"; a="4360353"
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="4360353"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2024 04:45:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,211,1708416000"; 
   d="scan'208";a="14663229"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Mar 2024 04:45:21 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 7 Mar 2024 04:45:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 7 Mar 2024 04:45:20 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 7 Mar 2024 04:45:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQl6NkPgtQoaVFL91P12VsjyyUYIMu0KKpiLeQUmIczB0lwa/osaBLd/k5idc5AFhsNxAlioABPBj/PHCa2+iaaKG4ARLnSFHO0pKEhXP80l3yh85iY1+oMjKvj9N+mbtjd2rd/jI7T5hlRprhz8SA2DjHi5U0SnaqA66UrcahQDF5QHP009xv7VuEcDBr/Kb39f9vkzURiR/+g6OfrCPJEUGMtLALfOjY5rh9xhw8zQ8RWbeFV8JwDoebkDdjj9lFy9igqTS0IEv/SudWMoaXlYLC6nqIRCc/713iAdCVvsJ5AMFD4bAJBWwp2H7CQBVBDpX46eFTAbW2R72SW8Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GBU9Pae0kk9rLoL7tmTZoQC1NSA8qIhtJKCOs8sRaM8=;
 b=TZ9vBGwfB9N20jHydLjMWG5MxF82pQBUATN6cOQ2QTFyCqQbH+QhXGux01FyI4xh0JpSekF9SUA/kpJXvWTv9opYbGoP0Rz8WNpV3FDwTHjjzxytBMFamJyVNLZhQxz+exfRngGjih5LaH+4DXv3wPSP2UXLWQ+YVQ5uyzkV4++UjH+qLMp8Oeo7aDyfi+jOl9mOjpFF9E9En6PzLVL+4Vc0fchVXVU2WpnZDzrXnBgS7KA/jwVCHkTSWJZiXEsFxxtwKH76gCZpWhViMgaSZbQJCh2iA+uE1YPbnqkCDgcQTyxN/38s+TJMaFfCcKVXeLpcW2B9OxyviPlbUYwxMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ2PR11MB8588.namprd11.prod.outlook.com (2603:10b6:a03:56c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.22; Thu, 7 Mar
 2024 12:45:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7362.019; Thu, 7 Mar 2024
 12:45:16 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "federico.parola@polito.it" <federico.parola@polito.it>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [RFC PATCH 2/8] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
Thread-Topic: [RFC PATCH 2/8] KVM: Add KVM_MAP_MEMORY vcpu ioctl to
 pre-populate guest memory
Thread-Index: AQHaa/5GbKxwZH3R10uWiWHoqBtWILEsQpoA
Date: Thu, 7 Mar 2024 12:45:16 +0000
Message-ID: <85ad9d17fc50ff0784f5bcaefccdade53d2c18a9.camel@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
	 <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
In-Reply-To: <012b59708114ba121735769de94756fa5af3204d.1709288671.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ2PR11MB8588:EE_
x-ms-office365-filtering-correlation-id: 360da683-d940-4e04-42ab-08dc3ea47085
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NLUSo5VnYbnUk26/Xr+531p4//U7+aOmpFTa50e0RvSNAcVSA27EZvCf6CztsTfon2bF9B9bu4d75PdJkCwy0p9lxetHhnnw8Aifn02b+KQ/2ZLtRWdES5wtMF/OEZe8PGVZGah9ePql2JaMGhNcgtk8tkS/Px7oxZnvSqhY3cIawFHwZUG7r+iTcVFu66v5SNkEaSjVHkqbEHsvvPvfaKyFOZ0L3DlYyI+p6dr6yIzNU1YWe66GTGUxZsuaVHHy7wN0CRhWxbIhHsWIuHphSBdEshF38rZRx3n6aVs4K6uynmcwa+Ec67eMrxNb9S9UX5p8vPFRBnBdicB3TXVtQuzeDcwMeaVxSdVDsqyclL2jFPgL4PdZTdX8Q4Zp/c4AGExi38m2BH15VM3Ld/Nfu6z8bFYeRiaTKDkmI27cKDbDyWp10XqctW1ADD5QMJQGy2RdtsQAvdAA1iPDPsMPjIB70zdnL7eL5QzKkW7UMjgRwx/PfjWTz2/Iy9RkzAtizSbVhAzPmIsi63ze33ev8I3GnI8xJUpPX344F3xepYq/ZTV3vjhDEo2f7WbHgCyjsMTCQ66YZVxpq+GcPFqPHiWVFJnBi10G3aUM6KXXcCsQ+AKYTM69mEc6REoRGdGUgOFH8yisw6c1ijywYax9ZpUTLT8WMv7/ezNTson+/u698xpAK0JLjY7vbpKirryh+rZmQ251HCnoQYhsl2NRuutjEvWQv0h1IW/d/RH0fpc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WE51bHlpU2NjRDFROTJTMlkxZW9XaVRBUVJmQnVBWFQwWmFYVER1ZHVBQitP?=
 =?utf-8?B?WHpZWTI3Umc3aUNnZTBYQm0wK05ZSDdrczkyaGN2cXM0cDV0VTBiWjNocm9G?=
 =?utf-8?B?Q0FHWk0wRlgwdlcvK24za0NGSjZTa3U0N2dFbHNpOFJKZUkweTdiL0tVdDR1?=
 =?utf-8?B?STJHTFpFMXJrRFFQa0kybWVYc1B2NElRWVRyN0creEF3YUVIYVVaWExyRjQy?=
 =?utf-8?B?NmczRWJnYVVwdFBHQUtsQlZ4c1U0SzJjVTRpMDlKYTR2MjhIYzlGSzVmQ1Br?=
 =?utf-8?B?QnU1OThSM0YzWTZKZ2dQTVowcTV2TGZScmpHRzB3MGVLbjkrRXRKWXgrRkpL?=
 =?utf-8?B?M2ZaZkJBdTBaZzZ1MSsvUzlRbVFEL0xxYjhubnRjbjUyWU9iZTBGdWNSQ1dU?=
 =?utf-8?B?Uk9oT3FQVmgwUDQ2N0JwMlhpZUgwdWc3dTZEcmo2LzBqcVk5QWs0NGl1WWI1?=
 =?utf-8?B?LzFSdjROajB3bXlrNEZ1UmlzRHh5S0tXbGhKajVKS1AxOUZ4amVuTFZ4S1By?=
 =?utf-8?B?OURRYSt1Y1hnUHExUisrSGdoMm8wZnlNdHQ2QlJVOHBtb2VpaWRmZkVCZC9j?=
 =?utf-8?B?NVBPcEF1QUhkanFXaVZlQUdTSTZHSmtFSnlLdmhDbHJUOGhMNVhqTzAyYjl1?=
 =?utf-8?B?ZkRjUEZGN3JvVGtBUmFxU0d0UlBtLyt2cURFVzAxSFJ0UGhKMVYvRk1qdFhx?=
 =?utf-8?B?TEEvTkV2T1VFczVUMFBoNXhyaHp1dXB3clZwT3o2ekNRVnlTeUppU2RLZ3RF?=
 =?utf-8?B?Um85Z0pCNFNPNXBldUJzNEo0bFVtVlpXbEtJSStLdjlucDd1ZFU3b1hxWCtC?=
 =?utf-8?B?S2U3NWMzbUJOVTViblpDblpiR1ZVSXBVMldHUU9hZ3B1Tml6TDhFRU1KSnJZ?=
 =?utf-8?B?ZnNsWTd6K2FDZGdPYWt3SkpVSWh1NUh4WndHbVRmRjVNSHNWaWxkME1OZG5z?=
 =?utf-8?B?WXNtbGVlSFRuY0pPNkRNSXdGSzJWQ0w0U0pqVFRLYUZtd1JqYWNXMEU0RFor?=
 =?utf-8?B?WU1oNDczRWpjRldERE51N0MvTGc4S0wrNVlXdkQvUnJObmdYU1ZIakdPaGpn?=
 =?utf-8?B?NlkzUHN0TUhWVHVWVTdqbWdGTTZGWmlnaFcwYnhBWWRpQldKRGRReFVXZzM5?=
 =?utf-8?B?dnliRFkwa2htMHVWcXZ6dFVCODhqc2VraklaSTQ5Qk4vMU0vNXlQYXZYNGNy?=
 =?utf-8?B?M3lhMVlGOU9XR0JhenFXbDhmNXBuK2ZGYXpWVDQ0Y3BPUFdvMEVRSlByL2Y1?=
 =?utf-8?B?S01wYzhDamRKRUN1TmRhRkxZMGxGSEhnSkJoU3hLM012cU5WU3l4ZEZGNWFt?=
 =?utf-8?B?NzhUMG9EUzJBMUd5aHQ5YnI4UnJDcHp5REhuUXlGQ0tBQTFtQVEvMlR5dlhC?=
 =?utf-8?B?b3lJVjF6RUhxTFhrZG9Qdm5yamFnUWt6TXFkZlROeGVhZkU2Sll2OFI0cS9l?=
 =?utf-8?B?MVB5d2l2MUxnQm1nZDcwOFlpS3NxZWNxZVNwMkxGY0l6d1UvZDBBeVd4WFdh?=
 =?utf-8?B?dXNkMTZwdDdxYUQwOEpGZFlnVm1lNlZKNFhOTmRxeHZpN3pHdXU5Q1ZVQkw4?=
 =?utf-8?B?eWF0cWZiNVdTd1RHcVNKR3c5czQrdEVtREhZa20yNXBjYXBIRG9lc1RGR3F3?=
 =?utf-8?B?bTJLK3ZhdEZ3THFrUjJlWDVWQmVRREYzRk9sRVcvQnhDeDlkd1RVUHl2eWZq?=
 =?utf-8?B?YW5sWC9XNHFCZTFUZTdzS3lvRHlUQjdVMktnejI4Rlg4THFKZU1PNTFnT1ps?=
 =?utf-8?B?RXNvWmxpLzB6ei82MlFWc0lseTVXclhEc3hQQzZoZWJDSDV1ZnJ6cHhxZ0xk?=
 =?utf-8?B?T3RTYmhFQXZZS1dCRi9aNEQ5STJNUnZwQ2ZWNHlXaUZvL0xscm9MelBIbUww?=
 =?utf-8?B?aEttN3dLR0NNcEhGeVRLeVhXLytpMGxqRkdmNUNrMXFteStvVlN4S0Y4ekJw?=
 =?utf-8?B?b2ZYdTJ5cW1tY081SS9SSm93WWdrNHMrSCsyTUlSNFpwdzVnYXBobFRtQ2xi?=
 =?utf-8?B?dmltN0VMeldCbGVUNlpxY0YwNjZrL3JxS3BXQzdrSVpFbm4rVHNEaUFQSk0r?=
 =?utf-8?B?SUE0Q0hEZE9oK1RFS0dITko2S0xxZzQvYzVzUWlkSDI5RUMyR3NnREhhZFRt?=
 =?utf-8?B?eWlySzZiN2JrdFpGWTVMQU1NN21kMEcwYmJCdWs5dThxMXhSL25VMTR4NzJs?=
 =?utf-8?B?b3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DBC14928A805414591DD787AC2CBD3A1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 360da683-d940-4e04-42ab-08dc3ea47085
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2024 12:45:16.2596
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CZhqclU/dnJAuRh4PpI0cnpruMaH5Deqii5zxcxUs61E973PEaYJy7eTWloXDWLZGxU9ZdTMhEI9JGXpVGL5Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8588
X-OriginatorOrg: intel.com

DQo+ICANCj4gK2ludCBrdm1fYXJjaF92Y3B1X3ByZV9tYXBfbWVtb3J5KHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSk7DQoNCk5vIGV4cGxhbmF0aW9uIG9mIHdoeSB0aGlzIGlzIG5lZWRlZCwgYW5kIHdo
eSBpdCBvbmx5IHRha2VzIEB2Y3B1IGFzIGlucHV0IHcvbw0KaGF2aW5nIHRoZSBAbWFwcGluZy4N
CiANCj4gK2ludCBrdm1fYXJjaF92Y3B1X21hcF9tZW1vcnkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LA0KPiArCQkJICAgICBzdHJ1Y3Qga3ZtX21lbW9yeV9tYXBwaW5nICptYXBwaW5nKTsNCj4gKw0K
PiANCg0KWy4uLl0NCg0KPiArc3RhdGljIGludCBrdm1fdmNwdV9tYXBfbWVtb3J5KHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSwNCj4gKwkJCSAgICAgICBzdHJ1Y3Qga3ZtX21lbW9yeV9tYXBwaW5nICpt
YXBwaW5nKQ0KPiArew0KPiArCWJvb2wgYWRkZWQgPSBmYWxzZTsNCj4gKwlpbnQgaWR4LCByID0g
MDsNCj4gKw0KPiArCWlmIChtYXBwaW5nLT5mbGFncyAmIH4oS1ZNX01FTU9SWV9NQVBQSU5HX0ZM
QUdfV1JJVEUgfA0KPiArCQkJICAgICAgIEtWTV9NRU1PUllfTUFQUElOR19GTEFHX0VYRUMgfA0K
PiArCQkJICAgICAgIEtWTV9NRU1PUllfTUFQUElOR19GTEFHX1VTRVIgfA0KPiArCQkJICAgICAg
IEtWTV9NRU1PUllfTUFQUElOR19GTEFHX1BSSVZBVEUpKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gKwlpZiAoKG1hcHBpbmctPmZsYWdzICYgS1ZNX01FTU9SWV9NQVBQSU5HX0ZMQUdfUFJJVkFU
RSkgJiYNCj4gKwkgICAgIWt2bV9hcmNoX2hhc19wcml2YXRlX21lbSh2Y3B1LT5rdm0pKQ0KPiAr
CQlyZXR1cm4gLUVJTlZBTDsNCj4gKw0KPiArCS8qIFNhbml0eSBjaGVjayAqLw0KPiArCWlmICgh
SVNfQUxJR05FRChtYXBwaW5nLT5zb3VyY2UsIFBBR0VfU0laRSkgfHwNCj4gKwkgICAgIW1hcHBp
bmctPm5yX3BhZ2VzIHx8DQo+ICsJICAgIG1hcHBpbmctPmJhc2VfZ2ZuICsgbWFwcGluZy0+bnJf
cGFnZXMgPD0gbWFwcGluZy0+YmFzZV9nZm4pDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+
ICsJdmNwdV9sb2FkKHZjcHUpOw0KPiArCWlkeCA9IHNyY3VfcmVhZF9sb2NrKCZ2Y3B1LT5rdm0t
PnNyY3UpOw0KPiArCXIgPSBrdm1fYXJjaF92Y3B1X3ByZV9tYXBfbWVtb3J5KHZjcHUpOw0KPiAr
CWlmIChyKQ0KPiArCQlyZXR1cm4gcjsNCg0KUmV0dXJuaW5nIHcvbyB1bmxvYWRpbmcgdGhlIHZj
cHUgYW5kIHJlbGVhc2luZyB0aGUgU1JDVS4NCg0KPiArDQo+ICsJd2hpbGUgKG1hcHBpbmctPm5y
X3BhZ2VzKSB7DQo+ICsJCWlmIChzaWduYWxfcGVuZGluZyhjdXJyZW50KSkgew0KPiArCQkJciA9
IC1FUkVTVEFSVFNZUzsNCj4gKwkJCWJyZWFrOw0KPiArCQl9DQo+ICsNCj4gKwkJaWYgKG5lZWRf
cmVzY2hlZCgpKQ0KPiArCQkJY29uZF9yZXNjaGVkKCk7DQoNCm5lZWRfcmVzY2hlZCgpIGlzIG5v
dCBuZWVkZWQuDQoNCkFuZCBub3JtYWxseSBJIHRoaW5rIHdlIGp1c3QgcHV0IGl0IGF0IHRoZSBl
bmQgb2YgdGhlIGxvb3AuDQoNCj4gKw0KPiArCQlyID0ga3ZtX2FyY2hfdmNwdV9tYXBfbWVtb3J5
KHZjcHUsIG1hcHBpbmcpOw0KPiArCQlpZiAocikNCj4gKwkJCWJyZWFrOw0KPiArDQo+ICsJCWFk
ZGVkID0gdHJ1ZTsNCj4gKwl9DQo+ICsNCj4gKwlzcmN1X3JlYWRfdW5sb2NrKCZ2Y3B1LT5rdm0t
PnNyY3UsIGlkeCk7DQo+ICsJdmNwdV9wdXQodmNwdSk7DQo+ICsNCj4gKwlpZiAoYWRkZWQgJiYg
bWFwcGluZy0+bnJfcGFnZXMgPiAwKQ0KPiArCQlyID0gLUVBR0FJTjsNCg0KV2h5IGRvIHdlIG5l
ZWQgQGFkZGVkPw0KDQpJIGFzc3VtZSB0aGUga3ZtX2FyY2hfdmNwdV9tYXBfbWVtb3J5KCkgY2Fu
IGludGVybmFsbHkgdXBkYXRlIHRoZSBtYXBwaW5nLQ0KPm5yX3BhZ2VzIGJ1dCBzdGlsbCByZXR1
cm4gLUU8V0hBVEVWRVI+LiAgU28gd2hlbiB0aGF0IGhhcHBlbnMgaW4gdGhlIGZpcnN0IGNhbGwN
Cm9mIGt2bV9hcmNoX3ZjcHVfbWFwX21lbW9yeSgpLCBAYWRkZWQgd29uJ3QgZ2V0IGNoYW5jZSB0
byB0dXJuIHRvIHRydWUuDQoNCj4gKw0KPiArCXJldHVybiByOw0KPiArfQ0KPiArDQo+ICBzdGF0
aWMgbG9uZyBrdm1fdmNwdV9pb2N0bChzdHJ1Y3QgZmlsZSAqZmlscCwNCj4gIAkJCSAgIHVuc2ln
bmVkIGludCBpb2N0bCwgdW5zaWduZWQgbG9uZyBhcmcpDQo+ICB7DQo+IEBAIC00NjIwLDYgKzQ2
ODMsMTcgQEAgc3RhdGljIGxvbmcga3ZtX3ZjcHVfaW9jdGwoc3RydWN0IGZpbGUgKmZpbHAsDQo+
ICAJCXIgPSBrdm1fdmNwdV9pb2N0bF9nZXRfc3RhdHNfZmQodmNwdSk7DQo+ICAJCWJyZWFrOw0K
PiAgCX0NCj4gKwljYXNlIEtWTV9NQVBfTUVNT1JZOiB7DQo+ICsJCXN0cnVjdCBrdm1fbWVtb3J5
X21hcHBpbmcgbWFwcGluZzsNCj4gKw0KPiArCQlyID0gLUVGQVVMVDsNCj4gKwkJaWYgKGNvcHlf
ZnJvbV91c2VyKCZtYXBwaW5nLCBhcmdwLCBzaXplb2YobWFwcGluZykpKQ0KPiArCQkJYnJlYWs7
DQo+ICsJCXIgPSBrdm1fdmNwdV9tYXBfbWVtb3J5KHZjcHUsICZtYXBwaW5nKTsNCj4gKwkJaWYg
KGNvcHlfdG9fdXNlcihhcmdwLCAmbWFwcGluZywgc2l6ZW9mKG1hcHBpbmcpKSkNCj4gKwkJCXIg
PSAtRUZBVUxUOw0KPiArCQlicmVhazsNCj4gKwl9DQo+ICAJZGVmYXVsdDoNCj4gIAkJciA9IGt2
bV9hcmNoX3ZjcHVfaW9jdGwoZmlscCwgaW9jdGwsIGFyZyk7DQo+ICAJfQ0KDQo=

