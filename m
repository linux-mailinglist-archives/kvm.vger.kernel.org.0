Return-Path: <kvm+bounces-16461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E33B48BA456
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11AD61C2244B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA76E28F5;
	Fri,  3 May 2024 00:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScrdPupg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D68B23CB;
	Fri,  3 May 2024 00:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714694996; cv=fail; b=BBZm5ZKug+AJ+vH/Ay0d7aMaftScOAvPcrYVuD5VE8o6x948wnoKY0rJ+yEP6UPbYBXoo27gLtaJWYwI8e3cCGK/Z+EZw2Kj+WBsBAqNNSo4Rarw66VHTFF27LY1hdNhIcH0jeTbHPOr/cgyveBz98BONJwkfqDfrDlbO4U1go0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714694996; c=relaxed/simple;
	bh=dUaHQbx0sLCkis3bxSqaE7UBSLYwVpwfzywlrRttfRY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lYKWZsTirXX1HdHNwhQ0UXRFeq1l2kdLEeb+Z9crDRYsrMZKwjNCFJcLfWYe4xkEQiX3wry4VHM3YkJth8hPcO4MA5YDTj3aiAC9gX6sCWvkERrfZF6FJ9XCR9zDmdxFg+c8VXycxezy5ejvK4u7BbW3kjiZLUyLZQME34ZM/ls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScrdPupg; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714694995; x=1746230995;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dUaHQbx0sLCkis3bxSqaE7UBSLYwVpwfzywlrRttfRY=;
  b=ScrdPupgjRR4TTe6nmjFxHUvKBjQK6cuicud/fDNWOKerId3d3EhbKYc
   MJ6S5qZpnn4EeRyhFpl3ZNUhJFeMSr/+seveYetg8F/OyXUJQ2pQHZhsV
   dB8ZPoc9M+B5rMzVvEWxrw8Pm5rdCspv5Q2kCiWm2RB1jHpplHek7EGNN
   O6F7TLvOvNpI6XSlV/R4gqZgQVNHBTQHYhkp1iuZXg3hPQ8Gq9oE4WnB4
   4f0rIJ1UaaL8vi7d7ZOTTtjxwk0Y+b2fEI0iPUni5c9ypVKJYyjkQZCIf
   Hi+y0Ph9lFrQwveYDw8PRQK+PfoV7mFrJCQWC4KAnZNF35lTAlurYo8UB
   g==;
X-CSE-ConnectionGUID: WPdRre6TTjyzJ4Er5MXJ/g==
X-CSE-MsgGUID: fE5OGepISxyUZrtmEnUmZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="21185890"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="21185890"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:09:48 -0700
X-CSE-ConnectionGUID: 2lIlGYgoQya5sk9blOPjKw==
X-CSE-MsgGUID: vgSiKspkTbe8PsOAHgjyEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27698190"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:09:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:09:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:09:46 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:09:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:09:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJ+0BXKwJFyq5oAVWjwPNXA8rsz04V7r0d4Tw2P3dfVF18WDzrT85qg0pZbtQf74nBgzCPfe3E7Z7oLxxncMn2LOpGCdJHtii0WJL6/O69bAkn1bmLPXvvbSp+2HUfj/jnkYEYjaYMK7OpGataS/u4/O+rV9UPMyB9Y1M5am9x0r1z8GbUO4/NQt6wfU91KauEekOHRmOnWPBbRZkacepl3I2QXpo6frqCGGsdZQmVUBaP/dQzO21EK7gj7v16mnvSiFGEOADH+5/adtNSkB8yTm4r/7nnINZuGTmod5KChbXwcq0RX47+Ta1KZd6CxUQhzlbX2/KXU2KMfoHXdrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dUaHQbx0sLCkis3bxSqaE7UBSLYwVpwfzywlrRttfRY=;
 b=XtGLFmzDGDtaNFx8V5M/85yAymiCL1H/XQVzK3yLM2EdlvH6qlI6R2gaeBy46pYWRVvKweVyxPfR+kDuFHMBeuAIbHru5upRRqZGvoYJ9jRWsPTl9FwQo7tP0X88npuD5SSaWBkPFxCcYseCdHhs+RKEJjNR7RYC+TGaAOmnwu06NOF0QZ+6+r+oC3vuWPx+zfhVl/Bi+7wakoUv3safXGYbz3ZpaqRJ6g9uZfNNPZNJw4XWkhBGbfwR1Dgj1BtoJ98Bj9fp77VtaQ8zaDAwBGS7dfrtocSBPh8Uf0+ct+rl1sX1/3E41U4vk0YkrOGpGJyGADpV0zx3hQOuv0+3jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Fri, 3 May
 2024 00:09:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 00:09:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 2/5] x86/virt/tdx: Move TDMR metadata fields map table to
 local variable
Thread-Topic: [PATCH 2/5] x86/virt/tdx: Move TDMR metadata fields map table to
 local variable
Thread-Index: AQHanO1K/eVdjH9xLke4OtoG/WWhgrGEooOA
Date: Fri, 3 May 2024 00:09:38 +0000
Message-ID: <21310a611d652f14b39da4a88a75ded1d155672e.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <41cd371d8a9caadf183e3ab464c57f9f715184d3.1709288433.git.kai.huang@intel.com>
In-Reply-To: <41cd371d8a9caadf183e3ab464c57f9f715184d3.1709288433.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB5983:EE_
x-ms-office365-filtering-correlation-id: 716ce1a6-1c49-4650-d49c-08dc6b05526b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?YlVLZXE0NGd6K2lwZlIwTHRmWmFLZllrcjFjL2NqZ3hMNVNuL3ZBdHBiRCtK?=
 =?utf-8?B?ZnVCbjFMdDhMeXNUSjk5QTFkODNkNkE5Q2JGRytoY1BSdWQ3U0VTREZDT0lz?=
 =?utf-8?B?aUJDdGVOZmpCZ1RISU9hZDFaWGVGdDBiYm1GdE5mdDIxTHlycTc2bTIreFlG?=
 =?utf-8?B?RFlpVkNYT3FyZW9DdHB6eldReVV5QTFGOFV2TlZXd1B5SGlSV25TK3pyUFRt?=
 =?utf-8?B?SkFLTWZZTmwvaVlhRUh0QlRIMFN4OWRSNllaQXFVWFZ6TlBoNE1odEFnSnJM?=
 =?utf-8?B?b2o0b3pIT1l3RmxsNm9ERmZoQThJeWpRdWtLS3V5ODkxYWNVaS9qem1HaWtZ?=
 =?utf-8?B?KzBzbmF0bFJKcHkySTJiajJkdmkvaXZCM0Z3clArSlRRM2UzVUFQZTdCekUw?=
 =?utf-8?B?d1R1VUphcGZnbitLSjl4bkFaU3p1MlE0WVpWQURXSGVLRU8rMVU4YmJmdC9G?=
 =?utf-8?B?a0ljcVBQb3l6eUM0RDgvZWZEWjIzY0xVYlFOUWJvK2dvbURvbnovNDRCZU96?=
 =?utf-8?B?elZzZzNHM1lpQWxFL0xOYTY2L09EaDVQUzdLMTlKRGthUm1ienNpOVh0STJJ?=
 =?utf-8?B?NjcvL0RTdjd4Y0dsZ2k2bGFzazVMdHZ4Y01pR1RrdVN2amNYZUo3S3VyRUs5?=
 =?utf-8?B?b2JEL3ZWRm1OQWFLWktUYUF0anVLOWdmTGxqcDBROGdRS1JBK2UvT3pFVXU4?=
 =?utf-8?B?V0ZJcDk5VUtHazNuZTlxM2FvQ1g0M2dNNFFDVWFaYTlhUXFSUnRJdS9KMURJ?=
 =?utf-8?B?WnE2L0F5SVUwdFIzbmluSlNXeXZBM2VuUzZQUEZqUzIvQXJVbmNpVTBXdGor?=
 =?utf-8?B?RDVaSHF6USswVmNSRThMM1RqVHdNYms3UUw2THVpNHlkTmp1RUV4VHdXdTgv?=
 =?utf-8?B?b01iUDZCNUdaaGxDY3F1b3Z0dFh5eXdlU1lSZHFvQ1BSdWJQejhRbmpTS0dW?=
 =?utf-8?B?Qk5VVEZLSDB5WHU1SWhjWkdxaHdxbmFEd1ZRaEg3ck8xRUorbXBGRzNWQ01C?=
 =?utf-8?B?VzRTWkwveGhlYVo1eXZES2JRMGlzYnFZRjUwZzlhNm1aRndFSzNMNXpiSDNI?=
 =?utf-8?B?SzJWWlZjbnJvRjMzR2lkTG9uSXozcnBKTnNVZzUxeXBXY0d3NXE5VENjczIz?=
 =?utf-8?B?eExvOEFVUmZOd3d4YW53b0xlcWRIYTZ2RUt2VW03dnREZFRJaGE1V25CdFpt?=
 =?utf-8?B?R0RKVWlOSjIzdkpDT0NhQkpzRytFbHFsUHVHMWg4Yzd4N0NiOWdyYUo5K0hO?=
 =?utf-8?B?bEdaVEx5QnQ2WUMxenVhYU9CbG1DOUZRSmRvVFE5VXBNcVJ4RGsrM3JwNEtK?=
 =?utf-8?B?VCt2SElyT2x0VE5la25MSzJkWHdvVVZEWDBFTGJ0MU9NMGhRQVUrckhrdzUr?=
 =?utf-8?B?ZGVkb3UyYVpDcWp3cHd2U2lmdVJlc25lc01uL0ZCZzBldGViTGd5SXN3VWFu?=
 =?utf-8?B?TWtJSk9XdjBHTTVTanJDOXFCRTQ3Y1ZPbXFBOXN4eVlzaGM4SzBUSWlzQVUr?=
 =?utf-8?B?ckZ0M2RRRk1SV01NekUyM1NuWFZoT3paOHhiMGtRTTlJTVhxdUxWd01RQUFI?=
 =?utf-8?B?NFdCaDd2cEk0YUR2RTFmb1pmVEIvNitJUDlWTmdHTlh6MTlEd1g1YkVSVVQ3?=
 =?utf-8?B?OTNjUVBtOVNCKzNvUVNZNko5VWNYSDZJSHlBYW5DajhrZWlCa3VHTWNNV0ho?=
 =?utf-8?B?aVpGZzZiNjBraitnNjc0YlVwT3BoQWJmOTE0Rm8reFBDbDI0eGtiQU9JRXlS?=
 =?utf-8?B?dGttNm4yL2grSE41YmV2dERrSDFOSnNMcVdhZkgwZmQ3bHlyZTA5eEFqbFRw?=
 =?utf-8?B?eFpHMDYveGl2YWxSTGRJdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N2Q4RnpCU3V6QVdOTlkvcUxiT0xQbmtsck1TTUJxVHNnVXIwYmxNR242RHZN?=
 =?utf-8?B?MFdnMHNYWGRab05wcXU5Y2R0cXVnY05vWjEzNXVhSGtzWTB0Z3NQellqZlI2?=
 =?utf-8?B?SzY3WThlUS80TUJ3MzVpVkV5d0pKalZJMkNvSXVzcXhQaUc4VUQyYmdWN2VC?=
 =?utf-8?B?YjNBMDhjMnhoaERkT05YRW9zZnN2Tm1EREdNemNjZEprVTRpWkpsb1pVZ2RM?=
 =?utf-8?B?dEh1NEkrRnBwZmVzKzRSdzBVNVc2ZVF2Sm5NU3gyQWcxMEhwR3FVa2hCQ1gx?=
 =?utf-8?B?S2V2R1AzMVNWWjRaRXN1eUhmeWpqT1NJaDU5R1JxaFdYQkVrd2ZrZ0hJeEcw?=
 =?utf-8?B?Zk9WaEFIdnZtOHBCT09wV3pYZk5HMzV2Sm54Z1FqRzRCNmpHbFRnck1UYWNE?=
 =?utf-8?B?TnAwUTZPc0ZXNFVVaWhXdldFaE8zRDcwM0loNlloWVZ3Q1FKR0tlY1pERHA1?=
 =?utf-8?B?RXY3M25qZFJRNHdWQldoMHgrN2pGT2xzMEJsTEhjSTcwVnNjV2s5YlRKTDJS?=
 =?utf-8?B?bisxb0dhelhxSDl1VzdLTmo0NFdvT0tVWnZVd0dLeDRnTVoydzh0MDlZZGVH?=
 =?utf-8?B?cEdGRG0vdTN5QmJxTVp6SGFHV1RPSGNDQnRmMCtYQjRHMXAyRGxNL2UwNWk1?=
 =?utf-8?B?WFVhMThaOXJqMEJreVRMd1BPNjQ2bERwd3Zld3hEdzVkYjd5NUdVSE14U202?=
 =?utf-8?B?b1ZOcWlzcWNGamVMNyt5R2dEb3UxV3RaT1BtNXdGcCt1OUdBTGlDNmJmc3c4?=
 =?utf-8?B?ZWdvdnh3WmFncEo5cnByUC9aRGVlbDRsKzBiWm1uTHlrdXBYSWU1dU5LYmph?=
 =?utf-8?B?dk9IbnVUT1Q3NmwxbW5IMjhwR1dZRGpBdnA3UWxNcWtOMFg3aXljUERXZms0?=
 =?utf-8?B?d3JWcDVFZ1A2bjkzdC84UjYvN1YxbVI0QklabDZ6YXVsUHl2dnQ4TFFuR0sx?=
 =?utf-8?B?L1A3eDBmdStJRzl6b1FTSEpFM0p1dFEvYnBZOFE0bkdTbGM2cTBmUjlXdUxB?=
 =?utf-8?B?QmFWaE5PQWVVeEVVKzE0ZEdUdW42T0plak5BaDd5V3duMUFkcDdEeXBEWWVz?=
 =?utf-8?B?R3UrTkZSc1dkK2c4OUJ2NE92ejBkV3RSakFOc1hJZ0xvSGpjSW5ncm5MR2tr?=
 =?utf-8?B?ZHVMdDBSUjArQ2JPZFhWUy9oTlVJY1daTzhIeDlaRVNaNFNSY3VtVkFmcWxK?=
 =?utf-8?B?NldpbjErVWREdElGZGJMbWdsaFVXUlJkT1lXczZWdzkxMUNodHhla0tVblhk?=
 =?utf-8?B?M1dndFpXVmpWa1p4NTVFb0NlZkp5UWJLenFUS1J4NGRTQzhlVlNHYnBFTlR1?=
 =?utf-8?B?SXFaaEdwQXlpRkhZM1dKUFNmMkpackxXU1pKUU5IVEd2TEZJVFNwRGVhTkR6?=
 =?utf-8?B?Q3R4Nk1FU25pSWJzM1hZQ0RUZkNRY1VydjloemxoSmJaV05IdGZYUjdjcTND?=
 =?utf-8?B?Um50MmZhdlJ3MFJjS0lzZGRjbkNkbWJlWUhIV3ZRb01aU1FCT0xQREFicUdv?=
 =?utf-8?B?UEJtak9DelBQcUNxdGcyemQ0K0FjZExkbUpDdFBJT0VlUUI3eUVFQmNIbmhq?=
 =?utf-8?B?UjkrRkFvZVdtbGpBV0Y2N0U0ZEFOZXgyQ3JvaDRjMm5TOE9TWUh1TmhYSjAz?=
 =?utf-8?B?ajVDQVFnWDhKcW1jWFVQbDk5Mkpjb3c0OHY5S1BHc3ByV0IrS21aTDlOMk5W?=
 =?utf-8?B?c3RsTGJ2aG0zQURQTGV1UXVVd2VlYXRHWUF0ZURvL3BOTysrUW40MnRnNXlG?=
 =?utf-8?B?WUJaTUNKTFVLbmV1Mnhuc2NPWlVHcnN6SW9MTU51MjU4aUlLUi9mQ0wwdWxm?=
 =?utf-8?B?YkdYa21BT0NCWEdQQmg1b2xiYkZjZnVtT0NJT1dqcGI4ZmNFeFpJbTMrQkhs?=
 =?utf-8?B?dk1sU2hEZHFMRlZIOFFHb0RJZTFJZ25va3lGKzBtTXEwTmlXbWNuekZSVWlI?=
 =?utf-8?B?bmpRY0xlRUxiSm5wd0pWSExOZkRhdlBSZUkxakNidmROdCswaUVOYUFuM05p?=
 =?utf-8?B?TWVOamxiSGpTRmZFeUYzcVlzQ3hDK0o0OVFQWjhrSzdXVnY1c3VXTCswQm1Y?=
 =?utf-8?B?WVZ5L0JRTVRQdE1KVURZeEExSzB0czNjQ2FxNjRJdTJzQkNKS1prV1dwNUdz?=
 =?utf-8?B?enBJUEVHNnFWQmpPWVllYkRDc1B3WUtYbHNXQ2RYakxZcUtQWWRHOVlIeStn?=
 =?utf-8?Q?D9dhRgwF6hau4Js1IZtXP3o=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3D6BCF48884E74EBC531F08E55321DC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716ce1a6-1c49-4650-d49c-08dc6b05526b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 00:09:38.1030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V11TmfAMCxbe9AID9P0p+DMTgnL9sudE7FTgQqzGZiQpwH/PYTj4OQUZ9FibiWe6Ogq5kWp1MmXT0h/RbmxhNsuNGkmcsNBVKYEhF7VX+8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5983
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTAzLTAyIGF0IDAwOjIwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IFRo
ZSBrZXJuZWwgcmVhZHMgYWxsIFRETVIgcmVsYXRlZCBnbG9iYWwgbWV0YWRhdGEgZmllbGRzIGJh
c2VkIG9uIGENCj4gdGFibGUgd2hpY2ggbWFwcyB0aGUgbWV0YWRhdGEgZmllbGRzIHRvIHRoZSBj
b3JyZXNwb25kaW5nIG1lbWJlcnMgb2YNCj4gJ3N0cnVjdCB0ZHhfdGRtcl9zeXNpbmZvJy4NCj4g
DQo+IEN1cnJlbnRseSB0aGlzIHRhYmxlIGlzIGEgc3RhdGljIHZhcmlhYmxlLsKgIEJ1dCB0aGlz
IHRhYmxlIGlzIG9ubHkgdXNlZA0KPiBieSB0aGUgZnVuY3Rpb24gd2hpY2ggcmVhZHMgdGhlc2Ug
bWV0YWRhdGEgZmllbGRzIGFuZCBiZWNvbWVzIHVzZWxlc3MNCj4gYWZ0ZXIgcmVhZGluZyBpcyBk
b25lLg0KPiANCj4gQ2hhbmdlIHRoZSB0YWJsZSB0byBmdW5jdGlvbiBsb2NhbCB2YXJpYWJsZS7C
oCBUaGlzIGFsc28gc2F2ZXMgdGhlDQo+IHN0b3JhZ2Ugb2YgdGhlIHRhYmxlIGZyb20gdGhlIGtl
cm5lbCBpbWFnZS4NCg0KSXQgc2VlbXMgbGlrZSBhIHJlYXNvbmFibGUgY2hhbmdlLCBidXQgSSBk
b24ndCBzZWUgaG93IGl0IGhlbHBzIHRoZSBwdXJwb3NlIG9mDQp0aGlzIHNlcmllcy4gSXQgc2Vl
bXMgbW9yZSBsaWtlIGdlbmVyaWMgY2xlYW51cC4gQ2FuIHlvdSBleHBsYWluPw0K

