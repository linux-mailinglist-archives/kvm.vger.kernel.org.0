Return-Path: <kvm+bounces-29794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8256F9B22B3
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 03:25:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42605280FCF
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 02:25:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30ADA15C13A;
	Mon, 28 Oct 2024 02:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HZq2KX6W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15A215442D;
	Mon, 28 Oct 2024 02:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730082322; cv=fail; b=X8JD3N7XWc8LsSg67/PatqcD/TLnzaulDIECwNTmTd8akBPMV9utzrK6sowp+xG3Kkpwk0UQUAKUQmHvK5NilX/007J7llNphDmcAW/NRzEZG/qr2aWYhB3CAfzjFnIKfOnHjshXWT8sGNczLS9nwYhCl4tlKDFWxDXX2fa3X5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730082322; c=relaxed/simple;
	bh=KdS+r1jXb0Z4M5sp7ZaT86y/OwvqcFKnUnaPUA5GAPI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mPzWq216fzsRgqxG11OwCBtdVZSun5SE5JX/S3TnwegmAGcDdDrlm6GnbmD93C0xQSDAfq41IC3LxNFw6uqjObXaGfCsAmGo+rEFw+mbIzuMEnNcjZG7WBf0+4DMpfUWYTm/iRe15KS4rzomixCQ0XN21G+dfYZAd7wT4ziY+8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HZq2KX6W; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730082320; x=1761618320;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KdS+r1jXb0Z4M5sp7ZaT86y/OwvqcFKnUnaPUA5GAPI=;
  b=HZq2KX6Wp5UPV98HsZ5NSkgIlhOoZas5eX2l1vKaKMRPVRFyznr4cVvC
   vF5nwBY+X555Fmzpd4vJaAbe3/a2yRQvH75wb+pi3MxUkabWNB35YbEY3
   WPzXAam89Pb4HI3UvNDhoGr3sdT1UiAwJWDT5OJftV7Snt6d5GD7PDXST
   zIR9xv5CJX4MGADrJY9BMcIRGH0pOOdWA/zm2J9b+kjYUAVOAmdk7wVC1
   LUDw5wPBqqy5NmSAhQWAHYLjEORdZFrML8CcPtuTgjGNqxoC8kwObTlh0
   DblFy2G0+Msu/kOpLrOLYwHQykbGz3oKpk86/DUl12LjOJID6i9rCMj86
   g==;
X-CSE-ConnectionGUID: /xEc7NxeSoKSEWisklLFDA==
X-CSE-MsgGUID: Nrt5Vue/SIGpHLdUZwhkyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="29104116"
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="29104116"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2024 19:25:19 -0700
X-CSE-ConnectionGUID: sP6n7Tr6RwiqeYuG4Ql13w==
X-CSE-MsgGUID: 4yKydjMWSJeDmZLvgKl9NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,238,1725346800"; 
   d="scan'208";a="81574438"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Oct 2024 19:25:18 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 27 Oct 2024 19:25:18 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 27 Oct 2024 19:25:18 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 27 Oct 2024 19:25:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RQmgcHGbkjVqXNho9XqDO/dBzzdMzDWDlXyFmRGzYf5tXNrP4dNe+zk+nt+0TI4hEc2307ZWKaZfiR7CrGdvH8UuIAv+WllBZ5UXUER7gJjW91IoExQ2ztB27W4cCjZ8GF8lSRgVUaqoia2d1PusdQAX4xDi+shmvkQGRICrmW2f0VzqCEe3o2P5KDeaVnATdn/MLU+d+W7Bnp8VS4vOsDUhK8KdLoHQPiOtTAB66qs/PrebPlOx/njWXKeVc5Vr5QHGoGNHvnNfhaV8b6t8HNpknqeKAThJ/UKAdBLn3Q8O01e1VSB99DVG8YAqjzD/Wjv58wsO8GSM/ewYrQJ7Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oeYQjr2lWfAMMUVFixnKNdY5n/We3yZpm7G7lxo3cU=;
 b=Zu1hYyAgZIXke0SEGiH16p3N5RdKS7wdFlhsVgE7U0tsPpE1n8B+EY2nvgnIAL9H+MeyZ8/fERIGY6QnOUNBo17P58qsXJMvhYlX/l0h5eRyMdktjx0VutGG82LDy2xBOYsbCn/JZqNU9MyZ/ER997lk4wuAZtyTf3e+XttY+EcceE8aZcadYBQDCbySthXv7ULvSdGxOaRwRTqua+LBqEfdqOmGo6ps5eUE+3pD72F6LF/58loXYw/at4GGLzskjrlfJlttc3QGamM8xhC9j3MiQwaIxFWQLbRHcRo8JrDtGcHxhh1pNuxb2SEw7+dGgJQeWvUekTquQ1vWEFyLuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BL3PR11MB6459.namprd11.prod.outlook.com (2603:10b6:208:3be::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Mon, 28 Oct
 2024 02:25:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8093.024; Mon, 28 Oct 2024
 02:25:14 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>, Hanjun Guo
	<guohanjun@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, Sudeep
 Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, "Alex
 Williamson" <alex.williamson@redhat.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Thread-Topic: [PATCH v3 9/9] iommu/arm-smmu-v3: Use S2FWB for NESTED domains
Thread-Index: AQHbGmeggfhRQtBEeEG2NWkBBDuT57KVnl2AgAH5aQCAA/RAUA==
Date: Mon, 28 Oct 2024 02:25:14 +0000
Message-ID: <BN9PR11MB52760BD6DE7707586F39588F8C4A2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <9-v3-e2e16cd7467f+2a6a1-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276A5BCD028849E1658416D8C4E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20241025140048.GG6956@nvidia.com>
In-Reply-To: <20241025140048.GG6956@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BL3PR11MB6459:EE_
x-ms-office365-filtering-correlation-id: 120d0f46-b031-41d2-21de-08dcf6f7c1bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?65QsYqFWsGfEV7A/bX6puYwSeZsafdQXux8N+gibo+9oKXQlM/6aCqTcwjNZ?=
 =?us-ascii?Q?cWwoc6x7NabiTEw1RTQ15vZkwt5uOhyi35c5CADGmggZkle+QF521thkITVa?=
 =?us-ascii?Q?57hQ3SrxJKHtSb6ymrvzU6Z/VVMijm4zRATRr4vc9z+YD4bOZ1DnSQWkMI7l?=
 =?us-ascii?Q?yV/oaClIlaxOa1pJynJCKN16L/hMppPpDgtjlfV24u7dCvMKy4B2JMCyyuXT?=
 =?us-ascii?Q?b5vpxu43co8lErdfwWjNrDfmJK1lD1k3dlIAxXhjEpmnOYlryjfIPwDTgyu0?=
 =?us-ascii?Q?HbIamO/fPKt3B4dNF3Zc0jimzmOfxf0b0qJWgLd37aobHniaYmIq8SoTX61i?=
 =?us-ascii?Q?NBZQOloRjkcji3AEb3EhGeXIjibNascKVng9NY2DDGjus+Dy3zaYvIwQketg?=
 =?us-ascii?Q?Y+i0t0ETVpgleD+VKmVgV9lKMJMJJ5nAm/dsaTkzalrE+m2zAv4eU62BOfi8?=
 =?us-ascii?Q?UMKgNVMxOXCGkLECKRA5l6jOkt9RfZmLb+cNF9rHAzsEqzA4gdMo4daD+1+v?=
 =?us-ascii?Q?RLFcM5UoAgkAc34NnVaqGq6zlQNcJ4VHq9I3nhOwxDGU15U27sLyUeX3wZAM?=
 =?us-ascii?Q?9eSXsoZT96OfNHhl/KQo0NV33l5cdtI//xD/TISZL/YLtQ5WNzu/t8kM9Uxv?=
 =?us-ascii?Q?GbR4EmsRYjHW+ZKOaqActTwbMMVqDcxd3BMH823Xi9ZnwfcGJFrq3dLrbFpm?=
 =?us-ascii?Q?B6Ico4v8Z7C7XcuVkpDZgxTEXpWcxkf1WsQLBFYyNEynjdRcCMsEBUntCng2?=
 =?us-ascii?Q?+Aml9YNMFjsQxaaSwM7u7Xiy+BBK9a85xo568Q97ccc8LSBjy+De06LTtnXw?=
 =?us-ascii?Q?eEnp0syZqMqFd4kVQKcsAnsDG0i9zNKGDHOCNtSA8xv9M4gUPjwfueJ7863l?=
 =?us-ascii?Q?1Jozv9kn+H/TStRRWPyH4DzuK3AAKl/ebruUZIb8R6ybj45nScGT7CwfDkuu?=
 =?us-ascii?Q?of+//bdwu2HNWyRMhL7S5z1JyWAkdO3J59cEZ6nkClflCay0bx1eA68NP77p?=
 =?us-ascii?Q?e8ZnraBb3mXLiO3tdw56lxDKQuG9fuq+4RCr9zgSpisPJtHfwdI5rKZWDqcd?=
 =?us-ascii?Q?YmrYhzeVI62a29GNAT68bJGZE0Vf4nEklWsmItrxRoX0C9Ncc3tiIEUVWsjW?=
 =?us-ascii?Q?3DtLUDZV+y0OMF77F0IMEa7Aip4buHiwvLI+DgoyYjfxmwbyIV/Spk7Jg3r4?=
 =?us-ascii?Q?e9zhdexcZDYKq9MWg17FDRCbedGsvnyaLwxeYGYxjKQZya5uNTnaS//+C8LC?=
 =?us-ascii?Q?XGSJI8vM2PD+zVpuEOJo+FJ933IXgkeZayfLk81IThpss1Ew0ESdtA5v9CN5?=
 =?us-ascii?Q?Bp8bY87SJSpEVoMjXOUhEy9SHOhFQ1kfG/Ip5I1YGhZNh+8f6D9AL1hYXH4C?=
 =?us-ascii?Q?ABuYjhk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lfjuA6kbPrjabopHjGANvkbp8diIaQSp/BHShR9m+IUiz0U818s9BfAoVQf5?=
 =?us-ascii?Q?PqLOrxvsYy6nZR+dvwg1fg1Vc4sEG/MJhSa10KHYVi+g5sozQmAVg19AmrIa?=
 =?us-ascii?Q?UGq0H7Yn0pj04BVkdIZSLiQpKDwR3KGyyo1kxjXlEXVNEPqpC8pbIoestMaj?=
 =?us-ascii?Q?kj73F6EJR3G+fcnkwG1ykc/W3FGTE9eBLSU4DiNrspPEA0T9FT2Tb+W+uHUu?=
 =?us-ascii?Q?EQTkFW37NC8wsu7+3rcPLyPcEXBaRIsQOQl6b0YXyQoXFWyw+7i5q4AJyA+f?=
 =?us-ascii?Q?C1KMMgokrLpcLMsn3WfYQClH30Lb8E4hBqR9+sgN7H4hSFHDjL91mle14fYB?=
 =?us-ascii?Q?n9qxj9bhAAamN0pv1KRmetnGf+k1lCsa5CD5u3iL6a1iJxyxoolXyNRuAOVp?=
 =?us-ascii?Q?brlAhFUkTr8iF5McCpS+ReBnGHjY5HcIJa4PI/g4Attkjlh10yVbmoHxl87T?=
 =?us-ascii?Q?NB7jMKf4hFEaLiwr59yq4aiZvMa+iamC5sjSdHOFrIyv02ajEe4CCEZLLs1r?=
 =?us-ascii?Q?EVuaeZrbqk7EEAL2jOOQS8kRxzoECZf2GetXTZcqn1upL6cWM51BFLBPmbGu?=
 =?us-ascii?Q?Jc623atvz5YedpEoDbeg8kAKuNq5GpzO/Y7hnS0WGIK3wrBm+5YZfigGveYh?=
 =?us-ascii?Q?O2AMHsRsLHKAGTnbmucplwu9pA9E9rP39cEmndhikrryVz6Yn+IzlNTZorz+?=
 =?us-ascii?Q?Dhkt9oJtDIBM/W38Xl9jVjBL7amccpEd3gc4NNkjtAivAkhUaAkwaD6BXx+a?=
 =?us-ascii?Q?rKNQSk2oET4QVmSrV5M7uWEnmqM5SCFP7oKrnIaXSXG5exT4bdmY0H7Psa8F?=
 =?us-ascii?Q?h5p9WDxU01WAmJLjekPTpTPTFvg00oU9BpucaVhNk5r8iHwN+JGxolAnUc4u?=
 =?us-ascii?Q?7aKokK1XAcRCgCDXIJjQdk3B+lhrf1UOTFb3/plpnAL4TEeObluJ0uU47ZF8?=
 =?us-ascii?Q?h31K6BwY/NWxWuXAs2Z5aKxqJMrWc1Sjne1bDsmpVvFRb9Q6FcNsGys3L2Ty?=
 =?us-ascii?Q?Jk9YaZ/z5nUj6eBhhowZM04EY353nUuuf3NpJgUsDd6ofbaqNE0nH6zd2d1z?=
 =?us-ascii?Q?gffn1UJXIG3UsgwtXWldZutVtELkJhyqM+xul4JVO9OeanrSTJPSDexNeq8D?=
 =?us-ascii?Q?YkzKYPd4kAZzaIM5/xSjUjqIkH/itaaYokclGGEdY+I31NMynVc/hOgd2mNt?=
 =?us-ascii?Q?VhaTEXP81itK3w/0odH87goczQiffz1Hn5+G8kX5wFdJil6Zy9o/fky19YE7?=
 =?us-ascii?Q?6OXHi6A5cjDWteoi/78SvXGDX6cPPWNnx97eadBw3Z0tj6w6wLdZdzlwMIq/?=
 =?us-ascii?Q?49u9vd5KY9pGJFYfBTd+yz142Kg3xBf9xClU2tqTPhOq7DFdGEBzNOf22oo1?=
 =?us-ascii?Q?7J/iDR1DOP8mOXIuvCLB3aV9kRSWytqOCNVSrCEsdFnwFeyFFLwaw8qL1Ork?=
 =?us-ascii?Q?SxCqyH304V1zdlHE/huLGFQ97hFMkT1N/rlLlez87aqAhDI9iLNfzVkzB0l/?=
 =?us-ascii?Q?EJaCOjLKfktgHdKueBD4tDyctaDJGuObh9AZkKvqM8+LJt8lHKBfuvZfAKJH?=
 =?us-ascii?Q?RDx/9xdNGYA8ImNad+AzrfKLWf4T1pJsJsjwlPKg?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 120d0f46-b031-41d2-21de-08dcf6f7c1bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2024 02:25:14.7192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Tt7sJPNdk7w9mmsOkjTZYbsj3gzuDECFQsReUKIEvsizGml1dvFT50H52zLx3GeLgInIpdxrqbHmhlg0lOpoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6459
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, October 25, 2024 10:01 PM
>=20
> On Thu, Oct 24, 2024 at 07:54:10AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, October 10, 2024 12:23 AM
> > >
> > > Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> > > works. When S2FWB is supported and enabled the IOPTE will force
> cachable
> > > access to IOMMU_CACHE memory when nesting with a S1 and deny
> cachable
> > > access otherwise.
> >
> > didn't get the last part "deny cacheable access otherwise"
>=20
>  Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
>  works. When S2FWB is supported and enabled the IOPTE will force cachable
>  access to IOMMU_CACHE memory when nesting with a S1 and deny
> cachable
>  access when !IOMMU_CACHE.
>=20
> ?

Good. I read the original words as if cacheable access is denied
when S2FWB is not supported or disabled.=20

>=20
> > > @@ -169,7 +169,8 @@ arm_smmu_domain_alloc_nesting(struct device
> *dev,
> > > u32 flags,
> > >  	 * Must support some way to prevent the VM from bypassing the
> > > cache
> > >  	 * because VFIO currently does not do any cache maintenance.
> > >  	 */
> > > -	if (!arm_smmu_master_canwbs(master))
> > > +	if (!arm_smmu_master_canwbs(master) &&
> > > +	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> > >  		return ERR_PTR(-EOPNOTSUPP);
> >
> > Probably can clarify the difference between CANWBS and S2FWB here
> > by copying some words from the previous commit message. especially
> > about the part of PCI nosnoop.
>=20
> 	/*
> 	 * Must support some way to prevent the VM from bypassing the
> cache
> 	 * because VFIO currently does not do any cache maintenance.
> canwbs
> 	 * indicates the device is fully coherent and no cache maintenance is
> 	 * ever required, even for PCI No-Snoop. S2FWB means the S1 can't
> make
> 	 * things non-coherent using the memattr, but No-Snoop behavior is
> not
> 	 * effected.
> 	 */
> 	if (!arm_smmu_master_canwbs(master) &&
> 	    !(master->smmu->features & ARM_SMMU_FEAT_S2FWB))
> 		return ERR_PTR(-EOPNOTSUPP);
>=20
> ?
>=20

Looks good!

