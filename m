Return-Path: <kvm+bounces-47287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80CFFABF9FB
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 17:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5780B504228
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 15:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E461A221732;
	Wed, 21 May 2025 15:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FENLdT8w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5047E2D600;
	Wed, 21 May 2025 15:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747842022; cv=fail; b=ICpdjYfMDzknnIq2OCPAhVuLzilfSptn1XDonDyd/2N/R4MDWv6hM8JRyJlLmxWAIEzWlHr+RfZ1dyC68mPegTVVmKX0EOsGi6zhjlxQpxwHIt4fViX9nngkUtN4J0wbqw4nALuCGljKVeiHs5w9wyByRlcSO1gVH3t93o/YpE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747842022; c=relaxed/simple;
	bh=13EjpY0kHp4hSxWAf67OhUdXykllsk4AnLSQJMKdMfc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sbsIynsTsdIbbJ74DsebHfPa4AF9rauZNwD2AZdzfeab5x+ZED8s31i1b3gQ+wNLkclxfZFOQSfVXJ0iVSGE4I/iK/2yY6x1OWZc+u5siWQqPhq9mKhhHIoTejupKhm7JGMdzpYaRb/5VEv8tvKMa0hPC9lgo7+vsHMsNAVW2HA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FENLdT8w; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747842021; x=1779378021;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=13EjpY0kHp4hSxWAf67OhUdXykllsk4AnLSQJMKdMfc=;
  b=FENLdT8w5JgpgGHdSI8HHEePC4ZXhwts/su0rzJs5StZjMmx/em9jy0S
   suD7rPpAF25fh5fzW9YfUZNtHWJyerFu5nnICvOI7edAfwqk/UvikSOT9
   TwGmPTHFpIJJ7LhvV4w/Hu7+ifxY5nEzRUhg/dh+u3dFQl1p9PEXKAv+x
   7ZUwg7D8SdbVqOto8XGn0Pil98qiP20+hxQuzfNHcQ7/8OfGUAPamv6/+
   FZLkYVlw4Dl6/yGsIfwSHmoLefSGu8ddTzzUMkSjEQtGIhKsYF99xapbR
   deEL0f/35/bIsDGmi3sCKNdszsgWk9XB4rFlhSg2NTSvQbIveyHQhRHla
   A==;
X-CSE-ConnectionGUID: riXxBbjDRpqoAmALnKLrMA==
X-CSE-MsgGUID: oM9O+VIeS4GFD39UHZYdiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="49085683"
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="49085683"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 08:40:19 -0700
X-CSE-ConnectionGUID: KugxmPiiSyuW9hYlbJrTFg==
X-CSE-MsgGUID: 3ysR6+PIQImejDDqYHAWPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,303,1739865600"; 
   d="scan'208";a="139970843"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2025 08:40:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 21 May 2025 08:40:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 21 May 2025 08:40:18 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 21 May 2025 08:40:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x9uJodUozTDMNwF8qV/1VsFfDywlkqVDIQuqM7Xm7DRqu9UukFDzdQD7Hk4Spb/1rwWJK0QG3ApAfWhjmK74G9rf58vBJYGNIUTO/C47K4rSkbByV7QEPiWBtXl/JUtoAU4EYjbCIyOft0lfTuRWDDe3LRFkzPv0GCj1N10uW5IlnPMxi3h8Di4+UN8khW3LJwWh+p5a7c5fhDK8RB5RWb6qnFDDLHnhVtY6B9MQ/HjpF/vg/lVpQgEFrEH3Ze9YTCPrzGhGZK5DZZ7mRp2urLZLw1BwkXchEFCmBnBwfK0D0rHDTkmfJGeKIXqIQomtDKnN9G3AeNl/X73de+b/Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13EjpY0kHp4hSxWAf67OhUdXykllsk4AnLSQJMKdMfc=;
 b=YjT7Qvi3Fw9QKJ3qeO6IuO/10/cDZCCgC0IixPWGQBMeJwGfaC4gdrxFv0PxEJg+NL4BECAaXhBXsBz6xZnODuyTdO4QuW0CwwiUgKCPBzQP3jSW+368fJ+iR1u1ZsH0hn+6jyZlkodxaEo94BAw0AjCzaRyj53PoxMVqwvW54h055Nhjny8ZUQZFYe8tVYA3b8REWA+FUv2UPiby1ITlJDnEKzXbaHTo6rPjGJx8ggkcCS+DtJqgPpxIVD3dtAqhv5zAP4zHqyBWj1vz20iLYBxogROqtxN3PiVE+QYj/gS7DJxvRArsT9hK+skOYVaIRCZ0OmZ71eRAtMC/NsYAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6104.namprd11.prod.outlook.com (2603:10b6:8:9f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8699.21; Wed, 21 May 2025 15:40:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8746.030; Wed, 21 May 2025
 15:40:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgAH4cQA=
Date: Wed, 21 May 2025 15:40:15 +0000
Message-ID: <d922d322901246bd3ee0ba745cdbe765078e92bd.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
	 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
	 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
	 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6104:EE_
x-ms-office365-filtering-correlation-id: ec9f669d-571d-47cb-a31b-08dd987dc84c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bmxnK3RWN29ydnNSeWpYODNQeWRUV25Cdnh1QXM1MFM4alBhNnU3OUJac21j?=
 =?utf-8?B?QUhZb0VReFdNa0RYVTg1UzloMHZJNHJBM3A2T0M5cnNiQ1B6QmNxWDN1Yk9M?=
 =?utf-8?B?bTliaHdXMk0yUWZ3cGVTLzIrY203eFYwMlR3YWxRandJSHF2L1VaQU1BNWhl?=
 =?utf-8?B?VlhtSlFJWEgzc0xNeEs4K2dKdStmUE9uL3FWSG5pOU9ONUFTN3RsdnYvQnFZ?=
 =?utf-8?B?aEhIRnQvczZVZG1lRjhNS1EvSE5iNTlTSXR4d3MyaXJ4NVZNSmg5anhiemp4?=
 =?utf-8?B?N2lpOEJ0em1vRW5rUFd5M2gydlpJZ1EyM0dZVERXalEwdGRCaEhiZENJT1Rr?=
 =?utf-8?B?Ylk0YUw1TWVoM1BrQ2MySGpoSTNFSUt3RzlvWUN2UkVySlZvTkZFWnBGblZx?=
 =?utf-8?B?ZHhsai82WGxlM21XTmduckVxbWI5MktlWEFJeUNrNjg2akkyL1d1V080SGp0?=
 =?utf-8?B?SHp5aGxKamtlbXFjWDFLN1RKUnc5MExrZEhjZ2NNSXVzbHZxQ1luZ1ZlTDlX?=
 =?utf-8?B?NFVUK01uWWNnMkhFYnpmekRaUlZ6cVNhNFEvaitXWmxBUXBDTTFNZVV5cVlZ?=
 =?utf-8?B?ZG9XTE9mRktTdUFLUTBxTFczU21IZDFkYVg5bUVQamo1NWlWZVpLWUNQRkJH?=
 =?utf-8?B?TjA1RzRxdHhYZjcySVFBWnJUSFMvV0YvMk1tUzBHTm0yNG1vVDFaaEl6TEYz?=
 =?utf-8?B?L3A5NkZ5NkFzVzJiTXZTdkRaN04wWmZxY2x5aTFISWM3Um5lSVFyS3NBQ1NI?=
 =?utf-8?B?dEdEbDVQM1l3NnBrbWtCb3F0L1lTMGFKRjJrdDlkenRsam03VXN5ZnNKR3lw?=
 =?utf-8?B?dEVSZEJqY3hqaDdxU0JMUFg0RG5xNXFjYkJSeVpmY01RQXBqZ201dEZORTJr?=
 =?utf-8?B?azJZc1g4N1QrTDc1M0p6L3BQcnpNeHh4SjF5dndXQ0ZLa0lFbmxYOHQvRjR0?=
 =?utf-8?B?TDFZZUZrS2hpNTNRSHRSb0lwUzF3MXkwaWY1cVZHY3VEdHJOZnA2OHJHR2ZF?=
 =?utf-8?B?cFF5aitIWHZZRjJOdUx0YTJGWDhjNTJSYzRjN2tRWTY1VkhwSFcxQnB0Smt4?=
 =?utf-8?B?UEFWT1p2Q0FkaUc2dGJ3Y2JuT0JvNkpSSGc3ZkUzbElUajE1WExOZ0FPOTNz?=
 =?utf-8?B?Wks1U3l2RHRpcFZ0WGhkWXR5UzBPVHVSRUVXMjBZVlpIUkJHaVNPQkRPZnZX?=
 =?utf-8?B?eVJkZk1HTXJlNE9XWG5HcEtFSnpZMkVWMGZraGdMQmVBcmw1ODd0b3hPMmZ0?=
 =?utf-8?B?MXJYM0drNmtUUlpXV0NlWTlOWmxSR1MyNnhDN2FwVUlMb0QzYmlkbXVmQnRs?=
 =?utf-8?B?aXZHck5QaEg3MGg4bXNaaHNQZnFsdHY2TzhlZ0tyYnZTdXpwYWt3bytGWVZW?=
 =?utf-8?B?L3UyVG15QjQ0b3B2WnNzWTJlVnBNRE1EU0o2QWFRd3ZBWXE2WGUvL2ZoM3M1?=
 =?utf-8?B?NnBWMGgzbHp5bm9QWTZaaDNjUGxSZ1FxK3YrM2N5eEZ6UVdwK3JjYWZCbFpE?=
 =?utf-8?B?WG9yVDlza200VWJoQXJ1WmJWcE1mYzJ6aTVJRWc3K1IyT2tMM1JPNyt2Y0dr?=
 =?utf-8?B?cUVmc0hEVTMwL1lBQzZwOUNtUTZvNDZCMFR1ZHNjazZMY0F6QUtqdG1hOVpP?=
 =?utf-8?B?bkNGTm43NitxMUV0bkMxRG9uZ2JjQ2FUV3FsZXB1WkYzWkhDNW5xTFB0R3RT?=
 =?utf-8?B?L3RFKzNUVzlMNHpwOHVvOVV2K1V0ZWk4bU1SWERORW1EakJwOWZCUzJWM0kw?=
 =?utf-8?B?dit5R1ByRlZJRlFyTTdobWhENmltaTJGY1BpdkZvc2lyU2pkcXdob0tpMEpD?=
 =?utf-8?B?L01wa2p0N3hCa0V3eDZPYml0R3F0TzFic3gyWnZsY1d2ZDZPNjNRc25OQmd4?=
 =?utf-8?B?UWVUN1BUT054dE1Hc0lldmZOZm52MDgwQ2NUdkgwRVlXNWk0MUxGVEs1Vk5p?=
 =?utf-8?Q?20I8+0tbLWM3yia8KctLCsuUUHP9FJFM?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2lZdmpHSXpsUnBmQjFXOVFndk5wcUdzeUJ6UTdzQk4vbmI0Q3hEOFhhQ0RY?=
 =?utf-8?B?NE1IZXM1d2NqeTFTZmJ0Q1hoVklxSXBydHJUVW5mL3dwUUFncWp6bWxyVnUv?=
 =?utf-8?B?OHR5TzFqU1FnTzE0VlFDZFVNV2JobXhNRUhhK1MyUmxzMTdMTWVOVjRoL0xu?=
 =?utf-8?B?MGw1S3ZBSlcwVlFDKzZ6NnJPcVY4SFdWczlPWTFORVVKSnhFZzJEbG5WZmtD?=
 =?utf-8?B?a3d1U2tYK2M4T3ZqRmlxSENMM3pkdUhCMTlleXpCUmE2MEhkT2ZVV0lvWms5?=
 =?utf-8?B?NjUwUkd3R1h6L1RrVUdRUUZpLy85enZpMVVoUCtpWnNzRUZBY0poM1FvZVpV?=
 =?utf-8?B?bEovQUdPa29DUWFyWE9IZVBRT0d2RE5VTjA3blIrQzN1Uk1oTjZGTGtnTmgz?=
 =?utf-8?B?eGltcjJ5czl2RUxlMzhIYXVjQm53cGtKUkJxMncrV05XWUc1S2FmbVFtUWZ5?=
 =?utf-8?B?VHdGbHMzUXFlNnRNRm1rK2o2VC92bVpiZW5BbWhOcFNNR2xlaDJtMzNUMTRX?=
 =?utf-8?B?TE03enlBZFZqVGlHUHA4QmRlWVpscXh1Wlp2QitWRnR6VHZSUkhsakwremMv?=
 =?utf-8?B?MHlCd01ENlVoWndlWWdJcEx1aFI0MG1GQlM1RTZPTkVITDZlN2pXSWFNOGNQ?=
 =?utf-8?B?R1ZBanRwVTF2eUdTeUNURFdOV3VBZU50NTNWN3lZSC9rajJvSHlMTkRXb2gx?=
 =?utf-8?B?Sm93SXdQaTgreW1rR0FpT2JoSStZakE2U2VHekdmd00venBJMitkZk5vdG82?=
 =?utf-8?B?dU5vdWxDN3FXRTl4T01TUDRGSDk3c0VyQzkySXpFQW5qNkpQcHpWTStQcnF6?=
 =?utf-8?B?VFdIdzZWcjM1VnV5aXR5c0V3WVpHU3ZFNE45TDZuNnNzSWJqc205bHVta3pz?=
 =?utf-8?B?SnkrdVhhVFFQUndLVktZTmEvOEF4N2RKY2pLTXZHU0Mwdys2TmdZMUdxcGZw?=
 =?utf-8?B?QVNWVkdROVR2NXhoYWsvMllvMlFIdkxYc1ZDcXQ0ZHJQSENIdXl5dDdXUG51?=
 =?utf-8?B?enJGV1VVVUNmNDFyUlpwbDNPZkg3T3hUQ3BhY1NqMk45WW1kbzlYZ0hZdmhh?=
 =?utf-8?B?UmN6MG5Jdk9mWklxdHJsQ1p2VDNKaVo2d0NhckRUb0Q3UmhZWlhJSUg2a3o2?=
 =?utf-8?B?b0xsZ1pXazR0b0Nnb3dBLzVhR3JxRnVlN3pZUzk2SWtLR2toSVM3aVFDRFIr?=
 =?utf-8?B?L05pOTBSMTJHc3YwVzcyMkZBbUlNS3BWRmZqOTJxamt1VlJUT1ZxdUIvSnZ0?=
 =?utf-8?B?OWlUbWcwdXZjZmNBdXV0WTRSZ3pmWVJ4TTY4OHk4MFJOODVBNU9lMVpyUDRQ?=
 =?utf-8?B?MUtNVE5UTUw0SWppYzcwb3dhajBLSEFoU2hLcG5vMU00eTVVcitnZkttdmVV?=
 =?utf-8?B?TmhCWFB0Rk4zZ093WWNnMXNmZG1hZC92R1lUZ2o1L29Fa1RHVXBQdW5kelh6?=
 =?utf-8?B?TEtzZUFnNTdEUkNKdWM3N3VTTkIycFpVU1VQU2JwVnNNdEFmbjZsc2FSRER3?=
 =?utf-8?B?TUxDbExTYU03Y2JxcVZCdUNLQ0Eva2l4dTdocndKRGViaVgyekxRR3k3STYv?=
 =?utf-8?B?STRmRy9PamIwQ1NETVc1SlRtM1VReC80QkFhVnQwRHkyZDMyMjFveGQ2WnFp?=
 =?utf-8?B?WlpsSm90aUU5djdWSElmM0xwM2hETHU2L1R0VktUb0JuU2ZKbEJZNUNLUk04?=
 =?utf-8?B?dkpRdUQ0TG0rcU5DSThuUlRHaUJyVGJiL3FET1YvK2p5Yy9wVSsyd0dURHRT?=
 =?utf-8?B?b2ZidUNNMDF2RVY2cEVuLzZhVmFOUERmdFJtOWRnMk1GMWZQZ3FIeGRLbkZT?=
 =?utf-8?B?UzFaNkdHMGQ2RnFoL3FSVU45TW1ON3N5RzNUZHAyVzJJOWFnYTB4Z3Z5OEFJ?=
 =?utf-8?B?TnRKM3FnaWZOT1NJaitkYUcwRzlMQnFkMGtHSjRsYUNkaTFsWklkTVl2UitW?=
 =?utf-8?B?dUZwSUc2WnJnOHFVcnE0WVFUckIxOHo3NzQ5VHpiWkxDbEYvb0tBbW9uclFD?=
 =?utf-8?B?VmloOTdUc0xxUmo4VGhjbUVsald5aEZucTVWMS80bzIxK25FWE5qL2VUVFRY?=
 =?utf-8?B?OUpjYjJHZitCeHJaei9VYnlsU3h3d3lJSGVoejBuSmhyYVRjTXJGMkhXbGZs?=
 =?utf-8?B?TjAzZWNSeU1maFlhVXVlRkRheEttM3JSbmxyK1JOcUJmOHRDM2E0TzUxd01G?=
 =?utf-8?B?SkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F11FEC0C89DCBC4AB2E87B7B919A42AB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec9f669d-571d-47cb-a31b-08dd987dc84c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 May 2025 15:40:15.5189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WWM3D0sHef34NVLbdo1OxCOj6PD5WeVYyrIaVpbIi1KZ61i73Mn2hFPo0oMsmJeQnCuw28tQyTuo/k1njUNoAsUFm8w7VozJ5wcoO4sDfRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6104
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTIwIGF0IDE3OjM0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gU28s
IHlvdSB3YW50IHRvIGRpc2FsbG93IGh1Z2UgcGFnZXMgZm9yIG5vbi1MaW51eCBURHMsIHRoZW4g
d2UgaGF2ZSBubyBuZWVkDQo+IHRvIHN1cHBvcnQgc3BsaXR0aW5nIGluIHRoZSBmYXVsdCBwYXRo
LCByaWdodD8NCj4gDQo+IEknbSBPSyBpZiB3ZSBkb24ndCBjYXJlIG5vbi1MaW51eCBURHMgZm9y
IG5vdy4NCj4gVGhpcyBjYW4gc2ltcGxpZnkgdGhlIHNwbGl0dGluZyBjb2RlIGFuZCB3ZSBjYW4g
YWRkIHRoZSBzdXBwb3J0IHdoZW4gdGhlcmUncyBhDQo+IG5lZWQuDQoNCldlIGRvIG5lZWQgdG8g
Y2FyZSBhYm91dCBub24tTGludXggVERzIGZ1bmN0aW9uaW5nLCBidXQgd2UgZG9uJ3QgbmVlZCB0
bw0Kb3B0aW1pemUgZm9yIHRoZW0gYXQgdGhpcyBwb2ludC4gV2UgbmVlZCB0byBvcHRpbWl6ZSBm
b3IgdGhpbmdzIHRoYXQgaGFwcGVuDQpvZnRlbi4gUGVuZGluZy0jVkUgdXNpbmcgVERzIGFyZSBy
YXJlLCBhbmQgZG9uJ3QgbmVlZCB0byBoYXZlIGh1Z2UgcGFnZXMgaW4NCm9yZGVyIHRvIHdvcmsu
DQoNClllc3RlcmRheSBLaXJpbGwgYW5kIEkgd2VyZSBjaGF0dGluZyBvZmZsaW5lIGFib3V0IHRo
ZSBuZXdseSBkZWZpbmVkDQpUREcuTUVNLlBBR0UuUkVMRUFTRS4gSXQgaXMga2luZCBvZiBsaWtl
IGFuIHVuYWNjZXB0LCBzbyBhbm90aGVyIHBvc3NpYmlsaXR5IGlzOg0KMS4gR3Vlc3QgYWNjZXB0
cyBhdCAyTUINCjIuIEd1ZXN0IHJlbGVhc2VzIGF0IDJNQiAobm8gbm90aWNlIHRvIFZNTSkNCjMu
IEd1ZXN0IGFjY2VwdHMgYXQgNGssIEVQVCB2aW9sYXRpb24gd2l0aCBleHBlY3RhdGlvbiB0byBk
ZW1vdGUNCg0KSW4gdGhhdCBjYXNlLCBLVk0gd29uJ3Qga25vdyB0byBleHBlY3QgaXQsIGFuZCB0
aGF0IGl0IG5lZWRzIHRvIHByZWVtcHRpdmVseSBtYXANCnRoaW5ncyBhdCA0ay4NCg0KRm9yIGZ1
bGwgY292ZXJhZ2Ugb2YgdGhlIGlzc3VlLCBjYW4gd2UgZGlzY3VzcyBhIGxpdHRsZSBiaXQgYWJv
dXQgd2hhdCBkZW1vdGUgaW4NCnRoZSBmYXVsdCBwYXRoIHdvdWxkIGxvb2sgbGlrZT8gVGhlIGN1
cnJlbnQgemFwcGluZyBvcGVyYXRpb24gdGhhdCBpcyBpbnZvbHZlZA0KZGVwZW5kcyBvbiBtbXUg
d3JpdGUgbG9jay4gQW5kIEkgcmVtZW1iZXIgeW91IGhhZCBhIFBPQyB0aGF0IGFkZGVkIGVzc2Vu
dGlhbGx5IGENCmhpZGRlbiBleGNsdXNpdmUgbG9jayBpbiBURFggY29kZSBhcyBhIHN1YnN0aXR1
dGUuIEJ1dCB1bmxpa2UgdGhlIG90aGVyIGNhbGxlcnMsDQp0aGUgZmF1bHQgcGF0aCBkZW1vdGUg
Y2FzZSBjb3VsZCBhY3R1YWxseSBoYW5kbGUgZmFpbHVyZS4gU28gaWYgd2UganVzdCByZXR1cm5l
ZA0KYnVzeSBhbmQgZGlkbid0IHRyeSB0byBmb3JjZSB0aGUgcmV0cnksIHdlIHdvdWxkIGp1c3Qg
cnVuIHRoZSByaXNrIG9mDQppbnRlcmZlcmluZyB3aXRoIFREWCBtb2R1bGUgc2VwdCBsb2NrPyBJ
cyB0aGF0IHRoZSBvbmx5IGlzc3VlIHdpdGggYSBkZXNpZ24gdGhhdA0Kd291bGQgYWxsb3dzIGZh
aWx1cmUgb2YgZGVtb3RlIGluIHRoZSBmYXVsdCBwYXRoPw0KDQpMZXQncyBrZWVwIGluIG1pbmQg
dGhhdCB3ZSBjb3VsZCBhc2sgZm9yIFREWCBtb2R1bGUgY2hhbmdlcyB0byBlbmFibGUgdGhpcyBw
YXRoLg0KSSB0aGluayB3ZSBjb3VsZCBwcm9iYWJseSBnZXQgYXdheSB3aXRoIGlnbm9yaW5nIFRE
Ry5NRU0uUEFHRS5SRUxFQVNFIGlmIHdlIGhhZA0KYSBwbGFuIHRvIGZpeCBpdCB1cCB3aXRoIFRE
WCBtb2R1bGUgY2hhbmdlcy4gQW5kIGlmIHRoZSB1bHRpbWF0ZSByb290IGNhdXNlIG9mDQp0aGUg
Y29tcGxpY2F0aW9uIGlzIGF2b2lkaW5nIHplcm8tc3RlcCAoc2VwdCBsb2NrKSwgd2Ugc2hvdWxk
IGZpeCB0aGF0IGluc3RlYWQNCm9mIGRlc2lnbiBhcm91bmQgaXQgZnVydGhlci4NCg0KPiANCj4g
PiBJIHRoaW5rIHRoaXMgY29ubmVjdHMgdGhlIHF1ZXN0aW9uIG9mIHdoZXRoZXIgd2UgY2FuIHBh
c3MgdGhlIG5lY2Vzc2FyeSBpbmZvDQo+ID4gaW50byBmYXVsdCB2aWEgc3ludGhldGljIGVycm9y
IGNvZGUuIENvbnNpZGVyIHRoaXMgbmV3IGRlc2lnbjoNCj4gPiANCj4gPiDCoCAtIHRkeF9nbWVt
X3ByaXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwoKSBzaW1wbHkgcmV0dXJucyA0ayBmb3IgcHJlZmV0
Y2ggYW5kIHByZS0NCj4gPiBydW5uYWJsZSwgb3RoZXJ3aXNlIHJldHVybnMgMk1CDQo+IFdoeSBw
cmVmZXRjaCBhbmQgcHJlLXJ1bm5hYmxlIGZhdWx0cyBnbyB0aGUgZmlyc3QgcGF0aCwgd2hpbGUN
Cg0KQmVjYXVzZSB0aGVzZSBhcmUgZWl0aGVyIHBhc3NlZCBpbnRvIHByaXZhdGVfbWF4X21hcHBp
bmdfbGV2ZWwoKSwgb3Igbm90DQphc3NvY2lhdGVkIHdpdGggdGhlIGZhdWx0IChydW5uYWJsZSBz
dGF0ZSkuDQoNCj4gDQo+ID4gwqAgLSBpZiBmYXVsdCBoYXMgYWNjZXB0IGluZm8gMk1CIHNpemUs
IHBhc3MgMk1CIHNpemUgaW50byBmYXVsdC4gT3RoZXJ3aXNlIHBhc3MNCj4gPiA0ayAoaS5lLiBW
TXMgdGhhdCBhcmUgcmVseWluZyBvbiAjVkUgdG8gZG8gdGhlIGFjY2VwdCB3b24ndCBnZXQgaHVn
ZSBwYWdlcw0KPiA+ICp5ZXQqKS4NCj4gb3RoZXIgZmF1bHRzIGdvIHRoZSBzZWNvbmQgcGF0aD8N
Cg0KVGhpcyBpbmZvIGlzIHJlbGF0ZWQgdG8gdGhlIHNwZWNpZmljIGZhdWx0Lg0KDQo+IMKgDQo+
ID4gV2hhdCBnb2VzIHdyb25nPyBTZWVtcyBzaW1wbGVyIGFuZCBubyBtb3JlIHN0dWZmaW5nIGZh
dWx0IGluZm8gb24gdGhlIHZjcHUuDQo+IEkgdHJpZWQgdG8gYXZvaWQgdGhlIGRvdWJsZSBwYXRo
cy4NCj4gSU1ITywgaXQncyBjb25mdXNpbmcgdG8gc3BlY2lmeSBtYXhfbGV2ZWwgZnJvbSB0d28g
cGF0aHMuDQo+IA0KPiBUaGUgZmF1bHQgaW5mbyBpbiB2Y3B1X3RkeCBpc24ndCBhIHJlYWwgcHJv
YmxlbSBhcyBpdCdzIHBlci12Q1BVLg0KPiBBbiBleGlzdGluZyBleGFtcGxlIGluIEtWTSBpcyB2
Y3B1LT5hcmNoLm1taW9fZ2ZuLg0KDQptbWlvX2dmbiBpc24ndCBpbmZvIGFib3V0IHRoZSBmYXVs
dCB0aG91Z2gsIGl0J3MgaW5mbyBhYm91dCB0aGUgZ2ZuIGJlaW5nIG1taW8uDQpTbyBub3QgZmF1
bHQgc2NvcGVkLg0KDQo+IA0KPiBXZSBkb24ndCBuZWVkIHNvbWV0aGluZyBsaWtlIHRoZSB2Y3B1
LT5hcmNoLm1taW9fZ2VuIGJlY2F1c2UNCj4gdGR4LT52aW9sYXRpb25fZ2ZuXyogYW5kIHRkeC0+
dmlvbGF0aW9uX3JlcXVlc3RfbGV2ZWwgYXJlIHJlc2V0IGluIGVhY2gNCj4gdGR4X2hhbmRsZV9l
cHRfdmlvbGF0aW9uKCkuDQo+IA0KPiANCj4gQlRXLCBkdWcgaW50byBzb21lIGhpc3Rvcnk6DQo+
IA0KPiBJbiB2MTggb2YgVERYIGJhc2ljIHNlcmllcywNCj4gZW5mb3JjaW5nIDRLQiBmb3IgcHJl
LXJ1bm5hYmxlIGZhdWx0cyB3ZXJlIGRvbmUgYnkgcGFzc2luZyBQR19MRVZFTF80SyB0bw0KPiBr
dm1fbW11X21hcF90ZHBfcGFnZSgpLg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMWE2
NGY3OThiNTUwZGFkOWUwOTY2MDNlOGRhZTNiNmU4ZmIyZmJkNS4xNzA1OTY1NjM1LmdpdC5pc2Fr
dS55YW1haGF0YUBpbnRlbC5jb20vDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC85N2Ji
MWYyOTk2ZDhhN2I4MjhjZDllMzMwOTM4MGQxYTg2Y2E2ODFiLjE3MDU5NjU2MzUuZ2l0LmlzYWt1
LnlhbWFoYXRhQGludGVsLmNvbS8NCj4gDQo+IEZvciB0aGUgb3RoZXIgZmF1bHRzLCBpdCdzIGRv
bmUgYnkgYWx0ZXJpbmcgbWF4X2xldmVsIGluIGt2bV9tbXVfZG9fcGFnZV9mYXVsdCgpLA0KPiBh
bmQgUGFvbG8gYXNrZWQgdG8gdXNlIHRoZSB0ZHhfZ21lbV9wcml2YXRlX21heF9tYXBwaW5nX2xl
dmVsKCkgcGF0aC4NCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL0NBQmdPYmZidTEtT2s2
MDd1WWRvNER6d1pmOFpHVlFudkhVK3k5X00xWmFlNTVLNXh3UUBtYWlsLmdtYWlsLmNvbS8NCj4g
DQo+IEZvciB0aGUgcGF0Y2ggIktWTTogeDg2L21tdTogQWxsb3cgcGVyLVZNIG92ZXJyaWRlIG9m
IHRoZSBURFAgbWF4IHBhZ2UgbGV2ZWwiLA0KPiBpdCdzIGluaXRpYWxseSBhY2tlZCBieSBQYW9s
byBpbiB2MiwgYW5kIFNlYW4ncyByZXBseSBpcyBhdA0KPiBodHRwczovL2xvcmUua2VybmVsLm9y
Zy9hbGwvWU8zJTJGZ3ZLOUEzdGdZZlQ2QGdvb2dsZS5jb23CoC4NCg0KVGhlIFNOUCBjYXNlIGlz
IG5vdCBjaGVja2luZyBmYXVsdCBpbmZvLCBpdCdzIGNsb3NlciB0byB0aGUgb3RoZXIgY2FzZXMu
IEkgZG9uJ3QNCnNlZSB0aGF0IGFueSBvZiB0aGF0IGNvbnZlcnNhdGlvbiBhcHBsaWVzIHRvIHRo
aXMgY2FzZS4gQ2FuIHlvdSBjbGFyaWZ5Pw0KDQpPbiB0aGUgc3ViamVjdCBvZiB0aGUgd2hldGhl
ciB0byBwYXNzIGFjY2VwdCBsZXZlbCBpbnRvIHRoZSBmYXVsdCwgb3Igc3R1ZmYgaXQNCm9uIHRo
ZSB2Y3B1LCBJJ20gc3RpbGwgaW4gdGhlIGNhbXAgdGhhdCBpdCBpcyBiZXR0ZXIgdG8gcGFzcyBp
dCBpbiB0aGUgZXJyb3INCmNvZGUuIElmIHlvdSBkaXNhZ3JlZSwgbGV0J3Mgc2VlIGlmIHdlIGNh
biBmbGFnIGRvd24gU2VhbiBhbmQgUGFvbG8gdG8gd2VpZ2ggaW4uDQoNCg0KDQo=

