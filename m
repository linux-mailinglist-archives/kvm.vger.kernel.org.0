Return-Path: <kvm+bounces-28789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2C9C99D4C4
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 18:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E3A3B23672
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 16:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCCAE1B4F04;
	Mon, 14 Oct 2024 16:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXPxXU16"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2C81E4A6
	for <kvm@vger.kernel.org>; Mon, 14 Oct 2024 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728923703; cv=fail; b=eZkpZmAyei9bdRch3G0DSEKiuKO5+6efJlWYP4kONNOqsp3WXzWx1EXcMRYXO2c2xD4LWNY47H6akTJNOLmgndb78adWFE70VV/Zef+lz1UchRV3oDVJg6O67x/sV0Pi8nIYfaZJ2vz96X06asOPb01NLoe0yFWKpSRVHE/rtR8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728923703; c=relaxed/simple;
	bh=nxewpEkCm23RVCoxDYQXnrskuP0Vk5XtrJxel7r2CWU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gIDU3TYZFdsVSWaVckZBuKpB1nBqUMHJSTbDN1XchpPXwX7KHr+Xlxvxm1NVx9uLmbKqkLrcBkUk+pclfLBPsjMAdrZKmK5jDwPrRipgoCl5DygiZuKUyyl92QpaSc6S7/HUcLf5k4AEeQMcDBybdmuSDMmx/BXm2/zUSuSNn60=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXPxXU16; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728923702; x=1760459702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nxewpEkCm23RVCoxDYQXnrskuP0Vk5XtrJxel7r2CWU=;
  b=HXPxXU16WdOCwftwSDqt85Pm5Wg0mFdjTzmSk136Hzsdqjr7189BID7m
   aV2x9u9j7ycVmdAOGcrEtfPpTCwpehqJM48iB3oJo26ritheqU58N5LsP
   Gsr30ZxIt42RUaJ+lsIxLPgL2/c+FAhQ8RVzS+7OI34JMfFhsl4eu00Iu
   Mu223bc9w2WiCvUbRknrxo9euiCWCUZ8H7PxfYHtcSGB47UTwE/oJQLel
   Pd1sQXglgUYESpu0MNWEjHc/9mVf4XBhSAIT2+KrdzZTKNdSDusls+Qbp
   wvInm7SB02fv7CxXeZ6xCOoZ13XY1MRqtTfLO8DKFOEdJnLyW8WIMUav/
   w==;
X-CSE-ConnectionGUID: JbasX+nqRkiS/iXI5jvrCw==
X-CSE-MsgGUID: 6LEdxLTcTRi8LcHBrTa3kg==
X-IronPort-AV: E=McAfee;i="6700,10204,11224"; a="39677172"
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="39677172"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 09:35:01 -0700
X-CSE-ConnectionGUID: I2CDCWt1QqamI1+ldaHm4A==
X-CSE-MsgGUID: OrUes+g9RdS741VdMMMU9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="78066557"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 09:35:01 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 09:35:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 09:34:59 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 09:34:59 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 09:34:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v88mADh4P1zPPJftbVmyV7QPwu1+EFc0efh4cyi9lxyjkp7+JsSyOsVYSGydbsOw8lPp0BrU7/7161JfO/EFoJJH4VW/9pFIzlxCts7LeVuC+IC5z4UFf53DUtWU5LLo9pAv6l01ZzruScU1C3oTotHEUW9sy2tbZJRsGak9DkSWvwYizyP3uFEA+7l8aXskzmHH2Wvyk6jobBkWr05wVExD4FBi27Vzl5hEbKlLMbCvBIhUkL9t3pj6oskDJNm4RZ6mMU7kTET6B1J+ytpqFcopj/ZwAaETGkQnMPiKQHZLhK3prF8ov4e6MSdc7mQR9KFaMRZJFq/xrOYlcy8Lyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxewpEkCm23RVCoxDYQXnrskuP0Vk5XtrJxel7r2CWU=;
 b=Q5bJogrM8PT3YaETKS3TYq3lJyRGM1AUr1n1evfPWId4HMcrf1DhRK+gKny6a/wvv15wpPC4JnCXIk0HsU/kHd5jWwHW7ky3+QZ50W9Vhdx9ApmLV/sYx1ptFZ2Yy52dieRnwpeqs58mF/4pAPZ0zjvqIbTc+EMVS4xZZCSewUkFDkJGl3+4veKfTQSDDUieoiAX/wPdNrt8m8EpHC0VKbdJn+pCl11wRAghtgemET9dQ+ElWNTflwOTKvJd1g6ca1iiuRF1LnSoN8vZevxrpRw30E95hdWV/RT74u5WkpwFu6GJ7CzNGhLgRLMEhm42UbAeQAA4kyaZVKeUI51lmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4550.namprd11.prod.outlook.com (2603:10b6:208:267::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Mon, 14 Oct
 2024 16:34:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 16:34:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: lkp <lkp@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>, "Huang,
 Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"robert.hu@intel.com" <robert.hu@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chen,
 Farrah" <farrah.chen@intel.com>, "danmei.wei@intel.com"
	<danmei.wei@intel.com>
Subject: Re: [kvm:kvm-coco-queue 62/109] arch/x86/kvm/mmu/tdp_mmu.c:474:14:
 sparse: sparse: incorrect type in argument 1 (different address spaces)
Thread-Topic: [kvm:kvm-coco-queue 62/109] arch/x86/kvm/mmu/tdp_mmu.c:474:14:
 sparse: sparse: incorrect type in argument 1 (different address spaces)
Thread-Index: AQHbHH4pwD7IFX5fcU2FnoyL93nar7KGdQUA
Date: Mon, 14 Oct 2024 16:34:56 +0000
Message-ID: <8cb221fef1580b7d404f3ccbf556f4f838a422a7.camel@intel.com>
References: <202410121644.Eq7zRGPO-lkp@intel.com>
In-Reply-To: <202410121644.Eq7zRGPO-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4550:EE_
x-ms-office365-filtering-correlation-id: dec4b39f-7e1a-4a3f-6e26-08dcec6e23be
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MkJQMVlURUpoZlRKSnZ0bHhMeW51WTNUVjFhOGhCQkU4Nmh4YVIyeHNZWGg3?=
 =?utf-8?B?alArcWxMWjJobjM2OFZOaUtMRWl3Q0xUM28vU0hRd1NvQlQ2SllyUlYvRGdi?=
 =?utf-8?B?OVRYNjdMR0lBK0NMSTlRV1FyY2NWQkJDMHhCNUJaSWxJRkxmby9VcU44UmJH?=
 =?utf-8?B?cDVPZlFMT0p4Q2JyWDNlVFlNdHUwTjl5Yk41OFJBY0dzS09taDAwYTZ1U1pE?=
 =?utf-8?B?azhJMXZxczcrRzlZSlpKVTNuQmpaMkRodFhOdy9TWExkUWpzWEZZd2MwSnkv?=
 =?utf-8?B?SmxtQUpzR3cxb0hQbCtoNTdSQ0h2MEM4RVdaTWpKbXo4N05wbjMwRFhrc3c3?=
 =?utf-8?B?UTN4VHN4NTZMMzZzZCs4TnFkanRydXJvelQ3cmQwa3B0Q1lJRCtDQXNscmU3?=
 =?utf-8?B?cVNadWMzdjFMR3gvajF6emtCcE1rWmJ6RVRoR2ZKeDJpRjF3ODZFZGZ3SzJZ?=
 =?utf-8?B?VTJmeEg1cXpsUjdhNzBsNXZmK0s4UEpYVnNUaGNXZm5FOGVRekl2SzlUTmZo?=
 =?utf-8?B?S1diaitJL0ZmWllHVTN4NmtMMFJiK1R2Mmhxd0JRdVlSeE1mT29BWGQ5MXBG?=
 =?utf-8?B?R0lxaFpXM25BTU5pN0h6SEtOOVkvMW1BbjU2bnNCaGZSY29NWS8vOXB3WGEr?=
 =?utf-8?B?RU81Sm00Vjh0cUJRcW0wV1VBZGhJb3FKUUd0Nnl0V1dvSHY4VEZyUmhIM0d1?=
 =?utf-8?B?R3NubDdvT0lxUmtkUExuZDlGQkdkdjJjR1dyL3p1N2REbFkrUUllMDBrNHo4?=
 =?utf-8?B?RExOVTZSbi9sNE43YXNwdU9jOW9lMEFhbnhoaUROTHNucmlscEJPdkFBaWpp?=
 =?utf-8?B?YU9Lclg3QzlJbThNMnRmeHNkQUNoWUlEUlFQUHdib1ZnUGFwK3lzTGJQUEdB?=
 =?utf-8?B?RlJhSGtaMXQvWmptSmY4SzRwVkdoS2tHRlJtb0ZBNUI1MU5ZSzcrTVFOUUwz?=
 =?utf-8?B?QzVWY2ZxN2tjZmthWEo0Tnh6NDZVaDNIbFY3VG12ZlgrN3czaE5HdFdYUkJO?=
 =?utf-8?B?bWVYQ3NtUlA4L2Jadkhrb3NmdW1BU2hrN0FIaXVwRFRBMytGamVDZitlVnhq?=
 =?utf-8?B?RVA5b2kwcnVTcS9lV2MrNzY5U1YzRSs5QWt0dnVUMTJucFVaVHROT2FYRk1s?=
 =?utf-8?B?MkI2MG1YQS9QMWdkMG9nSC9iVWhKdDVrakowMXBVbmJJWXh0RXc2MDlQNGhy?=
 =?utf-8?B?d2FzNDIyQWlMdzVKb1NwcmNoTWd1c0dNUjZJNURpN21FMU5XOWxGbWY4dVpJ?=
 =?utf-8?B?NTgzd0VhSCtDeVFTQmllK1h0dHZtZjRzOTl5UzJrUUhnQXBsdG8xMWpZaEsy?=
 =?utf-8?B?ZDlCWmRNaklKYWJBRHBTK1lWR3dQaTVmYy9zRUVja3FLVFM3bWF2VTEzZG81?=
 =?utf-8?B?Y1VsOHBXYlpqTG1ORzY3cHd2elg0RmtnYzNodVhrUmVCZG9ka3Fhek9kVGQ1?=
 =?utf-8?B?VjgyNm5LSXR0WEFqUHBtMDhkaDNwdlVMRVFzTlJIQkxha3pvdi9qQ3JseFFl?=
 =?utf-8?B?eHZzU29LZU5sSEVjdENTRS8vOTV3bjdoWEFDS0lpMWE3SnhjeGpkUkpvQ2lm?=
 =?utf-8?B?WnpwVWs1aUhjWllPYlhpVk82N0FSc0FUTi9uOUdhMFM1a3FKSWx6SmRSbjFi?=
 =?utf-8?B?azk3WndlL1lCK3BXVDBFdUI2a2pkUkx4OWtCV1pZOWJFN28rM3VjT3JrSytF?=
 =?utf-8?B?ZmdqZWxEcThndUVOR0M5TTZTZHRsKzRQR0UvQnQ3S2tCbzNobFJoYVlidCtT?=
 =?utf-8?Q?4KBsKFoLT8GGvt7o1Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cTF5QzM2WSthQTlrV2lHUjhWUktrSm5Sb0ZkOVZ6K2E4dmsxUDRnbHpEUm5G?=
 =?utf-8?B?a2ZiNWNEYzBBREFibGdzSVZXbVpoZGRTY3VuRzhtM1RoOHYwTnVWWDhRSGM4?=
 =?utf-8?B?RGZjYWNhcTArcEZndXRRK2dRTm9zdFdLK2VqOFdvMy84cS8xQk5RS2wvQnBQ?=
 =?utf-8?B?ODZJZDhSbTZSb0NwQnJDMFIybUhQOXQ4K25LVDloY2ZHYWtYMCtGV3JuVWI1?=
 =?utf-8?B?T20wK0RxV3ZIM1FzM1N2eUdtcVhIMjhyWkdqM3N1RVo5QlB0ZzdVTVRwYnRq?=
 =?utf-8?B?Y0hocjBCNGs1T2R2bVdGVzByWnN4WHVOT3BpUXowSmJ6Qm1QSUVWbEd1ZTZZ?=
 =?utf-8?B?TjRYNlVEcVZJMkZOenk4aStQQllhcVcyZFpKVDlrK2ZGRDd2Y04yT1FKRnJt?=
 =?utf-8?B?aDMzbnZEcW9VWGs5a2c5SlFtRjJnVDlSdktFMVU2dnM0TnpPVzRrSTcxNC8y?=
 =?utf-8?B?cmEwUGwxdnVWREpOK2dNV2xkNDBjbGhOeno5aFdNYzJjcGQ0MkpLRXFiQUdx?=
 =?utf-8?B?aTJNRFJIOTZLdzF0cWxEcDZiamdDMk54NVNrVEd4eVRVSENhRTFEODN4T0tJ?=
 =?utf-8?B?MXBoRGNwRVJaMFBIaStBSy9hMmtrcUZPZTVnNitaTmVKb09lNnJXN091WmNN?=
 =?utf-8?B?WHhPOTVkeEx0SktySTZjV3R2aXNPeXBIbG9FTGdtUzV5QTJ2bDZ4WUVpTEJ5?=
 =?utf-8?B?UzdxOVR0U1pBWXNVQW95d1JJeHNSa09zWE1LSDh5ckduMmZxUGM2OGJRaDMv?=
 =?utf-8?B?dTFRY0R3VDFYVFIxRGVjUlZxMGZ6V1pYZUZkcWVtbU1BWTM2VE1HQXczb29I?=
 =?utf-8?B?Uno3Q2dWTUxmUER2QkFYWEw1MG9DZ3RRc3BVS1gzWFkvbWYzeC9GblUvY3JM?=
 =?utf-8?B?VW1nVXIwYUxkeXB6eEczSU5sMlRjd0NubE0vdksyaWtwYy9iZUdDWXlXTVA0?=
 =?utf-8?B?aTBjazJsWldsc3MzOVVuZklJaksxNmZYc1drV2JzZVZUZUNibnFrQUxXQXVy?=
 =?utf-8?B?TzZTUEMyT28zcVNHNFMzL0MvWnladWlPWkhDclE4N1I1dFMvQTlWcENaeWVC?=
 =?utf-8?B?ZUswQ285Mm03dnJHM0lnNHFaSmpoM3phMVM3UG1lbE56WjNrYzhSb3Rockx4?=
 =?utf-8?B?MWR3dGNyMERweDJvVDlCMWJlRVdLMk5uQnJzMFh1ZWc4UGhJUjNBOWppa2Rz?=
 =?utf-8?B?WUVhUlJPdW9kZ2Y3eFJndFo1MWlzUzAvem5GemM2UzdHZFZucE14U0tYbGhC?=
 =?utf-8?B?SWdUWmlma1F6NmxwSEQ1aHU1UEthSVgrZi82eTVzNTNaRWd5U3BVb2YwTURx?=
 =?utf-8?B?NEFtMCtXT0thVWRxazE3Sm9rWi8yUnpCWm5tWGwzQUcyVVQ1OEJMTExQaCtm?=
 =?utf-8?B?V1dwalZodHRvbDVKSXoxcUtML0x3WG16KzVaNnh5dEJvQkdoQkd1M0dXZVU5?=
 =?utf-8?B?djZpaHVWUjlXVnpQRmh0NThaWU5LZHY5cGlJRTJqRUIvWFNIeU5PdmJMSU5Q?=
 =?utf-8?B?WVV3RUx4cm5keStkMXJTK2NFQ0k5bVRNVmJnUHdieUNwNlFZZFVzMEMzVE5t?=
 =?utf-8?B?UDNGZHVQNmVOanJpYmd0cnNaTUFqNW8rYVFPQjNkVExDR2h5UGQxbUp6RUU5?=
 =?utf-8?B?MmNtdkcrQlVnOXhGeVRqUjIrR1BvUEhFUWdjb09OMW1NK1BZQjN3bjNReFVB?=
 =?utf-8?B?bkQ1OVJ3UVp2amVDUlpYUlVkaVAreEFjR2lMRnQ2alhJdi90SzcxY3NRR3hl?=
 =?utf-8?B?SkM5d2tadXdEV1c3UUxDanRxcEJZVVJDOWMybnhPa1lObWpZazh2QnpwVG44?=
 =?utf-8?B?aFJ5amFKRHoxei9RK0p0T3FQUVp5Z0FCWnBqMG85WnUzQVQzQm1pNnp1eXZw?=
 =?utf-8?B?UUtmVW9uWUIzb3BFOWFRRnVJTUdNVUl6WWdOaXNBRXA5TWNrdlZsZEFvT1Zq?=
 =?utf-8?B?Qm03ZStwcEozWnBWR2hoVUVMbnQ0OWY3TnhSWGFHQTlHVFRzQzFReXlQc2tU?=
 =?utf-8?B?Z2NzVGVISHkxWWgzQWFrSGtHTnZ3QVpTS3BOelV6bTUxMmc5Y2lQZnJtVWlw?=
 =?utf-8?B?ODl5RXNKOFJaQXBUMkhhdFAyUzBONnhjdjZzbzJFQ3YwU3lzek1NeEZyUEI2?=
 =?utf-8?B?SXZkejlwaGxiRHAxNmxuTjRrM3g2Z1lsTDZPc1Y4anpISzQ4d3I0b3R2WjJz?=
 =?utf-8?B?OGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C51D408AC1E493429C1211D03F471F18@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dec4b39f-7e1a-4a3f-6e26-08dcec6e23be
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 16:34:56.9693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RKevkQ6IxvW5byk55BqTm9oYl9uv7dA/EQqZOxXInAiq2h2BsnqzaqB/z0pMdJvP8hw++YBtHMr3pd7plJ7C4zOH0kao9YApTIAj6s7fG5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4550
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTEwLTEyIGF0IDE2OjA5ICswODAwLCBrZXJuZWwgdGVzdCByb2JvdCB3cm90
ZToNCj4gdHJlZTrCoMKgIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92aXJ0L2t2bS9r
dm0uZ2l0wqBrdm0tY29jby1xdWV1ZQ0KPiBoZWFkOsKgwqAgZDJjNzY2MmE2ZWExYzMyNWE5YWU4
NzhiM2YxYTI2NTI2NGJjZDE4Yg0KPiBjb21taXQ6IGI2YmNkODhhZDQzYWViYzIzODVjN2ZmNDE4
YjA1MzJlODBlNjBlMTkgWzYyLzEwOV0gS1ZNOiB4ODYvdGRwX21tdTogUHJvcGFnYXRlIGJ1aWxk
aW5nIG1pcnJvciBwYWdlIHRhYmxlcw0KPiBjb25maWc6IHg4Nl82NC1yYW5kY29uZmlnLTEyMS0y
MDI0MTAxMSAoaHR0cHM6Ly9kb3dubG9hZC4wMS5vcmcvMGRheS1jaS9hcmNoaXZlLzIwMjQxMDEy
LzIwMjQxMDEyMTY0NC5FcTd6UkdQTy1sa3BAaW50ZWwuY29tL2NvbmZpZykNCj4gY29tcGlsZXI6
IGNsYW5nIHZlcnNpb24gMTguMS44IChodHRwczovL2dpdGh1Yi5jb20vbGx2bS9sbHZtLXByb2pl
Y3TCoDNiNWI1YzFlYzRhMzA5NWFiMDk2ZGQ3ODBlODRkN2FiODFmM2Q3ZmYpDQo+IHJlcHJvZHVj
ZSAodGhpcyBpcyBhIFc9MSBidWlsZCk6IChodHRwczovL2Rvd25sb2FkLjAxLm9yZy8wZGF5LWNp
L2FyY2hpdmUvMjAyNDEwMTIvMjAyNDEwMTIxNjQ0LkVxN3pSR1BPLWxrcEBpbnRlbC5jb20vcmVw
cm9kdWNlKQ0KPiANCj4gSWYgeW91IGZpeCB0aGUgaXNzdWUgaW4gYSBzZXBhcmF0ZSBwYXRjaC9j
b21taXQgKGkuZS4gbm90IGp1c3QgYSBuZXcgdmVyc2lvbiBvZg0KPiB0aGUgc2FtZSBwYXRjaC9j
b21taXQpLCBraW5kbHkgYWRkIGZvbGxvd2luZyB0YWdzDQo+ID4gUmVwb3J0ZWQtYnk6IGtlcm5l
bCB0ZXN0IHJvYm90IDxsa3BAaW50ZWwuY29tPg0KPiA+IENsb3NlczogaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvb2Uta2J1aWxkLWFsbC8yMDI0MTAxMjE2NDQuRXE3elJHUE8tbGtwQGludGVsLmNv
bS8NCj4gDQo+IHNwYXJzZSB3YXJuaW5nczogKG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+KQ0KPiA+
ID4gYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmM6NDc0OjE0OiBzcGFyc2U6IHNwYXJzZTogaW5j
b3JyZWN0IHR5cGUgaW4gYXJndW1lbnQgMSAoZGlmZmVyZW50IGFkZHJlc3Mgc3BhY2VzKSBAQMKg
wqDCoMKgIGV4cGVjdGVkIHZvaWQgY29uc3Qgdm9sYXRpbGUgKnYgQEDCoMKgwqDCoCBnb3QgdW5z
aWduZWQgbG9uZyBsb25nIFtub2RlcmVmXSBbdXNlcnR5cGVdIF9fcmN1ICpfX2FpX3B0ciBAQA0K
PiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jOjQ3NDoxNDogc3BhcnNlOsKgwqDCoMKg
IGV4cGVjdGVkIHZvaWQgY29uc3Qgdm9sYXRpbGUgKnYNCj4gwqDCoCBhcmNoL3g4Ni9rdm0vbW11
L3RkcF9tbXUuYzo0NzQ6MTQ6IHNwYXJzZTrCoMKgwqDCoCBnb3QgdW5zaWduZWQgbG9uZyBsb25n
IFtub2RlcmVmXSBbdXNlcnR5cGVdIF9fcmN1ICpfX2FpX3B0cg0KPiA+ID4gYXJjaC94ODYva3Zt
L21tdS90ZHBfbW11LmM6NDc0OjE0OiBzcGFyc2U6IHNwYXJzZTogY2FzdCByZW1vdmVzIGFkZHJl
c3Mgc3BhY2UgJ19fcmN1JyBvZiBleHByZXNzaW9uDQo+ID4gPiBhcmNoL3g4Ni9rdm0vbW11L3Rk
cF9tbXUuYzo0NzQ6MTQ6IHNwYXJzZTogc3BhcnNlOiBjYXN0IHJlbW92ZXMgYWRkcmVzcyBzcGFj
ZSAnX19yY3UnIG9mIGV4cHJlc3Npb24NCj4gPiA+IGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5j
OjQ3NDoxNDogc3BhcnNlOiBzcGFyc2U6IGNhc3QgcmVtb3ZlcyBhZGRyZXNzIHNwYWNlICdfX3Jj
dScgb2YgZXhwcmVzc2lvbg0KPiA+ID4gYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmM6NDc0OjE0
OiBzcGFyc2U6IHNwYXJzZTogY2FzdCByZW1vdmVzIGFkZHJlc3Mgc3BhY2UgJ19fcmN1JyBvZiBl
eHByZXNzaW9uDQo+ID4gPiBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYzo3NTQ6Mjk6IHNwYXJz
ZTogc3BhcnNlOiBpbmNvcnJlY3QgdHlwZSBpbiBhcmd1bWVudCAxIChkaWZmZXJlbnQgYWRkcmVz
cyBzcGFjZXMpIEBAwqDCoMKgwqAgZXhwZWN0ZWQgdW5zaWduZWQgbG9uZyBsb25nIFt1c2VydHlw
ZV0gKnNwdGVwIEBAwqDCoMKgwqAgZ290IHVuc2lnbmVkIGxvbmcgbG9uZyBbbm9kZXJlZl0gW3Vz
ZXJ0eXBlXSBfX3JjdSAqW3VzZXJ0eXBlXSBzcHRlcCBAQA0KPiDCoMKgIGFyY2gveDg2L2t2bS9t
bXUvdGRwX21tdS5jOjc1NDoyOTogc3BhcnNlOsKgwqDCoMKgIGV4cGVjdGVkIHVuc2lnbmVkIGxv
bmcgbG9uZyBbdXNlcnR5cGVdICpzcHRlcA0KPiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21t
dS5jOjc1NDoyOTogc3BhcnNlOsKgwqDCoMKgIGdvdCB1bnNpZ25lZCBsb25nIGxvbmcgW25vZGVy
ZWZdIFt1c2VydHlwZV0gX19yY3UgKlt1c2VydHlwZV0gc3B0ZXANCj4gwqDCoCBhcmNoL3g4Ni9r
dm0vbW11L3RkcF9tbXUuYzoxMjQ2OjI1OiBzcGFyc2U6IHNwYXJzZTogaW5jb3JyZWN0IHR5cGUg
aW4gYXJndW1lbnQgMSAoZGlmZmVyZW50IGFkZHJlc3Mgc3BhY2VzKSBAQMKgwqDCoMKgIGV4cGVj
dGVkIHVuc2lnbmVkIGxvbmcgbG9uZyBbdXNlcnR5cGVdICpzcHRlcCBAQMKgwqDCoMKgIGdvdCB1
bnNpZ25lZCBsb25nIGxvbmcgW25vZGVyZWZdIFt1c2VydHlwZV0gX19yY3UgKlthZGRyZXNzYWJs
ZV0gW3VzZXJ0eXBlXSBzcHRlcCBAQA0KPiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5j
OjEyNDY6MjU6IHNwYXJzZTrCoMKgwqDCoCBleHBlY3RlZCB1bnNpZ25lZCBsb25nIGxvbmcgW3Vz
ZXJ0eXBlXSAqc3B0ZXANCj4gwqDCoCBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYzoxMjQ2OjI1
OiBzcGFyc2U6wqDCoMKgwqAgZ290IHVuc2lnbmVkIGxvbmcgbG9uZyBbbm9kZXJlZl0gW3VzZXJ0
eXBlXSBfX3JjdSAqW2FkZHJlc3NhYmxlXSBbdXNlcnR5cGVdIHNwdGVwDQo+ID4gPiBhcmNoL3g4
Ni9rdm0vbW11L3RkcF9tbXUuYzo0NzQ6MTQ6IHNwYXJzZTogc3BhcnNlOiBkZXJlZmVyZW5jZSBv
ZiBub2RlcmVmIGV4cHJlc3Npb24NCj4gPiA+IGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jOjQ3
NDoxNDogc3BhcnNlOiBzcGFyc2U6IGRlcmVmZXJlbmNlIG9mIG5vZGVyZWYgZXhwcmVzc2lvbg0K
PiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jOjYxODozMzogc3BhcnNlOiBzcGFyc2U6
IGluY29ycmVjdCB0eXBlIGluIGFyZ3VtZW50IDEgKGRpZmZlcmVudCBhZGRyZXNzIHNwYWNlcykg
QEDCoMKgwqDCoCBleHBlY3RlZCB1bnNpZ25lZCBsb25nIGxvbmcgW3VzZXJ0eXBlXSAqc3B0ZXAg
QEDCoMKgwqDCoCBnb3QgdW5zaWduZWQgbG9uZyBsb25nIFtub2RlcmVmXSBbdXNlcnR5cGVdIF9f
cmN1ICpbdXNlcnR5cGVdIHNwdGVwIEBADQo+IMKgwqAgYXJjaC94ODYva3ZtL21tdS90ZHBfbW11
LmM6NjE4OjMzOiBzcGFyc2U6wqDCoMKgwqAgZXhwZWN0ZWQgdW5zaWduZWQgbG9uZyBsb25nIFt1
c2VydHlwZV0gKnNwdGVwDQo+IMKgwqAgYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmM6NjE4OjMz
OiBzcGFyc2U6wqDCoMKgwqAgZ290IHVuc2lnbmVkIGxvbmcgbG9uZyBbbm9kZXJlZl0gW3VzZXJ0
eXBlXSBfX3JjdSAqW3VzZXJ0eXBlXSBzcHRlcA0KPiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRw
X21tdS5jOiBub3RlOiBpbiBpbmNsdWRlZCBmaWxlICh0aHJvdWdoIGluY2x1ZGUvbGludXgvcmJ0
cmVlLmgsIGluY2x1ZGUvbGludXgvbW1fdHlwZXMuaCwgaW5jbHVkZS9saW51eC9tbXpvbmUuaCwg
Li4uKToNCj4gwqDCoCBpbmNsdWRlL2xpbnV4L3JjdXBkYXRlLmg6ODY5OjI1OiBzcGFyc2U6IHNw
YXJzZTogY29udGV4dCBpbWJhbGFuY2UgaW4gJ19fdGRwX21tdV96YXBfcm9vdCcgLSB1bmV4cGVj
dGVkIHVubG9jaw0KPiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jOjYxODozMzogc3Bh
cnNlOiBzcGFyc2U6IGluY29ycmVjdCB0eXBlIGluIGFyZ3VtZW50IDEgKGRpZmZlcmVudCBhZGRy
ZXNzIHNwYWNlcykgQEDCoMKgwqDCoCBleHBlY3RlZCB1bnNpZ25lZCBsb25nIGxvbmcgW3VzZXJ0
eXBlXSAqc3B0ZXAgQEDCoMKgwqDCoCBnb3QgdW5zaWduZWQgbG9uZyBsb25nIFtub2RlcmVmXSBb
dXNlcnR5cGVdIF9fcmN1ICpbdXNlcnR5cGVdIHNwdGVwIEBADQo+IMKgwqAgYXJjaC94ODYva3Zt
L21tdS90ZHBfbW11LmM6NjE4OjMzOiBzcGFyc2U6wqDCoMKgwqAgZXhwZWN0ZWQgdW5zaWduZWQg
bG9uZyBsb25nIFt1c2VydHlwZV0gKnNwdGVwDQo+IMKgwqAgYXJjaC94ODYva3ZtL21tdS90ZHBf
bW11LmM6NjE4OjMzOiBzcGFyc2U6wqDCoMKgwqAgZ290IHVuc2lnbmVkIGxvbmcgbG9uZyBbbm9k
ZXJlZl0gW3VzZXJ0eXBlXSBfX3JjdSAqW3VzZXJ0eXBlXSBzcHRlcA0KPiDCoMKgIGFyY2gveDg2
L2t2bS9tbXUvdGRwX21tdS5jOjYxODozMzogc3BhcnNlOiBzcGFyc2U6IGluY29ycmVjdCB0eXBl
IGluIGFyZ3VtZW50IDEgKGRpZmZlcmVudCBhZGRyZXNzIHNwYWNlcykgQEDCoMKgwqDCoCBleHBl
Y3RlZCB1bnNpZ25lZCBsb25nIGxvbmcgW3VzZXJ0eXBlXSAqc3B0ZXAgQEDCoMKgwqDCoCBnb3Qg
dW5zaWduZWQgbG9uZyBsb25nIFtub2RlcmVmXSBbdXNlcnR5cGVdIF9fcmN1ICpbdXNlcnR5cGVd
IHNwdGVwIEBADQo+IMKgwqAgYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmM6NjE4OjMzOiBzcGFy
c2U6wqDCoMKgwqAgZXhwZWN0ZWQgdW5zaWduZWQgbG9uZyBsb25nIFt1c2VydHlwZV0gKnNwdGVw
DQo+IMKgwqAgYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmM6NjE4OjMzOiBzcGFyc2U6wqDCoMKg
wqAgZ290IHVuc2lnbmVkIGxvbmcgbG9uZyBbbm9kZXJlZl0gW3VzZXJ0eXBlXSBfX3JjdSAqW3Vz
ZXJ0eXBlXSBzcHRlcA0KPiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jOjYxODozMzog
c3BhcnNlOiBzcGFyc2U6IGluY29ycmVjdCB0eXBlIGluIGFyZ3VtZW50IDEgKGRpZmZlcmVudCBh
ZGRyZXNzIHNwYWNlcykgQEDCoMKgwqDCoCBleHBlY3RlZCB1bnNpZ25lZCBsb25nIGxvbmcgW3Vz
ZXJ0eXBlXSAqc3B0ZXAgQEDCoMKgwqDCoCBnb3QgdW5zaWduZWQgbG9uZyBsb25nIFtub2RlcmVm
XSBbdXNlcnR5cGVdIF9fcmN1ICpbdXNlcnR5cGVdIHNwdGVwIEBADQo+IMKgwqAgYXJjaC94ODYv
a3ZtL21tdS90ZHBfbW11LmM6NjE4OjMzOiBzcGFyc2U6wqDCoMKgwqAgZXhwZWN0ZWQgdW5zaWdu
ZWQgbG9uZyBsb25nIFt1c2VydHlwZV0gKnNwdGVwDQo+IMKgwqAgYXJjaC94ODYva3ZtL21tdS90
ZHBfbW11LmM6NjE4OjMzOiBzcGFyc2U6wqDCoMKgwqAgZ290IHVuc2lnbmVkIGxvbmcgbG9uZyBb
bm9kZXJlZl0gW3VzZXJ0eXBlXSBfX3JjdSAqW3VzZXJ0eXBlXSBzcHRlcA0KPiDCoMKgIGFyY2gv
eDg2L2t2bS9tbXUvdGRwX21tdS5jOjE1MzY6MzM6IHNwYXJzZTogc3BhcnNlOiBjb250ZXh0IGlt
YmFsYW5jZSBpbiAndGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3QnIC0gdW5leHBlY3RlZCB1
bmxvY2sNCj4gwqDCoCBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYzo2MTg6MzM6IHNwYXJzZTog
c3BhcnNlOiBpbmNvcnJlY3QgdHlwZSBpbiBhcmd1bWVudCAxIChkaWZmZXJlbnQgYWRkcmVzcyBz
cGFjZXMpIEBAwqDCoMKgwqAgZXhwZWN0ZWQgdW5zaWduZWQgbG9uZyBsb25nIFt1c2VydHlwZV0g
KnNwdGVwIEBAwqDCoMKgwqAgZ290IHVuc2lnbmVkIGxvbmcgbG9uZyBbbm9kZXJlZl0gW3VzZXJ0
eXBlXSBfX3JjdSAqW3VzZXJ0eXBlXSBzcHRlcCBAQA0KPiDCoMKgIGFyY2gveDg2L2t2bS9tbXUv
dGRwX21tdS5jOjYxODozMzogc3BhcnNlOsKgwqDCoMKgIGV4cGVjdGVkIHVuc2lnbmVkIGxvbmcg
bG9uZyBbdXNlcnR5cGVdICpzcHRlcA0KPiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5j
OjYxODozMzogc3BhcnNlOsKgwqDCoMKgIGdvdCB1bnNpZ25lZCBsb25nIGxvbmcgW25vZGVyZWZd
IFt1c2VydHlwZV0gX19yY3UgKlt1c2VydHlwZV0gc3B0ZXANCj4gwqDCoCBhcmNoL3g4Ni9rdm0v
bW11L3RkcF9tbXUuYzo2MTg6MzM6IHNwYXJzZTogc3BhcnNlOiBpbmNvcnJlY3QgdHlwZSBpbiBh
cmd1bWVudCAxIChkaWZmZXJlbnQgYWRkcmVzcyBzcGFjZXMpIEBAwqDCoMKgwqAgZXhwZWN0ZWQg
dW5zaWduZWQgbG9uZyBsb25nIFt1c2VydHlwZV0gKnNwdGVwIEBAwqDCoMKgwqAgZ290IHVuc2ln
bmVkIGxvbmcgbG9uZyBbbm9kZXJlZl0gW3VzZXJ0eXBlXSBfX3JjdSAqW3VzZXJ0eXBlXSBzcHRl
cCBAQA0KPiDCoMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jOjYxODozMzogc3BhcnNlOsKg
wqDCoMKgIGV4cGVjdGVkIHVuc2lnbmVkIGxvbmcgbG9uZyBbdXNlcnR5cGVdICpzcHRlcA0KPiDC
oMKgIGFyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jOjYxODozMzogc3BhcnNlOsKgwqDCoMKgIGdv
dCB1bnNpZ25lZCBsb25nIGxvbmcgW25vZGVyZWZdIFt1c2VydHlwZV0gX19yY3UgKlt1c2VydHlw
ZV0gc3B0ZXANCg0KSSB0aGluayB3ZSBuZWVkIHNvbWV0aGluZyBsaWtlIHRoZSBiZWxvdy4gVGhl
IGZpcnN0IGh1bmsgbmVlZHMgdG8gdGFyZ2V0Og0KNzBjYWFjMjgzZmIzMCBLVk06IHg4Ni9tbXU6
IEFkZCBhbiBpc19taXJyb3IgbWVtYmVyIGZvciB1bmlvbiBrdm1fbW11X3BhZ2Vfcm9sZQ0KYW5k
IHRoZSBzZWNvbmQ6DQoxNjFkNGY3YzZkODBlIEtWTTogeDg2L3RkcF9tbXU6IFByb3BhZ2F0ZSBi
dWlsZGluZyBtaXJyb3IgcGFnZSB0YWJsZXMNCg0KU2hvdWxkIHdlIHNlbmQgc29tZSBwcm9wZXIg
Zml4dXAgcGF0Y2hlcz8NCg0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvc3B0ZS5oIGIv
YXJjaC94ODYva3ZtL21tdS9zcHRlLmgNCmluZGV4IGE3MmYwZTNiZGUxNzMuLjVkMzBkNTliZWRm
YzAgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3NwdGUuaA0KKysrIGIvYXJjaC94ODYv
a3ZtL21tdS9zcHRlLmgNCkBAIC0yNjcsOSArMjY3LDkgQEAgc3RhdGljIGlubGluZSBzdHJ1Y3Qg
a3ZtX21tdV9wYWdlICpyb290X3RvX3NwKGhwYV90IHJvb3QpDQogICAgICAgIHJldHVybiBzcHRl
X3RvX2NoaWxkX3NwKHJvb3QpOw0KIH0NCiANCi1zdGF0aWMgaW5saW5lIGJvb2wgaXNfbWlycm9y
X3NwdGVwKHU2NCAqc3B0ZXApDQorc3RhdGljIGlubGluZSBib29sIGlzX21pcnJvcl9zcHRlcCh0
ZHBfcHRlcF90IHNwdGVwKQ0KIHsNCi0gICAgICAgcmV0dXJuIGlzX21pcnJvcl9zcChzcHRlcF90
b19zcChzcHRlcCkpOw0KKyAgICAgICByZXR1cm4gaXNfbWlycm9yX3NwKHNwdGVwX3RvX3NwKHJj
dV9kZXJlZmVyZW5jZSgoc3B0ZXApKSkpOw0KIH0NCiANCiBzdGF0aWMgaW5saW5lIGJvb2wgaXNf
bW1pb19zcHRlKHN0cnVjdCBrdm0gKmt2bSwgdTY0IHNwdGUpDQpkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL21tdS90ZHBfbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KaW5kZXgg
MDE5YjQzNzIzZDkwMS4uNzY1MTJlMDVlMzFmMiAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9t
bXUvdGRwX21tdS5jDQorKysgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KQEAgLTUxMSw3
ICs1MTEsNyBAQCBzdGF0aWMgaW50IF9fbXVzdF9jaGVjayBzZXRfZXh0ZXJuYWxfc3B0ZV9wcmVz
ZW50KHN0cnVjdCBrdm0NCiprdm0sIHRkcF9wdGVwX3Qgc3ANCiAgICAgICAgICogcGFnZSB0YWJs
ZSBoYXMgYmVlbiBtb2RpZmllZC4gVXNlIEZST1pFTl9TUFRFIHNpbWlsYXIgdG8NCiAgICAgICAg
ICogdGhlIHphcHBpbmcgY2FzZS4NCiAgICAgICAgICovDQotICAgICAgIGlmICghdHJ5X2NtcHhj
aGc2NChzcHRlcCwgJm9sZF9zcHRlLCBGUk9aRU5fU1BURSkpDQorICAgICAgIGlmICghdHJ5X2Nt
cHhjaGc2NChyY3VfZGVyZWZlcmVuY2Uoc3B0ZXApLCAmb2xkX3NwdGUsIEZST1pFTl9TUFRFKSkN
CiAgICAgICAgICAgICAgICByZXR1cm4gLUVCVVNZOw0KIA0KICAgICAgICAvKg0KDQoNCg==

