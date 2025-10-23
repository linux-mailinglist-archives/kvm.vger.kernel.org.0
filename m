Return-Path: <kvm+bounces-60929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1261C03AE1
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 00:32:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 746D21AA372C
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 22:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD42227E05A;
	Thu, 23 Oct 2025 22:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rx+i62Eq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A124DD15;
	Thu, 23 Oct 2025 22:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761258741; cv=fail; b=j9HzlOVnvmKVkNG18wu19/u4D9nSFFAiB0mtdmea0xJkjn5ZQuGrN9MOubkmjY8rTvg2Bj4cG5TxXJ3Lfd4nrv3am0Qe0aAQd4whMOWA/bXQnBC5BmzsD1ZiSp3xdWNZOBFDylHtP9lAnd3PxIzYzWvsMiHoZehzd5UYBute6TY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761258741; c=relaxed/simple;
	bh=W+LFFGiwSu9fEZD6KeyiOMy6c8XIsgghGEHUL05FBCI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=m4/dLpxaTuvoMvCRZn9EHalZi0XXEMeEDPvAEaxy8BBAZvz0VjXV8Thu/cWB5IcgHfqzUFPUUncCdDXWaOJdUuh0isK50PX1ilXmy0KEV8hQDNA4SLYx1NFcaYMiVp2CkL48ROuc1xC/Fry4jsiDdEhNz1IMCmvASNIGykQxdFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rx+i62Eq; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761258739; x=1792794739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=W+LFFGiwSu9fEZD6KeyiOMy6c8XIsgghGEHUL05FBCI=;
  b=Rx+i62EqU7nqqkjb1tLXxuS+XZl8xArD6iWHgrfTv9APjZObKzJBlfSk
   qt9WOlmjL4BykfJz32GzHx/bSDNlBlDuuUBm2YQdAgd+xWYPpI/8YzG1C
   MhqyevJJZEJRg/0tuIeIUiM89gw1S+33NJabA6yIK6GCVHSeW9gzAzOJa
   qxKM03vUxKeC2pstk0oEADLRAZSamnwdoUGlM5RRLmH/rHYBzWxdmeFuy
   pBiqDrrS9sCiWC3uH6wBNov3Hfkeir0lqAVku3fCAoj5VmdY9uxO4nQmj
   3PNXgXSjww7jCS8J/2NtJohd2pv3G3BdAO62qF7dVCNdX4VDkHIkivgF2
   g==;
X-CSE-ConnectionGUID: CG27E6zFQ5mlsNfPEn5K4Q==
X-CSE-MsgGUID: 5iN3uFWGSKKtXzOAB5HD9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62471674"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="62471674"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:32:19 -0700
X-CSE-ConnectionGUID: J8G+cwKVQSaLWZiQzmXlmA==
X-CSE-MsgGUID: yiIWE2HoSeuxPpmXTTDoZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="207926129"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 15:32:19 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 15:32:18 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 15:32:18 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.31) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 15:32:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ukKnvQn5UZ+qXsQkusOfnIwNxSJi/NwhVWQnXeBaZ8FNisqxw0GvHTjJdXoe+WCpM55xpOVVpIqVU0gQYrPNyOUV2tL9FfOf5UonPLvkjCHK3ZKL4Iz8NmordoPk5jS2hjecu9Mdv6Fhk86d09IpmQHXgXQTYYi6PQ2wsusbs3M56mhByN4jPhi/TyqR/1JShMpqnWh7ZVfYIX3fdyjiVqNzVCuDos/T80K/EWaQIGM4Y8UxnAZa99jXdyPE0BW+MCe21huFZM7BaEeWpW3hjvl1dMjB0KprzHpTGHdEdgkA1rn6gJbVK3IBrDnbdqW5t7JsG9JXtbEydLtRNHVAGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+LFFGiwSu9fEZD6KeyiOMy6c8XIsgghGEHUL05FBCI=;
 b=j4fJO1iow4T5CN5VvRaubksZQF/JrPH+gNhM/LlD2IVYBOvOvkbM16fAWcYb8aUBeFGvgDTsidUBsJnHG7kqqxWeIuxml0RFmiYgKz7asSJTMIjpWkB2XBNKpCzgXxXOm4hCJSfN2e+ZiW9RKiVFKmpATURh3NA28WJhAp5Dw8gT9/JcIlyT1CmPEzxETOhfekWzlEJyRskW8YKifI1r/6sBypMa5z4zHBmom+ZweQ3HWDxBVJYNy7Qo9YkGqlKTfL0ifNiVhdpyifmqg/S0qkNAEOsKFPUknZpSPrpI2Q/eZSlxrZcjyCyMaYNi+8QtESNh+Fc8ECx0eLONfe2TyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM4PR11MB6503.namprd11.prod.outlook.com (2603:10b6:8:8c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.13; Thu, 23 Oct 2025 22:32:15 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 22:32:15 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com"
	<frankja@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 13/25] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
Thread-Topic: [PATCH v3 13/25] KVM: TDX: Fold tdx_mem_page_record_premap_cnt()
 into its sole caller
Thread-Index: AQHcPv2n07zQi2kCh0qwUFWmoDYx07TQW8QA
Date: Thu, 23 Oct 2025 22:32:15 +0000
Message-ID: <233d0250d457abd153cbd63cc8227f67b9a3a933.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-14-seanjc@google.com>
In-Reply-To: <20251017003244.186495-14-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM4PR11MB6503:EE_
x-ms-office365-filtering-correlation-id: f045fd42-15c2-47fb-99f2-08de12840486
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aHJqcjBldyt0Z1lNUW9PbFZLZTNvNkgzTm5LK3lkM2ZhdTdzcFc2LzhTSjZu?=
 =?utf-8?B?NWRvTUIyVDNWbVUzUjI0QWwyYmFBcnczY25IdGh4S1FtMDVJa0pXaGxVNHd2?=
 =?utf-8?B?QTRGaWJkNzFZaEhHWmVIRm9PV3QwRy82QnBBV3JLeWE2RkpZa2dhb0xRd3Fx?=
 =?utf-8?B?SUk4RThNRU5FZ3ZjR2lBSFp6TlMvYVlrR3ZjWTl3bjNkNjkvTG43M1ZVaENj?=
 =?utf-8?B?SjNKUVNYWXpWNGdpSG42cnllRmpCYXRLM0JXUFNlRHI2L3g2cDg5ZVBLanNo?=
 =?utf-8?B?b1hIWVVWS2hybDRhNG9IQ1labXhLemdFd0lFcTdqU3psck1rbEEzWGRYbk9s?=
 =?utf-8?B?cmtna3F1SDlyTHdzYUdBb0I5TktmbFB3bTJ6cmx3eWxjelBpNlBtMVYrSURv?=
 =?utf-8?B?YmpwUWJ0ZXNEdXp0cXE1cE1qSHphbXdGNTFac3JlYndpL3NqWFpNd0lVSVVl?=
 =?utf-8?B?RXNxUy9nVkFMYU9MQW1EV2hjekNNNktRYXhFTXUvOVlTeS90MFhDYng1TlRM?=
 =?utf-8?B?SStSTmdHaXh2amZRUkJ3bFp3RVJjbUl5bkRxMWJGRmp0bUFKcUFSNjk3RUg4?=
 =?utf-8?B?L3lCaGtlN2RHMXFGVEdDamJGYURUemd2NEg0WGE2QlhNRHRVYzJvL0lwYkFL?=
 =?utf-8?B?WSs5Y3V5bTZQSlhTYUIvd2JkR1RkOWFSbjhFM251RUxkWGpOTEt1d2ZhR1h0?=
 =?utf-8?B?WXVjQmFoMEJWVmNxY0FUcnFCbmg3cythTFRJM3lIMkR3Ym9keDhRL0RxRjdk?=
 =?utf-8?B?UkVVTlZuVVdSMUFNMmNsZWV2eU5jSnJJdlE4L3A5ZktsVmQ3cTRDZTJlSzBT?=
 =?utf-8?B?Ym5EVnVQcUJMcEhWcUovR1pESVIyMVZnNUgxNWhqNE9iZ1lTMDIzTFBZRkNl?=
 =?utf-8?B?VHF2VzZwbFN1bTJzY0N4MXhMUkkyMWFCNFJQWFlyNHg5c0JiZ0h6Z1lieW40?=
 =?utf-8?B?ODZmT3d1YTBydzArbk1QR2FJSWhRWmZZQ0I2OEpvTks1WWN6OGs5Z2JJbHA0?=
 =?utf-8?B?NmhRc3VtWm1JYzN2cWw2bnZiY0Jvb2g2Njhjd0tvajdIYitnOGtWVzRHenFI?=
 =?utf-8?B?K2cvT1J6OXFBYzFnaUQ4cm96TkxKRCtBbEF2TG1UZUdGMk0wZDA0cWZ1bjRt?=
 =?utf-8?B?azR5Nk9CV2d0cWQycTlhdjVGMUpEWUxKRXc0bmY0QmhzL0lHazROaGdkZTdE?=
 =?utf-8?B?WU1xRVZOMzNwMmFtTlNlT1ZkaTZxWGZ2WjhISktjWDhSWGVXUk1RdVRNVS9r?=
 =?utf-8?B?WDM3RWRaMTJLdnRwdHdaVk95TlRJdkRJR2ZoaFcyTkp2KzVUWG9qeFJpSHJO?=
 =?utf-8?B?QUh6YWZ3RkhVSVVXU0JJZUpQSmdPWmJwNmtkd085WkFFbFpTVDdjNnJoeWty?=
 =?utf-8?B?aGZ5dWl2NkxvQ0lmM1crVjcrNFBSQUJWQ2VFL0JHdEswcC9BTFpkbmZIWWVx?=
 =?utf-8?B?cyswNVVnTG5jbHNMVDFwbjJiWjhqMFJNNVlLeS9hNWN3ZTRzSDVqR0V6SGRX?=
 =?utf-8?B?L2g1MVRmTHUwdVgxOWpObEx6WGFLdmVJajV3L2FIa3hHdDJJc0pmM0M3eHZV?=
 =?utf-8?B?MVZLaG8zaFNRQnZFcEV2MXdycnlKelgvZXkwZW9NODBOSEY1ZkNrek95bXpF?=
 =?utf-8?B?cEN2WTdyVGhiZjJwQXIwcVZ3YlB3UnlpYWxYaUJmNWJKSDFhSGQxUWY5eHpp?=
 =?utf-8?B?TjR3UGRycGxEZCsvd082emIzcUJiMGdYNkhDZjBzK2J5S1VRTlhJd3hhQTMw?=
 =?utf-8?B?Z1ZOeUZpUFBvNU0yUGVHZnRSS3hFUWdQNFNTa0ZlcEdzcjZ1em1Xeisvb3dx?=
 =?utf-8?B?dXdTUWRITWpaTmJpS08vL053Wk9GUW5sNmVmcy9yaEVzOW1QZXRxaTRhbWVi?=
 =?utf-8?B?SVBVRmpEQTg4WFM2WUowNkRrcDFsTS9SR3FFY01pZTI2dmxoT2phWFhocXFX?=
 =?utf-8?B?NzJrNE1mWG1LcDZUUkNWeDVVR2F3eGdxbkpTb2FNWkkwZ2VOUnNlSG11NVc3?=
 =?utf-8?B?SDFFazMyZzJQcG4zcTh0cVFlSGxXTE9TNmEzSFdudVVzUFJFUnE5WFByV0tL?=
 =?utf-8?B?VVpSc3k4K0JCdjlnbjUyMndMRmV2R3JiOGl0dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjdRZFNyeEdBc2NtTVFCc2ZxV2pXejFxSzJqWlAxVURSYjlKZ2ladmFuYTc0?=
 =?utf-8?B?UUNLN1EyREJMZmUvK3FwU2wwSHdLYkV6M25VdytPZ0phQm4xdjJVcnUxVlhB?=
 =?utf-8?B?aTBuZ2JRQWU0MlAweXZZVVh2SXFrb1UzaDNkalJwQm5MV0tCWmZFeHpMak9p?=
 =?utf-8?B?Wm8rTFc5MVM3R1FOVjcrTllNeWU2OFlRYUc4MzdjTG5XRXRaalV3OGMvbEQ3?=
 =?utf-8?B?TWtyOThIaGluZmpsTldWejBVMitoWUlWV05Kc2lPYnlEcTBBNWtTR0pEOUdQ?=
 =?utf-8?B?RDBtbXpoZG1MREJubWJyb3ZKd1ZMUW9hMEFVUVNPRGprY3I4SEVkMVZ3RS9w?=
 =?utf-8?B?RzFmd3crUGRPRkZYOEowOFozTkx1QUZ3ZlFkTWJ0L0ZmS3VFbTVhV2J4R2Zk?=
 =?utf-8?B?R3FHTm8vRjN5SGh0cHBHUGxGODF1NEI4ZDFhZDkxYXFaUkQzODJSaWU5dHNr?=
 =?utf-8?B?T3RrbzJyMFFSeWpJU0N5dTFLSnZMUGs2alVXb3NkYzFwVG9CR2NycENsZitj?=
 =?utf-8?B?UXZ4VzBiWE9JM29LQXdCOUJidU5ESkYwRFowY2ZYY3ZPbzIvMEkweUJIWmZY?=
 =?utf-8?B?T09mczVoL0svRlFBdGlMVi96bGZRaVEwdm51SWFsSVJjc0RLZ2NCU2g1cWhu?=
 =?utf-8?B?SU1qRTVZNVZrY29palhpS09HRGdaZHMzSDRUZjRpaCtCdDVaWGNxdlZTcFVw?=
 =?utf-8?B?VENZaGpaaUJWUXFRUHVOOGhoZ0dzaHA1aHFNK0NWN0RVelI2dlpoeTg1UE5J?=
 =?utf-8?B?M1Z6UTM1T3F1NmVOVFF0YkVRVWNtSXh1aHFKeTJwdmJLWHNKU2tqaWFlZlJV?=
 =?utf-8?B?UDdMUVhmM3U1KzloZXJvbnpoWFlNMldRK3JpajBFMUxHSURUR2VEYVNqUjE0?=
 =?utf-8?B?REV5ZFVkWDAvSHJybWZUbFVvUjFMN3JQREZsWnRtb3R5STdsaWtEMlRBQXV6?=
 =?utf-8?B?MUwvRkpCaFFvN2swMVlobDA5QXhLUGQ1N1BOam9zU3psYzJYcTZGMmFNSHd4?=
 =?utf-8?B?K3RXdmM5N2U3R1YwcGl4WEpqSHB1cGNQNnBra1Q4eTVnRy9Pc2ttenhNNloy?=
 =?utf-8?B?WlNxY0djeE1OM3JpdVFsckVUZWFIeGRBK0w5SHlNVGQ4Mzh6VVAzMjMxSGp6?=
 =?utf-8?B?aHFnbWtiSndmUEo2VnkrSEFQU1p0cnhjWERUYzN3K01zNVN1Y2pXd0QrdlFR?=
 =?utf-8?B?YU1sQnkxSUU3bFJGTHRXM1Q4eit0NERVaitIT2QrRmZwS1dqQ3pQR2F0Nm1L?=
 =?utf-8?B?ODhYVGdvNVMvM3RsUXBNRk1xbTEyWmtyeEVJaVhWWTVnRDNsT2k3am9jN0Zp?=
 =?utf-8?B?c0tRVDRuNCtCLzhvdUtVbCtsZjd0KzNqemlhUytTSXkrN09WemllT1FkdFBQ?=
 =?utf-8?B?Y2pnc21hKzlmSVRMWHhDQkVJakxsMysrY2g1NytzaXgzbEhNRC9TdnA1ZThR?=
 =?utf-8?B?UVlNcHVhWGdrb1J5ZzB3MUxVWDI2RWFqL3QwWUlXZlNPYUpjYkJsai9GbVBC?=
 =?utf-8?B?cDg3eEx4OFpPaFNNTXNTS2l5SmNwUGtnMkV2b1RPWTR5REVzbDZXU0RyMkZK?=
 =?utf-8?B?ZmFnb1V0bUtiY3M2T0FxRml2ckNQWHBEKzZBZ05Jb0ZwamorWmN5NmVsVmxH?=
 =?utf-8?B?ZVlVZ1YxZWgvQmNqcTVJbW5WMGJRSFFRZ2UxTnRxcFI0dXVBWVkxYytXQ2lx?=
 =?utf-8?B?bGpXeTBveW9ndHdQekJkNFpqeHBzY2hxeC9sSVpVcXlpcHNwL25uZTZwMkhU?=
 =?utf-8?B?dGFGTU1JQXlVQndvazhZTTc0Qzd5NXZtYTlmVThid1dqZGNsWmlGQnYrWXJr?=
 =?utf-8?B?WmFQaDc5OWhxR3NkWUN6anRMMDk3VFBNVXdBTlZQWWlldXZKTFZrZ0ZYOHlZ?=
 =?utf-8?B?K050bVZBK3NtY3NrVDlQSGJKUWRCNk1HOU9WbXdkZUFSWHI3NEZSWGJVVTNO?=
 =?utf-8?B?Vkdocm9KaGV0N01TdmRuTVNXSzQ2d2FTOVovOFp6WFFDUmNYckp2TWIvWWtl?=
 =?utf-8?B?b0ZUNjJwRk1LLzk3bWVLY3B2SjlDemhmeU5abDJ3RFpGRlFlRGpTZndhZmgz?=
 =?utf-8?B?UnVHc1RIT29mOWZSejRPejd5OGpBNEU1eXN6djl2Y2FJSC9GODFRcTk3VHhN?=
 =?utf-8?Q?gYdT6QrSmRIIYDoxhpBKynOxl?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D51797E45D8FF4FA0920D397A90A708@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f045fd42-15c2-47fb-99f2-08de12840486
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2025 22:32:15.3750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7h0yBg1Yq+r0qFMpfpLv92TwmSAEzIIi6riEwssZyQ0rcT9NmjFBIVmGPajSsKVed7qwZMklL2eeOvCqQdlUVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6503
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE3OjMyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGb2xkIHRkeF9tZW1fcGFnZV9yZWNvcmRfcHJlbWFwX2NudCgpIGludG8gdGR4X3Nl
cHRfc2V0X3ByaXZhdGVfc3B0ZSgpIGFzDQo+IHByb3ZpZGluZyBhIG9uZS1vZmYgaGVscGVyIGZv
ciBlZmZlY3RpdmVseSB0aHJlZSBsaW5lcyBvZiBjb2RlIGlzIGF0IGJlc3QgYQ0KPiB3YXNoLCBh
bmQgc3BsaXR0aW5nIHRoZSBjb2RlIG1ha2VzIHRoZSBjb21tZW50IGZvciBzbXBfcm1iKCkgIF9l
eHRyZW1lbHlfDQo+IGNvbmZ1c2luZyBhcyB0aGUgY29tbWVudCB0YWxrcyBhYm91dCByZWFkaW5n
IGt2bS0+YXJjaC5wcmVfZmF1bHRfYWxsb3dlZA0KPiBiZWZvcmUga3ZtX3RkeC0+c3RhdGUsIGJ1
dCB0aGUgaW1tZWRpYXRlbHkgdmlzaWJsZSBjb2RlIGRvZXMgdGhlIGV4YWN0DQo+IG9wcG9zaXRl
Lg0KPiANCj4gT3Bwb3J0dW5pc3RpY2FsbHkgcmV3cml0ZSB0aGUgY29tbWVudHMgdG8gbW9yZSBl
eHBsaWNpdGx5IGV4cGxhaW4gd2hvIGlzDQo+IGNoZWNraW5nIHdoYXQsIGFzIHdlbGwgYXMgX3do
eV8gdGhlIG9yZGVyaW5nIG1hdHRlcnMuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRl
bmRlZC4NCj4gDQo+IFJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21i
ZUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5q
Y0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0KDQo+IC0tLQ0KPiAgYXJjaC94ODYva3ZtL3ZteC90ZHguYyB8IDQ5ICsrKysrKysrKysr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDIxIGlu
c2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+IGluZGV4IDZjMGFkYzFi
M2JkNS4uYzM3NTkxNzMwY2M1IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5j
DQo+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gQEAgLTE2MDUsMjkgKzE2MDUsNiBA
QCBzdGF0aWMgaW50IHRkeF9tZW1fcGFnZV9hdWcoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4s
DQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICANCj4gLS8qDQo+IC0gKiBLVk1fVERYX0lOSVRfTUVN
X1JFR0lPTiBjYWxscyBrdm1fZ21lbV9wb3B1bGF0ZSgpIHRvIG1hcCBndWVzdCBwYWdlczsgdGhl
DQo+IC0gKiBjYWxsYmFjayB0ZHhfZ21lbV9wb3N0X3BvcHVsYXRlKCkgdGhlbiBtYXBzIHBhZ2Vz
IGludG8gcHJpdmF0ZSBtZW1vcnkuDQo+IC0gKiB0aHJvdWdoIHRoZSBhIHNlYW1jYWxsIFRESC5N
RU0uUEFHRS5BREQoKS4gIFRoZSBTRUFNQ0FMTCBhbHNvIHJlcXVpcmVzIHRoZQ0KPiAtICogcHJp
dmF0ZSBFUFQgc3RydWN0dXJlcyBmb3IgdGhlIHBhZ2UgdG8gaGF2ZSBiZWVuIGJ1aWx0IGJlZm9y
ZSwgd2hpY2ggaXMNCj4gLSAqIGRvbmUgdmlhIGt2bV90ZHBfbWFwX3BhZ2UoKS4gbnJfcHJlbWFw
cGVkIGNvdW50cyB0aGUgbnVtYmVyIG9mIHBhZ2VzIHRoYXQNCj4gLSAqIHdlcmUgYWRkZWQgdG8g
dGhlIEVQVCBzdHJ1Y3R1cmVzIGJ1dCBub3QgYWRkZWQgd2l0aCBUREguTUVNLlBBR0UuQUREKCku
DQo+IC0gKiBUaGUgY291bnRlciBoYXMgdG8gYmUgemVybyBvbiBLVk1fVERYX0ZJTkFMSVpFX1ZN
LCB0byBlbnN1cmUgdGhhdCB0aGVyZQ0KPiAtICogYXJlIG5vIGhhbGYtaW5pdGlhbGl6ZWQgc2hh
cmVkIEVQVCBwYWdlcy4NCj4gLSAqLw0KPiAtc3RhdGljIGludCB0ZHhfbWVtX3BhZ2VfcmVjb3Jk
X3ByZW1hcF9jbnQoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sDQo+IC0JCQkJCSAgZW51bSBw
Z19sZXZlbCBsZXZlbCwga3ZtX3Bmbl90IHBmbikNCj4gLXsNCj4gLQlzdHJ1Y3Qga3ZtX3RkeCAq
a3ZtX3RkeCA9IHRvX2t2bV90ZHgoa3ZtKTsNCj4gLQ0KPiAtCWlmIChLVk1fQlVHX09OKGt2bS0+
YXJjaC5wcmVfZmF1bHRfYWxsb3dlZCwga3ZtKSkNCj4gLQkJcmV0dXJuIC1FSU87DQo+IC0NCj4g
LQkvKiBucl9wcmVtYXBwZWQgd2lsbCBiZSBkZWNyZWFzZWQgd2hlbiB0ZGhfbWVtX3BhZ2VfYWRk
KCkgaXMgY2FsbGVkLiAqLw0KPiAtCWF0b21pYzY0X2luYygma3ZtX3RkeC0+bnJfcHJlbWFwcGVk
KTsNCj4gLQlyZXR1cm4gMDsNCj4gLX0NCj4gLQ0KPiAgc3RhdGljIGludCB0ZHhfc2VwdF9zZXRf
cHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgCQkJCSAgICAgZW51
bSBwZ19sZXZlbCBsZXZlbCwga3ZtX3Bmbl90IHBmbikNCj4gIHsNCj4gQEAgLTE2MzgsMTQgKzE2
MTUsMzAgQEAgc3RhdGljIGludCB0ZHhfc2VwdF9zZXRfcHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0g
Kmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgCQlyZXR1cm4gLUVJTzsNCj4gIA0KPiAgCS8qDQo+IC0JICog
UmVhZCAncHJlX2ZhdWx0X2FsbG93ZWQnIGJlZm9yZSAna3ZtX3RkeC0+c3RhdGUnOyBzZWUgbWF0
Y2hpbmcNCj4gLQkgKiBiYXJyaWVyIGluIHRkeF90ZF9maW5hbGl6ZSgpLg0KPiArCSAqIEVuc3Vy
ZSBwcmVfZmF1bHRfYWxsb3dlZCBpcyByZWFkIGJ5IGt2bV9hcmNoX3ZjcHVfcHJlX2ZhdWx0X21l
bW9yeSgpDQo+ICsJICogYmVmb3JlIGt2bV90ZHgtPnN0YXRlLiAgVXNlcnNwYWNlIG11c3Qgbm90
IGJlIGFsbG93ZWQgdG8gcHJlLWZhdWx0DQo+ICsJICogYXJiaXRyYXJ5IG1lbW9yeSB1bnRpbCB0
aGUgaW5pdGlhbCBtZW1vcnkgaW1hZ2UgaXMgZmluYWxpemVkLiAgUGFpcnMNCj4gKwkgKiB3aXRo
IHRoZSBzbXBfd21iKCkgaW4gdGR4X3RkX2ZpbmFsaXplKCkuDQo+ICAJICovDQo+ICAJc21wX3Jt
YigpOw0KPiAtCWlmIChsaWtlbHkoa3ZtX3RkeC0+c3RhdGUgPT0gVERfU1RBVEVfUlVOTkFCTEUp
KQ0KPiAtCQlyZXR1cm4gdGR4X21lbV9wYWdlX2F1Zyhrdm0sIGdmbiwgbGV2ZWwsIHBmbik7DQo+
ICANCj4gLQlyZXR1cm4gdGR4X21lbV9wYWdlX3JlY29yZF9wcmVtYXBfY250KGt2bSwgZ2ZuLCBs
ZXZlbCwgcGZuKTsNCj4gKwkvKg0KPiArCSAqIElmIHRoZSBURCBpc24ndCBmaW5hbGl6ZWQvcnVu
bmFibGUsIHRoZW4gdXNlcnNwYWNlIGlzIGluaXRpYWxpemluZw0KPiArCSAqIHRoZSBWTSBpbWFn
ZSB2aWEgS1ZNX1REWF9JTklUX01FTV9SRUdJT04uICBJbmNyZW1lbnQgdGhlIG51bWJlciBvZg0K
PiArCSAqIHBhZ2VzIHRoYXQgbmVlZCB0byBiZSBtYXBwZWQgYW5kIGluaXRpYWxpemVkIHZpYSBU
REguTUVNLlBBR0UuQURELg0KPiArCSAqIEtWTV9URFhfRklOQUxJWkVfVk0gY2hlY2tzIHRoZSBj
b3VudGVyIHRvIGVuc3VyZSBhbGwgbWFwcGVkIHBhZ2VzDQo+ICsJICogaGF2ZSBiZWVuIGFkZGVk
IHRvIHRoZSBpbWFnZSwgdG8gcHJldmVudCBydW5uaW5nIHRoZSBURCB3aXRoIGENCj4gKwkgKiB2
YWxpZCBtYXBwaW5nIGluIHRoZSBtaXJyb3IgRVBULCBidXQgbm90IGluIHRoZSBTLUVQVC4NCj4g
KwkgKi8NCj4gKwlpZiAodW5saWtlbHkoa3ZtX3RkeC0+c3RhdGUgIT0gVERfU1RBVEVfUlVOTkFC
TEUpKSB7DQo+ICsJCWlmIChLVk1fQlVHX09OKGt2bS0+YXJjaC5wcmVfZmF1bHRfYWxsb3dlZCwg
a3ZtKSkNCj4gKwkJCXJldHVybiAtRUlPOw0KPiArDQo+ICsJCWF0b21pYzY0X2luYygma3ZtX3Rk
eC0+bnJfcHJlbWFwcGVkKTsNCg0KTml0OiB0aGUgY29tbWVudA0KDQogIC8qIG5yX3ByZW1hcHBl
ZCB3aWxsIGJlIGRlY3JlYXNlZCB3aGVuIHRkaF9tZW1fcGFnZV9hZGQoKSBpcyBjYWxsZWQuICov
DQoNCmlzIGxvc3QuICBJIHRoaW5rIHdlIGNhbiBzb21laG93IGVtYmVkIGl0IHRvIHRoZSBiaWcg
Y29tbWVudCBhYm92ZT8NCg==

