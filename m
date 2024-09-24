Return-Path: <kvm+bounces-27366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2912E9844F9
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 13:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D1381F241B7
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 11:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6481A4F29;
	Tue, 24 Sep 2024 11:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fiakAfi7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAACB126BF7;
	Tue, 24 Sep 2024 11:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727178014; cv=fail; b=pxEfqTP4t1RTFRxf9WF8gvl3f0YYBfX/EUTV+EalWsLA3s4rQjKkdQ08HYoeHZyWDnwmhI2WIPIPwQQfNORsN0gBbKgMxFBENkDOQCuI/Sy8dG7MrM3k5r/NE9rzEWXvrXcI3VfSACQyZkTdvgq5Q03Ues8RGkD6whyveoIvlrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727178014; c=relaxed/simple;
	bh=U8cKkh8vh8JSN8Eq50buZIepBx0jp1pHg/9+ePUOf1Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bEdxq2xR7AUepVLdxfJEwmXHk6SZizOzT3z3GxT/G6bIUcoWQd/WhJY2Yh5Qmz8FOYlFM5Y62993/waAkpvntm7jQ3bN5+rWojyDs2nEbnO+GG3fVXNDWPVEqGPWB46fCoWDxg8YPCMVqvFPLwDcWShOwiUUNKOTmyLHvb35JI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fiakAfi7; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727178013; x=1758714013;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U8cKkh8vh8JSN8Eq50buZIepBx0jp1pHg/9+ePUOf1Y=;
  b=fiakAfi7h0/9EUsWIMCLbGJLPBiIen0w97CwPXWCtpc3epfmgWxMp75J
   oFmppTzYhgVG37J/Tqofv7iXDslyJj6f0F8WL1bAg0/S8D+ZKYqBQx4RE
   Omlxq8lJldgy8ojyiHy61brLivtTBJftgdpE9T+aWOsTWtURQTUVkBaXk
   HBSPG9LH9/Oosb1IA874JJsT4zZTYSVnyPJkumPdbgwuX4Klk/Oq0TtDS
   vxbi8f+I3R4DIhfooqcgLX9R884iea1ZdF+naJvKm4ooLeewoVstoobN7
   QKO7oo3IAdku1bmmCKfSyNKsAMtQNuU2k0NZrO3NjHvRkd2w+nL9wiYvM
   Q==;
X-CSE-ConnectionGUID: QKqrkH7nRqG6V94GI2yleA==
X-CSE-MsgGUID: bM34gW0iSFS20bvAxOVvsQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="37541956"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="37541956"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 04:40:11 -0700
X-CSE-ConnectionGUID: U52I26B/S5u9vB2w03Nf9w==
X-CSE-MsgGUID: CX7HSRyVQN+dX+XLoIWEuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="75904119"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Sep 2024 04:39:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 24 Sep 2024 04:39:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 24 Sep 2024 04:39:57 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 24 Sep 2024 04:39:57 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 24 Sep 2024 04:39:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+RYFPPqilND0paJVCNUKYFsF83M0uNHc0/VBxH8h+/Cev5gnG+pDKwcvXnk2XgFE+TuDVPghdNpMbDi0cM2lNwbBFRqj71Ig0pTR7Q34oI/BKlQG0S6r/2XZYiRA2l4J89H+MHeINnoJaNvCXMGp/7TH0kn5QSlQyC3JyQQsSk18JY1HsI+9Kiatw2E3aII7htNZ1yx63jsEzhs+tAEmdEdfAt/7cypx6pULygPupysHKP9SUAbiI6E5gkxKYjWUxsm/uOumXUIpVKx1ATVCYL+tUM0YsZekDOQayai42DkOAlsiiGO6+RMtqh1e5mNpllj1nlZs6perMUEeeb9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8cKkh8vh8JSN8Eq50buZIepBx0jp1pHg/9+ePUOf1Y=;
 b=UapDQRkPVJ+dBy+Ba3U5s9BEPsBdTc6h5s4i+Qm9dNBfLB46qmUWwWZzAz+OMMMm0Gx7EXwOs++4loU7FuL/DpGlXvQ/auhvuTosm47PDyACVEYZI+HWduCEUFuwRfz0QDKf16FNMjseKWT5d4zL1Kad6UPhqNFpibieLn7kWrK2fvvjTe3T5RLEpOyIMCsQBBiSLDYGcF7yzjCBqUuyqSMrhHerUa/dr8RujAV+W330+mpxpUt/TZVT51/pgY+CXE7JX/Qo6mCYkGE4WhAcU5CugVe9pzzhsE2yo3q4vtNaQvjcS4jLBeU3bMtLyf/MzYtSaK16zsmv4FvQPzBUgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by DS0PR11MB8051.namprd11.prod.outlook.com (2603:10b6:8:121::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.28; Tue, 24 Sep
 2024 11:39:55 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%7]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 11:39:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 1/8] x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to
 reflect the spec better
Thread-Topic: [PATCH v3 1/8] x86/virt/tdx: Rename 'struct tdx_tdmr_sysinfo' to
 reflect the spec better
Thread-Index: AQHa+E/wAV0jXss1OU+QXa6tk2S5LrI7FGcAgACZqQCAK05AAA==
Date: Tue, 24 Sep 2024 11:39:55 +0000
Message-ID: <1375ae21332ecfe4690315f64568aab2e0b3273c.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <b5e4788739fd7f9100a23808bebe1bb70f4b9073.1724741926.git.kai.huang@intel.com>
	 <1b810874-2734-4ca8-933d-ebe9500a8ddc@intel.com>
	 <2152e96c-eccc-4e96-b658-70cc59dfee68@intel.com>
In-Reply-To: <2152e96c-eccc-4e96-b658-70cc59dfee68@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|DS0PR11MB8051:EE_
x-ms-office365-filtering-correlation-id: 11d05aae-9806-48c3-9f4d-08dcdc8d9c64
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eHRTMHdIUTFQT1hqWGoveFUwbVh1S0NVT3Y4emJ1WTFpZ2tXOWc2dTU5U1Nh?=
 =?utf-8?B?aU1IZzVUaEo5TnlQV1NiaW5WVDIzWFFadkdXelh4bkttTFJlTFJyRUp0ck9h?=
 =?utf-8?B?NnYyMklNTDA4WWN2anZZS2dkRkF1NDVzN2JjTjV5MUtacmllZHRIeUhzVDdE?=
 =?utf-8?B?Rmp6ZEdQcXFmbEhRTTFmaHNDSUMrK3VtSkFUdVgyc3VBalpxdU8vRlhPQSt4?=
 =?utf-8?B?UnkrNUhqS2NmVnpUaEtJQlF5ci9DTjhlTTZRNWFDVFo1Ukd3R0JQY3ZHaW9Y?=
 =?utf-8?B?QmEzTnhIOFBneHY4R2ZFWTJIVTZiT1hsRTBCR2d0d2JqVlNpRmdzemNQcUFs?=
 =?utf-8?B?R3pwcGIwNFZXTHFyS1pobGRFTXpSbkpTYTZzbnlQa2t5QVNhdTNzTzUvUXpE?=
 =?utf-8?B?c0hlc05rVGV6ZEFYUjRGQmpIc2RVVDFqd2hqZHNnMTNFTjhtZWZGVHZtY1pi?=
 =?utf-8?B?REFCakRtTEZZcVJXWlF4NThnSG1RR1ppQXp3TEQ5VTluYkJLWlNXd25GZVph?=
 =?utf-8?B?L1paVzVuM2VWUUZzZnhpZ28xOEI2UHNrOTlVU0Mvc0MraXE4Qnc4Y09iTEdB?=
 =?utf-8?B?dXJpVXUvR3JPYms5b0Y5d3NYRmVIUFNKZHc3VDdCWGpaa0s2RlRHKy93bW1U?=
 =?utf-8?B?WmdySWxUakRvYVU0RFJJTUxuQ09iSTkvNlY4d3VUd1BnMEtWV1IxaEZQczlE?=
 =?utf-8?B?bWhEQmpaS1VhMmpnSzQxYjU1Y0dwNjJoSzR4ZkFVMFQ4VHhYVDNRNDNWcjNp?=
 =?utf-8?B?NkwvL2hsdXlGenNEaGhONWNHQkZRakxPbmNCQVFPZWhpdWVQeU5LVFdsb2hi?=
 =?utf-8?B?UW9BdlN6NWoyeXh0VU41WU9qU1BKRHBaYUNtcllQOHJyTk1FUjdKOWJZUlQy?=
 =?utf-8?B?eHV5dmFhVFFVaUE5czlVTEFFUU1KVkRmZTR3NHJoUHZPZXFqazZrdTcydnRa?=
 =?utf-8?B?YkR1RTlVT0hhSE92ZkE3OUhoZnpPQ0F3UkNDcjBNT01TK25KQkJiaU1oMUJt?=
 =?utf-8?B?ZlNPR2tXVkxWVTNNR1VqQ1Y0UzEzZ3Znd1J4MDRjZWNPaFJnZHlkeVNUWlZG?=
 =?utf-8?B?NVluZGZzYXVXV3cvRmp1Q3JRYWxQK05BSmt4MVh6STJSYXloMWQ3K2NIM3JN?=
 =?utf-8?B?Wk54dDgwUDFkZzJhdFlXOTJ2eERjRllBQm9TdTg2REhxTmxkcmJ6RWdnQklI?=
 =?utf-8?B?REtWUWMwY3U2ZXdaVEJVVk0vZGNUQW9nVW1va0M2S09RRHhLMjJZNlpMb2lV?=
 =?utf-8?B?M2tMKzZqNC9FMGVzdVRsS3p5RFd1STNwenJyNmV6M0pvZjJ1Z3JmQWJFdWlT?=
 =?utf-8?B?VWE2MVVHQjd4cXQ5dlcreTBDNTBuNnlPSEcxNmpyZnhVNndEa1NDMUlFQm11?=
 =?utf-8?B?akw1djdCcjR1U2NTWi9DTWpxeVlnWXplRmxCcUpzbXppTkhNaEU1VU5MQTNq?=
 =?utf-8?B?YzB0S0pBajJvREtuZW5hcmE4NUhnSjhqSjFMQ3o2b3lZclJqRkJyWHlWdU9s?=
 =?utf-8?B?dXBTUUM3RGkxZjNhY0Vzd1RQaFF6VVR5VnU0WnpUaHZ3TC9hL0d1MWZ0eWlw?=
 =?utf-8?B?QUY5d2x1R0M2SG1QYWNXSVdqSzdPUjc5WlhPbGM2MUtmaU1KVTJ2VTFrbHlN?=
 =?utf-8?B?M3NMV2dDOUYzUVNkNDVidzN3MkFacFI3cDVnbDNrQ2IxNC96Uko4bFZFSlpJ?=
 =?utf-8?B?SFNSZjRrOC9adHhuaDhzQnNSL0ZvRjdhTE9qQVQ5cVhzL1JZKzNUaGE2TktW?=
 =?utf-8?B?UWs2aTF6MXAxVjF4dFFhMWpEdGtLajZHRklnUDg2RTNCV3JsZytVbUVZbm9Y?=
 =?utf-8?B?RnY2U01PZmRpNVkrdVcyYURvZ05pUnpFTjg5bitvdElCVytSaForczRPSVRp?=
 =?utf-8?B?K2l2b1pyYUdsd3lyWnNhaFFOMGJpQ0VwU01CN09jQVlqVXU5Wk1UUGlaeUIy?=
 =?utf-8?Q?1ODHWXAIoM4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TUVSWEJkWTJxQWRYc3NjclMvMTA5YTRXSUI3SmpFN0dFbXdXcTBUb2ltY29K?=
 =?utf-8?B?VHYrSWd5S0hxSm1NM2lVSXQ5SE9ZaVdjY3ZpUkNQUFE4dm9OTjVtMjd6UEpG?=
 =?utf-8?B?NDdMcGVQSTU2ZjBLTlZjKzIrckROaTBmWnJtdHY1Si9EdXozZThFUjI0enFi?=
 =?utf-8?B?Q2tMN2d5bDdOREV4dFpvVEpYMWdINGFjVXhyL2xUbjQ1ZVN2LzN2LzJOT3hT?=
 =?utf-8?B?R1IwSENwZDJ1UlpGUVlZYmllSGNmY0UrK1FoaStHZEZSYVQwNy9vWlpVMktB?=
 =?utf-8?B?U3k1TGtTY2FZQjhuNmJuQ0FSakV0V3kycmx1OS9Ed3lGYStwU3BaZ3h1REpX?=
 =?utf-8?B?cmFuZ00yclJIR3BlVUVYS1VUZ1VnS2drbjFQRE5DcWo3MHp0NkpvU2UwZWx4?=
 =?utf-8?B?S2o2Sy9Qb3NZSXRsK1BSV0g4S0Q5K3FLVkk1WUtOVHRwSVF5aVB4SmdjUTFy?=
 =?utf-8?B?S20wOVBVMUhJNmtyMEJUUlVST2I5RFpwNGt5bzVwLzJPMzZJV3MxTVliWlNO?=
 =?utf-8?B?b1NhS0VraE9pZ2lENjRCSUFVeU51WUs3V2JaRi93VXZkL0NSaE92Vkdjd3ht?=
 =?utf-8?B?Y1RKMXhZYVJXYzc1N0taUTNCZlk1UmxPSGxaLzNwRnFmMWFxWnM5NzR5TDMv?=
 =?utf-8?B?UW1mSFBzMUFOWFVKTUxDTEtqbHo0L0YxclIxNDdTVHB0RGlIaXdqYnI1S3Vw?=
 =?utf-8?B?dnk0VWViK2pZSzdEVnVYRVBDbEFDa2FpS2lBb2ovQm03dVhVK1RINDFZWElG?=
 =?utf-8?B?Ulh2UjduTkNIKzkralp2UGRYM1NjT25oczZuM0UrcGhOd2kwcmZHWFNtSjVo?=
 =?utf-8?B?YW5obDVsemN0cFNHVTEwWFhZY0MwZTBhMVhuMTNkcHF0VDkxRWxLY1lTNi9P?=
 =?utf-8?B?cDB3VzMyQTgrT2ZTTHhPUzFTbUtzSnhhT0lhRHZ6dEk1ZU9aMUVKeTBHQkRM?=
 =?utf-8?B?VVNrYWJMY1cxYVUrcW9Fd0sxRkFacU1ia0FvRjRLeXZQZzdJbDR1WERzUVdN?=
 =?utf-8?B?ajB6c0d3MW9wVkFuVHUxOENSYXdVSUZoWUM3M01YQUY5NmViLy9OMUVDQWlB?=
 =?utf-8?B?UElYY1ZSUi9wcmU3RG5SOUJ0Snc4QnNXR1hDRXVjdVBMS1U5eWducGRMTGxR?=
 =?utf-8?B?MjJOZWg0d1ZCSTEyL3lBazBXcExlejZ0NmRqOEUwbGNmdGozSEtOTlpHOVpn?=
 =?utf-8?B?aG1KUzNDbXVyWm9iNUQ0ejZTUWlaVWlCN2JYdkFqTXBPNTR2SW1iYzBFdlRR?=
 =?utf-8?B?ZUwvbWhXTm9UNGlQTkJQRGduKzhxWE40dE5VcjRzWktaQnZ1VnA0TERQZy9I?=
 =?utf-8?B?UGVZMFRpWENwcTNlYmtEeWloTTRhbENjalRYUHZtclFaa0J0aVFjQkdqcVkx?=
 =?utf-8?B?WmFPM1N3OEhCOHdDclV4RWUzaDFkZXJ4S2NSRWdrRXQ0WThYK3l6ZUp2VnBX?=
 =?utf-8?B?VEV2bmpvSS83a25LeHQxcmpHdmlUZC9YcnZDaDFnNnEyN0tiZjVNZlNpR2Uw?=
 =?utf-8?B?SWJ6VHNCRHhpdnZJQ2VQejdLMFJWZER3UnpVV3FTNXRwc3E0SmFtVFUwbkVN?=
 =?utf-8?B?UDlzSXFHd3ZnNHNhbkNkWUgxLzJYdkhMQlNjR0pGRHg3a2E2bUY1aHVkdEtm?=
 =?utf-8?B?bXJTMm5PeERXU2lOWkV4cjhQSXYyb2lneWNmZVVyclhZUHdlSDNyakNrSDIv?=
 =?utf-8?B?U09vUFhsK1F0UXZmWHVXL01jcmdYOVVlUTNQM2lrYWFhRUcwRXVxNXNSRjNW?=
 =?utf-8?B?TitScERqOWhGS2lyOXVVNTVBOWRwQmF6dlo3aW96b3dZRjAwYUdHRjFmWkNw?=
 =?utf-8?B?aFk1OGNoR21Oblk2Uk9HUFJSK25McXhIeS9zMTZVRFo3WnVCQXd0OEFLWllQ?=
 =?utf-8?B?VDJobXBETWlBUEVhNlV3eXBTeHE0dFhFY20vMWNqQmtiZy9sSVFQSnBGNnVU?=
 =?utf-8?B?SFY3WklRVUVFeHArMFppSVU4U200U3FxSWZyaWN3ckJNWDQ4Q0dtdEFKRXBk?=
 =?utf-8?B?QXp3NlhWOEhVVGpmZEJVNmcreXI5OENJbitDeHkycFh6em1oNTJiTHJacWtS?=
 =?utf-8?B?RC9oRVMyZ0tGTllCbisydzlxeG02RXdIZVAvZE44dUFCZzVDRE4vbDE3d0tL?=
 =?utf-8?Q?PN+jgt/5C5jQAiXVxrliz28a8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2ED04D43E8EE7C4EA215357B7C04E310@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d05aae-9806-48c3-9f4d-08dcdc8d9c64
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2024 11:39:55.1837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C89MMhQKezXLzrxIgu6iCkoZXdv7pti1275dyeF6pocsuoWp0wPVqCgtZfFo6kOPLtzQzVxR13juxEp4uQ8lbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8051
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTI4IGF0IDEwOjIwICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gT24gMjgvMDgvMjAyNCAxOjEwIGFtLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0KPiA+IE9uIDI3
LzA4LzI0IDEwOjE0LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gDQo+ID4gInRvIHJlZmxlY3QgdGhl
IHNwZWMgYmV0dGVyIiBpcyBhIGJpdCB2YWd1ZS4gIEhvdyBhYm91dDoNCj4gPiANCj4gPiB4ODYv
dmlydC90ZHg6IFJlbmFtZSAnc3RydWN0IHRkeF90ZG1yX3N5c2luZm8nIHRvICdzdHJ1Y3QgdGR4
X3N5c19pbmZvX3RkbXInDQo+ID4gDQo+ID4gUmVuYW1lICdzdHJ1Y3QgdGR4X3RkbXJfc3lzaW5m
bycgdG8gJ3N0cnVjdCB0ZHhfc3lzX2luZm9fdGRtcicgdG8NCj4gPiBwcmVwYXJlIGZvciBhZGRp
bmcgc2ltaWxhciBzdHJ1Y3R1cmVzIHRoYXQgd2lsbCBhbGwgYmUgcHJlZml4ZWQgYnkNCj4gPiAn
dGR4X3N5c19pbmZvXycuDQoNCkkgZGVjaWRlZCBub3QgdG8gZG8gdGhlIHBhdGNoIHRpdGxlIGNo
YW5nZSBhbmQgdGhlIGFib3ZlIHBhcmFncmFwaCBpbiB2NCwgc2luY2UNCkkgYmVsaWV2ZSB0aGV5
IGFyZSBuaXQgYW5kIERhbiBhbHJlYWR5IHJldmlld2VkLiAgWWVhaCBJIGFncmVlICdyZWZsZWN0
IHNwZWMNCmJldHRlcicgaXMgYSBiaXQgdmFndWUsIGJ1dCBpdCBraW5kYSByZWZsZWN0IHRoZSBw
dXJwb3NlLiAgSG93ZXZlciBJTUhPIGFsYmVpdA0KInJlbmFtZSBBIHRvIEIiIHJlZmxlY3RzIHRo
ZSBmaW5hbCBjb2RlLCBpdCBkb2Vzbid0IGNvbnZleSB0aGUgcHVycG9zZS4gIFNvIEkNCnRoaW5r
IHRoZSBvbGQgdGl0bGUgc2hvdWxkIGFsc28gYmUgZmluZS4NCg0KQWxzbyB0aGUgc3VnZ2VzdGVk
IHBhcmFncmFwaCBpcyBraW5kYSBkdXBsaWNhdGVkIHdpdGggdGhlIGxhc3QgcGFyYWdyYXBoIGlu
IHRoZQ0KY3VycmVudCBjaGFuZ2Vsb2cgc28gSSBkaWRuJ3QgYWRkIGl0IGVpdGhlci4NCg==

