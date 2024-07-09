Return-Path: <kvm+bounces-21244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB8892C657
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 00:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E38AB21641
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2024 22:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC2B6187850;
	Tue,  9 Jul 2024 22:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jtaLwi26"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166C014D439;
	Tue,  9 Jul 2024 22:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720565541; cv=fail; b=V6F3EQUcoQpV4lpKlL/ZQlndTe7eZZvF92hr0R++7OXqe6R9383aHb2Pco/HnqBNH/HKmnmF8uK+Xkz3xMnbR17aXAtdj701bFBlMZe46UQtjwXecSlrhWU06YqItp1qjJeR0/pZShRV9bnr9W9SZaP+VMvDiTc9rer4kNYMKJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720565541; c=relaxed/simple;
	bh=PDrRm7oIzn4jFa1SaeJhSa6tnX7eZaN3d9nZdogQ4fE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mRrK5hArYLJi1r91w28VUMNPzijKAkinfRvGFr4PVYbyxnBYmrKNYDjJaXwKASIwc5wzGlvteeFpBonf+P9oYZbOMG3m0MR9OQ0ciBITp3kZua46iWjOCqGb4B7SU6Ii6HyGQNaGZUDffAb3xI8K/EocC08StIvm0WUSIa6QS/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jtaLwi26; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720565539; x=1752101539;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PDrRm7oIzn4jFa1SaeJhSa6tnX7eZaN3d9nZdogQ4fE=;
  b=jtaLwi26oyCGqd3kvzRv1io2zyMYEQV/gqWgYsycUVHz6pvSKNCSq1KA
   ICNYgXWJqswttOyPhVKlYzrMlwU1r07ypuxiDUB5VumbJ2fh425Lf/9Zc
   lbGW953nUt7gskKcJWMnTx+uMF/a6ZnrDkk0IT1qjMYAKlqdKBNDg9StB
   nzp7gchhIfgrmH2Vu0jzKSgx5wwak5u0aRo4UYHsrzeM+GDmgpkC7ViEw
   J1w/fzcRYdfJmiKOuYCFyxnFURqYqM2IOp4WlMzr54Bgi6oIpoQM956BQ
   9op0+xUh1TZrI18pCCJ+eJvcE9DYtp8lAcGwOBAVzsu2jPw1KuCmCagvu
   Q==;
X-CSE-ConnectionGUID: +EJNGXN2SOSqX3uohPOEWA==
X-CSE-MsgGUID: vxf8G7xpSaetAncdU5SFFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11128"; a="17487239"
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="17487239"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2024 15:52:18 -0700
X-CSE-ConnectionGUID: Lr5aUulfRqegjPV66GDIMg==
X-CSE-MsgGUID: 5aCd9HiVSuWJU5i7Mp8gMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,196,1716274800"; 
   d="scan'208";a="48457292"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jul 2024 15:52:19 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 9 Jul 2024 15:52:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 9 Jul 2024 15:52:17 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 9 Jul 2024 15:52:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NU6K6ySYjiojPYVhTtCwYk9nRhOwNsmgSCcbPZKRWSdrlX0dLKmm2/pFymsAuFCm4IhPw3BSy7/pAzd9NUFB+2BBiKfYnsDB4wg+x0ArGqQrdKYpmoggvBaTrsWBij3b29Qb2CKZKmDQK+H6YU9COFxP9A5ToMAwOo4jEvU60cOSjSjosVwnxs1FocF6tc0iKJW/Bk+Oh88w8+Pm+n98q2gbtakAPXVACOeIUe1pGCTW5/G3NDA/3qI0MUyao6UEVYqjstX21MrfIwjBcYql+dD4j89D5bCq+dqUoonESIr0hFGx7XTGj9MP1KOi2LGffDEcTevu8RZvxLZgrjMjzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PDrRm7oIzn4jFa1SaeJhSa6tnX7eZaN3d9nZdogQ4fE=;
 b=jx7iBmzjbsmZWfobpnVRNPDlz02rs4eJQ3MHYTBko6wW4iZ3L0S/Q+Ge4ZtH91ewPW7m802LnjDVST7urzvktEP2XxpxnzsQ826yWw9grx2FS0XarKkjBUPp5Gpscc4M7Bk480TnPZ5RYPg3Aw2obq/WnXGegCWlnBBE8yEh1xrYQQ2MAVPGpcZK/BfS0nJJ631J/Fp5NWHczIj/IBYwuqfh/W7kKIcJTf/Qvg9cdFLHShG61kKCCVgoQld6moRAE9IgX6FAY/IDBJi63Qe4tX5bu7lv58S3on2FG9CXpanhzscO98xQs7EboCzv4VJlZQWbV/ZADKA7CeDplb/Plg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5165.namprd11.prod.outlook.com (2603:10b6:a03:2ad::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 22:52:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 22:52:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Topic: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Index: AQHawpkmqvK9+rV8gk+Fb4hYJXFjCLHRzw4AgADIg4CABASjgIAA908AgAB1KwCAAPZwAIAAW/6AgAwm8gCAAeq7gIAHs0oA
Date: Tue, 9 Jul 2024 22:52:13 +0000
Message-ID: <886ebfebf435d40f4f1eabd79515e6a1ddf50ca6.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
	 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
	 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
	 <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
	 <d12ce92535710e633ed095286bb8218f624d53bb.camel@intel.com>
	 <ZnpgRsyh8wyswbHm@yzhao56-desk.sh.intel.com>
	 <2f867acb7972d312c046ae3170670931a57377a8.camel@intel.com>
	 <Znt8K7o0gCwjuES+@yzhao56-desk.sh.intel.com>
	 <c2380408eff9fb8501f2feee571e96eab5ca882b.camel@intel.com>
	 <ZodJeS3qhO6nJ0di@yzhao56-desk.sh.intel.com>
In-Reply-To: <ZodJeS3qhO6nJ0di@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5165:EE_
x-ms-office365-filtering-correlation-id: 983db2c5-9626-410e-00c0-08dca069c5f1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TmR6c29lb0R6Y0VvaGRkZ1ZEUEgrU1Q5VW5pdmFuYXpWMWl6SXZzVTJ1Nktv?=
 =?utf-8?B?VHNTUUw5MXVnN0lHR3g2M2NldTQwTFgwZEowZ0xHc2RvUU9xRG9QQzJTMXVB?=
 =?utf-8?B?bXlVZ015bXVwczZqQW8rRk1HZXpnQ0RkMHZlaDUyQ3lPcUlOUXNXaENUWmtE?=
 =?utf-8?B?SWVaV2JuaThFK0xzSE54Y0RQU25UL3A5d05qQ1U2RTRtL3V6RkVnY1RzaDZD?=
 =?utf-8?B?NUwrUHRHejMzc051c0s0cTBZOFlVRGdXT29RcXRvc1pCLzNxeUJWVEtobVBF?=
 =?utf-8?B?RFJzNGVtbG4rNlBWdmZyVkVNakxkbWFtWjV5WFJsUFBQN25EaGgxNlpWS0cx?=
 =?utf-8?B?ekdKZC96OVJITFpNRzhsN2UrTDZqTGdkWHFCUXE0cUQ4U0VxbVlEVWRac3dx?=
 =?utf-8?B?L09ubnZ5Z21UOW1MT0gybGhicTZMdFI5a0ZGNUJkcG45ZzBsbVB5dEl6aUVu?=
 =?utf-8?B?VXYxZkhWS3l5NEVUL1NTd0tpWWUvWmtvQVlLYnI2YWJSdWowdTdVZC94Z0Nk?=
 =?utf-8?B?WXZpS01zSFV5K0plZjZSQUlvejMydDQxRlYwdTFnbGh6NGlXMk1QcXRES2k4?=
 =?utf-8?B?ei9sdW5FYmVaZ2g4VkwzTkl4Uk00YTNMOUEza2R6Z3U1Slp4M2RHdm9CMncy?=
 =?utf-8?B?Z3VOMjlZdVkrenc3cGsvNTA4SlhUK1VNT21MOHg4Q2dFY2lKTW5SMzIwODVC?=
 =?utf-8?B?RytMdHU4V20ydmNCc1c4b3BPYnJkSlRiUDFVaWo0Z0tnVlpGR3ByVnEyWVVn?=
 =?utf-8?B?aGNjZnBQZE1HaS9YdnQxMm5meVJvNjZFVUt2a21FNVdzWCtxenIzaXpGWjJl?=
 =?utf-8?B?NE1wNEV2by9SQ2M0cFpSbTdmRzZZUDVmRk1rVlRHSHhpTFd4eGFPd24zU1hW?=
 =?utf-8?B?cDhsTUhYNS96bU1LZ0Rzdzl0N0F6RUNJY1FLQTJFdVRCVTh2OE96NHlWdWp5?=
 =?utf-8?B?ZG1NUWtvdERpSndtN3k1T3R3WXFmbndLSS9Lc2VtbkxoY1R3bXF4UHlrWnZJ?=
 =?utf-8?B?UUhWZjJBUms2UitsaU9CcGRIV2xEUHorbUJUMnora0t4QXpoR2d6S1RDRk5Y?=
 =?utf-8?B?YXM1d3FXcHI2bEk4MTl0cE9sVmczdXUwMHJBWXc4S1hFczhDSkZ6RnZhdnNJ?=
 =?utf-8?B?QjNJbmNQczhQa2dlelo3M1RtN2J5ckgvY0hiblVxVjN3RXJ0ZTl6WlIrZGgr?=
 =?utf-8?B?MEN3NStyQjRFdHlGdGtPN2s0ak02K3VuTnpFd0tiZWJZWSt6ajM0N3FjUXZP?=
 =?utf-8?B?aVNSalY2dUJXd1h2RXNTYndwYUZ6YXpLd05ubXRBN3Z2cytPbVF4NlFNeC9r?=
 =?utf-8?B?MFN4ZGZ2dXdtcUpXdXBwaFZYR2M5RXg1WCs0ZEVkdFJnUUtlWlJBYmFKbVRR?=
 =?utf-8?B?L1dkSVZNQnAvdXlFNjJWMVhGY1dTZmJSZjdERkhpUmhNMVFHcW80ZDBHOEpm?=
 =?utf-8?B?eW8rVWhpRFZETXVyajkvQWk3cVlQdkM2amdaMUVVQXVUSEFTNHYweG9FeUxp?=
 =?utf-8?B?N3NJWTVYVHp4NkZrbUo2MnlCMVU3REFtOE90YVM3bitncUU5clorSzlZTkg4?=
 =?utf-8?B?UXNvRWREdzZ5QUZjaS9SQWpEeHUvdGlkTjltMG4yUkREZ2p5VGN0WVk0TXNP?=
 =?utf-8?B?OUd1dFZodVE2YzlhTHNQMjhlT2VYczcwMGY2ZE0zY1JDSzh1RjNWNmpZTkl0?=
 =?utf-8?B?bFF2WGRKNEhCUWxQQmNVNE91RGZwem5GREMvUFJTTDhUNUI3Z0txemVQWUZF?=
 =?utf-8?B?bEpOQUdhYXdFb08wckhXMVEvbnNuWk1tRmF4SkdFM1lQRVJMajVidUNXb0ZF?=
 =?utf-8?B?Q0p6bUlubmhRRk5MVzUvZitOUVF2QlkxVXRQSFhRTi81NXFVcFBuOEtZWHZZ?=
 =?utf-8?B?OStWWjN3dEREOTlhOHN0SGV1WUlxelU4ZjB1YWF0bi9BMXc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEdieS9IN2xTMTRBTEhrK0JzdUd0M2ZlRHdPc0ZIL2hlZkRteUgzRDFJd0wv?=
 =?utf-8?B?WXkvSjhNKy9kZEJ4T3RHcmg4cWlFY041NGhrcXRvUUtwV25mWG9PNERiQ21F?=
 =?utf-8?B?RythZktKa2JqTnhpWmR0ZXVWZVpocmM0V2ZiOHRNNzJ4dGx1L2VJWGwvR2hF?=
 =?utf-8?B?bWNkVzFEVE15U05lZnlYL0plRi9UeXVKb2Zzb3I2UDhzeFlGNXNkYk8ySHcv?=
 =?utf-8?B?Q0NPdkRTbnJ2NFlzc0xCbC91bktMbVI1SENUYkZQazZMZTU0ejdTVlpJZ3h1?=
 =?utf-8?B?NTJuaHVaSEZ6U1d3WlBxYlhYdk1RUFdnUWJMTytSazhOZ1g5NFM2aDJuYVhl?=
 =?utf-8?B?dGNyNmcxMm1pK1JGVzcwMXc0d2xNWXViZFRzQ2gzM3k3Vm42NkN3T3Z5SzFu?=
 =?utf-8?B?NDhWalFuMmFYcC9Dc3dTbm5USjkyNkxZRnBGSkw5ZTZ4UE01bkZRTFAxRUh6?=
 =?utf-8?B?Q2lUZG0rR1RJdFdrWFd0emFxVkFvS1hvTFRrRjZLN2lGamVnWHozN2ZmS2ps?=
 =?utf-8?B?UjR4MVk0dWdXS1hsck1QVlNRcWJkblZVK0tBeUNSMmE2bi9iamtVUS9EV25u?=
 =?utf-8?B?eUQxZnh3Vk85ZkNoNUJ0bzdIN05ma1RjMEdxU3dCMk51RmdUTUlwb044dHRo?=
 =?utf-8?B?cEJCTloxTTRHQjZWRFJ0cTNCRUt3Ujk1ZW5VVTl6dlkxQVBmTDVjVnpGRVNz?=
 =?utf-8?B?eDM0eURCN2ZpY2c3d2JJNDJ6UUhtOHZmZ0ZQU1V1bmovUytVRTllSjJuVklQ?=
 =?utf-8?B?WjFMQXdqdHJGMWNiUUdjUU1wZU9UMEFuYVN6emVaRnZURysyMkRJcTB3OWI5?=
 =?utf-8?B?UWwzWXRyOWN0dGRqN05RcVovYW5pYUEwWUxLbk8xbFFXOC9LSWkvTGpFaWk4?=
 =?utf-8?B?SzU3QWZJVkk1UDFmOStqeUdoWGgzaGEyOG13SEJ6T1FGMllCUzQvVmtDOG1h?=
 =?utf-8?B?cHNDeWNUUGh3alFsVm5TVm82WjN2WDdBa3YwZ3E1WFUzRXJaWUJIR2gxSnpX?=
 =?utf-8?B?aFBZKzB5cEdIOXBXNk1NaXlFYml0WVVSUmJaQ3dOQk9YdU12SnIrckdFbWN1?=
 =?utf-8?B?N3VzYXpQS0o4aG5qdkRpSDhOS0MrQW1LaWhoK2d3NkQ4SkN4VGpDbWVwVDNO?=
 =?utf-8?B?eUdOMEY0ZFNrTTZ6RU8yUEJjTzlTRFFUQXBiY1NpODIrTVdvOHA5N3A5cXIx?=
 =?utf-8?B?cXJwSFJFUFd6YWgvbFJTVE5FMnptTUhybHFZYzJJbTNiWkVTY1doWFpybmZS?=
 =?utf-8?B?K3dyNVRBcCtRZWVLYlNOa3pWejlBam5Mc080aEJ3Z28yci92UXZVVnM1ZmVm?=
 =?utf-8?B?YUw2a05NVktUZ0cyYUcwT0JHN1E0TE9pQkYxYnAzNVlEQVJtVzY2Q0lnQ3FL?=
 =?utf-8?B?WDFTZXEyRCtCTjBkUVhJMUtudEQwcHhYd0dtUGQ1QmdRbGpOS3VqT09meVZo?=
 =?utf-8?B?Z0FyNVBPMkdFaEJmTCtVaWhkL3ZING11VGg4K25VSy9xVTREY3Mwb2tkb2w1?=
 =?utf-8?B?ZHNjWC9CQ3UwdktoN3pDUm1LUHNKakpZOWNRS1ptbGVGNXRIYUdrQ0hGRHlZ?=
 =?utf-8?B?Yzc2UkNzdVYxaTlseEJJNzlyczNXRzVxK0tqanBaeEZBdHI2WEgyeUUwMjlO?=
 =?utf-8?B?SlpNYmpWakNDWThBNDNuTlhtOExXUlFJd2VNMzVoQzFJUzZxN0orZDFZNCtm?=
 =?utf-8?B?VWIzWm5ocFJZN25kR3V3dTJOUFBiaENGajczZzlIKzg2cXYrRzNhOTBKazJy?=
 =?utf-8?B?b214bEw1ZTNEY0daMGExaXMzbWhIKzdKZ3VZM1ZvVDdYT2swVUhjcURjam5v?=
 =?utf-8?B?M2dsNWhlMnNzcWQwNXBzakg1OEI1NzI0Y2tjcmxTbkFPd3FtdTZQbXB2QVR6?=
 =?utf-8?B?SWFRNStQRCtaS2VUZGNRMy9XTDB1aWVoQXBUcngxMHB1R0FBUDIxdnFDK3d2?=
 =?utf-8?B?OHA3UE5la3BxYmJ6Nmg4bVNPSjgxSjVDUHZySDRJVDNwYkVQU1dqcWl5dU5Z?=
 =?utf-8?B?dVhJNVlXMmxMaXZONHBSMFJ3MVpXaUxybDdtRnU5SG5UVzFkQlRZeGRKQVdp?=
 =?utf-8?B?K0NvOTMzMmVOQ01FWUVkTkVzSC94K2dDOUN3VC9RVlFseGtNMTBNYnFwbDFz?=
 =?utf-8?B?RkoyR0hGZU1KYlVyZ3hwQXFaN2MwVHdJN2ZLbnM0Wk1pbldRdTl3dkVOWEZO?=
 =?utf-8?B?SFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6CBF603DE7AB654F98AEB782C7E42059@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 983db2c5-9626-410e-00c0-08dca069c5f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2024 22:52:13.2448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I4fXbOKtBU9KR8mXFzxsiHKdKHhsMOL2Vfgq2S4ZglSCshf2UHfKGj5xcnnBJM9RmWVneQo2BkP9Va+kEVNzUoRDLPkfi96PPi6Ebl2S5zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5165
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA3LTA1IGF0IDA5OjE2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gVG8g
a2VlcCB0aGUgZXhpc3RpbmcgZGlyZWN0IHJvb3QgYmVoYXZpb3IgdGhlIHNhbWUsIEkgdGhpbmsg
c3BlY2lmeWluZw0KPiBLVk1fRElSRUNUX1JPT1RTIHwgS1ZNX0lOVkFMSURfUk9PVFMgaW4ga3Zt
X3RkcF9tbXVfemFwX2FsbCgpIGlzIGVub3VnaC4NCg0KUmlnaHQuDQoNCj4gDQo+IE5vIG5lZWQg
dG8gbW9kaWZ5IHRkcF9tbXVfcm9vdF9tYXRjaCgpIGRvIGRpc3Rpbmd1aXNoIGJldHdlZW4gaW52
YWxpZCBkaXJlY3QNCj4gcm9vdHMgYW5kIGludmFsaWQgbWlycm9yIHJvb3RzLiBBcyBsb25nIGFz
IGEgcm9vdCBpcyBpbnZhbGlkLCBndWVzdCBpcyBubw0KPiBsb25nZXINCj4gYWZmZWN0ZWQgYnkg
aXQgYW5kIEtWTSB3aWxsIG5vdCB1c2UgaXQgYW55IG1vcmUuIFRoZSBsYXN0IHJlbWFpbmluZyBv
cGVyYXRpb24NCj4gdG8gdGhlIGludmFsaWQgcm9vdCBpcyBvbmx5IHphcHBpbmcuDQo+IA0KPiBE
aXN0aW5ndWlzaGluZyBiZXR3ZWVuIGludmFsaWQgZGlyZWN0IHJvb3RzIGFuZCBpbnZhbGlkIG1p
cnJvciByb290cyB3b3VsZA0KPiBtYWtlIHRoZSBjb2RlIHRvIHphcCBpbnZhbGlkIHJvb3RzIHVu
bmVjZXNzYXJpbHkgY29tcGxleCwgZS5nLg0KDQpJJ20gbm90IHN1cmUgdGhhdCBpdCBpcyBtb3Jl
IGNvbXBsaWNhdGVkLiBPbmUgcmVxdWlyZXMgYSBiaWcgY29tbWVudCB0byBleHBsYWluLA0KYW5k
IHRoZSBvdGhlciBpcyBzZWxmIGV4cGxhbmF0b3J5Li4uDQoNCj4gDQo+IGt2bV90ZHBfbW11X3ph
cF9pbnZhbGlkYXRlZF9yb290cygpIGlzIGNhbGxlZCBib3RoIGluIGt2bV9tbXVfdW5pbml0X3Rk
cF9tbXUoKQ0KPiBhbmQga3ZtX21tdV96YXBfYWxsX2Zhc3QoKS4NCj4gDQo+IC0gV2hlbiBjYWxs
ZWQgaW4gdGhlIGZvcm1lciwgYm90aCBpbnZhbGlkIGRpcmVjdCBhbmQgaW52YWxpZCBtaXJyb3Ig
cm9vdHMgYXJlDQo+IMKgIHJlcXVpcmVkIHRvIHphcDsNCj4gLSB3aGVuIGNhbGxlZCBpbiB0aGUg
bGF0dGVyLCBvbmx5IGludmFsaWQgZGlyZWN0IHJvb3RzIGFyZSByZXF1aXJlZCB0byB6YXAuDQoN
Ckl0IG1pZ2h0IGhlbHAgdG8gcHV0IHRvZ2V0aGVyIGEgZnVsbCBmaXh1cCBhdCB0aGlzIHBvaW50
LiBXZSBoYXZlIGEgY291cGxlIGRpZmZzDQppbiB0aGlzIHRocmVhZCwgYW5kIEknbSBub3QgMTAw
JSB3aGljaCBiYXNlIHBhdGNoIHdlIGFyZSB0YWxraW5nIGFib3V0IGF0IHRoaXMNCnBvaW50Lg0K

