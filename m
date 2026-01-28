Return-Path: <kvm+bounces-69319-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6HBCLe6CeWmexQEAu9opvQ
	(envelope-from <kvm+bounces-69319-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:30:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF0D9CB29
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 04:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ED1D43014643
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 03:30:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3197F32E739;
	Wed, 28 Jan 2026 03:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WKkXmr36"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9337A2C15B8;
	Wed, 28 Jan 2026 03:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769571042; cv=fail; b=rXQk8PllRUf41443HJNU2e5KFbf7mC7DK3Z0uCfLrTUmV294E+FbhgzoNvvgR0EdRc+7u0yVbm/p1i/leMICkDrUixLFLHdZrpNDjP2Z9wL0BRWK4CgYm4XpfWau1Pz1HNA0rl1NnSF+qDQlANaKYuHtMzMgJUYscHrUImWAZiY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769571042; c=relaxed/simple;
	bh=KfUp/l0E3sG8t6UlJOUIH+bcJtpQzNt8qmvCpZ1x5xA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nYBoSZa2CEF0bb4nQF3mU7DC/Vq+sd52jbrq5cbul6eQ7LSpEvhjKAGtmpWnQfGV7d2cJ0KFQwlwIV7U1wIbOLUix/OK13j2EMBRFKyZrvx8TxAJeyJ2IDd6GhoowFV+oXCkpNS9y3Nc6f0gtjdv7IRBQmWiuzbsdZGDfp8aZKo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WKkXmr36; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769571040; x=1801107040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KfUp/l0E3sG8t6UlJOUIH+bcJtpQzNt8qmvCpZ1x5xA=;
  b=WKkXmr36Uny5NP2w7VXlcvnq0N/NnLWqyZV2vwmMDG+KP8pcVXSgtR94
   JUqZWIkJ6NkA1S2oeTE2Uo/yWRmC0NLm/Oi9l7cOGb4xFmv2ItBthZvMu
   h9DjSskWf1pGm6sd/sZlIr+Q1wHJOFxbiuc26a03NchFHYFttyuBnex2H
   UGWSB2enbIHmskojv+dE8TtYTLH5JgOhRTm5NgKcHyOKyAeUEnAbHEqTw
   hyLJ4JqPfTH5lgYosZKdPdKamr+bhwteAh2X1J14hEv4CIIdZxwL62S0x
   YmBkObUlvnuSZ0ZEEDhJ5UWxVhVhUM6UDHL7OARZOICRw13aGj56a9RDi
   g==;
X-CSE-ConnectionGUID: oBP68FGWSQii6MHTnk8ORA==
X-CSE-MsgGUID: Klb6MhpKS9qstcL5zCnexw==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70944282"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="70944282"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 19:30:39 -0800
X-CSE-ConnectionGUID: iE1SmvfORVSS7Wmt69MEuQ==
X-CSE-MsgGUID: rV0iy6iFSwSMMd/ti5YSQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="208386639"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2026 19:30:39 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 19:30:38 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 27 Jan 2026 19:30:38 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.17) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 27 Jan 2026 19:30:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADdd3yQ62KBmLeUB/s/TlZmwHAoalRUGca9vn96EVm9mlZVs6PWReypz6ot0UgQfYurnOrhNIM2cnJNtLYqNpulTEjoVQSB5MzC2RooPqjj9dbppvh3KQllweuBqNXGtyaGfxPk9sBVU0nmhb7ZR8eahXTjoozXu1xABQ0nVkoXF83GgSD6WWabt75uLgMeuA1Np71eo3MgtxwNE+Qg0cboCghYj06TwoeZotHJ0AFJfL3ejfpnG4PdR8UVS10bMn3UEqTmLsfQWmRHx2d8zz787mmXxq3ZqITIBjoLF7qqCIQJKdVfy2MojGgOwyWxZRW8Jfwzpen9DNkPWuJfw5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KfUp/l0E3sG8t6UlJOUIH+bcJtpQzNt8qmvCpZ1x5xA=;
 b=F7yUEBWP7avA5P54IX282oiWY4soVrLZTUSbbYdAbACNkEaYWhuTV9WQZ4niWP8zIHaYQd1sQ88u4Emic3PnuyUdL7G1ldLYDUcvOYDrj0TRELwFWi/2uXtJOI44B8hP6iuh+crvfIqaOMQYuBACUsIPhQNTJt7DVERENKMZEoYH0L2v2LlVPVLDQXHwqN+maRgjevAgskNGrWgM4LfE0aqhW9xMBjUX0OQ+dJrrvQANTIJExylbrzFR3iXULVnrCQZEVz9Iovq2JquMRRu+T7V1gnDIwY0cVXZ12qs8I7bpTpMRmMAN8a/z5S7GFVxh223GQYkR91YWoXx2E7D9JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB5942.namprd11.prod.outlook.com (2603:10b6:510:13e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 03:30:34 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 03:30:33 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com" <sagis@google.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v3 10/26] coco/tdx-host: Implement FW_UPLOAD sysfs ABI for
 TDX Module updates
Thread-Topic: [PATCH v3 10/26] coco/tdx-host: Implement FW_UPLOAD sysfs ABI
 for TDX Module updates
Thread-Index: AQHcjHkZJSd5hRGGKkm6M5UZMJsIWbVm8/aA
Date: Wed, 28 Jan 2026 03:30:33 +0000
Message-ID: <065fcf039eacf79c1566a15fb1dc935b3ac1dc5a.camel@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
	 <20260123145645.90444-11-chao.gao@intel.com>
In-Reply-To: <20260123145645.90444-11-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB5942:EE_
x-ms-office365-filtering-correlation-id: 3b36911c-c0a5-4d8c-4729-08de5e1d985f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?WWx0eW1BeXpFK201MnFpVUxNdnFaWmUwYXkvcVdtQzNjaE1pWTFJb0RCWUpy?=
 =?utf-8?B?RkhkTWZ4QkxRZS9jMHhndTdtSkFDcVRXaDh6QW5mSjZJVldmVlVFZlBNSEh6?=
 =?utf-8?B?QWlHV1VwQnN2MmE1ditRRTFDRHkzaVBRUk1QUSt3OFFsTHh0WXZlOFphZzZa?=
 =?utf-8?B?RXVRdW1FR3U1QlZDOTFRS3A5V1RWZ04yT0M1bDdVQ05aYjM5M2MvbG5nVTg2?=
 =?utf-8?B?cE1HelpLbjd1eSsrU1R4VVNyYjRTcFgzeWg1bnJJSElKU1VpTXlEYXNKVjJD?=
 =?utf-8?B?Mm9Eczd4OFAzMmxReDcrSSt0Vm04ZDhoRWVFNGcyU0NoR0l5WEpkSTBoS1J0?=
 =?utf-8?B?ZzIxbzYzMEJucEIrdjlqSDRoOXJucGI3Z0Z0UC90anRhVlJqdzk1TEpBbE96?=
 =?utf-8?B?RGRhWm8yeWYvcVZFUVJrenBIaGJzeVFRSTc4NFpUSXNrWVNyemxkM1dzeVFZ?=
 =?utf-8?B?U3hrM1E3SjhlRXZQNlJJaVJ6elI2c1VVK3cvbm5la3lvVDk2KzJQYkIrSXJy?=
 =?utf-8?B?U09lNGprWVNvNGltZFF0L0EwM3lkOFhHY204WkluR1NoVzJjYTc1QnM3d0Zu?=
 =?utf-8?B?eHl6U2ZPZnVJcjc3UWN4Q1REdzBiZ3Ayei9FcS9rQkF0YTFTRko3eC9pQVAy?=
 =?utf-8?B?RnNGVTRJSkh2N2RKVVYvWHp2NmtENzlkc1ZXVHN0MlFVZnlxNkFnV1ZVazM2?=
 =?utf-8?B?VHFUUUZLa3R1WFltejZJRWY4bnRKcW81UG9CM3ZIbFZIcko0VVMxbVVkbVBK?=
 =?utf-8?B?T29ieWNmTUZDby9NSEpzYjB1Q2RweW80a0ZyL001UlozclZaOExjRUw3UUk5?=
 =?utf-8?B?a0h2ZzVoV01EcHN5UURqU29KY1JUbVNLMlBWa2FycjlRWXdEdHhrWW90WTFt?=
 =?utf-8?B?ZzhIVjlEMkxpb0prTTVvYjcvUzBqT1JLL0dVR2wyOEN2dlR3ODVrZGhCbDA0?=
 =?utf-8?B?c1RFZElyOHNEQ3F5Ry9ZUGxHenM2VXRuNCtDUElpb1pKNzZTRUc3K0JON21B?=
 =?utf-8?B?QVdFanBvU3JyVUt2Mmc5eUI4L2RxNFdJYmJSVjk3Vm5KS0oxY1R4dURIanpp?=
 =?utf-8?B?RzFLTnRYbm1EN29iM012bURUZW9aYWp3dTlmOTFJcVR2bitGRWR1Yjd2VFRB?=
 =?utf-8?B?MUN3RXZkQVF5TGNvcGppL1lyTW5kSXpNbTdQeWkvQzh3WkRZeGRWMVlzQlFl?=
 =?utf-8?B?ZTZNaTlORC80dDNiKzlmWHMxblRZbC9sVzVNT25iMk93MWRIMHo3Sng4ZUE1?=
 =?utf-8?B?bU5kWUd3ZGVGV2dob2JkNFNPSlIyWFFtRitEZEttOWJNMXBNejRnRlRsWkdZ?=
 =?utf-8?B?Z3dHbXRkc0ZnZGJnNHJpRDIxUFdXdno2cnZyaHhHQ05QU1dYSkxaS2UwSWpM?=
 =?utf-8?B?Qk45M25WSnNrRW5JbFFvbkd3NUsvZXJ5S1ZZeTFYQkw0QTI2d0FZdUJ5aHFD?=
 =?utf-8?B?dlpPVU42aXdoaGFlUWRCOE1ma1RkWTRXYkhGSCtBWUpKdno5UytGU0drQlZw?=
 =?utf-8?B?SEp4RjJTQVdqdUo5OWhjbkZPS1QySGJHTWtBc3NNdE5BNG9kYmpjYndkZ1FY?=
 =?utf-8?B?NXJCT1IxMUd4ajcvWEVnNitWVXNKK2NaQ2NjcjRTSkxNRkxGR3gzVjIwVnRi?=
 =?utf-8?B?WUdQbjFlZE55Uyt0aHFCTEliNFNMSFRJQTVYbzJpM2dQQmZORW1sZ0FGbXFO?=
 =?utf-8?B?K2tkRWVFVm1uMDIzTkd2RjNHRFplaXJGbWoycS9UNktuSVltaVJMZEFwdkVV?=
 =?utf-8?B?cXJFblZEUmx0QnEyQnMxNEVvWWFQQVU2Nkk3SEtqRW9Bc2RmMUxZRnc2U1F3?=
 =?utf-8?B?SUp4Umw4MFVWYlYrR0FlTHZ2b1FBVE9WK0t4UG51UFdMRGdUKzlaZzlBMlBG?=
 =?utf-8?B?UXhFMTZtR0hvWFY1TUxpL2dnWi84dkk3YWJPS0txMi83cmtOVkFtVGhzR1VI?=
 =?utf-8?B?MG5NYzVJaXV5T2VOSlZ0eWo4T1drSHQ0RmFTbVBQYkZDSURkY0J0QmxBcGxU?=
 =?utf-8?B?N2x5em9iTFdnMWJCTnluRWpMaUZRR3R5VTVueTl4S0dEaStaa05RMHk3ejFq?=
 =?utf-8?B?emo4Q0IxclpCNUl2K01HMXI1cGszK2pnTE1FZmpSTlA5b0o3QjdWSk5UbGhk?=
 =?utf-8?B?NmFWT3hITkZVc2hadUw4aFJQRElMbGNFM2k5N2lHNVBzMDdkM0lTOGhGd0NX?=
 =?utf-8?Q?WUgQDDU/bKAUC/cvLr67zvA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TG5yTk5HT05tTGdoZXovK080eXIzMGhtd0JlZnNQRTg1YmFPY0k2c1ppTzNn?=
 =?utf-8?B?NllwN1ZnTzNOcWdPN2dkSDlyRkd2cjU1clhMdGtwY2VYWjZNdDN2TE1CYi9E?=
 =?utf-8?B?YlE2NlpLZFA3UjZPeXAwZnFvZ2xtVHEyRWYvQ2Zvb3ZoN1hudHBaalV0dm13?=
 =?utf-8?B?RDhHN1MxcnkzNU12RUliTzhoQWN2Um90Q0IvdzNqTWtZd1Y2WnVRU3o3Y3U3?=
 =?utf-8?B?ZFlMV1BUVktzWFFiK210S2ZEL3dlVExaNDVxeE5aL2NmWUp1NWRZRFJaMm55?=
 =?utf-8?B?WXJaNFlVS0gwdU5XdHQ0ancvZ3FDRmR0MEp5WkE3dFVLZmd2SG9BdzBWcWcz?=
 =?utf-8?B?b2ZnTUV3UmlKWTNwUDBUa3puWGxiaHhvWU5xU1JuSHZzT1NZN2svcVZYTytk?=
 =?utf-8?B?VjFaSWVjSmtIbzBXRllJVndCdnJCb3J1Q3pVSDJ0MlZFME1PbTBqNGhnVHdy?=
 =?utf-8?B?U2h6aWRyOG1ndFBoV1VhM1pMZi9mNGVsOUJHNWpJajF3a0RXUktwTzNCSHBy?=
 =?utf-8?B?ZDF0cjY3K0dGK0FwNzdrU005ZWh6SWIrckhMZmZqR2pvZTBlbkZhNnR5MFRI?=
 =?utf-8?B?Z2JYUFU0SGIraVE2QnpTMG85cW5TZys1ZDBsbTVOd1JiVjB1REZNNmFlREw4?=
 =?utf-8?B?amRWTFQ0WksvV0hwREFpYWI2c2xqcnIyU3grUXRSaTZDWFBFY0lPNHZrcW8r?=
 =?utf-8?B?QjlERllNaURHS2JaTzBhSUE2a2M0VWlGK0JEbmtCRmJoYXdya2twdU9KSTRJ?=
 =?utf-8?B?MDVxS3NaM1JVbXhKaG95YkNhM1pWUkRhRy9YbDh0U3hQNTF1NHBVcUpkSnU0?=
 =?utf-8?B?QVlKWmN1WktXcWxsWE1KcWVybW9GSUpiWjZJWlRaMGxlZ0FnWUtqa2hoclFS?=
 =?utf-8?B?SWl6Q2d5M2FUVWpocVRha3dENURYSVNIaFRpU21SYXVIbDR2c09iSmFuSFNC?=
 =?utf-8?B?dHBQaElXUG9VQmt6dlBqUjVTVWtXZEwvS2JZMHU0TitadmJDeWViNGtYaVEr?=
 =?utf-8?B?T2h1ZmhSTlNmeDR6UzIxb2NKNDdaejBUQUdONjJ4dXBOdG80bXpYZGpNd2Zn?=
 =?utf-8?B?Vnh4M3hYaE1BbEZrY1Z0ZGtuZnRhWUFIakdhLzg3aE1SRERoM3EzUlpxM3Nt?=
 =?utf-8?B?SU05VExkVWFCN0VrREc0SFdxd0w5YXh0dmsrTzc1UktCOUV2UndvOERzWlRP?=
 =?utf-8?B?UzA2S2I5R1MyMzl2endVMUlYMUVrdG9vNTZnbUp6V04vbE05Uy80dE0zek9i?=
 =?utf-8?B?Y2FuTzJjK3kyY3pFYlp2cmpSNzF2ZHFHeG8xQnlJNWs3MWZEd1VFcnQ0TXpD?=
 =?utf-8?B?RFd3Yk5acGFYTk8xRzMvV0xPdngwR0JqbUdRVUI4ZEZIUHVZRlBKU3lWdjFW?=
 =?utf-8?B?eitEdkdDUW83ajFZNEVsaUFKeEVUQTNweUNsM2hBb3hlNzlhMXNTbWNSWUox?=
 =?utf-8?B?dENpUDdNK29VQ3ovQXpYVjRMNHhrSzFISE5hZC9NMCtwL3JBNUVGcDNiQm9m?=
 =?utf-8?B?Qi9YZnRFZjJMU3dwRnVtUXIvSnR0bWVkemdZcGkwbEpZNVdpZXM3N0dNMm1U?=
 =?utf-8?B?WWozWDRFTVlQejB2UkFLQStnalE0a2dWdEZ2NmdlOHdsWFY3aTJvUjV4SXJi?=
 =?utf-8?B?bEpGWXM3RTZzakdNdkRXQ1g3ZU5Sa0kyQ002M3ZEK0hQWmdGTkxtdjBlZEp2?=
 =?utf-8?B?TmZhQS9WUTdoWVpaSHp6Tll5clhCeXNvWjc2aTBrcnEyYW1KREpxK0Nvc1Ar?=
 =?utf-8?B?clU4aEsyRTMrRFlFOXNmUUx2Ym1rZVJvNmJrdUllWis2a2x0THlZM3FNYXZE?=
 =?utf-8?B?S2dzQjlmRXlnaWYvSWthalhVVGFqdXJ4dUR2c2FOayt4dlB6am5Oa251akJI?=
 =?utf-8?B?ZTIwZmhlWXJPMGlpYmszSEhWSGlVMnBNa1lSNmxvdTJCMWVCc1hWbzRCRHhk?=
 =?utf-8?B?bytvRlVITXQzUGJUZklBRmVwbUxmRXQ3eVgrZjFaZjAvMFdQL3hoUXFNcVpo?=
 =?utf-8?B?c1RIc3BEMUZTbXc1MnFjSUdibUJBeGJUN0U0NHl2OUovdjJmTkVib1RUYzJm?=
 =?utf-8?B?YmZCVjFRcWIzOERMeDlyQXB5R0NoN2NwRVp5b1N2NU9Vb2FLbU8xTTJxVXFG?=
 =?utf-8?B?THk4L1NlQWVsS1RYWXc3b3U4RTdraFI1ZE5RVVN6WjR0VU4wUzhVbEM3Mm1Y?=
 =?utf-8?B?cE5CTnVhZkNrU0VaY2w4bHIvM0ZXSkNpeXJXd0hsYy9TUHU4MytDeFFNV1hv?=
 =?utf-8?B?d2JCV05YakVDWXBiYjFLVS8zTGpYM0lDRG5ZUnFQQVZPM21ES1BVUnJSOUV3?=
 =?utf-8?B?bEFVeUZXeGZsNnNqVERKNHRRUldubDRJVjBhWkxCcnBnL3JIK1dPUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4668776A69C82A4FA4B32F29124F5E1C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b36911c-c0a5-4d8c-4729-08de5e1d985f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 03:30:33.6069
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 40Yk7eHerS0TCEq10A5a/aCXFLBe7Llxh/Nxoqmvu3U7AplBjGNM5taILr7sYcnhme1KBUhMPa+Zr7xR2PWwZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5942
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69319-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 1DF0D9CB29
X-Rspamd-Action: no action

DQo+IDIuIFREWCBNb2R1bGUgVXBkYXRlcyBjb21wbGV0ZSBzeW5jaHJvbm91c2x5IHdpdGhpbiAu
d3JpdGUoKSwgbWVhbmluZw0KPiAgICAucG9sbF9jb21wbGV0ZSgpIGlzIG9ubHkgY2FsbGVkIGFm
dGVyIHN1Y2Nlc3NmdWwgdXBkYXRlcyBhbmQgdGhlcmVmb3JlDQo+ICAgIGFsd2F5cyByZXR1cm5z
IHN1Y2Nlc3MNCg0KTml0Og0KDQpXaHkgInVwZGF0ZXMiIGluc3RlYWQgb2YgInVwZGF0ZSI/ICBJ
cyB0aGVyZSBtdWx0aXBsZSB1cGRhdGVzIHBvc3NpYmxlDQp3aXRoaW4gLndyaXRlKCk/DQoNClsu
Li5dDQoNCj4gDQo+ICANCj4gK3N0cnVjdCB0ZHhfZndfdXBsb2FkX3N0YXR1cyB7DQo+ICsJYm9v
bCBjYW5jZWxfcmVxdWVzdDsNCj4gK307DQo+ICsNCj4gK3N0cnVjdCBmd191cGxvYWQgKnRkeF9m
d2w7DQoNCkNhbiAndGR4X2Z3bCcgYmUgc3RhdGljPw0KDQpbLi4uXQ0KDQo+IA0KPiArc3RhdGlj
IHZvaWQgc2VhbWxkcl9pbml0KHN0cnVjdCBkZXZpY2UgKmRldikNCj4gK3sNCj4gKwljb25zdCBz
dHJ1Y3QgdGR4X3N5c19pbmZvICp0ZHhfc3lzaW5mbyA9IHRkeF9nZXRfc3lzaW5mbygpOw0KPiAr
CWludCByZXQ7DQo+ICsNCj4gKwlpZiAoV0FSTl9PTl9PTkNFKCF0ZHhfc3lzaW5mbykpDQo+ICsJ
CXJldHVybjsNCj4gKw0KPiArCWlmICghSVNfRU5BQkxFRChDT05GSUdfSU5URUxfVERYX01PRFVM
RV9VUERBVEUpKQ0KPiArCQlyZXR1cm47DQo+ICsNCj4gKwlpZiAoIXRkeF9zdXBwb3J0c19ydW50
aW1lX3VwZGF0ZSh0ZHhfc3lzaW5mbykpDQo+ICsJCXByX2luZm8oIkN1cnJlbnQgVERYIE1vZHVs
ZSBjYW5ub3QgYmUgdXBkYXRlZC4gQ29uc2lkZXIgQklPUyB1cGRhdGVzXG4iKTsNCg0KV2hhdCdz
IHRoZSBwb2ludCBvZiBjb250aW51aW5nIGlmIHJ1bnRpbWUgdXBkYXRlIGlzIG5vdCBzdXBwb3J0
ZWQ/DQoNCj4gKw0KPiArCXRkeF9md2wgPSBmaXJtd2FyZV91cGxvYWRfcmVnaXN0ZXIoVEhJU19N
T0RVTEUsIGRldiwgInNlYW1sZHJfdXBsb2FkIiwNCj4gKwkJCQkJICAgJnRkeF9md19vcHMsICZ0
ZHhfZndfdXBsb2FkX3N0YXR1cyk7DQo+ICsJcmV0ID0gUFRSX0VSUl9PUl9aRVJPKHRkeF9md2wp
Ow0KPiArCWlmIChyZXQpDQo+ICsJCXByX2VycigiZmFpbGVkIHRvIHJlZ2lzdGVyIG1vZHVsZSB1
cGxvYWRlciAlZFxuIiwgcmV0KTsNCj4gK30NCj4gKw0KPiArc3RhdGljIHZvaWQgc2VhbWxkcl9k
ZWluaXQodm9pZCkNCj4gK3sNCj4gKwlpZiAodGR4X2Z3bCkNCj4gKwkJZmlybXdhcmVfdXBsb2Fk
X3VucmVnaXN0ZXIodGR4X2Z3bCk7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBpbnQgdGR4X2hvc3Rf
cHJvYmUoc3RydWN0IGZhdXhfZGV2aWNlICpmZGV2KQ0KPiArew0KPiArCXNlYW1sZHJfaW5pdCgm
ZmRldi0+ZGV2KTsNCg0KSU1ITyB5b3UgbmVlZCBhIGNvbW1lbnQgdG8gZXhwbGFpbiB3aHkgc2Vh
bWxkcl9pbml0KCkgZG9lc24ndCByZXR1cm4gZXJyb3INCmFuZCB0ZHhfaG9zdF9wcm9iZSgpIGFs
cmVhZHkgcmV0dXJucyBzdWNjZXNzPw0KDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gK3N0
YXRpYyB2b2lkIHRkeF9ob3N0X3JlbW92ZShzdHJ1Y3QgZmF1eF9kZXZpY2UgKmZkZXYpDQo+ICt7
DQo+ICsJc2VhbWxkcl9kZWluaXQoKTsNCj4gK30NCj4gKw0KPiArc3RhdGljIHN0cnVjdCBmYXV4
X2RldmljZV9vcHMgdGR4X2hvc3Rfb3BzID0gew0KPiArCS5wcm9iZQkJPSB0ZHhfaG9zdF9wcm9i
ZSwNCj4gKwkucmVtb3ZlCQk9IHRkeF9ob3N0X3JlbW92ZSwNCj4gK307DQo+ICsNCj4gIHN0YXRp
YyBzdHJ1Y3QgZmF1eF9kZXZpY2UgKmZkZXY7DQo+ICANCj4gIHN0YXRpYyBpbnQgX19pbml0IHRk
eF9ob3N0X2luaXQodm9pZCkNCj4gQEAgLTEwNyw3ICsyMjksNyBAQCBzdGF0aWMgaW50IF9faW5p
dCB0ZHhfaG9zdF9pbml0KHZvaWQpDQo+ICAJaWYgKCF4ODZfbWF0Y2hfY3B1KHRkeF9ob3N0X2lk
cykgfHwgIXRkeF9nZXRfc3lzaW5mbygpKQ0KPiAgCQlyZXR1cm4gLUVOT0RFVjsNCj4gIA0KPiAt
CWZkZXYgPSBmYXV4X2RldmljZV9jcmVhdGVfd2l0aF9ncm91cHMoS0JVSUxEX01PRE5BTUUsIE5V
TEwsIE5VTEwsIHRkeF9ob3N0X2dyb3Vwcyk7DQo+ICsJZmRldiA9IGZhdXhfZGV2aWNlX2NyZWF0
ZV93aXRoX2dyb3VwcyhLQlVJTERfTU9ETkFNRSwgTlVMTCwgJnRkeF9ob3N0X29wcywgdGR4X2hv
c3RfZ3JvdXBzKTsNCj4gIAlpZiAoIWZkZXYpDQo+ICAJCXJldHVybiAtRU5PREVWOw0KPiAgDQo=

