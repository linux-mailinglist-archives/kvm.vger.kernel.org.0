Return-Path: <kvm+bounces-17459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C17FA8C6CC5
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 21:23:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D50AD1C21405
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 19:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1546A15AAB6;
	Wed, 15 May 2024 19:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CPbIA3Q2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41623219F;
	Wed, 15 May 2024 19:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715801019; cv=fail; b=ZS1kg0YXuGJ0n0QpTaNJ+Ugd7GCrAgjPy8dwAtMTAzPf/nT4n2HQ2hk/CgpaCoHQEPA5/x1WBq0OSD6eWN2Zzl4T3lDdFKW0dOVxTLQncdCqIEgue/WzVYTI4Y792fpGH3kvclyixH5Xa2c7uXW/lRpCKr8759Hr8DiUpybKHio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715801019; c=relaxed/simple;
	bh=su6YQtHiORyhXHN0WzYN48ZMFhSGKnLQG3kXeinePfc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RojXnqkO3IMrSVASEV8UZcgCibHasfY4yKVVz/bDfdraDJyl6TRYJGTkw3bg9KIPjHBaa0KNLhaBM87GHc4qOVbhC+ILyMG/ar+BdaOPmvaCTUiMv54j74Fq8qgJAJbKvYyE/e/0T0bmY8aAJl4hE6vRDZcsTkAIRopZD9GTdec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CPbIA3Q2; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715801018; x=1747337018;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=su6YQtHiORyhXHN0WzYN48ZMFhSGKnLQG3kXeinePfc=;
  b=CPbIA3Q2iHjFglPX5LuN+gjpTeLvbnG6q+DCyMg8mtc/y6+TOUeWqsJj
   wnJ/pKkyZEHT6fQwb1cAFQG6O2rsczvwCOfbTEuJmJAQbzifWvCY0fOaM
   MtMiDbdvahPP/KYZLt76eGa56yhDvO3SLtLlpx7Q0pUeoVBxta8+ZEjGr
   Io+VjlSikwCNglor2Q+2IafoSZoH7a7UD9U5azbLNFiD6HZPexwlOSKQZ
   noOOz1+cb0MD6dZ5Zeng37Yqo22MlxiDAFmCJs0xU/LxV7ck1NHDFgblI
   IGb3Wj2QbBg99ic0NjnMJ/5/OxpAwPt9IXE/OyxImZahlMJMmZfuguTWw
   g==;
X-CSE-ConnectionGUID: laOwKbIuQimKUdW5AKh3ZA==
X-CSE-MsgGUID: QVkv1eCoQ3WK3b1Ctl+T9w==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="12089794"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="12089794"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 12:23:37 -0700
X-CSE-ConnectionGUID: tf5llMQ6R3+qaUPuk5QTXw==
X-CSE-MsgGUID: i3HWsuVKQmSSJ3+tpy+b5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35618965"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 12:23:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 12:23:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 12:23:36 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 12:23:36 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 12:23:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJc7V57f7WXs3nZx6uzhwvg0+9ODbEA+7Uc+Ym7qQbMzYuxVROpmW1SsAgHRMDAjPdKh4Nvez/qb1Zk0ctefSBHRHneUWn+pkinncoV4HccaBqWNU2a2Ha4KlwCnZA64ebiQWGLtYpwzTQJopQ8JPKEwTb17C+BfUbeP1m0XAmu0329ea16UNdZfWbIYpokPTwFd66igN7fiNCUqegmlnDO8SOLZQNDN2seurrm+O9pCak2vHzXMcSn44Zxd19ZQh6e7bvZgjj7Xd/YdiAz7mW+ksrAC6m1nl4n8Er8Sovv1GByk3/vuPyF+ssIic205s5ehwPhztxJjwEhB1ssW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=su6YQtHiORyhXHN0WzYN48ZMFhSGKnLQG3kXeinePfc=;
 b=cn6x6Y2LEhhvnBVIHClPCt4VPzydtAVQd9GXU5FLdgqO5JBmK2JlrNGDQjZ5bciTpeDKLIshUSSYV67BpDOYCDcHebGOAb+MwXCeBGktxK64oME6GHV9ns9PD2hKT/x87peJoZ29HQIlBK08VHWcjiszIWJRt/TqTkzHfHE4NP1r2cT3uYNUaYjvXM9/GOMkY1mrMAPetK5T+tAiItwQGSRjKP37SdEo//9Q7Z7ZCfsfJVgjG0/+Ui/0THjc5ITT3XyUKivunA6Tv33LHjsgx0lmowOHB5WR+sdx1tsQUdOcvdPQcVMRy2Dh07AaS2udw2StiTfFr5B3RKE5SOASlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4760.namprd11.prod.outlook.com (2603:10b6:208:266::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.26; Wed, 15 May
 2024 19:23:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 19:23:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "dmatlack@google.com"
	<dmatlack@google.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Topic: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Index: AQHapmM+V0hpZvOG4Euj+PM9FPWPubGYSbqAgABgPoCAAAP6gA==
Date: Wed, 15 May 2024 19:23:28 +0000
Message-ID: <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
	 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
	 <ZkUIMKxhhYbrvS8I@google.com>
In-Reply-To: <ZkUIMKxhhYbrvS8I@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4760:EE_
x-ms-office365-filtering-correlation-id: b3724497-ad81-43a0-9c52-08dc75147fa2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?V0lEK1dJeWpRa1QzbUIxckttR0FZY3R4ZW9kbnVvSCtjMlpFZDFxWmlacXJ3?=
 =?utf-8?B?aFEveWFxazhBZTUzNzhFWWdXbXoyOXhBZlRRS1lDNGE2TnF2c1N0TWR3ajdi?=
 =?utf-8?B?Yi9USjhhMXh2U1JhRFZtM3NMbU1lbTdpL0lLWXR2ZzR1c0xNd016VlFSNVFr?=
 =?utf-8?B?NXpud3YzdExkcVRUU0FPZUJMekNHaFhwbERhL3hENklTSDViOERqZllGd1Qx?=
 =?utf-8?B?ZExlbGEwMXE4OXg2Wk1GLy9lRThiQTRTbWcvcG5nQXNqVEhneDdkbjJNYWFQ?=
 =?utf-8?B?cmM3NXlubGRKaVdsMnNXdUtjbWFjc2V5andaWnAvMmhtWlNRVm0vZEx2TjFR?=
 =?utf-8?B?VmJLSlAvWERaaFNPV2EzZG02WWhZak5ScUN4L2wzUWdHK0c4UHJacnBkZlZh?=
 =?utf-8?B?Qmd0ZzNJdjk4ckJxc245NXVaRm4rU1pxbFlOdTNHMTR1ZzYvbE8vOUVXTjZu?=
 =?utf-8?B?N3NlM256RHUzNmh1UXZCekNZeVFWTURYMDkxSmRVdVFZNkZpZTFSUmxSb3hP?=
 =?utf-8?B?RVg3OERMUDdURlUxZzRpNFo4Z0NLVW1RSUMzY1JGdWlSWGkwbHUwQ2ZlekNI?=
 =?utf-8?B?eHk2RzJ4emVCUzRCWEs3OWM3TnBaNEh0bnhCQlI1K09hRUtBMnVhTG5FR0Qr?=
 =?utf-8?B?ZDdkQWtSUkIrWFB0RUtkcEpmc3JYTVdPdGNadHcraWNPZmtzSEtBWjl4bUJ6?=
 =?utf-8?B?WlkvZ05Bb0pYZTBKNTQ5dGcvSzNHek1ndTBUN0MwY09uNkxocmdEUnJhRy9r?=
 =?utf-8?B?dGt4S0VlR2UzRjNycmd1MWRwZGVJRTIrMnR3YnRLUUtQeWtLMDZZTVBUT2ov?=
 =?utf-8?B?bDZiY3hFdThDNEF0cUVhdERXeUNiS0RnOUV4SStabXZNdEE3NXhSTkpYaVpK?=
 =?utf-8?B?ZGlSUjgwMXlTSWVENjcvTjlRNXVZOG4yNm5KcGVCbmxLNS9YcW5kY1RTQnMv?=
 =?utf-8?B?V2NvZDhpbjM5cHZYNnVHVFRtWUx0VWJ1L1ZsRHBkY0JKNUhGd2lJNFRKTy9W?=
 =?utf-8?B?cmVRMWhNeWlZSlRkcDRHK0xmOGttaFJJdmU1OHd3SWxCZlh5UkFlU2Q2elMy?=
 =?utf-8?B?UVp1OU1pRXQ2cHVnWHdLcDFnZTFNcnQ1UlA3dG04bWg0WmprNi9MeXlVSzVE?=
 =?utf-8?B?S1ovR0hBaE5qMnhuaVh5SmRWSWVYblMxaCtiakN0UC9hV0Q3NTlTMEREZWgz?=
 =?utf-8?B?QVcvK2JEOEtleVM4OTFvVVcwMFVhdmNUK0xUaitoUHpIL1ZzZWFyeER6cmxq?=
 =?utf-8?B?ZjI3MU1hRmtCTEw0TlZCSDN6YmpXeFdsWGtqaTNnZmtjdXM1M1h6UXQ4dEJD?=
 =?utf-8?B?QU5xeWQ5TEFES1llT3l3bStWdlluTHM3TGVrQTdaYzc1TWFNT0c1N2RvK3Ra?=
 =?utf-8?B?Tzk2QmtWN214T3BvOGZUb1AwaWdmS0RXL3lUcXdKZ1JHcW5QUmFmZlJZWlR3?=
 =?utf-8?B?U0NLTUlOSFowVnNRSkxHMGVVY3pSS2wvUVlYeGw2Q0Npck51MnptdTFxa05x?=
 =?utf-8?B?N3I5UnQxeVNnR0pDN0JjaS9PK2ZiNFBqMDBJNmRsZDBxU2RDVkdReDNSTytC?=
 =?utf-8?B?ZDIvTzlnRWJBNGptT1hmcGZ1WHdQZUYvaENtaEM1TFRmR0JrRUxsdnJSNWQw?=
 =?utf-8?B?eVlCdFlWWlFBNEhQUFVtZmxQeTdGM2pOMWdWZmxNV1YxZEhjYVlxMDdlSGdk?=
 =?utf-8?B?eUhmU095bGJWWmRlUXNaOXZYQ3JGa040QS9BM0J2TWZSalNvNlFFa3VSajNQ?=
 =?utf-8?B?YTZhb3JqSDExWGtDNFZMcU1WSk1ZTFU5UnYwUC9ZbmJndVQzWjVpN2xEK0Nj?=
 =?utf-8?B?MG40WVdydXZzUVJGdEgyQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Lzl1b09ZcjJRaXRqWXJZcHE2M0I0b1FzUFRhajNVQXd3cjBMbEJiM3ZBRDJn?=
 =?utf-8?B?Zkg4UmVNRXNNSzNDZmsxdlRmY29DSEo2SjJMd3JkSEdDaUJRNnNBdzFGNmRG?=
 =?utf-8?B?S2wwa1lFNzArQUZncnZEa1Y2bkNEUGRscG5BbXJkWVNWY1dvU0pnOG9yYllC?=
 =?utf-8?B?SG5wZ1YzeGtDVE1GOFdpZHRjM1MrUDRVYm9DRThIS3ZzUEtLa25yYnkzRnFW?=
 =?utf-8?B?UENpMGduSWNpUFVuM1BnaHNjb1VpWWlOYmFWZWdEejdIcEx2VVBaUUhVQ1g1?=
 =?utf-8?B?NE1RSkMrOHYyTjdSd2Rldkt1R3BsVVpGcHVvOWova2wrN0laK0l4Mk9TYnl1?=
 =?utf-8?B?bFg5elRWWTM2UjQ0RzBTWmU2a1dTcnZNUVhNSWNpcDQvaHIzbWJLOVNLckxD?=
 =?utf-8?B?S1dPZ2wvVlBoSjJBTGNLVDBudHdQT3czY3drbW44MU9Kc0tCMXV2UGl1L0Zo?=
 =?utf-8?B?TURyNU1mR3BraUZLQlJEcjlMSUExMkU5c1pTZnd5VU9FT3lXaDFhNzJidDF3?=
 =?utf-8?B?QUcyWVlKQk5DODJIQmhzaXVMaUtPRFdkNWFVQ0ZuVmJiN2ZqOHB2SjhJM014?=
 =?utf-8?B?eWc2dTJUV1ppaTJ6NjVEcDNQYkRjRWZjQVh1ZXNiRUxhOWNhOWFSdzhCTm9t?=
 =?utf-8?B?R2h6OEdqRUg5dTRrRlJtcTVmVTY2NTdGSHhrSWo2Mkp2SCtEMGhrakZPdUVs?=
 =?utf-8?B?TmMvNlIyRFZzb0lpT3RuU2pmanVYLzdwSHI1MlU0d0dnQ3JLaHp0S0xtSk1L?=
 =?utf-8?B?MGx0ZWh1YzlnQWpES0lyZUNJcTFXeDdWd3hJYzhLZ1NvSnF5eTR3NFhSb3pU?=
 =?utf-8?B?MHlPa2puQ0ZRTDVMUnJVcFkzTUpSa3JGTVNHQ2d6TFNyOTFDRFRnVEZSb0J6?=
 =?utf-8?B?dEZ4QWhydG5Rcmp0K2FPM0hwQWtBdTBxQVMyd0NJMk10MEsvZmpxWjZ0K1Fj?=
 =?utf-8?B?cVhHTFBBQTBnWnlGR3J4NTRNcFhJUmJ2aGpieDlBMWhwbERXYXRFODIvWGho?=
 =?utf-8?B?NzRjRnpIM1VucmFCcUVRSTgyUEpINjUvdERqamtsbmtzdDJVR0dKR0xVb25j?=
 =?utf-8?B?MmVQckJCbkIzMnRYSStjbVR0VTc2NEkxbTZIUFNXRkQxcGpBaTlYZWljeVkw?=
 =?utf-8?B?VGtQcDV6Rms2ZzhRVXpSOWxVWEZYK0tKWEQxcnlLazNBamFFdkUvRjU5UXZh?=
 =?utf-8?B?aEQ0WjlMUUk4QWtBa2tUZlE4dmdocXV6aGM0WXh2ZkxLN2NLOG5rcThpMUVi?=
 =?utf-8?B?UmN5U041eXpXalphY1RZdjVvcGhQdGFqUGNaeWo4Qjl1L0hnUjFEeG81b3Bu?=
 =?utf-8?B?QWRvYXU4enhRdTVCK01JNVMxZkl0Yi92SmlyN0xvZmJaNlZVQmU3QW9FZTJs?=
 =?utf-8?B?cmxFTllnTEFGOFJvTnI4S0g1YW1UanpWZkNyWm9yK3pSR2Q0MmFMNi9rZWdO?=
 =?utf-8?B?bDc3VjdQcEZkTWhXUkVXMStMUkp2UTNudWt1TldVUjRSRWRkTTV1RzMwb2ZG?=
 =?utf-8?B?ZHBVUzhjTlVQVm5BZXZNUjNFTThFVkg2b2gwZ2dGbk5UVEpaWHoxS2V4RUE5?=
 =?utf-8?B?ZmxXU21VZ1ArYjRtYlZnYmg1R00zalhHRk5xclc0bkg5am1wR3V1aWxsaFpv?=
 =?utf-8?B?ZHB1bU90MHVtTFZBRG5vaU1kUHB6djEzR0hzbUpjQnI0YTllTkZvZFl4eEhl?=
 =?utf-8?B?Q2d0NUN3dGpyTmtobzJlc0R0dU4vTDFCYnEzNnkyUWhscUpQUGRDUVRMZWxX?=
 =?utf-8?B?RC9uSFVyVUpmZDZHSk80bW5pMXk2OXp1MVc5SFdoRk12UHpiU2N6SUd3NXA5?=
 =?utf-8?B?VXFLMU53QVYyYWZDeElaWk4wSENpTzdFbnhxSU5uZDdtMXVpU3V0VlVWbDBq?=
 =?utf-8?B?eWY3byt6MkFmVXBTaWNnajN1ckZybHI5TEJoVW9iYit1bGdveFp6T0tsdGVZ?=
 =?utf-8?B?Mno1Zi95cHRNcjlDbGFOZFBnVlVOTUNkSjZMN0N5VmZrcjFycnlyeFVmZ29Y?=
 =?utf-8?B?aWRWVVIzREh2V3pEcEJpSGN2eEl3bWZjWmE2ZitwaHo1c0VSbFIvV0FjSFpp?=
 =?utf-8?B?Q2FaeExxcmdDSFdLNFc4RU5lN1l4eGJOOEErakwrZ285MUhhd0JkZjFnMXFU?=
 =?utf-8?B?andzeEk4YmFJdSs2OW5qT3E0WFlGVk1XZHNjbUptU3RGOWxRMkgvbkxPWllY?=
 =?utf-8?Q?FZI5mEoV4dusRxJOOn4MpT8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE3135E6A833B9468187DA94797D9774@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3724497-ad81-43a0-9c52-08dc75147fa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 19:23:28.0884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oIT7wpK9YsWK4a8PtN9TGMEr4nE9tHha9hZaoI1N4yk/ZSGL0QAF48sGELnSgXQ7O1NE4EiGC3Xpju9AlF31+Uf5fqcvv/TB98phps30QDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4760
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDEyOjA5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEl0J3Mgd2VpcmQgdGhhdCB1c2Vyc3BhY2UgbmVlZHMgdG8gY29udHJvbCBob3cg
ZG9lcyBLVk0gemFwIHBhZ2UgdGFibGUgZm9yDQo+ID4gbWVtc2xvdCBkZWxldGUvbW92ZS4NCj4g
DQo+IFllYWgsIHRoaXMgaXNuJ3QgcXVpdGUgd2hhdCBJIGhhZCBpbiBtaW5kLsKgIEdyYW50ZWQs
IHdoYXQgSSBoYWQgaW4gbWluZCBtYXkNCj4gbm90DQo+IGJlIG11Y2ggYW55IGJldHRlciwgYnV0
IEkgZGVmaW5pdGVseSBkb24ndCB3YW50IHRvIGxldCB1c2Vyc3BhY2UgZGljdGF0ZQ0KPiBleGFj
dGx5DQo+IGhvdyBLVk0gbWFuYWdlcyBTUFRFcy4NCg0KVG8gbWUgaXQgZG9lc24ndCBzZWVtIGNv
bXBsZXRlbHkgdW5wcmVjZWRlbnRlZCBhdCBsZWFzdC4gTGludXggaGFzIGEgdG9uIG9mDQptYWR2
aXNlKCkgZmxhZ3MgYW5kIG90aGVyIGtub2JzIHRvIGNvbnRyb2wgdGhpcyBraW5kIG9mIFBURSBt
YW5hZ2VtZW50IGZvcg0KdXNlcnNwYWNlIG1lbW9yeS4NCg0KPiANCj4gTXkgdGhpbmtpbmcgZm9y
IGEgbWVtc2xvdCBmbGFnIHdhcyBtb3JlIG9mIGEgImRlbGV0aW5nIHRoaXMgbWVtc2xvdCBkb2Vz
bid0DQo+IGhhdmUNCj4gc2lkZSBlZmZlY3RzIiwgaS5lLiBhIHdheSBmb3IgdXNlcnNwYWNlIHRv
IGdpdmUgS1ZNIHRoZSBncmVlbiBsaWdodCB0byBkZXZpYXRlDQo+IGZyb20gS1ZNJ3MgaGlzdG9y
aWNhbCBiZWhhdmlvciBvZiByZWJ1aWxkaW5nIHRoZSBlbnRpcmUgcGFnZSB0YWJsZXMuwqAgVW5k
ZXINCj4gdGhlDQo+IGhvb2QsIEtWTSB3b3VsZCBiZSBhbGxvd2VkIHRvIGRvIHdoYXRldmVyIGl0
IHdhbnRzLCBlLmcuIGZvciB0aGUgaW5pdGlhbA0KPiBpbXBsZW1lbnRhdGlvbiwgS1ZNIHdvdWxk
IHphcCBvbmx5IGxlYWZzLsKgIEJ1dCBjcml0aWNhbGx5LCBLVk0gd291bGRuJ3QgYmUNCj4gX3Jl
cXVpcmVkXyB0byB6YXAgb25seSBsZWFmcy4NCj4gDQo+ID4gU28gdG8gbWUgbG9va3MgaXQncyBv
dmVya2lsbCB0byBleHBvc2UgdGhpcyAiemFwLWxlYWYtb25seSIgdG8gdXNlcnNwYWNlLg0KPiA+
IFdlIGNhbiBqdXN0IHNldCB0aGlzIGZsYWcgZm9yIGEgVERYIGd1ZXN0IHdoZW4gbWVtc2xvdCBp
cyBjcmVhdGVkIGluIEtWTS4NCj4gDQo+IDEwMCUgYWdyZWVkIGZyb20gYSBmdW5jdGlvbmFsaXR5
IHBlcnNwZWN0aXZlLsKgIE15IHRob3VnaHRzL2NvbmNlcm5zIGFyZSBtb3JlDQo+IGFib3V0DQo+
IEtWTSdzIEFCSS4NCj4gDQo+IEhtbSwgYWN0dWFsbHksIHdlIGFscmVhZHkgaGF2ZSBuZXcgdUFQ
SS9BQkkgaW4gdGhlIGZvcm0gb2YgVk0gdHlwZXMuwqAgV2hhdCBpZg0KPiB3ZSBzcXVlZXplIGEg
ZG9jdW1lbnRhdGlvbiB1cGRhdGUgaW50byA2LjEwICh3aGljaCBhZGRzIHRoZSBTRVYgVk0gZmxh
dm9ycykgdG8NCj4gc3RhdGUgdGhhdCBLVk0ncyBoaXN0b3JpY2FsIGJlaGF2aW9yIG9mIGJsYXN0
aW5nIGFsbCBTUFRFcyBpcyBvbmx5DQo+IF9ndWFyYW50ZWVkXw0KPiBmb3IgS1ZNX1g4Nl9ERUZB
VUxUX1ZNPw0KPiANCj4gQW55b25lIGtub3cgaWYgUUVNVSBkZWxldGVzIHNoYXJlZC1vbmx5LCBp
LmUuIG5vbi1ndWVzdF9tZW1mZCwgbWVtc2xvdHMgZHVyaW5nDQo+IFNFVi0qIGJvb3Q/wqAgSWYg
c28sIGFuZCBhc3N1bWluZyBhbnkgc3VjaCBtZW1zbG90cyBhcmUgc21hbGxpc2gsIHdlIGNvdWxk
IGV2ZW4NCj4gc3RhcnQgZW5mb3JjaW5nIHRoZSBuZXcgQUJJIGJ5IGRvaW5nIGEgcHJlY2lzZSB6
YXAgZm9yIHNtYWxsIChhcmJpdHJhcnkgbGltaXQNCj4gVEJEKQ0KPiBzaGFyZWQtb25seSBtZW1z
bG90cyBmb3IgIUtWTV9YODZfREVGQVVMVF9WTSBWTXMuDQoNCkFnYWluIHRoaW5raW5nIG9mIHRo
ZSB1c2Vyc3BhY2UgbWVtb3J5IGFuYWxvZ3kuLi4gQXJlbid0IHRoZXJlIHNvbWUgVk1zIHdoZXJl
DQp0aGUgZmFzdCB6YXAgaXMgZmFzdGVyPyBMaWtlIGlmIHlvdSBoYXZlIGd1ZXN0IHdpdGggYSBz
bWFsbCBtZW1zbG90IHRoYXQgZ2V0cw0KZGVsZXRlZCBhbGwgdGhlIHRpbWUsIHlvdSBjb3VsZCB3
YW50IGl0IHRvIGJlIHphcHBlZCBzcGVjaWZpY2FsbHkuIEJ1dCBmb3IgdGhlDQpnaWFudCBtZW1z
bG90IG5leHQgdG8gaXQsIHlvdSBtaWdodCB3YW50IHRvIGRvIHRoZSBmYXN0IHphcCBhbGwgdGhp
bmcuDQoNClNvIHJhdGhlciB0aGVuIHRyeSB0byBvcHRpbWl6ZSB6YXBwaW5nIG1vcmUgc29tZWRh
eSBhbmQgaGl0IHNpbWlsYXIgaXNzdWVzLCBsZXQNCnVzZXJzcGFjZSBkZWNpZGUgaG93IGl0IHdh
bnRzIGl0IHRvIGJlIGRvbmUuIEknbSBub3Qgc3VyZSBvZiB0aGUgYWN0dWFsDQpwZXJmb3JtYW5j
ZSB0cmFkZW9mZnMgaGVyZSwgdG8gYmUgY2xlYXIuDQoNClRoYXQgc2FpZCwgYSBwZXItdm0ga25v
dyBpcyBlYXNpZXIgZm9yIFREWCBwdXJwb3Nlcy4NCg==

