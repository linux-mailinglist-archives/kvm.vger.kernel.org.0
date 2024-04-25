Return-Path: <kvm+bounces-15979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 382378B2CA8
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:07:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E249F283674
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBA4D156871;
	Thu, 25 Apr 2024 21:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GgMm05b0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA9015381B;
	Thu, 25 Apr 2024 21:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714081988; cv=fail; b=g2teUyQf7DF7EcXpA5lfmo/VMvlul2E98+FriP7NteaXgA07CHoe1qbvsar3iyJyA/jzjXNSxFAxPHmMiKpajVEhmgAqCk/M1GVFeo1Uvr6Yoz3PVdc7IgNWzrm2y9LdpNqxI6+FRdbFAjllfu8wl7cynfRr+heSvxzs/m3ZJbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714081988; c=relaxed/simple;
	bh=wEeCdvsf6UsTEqxqmrQPCTBnP49YVq9KA19nagkzvH4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RU1hfGc4ZGg153eJjvU5BcZpSaf/DxeOR+MMvuFmwXtJEhJj3oJbK/kjM/vH9bbBGssjAIGNn/u5/v/6Hd2kg2XXI1UfSHiZBVy3KbESlvOED3nopfiGxY3IEmFkJ6vHdQiNZ7RyBx9nm86pxRXvXfROWh3PZNBnhBmpKwx+7cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GgMm05b0; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714081987; x=1745617987;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wEeCdvsf6UsTEqxqmrQPCTBnP49YVq9KA19nagkzvH4=;
  b=GgMm05b0O+VfFbvOPBQfEWDut04Ut9H3wZS1MVIEVpR6rOsXDxXwrpaq
   rITgsuw5tO1PfGO9ePt6ysMN7DAbgQFOJXsJYZjiWRrtKcFV2HNnxvmqv
   bLAJxdgQHCbYLvnkSyAE3CYhJOCj5i5s9UvujF0syEOtRqDBkH5i1GHbQ
   s4Sgf6xZVdzq5SB3RhP1pC3hu1hxVj4vkE06bv28mFxX5lEniIYyOvxo4
   pVN+LPSWiHkhSZxxRaFo/xSABeTgaRGTetvt9Z81vi+4qfIYev+HqMi1g
   WTw1ndcxLYdL+Rw9Y2PR+Zw1NQ9eeqXo+16qHqjBk39IqjUNb31lbZRe0
   w==;
X-CSE-ConnectionGUID: bpUW3SEEQxGiC7slJ5AIJw==
X-CSE-MsgGUID: hDIxWPJwS6mhtuqba+GkNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9962587"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="9962587"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 14:53:06 -0700
X-CSE-ConnectionGUID: aatk0WrORKCFE7kVVY4/SA==
X-CSE-MsgGUID: Ee+zRVYPS+mRfDvkfLPCgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="62692749"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 14:53:05 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 14:53:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 14:53:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 14:53:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 14:53:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W0caYwS9BlaEfaguLgSGr79c8vRIoXRLeOceU60oY9CYAdxPPxrY5BQ1q2bu02/3y6CwFg+/ZkDWY+OgxHqrRp/+e1A2YTSfR2FJed5wyna5oF46O974rUYXsBKBF7LyQILmh3NiU8WL6FvAxlJ6A4M3PCeZqPBHVRjOqY1BE7yahdVgn8k23CkTuAXtreKwjyPiAq9vVjnVxtnhgl5g42fWaxboko5a7CkUvgqlZ2xSBpS54VtJaeNWT4ehb45fFmLsR2C7SlFN3FrdWPSp99+znnDThZ08J1kjpAxUKLHNdwP1Oto4jj0u0gV0g21P39PhHJ/RzkZp1hlsOcEgvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wEeCdvsf6UsTEqxqmrQPCTBnP49YVq9KA19nagkzvH4=;
 b=TqU9nFKKwDhRISj6gCfwWo3qR2F2BeSJz4mf9/NQB/wX+fZOleZmr987rdaazyYIh1RNZWyDw6dcc7HYhYQ8roSbBHDlKRyrBF+0Ak0OmI4a6NLowf+JKfNQZ9HSoh+aJPI19vyzisdtrgu4QyHuVhRDO00q046SBxK1z8GYXTsanxeeb1n1TZEUikWpjfMYxqBubAA/RD8a7FFdGIw8yyM7xTzuUK5HWlnD3FYUIWVmMWOSvR+eEHF6bcr+mhvnbtuPRax5Z7+UdSytyL1qRKunly/GIdzUEvxm9GJjcHIlwgeKU/KMd4Huj8vR5hhMqkxoPsWfTcFswCYCgD72+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 21:53:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7519.021; Thu, 25 Apr 2024
 21:53:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Topic: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Thread-Index: AQHaaI2222Sa8TxUXk24fGddYGoigLFCUFIAgAIc5oCAHVMCAIAAJnsAgACCNICAAPghAIAAlYYAgAe6DYCAARI+AIAAFk4AgACOYoCAAAdQgIAAE+EAgADmKACAAJDvAIABMcMAgARpbwCAAEVEAIAAYpQAgAAWqwCAABgFAIAAAz+AgADiNACAAIG7gIACuUQAgABYxAA=
Date: Thu, 25 Apr 2024 21:53:01 +0000
Message-ID: <22821630a2616990e5899252da3f29691b9c9ea8.camel@intel.com>
References: <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
	 <ZiKoqMk-wZKdiar9@google.com>
	 <deb9ccacc4da04703086d7412b669806133be047.camel@intel.com>
	 <ZiaWMpNm30DD1A-0@google.com>
	 <3771fee103b2d279c415e950be10757726a7bd3b.camel@intel.com>
	 <Zib76LqLfWg3QkwB@google.com>
	 <6e83e89f145aee496c6421fc5a7248aae2d6f933.camel@intel.com>
	 <d0563f077a7f86f90e72183cf3406337423f41fe.camel@intel.com>
	 <ZifQiCBPVeld-p8Y@google.com>
	 <61ec08765f0cd79f2d5ea1e2acf285ea9470b239.camel@intel.com>
	 <ZiqGRErxDJ1FE8iA@google.com>
In-Reply-To: <ZiqGRErxDJ1FE8iA@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4587:EE_
x-ms-office365-filtering-correlation-id: 15600c0d-e153-4a2a-7f37-08dc657213d5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VTJQSHN6WFl3blVYcXZYazg2Um1Hb1ZaS0R3cEsyc3BHcjB6NDBldHUzR2x3?=
 =?utf-8?B?MjJ4KzhvSm9wTGNFU2k3c1hhaXhmeldCRkZ5NzZwSHF1M0QybGVQcUJ1Z0NM?=
 =?utf-8?B?bFlwMFVwd0Y5N2xoTGFuRTFDbHhTSlE4byttR3JoTXlLbEltcWt0elRKMlNY?=
 =?utf-8?B?eDJrWTd6Qm5DcGxwbXBEVHFjbG4rUmYwalNEREhpSldoTVJUQk1EYmFxSGJ0?=
 =?utf-8?B?a3lzcFE4OVdoKzhqRmJURzNEek9GS0owckRwLzRhaE1tR3N2ajR0a0pqMStS?=
 =?utf-8?B?S0xxZVQxWXJxbjBKS1NIemJXeG9ma00yYWgrTnArdjNablRoN0tTSVlhc2dm?=
 =?utf-8?B?NDYvZzJLT3E1S04zUHhHR3g1enpETW1LbGNvc2JERDhqRUJrZXlIT1p3OXVj?=
 =?utf-8?B?aldoUDhPeUpTYVYrSjV4bmcrck01eEVsUUJJU3EvTmNJM2VLNG5UMGxPSDRn?=
 =?utf-8?B?U0VZSC9YMGRJdXc2bk5Ddy9ydXYzT2NnUzF1YkM1S2thQWtaU1VXVHJOYTRL?=
 =?utf-8?B?RzdjUHVhdFJSY0x5a0FxbHhjY3FpNThOdlRGL0JDODg5eFQ4N0V6VlNCdTBQ?=
 =?utf-8?B?NXU5TUxpKzZBMGRmRnVwUEcxU3J1RHJkckJyT0hXT2g5NjdpRS9mVVJtSWZN?=
 =?utf-8?B?VUYvVHRUUFlOVUpabTQ4cSsvelhTLzJEWERXZEJ4RUcyeDdRbSt4cm9wQ0Zj?=
 =?utf-8?B?aXl3Wnd4aVFiL1cyNTNZYkU3WWRuMU5vcTYxOXFCV1VNYUpPOFE5K01kcVAy?=
 =?utf-8?B?cyt5WFlpeFRoclk2UEh6cVo1Tk1hdXhKT1lNd2lEZnk5OTFjS25YWnBMWTUx?=
 =?utf-8?B?ajF4cWY3V3NIUTArT1lrcS9RanpucWhZQ2VBTitVaWFYWEhadi91VFIyS1ds?=
 =?utf-8?B?MFFySzZKVzZleDVVd3R3TTk3U1lZdDNHcVRqbWhvbHRlakVOMEZZSVlKZG95?=
 =?utf-8?B?dUFqVnR3bC9tWjdmeENHMW9SSWxQNXRyYXUzeTZJSEtWdHVOTHh5bnhZbXRo?=
 =?utf-8?B?TlpVVEZuWFZDQ2xhKzVFNFhxbFJtYUZDRnJmZHBEb08vQ2Z3ampreE9kZVlQ?=
 =?utf-8?B?dVhjOHBHVUx1V3lhd3BVNDBPTUNDbFpvZndnMnlJRjA4b29pcklXUCt0c2dt?=
 =?utf-8?B?YVplK1JkdXM0WmFOMnJON2lTZXJ4OE1SeDRqQWNqV1ZmUXRIQkpYWEhZeVhJ?=
 =?utf-8?B?Uk1pcU8rVCsvOGNKTVZoQWFxb0pSTEhJV2dlblIvSkZYNGdYZzlmL2orb3pV?=
 =?utf-8?B?dXhwZzU5RWtZeU56eDF0Y2U4OVdTTllmd0lidkRvK3BlNUVmd3h2dkFxVGJ6?=
 =?utf-8?B?YUl0TzcxUHJiZ0xwUTh4b2tOQlU2c2RiODd3Q0EvU0NxdjZieDY5ZFVtUUJH?=
 =?utf-8?B?VW02b2NWcFZPdEdibU51bzRIMHJIMTEvM0Z0V2lpOEF1dXl5QmNjci9kS2Jy?=
 =?utf-8?B?WE13UVIyOEVoSFEzeGErK2NsYUNUcXpYS0Z2ZW5ROTZJUEtHcHYvYXg3V3JW?=
 =?utf-8?B?RXJOQ2Vobkd0L2szYU9oOXFISi9kem42cy9SdENSUXZmd3lsWXRjb0JUTzl4?=
 =?utf-8?B?SWp3YTIwOExGTllsVE5LRmIrVXE1Q0lySGRiUUtPUk5wU1U5OEJEejRLd0Na?=
 =?utf-8?B?T21YVHdUemZlVEFsSTR6b2JEZkJYVEJBb1ZobFJPeHNyekk4QmxHRVdic3Q4?=
 =?utf-8?B?RXpPaHVqY1AzNGZrQ25xYnR6Ump6a2ZjZlFiMjc5TjdoSW5xYVRaZG8zWGl4?=
 =?utf-8?B?Ry83aUZCYVFpSjVPQ0R4MnpmMGZhejlnRVJVQ210MUFYaVhGRE9uM1ppK21P?=
 =?utf-8?B?VGJrYkZOcmprU1hqZHNVdz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NE1QUW0wTjQ5MHkvaEd6YVRRMStlcmYxQ09iNnJWSFUyOGpZLzJ3SXZPRXBj?=
 =?utf-8?B?bVArWGEyWXNORXFZdXRENUJPTUJMUmtUZFhYdDVMNUFkSEdJTmZGd0dyZTlk?=
 =?utf-8?B?bEhFai9lOXYvYTVtNWZLczdkcVcxdHQzM0FTMENSUWFJRUxzMkluV2FTQmR0?=
 =?utf-8?B?ZFRCSWxvcEhvRjZIenNpZEdxSlp0TFgwWlVkbHJzakVZay9qVk1zeHVIR2Np?=
 =?utf-8?B?SnJ5VUZKbFJ2TFIyaEFDMTFYU2V4cVRuZ24xS0dPRm1acGFlYWhpYVMwV0p5?=
 =?utf-8?B?NFFzMHR1a0NKRjNJZ0VTV3JRSmd0Y3BFREdHUHhxRVh5TFdtZ2g4NFlWcGZ1?=
 =?utf-8?B?ZEduT2RMMXdQTVp0Zkh3TkkwczVrWjlmQjVtUFYra1J5NUltb1FDek9nMjM1?=
 =?utf-8?B?L0VKVC8xOWNuRHpLVjhOcnhGNzlHd2xlbjlYWGxlNlp0NHp1RVJOQnRuWmto?=
 =?utf-8?B?TXl3bmtZK0g0YW15b3llTVV6RXRNZ3J4QlYzOGoycG5hSUpuYmJkLzZ2MmhQ?=
 =?utf-8?B?RHZQdEY1MTlkTnNYZzVkNzcxRTRveE84M29rTjdTdjdqVExSRFNSMDFmMXBt?=
 =?utf-8?B?bkU4SzE3YlZSOEEwUTRZb2RiN2F2bGpDZHBsbTRvTjgwWmRsdUMrTDY4ZnVq?=
 =?utf-8?B?RXNkNVd3eklMK0VxaXBvMktjZUk1NGdKSnlRS0t1akVyc2g1WXNzWDI3bUF4?=
 =?utf-8?B?YUQzS0g0bVZxcWJWRjVaUlNqSWhmcHFsL2pxVGZoL2RiSUVuYXRTVnR2Ulg5?=
 =?utf-8?B?UEFUTS9iK3ZrZEVsREVMeFROemFkckwzRlhHUGdYaXBOa3dnTGtMK0tXbDI4?=
 =?utf-8?B?cmZvQmZZQStDVHpvbVpvYWxLdU5ZYlllODEwbFdRTzRRUE9TWFFjbGdSVUZh?=
 =?utf-8?B?T1pwdk1wbnNQTmd5dGIxVW1rUFJ6UUlJYTVzWTdPQ2ppQWF2V21nNnNvNVkz?=
 =?utf-8?B?aXloZFZIZUlTSEJ6ZnIyU21WV3ZpVHN5MVZWWlBsd2REQitpKzJJYUpNTUFi?=
 =?utf-8?B?bml3dHVBWENQM2UrMzhySVR6bnhXdmhLQ0t3eHRjaVVablRZb1RWSXNuUVBB?=
 =?utf-8?B?L0dIY0VwTnY3K01XSlIxY0xoN213Mk90U2F1dEpaQjhNKzVUd2lVZ0ZtSURT?=
 =?utf-8?B?RjBSZW1wV3lLYmpSUjlJbUdUOFp2ODBieVlyT2hSV0JPdzZ6MEFIbGREV01D?=
 =?utf-8?B?cUU5cVhHbHVkUndaWUF5L0h1QmNRQ090WC9sRVlTWjlwbDlBRUxhOGVDN2RL?=
 =?utf-8?B?eGJFYzJ0OTdHb2VQSXpqL1ltVHNLbXpjaUtkVXdaVjFhMWFocTNhZnY1ODlM?=
 =?utf-8?B?QVVONXFIRTkzTFFFRCtrM21ad1lqTVJuUVY4MnZLbUp5ZEFxNHNTTFJOUHpt?=
 =?utf-8?B?NCsvTTBMM0JKblNuZVNCazRZUVRRb0lIUkQ1Rlo4N0t1M0hhTXA1ODZ2aUZ1?=
 =?utf-8?B?NnlWQitsQ3l1dlBJdDlYTXBzWGQyTk02a21EelVkQ1pKVG5kc05ldlhYeG5i?=
 =?utf-8?B?OXZ5clNmOHd3RVlzUlNzemNQWmVqTTFzNE96YTRHTkhDRnFDWXhQbWxGMysr?=
 =?utf-8?B?MXdVdFkxb2tvVUg3OGc4UzlhbU5jUEZwUkhCclZwVlZvM1ZMMlNlcDlRRDd4?=
 =?utf-8?B?RklXWVFIUmF5TWpVUzFvOVJEdzRGKzB5NVplWkxtSVEwSkJqTmNrQi9QdmZm?=
 =?utf-8?B?ckZsdE95eFhNaEx2NnBJZWdIVUFlckZaOW02Z1hoU3NnMXZtTjNJcUhMM29j?=
 =?utf-8?B?UFRRNG04ZU1GaDh3ejFsSHZubDg5UGU5R0ZQRU9zb3NoeHBlaHI3S1FuWDdl?=
 =?utf-8?B?NjM1OGdjVDQzWEJwR0ZMZG44dHRUTDRFRUQzZjR6YVhYdVBwL0VESFZQR0RU?=
 =?utf-8?B?SmpNT08rRHR4Z3h3SS8wWWdRUmJ3SFZ3cWcyNnRLelVSYzdxREdtOVM4Z1Vo?=
 =?utf-8?B?dTJaRXhwLzNsdDRUTng4aW50ZzYwREtJejdrNkZtdjVBTFE1QVRObkEwMjEr?=
 =?utf-8?B?VWV3cTJDNkYyWDVKTXNPOGNMam11cHZ6cE16WHVIL21tMTRRQmZBTFVUQ2Z2?=
 =?utf-8?B?N2FFOFQzOTBiTG9wYXZvOTJEZ05LWHo3RGJjOU9vUDJFZXlCeXBQWmc1OE5Q?=
 =?utf-8?B?K2ppVVVRdi9DYnIycC9FOU9ka2J5U1R0aktVSmh0Y1BiUVBNdTA3b29lL0hr?=
 =?utf-8?B?cUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B0563E92F7AC74FB8271C02044732F1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15600c0d-e153-4a2a-7f37-08dc657213d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 21:53:01.2749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nu32IP4yMUqo7CDr6caNCMi3SslqkgCyKvMFWPecvcmuo+d0MWKgefUvduxDso081JPrOmQkyc8WvUYPfJMfRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDA5OjM1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAyMywgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFR1
ZSwgMjAyNC0wNC0yMyBhdCAwODoxNSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IFByZXN1bWFibHkgdGhhdCBhcHByb2FjaCByZWxpZXMgb24gc29tZXRoaW5nIGJsb2Nr
aW5nIG9ubGluaW5nIENQVXMgd2hlbiBURFggaXMNCj4gPiA+IGFjdGl2ZS4gIEFuZCBpZiB0aGF0
J3Mgbm90IHRoZSBjYXNlLCB0aGUgcHJvcG9zZWQgcGF0Y2hlcyBhcmUgYnVnZ3kuDQo+ID4gDQo+
ID4gVGhlIGN1cnJlbnQgcGF0Y2ggKFtQQVRDSCAwMjMvMTMwXSBLVk06IFREWDogSW5pdGlhbGl6
ZSB0aGUgVERYIG1vZHVsZQ0KPiA+IHdoZW4gbG9hZGluZyB0aGUgS1ZNIGludGVsIGtlcm5lbCBt
b2R1bGUpIGluZGVlZCBpcyBidWdneSwgYnV0IEkgZG9uJ3QNCj4gPiBxdWl0ZSBmb2xsb3cgd2h5
IHdlIG5lZWQgdG8gYmxvY2sgb25saW5pbmcgQ1BVICB3aGVuIFREWCBpcyBhY3RpdmU/DQo+IA0K
PiBJIHdhcyBzYXlpbmcgdGhhdCBiYXNlZCBvbiBteSByZWFkaW5nIG9mIHRoZSBjb2RlLCBlaXRo
ZXIgKGEpIHRoZSBjb2RlIGlzIGJ1Z2d5DQo+IG9yIChiKSBzb21ldGhpbmcgYmxvY2tzIG9ubGlu
aW5nIENQVXMgd2hlbiBURFggaXMgYWN0aXZlLiAgU291bmRzIGxpa2UgdGhlIGFuc3dlcg0KPiBp
cyAoYSkuDQoNClllYWggaXQncyBhKS4NCg0KPiANCj4gPiBUaGVyZSdzIG5vIGhhcmQgdGhpbmdz
IHRoYXQgcHJldmVudCB1cyB0byBkbyBzby4gIEtWTSBqdXN0IG5lZWQgdG8gZG8NCj4gPiBWTVhP
TiArIHRkeF9jcHVfZW5hYmxlKCkgaW5zaWRlIGt2bV9vbmxpbmVfY3B1KCkuDQo+ID4gDQo+ID4g
PiANCj4gPiA+ID4gQnR3LCB0aGUgaWRlYWwgKG9yIHByb2JhYmx5IHRoZSBmaW5hbCkgcGxhbiBp
cyB0byBoYW5kbGUgdGR4X2NwdV9lbmFibGUoKQ0KPiA+ID4gPiBpbiBURFgncyBvd24gQ1BVIGhv
dHBsdWcgY2FsbGJhY2sgaW4gdGhlIGNvcmUta2VybmVsIGFuZCBoaWRlIGl0IGZyb20gYWxsDQo+
ID4gPiA+IG90aGVyIGluLWtlcm5lbCBURFggdXNlcnMuIMKgDQo+ID4gPiA+IA0KPiA+ID4gPiBT
cGVjaWZpY2FsbHk6DQo+ID4gPiA+IA0KPiA+ID4gPiAxKSB0aGF0IGNhbGxiYWNrLCBlLmcuLCB0
ZHhfb25saW5lX2NwdSgpIHdpbGwgYmUgcGxhY2VkIF9iZWZvcmVfIGFueSBpbi0NCj4gPiA+ID4g
a2VybmVsIFREWCB1c2VycyBsaWtlIEtWTSdzIGNhbGxiYWNrLg0KPiA+ID4gPiAyKSBJbiB0ZHhf
b25saW5lX2NwdSgpLCB3ZSBkbyBWTVhPTiArIHRkeF9jcHVfZW5hYmxlKCkgKyBWTVhPRkYsIGFu
ZA0KPiA+ID4gPiByZXR1cm4gZXJyb3IgaW4gY2FzZSBvZiBhbnkgZXJyb3IgdG8gcHJldmVudCB0
aGF0IGNwdSBmcm9tIGdvaW5nIG9ubGluZS4NCj4gPiA+ID4gDQo+ID4gPiA+IFRoYXQgbWFrZXMg
c3VyZSB0aGF0LCBpZiBURFggaXMgc3VwcG9ydGVkIGJ5IHRoZSBwbGF0Zm9ybSwgd2UgYmFzaWNh
bGx5DQo+ID4gPiA+IGd1YXJhbnRlZXMgYWxsIG9ubGluZSBDUFVzIGFyZSByZWFkeSB0byBpc3N1
ZSBTRUFNQ0FMTCAob2YgY291cnNlLCB0aGUgaW4tDQo+ID4gPiA+IGtlcm5lbCBURFggdXNlciBz
dGlsbCBuZWVkcyB0byBkbyBWTVhPTiBmb3IgaXQsIGJ1dCB0aGF0J3MgVERYIHVzZXIncw0KPiA+
ID4gPiByZXNwb25zaWJpbGl0eSkuDQo+ID4gPiA+IA0KPiA+ID4gPiBCdXQgdGhhdCBvYnZpb3Vz
bHkgbmVlZHMgdG8gbW92ZSBWTVhPTiB0byB0aGUgY29yZS1rZXJuZWwuDQo+ID4gPiANCj4gPiA+
IEl0IGRvZXNuJ3Qgc3RyaWN0bHkgaGF2ZSB0byBiZSBjb3JlIGtlcm5lbCBwZXIgc2UsIGp1c3Qg
aW4gY29kZSB0aGF0IHNpdHMgYmVsb3cNCj4gPiA+IEtWTSwgZS5nLiBpbiBhIHNlcGVyYXRlIG1v
ZHVsZSBjYWxsZWQgVkFDWypdIDstKQ0KPiA+ID4gDQo+ID4gPiBbKl0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvYWxsL1pXNkZSQm5Pd1lWLVVDa1lAZ29vZ2xlLmNvbQ0KPiA+IA0KPiA+IENvdWxk
IHlvdSBlbGFib3JhdGUgd2h5IHZhYy5rbyBpcyBuZWNlc3Nhcnk/DQo+ID4gDQo+ID4gQmVpbmcg
YSBtb2R1bGUgbmF0dWFsbHkgd2Ugd2lsbCBuZWVkIHRvIGhhbmRsZSBtb2R1bGUgaW5pdCBhbmQg
ZXhpdC4gIEJ1dA0KPiA+IFREWCBjYW5ub3QgYmUgZGlzYWJsZWQgYW5kIHJlLWVuYWJsZWQgYWZ0
ZXIgaW5pdGlhbGl6YXRpb24sIHNvIGluIGdlbmVyYWwNCj4gPiB0aGUgdmFjLmtvIGRvZXNuJ3Qg
cXVpdGUgZml0IGZvciBURFguDQo+ID4gDQo+ID4gQW5kIEkgYW0gbm90IHN1cmUgd2hhdCdzIHRo
ZSBmdW5kYW1lbnRhbCBkaWZmZXJlbmNlIGJldHdlZW4gbWFuYWdpbmcgVERYDQo+ID4gbW9kdWxl
IGluIGEgbW9kdWxlIHZzIGluIHRoZSBjb3JlLWtlcm5lbCBmcm9tIEtWTSdzIHBlcnNwZWN0aXZl
Lg0KPiANCj4gVkFDIGlzbid0IHN0cmljdGx5IG5lY2Vzc2FyeS4gIFdoYXQgSSB3YXMgc2F5aW5n
IGlzIHRoYXQgaXQncyBub3Qgc3RyaWN0bHkNCj4gbmVjZXNzYXJ5IGZvciB0aGUgY29yZSBrZXJu
ZWwgdG8gaGFuZGxlIFZNWE9OIGVpdGhlci4gIEkuZS4gaXQgY291bGQgYmUgZG9uZSBpbg0KPiBz
b21ldGhpbmcgbGlrZSBWQUMsIG9yIGl0IGNvdWxkIGJlIGRvbmUgaW4gdGhlIGNvcmUga2VybmVs
Lg0KDQpSaWdodCwgYnV0IHNvIGZhciBJIGNhbm5vdCBzZWUgYW55IGFkdmFudGFnZSBvZiB1c2lu
ZyBhIFZBQyBtb2R1bGUsDQpwZXJoYXBzIEkgYW0gbWlzc2luZyBzb21ldGhpbmcgYWx0aG91Z2gu
DQoNCj4gDQo+IFRoZSBpbXBvcnRhbnQgdGhpbmcgaXMgdGhhdCB0aGV5J3JlIGhhbmRsZWQgYnkg
X29uZV8gZW50aXR5LiAgV2hhdCB3ZSBoYXZlIHRvZGF5DQo+IGlzIHByb2JhYmx5IHRoZSB3b3Jz
dCBzZXR1cDsgVk1YT04gaXMgaGFuZGxlZCBieSBLVk0sIGJ1dCBURFguU1lTLkxQLklOSVQgaXMN
Cj4gaGFuZGxlZCBieSBjb3JlIGtlcm5lbCAoc29ydCBvZikuDQoNCkkgY2Fubm90IGFyZ3VlIGFn
YWluc3QgdGhpcyA6LSkNCg0KQnV0IGZyb20gdGhpcyBwb2ludCBvZiB2aWV3LCBJIGNhbm5vdCBz
ZWUgZGlmZmVyZW5jZSBiZXR3ZWVuIHRkeF9lbmFibGUoKQ0KYW5kIHRkeF9jcHVfZW5hYmxlKCks
IGJlY2F1c2UgdGhleSBib3RoIGluIGNvcmUta2VybmVsIHdoaWxlIGRlcGVuZCBvbiBLVk0NCnRv
IGhhbmRsZSBWTVhPTi4NCg0KT3IsIGRvIHlvdSBwcmVmZXIgdG8gd2UgbW92ZSBWTVhPTiB0byB0
aGUgY29yZS1rZXJuZWwgYXQgdGhpcyBzdGFnZSwgaS5lLiwNCmFzIGEgcHJlcGFyZSB3b3JrIGZv
ciBLVk0gVERYPyANCg0KDQoNCg==

