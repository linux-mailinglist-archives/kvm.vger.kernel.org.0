Return-Path: <kvm+bounces-71609-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +OhLCvJ9nWk1QQQAu9opvQ
	(envelope-from <kvm+bounces-71609-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:31:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CC3E918560F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:31:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 52EA230CE500
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B28333AD9C;
	Tue, 24 Feb 2026 10:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nh5u7bW4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318882405E1;
	Tue, 24 Feb 2026 10:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771929041; cv=fail; b=pNKGf9cqw5ya9g1lm1J1H0sIeL+95B0xF+3H8K+vuphg/EHWsQW7oIxB60IghY9rLHn5nwJC8YK8USaDt1ak3lkoxj029n/qmKkyT7kibdL8wgVUf1ySYsrBXB2a5DHsFXR3aHERUMydnaVDBcCPX2cOOXURXz4Fkcvdhi4MQRM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771929041; c=relaxed/simple;
	bh=3xWhK9pcgOjYp1z4JerLkGm2HDf1858b/VOIXoa6+DM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ai+dvLITHLjciTamJqg383aUfdsYv20Qn794zFp1GehEJz3Bi84nrNDMXmDbOpFFwsT+91VoU2mOqjG06MuNxHKIBFL9PWZuoleGyk1RUsyJ8m4G0K7crq1V4Zd8rca32JoHIxtYIWOPB/GqmAMnp/qIUoNw5yk96In5isXKc/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nh5u7bW4; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771929040; x=1803465040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3xWhK9pcgOjYp1z4JerLkGm2HDf1858b/VOIXoa6+DM=;
  b=nh5u7bW4C25bN4TGF7zhfMrSGRwgSasm1emLBfxlHCnZgUnIF+o2r82p
   pUyvxVP7HHVxmsJqGvJJ08wKqTDANXUeHBytvLHlqm0KxCm2XrmQN/4h8
   UyISROn5tVjx8YAbfMbU+PbmGLTi67/R7KueZiomWAqer2Z+OV8FNRnRq
   Bh2gPpgkLtTHWeyek42ZjPUGgCJwO/HYbnvcBUJnQ4KiAWhoN6Jirlgdm
   +rCKv52hNTijl80SjdLDxr7rz7niI5KbDOVQ5b6o6L/eMwQKs3G6/eUWh
   KU1ZfjCHpDU5UhIWt0AdM0m4sL6Yv+23AjjwQMTMUe6lhEmZOfDmNiW/g
   Q==;
X-CSE-ConnectionGUID: v3TROW/OQE6tqnQo2pcq9Q==
X-CSE-MsgGUID: tpK9AyukRCWu4Yvpygo8FQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="83562187"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="83562187"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:30:39 -0800
X-CSE-ConnectionGUID: ZItso63USG6TiG29F3YfYg==
X-CSE-MsgGUID: ZvkIrHfVQyiGSjYseQK8jA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="214218594"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:30:39 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:30:38 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 02:30:38 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.3) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:30:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ITtfYg5bpab3EbcJQBcW9sxld0dGWvvV4BZIKglJmxBsrSA1bwDk3Jao4l/fFltjorGG7w69ApkvpVllMmrjeRV+e0OaA9csejgh5avRCwAsCNFLRvKQgguX5FAbYlVX9jy0DmuEMOTn31DWZ4vxQpRYbC6gNb3r9VJ82mmRlXkXtmHVYCvsckP3Cai+rzwE7ZSUFBN9o/2vhdiojYw6afNsyuIV//+0eQKNDQHUAStSlH1ipUlEWCBfDKfOxSq08IhfgdZqJ/pstNYY6QKcWWS20zk5H7QvprsH3fglkDqM9zB+vSrySdmYi7KORlNrqI8+8CJ7/GCb+WnTa2zU4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xWhK9pcgOjYp1z4JerLkGm2HDf1858b/VOIXoa6+DM=;
 b=JvmuHgR9cB4/eGSD8W2QIuRyKeo1CEbVFJm2GfWInrfMcTOXwMpKP9ExkHt8EQZHadPIl3D1g/PdQ8jmqdAMyfWQjPSm6s226tqpgv37c1Apdn65GvyD+7cfJmpFtPdeLVEHhtjkUoImxMT5wtWTqK2LjIWRAIufAZC6s6FdJYYL1kJ+hQdYsuHl3JZ/y9vaUucq0MPqS5JtPq7F2SHi/uwHnoQLf8eZ/mBTnggnIqfIWLPzySzogpq/sYut3YNQZjjZiKacE13p8hcpKbw5bMWgPHXfV2N+Xcs+1uMQVBfz+6Vo3BSXM3Tks1Iq0umPVykk/nlOqjjYwt8M47ccfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 IA3PR11MB8896.namprd11.prod.outlook.com (2603:10b6:208:57d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 24 Feb
 2026 10:30:30 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 10:30:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "mingo@redhat.com" <mingo@redhat.com>, "Weiny,
 Ira" <ira.weiny@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Chen, Farrah" <farrah.chen@intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "sagis@google.com"
	<sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 05/24] x86/virt/seamldr: Retrieve P-SEAMLDR information
Thread-Topic: [PATCH v4 05/24] x86/virt/seamldr: Retrieve P-SEAMLDR
 information
Thread-Index: AQHcnCz6PvNsJWZlNE+ecjfXXW9C0bWLYG4AgAXaiICAAH3egA==
Date: Tue, 24 Feb 2026 10:30:30 +0000
Message-ID: <4ff67f6acc162833959b0785d39459417cd89752.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-6-chao.gao@intel.com>
	 <88141072be073896990f87b2b4c33bdd99f38b29.camel@intel.com>
	 <aZ0ULTpWJpGjOKLU@intel.com>
In-Reply-To: <aZ0ULTpWJpGjOKLU@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|IA3PR11MB8896:EE_
x-ms-office365-filtering-correlation-id: 19a274f8-7e9c-4927-a91e-08de738fbbe3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R3MrcWltNjhuRHBFRFRYOGw5cFllYjRFMEt6YlBmUDhrMzV1RERidWY1MHQ1?=
 =?utf-8?B?WldaK3ZhTHN0aUxRSmZYREhMczBDZUVNNVZJWlNDMzE5WWhrMHhpSWM3T09K?=
 =?utf-8?B?WFhFWVFOK3RLTHpMdGNRZXNtOEtnTXllb2V4R0ExbDRhSXN6Mmc4T01kTXMz?=
 =?utf-8?B?dzRvM2o4OFUzazdVelZtNENTSENoNEFlVjMrNVp3QUU5K3NEWkZHRmMrMURo?=
 =?utf-8?B?T000QkcvZXlMN2V1OVJKL0NLNHlUd3JjbjYrSmh4d00yMVRpT1JSdGxPWTV4?=
 =?utf-8?B?YnhURjlSUklZQjRhUjZtMW5DMW9QVU5tVVhaYzhSMG1HVnF2R2hWT01KTnJy?=
 =?utf-8?B?WXhPUHJSVm1hTlpOZDYrTEpScVM2QTRna0l5azF3bGlSNUN0NzhJUHVvd21u?=
 =?utf-8?B?Nlp1QU5qNE1ERWdyb3VHV1JNbDUvUTRSczh2Zkl2TkdtUlZwamtqVTJMYVJp?=
 =?utf-8?B?bWEzQ2Q3WERMeWZEOHpURWNXdng3bXh3ZlN4UUlaNVBwOFJ0ZzlURUNkUkhC?=
 =?utf-8?B?WVA1UlEwbHA1MnA0T2xGZXRrY2RZRnZMZzFZRW1CMjUvSkRqMVZMeUNLRUhC?=
 =?utf-8?B?VlhmdFRpOTBlMW1hTGNST3BkcG9Cc0NGNmovM29aMy8rdUF4RmNIK092TWMx?=
 =?utf-8?B?YlpkQWl3ZUVQY3p6M0Jpamc2eFJpNnFYQjcyUDc2VVc2SThhZ2Q1cGN1MUY2?=
 =?utf-8?B?dFllVG5OY3BEZkIxRGlTZmdOV2o5blFJMkdFYjNXSzRWTm5pNjJoaktkL3Y0?=
 =?utf-8?B?SHFaVTJWaEdFSVpyczdxL3RIT3BNR09xTnlGcktoT29wM3k0dzFYeFdDeXNM?=
 =?utf-8?B?RlQ3dUlxWXNjR0JIQ3dicWpWaTRrM3FHRWlCK01sNzR0YVoxSy9vU2VHTkpq?=
 =?utf-8?B?M29LL2E3eUZrQXE5eENlSDFDMkUzcGlDRmdCWWUrSTZQY081eDF3U29wL1d3?=
 =?utf-8?B?YU13R3FiME5yRUxXWFczRkdNZDFoOFpFVDlaWmdydlNkd1pBVmRzTmhsTkc0?=
 =?utf-8?B?b2xxa0dhTVdRQVppbXNNTVBPWUt3Qmx6VFgyRzVXY1N0L055OEJ4VEtsVmds?=
 =?utf-8?B?WDBEVkhlUHd1eXlkVTQyVlp4MkRxODJ4SjZZWWd1RS9jUUlOcTdBVXFXTFZ0?=
 =?utf-8?B?cXNJSTY4bm14UjlEL1FZaVBOSEExSEhSOVZzN2hHQ1ZNaEZhaUJSVzV2aHNi?=
 =?utf-8?B?Wm1NcERzS3RxTkRXWEdYYUJRWEVzRVB2NzBVRXE5V2pqaGNhdU43NzF4MFhL?=
 =?utf-8?B?Ylh3aEpQL2txbFRzY3VQTzI5K3E0ZnpkMks1LzkzcHV1eVhic0dmT1Foa0Vv?=
 =?utf-8?B?aG56bklhRUdEWmYzR2pQcllqSVJDd3hWYXI1R0grMU16WHdjblFBcW9JZkdB?=
 =?utf-8?B?ODNXdWlGSENRaCtEdHg3Z0RMUFpWT0VYODNQVzlZS0FPMGlyT3NxVXdjU0Fm?=
 =?utf-8?B?Z2hUdy92VVVWZG9Rak9OaUp1VUc0T2hsWjRFWkptYWZ2MTc1dyt5ZzVxeUd4?=
 =?utf-8?B?Zklpc29JRDN2NmJpclZpVWhyT0V3UU1keEZzd0NhZlpvT3ZVR2J0c3dyR2dl?=
 =?utf-8?B?QUVPVDJ2YzUyeE9WRnlxbzJSK0JFM3c5dEYwelE2MGwvNUJBcmhkQWkraHN3?=
 =?utf-8?B?SWhZcmYwTFd5S0p5YzkzaDJXWTM0elo1Q3Rmc2pBWTVJMkFMT2ZmK0Z5ZmZK?=
 =?utf-8?B?QmxFRHpHWk1qODdUWE1JZ1ZqZ0g2ZWEyUHV0WGQyUmh2bktyYXl2c0RiZU5q?=
 =?utf-8?B?QnNtNWhjQjZRcEdrYnh0VU9XWkhlbi96ZWQ5VWpFdS9WMFlmWWRqMEVLODBi?=
 =?utf-8?B?SzFlUjM4aTMxQ0hDWWVGVWx0cGhkUklTQzZXK05jdnJPekFrUkI2RWhjVkRO?=
 =?utf-8?B?RlF5ZUNBc0YrYUNiMWNEbkswYzFNREVFWU50bjdhZEgvak9KZlpCekx0bDFD?=
 =?utf-8?B?RWErbzVvcnREN3RQNDRtWHF4dkdBb3Q1aDlMcG1aUWdSZkNRQnRBZlJwOWhH?=
 =?utf-8?B?MEwrOWpMMThZNW8vS280M3k4cUdpQUswQzJ0ZnZaZ1Q0MURaeXp0ZUF4NFB6?=
 =?utf-8?B?VVFVNzZMSVc0dlROTmF2a01IOGdwQUVRanVYcGdTZWxlSXJpQ0pxVHNsTDFr?=
 =?utf-8?B?c1YxdEVNcEJzTnBWQ1ZuS2hDSzZlT0hyaWZtMmx0bC9ta2RFYmpoMlE4MjNT?=
 =?utf-8?Q?3/LU9zRrGxUJJNKGQOEKPNM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzczN1dabjd2dE10OVIwK2plMG1jL1owazNkM1RqdGpUci9NNStFTDMwOGpD?=
 =?utf-8?B?VU5jQTd6S3ZkZ2NLbXBIK01NcGdTS0xmbEZpckFIbytQU2pBY1JqNUxhM1dS?=
 =?utf-8?B?YlowaUYvNmxUU3lERE5UK2YweUNDWkluTVI5clkwQnRjREp0SjNNWGNyd29p?=
 =?utf-8?B?N2tzRG9ZZDRMMk9Zb3VkdkxBQjJ5Z2xoelVnWXcyNml5aEtsK0dTaEduMmxw?=
 =?utf-8?B?RzN4T1NIaU1YTTM5UEhtTWJBZ1d2aEhRenE2TlpyUmQyTGxxejlZNnkvY0xi?=
 =?utf-8?B?Y0FFOG1MUXVDVVRZQVpyVW9PUTNVZExjVnBWZTU4WWVqb0xxRVBMU3kxMC9G?=
 =?utf-8?B?c3kzbnIyUElGTlA4UG1WbS9LcCt0QllDNHVYMHdkZnE0c2dtLzRRVHo1REZa?=
 =?utf-8?B?bmRTYXo4QkliQzI3ZXVQKzlvaUpwYXpXOEJUUytlZ0I0M1ZQUHNEZnRTcnk4?=
 =?utf-8?B?TU93NjNqUU1oVVhXNzJrc2pKUEZyOGtJUGxVcW15aFBtUWowVERWVmNTUHdJ?=
 =?utf-8?B?V2w5TWd4UXlnUy82clFPUzVhWFBUR09rU1B4TWd4OEdJS0NuNURSKzZqZmg2?=
 =?utf-8?B?ZXNLaWxGRVVIeHZVY2c4L1I2NHd4ak93WGJPWFNPMmRaOThqaDhPdDdCc0p2?=
 =?utf-8?B?aUY1UG0zOHNkb0dFYmplbEd3TFBNU1lQRGNTSzd6SHBaOWwrNEluL3BTWHZW?=
 =?utf-8?B?YjBpTWRVck0zTXRWcWY3NGVhOUlENVFEcVI3dzZVamhQcHdYVXhqZ0ZHYWRO?=
 =?utf-8?B?QTRyKzlRR0wvOEw2NDZpYlZsdWl4NDdwclVlMWZpTzQ1a3hNZml0UVhVVkJL?=
 =?utf-8?B?dFZOWmhLaGRwZGI5ejZTQUpnbTdzKzNuNWVOQnkxVWJic0hCUTZzWmVyU0to?=
 =?utf-8?B?Q2RyZER1Ukh6eVRQSmRUVktEOXRQeSs4SXBoaW1KVzI5UHY5eko5V3hTN2Rp?=
 =?utf-8?B?UXk2eXBKRnhrYWNZVnlsb3B2alZWVitQMzVHMFBRRjI1elAwMkhWZFVnNlkw?=
 =?utf-8?B?ZWNnWHJCSHVZVGNGMkwxcFBhL3RnNk00aU9UVUFWdVkzMkk5bitDVmROWmFj?=
 =?utf-8?B?dGpMaXJnV3pjYjE3T2ZPSXBTWHZYZmxtS21qbFZ4bm9pK3gyKzZWY2MvYU5O?=
 =?utf-8?B?SUFBTlhCMzdRUEZmd1VlK0RJQkRIbU8zS3lsdE0xalVsckh6Q2QzRG9OSld2?=
 =?utf-8?B?dWhodW0zVVQzOWNKV1FOWnhZUDlkMmNyanBoc1BjdmRxRWpJUk9RSFhCT0VQ?=
 =?utf-8?B?aWFKY1NuU0hGMjh0N3NwREgrZ2FGWmlEYVVPemF2eXhucTNxQlFpbENvRVFN?=
 =?utf-8?B?NlFGdENWc1hMNDJKT3FpVW1Da0ZsVmt1TC9Ddit6T3N4MXREdDZkRGVrMllW?=
 =?utf-8?B?YkdsZGJIbnJwQ2ZidzZRRFY2a1lwZWY0YUduYlJtVzBMQm5zS1EwbnZxSGt1?=
 =?utf-8?B?VWpzQ3BWNXNnUEpiTVdYWUY0WTdsbEY4REYyaHZtMHdibm9aNE0vWGMvanZv?=
 =?utf-8?B?RGxhNktqQjhNc2NoWjFUNEhCL05mdUh5enpsNWhJMVJKbnJwcGcycUxtU2Fo?=
 =?utf-8?B?eVlVakVFTDRNN3ZDOFFJYytZMWJpNzl6WlJZOHRCcnU5MGdCWXFwMGcvZlA2?=
 =?utf-8?B?VSs2Ty9wRlFMOUhlRDdmb0JSbWd3ZXFyck1mVCtKSFhGMmxuSk5ReS9wZk55?=
 =?utf-8?B?VGtERVFEMll1NmNJUVJnWk9qb3NlN3ErWFlQcnFJZW9qU2QxL0dhRUozQkRj?=
 =?utf-8?B?QXZZNWxmc1NpSEJjaXptMGNxME5LdjB5ZkpYSUxLSmhRdDlQS01QeUpRaTFq?=
 =?utf-8?B?OGU1Zjg5aFRoMUlZOGdrWGxMVjlYU3FtYmh3ZHlPNk5pdFJ4cVljOHV3OS9t?=
 =?utf-8?B?THhTR2taZ0JvSHFLOXdyZXBRWUx0T0l3bEpqWmZhK05kdzM2MWdBcC9lQlRt?=
 =?utf-8?B?VTcvOG1kSW1yTmdid1pmaTl6bUJ6YnlSWVZrUDJ2cVJBWkNIYUxBN0gwVENH?=
 =?utf-8?B?RXlNNUtjK1llN0VBUUhKSU8ybkxwK1pJbXowODNTT1FkWElwdEZhb0Q1d2FQ?=
 =?utf-8?B?NzZzdHZiRFRXTWp0YSsvcTBDK3ZZLzVjU21ndFI5blJWOTk0ZnRpRldwcDMz?=
 =?utf-8?B?YmpLMXpQVHVVRDFDRE1CbGpFOCtuUG1weEVJZlRpTDNtS0liWkNiMXpvbTZ5?=
 =?utf-8?B?RGJqK0xLb043elFaNWRnRUxYSXA4NnlSaWRPOHdtb1kwbTdNRW0xQzVOaXJE?=
 =?utf-8?B?d2FoM3UyTHE3dTFiYWE5L0NZZlVib3ZZTEova2dsak1aa1FJbnd0a0c5alZ5?=
 =?utf-8?B?L2EzVFA3QWZUQlF5bWxwZis0SkVlODZQVmdVMCtDZks5aXpiUktpUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F40FD63917BAEA4AA27680D4B4A59577@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a274f8-7e9c-4927-a91e-08de738fbbe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 10:30:30.2763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DdUAXqsUVncTf1+1RheC9Szs7IYbOjTkDKS/9k3gGqif7rzbGt8O1k5xCJjqgPRyVIrNWO1yB0qf0/g6vxVVGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8896
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71609-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: CC3E918560F
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDEwOjU5ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
RnJpLCBGZWIgMjAsIDIwMjYgYXQgMDU6MzY6MzNQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiANCj4gPiA+ICtpbnQgc2VhbWxkcl9nZXRfaW5mbyhzdHJ1Y3Qgc2VhbWxkcl9pbmZvICpz
ZWFtbGRyX2luZm8pDQo+ID4gPiArew0KPiA+ID4gKwlzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzIGFy
Z3MgPSB7IC5yY3ggPSBzbG93X3ZpcnRfdG9fcGh5cyhzZWFtbGRyX2luZm8pIH07DQo+ID4gDQo+
ID4gU2hvdWxkIHdlIGhhdmUgYSBjb21tZW50IGZvciBzbG93X3ZpcnRfdG9fcGh5cygpPyAgVGhp
cyBwYXRjaCBhbG9uZSBkb2Vzbid0DQo+ID4gcmVhbGx5IHRlbGwgd2hlcmUgaXMgdGhlIG1lbW9y
eSBmcm9tLg0KPiANCj4gSG93IGFib3V0Og0KPiANCj4gCS8qDQo+IAkgKiBVc2Ugc2xvd192aXJ0
X3RvX3BoeXMoKSBzaW5jZSBAc2VhbWxkcl9pbmZvIG1heSBiZSBhbGxvY2F0ZWQgb24NCj4gCSAq
IHRoZSBzdGFjay4NCj4gCSAqLw0KPiANCj4gSSB3YXMgaGVzaXRhbnQgdG8gYWRkIGEgY29tbWVu
dCBzaW5jZSBtb3N0IGV4aXN0aW5nIHNsb3dfdmlydF90b19waHlzKCkgdXNhZ2UNCj4gbGFja3Mg
Y29tbWVudHMuDQoNClBlcmhhcHMgdGhpcyBpcyBiZWNhdXNlIGluIHRoZXNlIGV4aXN0aW5nIHVz
YWdlcyAid2hlcmUgdGhlIG1lbW9yeSBjb21lcw0KZnJvbSIgYW5kIHRoZSAidXNlIG9mIHNsb3df
dmlydF90b19waHlzKCkiIGFyZSBjbG9zZWx5IHRvZ2V0aGVyIHNvIG5vDQpjb21tZW50IGlzIG5l
ZWRlZD8NCg0KKGRpc2NsYWltZXI6IEkgd2FzIGxvb2tpbmcgYXQga3ZtX3JlZ2lzdGVyX3N0ZWFs
X3RpbWUoKS4pDQoNClNvIEkgYW0gZmluZSB3aXRoIGVpdGhlciB3YXkgLS0gZmVlbCBmcmVlIHRv
IGlnbm9yZS4NCg==

