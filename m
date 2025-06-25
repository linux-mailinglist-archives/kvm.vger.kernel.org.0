Return-Path: <kvm+bounces-50772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ABF6DAE92A3
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 01:31:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 306EF165756
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 23:31:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E66272F1FFE;
	Wed, 25 Jun 2025 23:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TvlJhfcH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A9F2F1FF9;
	Wed, 25 Jun 2025 23:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750893602; cv=fail; b=gvz/YWVw6+ssjZDKlU8rDhKrYP8lX8V76od5O7agCNQEsr8thEULGiuyLAFzUgKeH0iv/MM0sNmqJDQmAC70XiDAwNNUpgVNwwLUtnDzjk7VVdb6kj8Qu+xCfDsua+opr5BbUzgVS4aVvPr6OHqaf0fvpbHBORD2i7S6lRoxSZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750893602; c=relaxed/simple;
	bh=/BOBOrBMQwzEKIhghzCk3x0KPw1K+W+zZPLX0/T52wk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WA6kfZ66/r+AMCzMJDaZ4WYfB8uYfpiDpyOnVunJvBeVBZdCcjl7Soz0E31Wor4DWgcwv7saimFPqs4tKuDKEJS7IloSqr33hImsYDrbNK6L3q8moxjHIS7pdt9/bi2V+jwcCHXvzfRc2CmiIQ8zGJePXW5mCXNJhOygfgomWSQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TvlJhfcH; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750893600; x=1782429600;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/BOBOrBMQwzEKIhghzCk3x0KPw1K+W+zZPLX0/T52wk=;
  b=TvlJhfcHXqjWBD7ie80ZP5/HR2TOM9u26hiq2cjcQN7ETwmuI3/hF35c
   gQ2goIlMQqIjTVQ8FW7bSl3lf0cxRkr0dZTYpbJCcWYGkLuQpfXxSeaNE
   TcByqTRLvlWdTBGxqM15o+6xpoXAM8L9XMPlzTqc/KU9bptMihj1uQOxp
   pSQc/Rhcc9H4P2oPfJP4Gx+1ilXcOxMMoX65dFFWoPmWOP7U6rI6OTyIa
   i6aqsyAkodSQm4vcUPVAOi2FOxo6CO+/PwyN3C3Gsv+ckSxhKatwKGoVE
   ij/iv204sDuwAOrm0yb+TzAPaASudhwER3/Ib0xTjraeIkiro6wkH8jwT
   w==;
X-CSE-ConnectionGUID: AeJPOzPkSzirSUXpXC0V+w==
X-CSE-MsgGUID: hYYl6l7mSJqlrOB8sBmgIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53247736"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="53247736"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 16:19:57 -0700
X-CSE-ConnectionGUID: 59gSjh0XSrasWs0rQhwY+A==
X-CSE-MsgGUID: UkQqmMMXRt2TNJDp+l4MjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="152844630"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 16:19:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 16:19:53 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 16:19:53 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.58)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 16:19:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TECWKCmFM42wHtMDAD1Z/1MzjlcuP28AgmQ1H4du8Zcg0wFb0sdj8y69K8SQN01mTgJsCHXNI/DiSHsSgV/RARYYdJd3KIemF9nUDck2w3RogsOZ7nC3GI7lAEF8+/OhsiveoqjkXhvdmRGltiSDvbaLYaBrt916Rvl9lKPLsu/VM0KpHoXUQe98nQT2rXJVFTJqCkAxuH2q45NOA8NKiFOqL13pHIYHt+oyhUd5isMyltHy6aocNDrcb/ydhDvEQGINPT7/ond3ZHGdPKehuzZlz7Jb31dkSoN/uqQEtDxqDd6dNUSkiJyf5ihPpgkfLC5VkuufcnjLXR3T/ZVsOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/BOBOrBMQwzEKIhghzCk3x0KPw1K+W+zZPLX0/T52wk=;
 b=J+LTBuM7N5Z6B090OM9/9WsLFpxLP9O5cYSM2t4FvKBpZfEFRDRq+1iHlthH8BJPgShpcZewVrI1HQpa63U1LKL2mM+MWdWzimHkIU8iq1qC7PG0RTBMATkBle8BZL+zaggPuDavNCf/W5UrLElPXEratAXdMeDZhLt/T1WAPjQbxa/1qv0L2GDKcvZDNBxVI334pcf77YOxlMip1xN3hqTf3czJ7IiI9P9WI56/+BXxyeGfsxvr7AA4NIglEeMuvhkLD23sgr7S41tgf4ZQubymxUliDApowIyzP22+ZqCdsz98jB3B0gqv+lgTO3nNUwN0c6tlnzSr7qrUZOy0Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.26; Wed, 25 Jun 2025 23:19:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 23:19:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "ackerleytng@google.com" <ackerleytng@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Topic: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Thread-Index: AQHb1Yuw8TDhKPA9uUiYAoJtWQa0+LPz2/CAgAozpACAB4/5gIAA7nmAgAAX8oCAAO6tAIAAjZiAgAAGKoCACG6bAIAA3+42gAGE44CAABkngIAACJUAgAGDrACAAALngA==
Date: Wed, 25 Jun 2025 23:19:36 +0000
Message-ID: <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
	 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
	 <aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com>
	 <CAGtprH_Vj=KS0BmiX=P6nUTdYeAZhNEyjrRFXVK0sG=k4gbBMg@mail.gmail.com>
	 <aE/q9VKkmaCcuwpU@yzhao56-desk.sh.intel.com>
	 <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
	 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
	 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
	 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
	 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
	 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
	 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
	 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
	 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
	 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
	 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
	 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
In-Reply-To: <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB5966:EE_
x-ms-office365-filtering-correlation-id: 69b0f4e6-3548-405c-07be-08ddb43ec058
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MUlqWG95ektrTFRqeHllSnlseEI5TWxQYms2V1FscE9ITXFSaUgzRnFwSGgz?=
 =?utf-8?B?WXRvOXhNZ0FRdnNIcGJxQ0x5M09kalJ3ZWxqVVpqdGpiNzJOdExLbUxtTER5?=
 =?utf-8?B?N2JLWFFZMVNpT2QwVitBaC92a2l4aE1JbmczN0VHZWJzUm9MblBBSmJNVUJI?=
 =?utf-8?B?T0l0SzFSaWx5YWgxSVZ1OGtjMTZoYUtFV0FLQWxIV0FaZWhMSXpOWmMzaC9a?=
 =?utf-8?B?dXkrSzlDdFZteGE0M01Za2YyOUtJcmxPaUt5YWRJeWgvc0Z3RXV3UzdyQ2Rj?=
 =?utf-8?B?ZTFhV3c1SDc4M1FPcElEUkZtV1RyR0d6cEdsQnhSWW1CTGU4VFI5SEhNY1FZ?=
 =?utf-8?B?aGlzS3NXZU54aVhTaHA2cEVnU2ZSSDNCVUxUQm4wdmhaWnloNDk5MVpTTElE?=
 =?utf-8?B?M1ZSWHo1Q1pQUDF5Sm5NR3NHU3A4c0s1N3hZd1lEZ3RjZ2M0QkdhMzIyMTAz?=
 =?utf-8?B?V0dTeGxCbTU2Vzd4NkpoM01CR29tS29sUWlNK0V3ejBGRzZyV0IvM0tMVWpq?=
 =?utf-8?B?STFpNVNRU0FtMW9nSXF5a2kxZkRuTUpUUnA1bTJGSE9Id0xNazZ4Ulc5VnlL?=
 =?utf-8?B?S1Y1ZS94MDE3ZkVsSjZ1NFlSTVduR3QxY3NOSlBTU2UwTldBbDVzNzZHUkRT?=
 =?utf-8?B?dTZJTTlsQkdDV2YvNGx4bW1LR1NVaFBXMW5ZWjAxckRRTkZkY2ZUSzcvRUk2?=
 =?utf-8?B?eDdHZXkxY2h6UzNTdDQwaDZYWVNHc2JEeGxWd3ZNVHlKeGlzMDl4SjNiejJO?=
 =?utf-8?B?aktXY0xoYXk2c3ZDY2pWVDlnYTc1OElTV2kwNVdTbytJMFlKZHFhUDNsV1hS?=
 =?utf-8?B?M2txNW5RaVVGWjhEWXJSa2Fja0xoc3BreFQ5SjNEWG1iOUJpaVFRZmE0aFRz?=
 =?utf-8?B?YXlKc3pSMDZucW1aVWlwQWhsaHRaNjQrZ2wxUGdJSDRsTTlYRmlqNXU1U0Vr?=
 =?utf-8?B?TTRFMVJnQ2lBejVVS3FUU2dnV1RIaElJZ3VwWTMraFdZWjlMUDViaGVlL3lx?=
 =?utf-8?B?anYxR2dLOXhZK2tObHlPSHBxTDY1b2RrL2pidE9nakp5ZGtzOWlybUM2UCt5?=
 =?utf-8?B?eWJVeUF0cnBlczI1anl1MGNBUjlrY0JpSTRFZGlNT284VFJScDh1NWRqNE5a?=
 =?utf-8?B?OVljSy9TdmVGaDI4MHIvdUJJd1hCRC9DRzVRWEt5RXhsM00rN0ZXOEFvbjBK?=
 =?utf-8?B?UkFJTHI2VEEyTi8ySEo4YW9Gbis3dnYxQUFUazBqZ1Vya3BTcDdSYU9sZzVm?=
 =?utf-8?B?OWh2d3hINVVPWHBCMFBWci8xUk5CTDFCVWgySUFveXpLMlR5dTBQWFVhdzMr?=
 =?utf-8?B?N0lmZ3RNSkFwc1ZaNThzdHNpQWNkcEdVb1V1SVIzVTFoTTB5TXp4ZWxxdjd4?=
 =?utf-8?B?VmR1eEsvWDFWbTdvNlhERDFYN2JDNE5iZ3RFVjJoaWo1YjQxKytDMlRYTE5D?=
 =?utf-8?B?cnJsWWdvb083SnlOaFVucTU5K1lmTWRMOFVNUVUwU09kWHllVUs2eFMzMktl?=
 =?utf-8?B?RE5Ec2NlaU9jWm5tK09SK0hLdHJDaG5iWmtBWGxiODVvbG5MY1p2ZmNhRzVB?=
 =?utf-8?B?RU9CaTRpZE1oeWpOYklQcVZmUE01YlJNWmxTanp4MFlkbGRWdjU1R3FQSnJ3?=
 =?utf-8?B?RUovTUZIZnY2V0p1N1lpYTczOXJmYVJvMC9XN1ErbURlbHhvalFYUThpMEVu?=
 =?utf-8?B?RURnRTBUNStHRktxOFNwcitLM0NRMWQ4YW9qY3BQUEo5bDFtSjMwVzRRMEtT?=
 =?utf-8?B?S3Y2WnpiMElqUjNhMk92UDRRdFY2VHJJa1ZncUVJK3hEMnFsMzdBV3BHc0hZ?=
 =?utf-8?B?VXdpdGtqbUZlbmN4V09iaEdKSm9mb0xIR1N3NGh5Z01EUEhEellIR2dsdHhq?=
 =?utf-8?B?ZHUrUEtjMTNmMUthNE13YzZKeUkwcm1nMXA0bXR0ZlRSTzNROFFEeEFCamMx?=
 =?utf-8?B?ZTdjMzI5Sm9FY1E3S3N3TWFEcndZdU1mVmpmQTVRa2NhcStnRHhoUTQxR1A0?=
 =?utf-8?B?ZWtTcGNJeGlBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SFhYZk8vMUtoMVQzc2FEVGowS0RlaXY0QTRUQnVzeWpzbHpsM0tXOVVBVGRB?=
 =?utf-8?B?S2tKK1dkSDhqOHdXMUoyN0JMUGxkRkdFT2QrTERxS09mVmFUaU9yUjRvYjN4?=
 =?utf-8?B?VUdMbTJ3YkpLNFZGaE5OMzJIY0oxd0pyYzB1Rzg5c3FQZDNMcDBQZU9xYW90?=
 =?utf-8?B?eXllZW9EU3gzOWtyZ2c0ay9ubDZxODhWZWxxSGIxQUZPWjhZUjZJUWhPaUov?=
 =?utf-8?B?SXFmNlpFcEtseU1VaUMzT0ZMWVY2ZnpRaTBvRnAwd0Zrd0t5MHJITkNUakxw?=
 =?utf-8?B?UVhlV0QyOVlaRkllU1phUHNCZ1RRalIwOFlWNE9ZckE2ZzVSNUhsKy82T0I4?=
 =?utf-8?B?cDlONkhmT3lnelAyTFdRdW5BVUxESlIxa0RGcDFwbEs2cmlReVNNZTZHWWtr?=
 =?utf-8?B?eXM0eVplRGlQYzJ6UXQvK3pWNXp3UmQwY0tXMUhUd2VFVXo1NG9aaXVNQ1c1?=
 =?utf-8?B?eUJod3VWZVNXS1hBWU1qL0lFOTg4QUdDS3c0ZWxYUGpuMlNlenAyOHIvck1H?=
 =?utf-8?B?TkcwZVJYejdnbXZQZXFWclBObFR2K1g1RUJTTEs0cHl0Ym5TNmRuUzBPaFQ1?=
 =?utf-8?B?Q1RFc29TSUdoVE9Oa3E5ODhrU2dvc2tIQ3EzQlcyOEFNRFoxbDc0Y0lyRzN0?=
 =?utf-8?B?NDdsWmRtWmRXalFIL2FQRHVicjBXQmthRkdROThuWVdTSUF5VUpyN2tDTkJS?=
 =?utf-8?B?ejZlUGtBZm9ydmNIOXp6WWpjWGFaZEVuZFNUK0ZxSjhod3FsVWV1OW9mRzg5?=
 =?utf-8?B?anB2OElqZDZ5L3lCT2hOTFVDYmo4a3ZtSkdNWEdON0w5RWliUGFsbUhMUlNp?=
 =?utf-8?B?RVFVVzBxdVVSSHdFcjZWN3ppcmVCU2p6QWs4ckNWT25DRit5VUxMeFFSRUdi?=
 =?utf-8?B?MnBtVmF5b2pCNTNSd0xvT3hUNU5lTWloZFpCeURtTmZLREFSQ3h6UkZBaE1a?=
 =?utf-8?B?T0FHZUdoWUJvSE8zVUplTGp3bGJpeUkwZ0VhMjhFSUpvYlMwZUpmSzhhdVVr?=
 =?utf-8?B?a0l1VzdCVFFKczh5TTdpSDZ1R0ZTSnFpL0VxM1Y0aEo4Q2pQQ0FzWlAzVXp2?=
 =?utf-8?B?YjBYMWc5K3ZMNUxzL0pUNHZWSmZXUktSdEJ1cHJHVkloS1NMcXZSeGppMVJV?=
 =?utf-8?B?SDE5dEwwMkZRR1NtU3p4QWNnWTY4V3ZiZHdrWCtwdW5xTDVlcUpENjduV3du?=
 =?utf-8?B?bFcyTGRlb2NQSWtsVU9LOFRocE9DVmk5dk5pNit4VG43Z0FOTmhVUkxwTW1z?=
 =?utf-8?B?bHZyRkxMYmRZejlWSzZHQm55NHNuSWRoTlJnYWJNQVFXNTBBMnRGZDk5dVRn?=
 =?utf-8?B?WTEwZ05lYUEzSnZXbC9EczRYNEFXZnliUjZIZllaWmlHNlpRWDFiT3R2NWVZ?=
 =?utf-8?B?UWlzaUZlSjBZV3NlbysvM1Y5WTFiZWlQczJ6RC9NVzZzdktGKyt0d1ZWT2hv?=
 =?utf-8?B?L21qdHdhUHAwVVpEcTJlYkxHYVBtK2p3T3lHVlUwOXJaTEtTSjhKVEVSc09u?=
 =?utf-8?B?VGQ0NFZYM1A5R3JBTXNTRnBXVXQ4bW5FRUs1L0E1bHpBakV1OW91QkxpQmJi?=
 =?utf-8?B?enZIZmowR0dpN3hIUC9ZY2pOTElTZE5UOGJqRXBkNHUwbGlEQllqZmZmN3g4?=
 =?utf-8?B?dmt4L0tvajVLWXdpUEp3WFhVZVpPZy9Yc2poZ2Fad1VwTVFNQWdpbVkybGJo?=
 =?utf-8?B?US9rRlF6MnozTWVBQmsxOWVteHBtWC9sT0U5aU55WVc5a0x2M2FySktNUXRj?=
 =?utf-8?B?QlYyWUl3bTVxWWs4bXlnbDU0aWg1M3NuWFYvcjVlSmFHdmZuaXNIRE9sNy9T?=
 =?utf-8?B?SmE3UTVMVndERFFFT2d2dFI4Zkc3N09vMzVlUjY5L0RkQlJQajFWTXhxanJ6?=
 =?utf-8?B?WnNCSzBjU2g3aE5hL2xRSHZhK0hKQ1NkMDYxU0FNV2VyU2dZRThBZkdXb1dV?=
 =?utf-8?B?dnhZbnZjTi9GZ0VXSEVaZU1UcGc2czJCeUFCL0tqTnp0cnNFQldqcWVzdmNZ?=
 =?utf-8?B?RXBPSDNUMnYzaFc4eTdFSkRFamI4OEZwcWxJVnhYQWFtK2hNUzhwaGdtQ3hi?=
 =?utf-8?B?MXB0dEo0eURyM2ZsNjFGdmhGTUk1cldyVEFMeTNjbmx3Nm1zRHJRRHljNmRv?=
 =?utf-8?B?aTJYWUJzYkZuc0Y4RXBvUHVQTS9mREVJWFMwRDREZFFoTkpEVzJCQlUwYlZp?=
 =?utf-8?B?Smc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC10904447A3BF448A67488189AC3C90@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69b0f4e6-3548-405c-07be-08ddb43ec058
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 23:19:36.3763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9OmLYB/pGK2X/jRY16Z4dGfo5NwEWIAqFe6AnOoSFuTp40c17r0X8XJFw3gpg4BS0IE+8SVLuJcEr/sGmuMp0yYpugCnWhC4AGTrVC6+1DM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5966
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDE2OjA5IC0wNzAwLCBBY2tlcmxleSBUbmcgd3JvdGU6DQo+
ID4gSSBkbyB0aGluayB0aGF0IHRoZXNlIHRocmVhZHMgaGF2ZSBnb25lIG9uIGZhciB0b28gbG9u
Zy4gSXQncyBwcm9iYWJseSBhYm91dA0KPiA+IHRpbWUgdG8gbW92ZSBmb3J3YXJkIHdpdGggc29t
ZXRoaW5nIGV2ZW4gaWYgaXQncyBqdXN0IHRvIGhhdmUgc29tZXRoaW5nIHRvDQo+ID4gZGlzY3Vz
cyB0aGF0IGRvZXNuJ3QgcmVxdWlyZSBmb290bm90aW5nIHNvIG1hbnkgbG9yZSBsaW5rcy4gU28g
aG93IGFib3V0IHdlDQo+ID4gbW92ZQ0KPiA+IGZvcndhcmQgd2l0aCBvcHRpb24gZSBhcyBhIG5l
eHQgc3RlcC4gRG9lcyB0aGF0IHNvdW5kIGdvb2QgWWFuPw0KPiA+IA0KPiANCj4gUGxlYXNlIHNl
ZSBteSByZXBseSB0byBZYW4sIEknbSBob3BpbmcgeSdhbGwgd2lsbCBhZ3JlZSB0byBzb21ldGhp
bmcNCj4gYmV0d2VlbiBvcHRpb24gZi9nIGluc3RlYWQuDQoNCkknbSBub3Qgc3VyZSBhYm91dCB0
aGUgSFdQb2lzb24gYXBwcm9hY2gsIGJ1dCBJJ20gbm90IHRvdGFsbHkgYWdhaW5zdCBpdC4gTXkN
CmJpYXMgaXMgdGhhdCBhbGwgdGhlIE1NIGNvbmNlcHRzIGFyZSB0aWdodGx5IGludGVybGlua2Vk
LiBJZiBtYXkgZml0IHBlcmZlY3RseSwNCmJ1dCBldmVyeSBuZXcgdXNlIG5lZWRzIHRvIGJlIGNo
ZWNrZWQgZm9yIGhvdyBmaXRzIGluIHdpdGggdGhlIG90aGVyIE1NIHVzZXJzIG9mDQppdC4gRXZl
cnkgdGltZSBJJ3ZlIGRlY2lkZWQgYSBwYWdlIGZsYWcgd2FzIHRoZSBwZXJmZWN0IHNvbHV0aW9u
IHRvIG15IHByb2JsZW0sDQpJIGdvdCBpbmZvcm1lZCBvdGhlcndpc2UuIExldCBtZSB0cnkgdG8g
ZmxhZyBLaXJpbGwgdG8gdGhpcyBkaXNjdXNzaW9uLiBIZSBtaWdodA0KaGF2ZSBzb21lIGluc2ln
aHRzLg0KDQoNCg==

