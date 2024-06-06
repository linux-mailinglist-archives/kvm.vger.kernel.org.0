Return-Path: <kvm+bounces-19025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4455A8FF246
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 18:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1C311F26AD9
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 16:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9620B1991A4;
	Thu,  6 Jun 2024 16:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K9/JEFEv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6DD1990A9;
	Thu,  6 Jun 2024 16:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717690559; cv=fail; b=Uh4rGhzom78DOTrGp4S7THWOCtXg1BNLxTZgStvCy0nqrLTFuCLhUN4AH0JffSe9HPG47AdxLO1ZGDF59unZXnjBN46ulBm4J5ePMAgV2rxeH+4BisUKpHayGxZt+9QgHwRlqgsnbdJpV3LWHcLDbx8QUyyCCeOm6GjWnG05CJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717690559; c=relaxed/simple;
	bh=tZqfL7Q9KIxQ+EzdNrXL5RZ7GqKuEX9IS+t5VpE6hF8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AIEnqrIODfjzDYxSm2Kghn0HDzm0qvPFO7tq8Lp0dTQL8SIHFdGfnLveV7Gl1EhuII/QML2+aDbcZNd+ZUJkiMkBb5Y8Wklxsud11NcQyV8t5PPNcRn7iLCEsMdt94+ztgg+Mo8iClmz+pi+dHDFLcn9OPiJZfXbnbhwqDqOuZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K9/JEFEv; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717690558; x=1749226558;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tZqfL7Q9KIxQ+EzdNrXL5RZ7GqKuEX9IS+t5VpE6hF8=;
  b=K9/JEFEvoSmgwC8kM0HupPpvAdEjMIxOyaZtYIWoxx6KEL0zIEUMiSD3
   gH0H8Qk87eKSeVGu8q2vmGpd/JpzkT0KEGKVlj70nId/96hcCMFYOZX6J
   0aCHL0VpQKNMGsKUVn2iHp0VT6jIQaySvq6ziUbfw/sOujMz/59F5So74
   3QcnIPaJDy3f4KnKGITs94VkJvq1cD6CbVSKruWklznbbeDit6gLf6hoR
   1AGwGUAHhw0Jrs/G8cr9iVCkYfIkM9a/+N9gP+7NBTxghacm2UTCbr8mf
   fnlVltf9AkEs6jMTXkCMfVuYwu4rENOsjItxrjUZt/zgfd93akDcWU3MS
   A==;
X-CSE-ConnectionGUID: sTMc4qnCTdKFRR2qnZ4Pew==
X-CSE-MsgGUID: pITEJ426Q4ShSvBeKswYoQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="25779495"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="25779495"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 09:15:56 -0700
X-CSE-ConnectionGUID: ocPTrVfCRzu7PXp9zVpJIw==
X-CSE-MsgGUID: aTzkif/1TjOVrhSv9Uns3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="69177635"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jun 2024 09:15:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 09:15:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 09:15:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 6 Jun 2024 09:15:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 09:15:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPaecBxm1ofDvpy9nHILuVH75eHJarsaOg8EvXDxp1MSgGZx2wI+kEAuSWOkuLg5Z9o7FUdnHBDtY9WxTuC9MY1BC4ubQo8Xle1KiLDbEYagvYCV4qLJ/nbrbLfW1ejyjTvcXbiK3lPDhrc5AhTmU03+nkkwHskktH9u4eKcdohpzKMOJDuhCoVmfuSIxoi0hoyOGyMN5e0VJ8IY/85xats3rpZAEEmBAZFwKGl5fUi/Ed76e8LU3Gk4iA9L+OjzQTdz/OiKiR0qhKJUHgIYEGHogtONmYL5weJ0wPhS75d9JAeGQH9OMbdgtbryMPZrxouqiUF8ENGqT1c5lodIvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tZqfL7Q9KIxQ+EzdNrXL5RZ7GqKuEX9IS+t5VpE6hF8=;
 b=LkurXJAobeOcdiqcTNAnyfdLIxThs9GfLMxADj/ITVOYxQzDYxvSPB3hcV8ki9mFe1ZZ+6u4DpDDNhvQ9HiO5k+FJOyThwuUNoTJrNc9qMB8ktXzCvZA04/2s8B2/7ZZ6yzvrnoyAzIpL8z6NRUXgUzQYtx0AdkafJfO80TydioDUtmCnBRvpSYkrokSX9Z5s0v5leEQEmbJ0TRyFUfyTTyTvq3Coh2FMGiXc0g7IijWZuyj7v5VPZ4tC4UytDY94ajlKxpsylsmxECOAt+dv5hBGWDrhl0S1OB/Qi2IcFBSnjcIWPX6dkdHke7ZaS55rcWsMDJRL608hnA1zO9DTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BY1PR11MB8053.namprd11.prod.outlook.com (2603:10b6:a03:525::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24; Thu, 6 Jun
 2024 16:15:51 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 16:15:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 04/15] KVM: x86/mmu: Add a new mirror_pt member for
 union kvm_mmu_page_role
Thread-Topic: [PATCH v2 04/15] KVM: x86/mmu: Add a new mirror_pt member for
 union kvm_mmu_page_role
Thread-Index: AQHastVnff7jttlsCkuVPX+X/N4lV7G68VWAgAACmAA=
Date: Thu, 6 Jun 2024 16:15:51 +0000
Message-ID: <6283047a2d638331b81b2e3dace6211d1bd73ba2.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-5-rick.p.edgecombe@intel.com>
	 <CABgObfa1xtZkGizNf=YrMYSo29v==qijMQJ-mZvobniS6-7OLw@mail.gmail.com>
In-Reply-To: <CABgObfa1xtZkGizNf=YrMYSo29v==qijMQJ-mZvobniS6-7OLw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BY1PR11MB8053:EE_
x-ms-office365-filtering-correlation-id: 17d518db-181c-483c-b52c-08dc8643ef6f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NDNIRnZXdDNHTng3ZEdrbDlvc1ovUVVFWk85cCtzeGt6cERnbE81UDJuS2s4?=
 =?utf-8?B?bkdFWWwxb084MCtRSi82VGQzTVVLcndZQjhjTm5DYXJEdURaYTFuQUFZd1hl?=
 =?utf-8?B?RTVsbmdua0p3YkdzZXVGenZFYThLS1V2bzlFWUxDcTBkREo3SGJsZ3dsR3VN?=
 =?utf-8?B?K2tnWFBIK2ZaazNLK1ZQMXRpUmhuN1l3MkUwemhaZ2I4Rk9zQmQvK1pOY2w1?=
 =?utf-8?B?ZjNybmRyamVxM3VDaWN6S1pDdEJXQWFnNElwU2EvRjRCOTZ6SmRBQm1DSzFp?=
 =?utf-8?B?WFRSQW1LTHpBSk85d1ZDMFZIQWtSY01xMTF4emhsNlJRSUxpcm5RQW1kZ2JS?=
 =?utf-8?B?N3NrUGFpcUpwbzFGNmg5S0ZsUkZFRXhQcHNLd2JzOUpGQ1o2M3FCZGVDK2Y5?=
 =?utf-8?B?eWs0RzdIelhwUng2YzJKZ0dkcHZGVkIyeDlYRXErYjF0cDE1L2s2aW5WTkQv?=
 =?utf-8?B?dVIvMGNQRC9NczBtQytURGo1UGtUZ0htMGlZcVVOQXpnNGpDdnpJcUZnMWVi?=
 =?utf-8?B?ZlQwbVhnN1VLcEQxaDhleC9DTWlMWTIzYmtGdzZrOUJ2b05YRi9NVkthZ1hW?=
 =?utf-8?B?aENGNGR5NkQ3STdubVJSYTRRcVpaWjQvTXlOb2luV0RyM0tzTEl2ZHdLWlEr?=
 =?utf-8?B?bG9CZC9LRHFwMVVJZW5LQTJmL1c1c0hIdFE5WWR4bUFFM2QwMllXTUhicjNq?=
 =?utf-8?B?ZThEVHFaaFlFaVNVekZZUnNkUlRuODNJOW8yZVl3aDRvakNmQnA3T0F6WTlV?=
 =?utf-8?B?VG11eUw1ZkFoUFJDL3IzWFZVcDhZTUptWW4zUG9RMlRJVG9heS9hY1MzcXlP?=
 =?utf-8?B?N1pTZmo0ZW1DNkgzL1F2eVkrOWdJZzFxZHdDSi9FMUVXL3pKZEN5SzM4ZDF1?=
 =?utf-8?B?VFJmNHZFRkhEN1pQVWtWZXRKWURYWGp0MVZrSW1NSTczM1VQQ0YzSWpHNzhx?=
 =?utf-8?B?ZExTZDQ3dkYzZy95ZmU3MHhqMXBUbWsrSEw1UUk2S3pwRWtFTnRZQTVDQWpt?=
 =?utf-8?B?L1Rwdnd2NEp2b0JHRjdxWWhQclJwWC9vVXpxMHg5Vi95a09TTTlKWWNxMTVT?=
 =?utf-8?B?WUZaNWhiR3pVLzBZbDJVTFZ3ckpXN3FUR1Q5UW5KOEdoQStoNlZCbHNaeEp2?=
 =?utf-8?B?eG5sZlQzUHAva0dDaEp2YmQyekQxZ1pkSGVwWmN3cWlBblNITGFXaVpXZmhW?=
 =?utf-8?B?ZGJmSUlwY3UxREhwSXpNTGtiVW01Tk9aZDl1UUt5ZFlqVXFNOWNYc0R2azRF?=
 =?utf-8?B?TEx1UjhqTGRpV084Y2xuSnJhdm1HRWVwVlYyZ3BmZTUxMFpwNGNHZXFGem1T?=
 =?utf-8?B?b095bmx6RlZISHFiNHFjTmpoamM4VUtadWozekp1dVh2d2x5RHhUS1BDa0Zz?=
 =?utf-8?B?KzkvSW15aGNPTm4wakJXM0NqMmdHcnZ1SlkrOTRTb2tUWGY0eVhxcVRjMEFW?=
 =?utf-8?B?M3A0UnVmTlh6Q0JPbS9KazVnK3pLUmczR1RhRUIvMG50MXozTXRLNWEzWkhu?=
 =?utf-8?B?WFNFdlNYR051ZHpwMjBWN1F5YjduVzlUM0FVWUZ6aTkxaFZDSUJMVFkxQVZH?=
 =?utf-8?B?R2xsNHI0SFNWZ0hacTVqUTNMd05PRFJtdWkxWjhvZmdHUFAycHZnM1BwTDdq?=
 =?utf-8?B?ZTlqWVZxUnhZbzR5b1pkbGYxYkdtSm95MkJFQ0dKdjh6RVRDUTIrR0ZidDNa?=
 =?utf-8?B?ZDdMazREL1lpQVVIMGJTVFdVaDJCTFlqU1FUdWRQVVc0RnpOSmJVcXJoeXN1?=
 =?utf-8?B?NHJyOVBEZG8zWVVJdXdaYmp2SGFPYjRJV3JKK1hkV05hNHVGRjZ3ZFZnZ1ZI?=
 =?utf-8?Q?V7+ZWUlROa5l4p8kuggEiJ9cr52dGyLSf3kv8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmdhZ1VXZjFibHZSVUFhZnFPYU9oUkpqZHA1eVVrM3pmdWJSWGVLZ2MyaExo?=
 =?utf-8?B?TDdmZlE0NUVvTjluRS9HU2k3TkYzcnJPQ2twWTJSTG1EcE90bWJmc09aaTl0?=
 =?utf-8?B?c0dyS2pJcGNYSlgxYXZDaHdyQVlTdzJkWlhtV2JMek1SY29yU2pqNjRoOXF0?=
 =?utf-8?B?V2toRWU5RFpJa2ZDRVNqVllWNjlXaTQvek5iWll6WVBZMXlnSzN3WjZzbVow?=
 =?utf-8?B?WEpjdWw2YUVSY1pBaGZpaTVLaVJraEFGbTR6ejNzM2VHUjV3WTBzUGhHMUI0?=
 =?utf-8?B?ZDNxd0JYaW5PRFhISVZjOW5VUFdVYUxsTUUyUjB5empIWU5Wd2M4Y3F4alpL?=
 =?utf-8?B?dW5jYjR1R3BIV016UnZvNlgrWklDUXBjZFJYQ3RDbjdueWpyY3Vwc05QQi9n?=
 =?utf-8?B?dHJDclVGSWV5N3p5ci94dkhPMWxWd09vL3dJLzY5OTVqQUxuUmN4QkFpdDRx?=
 =?utf-8?B?Ykt4bndqU3NCR3RCOHVVMlpkZGIvY3o1dWRwbG5kbGlra0pNZGEvM2hVbkJ2?=
 =?utf-8?B?NGRtSXdOcFVma2dmTUhGa3hDM2pZOW15RjNZVzhxRDc0dnBLSkRlckxTY2FL?=
 =?utf-8?B?Wnp6WXRLNDAyOStxTTY2MUt5NDlMQkVqNUxUQWtzU2ZWaXpMbzZOeXdRLzF4?=
 =?utf-8?B?dG5iV1BtSVJ6TDloc01QY3E3MGJMRGxpRFhWTmlybkEzTnhOdnVtSlYvQ1Av?=
 =?utf-8?B?Zzh2OTJlQU80RFhyTm9UT2NGc2kwaWdibm4xMk1NUmRxbXFvVlVRWndyWmxB?=
 =?utf-8?B?SW9yTVZiMzQ0MXFRMUZBcXBaVHlQZGRvNEVleDFsUUE5cFZTZzRsbEN2dDk5?=
 =?utf-8?B?c3d5OXZGVkp6em9Hak5RUXYzNFhMZHE0bkl6TEptRHc4dEo0dUVoR0hBVlJ0?=
 =?utf-8?B?LzNORXVHZmZVQ1dYM1NjRVAvWko0aVBOYVBJVlp4dEFsWVl0VFkxbUsxZTNQ?=
 =?utf-8?B?dWsybmY2K09JTkN3blhLSzNWRnNGdXRGYnpqdEVNemdWRWFTNXI3d3AwMExD?=
 =?utf-8?B?YXBQQ08zSjRhNG1UR245SjZqNXppK09LSGI0YS9ZU0d4MVdZRkNiTnZ1UHFJ?=
 =?utf-8?B?YmhPY1FLR2pobk9JZWYveC94aEowQUJaNTNnT1B5MXFPNnl0ZXlBS2R0T042?=
 =?utf-8?B?MTU3SGd4bXFYbk5RR1JSelJCZkNhZW44aGhuWGxaSWUvZFlETFVKU3paazhT?=
 =?utf-8?B?RnR0NkowL2F3NE9HMTYyNE0vWmZVV2lxOHhMMFpBQ0NmUHc1eEFQbm00VVZ0?=
 =?utf-8?B?cVptdEZrcUN6VzNLSGd3bzl2TE4yQ2x1K05YSldHZDA1TCtlWW1PRUliRXI3?=
 =?utf-8?B?M1RCaFZ4Z3Z0MUF1eTZ6N0hlOTI4bjhzZkRvckZuVW5IVE1zVmloUHZTTTJp?=
 =?utf-8?B?Y1Q1eDNyYXRYeGIvZXptcVFKakFDbHZDUEFjSHBLNk4yNHN5Tlh0M0JOV2gr?=
 =?utf-8?B?QXJqVVFUeWdJeG83cWZKalJERHk2Rk9LVyszNVVFNVlDY05Ka2huTk1YTmsw?=
 =?utf-8?B?eUlJVnFmSS9tdGNIVytuNkNpbC9ORzUrcVlFa0JETFFHVU95WlJuNnN3Tmlu?=
 =?utf-8?B?NEpLLzkvaExUN3hLUytXQzVOUGU0SjJlYThyRGcwMk5XZXIzVVlmVnhPWnEz?=
 =?utf-8?B?UGJoeis5Yy9LN1IvTlZRQmM2ditQNjRXMjRNVGNPQmxmTFNLc0d5MEFRc3Jo?=
 =?utf-8?B?enhRcTBnYk5jUGVJdTRiUUFmck1TM2lCZzh5Yy96eGtnVklOaXFJSG44K0Er?=
 =?utf-8?B?K0FxejJBdTFncWpEdmdXR3pWT3docjRkMVJ4WkhUbnluaDF5NWlzTktCSFRC?=
 =?utf-8?B?MzdiejVnQWtCS3U2VnYxU1l6QnlvWTJ1T0pRS1QvL1RzYmpIaGs2SXBmUTc1?=
 =?utf-8?B?d1o0QjFKNHlhNHk5V1NjSEtKWHU0bGg0RHhTMmNjdmo4Z1pGeHIxRUtjUHJa?=
 =?utf-8?B?MEkxb0grNVVFc1JBRjF3Vm0vTWlpaHYwbUZjZm1tUndtNmdpUG85MWdSL1Rj?=
 =?utf-8?B?V1czaFE2cWNsZ2FSS0tBcXo1YzF6QjM4TWVvVEZkYjJzWFdxMkRZNDFLQXg3?=
 =?utf-8?B?OG9FZ3g3bG5xdmRDTFJYSVBERlljNFhyZ3NLeUxVcVhCQlIzRmw0MjUwMTR4?=
 =?utf-8?B?UUlQNWI4Z2NVUnFocy9qVFBZMVk3TEJXYzVzM040OEozem95WGYxK3JaT2wy?=
 =?utf-8?Q?riLe9Fm66LrkBg+7GFHrnOU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF533F164823A74AA2604E90BCB47CB3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17d518db-181c-483c-b52c-08dc8643ef6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 16:15:51.7279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jyAgQPBQ1WQA2AqrC9qe8iZN7Cy0ysvgmT4xqdYrccXZiIT3oZwHCj4OnyUm2wIBHnWXJ93cUUwdNSXxpVUG7dgxY4GFVFpJR4Y5lHu6E8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8053
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA2LTA2IGF0IDE4OjA2ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgKPiA+IGIvYXJj
aC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaAo+ID4gaW5kZXggMjUwODk5YTAyMzliLi4wODRm
NDcwOGFmZjEgMTAwNjQ0Cj4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5o
Cj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oCj4gPiBAQCAtMzUxLDcg
KzM1MSw4IEBAIHVuaW9uIGt2bV9tbXVfcGFnZV9yb2xlIHsKPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGFkX2Rpc2FibGVkOjE7Cj4gPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBndWVzdF9tb2RlOjE7Cj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBwYXNzdGhyb3VnaDoxOwo+ID4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgOjU7Cj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBtaXJyb3JfcHQ6MTsKPiAKPiAiaXNfbWlycm9yIi4KCk9r
LgoKPiAKPiBUaGlzIG9uZSBpcyBhbHNvIHVubmVjZXNzYXJ5IEJUVy4KPiAKPiBPdGhlcndpc2Ug
bG9va3MgZ29vZC4KCgpUaGFua3MuIFdpbGwgcmVtb3ZlIHRoZSBoZWxwZXJzLgo=

