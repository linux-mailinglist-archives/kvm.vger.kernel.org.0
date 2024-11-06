Return-Path: <kvm+bounces-30852-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B65AC9BDF82
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 08:38:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 758532850F2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 07:38:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C426B1CF2A6;
	Wed,  6 Nov 2024 07:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LXQwlaWq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDEB199FB0
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 07:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730878728; cv=fail; b=uDiZyi5qnZmvotB3oYxG/JVQcwX2Mlxys+lGMVWUVn48fxkNCvfK9vvo6JJCEhZHKi/pKMSit04qFa/k8m1hyaoHHmb9hBvVHjW7+Nl8ACZZJrmtI84f+UoWol935Yxktt3b319+riztMS9/2ynIaIxgWTAGvGIShwXkvnuq/b4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730878728; c=relaxed/simple;
	bh=vIuJQI+GaDwB9dEV5Ctyt+cL5jtALvL2zj6ivBET61o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aa9Awy4wsSYrg+rKlZXxvPHQu4waQtPqY/XH3VC3Qu7nhPBeflbFPobzP81Xv9BxlyrzBQ12UtfR0W7V6MJ7yJewztp2Lyxk03LGVfG5NPwc6Dtbq286lDnXhzPr7XSI/w3/nsJJflni7pF2Il4PO3CnKCa8ZRq65kMs2z9V6N4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LXQwlaWq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730878726; x=1762414726;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vIuJQI+GaDwB9dEV5Ctyt+cL5jtALvL2zj6ivBET61o=;
  b=LXQwlaWq5/q877e3Gqr5Jz1f5dy779af5TCp8cujkcVEtV4/2PQ7/Ttl
   dWanM1aYrGivxlBsXdgEyVzSXjycUvydRZjGWPySWe7RHAZq8ImZO6Qmj
   KlIcsPofqZdH4EqEGDGHHUU0N5CyrVJSyWJ71pVzKZtAuPg5ZhmTxB5L5
   /3FoBux7LvauQmKQWhhP5xTJaj2ktQy8cRA2rbPHF/3Gc+W0sweNUdXoV
   onjhjeNjWjTa3USiOTKtYesn/iBJQc5+i2R1YqDxlDf8DuxLlgo8zqFRw
   Qkj+7VgRrUf4GmeMev/DuDR5t4eK79f6f+36RoWPFGGdBwjftTKdtO6+6
   w==;
X-CSE-ConnectionGUID: UAo8WrgjS82m6OCzRieHRg==
X-CSE-MsgGUID: UhGaPjQBSAKYSyLP8Clzvg==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30769557"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30769557"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 23:38:46 -0800
X-CSE-ConnectionGUID: 5gIBQSZySIuFxdZzZrK3Ng==
X-CSE-MsgGUID: uS11bEQcQ86/I40OpkPMIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="83927893"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 23:31:35 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 23:31:34 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 23:31:34 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 23:31:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UtiUyZhRgy7uevxjL4pgzTnJBJC8dYpZSdqhGuc+zR2jkAeKWg22nbMcO6OOCcfhlre2a3/uLeG04jEJoPYtuaQP+ZCTY8QZuc1pm49DYZ4jbeiYP9e3QT74JtDR+bYnUNYw0NOCV0wZtjVt7hVChvnKiTYGmEJCnSXZx9P4cnvr7iiZUcfjrS67wVM9YEDrgLUodCPfV9de/9WE8DzUy1RAK1u0I3/4+OHBQDpJmTvTBUPMhAUR/cjk6w09fVI4cOqkKgHbN7ymLpPLq3KgSn4RHlVzzeCCsujliB0g7qk9CxDcvS5C5J0HqHC/rze7V5h2Qn/JFou4vJCO8J8b1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+rvOT7/wPFcC9Z/ICM29WIsAK1BmZVFxwyxsh5/73tw=;
 b=VHMZRPbtt3z5QIcQGFDUDa3gCrNgw7qkyl4ax29QtZOfzCMjzO/VOtRHaAbpxgKkslDqrBfYaqo/fSld/i8md4xzbmPCD0EVW6LcgveTfIAZ1cGT1vYIwbUjbPcGOHGWUX4gUM+5kju9/93PHh5r1KA9N5ucxD1Ir6qCtdWnw6RUuOiqpyjYy+qC3CIVgAPqex0mJAyMCUqvpwfRz2IxhQW+WN74GuAeJ/XGGvo7ahLmSFpQ+1e2KHd+abfZ89rECPtjuc25SdEPKIZsBKisk5hA3BIohMNI7cTY9PCyI4DyVpa1VGmgn0zfcUlP0SgqdrhOqHVt6njrWa02Q7mxkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB6442.namprd11.prod.outlook.com (2603:10b6:208:3a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Wed, 6 Nov
 2024 07:31:32 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 07:31:31 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
Thread-Topic: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
Thread-Index: AQHbLrwadjuhsNo8NEGmUJt6qlMg6LKp2axQ
Date: Wed, 6 Nov 2024 07:31:31 +0000
Message-ID: <BN9PR11MB5276B9F6A5D42D30579E05E28C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
In-Reply-To: <20241104131842.13303-5-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB6442:EE_
x-ms-office365-filtering-correlation-id: 1f547ddd-98b7-41bd-ee40-08dcfe350911
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?8Eb8fEQwmOsghyAxmqMW4vyTyyzKwJlEGGuPU3Ust+xRI55xeveB474JHgLU?=
 =?us-ascii?Q?rQl759HaW9GzsKeNRIWVsSipqTSRe19GjoMCxzgPRrk2bIixoG74KV6M7oHd?=
 =?us-ascii?Q?X5/G3p8Vvhx12MJmBcFdlkZwst02UBpBa5ScLY6/71nMiLkzVpe/43rBXMp6?=
 =?us-ascii?Q?9R2schLpcOf3Zuy6DA75dj0P8zjzZ5qx1o5lHp9N4Ns7ZqTyu9LY4Gaqb5Jd?=
 =?us-ascii?Q?A9r6iypOb5JP521AfBg3TMceLcU3XoFmkE5CcSY4fYEgEKYEUS8CNxHiioRe?=
 =?us-ascii?Q?lk0V8byZ5yx6qMVz+wUECE8QO5EVvu+ziNZQGPigRy7pHcFuaeMsaleBe/cL?=
 =?us-ascii?Q?VfUMbYTTvneYl1SxUN87zhsbOjyE9RAq2hvNRP5kl9yqOtH82M0sHGRCl4m9?=
 =?us-ascii?Q?qETygukcLvEBQSIl2ZYe/ijTHl0gKxKblQ7DJApy0QhgilC3vOAqUrl/JH4x?=
 =?us-ascii?Q?YM/91uokAJXhzQANHLDpLmBh+RIxwcAGvcDG1nf6hDytDBS8n//MkBJshQIy?=
 =?us-ascii?Q?wwpzNjMynQvN2vSWwmRscDY8W16GkvsCh3k+zNTvMB9Er31RQzqDskwdbb/W?=
 =?us-ascii?Q?HfVvDllDx/S2H2oDKcuBk86i4bZw/YFheMeZG+grEpEurkOVG7crho02qyV2?=
 =?us-ascii?Q?0KJL0/BFtCRqOk7u8oWeLUDLCWQvPNYJaaQm0Nyc05ZX8ivbCMbWHD0n6eSV?=
 =?us-ascii?Q?ricZcHhAlxox06FRwc+Hi3UGyI8ux3NB2PpQeYQi47ct+KRBweyGd9nc178m?=
 =?us-ascii?Q?JjyPPlgnleBs/llR6LLEuH98SXc8Si++XVd8AygUGQ7v4HMefcxnZd+GBz8i?=
 =?us-ascii?Q?pw4ig1cs1rViNJ/4JtvQXjFGrwpHBEB6xiyf32TYdl8geXCkclfhP1l+Dn46?=
 =?us-ascii?Q?fPJkLqgcVSU5B5QWRb3fhKxXq6t8i1VTVcHUpz+TdpLGXt8ht0A4fysez4EG?=
 =?us-ascii?Q?JWVteu+opLG8ZPitnl7/tTj4jp+FlHTHfZiXpJNI3hKVhqXKtBFOjqcDiXHa?=
 =?us-ascii?Q?MXGDePUjCeaJYC0p3SVCPIJvJruETVjCgCKHYc7LiABMhWKyqYfs3bWEawTM?=
 =?us-ascii?Q?Xgnd9N+p8X0gNX1N6WJOaXURlwj0TyA5YPxnpmZ48QXjpAhHkPk2k18Xd25f?=
 =?us-ascii?Q?FPlDV/egkBujlLUswhg/GMLX0ytC6jIDwp/byTGXSshNTCae4F4TsRaVHY72?=
 =?us-ascii?Q?U6vq9ARAnhE2WBk0yamVSCAopjQ8o9kcRBTmdCx/DUC9G4fRnmAToZM40ldv?=
 =?us-ascii?Q?DYJhK7yoTem7Meuw/fotbJHirVti5ncaqRGULB648AxXv7ElQDmQh3/XgXzX?=
 =?us-ascii?Q?S5moEgxKGU2sb7v8Qlm/KAkrpGm5ZOj4msjOjRPozQaXJknQNsXxylldMaFn?=
 =?us-ascii?Q?RCEv9jc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?61710M8cLFkqbC4Bes1qahbmsrHA2av0mxX1aIE1rFYkT4WdzB9xxtxt9Aqm?=
 =?us-ascii?Q?PcTXsaVsSktgXBVOrCTJ9PtunJOMuYjaseOjBkRaqVinT/2xfQTEiMsYY25R?=
 =?us-ascii?Q?MFDJRCsHwDlGmYXmSGkW9/Wtq9tXWpYu9tCIZEYxqRimU9yqEL90dFDv8b80?=
 =?us-ascii?Q?U7/II94RjCDNYToWXEqDr9bDJPGdqUGgrl7ZaXv3wMPYBWWDQwwCmELvCSTd?=
 =?us-ascii?Q?knwRv/wNzrX2j8369BVJubbbu07skx/n6GdzMdvSz277mAFkPebJLEIxaKnV?=
 =?us-ascii?Q?Wd9PFfq9+pALIQhBHULE2g2aX9/VrLij2Gk3z+xcdo/kgpKz03otju9e7MhV?=
 =?us-ascii?Q?7p//GtJr7Jo8LpA3ZjuBsfvzUGUSAbiCXALpiwh9c+FwEW5Q3nIYCGr7ZKXo?=
 =?us-ascii?Q?fHudw/NIp8N+Q/ybz+o/uNsbYtGReUOquonkXliXTUexdXZMQDclxE+EBN+V?=
 =?us-ascii?Q?jYVeEDRIOyOehV+qrq2TYih+UNp12Xdkd2p+wIj1LtRQboygYi4z3H4et/2S?=
 =?us-ascii?Q?kMKtzPzi3/ADfSjgBjXvkcnorBROdHCYWt91ZsejGcuo0sRT94gusp4VUbkr?=
 =?us-ascii?Q?9OK9Karj3BNBBzWf8dXcv9Wl9PvbPRk0kzFBd2MbLMKZZSyI0zfwUW4uH5RY?=
 =?us-ascii?Q?HFRTADqgDOadbInXPD5vxegB4bEqOOOmVxPuNmuFZT3tSQGXPLOotZGnOyn7?=
 =?us-ascii?Q?QcrVG8Qq3IsVcmO7IvL8HmoPWMgM7vzMdzaVWuKGq6lQKjeTF80Wl/Rp7WIw?=
 =?us-ascii?Q?COGkRlDBAjHM9IATeFF6ZYMuJ4VXCMHaVJqqOsd0dzVi1Rz0UGb+48hS3FMR?=
 =?us-ascii?Q?Pgc6NwTTqG4zpEKFOTcThHbEhozaozon1HudLTyGq6F29TokYBRMJH/UvWG5?=
 =?us-ascii?Q?fOTOakVGNBfRFBm0Gp0KPdAh8sdAPZ8wz78ubcOhWI6+0gxQHgVZWY2A2mwK?=
 =?us-ascii?Q?KIH+KKgBiuoNCuHBGF7ieqpeEw0OBTaV0YtmslsUyXQbOsZrG/9WDtGADmoI?=
 =?us-ascii?Q?r5MtC7YBu2r3glmb8vpdd2pdRe67MKAQu6a3/qZROsGo+LVcDgy9trhsIiGJ?=
 =?us-ascii?Q?mqZ5zdIg67PyIJrX3AWoCHEMrAWeCPLw7s64E02TI+4hJ1luB46vJk+n6Hzj?=
 =?us-ascii?Q?IjQ2ODJYE8b+f/620ceAyG2RiDgyt+fqvmIcCpIanTrv6oY44dBix2jx8W+f?=
 =?us-ascii?Q?gcV8kaKqBlIg4qaG8IITJonzAJOy+FsMGlasfGf9SCFlYB85U9vItsvIepRz?=
 =?us-ascii?Q?C8XFOvTTPgZ25G/kWD61YeiqnSL6+HGyuQd8B1k8vuPtVwBsBNHCcZM6j5c1?=
 =?us-ascii?Q?spjxgTB8YVxz73aMKE5B8G6CPMRvG7Wm9YMl/QxjdizDXysYYR0MNk8WScg2?=
 =?us-ascii?Q?GGuxZFtY7yN3XkRdU03BPej643Jqz/+JCRxqyspKBV4nv+c9kpg31G1Gah8N?=
 =?us-ascii?Q?1V+sMIqv0OK5kvJtSISWluUZYKQt66acht45gA63m6ZYMztJ8oWNFu50xmGb?=
 =?us-ascii?Q?hG3nfTfcgrH2zpMMfbg5ymP8n9Y+lv7/qArSpCMjeIgIPVcays2rZz/DcMYQ?=
 =?us-ascii?Q?R7GkbvFwAiC03FQOIBx+shXiqvlUvvcEf1bhXMfO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f547ddd-98b7-41bd-ee40-08dcfe350911
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 07:31:31.8123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wDjowr3I3ceIZlWfohrUAVlujg8zoG+d5+39V8lnVhBhxI0RZUTtemnwkCWt6c93CALi6pqH3nmlH1jvYgNUaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6442
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:19 PM
>=20
> pasid replacement allows converting a present pasid entry to be FS, SS,
> PT or nested, hence add helpers for such operations. This simplifies the
> callers as well since the caller can switch the pasid to the new domain
> by one-shot.

'simplify' compared to what? if it's an obvious result from creating
the helpers then no need to talk about it.

>=20
> Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/intel/pasid.c | 173
> ++++++++++++++++++++++++++++++++++++
>  drivers/iommu/intel/pasid.h |  12 +++
>  2 files changed, 185 insertions(+)
>=20
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 65fd2fee01b7..b7c2d65b8726 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -390,6 +390,40 @@ int intel_pasid_setup_first_level(struct intel_iommu
> *iommu,
>  	return 0;
>  }
>=20
> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
> +				    struct device *dev, pgd_t *pgd,
> +				    u32 pasid, u16 did, int flags)
> +{
> +	struct pasid_entry *pte;
> +	u16 old_did;
> +
> +	if (!ecap_flts(iommu->ecap) ||
> +	    ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)))
> +		return -EINVAL;

better copy the error messages from the setup part.

there may be further chance to consolidate them later but no clear
reason why different error warning schemes should be used
between them.

same for other helpers.

> +
> +	spin_lock(&iommu->lock);
> +	pte =3D intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		spin_unlock(&iommu->lock);
> +		return -ENODEV;
> +	}
> +
> +	if (!pasid_pte_is_present(pte)) {
> +		spin_unlock(&iommu->lock);
> +		return -EINVAL;
> +	}
> +
> +	old_did =3D pasid_get_domain_id(pte);

probably should pass the old domain in and check whether the
domain->did is same as the one in the pasid entry and warn otherwise.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

