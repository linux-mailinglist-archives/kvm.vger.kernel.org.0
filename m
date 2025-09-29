Return-Path: <kvm+bounces-59020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 729B7BAA239
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 19:20:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10D753AFD42
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 17:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F12330DD38;
	Mon, 29 Sep 2025 17:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VtsrOxsi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93CF72D3A9E;
	Mon, 29 Sep 2025 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759166411; cv=fail; b=rQdUN4VDuXOaBUebUp58D7nbFbVQhPG38/1ycWjYFKVC/NuClruCcGzGcDUzNdyStW1RfZbX6YBFuAX/Nqtxg77JbQYXxsRel+mSnwPg4rQm/69n+UfKmpK41TXOa788GUpZLXK56FP9KrVhShhwegtpv26E8MzWa+qI7bFHFlg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759166411; c=relaxed/simple;
	bh=UcnP/32s6ua6ECHvCeAbWj70Ri1LqkuAFBjHrOHzkwE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DJJZYFdrI56Wr+bs/upBBluy1tJENI1TT2A9gR5AO0229RSf5ez5WSDSiAnOkNtqsfR1FxvwVTKnJwtvxxPCwGdpCajNQfN7GFp/vTyXa2+oL/EyjVlve2gxckMiYvmSmSQLm4gcc4DL9wBKVQ47cSYVwnzSdEj+JHf8qRdzMp8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VtsrOxsi; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759166410; x=1790702410;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UcnP/32s6ua6ECHvCeAbWj70Ri1LqkuAFBjHrOHzkwE=;
  b=VtsrOxsiZ0uHXr0BjCgHkQhOjUoHvJwSg3+bFOoTB34zHNHt2aLyUJtE
   mwIqQhXsj9dNf6e2gCn2TnM4lQjBDh+M6Gxu1izN4FlQ5FVflHmpi7b4t
   3yMFRzUFMis1SpCM7O+xJ5GKYuLl8lVdDO7HuvhVeNGTzEco6+GEu5PJB
   XOBSM+zJMddLdcrm4je0ZY3A7kRhrVRUzn6JFBbS+Brsp/JzIjnyQKSA1
   6oGCWpOzGBmesloxfhnDymnbP74ovzxWh3WoTNv0BXrylYIkfpg4fz8C7
   kF1EBtyUQtDdoTOF0wMyS/U53pN1Q1P4y2l9+KoTNPUU7v+ryaGhF7rTd
   Q==;
X-CSE-ConnectionGUID: 9kXZMw2ZRu646YcQD/hI+w==
X-CSE-MsgGUID: NydPN2RoQS6VzcsDJrc6cw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61369619"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61369619"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 10:20:01 -0700
X-CSE-ConnectionGUID: Mq6ANno7Q1+TGrJkA/NurQ==
X-CSE-MsgGUID: JauYlY4vRTOO4PiSDOVMpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,302,1751266800"; 
   d="scan'208";a="183545671"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 10:19:59 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 10:19:59 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 10:19:59 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.3) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 10:19:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M56olaYmlwCyLFAhXn+WuilLXqzsdi+Vl3rBOVE0HoYtjY3M+jdgFpiNPq7nqh9ittZX10uNGVvrGcje87se2FRFfvBsIg0UBDYdJfgq7MjDSnSjRHXiA9fpi3+2m70h01vKrbzYRW1cvlN0uJRTgVDnTqMs0XMibtoMn/ux3h7jISyUiUfkxXKQfNh9aKaJn95nwrBlGmFo58paXV+crd36+WxA+rY05LSrTQ9oQ6IcYLGm/yAPN7i4cZl7xQII0SWNen9HbkqGWie+lVJ2xGtZGOncEF07nbKUg0zVHUF4AD+US2VZaMjI+34fIhX/lV9mG/iUTm1ArTIyCWTwMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UcnP/32s6ua6ECHvCeAbWj70Ri1LqkuAFBjHrOHzkwE=;
 b=IzN/BJgQ8p2YW40AqJ+t18YQXhh645iTQKX4uFM7fb5Q9ru68/VWjngs4Y1i8YLAf7oe3MqvURLw8BY5vY5xYoWZkV3zLWMn12JQlUgTnKv6Eo98sdryM0V5W/lNGZS4kWg56uI7zkjZYoPFvYv1bRl2Ll7WA/WfrWVtjF7gSlWjJ/MLzpZ7tydTKjq9+7RCjK2zQRB2ot5aWELMYP4/089knWqJ8Yo0u8Jej2znl8vEQsn/+HgrM0i9Q3GfaVoBPxc5d4DE13PvaNz8Ut3jA4RdgNlqiDKCNIsOr/kMMnHS18hZiA0kZ231AhN4Gdl0fqLmdvs1l4hY7hHCkpYbhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4699.namprd11.prod.outlook.com (2603:10b6:303:54::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Mon, 29 Sep
 2025 17:19:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9160.015; Mon, 29 Sep 2025
 17:19:55 +0000
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
Subject: Re: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v3 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcKPM1NzNrnMrGfkmDv8ppN4f8QLSp20IAgACdYgA=
Date: Mon, 29 Sep 2025 17:19:55 +0000
Message-ID: <71b5325b7aa320e9271871b9cfe68981347391b1.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-8-rick.p.edgecombe@intel.com>
	 <aNo7tGlyGhVdGze9@yzhao56-desk.sh.intel.com>
In-Reply-To: <aNo7tGlyGhVdGze9@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4699:EE_
x-ms-office365-filtering-correlation-id: 02fd9281-27d6-4c9f-e2d4-08ddff7c68e3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?aEVuZG1kNC9aTk5JY2NxL2JkdEtrc2dYQ29MK01iZGhVYlltUFlaNTdmRk4y?=
 =?utf-8?B?TWt2bndSRE5kY3BTTUJyTmEyMkJzdHVMeFBzaGZNVkU5NkdreUw0YWg4TndM?=
 =?utf-8?B?dG5FakVqb1hPNE41WEFPWHJCMEwvT0FWY0FubkwwTlMxRHc2UmIvcDNVN3Mx?=
 =?utf-8?B?L0oxbWp3dXIzVUNWSUNYQ3hjN21tQnpnbXpSRy9SZFd6YlBJMmNWRi8rS2py?=
 =?utf-8?B?WEpQRDZnUWJVY1cydndmc3BUS040dUlmQytjR1N1bXVWUkxZMldhRE52cTB0?=
 =?utf-8?B?RE9GNlVGUkJxenFQS1l4Y1NweWlSQnRLMHVNMTZyTjEwdUV2dnl3aG55a2ZG?=
 =?utf-8?B?bWx2VVhNdUtrWEl4YUFzU1VUZ0wrWXRUUVFCV3hXRDlDMFRGSWxDdnJvdnpO?=
 =?utf-8?B?MnM1YjIyOURzK2puZXFWaUtwL2I3R25GRGt3azZLL2M3UHVFMldacDc5T3dD?=
 =?utf-8?B?RXdXeWJINnFqREdPR29wYk0wR0tuOVJCa2o2YmZCOE82eThOUVRNRDJzSnhu?=
 =?utf-8?B?SkNUK0hUWlFEdXlaOTVSanBUWnZZQzZtWEhtWFMzZ2o4S2RBc3hCMlpaMHA2?=
 =?utf-8?B?NndVNVJGT2pJc0FyUUNibTl4cXFnNGFmbXJLcmhPNXoxTklFWjdmdjU2SkJi?=
 =?utf-8?B?T3J5TmRNV2s0eEkyMzY4OWVqU0JOajM5bWMvNTgwWlNJZ2ZpdXZONFg3Y1or?=
 =?utf-8?B?N2E4UGdEOHlYTjYvMysyakgxQnNMN3NDSzlKaS8ydGk3c1hKZFhiZ215UGI3?=
 =?utf-8?B?Qk92aXBVYWdWdlVMNW9CYWduNmZvLzRrUTJuMFlaeThWSGJLZzhIVDEyVGEx?=
 =?utf-8?B?SjZPLzRxQ2NodHA5Z09GM3M0bndJV1d1Vlh5M1JhTlprai9vOEFJc3J1WUJh?=
 =?utf-8?B?VjlMZGRzNjM0WUxockQyV0F5M2wvakRHTnpvbENkTDdkOUY4a3NtOGlaRlZw?=
 =?utf-8?B?aVk2ektIdXlXOGVxVldPa0RXMlVGU2FOWnlFVVFFUmYzZW5KS2diWjlyWkUv?=
 =?utf-8?B?QnMyUzZRc1RIbVV4L0c0TWZGc1R0VWgxQzFaTUpncVhjTWtnbUxrblo4K28w?=
 =?utf-8?B?RVVRLzloZzQ0OXdzUktML0tGQm1WUTBBQUQrTTh2RUMzVytseTVueXQ3Vmtl?=
 =?utf-8?B?M0lxVzFEeXUxMW5MTUdVZzhOZGRsOWY3a3I0VXJDNmpVRStjelhIUzJYZExM?=
 =?utf-8?B?dU9XUU5EUklSNGtmK1J1ZVFZWUpGbFdiTzZobmxwTTlEL1BhQlcrNUEvWWpw?=
 =?utf-8?B?Sy93QlhpMzFrRkJKN1NZVXFxTldUOXZMZFluV0xJbk1pRVpPOWF0OTRzcmoz?=
 =?utf-8?B?VEdMaks4WEN4NlhvSlZlK1FBUTYvOHNHNXpUZ3VacXFKeU5MdUxVMjhaTXc4?=
 =?utf-8?B?cGZtaG1wVklPaUxUdHJqUUFtaDFlRVVrUUFsZWpQMWkvZExzL2VFc3REOHps?=
 =?utf-8?B?bGdzOTFCNVFiaWxpVWV3VW85Zjl2NDQyQ3RkU0x1QkhqNFcxbjNlVzkwMEdz?=
 =?utf-8?B?ZVNoWFpKb1RIZU5DQ0NjbzVFdlI0VWNmU2dqOEVKRFIvNlFqWTlaSktwVEts?=
 =?utf-8?B?WGRXOUxHTmgxOW83VDYyZzkyZEJndEwxcUNGRmwrTm9adHBZemhaUGVFN0I0?=
 =?utf-8?B?VHJLZHlGRzRtZFJURFlubm9JYk1RdHI3eUlSSDl5SVJQa3BrTDZpKzdQbTBk?=
 =?utf-8?B?SFlwT1I2blN4Ni9KWnZRNXdnenAwazlPbFA3amZ1a1QwdTRLWEI5N29ORGdh?=
 =?utf-8?B?WXJLV2tUK0ZCYVYvR3Y4bkJQMjZnTlUyME9iL2dIY0svL1RwQWFGbFZERmdG?=
 =?utf-8?B?cGRGTzBkU25qSy9SNHV4WkhrSy9DeE1saXZ1MmRycEN5SWtsUXF2cXhiQUU4?=
 =?utf-8?B?OHVLYWRtOCtvWVAwRFFlWm5qTmgxN0J2Zk01eDJwQW4xbkt5WHYybnN2bUs0?=
 =?utf-8?B?TGNkMVpwcHRTVE84cEIzQUlPNW1wa3pVZnduSWtlbStTZUFwUUFsWlpyZDFH?=
 =?utf-8?B?UGZrQW9jdVFWeTNXV0hEWTI2b09ZVTJtTkdFclptTmpxaS9PNjlpcXlPUTFq?=
 =?utf-8?Q?wpkT8m?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?blUxYmJSaTlIQ2M1Q2trSElsbzBKTnl3WSt3SW0reFBPcWg0Zjk5b0krTjYw?=
 =?utf-8?B?eGNlb1Iza0wxVnNZT3ZhZWVVL3VtMHpDMTEyODM4ZGlYSG1sMVJGSHBpQjBv?=
 =?utf-8?B?anB1WHdBNkxHcDVtbmVRQ0lzaDVWb2FvUkVrMEFnK2pFRGJNNUloYnUycjQz?=
 =?utf-8?B?VDZ2T0xhVlVlRzUyTXhremR3VDB3NjVMTjF2eVpuTzJ4T2U4cU94K3N0V1lQ?=
 =?utf-8?B?RXYreStNWXlYaTIrbEJ4Y1E5RkRTMng3Y3ZHMXowYTdQS3d4T2R1MWFEUmhO?=
 =?utf-8?B?RUNLdjVkcUJOelVYbjNUTGRsZEJmTEIvSm1GOU5NTUp0bkdiSXd5WU9uNzZN?=
 =?utf-8?B?YUlOWFE4d3Z2TGI3YXhtK295aUY1MUZtdWNGdjY2dG5CYndDSEJVem5kNHdi?=
 =?utf-8?B?NkN1ek90VSthUVJTMzNyN252cnBxT2JVY1RGUFdJRElLV0oxT2doY1VlV0xM?=
 =?utf-8?B?aXpoSjB5aFhKTjgzcVVkVTN4S0Rrc0o3N0tLdkdSRzFPeEE3YzkzOUtKTURQ?=
 =?utf-8?B?SWo5Nk84L1hVckpvcVpTcW9Cem56dzJEdklnNXhUckxjL1RMYVJKb1d4VTdS?=
 =?utf-8?B?amR3OGJVZ2FtZWhLUW9BWlYwWHkyOXU2T1VpTW54ZlRMWEkvcitsck85NU9J?=
 =?utf-8?B?NDBWdWZBOTdWZC9XK1FQSnVMWlVGaWxOYVFKQ0lOMDREUG51Nk1SYjFkTTJk?=
 =?utf-8?B?cnFwcGcwSmRkN05HVm1mWTBZWlkwemt3eExQUmVMUm80WnEvS2hXQ1dieDNa?=
 =?utf-8?B?NFNsRnBLamdxeGhXME92Y1NNWE03K1o3Tjh0OFNVS0I3RXRldHZCUFdyUVl3?=
 =?utf-8?B?MnhjUHljUzA1K1RxK0l1Z3BweXZ6V2ZQSC81ZFVnMUF3SHhKREJxREgyc1p3?=
 =?utf-8?B?b2JRZnV5d3VIV3F4enA2TjZoaDNUZkpDeHVjcXhIdXNiTWw0MGIwbFVUQWJj?=
 =?utf-8?B?ZWJjNnJFUzZCRSt3TUd3cEZTeGJCSUFxc3I2Zkh4bExIcTNlUGRMbFBsMmRM?=
 =?utf-8?B?UGRBSlhlU1ZGYkRQOTJmbHY4ZlNMUGEyMlVEWTk1aFcxeVpCSXp4MU5XOHR4?=
 =?utf-8?B?SGVqOE5iQlorUG5odjlheEVIYjg1YlZLVlZReUVGb25MMmhpVlRvTCtrRVcw?=
 =?utf-8?B?L3MyRWNSU0krU29RTlZ6VHcwVnNPTnkvSmpRSXoyYitFeTl3YXJCTCs4T0tB?=
 =?utf-8?B?VWxkNUJscUM3bnZMeVRNTHhod1NjWHYyczlTNFdZLzNvWjQ2UCs4WG1DMEph?=
 =?utf-8?B?R0FLYy92UmFEek9XbTVNZTQrSmlCQWdXMXFwcHBkUlFHdXJzMFRxTDNQWlRP?=
 =?utf-8?B?eDI5MXlzRnQ3VXZCU1ZEZG1iWUZPNk44WCs3MU0rVG1GTVJmRUwybG9nbFVN?=
 =?utf-8?B?VzNMMVkvUnpKVTFSbTdwdmwwQ2F0MVZMRENFZFpiRFJZSVlnSjFFc2hoRkZu?=
 =?utf-8?B?T0NoUzdMUWlqUER2YlQ2c0JrTGhmenZ2WE1sd2I1NDFua3RpeWhlQW85V0tU?=
 =?utf-8?B?azgrdERkUlhTa2psODJFLzF4TnFuZzYrZ095Z0UxZmFldmFuSlgvRm9DTTNv?=
 =?utf-8?B?NlloaG85V1dzTnQ4alM2QWNFMDhtaEs2VDcvUHRJaThTNldkTFdKSlAwTkRu?=
 =?utf-8?B?MDVTL2V1NnZkL1orczRmZzNyQTdoVys5bm1ub0FZbDF1UGt3Q0libW1HOTBR?=
 =?utf-8?B?RjJIb1dpNUQvZDVHc2JlRk45OGNoaG9HaHU3M3haOE5VTFczN2dnK2RkVXpY?=
 =?utf-8?B?UFduOVF2QkRlR0JoTXNocGlYeVRrZWtJQ1kvNWEyY3JZMHcrTThuTWNXNFln?=
 =?utf-8?B?eHFXRTQ0TmNreXdleGppZmlGMG1BL0F0NnJzQnV4WWRCOHJaY3I2ZmpRajlw?=
 =?utf-8?B?bzlOT2dMZzJPV3hlVlRJRk1oL05Qd0JPYjJNMjQ2a01QU3FIWGRzd25YaE9O?=
 =?utf-8?B?L3h1Q2g1aDl6cDRlckpsajJhU1dxeTFGV1BZODhaOUJUTnRsNzRkVDdmOTJv?=
 =?utf-8?B?WjR5R2ZVOVE1V3NaTWlhZ1VMRHA4M2Y4bXZwdkFIejd6Mzh4Wlgwcm9XR1k0?=
 =?utf-8?B?M2xnWFZWQ1B0TnYwbTZxOGkwVm8zMC9yWFZiZzBjRmQ0Z2xIZ29rbFA4ZTY5?=
 =?utf-8?B?c3p2c1ZaRm9xbE56NnpxdTF6MXgrQUxDSGtEYUJBT3RiZFAzTjdEZlZWV0FR?=
 =?utf-8?B?bHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E19ECDF82E20E141AA7FA657C17FC761@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02fd9281-27d6-4c9f-e2d4-08ddff7c68e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2025 17:19:55.7020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Eb8jyanU6Jrf4ahFuQXOHshHrluBL3/p9My0EPM3ovCSzJIjWXiLaewfpKjQ2myhNpRbGWZFmMTI+Xh0zPaZpRTiGCn6khMwuri2zAo9mQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4699
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA5LTI5IGF0IDE1OjU2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiAr
LyoNCj4gPiArICogVGhlIFREWCBzcGVjIHRyZWF0cyB0aGUgcmVnaXN0ZXJzIGxpa2UgYW4gYXJy
YXksIGFzIHRoZXkgYXJlIG9yZGVyZWQNCj4gPiArICogaW4gdGhlIHN0cnVjdC4gVGhlIGFycmF5
IHNpemUgaXMgbGltaXRlZCBieSB0aGUgbnVtYmVyIG9yIHJlZ2lzdGVycywNCj4gPiArICogc28g
ZGVmaW5lIHRoZSBtYXggc2l6ZSBpdCBjb3VsZCBiZSBmb3Igd29yc3QgY2FzZSBhbGxvY2F0aW9u
cyBhbmQgc2FuaXR5DQo+ID4gKyAqIGNoZWNraW5nLg0KPiA+ICsgKi8NCj4gPiArI2RlZmluZSBN
QVhfRFBBTVRfQVJHX1NJWkUgKHNpemVvZihzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzKSAtIFwNCj4g
PiArCQkJICAgIG9mZnNldG9mKHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MsIHJkeCkpDQo+IFRoZSBy
ZHggZG9lc24ndCB3b3JrIGZvciB0ZGhfbWVtX3BhZ2VfZGVtb3RlKCksIHdoaWNoIGNvcGllcyB0
aGUgcGFtdCBwYWdlcw0KPiBhcnJheSBzdGFydGluZyBmcm9tIHIxMi4NCj4gDQo+IElzIHRoZXJl
IGEgd2F5IHRvIG1ha2UgdGhpcyBtb3JlIGdlbmVyaWM/DQoNClN1cmUgd2UgY291bGQganVzdCBw
YXNzIHJkeC9yMTIgYXMgYW4gYXJnLiBCdXQgSSdkIHRoaW5rIHRvIGxlYXZlIGl0IHRvIHRoZQ0K
aHVhZ2UgcGFnZXMgcGF0Y2hlcyB0byBhZGQgdGhhdCB0d2Vhay4NCg0KPiANCj4gPiArLyoNCj4g
PiArICogVHJlYXQgc3RydWN0IHRoZSByZWdpc3RlcnMgbGlrZSBhbiBhcnJheSB0aGF0IHN0YXJ0
cyBhdCBSRFgsIHBlcg0KPiA+ICsgKiBURFggc3BlYy4gRG8gc29tZSBzYW5pdHljaGVja3MsIGFu
ZCByZXR1cm4gYW4gaW5kZXhhYmxlIHR5cGUuDQo+ID4gKyAqLw0KPiA+ICtzdGF0aWMgdTY0ICpk
cGFtdF9hcmdzX2FycmF5X3B0cihzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKQ0KPiA+ICt7
DQo+ID4gKwlXQVJOX09OX09OQ0UodGR4X2RwYW10X2VudHJ5X3BhZ2VzKCkgPiBNQVhfRFBBTVRf
QVJHX1NJWkUpOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBGT1JUSUZZX1NPVUNFIGNvdWxk
IGlubGluZSB0aGlzIGFuZCBjb21wbGFpbiB3aGVuIGNhbGxlcnMgY29weQ0KPiA+ICsJICogYWNy
b3NzIGZpZWxkcywgd2hpY2ggaXMgZXhhY3RseSB3aGF0IHRoaXMgaXMgc3VwcG9zZWQgdG8gYmUN
Cj4gPiArCSAqIHVzZWQgZm9yLiBPYmZ1c2NhdGUgaXQuDQo+ID4gKwkgKi8NCj4gPiArCXJldHVy
biAodTY0ICopKCh1OCAqKWFyZ3MgKyBvZmZzZXRvZihzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzLCBy
ZHgpKTsNCj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGludCBhbGxvY19wYW10X2FycmF5KHU2
NCAqcGFfYXJyYXkpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBwYWdlICpwYWdlOw0KPiA+ICsNCj4g
PiArCWZvciAoaW50IGkgPSAwOyBpIDwgdGR4X2RwYW10X2VudHJ5X3BhZ2VzKCk7IGkrKykgew0K
PiA+ICsJCXBhZ2UgPSBhbGxvY19wYWdlKEdGUF9LRVJORUwpOw0KPiA+ICsJCWlmICghcGFnZSkN
Cj4gPiArCQkJcmV0dXJuIC1FTk9NRU07DQo+IFdoZW4gdGhlIDFzdCBhbGxvY19wYWdlKCkgc3Vj
Y2VlZHMgYnV0IHRoZSAybmQgYWxsb2NfcGFnZSgpIGZhaWxzLCB0aGUgMXN0DQo+IHBhZ2UNCj4g
bXVzdCBiZSBmcmVlZCBiZWZvcmUgcmV0dXJuaW5nIGFuIGVycm9yLiANCg0KT29wcywgeWVzLiBJ
dCBuZWVkcyBhIHByb3BlciBmcmVlIHBhdGggaGVyZS4gVGhhbmtzLg0KDQo+IA0KPiA+ICsJCXBh
X2FycmF5W2ldID0gcGFnZV90b19waHlzKHBhZ2UpOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCXJl
dHVybiAwOw0KPiA+ICt9DQo+ID4gKw0KPiANCg0K

