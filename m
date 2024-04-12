Return-Path: <kvm+bounces-14483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 121F48A2B53
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 11:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 912F21F220C8
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:36:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FCB51C34;
	Fri, 12 Apr 2024 09:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NyEkRe2b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8A2482EF;
	Fri, 12 Apr 2024 09:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712914575; cv=fail; b=pPEbSCBsNLLeIwMMt2EwPhM42DcMsVIB9Kbtk++MM00uk3OEoU9F7MIFOvfi+z7vp8SQvyspahNlfruLp8jmODEhqw6sAla7rrqCDbIddZr5HAjGw7m4P0nDGxPyaOK67Q0Tqvjov4S+LYzoAXqlz4VGl+n4fzt1R/KnlIVnm7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712914575; c=relaxed/simple;
	bh=fOyLjKvF9CDEgjXk3HsJwTza9hsXwoIV8nM/iLkSqZk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i4d1GIH3MWDb/g7JPFCwuhGgG4v89oodR0JidZoleISozL/TC2ibk6ja5LmfudaYzxifEu3o/VINAoVHr7ozfYS0WQjVHDslmFNmf50hqLZEKvi+AsE21rfRTYpJcRtJjGsmyzoZ0sp/GJu0Zj4jBzHH0J9i4LYWWkiJ/aeLkOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NyEkRe2b; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712914574; x=1744450574;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fOyLjKvF9CDEgjXk3HsJwTza9hsXwoIV8nM/iLkSqZk=;
  b=NyEkRe2baAwq8VjzAOlo3CFdozJJ0zg1RjGcj2tEl7MEhpxB5+Lz5ifH
   ygkL9bL5OS6m0Zr9dc9eWsQpDtGQJlASTTtg4JlLlBvyc2D9NqY9pQzkr
   wg2qVl3YIzOcmKJutTXPYHx+SgJWmW2XtATBxFI6PYWFTrC00eWbh+J2p
   cWYrIz2ue67F/n1mqYCklSddtD0qppHPDORsZwGZChxaoqfYWSsxNpiNL
   BrzG5Tr5mpHEU9iWH1sr6HYFLU7BnBXZ9T6H+1tZhst5bPX7xgRK3NvG/
   c0dr3eCWdwHSiQEcNPJBFjcd9yL4n6AbqZ6VgghLEqBXM/4JQLP37s+IM
   A==;
X-CSE-ConnectionGUID: 08gvW4kOT8megYqNn+7f+w==
X-CSE-MsgGUID: gtWkkYWMQVaqqYFYKV42Zw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="12215836"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="12215836"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 02:36:14 -0700
X-CSE-ConnectionGUID: MWimMQr5SUSyxBSnKTVTKw==
X-CSE-MsgGUID: R6M2YYRgSRalq9qVXk6XWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21234140"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 02:36:13 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 02:36:12 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 02:36:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 02:36:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BB/674bwZWf0p2O1+Uqz839QZwvbQxpjjhA+XgNxpAm1atZ7S465jP54AQ4R+NFGavlWZ4X9EUH2PMjsEMuZ/qmVOYIH9moaPV+JcY4JCGa43FmI3rgJkG7JdPiREu47bCZ5/Dtza8vknJyGZVE7HvyAbdDRhXZ9uhN7Pffrq1tPGJPCzLn0ITVmjWY0Raq/TCzKoghUEAT+BdEeBzOxOwKNZ8VSM44E6QT6uEB5SIRdST6/rQ/t9cNCD4Z9VWnpdPzJSCDkez88A7Byo7bvEL4syGYhymZMvESRMsQQe5fIaf3kB9NEB6KMxQR3o1cua20J8BTWJz6bG/mvXaRtSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fOyLjKvF9CDEgjXk3HsJwTza9hsXwoIV8nM/iLkSqZk=;
 b=dTdJ5RMY1ezHnE7zGqhziakrE0k39gT9yKg4BmMVjE/BUsALgUbwwumWz45Hp0wL/INiLnvo7WOr0gjVMMZcjZEHSNv+LDc5MtOeX35WEGa+aJZQg8GCj2pIPLcuSIkTJ3WY2zrroLqs9B5l+qglGHoJFDNrqiPFEjE4xbTadvEbqXEXdexSH62UvrKf6AhC1vqGwBEbmibw4lo0nEtJcIzONBvXzYHEsX6UUhWlXYgi+E3Ttum/OlrPB31XxCTUaa/BT0skqahxu3Hjv0QmVRkQ43/MxSZSWDqvsTBwVpMYSFWDh9undEaRYz6TMMfl7meY84vj2iU6bom5BjHPFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5012.namprd11.prod.outlook.com (2603:10b6:303:90::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 09:36:10 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 09:36:10 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
	<linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>
CC: "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
	<ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, Robin Murphy <robin.murphy@arm.com>,
	"jim.harris@samsung.com" <jim.harris@samsung.com>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>, Bjorn Helgaas <helgaas@kernel.org>, "Zeng, Guang"
	<guang.zeng@intel.com>, "robert.hoo.linux@gmail.com"
	<robert.hoo.linux@gmail.com>
Subject: RE: [PATCH v2 12/13] iommu/vt-d: Add an irq_chip for posted MSIs
Thread-Topic: [PATCH v2 12/13] iommu/vt-d: Add an irq_chip for posted MSIs
Thread-Index: AQHah6hhsNvQeu6NdkOEy+me8PzsJrFkaSAg
Date: Fri, 12 Apr 2024 09:36:10 +0000
Message-ID: <BN9PR11MB5276051CAD86374C666ACFD48C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-13-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20240405223110.1609888-13-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5012:EE_
x-ms-office365-filtering-correlation-id: 929f3bd8-08cc-4378-4ebb-08dc5ad3fcb2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jcEKfjkpm3nqwZhax6B2FsOKZT1C82oHp8Qr4yezpiDI8ru8Pkur+4+yFCz65TPwkR0hJH1Ths36o4QYgfqqLv8mahol0jnCDOBqvhgt9gpXNyzZMt7YKH7rHRUfZhizO+l9XiSIOFZITd4V4sz2MONDNOOj0vnyjwU+32B7fvFyl2dfiBSRhSIqUsQ8Z5D9mAzHEzNzievKsSbd+byFjJjBcvwrBjlpZLbrHM9ZLcttfb6SSRGj6rULNYBZZTX+ZaOuRWDVajD2JF8saSOx157W8DejCWm7iYDC+JS0utT2u3XJ+FvOF1yqQan1vh6FGzzXx6jyqNL3S6QtnfT2Ecky1wtB0fulR//3JGRsl8I3+LA5mC0680J2F3qqjbcbx/rVEgKu6yKHUw4VlvGXPz5CSxZYP9+ZLq0bMysptu89uFeFAvHG7UJOESOIYC769QLeJqqx1GUql2DiwSCwT4xpVYXfJSePg3qlJoVIvrpQ0yoR/CqWPtCO2JcE/Z5CBUCYLZiDQHCEs+pQn/hlsJuPuvnNbu+au5+6jrXfyS1x4roYjsu/mjTzfhv8O+1wfGvS+mvzu4NIk2q9bESmwLxcH8cwEM+gSu0e5vau0OO3e7z6JMqyrxgmfHEGxLJyDrUvw/QRQgwScZ5SnLrfqIFGHcW9q4K6lcnksweyH32XDO54naiXleb0beWggBPRbRHE3MKrNVK34+uHUd3hEcQJa2z/lU7sAEN5V5Ul8Bk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlVYbjRicVltY0lIdWZlT3ppTnFqcExIV1hGZkcvTkhLYVFFZEN5bGkrRUV4?=
 =?utf-8?B?UDI1WVZ5WmpWYll4MmNUSk83MkEwbGNLeFllZXF0RkxwWVNjcm5CTGErSEFn?=
 =?utf-8?B?TzNNaWtKM2RRZTB5MHhiTkdrMHFPZ2lRc3NKcjdEMEQ3YTM3Uk1pRXNIVElU?=
 =?utf-8?B?WDVTTzY4MWFKMlZTMXhCZm1RRWVtWUhmOEc2b2JCVitSZGFDMFg4MlVZSzd0?=
 =?utf-8?B?T25qUkI2Q1hHM3drUDcwbGZVd3JzN2NPTHAzcVZENHRWdThuazBaVG9VY01Q?=
 =?utf-8?B?c0ZUM1VTTFBGSDJySlJaR1BvZDFqRFdyYS8zV1J4N1FsaFdSRmJlQk9pclJV?=
 =?utf-8?B?Q2lFUXJ2b1VoQjZDUUppeXFHcE5jTHpORzRWZXUvRGwyRWplUmEvck10TVJv?=
 =?utf-8?B?R3JLK2JyOXB0aHlxVTludGpKMkt2bkN3Y2IvTE5ocE1wM2EvVnRZSDIyRDRV?=
 =?utf-8?B?R25qcC9VTURpTEFKYlBQT1E5ZU13RmVqcDgzc2RFT0kzYnN4NWdyUURwL2JV?=
 =?utf-8?B?bWdkUEg2VDJwc2VpRFJ2cmVFZnUyTjJmdnZEbVhISytXakYzM0FOY0N6Y2gy?=
 =?utf-8?B?b2ZtWFpNR2hKelFHQ1Z2QVNZdENNQnlEWnRuRk9XOHcxbDN6Z0JSSHZVV2xl?=
 =?utf-8?B?bmpvN0pGUXU5b3psais1Wkk4eS9JVHNDY3RSNE1mZlptSzcwaG9TWkFvNkFR?=
 =?utf-8?B?MjZJS00yU25pTVg4TDJ6LzRIUGhmeTlrNkFXbEF5bkVPclg1bjdaMkxmYnc1?=
 =?utf-8?B?TFpRcU1hT3FPZDhydnFpcFkvYk1qb2FWVFdhbFd2TjNpTVNtVlZNL1d4NU9S?=
 =?utf-8?B?bjZUSnFXLzY2UXJHV2VrZDNuTDFSZGpoWGJSWHNmUUFSazEzeGVlUHViOG1o?=
 =?utf-8?B?U1NGRDdBU01iZENFQTB2STRDK09yTzhjOVJFdm5RZklsaGljK1c1TXVLM3U0?=
 =?utf-8?B?SVZoVCt4VWxyMVJDeGJLWHIyOGovNDhuWTRMZkVpUWMrL2UwYWM2TjRISXRu?=
 =?utf-8?B?RFZFbTZlaGRwK2tiMHZaTjJOMDZvTDRrbTNXa2phcG12MXc0VTMxa1MwWXBY?=
 =?utf-8?B?Mlg4TENvTEdhS0EvVVh3VFBqOTVzWFhUNDVDZUUzT0d1U1pibzF0MmRGcFZ4?=
 =?utf-8?B?WnJUU0FOOHFqSDAvZnB2NGsvWWNCU2pMS2x0b0NJWWIrWVBkKzB0Tko4MzNN?=
 =?utf-8?B?Ky9hcW8zV3lTczV3OXdDcEEyVkhGcXhsTFJTSU9GME13S1VmMFJhdUk2T3Zp?=
 =?utf-8?B?R2JMcjF1bk5iT1ZtRlRxb2RYcGltcm9ZNWRGdTVteFlHVjlmZDVQOWVpc2hN?=
 =?utf-8?B?Q3VGS3BZd0xieXlnb2xzYnh3dEttTitVWWFZeE9mY3RxNHR1ODR1WjlEMTVQ?=
 =?utf-8?B?R3VBWTVuQUo1T2ZCNUlDVzF3NzVWc3dMeG1YS1BNdCs5ZEVtQ3ZWZHEwa0Zk?=
 =?utf-8?B?cUNUNkdVV1lmM0VtS1VIdk5mblNTYmVxajdpbUYxc2tvS25lQm9tclhLemxV?=
 =?utf-8?B?VTBoTENBRzYwTkRqVjF0Mi9MOTY4eno0UFVKMVFJdUY4WDRwc1ltSk96cTZs?=
 =?utf-8?B?azV5RExuN3lhMjBuUmZBVW5OVkh0TWVibXdDL3hOajZLY3hCWHFWSlF1Z1FN?=
 =?utf-8?B?UStEQzNNOFova0ZkVTBKN2dnUVZyakpzdVUrU0cyOVl3ZlVNOERxSC9wUGxN?=
 =?utf-8?B?WFozUGhYaGcvM1ZuNDQxNVgzWWNjSFZQM2l1U25qZzU5L2o1aWRreVFsS1U2?=
 =?utf-8?B?TEMwOGxtMU04RE5qOU1ycUIzdzFJaENzbnZ5UDRObE40ZEFLNWRIU3dYeGJh?=
 =?utf-8?B?MzFlSnd5Sm92b2ZZenJ0REMvUVpnbHk1WnVEUk9CNGhoYU90U0JPUWFMZ0hu?=
 =?utf-8?B?eEdET1Q4cmtMZnZGeWhrblo2bG9uOENLQkV2MzMvdGh3bm9aeHhMczAzckpQ?=
 =?utf-8?B?VDZCV0MzVi9KR2R2OUdMM1dJZHlsbUlQSjdXdWJUdUt1Rm5Hajd0M002eE5y?=
 =?utf-8?B?ZzVrYzFmZU8zM1VGK3JvRVlXbGhTN29UOE1GazB3SmFRQ3lQa1M2b1hrelVX?=
 =?utf-8?B?YVZob0FteitwUkgyMCs0aDZKY1FuN3BOL0hISFNnbHhHeWd2cjk4dTFIL3Ny?=
 =?utf-8?Q?Xa/RjZ00qEzkjydTD7AGipXLW?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 929f3bd8-08cc-4378-4ebb-08dc5ad3fcb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 09:36:10.3771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PucEgYpiuOZEqTGzGL3p67q0s8oK4e98a3XpzEb+quPDsLX9YU+/3qflWQFUI/iPdRBbLviixFnqqF4TpPK/CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5012
X-OriginatorOrg: intel.com

PiBGcm9tOiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGludXguaW50ZWwuY29tPg0KPiBTZW50
OiBTYXR1cmRheSwgQXByaWwgNiwgMjAyNCA2OjMxIEFNDQo+IA0KPiArICoNCj4gKyAqIEZvciB0
aGUgZXhhbXBsZSBiZWxvdywgMyBNU0lzIGFyZSBjb2FsZXNjZWQgaW50byBvbmUgQ1BVIG5vdGlm
aWNhdGlvbi4NCj4gT25seQ0KPiArICogb25lIGFwaWNfZW9pKCkgaXMgbmVlZGVkLg0KPiArICoN
Cj4gKyAqIF9fc3lzdmVjX3Bvc3RlZF9tc2lfbm90aWZpY2F0aW9uKCkNCj4gKyAqCWlycV9lbnRl
cigpOw0KPiArICoJCWhhbmRsZV9lZGdlX2lycSgpDQo+ICsgKgkJCWlycV9jaGlwX2Fja19wYXJl
bnQoKQ0KPiArICoJCQkJZHVtbXkoKTsgLy8gTm8gRU9JDQo+ICsgKgkJCWhhbmRsZV9pcnFfZXZl
bnQoKQ0KPiArICoJCQkJZHJpdmVyX2hhbmRsZXIoKQ0KPiArICoJaXJxX2VudGVyKCk7DQo+ICsg
KgkJaGFuZGxlX2VkZ2VfaXJxKCkNCj4gKyAqCQkJaXJxX2NoaXBfYWNrX3BhcmVudCgpDQo+ICsg
KgkJCQlkdW1teSgpOyAvLyBObyBFT0kNCj4gKyAqCQkJaGFuZGxlX2lycV9ldmVudCgpDQo+ICsg
KgkJCQlkcml2ZXJfaGFuZGxlcigpDQo+ICsgKglpcnFfZW50ZXIoKTsNCj4gKyAqCQloYW5kbGVf
ZWRnZV9pcnEoKQ0KPiArICoJCQlpcnFfY2hpcF9hY2tfcGFyZW50KCkNCj4gKyAqCQkJCWR1bW15
KCk7IC8vIE5vIEVPSQ0KPiArICoJCQloYW5kbGVfaXJxX2V2ZW50KCkNCj4gKyAqCQkJCWRyaXZl
cl9oYW5kbGVyKCkNCg0KdHlwbzogeW91IGFkZGVkIHRocmVlIGlycV9lbnRlcigpJ3MgaGVyZQ0K
DQo+ICsgKglhcGljX2VvaSgpDQo+ICsgKiBpcnFfZXhpdCgpDQo+ICsgKi8NCj4gK3N0YXRpYyBz
dHJ1Y3QgaXJxX2NoaXAgaW50ZWxfaXJfY2hpcF9wb3N0X21zaSA9IHsNCj4gKwkubmFtZQkJCT0g
IklOVEVMLUlSLVBPU1QiLA0KPiArCS5pcnFfYWNrCQk9IGR1bW15LA0KPiArCS5pcnFfc2V0X2Fm
ZmluaXR5CT0gaW50ZWxfaXJfc2V0X2FmZmluaXR5LA0KPiArCS5pcnFfY29tcG9zZV9tc2lfbXNn
CT0gaW50ZWxfaXJfY29tcG9zZV9tc2lfbXNnLA0KPiArCS5pcnFfc2V0X3ZjcHVfYWZmaW5pdHkJ
PSBpbnRlbF9pcl9zZXRfdmNwdV9hZmZpbml0eSwNCj4gK307DQoNCldoYXQgYWJvdXQgcHV0dGlu
ZyB0aGlzIHBhdGNoIGF0IGVuZCBvZiB0aGUgc2VyaWVzIChjb21iaW5pbmcgdGhlDQpjaGFuZ2Ug
aW4gaW50ZWxfaXJxX3JlbWFwcGluZ19hbGxvYygpKSB0byBmaW5hbGx5IGVuYWJsZSB0aGlzDQpm
ZWF0dXJlPw0KDQpJdCByZWFkcyBzbGlnaHRseSBiZXR0ZXIgdG8gbWUgdG8gZmlyc3QgZ2V0IHRo
b3NlIGNhbGxiYWNrcyBleHRlbmRlZA0KdG8gZGVhbCB3aXRoIHRoZSBuZXcgbWVjaGFuaXNtIChp
LmUuIG1vc3QgY2hhbmdlcyBpbiBwYXRjaDEzKQ0KYmVmb3JlIHVzaW5nIHRoZW0gaW4gdGhlIG5l
dyBpcnFjaGlwLiDwn5iKDQo=

