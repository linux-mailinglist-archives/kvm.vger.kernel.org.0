Return-Path: <kvm+bounces-15588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF028ADB8D
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 03:34:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C2CB1F22D1F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 01:34:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1470F12E75;
	Tue, 23 Apr 2024 01:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VjLpjn9i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6301DDB8;
	Tue, 23 Apr 2024 01:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713836063; cv=fail; b=JnLXG7sbnpB/mTd0i7sowhvq8BprieNrI9efnc1WBajUyIaDGs83yy2xHTU9EPNrtYI9bxb9GhDu0LlbmVZ23y5YHY2pDKI0Lvk3RgFC8Y5jYuXlFSN3rm5TfSjOMEpseDmWfZHOXL3B+0D7P7H2ukYUwLFpwNKOz4O8EFYk/EQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713836063; c=relaxed/simple;
	bh=aageevEMYWcYuoJJUjEvOq3EC4Mo0Nk+/iAlJNgIWV4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DmVdn+srAomVVxjrys1gxEcld6o87NvfsoZkNKYqSx3nSdMwhjMrCiF4A3stjpMD4JD4KzGOIq1FIO0/gdMnaL5KC3xzU2ExNyzUo69CI0QR1JDr5w9XetgC6gCB8Z4VNjRdORIPlS7IErl9kQQhi2XVFU8/380VzJ93vYiPVAI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VjLpjn9i; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713836062; x=1745372062;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aageevEMYWcYuoJJUjEvOq3EC4Mo0Nk+/iAlJNgIWV4=;
  b=VjLpjn9iDa9ovjq8mp93i40UAkSzHFcLcuWqu7ON2FcMF9zrHIlY/do2
   9QCGcmktsJethlwjAnjF7W/jUJnFkhVqMdts20vumRK0MgZV7cvrCUuLW
   Rfs7PnhtmNtJN7V5z5EvxxRsEaH+jiuBnEOlcenUenowwFzo9i2RQdr18
   wzhAn4+pRHhklag5hAoOsdvS+vHzVV0n8vxu6TjTMkJMditgO93l9HjwH
   4iYSNvxE8t9VI3gR/nAKT9Jyb9Lb0Kg1X6+jSRC8eyf2wxvbXIt/VvoV/
   KiV1eLg7sOVEbkjvxwKi/R+wdgK5FHSZaKwm7xE/C0R8yHuU5KDYtpUKM
   A==;
X-CSE-ConnectionGUID: UuUzrvFoR+WB96v1wdZhHA==
X-CSE-MsgGUID: uDHGDtrYSSufLb5zws7bkg==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9269222"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9269222"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 18:34:21 -0700
X-CSE-ConnectionGUID: k03M3Q2bSvOYcBjrHOh41Q==
X-CSE-MsgGUID: KofzUsdHRhOUmg6XT4CzoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="28719539"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 18:34:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 18:34:20 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 18:34:19 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 18:34:19 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 18:34:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XpGHPd/TEXY8i4pr7VyCLrpNYVkWsIPHJ0ccome361SURRsPyKMwmvLEESRMMYhL7ZiKPzkzOaiFNcfxHQjKpWu9kzaAUKryaspM0z/InAhafHzYZkNpgMqRQNGiNR4HUVYLtD9XDD41+2DJJ2/QQEvWBy8JBapq9t+JF/Tryh6zvELaoP3PoQsiu2Sukydy7MjB66gpfoBEZcG6XrEnh89+Gdkq4sHe+u9eP4XmbwhtffUzHtZ1vm+TeV0PFCyVdg0WvqbLvPDlJyqfy9j1A7mSxZC6uHyl0L0mV9Mb5kisXrDbrAzHL5Rnl8dUGlLy47NOM7AvK/QhDOgIIsgOXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aageevEMYWcYuoJJUjEvOq3EC4Mo0Nk+/iAlJNgIWV4=;
 b=Du2wH6k/ySw3X+ikbW1IxX0Y6LTFnkqywFCSkPlnS1N/8XAFuB+l8NF21wZT+K+LMiQvB6p2uKV7OosxLU3a0gs3wfej3uPMsFc4UvLJftdDTblW4hmMmJ7n9ehpXS54NyMaCSnNQ4fUsKnmhTMQbgh7q2QaZlor4XCg1WJVc+JJ+NySOATrR8PGak7ECbXEAfvi/XD42jGj1p3PJY6Jxuarlr0x4Hnk0WUnma/YWM5R8QFrPsW9gv2EqLEN4yy31f8DFjLQgXr/oUWxU1xub3Es/sf4IXucLntaIGWDJeVCZBkrvVMn7AVB3t8H9njQvgkskCS85x5q/J2hro/xmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB7137.namprd11.prod.outlook.com (2603:10b6:806:2a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20; Tue, 23 Apr
 2024 01:34:10 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.018; Tue, 23 Apr 2024
 01:34:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAA==
Date: Tue, 23 Apr 2024 01:34:10 +0000
Message-ID: <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
References: <Zh_exbWc90khzmYm@google.com>
	 <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
	 <ZiBc13qU6P3OBn7w@google.com>
	 <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
	 <ZiEulnEr4TiYQxsB@google.com>
	 <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
	 <ZiKoqMk-wZKdiar9@google.com>
	 <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
	 <ZiaWMpNm30DD1A-0@google.com>
	 <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
In-Reply-To: <Zib76LqLfWg3QkwB@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB7137:EE_
x-ms-office365-filtering-correlation-id: 5abd6782-5334-4f08-95a6-08dc63357992
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?dGxQbGRXV05DMVdPTXpMSGgyNTQ2b0hYT29HWE0yWXpISUNROWM4enZMWmdM?=
 =?utf-8?B?T2VRREF5MTJiQ0RiaWN1Y1hhemprWUNYUnRtTXowK29QQWNLT1JJcmg1bFBK?=
 =?utf-8?B?QVZhSUZLR1VacDVpOFRoUHNHd2N1ck8zd3h4cmFhUnp3NlN5R3k2YnB3MTlx?=
 =?utf-8?B?WU9NaElsZ29EaU1yamtkUm9MVEZKSXl2bWkzemxMcUJGdE9KdUZLMW5HWTRN?=
 =?utf-8?B?R2xMYndVZTY1aWVOQmpLM1l3cVZQOEduR3IwZWJuTEtkSFZSVW5KeHhNNzA1?=
 =?utf-8?B?eEUxNTNlZlNwd0xYQk5CVWNHK1F3NktIYjF1YmZZQmowWnFtUHBGbHBXWFpQ?=
 =?utf-8?B?NkgrRFZjTUhrSjNIcDgxM1dWcWtQZ2xVSVFNT2ZTV3V1cjJQZnA5ei9zUHBN?=
 =?utf-8?B?NlEzNUZGSVd3UFdMOXVvMThLb0F1RjBGRVcrUitJeGQybk1MWVlPTVcza1JP?=
 =?utf-8?B?NjJ0SWZEM0NEdWYvT2dqcFFxUmZXeDMxbUNaNzdJSjVPSW5DS01vbjJYYVFL?=
 =?utf-8?B?eUJtNHdpeHJaM0xoVVNEeVBMYTZtMEFZRWFTRXBZMUxDZ3k1RFcybDNZT2pN?=
 =?utf-8?B?TklUV2hYTGJqdFg4RG1saXpzejFWVXhTcTA0RzdqMFk1ZC9HSy9kbGJ5OENt?=
 =?utf-8?B?Yjd4VmhzRWpTTnlMR3Q0bDYvcTZUMmVXK2ZyZkpiSmV1U2xxb25yd3ZtYThS?=
 =?utf-8?B?cnZjQXN2TjhiUGpEdVNpbTdDWTVWcmZxTnhuSHhwS2lqeFlxMjVNNVhESFI1?=
 =?utf-8?B?bTM1NmpCL2VEM21OeFNkb2FNbERwMm9pRmJ2RjFRZjM5ekZKVDBiUkVIMkZ0?=
 =?utf-8?B?eGd3cHpXei9zMVdON0tYYXZ2eWF1SnJGblFFVzJ4a1pGOXJLVjBCUzFNTHgx?=
 =?utf-8?B?U3NhWEJ6eEtBQVpHQjE5SnplMXR6WU16RWlrQ2hnMHAvNU1rSjFzcEE3aHQz?=
 =?utf-8?B?aVFZSWtNaWhPZ3RDeHBLZytXb01udFgvRkk2a3didU9mRjkwblQ1WU4rTEJY?=
 =?utf-8?B?REtZN0dDcllSVXU4enVPZEVoWmNZNWV6L0txMkRsaUQwbTdBNEJQY0l1cno1?=
 =?utf-8?B?SUJpMVc2U25sZnBHWWQ4TTRzZDZTQjk3ZzhBU1Bib3ZLMGpsbkthWVhGMHhm?=
 =?utf-8?B?K1ZiQjhQNG54L0podktWYkNBU2ViVHFsb3k0bCttQjZPUFpVVVJGVjZYZ1Qr?=
 =?utf-8?B?NFhIbDhmOHUxeUNBT25ReEdKTVNoa2EvZW9HOVVtNzZ3alhiQnVaZVUzQlZY?=
 =?utf-8?B?cG1BdG5ScXFDTkt3NXZaQ216QzNUdjZsd3JCb1FvK0c2ckowajlSQ3pLcDVo?=
 =?utf-8?B?RldCK2pNSUN1WjI4VTZZWnNoem42N2JubXNiZWlZZVB6eGNXVXA2bG8rUkI4?=
 =?utf-8?B?UXdCZWhOdDBxcWVqMHpleThzTElaY01WdktmZFpWWHhrN3ZYYjZZUkNGdlpa?=
 =?utf-8?B?cE5yWUxlKy9xbGVGRmYwemRUUi9DcEtMM29naTBqYzdwbXpndlJNc1A1bkhh?=
 =?utf-8?B?MkxERVVnd05jNzFCSzdlVEE2enc5aThhclZuODVaMHZZZnIyRy9pbTdMRzlR?=
 =?utf-8?B?cFoxU3ltM1lYemxqblN4Vzk5eTEvQjliVkhsM2dMMlo1Q2ZJM2RlRGdwazJB?=
 =?utf-8?B?KzA0U3Ztb2ZEWkpzYzdNdS9ndEdHTllTejM1QmZPbFVPeXdRZ29hOGFKUXh3?=
 =?utf-8?B?bGhVNmovK2xodmZ5MU42Qm1jbVpnejNQMDl6bGg5WFZQK2ZpZFNxZ0VVSk9x?=
 =?utf-8?Q?Ihi03C35SZ6Yux1ag4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUJCeXoyaERLZVhhb0ttMnloS0EvSnpQVzJva3V3OVArekt1VCtNbk1wVTBH?=
 =?utf-8?B?VDJlZFMxOVJuWmlXRTRGQ1VMcWQyQWN5ZW45cU81aVZTZndTK3ZwQVFmSTZ5?=
 =?utf-8?B?MXE3cDJqaXBQcVFrVHF4TFBqaW9UZllQQTVIRzI4alVXMjJLcTRYZS9GYzJ6?=
 =?utf-8?B?SG1jaEJzVXFqdzNZSXBuTXQyUHpPTjhEUzhmZnVtOXM3NlZCcWRPVGs4QjB0?=
 =?utf-8?B?aldJVGpLc3NvZjBQVkk2cFRzNE5vYlIySzRYMWszL2RuWXpWTExvcHBEbnJM?=
 =?utf-8?B?V2RpK1JidkVYQlE0NGlBV20vNmVaWFlEdFFycFV3NFZpQjZkb0hzUUs5eHJx?=
 =?utf-8?B?OEVoN2xXaUltd1F0dnY5V2k1NVVadzdGblgwTGRybU9JbUR2QWdQcCtFZXQ5?=
 =?utf-8?B?a1NkWDhTbGcvSldrMlNid1NwUXh3K0grdGQ0RVh3eld4NkxHcm5KTlpDNWpO?=
 =?utf-8?B?aVc5ZFN4Q2hvN0ZNUUljTHZZMG9ISlJ1Q1UxMjNRbjBVUmRmMGgxUXNZc2w1?=
 =?utf-8?B?bTNXSm45WnRhcGJySlU4L3R0VFV0ZktCMkM1L2hZalhZc1Q4NG9iWGNVMG9R?=
 =?utf-8?B?bmtCUXd3aEtUUXM5VXl5Zkl5Y3pWVWlNSjhIRVBDODdCVHh1dFFRNE9xd2ZO?=
 =?utf-8?B?cFJEalJXM29keGl3cmMvSWR2ZjhQOEpvWVdqZW5NeGdaUnFMZG5SNU9mckxj?=
 =?utf-8?B?NmZRdlphaTNCK24yRHVBTGZpcG03cXI2S2ExSVA2cUt3bmxPdkt2YXlMckpB?=
 =?utf-8?B?QjVBWVdjVFJWRUx5UExhaWhMbWpEdFVHWkpldnZLV25oWWR0R2NSalpST3RQ?=
 =?utf-8?B?U0o5bVVmWER4NVphS3MzQnFCMUhEdVdyaURpTE1jbXBRcXpDTFdaZnlseTl4?=
 =?utf-8?B?R21oQ0NCWThXQXRHeHNVWkRPV25NVERRck9QZ0hreWdVOHozNjFvRXlYcDg2?=
 =?utf-8?B?YVpOeW9HOHBXUVZwWWE5T3AxeUhZeGMreG9pTjdaQ3F1K3Vja1d1ZVBJRTMv?=
 =?utf-8?B?aU0zNGN0ekZielRDK29SNGdyTnpWQ284Y2xITkRrZzVKWnFNeDdaQkpkZWFZ?=
 =?utf-8?B?R0xRcTFlTUFLOXZpOEdRT3pFa1BxVWRLWW03eXJrOTl6eTdCNERaZFhvcktP?=
 =?utf-8?B?a3JVYUpGdTE5a1RDbE5odlk4TGxpTUhhQUN4enpmV3pPclRqUUt5QVFsbFRG?=
 =?utf-8?B?U0ZQTzNId1NHbE5SSDBjZUw5U05kVG1jYUd4ZXZ2Zlpucm0xaXdzQ0x4bTZL?=
 =?utf-8?B?b3ZJMFBncVovVUtOSUZJSldDYmZyT0wybXU5Z0ozZ2RKN2NmY0MyUGZRWEN5?=
 =?utf-8?B?dFR0Z3Bac2NPb2MrQVJiT2xSUjBWY2JHM1JvMHIvM3Q2UjlQNzZHOVgwa1Nx?=
 =?utf-8?B?UlMrejFReUtZMUtBQnFwV290d1lQZWI5RUVHNXRBQmZKNTM0MVZoMUJLRmhE?=
 =?utf-8?B?YXk1OGlVb0JzTEN3ajJhVGd5ZE0wbklYbC9pM0IzTVMxOWE1YnpWVEM4czhy?=
 =?utf-8?B?SkljSG1zdTlhdytTcHVDb3QyeExnTkpnM213bWpEZUZJU3JjcVFtc1d4Tlk5?=
 =?utf-8?B?V3NlR2hvL0M0bEpONk40bnMwSml1SDdDUmRvSG9QalZPalhkajRNaFVUb1dP?=
 =?utf-8?B?dHU3VUcwV1JWMTNmdEpSTXlwSERucnJ6UlZZYWtMalI5UWl3VWxENTBYZFZW?=
 =?utf-8?B?ZllWWnplemU5WFo3Rmp2QVpPSlJ2MVdrR2RoV1k4MUhzb3I5WExWNU9Iby9r?=
 =?utf-8?B?L2l3bld5TktBY2ZPQ0dCY1ZZZmRxamFMWWlnVTAyRXJFZS9WQXoxUktoY1hz?=
 =?utf-8?B?MHV3RGN2emd5c3R4NUNJaTBqMm4waHorVUxqUDYvZVk3WTc2ZCtyK1lUKzBI?=
 =?utf-8?B?NE1hWlhKTkxMeGpxeU1hRGxIODJZdFdQNVh5VVd5YjRRUjVaL3d6dTZaS1Er?=
 =?utf-8?B?aW5mc1drY3BFRnpKNGRFdjNGdzlYM0NMb1Q5dUNXWVhpT2ZSTTBxOUJjSDRs?=
 =?utf-8?B?aDdPN1BEZnMyNFgvV0laOFRsNzBFYURtR0tRTTZJQmM1SnM2aDl0dGRMY3Nr?=
 =?utf-8?B?NDhLYzZvRHBQcElyb1FnVEFQMEZUVTlYRnZ1L2xOTzR3cml0NFNJSkZKbGQ3?=
 =?utf-8?B?TTN5WmQ0cndKRDJuRmsyYStqOVlsaUtWazdtNkpkNHExMVRSZm4rdkhBeEpU?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <252696B1782DFD48BF8935EC6FF6B7D3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abd6782-5334-4f08-95a6-08dc63357992
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 01:34:10.3248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9mmxj3wtOKcq/fXsnr8ve/lBun0oCoR28/w+eopcEsyRRkPstJXwsokukizWZKo3fBO9Wyu2lT9V1ngm3KQyVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7137
X-OriginatorOrg: intel.com

DQo+IA0KPiA+ID4gQW5kIHRoZSBpbnRlbnQgaXNuJ3QgdG8gY2F0Y2ggZXZlcnkgcG9zc2libGUg
cHJvYmxlbS4gIEFzIHdpdGggbWFueSBzYW5pdHkgY2hlY2tzLA0KPiA+ID4gdGhlIGludGVudCBp
cyB0byBkZXRlY3QgdGhlIG1vc3QgbGlrZWx5IGZhaWx1cmUgbW9kZSB0byBtYWtlIHRyaWFnaW5n
IGFuZCBkZWJ1Z2dpbmcNCj4gPiA+IGlzc3VlcyBhIGJpdCBlYXNpZXIuDQo+ID4gDQo+ID4gVGhl
IFNFQU1DQUxMIHdpbGwgbGl0ZXJhbGx5IHJldHVybiBhIHVuaXF1ZSBlcnJvciBjb2RlIHRvIGlu
ZGljYXRlIENQVQ0KPiA+IGlzbid0IGluIHBvc3QtVk1YT04sIG9yIHRkeF9jcHVfZW5hYmxlKCkg
aGFzbid0IGJlZW4gZG9uZS4gIEkgdGhpbmsgdGhlDQo+ID4gZXJyb3IgY29kZSBpcyBhbHJlYWR5
IGNsZWFyIHRvIHBpbnBvaW50IHRoZSBwcm9ibGVtIChkdWUgdG8gdGhlc2UgcHJlLQ0KPiA+IFNF
QU1DQUxMLWNvbmRpdGlvbiBub3QgYmVpbmcgbWV0KS4NCj4gDQo+IE5vLCBTRUFNQ0FMTCAjVURz
IGlmIHRoZSBDUFUgaXNuJ3QgcG9zdC1WTVhPTi4gIEkuZS4gdGhlIENQVSBkb2Vzbid0IG1ha2Ug
aXQgdG8NCj4gdGhlIFREWCBNb2R1bGUgdG8gcHJvdmlkZSBhIHVuaXF1ZSBlcnJvciBjb2RlLCBh
bGwgS1ZNIHdpbGwgc2VlIGlzIGEgI1VELg0KDQojVUQgaXMgaGFuZGxlZCBieSB0aGUgU0VBTUNB
TEwgYXNzZW1ibHkgY29kZS4gIFBsZWFzZSBzZWUgVERYX01PRFVMRV9DQUxMDQphc3NlbWJseSBt
YWNybzoNCg0KLkxzZWFtY2FsbF90cmFwXEA6DQogICAgICAgIC8qDQogICAgICAgICAqIFNFQU1D
QUxMIGNhdXNlZCAjR1Agb3IgI1VELiAgQnkgcmVhY2hpbmcgaGVyZSBSQVggY29udGFpbnMNCiAg
ICAgICAgICogdGhlIHRyYXAgbnVtYmVyLiAgQ29udmVydCB0aGUgdHJhcCBudW1iZXIgdG8gdGhl
IFREWCBlcnJvcg0KICAgICAgICAgKiBjb2RlIGJ5IHNldHRpbmcgVERYX1NXX0VSUk9SIHRvIHRo
ZSBoaWdoIDMyLWJpdHMgb2YgUkFYLg0KICAgICAgICAgKg0KICAgICAgICAgKiBOb3RlIGNhbm5v
dCBPUiBURFhfU1dfRVJST1IgZGlyZWN0bHkgdG8gUkFYIGFzIE9SIGluc3RydWN0aW9uDQogICAg
ICAgICAqIG9ubHkgYWNjZXB0cyAzMi1iaXQgaW1tZWRpYXRlIGF0IG1vc3QuDQogICAgICAgICAq
Lw0KICAgICAgICBtb3ZxICRURFhfU1dfRVJST1IsICVyZGkNCiAgICAgICAgb3JxICAlcmRpLCAl
cmF4DQoNCgkuLi4NCiAgICAgIMKgDQoJX0FTTV9FWFRBQkxFX0ZBVUxUKC5Mc2VhbWNhbGxcQCwg
LkxzZWFtY2FsbF90cmFwXEApDQouZW5kaWYgIC8qIFxob3N0ICovDQoNCj4gDQo+ID4gPiA+IEJ0
dywgSSBub3RpY2VkIHRoZXJlJ3MgYW5vdGhlciBwcm9ibGVtLCB0aGF0IGlzIGN1cnJlbnRseSB0
ZHhfY3B1X2VuYWJsZSgpDQo+ID4gPiA+IGFjdHVhbGx5IHJlcXVpcmVzIElSUSBiZWluZyBkaXNh
YmxlZC4gIEFnYWluIGl0IHdhcyBpbXBsZW1lbnRlZCBiYXNlZCBvbg0KPiA+ID4gPiBpdCB3b3Vs
ZCBiZSBpbnZva2VkIHZpYSBib3RoIG9uX2VhY2hfY3B1KCkgYW5kIGt2bV9vbmxpbmVfY3B1KCku
DQo+ID4gPiA+IA0KPiA+ID4gPiBJdCBhbHNvIGFsc28gaW1wbGVtZW50ZWQgd2l0aCBjb25zaWRl
cmF0aW9uIHRoYXQgaXQgY291bGQgYmUgY2FsbGVkIGJ5DQo+ID4gPiA+IG11bHRpcGxlIGluLWtl
cm5lbCBURFggdXNlcnMgaW4gcGFyYWxsZWwgdmlhIGJvdGggU01QIGNhbGwgYW5kIGluIG5vcm1h
bA0KPiA+ID4gPiBjb250ZXh0LCBzbyBpdCB3YXMgaW1wbGVtZW50ZWQgdG8gc2ltcGx5IHJlcXVl
c3QgdGhlIGNhbGxlciB0byBtYWtlIHN1cmUNCj4gPiA+ID4gaXQgaXMgY2FsbGVkIHdpdGggSVJR
IGRpc2FibGVkIHNvIGl0IGNhbiBiZSBJUlEgc2FmZSAgKGl0IHVzZXMgYSBwZXJjcHUNCj4gPiA+
ID4gdmFyaWFibGUgdG8gdHJhY2sgd2hldGhlciBUREguU1lTLkxQLklOSVQgaGFzIGJlZW4gZG9u
ZSBmb3IgbG9jYWwgY3B1DQo+ID4gPiA+IHNpbWlsYXIgdG8gdGhlIGhhcmR3YXJlX2VuYWJsZWQg
cGVyY3B1IHZhcmlhYmxlKS4NCj4gPiA+IA0KPiA+ID4gSXMgdGhpcyBpcyBhbiBhY3R1YWwgcHJv
YmxlbSwgb3IgaXMgaXQganVzdCBzb21ldGhpbmcgdGhhdCB3b3VsZCBuZWVkIHRvIGJlDQo+ID4g
PiB1cGRhdGVkIGluIHRoZSBURFggY29kZSB0byBoYW5kbGUgdGhlIGNoYW5nZSBpbiBkaXJlY3Rp
b24/DQo+ID4gDQo+ID4gRm9yIG5vdyB0aGlzIGlzbid0LCBiZWNhdXNlIEtWTSBpcyB0aGUgc29s
byB1c2VyLCBhbmQgaW4gS1ZNDQo+ID4gaGFyZHdhcmVfZW5hYmxlX2FsbCgpIGFuZCBrdm1fb25s
aW5lX2NwdSgpIHVzZXMga3ZtX2xvY2sgbXV0ZXggdG8gbWFrZQ0KPiA+IGhhcmR3YXJlX2VuYWJs
ZV9ub2xvY2soKSBJUEkgc2FmZS4NCj4gPiANCj4gPiBJIGFtIG5vdCBzdXJlIGhvdyBURFgvU0VB
TUNBTEwgd2lsbCBiZSB1c2VkIGluIFREWCBDb25uZWN0Lg0KPiA+IA0KPiA+IEhvd2V2ZXIgSSBu
ZWVkZWQgdG8gY29uc2lkZXIgS1ZNIGFzIGEgdXNlciwgc28gSSBkZWNpZGVkIHRvIGp1c3QgbWFr
ZSBpdA0KPiA+IG11c3QgYmUgY2FsbGVkIHdpdGggSVJRIGRpc2FibGVkIHNvIEkgY291bGQga25v
dyBpdCBpcyBJUlEgc2FmZS4NCj4gPiANCj4gPiBCYWNrIHRvIHRoZSBjdXJyZW50IHRkeF9lbmFi
bGUoKSBhbmQgdGR4X2NwdV9lbmFibGUoKSwgbXkgcGVyc29uYWwNCj4gPiBwcmVmZXJlbmNlIGlz
LCBvZiBjb3Vyc2UsIHRvIGtlZXAgdGhlIGV4aXN0aW5nIHdheSwgdGhhdCBpczoNCj4gPiANCj4g
PiBEdXJpbmcgbW9kdWxlIGxvYWQ6DQo+ID4gDQo+ID4gCWNwdXNfcmVhZF9sb2NrKCk7DQo+ID4g
CXRkeF9lbmFibGUoKTsNCj4gPiAJY3B1c19yZWFkX3VubG9jaygpOw0KPiA+IA0KPiA+IGFuZCBp
biBrdm1fb25saW5lX2NwdSgpOg0KPiA+IA0KPiA+IAlsb2NhbF9pcnFfc2F2ZSgpOw0KPiA+IAl0
ZHhfY3B1X2VuYWJsZSgpOw0KPiA+IAlsb2NhbF9pcnFfcmVzdG9yZSgpOw0KPiA+IA0KPiA+IEJ1
dCBnaXZlbiBLVk0gaXMgdGhlIHNvbG8gdXNlciBub3csIEkgYW0gYWxzbyBmaW5lIHRvIGNoYW5n
ZSBpZiB5b3UNCj4gPiBiZWxpZXZlIHRoaXMgaXMgbm90IGFjY2VwdGFibGUuDQo+IA0KPiBMb29r
aW5nIG1vcmUgY2xvc2VseSBhdCB0aGUgY29kZSwgdGR4X2VuYWJsZSgpIG5lZWRzIHRvIGJlIGNh
bGxlZCB1bmRlcg0KPiBjcHVfaG90cGx1Z19sb2NrIHRvIHByZXZlbnQgKnVucGx1ZyosIGkuZS4g
dG8gcHJldmVudCB0aGUgbGFzdCBDUFUgb24gYSBwYWNrYWdlDQo+IGZyb20gYmVpbmcgb2ZmbGlu
ZWQuICBJLmUuIHRoYXQgcGFydCdzIG5vdCBvcHRpb24uDQoNClllYWguICBXZSBjYW4gc2F5IHRo
YXQuICBJIGFsbW9zdCBmb3Jnb3QgdGhpcyA6LSkNCg0KPiANCj4gQW5kIHRoZSByb290IG9mIHRo
ZSBwcm9ibGVtL2NvbmZ1c2lvbiBpcyB0aGF0IHRoZSBBUElzIHByb3ZpZGVkIGJ5IHRoZSBjb3Jl
IGtlcm5lbA0KPiBhcmUgd2VpcmQsIHdoaWNoIGlzIHJlYWxseSBqdXN0IGEgcG9saXRlIHdheSBv
ZiBzYXlpbmcgdGhleSBhcmUgYXdmdWwgOi0pDQoNCldlbGwsIGFwb2xvZ2l6ZSBmb3IgaXQgOi0p
DQoNCj4gDQo+IFRoZXJlIGlzIG5vIHJlYXNvbiB0byByZWx5IG9uIHRoZSBjYWxsZXIgdG8gdGFr
ZSBjcHVfaG90cGx1Z19sb2NrLCBhbmQgZGVmaW5pdGVseQ0KPiBubyByZWFzb24gdG8gcmVseSBv
biB0aGUgY2FsbGVyIHRvIGludm9rZSB0ZHhfY3B1X2VuYWJsZSgpIHNlcGFyYXRlbHkgZnJvbSBp
bnZva2luZw0KPiB0ZHhfZW5hYmxlKCkuICBJIHN1c3BlY3QgdGhleSBnb3QgdGhhdCB3YXkgYmVj
YXVzZSBvZiBLVk0ncyB1bm5lY2Vzc2FyaWx5IGNvbXBsZXgNCj4gY29kZSwgZS5nLiBpZiBLVk0g
aXMgYWxyZWFkeSBkb2luZyBvbl9lYWNoX2NwdSgpIHRvIGRvIFZNWE9OLCB0aGVuIGl0J3MgZWFz
eSBlbm91Z2gNCj4gdG8gYWxzbyBkbyBUREhfU1lTX0xQX0lOSVQsIHNvIHdoeSBkbyB0d28gSVBJ
cz8NCg0KVGhlIG1haW4gcmVhc29uIGlzIHdlIHJlbGF4ZWQgdGhlIFRESC5TWVMuTFAuSU5JVCB0
byBiZSBjYWxsZWQgX2FmdGVyXyBURFgNCm1vZHVsZSBpbml0aWFsaXphdGlvbi4gwqANCg0KUHJl
dmlvdXNseSwgdGhlIFRESC5TWVMuTFAuSU5JVCBtdXN0IGJlIGRvbmUgb24gKkFMTCogQ1BVcyB0
aGF0IHRoZQ0KcGxhdGZvcm0gaGFzIChpLmUuLCBjcHVfcHJlc2VudF9tYXNrKSByaWdodCBhZnRl
ciBUREguU1lTLklOSVQgYW5kIGJlZm9yZQ0KYW55IG90aGVyIFNFQU1DQUxMcy4gIFRoaXMgZGlk
bid0IHF1aXRlIHdvcmsgd2l0aCAoa2VybmVsIHNvZnR3YXJlKSBDUFUNCmhvdHBsdWcsIGFuZCBp
dCBoYWQgcHJvYmxlbSBkZWFsaW5nIHdpdGggdGhpbmdzIGxpa2UgU01UIGRpc2FibGUNCm1pdGln
YXRpb246DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvNTI5YTIyZDA1ZTIxYjkyMThk
YzNmMjljMTdhYzVhMTc2MzM0Y2FjMS5jYW1lbEBpbnRlbC5jb20vVC8jbWY0MmZhMmQ2OGQ2Yjk4
ZWRjYzJhYWUxMWRiYTNjMjQ4N2NhZjNiOGYNCg0KU28gdGhlIHg4NiBtYWludGFpbmVycyByZXF1
ZXN0ZWQgdG8gY2hhbmdlIHRoaXMuICBUaGUgb3JpZ2luYWwgcHJvcG9zYWwNCndhcyB0byBlbGlt
aW5hdGUgdGhlIGVudGlyZSBUREguU1lTLklOSVQgYW5kIFRESC5TWVMuTFAuSU5JVDoNCg0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC81MjlhMjJkMDVlMjFiOTIxOGRjM2YyOWMxN2FjNWEx
NzYzMzRjYWMxLmNhbWVsQGludGVsLmNvbS9ULyNtNzhjMGM0ODA3OGYyMzFlOTJlYTFiODdhNjli
YWMzODU2NGQ0NjQ2OQ0KDQpCdXQgc29tZWhvdyBpdCB3YXNuJ3QgZmVhc2libGUsIGFuZCB0aGUg
cmVzdWx0IHdhcyB3ZSByZWxheGVkIHRvIGFsbG93DQpUREguU1lTLkxQLklOSVQgdG8gYmUgY2Fs
bGVkIGFmdGVyIG1vZHVsZSBpbml0aWFsaXphdGlvbi4NCg0KU28gd2UgbmVlZCBhIHNlcGFyYXRl
IHRkeF9jcHVfZW5hYmxlKCkgZm9yIHRoYXQuDQoNCj4gDQo+IEJ1dCBqdXN0IGJlY2F1c2UgS1ZN
ICJvd25zIiBWTVhPTiBkb2Vzbid0IG1lYW4gdGhlIGNvcmUga2VybmVsIGNvZGUgc2hvdWxkIHB1
bnQNCj4gVERYIHRvIEtWTSB0b28uICBJZiBLVk0gcmVsaWVzIG9uIHRoZSBjcHVocCBjb2RlIHRv
IGVuc3VyZSBhbGwgb25saW5lIENQVXMgYXJlDQo+IHBvc3QtVk1YT04sIHRoZW4gdGhlIFREWCBz
aGFwZXMgdXAgbmljZWx5IGFuZCBwcm92aWRlcyBhIHNpbmdsZSBBUEkgdG8gZW5hYmxlDQo+IFRE
WC4gwqANCj4gDQoNCldlIGNvdWxkIGFzayB0ZHhfZW5hYmxlKCkgdG8gaW52b2tlIHRkeF9jcHVf
ZW5hYmxlKCkgaW50ZXJuYWxseSwgYnV0IGFzDQptZW50aW9uZWQgYWJvdmUgd2Ugc3RpbGwgdG8g
aGF2ZSB0aGUgdGR4X2NwdV9lbmFibGUoKSBhcyBhIHNlcGFyYXRlIEFQSSB0bw0KYWxsb3cgQ1BV
IGhvdHBsdWcgdG8gY2FsbCBpdC4NCg0KPiBBbmQgdGhlbiBteSBDUjQuVk1YRT0xIHNhbml0eSBj
aGVjayBtYWtlcyBhIF9sb3RfIG1vcmUgc2Vuc2UuDQoNCkFzIHJlcGxpZWQgYWJvdmUgdGhlIGN1
cnJlbnQgU0VBTUNBTEwgYXNzZW1ibHkgcmV0dXJucyBhIHVuaXF1ZSBlcnJvciBjb2RlDQpmb3Ig
dGhhdDoNCg0KCSNkZWZpbmUgVERYX1NFQU1DQUxMX1VECQkoVERYX1NXX0VSUk9SIHwNClg4Nl9U
UkFQX1VEKQ0KDQoNCg==

