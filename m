Return-Path: <kvm+bounces-16202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE8C8B660C
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 01:12:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C125F1C215A8
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 23:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1793126F07;
	Mon, 29 Apr 2024 23:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KyLtAM4Y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CF51E886;
	Mon, 29 Apr 2024 23:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714432362; cv=fail; b=AFuM39TaLL5kgQ9ltEOy+QFeDoE7USgj00jMicHaSwSToKt2U+f/RaBaN2NzNBK+h5tloVo8My2YCAWyZMWPfSMrUwXG3zN+LbwWAdsh07Gq2Uh9ydLrHFI1377xu1pQJJiZVulY7ejdn253ZsJpw92Xw3+lXW/zXMLN/PADcTs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714432362; c=relaxed/simple;
	bh=I43nLxdIiSuRFU7R4v2U2wnX02XPMARjKt2WkVVyqFk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pG+BBU09XcTxiqGEMjNGwpmp7h9UnLyXajctc8KxT2vGh4quLcFk1Qyj2nnurRpF+oY7ZSJhBVa3czlr/yeoepfMTRh6mF+BZNd+ziiG7lNP4Ufz5sl85/7jdUlKAnjK8up6wiF8iLGaqMm5wL51MDaql1Ii98n1w9/Mdu63Yko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KyLtAM4Y; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714432360; x=1745968360;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=I43nLxdIiSuRFU7R4v2U2wnX02XPMARjKt2WkVVyqFk=;
  b=KyLtAM4YgyvFz5Ofhr1PRl8mI9okGJcYZiV/oIX2Q5IzZwKnJQts2V0i
   8Xf7Nol78KsRC8rymCG/T0QAyQi8K2gTDVHVOfyYTxPv6YE5rSsaML3XL
   6WYfOq78AFaaufrb8XYcOqRddtGyRMJAcWiWbtKx+UWMWKL7lp2BVsEsK
   VJViH7DMLVfym8Cd/TDXwejA5jpUdishXTPCeyE8Az6fJDrCF2jzxHLcn
   Ox2Meq7sqaWhEqL48Z0ZNaaoF/mTZNSVVsLtuPtwIIETu5R6TxdNIFOOq
   FNwxIYVD6W9s6VFhSvw5hT3yQ+hjbIgA00zLghxkNCrB1ZKkHE0Bzuq6m
   A==;
X-CSE-ConnectionGUID: 3ULngXzdSravfJ732Lu+Ig==
X-CSE-MsgGUID: VzriatiwTU+YEM4T9ykjgg==
X-IronPort-AV: E=McAfee;i="6600,9927,11059"; a="13941457"
X-IronPort-AV: E=Sophos;i="6.07,240,1708416000"; 
   d="scan'208";a="13941457"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2024 16:12:39 -0700
X-CSE-ConnectionGUID: yJk3IAUOQCOZmyLXJt6Fgg==
X-CSE-MsgGUID: u5dC7qSfRyaMS8aLm/VHwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,240,1708416000"; 
   d="scan'208";a="26769011"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Apr 2024 16:12:39 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Apr 2024 16:12:38 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Apr 2024 16:12:38 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Apr 2024 16:12:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bX8QJDBp59IXGEkRWAKfFPhvOM4JKVGgl8y0crvVYrMUzf0gL89mCxwSE83EnHd9VmEFId+pAvrI8DFgGeWoSODmdpUshjpmQnDbT1fB/RB6HDdNFFHogvr7uKcPXmw4LKKclHjhpWxTg22sSAQae2UgDlTO50U04nzxXJN/U3VbKCZBKiOV3pVCNomyRDw1Wnaoy4847YtelI0EOvO+sAFGrFlZPddEZzbD1SMZPZNU10+FiNJpwpfmqkvIkFnnY47VfugFlNjM7dR4yZcZASbwtAbpCeUIuOPyPj+jo5S3t0EbMJH4hpOP9jLKEmBScT7shBxEoZeu/Z4BqAVJ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L5ag8m9duaC+NqYVEvkq3U2CIsr6DA35n0x6Btwe4XQ=;
 b=FRuED4aK4XML6E9JS2IXYX0uA2IRXDta01atObbzsqhKgVWk+AkAqTJPh9UfjYhxmdVUjlNPaoSF4qXywOLSKzcFWkibz3AyYZXHx1zRPaDUTfm+FErkhCECXz3UtWDDc0ws8c5k+LCbTfIDrAY4QhanbSfyJBBmzRyKcilo9H94gTSxn1wHdvhMz4iZruuGLmCFzLfhPobBmncCImw0ovL4ppxyPV7FOZACesiQIsYUUjtxFkNJy+rucuuhR5M9JMtIWCrY3I5vsOunCC2MrRsZ16j7cTPsIX64m4ORvEe8kSTSocoQqZi+acKnECeOqB4MXJ9+FhcDl/p+Rjh7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7262.namprd11.prod.outlook.com (2603:10b6:8:13c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36; Mon, 29 Apr
 2024 23:12:36 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 23:12:36 +0000
Message-ID: <2eab6265-3478-45db-86a5-722de6f39e74@intel.com>
Date: Tue, 30 Apr 2024 11:12:26 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Sean Christopherson <seanjc@google.com>
CC: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, "Bo2
 Chen" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <Zib76LqLfWg3QkwB@google.com>
 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
 <ZifQiCBPVeld-p8Y@google.com>
 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
 <9c6119dacac30750defb2b799f1a192c516ac79c.camel@intel.com>
 <ZiqFQ1OSFM4OER3g@google.com>
 <b605722ac1ffb0ffdc1d3a4702d4e987a5639399.camel@intel.com>
 <Zircphag9i1h-aAK@google.com>
 <b2bfc0d157929b098dde09b32c9a3af18835ec57.camel@intel.com>
 <Zi_93AF1qRapsUOq@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <Zi_93AF1qRapsUOq@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0180.namprd04.prod.outlook.com
 (2603:10b6:303:85::35) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|DS0PR11MB7262:EE_
X-MS-Office365-Filtering-Correlation-Id: d480c237-a5e5-4df9-9552-08dc68a1db53
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QXlqc3RTNER6emUzOU9NZlQvdDMrM05BK2p4dFZKZ1h0YnVKeE9mem1qb3NF?=
 =?utf-8?B?c3Q4RXRMNUhrd1UyQ1FPd1MrK3h2TWhhcmZnNC9XeVFjQ25heUswWm9nS0h0?=
 =?utf-8?B?SHJhZGxPaXdseExRSTl6aStSTzNqZDBhMHloSTBBQ1lMcG94dHE4L0Ivckdy?=
 =?utf-8?B?cFduektka2VTZnFoa1JXelBXdlFsNGpscWhuRzNQQ2xjOXh5SWlqT2ZHMTNo?=
 =?utf-8?B?eldlM2lNd2F0OEs1cmVpQkJXSGVwVnRZVmQ5cUxmblpaVVoyZlVyK0N4bDZP?=
 =?utf-8?B?azI0M1NPQ0J0dDQ4QXJtaTRLN2c3cWlZNVoxK3pndGdqTnZmS0V0cS9TMlBZ?=
 =?utf-8?B?VU43dS96SitXK3FPNVZid09yMGloWlBCSldGZGM0b3QzQWFZcmpnNm5MQlNq?=
 =?utf-8?B?SHRiZVQ4N0N4aGwrTE9wTUNyZmVCajNxeVJjRThvL1I2aXV3d1A5blI0N0ZK?=
 =?utf-8?B?K3FjaXp1SWlLYXpPNDFqSEJaZGM3QjNTazNvcmxycGprUzVWUXBzNzQvMDBB?=
 =?utf-8?B?UC9ZYmhPa1pmRUZYM2d2c2JBTjlFTmxVLzRhdGxaL0x1MS8zTGlFZkRGYW42?=
 =?utf-8?B?amhyN1pPNWQ0TFA5RnFjZndVdDNFQWVQclRZVWE3YXlCTVk1TUkrYmYyekhE?=
 =?utf-8?B?VC9Sc0htS21WU3ZaVEQrY3BvSzZHbVJGVno0cTlkcjlpRDlzd3p5bUs1M2dv?=
 =?utf-8?B?SVBOclJUUDl6TXlxNDcrNDZ4V1pkek4xSFYyMjI1V2Q3MFFqSFQxK1BMc0dm?=
 =?utf-8?B?Mm9PcWJneU1xb2t4UG0xa1hrZis1ZGdXa0MvWGprNWlQZnJrSCtIaHl5TytM?=
 =?utf-8?B?ZTYwMGliU2VONVlkSHY4UCt0MEdwVXlCbmVaTmRZOXB1M3o0RVJjb1I0eFZL?=
 =?utf-8?B?SXdybzhyN3d1WTVFRGU3UHJvbGhCZzFhMDZQVmRJa3RyVGF0V3U0Q3R6THRm?=
 =?utf-8?B?a01tNG1LLzNZSFZYUXArR2dPa2VobGdlV2FOUDU3bzgxZVFoclhEeWx1Nm5O?=
 =?utf-8?B?OXBVd1IwVEVPdi9aWnN3and2dExicDY1MnlxWDFuVGxKUkdLcFRtSHNQZndM?=
 =?utf-8?B?WTJQTU5rV1JuY3VyQWZlYnJkZnJtalBJNGtXdWJYYkJLZXExdFV4VFg2S0Fs?=
 =?utf-8?B?TEVocDR6cEplbVFhb0pUWmpJZ2xnejhtRURtT0hOWU9nMG5jSXhQTUlTYm9C?=
 =?utf-8?B?cFMxcHRnbXN2eGx5NVZMREx0akxEdUhaa2JScnpaZmJ4WlpEVFNteGFBSGUx?=
 =?utf-8?B?Z1EycnQ0NHpIR2ora1l6RnRwY0xFRTBsYys3T1U4TEFtQ0w3WldHbWFZeUtZ?=
 =?utf-8?B?VElqTzNDWU5aVjM3TFVxT1dZWmI3dE5vVnpuMlowUkRIWUpWaDg2QlJtQi94?=
 =?utf-8?B?WW5jaVdldU14Vk5kMnNWVmhkcmdBMWVkM3hKTHRSd25uR0YvN2YwVE5GK1Vt?=
 =?utf-8?B?dmxLSTRVbmllaFMwOVJGb25xeHg3TzcyNklhSjJGajdKL1pET1NLdEdiVlFY?=
 =?utf-8?B?OXFEN3g3emduc3ZsUlpTd0VlSE96ODVWRDRZbUw1NEk1cUNoNEc1UCtOeHIr?=
 =?utf-8?B?Z0puQTg1ZVJ6R2JBSXp4ZEUvVldMWDZ5THB1aHBiL1ZobTh4WVZIa2M4WkQz?=
 =?utf-8?B?QzBBT2Q0WUJxVkxqNXZBejE0ZXZDWEhUZzRvdklkT2tLME13bEtNaGxnZFBT?=
 =?utf-8?B?WC9McUNSZEpoaEw5cmZmdnAvVmFPV3ljaWw2amxMdkpZQkU2M2UwT0RRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eTdKc3h4cWZZV0ZTd2hLZUdmTVYwdmFXbk0zeDZYT05PQ2E5M0VvN2MyM2xE?=
 =?utf-8?B?eFJDQUYxbUtUMjJtNVZmZ1R3RGN6V1VqWSt0UEZkcTdHVVNPdlpINGU4dFVv?=
 =?utf-8?B?ZlhhS2RrYTJPUXVZTzdFbFo1aENxVnVtRFJ0R1JmZjJjVHAzcHdydUpnaUJT?=
 =?utf-8?B?Q2xrNnRKaUVPZHJ6SmdVeTZRRWU2MzdNb3I3Y09ycUU0VUY0TExDSTdwZS9y?=
 =?utf-8?B?RkR0YmZvVGljN2tHbUlhM3pXYVlMdk85dXFDYkNzMS95K29raXlGVVpOK3lv?=
 =?utf-8?B?NHdHb2lNdGNTODR0QmtIb1hRZmxPZlRpdFA0Sy9FVWJrOTNoVlk0OVJCakZV?=
 =?utf-8?B?ZHVaMXNkTlY3TE05YVhtQXFNaXJCdWFGSFJZQ0c5eDB2MGtmYlNDQ3RtMUFY?=
 =?utf-8?B?TUttZit4dWNNNURCQVZPMlE2QmlVaTc3VGM3NkVmSGljZk94Wko0Z0JJOWFm?=
 =?utf-8?B?Qm9ocXBKMWNXUTBSRUxCMStsUlhuWkJaalJNaWE3MmJrNmFCQXFFcmNvVjB5?=
 =?utf-8?B?UDR3SHpVemVFQmVhWjQ4U0dMbWkxdFk4aTA0OFlwalBkL3lmMGpBQUFqZ0dC?=
 =?utf-8?B?enN6d1NMdnBFZmhjMm5IejY1QnYzVHRXSktHTFRGZUdlNitlUXh3azNlWDhk?=
 =?utf-8?B?ZUlrZjhPNXg0dGtCQVplRWJhUURoSEJRS3ozOE9RMUFKNVFzK3JzQVJUOXRh?=
 =?utf-8?B?L2I3SGx6QUFZVEVyZlRlanFGWGppUWNVL0s4RXJ3QVdralZTNTRLd3Nxazh4?=
 =?utf-8?B?alhveEpPSkxSajFjK2Z4WG9NY0lHM09lK0ZIZmNBWXdLZVB0ZHJocWRIclJy?=
 =?utf-8?B?cEM0Nyt2QTZFbEhqT3g3bG5GNW9RMnBCNUhwbElTNkVLY205amZ6TXFneTVo?=
 =?utf-8?B?YnJINStxTXF6SnFLMUtjbE9EYXFkZ29yWkdRRnpiQVZvTEpYR0t2UWFjQVBs?=
 =?utf-8?B?Lys4Y1JDUWhkQm5pUmVmaGI1ZDFuTy9HTkJ5Q0Y1SUhrQ2VYOGpCQnU4eWZx?=
 =?utf-8?B?NTgybFFQcThLcmNnMVNTZWxpUmpOcnovb08zQnBCVEdDd0NSWUQ3dkdpa3NB?=
 =?utf-8?B?Z2c4Z1dpMjlaZXBCUTc5c1pocm5PbnpKa200dlhqeTkxcUxDQ2pHelhRYkt5?=
 =?utf-8?B?bVRyMUdUUVF2Z254RUtYcGk2SGl5WlNNUU5HMEVHY0doV1g3ZzVXeUdHS1N6?=
 =?utf-8?B?QWEvUjdtNjlZU2g1QmlXM1hheE9UQkp3OUp3aGdyQ0RoMkt4WW10UDViMmJ1?=
 =?utf-8?B?T1Q1ZUZ5djVqcjJSeWxWb1NmRGk2RnJBeHZIRnMvajZEaUY4N2FCZnFYZW5V?=
 =?utf-8?B?YWNYSnBCc3pOcm1OUGFST0pNSUt5YWl1WlY5ckVPdnB2VEhQbWxlM1haOG5p?=
 =?utf-8?B?QlpBU3JKNjM4aXJQUUJMOHdwZEtTSjBIRGNEZmQyWEN1Z1cvNnJiWWdMRk0w?=
 =?utf-8?B?S0JoTFFlV3kzc0xMUE9RQTdIRHIvbjFPZkFOZHFpN2EweFVlcEhaK0FYOHho?=
 =?utf-8?B?WXcwVmpxQ09nMVliZWpwTW5jUFJ6NmoraHFUajViL0tDZlEwS0dVVE1pUmg2?=
 =?utf-8?B?aXRlNFMrSGRqS0FGQ20rU0Z0cEx3ZUVYVVJsV3gvS1pPOGIvMksvYlJZWndU?=
 =?utf-8?B?TmpxdytlQllSb3R3UVEyM3p3QVA4eEJCZUpsRjEyaU1XUE9id0ZXVENJQjV2?=
 =?utf-8?B?U2ZEZTRLOTQyd01BV1JlZml2WDk2N3dKWFM3TDk1NlVYellnMU9YWGNad0h5?=
 =?utf-8?B?ZU94Kyt5RkdhU2lraDRoT0JtMU9ndEo1N0lWdFV1enJWckEyb0I5dExnbnFz?=
 =?utf-8?B?MXlSU1dKS0Y2Q1lrS21qd1M2UUYrOTJZQVZnbG9xNFAya2kyNy9rN3FxemRx?=
 =?utf-8?B?QllxaVFNc04vZGM0WXgydUpER0hxWlJTT2hrUzNiYjVOb3NBTHEzRzJ4S3Qy?=
 =?utf-8?B?TzFrZklZeG02dE5HdmNDbG9oWmZKS0tqZzlaUzVreFdzeU1rWnQxV3NSWC9v?=
 =?utf-8?B?RkJVVHVwWlAveWtPQ2s5cU5PY080S0RwS2RMb0NiYnljUnhGVFFzemtidUhH?=
 =?utf-8?B?dXJWZUtHUkR2cUJyNGV2YllqdVZ0L2d0T2o5Z1lJem9nYnEvYkEwZEUxNTdw?=
 =?utf-8?Q?MegFglbZSHCOyTafr8goi4HyB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d480c237-a5e5-4df9-9552-08dc68a1db53
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 23:12:36.0966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hjr9gzvrHk7keY0z7ZTVNS23R5S/FivvJxSZdfpi7xMt4oNKdmKDwETfm73C+bdLFT5YsBvwTxjJNg5SuMJElQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7262
X-OriginatorOrg: intel.com



On 30/04/2024 8:06 am, Sean Christopherson wrote:
> On Mon, Apr 29, 2024, Kai Huang wrote:
>> On Thu, 2024-04-25 at 15:43 -0700, Sean Christopherson wrote:
>>>> And the odd is currently the common SEAMCALL functions, a.k.a,
>>>> __seamcall() and seamcall() (the latter is a mocro actually), both return
>>>> u64, so if we want to have such CR4.VMX check code in the common code, we
>>>> need to invent a new error code for it.
>>>
>>> Oh, I wasn't thinking that we'd check CR4.VMXE before *every* SEAMCALL, just
>>> before the TDH.SYS.LP.INIT call, i.e. before the one that is most likely to fail
>>> due to a software bug that results in the CPU not doing VMXON before enabling
>>> TDX.
>>>
>>> Again, my intent is to add a simple, cheap, and targeted sanity check to help
>>> deal with potential failures in code that historically has been less than rock
>>> solid, and in function that has a big fat assumption that the caller has done
>>> VMXON on the CPU.
>>
>> I see.
>>
>> (To be fair, personally I don't recall that we ever had any bug due to
>> "cpu not in post-VMXON before SEAMCALL", but maybe it's just me. :-).)
>>
>> But if tdx_enable() doesn't call tdx_cpu_enable() internally, then we will
>> have two functions need to handle.
> 
> Why?  I assume there will be exactly one caller of TDH.SYS.LP.INIT.

Right, it's only done in tdx_cpu_enable().

I was thinking "the one that is most likely to fail" isn't just 
TDH.SYS.LP.INIT in this case, but also could be any SEAMCALL that is 
firstly run on any online cpu inside tdx_enable().

Or perhaps you were thinking once tdx_cpu_enable() is called on one cpu, 
then we can safely assume that cpu must be in post-VMXON, despite we 
have two separate functions: tdx_cpu_enable() and tdx_enable().

> 
>> For tdx_enable(), given it's still good idea to disable CPU hotplug around
>> it, we can still do some check for all online cpus at the beginning, like:
>>
>> 	on_each_cpu(check_cr4_vmx(), &err, 1);
> 
> If it gets to that point, just omit the check.  I really think you're making much
> ado about nothing.  

Yeah.

> My suggestion is essentially "throw in a CR4.VMXE check before
> TDH.SYS.LP.INIT if it's easy".  If it's not easy for some reason, then don't do
> it.

I see.  The disconnection between us is I am not super clear why we 
should treat TDH.SYS.LP.INIT as a special one that deserves a CR4.VMXE 
check but not other SEAMCALLs.

Anyway, I don't think adding such check or not matters a lot at this 
stage, and I don't want to jeopardize any more time from you on this.  :-)

