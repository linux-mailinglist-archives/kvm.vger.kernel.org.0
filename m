Return-Path: <kvm+bounces-25131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDDDF9602F4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 09:24:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11789B22984
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 07:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97306154BEB;
	Tue, 27 Aug 2024 07:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z79+Iple"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651A571B3A;
	Tue, 27 Aug 2024 07:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724743462; cv=fail; b=UK1zNWlb5RWktGVJXSYsjGQxBK3/6cfcnAhgAdUbW5Trgr+tGTe8QAQWqsSJz7VQ0e9rIB1Nns4fqR5H2GUZUTuAjO/ccViBC9CcZP/KkX/6rutiUPsadjDLbyUUeh995kXk5oYFB2gJok5o04NXWWTc/ckkWZZ9rP8hrDeBMrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724743462; c=relaxed/simple;
	bh=QYCDgc5iaLECWa5SW85x1AOYekxvupGBm7sEzFnOhyk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=duuyOfEfxd57Y3ezqGGcjE5oO/3salAUx06RN304ISHcoY97LcxiGbFzBfA9MsXdp8NwTTGXnxPeBp5S99uAGb/jFzP/vD6h3wvdDxI4+4JlBCQusHnaAiQnJkE3rwquCTe30FbZrHd8BLcTKcxXMGEHTKNkH0N1Fn4NmW8NFt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z79+Iple; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724743462; x=1756279462;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QYCDgc5iaLECWa5SW85x1AOYekxvupGBm7sEzFnOhyk=;
  b=Z79+IpledRUhNzfPsLegy7VZWobjq1SyJOTD2OBKdm2QeYL5R4GwFuHD
   0cmonqsgsB2w+tHK7dXYK8WQja69F5x6yd0FqsM/WablDyPqHncINMU0P
   /y+DEsH+vhm/6YsJz7a2fGJfqzP5gzVE2hUk8R3IWjR/CCe4KGusY4mhv
   mSbWTLTBSuqogCkE4v9lxmw7EXO+tw0YVAs8LYuUfWIGZusdjdPAQKmwJ
   +rx8iCRirsjhopyro9IQPLA0AOmqIN8OFjKYkOKgfKWd32rvIYBOB2Tm3
   4RHQz/RabIg2ffY8TUNToFhim0ohv3Acjdq/ALjYmZxv/tDa8MWjHhQoZ
   g==;
X-CSE-ConnectionGUID: S/FsE6m3S9+6+5K/+q/nrQ==
X-CSE-MsgGUID: vJFzckP0Ql6/FAiARf/a6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11176"; a="45720031"
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="45720031"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2024 00:24:21 -0700
X-CSE-ConnectionGUID: nLZml0J/Rw+o1H4OG4ax7w==
X-CSE-MsgGUID: bXFSz5olQHeoIev08nA2ww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,179,1719903600"; 
   d="scan'208";a="63289185"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Aug 2024 00:24:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 27 Aug 2024 00:24:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 27 Aug 2024 00:24:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 27 Aug 2024 00:24:20 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 27 Aug 2024 00:24:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XxskXwtOCV2X2d8I9Y+aXwv1GFbKNiD0oWEmvgcQpQ/H1H3N3TGCRCUsquUxE4CzniTMs8A4W9FRTLffQVqpxc+AAu+DZIjIMY02FJeKIK2lqihSl1y5K8p1JKcvGTCdIOUDNfSacYJDyqoqSp9O2J5IGycN/7dxlV+MY7cCatkYHN/S3IaUMWWUDJIsLfbY2NptYhb6J4p3EpZsfVeJ3ZRMxaXeOWTSoUtKLkua7PBY6phqUHVpHnraRkXCfroJG4l619kpvgAbWfczgJ8wbaSpmZyPNYrhd6LdebMF57T/7NvRxTsXzHGGAQPPXeBysNlKBVXHmziDDoRZCS3kSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYCDgc5iaLECWa5SW85x1AOYekxvupGBm7sEzFnOhyk=;
 b=idQGPG1m9H6Dro5zIi7R0PqWOQdy27U5TwS1+fohBcYgN2wDxGAEMXYsgF4krrb5lRaQaY9NRsvPg+83dqVK+c+VQF7mkJPGfCrPhCzG8LMhGOQupZJlkkpQuHFmPYZHEDPV/Av7jk1nYvww6mKqkEfcMkHYDk8DfZRqie1YdjA/Y86RtbPu6Lwj/7RJuilotA+TtvVHwtagCVM4HmZYldv5jY0hT3vkgQuFbau+3xE47vYNeqT0d1WMKYEc7Suv9rRxdybBf9XONNEIRosPgKLrOTjWFkslJOBYpp5g3EbzQ4EfjhwKTKyy6WUM0fBMlG4RaTWFFsAqIEWR2jIqSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6966.namprd11.prod.outlook.com (2603:10b6:806:2bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26; Tue, 27 Aug
 2024 07:24:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7897.021; Tue, 27 Aug 2024
 07:24:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 09/10] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Thread-Topic: [PATCH v2 09/10] x86/virt/tdx: Reduce TDMR's reserved areas by
 using CMRs to find memory holes
Thread-Index: AQHa1/rKhBfuuYvWD0iV0IdGCEl+mLIwsGCAgApD6IA=
Date: Tue, 27 Aug 2024 07:24:17 +0000
Message-ID: <28690ca3dca17e757a23bf60d05ffc75aef9b35e.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <39c7ffb3a6d5d4075017a1c0931f85486d64e9f7.1721186590.git.kai.huang@intel.com>
	 <055622fb-93b9-49a3-804e-c2525edea4a2@intel.com>
In-Reply-To: <055622fb-93b9-49a3-804e-c2525edea4a2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6966:EE_
x-ms-office365-filtering-correlation-id: cdac989a-d2e5-468c-a61a-08dcc66942d5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VWY4S2R5SG9pOFZlQ1J5UncvUEhZWTdnU21aY0V2Ykx2engvV1RRclh5Um9L?=
 =?utf-8?B?RlNJd3NnNy9HKzdIL1Izd3V3UHJCcTNJQmwwbkdDazdLYVRoYUdYcDVNTWlN?=
 =?utf-8?B?N0FKdGZWOVMvbEJJK1dON0pjcU50S1Q0dXYrS2RNYVhSMUpyNktCWmpvWHA2?=
 =?utf-8?B?Y3ZMckdObkwrclZYWUVmdmdscTZnU3U4TkprMGl5a29IMjdYOGx2UWdHb0RP?=
 =?utf-8?B?VTlqZ2RzOHBTVnZBUTl6eWJVajF2bEE0N0ErTlpjVzFUUW85ckNucjFHdWV6?=
 =?utf-8?B?aWVpVCsyZmI4TUZLZUNqOE1EYk9tV2dEUDFnYVFPaG5WL2tMd3Q1dHlWRXZG?=
 =?utf-8?B?bERKTFFkK3hzbi9aTE9UTXR1THl1YjR2T1lwUEY2SW9GTGNINmZON1F6ckp4?=
 =?utf-8?B?anY2ZWo5NFU1akRPTzl0b3dsanNheWI0djZqUE5MWGtvMkMxdjBoVHVMRkZP?=
 =?utf-8?B?S0VyZjlyTHdGbTFod0pSajhxbU1TZGVlRmhFVkV2bnNiVVNCbzg4Q2lKRkVu?=
 =?utf-8?B?cHB1NFhvazRlZHRvaGtrTnJzRWI3SVEwMHNuVVp6SUJwVFlxaTR2bEFQdFRG?=
 =?utf-8?B?QjltRlFPYnk0a1NOK1psQTFXUkdnYWpDZEE4ai8yaDMrb0cyWkc0RlpJRlNF?=
 =?utf-8?B?OUUyemFiWHJjQThUU1BFZmpLOE9TOWpNNFRoYVdSd1ZXblg3VHFHUzJoQ1B6?=
 =?utf-8?B?eXlxd3Y3WldNTUVLRjBtMGpPd1lRSUZ6YjlvZVljLzk1VEZKMlRpVWpVWVQw?=
 =?utf-8?B?SWRDU21iWEhDRWlYZUZJUkhOcnNIUFBhYm5vRzR0cWxxL3lTWVBSNGt4SzJO?=
 =?utf-8?B?WHBMNHlQWWdhd0N0WTBITVlMeU1wZ0lVR0JWTGV4YUpMdXpHZTBaNG1MWk03?=
 =?utf-8?B?RnhHVEZtL3RZNS80QituTHdERm5ZNEdOUENmZmdFY1JsWWhXeHpRdEZicW1T?=
 =?utf-8?B?eHgzcFBZUHd5ckRSaXhIUTMzQnk3QmRlSFBxeTQyeHBqejNHNmJwQXdWTXJP?=
 =?utf-8?B?WVkyVXlxWUhKcksvR1VLODMyUUppZWJyWVZrSlBKc3VYbFRNaUJ6YldGSTNl?=
 =?utf-8?B?aFUzMWtvY3BIckFqbStBT0YwTFloMFQzYUNYM2dJb1VnSnRnQUZXWnBQVEw3?=
 =?utf-8?B?ZnVLUUNiWEYyTEpTMFFreDh6T0RCblFsdWthODhtTmxUekxVNVNFSFAzc0sz?=
 =?utf-8?B?bm5IWEpSZk1ETS9WOUM1dFBEZnNUUEQyQnIvUEJuKzRtMm90cGszdi9wV1RC?=
 =?utf-8?B?Yk5tclgvZ0lFcTUzMlVoSDB1Uk5mQWc2V0h0UExkbUtGUzVTb29EankvTm9N?=
 =?utf-8?B?TjVZeEVSNlYrNzBrUVpiOGUwSkJRay9UdTBlcEVZQVAxbFN0WEs4d1ZUVHJp?=
 =?utf-8?B?VzJndHYvMzBqNDUybW5IUjRodk1YTm1QM2Q4ODB5ZUZyY2JzN3g1Q3RCTE42?=
 =?utf-8?B?akVjbWpoOXFQdkMxcjRxZnA3Z1Y0MUFIVDRmQkIrRlR3UndzTHdkcThrOUtS?=
 =?utf-8?B?ZEx6Mk55MWJIU1NLcXVwcWxqV3Ava2Y0eDdNTmRZcHRaYW9KOGM2VFhVN1c1?=
 =?utf-8?B?NmtwR0VxRG04K1RTRk0vM1R4bUJXVTY2ZmtGYUs4cmVrMkI5OVlkOVVMbzNS?=
 =?utf-8?B?b09SclE1WXhnd254dlFFNWJla1AvQXBkNWJDNHRmTURZTVNPMDM2dHptbldI?=
 =?utf-8?B?Rlg1NzZ5bmc4TzRYODYya2lnT2p5UFJpYnZJWmM4V0gyeW0wMmpTbU03OWU3?=
 =?utf-8?B?aFNTT3M3Zy9wY0F2VnY4dzFiNkNVa04xVHdQSU4xM0IxcnBrZFFnSFgySFlC?=
 =?utf-8?B?SkRYUlh0RFl5V3kzVG1tK3VDYWEwTkk5a2lFb2pLVXovUkYvQnJKSVdGNkZE?=
 =?utf-8?B?V3NVemUycHNaYWFzWjFkUGg2T0wzZEQyQlF1UUxINGdiN1BHMGJ1ekxwSlBx?=
 =?utf-8?Q?DDg1avJiAWI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b3hvdFBoL1RFZ0RLWTIyTUZJdHNHWGtTdURYWFJKdXRLcG1TckJhdFlUbjFh?=
 =?utf-8?B?SmE1TjBVcHU3MGtkb3VqRFltaGVkUzBnYUg1bjlGdStFbk1BK0hnVUIvTHpJ?=
 =?utf-8?B?V0lhTFJLUmZhSUh6WGdOdWdEZXRkcDhoM1E1YUp1WnE0cENvRnJuNlZhR1J3?=
 =?utf-8?B?RlNKWnp1L0dNY2xzTEFoQytBaStHSHA5QUlPNXA2NHpkQ2VFbzJDM0JHQis4?=
 =?utf-8?B?TmhoUmhHTDlqRFpkT3p2dXgrdThOUTk3NUtMdEVSR05VNllSR3hNYWY5R1g0?=
 =?utf-8?B?TytZMlhsZ2MrbUFVLzE0aUxRa0FaNXdqeENoZ2VqKzVEb24wWm5NNzZobm5Q?=
 =?utf-8?B?M2FONWhKd3VKSytTRHpramRpa2poajVNY0Fic2V5aCtJYi93d0Jzd0FGaXEr?=
 =?utf-8?B?b2VPZVVONzhMU0xOR0NGWGJIdFRjMS93TGhoWG9qaGF4anNlN2s4Ry8rYzhF?=
 =?utf-8?B?ZVpvOUwvN0JZcjZFREZMMTByRlBjVkVzVXhFYmZrcnZOYkMxRDM5U3BRVy9p?=
 =?utf-8?B?UGRLblVjY09oNTMzTGVTc2RrTGdBdTFtZGdjNzJCMGhJNEs1U0xrOS8xN1pq?=
 =?utf-8?B?TkR1VGljZ2x6eEk5cFp5SFQxT3Bka1JsYTE2NnBJYzhnMmRDTitFa1pUL0ZS?=
 =?utf-8?B?QjNIb3ByRnlvR0w1RTJOTzViWFNJcTQ5Rkdra0U2K01ZL1hTTGJMWENvSy9m?=
 =?utf-8?B?dmc0dkI4V3V3TDNKNXAzYVVlOVpSZVNLbVlpTk5UN1hOSHc3dU5sNkE1Y0sv?=
 =?utf-8?B?WC9hZEZiaHhFNWpQQ3FmdTR0UkpyZC81RFF1RnFqUTlncHNDQlNOaTc0NEZM?=
 =?utf-8?B?RVUxd28zRGdqVURoRkpsWWlIMkN5SlBEUURrVW95d2IyU1lvbmdwWk1LYjRV?=
 =?utf-8?B?RTZHdXhyd2JXaGVzRnh5ejBDSGtiQnBRMEJwNGwvN3RWSTVRU01uUUl3NVlr?=
 =?utf-8?B?ay9KaVVHbCtTdHprSDJnQkRwbkpFMjZjVW52QXFpRlgxSkhxL1ZIZC9GNTRm?=
 =?utf-8?B?dGxxdSt2SllOSkl1bkJxZ3kyeEJPNy91a3QrRlh1cEhJN3U5MHVyZTNvaDVr?=
 =?utf-8?B?RXV1TmdGTFhkZXVWOEl2VGNDQlMrdkx4VWlvY3daZTVURzdweldqK1dYVjVn?=
 =?utf-8?B?SmJjSDNHYk1kYnJiVWI1Y1hBOTB1b0xidWU5VUxDVy9IUHJ4cGpJaWNTS1Ez?=
 =?utf-8?B?NGZnWmFFR0kwbmYza24yS1ozMm4wR2dMcFhsY0pNakJ3ODBiamxpMHhGdXU5?=
 =?utf-8?B?NHZVd2ExYzBoSERzanF1UkYxdjA3TlR0MUthNHJIcHllbHV5ZGIvT1VTOHp4?=
 =?utf-8?B?QldtZlRUZzgrVTc3K1ZZUGNXS0o4WHZRbnA4Nmg0VjBMb1FxTGQ0Z1hoYjZM?=
 =?utf-8?B?Qk5qTTl0QVB6YkpVYmMyNEJPRkpjTFZqeFU0b25MMHBMb29SSjRhaWh2VTFY?=
 =?utf-8?B?NEtGd0I2RVBxVEtGcmVJUWVXRVhtdEF5SmxhL0F4aEJ5Qm4zRmxzNWdkTi90?=
 =?utf-8?B?K0k4aW5BMnRPZ0s5UFZsTEg1NUNkY0F0djJIckVQMFl6VWo4bGdLK0xZREhY?=
 =?utf-8?B?MUNFQ05qaWJyKzdrUm1RRDBhNnBSS1F6Q3hSSWdlNytIM0g2aEU4M2hhdGFj?=
 =?utf-8?B?ZHhoK3E5YzU4OWpjaUFEdUpvSGcxeDFpcmdLMWNqRXNpMDd4czAwWFBBS2Vh?=
 =?utf-8?B?VmJOMFg4UkNwTmYyaHdkZ3QrWHhyR0gyb3ZOWlRGejRHUm81enhUS3FyZ0gy?=
 =?utf-8?B?OHlYMXNYUW9GcUNucFRiSUdsMzYyN2EydllZUVFBTnFJSW1PeVpaN1RvWTZp?=
 =?utf-8?B?dkJGMzNXa0haWHJyMXl1MW1LN0s1eWcrTEhLNWRIbkdzYzVvdVpsaGZHM1Fq?=
 =?utf-8?B?NkdBY3ZuY0dIdGcvREhmTUg1N3ZpSHk3YUUxcjZ1N1ZodHhqUnBQdUZtTksv?=
 =?utf-8?B?S0k4VXdzVjF2QjFIQzVqTzd5OVhBWFcvVHZ3dXp3VmpMZkk0SzFVSWdaQVBz?=
 =?utf-8?B?TDRTdUVNV09reThRcngwUVR2TVRXNHFiVGlyNmtudzh1MjlMaWVDcnJiQ05F?=
 =?utf-8?B?VVErcU4yeXlDTURFZnNqMWVyaXB2eEFhcElaZDd0UzMwR0hVaDZLZkhFSlRL?=
 =?utf-8?Q?ndiB9F9nc3CndxvpK8PlObkU5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D3F766913DB5024EAB779C541ED4CF7E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdac989a-d2e5-468c-a61a-08dcc66942d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2024 07:24:17.4717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kOVOiTcKGY9BCaPcKCui3aG5Ojv4oTSbe7sH7m5LqpzmSZ//4xYfARWOW/PTAZkriHm7HGn7l9y/3zJg411u8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6966
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTIwIGF0IDIxOjM4ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggYi9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmgNCj4gPiBpbmRleCA4NjFkZGYyYzJlODguLjRiNDNlYjc3NGZmYSAx
MDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gPiArKysgYi9h
cmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmgNCj4gPiBAQCAtNDAsNiArNDAsMTAgQEANCj4gPiDC
oCNkZWZpbmUgTURfRklFTERfSURfVVBEQVRFX1ZFUlNJT04JCTB4MDgwMDAwMDEwMDAwMDAwNVVM
TA0KPiA+IMKgI2RlZmluZSBNRF9GSUVMRF9JRF9JTlRFUk5BTF9WRVJTSU9OCQkweDA4MDAwMDAx
MDAwMDAwMDZVTEwNCj4gPiDCoA0KPiA+IA0KPiA+IA0KPiA+IA0KPiA+ICsjZGVmaW5lIE1EX0ZJ
RUxEX0lEX05VTV9DTVJTCQkJMHg5MDAwMDAwMTAwMDAwMDAwVUxMDQo+ID4gKyNkZWZpbmUgTURf
RklFTERfSURfQ01SX0JBU0UwCQkJMHg5MDAwMDAwMzAwMDAwMDgwVUxMDQo+ID4gKyNkZWZpbmUg
TURfRklFTERfSURfQ01SX1NJWkUwCQkJMHg5MDAwMDAwMzAwMDAwMTAwVUxMDQo+IA0KPiBGb3Ig
c2NyaXB0ZWQgY2hlY2tpbmcgYWdhaW5zdCAiZ2xvYmFsX21ldGFkYXRhLmpzb24iIGl0IG1pZ2h0
IGJlIGJldHRlcg0KPiB0byBzdGljayB0byB0aGUgc2FtZSBmaWVsZCBuYW1lcyBlLmcuDQo+IA0K
PiAJTURfRklFTERfSURfQ01SX0JBU0UwIC0+IE1EX0ZJRUxEX0lEX0NNUl9CQVNFDQo+IA0KPiAN
Cg0KSSBlbmRlZCB1cCB3aXRoDQoNCiAgI2RlZmluZSBNRF9GSUVMRF9JRF9DTVJfQkFTRShfaSkJ
KDB4OTAwMDAwMDMwMDAwMDA4MFVMTCArICh1MTYpX2kpDQogICNkZWZpbmUgTURfRklFTERfSURf
Q01SX1NJWkUoX2kpCSgweDkwMDAwMDAzMDAwMDAxMDBVTEwgKyAodTE2KV9pKQ0KDQouLiBkdWUg
dG8gdGhleSBhcmUgYXJyYXlzIGFueXdheS4NCg==

