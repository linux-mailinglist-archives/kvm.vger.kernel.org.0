Return-Path: <kvm+bounces-8087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F0984AFA5
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 09:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3B31B22CFC
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 08:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE97012AADF;
	Tue,  6 Feb 2024 08:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i7fygK58"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 306B47E787;
	Tue,  6 Feb 2024 08:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707206969; cv=fail; b=diRwAfthDYXG2PuktD91n2NUk1YftakVQEnZo7YgF/UYRclQOt2lbTrf87kQl4SH3T6nJZ8jnaefVGXPp9Zsx5I53WyLGOBrL2klTe5wt76tt43/yXq0b0FLofeGEPSqcYRviGp1jIo6ItUn0AGNJNR06Cd8rKVKfORrI+lFIc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707206969; c=relaxed/simple;
	bh=qGnpAhVB0UabQXlwMdlCrtEythu8dRwHgc4PLZAeKc0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JMPTVPOTZcN/m0xltQGDpuav/fit60ausHRnVUYukYOU1uMVjS7XHkKwxz4QI1SA8vwDLQldY4tuF20ulgIc65/6QC9Jb+Adf666pmy94Hn5YDxrYbx5/QqJTdJejhnJ0NnyrVM8lqs/vlptpFOP9dWBrC8CJrp6CWMLamBNsbs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i7fygK58; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707206967; x=1738742967;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qGnpAhVB0UabQXlwMdlCrtEythu8dRwHgc4PLZAeKc0=;
  b=i7fygK58KtiGIPF9qWG0Y7KaweToyPzXhgfYt0pDeYy8SBea0Kh10VuS
   jofXJ6xBiBJmvjBE/J5NyXtD+bUyPcsb/ELpPR5jSsFpCX+MyskEcffAa
   3wGf1Zj0qtnVfnVncEPYsow8XL0i+AD/9Lg4EGUq+Y3XcTLPxx4e8z3KD
   WPuqR9Y+1ynxOr37WIcWH5Vc+4So3oRmSH4j9RC7VRrUUtzoF7WUnmesy
   WBiEKk5KK3h50TEGuP3lGMS1dX5lEDChFgp0Tr/AWqs+X/4FWNWtbSJXa
   NLKBWwq3rhxaJz+Gbxko78KzWRtulvWK3rHUh7I63yaC9WJxrNOQEcNh7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10975"; a="577639"
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="577639"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 00:09:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,246,1701158400"; 
   d="scan'208";a="5574395"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 00:09:25 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 00:09:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 00:09:24 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 00:09:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JB5xXVf0SdD2qsHLhqASI4uT2xTXUL/P8qdyjAJf7RnbsybVkCP0dMDCGfNobyMFct8s/trpLzhtxgcPJAl0lB7aTB6UC+fG4/T3j/jtt26qsXcEkaq8OK5sPVB4TurMDhNGd6ZAcpp6Tu2AJ/C1pKaudRm5+eM4GlttGBDiJ2l8apfz0h7wqskd3Y9OOIewuneYx5KJMGKHiam40vR/WXs9h2nowsbyEChw1B3PtjW4/ytzeFjthZvptOMJC0laf/OT8cSb0BRHTP2Wubt6z/aY1/jrvsu7iaLOHHrOd8LbOyCriT3nUQXZ87TnR+v2L18TO9fM31qUzokGwEI3ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGnpAhVB0UabQXlwMdlCrtEythu8dRwHgc4PLZAeKc0=;
 b=EHTLmD3FCW8VZneCbxde3OMVkoSsIgj+JsnGLHS73alAx55a6ku5bkVAZDaEHB2bpJ0ASFAhPxRTE8AanvXejMQLF69pJbKzcDQn0Ybtdu/6XSBLyCyReX+ikd/+8zh3cS5ENaOCd2fbiCXRxDBGtxSOI2dsAsc3rZREMaMjpZtcAWR+GhmEy1m9IuFzYyqZh2oKvzcXbYEdhO1BUBMtljEwfy/juaz/wiRkg4dRJdKHaXPAGn1lDF7yGj7IlE0RkkRRK1yYQViFErik/bckHSYshpbovDNZgp/Dcp1edmONDGG7vhoS64Z5tp+6040wjHT6ONnaleBAYf7zVT8B2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7741.namprd11.prod.outlook.com (2603:10b6:208:400::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 08:09:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::a8e9:c80f:9484:f7cb%3]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 08:09:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, "Will
 Deacon" <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
CC: "Liu, Yi L" <yi.l.liu@intel.com>, Jacob Pan
	<jacob.jun.pan@linux.intel.com>, Longfang Liu <liulongfang@huawei.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, Joel Granados <j.granados@samsung.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Jason Gunthorpe <jgg@nvidia.com>
Subject: RE: [PATCH v11 13/16] iommu: Improve iopf_queue_remove_device()
Thread-Topic: [PATCH v11 13/16] iommu: Improve iopf_queue_remove_device()
Thread-Index: AQHaU1RzuvzbDOxmwk6/Qx3I8sJBXLD7dmtAgAA3UoCAAVJSwA==
Date: Tue, 6 Feb 2024 08:09:20 +0000
Message-ID: <BN9PR11MB52766E912B0FD784C5937D078C462@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240130080835.58921-1-baolu.lu@linux.intel.com>
 <20240130080835.58921-14-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E70CAB272B212977F0C98C472@BN9PR11MB5276.namprd11.prod.outlook.com>
 <416b19fa-bc7a-4ffd-a4c4-9440483fc039@linux.intel.com>
In-Reply-To: <416b19fa-bc7a-4ffd-a4c4-9440483fc039@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7741:EE_
x-ms-office365-filtering-correlation-id: d3292c61-1a92-47fe-9e3c-08dc26eaec04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sg1yDQFGR2wC8oA43uUzXStGiHNUKIVlfDxlwnsc8fwMnauJp/b1jA3hs6b0805L2zv0fn0ZiEU28ma12Xul6wWYLF2gEj1/9SCLkgRqT4ie8UmRZPIabTx15vqjVBr5KoEGdyjEvgozjYBrCAEIGKjnh3qckssXm4++bRLeLmTuawFboRRYH4UsmrSWuOsR9mmqVmr5Gh0lBkYJUdGw+Nhj4KtmDXNg3FEoTUlgXzTpy8Kxfdt+gnMeAwiGngTjQGdXTMcg3nWoW6Xh4NYIhcEe4dn0Jaov9LWfYWHCs4opUVR5JU0yoE2v3kufIgEdu4/SOejLT1DxtGoqAChKiuKPL354HQpltN5n+LnLdLiFVTxqHhjA/tyPjjXviK2PaQjA0hryfyka4UCtDGgjpCs8QDVBgGXgpgmq8BTl41v0DKidgsD/vMs0NNdn6s2zMuqxYnqeoQYi+xXBSipT5ywDPftqEMxFZtANbRL7Qo5BIN9MkyC7fpNA0MwlPO1z6tSRLqyd3EkbeV7pttWZEYYhX7SWKQiCtxDaiEx9lRZmVerKEqnN/AvXhFa5yiYSeaKuNQbBijOkcfwvJRG34/CG8XfrK51Y3VxhDaf8Sm8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(5660300002)(7416002)(52536014)(2906002)(55016003)(41300700001)(83380400001)(26005)(122000001)(82960400001)(38100700002)(86362001)(9686003)(33656002)(7696005)(6506007)(110136005)(53546011)(8676002)(8936002)(478600001)(71200400001)(76116006)(54906003)(64756008)(66446008)(66476007)(66556008)(66946007)(38070700009)(4326008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UCt6SGxtdGFQcTN4VFptZEhLMzRwWmtNdG9FUDZxV2haSXhpL05wQXJWTHNy?=
 =?utf-8?B?Wm5XT3ZYb3M5Vzl0dzNZcXBZMXRlaDZINXV2TVIrWXphdWJZTVVjTXc2dEFC?=
 =?utf-8?B?Z0c3VURxUm5RVDN4TXNyQU44aHpzOE52ZzcvMDNQd1RmVzloOFdhaXViTVNj?=
 =?utf-8?B?c2JKY1dGTjltOFVKWlNabHRRVFVKWlhPTGd4bk1wU2RmN2pTWW5DMjNNZzhX?=
 =?utf-8?B?eVMvQzNzNHE2aWJLMDloZGFKSXY5VGR1M1lFbFU3VU54c0lrZWpYS2NpMmZo?=
 =?utf-8?B?VDFneitCdTRsaXRUWU9nYWpJcEpWV1hhMHQrOFZlK1VpUXJtb09ZNkhHWlYx?=
 =?utf-8?B?ZGVWRG9NcStYN0YrMnorWnBvcXBkaDJGLzAzNUFzdnFzMUhCR0FWRXZxd2FE?=
 =?utf-8?B?MGVlZUZZeUVVRm9KU3pkaUNIZTNQZjJ4bndGTDRsMXM5OCsyaTlWTUkxTGcx?=
 =?utf-8?B?VEFLeFdwRGxFMEdPVWxVcWJYNzBSNW9RTGtaTEFZVld4VmpXcFhQdHhQN1RD?=
 =?utf-8?B?V3lWYUU4dDZiNDI2VjlNRThHLzgzSnpjM3EveUJTZUpCMk9OZE9XWXc2N2F1?=
 =?utf-8?B?blg4VG5hNEtyYnFEU3EwZ21mbG94ai82bCtSbDB2eE9QdFI3VVR5Slh2YlhU?=
 =?utf-8?B?L2FkNzRMdEI1emxVdllFa0lUTUZuS0hEeXhwaUNkNXJYUWRDNDZTeUw0dWFN?=
 =?utf-8?B?d01ZMjhzZ04vYlIrcEpCa3ZsamZEbi8zbklyK2p5ZG9La2pCQWxDL1U1dXNZ?=
 =?utf-8?B?YVJOaUVxWTNVTGg4dEZGOFAxOUowVEZ6M2k0M2c5OHBxRDFYNkV6MEVMYUFB?=
 =?utf-8?B?U1g0bWRScWNoVEVrcDRDc1hWVWt3MVhYRjlUQ3VnNVprOXk5b1hLOWRxNHJP?=
 =?utf-8?B?TDBBOXlWaHNNbWFNRG9COFVUT0dqYXZ1ME9mZUhEamdML1lDb1R2a3hoUjlo?=
 =?utf-8?B?NFkvejd5Q3N6RXRvbjUrSkxxRWFZTXRsTHQ1dDJTOWdpMnpCdzRSbVNLNm95?=
 =?utf-8?B?OUl0dHQ2czAvNFR4T3EzVGtybWVBU1p5UHY4L0NNU1JCM0tjeS9rZjBROExO?=
 =?utf-8?B?QjZLTXYwQ3I1N2xOYzRZUlVWRldCejUyOGNHUTZCWHFYRVJNSFYrVDU0djdH?=
 =?utf-8?B?djAzeTlsRHFNYkQyclAwcEo2aW9yS0JJUUx2aUZMenp4YUd4ZVQ0bWRXZHZZ?=
 =?utf-8?B?WFVObnVuVzhYZDlkU1h3aFlDRzExc2RLWkx0dWJLblVFOFJ0bTYyeDYzU0NT?=
 =?utf-8?B?SlNpaktsZ2tJUVFwUDgzMXl3U050ZVQ4a0xUUlRuTmNaaEF6U0FaaDdEWE1C?=
 =?utf-8?B?THRhZkRoLzZFSEpNYUZGdS9tZU5QWElVSFhFQlpxT1l6QXk1MWQzeHRQTG5m?=
 =?utf-8?B?Q0ZTQjN3SjVINElXQ1FNZ3NxeFFQQ2pQM2ZxL1luOUdjc1dmY281VFZlUCt0?=
 =?utf-8?B?UFJ0bU9aNzliOXl2ODhJaEoxUjhNeUpERUpuZnYwaGFoY2hrWWNCditMVzla?=
 =?utf-8?B?N21tVXcrQjZFWFZTRVVyR0FKYmwxcnQwdFZiWTBBOXlsUk5ZcXpjcEo5YWYx?=
 =?utf-8?B?ek9UT2E4c1lPTWkzdjBUKy9tRDcrYnBBYnhLazAzb3liNnpoVSsxRWNOZk9t?=
 =?utf-8?B?bHIvbjc2ZmxGSkR3TEF0Yit2cXpDVitrNytjRHN2VE1Fc2VoMkZXQUI4VzFa?=
 =?utf-8?B?VFlyc1QyZkxpbkQxYTFQV2RwQTVqY3A2L0NtdmJ4R0ZUY2dPdk0wRjAybE43?=
 =?utf-8?B?TmRBQnNDTno2bTRTRVYvSGhpbnoydzNIRXMrOWxTVDA0QjFMeFVHWnRydFlj?=
 =?utf-8?B?TCtaN01oZzhpRkY4TC9CandmMTdGZUdBaHVMeVB3WnZybCtlN2p3alZIMFQw?=
 =?utf-8?B?a05CcFNjeElXczZtbG5BQldBVHZpd3ZPcjZ0VFJrZ3p4WjgvQUI1dlkyZnNP?=
 =?utf-8?B?Q2FHRDh6N2JNUUY0dlFiTFV0cGhsNWhlcDRUN0dGdVVUMGs5TnlFZ1pqSDRs?=
 =?utf-8?B?MnZaRWg0VWp5NEdwbWY3NFAyOTh1NmVYY1oyY1Z2a2VoWS9YUVMxQjg4b2FS?=
 =?utf-8?B?Y3k2WU45blZFMkpEU2JoYTg0bmtsL2IvL0R0QVN1WVdwUjhodmxYblNEMldU?=
 =?utf-8?Q?R1DD/lO+0HgZvn1ISWEkH5tsr?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d3292c61-1a92-47fe-9e3c-08dc26eaec04
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2024 08:09:20.3177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nQWnNm3TLtpoQmaoHQ9dwV3ebsKS0zK62mJxF1BpKvAQPPh+harDIMEfN47OfKfzl+QuIHIwlDZB8lK75KOkpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7741
X-OriginatorOrg: intel.com

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBNb25k
YXksIEZlYnJ1YXJ5IDUsIDIwMjQgNzo1NSBQTQ0KPiANCj4gT24gMjAyNC8yLzUgMTc6MDAsIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBMdSBCYW9sdSA8YmFvbHUubHVAbGludXguaW50
ZWwuY29tPg0KPiA+PiBTZW50OiBUdWVzZGF5LCBKYW51YXJ5IDMwLCAyMDI0IDQ6MDkgUE0NCj4g
Pj4gICAgKg0KPiA+PiAtICogQ2FsbGVyIG1ha2VzIHN1cmUgdGhhdCBubyBtb3JlIGZhdWx0cyBh
cmUgcmVwb3J0ZWQgZm9yIHRoaXMgZGV2aWNlLg0KPiA+PiArICogUmVtb3ZpbmcgYSBkZXZpY2Ug
ZnJvbSBhbiBpb3BmX3F1ZXVlLiBJdCdzIHJlY29tbWVuZGVkIHRvIGZvbGxvdw0KPiA+PiB0aGVz
ZQ0KPiA+PiArICogc3RlcHMgd2hlbiByZW1vdmluZyBhIGRldmljZToNCj4gPj4gICAgKg0KPiA+
PiAtICogUmV0dXJuOiAwIG9uIHN1Y2Nlc3MgYW5kIDwwIG9uIGVycm9yLg0KPiA+PiArICogLSBE
aXNhYmxlIG5ldyBQUkkgcmVjZXB0aW9uOiBUdXJuIG9mZiBQUkkgZ2VuZXJhdGlvbiBpbiB0aGUg
SU9NTVUNCj4gPj4gaGFyZHdhcmUNCj4gPj4gKyAqICAgYW5kIGZsdXNoIGFueSBoYXJkd2FyZSBw
YWdlIHJlcXVlc3QgcXVldWVzLiBUaGlzIHNob3VsZCBiZSBkb25lDQo+ID4+IGJlZm9yZQ0KPiA+
PiArICogICBjYWxsaW5nIGludG8gdGhpcyBoZWxwZXIuDQo+ID4NCj4gPiB0aGlzIDFzdCBzdGVw
IGlzIGFscmVhZHkgbm90IGZvbGxvd2VkIGJ5IGludGVsLWlvbW11IGRyaXZlci4gVGhlIFBhZ2UN
Cj4gPiBSZXF1ZXN0IEVuYWJsZSAoUFJFKSBiaXQgaXMgc2V0IGluIHRoZSBjb250ZXh0IGVudHJ5
IHdoZW4gYSBkZXZpY2UNCj4gPiBpcyBhdHRhY2hlZCB0byB0aGUgZGVmYXVsdCBkb21haW4gYW5k
IGNsZWFyZWQgb25seSBpbg0KPiA+IGludGVsX2lvbW11X3JlbGVhc2VfZGV2aWNlKCkuDQo+ID4N
Cj4gPiBidXQgaW9wZl9xdWV1ZV9yZW1vdmVfZGV2aWNlKCkgaXMgY2FsbGVkIHdoZW4gSU9NTVVf
REVWX0ZFQVRfSU9QRg0KPiA+IGlzIGRpc2FibGVkIGUuZy4gd2hlbiBpZHhkIGRyaXZlciBpcyB1
bmJvdW5kIGZyb20gdGhlIGRldmljZS4NCj4gPg0KPiA+IHNvIHRoZSBvcmRlciBpcyBhbHJlYWR5
IHZpb2xhdGVkLg0KPiA+DQo+ID4+ICsgKiAtIEFja25vd2xlZGdlIGFsbCBvdXRzdGFuZGluZyBQ
UlFzIHRvIHRoZSBkZXZpY2U6IFJlc3BvbmQgdG8gYWxsDQo+ID4+IG91dHN0YW5kaW5nDQo+ID4+
ICsgKiAgIHBhZ2UgcmVxdWVzdHMgd2l0aCBJT01NVV9QQUdFX1JFU1BfSU5WQUxJRCwgaW5kaWNh
dGluZyB0aGUNCj4gZGV2aWNlDQo+ID4+IHNob3VsZA0KPiA+PiArICogICBub3QgcmV0cnkuIFRo
aXMgaGVscGVyIGZ1bmN0aW9uIGhhbmRsZXMgdGhpcy4NCj4gPj4gKyAqIC0gRGlzYWJsZSBQUkkg
b24gdGhlIGRldmljZTogQWZ0ZXIgY2FsbGluZyB0aGlzIGhlbHBlciwgdGhlIGNhbGxlciBjb3Vs
ZA0KPiA+PiArICogICB0aGVuIGRpc2FibGUgUFJJIG9uIHRoZSBkZXZpY2UuDQo+ID4NCj4gPiBp
bnRlbF9pb21tdV9kaXNhYmxlX2lvcGYoKSBkaXNhYmxlcyBQUkkgY2FwIGJlZm9yZSBjYWxsaW5n
IHRoaXMgaGVscGVyLg0KPiANCj4gWW91IGFyZSByaWdodC4gVGhlIGluZGl2aWR1YWwgZHJpdmVy
cyBzaG91bGQgYmUgYWRqdXN0ZWQgYWNjb3JkaW5nbHkgaW4NCj4gc2VwYXJhdGVkIHBhdGNoZXMu
IEhlcmUgd2UganVzdCBkZWZpbmUgdGhlIGV4cGVjdGVkIGJlaGF2aW9ycyBvZiB0aGUNCj4gaW5k
aXZpZHVhbCBpb21tdSBkcml2ZXIgZnJvbSB0aGUgY29yZSdzIHBlcnNwZWN0aXZlLg0KDQpjYW4g
eW91IGFkZCBhIG5vdGUgaW4gY29tbWl0IG1zZyBhYm91dCBpdD8NCg0KPiANCj4gPg0KPiA+PiAr
ICogLSBUZWFyIGRvd24gdGhlIGlvcGYgaW5mcmFzdHJ1Y3R1cmU6IENhbGxpbmcNCj4gaW9wZl9x
dWV1ZV9yZW1vdmVfZGV2aWNlKCkNCj4gPj4gKyAqICAgZXNzZW50aWFsbHkgZGlzYXNzb2NpYXRl
cyB0aGUgZGV2aWNlLiBUaGUgZmF1bHRfcGFyYW0gbWlnaHQgc3RpbGwgZXhpc3QsDQo+ID4+ICsg
KiAgIGJ1dCBpb21tdV9wYWdlX3Jlc3BvbnNlKCkgd2lsbCBkbyBub3RoaW5nLiBUaGUgZGV2aWNl
IGZhdWx0DQo+IHBhcmFtZXRlcg0KPiA+PiArICogICByZWZlcmVuY2UgY291bnQgaGFzIGJlZW4g
cHJvcGVybHkgcGFzc2VkIGZyb20NCj4gPj4gaW9tbXVfcmVwb3J0X2RldmljZV9mYXVsdCgpDQo+
ID4+ICsgKiAgIHRvIHRoZSBmYXVsdCBoYW5kbGluZyB3b3JrLCBhbmQgd2lsbCBldmVudHVhbGx5
IGJlIHJlbGVhc2VkIGFmdGVyDQo+ID4+ICsgKiAgIGlvbW11X3BhZ2VfcmVzcG9uc2UoKS4NCj4g
Pg0KPiA+IGl0J3MgdW5jbGVhciB3aGF0ICd0ZWFyIGRvd24nIG1lYW5zIGhlcmUuDQo+IA0KPiBJ
dCdzIHRoZSBzYW1lIGFzIGNhbGxpbmcgaW9wZl9xdWV1ZV9yZW1vdmVfZGV2aWNlKCkuIFBlcmhh
cHMgSSBjb3VsZA0KPiByZW1vdmUgdGhlIGNvbmZ1c2luZyAidGVhciBkb3duIHRoZSBpb3BmIGlu
ZnJhc3RydWN0dXJlIj8NCj4gDQoNCkkgdGhvdWdodCBpdCBpcyB0aGUgbGFzdCBzdGVwIHRoZW4g
bXVzdCBoYXZlIHNvbWV0aGluZyByZWFsIHRvIGRvLg0KDQppZiBub3QgdGhlbiByZW1vdmluZyBp
dCBpcyBjbGVhcmVyLg0K

