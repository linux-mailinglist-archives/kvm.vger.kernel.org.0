Return-Path: <kvm+bounces-64572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D8AA4C87605
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 23:44:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FD8E3AAF2C
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 22:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AF7133ADA3;
	Tue, 25 Nov 2025 22:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c05EGu5V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7351EFF80;
	Tue, 25 Nov 2025 22:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764110657; cv=fail; b=nmSGHYT1yWT5f1OYAczxTGXRkV1jESmQgbB+Sp/Se8IsMxkHKjARnAnQRmmOwLeRsIeD7je/NVwRHsmDTe5fqfHJV6FhvPbYBWzpF5O3jD1MWJMIox+CDvrU+aBrYMQkQwS5lnrPfc4JY1C6sfNT16MlfJP2zvluAgVex8+XRak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764110657; c=relaxed/simple;
	bh=rc9ZqTY2VNtCxgpZXxcAX3e33J8wTuiBFW4N9qE0fyw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Qi0uzaGQfZ4zjgHnYLJ8gMZtsr29t7gh/TzG5E9J7JujkCMQwzM3hGaJnD0bEFJhvD2ioBHmMiPDwA6Va6sg81AwTu6YrxAm/yvddNPHfrf3hkfM++ypL8OHT8yRcwxnx3YpXNSq56DmmhjuXbDtCAr0FwGs5vXY+rSsXcTeKII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c05EGu5V; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764110655; x=1795646655;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rc9ZqTY2VNtCxgpZXxcAX3e33J8wTuiBFW4N9qE0fyw=;
  b=c05EGu5VhU0kZXuHzn+TOmvzkAvjjUm3hht265N7RSZ+UqThEW4v3Rqa
   PYsPxy+YO3lWFzZkapkbfQAfYttIHWoWbLa4uBnpWnPm0rFVz5BykIlEb
   rg5pez1bXuoXxXWgAIBC+vyzoZR3m8s2wACdTlKRoMwAVRVeX496yMh8h
   wqpXjCbvPHRYeAwL+2Yas/PzmmSMJ8+MSYpyEE4Yh9gvd6aX4To3lA2yn
   EgqV97uBhETCDKcwih5RC7K6ji19Inc8/sJ260rbAcxQKJkBd54KILUWn
   tfdsbpWoxaEA/iTbpurp50linjS/MNyLrSiLvse2sYBgDxYXv4iVp/VTz
   A==;
X-CSE-ConnectionGUID: yCKHBsjeQbOwGh/kTBzouA==
X-CSE-MsgGUID: qs4rTPcrTP6VEYEgaKi1RQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="68730461"
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="68730461"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 14:44:14 -0800
X-CSE-ConnectionGUID: abTXX07KSSmlVnel611IJA==
X-CSE-MsgGUID: toLaJNlmSz2ATsZfvUZRsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,226,1758610800"; 
   d="scan'208";a="193005228"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 14:44:14 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 14:44:13 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 14:44:13 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.37) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 14:44:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elx44cYEd7jvsIz1GhvFsbU4uy05nNxUlbK8WGsKK/runWyakBGZs9Zka+30NPIg7d+lsWHibjUNfOhnkX+7uwRZogLzwrZxpeie5nowL/o3cpraHv3+AvBLhAF6pTRji/6mZnbqFJOT6oiDB83IOKo1TBCxhQVgxrwcR5HWlrG6udGtqCD7tRcGGi0u9RyzvZkpb2dtK3mTETYhyKpcqRSiKXsCOpRgO1G1iWS3vwLQlyVS5WJZc+x3oh9Yj1AQgv2SWKV3/FBXbXqM2rAvteos1iM6tL74k1Mx3CIHR8MHzR9pYh0ew2abh/Ng/YqhvwLIyqnq49Y3Jspznl4dhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rc9ZqTY2VNtCxgpZXxcAX3e33J8wTuiBFW4N9qE0fyw=;
 b=LU7VnmwAOW81DR/f0XgDQ89TQHfsp7R51jYoUxpt/VlhKq/KGJ6wdXWiuroeRcCz/4UNTaIKxDQQhXavaWQk2RJUIDlpsvrF5MsJ2ql9+Glj8tcgGFF8kTI+/yXytcA4WtuJD4iFc3s99Bu1jL+dhYJhGefmg9PR+P+rLI8rh1QydOhcA8xp05TXtsvDQwsczYQrPz5ls9S7zx4wHJHEvMq1VDr8jvGKukmUvpnXO2hVVH+OG2Mz2bKYvnmA/VbXyRoCyHrCUN46lQ8Gi8j9Y51Qc5i+UZQfTPqxacARi4/J0uTvUvtPLy0beHBL2SM8+M63/CwZsRcGYYKQ/Y1Pwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY5PR11MB6415.namprd11.prod.outlook.com (2603:10b6:930:35::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Tue, 25 Nov
 2025 22:44:09 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9343.016; Tue, 25 Nov 2025
 22:44:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu,
 Binbin" <binbin.wu@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v4 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcWoEIAFaZsBBWxE2dTZ5VmBGiMLUEARWAgAAD6wA=
Date: Tue, 25 Nov 2025 22:44:08 +0000
Message-ID: <af7c8f3ec86688709cce550a2fc17110e3fd12b7.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
		 <20251121005125.417831-2-rick.p.edgecombe@intel.com>
	 <6968dcb446fb857b3f254030e487d889b464d7ce.camel@intel.com>
In-Reply-To: <6968dcb446fb857b3f254030e487d889b464d7ce.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY5PR11MB6415:EE_
x-ms-office365-filtering-correlation-id: 85f1e630-e616-4c92-b4f6-08de2c742575
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?OXVMODhQV2pCb0RKU2VyUW1CaThnUW4xWnNjc3BIZ1h5ZG5say9LRnlVMER3?=
 =?utf-8?B?YkwxQUUzd09zQUNnWUR4Q0pISDhZaTRwOSswVUl3enh3L2FpaHlyVjdTRFho?=
 =?utf-8?B?RThtWW5mdksvSW5NYWp6QTdqVUcxemxKMWdmZ1FnbHFCQ3BRdE9XenovTCtF?=
 =?utf-8?B?eTdBT0VHaUowY0xtZzBqcjBNMFlFcmppNlk5eklPNHh6UklNRHBXL1BJR0Zy?=
 =?utf-8?B?R2dYQUkxOUxyVVRwNTVjZW8vaXJzZVdhdEt3d3pERktzL3Y0cmkwdHc1dHo2?=
 =?utf-8?B?NVhVeDlheDlhM1UvRU0rV0xqOGlqaFRUU2RjQ3hndnRNQ2toNk1DUTZBdXJ5?=
 =?utf-8?B?Y2NENkZiUGNiRlpzTXZoZTlLQzk5MEdLdDhVdTAxRkJsaTdMV1Npb2tHcXkr?=
 =?utf-8?B?MDIzVWxTYm55cWVUczFDMkhsN0ZwMEd3aTlseVIwZzJSODk5MEQ0TnNkbjJt?=
 =?utf-8?B?dlNYeVV0WEdMclJhSm52UndPVlNpdVplUnpqTXcyVlhnMytvcEh5MXhUejhp?=
 =?utf-8?B?VTEvRityeDZYVEx0UUxvcXFpamd5NllGZC9WR043eERhUGlUZURnbzZpWEtn?=
 =?utf-8?B?K3RRcWxYWUVSc3dLejltcC9LNmtTZEFxbS8wc1FWcUZ0THBUZzRiSCtaalFv?=
 =?utf-8?B?c3ZkNkZNcDZvSG9KNXRJenNsKzdNWkNBdTRRcElucTErLzQ1RmtxSTV1U2xO?=
 =?utf-8?B?N21YamtTK0xQbzl0akJyUHcvMWF3UFAvK0YwZmFZRHYvcUx3YktxRzRyNEh3?=
 =?utf-8?B?akxORWl0eU5rVzJHZlV3OWlsQkdHR0p3eGRYV3pOQ3FXaDR3RzFkMlVpRllX?=
 =?utf-8?B?eVdCU1YxWnBhTDFFajVvUUhya2dVRXM5TGlaZTYvSm9VZCsyUWRvRUphVzZU?=
 =?utf-8?B?RDdHWXk4M0xYc1B0V1B1bGR2RlV2TjRITnNjR3JNUVpLdXpaMGo4aHBveUpM?=
 =?utf-8?B?bTNNenE0ODBnWDdSNm9xRkZHY1BRM3RPdnBvSHRhUGluVm84b0VNb2NsLzh6?=
 =?utf-8?B?N1NqelBXdGU2WVVtcmZqekZCYjdoZEhDSzI0MU9YMW04eDB0Ui9nWVViMnlj?=
 =?utf-8?B?ekduYUFCc3ZCZFVmM2plVFMwODJNMXBVUTZZeGhVOXZlc0dQMVUvUEcwRXJl?=
 =?utf-8?B?dHZVbmJGV3FaeWJVTi9mVFFWOTNUaEVWQzUyQTNjQ1hMVzdiN1FNOVp2Tjh1?=
 =?utf-8?B?bkRIdVdiOWlsa0JkSjJudE41R0s3ZmhtQjV2cldxeW5zdnFFT2hLSEhyM1oz?=
 =?utf-8?B?dUZrSEJpczNKL25nb0dWTU5TUG5KTFIzV2pJYkVEY2k2Sy90TDlQRFlsNUpI?=
 =?utf-8?B?Q0UwWDhJc0F3UklhRndZOGVqdVFIMlBRK3JuM3FIc3Q2a2lnZXdPeDMvRE12?=
 =?utf-8?B?WjdBM1U5Q3lYVkR4Qjk0d0tHVCtDSEk1cTBkTkpPaEZDSDBoZkNKWW1mL250?=
 =?utf-8?B?dFVqQS9nd1hIRW5ydXErdHBpN1dWM1BIamV1ZFdNeVBvNlZqQ21sMlNCNkV4?=
 =?utf-8?B?VWdXR0Vlc3B3TFF4cEVRWWlzY1Jpb3E4QzV4QUVJTWNXTUtSNFFlZFRVQzJq?=
 =?utf-8?B?SHdMRG1aeFZCVnoyUDdkMkVSZy9KZHVGSmdKT2owdGN5NHZCWERLVmJ5WnFL?=
 =?utf-8?B?OE1pQm1aT0NRWkF1STd6UWsrSkl4Mzh4TmFwQU5wanIwV0xiVHRJeHY0Mktn?=
 =?utf-8?B?MUxCZDBhc0t3Tm92dUFVSFY5UUNRY3lVODdsT0FIM3RodElrdmoxMGF0QXFo?=
 =?utf-8?B?c0grMTMzdVRZaTNsNjhuU1d0Y09ZSytTWlREaENaaGxkK3NpT3pDL1BiVU5U?=
 =?utf-8?B?NWI4eVBJYUNnY291aHRuSnZCREhqd0VrUjBuSXZ6aUlzTlRmYzZnbGxvck9u?=
 =?utf-8?B?KzBNWHNLM0J3Z1QvdzJwN0dYbHRGMXllSXZiMGM4TGRxMVJ5VFNCV0ZNSnA5?=
 =?utf-8?B?cVZva3IwNDU1a0I2dkNNRWxFcEQ0cW95SFlQMHJiMHlQZDRGUTBOVWFvdnRO?=
 =?utf-8?B?Ujd1QUF4Y2ZYbnVpNGg5WHJESXcyWU5zL0cxQ3hXYUxoU21yVVhnY0FiYit5?=
 =?utf-8?B?c0FZcGRZTERObmNtUHVsUjhIQmVWRjdVMkFsdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDJteVUxajRzRUhha2hwRW1WZ3Mxa0Z5blIrYVJtdXpVdTkrVHNyeWdSV3BD?=
 =?utf-8?B?elFabVltSnU0ajlmcityZi9md2MvRC9SUWxVOVJNZ0FkSHZyZ2FaOFdUME1q?=
 =?utf-8?B?QjZyR1dvR1QrYmFyTUNmRUd5aG13dFA3a2pHdVhsdUtoejF3eVB0NHpwaVBj?=
 =?utf-8?B?cHprSkpuVHc0c3RpSWFxMWM2Mm5yVy9qakc2RVdJa1BoOHkvckRCa1pWRW1R?=
 =?utf-8?B?Z0lOTHdRb0RXbWlDMXFjd3hsbW1kOFhEbXhTNVJIcFNyby9CTHlsY3FkT1Ro?=
 =?utf-8?B?eXZJM3hPVHNSNzJ2SlBvY3AzNGpTV3ZYbHh5V1FYOE8yUlByTUlYa2NQbXoy?=
 =?utf-8?B?WlJJRXplc2o5Y1NRZEE4ZXk3Nm1ER3Y1SFFLVUdNOGJhTllsVklRVGxiWUJ4?=
 =?utf-8?B?WUZsRlRHZjZBcFhEdDNzY1FCckVBeCtyZ2wrOHNGWVNOdXNmZ0R3Qlp6R2NQ?=
 =?utf-8?B?em9YYVVadCtvSEZHaktVTCtuL0w3bjVJaWNpWmJSRGRyNGYyaFBUaTNGUG4y?=
 =?utf-8?B?L2tPVTdFUVZCOTdHQjRIVXMxRnpMR3JJSjNKcGFPZ2lmM2w2VDY5WkVFODlK?=
 =?utf-8?B?SWRySitLQmt3aTNyWVEvU0NFb1Y5S2lGaGJIZXhaVzBGNndGUjduUFBFWVE1?=
 =?utf-8?B?VmRIWnpCOXZNWU4vbzZIb3VkZ1g0TkxiSE9YaXdKcGdLR0pWQnd4R0tRT2pT?=
 =?utf-8?B?cUxNNGxIaHh1MGJXT0lFQ0JHcXJvaGlBYXNRbGlhbzN0cHhQc3hsalZPZ3dJ?=
 =?utf-8?B?TXJxT1I5dElzMWV3a2tNZStlbHNFMlYzTDF4cFRKeVdaTVcva0djazJLOVc3?=
 =?utf-8?B?eHZBMm1DRERUcHhhc0ZJTXl2NVR4cUNOQnE4R3QrMlNHUXNtSWtuUnBqVEt5?=
 =?utf-8?B?ZnBBbFVoVkJYRm9sajlyaXp3MWJXMUFjemdzTVI5anBuTHc4anRoTGU5YitT?=
 =?utf-8?B?RWhjVE9tV2YrZU15QUxHbUE1ZnYrcld3a2tVbGk5d1I1MW9hYUVzdFo3VWhB?=
 =?utf-8?B?RUdFeUhXWkpYQks2Rm5rcll6MjRPdkIyL05aMDZnVTVVSFd1MzRCM0FwLzZo?=
 =?utf-8?B?eTBLL2swZG9oWDFNUVJkdllTTktkenBuZEJETFBxMXRlajl1N3NsRTljYVpw?=
 =?utf-8?B?WFY3U2ZDZjlQNmZOaEc4cCs0TkxkUVV0UGdabEE2OGdrY2YveWh5K25FZ01D?=
 =?utf-8?B?TG44MGVVZlliU2IyRVZwNklCYkNIelZ3aXYxbmJGWm9YaGdVbGVpMnp3b1kw?=
 =?utf-8?B?UlViMStHWkpYRHMvZk9BSlJWK21YRnpEb3JrTnRJcUpLK2t0RHNJRmhraWll?=
 =?utf-8?B?RHRCOC9OdXllVVl5UWpubmQzekliZ21XNU0vY0RRY01YSlNpbnNhNEZXWkND?=
 =?utf-8?B?bHFSWEl5TWJtM0MyNUVKQ1lhTjB5S0VzT2ZpVi9NZUVwZVlXd2dSZGM3cnF0?=
 =?utf-8?B?Y2toQmpOVURpUmZMWkNxQjlVK2oxWVdQYWRXUWREZ3luSi9YKzRBYU5IOWxJ?=
 =?utf-8?B?bHFsZ3lDRGhoZE95c1ZxNFkxcTVML1ZaTVY5NThlMllzUGhJcDdvdGFMRUNw?=
 =?utf-8?B?U3B3UHh4WGhJZEJtbnlIVTA5L1diQmtKbjV0Z0pvNFBRUENUVkFXU0VJRWNy?=
 =?utf-8?B?L0NRNmZsRDFraHNZNy8rcGVCdUswSGo5R01WNDl3QnFTOFhXa3VmR2NxbUxW?=
 =?utf-8?B?RnN2WXhQQ2lQVkNpUEdkT3p4aXpJb3ZjQmRGYXhlMFNvVkFtYzJDOWsvTUxs?=
 =?utf-8?B?d3NRQ0ZaTkJOYWVBc1laMkV1aXFWY2hQNmRoN040N0drNjRjVGhyMEhOV2Ur?=
 =?utf-8?B?T2NrNGVCeGJCNmFWMXMxZmpCd0QzelJlTmhYWU5lT0N4T3JBMGEvYTVhYmds?=
 =?utf-8?B?SUtaM2xKeEQwa1ZkTUxZampQY1NtUjVWOUhzNTcvM2hZdmlJeTY3U0ZiWWFK?=
 =?utf-8?B?V0p1SU5jc0NrVDFrZlEyYTM0KzhTMS9VS0dpNG9RSEdQQUE1bXFzcWRjSU9P?=
 =?utf-8?B?NlV2RTZDd3Z4c0FtZ3NMY1VNQmpGbVpCYUZVcDRxVHdyTlhiaWZ6bWVuVU53?=
 =?utf-8?B?RWxIWmtVNXl6WDhYSUxUUHR6SHFoemxaUXZJWm9ockN4TlRid0gydlZIMll1?=
 =?utf-8?Q?TY1P5l+DOUFF+eVC60F6czk0b?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48035ED75E02D14B8A35684F9DB79D37@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f1e630-e616-4c92-b4f6-08de2c742575
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2025 22:44:08.9310
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KtH43mv8o43ZwmjrshR+Gxg+vv82CzSzVpUknjqFOR8husfqBGxr+rXbWh4UtLOsQz90HJoo2JfR2pTnCelabQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6415
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTI1IGF0IDIyOjMwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IMKgIC8qDQo+ID4gLSAqIFREWCBTRUFNQ0FMTCBTdGF0dXMgQ29kZXMgKHJldHVybmVkIGluIFJB
WCkNCj4gPiArICogVERYIFNFQU1DQUxMIFN0YXR1cyBDb2Rlcw0KPiANCj4gTml0Og0KPiANCj4g
SSBkb24ndCBxdWl0ZSBmb2xsb3cgdGhpcyBjaGFuZ2UuwqAgSnVzdCBjdXJpb3VzOiBpcyBpdCBi
ZWNhdXNlICJyZXR1cm5lZCBpbiBSQVgiDQo+IGRvZXNuJ3QgYXBwbHkgdG8gYWxsIGVycm9yIGNv
ZGVzIGFueSBtb3JlPw0KDQpBbHNvIGZvcmdvdCB0byBzYXksIEFGQUlDVCB0aGVzZSBlcnJvciBj
b2RlcyB3aWxsIGFsc28gYmUgdXNlZCBieSBURFggZ3Vlc3QsDQp0aGVyZWZvcmUgeW91IG1pZ2h0
IHdhbnQgdG8gZHJvcCB0aGUgIlNFQU1DQUxMIiBwYXJ0IGZyb20gdGhlIHN0YXR1cyBjb2Rlcy4N
Cg0KPiANCj4gPiDCoMKgICovDQo+ID4gKyNkZWZpbmUgVERYX1NVQ0NFU1MJCQkJMFVMTA0KPiA+
IMKgICNkZWZpbmUgVERYX05PTl9SRUNPVkVSQUJMRV9WQ1BVCQkweDQwMDAwMDAxMDAwMDAwMDBV
TEwNCj4gPiDCoCAjZGVmaW5lIFREWF9OT05fUkVDT1ZFUkFCTEVfVEQJCQkweDQwMDAwMDAyMDAw
MDAwMDBVTEwNCj4gPiDCoCAjZGVmaW5lIFREWF9OT05fUkVDT1ZFUkFCTEVfVERfTk9OX0FDQ0VT
U0lCTEUJMHg2MDAwMDAwNTAwMDAwMDAwVUxMDQo+ID4gQEAgLTE3LDYgKzE5LDcgQEANCj4gPiDC
oCAjZGVmaW5lIFREWF9PUEVSQU5EX0lOVkFMSUQJCQkweEMwMDAwMTAwMDAwMDAwMDBVTEwNCj4g
PiDCoCAjZGVmaW5lIFREWF9PUEVSQU5EX0JVU1kJCQkweDgwMDAwMjAwMDAwMDAwMDBVTEwNCj4g
PiDCoCAjZGVmaW5lIFREWF9QUkVWSU9VU19UTEJfRVBPQ0hfQlVTWQkJMHg4MDAwMDIwMTAwMDAw
MDAwVUxMDQo+ID4gKyNkZWZpbmUgVERYX1JORF9OT19FTlRST1BZCQkJMHg4MDAwMDIwMzAwMDAw
MDAwVUxMDQo+ID4gwqAgI2RlZmluZSBURFhfUEFHRV9NRVRBREFUQV9JTkNPUlJFQ1QJCTB4QzAw
MDAzMDAwMDAwMDAwMFVMTA0KPiA+IMKgICNkZWZpbmUgVERYX1ZDUFVfTk9UX0FTU09DSUFURUQJ
CQkweDgwMDAwNzAyMDAwMDAwMDBVTEwNCj4gPiDCoCAjZGVmaW5lIFREWF9LRVlfR0VORVJBVElP
Tl9GQUlMRUQJCTB4ODAwMDA4MDAwMDAwMDAwMFVMTA0KPiA+IEBAIC0yOCw2ICszMSwyMCBAQA0K
PiA+IMKgICNkZWZpbmUgVERYX0VQVF9FTlRSWV9TVEFURV9JTkNPUlJFQ1QJCTB4QzAwMDBCMEQw
MDAwMDAwMFVMTA0KPiA+IMKgICNkZWZpbmUgVERYX01FVEFEQVRBX0ZJRUxEX05PVF9SRUFEQUJM
RQkJMHhDMDAwMEMwMjAwMDAwMDAwVUxMDQo=

