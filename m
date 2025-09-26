Return-Path: <kvm+bounces-58910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BCFCBA565A
	for <lists+kvm@lfdr.de>; Sat, 27 Sep 2025 01:47:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 327AB1C07DF7
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 23:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162742BE7D6;
	Fri, 26 Sep 2025 23:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GSbe2zwn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8CF86359;
	Fri, 26 Sep 2025 23:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758930455; cv=fail; b=k57vf2AyCPIDecdPNSLdJEFWTP7zp4ENXxF5nexwvlv4dDSWqDQc7KQh3wZn3e5AzLEpi+03a38NqSN7G9CT846CEc9jur4brTmU6tYa8UQV/dn1cQWtSnErjW9Hgih0jB99f1S9UYqsWknZMNp2Fc2J+07f0E+6LrozGvkBdQ4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758930455; c=relaxed/simple;
	bh=N4YiDf6jjgtPsdrYu5GLKlO8QKXI7FAvcZGt7BtpUGM=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YYLCcOi4yMr/hAj8snW3gtdB4+S03DsiR2a8nJh8MKgltTgce1UTWHr+T8ktstMLhNB/OAOYrB+akWWbAMt/4tqrcb7SYP1vaG8xNJjlkM0JqhSI5wdo7riRPfCZJONEaDCWFoLg/GQQakhDIzwHLAtF/F4uSjmv5Ly3z8cJC7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GSbe2zwn; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758930454; x=1790466454;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=N4YiDf6jjgtPsdrYu5GLKlO8QKXI7FAvcZGt7BtpUGM=;
  b=GSbe2zwnQ4v0g2cmeRrRWmGQeCYm1b5CagAtKOqYZHkw01wWI1Zicltv
   Og3dH27S+wyv51Dm1DrSYUk532yRPsmvo9FWpf9OzBQb7PQBuHh6cqYCI
   fNtLcY7Bqy7MTiYT6O0us6OQMX3f68Xjn9JFAo6s/ZQ5BrW7reb6Xuxxh
   mWTX0dgGH/ufkflm2EijI7ahg1+0O+oQGYHXwRgBJ3a2fc18i+HHLotVN
   IJL8L5OmycNrqMLWNL/xkS2+V6G3mur6KD9Nz2XZTTmErFmMq24yGA3SL
   BFil0ohc7PximMTfQaZHniHTunOve/aPIFnPF+GaN947yvBej6hEJDMLw
   Q==;
X-CSE-ConnectionGUID: qgVviaOMQdqT/i+p89mK2g==
X-CSE-MsgGUID: PtKOPpkZS46IAsWPmBBwTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="72362129"
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="72362129"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 16:47:33 -0700
X-CSE-ConnectionGUID: ppXzbdUMR5a9SPjJbvkZdA==
X-CSE-MsgGUID: kZNGnKQlQKKjH3MjHh6OlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,296,1751266800"; 
   d="scan'208";a="177011137"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2025 16:47:32 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 16:47:31 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 26 Sep 2025 16:47:31 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.3) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 26 Sep 2025 16:47:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ouNb+lIF+7Xsg67S1vjCCogFRoR2rqh8tp2OhF8swfpf8ALEn2J7haxSx0OBD6Q49RAWjMdB/oAOuLBXkpl3WDFf1dcvA3RnOfmx4xtpl/QDnd27E5ARxTTqTzQHMu7L/mz6taUiHMQjLs/2Q7yaT8dGwd77RNZ3m22Qqi0Fm2v0/DPsBKSQ5jhI6PaplC92hb6JgMVrJwIMIF/jvHiivTtknrEMSyQeuepVWjdsnbdVzijb8rhzLxEvIBdT2u2F299mEqOhCrw1qtgzDubniuMNoXFASmjEkYZQ28l6z4xaeKMXSfpIIzP2U3AHHkdyfOHYi9GJEI32MQYk0/IFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4YiDf6jjgtPsdrYu5GLKlO8QKXI7FAvcZGt7BtpUGM=;
 b=JeSeI4lv1ys40TQdJvobNmx4zwB/+vg9SSJ5Wt4p/79JhFicaLSbMuf4FXsuvSbuKqaTqYu5xYAF6gx/GmzqDKj7T1PnHhuNzEXPppyGBRwhoHZoYtxr0fVj9O6OXIlN/9Jy0eRmyZq8Pvx7658I7gdocAcosxDJt855aVdljk4Pc1MZkKCEVULWCR9wUIfNq1BuB2DkC1H4TqvRwV1rNBxaMC9xtAbWmY5gU1SEJ48Un+1DpIolo6VtPnEjBgRJ/eIQ10+64/Jqj6+QU8ULhfnYECBuvOuKnitw+N/PPlwONwW7ZRZiY9DP/waaINhc9nHzzzt6/muM8X/LoYvSsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7801.namprd11.prod.outlook.com (2603:10b6:8:f2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.10; Fri, 26 Sep
 2025 23:47:17 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 23:47:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcKPM47wNFJAdMMkCLNWN+W5B0ObSfFAkAgAcZw4A=
Date: Fri, 26 Sep 2025 23:47:16 +0000
Message-ID: <f1209625a68d5abd58b7f4063c109d663b318a40.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
	 <9e72261602bdab914cf7ff6f7cb921e35385136e.camel@intel.com>
In-Reply-To: <9e72261602bdab914cf7ff6f7cb921e35385136e.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7801:EE_
x-ms-office365-filtering-correlation-id: c26f6f7d-ab7d-435b-9f12-08ddfd570608
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?YlI5Y2tVb0ZHZXRrV2NDU0RwYTBqRUtzdlF0d25lZWpLNWM5L3NDdmZLQitp?=
 =?utf-8?B?QWsrenhkN28yZUpZQkZ2N3VhNVN2M1M1TjZ5SVdpNm1lb0VhWEg0bmpFcTBl?=
 =?utf-8?B?WVJka1lvWTMvODBTWDViSXJYakMrZ0Z5cEdvaGc2Tzc5aXdZcFBPM3F0MEVT?=
 =?utf-8?B?VFViOWVRWG5YaFVCUHF2MnJVRkxwbGJoRzRpdzFSTHlBMks0TS9wRURrT2Y4?=
 =?utf-8?B?dlZYNGg4TTJyZ2xVSmN1YlZZVUM1aWVvK1RyWDlhbmdOR1NlY3E4UFhCRUJM?=
 =?utf-8?B?Y1RqQkZEVVQvSVhmN2F5QS9YdmdONjRqenhVU1NmQyt5ODh6bWx5ZVpRZkth?=
 =?utf-8?B?d1diWFFGWmdpcDdkcnZVVmxuVmtEN0EzczZqMXZQS000M2E1bmx2ZVE3YXcx?=
 =?utf-8?B?Vmh1VldOWDM0SDZQYWJDdGNoR09sTGJhTy9LbWpSNnROQ2piS1FESWc1clZN?=
 =?utf-8?B?VDJRa3FRbTdCclhrTWR6RTVvbGlMV1hkVk93K3kwNFBzRXZ6d2VYdGtUYTda?=
 =?utf-8?B?SFFPaXhRL1NhcTRXbkZtVjkyVkpXQlVXU0U4bUdxNjdyN2FpRGFqcHFudm5j?=
 =?utf-8?B?dEFDWFVJdTRWMTErREx4amg4Q0UySGltV0drc29wZzZhdmpPV0d3M293dERZ?=
 =?utf-8?B?ZmVKNWFucFRRQ3d2VU9UK09HeW1ISG5xa1RoeWJtSVV0UEpadzdXZHFsMkpZ?=
 =?utf-8?B?NHJtQXdYTGt4MHNCYTczWEZCNnA2bWFKdG1Ydkh5K0RIS1ZHMUl4SjN1Tm9S?=
 =?utf-8?B?bkpmM1pYODhwWjBVbGtjR2ZpOG9VVXh5R3N6aFh6YzU4d1UyS2docUhLV3BP?=
 =?utf-8?B?Rkx6Mkt5UTlLbHN5QktHSndxWDFGTmxqa01hRFBnY29WOE9TT0x4YkkvOFYx?=
 =?utf-8?B?NFF3dkNpYnJxZldVbC9QNXFjTkNENzU3bGFocnQwenBIZ1pWMXpscm8zS2tL?=
 =?utf-8?B?Z05RVDRQbkJKaGh5Wkk1NEpPcEsxWmRiNzBjb0dQTSsyNWxmZG1MRTRET0pE?=
 =?utf-8?B?TTliQndYRVBQNGFpUE9DMkdpVzBZNXZ5RnlQLzZ1Vno2UkVqRWxNSHA0eTZR?=
 =?utf-8?B?andZclU1ekZXbEsrMFVRejlCUXBFYzVQRWoyenYweFNvRk52THcyRG9nd2JX?=
 =?utf-8?B?RGJoWFdVUGFNTUU0MUhTTmNrSGxLNGtxZldicGh4endGUTdzUldhUDR2N0Zw?=
 =?utf-8?B?R0ZFTURqbXhFbmNsSmxvTWpyckg2bkNjcDdxb1lDWEJvQmlCRlYzNDc0K1o4?=
 =?utf-8?B?bEEwanJIQkxBZmszUlFFSGdENmxoZEFNOTZrSWVxVjhGRzhGVHBTWjdtS1RS?=
 =?utf-8?B?ZTJkR2dPNFYwNWVVdFJNdGkwWkc2WmpNVlhCa3ZOSU5yRTlOMU83N0xWdEVa?=
 =?utf-8?B?clExU1J1K3lxb0NnUWtVNGtHZHZibDFWMW1aV0R6R1NyNzIxckdrRVlDa05p?=
 =?utf-8?B?bHNnamtkSjZrWHdXY3Z1TzF1dE0yanJtWlZtTkFua3daZnNqajdmSTlIbm5M?=
 =?utf-8?B?bTdxNFowN2NMY1N2UGMzMUdjWXoxN2N5Tzl1NnRmUkxpV1NqdkUyOHl6b2VZ?=
 =?utf-8?B?cmZ0VVIxUUVvNnZIeHJKZ0pqMDJaWlpkMmlnMnk0YzJTVVFFVk5MbEg1VEZ5?=
 =?utf-8?B?Zjd5RXpDVjQ1RlRLZ0VHQkxGSjRCUUIxVFVUdW1yNTBWc0hyTUNtWFpZRTJP?=
 =?utf-8?B?QlZwUGxzNXEyVDlNWXFLTFBkbVE0aTJPbzFNb2QzcTdNNTYybDRlbFAvNlNB?=
 =?utf-8?B?THFvQXk3VXZVZHEvRi96Si83NWlhSXdVRXQrUUtOdjNFMmg0WXdIb1NPbVp6?=
 =?utf-8?B?V0ZSU1lnbDUvcXQvc0o2QVUzVWxFTnRBTEFQdXNYL0dZbU1iRTkzeHdvbW5S?=
 =?utf-8?B?QVNoM2pZNys4NzYxdjVyK0FHNU0zRUJ5VVB4a0NRWUhySVYrS3g2QWtielI3?=
 =?utf-8?B?OXQrV3dlTjByU2YrREUzNmZ4TnRwOGJkVG4rL2cvUCtkSUcvUHdtbllpMFBh?=
 =?utf-8?B?dy82Y2ZDL3J6c2FUcldRaS9ZcVV6UnhuS0V3RDM0TmVYZytEUENUc0hmZXox?=
 =?utf-8?B?WUs0Yll3dUZMY2VQOFQvZGlyREJvL0R2RlNRUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVJFT0JwUGJDTm9uOTlBLzQ4aDk2MWp4TU5ZdXZOTERKSnVnLzBIbXMxbUdD?=
 =?utf-8?B?clloQUpXYVB5Sjh1M2sxc1pjVWtlRWdkL3NJQ0VkYmZ1TWh6d1RTL016NWRl?=
 =?utf-8?B?OWJsbXd2eXFTK2N1eFN3Qno2T1hOS3BtWXFKbnlaMVFBY1RCZXNYTk95a3VX?=
 =?utf-8?B?RzB2emhaUi9NcmN5ajc3Z2ZYNHp0Z3lKd25yb3ZpZ3VTcFhmS1FCVWJGRjZS?=
 =?utf-8?B?dTd0d2szNTE5UUtnS0s2NG9LdGJZWVVQUTF4VWd3U2tVRGVKRDBrZDZWVm5h?=
 =?utf-8?B?d1JhWS9uc3pocWFpU0QwdWRad0dOUWkwOEdoZGtrMVhJck9NOEZscjhTUGJN?=
 =?utf-8?B?RWduY2E3aDhScU11TEp1emQwd1VXOEthSEdIanZUazJSSFk3STdzeldIWEhx?=
 =?utf-8?B?eVZ3VEtESTd2Q3JtTUVPU2NMbklKRkU0eGsyVE5aR0pYdFM1MWtiY3V3b2xU?=
 =?utf-8?B?M1kxVXpkTTJma2pQZzAwTHZtM1B6RW95L0dacFV1T2lVYmFLMWFoNjkrZTY0?=
 =?utf-8?B?Vmw0S1g5ZDl5UnUzUnpuOWFmYWNEcUw4NnluWWJIUEUzWWh0c2pibWlYNUNF?=
 =?utf-8?B?Z2c3NjhTcU1MeCtoSTduNEt5MDFEM0VmWnZjc1N4TUkwM3E0NFBoUjFIVmNn?=
 =?utf-8?B?Qk1ybnhLY3UzWWNQTmhNVXlQZ3RMTUNNc2lRaE52SU9iOGpySTR3MGlDUFRp?=
 =?utf-8?B?UFZhT3pIWCtSQk1BbkVLeHRGQkU5UzE0UlFmT1NmWmdWTENoc2JJUythZ1hV?=
 =?utf-8?B?NTBML2U0Tm15OHRFZ0UveWNMblVia1ZWZUZYYjYzcVJxbVV4OC8rTU90Q1ow?=
 =?utf-8?B?bXNTL2hZU1NCSjFGYlVHcDM0WVA5cW9ybEVyZlN3N004bHFON2VZQ3E1QUh1?=
 =?utf-8?B?eTJ5YWpacXBnc1NPL0x4N0ZkcmJkYlRXdEJwY0l6anBoalV5b2xDQU1ScHM0?=
 =?utf-8?B?Mmk2SUR1YmNuRWNIVzY4VGlzME1OZStTRjg0d01MeUVKcDI5c1ZJYndLRzNp?=
 =?utf-8?B?Z2FTemVuYjg4UWV0RmRnV0lKQitQSEgxMWR6NVVZVm5adGkxUXVmRjB1UDdq?=
 =?utf-8?B?V2ZkendCM2FvTEdWV0VaQk9XRnZkOHBocHFyZGs4V1hFZWtDMVFxNUZkVW1C?=
 =?utf-8?B?cnMrWDdQRjQvZGhaQTVvUnpvSlRkMFJ5aHNnSTJsc2RydXNxUUdzUGpmNWJB?=
 =?utf-8?B?azR3Zk5uaXc4SnA0VGtsTk40Z1BwZ250d0hwSzIrY1IyYWdpeFNWZWZmeEhO?=
 =?utf-8?B?eUJ5VlRjcGxIR3pNQUlNQkVZaVh5TC85dnJZLzgvNHpyeU5HT0tJeFB3aTBk?=
 =?utf-8?B?TnhoY3BqR3FqTjZVVG9HL0ZvbkNPc2ZXck5oOWFiS29nRjNnVEZOUENUMWRr?=
 =?utf-8?B?VzNIdHJ2a014Z3B2RjlJSjlDazhJSHVyOWRRNHVJL25xV3F2cXZoUWJYNzJB?=
 =?utf-8?B?SUV6MHFzeUJCMlA4cDAzNSt5QmgvYmt4TzUzMnN2ZWFaTTUyaEk0RzJxVlFl?=
 =?utf-8?B?V1JYL1VtQnNVZTd6TEQrNGV2Ky9LSkFCVmV4RVAzNW9XLzRDMXdreW9SdlJn?=
 =?utf-8?B?T0dZSStjUCtrSVpBb2Ftc1Z6S2hYaExqNThhREJ4TkFLZmhTUi8wRkwrNksw?=
 =?utf-8?B?eVIzVmoycjlyaEJ0bmYyN0lnS2wyMnpHZjlBMHRmQUYwbDJQTktiYk9qVDZr?=
 =?utf-8?B?WFlxSUNncFBvUjhJVGpzRGVQb0JPQVA1NlhrQzc2K20rODVMRkhWLytubHJm?=
 =?utf-8?B?WHRxV0tXK0NnWVFEbitZc1hkR3RzMDVOZ0F3eWsrVDZTdlJRQkozeVI3UlNU?=
 =?utf-8?B?WDcyOHdGZDZaOW9sWGwrWVIvK3J1YnRGZDlnZlpFRXVQdzVlVDdpcWJITER4?=
 =?utf-8?B?bnVPZ1lVWFYrYTJsYU5xQjY5T0xTalNGZUhtdll2bkgrSmJBUjBaREdaSzV6?=
 =?utf-8?B?TzZ2VGdwazZLQjFHSWhMNEVqYi9OczFPWE0wMTArZitiVDR5bGJPRWVzMVJT?=
 =?utf-8?B?dWFMRWZla2hlenVkak4zcHhjK1FXMS9KVUJUUm8vRFo2M2JYYWRjOCtVcXhq?=
 =?utf-8?B?NnBoeUcveFZTeWhub2JLdVpjaENWbGo4OTRaRUpkMGxJZFBJY1YvTG5TdEJm?=
 =?utf-8?B?emhHS0tuVS9uT2MwT1RjNWZxd0Y0QjdZZFQyNUV0S2RBaWc2Vy9BMGs2TVFj?=
 =?utf-8?Q?1uX2RjdSgz9MBFyynf9GvCI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62317B1B6C0CB646939488DE52C562A4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c26f6f7d-ab7d-435b-9f12-08ddfd570608
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 23:47:16.1606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PXdOHbqYxd1fJpYUUWr9WRlHbYvUrUnXh04yZNqMDVjuJg2Jv3GWXthPTHpRHwnYKoH6j6AShdvNwTlDQw5pHx7sJsShAw01znfxaFV+Qdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7801
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTIyIGF0IDExOjIwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBT
aW5jZSAnc3RydWN0IHRkeF9wcmVhbGxvYycgcmVwbGFjZXMgdGhlIEtWTSBzdGFuZGFyZCAnc3Ry
dWN0DQo+IGt2bV9tbXVfbWVtb3J5X2NhY2hlJyBmb3IgZXh0ZXJuYWwgcGFnZSB0YWJsZSwgYW5k
IGl0IGlzIGFsbG93ZWQgdG8NCj4gZmFpbCBpbiAidG9wdXAiIG9wZXJhdGlvbiwgd2h5IG5vdCBq
dXN0IGNhbGwgdGR4X2FsbG9jX3BhZ2UoKSB0bw0KPiAidG9wdXAiIHBhZ2UgZm9yIGV4dGVybmFs
IHBhZ2UgdGFibGUgaGVyZT8NCg0KSSBzeW1wYXRoaXplIHdpdGggdGhlIGludHVpdGlvbi4gSXQg
d291bGQgYmUgbmljZSB0byBqdXN0IHByZXANCmV2ZXJ5dGhpbmcgYW5kIHRoZW4gb3BlcmF0ZSBv
biBpdCBsaWtlIG5vcm1hbC4NCg0KV2Ugd2FudCB0aGlzIHRvIG5vdCBoYXZlIHRvIGJlIHRvdGFs
bHkgcmVkb25lIGZvciBodWdlIHBhZ2VzLiBJbiB0aGUNCmh1Z2UgcGFnZXMgY2FzZSwgd2UgY291
bGQgZG8gdGhpcyBhcHByb2FjaCBmb3IgdGhlIHBhZ2UgdGFibGVzLCBidXQgZm9yDQp0aGUgcHJp
dmF0ZSBwYWdlIGl0c2VsZiwgd2UgZG9uJ3Qga25vdyB3aGV0aGVyIHdlIG5lZWQgNEtCIFBBTVQg
YmFja2luZw0Kb3Igbm90LiBTbyB3ZSBkb24ndCBmdWxseSBrbm93IHdoZXRoZXIgYSBURFggcHJp
dmF0ZSBwYWdlIG5lZWRzIFBBTVQNCjRLQiBiYWNraW5nIG9yIG5vdCBiZWZvcmUgdGhlIGZhdWx0
Lg0KDQpTbyB3ZSB3b3VsZCBuZWVkLCBsaWtlLCBzZXBhcmF0ZSBwb29scyBmb3IgcGFnZSB0YWJs
ZXMgYW5kIHByaXZhdGUNCnBhZ2VzLiBPciBzb21ld2F5IHRvIHVud2luZCB0aGUgd3JvbmcgZ3Vl
c3Mgb2Ygc21hbGwgcGFnZS4gQXQgdGhhdA0KcG9pbnQgSSBkb24ndCB0aGluayBpdCdzIHNpbXBs
ZXIuDQoNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgd2UgbmVlZCB0byBrZWVwIGFsbCAiRFBBTVQgcGFn
ZXMiIGluIHRoZSBwb29sLCByaWdodD8NCg0KTm90IHN1cmUgd2hhdCB5b3UgbWVhbiBieSB0aGlz
Lg0KDQo+IA0KPiBJZiB0ZHhfYWxsb2NfcGFnZSgpIHN1Y2NlZWRzLCB0aGVuIHRoZSAiRFBBTVQg
cGFnZXMiIGFyZSBhbHNvDQo+ICJ0b3B1cCJlZCwgYW5kIFBBTVQgZW50cmllcyBmb3IgdGhlIDJN
IHJhbmdlIG9mIHRoZSBTRVBUIHBhZ2UgaXMNCj4gcmVhZHkgdG9vLg0KPiANCj4gVGhpcyBhdCBs
ZWFzdCBhdm9pZHMgaGF2aW5nIHRvIGV4cG9ydCB0ZHhfZHBhbXRfZW50cnlfcGFnZXMoKSwgd2hp
Y2gNCj4gaXMgbm90IG5pY2UgSU1ITy7CoCBBbmQgSSB0aGluayBpdCBzaG91bGQgeWllbGQgc2lt
cGxlciBjb2RlLg0KDQpJIG1lYW4gbGVzcyBleHBvcnRzIGlzIGJldHRlciwgYnV0IEkgZG9uJ3Qg
Zm9sbG93IHdoYXQgaXMgc28gZWdyZWdpb3VzLg0KSXQncyBub3QgY2FsbGVkIGZyb20gY29yZSBL
Vk0gY29kZS4NCg0KPiANCj4gT25lIG1vcmUgdGhpbmtpbmc6DQo+IA0KPiBJIGFsc28gaGF2ZSBi
ZWVuIHRoaW5raW5nIHdoZXRoZXIgd2UgY2FuIGNvbnRpbnVlIHRvIHVzZSB0aGUgS1ZNDQo+IHN0
YW5kYXJkICdzdHJ1Y3Qga3ZtX21tdV9tZW1vcnlfY2FjaGUnIGZvciBTLUVQVCBwYWdlcy7CoCBC
ZWxvdyBpcyBvbmUNCj4gbW9yZSBpZGVhIGZvciB5b3VyIHJlZmVyZW5jZS4NCg0KVGhlIHBvaW50
IG9mIHRoZSBuZXcgc3RydWN0IHdhcyB0byBoYW5kIGl0IHRvIHRoZSBhcmNoL3g4NiBzaWRlIG9m
IHRoZQ0KaG91c2UuIElmIHdlIGRvbid0IG5lZWQgdG8gZG8gdGhhdCwgdGhlbiB5ZXMgd2UgY291
bGQgaGF2ZSBvcHRpb25zLiBBbmQNCkRhdmUgc3VnZ2VzdGVkIGFub3RoZXIgc3RydWN0IHRoYXQg
Y291bGQgYmUgdXNlZCB0byBoYW5kIG9mZiB0aGUgY2FjaGUuDQoNCj4gDQo+IEluIHRoZSBwcmV2
aW91cyBkaXNjdXNzaW9uIEkgdGhpbmsgd2UgY29uY2x1ZGVkIHRoZSAna21lbV9jYWNoZScNCj4g
ZG9lc24ndCB3b3JrIG5pY2VseSB3aXRoIERQQU1UIChkdWUgdG8gdGhlIGN0b3IoKSBjYW5ub3Qg
ZmFpbCBldGMpLsKgDQo+IEFuZCB3aGVuIHdlIGRvbid0IHVzZSAna21lbV9jYWNoZScsIEtWTSBq
dXN0IGNhbGwgX19nZXRfZnJlZV9wYWdlKCkNCj4gdG8gdG9wdXAgb2JqZWN0cy4NCj4gQnV0IHdl
IG5lZWQgdGR4X2FsbG9jX3BhZ2UoKSBmb3IgYWxsb2NhdGlvbiBoZXJlLCBzbyB0aGlzIGlzIHRo
ZQ0KPiBwcm9ibGVtLg0KPiANCj4gSWYgd2UgYWRkIHR3byBjYWxsYmFja3MgZm9yIG9iamVjdCBh
bGxvY2F0aW9uL2ZyZWUgdG8gJ3N0cnVjdA0KPiBrdm1fbW11X21lbW9yeV9jYWNoZScsIHRoZW4g
d2UgY2FuIGhhdmUgcGxhY2UgdG8gaG9vaw0KPiB0ZHhfYWxsb2NfcGFnZSgpLg0KDQprdm1fbW11
X21lbW9yeV9jYWNoZSBoYXMgYSBsb3Qgb2Ygb3B0aW9ucyBhdCB0aGlzIHBvaW50LiBBbGwgd2Ug
cmVhbGx5DQpuZWVkIGlzIGEgbGlzdC4gSSdtIG5vdCBzdXJlIGl0IG1ha2VzIHNlbnNlIHRvIGtl
ZXAgY3JhbW1pbmcgdGhpbmdzDQppbnRvIGl0Pw0KDQo+IA0KPiBTb21ldGhpbmcgbGlrZSB0aGUg
YmVsb3c6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9rdm1fdHlwZXMuaCBiL2lu
Y2x1ZGUvbGludXgva3ZtX3R5cGVzLmgNCj4gaW5kZXggODI3ZWNjMGI3ZTEwLi41ZGJkODA3NzM2
ODkgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgva3ZtX3R5cGVzLmgNCj4gKysrIGIvaW5j
bHVkZS9saW51eC9rdm1fdHlwZXMuaA0KPiBAQCAtODgsNiArODgsOCBAQCBzdHJ1Y3Qga3ZtX21t
dV9tZW1vcnlfY2FjaGUgew0KPiDCoMKgwqDCoMKgwqDCoCBnZnBfdCBnZnBfY3VzdG9tOw0KPiDC
oMKgwqDCoMKgwqDCoCB1NjQgaW5pdF92YWx1ZTsNCj4gwqDCoMKgwqDCoMKgwqAgc3RydWN0IGtt
ZW1fY2FjaGUgKmttZW1fY2FjaGU7DQo+ICvCoMKgwqDCoMKgwqAgdm9pZCooKm9ial9hbGxvYyko
Z2ZwX3QgZ2ZwKTsNCj4gK8KgwqDCoMKgwqDCoCB2b2lkICgqb2JqX2ZyZWUpKHZvaWQgKik7DQo+
IMKgwqDCoMKgwqDCoMKgIGludCBjYXBhY2l0eTsNCj4gwqDCoMKgwqDCoMKgwqAgaW50IG5vYmpz
Ow0KPiDCoMKgwqDCoMKgwqDCoCB2b2lkICoqb2JqZWN0czsNCj4gZGlmZiAtLWdpdCBhL3ZpcnQv
a3ZtL2t2bV9tYWluLmMgYi92aXJ0L2t2bS9rdm1fbWFpbi5jDQo+IGluZGV4IDZjMDdkZDQyMzQ1
OC4uZGYyYzIxMDBkNjU2IDEwMDY0NA0KPiAtLS0gYS92aXJ0L2t2bS9rdm1fbWFpbi5jDQo+ICsr
KyBiL3ZpcnQva3ZtL2t2bV9tYWluLmMNCj4gQEAgLTM1NSw3ICszNTUsMTAgQEAgc3RhdGljIGlu
bGluZSB2b2lkDQo+ICptbXVfbWVtb3J5X2NhY2hlX2FsbG9jX29iaihzdHJ1Y3QNCj4ga3ZtX21t
dV9tZW1vcnlfY2FjaGUgKm1jLA0KPiDCoMKgwqDCoMKgwqDCoCBpZiAobWMtPmttZW1fY2FjaGUp
DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm4ga21lbV9jYWNoZV9hbGxv
YyhtYy0+a21lbV9jYWNoZSwgZ2ZwX2ZsYWdzKTsNCj4gwqANCj4gLcKgwqDCoMKgwqDCoCBwYWdl
ID0gKHZvaWQgKilfX2dldF9mcmVlX3BhZ2UoZ2ZwX2ZsYWdzKTsNCj4gK8KgwqDCoMKgwqDCoCBp
ZiAobWMtPm9ial9hbGxvYykNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcGFnZSA9
IG1jLT5vYmpfYWxsb2MoZ2ZwX2ZsYWdzKTsNCj4gK8KgwqDCoMKgwqDCoCBlbHNlDQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHBhZ2UgPSAodm9pZCAqKV9fZ2V0X2ZyZWVfcGFnZShn
ZnBfZmxhZ3MpOw0KPiDCoMKgwqDCoMKgwqDCoCBpZiAocGFnZSAmJiBtYy0+aW5pdF92YWx1ZSkN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG1lbXNldDY0KHBhZ2UsIG1jLT5pbml0
X3ZhbHVlLCBQQUdFX1NJWkUgLw0KPiBzaXplb2YodTY0KSk7DQo+IMKgwqDCoMKgwqDCoMKgIHJl
dHVybiBwYWdlOw0KPiBAQCAtNDE1LDYgKzQxOCw4IEBAIHZvaWQga3ZtX21tdV9mcmVlX21lbW9y
eV9jYWNoZShzdHJ1Y3QNCj4ga3ZtX21tdV9tZW1vcnlfY2FjaGUgKm1jKQ0KPiDCoMKgwqDCoMKg
wqDCoCB3aGlsZSAobWMtPm5vYmpzKSB7DQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBpZiAobWMtPmttZW1fY2FjaGUpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAga21lbV9jYWNoZV9mcmVlKG1jLT5rbWVtX2NhY2hlLCBtYy0+b2JqZWN0
c1stDQo+IC1tYy0NCj4gPiBub2Jqc10pOw0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBlbHNlIGlmIChtYy0+b2JqX2ZyZWUpDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBtYy0+b2JqX2ZyZWUobWMtPm9iamVjdHNbLS1tYy0+bm9ianNdKTsN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGVsc2UNCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmcmVlX3BhZ2UoKHVuc2lnbmVkIGxvbmcp
bWMtPm9iamVjdHNbLS1tYy0NCj4gPiBub2Jqc10pOw0KPiDCoMKgwqDCoMKgwqDCoCB9DQoNCg==

