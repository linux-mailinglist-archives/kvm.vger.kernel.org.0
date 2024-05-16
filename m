Return-Path: <kvm+bounces-17558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 512358C7E94
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 00:38:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B460BB21D96
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 22:38:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D59D1F19A;
	Thu, 16 May 2024 22:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jUjkYnza"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF494A11;
	Thu, 16 May 2024 22:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715899107; cv=fail; b=EcbQgPxTY7f1sPrMTmCnFdg3bqw+8svbXNwMy9kvs+bGju6glD/FyqyCE18xxrMHMfPlG6gBPOo8p+3iBYwGvTYqMYkXZJVrhwvL5AwtxJN+xVBo2Oaq1GTZhJZE8tKz1wH7J7f6HkMQwWkY8hFwlKDuAKG9Qi1AFIeVW4HGkUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715899107; c=relaxed/simple;
	bh=ducAdxTW/akcFYGFW8ZyEBfqHAIokZ9kMqhcxiWZSkU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oWgW6E+osuvVsRuDMa2jQ65+19zXEZg9AJPb8YHwXzWE6Oaj+3IQAuaWBjcaIEHZhsSdV712taCAeJ0jjPAU39upyRkjezSAYYbbJ2yOJwJBJsalXkPNLxKzSJdwk6X8z7oMvLtficWr2AOXCzV4+30IstYqu1Im1crFGV7a5tI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jUjkYnza; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715899107; x=1747435107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ducAdxTW/akcFYGFW8ZyEBfqHAIokZ9kMqhcxiWZSkU=;
  b=jUjkYnzaJKcqikSEew7c1Aj8M/TCDzyEP84J2BLaU9MBpNrabM3V8xBn
   RVIPu4bYcAq6/0Hq8VCzrSaPGAEiUcIv0en3OkSIOGIKzlUs/X4ey80R/
   Jqto4EgiXn/7C2j70uVAxXvQwtBqLepPC1+IekgC95ttOX3J/3E85RdlS
   mk8/PYjAi7oJns3V61C9m42CYGWA9GDPUEvH6mjT9WetOgZDjvDStEoPh
   nG2kLJaI6Z12qfT4HtaEjKeiWVR8BlsHmKWCtfHycU049nhkzKyvXsKRE
   KecDQEVfdWq2F7RJt+jfNfQ3EFEBS7ohcj63wHSLVctsPTo3LNJppA5DL
   Q==;
X-CSE-ConnectionGUID: QYxcfF/0TkK+ub3L9x4EBA==
X-CSE-MsgGUID: sOhokLc7SROczYuaydRU8w==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15836094"
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="15836094"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2024 15:38:24 -0700
X-CSE-ConnectionGUID: wzlkHdBzR6eAjZ2GKqreXQ==
X-CSE-MsgGUID: 0jdAFdNJTvC+5VPuIYq3Ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,165,1712646000"; 
   d="scan'208";a="69039541"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 May 2024 15:38:23 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 15:38:22 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 16 May 2024 15:38:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 16 May 2024 15:38:22 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 16 May 2024 15:38:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBHYBD3azDlX3DIkiqh6zVH7fQWMbhccGM7C6S9jj7+rjZe1wA7AD07OTxf/6YFS/2t4l3ttz/OFJ7DZNR88GponUxgc6GBaL+dfUTvFbXJrwnHkPdZ8Mn6aDptpbgAH6+W+rXd3m0QS7uKahkRb4ngjKOfUOcA5JTzcWIB2vAfR+J2Pn5EkPXt5EUvnHJ134jZJU8r2Cb5D8+mYEnjL8xUZCQaLDs1O7/bRCujUN8OnEJ34V+juFE0ksrstd7DhNdLLd2R6LNAu1OWnkUZhc96U8uHt9pLaylWiQzZf97ej/x5epe3B+sD4EnGtX+GuijlFEZpsZbAkRCDKlix5xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ducAdxTW/akcFYGFW8ZyEBfqHAIokZ9kMqhcxiWZSkU=;
 b=RmQRCC2bH8lc9XT8FFo+s7SVuTPJSIJNhN1wsWA9A3Sm9tD1IIg7qelqCryRb/IfqGWwWhSQ/j1nbh8CM9JoOInwQrR/XU/sv8s41scmC0fY4TLc2sSUVIHxopEwRUrnXalQcZxBGqJmMim3qh4wKVdXyVVihpqf5bhuuzxefY7ds/RSdGMuJrtsYg++/lXqkK+z3ey8udB1JR0xxbDtD23y0tQQ7O3bUnJ4KR2/h0F7HmcXXxVYtFrm+VR6RT0Nz4xt+6OKpTSrFs9B+z4RMuA9HS3/7AG8Fzq/jJkBCc79AUZtyy8cBC7eA+sdSXHvcojRvIhaXvxq5ak69z/b+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6101.namprd11.prod.outlook.com (2603:10b6:8:86::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Thu, 16 May
 2024 22:38:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Thu, 16 May 2024
 22:38:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sagis@google.com"
	<sagis@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>
Subject: Re: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Topic: [PATCH 08/16] KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is
 called for TDX
Thread-Index: AQHapmNQnVfe1bKBZ0u4IdlZLB/mxbGaaC+AgAAKXoCAAAQqAA==
Date: Thu, 16 May 2024 22:38:19 +0000
Message-ID: <00d2cfe84f67dde1d9cbdcb2a2d907354e2d704a.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-9-rick.p.edgecombe@intel.com>
	 <aa8899fd3bba00720b76836ec4b4eec3347d43dc.camel@intel.com>
	 <e5d163ea-63ca-4c4f-9e69-6d1686be92c3@intel.com>
In-Reply-To: <e5d163ea-63ca-4c4f-9e69-6d1686be92c3@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6101:EE_
x-ms-office365-filtering-correlation-id: 706155a7-ba2b-4b2d-8996-08dc75f8e286
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cjhrWjVuMVUrekc1STRhcVZQamx5WkJEMllMSk9odm4xdlJkSFFjdkt2RGxU?=
 =?utf-8?B?cGpPR205bnRTakRpVTRyYUxRajZsbmRIUFUvSW9KL21oN3FkZTNEVUlUWURR?=
 =?utf-8?B?YTg5Um8xRXVOckFIN1Vla0ppcmNwS2ZISHhERXRGaVFqZUdSQjVSdkc4cWlI?=
 =?utf-8?B?dzZrRERyU1NPamF3cHdZb3hvc3Q2QkFKa1RUTWJCc3pqQ0gwODdwZVRiUnhm?=
 =?utf-8?B?ZjN5U1lCek9xVkxvSHVOVW04WWFvWnVaZjF1TmFqUUpJcGtrdWF6KzFSa3BE?=
 =?utf-8?B?LzVSRGYzdzFCZGgreGUwbDF5UUVoYUlNdHBySWRwMVVpWVdXTWlQa1ROZmx4?=
 =?utf-8?B?bldHVWV4NjNrOTcyTkVGMVZ5Q2xTQ0JudUNRT1BjR0lIMHd4N09UMUkzOEVw?=
 =?utf-8?B?dFBQUVB3TkhzRkJGSmEzNFZpQUFOYStHMTlnYnhlTHhnRVVyRWltV3JGTGRm?=
 =?utf-8?B?THBmejJEVENpRm96aFhUeWoyVlRqT2tpV1Q3Rk5JQ0VYQ3owcndxbTRuL29m?=
 =?utf-8?B?T2owSFRPSmM2YWEzcHpOa2hLR1Y2WFFvQUJQN252ZUlrcGJZUmxaWmRBQ0xa?=
 =?utf-8?B?aGZJb3JDWi9CcytlN3IzVDdORmRHRTZNekg5UVErT3YzZ2ZkbldyQWJvc0ky?=
 =?utf-8?B?eWpkejRBeTZKaHp0RTRaTkwyZk1tNHlBbDVBUWJDUWYyV2JNOWNvWEwvV0Vw?=
 =?utf-8?B?ayswdWpyWFRxUE8zQlZwME5CQktYeElmaTR4Lzh6UDJpdkxZSzY4c0RFOGx6?=
 =?utf-8?B?ZmNMbGczWGZ2WEpSK1pxU1BKdFMycDJFRUw0eGtpY213NHk3eWlVTlc0aFRr?=
 =?utf-8?B?OHJDV0ZxVlE0YzdRdkEyNWtWSUJIYjhWdEk5V25vTUt3ZlZ4bE0zQzZDVUF1?=
 =?utf-8?B?YW1HeU4vbStESzhQczVsYlRlaCtma3h5S1dqRjhSU2V0VDdPOTNKaVpTbEx4?=
 =?utf-8?B?bFRSeWszampDbGRFWjRsU204dzNGWUlzY0s4RWlKNTREY0dkVlR3YVhTMWVo?=
 =?utf-8?B?b0pyQkk3ZG9JdGdIaWFOeFJEbTlpT05VTUJibWNWeG9veGprbklkdTFOSEVL?=
 =?utf-8?B?LzcrUEZMTDlUMU9KdWI4T2lnMko3UUVOdkw3bENTUWROY1llN3pYekpnQWZQ?=
 =?utf-8?B?RjM5elBlbWR3VzFybGdrTnFCaHJLbHZKUndxTTBjdjdYNXlicGtxTDdCeXFk?=
 =?utf-8?B?Z3VPaXlqSkg3bm1vOWdPbTBlNDdNUnFIREdpWnI4bWdSRkhzWkI4bUxTVWkr?=
 =?utf-8?B?YWFhSjFrWFZRUmxGNmJWOE1sRXhSS2NHd3pWZjEreWZQc3FGQnlCd1BwOGhu?=
 =?utf-8?B?OGorZU4rUXBXbU1CZDk5UWwyK0hRbXVvc0VLU3Zvb0REdDJIRFR3M3BCanFL?=
 =?utf-8?B?RDJnUFVTem9jdFFUemdDaThVUGVZdStqTnkyZHhPMzNKRHovT0FnUVBlczg4?=
 =?utf-8?B?STRjRzJ3bkxOWlNYS2ZvN3JIV1VkaG80T3k3WjR1dERJWW1VTTkyYkt2bU4y?=
 =?utf-8?B?QmpWSGRocGIzVGp2aVY1dzk2TjZUQjhlSXJZbCt3UnphZDlGc1pxVmsrOEhQ?=
 =?utf-8?B?VmdaZFQ4Wmtad0lFTExtaTBDZmt6U295U3lkbmliMjdJTjFHVDFQZVhKaitW?=
 =?utf-8?B?amlZTTdZUytPdGtGUnVjRzhidURPVHd2NmZidzliMVY3b3pYREpPczRJckNL?=
 =?utf-8?B?SUlVeDR3Q056UllvTWxQVXVOWlNzZkkrWkE4cWh0L0N1TmExcFY5SFNGaVpQ?=
 =?utf-8?Q?cNJCUJcj46r75Ub5VM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWE0RkQ1bk14ZWpTbTBLNTFNdnNGcmhUVFpqUXp4dXNJY1FaRVJPUkZRTnNI?=
 =?utf-8?B?MG9HY2hTYlBJMUFMbTVub3psWVpYa2FlWjRjNEw2TWhCQ1NUa2RuMkkwS042?=
 =?utf-8?B?VnRubDdGZVhNdDJ0aFRQbTZET1pYb3ZrNTBkKzNXUnNWR0xJVzkzQUZud2l5?=
 =?utf-8?B?ekdXbm1HNUxFYlUxR2JsZHFiRnNTK2pTYkVRSlpTdHFBaEQ5a2NmRWI0NUN3?=
 =?utf-8?B?NkljZ2ZRa2VaVFY1bit5eFprNGZRTlErSDVpMExCelhRcXV2RkFLN0lWd1RU?=
 =?utf-8?B?VTdURzZrYXdXMFh2UVN3ZXFROG9FdUVoV1VWNjZpcWZYL21OdjR4eFR6b1R4?=
 =?utf-8?B?djJEeFlQVHVMbFpuTlRxMmtHdUJPVU12SXZsTG5wYWdaK2VuU3dJUENPSENM?=
 =?utf-8?B?eVNtTW5COEZpRmdHTU0vT3ZpMUp0WTZvY2xObjNsTTJQU1lsNlV0TnFmWktX?=
 =?utf-8?B?VEIxK2FReGg5dE1MVEFCdHpJNVA0TU0yUUt4N1RIRTlKYWNGSEs4QmE0MHND?=
 =?utf-8?B?TkNRMi90eGtKczBXbFVwbzZTcEx1Z3hDajNZaHN4Vm12L2tSUGkxUll1V2lm?=
 =?utf-8?B?RHZ2aVRqM0xKVkszcHZCUkdhZVpBbGpWcjFUNEJ2bnRwa1lRY0tTMkxFRnBZ?=
 =?utf-8?B?M1JWaERlL0NYMEdoZVAwZFhHbHBoc1p2dzYvYmdLOFY2RUxJNTRhcjh0cEdw?=
 =?utf-8?B?Y1ErRjJWUjVzaTNocUV6R1JOVDNpemRxMENoNXJUUmVtSVBacTFXVGdNdzZG?=
 =?utf-8?B?YmZJLy8wbUdGWE1DZVV2Zk1wV2wzVlpNem1OdkorR2pXaGtJYlM1ajE3SDFU?=
 =?utf-8?B?ODExRVRLa3VtMnFHaUpVL1JpcWF6aTBmVjNKUHE0VU5CVTcyUjkvWW5adFRO?=
 =?utf-8?B?a1R2SWw0Nm14aUJQVCtDdEcyU1RWZG83Y3FmOEk0U0JjV0YwdFhWckduQ2xZ?=
 =?utf-8?B?dGl5SXRGTE04eXBubTdJMTRXdndlYlVRV0lxTWE3YWx3dGorY1BISjFHZDN5?=
 =?utf-8?B?SFZRbUMwdGpsYzlOL0xjMDg5VldIQ0NLRU5qV25BekxrK3lsYlpEbGs1eVZS?=
 =?utf-8?B?aEFHNnNLd3Q4a2prOGxham1pQmUybnNwQ0lIUDFJSURiQ0U5RENkT1dmMmcw?=
 =?utf-8?B?UVBHSUJPMDNwR0RwTW5kcEJwT3UzT1ljRlA1M0lsempzdHFjazFQYjBaL3BE?=
 =?utf-8?B?bjJ2Snp3cll1ZzRDTDlLMnRPOGNINVdIdFVzRFNOZVJ2S2pjZDZaMEZWNjdq?=
 =?utf-8?B?TGI3clB0SkhwT094bFkwMUVrdFRaYmk1YnRsRi8vaGFDT1NRdTdCUExaSGVz?=
 =?utf-8?B?T1VScTRYYmZqZXJ1T1RTTHo1MkpscjBBd0hOL1lsb1dyL2ZwSG1GbnJlZXBs?=
 =?utf-8?B?eDY0SUhPLzRwdWZhWEpqOXRnRDhUTm0zaXJDQ0R0a2UxemE5Q2pZcUxmYlVK?=
 =?utf-8?B?S2dvcHZoRDBRZ0xhbU5xYjQyZndNMFBtNnh0ZTZKb3Q3RFZnTkk4ZWlLT2Mz?=
 =?utf-8?B?ZHBPUkc0S3R0d1oxSUtyWk1uS0U0YjRLblpXT09Lb29tcUpFa3U4S1hSSGNE?=
 =?utf-8?B?Z3ZiUm91UnFSbDlFRW5kVWN0OVc5c2FvaGc5RHdoVHB5a21CY0F6STlHVXZ6?=
 =?utf-8?B?N0xUblBoMmNRV1hnR0E1SktJZm12c2F4NEJBNUI2bGMwcVZqeDB3OFJOa3VZ?=
 =?utf-8?B?aEM4c2pOSkJuYnRNYUhwRnp1SnI4VHNXeFVGaVhKNUIzc2lKbityTExVWFU1?=
 =?utf-8?B?MjZ6ckFRc0pZQzNHRnlrWk1yOE1lUmdmcDhaNzFoSGQvTEFmOGszVmZHQitK?=
 =?utf-8?B?a1d2OUdJWnMwUFdxdWVFMjMrb2p1QnZWbHBIMEpBVHY5UllEWkR1WUVtTlhx?=
 =?utf-8?B?MlhBQzlsaUkrVW5neng5UTFTTXFLc2pFdGZ2VlA4S3RXTitSTlZVZFhockxq?=
 =?utf-8?B?QStTQ2R2dnl6Syt3aGlpL3ZBU3RoY09OTWE0aEZDSlR4L3hYL1pJZ3VNSmF4?=
 =?utf-8?B?TWVYd0IrSmtMK1h2Tk1tL3J5dC9zc1U3LzRQMVlFSG85NXVXaEVKOWZCcDFw?=
 =?utf-8?B?T0wraWNwa1lhOTFQMHVZUTJubHY3YkZWYzVEOWgwSXNldU9uWVVlQzZZNmo1?=
 =?utf-8?B?SDNoSm4wVTB3aFk1ZVZocmNtWFJIeW14VG5Qb01SMDdheDA5Y2hPUWRtRE9n?=
 =?utf-8?Q?jBe9HCxKJpZT2L6c1bCtP4M=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDEA6CF730980D4C8C20A638AEBADD5B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 706155a7-ba2b-4b2d-8996-08dc75f8e286
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2024 22:38:19.2485
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k4f6/LxWCOYe7HqyI229bBs8nUcTzCoMfF9G31sR87/8Y8S2ZdCyFViwKzIKgg2k/aBnhFMa6Isy4AlnrdIZ0BGv9Zc9gv5J1dtSgwt9LVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6101
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTE3IGF0IDEwOjIzICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biAxNy8wNS8yMDI0IDk6NDYgYW0sIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNC0wNS0xNCBhdCAxNzo1OSAtMDcwMCwgUmljayBFZGdlY29tYmUgd3JvdGU6DQo+ID4g
PiANCj4gPiA+IEZvciBsYWNrIG9mIGEgYmV0dGVyIG1ldGhvZCBjdXJyZW50bHksIHVzZSBrdm1f
Z2ZuX3NoYXJlZF9tYXNrKCkgdG8NCj4gPiA+IGRldGVybWluZSBpZiBwcml2YXRlIG1lbW9yeSBj
YW5ub3QgYmUgemFwcGVkIChhcyBpbiBURFgsIHRoZSBvbmx5IFZNIHR5cGUNCj4gPiA+IHRoYXQg
c2V0cyBpdCkuDQo+ID4gDQo+ID4gVHJ5aW5nIHRvIHJlcGxhY2Uga3ZtX2dmbl9zaGFyZWRfbWFz
aygpIHdpdGggc29tZXRoaW5nIGFwcHJvcHJpYXRlLCBJIHNhdw0KPiA+IHRoYXQNCj4gPiBTTlAg
YWN0dWFsbHkgdXNlcyB0aGlzIGZ1bmN0aW9uOg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2t2bS8yMDI0MDUwMTA4NTIxMC4yMjEzMDYwLTEyLW1pY2hhZWwucm90aEBhbWQuY29tLw0KPiA+
IA0KPiA+IFNvIHRyeWluZyB0byBoYXZlIGEgaGVscGVyIHRoYXQgc2F5cyAiVGhlIFZNIGNhbid0
IHphcCBhbmQgcmVmYXVsdCBpbiBtZW1vcnkNCj4gPiBhdA0KPiA+IHdpbGwiIHdvbid0IGN1dCBp
dC4gSSBndWVzcyB0aGVyZSB3b3VsZCBoYXZlIHRvIGJlIHNvbWUgbW9yZSBzcGVjaWZpYy4gSSdt
DQo+ID4gdGhpbmtpbmcgdG8ganVzdCBkcm9wIHRoaXMgcGF0Y2ggaW5zdGVhZC4NCj4gDQo+IE9y
IEtWTV9CVUdfT04oKSBpbiB0aGUgY2FsbGVycyBieSBleHBsaWNpdGx5IGNoZWNraW5nIFZNIHR5
cGUgYmVpbmcgVERYIA0KPiBhcyBJIG1lbnRpb25lZCBiZWZvcmUuDQo+IA0KPiBIYXZpbmcgc3Vj
aCBjaGVja2luZyBpbiBhIGdlbmVyaWMgZnVuY3Rpb24gbGlrZSB0aGlzIGlzIGp1c3QgZGFuZ2Vy
b3VzIA0KPiBhbmQgbm90IGZsZXhpYmxlLg0KPiANCj4gSnVzdCBteSAyIGNlbnRzLCB0aG91Z2gu
DQoNCkFzIEkgc2FpZCBiZWZvcmUsIHRoZSBwb2ludCBpcyB0byBjYXRjaCBuZXcgY2FsbGVycy4g
SSBzZWUgaG93IGl0J3MgYSBsaXR0bGUNCndyb25nIHRvIGFzc3VtZSB0aGUgaW50ZW50aW9ucyBv
ZiB0aGUgY2FsbGVycywgYnV0IEkgZG9uJ3Qgc2VlIGhvdyBpdCdzDQpkYW5nZXJvdXMuIENhbiB5
b3UgZXhwbGFpbj8NCg0KQnV0IHlvdSBqdXN0IHJlbWluZGVkIG1lIHRoYXQsIHllcywgd2UgY2Fu
IHByb2JhYmx5IGp1c3QgY2hlY2sgdGhlIHZtX3R5cGUgaGVyZToNCmh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2t2bS9mNjRjN2RhNTJhODQ5Y2Q5Njk3Yjk0NDc2OWMyMDBkZmEzZWU3ZGI3LmNhbWVs
QGludGVsLmNvbS8NCg0K

