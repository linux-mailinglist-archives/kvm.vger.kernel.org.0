Return-Path: <kvm+bounces-38830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75401A3EBDC
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 05:29:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81DDC3A6C9B
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 04:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38B01FBC91;
	Fri, 21 Feb 2025 04:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U2WQ8VZF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3491D6DDC;
	Fri, 21 Feb 2025 04:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740112136; cv=fail; b=Mr1c2dnm0YQmPyNP5+KZvENM+leq8HZ2/CW2m+BiwU1bKULaBQgPEw06XXk8YiLLGRxg5kbZ0QjS6yKadwXfU2nUZOBlWNmtMxtr/oiks7ZPbnyayUfVZ7IWo3oDy9UvFPA2th6Ztt0q26Bnn1SfkMIHVnLDHZBOY6WDr6ct6vY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740112136; c=relaxed/simple;
	bh=8/U28zvL4AByA59tihdBjZKLTB0o0jDvloZYxtipI3g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kMpYsNLqQTQy+ygx13OmL/G1uCfEZSfZDNmSxNAAgrX+CeJuvVQu4SBj+kLiAauE8Q7zBQi3Z6V0IDUXbwL7W3hDGtYT8JFzFBjf03Mk8TFMTR0vxfrqgaVAueiLYbX1oE9I7ny2N99gpIzTiUOLcXhQL5V1UNdksEBcBTT3WPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U2WQ8VZF; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740112135; x=1771648135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8/U28zvL4AByA59tihdBjZKLTB0o0jDvloZYxtipI3g=;
  b=U2WQ8VZFNngzxeoNzZ1LdxqYj0xT6j+2oWCtUSoVNexUss97Ezb/sje1
   fOViL20jkbjLqWCfJ9Kw+VHG35bBbEprsIO3AcL5WBI7P7u5OiuOFULbc
   33IMMk5p0ZYvlqxT+oPO0+15iWu/BVfu+L6448RI8gXQVZOerr3fcQrF1
   iewNg1KLGvcrQl75qeCqwJatP8i0oRnFj95unBrQwb5xI0E0+lKvxZGnW
   G3cAWoih2JyhFhOkxW6L+Qg1MaaK+iLYnkieRuOCqtQPbOT7ocgj+hc+Q
   RDp3pBwFWbmnQtTCfScS2dDq7aQ7lLi8BnP3kDlRiG5IcaiDkidmXpYOs
   Q==;
X-CSE-ConnectionGUID: DjDC03PBRTmaDDPXhYKItg==
X-CSE-MsgGUID: t1HcghvPSgCb5eTmKdhucA==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="44705251"
X-IronPort-AV: E=Sophos;i="6.13,303,1732608000"; 
   d="scan'208";a="44705251"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 20:28:55 -0800
X-CSE-ConnectionGUID: I120jAdlRXOa7ZE5cPnYBA==
X-CSE-MsgGUID: /w6wlD7STPmbs7XBD+5iHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="120490153"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 20:28:55 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Feb 2025 20:28:54 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Feb 2025 20:28:54 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Feb 2025 20:28:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CcZFoaLTHR9hdxAnUwa28nhxLXtWRIhcs/+L+QDzZO0Hrb0sFgYzVH+fhbH2okztOmxec5nBIXBa64bSbu/2UcNrsB3DgHRci3GDEU+fO64+3ehQS0JEV0vd/WvXBQDF5dg9Ou5AARgM5ecuwLlGmkMushGyGe9i/1iJCQAl0yE+ViVp2GEDOcR037vhXoHLMJslJvIKBRbsz7qEQMvja7Kc9crEGFXX4irl5KZtc099inPDEnoiqlMubs0DW2MAXNPwOmrqoy+ZMBrEHeoIPQgSAwQ4Gd2BpiKlJhNyAw3+vSjUesKW4o06l2x3n3rBQEBk+ybxgQlhWjbtuz0Lag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/U28zvL4AByA59tihdBjZKLTB0o0jDvloZYxtipI3g=;
 b=wzTLTuQumi594yXhwrt9yYoDc9zbNJtaxa26jW4z/xH8TjvAFkaD04sK0/fN26NQaPaRMHIqSV55AuNbjwL4NP7GkwPDWV4B0STbAR+r5XkstcmeAVoYxi6kd0DKzGfMYA497PAGDw8IbA+QMo+rtwE6kBKdD2ulcbNgBU3n7u/qj7HPe7Ue9N+sBzn7QXfa2rGrCphr3N+60XRLSm9grPHxYqyEtgVd6oZ5L9Kl7fUGy6aSL9J/AkNsS/etFcSiMTRZ2UOjUItW7HZKiN/4fYNNJ1pigci9RfBaJGFhQ/s5wdNVsUpo4RytC9LDg0IvofWpfGKr7VoPmxzLarX4XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.14; Fri, 21 Feb
 2025 04:28:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8466.016; Fri, 21 Feb 2025
 04:28:51 +0000
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
Thread-Index: AQHbKyrWDF3jObQSjkeRms2pcvbWarK0C1MAgABtioCAAAY7gIAAGZ+AgADnOQCAAIh9gIACsFIAgGr39QCAFPmxgIANHEiAgABxR4CAALdzAIAAdeUAgAFjOYCABOwsgIAA26KAgABqtxCAASfiAIAATP4wgABUnYCAARcLcA==
Date: Fri, 21 Feb 2025 04:28:50 +0000
Message-ID: <BN9PR11MB527644D4478318D4DE0E027A8CC72@BN9PR11MB5276.namprd11.prod.outlook.com>
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
 <BN9PR11MB52764E131435DF44370653CD8CC42@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c57977e2-d109-4a38-903e-8af6a7567a60@linux.intel.com>
In-Reply-To: <c57977e2-d109-4a38-903e-8af6a7567a60@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB7529:EE_
x-ms-office365-filtering-correlation-id: 962bb4b9-7f07-49a3-7bcc-08dd52303e1e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bVRIekx5bjdvWS9UcjltQUl6U0RoSTVQZ1BYeFYyUzN1M3FNUTZqQVBqbFda?=
 =?utf-8?B?YWxqdjBzUitZSVIwTnNOOXVtN0plVzlPNEpoMHdYalBKakFabmNpOWF0T28v?=
 =?utf-8?B?bmFGZ245bWc4QmFkaFJCQTRvdkFPMlBoTjJ1R05aVm5vcnVPTjc0alB4aGhs?=
 =?utf-8?B?bTBkdm5PdkV6b1FRWWt4cDFNOXNQbVBxV1lmcmR1ZXVjUm0xNjJVMUhqL200?=
 =?utf-8?B?elhyem11ZWpQRW5JTEhDenB5SFF5RWQxSis2bkR1UlpOWHdvb3RCNXlQSGsw?=
 =?utf-8?B?aHM3eVMrN2Jiam9DNThmeUJmREVWWnhvNW1rVEtRRDg4emp1TExsdjQxRk16?=
 =?utf-8?B?M1FxZ1JiSUhuTWJoY3g2YkZiZUFCb25TOW5haDNidFM3aDRJNEs3bDJLZGQ1?=
 =?utf-8?B?M0JnRENxMjNGbjRvQWt3Y1lQZzdabW5CY05QNjl4UFZ3bGt5RXNlQUEyUi9Z?=
 =?utf-8?B?VTRQYzJqZ0psVHVrVUxXNzQ0T2Eyamt6NHBNb3kwRUdBZ0IvaVdGU29hcGZ5?=
 =?utf-8?B?WnFPR0dBc1JGSFZtWjJ4eUpBSkdUMWhicGI3a3BWanRRUTU2eE5YT0Rwd1Bo?=
 =?utf-8?B?TDEwc2lPclhVUE1BREMwY3B3bDJDTGxGZ2lNOWErZ25OdGJRRFoyZ0Zndk9O?=
 =?utf-8?B?OUMvYWNEdUxOUTRHNzhBVVNMc0JEYktiV0xnVG1xSWpCVy80bFUxdmQ2WW1Y?=
 =?utf-8?B?NlFqQzZWdW1VR3p5Z0EvbGFEUmJMLzBqTEticHpkY2ZKa1R1MnByK1FNUm4y?=
 =?utf-8?B?YlJnWkhkb3lVaUdFUjlRV2QwbTZTc1NKSWRPL05XNmUydll2cjZTcHM0aTY4?=
 =?utf-8?B?SnAwa2txVzlYUldqVjJzQTJSUmhpeXMzRnRjS0dPcjhzbHpPQ0hieXBsaFRq?=
 =?utf-8?B?TkY2WWVQbkFBRFIwYldOQmFqZW05QmNkTW5KTzBhMHVxbU1LRHBTWVlaK0dR?=
 =?utf-8?B?NTdDMDFuM2NjU1J1eXlWTkxISVEreUdPeFk3OThCUjQwOWFIUU00WVpaK2pI?=
 =?utf-8?B?SDlGSVBPMGljT3kxaVFDY0NDbUYxMi9wRURydmFLTDV0RXdXL2pnMzZvZTRG?=
 =?utf-8?B?eml5M2RSOWxvMXV2MFdQbmJqYzVweUFYR2JNSGpNTHErZklqVlNXdGJiV1BG?=
 =?utf-8?B?WnI1Sm9vRmtZc3BCSEhxZ0p0eEI5ektjVWlLOU5aMkkydGpCVTAwWUVrS2pw?=
 =?utf-8?B?YlV4QWROc3lyY1c3eVROenZMVDVnYk9LdHhocFAwUFc4eUIzbW5kWmFCOFla?=
 =?utf-8?B?N3YwTCt1UXg2cU9NL3VrVUNmTFQ3d2dMbjVDSXBrWlJjTDFDLzJSUE5LUWFt?=
 =?utf-8?B?WFBUSDRERWZTSERBbFJmLzY2Y1E0VTVGR3k2TUpRYnZ2OHFFbG5NRnIrQTlj?=
 =?utf-8?B?RmYrQ3FRWmx1TXZiYWtDZGZzeDdrZWttOVk4bHhsdHBPbkRBdElsOG4zUUli?=
 =?utf-8?B?Qy9wN0FZVHcvM2lWRHZiOEFnVUFRL000eERPYlh5NjZSQVoraERaMWZYQmRw?=
 =?utf-8?B?ZityQm5JbXpXTFhnc1g1SEJIK0N3YkZnM0RHVXhxcDVOL2IwV21CNDRNMzhK?=
 =?utf-8?B?NUQwNXd0cjlCTm54d1VLVStab1E5aXFnS2RNTVNSVUNYUGxoVUQzdGUvRkk0?=
 =?utf-8?B?TnYycFpGVGtQb0ticFF3WDVzRVRoQTFHOHBaN3pQRXdyTnFtVTI0ZXhlSm5k?=
 =?utf-8?B?YmtXdkxBYWZkVHdTdWVueVB5SDlVL1I3VjFCSHgxNzVvdHVVWWllWGxDTVZN?=
 =?utf-8?B?dWZSUU56cnNDV1BwMXVJaytVSG1BM212bFE4TXRjbnN2YVoxSSs3R09tRk9T?=
 =?utf-8?B?SkkraytsZHhnWVQvRTJqTUtQKzhjK3AwOG44UThDVGNIcS9Rb1MwMTRMdXFH?=
 =?utf-8?B?c0NmaHpVMUZab2tpajdYTVdGeHNhajFZSUFHZWF2RHJUdnQ4SlBmS3VuS0h0?=
 =?utf-8?Q?f1H/P9p0G5F6WLp1fZDstl5FC8mYos7+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFVtYVBwMnNaM2RBTTl1WDRxSDJYeEZlUXpEZHZOWlU5TTltanMwcGMrc2s5?=
 =?utf-8?B?eXNRUzc3dHFuSm5zek9BOEZxMmxDY0lMWnUzRHg2NDhmTHMydTVSaXBodXdY?=
 =?utf-8?B?ajViQXl0bTRScVdWemlHUmNSRW5yRlpoSlc0eFdoMFVVWDZsZEViK0hGb2Rn?=
 =?utf-8?B?Tml2WXllTmVidGF3NWl6Y1Q2dURvckJVS3NvVll3YlZQWmZrRmEydk0yTHhl?=
 =?utf-8?B?Z2NlMFd3WU5ORGpiSmdoV3BEcTlxcVlJL2VHNy9VazdPZzZpM1RYbzlpVVBT?=
 =?utf-8?B?M0tZc2tyZlVCb2x6QWZ4eTVCREZYdW5Gdk9lbTVvOGJ4Qk02RW1ySXN5dUV0?=
 =?utf-8?B?UVJITTJYMHhxekVkTjJ4VU00R1c2WEwwTDFuODhtT2czemhhU0FZWmRIdndp?=
 =?utf-8?B?K3luanBDbVBEN2MrSFpsZ1QzNXJ3UHVLUEhnckdBcHdjWWpqRnBhOEY0Y2Z3?=
 =?utf-8?B?bWNlYVN4Zm9BRHRIQmdGaW1DeEVZUXVEQ2tWVjE4QnNKNW9mQmhxbkFCSWUz?=
 =?utf-8?B?WHJ0dzlZYi9MVCt1dFV6eTNRaEdpb05EVTlqdnBaSDZLSFBxcFVXUUlwMmJy?=
 =?utf-8?B?Q0cvN0h4NVlNaHhWY0hhZGczMTFDRE0za05TNVozeGJRemNtOXptbkxZelJl?=
 =?utf-8?B?a29mYUpabThML1JlSlZrektha0tnVmRoWFd6K1FxZ0FTdmlDR2ZSRU5TN25z?=
 =?utf-8?B?Y0NsOGk5ZVJzcFNuek1wWEd4WHo5a0phM2NhTFFuWVF5YVhmWWp4UkVmTCtQ?=
 =?utf-8?B?MUtiRFlKd2Z4L01LWE5pVVY2bExYQzA5cWg3cy9YdEc5bWNRekVxUHRSL2x6?=
 =?utf-8?B?Y0FYSFNWMnFvOCtPbkJ0SjllNzVmVSt5NTRuWTREVEJERm5LNDFSTGZLM2Nz?=
 =?utf-8?B?RWtqTXZpMEs0NGhFam1OWUJxY09TOW0zSUlUSkpYMkZLK1p2bi95MkNES0Zr?=
 =?utf-8?B?bkNJQklVcFRBdWFIdE45REFIODkyWjhCemo5aXJrdStYTkRmZTJXVllCWDBD?=
 =?utf-8?B?SWF6YkE5VmwzLzlnQy9wMzlLUVdrSnRtK082R0ptVjNhcmpzMFE2UGVlb3Iz?=
 =?utf-8?B?aVB4WHZ6Rjc2RHpCL0Znb09uV0lpYnpPQjVjRlRsZ253UkNPeWJyNjVRQ2RS?=
 =?utf-8?B?azFYaUZsdnlRdVFSd2c5QTUzdUtSaCtPZmJpZkZlQ21LU2dKK0hPdkVrTjlK?=
 =?utf-8?B?VFZoenVtNElBVTV5R1ZoNnZPUjBpUTJFUXA2YWRKY3hkMVZRUk5HRGhLNVVX?=
 =?utf-8?B?UDlSR1pTR2ZxNHlGd3NZZ3JRT0hIalhiTUxTbGpZQ1VScFYzNkRydENuTSsz?=
 =?utf-8?B?OVlpQXZtOGlqZDRheEdsM0RqSHhtS0JuWUZQK0RPcStwaXpsUHNpQ0ZuTHJ4?=
 =?utf-8?B?Q3gvb1ZKMkJrMi82cThTcmtkQVdEb3N3a2Fjd1ExMG9yeEp2NXlxQ000alps?=
 =?utf-8?B?SDIzZjc2ZjJCTDYvZElCa1cwZ09Bc1RIYkRWUGxHQ2ZEZEhxOTBhWnkvNzUy?=
 =?utf-8?B?eUtib0tsYUh2eVlxK2wydXYvSzB6VzF2cTBqejdUVVFseUlJMHRabnNRNkZs?=
 =?utf-8?B?T3dJTm50U3U1cXAwZEJ6LzhublZPWDQwYWJqTXFSTUhLVmN6OUFMZmpJejdR?=
 =?utf-8?B?QVFuajIrM3VkcjdKdHBBRlMzZW5raHVDL1B3ZlBXVkdHNGJYUEc2cEwrU3p1?=
 =?utf-8?B?M2RkbVhIbmJCOTZCSW5iWFpiN29RN1pvK0I0T005UUJkdm5LOEVERWpNbXpP?=
 =?utf-8?B?ZE0yeTVaWWdNalErWS80cmtnTG5OTXA2MHdET0ZxQWhXOGJUTDczV3ZCRmdH?=
 =?utf-8?B?UTB6cTE4c1kzS3JlU2R0SjRQZmNsTmpFaDd4eGpDSk5rVXZlUGd3QVAvcEdV?=
 =?utf-8?B?VG9BUG5jaDM5Qzg0UmdISWxEQ2F1Wmd2cUpheCtraTRWeVJBOFlwcTNwWDVm?=
 =?utf-8?B?NEsxUmpJdVFCdWp5S3ZDN0pOUkllNUFWZTZMd09jbmFpUTdnakFBY2wvdjRt?=
 =?utf-8?B?UW11eTM4aXM0QjdTZ0lEWG1WRjJRZWRZbUd3VWEwOWlnVUQyeEYyZU8xL1F3?=
 =?utf-8?B?MWRmZGdaT3p1STViVTg1VFltMVZVVFRvTnRvUVFhMHRsZUxlTlpvQk42dmFo?=
 =?utf-8?Q?Nr2voHxvIqV+LYQ3d+CruhMK+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 962bb4b9-7f07-49a3-7bcc-08dd52303e1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2025 04:28:51.0150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: svCrnwqWQtJQ16tPFf3ClTEeySM9gbMtN3dVRRRSCc0g5BR28Yx5q9WAqbkP1Kjn1/gAtbXAdNY8U5Yi0YP2LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7529
X-OriginatorOrg: intel.com

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBUaHVy
c2RheSwgRmVicnVhcnkgMjAsIDIwMjUgNzo0OSBQTQ0KPiANCj4gT24gMjAyNS8yLzIwIDE0OjUx
LCBUaWFuLCBLZXZpbiB3cm90ZToNCj4gPj4gRnJvbTogQmFvbHUgTHU8YmFvbHUubHVAbGludXgu
aW50ZWwuY29tPg0KPiA+PiBTZW50OiBUaHVyc2RheSwgRmVicnVhcnkgMjAsIDIwMjUgMTA6MTEg
QU0NCj4gPj4NCj4gPj4gT24gMi8xOS8yNSAxNjozNCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4+
Pj4gRnJvbTogQmFvbHUgTHU8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiA+Pj4+IFNlbnQ6
IFdlZG5lc2RheSwgRmVicnVhcnkgMTksIDIwMjUgMTA6MTAgQU0NCj4gPj4+Pg0KPiA+Pj4+IE9u
IDIvMTgvMjUgMjE6MDMsIEphc29uIEd1bnRob3JwZSB3cm90ZToNCj4gPj4+Pj4gT24gU2F0LCBG
ZWIgMTUsIDIwMjUgYXQgMDU6NTM6MTNQTSArMDgwMCwgQmFvbHUgTHUgd3JvdGU6DQo+ID4+Pj4+
PiBPbiAyLzE0LzI1IDIwOjQxLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+ID4+Pj4+Pj4gT24g
RnJpLCBGZWIgMTQsIDIwMjUgYXQgMDE6Mzk6NTJQTSArMDgwMCwgQmFvbHUgTHUgd3JvdGU6DQo+
ID4+Pj4+Pj4NCj4gPj4+Pj4+Pj4gV2hlbiB0aGUgSU9NTVUgaXMgd29ya2luZyBpbiBzY2FsYWJs
ZSBtb2RlLCBQQVNJRCBhbmQgUFJJIGFyZQ0KPiA+Pj4+IHN1cHBvcnRlZC4NCj4gPj4+Pj4+Pj4g
QVRTIHdpbGwgYWx3YXlzIGJlIGVuYWJsZWQsIGV2ZW4gaWYgdGhlIGlkZW50aXR5IGRvbWFpbiBp
cyBhdHRhY2hlZA0KPiB0bw0KPiA+Pj4+Pj4+PiB0aGUgZGV2aWNlLCBiZWNhdXNlIHRoZSBQQVNJ
RCBtaWdodCB1c2UgUFJJLCB3aGljaCBkZXBlbmRzIG9uDQo+IEFUUw0KPiA+Pj4+Pj4+PiBmdW5j
dGlvbmFsaXR5LiBUaGlzIG1pZ2h0IG5vdCBiZSB0aGUgYmVzdCBjaG9pY2UsIGJ1dCBpdCBpcyB0
aGUNCj4gPj4+Pj4+Pj4gc2ltcGxlc3QgYW5kIGZ1bmN0aW9uYWwuDQo+ID4+Pj4+Pj4gVGhlIGFy
bSBkcml2ZXIga2VlcHMgdHJhY2sgb2YgdGhpbmdzIGFuZCBlbmFibGVzIEFUUyB3aGVuIFBBU0lE
cw0KPiBhcmUNCj4gPj4+Pj4+PiBwcmVzZW50DQo+ID4+Pj4+PiBJIGFtIG5vdCBhd2FyZSBvZiBh
bnkgVlQtZCBoYXJkd2FyZSBpbXBsZW1lbnRhdGlvbiB0aGF0IHN1cHBvcnRzDQo+ID4+Pj4+PiBz
Y2FsYWJsZSBtb2RlIGJ1dCBub3QgUEFTSUQuIElmIHRoZXJlIHdlcmUgb25lLCBpdCB3b3VsZCBi
ZQ0KPiB3b3J0aHdoaWxlDQo+ID4+Pj4+PiB0byBhZGQgYW4gb3B0aW1pemF0aW9uIHRvIGF2b2lk
IGVuYWJsaW5nIEFUUyBkdXJpbmcgcHJvYmUgaWYgUEFTSUQgaXMNCj4gPj4+Pj4+IG5vdCBzdXBw
b3J0ZWQuDQo+ID4+Pj4+IEkgbWVhbiBkb21haW5zIGF0dGFjaGVkIHRvIFBBU0lEcyB0aGF0IG5l
ZWQgUFJJL0FUUy9ldGMNCj4gPj4+PiBZZWFoLCB0aGF0J3MgYSBiZXR0ZXIgc29sdXRpb24uIFRo
ZSBQQ0kgUFJJL0FUUyBmZWF0dXJlcyBhcmUgb25seQ0KPiA+Pj4+IGVuYWJsZWQgd2hlbiBhIGRv
bWFpbiB0aGF0IHJlcXVpcmVzIHRoZW0gaXMgYXR0YWNoZWQgdG8gaXQuIEkgd2lsbA0KPiA+Pj4+
IGNvbnNpZGVyIGl0IGluIHRoZSBJbnRlbCBkcml2ZXIgbGF0ZXIuDQo+ID4+Pj4NCj4gPj4+IEkg
ZGlkbid0IGdldCB0aGUgY29ubmVjdGlvbiBoZXJlLiBBVFMgY2FuIHJ1biB3L28gUEFTSUQgcGVy
IFBDSWUNCj4gPj4+IHNwZWMuIFdoeSBkbyB3ZSB3YW50IHRvIGFkZCBhIGRlcGVuZGVuY3kgb24g
UEFTSUQgaGVyZT8NCj4gPj4gSXQncyBkdWUgdG8gUFJJLCB3aGljaCBkZXBlbmRzIG9uIEFUUy4g
VGhlIG9yaWdpbmFsIHRvcGljIGlzOiB3aGVuIGFuDQo+ID4+IGlkZW50aXR5IGRvbWFpbiBpcyBh
dHRhY2hlZCB0byB0aGUgZGV2aWNlIGFuZCB0aGUgZGV2aWNlIGhhcyBubyBQQVNJRA0KPiA+PiBz
dXBwb3J0LCB0aGVuIEFUUyBtaWdodCBiZSBkaXNhYmxlZCBiZWNhdXNlIEFUUyBpc24ndCBzdXBw
b3NlZCB0bw0KPiA+PiBwcm92aWRlIG11Y2ggYmVuZWZpdCBpbiB0aGlzIGNhc2UuDQo+ID4gUFJJ
IGRlcGVuZHMgb24gQVRTIGJ1dCBQQVNJRCBpcyBvcHRpb25hbC4NCj4gPg0KPiA+IEFUUyBoYXMg
bm8gYmVuZWZpdCAob3IgZXZlbiBtb3JlIGNvc3QpIHdpdGggaWRlbnRpdHkgZG9tYWluIGJ1dCBh
Z2Fpbg0KPiA+IGl0IGhhcyBub3RoaW5nIHRvIGRvIHdpdGggUEFTSUQuDQo+ID4NCj4gPj4gT3Ro
ZXJ3aXNlLCBBVFMgc2hvdWxkIGJlIGVuYWJsZWQgYmVjYXVzZToNCj4gPj4NCj4gPj4gLSBJdCBi
ZW5lZml0cyBwZXJmb3JtYW5jZSB3aGVuIHRoZSBkb21haW4gaXMgYSBwYWdpbmcgZG9tYWluLg0K
PiA+PiAtIEEgZG9tYWluIGF0dGFjaGVkIHRvIGEgUEFTSUQgbWlnaHQgdXNlIFBSSSwgdGh1cyBy
ZXF1aXJpbmcgQVRTIHRvIGJlDQo+ID4+ICAgICBvbi4NCj4gPiBBYm92ZSB0YWxrcyBhYm91dCB0
aGUgZG9tYWluIHR5cGUuIE5vdGhpbmcgc3BlY2lmaWMgdG8gUEFTSUQuDQo+ID4NCj4gPj4gVGhl
IHByb3Bvc2VkIHNvbHV0aW9uIGlzIHRvIHVzZSBhIHJlZmVyZW5jZSBjb3VudCBmb3IgQVRTIGVu
YWJsZW1lbnQsDQo+ID4+IHNpbWlsYXIgdG8gaG93IHdlIGhhbmRsZSBpb3BmIGluIGFub3RoZXIg
c2VyaWVzLiBBVFMgaXMgZW5hYmxlZCBhcyBsb25nDQo+ID4+IGFzIGFueSBkb21haW4gcmVxdWly
ZXMgaXQgYW5kIGRpc2FibGVkIGlmIG5vIGRvbWFpbiByZXF1aXJlcyBpdC4NCj4gPj4NCj4gPiBJ
J20gZmluZSB3aXRoIHVzaW5nIHJlZmVyZW5jZSBjb3VudCBmb3IgQVRTIGVuYWJsZW1lbnQgYmFz
ZWQgb24NCj4gPiB0aGUgZG9tYWluIHR5cGUsIGJ1dCBqdXN0IGRpZG4ndCBnZXQgdGhlIHJvbGUg
b2YgUEFTSUQgaW4gdGhpcyBkaXNjdXNzaW9uLg0KPiANCj4gU29ycnkgdGhhdCBJIGRpZG4ndCBt
YWtlIGl0IGNsZWFyLiBMZXQgbWUgdHJ5IGFnYWluLg0KPiANCj4gUEFTSUQgaXMgbWVudGlvbmVk
IGluIHRoaXMgZGlzY3Vzc2lvbiBiZWNhdXNlIGl0IG1ha2VzIHRoaW5ncyBkaWZmZXJlbnQuDQo+
IA0KPiBXaXRob3V0IFBBU0lEIHN1cHBvcnQsIG9ubHkgYSBzaW5nbGUgZG9tYWluIGlzIGF0dGFj
aGVkIHRvIHRoZSBkZXZpY2UuDQo+IEFUUyBlbmFibGVtZW50IGNhbiB0aGVuIGJlIGRldGVybWlu
ZWQgYmFzZWQgb24gdGhlIGRvbWFpbiB0eXBlLg0KPiBTcGVjaWZpY2FsbHk6DQo+IA0KPiAtIEZv
ciBhbiBpZGVudGl0eSBkb21haW4sIEFUUyBjb3VsZCBiZSBkaXNhYmxlZC4NCj4gLSBGb3Igb3Ro
ZXIgZG9tYWlucywgQVRTIGlzIGVuYWJsZWQuDQo+IA0KPiBXaXRoIFBBU0lEIHN1cHBvcnQsIG11
bHRpcGxlIGRvbWFpbnMgY2FuIGJlIGF0dGFjaGVkIHRvIHRoZSBkZXZpY2UsIGFuZA0KPiBlYWNo
IGRvbWFpbiBtYXkgaGF2ZSBkaWZmZXJlbnQgQVRTIHJlcXVpcmVtZW50cy4gIFRoZXJlZm9yZSwg
d2UgY2Fubm90DQo+IHNpbXBseSBkZXRlcm1pbmUgdGhlIEFUUyBzdGF0dXMgaW4gdGhlIFJJRCBk
b21haW4gYXR0YWNoL2RldGFjaCBwYXRocy4gQQ0KPiBiZXR0ZXIgc29sdXRpb24gaXMgdG8gdXNl
IHRoZSByZWZlcmVuY2UgY291bnQsIGFzIG1lbnRpb25lZCBhYm92ZS4NCj4gDQoNCk9rYXksIHRo
YXQgaGVscHMgY29ubmVjdCB0aGUgZG90cyBhbmQgbWFrZXMgc2Vuc2UgdG8gbWUuIFRoYW5rcyEN
Cg==

