Return-Path: <kvm+bounces-25471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1A896594D
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 10:01:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DB0C0B24FBF
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 08:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F40166F3F;
	Fri, 30 Aug 2024 08:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MricZv/M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D59515099A;
	Fri, 30 Aug 2024 08:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725004871; cv=fail; b=F+lnYaA0Bj50BryAXlCAoJqsNB0hJ6LnlToHjNzHhimAZQoluZch7k8tM7FyG8ggxrPNCsmcy6rSvhs7nkdqSvPSLVPp8AMNypdfNFVc+1JQxqTcBHiitkYo/U54wYKb6IgZDN4N4gtSVxWEUXwA3ImaFDgEywkGFOsNEA3F/Cc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725004871; c=relaxed/simple;
	bh=xVIHEIwoGHbOOkVjLMqE9QOInVFOGas14uGK2kbRGUo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iNnImgwgUkzLx9M1fhi96xoiCOqIrVVeJgTRTafZtRW3fl7dCaJ/4p7Pw5P1h29ZGO0fekznOp5v1z87ykXroDbdz9ifiytPCcMf7akBe+rcBxNgA2Zw8P86Dk4oAPq6UzppMmoaVILs800GxgV7Rk0UVFYVeX9kej0uUKIsTzI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MricZv/M; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725004870; x=1756540870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xVIHEIwoGHbOOkVjLMqE9QOInVFOGas14uGK2kbRGUo=;
  b=MricZv/MfuSQIHaAdBLOV2GiDyCkb+YwCj5BE8IH2e3+UTEYDpHQNz9J
   ++Cq3XEVD/TAkdW09zI62/yura9BBo5fbDzjlqWr9yDwHRLrS4sDnHqB8
   IYUxjzMaI/GCnjrQm7TwxWP9Xnd+n4H7Ub9VcjZ2+RamdvCOfe2gukLh4
   K1em/TAox7ZQXQRDj5seTNrdqSW8hmIhil83kZErapgfcJlAMC4WLE9Mw
   oMAS+8CKgSkf9UXcS86TV0xUAwWJ/yNFkWTCB3D8xvPxpslAYhHJD/sJQ
   rg+IkaYH9/9lB+8q92Y/9CFqp8cOm8etMZ9myNACokScPgom1h7uKz6mK
   w==;
X-CSE-ConnectionGUID: aJGMW4TOQqCLbE9gqR8rsA==
X-CSE-MsgGUID: MPV/sX6VQWW5xHG+UaVFeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23820500"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23820500"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 01:01:09 -0700
X-CSE-ConnectionGUID: fUx5W/yvTlKV78S4atCxVA==
X-CSE-MsgGUID: dgFSbj01TpS7bwbttHv3TQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63822597"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 01:01:09 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 01:01:09 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 01:01:09 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 01:01:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X/vTh+Ouqc7cQ2TPs3N3P5OdxWKncUtt+CyQelY7DHKFF875WD3cIWA3c76Mkqzzf5sGOxIo0nkDmJak9q+F7ceOv1+7Gl9g/19aLv8Rtw4xOX5ulAX1jJ+7xb85vKVxxGyUghFwmZhMB6pdUtHyQLAyZnmC5Wp5fwf5b42ooADFG+CiNKwm8eMRxko0Cyt4+ztsp+UpXyLzcGi4XNqCSXluSLpTDviLRs5JTuazYhlC+Um/34MCZ5jdhH+A6gk1uSELeuzYaV3Wamp50SXFpCuwIO5z3xGqXZi3temIAOdXPmUzIqpLG16HIH4cdn4JH0T1pa1v+6IElT51eYd1FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQbSKr4lpuYLcdxildiRmKrGwneKT8DWQ1IGTxlXP7s=;
 b=fnABiMxYpBSn8JEYgVOFcU5yMRAy5fJB/267gIyo9IeiIXsz9IBkHTgRkRl9algMrtZQX8oKm8aAmHRMiEmzFSTp2DoyT7tjiWIb8/NInoSDUcAVbHmPqe7fomSkUMoSkVJD2/UtyHt3reIkWwfpH9rlZqnyJnbrFpr46d0XP8sIERbpFqEY7ZcSRgwBMtinBdzIJlxKcGFM/6IjzOINGAcUEepd1xBlswkjo/BJJz9DCi3GLg0mMUzEaCyniOeWlu4ryXYXHoRlHqBe8inENMCPlLouzkU0iYvz2dJGDIUIfVJgP4lJ1Q6t66ux+j/epjHNu61EcxUDBMhzed/Tgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7173.namprd11.prod.outlook.com (2603:10b6:208:41b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.29; Fri, 30 Aug
 2024 08:01:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 08:01:01 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown
	<lenb@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, Sudeep
 Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, "Alex
 Williamson" <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Shameerali Kolothum
 Thodi" <shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: RE: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Topic: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Thread-Index: AQHa+JkZTSBXuEzIEEGnxKhZRRq9CLI/bzhQgAADtQCAAADgIA==
Date: Fri, 30 Aug 2024 08:01:01 +0000
Message-ID: <BN9PR11MB52762AF19642D1EE0A49CC488C972@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276AAA6242BE404D43F0D348C972@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZtF7FINkcGFbnAKI@Asurada-Nvidia>
In-Reply-To: <ZtF7FINkcGFbnAKI@Asurada-Nvidia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7173:EE_
x-ms-office365-filtering-correlation-id: 85847434-6788-4657-7a26-08dcc8c9e3c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?55NJEXEpQ7tCHZ76m3maf60eC+fy8A1wvWNcgFJzh7oghkuCZukdYEJGwQFm?=
 =?us-ascii?Q?sSmLdbMzTg/1hmpn4ZhmVSNNPkONhHdHCeRmuBmMoFAqwfYKuIkIEvezGJL1?=
 =?us-ascii?Q?H5XEJW/L7aVWo0Wv6A2JzKxWGfQ5X8vHnK2bvwmm1TN2n90RIW8+O/4p0GMx?=
 =?us-ascii?Q?CpXtm5WiIqGedZRvxhpe4SquOk55sON8T2G0kqKi4eNC9XElQ1cc4Zo1lCd9?=
 =?us-ascii?Q?VaAxwCriw0cGu2Nt1qaittu0zV9KnDV84919nKEXb01Vmqq2X7nUbaiNBkZA?=
 =?us-ascii?Q?+qFC09GoQz5cxd6bMreqKcJKEDNsqX0nufSj+oR5MIWmD0AmLGgb/D29qoMz?=
 =?us-ascii?Q?rx2tpKsNU1bfAFWLMHOC6CySOX/VfNpgLh0SvifaJ1sk538af+77CUgcvwUx?=
 =?us-ascii?Q?4RyoxYCDUvLt7hCEoWcMxA9jV7q3598RS+3v1SzupGjiATnvb/K2u9rFxptS?=
 =?us-ascii?Q?WTKUcFExPx0jG5TdgIVm9irjJ3kS8U38tJRRyiQ3JgCLza+Xf/BkpH2F79HG?=
 =?us-ascii?Q?KgcDX4wsNZzPY82TvfrVNBjpWFx0gQKyG0jOWWww/m6quod0UTf0klxzG2C9?=
 =?us-ascii?Q?clj6G4YPO9nzlCz8IWyoEYd3+ZAR+Z7kl02EBGfx70eCyZ80qxzI1lXKYHVk?=
 =?us-ascii?Q?skhRrD61g+IsUyHckNVae5tBFXUQhUlz6CTRE1+AaZflNl9rMrgrg88u8ZqS?=
 =?us-ascii?Q?goMGQdXK2RzADYWTJUbUq0s9t3e8HNDQEXMV90goGe2lmSTNS7zgPZFxGzli?=
 =?us-ascii?Q?AG+KldS1LXQorrXA3ghjISbBmLYrfAotiXB40nOpWvZQ1gLDx9cQpEiw/6ZU?=
 =?us-ascii?Q?Xo17TKW9fbnoPexUYC2053fpVxAIMTnLsw0thNzWArhyne6Pas+j3jAyTTpS?=
 =?us-ascii?Q?7qljf7D0XK60uBpzBHCcC1uh5GgP4GkzGs9Ms1banlSET4/Ar3OaE/GJ0I8e?=
 =?us-ascii?Q?oQPhp1ETErXr5WHtDmRzl8ZXhG1WPqjMknfHT7MeUn1445SwRm6jsbPMGc/J?=
 =?us-ascii?Q?uEwC6whAXRtLo376FEIadN74yzzxtSE8csdiCriXu6cO+rkY+RHgrdwUfz+A?=
 =?us-ascii?Q?FsSWbzb2w3EPBGInKWrwiJb8V645u3C3UW5x0BcJ2pwhmrZ4HGLLkwuQUuhm?=
 =?us-ascii?Q?NQPvfO1xLBf5dBjMK6bHYog89noNHmwE8DGC5TSwxU+dxazK77ddH7E0On8U?=
 =?us-ascii?Q?G+AYsLVcTV45ygb188TR7CHsDO0sRI9T9R3PvN42CBkiPj3ulmEcNITxsKys?=
 =?us-ascii?Q?nql41H36oxEYDQfOuze4fz77Le6DuF7/2JVJv3TPD9dpOsFs30Txa0mY4d4O?=
 =?us-ascii?Q?5rI/DWiPO4ncgq94EZPnQMj7yRtQ1WqM5lguhqven+4NHYJvf25vKvENbKT4?=
 =?us-ascii?Q?+WvLMuYcv9EbDzBnE7nyUsB0ct7LOtoAiWUB+m2FjM8bHCFL/g=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SIkzcVJz1X7JGPoB3AAiatoxeJvoqpWogeeVbnvWx/kw9+VXE05ETeVx6+ap?=
 =?us-ascii?Q?q/EhNON9W63MmXNvD8GwifaOySYJCnk0BOACJbU2HuzxQLbTrpcdPB8Org6g?=
 =?us-ascii?Q?0qVSlKpuy8aDhpkq3t6ZsKAakVX72nIus9ppajvY6/+4RUC7DMS/W1Peryvz?=
 =?us-ascii?Q?ycL59ZK6VOi4puqKQ+9jcdX5ZiDe32Fs8HvLOhjdsnvMN85pjWLsJ6XbWW6e?=
 =?us-ascii?Q?Uf9aNOSA1qOzb2T4JxN1gTT/ikjcga9ceQWpuAXUsJC71XadX4FHaCbyhYky?=
 =?us-ascii?Q?nuSpHvUUNs0DqtLfc+Ax/O7q4HbIoeNASmo7z2Ci/hmCLUegqMx5on3/1u8C?=
 =?us-ascii?Q?CYuHDbKEnJmMzhN+ch2YH3Awov5w40KrAO79zV4dmwp4BJ81MorS5reYHIj8?=
 =?us-ascii?Q?+s9lw4//l6ak/xtUvGBp351ZSLy3kmJHBs11YSj2A/ozQCOpCbZD5gRiZ8Iz?=
 =?us-ascii?Q?HOBbuY5fbXJ3yAxmDBT0W7B/2a0+vUyl5H/36UizWnKDCSMnUf7u4lVHRvwP?=
 =?us-ascii?Q?byIUAWi3skjGllr/dZEwBIFV9vKpYcCdEr5Em+OYEvil1JTAiRmUxyfkYT+T?=
 =?us-ascii?Q?WhDzKD2oedNhXMaR6tRyq7yUnNKj4yExmyRFpQOtndPbL5WIjEjRtOJuxxoc?=
 =?us-ascii?Q?816OQDquSZz2UnGLKgkdGBKvVuhIiW2JXnvW3QkyeTHY7YSl1JWM9GxiHvrZ?=
 =?us-ascii?Q?V751rnrr11laNAbKc8jgw3roinxW+JMjp5bk/BmxXxkn9wLfDR1rUDsfRPL6?=
 =?us-ascii?Q?lA8h0RJA23KvJ5s4Oj7nBAFFxZin6mSiPbb3Z0On1BWZpGtL6meH3bCbaOPI?=
 =?us-ascii?Q?Ol3aHcNZZlAbILbeP27mqdUFci2x3NEelJ0BjOcgfS/Dz3DRt0oVmuQe6wJs?=
 =?us-ascii?Q?xnS1rAHrXeuy6kO+e1cdKLK3uRvWIyk0MRuetLV9D4P7M31rTk+Rxp5iF7fg?=
 =?us-ascii?Q?U4d05fvrRyJV8OhzckYRJZrT0L4HZXUexcj2pAu4FimaWv18Idu5PZMTEIXY?=
 =?us-ascii?Q?hAyR5/6xaS+Ic1qQ5/4JiU6ls7a/Zo68JrPYC2YRB6wKeNVmy8Q0DKJ04aKW?=
 =?us-ascii?Q?GOl+GQf65dTiaOORZYAs3e3Zn473SKiFakNSijpxD/2muTZjMsVbdtqoCCGP?=
 =?us-ascii?Q?0caGFQbWgOV5C6oDLPi6BY7q8Rzce20tDLpj5Fedx7WdjhIx9hiE7HDRpG6l?=
 =?us-ascii?Q?dJZbGVFyXTFGS3mUOmOiDzlxMeMK0+WHOmdBRf0o+mN+Alw2raw09aJIgIDa?=
 =?us-ascii?Q?65cyXJ0KuoDsUA/sYl+otBlKUGoTnodutWTVf2vKmklMNvyLdoLy4P+l9fvn?=
 =?us-ascii?Q?GpKbD6b0zqoU45cky3HF/vOiUEtRolwiv0Mb6xUD29wN1mE4Ppmm862/ypiH?=
 =?us-ascii?Q?nWMUnwotUy+IrtG/qjPIrCYbGma3jnWBvY4UKq3D2yZLiRZd+KIW9Lq2oN3P?=
 =?us-ascii?Q?QKo65GtCDuHiM1YuIhxfJP0ztRzfljWNHeBEVQ+PmqAkvkGPuIwnavyBX6Wj?=
 =?us-ascii?Q?YaCCBTmwD72WFGGhnlbP/rCnnIsR+Kx5KnzjSok4/kQWWE0ywZzM3DeHdoUt?=
 =?us-ascii?Q?lBF9GZk/20xyGiMRm/oWBxL9Gq3V6SsASrPc9Ax0?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 85847434-6788-4657-7a26-08dcc8c9e3c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 08:01:01.4953
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ojkmtBstDKN5Ivwa6lG2nl2jfsCCAT1byr/lAUs9GGBfmYAcBVlouoHurlEWrgGnGriJFF+lCJ35dYTmywl/Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7173
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, August 30, 2024 3:56 PM
>=20
> On Fri, Aug 30, 2024 at 07:44:35AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, August 27, 2024 11:52 PM
> > >
> > > @@ -4189,6 +4193,13 @@ static int arm_smmu_device_hw_probe(struct
> > > arm_smmu_device *smmu)
> > >
> > >       /* IDR3 */
> > >       reg =3D readl_relaxed(smmu->base + ARM_SMMU_IDR3);
> > > +     /*
> > > +      * If for some reason the HW does not support DMA coherency the=
n
> > > using
> > > +      * S2FWB won't work. This will also disable nesting support.
> > > +      */
> > > +     if (FIELD_GET(IDR3_FWB, reg) &&
> > > +         (smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > > +             smmu->features |=3D ARM_SMMU_FEAT_S2FWB;
> > >       if (FIELD_GET(IDR3_RIL, reg))
> > >               smmu->features |=3D ARM_SMMU_FEAT_RANGE_INV;
> >
> > then also clear ARM_SMMU_FEAT_NESTING?
>=20
> S2FWB isn't the only HW option for nesting. Pls refer to PATCH-8:
> https://lore.kernel.org/linux-iommu/8-v2-621370057090+91fec-
> smmuv3_nesting_jgg@nvidia.com/
>=20
> +static struct iommu_domain *
> +arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
> [...]
> +	/*
> +	 * Must support some way to prevent the VM from bypassing the
> cache
> +	 * because VFIO currently does not do any cache maintenance.
> +	 */
> +	if (!(fwspec->flags & IOMMU_FWSPEC_PCI_RC_CANWBS) &&
> +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> +		return ERR_PTR(-EOPNOTSUPP);
>=20

Yes, but if we guard the setting of the nesting bit upon those
conditions then it's simpler code in other paths by only looking
at one bit.

