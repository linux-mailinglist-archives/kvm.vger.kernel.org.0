Return-Path: <kvm+bounces-54466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06381B21A2E
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 03:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C2513BED1A
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 01:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B402D780D;
	Tue, 12 Aug 2025 01:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HbQ7xhe0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570482CA8;
	Tue, 12 Aug 2025 01:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754962345; cv=fail; b=knbjenMDsN1M+9GQMiVzKIXeEEgKwHqauWVmXnhszlaFW5+Qwsg08wjmOSoFfah9jTzOz+UnbsLRT4AnVRwuSNGU8CY8UzQ4ZZweNK2J8OJMYGzBNT7hfXAVTSD/Brz63iT1U1/vc5sXRBXVGbAGT+HPOTUgKp3ZMI75ptsOfWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754962345; c=relaxed/simple;
	bh=ueLo00Y0Mi2bRdjhFiOsnGXcTh4PrpRaR7GFDnmw5rw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kOC0g8kDIuK1C8xhuUf/icxHJR12GJ6XUFDbAO1u3lr+rJsb26mZp4Q/c2nYG6w7xTWV0cYOSmiGR+t844asgGc/64sH2pOy6XbOaXIfgj7U8NyaKOzWdjp8gEG0RWy0LHmFWd9NTHXR4swTZD8bIgnI9Fgrx5d+U/uDjbxEY9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HbQ7xhe0; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754962345; x=1786498345;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ueLo00Y0Mi2bRdjhFiOsnGXcTh4PrpRaR7GFDnmw5rw=;
  b=HbQ7xhe0TAfRzfzb8c22upUCqc0b4Y5sVaiCuPUMKlnMImBla6XL88vT
   YH9XIACziVqTbBSAU9fS9xMho3dtB5XkqnD9mAhUutbWN6eQ3xSnwwoOD
   czntfmfk2BWiz6XRg2FGraSPYmX9zqmp+z3bH/FKUiwRlk02xeZGr8FcM
   sK7OBZpQ+leBlewQWalYIapmDmtjaFclWNcl1/p802MeSoyocjT/hvP6a
   xtKR4eD0VCiN6zh2f1m57Jv5sFZVAFoc96L27tBH6wONGcXMjSXjQeVWn
   vUK//I03cPyPEpA0DVlchWIz8t37/5HFnKUOUaXkRa3dqyQ1eQze2CaMj
   w==;
X-CSE-ConnectionGUID: SvZIF7VFRiu1t1THHhbrcA==
X-CSE-MsgGUID: sXFKoRUDR5+QFL5LxbyBFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="56943585"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="56943585"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 18:32:24 -0700
X-CSE-ConnectionGUID: ZjJH4jJ0RHmZkgXw/nfxGw==
X-CSE-MsgGUID: BPqEa2AhTamnrFZsmfFh1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171301938"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 18:32:23 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 18:32:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 18:32:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.75)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 18:32:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J8suTW5xbJ1kGWG+wHFIf+UYH9Rbq+S7w8mHmMgqK5Ay1LU8hQuzHDCC9dLb0bsBbUC++mvL7TE/iRAmcWNmalsIPAhhbJ/3Mx1ixHoHItxKd/VDi1wPTmIMfBl4Oe9asWHcaCfUqlxQ22mSIc9DP6ADSxkPi3uuQolxn72Ul+p6zrvHynawFyOSqvdP630xT/BawHEnMO049NDjAcAE1zZ0rWJsx1oAIOs4xCGmkCG0e+q+VAsXbPU7j2JVOfJ1NGASD59Xt2GIakczRuH1rEDdLwQG+3qwTzuPgbmKC4MPYkILAMAgBB/F+YW5Uh1kNpTLfe1Ym/2z5KtmqXGxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueLo00Y0Mi2bRdjhFiOsnGXcTh4PrpRaR7GFDnmw5rw=;
 b=gaKLK9x0a5Bx5rouOWaj35JOZoOKG+IHqtAeuxx/Ws4uF8K7IbLXRJ7HyU5OY8fOfRT20okFLgKNlMqG4ILTDfmcIYrukuVULuVKXa74C1Cj533htEhNhgFmKTYOkYn4ToLACU/WQCG3HKXjRAZ5cL64pgTYODgWswMmiqRN0dDtc+35vCaKMI0AWxLCZK6LWckC67yOggCb/XSVQ9x7cuYvrrNl//NdyEt1zMPWUFrkanYQtlCFe5rVOjCbyeP+G81PtqPwBvlOBg8A31dzmEYc47eX9EwfIDH7t9L9RsHkxOLaA5dug/k1zgtrdb2DZcxliK+GSs0jhr2YD8q/DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by DS0PR11MB8229.namprd11.prod.outlook.com (2603:10b6:8:15e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 01:32:20 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9009.017; Tue, 12 Aug 2025
 01:32:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v5 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb/7MLtHK6BqodHUKBqQjOH+Kz87ReRx4AgAALXIA=
Date: Tue, 12 Aug 2025 01:32:19 +0000
Message-ID: <05ed4105f5cf11a9dd0fa09f7f1ff647cc513bd5.camel@intel.com>
References: <cover.1753679792.git.kai.huang@intel.com>
		 <03d3eecaca3f7680aacc55549bb2bacdd85a048f.1753679792.git.kai.huang@intel.com>
	 <3bd5e7ff5756b80766553b5dfc28476aff1d0583.camel@intel.com>
In-Reply-To: <3bd5e7ff5756b80766553b5dfc28476aff1d0583.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|DS0PR11MB8229:EE_
x-ms-office365-filtering-correlation-id: 8a25ffaa-9cfa-4b16-13b2-08ddd9401464
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?QklRUVEzZ3VKMGdIUjArRExkMTJFZWpiOSs5SU1UdmJ1WUxPVWQ1ZTRMUE9Y?=
 =?utf-8?B?K0p2bjRuQ0JwQ0gwOG9aS053NzZxdmtsY09yYlYxWjFiOEJKeE5pdVVSSlZo?=
 =?utf-8?B?elMrWUMyQU1vRlJWWUJteFBuWDNaY21IUit2MUd3dmdxOVZUZk5QVDNSU2pJ?=
 =?utf-8?B?NkFtUFh4S0dVVzJTb3d3UnRVSzM4UUYvckRGbE9FaCsya09sUkVsYVprY0NN?=
 =?utf-8?B?L2tTbm91N3p3K3c4bC9PV1d0M2xoM2R0bXYvTTQxekZZREZBWXlZelA4ZDdk?=
 =?utf-8?B?MWFWMGtnMGliSHhuMENxWkN6REpCYmFOYk5OeUE5R1p1bnc1RkJ1MjNCMDVj?=
 =?utf-8?B?WDFGWVhWM3RhdGtvak5MODhlYXo4bW5zbTgvYWpnbjA4Q3NXMURONG9ISks4?=
 =?utf-8?B?bVUrUnFGY0ppdk5FY1pOKzh1Y3BjVTk3VVk0RzFiSHlFc29weTVPZWw4dW90?=
 =?utf-8?B?emg3aTlhVXlIN0hyTFZzbytJakU3bU5qUkl2QTZPTzdHSkhtdWdwRjhST2g4?=
 =?utf-8?B?dCtmRzF1cDFsS0d6bDc5Ti9NaDllUnkxbDlsV1RUbWRpUGJQSjNNS0xFSDBO?=
 =?utf-8?B?TmN5enBwZExnU3VJU0xsVFZnYk1zNW5KYW1ORHhubUtiMUpOMzQ1NVRvNlRH?=
 =?utf-8?B?eUx3c3YyR2o2NUVqQTR0N2V4cCt0cVRkZHUwczZBT01RYnNYanNSS0pFTXUy?=
 =?utf-8?B?QjBQM3hVZC9qWXBtUDBYZ3ZzQzVoOFgxbWRRL3hwbVl1YnpRTUpJckJ4N3Vk?=
 =?utf-8?B?b2g2T0hkZzQ1SGFkaVZabXdibjQvUS80TkwrSVBjYlhaRXMzZUp6NDF5NzFB?=
 =?utf-8?B?TDBlMHh5Z0xoY2xSaG5wRGZMZ04rK216WXl5dnBGYVJ6dlhEOXMxcWx6SFcw?=
 =?utf-8?B?ZEFVYTdDU3BxdXBwZ3FwdFlnZEp2RndNY3lpOW9JbEYybG1USmVEZlZ4K1NP?=
 =?utf-8?B?R3AvV0lwYjRhS3cvdWxTVDRNV2xlQjBIVlJibGx2czUvclBwVHhPUUd0dUpa?=
 =?utf-8?B?ZWpXR1ZPN3BZYVpjSGl4NCt3aGFwWHBXV0R5eDJzYkVtSkxNb1lyRDJhZXp0?=
 =?utf-8?B?WlFsQ2hIM3FMUmcwRUpkdmduVmFHOG4wZzBSQUc5SlNUVUJpSjNpOU5nK2dw?=
 =?utf-8?B?bldRT09LcmtjRnhrUGJISFlUc3BMM3VNTEo1OW9oV09GVXV4eWFFdWVyZVp2?=
 =?utf-8?B?WnhsT2d5M3YyWS9MN2o5VVlTaXd5OGNxa1RTZUszeHlKZ0tEUmp5VDA1enov?=
 =?utf-8?B?a1k4WHVwaGhsV0szb0RnZk5uTllNaFZKYXJ2MUhyYldhcVJwRWRDeEVsN095?=
 =?utf-8?B?Vzh3Ny96cG5ZQmVOSTgweUlGZVJ0ald3ODVUZWcvQ2d2SEtrUmJsdWdmcWl6?=
 =?utf-8?B?RTJIc2dwNkxKYTVsYVN6Q2VBdTIxYmlmSVhoMmhuZzNLQi9KM2hkS0dZT1pm?=
 =?utf-8?B?d2c1M3BmWGwzLzIyakM2SVpLRHdvU1VUNXQxeFN6L043MUNjU0IwOWZsQWly?=
 =?utf-8?B?a3N2cnJ4ZTMzbVdTV0ZiL0pvb1VyaEJQVk9qdXdmNCt6MWRWajFGZ0ZQMDl1?=
 =?utf-8?B?OEtiaCs1NUhlbnlMaEpwRXdSa0krbEg1SFMzV1J2dm0zOVRqb1gyR3ZTQklj?=
 =?utf-8?B?M0Y3WXYwVmtaSVAwTE9yeEsveGI1T2hDT1A3UkdvN1Mra0ZoWW0wSnJsU1Bn?=
 =?utf-8?B?TUsvNzNDbzFsRHgwY3pkQXlUUkhRS2oxTGNKVnQ5VzZYZHZNc2h6S2ZZSWZH?=
 =?utf-8?B?NXRIdk9xQnVNL2Z3dlh3akVRNDRNUENkbUJkWVg2ZlVHNzAvTzd2ZXMvbk5J?=
 =?utf-8?B?Zmw3WWZva05waEwyZ1h2cWx0OWhaaGFzZG1UVVJZN3NCZUNhZ2NPdGFBQVR1?=
 =?utf-8?B?SjFzbFBlTWt1eDk2YWxmV0JBbTc3UDNUOVNSNHkzWHRqcW5XT210Z1ExWjhL?=
 =?utf-8?B?M2pzNW5LRXRjaERsL1daTytDRTZWcnJWNTJaYjljY0tzcTJNeVBiQUo4dFp3?=
 =?utf-8?Q?y10kfbMG29ZOSUrx7SXPkSE8nr+2io=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bGlwbERWYkVFTkMyR1dJUkZxSVh5YWg1YkNtK2pxclNmd2NCT2FSR29FREpC?=
 =?utf-8?B?NWdVMjlFRFhySHg4dTdEMkd0b1pIWHN6Mkx2aHhTdjFKWTJ4ckFRL0pDT2Y5?=
 =?utf-8?B?OXAya3IrNWZyV295MDdRZVFkV0M4Q3RiaVdnRHBsZ1NyNndvNHRZY0NJdzJY?=
 =?utf-8?B?cW9udFpkM1VmVVdnZnNsUEtienVhYzVURUpCamd3dGdteElkRGU3RVBRSDli?=
 =?utf-8?B?RG9JeGprR21JWkVUb29wbHlHOENacG5XekUxZ3d0c1ljSVJ2NzdPMjV3Q0Ji?=
 =?utf-8?B?dDZFTTVXQ3FQcGwrTHJTZVhHbWFmRjF3blhZQXFBOWtNejQ0cHd2ckxKbHov?=
 =?utf-8?B?cXBLcmVkTnVNMHlsQ3dLZDRFK0lXQ2U4bUNNRnRnME5YREs2cDhBb3Q4Y1M5?=
 =?utf-8?B?VU5wWkFzU0tzSXUzSlQ5ZXRtYU9aR0djb2pwLzdrZkRINFExVzRGZFpidEMv?=
 =?utf-8?B?d28yanFVMy8yWnFDUjA1UXdQa0JRSkgwSGVuNTZvZDRSYmIyK1VFSnJ2SUhy?=
 =?utf-8?B?M3ZyWUx3R1VEZWlGdVAvTUY4ZkYwMm5YcS90Qlp4R2NIWW5TWG9vZEh6OGRK?=
 =?utf-8?B?ZkxrckFWd3dxck96NmtDVkkxUStFVmExNGdIZFd2empNalYrRVBPdFpKWVM1?=
 =?utf-8?B?eHZBa0xWSmtDWW15T0VZZzNXcjNBWVVORUhEQ3FKQmk5WlBTUFVkYWVscTVN?=
 =?utf-8?B?NmJRVlJRMFdtZVpiLzVqTEk0cmNjUkxzVVFzcVBrdm9ZZkxKY0l3a2Q4Q0VZ?=
 =?utf-8?B?ajRZd2RBL1EzblBqaTF2YnZLSnA3aXlTcEZDYmVmQVdVdlhyQjRCYnZ6QzhH?=
 =?utf-8?B?SnV4RUkyTlR3UUc5dkJTWWMyMkZVQm9kOFJFTWxTS3BjZlpGVzJCcm5NT0ox?=
 =?utf-8?B?VXN5V3BBd29VaTVuUENrVnRwNE13NnZyU08xRGpBb3IxMXMyTE1NVW9YSjNm?=
 =?utf-8?B?SWRiTmJNdDA3djZkRTMxQ3Y5V1IwOWh5T1JtOGkra1owUXhrc3psNWJUNU81?=
 =?utf-8?B?L1FncmZ3N2VRbnQ4NStTUEE0OEhqSGFXYkQwNm4wUjRKaExiS0ZyeHY4Z3B2?=
 =?utf-8?B?R2J1dHRCNnI3ZEo3eTRNZytDZDRjNHIrZCtUTHRncHZXQkhGNFVDV2JJUWJT?=
 =?utf-8?B?SDhQQ2drNlhmRmpMRlhYS1Nqa0xoYXdGazIyOER6M2hXTFFrUitkL3hpM05K?=
 =?utf-8?B?enI4WlNNNU5ERGRMUjJmRy9QbVJwYmg4Q2N3TXNFSDZPcHNkUnhWNzllaEJy?=
 =?utf-8?B?M2l1ZTFjNzZsa3c0eHcrdC8xTGlCN1pFVFAxQ0ZnejNFdUlYcHBkTDhOMjM0?=
 =?utf-8?B?ZVFJYjZ1M0VZeitwdXM4ZWdvdVZGM0xPRnRJNDJpbkQwN3dVREJaZWY2bXNS?=
 =?utf-8?B?bXdUSXFIR01qenNzK2tuYWk3TE9rY1Y4L2kraUdPUlhYMmJURlN6VUpYd2ti?=
 =?utf-8?B?QkhRUmZJSjNWWVlrbUdja0FIektZa2ZkY3dKNjUxK09tODFBNFdvWTk5cUFv?=
 =?utf-8?B?TXY1OFNrK3JPZ1VsTkZ4WXh2WFZwMGxvaU52WjRzVDdKUW0xVjMxalJ6M2xS?=
 =?utf-8?B?ZzlLVDNRUWFRTTFmMlhRaEw4SjQrbDJRL2FFYUxEQkdUckwyS1VpM1RwZWJ0?=
 =?utf-8?B?dmQrVVVFN1kxZnlCTjJDQ2dzdEJ6MlZ0ZEl3bWt6QWpYajM4NUlOL0VsZlN4?=
 =?utf-8?B?T0NRSitqc2djTGczMjNJMS8zTXUzZlg5L1JPcWdid2ZrajNxRzc4TDNROWxk?=
 =?utf-8?B?WlZqMzMyR1BsTDI4anNuK0t5bmxCOFVYL3hvN2E0QzFXSzd6em1Lb2RoMGpV?=
 =?utf-8?B?SUE1WnVGUzNFSDI0c3pWaHRGamVOcVVsUFZNbUdoVUtZdm1PUW95ZFk3bDlL?=
 =?utf-8?B?NitYdnZzZUc4RnpDdFNRTjVCTGRBNG13V0IzT2ZTR3BMYXY2cmtuS3BOdnVY?=
 =?utf-8?B?YlhnNDBQY2k0VlltMmJqVERNbG1KbDFaUFB6dVo4WDZvcXdoUGVlMFhzZSs4?=
 =?utf-8?B?eHowL2JsZi9JMHBhWWxGNWIrcjNDVkkzRW5tK1JmNGxTWlNTejAvTDdBamFk?=
 =?utf-8?B?NUxKbEhvTWF6N1EwOWhEcGZLNlZ1REtYa3hMUXdjaktXY0M3L3pUcm9qcGxM?=
 =?utf-8?Q?omPj3NcshIHJqX5ns7KIAD/BY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD3AA25F82D20F45AC5F3861E7E24356@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a25ffaa-9cfa-4b16-13b2-08ddd9401464
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2025 01:32:19.9610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WfYi+7ISRQBtNtJcrKlBvjkHbaQBl7Mv8sfRr1kl9c0VF3H0pEDxPgKz8Vqb8vJIWgfCbWIsTFjTo/5Exzztsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8229
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTEyIGF0IDAwOjUxICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVHVlLCAyMDI1LTA3LTI5IGF0IDAwOjI4ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6
DQo+ID4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUgdTY0IGRvX3NlYW1jYWxsKHNjX2Z1bmNfdCBm
dW5jLCB1NjQgZm4sDQo+ID4gKwkJCQnCoMKgwqDCoMKgwqAgc3RydWN0IHRkeF9tb2R1bGVfYXJn
cyAqYXJncykNCj4gPiArew0KPiA+ICsJbG9ja2RlcF9hc3NlcnRfcHJlZW1wdGlvbl9kaXNhYmxl
ZCgpOw0KPiA+ICsNCj4gPiArCS8qDQo+ID4gKwkgKiBTRUFNQ0FMTHMgYXJlIG1hZGUgdG8gdGhl
IFREWCBtb2R1bGUgYW5kIGNhbiBnZW5lcmF0ZSBkaXJ0eQ0KPiA+ICsJICogY2FjaGVsaW5lcyBv
ZiBURFggcHJpdmF0ZSBtZW1vcnkuwqAgTWFyayBjYWNoZSBzdGF0ZSBpbmNvaGVyZW50DQo+ID4g
KwkgKiBzbyB0aGF0IHRoZSBjYWNoZSBjYW4gYmUgZmx1c2hlZCBkdXJpbmcga2V4ZWMuDQo+ID4g
KwkgKg0KPiA+ICsJICogVGhpcyBuZWVkcyB0byBiZSBkb25lIGJlZm9yZSBhY3R1YWxseSBtYWtp
bmcgdGhlIFNFQU1DQUxMLA0KPiA+ICsJICogYmVjYXVzZSBrZXhlYy1pbmcgQ1BVIGNvdWxkIHNl
bmQgTk1JIHRvIHN0b3AgcmVtb3RlIENQVXMsDQo+ID4gKwkgKiBpbiB3aGljaCBjYXNlIGV2ZW4g
ZGlzYWJsaW5nIElSUSB3b24ndCBoZWxwIGhlcmUuDQo+ID4gKwkgKi8NCj4gPiArCXRoaXNfY3B1
X3dyaXRlKGNhY2hlX3N0YXRlX2luY29oZXJlbnQsIHRydWUpOw0KPiA+ICsNCj4gPiArCXJldHVy
biBmdW5jKGZuLCBhcmdzKTsNCj4gPiArfQ0KPiA+ICsNCj4gDQo+IA0KPiBGdW5jdGlvbmFsbHkg
aXQgbG9va3MgZ29vZCBub3csIGJ1dCBJIHN0aWxsIHRoaW5rIHRoZSBjaGFpbiBvZiBuYW1lcyBp
cyBub3QNCj4gYWNjZXB0YWJsZToNCj4gDQo+IHNlYW1jYWxsKCkNCj4gCXNjX3JldHJ5KCkNCj4g
CQlkb19zZWFtY2FsbCgpDQo+IAkJCV9fc2VhbWNhbGwoKQ0KPiANCj4gc2NfcmV0cnkoKSBpcyB0
aGUgb25seSBvbmUgd2l0aCBhIGhpbnQgb2Ygd2hhdCBpcyBkaWZmZXJlbnQgYWJvdXQgaXQsIGJ1
dCBpdA0KPiByYW5kb21seSB1c2VzIHNjIGFiYnJldmlhdGlvbiBpbnN0ZWFkIG9mIHNlYW1jYWxs
LiBUaGF0IGlzIGFuIGV4aXN0aW5nIHRoaW5nLg0KPiBCdXQgdGhlIGFkZGl0aW9uYWwgb25lIHNo
b3VsZCBiZSBuYW1lZCB3aXRoIHNvbWV0aGluZyBhYm91dCB0aGUgY2FjaGUgcGFydCB0aGF0DQo+
IGl0IGRvZXMsIGxpa2Ugc2VhbWNhbGxfZGlydHlfY2FjaGUoKSBvciBzb21ldGhpbmcuICJkb19z
ZWFtY2FsbCgpIiB0ZWxscyB0aGUNCj4gcmVhZGVyIG5vdGhpbmcuDQoNCk9LLiBJJ2xsIGNoYW5n
ZSBkb19zZWFtY2FsbCgpIHRvIHNlYW1jYWxsX2RpcnR5X2NhY2hlKCkuDQoNCklzIHRoZXJlIGFu
eXRoaW5nIGVsc2UgSSBjYW4gaW1wcm92ZT8gIE90aGVyd2lzZSBJIHBsYW4gdG8gc2VuZCBvdXQg
djYNCnNvb24uDQo=

