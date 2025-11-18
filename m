Return-Path: <kvm+bounces-63440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DACA8C66C72
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 02:05:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 554EF4EC1EC
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 01:04:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF4B2F99B0;
	Tue, 18 Nov 2025 01:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bPR3H8F7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D695EEEB3;
	Tue, 18 Nov 2025 01:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763427869; cv=fail; b=HPUZ0sJuoufxFYCVkipmxtIxtbYgbfBppia9PjoFpQXVluSZ8A1qvQNnRzY0I9nfjz9B+bnWQgm66FOTGBuGx4aVk2mjq4QREZqnnFrvrttqPWRHAeUSIn27+9Lw8vFIZB6HPTRrMP1BC3eqsC/PjqnchVlASF7qK7rXZQUbyOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763427869; c=relaxed/simple;
	bh=v/QQszz/CXQyzKDfqqxsTBVwoONbPEEIz6cMf2iOT6E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AhX4ECoTJKyPhKY5MHczIT0xhL2JEgEEUhbM7sT0srQSOYjMj9aOcl/0QnIKTp290XT3ezMcKjOXq1WwCWddi7li1s380cvNeMHwXOIeHbjL+bbfdcIIMtBxn1brkWz/7KxPETaAxmuxKN3jnBrom1uIEndROojeLLNr1iVU/nA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bPR3H8F7; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763427868; x=1794963868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v/QQszz/CXQyzKDfqqxsTBVwoONbPEEIz6cMf2iOT6E=;
  b=bPR3H8F7J2J1tKCCc84h8XfQMGuVuVn85U4PKVa9wkYcO1gBZ9BiFn3P
   1G/hBZ2M8SntP48mzx6cNtyqYDjd+xD2P9upBzRfLNMtd5NqUxZAndpr5
   drt6ZAmNSyMBCi/URYkmUU3E6JEamwx/KNROIIMzHy2ZDtkmuoKNdJ3x1
   tZWmf8zdpdcDUBIYw+CasUjU/SxtV0sAYFUTJAeoCbRC8N0f8Z5hivslM
   Cvi6BFgyQAsKotWL1NzEU+5ZL42bz0z1MfAXYKHM7LZomDplTQLON/wtb
   xLUZ//8UdPVx4yBF71H2iASWwFZ6qYcI7ffEHPUEqXT1QAzimIGD9kwp3
   g==;
X-CSE-ConnectionGUID: HzbsBhU3Q7Sk/JLIM3viCQ==
X-CSE-MsgGUID: vsH4pH+zQ1m3FyFS9Q+bGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="75761229"
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="75761229"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 17:04:28 -0800
X-CSE-ConnectionGUID: Sg6btzwmS0S9staXWE8FEA==
X-CSE-MsgGUID: 7Qv7VFN1RSupFPG373tteg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,313,1754982000"; 
   d="scan'208";a="190630594"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 17:04:26 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 17:04:25 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 17:04:25 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 17:04:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ooOvTGZD3wCijrH9j+xpSvSBHFZSLrnmXmfXDrxAZYn9BYsWaw4XCWBki/kZLJrF441J/Kg8C/q+nADVKHlHZKFTpsI4pPoeuDO71xADXoaNGMbO7pNDi24u9DWBPLEE7FWHAs4vSlfXvif9MUugxuHwxrujCj1a4OHa9koju/2ytJ0xqZnJ6mbBPV6SofbGbDlBqmLFO8s5U4IeMDoJL6iyXT9pdh3RShs2sGt1YCTjwz8N5mSRBxCmrSUmH3ScC5M0f0yMzeMVrwzfxwgZHSzSNlwgHJ5zSSjS7Vfhw9OLgZNQzgf+rw7ra4pcJYAveLoWS+HtWioNadN+8WZnkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v/QQszz/CXQyzKDfqqxsTBVwoONbPEEIz6cMf2iOT6E=;
 b=CCRK3pYWs3xDJRIyiZMibDaF/cBE2p325yoXvk7LBCMDJU8qgdUG/Xec54droGSfs5Ld539ULKVupOnPrKizbTCEaDJMY8pIGlaU9N6KLQVgpJNn923FU0+fZqOdzr3QODY+JPVrmJSrZcD+QaJjq665dfDz0oUjr4BypWea3psSNmut4R1qipQE61wGlOMs9N76sLXbhdYfdpkI6/TOjaXpnpw5LJZGtmJxsGTrBuNY8DlzMTaI5dxSXuM9zJaHjkKbq2H1gZZauXZIFAIOSjj+vv+EF1ylFucyUSkzKFNwD5amP9XcqzFwR/6TYK1umqVbLkl5SD+VMnb8jyq0lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV8PR11MB8511.namprd11.prod.outlook.com (2603:10b6:408:1ed::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 01:04:20 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 01:04:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kas@kernel.org" <kas@kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings if
 a VMExit carries level info
Thread-Topic: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Thread-Index: AQHcB4ATc43XQ6PqxUuwXAgCtykiwLTt5ymAgAR4xgCABd+VgA==
Date: Tue, 18 Nov 2025 01:04:20 +0000
Message-ID: <6635e53388c7d2f1bde4da7648a9cffa2bda8caf.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094423.4644-1-yan.y.zhao@intel.com>
	 <5e1461b8e2ece1647b0d26f0c3b89e98d232bfd0.camel@intel.com>
	 <aRbYxOIWosU7RF1K@yzhao56-desk.sh.intel.com>
In-Reply-To: <aRbYxOIWosU7RF1K@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV8PR11MB8511:EE_
x-ms-office365-filtering-correlation-id: a3c69186-6c21-4009-2462-08de263e6802
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?d3FvMVdTWDBjZ0RKVC83MWVFMHJ2Q0tCSGtidVFxeEtwQzFtZFRJMG9Ubi9t?=
 =?utf-8?B?QXduYndOeFRCdXptaTVyYkhlVHFiK0dVSlRPUDVLUXR3WkdJVTB4Wjh1c1ZX?=
 =?utf-8?B?UXFxZ2NPKzUyNm5tV0h3T3NBNmRFOGd0c1RLNVZkRDM4Mk9nNVV0ZEFIR3F3?=
 =?utf-8?B?c042ekdodUJXeUhPTTg5WWtMb1FKZTBydjN1Q0Q5Y0tOZHB4TEYwb05VdlJv?=
 =?utf-8?B?enZ6MlVDZm40RTJNMkQzdDJVd0gvN2RCRVBJdVRGaHZTTmUwd2VMS0VrREF5?=
 =?utf-8?B?c3lLY2RRaVZJWndzWDQ3bVE4V1AxcWZ3NWNYUy9UdWdsbUJxRVZ0STV5VTZL?=
 =?utf-8?B?aEFQSXBrc040bDJwa2Z5N1UzMi91T1BLemRMVkI1STl6aWhsSkd1R0dPTkdE?=
 =?utf-8?B?WWVJRmhhKy9mbEdVanhOWDYyWG9hYVE4THlwOUQrS3BsOVBvdGJjM3dGazJ2?=
 =?utf-8?B?NzNtNjFPYnhqSVZxa1JlcERVbHI0TWRZYXVQdDhjVEcxWjhMT29nUERWWGli?=
 =?utf-8?B?ZmdiMCttenZ0RmRiTWJmNzZENUp1YUE1eGh1L2lSYmFORVFzcm5nY0VjY2pH?=
 =?utf-8?B?Q2g5M3RMV1hiR3VuTXdUM0VXeGNHbzhYNTBSVzlLYUxFREo0eldyRENHZzJ6?=
 =?utf-8?B?S1BTV3VxQTZPeVplZzgrcHA4bVNZUFAvWUJWWFF1b0NvNURPZ3FKcmg0cjlE?=
 =?utf-8?B?ZE1jU1JkQVBkSDJnTW5uMi9VdXE2OGtaaC9mM1AyT2NxTlVhKy9abHA4eHlC?=
 =?utf-8?B?c09RNWtuV3gwdlJ1SFo1bEUwaHhvYkxLbG9INkZFUUZUeURWR3BmWlJpR2ds?=
 =?utf-8?B?N044ZmNxRkZFWjhpTTdRMk44ODBJbHFUR2lDQUtaV0ttNFo1Q2pmTkRxbXVz?=
 =?utf-8?B?VVdjVG9tVHpCNmNHVmY0N3ZnSnBKQjRwTENxVUJQaGlDRGg2VEFoVXVWazlE?=
 =?utf-8?B?R1BRdnc3V1dkL2FGREdiWHBzQ2MvUnBZRlZVNEhOOHdIdkZ1SFVzdlhJemd2?=
 =?utf-8?B?REVCUFBiYktLZUxuYWdVaFJYQUUwTHlUZDh1a3FkSkRmS1dmVm9oQ0lWMGVF?=
 =?utf-8?B?UFBlWjR6b1AwdUJwMkxUZnNuS1NFN1dPL2FEeEZVd0o3VzlzU09wempwVjlL?=
 =?utf-8?B?VFpnWC9QL1hEeVcvU3JpRW4yZnQ5QzlJNU9MNDcwbzlidWx6TEhWYk42VHlj?=
 =?utf-8?B?aS8ydGp4dUF2N2JickR4Z2dUWnI0dW1YYVY1SDdjRElsNldzdjFEc3R4dVhO?=
 =?utf-8?B?MXU5UDVYWjBIcFM1cGtHR0s0dzI0RnlTaExhNFRFQ2lkZDJFNTIydjQ4M1Qy?=
 =?utf-8?B?T2hVOFlJbU1LM09QZEVHYXJTcEo4TkwxZURyeFlwVGtBSUE4Wm9vZEx3NUJi?=
 =?utf-8?B?eTcrTnJSNXFtZUo2VVFLYzdXbHU5Y2p4TzJhKzI1VGNKY00rNzJGeXk1Mmtr?=
 =?utf-8?B?WDJzTEx3OHJHejJWSDJ1Tm9mQU1vdno4RVFBY3A2Q00zZWJOeHk5NW4wbWU0?=
 =?utf-8?B?clB4bEQvYlE5M2dzK1grSXY2bkE3THd4bmVOTnBpbjcyU0FXbW9ReTkrSUJC?=
 =?utf-8?B?T09UQzFNRzIwSXhpUndtcUUxamdxU1l0QllFNUMzS0V6cENVVGREK0FMWUVu?=
 =?utf-8?B?ek1Sa0hlRERaOTZhTkFoQlBpbjhrN0ZDbVFKOTFEWUFzQjJWTlpGTlBOeXNp?=
 =?utf-8?B?V0tSZjZOVjVzTW1rNDdEOGV3WUZ5N2F4MkZnVzRmR0VNSWc4dzEzZ1RTZVpU?=
 =?utf-8?B?bjdWc3NqMmcxak12d241c2xNOGRuUnhhN1U0clRuMzdETlhsbk9VZHR3NUdt?=
 =?utf-8?B?YnFGMy8wUTN5SjdqZmt0bHJnQTNDVXVLNVAwZ2tUNEJwYUszTC9tYUFkQzR6?=
 =?utf-8?B?cXFDM1dqcmtDSW44cDF3OUJYMEdEK3Ayd2VhWWJFOWQxZkV6bklwWGVrQkw5?=
 =?utf-8?B?TEZpRHdpdjJvbTZZc3E2VFBqc3RpdHlTOUppaDBLSUNrb0N5TGlwQnR3Ulhi?=
 =?utf-8?B?RXRwV0puekRIb096VFhDNFJTa0p3Y3dCVGU1WEl4L0FwWWRkcHIvUXlLVU1p?=
 =?utf-8?Q?rqhhup?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0ptWXdKejVtWGRVc2szUmZYdm9DS0szYUluOExkTlJSSk1pVWdmOWVFT0Q5?=
 =?utf-8?B?Y2w3TUl1a0p3Qmlsa2Vvcnh4VWM3NG90NDBlSHJkZHQwZHJFT245T0hlTnEv?=
 =?utf-8?B?b3Nla29NbElKMkpzNkFEZHEyY3hGaWhpYkZNbHlaSXBIcWtrNHpVWDBySmxp?=
 =?utf-8?B?d0RuU1RLeUxqMnJ0TTF6ZHJCNThTeXBIS2VZbjZxMzJtRnRSUk5VTE13RkZ6?=
 =?utf-8?B?N0M5enlGUHZaZVRlNEYreG5nZHMwSDUwdkxDMHI4MmJoMzMzK0F6ME1wT0JC?=
 =?utf-8?B?ZkxiUkcySm1MWk5QVEw0ZnViTXBOcjNmK3Y3cWZ2VUV1ZjIrTkpGcXdrbnhD?=
 =?utf-8?B?NFZUTFRJd3c5K0cyUEdFeFFheTB0ajV1LytKS2VVc0JyM0g5QVo3aURNR3dp?=
 =?utf-8?B?Q2Q1N2tCMk9ubCthaFVCakdjd2ROR3A2UXF6R21Ca3N4MUFmanZxaE9oaGlT?=
 =?utf-8?B?ZGwyYmRMbldndk0rN0x1L21pMWdWSHBZWjQ0bHp4SVpDNXFCNXpCVjZsditu?=
 =?utf-8?B?UTcvdmg0M1Y1MmdqY0g0OHZQVW9BLy9VK1YzSG01RFlSeU1FZmFrWEFpUVFx?=
 =?utf-8?B?SGs1YVVlaUdtV0hkTUNNUXRCY3crOWhCcE9XRVp3OHFSMmhtNWMwbVc2TVFN?=
 =?utf-8?B?cG4xTVZvZS91NlRVcWRTNlV4Y1NsakpwK0xZTUlJb2tXNXJFODhuVnl3MWM2?=
 =?utf-8?B?SHUyQ0NPeUZvOE5XQ2E2SVFQczd5Z0FUTkdxUEhZMUExTGNVdVoxV3Jqa213?=
 =?utf-8?B?VU1LZVQ4ZmpDWUxRMVF0SnVMVXdjc2pjRVlhNWxucmNjNGwxUXJzYXNTMWZl?=
 =?utf-8?B?MkhPbnIvNk1GekhBQlFwWnhBaWRmWHFDcHJtYnVxdEpKY2RmZ2Fpa0JLOVl5?=
 =?utf-8?B?U0xOakwvd1poTnRQMWhuVmtPYU9YSTVwNG5EMENBV0l2UkFnVFArOFg4eGNu?=
 =?utf-8?B?NXg4SllxNnhPaGR1UVRHa1c5UExDaFhTdUx5aElSZSs1UXVPNWc4TFdRU016?=
 =?utf-8?B?RlJxd0NzaTFwZlpEZjIrSzdwd21zY1dHS01sV215a1FGcXBhcFNGRXZSS3JF?=
 =?utf-8?B?MW5jc0JsaUFXWDJ6TXhuNENwMDFJY3BXMDJxdW5BK0pDc054TTYrUEZZWkhz?=
 =?utf-8?B?eFRma29UYUhnN3ljRVBEU3YxNjFEekVVMEloV3p0YU5WdUVPdEpnUGN3bG1r?=
 =?utf-8?B?WGJIYk5JNU1TTHdyWTA5c0tKNGIwbGdwM0wzWDgyNVM3RFYzQkhwY2poQ3Jm?=
 =?utf-8?B?aXVIZmdiZ3ZzL0g3K1MwYllRZXZZU1YyV01lbEVmRHMzTVhaZ0prNCs2N2lJ?=
 =?utf-8?B?bFJ3Q2ZqQlBWelVTOEExb3VSNXQ1OWhma2d5TWp0MTZ6UnMrZGsxMHNwY3Zw?=
 =?utf-8?B?U3dlRFhCL2tXMGRDSEsyOURnU1FxN3lXSEFGZ3N4d3dnV24rdkZlNGpJU2FG?=
 =?utf-8?B?R1hZT3cwd0xxRVFJRlN6MU1BU2VUbkZ0bkZ5YlJaUlNkY1p2Lzg2N0N0Ujg3?=
 =?utf-8?B?Wk52a0JsbWwrNjhmdjJZWGNtQ05Zd1JWdk1ISDQ2OGJZR2U1UERrQm90M090?=
 =?utf-8?B?NTdFcVpKNzZLV1N6dG90dW1iSno5aDh6dGxJeHFTZWlVMjJuaEJjR3NneXFY?=
 =?utf-8?B?ditZWnBUbXcrakFTdmZ1WUo0VjRabXJ1K2IrSEhMRnpnSHFjQ21xVk05bndr?=
 =?utf-8?B?R2VWNU1PTzJ1aFNzaDlhak82dG9VRGdPWmpyUDBFclQ5NkY2ejJXSVA2eWFo?=
 =?utf-8?B?MGdHZW1BMzI4Ny9vZU4xc054SFR1Yk4wZWFXOEZ6SUJUTXNSU2pNdnFTZXVW?=
 =?utf-8?B?NFRRWkN0RzZVTERGaGp3MDAzWWZpdHpWOHpaWDc4bVBYZWVXTlVwbVd4MFUx?=
 =?utf-8?B?WlBMNlZSRlM5amdrYW1zOUVtdjNSUlZyZmRzMDJaQVJ4dmxNazUzem5WSjVC?=
 =?utf-8?B?VWZPb3FRZjZtZnJlb20xckhtRVJGNEwvU0djdVdaMVBzZ0JCR2cySE5uMG5J?=
 =?utf-8?B?dlZiNldFUWY0b3Z3Tzl5THFsTTVVK1VXRzBmNGJYUGtjb2xOS0ZnWUx0N1Ji?=
 =?utf-8?B?V0xXYi9RQW52WEh4QysycTd5RFNCTVFxNzl4QnAxdXZieXBhdjBWZ3FLSW1r?=
 =?utf-8?Q?qGZfYATvYv2PS501WdIRAeDT9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2BA31C091A27142B53135C84294A840@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3c69186-6c21-4009-2462-08de263e6802
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 01:04:20.7587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L9Ir6b/jfASfxR3rot47vmUhrBXK/Y+0teKahPR1YpFRI64Iu0mBgQHzJeJZLPsuVQ4kygY/erFjiW3xaJvpDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8511
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTExLTE0IGF0IDE1OjIyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBX
aWxsICdsZXZlbCA9PSBQR19MRVZFTF80SycgaW4gdGhpcyBjYXNlP8KgIE9yIHdpbGwgdGhpcyBm
dW5jdGlvbiByZXR1cm4NCj4gPiBlYXJseSByaWdodCBhZnRlciBjaGVjayB0aGUgZWVxX3R5cGU/
DQo+IFRoZSBmdW5jdGlvbiB3aWxsIHJldHVybiBlYXJseSByaWdodCBhZnRlciBjaGVjayB0aGUg
ZWVxX3R5cGUuDQoNCkJ1dCBmb3Igc3VjaCBjYXNlIHRoZSBmYXVsdCBoYW5kbGVyIHdpbGwgc3Rp
bGwgcmV0dXJuIDJNIGFuZCBLVk0gd2lsbCBBVUcgMk0NCnBhZ2U/ICBUaGVuIGlmIGd1ZXN0IGFj
Y2VwdHMgNEsgcGFnZSwgYSBuZXcgZXhpdCB0byBLVk0gd291bGQgaGFwcGVuPw0KDQpCdXQgdGhp
cyB0aW1lIEtWTSBpcyBhYmxlIHRvIGZpbmQgdGhlIGluZm8gdGhhdCBndWVzdCBpcyBhY2NlcHRp
bmcgNEsgYW5kIEtWTQ0Kd2lsbCBzcGxpdCB0aGUgMk0gdG8gNEsgcGFnZXMgc28gd2UgYXJlIGdv
b2QgdG8gZ28/DQo=

