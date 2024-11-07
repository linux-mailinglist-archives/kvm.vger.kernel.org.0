Return-Path: <kvm+bounces-31073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FCAF9C0134
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:34:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 736491C213CA
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 09:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1B81DFE17;
	Thu,  7 Nov 2024 09:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d7u5eR7j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EB4C2ED
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 09:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730972062; cv=fail; b=TSeAmnj8vOXOn6xs0MnuXpDkhRyOGuvvI1aD4igtITZjTVVoF+KtKn6EwiE+81X9Rvr93HJPMpbUqe59UvRIQleZG7CGja7SmGfdjZwPiDlANCQ94B17bCkML8ckHnL9NIsPSs9PqXNc/B1VXOU66mrLo/Z51ywY/BnocnvnU/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730972062; c=relaxed/simple;
	bh=Enj9UhjXFRLjkizPErnPR49xiAJteB/ngF9zHCcn17M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EjhCsC2s5SbNJnF9lL3/oCb+HjfoLPCidr7ha9MXXQ31L24dqTR+Lp84Y3gGuCq0atbBtBpRCrhylHZHtpfZibVH8qfjZtRqWpgi4Ob3NuEVvtpOX5QCAXvCDKPWlxJfttWtNdLxvjuMOrknFO53n3tuDTa7u2+lU0bPc+h4Lik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d7u5eR7j; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730972061; x=1762508061;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Enj9UhjXFRLjkizPErnPR49xiAJteB/ngF9zHCcn17M=;
  b=d7u5eR7jLLfdmNIcJj914RjU6t9LucK1LzBfqT6P+9ettlB/tA55Gb35
   yl+gaIC1oYeAKJmfi0ZTawdRJLqap8ludGTs6SK/nlcnGY6SOxIVqdPdk
   YDtpLkVM/Uaf5yJKquJVqwmF+U5UmGUbUjIioE/VBd3PeVmTW8KwjVwyD
   lMsi7bxrWNFuFKy2eqNwkaqICUu5w2LtPhFnFYUiDv2/DsUSfYDPMhQwU
   m5Nt6XUVMSV4KsIfuapuUwTSwyb50o/SM+BAllgeGbGVUfojv5VnLSHhT
   hUiHQkM/6fyAVrbirOATeWZ6QYuZpLk3XBTHkBbvw8tileL20H9TrsWll
   w==;
X-CSE-ConnectionGUID: 0Pj80fF4TyOBlqWVbqxztg==
X-CSE-MsgGUID: ME06a/UnRiyw+SeQD8M1NQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="34501893"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="34501893"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 01:34:21 -0800
X-CSE-ConnectionGUID: UZmoOdCrReWcni0zsLpfEg==
X-CSE-MsgGUID: 1D2LVFguStOxVQggmmSZSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="85128060"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 01:34:20 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 01:34:20 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 01:34:20 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 01:34:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l88nbAIKiTZsyQOqfvlhJF3XkfQ7fuxgFRxt2d5X0aIw1dp0PXMK0d/Jd9eQguQ3LCCP0zguZuvem01oyAvRorwbN6MVJeE7N1oMzlZKDYObgdkZwqdXR/cAl2f5GT+TTVnR7c0GqP3ZyiP+6QttbB/6lZDQsSxX1ND3Hq6HfAH34adwwvyyGzHBHZbeqCXZ3SNyASfKh0wmFhlKj5d48Dm6+dKfnREbnhHnac9W49PSTvIsy+tR+mAk1LAJ9rV2X+1NWZz1szlIVuPNgR+1brjuFWVrvcVyh8gswbTktq03+OQXWYSX+Uvv0Ukwp1eFEqPIj+5J6xlyi1aYG18R5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Enj9UhjXFRLjkizPErnPR49xiAJteB/ngF9zHCcn17M=;
 b=OfkILpyMqTVXPhHuDA4iJ1t2NSy5Cql9IHeUM5rsoQZd4MDxCaLaDij7seuVp9E2qQsj09N7Pw0uku7mbJT2zgewmc8SMn63S/lxaQ08Jp5ib2ZzOyAYbRkalKk4NZ6MN/yLJnRP6toXxAHqB02bUSSmERJTIMdt810S2B+cxV0XINJlqJaG0CONl2juzlOGF8z2rAZFDkVC+6fGrgfWlLrE/uu4BgobIQuAwImwiE2+k1K1HAl30texmLg22J8Yg7NLJ47uNwbDoRX+wXz38ObZVhJLgz5gWrSJs9N4OpbicrYRVFsUhAfCf1QlbeahKwpYwd5cMqbHNQIW6QamkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4846.namprd11.prod.outlook.com (2603:10b6:a03:2d8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20; Thu, 7 Nov
 2024 09:34:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 09:34:17 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Liu, Yi L" <yi.l.liu@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v3 2/7] iommu: Consolidate the ops->remove_dev_pasid usage
 into a helper
Thread-Topic: [PATCH v3 2/7] iommu: Consolidate the ops->remove_dev_pasid
 usage into a helper
Thread-Index: AQHbLrxftW2Y/N6jEk2bUUVg4Vu46LKrkt1w
Date: Thu, 7 Nov 2024 09:34:16 +0000
Message-ID: <BN9PR11MB52769A48B33A5F773CCF76398C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-3-yi.l.liu@intel.com>
In-Reply-To: <20241104132033.14027-3-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4846:EE_
x-ms-office365-filtering-correlation-id: 4365cda9-489b-4dbe-5da2-08dcff0f597b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?r4D9Aqx0LKbwSLwtJc0skqrmLrqHL4VQofftgFDJoCzP8vsbfchiMX+ahyWW?=
 =?us-ascii?Q?pj5vDzdiDuw3wCO2FkMkyvMmLlRhQwKSzSiKHa6OpeU/mpnmJRfYBSSyz7eI?=
 =?us-ascii?Q?WMuCcJoL9CTqCOhRsPUIK44TX49tZCBJuL8t4TG/t8N1RDMoFOGzIwfnvJCV?=
 =?us-ascii?Q?HIRZN55he1h/7W7tGDYHF6gijuciKhz4zLWmxMztZRoswsoMR5T4dKLTuV/b?=
 =?us-ascii?Q?BIUOv6+riDd7djP2oPqZY/mTxHEp2Ulhri/15yWsFC58Xdu2OxvYfVFYoLQ7?=
 =?us-ascii?Q?zJNdIBnr+yymmjWN+5iHThHI7Y7sMLngF8bHviS1iR5QL5zkzbHNsGazOV+E?=
 =?us-ascii?Q?GPbE3yLCWWry4tKl+bUu8mFFv3YAkWOmbVJkiq+WwuC4wJ/3699LPCfm2pMa?=
 =?us-ascii?Q?znZH5uLPkNMP49hZZOMCjNQgqEe6p6P6wdWBM87KNQTOkcsSQRpUJK8qBYmA?=
 =?us-ascii?Q?IJfKL6wt+s/Wx5FgFs0810292+fqJ2a/nRjg2O+jb3stR+ofVVaw9rVJx2iD?=
 =?us-ascii?Q?1MFxYREw8E42JJMc+8wcq9VTSn6OhnL7hcb92gL01pXFRbD+SkkwNu0h4tGC?=
 =?us-ascii?Q?oJHypYhyDYV7NiO5yA9e7yc5pyOD+gDa6oNB51sffeDOVqr6Rl3n910Ioq21?=
 =?us-ascii?Q?f64Hfg5efWpunkeRpivAFQz0Z33bZiMK+3BdfkHXCQPExEV2BLrMMM1C2XSU?=
 =?us-ascii?Q?cu0DQBPRNpIZccLMJTlktXPqLaPsYF2Bpn3pmpEy/bDPkJGiOV15MvfJ76JP?=
 =?us-ascii?Q?YhS2nGvlh5aierUEQKiJatzo3oAJLVNAT9+jvG7VM5O7TjgtNWqhtU8a6qBf?=
 =?us-ascii?Q?2qqaKT+hEgkIr0Sw22QUA4A4T4pVCdmzYFUT7t41sBXha4EDRNfX74RswxYI?=
 =?us-ascii?Q?w6drAPCVLdrutd3BcVzaxBishfKbXrASRo0cFkm3onybDzLXWnmPCAZQapxK?=
 =?us-ascii?Q?zYH2TO1ySSO3oGfN0byicBtKMlhhPS+4xvpLnbPWjB6DBjO37Hkp/oX/dsaU?=
 =?us-ascii?Q?OkYGHUTclVecB0QJC5ldqe1vK/o1dmPiLrPzthH0Y7B9e6ip6P2Wf1dkC57I?=
 =?us-ascii?Q?4u0ZQv+CiBT0GvqTMI1xSiQ4RuFqzM/nbfrl8DlIszdUbowKBUoc838aD40J?=
 =?us-ascii?Q?CvKZTvzdeo4tENIbDoD0yVgh9E2y4c9VpedneM/kTYvjUi7Sm2JUYLO8zXn2?=
 =?us-ascii?Q?MfZVFm7DebdvXauRK1ie5yeICuK3C9FZt0EDMHodl7IuqOHvDNNH4ROH2Oil?=
 =?us-ascii?Q?oTDxbdO1BwecNsaFVbcJsUNCXzccQRGJQQ7SQaqkQliWGFBZJJ2pAOcrArki?=
 =?us-ascii?Q?WtcdNW7tNbgiy8v8W4OMv3eQD/GOe8VsTSTaG+hXgKpYj/ksVkcRwqeAFh/2?=
 =?us-ascii?Q?3DamN2c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eCnKwgizXg8Gi5Hqxmxi4U3zMmPlcrgyfvaHGhQTW5Ey4DpJ9n5raMcWR41q?=
 =?us-ascii?Q?wrnY12usClCmSqZ2hFqaL7YN0xC0X2BKfBAOQAUfoRJnFO51yxMTndF+qVIr?=
 =?us-ascii?Q?0pPPW8CsP8B+KVG+n3Wc3e0OJUadB6KZwCxC7HE7VblrOWr7AStvu4rq0jjk?=
 =?us-ascii?Q?VDMuxIWrTxg938C2JlvsK0VwntwrmxS8hP+hMgj7W1jClo+nD/zZCBVVC02t?=
 =?us-ascii?Q?68+KyC9VRUiTxpvyyQbufhIKRGpbgxol0SKhdrGkPtWNmpGd9iYwDV8eJ+lt?=
 =?us-ascii?Q?x/UyUR9XJ15uK2qPHyQBdWvJgSQ/6t+ytINRo8YXE7C7Gbe23jNdjv2CPTcc?=
 =?us-ascii?Q?Rl13Y0ta3EgGA/jReKACSPnh8q7phCMjlz5bYeKilizdHPD6q9qYZ/48tFuc?=
 =?us-ascii?Q?2qHnjaxcmb/AH8OugF4j1Y1DgiZJGdUfhK2Gy6uMsVBc98RafnHUwiE9BD6t?=
 =?us-ascii?Q?7QqIqS702AP63cywlt5oEphJhhPzRS5AI0tj9Nd0UWVfBzA8SNZNJVBRKsn1?=
 =?us-ascii?Q?0+9G2ArUR0tnO3L8gdNRpgNa4lqtTnORvDUHK72bDeaVx9cHiiEch7rB32zq?=
 =?us-ascii?Q?0dg4sMw/ChynNTsismEOGVO+E/KzByUlavTch4ELCbvQAZaaNynATl6DVAmF?=
 =?us-ascii?Q?mXtYiYVdLnRdPFKDsmYJfBqKlRn66Da2OlUSljU0RRMN36aiK+TNpCHgA7DV?=
 =?us-ascii?Q?q6aogN9bf5teVIzWDBbTm4fdj57cKqhEwuaVX5mQM9Ux8S3Azz3RYKouuYYS?=
 =?us-ascii?Q?oVWegyY3DSjB51JXzz6q9DI7outRsYIB6ngLwAnErdni9nMnNob2xq6e4R4w?=
 =?us-ascii?Q?6vB8FCKw8mo8k21nqbeToYpvBcppWBGrr3//rwGCEyLNQjPbsD8d1LR8z3iv?=
 =?us-ascii?Q?I+fDlG6JuJAGZqqKxtTBARYyp2Z9U1lkRtmt+MmUDZcCzkVbcYgO74fjh8TY?=
 =?us-ascii?Q?c/kAJaT3Q3YV7OHWXo62iu+V/DuY5GjAc8n1Y6uTQDtYe9mQs61HkgOuAyxW?=
 =?us-ascii?Q?ZQHO0iW0jtdXoHpGTMXdo5d7ygE/Egs1itKU5Y8y4wZGJlCVO8XG4XSCOGKZ?=
 =?us-ascii?Q?qZEtlQYuEsbxWhDVn8eMKgkFiJlRKb+Ui69Y/m73HLPQ8zfqSfbTuPCj5eoQ?=
 =?us-ascii?Q?yYSOwWrIDm3tQAajS5aqm4ziz5hKc08MCB1TFHXJqGPuG3IwE/nCvwZAvC6e?=
 =?us-ascii?Q?SjfFCA7st3lVY6HgS8D1JbPAoFeCqrFrfRaUAE5YMwfoVFMjUdI9ciaTl52e?=
 =?us-ascii?Q?5PQ9Q5w+QSqPSY6xB/PhNkR7FgliDH1tjJvUSK7Um8rWn4yBlFPDWflkS17a?=
 =?us-ascii?Q?qdGbaGj8JqnWfWj8wQBGXQro3yZ25UY3djs+VFEh969PtsPbijcGBdfLYyWc?=
 =?us-ascii?Q?mX2XYMQ9Dp75DaUb7kOnppd/ByaL3HtvK9GEMUHkyPoiKYmnsWkj1tHaLlci?=
 =?us-ascii?Q?3VhP8sIxkTln45/YROFnm5fxYQjb8gquyZRDsP3TJ5BYI9KjhHnMXRjLmD7t?=
 =?us-ascii?Q?l89jwTfr9whB5lT8uN0Jh35hn8XhQeM4/q09kX8QNEKyMuPzAxoOXOJ6T4lp?=
 =?us-ascii?Q?DnDKrAbamgqoonilRHykXg8XaBEs4qWzvwTJ+Ua+?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4365cda9-489b-4dbe-5da2-08dcff0f597b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2024 09:34:17.0170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yx07Y1LKKMNAPQBRgjo9xBfbZ6UOalGqzItwtUksHXCX1A9HXRYQVJ0lB+VCx+KWAvNrpjLohpreUuCe7IZPWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4846
X-OriginatorOrg: intel.com

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Monday, November 4, 2024 9:20 PM
>=20
> Add a wrapper for the ops->remove_dev_pasid, this consolidates the
> iommu_ops
> fetching and callback invoking. It is also a preparation for starting the
> transition from using remove_dev_pasid op to detach pasid to the way usin=
g
> blocked_domain to detach pasid.
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

