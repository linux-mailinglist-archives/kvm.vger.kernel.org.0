Return-Path: <kvm+bounces-25520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C9B9661E9
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:42:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E331E1F255F8
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 12:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAAD519ABCB;
	Fri, 30 Aug 2024 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="liJXQG24"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D6619993B;
	Fri, 30 Aug 2024 12:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725021728; cv=fail; b=D+qHcfgiNuouMNfTuqZzjo4bKJMDHUq54zyRFpBpn/98oCwJ9uFU1slZTipqeb4d/XJn92OzDxV3D/ohWxLIk1pM/rX/Kv0u/0Hd6xRWDH5k3KDzC3LyRi0fC+ypKPeDK8UsIfEUKgcazgFR3d0PBHWlvB0McoDb4fVgFCukxDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725021728; c=relaxed/simple;
	bh=j6ptf/rlQSyuG+u/e/h1BOfuEIPYR3LcD9QOzKTkUe4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ogF5jndpUdnwEBJ6gvfhLFnxw+C7SI4UDvx/+AbtB2zpgWKqPC5ySEDSioxZLjIYIM0dY6lsyZZ1moHUIDOotvok3TYwkUCk7xuT3LWOw83bt9onA51PEqURcKNHKg/zoHjk1JhrC91I2ffhXf9V3RxwmMn/Tcs7kYmA35jZ7nM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=liJXQG24; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725021726; x=1756557726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j6ptf/rlQSyuG+u/e/h1BOfuEIPYR3LcD9QOzKTkUe4=;
  b=liJXQG24VyqHMX0wIl89QmF4kov1QpmtnqgKL662BLJOzqg2c2QTGFoi
   zhNiCv4ZD/c8NOpLGoTJmGeXzV5lsj7u73sCHw9GBB89qEPtn1cAMw+bf
   cBexZNr+J+Fi5K8AaP0uhDha4TCQsMsfrUnNFbZE8+UaVxfapcvqGMTNe
   e9sivHRWxCrQIUqVZDG4qy1+8c9qS7HuQcFctbBVtMBIYr9YftUSEQGek
   uFFPq9u2EYy5dUqA5XAxml0g8XN1omwgX/DGZHpeysXC4+ooaqfLaFmQU
   XgR+dXbJBLSZzXzy7yAsIf6WoQWYbPwC8iCRy0E0lQE1nL9KcRJVbWf3m
   w==;
X-CSE-ConnectionGUID: JXti+8OqSricsimMxzQ8zA==
X-CSE-MsgGUID: Ep/P1/LmSqy2+ymgNAQsJg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34822192"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="34822192"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 05:42:06 -0700
X-CSE-ConnectionGUID: NEDJRp6XR0KFDiCoAgJlbg==
X-CSE-MsgGUID: c9jYPQHPSd24XHcaRidGKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="68737428"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 05:42:06 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 05:42:05 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 05:42:05 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 05:42:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eg4meMkK176gc+uUbgjh4+ukVkiD4So8+CjB/C3NtxGhOKnEzk3FeJLfcxXkDidRFuEN2zHQELxZFPrdVM8ORO7xn5pF7c9fGVnn14M5T9dDkDySwaTYA9nO9Gq+JAkna49C9WZ9taaM2Li13Fpq4eZHhC2eohPD15DXcvrXgYqOf3f1qmD68dZSijgi4+TTBVtN5H0ln2C4Ud2r1541FNGsBtrNI6D+8OfleLzrHR5aTzC0wHZ+hBsVzhbXMM44Lg0ITO2PTHQh7A9oObW6+Roj3DwrpOZYU8KbvlwwYA7f3t/d1sTMF1HUh3dkX9/pd0XIr2d9b5dxNCCt/ju8CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j6ptf/rlQSyuG+u/e/h1BOfuEIPYR3LcD9QOzKTkUe4=;
 b=Ru/ZAca8t4agS0B98DuTx7irqeOBznAgqnkpp1O1ymZYTB/OLlLHcgFF93WhrjNsY4y5/W1qKFReDkazUSUHdzSzxaDWDOql6+rJxb5yNgL0SidF0Dmd08I6i00YgKLy25jB93+H5qVTWNstwJdQpylx3z0ug+eAbqcIKoOFAhqjrNWBuG/bf5nF0u3gT32S9uUSmv20x590ILBGImGca17vsJnWTM6TNV2nGsbq41sN5Rjpqj4uYU1zih+cTt4hCNyoVSpvHDMNE59jVuh6pbaDTC5HlZJKTpLcBKtj7tUMg2cIpICV1ceyMM/Npf5Po9nj2yxlKh5rodeCn0XyiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB5284.namprd11.prod.outlook.com (2603:10b6:610:bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 12:42:02 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 12:42:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "zhaotianrui@loongson.cn" <zhaotianrui@loongson.cn>, "seanjc@google.com"
	<seanjc@google.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "anup@brainfault.org" <anup@brainfault.org>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "Chen, Farrah" <farrah.chen@intel.com>
Subject: Re: [PATCH v4 04/10] KVM: Rename arch hooks related to per-CPU
 virtualization enabling
Thread-Topic: [PATCH v4 04/10] KVM: Rename arch hooks related to per-CPU
 virtualization enabling
Thread-Index: AQHa+pYq1r3JCuwhAUKTH7rS1QoUw7I/vtWA
Date: Fri, 30 Aug 2024 12:42:02 +0000
Message-ID: <2dbfc6066e32da4d2c847bf00260313ab8c5aea8.camel@intel.com>
References: <20240830043600.127750-1-seanjc@google.com>
	 <20240830043600.127750-5-seanjc@google.com>
In-Reply-To: <20240830043600.127750-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH0PR11MB5284:EE_
x-ms-office365-filtering-correlation-id: 70b2dc6e-121e-4dd5-3995-08dcc8f12581
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?QS81ZTZNSlR5aE9kckZQSnN6WHBxWk1YQ1dVMGxYdW1CZXNjYzhyd1lUVnQ4?=
 =?utf-8?B?VkhiT0ZhWW02YUN0MXBTbnZPZVR5L3VvL0JYeU9FWDBDUENxWWJhdmswUzA3?=
 =?utf-8?B?aTNLb3lrMGVqQlJFQVArRlVpOFc3Wm05V0lFN2pBNTBKT0xjUVlFUHhaUEww?=
 =?utf-8?B?Y0UxeW90bVlOQWRZYWtXZXRMcVBWRnd2VkVhdWpUTzl4WHVLeHkrWUFqQitC?=
 =?utf-8?B?c3ZXdnRId05OWExGZ0JKV1FsN1pJblRMWWl5UXRXZDlNMGxSTlp4SU1YVk9m?=
 =?utf-8?B?OGZ1WnZiT1FZN01wK0JVQ2JlK2lOakRoYjNmaDMwVmlYM0IzdG9rOXBiUkkv?=
 =?utf-8?B?VTYyUEhBVFF4SE5kVTdoSkRJRmYwUXBaK1NYdHRWcTFVeGJYM01zVE9Md1hT?=
 =?utf-8?B?TjZrSER3a0xxNlMyQXMzWUg5c0hpd2lYTWFCNlFWb01GSDlsSG93UXJxM2Nq?=
 =?utf-8?B?UmlFbENBZEp2eE82dDZ3eGVpZGplMW1qTGRXMDFycElvdGhSc2FGaUFXMm8w?=
 =?utf-8?B?VGZkL2FSTHpTdDZWdVRPdDVkcWYvUVhVSXBlUW9XdmU4c1ptbHcyUERuODVk?=
 =?utf-8?B?RDJKUHNhcVZiZlBzK2pteUQ4WDg2SFd5bGhZOFUwOHFrYlA1VTMreWxCb1Qx?=
 =?utf-8?B?WVEyekpOZEtXYjlnaHBlN1R6TkZwRXMxYS9LTnBzVTQ5cFVHZlREdzBXU0NN?=
 =?utf-8?B?TTJLVEp5TXVab2grOUVKbTBsb1orVW5IOFF5MXE4Y3NoTXQrQVZQcGlsNnM2?=
 =?utf-8?B?elJ3dXgzVUlRNDFLcmcxUE1sUVJvOHFWemZpcHQ5T2s4YVVXVVBsaDRDOENh?=
 =?utf-8?B?Vm9IbU9pN2xGNUE4N2NyZ2tzQ25QcWpXV2VoVjZQVXQ4eTlLRnBSVDVQRUpk?=
 =?utf-8?B?ajVQc2hhRmxvbzFnR2lIZmRZcG9peGhadUR0SHVOU1czellJMWFRS0N4cnUz?=
 =?utf-8?B?dTVCRnBxb2U1WmMzV3FOWlBrQnZCRVZ1TkdPRFUvYkl0cmhXQXJ5T3ZvVnBx?=
 =?utf-8?B?QkxkT3RTYlltcmhsVlBzN1lOdnZWZzVZeVl4MU1Uc0xSMzB0bnlTRjM0UkVX?=
 =?utf-8?B?UXBVeXlFTVZHWUJrQ3BjVyttWEdDblgySXd4ZkdJTEFYRSt4OERjQkhkVWI0?=
 =?utf-8?B?clRJT0Zac25SM2tvZ1V5dHRUbTlxZGpnUkhxdmFmRmdHZ2dNSzBZdmFVVjVm?=
 =?utf-8?B?c3kyN291TmZBNE1xUFl5OUVrZXc0bE9ZL2lMUGdqVTNjVGZ2aDVCY0pNQnBP?=
 =?utf-8?B?MjZhSGFETFVBclNJSU82LzQzN20zbGRuZUxINWxka3ZJb1M1ckJRZE0zVXh6?=
 =?utf-8?B?cFNZcUovL3BpK0pnY3NzWG10R1dBRkZGU1ZCUnZUUjFkWmcwNFVvcGdPWGw3?=
 =?utf-8?B?bUZ2Wjhjb1B4NmZzaHE1NitPckhyYmtTNjAxYzVCdFdXcUpRVUk1dzlvT01Q?=
 =?utf-8?B?MHExZ3NHUm9KMU15VmNOMHIwMWJRWWhucXlTWXg2T0NkeFMvSGRyTHVSNnd0?=
 =?utf-8?B?NmlCK2xwVjdPcEUxWVNlQ245QjJ6dVpPdHh0Vk5nVSswb29SZDNGbnQ0aVk1?=
 =?utf-8?B?ME9XaVZUZEpZMmJ1Y09XeEUydmNIRXA3TTJ4ei9EVHlHYXlUbXIyeWhIRUN0?=
 =?utf-8?B?ZG53M0hHRGRDMllXUHVCTXlKd2p0d3R2WjlTcnBxK2NiRTVIMWxhTFdZMDJW?=
 =?utf-8?B?ZkZnMHlBMkJ1RE1pMFRvclp0V1ZHbC9ZMlFrRGd4Y2lGU0I2bEttQlhsWjNN?=
 =?utf-8?B?eVEzcXRBTmlMblJUK21NMUJnb2s1d0RZajNOK3hYUUZZMGgvd2tpUFFyeldN?=
 =?utf-8?B?MFVucHRDcWdhbkQ4U1JPcW8xekYzaFhDN2hqYllSODZUNW1vQjlMenRReW9m?=
 =?utf-8?B?QmN3akJxSkVZbkhkN1kyZkdGbUJzYVJOWWFEYjlyak5zRTViTWVVMTh6aWdw?=
 =?utf-8?Q?kJeRBejZ+mM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RnJWSnM0RDBCNTc3VDJBeEhhRDU2Z1o1NUlsTUdZSTNMaXdUcm5SNldIN0hZ?=
 =?utf-8?B?MVVLd0NNRXRkV0RGRnE3azlqQXZod3Zla09VWEFCclBrQWhGNi9xU2hiSXph?=
 =?utf-8?B?Qi9FQ1VhWUNJc3RwN09nc210bG1YdDRUK2hkTjRsSUlDZ2dOSDcyazdpWXEw?=
 =?utf-8?B?dUdHRlEwRUdhRkFlQ3g1V09UR1RTclI0RTk3eER1aWJ4YklheGEvQmREK0t1?=
 =?utf-8?B?UGNjNHUzUlRSQ2VFUXZuUUYrNTgvZDdubUFkdXo5dzRiUkN4SG9wVms3R1FI?=
 =?utf-8?B?Rm42SDFqbzMzU0FuaXZWcEpOY25Ra2RPVHZhZFZ6VVprRXFHb3hwN1kwQXFw?=
 =?utf-8?B?UnBIdS83SnBCTmFoa0todXQ4V1dyQkx0UEZXZGkyN2VrSFhCZ3kwMW9Nd1dt?=
 =?utf-8?B?bitlOXRjUFlxTERMcXBUbzBReFpzNnZqY1VIYnptT2s0cjNCSGgxNitOcDdM?=
 =?utf-8?B?N2pFa2U2aHhQRWZsWlJwNUZIbVJwV3U4blZUYnB2ZXpsRnRhUzR2SnJNZ1pC?=
 =?utf-8?B?VUExa3h5SEc4YTZqM04vQkFZblA5ODAzU1IyOTZ6bjNReTVUTDZENjBsS3dH?=
 =?utf-8?B?dEtjTXZ4Zmo3bVNEY2x2N0M3dFZWbWZBemY0Nm14bC9EOGxQckxjalJoWndh?=
 =?utf-8?B?L2FtRk54alh0ajU5R0VTTW01eno4alE3M3FWZThZRzh3VFRRYzJvREsreGg3?=
 =?utf-8?B?QVRyNVRpSTkxdFl6b0NSU0IwdmlhcmE0N3huUkx4UllkVitiSUpBZDN1TjVV?=
 =?utf-8?B?YjhmclhwRjZFRTMzVGRXTDh1eHBMdnFWM0NqMElacDlPa2RRMno1RENmM0Zh?=
 =?utf-8?B?NFNnVkttd0JzTlQ3dk1mVGRHR3hZNWdQejdIcVU5WVlpYkNsa0dsemVqQlhs?=
 =?utf-8?B?WFF0V3pvbjRJSDVZamZlU0JWQXhFYWtjLzJEZTZCL1hWN01CNWcwTS9PZjJn?=
 =?utf-8?B?NzAyczN0V0hrUlBjVWVOVUZHOFN0SitWQnVIT2RRbm4zNThNVVBhRGtuTEl4?=
 =?utf-8?B?ZVJka3RJME1ZVDdtT3IzT0pEbGJSWms5b0hXM1hrc0swK2JNVHFicHBsY1VX?=
 =?utf-8?B?RkNzWUtKQmlVZkZjRmJhVUNjYnhHSnNtcHAvYzZ5YTRiQ1VNQkdhcDhaNlVp?=
 =?utf-8?B?QloyMmU0dTZtUm5wUmhXRFhsaktXLzFBR0w1M1ZoazJvdUtyeWx4cWVHMGlv?=
 =?utf-8?B?WnA0ZjFCRUNvM1NKZ0Q5UDNTdFZuQklWTlFqSVdzczhOclhmckgwK0NLdTNt?=
 =?utf-8?B?WHZtejJKbnUxY0R5RlZWMTJRdHg1bk5pTWdXbjh4aUJ1QlJBVFBtZGJacCtM?=
 =?utf-8?B?NXFnc1pkOFMrY2w5VSt3bmwxOVpMZ1JjOHI3TndWQmF0N2JlTHRqVEF0b0VV?=
 =?utf-8?B?NUpjbC9GejdkZVV3WjFqcWFnbFNBVWNmblRuVS80b3RMK0hZRnJ0bmFnUkh5?=
 =?utf-8?B?eUZjZGV6UzlmdloranBSeHQ4ckw0M3premRKRlRaa25yek9sSXBQNVREeWdH?=
 =?utf-8?B?dnk5ZUpHdlVzMUU4c0hZYUk1YXFNZTFaNzVRdm1vNWFFbHM2WW9HM2VQT3Vu?=
 =?utf-8?B?RWI4MlR1TVpkWWx1UzFHcGw2c0VVd3dZRzlBbVNsUTBFNnYweUNkSTd2MUlF?=
 =?utf-8?B?bWRTakZlZ3BBY0JzSlBST0l0bmJXUnJnVE10MW5pSWtVSDB1U0JmNDNsYWhC?=
 =?utf-8?B?VmJzSGZqMWV1WENwS2JDeE9JRUxHZ1JMUW1DK0E2QkZPcFZPZ2JsOWZFRXpt?=
 =?utf-8?B?THJmRHMvRVZKNUtoNTdpeTg1UG03dk1EZk40M2xTUFU1MDdCQmorRVFpMGNY?=
 =?utf-8?B?emtYUWtpQ2pCUjlzL3BoOEpyYXEwcm84ZHB1QVFvVEV5OW1MTWkyLzQzZFpr?=
 =?utf-8?B?TEdqWWlwWFY2dXlXbjI1NnJNamVGaW9QQTRYUTJsa1NvUlh6ODN5NmIrNlBp?=
 =?utf-8?B?bzRMSU9uNEErS0V4eEJRSktFQm9yL0d6aUNkWW56WXJRVU5sNDd4aUlRUXM5?=
 =?utf-8?B?NnJRRTVMNkN2SlJFRDNvTk5zZnBQN25sSW9TOFh1WThYM2prYm1zRVIyZWV6?=
 =?utf-8?B?djJPQVl2SnRFS09iUzNiRUtvNjFrd0lQaS9qNG1Sc2VJZXVZTWJyeUhya2dl?=
 =?utf-8?Q?X7xtRIn51kFTy1OBMVWb1zM6r?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2819FA10C9F7E14F998EE7A4CF7EFA83@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70b2dc6e-121e-4dd5-3995-08dcc8f12581
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 12:42:02.1623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1WbXOiT5iswqVefJfLxZwSHVDZyy7Ietw81fQOw4J3XlQyWkFI/211SUc1jpT5LTOay8XTGVdewywM46oa5oag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5284
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA4LTI5IGF0IDIxOjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW5hbWUgdGhlIHBlci1DUFUgaG9va3MgdXNlZCB0byBlbmFibGUgdmlydHVhbGl6
YXRpb24gaW4gaGFyZHdhcmUgdG8NCj4gYWxpZ24gd2l0aCB0aGUgS1ZNLXdpZGUgaGVscGVycyBp
biBrdm1fbWFpbi5jLCBhbmQgdG8gYmV0dGVyIGNhcHR1cmUgdGhhdA0KPiB0aGUgY2FsbGJhY2tz
IGFyZSBpbnZva2VkIG9uIGV2ZXJ5IG9ubGluZSBDUFUuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNo
YW5nZSBpbnRlbmRlZC4NCj4gDQo+IFN1Z2dlc3RlZC1ieTogUGFvbG8gQm9uemluaSA8cGJvbnpp
bmlAcmVkaGF0LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vh
bmpjQGdvb2dsZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdA
aW50ZWwuY29tPg0K

