Return-Path: <kvm+bounces-24560-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D185B957767
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 00:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0209C1C22BA9
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 22:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF701DD392;
	Mon, 19 Aug 2024 22:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTgyFcr8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD291586C9;
	Mon, 19 Aug 2024 22:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724106286; cv=fail; b=UWhr07TsETlCixKOty9vFEx2pO4EwTGLvzzrWVFSHAGv5xLCvJEHx3BkgzY8DUd4YuN7SIpKjpVLAUg5gjy5z521F5aAc6tn6lxbpNlcj9GX8njwnao5k+IduZchdF5IM62ArJFSk4Wp2S74zChrVhPlKlvnStfZnbWKCNXNxOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724106286; c=relaxed/simple;
	bh=lMbYHvb179ycJb2nb5bRxNnZJXQENRBhSAsY/NjYCYA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PjCgXauWVk/2dbB0oERs+AGIb+iuVDG8VF8b7p7FlEHn/GWvq2Hap9ytpx/9fUwccpqgci7owhb85NZNeIL4SMRwxMjElOMmRFWdhJTXuS7lpAeQrJfugNRgGJzyuxk9jfqxt0YEbLnwtNT8X5JQJjEbN/+fSGss6gOWUz0wUwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LTgyFcr8; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724106286; x=1755642286;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lMbYHvb179ycJb2nb5bRxNnZJXQENRBhSAsY/NjYCYA=;
  b=LTgyFcr8DXdeulVfIBwfXOhExh2SvXLngz3c7kuQtQ0lITIJe9DTbC0O
   2WUtmINnYMQDJVugzPsEyN3tWyozY+o+VjcQsD5Zng0xIYkfnbzx8wB0B
   FOQ+kfb2XmBVJMz5Hd6IqARAcB15ERXVg9ufJ/O3IaR/bZE2UAnT9CMfX
   UKLUAGeNaxEzRCZ6HIjt2izjmf5ebvBYCYlN6HY0xLYx4tCYhhCaGbmML
   64AMXwIVRHeWVKHJc5gg9Oq4ndru+MjbCGTrYF5nCle0dAH1Bi3aaNz0A
   pMA+7BuXqstBx9hYlGgBWGUb4KoZiVkf2/f9KufQ1pJULPp6yTNvD2Age
   w==;
X-CSE-ConnectionGUID: hCBotPufQ2OjRmjs/C2MSA==
X-CSE-MsgGUID: enmDNMHKThiVpAQkRZ79YQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11169"; a="44902656"
X-IronPort-AV: E=Sophos;i="6.10,160,1719903600"; 
   d="scan'208";a="44902656"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2024 15:24:45 -0700
X-CSE-ConnectionGUID: wcQE1FEDTmue5uSyiS0lbg==
X-CSE-MsgGUID: oudc5giJSZ2+3HUD6oduqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,160,1719903600"; 
   d="scan'208";a="61069891"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Aug 2024 15:24:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 19 Aug 2024 15:24:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 19 Aug 2024 15:24:43 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 19 Aug 2024 15:24:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 19 Aug 2024 15:24:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P5eCcUQA1yHXfV/VvsfF0GcpMKDYEbUCG/sy1VqPat2HnbFTMoAgv7nhLRaJdQMBzW5u/dQzGfYfxOJWYMRVkhjXC66XtVAVdKsd2tp3jGnJQAYNqxA694tlbVC5yrwhs1ba8GYyI9BkkQ241dulsJG40/L/inPanhWHQCKgxJ8grnDjpTtSpKbhz39CBEnJLM+ywDwxKp9IKI8abwF8htkxbFeAUKPzt+NJN+tHLYq/Cer37w2CIRQm1NbEryWg1Z47+cTS/fLzuhm9fWJjCe/QK858LChKkdQ+UbgeKuIXcn59JhJ0kFS0Udwab6cy4ggb66e8nvJVSMd6PYjBbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DAvhPo0eRRav15BY1itfnDoLSOmsqWBVZ9Zn29/sZxs=;
 b=LG3w2KuKdgV/6iItAsnUrbUilt+5AWfr7pumY3AupwTOlRvgf9KJ6pu5g0OvbNehs8fzorjxyBaGzU4gl7zuW8uMeHD4qHyNThsCpAoIoEC4mhtergR6wYP0Kreu/tJXwDiybgwO4QjIIXa3vQ0LO0jhAtNBeqiLVHw/V5D/luLod3QU0Cjkyr6aBhUOG2eKz3YYgawW0ysjWCArRA1Xke3wdME/U+ruKLqN5oKsnvLa/rr67tORCBcIKY5j4xZirt3EuZHSFV46MxRHkGaJIp/jBDLgEB7KNh72EDr1Z6sFMafSXSot2wc2MXPqME1bd1nQyiKNHeA/QBDkCPucEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8156.namprd11.prod.outlook.com (2603:10b6:610:165::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Mon, 19 Aug
 2024 22:24:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 22:24:40 +0000
Message-ID: <928aedc4-beb4-467a-b4f5-4df35ff165ea@intel.com>
Date: Tue, 20 Aug 2024 10:24:32 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] KVM: x86: Use is_kvm_hc_exit_enabled() instead of
 opencode
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <isaku.yamahata@intel.com>,
	<rick.p.edgecombe@intel.com>, <michael.roth@amd.com>
References: <20240813051256.2246612-1-binbin.wu@linux.intel.com>
 <20240813051256.2246612-3-binbin.wu@linux.intel.com>
 <0b27494f-7ce0-4ca7-8238-cb95999b3142@intel.com>
 <d7995584-f844-4a05-99d7-a3a85ef11516@linux.intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <d7995584-f844-4a05-99d7-a3a85ef11516@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0136.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::21) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH3PR11MB8156:EE_
X-MS-Office365-Filtering-Correlation-Id: b5cc4a2b-11c6-4616-e336-08dcc09db7ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHdNY1BLTHBXYmp5M1RONDJvUWhEUjdacHFubXNCRUtEU2JRcjlCV3Y0VkJG?=
 =?utf-8?B?eHN4TGp4UEpyTDZkOVR3SVhacnptMU5kbXhmcnlBVlAyUGkvN25Tam5Tallx?=
 =?utf-8?B?VS9RMTJQZDJvUXhzYnQrSk1XTEswVU1UbXNkWVJKMEhaZVA4QXJhWDBSMWoz?=
 =?utf-8?B?UkxIK0x3STRtdHM1a0hlSDlQc25MRHV4YXViajgzU3JpVFR0cFRSUTV3aGVR?=
 =?utf-8?B?U1hOckk4OTFMSW1td1pvMHM4QllxR3RSMVVQcXRBSWsxTGFPTUxZczhmVnI1?=
 =?utf-8?B?cnRsMlhzU2UzM1hKT3ZWbm9YZFFROXhxSWNoT05BengrUjRJdkJYTmk1akx5?=
 =?utf-8?B?MDlkRlBEM1padTEwd2N6TTUzVitsSFE5QTFGdFk4VVp5OWZuZEhXdnFpVGxu?=
 =?utf-8?B?bDNRM3UwempmaTN0WUo2UGpTUjJzOFVNSHpzWHNtaDFURER2eXVUaDFjOUx6?=
 =?utf-8?B?Y2MwVm54WjNqYkhEcVVzYXNVVGlBSGxwZzVYVWtkOTNVRHBGWG5Gc25xYmN4?=
 =?utf-8?B?NHVVUzdPMnZOOGhwOUNKL24veHcyZUNHS2RwVE5IbFo3Mm5Nb2trWVhVRlFz?=
 =?utf-8?B?dzNIc0FIcVVPSFZ4dUcvYUgzS1Z5U2lHcGt2M254WktTUFA0UmVtREFLMEQw?=
 =?utf-8?B?Q2dEQmUvYytjdStqME5kdnRLRWd4ZEZRWU9DVTVCWnp0Z1A4dGhIcFU4R1pi?=
 =?utf-8?B?SU9iRHFYOHVJMUZjaWdnWjNjdHdIektHU1UwMnk4UGw5Wi9yWlNrbmJaQ3Za?=
 =?utf-8?B?WHNrRkdHUVZsdnI2NFk0eHBFVkh4OW1pM1FnQ1VvS2M3TFd1UzNUV0ZNUXhl?=
 =?utf-8?B?cXcyV1lrNHdaNVduUktMd2dLWjNON2dMd0kxdkN1UlRiSFlmaHg1MWdWVVNo?=
 =?utf-8?B?NVNVYWRyN2NOVmd5Y1ZvZW9NWFRjdWtleVJwOThzbUt0UTBxc0ZUbWVSckcw?=
 =?utf-8?B?MG5vb1NydUx0WjRqcTFTbXZHaEx0N0dIS29jNzRDS0lZUW55TzExZFhIOWdt?=
 =?utf-8?B?THZUcEtSenlDOGFha1lUUnhpN2plcHo2NitDdzU5VWJrWE9GM0VQaW83NmUr?=
 =?utf-8?B?K1cvU1o2dzAwTUUzT21YY1lpTVdibG5EZFJBaTBZUk9Uak96dHE3SWpKSXlv?=
 =?utf-8?B?R25wTTY1SSt4RUxJMUsyamN4c0dsV3NuZ3J3U0RoVmI3cE1IakxKbDNXNjYz?=
 =?utf-8?B?Nzdscy9jQ3J2Wk1FNUhrSEJEb2xTQ0ExTU1NeFJ3SVY1cWFZcklOdWhmNnIr?=
 =?utf-8?B?L016MGk4QXVJYXlLaU1PWVYxVzdOUVNXbzlCV1dWWW04U240dzNVdXBWSFhC?=
 =?utf-8?B?QmhYMnpZTW5RbVB1L29hNGxJMXlQWHpmaVhJVlcrQTNYYkpiMTlNeGF5SWlJ?=
 =?utf-8?B?YUI5VmZrTy9OR0FDZGlqa2dvKzU1bFF4blJoekhjZ09JWnNRdDBBQWNicE1r?=
 =?utf-8?B?UUQrQmpwMVVHWGZSQUVzU3ZtUWdvTXVRQWw2aW1pbTBqdlAyc3ZxSzhNcmxv?=
 =?utf-8?B?UjJUUlRXbFp3ZjhsaG5ZU2l2YTFIQWVjdzdnQXBNQVB0VktXUWRCNW9yNW9B?=
 =?utf-8?B?b2FmUlQwclVBZFkyRjI2bklQeVJld1o4MURGWGVmREdHQk1TU0VOQVJLY0R0?=
 =?utf-8?B?QUFVdjJIdzFnWVB6ejhFNnRJRHdPTEJuVCs5dlNueWszYlVnT0hJYVVJS2pO?=
 =?utf-8?B?bjNBUzV5U1ozb2s2YnprQ2FlSVFuOEZhMTcwTnFzZDZsYjFocUtoSUQwS0No?=
 =?utf-8?B?T3FGYVFTT0F4NmlwVTMwVTlTVHVqOGtJMFFEZGNycDVBTFhXVHM3bjZITG9W?=
 =?utf-8?B?R3REVzBudHU3YURCOC9JZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXh4V1FSQUFxdy82WHVHRTlIemtwNTFmeGFoQm9yZGNNVDMzZWozbTU0NEg4?=
 =?utf-8?B?SUZjMEY4cHNSQ3ZhZFlOTGcyd0doTXZsc3drSE5RTE1aUnZLMGVrNEJqSEdO?=
 =?utf-8?B?UGJvcDVnSHBNZWF3VzRsNngrbks3SXFhajN5Vm4rWGxwQndPME1US3hHdVh5?=
 =?utf-8?B?a3dOU2YweVc5SG1xdjFKR20zV3VxN3cyYkx0dlo1SE9EcGdYdlFHeE5KMi9J?=
 =?utf-8?B?V3VmaklEcWVGUmZUVEsrRFdHbVoyTThVUFRoY0p4Rm54QXgyUjNHYUVEbm8w?=
 =?utf-8?B?ZnNMbGZwam5PTHJXdHE5NzZ1Y0Y0VGJqYkNWRkpNWXdDSzJzeDFRK29rcDF1?=
 =?utf-8?B?WnZOSlcxd0ZlMFlPT0QrbHNiT2JTZnVQZ2RXRzhoTnFwa2QwZ2lkay8ySmdk?=
 =?utf-8?B?UXN5UTZDVit6SE94R1MrMXI3NTB6NGhsVmYwL09mdll6RlUrVUloKy9qY2pW?=
 =?utf-8?B?Znl2Sk5pTkwvOWkrN1NHZnFQQitLY3I2TXk2eEwrd3Rab3BaT3M1c1dtN1ph?=
 =?utf-8?B?SHFWZThmVm5oVXQ1SFRKOHJ4SmFHTWJQYXpuMUhXZ1Z0OEY4bm9LTVdmK2Nl?=
 =?utf-8?B?M3hDMjFBamg1MWoyUEFpVDgwbGNidXg5Q2ZTTUxMT1NTNlZHbGxMOW1VdnBa?=
 =?utf-8?B?VGNCNTByREF6b24xQ1FoM0pBeHhIOU1aclk1ZjZwZGozeENmd1VxaTZnRXJY?=
 =?utf-8?B?Y3JpVnlCNTVKUzBYRzZHTUY1N01MVTJpL0ovTm1kRU1xbXJwZEx2QjVDeVVU?=
 =?utf-8?B?Z3VFeDJNdXRkbkhhTkRCQjh6ZU5EUFZGbzB1SGMyU1k2TWZoTitmRVR4N3Vv?=
 =?utf-8?B?dWQ5bUxsTG9LSWRTRktSbGIwVlUrSU1PN1IrNVA1NU9GUGpLUUJyelZjR0Vx?=
 =?utf-8?B?T05ZTFYrM3krbEZ3aTNUOHg1YzFJL2tJY0VUaUErME5Xd0ltQWN3NUVHWE9q?=
 =?utf-8?B?Rkc4UFlHN2IrYzRWcGdjbUtUa0lERXcxZWhZT3JvMElqcVdtdk51QldEcWRM?=
 =?utf-8?B?dG9GU29adm1rdnIyWW1MWE5vQmFEa0pZUUxyNTJpOEQxMXRpTVc1MndmdmdX?=
 =?utf-8?B?b3ZqTUtmc3ZrVUs4dzQ2S1lxVzlrVlY0ZjRRa1Byd2U4MlRxYmV5ZVpvRGhJ?=
 =?utf-8?B?d2lHNTA1R1V4Y0x2bEtIekVlZExlMHpnV0pRbmFiTTdJYktDNUlMUUtlaEdW?=
 =?utf-8?B?cmNwdlRzKzVWUDAvelI0OTVORUJ4cEdzSk5HY0lIZDBCUjFFR0cyMEltN1gx?=
 =?utf-8?B?cnBWOS9TODFmeW5aQ3dubU04aWJkV25SMDhrYmRxclRoWithdTRiNlFITm9o?=
 =?utf-8?B?SFJiQ25VbUIyWTYrTlhHTktEZ3VtSGxLeHlFTStzWDg5UWJENm5VakdFVzdw?=
 =?utf-8?B?V0ovNkNhOXJKb0d5THBCM3JDTzJGbDZjcWVURFBlNWgvOC9EeHBkRzR2VHcw?=
 =?utf-8?B?U1lLQVdES245TGFYQWN1VktKRFZEWkpmOVRHbUZwM0xYa3dhR0lyeHZ5QmRV?=
 =?utf-8?B?RFdDaG42QlgwUEptSnR0dHpsK1VrbXNOcGVIMUZIb09RMHFjbWFMZGZUY2x2?=
 =?utf-8?B?dklBbmg1MHlub2pwOEZBZHVLSTNteFg3eXpjWHloeDU4MmI2UURyQklmdGZl?=
 =?utf-8?B?dUpQMTVDeDM5MDljbUo5Si9SckZBelVCYXhBTEo5bzdMenBJZHM3aDNManBO?=
 =?utf-8?B?OW1FeTZYWjI5bFZhZkZLbDVlV0ZDL0krZ0xHQTV1YXVDc0VQeUxrRDVwbGd1?=
 =?utf-8?B?aGNTNjZHVGJRc25rU1orSmhvRWtkWnh4Q0t0b2VCcWRWRzlOSk0ydDYwU2s2?=
 =?utf-8?B?Y0t6QU9NRjJ6R3RrUmtZZC8rb0tZN3g3ZDBmeFRicTgyVk9NUENUanVQNU9P?=
 =?utf-8?B?QXh3OHI3dzZtQ09nNnAzYlVCY3hwbzhSaDk4TlRKd3dnNGorRTI2YUx1Zkd5?=
 =?utf-8?B?bElmUXZkRlYxdW5NZWlVRVJOWXZQTGV5ZDcyYUdDODBSdWs4SmoxL2pLM0Nk?=
 =?utf-8?B?SHZEYVZVbXUrSm4vOTJubmVnM1pLcnN4aitVenVrVTVYeEhzNENHc1RIbWpS?=
 =?utf-8?B?RmVvT2QwV2k0aDRES25BSEpYY1RLTlo3dDMzNnoxbGI5ZXVJc0dyTHJZemMv?=
 =?utf-8?Q?5Mepmy/Dj6+khWexYPpEpwKjc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5cc4a2b-11c6-4616-e336-08dcc09db7ba
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2024 22:24:40.6178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkTUtLaRxRH0W8/XiGtBcbHib4RwtyZeQ02fSoC6r4sGyNnrxbtZuhuh1d50fmPKlxnYaMAXRBRzzUTVmbA4eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8156
X-OriginatorOrg: intel.com



On 19/08/2024 10:07 pm, Binbin Wu wrote:
> 
> 
> 
> On 8/14/2024 7:18 AM, Huang, Kai wrote:
>>
>>
>> On 13/08/2024 5:12 pm, Binbin Wu wrote:
>>> Use is_kvm_hc_exit_enabled() instead of opencode.
>>>
>>> No functional change intended.
>>
>> It would be helpful to mention currently hypercall_exit_enabled can 
>> only have KVM_HC_MAP_GPA_RANGE bit set (so that there will be no 
>> functional change).
> I think it's not needed, because is_kvm_hc_exit_enabled() takes the input.
> It just replaces the opencode with a helper API.
> 
> Maybe your comment was for the patch 1?
> 

OK.  I guess my brain wasn't very clear, feel free to ignore :-)

