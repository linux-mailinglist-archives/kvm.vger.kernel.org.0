Return-Path: <kvm+bounces-17731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BFDD98C8FB9
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 07:42:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 304C81F22705
	for <lists+kvm@lfdr.de>; Sat, 18 May 2024 05:42:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E83B9463;
	Sat, 18 May 2024 05:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JB4hOr2F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EA41A2C06;
	Sat, 18 May 2024 05:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716010939; cv=fail; b=hpK6pgUogsu17VkkwsyJBHvK2rw0b/zJj+2+QoIhrF8j1SDdr+yOdjQjb0POObZj//Aj54XxGosKfD5x9hcE2u8bZcKvMZT5AltikPQGFnf8MX0pyergTiFiugAuwNPr9n+gel11Zo6m6GN2/QhtMA7izqAxiZV+L4Wt6ogtyng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716010939; c=relaxed/simple;
	bh=+dN6tUnaRLINui0sD+s9e7KF0hktbUkvRaeHwJcMLHw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h40QofK2hHhxQoS8QmVdnh2X1mlEik4uZx9W+JO+ixbfTVfRRGAXV9bOx8LAebE14W63QQ3TNZjidCixRfVztM0bS7BMItrQVErKmBWRGdiKfXwDVKmnkRtHec3eNAmawodG4CnkOJt3xs2O4AFRzPzGyctTDlrpdlkinlXHclA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JB4hOr2F; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716010937; x=1747546937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+dN6tUnaRLINui0sD+s9e7KF0hktbUkvRaeHwJcMLHw=;
  b=JB4hOr2FIDk9YYqh/9oBIIrnxpFcUuP+kWa1c00eTlH7ZWv6MrM3j1Vo
   KMawtgWKkqWxlmULeYYkB1+nWxBs8Rp3XFq/s6JTEz17W9JnaZOTAe0Ir
   ou1SU07eV3nnQJLsbLpmXtKp4LwprCKcLQHBvLZ43PInRYZVqHcAWAIv9
   5U/ofkrdbP+a/8QHZ6UHDXJdY/Ni9N93QX4txYg9oeN8QEilwuokquH4i
   Cyv4+dkRyMHyh+hR+kJ2aSrNCG3Z1ACyRfmAAJUtFpEO+1Dr/bvg6NMUM
   Wfy0KgVX61XaZv2M746/mKNGbaEOIaurCnmKNLm/WuSZam7a7OxyDo6fc
   Q==;
X-CSE-ConnectionGUID: zub7t+pvS5CMf9TpRs1Ylw==
X-CSE-MsgGUID: kcm8bhCYS/CsYL99qzgx/g==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="16033800"
X-IronPort-AV: E=Sophos;i="6.08,170,1712646000"; 
   d="scan'208";a="16033800"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 22:42:17 -0700
X-CSE-ConnectionGUID: /toTJrPbThWLNNv8I12cWg==
X-CSE-MsgGUID: OnbXsvS7RoaHUtik8/I1Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,170,1712646000"; 
   d="scan'208";a="32581822"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 22:42:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 22:42:15 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 22:42:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 22:42:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nW8CAvHmt67Mi6ySaZqsoXgWTtZLI6SonixjKxWeyhzBkyzn2RmyteOUQcMXkxEY0vBNxXImqGdN4XvOtwbdet+YKv1syvAQ4v8ULEvVpRimfLQPkB5X2nGW5lAbip1WyJ7wB0Ao76Kn7XvENiSMai32xI0AhT6IRoZA9ZTcFYiWnCAtFw2E2imzabjdB0P8niZhcOJ6viCzWQ6j7h6HkiRvIynFfaD5I8c8tLhBxqdOg1gXk3kC46KzEi+rz6OiYOjby7ZGL4Of17/iRQGKvzUtUnsxiJ0qxRRd7oD0tO9dw3mlRHMUMZD0ihbwUt+XbnKWH6Lz0yhzQ+0SCr0A0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dN6tUnaRLINui0sD+s9e7KF0hktbUkvRaeHwJcMLHw=;
 b=cjXWoDpoVOtjFB0oVwpc11fUgB/1RA5eHzIjRap6J8v57QC/otYO9+yV5N0gZpB3+h5cwTJYhNxIUWmk6h3NKaM5H0417olz6u/NsMZVruEC7MOOUGFd00F25XXryJhH//lTy9KEP0aeJBtZzmJD9zFL3uFP5/Vk1jOUne8/MYWVtqalQ6vLRjP8fA639Bn3RMsc0s1jI54WRucZk3zvoH4VcAoeK5vCy59sAvuw9XOgHL6j339uwQrxfdtMyYeuV8g3gmwN1ztF+dcpnAWRu7iwbE3N9n1suymDoGZ7aaE/DcJtRkNHKKJ/qnjTFDhthD7hG7LqgE9b2Hz138toZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7346.namprd11.prod.outlook.com (2603:10b6:610:152::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Sat, 18 May
 2024 05:42:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.028; Sat, 18 May 2024
 05:42:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmOz3jiNvsf7Ck6WlN+dtixHHLGZCeMAgAAJxQCAAAs0AIAADfQAgACpjACAADtaAIAAM8mAgABz1YCAAF5sAIABZ7iA
Date: Sat, 18 May 2024 05:42:12 +0000
Message-ID: <b6ca3e0a18d7a472d89eeb48aaa22f5b019a769c.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
	 <12afae41-906c-4bb7-956a-d73734c68010@intel.com>
	 <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
	 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
	 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
	 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
	 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
	 <20240516194209.GL168153@ls.amr.corp.intel.com>
	 <ffd24fa5-b573-4334-95c6-42429fd9ee38@intel.com>
	 <20240517081440.GM168153@ls.amr.corp.intel.com>
In-Reply-To: <20240517081440.GM168153@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7346:EE_
x-ms-office365-filtering-correlation-id: b34aa1e8-cdcd-455c-b9e6-08dc76fd4459
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZkZBZlgyNHZlTjM3ZFIvWWpqdmVnTFRuTlFRMFVnWkMybC9oTzhwZGR3L0VT?=
 =?utf-8?B?ZEFVNGxaNVhQYmpUdW5CU1RwVk92MVZPOUdjOFh2NHBuWnVZZmptaituZFl6?=
 =?utf-8?B?K29Benp2ODlyd2FxRHNJWUxrSDBFS3BZaUF5UFFmbmJkdHFiNnYvRWhZUmNn?=
 =?utf-8?B?Uk5PYmEvR1dWL1M2VHd1T0Fab093ajI4NEo2ZFhLZXlPSHNObTNDSng3c1FK?=
 =?utf-8?B?WXdyM1NOb0xFR2xpWE1Ed1RDMjBwcGd1VHRKUTRjcHM3VUxUQlFmTFYzdUdj?=
 =?utf-8?B?RHM2V3laSE9UYjlGY1hQMjl3anZhL1dzMjhvS3YxSnYyQjFlT0I3VEFlTkVZ?=
 =?utf-8?B?bmcrYklQWWFldlVsWDBsM2VmSm8xVXNYUGl2QXhaK0pNK0VQTHk0RWdoZWF5?=
 =?utf-8?B?T2lodmVrS1RNT3NQYjVsOXVCSnh2cEJ1cSs3RnhackRLaWVnSFdrTXVicnJK?=
 =?utf-8?B?SXBjNEZqV3lBQ285bWtpM0tTa2wzdis2QVJISHlnaTk2TVJkckkvU1Y5ckRp?=
 =?utf-8?B?cjM3OFh6bjQyeWFzekdVY1owdEx4bWdrT0NZakY3NkxiUFlwd3BHbjZqM2JH?=
 =?utf-8?B?TmI1QmVLd2NuOE9ONmhIU1JBV1Znd0ZzeUpyK1BEWlZ1RTMxWTE0Qy9iRkMr?=
 =?utf-8?B?NHpiNXl1Rk91Q1RndG1aWUxnVytZT25KVVhkcGJoeXdld3ZIYk9oSjRCcEJH?=
 =?utf-8?B?am1STHpUWk5RVVFFZ3RvV3NXbEJ5R2tLTFU1MXhJczJ4T0ZqNTdzUXJJRmQr?=
 =?utf-8?B?RXN1bWxKNm4zSXpscUtvRUk2WmZEVWUvR3U0VWQrbENhQnFOMnczZmsrQUcv?=
 =?utf-8?B?WXdadmFlOG95bTdIOXJMbFFIa1B6VkppVmNMS0tjdzgrTGk5RCtWOVN2dFlJ?=
 =?utf-8?B?MzcvVWkwYVJvcDV4R3dPUnU1TW5LTkJQYXVYUENFY1oreUJ4TnBZbGNhcmR2?=
 =?utf-8?B?R25OTTlnL3NIa1dRbDN0cHBYTUIxWEJMUHR2MkFCb0tmczlEQmIwQ3l3WXY1?=
 =?utf-8?B?d1FSa0xGWVZjNEtsNVg2YUkvQkdNUUQ2V1ZBeUFPVGtROHplRGJvdU5Yemgz?=
 =?utf-8?B?YXBFbjI2K2NST2hNSHhSZTNRS21LWjUwSFJrbzRYUUVqMWpmSzk3OUlob2h3?=
 =?utf-8?B?ak12ZWNiemtkTlJQNEVWRE82VlpqS2MvUjVDMUNuSXlJb1VyM2tyS2IrWEFm?=
 =?utf-8?B?UktGclNDY09SaWNTMFBXNWE5Mk1HTnJIMU5mYkNUaUYyMi9sbm02MGw1Ym5Q?=
 =?utf-8?B?VFpKZ0kwVy9udXdydFdlRlUwZTBKV0lLRDdlR1VLQXRHRmhJNUF2L3FKNmpX?=
 =?utf-8?B?SnNUNnliTy9LNTdDdHhJMFkxZ1NSendoUmlROWpxMHZQMHZBVU9CMno3K3lk?=
 =?utf-8?B?cXRVQ2NQUFZlY09MVXMxR1NKWWl6TjBXUUZRbTdyTlM1MHJZUWRzNVp2c0Jx?=
 =?utf-8?B?UFR5RDdhTHBkeGd1akRmb3N1ZHVKVDZHd1RpL2N1enVoN1RyMDRpaTNFVXF3?=
 =?utf-8?B?RlNpUWVtcmtTWUtLV2cyU0Q5VVpqREsyNndxZ3VMZk1JejNodzZKY1c3a0lY?=
 =?utf-8?B?MWM5dWk4QWxuVmNsUkNmZStJNXFpUXdBRUJ2OC9FQVIwOXJlZlZ4YllFeWU5?=
 =?utf-8?B?Q0hPajRxSE9RVzlrRUxBcWI2YjRNNC9lUVpFejFrUHdHUjFYZEg0OGdlL0lC?=
 =?utf-8?B?K2JNcTVCZytxUW1IZGZ2MTQ0VlFrUit4Y2VhOU1OWDlQR0NuU3dPK1Z3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1FGZWpYQWVVbjA4ckxMZGlOZHdYQkNvQlc2S0NvUkJjQkQ3WkxWaFhSL0Fh?=
 =?utf-8?B?SklNSmx5WG5HM3p5MDlMR3I5MU5lYnFWa1BWdUtzb0Nzem1ibHhKMnM0Sk9Q?=
 =?utf-8?B?dDMxc24yamlTWmo4UStUOVFMcHJEYTUrdnEyb3N2NFNwQ1BuV0hUOG9Pa2Fi?=
 =?utf-8?B?Vk9UbnB3NVBYNUpETENOWkRQODhVMCtjMThrcGN2SWFicmRMWUREeVpsVDFw?=
 =?utf-8?B?V1JVN0FLdmRGM1dWMW02SnVCTlp2b2N6RE8zWjl0Y0Fodnk2ellBbGNSYnRF?=
 =?utf-8?B?bmI2bXhYUG5Fems4ZGxtTzlGMDIyb0o5RVdjRjh3N2d5bDNmSnNodHJNbWl4?=
 =?utf-8?B?QkgwSklrT3hEaUhTZnBsVUNxYjRzZXk1VXZoZmJtSTNsN2hUbEhqQlFITk5R?=
 =?utf-8?B?RDZCV1AwNWpnT2VaM0ZNbDkvWVZBZW1LMkNYUy83TjNCeFNzMFNYNnE2bndG?=
 =?utf-8?B?S1FLY29rakVNTzNwVDZDVTAwUFg1T1l5aHlwcWpUK3pCeEFqZjlFY0tsQ0dI?=
 =?utf-8?B?NzloT0EyZmZmYlFtS3h6dVcvRW9CYzZ2dHczcTF2MHl1WHlEUGlOZTFFeU1P?=
 =?utf-8?B?VjMvWndBTzFDVmdrMHczTkNKOXJFTDVIMVp1RVZuTzVhZmYrRXErTklXd0hO?=
 =?utf-8?B?dFJHS2FPM0o1ODlmRFdzMmh4YmtnQSszR21WdlRsWGI5SVN1TXVneUR4T0lN?=
 =?utf-8?B?T3A3a1hQSWpOYnZtQ3R5bVMySnFEYVFOSm4vWUh2RUtTWEQ4VHltWkdRcGc3?=
 =?utf-8?B?UW93d1EyMldhcTcxT3o5L1Z3MHAxNUpHaGdaWGhNdFFleHRJbnQwMVRDM1Mv?=
 =?utf-8?B?VUk0cTFxT3FQUGg2UU5LK25UblAza25RbkxPNG1jMytVSVVoRndIYkU1SEYx?=
 =?utf-8?B?QkNIaWxkd3FGMDNlNGs4eUpUaVI3T1BmWWFISERpNlB5eURNZFV1U1owZFYy?=
 =?utf-8?B?WmpxaTdmaWNxWktoNFIrcHFuR2krUkJWRkdvNkNyNjZ4L3A5V1MyekNocVJK?=
 =?utf-8?B?TmtON0NjZitER01JUlh1YXkyVm5sZkZ5NnlmOW4zOGVTZTNrRHdmR1E2Zjhv?=
 =?utf-8?B?c1F2Y3FGS1VNdGNhM1V0UE9lek9zalI5SU5OOU5hbnJmWnZkZlZBc1ZUemlj?=
 =?utf-8?B?K1lIZDVYUndrY09LWldEd0RvNURSc1F5bFU4WUpOOVdHSWVaYnlsUUFTa0dI?=
 =?utf-8?B?ZkUvaEY1dWtCeEVDR3k2cDRIQi9GMDhwR3M4VmNIdnF4ckwyNzBObE5MRmdT?=
 =?utf-8?B?V2dhSlgrYkF2cGM5WkJtdzRlcmV2SUw5cHhkUktNRVVvQ1FVMFJZLzJvcm0y?=
 =?utf-8?B?MFFTVnA2Z0p2K1Rpb2NPbnRYK1JxNkQ2SENvZWxUcTVoZzBOc0pGOFBuZ0tT?=
 =?utf-8?B?N1g4NmgxY0VEajVnekpzS25FeE5jc3IrSjd0anFKdjhNc1lQU28yOTEwUlVY?=
 =?utf-8?B?eEI5QnhNVWIycEgxS0NURzFpQThuUVNheHJkZ3cwM0RYbklQVUM1RTkzOWZ5?=
 =?utf-8?B?cTRzOXRwbk9zL0hjZGhWMjRXVmZlYTF3aVFwWUFaa1o5d0NrdUViNUxVK2hi?=
 =?utf-8?B?ZkNsb2oydkxTbkxLTzNIckhrQTVNQnVKTThwNDBKTmFxTDlSbm9NZWZLeUcw?=
 =?utf-8?B?U3pnaVFlRUJycmg5MzAvRjRNanZzMXhveFJ0Nyt2OGtza01ZTXd1Q1hSMUUy?=
 =?utf-8?B?VE5tWE5CUHV5MkNkMG1yblZYSWdTR1JzL3JRaU0rNUlZOUxSR2JBOC9rR3Bh?=
 =?utf-8?B?WC9VZ1l6LzQvaUthNDVISDVaSm5PL0RlbUFGUFYzS1pidHdIeTVVdWduV09O?=
 =?utf-8?B?TVhoZWwvdHl4K1E0VEZkNk5lQThjSTF1SUJMbWZLZkNzc3ZxeWRQYU5DMzhW?=
 =?utf-8?B?VFcyVTBkc05oelBVb0NYSXRObXpWME8wMGxUajcwRWduVVBXcmduLzJsQ0VG?=
 =?utf-8?B?NzNBUlF4dHc4M3laNlpaQ2tZcWlXWk9rRlJwNVFmRTlpMUhwMlhhWW1EcCtH?=
 =?utf-8?B?QWhaV2IrTk9vc1dTMVhyM2QyMU1meDkrZkNXTmU2dWljc3g3c09ZUkNtZFNm?=
 =?utf-8?B?TlFyckp6aGllNW1lWkhZSWZtdm84dERtOW1MekVGcVEzSXJiUlJ3bGhPc01v?=
 =?utf-8?Q?Uv7hr/+F41+Mlt3CrGYkqsAre?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB259DBED89DB34DABF6793853252C5A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b34aa1e8-cdcd-455c-b9e6-08dc76fd4459
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2024 05:42:12.5233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AE0kw286O194FtEyWJO1boxrmx877/s5sOoar0OJHEXyE2dOKsIPTdAe1KhuQTuQ9VoN9Dcqd6gBr2ThEfo4KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7346
X-OriginatorOrg: intel.com

PiANCj4gPiA+IA0KPiA+ID4gICAgICAvKiBBZGQgbmV3IG1lbWJlcnMgKi8NCj4gPiA+IA0KPiA+
ID4gICAgICAvKiBJbmRpY2F0ZXMgd2hpY2ggUFQgdG8gd2Fsay4gKi8NCj4gPiA+ICAgICAgYm9v
bCBtaXJyb3JlZF9wdDsNCj4gPiANCj4gPiBJIGRvbid0IHRoaW5rIHlvdSBuZWVkIHRoaXM/ICBJ
dCdzIG9ubHkgdXNlZCB0byBzZWxlY3QgdGhlIHJvb3QgZm9yIHBhZ2UNCj4gPiB0YWJsZSB3YWxr
LiAgT25jZSBpdCdzIGRvbmUsIHdlIGFscmVhZHkgaGF2ZSB0aGUgQHNwdGVwIHRvIG9wZXJhdGUg
b24uDQo+ID4gDQo+ID4gQW5kIEkgdGhpbmsgeW91IGNhbiBqdXN0IGdldCBAbWlycm9yZWRfcHQg
ZnJvbSB0aGUgc3B0ZXA6DQo+ID4gDQo+ID4gCW1pcnJvcmVkX3B0ID0gc3B0ZXBfdG9fc3Aoc3B0
ZXApLT5yb2xlLm1pcnJvcmVkX3B0Ow0KPiA+IA0KPiA+IEluc3RlYWQsIEkgdGhpbmsgd2Ugc2hv
dWxkIGtlZXAgdGhlIEBpc19wcml2YXRlIHRvIGluZGljYXRlIHdoZXRoZXIgdGhlIEdGTg0KPiA+
IGlzIHByaXZhdGUgb3Igbm90LCB3aGljaCBzaG91bGQgYmUgZGlzdGluZ3Vpc2hlZCB3aXRoICdt
aXJyb3JlZF9wdCcsIHdoaWNoDQo+ID4gdGhlIHJvb3QgcGFnZSB0YWJsZSAoYW5kIHRoZSBAc3B0
ZXApIGFscmVhZHkgcmVmbGVjdHMuDQo+ID4gDQo+ID4gT2YgY291cnNlIGlmIHRoZSBAcm9vdC9A
c3B0ZXAgaXMgbWlycm9yZWRfcHQsIHRoZSBpc19wcml2YXRlIHNob3VsZCBiZQ0KPiA+IGFsd2F5
cyB0cnVlLCBsaWtlOg0KPiA+IA0KPiA+IAlXQVJOX09OX09OQ0Uoc3B0ZXBfdG9fc3Aoc3B0ZXAp
LT5yb2xlLmlzX21pcnJvcmVkX3B0DQo+ID4gCQkJJiYgIWlzX3ByaXZhdGUpOw0KPiA+IA0KPiA+
IEFtIEkgbWlzc2luZyBhbnl0aGluZz8NCj4gDQo+IFlvdSBzYWlkIGl0IG5vdCBjb3JyZWN0IHRv
IHVzZSByb2xlLiBTbyBJIHRyaWVkIHRvIGZpbmQgYSB3YXkgdG8gcGFzcyBkb3duDQo+IGlzX21p
cnJvcmVkIGFuZCBhdm9pZCB0byB1c2Ugcm9sZS4NCj4gDQo+IERpZCB5b3UgY2hhbmdlIHlvdXIg
bWluZD8gb3IgeW91J3JlIGZpbmUgd2l0aCBuZXcgbmFtZSBpc19taXJyb3JlZD8NCj4gDQo+IGh0
dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS80YmExOGU0ZS01OTcxLTQ2ODMtODJlYi02M2M5ODVl
OThlNmJAaW50ZWwuY29tLw0KPiAgID4gSSBkb24ndCB0aGluayB1c2luZyBrdm1fbW11X3BhZ2Uu
cm9sZSBpcyBjb3JyZWN0Lg0KPiANCj4gDQoNCk5vLiAgSSBtZWFudCAidXNpbmcga3ZtX21tdV9w
YWdlLnJvbGUubWlycm9yZWRfcHQgdG8gZGV0ZXJtaW5lIHdoZXRoZXIgdG8NCmludm9rZSBrdm1f
eDg2X29wczo6eHhfcHJpdmF0ZV9zcHQoKSIgaXMgbm90IGNvcnJlY3QuICBJbnN0ZWFkLCB3ZSBz
aG91bGQNCnVzZSBmYXVsdC0+aXNfcHJpdmF0ZSB0byBkZXRlcm1pbmU6DQoNCglpZiAoZmF1bHQt
PmlzX3ByaXZhdGUgJiYga3ZtX3g4Nl9vcHM6Onh4X3ByaXZhdGVfc3B0KCkpDQoJCWt2bV94ODZf
b3BzOjp4eF9wcml2YXRlX3NwdGUoKTsNCgllbHNlDQoJCS8vIG5vcm1hbCBURFAgTU1VIG9wZXJh
dGlvbg0KDQpUaGUgcmVhc29uIGlzIHRoaXMgcGF0dGVybiB3b3JrcyBub3QganVzdCBmb3IgVERY
LCBidXQgYWxzbyBmb3IgU05QIChhbmQNClNXX1BST1RFQ1RFRF9WTSkgaWYgdGhleSBldmVyIG5l
ZWQgc3BlY2lmaWMgcGFnZSB0YWJsZSBvcHMuDQoNCldoZXRoZXIgd2UgYXJlIG9wZXJhdGluZyBv
biB0aGUgbWlycm9yZWQgcGFnZSB0YWJsZSBvciBub3QgZG9lc24ndCBtYXR0ZXIsDQpiZWNhdXNl
IHdlIGhhdmUgYWxyZWFkeSBzZWxlY3RlZCB0aGUgcm9vdCBwYWdlIHRhYmxlIGF0IHRoZSBiZWdp
bm5pbmcgb2YNCmt2bV90ZHBfbW11X21hcCgpIGJhc2VkIG9uIHdoZXRoZXIgdGhlIFZNIG5lZWRz
IHRvIHVzZSBtaXJyb3JlZCBwdCBmb3INCnByaXZhdGUgbWFwcGluZzoNCg0KDQoJYm9vbCBtaXJy
b3JlZF9wdCA9IGZhdWx0LT5pc19wcml2YXRlICYmIGt2bV91c2VfbWlycm9yZWRfcHQoa3ZtKTsN
Cg0KCXRkcF9tbXVfZm9yX2VhY2hfcHRlKGl0ZXIsIG1tdSwgbWlycm9yZWRfcHQsIHJhd19nZm4s
IHJhd19nZm4gKw0KMSkgDQoJew0KCQkuLi4NCgl9DQoNCiNkZWZpbmUgdGRwX21tdV9mb3JfZWFj
aF9wdGUoX2l0ZXIsIF9tbXUsIF9taXJyb3JlZF9wdCwgX3N0YXJ0LCBfZW5kKSAgIFwNCiAgICAg
ICAgZm9yX2VhY2hfdGRwX3B0ZShfaXRlciwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFwNCiAgICAgICAgICAgICAgICAgcm9vdF90b19zcCgoX21pcnJvcmVkX3B0KSA/
IF9tbXUtPnByaXZhdGVfcm9vdF9ocGEgOiAgIFwNCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgX21tdS0+cm9vdC5ocGEpLCAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAg
ICAgICAgICBfc3RhcnQsIF9lbmQpDQoNCklmIHlvdSBzb21laG93IG5lZWRzIHRoZSBtaXJyb3Jl
ZF9wdCBpbiBsYXRlciB0aW1lIHdoZW4gaGFuZGxpbmcgdGhlIHBhZ2UNCmZhdWx0LCB5b3UgZG9u
J3QgbmVlZCBhbm90aGVyICJtaXJyb3JlZF9wdCIgaW4gdGRwX2l0ZXIsIGJlY2F1c2UgeW91IGNh
bg0KZWFzaWx5IGdldCBpdCBmcm9tIHRoZSBzcHRlcCAob3IganVzdCBnZXQgZnJvbSB0aGUgcm9v
dCk6DQoNCgltaXJyb3JlZF9wdCA9IHNwdGVwX3RvX3NwKHNwdGVwKS0+cm9sZS5taXJyb3JlZF9w
dDsNCg0KV2hhdCB3ZSByZWFsbHkgbmVlZCB0byBwYXNzIGluIGlzIHRoZSBmYXVsdC0+aXNfcHJp
dmF0ZSwgYmVjYXVzZSB3ZSBhcmUNCm5vdCBhYmxlIHRvIGdldCB3aGV0aGVyIGEgR1BOIGlzIHBy
aXZhdGUgYmFzZWQgb24ga3ZtX3NoYXJlZF9nZm5fbWFzaygpDQpmb3IgU05QIGFuZCBTV19QUk9U
RUNURURfVk0uDQoNClNpbmNlIHRoZSBjdXJyZW50IEtWTSBjb2RlIG9ubHkgbWFpbmx5IHBhc3Nl
cyB0aGUgQGt2bSBhbmQgdGhlIEBpdGVyIGZvcg0KbWFueSBURFAgTU1VIGZ1bmN0aW9ucyBsaWtl
IHRkcF9tbXVfc2V0X3NwdGVfYXRvbWljKCksIHRoZSBlYXNpZXN0IHdheSB0bw0KY29udmVyeSB0
aGUgZmF1bHQtPmlzX3ByaXZhdGUgaXMgdG8gYWRkIGEgbmV3ICdpc19wcml2YXRlJyAob3IgZXZl
bg0KYmV0dGVyLCAnaXNfcHJpdmF0ZV9ncGEnIHRvIGJlIG1vcmUgcHJlY2lzZWx5KSB0byB0ZHBf
aXRlci4NCg0KT3RoZXJ3aXNlLCB3ZSBlaXRoZXIgbmVlZCB0byBleHBsaWNpdGx5IHBhc3MgdGhl
IGVudGlyZSBAZmF1bHQgKHdoaWNoDQptaWdodCBub3QgYmUgYSwgb3IgQGlzX3ByaXZhdGVfZ3Bh
Lg0KDQpPciBwZXJoYXBzIEkgYW0gbWlzc2luZyBhbnl0aGluZz8NCg==

