Return-Path: <kvm+bounces-19094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C31FC900D35
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 22:52:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BDA828399C
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 20:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C196C154C17;
	Fri,  7 Jun 2024 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GOWp7o7y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9BD154BF7;
	Fri,  7 Jun 2024 20:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717793557; cv=fail; b=lALJJQthB4XtVScnLWwEOXXWabtNn0sxexVTJQrVL8y6jk6u1Wtsefs2KeRCGdAN1AMM4jTL6QypMRydbriOyrtrC041v1X3GwkYIPJzUkUBrOlamR9Jw2glenL9+szf3uvyPea7QsCNABrzoaomIV6hTqSUNzwrpAR0VCxLUD8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717793557; c=relaxed/simple;
	bh=wZUcveo/IH/80SfqQoAp0y64OkqTwJzheqlBU0w2prI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dXCJsV+QE9DANsV1tUZmyPYZK+c+TuxnLVSuEPL4pDfwnZr4dujetD+jJDPzn8dsNDfKMEuOUMDcPO9DilVGy41KYUv4o8keInP/ooTfK/kFLVr4Aqoxrle+11ZwPYvW9t5s5Av90nnqTzRVnYgaRwwIiDfiR6PbOP7hp6sFq/w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GOWp7o7y; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717793556; x=1749329556;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wZUcveo/IH/80SfqQoAp0y64OkqTwJzheqlBU0w2prI=;
  b=GOWp7o7ypPh8wxrowVYYBnCiFkpea3ZXlsoVNnN8YaA6v0jcnxEA3/BO
   AqBmFlHe8F9Kses+HMUQty+5MDDJeFSZxuVhQzy7TDG7mOnbT7s3KR30U
   nvMfN4nUoGuCgNJZ6zeViEsp6WKZwuEme6rv6YRCJAktruuS836gBcFLD
   wEa2X1Bk7XmD6o3NPyQJQrUpt2c9cBcIImnt1IFUpou80A0EiYQZ/ZgR7
   N5U6+1k7+CJKpTr1ggA1GiE0jUdGpI8T8hurq1JqYiyL3wrgHZ5LmnTu8
   E69JG3dERRT684vmjVeIHyGhD/ey2XoFG6fiHnmLZEPyxpEpADHL1FpWx
   g==;
X-CSE-ConnectionGUID: 2iBLUoifSTaRHJW2zBR7kQ==
X-CSE-MsgGUID: /fXIHBT6SHa9vZTxkXESTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14767432"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14767432"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 13:52:35 -0700
X-CSE-ConnectionGUID: AujzFFY0RGiGuRnsAHmmMg==
X-CSE-MsgGUID: 9XHLyceFRHSzidzSIAAetw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38433684"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 13:52:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 13:52:34 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 13:52:34 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 13:52:34 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 13:52:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDsfWQFzDnn0NH4Kt5KY8aYy3K7aRgekT+87dAjM2YeNh4Ja6dJ57ogymWOgoeph0pXwlqdmLp0O7bJjGKcFjA1xnbidGJgz9LnE4qde+Z1ywccfGdF1jL0NI3l/rR1HW1VYeo0Por752Kpu+EL8CJSwflWdTksoJYeeY0n3UtNLY/fFxB+blVJV631+zwxysb9uZ5oB9QMZqwDN64k7T9SLcgTDTad053jl0uYwhrJXL3+/VlnevEJ+HQGfrVXk3F/ZMzofnUga+cKt7X0dTVBSqhKFSrOl7kvWFy1563xHFMozSyofseofcb6OyLKgrY4/vlPtXvBMo6440xcpLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wZUcveo/IH/80SfqQoAp0y64OkqTwJzheqlBU0w2prI=;
 b=XGZsZhBNVDvbdlgAH9SqS3Tli775Aa+JHge/MOmm0d82XihZXnEds982dut8YywbUbxD7wX+0vXw0olQ66RN1HB1cLTDbKA73OSrDes1lxPny0WQyE0iIV25Y7FAaGq789R0XaC2gBa5IxwFgdGpKN3OqoFNLylO4W5WBJXtDuLKMapC0pZZNUDsq+a/WR3EFw0+C8DLTbgRbMKHIxLLKzl0ZgiXSkJLDesePW8B2r8s+oZNsQLEkALqXOjWn+aVrugQhCbpkhcY9aHMWB9HdECZgpXE3teYUpO2EJFVJ1XqMniIxcxHH6uXkfcYTLEC9B79m9zbgu3mhoLTXbV0kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB8354.namprd11.prod.outlook.com (2603:10b6:208:48c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.33; Fri, 7 Jun
 2024 20:52:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 20:52:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 10/15] KVM: x86/tdp_mmu: Reflect building mirror page
 tables
Thread-Topic: [PATCH v2 10/15] KVM: x86/tdp_mmu: Reflect building mirror page
 tables
Thread-Index: AQHastVs1q2hkoirN0SkbNQdRgcKZ7G8IDKAgACzW4A=
Date: Fri, 7 Jun 2024 20:52:29 +0000
Message-ID: <44fed65b5b7f180e912f265209269a0a2b2f8846.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-11-rick.p.edgecombe@intel.com>
	 <CABgObfYhKmBkqGP-d12o6W2TfiaqwP-c8pcae9-pnkaYJt6K-w@mail.gmail.com>
In-Reply-To: <CABgObfYhKmBkqGP-d12o6W2TfiaqwP-c8pcae9-pnkaYJt6K-w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB8354:EE_
x-ms-office365-filtering-correlation-id: 07664418-e93a-447c-ceab-08dc8733bf0b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cjdQSkNoSHFnTDlYUnVuUi9FMGZ2eHhIcWE1WldWK25SKytMaGZraG5oN01S?=
 =?utf-8?B?bkJOOGRreGt2Q3hCSVMrQ3QxUE5FOVFWVGtTZE13ODM5dzBvRWFnSC9lU1BB?=
 =?utf-8?B?ekNUdm1scEc3MVRLdDFmZ2gxY2FyaFZRTVlXdEhqSm56V1VXK2ZGOERETEJp?=
 =?utf-8?B?OUM3bFltZE5IMGRXcVJqSE9DUytWalIzT2dnbHhVc0kwZy8yQ0FFZ0c5V253?=
 =?utf-8?B?dDRDd0FNOUdKN295alk2SFBnWS94eGNSWFhFekhIN243ZmVoNUV4c2t3OUF3?=
 =?utf-8?B?eDZkcEZhakpEVHF6TEI1eVFjMzM2bzVWTllDVTAwMFpCZHJNb3dKQmZtc3I1?=
 =?utf-8?B?WHlKVjU2dDI2bFVydzlEa280eTRybDJZaDNwekhzVWZ3NzN3eHpJcHVzMmJO?=
 =?utf-8?B?TGV0ckt6WUROTlZFQVFRbkl1WTVGS2tROHhUMm9TeDlRa2E5cVp3eDBlSFhG?=
 =?utf-8?B?TjV4bHNCbmlzajRNczFrdmZNY1JMRzJpeFdsMTJ2SEE1OEhsRXRQRmpNcmFx?=
 =?utf-8?B?RHk3azhFYlNnb0tkNVBZQmtkS1JDYTRZQnVyb2NEZEdpKzY0R1BDeTlOcXd5?=
 =?utf-8?B?aGJtRm1XTkJwZ29mTy8zWEdudmVpbCtTNTl3RWV3amlWdzB5SW13VkN3S2dO?=
 =?utf-8?B?K0ZFN3BFQWNZTE9VdzNQYTFmd003S0t6Skx4K0Y4MHlDY1NaZ1VlSFlYVGhz?=
 =?utf-8?B?T1RDaDVxeXJhUElvdVN4c0FOeUIzRU01clJvVmNaNXQzOUVGSUxSTkMxcVoz?=
 =?utf-8?B?REZJcERBVVhMQUFHczVKeTVyczIzRlpzV01Xck5VMkNacVluTVVpMHRuaU5Z?=
 =?utf-8?B?a1RZd1ZpU1NqQnNiUHRZUFVGVkxwcHNhMVdBMWRmeC9pMlI4Wm9qN0FmYkhu?=
 =?utf-8?B?dnVaMUtqcmtLNEFVYmNWVTRWTHBPKzRlb2tGM1pTRWtwN1dKVzFmdFBvcmE5?=
 =?utf-8?B?dW9HVzhwdUlVVzUrVVNIQkx1WTZvYVN0UW9oQktNcVNOemlmNXVnUlk4b0t3?=
 =?utf-8?B?WUtydy80UHgwS1Q0UDdHZ2tnZkRBYzhqOHBJL1RvTFdYcTBDRkRRSlBrakRF?=
 =?utf-8?B?NmJqV2lmNzJ4TlhLLy9YSmMrS09PT3o0OFV2bGtJejhUUXFxRHZrbW5rWFAw?=
 =?utf-8?B?U2JsdEQrc2dWVEU4YnpSWCtLRjF4eWFORGxBUDNKalFMMG85T2RLTlhoc004?=
 =?utf-8?B?SmVYTlIwajgxTTB6bTFWS1IwWS9qQ1J1d0psNHl2Ulo2Yk42K3N4d3Uxd0RD?=
 =?utf-8?B?aW1JeVp5TUdaTVBpOFRRWVdWUE9OSS9ydCtxTlN3OGJxOTN1Unh2eldKbXZU?=
 =?utf-8?B?TXgzRzI3bmN5K0FvUVI5R2FPcklRRlpWUUs3QkFXd1hiVjNJeXZ4Z0VtNzc1?=
 =?utf-8?B?WE5Da2xIdXZLOVluWUU1ZzdsNk5MMWJrQTBvWFdXNFJ0Tk55QnRuSlZDbUxK?=
 =?utf-8?B?Q1BZWlZSR052WThzQURmMXVoZ3gzZm44c3ltL21PQndEN1lMRDVnalh1S0tO?=
 =?utf-8?B?MlpGT2lHQ1M0OVQwclEzbU1wTE9udzlUTEMxNmlxM2g2MmYweFQ2VTRKbHJZ?=
 =?utf-8?B?YTBWeDdvZXFCZi9rVHVRN1dLOTU4NlZaWWEwVGUxU3RkcWh2ZHFmTW1renhM?=
 =?utf-8?B?OFpaTVJWNUxOck11NGFPZ3hKMjlVMzF2NUxxVzdabnBwb0ppRU9JeHdkRTln?=
 =?utf-8?B?Qy96VURNNUlMVDF6K0xIbm8wcjE0Q0dnWmNmcmtFTXp6YmFLcUZEZnNkK2lq?=
 =?utf-8?B?Rm4xZmhCV0lDRFAzdS9STEMzdGd0NFVPK0FHUUxscHdWcUVqV2dseUt0UDFw?=
 =?utf-8?Q?ixzojpERnkPpwq/3LcseomPh2HyWlq09ABsT8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0RaN2RFR0lvZGgwazZDSS9MdzJjWnZqUmxGaWVIamFRaEJrKzJkMkRheUFn?=
 =?utf-8?B?cmxNSkVKU1IzaE93SXFqMExKYU41TWs4VWt6VnVLVXVHbXNFeE5TUi9TaGJw?=
 =?utf-8?B?NFZHdFUrU3BKTFd6cjRTUTU5TDAwNGQ3QU0zMithL1ErbjFQODN4U1NMcExR?=
 =?utf-8?B?S0tLWDBTRUNWSjRjT2x2ZFhjVFJLM3RjMHdCcTRYUWNaNHFtakg0Y1NUMEZp?=
 =?utf-8?B?R3BjU00wRmFwMmtVYlZXbHpqWHBxQjltVktEK1hRWEhxcDU2V2NYbVlhMEpG?=
 =?utf-8?B?RzVGcjE0b0MzdFlhMXVBdkdIWWorSVpvUHFsUmhlVVlyZ05wNWM3cFNEWHls?=
 =?utf-8?B?dzkxeUxEVm1rWnY2cWN1Q1d0K1J1WE1sVnFVRHVZaDArQVdPemxCRjZTczl6?=
 =?utf-8?B?M1lUc3VXOXBvanQzTW9GN0N0T25DQU5EaGdEOHRJY1BvTlJUVnJ0VmkzdG9L?=
 =?utf-8?B?NVVMS2pGS3ZkcS9Ha3hzMEhWWkhiWUF2L0NlaEh0UVRTbTlrVGhSVGROMStU?=
 =?utf-8?B?M2NiRHVYWkxlRFh6WGwwZ1RVNnAyVy9nT0lDTi9WQ1ZrdFgyVERraXJ4WjVy?=
 =?utf-8?B?Z1A0cVVxNFRoL0ErWDhZbHRUS2xSREhOalI2em1UVXBHL1JscnoxYldGV0w4?=
 =?utf-8?B?VjRGRWthS0RUS29ueFQwbXNUaU00MFFLTExjbmUxV1RERGdQM09YYW9rZDlR?=
 =?utf-8?B?YU11dm0wellYdytrc1ZVamJBL1Z3aFVNWmZ6SXhZS0tRRFIzM0JveVFZc2Vj?=
 =?utf-8?B?bXRUeUVPc0YzV2tSanhGbUFXaytKVThrV05zcXFpaGVFQ1RKWSt1Rmh3Z2E2?=
 =?utf-8?B?N2NrQWovc0NnTk4yVFNZV2tNeWs5VEpsTURtUUZRK2ZMazQ5eEdpcGoxdUtV?=
 =?utf-8?B?WWhycmNiMVVHZmwyNjZzYjdscjVzbDFuclV3TXRDMXRFYWhJbVRxTnBodm91?=
 =?utf-8?B?RHRGcFRpQk5XeExYMys3OHdCMnp0WjUwWUFCNmRGanordzd2V2dCR2lBQ1Vt?=
 =?utf-8?B?MkUxNnNQQkdUaGFGOUxKVmd1czR1bkhibm5vUDg2SVdwaGV3NjdtT1dSZ2Ux?=
 =?utf-8?B?cVZpbWRSMjdwRlF6T1lqK0pSTVRMRGJUOTZVRHJBZFhDbUZPZ2gyT2dSakRD?=
 =?utf-8?B?SmFWT3VKYkgyZmRyWnpBYWlVc1VtaXIyTU1vdDNVQzFkZ0ZidVpDWUsxbVVm?=
 =?utf-8?B?dE81SXh5ZXZ3TmthdlM0NC83NnhSVDdVQWtvQlQ5RmU5R3FvVXFCY3U3OENn?=
 =?utf-8?B?Tk43VmlGeExwQlZMUFQvMGV6Vk1BaU9McFhycFFOT2VpSDFOOWpRTTkwQW54?=
 =?utf-8?B?ckVUMjdJWGNqc0k2eXpEdGUyTC82MUROZ3VDaXhzSDM5QXJTL1VqaTB1Y1FE?=
 =?utf-8?B?dnc4RjdlVTFCYmxvYm5kRmMwam01ZlJuYjV1Yllnd0ZjS3VyYWkxd2JDditC?=
 =?utf-8?B?b0ZZcnV5V2o4RzJKVFZuNiszSzJ5dVh3TUg4cnBUSFNJVWxSQnE4U0pyUnhR?=
 =?utf-8?B?d2dHTzNMMmI2R2xiRUQyZWRqVWY1U2RFMG4zRnpwcXRLbWN5ZXJDSm05aEJt?=
 =?utf-8?B?bHZxbjhGbjNyRmdMbXdOSkJzOVJyVVhaaStrVmtmbzBVSSt5VjBsT2ovT1Bz?=
 =?utf-8?B?WEpoUG9qdG90enA4N3dyWjNIM2hOMFNDOEJDUndTSjVjbWwrN3o2bWFsRDRq?=
 =?utf-8?B?TGtkNDI4V2x1Tm5JRWFnaEhPcXdVN1pRSiszdGZrZDRKdzhQSGgrSm5QREkx?=
 =?utf-8?B?NlBnSlhheTFSa3N3emZqcnE1Vm5EYkRZRWM0bU5WcWk4ZHdsTjFUd05rNFJV?=
 =?utf-8?B?VlFxcjRmSE1BUURhVWVZRXYyM3d0c2dWOXpFOTdFRHp0V0tXWXRtVTJLMW5v?=
 =?utf-8?B?eE56anVkdGJhMEplUXN0d05lWHVjOGQ1UjBPVFBBRFd6Q09rcmZBaDc3dTk1?=
 =?utf-8?B?Q3dCM25vZ0RjaVduMXk0cnhNWElpZll1bTFmRGZwTzhIamF5dWk2Q0JzNUV5?=
 =?utf-8?B?bDVzRTZ2aml1MlVjdVF3eXdNOFZMSUpWb21VUEgrQVdIRFZITC9rTWpVUlln?=
 =?utf-8?B?M1UzOW5zTTFDNC8wa2U2ZHZRb2RNTUVObkxFdSt0YWdCTm9BUUpVMGs4S0NW?=
 =?utf-8?B?UnVhZ2s0THJONnBTTFVnMlExRk0xbmY0YnJjdlJpWmpSYXlGQnBzZXBTMDRu?=
 =?utf-8?Q?GHNqmlbeN6EEQ4rXOT12Rjk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C4CFB1C803D47478D01AA129FB6ABF3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07664418-e93a-447c-ceab-08dc8733bf0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 20:52:29.8042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vsaSXurjfWi+jUwHewn2mOYELR5OQq3vKuiVAOIFW3PzuW7M9rcFqtFTjAZjYWjl2p2mncIewNiC6e5Q3WdknJ5cKrJhbzy4OeTm6z8elgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8354
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDEyOjEwICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
IE9uIFRodSwgTWF5IDMwLCAyMDI0IGF0IDExOjA34oCvUE0gUmljayBFZGdlY29tYmUKPiA8cmlj
ay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+IHdyb3RlOgo+ID4gK8KgwqDCoMKgwqDCoCAvKiBVcGRh
dGUgbWlycm9yZWQgbWFwcGluZyB3aXRoIHBhZ2UgdGFibGUgbGluayAqLwo+ID4gK8KgwqDCoMKg
wqDCoCBpbnQgKCpyZWZsZWN0X2xpbmtfc3B0KShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwg
ZW51bSBwZ19sZXZlbAo+ID4gbGV2ZWwsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZvaWQgKm1pcnJvcmVkX3NwdCk7Cj4g
PiArwqDCoMKgwqDCoMKgIC8qIFVwZGF0ZSB0aGUgbWlycm9yZWQgcGFnZSB0YWJsZSBmcm9tIHNw
dGUgZ2V0dGluZyBzZXQgKi8KPiA+ICvCoMKgwqDCoMKgwqAgaW50ICgqcmVmbGVjdF9zZXRfc3B0
ZSkoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sIGVudW0gcGdfbGV2ZWwKPiA+IGxldmVsLAo+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBrdm1fcGZuX3QgcGZuKTsKPiAKPiBQb3NzaWJseSBsaW5rX2V4dGVybmFsX3NwdCBh
bmQgc2V0X2V4dGVybmFsX3NwdGUsIHNpbmNlIHlvdSdsbCBoYXZlIHRvCj4gcy9taXJyb3JlZC9l
eHRlcm5hbC8gaW4gdGhlIGNvbW1lbnQuIEJ1dCBub3QgYSBoYXJkIHJlcXVlc3QuCgpEZWZpbml0
ZWx5IHNlZW1zIGJldHRlciBub3cgdGhhdCB3ZSBoYXZlIHRoZSAiZXh0ZXJuYWwiIG5vbWVuY2xh
dHVyZS4KCj4gCj4gPiArc3RhdGljIHZvaWQgKmdldF9taXJyb3JlZF9zcHQoZ2ZuX3QgZ2ZuLCB1
NjQgbmV3X3NwdGUsIGludCBsZXZlbCkKPiA+ICt7Cj4gPiArwqDCoMKgwqDCoMKgIGlmIChpc19z
aGFkb3dfcHJlc2VudF9wdGUobmV3X3NwdGUpICYmICFpc19sYXN0X3NwdGUobmV3X3NwdGUsCj4g
PiBsZXZlbCkpIHsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBrdm1f
bW11X3BhZ2UgKnNwID0KPiA+IHRvX3NoYWRvd19wYWdlKHBmbl90b19ocGEoc3B0ZV90b19wZm4o
bmV3X3NwdGUpKSk7Cj4gCj4gSSB0aGluayB0aGlzIGlzIHNwdGVfdG9fY2hpbGRfc3AobmV3X3Nw
dGUpPwoKWWVzLCB0aGF0IHNlZW1zIG11Y2ggZWFzaWVyIHRoYW4gYWxsIHRoaXMuCgoKW3NuaXBd
Cgo+IAo+ID4gK3N0YXRpYyBpbnQgX19tdXN0X2NoZWNrIHJlZmxlY3Rfc2V0X3NwdGVfcHJlc2Vu
dChzdHJ1Y3Qga3ZtICprdm0sCj4gPiB0ZHBfcHRlcF90IHNwdGVwLAo+IAo+IHRkcF9tbXVfc2V0
X21pcnJvcl9zcHRlX2F0b21pYz8KPiAKPiA+ICvCoMKgwqDCoMKgwqAgLyoKPiA+ICvCoMKgwqDC
oMKgwqDCoCAqIEZvciBtaXJyb3JlZCBwYWdlIHRhYmxlLCBjYWxsYmFja3MgYXJlIG5lZWRlZCB0
byBwcm9wYWdhdGUgU1BURQo+ID4gK8KgwqDCoMKgwqDCoMKgICogY2hhbmdlIGludG8gdGhlIG1p
cnJvcmVkIHBhZ2UgdGFibGUuIEluIG9yZGVyIHRvIGF0b21pY2FsbHkKPiA+IHVwZGF0ZQo+ID4g
K8KgwqDCoMKgwqDCoMKgICogYm90aCB0aGUgU1BURSBhbmQgdGhlIG1pcnJvcmVkIHBhZ2UgdGFi
bGVzIHdpdGggY2FsbGJhY2tzLAo+ID4gdXRpbGl6ZQo+ID4gK8KgwqDCoMKgwqDCoMKgICogZnJl
ZXppbmcgU1BURS4KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIC0gRnJlZXplIHRoZSBTUFRFLiBTZXQg
ZW50cnkgdG8gUkVNT1ZFRF9TUFRFLgo+ID4gK8KgwqDCoMKgwqDCoMKgICogLSBUcmlnZ2VyIGNh
bGxiYWNrcyBmb3IgbWlycm9yZWQgcGFnZSB0YWJsZXMuCj4gPiArwqDCoMKgwqDCoMKgwqAgKiAt
IFVuZnJlZXplIHRoZSBTUFRFLsKgIFNldCB0aGUgZW50cnkgdG8gbmV3X3NwdGUuCj4gPiArwqDC
oMKgwqDCoMKgwqAgKi8KPiAKPiAvKgo+IMKgKiBXZSBuZWVkIHRvIGxvY2sgb3V0IG90aGVyIHVw
ZGF0ZXMgdG8gdGhlIFNQVEUgdW50aWwgdGhlIGV4dGVybmFsCj4gwqAqIHBhZ2UgdGFibGUgaGFz
IGJlZW4gbW9kaWZpZWQuIFVzZSBSRU1PVkVEX1NQVEUgc2ltaWxhciB0bwo+IMKgKiB0aGUgemFw
cGluZyBjYXNlLgo+IMKgKi8KPiAKPiBFYXN5IHBlYXN5LiA6KSBXZSBtYXkgd2FudCB0byByZW5h
bWUgUkVNT1ZFRF9TUFRFIHRvIEZST1pFTl9TUFRFOyBmZWVsCj4gZnJlZSB0byBkbyBpdCBhdCB0
aGUgaGVhZCBvZiB0aGlzIHNlcmllcywgdGhlbiBpdCBjYW4gYmUgcGlja2VkIGZvcgo+IDYuMTEu
CgpPay4KCj4gCj4gPiAtc3RhdGljIGlubGluZSBpbnQgX190ZHBfbW11X3NldF9zcHRlX2F0b21p
YyhzdHJ1Y3QgdGRwX2l0ZXIgKml0ZXIsIHU2NAo+ID4gbmV3X3NwdGUpCj4gPiArc3RhdGljIGlu
bGluZSBpbnQgX190ZHBfbW11X3NldF9zcHRlX2F0b21pYyhzdHJ1Y3Qga3ZtICprdm0sIHN0cnVj
dAo+ID4gdGRwX2l0ZXIgKml0ZXIsIHU2NCBuZXdfc3B0ZSkKPiA+IMKgewo+ID4gwqDCoMKgwqDC
oMKgwqAgdTY0ICpzcHRlcCA9IHJjdV9kZXJlZmVyZW5jZShpdGVyLT5zcHRlcCk7Cj4gPiAKPiA+
IEBAIC01NzEsMTUgKzYyOSwzNiBAQCBzdGF0aWMgaW5saW5lIGludCBfX3RkcF9tbXVfc2V0X3Nw
dGVfYXRvbWljKHN0cnVjdAo+ID4gdGRwX2l0ZXIgKml0ZXIsIHU2NCBuZXdfc3B0ZSkKPiA+IMKg
wqDCoMKgwqDCoMKgwqAgKi8KPiA+IMKgwqDCoMKgwqDCoMKgIFdBUk5fT05fT05DRShpdGVyLT55
aWVsZGVkIHx8IGlzX3JlbW92ZWRfc3B0ZShpdGVyLT5vbGRfc3B0ZSkpOwo+ID4gCj4gPiAtwqDC
oMKgwqDCoMKgIC8qCj4gPiAtwqDCoMKgwqDCoMKgwqAgKiBOb3RlLCBmYXN0X3BmX2ZpeF9kaXJl
Y3Rfc3B0ZSgpIGNhbiBhbHNvIG1vZGlmeSBURFAgTU1VIFNQVEVzIGFuZAo+ID4gLcKgwqDCoMKg
wqDCoMKgICogZG9lcyBub3QgaG9sZCB0aGUgbW11X2xvY2suwqAgT24gZmFpbHVyZSwgaS5lLiBp
ZiBhIGRpZmZlcmVudAo+ID4gbG9naWNhbAo+ID4gLcKgwqDCoMKgwqDCoMKgICogQ1BVIG1vZGlm
aWVkIHRoZSBTUFRFLCB0cnlfY21weGNoZzY0KCkgdXBkYXRlcyBpdGVyLT5vbGRfc3B0ZQo+ID4g
d2l0aAo+ID4gLcKgwqDCoMKgwqDCoMKgICogdGhlIGN1cnJlbnQgdmFsdWUsIHNvIHRoZSBjYWxs
ZXIgb3BlcmF0ZXMgb24gZnJlc2ggZGF0YSwgZS5nLiBpZgo+ID4gaXQKPiA+IC3CoMKgwqDCoMKg
wqDCoCAqIHJldHJpZXMgdGRwX21tdV9zZXRfc3B0ZV9hdG9taWMoKQo+ID4gLcKgwqDCoMKgwqDC
oMKgICovCj4gPiAtwqDCoMKgwqDCoMKgIGlmICghdHJ5X2NtcHhjaGc2NChzcHRlcCwgJml0ZXIt
Pm9sZF9zcHRlLCBuZXdfc3B0ZSkpCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBy
ZXR1cm4gLUVCVVNZOwo+ID4gK8KgwqDCoMKgwqDCoCBpZiAoaXNfbWlycm9yX3NwdGVwKGl0ZXIt
PnNwdGVwKSAmJiAhaXNfcmVtb3ZlZF9zcHRlKG5ld19zcHRlKSkgewo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgaW50IHJldDsKPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIC8qIERvbid0IHN1cHBvcnQgYXRvbWljIHphcHBpbmcgZm9yIG1pcnJvcmVkIHJv
b3RzICovCj4gCj4gVGhlIHdoeSBpcyBoaWRkZW4gaW4gdGhlIGNvbW1pdCBtZXNzYWdlIHRvIHBh
dGNoIDExLiBJIHdvbmRlciBpZiBpdAo+IGlzbid0IGNsZWFyZXIgdG8gc2ltcGx5IHNxdWFzaCB0
b2dldGhlciBwYXRjaGVzIDEwIGFuZCAxMSAoeW91ciBjYWxsKSwKPiBhbmQgaW5zdGVhZCBzcGxp
dCBvdXQgdGhlIGFkZGl0aW9uIG9mIHRoZSBuZXcgc3RydWN0IGt2bSBwYXJhbWV0ZXJzLgoKSSBh
Y3R1YWxseSBzcGxpdCB0aGVtIGluIHR3byBmb3IgdGhpcyB2Mi4gSSB0aG91Z2h0IHRoZSBjb21i
aW5lZCBwYXRjaCB3YXMgdG9vCmJpZy4gTWF5YmUgSSBjb3VsZCBqdXN0IG1vdmUgdGhpcyB3aG9s
ZSBodW5rIHRvIHRoZSBuZXh0IHBhdGNoLiBJJ2xsIGdpdmUgaXQgYQp0cnkuCgo+IAo+IEFueXdh
eSwgdGhpcyBjb21tZW50IG5lZWRzIGEgYml0IG1vcmUgaW5mbzoKPiAKPiAvKgo+IMKgKiBVc2Vy
cyBvZiBhdG9taWMgemFwcGluZyBkb24ndCBvcGVyYXRlIG9uIG1pcnJvciByb290cywKPiDCoCog
c28gb25seSBuZWVkIHRvIGhhbmRsZSBwcmVzZW50IG5ld19zcHRlLgo+IMKgKi8KCk9rLgoKPiAK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChLVk1fQlVHX09OKCFpc19zaGFk
b3dfcHJlc2VudF9wdGUobmV3X3NwdGUpLCBrdm0pKQo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAtRUJVU1k7Cj4gPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAvKgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
IFBvcHVsYXRpbmcgY2FzZS4KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiAt
IHJlZmxlY3Rfc2V0X3NwdGVfcHJlc2VudCgpIGltcGxlbWVudHMKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKsKgwqAgMSkgRnJlZXplIFNQVEUKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKsKgwqAgMikgY2FsbCBob29rcyB0byB1cGRhdGUgbWlycm9yZWQg
cGFnZSB0YWJsZSwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKsKgwqAgMykg
dXBkYXRlIFNQVEUgdG8gbmV3X3NwdGUKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgKiAtIGhhbmRsZV9jaGFuZ2VkX3NwdGUoKSBvbmx5IHVwZGF0ZXMgc3RhdHMuCj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovCj4gCj4gQ29tbWVudCBub3QgbmVlZGVkICh3
ZWlyZCBJIGtub3cpLgoKU3VyZS4KCgoK

