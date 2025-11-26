Return-Path: <kvm+bounces-64775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 08DC4C8C4D7
	for <lists+kvm@lfdr.de>; Thu, 27 Nov 2025 00:14:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7460C4E11CE
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:14:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D72230C611;
	Wed, 26 Nov 2025 23:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TbiyvZO4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A2030215A;
	Wed, 26 Nov 2025 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764198869; cv=fail; b=fS6ph0PPz3zMd3j6AMPfw6yh4x+aLZkXhV0H8130qfidq2zjjlUPzKbIsXYYjBkdYAqu56FF9fHGGTICcYQBnHLgFjXx7nwvQET/CV63s4zQ7M6OAVtqeIiKdh8Q6Bc01sUTKB1v4Rv2KkBawUynXw1NV2Q/AUx/bthfoePmVcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764198869; c=relaxed/simple;
	bh=45rP0KCRNFy/MS1I+N2SJDdo9kzvWySBeVr4ips3pt8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OKiVZAuA2G/de5k5Ebjun7hpT6gaUx1ijN84WpTTr4qZ0FTkO0yl3WhLRRIVRbUBdgJOIXwkZlwOpik9jgmlb6u0OP191wJQjBEdJRQHio/QYZGI0lTc4fqVMa1HJLEmxsQCoy8UBl09GbDw8WLhlDd5kV4LSjlFFfTZaiNmYWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TbiyvZO4; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764198868; x=1795734868;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=45rP0KCRNFy/MS1I+N2SJDdo9kzvWySBeVr4ips3pt8=;
  b=TbiyvZO4r3yDSiU/1mCVH40w/W4sNV2ClsNSWcn/c2iYIIceb/f8fLho
   3G4PlEBdhc1wEKFsnVpOLP9rXdPv0DYyj5sqhp2//yXG07g0FaCI+SLnj
   ZeqUhPYB7JXopn3cn2j7cADgVxNXj+poFkGn7w5vHLhonOmw02vSqWudE
   Kx560j7OyZIaHS2ILGDXO9jWVFTFrQx4vFvWRqePfXLJnKKqAa5GpG9Iq
   55/O5P4aMb3QsO41zc4ljYaS/B8BsBHSL1z/xqaqnDlvEN8t0JJ1uNxPO
   uWjk7wlC3wU1qWIRwxPZJpH8uxt14JNS5Huv818Za6XOCj7kRk4nKCKZM
   A==;
X-CSE-ConnectionGUID: POkjEacWS/+92tIcd0VsBg==
X-CSE-MsgGUID: 48AEeACnTq6fDjBlAEZylA==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="66137869"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="66137869"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 15:14:27 -0800
X-CSE-ConnectionGUID: jR4ZU7ZSTOeVwkZ0zN0EDA==
X-CSE-MsgGUID: f1z3HCpSQdmiOqDQCuV6mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="198189450"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 15:14:27 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 15:14:26 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 15:14:26 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.10) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 15:14:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekLYnrEYjQwPRDJiX6/4zTXUqAOyAtAbB6SZfmp1CB+qrHrAQqmKXrIigmJerWtiqMqGF1oKDeEMuUmdmm/OcEISVa8Pb/7EJndepQhWZUGpWH/bJwLAO/0vtj0QedYnWppqih+ZjQlu5RizoQQCNjxNZF0GFjQ8OzB56PMLe+/vuemTKbWQncppqI3BUpoAW5e83PIFYKS1o9G2iV+CtIy7TKI1n6bHTkZB6Dy0LiACwxPNqR5my9wsSRuKqn3noD9Q2zS7wqo885/mWSwsdudfex3COukc2p0iNTfFBwMpEwKIF3VCGNoAbIvrY5iNPHmVTLgnbz/JzRCYdy0Zig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45rP0KCRNFy/MS1I+N2SJDdo9kzvWySBeVr4ips3pt8=;
 b=av9CtT4th3pKqea9iArTFRcmVGLKHWjlbPnnoQJ7xhGmFWS93uw7mVHrXo+8QrLK5m/bgOHps3nLiGrfHTs0yCYBLSvhWTiQRs2kW/MZFTznttFvrL+4CU6LHxNHZDVzG1BrQXu1Aj1F9wLKQ7o9D36RUqycToVHmn9dTEcVqw9l2Yv2FNaSEJBk7eRbz5wwAFqGqYdBZDbQQkmaQXA3uqayP/JyGWSoH0fw0RRLXC/5Xb+cnbH0R1ft5YL+xzbVaegEGE0TodIpmp71vXshVt1r3FD9HbN2CsBKMSdxqZ8W5+KhXZXo55V+s+h+CGUR3EMRurvnsCZrJqBWl2QKgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8522.namprd11.prod.outlook.com (2603:10b6:806:3b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.13; Wed, 26 Nov
 2025 23:14:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 23:14:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v4 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Topic: [PATCH v4 01/16] x86/tdx: Move all TDX error defines into
 <asm/shared/tdx_errno.h>
Thread-Index: AQHcWoEIto+2L4vuwUu4TSstnaj7zrUEARkAgAGesQA=
Date: Wed, 26 Nov 2025 23:14:23 +0000
Message-ID: <77d07725eac2d6b156685840018c4fff93871734.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-2-rick.p.edgecombe@intel.com>
	 <6968dcb446fb857b3f254030e487d889b464d7ce.camel@intel.com>
In-Reply-To: <6968dcb446fb857b3f254030e487d889b464d7ce.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8522:EE_
x-ms-office365-filtering-correlation-id: 7a77fcb6-d820-4a02-6b4c-08de2d418978
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Mk1xNjUzOXplR0pXSWhhQzBvaU4rQmgwM3Z1Z3B5Z3ZvSERHcmVobGNzc3NE?=
 =?utf-8?B?RWJWSmhJUjN1ZXZNTzJlcFNKbDAxNmtVNVZRdDQrVlRkcW1ySnJMcUZVYnNj?=
 =?utf-8?B?SFlKVldvRFhXV1RheUlnYVJQZmNuQjJDbFVTbFp3citBclhaR2hIeUp2cEMw?=
 =?utf-8?B?UlljRkc0cktMb05jYXBOczRrWWk3S1E5UmVDZ0lZUWtnN05sTG15RXgvdDNP?=
 =?utf-8?B?c1lYNFRCOThuaHhmMkdveWJxemVpWTUvcXJJM0Y2R25FblArSnVXWXVkSWsw?=
 =?utf-8?B?WWMrRlUzV2VxVFBCbUtZTHBLcnVvVlZ6R2RqTjFMUnIzTWtBRm5XbTZMYXM3?=
 =?utf-8?B?QTlIRzhIZk8rdUlPcUNaZVNueEUwMTBhMWFPamRyOTRqaFJlQ3RCUEJpdE9G?=
 =?utf-8?B?VUgvMThBZ3J3Q1JlNGc5UXoyL2hpWXRHK2JIcjFhSEF0YmFnZ1ZQaU5FTkl6?=
 =?utf-8?B?SnBxUmlTZXdwc3BPWTNFRXg2NHRaR1dEM29PQytseUcvRDgvZmhJV0NNSmdS?=
 =?utf-8?B?Tk91ZEVHeVdleUF6WEdXTzcrUzJZc0cvekRoRTdDa1UwUUZQemlqVll6aVFZ?=
 =?utf-8?B?RkQ4TytlVkNUTXhWbHZVd0R3Q3g0ZDN1dEoxODR1SmdVcWRDZ3BWNGtIS0t5?=
 =?utf-8?B?MzhpZWJCQ2RWT0l4b0lsb0RZSVFvSnFTb001V3ZoMW10Z0s3TXlWVkR3QzJz?=
 =?utf-8?B?NlV5VFJBL0RaZ0dYbEx2V0FjeFZsYkxMb0x0ZjVjK3RaNWZNWXBjaE02UU40?=
 =?utf-8?B?QU5zd1Z5VU9tQjNWTXdxM0I3UHk1WGQ3c2tSQzNTS1hNU0lEQnNFQWhOaWJJ?=
 =?utf-8?B?Vm5PUFZRaFBOTC96Sk5ua1JwZUprRXluWFNvc1dOQkdtSUFva3A4d3lhS2pj?=
 =?utf-8?B?dW5Fc3JQUGNxOW1UTDc4U2xWSmlkRGh6N3NoNExiTG5wU2tjNGlmMFpDcEdm?=
 =?utf-8?B?L0NpZFpZd2hqK3RlNlBQM2dMN0tySFVmV0ZsYWp5UjdHalRGdDNzZWpkM0Nk?=
 =?utf-8?B?YUlhSThzQi9SNW93aEIvS0N2cEM4bXhPZ1pHaVhGZElEUkpHK016MUZvODUz?=
 =?utf-8?B?S0kwU211R1ovaVJQS1VZZHYvUHVsRnJhRWNlNHI0QW9LVU9LdU9WK3F5T0pY?=
 =?utf-8?B?U0oyNkNISGd6bGRGcU1HRG0xRG9uL0wwY3kybUZzVUFXdTZobjRlelRuWFNU?=
 =?utf-8?B?WGNnQmRFR3JpbnZqUG40UFBETFgrS1BiMWNYZG85MWJBTjVxTVB6aysrbjhr?=
 =?utf-8?B?U0E0RGtvSU05eXJiYlJOTzRLZm5RVzkvaFEzOG5kbC9yQytEVE1tRTVoM09T?=
 =?utf-8?B?UUx6M3I1T0NIcGhDbnNmT0NCcWluVFhuRi84K3hQQ0VyNEltL0NlSEZMS1h4?=
 =?utf-8?B?Q1NXRHRSdCtEN3BxTWtvZzRpa3Q4K0ROVVBUVmZGdUw5ZXBaemVsVVF4K0FB?=
 =?utf-8?B?dEx0YjdRcDVHRGVuQnNRVThLRDdXMzBCczZQd2FOSGVjWVhjRnE0M29BSFN6?=
 =?utf-8?B?NzczOW12OGVGbFJRck52UXhodEtZYjBJL0N6bWdEQ0RKNWsvN3dHWm9uV2I1?=
 =?utf-8?B?Zm5FSjhlTGl1azY1Q0Z2Z1lXNCt1UzVhdzNveDEwZEwyT2RVd1p1YjJMbzRE?=
 =?utf-8?B?blpTN1p1dXZkZWQrSFhLeXlwOVpKRFdDKzk2R0FqT0hUeXJVcTdxUDBwQktm?=
 =?utf-8?B?WHJ6UVpvUERJajhJUHVhbXYzaFdXK0pPb2JEb1dqMnhKcU9MQ0k1MjZhSUNQ?=
 =?utf-8?B?TFVsOUxFQklaa2lqU29IbTZUOE15bHEveUxwZVBLdm1qdHRxVTRBYnd6SFh1?=
 =?utf-8?B?c3VVY2JmS1ZBckVqOGdsbUpvSmRFWENIKzhQbm1JemJETVdBUDdKUUFqckVp?=
 =?utf-8?B?MlA0NTFrMlFXY3FKT1JVRURMR3dwRk1XNUZrYXBEclR0TG5JQUQxQWpzMEUr?=
 =?utf-8?B?aUM2QXhCdTFyY2pEV3BBTDMrQ2ZiNnkxWElHQm1yUEQ5Y2ZteS92WFhONTFh?=
 =?utf-8?B?RjIwR2puVVZzdEpiNWNXb1d6NWpWekNLUG45aG5XakRYTThZdkN0RjZyZE9D?=
 =?utf-8?B?UkthVVVlNkpVWFcvbzlqbVo3R1VNbHRKbEJFdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QTkxV3RBTEFvbFBFUEZPWkdXbVNwVHdSSlBUbzVrU3dKNjA1WklKb1J5QTlM?=
 =?utf-8?B?eWNtMVh0V1pKRnMvN0xxTXFoY3hmZ1dxQTJqY1M3bm1DcVA3MnJ4SW1WRi9G?=
 =?utf-8?B?Z1VDU1FiQVA2NEFNRmE0ZGZCUEZvelR4VlhMM092aUVzNzUvbnFyZUVOTmJR?=
 =?utf-8?B?UkU3VUJZTUVlbGRPRStBSGNZQjJ2dTNLS3NQcXBMblRQWFdua21lc1pFOVRJ?=
 =?utf-8?B?ZllycHhOa0Rmb0hvTmIvdVdQQmE5eitJVDFCYlRXMkhrS1l6bmVXMko0T0Iy?=
 =?utf-8?B?ZGJEV2N2aDJ1YmdwSlJ6cWRMZDhBaXJENEVNYWxja3ptK0F6amF1ZXVkbTJa?=
 =?utf-8?B?b05nR05VTjhRVjVHMDAvSkp2SzVsZjNySnNDVjhtVUFqTDdoNjBMTDZmN05S?=
 =?utf-8?B?d09UR3B3dWRlVGNFT2cyM0JzT1NPOXZkT2lXVlpxc3BReW40QTJpL1owY0Za?=
 =?utf-8?B?dVRIeWUrem9yU1ZjZnVzOW5rYVR0YmkrOVBBM1pjVDdFVTJvS1FVTTJzV0w4?=
 =?utf-8?B?MmhtYkNQWHJ2NXE5UktScTZQWThOZ25CVHdGYjJDNlRGbjdRZnc0aENIbHEx?=
 =?utf-8?B?cFhqUnNFQkRtZXJIWjVPUndoS0FBUUp4TkNtcGsyWGJVbXRoVERvbFpUY29w?=
 =?utf-8?B?QWVqZzhRQ1JML29vckpSVFZldTdCZytheXd1T1VuWWI2Y2hqeVdkMWFCaEZ3?=
 =?utf-8?B?MmJ0NDB1WmZpN2FPaVhIazY2MnBWdE5NMlJ3eEprQmdWTzRxRkE0NFQ3dVZv?=
 =?utf-8?B?NFd1M1RpVjJneEFpMWQ3ajM2MFk5dGd3Wnp6ZW0zQUZ1bTk4eEtyVEFBZ25X?=
 =?utf-8?B?Zi9mcmc5RGZRdndndklaZmd4UUQrZEJzd1grOCtPRmdDelZnMngzMmlDcEFw?=
 =?utf-8?B?Y3F2eHNRSmtqQzRsbmswa2hPSEJwT092Z0c4T3JZdThFY3dRZGFkVzgvbzZq?=
 =?utf-8?B?am5uRm5WUzlaVWNCQU1hcnZoM01LYVQxcW8yQzk2NGpFbjBYaHhoSkEwRFVn?=
 =?utf-8?B?dU5rc3FaZEdKcnlOU0RFZWV3dXJ2Z2UvbmV2dExaRkh6MHlFZFVURTdqYTZZ?=
 =?utf-8?B?ZERXQWMyVjhPQ1FlYUhrQnNkako5Nmd5Ujg4aHMyN2pkanAyOHpGVm1BZCs3?=
 =?utf-8?B?TWtHbTB6cEFwZWJadDQzQUJsNVAyQW1OaWpWSFZwSmQ2Q0pOTmVKRU54a1RS?=
 =?utf-8?B?VWhBL2ZoQ3dqNW9SbVdWWHU2TG1rSTRSZGswbnA4U2RKK3hERmxiMzh1MmRv?=
 =?utf-8?B?WE9Ua1hBWXRnNVRZazdPcFA4aGtzVC82blBFTE9kNFVhSW1xOXlzZk5zbHYz?=
 =?utf-8?B?OFVBOFV4dHJiUzNkVXNjSkFjSXNCdGNEQU1ZZ3d2OWtFQTFaVFphS0JGVi9F?=
 =?utf-8?B?U3dmVmxVUmNZQXlUUjFnaWZ4amFER0FjQ0hGSjdCT0FCMU9OdmFCM091NW9n?=
 =?utf-8?B?YWNmSXRWOWtpc2JOMk1BRkxMM3pkTlJIdFU0TDR0aGpnRHVrYm1KMDErS2R3?=
 =?utf-8?B?aDBpcmg1OUVNbmtieFM5VlVzeEVQQ0gwRDRscVVjSWQ5bm1WTEdqcmdIWEp5?=
 =?utf-8?B?TVZ2TjBMUnlnMGF6TjIrNXg3c0Z6NFJrek95dEFNeklreXdTMTl1TDRMeW1H?=
 =?utf-8?B?MVZZYnNjY2x5M2llY0w4UVN0T0UyQlR6WEZjeFhMZ2JYQU9Pc2F2NDJEaUpZ?=
 =?utf-8?B?K0p6ckc1ZTYyRXQwSFlsOXhMSmdTOVovTVg3bWhCL3cvRzhxNC9CVlpObm4v?=
 =?utf-8?B?dmhWQlpBb1FWQktkL015c05DeWhpM0RkalZwQjR6M1d6SlB3Z1JuNllMWGtB?=
 =?utf-8?B?VHRuUXNiWkdLcnFIZG0wNU1YRzFxQWJUdkYyRklXMFIwTG1zclQvbEd2dFpy?=
 =?utf-8?B?UWhoZWZwbWJ0WVlrUnJCYWlETGkwRmlUbzBxdDdHVGtqVzRKeHE4ZTZnaU5x?=
 =?utf-8?B?UHBheWJZeDBzOGg5VE5zYmY1ZkF3MlRzQ0M1aW1sR3JXZSttd3FUMERWTldU?=
 =?utf-8?B?M2J2aE1veUVUMHVhMityb1IzR3JMbmRaUmxNaGs2ekdIREpuYnFTbndmdDJH?=
 =?utf-8?B?ZThERUNFQkxoRzUrRnBsU01yMDQ1akJsZFFDMUNIdmVvS2JlK2VVazVDVjBJ?=
 =?utf-8?B?cTdyUm56QzhsdTRsVnRvZlBTTTFNZ2w1MkcvcDhTZXVaalhTV3hPTUh5SjBh?=
 =?utf-8?B?M0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A086AC62E7C05640A8993836B26696B7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a77fcb6-d820-4a02-6b4c-08de2d418978
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 23:14:23.5231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qEL6xbkcazSrz7YlnrlgaQBr5rBUqPIJeyVqSPVZeg5asA9wQZvlqw1dz7VRGdDgyvAxGWUmMaFlRkyAAJXqFPV8kyQnGvdhdc9gLedZl5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8522
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTI1IGF0IDIyOjMwICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4X2Vycm5vLmgNCj4gPiArKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9zaGFyZWQvdGR4X2Vycm5vLmgNCj4gPiBAQCAtMSwxNCArMSwxNiBAQA0KPiA+
IMKgLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAgKi8NCj4gPiAtLyogYXJjaGl0
ZWN0dXJhbCBzdGF0dXMgY29kZSBmb3IgU0VBTUNBTEwgKi8NCj4gPiArI2lmbmRlZiBfWDg2X1NI
QVJFRF9URFhfRVJSTk9fSA0KPiA+ICsjZGVmaW5lIF9YODZfU0hBUkVEX1REWF9FUlJOT19IDQo+
IA0KPiBBRkFJQ1Qgb3RoZXIgZmlsZXMgdW5kZXIgYXNtL3NoYXJlZC8gYWxsIHVzZQ0KPiANCj4g
wqDCoCNpZmRlZiAgX0FTTV9YODZfU0hBUkVEX3h4X0gNCj4gwqDCoC4uLg0KPiANCj4gSSBndWVz
cyBpdCdzIGJldHRlciB0byBmb2xsb3cgdGhpcyBwYXR0ZXJuLg0KDQpPaCwgd293IHlvdSdyZSBy
aWdodC4gV2lsbCB1cGRhdGUgaXQuDQo+IA0KPiA+IMKgDQo+ID4gLSNpZm5kZWYgX19LVk1fWDg2
X1REWF9FUlJOT19IDQo+ID4gLSNkZWZpbmUgX19LVk1fWDg2X1REWF9FUlJOT19IDQo+ID4gKyNp
bmNsdWRlIDxhc20vdHJhcG5yLmg+DQo+ID4gwqANCj4gPiArLyogVXBwZXIgMzIgYml0IG9mIHRo
ZSBURFggZXJyb3IgY29kZSBlbmNvZGVzIHRoZSBzdGF0dXMgKi8NCj4gPiDCoCNkZWZpbmUgVERY
X1NFQU1DQUxMX1NUQVRVU19NQVNLCQkweEZGRkZGRkZGMDAwMDAwMDBVTEwNCj4gPiDCoA0KPiA+
IMKgLyoNCj4gPiAtICogVERYIFNFQU1DQUxMIFN0YXR1cyBDb2RlcyAocmV0dXJuZWQgaW4gUkFY
KQ0KPiA+ICsgKiBURFggU0VBTUNBTEwgU3RhdHVzIENvZGVzDQo+IA0KPiBOaXQ6DQo+IA0KPiBJ
IGRvbid0IHF1aXRlIGZvbGxvdyB0aGlzIGNoYW5nZS4gIEp1c3QgY3VyaW91czogaXMgaXQgYmVj
YXVzZSAicmV0dXJuZWQgaW4NCj4gUkFYIg0KPiBkb2Vzbid0IGFwcGx5IHRvIGFsbCBlcnJvciBj
b2RlcyBhbnkgbW9yZT8NCg0KVGhpcyBjaGFuZ2Ugd2FzIG9yaWdpbmFsbHkgZnJvbSBLaXJ5bC4g
SSdtIG5vdCBzdXJlLiBBRkFJSyB0aGV5IHNob3VsZCBhbGwgYmUNClJBWC4gSSdkIGJlIGZpbmUg
dG8gcmVtb3ZlIGl0LCBidXQgSSBkbyB0aGluayB0aGUgUkFYIHBhcnQgaXMgYSBiaXQgZXh0cmFu
ZW91cy4NCkJ1dCB0aGlzIHBhdGNoIGRvZXNuJ3QgcmVxdWlyZSBpdCwgc28gaGFwcHkgdG8gc2hy
aW5rIHRoZSBkaWZmLg0KDQo+IA0KPiA+IMKgwqAqLw0KPiA+ICsjZGVmaW5lIFREWF9TVUNDRVNT
CQkJCTBVTEwNCj4gPiDCoCNkZWZpbmUgVERYX05PTl9SRUNPVkVSQUJMRV9WQ1BVCQkweDQwMDAw
MDAxMDAwMDAwMDBVTEwNCj4gPiDCoCNkZWZpbmUgVERYX05PTl9SRUNPVkVSQUJMRV9URAkJCTB4
NDAwMDAwMDIwMDAwMDAwMFVMTA0KPiA+IMKgI2RlZmluZSBURFhfTk9OX1JFQ09WRVJBQkxFX1RE
X05PTl9BQ0NFU1NJQkxFCTB4NjAwMDAwMDUwMDAwMDAwMFVMTA0KPiA+IEBAIC0xNyw2ICsxOSw3
IEBADQo+ID4gwqAjZGVmaW5lIFREWF9PUEVSQU5EX0lOVkFMSUQJCQkweEMwMDAwMTAwMDAwMDAw
MDBVTEwNCj4gPiDCoCNkZWZpbmUgVERYX09QRVJBTkRfQlVTWQkJCTB4ODAwMDAyMDAwMDAwMDAw
MFVMTA0KPiA+IMKgI2RlZmluZSBURFhfUFJFVklPVVNfVExCX0VQT0NIX0JVU1kJCTB4ODAwMDAy
MDEwMDAwMDAwMFVMTA0KPiA+ICsjZGVmaW5lIFREWF9STkRfTk9fRU5UUk9QWQkJCTB4ODAwMDAy
MDMwMDAwMDAwMFVMTA0KPiA+IMKgI2RlZmluZSBURFhfUEFHRV9NRVRBREFUQV9JTkNPUlJFQ1QJ
CTB4QzAwMDAzMDAwMDAwMDAwMFVMTA0KPiA+IMKgI2RlZmluZQ0KPiA+IFREWF9WQ1BVX05PVF9B
U1NPQ0lBVEVECQkJMHg4MDAwMDcwMjAwMDAwMDAwVUxMDQo+ID4gwqAjZGVmaW5lIFREWF9LRVlf
R0VORVJBVElPTl9GQUlMRUQJCTB4ODAwMDA4MDAwMDAwMDAwMFVMTA0KPiA+IEBAIC0yOCw2ICsz
MSwyMCBAQA0KPiA+IMKgI2RlZmluZSBURFhfRVBUX0VOVFJZX1NUQVRFX0lOQ09SUkVDVAkJMHhD
MDAwMEIwRDAwMDAwMDAwVUxMDQo+ID4gwqAjZGVmaW5lDQo+ID4gVERYX01FVEFEQVRBX0ZJRUxE
X05PVF9SRUFEQUJMRQkJMHhDMDAwMEMwMjAwMDAwMDAwVUxMDQo+ID4gwqANCj4gPiArLyoNCj4g
PiArICogU1ctZGVmaW5lZCBlcnJvciBjb2Rlcy4NCj4gPiArICoNCj4gPiArICogQml0cyA0Nzo0
MCA9PSAweEZGIGluZGljYXRlIFJlc2VydmVkIHN0YXR1cyBjb2RlIGNsYXNzIHRoYXQgbmV2ZXIg
dXNlZA0KPiA+IGJ5DQo+ID4gKyAqIFREWCBtb2R1bGUuDQo+ID4gKyAqLw0KPiA+ICsjZGVmaW5l
IFREWF9FUlJPUgkJCV9CSVRVTEwoNjMpDQo+ID4gKyNkZWZpbmUgVERYX05PTl9SRUNPVkVSQUJM
RQkJX0JJVFVMTCg2MikNCj4gPiArI2RlZmluZSBURFhfU1dfRVJST1IJCQkoVERYX0VSUk9SIHwg
R0VOTUFTS19VTEwoNDcsIDQwKSkNCj4gPiArI2RlZmluZSBURFhfU0VBTUNBTExfVk1GQUlMSU5W
QUxJRAkoVERYX1NXX0VSUk9SIHwgX1VMTCgweEZGRkYwMDAwKSkNCj4gPiArDQo+ID4gKyNkZWZp
bmUgVERYX1NFQU1DQUxMX0dQCQkJKFREWF9TV19FUlJPUiB8DQo+ID4gWDg2X1RSQVBfR1ApDQo+
ID4gKyNkZWZpbmUgVERYX1NFQU1DQUxMX1VECQkJKFREWF9TV19FUlJPUiB8DQo+ID4gWDg2X1RS
QVBfVUQpDQo+ID4gKw0KPiA+IMKgLyoNCj4gPiDCoMKgKiBURFggbW9kdWxlIG9wZXJhbmQgSUQs
IGFwcGVhcnMgaW4gMzE6MCBwYXJ0IG9mIGVycm9yIGNvZGUgYXMNCj4gPiDCoMKgKiBkZXRhaWwg
aW5mb3JtYXRpb24NCj4gPiBAQCAtMzcsNCArNTQsNCBAQA0KPiA+IMKgI2RlZmluZSBURFhfT1BF
UkFORF9JRF9TRVBUCQkJMHg5Mg0KPiA+IMKgI2RlZmluZSBURFhfT1BFUkFORF9JRF9URF9FUE9D
SAkJCTB4YTkNCj4gPiDCoA0KPiA+IC0jZW5kaWYgLyogX19LVk1fWDg2X1REWF9FUlJOT19IICov
DQo+ID4gKyNlbmRpZiAvKiBfWDg2X1NIQVJFRF9URFhfRVJSTk9fSCAqLw0KPiA+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3Rk
eC5oDQo+ID4gaW5kZXggNmIzMzhkN2YwMWI3Li4yZjNlMTZiOTNiNGMgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS90ZHguaA0KPiA+IEBAIC0xMiwyNiArMTIsNiBAQA0KPiA+IMKgI2luY2x1ZGUgPGFzbS90
cmFwbnIuaD4NCj4gDQo+IEkgdGhpbmsgeW91IGNhbiByZW1vdmUgPGFzbS90cmFwbnIuaD4gaGVy
ZSBzaW5jZSBub3cgPGFzbS90ZHguaD4gaXMgbm8gbG9uZ2VyDQo+IHVzaW5nIGFueSBkZWZpbml0
aW9ucyBmcm9tIGl0LiAgQW5kIDxhc20vc2hhcmVkL3RkeF9lcnJuby5oPiBub3cgaW5jbHVkZXMg
aXQNCj4gZGlyZWN0bHkuDQoNClllcCwgeW91J3JlIHJpZ2h0Lg0K

