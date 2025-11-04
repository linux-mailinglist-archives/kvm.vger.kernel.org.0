Return-Path: <kvm+bounces-61956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E64EC30468
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 10:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D693734B12C
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 09:32:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03E2B2D0C61;
	Tue,  4 Nov 2025 09:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mCtx1QUx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0FC2BE7C0;
	Tue,  4 Nov 2025 09:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762248768; cv=fail; b=UYPk6wfn0dhX/AiboCdwUHa74j8jLk6F8s1vh//Wd2I21+pMNfRcJY0zj3qtNf7uM/eQHmc9+B4O3uayIYUbcqsAkcfK09jP1ovSlrzqmw3bym8LouCja3h9Vj58Pc1bQYTb0bEEEQv1HO8qk7rDkUUTyUIA+kpdpv8YtsMDT9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762248768; c=relaxed/simple;
	bh=N481nwiY3AuDp0/txJnzq39HGUhCX5inY5wC5LpE/GY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JWLagsyr3pYdBtcx4abojWpY3BUCK/xhkbCgxppWdK953ACAs5kPTtuh9Jumh0+gASVTF3aXf4zufJO+EPFH0u6CYruHaLYnrQ6OusPxg6P8HWdIwwHrL6C1TVUaGT+SDXE9MX9dvEav7+bsRlW/H6wq03EG3KKmlaxHNS8lwyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mCtx1QUx; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762248766; x=1793784766;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=N481nwiY3AuDp0/txJnzq39HGUhCX5inY5wC5LpE/GY=;
  b=mCtx1QUxzuq+6XNhDf9wnTwAA2hqQZzInwMs3nePxP5SuuUc+KjvMXOq
   wvZzzBvgDwmhx9cw9JCc+fVKq+inqUU4lsaip1HgxS0tUXToFrAXQ3aCn
   1US2ZkmJkkuNh+S3rLomkA/EdzW77gjnDYik/vpKDTJvPiCvBCwjoywRS
   JEqU2Ea7TzVQ7K0nvjv3hElze7VN9r+HaTX9wWSylM9mvQhpc2TlzBvjd
   x0DGXSSWInPTGXT40n9OxjBEBMeU5wc34unKjmoEcC45j1TjPKI307z/h
   J60bZkpAAbPvcIaPLYpQVoMn7MEEWC+BKxfY5fFEPQb4Bb+5bpvGEfSpD
   g==;
X-CSE-ConnectionGUID: upBgFYEKTO64Fsi/xD320g==
X-CSE-MsgGUID: ePhxngO7T7KSWKBBvlDx0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="68197629"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="68197629"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:32:45 -0800
X-CSE-ConnectionGUID: B1MMF34CTCSayOIQCutFDQ==
X-CSE-MsgGUID: 8XymuR5nTumk+L7aXAJWDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="210616192"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:32:45 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 01:32:45 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 4 Nov 2025 01:32:45 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.50) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 4 Nov 2025 01:32:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZfwnAhNuhtw4O0mEUQKKvJin/yu2xQwbWeKo+6y9QY2sWC8Aky6XjBDiWlnFXWHagkiHqvo+KKoXUdO5rOL2Q2Kig1XwTaPReFeQNMbwblO/Trc1wkWJvX4WyW1byfHXgUCiR+68RTVf0w/7K6ql+Lks+81CRZEZb7azj6yuAHHlZ3PIdnzEkBV4ir/QlYd5Q5LOO7rkhYqWB9YEOxE8qOtaDZG8gqBChspB4MEjRgzePuBsWkSYlALFO4ohfKmrJxzwMBgw4qRuUPtQPo6EfnjYW/KhveO2dr8inG7LisHObgbMe1QWZK264MtuLxTTngreIqJRUhnXdT2F5gYyqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zKhpf6dslFOjOIB6fX1iuHTLsE8wFj3INpSgxJe/Tnc=;
 b=XqrMlqTlla9aQb03a5mvC/wJM/AXENFaC2qCnMlnSCRZA3h/n48rKlEvysqSmt/us+vP8cJ84hTtoUvzdNrtZVKROb2AuUSYOIw84TcB/LdR0x6pY3vn8jmoEAEPFd4TBpWZbmbD4PHWOtWtx1YRB7SXc5kqe/qm4Gil7/8rjG5XwTR4KY2/WcLRy0fScrkQ4dZnqdLHMmjg6brZrQnW/P58DBpk/WKsbMdkfmtAs9oH6aiBJJsuNkYxD42OJkCowrW994N1oTIqBRhw9Skl1ZBz8spOYB0BpQ9oQvfJsvOyRjaA6j/J73SkPpnFMBZ2xO25Y+vZ0S9ZjOV2V1iADA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB7942.namprd11.prod.outlook.com (2603:10b6:208:3fa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Tue, 4 Nov
 2025 09:32:37 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.015; Tue, 4 Nov 2025
 09:32:37 +0000
Date: Tue, 4 Nov 2025 17:31:08 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v5 1/4] KVM: TDX: Explicitly set user-return MSRs that
 *may* be clobbered by the TDX-Module
Message-ID: <aQnH3EmN97cAKDEO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251030191528.3380553-1-seanjc@google.com>
 <20251030191528.3380553-2-seanjc@google.com>
 <aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com>
 <aQmmBadeFp/7CDmH@yzhao56-desk.sh.intel.com>
 <969d1b3a-2a82-4ff1-85c5-705c102f0f8b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <969d1b3a-2a82-4ff1-85c5-705c102f0f8b@intel.com>
X-ClientProxiedBy: KU0P306CA0095.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:22::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB7942:EE_
X-MS-Office365-Filtering-Correlation-Id: e1f6f621-7b78-4ab1-f02f-08de1b85175a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CTVy5Ke2u/P0OpSOoyghPu/EFKGnaEmfJj844SdwiJfiH+6EZ3NBcZmFw9jr?=
 =?us-ascii?Q?MrruA3rdG6L+k3oh4VwOeXdzfCQgWBHMo6pmb/Q9V6gSOu3WGpK4MWTsDtbG?=
 =?us-ascii?Q?MfQ/F2mLIcnnlje6mPRn3xY81AqNChc7qqJasomy23bvA4oSHe7Z9XrrpG3J?=
 =?us-ascii?Q?GjqwEUXB3RzZOZ38DeC68QEUtNGshkavm8Hf7XH4dzDUvPSDOCcD4MOlWwnF?=
 =?us-ascii?Q?TdFJ2/4zF1es2eAG5uOMwGOs3jIuyGEsKPC1SsC3CzVwHi1gYfniHRDoC2OQ?=
 =?us-ascii?Q?O6I7zuwGzDvm9WhlBtov6FXc0PkisTXeF3RMYTkQs3m0QJIQAhCoAutBAesW?=
 =?us-ascii?Q?orFkZmDW9c8OgvEZ8SH5RSgdYmhnCfNXaq5IikfPRLqybQHXGNnrkRv1fiZ3?=
 =?us-ascii?Q?2k4PsfQ2quADHrRcIYKIPHDh71Y/vFC4lqGxe/zmGoDULGB9gOYCLDBs3lMJ?=
 =?us-ascii?Q?LCbTq9lu0aBkbZPyx7ADoc8p10q2aA5kBvX+Pxi4apG6lGywb5fCOL3UsJtv?=
 =?us-ascii?Q?g21Wwl/QMISqGdfl1gsr6OIL7kZF7B8De2DL3U/fqIHlPw8slPN80epc8dJW?=
 =?us-ascii?Q?tO1RTHHBFHvQpufRj+gSVWfnN8rgoHoamx9nYq2eo56I2SCSP9lhQAph0OMF?=
 =?us-ascii?Q?gMGL8vM1qUm2jp1pi5d+ZLGMqNTyrdS9eC/DzMi0kkR8RLHgOXDuBfBf8nEl?=
 =?us-ascii?Q?0w7NWtn9ll+IIZyRgT1Y0gm4y0wsWEuQvxCSYpTCSB8WsneUA8G/msfrj2A2?=
 =?us-ascii?Q?SDGKNqLOeRs9Blt8EwmARhmq/QPJFHPdgzMRHyHv9KYlfQ21zdlvR8qfqzxz?=
 =?us-ascii?Q?aDpv2EdtKV5QugZlkhrkVfzfvqYx7InzXnJ3QiJL7DympeVa6KfowkYUY+rC?=
 =?us-ascii?Q?mV+240Iz5g5f09OenacazCqO1jKpdfC26IMWR2Yms8mZ2fb8t2qqq5kL9tmB?=
 =?us-ascii?Q?EZZPpd09mKDNcnqdUUzEW4cxlMbx6zfq69IjygRCpHby2L4Xe/7zWMxS6YAY?=
 =?us-ascii?Q?V2UZy4ohksaKqGKH2160chGe9uL3cWqHhTKRHhe2uuynGvDKe4elE/6kWrHV?=
 =?us-ascii?Q?6ldW9RHa3zMjvvjezfAACsyG/gA3auVZgtVK2wpe2Y2ES+FGgQHQhT/z2DT3?=
 =?us-ascii?Q?ahpF8qFHM/nXebUDcNXMKb3ovKdD6E3mRB5zv5dyqcIoi6uBzJVzFORUJS92?=
 =?us-ascii?Q?XyG13H4p84JE8MtrMHowmrckDVIVjQbCjDKEP1KdrCnO8g6PAltC6L4IsClb?=
 =?us-ascii?Q?vgbWSOHHWv0lF64MqSpj1Zwu/MBm7tdHtX69XbSgyT8DDBqtvpZh53jHLZl4?=
 =?us-ascii?Q?YuPYMw2djSUds92o35BKCkGvGB2rNMC3gqCwjs+SvejXgMlVTUlAZZwrpOmr?=
 =?us-ascii?Q?p1TZgZRmcx5PHNI1ln1a6Cqcr0B0sVRwmd8QRltoEcWForBBKhpN+CF/a38t?=
 =?us-ascii?Q?+bYaCO523u23Y2RqpumRRU2l3RIT05MW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?t5rLIVrX9u8MOPe2MeVeSTtTLi1xyp9rhAIMK/jwE4hTqM2mw7r5/DwBVZem?=
 =?us-ascii?Q?5Xo+Kum1P4ivyJGtL7rv3qgn/bwamOLLvNACoAxm4mazZ0Pk9IjaxHmC0OrO?=
 =?us-ascii?Q?q4Er5i2Wll6wugGe3sfmRNRfuJdKuHxP+VFZvqiaOx+w7d4HKHEGF7FFgwJP?=
 =?us-ascii?Q?9whWNCDiD74Qi/nSNahmqZCbeFOaEDKjHEZUQF/P5RJ4jDH+Jbc7vAUkAKBh?=
 =?us-ascii?Q?LsxicvZ4+C9QCJVai9l3+9mp4GG3qukdk7hZUb9C0wZQx8+b+Bwbqd4XHei1?=
 =?us-ascii?Q?l4qL0BhTkeLe/vRhyvhq2bySFkTjEJl91ZAAcDYEMBL421dmDEhWOeCyOIyz?=
 =?us-ascii?Q?5N0pl84OWBRF0Y37MEaoO7c+2L2CubFV3j0WqJK7A/81PJK6h2v7dEalytop?=
 =?us-ascii?Q?3wmWZtdNvaij9iPzxgqbWGbWvLKV9q2g/k47CvVECwB9Ex+pKjqyGrNDhSjB?=
 =?us-ascii?Q?97HNO/jw5Ihs/wFBNzA5QWKXv9hbHajrftok7qNwqm9yzgZ2ccx73JAujydQ?=
 =?us-ascii?Q?6qTUDZNMe+yeYFuufJj7LZieCeSRJimnM4jPB5z2vMsKqg4bMiiopEa3kKDk?=
 =?us-ascii?Q?wsMwiJY49SrK+pxsuSvmcDSgNNvYe4qUupWFtpc/aGmOVRMGDhUb9dhdDIFk?=
 =?us-ascii?Q?8l4vs98UkuxgFiO8RzfPq3UX/kDgDGFD5MPNerPB8SjzQAT7l5AmyrDqz+FP?=
 =?us-ascii?Q?wLew2qzS+Fay0U7EWZZiWFRzHsVO1al1n3ghl9iVfBqdky6jk+LTV2jBZdh4?=
 =?us-ascii?Q?S0lUVXjaUzxVU6MRB1qyt9eL9Ti3UfIdYOMCSRM/eO+r28Eec3jn06YmU9MX?=
 =?us-ascii?Q?yTQzeldfoZ4htk5YPvb3QPvm1or2UkyDQLm4rknMoBuTLCXuLracU0xDRdxy?=
 =?us-ascii?Q?ZgSgvthMC64b4fYl3mNsYSfrtlcnRVQ85kHKItOSVhYqa0gpB1TOVfQh2+MG?=
 =?us-ascii?Q?eqBcntdcUmot6vyaPSdDXXnfc7y1cFCiyvtrBji+gw9lPi7zb2IoHefAVgsh?=
 =?us-ascii?Q?U1hy2qphJK9SJtwv6b0mdotjeQRJsj23vcR/yrtUJ5A1GgiarC3kyCREnFQ4?=
 =?us-ascii?Q?iD8CQ5ZfRnhdrT+KieHISGPfMrMIxgfDNbiBCPn2vJRgjQ3G5UrGob/31ZCT?=
 =?us-ascii?Q?3GqkqOpMSGwkLP+TeJl5cRCbULYua8hQVxpCc5C14feyEFcR2in0jOvDO+dl?=
 =?us-ascii?Q?98LTGb07TAo5bzzRmSbilxadtgtwXiOBtR59BsP6Q+W+krGUnlNCJqLJas+M?=
 =?us-ascii?Q?c/TczgYUqDWUJS1CC5gysNAdKqmukrsWWqCcivPKC97ZvW6Ii1EQCmAw5l9X?=
 =?us-ascii?Q?vFVMoS/PGH3MgrdJxHfPVYz6P+0Cozl/4Z5dC69mG/e0HT/26LwV+znNMenJ?=
 =?us-ascii?Q?WEsz7bb7WSy98Z81wosL0Q9NEv1+ebKSCBuJ3av3nc9AQeXG8tBQr3iWqmgb?=
 =?us-ascii?Q?BQ/2DyBIj41QXSbm5OSQSuKZSFCVsCOoQ/hX+rWTFYyV9Z90NCGiyczNhGVf?=
 =?us-ascii?Q?N54QGbPa5lzQ8CN3r93vAI8WDqSP2U7w9fC9xakdTYAD/D5pUyyH9zRQAMj8?=
 =?us-ascii?Q?NTxMKYNneb+qg3MkxBzKFeNuGvLunI6WSaI5SFas?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f6f621-7b78-4ab1-f02f-08de1b85175a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2025 09:32:37.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OG42L3W8bSBsX8br9DQAkAheK1Wkc+WX7p0wJdttH1L+b4gVzs8sTstww4d198ShnSDhfX8ES0BBT0L7z+xIkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7942
X-OriginatorOrg: intel.com

On Tue, Nov 04, 2025 at 04:40:44PM +0800, Xiaoyao Li wrote:
> On 11/4/2025 3:06 PM, Yan Zhao wrote:
> > Another nit:
> > Remove the tdx_user_return_msr_update_cache() in the comment of __tdx_bringup().
> > 
> > Or could we just invoke tdx_user_return_msr_update_cache() in
> > tdx_prepare_switch_to_guest()?
> 
> No. It lacks the WRMSR operation to update the hardware value, which is the
> key of this patch.
As [1], I don't think the WRMSR operation to update the hardware value is
necessary. The value will be updated to guest value soon any way if
tdh_vp_enter() succeeds, or the hardware value remains to be the host value or
the default value.

But I think invoking tdx_user_return_msr_update_cache() in
tdx_prepare_switch_to_guest() is better than in
tdx_prepare_switch_to_host().

[1] https://lore.kernel.org/kvm/aQhJol0CvT6bNCJQ@yzhao56-desk.sh.intel.com/
 

