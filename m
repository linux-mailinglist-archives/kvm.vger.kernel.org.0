Return-Path: <kvm+bounces-25116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3325C95FF25
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 04:32:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 579251C219F3
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 02:32:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E32912E5D;
	Tue, 27 Aug 2024 02:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dJAKbceP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A9B372;
	Tue, 27 Aug 2024 02:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724725919; cv=fail; b=kYgUQ6PwqoqkGx/fivsHkBkY+4jHb7lHffW4K3SZhZQy/FffJiEn8T+xwjT5X7eSy6oKMJICJhFP58HSH6eMBLV8lxg5SyhSuw8qxWyWt5AuPCo0KPiSgDDlQZKHXGJZ1WnNy1uY1v25ScwgOqD59sXvmfPvOEFpbPcMoAr8ASY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724725919; c=relaxed/simple;
	bh=+WJ9OKth6xBOueCuQPf33h1rBH0zKeyUbLoPD/U5ALY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GE0bgafYQSwS9VsIZaiPJl2BKsY9voHsrHQolYuvpVN7BgN1gicegNbkl5rLH0vKkA+JTRJNY7FZrvOiSv1WIHRctguYCLYBd9s/OzF/KSJohQu4rkH4dh+1foWaygBJ5sFQ/ftsLfZCczSUrocjJXRB0QnyDa8yArXM0+klEHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dJAKbceP; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724725918; x=1756261918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+WJ9OKth6xBOueCuQPf33h1rBH0zKeyUbLoPD/U5ALY=;
  b=dJAKbceP9kO7iBhOeYiWECvPRw0UPrtGK2SI4CUIYNhzxXzt8qzSY0rP
   LdwDghd6lGUusRIsFYb4gTXOBj8JL1Xnjp1K/pD69YmP9ztr696U4cCzh
   /k2WzNkMQW6dAy+NTmP47rRo29hMUJ/ukP8D0sgaXaLA2I4YoUi6vDQa0
   X+4qTTiXPin2pMqoX/FjUnpwEh8w1Dj/N44Av27y7EqS7hTQ+XgF7+b8K
   UFbiv3XS2ZTBCC+H6jBjT1AqnviRLbj9aWp5xFEI8uEbtOUVrmeU7WPnL
   jfLVlWSWXdt6azs/HxXhUe+cLwWiZcsSctz6FDG/z30JGIAxwRhW+AAU4
   w==;
X-CSE-ConnectionGUID: mlJhgXjDR62R2pofjvsbaA==
X-CSE-MsgGUID: OHhVhaweQm2fG6LX27kL5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="23342989"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="23342989"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2024 19:31:34 -0700
X-CSE-ConnectionGUID: 9Lq65Ir/SDKUZIns6STl9A==
X-CSE-MsgGUID: O3eeOC9kST2ajZtCIiSaNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="62543414"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Aug 2024 19:31:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 26 Aug 2024 19:31:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 26 Aug 2024 19:31:33 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 26 Aug 2024 19:31:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v06QbaKY06CdSVXeiShTQ1ISbwNBwOaGL0PEzaQPBKsHRp/HfMoZx4r54Wbfiw1qnz8/tSvQtNVkaI0Eqo8+j5/g8Q+BC8jxsn/Px2LJeDFRX+ot7kJyAo44WsyIRfOx1G+c6JhVb21NcWkQEFEEl5qcSz+KZS99psAUXrpe7PPnK8KbIkR31KnsDEI0jJxkMKyEF4cLb2yt4UjiIfxIJORq1cGfB2J0rRozY6uKpL8u/uFwxCbm7Zb0GuCxP3lZh7hF8yhvzPcoWeVY7tNgKk0wISDudW0s1qZXl5eENAacUQGNJHF42vZCNGL1UBsGQNxvLGztlVOsQvyVTsUeZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+WJ9OKth6xBOueCuQPf33h1rBH0zKeyUbLoPD/U5ALY=;
 b=JmVn6ohh3ioSECUdDPIJ+nkf0dVeSkj97/Tps0p8a5ThVyxmZBG+Pp+4ho361sEQyu01KyVGr6Vm+ZeJ0bFtvl7KtGFbLJp8VlUSi4sRa1TB2J/Irgb0hSMs4uxvw4dCi8RO0TzZK66cVz/t46LtAre3n7fOAj2iCGcGCBy1Mu18PORFzWEziCAfVr7fpsI90CXBnAfnZehwz/PfY2pwrlTh+w7ozOKH1me0olsEjeH54Z+suoyIUEZ6fTklIxzlJpHTZrw3sMMsfUIWsJL34nUbz9nN9W2mBqG13gi0WZ7qo/l0PFv3yo7pwygI5ePI9ip2RrE45gVegzgaRI5wig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4957.namprd11.prod.outlook.com (2603:10b6:a03:2df::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 02:31:28 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 02:31:28 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
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
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Jason Gunthorpe
	<jgg@nvidia.com>, "david@redhat.com" <david@redhat.com>
Subject: RE: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Topic: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Thread-Index: AQHa9WDSA4/jzf2jak2pyUws2LsQ4bI5OEgwgAEuU4CAAACT4A==
Date: Tue, 27 Aug 2024 02:31:28 +0000
Message-ID: <BN9PR11MB527602D9A20BE8B60AD6B7E08C942@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-13-aik@amd.com>
 <BN9PR11MB5276D14D4E3F9CB26FBDE36C8C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <477f3f50-0015-46ea-96c7-dae0971f9fc6@amd.com>
In-Reply-To: <477f3f50-0015-46ea-96c7-dae0971f9fc6@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4957:EE_
x-ms-office365-filtering-correlation-id: ecb19417-ff9c-42eb-c71a-08dcc6405ad5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RlB2QXdRNVpxU1F0elJGdWJucC9lYkpSOTFzTlJ1M3BjbGpHZGxROXdCeXJL?=
 =?utf-8?B?bjQzU1FLVlhwUEVLMG05Z0NiYm82VTBRc0tDNUNIZjhQTWlVRHNGWjBuc3lK?=
 =?utf-8?B?SlpPQ1JiVUp2MGRBRjQwaEVvMEs1dlhPTVlaVFg4aStPbjQvWUhRNWpXTnBr?=
 =?utf-8?B?RmROSUtqMzYweHFNYk9JQ1Z0elBheWF4bDh5dUNlZ2RueDRGK0EyRTV1K2FF?=
 =?utf-8?B?ZFl5WW9qcWJ6SitnSlpKNERoV0IvdDVtMzBKQ1YvUWdxd0FkN2xCR0pwWG1X?=
 =?utf-8?B?Q2R4OUZvRndZYnRUZFlhVDJqUkVEVjlJYTBza0pDdkNHdUNBa29jK3FVOTVt?=
 =?utf-8?B?QnpEUVk0VjFSbG5jdDhRLzh5aGZSMnZxbWJ6VzVGNWhlNEFCSlZQT1lQTjNl?=
 =?utf-8?B?NFEvd1NRWDdiTEI1WmFUeEo4OUgxTHd0K3Yyd1RQRkZzSHJXSm82U1FzZ2k2?=
 =?utf-8?B?ZTl4YVduVWs2cTl5Zm1DcUZSb3Q5ZmVGWEsxRXluVW50bW5qVjFLU0o2cGpI?=
 =?utf-8?B?RUdzRTluSHBHa2szNGFidE9NQ202dVJCblFqMDRNcmRMbkRIcDRIOUFYcWJq?=
 =?utf-8?B?TTlFNHkxQ0pLVzRlTllUZFhLSHRtSGZmOURvMUIzV0w1VVh4VnRPNWM0aWZp?=
 =?utf-8?B?VEhWa0JDb0lDWTlKdURjWXRwMDV2ZHMxTDhFdlpUWlowQlM4M2c2Uko2ZURE?=
 =?utf-8?B?bUVoOVZRcUVlUFJWcEQ0dTJEZkU3SjVhTHAvWFplcURMUzFTYVNmLzl0dUtB?=
 =?utf-8?B?dzQzRFQyZGpCcTJOM1Y4cXBnYk16YkthRGdPeDFCazRnTkczTFFQUEJJeWNi?=
 =?utf-8?B?a1dNNDhDV3IrYnRaRVkwM0kvaEdPZDd6T2g2ZkFHM2x3VEVpcmE4dXo3enAw?=
 =?utf-8?B?SHNoN29DbjRseFlZSnJRemwxc0NiQVVHc3lBNTEvc0xYNnJod1p0M2pIMW5i?=
 =?utf-8?B?cW5WR2dwK1BkYXFmeWFXdW1FRDNwbTNDbzBZUDJ0dGpmczBqQVF3NFFHUlVn?=
 =?utf-8?B?RWttK1dmOGRYZmQzeHh0dWlvV2lEWkVmQU12K3VBdHV4Ylg4K0pjRzI0UGIw?=
 =?utf-8?B?ZENDRnRGVXlHNjMxUU1BZGcrbDd1Q0dWTlZLVCtCYk5yb0kxUWFSZVVFazNh?=
 =?utf-8?B?UDlqbk1ULzhjcVhUVWRGV2NNeklBOStYMXFFNDluajYwZnR6RlErNURndnlE?=
 =?utf-8?B?bER6cko2Qnh6L3dNeVRRN1hDNTNYTkEwYTFrRzBZb0RDYVVuNC9PNy80ZGY2?=
 =?utf-8?B?K1pjVWpPNU84bDVuTFUrd2pveFZUWE40M0ZRYm5TWUsrMU1BMTU4Vzg0bFZ2?=
 =?utf-8?B?bXhjbWMxczFteFdEMzBUcGtsa3ZoRXBNNGdJRGE2U1JXNmVQNURRZWtFMW5w?=
 =?utf-8?B?WUpsT2kzWG15S2p4UjNsYWtoS3dncHJxYzg3WktzQjZ2L3hNQkJNYnd1K21r?=
 =?utf-8?B?ekdpMjBKZE04SkJDVXozTmRMS1M5TFZhNGRHNWFmanNEK3Z1RVNiajBwWFFi?=
 =?utf-8?B?OXRjWjBEVG9yZ0RONjZuRllwc2tMcHMrZWtoU01KNzVVN2FERXAvL2pNY0xR?=
 =?utf-8?B?Q3Bud3cwVDR1RHNrUzNrSTF3UHRaaU1MaWZ1TVB0T1pCQTFBWlZrODgyYkRo?=
 =?utf-8?B?aUljWXgrQ21VREdSQjlDNERlcDQ3NlhQSE9JTk5rZ21LaERMaHowRTkwL3dR?=
 =?utf-8?B?cUxJbkRFQTg0ZkhpTGozekJ0dlAybktLQXdKQk5QSERnK0RWa2hnTVY1Rjc5?=
 =?utf-8?B?ZWtDOFhudEduYjBKTG9ITW05eUZoc0hWTTdvcGxTM3NRZmtoTE1UUHJSZUlr?=
 =?utf-8?Q?PSOHT+ugEdWHPA54mhihqYHk1HIvQntYz6EuQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGNXVEhiZG04bjFZdTIzd1Fyem5MVi8xa1FIcW1jN1BrWXNMRGt1NlZTbEts?=
 =?utf-8?B?REV1cFB6R1dHbXg1azdYRU9kZS9Ed0ZjVjJPdkRMYm9SUUF5S3RsNGRKTWgr?=
 =?utf-8?B?aDNzQ3pGanM5aDRXd0E0Y1dDeENKMnhmZVV6OUhUbFhOL25USUVvbG52K29v?=
 =?utf-8?B?K01KZno3ekhoS1dMMFR5dHk0clJCMnJMTm9qa2ZOVjUybzcvb2NROG1meXRE?=
 =?utf-8?B?YjlueitHcndMSTRHR3NuRWN5L2k3RlV3bmQ2MjBKbXJOcFZYZTIyTzlFamFx?=
 =?utf-8?B?NlNQU0R0ZEZVRUYvMVgyZGtCelMrNUp0enhmSW5UTU1RWDNqeW5HbkRLcjd1?=
 =?utf-8?B?U3hmL2c3RGE1NEdESmg5UElMZlpWU255aGVPNjg5QlpoYXdRR29uSGJaSEF1?=
 =?utf-8?B?R2o1UnZDRmEyRUV5OWVZVy9Qa05XT0RKeit1dmVXZ21kSWhXSllkZE9rbERU?=
 =?utf-8?B?czdKcmlMZHJxS1hrcS9WTWVpQi9BTXRFQ1RkMDc2c2dXNDVLSmFaNmJBMlNl?=
 =?utf-8?B?MUZybkRJY3FHTU81UmgzSUo1TWh6aWYxZmo0eXlpK083WTAwNW40dStOemY0?=
 =?utf-8?B?Q0FGYm1KMW1VTWpTaFRvcSs2bGxQbEhlSzBtVkRPUk9UbkxYQnNJQlZBblli?=
 =?utf-8?B?OFNPcTVqTHhGZ3JyOHJvWnBEcnhjbFZ2TlJJUFIraEhZdzc0ckd0SUhmc3lM?=
 =?utf-8?B?SVJNdEQxZmx4TXpqR1ZLRE0zMGR5UkxOck5qSzlva2JXcTMreGMvd1dBWXJZ?=
 =?utf-8?B?bVNwUWdPa0srS2R6SjZsSmpFOFZ4cW90alpCNG5tS3FSSXNWQTBZaTE5enIr?=
 =?utf-8?B?SFFHYkdSOVNpNTNldFhjWjJMdWZ1MURFbWpxeHFSRFlIVnpRdXBpbFlIOHFi?=
 =?utf-8?B?SGE1TUdZVlhFb0pQVG9DcnU1ek1POEpzM29xSnd5YXgwdzQ0NWxPZ3ZEWnhZ?=
 =?utf-8?B?QmgybWx4bW5FWFFHaXdTb1JqZ2RBeEdPODJrRjI4RVphZEYxMW5qenlBWWhU?=
 =?utf-8?B?MnpoNzNRSjBDSWdOWWdKRTVmUWpsYkV3eTRKb3lYSk5mMVZMZXBuMjFOajg0?=
 =?utf-8?B?RWZTUTU1cVpPR1Y2bFFmcWVuWURHRy9QWlpUT1dhRHBVeWhvdGcvU0RWZFM0?=
 =?utf-8?B?Ris0M3ZnbDBMalZoN3l0a3k1b1VNU00wUXJnK09VeUN0K1o0VHZ0YVZFRnFC?=
 =?utf-8?B?T2h0ekRkbWNSb29ubU9yRUR6OU1DTTNaNFQxSndtQU5mbitGaHdYeis2ajBI?=
 =?utf-8?B?UDhoNXhiWlNjUFZZSlpMQTk5S2JjRWVFd29oR2NSZUwzcWtIMG9OOGFTYko1?=
 =?utf-8?B?QXgrc0Q0eVdTZ1dXK1dkSXRiNEFucVhSL2ZNQ05lZTJULy94WUtmQW1uYSsv?=
 =?utf-8?B?WkVtWXg3QVFWUFlpeDVLUUdMQTZPTjBOMzdaVHg3TmtUSHkzOEYyTDRzeWw5?=
 =?utf-8?B?MjJvazBWYzhINVBRTEN2aiswcDRjM0VORzVsMS8rRVV2MEdZQTRPTHpCbjU4?=
 =?utf-8?B?QlFoWVpYU2hWMUEvWDRSaUJkSC9XVFZQbm11K2xXdEZRWkZLc203a1JSbVNp?=
 =?utf-8?B?dkcrRHpYY3dBS0NubXZUeFpHUnNPUUZRRkwzb1o0MUIwRWI2SXBjenFBcWlj?=
 =?utf-8?B?enpSLzJQSU9GK1ZWelgyd3Qvc1pXdUk2ekVacEpEREdTOVlkUUhkQVpmbWNt?=
 =?utf-8?B?UjlOd3RBN0NuVzQ3NVA4QjZYNEsyQ293eEhEWlJCQnV6ZnVVZlE4M3EybHVF?=
 =?utf-8?B?NVlGRGdBWjU2Q01kbmcvVlFMTnJQNjhmeW5oeGRPdUJQMXBqdjZnTUlhREpw?=
 =?utf-8?B?c1ZyZmY5V0tPU2Z4NW9HRnhPdjNPUHo0emR0VENUbU83cUVqNm1vZWJXMnBE?=
 =?utf-8?B?b09STFo1am04WnNoNnhlblBMYkRDeXFLU1J1SXJrVUV6T2ZHV3JLWVUwTWVP?=
 =?utf-8?B?RU9wSUtZV0JobmZGWkt1clZrWnUwdGpqc1hYbTBNZEZqNHdsRnlGNnUvaDAv?=
 =?utf-8?B?VW9pdlMzZG55SDI1YUZiRjI1WUhnNVlhMURGa1pxbGtORWF4M0dHanc4UzZ4?=
 =?utf-8?B?VmlOeGlvY09xTlhHVWF3OHdqYUYrNTBEczFCZ3RZeFBNR1hHajhYeld6RHlz?=
 =?utf-8?Q?X5P28RU2Etq6/d0sBMpb/iyfw?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb19417-ff9c-42eb-c71a-08dcc6405ad5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2024 02:31:28.3604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QhgnJOckQ6QqyOxognwX+a6mVYPvimME4X+757xfSw0odBYap5PreotUFmXHtQj7ymIr7Shb2cjTKaeJnpuzqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4957
X-OriginatorOrg: intel.com

PiBGcm9tOiBBbGV4ZXkgS2FyZGFzaGV2c2tpeSA8YWlrQGFtZC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIEF1Z3VzdCAyNywgMjAyNCAxMDoyOCBBTQ0KPiANCj4gT24gMjYvOC8yNCAxODozOSwgVGlh
biwgS2V2aW4gd3JvdGU6DQo+ID4gK0phc29uL0RhdmlkDQo+ID4NCj4gPj4gRnJvbTogQWxleGV5
IEthcmRhc2hldnNraXkgPGFpa0BhbWQuY29tPg0KPiA+PiBTZW50OiBGcmlkYXksIEF1Z3VzdCAy
MywgMjAyNCA5OjIxIFBNDQo+ID4+DQo+ID4+IElPTU1VRkQgY2FsbHMgZ2V0X3VzZXJfcGFnZXMo
KSBmb3IgZXZlcnkgbWFwcGluZyB3aGljaCB3aWxsIGFsbG9jYXRlDQo+ID4+IHNoYXJlZCBtZW1v
cnkgaW5zdGVhZCBvZiB1c2luZyBwcml2YXRlIG1lbW9yeSBtYW5hZ2VkIGJ5IHRoZSBLVk0NCj4g
YW5kDQo+ID4+IE1FTUZELg0KPiA+Pg0KPiA+PiBBZGQgc3VwcG9ydCBmb3IgSU9NTVVGRCBmZCB0
byB0aGUgVkZJTyBLVk0gZGV2aWNlJ3MNCj4gS1ZNX0RFVl9WRklPX0ZJTEUNCj4gPj4gQVBJDQo+
ID4+IHNpbWlsYXIgdG8gYWxyZWFkeSBleGlzdGluZyBWRklPIGRldmljZSBhbmQgVkZJTyBncm91
cCBmZHMuDQo+ID4+IFRoaXMgYWRkaXRpb24gcmVnaXN0ZXJzIHRoZSBLVk0gaW4gSU9NTVVGRCB3
aXRoIGEgY2FsbGJhY2sgdG8gZ2V0IGEgcGZuDQo+ID4+IGZvciBndWVzdCBwcml2YXRlIG1lbW9y
eSBmb3IgbWFwcGluZyBpdCBsYXRlciBpbiB0aGUgSU9NTVUuDQo+ID4+IE5vIGNhbGxiYWNrIGZv
ciBmcmVlIGFzIGl0IGlzIGdlbmVyaWMgZm9saW9fcHV0KCkgZm9yIG5vdy4NCj4gPj4NCj4gPj4g
VGhlIGFmb3JlbWVudGlvbmVkIGNhbGxiYWNrIHVzZXMgdXB0ciB0byBjYWxjdWxhdGUgdGhlIG9m
ZnNldCBpbnRvDQo+ID4+IHRoZSBLVk0gbWVtb3J5IHNsb3QgYW5kIGZpbmQgcHJpdmF0ZSBiYWNr
aW5nIHBmbiwgY29waWVzDQo+ID4+IGt2bV9nbWVtX2dldF9wZm4oKSBwcmV0dHkgbXVjaC4NCj4g
Pj4NCj4gPj4gVGhpcyByZWxpZXMgb24gcHJpdmF0ZSBwYWdlcyB0byBiZSBwaW5uZWQgYmVmb3Jl
aGFuZC4NCj4gPj4NCj4gPg0KPiA+IFRoZXJlIHdhcyBhIHJlbGF0ZWQgZGlzY3Vzc2lvbiBbMV0g
d2hpY2ggbGVhbnMgdG93YXJkIHRoZSBjb25jbHVzaW9uDQo+IA0KPiBGb3Jnb3QgWzFdPw0KDQpb
MV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjQwNjIwMTQzNDA2LkdKMjQ5NDUxMEBu
dmlkaWEuY29tLw0KDQo+IA0KPiA+IHRoYXQgdGhlIElPTU1VIHBhZ2UgdGFibGUgZm9yIHByaXZh
dGUgbWVtb3J5IHdpbGwgYmUgbWFuYWdlZCBieQ0KPiA+IHRoZSBzZWN1cmUgd29ybGQgaS5lLiB0
aGUgS1ZNIHBhdGguDQo+ID4NCj4gPiBPYnZpb3VzbHkgdGhlIHdvcmsgaGVyZSBjb25maXJtcyB0
aGF0IGl0IGRvZXNuJ3QgaG9sZCBmb3IgU0VWLVRJTw0KPiA+IHdoaWNoIHN0aWxsIGV4cGVjdHMg
dGhlIGhvc3QgdG8gbWFuYWdlIHRoZSBJT01NVSBwYWdlIHRhYmxlLg0KPiA+DQo+ID4gYnR3IGdv
aW5nIGRvd24gdGhpcyBwYXRoIGl0J3MgY2xlYXJlciB0byBleHRlbmQgdGhlIE1BUF9ETUENCj4g
PiB1QVBJIHRvIGFjY2VwdCB7Z21lbWZkLCBvZmZzZXR9IHRoYW4gYWRkaW5nIGEgY2FsbGJhY2sg
dG8gS1ZNLg0KPiANCj4gVGhhbmtzIGZvciB0aGUgY29tbWVudCwgbWFrZXMgc2Vuc2UsIHRoaXMg
c2hvdWxkIG1ha2UgdGhlIGludGVyZmFjZQ0KPiBjbGVhbmVyLiBJdCB3YXMganVzdCBhIGJpdCBt
ZXNzeSAoYnV0IGRvYWJsZSBuZXZlcnRoZWxlc3MpIGF0IHRoZSB0aW1lDQo+IHRvIHB1c2ggdGhp
cyBuZXcgbWFwcGluZyBmbGFnL3R5cGUgYWxsIHRoZSB3YXkgZG93biB0bw0KPiBwZm5fcmVhZGVy
X3VzZXJfcGluOg0KPiANCj4gaW9tbXVmZF9pb2FzX21hcCAtPiBpb3B0X21hcF91c2VyX3BhZ2Vz
IC0+IGlvcHRfbWFwX3BhZ2VzIC0+DQo+IGlvcHRfZmlsbF9kb21haW5zX3BhZ2VzIC0+IGlvcHRf
YXJlYV9maWxsX2RvbWFpbnMgLT4gcGZuX3JlYWRlcl9maXJzdCAtPg0KPiBwZm5fcmVhZGVyX25l
eHQgLT4gcGZuX3JlYWRlcl9maWxsX3NwYW4gLT4gcGZuX3JlYWRlcl91c2VyX3Bpbg0KPiANCj4g
DQo+IFRoYW5rcywNCj4gDQo+IC0tDQo+IEFsZXhleQ0KDQo=

