Return-Path: <kvm+bounces-36325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B57A19FF4
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 09:35:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95B8A7A4FAE
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 08:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EC1C20C023;
	Thu, 23 Jan 2025 08:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BuERGCXt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DFD1C5D5C
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 08:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737621330; cv=fail; b=dWKW3k8s4f9lXBM5dllP2dFJA0X/b2L/KaggYM0OKhgXIcwJf4MO9g0X21EiJm9AkLMrPZxgxMEv08DyGBpKVi0u6Wq6TEwdgL1Hx3++IlsMSvEvkI+ilikRvL4s2FLwWVr/Z7/yBXnhu2Cv/qS7rGVTo9HLzMKvRplAiVbia24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737621330; c=relaxed/simple;
	bh=fVrpCzQL3dRD8qHNHCmjJEaV044znRVUyIJV6oKOkt8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h1101EUkPBfX8sUA0vybWZYgG8FMLcz2Noi6KfZ2RT5gpPzoQecUEzKMaCEHoz82laVAjN4fSykkJ/MNTw6zhnPUOx+NKLGbKQh8aQCGsvoCkoJW0GBb5EzhFdMC89whNKbaUyHqs7Z36BBTX90wszhHwXtlzuuc1mAliigRVxw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BuERGCXt; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737621328; x=1769157328;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fVrpCzQL3dRD8qHNHCmjJEaV044znRVUyIJV6oKOkt8=;
  b=BuERGCXtOXi6b5Hw02TEA30blKvd6n0kbgY+s67K1HrK2LaI0kLP4gyR
   09Jf4oYIOVzxwuMOFHae0Pn5Q1FC9L1MZl9X+6ynrY6qoVnOM+3nMw85N
   i3SJlhL3d0HnjEtsHkI7Cooea/lhvNCPuTXQcbyWIPxw/PhUpN2rh+wMZ
   KLBjbTw3ZEy6hD/Gs5UINHJkRGsMpkVfImRmV2J5eMrxZTeRrGg8uHx26
   /6BMFJawHHa94YMPrioEO8h2duDJ4Dje/bPZ2Y9ThBo8oXZ0z87ou8sR6
   8UL1FElQGnch2eZLzYg8vz2ODRRXPBVyJG2nrHkmEA5plUiPSJlkk2+kr
   A==;
X-CSE-ConnectionGUID: z86nPXgcQmq7ocLey4sesQ==
X-CSE-MsgGUID: N42KZ3pvRk+HjHA3N5coGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11323"; a="25709555"
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="25709555"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 00:35:27 -0800
X-CSE-ConnectionGUID: Fx0EYaWeSiKPCELzjHqN4A==
X-CSE-MsgGUID: 3tr9YC6+SZaShXjA+eoXJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,227,1732608000"; 
   d="scan'208";a="112419981"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2025 00:35:27 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 23 Jan 2025 00:35:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 23 Jan 2025 00:35:27 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 23 Jan 2025 00:35:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mrmpsy7nXgqM5EQz8NX8j6/PbRcBaMuXwT7ss9vUoVA53GMIG5jJm4cDBJE9hU6sa/CZ8NXhHYCTiJp7IBijq3961nRMtdwVRNw8rRQ4UBpCCpERtGJeib6Z/Ez/8tJbc5tdIsNNPkJ0NS/+yne086yeTtKSIsKa0wdBmPyAkSijMeUnN+aBL4CyNU3JjkSGzUfSIB8G39LGQQz1+ksLkWbrYh4uH/BsmAD/IR65fIcYK57eUKfHU0a2oFgFVPVlomCfz5ih45J6xKYEbCdsCCekTcvNHPHM5NqO+TJAPK+irUeMLVc5ZwM6uWQ4M6yojih6k2jSkF62mu9yZocpnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JPDzMDrRtEaTpH3yQZlW9RzrM6KgmcfesY53Yz2d0ss=;
 b=Nhi3WlJj/5dBJsqHfCTRMYWq+vbJB+iJqRFL+7trZcn3wXJxcQkwkbibIDgZtVA8ZTMJaHwPnSfzKsCIASDbYPh8lPVAic+TRHj5Luslw+C2y0b65K/pqygGe48RF0s7p+s6QMWhVZmthIxhMN8p+VLjo+NO1eg/43TLUA3oD2v4WitKqMcPIw/WmGcjkSjsH6EoXqb7Br4UfkpvSskNwjnMRNag5go4sThEZTA/iDOkg2mRntKvE+V/fCIZ6lA94zRoTpLjgCMl0QsC4x+bg5p0ZzTUcVNsx/3NbD7hRb8T1/QdQEl3waA/eFbaPXyQxwxEHDb8MsSoC9Br+qdXhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6611.namprd11.prod.outlook.com (2603:10b6:510:1ce::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.16; Thu, 23 Jan
 2025 08:35:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8356.020; Thu, 23 Jan 2025
 08:35:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: lkp <lkp@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
	"oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chen, Farrah"
	<farrah.chen@intel.com>
Subject: RE: [kvm:kvm-coco-queue 39/125] WARNING: modpost: vmlinux: section
 mismatch in reference: vt_init+0x2f (section: .init.text) -> vmx_exit
 (section: .exit.text)
Thread-Topic: [kvm:kvm-coco-queue 39/125] WARNING: modpost: vmlinux: section
 mismatch in reference: vt_init+0x2f (section: .init.text) -> vmx_exit
 (section: .exit.text)
Thread-Index: AQHbbVMKBkgBuXo+D0WtIKxpAV33FrMkCA2g
Date: Thu, 23 Jan 2025 08:35:24 +0000
Message-ID: <BL1PR11MB59780AA56D67068C906A40BAF7E02@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <202501231202.viiY8Abl-lkp@intel.com>
In-Reply-To: <202501231202.viiY8Abl-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6611:EE_
x-ms-office365-filtering-correlation-id: a39c5562-fdb0-4c05-c660-08dd3b88e1dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?K/KdhVmM1D9X0dHQYAW6A8aqizxgFAiY861vLsGTWjWA+v4ed20RNlHwDYk6?=
 =?us-ascii?Q?gZg+jfO9YITilSIF2dOexL/+9UsfdE2HlzrplKwILCob2X+RWN2k1MTDLV3V?=
 =?us-ascii?Q?kZCI21xVD77HSVfvoN0YsVFUOWVBC12NLGGtTCZD9yiUPyg8cDmKG0xg+X79?=
 =?us-ascii?Q?SOEYBJVM8X2iu2AkWU8rxEwwlylFAhSsbIm6g1FjoDCZK8szUBi6HpWv2AMb?=
 =?us-ascii?Q?6X2kAwWfYJuo925PG9XW2EU3ucoh42ebi1nu0CF/rDzES0sT1TbcmVwlk9hB?=
 =?us-ascii?Q?K3uEM15olcyXyvr2xlM6xTYRQqXmQojOOSyCjexan/QpdYlGGONRq9uLqvw/?=
 =?us-ascii?Q?4+uAiwoYL9LatgaO1iwHpSJm3JtOtM3xqszjQUCTTgVlG5Oc5MdNn7ciNzM9?=
 =?us-ascii?Q?LAQA6grdc2Dinv9ztJuxsRFE5UOu1GLMR90NkUN+R0fllLiVI5K8px9PcIXf?=
 =?us-ascii?Q?6f283em033g5tI+/CY8gwHm9We11dBVbkNRSj3KzEiqHUPe04fZVSaUD8Whj?=
 =?us-ascii?Q?aGbcqLQcjybiKR1al+iB0/RCZPGSuvD5LeiiuW+aNkKvXmDuGIHTvtr573rp?=
 =?us-ascii?Q?S6ct/AQzXmqUpD9DZjX9bpdaLeoW7qVGBcdm6F8VSP+FM4Yshd0NGGcQTuX1?=
 =?us-ascii?Q?J3HpPazaMILo02Wm9a4JPcjGDtO83Hjr/JX/YQfp5RuJCe4HesoB9cM+w1j2?=
 =?us-ascii?Q?EFPYNUepZS79ofFMbX9DtnVjgKo2XINrLcdhP1rBJpiQNdZuIgmyYSR1BvVh?=
 =?us-ascii?Q?zgI9dKts5zAZ8F58L7IQP2CdQ283RN6+VJUzyvKcHPlJGYpmbwJw57WShd1C?=
 =?us-ascii?Q?tYK56kLWPKKt9tFym12fONVfz4wPn2VhvLUFw4AZXUklaFgjcUIJqUl7K4O7?=
 =?us-ascii?Q?4caDIliIH4812zr2Ho+QCzllU+pk5x1ZSMUztUvjwMv/uHbh70TtuF296P4R?=
 =?us-ascii?Q?hgLYxtKmu4wLt9O5ahxv+0ANZIVfnbHTLCVQ8biDfhiwTxwSNSgUygRH6E21?=
 =?us-ascii?Q?xhzuYzVbY+fMn+Y/0Y03qvWfYQvA0vz5bPbrWOcVqfgjolCMc7uDOO4dQbej?=
 =?us-ascii?Q?QgdmHQQVBAfkOZQ4VD1LzLhZwWiiGp/fGBghX0BcXS5rHu9z/wMzfeIaueAS?=
 =?us-ascii?Q?W2VlzfNHjHBLStnCArSllfChtgGawg/nDi9S7olFYRXGoUouvci+PQkYsx2J?=
 =?us-ascii?Q?nXxIt83wUFeU+4XwCcxYKQL2u/jzFlbw+YngkbHUHWybQa7lB+crmRSspBsf?=
 =?us-ascii?Q?Zo2zk/G2c9RKCrA427x19QRaRKO/22skzw9gZDG/0CvcJugNdjGszuXkEgvF?=
 =?us-ascii?Q?m11F8lMHYmgghm/LSjeh7NqZTexlTkuWmawboJreiGzkV6bDuN3WqWTQVzaP?=
 =?us-ascii?Q?8nskLRKtf/kTI2HX8unHnjUYPh6GDLuBqie08GMZ/mncIQfQmw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?shJ8ZI+a5v0wM8ep3dtCZmnd6BoIyF7oNYhF21pQnBxvR7zbaq2cBI6bODfV?=
 =?us-ascii?Q?cwtSdinZDtgjYH0cL3Uy0OkxNEzWIEynAN1zvWvfW/LycIi1tisuAzOtxkK1?=
 =?us-ascii?Q?AigjrE5uFBf0T2bzos4p/nkfq01FgI46oT7sH1BmyxEKN7I071hXnXhOh1bw?=
 =?us-ascii?Q?2GlH2+y+OwWjOIy8JSfF7zdTIIBoQmNQlQbtcIeqigXkA/pD5fH7rQjyiRal?=
 =?us-ascii?Q?dciFzxvXr0O0v3AfQiC5frdhnf+LyJ5eJoCuc76f/7/UJ/D7YJK+wpedmZs8?=
 =?us-ascii?Q?8sogIxfBfxxrZ4Ve4SvcMHlRc5aH8RHzphcgOceMW5qw9m+5+0b+ds8lG/Hs?=
 =?us-ascii?Q?qJ9LPBdEw5UmMBat22z23ipl7rL+B9Sk+AC/noEoGCMj2C8lzMrHUbeGOP5R?=
 =?us-ascii?Q?7bnhjBVZewDC1nN7DJ66cgpkaQWfCmHFK4iVhxEhqmaMVU3UBwvfUu6VoEel?=
 =?us-ascii?Q?7twDmQeSWmvtab0A6jvwBC0lh9gnIE7dT/Hx31WgwjJw8tHPmU93hn5ZHa0h?=
 =?us-ascii?Q?tOQLxaHrM6LpNwryJ+3ns/KyrcLRm2WuLrO/KN21wB46CLys9zVXhRzF3P2b?=
 =?us-ascii?Q?hP6w+nzJ+hRoq7bIYzRdYV4EWGJCUsZH3jcpCpShTKzcs2m+lSFI/uMXwfcM?=
 =?us-ascii?Q?LwFq76M0CkZ+FdFvBzFa3ak58h+TjryMOX8k41dA1lxzEskDlMqiElvlJXTX?=
 =?us-ascii?Q?NOOzd6DCrMwao7cHDwMKz55rKLJQZ1O3sDvm3R+Pxrr0GoKALJa6F1HICwrc?=
 =?us-ascii?Q?W5JhRQPwmqW+sEhZJp3W509OJvnarE27yRMs1jI+KOFlCzlzUZlb4HfVyMB+?=
 =?us-ascii?Q?yO83QvgKDzeen8AOICV+/SyxMtDD5LgJacPiaEGRxB/ESQdqPz64WlC+d5pJ?=
 =?us-ascii?Q?CvI+1f1m3LQ/UMWZUKqK4Y6V89tlGPHu0CM35rMeZq+ezGfOkoO8789wIkly?=
 =?us-ascii?Q?5ta45H962PTiRReQlywik2mdJOnciII4IZ4sVc6VhO3UKWnIhTS57X03kklS?=
 =?us-ascii?Q?z9nr8MpLPOuGdaas4ASTuQpNGgK2rQxLju/ZqaJP+QbZiy+759YVUcBL/d0U?=
 =?us-ascii?Q?fr4YMu2m3fSpOfQGJgTAIx1Oiwh/kAaJAVSVX55JiayU6Kxe1LpKBRISxzS9?=
 =?us-ascii?Q?DoYd8RWfmIgL79iWw536Db39r6OG7ozmPE8nfs7Nuxde5KLH6JMDft+cjsPk?=
 =?us-ascii?Q?wtk32YrVZfhIAGydIt2o+yjEA/vK7j+kILghFaNoqvvBn5g6imfwo8T8iDFK?=
 =?us-ascii?Q?pH8DAkezRcZ8tzqayURCT5uTw9ApYFQ3gfAil3szCFdUDfD6/l0b33964He6?=
 =?us-ascii?Q?8rRe1GRX/zF92Rt1FJshp8rrv3HepuxdaWwqVmw1GEmWytfcqWQdDoDz1m95?=
 =?us-ascii?Q?U0vFXeOmJJ34QpnUPRV4TXg6S4WV0TEAL5oknRu0I33NDBpzzvV3Cd1iWrWq?=
 =?us-ascii?Q?9L4P1DbMCzB1v63rcgqa5u8sMlsqqauzoCPUm4Jf314Uxr8F9LKoKxHCf0XB?=
 =?us-ascii?Q?IK44tBb9A1F72qpU0hbrkmCZxd2udClCS47VrAmaMbw63bxfgO3W7Nmri+xN?=
 =?us-ascii?Q?owRcl528bvN9mb6ASY5IMBbaDP6gNOX1vTT3Dq4v?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a39c5562-fdb0-4c05-c660-08dd3b88e1dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2025 08:35:24.7269
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E1KrHvJu0HMHNa8fjajzrtyFXeUBoE6vOV4XDM7KlzFkHEDofKggdwWAnG83bSsRn/tOi2sK8DNTa5BMW1me8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6611
X-OriginatorOrg: intel.com

> tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
> head:   46bf7963a06a56a6c411329d06642836450d19a7
> commit: 45c7c4a6fbf00d0ca3f033f30c39e6c12c517381 [39/125] KVM: VMX:
> Refactor VMX module init/exit functions
> config: i386-buildonly-randconfig-002-20250123
> (https://download.01.org/0day-ci/archive/20250123/202501231202.viiY8Abl-
> lkp@intel.com/config)
> compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project
> ab51eccf88f5321e7c60591c5546b254b6afab99)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-
> ci/archive/20250123/202501231202.viiY8Abl-lkp@intel.com/reproduce)
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes:
> | https://lore.kernel.org/oe-kbuild-all/202501231202.viiY8Abl-lkp@intel.
> | com/
>=20
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
>=20
> >> WARNING: modpost: vmlinux: section mismatch in reference:
> >> vt_init+0x2f (section: .init.text) -> vmx_exit (section: .exit.text)
>=20

I checked the code, I think it is because vt_init() calls vmx_exit() in the=
 error path when kvm_init() fails.

vt_init() is annotated with __init and vmx_exit() is annotated with __exit.

Perhaps we need to remove the __exit annotation from vmx_exit().

However I will be on airplane soon so cannot actually work on the code to v=
erify.  Will do it once have time.


