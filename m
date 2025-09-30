Return-Path: <kvm+bounces-59217-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 49E82BAE480
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 20:11:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 62E7B7AB07A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 18:09:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8DAA1E0DFE;
	Tue, 30 Sep 2025 18:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QTKvSJxq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B881A9FAF;
	Tue, 30 Sep 2025 18:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759255891; cv=fail; b=UepSGHnJDTyDJBAH9eAS6CoSJowQHfrCJt4DYHgfxnKmuH18JNlYDuCeaC38jqpsfF7Kvovk8F2yx6yeGYZdibl8N4UgO3zPGD+MqQUgAUL9muG/hlJufyvsTN/X7XOsV6oIdKswvMWBzij1KdGUc9+68qeUybuqBTtOU+x7o0U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759255891; c=relaxed/simple;
	bh=Zdn95EiaR6l1Bl3Qst93xMl74IpH6KqfApHROrr5Wx8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bZ07Aamuv5Lpjv//3eaePcZkiV6vGxpbE8fPUnFVEc1YkTKTMLNkALA0DZkP/G8zElq5vM7ANKBXkpik0YI/lE3LN95TbaYF5S9RoF3ULTkD2t7t8BVJJcfT9pGlcAa+nGHo/9CSt6JN2HRYjiRVWF7mIWBCOzxAsNBp7yuQXTs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QTKvSJxq; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759255889; x=1790791889;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Zdn95EiaR6l1Bl3Qst93xMl74IpH6KqfApHROrr5Wx8=;
  b=QTKvSJxqUPBPnFqCBkKAyRn9B+4TpO90pK7dUjUVp2L/EkVlB52eF1vH
   YywGWSq/JLPkZXP/tvvfTGCvetUIdj8jzgx8mrKH798mTFA46ZaJ1Mrfp
   uNtgWPLqpgnrpd07DMX43FbRe2pHSbMTWti8NIeoAHkQly5SjRMdr8X8L
   T+JTZijRxPGne3ZHvR9fc5H/THp+Rxm4qgA854CopdTle4BXR3QBWPmyt
   Gcw79O4Ch8ywFnP4KgXTqcjRZysKPy0iQEQDNa6Wib0FY5ykUXRgxYleT
   iO6wMRPOIRzoF20KBWvp2dY7nEN79g0DV16x1XhHP1xIaIDSOl1QuX1GV
   w==;
X-CSE-ConnectionGUID: AhsWBtnoQJ6c2adQbxe/bA==
X-CSE-MsgGUID: rp53Oxm2QTmLW9lrXQQV2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65342924"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65342924"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 11:11:20 -0700
X-CSE-ConnectionGUID: LNWXyN+tT96JZFDjtiDdWQ==
X-CSE-MsgGUID: mgLlA47ERHa3ajU/Ho9I8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="178540226"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 11:11:19 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 11:11:18 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 11:11:18 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.13) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 11:11:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dXxv5DWbJKZy9nGm0Evt5GXesRRBx6pKfaOf1mZCj2vzVCGr3CP5eIY051y3iiWt704RDR2Y7S2zmJg1CW9T3x4rOZ6hp+dFlsu7CusAaaO6LoLAvco+VKrmBMEkYGN2aaprPU994TkhyY82NsGwrkZKP0xwhK+c1BhY2Hl/J5Lpty8Dn6/LVZR1xqUSwXJNHpVcCK9lecXHpxwDKwH2Cwb4ApzFKPpxXPLb8/2jQOwDoD3GgoZW16T/M5BrlI4jEILCBCOSkYyLrz5cZcsYHMVW90AGS2T+OR8C2l/QNcKh1ca6EM990SbNv6shsKqxOIo0ypefQutdG5M1nE6//A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zdn95EiaR6l1Bl3Qst93xMl74IpH6KqfApHROrr5Wx8=;
 b=eJiDZiiFBZiwGICDpnfWhYPYNrLWbn8t9B+yjcXx6sfOttbQAleiScHi+kIVm+JR36piX4zJZu5NWzKOqVG5NLTThHzQcIqj944TPNSN6Kc62SaUHtm+Ue9E135wg6sv3S6TbD2RGDUjfEXnH27qFlS30AxsPGD1n6tGEuPMWeaNs/Y3NaHimb1KoWj1r/39QMlPBrk0/N4deLvRnIfP37GHRpUHxO5kqgCGRP3xwSzpaaOe9VfH8Bf5KEXH9d1JdmNt7Gig0oqmk9VSlhM5cZ6jhKSCbPOxsAsRlqKjcNgFaJR5qexTEpOi7zZwK6Fa6Y2NknwdauAsAZmkYuhnZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA0PR11MB4544.namprd11.prod.outlook.com (2603:10b6:806:92::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.18; Tue, 30 Sep
 2025 18:11:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 18:11:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kas@kernel.org" <kas@kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 13/16] KVM: TDX: Handle PAMT allocation in fault path
Thread-Topic: [PATCH v3 13/16] KVM: TDX: Handle PAMT allocation in fault path
Thread-Index: AQHcKPM46A/2quvel0yXT7GYoUCY5bSq+8MAgAEdjIA=
Date: Tue, 30 Sep 2025 18:11:14 +0000
Message-ID: <328822c580d57d79403513f38a83c50649159ec4.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-14-rick.p.edgecombe@intel.com>
	 <aNstuNoT/kp6XGGR@yzhao56-desk.sh.intel.com>
In-Reply-To: <aNstuNoT/kp6XGGR@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA0PR11MB4544:EE_
x-ms-office365-filtering-correlation-id: f9b6b716-ca40-48dd-90a8-08de004cbe7e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bzhDcjlRMDFLbWVCQjBaYlYrbXJsZjJuZmpaditxYmZZdGhxU0Q1NmJDOGtU?=
 =?utf-8?B?M1J4bWMxQjljSWZrY3RiOHpHU3IwZ1RKRmZFTXdHMnlHY2wrQitNU0VKUHBh?=
 =?utf-8?B?dGhxZXUrbUpUVnhCOGp3Z0pQNW9ncENWUmhLV1NZNFJIQ0szTXloWC9RQTVC?=
 =?utf-8?B?NURaVDFhTCsrSXVXNzJhRkIzNVBaL3l2L1FFUzJ1OE1oeGVQOXNLSHUwNVNt?=
 =?utf-8?B?M0JlZThYSTJtbDl6dnpLT0w4VzBHQ1p2NmdEUG9NYUJZZ0JWRVpKNnFlM0Nw?=
 =?utf-8?B?MVhsZ3VSb0l0YmJHazM0OHBndy9HZHp5TVd5YUp5U3B1VUVPQ0Q1b1R2M0VC?=
 =?utf-8?B?OGErS3lWaEtBaElSS2lPYklLaHR3eHZ3b3dvUzFjc2YwMUxrRTRZa0pFZUE4?=
 =?utf-8?B?M01hN3pNd0NqWk5DU2ZSRmd6R21hMG5nUktWdEFVRkxUbng1VEN3ZXYyV05q?=
 =?utf-8?B?c2l1L3pqSnlEeTA0RWI4N1VGQ1NTU0VXa0Izemhnb0J3RllvNGZYVW9OcHdu?=
 =?utf-8?B?eVhEQVVOQ0hBY0Z3TlVhTWVnZE96U1ROTC9JWTU5Z05KQnVFdktpdGtlUm1N?=
 =?utf-8?B?MVlMM2xYTitNdThLUVRYa0tDUkJmbHpoYjN6cVMwWW9qbkFVc3BwK0YrNEI3?=
 =?utf-8?B?ZWlha1YwbFhHLzNYMDZIS2hLUXVoVWlpS1pVdnpQaW1zOXhKZ1Ivd1Y0Ym1V?=
 =?utf-8?B?aEFDbWFCMEdna0E2UnJvZkwyM1k2UUQwSDZPejRDY0JWYlZob05zYWhlQzZ6?=
 =?utf-8?B?MDVid2Z6azBpaFlsUkFsdm5GR0JwbWVjdkNZSHNUTG9TTmZYL3VzenVBaG5o?=
 =?utf-8?B?dXg4S2M0ZzFEdEJ0SlFldkNMcUx5ZXRITnN3K3poWDhPcjFZS2xwNlNqWmNZ?=
 =?utf-8?B?YjczcWV5bTJkcmYwMFhnWVdaa0NYZStmakNEQlB0bTNsdGNjOURxWU9oQ1Nj?=
 =?utf-8?B?ZVN4L2c4VHB3NWUzbUpJSlJ1V0hmWUoxeVVTTTlyeFV4NVFpOEphMURqRlV5?=
 =?utf-8?B?SlRlS1YzYzhCN3QxUTA0S3c1RVhpWXhXZlA0Sk4yZDBjTDNsQW5oVVpTWmg4?=
 =?utf-8?B?ZC9OQWhlTURUSW01YzFZZ3hUVFJTcDlhb29ydnpOdCtUY1U1MXpVaEdPQVBK?=
 =?utf-8?B?NGV3QUlwZkk4Y3RoVGRhRDdzWWM4ZGNEQ0ZBS2xRdzQ3YlZvbjZtV2pQRlQz?=
 =?utf-8?B?eU9HaTdNL2YyOXJwZlYwNDc2KzMwdVBQbjRPdm9xUTRHSFc2REJHVEZVZ1dM?=
 =?utf-8?B?Tk5yalFLMm9jRkdZQlEyODFudWRETGsrNlVEYWN2L2JQUnFLWGdLY2ZqS053?=
 =?utf-8?B?MVh6QkJ4N3BaZjhqNnJ2YnY3bDRnYThNQzNUTFd1QnUrM2VlSnZlY3dTUmRD?=
 =?utf-8?B?RGNuVDhvamhJTXJQbkhJYyt1RStocGdnZlArTnNkRHdWdldFWDdsUDMyMmV2?=
 =?utf-8?B?a2ovcGR4QWJXUlNGMlNTWVZXS1p5NVNDV0ZnNTArS0ZOUmRSaUd3MDhoWVA1?=
 =?utf-8?B?Zy9JZUtxQ1J2YjJzZGlGVmJyN2RrbmNwL2lWeTNwRzlZVTNaQmJkNXR3VUpW?=
 =?utf-8?B?SDFJMEk4TFRWc05iaHQyWWhMTTNIMEc2SDdFc3JQZzhQaUhvMVcyQmp3cWs2?=
 =?utf-8?B?TVc2c1hCayttam1ranBrUWc3My9qaGpyQU1lRGFOS3VpSWpIRzhZY0FRZ0FP?=
 =?utf-8?B?Tmpjay8vZVZhRjVTWE5tNFo4bTlEemZFN0pGc2NaMjliWW84RFhaelJYbGIv?=
 =?utf-8?B?SGtjWC8vUWFUejA3bitRSTE0YjM0NUptTHIybE9lSG1INGRsYXdmdTlpRWhH?=
 =?utf-8?B?UFJwemlNaCtqd1l6blRBZnlMaENON200L211eTZPNXo5Y0FoWTJ3Tkl5cTJk?=
 =?utf-8?B?cGpXWlM4YlBEaEhBMXowTU5JYVVQWjg4U3lXY01MVWxsMjd5NFVqbWdxemho?=
 =?utf-8?B?S1NBYXRsK3Q2N1NlOWtzbXpTbk92QitoR1JPcHJXK041YjROWHh6QmF2R0Vr?=
 =?utf-8?B?R1BVRVA2WGFkVUVTek05eFVNUUpBL29nWGlEOVZ4QU5mVlNQZjUxOWNJOWg0?=
 =?utf-8?Q?Niznht?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ODZoV1lMcnpMUjJCQjhqWUYwaVpJcXdrVkJSc1BjTUR4TVBjMDRZSDNBeUE2?=
 =?utf-8?B?cmdyMGt5cUlmWEN5QTRzVXE1b0RmNFUyNGJVUVR2QnNUUGxoczRVaXdGd2xn?=
 =?utf-8?B?dTBORm1QZnczSmtOYnhzUFpzY21IcXIxN0w2WDI3Q0swL3dzNTI1TlY5S2lj?=
 =?utf-8?B?dUNvTGVFK0dkdlJYMnZNcnNWNlNuK2FrMUJFanN1bjBrUTI3SjQ1TFFiSzFO?=
 =?utf-8?B?SGZRZGpSZ3Q4NDBCS014eCtIazhPMnlwVGNvZTlGM1AwbS9KWW9NOGpOTkxH?=
 =?utf-8?B?eWpNRzRqRjJEYnJBMHk5a09TQjUrRnBhdmVIYzRweVEzdVpCTkxGbkpPNktr?=
 =?utf-8?B?cHFPeTNEa3BPNlduVENtbTk4VXVKT3gyUTAvUXdYKy83a0ZMZHlnVnV5ZEVT?=
 =?utf-8?B?WDMrWnBQR2d5c0pZSTl3Vmw5WlFVY0M5S25sT2ZVdG9aUTFxd1FvNWlEUTJt?=
 =?utf-8?B?TXRkUUgzUkVpRkdiU1gxMXZBcXFPK00xSHF0TFRwa21pZjA0dUFGVGZvZDFs?=
 =?utf-8?B?U1JvTzB5RXE3dDd3QnVlMVFPMTVhMmZnejBhbjE5cmt5dDlXbkx4ejVjV3Ra?=
 =?utf-8?B?M3JpdzY4YWZKZ1JVQlIwM2dodFF6enFkRHAzVnFHYk8wVkdJaVYrMFVNNEpC?=
 =?utf-8?B?YmZtUlRoRzRiSnkrSTFiM0llT3hnZzlZMThkUFBnV3FJaXYvSHVTb1ZBMzFi?=
 =?utf-8?B?eFU3RGZrRlVYWVFHNHZOTjFocjZENlN1WUorNFNZbFlmVWRqMmF3bSt6djF3?=
 =?utf-8?B?aWtxdVNsSjhFeWZyL01IU0hnZi9RTnRzSkdvWVdsUy9zOEdaV2NwakZlWnpL?=
 =?utf-8?B?MWtrVTNYUmJ1Mi9mbGRBTFNrdHF2ZEs2WDQ5RWN1VXZ1YUszeThPYitETUVy?=
 =?utf-8?B?UEJOVmxsQ29uOFdIQnpSY2ppZ2tBMHY2RFkrQktlZjJGckgzV0RNSmQ1Zk0v?=
 =?utf-8?B?SjBTOEpxSThENHZORnBLUWRWM2tkeUZZN0F5NmdkYTVIaENjeUtEWkJkV054?=
 =?utf-8?B?NlZFRVRaVHc5d2x4UWR3My9Xc1ZJaUFFUmdtV3J2VUtVYUFpa014NmdzZGtO?=
 =?utf-8?B?Y3hZSkFDRGplV1haenZXeXNCZXZWUGlRZ2J3NHNrRE80QTluOWxUbEgxbFBx?=
 =?utf-8?B?VjdacnkyNEoxVHRGVVdxQ0greFV2cWUveEJUbVlUNStieGp5TlFGczFqZkN1?=
 =?utf-8?B?N1VTaG41NlVVaTdQV0pmOUpGeFYrZTBUdTlnS3g3TlV3a0RxRG1STVgyemJO?=
 =?utf-8?B?TFFxNGZNRFBDRC9sVzhweVVWQ0E1NERlRS9kNjFzOWZaWkp6WWMyQ242YS9w?=
 =?utf-8?B?THRyTFpZYldxdHpoREJMODQ5NUNUZmhueVdBYnB4YjZqekVxYk9kOXFQN1JB?=
 =?utf-8?B?SXh0VUVhbmdVd3E0bzJsUmdZN3lsaFVhUUk3M0N4VFlwd2loSWxWQmI0b0Qy?=
 =?utf-8?B?UzlXQVQ2Z2ZDN1FmSVE0QUpYeFd0TnE5bU5FWEZWRFFiQW1idkdRRWdFNEl5?=
 =?utf-8?B?V3dEOFFCYzdTZmQzeUtSeXdWTDZvMTZyUmZ0Q0IvKzVjU2dOVTVBdGozOXdx?=
 =?utf-8?B?WHEvTzJUd0FFMWpRbGZ2V1JqeWhaUTRxM3dRcXQ1bkdFWmE0dlBYQ3kzU1c4?=
 =?utf-8?B?RVRzVlFHdXg3eGZPS21MVVZSR3YwOUtXN1gxR0U3cm1hR2pMMFFNb0tVZ0hR?=
 =?utf-8?B?OUF5Yi90b1c5a2VhUHl2MHlpTGk1aFh5ZlgzTWgwVFJPaDliTGFrNVVYaHY2?=
 =?utf-8?B?SG5GYnBicW9TYUJtWXN6alljbzdrN0o5UjlQaEJWNjVieW1NY3Z2TnZhQlJI?=
 =?utf-8?B?R3pEVjd3dVRqcFVwZ1JVRmJQUEYrNi9QVTN4OEdYSW4zdWpxb1QxSEJWUTRp?=
 =?utf-8?B?WXF1anF5UTk1OFlnaXFqMXVmamZRdG1EbHAvaXhqYmZ1OFZaMlFYeUV1Wk9Y?=
 =?utf-8?B?aTlydVlxTlp4cjgyTjg3amd3VUxQUzBEZ05MVTlNRjh5V0pudUZpeTB6U2Ns?=
 =?utf-8?B?M3JZcnB4VTNaTVoreFk5dExqakRZYzMra3l6RkN3WUdXcUhROXZ5bnJ3QnRX?=
 =?utf-8?B?QzJEakJjM21UYnRaSjNIbnlyK3djV29nYWF2UHg1a0xjZktCVE12QWl6T2Rp?=
 =?utf-8?B?c28rNHp6amE4eFBkcDZTb1h2UFQ5Q0NNS1hScVRqdE5qQ0hOOEZLRmtudzQ2?=
 =?utf-8?B?elE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <925794C3B5CAA14DA191B3B6A9D65912@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b6b716-ca40-48dd-90a8-08de004cbe7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 18:11:14.6159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aQVljGggPUEI2fGjQB9/llhALkFQkc0V6/At7BrAIJy9Q+X+CCAvZ6nPAy2Bow5QbS2ylVzNqmrIPxUrZvWDlinfnrMlfYnKT4fRPq3jnxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4544
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTMwIGF0IDA5OjA5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
VGh1LCBTZXAgMTgsIDIwMjUgYXQgMDQ6MjI6MjFQTSAtMDcwMCwgUmljayBFZGdlY29tYmUgd3Jv
dGU6DQo+ID4gQEAgLTg2Miw2ICs4NjMsOSBAQCB2b2lkIHRkeF92Y3B1X2ZyZWUoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1KQ0KPiA+IMKgwqAJCXRkeC0+dnAudGR2cHJfcGFnZSA9IDA7DQo+ID4gwqDC
oAl9DQo+ID4gwqAgDQo+ID4gKwl3aGlsZSAoKHBhZ2UgPSBnZXRfdGR4X3ByZWFsbG9jX3BhZ2Uo
JnRkeC0+cHJlYWxsb2MpKSkNCj4gPiArCQlfX2ZyZWVfcGFnZShwYWdlKTsNCj4gPiArDQo+ID4g
wqDCoAl0ZHgtPnN0YXRlID0gVkNQVV9URF9TVEFURV9VTklOSVRJQUxJWkVEOw0KPiA+IMKgIH0N
Cj4gdGR4X3ZjcHVfZnJlZSgpIG1heSBiZSBpbnZva2VkIGV2ZW4gaWYgdGhlIHZjcHUgaW9jdGwg
S1ZNX1REWF9JTklUX1ZDUFUgd2FzDQo+IG5ldmVyIGNhbGxlZC4NCj4gDQo+ID4gQEAgLTI5NjYs
NiArMjk5OSw4IEBAIHN0YXRpYyBpbnQgdGR4X3RkX3ZjcHVfaW5pdChzdHJ1Y3Qga3ZtX3ZjcHUg
KnZjcHUsIHU2NCB2Y3B1X3JjeCkNCj4gPiDCoMKgCWludCByZXQsIGk7DQo+ID4gwqDCoAl1NjQg
ZXJyOw0KPiA+IMKgIA0KPiA+ICsJSU5JVF9MSVNUX0hFQUQoJnRkeC0+cHJlYWxsb2MucGFnZV9s
aXN0KTsNCj4gU28sIG5lZWQgdG8gbW92ZSB0aGlzIGxpc3QgaW5pdCB0byB0ZHhfdmNwdV9jcmVh
dGUoKS4NCg0KT2gsIG5pY2UgY2F0Y2guIFRoYW5rcyENCg==

