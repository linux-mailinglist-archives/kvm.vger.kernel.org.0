Return-Path: <kvm+bounces-35767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8D52A14DEB
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 11:46:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B1823A8221
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 10:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7D621FCCFE;
	Fri, 17 Jan 2025 10:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nGHZjZUi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590EE1CEAC8;
	Fri, 17 Jan 2025 10:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737110805; cv=fail; b=a94csd6xptml/MnS0KP989CbcArEttlpYT9dyaLx1U3B5ivRZP9VEFrn2FrzjyQLy5A0nEE3UyvE/RYA39yR5fzQiYjEWX+cjVJ6QdmmCMLsAxYxj4GBqfBl8fJDN4DLRJxDjerIMh1C37C7vayI2YIlZI1s4D5oL9CjtBqF28s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737110805; c=relaxed/simple;
	bh=JaAmanv1aROPOhUk3cpyuDL4APrlG5y2cvjGozKAmxM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iqJBgaYLJNf56OPpscLk9D2FPTvSckwl9SoHF/yZjoggzYNggNpovcikFPraKfcBjodI92VUgQmg+XfNUheFrW6ZaDOt7kv0GuNlf/rjmE+mjS5vUad2rMhT1EWnd2x3h33oZUS9JPv+7nrI+oeoVg+L45gPhwAFm03/KSPzpPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nGHZjZUi; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737110803; x=1768646803;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JaAmanv1aROPOhUk3cpyuDL4APrlG5y2cvjGozKAmxM=;
  b=nGHZjZUiYrP/NU+YMl+aX3EKTGKkDeAINhxtcMhLl1KyLq+Yc/MzAc9X
   KVCaklSVpUFgIKRwei2IcgmFg72aawf6Zi8fF+pXGfi95Hv+mUUZ86Eas
   /4wCPDxTRhCW6JMvYP+K1T0DV3DRatb4WgZCw02nfp9p0pkfQHiwHXEqp
   DkuA0wZg/wrU/I6DXFqSB6VEBGUcPClevHm6DxfKQ9sXaJSvdeP+AmCcu
   mt/W/Aw4NgTB07vsEOfjzMRf9GFNSSNMNwlh4MDJaGpk+c1YkP8BzInx6
   flvVld4Q1tiTD2jozqj/voLmMwXxhPbHbLmlPO+tO+rqP800W37Sz6qa1
   g==;
X-CSE-ConnectionGUID: y5CL9jmcQ5i99X7gEs+Vrw==
X-CSE-MsgGUID: eZEJuZ2rQ++aLvR2FtIriA==
X-IronPort-AV: E=McAfee;i="6700,10204,11317"; a="41470713"
X-IronPort-AV: E=Sophos;i="6.13,211,1732608000"; 
   d="scan'208";a="41470713"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2025 02:46:42 -0800
X-CSE-ConnectionGUID: wSviaAIhTgyAvTQt3cvX4w==
X-CSE-MsgGUID: ADLupVvpSUW976pBZUtpuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="109836277"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2025 02:46:41 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 17 Jan 2025 02:46:41 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 17 Jan 2025 02:46:41 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 17 Jan 2025 02:46:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RfIRPLahgxGyMgrVNPQvn4MrI7AE8hiuCj1R3YP+GtlCDSKWnfRi280d9e+APOW5Wczh/Sp5g6e1sOEmMXuIK0HpAB48sknWAvDOGw3+7ZYpPwcGcC5/SCZnBLNJQi0r6+oexXNZgJonizJTqs+ISafvOPsq+CRET64fJssopXhX+0uCIMyoYvzppNnGeNfKnfo1x55T2AbCjF1IMmZZwjlW5TuX0IgUAjlSzIhu9pHFzmppL6efezLtlcmgI6hJvc3ibmEBLg+8GHyZn3I7XKzoVLjOsxrdaKAp07IHzogDYljArhBSkAgGt3oVkJCpfUqOX4i/0AzOS/qmoirH4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JaAmanv1aROPOhUk3cpyuDL4APrlG5y2cvjGozKAmxM=;
 b=t5lTtBVytI3Jcutv+ebm66bL0N8fnildQjpiWVL39jvTRBzKX3Uzi8q8Ks/EHMugwTYO97uVw6okHjHQq9A5y3C1pGgXIXbKHFQ8Lp8KayEN3yzethaS/nOtMwC7pQGPgONmAKMMi/aa1QQtnOV8eS78EWefUCW8AUrDgIZRnC6gv+V1bTVo0ktsUjD8ErRDg2h0AqnpSs0CaRiwLlxI0LdCJj73150W7AMcy4dBJtG1HfSl5qcPavFglaG5k9rXFNR5UzlgY3k9sZPvWtBiT4Juh1JIJqWEBsGe2JkJhWQsR5KLkaPAREPOrGunX52ZAjV2y/YJgeM6JmTFqjtRTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB5820.namprd11.prod.outlook.com (2603:10b6:510:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.14; Fri, 17 Jan
 2025 10:46:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 10:46:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Thread-Topic: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Thread-Index: AQHbSdaRKaJIAc3W+kqkHDGtm3kSR7MUKuIAgAABzACABVqtAIAAMPKAgABbB4CAACdcgIAAvPMAgAAOxQA=
Date: Fri, 17 Jan 2025 10:46:24 +0000
Message-ID: <85a8bebd3c92292472bd50c6a03d85365c4979b1.camel@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
		 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
		 <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
		 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
		 <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
		 <Z4kcjygm19Qv1dNN@google.com>
		 <19901a08ab931a0200f7c079f36e4b27ed2e1616.camel@intel.com>
		 <Z4mGNUPy53WfVEZU@google.com>
	 <80c971e62dc44932b626fd6d22195ba62ceb6db7.camel@intel.com>
In-Reply-To: <80c971e62dc44932b626fd6d22195ba62ceb6db7.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB5820:EE_
x-ms-office365-filtering-correlation-id: 7638b26f-a7ed-4d80-3c21-08dd36e43008
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RHJaK2owR0loK3RWYnR6L2xYZEhQZUZUQkhJZGpXRUI4VHd4Qk1tczdWTWo1?=
 =?utf-8?B?S2cxZEtXWkR5QXdtNjNFSzNkVlhtTG9sUjQrZWZGQ3pHZHVrWDZCc2pNNFM2?=
 =?utf-8?B?WURNWlF0bUZlQ0NsVFFuOFAyaTBpR3VoZkVPTnNSWUk2QzI5S1k1MFUvQVJk?=
 =?utf-8?B?a3FCaDVJL1JMd1JHcEtLdVhRTHhRU3JRN0hxL0R6aTRUb2lteFkwUFV5ZU0r?=
 =?utf-8?B?WmxJa3R4UVh1WkZpaGt5UEUrNU8xTEZ1WTBDZExIdHd0RE9xVFJocnBMamha?=
 =?utf-8?B?NW5Send3RUlRdGdNZVBtUlg2S1hpL2YzcTgvZmVSc0RCRnVVSCtyeU1uZThs?=
 =?utf-8?B?cmM4RHorVTB5NnpCOUFEam42RnNxWWVML3BrQllwamZnZ0NWUThrSXpBMGJD?=
 =?utf-8?B?bmIvUGR1cHBIcVRjSGduQzA3bC9sY3YvS0llejNONFlITWtCdHFoenc2QkY2?=
 =?utf-8?B?d1QyT2NuUHNnQkt4aFQ3UkRuVWt1TU5rOStIT2tRUXlnZzRtdkYySDd0NzZP?=
 =?utf-8?B?S2ZzRzlhRnV5YTNvc3dVQXJKWCtGMlpmSldaWHJkNGR2SkhmR3BVUVpUamFS?=
 =?utf-8?B?QXliNncrb04zd2FpR0VrR2l5cm5hamhZN1E2MFJ2QmFqVTZKcUlpOE5CMnRm?=
 =?utf-8?B?WFFPT1VOa0RNZ1NRNlZ3UURORTJ4bFpZWm9JZWVRMFptU0o5bDNiNDROM01Z?=
 =?utf-8?B?NUFZZHFuaUxTdUJ3d1BiSjVYZEJrbkpxWnptYXJyQW03azA2b1haNU9TejdQ?=
 =?utf-8?B?Vk1VQlNmV3hjVmdOQW9rK3JKS2JhVG0rN2s4OFNRYkdScnp4L1Y4OGlvcVVj?=
 =?utf-8?B?Y3RHazFJRVNQUHdsMjhjeWxUaHI4d0t4aVYrU3dGWE96NHRuZzR1bFowRFE1?=
 =?utf-8?B?M0Q3NmpwOU50cUNDT3pPOUFMNnFXelVVaWxTd2o0TjI4ZEhMU2Q4OHVkdVBK?=
 =?utf-8?B?WG16YTlVdDBYY0FXaURpa2dnUzF5WVpvZWNjNDFHVU5oTEU5RUFGWCtZbVhI?=
 =?utf-8?B?RWExRWV0KzRJRFU2NmU0c3lWRG1zVEQrQytxcndyRlJsS0dOd3dPUHk3TzNv?=
 =?utf-8?B?RklOWm1oSjZPWnVtN0F6ZUlSblp1WkxNZTJGM0xiREZqQk05K1I0bmUwSTJp?=
 =?utf-8?B?Y0hBZXFFTVZIWklsb0FiOU5TWVM1RHBLNURRUzhaOGt2enVFVkUzbjkybTdx?=
 =?utf-8?B?VUVXZjdJbUVaTVNwUENjZHEzZHB2MGxiL1ZqQVFMYkxnYSt4QTYrT2FYU2Iz?=
 =?utf-8?B?alZGdjFSWTNpZUdLNTU2UzlIZ2xVejc5aVhlOGFhQ3hYS2VuNVNnQXduV1Bx?=
 =?utf-8?B?WEtNUmd3NHZDNUtucVp0TUtldzhwQWZ1bHM3UXlPOURCOS85WUZNc0RTNHJH?=
 =?utf-8?B?eGlTUEYxZjdLd0tySWVkb1I2QVo3TVNxazdOYW5ZUTRJTy9QcFNNRUU5TWcz?=
 =?utf-8?B?TXJnMFExeUxPL1A3WjZSQTdZd0ZIQXhaclRjVWZyWExDV2xITllrUkVjd1hQ?=
 =?utf-8?B?RGwxR1hrWVBMZTZzYXBjU2lLQkVNb1VqZ0NSNjBrUm5QRVRJeDIyWjc5SzZY?=
 =?utf-8?B?c2grLzVDQm5GOW9YSjNSSTZjaU5OQWpDeEF2aDhFWnZjME1OeVoyem40T1B0?=
 =?utf-8?B?S2NXcWlUVU8rekhLRU9ZMXBES052N040dHBWaENtYTlCZ21EWE03TjkwNTBz?=
 =?utf-8?B?WHJtQy83Z0xvWnVnSTRvNTJOTE95dGZMVXpiU09qZkxtcTdnVmZQNE9WVDQ4?=
 =?utf-8?B?eEJnL0tGQUpmWThheFIyUkdxNTd4V1BZUmhoZUhrMGlQdFpXRDNGUHk4REI4?=
 =?utf-8?B?bXphWTJYM0FKeWdJYjAzZ1VCQlQ4OThrekM0Y0pjRzJ5WWtHeU1nemZTcGhK?=
 =?utf-8?B?aVhWQ1VnTzZkNDA5MDNleTg3eURyVlNnWjI0amlnOEZUdFNNUzJCMzB1N2V6?=
 =?utf-8?Q?w077h4QpohQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHZjZGkwVzNCVERQTENZY3BNRUk0TmJsT2t6Z3p4UnJsdVV1L0hMQndBTit6?=
 =?utf-8?B?VjJjaDZWeVV2b01DNTFRcHFPaTBWRHd5QzZBcmFsS0p0ZDJ5RzhQOFhPY1Br?=
 =?utf-8?B?SUNtdVA4MjQ4WGxFTTdlNmlreDdYbkpSRGQwdDg2ZENyNDBSbDhnVGNLSUty?=
 =?utf-8?B?RlYydmU3VU1qY0RHVDYxS2tuSWNSL0o3VnkwWE15MlZsY1FsdmNMUDlITm1u?=
 =?utf-8?B?aVUzaEMydDhmcE9XTjErNkpMdXB0MG9hSTlWd3AyWHdDdEwwTjZ5S29uZE1L?=
 =?utf-8?B?KzY0Rmh6aUJQOURQWFpOWHIwc3M4WWZtN0dNNE1GVDZSYnpCOHNReXU3YnFn?=
 =?utf-8?B?N2Q3TzBybkpLem11S2lJczJWcHVGVE02SEQyTlhzaERlekFpQURYVmRaeEFr?=
 =?utf-8?B?bDdRb042c2xDQlhiOXpna3k5a0hSbDF0WHV3Ylcwb2pFSzVVUWRhc090WGlv?=
 =?utf-8?B?by9oa3A3Wjc0czdkRFhwQmJZajBwcVhDZWJacWFtUlJKTjRZczc5azNUbW5o?=
 =?utf-8?B?Szk5dFJUNVBlUllIa2JHRzYvTnBpUEpCYnhNRU42NGZSaThERTllZnE3ZHUw?=
 =?utf-8?B?TDJ1cmRUVGVNUDcxck1PVmxBNXJkTy84cHFrU3F3bTloOGZqTFhkR1FCd1Fl?=
 =?utf-8?B?WGljMmFEdTB5Qm1LS3NiaGlJbi9tMDUvdkNreldXVEx5QXMyMkFxV3BHNDZP?=
 =?utf-8?B?TTlBN0kvU1orRmQ1VUdud3d2dGVNUFBCWkVoeHJhdlVmYUFLU3hxR1RNL25h?=
 =?utf-8?B?ZUFtdUFmTU95VXg0ZUlQWVdBQnhzQnJqN1RWTFV0cGFsRVdWL05qeUE0ZWtv?=
 =?utf-8?B?akhpNCtVQjBMRTcxRFFFNk1yUUF4a2tYWElSQnEzWnIra29QQ0syZnQ3dXlH?=
 =?utf-8?B?NlFRU29MTGZOZzVWRFhDNEdYTi8wdVhQU1Uyd1grTEFreWQ5NzFWbVl0c2M1?=
 =?utf-8?B?a21BZ3UrRVJ5aGY0b1hVVC9lOXlGczFyUTVwTStxcjFpZGV2cDRsQzlROFA4?=
 =?utf-8?B?NDRCLzhrekVuaC9xTmJsNFJyTVJaUGVDMTU4bk10NTJaL1pBalFFa0FVT0dl?=
 =?utf-8?B?TmtZVi9WZ1lac2pXREI3Yks2NWJZcEVVK2dlL201Z3lDNEIvY2FtbS8rTjVl?=
 =?utf-8?B?TFl2elVJeWI4UlExaE5TM0V5dzZnTHlTOGZSVklVL2Izc3ptMmpjWklwK3FL?=
 =?utf-8?B?dCsvK2JNemZFWGNObzRXVU9aRmY5c3M1Tnp4L2hRSDlWUUhhWGpjRUdMUmZX?=
 =?utf-8?B?TTNzT0ZibEtiZDZxSkFxT0VLUVNjamFyZlpHNFB5VEw3dGhoVlJGNVk4MGo5?=
 =?utf-8?B?RVQ3cU1hcW41NkZ0bmtDdkoyTmlvSy9CRG9UUkEzUUZUN1h2ZlpPU0pPTE5G?=
 =?utf-8?B?Rm8ySnNXbnVFb09ieng1eVlLeVJ1bWtkVUhsVytEcElaejZuMUV0d2tENXpi?=
 =?utf-8?B?V25KVmxma2pwVXNXR0J6L1NCSjQ0amlYK3VaNFJ2NS9uNU9hSnlzb01ZZkxD?=
 =?utf-8?B?dnYxTVZhNGI2T2MwaEU5WmsrNk5KdS80cFkvTUhGbHMvUUIzYzFJUFNuWkRD?=
 =?utf-8?B?YjBBMGxzWlhvL3AwdTRhaFhWYW5aSWtPV3lhUy83K3pnWS8xTHlPSVB1UXAx?=
 =?utf-8?B?NG5ZS0tGZFpSL0dZS08vNHJGdHBRTXc3MTZSd0NjdWpFc09OYzZwNHBzTzNs?=
 =?utf-8?B?TlIwZFpWaW1oWGVTNTA5K1Bhck9odlNDa3dEVDJwYlJoUW5pWkd4clorb0Yr?=
 =?utf-8?B?RmhOR1UxdWRaUkFwQUJMMXJ4Mll0SHBiZ29jbGQrbWR3Rm5Bc01oSnZQdmhH?=
 =?utf-8?B?Y01jbXJ6bkMrMzVrZGlqYjB3emtIVmFvc1E3WWF2bG5wM2FXdXA2T1JZSDFY?=
 =?utf-8?B?YWZJbEx5anJoMFlBZ0dLQmIvUWN0VXB2c3k0K2VyMW42WkNnZ3UrNkxnS00v?=
 =?utf-8?B?bWEyK2FaTzNocTRESmU1WUYvN01Gd1Z6UEo3ZGJKbU80TW9JL1E1enZSRlBp?=
 =?utf-8?B?ZlBhWmxwY28xYWxSNkEwdy9ZOVVlNXNsNEtya3pJam9XYk5DOXJLYXl0aldj?=
 =?utf-8?B?TytFL0RqdEhxMmprSzBzMzdGWThqdEdrOGs1eDA2c1k0OG5zczRyYUlQMXh0?=
 =?utf-8?B?VDR4WllCZ1NOVzltMEdRbTRmdzdBMmIxUUkvU3h0cU90WUQ1ODJpYTMwY3Uw?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC87103C846DBD44BA44A7DF91ABCC92@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7638b26f-a7ed-4d80-3c21-08dd36e43008
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2025 10:46:24.2424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YqD17D0ELNlX/SJrM8C9yROlyBQWeULfcUwF/+22mO6bdIE3fMK32aHUgo3QS+mtMC3xqnWcN9f7LfW5z18bSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5820
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTAxLTE3IGF0IDA5OjUzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOgo+IEJ0
dywgSUlVQywgaW4gY2FzZSBvZiBJUlFDSElQIHNwbGl0LCBLVk0gdXNlcyBLVk1fSVJRX1JPVVRJ
TkdfTVNJIGZvciByb3V0ZXMgb2YKPiBHU0lzLsKgIEJ1dCBpdCBzZWVtcyBLVk0gb25seSBhbGxv
d3MgbGV2ZWwtdHJpZ2dlcmVkIE1TSSB0byBiZSBzaWduYWxlZCAod2hpY2ggaXMKPiBhIHN1cnBy
aXNpbmcpOgo+IAo+IGludCBrdm1fc2V0X21zaShzdHJ1Y3Qga3ZtX2tlcm5lbF9pcnFfcm91dGlu
Z19lbnRyeSAqZSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3RydWN0IGt2bSAq
a3ZtLCBpbnQgaXJxX3NvdXJjZV9pZCwgaW50IGxldmVsLCBib29sIGxpbmVfc3RhdHVzKQo+IHsK
PiDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3Qga3ZtX2xhcGljX2lycSBpcnE7Cj4gCj4gwqDCoMKgwqDC
oMKgwqAgaWYgKGt2bV9tc2lfcm91dGVfaW52YWxpZChrdm0sIGUpKQo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLUVJTlZBTDsKPiAKPiDCoMKgwqDCoMKgwqDCoCBpZiAo
IWxldmVsKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4gLTE7Cj4gCj4g
wqDCoMKgwqDCoMKgwqAga3ZtX3NldF9tc2lfaXJxKGt2bSwgZSwgJmlycSk7Cj4gCj4gwqDCoMKg
wqDCoMKgwqAgcmV0dXJuIGt2bV9pcnFfZGVsaXZlcnlfdG9fYXBpYyhrdm0sIE5VTEwsICZpcnEs
IE5VTEwpOwo+IH0KCkFoIHNvcnJ5IHRoaXMgJ2xldmVsJyBpcyBub3QgdHJpZ19tb2RlLiAgUGxl
YXNlIGlnbm9yZSA6LSkK

