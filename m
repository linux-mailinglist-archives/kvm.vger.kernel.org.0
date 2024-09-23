Return-Path: <kvm+bounces-27294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3E797E779
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 10:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4557D1C2117F
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 08:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 846E919343B;
	Mon, 23 Sep 2024 08:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MDUp7AQu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40D7101E6;
	Mon, 23 Sep 2024 08:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727079886; cv=fail; b=YW97YpcOzQU9AGlAy2puu08vcTt4mB3su7RycFuQIOIUp67bwidn9YOwKwhvJOjSLBmbXG6YjOaHl6D+Qxf+K+8sBj0fc5vkRQdJdG4iC2KMwhH7SkBnZIaJBC5SWTlm4wPQ5F8R4vVTz2pnWgO8XdbxD0QD4M+IYHNnPQi30EI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727079886; c=relaxed/simple;
	bh=3yH12/9YtxOcJHcJPHBUSkRQXMghjVYBoLDwE83cIgM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I7Chn7V8VMAbmFg/LE+FqJxJncDwRLByFIpQKTY+x5RjkoX3ooCI36kN9qKtbFHiC+pX/sOiTHOD4tmN28asi+mBSIChanZP3zqu57aTIc61YI7CHwtyB2SB1l8L5Tb2fu8st+gdDHY46GHsBz9VZ5NX+aIH19eweds7Tp/JJj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MDUp7AQu; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727079885; x=1758615885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3yH12/9YtxOcJHcJPHBUSkRQXMghjVYBoLDwE83cIgM=;
  b=MDUp7AQuQjcHTfqdeb5QCmd6AnNU+oRyAf2uFHsU3qlvanJDLG+QTubr
   81xalezEsUggK2xX8HleLiA/1GR/vmUA9vjbs6lUmY4iwwb/rzd/d4Yer
   CwwSIR6APmUksu6FTwVdAIjZqSWc2KBG4kM6a7NpUQLBMhTz3PTat6v4H
   P6X39xqRaJ5GLwfQbvLitSV87OmoG+bvnHk14yuTjUhNBN3DPzbYGK8Ti
   fQ1yT14dbBxCNhqrywNjt8iTF3qNsmZKmxsWwvtpS6DOWfND4qVEq9fL2
   xXKAP3epKToODjGtjiZ0We2uc+iReDxCQs2mfbC19ThbkfvD8FAiCEDzF
   Q==;
X-CSE-ConnectionGUID: 85lprgUuSyW+rIUmDRQ0wA==
X-CSE-MsgGUID: VxkjmQ5YRWOfQ4ljPeEb0w==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="26107913"
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="26107913"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 01:24:44 -0700
X-CSE-ConnectionGUID: 4EV+CJJtSuqgW47eQMfrSQ==
X-CSE-MsgGUID: el3g8sUyQFe90JNq+nVszw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="71016175"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Sep 2024 01:24:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 23 Sep 2024 01:24:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 23 Sep 2024 01:24:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 23 Sep 2024 01:24:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hg7CT9uiavSJfgn3tHZXqY4dwBg3rLALjwyWIbuXXQID+jIMPfYpxyj6rGYUhGFtmmoSqAASoHZdkTytwFjxuuzSwdrl+bfg8Mtphd4fZ56Yaxx6iQ2gbcdDJOdMMBFgaYkY+1wrxWGiYYABDWLAH2q9LYdGpbMHQnwpaJtAdmDcrRjHng5ek5zlOV558f2OsXyOdbR2miXG35XWfiQZGCPkaCVZ08RKA9xeY0spLqVIT1T3ZmBAcWBrUrxgmMtYSJaIUphizDwksqAREMuPwBX9uCGGhj6rmmNGj8SS9bIIIj+xgEz0olmW3tAJgf6zQhF0A6S31+7MIRZsTcYk4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yH12/9YtxOcJHcJPHBUSkRQXMghjVYBoLDwE83cIgM=;
 b=bjDBn9JC9+aOXFNNW5Ps0NLE0+EYjoWO+weznSKNbSV+XhK0hXAyBk/gehBPo/XF1SzfMplVD24DpToF/dOxAjQw8PHjPOwTrtEq6jFDqfXUf8syunOQGttmcCMWfg0Im3nO3r7lqRm109FCwN2imTKgD2emIG6W1FueNGrFPXhUTtDwxRX5dC9s35oRhPfSs6s+cg+Ev4vsgRwW6BkivhxmtdGuiwHLgqrEW3SimdWiI89m1tMgrz1K7X6zzo76JbuNwxoP2IkKvwc7fDkkOuGl+kYxWac8oR/YjNA7mnNAv9Pu1BIvJO5Q/7x0DPu9gk/BgvmNCwhcbx9AZuMYIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by PH8PR11MB6779.namprd11.prod.outlook.com (2603:10b6:510:1ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Mon, 23 Sep
 2024 08:24:40 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::5616:a124:479a:5f2a%2]) with mapi id 15.20.7982.022; Mon, 23 Sep 2024
 08:24:40 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Annapurve, Vishal" <vannapurve@google.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, Alexey Kardashevskiy <aik@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
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
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bJZe9sAgAfcbgCAA67AEIAAE16AgAAbiYA=
Date: Mon, 23 Sep 2024 08:24:40 +0000
Message-ID: <BL1PR11MB5271327169B23A60D66965F38C6F2@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com> <ZudMoBkGCi/dTKVo@nvidia.com>
 <CAGtprH8C4MQwVTFPBMbFWyW4BrK8-mDqjJn-UUFbFhw4w23f3A@mail.gmail.com>
 <BN9PR11MB527608E3B8B354502F22DFCA8C6F2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CAGtprH-bj_+1k-jwEVS9PcAmCOvo72Vec3VVKvL1te7T8R1ooQ@mail.gmail.com>
In-Reply-To: <CAGtprH-bj_+1k-jwEVS9PcAmCOvo72Vec3VVKvL1te7T8R1ooQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|PH8PR11MB6779:EE_
x-ms-office365-filtering-correlation-id: 3f20398e-103f-4974-ad92-08dcdba92b4f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YTdxNGFrMkdSWE1UQ0RoWE94bnEvMysyYk5qMVc4UEFJWTFleExJdGVCUXpC?=
 =?utf-8?B?Nm0rUkxxR2tZWm5PUFRJbEVvWjV2YW9wNWNrZHZNMWtieVBxZVZoK00ybGhj?=
 =?utf-8?B?NzA0SlFVa3lzbGNEUXJGRUFNMVgvaEtoYmJ3aXJjQXN5U0pXTVBzWnJCbU92?=
 =?utf-8?B?UyszdUFZb0J0THllK1h5OGRXVXpoTHdVZnpTVmR4d1BuNmlVMDNNb3JiRlJY?=
 =?utf-8?B?T2VaWjFSRVByL3pJb3EzSk5zRlAzNDFPNks1bUJxbzJqcnJsSTduVUJmMnJO?=
 =?utf-8?B?bmNKK29pcTZCOUE5UnBqZGlVUEwzOWRlN0tYWmt0U3o3RU5FTmFPSU9qSjRT?=
 =?utf-8?B?dzR1emNtcHgrOXU1RFZacUU0YUpSVW1wS0ZRL0gxUExpMVZLUjhxRVVNZ1NN?=
 =?utf-8?B?b3VFaUxYZ2N4WUlPVDY2akhXWDYrbHNhY0ZwUENRTW5tU3dMbjdxUVg5czZQ?=
 =?utf-8?B?aER5YW4yTnpsN0tWaUZhTUJJNG1CVERmUHBycFBDSHA1dWdvWmRoampmSkpo?=
 =?utf-8?B?NUlDeXN2UCtqSTlxcDIxUlpLQzNlOWFGZEZSTHhQS2sxYzBqWGIrU3ZVRGp5?=
 =?utf-8?B?ZkxaVDNQMnIzdDE1UE13aStFelJtcnlaeUdjOUp4cnQ2Wmk0SVZUY2o1Yk5H?=
 =?utf-8?B?TTZST3hISzM0V1ZYT01zU2wrMlNjTnFFenRDZkRlazlhRmVJZjBGUmZzaTBi?=
 =?utf-8?B?aUdUQ2RLY1ZPUkFxVU4xbnNjYm8yS3JyVGd6aWxFbkUzbGV5MHdDQmlnV2Nk?=
 =?utf-8?B?S09ibkgva2FZcWdqY2FvZUVkZWhFMnV4cGZBTjhtS2d1blgzVnpnK3RHTVo3?=
 =?utf-8?B?anNCOEltcFo2VW5oSGViUEVFV2puejIxM1o3Q0E4cERDRjFPK1JvSWdob0t5?=
 =?utf-8?B?NlRtb0RSYnJtd0JJcXJEdGpPNjF3NlpEV3c2UlNSdVliU1k3MCtrRWJiTVhu?=
 =?utf-8?B?bVljTmdsK2E0TGhNNytFcGF1YnBXL1h1NmZxU1I3OE5Yc0hXclZ4UXBqY2xZ?=
 =?utf-8?B?d3gvYTMxY1BTdVNtaTdVb2Y2TWcrL2wrYlRvRk1nWGsvNytWKy9SNWgrUXh3?=
 =?utf-8?B?bHZKYWd3dlNKQWxQK0Jvb3ljZmJIR2pEbGtlc1FlZHVaRDJKSks1ZGI1Tnp3?=
 =?utf-8?B?Zjg5aE5RVnlQMGJrMUQ5WnVqVnVRNUJncVZDUExMUUxhSnJKVCthZVJ4VWh5?=
 =?utf-8?B?T0ZmVTRnRHk2MkkxbEpVanYzNFcrOFNxdW1aQ2kyL1M2ZmJWcFV6NFJPalcv?=
 =?utf-8?B?YjcxMXhIM1ZjZVFzSUt1TXl2ZzJIclY4VVJCT2NUdWlFUnhoMm9nTHpiL1Bx?=
 =?utf-8?B?MktzdUJUZzFEc0RUM0xrRUlGREdkTVlnRlY3ODJVdDgxV2pJYnZ5L1JnN3F3?=
 =?utf-8?B?VkNRUGF2MUIzMjhpaE5HbUFFeWZpeCsxd2s2UkNMQlhsMHQ3a1JyWnVBN1lI?=
 =?utf-8?B?MWVzQUduTklsV0RtdzZsc0tnT0xVVWFTQ1lienVMTFBrKzlhUmJLZS9QMVZ0?=
 =?utf-8?B?bDBwQ0JlazJHbXY5aHZYM05MOFg1ZHhuc2t0QllEYXlJZkUrZ1B2RThGUmpR?=
 =?utf-8?B?ZWRoZFE4anE4SW5sc09SYnF0YXRGZ2IvNW9uelVpeXZqVkVLb09FdjZ1MDdV?=
 =?utf-8?B?K2lIRDVjTE1FNmxPYzFEZ1BoeVh5TzV4VCthZjlVYktYa0xTZWpRdEFUbG9X?=
 =?utf-8?B?dHJhMVQ5c1plZXhLR08rM1Uwb1kxQzM2S09RR0UxU291VnFQN0NxNEs5OGN1?=
 =?utf-8?B?eS9JQVBzajNWOVlWZFpQZUxUZHFXbG1VUDB5bkcvQ3pQejVnV0NXZXZKMnhJ?=
 =?utf-8?Q?jAaIav+JOXiLBH3T8ItIfAvmYcM2HN1NN4gfw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VlRLQ3BRVUQ3aElHbUY1aFMxKzZjQS91b3laZGJudWYvN0ZSaDFJRWQxTUYw?=
 =?utf-8?B?VE50YXJSVGd6OFRVRmhqSlV6ZzBSQ2RpRDV5S0pENGFIYytwNGIvT1l3WXZk?=
 =?utf-8?B?MjNpNVFwQTBqQ2JIeEE2VCtZUTNmd0hQOTNyVjRtU1VVU29nMGtzMGw0aVAw?=
 =?utf-8?B?SkdjQUxiZis4R3J5NnJSWmZ2K3kycUNJaXJpOHgwMGptU2NxallXNWJDVEdR?=
 =?utf-8?B?NFV2MWRpR1lqYVNMenh5bDVzNHJXVElRdXhTN3Q0WFJNb3JHNXFQMDdCMWNG?=
 =?utf-8?B?OCt3NnFJMDdOVmdtblJJajVFcnhXSmw3N0Q0VE9vYTArUFBycXhzOXl5QzBm?=
 =?utf-8?B?NmVSSm9KQ0tlWkdLUTd5QU9YL2xMVmQwOEFGZG9QYmpSb3QvckpvVmNQTjdu?=
 =?utf-8?B?bjFHTXpWMitxTk1oWXRaa3JUSnFQaUhXQXhNWjE3WmhjcW8vVE92QURndXZK?=
 =?utf-8?B?QmxFNndHR2VuMkNCbkR2WkFmdkgvb0RnNjJaczE5U3JHRDNqYktHR1JqMFNP?=
 =?utf-8?B?OXMremlUekEycDMxSWpZL0ZrQndFOVFjS0htcC8wMFdiYlhJay94dDh5ekdC?=
 =?utf-8?B?N0ZUNmJKZklwRnlqS1cyTXNyWENTZ1c2N3NwTTBPUEdtZ2xUajlKZUl2NE9n?=
 =?utf-8?B?WFNVZ0Nub1VDYTZrYXFQb1lPK1VJeVB0dEZCdVI3TWYrdUQ1bnBqOEZDenly?=
 =?utf-8?B?ek5YejN3a09MKzJWZlZjMXErcldZSVliNktOdHN6dmpVSVppZUtaNTQ0bTA1?=
 =?utf-8?B?ZDgyZTJCZUpKME1jcWpXTnhGQ21EL3JtNzVkS0g3U1FCbVFaaUlua1RBcSt3?=
 =?utf-8?B?bjZTMkV2NzdmWU5KN0tzSGJMZTl0QUxkcXE3cHA5MGZvVjdtd1h3MEZKdnBJ?=
 =?utf-8?B?am1PU1MxcTVHQ2ZrZWNDU0VxQWtvT2RvL2MrV1lCUmZrODRCWE5iY3EycnND?=
 =?utf-8?B?eEJvWFM2RGpIUityWVd2NFMrOUE1d3c2eGxJSDJDWkJBUkNnS244ek9qMFNW?=
 =?utf-8?B?N0JNd1gyOXJHMGFHN0krbkg0TEV4TW1lblNHZlpUQ0tJYm44T2drOUg4Z3Fv?=
 =?utf-8?B?bHNkNzJnUVE5WnF6cWMvb3ppcUMzRE5BWEtVTjlyS1hQSUFkUml5blBORS8w?=
 =?utf-8?B?ZEdGaFpWOXE0MmcxUjU0aE9RS3lHd25sOFcrZHBUNExTMVRHNjVRMGE5Y3VB?=
 =?utf-8?B?UVE2SFdDNy8vYmdCNXY0VXlSRDlReTI3SXVJallrT21BbThZc2duUHVIUkND?=
 =?utf-8?B?OUdPYVNzNERHVnB1eURWTFdVcFdleHUrYnNqa2tmRW5TYkwwa01kUGpTYVUy?=
 =?utf-8?B?SFJiUnVzUnk2VWQ5TG5xYlUybWRmaTJpVisrNlFTQlcwRVpqYy9zczJ1MEhJ?=
 =?utf-8?B?cE12TW92bnZ6TDBKS2tyVVJ6MWhraDV4RHFqOENEOS82MFRGcHFkaTJzOTBs?=
 =?utf-8?B?VUpjanVhVy9jS0ZwZ24xVzl3TWpUYmk5WUFSc1JvU1dIenNoSS9Sd04zeGhJ?=
 =?utf-8?B?SVZUWm1QSzNVYWQ0Y2d3Qnp0UE90YTFvZW9ia0VSZEdyVk1mdjRqUWlVN29p?=
 =?utf-8?B?RzB3d2hMK1ZKcC93U0pjYVFwc2FyM0l6bzNEbFBmYTJuajMyOXVkeUxRcWVG?=
 =?utf-8?B?YjZ5R1dGT2xiVWNTRW1NNDdTbVFGZGxxVEVCMGRSS1FoVWRsNmdmbFNHZm9L?=
 =?utf-8?B?eXMxMnliUTNSNHI1VEgxWmJHVlZha0xkMlVoVWtFN05rQ1B3UEk2VDl1RzBr?=
 =?utf-8?B?ZThScWtPdEFUNkoxMnQrbnFrdzJESUVYNUw4azlUNTUrVkZZbTBRWElwcDdh?=
 =?utf-8?B?bW4rNGlvK05sMGVkNmNkWW1NbEk1K3hEcm84aExVdmlpWEJ0TTdwVXIxeGdm?=
 =?utf-8?B?K2RlcklJSTYvZWhrRFF2RGVJYUR6SG9BSUVZbjd3eVFEalFrbys5YmlqN3FM?=
 =?utf-8?B?NllHSGFLR1NiWjB4L29YaERkVjE4cVpMSGYzTWVLR0Q2aVE4L1VCb3ZKbk1u?=
 =?utf-8?B?K0E5N3FQMlp1bW5XZjMzOVJLY01JTWFTK3d1SVp0dDRPOWJxUkluejYwemNL?=
 =?utf-8?B?aS9pVWFEWFJHTDdzdGxLU1V3T29Md1BBeHVDTzBMQ1dNVVgvR3kzWEhTUXJ2?=
 =?utf-8?Q?QgXXcJnPKEQd0Kk/c1xxNp8pa?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f20398e-103f-4974-ad92-08dcdba92b4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2024 08:24:40.2313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GCzje19fr15orkEdWSwkPxntqbNbvO2yywIaDXy0SDR416j5jdFYz5hvbVFNtTmr8U30H+i2ZhdBoQreSPwkqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6779
X-OriginatorOrg: intel.com

PiBGcm9tOiBWaXNoYWwgQW5uYXB1cnZlIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+DQo+IFNlbnQ6
IE1vbmRheSwgU2VwdGVtYmVyIDIzLCAyMDI0IDI6MzQgUE0NCj4gDQo+IE9uIE1vbiwgU2VwIDIz
LCAyMDI0IGF0IDc6MzbigK9BTSBUaWFuLCBLZXZpbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+IHdy
b3RlOg0KPiA+DQo+ID4gPiBGcm9tOiBWaXNoYWwgQW5uYXB1cnZlIDx2YW5uYXB1cnZlQGdvb2ds
ZS5jb20+DQo+ID4gPiBTZW50OiBTYXR1cmRheSwgU2VwdGVtYmVyIDIxLCAyMDI0IDU6MTEgQU0N
Cj4gPiA+DQo+ID4gPiBPbiBTdW4sIFNlcCAxNSwgMjAyNCBhdCAxMTowOOKAr1BNIEphc29uIEd1
bnRob3JwZSA8amdnQG52aWRpYS5jb20+DQo+IHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4gPiBPbiBG
cmksIEF1ZyAyMywgMjAyNCBhdCAxMToyMToyNlBNICsxMDAwLCBBbGV4ZXkgS2FyZGFzaGV2c2tp
eSB3cm90ZToNCj4gPiA+ID4gPiBJT01NVUZEIGNhbGxzIGdldF91c2VyX3BhZ2VzKCkgZm9yIGV2
ZXJ5IG1hcHBpbmcgd2hpY2ggd2lsbA0KPiBhbGxvY2F0ZQ0KPiA+ID4gPiA+IHNoYXJlZCBtZW1v
cnkgaW5zdGVhZCBvZiB1c2luZyBwcml2YXRlIG1lbW9yeSBtYW5hZ2VkIGJ5IHRoZQ0KPiBLVk0N
Cj4gPiA+IGFuZA0KPiA+ID4gPiA+IE1FTUZELg0KPiA+ID4gPg0KPiA+ID4gPiBQbGVhc2UgY2hl
Y2sgdGhpcyBzZXJpZXMsIGl0IGlzIG11Y2ggbW9yZSBob3cgSSB3b3VsZCBleHBlY3QgdGhpcyB0
bw0KPiA+ID4gPiB3b3JrLiBVc2UgdGhlIGd1ZXN0IG1lbWZkIGRpcmVjdGx5IGFuZCBmb3JnZXQg
YWJvdXQga3ZtIGluIHRoZQ0KPiBpb21tdWZkDQo+ID4gPiBjb2RlOg0KPiA+ID4gPg0KPiA+ID4g
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzE3MjYzMTkxNTgtMjgzMDc0LTEtZ2l0LXNlbmQt
ZW1haWwtDQo+ID4gPiBzdGV2ZW4uc2lzdGFyZUBvcmFjbGUuY29tDQo+ID4gPiA+DQo+ID4gPiA+
IEkgd291bGQgaW1hZ2luZSB5b3UnZCBkZXRlY3QgdGhlIGd1ZXN0IG1lbWZkIHdoZW4gYWNjZXB0
aW5nIHRoZSBGRA0KPiBhbmQNCj4gPiA+ID4gdGhlbiBoYXZpbmcgc29tZSBkaWZmZXJlbnQgcGF0
aCBpbiB0aGUgcGlubmluZyBsb2dpYyB0byBwaW4gYW5kIGdldA0KPiA+ID4gPiB0aGUgcGh5c2lj
YWwgcmFuZ2VzIG91dC4NCj4gPiA+DQo+ID4gPiBBY2NvcmRpbmcgdG8gdGhlIGRpc2N1c3Npb24g
YXQgS1ZNIG1pY3JvY29uZmVyZW5jZSBhcm91bmQgaHVnZXBhZ2UNCj4gPiA+IHN1cHBvcnQgZm9y
IGd1ZXN0X21lbWZkIFsxXSwgaXQncyBpbXBlcmF0aXZlIHRoYXQgZ3Vlc3QgcHJpdmF0ZSBtZW1v
cnkNCj4gPiA+IGlzIG5vdCBsb25nIHRlcm0gcGlubmVkLiBJZGVhbCB3YXkgdG8gaW1wbGVtZW50
IHRoaXMgaW50ZWdyYXRpb24gd291bGQNCj4gPiA+IGJlIHRvIHN1cHBvcnQgYSBub3RpZmllciB0
aGF0IGNhbiBiZSBpbnZva2VkIGJ5IGd1ZXN0X21lbWZkIHdoZW4NCj4gPiA+IG1lbW9yeSByYW5n
ZXMgZ2V0IHRydW5jYXRlZCBzbyB0aGF0IElPTU1VIGNhbiB1bm1hcCB0aGUNCj4gY29ycmVzcG9u
ZGluZw0KPiA+ID4gcmFuZ2VzLiBTdWNoIGEgbm90aWZpZXIgc2hvdWxkIGFsc28gZ2V0IGNhbGxl
ZCBkdXJpbmcgbWVtb3J5DQo+ID4gPiBjb252ZXJzaW9uLCBpdCB3b3VsZCBiZSBpbnRlcmVzdGlu
ZyB0byBkaXNjdXNzIGhvdyBjb252ZXJzaW9uIGZsb3cNCj4gPiA+IHdvdWxkIHdvcmsgaW4gdGhp
cyBjYXNlLg0KPiA+ID4NCj4gPiA+IFsxXSBodHRwczovL2xwYy5ldmVudHMvZXZlbnQvMTgvY29u
dHJpYnV0aW9ucy8xNzY0LyAoY2hlY2tvdXQgdGhlDQo+ID4gPiBzbGlkZSAxMiBmcm9tIGF0dGFj
aGVkIHByZXNlbnRhdGlvbikNCj4gPiA+DQo+ID4NCj4gPiBNb3N0IGRldmljZXMgZG9uJ3Qgc3Vw
cG9ydCBJL08gcGFnZSBmYXVsdCBoZW5jZSBjYW4gb25seSBETUEgdG8gbG9uZw0KPiA+IHRlcm0g
cGlubmVkIGJ1ZmZlcnMuIFRoZSBub3RpZmllciBtaWdodCBiZSBoZWxwZnVsIGZvciBpbi1rZXJu
ZWwgY29udmVyc2lvbg0KPiA+IGJ1dCBhcyBhIGJhc2ljIHJlcXVpcmVtZW50IHRoZXJlIG5lZWRz
IGEgd2F5IGZvciBJT01NVUZEIHRvIGNhbGwgaW50bw0KPiA+IGd1ZXN0IG1lbWZkIHRvIHJlcXVl
c3QgbG9uZyB0ZXJtIHBpbm5pbmcgZm9yIGEgZ2l2ZW4gcmFuZ2UuIFRoYXQgaXMNCj4gPiBob3cg
SSBpbnRlcnByZXRlZCAiZGlmZmVyZW50IHBhdGgiIGluIEphc29uJ3MgY29tbWVudC4NCj4gDQo+
IFBvbGljeSB0aGF0IGlzIGJlaW5nIGFpbWVkIGhlcmU6DQo+IDEpIGd1ZXN0X21lbWZkIHdpbGwg
cGluIHRoZSBwYWdlcyBiYWNraW5nIGd1ZXN0IG1lbW9yeSBmb3IgYWxsIHVzZXJzLg0KPiAyKSBr
dm1fZ21lbV9nZXRfcGZuIHVzZXJzIHdpbGwgZ2V0IGEgbG9ja2VkIGZvbGlvIHdpdGggZWxldmF0
ZWQNCj4gcmVmY291bnQgd2hlbiBhc2tpbmcgZm9yIHRoZSBwZm4vcGFnZSBmcm9tIGd1ZXN0X21l
bWZkLiBVc2VycyB3aWxsDQo+IGRyb3AgdGhlIHJlZmNvdW50IGFuZCByZWxlYXNlIHRoZSBmb2xp
byBsb2NrIHdoZW4gdGhleSBhcmUgZG9uZQ0KPiB1c2luZy9pbnN0YWxsaW5nIChlLmcuIGluIEtW
TSBFUFQvSU9NTVUgUFQgZW50cmllcykgaXQuIFRoaXMgZm9saW8NCj4gbG9jayBpcyBzdXBwb3Nl
ZCB0byBiZSBoZWxkIGZvciBzaG9ydCBkdXJhdGlvbnMuDQo+IDMpIFVzZXJzIGNhbiBhc3N1bWUg
dGhlIHBmbiBpcyBhcm91bmQgdW50aWwgdGhleSBhcmUgbm90aWZpZWQgYnkNCj4gZ3Vlc3RfbWVt
ZmQgb24gdHJ1bmNhdGlvbiBvciBtZW1vcnkgY29udmVyc2lvbi4NCj4gDQo+IFN0ZXAgMyBhYm92
ZSBpcyBhbHJlYWR5IGZvbGxvd2VkIGJ5IEtWTSBFUFQgc2V0dXAgbG9naWMgZm9yIENvQ28gVk1z
Lg0KPiBURFggVk1zIGVzcGVjaWFsbHkgbmVlZCB0byBoYXZlIHNlY3VyZSBFUFQgZW50cmllcyBh
bHdheXMgbWFwcGVkIChvbmNlDQo+IGZhdWx0ZWQtaW4pIHdoaWxlIHRoZSBndWVzdCBtZW1vcnkg
cmFuZ2VzIGFyZSBwcml2YXRlLg0KDQonZmF1bHRlZC1pbicgZG9lc24ndCB3b3JrIGZvciBkZXZp
Y2UgRE1BcyAody9vIElPUEYpLg0KDQphbmQgYWJvdmUgaXMgYmFzZWQgb24gdGhlIGFzc3VtcHRp
b24gdGhhdCBDb0NvIFZNIHdpbGwgYWx3YXlzDQptYXAvcGluIHRoZSBwcml2YXRlIG1lbW9yeSBw
YWdlcyB1bnRpbCBhIGNvbnZlcnNpb24gaGFwcGVucy4NCg0KQ29udmVyc2lvbiBpcyBpbml0aWF0
ZWQgYnkgdGhlIGd1ZXN0IHNvIGlkZWFsbHkgdGhlIGd1ZXN0IGlzIHJlc3BvbnNpYmxlIA0KZm9y
IG5vdCBsZWF2aW5nIGFueSBpbi1mbHkgRE1BcyB0byB0aGUgcGFnZSB3aGljaCBpcyBiZWluZyBj
b252ZXJ0ZWQuDQpGcm9tIHRoaXMgYW5nbGUgaXQgaXMgZmluZSBmb3IgSU9NTVVGRCB0byByZWNl
aXZlIGEgbm90aWZpY2F0aW9uIGZyb20NCmd1ZXN0IG1lbWZkIHdoZW4gc3VjaCBhIGNvbnZlcnNp
b24gaGFwcGVucy4NCg0KQnV0IEknbSBub3Qgc3VyZSB3aGV0aGVyIHRoZSBURFggd2F5IGlzIGFy
Y2hpdGVjdHVyYWwgb3IganVzdCBhbg0KaW1wbGVtZW50YXRpb24gY2hvaWNlIHdoaWNoIGNvdWxk
IGJlIGNoYW5nZWQgbGF0ZXIsIG9yIHdoZXRoZXIgaXQNCmFwcGxpZXMgdG8gb3RoZXIgYXJjaC4N
Cg0KSWYgdGhhdCBiZWhhdmlvciBjYW5ub3QgYmUgZ3VhcmFudGVlZCwgdGhlbiB3ZSBtYXkgc3Rp
bGwgbmVlZCBhIHdheQ0KZm9yIElPTU1VRkQgdG8gcmVxdWVzdCBsb25nIHRlcm0gcGluLg0K

