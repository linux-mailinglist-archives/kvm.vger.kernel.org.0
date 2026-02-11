Return-Path: <kvm+bounces-70818-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0OTMBWjSi2mgbgAAu9opvQ
	(envelope-from <kvm+bounces-70818-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:50:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 76DAD120604
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 01:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CCE7D305980C
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 00:50:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C098722156A;
	Wed, 11 Feb 2026 00:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iRLg6+f2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3774146588;
	Wed, 11 Feb 2026 00:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770771038; cv=fail; b=OcSpawpR/tkOd8+QVAWvw2+97HwVltiJXfe5F1lA/Yehtmhmic7U0OAOkQFYHhcbE0TMOLBh4RNu5QAvCK3jaHQKePeRtYcxYHh9mATgQlHJ3r3tgSp/NlnKX9eyxcbglNlEjGvSPEaegDV6hqcpcjClnk+ZVjJQpLcOhWjD8+Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770771038; c=relaxed/simple;
	bh=E3wGsdPyBWHnt2EntVD1MyHju2YHPJt5Qm1WosrqahY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hJ5QdNNegUwth/QXTD632WZY0N7jUY52UEhYzqNW4EF5x2zVcDPQVHVukzsWLv30lW7GUd+6kifGJ47XhxjfJXgk6CNaBIDSukSrhqi2nWuxUHHXe2DjJA3myo23fgYSnv/0wsZ4lZ70eQGv19A6WkFwZxsfsLhYSTxZG2VMqQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iRLg6+f2; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770771037; x=1802307037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E3wGsdPyBWHnt2EntVD1MyHju2YHPJt5Qm1WosrqahY=;
  b=iRLg6+f2DRHJYymtnCR+OUjxR8KyOq2zFsZWyOtDPGJC0h6thPn+VgwF
   x1PmDNYfAN31bI/KW/A5/5iaHWRrSxpDMJPKUytHu2Q/qJmLWGyA2Xe4k
   bIQyiEq1dBIO9+5Iu0S3nNMLtk2HcdCTSl+Mi2JuxcI3moDABE0crHpjL
   PLeqzxUJgISO1dpBIjdoLM6pGc1MnAY2cPBINznK08yHDMi6P1jSvlGC4
   cM0VwVetoWASpGgKt6sie7USO49MdiX7HjzjuA1m+50ohqCrPmcESjkKa
   JFLyq/APzyE/17x5ufoYCJlgfhwvffQYmzeoeE0fCwekdXWR1ygghAjh9
   w==;
X-CSE-ConnectionGUID: 3JqAHJfzQNedi4oi3uOV/Q==
X-CSE-MsgGUID: HdZQG14aQf28viL6DZOCtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="70929734"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="70929734"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 16:50:36 -0800
X-CSE-ConnectionGUID: A1Q7iXxJTYaIBTz9P4VHyg==
X-CSE-MsgGUID: z4KramhWS9uhpLE9VaaOgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="211148509"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 16:50:36 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 16:50:36 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 10 Feb 2026 16:50:36 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 10 Feb 2026 16:50:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wMI3FUd4TLnPmq54w3vEsv+Y6PiIzQ2f2sqjxu2ZlG/EDHw5sbQVAJtoltQPD478ANrKpKdRYrACSz6PiUXuA1i127+cZF50WAG+55jy+JAYS+Ms5T5Z2I2/8fxFQNlFHqAVbeb9zeb/V6c9cBIlcdwkTg15UaCBk8qcIaAPdbas2O/CDfTQYNvilmyo+LAf9hLsXEFZ0E2abuhIYVKriFGlfjrR3YwCx7vArbStFe11GQiMy71E1I5du7OGiQ1bII3yZLT3JgBzbM78nxYIPYs9XEKLgwDbD6DwBAsSdxXnJ0xkSC16HtogyVUdFSO7DrZyXX2IN0AjqM4Hr9WtTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E3wGsdPyBWHnt2EntVD1MyHju2YHPJt5Qm1WosrqahY=;
 b=OJn0tjyZtox7XRE3Ymo4viNSZjN2Kca+Q3XLGQTM5bZZ82M6BcyH28W8IOfceDfLfmvZ+EX/mni8I1Fj9uT9Ul1vvYmLLrrmeeQr/YmnPWWp0KjM8PZwmeIb2T3MYS4jsxVCVLmcErIMtUEsHo8dg4IExljI/z093h97Srk6dno5w0jJqxh+9snTXG6depWvkHEva5WOmgfp7K/Nr46tXhhGHrB6Cc/l+mPecPS5i/OCR9jPNvBq/rOajCdaIOn3QxitrvS9GV+MPCAjSEeh80DUPWS2fT15ubvITF4gM01se3ZqdRjiUhFv5m87NeSg4ifVdaei9A/b5jvwZgH5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7607.namprd11.prod.outlook.com (2603:10b6:510:279::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Wed, 11 Feb
 2026 00:50:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9587.013; Wed, 11 Feb 2026
 00:50:32 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Thread-Topic: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Thread-Index: AQHckLzbLDbm1hcjXk2EfwFkWO7GVbV8SEYAgAB3GIA=
Date: Wed, 11 Feb 2026 00:50:32 +0000
Message-ID: <51b7d6a424e9c815cc95641eb16e568ce742254a.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-17-seanjc@google.com>
	 <655724f8-0098-40ee-a097-ce4c0249933d@intel.com>
In-Reply-To: <655724f8-0098-40ee-a097-ce4c0249933d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7607:EE_
x-ms-office365-filtering-correlation-id: 820b7db3-c0f2-4521-2862-08de69078fa5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aHRjRm5saHF0WGs4SXBxeWhPVFpRWWtZcnNCM1FTUWphOGpreHkvT2pYN25H?=
 =?utf-8?B?Q0J2RFd1R3dHYTlqck90RGdwMjluWGRtQ0wrRGQ2SkZpUytLaGNMdTFVZmJj?=
 =?utf-8?B?eGFCbGtOcldHai9DMkp5Y0RwYnlRSFg1NWRpYjRlZjhwSVdKUitFOUJtcHd6?=
 =?utf-8?B?ZkRwTjIzS0xsZjc4NGoyNjNZMUlhTjkzdk1iR2l0dFZyYnFCWWhveXZKRGpw?=
 =?utf-8?B?d3E2T2g5VGRLUjB4ME1YbVhqRkx0L1R6a0JVWm5tL2trb3RHZTdhZGt5M3o4?=
 =?utf-8?B?aXZRcytQcWlmYTNKd3hUL0p0ZXdKbmw5S1h3THd2OHRVd2hZN01tRzFEY0dR?=
 =?utf-8?B?ditOOTliNmF6QTQ4Wm16S2NtZXFSYm5WaXdibG8yd3NKUENrWk5hbEVZRDdQ?=
 =?utf-8?B?OWlmeFdHcFFSbkJneHlqUFRhbVN0R2R6NHV6ZlJGNjBzdXo3eml5ZTNXdktv?=
 =?utf-8?B?dDNlNmxDeVBVajRCTXRTSENqMVkyKzNZQjNOZy9xZmp0VWlSL0d3RG9ldjVz?=
 =?utf-8?B?QlZINzRORGFrQ2hWZFVWaGFSTHU0MEZPeklCbS8wOHoycFZmRmJ0c1FiQVpq?=
 =?utf-8?B?ZWdGZlhzbVo3NGxtSjJsQVdudDZMeDRjdEJWMDZUa3VDb0FmNDQzTkY0Zzdr?=
 =?utf-8?B?SVRGTWdFQVlRenZ4TTFxd0RIaXljZkZTN1lWdHlZM3RFNWpzT1hyTzh0MC90?=
 =?utf-8?B?Y0Q1M0JFbG90VWNEME1vYWlndlhVaTMyZjVmTS9mY3hkUWtvRm5Bc052ckxP?=
 =?utf-8?B?YnhUQUc4ajN6emZsakhzRCtaNWZibWkyVkt6R1FNN3ZycWViWGNaRXlqWUhE?=
 =?utf-8?B?cU9tbEpJRElkai9IakxYRkpyM2NKMlZpQjgxWGFOSEpQemd6OWs2K0VCVFBN?=
 =?utf-8?B?Q2x5cGFrV2x0VlJ5bTBSNFFRRTZUT0YrRkNrYTZOYzdRdERxbzZIS0lER2xY?=
 =?utf-8?B?Z0g0ampkZTM2aEZwQlFaREpoUzA0SjFMQi9TQ2lmSkt2aXpHbGErRENsdENP?=
 =?utf-8?B?VjVQemVRNEZOSzFIWjZUWUJ2MzF2Q01ubHVBQnhQUWw0RE91Ym1GM2hBVVFE?=
 =?utf-8?B?czRobGpnYkdwRVljeVdMTFBnZGlpMnl6MVZacDFtRERaSDkzM2lVWDVWNE45?=
 =?utf-8?B?elBFNFZuQlB4VlZIcTVZdkNCemRUZm8waDNOUjc5Qm1VU2tCcXNZaTY1bFhV?=
 =?utf-8?B?YnlKTWs5TTRpNWJkUmpXaFB2aFVObGRMVmRrdCtGOFhMMm96ZUNRSWR0WHQx?=
 =?utf-8?B?WktGM2poMVgzd0ZMWUlsYUExaXRGTUVyckJNekxwUFdpN3hBblhWaDdqVE9L?=
 =?utf-8?B?dkVhaG41ZXl4dndoYk9CTnYvdTFaOVV3dnBGUE54cHVoOEo1QXFuSFJJNno0?=
 =?utf-8?B?eUk5OGYrRWZLREUzZ21ndGRDdlpxblcwc0RxdHVlVTNBbWwxU3hSb1VBN1Fu?=
 =?utf-8?B?K2tzRmtabCtOamg0RG5GTmhnRDJZWThiYWpUZDFiejM2TTBxUUtIclhmeUM0?=
 =?utf-8?B?RDdhSnVYY1QweVA4T2pLeHdFdlNoUC8wV0hBVGQ1UU5ISUhSaFZFY3dJVDNw?=
 =?utf-8?B?U2FaVzVYVXJkbDJvWFJCaWVTL2FZSCtGVHU2KzNHbU5OTTdjdGVUQ0hnaUhE?=
 =?utf-8?B?c2EwakdJNlV5RXJrVVhUZWpHMVBlVWEyTUJvT0tXWDcvOTlGR08vbVhSUWJl?=
 =?utf-8?B?NVNIRENEWmZQamxSWm01YmRPK3IvcjZnV3JCa2FaS3plZXk4Z1FmOGtzc0JN?=
 =?utf-8?B?ZW1wNFp6em5zQmxOM1JVRlJBOGNoRDJ3L0hrUHpMeXdGK05MUkt5c3kxTGE3?=
 =?utf-8?B?MGdIU0hYNmZFZU1XcmY3Q3BRRFcxcExNU01NUVhkU0FpeVNpRkdzbzRlZXMv?=
 =?utf-8?B?NFc3eTF3ZXNVRXpPMmhlUk96dFVHUjRhSVg2cnNCNDFLRE5TV3p6aCtiNzdw?=
 =?utf-8?B?eklvLzU3RUJhdFJLYlZmMGUyYkdYZUZZTFYvdlZiZWxUaWFQYXljNmEzTkow?=
 =?utf-8?B?dlF4SFM3OVJLT1ZCQ2daV09UMFkyT3IrQnNrNzZPdkd3Rkp0cFR0MFBiMGNH?=
 =?utf-8?B?QUNNNW00eEJhTDZaQko1RWRhQW1MWHJhV3lUZThON2FCSXU1QXNqWUpZZXc0?=
 =?utf-8?B?c25iL1M2N0E5aGRweGVrQm9TRXVOR2MyUE9VcUtRdDgxMFlBOVVxR2NKWTk1?=
 =?utf-8?Q?UzENPE5k7oSfFgmMR6mSGnf27DOBwHHyuPMAYGAPpCom?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UW44aE0zNm9UUU9scVhsTjMzWjdMM1dkTUdnTngxV3Y5Z1dsSlh4b3g0TGMy?=
 =?utf-8?B?dFNFcnhKb1JaTFdJc0wwQkEreUdkRVR4VENzKzA1Ync1RktBR1RmNmVsSUdO?=
 =?utf-8?B?MkNPakFxUUowN3U5YnRNeHoyOVJMdW9NUE51MXpSdFBrWVJERCtKZytKRC9M?=
 =?utf-8?B?RGMvdXFqcnZBYlJGRHFmampqVHY1TFdoWUZvcnpjdXJBbWYvMUZXdXFOYkE1?=
 =?utf-8?B?YjBJREhNOERIRWJCaDlyVmNleUtkdTIwdnVlUmpPZnZlaDBGbHh1N2U4cDk3?=
 =?utf-8?B?dEsrWUtUTG1aR0F1YXIrbFdoZytKUEh6eGJzb3dKcG5mWWN1T1Q0YVBQSzFo?=
 =?utf-8?B?V25BaUtVcG9oSnRjaG5zNmZ0RDJVZHNXR2ZKVEt6YjVjUHlnV1NaR0xmRXZr?=
 =?utf-8?B?NmFEaURpSDRVNDgraTd0bWMzRXc0RFRqRk45em1zdHNNaUV6N2pkLzZlMUxB?=
 =?utf-8?B?TnU3OUR2dTZpeklHbXE4bDhpR21UL1d4K2M0SkN1WHJlYWg2eXFQUVp4cVFs?=
 =?utf-8?B?eEFTdmNxSjlzOVFOdjNtN25XWXVmWFBVR3ZhSFVWbnE2Z2RXTHFIYkJwNjRr?=
 =?utf-8?B?UlBsbGtnb3Jlc0xmWTd1UUx3NVNaa2hybUl4bGRiY0EzWkJDbU9TVzROZWxl?=
 =?utf-8?B?eHR5ZjlPcmxoUnJ0V0txVjRaTFg5T2VwWEhuNjBkNTVKYlZzSlZOcHJadTla?=
 =?utf-8?B?SElNZno5MHlSN0VMc1BoSWJLQUo4WXg5VFVUNHBXSkNFOFdJZmo3dWgzY3FT?=
 =?utf-8?B?UmZEWTlYZmw5ZlhTYlZWUzRZLzdTbExXWk9ycWxRZ2tUOGNkODFpWmlCZ1k0?=
 =?utf-8?B?ZE8zN1VlWkFXNVM0NU0rMEdFK2RUdFN0bk5PWTVzQTd5MFRFWlBYQlo3Z0xq?=
 =?utf-8?B?OTNJUC9vNFhmMlI5clg0ellPVlNZZDZUZVo0UkJiQ05HVkhTdmN0bXZ3OWZu?=
 =?utf-8?B?SVNqMFQzWVJVaWUrK3A3ZkNpWUp4SkVORlJ3ejM4YnlaVVZuWkZOclNpMzlq?=
 =?utf-8?B?RGxRNUNFdUdudnphUkZiSnFlckNZOFJFQjVveUxkbkorckdUSHlwditSRE00?=
 =?utf-8?B?dDFSMFIzWUlXdUZVRVR6Njk4Yml2c09jcWtNakJwaUk3d1RiUHpGWHBHUU0z?=
 =?utf-8?B?VDdKb3pUT21kVDVrRUVRQ3JXd3ZHK3NlWGlTMW5vbVoyaUJPaDVWL2xUT2NX?=
 =?utf-8?B?SjYwdmFVaDRRZmNWdWR3SDFTYS9VSld3K2dRNlFpVS8rd2o5U3BlK3hyT0Ur?=
 =?utf-8?B?cGRQUko0VUpwVElQU29qRFdteEErc0F4Vlo1MmR1Wk93bHJUd0JlM09GRTA0?=
 =?utf-8?B?Wm15VGU5TFZRNC96R1NaaVhMamNxVnk0T2R0ekRVOTJGY3gzSFFRN3B4UDh6?=
 =?utf-8?B?UjZXcnM2UkNRa2lheXFzSWFEVi9VU2p4K3FRMU1vWFh3N2FNb2tPQ2lhTmJj?=
 =?utf-8?B?Z0JvMU9aeGtSeHBpR092SExzbXFPZ1EyOHh2dmxhaWpMMDVneVhEek1yaWtp?=
 =?utf-8?B?TFFPamc1Zyt2NU92NlY2WnoyaVZuUzMraC82UVBucnVTd0pjQnBqTFk4MTRm?=
 =?utf-8?B?ZmMvS3ZmSkU1clAxSlRzVnJDelpOdktzUFpYVmVid3V4RE9KUkpSbnJWd0lt?=
 =?utf-8?B?akhLNHI5L3l2TmFpb0gvWnBmd0EwbTUxeW9ucDhDQjBOT1pWMHgxRWhjazhR?=
 =?utf-8?B?YkpaL09lbjl2dEhEcUF1TG1BZGYySDNyak84cnRzTjFTRlluZENLMWdQak5x?=
 =?utf-8?B?ZlZxME1hdWZ2S21lMlBrV3htUTBmMUQzMGl1QWJZZzdDTzdXQTlKbTlYUmZy?=
 =?utf-8?B?YVhnSlN0bXRhbHdUWDlhV25icmJXZ2Raa1N1U21GalYrWGplV2d3cEplK1dh?=
 =?utf-8?B?TXlHTkNNcU11M0R1cXNKWTh0TDh1MHVxUVh1alEwd0hiWkJod0E0WGN0aHN6?=
 =?utf-8?B?Z3E0dXhaUWd6Q0lJVmxXU1FFZEVWQ09BRHRERnkvOXUvaWk0RXVUbUI5cXB1?=
 =?utf-8?B?alFiS2V5RVIwbFdOM0hSUWRiYXB0Yjh0dmppOHM2RFRQb0J4T2pLNzBIaG1w?=
 =?utf-8?B?Vkw3N0lYRis0SDBUU09JUHBQOGk3MHFOUmU4MkRLMUlUVFNRNGRXYXQyTkVN?=
 =?utf-8?B?ZnlQdEdKek4vY2Q4SHV1d2VUSStDTFlheUdSVjNWaEFEV3RBN3pyR1AzS1BL?=
 =?utf-8?B?aEZPZVBtOG5zWGlGRXUreURFemUwNUQyek5rbkN1aW5kb2FRK2RnYmNqTXEw?=
 =?utf-8?B?RjFUUVFDVTVCV2FOMDJLZjIwd05oQlh2S3VETTErM0ZQM3BSeEtuMmkvd2FI?=
 =?utf-8?B?Z1AyT2VmdWRwMmJDdWl1UytWT1lFN1Rpaitza1NFUzcwUEJWRWl2RHJ0Ujlj?=
 =?utf-8?Q?Uw4X0yAK0DhNFpKc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4FA546658336F4488A07520E4912B3E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 820b7db3-c0f2-4521-2862-08de69078fa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2026 00:50:32.8513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pfgBxtbUkAZ/4wwxaTvGJbfylBH3ppBntOZwlwxfmw2r5oN7FZgF44pIrC7/B/1La/+XqNk00iOTnHqy0CTtfpHHcTNSSCw/RbcEXCvSz1A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7607
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70818-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 76DAD120604
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTEwIGF0IDA5OjQ0IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
CXNsb3dfcGF0aCA9IGF0b21pY19kZWNfYW5kX2xvY2soZmluZS1ncmFpbmVkLXJlZmNvdW50LA0K
PiAJCQkJCXBhbXRfbG9jaykNCj4gCWlmICghc2xvd19wYXRoKQ0KPiAJCWdvdG8gb3V0Ow0KDQpJ
IGd1ZXNzIGlmIGl0IHJldHVybnMgMCwgdGhlIGxvY2sgaXMgbm90IGhlbGQuIFNvIHdlIGNhbiBq
dXN0IHJldHVybi4NCg0KPiANCj4gCS8vIGZpbmUtZ3JhaW5lZC1yZWZjb3VudD09MCBhbmQgbXVz
dCBzdGF5IHRoYXQgd2F5IHdpdGgNCj4gCS8vIHBhbXRfbG9jayBoZWxkLiBSZW1vdmUgdGhlIERQ
QU1UIHBhZ2VzOg0KPiAJdGRoX3BoeW1lbV9wYW10X3JlbW92ZShwYWdlLCBwYW10X3BhX2FycmF5
KQ0KPiBvdXQ6CQ0KPiAJc3Bpbl91bmxvY2socGFtdF9sb2NrKQ0KPiANCj4gT24gdGhlIGFjcXVp
cmUgc2lkZSwgeW91IGRvOg0KPiANCj4gCWZhc3RfcGF0aCA9IGF0b21pY19pbmNfbm90X3plcm8o
ZmluZS1ncmFpbmVkLXJlZmNvdW50KQ0KPiAJaWYgKGZhc3RfcGF0aCkNCj4gCQlyZXR1cm47DQo+
IA0KPiAJLy8gc2xvdyBwYXRoOg0KPiAJc3Bpbl9sb2NrKHBhbXRfbG9jaykNCj4gDQo+IAkvLyBX
YXMgdGhlIHJhY2UgbG9zdCB3aXRoIGFub3RoZXIgMD0+MSBpbmNyZW1lbnQ/DQo+IAlpZiAoYXRv
bWljX3JlYWQoZmluZS1ncmFpbmVkLXJlZmNvdW50KSA+IDApDQo+IAkJZ290byBvdXRfaW5jDQo+
IA0KPiAJdGRoX3BoeW1lbV9wYW10X2FkZChwYWdlLCBwYW10X3BhX2FycmF5KQ0KPiAJLy8gSW5j
IGFmdGVyIHRoZSBURENBTEwgc28gYW5vdGhlciB0aHJlYWQgd29uJ3QgcmFjZSBhaGVhZCBvZiB1
cw0KPiAJLy8gYW5kIHRyeSB0byB1c2UgYSBub24tZXhpc3RlbnQgUEFNVCBlbnRyeQ0KPiBvdXRf
aW5jOg0KPiAJYXRvbWljX2luYyhmaW5lLWdyYWluZWQtcmVmY291bnQpDQo+IAlzcGluX3VubG9j
ayhwYW10X2xvY2spDQo+IA0KPiBUaGVuLCBhdCBsZWFzdCBvbmx5IHRoZSAwPT4xIGFuZCAxPT4w
IHRyYW5zaXRpb25zIG5lZWQgdGhlIGdsb2JhbCBsb2NrLg0KPiBUaGUgZmFzdCBwYXRocyBvbmx5
IHRvdWNoIHRoZSByZWZjb3VudCB3aGljaCBpc24ndCBzaGFyZWQgbmVhcmx5IGFzIG11Y2gNCj4g
YXMgdGhlIGdsb2JhbCBsb2NrLg0KPiANCj4gQlRXLCB0aGlzIHByb2JhYmx5IHN0aWxsIG5lZWRz
IHRvIGJlIHNwaW5fbG9ja19pcnEoKSwgbm90IHdoYXQgSSB3cm90ZQ0KPiBhYm92ZSwgYnV0IHRo
YXQncyBub3QgYSBiaWcgZGVhbCB0byBhZGQuDQo+IA0KPiBJJ3ZlIHN0YXJlZCBhdCB0aGlzIGZv
ciBhIGJpdCBhbmQgZG9uJ3Qgc2VlIGFueSBob2xlcy4gRG9lcyBhbnlvbmUgZWxzZQ0KPiBzZWUg
YW55Pw0KDQpJIGRvbid0IHNlZSBhbnkgaXNzdWVzLiBJdCBpcyBsYXJnZWx5IHNpbWlsYXIgdG8g
dGhlIHZlcnNpb24gaW4gdGhlIG5leHQgcGF0Y2gNCmV4Y2VwdCB3ZSBkb24ndCBuZWVkIHRvIGhh
bmRsZSB0aGUgSFBBX1JBTkdFX05PVF9GUkVFIGNhc2Ugc3BlY2lhbGx5LiBJdCBkb2VzDQp0aGlz
IHdpdGhvdXQgdGFraW5nIHRoZSBsb2NrIGluIGFueSBtb3JlIGNhc2VzLiBTbyBzZWVtcyBsaWtl
IGEgbmljZSBjb2RlDQpyZWR1Y3Rpb24uDQoNCkl0IHByb2JhYmx5IGlzIHN0aWxsIHdvcnRoIGtl
ZXBpbmcgdGhlIGNvbW1lbnQgYWJvdXQgdGhlIGdldC9wdXQgcmFjZSBzb21ld2hlcmUuDQpJJ2xs
IHNlZSBpZiBJIGNhbiBzbG90IGl0IGluIHNvbWV3aGVyZS4NCg==

