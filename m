Return-Path: <kvm+bounces-51372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8D45AF6A6A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42FB63A888F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:36:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7591F28FFEC;
	Thu,  3 Jul 2025 06:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="el+VRyW1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18FDF18B47C;
	Thu,  3 Jul 2025 06:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751524595; cv=fail; b=FLfVv2dfzJ7/3sjr+XDoXHq6imuDe/dHd9FIL3zhBSt+zp3HLfasdTbWHpEeHU3VBqwxkKOhK3Z1HCtUFE1/CXNqk9e85p2gQGtLImK2sz7fpBIre/NDTNMYC+1YMl/RcPajACKgweRm4NXdcK81tzFDBiMfz5KVbZQDHVcUqEY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751524595; c=relaxed/simple;
	bh=IHN5fESVlMJzHxm2BlZU7Rg4rkWGJmB0BhmWHT64PHI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=RpZppN9V0MhaqjIznfgLind4U2ol66psVu7YRP0Y1eMjuetv7IulQvwtWdLpkdDSQWLT8bRU+cSzMhFV/wLKNtCb364xdvB9sUiwLUQ23xDRzdcU0DL9+ONb3V2+ssfuQuIN9OKURAcEb0UJafPWKzwmo+JpeoFS97FuWnFY2wM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=el+VRyW1; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751524594; x=1783060594;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=IHN5fESVlMJzHxm2BlZU7Rg4rkWGJmB0BhmWHT64PHI=;
  b=el+VRyW1xAgcW3bzUTqR/Ttg7GHF0ovm067Fiy7gDJZLaK8sLaDV+ZVb
   aLxLv9iOIHT8gXcfppltAICXSGPlIlO5LWIoOhu4U8clQ2ls3h3hDHusx
   13W5iRBS7NGUmhup4PmesOjX/nHRpo/2Kikaj52e0q1bCSZZd6s7tpAI7
   Ly94nS7+bBP4+rCZasGmYfXGWhrHGubJTkc5DdsHMbYzM7gvAgSgIOQ1f
   r3r+Xi0L0eZTYvuOgS0RzUYswRRuaEVPByy02O4v5UZmWQE2nIdCCSvPY
   hnuoIT7l1kTXI+JOMI6uB03coyEFkt7G4JfJSN1PrPBfBr/r0Osb8HLu2
   A==;
X-CSE-ConnectionGUID: iw9LdA3kRjGmF6AvfLr+FQ==
X-CSE-MsgGUID: KebyOUSKSGi1+jUNANqR0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="65293742"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="65293742"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:36:33 -0700
X-CSE-ConnectionGUID: 0PFAUQ3fRQWBA8qOKa5OMQ==
X-CSE-MsgGUID: tLnpm+bVTq2+LOtBqVoL6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="153694726"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:36:33 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:36:32 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 23:36:32 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.86) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 23:36:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nms/ko73tA+XW0h+zCHKpsvSWaTJ1e+QjAf1voIL+4c6Al0yXcbTsGVCKLeQDps4HtqG1B6tCxy77MyYd3OfYARq/56ReYwpdZxYjpicBsv/7yWz+1kvTZd3ydrio08DNkXEzVdtugjrE0LVGhVbUUKz2ACUO0Ys8Nro3b6jcxwoKREtpQZYIZA9vl1fJ/0d6uUboEnufZaqFTIgo1oSmjoitAFDeUGp1n1dgLPtda5kvEWBPi8DLolsD+eY88DRhTKentqRRy+UbD7Vm8c4KUWNFOSxnBUtn/QMcCe8iGVUfNJz8gmOXCnedJlHtBc3lfVwoVKOD1Wwsrv1HSTbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MinwbpYG/PGwnx924vKkhQVkSpdZK6Z79WS3XiNJTjM=;
 b=om4VjVMPHGs6UQgOMGVh4oL7R84BD8VzeJcKRJ0xbeiqwDIn8LNHEm/Eq4/t2rKauw4eyWmNx5T1X8c9pWKFKxoVdZigIefHoh+WrmLiZXEcU2Tyocykg1qq/ubr/he/oidpkafih/IMbE+TJFc0svDyHqRV3uBH+Q1FwYkPbCmmlAJBq8SWDPURSHAiDEOMrVldnn6PM/uwCFOPYc6TW0QVY3gkQvIPcOUXHIDa6tvyF3DRkMuFnpxH6EMzqrK861dZlH+BQVEk5rQ8OcGJJMSWngCUNNeC8Kj0M6cAHHvQs/rnN0YUuUqdMyZ/yV5KzS+NqLNZpZAueF6nqv59Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7855.namprd11.prod.outlook.com (2603:10b6:208:3f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Thu, 3 Jul
 2025 06:36:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Thu, 3 Jul 2025
 06:36:29 +0000
Date: Thu, 3 Jul 2025 14:33:54 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: Vishal Annapurve <vannapurve@google.com>, Ackerley Tng
	<ackerleytng@google.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<amit.shah@amd.com>, <pratikrajesh.sampat@amd.com>, <ashish.kalra@amd.com>,
	<liam.merwick@oracle.com>, <david@redhat.com>, <quic_eberman@quicinc.com>
Subject: Re: [PATCH 3/5] KVM: gmem: Hold filemap invalidate lock while
 allocating/preparing folios
Message-ID: <aGYkUjdvChdZWTXF@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <diqzjz7azkmf.fsf@ackerleytng-ctop.c.googlers.com>
 <diqz8qmsfs5u.fsf@ackerleytng-ctop.c.googlers.com>
 <aC1221wU6Mby3Lo3@yzhao56-desk.sh.intel.com>
 <CAGtprH_chB5_D3ba=yqgg-ZGGE2ONpoMdB=4_O4S6k7jXcoHHw@mail.gmail.com>
 <aD5QVdH0pJeAn3+r@yzhao56-desk.sh.intel.com>
 <CAGtprH_XFpnBf_ZtEAs2MiZNJYhs4i+kJpmAj0QRVhcqWBqDsQ@mail.gmail.com>
 <aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com>
 <20250613180418.bo4vqveigxsq2ouu@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250613180418.bo4vqveigxsq2ouu@amd.com>
X-ClientProxiedBy: SI2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:195::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b5f69d8-1c82-4a1f-f95f-08ddb9fbf186
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aE05c3dsSkYvQjdERS9jclBtcUhtaHozNUtjdzQwVnphRVhKRHVCYklZMHB3?=
 =?utf-8?B?MWRNRGlXWmpIdW5GS1UyNzB1b1Q4ZFRpMmRUL1dGb0hCVmpwSE5BNUNPNXJm?=
 =?utf-8?B?WG85K3pmOHVkVG1VdXo1UHNhblE5a21jaHdqY0o1aVZwNWliY2FpbzZXTGcr?=
 =?utf-8?B?VWhtNVNuNVJ4MXlpejN3OVVzN2tNbFl1RHhscS9pUUhXRDl4T2dUL3F5MkxV?=
 =?utf-8?B?NXBMdHhrZzhhR1ZTZGt4NVhONHV0aitSWWs2Q1N2cG15cXR1ZG9kc3YrK1RZ?=
 =?utf-8?B?aUtETkJ6aEVNRE9oQ2s3d0ZmTHBRc1BTRzQzYUcra1hWZUlzMHRCbVJ6ZHMv?=
 =?utf-8?B?ZVFjeVErQ01Cb3kyYy9iT0htQnd2dzNucnY5N0QvWVo4dis0dG9XWGZpbHUw?=
 =?utf-8?B?dU1jTWhVRXpFT1JyZE9MaUhPS1huMkdVZUdCc2p4ZjVTVU9NY1U1MzZVbWFF?=
 =?utf-8?B?RU9veHhtZEJGeWwrZUYyTlF1RlloOUREZUxvY3M1RWRqT0ZkNTZtbGlpSzEx?=
 =?utf-8?B?TE5XYzhhcUd0cVFOci9FTXMyWjg3b3dhMDNIcGQrMEpvcmljQjViaWFWeTIr?=
 =?utf-8?B?Ykp4TEJqK0xlSVdIQXNQMXgzQ1puWlJJWkFmamFXb3g0V3JkUkE2bjg3U1B5?=
 =?utf-8?B?OUFtUW55bjV1MXUxb1drNGcyYU9YQWZMK1MraGhaZUtvWStrR2o1dEZyQnAz?=
 =?utf-8?B?eU1oYlpVWjVFbFZJV0hZODhZQ0V5YXFtTzQ3UWgraU9wenJwY3ZBQmtzTDZY?=
 =?utf-8?B?YWd2dUZ0eEpMZ0xDaHVhVHlvUnY5L3FFSUZoL0RSVklUeVpOdlpmT3FmbGo0?=
 =?utf-8?B?MjRHcmpQRE9hVHY2TjBscVB1Snd6V25QL3VVZ2h6cmJpdzMyeE1BZWhvOGU1?=
 =?utf-8?B?RFVNUFpSaFRod3AxZTVrVWF2MkJLRTlpaGdyUGxVQS9hSDZXSmpsZUlMc0Ew?=
 =?utf-8?B?dXlob3ZwOG8xMWpPMFEySkdsNTVrNFI1Si9mK0tXNUF0ZU1sMG45TWZ2ZDFM?=
 =?utf-8?B?TEwvNlVVMHFBQ2tYelRRZzl3aTZuV1RMcFRIL29UZlVQV0tnSDlhYks4NzFo?=
 =?utf-8?B?UHdDZk1pSC9tR3BLOTZHS005akNKcFFuK1BRb1ZOUk51NGRCSXdWWXVCSUR2?=
 =?utf-8?B?QlFvM3JvaTNJbjBLU1VlUCtsMGhVVk1OcWJQK0Zhd3NUay9MRVR5U1IwcS91?=
 =?utf-8?B?MnVmMldVZjE5VWJHTlFTZmtMNk15THNxemxodThCRS9WNWhhT2hERFZBak5T?=
 =?utf-8?B?TDQ3R3NUMkt0TWZnU09IajhzK0szNFpIdTYrK2VVdWNCK21iS1l0Y2RzLzB2?=
 =?utf-8?B?N1BHTkJrM2Fqc3ZSTDZ6UUxwZ21oc2NHNWZnemRSTExSV3VmcWdOTDRNMmxs?=
 =?utf-8?B?TERkYmJvNjBMVmZuQytoN3RsRzdXTU50R1J6MHYxMUpmdEJJeXUvNUNjV0xZ?=
 =?utf-8?B?alF2MlZvMXpEaitpL0djMHJRTDJLQlF6R093cTQvTkdHNzNZWWtrRDZvYUFq?=
 =?utf-8?B?WUZldE1oSmpJa09uU256alZtOFRkWXpGSEgyWEJpMlJMWjZaaDlkbmFrRGFG?=
 =?utf-8?B?b01JeHhJbzdGaXp1MjZqVEZxd3hVWGs0WEhNTXIzSjA3VUV6TTJWOWd1M09l?=
 =?utf-8?B?VEZPWWR5WHQ2MEw5WWMrVVlSOWxCdUpFWkNrZjV6QkdCWmdmSU1laitsNnVz?=
 =?utf-8?B?bWtmbzB3emREOTNRa1k0d2JpZlErcTNnWFB2dG94TW1jajErN2xGN0ZmL2U4?=
 =?utf-8?B?cmhhSTN6MzQwNGZzVjlLUFVPdDFLYVpzOHMxcjRudnlQRjlvTkxRY3pwSjRD?=
 =?utf-8?B?cVIxMm84R2xpYU5HdGJVTGlFdlovMlc0eTlNUVRtb2lDdnNvd2k4YnBwMXUz?=
 =?utf-8?B?OEtXaXRjb1dzbXp5VVF2eExsVis3TEFCU0pnKzhybFRRSDdQNHN4Nnc0QkNu?=
 =?utf-8?Q?R51fWVNS5kY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzBKeHF6d0V3T0FhWmNHZ2swWUFqWHdmdTE4cnc5S3pTeEdMaCsrM2RNT0RR?=
 =?utf-8?B?TG95RkNxTDlyWHc2TkhrZEhCTlE2U2JyUytoSTZEaVJza05rbzZhSmdyUUln?=
 =?utf-8?B?ak85d1NOOUtjZlh5OSs2THEycjYzc0xKa3Bnb2hGRHI1QnNHNmcvZEJTYkJx?=
 =?utf-8?B?MXl5VmdqR3RLOEdnSVVCVlYxMWxFdnZURkE0c0k2bHlUMHhZUFFHdmxuSnZ2?=
 =?utf-8?B?bDRodXliSkxlS3REZnFDNkxkdFk2N1M5dnVZUkJLVHFwV0hYa3ZDaE93ZCtq?=
 =?utf-8?B?bGVvSmVKRVd5aDl6cHdIa1FGajd1azJlclFhVGU2TG5RbjIycGNNYUlmSGJ3?=
 =?utf-8?B?NEhHNGRFcERkak45d2ZlblpuTllCdkdzd1NaS0MyUVRpQkg0d1FOL0lUbGtE?=
 =?utf-8?B?cGJJY2FGRkdYRWFYc2l5NEFjUWtPN05LMGp0SXd2OWhqVnpOdjJFdlB4d2dl?=
 =?utf-8?B?ckhZaFYrd2JlTXM4ZTBjY2I0cVVGQWhlaVJjbWVoVWFFWWxyOGJ6dFB4V2kw?=
 =?utf-8?B?clVRUUFzNjZ3Y2wvbTdhczU4RkJXV2xDOFpWdG1oY2VkVXBxZWI3NWpYVlB1?=
 =?utf-8?B?YjBGbTRHSFJBVFUxdkt2NGtRSFdTUUFEVjJmakdzMmIvdWdwNWJ1RVh3Nnls?=
 =?utf-8?B?Z05NdHZUbGo4YTNEQ3BDMmZkQjJ1WVdXU1dNRTVVKzdsbW8zNkljSWVoNXVP?=
 =?utf-8?B?TXlnSDBhNnQyaGdmTnYrTzQ1RXoxbmtQcHFKSGV6UUZ6ZDMvbk9pWXQzQkp0?=
 =?utf-8?B?RnhXUVI1eE9iNE1zZ0V2TzJtSVNaRGhpQ2xHL1NUTkNFWUZBNU5YYjJSNTZz?=
 =?utf-8?B?bFNhdXVKdyttNDM5SkFzMTdpTjRKMFVUYWlUeTV6V3dSOU1NTm1ORHFEY1JE?=
 =?utf-8?B?U0Y1Qm1hVEk0Rjc3cTF0Z3FpbExlNDNyVVVTUnBJSEJTZTErM04rdW10K2ZU?=
 =?utf-8?B?aUEycHdkMGNLb0xRZkphTFJnSjRIWW1sUEQ5YldiVmRBWkNxakJtL1FESUtV?=
 =?utf-8?B?R1hEdDRMZzQ0SW4vcFJrRFYrUmJCS1dqL1JIcVJmUGd1RlpPNG5rV1E5b1cx?=
 =?utf-8?B?NFR0YzBWZGtYWGI5WjZQbE40Z3dQZlB1WGdUbEsvTWg2UCt4QjdIYUhDeEt3?=
 =?utf-8?B?b1ZyN0FpUUdpWUlHRDNsWm1wdFNFTGt6Zk9uYTY2WlhKSlBFdFJXVWhsRDRZ?=
 =?utf-8?B?UXhFNm0wMlV2azhXSm0rZU0wNjVFYnVTMUUvLzRIaHJBRFMxYjNXWlpINW15?=
 =?utf-8?B?OG5RVE5wNFBtbHFMUEZwNnphUXBSQzd4bWk1Yk5DcTdzTXlnNThZNGhtSURs?=
 =?utf-8?B?WXB5Y09wOGxJRUd5Y3Rha3d1RVVibTl0WlplK3FLNE1lcXJWTHFuUWV6a2ZS?=
 =?utf-8?B?T0NwQVZVV0F6bmE2UDVycTdlWkZVZGdVOU9QRW8vZDhGR1I5emJ3cVlFR0gx?=
 =?utf-8?B?Uml6UDhST1luSnk0Mlo5WTRuNTBRbmhDNFBmOFlRM0dVUHdVeWxscFQyQi9R?=
 =?utf-8?B?Umsva3poZW1SWjAzK2tmNkE0SFlMUU5UME5taVprWUVJSDdLU2YwVGdQZTBj?=
 =?utf-8?B?SDNrUkhlODZlUEFhcEdzYllsOGdWWmV3SEVDSlNKS0M2bEZmTDVYSTBMM0Z1?=
 =?utf-8?B?VVNyU1IwVHdXMjBlaDhVZGpFb0RwMnFwMTlQbVIwNmRDTGNhRkg1RVNTUyts?=
 =?utf-8?B?VWhFZng2MjZDTUlQS01xcUFuK0c4ZGtGSEM0MmdHdnB2NFR1YkNQQkdLUWxS?=
 =?utf-8?B?MEI3Q0lkR3ZoaGE3cmpDcklHbkhsVjZ2ZkNPRVBHTnEvaDNZWVhXdmZPZFpY?=
 =?utf-8?B?TWtKWTh6MFRWOW9IMi9HTTVPc2NiWW82WWpKclZ3bHpBcEdWVXVpdTlLeXMx?=
 =?utf-8?B?UldDSEN2dHQ0NnBRc1N6eHdSdTVMRkY1UFNNOTI1VkF6VndTMlM2TkZFMlVw?=
 =?utf-8?B?b1Q5ajRhVzY4VnRvZG1LNG9NaWNMcFR0U0pQdFBBRHY2NFRLNi9CWmZTdGNH?=
 =?utf-8?B?aFFOVUJxamJYVVU2N1dlbVdnMkRPMzVKSnNYWGJNZmxBM2hmdm9uSFdscFFw?=
 =?utf-8?B?V0pINUJOSHZxdndKQXNWNkNVTmowNHpRTWEydFh3OThjYTBPT2xnbmdhRHBY?=
 =?utf-8?Q?fLnxjzIUCdb/CgLCJCq6I2Icq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5f69d8-1c82-4a1f-f95f-08ddb9fbf186
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 06:36:29.7708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xJKv3/W1WexY+pNTtSw5fwwyBZ5xRPHyHDi7WmIO1t29S7LKbKLiuQOgy9HEVGGP8r0y7czAtz62hY4XUMnUSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7855
X-OriginatorOrg: intel.com

On Fri, Jun 13, 2025 at 01:04:18PM -0500, Michael Roth wrote:
> On Thu, Jun 12, 2025 at 08:40:59PM +0800, Yan Zhao wrote:
> > On Tue, Jun 03, 2025 at 11:28:35PM -0700, Vishal Annapurve wrote:
> > > On Mon, Jun 2, 2025 at 6:34 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Mon, Jun 02, 2025 at 06:05:32PM -0700, Vishal Annapurve wrote:
> > > > > On Tue, May 20, 2025 at 11:49 PM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > >
> > > > > > On Mon, May 19, 2025 at 10:04:45AM -0700, Ackerley Tng wrote:
> > > > > > > Ackerley Tng <ackerleytng@google.com> writes:
> > > > > > >
> > > > > > > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > > > > >
> > > > > > > >> On Fri, Mar 14, 2025 at 05:20:21PM +0800, Yan Zhao wrote:
> > > > > > > >>> This patch would cause host deadlock when booting up a TDX VM even if huge page
> > > > > > > >>> is turned off. I currently reverted this patch. No further debug yet.
> > > > > > > >> This is because kvm_gmem_populate() takes filemap invalidation lock, and for
> > > > > > > >> TDX, kvm_gmem_populate() further invokes kvm_gmem_get_pfn(), causing deadlock.
> > > > > > > >>
> > > > > > > >> kvm_gmem_populate
> > > > > > > >>   filemap_invalidate_lock
> > > > > > > >>   post_populate
> > > > > > > >>     tdx_gmem_post_populate
> > > > > > > >>       kvm_tdp_map_page
> > > > > > > >>        kvm_mmu_do_page_fault
> > > > > > > >>          kvm_tdp_page_fault
> > > > > > > >>       kvm_tdp_mmu_page_fault
> > > > > > > >>         kvm_mmu_faultin_pfn
> > > > > > > >>           __kvm_mmu_faultin_pfn
> > > > > > > >>             kvm_mmu_faultin_pfn_private
> > > > > > > >>               kvm_gmem_get_pfn
> > > > > > > >>                 filemap_invalidate_lock_shared
> > > > > > > >>
> > > > > > > >> Though, kvm_gmem_populate() is able to take shared filemap invalidation lock,
> > > > > > > >> (then no deadlock), lockdep would still warn "Possible unsafe locking scenario:
> > > > > > > >> ...DEADLOCK" due to the recursive shared lock, since commit e918188611f0
> > > > > > > >> ("locking: More accurate annotations for read_lock()").
> > > > > > > >>
> > > > > > > >
> > > > > > > > Thank you for investigating. This should be fixed in the next revision.
> > > > > > > >
> > > > > > >
> > > > > > > This was not fixed in v2 [1], I misunderstood this locking issue.
> > > > > > >
> > > > > > > IIUC kvm_gmem_populate() gets a pfn via __kvm_gmem_get_pfn(), then calls
> > > > > > > part of the KVM fault handler to map the pfn into secure EPTs, then
> > > > > > > calls the TDX module for the copy+encrypt.
> > > > > > >
> > > > > > > Regarding this lock, seems like KVM'S MMU lock is already held while TDX
> > > > > > > does the copy+encrypt. Why must the filemap_invalidate_lock() also be
> > > > > > > held throughout the process?
> > > > > > If kvm_gmem_populate() does not hold filemap invalidate lock around all
> > > > > > requested pages, what value should it return after kvm_gmem_punch_hole() zaps a
> > > > > > mapping it just successfully installed?
> > > > > >
> > > > > > TDX currently only holds the read kvm->mmu_lock in tdx_gmem_post_populate() when
> > > > > > CONFIG_KVM_PROVE_MMU is enabled, due to both slots_lock and the filemap
> > > > > > invalidate lock being taken in kvm_gmem_populate().
> > > > >
> > > > > Does TDX need kvm_gmem_populate path just to ensure SEPT ranges are
> > > > > not zapped during tdh_mem_page_add and tdh_mr_extend operations? Would
> > > > > holding KVM MMU read lock during these operations sufficient to avoid
> > > > > having to do this back and forth between TDX and gmem layers?
> > > > I think the problem here is because in kvm_gmem_populate(),
> > > > "__kvm_gmem_get_pfn(), post_populate(), and kvm_gmem_mark_prepared()"
> > > > must be wrapped in filemap invalidate lock (shared or exclusive), right?
> > > >
> > > > Then, in TDX's post_populate() callback, the filemap invalidate lock is held
> > > > again by kvm_tdp_map_page() --> ... ->kvm_gmem_get_pfn().
> > > 
> > > I am contesting the need of kvm_gmem_populate path altogether for TDX.
> > > Can you help me understand what problem does kvm_gmem_populate path
> > > help with for TDX?
> > There is a long discussion on the list about this.
> > 
> > Basically TDX needs 3 steps for KVM_TDX_INIT_MEM_REGION.
> > 1. Get the PFN
> > 2. map the mirror page table
> > 3. invoking tdh_mem_page_add().
> > Holding filemap invalidation lock around the 3 steps helps ensure that the PFN
> > passed to tdh_mem_page_add() is a valid one.
> 
> Since those requirements are already satisfied with kvm_gmem_populate(),
> then maybe this issue is more with the fact that tdh_mem_page_add() is
> making a separate call to kvm_gmem_get_pfn() even though the callback
> has been handed a stable PFN that's protected with the filemap
> invalidate lock.
> 
> Maybe some variant of kvm_tdp_map_page()/kvm_mmu_do_page_fault() that
> can be handed the PFN and related fields up-front rather than grabbing
> them later would be a more direct way to solve this? That would give us
> more flexibility on the approaches I mentioned in my other response for
> how to protect shareability state.

I prefer Vishal's proposal over this one.

> This also seems more correct in the sense that the current path triggers:
> 
>   tdx_gmem_post_populate
>     kvm_tdp_mmu_page_fault
>       kvm_gmem_get_pfn
>         kvm_gmem_prepare_folio
> 
> even the kvm_gmem_populate() intentially avoids call kvm_gmem_get_pfn() in
> favor of __kvm_gmem_get_pfn() specifically to avoid triggering the preparation
> hooks, since kvm_gmem_populate() is a special case of preparation that needs
> to be handled seperately/differently from the fault-time hooks.
> 
> This probably doesn't affect TDX because TDX doesn't make use of prepare
> hooks, but since it's complicating things here it seems like we should address
> it directly rather than work around it. Maybe it could even be floated as a
> patch directly against kvm/next?
Posted an RFC for discussion.
https://lore.kernel.org/lkml/20250703062641.3247-1-yan.y.zhao@intel.com/

Thanks
Yan

