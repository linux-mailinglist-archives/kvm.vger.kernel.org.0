Return-Path: <kvm+bounces-16466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 183438BA48E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 361D51C22B53
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:29:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1606FCA;
	Fri,  3 May 2024 00:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i5xbzXqo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAF328EA;
	Fri,  3 May 2024 00:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714696153; cv=fail; b=YxE/s/yFxTMpOFWXOdZ1ixHBys8cA6N9/9iljsKk7Gv3hfSuXx9u2lSf3vgeAPvYlE8ME4etAQZ7EQWPuzNxmLxeOwxz5vW5EtVaUJ2nI57l1dN6iJmU5Mh8gC/wvBXTUuEHLXfNDSqDCqm7KWxr6gPyKmIZPIXnByBbI/Zs6n0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714696153; c=relaxed/simple;
	bh=7eM3ZBlHGEyb4AECguPRMhNBjkdkcHFWatxL5Smzy1U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=T1fFPUbEN6REiQ2MXnoei+f65nO1+mqjIdvER9ZYXY5AKw32FOuRtPKF6GYN4EZHT2OYfPnuAAipnOSkdfA4Jek2j/PRmw7rbE5H9iF6vcJGPA6QWpf3oKYvLcF4vj7XMXNGJhpcRvGZVmHLW1euYZnhKKyCEaGJDnoz0ttU178=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i5xbzXqo; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714696152; x=1746232152;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7eM3ZBlHGEyb4AECguPRMhNBjkdkcHFWatxL5Smzy1U=;
  b=i5xbzXqoosfTsDQSnUjx0xzDvgTnnU12ZsEI7Hdjr9sO8+Xts4YjqTXl
   MvysXWKFFrRSZiaJYduTfpohbTYAgemu2raK4ttIw+2MQ5P6uwk4ASXeu
   LaSYg/ig5org7ykhdvjJGem1+DKlcd5TEelLogIfZ3oThJmFzJqhN+UQK
   emk+NKoI3PWQDCsOqfbKt9hVbrWJjiozY9OxjRfgnp4vKuWAi22OKgn0w
   /vRO9MGgbr3l6g9PWsjlBSWLKhKWXf6RCKDEJrdUh9/ROyFYPfuzFg9Wj
   0ENRLKvyY5MvqElkl4I8Tb8XPOrAEWJZtrQ2V0BzCaPC8CoCU+LF+EFfe
   g==;
X-CSE-ConnectionGUID: ZI1PM0D7TeCzcc+DhuLWrw==
X-CSE-MsgGUID: IHpAIbWaQ6SyAzp6GhNXEQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="10627420"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="10627420"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:29:11 -0700
X-CSE-ConnectionGUID: icJ9SysMScq1ObW7btlQJg==
X-CSE-MsgGUID: OMpABENHR9OCL8JrV5ZFig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="31973537"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:29:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:29:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:29:10 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:29:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hvjx5lvHmeExiXaanURB+E743GlOmkEcvfnqWvm2sJRfVat5fBN24No3wp1A/WojRijDA0umottVIFuZ6z6J+JKOyIt/ZL0i9VVWyyZ4wkMwBWG/mtmfc1Sijiac+DiIzFgQUnrV/Ga74UZLiUCMOFeKl6L26kZuD/Qo/9k2XYrXIQ3wcDb70n59JxBrrfwsBXUbc9RSXlUjgjxxkJ9L4Q5y8F5pYffUHsqyKbLGQVJGwU1V0jxHwDd0JCkWU9puXVza4ZFT7plVL6sJsq8FW0G4g3nrIDKq3p9bJkz8By9vsif/iutm3gfY5AbpdHZ8sZyH1b5FjPILYvES1U8SnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7eM3ZBlHGEyb4AECguPRMhNBjkdkcHFWatxL5Smzy1U=;
 b=Nfc5W/Wl3R9vEbFgsS7G1LoxLFg9M8P18T62XSAhqJ/iEAEXfge1MV5oNdl3TT3caVizU/cbS4bZkbrP5vQPM62oLTva+/f8Z8bq4OJVJAp8yBb/+yJeeReHiyQFlKoLowuh29oaSl9Wm7fChZwW84b8t+rfqSn29mu5bu2RF1Qqe4+o31s9cf2cvsp3Ybolz/fLNBaCnAkvoqqyQdc0gRMq7BLhLDsr2gN2el28K4ieEacxU45eBFXJa90SgbNnGDk7GC545Lts52JRXZXHhxL4X8ibSfjLjOlnTQR1eFH3vhJty2OjLo52LPnMLGT7uwv/XcbgU0RWC7/Q0dD/fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN0PR11MB6255.namprd11.prod.outlook.com (2603:10b6:208:3c4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Fri, 3 May
 2024 00:29:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 00:29:01 +0000
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
Thread-Index: AQHanO1K/eVdjH9xLke4OtoG/WWhgrGEooOAgAACfgCAAALtAA==
Date: Fri, 3 May 2024 00:29:01 +0000
Message-ID: <6cbb56898011b8b0adbff216f1318dc5529b7d1f.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <41cd371d8a9caadf183e3ab464c57f9f715184d3.1709288433.git.kai.huang@intel.com>
	 <21310a611d652f14b39da4a88a75ded1d155672e.camel@intel.com>
	 <6d173173-97de-42a9-85f7-20c5b6a2e6fe@intel.com>
In-Reply-To: <6d173173-97de-42a9-85f7-20c5b6a2e6fe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN0PR11MB6255:EE_
x-ms-office365-filtering-correlation-id: f3ea69d0-d42e-452d-0cc0-08dc6b0807c1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?K3FXcFVuekFFTnBTdHhwTkxVWlg1VFVoQ1h5TmNoaUd0NmxhY0hHc3ZqNDQx?=
 =?utf-8?B?TnMrbU5HY3hHTGtBNXlXUzNNY3ZyWWVTNWcrbjVWck8zb2x2bXdRaXdGMnRJ?=
 =?utf-8?B?dnN1c2RXdFVyeXRuOXhUSXdxTzlvRnhGTlJsQWZNME1FZW9xcno2WkZ2Y2gy?=
 =?utf-8?B?SUZjTlFsSkw3OCt3K3E0eHZya2g4T1orNTl6bXA1WG0wazZpbXNJRWJsVzFT?=
 =?utf-8?B?RnJhNFNUZllPTXh3SnA1LzlqQVJDZFRWTHp6RUUrc011TXB4eTJacitncnFM?=
 =?utf-8?B?dnlteFEzM3gvZHd6L294RVBGcVRySHJFdkRiQzZqVW5jNGNCVDRUMUU3Z2J1?=
 =?utf-8?B?cUhKTklnTDhHQ3ZKOHBUNzVaUE11a2FyTzd2eFYya2FWbWVDckdVV1NCeFVt?=
 =?utf-8?B?Mmlsc0JNZWlNdEpaZGMxL3g1bEVSN1E5MTdFVmpHdlpVWHF4QWs0NkhjSkpR?=
 =?utf-8?B?SXY0SGlQQWRyMXI3OXV3Tlk5eVc0SDkxNHpZV2NKZWR3OGRzRTRQV3VxREo4?=
 =?utf-8?B?TFhQU2crdXpwRGJ0dGdIR2k4dWl3TlQ1VVE1VG9lUEpWY0lCc2d2VCtzR2hE?=
 =?utf-8?B?aFVFczloNnY0Z092eEtDWFo4b09IdTFMYlFTY1lBV3V6UUtqVEtRS20wMy82?=
 =?utf-8?B?NHkwMFpsQVFpN0R2ejFCeW1jR081TjJ0U05McUtKNkU4K1lNRUdzYmk4enMr?=
 =?utf-8?B?WHRieWYzRGdMd0lnQmZ1UHFBT3o5NkpwcHhiaWV0eGhDZ2ZwZnd3cEVpNTds?=
 =?utf-8?B?RTNneWp5T1BOTEk4ZTI3NW1yZURCVFRZdERmLzhZVG94U1QxYlhSTXVoaWs2?=
 =?utf-8?B?ck11OFBaRGVNWEpSTDZFWGVKVWVZdTNBYU83LzNJbGVWMDJqcHNHdTliWHMx?=
 =?utf-8?B?OVhrbTdZNUUxV2x6OEdpL25pSUUxVFJ6SmJNb3RCdFR5LzZRazYvcDlzaFRu?=
 =?utf-8?B?ODJkaVd4Zk5KMitpWlRIc2pVMG5RWEZPWThvY3dkVVJ4TWRyUTQwN0ZqSndN?=
 =?utf-8?B?eGNzZW9HOExRZHN1SzhJRnBpUmdYZURrdnRZcXZRM1lzSmhzZ05MaUM2TGpS?=
 =?utf-8?B?NVFhSWRVc2cwSUFpS3YyUmlHOVFnTFFocTFyY3dQWEtrYjRUMG9VMWRjb0ZC?=
 =?utf-8?B?WkJXL29uQkxKUGhOanFwNjhpZnBVSFNVd1NOZUhENUx4THY2UUZ6SmxMQXdk?=
 =?utf-8?B?S25OYVV2c3hEZVN0UEw4dDdrOG1JNGxHb0JJcW1xYTQyT0UyMmZSREtLNURY?=
 =?utf-8?B?dFZGTXF2aWV3N0RZa1Bua3BwZWVESXZYZWhIZWdXRldmaTZhYS9SU1NMSDRW?=
 =?utf-8?B?UXlGZm4yQnMycDI1ZEVsbE9rYWJOZUVDSTZwekNYL1hkdHB1K05SRkhCQzR4?=
 =?utf-8?B?ZXJtWXBlMCtubkhZTWx4dGJkRFFuWGE1TU9ha2RuTXZPMW03c3ZDbFArRFha?=
 =?utf-8?B?TVVLVG1BRUhFcTJ0dUYwaklLYkN5dmxBdjVGeHczeSt1SUcvbmRPQWczdDc1?=
 =?utf-8?B?TXp5Q1Z2c1l5cWRsWUpCWTdmZTE5QWpaaFRqblNhZmRPZWNyRDV2OXRFNFFY?=
 =?utf-8?B?Z0pldld4UGV2bUtSbFdnOGRIbGVzSHE5Slg3amUxMUY2U1gzaXdhLzhReUFB?=
 =?utf-8?B?MjZaNEdkTGJSQ1JNUE81WWJHaGJ2WUV2dmkzQVVEZk9Cb1lWb1ZwYVB1T1Rx?=
 =?utf-8?B?SVZaYlM4Y1hIN2FPUnhhV2tEQXdqVjhoWEJoc0RhbXp0UXBFOWRFVlN5VW1w?=
 =?utf-8?B?UTRNNFRuUzJHaU1NbklBa3pIM2ZaRlNNRTJ1cFpIdURHU21CdzAvWG5xZDN4?=
 =?utf-8?B?UTdJOUVCRlEvZEhEOXBMUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHdHSVZDZHZrcHdoQy9Ib0V1TWgrNHpoZ3g3eDl4RWN4Vm16bGk1YVhQOGt1?=
 =?utf-8?B?YzQ2UVlETFVBZ2kycC9jako1eUNxS2xtbHNBVVVWR05LeXZkVnNoREhVWUgx?=
 =?utf-8?B?am02djVHenl0Ti83OEg1aGxXM3VSNDFuNDR4d3dLRkVvVFpsN2xGM2dYR0RT?=
 =?utf-8?B?OGk2ejlQWlNwSm1qVFAvZTM1dXNlbVNMVTd2S1YvMEY5S2ZSYmQrekZvWGJa?=
 =?utf-8?B?Rkg4UGZIMGRhWXhReFRBUTB2K0xnNzlkSVF5ZkwwQlJ6VkVTMEFCNWZCVmxI?=
 =?utf-8?B?cXppQy8vaDI1QUs4cCtOVDNZRDFUakZVOVZXSVNKa2JDU0Z1cm1qTGhoOGJI?=
 =?utf-8?B?YVozTnErMHdtZ2FFVjg2dGVqNkRyRVFTUUdNbGU3WTdmNWJYMVIwTnhUbFFG?=
 =?utf-8?B?cWNUNkszNjhYT1pSMDIzRzdFakhqME55KzdvQW5iaVJBU0VKeVlxbzZpd0RY?=
 =?utf-8?B?UjYvTjdQa3JZbStmeXkxem1PMmFFUVR1aVM1QWpqSjZwV1NBRC92bFZiaWRY?=
 =?utf-8?B?RzFnSVJDYW1ORm1XcVBEcXkrWjI5VGY1RXFRUEsyYmR6VFBTd245MmR4a2NE?=
 =?utf-8?B?VVQ4emhHZFNRby83ZUh1YVpHT3IxQWtIaWFNblpzdnVLS3F3ZG9FcHpwcnZq?=
 =?utf-8?B?WTRlU2pRMENXM21reStMaU9iUmo0OVRUYmtRSU1WV3QyT0tVQS81bGxQdEZQ?=
 =?utf-8?B?ZnJaakx5NHAzUFNBdFRmdVl6UjJCbGRPWGpWM0JPNGV6dUllajZWZk55Q2Uy?=
 =?utf-8?B?M1lMZ0J0UGwwWG84Yk1QWDYzd1Z2TC80VkZaYTYrRHNqMXFxU3lOS21LeFNR?=
 =?utf-8?B?anl2NHl4d1dUbFNiN0dCK1pVenl4Y0hoWEVEeng1UG1ZZ0wybDhsY2k2VXgx?=
 =?utf-8?B?TWVjT1NtcGxVUjJGQnV0UmhCY1B0eHJTVlphVVduT0FiU2ZzUFJNUUNvbzEw?=
 =?utf-8?B?VXJDSVZVeFpPQWViczFSOE1aanpVYll3LzF5TEVqRGRvNmpCU29rN2xoVkx5?=
 =?utf-8?B?ZTZJOWVUSnJhUlY4SnJXQnYrcklBMHdPemxSSmR2R2NwSkJjT3dhRXppREZi?=
 =?utf-8?B?bUQwYUdndlBKOFJnVzhMOFdFazRFcUN6VE9HZWZaTUNyU0pxd1RUSDZXbVE1?=
 =?utf-8?B?WGdGOVNzQlZqc3MwR3hiN1FxZTBvWmdFTnl6Z1hwL1lrTloyeE9zYVRMNlho?=
 =?utf-8?B?UHhzd1NoZGhram5HOWJiaFZFdEtWM05QTWVHZnpIYXRqeElGNWJ2NnREakth?=
 =?utf-8?B?UGV3eW9ISFp1cHg3VnREMUFKZzR3dGFCejVGalJlUjdsbWxCMGRoak9waGU5?=
 =?utf-8?B?TnB4QUhrK3o2dHF6WFRBSERwOVZRQmpObDByOXdKalM3SGJjaEJzS1J4eFB4?=
 =?utf-8?B?Tml2TkxUbU54NmF3VEZra1cydFRscGdEdlFkMHJEYXUwZ1ppUUNxeEFMNERl?=
 =?utf-8?B?eEdFcHFVR0daOXJ6ek9uNnFrVjZOR3NleGFrZVRjNGR0SkZHSEhuNjJ0Ykti?=
 =?utf-8?B?dlE3Qm4vTFRpblZ3amNEeFNiTERtYlhMaG1kRVFpWlAwYUJKeEtVWHQyOHdK?=
 =?utf-8?B?Rk94cFYxTFlWekYwSVU3MFNrMjJHRWRNRjhQUGpTdjlzeVNWbVhGQ3g1Q2gr?=
 =?utf-8?B?S1JzRzBMcGZ2b3dzWTd5ekI2Vm1GN2tqWGJzNjNDaGdMT2d6LzUzcGVQM3hZ?=
 =?utf-8?B?dTZNa2tXNGorODNXenZZYTluZC85bmJsSTJRbXNCL3RJR05LOEJSZ3F6TFAx?=
 =?utf-8?B?SmhDVStjUlVVM3lMU2hyb3pjY1pSMlUwei9ZekVTdnJPQ0xsS1JiMGtmdzBC?=
 =?utf-8?B?Mmg4MlpIN1dXNTZ0NWxKZ0kveG00MHlkc0QzTHBsdGNyWktUeitCWXdCL0RE?=
 =?utf-8?B?elAxcjJwc0hDdG5xd29ObWxtVUg3NmtWK1hYTjJtczlVY3EzaDJSNEp6L3Rs?=
 =?utf-8?B?Wko1L09IVzltQnBMb1JONjdIMEtmL1NtTURIMUZ2c3RoMi9nNmUyb1JiMXJU?=
 =?utf-8?B?eTNYVkJLeGx4NXBwRWRwQWVGL05CbUJQTHRORmxuRkQwMVNCRjJKdlZzVHgv?=
 =?utf-8?B?d0FvaG8yV2hMN1ZzNE9XQUFVZFpDbDgzWlloY2RiMFA0Mmx1My92UjF0NkJW?=
 =?utf-8?B?dzRoSm0vaDEveVlDRWs2aWo1UVJMTWZvR1VTUEdBcE5WS1JUdnZKbWY3L09C?=
 =?utf-8?Q?AAN8g95QK9sjd6hKM3kpIEo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FEED95C1F6AF4E48889CFB856B9BDFDF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ea69d0-d42e-452d-0cc0-08dc6b0807c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 00:29:01.3298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k/M2aC95x9xk+zpTesOglwshyuIuriAmfBGSiNnLbCUPOpd180U3GD7yc5ISA3gZ2Pf62zQbCMjCvlPx0BFKNiE1TgVYBdYDgtLQnEEEHAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6255
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDEyOjE4ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDMvMDUvMjAyNCAxMjowOSBwbSwgRWRnZWNvbWJlLCBSaWNrIFAgd3JvdGU6DQo+
ID4gT24gU2F0LCAyMDI0LTAzLTAyIGF0IDAwOjIwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+
ID4gPiBUaGUga2VybmVsIHJlYWRzIGFsbCBURE1SIHJlbGF0ZWQgZ2xvYmFsIG1ldGFkYXRhIGZp
ZWxkcyBiYXNlZCBvbiBhDQo+ID4gPiB0YWJsZSB3aGljaCBtYXBzIHRoZSBtZXRhZGF0YSBmaWVs
ZHMgdG8gdGhlIGNvcnJlc3BvbmRpbmcgbWVtYmVycyBvZg0KPiA+ID4gJ3N0cnVjdCB0ZHhfdGRt
cl9zeXNpbmZvJy4NCj4gPiA+IA0KPiA+ID4gQ3VycmVudGx5IHRoaXMgdGFibGUgaXMgYSBzdGF0
aWMgdmFyaWFibGUuwqAgQnV0IHRoaXMgdGFibGUgaXMgb25seSB1c2VkDQo+ID4gPiBieSB0aGUg
ZnVuY3Rpb24gd2hpY2ggcmVhZHMgdGhlc2UgbWV0YWRhdGEgZmllbGRzIGFuZCBiZWNvbWVzIHVz
ZWxlc3MNCj4gPiA+IGFmdGVyIHJlYWRpbmcgaXMgZG9uZS4NCj4gPiA+IA0KPiA+ID4gQ2hhbmdl
IHRoZSB0YWJsZSB0byBmdW5jdGlvbiBsb2NhbCB2YXJpYWJsZS7CoCBUaGlzIGFsc28gc2F2ZXMg
dGhlDQo+ID4gPiBzdG9yYWdlIG9mIHRoZSB0YWJsZSBmcm9tIHRoZSBrZXJuZWwgaW1hZ2UuDQo+
ID4gDQo+ID4gSXQgc2VlbXMgbGlrZSBhIHJlYXNvbmFibGUgY2hhbmdlLCBidXQgSSBkb24ndCBz
ZWUgaG93IGl0IGhlbHBzIHRoZSBwdXJwb3NlDQo+ID4gb2YNCj4gPiB0aGlzIHNlcmllcy4gSXQg
c2VlbXMgbW9yZSBsaWtlIGdlbmVyaWMgY2xlYW51cC4gQ2FuIHlvdSBleHBsYWluPw0KPiANCj4g
SXQgZG9lc24ndCBoZWxwIEtWTSBmcm9tIGV4cG9ydGluZyBBUEkncyBwZXJzcGVjdGl2ZS4NCj4g
DQo+IEkganVzdCB1c2VzIHRoaXMgc2VyaWVzIGZvciBzb21lIHNtYWxsIGltcHJvdmVtZW50ICh0
aGF0IEkgYmVsaWV2ZSkgb2YgDQo+IHRoZSBjdXJyZW50IGNvZGUgdG9vLg0KPiANCj4gSSBjYW4g
Y2VydGFpbmx5IGRyb3AgdGhpcyBpZiB5b3UgZG9uJ3Qgd2FudCBpdCwgYnV0IGl0J3MganVzdCBh
IHNtYWxsIA0KPiBjaGFuZ2UgYW5kIEkgZG9uJ3Qgc2VlIHRoZSBiZW5lZml0IG9mIHNlbmRpbmcg
aXQgb3V0IHNlcGFyYXRlbHkuDQoNClRoZSBjaGFuZ2UgbWFrZXMgc2Vuc2UgdG8gbWUgYnkgaXRz
ZWxmLCBidXQgaXQgbmVlZHMgdG8gYmUgY2FsbGVkIG91dCBhcw0KdW5yZWxhdGVkIGNsZWFudXAu
IE90aGVyd2lzZSBpdCB3aWxsIGJlIGNvbmZ1c2luZyB0byBhbnlvbmUgcmV2aWV3aW5nIHRoaXMg
ZnJvbQ0KdGhlIHBlcnNwZWN0aXZlIG9mIHNvbWV0aGluZyBLVk0gVERYIG5lZWRzLg0KDQpEb24n
dCBoYXZlIGEgc3VwZXIgc3Ryb25nIG9waW5pb24uIEJ1dCBnaXZlbiB0aGUgY2hvaWNlLCBJIHdv
dWxkIHByZWZlciBpdCBnZXRzDQpzZXBhcmF0ZWQsIGJlY2F1c2UgdG8gbWUgaXQncyBhIGxvd2Vy
IHByaW9yaXR5IHRoZW4gdGhlIHJlc3QgKHdoaWNoIGlzIGhpZ2gpLg0K

