Return-Path: <kvm+bounces-56237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AFC49B3B04A
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 03:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C2F691890034
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 01:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD261DE2DC;
	Fri, 29 Aug 2025 01:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MzR+xU76"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D366E186284;
	Fri, 29 Aug 2025 01:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756429893; cv=fail; b=ne7rLRy3VjLT6/zKBCXjvkb7hHdN2NGUf/q/Jrf5LCWmrYiog3d7ZYUvSeHpM3zZk7FfzZHxzsR/a9kkM4agaKPnE1RojayZrQjmEFA8AtOWTllNI3ckswlo6oTCAZR2Ux8aPeTKWAxspWOH5WCePZstaYax4HWHQujwgC1T0/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756429893; c=relaxed/simple;
	bh=QdM/jAwm8CjzNiKrkavN2MsjAXN9QZXd1NsuAckPuv0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n3UGWultBpws/w0lGUtBtbJpqigsuKl9JvxtweW9zearNZcQVZhxbVvs/kqGXZblOGDzX069szZrj13PKMqXRUAxVwX6BNsE8nnaSBRm6Muiaoi94YJLSADHZAoVHutcRBHgqIj4NT7wZS/J1QRq//n80//hnFlmmh0T+eYmzgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MzR+xU76; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756429892; x=1787965892;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=QdM/jAwm8CjzNiKrkavN2MsjAXN9QZXd1NsuAckPuv0=;
  b=MzR+xU76xAD4JZi6WxZ3Riq9t1ALr6hB/k7rmQ6NKf5m4bfKeC/ssJ0m
   tb/miXj+EMELsRu6NvTrRiwHLEKHA3D9XC4eew+6O1Eb38z88LQW7n2fC
   BsYErJPvwlxeQ1fRgFU6cKukSm9PjUVNOn893I9rYjvzLTWbyeaOB3V+S
   U8E4hIVW57Uc0z2KKPIqdhEypK074xiytu75qeMNS86mZjVMRRhNa2A3/
   Dt5epa8ZmWhiPeaFDEEp2QajOKciTL23RgeroHiKEEH8X9VOyg2/ylvrK
   MUHqg5srqUSnPeQqTftPLKObg5gAug6CdYf7xqy+VcgUL+T9mkX9IN1vF
   Q==;
X-CSE-ConnectionGUID: zckY3KLfSAuPg1ZM9YTetw==
X-CSE-MsgGUID: 9NCRRlwiSsWNullQndKMXA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="57739944"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57739944"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 18:11:31 -0700
X-CSE-ConnectionGUID: MZ7TjWRcQrK7zfhgYJw4yg==
X-CSE-MsgGUID: GhEA7wmFQe+zPmXhHueQrw==
X-ExtLoop1: 1
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 18:11:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 18:11:29 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 18:11:29 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 18:11:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AUNSZagxJvifZdURyPAQSIvAX8XQAZ93bLa2eyFo+G27PfxRW/IyVN6Wq/mI5hRX9l26OfnvJjIfehXHAD5GLERFplEFKPfH5nkHRY7lmCak3mhbuqwVUnnujom+lO7ftSJ6C+e5ORYjyMLmEUHOoNzzzTsHspkEetyAIOKP9GhdIs0nEiYNGGPYD0A+yOoppe4BbVWXH8vXckvPlLWV+AWTp/rwoy5/V1pF86oyrVRQOIR8KKE+AWHHuqqImMSsdGakzU0TcPfm0xMJWH7Zjndiw1+4TChvhw8ZiCXMT8HOjz3Hk+Oj9k03ogddjVIOG2kSTflI2Hch0HVtn7MHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o7m4cXgaB81+hz5eyQPvXlts5DqDBoXTwC3tuJXuPi8=;
 b=JvUPw9rGRvNLb4c2dhUOqBrEOJHPSmCexBqY1NIOq9t48rqsS+s7WS9hw2NrT7lW80CIkB+49HIPElQis3k30YC6ArqWhkjjwZ59lAuMZ4qav4V9eKlV+CLoI/XhDY12CwK3DP0dx1Jjx4Fa60eqk/3YVW7iHaWPTLvLeX18Ikfe24JaL7zrdrEx6tACtz9wuwjB8+o5Rwc0KWs+oelJiD6YF7HS+ajhxpath5h5TiQ9hIiRBpRCEnPIMqhDbs/zfOKyfo4s3FLRuIc/mt0DWS/VAFIXE8/UG96EwO0flod4uWpm4+XHjd5OguzjkFyB2TqfEhO5btFH2sTq5/jnDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7831.namprd11.prod.outlook.com (2603:10b6:8:de::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.20; Fri, 29 Aug 2025 01:11:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Fri, 29 Aug 2025
 01:11:21 +0000
Date: Fri, 29 Aug 2025 09:10:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 07/12] KVM: TDX: Avoid a double-KVM_BUG_ON() in
 tdx_sept_zap_private_spte()
Message-ID: <aLD+CCAqDNlUklR8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-8-seanjc@google.com>
 <f0ab4769b3c7b660b7326fa7cb95c59ebe8a4b48.camel@intel.com>
 <3224d2c78710b41c2245576c2b8ffa1bf0512fa9.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3224d2c78710b41c2245576c2b8ffa1bf0512fa9.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0045.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::14)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7831:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c0b0758-97b3-4a01-f901-08dde698f74a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?yZ8+sh+PqmBVacGqIQeOLudFgQYNZqtN067ZCLJK+ihSTOrqRFhlgHsc7Z?=
 =?iso-8859-1?Q?NwxD5GnNZG2xKWmqq5EGFv96dBu0PNTs8gnyg08ce0CC4p4D/EOe15Sxek?=
 =?iso-8859-1?Q?MdTdNhuiSIB2SlWoZiGy/If8qxx579aYpGh4OmHblEMHfSgSYiFj5/F1ul?=
 =?iso-8859-1?Q?o5ev0ENjHjP6Bn4JH3vQBPe7OrOB9o6iisvTUreQOovKW+hDDjtx5H0WrL?=
 =?iso-8859-1?Q?FzUO/arH7IoHAVlhytFRMA25wi9b41cKb63s0Up0EhluwB2Ii1bPK6+JMF?=
 =?iso-8859-1?Q?czb+9PIXT/pDIkSMwNW+08TMUSFY/3A3DzoyI0H/LIWCq3QaHoHhmQv1zG?=
 =?iso-8859-1?Q?JhPpU9NQ45YXva/tSXGrV/GyClbDN0+WQr/ZXO8MAb/n93/DG6X0c4wjNL?=
 =?iso-8859-1?Q?Ooe5M/u6I6CW+I6kestMUL+2fHWGJJeb+RfaMKmNd1ArVKJyikM0JJ7iJM?=
 =?iso-8859-1?Q?AYCiuG2QdyBUd5URb+q8uLwpsVCasopZYRitkpAhZC5r1yvNcS4c7d0evu?=
 =?iso-8859-1?Q?yv0iz+kSrfHNyF/KrwDsaT+L7E+UI9kNascjC4t5v2zGAxNZ29J8lUr3fh?=
 =?iso-8859-1?Q?CVPMYkAXU1wjYZKOHObVtwJg3ZLQMGk72s5qIGB40pU5+CgyLsY4BwCgQm?=
 =?iso-8859-1?Q?3FRe30PsE7C1PuCnkIyyOmr9qWof4Vz4e+Kk5ISA8fA38h8hhIx/oj4zW1?=
 =?iso-8859-1?Q?uTdlV+w/ADjtoGh2jR87uBDH0uG/OpoIQChb1i4SOjN0SQ3USbFd9tKfX2?=
 =?iso-8859-1?Q?T9USXitSF4UhYtcSCKTND7ZdPY+UCoTBq9lF5scFzNH50W+OcZ4s/1CFI5?=
 =?iso-8859-1?Q?MaHwFrKBhZgT7qRL5g5Wx6FzH2HILMwgdcrkdR4rUXYCvXrE033Lgs9wVI?=
 =?iso-8859-1?Q?OK3/5N1QoBe5JlTqJjigbLt82o1WtvsS49CQE2JmSO8PBla/5zoU/SSiV0?=
 =?iso-8859-1?Q?smHt1Nfi5BAYQoaLf4GfTrQH5DF97A46vpRO8U6r+x2gGJijdjLa6fT12o?=
 =?iso-8859-1?Q?PaBCTiPknCO7LzEENgxsKrFifeEn2HmF2q0gaTs8nnKU9X4u5O2b4pRsdS?=
 =?iso-8859-1?Q?VpiNv8Bm76UexUavqoQMv4/1qQjueFqMrTIP/b8U3NgrpoJp/+M+XMmMKH?=
 =?iso-8859-1?Q?hAKo0mgPQ/pXDB3ahFzimG3xqzoypN5VZaVfFUKjuJGsqqXFpkwjgEhJDc?=
 =?iso-8859-1?Q?naROauVkA2pDJOhIHCe8EmzYR+K4GtBKp4Y6IG358HbN36wwthktRrZ0pu?=
 =?iso-8859-1?Q?zTRohdZoRJF6rDcRzMn0YTyyGKEBbnjLB8gY3MspU4/M2fk6O5I3djmcIR?=
 =?iso-8859-1?Q?L1O5Dbp5/Y14KAqao4MDk0wglGUxFb+wEDeLc1p/LmBu2io8dHUl15rE/f?=
 =?iso-8859-1?Q?u+NNljN41Fb16G5LYg9hAiUtw/dw1uSkQRn+G7BPrVczlsoxOVHeks529z?=
 =?iso-8859-1?Q?5C0yPoQ2aQakuhVoG9NzEN8eLlZPnDJN7KY81LsXMY59oYWYWjNdn4yJEm?=
 =?iso-8859-1?Q?M=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?fExFLv8Rq/3Y0w4kYlrZK1u18EuoHcMEzO4rlhDQF2vlmUl0KTF8Itsg8g?=
 =?iso-8859-1?Q?WFPrd1X8X9kuYMYM5kReIgOORPPEXxhMoc3iat8EJDWczqsLh265wbPpVE?=
 =?iso-8859-1?Q?LEyjnvhD2kHvLGKrEzvAB79lT6KaMcHDPl6x/osnOmQDvOdNrof6xQWx7v?=
 =?iso-8859-1?Q?oaaL0Yi4ODjiADMvw5Wuw0rkvdRg8Dcxy0iWI+8b1w7pWWEL46ioIoiZpK?=
 =?iso-8859-1?Q?GbUhtxLFy13dyAUrZ97aSJ5Xs6Svza9l63DlpBvGjojQHLMBgSEfWdummj?=
 =?iso-8859-1?Q?lj7PHEHXDPyHSHr9dyrgzAS/avDImhGQRCN9ZzuCPFWIkluEmRkI8KerWd?=
 =?iso-8859-1?Q?oaZ10RPxeVk97NhtEBJgWzPStdDUqQ+zKwR4OaiqxG1Z8SiMl1yoO5tpk/?=
 =?iso-8859-1?Q?J/Q74e48C/V14fpwkJD9X4h3mxVAgx1ryEezELTJsMqJ5WWBHNxbmaaxvS?=
 =?iso-8859-1?Q?ZALYtRrceNrzqO+v928co2yzhixvNLgUzKgEdIdvB3wL87nbuem5TuS8F6?=
 =?iso-8859-1?Q?pWLPC2Y+/QHZ1ODHcNupQTo1qzps57AEJYOSlEuwvpytOc2OZxMwQLmuS3?=
 =?iso-8859-1?Q?68u+B3AN+bfuZBfu/pk3Wc4uLfJUManQuCbRlNn4EUV65U3PRMTYPhTpUj?=
 =?iso-8859-1?Q?9A+MrWwMjUPv7W2GbDjbwhlMK78S0r2/UkvWd52Y/TD55fZWcIVyp2A5Rk?=
 =?iso-8859-1?Q?bYMhdA50aej+sFidvGgkAwOtF9IBleTsFy0nTBbGSaUTgU0Ru5GaATQBds?=
 =?iso-8859-1?Q?72vSaJ6neEsEAijTUNGPn2ATeuFj7LZGjq5UUiiu3RHGldgHIoYxOzo8X/?=
 =?iso-8859-1?Q?9U73nhJDEhuC1/QZF6ALonh2Ya+5m53Wh1FPhOpCYj38eG3CzffmQGRdNk?=
 =?iso-8859-1?Q?0f+ftawDcmeHKg5q2Sj7CIlIfsuKsKYWgwST+ZBVeF/b73X741nPLLps6T?=
 =?iso-8859-1?Q?O0I5iJ+RanLxUuVWgwGvgXYKf1kOyhi9apm+Uicjy01t/fIdjm7/1CzPg3?=
 =?iso-8859-1?Q?zpxMJZRlfO4PwUtzS/DIGWgRjUC//6YXLobhOrvHkRpbnFuxhBJ7N5kfeQ?=
 =?iso-8859-1?Q?mhPS+E3m9dcgrrNPbVpgOiGtbMIdKdV4Wmo4LPfdX4jIRSYrybV9C1IPps?=
 =?iso-8859-1?Q?im4vijertzHkltazDNaLiJTbicbOns8YP0iV/0trBE7mGM47teMs4Lxdg/?=
 =?iso-8859-1?Q?iediycRzuF9MyDKpDuZ0x1nEtPGKQagL7x+mSVLH+DR+/cKWo209iO2wCD?=
 =?iso-8859-1?Q?ChYbYHbYnnAWS3plH4PfLaiDZR3QkNQHbwgSnuFBLMNTHEbWx6R4EG92G/?=
 =?iso-8859-1?Q?Y0ZpITVs6S6lXg/RiiizV0XXwyJHS+pvkTw30TJOhcypv1+RSD8014hYQb?=
 =?iso-8859-1?Q?V6v7Xyuh9avp6k2PnVfiiXb2ju0iKi7fyN4ofC1fdjTgAY6DGaU2Q+0R4y?=
 =?iso-8859-1?Q?7busLrMazD/6PZ7TMmo+xGN4eUuSlNCBmFS9HVUeKemA7TCml14J1x7JUH?=
 =?iso-8859-1?Q?qXpbfbnXKhaap44MeLjSZHN5SK3/2UyStFRO5ticlN0HiqHZcFMhg/XxOl?=
 =?iso-8859-1?Q?D64A38BFMV730VEVacB0q1FFJu8iZkwK6zFnPnMvyzYCQTQDzCry4C4hRq?=
 =?iso-8859-1?Q?1mUXdi/sFEDFi4U2k9Evx23sQFlCapnSsP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0b0758-97b3-4a01-f901-08dde698f74a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 01:11:21.6559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aqdKIWjPSQB0ICaMzHbfhF4FGXawrk87vkhe8kJ5h4S9fUMuwdGCB8uWu+xF2V7a6xM8dzIdLObA3d7eFnEvKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7831
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 10:50:06PM +0800, Edgecombe, Rick P wrote:
> On Wed, 2025-08-27 at 19:19 -0700, Rick Edgecombe wrote:
> > On Tue, 2025-08-26 at 17:05 -0700, Sean Christopherson wrote:
> > > Return -EIO immediately from tdx_sept_zap_private_spte() if the number of
> > > to-be-added pages underflows, so that the following "KVM_BUG_ON(err, kvm)"
> > > isn't also triggered.  Isolating the check from the "is premap error"
> > > if-statement will also allow adding a lockdep assertion that premap errors
> > > are encountered if and only if slots_lock is held.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > 
> > Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> There is actually another KVM_BUG_ON() in the path here:
> 
> static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
> 				 int level)
> {
> 	kvm_pfn_t old_pfn = spte_to_pfn(old_spte);
> 	int ret;
> 
> 	/*
> 	 * External (TDX) SPTEs are limited to PG_LEVEL_4K, and external
> 	 * PTs are removed in a special order, involving free_external_spt().
> 	 * But remove_external_spte() will be called on non-leaf PTEs via
> 	 * __tdp_mmu_zap_root(), so avoid the error the former would return
> 	 * in this case.
> 	 */
> 	if (!is_last_spte(old_spte, level))
> 		return;
> 
> 	/* Zapping leaf spte is allowed only when write lock is held. */
> 	lockdep_assert_held_write(&kvm->mmu_lock);
> 	/* Because write lock is held, operation should success. */
> 	ret = kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_pfn);
> ->	KVM_BUG_ON(ret, kvm);
> 
> We don't need to do it in this patch, but we could remove the return value in
> .remove_external_spte, and the KVM_BUG_ON(). Just let remove_external_spte
> handle it internally.
+1. Triggering KVM_BUG_ON() only in TDX internally is better.


