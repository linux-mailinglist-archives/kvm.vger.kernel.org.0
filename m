Return-Path: <kvm+bounces-18352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 854B78D4228
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 02:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35B42283F5D
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 00:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53A9F1CB331;
	Wed, 29 May 2024 23:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jNNiiLm6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA0128E8
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 23:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717027193; cv=fail; b=Asr1hP+oA+puNIcKIVrU78kOdWJ5zbzvoel0J43zFc8/mXtHKi7pRGiw6UapaOg+yWRgZkApYtm18OcEbjRbuwQVFIi8fy2f/IqR+BBUZfS2lU4GzjryYJgk30Qa93H12QHXEWPRre9HmHjRzRNlnkP7fYktNW0HkBUO/U1DM4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717027193; c=relaxed/simple;
	bh=We78zYhB8gQn4kx3QeofVFoXwi54+drPGtp2C0w3+2U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TQC1lsTm1/R8DOSqGA/79dRZe/MuCQXBc3kJmYQCGYxNPOgLyj9djcvUNQj9xGJJ092spvVMd4zNFBrX0ZEhNxY5QOye+rlB/Hxd07bazwpO1wj5cJFxh1YFExMPz8SbSTtFohbMJjqRitOAjtbThEC9SPyNdH07OVJacP+RcDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jNNiiLm6; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717027191; x=1748563191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=We78zYhB8gQn4kx3QeofVFoXwi54+drPGtp2C0w3+2U=;
  b=jNNiiLm6Ij5EkoEhaABLL8koWaJWWSWOVL6HG85SiQeQZFhrEDANzbl3
   PcCeenk7sEG8hBgLSTJo13FigrZkquOROvHTIh/KwJP0pItnGjafJN+sv
   PPGTkeeBy9TS1Sc7+G25ukZk3t5DBPZ2DU1TY3w0mGZvBMY/mjjmLg+zW
   PBh3QEsC1RHFZplupMcqFOKtV917NUASg3C+FrMGnHd+5kOU/5P5XSmfi
   AGrV5/2xAGC09kPk5a1hqzWYoSuKxKNvkREH4F2NWFi+GyzCbhlxhBNf7
   f5yK1wvdx8JNj5Y8nie/pMczR4wl8ceWAqxYMIqcHzcdBDJfCKgpf5O6K
   Q==;
X-CSE-ConnectionGUID: xBqHeNGuQia690KCdxaFqw==
X-CSE-MsgGUID: +qMauFuuQv6JnkMmNbA8Xg==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="13659148"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="13659148"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 16:59:50 -0700
X-CSE-ConnectionGUID: bV8ojpN2Tc21GRE8o/264A==
X-CSE-MsgGUID: AriYWVl1TSmGUQAq0wn11g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="35706106"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 May 2024 16:59:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 16:59:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 29 May 2024 16:59:49 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 16:59:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PbF48rrUd1B3LrUEcaM6GxTudmmDrUyTZn85GyL5B5jSxwvJmM7LeethBRj8+q5NVa7NA+PZUErTutPJMxWshIlYni8Zkx7cG/DGDH8uf9GKksHOsE9vSuLk02CNN1VcmazfX30pk9CstK9Mh72T2wAZUNlqJHgVffQ9V0pyNWeM4YOgJbmiHpfb65pKwpP5qDcxhDCyxcu8oswZV1Cq9q00e7vOtTQbpHfS7esVDcZ01ePbgVSeiULjpEEDu2F144BDaQ6vWrbOzD6yMsBlLD60Y9dX49dOwkBFrC8ZZ9H+fegGAczEAqTtA6FMdszPls6MLZtBnCcJLe1MmUQTPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=We78zYhB8gQn4kx3QeofVFoXwi54+drPGtp2C0w3+2U=;
 b=Fz+qrUeWIbahfYDfDwKc8C4ih1DK2Cf1z64FpvpmjR487WdDP1a1DPcH+XNgjeK84GttrFosctB2k8+ouHeXEUkQ8z4LMZH//rQaykrnKDIi9Y/Cp6hDSuuoF/0lyvgB/YQvbLJUeHLhJdvb12GtPihhAtqZA6ap2t5N6Q0i/bCMeX2Bo1Sl79inc/PkM4fhXeuRlKASLM/FPZKbrFZzQBmkRALliHofNdlPPqWDEYSBzPXQmIM7K3+Kc8CpSrlUdBeNk0+Hup4WTD9IEoiBTz3P9/Qj9+3rIxygNs1cnaNxWCwQcx/96cl/rBCrOizK0vftfgBUUHp69Uy8Nu7aDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Wed, 29 May
 2024 23:59:47 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7633.018; Wed, 29 May 2024
 23:59:47 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "ajones@ventanamicro.com" <ajones@ventanamicro.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>
Subject: RE: [PATCH 1/2] vfio: Create vfio_fs_type with inode per device
Thread-Topic: [PATCH 1/2] vfio: Create vfio_fs_type with inode per device
Thread-Index: AQHarUtjt6sZzfMLzkKguhHqxEEYd7Gu7dwg
Date: Wed, 29 May 2024 23:59:47 +0000
Message-ID: <BN9PR11MB5276B8BA37C325C4EE41BADA8CF22@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240523195629.218043-1-alex.williamson@redhat.com>
 <20240523195629.218043-2-alex.williamson@redhat.com>
In-Reply-To: <20240523195629.218043-2-alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CY8PR11MB7134:EE_
x-ms-office365-filtering-correlation-id: e81b5926-3bed-4ae5-b82a-08dc803b6b45
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?hkutQ9Y5c+1iqdgXUq9TPD41yl9HCKVZ5wYvnDyQOijD3AahRXkuMNHZrbTN?=
 =?us-ascii?Q?1eAy2sDl0rXVgpdDafPMimIkMfPoee5+sIx0+8/dpRP2MN0YpklHZcvg5/LP?=
 =?us-ascii?Q?s1dshPzUEbzODct6/teeMTZ8a30ZlfknSLSjxmevsHO7hvo+FhhAAj0J+N08?=
 =?us-ascii?Q?NaVCexgBnUu0tXh9gTweXwBujF2ZHgo1lq6HsC1+9ozkerTZn6hwn5PuHoAZ?=
 =?us-ascii?Q?A6j/rxCN6Zf7tBEaABoOdIKJI5xeVJiv0IALH/sdyVQ2VTp/O5aQ5ztB/xLD?=
 =?us-ascii?Q?+qfmqiG3vH/r1I3hQs6viSxIyeEffl+oEqgQw/xrhQ4p8hxnLrtwxuGThnwL?=
 =?us-ascii?Q?Z216cKJrEfX5chvG99ne9vi0wJOfT48s979yXsrnFGDAV39wRZkA6UnsP5tt?=
 =?us-ascii?Q?dMOB7/Z/kWND+jz5kNBYUGhHYghcwNSSGoDs8rT76FBv3Vl9oPq+JAoiy5p9?=
 =?us-ascii?Q?4L9LPbjDviiTmRJSV30ypdI/8dyGOMtjY4eJNGOYuefS0+yg9Paqwl0/Q7hU?=
 =?us-ascii?Q?TDLAMeZ81eCLdbw7tBG3xFAd9zMuq28IyZqBtKQ2nmBkgLMBO7BMr7pK3s1J?=
 =?us-ascii?Q?s2LVWvUpxDCN4j37y+XC1ZEqoLrmgXqdkWYj8MkpFBDIIZNgI5IJROkAMavf?=
 =?us-ascii?Q?xlCp//XDnnhg28L2h3a6ejnvx+y6tA0d5wWtMuCIpyskCxKpRclqr0Hi7CQq?=
 =?us-ascii?Q?Kc4KdaL0AtLoBIr6juFjKEYk6WBEik/uomVQs986iXlGsnxx/Jq8R9joIe7n?=
 =?us-ascii?Q?7K0AY7YNYlgbOtiV29ZIpsYIL4uVBSOf3Lg03ZetV3rP7t3hgHYQ009NEQpb?=
 =?us-ascii?Q?oxgE2oOZ1OUPamhaKa9tqQ9BAdRWX+zx35P4Y+jZYJ20UaRu8NYOENGJfBPJ?=
 =?us-ascii?Q?t/JqNotj0j1s8KGQ6HxzHiOkb8dm0vN0uQHMEsTNElsa7EiSJ7QXb8xljS6t?=
 =?us-ascii?Q?8AMgys6zSgx6bc8hLjVAry7Ar/E7t31G6Hp/9qgprRhEDNl04xbDoFkmG+Do?=
 =?us-ascii?Q?rlV0TbDnv66t6wJkuZTJPmmdRlFTQHPW+N43Ep92IvK9hDFJJLkCdC9/81jY?=
 =?us-ascii?Q?UeqHdu7ecQ+i8KUVcJ921d0lPPZNg/z7Vvsr1+iXH4v9oa9C9/uy6dIu8CCT?=
 =?us-ascii?Q?1ZoWnSSz+7iedxr8CDvYYPEMl7S/aNM2eEDvt8bjb2q10QVQXPzNtr4Kugsq?=
 =?us-ascii?Q?o/Q8FJysnMzCbyfT401OM05u1MEi+xIIUbCgAkyFrxDjTpWE02A8A7SRODa5?=
 =?us-ascii?Q?oKo+LAwUnkeFIo4i08YOqdrjQnkfDX7OfaxPnDcvkhOYAmJiZJGX3lsVOVu8?=
 =?us-ascii?Q?OoHoAv9vCris4a2B6BAOYzxygviIYmTaPJmqAHYEyNIyeA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+5w3GOS2HObRl3QeaO3g6Mzprq3WuStftysmTTY1XJTPBQaTAm3NaMK56gO5?=
 =?us-ascii?Q?qcovgQrmwGTqTPF7RH5MawPlpfDABdPlWIfA3uaXVKgcDRrZimWkzQj58LSv?=
 =?us-ascii?Q?L5W4fXo2GeIrwUHV+xTM34uHzdYuGUTOiRrfQ0QQ5HgqjcxguZlI/msfukYy?=
 =?us-ascii?Q?0CBkQugd6xP2XeBk3vpX2oX2H7OKs1aVLAKIXQGSnajy3/wHLnpxSa83noFv?=
 =?us-ascii?Q?7+DRXYoqM3dbVPhITc/MrlIBEc9jiuuRuMN92MlU3Ne2GzOmbD7TlLn3LAst?=
 =?us-ascii?Q?cXY2Zj9QOX1eVpSV648TTYSZIfgY3FepG0lVazuThPV2zApo3oLv870pjx7M?=
 =?us-ascii?Q?MF0jpIeUIKT0zoHjM9L4wfNmQBydfjRROC0sEdp212bIqDclt1Nuodeq1UIu?=
 =?us-ascii?Q?nVGV7TnDPy4GMzulZMU+FN7G/8MHn4Rj/jn11+jDBbUz0tLtjUnWA309zd1T?=
 =?us-ascii?Q?5CB9+ZD1ESjABeiJcdU2SxcdFGf+6rNFKFjXp4AyoQ5WesUkYVrtmNqI3Itc?=
 =?us-ascii?Q?pe49TepuSUQHUcSC8p3WB1Ex17tYB+2eLJPZGUhDPTnuO75DuBLoKBxvNvmE?=
 =?us-ascii?Q?Yq68jBQaHvVePJX2KzNIplKlYcdaIV5INqpJ3D3bh1m+SQ8jVjfUiMWSNgNt?=
 =?us-ascii?Q?TloDflxf+N1u7JKv+Com5gXDAfQlN3UDcrXIWIR/nPbojg8ZN65zQ+RDythV?=
 =?us-ascii?Q?IBDgm49eLQoRg4XJPVvquIHhAvkUphd4kL6MnOucuQ2Pdg/4EIAN9Aqnq0VZ?=
 =?us-ascii?Q?WTGUafhR7SJ1xUEIL2/gxWkHxPNEhTXL/w1ahPOgSjx0qsBcUBOW0s+2+DY3?=
 =?us-ascii?Q?o4nTpT60RsHP/HnkowRf3GqRRlASiw+8BWPZVK2B1UdXKUoQN3qNSrP9UHGn?=
 =?us-ascii?Q?R+e1Ijq3mA1aTCTRnTCb1Eeb+bg5Ojj/ue8RllQhj2Pzne5JlO2cj5gc1Bde?=
 =?us-ascii?Q?uZGBs8I9LicV7X3j1x+NFbplD9/ipPXc7igArYqP/1TNhehyXpOJKLXbg/oW?=
 =?us-ascii?Q?p5oHbqDuV79oICY7GORzmyUqVteCVLqkK5DxrvXFF2UW+sXxeXqtxMnMnkWW?=
 =?us-ascii?Q?fhSYyrq88Zc9f0RuYG9vvJ9P6Iz7DHY5cLgPjw4HKUDUFh9rzpY0EfBSBhX3?=
 =?us-ascii?Q?1rNKW8hDm6/YutHhlsmlU4/YgnHpgDohbtqWSATWIZ6hTkVBpr9ctSIF6vVK?=
 =?us-ascii?Q?PL8u0xwe0orZXcGorbSHUr4iZGQu+PrkD7rUkEIBJwtm8j7uF1tq7lydD+8Q?=
 =?us-ascii?Q?ukv+Yke1vnxy/W1H7ZXCSRvlrWO5kAzjHHtT5OVjn0Q2UQkbdykUgm7CnHqk?=
 =?us-ascii?Q?y5dEOS3zimBT0+CXNrDOHi8ZHLCyf/QErnzDpBlhm/Fz4ct/3rGWljG4EFQr?=
 =?us-ascii?Q?oKh4kxnLynDwnW8uuDRjo9FMeV/tSGqqoOfmIw1DQ+Waod9qitc01C1S7Zv4?=
 =?us-ascii?Q?paiwypEcoTRXf587gcUcHdck815+2ykgZ8o0PkRSxoWLctzr5vQXQdulwuig?=
 =?us-ascii?Q?syM+6H02SJ0ttVtRBeO7/HvV4iMyypWzbLZUGv/akiu0L7mkAqCPZB2wN6N9?=
 =?us-ascii?Q?ZFUe280c9a8Go8atgYRrDxxMsH7D9WzPyk6Hwnve?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e81b5926-3bed-4ae5-b82a-08dc803b6b45
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2024 23:59:47.0380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zBEcQaqWw2oFkdgFUwuMcyVscDZ2VxrdX7aZNJyC7/+dyaEaetZqlULymKqcRwreJKW1kWiQuqoN6ZhJfTrwNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7134
X-OriginatorOrg: intel.com

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, May 24, 2024 3:56 AM
>=20
> By linking all the device fds we provide to userspace to an
> address space through a new pseudo fs, we can use tools like
> unmap_mapping_range() to zap all vmas associated with a device.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

