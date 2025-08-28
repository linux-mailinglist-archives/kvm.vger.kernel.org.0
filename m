Return-Path: <kvm+bounces-56009-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDD5B3913C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 03:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B25E31C21309
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 01:51:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71B8238C0F;
	Thu, 28 Aug 2025 01:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BQKtX1KN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4961213635E;
	Thu, 28 Aug 2025 01:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756345872; cv=fail; b=ZBpX/lLymF6ltlj0tz3Y1IDsZrmFHRj+ssz/N76JODcT5sk5czbED/b4NDps3R7LdIyerlgctY4aEOKgPAMbCveVOTmxrYEiUEj9KXJQuqLm8MV4yYKmAt/rifl5B4LavJJcw3RgPFUEmbOPL/ISyTXOATkfS7l3WLqtUefZ3eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756345872; c=relaxed/simple;
	bh=LOOorYTMOOWY3HDJKWEt9Gpu52i8Tu0suLhR3A+6RBE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P9Ysl8Gnu9R7XciV3NilQSNOAR7kIIG0IjNtamMFS/yCD0UK9ZyvFFLv3mXdqFY61NJGjRcNbmrmUlSGgg52Sr7+BfWT7l/UNeARHKMU6lLH95xEOXwSodPjU5dIG7cQ/mtm/jnROaJ8q2ntVRzHrwkcwiAgNGHQaQMc6M3yBII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BQKtX1KN; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756345870; x=1787881870;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LOOorYTMOOWY3HDJKWEt9Gpu52i8Tu0suLhR3A+6RBE=;
  b=BQKtX1KN2B4fIKnQSY0OQL1snh7e7/x7Hezl2C0SC01u8JVTotX1DM/Y
   e0nayvjPIV16lkcJqauYcZ5OriuqzNmlYetCIAtpImZollwFqwi1uc9R6
   BaY2MwM+syKdO5Sj2OW6tT8baJt2a0p8Rm0NLODk1gJ2tOCqEtYDfPjcT
   +Xm+STQ43bMJpWvi6l1Rcm3QiLqEuXH97B1NWPnRVVYcA8EUESQx3118k
   3bbD+7D4miCpr23Wks30Sgp8QTvFJixmo6hGg+DGeDFZgKU4DMKxSpXIG
   24qiqyJC7yJNfULc07ndpVgRjP9L4bx242VX9MhhVYJbkeqZnuWGnAFD5
   w==;
X-CSE-ConnectionGUID: AgvvzrI8QuSpyU6fVzMYjQ==
X-CSE-MsgGUID: +unJ5Q+KTlaLgc2ROEyENQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58755564"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58755564"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 18:51:10 -0700
X-CSE-ConnectionGUID: 4JhLkPOlRaGFy2KpQwtxNA==
X-CSE-MsgGUID: U68wjvNiSwWLPh9OrjK+aw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174371149"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 18:51:10 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 18:51:08 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 18:51:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.57) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 18:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVU1sIzyCLXdcIBwOQLrnnLEixWbz15olj2PfP7gz+mSWZIPlZO72DpKXVIXWnU71eTsAW6cTzkIN1xfVRtD5iwoX1ZW1d0kOGtwgBrjwNuKVXTPypv1qz9/tbl4TlnqN2zfIkTElA5Q67FlMkAcBYGD5A5pW+o5ak6mikgyulCa91cxrl5WJbah3s88xuDg1Q5jN62UNIAOh7SSQ7I+syArjMZm8LG/G326E+BO5+pVRX07kyQrpIXcZa48stE84aH/VOHGS/qG/BqPwe6FCEpJwFeFEh9JbU/KKATZfLB40vC9OLt9RMfQAirrs5fUWWNYs0mxdIXKZ8dINEoFlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOOorYTMOOWY3HDJKWEt9Gpu52i8Tu0suLhR3A+6RBE=;
 b=LVTGmQvk2ScqQoSgqXVUD74q9mtIx0u9F2qRzL0MFn6v3q8Iks0AcwuI3R7DUO/ivVTjLsmc0ZmFvZEu4Ar9m2B6GLPsIS+bYkpqGfDLbBhW6quXxPPrRuqfw7fRj3b+7vtzo6A6eHES50taOBmCYS4K0QG6H937iwpXeR5dmeJtZ5ChsJZYxNVfgzhxiQAVoah8i2nZOAJK5wYrdc9NaA0l8LnlLmdNiU2sdt14qWOZtVxSmyE1cfGz27i7UOzh27UYayXvK6jDOVEolPIcb4XMuKpkBhtyZOcmRyGq7aNTPaRBgVb1pkSW/q6uJvzwIudQzsx3P3/WABDxy4qrXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB6832.namprd11.prod.outlook.com (2603:10b6:510:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Thu, 28 Aug
 2025 01:51:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 01:51:06 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Topic: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Index: AQHcFuZRH7A9gjtzDkWLIdW2XN4AQ7R3OuOAgAATvoA=
Date: Thu, 28 Aug 2025 01:51:06 +0000
Message-ID: <a0f42c955d4b86229b9cc200b37963ac24458f76.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-3-seanjc@google.com>
	 <68afa57959dd8_315529471@iweiny-mobl.notmuch>
In-Reply-To: <68afa57959dd8_315529471@iweiny-mobl.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB6832:EE_
x-ms-office365-filtering-correlation-id: 0b5ef125-76db-422a-cb20-08dde5d55a5f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cVZUOS9qZHNjdmZBNFppaHNBRUkzYnROOFhRa0JCY2hHSWNZRWdhb2tGSkRl?=
 =?utf-8?B?d3MxMWNOTitZSHpneFNaNjdwWHhrT2R6aWxEajVGS251Z1Q5eDg5VHM1ZUc1?=
 =?utf-8?B?dEVSVE1BNXhPOFYvS1Y1RXU5VC9WczR6RTFSU3BZT1R1bnZRVkxtU05iTnJx?=
 =?utf-8?B?ZUVRNEwyUXlFbkVWOENJVHNQa2RaNDdNRXZZQitmZXhkTUZSNHk3bHVGZmZJ?=
 =?utf-8?B?WU9PbElEVEVBYitlVjg5R2tiWU5MSjJndzdkODNoeEFSQUhVTzhvTGRvaEtN?=
 =?utf-8?B?ZWphMVBDQStpWktSd2k4Nzl0TXdDR2VpbWdGenNDN3pTWWhlVmd2d1BzWENO?=
 =?utf-8?B?Z0RrT2d6VXFrcEV0K3JUMjZ6TEFMNmlVZ0FtRFE3b1hoZStLWXBPbmM0blNo?=
 =?utf-8?B?dWdZUVN4aTd5TmpDekhhM2EzZ01FdTVxZ2NoNVFRb0VDcTB5enNBRHZ5SHVQ?=
 =?utf-8?B?UWRET2MvdlpicnZjYU9YaGN1QWFPWXVkVHJheVF0ZEwvMUEzclRNaXpXeVZ3?=
 =?utf-8?B?RFpTZ1p3RjBEcHNFTTZCNDYyRFdxdWNFblhtSE5mVTRMdndlK1FYS2lKTEo1?=
 =?utf-8?B?eHBZRVJhRGV3QlJHS0tvRE03M1ZKaURaY21tS3VQTi90WmFrckNKZnIvWVRl?=
 =?utf-8?B?bTRHcEF4R0xTenpBRHhTYmRxZXZCQUpHQWZXb0VvUDltRHJrblMxdFRuazF3?=
 =?utf-8?B?NDZiVm1zM0Y5Z0VlM0dKeHhLR2VYY1kwOGhwcHl3U0NIVk5MQlArYldnUUVC?=
 =?utf-8?B?OVp1aTZxRzFOSitlaUl1K2tVUE0zdXI5alRPVGFtWW82YXVKOTNTQlhWdytS?=
 =?utf-8?B?YkMveXkzZEEycVcrTFpZZEsyREREMlU0d2NBcUtuczMzTDV1VHBReG41ODVt?=
 =?utf-8?B?WGF1VHllK3BUT1MxZmFWbXo0eXJEaVpaSEhMbThWSmZCV2RZUTc5K0pNRmNC?=
 =?utf-8?B?MUF3MHdJdWhMZ2s5Y2JUaXQzcG5vQk41cEc2YVl0K29HTjI0MktHM2publZH?=
 =?utf-8?B?QXBaNC81TzlFMW9NMTZZeSsxQmhxRkNOWlpSTksyMDJBaUdYZGI0dGt2eEI1?=
 =?utf-8?B?U1UwVzV3RHFFUlpzdzR2UGJhUllNK2NNTzhDNjBJd3QvdC9lVHNuL0lCalRl?=
 =?utf-8?B?TGN4czhyWkduZi9BVlhqZ0NYNWU4Y3hvYmI2K1dKaEVXRU5GT0NHOEU0aVVq?=
 =?utf-8?B?WWI4Ynp1YUZ0cElsU1hPU1RJbjMxUlJaaTRpWGhLR2ZQYS9nQ003TEVSTTVl?=
 =?utf-8?B?UndiUFAraHFrTWVWd0hwWWxtS0Y0ekd2NDRIQXIvL012b2VMZ05HSmZTTTM1?=
 =?utf-8?B?akxBUm5xWEJvWEd1WGlKQTVGMWMzK3RzRVNoaEZKVnMyY3dYN2IwNFpkUkta?=
 =?utf-8?B?RDZucnNIWTF1ei9DeGlLS0lIaEFMcHR3Wk1Wb3R3SVhLU241MW1NVUtEOWF0?=
 =?utf-8?B?N1FoK2Q3d2RvK0cvM1dVOFFEZmlreTVRcnZaWUlFTFFiNW9XemlUZDlIT0U4?=
 =?utf-8?B?Rm42Q2pIWGZFMGNnSDQ3aHB1T0xNUVVuVVVIclcrcEhzQ3NnY1d0Q1JNMDRQ?=
 =?utf-8?B?NjJIM0NHQWtXUHJDRXE4NFVLRFhIamVsbFNFR3B6cHJHZzRCOGZiK3IrSElm?=
 =?utf-8?B?VGthTWk1aE1qNGxQMTBvWEdMYmNWWTNJL3ZvMUZtd2JSU24zcTcxOXh1TzY0?=
 =?utf-8?B?QTlXVnBUQ2R0cllveFFWN0RvbWxCNTUybkdwbjA4ZGxwZ3FPQm1oWnlka3dT?=
 =?utf-8?B?S3VONkNkRHNaQlhrMGF0WUNpOVFuaU1yOHFEQmE2QWp1RTJmTlIyVXUxdm12?=
 =?utf-8?B?ak02cXc0aGhzY3NnZktoZ1F4MEh1Vlg0UnFlc1YyZDdNTWZESDY0eUwrcE1M?=
 =?utf-8?B?VU5iL0dWanJnV1FPSTBJQVpmNlJ5dVBJSk1oYmFQMmV1MW55QXVub0N6eHdy?=
 =?utf-8?B?clNja2dFZDR1NnZUdVFncno0Z3JmbitHR2E4NDlSbGpNckljUHp2Wk9ZWDJL?=
 =?utf-8?B?dk5SMW9ZZjNnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEIwMHZwVDBYQ05xWUx6VHBha2FPZEJtSTlLVEhORmRiMVBtTHdMMkoxd2ti?=
 =?utf-8?B?bzkyZzNiQ1VlbjU0L25IREJmZ1BaS3JydmtaWGtwZWk1ZFRRMGo1dWdzNW5p?=
 =?utf-8?B?WVMrdlEzU0hPOTBZZzRCR3U5cFVlM29pODdmNzI4anQyTU5GOTlkN3F1NzJM?=
 =?utf-8?B?RG1aTW1STTNMOXBCQVZubUorMGI4ZzRCbDF0NGhQL0ZTMlVwNGVPcHJodlpv?=
 =?utf-8?B?anQyZ3BabXV2bVhBMXc2aU9lYXhBdzhMWjllcHZLa3phSG5VQ0Nwb2F4Vmc2?=
 =?utf-8?B?NStRRnNkRWN5OHcvRDVkQzBxU0RvSEpOaEtsdXVBYW9yU1lDaGFsZzZILzY0?=
 =?utf-8?B?ZnZMd3VRVTlmblR4aTZhWFMwSUJmQzF2MmNuT3lRV0pKaWpEZUpZSFgwdjF1?=
 =?utf-8?B?dkVKVmRNNElTS1luUGwvSUptaDl4SHhKS2hZWU1YZ2dOa0FtNTFMcGM4bUFG?=
 =?utf-8?B?c21ZVGxObUtLeDVkV2NTNmpQcnBYVm1pWUpLK2htVng3Qmo5VVZ1ZkRxVjQz?=
 =?utf-8?B?bkU0UFA0bFMvRERPNGk2cG4wY3J4Q3B5bGtHdlBYeFpCS0RyT25MZDlDdHB3?=
 =?utf-8?B?MEwyRnVxRjRBSU5sblFKRHAzQXllejZKdGpvRnc3SElMYUw5SmtIZUltRElH?=
 =?utf-8?B?ek1GTUpXM2prTkF5emVtcVJWT1dvRmt0M3lTZXZSNjBRMTRKOVFyaWFvMm96?=
 =?utf-8?B?UFl5djJPK2V1NmRRcy9lOWJWd2pOYjhSaTNLNVYvcm12bU5CVGxrZEMzQlpG?=
 =?utf-8?B?L3VQRGh4RmszZTFLOXdSSzJvVTBaMW5TVXd2OEE2c1dLOXhhcHpsRnNHTms5?=
 =?utf-8?B?VkZqYWVzNFJLSHNxdWQ2Y2FNSmRqekk2Q1pCZGJDZWlMVkRvVVo1VGNjbUNY?=
 =?utf-8?B?c3llMExPWDREdExoSWhSNURNVlpucmFXQkZ1VHhQNndlSklITGc3RTloWFZZ?=
 =?utf-8?B?cDBBOVRzTjBYb3gyemJlZDY1SUxQRjg0VUNlL2NRWWNUR2ZxdUVjZHZXaUh2?=
 =?utf-8?B?R0JVNGI0b09hcEtlMkdDM3RING4ySW9VMmZ0T2h2OE90ZGhuSjdxYTM4VGdV?=
 =?utf-8?B?ZXNEaitnbm5OK243VXROQlhZTTk5TEgrcTZub1lEVUdZNit1K1JwUFZPQ0lx?=
 =?utf-8?B?dFBTVmxiU0xIUUFLeDArb1EwdDg4SmtrT3pHYmtzWkRhUTBvRm00dlhCY2ZQ?=
 =?utf-8?B?cnE5SDE2eHAzZm9EeUIvanJQMUs4bHNSaVlIanZZTzJiNFhhdEtSUWhZWlBh?=
 =?utf-8?B?ZjJLSGxxY2ZCOGl4K0lyajFxWGR0eEFQTUNGN0FPbFFHSit6Um41ZkMwWUl1?=
 =?utf-8?B?Y1ZTSTcyN3hBN0N1Q0VETENtU1ZyeldSZVpYWTFpTVkvbWFJTkkxakp6ZVh0?=
 =?utf-8?B?NHlmYnpkNXZhMDJXWldua011d0MrRlpxQzBZeGR4MDhtTzJoc0JtemdPQ09y?=
 =?utf-8?B?N1I5dXo0VnlyNnZTSDJ0VzBBZkx4YVBLZDNRdVUzN3FZa2txTkNUQTU4c3Fv?=
 =?utf-8?B?aDNQYjJEbnp2T1RIYVlFdlkxWkNKY2huNDR1WFJ3cVBRS05RUHNDaTdYZStp?=
 =?utf-8?B?THpSaEdDdHd0a2FQbGZiWm9XVTh2Skp5cTNmTjdHOGE4Yy9QbGM2QS9Kd2RF?=
 =?utf-8?B?NWZSSDNuT0NmTEEySDZLSysxakg4Wmd3K2RKbVlrSWZZN0JxTDBJeW9kUi83?=
 =?utf-8?B?TS9RcmRJTnQ3dWh4UHRUelNSWG8wQTMwcjhoUitVeTFmL0pLbS9lNTVyVWZ0?=
 =?utf-8?B?MFlZVHpDT0dVTjcvUVlYSWtac1lGcUVCaWdKUTQ5L0pOcXEwWU5ZWUsxYXNZ?=
 =?utf-8?B?MVRuV01DYkRkeklyQ2VBYW5oNVp5aW43c3VTSUZpRnpQYkk5ZWZXTTF3cHlT?=
 =?utf-8?B?MG5UZUU4YjNJWFFBVis5MjBXTWQ5dnQ0UXhQVUtRRUhWTlNlcDBDU3RhY3gw?=
 =?utf-8?B?WlZENEVpbVliaEpCSGRvYTkvUnZjYi81dWVqL1JKNzdVVVlsSXM2VHU0Zi9n?=
 =?utf-8?B?STVFaHYvZklUNWhzMzRaZ0Fhei9GdnRTZG5vVVdwRVRRSjNDeUIzQm1NdWlk?=
 =?utf-8?B?emlYcG1WTzJFbTZNV0I3THdpUkxua29GRmNybU13QTlOZ0E0VFZTQTI2Yi9p?=
 =?utf-8?B?VXZ2QlExTjdWTnphWi8rTWJqT3c1OE85VHRocGl5c0srSEt5bUVaWndaSUZL?=
 =?utf-8?B?Qmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CEB4FEEAB96FC40A74137750EEA88BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5ef125-76db-422a-cb20-08dde5d55a5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 01:51:06.3219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vjTPRYnoqchJuEMNf9fH+l42IU/RzafQqLxoqct2j4/Wg7etGHjs3BhcoAK2CuC4q23aWofARc7hGP1XxCH68POoxy4MIfT8djLfF2AaNDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6832
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTI3IGF0IDE5OjQwIC0wNTAwLCBJcmEgV2Vpbnkgd3JvdGU6DQo+ID4g
KwkJLm1hcF93cml0YWJsZSA9IHRydWUsDQo+IA0KPiBXaHkgaXMgbWFwX3dyaXRhYmxlIHNldD/C
oCBEb2Vzbid0IHRoaXMgZ2V0IHRyYW5zbGF0ZWQgaW50byBob3N0X3dyaXRhYmxlPw0KDQpJIGd1
ZXNzIGl0J3Mgbm9ybWFsbHkgc2V0IG9ubHkgaWYgaXQncyBhICFLVk1fTUVNX1JFQURPTkxZIHNs
b3QgZm9yIHByaXZhdGUNCmZhdWx0cyBtZW1vcnkuIEJ1dCB0aGF0IGZsYWcgaXMgaW52YWxpZCBm
b3IgZ21lbS4gU28gd2Ugc2hvdWxkIG9ubHkgaGF2ZQ0KbWFwX3dyaXRhYmxlPXRydWUgY2FzZXMg
Zm9yIHRkeC4NCg0KSHlwb3RoZXRpY2FsbHkgdGhpcyBmdW5jdGlvbiBzaG91bGQgd29yayBmb3Ig
bm9uLWdtZW0uIEkgZ3Vlc3Mgc2luY2UgaXQncw0KZXhwb3J0ZWQsIGEgY29tbWVudCBjb3VsZCBi
ZSBuaWNlIHRvIHNwZWNpZnkgdGhhdCB0aGUgbWVtc2xvdHMgYXJlIG5vdA0KY29uc3VsdGVkLiBU
aGVyZSBhcmUgbWFueSBNTVUgZGV0YWlscyB0aGF0IGFyZSBub3QgY29tbWVudGVkIHRob3VnaCwg
c28gaXQncw0KcHJvYmFibHkgdG9vIG11Y2ggZ2l2ZW4gdGhhdCB0aGUgc3RydWN0IGlzIHJpZ2h0
IHRoZXJlIHRvIGxvb2sgYXQgd2hhdCBraW5kIG9mDQpmYXVsdCBpdCBpcy4NCg==

