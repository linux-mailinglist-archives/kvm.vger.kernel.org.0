Return-Path: <kvm+bounces-56199-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED267B3AE5C
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 01:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F1201C850F8
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 23:19:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C673E2D061A;
	Thu, 28 Aug 2025 23:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Am2nn1lm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAE37082D;
	Thu, 28 Aug 2025 23:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756423125; cv=fail; b=d0Eq12ORa3YQILz6dR+PDpt5IMmRpDoD/At4LrW9Qwvfs8GSDs5pk+W/5sfxyzKWS4K3EHwoO9pBm3s2S4Kw1xMxSZrbd6u46k8zVHQFTCKzrKLfxpfI5xxOAefz0dSOCP6iY+k2ELNwXkvDji31Tr9OrxMMuG1LyvJxwWxVaow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756423125; c=relaxed/simple;
	bh=ztHe0rdVo2F7Z1zWY/KkJFbgxjrf41xK7P+LpUIIt5w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=clN7uEpO770ugG09Mt070aMhMeHyRN2S1RNuVTcic+Whp/aK4OnFiHrG8F7l0ljM0yP8IbWEwUTj94Rh25yeB9tWnTb/Qrn58K22urFKy8lti6YHIApHiEIxWICKyf2qIKEtEqxG2DCBuBrTyTs7434wnJq2lxh9Qq6gJ9NBRt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Am2nn1lm; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756423123; x=1787959123;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ztHe0rdVo2F7Z1zWY/KkJFbgxjrf41xK7P+LpUIIt5w=;
  b=Am2nn1lmRS2ZIapx9PWxMw4oOIStzfq4Rp+AA7D2kj/c2GesMcXrqoPU
   H8/xzm1yR8xfNqjmMEj1CzCLVA3nQNp/FQQZPu8FXwfiZZNnR8sQ4SMQt
   8cKGPEF9WSN8DVvRH+8lbT9BgHsg7+st4lnH+ZO5jMN0JLV5FhBaCBDti
   HyyU3cCDtENEjJtELPVRAKQeAlSJUe6MYfe9BvpF0e90cYTs4/cV1obhi
   HtjopW8RREeMaUbwDJ0OsvsvP5I/DCHWZYnWswXVOeB2CqUfpe2Ur7slg
   mdPbYQ0PBW+OVIFVX+Q0pgyZ9k4W8sA/736UqbjCfEtLBTz6Q9OEH2leh
   Q==;
X-CSE-ConnectionGUID: 4OFl7lA5RA+kELHVZUyCVQ==
X-CSE-MsgGUID: d5/oROKySOugOAxWZCacFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="57903183"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57903183"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 16:18:42 -0700
X-CSE-ConnectionGUID: RCqTdbD8RWKa3rrlFTbXgA==
X-CSE-MsgGUID: 7YmlrsUXR7irkdFsX5DFIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169764024"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 16:18:42 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 16:18:41 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 16:18:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.60) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 16:18:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DEbynfQPu9+lbvBbGR90p8paR2t41SMmGaLSqDNErxxuxzrpcmTZyilpTVpY6YNP33Pd4gPh9yUlq3W8xQGXz1MxjFe76GuY5nqXAhoMeYbi5Jzqc+w673P0GU/Ep3KIVXZ+HJAYImm+mG92dX2ukIZH08q2Pa266xy5ZVjcwy5Grgy8rfsmmwluAenOR7Yr6tILchb4cwiiN1ZJi/M82lJhQZu86rBlg6QB1gPJWq4qm1aSgE48GT1cDgt6aq3Nc/b1gvzHPLWP15RxLR5BDey8VlfdR7N0MVzLaIkI7NEknytBdVe50aoxJpPDNlxZn2oc0xioRl9sbYiSiaJ0gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ztHe0rdVo2F7Z1zWY/KkJFbgxjrf41xK7P+LpUIIt5w=;
 b=e4Hod1zgiYRw3Y+BtN3mEKoLvpaNAs80Uw18kTPUF+moEfoXAO0Fw4GadlsqMCZZiqg3Pjf9G55Fy8v16GKJULRzscDtwt7h9ODYhL+ICPuzfMd57b1CkX7JIOVxj6VKa7EMbUpLgQIbjhYGBL7v+qQ7mj8tlxNI/6Hh/4OgEfi6d3kNyQC8YeFd3/LGzWsdFySmamM+SBp1oWpWik07CvNDDCInm0sF74kl6R33ewvgi9LujrvKPCZHx9vRLT0FO+9tHV5oDQ+LM7JUsG+zMsUqxSwNIvCTvxlpsxZ/E4nS9GqS0RJNcb57EvsO4WpBDrWVtXJUg2II4YHfiz21yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6247.namprd11.prod.outlook.com (2603:10b6:8:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 23:18:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 23:18:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 08/12] KVM: TDX: Use atomic64_dec_return() instead of
 a poor equivalent
Thread-Topic: [RFC PATCH 08/12] KVM: TDX: Use atomic64_dec_return() instead of
 a poor equivalent
Thread-Index: AQHcFuZhH5ivTN1080yMH+cPgFIX9bR3YNiAgABAzwCAANB5gIAAN3+AgAAMrYA=
Date: Thu, 28 Aug 2025 23:18:25 +0000
Message-ID: <da91ddb191db9e4178e5d1e05a0d2a40505f0d2a.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-9-seanjc@google.com>
	 <afacb9fb28259d154c0a6a9d30089b7bb057cd61.camel@intel.com>
	 <aK/7rgrUdC2cBiYd@yzhao56-desk.sh.intel.com>
	 <128a19f38bb532a91cfe23b7a7512bb883b276cd.camel@intel.com>
	 <aLDZHf55rz1W0n6b@google.com>
In-Reply-To: <aLDZHf55rz1W0n6b@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6247:EE_
x-ms-office365-filtering-correlation-id: d69d9f41-4b7e-4d04-ebea-08dde689303f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dkx3M1JUOGRVQStQa1dGTXU2S3Z2QW12aTJRZzRVTE1MeXhrdUJMSEFQUkdX?=
 =?utf-8?B?elVpVmhvbzIvYzRCOHVxSWVldm40REtobUJUdTRqMTlQcFNobnZWdG5OeU1k?=
 =?utf-8?B?S0M5NE9KMlpBZCtlK0FHVE1SekFibTF6R05hZGhuSmFWU3AzalIyb2hLbWVs?=
 =?utf-8?B?TFRMRG81OWRYdlhKSDJ4Y1A1bkdMTTdJcG5RTDIybGpPd1NjSXdDV3BVZ3p6?=
 =?utf-8?B?anFFUjFmSUVsTmo3dTJ3UytCSURjcU1LR1hYSFZQQzNsaXZVUVkyenc4dGN0?=
 =?utf-8?B?RUxiNDZaL2d2cW1UWHlrcENQZXZtOFFaTW5XTHZLQlJhMGxHTm9wazRsamxt?=
 =?utf-8?B?QWx5bzRjMXQwWEU2REFLVEdsMHh6M1VxK1RwVFNuSDZleHBTSzk3Z2RkU1VQ?=
 =?utf-8?B?YWIzT1JBOTlUZlhla0JqS1o5aGdSakhHeXlnaXV5OFhJb1hDaDhMZjNOYlBG?=
 =?utf-8?B?bUJJaGNkbkd3aFY1d0VkQ2t6YWJBcENYL3BOUGVXMGpCSEN3cGNkcU9TYlY3?=
 =?utf-8?B?UDhCQXJpamZtclROT2xsYnBocXMvRUhkVEw0bysyYjZQMHNxZmFqQWFVcFJi?=
 =?utf-8?B?N09FQjJPVEtKMWlBTzFZTFNYNHF5dm5kNzBTdDZqcjJFUWJzNSs4ZHlzSnMy?=
 =?utf-8?B?OXcraUhEenhvVmk2dXAzaVVIVTdMeldKcmZja05rcDZQam1WcGN1M1NlVFZQ?=
 =?utf-8?B?OWZkUXZ1Y2tRU0xuTm42Q3A0enV4clhHallDVHM1Y0YwMi9wUlFNeVhwK2c4?=
 =?utf-8?B?VGtla0VKZGlkVTRhTFRwUFFkSHM1UkV3cStuZTJRWUZhbnk1VndlRzREZnZa?=
 =?utf-8?B?c293cDZENHV1eHdQa0xGVjA4VFBXMGtBWjRnVWFZNlVLNG5aRlRTTzJncTF0?=
 =?utf-8?B?Zm1QZmZPWUVaUkRQZ1Q5SmdHMnZxVHg4ekZRV2ZyU2FGSlhVdHhuZVNqaTVv?=
 =?utf-8?B?TWlqSHdWeXovSmpQN0g3NFN3ekxQQTVBOC9hSjM3V1p1K2M1QVQ5cnc4bkV2?=
 =?utf-8?B?a0Y5ZWlrL0Zsd2lvU1Y2M3JSUXc5SmtmbkQrektsUmY1YldwR1p4QVNnWFF3?=
 =?utf-8?B?ZVkzYWg4YnBKeS9ZNzhBaVpQTUV4WU56N0l0bExTbGFPV1UvOVFYNlJIaUxw?=
 =?utf-8?B?WnJFSnQyZE5pQVBKR0w1Z2QxVVBjMzMzckZ0VldvcjBDMnlldUlCVVNHTW5T?=
 =?utf-8?B?ZXdSeUNTbjFOeWNRelRXMzIvcHlLWGpLYU16V2VSZ2xKUVZjWWpOdGJEWFo3?=
 =?utf-8?B?QUhueWZVdFlwWnFEY2FIV2JzcS8rNk5zOHQxWGkvazRlMzlTRkJ0TWpGSmpr?=
 =?utf-8?B?cFNNV0R2Mk93R3B1UFZmOWYrWHQzMUR4VzBjcVhVRS9ZRnZYWkp5MWdrQTVO?=
 =?utf-8?B?bEF6ZkhORG5oOU03Q21LVHN3V2cvdnRxNTFnVCtoYm4xZkpRRnZqdDVrdFNO?=
 =?utf-8?B?YjBwbkxSNnVIMUk3Z0VoYmdUVERMMCs4THdnbDNKcDJpZ0F1OGNVZHQ1bXhp?=
 =?utf-8?B?RVM4YkZSMThjcS9WZUZjTXNlWlcyZHMrMmptNEM1Q0lhR05SdlVWRFBzVkI3?=
 =?utf-8?B?MGpySnNnN2NsbGtHc1F3VUxmS2o0dmlkTENRWjVtS3lPUkZZMXpDK2FaSlFU?=
 =?utf-8?B?Rk9hcXVaREZSNDdvaVpHeTJKeVRYbVpYZExYOHpaeTU3ZXRnVWI5SjkxcjQy?=
 =?utf-8?B?ZUFLOWpibzlIUFhMZXZjalRzSy9NUUFpTGw5WmQ2YUR2cXVkQ1pEWXRmbU04?=
 =?utf-8?B?QVp5LzVhUWdoY0N0TmZPZ0hkM2d3RUx4cUhKb1VhbS9sYkF2VVo5NE9VUUE4?=
 =?utf-8?B?TkVWbHI4K0l3Tm90V3dpUitDZU44TDhGWkNyRFlJQnNrQklTQXpBL0xJL1JM?=
 =?utf-8?B?Mmp5QUNHZFl1aUE0OUZ4endydnE2QXh0MFNvaTZjc2t2cmpNVS9LaVBEYzNs?=
 =?utf-8?B?MU15OGorN0NYeTBNa1hPYVUxWVE5SmJtOFJkWUFWZm56V2pTZ0pNR1c3UHRr?=
 =?utf-8?B?dXBzTlhaa1JRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGNwaGJUeGtZUm56dHdGQmpsaUViMHhFTnBiemk5MkRlQktNNlU0OGZSajV0?=
 =?utf-8?B?V3hPMWdrdjNIT2V4eHk3dVF4UjI0bkl3cXhEZzRKbXRKR3N3dzZyKzlaaExY?=
 =?utf-8?B?KzBOaUYyUWNZMVNqd09pZHJXNDFDT0htWTM1ZEwzVnd6ZHpjK2N0ZTVqNjZU?=
 =?utf-8?B?UWRvQ0xvbFJRcFpLTWE1UXFBeDdlTlYwV0F3SEdhM2xpZXJCbmVhV0JEc3M5?=
 =?utf-8?B?blpNNGprYTJwRXg4WnlHYkRjbW5VODBHcmx0NmpldU5tb0FnckZzbFplNVVw?=
 =?utf-8?B?VFBnZ1pPejNSTWJmSTJHWStUL0lCdEViUWFiV0xFTzY0WTdRVVJ6dlVISHNt?=
 =?utf-8?B?MkFlYnU0US8vb1FHdVUwR3E1QlFaRk51bzU1UWl4S3pSUWk0MWZMNkpiUnRD?=
 =?utf-8?B?MzE0SXFoMmZQRUZOcmlHV1F1c283cFlwbEl0Ymt5UkRyS2t6SnlsVmFzV2J4?=
 =?utf-8?B?NUZER2FNbDhZeE5SWkRvYUZhWW9uWm52clF6WitQTkpKTFlTMmszMS9aTmND?=
 =?utf-8?B?MlZjbklNM200NVFDcXFCdFVPY0l6NGJYemNYUnFUZDQ4bXh5L0xxQkozei9x?=
 =?utf-8?B?VEJxNEZZVjlrbHozcWl6ZGRoQ0pjVmJIcEkrK2ZCZ0Evb1FYaU5OcFJ5Zmlu?=
 =?utf-8?B?S1dCUTZrbm9HUDd5MGR5UGF3QnNzRmVaL0crQ1VuNFhPaGtoTERJMkhZY0hq?=
 =?utf-8?B?MStPbUl5VVVTd2FvQXRWWFV6NEtaVG5IWGxsRjdoS2gzQWxHbFBGZThCK1Yy?=
 =?utf-8?B?VEhDOFp4K2Zhd05OQzN3dXp6VmVHT1podG96QnhVOVVJYVlIaEYxYkhaUjNv?=
 =?utf-8?B?d3lMUmdBM3hMdmhqY0VjTjdLcXhGL3NOL2MrWVNSZ2w2K0Y4cm1ocUpPTG91?=
 =?utf-8?B?NDdIOHRJSjBSSVNlTWx5QTJ0dlVwZjFWaGgrWlBZcXhsVWpHTzRpNXMvNXpv?=
 =?utf-8?B?NFlER2FxOFZtZldSbGZseE9sMldCcHVrcFg2N2JtTXRDeGxpUkdlWXg4S3BM?=
 =?utf-8?B?OWRSQ1hDMUxLTGd1cHVzVlJhMXhpU3hGNlYwUzBjZFRCZzQ4STk3eDZiR2pq?=
 =?utf-8?B?anZJNENtWVRibWI4cjBHNkZKNWRqbFlpeWxTZStTMS9LSGNUaGRMclZ3cWFn?=
 =?utf-8?B?Snp2OEpYZ1BJL3dxVkJROVhnNVNNRTJYck44NTJzUk5jSVZHNEI1QWREcmRJ?=
 =?utf-8?B?MnVtZlJFY0dRYnhGVTA4US9rL1FTLzJIRzFwOEtvSVhYYzhMTVpZc0FVdzU3?=
 =?utf-8?B?YjVTUzJNRkRLQXFhMWtmTWJNdHVmcHd6djRObHh0N1d2TVR2WTZZWXVFOWRh?=
 =?utf-8?B?OUZQV2d1MElKK0xLRWVyeXM4bXNaT2ZaYmVTMC8yOEtZK1dIZm5YMFY3TmhF?=
 =?utf-8?B?ZFVuM3NVWjZvb1FFOUFEczBDQ09qTWVXME1VSTdZWXBXQldHZHFBaGVNOFVS?=
 =?utf-8?B?T21nRnVXTjZqTHB6Q1QzUEN0Y0tuWExDY3FlV2MvMEFxRlY1MWRweGxoVUU2?=
 =?utf-8?B?QXlWeWFuM2djZFB2bVY2VlpQVWYrT3JNRjVlN3ZHN1ZVcElYZS9oWmFWNk5S?=
 =?utf-8?B?VEFuTmlwWHpFL3ZLbkIydkVzM0xhUml2bmZNTWoybCt5dm5qUXBqM1A3SG1n?=
 =?utf-8?B?UGJ1QWVVMkR6V1M2bmpFTjZaWVlhc09JOTV3NHU2bk1lSWJOR3JPaVp0QVdm?=
 =?utf-8?B?b1dNVWhZNmQwdFhKYUMrM0ZuQUZ0elRhVTkxb21mWitxSGM0UXJMOGZrcDFE?=
 =?utf-8?B?aFQzM1pRQ2M0ZjBUQldVbWtYQnQ4RWV4dXg2eEJRb0M3ekJkN1g0dFVFYWRu?=
 =?utf-8?B?cXFtQmIyWVpBbE41OWlkRlVyU09SclMwU2xlMDJBQWZFMSt5bHdrMkpNNGxo?=
 =?utf-8?B?MFpIMDhJMExiK2FKdW1OSHZhRkxFRTB1SGJYa3NNYld5bXl3YXBwd3Jhc21i?=
 =?utf-8?B?amk0OXp0MVJIQ0R3K1o3dTBoOC8xSWQyRW04WEhRNUZWUDhBL3VjTWpEb3R5?=
 =?utf-8?B?MEJCRHBNYzRCSm5UL1I5M3BkZHdiNjNKaEh2SENoZTloOEloWkJuVURUWkc5?=
 =?utf-8?B?YXJWU29UK3BBMFpRN3hwVzFFRjQrRkxQbkl3QVFPWVJxOS8vQ0FFZ3dRZFlJ?=
 =?utf-8?B?NmREUEN3ODlncG96UERxcGZSL3ZySm1FQi9jSENmQWdYVWt0d1NoKzJINFJ5?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <312732243DBA5649BD064006EDE1D0EA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d69d9f41-4b7e-4d04-ebea-08dde689303f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 23:18:25.0295
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbrCXZFwT7jrUmlLKjBjHo5JtFhNS3nSCPDC9sgxZcm6dK95VD33p1VCJWqprmgiq7PYoC4H38TS+OY8nxKxpmgxyqfhC7VKT5VUKH+SjK4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6247
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE1OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEF1ZyAyOCwgMjAyNSwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBUaHUsIDIwMjUtMDgtMjggYXQgMTQ6NDggKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0KPiA+
ID4gSG1tLCBJIHN0aWxsIHRoaW5rIGl0J3Mgc2FmZXIgdG8ga2VlcCB0aGUgbnJfcHJlbWFwcGVk
IHRvIGRldGVjdCBhbnkgdW5leHBlY3RlZA0KPiA+ID4gY29kZSBjaGFuZ2UuDQo+ID4gDQo+ID4g
V2hlbiBJIGNoZWNraW5nIHBhdGNoIDYgSSBzYXcgaG93IG1hbnkgbW9yZSBLVk1fQlVHX09OKClz
IHdlIGVuZGVkIHVwIHdpdGggaW4NCj4gPiBURFggY29kZSBjb21wYXJlZCB0byB0aGUgcmVzdCBv
ZiBLVk0uIChldmVuIGFmdGVyIHdlIGRyb3BwZWQgYSBidW5jaCBkdXJpbmcNCj4gPiBkZXZlbG9w
bWVudCkgV2UgaGF2ZSB0byBkaWZmZXJlbnRpYXRlIGZyb20gZ29vZCBzYWZldHksIGFuZCAic2Fm
ZXR5IiB0aGF0IGlzDQo+ID4gcmVhbGx5IGp1c3QgcHJvcHBpbmcgdXAgYnJpdHRsZSBjb2RlLiBF
YWNoIEtWTV9CVUdfT04oKSBpcyBhIGhpbnQgdGhhdCB0aGVyZQ0KPiA+IG1pZ2h0IGJlIGRlc2ln
biBpc3N1ZXMuDQo+IA0KPiBOYWgsIEkgdGhpbmsgd2UncmUgZ29vZC7CoCBUaGUgbWFqb3JpdHkg
b2YgdGhlIGFzc2VydHMgYXJlIG9uIFNFQU1DQUxMcywgYW5kIHRob3NlDQo+IGFyZSBubyBkaWZm
ZXJlbnQgdGhhbiB0aGUgV0FSTl9PTkNFKCkgaW4gdm14X2luc25fZmFpbGVkKCksIGp1c3Qgc3By
ZWFkIG91dCB0bw0KPiBpbmRpdmlkdWFsIGNhbGwgc2l0ZXMuDQo+IA0KPiBPbmNlIHRob3NlIGFy
ZSBvdXQgb2YgdGhlIG51bWJlcnMgYXJlIGVudGlyZWx5IHJlYXNvbmFibGUgKFdBUk5zIGFuZCBL
Vk1fQlVHX09ODQo+IGFyZSBib3RoIGFzc2VydGlvbnMgYWdhaW5zdCBidWdzLCBvbmUgaXMganVz
dCBndWFyYW50ZWVkIHRvIGJlIGZhdGFsIHRvIHRoZSBWTSkuDQo+IA0KPiDCoCAkIGdpdCBncmVw
IC1lIEtWTV9CVUdfT04gLWUgV0FSTl8gdm14L3RkeC5jIHwgd2MgLWwNCj4gwqAgMjUNCj4gwqAg
JCBnaXQgZ3JlcCAtZSBLVk1fQlVHX09OIC1lIFdBUk5fwqAgfCB3YyAtbA0KPiDCoCA0NTkNCg0K
SG1tLCBvay4NCg==

