Return-Path: <kvm+bounces-62760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EF29BC4D2B1
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:49:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 77EF24EA1DF
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 10:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98C223502B3;
	Tue, 11 Nov 2025 10:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kwDkoMma"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D3F34FF64;
	Tue, 11 Nov 2025 10:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762857780; cv=fail; b=uNbfNH3xi0gHXRcFiZTE2Fqijo9a5owzheyDHiCwi6Y9uElTqyTH9tIDHaYrZ7fIDOrkkAGNPPmxcXBu9RXj2Ii3up3fG1EhmJBf1q49tdON0t1x7gMBTxFNLHK/aSqwwStEeSxI0+Jeh/+0a8P+VeLieABdZPKDYRkCEI8gHg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762857780; c=relaxed/simple;
	bh=RzeoW6rkOf9DY+FyFIUndTXc8wNVVCoH83YbZtoK2mA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gz8a6cIXerCLCfiKTChFweqRj/7uRo8xwMAmvIplMT5mx5sHafh6e8WJu5TLVYBy7flR174HLPBMKCk+clbw9dcww7wNAnGwUWyul9WB5gbTi0FCg5WWd7w6JTiQXAh4MKMZwpBrxkkzUW7e5ta075RwWIUvph4gMV3Y6VN84KI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kwDkoMma; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762857779; x=1794393779;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RzeoW6rkOf9DY+FyFIUndTXc8wNVVCoH83YbZtoK2mA=;
  b=kwDkoMma+ysorq1BMzZUNkkKh4WbuqqESPQIlfvMKYjQSrhWhg81tShi
   ZTL+YJMXTxIPTF3JFeevPZtkqeZHJzpJXgCApxrtZP0w81m7xhg9zAhz9
   dt8lanvwFdQTNb3VdFrqoo2CnZAM5rgFLVK64AroHKcwS1A5cPTIBXRVn
   qOfJzfNsDQ+6nVOw7EABLktJ+DQvlGDu5CPVL88HBgGRpZStQZqjmEGje
   tpvVKr4GREZW8ScsmI18aCYD3iUyAQilVEeNLakQ0kMUb/pqAbLF4saxS
   2KKNwHeawVrbFIuC90S0x7fOhYfKdntDAjUBbBUVVEGE9nueR908nFrvU
   w==;
X-CSE-ConnectionGUID: +VduyveuTFGrRiVl4jfFXw==
X-CSE-MsgGUID: 6OmdlIOcTtSFD38i60cJRA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="64801586"
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="64801586"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 02:42:58 -0800
X-CSE-ConnectionGUID: 7C3V6DAhRUmJqAWZDbtZUg==
X-CSE-MsgGUID: A8O8MvtpQQuN+kAthicDNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,296,1754982000"; 
   d="scan'208";a="226195095"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 02:42:58 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 02:42:57 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 11 Nov 2025 02:42:57 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 11 Nov 2025 02:42:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LHqPjw8tDP/jeKOV0pN96YVvMq6CI2zleXGoRBlwzhuNKym/UfmMLGRhmRyblUGdCeXvmpHqNQWbJaOSVOAoTSldHoHQXviTPN7SG5WeJQNBDhAdFmd3q5NiSOgR+wdeAovOVd2kGLX4QR0SDUkNMjw3xh/wfS1xzfwgHFhGu/wwCKiUMyxw61GeTBOHsHspynOjrbrTWui5Vac2La21YD5uJn+bDHr38Ht0hwKcUafJWPo4OzZFYDIu/hxRE/Moy6n6aQxc/dmR4qXL74d83Hfb+PMpBWqHXnez/A8ALNJPUb2rXWNkjibQvsjPf3Ew77bs51Iq6j+UEq+bBFONOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RzeoW6rkOf9DY+FyFIUndTXc8wNVVCoH83YbZtoK2mA=;
 b=CN/e5MMo3OAoDBZRPJFCbyjykpJcAZqX58+p731PL+THPLOgYHbv/I0LVGAqu/8KEbhmfcntzJK3eAoC+J1zc4+L9OLPsTjpe6YfGtMxhIh3F/WYky+kdhFPRKJu2wiBgE4UNcOuV45tZkBkhVl0aDOxxm5hL+S3ohej9S5gTqS0FkMszlx9MY/ilkDX+cS1quIkITL7Aol5MKx4hLlr4p1ZkShULlgG2nvOkz12mvzUN4elo8KiG0e+exMnH1298Oj8+iZG9C0GAVrJNGYnysFATPWHSihrvNnjb5gJg0CMufGnG6T8s/BLB7aLC9DxB43Y89hIHAkJx0va/9KVrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MN2PR11MB4517.namprd11.prod.outlook.com (2603:10b6:208:24e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Tue, 11 Nov
 2025 10:42:55 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Tue, 11 Nov 2025
 10:42:55 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcB4AQJSSoQW12Bkmtr+PwbHPEybTt4N2A
Date: Tue, 11 Nov 2025 10:42:55 +0000
Message-ID: <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
	 <20250807094358.4607-1-yan.y.zhao@intel.com>
In-Reply-To: <20250807094358.4607-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MN2PR11MB4517:EE_
x-ms-office365-filtering-correlation-id: 93dfa834-9a20-476b-c6e9-08de210f12e3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dTZlMW1xWXllWGNmMHlYZENMTEJrVFR0UGFGdUZvaDdDMWFXSmF0Q1BaWnpY?=
 =?utf-8?B?SDJiMy9Ga1VocFBqNE8xNDFhVmhIZ0FNTzRqWktESkNQSDkrZGdSa0huWjlj?=
 =?utf-8?B?TGJaWVpXN1VKR0F0T3hkZzJwQ0R5KzJrZGV4QndZc2hRL0dxVTh2VjJQQVJl?=
 =?utf-8?B?RHJwdkcyRUgycGhvK2phVmMrTUhKY0pnNzlGbkkwRVhZMDU3OFlGdjYvcDhL?=
 =?utf-8?B?eEhOTndRTVc4T0g3WEJiQmdqNFB0ZXV4ZWlybElQNVJBSEcrL3JvazJkZVB4?=
 =?utf-8?B?TUhCeTUvems3S2U1a083Syt0SUFhWVBLelBsRWg5bXFkUDBDVzBJb2o3Sjhq?=
 =?utf-8?B?d0JJVkxhc0tPSWNTOC8zVmpYZ2x1TlhNTXpYeVhJSGVzeTZWK245QW5UMDVy?=
 =?utf-8?B?OVdWamJBY1htUFhiVDZja0ZCOGtxaVVoaHJoRzRwSmg1TDE4V1RQYU9melVO?=
 =?utf-8?B?aStHdVpMT0tGZnFPdjlYeGxwUmJSOXdPclhjNEZQcWlrMTJGNGJsZFVOUGZS?=
 =?utf-8?B?RlZqUm9uNHB5TVNGYi9qY0M2cmVGSDBna1FyenE0UE5JWXZzY2hWVlM4elA2?=
 =?utf-8?B?RDg5VXFDYTkwcUxZN2VFUU1YdG5WYkVDcmt2UzBpTk0rRGxGTFpUaTVQcVZY?=
 =?utf-8?B?L1QrejdSNjZQV2w3a3VYZGNtM1NxMWk3UStZYVZSNVJ4eDRmdnFmczN1Q1A3?=
 =?utf-8?B?b0VOSG9UWlIzcmRIS2MwWGttaW9UVXhxT0RKY2pvNndCYnVYU0JxYjBnaEt1?=
 =?utf-8?B?R1Qvb1JUS2UyTytRcXBrYjVqd2ZkSm4wTnhCTGNON3BoclhtOE1CY2h6eUpo?=
 =?utf-8?B?VENWdUJXNjR4NU1hemR0aWNkSVR5RmlzbVZUZkszSTBnNWUzMWhZNkgzSW1H?=
 =?utf-8?B?UFJ3UkR3L0ovTC8xbk00aEZET3ZQSlNUWUJhbEhnN2hBa3h6Yy84eEc3RU9l?=
 =?utf-8?B?M2hhVzFHVnM4b0tsSE1BS3Yybmw5MzllWWk2MnZNdHM4VEFpTU04L0RWUFF3?=
 =?utf-8?B?K1JzbCtrSEE3dGswVVRBQkx2MGpXbTJoOUFjM2pkaFNNOWgxbkg3T2FyRFNa?=
 =?utf-8?B?ZHZaeSsvTHZBcFJQRnBmaHlWNXhBRi96QTFaSmRZdUdZVXJKanJLZ3l1ZHJN?=
 =?utf-8?B?eEV5T0RnSTVIaXY0Q1JnVFNEZ0V3Qm9INW5NU3lSWVhCMVJIYS81dzhMRU9S?=
 =?utf-8?B?SGk4RWRwSUhLeCswZlB6MmJzemdaNkFvdDhhUUFFWmFmNVVxVzRXbStiZzlF?=
 =?utf-8?B?bmI3NDREbzRLeGtsdE1BUEx5aVFmRmg4dGZIbEFQUnpudnZrS1J1cnd6eXlC?=
 =?utf-8?B?MDJqcDY2MHpXa2wyNzBYY3h1VUNMMjVEbzhMWVBoSjgyRCtmTk5RbmhHdGlS?=
 =?utf-8?B?SlZHankya3FOSXEzWEorcHQ1UGJGR2xNcDJLZzMzMDlHYUd1dVREc2ROditu?=
 =?utf-8?B?dTdBd21tQjNYMkZUY3did1pEOXM3WWxuYTVsL3RjRVQyWllFVzhBdnF1ZEIv?=
 =?utf-8?B?Z3ZsVWVoMnNteENnTDd1aG9Xd0NTalZvc1dBWllrcW9OZlRmMHF1Mis4LzBh?=
 =?utf-8?B?ZUx5dkR5S0RqTFFtZXRxako3N3Y4OGxvQ2xhV0VCYUZQRmR6SGY3RDlIUUp0?=
 =?utf-8?B?U0NQVnYzcVBqRmxKVVNNK3U2eEJwSjE2UHRtOTFyaEhweXBCdDcrZERzQ0la?=
 =?utf-8?B?QnRTKzlWalljQXhMK0VhVHBSajVNalhiaFp5NjRxYUNNSnNiUDBhcjFsQXRl?=
 =?utf-8?B?azViM2VzZTJDYXVNUlJ6T0h6NnVTSXRkY0R4TTZNL0lmR2ZWTDd3dUszbFc1?=
 =?utf-8?B?c29oQ0Ewc05jVjdmaXFJVjlJM01kRHg3S1BiNkhFVGVCd1dBNWdkSDZ5bkJC?=
 =?utf-8?B?a3h2QXZQRVZGaFVXS3VXdmNaY0R4QTNLSHpXS3U2Mlh2amxYeXh6Zm5BS1RE?=
 =?utf-8?B?KzZRSk5hZGdvdFVWVEoxL2FLbEtkNm5ocGhTellxNXhuRHVJUFZQdXN6SmlQ?=
 =?utf-8?B?TUhJdTZUU1NUa3ZEY0swRDc0VzZlcEp0eTBOOG9weGUwM3NTQWdFcHphZXgw?=
 =?utf-8?Q?Z/rR0B?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VU1JTDVzMXJUaGtJbTY2TktxU0dHaXFSaWJQN25FVi82L1RPT3ovTldQZERY?=
 =?utf-8?B?Ym5tc0JTR0ZxdnJUWU80cno2ZDNVUGpRZVN5a0p3TEpZL1JNaGJ1V2YyaFpP?=
 =?utf-8?B?RmhFeTZqMFFCN010eFNZM2k2NXZBbENnYm4zaEtkdkVUc2hkNXd0K3Vza0pr?=
 =?utf-8?B?QUlxRktQVG1QTURLWDI0YWJyV2NXcHkvemJ0Y0hTVVQ4S2J3V0xoREdOSGk0?=
 =?utf-8?B?L2YxbnRTbit1RFdITWc4WHkvYStkck5EazhuQUNmSjljZWw1Y05HbWo4UHVu?=
 =?utf-8?B?RzBPTnFmN0RVb0txQk5EQm1JYUFQSTBhUFlhVk1TTlhVOHlTZUpUc08rbXdC?=
 =?utf-8?B?WElXYzhRQ1QrZmxqNHRzSW1wOGloUmRtSXRJTHV0aUZpcTE5dlM2T0l3YXJh?=
 =?utf-8?B?Mk5kYktuMTZMbmJHZDhOUUJxMVhybHF0NkdueCtjcnorTXhLNERNeWhWMld2?=
 =?utf-8?B?cER2RGdhYzVyeWtyeDlHMTFCN01FR01FcUs3UnBwYUZjL0d5OFJZVzBPSFB2?=
 =?utf-8?B?UGhiQVUrRHBra2x0TzZEN05rQ2trOHpuaUpEeDd0YzBVb21hbFk5Lzcwc3Z4?=
 =?utf-8?B?REFNRFVCTEZSQnhjRlZ2cGlSS05NdnBmQUNVZHNLODVlUVdYWE02M3huY3dp?=
 =?utf-8?B?WGliMDdHbTJGRk13dkJtQnBhZE8zRnhpbCtNT0l0dHRXOERaRFduc0h4TlRs?=
 =?utf-8?B?aklldFlaQ3E4TmhyMUloYWs5UG9ld1h2d0NqQzFFWnNZdjNDSSsxaDNtRlhs?=
 =?utf-8?B?MTAvSHp1UWZPMkdrdXVKcXNVZ2dKaE5rZEE1RXhQRzZBZ3hKSG5Yc1dYempV?=
 =?utf-8?B?WUVyMzBYdEE4MWxndytYVEU5Q0VZcjQvK0RTMW53Ujl1N3RQbjU4d3dFQmlu?=
 =?utf-8?B?VG0vSjJ6ZHI2L2FkNTM0NUpMeHBVU3VqWWp5QXkzbjB5Ymg5MTZTYm11ZXAz?=
 =?utf-8?B?TFJLcDNBM3drMTNQRVVRSDhQdTFvVW9YRnFtMHhFSkFyN1dyc2ZWLzBoSlo0?=
 =?utf-8?B?cmY0cVR0Q0FDcUx3TjN2Yy9yWTI5ZkpXenNkdTNlR3g4aEVFV1FGVGkzekR3?=
 =?utf-8?B?cnZmNUJEUHhpUzF1UTdvL0c1aXlKeWZ4TEcwQ0p3ekRZd2FUYnFkWmppU3Ar?=
 =?utf-8?B?aWxTa0NTWTlISXlhZmErMCtWVktsTGhtT1poY3AyNFYrWnJQM0pOQVVYTGl0?=
 =?utf-8?B?NXQ5ZHpudmlKa3o1WjJpQlZhWnJFeWZVV2ZGNHNUQisxZm9lK2RORmNPSTR5?=
 =?utf-8?B?ZHVxTHRqc1FmeWNhM09vY3IvalgzRTE3alZQMEF0U2JKQXcxOTNORG1BWW5W?=
 =?utf-8?B?YjFPbUd4NFBidllWZXpRd2d1ZXZmN1FPaHRST3dxZlN0MktlZ0xXUXNqVURT?=
 =?utf-8?B?Vmpob3U0ald5WkVmd1pJQkVGYnhyL1pxZmpEVHB6NDdUZmpLc3VDc1M3N3ZJ?=
 =?utf-8?B?VE5kK0hqY2NzRnhFR1ozNnVvcWI2MDlrSGkwejJZd1RlYW1hNmlHUnlQcWt6?=
 =?utf-8?B?Z0xyUmpQNlpKOGlnOE1wODhteE9tSVJHNXRmdUZqV29Hdk02cmx2QWk5Y3Vk?=
 =?utf-8?B?enRNZEZRc3l5Tk55VkVPMldHbCtFcENoMTZDTllZSExGemZOc1dMaVVJT0Fv?=
 =?utf-8?B?bFQ4VldFc25FcHdPaUpmakx2Yk9hOEZ5TEx6eTl1N05aRXpEM1lxSHJYUUpy?=
 =?utf-8?B?WjVOVld5a1poS3FFeDhYYytScFZZNjJaWlBHNnRCK2hxUXhGNlBCMXJwekVJ?=
 =?utf-8?B?enYyc2dqODBaRkg2TW91UkNhbWpqK0hqSElPZmVqK0kyZ3N5ajFQZ3F2bUJ3?=
 =?utf-8?B?NTVndVdPY3RHT09BcTJrMVdzZWxSVEVvRjA3YjRiMmZDZ0UvaFhpTmFJMkhv?=
 =?utf-8?B?ejNxa2F1T0MyYnI5ZzVEQzZsSTUveUVZemdESWxrT1BZbm5aQ2pQTzg2T1Fu?=
 =?utf-8?B?RWRZZHNaalJ5Vlp1KzEwRWZVMERRMFk1ZDJJWnY4N281OG1iMHoyazh1eUF2?=
 =?utf-8?B?Zm52cGp4VVBmMjNSSEVGQkkrbTN1bnYzZDZoT3VnMjVxdy84VXJ4NnVPVEpW?=
 =?utf-8?B?em54MW5sb3FzTmovYW5PbUF3VC9PRkZGZHlTUmtWNFUzM2ZmOU14ZkZlL1ZN?=
 =?utf-8?Q?KDfrIOV34Ilay5F8Z7nBWhdSt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A809FFD31997864F9080DF59C449C6F3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93dfa834-9a20-476b-c6e9-08de210f12e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2025 10:42:55.7827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DT5kEGSaqTBi747E7/XPBINBU6N2AbwkdFo9X8ZobVc3XLw/neBeH/yzYAz6FHNR24GadXPFTvaRTCYNlbNJmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4517
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTA3IGF0IDE3OjQzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gwqBz
dGF0aWMgaW50IHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KHN0cnVjdCBrdm0gKmt2bSwN
Cj4gwqAJCQkJCSBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290LA0KPiDCoAkJCQkJIGdmbl90IHN0
YXJ0LCBnZm5fdCBlbmQsDQo+IC0JCQkJCSBpbnQgdGFyZ2V0X2xldmVsLCBib29sIHNoYXJlZCkN
Cj4gKwkJCQkJIGludCB0YXJnZXRfbGV2ZWwsIGJvb2wgc2hhcmVkLA0KPiArCQkJCQkgYm9vbCBv
bmx5X2Nyb3NzX2JvdW5kYXksIGJvb2wgKmZsdXNoKQ0KPiDCoHsNCj4gwqAJc3RydWN0IGt2bV9t
bXVfcGFnZSAqc3AgPSBOVUxMOw0KPiDCoAlzdHJ1Y3QgdGRwX2l0ZXIgaXRlcjsNCj4gQEAgLTE1
ODksNiArMTU5NiwxMyBAQCBzdGF0aWMgaW50IHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290
KHN0cnVjdCBrdm0gKmt2bSwNCj4gwqAJICogbGV2ZWwgaW50byBvbmUgbG93ZXIgbGV2ZWwuIEZv
ciBleGFtcGxlLCBpZiB3ZSBlbmNvdW50ZXIgYSAxR0IgcGFnZQ0KPiDCoAkgKiB3ZSBzcGxpdCBp
dCBpbnRvIDUxMiAyTUIgcGFnZXMuDQo+IMKgCSAqDQo+ICsJICogV2hlbiBvbmx5X2Nyb3NzX2Jv
dW5kYXkgaXMgdHJ1ZSwganVzdCBzcGxpdCBodWdlIHBhZ2VzIGFib3ZlIHRoZQ0KPiArCSAqIHRh
cmdldCBsZXZlbCBpbnRvIG9uZSBsb3dlciBsZXZlbCBpZiB0aGUgaHVnZSBwYWdlcyBjcm9zcyB0
aGUgc3RhcnQNCj4gKwkgKiBvciBlbmQgYm91bmRhcnkuDQo+ICsJICoNCj4gKwkgKiBObyBuZWVk
IHRvIHVwZGF0ZSBAZmx1c2ggZm9yICFvbmx5X2Nyb3NzX2JvdW5kYXkgY2FzZXMsIHdoaWNoIHJl
bHkNCj4gKwkgKiBvbiB0aGUgY2FsbGVycyB0byBkbyB0aGUgVExCIGZsdXNoIGluIHRoZSBlbmQu
DQo+ICsJICoNCg0Kcy9vbmx5X2Nyb3NzX2JvdW5kYXkvb25seV9jcm9zc19ib3VuZGFyeQ0KDQpG
cm9tIHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KCkncyBwZXJzcGVjdGl2ZSwgaXQncyBx
dWl0ZSBvZGQgdG8gb25seQ0KdXBkYXRlICdmbHVzaCcgd2hlbiAnb25seV9jcm9zc19ib3VuZGF5
JyBpcyB0cnVlLCBiZWNhdXNlDQonb25seV9jcm9zc19ib3VuZGF5JyBjYW4gb25seSByZXN1bHRz
IGluIGxlc3Mgc3BsaXR0aW5nLg0KDQpJIHVuZGVyc3RhbmQgdGhpcyBpcyBiZWNhdXNlIHNwbGl0
dGluZyBTLUVQVCBtYXBwaW5nIG5lZWRzIGZsdXNoIChhdCBsZWFzdA0KYmVmb3JlIG5vbi1ibG9j
ayBERU1PVEUgaXMgaW1wbGVtZW50ZWQ/KS4gIFdvdWxkIGl0IGJldHRlciB0byBhbHNvIGxldCB0
aGUNCmNhbGxlciB0byBkZWNpZGUgd2hldGhlciBUTEIgZmx1c2ggaXMgbmVlZGVkPyAgRS5nLiwg
d2UgY2FuIG1ha2UNCnRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KCkgcmV0dXJuIHdoZXRo
ZXIgYW55IHNwbGl0IGhhcyBiZWVuIGRvbmUgb3INCm5vdC4gIEkgdGhpbmsgdGhpcyBzaG91bGQg
YWxzbyB3b3JrPw0K

