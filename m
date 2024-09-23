Return-Path: <kvm+bounces-27325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3623983A85
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 01:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11B381C2222C
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 23:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8B5D136338;
	Mon, 23 Sep 2024 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KI+dpgj2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D36E127B56;
	Mon, 23 Sep 2024 23:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727135712; cv=fail; b=ga1dk3Cn8yZlGqvkhl4He7WSP7nlRiTWiiJt/X0OjWVsXHWhd1aMQxbBRmXJ3oCyEkM69c8QOUJ3MDLWQf1wk89P6A9RhLkvGn+6Z9BY+TPE6j5p1FBlvKEvOuNVT7jW3Rj1QOuICYihAUimmQnZqujccOEPZ1HF+d6hS08vmk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727135712; c=relaxed/simple;
	bh=r0L5Vy6fujEc3NR+piutqD0pQIffR5rb6mvnW66ESOU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CxC7/bTPjqH5DDlwqxXhuoUFTk7x+TpXHOWLk1+kX5LclrszYKjcitkPjI8mNWRNVheXl3Op0zTUcUQZ+gApV2uyY3188IB/ZpljLJeMc/Qd6ES500lMaqmVllacs0+jhPubJDkAYeCfJ1tTaE7ntYa78c5UC9ltXABYorRw8OI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KI+dpgj2; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727135711; x=1758671711;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r0L5Vy6fujEc3NR+piutqD0pQIffR5rb6mvnW66ESOU=;
  b=KI+dpgj2Kj+st/bdh55a7+YRTXJNK+ZoWtOhpx3fiRtbch28JG5wStOt
   8trN9QMhKrLUNtFAtWItlfvchPSK7CQ8dMcyFQSIXUvqeG8NmLxueR6CI
   9iHnHchoi86iex4P36TalqPnMgQ3ACDbaIa8eUFOCOIbzwUydZWq5CwcJ
   NNrM4IzE7b2enpzov/WOyMlQiWbO9VX0JjdIkGU6W9fel7pwAVSp3Ootw
   VYm3+lQsY9PZ1yavahbBW3iZfrsus8lk0Pc198aTzCB5BC/9eW/JD3aDp
   Lxf1cwr37jtbPDLPk6DWGBNJBGBhnec0KtyZRjBS2qEiGpOf2FkUek4a+
   A==;
X-CSE-ConnectionGUID: m5n9jpRES6WJVzLoAcJbsg==
X-CSE-MsgGUID: IFNH1rF5S3KJbF+fF6x6Ng==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="48638753"
X-IronPort-AV: E=Sophos;i="6.10,252,1719903600"; 
   d="scan'208";a="48638753"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 16:55:10 -0700
X-CSE-ConnectionGUID: HgGC3Ff2Ts+7OXlg5/C1/g==
X-CSE-MsgGUID: v0J8Tpz6TMucgzEdWAvEWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,252,1719903600"; 
   d="scan'208";a="70825737"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Sep 2024 16:55:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 16:55:09 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 16:55:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 23 Sep 2024 16:55:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 16:55:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ui+DDc1xpR2XSn5AwJoQAOHdvFHx8Ltl6imZ9Qy0YLDQ89uLeGsME6SXzsuZDWQ4BdiTSI/jzqpdSmTVnTyivHDjF73PGsYxLnzLxcVDGl1yT5ENQxZF+rnG+cLlZyBpxPBbeltgPgneeDoSZ5/wJRfpnDSSS5uRrKgJW66kFRLabzwNOclmmIWzo3tbgK/ko+AuuWR5T6lFIBaIZId0sJ6/qpU9k9E2aeYC0haG+W7KfshsStbnk7jjYpJaqpgdX1ToZ6T0UN6js6KsnSZO0otLVOoRdUEAosoG0KEfm/k4XpzikuAcwnDHIWoXhUtFO3bjap9VxEy6c00eSvADTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r0L5Vy6fujEc3NR+piutqD0pQIffR5rb6mvnW66ESOU=;
 b=q1V3FiMzwj8hyH7bZDqMlKJGItwQHaZck/oJJERhorwqPqbtFmc9NBQfXS5hk2RCYCafAAZll016DW+Jfu2LIU7tJyYDB2GCfappWIempC5s/XO1XXJ56YjIsa1unw+084ojpl8fANacpzbSGZZvSnytY5NB4nyI7Sy6wqvV6G/lWmRSNCOUM9PKC9/SzH0ufD6SrTrM/HBoQFlO2jHUKK4zXvLruzzECYmuYR86AtyQXekso6gIl+9Ft2YFUrYkIkyA1wPSi/+21ltdxUsc88M4PQfFPwpyCnLbMl+x5MXNmvmxG13gDmVL8NR+qzWyFkTr6z8JajApvPAxPoipeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CYXPR11MB8732.namprd11.prod.outlook.com (2603:10b6:930:d6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 23:55:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 23:55:05 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>, "kvm
 list" <kvm@vger.kernel.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Suravee
 Suthikulpanit" <suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"pratikrajesh.sampat@amd.com" <pratikrajesh.sampat@amd.com>,
	"michael.day@amd.com" <michael.day@amd.com>, "david.kaplan@amd.com"
	<david.kaplan@amd.com>, "dhaval.giani@amd.com" <dhaval.giani@amd.com>,
	Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bJZe9sAgAfcbgCAA67AEIAAE16AgAAbiYCAANS4gIAAMdaw
Date: Mon, 23 Sep 2024 23:55:04 +0000
Message-ID: <BN9PR11MB5276A329514CE2EC1C852C6D8C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com> <ZudMoBkGCi/dTKVo@nvidia.com>
 <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
 <BN9PR11MB527608E3B8B354502F22DFCA8C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CAGtprH-bj_+1k-jwEVS9PcAmCOvo72Vec3VVKvL1te7T8R1ooQ@mail.gmail.com>
 <BL1PR11MB5271327169B23A60D66965F38C6F2@BL1PR11MB5271.namprd11.prod.outlook.com>
 <CAGtprH-bcZDwndi6E7-qZPO6Qz57g-sanjmvM-Af8hjUN6SowQ@mail.gmail.com>
In-Reply-To: <CAGtprH-bcZDwndi6E7-qZPO6Qz57g-sanjmvM-Af8hjUN6SowQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CYXPR11MB8732:EE_
x-ms-office365-filtering-correlation-id: e4be5416-e8df-4255-b8b3-08dcdc2b2571
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZUtHV2J1Mm40VVhhK3NMTWJ5SFlGYmY4cVpzbFFiR3EvZ0xZczUxOGwwQXhC?=
 =?utf-8?B?c29pdTdJbjNFR0R2R25lSnRVcmw4NzNJcmcrYk94MkNoMWVrRmpsajkvN0Rr?=
 =?utf-8?B?RjY3UXFTZDhVajhmdnkyTFpvcURqU1pWaUJTOW8xKzROT0szVGZhNjRiY3hF?=
 =?utf-8?B?OWhiQUFLWFZKR2xGRTB6TUljR1FUbk5XTlYvNmJ1U2hLYlN4NVEzVHVVYVVi?=
 =?utf-8?B?aDkxZWEwcFhtRUhTenNyM1JBSTduRDViVnZ0L0wydDRoL2YxZnlIWVE4a2tE?=
 =?utf-8?B?aDZ5d3dSU05qK2xtWXY5NVJKTHlGQjVJSm10alVkUUw4QnpSeG9qSUx2ODU5?=
 =?utf-8?B?U3JYcWZaZVNZT3RyN1hpRnhmSXovRzBCQ29FTlJraFhTNEt4RzVUUlpHdmR6?=
 =?utf-8?B?NVI2QmNHN2Q1ZXZkQWh5OWVINWU1b1pUb1UzTHR5Rmx3RTJPUU9NeDB1eWJL?=
 =?utf-8?B?Z1ZqdDFKeWZuNEt5ZEVlb3BWZW03K3BueHo1M0FpT0VPY0oyQjZCd2Q2ZDhT?=
 =?utf-8?B?VG02T2w1Y0lnNVV2VWkxQzl4ZDI4d3lOZHdCaFZlVXZYQi9pYUpCSnlKT0sx?=
 =?utf-8?B?Y1pSOWhseGRNTE45aFJJTFZiK3FNZVNNNVRtK3FpazZXeXNDYlpaV013UXI5?=
 =?utf-8?B?eGFpNUREN3YrWWMwK3VBancrNWZhTDVxZ0RLREpuanMyNXFKbXE3eWFucnVI?=
 =?utf-8?B?M25RWEUzYXk2L3JSYjVpRkJkMVpkUS9LdjhxTXQwU2JHbC95eGZYVE90RVc5?=
 =?utf-8?B?eVZTMWZFaVo3MkQwRERqenlZcmo4bjRGVmlJMVRvOWZxN2NiS3N0QWExWEo1?=
 =?utf-8?B?UFVXUzVLS1U3NHNjWUFHb3lRTjk0SjdWa0tTV0U2QTBsVWhvUUw1SnNLeTBN?=
 =?utf-8?B?cENPZ05zRnJkQ2pBa0xiRnZlNDZpRVRCcGU4c3Q0MFgySVJWc25MdTBNZzgy?=
 =?utf-8?B?RGFsSWExQnJVZUxQWmFnOWhRRXplWTFjdG9RNys2dUxOOU8zdkZsd0JJWkpt?=
 =?utf-8?B?VTJKMGkxK2JNd1JPY21ZWndwMEMzNTQ4amNIM1AvdWgzK05HTkFzYy9hWSs5?=
 =?utf-8?B?d3ZnSmZoZjR6OHFzdDhXc1BaeFdpS0JrdCtpbGhwQVVIcTE5OWRiZ3dBMkRO?=
 =?utf-8?B?cUNFNHZkUVQ0TEVFc2JmN05JWmJSdHJRWW9vT3NnMEdlZDgwWTg3aml6MXgr?=
 =?utf-8?B?ZlZFbVRqT1NHaVVoYjljYkZQaU90QjN2bzByUHFiNnhLQWNVNDM2VG9TMG1I?=
 =?utf-8?B?REVQSWl3dm0xVWl2ZlVxbjJMRFRBdUY1RWJVZmx6c2lTbmlPMUx5T2JpMzlm?=
 =?utf-8?B?RWx0ZlhNNjZZOGV0eHhVUmVNdElDMG00VEZBbG1zYk8xV2xIREdhUzh6bHla?=
 =?utf-8?B?VTBsYU9ETjBHZE50bDhVWENQRkRPZHJsZHZVYzhkSzF5R2NnbE82d2c4Z2dP?=
 =?utf-8?B?N2JNQXBVV3JCVVRHc2pjenl4emtqTXFURmZIelFlQ2tEMFdYU2ZEWXpKY3E3?=
 =?utf-8?B?VmdBc2hCTU5HaUEzQ1hIZkQ4Q0pIMjMrRHhIOUtRaC95cHZSeG9EVllENXhS?=
 =?utf-8?B?OVdlTUJtU0x6U1RQUWJ4Ny9wSm1zek9kaFVwdmRWSklzM0ZEZkwyNGFqRE1I?=
 =?utf-8?B?bEJ2VC9IbWdCMU5vV1BWNXpLMUpUYm42emMwT0RXQ29MMzFTN2hzeEg1Sjc2?=
 =?utf-8?B?bkhPWTRRS1B3dFU1OWJ5Vjd5TklPaUgweXBQbUxzYkhKYzdGN3M5Q0pXSmx4?=
 =?utf-8?Q?1MN5cp/ouzkIpDrIEw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eEZNeVl2VWY2U1o4QkV2b1ZPaUhUeDhaZEtFbDdOcjBVOGdZUmtFSElEZkRw?=
 =?utf-8?B?SE5iV05COWZ6K3BSWWlPQWpZS25lZ0dqRnlpL2pvSzlFaWs1SGN0QW1hR2Fp?=
 =?utf-8?B?OThLRDg2YVJjYjB6eTM4d0JUZ1huZTBjc3pTVkkzZlhXY2RtQ1daOW5WQU9O?=
 =?utf-8?B?bS9OL0F4NFBQSHp6RzNoSzNuV2N4eFdxOHJna080SWZOU29CZHlaMG9zZjVI?=
 =?utf-8?B?WEM2S05TNVJNay9xVEZhNW9VcmdkN3lDcGJNUlV4TGlGdmlVV0dUaWJCMmoy?=
 =?utf-8?B?MG54STdGQWZJZ1lrK1hHMnZFWWFQS3N2c280cHE1T0Q0ekRYQWkyS0FPMStT?=
 =?utf-8?B?dkJ0cVgvOXAyNS9rWkNreCtCVUZaMEc3SHk3L3VqU1MwamFiZ1pYeHNKeUpT?=
 =?utf-8?B?ZW5MQmdxcVdyazNYUlk3RVNESkdjRHY4YVdsTVJMZWJTTUVkWHNxRmVuYUps?=
 =?utf-8?B?WmhnQ3d4bGlFK2ZrNVE1UVBXdkVRU3VaOCs0bXJ4M0VLVmk0S2RxbzU2cW5G?=
 =?utf-8?B?VDA0QlArSzMyeXVQdFhSSXpwYk1MRjkyQU0vL0kwLzlWOWlzRlNFR3paTVBL?=
 =?utf-8?B?UUd5WWJBZTFteVEwK1k3U2ZKbjZNam9ZcS9hWUd6N0V3Y1UzaHJJdWh1dHpD?=
 =?utf-8?B?bDRrczJWekxpcHZNNFVhR2tha2oxVXE4Vm9HUzMyKzZWUFJPaHFFcXRkOTZ5?=
 =?utf-8?B?ZENCeExLd3llY2UvK3ZZdC82aFFDK3VoRmlMMW13azk0SmdnOU1LT1VSNFJZ?=
 =?utf-8?B?cysvY2pxQkl0a1NPRG1EV0dnS2NUaFMvUTNGOVVjQVJZaEZQQzlUZ2tiQWxW?=
 =?utf-8?B?cERTcmgvN3BNZUZvRjBVQ2UxVTZLL0ZjSnZweXAzYWRwWnpPWm9ZRksyblc2?=
 =?utf-8?B?c1JHTDhNbTk2WXRYS1RlUSsrNmZvbE1KOVdidGRDWlBScnlnSTdQL1Y1RUJT?=
 =?utf-8?B?NjBldjF5OGFVNG94MEhyM1dhVml2V1NpbldqWEZ4ZnZhS2ZTenBzeDg1U213?=
 =?utf-8?B?MFdSQWI3TWZaaU9RNDhPK05jWXhNMmw0TmRNUHc0czl4UHpQSzJmc2paOWRO?=
 =?utf-8?B?RUhvclA4Nm0xMGxZV3FtazFzYTNKcE1FbFd0MVgxUkdKMWVKNkNZM1pGSUxD?=
 =?utf-8?B?TXVOMjBsdWFWVkdXR1ZCNTRjeEliU0dncmNiZmxTaHR4dFpkd1B3dDhNYlgx?=
 =?utf-8?B?MFNrdllaeTlrbzlSakFNTThlYksxYllkdDgzK0ExOTUrb01rL0E5M0JCSWNJ?=
 =?utf-8?B?c1NoVGhMUy9KTWNGTzZ1YTBPTDBrMVlvSUhLUXpaV1hpbTJYM2dqK21tblJR?=
 =?utf-8?B?WVl3ZGVVdGVSVTI0dzVzL0dnd25qd09XZ0drQWJ4d0xmRjNPZmxvUkhwekc5?=
 =?utf-8?B?ckc2M2gvcVM3NTFDUnNaZEMvTHBsaVVMdlhEYnh4QnIwSkRqWEVTNGw5SzNE?=
 =?utf-8?B?TjcrbDVtNHhSOHhUbDJjRjFQUXVXS1o0N1U5QkNXb0FScDdFSkxqTFVqVmIy?=
 =?utf-8?B?Qjl2cXRiRDUzQzJWWkRVWFIrTXpPaURkMDlVSGZYRFovdk5YU0RJY3ZQaHFD?=
 =?utf-8?B?VlhidGdoQ204YklCcWwvL0tGNEJ3MTFEbFVSb21VemxCQ0lpNUE1L1I1SG9w?=
 =?utf-8?B?Z1Izb2hGVG1xWEtvYnNXeVdWbXNFaFZ0eTVMSDk1UWVRM3Y5ZmRjSHg1c1hs?=
 =?utf-8?B?alduRDBoMkhBeUxPQkFubXNkTHdzRTg5R3V3UDFiWkxRbTlScHhKL3VGYm5z?=
 =?utf-8?B?Rmh1dGhkMjFUNHJ0b29Gd3NNTWVaSmtyczNqeEpYTVpOWStzV3VuT1RrYUpK?=
 =?utf-8?B?KzlFRURaMGNNWXlhSDBndlRxZ21iTm9KbmtPZzY1eVduL0loTXpMREREbzU2?=
 =?utf-8?B?TUpGUUJEOGhKVTk1dFYweEF5ank4Z2ZxZ1N3SXRkaUZsTWt5a28xellVdEQ3?=
 =?utf-8?B?ZlhWQWI3Q0pCS0MwNzlqUEtmQ3lxa01DMndyN3MwdnNjVEJTUGU4UzhjYjZN?=
 =?utf-8?B?WVdHVDQ4ZlA0UnZpcGlFUzh1Vk1SQjl2d2lyRWNIeTB1aWpRYURYM1pBUnBN?=
 =?utf-8?B?U0VST21KMlZGMmhzN1FLdDV2R21PSmFVUkpXK3lYMnA4T20zdy9CaG1sSkhO?=
 =?utf-8?Q?MF8Te2vPsSSDLgzVSr7RCIpwF?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e4be5416-e8df-4255-b8b3-08dcdc2b2571
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 23:55:04.9065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7ZtdbsfV+yhI1C81wfe2Hz9jVLA4b7RU78gU+JQc6P2TTAZtA9qMJwFHGC/aMiGay4hYc3tPNC691YBer0begQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8732
X-OriginatorOrg: intel.com

PiBGcm9tOiBWaXNoYWwgQW5uYXB1cnZlIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIFNlcHRlbWJlciAyNCwgMjAyNCA0OjU0IEFNDQo+IA0KPiBPbiBNb24sIFNlcCAy
MywgMjAyNCwgMTA6MjTigK9BTSBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+IHdy
b3RlOg0KPiA+DQo+ID4gPiBGcm9tOiBWaXNoYWwgQW5uYXB1cnZlIDx2YW5uYXB1cnZlQGdvb2ds
ZS5jb20+DQo+ID4gPiBTZW50OiBNb25kYXksIFNlcHRlbWJlciAyMywgMjAyNCAyOjM0IFBNDQo+
ID4gPg0KPiA+ID4gT24gTW9uLCBTZXAgMjMsIDIwMjQgYXQgNzozNuKAr0FNIFRpYW4sIEtldmlu
IDxrZXZpbi50aWFuQGludGVsLmNvbT4NCj4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+ID4gRnJv
bTogVmlzaGFsIEFubmFwdXJ2ZSA8dmFubmFwdXJ2ZUBnb29nbGUuY29tPg0KPiA+ID4gPiA+IFNl
bnQ6IFNhdHVyZGF5LCBTZXB0ZW1iZXIgMjEsIDIwMjQgNToxMSBBTQ0KPiA+ID4gPiA+DQo+ID4g
PiA+ID4gT24gU3VuLCBTZXAgMTUsIDIwMjQgYXQgMTE6MDjigK9QTSBKYXNvbiBHdW50aG9ycGUg
PGpnZ0BudmlkaWEuY29tPg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4g
T24gRnJpLCBBdWcgMjMsIDIwMjQgYXQgMTE6MjE6MjZQTSArMTAwMCwgQWxleGV5IEthcmRhc2hl
dnNraXkNCj4gd3JvdGU6DQo+ID4gPiA+ID4gPiA+IElPTU1VRkQgY2FsbHMgZ2V0X3VzZXJfcGFn
ZXMoKSBmb3IgZXZlcnkgbWFwcGluZyB3aGljaCB3aWxsDQo+ID4gPiBhbGxvY2F0ZQ0KPiA+ID4g
PiA+ID4gPiBzaGFyZWQgbWVtb3J5IGluc3RlYWQgb2YgdXNpbmcgcHJpdmF0ZSBtZW1vcnkgbWFu
YWdlZCBieSB0aGUNCj4gPiA+IEtWTQ0KPiA+ID4gPiA+IGFuZA0KPiA+ID4gPiA+ID4gPiBNRU1G
RC4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBQbGVhc2UgY2hlY2sgdGhpcyBzZXJpZXMsIGl0
IGlzIG11Y2ggbW9yZSBob3cgSSB3b3VsZCBleHBlY3QgdGhpcyB0bw0KPiA+ID4gPiA+ID4gd29y
ay4gVXNlIHRoZSBndWVzdCBtZW1mZCBkaXJlY3RseSBhbmQgZm9yZ2V0IGFib3V0IGt2bSBpbiB0
aGUNCj4gPiA+IGlvbW11ZmQNCj4gPiA+ID4gPiBjb2RlOg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4g
PiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMTcyNjMxOTE1OC0yODMwNzQtMS1naXQtc2Vu
ZC1lbWFpbC0NCj4gPiA+ID4gPiBzdGV2ZW4uc2lzdGFyZUBvcmFjbGUuY29tDQo+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gSSB3b3VsZCBpbWFnaW5lIHlvdSdkIGRldGVjdCB0aGUgZ3Vlc3QgbWVt
ZmQgd2hlbiBhY2NlcHRpbmcgdGhlDQo+IEZEDQo+ID4gPiBhbmQNCj4gPiA+ID4gPiA+IHRoZW4g
aGF2aW5nIHNvbWUgZGlmZmVyZW50IHBhdGggaW4gdGhlIHBpbm5pbmcgbG9naWMgdG8gcGluIGFu
ZCBnZXQNCj4gPiA+ID4gPiA+IHRoZSBwaHlzaWNhbCByYW5nZXMgb3V0Lg0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gQWNjb3JkaW5nIHRvIHRoZSBkaXNjdXNzaW9uIGF0IEtWTSBtaWNyb2NvbmZlcmVu
Y2UgYXJvdW5kDQo+IGh1Z2VwYWdlDQo+ID4gPiA+ID4gc3VwcG9ydCBmb3IgZ3Vlc3RfbWVtZmQg
WzFdLCBpdCdzIGltcGVyYXRpdmUgdGhhdCBndWVzdCBwcml2YXRlDQo+IG1lbW9yeQ0KPiA+ID4g
PiA+IGlzIG5vdCBsb25nIHRlcm0gcGlubmVkLiBJZGVhbCB3YXkgdG8gaW1wbGVtZW50IHRoaXMg
aW50ZWdyYXRpb24NCj4gd291bGQNCj4gPiA+ID4gPiBiZSB0byBzdXBwb3J0IGEgbm90aWZpZXIg
dGhhdCBjYW4gYmUgaW52b2tlZCBieSBndWVzdF9tZW1mZCB3aGVuDQo+ID4gPiA+ID4gbWVtb3J5
IHJhbmdlcyBnZXQgdHJ1bmNhdGVkIHNvIHRoYXQgSU9NTVUgY2FuIHVubWFwIHRoZQ0KPiA+ID4g
Y29ycmVzcG9uZGluZw0KPiA+ID4gPiA+IHJhbmdlcy4gU3VjaCBhIG5vdGlmaWVyIHNob3VsZCBh
bHNvIGdldCBjYWxsZWQgZHVyaW5nIG1lbW9yeQ0KPiA+ID4gPiA+IGNvbnZlcnNpb24sIGl0IHdv
dWxkIGJlIGludGVyZXN0aW5nIHRvIGRpc2N1c3MgaG93IGNvbnZlcnNpb24gZmxvdw0KPiA+ID4g
PiA+IHdvdWxkIHdvcmsgaW4gdGhpcyBjYXNlLg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gWzFdIGh0
dHBzOi8vbHBjLmV2ZW50cy9ldmVudC8xOC9jb250cmlidXRpb25zLzE3NjQvIChjaGVja291dCB0
aGUNCj4gPiA+ID4gPiBzbGlkZSAxMiBmcm9tIGF0dGFjaGVkIHByZXNlbnRhdGlvbikNCj4gPiA+
ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBNb3N0IGRldmljZXMgZG9uJ3Qgc3VwcG9ydCBJL08gcGFn
ZSBmYXVsdCBoZW5jZSBjYW4gb25seSBETUEgdG8gbG9uZw0KPiA+ID4gPiB0ZXJtIHBpbm5lZCBi
dWZmZXJzLiBUaGUgbm90aWZpZXIgbWlnaHQgYmUgaGVscGZ1bCBmb3IgaW4ta2VybmVsDQo+IGNv
bnZlcnNpb24NCj4gPiA+ID4gYnV0IGFzIGEgYmFzaWMgcmVxdWlyZW1lbnQgdGhlcmUgbmVlZHMg
YSB3YXkgZm9yIElPTU1VRkQgdG8gY2FsbCBpbnRvDQo+ID4gPiA+IGd1ZXN0IG1lbWZkIHRvIHJl
cXVlc3QgbG9uZyB0ZXJtIHBpbm5pbmcgZm9yIGEgZ2l2ZW4gcmFuZ2UuIFRoYXQgaXMNCj4gPiA+
ID4gaG93IEkgaW50ZXJwcmV0ZWQgImRpZmZlcmVudCBwYXRoIiBpbiBKYXNvbidzIGNvbW1lbnQu
DQo+ID4gPg0KPiA+ID4gUG9saWN5IHRoYXQgaXMgYmVpbmcgYWltZWQgaGVyZToNCj4gPiA+IDEp
IGd1ZXN0X21lbWZkIHdpbGwgcGluIHRoZSBwYWdlcyBiYWNraW5nIGd1ZXN0IG1lbW9yeSBmb3Ig
YWxsIHVzZXJzLg0KPiA+ID4gMikga3ZtX2dtZW1fZ2V0X3BmbiB1c2VycyB3aWxsIGdldCBhIGxv
Y2tlZCBmb2xpbyB3aXRoIGVsZXZhdGVkDQo+ID4gPiByZWZjb3VudCB3aGVuIGFza2luZyBmb3Ig
dGhlIHBmbi9wYWdlIGZyb20gZ3Vlc3RfbWVtZmQuIFVzZXJzIHdpbGwNCj4gPiA+IGRyb3AgdGhl
IHJlZmNvdW50IGFuZCByZWxlYXNlIHRoZSBmb2xpbyBsb2NrIHdoZW4gdGhleSBhcmUgZG9uZQ0K
PiA+ID4gdXNpbmcvaW5zdGFsbGluZyAoZS5nLiBpbiBLVk0gRVBUL0lPTU1VIFBUIGVudHJpZXMp
IGl0LiBUaGlzIGZvbGlvDQo+ID4gPiBsb2NrIGlzIHN1cHBvc2VkIHRvIGJlIGhlbGQgZm9yIHNo
b3J0IGR1cmF0aW9ucy4NCj4gPiA+IDMpIFVzZXJzIGNhbiBhc3N1bWUgdGhlIHBmbiBpcyBhcm91
bmQgdW50aWwgdGhleSBhcmUgbm90aWZpZWQgYnkNCj4gPiA+IGd1ZXN0X21lbWZkIG9uIHRydW5j
YXRpb24gb3IgbWVtb3J5IGNvbnZlcnNpb24uDQo+ID4gPg0KPiA+ID4gU3RlcCAzIGFib3ZlIGlz
IGFscmVhZHkgZm9sbG93ZWQgYnkgS1ZNIEVQVCBzZXR1cCBsb2dpYyBmb3IgQ29DbyBWTXMuDQo+
ID4gPiBURFggVk1zIGVzcGVjaWFsbHkgbmVlZCB0byBoYXZlIHNlY3VyZSBFUFQgZW50cmllcyBh
bHdheXMgbWFwcGVkDQo+IChvbmNlDQo+ID4gPiBmYXVsdGVkLWluKSB3aGlsZSB0aGUgZ3Vlc3Qg
bWVtb3J5IHJhbmdlcyBhcmUgcHJpdmF0ZS4NCj4gPg0KPiA+ICdmYXVsdGVkLWluJyBkb2Vzbid0
IHdvcmsgZm9yIGRldmljZSBETUFzICh3L28gSU9QRikuDQo+IA0KPiBmYXVsdGVkLWluIGNhbiBi
ZSByZXBsYWNlZCB3aXRoIG1hcHBlZC1pbiBmb3IgdGhlIGNvbnRleHQgb2YgSU9NTVUNCj4gb3Bl
cmF0aW9ucy4NCj4gDQo+ID4NCj4gPiBhbmQgYWJvdmUgaXMgYmFzZWQgb24gdGhlIGFzc3VtcHRp
b24gdGhhdCBDb0NvIFZNIHdpbGwgYWx3YXlzDQo+ID4gbWFwL3BpbiB0aGUgcHJpdmF0ZSBtZW1v
cnkgcGFnZXMgdW50aWwgYSBjb252ZXJzaW9uIGhhcHBlbnMuDQo+IA0KPiBIb3N0IHBoeXNpY2Fs
IG1lbW9yeSBpcyBwaW5uZWQgYnkgdGhlIGhvc3Qgc29mdHdhcmUgc3RhY2suIElmIHlvdSBhcmUN
Cj4gdGFsa2luZyBhYm91dCBhcmNoIHNwZWNpZmljIGxvZ2ljIGluIEtWTSwgdGhlbiB0aGUgZXhw
ZWN0YXRpb24gYWdhaW4NCj4gaXMgdGhhdCBndWVzdF9tZW1mZCB3aWxsIGdpdmUgcGlubmVkIG1l
bW9yeSB0byBpdCdzIHVzZXJzLg0KDQpzb3JyeSBpdCdzIGEgdHlwby4gSSBtZWFudCB0aGUgaG9z
dCBkb2VzIGl0IGZvciBDb0NvIFZNLg0KDQo+IA0KPiA+DQo+ID4gQ29udmVyc2lvbiBpcyBpbml0
aWF0ZWQgYnkgdGhlIGd1ZXN0IHNvIGlkZWFsbHkgdGhlIGd1ZXN0IGlzIHJlc3BvbnNpYmxlDQo+
ID4gZm9yIG5vdCBsZWF2aW5nIGFueSBpbi1mbHkgRE1BcyB0byB0aGUgcGFnZSB3aGljaCBpcyBi
ZWluZyBjb252ZXJ0ZWQuDQo+ID4gRnJvbSB0aGlzIGFuZ2xlIGl0IGlzIGZpbmUgZm9yIElPTU1V
RkQgdG8gcmVjZWl2ZSBhIG5vdGlmaWNhdGlvbiBmcm9tDQo+ID4gZ3Vlc3QgbWVtZmQgd2hlbiBz
dWNoIGEgY29udmVyc2lvbiBoYXBwZW5zLg0KPiA+DQo+ID4gQnV0IEknbSBub3Qgc3VyZSB3aGV0
aGVyIHRoZSBURFggd2F5IGlzIGFyY2hpdGVjdHVyYWwgb3IganVzdCBhbg0KPiA+IGltcGxlbWVu
dGF0aW9uIGNob2ljZSB3aGljaCBjb3VsZCBiZSBjaGFuZ2VkIGxhdGVyLCBvciB3aGV0aGVyIGl0
DQo+ID4gYXBwbGllcyB0byBvdGhlciBhcmNoLg0KPiANCj4gQWxsIHByaXZhdGUgbWVtb3J5IGFj
Y2Vzc2VzIGZyb20gVERYIFZNcyBnbyB2aWEgU2VjdXJlIEVQVC4gSWYgaG9zdA0KPiByZW1vdmVz
IHNlY3VyZSBFUFQgZW50cmllcyB3aXRob3V0IGd1ZXN0IGludGVydmVudGlvbiB0aGVuIGxpbnV4
IGd1ZXN0DQo+IGhhcyBhIGxvZ2ljIHRvIGdlbmVyYXRlIGEgcGFuaWMgd2hlbiBpdCBlbmNvdW50
ZXJzIEVQVCB2aW9sYXRpb24gb24NCj4gcHJpdmF0ZSBtZW1vcnkgYWNjZXNzZXMgWzFdLg0KDQpZ
ZWFoLCB0aGF0IHNvdW5kcyBnb29kLg0KDQo+IA0KPiA+DQo+ID4gSWYgdGhhdCBiZWhhdmlvciBj
YW5ub3QgYmUgZ3VhcmFudGVlZCwgdGhlbiB3ZSBtYXkgc3RpbGwgbmVlZCBhIHdheQ0KPiA+IGZv
ciBJT01NVUZEIHRvIHJlcXVlc3QgbG9uZyB0ZXJtIHBpbi4NCj4gDQo+IFsxXQ0KPiBodHRwczov
L2VsaXhpci5ib290bGluLmNvbS9saW51eC92Ni4xMS9zb3VyY2UvYXJjaC94ODYvY29jby90ZHgv
dGR4LmMjTDY3Nw0KDQo=

