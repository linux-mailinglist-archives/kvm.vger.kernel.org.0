Return-Path: <kvm+bounces-32711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF569DB1AB
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:05:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2C762822F5
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED69484E1C;
	Thu, 28 Nov 2024 03:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AaEJcOYV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F3B481B1;
	Thu, 28 Nov 2024 03:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732763097; cv=fail; b=fALsIOzLJINCCVnmbnmS/oi19LonRjWn7vFGqoD7qr0PVmzhHPgd8fXWnJU06p8PRCyMqX640AazNeqRKVcy0UwzlbRr9vDYZxeaCP87HGfzMnK0x41+z44eLHDbvYkX8v7xPQiJAfw1+KAq/ii/lcshmIbfx7mXdwTeJmF5RME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732763097; c=relaxed/simple;
	bh=w4WWcYjJhh/5EzvMGM+G/BZA337KA0SwdSG8rZx1i/g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y9d+gOSkVeQlBIjQMgEY9iuATBFWWnxyKd8BPt40YkJe++5Cvc0FxMnMvDSGTdb0IRmoTCCtssUM7uDig7jNUYrAoqE+/PEZoqkyI9/dqPw7XraZRatc3YQfBn7AyJN/OLqvoqeTxn4Hoqz6Rj2adxpokTwJ/GlwEsVi9afwEvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AaEJcOYV; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732763095; x=1764299095;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w4WWcYjJhh/5EzvMGM+G/BZA337KA0SwdSG8rZx1i/g=;
  b=AaEJcOYV/0z2xNrsRMon3NIRJWsgsqFb2e5u4iTb53e0aQpWlGum6Shg
   9SGv0V3RbbUyQ5ijASHiIy3CRUP3DR3buVKtlmZrQolPHeXJcdj9+zTzr
   wfjb59cE5X7MUAo6dJtVTGA3Xb/Y/U4q1waFuBY470WNxF2dM3A1C5RZM
   Ljvxtymt2EUtYI/GiIBg5JytwArV45hDWlLfVh5A1TpBayw55gZt2tAUk
   jVnOC3cOJ8+KFyt9Ju82gAD+U6GWnVti3x17dOBCe7Li9VUyKhEzT87yj
   HH4x9YI7nQtYOHi0qbzR9yS5oM9utSiOH2VqeCtQN5UI+Sdow/GJzj2qt
   Q==;
X-CSE-ConnectionGUID: s0roJTTCTQCHMeHFvzrC2Q==
X-CSE-MsgGUID: 2p2rwsKXQdyRwgOpJ6hiZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="36649030"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="36649030"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:04:54 -0800
X-CSE-ConnectionGUID: Gnp6C03tQj+Tt+e0rI1G2A==
X-CSE-MsgGUID: QeyfeXVTQhGGUMKdj25qgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="123073450"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2024 19:04:54 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 27 Nov 2024 19:04:54 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 27 Nov 2024 19:04:54 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 27 Nov 2024 19:04:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l4+9fN93HSlwV9y2FEj39/ggHWiGy30fCfHfFe2O749IGCncR2o+5jD0Yw+amp6L6PHUtXT5G7IxMZBZNx3IIZskRHqS5aqmgd1D/dFt+SV4iBBxAMvrLKFrG4vRbyEZuBhsUrxdEcd2sSA7bntZgQcw2wZtuRVTGG3KgXky3NKK9wx2CAL0n6PajU7pqHU0bJO035iuqsMLIxhnuL3aJJV6ka2XQW/J3rkINaI5RNhLgfKs+n/bEknGDU9vj970ys3hcsXgMtObX11X7CHqPb6ipagOWh6tRohavlywbfCs5qne0FK+xoNFFZnFdrtCNczys6+jDFzRUBwKkIveDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zyT04bAOvvtNA/SPaFfEZobndbZHEGryq+9N/rWKho=;
 b=lw3jQ6rTzTC8/Ia6nnnO8858eKDtYPWE/867SZxpLkS85yUYTX/l+Aao1zjmAmQZyld5pb/aySzWqSFrhMlt63OoC0GEEJil03h2ISKIbNdxXyaq3r5l+ty+DNGvr6spJEaW+KzhtPMZVYKgLqoR/uuRMjY65jeXpeIv3h17/v32L9NXndwZiWl0TXUQCq8Z9ptSbODzLL3vnZu+Ye1uhxAIW1TkBopzc62fBZSxYV0L238R9uROmBdissinUBXjAiMOYr5wOGNxqHYnzsnUDsL2yFfEQHrGXVv/tiM09M4hbasjPE5XhQTv5vn0s3mn5joov7NTKYwnP/d1rR/JJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY5PR11MB6164.namprd11.prod.outlook.com (2603:10b6:930:27::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.13; Thu, 28 Nov
 2024 03:04:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.018; Thu, 28 Nov 2024
 03:04:44 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbQQh4pHKqsDBLVki8PZg9/3tBMrLMAV6AgAAAw1A=
Date: Thu, 28 Nov 2024 03:04:44 +0000
Message-ID: <BL1PR11MB5978022292C2AD296FB2D235F7292@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <20241127201019.136086-1-pbonzini@redhat.com>
 <20241127201019.136086-4-pbonzini@redhat.com> <Z0fc3Z6YJB20uP3G@intel.com>
In-Reply-To: <Z0fc3Z6YJB20uP3G@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CY5PR11MB6164:EE_
x-ms-office365-filtering-correlation-id: 932efcf3-1fb9-4cde-e280-08dd0f596937
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|10070799003|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?4mhaV580EkfAgpbiLxvDW+ga++1Bf3aywFs/429X2dkROwevl2OHHn9YAT+e?=
 =?us-ascii?Q?MwhQQUf6oEr60mBlCb52yxax0efTJGYadRifL9QVXCtrtHIZShQ+871PmT7P?=
 =?us-ascii?Q?X7NvOzRAbXsu3FCZDyLGZ0XgWKa8ajHxP1dNklxSQOlzc0/168NshRCh+Cid?=
 =?us-ascii?Q?INz9hR9+XJAYgXQwg9qhx0EzsKY6aFAzxkQMVoPzxurRAwLbldmR89G3N1ES?=
 =?us-ascii?Q?+iiWT3trjI467VzYbZyyrICzEq6bhxQoszOeFCi5dNh2VjbPK+E+wMQ+XYK9?=
 =?us-ascii?Q?ECKF5Dr6GOy1US3q5eILjuoVam4uaS32OBWpBqrpHVUuG/+bM2k8MxTqRluB?=
 =?us-ascii?Q?fLrKxjm3k/dS00FkG1SZ/XSYNSl4P8d9TP2KZmcHBj6baDTwfql2pXs1gHBO?=
 =?us-ascii?Q?qr2dXUB8cIoRisNtx5ZpXaSbfBVYlpih5nTNm1LAzVbojkQLFUbBcUG3Kgi4?=
 =?us-ascii?Q?VhQ9UIaoQySRW6V2FZRjkTjKDcWMv5wopt8MTy4cfgx1MdYz4PL2Nu2VEBoN?=
 =?us-ascii?Q?W32y/ATLOAVZAiGlJ8Dj2LcYPtIlI5/azE7ClhKLzrxEZglkIMW4CVRgffJh?=
 =?us-ascii?Q?2ZBTuXh6wpLk07pw0hT3E9zPUM2ax6e9E9i5YO59zd7t0f7VN1y4A0QY75IU?=
 =?us-ascii?Q?VqQDM+NKfsjN310eF53DuiEkyUgnSdza8dj88ICDo19u/jRWH+kZMyMhgz0g?=
 =?us-ascii?Q?NAMWzAef7Om4q+90lmfK1NUcpbzPesUE2eEzFumg2KVH8bpMDpbWkaDmYwse?=
 =?us-ascii?Q?An0x54Rja5YyxXsEqiLlYKaWEH19g7A2nYgJQEGXKPwdqcOZvqgqwk9I2ijo?=
 =?us-ascii?Q?XEogCAKfadkVssYv6km+GNVoNPUu1mXE4rauhA9D8URE+eJCOpZYtXhlrUAb?=
 =?us-ascii?Q?KYavwq3+8uiAJWwfvZNOIt63PN44HxBhugWzatdGyKGY2D6QQpbfl/3YJbQ8?=
 =?us-ascii?Q?0EGniqWxAOkyetEAK5mYzpzmPgV2J43/SoAmiEruaUNT2/JP52L8SvyBcMtI?=
 =?us-ascii?Q?ddHpWnp1m3U1RICEw/H8iDRafg8UWAt1TCDYAl+Os+ZRVvGRqkNlstUWaB4x?=
 =?us-ascii?Q?s7KDweWykOlZ38VARYQ3Ty/FXhgLBgHBR5JJAV92EQ0+OYhbaHRKFOy982Bm?=
 =?us-ascii?Q?LizWGbiKTIZV0hZsTfLzVPYJyr1YKJEH6vdiOiK3q6+784fnnibq/cTMTw3f?=
 =?us-ascii?Q?aEpL647xPX5E9xDeN77GTxMlblrmpKZUx7iolK5lPURhg/QZ0t9xC+06exRF?=
 =?us-ascii?Q?TBj+JGksPGn6KMVrKiB1B0l8u6vqGOGhq4u+y+i3EicbsVbhJCnjdcrL+KXm?=
 =?us-ascii?Q?ffJnZwE3TH7ikG5kD5OtGhXc4h38gmv0AO5pUbIU1n5AwY9qJVhK6aOZCOs0?=
 =?us-ascii?Q?Xk0cxUR1L8DvSbZTGfkTLQaqYAJ+Lg5gbXOw6EOtxd1icT9tIQ=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(10070799003)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Pz7Y7QBtFyLPNL9AdA9HGu4FO9+7dSUcXxO3ZoCctQM+azpX8iT1SPyzb1e3?=
 =?us-ascii?Q?k9z1Nmy1EH0iTEjfUc7PL4d8QDBo2/24gRMV7T4D/OD+TV2IkhJ7rKCOPhL+?=
 =?us-ascii?Q?mcHvY3RiE355TjouX/JVa8mkju/cAxRsjiL9r/m1xSsAjx6U9Xxiflk2jRaJ?=
 =?us-ascii?Q?tuVqe5ZNbjWFrKTv9fhYkGWlmaXqWK5XwLrJtr7PoLwmyVIpiPi4vj17HgBW?=
 =?us-ascii?Q?oaDGr3BLyxppg2+3bGz8vhtOgOwCL578gYrtPNDIyx/r1uUaTteS1EG/ZM8S?=
 =?us-ascii?Q?NuKslyVXZpWCueGn1AareE/EkKZOhfCKpVkrMZ/y3L9Zl8CWD46fdkHHUEjh?=
 =?us-ascii?Q?Kp74kLfhkpEJDx/43DCDd2pV8qq0yl2sWnAp62goztC+87L/W+B/hbDqUtiy?=
 =?us-ascii?Q?TFBZDcfwrSHWx4OOAVJGrizMc0sp7eyx7DkgLbtKLXnZeWAJqMHUQuYaW/uh?=
 =?us-ascii?Q?aMRMZHBialXolsF8fpeLe5kefTSnoP7zlGFsd0NqhQ50LJAQ5lff1qaS8rr/?=
 =?us-ascii?Q?/WTONLzdte8aOP6SpguskFcpe8Psoe3xU/17ponpAX2gkda7QlpjsZ2K2bm2?=
 =?us-ascii?Q?jE9Bsx6/uZf4LDGaUksNv1sxZf2LF4T4Pq2kd59iTdYIkDLOj01hxV4b276K?=
 =?us-ascii?Q?c5vmT/0qU8JHbjedlBIT5HEhrGD3tEkTat5h3e8TDJEm3LQtRVobBv6mRyuT?=
 =?us-ascii?Q?r4bv0Of9Jb36cb3TU5vHCHwwvEKGfqx//lXOrAJMwrdylfpGvyoN4EnSt1rf?=
 =?us-ascii?Q?GMMvrdA6MZ2JuEd7JMHBKcJFR0BK6w3PEV3upDCnPCOGy/v/zkpSJATW4RiK?=
 =?us-ascii?Q?D3LEWp3k4znM37A7ea8NJl0Zl7jwBJKSJINmXrfaGLYjSIbIDyqgh79bCYc3?=
 =?us-ascii?Q?GAPhhjjcWRlk+v7V/cSNZau04FHMx1avBZBpR7p/NEWTSMsMOij6IdkDuRCB?=
 =?us-ascii?Q?QvrPp8llz1qmTfMKWDAlUb2mYfld4hQePdSuPehgHAW80ao2D++R16OreHUY?=
 =?us-ascii?Q?11BJo5IFSD+MGsmBY3PNStjWNTi71iBHrPq/fi/T2YFGkZXV69o99UniC65O?=
 =?us-ascii?Q?zwwAObQRJihHLi8r3t9m6rQ+HtSCgCYyGDsJg6lev6eWJ0Prorn6sEAs5/zR?=
 =?us-ascii?Q?FkGkt5MhEqrotNGUQKiU2zG3kAQPrEE+t2T74Qn8VfdiuxmZjiLDHEmW3BpZ?=
 =?us-ascii?Q?qizqF9sTvU/vmiWp1Sm1rOGMwLV1/YDCtW/yE+dFlnCpHYKzI6kKIGeZvggb?=
 =?us-ascii?Q?4zC12pv5HU/cszCJKMOwC14IBGY4IiVSCFGaS2ZhF1jGJVjzRIPW8XqnSpFl?=
 =?us-ascii?Q?96LxGRaVDvWdLyr/kF/mPPDZyTqzfFFzysrej8pLC/8pC1OSgRToBC76y8/L?=
 =?us-ascii?Q?FKk0GZcS0PHuoz4p3QY4j8a6yJIaBm8XY2hYs0buFJQg7VKyk0qdOkNsY3GF?=
 =?us-ascii?Q?PIwDobrmUisr20ByPkgxfKtkPssSilj12FzbWV0kxjeSSYWeDczpaUCDOD4K?=
 =?us-ascii?Q?Syw+LLw5/wJp4KCEQaAQVVTEh26jASZm0HA3Sz26DCFqB9RIkifkDt2CH22t?=
 =?us-ascii?Q?9P+Q7dPnVNfeu0AnjTmsrPuedfmHhOpyvR+IB3v+17jCATnZgojjJbZCf9pE?=
 =?us-ascii?Q?f4TkmfwYn58S4DuGka/b22dyLZ9kvCqz0Cd6nWi7slsk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932efcf3-1fb9-4cde-e280-08dd0f596937
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2024 03:04:44.8020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ohSyIlZJA8GV+fiRXOu7fJadTCVm5V/q0ln6aJlstZEBZahDfnnEXPA+Z4EqeaHdFLc3AOXwWI+gOlOjClbm3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6164
X-OriginatorOrg: intel.com

> >+	r =3D tdx_enable();
> >+	if (r)
> >+		__do_tdx_cleanup();
>=20
> The self deadlock issue isn't addressed.
>=20

I planned to send out a new version after merge window, but Paolo beats me.

I have fixed and now testing.  I'll send out the fixup soon.

Thanks Paolo!

