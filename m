Return-Path: <kvm+bounces-14716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4008A61C9
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 05:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC25D1F23EB0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 03:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C168208A4;
	Tue, 16 Apr 2024 03:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YFWUj28Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CD217999;
	Tue, 16 Apr 2024 03:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713239125; cv=fail; b=jt3tjMc9CzcYjDeCA9sLRJHJLjDQrL92tknubjymRssO+YQ3jg9RlQ8YBnVhmctfbzy3uoFaSUf6V1i/Hau7Hd3dblegYzQwxrM8qneRNqnhPK7BYGffzJ5COOh3B+VxoPft1upgEAUNReWH/HaTvIVn90ElMIICN9luAQ6dR3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713239125; c=relaxed/simple;
	bh=g6byyn0l/VicaIYQ3h1XMnMSBzwxRgwI2zmMJBsVAjY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U2aeP8BbL5IZac1L6Y/gCiqbHuAwbt8y+pGMUQLXyTt7D3o+OYa7cU7VWKEQKJ03ScL/NwABEF9uc7+PItVWVs6IJVm/IlPHrs8Qkc1bsCbasN7WmsZjaH+nmTMhwm4hEq/kv2Uk7euRvxBLfNo0nCJRNtKXIe3BIVHIdGXrb3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YFWUj28Y; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713239124; x=1744775124;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g6byyn0l/VicaIYQ3h1XMnMSBzwxRgwI2zmMJBsVAjY=;
  b=YFWUj28Y71azKjt7+NCYaAdDsF6Tv0gZFKoefAv33fvaU+E+HFEg2Kah
   KrRpdKEknmDVvcqEJUmKqKEvyW9ET9r9d730pKJ4WMboGUQTbfkD2J1lP
   rHf+4Lw9JP0Pms3Xu2/LSI+AoNIuhYMjHvgq+6Z46y8Hazaz4Xv6990MZ
   btKw6VHab2d/i0vAHXak6ibRAxI9ki+kok4JI5DnhSsYvafIWJbaK/lua
   KuIgMjH3UT1oyw8z/XylyMnlNkw84ArNdTzR9UlN4BDwOUKAfT/QTd0GK
   cWCoPhZo9xJw3m2F9hTJ7diphOraeBUe9Kk/NQA30OOsULjw+XDVk0JGG
   g==;
X-CSE-ConnectionGUID: nZXHcCMTSYSxt/u4oeLZew==
X-CSE-MsgGUID: s1THP2e3RBmgt0pWJg81oA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="19364875"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="19364875"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 20:45:23 -0700
X-CSE-ConnectionGUID: WY9RlofQSa6ml9O9juTkJQ==
X-CSE-MsgGUID: 3WNGxG5GQ9yusSxPQitPVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="59571574"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Apr 2024 20:45:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 15 Apr 2024 20:45:22 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 15 Apr 2024 20:45:22 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 15 Apr 2024 20:45:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDCZBNjND7gjUmQEwo9h6rHYB6mOwg2bBKdKpHtm28XWmImVxGniH791Sc3cNWF4WsUIVnxuZ6qhc63pZptr5V8WN7OJxrN4h8RKQwOBxNqi4d85Rn66/siSAmBs+vUDm0JjsIg10V5fkxl4tC2CicrX4e7+IYmie3ZpcOTHiXoWNcDlU96C2nK5lUQiNY6PYBszSeNVPkRhxorv9ed74SMV01knOCX7tbprJiLA0aSv6ZPt4hTV8evlN9NRqFEHkTDrpA7DSjx0Any59A9CE5cGjcjm44lFwG/trnHdImXKPEnn16UF6Mx/0zXLJck7I7Yz5sC8BxiblRp6L5XcCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g6byyn0l/VicaIYQ3h1XMnMSBzwxRgwI2zmMJBsVAjY=;
 b=XEtWxx11YhZ/qlQ2FORgVU1m4hkk2IEJv8f7K3JuyNkIvkbvoEtNlDkYBzAnpKeI4l7EO35oXj2NgfjnMRZM1MLnMTHDJTv6KbhZcUuJ5dSdIw83Ixb/JyQSTbx+Z6fZHL5CfD3fDeFR6c1BH4Oues9JgBNPNyQFZ3eMNc27XOiPL2SdLBoeZuC2thqUyM9B25cGxGzBqWotNiTo7C1yz8Yr2VoLGleKPqQLr4ziSs3AX3CXt9bGrNdflZXh03MEzMi0kZN99tzrY6VhJznL7u1qgs8pz2HGBvgKo6aAGAigUYlkFCTfFa0C/rrsYrLxHG34W6ZvgiGh0395l8jtTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN0PR11MB6010.namprd11.prod.outlook.com (2603:10b6:208:371::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.28; Tue, 16 Apr
 2024 03:45:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 03:45:20 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
	<linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, Peter Anvin
	<hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>, "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
	<ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>, "jim.harris@samsung.com" <jim.harris@samsung.com>,
	"a.manzanares@samsung.com" <a.manzanares@samsung.com>, Bjorn Helgaas
	<helgaas@kernel.org>, "Zeng, Guang" <guang.zeng@intel.com>,
	"robert.hoo.linux@gmail.com" <robert.hoo.linux@gmail.com>
Subject: RE: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for posted
 MSIs
Thread-Topic: [PATCH v2 05/13] x86/irq: Reserve a per CPU IDT vector for
 posted MSIs
Thread-Index: AQHah6hds9I+TESl7kiFR5xiGDPLp7FkZAcAgABXwgCABZSTEA==
Date: Tue, 16 Apr 2024 03:45:20 +0000
Message-ID: <BN9PR11MB527615053A012DB570999FB08C082@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-6-jacob.jun.pan@linux.intel.com>
 <BN9PR11MB527609928EA2290709CDB3E78C042@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZhlEh7-NoknHcNX7@google.com>
In-Reply-To: <ZhlEh7-NoknHcNX7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN0PR11MB6010:EE_
x-ms-office365-filtering-correlation-id: dea89496-3e9c-46a3-9202-08dc5dc7a378
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FQoA1UMpqDA0N5nZFhMq+dKsvx/3p/x42vVyjgI7+JO65aN3eCMbUrfUZlcsE9Vz/bcXcjHltzURWsp+cdUAw6UUpfMdcYqYj3MMb5F/n5N+B923msF8bOB4f6pmCWSs6avc81V+ofvUngH0GZplbczsfk6R2Qw2aXvGxR68XpUot52aeCsrHMHm2o7A/RztJxkpv8U2OC1dR3TPIi/Jgo8ROhS+iAuOAHREucAaG4bDRIfj6tUCdMWI1fe4ClPUfio+HAKyXllj7okseMDzoW7j1NKW976h+/kN5JyDA6AoZggEm7gIVeQz1gJPJ9jHCht0B+UERvspySBSYDHf/5+atvkcG7QtBggJBoOgjUmaJ+u9TQLuEy5LD+pyiReAMivhZk6YbNKvemQbf+ASCU89rGupA/sX9Z3G0rSoLqYhzhfVuA+h0d3FXwqOAseCkXL8DFsQrejpuXip/A1rTIsU8X1eydXhWoqrpTAxqVLKZFqIk+EReuobchiOY/31D/E+2CFax3Ge9i9yGd6+XMX9b5+Mx8rKkb+PQUVx5aAluAQ1grDqmoDj8r792wVN4OPPCoMw3WygKmfG6bnIRfowUnXVjR5HRq8x+3SUKG2OpSqfhpVw4PWXjhGb4zBnL32QKs/YYFwydomPnCsnIk8itsJfHZ5Wx+rQlPMTKk4KP/ezKbA66chxG4A9fHwl9LUrqVmjBQsYIYnoDk5tOARxXWu9FuYC3POxDha30n4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTZMTXVOc2EyZ0lJTDEwVDZaN0tQOXJWczFVQXZlOW4vZnJwWnBjam10cXFp?=
 =?utf-8?B?NXlwQWdPTkNzZGpEcWowUzZuU2xFeC9yZWRnOHFaK1JrYllxZ3pNd0R2RDlt?=
 =?utf-8?B?RXU4TmVqZlRLQUp5VEZrKzNQQmhmelJKVU4rS2JxcmNHZm5YS3ZMaWtKQUtq?=
 =?utf-8?B?RFg1T3BnQ0pWNlBwWnN5ZGw4UjhnK25LSjZJZmFIWmUzYjhKRUlrYWhNODZQ?=
 =?utf-8?B?TXNsSTB0SHZwemx0OXoyRmdQVjB3MXRKdmlUbmtuSm1RdkthZ2l5cERaWXFE?=
 =?utf-8?B?Q2xVcnYyS2tlVU9DeVZtTFRxOGoxS1dnWEEzNjRlb0kxUWx4Nno4OHNDRWdI?=
 =?utf-8?B?blVxVVpnNE9Yak5yZU91SWFxczMzT1dkalVKTUxnMloxNFowK2RSRjZ2V2Mv?=
 =?utf-8?B?eG9FNFliYnR0RHNpNjBwR0Vab205RUwzc3FDQXhyOVovbk10cXVkTnpoWVh0?=
 =?utf-8?B?RXo1NjNSUW5wbHB0MlZlM3NLVzVGYnFkajVnTGtMN2grRTRSRGlGbWE5L1Ro?=
 =?utf-8?B?d21pTmFvcW5uM1R0ek9kZkhucmFQd2txUDVEcmVVcjh2VFpXZlFKNGU2cFRX?=
 =?utf-8?B?N21maVM3TDUxcVZuS2pkK3BGbGVxOU5ESnZ3aEQ2MHVXdjdwTEtqSkpiZDZv?=
 =?utf-8?B?STlzVFJ2UXp4TktnS2MySnU1K2dJSWt6eHY3Y0ZLTTVRM3ZxUGhBUHVCOXpz?=
 =?utf-8?B?TTZEdkUrRFNSdnZ2aDRXL0pXeE05NnZBQWNCckp6WXlPakh0b0xvZ0VlSVZS?=
 =?utf-8?B?RE1rbmRhcFlxdVZSamdUMXFDY09mb1h1RlYwTTRlODRxSGVPOGxWMkIxN0Ry?=
 =?utf-8?B?SHpieWVUQXB1aEMwaFgvc20rNFZPQ3FkcERxNFQza2lLcXBCWCsyejhVOFFq?=
 =?utf-8?B?SWdvZHJNTVUreUZtSEs2WkdxVTBwU2Q0VE5NSTdNbGJCbDRxT08xcmNjaGo3?=
 =?utf-8?B?WFdubFp3UzZWdVhoTUVXS2pkTVk2YWFCSDREVDRnbnBVYkx2SDdQdHUzTXNK?=
 =?utf-8?B?MU14MHJ3bng0Mitaa1JXSU1XSGZTbTZPcW1YcUh1MWNyVjhyNzNac01reElo?=
 =?utf-8?B?bjgxS28xTFZsa3VFb29YeWMwdnRJdW56SUZXNlFBbG1tNnZlNFJzZjV0ZVdM?=
 =?utf-8?B?T0ZTeE5mYTUxbGptS2JCSFk3am1YbGdjRjdDT0RBZjE0Ymd1QWtHRGFjK2gw?=
 =?utf-8?B?VGdTWklVRHFmdy94TU5DYjlzL3FBSHUyNk8xeTZReC9CaEpSVVl5SW16ck9I?=
 =?utf-8?B?Rk4va24zRmVYWjl1Ti92NndpdDAvb1pOcUZaM2owSE9RczdySVFmY21BZGR0?=
 =?utf-8?B?MWRCaEFIalNGc1VTU0VwN0E5SkI1Nk40SFFubFp2bGlEb1I3TllDU1ZoOGFG?=
 =?utf-8?B?cERydnRCUEFrTUY2VDdmVFg4c0w2ZG56RkhnbG9HM2JQMHZGb2U1cHkwQU5v?=
 =?utf-8?B?b2xrb1BhUUYzYmM3WGRrZjNPaTZoRFNKTHR2UHFDWGorT2NTMXAxVklGdktz?=
 =?utf-8?B?VGRFSEIvTEZGWUNmUUV1K2g0akdlUEVWNDIwcU44ZjVvZlVKTm1YbGlsRnRr?=
 =?utf-8?B?Kzl1SDJOSUN6RnlTZzlCTEVYcWZEa3VKZnJGRlUrdlc4a1ZydHJRT1JBTlIw?=
 =?utf-8?B?Z2d4cWtObXNxQmswdFFPUEM1Zlk0T29LT1dOY000aUI3K1FrbHRmL25pZzIy?=
 =?utf-8?B?WEdmdVNsRlMwWHA1VXA3Z1RYY1plNkMyUzZ6SzhhYU4zMkdZMGdRSkF0ZUpW?=
 =?utf-8?B?NERXTDBKVFRUcDRHR0xEUHpuRXlZcXpLMmlzdWh3WVZHQmY4dEtYVWJmZHZk?=
 =?utf-8?B?Q28rZE9jczFnOWhEb1VQTEk4M1JRd2F0eTlhT0VOdk45N3hYVGk2VnJSQlU2?=
 =?utf-8?B?WkN4OHNxejM4eHVYSHZZZjNXY0FVWmVDMU15b0JxcDBLY0xmbEVaelRhNURk?=
 =?utf-8?B?emttNnR3a0xzbG1kTVlFT3NEMjBRM2JsUnBscHNFNXU5L3ZLTTNxOEFvdlFV?=
 =?utf-8?B?ejRFMmExa3FpdmVYWW16REJwRWo0VVZiRy9MNk45L0xYMHZGTS9yZUpUWDQy?=
 =?utf-8?B?T3hDcFVVSGR5VmpKN0sxaGczSmlGeW5oUEVqTjAzZXNhVm9pWit1RFhXTmJp?=
 =?utf-8?Q?oZJsiA27Bqb5e6jq3OFMLN+Il?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dea89496-3e9c-46a3-9202-08dc5dc7a378
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 03:45:20.1944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzwUr/nccrdHsq3qwfzI2Njj+JIppEN9B/WwwqY4rh69tqwc1xd3s2ue90ynLz1n3DCqTzW7ZAGAMJTSJPSmMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6010
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
RnJpZGF5LCBBcHJpbCAxMiwgMjAyNCAxMDoyOCBQTQ0KPiANCj4gT24gRnJpLCBBcHIgMTIsIDIw
MjQsIEtldmluIFRpYW4gd3JvdGU6DQo+ID4gPiBGcm9tOiBKYWNvYiBQYW4gPGphY29iLmp1bi5w
YW5AbGludXguaW50ZWwuY29tPg0KPiA+ID4gU2VudDogU2F0dXJkYXksIEFwcmlsIDYsIDIwMjQg
NjozMSBBTQ0KPiA+ID4NCj4gPiA+ICsvKg0KPiA+ID4gKyAqIFBvc3RlZCBpbnRlcnJ1cHQgbm90
aWZpY2F0aW9uIHZlY3RvciBmb3IgYWxsIGRldmljZSBNU0lzIGRlbGl2ZXJlZCB0bw0KPiA+ID4g
KyAqIHRoZSBob3N0IGtlcm5lbC4NCj4gPiA+ICsgKi8NCj4gPiA+ICsjZGVmaW5lIFBPU1RFRF9N
U0lfTk9USUZJQ0FUSU9OX1ZFQ1RPUgkweGViDQo+ID4gPiAgI2RlZmluZSBOUl9WRUNUT1JTCQkJ
IDI1Ng0KPiA+ID4NCj4gPg0KPiA+IEV2ZXJ5IGludGVycnVwdCBpcyBraW5kIG9mIGEgbm90aWZp
Y2F0aW9uLg0KPiANCj4gRldJVywgSSBmaW5kIHZhbHVlIGluIGhhdmluZyAibm90aWZpY2F0aW9u
IiBpbiB0aGUgbmFtZSB0byBkaWZmZXJlbnRpYXRlDQo+IGJldHdlZW4NCj4gdGhlIElSUSB0aGF0
IGlzIG5vdGlmeWluZyB0aGUgQ1BVIHRoYXQgdGhlcmUncyBhIHBvc3RlZCBJUlEgdG8gYmUgcHJv
Y2Vzc2VkLA0KPiBhbmQNCj4gdGhlIHBvc3RlZCBJUlEgaXRzZWxmLg0KDQpJTUhPIG9uZSB3aG8g
a25vd3MgcG9zdGVkIG1zaSBkb2Vzbid0IG5lZWQgdGhlIGV4dHJhDQonbm90aWZpY2F0aW9uJyBp
biB0aGUgbmFtZSB0byBkaWZmZXJlbnRpYXRlLg0KDQpvbmUgd2hvIGRvZXNuJ3Qga25vdyB3aGF0
IHBvc3RlZCBtc2kgaXMgYW55d2F5IG5lZWRzIHRvDQpsb29rIGF0IHRoZSBzdXJyb3VuZGluZyBj
b2RlIGluY2x1ZGluZyB0aGUgYWJvdmUgY29tbWVudC4NCmhhdmluZyAnbm90aWZpY2F0aW9uJyBp
biB0aGUgbmFtZSBhbG9uZSBkb2Vzbid0IHJlYWxseSBoZWxwLg0KDQpidXQgSSdkIG5vdCBob2xk
IHN0cm9uZyBvbiB0aGlzLi4uIPCfmIoNCg==

