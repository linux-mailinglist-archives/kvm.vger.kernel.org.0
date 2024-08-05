Return-Path: <kvm+bounces-23183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C089474B5
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 07:35:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7AA31C20C4B
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 05:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A90142911;
	Mon,  5 Aug 2024 05:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MDlNOmrk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4807163A
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 05:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722836124; cv=fail; b=hF5eOXaLjvBsy+SY6/3DXjTGQgQLXg56B79FjzOJGjWwLNLGA0gEo+/S37T1GDeIjDwHSpx5qLzHWLQlX/NhseYr1n2p5+g5RwKsmf5uPX1g3SYE35FE2UcDEfQjGSrR9A7fvoPRjQwC7GjQ5pzgAAdMwUwbCG2Im+WAy+XJlLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722836124; c=relaxed/simple;
	bh=MvT2LFuxkB0RRwNWXQXJFvTByIEybtwlwy6S2MrltsM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JiMNHV4x/AvR1+caf1US3iyGnKeSPsfN17P3wIlnRG4hhq4BSQWVGezF5iceR/j8vM/9EOvFIxnSv1hSkdWrJcFmzkUo1rvW2kfYHSfTyBjdOzQ3XSjho2/poLUM+MbZWg7GJeNOSms3Rm4WZsDLl8M4vtFMRRbEmq3EcMcZdVE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MDlNOmrk; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722836122; x=1754372122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MvT2LFuxkB0RRwNWXQXJFvTByIEybtwlwy6S2MrltsM=;
  b=MDlNOmrkwfwx2s0Ee9VStBAQAj9cpBVyt6WIzZNgyEt75NliAladuJrX
   YXjW9VefHYC+0XjdmBN2rXCKjBiPBWcX69lW+XIL95PKnaWAml1/gK/Ca
   aJ1Zg0NvbFL6UR2R2IEb5bDAITmgBpUSgYvMpyA6oSSKTlf0Layst2/tm
   Yqmi6uwKozw7iVphlkdTxNIh0NJUbbbVRlE5HLxPzFteF0sskoUXSmQbM
   4fjruAAlr5bNRtwb2Sw5CTXO2opfIMpBEjryY50bitMaGnMd0I/xCCEC0
   fTQ2OCftTC3cLD0X2pI6oIyRO++wAK+R1udBLgd8ZlyfN8R6vVS/RU98j
   g==;
X-CSE-ConnectionGUID: qHIwyf7+QuSNh4wvLdRpfA==
X-CSE-MsgGUID: nnIQ6skTTEa42ONDP0GTUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="20731634"
X-IronPort-AV: E=Sophos;i="6.09,263,1716274800"; 
   d="scan'208";a="20731634"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2024 22:35:21 -0700
X-CSE-ConnectionGUID: GrD55w/+Tqy4pu0e4R2Gvg==
X-CSE-MsgGUID: r0RWZx+XRrqJ3Y3LUMfBuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,263,1716274800"; 
   d="scan'208";a="60857980"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Aug 2024 22:35:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 4 Aug 2024 22:35:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 4 Aug 2024 22:35:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 4 Aug 2024 22:35:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x/BqIyydWn10HhKIjAP0Y9rRUvFkpnUh9tf1knQZj472BrK/1Aeib0/UUPbnDTXEvx+SmIRDRtEFs+RdDl+7xhe4mL0HV3F3CPcZlKEPDWtun6DyhXVkTfjmDuRaU0S6CpfPAEkRDnA2Oo2zwlh6rIRpIg1tsVpOV4Bcem7Kb1A58zWnUrktiA3rrdH5Tj/hTAsrUOZXbKnXYoETNiPQF86I6jVUHiJE9GfT4zAHjVnqBBxj6HCq5OCbECbGLuu9TJSGmdqc/ywxm1g73UA2k3MPb01sfOG37Txt4S21beeqi7Lx51ZpLKZjp6vzXZeddSIRwSreEfVbM60loLbhNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvT2LFuxkB0RRwNWXQXJFvTByIEybtwlwy6S2MrltsM=;
 b=G4AYGGRaGqg5O5lvOdjYVoO9TpjFaa5h/9s9OtN3KGfRYZPv4LrdNnzrOvNPwoVsu2Hx1zB+Bsp/ObV+r5hkqxkFrP8f7IJzFA+ox2gUataHUQoUO+3jh/6ndJoIEXCokZQRbNd+QvsaVHDVbOAoTglGkY3WEuxRtxu5HZt1c2VpddQc53NsTwUv5febWYuhcVsTO4RBh4KqQQjE1HNf3HSixiQ/earKHWefl+3faENF+ErLCEzgoTMX1jhbXzySiTGUXu2N8CmtPpSS4dkaHLvyZ6M1VDV4fpdUHxZxdYt+gTEGncpUyB7DgATiuyecfCbPu2yGMeKeBgqdiJBC+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB8081.namprd11.prod.outlook.com (2603:10b6:8:15c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Mon, 5 Aug
 2024 05:35:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 05:35:17 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>,
	=?utf-8?B?Q8OpZHJpYyBMZSBHb2F0ZXI=?= <clg@redhat.com>
Subject: RE: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Topic: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Thread-Index: AQHajLJtgFipqDFp5kGVxfWLZ+e8jbFqmBhwgACbmQCAANtx0IAAWtiAgACzNgCAAAsdMIAAnMyAgADCDYCAAJZRIIAAuGoAgAWh6eCAAFrQgIAAvzfAgAAM8ICAATEtgIAAA00AgAAbNoCAAr9fgIAAZVAAgASNTwCAhOTNIIALrw6AgACT05CAAPXvAIAA2q0AgAJglQCAA7rsIA==
Date: Mon, 5 Aug 2024 05:35:17 +0000
Message-ID: <BN9PR11MB5276318969A212AD0649C7BE8CBE2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240419103550.71b6a616.alex.williamson@redhat.com>
	<BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240423120139.GD194812@nvidia.com>
	<BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240424001221.GF941030@nvidia.com>
	<20240424122437.24113510.alex.williamson@redhat.com>
	<20240424183626.GT941030@nvidia.com>
	<20240424141349.376bdbf9.alex.williamson@redhat.com>
	<20240426141117.GY941030@nvidia.com>
	<20240426141354.1f003b5f.alex.williamson@redhat.com>
	<20240429174442.GJ941030@nvidia.com>
	<BN9PR11MB5276C4EF3CFB6075C7FC60AC8CAA2@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240730113517.27b06160.alex.williamson@redhat.com>
	<BN9PR11MB5276D184783C687B0B1B6FE68CB12@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20240731110436.7a569ce0.alex.williamson@redhat.com>
	<BN9PR11MB5276BEBDDD6720C2FEFD4B718CB22@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240802122528.329814a7.alex.williamson@redhat.com>
In-Reply-To: <20240802122528.329814a7.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB8081:EE_
x-ms-office365-filtering-correlation-id: 7dcab30f-9b3e-410e-a9e1-08dcb51063de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RTFqa0J3TENwQXhveUZ5cHdyVEVZbkdHVmh5aXBKczdGWFBxYjJVdGlSWmxk?=
 =?utf-8?B?RFB5V2VYYWNHQmdKZ2pidVl4bStFbGFFRkNlWHJTMytMZy9ZWkszOE1hM01N?=
 =?utf-8?B?ZzcwU3pBNzVpbDFVa0RlbHpTbWo1MnkvUEhYNGJEZUZ1UVdaQlpIK2h3ajZJ?=
 =?utf-8?B?STg2WGU1ZmI1RWduRUpIZEg0SFJZWWM3TUJudnhLN2ZPRkttWWxPSjZSZGt4?=
 =?utf-8?B?SGtILy9XS2RQY3FqdU00dE5qdXBDbjFFVVh1YlJZZG15azhNcFVzVWFhS09H?=
 =?utf-8?B?TkxYT0tsV3l2a21pWU43SWUweUxBcXhxZ2FqTGNFOW5JSXFtYnpGTXprbGU4?=
 =?utf-8?B?c0duMXo1QkE2TWpkYXpwdlNTYnRxcXRCTE1iT3V4QlMwcVNGSE5MVnFiRVlB?=
 =?utf-8?B?YzRLdTNHU0hmNmVoQzdFR3pGMFBYaWk2QVlQVlliMFl1MFd1dldpK08xdjB4?=
 =?utf-8?B?MlhtbDFZeFdNOTVZZGJkcHlCS2tvOG84c2NVNmRYcFFCZzJQL0JzRmZWeVc5?=
 =?utf-8?B?TC9BQjl3NG5nZ09xWFFONjBvZHhzWWs5TUdvUWYxbzQ0dzBxYmhvbUprcVN3?=
 =?utf-8?B?V0ROQzFqQ0xwQzVqc21vZzZyNndQa0Y0QzZMT0lycWtLbTlrQXN3aE9OK0ov?=
 =?utf-8?B?TjVFNEJTQ2V4TUJZMmtZSDJadTd2MmRjVkt4Y0REK2x1Njk1bVg1YjhNMDZp?=
 =?utf-8?B?U2hTOS9TNUlZWURxUWJPN3VBQ05hbUtmWHNoeGlnT2Y5bm1sc0F6NWJiTzQw?=
 =?utf-8?B?RlcwN2lmNnRQbG1JZFdJSVJUN0JKV2dFcFBSN08rNXRXRjBkLzkxQUx2SDVF?=
 =?utf-8?B?bHllL1pNaWhnek9TdEpuZS9rU1R1bEx1ZGNjNnZidEVreFdyY1lTdjFpYmpC?=
 =?utf-8?B?MlNod2lWc3Vob2JjdHlzV04wS2ZCVU1GV1NEdHdQbzZBSmhnNGJucjh3NGFv?=
 =?utf-8?B?ZGM2ZTBuZkZpeXgrVGZUQWFlZjFURU0yRktHMW1ZVTFGR3BPWlN6dStBd3JF?=
 =?utf-8?B?ZkFoN0MyN016bExRZmJ1N0xLQ2lJbzNjSXpKUlpobkJxeU9vRXU1dnQzZUpa?=
 =?utf-8?B?R1hhK0dtWUJlQVlXWFhyeE1xWm1wSzN4b0tzV0FMUnpJSm4rd3lla0xxTkxK?=
 =?utf-8?B?dzMzdkFFZk9MaS9odzdoUjZPajdpTGpBZUkxNWlqZ1ZzYy9ZNWxSVUdpNVJW?=
 =?utf-8?B?NlpVdU9ucU1UenJaamNGTHRuby96NG5aSWJNNTgvMjhCWWdjc2ZjQWVuVkY4?=
 =?utf-8?B?ZDQxR2ViYjl0akJPK2RXS2hSbzNLWHpTNTFybjRWdkNiV3BIS2h1N2ZmazFm?=
 =?utf-8?B?WVhnSDZBNWtuRkJrYjVhU3VyRzZpZENPamt1Z05MbnIwMWZFK1V0SFpmNEg5?=
 =?utf-8?B?cnp4dXlWeUpwNFlGeTk1d2dTMzFhZjlqajhuelRUVktDWGJDbGM4TUc4c29p?=
 =?utf-8?B?alZacTN4RWhQYXhSQmFMekpuSnpKWlY3eVJ2NEJpYjNyV0tMdmFoelhBWFlM?=
 =?utf-8?B?RE5zRldxOEhoeVpGcE40NXZwektuU3NzTmZPaXpiQXo1STRkWFJlSjJVUHc1?=
 =?utf-8?B?ekp5c3o1MzAzb0lTcnlvOGM2eXBhRDEwSCswUWhOdFlTR09XQWNiRU9rN00w?=
 =?utf-8?B?Vk1uSnpLQWIvb0pDZU5DVU95TVFja0JMRWlHcTBERVdCYVB2L2xiVklqV3lQ?=
 =?utf-8?B?L1RSTDJxc01ST2VYb2ErK01kOTMzaEFYNkJwTTROdkdUQXEyKzd6YXNzZGwv?=
 =?utf-8?B?U3V0UGNVZzhFR3BnTEp3dG1WZ05DNXdDa1BvVVV3TFBTSldkOThsQjQvNDZz?=
 =?utf-8?B?MkIwK3Azc3U0OEQwbHJhaHRSSHRNaFgzNmp4YnpJVGlZc3BHYk5rdHArUzNO?=
 =?utf-8?B?aFFkbzVYSVpnc0pFeEJ2T3NsTlo5bGlHOVBpRXFIQ2t1ZHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dElRQjhQSUtKbWRPSkY0Q0xKWHoxRUN3M1hxL204K0JPRzZTbWV1SkxUakx0?=
 =?utf-8?B?a2hld3F6ZjIxelNEQktvNFJCekFXRlRtdWNGT1l1QWs0disvSXNJSDJDaXlq?=
 =?utf-8?B?blVKZEQvQ0M5VHE4QnRINlFrMlpVTUY4ZWtPSmI3N3dRQUw3S0lxa0hQOG9t?=
 =?utf-8?B?Q0lSa1lqZXRRNkkxdGFjaE96NUlDaDlLUHJuOWlHUU1JWWQwOWRMZFV6ZWxY?=
 =?utf-8?B?eWRQT3JLMnd1WEV3TlNPNjB3YlY4dWNldHVQYXNJZktNVmtxUSs2SW83TlNS?=
 =?utf-8?B?TlpOblc2UnJHYkRaMWtEY01FTnVLTnJwbHBKVXNyU01UVlZlQms1OVp6c0o5?=
 =?utf-8?B?bWdQeGI1K2E1eDFGbitxK0J3dGIwRlY3YzZQSy9Dck52NVh4aWdxREJlRnNC?=
 =?utf-8?B?MTVKendFRVJuSWtKT0hES09SeUpBODVKN2ZVeWpIYkdGdUZHaVZQdWsvTE1n?=
 =?utf-8?B?c2NkbGlONkxYanNZUjFyU3dWZHZuUzh6bGV3OUJkZWRQSWh5Y3N0emlsTzd6?=
 =?utf-8?B?cmdZTkZnTDN5dnQrL1BlMG42VGdFVUtEU2V2aXRoOGhOSkk1VDBxVkhlbEpw?=
 =?utf-8?B?NE02RWNjZzg2S1BDNVRESkdSNjk0WCtPdUJJZWFvSGRPSmpxY2QvQlhHamlR?=
 =?utf-8?B?YVRaeEhOMkx6ajNpNUdCT0JHbHBBOGpiNmZCaWVJVjlraXBOeHh1anhCMmpy?=
 =?utf-8?B?Y2crY3pxZkFsNFVSdTdIaHB3OGtXQUhyR1RSeVRIM1hxZzNwNE8vbUIzRWJh?=
 =?utf-8?B?SWJhM2IzVzdkNGJyTGZWVnVtZml1TDc2Sm54ZmJUY3NzaDYzUUdRcUNTZStm?=
 =?utf-8?B?TlRqQ1ZKVXZJd1BRNDgwaDdIcHl0aW82OFZ1QzMwUnM3Z3B6QVRUbzJwNDl3?=
 =?utf-8?B?NDlIOU5MRmJQcFlDMTJYYVNzTVFTQ1o2RnoxMVBuNGFSNHVBRGp2ZThqYldr?=
 =?utf-8?B?aEZvNldxeFlza3dJT3FiOUI5aVcwenNUWi9Fa1RMS0txM25VcHVGTTNYZWFB?=
 =?utf-8?B?RHptRERKSXkzZ2JLbkdQaUhYK1dJSnBXNkFGeGR2Q3pUVDN4M29jdG9ySTVW?=
 =?utf-8?B?N21Wd0l2K0M3dVlqVzZxNTlYMUNHQWdhYUZJaXpMWXhzODdOSVRmUGVYMURI?=
 =?utf-8?B?d0pvMkY0aXBNTXNpZXF2amR0M1RQQ0JIVmQ2S3Rqa1FBb0lwbFdXWnErMVBB?=
 =?utf-8?B?OGgra1dPZk1rVTRDREg3cFZvWUl1UVVxaXVFL2lKa3ErUmVSemUxaW1TR0Zi?=
 =?utf-8?B?UDFKUzRQM2tJemZoZG02RElTUkRDNFd2a2ticWw0NXRKZWxZVjdvWVFCTGNK?=
 =?utf-8?B?MUJxT09xZUZLVVJFSjhFaDB3TldyaXZHUldjd29xQTJ1TG9Ici95ZklQU2x1?=
 =?utf-8?B?d01BVzYvemZnaUpQcWZndzdlL3NqeEpqWU5vV0pWNXBQRTVFZC9rbnhoS2Ra?=
 =?utf-8?B?aXNlMWJBdzE3anZzQUFVaVk2YllUQnFJQ2Q2MjFPN1VhTjhXM2Y3MHZlVitL?=
 =?utf-8?B?TEZXMWdwTWttZ1lOZldDZHFhY2M1RkhxZmkvTExSSThvTWJNeFFIVXpkRWRU?=
 =?utf-8?B?TGVVclc0S3lDSGdQK1M3elE3blFlTGdGU2tCUGRvdGRuTy90dzFaUzljRCtG?=
 =?utf-8?B?S0ZwUml3MFFmUG9nV2RsYVE4UmZDdWpuWHlMdUlQR0EzUXdmZHVVVEIxck1C?=
 =?utf-8?B?RVJ6VHZBVlFJSjBFYTA3bEE5TjN3WG82NTRvaW4wU0NreTkzTjgwYXNXSEEy?=
 =?utf-8?B?T0FNdjBtU2pIZjcrcWRhTjA5REZ2dWFlT0ROOWFiV0VpOTlyNWJTWGRsa1VV?=
 =?utf-8?B?c1E4ZXJGdFFMRjdyZ3JsYzlEc2x3YTFvOEFDckhGb3VQRzhCMVI1dVhtY1JP?=
 =?utf-8?B?YVZ0aGFwV0FraldpWnc2b3NFZVloanV2L3RFcWVDMkVHZ0gzZzlYSDV2aVpC?=
 =?utf-8?B?TWJ1R0sxa0hjanlLcW5BbG4xYlAzNGlnRFZYeWtEdmJGT1hvZGhnL2VtOXBv?=
 =?utf-8?B?TTRXK2JHZ3F2bElDT0Q2L1VCRENnQ0YyOHlURDZSYVJKV2pzcTVUNXczWFlY?=
 =?utf-8?B?NC9CRUdoUStxRERPdmZsbDdwVUdOd1FaQzBTV2MrbnFlRWwxbWtGTmhkNUcy?=
 =?utf-8?Q?9pEZkdSLL0kO2fcTUjqQbU2jW?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dcab30f-9b3e-410e-a9e1-08dcb51063de
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2024 05:35:17.8885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UKMJJ3f6oDei/Flpmb4pGJE60nv+/Jp7iK7pQaayzi1L5J0WngFCN5ITYtBgALRg7ED1I9EFc3x4MrUvj7E9lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8081
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlhbXNvbkByZWRoYXQuY29tPg0KPiBT
ZW50OiBTYXR1cmRheSwgQXVndXN0IDMsIDIwMjQgMjoyNSBBTQ0KPiANCj4gT24gVGh1LCAxIEF1
ZyAyMDI0IDA3OjQ1OjQzICswMDAwDQo+ICJUaWFuLCBLZXZpbiIgPGtldmluLnRpYW5AaW50ZWwu
Y29tPiB3cm90ZToNCj4gDQo+ID4gPiBGcm9tOiBBbGV4IFdpbGxpYW1zb24gPGFsZXgud2lsbGlh
bXNvbkByZWRoYXQuY29tPg0KPiA+ID4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCAxLCAyMDI0IDE6
MDUgQU0NCj4gPiA+DQo+ID4gPiBPbiBXZWQsIDMxIEp1bCAyMDI0IDA1OjE1OjI1ICswMDAwDQo+
ID4gPiAiVGlhbiwgS2V2aW4iIDxrZXZpbi50aWFuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gPg0K
PiA+ID4gPiA+IEZyb206IEFsZXggV2lsbGlhbXNvbiA8YWxleC53aWxsaWFtc29uQHJlZGhhdC5j
b20+DQo+ID4gPiA+ID4gU2VudDogV2VkbmVzZGF5LCBKdWx5IDMxLCAyMDI0IDE6MzUgQU0NCj4g
PiA+ID4gPg0KPiA+ID4gPiA+IFNvIHdoYXQgYXJlIHdlIHRyeWluZyB0byBhY2NvbXBsaXNoIGhl
cmUuICBQQVNJRCBpcyB0aGUgZmlyc3QNCj4gPiA+ID4gPiBub24tZGV2aWNlIHNwZWNpZmljIHZp
cnR1YWwgY2FwYWJpbGl0eSB0aGF0IHdlJ2QgbGlrZSB0byBpbnNlcnQgaW50bw0KPiA+ID4gPiA+
IHRoZSBWTSB2aWV3IG9mIHRoZSBjYXBhYmlsaXR5IGNoYWluLiAgSXQgd29uJ3QgYmUgdGhlIGxh
c3QuDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiAgLSBEbyB3ZSBwdXNoIHRoZSBwb2xpY3kgb2YgZGVm
aW5pbmcgdGhlIGNhcGFiaWxpdHkgb2Zmc2V0IHRvIHRoZSB1c2VyPw0KPiA+ID4gPg0KPiA+ID4g
PiBMb29rcyB5ZXMgYXMgSSBkaWRuJ3Qgc2VlIGEgc3Ryb25nIGFyZ3VtZW50IGZvciB0aGUgb3Bw
b3NpdGUgd2F5Lg0KPiA+ID4NCj4gPiA+IEl0J3MgYSBwb2xpY3kgY2hvaWNlIHRob3VnaCwgc28g
d2hlcmUgYW5kIGhvdyBpcyBpdCBpbXBsZW1lbnRlZD8gIEl0DQo+ID4gPiB3b3JrcyBmaW5lIGZv
ciB0aG9zZSBvZiB1cyB3aWxsaW5nIHRvIGVkaXQgeG1sIG9yIGxhdW5jaCBWTXMgYnkgY29tbWFu
ZA0KPiA+ID4gbGluZSwgYnV0IGxpYnZpcnQgaXNuJ3QgZ29pbmcgdG8gc2lnbiB1cCB0byBpbnNl
cnQgYSBwb2xpY3kgY2hvaWNlIGZvcg0KPiA+ID4gYSBkZXZpY2UuICBJZiB3ZSBnZXQgdG8gZXZl
biBoaWdoZXIgbGV2ZWwgdG9vbHMsIGRvZXMgYW55dGhpbmcgdGhhdA0KPiA+ID4gd2FudHMgdG8g
aW1wbGVtZW50IFBBU0lEIHN1cHBvcnQgcmVxdWlyZWQgYSB2ZW5kb3Igb3BlcmF0b3IgZHJpdmVy
IHRvDQo+ID4gPiBtYWtlIHN1Y2ggcG9saWN5IGNob2ljZXMgKGJ0dywgSSdtIGp1c3QgdGhyb3dp
bmcgb3V0IHRoZSAib3BlcmF0b3IiDQo+ID4gPiB0ZXJtIGFzIGlmIEkga25vdyB3aGF0IGl0IG1l
YW5zLCBJIGRvbid0KS4NCj4gPg0KPiA+IEkgaGFkIGEgcm91Z2ggZmVlbGluZyB0aGF0IHRoZXJl
IG1pZ2h0IGJlIG90aGVyIHVzYWdlcyByZXF1aXJpbmcgc3VjaA0KPiA+IHZlbmRvciBwbHVnaW4s
IGUuZy4gcHJvdmlzaW9uaW5nIFZGL0FESSBtYXkgcmVxdWlyZSB2ZW5kb3Igc3BlY2lmaWMNCj4g
PiBjb25maWd1cmF0aW9ucywgYnV0IG5vdCByZWFsbHkgYW4gZXhwZXJ0IGluIHRoaXMgYXJlYS4N
Cj4gPg0KPiA+IE92ZXJhbGwgSSBmZWVsIG1vc3Qgb2Ygb3VyIGRpc2N1c3Npb25zIHNvIGZhciBh
cmUgYWJvdXQgVk1NLWF1dG8tDQo+ID4gZmluZC1vZmZzZXQgdnMuIGZpbGUtYmFzZWQtcG9saWN5
LXNjaGVtZSB3aGljaCBib3RoIGJlbG9uZyB0bw0KPiA+IHVzZXItZGVmaW5lZCBwb2xpY3ksIHN1
Z2dlc3RpbmcgdGhhdCB3ZSBhbGwgYWdyZWVkIHRvIGRyb3AgdGhlIG90aGVyDQo+ID4gd2F5IGhh
dmluZyBrZXJuZWwgZGVmaW5lIHRoZSBvZmZzZXQgKHBsdXMgaW4ta2VybmVsIHF1aXJrcywgZXRj
Lik/DQo+ID4NCj4gPiBFdmVuIHRoZSBzYWlkIERWU0VDIGlzIHRvIGFzc2lzdCBzdWNoIHVzZXIt
ZGVmaW5lZCBkaXJlY3Rpb24uDQo+IA0KPiBUbyBtZSBhICJ1c2VyIGRlZmluZWQgcG9saWN5IiBp
cyBwbGFjaW5nIGFuIG9wdGlvbiBvbiB0aGUgY29tbWFuZCBsaW5lDQo+IGFuZCByZXF1aXJpbmcg
dGhlIHVzZXIsIG9yIHNvbWUgaGlnaGVyIGxldmVsIGF1dGhvcml0eSByZXByZXNlbnRpbmcgdGhl
DQo+IHVzZXIsIHRvIHByb3ZpZGUgdGhlIHBvbGljeS4gIElmIGl0J3MgZG9uZSBieSB0aGUgVk1N
IHRoZW4gd2UncmUgc2F5aW5nDQo+IFFFTVUgb3ducyB0aGUgcG9saWN5IGJ1dCBpdCBtaWdodCBi
ZSBvdmVycmlkZGVuIGJ5IHRoZSB1c2VyIHZpYSBhDQo+IGNvbW1hbmQgbGluZSBhcmd1bWVudCBv
ciBtb2RpZnlpbmcgdGhlIHBvbGljeSBmaWxlIGNvbnN1bWVkIGJ5IFFFTVUuDQoNCk9rYXksIEkg
c2VlIHRoZSBkaWZmZXJlbmNlIGhlcmUuIEluIG15IHJlcGx5IGl0J3MgY2xlYXJlciB0byBzYXkN
CiJ1c2Vyc3BhY2UiIGluc3RlYWQgb2YgInVzZXIiLiDwn5iKDQoNCj4gPiA+IGludm9sdmVkIHdp
dGggdGhhdCwgc28gd2h5IGRvZXMgaXQgbWFrZSBzZW5zZSBmb3IgdmZpby1wY2kgdG8gYmUNCj4g
PiA+IGludm9sdmVkIGluIHJlcG9ydGluZyBzb21ldGhpbmcgdGhhdCBpcyBtb3JlIGlvbW11ZmQg
c3BlY2lmaWM/DQo+ID4NCj4gPiBJdCBkb2Vzbid0IG1hdHRlciB3aGljaCBvbmUgaW52b2x2ZXMg
bW9yZS4gSXQncyBtb3JlIGFraW4gdG8gdGhlDQo+ID4gcGh5c2ljYWwgd29ybGQuDQo+ID4NCj4g
PiBidHcgdmZpby1wY2kgYWxyZWFkeSByZXBvcnRzIEFUUy9QUkkgd2hpY2ggYm90aCByZWx5IG9u
IGlvbW11ZmQNCj4gPiBpbiB2Y29uZmlnIHNwYWNlLiBUaHJvd2luZyBQQVNJRCBhbG9uZSB0byBp
b21tdWZkIHVBUEkgbGFja3Mgb2YgYQ0KPiA+IGdvb2QganVzdGlmaWNhdGlvbiBmb3Igd2h5IGl0
J3Mgc3BlY2lhbC4NCj4gPg0KPiA+IEkgZW52aXNpb24gYW4gZXh0ZW5zaW9uIHRvIHZmaW8gZGV2
aWNlIGZlYXR1cmUgb3IgYSBuZXcgdmZpbyB1QVBJDQo+ID4gZm9yIHJlcG9ydGluZyB2aXJ0dWFs
IGNhcGFiaWxpdGllcyBhcyBhdWdtZW50IHRvIHRoZSBvbmVzIGZpbGxlZCBpbg0KPiA+IHZjb25m
aWcgc3BhY2UuDQo+IA0KPiBTaG91bGQgQVRTIGFuZCBQUkkgYmUgcmVwb3J0ZWQgdGhyb3VnaCB2
ZmlvLXBjaSBvciBzaG91bGQgd2UganVzdCB0dXJuDQo+IHRoZW0gb2ZmIHRvIGJlIG1vcmUgbGlr
ZSBQQVNJRD8gIE1heWJlIHRoZSBpc3N1ZSBzaW1wbHkgaGFzbid0IGFyaXNlbg0KPiB5ZXQgYmVj
YXVzZSB3ZSBkb24ndCBoYXZlIHZJT01NVSBzdXBwb3J0IGFuZCB3aXRoIHRoYXQgc3VwcG9ydCBR
RU1VDQo+IG1pZ2h0IG5lZWQgdG8gZmlsdGVyIG91dCB0aG9zZSBjYXBhYmlsaXRpZXMgYW5kIGxv
b2sgZWxzZXdoZXJlLg0KPiBBbnl3YXksIGlvbW11ZmQgYW5kIHZmaW8tcGNpIHNob3VsZCBub3Qg
ZHVwbGljYXRlIGVhY2ggb3RoZXIgaGVyZS4NCg0KSWYgbm8tZHVwbGljYXRpb24gaXMgdGhlIGFn
cmVlZCB3YXksIHllcyBpdCdzIGNsZWFyZXIgdG8gaGF2ZQ0KQVRTL1BSSS9QQVNJRCByZXBvcnRl
ZCBjb25zaXN0ZW50bHkgdmlhIGlvbW11ZmQgaGVuY2UgaGlkZGVuDQppbiB2ZmlvLXBjaS4NCg0K
R2l2ZW4gdGhlcmUgaXMgbm8gdklPTU1VIHN1cHBvcnQgdGhpcyBjaGFuZ2Ugc2hvdWxkbid0IGJy
ZWFrDQphbnkgYXBwbGljYXRpb25zLg0KDQo+IA0KPiA+ID4gPiA+IHRoZW4gd2UganVzdCBsb29r
IGZvciBhIGdhcCBhbmQgYWRkIHRoZSBjYXBhYmlsaXR5LiAgSWYgd2UgZW5kIHVwIHdpdGgNCj4g
PiA+ID4gPiBkaWZmZXJlbnQgcmVzdWx0cyBiZXR3ZWVuIHNvdXJjZSBhbmQgdGFyZ2V0IGZvciBt
aWdyYXRpb24sIHRoZW4NCj4gPiA+ID4gPiBtaWdyYXRpb24gd2lsbCBmYWlsLiAgUG9zc2libHkg
d2UgZW5kIHVwIHdpdGggYSBxdWlyayB0YWJsZSB0byBvdmVycmlkZQ0KPiA+ID4gPiA+IHRoZSBk
ZWZhdWx0IHBsYWNlbWVudCBvZiBzcGVjaWZpYyBjYXBhYmlsaXRpZXMgb24gc3BlY2lmaWMgZGV2
aWNlcy4NCj4gPiA+ID4NCj4gPiA+ID4gZW1tIGhvdyBkb2VzIGEgcXVpcmsgdGFibGUgd29yayB3
aXRoIGRldmljZXMgaGF2aW5nIHZvbGF0aWxlIGNvbmZpZw0KPiA+ID4gPiBzcGFjZSBsYXlvdXQg
Y3Jvc3MgRlcgdmVyc2lvbnM/IENhbiBWTU0gYXNzaWduZWQgd2l0aCBhIFZGIGJlIGFibGUNCj4g
PiA+ID4gdG8gY2hlY2sgdGhlIEZXIHZlcnNpb24gb2YgdGhlIFBGPw0KPiA+ID4NCj4gPiA+IElm
IHRoZSBWTU0gY2FuJ3QgZmluZCB0aGUgc2FtZSBnYXAgYmV0d2VlbiBzb3VyY2UgYW5kIGRlc3Rp
bmF0aW9uIHRoZW4NCj4gPiA+IGEgcXVpcmsgY291bGQgbWFrZSBzdXJlIHRoYXQgdGhlIFBBU0lE
IG9mZnNldCBpcyBjb25zaXN0ZW50LiAgQnV0IGFsc28NCj4gPiA+IGlmIHRoZSBWTU0gZG9lc24n
dCBmaW5kIHRoZSBzYW1lIGdhcCB0aGVuIHRoYXQgc3VnZ2VzdHMgdGhlIGNvbmZpZw0KPiA+ID4g
c3BhY2UgaXMgYWxyZWFkeSBkaWZmZXJlbnQgYW5kIG5vdCBvbmx5IHRoZSBvZmZzZXQgb2YgdGhl
IFBBU0lEDQo+ID4gPiBjYXBhYmlsaXR5IHdpbGwgbmVlZCB0byBiZSBmaXhlZCB2aWEgYSBxdWly
aywgc28gdGhlbiB3ZSdyZSBpbnRvDQo+ID4gPiBxdWlya2luZyB0aGUgZW50aXJlIGNhcGFiaWxp
dHkgc3BhY2UgZm9yIHRoZSBkZXZpY2UuDQo+ID4NCj4gPiB5ZXMuIFNvIHRoZSBxdWlyayB0YWJs
ZSBpcyBtb3JlIGZvciBmaXhpbmcgdGhlIGZ1bmN0aW9uYWwgZ2FwIChpLmUuIG5vdA0KPiA+IG92
ZXJsYXAgd2l0aCBhIGhpZGRlbiByZWdpc3RlcikgaW5zdGVhZCBvZiBmb3IgbWlncmF0aW9uLiBB
cyBsb25nIGFzDQo+ID4gYSBkZXZpY2UgY2FuIGZ1bmN0aW9uIGNvcnJlY3RseSB3aXRoIGl0LCB0
aGUgdmlydHVhbCBjYXBzIGZhbGwgaW50byB0aGUNCj4gPiBzYW1lIHJlc3RyaWN0aW9uIGFzIHBo
eXNpY2FsIGNhcHMgaW4gbWlncmF0aW9uIGkuZS4gdXBvbiBpbmNvbnNpc3RlbnQNCj4gPiBsYXlv
dXQgYmV0d2VlbiBzcmMvZGVzdCB3ZSdsbCBuZWVkIHNlcGFyYXRlIHdheSB0byBzeW50aGVzaXpl
IHRoZQ0KPiA+IGVudGlyZSBzcGFjZS4NCj4gDQo+IFllcy4NCj4gDQo+ID4gPiBUaGUgVk1NIHNo
b3VsZCBub3QgYmUgYXNzdW1lZCB0byBoYXZlIGFueSBhZGRpdGlvbmFsIHByaXZpbGVnZXMNCj4g
YmV5b25kDQo+ID4gPiB3aGF0IHdlIHByb3ZpZGUgaXQgdGhyb3VnaCB0aGUgdmZpbyBkZXZpY2Ug
YW5kIGlvbW11ZmQgaW50ZXJmYWNlLg0KPiA+ID4gVGVzdGluZyBhbnl0aGluZyBhYm91dCB0aGUg
UEYgd291bGQgcmVxdWlyZSBhY2Nlc3Mgb24gdGhlIGhvc3QgdGhhdA0KPiA+ID4gd29uJ3Qgd29y
ayBpbiBtb3JlIHNlY3VyZSBlbnZpcm9ubWVudHMuICBUaGVyZWZvcmUgaWYgd2UgY2FuJ3QNCj4g
PiA+IGNvbnNpc3RlbnRseSBwbGFjZSB0aGUgUEFTSUQgZm9yIGEgZGV2aWNlLCB3ZSBwcm9iYWJs
eSBuZWVkIHRvIHF1aXJrIGl0DQo+ID4gPiBiYXNlZCBvbiB0aGUgdmVuZG9yL2RldmljZSBJRHMg
b3Igc3ViLUlEcyBvciB3ZSBuZWVkIHRvIHJlbHkgb24gYQ0KPiA+ID4gbWFuYWdlbWVudCBpbXBs
aWVkIHBvbGljeSBzdWNoIGFzIGEgZGV2aWNlIHByb2ZpbGUgb3B0aW9uIG9uIHRoZSBRRU1VDQo+
ID4gPiBjb21tYW5kIGxpbmUgb3IgbWF5YmUgZGlmZmVyZW50IGNsYXNzZXMgb2YgdGhlIHZmaW8t
cGNpIGRyaXZlciBpbiBRRU1VLg0KPiA+ID4NCj4gPiA+ID4gPiBUaGF0IG1pZ2h0IGV2b2x2ZSBp
bnRvIGEgbG9va3VwIGZvciB3aGVyZSB3ZSBwbGFjZSBhbGwgY2FwYWJpbGl0aWVzLA0KPiA+ID4g
PiA+IHdoaWNoIGVzc2VudGlhbGx5IHR1cm5zIGludG8gdGhlICJmaWxlIiB3aGVyZSB0aGUgVk1N
IGRlZmluZXMgdGhlDQo+IGVudGlyZQ0KPiA+ID4gPiA+IGxheW91dCBmb3Igc29tZSBkZXZpY2Vz
Lg0KPiA+ID4gPg0KPiA+ID4gPiBPdmVyYWxsIHRoaXMgc291bmRzIGEgZmVhc2libGUgcGF0aCB0
byBtb3ZlIGZvcndhcmQgLSBzdGFydGluZyB3aXRoDQo+ID4gPiA+IHRoZSBWTU0gdG8gZmluZCB0
aGUgZ2FwIGF1dG9tYXRpY2FsbHkgaWYgYSBuZXcgUEFTSUQgb3B0aW9uIGlzDQo+ID4gPiA+IG9w
dGVkIGluLiBEZXZpY2VzIHdpdGggaGlkZGVuIHJlZ2lzdGVycyBtYXkgZmFpbC4gRGV2aWNlcyB3
aXRoIHZvbGF0aWxlDQo+ID4gPiA+IGNvbmZpZyBzcGFjZSBkdWUgdG8gRlcgdXBncmFkZSBvciBj
cm9zcyB2ZW5kb3JzIG1heSBmYWlsIHRvIG1pZ3JhdGUuDQo+ID4gPiA+IFRoZW4gZXZvbHZpbmcg
aXQgdG8gdGhlIGZpbGUtYmFzZWQgc2NoZW1lLCBhbmQgdGhlcmUgaXMgdGltZSB0byBkaXNjdXNz
DQo+ID4gPiA+IGFueSBpbnRlcm1lZGlhdGUgaW1wcm92ZW1lbnQgKGZpeGVkIHF1aXJrcywgY21k
bGluZSBvZmZzZXQsIGV0Yy4pIGluDQo+ID4gPiA+IGJldHdlZW4uDQo+ID4gPg0KPiA+ID4gQXMg
YWJvdmUsIGxldCdzIGJlIGNhcmVmdWwgYWJvdXQgaW50cm9kdWNpbmcgdW5uZWNlc3NhcnkgY29t
bWFuZCBsaW5lDQo+ID4gPiBvcHRpb25zLCBlc3BlY2lhbGx5IGlmIHdlIGV4cGVjdCBzdXBwb3J0
IGZvciB0aGVtIGluIGhpZ2hlciBsZXZlbA0KPiA+ID4gdG9vbHMuICBJZiB3ZSBwbGFjZSB0aGUg
UEFTSUQgc29tZXdoZXJlIHRoYXQgbWFrZXMgdGhlIGRldmljZSBub3Qgd29yaywNCj4gPiA+IHRo
ZW4gZGlzYWJsaW5nIFBBU0lEIG9uIHRoZSB2SU9NTVUgc2hvdWxkIHJlc29sdmUgdGhhdC4gIEl0
IHdvbid0IGJlIGENCj4gPg0KPiA+IHZJT01NVSBpcyBwZXItcGxhdGZvcm0gdGhlbiBpdCBhcHBs
aWVzIHRvIGFsbCBkZXZpY2VzIGJlaGluZCwgaW5jbHVkaW5nDQo+ID4gdGhvc2Ugd2hpY2ggZG9u
J3QgaGF2ZSBhIHByb2JsZW0gd2l0aCBhdXRvLXNlbGVjdGVkIG9mZnNldC4gTm90IHN1cmUNCj4g
PiB3aGV0aGVyIG9uZSB3b3VsZCB3YW50IHRvIGNvbnRpbnVlIGVuYWJsaW5nIFBBU0lEIGZvciBv
dGhlciBkZXZpY2VzDQo+ID4gb3Igc2hvdWxkIHN0b3AgaW1tZWRpYXRlbHkgdG8gZmluZCBhIHF1
aXJrIGZvciB0aGUgcHJvYmxlbWF0aWMgb25lIGFuZA0KPiA+IHRoZW4gcmVzdW1lLg0KPiANCj4g
SSdtIG5vdCBzdXJlIGlmIHRoaXMgaXMgYSByZWFsIGlzc3VlLCB3ZSdyZSB0YWxraW5nIGFib3V0
IGEgVk0sIG5vdCBhDQo+IHNlcnZlci4gIElmIGEgdXNlciB3YW50cyBQQVNJRCBzdXBwb3J0IGFu
ZCBpdCdzIGluY29tcGF0aWJsZSB3aXRoIGENCj4gZGV2aWNlLCB0aGUgZGV2aWNlIGNhbiBiZSBl
eGNsdWRlZCBmcm9tIHRoZSBWTSBvciB3ZSBjYW4gaGF2ZSBhbg0KPiBleHBlcmltZW50YWwgb3B0
aW9uIG9uIHRoZSB2ZmlvLXBjaSBkZXZpY2UgaW4gUUVNVSBhcyBhIHdvcmthcm91bmQuICBJDQo+
IGRvbid0IHRoaW5rIHRoaXMgaXMgc29tZXRoaW5nIHdlIG5lZWQgdG8gcGx1bWIgdXAgdGhyb3Vn
aCB0aGUgdG9vbA0KPiBzdGFjay4gIFRoYW5rcywNCj4gDQoNCk9rYXkuIFdpdGggdGhhdCBJIGVk
aXRlZCBteSBlYXJsaWVyIHJlcGx5IGEgYml0IGJ5IHJlbW92aW5nIHRoZSBub3RlDQpvZiBjbWRs
aW5lIG9wdGlvbiwgYWRkaW5nIERWU0VDIHBvc3NpYmlsaXR5LCBhbmQgbWFraW5nIGl0IGNsZWFy
IHRoYXQNCnRoZSBQQVNJRCBvcHRpb24gaXMgaW4gdklPTU1VOg0KDQoiDQpPdmVyYWxsIHRoaXMg
c291bmRzIGEgZmVhc2libGUgcGF0aCB0byBtb3ZlIGZvcndhcmQgLSBzdGFydGluZyB3aXRoDQp0
aGUgVk1NIHRvIGZpbmQgdGhlIGdhcCBhdXRvbWF0aWNhbGx5IGlmIFBBU0lEIGlzIG9wdGVkIGlu
IHZJT01NVS4gDQpEZXZpY2VzIHdpdGggaGlkZGVuIHJlZ2lzdGVycyBtYXkgZmFpbC4gRGV2aWNl
cyB3aXRoIHZvbGF0aWxlDQpjb25maWcgc3BhY2UgZHVlIHRvIEZXIHVwZ3JhZGUgb3IgY3Jvc3Mg
dmVuZG9ycyBtYXkgZmFpbCB0byBtaWdyYXRlLg0KVGhlbiBldm9sdmluZyBpdCB0byB0aGUgZmls
ZS1iYXNlZCBzY2hlbWUsIGFuZCB0aGVyZSBpcyB0aW1lIHRvIGRpc2N1c3MNCmFueSBpbnRlcm1l
ZGlhdGUgaW1wcm92ZW1lbnQgKGZpeGVkIHF1aXJrcywgRFZTRUMsIGV0Yy4pIGluIGJldHdlZW4u
DQoiDQoNCkphc29uLCB5b3VyIHRob3VnaHRzPw0K

