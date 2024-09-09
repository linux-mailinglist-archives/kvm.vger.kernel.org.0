Return-Path: <kvm+bounces-26157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA6B972435
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 23:07:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C15F71C22ABF
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 21:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 740EB18B493;
	Mon,  9 Sep 2024 21:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EGOMwjIu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF33818A6B9;
	Mon,  9 Sep 2024 21:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725916060; cv=fail; b=m48NtG+jBMM9LlRw+f7ZZyomKWD48SfhfuKuKycwqONdfNttRRqkgtcxyLtvn+tc550v/fqRAEpvYiE/AkEfiN6Mj3PT5uGHphlqNwoEZSd5+nkevaPsE6L51BRbD0e38P06MN3wX/8oT0QyiDkC6srG7rCCah5YPvpDpgA2wbw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725916060; c=relaxed/simple;
	bh=KbDlq858N5Efe3a+1XdtsqjfL0XGxosa1xIwnnxjUzg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=I0S1Ulca+FjFK5gttW76KypwN3dmnOYaJiQ6/prFTefhLni9P2FEod4Sa28wlxc71/TIz/n3vYA7xHYjXnunlDS1OmNQX95Coh51wMFRGRR68qb8i0MyZIqxsDMASJoLZWPy4VnHQ5z3nUfESIpCm3gFg197+aKCOGGt8E2m0II=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EGOMwjIu; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725916059; x=1757452059;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KbDlq858N5Efe3a+1XdtsqjfL0XGxosa1xIwnnxjUzg=;
  b=EGOMwjIu2G2F2S7ZkUDwnPTOZCRc6uQVKGAS88aYnYRUiPqyrxkIJDEp
   e0ZRLl53A76zf2tEl1HyEHMEeXhQukavUmmvjILlab9aqBsbMt2bcr66e
   tpyBltEIPhe5XY0k1uyCe+kNDzE3lNUGZFa6S+x/wOhSdmdQbqZN+BPFB
   cvvVoLoT4sgEWo1MpygviMEk0KYSiRSBjGb4aqI+WTQglLt7ynfuxBuG7
   nTXDyFmAZMluNJkWKctGrfMDDx6SVqZWp3+Id5aWAqT/NeUBqTw+489jm
   EogBJMHFkea1oQ/9JVQt6mjB88Mq2toUf/KlCe6xr3YY0XkO8StG7toyo
   Q==;
X-CSE-ConnectionGUID: HlBrFXFsQTW4PgLk+9WnZQ==
X-CSE-MsgGUID: 5xuxNCUOS+KZUWLasaXZCQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="42114778"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="42114778"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 14:07:38 -0700
X-CSE-ConnectionGUID: wSGcdRwKQAGk506+JkPT9w==
X-CSE-MsgGUID: hDxx+QklSH+kakoekq6ewA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="97604201"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 14:07:37 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 14:07:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 14:07:36 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 14:07:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KMTVVxL5Bjh/7qgTw09sTU/magZKEBQNWIJ5DwGdR0mpwOK1K1ObyLw10mFdE5SPyBhoy1W5MPkWDSZo7u08d4W7CIBl+BphM3fKlOY7+8HdlnhgXj42cHMSJ8nS0LWX6KCP0S3AQeOUdGbhyjr8iGTYbjZ1bmiT6x3MZbSpxG+0vwQEZ1p/fPG1RjNQj8MJJdJIu4U9YlpUgC/pyYC7qRpAEtKgdaTGOvXgLJ1Q1v+3VSHoSF1yo9g+Rb/7RPXBiTUz4h5xP7JEOeylWPSd8rrnWALTJOQYusanca3JgsBqCTN9GQqum9mZMSuHSWWQaeGI3Dll31GDV0AKHhHT3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KbDlq858N5Efe3a+1XdtsqjfL0XGxosa1xIwnnxjUzg=;
 b=GvbriFLcKm+YrbwDN9PdUrxAFlwuL0r/nXAnBDdBqOebEtqhSYeYWgdrCsuTGDGx30nMjFrwBssHWnn78Cx3wVqtPVlED3gHwgmLFrF5wf0uZhecbxnASHl1fXOfk7FHdxO86v8JRET2ukiH9LQuhAUGmF8fckBFE0GhOYGfyl6IGiQZMLgV3XxVn3PmtHymudLKbliPYISYA8Ml0JrKPp/Vrilcei/FQbSeQcUSB0/Xc+1vV4GvgZGgk9VAl+Ubyq/CU+ZL7ILcya4MAZssc7oTPwtW6kINBH46JRd3x8MGfQzlQLqNGxUswAvU4aeV3zKkWK1yXPR3ZaJ+V8wAOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7862.namprd11.prod.outlook.com (2603:10b6:208:3dc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Mon, 9 Sep
 2024 21:07:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 21:07:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/21] KVM: x86/mmu: Do not enable page track for TD guest
Thread-Topic: [PATCH 03/21] KVM: x86/mmu: Do not enable page track for TD
 guest
Thread-Index: AQHa/net/nddhsqhv0+jBLnQOoFlmrJPgl+AgAB5PwA=
Date: Mon, 9 Sep 2024 21:07:29 +0000
Message-ID: <7387fb537c851a4038270f126f01af3c29490a2a.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-4-rick.p.edgecombe@intel.com>
	 <7d986ebc-f3a3-4a06-96a9-8c339fdfb23c@redhat.com>
In-Reply-To: <7d986ebc-f3a3-4a06-96a9-8c339fdfb23c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7862:EE_
x-ms-office365-filtering-correlation-id: 4a77b109-ce76-470b-efb2-08dcd11369f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eEZ2WCtwclhZMVA1dlkzeW5Oa1JwbXVIb1FCTGl1SG5wL3A1VXBQM0NnVUJk?=
 =?utf-8?B?K0Fqb1B4SEtCeGMxU2JJRFdCMUV5Ny9SRmNSdlI3WHZHY2pyWmZFMVpMU2Ji?=
 =?utf-8?B?NFdRL3pya3ZyWVdHVG9lelZWaWhWUE03VFAvNTdML1ZVVC9oNjUyVExodlpR?=
 =?utf-8?B?czRFZDEwOVV4cXd1eC9iNVlHTmVKbWVLaXVidWZDMFVOUGZPZjZ0YXNoZXM0?=
 =?utf-8?B?RDZXRkcwRGN0TXdISmtFOHFhZ0JJQmlEWmhJdnBZS0pqb3BjMHRqdlNVWWE4?=
 =?utf-8?B?YnppY25yUkk3VGhrbXhMZ0NFNnpsR2lnYnZuMWJCY01VZWtsRmJyVHV3K3Z4?=
 =?utf-8?B?RFpQZkNhdDNmL3RJNzhmbjY3WEJBbE1Sc3hFSGJZck51L0luK0d3NUNZUDV5?=
 =?utf-8?B?eWo4dHlMUUlob2U3eU14amRHdTdrWHNZS0VhNDUvZmRQZVgrMVhkeXZyL244?=
 =?utf-8?B?WW1hQmk0bDNDelM5b0ZuSUNmaDZoTG9vTXNwOW5CdWI0K2xFSXVDbzljUkZ3?=
 =?utf-8?B?RVl4UXlENzRUYWtlcjJjcUxYN2NyZ3pPZXRpL2RMSm1WVFptT0dvRW12Sjc3?=
 =?utf-8?B?S0tkZWJ5amx5MTdlakhUa2lzczBIb09uVDNYaHV2bWNlT0NhSitsR1pRUHJ3?=
 =?utf-8?B?RVVEKzhvL3pSbzE5c2ZqNzVjNjBlZ2cxajRFSGdpekdtNW5MTnJISU51WkZm?=
 =?utf-8?B?RTRtVEx6akJXVkRMTGk4ck5sRUpYQnAxZW14VHlJTHNNRml4WW4vZVFqOFYz?=
 =?utf-8?B?US9hTHEwZTBQc1Uzb1ZJM1Q5eWtQNmNQRzVmaXBicVFlUXdxTHUraDRobzNs?=
 =?utf-8?B?N1o2bDRmeFZwU1d1RHUzWEN2dEVxLy9iczFIM2JSVlhsKzF5TmtHeDI1Q2pU?=
 =?utf-8?B?ZEdjT2NDZDlWVkM4NCs3M29NZGNyR3VUcXl1K2NsSksrSklEVGhuazVTOXNo?=
 =?utf-8?B?ZG5jK2hmR3A0TkptZHcyM1Y3SmhJVDZBSVdjeFc1UktyajkwMjNHRUVxeHNJ?=
 =?utf-8?B?V3NpeW94cVhWOGxJdlk4T05FVWJXb241TGs1MFVGeVlUWDJHRXRYaUxqUU5E?=
 =?utf-8?B?QW9CNzBoS21yYlpRbHF2bXRHV2tqOVdNQjZNMkFEaWdTcncxQ1ZZa2ZhdXZP?=
 =?utf-8?B?czUzemNueTVIZ0tXbEcyNkVTMHBXb3ZOUW9SZklRK21oL0V2ejVHeHlRWGw3?=
 =?utf-8?B?R3hrbWlyZFVyUlJ3STkreGVLRFhXYWJvVEtLb3dGSU53YzNKNEo1bjBORGox?=
 =?utf-8?B?Ym1SN3JnRUM1SGw0ZlJXUWpUT2JMbU55QmZKWG4wSUMxOUhxUUx0OHplQTVo?=
 =?utf-8?B?RXlrbS82OUxLa1JSb2hNQWtWRXpCbTFBOVZacWwxY1ZsRE54NklnS0NPa29y?=
 =?utf-8?B?NTFjTzBSdkc3V2Rud2ZzUHhhK3B1VHI1SGdOM2lITWwxWlEwVkg0SUlwemlH?=
 =?utf-8?B?Ym9SYXg1cncyUE1FWGd0UmFmRUVMeUpjeTFxdW5uTnoyd1N6K3p6Qm1obUxU?=
 =?utf-8?B?K2FQenRhMjVtUzYvVytYV0JhWlZwc0dkMGw0aFBjVU45bEZpdTk3SitzNHBC?=
 =?utf-8?B?Rk4wekRGemNSc3p4djM1WElzOG5MWEllU3hFdDE0NjVrSzI1TGQxTGxqTVFM?=
 =?utf-8?B?TVZicjdqS3lkS0ZaRGhsNzAyMVkvWmZBam91VTJ4UUFueHg1WU1POEc2MVZ0?=
 =?utf-8?B?RmxtTk9CVzB5MHJPS1lZa2ZEVTNlUWhVRDJ1enpFV2gyYmhEVlN0bE9aaGd1?=
 =?utf-8?B?NEVyRG1leTNNQlhxcEduZ1Zpem1HdDRCQmlkZ0V0Njl2eFRya0VjTy84WTdX?=
 =?utf-8?B?Q3ZVNENuOG16bks2c21udHRzUE5xQzI0S2RDVHRDUjhzajhvWnRlMDRoK2FE?=
 =?utf-8?B?aG1LWUV5akUxSDgvQjNuSmRnRHlzNG9VTHFqbmNybXdZRlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azZ3eWdkaXFqcHBjckdTZ2ZEcHNzVEdqRXFwc0E2b0RwTXI0cHN5WGtMK0hz?=
 =?utf-8?B?V084d0VhT2lQUFdnR2FPdnBwOEtaTjRQdUF4WERUa3NLaXdnRGlDQkNMeldZ?=
 =?utf-8?B?OFVwODFsQVJKMkZ5UzlwNG9sTW1ybU93MGNJRVowcUM1YlF2USs4K0hVNjZv?=
 =?utf-8?B?S2UweXBvMVFhdHRPQTlxN1dPU21tVDA2M0E0OHE1dFlBUWJmNXNscnpJampi?=
 =?utf-8?B?UEluTzdGc0lLUEhGQXpxeGZ1eW82Q2R4WVJadGhZdER4ekExNVZqT2VGUmZv?=
 =?utf-8?B?Mmc2Z0FRblNkQXB4dmQra2o1RVhadjhMY05qV1BqVlhFSU5vSzkralVZWUQw?=
 =?utf-8?B?aytkdUtpOEVwYi9JT3BvYWRUcGF2YzNtR0cwZVgrMmVrRzUzQUFtTXh3ejli?=
 =?utf-8?B?VnFUVXRVODBHUXB5Zi9zOUFEYkliUTZOb3FMTldPb3oza0dzYzErT2VnZUdo?=
 =?utf-8?B?MHYrNG9nV05wVXRrWit5ZVJHMmhJTXNLR1JtWkZwZk1WTmxwSllNSUgySXhX?=
 =?utf-8?B?elM3Q3JYUVdiZnExbVRJclFlYURJdDhmeWtEck9NRWxyc1RDSDlmKzUrRDB1?=
 =?utf-8?B?Q2ZKM3QrRVlXV2pEaGROcm5LODVHWGR6Rks1R1g3eXY4YzAvRjRSK09qMDlr?=
 =?utf-8?B?am9qNGlCaVV4R2NSZmJuaGI1Y0J3N1poY0FPVXdRR0YrNHV1ZXhzYmNlUGFv?=
 =?utf-8?B?M1p4WGF2bzlnci9acGFxcGpTUzJYOUhmMmRKalVKbmpEWEwrVWlHb2ZJWHIv?=
 =?utf-8?B?MS8vWDhBWkVMRnBURFYwTSt0blZPd2pHcm5zdFRIZUFMbTVCbzZPdFhoQmh0?=
 =?utf-8?B?c0VGZ0dZMlFWanUwazRKOE1SMkdHeWZ0RWZDZFhLeTFiQzZ6dmhyQ1lFVVVW?=
 =?utf-8?B?NllVMXdPSFJ5NHFrdGpUWUdFKzBmRjdwTzlNODd4eC8vOC84K2xaYURMa044?=
 =?utf-8?B?SFd1WjR2TlcxMWJQek4weUR6cVE3bDlmZzFVeXhpLy9JQW9oMk5HbWpFdWdq?=
 =?utf-8?B?ZGt4SlUrY1RBemNaK1RHdGJyQlk2VU1rMjI1ZWRmb3pOMGtNQlE0TXdhSnA3?=
 =?utf-8?B?V25tSENVTTZKUk43SDE0eTlyWFhZQUUxSkpTaGpHSXRGQmlSakhVZCtBQkI0?=
 =?utf-8?B?YXp1VkVNdEJaRytzaHUybEtlSXVLM00rK0RkcnpHK2hOeUpsVndxN3IzWUNh?=
 =?utf-8?B?RWpwQU1mcm82eGExSDBMSTk0cm42YkNhbU1PemVMSGRFdmF4RTVSaU95N08z?=
 =?utf-8?B?WWpUR0I2dWxySXkveHJnS0N6Q3p3N0FoVXo5ejZBd2xmQ1RKNWRjaG5RNDBR?=
 =?utf-8?B?cmNPbmpSOHl4Tkl0UFEyWFk3RUFyc1JhblFOLzB1NmZtN0dyM1BlK0NpVnIr?=
 =?utf-8?B?WjJxaW5MZmlUWDBOWHRJbEkzRC9GQ2FCNUdmYitNQzdWUlQ4b1dvT1lzM2ZO?=
 =?utf-8?B?S01tcXp3bFhacVdJbFlGVUdTVUU0K1ZNMnJmZ01YWEh2QnprZmNoK1NTZ3Fr?=
 =?utf-8?B?MlkzWUgrQ3hhcFVqRUNrQ0YwcmxZTjNjMHFXTWdPYTU1VkJ4K2VtU0JldzQv?=
 =?utf-8?B?MFczQkJOY3EwcnkwaTROQWdBRHFYeTNuekFxUUZQbVdEVXJMcEdHVzVEdjQx?=
 =?utf-8?B?ZlQvRndnOVJmN1JXdkZxeWplVmJSTlE0bEp4ZmVCUGpOV2hWekQ1NlkwRHpY?=
 =?utf-8?B?NmdlQ094cjV0c0ZNbzNGNmFLK0Z4M0tURGtNRUsybkQzUm9GUTVpMTN6MHQr?=
 =?utf-8?B?Nm5KaXlsMm1DejhlVW5FcmRrY29oUU1qK2c1emVFYkJQNUNUZnc4Nk5MMXBn?=
 =?utf-8?B?MVpIR1pCMDY4NGhqY3MxaDYyN09OR2dKamd2WlVFSXdJWkJJb0RVYVF4MU9n?=
 =?utf-8?B?N3BlWVFNVnA5S21Vdm4yckNrT2dOWWpKMWxUUFJ0cXJjYWdHNmFyOENXeFRD?=
 =?utf-8?B?RWx4dllZZ1FDWXo4Q2gvVzd1czBYTXpWMVhlbFltUmRibnZ5UDYvN2hzd09U?=
 =?utf-8?B?VHdTSFFJS0xnQnlKZW8zdnAzeUdIb1RQeTBwUVdGSi9vRjVPL1dSRnhDRFM5?=
 =?utf-8?B?Z0pXVnRQQjlZOTVVdXhvc0ZFbVI1VFBQdTdUWE9MajZ6SXhKRHFiUWRCanBB?=
 =?utf-8?B?aTZpRXg1RUVhbUt6Qk13bDhKcXk5S0N0ZDQ5U2s2SHV0anFaVjZ1c09WTkYy?=
 =?utf-8?B?b0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A488557DBE9E044A5B54B562559F47D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a77b109-ce76-470b-efb2-08dcd11369f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 21:07:29.1649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8EpjKg5r60tWDd1dGlG5Cv445EpMeQGams80MqSxqbyAqGs1Sxx8H7Ro+nSitlchZIFzojKoFF12Zsb91+CCY4PSeqNWI5LPTzdTJBhOmdU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7862
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE1OjUzICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiANCj4gWW91IHNob3VsZCBpbnN0ZWFkIHJldHVybiBhbiBlcnJvciBmcm9tIA0KPiBrdm1fZW5h
YmxlX2V4dGVybmFsX3dyaXRlX3RyYWNraW5nKCkuDQo+IA0KPiBUaGlzIHdpbGwgY2F1c2Uga3Zt
X3BhZ2VfdHJhY2tfcmVnaXN0ZXJfbm90aWZpZXIoKSBhbmQgdGhlcmVmb3JlIA0KPiBpbnRlbF92
Z3B1X29wZW5fZGV2aWNlKCkgdG8gZmFpbC4NCg0KTWFrZXMgc2Vuc2UsIHRoYW5rcy4NCg==

