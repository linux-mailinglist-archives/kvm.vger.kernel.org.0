Return-Path: <kvm+bounces-17519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 635668C7235
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 09:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 869D91C21454
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 07:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72A203FBA7;
	Thu, 16 May 2024 07:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1A4/9S1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DF14120A;
	Thu, 16 May 2024 07:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715845358; cv=fail; b=kR8kjQp3jS2reEvV1cfhNzqo1DPux5lUAGvIdEC5xlDCeM7RvXWcS+TRoGsDl5cnWDTMhSiyeVTZPMeglyjJA80H6Vn2B+FeT9tEqw0Xt7SNC0M9VrvIzMivdbz4+seET7D1oCeu26AXCjjWXb7/dD/zi5mhHSGWZpF0EMEi5M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715845358; c=relaxed/simple;
	bh=MtP75dXNg1emxFM41jbLm1ysLfZkxXrOsxg25YoKgRM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ajl4uKE0093SGdhugdATmvjCbgeJYfEEXTQj/dmZqBP1gIP53jda1OkQys5w3b/f9+PQka98pIRA33b73rNvqJBht6CNfsiZ9iQP0FYkATjXqfZ8iMSmAcYuO14gsqhKR/N1C7R9C5Y80auC+8fLPWO4AkLglFbaaQeRCD76Aqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1A4/9S1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715845357; x=1747381357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MtP75dXNg1emxFM41jbLm1ysLfZkxXrOsxg25YoKgRM=;
  b=C1A4/9S1MD1qAv1IhifhBqgnzdaUJZU2hfbgMWCm82rNUA1HUb3/IDwe
   4vO9vicOVu+kzEmVBumQmPOkOWrd/fwDaTwkjVlciASzp4iUiXyogYFg6
   Pw8mpoJY0hbYQbvlbAUlbM+o3mbiB1ZTmS+1UqoSUh3j84RuBnE7KIfja
   y+Wc36QqMKeKI/PnNYnWTzIcfCyH06hpa3qzR4x9TUkaL4ubXJaTON0LM
   JdXCk+DKj7DL4o8aUf9YBS4RcKeQ94VeOVT+jIt+7ONoIYCfptNlsxr7+
   6LtSPiS5O4yWKWMIYQha0sKYQEgTz/c/TGOOLh3uOALOYvGe4q63Nj/nx
   w==;
X-CSE-ConnectionGUID: yj7HBbd/S8Co/RnTHMyEfg==
X-CSE-MsgGUID: E44nRNx6TgGPh0GBnM0/zQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12101655"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="12101655"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 00:42:36 -0700
X-CSE-ConnectionGUID: dycwVnxuSbmZPdxrFlgD3Q==
X-CSE-MsgGUID: N9cQbXlwQQ2C2ZUuuBdXqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="35778365"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 00:42:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 00:42:35 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 00:42:35 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 00:42:35 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 00:42:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mu0P522yvALdjwsScl5QqncL/z8E6efqR9JYxXC7I52ErMtednAXiCflDHMVvgZJiY1yWz8q70GCQVFPNU3Lbf9eHmecUuMQktvv0BdGY/CuD1LyNhFXOH/Y6oN+ujdMm5y1QXtuD2lkefS1MiIu9XVnXd+CDSKvC+aqQXRJH5hBu4SVjp/jOtWT12WR1gbjYzYK9Ly0XwZJ3QidOGU9bXZvkUO9p5gS2VPp3Zlu/eLUAFNz3j/xyfY7+MqGQcmu0fZft3ReAXUtI6Ypt5wcyhN1OcCggymN64Ozl70/JvmTHpkN1wRz9j1b9zoNPaazj+jOzf34RRri2C8ti7KDrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S21tK5RayO+74UNwhofhFbU8x0bjVuV6EiKyJNnVsZ0=;
 b=Im5ughV9nm6HLOS0+PWcE08l6Kr/6aAaB1knomz9/kxY5H60eANU2WMPKqXD8DgRUYA3zKvNbeKfvjQzieDRCWs+epVOaWfsXbttlhPxnGSYYpyLNYWk4P8ufLL4WgY7oGwZLEE8C0jIRaz0WYGwjXJFiQQ2yTl7bVobxkl7cvlOciXkypTUBLVslbwW1kw9HhHOM0u7QSmSWsg3AcyMtGGE8F0pRdQcwWJRsMTSPctFE25SKggpiET4/Bb51gorfcmnVZfvNpky+3yLlEl2anKqHaoekwdXS9O6jhy3r4rkNxgo+c9h/64neaT5guHuV5jjCEKJcu2OyA8GrcjUog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8544.namprd11.prod.outlook.com (2603:10b6:806:3a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Thu, 16 May
 2024 07:42:33 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 07:42:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"joro@8bytes.org" <joro@8bytes.org>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Thread-Topic: [PATCH 1/5] x86/pat: Let pat_pfn_immune_to_uc_mtrr() check MTRR
 for untracked PAT range
Thread-Index: AQHaoEaluFlXp2ccfkynqcQr/+5ZoLGLbskwgAAOFQCADgeZUA==
Date: Thu, 16 May 2024 07:42:33 +0000
Message-ID: <BN9PR11MB527614E72C1DF467FF3F4C948CED2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507061924.20251-1-yan.y.zhao@intel.com>
 <BN9PR11MB5276DA8F389AAE7237C7F48E8CE42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZjnwiKcmdpDAjMQ5@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZjnwiKcmdpDAjMQ5@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8544:EE_
x-ms-office365-filtering-correlation-id: d2cf577c-9f87-423b-1e89-08dc757bbf82
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|7416005|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?0ofa3zuvruHCIEuvB0mJj9q3FupKtQL/Xc67uisPlUMa/xjFoCbleaNJI8Ox?=
 =?us-ascii?Q?hEp0TIeu6ANfPcuvtmsWKIFwVPGrRx9ICTQgv+Zy+dldXGdVZOsobuyZ8Bfk?=
 =?us-ascii?Q?ixP/lwShOO+okYDwWPAnveTkbyrb1erTzshW51vhiuVkSRyup1PXQvIGgy6r?=
 =?us-ascii?Q?PF7E09eQSFRvnAKH8mKeKb2ipLINts3/UdNR/NWVwXWHbroehqvZ4E6GtU9W?=
 =?us-ascii?Q?FlZWHIpuIBZt8fE7UsmJzutc1u/W0k0dQdlGfMduNhfVpkYDdlZ6bRM0H3om?=
 =?us-ascii?Q?7FCAfCXE7ADeKW6KL/+bxVTLRJPVGkCksEkvU4IvV7lmxRsZ2/2pOar35Upq?=
 =?us-ascii?Q?mdPPv6JGfy/0pdRxOCrxynM10WbnwobLgFwioCvyPu3ZNhOXfTj1zWezrc9j?=
 =?us-ascii?Q?lOYvoY49C6IrpNHwN0lgIXdjZHGT5Ao/Y46pdBhGyCSkuPABIfmroy38/BDt?=
 =?us-ascii?Q?cVAFU4H36EhZHSifTO1DMDEtVB6F/uP407doiCz1WUQbuMF6jPBjUevb95Pz?=
 =?us-ascii?Q?KrqRCueZ2Xx+GfZYBoNMZvuHGnQebx0FKEYVM7HqXZa9cUBrFIf3Gs5aQ+zA?=
 =?us-ascii?Q?gNLfZb0vfw02cLdlAYCJjCcYb0MP1Et+B6hhUDYnwaAmAa1eWKhRbTDkgTP0?=
 =?us-ascii?Q?hfMrxOfah/O5qFUtG3W8SAbb8gV9E8xlsAs3Zt7Xocfgl8fDttxJY2xtEQ/n?=
 =?us-ascii?Q?WiTiJNq1bj1s817/mwpdGDJshcfc3yUGS2/PC1bcosfzQGkJgG/iUz+rkHxC?=
 =?us-ascii?Q?QiWwwhCYR2GbPkM2zICj9oBgAq9LCnwBfGF5QDQQ+f8tTLV0rloJ8tKCZXHh?=
 =?us-ascii?Q?y9Rk2l/BTzYFh4NtnjDt1Xr6viBd9PZOWtzROcogHh0+n3vUiOG3vjH9vG+q?=
 =?us-ascii?Q?B+xQbAUTzUBCW4LyyGOXewsuLdnutUeDrf1BE681ysfx0Z3/xGs9PJYnziaT?=
 =?us-ascii?Q?N/2rUxlKTEL5tB144PWTM66s3QIfm6YST0BaCT6tDa88ZD38ZyxjubnGZsrb?=
 =?us-ascii?Q?8QGBnBSenrO2EB2KzbyKbDeLrD/5CVuY6xx8oD98xbbh3n8NKDpbW9NrPp0Q?=
 =?us-ascii?Q?eeeT+maU2r7DE9cnlj9i5GIeFskt84UXai6T9mIjIuFjMWctQcW6bqY0BJ5H?=
 =?us-ascii?Q?7QgzNxGzLeqdXhpEntqr7wjK1Fz4UmzFM30ZQNKE7nOmi+HHXI5eFlWZZvPs?=
 =?us-ascii?Q?cQvdML38UseEH4cZP0EAJG/MRYI5ILPWEtbXxeM2QxP+gEWGcdQWsBXDRWbD?=
 =?us-ascii?Q?3YO5YNMOp18cnBM0HboFE9mrtqFVpwG0o2hMqr1mQmD/ZucEefbhihpkf0UI?=
 =?us-ascii?Q?0N16b7yye+2cleQuAQHGZlQquRpjOgRmJa79Oe6ZzkxhdA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mGmYNq0DAnNrwqoFPQz7DYa4MlaEJY63EsuNaVBRkjgCuC1rLrRpjn+fhG7c?=
 =?us-ascii?Q?+yY6SUS9BUjCBWH6sqOIADojhOVp95B2Gg0UpqV6lvS44azYnlHjFpz0tz/x?=
 =?us-ascii?Q?ULGQd4YlX/ENOj99ZxidL35InKtxuHo6TJ8Qsi8ggDksYDT/qPHjyG+ZnVhm?=
 =?us-ascii?Q?VT4fH3/QRRVF0DL4Sk4MvG80rwpZ3ejasRwV8fDJkXleygM9h0dpt+qYHF6C?=
 =?us-ascii?Q?e/6V3+W4SteTWMg0m0DAoKdBblM/VQBwi0Ue72vkSxzAXq3DA46MVY7B4JL0?=
 =?us-ascii?Q?oSkseuD6N5bwma2Zd7AT7T8uVnuLyQFvsip2Y/VifHetcgCV/UClO0HarURM?=
 =?us-ascii?Q?O0ebz+GeTwRHUhu+HuqGYw0H31FIE8O76nXO8ozacxSUt2J7FQdsrNM/WDGE?=
 =?us-ascii?Q?v12Vqc/aA/5qsmbKaqx+7DVQs/rpWqjkw4DHcvE31xjdaI08FriQyAmcfEqR?=
 =?us-ascii?Q?oVaw8P5D0CKW949G5ge8jBVnI1JAowaqJ4/wB28hAfq2GPhm5kq3UkPrlpk4?=
 =?us-ascii?Q?RTg0w/gS+rQOnYE2sVLtWg0EXqo+3tiV0Pc+PWojlOJjsrHmwoqeDj6c75Kq?=
 =?us-ascii?Q?5eT43efWqLowRJlCU7ZSV5k84Yrd3g1wtPAkh28UsKXxl+1zFN7WX6WV8dcy?=
 =?us-ascii?Q?oC6MvIXDMk4wSYuXZ3bRRAbyNcteOItheviXFpxJRl4JsCpMzH4FPoApG8jf?=
 =?us-ascii?Q?SedmChEPhVpqniea4uWoUSbXfoW+WZANcQnsUC1IPKHc3SRcLLx8jicD2wY6?=
 =?us-ascii?Q?3CYpUMAtLSM97FzijU6AApRzHOh+BqAPacP6h9IU/irgN1366fRuGcLeMnHX?=
 =?us-ascii?Q?bN7Sg80hSCNShch+1hg2LJplW/bZD96TQFfc7PzLIY+pSDampW1YqVAZX+eP?=
 =?us-ascii?Q?0nXeBp75S2/VjuiVwCCFezGMokxp/mdhEIZtq0XosR5BlPbsL2PziDrvwihL?=
 =?us-ascii?Q?beaDcZjDx1naqWIe/w2mXp0KehaRuD2NxPwzo8I35uqZO2lDzW2uq8HkqsZo?=
 =?us-ascii?Q?RYWAPx4Xpq2SVc27c4lddxdSssRNXPaVcYtJjhFLFwykgkAgjUPmzkkjNoOX?=
 =?us-ascii?Q?0cGSzYrQbn0dz5+R6I3PRmZv2iX+1SxUmkU3RMPdNGurB3zKIvlxMMdeiM/0?=
 =?us-ascii?Q?ugNmYsuxnPT6uJHn9k/VPwZqZvGrG9+5MBjtsuGObhIkUdV1JefnnVZT4Xbi?=
 =?us-ascii?Q?oc2yIql50GiboeRpkSivgWzRJ6HkJTBsDhoQgs7G6brrqXI/pwxc5lYeBan2?=
 =?us-ascii?Q?JKQxN1TtrZTrqwmwWkSsT6DXykxmDjrFynblBfOyNqyAbG9s2c1Wj12YAmWu?=
 =?us-ascii?Q?I8gL6QM75P2fzhO+n1J6Wa7G7DwsvWgJGgoJNSmPMo9nm+MPnnfMNI9EoVGE?=
 =?us-ascii?Q?nVU4m+uvLKh15I0iu+9d9a4NfOUCE3TVwkIBUFLmSk4fBz0YUj8ZBWd1qaFZ?=
 =?us-ascii?Q?a6flr15yTKDoG8wEd7SELJcKII1Mn531Cl1+4pgQQAe80DJeChgS450xLMw+?=
 =?us-ascii?Q?R9k00K0OEr0O0J3c9YmC//6DKbYaZUbgHVLntVGo8KFmnRrKMrRXUCqcFEYF?=
 =?us-ascii?Q?ra6LINlny53XgbatiGGPQIa5XXCo9z9TfjHD1Oq/?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d2cf577c-9f87-423b-1e89-08dc757bbf82
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 07:42:33.3552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rzulChCmuVLx4jWaRcUddqpbyfIxkFKmqGPS6Ph+iIOn4heotf2B9YdGY8o8peYBXq7Ywq+BWpzoiyN4LEm00w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8544
X-OriginatorOrg: intel.com

> From: Zhao, Yan Y <yan.y.zhao@intel.com>
> Sent: Tuesday, May 7, 2024 5:13 PM
>=20
> On Tue, May 07, 2024 at 04:26:37PM +0800, Tian, Kevin wrote:
> > > From: Zhao, Yan Y <yan.y.zhao@intel.com>
> > > Sent: Tuesday, May 7, 2024 2:19 PM
> > >
> > > @@ -705,7 +705,17 @@ static enum page_cache_mode
> > > lookup_memtype(u64 paddr)
> > >   */
> > >  bool pat_pfn_immune_to_uc_mtrr(unsigned long pfn)
> > >  {
> > > -	enum page_cache_mode cm =3D lookup_memtype(PFN_PHYS(pfn));
> > > +	u64 paddr =3D PFN_PHYS(pfn);
> > > +	enum page_cache_mode cm;
> > > +
> > > +	/*
> > > +	 * Check MTRR type for untracked pat range since lookup_memtype()
> > > always
> > > +	 * returns WB for this range.
> > > +	 */
> > > +	if (x86_platform.is_untracked_pat_range(paddr, paddr + PAGE_SIZE))
> > > +		cm =3D pat_x_mtrr_type(paddr, paddr + PAGE_SIZE,
> > > _PAGE_CACHE_MODE_WB);
> >
> > doing so violates the name of this function. The PAT of the untracked
> > range is still WB and not immune to UC MTRR.
> Right.
> Do you think we can rename this function to something like
> pfn_of_uncachable_effective_memory_type() and make it work
> under !pat_enabled()
> too?

let's hear from x86/kvm maintainers for their opinions.

My gut-feeling is that kvm_is_mmio_pfn() might be moved into the
x86 core as the logic there has nothing specific to kvm itself. Also
naming-wise it doesn't really matter whether the pfn is mmio. The
real point is to find the uncacheble memtype in the primary mmu
and then follow it in KVM.

from that point probably a pfn_memtype_uncacheable() reads clearer.

