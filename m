Return-Path: <kvm+bounces-32492-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF1FC9D9166
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 06:38:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F0F52872EE
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 05:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191EC16C850;
	Tue, 26 Nov 2024 05:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oAaqCg+c"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E5828FF;
	Tue, 26 Nov 2024 05:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732599478; cv=fail; b=eIxWYS8hRev10cWgEgdnk2BRzwxg7QJ3PIpVL34mpfbGukgOzZ/NSLbtbmkDQ865dZIwvqAU6/q+/JE418Ib+pJ9iMr5N0+TGfkKHE/J8p5Hp+t+O3tfjvM4bAqhyKt4cShYkrjjuCuRhvAsjbGXNrDxkoCFkCUVyOkWCt7T108=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732599478; c=relaxed/simple;
	bh=GAvF6nreiSF4oIru/l1gi38wqbgWZxYCSmTPHRLIcEQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kYSck2M9jvq6IegbY39rHn+aM0FbHMRjxysybyYQVGQ0BrO0wCHU98ZMelGOkZndrzHaIoun5TiksLmqsCMiGgRab3K+kkzNcNek0Eu3B89TlRvFH9+eHYLgo7GW3aKxADw3Zv5nrolOffR5AD9PhnNFi73uUlXNIvVu7IctNrE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oAaqCg+c; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732599476; x=1764135476;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GAvF6nreiSF4oIru/l1gi38wqbgWZxYCSmTPHRLIcEQ=;
  b=oAaqCg+cQ9dZb97Fg56/hJG23c3aXvrs/aVNd8t8PGg8oPoQRR0cJ/tE
   qRMJoWX4h9mN1E5Xvawgy5C7LtbG4CQN6cfh4P+M9eTQ36G0myy1P3N+t
   Ng+QU3lctN7Y0IyVZpna/TMI95aG8vpYX6v0xL64qC+K4v8BlHokIfs37
   GPpiz4wY54+uEEwkXLv/gHZyIkWu8kgaycG+eVa2MBazNDAQwwxX5RaYu
   5TfTfdnMizAvDUNYRKTcHAWhblCeH7E58dLXho5DlPvaV7vHy3ty1MX2i
   VtfOOS/nM5M8L7HcE9YbUA7mcAhEvbPrGRmfnMqBxaSRX+d/vZ1ftpws/
   Q==;
X-CSE-ConnectionGUID: brSgGyUERL6pCjVSBwhf2w==
X-CSE-MsgGUID: paQC0ULBTFu5etsktkZKRA==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43401228"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="43401228"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 21:37:56 -0800
X-CSE-ConnectionGUID: uJcB95ogTu2iiLfRwspB/w==
X-CSE-MsgGUID: 5eaI+wb8SU63E9rMuyb+jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="95925332"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Nov 2024 21:37:55 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 25 Nov 2024 21:37:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 25 Nov 2024 21:37:55 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 25 Nov 2024 21:37:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ef9+/t/IFTUp3DMDDvL1rlXkokJ4lhxtGO4nihU6soG39vrI6OSyAE5zhma8zr/JUgDoRwQFfQctVXdG7IKafhjs4UzQwv7Kxz2WGA7V2f9L8GVTKwm8suyb0RoycdpS0ROor0l8ku2GazMfldE/iLX8LMZBHb8Ebi8tJ99t7CP/sSz+DeTcT7xqguTIqJB8bvUX5b0k3XEiDBTQzMpk/Bk7bJl5etamLOz28+7AWFZ8m9KRcIiYn/lXyKWnBUuq+hO50LutMl4e4/UAfEuewxMcGWONL7q4M/3cX8oXe1lsTMIOOz0tEkTd2MilHJzZtc4OyIq7qTTkN8QNeVW9Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GAvF6nreiSF4oIru/l1gi38wqbgWZxYCSmTPHRLIcEQ=;
 b=Zq1RIW/FoBkdo0IUlmKmwxjX4jDO+su0a4gZMT52bVr/t555TEZgk454ll+c/6c2dEivGMFMrJnzh87B0P3On7hzOlyRL1iNan1oGc9WrCb1gZFLKxLeoNWudezyVc6cVqV7TZJwQG/dSZUV6AsPiVkgRDv7tTRboqBFdqfv9MIDmRLQc2VF8vuoSxcrg5YmJhmP7UkI5K7YZRuNqUFlsSW2yiXg5qmIrRiDE3L3nzQokGAQfKM5OoALSXrmyXR1mNFn77wZMtiWpIAJ+WJ1XCCyXehgPtPBHsFv5/ZWPd+uBlwGsXp2JAX/Z95jIEKl4ogjwcu01KZfEwgeKMqzuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6756.namprd11.prod.outlook.com (2603:10b6:510:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Tue, 26 Nov
 2024 05:37:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.018; Tue, 26 Nov 2024
 05:37:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Li, Xin3" <xin3.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Thread-Topic: [PATCH 0/7] KVM: TDX: TD vcpu enter/exit
Thread-Index: AQHbPFIlIBknYlpwZEWiEupj6OInArLHOU8AgADo4YCAAEuvAIAAMrkAgAAwOQCAACOiAIAAGzWAgAACV4A=
Date: Tue, 26 Nov 2024 05:37:51 +0000
Message-ID: <20374e3651cd61b7c25d13cb5f07af98da76fb13.camel@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
	 <86d71f0c-6859-477a-88a2-416e46847f2f@linux.intel.com>
	 <Z0SVf8bqGej_-7Sj@google.com>
	 <735d3a560046e4a7a9f223dc5688dcf1730280c5.camel@intel.com>
	 <Z0T_iPdmtpjrc14q@google.com>
	 <57aab3bf-4bae-4956-a3b7-d42e810556e3@linux.intel.com>
	 <d27b4e076c3ad2f5d7d71135f112e6a45e067ae7.camel@intel.com>
	 <8db4d414-b8f0-4ea2-a850-0f168967fb94@linux.intel.com>
In-Reply-To: <8db4d414-b8f0-4ea2-a850-0f168967fb94@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.1 (3.54.1-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB6756:EE_
x-ms-office365-filtering-correlation-id: b02b9e2d-8865-4fcd-f2cd-08dd0ddc782a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dm9odzlvVlRYZXVwbkx5TVlDWTNJUHVnNW5iUFlGa21mclFyR3ZIaUR6Tmdn?=
 =?utf-8?B?bjBqODBRemJUSndEeHpjSXdjQVNJOXZhRFlIOVF6NUJWckFadCtWUmE5WDA5?=
 =?utf-8?B?OHdJWHc4ekdKejEzcEc3Wm1NWWtFLytLUlVQZEhsUExLT0pFRTYvYkxZT1A3?=
 =?utf-8?B?aXVEQm9PTVZNSGdPV2E3eTVpS21TWm53TDNFWVZORUEwVlpwYWt2RUV0WXZY?=
 =?utf-8?B?aWdQV1hDVVIydUcrWDlYNmYrdXdDYmcyOHNueEFrR3d1WVk0ZDNMVWFGeGlK?=
 =?utf-8?B?L3hFc1N4NFI3dHpsMlYwK28xTnpsdmdLcGpCdjdjbDhMeTE5Q0ZBeFdua1FG?=
 =?utf-8?B?ZVhESkxoVkZpUXp0alVYSDZhUXNMck9OeVdDOHRGcGNYWHUrOUZuVWlHMTVj?=
 =?utf-8?B?SllYTFk1cGtyKzA1QWlHOTNDdmJ6WUdoTXBkbGswZHV5UXRVTzJIYVVhN1hJ?=
 =?utf-8?B?NG1DNk54cWRaWUd3Vmt0S3huUXg1YUpvdlBUVnVUdDNsRHF1WW9tK012bFFV?=
 =?utf-8?B?R2h0NXpmN0Vra2R5MlQ3ZmtubHlLRldqZWxlZDBCRHV6VEduM2hYRlBYUm1k?=
 =?utf-8?B?RkI1eW1ydmFyZ3hvdWhEdy92RWVoa1ZGeGpTNVIvanVBMHhnSnc2UkFjOTFY?=
 =?utf-8?B?VW1vV0grbHY2WnFQbEZNVTkzeXhGc082bjdCZ2d5TmNib3U5L2VEeW83K2NI?=
 =?utf-8?B?d3gzaUxhVWNFdWRSaGVmSVBURTlad3RYRmMva0MwVW45REpsUHFvVEJYS1VP?=
 =?utf-8?B?N00wNGpxaUIwaWZTNlNIMkJEMGEveWxMMUlNQjEwRmUrb1hNcmlnbFJrWUtE?=
 =?utf-8?B?RlJRUTRRVkdkWGg4UjdEK1EyVkFnYnNWTnlFZzBxYXV4YU5WYklibTJ2TWt2?=
 =?utf-8?B?VGRMa0k3TzZ6RndpSlcwb2JyTGhSNTBLYUNLTForajJuR1E0VFBKZURMZGtm?=
 =?utf-8?B?NmJQNEVPNkVoVG1FZ2NPZDZMaFQ2WFFneFlMck5KL0pkdndFdk1CZGR3SXJv?=
 =?utf-8?B?bXhXWkYrOFRxc2pNNUZ5ZWdpV3A1ZGh3OHhsd3c5UHNLWTlQR0dvMm5oL3NX?=
 =?utf-8?B?VHljaFE0R2RMQi9ERENwYWhlRUR0MzB3V0tnaVFlZW1NakdqM3dvWTEzK0x2?=
 =?utf-8?B?ZUU1NFpNU01yb2Zrd3I4V2U1dTVYK1ZvWE10eVFiM2VpL29tWnFDMFpFMjVD?=
 =?utf-8?B?N1FNZVNNU3EwVmdtRkN3QitzMzVjQkQxMlVDbXlKZllOZ1JrVWZTNVNGNk9D?=
 =?utf-8?B?MGc0NnhacjdhV0xRUjFaRlE4dGlCeUNaUSt2VjBOOUpwelBVNmlSNnFxZ0c3?=
 =?utf-8?B?ejVpNGk1Vm1hZG5tY1FKQUppMEFKUnk0c0s2MGxFVjdGQWhzSEFoWXFaWTFL?=
 =?utf-8?B?S1hKbjlGVlBUOExnaFhPNSs1NUtRa0x0ZUc4SWdhaEppdVF5ZENQelhhVjlZ?=
 =?utf-8?B?NDhRUFZMZHNxTlJFWTFGQnExQnpJUGs0L0hXdUQ4Rk9kRUNkNkdORWhGdFF1?=
 =?utf-8?B?cFAwa3hBSkJRWjBSUlR3V29leEl5S1FMYVJCd0xDNXZFbEhBbVc1REU0QVNL?=
 =?utf-8?B?Z2RZNDIycmlWaTJuU3hQMklxVFgzeHg0elN4aHhHWTM0Tk53bnQwamUvUElo?=
 =?utf-8?B?cC9ZbGNOQWx0cEFtTHNFMmpkY0wrYXpjMXJUVjNjMWhSOTFTcGtHalQrc3pL?=
 =?utf-8?B?VjBuWTdnYllSUFNldmVyYmthZDk1TTFSUk1SY0hSaCs4enAveEErYnJyZFVy?=
 =?utf-8?B?YzFRNmMydjNaTndQUzYzSHBwWDZ5QVJiR3AyMk5xc1ozbXVJRHB1MVA2K3B6?=
 =?utf-8?B?ZHRDTVRsUjI2RU5CdURJZUl5bTQzN2tGR3pnb2JXSVdiUHRlaUhQa2E2dmJv?=
 =?utf-8?B?WFlqWllvTDg4UXNIWHpGOHdaRGI2U1lGWk1lZG5IL21aYlE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTk3eTE0YmJsK2k0MFVoTldkcUptNDQreW5FUXdLTFJVY3ZFVWQ4SWVtamx2?=
 =?utf-8?B?bUFrWGhOMUFLdkZOUFpCSmV6SlFDSU5ZaHI3T1RaS3B5UFNMbk1hWDJ2c3Zp?=
 =?utf-8?B?MkM0VmlLM1BoVHZlcVBTYWI3NkFzUFo4c2tnU05pVVRTd0g1U0JvQ2VObEVz?=
 =?utf-8?B?Sy9BOVhKTS9Eb1ZaM25KLzF1cXBuWWVCUkpjbEh1MUFxcVVpUFp4UFNlWW1h?=
 =?utf-8?B?ZzVIcUdiV0ZVc1dQZGF1cWQzdzhodXg3VGxxalljWm9ELzc0b1hpQlJZckU5?=
 =?utf-8?B?b2FhL25wYitCTTMzajJtL3FMVW5FMFliL2FJRjRhYlBCZkY2a1djd09sc1Vm?=
 =?utf-8?B?QWlnR2VQSFJOZUtaQ1BqN0ZQWXdZQi9xNDMxSFdVbStuVWxVTnF0eTl1b0Fa?=
 =?utf-8?B?SHpScWNPOWtJMWs0VFB2QnVhdVpIMWdGdDZnRkRyUS85NzJVd3h4TmQvQ08z?=
 =?utf-8?B?amF1cVp4bWV6dnZCWktEUXR2NG9jV3hYd2FQWlN3MTdjMTBDYWJiWVBLYVBV?=
 =?utf-8?B?MXFrNTExRGI2Mno0V1lJWTFmcGZFZE9Iajk5blF0eFp4cnQzWEs3N2I4alJB?=
 =?utf-8?B?aFpsLzV0Q1dzaElwQjVDRk01OXowTzJEbzBqWDJHeUVyZG1sMGxMSUg1WVhv?=
 =?utf-8?B?TlNOdUF3d3Uzakg5VkZWMlZ3UVl4WnJ5eTNJV2dDaEVnSXZLdkMzMklTR3My?=
 =?utf-8?B?dThLQlBYN2VGYldLQU5McEdJSnpwMWxNRXpidnoxUzFZdHY2dkVRb1pBSG9a?=
 =?utf-8?B?TzlkU1lSWmh2WGtSZjZPSldmVFdPYnBYNVd3SXM4MDdGMld2Q0UxMzBZNlZV?=
 =?utf-8?B?dW1ac1d1akVFek5uZjVPbFZHMUx6bmhjRGRHb3hXakpsdFh6c3ZWbnNBMFFq?=
 =?utf-8?B?TmlpYU9DTnQ2T2RDekJwbmlzd3VCeHRZSFV0RERlbFA4eUpNK0ZZRnZudmtu?=
 =?utf-8?B?M29kd1UyZGFLYnd2Ylg5djNJWUVlY3VXRzlsc25ONWt5bVVYQmpmeFlpNitI?=
 =?utf-8?B?eGlYSThHQ0l4NG1FQnBhdy9VUWkyQ3RYdEhNS2FpVy8yYWVndFFxWVdtUk1X?=
 =?utf-8?B?RlNyZitxSDF5bXhXVzc1SnhvZHpvdDJJaS9EQXdSMGdiM21kNEJRQW1qUCtv?=
 =?utf-8?B?cWNpaVZCRkIzMXZ2blJNaDJjeGFoTDg1OXNyakJVTXVTT3Y3dVVRRHdsdS9t?=
 =?utf-8?B?N3lzMGN5NGdSek5URFRHZDNQTW5nYnpjZ0lOTit4ZDJteDVxZFYvOTl2c2Vv?=
 =?utf-8?B?UEdOa2lFOGRjSVFTb1gzaHkycHI4MXV0SjRCMllSN1ZxakIvNlhrdFhQMzRY?=
 =?utf-8?B?T2xtUWl0bVRscEtUYXAxcVNIdXJCYk5FMTBIU0FJZDZseDBHR3VYeFlBdnJh?=
 =?utf-8?B?bS80ZTJpMnNmRTdaTlFkRDBJblFXc3BkSllCUXV6NjRiOFpHNkJzdWhWdWxz?=
 =?utf-8?B?WVNHejQwa1dVOWdvWWl6MVRNQlkxRjRMN1lVVmc4MnVKenNTNnpENno0bHJQ?=
 =?utf-8?B?dmlWMG1VUDBaTy92TDI1emxHVXM2cVQ4Z3NlV3hINDBZTUJ6N2N2MUIyUyt3?=
 =?utf-8?B?ZkhDQkNpbUY5MDNnNS9ES1k4bGE0bUMrek5rYTg1VHM3Wkg5eGtxUVdpUm1x?=
 =?utf-8?B?TW02aTF6dUcxdXF0cFVudXRVS1Z5VExSR2lpSDdQbkhvUHhjS05EYzlnY2x6?=
 =?utf-8?B?TDU0YjVYWXFHSG9tZ2xEdFhPZnkrS3lkNzUyT28xNjJkKzd6Q3ZoTjlNQlky?=
 =?utf-8?B?aFRlcDJUbGZoam5wTURGN2xaQVVORFFEWmJGalRNK0Vwa1JEQ2JLQ0VGbjB2?=
 =?utf-8?B?dE9JSGVpQ2ZhcWhkYnRiYUNnK2d6cE1yRGRlaWNwZGcwWEJhdnVaZitKQ0dz?=
 =?utf-8?B?aU9LUERtOS9ESUtXb3NCWTlvbDZ3OHlYdmNmTnRWQnR2V1NCbUluMTc1NDVC?=
 =?utf-8?B?b0JhRlpLOFFyNTFaM2F0dDJ3YnI1T0IxeGd2V3dWM3V4VSs2Y25xL0k3LzVL?=
 =?utf-8?B?WmtvUEF3eXJzbHU3bEw5N1p5UmdBMEdGZnppZjRPenJYcmVsanBGd3FqN3hk?=
 =?utf-8?B?eXNXZjZIaytLTXVLUVp3dDJsU0ZzdEJmVXhMenV0bHlFQ0FaSmsvMGVqMDlX?=
 =?utf-8?Q?vW/EK+1KN8rF/1RJHM7t8asGd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A1A8939B7D4004CAB8B0995B86E8249@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b02b9e2d-8865-4fcd-f2cd-08dd0ddc782a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2024 05:37:51.6115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HwLid/kgWKmGr9U7u2Z9uIqD/dwrdRdzIruz43b1tunem38aK7FFteXQkXYjUIKsoEpTiKWl4iYl53K8XAsrxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6756
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTExLTI2IGF0IDEzOjI5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiANCj4gT24gMTEvMjYvMjAyNCAxMTo1MiBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBPbiBU
dWUsIDIwMjQtMTEtMjYgYXQgMDk6NDQgKzA4MDAsIEJpbmJpbiBXdSB3cm90ZToNCj4gPiA+IA0K
PiA+ID4gT24gMTEvMjYvMjAyNCA2OjUxIEFNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0K
PiA+ID4gDQo+ID4gPiBbLi4uXQ0KPiA+ID4gPiBXaGVuIGFuIE5NSSBoYXBwZW5zIGluIG5vbi1y
b290LCB0aGUgTk1JIGlzIGFja25vd2xlZGdlZCBieSB0aGUgQ1BVIHByaW9yIHRvDQo+ID4gPiA+
IHBlcmZvcm1pbmcgVk0tRXhpdC4gIEluIHJlZ3VsYXIgVk1YLCBOTUlzIGFyZSBibG9ja2VkIGFm
dGVyIHN1Y2ggVk0tRXhpdHMuICBXaXRoDQo+ID4gPiA+IFREWCwgdGhhdCBibG9ja2luZyBoYXBw
ZW5zIGZvciBTRUFNIHJvb3QsIGJ1dCB0aGUgU0VBTVJFVCBiYWNrIHRvIFZNWCByb290IHdpbGwN
Cj4gPiA+ID4gbG9hZCBpbnRlcnJ1cHRpYmlsaXR5IGZyb20gdGhlIFNFQU1DQUxMIFZNQ1MsIGFu
ZCBJIGRvbid0IHNlZSBhbnkgY29kZSBpbiB0aGUNCj4gPiA+ID4gVERYLU1vZHVsZSB0aGF0IHBy
b3BhZ2F0ZXMgdGhhdCBibG9ja2luZyB0byBTRUFNQ0FMTCBWTUNTLg0KPiA+ID4gSSBzZWUsIHRo
YW5rcyBmb3IgdGhlIGV4cGxhbmF0aW9uIQ0KPiA+ID4gDQo+ID4gPiA+IEhtbSwgYWN0dWFsbHks
IHRoaXMgbWVhbnMgdGhhdCBURFggaGFzIGEgY2F1c2FsaXR5IGludmVyc2lvbiwgd2hpY2ggbWF5
IGJlY29tZQ0KPiA+ID4gPiB2aXNpYmxlIHdpdGggRlJFRCdzIE5NSSBzb3VyY2UgcmVwb3J0aW5n
LiAgRS5nLiBOTUkgWCBhcnJpdmVzIGluIFNFQU0gbm9uLXJvb3QNCj4gPiA+ID4gYW5kIHRyaWdn
ZXJzIGEgVk0tRXhpdC4gIE5NSSBYKzEgYmVjb21lcyBwZW5kaW5nIHdoaWxlIFNFQU0gcm9vdCBp
cyBhY3RpdmUuDQo+ID4gPiA+IFREWC1Nb2R1bGUgU0VBTVJFVHMgdG8gVk1YIHJvb3QsIE5NSXMg
YXJlIHVuYmxvY2tlZCwgYW5kIHNvIE5NSSBYKzEgaXMgZGVsaXZlcmVkDQo+ID4gPiA+IGFuZCBo
YW5kbGVkIGJlZm9yZSBOTUkgWC4NCj4gPiA+IFRoaXMgZXhhbXBsZSBjYW4gYWxzbyBjYXVzZSBh
biBpc3N1ZSB3aXRob3V0IEZSRUQuDQo+ID4gPiAxLiBOTUkgWCBhcnJpdmVzIGluIFNFQU0gbm9u
LXJvb3QgYW5kIHRyaWdnZXJzIGEgVk0tRXhpdC4NCj4gPiA+IDIuIE5NSSBYKzEgYmVjb21lcyBw
ZW5kaW5nIHdoaWxlIFNFQU0gcm9vdCBpcyBhY3RpdmUuDQo+ID4gPiAzLiBURFgtTW9kdWxlIFNF
QU1SRVRzIHRvIFZNWCByb290LCBOTUlzIGFyZSB1bmJsb2NrZWQuDQo+ID4gPiA0LiBOTUkgWCsx
IGlzIGRlbGl2ZXJlZCBhbmQgaGFuZGxlZCBiZWZvcmUgTk1JIFguDQo+ID4gPiAgIMKgwqAgKE5N
SSBoYW5kbGVyIGNvdWxkIGhhbmRsZSBhbGwgTk1JIHNvdXJjZSBldmVudHMsIGluY2x1ZGluZyB0
aGUgc291cmNlDQo+ID4gPiAgIMKgwqDCoCB0cmlnZ2VyZWQgTk1JIFgpDQo+ID4gPiA1LiBLVk0g
Y2FsbHMgZXhjX25taSgpIHRvIGhhbmRsZSB0aGUgVk0gRXhpdCBjYXVzZWQgYnkgTk1JIFgNCj4g
PiA+IEluIHN0ZXAgNSwgYmVjYXVzZSB0aGUgc291cmNlIGV2ZW50IGNhdXNlZCBOTUkgWCBoYXMg
YmVlbiBoYW5kbGVkLCBhbmQgTk1JIFgNCj4gPiA+IHdpbGwgbm90IGJlIGRldGVjdGVkIGFzIGEg
c2Vjb25kIGhhbGYgb2YgYmFjay10by1iYWNrIE5NSXMsIGFjY29yZGluZyB0bw0KPiA+ID4gTGlu
dXggTk1JIGhhbmRsZXIsIGl0IHdpbGwgYmUgY29uc2lkZXJlZCBhcyBhbiB1bmtub3duIE5NSS4N
Cj4gPiBJIGRvbid0IHRoaW5rIEtWTSBzaG91bGQgY2FsbCBleGNfbm1pKCkgYW55bW9yZSBpZiBO
TUkgaXMgdW5ibG9ja2VkIHVwb24NCj4gPiBTRUFNUkVULg0KPiANCj4gSUlVQywgS1ZNIGhhcyB0
bywgYmVjYXVzZSB0aGUgTk1JIHRyaWdnZXJlZCB0aGUgVk0tRXhpdCBjYW4ndCB0cmlnZ2VyIHRo
ZQ0KPiBOTUkgaGFuZGxlciB0byBiZSBpbnZva2VkIGF1dG9tYXRpY2FsbHkgZXZlbiBpZiBOTUkg
aXMgdW5ibG9ja2VkIHVwb24gU0VBTVJFVC4NCg0KQWggSSBtaXNzZWQgdGhpcy4gIFlvdSBtZWFu
IHVuYmxvY2tpbmcgTk1JIHdvbid0IGludm9rZSBOTUkgaGFuZGxlciB2aWEgSURUDQpkZXNjcmlw
dG9yIDIuICBUaGVuIEkgc2VlIHdoeSBOTUkgWCsxIGlzIGhhbmRsZWQgYmVmb3JlIE5NSSBYLiAg
VGhhbmtzLg0KDQo=

