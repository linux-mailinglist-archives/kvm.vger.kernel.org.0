Return-Path: <kvm+bounces-35456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F11BBA1140F
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 23:28:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 469E17A21A0
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 22:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FF17213221;
	Tue, 14 Jan 2025 22:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B2NdRkkX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A684644E;
	Tue, 14 Jan 2025 22:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736893690; cv=fail; b=Z8CgvoWyStynZNQ94PMrKjAPTUSR2wZJ+/Kr1z4Hnp7av+7lUUPXxt6fdvDMYb3K30QWHyD0GTrLO32NgP247CTKmQf00mn0MD1GCU+fErp3tEOQn7lLoothM4NqZ75zSp1Dsh3eyfu9v3D+6qW0KSCXrwgAA762SfX4AC8Emic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736893690; c=relaxed/simple;
	bh=zGEJIkpdbHNk4kUD6W1VhDS7W2CJ5K4xG+w5J+RVwUA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MiKbtoDa7PGOZ7yZjeQYfhhiWizmf3LtsgtFy0i4g8xgy2TMeu38bn+V6vz+Q9sE4TbuGt/lQP9YEVvcOkyr4KLNiB3Q+nP7/v3cK1oCCkjbnjEY6+OXEjWFH7LAi/a/8l150x6xe6w8OaIhQKnIhAltaD7YlwNuKzr/O+woZu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B2NdRkkX; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736893689; x=1768429689;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zGEJIkpdbHNk4kUD6W1VhDS7W2CJ5K4xG+w5J+RVwUA=;
  b=B2NdRkkXxbApXDMFyVY4gX/Umq8r3PZqnbUH2AYsith9dzrPiIHLQk3b
   ab7hq0Rnj9skGXnYt7zGN2OBizdSFRN+TyyW27FrzYVTVpwnjyRWSERH1
   eGxPuwvsUCljRxsco4JDo19SOhaB9tTpmB7EH1ewZIWoO060oJ0RdLQAa
   UapY1/cPI2QLELxrA9g36zMcxWPjJ4UKTaUxDiWw5l8VE7L9LQFJTBXi9
   YMX50I7E4GJ1qkDmmGKECco1FN8HT0+iy40YFT20fHvHokkiCxE2a1isL
   Vg7+Y8AU2ZRUXPfgYjUH/zAW/t8zVUfTlRenuSJmQx5CfNIgPZchOopsk
   A==;
X-CSE-ConnectionGUID: qjjLEjyeRrG1VHEAv8Rk9Q==
X-CSE-MsgGUID: ivkE7Kb1SGesOGDYcVuEQA==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="40020546"
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="40020546"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 14:28:07 -0800
X-CSE-ConnectionGUID: majcuxUGRdy2tDn26zH5Uw==
X-CSE-MsgGUID: L0P3nZS0SH6qKnEPc5hvIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,315,1728975600"; 
   d="scan'208";a="109913375"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 14:28:05 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 14:28:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 14:28:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 14:28:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BoZnxSsWb0q7Fs4lvYU6m+v8oOmX7/+Fhm4CqtMlawaXlijw+5cVw/zihnJavnExafhNO2UVygYNQGeYn+5ebFkkIfRPq3I+KEykmrBtgPFC358Hn/Eg8vSaaQSg1WDiGY5LSH/kSL6diILrYynpRXf/QEo34SPoPy2Y1aKwv+g6wF39k8rJ+pwI/edAHLZ1L6/3HsjNuASxCu1ccaiMoWZe6NpzxnSzLnErSFwcFJ41FwQfyjb1IHNAPVPYiQwpvMYc/SPDp4kEgZp14BjCVSX1iCpXRe8pCnVvdNVK3eKHTaQ9I9eHpUBRueumq36XKe5ai15mPuxMJI2ppKHACg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zGEJIkpdbHNk4kUD6W1VhDS7W2CJ5K4xG+w5J+RVwUA=;
 b=R/1v/TqeFSBTsXvwgoppZQDVt1cE81BvNeQrx5JXyP75LlQroKGxdBHCKhgdf5COsabvbKGKZT5wqkmAlnPrsVBD6nu6abhuDWxQxzxins1FwIsJ+TgZQolmSSpOdPIK2LCEFiSYqphBZPnTy7U+GMdD6fy9zJNQnkAa5QUzPW35lpLn+oOcVDyslQqt+ZfOGSDsG8bN463dx/+hh3DMIEdVLv0sAdpP//5u6XZ7D2aQ4vIdhl72Gd8sK6us5NhkoAWlBOBfqQUxH7fh8TlQfJZX8mP8so8UdwG4V5ylcSOcHYT5de2FpZRB2UVKyJJyZvAF+x99xurGPB/4HzWJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB7701.namprd11.prod.outlook.com (2603:10b6:a03:4e4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.18; Tue, 14 Jan
 2025 22:27:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 22:27:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren,
 Tony" <tony.lindgren@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH 0/7] KVM: TDX SEPT SEAMCALL retry
Thread-Topic: [PATCH 0/7] KVM: TDX SEPT SEAMCALL retry
Thread-Index: AQHbZWBdQBp1IyKDLkaCY8BX3TBz3LMW3F8A
Date: Tue, 14 Jan 2025 22:27:59 +0000
Message-ID: <603be51644f179d0f9ece1cd35e8a744ffe21b6f.camel@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
In-Reply-To: <20250113020925.18789-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB7701:EE_
x-ms-office365-filtering-correlation-id: 0fb4141b-c139-48de-18bd-08dd34eab34a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dldONWJXUitReEh0dzlKbjBHSitqbGVXNGkrR0g1N1IyR0tMN0xxUUs4NThm?=
 =?utf-8?B?bFNvUlNXYVBMMDZWb2pOMUlWSmQzLzZSeTFZTkI2WFh2QSs2cXhsT0JBNGZ2?=
 =?utf-8?B?YVJsZUlrY3RkdVV5UEY3cnBnTkFlWWFhNnZiNXdNcWY2dENWZFB2VUd4UEt3?=
 =?utf-8?B?cVdaYVV3YVZ6dU1RZU1yUVVkb3VvQWFmc080b3JNWU5iVERDaU1ocU1maVgz?=
 =?utf-8?B?T21TdmUwL3p5SjlUb1JGRVdoU0ttR0RvU3dQUkF4L25WNnVxK2srclFlemxV?=
 =?utf-8?B?bXVnRlZ6YkdEV28xYXZoMGlpbm1zVWZUMUZ5SkhPa0p0WlIyTnBxbU81UzZt?=
 =?utf-8?B?THhlb2JMalZRQlVDWGh6S29GSnFRVFp6VEdwS3dtSUFXaFBhL0xGcGZ5Nmov?=
 =?utf-8?B?Y3J6OU04ME55VW9wMTFWWFZ6NnFyRXRwYmMxWkV1L1hlN3I0anFncXA1U1dw?=
 =?utf-8?B?c05vMTBqYytTcFpxUktPQ25SVDhoL3dhTnBPaEt6VVhjTldvVkQyMnErQ3ZY?=
 =?utf-8?B?U0ZETGVENmVMM2F4TWdVZFBmOXFqUGVZSDdWMzBkbGJyYTNJeXBGbFNVRDcw?=
 =?utf-8?B?K3pyZnVDTUY4YVh6MDZlYjlndzFNSlZwL0JjNE5ocWZuVVkrVTQvTGhBMnR4?=
 =?utf-8?B?SUlnM2ZtVUM1WmJVT3ZXUkw2VkJOa3ZqdG9LcUF6ZGRSa1FZNmtha3kvZ3RM?=
 =?utf-8?B?Rlh5MjZ4RzJSQkIxaXBxK1M5WHhaUUdqTlBCMi95L1VhdHBieWN4Y0VPRGZj?=
 =?utf-8?B?REFNRG4wS0djbmlhcndVK1FOU0VrOWVSZUk3UktzQXRhS2U5KzNkcXhpRW90?=
 =?utf-8?B?TG5zOTlsOHdMTGxTdzJhMjI5aUsvYk9MUjhDb3lMSThSZmQzSzlBOFV0clFL?=
 =?utf-8?B?ZmFmNzV6NWpaZjdSRlJ2ZCtaZ0dwK003c3FGenBxSGxZL2c3d0dVOXhNUjN3?=
 =?utf-8?B?aEFiZkNpRjJDUjlFS29oWVNXUWJjOWVNYU1IUm1lcE5aSGhTMlVmakYwamxa?=
 =?utf-8?B?NEk5S3I0VEpNbDRhMGJrTUFLZExXY3E2eDFUUDdHTEE3WTYzbFhQWGR2WXov?=
 =?utf-8?B?R3Znbm9YOEZvMDNja1ZncFB6SGFTeUN6anpNb2RiUWJZa2ZhZEFROTI3Y1hS?=
 =?utf-8?B?cy81Z2hXUVRkRDcyMkFuaWFQN3dQYXFabFBHR3hvc0draUVnVUxLQytEZkZK?=
 =?utf-8?B?UzZPQldHMTU1T1NXd2d0UW9WUS92ZCt5VjRIRVVqcEJnLzVvQXVRT3crVlNW?=
 =?utf-8?B?bXhrWEwxRzRhd1VJTnVPOGlDWWtpYXNHdW5Od01CRnM4NEJOamRTaEt1UHUy?=
 =?utf-8?B?elJidll4ZUUxVDhZV0NlRjJuMkI0UzFBRklwbzQ2eHVNbWI2OVhLOW45dGNw?=
 =?utf-8?B?TE5WZ3E0Q0N1S25DMER4eWRPRE43WUZGZVliRGhjOUxOOVpYOWk1ekk5WVFO?=
 =?utf-8?B?UGFWM1NQNXE4Q0xYNFo2KzArNDdLSHpwb0ZNb0tWeHFaeEhqcFVMNEZFVDVu?=
 =?utf-8?B?OWFMWXluRUI3YlhhdGJoRGxOTkQ3ck9Lb0U3YlUxdWNGQlE3RVJvZkxYaEF3?=
 =?utf-8?B?eUxEMDJqODlZZXVROTl1U3FEZ0JMODQzMW5jRVl6Ky9QcG9JWTY2d3U4a1ht?=
 =?utf-8?B?Q1RHY0Z0N29ldWR1Y0pZUzJEdUF2VlF6SERxU2FxMXNoM29scmpGV0lkUTRS?=
 =?utf-8?B?dktBRDdlSDVQMHFIbGthTTRPK3BnTmU3N080VmR4RWJiRU5aSWQ4dkJlODdp?=
 =?utf-8?B?UG5peUhUT2JmVFpTVnFtUytBNXhrRXN2RmFSUnJ0dDFHQmVUWGdBMHhtY3ZH?=
 =?utf-8?B?NjB2bVZzZG44SURrL2FmVXdiWjh5Tlg1TDNrWTlyRVJzVXkxR1k3K0ZLSXh0?=
 =?utf-8?B?VU00SUphUzZSM1llVmhIZmpYNnJuQWMwZE9CVmhyemZCdGdPMStac0h4bU80?=
 =?utf-8?Q?oiDgSOgTekk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGNnVy9tN2JhZ0xCVXRBc3RPM1FPbVhMd2lFZmEyajFzdmtXTmpscSt0Yzdp?=
 =?utf-8?B?Mmtic0ZjNlRVQkN6UVgraDdCbnpWeklDdWtOYXpHVzlYTWRGdXZuU3lvL2hW?=
 =?utf-8?B?WktXdndOZ01ZSWdLMjkyd08wNFNMK3pTMzRISW40RTgrVkhHTC9nYUZSdERH?=
 =?utf-8?B?L2cyWlJMSkMzYzdvMm5ZRC9NalpaWnFDbno5dStxRmtmcUNZVDB0THVLUVd6?=
 =?utf-8?B?aW40OFJ1dmN4R2tHdGFMMkVmRklpSDZGS1dPaGFTNjZybFpnVXQ2VW5QazM1?=
 =?utf-8?B?bkNlY0ZXSHprRUw0eVpYS1RJV3B4U1RxVjV3MVlUekhubGxqV0dTWWVCa1I1?=
 =?utf-8?B?Q09OMjdNRm9TYWhrTlBVcWUzcml1WVFpODNlVnlYT29tWk1FOEk2VDlpczNM?=
 =?utf-8?B?cnNXOWdielZqRDNwUnFyNmxjRmZyMTFkSUwrWVBDOUhTMnZmWXJudDlBT3FK?=
 =?utf-8?B?VkNlNlMxZWFhSCs3TytaNVhCRk1OaGxMTVlaaEVZNTBESUtubERlcUhrb0pR?=
 =?utf-8?B?ZzNudTh4ZHNCalpuekdpY0JWNW4yVnV3RFVOU1pSaDNuZ2trSUJvNFFTOFRD?=
 =?utf-8?B?ODVLMFpUNHN4Q3JzYjlBTld0NUZnUUJxenJGa2JKaHVHdWhlblBLK3IrOENY?=
 =?utf-8?B?cjlkajFtNVFOVjk0SE1BdDB3OVdmRG1ZaUY0cnE2cDhoMHZSS1RWRkpkS0Jk?=
 =?utf-8?B?TnNENW9DUzZSZmpOU2dqRm83L25FVDhCOFA2NlQvcXpYN0dIeEExUEZhZ2ow?=
 =?utf-8?B?c0kzdExOQVZsNEx5WHpKeEJLOW4xOCs3ODJmWlNXSlpDekxjYTdGdE5EaEV5?=
 =?utf-8?B?NUhvclNNVXBoUWlQb2dTbjRwMm5ydmpBMXNTSHdFSlhsREx2T0ZTUFhyZks1?=
 =?utf-8?B?U1V3aFZGc1MzNVZ2aFJnVE5GQmRIYS83WDdVSzlLZjhqZWZIaEREeS9rbnp3?=
 =?utf-8?B?NVlTTzcxMGtlZTE5Z1FSWXg4NElvZ3RNbGFPWXF3SXVFdWdCdzRGMTB4citt?=
 =?utf-8?B?L1lGTVZPdXRtMklWQ2Vhbmc5ZWY0dHlLRFgrMUpjRjh1Zm1QRVl2OEMrdE5p?=
 =?utf-8?B?dWNYUUZsZEQwcXVKcXB5S2x5K1lGTm5hS3Z2Y3FvYkdQb2NjWmNUVG9BYWNi?=
 =?utf-8?B?aStDeHIrbTRiSzlBblAzaXlScTlMODNKSm1Rb2JjalVLU1FtNHliUjRRTXJG?=
 =?utf-8?B?dnJBNEdCV1FOUXFWNGwrd1FxMGl2cUhOV2ttVHl0UlFLaDNDd2tGMkNLWWM5?=
 =?utf-8?B?aWdSRDQyVDB1ejhldFBQcW1aWTBOelZpeFd3RlkwTWhtckptSG5JUFhpTlcx?=
 =?utf-8?B?cExhZkExVCtnNkxQbXBLNTdScnZsWEloN0xmZnJHVy8ydDREeFRjazJvd1lO?=
 =?utf-8?B?bzBoQk1LYjNhNzdwclI3amFBRDg3dWxZQ25tOUtKa2diVDUrNjlscWhITXVB?=
 =?utf-8?B?dVg1c2RENWxydzl1UnpyM1ozb2JFWGJiWVVoZUNCVEU5Qjg0K3FCNkdZTmZJ?=
 =?utf-8?B?REs1UWVRUG1tZnBjdk51aitHR0o1WUI4N3F5YWdtdklVT0IzbzFPUGp6SzdF?=
 =?utf-8?B?ZXNUbnJKUDNYd1R2SVhHYzI5eXBnNCtOV2VTMzdxOFU2UHcyMkJoS0ZkMGox?=
 =?utf-8?B?OTJRbVk2aU5WaEJUdEVYU3BzUFBmV0kwZDBnaTJ3bmlEdTVoS1lDUW9hNHdh?=
 =?utf-8?B?MDBEUmlFNVlneGRvbktIcXYzOEN4OWNETEtrWHVFVkxFOWNJWXp3UHlQRlUx?=
 =?utf-8?B?TEluZ3JVT3BueHByTGxzZ2JWek9rdzNBZjVKaW5HY3REaGk0aHVLQmE1UDFz?=
 =?utf-8?B?UTJrQXM0RURyTjJIYmJ2cTBWT3FCanVBMk42aGh2czVSVm41UHh5bVVYcGM0?=
 =?utf-8?B?VTVzRkp1bVM2WXZmaHc2V3dSOXJNcHV3U0hKUXE4c2txM2IybjlXbW95VTdq?=
 =?utf-8?B?MHZkWjRLTUJURHlXdEtpcXhYUEpCZmhqdUpuek9COHRCRmlNck5KaElQRldY?=
 =?utf-8?B?b2FsZm9TcGVkV00wVXdtSnZ2OEQ4d3NNQ1dwcmJ1UGQwMmcvWmRnaFBNcjlJ?=
 =?utf-8?B?RHdvSThoQS9Ranc0aWFKbVh5ZW9pdTBHK0hacXYyTTdGTnVGU0ZLVGJjOVZx?=
 =?utf-8?B?V2NJc201T3p5VDRTSFduNjRmb2diZUp1ZlJaZlhxVzIyWGVLcHRaTWVXZ2ps?=
 =?utf-8?B?aEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A57C1B8DDA98446925ECBB3E9312CBF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb4141b-c139-48de-18bd-08dd34eab34a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2025 22:27:59.1111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J+Q65vdEz8zk4VlOVsH51BK7rnzAT7G+fXuMBzuGprji7fP1PD1NAAPQHvgkrv6F6xOZBrVBMCktBIzHHnvkEBCNC9E7s5q1xvgD4fC1DyI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7701
X-OriginatorOrg: intel.com

V2Ugc2hvdWxkIHByb2JhYmx5Li4uDQoNCk9uIE1vbiwgMjAyNS0wMS0xMyBhdCAxMDowOSArMDgw
MCwgWWFuIFpoYW8gd3JvdGU6DQo+IMKgIEtWTTogVERYOiBSZXR1cm4gLUVCVVNZIHdoZW4gdGRo
X21lbV9wYWdlX2FkZCgpIGVuY291bnRlcnMNCj4gwqDCoMKgIFREWF9PUEVSQU5EX0JVU1kNCg0K
U3F1YXNoIHRoaXMgaW4gIktWTTogVERYOiBBZGQgYW4gaW9jdGwgdG8gY3JlYXRlIGluaXRpYWwg
Z3Vlc3QNCm1lbW9yeSIgaW4ga3ZtLWNvY28tcXVldWUuDQoNCj4gwqAgS1ZNOiB4ODYvbW11OiBS
ZXR1cm4gUkVUX1BGKiBpbnN0ZWFkIG9mIDEgaW4ga3ZtX21tdV9wYWdlX2ZhdWx0KCkNCg0KUmVj
b21tZW5kIHRoaXMgdG8gZ28gdGhyb3VnaCBrdm0veDg2IHRyZWUgc2VwYXJhdGVseT8NCg0KPiDC
oCBLVk06IFREWDogUmV0cnkgbG9jYWxseSBpbiBURFggRVBUIHZpb2xhdGlvbiBoYW5kbGVyIG9u
IFJFVF9QRl9SRVRSWQ0KPiDCoCBLVk06IFREWDogS2ljayBvZmYgdkNQVXMgd2hlbiBTRUFNQ0FM
TCBpcyBidXN5IGR1cmluZyBURCBwYWdlIHJlbW92YWwNCg0KSW5jbHVkZSB0aGVzZSBpbiBrdm0t
Y29jby1xdWV1ZSBhbmQgZHJvcCAieDg2L3ZpcnQvdGR4OiBSZXRyeSBzZWFtY2FsbCB3aGVuDQpU
RFhfT1BFUkFORF9CVVNZIHdpdGggb3BlcmFuZCBTRVBUIg0KDQo+IMKgIGZpeHVwISBLVk06IFRE
WDogSW1wbGVtZW50IGhvb2tzIHRvIHByb3BhZ2F0ZSBjaGFuZ2VzIG9mIFREUCBNTVUNCj4gwqDC
oMKgIG1pcnJvciBwYWdlIHRhYmxlDQo+IMKgIGZpeHVwISBLVk06IFREWDogSW1wbGVtZW50IGhv
b2tzIHRvIHByb3BhZ2F0ZSBjaGFuZ2VzIG9mIFREUCBNTVUNCj4gwqDCoMKgIG1pcnJvciBwYWdl
IHRhYmxlDQoNClNxdWFzaCB0aGVzZSBpbnRvIGt2bS1jb2NvLXF1ZXVlLg0KDQo+IMKgIGZpeHVw
ISBLVk06IFREWDogSW1wbGVtZW50IFREWCB2Y3B1IGVudGVyL2V4aXQgcGF0aA0KDQpBZGQgdGhp
cyBpbiB0aGUgbmV4dCB2ZXJzaW9uIG9mICJURFggdmNwdSBlbnRlci9leGl0IHBhdGgiLg0KDQpI
b3cgZG9lcyB0aGF0IHNvdW5kPyANCg==

