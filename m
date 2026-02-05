Return-Path: <kvm+bounces-70362-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +CUCJhTqhGkj6gMAu9opvQ
	(envelope-from <kvm+bounces-70362-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 20:05:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E3DF6B1F
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 20:05:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 1CBE7300533B
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 19:05:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF6030E0F1;
	Thu,  5 Feb 2026 19:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ERUMdrF0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A053830DECC;
	Thu,  5 Feb 2026 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770318344; cv=fail; b=f//XWKUsjXziG17LK+TEvXRBx2ON1dMHnvv9odmorIe18uUozEiN7LWojLX0yZj/DMi7hwRyA3lYCe95yqYRQy5WYTNtCh2qQkM0tSRkCxIl6OO9v5Svty3s0X1XYBJRVHahyjkQ9JuTqYysC8EQEVte4Vdp0wuZOSNBxYZeqw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770318344; c=relaxed/simple;
	bh=9lL+VKZCdVKZ2LUssN0h/oOtO8wzRssYEMWYBfOnx3s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bMgaTtGQrrsINsCDPbytTN7mut2IFvMO2cSgMDmoEiiJqK/1rtI8VIDVKsxAtb9YFgiuogOjEQHUrUu8TiuiVspKx+hgHXoQFTms0DeTdQpmR8Y0o5OtaCh0OEnwUyRjlee+GKbJ4ScfRGoN3w+/EH88xCCe7UZXz71uBmvdY4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ERUMdrF0; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770318344; x=1801854344;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9lL+VKZCdVKZ2LUssN0h/oOtO8wzRssYEMWYBfOnx3s=;
  b=ERUMdrF0hprQHIcMNnhPm0hPD94gmdjGBpSp8LaFTE0DK5CPQP7q+T9Z
   T+j2TE7UZMrUOMqpsCxXS8kE8t39LqkYz2e+UwjgIurTYYxjck4GprIm+
   1X9DQrKXCOX6q3Xf3OZe//jPuIc5FDEZ7MKSL+dPsT3lRc8orpa3ZQLOw
   6CZwLG/sd6+61SSZHmkb4i5tYM+k92ZX19ZUZt5AEjw/gBISaPH7fIUI6
   wmNrTbJFq89PU2MbS2M13kinFd8lX4UGwxqhiXgC4Cx+JvgfPGC6qYEXG
   4rDu97DGt6EL1QXlI1nfDemsuPgM78pmx2LYzJNDJ+a/M4waazFa2JTjs
   A==;
X-CSE-ConnectionGUID: xoRpKhlAQcSnRkxSv8vTHw==
X-CSE-MsgGUID: LowZQtE2Q0GA88+8d4Mjkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="71425374"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="71425374"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 11:05:43 -0800
X-CSE-ConnectionGUID: nGNQENa8REawjm8S2PBg/w==
X-CSE-MsgGUID: 3GDmjfOITI6jG54y3F1wqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="210058049"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 11:05:43 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 11:05:42 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 5 Feb 2026 11:05:42 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.2) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 11:05:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nWOp3wn6PfIBsNET/cSvzgD9/OGTtrK2XwkaGY/jmGHuGujgDjYs3Hk+rxZq7OOOuViyxBkOgiQcdMFEb/QFpDXLvJCR/UVCz9nc7xlqe1F1N7fDG1YuzCiGqyNIMa+Rxpi1CurvlebvyhJqWPmt5Z7CzPDynERlLCzpav94HugRN2jvP6NqHJFyBhWZZ9DN69vwwrHm6Xhyo+ymXgzVt0T7FIBWGxtZeuLvgILfjhPVKU3iSfpY1CPfZ2CwSgz587ZbqPrNU0n5LO5iLUa8d1/r4lmGx0y3Y5DHO47X4ZtySMJgCdHmtjPEIzZ1Ag69JsHIR7eFq2xFzCVnTuEdmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9lL+VKZCdVKZ2LUssN0h/oOtO8wzRssYEMWYBfOnx3s=;
 b=mohagvjfIHgO7VStWncaB4hiIt7NEy9JYbDqp/9rLi2pvyh4cjzZL56RPxisNHVChjIYE73+YQN8u7XuQo8nJWfITczjYKxgjk1Vs2j1gKV64TGqTy73FVVv6Qa4mKGWT4JRER2bUzDxAaNJYnFTf+pUvrqtUXNQgaNGKgpZ4WpLgraRUv/UMMi47UuH3OQwR6L7RxWFZXlEAUtwL2vhHMO8Nn8GzaNi7QFqmlsNT1tAuqbgoVGdPGNvE4Bul0aysN1G2jRjgwLhnxyP0dA0CxGFIpDqbt7UgBYilspB+DIzp4sl087rxT8cjISBC13tqZSQx84GN8hpSYqsOz1fRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB7125.namprd11.prod.outlook.com (2603:10b6:303:219::12)
 by CO1PR11MB5122.namprd11.prod.outlook.com (2603:10b6:303:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Thu, 5 Feb
 2026 19:05:39 +0000
Received: from MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684]) by MW4PR11MB7125.namprd11.prod.outlook.com
 ([fe80::eff6:f7ef:65cd:8684%3]) with mapi id 15.20.9564.016; Thu, 5 Feb 2026
 19:05:39 +0000
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Thread-Topic: [PATCH v2 0/2] x86/virt/tdx: Print TDX module version to dmesg
Thread-Index: AQHcgZw9XVUHAhHwIEy5XIv07evhX7V0oZsA
Date: Thu, 5 Feb 2026 19:05:39 +0000
Message-ID: <6d8d37740459963e6fd7f16a890a837b34ebdf17.camel@intel.com>
References: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
In-Reply-To: <20260109-tdx_print_module_version-v2-0-e10e4ca5b450@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB7125:EE_|CO1PR11MB5122:EE_
x-ms-office365-filtering-correlation-id: 754a477d-46d1-4a1f-415d-08de64e98d70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SGNMRmxCMlFtcnZLOVNYTEsvdmtqOG1FK3h5Nk9YeTZUMi9DSmF5VHUrRHNy?=
 =?utf-8?B?YU14djcvTy9tRjBZLzh3WmFlR3hrZ1ZIeG9COFMrdVplYUZUcWpoY0R0VEtv?=
 =?utf-8?B?UVhYajVFZFJQL3Q0QWpLdWJmZTR5OUUrREdSUnVJT3NweFhkSEZBdlNBNUFM?=
 =?utf-8?B?eFc0ZUVDWXMrZ3p2SVlNNGxNNzZSbmIxNVIxV2tGMVp3OUc3ZWI0NzR4ZC9x?=
 =?utf-8?B?OUxPL25UM3Zpd0dKYkFyZTFmdXZMbEhFNVc1TitSMHpPSmRja1ArTHBPY1Z0?=
 =?utf-8?B?aUJjSW0wMnhYS2grWFN5VnBaS0wyV3YvZFNnNkVmMkw4bEtDQVo4WXBTc1R2?=
 =?utf-8?B?ZmZtUGkwMzNvN3pjUVMvMDRJVDJPNktkNW44blNFL2VYVUV1ZmFIVlVrNTl1?=
 =?utf-8?B?UzZ4akEvT2t1bjRGWEJvTXZvZzNzMW01NDVGUEFGay9Nb2IrSko4a3FubWMx?=
 =?utf-8?B?MFdkam1KQXhiYldFTWF4TjV2YXJJc3lpdjcyUUJ5V0oxQTl6eFNEcXpnYld1?=
 =?utf-8?B?QjlBMHJKQ29EY0grWGJIK0JvTlpLUENmbEk1T1VDa0VQL25jWjJiMFA2dU5x?=
 =?utf-8?B?VDZZcXhkbkdmV3hmWkh3ZmthOUNJU0VhYzdkMDRNQmc2SHJ3OXRiY3M1Qkg5?=
 =?utf-8?B?V0cweHFQMHUvaEtuQzQ3cEJHVDlRcitSaWNtUDJjZ01RR1JHc3NicmRIS0Rk?=
 =?utf-8?B?Z09XL25xaHdWWFY3RDhKV3hXK05tdW1OeENkN2UzejBsRk1FSWNhNkhDV3M4?=
 =?utf-8?B?emNaeThYcXV6ODVTZUt3dXZDOTNOU3laSzdqbnMwbllGSk02QkJqWU1SQUxP?=
 =?utf-8?B?cjBuejBEaWxtSlo3SEN1aUExNkdYblpxVjhiOC9BVUJ6cDBkT2ZZQTZiZmxN?=
 =?utf-8?B?VXl4cmZPTlpFOWNpRDFjaVRLZFVHcWlaUXJKck5SSjc0ZmM5alJyR0VNZ1Jh?=
 =?utf-8?B?NlZvYm9TWFgxUUp1MktEVVNXK1lKVWtMNHJPclFjNXptd0RSVVlPQmR0Yk5t?=
 =?utf-8?B?TE5CZ1hubDVkankxVmFDVGNrNkwrWE5qdTJWbm44NnZpSHN1NzhrZXhTamky?=
 =?utf-8?B?TWZLZThRdXdCY3p5dmtVYjY2aEg5R01tM3ZScWY3ODhlUUFTalBKMk1QUlFV?=
 =?utf-8?B?RkI0R0pBL1FSb05ZemlFZjk4NHlzZktzUlllOWZ4eEU3b3NtM3FJMHA2dnAy?=
 =?utf-8?B?UVhIU0FMR1ovWGt5c0tSUWNlZjJzOWJuTUdFNk5YWVoyTk5YWDFIcmo0dUdt?=
 =?utf-8?B?d1BsSmoxaG9ISVlGUTF6amdJQm1YR2g2WForTVNSTldDcno0VFZVS1FKS05D?=
 =?utf-8?B?TXFMKzZJN0wwakRTcy90YWNmRE96M052MHZMOVQzWE95NHpjR1o4djNvTkVM?=
 =?utf-8?B?MTNCTnE0L0JUazBuQmRWdDNiZUVUUzFmTXNuUUZoQWRvNGVOY2JCdERWLzl6?=
 =?utf-8?B?Yzl3R2g1SENKNnV0aUt1MytBUWx4eUFXNEJ2aTVpVzRkeS9KNkc3L0hKNmxJ?=
 =?utf-8?B?SEd5Z3dWcGNUdGtZTmtCVlRYcFh4UTVqbmQ1Vk5LRE53cy9lekx5UzN3SUUy?=
 =?utf-8?B?ei9RTUY1UDEycnVPeGpmL2hRT3BYS1dDblRjMmI3R2h0NCthaERXSkZjTTE2?=
 =?utf-8?B?S1JIT2xIcXVvTFdndVRBRDQ5OVNKTCtHYlZuNVVNM2hydGtQUjZkV0FqTXBH?=
 =?utf-8?B?aXNXM2pINTFNYzhjdEM5dkc1TWJNbEpLdW42Mm1kODJGaEJ0dmJYNWpmRnVw?=
 =?utf-8?B?UklQMHRPT1VjWHlZOEZ1VVp0MVVCbmUwVDVQOXJtSUlVR3d2TjNJc3crUHk1?=
 =?utf-8?B?WDdlZ3MyeWZycjhQU094aGpUTGh6VldJVTNzNE5GdnVEalA0WWNtMkt6MFBh?=
 =?utf-8?B?VHQ1aWxkNEpvUzNqMlNCVEo5ZFhIU0JmZ3RhS25LdzR6bnFJai84cFlGai9z?=
 =?utf-8?B?OGtqRDgrWlhwbHZvR09KSlhqcjVZUE1wNndvVG5DS2N5NUVjUmpQM2M4cElM?=
 =?utf-8?B?S1o3TTlHUzl1dmJtclZrRXVlS2twOEZ4NXBEY3ZRb20zOEJLTjdGQ2U0SnQv?=
 =?utf-8?B?U0FKeXdYUEhNaXRvQzZRbzB3NEM3WU9YSzN5T3RvaEZOaE9BbHg3Tmk1K3Zw?=
 =?utf-8?B?K3hmV2YxUTB0TG1MUGpmSFZTUkFLWTdvdFpsZm90Tk1pbkVpWDlRNUJEU3JQ?=
 =?utf-8?Q?1n4kUe9csuosJvOQ/IxZ+usN0LGLcj9hpBZqwBREJwNf?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB7125.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTBCQzRQSkNGMFR4MXRoUmdWeG5hK0VpMUNySkxLNGpGSU1DbngwN3JFTkVM?=
 =?utf-8?B?QkduOEp0N3dFeDhneFFwMUlLK0RlZEM5NU5iZk9yMHpwVnJzbG5OSks4Vndx?=
 =?utf-8?B?alBYaW1QMkgzUkQrbi8xWHB2RUtYdnNUSDlYZVZwcWRSUmgzWnRLL2MyalFI?=
 =?utf-8?B?RWxwS1NEYnVzVUlmTWxXZUUzY3dTcjJJZEVCTGw4dzY0WStuVWttK2VHOVM5?=
 =?utf-8?B?ZUYzQk9OdEdURjBOV1lnWmo3VzR2ZEtnd0xrMVN0MmhqNHdGUjB2UHBIeVB5?=
 =?utf-8?B?WlF4RWNmMGJyMzEwOHFtNmZscTJWckZZMm9TSTVLaVVKTHpZZlBVUjFPajJ5?=
 =?utf-8?B?RVFUVlJvSURjbXhxOCtTWlljZWdCZ0thMVdCbUlsbXhXYWMvWS9pUU1ONFNw?=
 =?utf-8?B?VGZHSVY1eXRmR3ZVU2lUN3F5cFFnb2RrV0x6aElDTVVJWWIwZVRlRFd6Uzls?=
 =?utf-8?B?aGtjYmlYbjdzMUxPZ3ZYZ2dhQ1FRUU9UaHZJek5ua2xHcmcwU240eHFRSzV6?=
 =?utf-8?B?dnpyRzNsa09XZkRoUUdjWnkwc28vTHFkNGR1UkwyMGVVanlQWFBtTWJTcmZt?=
 =?utf-8?B?ME9pQ2xPcmpIRGV2WGw2V1J1UDllSDZPeVNsZTkyWE9ieXJVcnJmUDRZNDBH?=
 =?utf-8?B?aStDRWt3KzJXaFRnNFF2emIxbkZzZ1BKVXFUeGl0dndwRzl1QkxzWUdyUkpr?=
 =?utf-8?B?K2d5SzJLcVJxU3h1d1A0RVJwSjlJdFVHY2V2ZXlVbjBBQjRMS2Z0ckdBRloy?=
 =?utf-8?B?WUFvVUxNdlQyNWdpc3E1eitjRmdNNDFmUUZDVFlsV0J5K1NVeFhPNDVnQ2F1?=
 =?utf-8?B?UU1oc2xUMXRsSWs3MXZ2bnNIMXBYdzZFck5kUERiYXAzOUY0WFhQTVFJM1ZH?=
 =?utf-8?B?aXFjUDdhK01Ua1B6cmdRK0dtNlVlYStPa21LQ0VYOHc4cFVMVllyRHJwZU91?=
 =?utf-8?B?eUFKM2RnSkFYWXhRRVM4d3pCNVBYOWdVZzlydHJucG5Ib1JaQjRQREtpakZ2?=
 =?utf-8?B?M0ViYXppQW82UTkzQTA1T3hTRjdyRUd4UDJudVMxb1VaN0x0dTRVMjhaUTUw?=
 =?utf-8?B?ckl0QXgvenJ5UW5USGZFWE9HN3BoMTJpRWFaSUlBTjhJQTE3SEZ5QW50SGls?=
 =?utf-8?B?dFErT1FZUm4rN3ZENFkxMlUrQzFVWHpMSmlTcnZhYUpoQjRmWGkxRHhwa2tp?=
 =?utf-8?B?QlNtMFIxM2NMbC9XQ3dMUEp0NENXSGNIWXZtRm9heFNtWnR3bE5hK0xNcC9N?=
 =?utf-8?B?SFFIRlJpSmJIcUdYWXFhUTBSWmNXVHQ2Qlo1QzA4eVRpNWwrelZUeHJCUEtj?=
 =?utf-8?B?aktlRTE0bFc4R3puWGNaMUJqN0JSZFl5OWpoamVrNWR5dGhGSVd4ZmxBeFZl?=
 =?utf-8?B?ckloVTBjZjRKRWN4MXBESlNqM1o4TnJmQjZMVDNwNmFXSlNTclNjMFFvYmdl?=
 =?utf-8?B?TGdEYWdvVER4OWhKa2dZTEhlRlVFemhPYmdCTHAxQVQyTnEvaHBTWGVWbTBh?=
 =?utf-8?B?T1d0NTBsZTNnQm1DRHlFOS9EQnp3aHFPRURkVzIrbDNFdWcrb2ZCNkZUVU5U?=
 =?utf-8?B?aDhHRnI3L0s5b211SnlYTk40azg4UUpDdWxrNHBtcllTVm52VThEa3kyVXF6?=
 =?utf-8?B?aGhLazErdFRjanJVOER2ajdnaGtRaTlVR0wvTU8zZmRESVRRODJnR2xGdEJL?=
 =?utf-8?B?VS9pVmJHeVRMdzNHSlhzbjFPdi9IMDVwNkdkNlhVWFgyR2ZLTG12SjZnSTQw?=
 =?utf-8?B?VnNxZTE3RmZMVkNUaG5NaGtqZjNMVjBUeVYwM3ZxUXQ2ejlKSmdpUUFjMGFm?=
 =?utf-8?B?d211WDgvT1JoTCs1NVVjMEFzOExpS2VlNEpKZDlzSUFrQVk1NjV1L3kzTmhG?=
 =?utf-8?B?Q0NCYzU2NWtsbVRRNXZDYnpWVnJ2cTVpd3hYZk1WSE1HMDAvL3JKQ1d1Rjc3?=
 =?utf-8?B?c3NHd1kxMEtaY3lmYmVsMXRwTEZmWmZod0N1MkF4NjdKZFZMZzMyMWFObjlQ?=
 =?utf-8?B?aTNDamlWc0luRC9QUEg1Ykg1eTY0dkl0VTdCK0NhSlVINGVoaElsZVRvRzVU?=
 =?utf-8?B?M0RTMU1TWHFSMGpxNTg3ZUdvd3NFUnF2Vlk3M00rNjJjODNOZHhlelhzYTJT?=
 =?utf-8?B?ZzVhYUNHbnNpRTZmV3FvM25ncm9LaDdSaldjWEg4enlTdDl3VkgzRFlRczMr?=
 =?utf-8?B?MUJmY1VpQVJhMzU0VXJEUThjbXVDWWNuNU5URGVrNks5WDB4K2xHTXJLcDd6?=
 =?utf-8?B?TFNyYk9PbTN0aGxlQThDWDhYWnBKVTZrUU4zSXBDR0RYcFh5dmtIL3lNQjhv?=
 =?utf-8?B?allXYWF3RlN1MDV2MXlKa0FJNUNOenVSdE1yN0syaitOR2hKOXpUMjNSTnZ6?=
 =?utf-8?Q?l5nD89W0WIEPsmSA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B920FDC2EDC88F40848B55B6E7414884@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB7125.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 754a477d-46d1-4a1f-415d-08de64e98d70
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2026 19:05:39.6207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7E/XZiu/Wo4s1M3UvtGbOtunhle1pSprMv/w1G7KxZQ4aHkOgqo6bLtAtsQMhjc7Wy3eHFJC/uVcyYuYVKuWt+oxyPzXep0ZzN4yc+lHBoA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5122
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70362-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[14];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vishal.l.verma@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 89E3DF6B1F
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAxLTA5IGF0IDEyOjE0IC0wNzAwLCBWaXNoYWwgVmVybWEgd3JvdGU6DQo+
ID09PSBQcm9ibGVtICYgU29sdXRpb24gPT09DQo+IA0KPiBDdXJyZW50bHksIHRoZXJlIGlzIG5l
aXRoZXIgYW4gQUJJLCBub3IgYW55IG90aGVyIHdheSB0byBkZXRlcm1pbmUgZnJvbQ0KPiB0aGUg
aG9zdCBzeXN0ZW0sIHdoYXQgdmVyc2lvbiBvZiB0aGUgVERYIG1vZHVsZSBpcyBydW5uaW5nLiBB
IHN5c2ZzIEFCSQ0KPiBmb3IgdGhpcyBoYXMgYmVlbiBwcm9wb3NlZCBpbiBbMV0sIGJ1dCBpdCBt
YXkgbmVlZCBhZGRpdGlvbmFsIGRpc2N1c3Npb24uDQo+IA0KPiBNYW55L21vc3QgVERYIGRldmVs
b3BlcnMgYWxyZWFkeSBjYXJyeSBwYXRjaGVzIGxpa2UgdGhpcyBpbiB0aGVpcg0KPiBkZXZlbG9w
bWVudCBicmFuY2hlcy4gSXQgY2FuIGJlIHRyaWNreSB0byBrbm93IHdoaWNoIFREWCBtb2R1bGUg
aXMNCj4gYWN0dWFsbHkgbG9hZGVkIG9uIGEgc3lzdGVtLCBhbmQgc28gdGhpcyBmdW5jdGlvbmFs
aXR5IGhhcyBiZWVuIG5lZWRlZA0KPiByZWd1bGFybHkgZm9yIGRldmVsb3BtZW50IGFuZCBwcm9j
ZXNzaW5nIGJ1ZyByZXBvcnRzLiBIZW5jZSwgaXQgaXMNCj4gcHJ1ZGVudCB0byBicmVhayBvdXQg
dGhlIHBhdGNoZXMgdG8gcmV0cmlldmUgYW5kIHByaW50IHRoZSBURFggbW9kdWxlDQo+IHZlcnNp
b24sIGFzIHRob3NlIHBhcnRzIGFyZSB2ZXJ5IHN0cmFpZ2h0Zm9yd2FyZCwgYW5kIGdldCBzb21l
IGxldmVsIG9mDQo+IGRlYnVnYWJpbGl0eSBhbmQgdHJhY2VhYmlsaXR5IGZvciBURFggaG9zdCBz
eXN0ZW1zLg0KPiANCj4gPT09IERlcGVuZGVuY2llcyA9PT0NCj4gDQo+IE5vbmUuIFRoaXMgaXMg
YmFzZWQgb24gdjYuMTktcmM0LCBhbmQgYXBwbGllcyBjbGVhbmx5IHRvIHRpcC5naXQuDQo+IA0K
PiA9PT0gUGF0Y2ggZGV0YWlscyA9PT0NCj4gDQo+IFBhdGNoIDEgaXMgYSBwcmVyZXF1aXNpdGUg
dGhhdCBhZGRzIHRoZSBpbmZyYXN0cnVjdHVyZSB0byByZXRyaWV2ZSB0aGUNCj4gVERYIG1vZHVs
ZSB2ZXJzaW9uIGZyb20gaXRzIGdsb2JhbCBtZXRhZGF0YS4gVGhpcyB3YXMgb3JpZ2luYWxseSBw
b3N0ZWQgaW4gWzJdLg0KPiANCj4gUGF0Y2ggMiBpcyBiYXNlZCBvbiBhIHBhdGNoIGZyb20gS2Fp
IEh1YW5nIFszXSwgYW5kIHByaW50cyB0aGUgdmVyc2lvbiB0bw0KPiBkbWVzZyBkdXJpbmcgaW5p
dC4NCj4gDQo+ID09PSBUZXN0aW5nID09PQ0KPiANCj4gVGhpcyBoYXMgcGFzc2VkIHRoZSB1c3Vh
bCBzdWl0ZSBvZiB0ZXN0cywgaW5jbHVkaW5nIHN1Y2Nlc3NmdWwgMGRheQ0KPiBidWlsZHMsIEtW
TSBVbml0IHRlc3RzLCBLVk0gc2VsZnRlc3RzLCBhIFREIGNyZWF0aW9uIHNtb2tlIHRlc3QsIGFu
ZA0KPiBzZWxlY3RlZCBLVk0gdGVzdHMgZnJvbSB0aGUgQXZvY2FkbyB0ZXN0IHN1aXRlLg0KPiAN
Cj4gWzFdOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNjAxMDUwNzQzNTAuOTg1NjQt
MS1jaGFvLmdhb0BpbnRlbC5jb20vDQo+IFsyXTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxs
LzIwMjYwMTA1MDc0MzUwLjk4NTY0LTItY2hhby5nYW9AaW50ZWwuY29tLw0KPiBbM106IGh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2FsbC81N2VhYTFiMTc0MjkzMTVmOGI1MjA3Nzc0MzA3ZjNjMWRk
NDBjZjM3LjE3MzAxMTgxODYuZ2l0LmthaS5odWFuZ0BpbnRlbC5jb20vDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBWaXNoYWwgVmVybWEgPHZpc2hhbC5sLnZlcm1hQGludGVsLmNvbT4NCg0KSGkgS2ly
eWwsIGp1c3Qgd2FudGVkIHRvIGNoZWNrIG9uIHRoZSBwbGFuIGZvciB0aGlzLCBJIGRpZG4ndCBz
ZWUgaXQNCm1lcmdlZCBpbiB0aXAuZ2l0IHg4Ni90ZHggKG9yIGFueSBvdGhlciB0aXAgYnJhbmNo
KS4gV2VyZSB5b3UgcGxhbm5pbmcNCnRvIHRha2UgaXQgdGhyb3VnaCB4ODYvdGR4PyBDYW4gSSBo
ZWxwIHdpdGggYW55dGhpbmcgdG8gbW92ZSBpdCBhbG9uZz8NCg0KVGhhbmsgeW91LA0KVmlzaGFs
DQoNCg==

