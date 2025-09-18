Return-Path: <kvm+bounces-57982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61844B8315A
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 08:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14271620106
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 06:09:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61AB62D77FF;
	Thu, 18 Sep 2025 06:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IQMH9EAE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8ED26AE4;
	Thu, 18 Sep 2025 06:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758175748; cv=fail; b=THj0kZ5jDOiw/e2LXP939nTycjcgfDr6fw4hRYfaFHETv1L086WkxOSju+iVxqYyJDWAj1wkBn5Fleck32V6i9PB2CreBIeTbWXdXghFhogYfIBnXYhChQNvF7VWwUExbcrQAx1vp+Y61dh776LDRUbSmvfGL6WgQz33UDCBkFM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758175748; c=relaxed/simple;
	bh=3RAsdaqltXOEPhEfpyljsKVEbaIlYo+wGsheVfB6n8o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MjDQbR06ZRsgcjTlWcpkjdx2Xon4J77d5i03RELC8Q7jaZb1LADNID/AWRtp3haO4d6imBNyVffUblP3zhJxgaJ3ElFK3gr5Tq06GFAt0l0L5+Kksh4KT5rIRL6iQNZuZruk3wUf52NdwSLPL0o9sG7xneuuhhUnl/vwW0gQOCQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IQMH9EAE; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758175747; x=1789711747;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3RAsdaqltXOEPhEfpyljsKVEbaIlYo+wGsheVfB6n8o=;
  b=IQMH9EAEZx8bD7+3HVL+d+wwASjNUsdM1OWd9jxcHixuFDot7j59MhPD
   WbB2dOST7PUsOo6mBTHp607CjgcJJGERPcWkyWWY3EjmbefAJeuVNToFm
   huNeOeInzm5D3GBLt+YNFBxQM74R/RH0Z8Xrxipgb206byHuqNIZ52RQr
   TtLz2EOm80HeFt8tnO9r/e7/FYVWaktlGkTf9/RVuDFHckRObtYL4/aYk
   K9dP94LypG5gwSa6XYlGAXkWpPKOrKWLe/msk1tUXEagOoLo65l7p+Ej6
   +u9mTuC97LPk54HzLCoPgdVgnzDJZnL5EboeKd7yY0Km7OwhnQvw3Ias3
   g==;
X-CSE-ConnectionGUID: UJaZ6TCdTUKQg+rncLrEFw==
X-CSE-MsgGUID: 2fJHeqcXRHybkM9WQHj5ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11556"; a="83091691"
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="83091691"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 23:09:06 -0700
X-CSE-ConnectionGUID: vkIFOMJoSaaGmUtk+MYQ7A==
X-CSE-MsgGUID: mzHaTCpDTJyVP4AoljUpgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="179732455"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2025 23:09:04 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 23:09:04 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 17 Sep 2025 23:09:04 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.56) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 17 Sep 2025 23:09:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mTphJpQIvnsiydlnaMmS9m7lMMxdiTZhuZud5wcYMAD7dnbkw6+EfELsgf1tRsz/iKYkqWQod3HnIsiOmyNpQlfkKptYCUtdOhr5nR8Zf6INtdn8tEM1YrivebwsYEtj2Km2d1GyXJ6rcoeitEcVJPfSiHeCsWSJSIcWG/o+irE3ZpP79ghfFmr8hfZDe7NW8xSExCJxpBWG0A/N/fcGzTszDCirn+YvM2ag1YEVQBbc94LsZoN8/l/bmmKS8A25HHri+60DIeElHFJIsQItbQ0WhhWAW0oWV/d5yn3KUOboKzpoCKr8YmNPUdlM/Jx+tpxxOoCSN6uUxvX+xxuRew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdbjC3+T81yP/xTBQnotu6gVu7Ax+HrVme6ZhdLBpn0=;
 b=cz2SbCTQAmVx7yjjtun0WlY4ylVA1W3YF3dD3WjBWhHxE5N9ZMWf9s/6J5+bChq2eow2vN0T28ag/3BspclCMPC9US/bOp9KsQXT9KF+yI7fHLcMcNrmcsAsTkGyRgli4tJlFK7MDms2cDARSGLl67NYlMc4pwgYCIsnsu6LO6gYoj+J4p4yECy4o1qV1jEztusF/GEPo9pSvUpzzjYLs441wz5gzEfnohjdCtVDVDAReHg55eLftckyWy7mEb9csgRTkPVPlRmXPnYFzqeRg8Z/STm/1qZNmWQ4Xp63sdey6uqxeR1XqEy7jPqiH6TmP5O7OLXwhb2ISNrljPnoXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7354.namprd11.prod.outlook.com (2603:10b6:208:434::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 06:08:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 06:08:56 +0000
Message-ID: <79b2d040-a3e6-40db-b545-bb07d42c8c29@intel.com>
Date: Wed, 17 Sep 2025 23:08:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/10] fs/resctrl: Update bit_usage to reflect io_alloc
To: Babu Moger <babu.moger@amd.com>, <corbet@lwn.net>, <tony.luck@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <549a772b83461fb4cb7b6e8dabc60724cbe96ad0.1756851697.git.babu.moger@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <549a772b83461fb4cb7b6e8dabc60724cbe96ad0.1756851697.git.babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0156.namprd05.prod.outlook.com
 (2603:10b6:a03:339::11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: d56b7fc3-c00f-49e2-d0d9-08ddf679d9ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WkdwWElzWDZ5SUNSOVJCSkxOOXZIWjRmU2Ruek9lWm9iUkd0b2k4d2VqRHdF?=
 =?utf-8?B?Y2QySmJ1bnZUZmU0bGNRYTZIRWVIOGRzY0hzODhTM0kyeTNZZVJZR1FPcjZ5?=
 =?utf-8?B?ajBZVnlJZ0RoUVh6dVUyQlcxeFE4dGFkL2VIU0JuRXZBU0NLcXlKcnpla0VS?=
 =?utf-8?B?N2IvNEFTWWFubFg2MExoL1JRNnJYN2c4RyszRnp2YVA4YzlaWVhWYU5VWEQ2?=
 =?utf-8?B?RDdkZ3ptSjFJQklkMWFTbHlybE5kSHBzSVlPQW9VaXF4ZTc0eWJUSmYrZW5m?=
 =?utf-8?B?emV6ekMwWmJ3R2MwajVac2prdmJDK3h3blhxeVFoN1BPYzkrd3NsV2NBS05L?=
 =?utf-8?B?aWZPaHRRNU4wVGI3N0g4a2JZcVVPNDVDbUx0clQ4RkYzeEFNMkJSZkFyRG9I?=
 =?utf-8?B?bmFMcjkvREdWY1NJNW45cDk4NmRvTzExM2RkRFhId0IzazBUakhwT0RhaEZW?=
 =?utf-8?B?Ylk5UkhLbzczN0FMbWZaOXp2YkpZS2VJb3kzN1FjYWN4RXZ3SWRXd3VQcXBJ?=
 =?utf-8?B?QlJzalByY2ZRbGZyZmF6ZjB1clc4cnFFNmw3R1JERUg4NnRwaklLR2h1UGtX?=
 =?utf-8?B?ejdkci9NQ1kvZFZsVzRLaHJBaHZrRzQ3NTBFeExtby9yM1Q2SzdCR3Y4TzdX?=
 =?utf-8?B?dTAvdVQrUzhyMUZvUjlIeVpvVFBjc3p1N2todDBhYmZJeWpZdGw0OG4vcEpT?=
 =?utf-8?B?TVgyK0ZzQ1U5UUpSdjJnOFRoNFFIZVg2b0JpOGdra0dQSWhwRVdhQyt5c0hq?=
 =?utf-8?B?clJ0eU5VMHllalVuT2hkbUVWM1U2Qk9MOHhnWXdoVzZ0N01uK3Z5bm5OMVhO?=
 =?utf-8?B?ZWloVnlEcU43K1RBWXFuRXlJRks4alJmeXVkQjRsRWIyRDlZb2gxRmJ6SnRU?=
 =?utf-8?B?WnV0NzRCWU5iTDQ2cytiOHdsM3FaNDJYRnVHVE1zQkJIMHZ5V1lWek1IOXJO?=
 =?utf-8?B?QjZkeG5QUFVYWUlDRWxpYU02ZlVReGY1YjFvaHpzS1VUN1BrT0RQN0MyRWxE?=
 =?utf-8?B?b0Z3N0NWRUtrdENLNXhTZGEvNU9kUzZYVGpubjJFcDNZdzFIQnJMT3ZpdG9l?=
 =?utf-8?B?NFFzRlBWNmdRSzFuUmRlRWUyVDVqYkovaGJ2SkxhT2lBTVo3ZE1DQ2ZsTE1P?=
 =?utf-8?B?eVM3N1h1Z3ova1hFOWloR01ZTjhXRHltMVlLUGlXb1ZNeXM0a3pQeS91SUJQ?=
 =?utf-8?B?NGJYUllJR2dnTTdjQkZ3aXAwRnBBRDM2L0xOUEhDaVRsZlF2ZVEyY0dGbzNL?=
 =?utf-8?B?WC9XRS9NcHJGd3NGbll3QkxoaEJXcFlZSzAxMUxiNElEVkZmcnZ2ajdCdWg3?=
 =?utf-8?B?YkoxMnptNUtYS0FYZDU0emFpbEk4R1FEY1VIWUNmRUhZaWg0YVV2aHFnU1gx?=
 =?utf-8?B?ZitQcGlEREh5SE5MM3dZS25PNEE2Vi9HUEs2MXpudlJYZlJ4WjRuM0E1UkR1?=
 =?utf-8?B?cDNrM05wcFhYczFNcWxkeVJHK1VIVCsvTTd4OFNTQWFORkNITGpINng1cE5I?=
 =?utf-8?B?TDlPWThXN21ZcHMvRDZaOEFJRU5kaloxcWtLSUxkdXJnc1ArSDFkRE9IUE5E?=
 =?utf-8?B?QmV6akRCaVVxT21ZY1pFMkxtNUduTkNsUlltYmhsdXBBWTV1ZCtFVkMrVFZz?=
 =?utf-8?B?V2FWeUNQbkQveFhsUElMZS8rUm93dXFXMU1ER3Bkd0cyTWhwZUQwaXJadDJD?=
 =?utf-8?B?SVRvRXRpVy9QdVVJMG5OclNEaS9qUjlLUVBQSVg4emE3bTYzZnZPVy85UVdz?=
 =?utf-8?B?OFFoMkdTbkZNeXpaeFVod1VPUW0ybjcrSkdzYTV3R0d1VGtHVEtGaDVVL3dZ?=
 =?utf-8?B?bWZoT25sRmRtRzJWQU81ejZ6TThrU3RERTdpam1DMDFIbmQ4aWt2UExYb2s2?=
 =?utf-8?B?Q3BNcysxTFMyOWhEWElQSFljYU9IZXZGUHJvelo2Y2FWdjBnV1RZWGtYdEtO?=
 =?utf-8?Q?BRkhFMkvfKw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmdFQ3ZuL0dRcjRTNzlIQlViclZVYUt1akdvcHJaYlJlUUNoVnlIeGVCbUpG?=
 =?utf-8?B?c25sd1BCZTQ1YjRwbjgvT3hKWXpQOXNFMUhlcmhTUGZsZXRicDd6ZFpUa0JP?=
 =?utf-8?B?TjRvL0FrUlhJUVptcUh4WGFUMEIwTmJ6MExYM1lnMzZIOVFwK3hCZW9LVkJp?=
 =?utf-8?B?a2phdFE0Z0dQbnZZeFZFNWVLTTZOMHpST1ZsRnVMU2ZOQU9QbHVyYkxPU0xo?=
 =?utf-8?B?bGwyc2dRcURlS1cvQVVoU1h6MVFZQlVLQUFuNTNvWlJLS1grWk5oQWw3VytJ?=
 =?utf-8?B?UmhPemtuOVNsNzJtTXpoWFhZV2hYczJNK3E0S0NoM25QN0lNVkU5Wkw4Rzh0?=
 =?utf-8?B?SFNJWm1nWFhTYXEzNkNlZjZ1dnpZdkJsTzhSWEUzSDVFbkZGNGhvemU0dStq?=
 =?utf-8?B?YWZUaEFQQzNGeHpKUTJwUGFKdmYxeWdlbk9hWTJxcWFyRTI0WnRPR29reEZ0?=
 =?utf-8?B?UWs1Mi9JRlJoZnRlblJRMm0vWGhWM09nL2JNNndRaEN6eHZSendVb3pteTRS?=
 =?utf-8?B?ajUzNWUxZ2cvZ1Iwcjl4SHJhdW1zUWgzVzB6Z2g4aE5VU2xOa0krNjlvK3Q3?=
 =?utf-8?B?UXJzSzJEMFZWNXBIN092cFNwTFN2YURhakZRM1NWNURvbngwa1FIWUxlTjVj?=
 =?utf-8?B?cUdCa05hcENraXViS2ZTZGdsOTM5Wkk1bDdkWWE3YnAxMWZtNDNLOHZmSyts?=
 =?utf-8?B?ODgveEhtZ081cFliTFZqNUdheFNNMEZlNFpDUjBOc1l1NjVKcWpyWkNraXBB?=
 =?utf-8?B?NndabjV1ZTk0MGM0Zk02bjFUZTJiV3E1am81cXlWalIxREhIem1NajgzWlEz?=
 =?utf-8?B?QzVWNnlxTG41VHZST0ZTZmMyOHJHcm9aRUw1Z0lmL0Z4bmJvMUxGZUM4dnlC?=
 =?utf-8?B?U3M0aGllbUN0R0NKSWxzZ25ZQUhpVisweTNaeHFKcHhLdFY3WHNrZ2xFRU1h?=
 =?utf-8?B?TEUrQlMxczNoUmFjRWQ1Rkk2d1R5c3Y5RjFibFVJcXBHUW8zNnRKeG1KdzBo?=
 =?utf-8?B?bUdhMFJtU2w0NkRBcGZrYUorRUduTmo0V0d0Y1d2QkJ5ck03WFJyeVNPaURk?=
 =?utf-8?B?UVgvTnBKOXYybDFMMW02Y3BkNFBid21rbkVWWG5KOXYrY2Z0V05NNGM5VHFT?=
 =?utf-8?B?L05tRTVHWTdLV0VBOHprdFYxMldrSmRVVlYxWDR5eTI4UnZtN05HVVZSMzgz?=
 =?utf-8?B?SFNISzRJdzJjREMwQzNLN3Y5QnUzbHZRL0VDYTJwZk5mVEFjc2JqTkVwVlBr?=
 =?utf-8?B?Y1VtVUJnbjlSVyswSFN2eGlNUis5VTZhRHZFNjhuSWdXRjlPd2hTWllkNmU5?=
 =?utf-8?B?SmVSYU8zbnhWMTNaMEJvWi80RkQzekc1anphS08vakdnaFQxTmY5M2MxUjVw?=
 =?utf-8?B?THNUN2Q0MldUUU02ckRZd2s4bFlTNlZOWmdNYjQvKzloWkwxemNOWlA1WHdB?=
 =?utf-8?B?S3FJS0ZDRmF4WkJIcHd6Y2VXelE3bExzc2U5YVYxVDZWUkN3ZWFWWFJpQVJD?=
 =?utf-8?B?QkF5M3BiWXpmRjBWWWZRVW5VUmNlcVcwMVM3TThXKy90Tm1XU1dyMkFJTkF4?=
 =?utf-8?B?TnBuSFBtdG5YeGZMRGlFOHlkZ3pSOERkanRRNjVwUDVYMmxNdG9vU1BvSnpF?=
 =?utf-8?B?UERiOWFNL3FQVVJEaEJOQTdVNHpLSHVZbXYwQVRRN2E0a2ZxOGo2WUt3LzdD?=
 =?utf-8?B?eWlrZGpSR2liS0k4Mlg5YVNPOFZTS3d6Y0MzaTZ3dDRlM2lHd2pwYkprQysw?=
 =?utf-8?B?TzlXcVJ0ZEN6ZllKd3I3Z0MrbjRnVGx6RkY2elVKQzYvMnJsaUxDRWlQTnV3?=
 =?utf-8?B?VDd4TUpDeEFiTWVUK0QvdWVYSTk0YTFCRzMvdk5SOXpsSEFFNzFhNXB1UHEv?=
 =?utf-8?B?NHBENkt2a0poTUUxbS9pb0c5QkJjZEpEZmlDOWFWamNSRGV4dGo2NEpmMzJC?=
 =?utf-8?B?bTU3ZDVMS0FrdnA5RmsvcUJkU1BUYm9ZVm1KdytQaU9rcDFmUmxnajJtMElp?=
 =?utf-8?B?SUpyclBvMUZpa2FzVHpSbFlhbVZLcERkeHVrYStWVkF1Qmd2Q3IzWWpLc0Yy?=
 =?utf-8?B?YmRsRHNnMnN5WjlJb3NxUmR4T2hMN0hvbVlTdEpPR2M0dWN5bmorbXpEQitD?=
 =?utf-8?B?TmF1TkZLb0tVZUNmQ2F4UGFCYXlkMW5rZk1FYzhjN1UrbEtRc0NFdCtmbjRt?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d56b7fc3-c00f-49e2-d0d9-08ddf679d9ff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 06:08:56.6635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1vogAqKEXOcwYc3fegQ9yZhgv1Up89khyR5WVJeYZrDFpL65st1JbNJblX4GKjmUwrEwT0uaD++xTgI20mQFzG3zbB7ikz3M+0fD5iFZDnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7354
X-OriginatorOrg: intel.com

Hi Babu,

On 9/2/25 3:41 PM, Babu Moger wrote:
> When the io_alloc feature is enabled, a portion of the cache can be
> configured for shared use between hardware and software.

(repetitive)

> 
> Update bit_usage representation to reflect the io_alloc configuration.
> Revise the documentation for "shareable_bits" and "bit_usage" to reflect
> the impact of io_alloc feature.

Attempt at new version, please feel free to improve:

	The "shareable_bits" and "bit_usage" resctrl files associated with cache
	resources give insight into how instances of a cache is used.                  
                                                                                
	Update the annotated capacity bitmasks displayed by "bit_usage" to include the  
	cache portions allocated for I/O via the "io_alloc" feature. "shareable_bits" is
	a global bitmask of shareable cache with I/O and can thus not present the
	per-domain I/O allocations possible with the "io_alloc" feature. Revise the
	"shareable_bits" documentation to direct users to "bit_usage" for accurate
	cache usage information.                                                                    

> 
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> ---

...

> ---
>  Documentation/filesystems/resctrl.rst | 35 ++++++++++++++++-----------
>  fs/resctrl/ctrlmondata.c              |  2 +-
>  fs/resctrl/internal.h                 |  2 ++
>  fs/resctrl/rdtgroup.c                 | 21 ++++++++++++++--
>  4 files changed, 43 insertions(+), 17 deletions(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index 7e3eda324de5..72ea6f3f36bc 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -90,12 +90,19 @@ related to allocation:
>  		must be set when writing a mask.
>  
>  "shareable_bits":
> -		Bitmask of shareable resource with other executing
> -		entities (e.g. I/O). User can use this when
> -		setting up exclusive cache partitions. Note that
> -		some platforms support devices that have their
> -		own settings for cache use which can over-ride
> -		these bits.
> +		Bitmask of shareable resource with other executing entities
> +		(e.g. I/O). Applies to all instances of this resource. User
> +		can use this when setting up exclusive cache partitions.
> +		Note that some platforms support devices that have their
> +		own settings for cache use which can over-ride these bits.
> +
> +		When "io_alloc" is enabled, a portion of each cache instance can
> +		be configured for shared use between hardware and software.
> +		"bit_usage" should be used to see which portions of each cache
> +		instance is configured for hardware use via "io_alloc" feature
> +		because every cache instance can have its "io_alloc" bitmask
> +		configured independently via io_alloc_cbm.

io_alloc_cbm -> "io_alloc_cbm" (to consistently place names of resctrl files in quotes)

> +
>  "bit_usage":
>  		Annotated capacity bitmasks showing how all
>  		instances of the resource are used. The legend is:
> @@ -109,16 +116,16 @@ related to allocation:
>  			"H":
>  			      Corresponding region is used by hardware only
>  			      but available for software use. If a resource
> -			      has bits set in "shareable_bits" but not all
> -			      of these bits appear in the resource groups'
> -			      schematas then the bits appearing in
> -			      "shareable_bits" but no resource group will
> -			      be marked as "H".
> +			      has bits set in "shareable_bits" or "io_alloc_cbm"
> +			      but not all of these bits appear in the resource
> +			      groups' schematas then the bits appearing in

I understand that you are just copying this but "schemata" is plural of "schema". Since you
are copying this text, could you please fix "schematas" to be "schemata" while doing so?


> +			      "shareable_bits" or "io_alloc_cbm" but no
> +			      resource group will be marked as "H".
>  			"X":
>  			      Corresponding region is available for sharing and
> -			      used by hardware and software. These are the
> -			      bits that appear in "shareable_bits" as
> -			      well as a resource group's allocation.
> +			      used by hardware and software. These are the bits
> +			      that appear in "shareable_bits" or "io_alloc_cbm"
> +			      as well as a resource group's allocation.
>  			"S":
>  			      Corresponding region is used by software
>  			      and available for sharing.

Reinette


