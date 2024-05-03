Return-Path: <kvm+bounces-16465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DF638BA47C
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:21:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 751091F2158C
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14D8E256D;
	Fri,  3 May 2024 00:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ii+d+lOu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E970C1367;
	Fri,  3 May 2024 00:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714695687; cv=fail; b=Y7fHGvGk5WmlF9JObPrGqS2oqcahhmvG9KagkMJegenrKYLbGZtzirWRItqlO8kicn3/Aac7QpKqXlzPqifKi1iqdhYDwmlgL4CkhZCg+WNSCoMBcf8oPmHDa3U5z2UUk5UTvAi1kABqw88rtIp+veKSxOtKWi3JAs8mQnYQYFI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714695687; c=relaxed/simple;
	bh=R9MxOXNQmmBlDH24V3iVXIk4twPBkXQbpLLSymtVRws=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pI4h0BEtOBW/npWiZVKLDeCw/pL5QR9hEwk3PB2jj2Vfm8ysZZM5lkOkDcF/d3xyga5MoMf7yOVNwgRLQLYHRjEgppXrmNOLqX5aAGzhc3o/ajFlv4LVh+weHwiabzppl54jkU7XbFaYQhHdnNth2pFFvcOoAHmLW/EPVh/4kww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ii+d+lOu; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714695686; x=1746231686;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=R9MxOXNQmmBlDH24V3iVXIk4twPBkXQbpLLSymtVRws=;
  b=ii+d+lOuUhCGEupu3ed0ExxaKFjxmSoZQw/Ow5RKyA9b+VgqiU4whxGJ
   CeUrjDCvMe+nStMBzvVnvCGwCgS6u3CFf8oiGZLI4VdZyiepx7ColXWNP
   EHZ9/HXKlRalGMoLHi2sifTDfjaQ1CayzZyJQyWseOxBxAxCtLHNtHrMS
   QUi7J5bZB/0iJJL1RLPguR+GlZNUe04NYbgwS2d6aCmVoHxMIkga4Skdz
   W1KV/S7u/FOhjpDVYupMYn7v/DxW+Jq35LbWpz9B7vAdJ2trQV9fyGZey
   WaJf/PYNPH/DVUSpqEckLATXu/ifCIzwQmc8Zbkeooz6MVAYtBjN9aPYj
   w==;
X-CSE-ConnectionGUID: zGohlOtORNmqLucsm58XWQ==
X-CSE-MsgGUID: +usXMKaBQ5ag/5+gpQ5b5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="14310654"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="14310654"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:21:25 -0700
X-CSE-ConnectionGUID: i8xan7hgTCu6AB9qkrqZkw==
X-CSE-MsgGUID: u5hP/y4LRy28SIq8IzrXdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="58486133"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:21:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:21:24 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:21:24 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:21:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXlX9ZTzsC8O4t/lpOQYy8SBXuXOwml8UFey2woalrcIgu5jC19k/6q5uKOoXhgrVQsQN8RxQrLD6tiqBTRZ7MKIraeOCjcOwZam+ZpRLc5OxGCle9IfNSoJ6KB5OGTGKxi11HjoYuGt56LPorWYNX0IbMn5ammIGjXX7hwH4rIvuJ3zj6U1yb0CtTNuu7+Mxk975jrCCkaEA2QcwKlOG1EMx6G+unfU6qruajEg3dgzIXwhxYU2yWet9IyEoMursd3zt5GWFIjAMokqylL7cFhiFMPwfKD2i24m3GSd57WWMnfLTNywgLySBOSUwDkke6vZg3b/65a6BY1eMNm9IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R9MxOXNQmmBlDH24V3iVXIk4twPBkXQbpLLSymtVRws=;
 b=cGfZWQ8EBYzc4V4aajTAZcIwh5a3X7KRgxeTbkT4jRuFb/Il9TS09mcGasLSOMm2t8S6ifMmYF2+ua7iVTqu+Xi0bUebbuBQAu9hp6jnSmNz7vIev8czvA6QjiW3f/Y0J4x2Zb1fbFtkRQL16HnOtkIYUPb7Jnc9uVWKSCMbuzV7KTcaPWaryOXVhtlm9hoAaGVd381agFZlDR+S4bxzWvjZNHk9wjf0CqjdzPTJIzrNHZwe3Hb+kmXhDc378TmZVRCvjsce5sT+Gg+MakbzbI0ei2P8uo/qAl1Za7EaWvL1b1Pr8oENLBw+mpmg8F1nhLgctZ6drxewr2+ZlWEozA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7197.namprd11.prod.outlook.com (2603:10b6:208:41a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.32; Fri, 3 May
 2024 00:21:21 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 00:21:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Thread-Topic: [PATCH 5/5] x86/virt/tdx: Export global metadata read
 infrastructure
Thread-Index: AQHanO1LpwQKjb3BWkmudfJCqyD9LbGEpckA
Date: Fri, 3 May 2024 00:21:21 +0000
Message-ID: <affad906c557f251ab189770f5a45cd2087aca19.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
In-Reply-To: <ec9fc9f1d45348ddfc73362ddfb310cc5f129646.1709288433.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7197:EE_
x-ms-office365-filtering-correlation-id: 025fbe00-bf06-4710-9f49-08dc6b06f5db
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|7416005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZU03bWFWOU53dWd4Z2VSdW9HWktYcG12T0xDTHlTZGhTblV3Y2tFUmlmVmhB?=
 =?utf-8?B?ZlErSldoV2xXN0tQdG13QldMclpoeGtjZFVGT3NiMzRwRUpXck52N1A4Qkcy?=
 =?utf-8?B?aERRQ0Rqd1l2M0NibExiMHZxK0xod282dmVMcXNLdmN5eUNuWk5LUDRqNmd1?=
 =?utf-8?B?UTk1bG4zQW0xRXp1emhRR28vZHRKcVNpcXVTbHlMVmtHeTFSUHMycVVmWEU3?=
 =?utf-8?B?Y29mTVN4bGF4dVBOT3NScVQ5RWtncDNCZWVHQWJnWFlObWlER0kzN3BLRTdw?=
 =?utf-8?B?WkEzN3pCT3NCQzBMS2VkMS9SV212RGF6bExHUnhzcGpmTlV4QlBRYklyNlJP?=
 =?utf-8?B?b3VtNjQ0eUFBNzN4eDBOMHhBbGNPVisrU25hLzRQcDZSbWJZNXpNenp6N3d3?=
 =?utf-8?B?UG5HdTd0UFBRNWxLM1VJMHdlU0VZUzFlbng1Um9mRzBMZU5pYjhoUUtieWdT?=
 =?utf-8?B?V0piRE41eUY0cmFlZTA0NUsyemJhTTZWY2RJcVFaWmpWRytaZmdCalcrR0lo?=
 =?utf-8?B?QjlseXpBazVvcXQ4eUxGbVlWRjNlQTBMSUdIeGxWb2xoampGWTI5UTg2amRZ?=
 =?utf-8?B?bDZYVGVqTXgxTHFIaUJ3WGZmTTF0S0pOeGdVRU5tRG96V1NhaEh0cmM5R0lD?=
 =?utf-8?B?djB5TVQzTks0TGxTRDdBV1cvRU5PR0VkQXdzWlpoSytxU3RoTHh5MGllOGM1?=
 =?utf-8?B?NjZka2VrejBsRUFZV1FJUmIrM3drUnZyZ0VlYWRmSXRBdVhMS3dSQlRZUFJp?=
 =?utf-8?B?ejlWeGh1SCtvSG9xN1NtN3dXNWtJR1Z3OE83LzJLMlljUmlXWFc0ZWdsczlG?=
 =?utf-8?B?VkhKUXdqalpRdERPdnZ2UmZmVWluaEJ6NmMvV2FFSy9EQVNNbUpGOEhoMUFm?=
 =?utf-8?B?OVpmRi9saTBNd0JtQlVEQTJQT2U1UUgrS3RVc1VnNVRJTitNc1o0aVpFUWZu?=
 =?utf-8?B?dDJOQ2FaQXZOSmdoY0Yrc2JDWVVuZm4vbUZLK0ZQdDUyelpHVUtNZ0Z2dlp3?=
 =?utf-8?B?TXBqemVpVENZU1BPWEdocXNhbUpGeGg5Z0NvSVdDS2hzNXRhamdmMGFxeE01?=
 =?utf-8?B?SVV3QnpBenhsUDFQSmdjUjV1S21FWGROTWNvUEZHNkpqdmtOUHlaRFVKT0o5?=
 =?utf-8?B?em90OC9BY1UvSG9RaVR4RlVXOS80R2tNNEorRy9tOHZLZExVREFlU2owNjlN?=
 =?utf-8?B?UHYycFFRR2F4T2hMRDBkdm5zR1A0Si9ublc1NVYvS3RPZGdZR3FIdGVSNjNm?=
 =?utf-8?B?VnQxQmFCdVp2UEFyaFUxV3BacDFhUFEzVGRwT2xBcWpKRk9lOWI4dFpCclVl?=
 =?utf-8?B?cStYWXAzOUpYVHpoZGdrYXhUcGZkOE9qcHR4TmVPTUF0VEpvNVdVK1BRdk4w?=
 =?utf-8?B?Vk83aUUxMU5JNDZLV0pkN2IyOWtkSjV2SHphN1NtOUt3OGRSZzhSRzlWd1N1?=
 =?utf-8?B?S0luMGpqNnpFSCtrUVpkM2ZkbWY4K1EwWjdwWEhCdm40ekdBS25HSVUzQnJY?=
 =?utf-8?B?VUs2WnNPQmFwa1R2YVd4dFpFTTF6NEl3TUZrNVU2eGpNMmJNb0xpdTNOMktL?=
 =?utf-8?B?c2xhQTV0cldvY2tBckV4WlY4MXhhY1dsRC8ySDgvSU1oZ2F0Q3FTUHJIdjkz?=
 =?utf-8?B?Q2tRWmgzc1JSRm5Zd3FrTVordmxXMGhISDRhTEQ1WHpMUWFMSWJTajZCZ0lR?=
 =?utf-8?B?SEFBTW1RTG9KRnRrSFB5M09nUVlIWVBYNGZBUjJQTzBtaEFkb3lPcDhhbWVz?=
 =?utf-8?B?ZjRuWDRMYVYvU3puTWdtWU9pak1CNHJ2dWJWSXZTMW5ScHFtbDFUVlhnRzdy?=
 =?utf-8?B?NEVEZ1U5N3U5OURhZWVZQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlJVMVNMR1Q2VUVZOHZ4ZGxYb2lRVFM2NzY0Mjk2TTgvdHV1a2Zwdklqcm1a?=
 =?utf-8?B?akRyemowRm5oRFpKZlBzcDBKRXhjeExYbXJXeXI3Sko1QlZsUFJmTUxtTDhH?=
 =?utf-8?B?YUpmcCs4TWo3RURxeUF5aTNzZ1F5QjI0YUMyUTA0MkQvOFllLzhBd2F3N05E?=
 =?utf-8?B?U0s0V2l5eUxiUlcyczh0OGFBdzdUS2JSelRrZ29DeGhUZDA3ci9FNWhpWFJE?=
 =?utf-8?B?OGFUME5LN25mVHFNWUVaZVVVcnN3VUh5eWFLQnc3RFNPV0lnelEwVTNpenlP?=
 =?utf-8?B?K0FMYTNUSlNwTlV5NEF4ZzhWUEF5b0g5ZFR5aHVjUGVIS3NHdTFXbHhXQnh5?=
 =?utf-8?B?T0QyYUZYM0t5VjJCbHhndzRRbnVkVFhUNVg4UXpuSHJrUmVkVDBLV29pc2hJ?=
 =?utf-8?B?UmF2S21XbkQ2MmpUUy81OVIzMWtKOVBaSjNweHQ2bmZqRnhRY0ZDOGZpWGlL?=
 =?utf-8?B?dlM4MGY4TlhWYjRFTVZQVEpkNzU0UitkNE9OYW1kazVGazMveGFyMjZaUVBO?=
 =?utf-8?B?R0lDZEpIZHN2dm9uYitqdjd3bk9NWmJtZE1Cand4cU1NaVdBV1VFa1ZFaEhv?=
 =?utf-8?B?RXd1QUYzWVltRXJDZ09mdXk4ZXM3cFZoN1R1Z0ZTUEdFV3h2UDQvTXAvR0Mv?=
 =?utf-8?B?eUlXdWNnVWdGTTdIZThJQlZTNENVdmU2WUFHK1RGR0xaMXVHTVNpUFN4V25U?=
 =?utf-8?B?OHV5ZGhHN1FnbElwMGdjc25rVjNqRDBjMjYraVlRNHR2RHhIMUg1Wm1lcVVh?=
 =?utf-8?B?L2dLWXpqTEtUb2JxNmJ3NXN3UkNlWDNLM0txSWNEOXN1U2NBeW1uOHFLUlYr?=
 =?utf-8?B?WXp3My9Pc1F2TWM3R3J5YWY0ZUphSWFzRTMrUjd0eXZ6MStkdEY1Y1VCV1Fz?=
 =?utf-8?B?TzdCdnBjcHNqKy84ekFUYlJyakZkay9VK2xpOGdsR3d0Vm9nampETW44RENY?=
 =?utf-8?B?MGRVMklSdlRYVHBzTEJrc21XQTBXdjZKTFgwejVuOERsK2txckdCRGJtMXZv?=
 =?utf-8?B?WU1lZzZBS1dDdDNINXJkRW1vWkpib3MzWDlidHNFRW5PZEdWeC9Pc0hlSVBT?=
 =?utf-8?B?RmU4RkRqWWlLRFVsYWxkcjVqOG0rY2dnNFg3RHJjNG54L3lnQmFOOFBPSzkz?=
 =?utf-8?B?Ujh6ZlhLZnQyalpaSHAvY0U1M09adzgzaW41a3FhYUdmQ3ZEL29DaGJBTSsr?=
 =?utf-8?B?WXFMeWV6R0dYZCtvUmw1eTFNNnBaYVJHUC9ucFlaUHJJRTN0Q1NEYUM1SUVF?=
 =?utf-8?B?QjRBZ1V5bXJrbUowajNRVnAzRTZ4K2NJem5scGFoWEQ2VnhSLzVJMktkRDha?=
 =?utf-8?B?MytFS3lTTjFxQXZybnFjWWZMc0xFdFBnZVBNVmwvNU5qUUdSWEFiTldYc1Bj?=
 =?utf-8?B?YllxTSt5WHhxZGRJTGtIdVNraUU2RUczbUFyUWxpMWhUNmM0cW5haVpnY0Jo?=
 =?utf-8?B?MFJqaU9aaVIwa2N0cjBDT3RGaHRQUkxZSU0vN1NmcEFvcGdaUExwMWdkSUwy?=
 =?utf-8?B?QVZESEFjZUZDL25nT0U2Ym4yZXppT2tvZlFsckpqbGxFZnVhc1RGS2RmZXFi?=
 =?utf-8?B?allnZ0E3VU1iZldLaDNwMEJwdUFJYmhYT1hoY0xSdkY4SCtNU001MlMwTzhW?=
 =?utf-8?B?ZVZYUGcyUkpjOEhFM1o4U2VtUUlKZzhIMWh0WkVLU0xwak8zZnlqTkZpZkx3?=
 =?utf-8?B?RnJ2TnFXdjVFZFovUWJnTDFkYWxGak5LSjlZTVhvbG1TUWFycDBuOElxNmkz?=
 =?utf-8?B?ZlVnUVFjUFR4dkVnYU53bGs1NGM5Qyswb0NNRE1kMmpFa1VTb2dSWnZEVmtj?=
 =?utf-8?B?RFRldGoya3Q5MEdnRzFLdExRdGtqM29XWEFLWEdBUHQzajF2d3IwM05sZ1Uw?=
 =?utf-8?B?TVhUODZwRW1YRlJrNDB3YXFyMWFtVm9IUDFBL01jbWZpRVdBLytnbGlPTGhV?=
 =?utf-8?B?Nk5NUXJPSStQbnRobStWdTlTV2MydDcxa1B3Z1BvYnpHVmovSzJSVUVQOUJo?=
 =?utf-8?B?YzZQNHIvYkxzNStXMDg0cnBpQkZnZ1U3SldINTh4S25WaWEzT1JSTWtqeWUr?=
 =?utf-8?B?RDB0eG9ZaTFLcnMxRUx6b2duZ0c2V1U5N3pMZUFFdE9hVlJtSDJkZWt5d2RV?=
 =?utf-8?B?UFhqSXdsVUt6VjF3TmRZcDJ1K2VkTmhRb0htSm9DS0xKVkVVbU5yc210b3Y3?=
 =?utf-8?Q?0IK+bae1VfCCZqwaz4RFKBE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0869767214DE04DA04C66E4961EB732@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 025fbe00-bf06-4710-9f49-08dc6b06f5db
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 00:21:21.8028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FCmA5tasEiNuGFHxEzSBm30AHpgCLu05He/f7HhESbaHZRwQW/dMkKnloUzx4ccvsrr6UZqdKU09zdCsITUPeE+df1cMRCglgND/IEXGyRI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7197
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTAzLTAyIGF0IDAwOjIwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IEtW
TSB3aWxsIG5lZWQgdG8gcmVhZCBhIGJ1bmNoIG9mIG5vbi1URE1SIHJlbGF0ZWQgbWV0YWRhdGEg
dG8gY3JlYXRlIGFuZA0KPiBydW4gVERYIGd1ZXN0cy7CoCBFeHBvcnQgdGhlIG1ldGFkYXRhIHJl
YWQgaW5mcmFzdHJ1Y3R1cmUgZm9yIEtWTSB0byB1c2UuDQo+IA0KPiBTcGVjaWZpY2FsbHksIGV4
cG9ydCB0d28gaGVscGVyczoNCj4gDQo+IDEpIFRoZSBoZWxwZXIgd2hpY2ggcmVhZHMgbXVsdGlw
bGUgbWV0YWRhdGEgZmllbGRzIHRvIGEgYnVmZmVyIG9mIGENCj4gwqDCoCBzdHJ1Y3R1cmUgYmFz
ZWQgb24gdGhlICJmaWVsZCBJRCAtPiBzdHJ1Y3R1cmUgbWVtYmVyIiBtYXBwaW5nIHRhYmxlLg0K
PiANCj4gMikgVGhlIGxvdyBsZXZlbCBoZWxwZXIgd2hpY2gganVzdCByZWFkcyBhIGdpdmVuIGZp
ZWxkIElELg0KPiANCkNvdWxkIDIgYmUgYSBzdGF0aWMgaW5saW5lIGluIGEgaGVscGVyLCBhbmQg
dGhlbiBvbmx5IGhhdmUgb25lIGV4cG9ydD8NCg==

