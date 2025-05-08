Return-Path: <kvm+bounces-45830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F58AAF104
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 04:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1B3641BA2C0A
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 02:11:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15851D6195;
	Thu,  8 May 2025 02:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nUXFfZnj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F193319C542;
	Thu,  8 May 2025 02:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746670248; cv=fail; b=pVq3WD2ES0/mrsucIrfWuCO8V1D++p0wXfv6CFm2u+fKmpP018W+jZRh91Gy6H6D15EDuLVs6kgpT5B749sfABXsIb3QRF+jAW82SNcaWzMomGNxjpwZilIeEz5qRJ87fpTucLpgQKSMby8wVMXk0p/5DWHbZLs/h+xOTB7tL2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746670248; c=relaxed/simple;
	bh=kptdpzreFG80DXEB8ZO7Kb/8LI2lX/fdeFj9uoCftHc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=khB5lw+DEqeQeoKnBjyN6moUYJWjUKqGQXxFMPYEtiYWkqBBiDcUy6kNe8US+EWKikN7rKpyFubR/Zdmm8oNOMQRBX/p/p4uOacWxmGrOPz4AURD5G7ZO7fTL9aLsz1dBEt+uElA7P+/U1GWYSzP8Ji/mbCs5eMBaVX865om4A0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nUXFfZnj; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746670246; x=1778206246;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=kptdpzreFG80DXEB8ZO7Kb/8LI2lX/fdeFj9uoCftHc=;
  b=nUXFfZnjOk0XwhaH3dQmlY8H0uL5VJu57hrKH9WeqMbMIBBfT5ypenvK
   o1OUAzP0bmhLhywqdBcGnmyKqbpLogTZwgV+XAkZHIBZU5UWIduMjosk3
   R09T91hrJ0wA3I9GgqwcvJ6D/ue8eKab6R21X9w6e2mzAdEJ0DkylBLKs
   401w2ykyTeAuUvDRaerzTNIQOq6b3MFJwRFzqmgyvQL9MLJ+1wPjb52MA
   O36au9OtbeM/jrXBwBbiPjgod5JzYcjM3tulF8GnHM1H7TVbbIESNYRqe
   PdvNoZkMLGZGOzOmuV3yvTDAbFBEThApCfthj6eEClIAGho7j8N3euwiP
   Q==;
X-CSE-ConnectionGUID: PvbK3UySRKOKxehNdoeyKw==
X-CSE-MsgGUID: TLJFyPF5Qdu4rQXoHRcBDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="65963752"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="65963752"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 19:10:45 -0700
X-CSE-ConnectionGUID: bpK3+Ah6T3+By+1uKT1vzw==
X-CSE-MsgGUID: tB/PT7WRRF6BBLuh4YGVoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="136537810"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 19:10:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 19:10:44 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 19:10:44 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 19:10:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpBJ4Fft02Ieo7sEHGS26LuNiDzu5LabPQjcCgx6jSZEdHtOClVaz1LFwCU23haZ9mCLCpr5rb5YpAD+cQi1ibqpSklwDaE1GKl6hk/AvdzQsJalSdrxuWQrfKum7mOQNo4DvBQrGEcyy13hol67XOirjDq6vA8F0277OSjB3Sf/47iLiPLFigxeE5ykn/I7NUKAFXjnIiVif+CKwQlReTu5VkYPKGhDz4EVIOqYE/S4MkKFalXPFASZ43atRc3y1AOH1Rrtf2xNCt4UL0HwZNAp7ZTx2pHGZsrE0oLx5Q7jqnQeyh37P2pJ7lNZulRGPHT9rtTXDjLEdaxX5wKw7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDvpG8fPFeFMkIJnvJ+DaxB5f/iUsFvRbPskRBplEfc=;
 b=lIbNnaxhAWefRsBfzCqqmG9NnVLkqflJudNfDeBiBuAmnVRvDKDFk58uzpSewxa+A7EXWG/n5GsF6jH+IpplDVkFoGzxPQeFnbsBmrEELZZjVIG4rMagN6MoPzDGbTVrFcmn/7w7rouVQKFtz9mAOpNwoYCCog4iCUlE1lampNzTMtypDX6gBMnHvMV5HA55H0gnLIzFPoq7BHe4cBUWQ7gDjxDhR9qDn0RP2jc1RP0d7TNSb9WETb8j/sWw8rDX0vTvQgJa3qnavow91i2+N8CePpDRgiGVWEmcyJu8fsrYQjbNz2inakQEy57G9+g903M/kRdmbC09g/foQFW93w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH3PPFE994B740C.namprd11.prod.outlook.com (2603:10b6:518:1::d5b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.35; Thu, 8 May
 2025 02:10:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.020; Thu, 8 May 2025
 02:10:34 +0000
Date: Thu, 8 May 2025 10:08:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
Message-ID: <aBwSICZBrgiKX2UF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com>
 <4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4bb2119a-ff6d-42b6-acf4-86d87b0e9939@intel.com>
X-ClientProxiedBy: SI1PR02CA0009.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::10) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH3PPFE994B740C:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e31e930-59bc-4f42-06d8-08dd8dd58415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4Y8RF7Ow6CS5YrEBkafuDi0te31FUMTsaYrw9cHZcTvItRlEPq/Sv/bipV2f?=
 =?us-ascii?Q?B7E4lHfAl0FxjYi2ZX84OFXwK/eKmdwStxi/IS+hpZHlR9QJQivgkuw65kb3?=
 =?us-ascii?Q?HHg5cI1P84iqU9piVoIb5n6Q5kNQc8Oz0be2da4eklTuka84giXNDnRK+xIF?=
 =?us-ascii?Q?6Tr4Ng6/q5cyTsRuKDeO9vihZnrNosL9ykRSvXhkoiF+hG1M+jZz/v5zNYKC?=
 =?us-ascii?Q?j8v6xsOmZlF24wItNuhkiu8X4/+af5Qx2GnWGu9r5758knZbUN2jiOskfwUB?=
 =?us-ascii?Q?HpQg08CLzjbUnVkGXEfNeZCAliTa/pNYJJsYkmsr3xwd2IS24xAXSq2Mq9/F?=
 =?us-ascii?Q?kpdPSdBhO87JqhT9ux5ONU7yVRHR+iJeue/c3Ks2ZfFirPyH7iw1YBvjlsUa?=
 =?us-ascii?Q?XJ5FYYnTriNsjdHRn5U0eIwOc+O+Mts2FOGEM9vE15fY2SINE+wHVwpBRt2/?=
 =?us-ascii?Q?4TdHuPx+5TOLtGOMCgRxa+6xlvxDpmo8pYCknPM4yEavAanVoMKsYMy7LKdK?=
 =?us-ascii?Q?AwaJB5gZp8TLVUII4B3U9bvFKvtW4IWfg3xgukBDNVlI/nltUazvOPvmq4jr?=
 =?us-ascii?Q?1PNd+hfepS3Nc8Xmy3aHe34J4Om3tU9ys08Z4NmJ1VTPI3MAgs5eG81A7u1J?=
 =?us-ascii?Q?qzbT/fkznAanIg58UWreWEdyXTA45eX9t4cr58+rtMV3TIVrY6lzoIKUEoJm?=
 =?us-ascii?Q?1mvrWNOnfi8CA0F+W5j2lAEsbUfgi2tqCyiPPZatHYkdP2nteJX0LHqwbzqF?=
 =?us-ascii?Q?bIZ9HFdu4AHfRxzhUurw2ppE6twsFlZRQ7cQZKl3Jem/8cTuLuJikHTxPMNC?=
 =?us-ascii?Q?P5U5NFPI/83gy+e5CiAyfT2QMVtmSm3IrsHA4K99dyRGJ005K7CSpLEiWlCp?=
 =?us-ascii?Q?weRCeMPuow/LtZEPtub28dpG0exrnSCoEYYf1qpjInjDz7CGJVqE7LWj0CkN?=
 =?us-ascii?Q?dK9dCDHZmvuO3ugbSUyrYU76/g+6dS3LpbfOPASPJzOyfaYUsovYto+EvgOn?=
 =?us-ascii?Q?osozTHNrThebHiukoPKAveKtVWRACymtVpWNRvaX87Y7ME0md3XS56eKY2U8?=
 =?us-ascii?Q?08hLrIBcb/dFztP+1Qa119BZq61tGZs+ooyJ8ws3QlHao9veNsJVrmpOecEO?=
 =?us-ascii?Q?DHz8rRPAmiqDNxKmYAg5JMEIEv4M4ttMnQKhXrp30EN55gl8GdrBcpC0SVyR?=
 =?us-ascii?Q?1Iojq+tVOLUHGggeiQL7p1eLF293JcntGhL9B0KXz+Wfw2X4rMtLa4azp8B4?=
 =?us-ascii?Q?LE1X04lgYZ7cejSI6+Szax+/HtknnzVBuO+BGUQFJ0tYLMyx6KvtMKoQ91q4?=
 =?us-ascii?Q?8eOaYjF+aiiBdhZFUVjuL9gfKCk1zA/fdomxrmCdwxLOkbRK60dfgaEl8G+R?=
 =?us-ascii?Q?ecAAUhNv7eHJao0n8RlARze12gKSByNiOSwpalfCaqHuHtZ9TuJbsa5htXBp?=
 =?us-ascii?Q?9Ynywwd2LaM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ei0nZPMkQna6IgywxHfn8usJ24gA1Q3nd9GfdzQCPNnSut4bfdwiWS4xk8Nl?=
 =?us-ascii?Q?I7EOe0glDwqnOOcfXl8xSQ118ZvQS6RZ4hl2eg6ceEhlN162vHY9NE11kwbQ?=
 =?us-ascii?Q?pw4yLGedM/HxwG1KWN8WXQB2qI0Fih3pbR8fzEMSq6jYrZzkJOojo2ZR5mbE?=
 =?us-ascii?Q?xXMltaYkK9nh1+w+6ulq+n8vBVau73Zw7YXehCFQ4ir7/goNV8cpfI4Pjl6t?=
 =?us-ascii?Q?TFaKEZ/eTwuVSXJYr0pOscWFKgUifjezM3FSQgGkf9kq9TuB5O9pD8ivkE3Q?=
 =?us-ascii?Q?+Mauny29wAM563VUv+Gy8Y0BbNoak/3EHphgVfc2/BboE7iw5o5oznWFG1Q/?=
 =?us-ascii?Q?h72sRGS46KAnbcdATRFIsSeuoN9X4wIb1q9y6JJSHYoQ4nc3Zne44mPVb0Mn?=
 =?us-ascii?Q?z6knsE/4xIIJ0XhqZlJMsy4R4ceub1k1SrijLh7+llZWc+GpPGwPP0BLGwwP?=
 =?us-ascii?Q?4dhrYLVJy8+9gtCtYVkE7TG2JnXAWCB3lVlcIrQ5pWGTn9l3c1w5h2bdxCcN?=
 =?us-ascii?Q?OMZVvPJal45oawrh147bQLJhUmFt417ckSBkn/cnxpupyRIyukEjsdy+otry?=
 =?us-ascii?Q?w325dMDQDBJTRFwXU2YPLRf1s0/CG3usy2+s7g2bTSp+oTseWVbT2qd/4Vkb?=
 =?us-ascii?Q?6yefz5QtsZIa+ojf9J42avxoW7/G1DihCVeoe/Y9myl5MZ4i0jlmKEQb/W7C?=
 =?us-ascii?Q?cioimHedH/6zfJG9QTzTX/12CGNjc2537P4G3aDRy23avg4EYMhAzTg+Qeay?=
 =?us-ascii?Q?NSHKnVtx7PmjsQtIklku+1d2xtYVWJ+F1icvGBQhEev99fAL8d3/CJevF5m8?=
 =?us-ascii?Q?lsjeyx/xe+Js2ANc0brR56vzvWO9psH/wZ9TMkv+fJ6OGgyQASp0xKDGv9Ex?=
 =?us-ascii?Q?32rZeGaQJmCnMU+48kxrm+2ccDZcw4g/Xg1JYXwkPJKypYtGqp7wKaLuilLn?=
 =?us-ascii?Q?+0eGa4c52zEM9JzLpPcdz8Kt/Nqw7IeVQcHeMFbwVuE1HGqtkRwGCGpLcEnA?=
 =?us-ascii?Q?uOI2iyiDHKgyCzBMjTo9TPyiTH0ZBbocoruQc6Wmu0NjYSinpqkIEx7AOErZ?=
 =?us-ascii?Q?ZWZv0IBzfGRqe+hJvu+YyIZOT/ULXKaB/BXqIHjJ1VwZPI1xShVX/DlphuGJ?=
 =?us-ascii?Q?m+6D1SBTh1Zpv1u2T249d1tQdNtizDzjI/X/7Bk4mF6IfE20NtoPLM3yv/wQ?=
 =?us-ascii?Q?paWi4FFPSbUOxCSThEZWAoMpvWhPjaIXoyClh0yKwn1ilDgnfO8R731ipMhj?=
 =?us-ascii?Q?/9zzoltYYOGQ/fRanK1rxJc5jJe0ZpETuCYJNBcQ8qtQ4EU9bJ+xUlYWuOUd?=
 =?us-ascii?Q?8G+3d7nnrCrLCv8q3qLnSPVEagsHVNiBH0FpaJ1xRLAP0BtXG+1V41eXdQWq?=
 =?us-ascii?Q?18sPQ0avnZlU/dTDaKmetRjilNWN/NlBL7f9ZPkbBoCWpciG1g8Km6hUJaAZ?=
 =?us-ascii?Q?WwzNUKVTjFlBK8Lt9pCEH+eJ7S5FEzYczXWqCw1KeDQ7vgfX8MW4qE4+Cwth?=
 =?us-ascii?Q?VWSirgeI1tHWDPYmrqpzp8fJFyWhOC0QxFq8IaRlBIR36so/cUhseV/SM5Q8?=
 =?us-ascii?Q?wexSI1bNBsqtLzW13vWLsXu/uNrH433PqMJ5dkqA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e31e930-59bc-4f42-06d8-08dd8dd58415
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 02:10:34.2330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iZYLhbBKegyMElkPXc2c0QHU0i5unnTk39M1aKGQLoWEEjDO2zYQ9kYNZND58vCmsoTtgPjaz2LAFgr8UzigZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE994B740C
X-OriginatorOrg: intel.com

On Wed, May 07, 2025 at 09:31:22AM -0700, Dave Hansen wrote:
> On 5/5/25 05:44, Huang, Kai wrote:
> >> +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> >> +			struct list_head *pamt_pages)
> >> +{
> >> +	u64 err;
> >> +
> >> +	hpa = ALIGN_DOWN(hpa, SZ_2M);
> >> +
> >> +	spin_lock(&pamt_lock);
> > Just curious, Can the lock be per-2M-range?
> 
> Folks, please keep it simple.
> 
> If there's lock contention on this, we'll fix the lock contention, or
> hash the physical address into a fixed number of locks. But having it be
> per-2M-range sounds awful. Then you have to size it, and allocate it and
> then resize it if there's ever hotplug, etc...
In patch 2, there're per-2M-range pamt_refcounts. Could the per-2M-range
lock be implemented in a similar way?

+static atomic_t *pamt_refcounts;
+atomic_t *tdx_get_pamt_refcount(unsigned long hpa)
+{
+       return &pamt_refcounts[hpa / PMD_SIZE];
+}


> Kirill, could you put together some kind of torture test for this,
> please? I would imagine a workload which is sitting in a loop setting up
> and tearing down VMs on a bunch of CPUs would do it.
> 
> That ^ would be the worst possible case, I think. If you don't see lock
> contention there, you'll hopefully never see it on real systems.
When one vCPU is trying to install a guest page of HPA A, while another vCPU
is trying to install a guest page of HPA B, theoretically they may content the
global pamt_lock even if HPA A and B belong to different PAMT 2M blocks.

> I *suspect* that real systems will get bottlenecked somewhere in the
> page conversion process rather than on this lock. But it should be a
> pretty simple experiment to run.

