Return-Path: <kvm+bounces-21666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 91861931D5C
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:57:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C9B11F2231F
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 22:57:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A0CA13E8A5;
	Mon, 15 Jul 2024 22:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B27dzxz9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78143BBC2;
	Mon, 15 Jul 2024 22:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721084261; cv=fail; b=Xu3kxEXQg9Atq7vDHqU+a0YAqo1uIO4QjSUaJ9ve4bu4/yBEaDi9TbmPqTbs4yz87gk/bSBPa/JG/hli5EJE5nExF3SUg3GnsifI6jG6V0OQdJ4DFWBYyintuvjqzwyD9mUC9rjQ2Alw6VtxjT7yjKyh0WWZ9jAy5Gccslky0G0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721084261; c=relaxed/simple;
	bh=+eB84sMKXsEDsZ4b5HJdW8IpxunrOutC1833Cv0GoDM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gWd77QDfqWFOUCjPHgBO29mUlSgUdoXZa4P4WoOJ8hxv07+QlAXMruGuOmxd1N2nnq8UsS+8svqQlQ+VjBMqEVOT3VXftV6lJzBIdhrc90zVZWxi0Vx+w6w/4oui92moJzm7vpIF+0WZB/qO4feyf1A5lw+0WCUphZmSItKP/ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B27dzxz9; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721084260; x=1752620260;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+eB84sMKXsEDsZ4b5HJdW8IpxunrOutC1833Cv0GoDM=;
  b=B27dzxz9CjjRJcJ2GWycCm2XvcePjCGRVaRM5qfR23pnT/dxQdJJN1eI
   uj1IABm0Xmo5jLBkeVgAeoAiTRnm+Y4CrokNqc9vvBOLOouZw2DZWa3RR
   3YX8IbYjjbgmp6+y25KoInv4TlsMw0Q4QNDHf7Uehl10U2PQHHiT6qE6q
   C2u8l24t9Heo/l9FhiT2GztrqbB68byZSUpaiKjhEfvLAJhQXvfUedvaA
   QxMtCp0pik4Os3PEFjUXyOBC+hxgp1uTMAqUlJ81Ns9hnqI5U3eki1LhU
   8ASEYG/9myIZmrfP9gctM73masLCIVY0KKiC9i4yiR/ULhQJPJAfvRsQz
   g==;
X-CSE-ConnectionGUID: dcOm0DooR7GSShxaD/tNtA==
X-CSE-MsgGUID: Hy3xO1E0SZSYizlbc1RvYA==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="18202410"
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="18202410"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 15:57:39 -0700
X-CSE-ConnectionGUID: bW3SFUBTQHuPPUikfNsnYw==
X-CSE-MsgGUID: EVczs9pURb2a6ataxa42iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,211,1716274800"; 
   d="scan'208";a="49534152"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 15:57:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 15:57:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 15:57:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 15:57:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JuSJSJANDf+B16JEtybIbkCvbLX4v8U3kJK/hBW29+uKiZHL8bPhTmFeq3EtAMchcImWdXLWQnOI9WtpJhFTH/9Jk2oqfPld+34MWiERexM8iVyg3chDAuFC/AOFrqiljAXzCMAEcWNBeFbfknieDbdZZjYU9srWoP8e4x2iWl1otbHtA99BvDTZq9hS93/x7V7Qq2fZ15S3gXPO/Hbwxz9wtzxucsWJpiUNktQEsLzJP1EOP9x9sHT2Lg2MYgFGdjhjYl0rNpi8Fz0hFfyhfXfiUgUsJGr367jAMt/fSVKkgSDl2qmaNpWQGK/NvyhxuJZb1aLnvvaMyyNUgMd0qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+eB84sMKXsEDsZ4b5HJdW8IpxunrOutC1833Cv0GoDM=;
 b=p/Ucj8CLYf+AdhkR96zxPpTbgZliVNKOJHbZ0rrrQIhTWktXmY0/c05y3BRFGOZv3PtdMwqhYluCkhe7xGCLkJh3QI4QI+XWY+WeT7hxKJI2aV0rHfE5285oyPaUXj41xMnUAZxUaJ8qwD1Fj20MFwKlI50+pIG+/bCaO+J3J2/9GgFUpO6hp+7vD9MgSSpsh1VDO42skqZF0Uk5RU7U5+yWzCoHSLd/IN1Y+BJRq9AbLf2ccE+8PbALelCmbcyGqOpRodkzsYO1bMe4W43mrBxI4DcgQ8jVt7o9TT7hHJcd6LNc18vLWYJWy/XLQOMxEEdn1r8YfcDdgSxyVL8r+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6293.namprd11.prod.outlook.com (2603:10b6:8:97::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 15 Jul
 2024 22:57:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 22:57:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Thread-Topic: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Thread-Index: AQHa1MP6tknHBB/QAEixGUJsVbkOOLH0cD8AgACr4wCAAJjdgIACRAmAgABeroCAABOEAA==
Date: Mon, 15 Jul 2024 22:57:35 +0000
Message-ID: <00f105e249b7def9f5631fb2b0fa699688ece4c2.camel@intel.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
	 <20240711222755.57476-10-pbonzini@redhat.com>
	 <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
	 <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
	 <97796c0b86db5d98e03c119032f5b173f0f5de14.camel@intel.com>
	 <n2nmszmuok75wzylgcqy2dz4lbrvfavewuxas56angjrkp3sl3@k4pj5k7uosfe>
	 <CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com>
	 <i4gor4ugezj5ma4l6rnfqanylw6qsvh6rvlqk72ezuadxq6dkn@yqgr5iq3dqed>
In-Reply-To: <i4gor4ugezj5ma4l6rnfqanylw6qsvh6rvlqk72ezuadxq6dkn@yqgr5iq3dqed>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6293:EE_
x-ms-office365-filtering-correlation-id: 6058da30-23da-43cd-4824-08dca5218478
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bmhLaWFmbW5pUUQ5aDJsam1nbzNhMVVXeVhrZE9jRkxLUlVXamVqVVU4aEdh?=
 =?utf-8?B?ZGtLbnVSaVpuYUJxYk44VjdHZEpmL1pMZVRHRUQ5RlBsQ2s1N1krNlNNQ0h6?=
 =?utf-8?B?VUxnaHFnRTVWL3JUaXBtZWxoOG16am90VVB0OWk2UEtYQllDdzZCZmM0d3pI?=
 =?utf-8?B?b2srMjNsS0Y2UWovSWgyUmE1U25SL2NVTkJ0WktZNTZtQXI3M29vTEdmMTRm?=
 =?utf-8?B?VjZ3dE96a243K2Y1UXVlcm1pb0JvZmdOdmFWVTFORjZrY292NXp6WW04TUsw?=
 =?utf-8?B?Z2ZDNUJUZSt3aWZsdngwTXE0aThaK1dXZzl5K0ZhLzg2QTBBRk5oUEpIYzhF?=
 =?utf-8?B?cFhrTjU3bkhhcERIOVpIZ0NNdHA2anNaL2ZrL2cvTkN5Tk50U0sxTmtwdGZp?=
 =?utf-8?B?NEwxeE1BdTJPQThHVGlqdU5VSkl2aThGNXUvZThnRGwwS0tmYkNDUURQaGlZ?=
 =?utf-8?B?N2dkWnByTG5rYXpMZUIvMzYwOURTVnFuRndLUzd3NkJyS25JVks5U3hsVVhR?=
 =?utf-8?B?VEcyYlF4STJuU1RUZ240MDlDY0ozZFcxeGMwekxZVlF3R3poejkvZUQ1TDhZ?=
 =?utf-8?B?S2l0eFM4b0FiRUNRMkpEbjI4dENHZWhjektUM1ZVamxMNkJ3NXc5RHd2K3p4?=
 =?utf-8?B?MWRNRmZlMjhVQlhTUDZ2NkJ0L2x4R3hnUWg0a2lKdVhBRE55dXI3Wm5EMWty?=
 =?utf-8?B?SndBRnBCVVQ5dDBGM1VhNGlsbWxjTnV4TEYxYkt3SUpJUDQvN2NONzRpRXVP?=
 =?utf-8?B?SWhScEd5L3BocHJVNGFRTDZPaGYyb3VqMWFoREtTYzJBME9EelFLZmlETWtE?=
 =?utf-8?B?YVBib05kTmVYNzh4UTVTOVczQm9yWU9Dd0JjbzlZVDBObDZ3cllHNTYvb2lL?=
 =?utf-8?B?R1M2SHNQV2xYWFpjbzNwZDdhZmRhSHBCSXl2MU1Ub1dYZDhMNmVjUlNUWlJz?=
 =?utf-8?B?RGxOS2hQNGV0czJOMmFhc0dWWmhYTHBDTWFwTzVXcTFwOWF0WjhJTTk4ZDg4?=
 =?utf-8?B?cUp0VWtBQ2JueUxJb1lpanM4S0JPck5nN1VsWGdZRlBoMUVOc2F3UDNPV1BO?=
 =?utf-8?B?T3hJNWxqbm8wUzZ5WFh6cHZsV3BvaUJoQzFTendXNUk5YW1uTkJjUXo4SjR6?=
 =?utf-8?B?bzRndlFvd3hMTW1OTmpNZmxyK0E2MVFDd3RudE9RdUxFeXQrNExWR0NZQ1VJ?=
 =?utf-8?B?V0lZWjhpYk5tQVpJSDhHeTVERlRic1Z1VSsyZlZNR1kvSFpkTnZYTGc2Qzlu?=
 =?utf-8?B?MTBpZWtVeGQ0SE9VL0NScURzVDQ2WUlXaXdnQmYzTzQrWWVUZHk1M3Z2Ukk4?=
 =?utf-8?B?cjBtZGJmcFA2ME5KNEJOcTArSnJVOXhOVEtuUHZVWmRjM1lHUEVmTW11L2Yz?=
 =?utf-8?B?dUYwMlFUdTVMUU5zOXJzRWd1bXlyZmFhNVF1cWtLZGh5cUhWWXZ0eTAwZ3VN?=
 =?utf-8?B?VlovTFJPU21leXdyNHRJNnFadGxQTHp2VW9iNlJrNFZrYjg0MjlpZ3JQVmRP?=
 =?utf-8?B?VmF5b0hnRU8xbHY1bUZkMCs5cFk4eXd3Y0F6WWN1NXFnY1Q0MlF2aldPeFdz?=
 =?utf-8?B?RW9xa0JQdldsT1NJT0RhSTJBYmovaHN6VFpVQ2NhTWdZQmZxVldGemY2R3cv?=
 =?utf-8?B?bUo5NjNjeUM1ZHdaRDAyMnlacUUrMDUrU0R5L2VZVWU2aTV1M2F5T1FobERE?=
 =?utf-8?B?MlZOYnYxUzlqYU9aS1N3ME1haWZYY3JZbmN5WFFLRlIzcjNoL20weUpER0FE?=
 =?utf-8?B?MkFYNXdCbDlLMVlTY3A0bjNVc3phSFQwazFWTHBnbXArckY4bWRzU2hrb21Z?=
 =?utf-8?Q?+4+8FQplNyvsG0Cr+rkcvBnxOkHoQ5llKol+U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGc1ZXltQ3lQU2p0SDRETU4vY3IvUmJIUGtPUlp4WUR1dG43SjV1U0pHY3dn?=
 =?utf-8?B?bWxaRzYzYzIwL3p1QVlrdjNyOWl3anVBWVR3dCtjR0x2VGtlL0Y3TGJBWDds?=
 =?utf-8?B?dkZUMnVFVDFDVU9mam5NV2l0NzJhamJUejVaNUlseHpiemlCQnpIcHU1dnJX?=
 =?utf-8?B?MktRemFORERrSTNjZTFYWGN0cVprdUEwdTg3enp3VlhqYXVIUHVrZUt3ek04?=
 =?utf-8?B?WDAzUU53MVRGRmQ0Ykt6OHNteStVS2dTVE4yYnFFZTV1Y0E4aE1NVngyUlda?=
 =?utf-8?B?aVhnbmFMMWJnT2RjbmlJdmNOSytGV3czRTVpZHFSQ1pMZS9sajdreVVGWWhC?=
 =?utf-8?B?aVlUQlNtRFFEekVzZE8veUVWeEZ5VHpMeS9CcFV0SEFwSHp5Q3ZyOE5mZC90?=
 =?utf-8?B?U2JBTXRoWkVoaGVXdnRPYWRyaG01YUJ2aE1PSU9qaGdSTUVVdGQ5T290YzM3?=
 =?utf-8?B?VGJDdm5EK205WjdUSmpSaU1VbFdsM1FOdEwwTkdOczdPOUhRUmtnd1VRb0xi?=
 =?utf-8?B?OGJ0ME5OQ0ExSE9TTUttcThBQTI0NWM1cHZDTU1mTEZpMmZaVDdFYXkzRytV?=
 =?utf-8?B?eCt1K2Z4WWpQbVhuTldiaGJJd0t3cEo0SEhRTDRlRUlSZWdVWW1OVFF4NDJO?=
 =?utf-8?B?KzdXaWFxZmszSkVMdmxsN1dpeFA4Vy9sbEptYm5XUXJ1dVJlcVltZVJWanY3?=
 =?utf-8?B?OEdBRzhIYmxDVS9LTm9tdTVDRiszQS84cGtNOGFFS0tKOGNlU0x0WGFUU2xz?=
 =?utf-8?B?LzlMTWI5V0NwWUczQW91OEFMaUw1WEMrSDVXVUxoOFhwV2xwZ0ZuUThkL21I?=
 =?utf-8?B?Tmd0NS9QQlcxb2pvWmZQTmhRRXJCUUJ5eDFrOGVzSWVPZ1JFaWtOUVR3QXB3?=
 =?utf-8?B?MFg5amZYWjlJQ3RNaTVXQWNndm83bjFFcDd5VFRRV2FYWHdtYVh1Wm1CSnZE?=
 =?utf-8?B?b2c5aXhWWG1SNGhML2Ixd0tnQ3VHOGlnNmdZR0VzMlpMUzFjcGR6akxJY2Vo?=
 =?utf-8?B?NDlDbHZXSzRpNkRuekd5Z3V6RnA0UStMbENMb2oxbDVwZ1IrRCs1T0dBL2Fz?=
 =?utf-8?B?bTFQenR3SXdpbVd5S1d3VUdvMS9jTSt4SlhySXJyajFmdWlQVGxtK3luOEYz?=
 =?utf-8?B?OW84ZFBJN2V3N2VETm11c1oxV1ZxUDBLaGFxSnB6RmpWalhHSC9OOVUveUFj?=
 =?utf-8?B?UENmdW5SMXU3eGtFSWVHUEdiZFJRZkgrRHQxUmxMakFqMTVVR2ppVEFjcit1?=
 =?utf-8?B?dzBzcllVdi9NT2tvK0hOKzc2b3dleFhrcnF3VFFrc0FZMmQxQTl0KzFoREFN?=
 =?utf-8?B?RjR4NUdDdVpQcjRoYjJpNTRHVkVHU1JEUVJtU1NJNkFiMGFXWVRPRm1aczNZ?=
 =?utf-8?B?L1NuczU1TDBHZjJKeUxIb3dVZ253dXZsd01zNThiYXdXSExXeFZXVzhuaUt1?=
 =?utf-8?B?QzIwbGJmYW1TTnBLRHF0Zy9BMmdBWG9TMkRBdHZEZElkTUwyNU1ZZEd4clg0?=
 =?utf-8?B?d2lDYm1iTFF6Vm9IZFRKUVo4QUlQQjRaa1dsWUJBeUxwRVdNSTRnYnNEcEY1?=
 =?utf-8?B?allYRWpENC9xZFhCS2thZ2tNNmZ0RDhUOElMcVJhRE1SM0pka09Mdm9TZUZa?=
 =?utf-8?B?UXlwMXJ1dXc2c0tjQnd3K01mckZFcnJIVDZpRzROcWVaSGtYV3hYbDZOS2gv?=
 =?utf-8?B?bzc1c2NwTFFwTWtjZER2S3lPVnNTbURTZVQ2dHRtd0d5Vlp6NXVVSlhINWlq?=
 =?utf-8?B?SVF3NnlEN0xiQWZJaEVaVmh3WHdWUXV3NWZZTTZzRXpTTzRwRHFHTFYveFNw?=
 =?utf-8?B?dlVyRm1KS0R1cmxtSzJXeWphRTcycEpzdzB2NlU0bmtvR04xSkozaVB0UXJj?=
 =?utf-8?B?bXhLeGk3anN0MktzRFRxVFJTOGtqSEpCeDA1TnVUSUtrWjhLdGdYaWl3cGtY?=
 =?utf-8?B?WG9Jd2R5cnFkMkVEQ251QTY1bTh2TnhkMUpNaS9JbUo5Y1o3Z0FRVDdDUVlR?=
 =?utf-8?B?R2RPelR0cVR5ZGFuY3FPUWhqYytZQ2s2cDQ1VHoxajA1bEc3a3pSZm96Snk5?=
 =?utf-8?B?aWlKZ29pZm4vUzdXNWJIQ1ZyMDhnaytpRVJKSTBVNXpSUi96anRiMnFRK2dw?=
 =?utf-8?B?ZlYwdEY4Q09WU1oxVi91QUNiYllFUW1mWSszYUEybGNIbG00b1RjdFF6alZp?=
 =?utf-8?B?SWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D58AACBBB172B48A1D0E95CCE90E27D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6058da30-23da-43cd-4824-08dca5218478
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 22:57:35.4334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6JcB2K2UbA/eZcban1j16Dr1/Nk0YjfwgTK2Wa6d03RcULT+knFYLVNj47tbP+pPEhvwa96jlULJoHeux6o13miT1o0mmWfpr3RgtCyL21s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6293
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA3LTE1IGF0IDE2OjQ3IC0wNTAwLCBNaWNoYWVsIFJvdGggd3JvdGU6DQo+
IE1ha2VzIHNlbnNlLg0KPiANCj4gSWYgd2UgZG9jdW1lbnQgbXV0dWFsIGV4Y2x1c2lvbiBiZXR3
ZWVuIHJhbmdlcyB0b3VjaGVkIGJ5DQo+IGdtZW1fcG9wdWxhdGUoKSB2cyByYW5nZXMgdG91Y2hl
ZCBieSBhY3R1YWwgdXNlcnNwYWNlIGlzc3VhbmNlIG9mDQo+IEtWTV9QUkVfRkFVTFRfTUVNT1JZ
IChhbmQgbWFrZSBzdXJlIG5vdGhpbmcgdG9vIGNyYXp5IGhhcHBlbnMgaWYgdXNlcnMNCj4gZG9u
J3QgYWJpZGUgYnkgdGhlIGRvY3VtZW50YXRpb24pLCB0aGVuIEkgdGhpbmsgbW9zdCBwcm9ibGVt
cyBnbyBhd2F5Li4uDQo+IA0KPiBCdXQgdGhlcmUgaXMgc3RpbGwgYXQgbGVhc3Qgb25lIGF3a3dh
cmQgY29uc3RyYWludCBmb3IgU05QOg0KPiBLVk1fUFJFX0ZBVUxUX01FTU9SWSBjYW5ub3QgYmUg
Y2FsbGVkIGZvciBwcml2YXRlIEdQQSByYW5nZXMgdW50aWwgYWZ0ZXINCj4gU05QX0xBVU5DSF9T
VEFSVCBpcyBjYWxsZWQuIFRoaXMgaXMgdHJ1ZSBldmVuIGlmIHRoZSBHUEEgcmFuZ2UgaXMgbm90
DQo+IG9uZSBvZiB0aGUgcmFuZ2VzIHRoYXQgd2lsbCBnZXQgcGFzc2VkIHRvDQo+IGdtZW1fcG9w
dWxhdGUoKS9TTlBfTEFVTkNIX1VQREFURS4gVGhlIHJlYXNvbiBmb3IgdGhpcyBpcyB0aGF0IHdo
ZW4NCj4gYmluZGluZyB0aGUgQVNJRCB0byB0aGUgU05QIGNvbnRleHQgYXMgcGFydCBvZiBTTlBf
TEFVTkNIX1NUQVJULCBmaXJtd2FyZQ0KPiB3aWxsIHBlcmZvcm0gY2hlY2tzIHRvIG1ha2Ugc3Vy
ZSB0aGF0IEFTSUQgaXMgbm90IGFscmVhZHkgYmVpbmcgdXNlZCBpbg0KPiB0aGUgUk1QIHRhYmxl
LCBhbmQgdGhhdCBjaGVjayB3aWxsIGZhaWwgaWYgS1ZNX1BSRV9GQVVMVF9NRU1PUlkgdHJpZ2dl
cmVkDQo+IGZvciBhIHByaXZhdGUgcGFnZSBiZWZvcmUgY2FsbGluZyBTTlBfTEFVTkNIX1NUQVJU
Lg0KPiANCj4gU28gd2UgaGF2ZSB0aGlzIGNvbnN0cmFpbnQgdGhhdCBLVk1fUFJFX0ZBVUxUX01F
TU9SWSBjYW4ndCBiZSBpc3N1ZWQNCj4gYmVmb3JlIFNOUF9MQVVOQ0hfU1RBUlQuIFNvIGl0IG1h
a2VzIG1lIHdvbmRlciBpZiB3ZSBzaG91bGQganVzdCBicm9hZGVuDQo+IHRoYXQgY29uc3RyYWlu
dCBhbmQgZm9yIG5vdyBqdXN0IGRpc2FsbG93IEtWTV9QUkVfRkFVTFRfTUVNT1JZIHByaW9yIHRv
DQo+IGZpbmFsaXppbmcgYSBndWVzdCwgc2luY2UgaXQnbGwgYmUgZWFzaWVyIHRvIGxpZnQgdGhh
dCByZXN0cmljdGlvbiBsYXRlcg0KPiB2ZXJzdXMgZGlzY292ZXJpbmcgc29tZSBvdGhlciBzb3J0
IG9mIGVkZ2UgY2FzZSBhbmQgbmVlZCB0bw0KPiByZXRyb2FjdGl2ZWx5IHBsYWNlIHJlc3RyaWN0
aW9ucy4NCj4gDQo+IEkndmUgdGFrZW4gSXNha3UncyBvcmlnaW5hbCBwcmVfZmF1bHRfbWVtb3J5
X3Rlc3QgYW5kIGFkZGVkIGEgbmV3DQo+IHg4Ni1zcGVjaWZpYyBjb2NvX3ByZV9mYXVsdF9tZW1v
cnlfdGVzdCB0byB0cnkgdG8gYmV0dGVyIGRvY3VtZW50IGFuZA0KPiBleGVyY2lzZSB0aGVzZSBj
b3JuZXIgY2FzZXMgZm9yIFNFViBhbmQgU05QLCBidXQgSSdtIGhvcGluZyBpdCBjb3VsZA0KPiBh
bHNvIGJlIHVzZWZ1bCBmb3IgVERYIChoZW5jZSB0aGUgZ2VuZXJpYyBuYW1lKS4gVGhlc2UgYXJl
IGJhc2VkIG9uDQo+IFByYXRpaydzIGluaXRpYWwgU05QIHNlbGZ0ZXN0cyAod2hpY2ggYXJlIGlu
IHR1cm4gYmFzZWQgb24ga3ZtL3F1ZXVlICsNCj4gdGhlc2UgcGF0Y2hlcyk6DQo+IA0KPiDCoCBo
dHRwczovL2dpdGh1Yi5jb20vbWRyb3RoL2xpbnV4L2NvbW1pdHMvc25wLXVwdG9kYXRlMC1rc3Qv
DQo+IMKgDQo+IGh0dHBzOi8vZ2l0aHViLmNvbS9tZHJvdGgvbGludXgvY29tbWl0L2RkN2Q0YjE5
ODNjZWViNjUzMTMyY2ZkNTRhZDYzZjU5N2RiODVmNzQNCj4gDQo+IA0KDQpGcm9tIHRoZSBURFgg
c2lkZSBpdCB3b3VsZG4ndCBiZSBob3JyaWJsZSB0byBub3QgaGF2ZSB0byB3b3JyeSBhYm91dCB1
c2Vyc3BhY2UNCm11Y2tpbmcgYXJvdW5kIHdpdGggdGhlIG1pcnJvcmVkIHBhZ2UgdGFibGVzIGlu
IHVuZXhwZWN0ZWQgd2F5cyBkdXJpbmcgdGhlDQpzcGVjaWFsIHBlcmlvZC4gVERYIGFscmVhZHkg
aGFzIGl0cyBvd24gImZpbmFsaXplZCIgc3RhdGUgaW4ga3ZtX3RkeCwgaXMgdGhlcmUNCnNvbWV0
aGluZyBzaW1pbGFyIG9uIHRoZSBTRVYgc2lkZSB3ZSBjb3VsZCB1bmlmeSB3aXRoPw0KDQpJIGxv
b2tlZCBhdCBtb3ZpbmcgZnJvbSBrdm1fYXJjaF92Y3B1X3ByZV9mYXVsdF9tZW1vcnkoKSB0byBk
aXJlY3RseSBjYWxsaW5nDQprdm1fdGRwX21hcF9wYWdlKCksIHNvIHdlIGNvdWxkIHBvdGVudGlh
bGx5IHB1dCB3aGF0ZXZlciBjaGVjayBpbg0Ka3ZtX2FyY2hfdmNwdV9wcmVfZmF1bHRfbWVtb3J5
KCkuIEl0IHJlcXVpcmVkIGEgY291cGxlIGV4cG9ydHM6DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9rdm0vbW11LmggYi9hcmNoL3g4Ni9rdm0vbW11LmgNCmluZGV4IDAzNzM3ZjNhYWVlYi4uOTAw
NGFjNTk3YTg1IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL21tdS5oDQorKysgYi9hcmNoL3g4
Ni9rdm0vbW11LmgNCkBAIC0yNzcsNiArMjc3LDcgQEAgZXh0ZXJuIGJvb2wgdGRwX21tdV9lbmFi
bGVkOw0KICNlbmRpZg0KIA0KIGludCBrdm1fdGRwX21tdV9nZXRfd2Fsa19taXJyb3JfcGZuKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTY0IGdwYSwga3ZtX3Bmbl90DQoqcGZuKTsNCitpbnQga3Zt
X3RkcF9tYXBfcGFnZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90IGdwYSwgdTY0IGVycm9y
X2NvZGUsIHU4DQoqbGV2ZWwpOw0KIA0KIHN0YXRpYyBpbmxpbmUgYm9vbCBrdm1fbWVtc2xvdHNf
aGF2ZV9ybWFwcyhzdHJ1Y3Qga3ZtICprdm0pDQogew0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2
bS9tbXUvbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQppbmRleCA3YmI2YjE3YjQ1NWYu
LjRhM2U0NzFlYzlmZSAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCisrKyBi
L2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCkBAIC00NzIxLDggKzQ3MjEsNyBAQCBpbnQga3ZtX3Rk
cF9wYWdlX2ZhdWx0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0DQprdm1fcGFnZV9mYXVs
dCAqZmF1bHQpDQogICAgICAgIHJldHVybiBkaXJlY3RfcGFnZV9mYXVsdCh2Y3B1LCBmYXVsdCk7
DQogfQ0KIA0KLXN0YXRpYyBpbnQga3ZtX3RkcF9tYXBfcGFnZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIGdwYV90IGdwYSwgdTY0IGVycm9yX2NvZGUsDQotICAgICAgICAgICAgICAgICAgICAgICAg
ICAgdTggKmxldmVsKQ0KK2ludCBrdm1fdGRwX21hcF9wYWdlKHN0cnVjdCBrdm1fdmNwdSAqdmNw
dSwgZ3BhX3QgZ3BhLCB1NjQgZXJyb3JfY29kZSwgdTgNCipsZXZlbCkNCiB7DQogICAgICAgIGlu
dCByOw0KIA0KQEAgLTQ3NTksNiArNDc1OCw3IEBAIHN0YXRpYyBpbnQga3ZtX3RkcF9tYXBfcGFn
ZShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIGdwYV90DQpncGEsIHU2NCBlcnJvcl9jb2RlLA0KICAg
ICAgICAgICAgICAgIHJldHVybiAtRUlPOw0KICAgICAgICB9DQogfQ0KK0VYUE9SVF9TWU1CT0xf
R1BMKGt2bV90ZHBfbWFwX3BhZ2UpOw0KIA0KIGxvbmcga3ZtX2FyY2hfdmNwdV9wcmVfZmF1bHRf
bWVtb3J5KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIHN0cnVjdCBrdm1fcHJlX2ZhdWx0X21lbW9yeSAqcmFuZ2UpDQpAQCAtNTc3MCw2
ICs1NzcwLDcgQEAgaW50IGt2bV9tbXVfbG9hZChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQogb3V0
Og0KICAgICAgICByZXR1cm4gcjsNCiB9DQorRVhQT1JUX1NZTUJPTF9HUEwoa3ZtX21tdV9sb2Fk
KTsNCiANCiB2b2lkIGt2bV9tbXVfdW5sb2FkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiB7DQpk
aWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4
LmMNCmluZGV4IDlhYzA4MjFlYjQ0Yi4uNzE2MWVmNjhmM2RhIDEwMDY0NA0KLS0tIGEvYXJjaC94
ODYva3ZtL3ZteC90ZHguYw0KKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KQEAgLTI4MDks
MTEgKzI4MDksMTMgQEAgc3RydWN0IHRkeF9nbWVtX3Bvc3RfcG9wdWxhdGVfYXJnIHsNCiBzdGF0
aWMgaW50IHRkeF9nbWVtX3Bvc3RfcG9wdWxhdGUoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4s
IGt2bV9wZm5fdCBwZm4sDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgdm9pZCBf
X3VzZXIgKnNyYywgaW50IG9yZGVyLCB2b2lkICpfYXJnKQ0KIHsNCisgICAgICAgdTY0IGVycm9y
X2NvZGUgPSBQRkVSUl9HVUVTVF9GSU5BTF9NQVNLIHwgUEZFUlJfUFJJVkFURV9BQ0NFU1M7DQog
ICAgICAgIHN0cnVjdCBrdm1fdGR4ICprdm1fdGR4ID0gdG9fa3ZtX3RkeChrdm0pOw0KICAgICAg
ICBzdHJ1Y3QgdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZV9hcmcgKmFyZyA9IF9hcmc7DQogICAgICAg
IHN0cnVjdCBrdm1fdmNwdSAqdmNwdSA9IGFyZy0+dmNwdTsNCiAgICAgICAgc3RydWN0IGt2bV9t
ZW1vcnlfc2xvdCAqc2xvdDsNCiAgICAgICAgZ3BhX3QgZ3BhID0gZ2ZuX3RvX2dwYShnZm4pOw0K
KyAgICAgICB1OCBsZXZlbCA9IFBHX0xFVkVMXzRLOw0KICAgICAgICBzdHJ1Y3QgcGFnZSAqcGFn
ZTsNCiAgICAgICAga3ZtX3Bmbl90IG1tdV9wZm47DQogICAgICAgIGludCByZXQsIGk7DQpAQCAt
MjgzMiw2ICsyODM0LDEwIEBAIHN0YXRpYyBpbnQgdGR4X2dtZW1fcG9zdF9wb3B1bGF0ZShzdHJ1
Y3Qga3ZtICprdm0sIGdmbl90DQpnZm4sIGt2bV9wZm5fdCBwZm4sDQogICAgICAgICAgICAgICAg
Z290byBvdXRfcHV0X3BhZ2U7DQogICAgICAgIH0NCiANCisgICAgICAgcmV0ID0ga3ZtX3RkcF9t
YXBfcGFnZSh2Y3B1LCBncGEsIGVycm9yX2NvZGUsICZsZXZlbCk7DQorICAgICAgIGlmIChyZXQg
PCAwKQ0KKyAgICAgICAgICAgICAgIGdvdG8gb3V0X3B1dF9wYWdlOw0KKw0KICAgICAgICByZWFk
X2xvY2soJmt2bS0+bW11X2xvY2spOw0KIA0KICAgICAgICByZXQgPSBrdm1fdGRwX21tdV9nZXRf
d2Fsa19taXJyb3JfcGZuKHZjcHUsIGdwYSwgJm1tdV9wZm4pOw0KQEAgLTI5MTAsNiArMjkxNiw3
IEBAIHN0YXRpYyBpbnQgdGR4X3ZjcHVfaW5pdF9tZW1fcmVnaW9uKHN0cnVjdCBrdm1fdmNwdSAq
dmNwdSwNCnN0cnVjdCBrdm1fdGR4X2NtZCAqYw0KICAgICAgICBtdXRleF9sb2NrKCZrdm0tPnNs
b3RzX2xvY2spOw0KICAgICAgICBpZHggPSBzcmN1X3JlYWRfbG9jaygma3ZtLT5zcmN1KTsNCiAN
CisgICAgICAga3ZtX21tdV9yZWxvYWQodmNwdSk7DQogICAgICAgIHJldCA9IDA7DQogICAgICAg
IHdoaWxlIChyZWdpb24ubnJfcGFnZXMpIHsNCiAgICAgICAgICAgICAgICBpZiAoc2lnbmFsX3Bl
bmRpbmcoY3VycmVudCkpIHsNCg0K

