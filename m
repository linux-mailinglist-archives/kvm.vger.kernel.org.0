Return-Path: <kvm+bounces-38642-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 544A3A3D18F
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 07:52:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 719407A940A
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 06:51:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EBC91E3DFE;
	Thu, 20 Feb 2025 06:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C6SDhDIs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD161ADC6F;
	Thu, 20 Feb 2025 06:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740034310; cv=fail; b=jimrvAAv5Uh/XHwBzINWpQT97xV/5NBFjOcLEQV8rxjcdIHCV+xo5xAu2oD7YIOyhl/fcrR+t4gF3Euf4FQwMC4Eh48o0nib5SlGCr4T1EwsIwZ7Ia4PWqTYKRwJiAeHaSC3rhYrcfoWcmFh9qLOy1vgarZKZNkjJBXHR0Lhstw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740034310; c=relaxed/simple;
	bh=NpgXw/DZ1UywBT2bpWknHcon85fvx7JJ2ijuVcWtX0k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jaOg8JMRsLa/BZHUlLNAnrOIvKVWLSHT6ECrofz1FrZQ+IJaD9ZRMlNkLpnHJbli5mXw+a04dNfVM6Wj7zIaIV8q/yBKKK1BCxHlUP44ziU0XrV1kABxytmEAQiKuSGN1vh001whiZDoRYIPtXCnyhclZRxgerfqBNTVEP+ZYCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C6SDhDIs; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740034309; x=1771570309;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NpgXw/DZ1UywBT2bpWknHcon85fvx7JJ2ijuVcWtX0k=;
  b=C6SDhDIsI+dxc8HG1lhufaDBlRtSLK7VRgloDIloKvwK+gWC2tWTSYZ3
   u5Fq8sA3V7jABcAjV2KW2JEUaMKLoFDiPEpOjg1+crUs5eRzjkqNSKFyx
   7J0VoQ+kIbK1WyU0rxFxq2nsER8INAmZoMtimN7eKNpedgXk7MeRcXsbu
   IufM7sUgnlqPQ5i5GB+VeTJP+kO9AthFk2omwmDDvkGz8Je2haiKE4KQv
   XoxWUkLGGvpqVLuVrk54B68VI2zTEtRgCwbH4pI9qaVJXJEoQLDMV4CXA
   ec5DM72g3hYECPAjE8CKUojjpZySrOcELs784udwC0B8dwO1m+L7etKKO
   A==;
X-CSE-ConnectionGUID: vaCuuO/3QfC4v91cn0QWDQ==
X-CSE-MsgGUID: 2XGCK9L+Ts+7kLumMLtHAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="39988571"
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="39988571"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 22:51:48 -0800
X-CSE-ConnectionGUID: mkeYjkS+TYmAeNz29S3n4A==
X-CSE-MsgGUID: GXmxFXRZRi2MO1l3i8bpug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="138151804"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Feb 2025 22:51:47 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 19 Feb 2025 22:51:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 19 Feb 2025 22:51:46 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Feb 2025 22:51:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yIsBruz3kFAldXNGE5Zf0Cs0UzxxdkIXB0lKUxkLGZ4ZGDSqLwNU3OoJpMfVTDClU4GWjyGGIWYEB68FtpHXl84zY2plmqoZqjxl4DMFH7bb8SGG9r7RdGjhdouzp9AZnihKCTuEsIOlcXgV88euPF+FlaV79glqzb70fy2ucX+G33gNkD0ZzywTOIMeTdW4+iLRP640GmLlbF4qwUQOQx79FOxWOYluwITulRWRTRLmimVTeQ9OScLtgDlMrF7JP1Qg8qUPUNjE1dLB77zXxRNmNu2WXnjhZlUxIlCEFONvmlLoYdH9/KrfY2bWnK5KxII75NSfzXNoGksrHfYZzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpgXw/DZ1UywBT2bpWknHcon85fvx7JJ2ijuVcWtX0k=;
 b=IC4uhZHJmQjTW7ImASDLewCk0GXNa6I3Jno6HZPQoIUw1Lqvc3QvUMtccqQNDZyCEHTJq9tXWlbd+VwxpxH25wQu3fMj0vlR79UYL3lk510LvLmHfxNohapml12b4JnMUBlrbA4otCiVNGc7pvyNz9ftRsPGzg9oUGxOD0ZRqL+SixjhffJWYOO4wFesbqo+E29wi+JzOQrmkM5lAWpDFjoc6BglJ/xJCuxbcCkbhTVmzCjsZzccVXSWvk5RBH85W3erRN6PI1wUbkFyXLDAxuJ3srlKu/2FXAsf4595TN6HB51fxvm1g1R9YbLFi4q4QaWncLDQi9Lh6+UUFrlHmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH7PR11MB6652.namprd11.prod.outlook.com (2603:10b6:510:1aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Thu, 20 Feb
 2025 06:51:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8466.016; Thu, 20 Feb 2025
 06:51:00 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: Zhangfei Gao <zhangfei.gao@linaro.org>, "acpica-devel@lists.linux.dev"
	<acpica-devel@lists.linux.dev>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, Lorenzo Pieralisi
	<lpieralisi@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Moore,
 Robert" <robert.moore@intel.com>, Robin Murphy <robin.murphy@arm.com>, Sudeep
 Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>, "Alex
 Williamson" <alex.williamson@redhat.com>, Donald Dutile <ddutile@redhat.com>,
	Eric Auger <eric.auger@redhat.com>, Hanjun Guo <guohanjun@huawei.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Jerry Snitselaar
	<jsnitsel@redhat.com>, Moritz Fischer <mdf@kernel.org>, Michael Shavit
	<mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Wysocki, Rafael J"
	<rafael.j.wysocki@intel.com>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: RE: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Thread-Topic: [PATCH v4 00/12] Initial support for SMMUv3 nested translation
Thread-Index: AQHbKyrWDF3jObQSjkeRms2pcvbWarK0C1MAgABtioCAAAY7gIAAGZ+AgADnOQCAAIh9gIACsFIAgGr39QCAFPmxgIANHEiAgABxR4CAALdzAIAAdeUAgAFjOYCABOwsgIAA26KAgABqtxCAASfiAIAATP4w
Date: Thu, 20 Feb 2025 06:51:00 +0000
Message-ID: <BN9PR11MB52764E131435DF44370653CD8CC42@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241113164316.GL35230@nvidia.com>
 <6ed97a10-853f-429e-8506-94b218050ad3@linux.intel.com>
 <20241115175522.GA35230@nvidia.com> <20250122192622.GA965540@nvidia.com>
 <284dd081-8d53-45ef-ae18-78b0388c98ca@linux.intel.com>
 <f7b6c833-b6c1-4154-9b77-13553e501f2b@linux.intel.com>
 <20250213184317.GB3886819@nvidia.com>
 <bc9f4477-7976-4955-85dc-3e05ebe95ead@linux.intel.com>
 <20250214124150.GF3886819@nvidia.com>
 <58e7fbee-6688-4a49-8b7a-f0e81e6562db@linux.intel.com>
 <20250218130333.GA4099685@nvidia.com>
 <f7e30bd8-ae1f-42fe-a8a6-2b448a474044@linux.intel.com>
 <BN9PR11MB5276EAD07C3B32517D339DF28CC52@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7027fb3a-dfb4-40ae-ac9c-5ea1dcd57746@linux.intel.com>
In-Reply-To: <7027fb3a-dfb4-40ae-ac9c-5ea1dcd57746@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH7PR11MB6652:EE_
x-ms-office365-filtering-correlation-id: 2698a717-e6fe-4dba-93da-08dd517aefd5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bVJnK3Nnb2JYa3Q4VmpyV1JvNUN5eTBlWEl4cDVBQk5pM1B4TWg2YjBvSndB?=
 =?utf-8?B?ZlZVa0Y4UTlGS21LRVczRkJFdjFtK0c4Y0FMeVhBOUwyUlM2NlBmSG80ODE4?=
 =?utf-8?B?OWlEM0paa1RmYUVlUjFTemtxUDlNYnhHUkVEK1VDbEk2WWJaTWpUZDlKeHIv?=
 =?utf-8?B?eEgxYWdlWjlLU0tPdkx0ckUyVy9jZ1IxSDVCQ09nbFFoaENxRGFYRERDWVQ4?=
 =?utf-8?B?ZUUwak9wUE4xUGlIZHhYY3F5MzF6Ykg2bDJhZ0U4WGFENnJxSG1EdGcrQXlo?=
 =?utf-8?B?b3o4cUkyL25ZV2k2c2dHZlJzd1FMVi9QYnVzZ0RLSWtFMFFPYmlmTnNOMkk0?=
 =?utf-8?B?RFplSXRxVmt3TXFiZTFOaDRZTW81T1RMOWtKREgvQkxTS2s1d3U0M2tjaXlC?=
 =?utf-8?B?Q2g1dWpEZE5aUGNXeENyY083NlBIeHJaSnd1MndHZkxQS2VtalNkclpSM2hj?=
 =?utf-8?B?SDlVaTB4UVI4aDl1b1dMem5ueVN3bk1YWFZjWXlTSjZtd29ZVDVjQ2JpN29Q?=
 =?utf-8?B?akk5RGRZeWdhSmJVZmFuMWRlZWhDcnhiY3FGKzA5ODkxTUtoYzE2aU9MZ082?=
 =?utf-8?B?Q3hxa3l5emF1QUZpNFlEMWY1M3BEVkU5ZFJmNXJoWmV6b2dyczNuREFYUjJW?=
 =?utf-8?B?bEhqNnBBR0RKYlJuYWw5MEo3b1ZzTTJpQzd1Vnp4RG9qZXlaVjFvWnJ6THJq?=
 =?utf-8?B?TGMzYWFrZUpuRUxmM044WTFCb3Y3MWFjMSt5bzI5Z1k4NGlCcWViRFBSRlgx?=
 =?utf-8?B?Q2FYZXFWejJ6OE03Y2k0WlRIall0U2FtTzNmNjhBMDZwT1pZVVc3ektuKzNN?=
 =?utf-8?B?VkRUd3FMbnlmN1dLa1o4a000U3hrc1dnYzFCZUszOVdMdHpwRFkrNHRWeURk?=
 =?utf-8?B?MnUxZUloOWdsZnUwMy9PR3FTbXU2QVlZb00rVG5DMUVKSjNRNk1DMzlBZHY2?=
 =?utf-8?B?THpkQ1dxYzVabkJ3aVdkMDdmc2FDL1RvdUlQamNPWTN0ZHlFWXJLbUxRdHht?=
 =?utf-8?B?M1lsVGd3UlZhcmQrNG5WK0xNSGszTnFNUGVTZVlBZGdDdGdyTXNja2NRVDA5?=
 =?utf-8?B?WVQ2NE1wRFRpbWs3Uk9MeE9Fb3FRamVqMFNxNms5c1dpK3lxTG9LTWprZ1la?=
 =?utf-8?B?c05vNlpuZjVSa1hBQUxENnJLVmcwZFVWaG00aUFNdHdSR3BQWlg5emR3aW9k?=
 =?utf-8?B?eHRKRnczMmJMZzJpTDRCZ3hBUjB2NzZoNWNzazIrZEdCWDVVMjVQRitIMGV3?=
 =?utf-8?B?TUZNNDdPbHZCelJlbVJTUU5VMnlxYjNDaEE5YWhGTkJPaE82YTZMYUJVM212?=
 =?utf-8?B?Z0Q0YURUcjFYL0JDYjNaMmVYSGRMV3piWGNmOG5BcEM4QUhxeElDT0lpR2gz?=
 =?utf-8?B?blNOc1gzcGdoSlBvUXNBaUswVlpYaVRRV2FGbDdjNUYweDB1SndYcmNLRGZ4?=
 =?utf-8?B?c3VuUVhoSnR1bzZJWFFhYkNwbXdMbHhJUXNLMlB4ZHNyUmszd0sxYWJoYzd2?=
 =?utf-8?B?SS9GZ1R6N1FCYjZXVDVvdUZKcmxhVlA4UkExaW1oUmp3WVpXUlVjRHppdVdy?=
 =?utf-8?B?YU5MZE9HZXNQRHdCY21WQkpVQkdvVTFwS0ZFelY3S0FSYmIrQTdtK0Qrci9z?=
 =?utf-8?B?NGZ1blFxUWdmbzFjQmR2M2k2dW5JQ1l6N0hldjY0T3JHaGs5NjhXeHc3SGVn?=
 =?utf-8?B?Wit6dENyckdWN21DZFBWaUdYeUdXL2c1VGYrdnhnQVBmWi9JSmFrRzVPTFFN?=
 =?utf-8?B?TWEwS2dYM1ZpU2lyYmZyRzlXblpjcGo2L3NTV2pUN3VLdmlvL2oxaHpsVm9F?=
 =?utf-8?B?NVYxcUgyNkNVMXprcWdWRVI0Yjg2ZVNmZGRmaEtrUUpuYXh4dzJ3Y1ljWnl2?=
 =?utf-8?B?OUVSUDVkNEZTUXZTRk5lSGJhcGtQdk5WQUtLVDNZQXdlQjAvVHNIZVVjOURE?=
 =?utf-8?Q?z4QOITVefS7OYy7wqyYfpKmVapuIJluL?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dElDRnVwYjkxM3RTdnM3c0tQbzJmQ2lwaUhRcE9rNWJKVjdoblZjeVBSUjI0?=
 =?utf-8?B?WFl2M2ZEZVRUQUFiZ3B3aVQrZlhDaW1lY3g1Yi9IdWtsc2NiTUdZU3hRdGJF?=
 =?utf-8?B?Z0h4WllFREp4SUdMRXdra2crNlVYaGozVm56OHFqc3pJMmVqOU92RzRPMUVR?=
 =?utf-8?B?ZXRDR3RXWVh4U05yWHYxelpxa09PWk5ra3lacThEdmJEelhoeW1DUFRRN3pD?=
 =?utf-8?B?MHIwUnJ6bFNML2RwMVdLcnhJOHZENUF5bWlxbjFPL25wYnAvTjJDREFiMmIx?=
 =?utf-8?B?N1dINTlqWFF6R1hTUW5LZVdreWNEaXVYRTRYemZpb0ZpLzFDTGtLUXBid00v?=
 =?utf-8?B?dGkxeVcrN1pJc2FOdk5pM3BYeER1NlpzMXRuV1ZpN1BFc0hZWWRIRDNDclox?=
 =?utf-8?B?WGtEZ0c1WFloVlRGU1AvemNVT2xPVkFleGVQRWRtak9sSE0ydHV5RzhOaSsx?=
 =?utf-8?B?YjM2SzdTRTcvdVJDcHVLc1VhNll1Wm1LdDlIS3czZ1pYS1JXZ09zM2dBd1Bo?=
 =?utf-8?B?UTRsYy9aNjQ0dk80VzR1RlZTTGJqNFRxRzhIdVFaOW1EY0pnU2sxVWtrdGI2?=
 =?utf-8?B?NjNTT3EvVHNtaEZNdXg1Unc1a2swRG9LWDdzaU50enp5TVRZRUhPeDJwSHdW?=
 =?utf-8?B?bXE1RU9qZndBVktqQmsxUFpwZXhzM0x1ZUtWcTRlbWRNWU5xSFMxRUJPR1J1?=
 =?utf-8?B?ejZTdHVkZmJla1J0REZubk5rUzFHTXFReUdDTi9ES2tjQTc3ZkprY0lSc0VF?=
 =?utf-8?B?dEZGR1RnQnRTNTRzbzEvZytGOUZ2VmhERnlBMHpDYVRQeitOZ2dleHBXOGJw?=
 =?utf-8?B?L0IvVTdaSEcvbXJzTCtzV3BMam9FZ29OamR6REM2VjVJc0I5UUxkcWVhZzBF?=
 =?utf-8?B?LzR3YndKTi81blViK2VodnUwcit6OVhNT012WFR6a3BUM0VyK1ZEZEV0MmtK?=
 =?utf-8?B?NjJhdHQvTmRXUElLZ0dYcjhhZ1EvWURjQlVMaDQ1TFFXWjFZVDNYbFVwQVBm?=
 =?utf-8?B?cXVRK1FDWGFFVGZlVUpXWGlDVnJmWEkzS05hc3k3bUVhMnY5QU1Nd1FUR2RK?=
 =?utf-8?B?UU83bmxqckpoS1dLVGxiekFycXlZT0VDQit2dVVOU2h3V0ZRZk9jMmduN1Ny?=
 =?utf-8?B?aEd6d25DQmR5UmZzVE9mMEE4R3dCblJRV3VJV0FVQUM2R1pURU9mL0hibDJO?=
 =?utf-8?B?TEhDYXFKcldCb1UrNnRGN01EQzZVaGdncjlEYmVra3Z4SS9pazdxNUVnSjdr?=
 =?utf-8?B?WGFEcjQrQ0h3MHcyZ3pKRDBHbHNlUDhXbmljcGlYZ2xScS9yNGFZeXVaMjlQ?=
 =?utf-8?B?M25maXJVazZjN3VsSWxodHNBMi9HNG5WK3VHc2RJZlN3UlZGd3I1RWZFTFVv?=
 =?utf-8?B?cUE1dG1oVzBBdkQ1OFhkTVRLb01XaE1CY3hGMEJFN08yQ1BZZExsM2FLM3d6?=
 =?utf-8?B?MTQyaXdveU81aTRvbVFqU3RIaCs4cmhNdHZDdktoa0p3V0RGM0VRU0dScWJn?=
 =?utf-8?B?cU03TGlrT3JCbEMwWEVlTXZZN2xHdHkrVjJUWUZMVDZWOE5jTU5PdkJUVGxn?=
 =?utf-8?B?SCtVWkNkOFA5ekFNN1FVK1NkNEVtOUpYa29xWDF2Sk9hUU4vdjE2YnRhMnRX?=
 =?utf-8?B?UldldDFwVGZBM3pRaEllc01KZFVmOTBNNlYzVGlQZ0M5Z0ljSllxQ2p3TkY4?=
 =?utf-8?B?N0UyRFNVZDU4QkUwVEhDY0FtbHpqMVpmOUVJa0t6WUdSeGxhNEIyeVI3NWQ0?=
 =?utf-8?B?ZEFra0xpYzV0MEp1Z1Rxa1MwVEdBSzU4VlFSRG1nR2QvVCtSUmNxTnFqM1dB?=
 =?utf-8?B?WjdYd1d2K1pzWTJsc0h0RWgvdkh0Wm55cURxTStWaFN6aytTVXVPazk3YmhF?=
 =?utf-8?B?M2p6b0UyR09MODM4RWtKa3djMHNPdXR1dEt3UzdlZzBmVFQ5ektzdTc0aDRx?=
 =?utf-8?B?R1QrU0l2L2FUMVBqQXNNY0NhSXBHa0JER2V3VzBMb0hLeWJnSFlSQ012Q3Fx?=
 =?utf-8?B?ZHVpR2hBUXk3aVlmam9OSGc1WVN2WTdVNlFUaXgvUjNkR2ZiNXFrR1lPRjlS?=
 =?utf-8?B?QS8wZ1FOR0tqbyttL1ZOb1hsNmt0cXN3Z3NOOHpTRndpaDVsbjZMNm03UlMw?=
 =?utf-8?Q?5bVGV/aniWU1SbtcDQSSqb9Pr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2698a717-e6fe-4dba-93da-08dd517aefd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 06:51:00.7563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wEtSwsFlMWy4hprpHt6Lom/qcGEK+6JwSs92btu/SVk868nCPM/iQ2Kv70f7Vcqg4WFMdR5wFwnVokVBy/lX8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6652
X-OriginatorOrg: intel.com

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgRmVicnVhcnkgMjAsIDIwMjUgMTA6MTEgQU0NCj4gDQo+IE9uIDIvMTkvMjUgMTY6MzQs
IFRpYW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXgu
aW50ZWwuY29tPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIEZlYnJ1YXJ5IDE5LCAyMDI1IDEwOjEw
IEFNDQo+ID4+DQo+ID4+IE9uIDIvMTgvMjUgMjE6MDMsIEphc29uIEd1bnRob3JwZSB3cm90ZToN
Cj4gPj4+IE9uIFNhdCwgRmViIDE1LCAyMDI1IGF0IDA1OjUzOjEzUE0gKzA4MDAsIEJhb2x1IEx1
IHdyb3RlOg0KPiA+Pj4+IE9uIDIvMTQvMjUgMjA6NDEsIEphc29uIEd1bnRob3JwZSB3cm90ZToN
Cj4gPj4+Pj4gT24gRnJpLCBGZWIgMTQsIDIwMjUgYXQgMDE6Mzk6NTJQTSArMDgwMCwgQmFvbHUg
THUgd3JvdGU6DQo+ID4+Pj4+DQo+ID4+Pj4+PiBXaGVuIHRoZSBJT01NVSBpcyB3b3JraW5nIGlu
IHNjYWxhYmxlIG1vZGUsIFBBU0lEIGFuZCBQUkkgYXJlDQo+ID4+IHN1cHBvcnRlZC4NCj4gPj4+
Pj4+IEFUUyB3aWxsIGFsd2F5cyBiZSBlbmFibGVkLCBldmVuIGlmIHRoZSBpZGVudGl0eSBkb21h
aW4gaXMgYXR0YWNoZWQgdG8NCj4gPj4+Pj4+IHRoZSBkZXZpY2UsIGJlY2F1c2UgdGhlIFBBU0lE
IG1pZ2h0IHVzZSBQUkksIHdoaWNoIGRlcGVuZHMgb24gQVRTDQo+ID4+Pj4+PiBmdW5jdGlvbmFs
aXR5LiBUaGlzIG1pZ2h0IG5vdCBiZSB0aGUgYmVzdCBjaG9pY2UsIGJ1dCBpdCBpcyB0aGUNCj4g
Pj4+Pj4+IHNpbXBsZXN0IGFuZCBmdW5jdGlvbmFsLg0KPiA+Pj4+PiBUaGUgYXJtIGRyaXZlciBr
ZWVwcyB0cmFjayBvZiB0aGluZ3MgYW5kIGVuYWJsZXMgQVRTIHdoZW4gUEFTSURzIGFyZQ0KPiA+
Pj4+PiBwcmVzZW50DQo+ID4+Pj4gSSBhbSBub3QgYXdhcmUgb2YgYW55IFZULWQgaGFyZHdhcmUg
aW1wbGVtZW50YXRpb24gdGhhdCBzdXBwb3J0cw0KPiA+Pj4+IHNjYWxhYmxlIG1vZGUgYnV0IG5v
dCBQQVNJRC4gSWYgdGhlcmUgd2VyZSBvbmUsIGl0IHdvdWxkIGJlIHdvcnRod2hpbGUNCj4gPj4+
PiB0byBhZGQgYW4gb3B0aW1pemF0aW9uIHRvIGF2b2lkIGVuYWJsaW5nIEFUUyBkdXJpbmcgcHJv
YmUgaWYgUEFTSUQgaXMNCj4gPj4+PiBub3Qgc3VwcG9ydGVkLg0KPiA+Pj4gSSBtZWFuIGRvbWFp
bnMgYXR0YWNoZWQgdG8gUEFTSURzIHRoYXQgbmVlZCBQUkkvQVRTL2V0Yw0KPiA+Pg0KPiA+PiBZ
ZWFoLCB0aGF0J3MgYSBiZXR0ZXIgc29sdXRpb24uIFRoZSBQQ0kgUFJJL0FUUyBmZWF0dXJlcyBh
cmUgb25seQ0KPiA+PiBlbmFibGVkIHdoZW4gYSBkb21haW4gdGhhdCByZXF1aXJlcyB0aGVtIGlz
IGF0dGFjaGVkIHRvIGl0LiBJIHdpbGwNCj4gPj4gY29uc2lkZXIgaXQgaW4gdGhlIEludGVsIGRy
aXZlciBsYXRlci4NCj4gPj4NCj4gPg0KPiA+IEkgZGlkbid0IGdldCB0aGUgY29ubmVjdGlvbiBo
ZXJlLiBBVFMgY2FuIHJ1biB3L28gUEFTSUQgcGVyIFBDSWUNCj4gPiBzcGVjLiBXaHkgZG8gd2Ug
d2FudCB0byBhZGQgYSBkZXBlbmRlbmN5IG9uIFBBU0lEIGhlcmU/DQo+IA0KPiBJdCdzIGR1ZSB0
byBQUkksIHdoaWNoIGRlcGVuZHMgb24gQVRTLiBUaGUgb3JpZ2luYWwgdG9waWMgaXM6IHdoZW4g
YW4NCj4gaWRlbnRpdHkgZG9tYWluIGlzIGF0dGFjaGVkIHRvIHRoZSBkZXZpY2UgYW5kIHRoZSBk
ZXZpY2UgaGFzIG5vIFBBU0lEDQo+IHN1cHBvcnQsIHRoZW4gQVRTIG1pZ2h0IGJlIGRpc2FibGVk
IGJlY2F1c2UgQVRTIGlzbid0IHN1cHBvc2VkIHRvDQo+IHByb3ZpZGUgbXVjaCBiZW5lZml0IGlu
IHRoaXMgY2FzZS4gDQoNClBSSSBkZXBlbmRzIG9uIEFUUyBidXQgUEFTSUQgaXMgb3B0aW9uYWwu
DQoNCkFUUyBoYXMgbm8gYmVuZWZpdCAob3IgZXZlbiBtb3JlIGNvc3QpIHdpdGggaWRlbnRpdHkg
ZG9tYWluIGJ1dCBhZ2Fpbg0KaXQgaGFzIG5vdGhpbmcgdG8gZG8gd2l0aCBQQVNJRC4NCg0KPiBP
dGhlcndpc2UsIEFUUyBzaG91bGQgYmUgZW5hYmxlZCBiZWNhdXNlOg0KPiANCj4gLSBJdCBiZW5l
Zml0cyBwZXJmb3JtYW5jZSB3aGVuIHRoZSBkb21haW4gaXMgYSBwYWdpbmcgZG9tYWluLg0KPiAt
IEEgZG9tYWluIGF0dGFjaGVkIHRvIGEgUEFTSUQgbWlnaHQgdXNlIFBSSSwgdGh1cyByZXF1aXJp
bmcgQVRTIHRvIGJlDQo+ICAgIG9uLg0KDQpBYm92ZSB0YWxrcyBhYm91dCB0aGUgZG9tYWluIHR5
cGUuIE5vdGhpbmcgc3BlY2lmaWMgdG8gUEFTSUQuDQoNCj4gDQo+IFRoZSBwcm9wb3NlZCBzb2x1
dGlvbiBpcyB0byB1c2UgYSByZWZlcmVuY2UgY291bnQgZm9yIEFUUyBlbmFibGVtZW50LA0KPiBz
aW1pbGFyIHRvIGhvdyB3ZSBoYW5kbGUgaW9wZiBpbiBhbm90aGVyIHNlcmllcy4gQVRTIGlzIGVu
YWJsZWQgYXMgbG9uZw0KPiBhcyBhbnkgZG9tYWluIHJlcXVpcmVzIGl0IGFuZCBkaXNhYmxlZCBp
ZiBubyBkb21haW4gcmVxdWlyZXMgaXQuDQo+IA0KDQpJJ20gZmluZSB3aXRoIHVzaW5nIHJlZmVy
ZW5jZSBjb3VudCBmb3IgQVRTIGVuYWJsZW1lbnQgYmFzZWQgb24NCnRoZSBkb21haW4gdHlwZSwg
YnV0IGp1c3QgZGlkbid0IGdldCB0aGUgcm9sZSBvZiBQQVNJRCBpbiB0aGlzIGRpc2N1c3Npb24u
DQoNClByb2JhYmx5IHdlIHdhbnQgYW4gZXhwbGljaXQgaHdwdCBmbGFnIHRvIG9wdCBmb3IgQVRT
LCBqdXN0IGxpa2UgdGhlDQpleGlzdGluZyBmYXVsdGFibGUgZmxhZy4NCg==

