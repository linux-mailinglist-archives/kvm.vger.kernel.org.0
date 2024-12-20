Return-Path: <kvm+bounces-34206-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98D969F8AB4
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 04:52:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 482B5188B4B3
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 03:52:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D54156F073;
	Fri, 20 Dec 2024 03:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wkgx2CmB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8803F2594A8;
	Fri, 20 Dec 2024 03:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734666738; cv=fail; b=aoKI4UF5dgVx74D0E2O11Exv+WJxH5DclqUvisKeAiu3znatFNCaSpKc9hcahp7J61u0dcox7+T7ITvAZeXtbp7YfPMZ3dreXDC15buhrcyZFXDar5Az1qrIBcTZ/VefkSwj2RKU3mi8qlmCdGNSRHOzaI3WwRmSgRwgwhaVaxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734666738; c=relaxed/simple;
	bh=jIwcwcyZzQYULrVlENYCzoo0u5W+3m5JcqvLFDs2xDQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ai1PcpMpeJmAG6a12CiZOST4CT3VOVdlpIciF2ZqIskILiXuntl3LaNXxo4ocQWKfJ2zW2fc4fDU2s1kCYZaTH9HESxNDNp45sfJGw1QHdlxsHqPGrKDzYfFnkJcIzsvVOeE0hwSlYKckZn3MW/3RMcH/lAhreehKAe1CkXM3wA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wkgx2CmB; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734666736; x=1766202736;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jIwcwcyZzQYULrVlENYCzoo0u5W+3m5JcqvLFDs2xDQ=;
  b=Wkgx2CmBR8j7YKu81YE8grcbg7MmHtfW1nPx3iAeRpBrYGKGeBIrjmIg
   ofJJ+99Rg35WdlFw4Z2gQWWhedjStffvyDsgw5qAiFrLz9oV9+go0BhbW
   jzOYsNqnoZ/5vE+bd1liKebqd/qtR9J31TlAbSwsuzXrjFY8DK7MqYNC/
   PEfnUXe+52rHcqFqRKv4pgq16mpzJDmWEUDiR9DDBvwkOdL5ruldsFS7r
   wng1IIeBTkXRVpMVmEp8HCK6n4v+J4BU4Mz1dx7XnV/cWx1gb7QpIqTlX
   mp8r5ZwU1jAUjilDOgONueZ918iYCnBLZLWRkiIuyCEckFPaWRkoVN3Ep
   g==;
X-CSE-ConnectionGUID: nB4SC0JkQSSiomC5elYGyg==
X-CSE-MsgGUID: 2XBI/lQWSbiSiTQI+4Kv2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11291"; a="38992550"
X-IronPort-AV: E=Sophos;i="6.12,249,1728975600"; 
   d="scan'208";a="38992550"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 19:52:16 -0800
X-CSE-ConnectionGUID: xb+brmkDSbOvOQxIDxTmKg==
X-CSE-MsgGUID: Nbv+S9uaRRezFNakXFgGyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="129358942"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Dec 2024 19:52:14 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 19 Dec 2024 19:52:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 19 Dec 2024 19:52:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 19 Dec 2024 19:52:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HiKYyq3OId8YnRcsRnXiBiHAfUuRlunTZ5QUVlwSTH41TZMfhY/WmEkfqZDXdqO0sFDfsso1vakfptE3EAryXPGJW4m6yu6KfFO2tMVUgnc0s7U2npEmlZqhBEcSF/Gm0MN/f/PGXA/hX1XRlhOp8wmo0hJOVvNaUjKdsYlCc7HAWnoAqR+gKMwhyh++b7sbkUF7EcHZYTNP0NSz56Culvo8WO4T3P2ysYAHmJYkAMIt1dlgxMcYPo3cu3ZobxYb7UebLrWqE5usSrq4wGjHDJGEkL/g8y8GZrDwX9MbkSBa/mXZ3jJV2i7mi+dHCd+yuPE42fuk0Mn/HjdzWnXcNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0gpVfP7gcrGjCifN+DDcazfAtrHGkiwTeTNLv/pjD+s=;
 b=CurTXsxc2Y+/UAclvHYp1MESSvDNa9XHSEdsApw6PHDRsinABWsC5OeXAm6Hs7rEydfAi5L4TkLX6ws3ts3uLqaXzLvrpQBPmfW6I3FiCgbGPat/iY7YCRnhz6Z9o+EMFJPChKs8z5+Hk/bdgMOijetWmY2QjxnSoVfBvmyuciz0vCNLYWJsc/o5N15qNvwp4djF1g3tTL0+3iJpkr3a51H2I9OwlQiUz33ZBJtrYBz2mKjRb3GXKQd0H1NhvQSf/9/QMMI5gqrwQD+3yA6Of5FpLaoUTkmkkIcID5xdO/fhA3yV3lAFMhfuQlhN92Pp1fRnkuLzdw6ckSfcGODG9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8166.namprd11.prod.outlook.com (2603:10b6:610:182::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8272.13; Fri, 20 Dec 2024 03:52:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.005; Fri, 20 Dec 2024
 03:52:11 +0000
Date: Fri, 20 Dec 2024 11:17:51 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <leiyang@redhat.com>,
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86/mmu: Treat TDP MMU faults as spurious if access
 is already allowed
Message-ID: <Z2Th31I/0O/HY/Mb@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241218213611.3181643-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241218213611.3181643-1-seanjc@google.com>
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: 3060705b-88a8-4a48-725d-08dd20a9af14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kUeNiTyc5a+mbzfm7BDzidxaE5o7XNaAfhdMCUTYiTy2lGUmAzH0Y1lZ8L/7?=
 =?us-ascii?Q?1yAwLfzYTA47wU0LC8JVGHf8gmi2uraoevVuUuv2VpkJihPCZARTQPGJiK3K?=
 =?us-ascii?Q?HlmA649iPcH5QCns/DwVJ0OBE+6ikmPt3f3RfRXbkBo+vrrBHaO5499dp43P?=
 =?us-ascii?Q?iCXqPsXNnSGMgn/svsbLZTZJCtpxTFFAMtf+bhppeVgkBu7fJxWnSO4ZkNPA?=
 =?us-ascii?Q?hm9syjgJEtvOV7d21+laadrNJHaVNMC0g//EJV5SlUUO0G0LCq+Pmkf2CfTS?=
 =?us-ascii?Q?c7JKJde+X2D1FV1RJ2edr9a/pTTebxRovA5/lZUA4km91lbqfwbWGRJsthNO?=
 =?us-ascii?Q?Z9HYeNd2A72w+42dlx7O11YZny10xT4hFveOjzQq6djrI0LAHXfQpYhbsy2b?=
 =?us-ascii?Q?ruo3u0tuHgVfaP7gz755vGlPvjeD98+HKINLtNn4AvXnYxDtew1tOqahNIsd?=
 =?us-ascii?Q?fSOydduUZhzkHSt3qHBK5HH3OEAAiuS2AYTJ//m/KTgpV4zfi2nmOZi73UUA?=
 =?us-ascii?Q?UC9rfzew6ivjpuyxi7DprIm+TmBpmq3QYv0qmoHtCpaWtVjj/T4b/bvRkUiu?=
 =?us-ascii?Q?rtZWLApCpx/gonJIt59phuWVr/EG3XgFLw4HGvaHRitrFqxfKSWCXh3Zit6i?=
 =?us-ascii?Q?B68O0Xjv/yAgoFpnwtfO5r3JPnmwnLbGixeZRY2Lgpzxq+C8bsyPWbkmt+bT?=
 =?us-ascii?Q?DXyUsy2wL78eeCoqTzm6vsne0z6WXnv80la1ZQaD9K93cdu0Fu1DAejEzZ7I?=
 =?us-ascii?Q?ige7Xd7TTIgZE3uWDUbRAKnZhipkBpvVcG8DhspJzIDtktrB/exuN9X4dZ3C?=
 =?us-ascii?Q?hKfPYMX7YG5PfWF6bNObfzHduIFp6a0wM41JpTmeYjqSIsvMBp/bOqtx2u+s?=
 =?us-ascii?Q?VtmYv/Oqp0bzj4wPZsswfK1CArXyz9Snwe7aIezK1RvjLbJWlHFBNhzl93Eu?=
 =?us-ascii?Q?pzxDIKHG6bXJwmx7xWu6EdltApv7MkGCCT13XLmMvFSsO6+iPwwH9DsfJ2J+?=
 =?us-ascii?Q?Pgk1wiAp1VWPunvHOhotID8PCLzGNL7dkOsmSFRgcX6VbO1w+ZeYURcOcQux?=
 =?us-ascii?Q?0vUDb4PXc/RgCZM1xiuH1FLPUiTzQoSIho+VHgvZN6baH1MQWr2wOX3ACFTb?=
 =?us-ascii?Q?o0LOKOjtzUGv2MInXXhpQFtZ7PkIIiLWfSzsMOcV85+Kc8xmy+T7qWHt2MPw?=
 =?us-ascii?Q?m73WnIjc2+lnFzmCh3lxo8RrSeCIMT3a3NsZ4mGYFgLfXGAkAXId8xUrSvTm?=
 =?us-ascii?Q?QfmobD+JaHNFwy1EZVAP7ZrhfGnh74mdLxi7gN8AUU7PzLeFJHCX5o6mDFE5?=
 =?us-ascii?Q?ykqjLCGFE7b+c6U4Pabik24mgOs/5jOD2dihpkY8byqhB3O5X4Ac8PaowMXV?=
 =?us-ascii?Q?VxjTXDexQ5uS+buPq2J1tVDOKRBB?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J1GjG8AdFNuXmVUn499xJm6pBhVC+Sif0kr1ZVNU5n6vqfYQoDeauTi5GByf?=
 =?us-ascii?Q?odr1Y5AE/oItCAja78WGjkdLr0DI45m4dWQGKd7Jh/I6G76abA/f2Sepk1QT?=
 =?us-ascii?Q?/kGrsOVBcQlDcqc35tq6w91/Y+JOZ7HEg2PNmN38GNuUpXbYJwNx5KLy6TT9?=
 =?us-ascii?Q?Jr+XgOSGmHuYcBGzmwcK5JLERQcvasF/EIkz3PheV08k55Anifac+WM+zQf+?=
 =?us-ascii?Q?kePpAp7mWRkts9pHngRxFjzvH4votyYR65fpZK0F5nz7VYq0R6fn1oIoPH7x?=
 =?us-ascii?Q?vQ82RtFmmbVkWG+lcUR4bC/Warq7tE850lVcNPGFmjU0JaLFtnmKRpCZBIli?=
 =?us-ascii?Q?qpUieyJB9WePJCxvWnvAyP+A+i9E0ktPq1rsK0yspfTW/QySJ711x9v9biEE?=
 =?us-ascii?Q?WZSGTnnksxmj1rkMr08R62s0SOF/bR6TL9jHE+2TyHlYKiRhrCWhkEsvFmi2?=
 =?us-ascii?Q?faRAPI9PIYnFjqdWugYjDaMVGD+hjdhsYPTCuXWLzrziQnF0LvEaqt4nyxtx?=
 =?us-ascii?Q?pGjK3v+0OreLUp7lNOZoQnhE1OtgxHAOYszeGDcNtRGyrYDVaylc9rF8Q6nz?=
 =?us-ascii?Q?0ZozoBY6OD1N86G4nqRKhsUCMnOplFI8X/sfN9UemijxURE/WFEelSM9Y6Wq?=
 =?us-ascii?Q?j/oKY4LWAkdxic9KW1EJzgHIOmBPSB0zcIYKlkP9x7wWLvYiaJ+edJGZWkkS?=
 =?us-ascii?Q?sVQ9wc1phalPxQ3nF/fiwKIZONIc7JQK7xCzN74GUIYHVZ8ktKlLNH0zVx5Q?=
 =?us-ascii?Q?JxhUdno8koKVtG8IUioiIGc5QlZlNOVsbjxjnlsDprZtDWf95UjVwnNGufmq?=
 =?us-ascii?Q?c5b7oD2JOtHJHsroT5ING6H8BluotunpemoGOql1w7OSyUBnovWTrdVxJho9?=
 =?us-ascii?Q?gD20xEOR+ll/JT8gLDCgXJf5LMkiijfDPaD4srWsjqP0OQC3J45jtsIetVy0?=
 =?us-ascii?Q?+lM1AW2ASPUDMn2LzhtCJqp9h3VhLNepMv9WnP+6HomHMq/K0qepSmWM87TL?=
 =?us-ascii?Q?g1EBunODhHW3z8HxSErjFNxlh9Y7fGUB7L1ioxfJ0kD6nv77P3aOOF8twV+h?=
 =?us-ascii?Q?qkEa4adVohuhSfh9rLulFHqBX8ubP5s13/9tK3fjGfzoBzvMgeBrAWKAYQf7?=
 =?us-ascii?Q?n0AcTg97qGNeClk+r5P+GLKNlRFpgMV3W+5Kbgg8mjiqoA71ZLB85j+FvFUz?=
 =?us-ascii?Q?wkuLzLgrE0Uiqbx4BlmsrXy18bGwsZ88ynV0GyF5lfteHLxSKdqiD80zchGP?=
 =?us-ascii?Q?Wn2yKg0mcy7QoIijbK1TfCKs6xXctr/kRjFoNEXDdc6y9GtS1uGn5jfTFs7q?=
 =?us-ascii?Q?yRKk2Mmj9fylhFqyJHvmwdi8C9CwLMYxYId6+sy0abp8lT1uP+aS3ugK5qWj?=
 =?us-ascii?Q?3FKpMY6jpnEq/32We4BXXDxG2T75i71iOLb7dIFTj9ygQFx8eFklI3opVn3z?=
 =?us-ascii?Q?y6oWmjy3drdWepegQt3TF1LotfszEgz+9t7kY1/+QyqbFfF8v13+hVwhWFXz?=
 =?us-ascii?Q?MavMX+4J0KlGMEmMJNBMcvw+lSATUpV4k1ucknPW+hr3HdyPLjHVDcaySoRu?=
 =?us-ascii?Q?mjVVeLZMdNZreHKJnVWwAUMuLve6ENhkssBiHkBg?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3060705b-88a8-4a48-725d-08dd20a9af14
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2024 03:52:11.6694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNHL01Wbh7nYz3ANUdLV2T8MzxXOEUSlSHyrw1CELSPSYDd4+ynvEzSxAJgCpuCZGSaSc+VbpPFWzliFmXzPtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8166
X-OriginatorOrg: intel.com

This also fixed an Accessed bit related bug in TDX, where
"KVM_BUG_ON(was_present, kvm)" can be hit in below scenario:


     CPU 0                 CPU 1
                           1. TD accepts GPA A
                           2. EPT violation in KVM
3. Prefault GPA A
4. Install an SPTE with
   Accessed bit unset
                           5. Install an SPTE with
                              Accessed bit set
                           6. KVM_BUG_ON() in set_external_spte_present()


Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

On Wed, Dec 18, 2024 at 01:36:11PM -0800, Sean Christopherson wrote:
> Treat slow-path TDP MMU faults as spurious if the access is allowed given
> the existing SPTE to fix a benign warning (other than the WARN itself)
> due to replacing a writable SPTE with a read-only SPTE, and to avoid the
> unnecessary LOCK CMPXCHG and subsequent TLB flush.
> 
> If a read fault races with a write fault, fast GUP fails for any reason
> when trying to "promote" the read fault to a writable mapping, and KVM
> resolves the write fault first, then KVM will end up trying to install a
> read-only SPTE (for a !map_writable fault) overtop a writable SPTE.
> 
> Note, it's not entirely clear why fast GUP fails, or if that's even how
> KVM ends up with a !map_writable fault with a writable SPTE.  If something
> else is going awry, e.g. due to a bug in mmu_notifiers, then treating read
> faults as spurious in this scenario could effectively mask the underlying
> problem.
> 
> However, retrying the faulting access instead of overwriting an existing
> SPTE is functionally correct and desirable irrespective of the WARN, and
> fast GUP _can_ legitimately fail with a writable VMA, e.g. if the Accessed
> bit in primary MMU's PTE is toggled and causes a PTE value mismatch.  The
> WARN was also recently added, specifically to track down scenarios where
> KVM is unnecessarily overwrites SPTEs, i.e. treating the fault as spurious
> doesn't regress KVM's bug-finding capabilities in any way.  In short,
> letting the WARN linger because there's a tiny chance it's due to a bug
> elsewhere would be excessively paranoid.
> 
> Fixes: 1a175082b190 ("KVM: x86/mmu: WARN and flush if resolving a TDP MMU fault clears MMU-writable")
> Reported-by: leiyang@redhat.com
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219588
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c     | 12 ------------
>  arch/x86/kvm/mmu/spte.h    | 17 +++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c |  5 +++++
>  3 files changed, 22 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 22e7ad235123..2401606db260 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3364,18 +3364,6 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> -static bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
> -{
> -	if (fault->exec)
> -		return is_executable_pte(spte);
> -
> -	if (fault->write)
> -		return is_writable_pte(spte);
> -
> -	/* Fault was on Read access */
> -	return spte & PT_PRESENT_MASK;
> -}
> -
>  /*
>   * Returns the last level spte pointer of the shadow page walk for the given
>   * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index f332b33bc817..af10bc0380a3 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -461,6 +461,23 @@ static inline bool is_mmu_writable_spte(u64 spte)
>  	return spte & shadow_mmu_writable_mask;
>  }
>  
> +/*
> + * Returns true if the access indicated by @fault is allowed by the existing
> + * SPTE protections.  Note, the caller is responsible for checking that the
> + * SPTE is a shadow-present, leaf SPTE (either before or after).
> + */
> +static inline bool is_access_allowed(struct kvm_page_fault *fault, u64 spte)
> +{
> +	if (fault->exec)
> +		return is_executable_pte(spte);
> +
> +	if (fault->write)
> +		return is_writable_pte(spte);
> +
> +	/* Fault was on Read access */
> +	return spte & PT_PRESENT_MASK;
> +}
> +
>  /*
>   * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected for
>   * write-tracking, remote TLBs must be flushed, even if the SPTE was read-only,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 4508d868f1cd..2f15e0e33903 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -985,6 +985,11 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	if (fault->prefetch && is_shadow_present_pte(iter->old_spte))
>  		return RET_PF_SPURIOUS;
>  
> +	if (is_shadow_present_pte(iter->old_spte) &&
> +	    is_access_allowed(fault, iter->old_spte) &&
> +	    is_last_spte(iter->old_spte, iter->level))
One nit:
Do we need to warn on pfn_changed?

> +		return RET_PF_SPURIOUS;
> +
>  	if (unlikely(!fault->slot))
>  		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
>  	else
> 
> base-commit: 3522c419758ee8dca5a0e8753ee0070a22157bc1
> -- 
> 2.47.1.613.gc27f4b7a9f-goog
> 
> 

