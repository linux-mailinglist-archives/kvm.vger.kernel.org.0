Return-Path: <kvm+bounces-61267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 57240C12C2E
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 04:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 167204EF151
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 03:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D010127E1C5;
	Tue, 28 Oct 2025 03:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aXcaXgE4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459492222AA;
	Tue, 28 Oct 2025 03:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761622146; cv=fail; b=bl0qXQH0vFCSaDdXNMTmaupJQkwETszmHSsLNBgB9/yhv/VxEIdOm0eMwfRkTAf0AO2ICHui1dgnM23EuxdbPcfu/FLg8Hx9Hlc0IAnzzj39IlcnkeYY8wNvHP+WH2nXxmEq17cCzZ10jD/D+OboNFmxAiTiY5bE794Cw5inga8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761622146; c=relaxed/simple;
	bh=xjwuAi0oQIdHo6D7yDnMT/yagN146NYQGoCeeWSvtIY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BgyudKOVm9sArM3RYqnIsYBXatn8qUx1HM+R6wJ3eUmYW5+weLY3Un8PosxJX1lNB2E1f2xYwNF+UK2YArXElmGGDFTTGBWcAmQKYyTSOqlyJHKA2HRG0CLtDPQU9P1n2RQ/Y5w1LoRiqOjNhEGZpjlrmzCKi7w8EF2Hy6gaAyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aXcaXgE4; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761622145; x=1793158145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xjwuAi0oQIdHo6D7yDnMT/yagN146NYQGoCeeWSvtIY=;
  b=aXcaXgE4SB5sDQ6dxI8u65a28zcg65C0vgsmgA2GoYOMhd1MqK5XAIkN
   zEHqFqNMc8NcVHBgBfAWn9ISsxmKr0AvWA5d033Oob+Kq+md/n0zBg/UD
   ueBiSYaGjOJyd/CQsv7Lyi/dBt+TFVrGcNzLwOf4VVdvJGJ3K+mCckaa3
   YH5orQbf8lBK4fZ4qI2qIns+lRZ0uOeUV6MCJJ/bUCYH766sdVG4MhvA1
   XShS43DsiT/5Uf9iTT9XmA2kQU19el1cnKFsDLoMi0JzH82Z+NNezisAV
   8pEwvEI3h1EbCsDBblJVo4R3/v18W9n1DSLqYszip7MhN2A9TxQRXaqS+
   A==;
X-CSE-ConnectionGUID: 6LiJjLRxQZe6skI4GIGO/g==
X-CSE-MsgGUID: kTlKB4g2TZWvKj19yjQBZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63621255"
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="63621255"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 20:29:04 -0700
X-CSE-ConnectionGUID: l5F83+j4TYOxg6Z5uvvxhQ==
X-CSE-MsgGUID: 0e7IkPjOTwm1aRRnjrltBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,260,1754982000"; 
   d="scan'208";a="184926715"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 20:29:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 20:29:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 20:29:02 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.12) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 20:29:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VNjHfNPGsDZmOZsVZt1KO7/ESnWHMvr+ON4HCxytmQJy6sFd58LUSPQL0W41Mlb2gMbFJuDtnVeJoJ0N2wdAM2UNYJLRu2vHj/wfk6u7sbA6L2/lui3hduCPPi+vCsxyYq39DSqc+bcwoCUjvjT9MVIz3fgMcJhuGLzNjfifp9Bj4jtu9hlSuX4QWNAxCpfanlzx87LZfnWVmUjq+F5DH09YQvSmiukuGhWZ7PJ5LUdF+IGmUIFDVUTVpz9f4CzAOs6P9gesPyiId/Dd/BeAO+mQverVW3wf+VAFbEpBLWAsOb7i3t6LvL4/rx16mAwo72rQ9oGujJrfnNz285iJrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xjwuAi0oQIdHo6D7yDnMT/yagN146NYQGoCeeWSvtIY=;
 b=aOmRoOHidW2a7orY2OuBJatTAjvZ2m3mljX3GHJXdEh8+gdQ9Aupj4oR6w7QvI2lV2xXfIFECIXTjiS0HPOTr/72ApfWY6SsF1IHExIHLip/6xkCxzH+1+sRMbSss+MJ26NAL4I0xCIf8A0DD+hYob4usgu1CLzC8/E9417PEyIWcOwvzUsQMRwNX8KHVqCQYofuDkUrOmDxJXRxGnHmwqmrcc/G+qhA+ShOSh52/FnCh6lzs1atspAsKtAmrNS1PUevhyIVMT6eske1gYU1JqDKTQwKgEN5Vl602ZMJHWzOk97DlBHt3ubaJr1ew2a90PKErnRdWiCTbEfYd2uTtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6280.namprd11.prod.outlook.com (2603:10b6:208:3c0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 03:28:58 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.9253.018; Tue, 28 Oct 2025
 03:28:58 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: "Winiarski, Michal" <michal.winiarski@intel.com>, Alex Williamson
	<alex.williamson@redhat.com>, "De Marchi, Lucas" <lucas.demarchi@intel.com>,
	=?utf-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>,
	"Vivi, Rodrigo" <rodrigo.vivi@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>, "intel-xe@lists.freedesktop.org"
	<intel-xe@lists.freedesktop.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Brost, Matthew" <matthew.brost@intel.com>, "Wajdeczko, Michal"
	<Michal.Wajdeczko@intel.com>
CC: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "Jani
 Nikula" <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Laguna,
 Lukasz" <lukasz.laguna@intel.com>
Subject: RE: [PATCH v2 25/26] drm/xe/pf: Export helpers for VFIO
Thread-Topic: [PATCH v2 25/26] drm/xe/pf: Export helpers for VFIO
Thread-Index: AQHcQtxHibA2HY+r2kyzaO6GFVlPJrTW76Xw
Date: Tue, 28 Oct 2025 03:28:58 +0000
Message-ID: <BN9PR11MB52766B1A0B19758171772F2F8CFDA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-26-michal.winiarski@intel.com>
In-Reply-To: <20251021224133.577765-26-michal.winiarski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6280:EE_
x-ms-office365-filtering-correlation-id: e7eea36a-bd9e-4981-98ec-08de15d221ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?N21aQjZ3UWljT2RhaWZXSXFQQ09ORGRNRDEyK3ZWTFZDaWY3cytCS054NGFC?=
 =?utf-8?B?a2pVcGgwZEpVRjdkclI5M2RMb3Z5emg3aWhMR0NKN3Z3Q2daL3YvVmtLTjd6?=
 =?utf-8?B?c3NVTncwamFGRE1ScHVWVnVHaUgvRE5kZ0NLZC9wd0s4YW5xTjRQeVlaTWpJ?=
 =?utf-8?B?bXZtYmNYWXU5cHJReEgyTVYwVjlPTjRMQlR3cmpRNWh0ZGJ5d1RVNlhYWm8v?=
 =?utf-8?B?aExRbVVrUVA5Y25vZWxmcCtJMWlCUGcyanpudkpObEtsRjl0R3A4RmwxSzVK?=
 =?utf-8?B?OCs0dmxNRmxnUExvS05VUHhpTFZoUVQwcFFMK1JvR0F6MW8veGtZUzErRzZw?=
 =?utf-8?B?VXA0MnRsSTBuN1BuTTFYd1I2OVg0VkRpOFA2a3NRa1VYNDFhZEhjZUhUY3ho?=
 =?utf-8?B?Tzl0Mmg5ZCtLR3pYdVdJWE9GQmlwWmxvZlgrdUtwYkNJTGVlcFBSWjdONGR2?=
 =?utf-8?B?MXNxZDlaNmtVakd4QmdhMnE3eFdnUng1UzE3dUFFRXRxTmN4ejRMNFhaTjRi?=
 =?utf-8?B?VGdyNXhTSGVTeldvbHIwWGNXRFN5OGZ3SmNOcFZSTEk2MWNhSWg2Qkk1WlZn?=
 =?utf-8?B?Wmo3aDRwZlRSQVhES2xzWGpLakxPNVp2aUk0T3RPQ1FoVG9XbS9jOTJUek4x?=
 =?utf-8?B?ZFQ5TUIxeitva0dZQUlsMTZPZ081eEM5Tkp5V0xtaFFNRlFGNUV3WTI5OWpG?=
 =?utf-8?B?ay9sVlY4eWpTdnN2dVJjREhHVXhpdDExYm82cjZ5SUUzTk12SzM1YkRIYUV2?=
 =?utf-8?B?UDc3UWhZV2RFcUNDaHVtQkpvSllMWmdjV0NQd1k0c3dzeWlGbHlXd0hVYXBt?=
 =?utf-8?B?R0UrTmlLMmRZMEZCMWVVbEFHdVphbGdpamt3Z25qSmRKTktkT05ZZWxvMkhm?=
 =?utf-8?B?UjR5OUJmd09xM2E3K0x4SlVVSmVISkJJYU5rY0tUVThLUTNDejJlbG5YTHdB?=
 =?utf-8?B?S3VHVHIyc2dEUEczR3h4eXh3bXJxbWhOY2MzVEw2SzNpbHpGK1IxbnI0aUxY?=
 =?utf-8?B?ZlpuaDAvaGhudmo0bjlsbWhjNzVqL0txeUg5SnNtNjFoVjJpaVRmRXhpb2My?=
 =?utf-8?B?cTRlTnJSdGlyMDNmOGlwZjhURFUyK2FMUEJZSDBlYUU5eDBwWFY1d3dtaHpD?=
 =?utf-8?B?RklhOERTSEtsQXZCMFRXRDhGck15V0c2QmN6NGZZVkhObVpCM3NKVmVreTNk?=
 =?utf-8?B?YVZxREVTQXdOTERTaTI3RTlPRGMvaDRtVEpIZC9HR01zZ0x2QXpRNExNSXJJ?=
 =?utf-8?B?TFM3Z1N3L0lydUxreVNOeHY3TmI0U09hSjd1RHd1SkkrcXJ3NjBsb1RFdWdB?=
 =?utf-8?B?NHVJSjhCbE5RcmhZWjA2b1MxTmpTWk01WHoyMUNqQ0NqSHhKSWRMcTlueW5h?=
 =?utf-8?B?eUl6UWg1T3NPaWh0MnU1U1ozK1ZPQkp6YnNjWHpIUGMzQ0tya2hkYTJXSmRz?=
 =?utf-8?B?V0V2Ui94Qk1DOHdvcnE0RktpcEdFcnhWNFZpVkkzcTBFTWY1NncxR3JETklN?=
 =?utf-8?B?TVMwYjU4d05DOENSekYxZmVXNU5EOHZ4eU5sY3pvSSttTFV6RnA5SDYzdm8y?=
 =?utf-8?B?Umk0OWw2Ym1FREw1SGpyMEFxUHRUaTZ5MUtzOGZWa0NHaW9kckVRZFU4Q1Nu?=
 =?utf-8?B?OGRuUDE3eTBrQkUycS9vWVhDckRrQnhvd0U3dU9VZnVkYWJ0VHlNbWdGR2I3?=
 =?utf-8?B?YmdIT0hMcVhjZmlSbTF1Y21IVEk3Z1o0amd4ZFoyZHlIajBYcFFqTFFwazB6?=
 =?utf-8?B?RG9BRWdrbGY1bnBUSjNTaHFOYWEwKy9QdEpGblBWeWNRbFFvTURuc2tXcUNx?=
 =?utf-8?B?L2w4Qm9HaU9VSzRiOU8weEZYNkFSbVZ6bHBiTTF6clE3UENSQkt6V1BwNDBy?=
 =?utf-8?B?allrZGVLd2JkWWZXNUluZjkxTEdUc2lLTzhJbkRLYlh5MG1hanlXdG1NeW9O?=
 =?utf-8?B?K1NvTDBYT28zRHNDaGFBYThIOWZyMm0yMzd6K082d2crUURENE1Hb1hJaW50?=
 =?utf-8?B?ZUE5S0hYbnY4ZzlDaTZWVVBDY3lya2d4U1g1cDJVZWZQdE9SR0NNM0tLWkdW?=
 =?utf-8?B?SHRnbmhiRFhUK1hscUhkZEh6WmdTa3puMzRXZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWdEd0RoS25Kd1pSSzZydnhZWWhSZWVsQmFpSFExYkVFQk1NY2hwaUVMWTR1?=
 =?utf-8?B?SVB3M3laaEFOWGI5Vko4VGEva2RjbW9QZFRwRUNINVBxN0tVdGtQVGVtYjRq?=
 =?utf-8?B?MW1qcGpoOUdtY3FtT0lVeVpKcys0QjV2QURIeXd1L1FXVDVGZ3JmQy96NnBr?=
 =?utf-8?B?ZDhkV2JNcWpBTlZQRkFzVkhpVUM2S2hWSDJHNHZ3eVcrVEZVNWhoaUgzQW5u?=
 =?utf-8?B?a3AxN1MwNTg4amZtLzBuTWpKVC8vdlNhQlRTcUdCV21Qa3htbG1KVFVBWkVW?=
 =?utf-8?B?MVRzZEluOHJQNndKWGhUSlJmK0VjSU41RjdOTUhzanUzU0VuSWNGUUdldTdG?=
 =?utf-8?B?MTE2QW84TnVRSmlpa0pyYWgzUVNKNDFjYktWSVVRUFY4TzFScExodmM5K1dn?=
 =?utf-8?B?QW1MYTd4dEhNdnhsall5S0dvWFY4R2NLR3ZWTGkxZVFqL3JLdFR5WWZLblUw?=
 =?utf-8?B?QWVyYXJpY0s5N3FBQ3pGSE5oNXBOOG9aQ25BT0t3azA5ZE45MUdqQWRFYmly?=
 =?utf-8?B?N2hmV3VkSkROTG96elo4ZkRBUGRkbnZRT2szOGZuWFcrMHE0M1dwRVMwYzIz?=
 =?utf-8?B?M1pWRVV6OFFtcnA2ZUg0SjVsck9LYkRCSUlwQUwvUXFmaFIzMkdQaTJXOWtF?=
 =?utf-8?B?UnplVTI1TjNxM0xuamZvZjZYQVJ5U0oyejROTTFBalBuWFdncm5kVmlTbC9y?=
 =?utf-8?B?WlJ1cC9yd3ZZdWxpTWQ2d0NSdGJNNmVGbXozVjRMMi8yU2JrOGh2bUJTMEpK?=
 =?utf-8?B?Qy8rVmNrUVFuVlBmV1pxM0lkclFhTVZsUDM2ZEFWOXJoUEFCYXhqcEQycEFn?=
 =?utf-8?B?YUpDeEVZWmpWYms4cmJScVZoZWhwc0I0VzJsSHlLY0pVT3d6K3JxRUwxRXp6?=
 =?utf-8?B?WGJuQ0ZnaGZQRTNhU3ZaV08zUG10ZzUyajZRQ2g1bVpOUWEyaEtldFRYZGZM?=
 =?utf-8?B?QU1Ga3AxY3IxVEswWEN5SU4xZy9oazI2UFhJbWVPSFlCczV6ZGdheFhvLzVE?=
 =?utf-8?B?WG9JU01ycFkyQ3RHZGMvWXZ3cERWcDI5bjlud2dGRGI3YTFkRklRWERkSjBZ?=
 =?utf-8?B?R21CZTRNWk1WcGtxQjNFWGRieGJaclhDK3d1OUsyTXdNVkFjQlRpa3VNY3Az?=
 =?utf-8?B?WmFENytFSlF4SHRHQnM0NjZINnI5S0l6dW9NL3FVMkNxR2srZTBMTldXWnF2?=
 =?utf-8?B?OXpjT1pSVXhyNmFNWlA1TFg3RXpINHM0NmRTNFJpRFllM2lmL2lHa1BSRFdm?=
 =?utf-8?B?aGpqN05EYTZ5NzFOSlN2WlBybURRTkwray84dXRDMlRrbnJyb0VuNEIxSFNN?=
 =?utf-8?B?Y2dPZDhUdUhEdHVoTkZRZUhnSU5URGJSYzliMFRQMlBuT0F5VzJtbWk5VSt2?=
 =?utf-8?B?MHl0NkhxbE5xVzVWWXVWY0JhdTc2a0VzOUhLdWRkR2hjUUM0Z1JKOUh4QXVp?=
 =?utf-8?B?SHdGK3oyNzdQOFBPZ016dVc0OHpCSE9XYjVJMVhKM1RGUjBQQ2NTN251MThl?=
 =?utf-8?B?Q2RQLytjV20yUSt6ZGpGVUxiWnFVSnJPSlh5Q0hDVnI3YWlOSlduU0JNOTBK?=
 =?utf-8?B?Y20vcElCV3IyWkZpV1IyMUhiSmdITERLem5lZEFldmhqUGgydXZ1WUlFTEFJ?=
 =?utf-8?B?L0o2Q0trWGJpeWpnbEhpNFo4QTJxbnVvZWRGeHFLdXRaN2JYMHYvMEFXK1lD?=
 =?utf-8?B?MmJWQitodWJhQllKNXhGdmNMb3dFSEZKNCtwQndOeUdYUitiSHhQOU0xcjdk?=
 =?utf-8?B?M2tjb0hOQ2xQWmJoaCt2dzNRZnNuNnJ6bTlWT0o3ZUtoY29BRS9hSHYzRm5i?=
 =?utf-8?B?bGI5c3dITWNJWHl2VHdTUzEyYlN6aUxma0dUOHB4UEFaWDhsNDU5UUJVWFFK?=
 =?utf-8?B?Nlg1eDd6RlFkbURUMUZFMHlBcUlCMmFiMENueloxbzNtYTJZZk5wQ0orQUVY?=
 =?utf-8?B?eVpZR1Q5MDIwS2N1VFpHbWxxNjFxODlmR2xCZlZTY1crdEtNbnFscFJpK091?=
 =?utf-8?B?MjB6eWoyY1huOFU0TGRsVVBBVHlNcVpwRk5ON056SmhHRndaZTJVdVFNd2Vy?=
 =?utf-8?B?djFkZXpQeUhCNUQ4Q21HK0RRNVU2eWRyQVNDZHNXOHMrOUVjdS82MUFBa2Rj?=
 =?utf-8?Q?vr1URhUigsRawF2ePnEB0ErBF?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e7eea36a-bd9e-4981-98ec-08de15d221ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2025 03:28:58.6727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DBdgblgQTdHkhx/2218Ff4b3TMqEYsWXYK54s6JU8r6Zos7Iw/fP6/31l8YODGIimDPdCOHJLtC1K4Sx/pe2rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6280
X-OriginatorOrg: intel.com

PiBGcm9tOiBXaW5pYXJza2ksIE1pY2hhbCA8bWljaGFsLndpbmlhcnNraUBpbnRlbC5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgT2N0b2JlciAyMiwgMjAyNSA2OjQyIEFNDQo+ICsNCj4gK2Jvb2wg
eGVfc3Jpb3ZfdmZpb19taWdyYXRpb25fc3VwcG9ydGVkKHN0cnVjdCBwY2lfZGV2ICpwZGV2KTsN
Cj4gK2ludCB4ZV9zcmlvdl92ZmlvX3dhaXRfZmxyX2RvbmUoc3RydWN0IHBjaV9kZXYgKnBkZXYs
IHVuc2lnbmVkIGludCB2ZmlkKTsNCj4gK2ludCB4ZV9zcmlvdl92ZmlvX3N0b3Aoc3RydWN0IHBj
aV9kZXYgKnBkZXYsIHVuc2lnbmVkIGludCB2ZmlkKTsNCj4gK2ludCB4ZV9zcmlvdl92ZmlvX3J1
bihzdHJ1Y3QgcGNpX2RldiAqcGRldiwgdW5zaWduZWQgaW50IHZmaWQpOw0KPiAraW50IHhlX3Ny
aW92X3ZmaW9fc3RvcF9jb3B5X2VudGVyKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCB1bnNpZ25lZCBp
bnQgdmZpZCk7DQo+ICtpbnQgeGVfc3Jpb3ZfdmZpb19zdG9wX2NvcHlfZXhpdChzdHJ1Y3QgcGNp
X2RldiAqcGRldiwgdW5zaWduZWQgaW50IHZmaWQpOw0KPiAraW50IHhlX3NyaW92X3ZmaW9fcmVz
dW1lX2VudGVyKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCB1bnNpZ25lZCBpbnQgdmZpZCk7DQo+ICtp
bnQgeGVfc3Jpb3ZfdmZpb19yZXN1bWVfZXhpdChzdHJ1Y3QgcGNpX2RldiAqcGRldiwgdW5zaWdu
ZWQgaW50IHZmaWQpOw0KPiAraW50IHhlX3NyaW92X3ZmaW9fZXJyb3Ioc3RydWN0IHBjaV9kZXYg
KnBkZXYsIHVuc2lnbmVkIGludCB2ZmlkKTsNCj4gK3NzaXplX3QgeGVfc3Jpb3ZfdmZpb19kYXRh
X3JlYWQoc3RydWN0IHBjaV9kZXYgKnBkZXYsIHVuc2lnbmVkIGludCB2ZmlkLA0KPiArCQkJCWNo
YXIgX191c2VyICpidWYsIHNpemVfdCBsZW4pOw0KPiArc3NpemVfdCB4ZV9zcmlvdl92ZmlvX2Rh
dGFfd3JpdGUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIHVuc2lnbmVkIGludCB2ZmlkLA0KPiArCQkJ
CSBjb25zdCBjaGFyIF9fdXNlciAqYnVmLCBzaXplX3QgbGVuKTsNCj4gK3NzaXplX3QgeGVfc3Jp
b3ZfdmZpb19zdG9wX2NvcHlfc2l6ZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgdW5zaWduZWQgaW50
DQo+IHZmaWQpOw0KPiArDQoNCm5vbmUgb2YgdGhvc2UgaGVscGVycyB0aWVzIHRvIGFueSB2Zmlv
IHNwZWNpZmljIGxvZ2ljLiBzbyB0aGVyZSBpcyBubyBuZWVkDQp0byBoYXZlICd2ZmlvJyBleHBs
aWNpdGx5IGluIHRob3NlIGZ1bmN0aW9uIG5hbWVzLg0K

