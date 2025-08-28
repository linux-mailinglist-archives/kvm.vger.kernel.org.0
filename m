Return-Path: <kvm+bounces-56015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56039B39187
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 04:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E0EA3BE148
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C717246BB9;
	Thu, 28 Aug 2025 02:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TtpypLmU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1497230CD89;
	Thu, 28 Aug 2025 02:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756347227; cv=fail; b=qcdAnFk6eEsdQpfw8nZdQ2SZ8fqRfERYZ2rU2mczemDOPyrkAkNDo3FmgrfPLM5HRJbALXJ/xf2f/keJB6b4C+1O0SzbtvIz0rolNTTbhkPPc13hKW+S8DkQ3wYCUFc1umjADX7OVbkmpLGihv+GIdVTVDFLPTZXzPPD0GkZRqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756347227; c=relaxed/simple;
	bh=rr0b3xjfS33SMTI18tVX6lsGFY8bPYkHkDUvGCPTpNQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=n2DUecZLPFzkiLfe7vgnipc6gtBNqScnhUP9/m8dNkq1nnGp2h8pRhuzTRjWLE2hLCQyIzWDa+nZcNwTOIqZB1Ojyo8cVgdWQfHzcZPkWgRM5Q62fb4LQ+5i2ngz1F9u1/RKm3SId/fG1st00ZBccD5zMeOXh5OgrV4s9ujg7jQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TtpypLmU; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756347226; x=1787883226;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rr0b3xjfS33SMTI18tVX6lsGFY8bPYkHkDUvGCPTpNQ=;
  b=TtpypLmUtDDKu4LzsUxObsoi1bUN3g9wsYpxn5iFeQLEdgexv4Zrl6h9
   zIXOpQPWouLeOyt+2/nN7o1bGUiEofLpYg7kTbrhRpaL/s4uKoDqeWZO1
   xGo2qsmHWmMirmYcr4OoTBb+wZvXym/4x+dJ/aDru29ubbvUOv/RPMQX3
   1CXTfjTfArCszs454pG5gwKc3rEM2JI//qqkFZUGldx72R+loqzPM615p
   2gTVqx8krI/G6b8uiVct0omeUtXSCDQ7GQMYYeYOk+SQXL1lj3sBCR4vn
   5jG9QFahHiNRlTGijsQs1uEDEu4xCoBHx2JEOSsU94L7FN+reYea2nPqn
   w==;
X-CSE-ConnectionGUID: H/2VcgNZSRaJUzB2jcfJBg==
X-CSE-MsgGUID: e1d5IRKVQQyEgt+JMyE5fg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58531851"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58531851"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:13:45 -0700
X-CSE-ConnectionGUID: I3DtMDPLTXmZwAPHPOuEKg==
X-CSE-MsgGUID: FhaxxwftTDaXN6Msn4ujYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="175257992"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:13:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:13:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 19:13:44 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.44) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:13:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N9lht7pR66KzO/re/XB+77iJfwWuzuNsyLQEB4htU1opja+2xDTPnA+DC3uGWj5mRn/zcMagA6fC1P0IhC/pG86Aq8bFJRn3a15iAtwYQk/RL/wtZrLQ2PjEPBciBOb8/yOYBAk++l5PNxH0YFXL3OWlT/12GPcVhczXXq+QEe9Rb0IhTTw3rBWyKz8sL187Bj2woUIMNx6iPVBrJAUTXYLB/2iPbBAq8JLoVWnd2LnDEAGvGWYcu2MqFkdFMqgmsS++tNPWIfnxkbbD3IFBKlC6Z4vgCYix7cmocs1pSN3eFkvsUwomnY5+UT8duFbeey/P2Y1xh57f1CQQkt5NnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rr0b3xjfS33SMTI18tVX6lsGFY8bPYkHkDUvGCPTpNQ=;
 b=RwTexo+HfGvb2yiJO2V5kxwSfXgMd1N0HIpePAVg45V5E0HkcIkvaHmYAlNDYTZVG5E+Lo2bhnwVJ/8iiyuGm+wXXLjHktvHD3b00v3wb2o8WhYWS5iZvP+LOOHH4TNGzAhqYQWi7cecCfkhkC41byJR0tYTs+9hY40oIZicc4SHmLGSTpxtyvlXLJ4N6FXjaacoScrvnN8xoVi+HOvoMp/TZAcDNY8PQA+1LcNfHjIzEgqwF432b6pBJ0nl/w2fSLTA8VcJcwGNXKgQgd+ElJf+bUrAwEYx4pJMmxp9aqx6fzB6LgXG0adfzORux8I8Nu+NvaxTOXsUTwmwMSblnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ0PR11MB5919.namprd11.prod.outlook.com (2603:10b6:a03:42d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Thu, 28 Aug
 2025 02:13:36 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 02:13:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 01/12] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
Thread-Topic: [RFC PATCH 01/12] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
Thread-Index: AQHcFuZd+OjdBq/Ez0aPEIyR2kpOIrR3VOiA
Date: Thu, 28 Aug 2025 02:13:36 +0000
Message-ID: <3e2d9f4a1e886721e59452a0cd5d553f0d32d7f1.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-2-seanjc@google.com>
In-Reply-To: <20250827000522.4022426-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ0PR11MB5919:EE_
x-ms-office365-filtering-correlation-id: 9fb70364-6f54-4edc-8d7c-08dde5d87eff
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cUtXaUQxRDJZZ0lhL2NXdER2OVlVOU9STTgrbC8wMlluL2Fkb2o0Yjc2Vito?=
 =?utf-8?B?TjVqSWpTSFQ3L010bnJ1OFhINlh3SVNBbWZDc0h2bEZrNGp6ZzNJUkxRelNS?=
 =?utf-8?B?N2VtWkEzM0ExNHRINU9weExTUitOTUdaeDdrNnVOM2JVbGFNYTh0aFNpRVZF?=
 =?utf-8?B?NWIza0VrWGdBdzlEWmIxaHh4TmhZdEx2YzNyQjdDeGs3b21nbEptTTFHczNH?=
 =?utf-8?B?N3BGbDJtc3ArSlU0eEVZZnZuTU92Y3dHTHh0cjhTZTBvZVI3NHl6WlZXWWlr?=
 =?utf-8?B?L0NpeWhrOFZwR3VCSUIrNzNrNGprQjZYMWdsQkpXWTN3V09kYmF1VmxtTExj?=
 =?utf-8?B?Q3lPTTBTMXNucFgwMnI2OXkzYjkrZXRPNkJTOTRaOU9UMkdKRm04S0FrVWpq?=
 =?utf-8?B?VVI3Wm83alphQjA2ak1EODdhRXVFd01TN3MyU2Y5WjE4TmVCK2pXM3VBcTYr?=
 =?utf-8?B?QlFwZDBKYTBMZUVPOFI2dkNIUE1KU2pvTkx3UnM4OWQvdGtLRWE1eVN2eFE0?=
 =?utf-8?B?R2FxTld0QkYzZWxSSExKd1cveENGNU9pcmUyMytYVXpOTURDTHduSk8xTUNL?=
 =?utf-8?B?QVMwSUloSC9ibENzYlJQcHdLaXBQcnpJQTJwaDVDRHZtRVlHbVpzMlA4c0Ro?=
 =?utf-8?B?ajV3cEpUSjRJcXp5WFBBdmk1VGxVZWNDUFNicml1NTZQL3E0U01XdlhFZER2?=
 =?utf-8?B?NTRXQUlRdVRiZkQzUVlXaGJ6azBnQzFiTllxSS9KdDl6WUhqR2pGSzJPQ2dh?=
 =?utf-8?B?N2FCN0dvR2h3Sng5MHl4REUrMjRSZGM3L2xWYzcwVDBMemtTN3JCK1RUeWtS?=
 =?utf-8?B?d3NDcm5nTy9RZWZkdmVBbURTa1oyM0xZZUM4cmhmSUd4TDF4ZTNZNFFuNUtM?=
 =?utf-8?B?SENBQitJL3JWcGl4THlsZmt5TGZtQVk1Rm5XRHBpVysvc0Q0WnhMekxSYWVD?=
 =?utf-8?B?aFRSTitpU3g0ZUMrVnNzVjhUR1I2eWJ0MVYvc0N0QkpkV1VzVHFReXlRT09C?=
 =?utf-8?B?c2s5YmlSZWtpVnM5Q1dDcjFNNUJSVUhwYVpZVWROSkV1UzNoMG8zSkFHV0ZN?=
 =?utf-8?B?bTR0VHBsNzBBN2tueTZvdExORloyN2ZYaE9nMzdlajk0U3FWSTdrRWJ3VlpM?=
 =?utf-8?B?MnJOQWlzaUJjRWYyRUZTN0NUZVM4T2lHTUdtS29zNVdoSWM5eWZYdGZJWVhK?=
 =?utf-8?B?TFFUd1o4czdGeGFpQXlKWjdFdnVQT0ViRzd2OTFsQi9NZUlZUE0vc0x6US9F?=
 =?utf-8?B?aTduUEUveTVrZlF4L1RaZVAyeUF3OHBBanFEWnlZMFd5enBWdHd4TFBHVXNE?=
 =?utf-8?B?VU1SRExNN3lpM29kaVRjVXljRFZ1bHl6K3pCMWNrWi9tQVZJQjdnNjNXenVp?=
 =?utf-8?B?RHpuR0FXcE1iQm8rRXVrQ09Jb2JrTVgvU2RqMDFYcTUyWGRWdHNYUDhmYXRj?=
 =?utf-8?B?UGx2MlpYR2FrbUlzd2ljS2g5dmpLTHF3OXNJeGdVekNSQXBjcXJkSW5mY2w2?=
 =?utf-8?B?NVZQR3VYcTk5alBHL3VlcHRoa2JwcFVVM09qbmJhODR0bWRNMVg5cUFVUTdQ?=
 =?utf-8?B?ekNQWXg4MzlCakhIL3VydHVIOFcyRVZpeERTeTd6OXVhRnQ5VVM2eEVJWW5I?=
 =?utf-8?B?S1c3YWRocHpFYlhmVGVFYlJsZWcxRExZRCt3ODg0U21wSnhhc1J4azBLQUpz?=
 =?utf-8?B?RlJZSzNqWkhQL0dxOGhteTExZUVBTmF6WGdsWVh1dFA4M0xhcy9PeTZXdkkz?=
 =?utf-8?B?ZzZ0RC9tVGtSMTRRcXNOeWZhWExidEs5akNwWm51WTlMTHhRWXBOUGdzc3ln?=
 =?utf-8?B?Y1pDaTBUTnE2ZXV1b1RMMXovQ29GdldOS0dYcmpvVDkvU3doTTVPaVV6YXZZ?=
 =?utf-8?B?VWhqSm5aRWZPQWxNYUJEc2RYZFJETkc0KzF4a05lT2lVS0tlQnpNQkdiaWJO?=
 =?utf-8?B?RStPSXF3QitCNnZ4U0xzWXdIdDA5aWpKUzR0encrMXVQVGNycEI1cno3Zjdl?=
 =?utf-8?Q?HmpuqWnAyjqP4y8bK7zDhyX0yYsEgA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MDZIZHpXcnljTHVQNVhQd3cxUm5xRCt0V01nRDFjS2swd0RWVnMwZVJGWkNt?=
 =?utf-8?B?VU9QRlpLa1l4V0ZOQkg2TUd4K0JZVkJMbExsb05LNEp2VHlVMUNCZkUxbEZD?=
 =?utf-8?B?YVR4RGlacnNtdkRYZlUvZW1BQWxTZjhoaDFMV1N2VDJvRlJ3S2EzeUNNNEhZ?=
 =?utf-8?B?dWlGMithd3k1R3RUQkxiWFBUNUFGVzhGbCtIb2s3TW5oc3BuMW52N1VpUEZh?=
 =?utf-8?B?UmF3WThpK0FJdFM1djdmQUdqajJoaXJEYzhoWFg2Njg1QzJVYUx5dkIrRHBk?=
 =?utf-8?B?eC9RWTFwTERDL3kreWhsTTVFWk84bnQwNGpJemhXb3F4TTJBS2U3WlVFdndl?=
 =?utf-8?B?TUVWMERZUjhTaVJrbm1RTlljd2t2QmRseEJZNGJpcXdXRDZhejZHZndPeDVm?=
 =?utf-8?B?QTVuVXBSRGdjWmpKVHpWUEQ2L0Q2NGhETlBBc014N1Y4Z1IxVy9mRkpzTy8r?=
 =?utf-8?B?K1M1a0dtRTRJK3RUbDN4TTRXS2JrOGY1QW9GLzZpN2gwb2ZVYU9BSnZacjE2?=
 =?utf-8?B?ZGN2c2lVcEt4dUNoZmRKQ1EvSTlnNmhjU2pER1krYStnYmd3Q0RHeSt3SkVY?=
 =?utf-8?B?VXFmaWd1dXNlRGE0Ymc4MlR3NWI3WWdLSERCODJ1U1A4UXBzOEY2dlo0V1Vh?=
 =?utf-8?B?UW5Wd2lJY2RQUTlWK0pmVlI3YzBDcHc2bGNIY1E2YVJIV09HU0RPWVFST2pk?=
 =?utf-8?B?VjBnVXEwbmZlTWIvWkhiMjNtRXVZaFNZZDVFQ1FoT0JhT293cFREc0FubU5h?=
 =?utf-8?B?a0hvdDBSRkJCU0h1YzAvczRzdzBtRTc5S2tFbDdtV0Fla2lNS3l4RmJOL01J?=
 =?utf-8?B?VGpvUXYwRVM3MjBSck00emV6R0hEdzFzRjZwWTYvcFlZRzlVaXdGYWpTUFRB?=
 =?utf-8?B?NGhjcjBUMVpFSkZ1SWZNaGUyNk5Jd1lsNUpEUkxXMlIwVWZyYUpHME5YT0pj?=
 =?utf-8?B?WU1XRVdoRUcvNkNmUkdxTGtia2lpenhMRjl6Rk1XWGhjREN4Sit0OG9PeVVh?=
 =?utf-8?B?NENPSTl3T01DdGhic0E5bDBUVWFOSEQ3YkFMOWdMV1V2T09SakdxMkNrQXRC?=
 =?utf-8?B?YmdSZjQ1NVBJVEhnWjBTZzdrUXFoRXk4Nnc5SHZZb1FmdU5UblMwczcxc2xx?=
 =?utf-8?B?aGJpOHUyUWczTGNJN2lNb1BJZGZvMGxaOUZlaHN3aTFqTERaVmNrSVVzUnU2?=
 =?utf-8?B?ZWk0RS9wQitjdlZVaTBBNXZFa1RMUTd4S1NTRkR0WUk4T0M0WS9pZDNyaHlr?=
 =?utf-8?B?WTFoYStYYUZod3hOZURvREtoZm5xZFlzRHhPMmx0OGZ2WVpKRVQ1OW1qRHBY?=
 =?utf-8?B?cS9mcjI1STQrK3FvWlJJVVQ1ajY2ai9TWm43SjdBRzhaYUZ6Vm5yOXd0VGRs?=
 =?utf-8?B?ejM3QzZIYTYyYjR0REZya0N1eXhROWlMSkFWZ0pMeFpDVWdiazZKdERrNjVs?=
 =?utf-8?B?ZHRibS9kNnpBM1V5UU85WFF3d1RQckNHTzNiOTJkeFc0d0VsbWtkVWwzQm01?=
 =?utf-8?B?eDdvQjd2dHVmTDYzS3R2eTl2eEdUMXBtbDNiRWVuSUhWUU14U1I4bmpXdVN5?=
 =?utf-8?B?ellmN2c4Q3p4eWpHYSswVnVOZTRxNDFTTm5jYndVdlJVRkdKdXE3dDhIL2pv?=
 =?utf-8?B?bXFJamswcWFIcFB3K3pnR1IxQm5rdCtWU2JXY0lURy9GL2ZyUlNTL0VRRFh0?=
 =?utf-8?B?dWoxSTVtdVcvSTVBRnY5ZExnM3lHVFdYWS9NUUxmR0Z0QWR2cEFrRmFpRkda?=
 =?utf-8?B?a2pvNjZJeEFhazk1UHRUZTNwdHBWM1RYOEVTYjIxZDZhM0NwSUQ3bDdVbWQv?=
 =?utf-8?B?YUhGT2hpUGhGak5WY2pxeUVJbXBJTTJHZjE4RTM0Y1VPTTRmRDQ2Y1N0MDJX?=
 =?utf-8?B?OXp4SGRRdlRtQW1uSFVIVlVMYnA4ZlMzNDZ4WVFOVmJHb1hFVlBvRzZzWi90?=
 =?utf-8?B?MXdMWjc3TEpJMHlDSUlVWGhhU3Y1MFVpM3NPbTYyeGhEdDNTOVpxK2dvWjZR?=
 =?utf-8?B?aFRFVTRscWRadXFHWWV6QUVGMGRaV2diZ0hBOSsrT2tMR3RKbGVPY0pybml0?=
 =?utf-8?B?SFh5cVhwNDBpRkQ2cjYyYjZwdzByNTFreFlMazVmUjU5cmVxbEFoUG5MbEFX?=
 =?utf-8?Q?xmgDyM0eIWZHo+o+pXNl3IRxL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A46FD65B35DB7B4293E3D2DACC326747@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fb70364-6f54-4edc-8d7c-08dde5d87eff
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 02:13:36.2399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5uwlG5WrLLiz1XcNbmOr7wl9edYrWxab7qplkKUDHbtIIAFXnqOBlgfrtENEneWD4mFqbAhHmSH7aAmUiIz51Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5919
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDE3OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEcm9wIFREWCdzIHNhbml0eSBjaGVjayB0aGF0IGFuIFMtRVBUIG1hcHBpbmcgaXNu
J3QgemFwcGVkIGJldHdlZW4gY3JlYXRpbmcNCj4gc2FpZCBtYXBwaW5nIGFuZCBkb2luZyBUREgu
TUVNLlBBR0UuQURELCBhcyB0aGUgY2hlY2sgaXMgc2ltdWx0YW5lb3VzbHkNCj4gc3VwZXJmbHVv
dXMgYW5kIGluY29tcGxldGUuICBQZXIgY29tbWl0IDI2MDhmMTA1NzYwMSAoIktWTTogeDg2L3Rk
cF9tbXU6DQo+IEFkZCBhIGhlbHBlciBmdW5jdGlvbiB0byB3YWxrIGRvd24gdGhlIFREUCBNTVUi
KSwgdGhlIGp1c3RpZmljYXRpb24gZm9yDQo+IGludHJvZHVjaW5nIGt2bV90ZHBfbW11X2dwYV9p
c19tYXBwZWQoKSB3YXMgdG8gY2hlY2sgdGhhdCB0aGUgdGFyZ2V0IGdmbg0KPiB3YXMgcHJlLXBv
cHVsYXRlZCwgd2l0aCBhIGxpbmsgdGhhdCBwb2ludHMgdG8gdGhpcyBzbmlwcGV0Og0KPiANCj4g
IDogPiBPbmUgc21hbGwgcXVlc3Rpb246DQo+ICA6ID4NCj4gIDogPiBXaGF0IGlmIHRoZSBtZW1v
cnkgcmVnaW9uIHBhc3NlZCB0byBLVk1fVERYX0lOSVRfTUVNX1JFR0lPTiBoYXNuJ3QgYmVlbiBw
cmUtDQo+ICA6ID4gcG9wdWxhdGVkPyAgSWYgd2Ugd2FudCB0byBtYWtlIEtWTV9URFhfSU5JVF9N
RU1fUkVHSU9OIHdvcmsgd2l0aCB0aGVzZSByZWdpb25zLA0KPiAgOiA+IHRoZW4gd2Ugc3RpbGwg
bmVlZCB0byBkbyB0aGUgcmVhbCBtYXAuICBPciB3ZSBjYW4gbWFrZSBLVk1fVERYX0lOSVRfTUVN
X1JFR0lPTg0KPiAgOiA+IHJldHVybiBlcnJvciB3aGVuIGl0IGZpbmRzIHRoZSByZWdpb24gaGFz
bid0IGJlZW4gcHJlLXBvcHVsYXRlZD8NCj4gIDoNCj4gIDogUmV0dXJuIGFuIGVycm9yLiAgSSBk
b24ndCBsb3ZlIHRoZSBpZGVhIG9mIGJsZWVkaW5nIHNvIG1hbnkgVERYIGRldGFpbHMgaW50bw0K
PiAgOiB1c2Vyc3BhY2UsIGJ1dCBJJ20gcHJldHR5IHN1cmUgdGhhdCBzaGlwIHNhaWxlZCBhIGxv
bmcsIGxvbmcgdGltZSBhZ28uDQo+IA0KPiBCdXQgdGhhdCBqdXN0aWZpY2F0aW9uIG1ha2VzIGxp
dHRsZSBzZW5zZSBmb3IgdGhlIGZpbmFsIGNvZGUsIGFzIHNpbXBseQ0KPiBkb2luZyBUREguTUVN
LlBBR0UuQUREIHdpdGhvdXQgYSBwYXJhbm9pZCBzYW5pdHkgY2hlY2sgd2lsbCByZXR1cm4gYW4g
ZXJyb3INCj4gaWYgdGhlIFMtRVBUIG1hcHBpbmcgaXMgaW52YWxpZCAoYXMgZXZpZGVuY2VkIGJ5
IHRoZSBjb2RlIGJlaW5nIGd1YXJkZWQNCj4gd2l0aCBDT05GSUdfS1ZNX1BST1ZFX01NVT15KS4N
Cj4gDQo+IFRoZSBzYW5pdHkgY2hlY2sgaXMgYWxzbyBpbmNvbXBsZXRlIGluIHRoZSBzZW5zZSB0
aGF0IG1tdV9sb2NrIGlzIGRyb3BwZWQNCj4gYmV0d2VlbiB0aGUgY2hlY2sgYW5kIFRESC5NRU0u
UEFHRS5BREQsIGkuZS4gd2lsbCBvbmx5IGRldGVjdCBLVk0gYnVncyB0aGF0DQo+IHphcCBTUFRF
cyBpbiBhIHZlcnkgc3BlY2lmaWMgd2luZG93Lg0KPiANCj4gUmVtb3ZpbmcgdGhlIHNhbml0eSBj
aGVjayB3aWxsIGFsbG93IHJlbW92aW5nIGt2bV90ZHBfbW11X2dwYV9pc19tYXBwZWQoKSwNCj4g
d2hpY2ggaGFzIG5vIGJ1c2luZXNzIGJlaW5nIGV4cG9zZWQgdG8gdmVuZG9yIGNvZGUuDQo+IA0K
PiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4N
Cg0KSSBndWVzcyBJIGFza2VkIHRoYXQgc21hbGwgcXVlc3Rpb24gOi0pDQoNClJldmlld2VkLWJ5
OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

