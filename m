Return-Path: <kvm+bounces-24177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE0D09520E9
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 754D628ADDD
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56B1F1BC075;
	Wed, 14 Aug 2024 17:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KI+jhFUQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB78E1BBBCC;
	Wed, 14 Aug 2024 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723655859; cv=fail; b=rQaeRsIV2YWzSXVUArmjq+CgjvvXP75mbMJ6DRU9Gp4Y6VvYaLtKBJ4ZcysjjoWQnIEYpo9NeU7Kd/IgVa3bIBZhzPGjMg6fGl6Sa+rmt3ypFxggr5MzzijPgVbuZ0tFj/22ajLE54vhYF3eE2DKDpX2J0FZCLG5FL+SSH8GKXg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723655859; c=relaxed/simple;
	bh=hjKYYRkF2Or4tOtvidviAeBRZHz4kGVURhFVunVMItk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SL18g1TmmbtMk67TRnRzUCKTsvoaGdwpUhFsbUr/rdulabbk1smgpaW21lEG/RwWxqzVmiOhzVkstxo9kRn/TvtcrbfYMJpWF97jkx9h57De5MrGkOkZ0Q0eXQgn1obadhDkPJvLMVzkFpeuywZee8v/HOpGwD0JCSwnPNElx64=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KI+jhFUQ; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723655857; x=1755191857;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hjKYYRkF2Or4tOtvidviAeBRZHz4kGVURhFVunVMItk=;
  b=KI+jhFUQhYWh3k7ZnC/NwXwd+kHVN/ZT3Mq7n3Vkul/QWU6wYvVw+1Yg
   IgTvHmdvU2wc97NsLJtf0jsKvylGh4y+WG7Lh/pr3fViXJMdIP0HFTAMi
   PXc5Lmkglh51ttZ1HqFKyZo9dISs1tuyeXPUzr2ddfvWlbIzcKGrozSKl
   p2fiK3yAHm+265eaC2pLk1SrieLsGG/Cflyuo2I5FQxuF4syVxoecOrc4
   CZq6OTKp8Iv4NM/WPwm9LC9AfqtPRBLwDpVLvi0BShg8Jk8RD7IuGFRB3
   p9ng8pnz5nNmUuA0V4nT/BzGoWlavTq17NkaH7GW9a0e1egO4guLzdA4p
   Q==;
X-CSE-ConnectionGUID: ugwFwQ1ETkuxkoT0yvOJXw==
X-CSE-MsgGUID: gjZRR4uSS/KrdT5R8UX9oA==
X-IronPort-AV: E=McAfee;i="6700,10204,11164"; a="21702387"
X-IronPort-AV: E=Sophos;i="6.10,146,1719903600"; 
   d="scan'208";a="21702387"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2024 10:17:36 -0700
X-CSE-ConnectionGUID: K7qCQNNcT6CkebUylrRJMg==
X-CSE-MsgGUID: M4Nl9c5aQbK7VrORBsOuOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,146,1719903600"; 
   d="scan'208";a="59048354"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Aug 2024 10:17:36 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 10:17:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 Aug 2024 10:17:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 14 Aug 2024 10:17:34 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 14 Aug 2024 10:17:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TFRdmh2aCJfWmmMhsFDVmB91d2o/jlM5IyQkmYIDC4aD4FWo8T4O+h0HG3VFLbq8YAIqjlZBW5LkVCzw+e762RvKmViQSmEpL73St8J59NUh9a76VmFQaja0+whUtWVwxfGmlXTWM58yFJ5vptNE82sD1MYmf4WNkb7jfTUbN62BMR0q6kxcE6qTgDGgBUdnLImBDVOWulMIW+etO2C/bef7qwpSWAqa9u9QNBh2AvHZfZxHXhyf4JkvEIfEpIILGtLimvqGGldAChtpy40yj6V4QvvOTb67Po4alLUQHOXwOcNtcygaQqPFoT9hc+dS/y77dfebZQ8ehiHNl3Et0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjKYYRkF2Or4tOtvidviAeBRZHz4kGVURhFVunVMItk=;
 b=OHKk7PYiMwI8c7Ej58dug44he1R02b6C1l1tsBilvCEzZm517XWiy22D4TdEg9AvntFLFWPQ+zrhrF49QHFb+nR33UGM/HFOpoURNw0z0/nOy/ApBdaU+uD9KCS3CaPVclLLI8ffAGp0tcqEbz0wFXsLjNXE62Xp9igdfg6Sk8OsZnrAqEoVPhZ2BV4PM2GdpYDb0n6Hk0IvLYt51gn5No3lMr4OcZXQqFKQAMLSXhJwUsBLMMFmT4GVe+oNTG9kOopKKvC4D8ebpvgbVEkKabC/jvYqR+cU/rfk4uA6N8oiNRVJVeOh0i1G33Hl/CV0ACiPY6y08G/3mDDxyUN/HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB7617.namprd11.prod.outlook.com (2603:10b6:a03:4cb::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.17; Wed, 14 Aug
 2024 17:17:31 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7828.030; Wed, 14 Aug 2024
 17:17:31 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Topic: [PATCH 25/25] KVM: x86: Add CPUID bits missing from
 KVM_GET_SUPPORTED_CPUID
Thread-Index: AQHa7QnThnZIMHm/AkW0hgwbYo+0yrIlD2UAgAB4kACAARpjAIAAX0EA
Date: Wed, 14 Aug 2024 17:17:31 +0000
Message-ID: <cf85f4fbf1339ea998fa34e722d2bac9ebced05b.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-26-rick.p.edgecombe@intel.com>
	 <ZrtEvEh4UJ6ZbPq5@chao-email>
	 <a24f20625203465b54f20d1fc1456a779eee06a1.camel@intel.com>
	 <ZryWwC7qxWUGyLnp@chao-email>
In-Reply-To: <ZryWwC7qxWUGyLnp@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB7617:EE_
x-ms-office365-filtering-correlation-id: 143465cf-59e8-4b4f-785f-08dcbc84fb16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TjFjZVYwUXVtaHgwMnRvQS9XczJOOUZWY1hmWEhLdVpJd1J2Tmc0bWZmZ3Ri?=
 =?utf-8?B?TlBVZDFrME9nTlJRd1Blc1E4ZTV0bkwvdWtoM0NCUEZtT0FUcEVYVWZBTlFn?=
 =?utf-8?B?TzlnV0FxMFNmai9od0N6cFNHRld4eSs1VkYwVnE4WFBweUoxekZXV1gzWUFy?=
 =?utf-8?B?MkRGTFZGQ3licmxpNllyTWNCQmdlb05ORDM0VmNkNDYwNlB2QlhieFFKNHFn?=
 =?utf-8?B?RkMvckNjdUF3NHlOeitIK0xwakYvL0UreWtpNWxEL3FWM2JTMmlmYzAwRkg0?=
 =?utf-8?B?NU1ScElTL0w3a08xYUlhZ0d0WE9WV0xrTHpGdTNHK0EzTUNLQ2xuMkxJQUVq?=
 =?utf-8?B?cWZYNS9pVENIdnZEd01Gc25aeHd5YlVNNEh2Um1vZ0hZZGtwZzcyTGRvc2l1?=
 =?utf-8?B?TDZjdnFSQ3UxWkQ5cDJiQjNJSDlGOWhMR0c3RkxLdC9HODIwTXNZNFhpODJ2?=
 =?utf-8?B?c0lSRVYrekJsWHJOMUdvVldOZEdWZ3A5dCtVOVZOeVZLOGs5ZWd6RUowN2tp?=
 =?utf-8?B?MGNHZ2tBVVRFOWg0ZW5wWWJvaFdCZ3JlWnFBbVpPRzZtRHlCRm8wTERzL2o2?=
 =?utf-8?B?M2NtRFl3Wk5ZWm9sYzdURVpqRjhEQnBBYlUzN1htZ0Z0Z3VOeTVQL3VaRzAz?=
 =?utf-8?B?TWxlVUpKbGZtbnVIQjNnQjhvUHJKNW1VTkx5a1ZMeU0wY3ovUzRBMkVZUlRp?=
 =?utf-8?B?TU9pVzVjZEpOOGM0WE94Y21EcXRVeWlmZ1RKckk2VVEwenVKd2lxTEoxc2Nv?=
 =?utf-8?B?bjNxeThRMXVzQ0lnRGRsOTRSaWFYdkdEQkNkazhpNWtnMzhtRDNQU0s0ZnEv?=
 =?utf-8?B?Z054RU84MWFqdHNsLzAvc1NlZDdNdE5nTC9QcStaQU1mVWZoQjV1Mjh5Z1hm?=
 =?utf-8?B?V0taWWh2d2FjTmdsUWpzMVBVUXBWVk9hN2RqRU9BYmVxcjVLb3pqTzN2ckxl?=
 =?utf-8?B?R0Z3dHlVMjViVnJOZjZjajRCYlo5VmxVN2F3ODAwZHd3d2VEM084R2FiQ3Fy?=
 =?utf-8?B?Z2tSclI4Q0VLV2E5aVFvM2lJY1ZobFpZaFkxVnFCY0lxR21iQjNUNndGRWVu?=
 =?utf-8?B?QTdxRTdLeEUyaGQvUlZLWTdCSWJtMW1ablZBdkFuUVRsYXhhK0pxejFZMTdZ?=
 =?utf-8?B?YlVPT0pqSkwvVlcreVo2MW9EZG80WUxrY1ZqeElXcm5aQStocnlHZzBKbmFj?=
 =?utf-8?B?djVhMmYrSzRqbmpVRnhvNUV1MENvcHNqRG05b1MxMUhWVkw2bFpNaE5PYk85?=
 =?utf-8?B?VTBhTnlqczkwT2JGSk83c0kwRmpqUHN2VG1KQWIwMWpoVEVGeXRCNzZhRjBW?=
 =?utf-8?B?NXZObDJmTThnMHB2NGpHRmx3SkszZWtzUzBDTDBGS1JHOTExN3lMaVhYbThR?=
 =?utf-8?B?UWtQUHpyU0x2dUdFa0NCeVMwMzlCRzFUUmtwbFFjZkM1U2JOSmt6b1AwNTc5?=
 =?utf-8?B?VDNPcnc2eGxHOUkwRTlad1p6ZGNFUVFyUy94MDYzVWYxWDBoYlhXcU1mV2Nn?=
 =?utf-8?B?TGR1YVdYQ3RCR0VGUEF0K1l6UGpMTWp4R29jaG1IVFd4VitDN3l4ZnEzRWhr?=
 =?utf-8?B?SEw1cGZBYTJrV3JaWFRpdmNQNW15TnhFWWtPOE1OemtDYUs4bDIxT08xYTM3?=
 =?utf-8?B?SUdEbkUyWHRuVURxcmlZUDhJWlFwNTlnekFkWHVodTU5TENXQ0Q0NlI2TFhs?=
 =?utf-8?B?Skx3NXU4eFVMVEVRYVRyNmlVS0ViLzNaVC9oaGN2VHR0UHh3SzVHZHpVSnNV?=
 =?utf-8?B?MVBocUpWYlRYZ1pjZDdadGtzZkV0RE9TTml3REE5dWhLZ3FBOEFHNVZzN2tJ?=
 =?utf-8?B?eVdqbmhNK3ptSlZSYUhreHVqb0x6cWY1L1pCL3JlZU1CbXJMelQ0NkJHSDYr?=
 =?utf-8?B?NHhTc2pkazVYc0xxR1ZYUmI3SkhHRnF6bjY3ME1qMXlDeHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aUdVcnNqQ0lJMTcwQkY1TlZKZDVISzlLa2w0bE01R0JmK3pObnZvdFgrRCsr?=
 =?utf-8?B?WU9GRm5Zb3JmN0JacDhpR2dKWGdzZG1OVUdqNUg5QWJhSHZRSjMvelFJd1Nu?=
 =?utf-8?B?SFhCSVc0Y212TFFZWjJOcWxqbXJ5anZjWmVzUUVScytBeUFXT2c5VVEyUGYr?=
 =?utf-8?B?SkhEc0d0L1hlTGd4aGJ4S1FLSDdBeUpFNmFQMFNxVHhRV3lwcmw5dzQ2OFY2?=
 =?utf-8?B?eE9YR0JHdS9EaFhodFdwUjBUc0lTNnYxMk1vT29NWDFrUHFVNVhhbEFlK3Rp?=
 =?utf-8?B?bnZhYi9ib3NSTThieXFoVCtIMGkySHpUUGgzMFpQajZuNDNoa2RBdGd0S0g4?=
 =?utf-8?B?a21TR0YyRWs1ZHprclFzV3JQZG9jSGlZNEVIUjB2YURtRUNSSXZ5QVpXWGFF?=
 =?utf-8?B?OWdVNVM4d2NqUndTd1lIdHYxQjhjNGt3bUlVVGYvYU42SnM2UytwMlUza0ZT?=
 =?utf-8?B?STZ1VVlrNDNBQi9iN0I2cFpIZVhSNlNlaGMvU3JQcUo2WnRKcjNhdmxJdnVH?=
 =?utf-8?B?NXFWUjJJRmRLaFpPVmhzSS9vRlVFZ2dGWm9WM3lnMitINy96WmhwUGtRY3Fx?=
 =?utf-8?B?aUpKVGN2R2dlZjRIR1M5anFTaW9GMU9CZitwR1NZTHF6emsrd2tiNERNS1Vp?=
 =?utf-8?B?dVZSWjhFZ2t0UFUxKzZRVkFOSUhJQlN3d1UyVTJNSXpoSHNiaFdoK0gxR20w?=
 =?utf-8?B?bTFaZWcwT2dRTUF5VUlHamxZbGlyS1Z1SU1naFlibkErZStSeVNva1VVKzUv?=
 =?utf-8?B?QTI0YkVwYjltWXBReW9sRkc0a253SE9kNTBuZnFubklFRllneldRNjIvOW9Y?=
 =?utf-8?B?QUp3QVUxM3BqaCtyMmNmOTBDd0RWdDRvV0lFdGlZZjFwK1M1eXhkUzVCeFVO?=
 =?utf-8?B?aUNzRmdxT3JuZ2dMMDZseXB3KzJQRmxMOWFmbzVwK09qTEdXSnRhV3lRUzVN?=
 =?utf-8?B?cWdhWnZtMEVtODJBZmFUdXZuMm9ITkxFYngvYXdweDUxdWthN2JmZ0YwRnlT?=
 =?utf-8?B?WFkvei94clM3VUZJQ2FTdW5HV0tiN1BFT2F3SGRpK3N6N3hTQ0twNE1TK3Bh?=
 =?utf-8?B?eVRPcjdzMEs5QmVTWFlacmRQa3hVK0tLM3JPTGIyZHdFNTIvKytTNXJzQjFD?=
 =?utf-8?B?THJ3OCtxajZOaWxNZFVldzBUU2h4cThiMzVGUjUraEMwdVZUTWUyWjFWUExx?=
 =?utf-8?B?RWF5bFVlNVZpb1p1TkFkcUFwNGxmdVJnMUt2ZnBjRURsWnNKNEw4M013RGRG?=
 =?utf-8?B?S25nKzRmNkVNRUk4M1RKL0ozS2ZIT2libnZmTWFOWFRLK2FhTEdLZkhiZ1lS?=
 =?utf-8?B?T1RpS29sdDVjZG9SdjFmQnJLMC9KcnExcHdPNnluc0pLbUV0Y2NxL0NwSzcx?=
 =?utf-8?B?MHNaTGJ0QTZKSkZDbGtaYllPL1Q0Wis1eHEycXhDaTUzU2lCK1FEQzRnM0d1?=
 =?utf-8?B?NTYzcklKR0VWdHhFc0c2b0QxYkZ0cWFUTkg5TlF5SjlBQkgwWlBuTlo0amR0?=
 =?utf-8?B?VXZsS3IzREV0QVdJZ1RpcENGM2dTZDZ3T3ZDRzhKeFg1enhDckZSL0RWbXVq?=
 =?utf-8?B?ZklLWW0xcjMrSGx0U2dJaVFRUS9kWUxnVVg5TmZFaEZJbTcrSHZzeThhV3RX?=
 =?utf-8?B?Uko3Y2U2R3FPcStIMVlzWGhsdjdoME1QRXZQU1h6NkJuZ2lMZ0RzWFExM2Jx?=
 =?utf-8?B?NGtOTFpkaVBscXJOTzRPTnJIL3RuTkxGam00MUlnTjY4cDVyTDVuVjNsaVdN?=
 =?utf-8?B?cys5WjF2T3NzdENxYjhEeGZhUXEwT3h6SitVcTNoV0lLc3ZEL2g5Z0VnQkdh?=
 =?utf-8?B?UHFTenFQei9uVEt6aStzUHNtY0tBTG4xU0NmSDJ3ZlkybnZFOVR0TTRIZ1pk?=
 =?utf-8?B?aEpKMjFxdG5pT1MyQ09aS3JMQXBKR0FsMkcySTlQa1dqUzhKczh6amJMYlhO?=
 =?utf-8?B?eUNTaWNhWDIzUGZPMlFZNDY3NTI5U3R6ZE51aU9DMHg0VVNrUFFRWmJLVUFJ?=
 =?utf-8?B?Y1FhdWMyRy85YmNjelFRRWpJL3RSdFVicXNvMkppK1hIb2U0SmRhMkRUUVZT?=
 =?utf-8?B?WDZtVGtXQk5OWXdDdUdYV1NrbmpGQ1p0dUk2VGFJalZidVU3MDNHVlV0dUVG?=
 =?utf-8?B?cldnMlpOWGRJY3lNM2ZTWEl4eW15ajA5cFlpRDFFU241ekpRandZa3ovY0VR?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC41A3E9507B4743B16E2BFB5A1CD923@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143465cf-59e8-4b4f-785f-08dcbc84fb16
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2024 17:17:31.3446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbz3po7HtqU5OYdzL5BNdly6qGE66BK1OUUuYTDRH36RGZdKWHOLMnwTGRsUZTYZEmFBaGQKjMxLRoQEbZ/il+zuwgh5AJQTL+AL8Fuo/5E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7617
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA4LTE0IGF0IDE5OjM2ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiBJ
IHRoaW5rIHRoZXJlIGFyZSBtb3JlIGNvbmNlcm5zIHRoYW4ganVzdCBURFggbW9kdWxlIGJyZWFr
aW5nIEtWTS4gKG15IDINCj4gPiBjZW50cw0KPiA+IHdvdWxkIGJlIHRoYXQgaXQgc2hvdWxkIGp1
c3QgYmUgY29uc2lkZXJlZCBhIFREWCBtb2R1bGUgYnVnKSBCdXQgS1ZNIHNob3VsZA0KPiA+IGFs
c28NCj4gPiB3YW50IHRvIGF2b2lkIGdldHRpbmcgYm94ZWQgaW50byBzb21lIEFCSS4gRm9yIGV4
YW1wbGUgYSBhIG5ldyB1c2Vyc3BhY2UNCj4gPiBkZXZlbG9wZWQgYWdhaW5zdCBhIG5ldyBURFgg
bW9kdWxlLCBidXQgb2xkIEtWTSBjb3VsZCBzdGFydCB1c2luZyBzb21lIG5ldw0KPiA+IGZlYXR1
cmUgdGhhdCBLVk0gd291bGQgd2FudCB0byBoYW5kbGUgZGlmZmVyZW50bHkuIEFzIHlvdSBwb2lu
dCBvdXQgS1ZNDQo+ID4gaW1wbGVtZW50YXRpb24gY291bGQgaGFwcGVuIGxhdGVyLCBhdCB3aGlj
aCBwb2ludCB1c2Vyc3BhY2UgY291bGQgYWxyZWFkeQ0KPiA+IGV4cGVjdA0KPiA+IGEgY2VydGFp
biBiZWhhdmlvci4gVGhlbiBLVk0gd291bGQgaGF2ZSB0byBoYXZlIHNvbWUgb3RoZXIgb3B0IGlu
IGZvciBpdCdzDQo+ID4gcHJlZmVycmVkIGJlaGF2aW9yLg0KPiANCj4gSSBkb24ndCBmdWxseSB1
bmRlcnN0YW5kICJnZXR0aW5nIGJveGVkIGludG8gc29tZSBBQkkiLiBCdXQgZmlsdGVyaW5nIG91
dA0KPiB1bnN1cHBvcnRlZCBiaXRzIGNvdWxkIGFsc28gY2F1c2UgQUJJIGJyZWFrYWdlIGlmIHRo
b3NlIGJpdHMgbGF0ZXIgYmVjb21lDQo+IHN1cHBvcnRlZCBhbmQgYXJlIG5vIGxvbmdlciBmaWx0
ZXJlZCwgYnV0IHVzZXJzcGFjZSBtYXkgc3RpbGwgZXhwZWN0IHRoZW0gdG8NCj4gYmUNCj4gY2xl
YXJlZC4NCg0KSG1tLCBhbnkgY2hhbmdlIHRvIHRoZSBrZXJuZWwgY291bGQgY2F1c2UgYSBiYWNr
d2FyZHMgY29tcGF0aWJpbGl0eSBpc3N1ZS4gQnV0DQppZiBLVk0gZG9lc24ndCBzdXBwb3J0IHRo
ZSBiaXQsIEkgd291bGQgaG9wZSB1c2Vyc3BhY2Ugd291bGRuJ3QgaGF2ZSBkZXZlbG9wZWQNCnNv
bWUgcHJvYmxlbWF0aWMgYmVoYXZpb3IgYXJvdW5kIGl0IGFscmVhZHkuDQoNCkkgZ3Vlc3MgdGhl
IHByb2JsZW0gd291bGQgYmUgaWYsIGFzIGlzIGN1cnJlbnRseSBpbXBsZW1lbnRlZCBpbiB0aGUg
UUVNVQ0KcGF0Y2hlcywgdXNlcnNwYWNlIGNoZWNrcyBmb3IgdW5leHBlY3RlZCBiaXRzIGFuZCBl
cnJvcnMgb3V0LiBUaGlzIHdvdWxkIGZhaWwNCnNpbWlsYXJseSBpZiB0aGUgYml0cyB3ZXJlIG5v
dCBmaWx0ZXJlZCBieSBLVk0gYW5kIFREWCBtb2R1bGUgd2FzIHVwZGF0ZWQgdG8gYQ0KdmVyc2lv
biB3aXRoIG5ldyBmaXhlZCBiaXRzLCBzbyBpdCBraW5kIG9mIGxlYWRzIHlvdSBkb3duIHRoZSBy
b2FkIHRvICJmaXhlZA0KYml0cyBhcmUgYSBwcm9ibGVtIiwgZG9lc24ndCBpdD8NCg0KPiANCj4g
SXQgc2VlbXMgdGhhdCBLVk0gd291bGQgaGF2ZSB0byByZWZ1c2UgdG8gd29yayB3aXRoIHRoZSBU
RFggbW9kdWxlIGlmIGl0DQo+IGRldGVjdHMgc29tZSBmaXhlZC0xL25hdGl2ZSBiaXRzIGFyZSB1
bnN1cHBvcnRlZC91bmtub3duLg0KDQpJIGRvbid0IHRoaW5rIHRoZXJlIGlzIHJlYWxseSBhIHdh
eSB0byBkZXRlY3QgdGhpcywgd2l0aG91dCBlbmNvZGluZyBhIGJ1bmNoIG9mDQpDUFVJRCBydWxl
cyBpbnRvIEtWTS4NCg0KPiANCj4gQnV0IGlmIHdlIGRvIHRoYXQsIElJVUMsIGRpc2FibGluZyBj
ZXJ0YWluIGZlYXR1cmVzIHVzaW5nIHRoZSAiY2xlYXJjcHVpZD0iDQo+IGtlcm5lbCBjbWRsaW5l
IG9uIHRoZSBob3N0IG1heSBjYXVzZSBLVk0gdG8gYmUgaW5jb21wYXRpYmxlIHdpdGggdGhlIFRE
WA0KPiBtb2R1bGUuIEFueXdheSwgdGhpcyBpcyBwcm9iYWJseSBhIG1pbm9yIGlzc3VlLg0KDQpU
cnVlLCBJIHdvdWxkIHRoaW5rIHRoYXQgd291bGQgYmUgb3V0IG9mIHNjb3BlIGZvciBiYWNrd2Fy
ZHMgY29tcGF0aWJpbGl0eQ0KdGhvdWdoLg0K

