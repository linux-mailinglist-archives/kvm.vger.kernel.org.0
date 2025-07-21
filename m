Return-Path: <kvm+bounces-53045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C331BB0CE30
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 01:30:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8ACF1899D4E
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838CF248F62;
	Mon, 21 Jul 2025 23:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TE0j4M6g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F630246770;
	Mon, 21 Jul 2025 23:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753140581; cv=fail; b=rPHAMaDilFVypRr2Vv3arRdzhC+tr654bnWAHF4NcWGbPCdoJZN/8IrRGVF1yCNWYg3hWjx896wXZ1v42SCR6HCT5vm1TzVO2Vb+4qEGzlIR2z4jUV5PUrsQUALnlWKIqyp2E/fJhv+sI6DTeRjqs7ZKNNoRc/SCaVqpznVrv58=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753140581; c=relaxed/simple;
	bh=Bkms3TtyPrkpKHy2N+DR2pWDvQXWeLHWFbObr+ySJO0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UN5RKwcKiykVZ90zI2+ywrVWxSvuIpFMigcCu9xn2nxn8OXbg+OAks85KSZpaGtdFJvbeCTul/P3Ysd+HWXGHmkkdybPZIrfk/+ZAGkFkKm0MMQEcJao0Xdj+Bo+CCn5NXw97EixbRVnB1Zx8hb+QDrCC0xvqAKsNTHFiiWXLYU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TE0j4M6g; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753140581; x=1784676581;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Bkms3TtyPrkpKHy2N+DR2pWDvQXWeLHWFbObr+ySJO0=;
  b=TE0j4M6gN1aEat6jPGR2aRVLFnDXP4+BsrejQ9qXh883nkuo1x6Jym3p
   Avnllh+ijiWWG/L4h1olqRtOCabAth9erxPX5jZENDd6vu2j9GPpNAk16
   qFAsvngY1nQPBHzjFAhGD9QIHkIjPkTLBCEVhM9UFu85DbXIian5aD7L7
   RyGCCCyr4C5Uwb5Yjeb4byFoMtyaipaFTc0f54vVSplTphUDaQdVZUtkU
   USu9ixqKcmsN6o5epuTZgrSq6KHFV/t5chkJXoSwDTa2cA031exwK65Sh
   j0bKBLmueWqDt++1ROP3kfELGND/hAZSR1j6RYT0eVqVhjEVeiAfw2oBL
   A==;
X-CSE-ConnectionGUID: ndsq3fmvRnuCLyRRlLXceg==
X-CSE-MsgGUID: SE5jmaAVSQi7ig7mWtaGqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="59033355"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="59033355"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 16:29:37 -0700
X-CSE-ConnectionGUID: NM9Q+WMASVqFE091ic6JWg==
X-CSE-MsgGUID: oYlfXunzSCqj0HXAvGbgpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="164636206"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 16:29:36 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 16:29:36 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 16:29:36 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 16:29:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hyDPy1v5w5yJCQP85ropMEhASX7SJSEu7KZlxcSBpRBQE8qNgQH95vmjUZUqjwBQJd7wjdsaKHsmQhnav3UcFoQ6+ViIUJ5PCggPIkls8c3C8NexIlataTRJ6ADc5UoBi82bRjHCj8yDjcngf0fJ/Fvlej8NZLksiOik526Soy9ahUXwCGZOT9ZUDbBzVt3Y8DYFM7zTcu2T2/yriVvye6yvj+rz/PgOaxqHl0Af0dnevNt6G47SvTTKX5qLqUM2MiM9POpFEf2h0zDVf1yk6GLGuny6Whxi/rxXPQWrCnNkV9MQmEpHKK7JS8kQEPcUks7rL7KlhCDhXWSo8NE6zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bkms3TtyPrkpKHy2N+DR2pWDvQXWeLHWFbObr+ySJO0=;
 b=AwBnr0mHXDLJ5wl95gTF/TNS0xDRdmjUU6QfInmsoy+wnWW1Z1dLqutXTa/vqB0rW3d05y3SMCalOfTh++hTbDYMCMNFlQd+N3+GdFkhsrUENOkBA7TwGYszv20j+bMYXpeQBDWmLDLZ2CgK7d1pZ1RVbQ4e8+nyMsufWi7h8icCXfikm1V3t9Sbv5vEfadObqlmuv0MAM9O83eE/6WF0AP9DbqOSuN1tXUgIf7TVglvuN5Hn6TME1ijPXnusvZfSJByz89kCAxFcs8KmxqNAU/nf8Ek/eU1rhiFzcPkWZNYSTWjFBSTlWx95Y0ZuTYrCfCkkQJLGpOzOV03biEMNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH0PR11MB5236.namprd11.prod.outlook.com (2603:10b6:610:e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 23:29:07 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 23:29:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: RE: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Topic: [PATCH v4 1/7] x86/kexec: Consolidate relocate_kernel() function
 parameters
Thread-Index: AQHb92MJH4Vi4bs6uUOSkG2OAWH7LbQ8rCmAgABvgwCAAAIgAIAAAokAgAAYrgCAAAYskA==
Date: Mon, 21 Jul 2025 23:29:06 +0000
Message-ID: <BL1PR11MB5525BEC30C6B9587C2DF23A0F75DA@BL1PR11MB5525.namprd11.prod.outlook.com>
References: <cover.1752730040.git.kai.huang@intel.com>
 <c7356a40384a70b853b6913921f88e69e0337dd8.1752730040.git.kai.huang@intel.com>
 <5dc4745c-4608-a070-d8a8-6afb6f9b14a9@amd.com>
 <45ecb02603958fa6b741a87bc415ec2639604faa.camel@intel.com>
 <7eb254a7-473a-94c6-8dd5-24377ed67a34@amd.com>
 <1d2956ba8c7f0198ed76e09e2f1540d53c96815b.camel@intel.com>
 <38C8C851-8533-4F1E-B047-5DD55C123CD1@zytor.com>
In-Reply-To: <38C8C851-8533-4F1E-B047-5DD55C123CD1@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH0PR11MB5236:EE_
x-ms-office365-filtering-correlation-id: 6b5e44fa-8b06-4a07-066f-08ddc8ae6334
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?S25kV1MybWJhcjNrMVl5MFJyNVROc1ByTzRoT2NNV3gzVC9pQTlpNXRoTSt1?=
 =?utf-8?B?OW45NUIyS1MxTGdrN0hMbXM4V0s2bmdSZTVtQUZ5ZGIyQWpuTUtJS29yODBP?=
 =?utf-8?B?MGsxSlptdlM0SC9nU1E5SE9zUEtiR09QQVcxdmpPY29nMW1PWlJ3THpkTU9B?=
 =?utf-8?B?VWxHdkJMUUVJWGJvbndUdHA2VWJmaGZXYjJINU9JK1pSMHRXelN6N0dKdTBW?=
 =?utf-8?B?TFJyWWxCNXhicWYwNGc0UEtVVzQ1TzlYbWlxNGFHaFBPczdUVXFJZWp2T092?=
 =?utf-8?B?eGNrSDV2eDZDWFBObEVpYy8zbVhqWWg0TU1JTXJJeXlpb1Rsem45YndxMFl6?=
 =?utf-8?B?T002NU0vdjFadEJOR2wxaHRoV2N1UnVvUFJoOTBaRFpTbHZ2eHZkRGdYUjdV?=
 =?utf-8?B?c3FRdE05RlY2bkxXSFFBMFVpQUpQMTltMjNqSHQ0cmQxMDJOYm13eXFuU0hs?=
 =?utf-8?B?MGJhRFVMU09RQXQyMEhuakVtNFhHa2tiam9mV3N0cG1ETkl6T0ZUaHYwQUNa?=
 =?utf-8?B?d2l0THgwZjZ4RDhycFUwVVliVWQ4QWpucEFGV0RDZzhGSlhuN2lwL25aZGUz?=
 =?utf-8?B?dGw2aUZYSGVKQkdwTk5DOGJpTTRzRHI0bEt6L0RiaExrM0FhZzhQL0NNU3BH?=
 =?utf-8?B?dFpQNlZQZktyWXRWYmlWRkZrbjFXbEtLQ0I2Um1iYzNjNzVTZ1lMMTZCSHNl?=
 =?utf-8?B?eUk3amNIdUpJQzZkaytHeGY2THlBUk4yK1N3b0JNaDc3U3ViWkZTc3owNkM3?=
 =?utf-8?B?WDMzNWFnZUQ0dVo4T1Mxb29RTnEyM2Jxd0ZqS1BlZWpxN282eGo5WndubVdO?=
 =?utf-8?B?Y0pRUnpMZ3FZdFlLOVMyQ1ZIV2dVcGdrUU5ZeHNJM2l0QmZuckdnb0dCSVNQ?=
 =?utf-8?B?bEFWV3A5a1dYcVBFYlZRR3ZWcjRLRkpTSTRqeTNyZFZxMHVqZW9ERmVMeEM5?=
 =?utf-8?B?b1VPUjhrelVlUU9sK2tsK0crakViUUYzcFJaejBZTDkzdXo0SmZKTXJsTFhZ?=
 =?utf-8?B?QjVxZDJsOWRTTW16Zmd4aTJtejNLY3QxV2ZHQ0k5TTNJMitjSjlycmxqbVNh?=
 =?utf-8?B?b0VUMkJlL1pVa01veUZRcE9rbGVVRGZwMFp5NWpHUHdJTllYaytySThiT2dN?=
 =?utf-8?B?Tm40d2xNWkVOTE9DZ0k2dVVnOXFxTzhUZ0hFcS9VS1I2MjNGa0hPcjhkUHl3?=
 =?utf-8?B?WElQYUlSMEdTaXI3aWpjMUZlWDVGQ241Ni9ZcGFVdGg0TmxITjY0Wm9BUFZk?=
 =?utf-8?B?SUlURkdwTytueDErUGxmd3NmVXJDZUZzR2QwdVkvc1lqWnZoMm43QlRqSjNT?=
 =?utf-8?B?QmxzZHBrYkdrc1dnVWIwNkw0bHp6cW1GS2VMak9BWjFXR01WTzZiTkhld0t1?=
 =?utf-8?B?LzUxZmxzdHAxVWZpY09iYXRZMHVab3I5bnZLRGNOeDZTWmZia1ltRnFCK1ph?=
 =?utf-8?B?cDhidTRCWmFMcy8vRXBiSy9OUkNXbldFZ1FqdmFhL0NqQTlTR1FKNTZ1bEd1?=
 =?utf-8?B?YVlPMU5jeEFOTytDeWtMZk9XcFh6c0w0Skh4OTlyNDlLK1d6OHhhN2VIYk01?=
 =?utf-8?B?T0h0emF1M0UvVmx5aGFuK2d6QnI1VjI0SkVSM3lrWXU3Ujc0VTMvdmNyZURE?=
 =?utf-8?B?UmtOYTIyZE9Qem41eEo4QzBjNmU4UHFPMjVIcldzdzhwKytrYm9TSUV2WFB4?=
 =?utf-8?B?aFhxUnNsVCtKZ0ZvOTMrS1A2NHRqN3pmT21FSmR4a0srWEtnZkdsdFFYQXRI?=
 =?utf-8?B?NkxZNHRJNnd2R2ZoeTF4cHVPUG9CcTZDSy9lMXNqMDFma01Bc2E5UUhxTjNq?=
 =?utf-8?B?akxIMXRtOUNIeW9TR1lQWUFUK00xbmlFL0pSMTB4RS9hTHJINWdpUVk4Uk5K?=
 =?utf-8?B?MFRhRW1YbWV4WFIzSi82SHA3QmwrNGdQZndBTkl0UURHc3hrSjVqeS9MSnpV?=
 =?utf-8?B?TzFzdkRuUW1FRUszTUZ6Snh0Z1NNVkV1ZFR0NzVpWS9pTGdCYk12MkNLRThB?=
 =?utf-8?Q?+QhUT+WiqxKWAHKBvLwYYeoKQB4Z+4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QkRrNHNmZjNaVkVic1AzbnJtbkhERWx6bnZ6b0E4QlVxNlZ3TEN1ZXNTMXpy?=
 =?utf-8?B?N2NmQ3VQWFhsRFlZeUlRaWFoVFFYQVdJQmFiU1lYc1RyUXB5eTJqeW9DYjIx?=
 =?utf-8?B?SHFONkJqWkVYT1VzZFZmcU9oTVVPVTBWUDdRUkdFc0xuM3B5MG5CYkFMdk5i?=
 =?utf-8?B?TWd3YVZmQWoxZjBSVFZlZjI1ZDRHMlBLUHUwYnc0ODU1OXpKdDJPaXR6QjMz?=
 =?utf-8?B?U0IxS1YvK0FyMnFDc2NYVmV6cDFLdFphYlpQcjl3MGVTSUxQeWFnQnhLbkF1?=
 =?utf-8?B?YkZEL2xSY3p5RDBkUTZXZWIvejcwVzZVblh1Ris5VGNmeGpQb1dSQ3pZWEZh?=
 =?utf-8?B?VjFPVHEwdzhrUmx2ODM1dUdrTWhkUnZ1cmtrekF0WTR2MFAvZTlUWHh3V0NB?=
 =?utf-8?B?WnFWZ2g5VGtRSFBlWjlhL09PeWIvMXVDRWU0YUtnWDhTT0hyR2JuWFUzWnFj?=
 =?utf-8?B?TlhUWDFiRVV5a0Rhc2ptZkhwOFhVUUJYN3g3a05GdVBTVXNJb282cTdmMXhX?=
 =?utf-8?B?MnZ4NDdXWlRLbzBLVzRLYkJQS3dYWkFxMDZWd2Fxc09zaHJMbkNnNDI5Q3hI?=
 =?utf-8?B?M0pvN1B4cXFGQkhEd1MyeE1ORUc2Q2FDb2J6SThKR25xbVFkV09WcmNjQ2pl?=
 =?utf-8?B?dmN3Tkp6d0U5MHNyQVJkazdZTDM3c2tRQWVCVHBuUzdsK2ZZS1ZVYzBUaTNU?=
 =?utf-8?B?YlVBdXBSeVNTT0Z4UVZaN2ZMVkloc1l0V0FZL2pSNUFBbHVHUE5ESjFTMHIz?=
 =?utf-8?B?L3pPOEZXVWRJVDZFZmhVdVlKeGhqUFVoTWF4Y3hJWm1sekUzWUdOTkEwelBE?=
 =?utf-8?B?TDFhYXZBdFZ5Z1MzSzBCRCt5Q0RaV0diMFYwd3UyUGdFTU1JeUtCb1REVDZB?=
 =?utf-8?B?UnMxL0MzSzhSWlBLUEFVdVdoUEhjbk5pZlRlTHdpemtha2NveTBjSm1wamdr?=
 =?utf-8?B?Y0tBWDgxbXBDNGJnWFBad3pieHdlRWVMdVZCMW9GMnk1RGhZdEVRcWFoZE10?=
 =?utf-8?B?bWtQWjBUUUNnY2pDRm1DOS91Ni85bThTMWVXM2o4Syt3SytiZHROZWJFODBR?=
 =?utf-8?B?dC93eGNzSDlTTFF0Um53cE9CbmVuNml3NGgwU0RqRzA3QnRuZ0g2dURtOW1s?=
 =?utf-8?B?U01lRTVNVnNnVkxnd1FiTzdJNmFQSTR4RGV6eDlmcU5WWFlJaUh3bG1UUVZ4?=
 =?utf-8?B?aklPcno3R1ZsampIR21lYzdNNWVsZUpUWmZxOWROcmt4clVxZ2dnS0gzNWN6?=
 =?utf-8?B?UFlxbmFsck8zbVB5bitXOEFvZ2lNTDBRWTRDL1JJTTJ1bGZlaTZTTkxjc2Iv?=
 =?utf-8?B?a0R2ZDRYN2UwVGhiSUxVRVZZR2cxUHRWcVR3Qzh1UithZlJJUndWN1BReS85?=
 =?utf-8?B?ZHFmZVlOWWZ6MXhGWWM4SHlUNDdtSHdTdjZxUUhBS1YrWThEQTRzdE5GWWgy?=
 =?utf-8?B?MTdtQ3IyLy9saWRpc1VGMXNTV25weFcyT3R5b0R6VEdtMFdEaFlDWDVsK01G?=
 =?utf-8?B?Y1RaeGVnSXE3ZGVTTzNmT2ZyU1RZWVlBSHJhOHVGK2d6Zm9EZThIMUpXamxP?=
 =?utf-8?B?VnpYeFhtdFZLUTlSaGxwMXRzY3RzbXJORzEyN3pHdVZ3VU5hOS83SDZpTnNI?=
 =?utf-8?B?SW52a0xyYU1XK0xpVmxZQnE0Zmtzc2ZhQ2tGL0JrQytUWU00d3pVNzRwNEpz?=
 =?utf-8?B?ajg2c1V6OEY2SXdWZVEvOFgvVEh3TERGdFQrTCtwSVFKWGpPQW1IZm9aWm9F?=
 =?utf-8?B?c3YvZlU0VWh5bWhRMlhnV0JPNCttcEJBYnhLb2s1YnYzcVIweFJIeEdJa3JK?=
 =?utf-8?B?UWh5Z2tmbTlZb2M1RG5mT0JyYVBzQ012ckpsOGpTMXlsZHQ3SFM2Mm9tdzdU?=
 =?utf-8?B?QUNLQ2FQVFpSOUQ3Uk5zNXk4cTZScXpuanV6WEI0a0Z5bkU4SVNUYktUNEdE?=
 =?utf-8?B?YVAyTzJ3UXZ0NTNzdng1VzVrRHE2bFJrUVh6c0xKamJ5WmFydDdNL01LaWxC?=
 =?utf-8?B?MkZaOHdJR1praytzQXhlNE5jaGJnRndML2JzcVFNS0RRNnpnV0JhMU85aHRk?=
 =?utf-8?B?Lzd4OHFDdmxseHNwd2xQU0lIZVNMcUpuaXdKbkNuNXBxYitDT0RXSXVOdUdQ?=
 =?utf-8?Q?QM027ymUBZhLUtj/DsuqfPlxE?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b5e44fa-8b06-4a07-066f-08ddc8ae6334
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 23:29:07.0587
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FKPuYS1tCtwfkp/GYoIbna5jdLnLGf/gJYxlAlG0AO/3qGkYAk88XsjDneoqduAQwLCQYWJXLBBTq3KKErzdSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5236
X-OriginatorOrg: intel.com

PiBPbiBKdWx5IDIxLCAyMDI1IDI6MzY6NDggUE0gUERULCAiSHVhbmcsIEthaSIgPGthaS5odWFu
Z0BpbnRlbC5jb20+IHdyb3RlOg0KPiA+T24gTW9uLCAyMDI1LTA3LTIxIGF0IDE2OjI3IC0wNTAw
LCBUb20gTGVuZGFja3kgd3JvdGU6DQo+ID4+ID4gPiA+IEBAIC0yMDQsNyArMjAyLDcgQEANCj4g
U1lNX0NPREVfU1RBUlRfTE9DQUxfTk9BTElHTihpZGVudGl0eV9tYXBwZWQpDQo+ID4+ID4gPiA+
IMKgwqAJICogZW50cmllcyB0aGF0IHdpbGwgY29uZmxpY3Qgd2l0aCB0aGUgbm93IHVuZW5jcnlw
dGVkIG1lbW9yeQ0KPiA+PiA+ID4gPiDCoMKgCSAqIHVzZWQgYnkga2V4ZWMuIEZsdXNoIHRoZSBj
YWNoZXMgYmVmb3JlIGNvcHlpbmcgdGhlIGtlcm5lbC4NCj4gPj4gPiA+ID4gwqDCoAkgKi8NCj4g
Pj4gPiA+ID4gLQl0ZXN0cQklcjgsICVyOA0KPiA+PiA+ID4gPiArCXRlc3RxCSRSRUxPQ19LRVJO
RUxfSE9TVF9NRU1fQUNUSVZFLCAlcjExDQo+ID4+ID4gPg0KPiA+PiA+ID4gSG1tbS4uLiBjYW4n
dCBib3RoIGJpdHMgYmUgc2V0IGF0IHRoZSBzYW1lIHRpbWU/IElmIHNvLCB0aGVuIHRoaXMNCj4g
Pj4gPiA+IHdpbGwgZmFpbC4gVGhpcyBzaG91bGQgYmUgZG9pbmcgYml0IHRlc3RzIG5vdy4NCj4g
Pj4gPg0KPiA+PiA+IFRFU1QgaW5zdHJ1Y3Rpb24gcGVyZm9ybXMgbG9naWNhbCBBTkQgb2YgdGhl
IHR3byBvcGVyYW5kcywNCj4gPj4gPiB0aGVyZWZvcmUgdGhlIGFib3ZlIGVxdWFscyB0bzoNCj4g
Pj4gPg0KPiA+PiA+IMKgCXNldCBaRiBpZiAiUjExIEFORCBCSVQoMSkgPT0gMCIuDQo+ID4+ID4N
Cj4gPj4gPiBXaGV0aGVyIHRoZXJlJ3MgYW55IG90aGVyIGJpdHMgc2V0IGluIFIxMSBkb2Vzbid0
IGltcGFjdCB0aGUgYWJvdmUsIHJpZ2h0Pw0KPiA+PiA+DQo+ID4+DQo+ID4+IERvaCEgTXkgYmFk
LCB5ZXMsIG5vdCBzdXJlIHdoYXQgSSB3YXMgdGhpbmtpbmcgdGhlcmUuDQo+ID4+DQo+ID4NCj4g
Pk5wIGFuZCB0aGFua3MhIEknbGwgYWRkcmVzcyB5b3VyIG90aGVyIGNvbW1lbnRzIGJ1dCBJJ2xs
IHNlZSB3aGV0aGVyDQo+ID5Cb3JpcyBoYXMgYW55IG90aGVyIGNvbW1lbnRzIGZpcnN0Lg0KPiA+
DQo+IA0KPiBZb3UgY2FuIHVzZSB0ZXN0YiBpbiB0aGlzIGNhc2UgdG8gc2F2ZSAzIGJ5dGVzLCB0
b28uDQoNClllYWggSSBjYW4gZG8gdGhhdCwgdGhhbmtzIGZvciB0aGUgaW5mbyENCg==

