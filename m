Return-Path: <kvm+bounces-46403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF28AB5FD8
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 01:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E44638660FC
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 23:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8940220E03F;
	Tue, 13 May 2025 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QizqiLvP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25F61A3BD8;
	Tue, 13 May 2025 23:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747178426; cv=fail; b=JqMXdZKkeMH2IRwTNTNC6ZJQf7FtnPi+nOderoA95O0VDi7VFY4Z0+R7WEOrrTcszQ3R7c/LiGUqwjrNwHS17XFRugl4d9/LCb4qRfLDJEbVVvv1K6Wx2YGerJ/w4ZPmZRUAoLlMiWM9QIgFRKD8jSU4BQ12BaGd3MCB3192anA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747178426; c=relaxed/simple;
	bh=Uc5qL1Q23FBiiiTSMxabGsjH8Fo1a30sjK8IqOBvV8g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FT8uA+U6+DvoY46h5+yLGyuARx/aa74EtI7bVIAPecu0DvPAHKgDmafJiQoWKDPh7jS17sz4gzORSIZKGsawTOPg8dKz1wx+N3l1n2+5vVn00D68zegTDIxXdbsp7vGy15RQefOFC8SiCH0kydqKVVRjidv+lyaRBMYw0QkFhWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QizqiLvP; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747178425; x=1778714425;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Uc5qL1Q23FBiiiTSMxabGsjH8Fo1a30sjK8IqOBvV8g=;
  b=QizqiLvPwYcjkhOAgDV473xOCRF3BZHrZGj2ypbZf4NuxAK5X51f5l/p
   vGVg5RIO7nPFZFWcg+EmwwdeTr+ra239dKPMODzBI5aUiAmK9kuq2c+7g
   QSklnSTNdYf1Y81R+b3L7pCW5FeWy3MiJM9aVaKOTqx1ecc847Nv6d8Sn
   YKMZdwPGkkj2GhC/tY4IBfNIbyV5VGnMgN2VfhRe8I40kb7fx8FRgnU9R
   iYVTxiH0egXw58vpHRfGSA8yYbcuOngbyqS8Xcnqh2JDKs0cb/4GKJopW
   0jVW2o8qh7H4oKLh4FF6ClCkWqGXFShGq2Esp0JcHgt63qDN/38YshTFo
   A==;
X-CSE-ConnectionGUID: t2w2X8aVQPqHOT10W/ZfgQ==
X-CSE-MsgGUID: pX6p1HmlSrSDtphg+n/pEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="71553149"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="71553149"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 16:20:24 -0700
X-CSE-ConnectionGUID: COu2hP0lRVqE2M1WqoIPSQ==
X-CSE-MsgGUID: +HX3iplTRSm7RMj4/YcQxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="142737697"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 16:20:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 16:20:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 16:20:23 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 16:20:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Im8KNNdkWEzGzZtGpFFS8QGOFS4NvO1oFKZfPqohHOhPhwKRrtSoC47FbJMxgysJozZeA5m4jneG3Wo0ZNIqLQGY09o9jDI0+4JJGrQbeRIX90ogicVd1EpzLz1u+wlbRPCHXesTpMvU/xyrrd7f8vGSatkf/uGce+sBvBywKCBhQ+kxgAm/V+eMLY7prhhIWMMlMdbviMz+fO+fGHVZT3ItjCZDxXXfsa3vmBrQm5eSMXdFmTvSMC9kzJRUkOnlo2Ttl5VNd1ogZQFimySeTS2hlfK545Gi4b9BW7MN4SVgRsLmqTQDy/jw2vhStiLhhFB0c/fFZ+tQR7yjqaS5Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uc5qL1Q23FBiiiTSMxabGsjH8Fo1a30sjK8IqOBvV8g=;
 b=lWvkxGoIGmgBr/S5Bvhwuway2xKXbI8a4tEWjM6ceK36th7gmxOk/noYeG7fBwYofW84rs2VVz4FclCqrj+hcTBWpZ4NCZMPK3nNkRMfsaT8PnOFsACSARWlCAs4oLN1f0tgKvfyJqDvrADgNDpFKJ6Zglp8B9UjVWnmkyxEPo3/fr5+ry01JarKL/ps/ihxCVysHOkCynctq0QBMPOhTZfneVR/RFchcxU2P+wz7ewt8zFZ65HmALhsQMu75VgugmRmI12nDtypAC6Yg85qRA2ZhuPpDTZxOu8AKqf+h9DucqIunUeR2HlR88cJWyqy0qH/aJ0L4PCtYf3yERAWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4999.namprd11.prod.outlook.com (2603:10b6:510:37::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.19; Tue, 13 May
 2025 23:20:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 23:20:18 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 20/21] KVM: x86: Force a prefetch fault's max mapping
 level to 4KB for TDX
Thread-Topic: [RFC PATCH 20/21] KVM: x86: Force a prefetch fault's max mapping
 level to 4KB for TDX
Thread-Index: AQHbtMaLPfHS82PUZ02rWw+KQy+OB7PRUZ+A
Date: Tue, 13 May 2025 23:20:18 +0000
Message-ID: <1e6ced6acc5c733c88879a3febe09942d32175d6.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030913.535-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030913.535-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4999:EE_
x-ms-office365-filtering-correlation-id: 5ddd50a3-8363-469d-5acc-08dd9274b9b4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MC9CTytBaTdtUHdwMEppd1RtMEkzUXdDR3Z1ekpWYWdYM1ZERWxjVmZuNTda?=
 =?utf-8?B?czNNWVBpS0czTWFtVDVZRzI2c0FZUVVYeTUzS3gvS0tMTUw1MC9XS2FDb0dx?=
 =?utf-8?B?Yzdydlo5TE5hZFgvZDVrY0xwa1IzUVFCWjJPSEYwQlVHeFZhZkxrcno0SGpU?=
 =?utf-8?B?SHdJd1hHay9tSDJ4ajFMSjcrMW12d2xWYmdJWG8xekNWa3ZDYUhhK05VSVdo?=
 =?utf-8?B?VHRLSmFIM1pzK2drcVVHMkxPZFJGWkhBeXplYkttd1FEeDNZTzJNMUhRRjF2?=
 =?utf-8?B?d1dEcXdRTjFYcllWeVdxY285L1B3WGs3Rk1RZTl1Z2g4WXpySDVJSGR1VURM?=
 =?utf-8?B?UnlBL0pLSUprY1c2WlM4NDIwV3NUMFQ0K0RzU1hZd1RxUmh2QW1uanhEdTZh?=
 =?utf-8?B?WGp1NG5vNlo2SUUvSllTcXBWWTNUY1FlWExyVlNYOTBmYUpCemp5eVd2WHFx?=
 =?utf-8?B?Z1E3K25Ic3VxQmxMdy9pTHNSWTR2UWllZmcvRXB1WnB0dG9xVGpiNG03dWxB?=
 =?utf-8?B?VVZ0bTJLTVcvU0FiRWpJMUdjOVFqNlFlMGFGZ0tHSWdFeHh3VTlNVE5STkRT?=
 =?utf-8?B?Uk5oWDU1ek5GNGs5Sno3Q05oQXFVTU5sM1gyV0xwbWdWN1kzTkQ1a21tVlpN?=
 =?utf-8?B?Z0Q4a1hvSGgwaXhjTkJZUmN3YlQwNkY2M011d2UxZnJCK2NrODNzOUVkR1Mx?=
 =?utf-8?B?a25EWVZ3aHV3L0YxMTBpQWRuMHZXZmFCRWEzbVBLcmZNeWdjcWNRMHdsUGFF?=
 =?utf-8?B?OE1sM2JRZXV2NTVxM3g0bTBlOXNxbGtETlNSWnlsNG41YUVFa2VkTWlONGdU?=
 =?utf-8?B?QXM0cC9xNU5HcW5PbUk0dThZMDFhVFlwYXc1TTJaaGt5MEpHVk04aXdQWGFn?=
 =?utf-8?B?VTVQOTMxS1htaEttenlyek00U3N6YlBRZmtQVFdFaXhxQTZKaW5JZnN4cDJj?=
 =?utf-8?B?bWxibUh5dHRSWW4wUTNrOEdMT2FMSmV4am4vbFN5SUVjemNBdkhEeklTZUlz?=
 =?utf-8?B?VXJYZUdBTzY5aFhkZ1ZtMWRTdUJnYndWaytCZll0YWtybWp6SWRhMDdHSTl1?=
 =?utf-8?B?STNwdDNqSmN1NStmMEdKTDVkaXN2VXB3QUVsemsrczN6NWFabjlLczJkLzlI?=
 =?utf-8?B?SmdISGhLK0xFSHpsRWJjTWZRR0c0RkUrOWgrZndCbGQxT0JJZTcwZk50NWVO?=
 =?utf-8?B?Nkkwckg2RHpLeW9jYlpBdjg3Z3hPeklUNWtkNWtjUTVIbHlHVUt3VEFCbEtu?=
 =?utf-8?B?K21yU3RqYndOa1dLc2VXT0I5R21hQ0pDVVcvNDZhYzZ4RjFXSUVmckdlTnU0?=
 =?utf-8?B?OWdNUVphZ3RuU2xidmlNLy9VRC8yVFFwMmRoNjlIWm16YVBDZzhmMVdZY1pR?=
 =?utf-8?B?dm5jalgwYWE0TGNSMk5vVWJFT3hoZjA3OStBRWlvYk9PSEhYRjljZUlqaC9Z?=
 =?utf-8?B?SGVWeFVtdlJGdlEwR3NLQ056Y2k0RVk0bVJ6V0cxR0Y3cW9oOUlFRU9FMHNz?=
 =?utf-8?B?d214eXhGNHVIT2lrMEdBR1kxNkVZR3JCSlNvZmwyRXhOMHBxejFJVmZ5ZlVs?=
 =?utf-8?B?T2xJSVZuWjYxdytpYzQwcnRlOVZ4aFB1dFEybzJiZUJsS1IwUHZ3Z1R3d1ZY?=
 =?utf-8?B?K3FEcFk0aHdwK0RnYkE5VUhlYzZxUGVMcTJRUVdMeE83bFNiMkZ3d3NCN3o2?=
 =?utf-8?B?ZTVjOGZrWnFtN3BvOE5NMEVPYXBKR096aERHd0NtZGRlVHFZZERPY1VzUlZ6?=
 =?utf-8?B?aFJRNDJLVnRMT1hSTnVDS0d1TWMzVnZpZnJNWTdHbTRyMnRIblhpemNScW8r?=
 =?utf-8?B?WFhIRVRGS2VMZVJKcWd2K0NsSy8yQncwa1IweHdKT3RZYWFxc2pPbmdGYVJX?=
 =?utf-8?B?Z1M1enlQQWlPTkRqNjBDYTRDK2JrZTRMZ0l6M1gwSGtocElZTkdtV1dyZ2kx?=
 =?utf-8?B?ZERIZG5jdnptb3o2QWRVNzg3RHN5bWlkelRiZ3NUeER6Z0NiRFZpdFp1TEdO?=
 =?utf-8?Q?z7RufdMgPGNKuiZjcoEivYfMRNlp1E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eERVZEJkNThFWDNPMHhBU2pGZC9XdTFGc3RQV3M0L0R4QXRGZWRhMlA2d200?=
 =?utf-8?B?VWZOOVVIeDg1eks2V1BVVURRSkQ0dzNTNlpaT2tha2tkYlBQV2ZrRE1UeHIv?=
 =?utf-8?B?dWRid0NOQzNUR3pXM2R1WVJOVWFiZC9pZFBlblVxYWxSU2tVUFM4cDd1SEFU?=
 =?utf-8?B?eElRek83UHc4VERldDhKUEJ0eTRHeW9WTk5rVzNFVk9yZThYem9ITFE2UkE1?=
 =?utf-8?B?ak85Skw1Z1drVFRuQ1BUYlFlYzdIaG1qOFRUd0o3azJzVDlCTFpaMjlRSWJ3?=
 =?utf-8?B?ZWFsODlNRFNWM1E3ZGlIM0xJSE1tRUI4RUMxNmpqS05rME9jU2VtYTk0a0tK?=
 =?utf-8?B?YjJFZE1jdGkxVFd0TDh1Ly9wWmVkbU96OXo4enFiUkNYYmJ1NHJaV29xWC9u?=
 =?utf-8?B?K2VMTkNqR0RGQzN1TjBVTGVpRGZlZVJwcVp6SGR2VU5zcTU4bUQyb3IxQks0?=
 =?utf-8?B?VUovZnZ5Y1hPbVUvWVA5WmdhWUc0SU54WGh3QVFCdWlhakI4VVZFWGxzM0NK?=
 =?utf-8?B?SHZVTmx3Y3pvK1ozMlNhbm9JaHdpUmU1ZlZDUEJIRVcwRTdXc1ljM0hBTjJZ?=
 =?utf-8?B?UENlVVpmajJVY1lNOWxVc3JyU0tWVGJiZDhvZG5xczB1cnhhMmY4eWdGQU1D?=
 =?utf-8?B?aUpDejNaSXZSZXBNT0t1a3Z0ejB5RWNFdU5yWTVCaDQxSTNxc3NwZCtSMXV4?=
 =?utf-8?B?Yi8wMlhlbmE1OWoxVFBwVzBicXVDOTZRNXB5UEhiV0MwaHNNYjc3U3pyRi9B?=
 =?utf-8?B?bnJBOFEyVkdaa2dPNnlZdjNwWHpsTnNUTDJqd1ZnY3o5SktJRGR1eTFmOVBx?=
 =?utf-8?B?K2FmZ0lNczY3R3NxUDlvUXllU05RcXFKbjU3YUdScDRTVml6d3VQakJ1RUtp?=
 =?utf-8?B?eUNHVjJvZ25qOTJoL21hQ29CU0thWGlmRE5KektRcEtDTXdpVzBiN0ZHai9C?=
 =?utf-8?B?bzhVSGZnM0sxVzd1TEw2MHU5SWZDRjZOL3RFc2pzSUdUeTdRMEhEZjVMRm5F?=
 =?utf-8?B?OEFacHA4bHp2NmptTlROQlYxMTZhTVZDQWhvWnNzY0JXak12ZUpwSy9yTUVw?=
 =?utf-8?B?VW9vL0w1aHRmV3NLWDl5cFZOd1J3dmQwRHp0TDYzc1NnVGtQaWlHdnZ3MUpY?=
 =?utf-8?B?VDJTaUYyL1VidGRsbzl0ZUJWclFzamxleGdyODl0UGJZbTNZZTNFSmo4YWlQ?=
 =?utf-8?B?V1Q0aWIwMnpWeTVvKzE0cUswQWtBSE5tNjBLRE9wM2N6cElFZ1dnbGNHT2g1?=
 =?utf-8?B?SSs0T2lwTUF6TFJwSEJRYkZWTGlsdHl3YW4zM3pCNG84TU02NktpR2dybTBz?=
 =?utf-8?B?eC9nbkJNUVR1NkJuRDc1aGhtUTZ6UjdtZGMwb1A1bzB2NmNKZVQwVVBEN0tQ?=
 =?utf-8?B?V0h1bzcrR2VjOVlNS2xnZlh2aGhRUmJyWklINTlpY2RpSlZrMjNwU3pFODA1?=
 =?utf-8?B?K3kzeTVvTVg4MDVOcVFvZnJzVmFxUlg0Yy9wWHFrNUlYcG9hclFoMnZYZUhR?=
 =?utf-8?B?YW45RmtnMG5NRGtpUGxFa0hHMUFHRHBGY2t6SG9ySmhnVHV2eis5U1ZCWUor?=
 =?utf-8?B?azMvZkpaODJIb0wwQTM3RmpJTkxkZUxOYmRWcDQyQ2Q1SHBTYjJGbHBmU1dS?=
 =?utf-8?B?azFLUHF4MFZDSDlyMEZLeGxURGt1K0NldTN6TjlsN29SenB2bWJCbFpNbUMr?=
 =?utf-8?B?SSs5di84Wm1UZk9jaDJxU21ibldqZ0xYWVNmalFNRkNOUkZqZGVmbUNuRVBZ?=
 =?utf-8?B?WVlDMkdYREhLYzlIMnduWUdhSTBFOG1BNzIvWUpuQ1A2MGEvYmxjZlg1dHc1?=
 =?utf-8?B?NnU4Sno5R2dieWs0Sms0cUg1ZW1KZFI3ekVOSjJYWStTYTBNYVpsUFRFdHN6?=
 =?utf-8?B?cThjdEk0cHpSQ3pOR1ZjY3Y1M2NnUXUwY1hNMXJHemQ4TzkvOWhRWStDaHpK?=
 =?utf-8?B?aFVJRlgvQ2JOMXpXS2pobW5nY1hKNE1oWnBjR2RJUWhaNWFQR0dpU1RKcm5E?=
 =?utf-8?B?LzZSWjI2S2g1dm5vdDVteGJ5NEpQdzBIbnZPNk9UUUliZVRsZFNHaHo2aFpY?=
 =?utf-8?B?NHV6Ym9lL3RVdmQ0WWRWWC9FMTd0MlZQZi81RW1XcUhnNy9MNW5VVlNuMHUw?=
 =?utf-8?B?M05yU2wyTnFRekV4eE1XdHI4cWVCQ1dleFpCa1pxdFRzWDZud3lsbXhhY3Zl?=
 =?utf-8?Q?7nnFRo1ZoPaUQ1JOka1EaM0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6FC483369CE6BB449E9B007578299E63@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddd50a3-8363-469d-5acc-08dd9274b9b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 23:20:18.5564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SOHAqox5GQ/kcQaP8pvKxDl9OrgA74OBIjz25PSINuIe1Zhs1LV9/Ge2H8zJNwf6hAiFvTKWm83uUIdWb642aUewunnqHqUHMbiWUDKvSCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4999
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA5ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSW50
cm9kdWNlIGEgInByZWZldGNoIiBwYXJhbWV0ZXIgdG8gdGhlIHByaXZhdGVfbWF4X21hcHBpbmdf
bGV2ZWwgaG9vayBhbmQNCj4gZW5mb3JjZSB0aGUgbWF4IG1hcHBpbmcgbGV2ZWwgb2YgYSBwcmVm
ZXRjaCBmYXVsdCBmb3IgcHJpdmF0ZSBtZW1vcnkgdG8gYmUNCj4gNEtCLiBUaGlzIGlzIGEgcHJl
cGFyYXRpb24gdG8gZW5hYmxlIHRoZSBpZ25vcmluZyBodWdlIHBhZ2Ugc3BsaXR0aW5nIGluDQo+
IHRoZSBmYXVsdCBwYXRoLg0KPiANCj4gSWYgYSBwcmVmZXRjaCBmYXVsdCByZXN1bHRzIGluIGEg
Mk1CIGh1Z2UgbGVhZiBpbiB0aGUgbWlycm9yIHBhZ2UgdGFibGUsDQo+IHRoZXJlIG1heSBub3Qg
YmUgYSB2Q1BVIGF2YWlsYWJsZSB0byBhY2NlcHQgdGhlIGNvcnJlc3BvbmRpbmcgMk1CIGh1Z2Ug
bGVhZg0KPiBpbiB0aGUgUy1FUFQgaWYgdGhlIFREIGlzIG5vdCBjb25maWd1cmVkIHRvIHJlY2Vp
dmUgI1ZFIGZvciBwYWdlDQo+IGFjY2VwdGFuY2UuwqANCj4gDQoNCkNhbiB5b3UgZWxhYm9yYXRl
IG9uIHRoaXMgY2FzZSBtb3JlLiBBIHZDUFUgbWF5IG5vdCBiZSBhdmFpbGFibGU/IFdoYXQgZG9l
cyB0aGF0DQptZWFuPw0KDQo+IENvbnNlcXVlbnRseSwgaWYgYSB2Q1BVIGFjY2VwdHMgdGhlIHBh
Z2UgYXQgNEtCIGxldmVsLCBpdCB3aWxsDQo+IHRyaWdnZXIgYW4gRVBUIHZpb2xhdGlvbiB0byBz
cGxpdCB0aGUgMk1CIGh1Z2UgbGVhZiBnZW5lcmF0ZWQgYnkgdGhlDQo+IHByZWZldGNoIGZhdWx0
Lg0KDQpUaGUgY2FzZSBpcyBLVk1fUFJFX0ZBVUxUX01FTU9SWSBmYXVsdHMgaW4gMk1CLCB0aGVu
IGd1ZXN0IGFjY2VwdHMgYXQgNGsgKHdoaWNoDQppdCBpcyBub3Qgc3VwcG9zZWQgdG8gZG8pPw0K
DQpUaGVuIG1heWJlIHRoZSBrdm1fdm1fZGVhZCgpIGNhc2UgSSBzdWdnZXN0ZWQgaW4gdGhlIG90
aGVyIHBhdGNoIGNvdWxkIGhhbmRsZQ0KdGhpcyBjYXNlIHRvbywgYW5kIHRoaXMgcGF0Y2ggY291
bGQgYmUgZHJvcHBlZD8NCg0KPiANCj4gU2luY2UgaGFuZGxpbmcgdGhlIEJVU1kgZXJyb3IgZnJv
bSBTRUFNQ0FMTHMgZm9yIGh1Z2UgcGFnZSBzcGxpdHRpbmcgaXMNCj4gbW9yZSBjb21wcmVoZW5z
aXZlIGluIHRoZSBmYXVsdCBwYXRoLCB3aGljaCBpcyB3aXRoIGt2bS0+bW11X2xvY2sgaGVsZCBm
b3INCj4gcmVhZGluZywgZm9yY2UgdGhlIG1heCBtYXBwaW5nIGxldmVsIG9mIGEgcHJlZmV0Y2gg
ZmF1bHQgb2YgcHJpdmF0ZSBtZW1vcnkNCj4gdG8gYmUgNEtCIHRvIHByZXZlbnQgcG90ZW50aWFs
IHNwbGl0dGluZy4NCg0K

