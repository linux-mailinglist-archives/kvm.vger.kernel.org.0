Return-Path: <kvm+bounces-72581-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CICkFPw0p2k9fwAAu9opvQ
	(envelope-from <kvm+bounces-72581-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:22:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EC90C1F5ED2
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 20:22:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B00BE307E432
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 19:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0031239658F;
	Tue,  3 Mar 2026 19:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LJ4J+TCL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915C6396577;
	Tue,  3 Mar 2026 19:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772565724; cv=fail; b=QKdZtw5z6PgXSgkSmfO17e+E82WkcGgn+qcQcNpdioNs5sfKSuP+DjoOpd2jFUUYl/RBNxcO0V+K88XTOeI9vbi9WsTr0Bzd4aX9EQpWIhamlcPAsASwsXZM2XM/G8AUqSdgASO4SWe0iO73LtpD5CVO3Q/c0s8kFl3i32L0pB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772565724; c=relaxed/simple;
	bh=qpbYB+6rV04KUYyWToIYXHOm4Sm4r4YXinVw6fopvEA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OIjBrQsNTGwh8frBdvF3AP0kXDNTa0iwF7xg30fodHl/59pEPcMLmvr4aL94DvKuWExvatkujYmuXJcIpBIOXETnzRKfdoRM0Rb8aVbru0MR7QLou8daTVaN9Awt7pgjRoUJlHrSmTs8+uim9jLKdmCtpbUEej3/wG3lLWaqa8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LJ4J+TCL; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772565723; x=1804101723;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qpbYB+6rV04KUYyWToIYXHOm4Sm4r4YXinVw6fopvEA=;
  b=LJ4J+TCLg9XoROm58DeUpK7TtlVzhr9eKEo0HODhIUBL8gHucBoA0UAL
   hZne9R/EcSR/GQPYjkyJLMkNw9VT445CS+m90LxB1ckcZj0FDFakcoT76
   98XVBgdzZ5x5j6HCDO8WctIpoy242gAir8xrbBglheKRG5M9kb5NOo37e
   u8zu3wf7Xac/ongcCSQm81NRLBrC+YaWij2VUhm6bD/x3KRbUdnoSi2P0
   8m0y6mfI5UtcXgcvxndcoNYqqJgIzN/Zck3n8rTCUZ/7h+cv23HbTNsVW
   NjG/3Bb/eCWhNGtmVey2GX3+obOGfFuIXX2klx/eFP9DMAp5QurTs8zGn
   w==;
X-CSE-ConnectionGUID: n4qHyi+pQY+XlygQlqnPrw==
X-CSE-MsgGUID: sYlnECCzRJ2eOQhKxUzeKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="85085112"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="85085112"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 11:22:02 -0800
X-CSE-ConnectionGUID: 3kRS+s9eQaeoEGG9OYx8dQ==
X-CSE-MsgGUID: Tvon5tapTFaA6I0yzAu7/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="241104845"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 11:22:02 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 11:22:01 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 11:22:01 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.18) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 11:22:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uHRNnVtB3o/sRh7FVLU4dB6DJChLuWVyhZ1RwMOZiYmzPa7UejYxCUcVKSiuQ8SILluqYGdb9xu1CMb1yCK/oMtpYCX8J6Opc7emfKkNXSMNXzFve3hAv1RdeKDVJ8Pb9abX5VBsxMNZY8QO9fvbgTZGTDHvEE1DOJjNu9keP3hwNsMPb5JHAOEu3sEFv6PEjiy7Sdruyz/IKLsgjZBVxoRViGFLvNpMxbl44KCE1lkv7uHnlGCwq+iwzXhd2qyCS5+JwcsygcC3t/Yz/ZnmryRQ5VKIGY3MoNDbBaNrhuPkHt5JIwhzO0g7lna4zEowMGSY/glLqv5CEDWeu1OXsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpbYB+6rV04KUYyWToIYXHOm4Sm4r4YXinVw6fopvEA=;
 b=gpsQyDoFJUW5NtB29ylEHr8vCrQoLFrL8saYR9e/PUDmlHZizAjPuLWsAdHnKwz1/Ze6t8Sg5RljEgaLtPQKzWV90DBUTfC8+Mk7aLJDMv3MDa0z3fb8of8mySX/VqfIGD0oQGZG8XJ69cdhMt6AhHGSxwa9+SRxDm459vka3vLvnfOByQ8BwzqfEHE//hVGMHrNFkuFYL1uRWNJR80NvOBPcbzK3M4xVRxTzfLjnnv2G6+POjs8V6pNG9uexglBHXSqF38GLK7l0uWBU92hANciuGExZHn9/Fee16gWIWRtGqHTmDyfdGqlmmLWWSm0LFxRYNdxP6yh9X1Ndv7pBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5115.namprd11.prod.outlook.com (2603:10b6:806:118::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 19:21:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Tue, 3 Mar 2026
 19:21:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "zhangjiaji1@huawei.com"
	<zhangjiaji1@huawei.com>, "kas@kernel.org" <kas@kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
Thread-Topic: [PATCH 14/14] KVM: x86: Add helpers to prepare kvm_run for
 userspace MMIO exit
Thread-Index: AQHcpfUVg+RNJOrOv0Cmb5EAu8jOw7WTrZgAgAAexoCACFFegIABHFsA
Date: Tue, 3 Mar 2026 19:21:58 +0000
Message-ID: <4574be9a29d75d565e553579ef6ce915ef33b19b.camel@intel.com>
References: <20260225012049.920665-1-seanjc@google.com>
	 <20260225012049.920665-15-seanjc@google.com>
	 <8bed2406e9f5f30f8f01c1da731fae6e040da827.camel@intel.com>
	 <aZ9MDxJ1iEhIbJJ6@google.com> <aaZGTY3CzhaCb1lc@google.com>
In-Reply-To: <aaZGTY3CzhaCb1lc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5115:EE_
x-ms-office365-filtering-correlation-id: aad07515-a13c-42f8-3c71-08de795a23da
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: AeG/kACKJ5Q7xckJdu6g8bYplzNtTlXh1nnhKwY76v2dZc+Opp2U6yGR692tvtAsRXCATIbQPdvnSDEnA70u3EQDROlA9rGJ/u0wFpIEmYjAw4N81gLJCWGBbX0q4DDUmZIQ6SrlYS2h8KnVfT2Bcd0cKqvSOeswocruRy5P/W/z4WbKchjGa0CEJsQZTddc8z+51jD0z+Jy5Flxora+3+pw5ZeQFVxioEk9Tn/ySZ4P1TmlWUcs5VutQj9Tnipg5+FETRCXGk+Cf1Jn6bucUO9FSCT88XH6UfWX6+IVQjFwminJunev5OESgMSL2ysK5/Mgl0nVrAMO8yq1qR4g/tbACcfTleYrGwTS87Vn7q/mRSiQ9J+5iz542DgiXhuJgIAYmPVyWcBGk3rSwmPyhyNnTLa7w9tECNYEk4Lpv0eFdhpcPuB5LDfFF86SzGvhdOYl4YwKokbrsDHzp9w9HVed0Wr0NK1HXiEx+K2RH92cnWtORlbojVbxS1aJCfaUonF6JsXrRLV6t6UKwXhJXbKVkfvd1ULdIb/P9HiVG5Qd7+CqSCvLOlsbEwr1zayN6Ey6DyxCbqtY5TCnXYzYiI7QjvjpKjGxfmASQI4P9AS+850Ciom7DDIw0kzJQ9BsKJ3lJ5KodXkO6O315fMboNZCpOSVMdbh9CnkFxDQB9d8kusux+UgYLZeqKd7rEA/m+DknET22+/ucxuUQ2RX0z2NqyM5BfDcdwd8goI/p2Dlst8FQkgRBUaDC5t3xoMBA5D/rLLtE/JRk0ZDL6q5ARf67jiEvqw1lcXOV5a5+1M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cjlUaWVyRGIrVUpTT1oxeFgvZEhWMTc4RDVVNVFxejVEdXlkcHdDUTZwcEhP?=
 =?utf-8?B?aDFmcmlHbVU1TTNiWWpLRVg3eFpaVEliM2VJaDZaeGg3OE9pd0lEV1Voa2R1?=
 =?utf-8?B?SDY4TFhpOTZRdlJWWXRIN1BjcmQxODF4UFYyVXhZRkZwUzlDbnluRjZjSFRk?=
 =?utf-8?B?N1I0ZTh4TE5SNzRwT0YrSTNoV3NnZVViMUdNUGdJenloTEVCRngvWkhvcXI2?=
 =?utf-8?B?YXJFZ1BGU0VvNWRDeTIza3YxRW1yK2R5aXZ2eEhIa1M5Vlo5L2R0OEQwNTZQ?=
 =?utf-8?B?RUhoVzc2UXI2NFhXNnhNcDVTS3o2WENzcWxHYWQyZGYyUllaYkdWYlNWdTcw?=
 =?utf-8?B?aHVwdCttZ3BONkloMDUyZGVUaW9xNGowY29EZmdqMHdiQlN2UVMrN3AvR2E2?=
 =?utf-8?B?VXBtYTZzTkhyZVhlUThCbG9hQWlUZ0laWFZ1Sm5UMmZUM01NNyswQzBNQnRU?=
 =?utf-8?B?bUdPenNTcVJOSEhoYjRPYU80Ly9scnduWXl2V1F2SDZZUmZQWTFoNGN5TkJY?=
 =?utf-8?B?Y09ud01JKzd5UEk1MWNNQWg5MHZLUitPMUN0TXBYWXl0NUd3cjVwYzJxUGZm?=
 =?utf-8?B?ZTVlOUxSdHZUZ3ROTnZjekRmZzYxd2lSV2w1WCt5dEEwYUxnYThyYlNrVDZJ?=
 =?utf-8?B?N0psTFZPQVFZN2dLVXdHcjE4Qkl3K3Fab3VSWFdMRTRqWnRxME5VeTR2eDBE?=
 =?utf-8?B?TFRqcHZOOEswbzhCZTllU1hDMUNycS9wcXJBZlQzc1Jqa0VsOHVvb0ZMQWNq?=
 =?utf-8?B?d203bWJhZTFKZTNWVGdmZkovcm96MDdObjYrd1dsQjRhbUxRT0lKWENNUGRG?=
 =?utf-8?B?TkI1MjNYN3hzMmNpSDVvelVHNHpYNXNGWUQ0Q25wbXdyWWRidUV0Q3pxTmNz?=
 =?utf-8?B?SnRLcGNGVkJTMEsrdzZRZ2RSdkFxbXAvWHJZTzVWMW5USUUxNDA3bU9lYlg2?=
 =?utf-8?B?M2JNcWFBOHltSHFPN0NOZFBLSjMydkNHcnpPb2VueHNEaGhpZmZJSE55RkZ3?=
 =?utf-8?B?TUovckgzUDZrbTVvbTVEYkpIbXdZVkpOL2hYRnU3NU1ZdnNjNFhhdkV2bkM5?=
 =?utf-8?B?S0ZvNU1wZ0JRaUJOUFdkMXhKak5qVTZOT1pSY1NzYnFITGVZdDNGUmVtZVQv?=
 =?utf-8?B?VG1WNjB3dlpEQTdnNGdqNTdXTXZKeGQ3QmpPeVlxbURwMXNPejlkTll4VnF4?=
 =?utf-8?B?OUNSSktEYXp6MTJaQjIybDhkSWRVSlRCRHNOaXNSckxHZm9nUTZjVmNaa3F6?=
 =?utf-8?B?NUJnRUl2eFZna3NVRGE3SXVhTzdNRVNSdk1RV25xalpMNFNOc2Fla2RZUW9z?=
 =?utf-8?B?WWpKeDdRUGgwSkRXUG5mSXhFVzFnK2h6OC9mTFpQS01CWW1lby9XQUJYNUVM?=
 =?utf-8?B?LzUvZmk5RHhtYm9UMWN4alU1bDNLYnQvUVhERlk2ZGduSDU5aFlIRHpyTzMz?=
 =?utf-8?B?NFNEMWgxQmFpand2UkdrU0lWOWJMWjRKZlUzVEhBZG5ucVBQcm5hcnhZeUNS?=
 =?utf-8?B?cW02WitaSGQ2SklDYzBwdnExQ1k2NWRnb1lndGUvTnNYUDRwQkdsRkxhVDBi?=
 =?utf-8?B?UmpST3JzSnk5M24yMVpOWEVIaDN5WkVGN2NaZWtjbmVvM3NHOHVMc0dEUHpP?=
 =?utf-8?B?Q3ZNVFFsTTdCWStmaDlpS016a1BmZFRWTWc3ZHdoY3g2aGZHV29RU0c5Rits?=
 =?utf-8?B?Ti9Cc2dtRkk2RFZiMXFPaFlBNkd4dnEvaXpUYXNCMEhTUTlVVXovQlVmZnR0?=
 =?utf-8?B?SmZ3R3ZyQ2wxb1NjNHc5NUw4REV4MGc1dExNQzloK05XZ3Vrb0wrLzNKYmNu?=
 =?utf-8?B?d3VoVm9yNmhDWHhydGxWSjhpeS9oamJ2N3JUT0JLQWp1dUhpOTBFbTVJWnZF?=
 =?utf-8?B?Tm9qNGhMcFlCK3o4VEhaQ2thOUZNSE9kUzBCUmIraVRBcjZVWmtmQkpleEJx?=
 =?utf-8?B?WEo1SzhuL09QeUt0LzN6SzA2bzJuYW92ZCt3OXdEM3hzRXRmeFZuYWFITHlx?=
 =?utf-8?B?VmVFc0FOb0NzOE5LV25EdXBkaS9kR09rL1VKZ1NNcTVoWjVQdTUyRjhnUmpk?=
 =?utf-8?B?ZDlDVDlvck05YWczSjhoY0VOVVAyYlgrTW9ZOUUvK04xZFdGSFVldXJkc3lL?=
 =?utf-8?B?MjlZODA5SE03NGttcTRqMEVkMlNFaWdVaWFQOE4wa1MyZkZpM2tUL3BPcDBO?=
 =?utf-8?B?T1c5OWk2ZjJlaUpmZlRZWjJBOGNtVmJhdGJGckJHY2tSMkhTdjRiamxpZDR3?=
 =?utf-8?B?TmZXbkhyRkFNQ1k3K05pSTBLb3I0NFdNRHNtVGpQWFhYem1SOHp1SjF3eHpB?=
 =?utf-8?B?MVVqYUZzZmwwcWpHR3dhUTBpLzZURkZ0ZUJWVloza0ltMkRSc01ISlEvdW1C?=
 =?utf-8?Q?8EaaIFs6EuuzDnsE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D8B3A9F845E9304AB27D084812FF61C5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad07515-a13c-42f8-3c71-08de795a23da
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2026 19:21:58.8670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hrYWsbpFLa09qSCl9ylUkY9EMEhViSuk5KHlel6oJOgJCeSCiTjAu4/IyJivB8xInDCWyxb6e2p/+bZabJWWz+HGIaisq2eAyxWp5l+rxT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5115
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: EC90C1F5ED2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72581-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAzLTAyIGF0IDE4OjI0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPb2gsIGJldHRlciBpZGVhLsKgIFNpbmNlIFREWCBpcyB0aGUgb25seSBkaXJlY3Qg
dXNlciBvZg0KPiBfX2t2bV9wcmVwYXJlX2VtdWxhdGVkX21taW9fZXhpdCgpIGFuZCBpdCBvbmx5
IHN1cHBvcnRzIGxlbnRocyBvZiAxLCAyLCA0LCBhbmQgOCwNCj4ga3ZtX3ByZXBhcmVfZW11bGF0
ZWRfbW1pb19leGl0KCkgaXMgdGhlIG9ubHkgcGF0aCB0aGF0IGFjdHVhbGx5IG5lZWRzIHRvIGNh
cCB0aGUNCj4gbGVuZ3RoLsKgIFRoZW4gdGhlIGlubmVyIGhlbHBlciBjYW4gYXNzZXJ0IGEgdmFs
aWQgbGVuZ3RoLsKgIERvZXNuJ3QgY2hhbmdlIGFueXRoaW5nDQo+IGluIHByYWN0aWNlLCBidXQg
SSBsaWtlIHRoZSBpZGVhIG9mIG1ha2luZyB0aGUgY2FsbGVyIGJlIGF3YXJlIG9mIHRoZSBsaW1p
dGF0aW9uDQo+IChldmVuIGlmIHRoYXQgY2FsbGVyIGlzIGl0c2VsZiBhIGhlbHBlcikuDQoNClNl
ZW1zIG9rIGFuZCBhbiBpbXByb3ZlbWVudCBvdmVyIHRoZSBwYXRjaC4gQnV0IGxvb2tpbmcgYXQg
dGhlIG90aGVyIGNhbGxlcnMsDQp0aGVyZSBpcyBxdWl0ZSBhIGJpdCBvZiBtaW4oOHUsIGxlbikg
bG9naWMgc3ByZWFkIGFyb3VuZC4gTWlnaHQgYmUgd29ydGggYSB3aWRlcg0KY2xlYW51cCBzb21l
ZGF5Lg0K

