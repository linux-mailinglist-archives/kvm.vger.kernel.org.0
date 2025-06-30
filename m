Return-Path: <kvm+bounces-51091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56955AEDA98
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 13:16:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 598ED189929D
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 11:16:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F094235056;
	Mon, 30 Jun 2025 11:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rctlz78k"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657E91B0435;
	Mon, 30 Jun 2025 11:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751282188; cv=fail; b=hT5g1u3sVBTZw3iCEgvJ5Pe+c1wQHHgeFXS6BuOQ6xaciY4BPbl03a3pOdunIQkLgHkkuVVLAelVCGuh5iqdX7AivX1lBjuhjoRsiN1+9ENlrF+nAsGQqPTTs4g9jVNwVDv0wYOdeGtg8OMCaz7M34EfG5rFoWYjYlAVPQzYjko=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751282188; c=relaxed/simple;
	bh=MJxfwWWAVcqerCD2SLfJjKH89uw1VI0sPvO+C3s7tXg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mu8oY1KhXfbesCePJSoYD+UZaqID+WLebPrzK0anoEIWM/GCccr4NfPGKOgjswDebZAFi5A5ik5XuVjM6TIuft11IAtEYZa3C44kiK323VM+qWwSpsDjjbfbaa3MqfvQChY7/OuckHUJjYwF6vdoXiZKnjRqv82gnyt6aCQ1B1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rctlz78k; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751282187; x=1782818187;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MJxfwWWAVcqerCD2SLfJjKH89uw1VI0sPvO+C3s7tXg=;
  b=Rctlz78kJw81c6hs7ihRGbMeC/hIzfFNTc5JxKle9+rXrHSnICPoc4Ve
   THSkOIyM40DUpi1H2ycLJTUcUCCTyaPyXGOemUgVXBE4mu+DY+8t7mT38
   XDVQY4ltHHQtUc5KRilu3hzSKpF2V6hlHwDfhL2iONfp4Qa8tLUwcGnvL
   1CctJM+lbnUqUNHlwt+50Sg2cf2YqEZC9s3DS2+WxcyPYnLGLGTFZodKr
   /zBAicSqrzTtl36S2qHSCd2+6CqaFY5ZMrApYo3ZFTtp033yaPKSyobpd
   nwdLkiAHL0RJFOw6QJi3PT1iWJp59RruRvsw1YWh99nf6RoJYj0vV+kFg
   w==;
X-CSE-ConnectionGUID: H1Yf+5I+QIm4fLfu6nsDyw==
X-CSE-MsgGUID: WRpn5P6sT16ZpKEuHH7XWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11479"; a="53366120"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="53366120"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 04:16:05 -0700
X-CSE-ConnectionGUID: r1cW36JxTjOYqUX63sR68w==
X-CSE-MsgGUID: DMQmPiiQSF+7/ETwe07vjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="158940806"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 04:16:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 04:16:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 04:16:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.61)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 04:16:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdGcQ++VQlJ4CeF4F+zo+34Y3PSNWBiTiH0r58AN+AITLAkiS0tOieWfT3fS7WO+4HF9/9xUrCwELONEipkyZxcGG121Fq59yr71xJt1/SicE7LYKsXC7pIlHD0RPZz6eqgw25NH5TmKVl2LzjYRwTQXpnucBVvkuGpa2hoT6d0ieKAgjlhcsUSG3lDluOr+USXm1fmpbjiN98oRFCOAZb3ZrAHWXJmRwLWXETndOLagKUXbScRRb2+pQrGfPdmYWTSA08C+KFKWWwCGUp7pHJi3eHHK7qx2tSD42KJAtViFmCQ9Z223Lr3ye4Q9hBVeo4Q/cirsi47dtu42CY+Ckg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2h9Jhd/FELdBM82sIHfv+u32sUayABziLvGHPOQo/W4=;
 b=vbmIAXSVRCypiGogQ/UF4khZKd3scARhzTCzkxPV20hwP4MZfkIwV8+nhGznHCndA/NOjFfNgD/F8VZO7zwL3zyeUKGq0UkjahArInsBzw1+F2RVAtRELPsqFKDuwfOb08EZU0BzVjGfXirFOc6v9WYoU9jWJuOL+PyQxVhwLcPZCV++qO6keeUU+vqvVxw0gOdHpl0gDECm/FENEXSRSLlSjVJ29ZvtldRxNVqKDkdreXVy9IdxR3MpgrpISpNJZn3mlR5k3R54iW5QxUuwRUmbNwdw4rNkj4d841x3jWwRnBVFjoL8ifsrDK4abglGS3vWecuBHQ4gYobmABG6XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6037.namprd11.prod.outlook.com (2603:10b6:8:74::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8880.30; Mon, 30 Jun 2025 11:16:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8880.027; Mon, 30 Jun 2025
 11:16:00 +0000
Date: Mon, 30 Jun 2025 19:13:23 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "tabba@google.com" <tabba@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Li,
 Zhiquan1" <zhiquan1.li@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
 <a3cace55ee878fefc50c68bb2b1fa38851a67dd8.camel@intel.com>
 <diqzms9vju5j.fsf@ackerleytng-ctop.c.googlers.com>
 <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SG2PR06CA0196.apcprd06.prod.outlook.com (2603:1096:4:1::28)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6037:EE_
X-MS-Office365-Filtering-Correlation-Id: 88c5ad9c-384e-4e4e-1a44-08ddb7c77e38
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?9ew5HPAsSFCK1R8+HPYzQlZKqd8ALzN2eVoDZBZ0VR9M9ckO//VpAR/8DBrh?=
 =?us-ascii?Q?MQqqZhCP7TJbgsYlmRwyadJYDdrowIMP7C7SvAjI14arDjosrGV1R10rDjJp?=
 =?us-ascii?Q?d71HOvHUY0GyfptYbYyQLr9h+NE57zL3O1Isroj2+jwuqu4yPdvktWJtPrZ6?=
 =?us-ascii?Q?YxRpbjq7KorgY973xfWwi2iR735YNW/EyrnVe2Gz5QXC1kVOIIEhmEAPuHBh?=
 =?us-ascii?Q?sP8/9kb1CsVFQEu23AFleW8zsDJSMWeCzNEwz/QLw+TBizC+7KqRopBh6e4R?=
 =?us-ascii?Q?io63KW9UWx3tOtbbkFJpuubqGD8hmyNn9msOEpC6rBTsFSUoOVIXsL4zwR8E?=
 =?us-ascii?Q?uU003V2FK6B0n1YaQMcpLMDWiHgIo79wp8MgqersumgY2MAKy/C6iMntidvL?=
 =?us-ascii?Q?CgC3mhqJQK2vm0MLwv5kah4/3alzxmu7Yg3FJZcOJ3Yr3LsxdXy/RAxoWYem?=
 =?us-ascii?Q?niOhI6WGVBUKkt+or2NieSv6SUkt+QQ1ggc02oDhXDqo2LEC51pVwRUSITAG?=
 =?us-ascii?Q?5QzyBYyjPq07oMrsRFLoI8hCw2Swm1ohfUlPCbN5n3d57bn2nocmDdsGZuFD?=
 =?us-ascii?Q?Q1mJgTMPVPwvODEMQJi+JNRa4FvbzSBizph6HVBcpWDadyfHe7uI2FUrrIcl?=
 =?us-ascii?Q?By9kB3sJkHWkHxUrDa/Ig+gVPvLraWhK3Qb5FeS+RIIGkWpbEQyBvnwuAlYf?=
 =?us-ascii?Q?YBI+fnUXxW/if/jhG/Er57weL2UQ7vBjxgkE649DNoXZ/MUbyFuHmQqTVAih?=
 =?us-ascii?Q?309ty6JpJAb+oAxnnrqIeTQGTfNpAGR9wS0NjFSX2CKB/VwBuOGYcn9NI1xA?=
 =?us-ascii?Q?B6hQKpOIzWeXyhgdcCNaBRb1cruVv5onEe5fvn6lX4mNZ29/rWob6Hgy9Itk?=
 =?us-ascii?Q?rMhqWU3ir4fNpoTCpAqx8jncSn+CGiL5L1h0PBIexo99k+0foKelPa/osk2g?=
 =?us-ascii?Q?MbavvMiu89ddChlJrWO7X15g9fmSCoFWV3hzllKp2sQz2KwrEKgcgu3NwB5T?=
 =?us-ascii?Q?zM2SNQGGVAslM83ljnzo3jE8GSwvFeuN5Gbc+h4Fhl49GA/1j96xfUyjp4/u?=
 =?us-ascii?Q?3aAwy0H6NKgb3KV399ccfomsrPqxTlwet6qMTxJrF14GCoJHRghx7UIH6XWd?=
 =?us-ascii?Q?hkDte5KdrdeYrOTFLZLxOoUapjiX11c5GzFH1o2giwsl6o1DCQ0XYECX75JO?=
 =?us-ascii?Q?h2khlApfEh/WUscsetsEr36MKk3QgNW57Iw1JgC8aaD7ZQ1CJ6s5DG4sMO7V?=
 =?us-ascii?Q?lPH8lf1eCNII/DzBHHC5n81l1CxJPRxbuNqExxT3qMXH1EoBj7dQuUZLpZuM?=
 =?us-ascii?Q?RIeu0Bweqz6Lkog4ZETeOn/+WNC9HOyrOnFfGtQnwxnZghtnwY9UJMqudDxu?=
 =?us-ascii?Q?ku89Cgj+apT0KSfLFKnhHFs9uCL5sqx3V2iFaYzt7V4YEwMqlw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JXFx0O/1f+7XjBvKYb+nlkE/K0GS/XC5fb7bZG6TLXQ7pM3UD0HauDWZiYwp?=
 =?us-ascii?Q?riDUIOZxJUTVDRqSANpXkg6y6i0xCJ4r5/At5Fy0OFIkNi5v395GXHHvYPXh?=
 =?us-ascii?Q?94Wdu32Pc/gTLvfVX77JscP/ADzdUczeJmTce+Xe15L1P4l+OqKQbCbF47pi?=
 =?us-ascii?Q?2I1uhM7M2fe1yvd6nKIqutdXosmhWam2cf2VVSZiXMk8tQzqUGoCoUVTY3h/?=
 =?us-ascii?Q?2hOTf2EtUmlzh5ONAxl/6zYsx1KJAzdZaZHv0pmcxb1u8DHkeT7xJOzKZlaN?=
 =?us-ascii?Q?aH0074jZj6xGAXdHq/+GiDwYTriyv9DrPX/ky2Sq+tCM8WPNNxeHpDcptYZI?=
 =?us-ascii?Q?GgcNS/l9cQvpvBh35qP+IZuACa6gicLgYM45X67Qzrk9O+g0UBnCk3drFtkm?=
 =?us-ascii?Q?05eO4v58hnsI4qzgKohGU8wKhIDVWnx58ZX2gBJD0tR3Vq5I5Ixdp1fazEkG?=
 =?us-ascii?Q?/U+VHfnZFnPGETsOKSpvntQlS1dePaIbIvND3XC3PoWBw1C/mP14Q3WVWFn5?=
 =?us-ascii?Q?2/r8MDPUPHBTz/eZ0opSGVvDwjadYbNapIEI0gX/zkiWCmfkZHdb+VEJJaDH?=
 =?us-ascii?Q?8IGCU0uAiv79g86AkZX09IVdRvUajv8fsgsAwTWBI3WTYMJ0jH5k7AlnsQM4?=
 =?us-ascii?Q?7P/7j6GxN276R3uW7zs86LxKJ32ad/Lu4jS1M7z6lygynuylsotjzt0JiJ/u?=
 =?us-ascii?Q?ZN7p6TULnjh5lFFnvD4lgEwuJ8ws1KizEMUhyoe0InfUYJaUd+CBNpwS6hUf?=
 =?us-ascii?Q?I6lOf+rQw2tDqkn35u6CYWPwf9Ay6arDyb27IeY5hrluBma90mEkb98+vImm?=
 =?us-ascii?Q?WmjspMcm/Vhq+ZVg7JwtW8eZXhmHXYv7f27hOBebwEwDvdbyvf2Gyo37ga9W?=
 =?us-ascii?Q?GdywHYe+SiKb4yDcl5py1INkNFuskIO7GdSs+edB9ioiAobQLbYjboVbW6sd?=
 =?us-ascii?Q?aF39brQyv2kz7QGUxSNIuCeqO3HZq0Gu0o3oJsu/xLqhz5xiuXBZ+M7StBbh?=
 =?us-ascii?Q?8mVR9vBaloNq0HQzOBW/8Djbi1LwLX7Gi08ZdKUnsH+fdlCrZTcPJEpSDd12?=
 =?us-ascii?Q?PtmT8Yjqb1GVl90DpTbQoSTFaVcAzFDTDww9JfgcUyFERBFz3SCZrfbwt0YB?=
 =?us-ascii?Q?BVz6ZjcyzD0PumNRaA1MicGEumEdoow9kbggbjT6L06nZBdZ3izhshTHe9xe?=
 =?us-ascii?Q?cpS4L8gc8M60CVlrXzfp1qqwwVV+wEW8cVbNTI1Oy468LIjoI1DUYKIMtdYk?=
 =?us-ascii?Q?cyApZaVQDgH0bIwuI1AbSv2zSzjWz9Tf51frlZltSoWT/Yo5G53Qj4E8JYz/?=
 =?us-ascii?Q?3s7BdE/WhnjtEDeWDdavluqEVWuuZiPhuWsIoeLkRqYvr2AbfaFrIcBAOBqm?=
 =?us-ascii?Q?ePm0W9ba8BMuI3PHe0DQ52QQovD2hVJ8eVv5AzSJ/1xG72a5FqfCB5LVpbc8?=
 =?us-ascii?Q?G4tHaiKNch5Djh3csuFuN5Ph4lVJFZYCZ0ekJcPDa6PFlBJFPz9y2O3zTnVM?=
 =?us-ascii?Q?X4Rlapsm/ogYpQTuZBlcpeV/6kHOSgh9lfCH0jxeqpOy3DN5YZ//GVZY4ieB?=
 =?us-ascii?Q?2pvgBASaxfCx7RD9BfGbHpbBDEPWlK31EMyajn/g?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88c5ad9c-384e-4e4e-1a44-08ddb7c77e38
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 11:16:00.2556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H2blGRIeg/XPRBN0MFc5dF7S6fj+yvmllxqTWHFJOWyVy3TweMOv2PHBKimZfJo2WyGKUubv2phvu7a4GbE3gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6037
X-OriginatorOrg: intel.com

On Fri, Jun 27, 2025 at 10:59:47AM -0700, Ackerley Tng wrote:
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
> 
> > On Thu, 2025-06-26 at 18:16 +0300, Shutemov, Kirill wrote:
> >> > > Please see my reply to Yan, I'm hoping y'all will agree to something
> >> > > between option f/g instead.
> >> > 
> >> > I'm not sure about the HWPoison approach, but I'm not totally against it. My
> >> > bias is that all the MM concepts are tightly interlinked. If may fit
> >> > perfectly,
> >> > but every new use needs to be checked for how fits in with the other MM
> >> > users of
> >> > it. Every time I've decided a page flag was the perfect solution to my
> >> > problem,
> >> > I got informed otherwise. Let me try to flag Kirill to this discussion. He
> >> > might
> >> > have some insights.
> >> 
> >> We chatted with Rick about this.
> >> 
> >> If I understand correctly, we are discussing the situation where the TDX
> >> module failed to return a page to the kernel.
> >> 
> >> I think it is reasonable to use HWPoison for this case. We cannot
> >> guarantee that we will read back whatever we write to the page. TDX module
> >> has creative ways to corrupt it. 
> >> 
> >> The memory is no longer functioning as memory. It matches the definition
> >> of HWPoison quite closely.
> >
> > ok! Lets go f/g. Unless Yan objects.
I'm ok with f/g. But I have two implementation specific questions:

1. How to set the HWPoison bit in TDX?
2. Should we set this bit for non-guest-memfd pages (e.g. for S-EPT pages) ?

TDX can't invoke memory_failure() on error of removing guest private pages or
S-EPT pages, because holding write mmu_lock is regarded as in atomic context.
As there's a mutex in memory_failure(),
"BUG: sleeping function called from invalid context at kernel/locking/mutex.c"
will be printed.

If TDX invokes memory_failure_queue() instead, looks guest_memfd can invoke
memory_failure_queue_kick() to ensure HWPoison bit is set timely.
But which component could invoke memory_failure_queue_kick() for S-EPT pages?
KVM?


> Follow up as I think about this more: Perhaps we don't need to check for
> HWpoison (or TDX unmap errors) on conversion.
Hmm, yes. HWPoision bit is checked in  __kvm_gmem_get_pfn() and __do_fault().
Looks we don't need to check it on conversion for the purpose of disallowing
shared memory access.

My previous mail was based on another bit and I was not aware of the check of
HWPoison in __do_fault().

The conversion will be successful without checking HWPoision during conversion,
with error log "MCE: Killing ... due to hardware memory corruption fault at ..."
though.

> On a high level, we don't need to check for HWpoison because conversion
> is about changing memory metadata, as in memory privacy status and
> struct folio sizes, and not touching memory contents at all. HWpoison
> means the memory and its contents shouldn't be used.
> 
> Specifically for private-to-shared conversions where the TDX unmap error
> can happen, we will
> 
> 1. HWpoison the page
> 2. Bug the TD
> 
> This falsely successful conversion means the host (guest_memfd) will
> think the memory is shared while it may still be mapped in Secure-EPTs.
> 
> I think that is okay because the only existing user (TD) stops using
> that memory, and no future users can use the memory:
> 
> 1. The TD will be bugged by then. A non-running TD cannot touch memory
>    that had the error on unmapping.
> 
> 2. The page was not mapped into host page tables (since it was
>    private). Even if it were mapped, it will be unmapped from host page
>    tables (host page table unmaps don't fail). If the host tries to
>    touch the memory, on the next fault, core-mm would notice that the
>    page is poisoned and not fault it in.
> 
> By the way, when we "bug the TD", can we assume that ALL vCPUs, not just
> the one that is did the failed unmap will stop running?
Right. All the vCPUs will be kicked out of non-root mode after "bug the VM".

> I guess even if the other vCPUs don't stop running, the TDs vCPUs will
> access the page as shared thinking the conversion succeeded and keep
> hitting #VEs. If the TD accesses the page as private, it's fine since
> the page was not unmapped from Secure-EPTs due to the unmap failure and
> the host cannot write to it (host will see HWpoison on next fault) and
> so there's no host crash and doesn't defeat the purpose of guest_memfd.
> 
> If the guest_memfd with a HWpoisoned page is linked to a new, runnable
> TD, the new TD would need to fault in the page as private. When it tries
> to fault in the page to the new TD, it will hit the HWpoison and
> userspace will get to know about the HWpoison.
I'm Ok with just checking HWPosion on the next fault or dequeue of hugetlb.

> Yan, Rick, let me know what you think of this!

