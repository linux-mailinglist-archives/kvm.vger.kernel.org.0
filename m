Return-Path: <kvm+bounces-19387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E626190489D
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:55:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 885DF285537
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:55:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F5BAD35;
	Wed, 12 Jun 2024 01:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C/w+HSjV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DDD5CAC;
	Wed, 12 Jun 2024 01:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157312; cv=fail; b=utFWZZWaNdhVLLbN7/j5/By1pTIPOvcrtyt9PK4KheyZ7blPIM7kThfKwpVqkkj1H8TgbPwVcV7j7NDV1i3SOcyzNpSYjkEjB/6k1DIkHcWg7OqZEIBkhVEVWdamlsbj09GKK2ZEuUAwrn9krWESWNpIxnpsP6hG3PEzZFWlWdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157312; c=relaxed/simple;
	bh=gT36cz0UIrKU6Ilkt1/Mlc815Tdgklqs01eSfNNAjlg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AzUkvEtlWAD7q6M73HqdvCGdXdC77iM5RGSdpQS/EgqsAGlRs10YHc72K2e/MxdfENlKEB7P/jWpA1jcm2SDEHeXvymxPJU29lhYSMm2MuHqkuuJU+66EVlOfcT63Cw9qIjUzMA9agOscNsALYlEtIvW/XD7dBtr5W5N5b10Jvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C/w+HSjV; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718157311; x=1749693311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gT36cz0UIrKU6Ilkt1/Mlc815Tdgklqs01eSfNNAjlg=;
  b=C/w+HSjVFckL3Gc5VmNqLc04Wg4uroLwGVXsjTtDwi2bc/Dw91us5otN
   ylbvR/vpc3HwSXLrPXdwF0C2OPPQ/t4McWI0e2qbj7uQJPb3Wmjv3soDO
   9FvQe4z0bCgP4MBHDJMSk9NFnrYvWTeI330fEodEALNvAkVl4kZMdobOx
   jK7gTr/SeNOx6cgCqlr/ynus5ey9AQH+8ZIIRRyT4xw6+koB22GJlPjkF
   MS6K7PNlFD3pfGywmTh/T3DavD533pAsMSZmiuA6dnv6n5MmPUcKVRwk3
   KtVUwFUdWh8FyirwomViSsqdnVWgAoLrWpiLNpNrzZjQucHSh38ENHkj/
   A==;
X-CSE-ConnectionGUID: nq398AluQEWm3045Eq0XBA==
X-CSE-MsgGUID: /0puhdpQTUa4ntCfVgeyKg==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="26309651"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="26309651"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 18:55:09 -0700
X-CSE-ConnectionGUID: D9H/0EarRVqh1+94gAaUnA==
X-CSE-MsgGUID: xu58HvxdRKuVAl64S1Z0tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="39742771"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 18:55:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 18:55:08 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 18:55:08 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 18:55:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fXXfsaHobojVPdmdna+ElhSTz9ZP+L61p7OrLIIGBoi3fsS+QbptrPJyrzUjniuCFG6Pqdw5jEWj9IGRRCeOuhFh7ABZIojzpdy72ILTfsY02XqZeW/wrRzUNSNLtp1EoqyXjt5V8kOb0VZNkw+Oy42SrmggJ+CyrUKOgk76x+hLG6bfuaJ8enp8vXCx44TtfBCUWskKzHJzNWbITLSDNY6TZ+05vy8qgcRRPPU+isrXiNtju5u1QcdVejEZBSTud3PZm4M0xE588FbkED+/H2uSLxLknuDlZFgOPDOzoyZZMWrKGoZWOY30rhBbHc9T6w0O/TiFdtN/dRIXDwR7nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gT36cz0UIrKU6Ilkt1/Mlc815Tdgklqs01eSfNNAjlg=;
 b=Yh0tpBz0Jmb/um6tm3bWDWHa9hklKk398jhiNOs/MClE355OePLHJtLBAwgX4ttBfsLcEdVhF1H0KqUvZIEeQuaxKX6ii+kPQBRSNaCCVKCLUQZmW5Mbn37TXS26wPn+V9zU2y+zoBfQ7ay3iAOGFnMS9twLxDarM0H9PHYd5Zf0qZvstkD7+BRHPG8H6w2P5D/D3E9Z72v05eMxEhTzlmuTcC+dAMIpSFwV6f/ltLvsqMkzplexJRWTrJniNUK1iAOFiqZWpjLngHgzrOpWlsC2Gijuuqjrbmks6gxWtQ+IH9oEOXHiRO161l/miZWTXAkfzUvn8oEyIguMp4ZiQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 PH7PR11MB7662.namprd11.prod.outlook.com (2603:10b6:510:27d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 01:55:05 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%4]) with mapi id 15.20.7633.037; Wed, 12 Jun 2024
 01:55:05 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 0/3] KVM/x86: Enhancements to static calls
Thread-Topic: [PATCH v4 0/3] KVM/x86: Enhancements to static calls
Thread-Index: AQHaoILaOye8JSmZYkO/dg/slvYW77HDi+sAgAAHcvA=
Date: Wed, 12 Jun 2024 01:55:05 +0000
Message-ID: <DS0PR11MB63730E881D94883638D0B219DCC02@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240507133103.15052-1-wei.w.wang@intel.com>
 <171805499012.3417292.16148545321570928307.b4-ty@google.com>
In-Reply-To: <171805499012.3417292.16148545321570928307.b4-ty@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|PH7PR11MB7662:EE_
x-ms-office365-filtering-correlation-id: 6769741d-e61d-4269-4e4b-08dc8a82ae65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230032|376006|366008|1800799016|38070700010;
x-microsoft-antispam-message-info: =?utf-8?B?VE5VcDZUVjBINXFqbWVrU0tLSjJEajJsejcxSi9GVE1HNEU5TVc4VEpDNHRt?=
 =?utf-8?B?cEtDa2N3ZHJ2bWhUeitYZ3pQZHY0SUtvZDBlUVpxcFRwY3V5ZVExSWw0Zysz?=
 =?utf-8?B?NFhjQkROcEtxT3lvUVVDMWYyWFFOaHdSZWNVcGVlQUw3b0RwZlhEQVpMUVNK?=
 =?utf-8?B?b1p2T2oxMnZONnh3UThKSkZ6UjVpZUxUZXNoOVNaaFdZZGFJWXVFOGRHdmNO?=
 =?utf-8?B?Y2w1bFpyY21wQ3VCYi9pSUdEN2F1VXBld1A4YWlyckxOTXpVcTJtSTRpbk4x?=
 =?utf-8?B?bTY3YWJxbzBNQ3A3WkhYYytCMXNzODhLT3k5T3RhWHp0b2VHRUUrWkd3bmNy?=
 =?utf-8?B?RlQ0eWxreVBHWUM3a2U4T2ZPeFFFeDhMd2FBS3gvUUFpaWxBaXFzYmdtUmsw?=
 =?utf-8?B?cmZIanR1ejFpdDFzd0F0RTdETGlySG5jN25mM0xTMVc0VEJLR1ppS2FYVDVj?=
 =?utf-8?B?YWx5Y0VXRytDWlRtVnZBZmtSU25zeFVGTndXcXMwY1FqY2c1VUdSU245ZzZz?=
 =?utf-8?B?em1RL2FPZjQ0dDF3M2xpYXkzcWcyQ2I3ek1JdzBZRUdKc2FqcGdDdHpOK3RI?=
 =?utf-8?B?YjVaaGhEbDBQNG5QektqeUppUXdMazFURk5GdjhndGJxZk9jY3hCcGpBZmxU?=
 =?utf-8?B?Y0htdmxIcE12TFpUUWdTNHdZcy81SlNrOUloOHMyNWw4SUMvdFhOTDJlN0Fp?=
 =?utf-8?B?UnU2ZkIxVU5TVFpVWm5MM01hdk0xWHIzTHgvWVFwWTdxSWhPdkZZekhSRUky?=
 =?utf-8?B?VGdVMWF2c2hLUWl1UzhhVk1EYndvSUxpaVh6cTBEbnVmVHpkcHlaSElnczhZ?=
 =?utf-8?B?NldlMDBVUE4raGYxWkloRXAzdDhnR1M5UHd0d1lDeEZBelRNZmVhQ2grVE9E?=
 =?utf-8?B?U0x5Y2xZeWp3ZllldFViUEtvSFdKZmZhdHcvMWRVTEIzazJYSVVLNVNESzhu?=
 =?utf-8?B?Um83MXlPNFlWdldjLzBBT2xNVVpHVHhnVmtlMEhpMFFpWFNBOGhMMjd6SXB3?=
 =?utf-8?B?NzNucTU3aHQ5K3VjNUd1N2RGUHpKUmltbk1NbGxMVm1xbGR0MGV2emtYcUNt?=
 =?utf-8?B?ellnem9kYkxnVGlGQzgrTWUvSllnanRTSHdoVWxoeTVkSysyWUVaQ0RuVEQx?=
 =?utf-8?B?VWJUTHg4UlBMbDFTOTl2ODBoZlVma2Y4QldOMXBMOEVKeHVCY1pSdEQzWlhx?=
 =?utf-8?B?aTRETUd3V1FLUkI2RUVubnVpY3cweTU3T0Q2MWhkV3RWY0tOc2lmZ2pSelJs?=
 =?utf-8?B?aDBQZkQ1L2E1M3grK254ZjEyb3FNWmVtZ29mbUxoRXh2cHZwd3NDS25Dc0JR?=
 =?utf-8?B?UzRzUkxES3hnMG1ES2pMZm5aL0VRNndCZzJUQkJIcE5KYkp4UkFPOFcwWEJ2?=
 =?utf-8?B?RnNYSjZXblhPVVhLR3NvUjhFY240YzFhUHN1eWkwMnR6ejFNRkZzdmZSNlcw?=
 =?utf-8?B?WW5MRXMyZUZOemdSczFjTTZ4MmEvR291NmRRdXd0M1c3YlhWZ1R5VmI0TFNw?=
 =?utf-8?B?am9Ec3JPTTh1YWVGejU2N3FjaFA1NkdRejBvQ3hEbnZ1aEtORVV1Y3V2MStF?=
 =?utf-8?B?MzFIT3BDRXIwNVZ1SWxxam9XQm5KUUhqL1RZSHZqRmlSNUo1QXBpSlVtZS9D?=
 =?utf-8?B?ckJJaWlQSmwxZWF4RElRKzR5M0NjcUpMaERxeGE3dDdJbmRzNEFpOUs0cXE3?=
 =?utf-8?B?bFJyZEcraXFwbXBTWmsyUjJwQmllY3lXZjZobERabDRzMEhNQ1liU2x3WVNr?=
 =?utf-8?B?a2pPQ0hHWjM0NmdvWklSeGloNDYrbHVaUkdUSVdoSUdsOGxBMmJRdVpYMWpl?=
 =?utf-8?Q?0Ap2L11EjAYeqyglvSmkTLPwlsie3N+I0f9vM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(366008)(1800799016)(38070700010);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnMvaGs5RXJBY2VNSURTeEpuekZPMUNDejVXUE8vOHVHWkN2d3g1WnYrbExO?=
 =?utf-8?B?cUxQOGh2WlB6UUNTT05nRWQ4YmlENmU3ZHE5U1FUbnZlbHZ5MEVvZFlEYUox?=
 =?utf-8?B?V0tqUm9NSFRmVVE4aStXQ1FJd3M0TVJzWHkxQ0RBYzJrNkZKcFJraTR2aGhZ?=
 =?utf-8?B?b3FvMm9rUWtJOGgwdW9YYTNMd1J5S2lMQW51STcvTnNtMmpDMnBYN0RjMHo1?=
 =?utf-8?B?TUZSS052OTFOcXFDMVY0WnI0SzFQdkRaRU1zSEQzSmZtekdBaVZSNU81NUtx?=
 =?utf-8?B?QlE5OWR0d2svTTZnaW1OSVorUUtkc0hwSzJ5Yy9NWklETUVSemJuQnhZdWVx?=
 =?utf-8?B?TzIyL3lMR2R0YU5kNjA4OEZ0dnRIaDdpS2M1UnY4eW9LTzQvM3pNZ2FBSjEr?=
 =?utf-8?B?Vks5U1doWDJKUGJlNUhIckErKzZ0YkQxcFJJN0dSbENJcE5jVVdoS21lOW16?=
 =?utf-8?B?UlQ2ZEZVYkI4YTF5SXZoOFJxcGQxM2xrTW9TTG9NeUZNUDhHWlFGS0t3SHQ0?=
 =?utf-8?B?N1dZT0Y4Yi9KbnJGSXN0c2UrMjltOFJvb1pMZUZhREtQclR2SUhmQTN3TEJr?=
 =?utf-8?B?UURRVUZ4S3JZR3ZFWGYwZXR6ZGFvQVVzWWkwUi9RV0MwTit1aHR2UjNiQytq?=
 =?utf-8?B?RmFvZGNVNFJ3RmkzbFhvVTVDNUo0NFFlOWVmbE5MaXpaSjJBeVJobkkrV3py?=
 =?utf-8?B?d1A1V1RrTG15OXpJYXhnOE9mMG8rVXRNcHVJdGt0endhcnQ2VjhzUmlaUVhF?=
 =?utf-8?B?VkViSENhZGZnZnBTY3ZzNFVnY3hWQmdRQkI2bS9HUTF0RHZvSE9lY0lkZUNO?=
 =?utf-8?B?c1pxL0pXUkxyQnEvWmRJcU9aakVVQlR5d3ZuZlFvZUdoYWNuT3BDWGFtMHp1?=
 =?utf-8?B?RHU1UW9lUUN6N3RlYnVvZnBjaHJJQXl1YWxqOXgzNi82SjhCN2dyZWhSK3Nj?=
 =?utf-8?B?Q1Mxb0hzcStHYlF1RXZCamFNK0htRUtEVlNaQVQ0bGN4cmVZSVFET1ZJRExh?=
 =?utf-8?B?dTNKamxuczAzNitXNXdUbVBPNHJoWHQvN2RKb2FXZWZEanRPamhqakZ5ZlND?=
 =?utf-8?B?dTNqMklocElrQWk1Q2h0U3AwUy9ZS0g1d01KdUt1UVdnY2o3VGpYakZBTEhU?=
 =?utf-8?B?a1R2amFZdjczbWg5N1g0UzJoNTBlYWcrbDZ3bEJzOHF5NzFzZ0xEeDhjTmd4?=
 =?utf-8?B?TFZWczFRRlR0L3F4Q0szN2hsSzdSQzNUTnBVd2xhOEU2MGxrNjZhQkl4SVNX?=
 =?utf-8?B?emcycUJBdVBBVzNzK3NNTUM4MGZjVWRndWwvMEdySnp1K2xxaThvb0x0SUV3?=
 =?utf-8?B?N0JHTzJlVzZTaFh3T29JMDFkL1o0MDJYc2ZWazZTUHVwcGdLTEV3OEk1M1Zt?=
 =?utf-8?B?OEE4dXdKeURuamtRWGtuUUloZm1FMG1yR3NIWEdkU2I0K3hDdDRoNUdlbDNC?=
 =?utf-8?B?SURXMWo2S0hObXY1d0Mvd2FBTWVLT1Z6MkZocXpZYlYvM1d4R1lOYk1GVFh0?=
 =?utf-8?B?Yms4MGVqNmg4N1J5RHhMQVVxSXRVYWdlcmpaMUQrb21YaTVETFpzVGVnOWRC?=
 =?utf-8?B?QVZvZmU4aDhXLzYrQmIwbWx3RzBBRmxhS0x5a0s2ZWlmeGtlQnc5eWpNWkhv?=
 =?utf-8?B?R1dld1V4dHpabWVsT1YxMCtnc2lldTJmWHpTbTB6WnZkYnNLUmsvbHUrTGJs?=
 =?utf-8?B?T3BsTzl4dWRTTU9wS21ya0RJSVUwck1sYUh4TkNPRnJvQzF1Um51ZkhvV0hB?=
 =?utf-8?B?MElBcUhJby9jSVZYeEVEbVhQRVBIU3EycGhRZVhzQXViaHF2SlhuOWhwS1hp?=
 =?utf-8?B?ellPV0hUVjgvL1hWWUVSWDEyRUN2VENmVkFqM2t6N2U2ZGNSQjd0YzJRRHhG?=
 =?utf-8?B?MTdDaWJ0clFWV3VGbzkrQm1VZEFTcUxacTArNEY1WFE3RzdidXBVbnZIRVUz?=
 =?utf-8?B?b0FVU2FQU2ZNeDlHRUlxa2g0NDJuYkxJN1ZPbDErVlY4V0o1YUdFTURHYmJj?=
 =?utf-8?B?M1Q5clBGUjV4bXYvZ3J0NTR0RmNxTGhIQU9GbUpvcnBjVlVoOEgxckpoOXd3?=
 =?utf-8?B?MWRCZEJ1K0lLaWpLbklFdDBXLzZ1YjJ4dVJjRkNFZVRaQW16VVBsU09lcWNk?=
 =?utf-8?Q?c+VDG038D/MJHJ1BKL84s2RU5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6769741d-e61d-4269-4e4b-08dc8a82ae65
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2024 01:55:05.5492
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CDVUjcopHCKrrb3K/biSFrYRK0oOgsf600728yyfJaLUtUZm0Uiq6B/5MDRBgpVN17MNDFiaqWQ0JLSGb87pOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7662
X-OriginatorOrg: intel.com

T24gV2VkbmVzZGF5LCBKdW5lIDEyLCAyMDI0IDk6MTkgQU0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+IE9uIFR1ZSwgMDcgTWF5IDIwMjQgMjE6MzE6MDAgKzA4MDAsIFdlaSBXYW5nIHdy
b3RlOg0KPiA+IFRoaXMgcGF0Y2hzZXQgaW50cm9kdWNlcyB0aGUga3ZtX3g4Nl9jYWxsKCkgYW5k
IGt2bV9wbXVfY2FsbCgpIG1hY3Jvcw0KPiA+IHRvIHN0cmVhbWxpbmUgdGhlIHVzYWdlIG9mIHN0
YXRpYyBjYWxscyBvZiBrdm1feDg2X29wcyBhbmQNCj4gPiBrdm1fcG11X29wcy4gVGhlIGN1cnJl
bnQgc3RhdGljX2NhbGwoKSB1c2FnZSBpcyBhIGJpdCB2ZXJib3NlIGFuZCBjYW4NCj4gPiBsZWFk
IHRvIGNvZGUgYWxpZ25tZW50IGNoYWxsZW5nZXMsIGFuZCB0aGUgYWRkaXRpb24gb2Yga3ZtX3g4
Nl8gcHJlZml4DQo+ID4gdG8gaG9va3MgYXQgdGhlDQo+ID4gc3RhdGljX2NhbGwoKSBzaXRlcyBo
aW5kZXJzIGNvZGUgcmVhZGFiaWxpdHkgYW5kIG5hdmlnYXRpb24uIFRoZSB1c2UNCj4gPiBvZg0K
PiA+IHN0YXRpY19jYWxsX2NvbmQoKSBpcyBlc3NlbnRpYWxseSB0aGUgc2FtZSBhcyBzdGF0aWNf
Y2FsbCgpIG9uIHg4Niwgc28NCj4gPiBpdCBpcyByZXBsYWNlZCBieSBzdGF0aWNfY2FsbCgpIHRv
IHNpbXBsaWZ5IHRoZSBjb2RlLiBUaGUgY2hhbmdlcyBoYXZlDQo+ID4gZ29uZSB0aHJvdWdoIG15
IHRlc3RzIChndWVzdCBsYXVuY2gsIGEgZmV3IHZQTVUgdGVzdHMsIGxpdmUgbWlncmF0aW9uDQo+
ID4gdGVzdHMpIHdpdGhvdXQgYW4gaXNzdWUuDQo+ID4NCj4gPiBbLi4uXQ0KPiANCj4gQXBwbGll
ZCB0byBrdm0teDg2IHN0YXRpY19jYWxscy4gIEkgbWF5IG9yIG1heSBub3QgcmViYXNlIHRoZXNl
IGNvbW1pdHMNCj4gZGVwZW5kaW5nIG9uIHdoYXQgYWxsIGdldHMgcXVldWVkIGZvciA2LjEwLiAg
VGhlcmUgYXJlIGFscmVhZHkgdGhyZWUgY29uZmxpY3RzDQo+IHRoYXQgSSBrbm93IG9mLCBidXQg
dGhleSBhcmVuJ3QgX3RoYXRfIGFubm95aW5nLiAgWWV0LiAgOi0pDQo+IA0KDQpPSywgdGhhbmtz
LiBKdXN0IGxldCBtZSBrbm93IHdoZW5ldmVyIHlvdSBuZWVkIGhlbHAgd2l0aCByZWJhc2luZy4N
Cg==

