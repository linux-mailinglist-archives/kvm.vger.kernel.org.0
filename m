Return-Path: <kvm+bounces-49618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25DE9ADB25F
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 15:45:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3D2418829C5
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 13:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCB22877DB;
	Mon, 16 Jun 2025 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c+FIv3wR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EFD2877C0;
	Mon, 16 Jun 2025 13:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750081404; cv=fail; b=Vi3B2y0b2vDIxJYp5GqTBjP6wioz8KoZzS7UXPhVM84G3Lr70er6mL0tieZcRie/225SXOwqY8wUmvTJ688nZEg1wLHwgBwAQka+r9w6306DaF5vvG697KLKiMjE5X5MthAsvy6JUKDtKaBLfWOomdZkepqtVE/B7bMxU1k+UgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750081404; c=relaxed/simple;
	bh=FiW9n2KszQAzEEwW61SbvorwN3dnL3g5QpVJjnGFjSM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QVqyYmBZpezs3hakmQquF6fBcn9YNJhRS5uvQd0vXTCfyAx8cyCEM/YMP+GIY+VxmBw9CnBLQChojQ8ljjAyGNZUIMx5JtrMW/ZnbV6jSOunMN3HAdZP8E/UJBiGhrgHNmt6WU0DVEhp8Wn5W5WU1axljhOg89a0zg1bLPHNBRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c+FIv3wR; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750081402; x=1781617402;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FiW9n2KszQAzEEwW61SbvorwN3dnL3g5QpVJjnGFjSM=;
  b=c+FIv3wRRTmcnbFn3KHG2aFVROwkvgshZ6/B1xbjmbsQubrCD42s7l20
   c8lXTi57l7gfUb7Av4on08WxsM8+cz2dhqKe8iGAL+v3rkIYh30ZLJm0Z
   3Mmz70uu7BqDO8vOegvwY3pjaWOPO3y/irPv5KAiymYGXh6C6SfSBb/GH
   yvZju8UNDuSda5u2KKrdJzvceRo8831WtsBOxAbe1LEdhpc37lvbQeZLF
   RPEfS6W1wBwZcLfboUssMyxeIelCb/Az+EB2bQX4fMOw4Xkwk2j+5Pjxw
   haFQEHr0jkJeaollrj5Ef1kDCoqqXnCUj+LTdnyFW6h7YhIii6vy5/d6o
   Q==;
X-CSE-ConnectionGUID: oEGE2ZjBQwuXjxk9cUn/iw==
X-CSE-MsgGUID: hE9FcJ13T9a1IeqJ6cx1/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="52315960"
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="52315960"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 06:43:21 -0700
X-CSE-ConnectionGUID: S/sTlcr9SDiE2VZPRgkzVA==
X-CSE-MsgGUID: vVV97YBBRVO1eaf29H9SEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,241,1744095600"; 
   d="scan'208";a="171697793"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 06:43:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 06:43:18 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 06:43:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 06:43:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jB64cXjczRvhNjurfcJdyTfSG5mqTKfkAtm9kVL+DG8JoaqdjEkzOGC6anT+1T/tbpPBbmDR9BAl3LkJJ54XWhQcf2gSWvEOM+2dvM2W/1G54P+dWzdndKZMVUeLRmoblv6loiusoEwszPP5iyiqrMd0oiHAoVaFlkmnWmzKfAwRwlfcpsF0gYdpDtWx2/UEJI1RZGCTjdBAMgNxZSdHiQgWrafisDasWz+L30KFpqx2dKgEpT5Y4boCghNMEyr7e+RRAX3JUWBu9taiqumQ0qMwQ2n3HdifS3895jNN6V2gnPyR+2AHWrB7rhVtxVRnN7l5gFTJtn3fwJ4Ew6WylQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcFljD8rP7OtsuANFsBQ0C3gYtGRYsATyTij7PAVa/w=;
 b=p4JqOOFx1hfdTupGScG0CriPCA8FyuSmLOUyQBDrhZbWqwl/MiA3pNpG3Hy96zgCFms2/NrYkmLZrT+RauLnG7tzTUcx3qsMtdhOTnFh24YRInlPz/QMj4dcSYvCVZPUKkTJpwDyziRWokXBqtYYYI5BFZGj8fPqou69/o82d9gAOIi6uUHKYh/1n4DeUyYXA52iWp6FKIrUzQVK1Kfboig4EvQVVKlklz/V2a2Keyo1CwSszgM1DUgLKcvCk1A7PvuQDaPRo/3OVrTxEtUeKZK2SdyWFhnzdKcvYVpQxBXFL7oFImBdRdrhO6D5OlJsHBCmM4fMXq4OJMWlEBOXoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by MN2PR11MB4550.namprd11.prod.outlook.com
 (2603:10b6:208:267::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Mon, 16 Jun
 2025 13:43:01 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::19ef:ed1c:d30:468f%4]) with mapi id 15.20.8835.018; Mon, 16 Jun 2025
 13:43:00 +0000
Date: Mon, 16 Jun 2025 08:44:05 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
CC: <kvm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
	<linux-mm@kvack.org>, <kvmarm@lists.linux.dev>, <pbonzini@redhat.com>,
	<chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
	<paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
	<viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <xiaoyao.li@intel.com>, <yilun.xu@intel.com>,
	<chao.p.peng@linux.intel.com>, <jarkko@kernel.org>, <amoorthy@google.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <mic@digikod.net>,
	<vbabka@suse.cz>, <vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <michael.roth@amd.com>,
	<wei.w.wang@intel.com>, <liam.merwick@oracle.com>,
	<isaku.yamahata@gmail.com>, <kirill.shutemov@linux.intel.com>,
	<suzuki.poulose@arm.com>, <steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>, <ira.weiny@intel.com>
Subject: Re: [PATCH v12 08/18] KVM: guest_memfd: Allow host to map
 guest_memfd pages
Message-ID: <68501fa5dce32_2376af294d1@iweiny-mobl.notmuch>
References: <20250611133330.1514028-1-tabba@google.com>
 <20250611133330.1514028-9-tabba@google.com>
 <aEySD5XoxKbkcuEZ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aEySD5XoxKbkcuEZ@google.com>
X-ClientProxiedBy: MW4PR04CA0075.namprd04.prod.outlook.com
 (2603:10b6:303:6b::20) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|MN2PR11MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: ee6786be-d227-4087-9430-08ddacdbb5d6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hdARHb780v1wlHgoVAT+p4aMpBwC03mCAbJSscNvhXAuKyIM2m7v0+RgIJgd?=
 =?us-ascii?Q?4NMGr6OEHpyqggipFRKF2AorIena4RHQzVJwbNejh10LjCGhkdXQ0vbXIkiv?=
 =?us-ascii?Q?iR4IEar5RlF8MukF821iaqQZQRjlswiW61ExfIETqciXP+24XWl3uqeAyCjV?=
 =?us-ascii?Q?GtK0qg69ewg3aAgS0AMs8S3WRfk2Ehf1bnJVWc9aFUhx1HCy3ThW3V1gRG6P?=
 =?us-ascii?Q?Tur0LVLVv39Jv7P8q0RfMjttSd4ISAhDaZ/tD2rbvR4wHQ13mieDvHlSL4hD?=
 =?us-ascii?Q?xlPaTOahwFV1rhUURoMaPmBMkHuGWH8HDWCieeBUneS53s2H1cg4NCICRIMd?=
 =?us-ascii?Q?PweYQQYK8F7Lr42uWHWV3AFmLAJCpCXSBY2KxlCiAt5DhC35oAJpf+DAIBao?=
 =?us-ascii?Q?emusFa/apUxGCypKqif96V8x26lbguLFyGZZ4TSg1ZmU1AO4RjOgqqpB3IKq?=
 =?us-ascii?Q?pActYdCCZpU8oqAsVaaX6sEVWx2EucFg2N5yeWGplNXHszgjQKgBqab8OpN2?=
 =?us-ascii?Q?NwB/zGL/S8tMBwNwvZlwNQ9VCx1wTZch8D/yZFZO3+052l7u26UWbHELY6j7?=
 =?us-ascii?Q?JiWx2SzA3r1H07nY99Sl7vzmV6zNqhsDs9p2dLWRCWoVs/i6/mALljiXkEda?=
 =?us-ascii?Q?fNPsYBRmFDQy1EYIlAKoebSv2LeS3YgUMHB1p1WaZoTvN/LOyXrpUh1i3ojO?=
 =?us-ascii?Q?Dtf1nwSuBw2czBiNNXHXn2CjUzGtuYmorAGVKUaq6dBAhjrs6AiNiys4qTbi?=
 =?us-ascii?Q?1kHVO9xnvbp8uV10lLR7brYnQjnywlOxp15iMiAAh6i9K+YtvaTktXPA7P8x?=
 =?us-ascii?Q?dgK/nsRr7cKNVkILopVVkcPSoI31/okqQ7Y4Tg1keYPi77bdDEPb6EA3Mgfy?=
 =?us-ascii?Q?GzXYtk1fkfbatzzwzm0dQKe2Hq6dVAje/DZRYLT3icsb6hkIFNb6s1VszYZI?=
 =?us-ascii?Q?gns3uDCMyk8mgaUNby6ZdEZjXRnYXnbLR5pkqVa82Hv6vWu/amMQ7jdFbfqn?=
 =?us-ascii?Q?l/CGtto+9wr/Q8Yvu0AMAOUdLT5DqaDuMYJ3fQ8EoHBG+XRKZIcxa50ppk2G?=
 =?us-ascii?Q?3KDi76uw54v6OomgjEgFB/3YGWgi3AGxDF0xy63HUKwT4W169u4xXskvAt8S?=
 =?us-ascii?Q?Plg3zZPoXGVF/vB4MirXmHDRJaH/sktyrCt1OayVtrIXSzh9cXOTbFkLW5Sy?=
 =?us-ascii?Q?YMinwA1r+PU7vS+W2pMuBv3tfgyWOc4/wdoHAfO3h3+6nT1Ul46DUH5zhlJ6?=
 =?us-ascii?Q?if/v2fxDaqJLjqxpb/fLqSPMdS5+2ApY+AnHRt56UnWJn7JBULxvA6lgnQ+6?=
 =?us-ascii?Q?fHjazTC172sAL7sCjR/3SFEb9EgsZJ5SQnZYnFxx0xedl/y+P5hYBxy44uRp?=
 =?us-ascii?Q?qawHK7l/UNlt7ODG75CfmzdhMMUaBqisL3tiD1KU6TubLGApwkHozWzZFyv1?=
 =?us-ascii?Q?rSbGR9xjxi4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ho6P0A6t3dudpxjAvsbTyyvAFIRyEQChXtLDoDoihQvsurdyZWUtlEuTNK8G?=
 =?us-ascii?Q?vOyAsEJUiTGsNWbRug4RUQL5KyW2WnXRXqWlcbidD1q7QBVb7DFbBEa1CUrJ?=
 =?us-ascii?Q?JA8/IfB05HDhSar2OGo2CmpSvNbCM4ctIM84jbs7P7Dh3aGJ4IEgi0AiSHxq?=
 =?us-ascii?Q?DXWLGY+9RAlLaNn+D3GgICXssqE8wB0asMnIl2aAqS+EIufGBsOkGTy4g9ch?=
 =?us-ascii?Q?5QHKDBOAzEdk+UOHqC7y+aK1MDvxXzxHU1OmUqpmcXUtODXiQw1xXNVViFan?=
 =?us-ascii?Q?qp9QYpd91aGOFuPatYkdqUTLpFva/LW4wih3TJow6Mo9NsZKCJn2lqkkYYOR?=
 =?us-ascii?Q?QmKQbz04/JhYw7Yk0AfoKmrQJxhXcxOfnK9LRpRN1r5eQVRkBHIkn7/Kw/MA?=
 =?us-ascii?Q?ZJHyQE7dTCHgR0ZHfDP2HKUQC//G4KEbLFeaDIEpXasUQez30BpAWCja4T8P?=
 =?us-ascii?Q?fdmLmktJMhKIJeO4pXwul/0V2HuxYwv9HHaO5ahOB+fbir1vXKv5ABt/L+GP?=
 =?us-ascii?Q?RQyj7J+7argOb/GKfENooK/kOCHCRLOridhdEEgIki5r50HMAoQkvimEmdTA?=
 =?us-ascii?Q?7eGi3gwDFU3V7DMrUGxtu0TlHcWtaTjfp/dDOCQi7JDO9vhhb+CcYsaJcsln?=
 =?us-ascii?Q?J7cgYcnMHUgDtE8V6n6BUgVcldq7Nu8EjA93494Vsl/N2tk7eE9VtnTnKB4e?=
 =?us-ascii?Q?Ar7EOuUmJfnUHfq8UDqBeMswgSMjVoDcYf+ww20Z6PU9QXym1HdTKQF3j97L?=
 =?us-ascii?Q?uMIWdNAdWZCRA/7zIN5+E08IXAEHAMFX9rG12dUbM9sG9NcFwNJHdL66DvW4?=
 =?us-ascii?Q?mtfsQnLloDXErK96tRaaL/UoSbd8sdy0YpnCILQeqLBbWdUxPfSVJb4yUyNe?=
 =?us-ascii?Q?Lbr4RoQxeZsSpn5JwP05qFmWWaaNbJNAof2lUqmlapww+RguZ/oD/56NKIRG?=
 =?us-ascii?Q?P34WG4R+RpbhB1/A5n7G2cQa1FRwKENbmRL5wD4SaWMvDM3z81nMaaaq7jCj?=
 =?us-ascii?Q?nvic6FvcHl2VA/7iK8krBea80xHmWDLTJ2dGA829pOOAcdDIhNt05tgxZGg/?=
 =?us-ascii?Q?OmHXml+UWL8Kbl+StEMXYfm2Sz2cN6IhdOq9HORHlAG71WJrc3lOY23RSQut?=
 =?us-ascii?Q?KgdhZIFSCnkxUgCcujQN/h+CLXXw9LfUVHcxX9sXZLGu0GqJ7pBVQHeIQF+E?=
 =?us-ascii?Q?4w8ahXAD9Q0Sq/Qht/HKKB7e8yli5x+HyDanc9z5dR47I3Np05WiNpnBkdIF?=
 =?us-ascii?Q?1i27/Scgj+DDCqllVzo/GFFGjZNJlUMcpoBXC9Gj5pKywStsdqIKGvUfCyAC?=
 =?us-ascii?Q?CEDw1O6oxjfTSOJBp8o0cEXDhn12Ukhf4yympz1gZxNe53xLUSyTG0m50ESC?=
 =?us-ascii?Q?4oiFrNjUBgylGKIGDDouZHVKauMw6UxLP+xuYWyVqlS5ZcpArjGkwknF2MzC?=
 =?us-ascii?Q?8HqU3sHIfdm2HPYOrm64ma0M68bMLCvj2ugleB6LvYovk9GxvHUwy0ODclfU?=
 =?us-ascii?Q?+udj8zIgqj40FUyIU1CdMo27mCXHoWAyHYk8XroMlJ33Y/A0D89yhVpb1tQr?=
 =?us-ascii?Q?C8o4yb8kOKqSXVr4Nni/S9iDjR7Gx1b0KfeZWCgM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee6786be-d227-4087-9430-08ddacdbb5d6
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 13:43:00.7923
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1WKVykR11RyRD+RFqIwdTfm9uqRQyug1Dy0NqcwJho3jeQsdcG5RehqbD0g+5RgX0+Lju1zkdOjtt7DEVxu/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4550
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> On Wed, Jun 11, 2025, Fuad Tabba wrote:
> > This patch enables support for shared memory in guest_memfd, including
> 
> Please don't lead with with "This patch", simply state what changes are being
> made as a command.
> 
> > mapping that memory from host userspace.
> 
> > This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
> > and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
> > flag at creation time.
> 
> Why?  I can see that from the patch.
> 
> This changelog is way, way, waaay too light on details.  Sorry for jumping in at
> the 11th hour, but we've spent what, 2 years working on this? 
> 
> > Reviewed-by: Gavin Shan <gshan@redhat.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index d00b85cb168c..cb19150fd595 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1570,6 +1570,7 @@ struct kvm_memory_attributes {
> >  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >  
> >  #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> > +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED	(1ULL << 0)
> 
> I find the SUPPORT_SHARED terminology to be super confusing.  I had to dig quite
> deep to undesrtand that "support shared" actually mean "userspace explicitly
> enable sharing on _this_ guest_memfd instance".  E.g. I was surprised to see
> 
> IMO, GUEST_MEMFD_FLAG_SHAREABLE would be more appropriate.  But even that is
> weird to me.  For non-CoCo VMs, there is no concept of shared vs. private.  What's
> novel and notable is that the memory is _mappable_.  Yeah, yeah, pKVM's use case
> is to share memory, but that's a _use case_, not the property of guest_memfd that
> is being controlled by userspace.
> 
> And kvm_gmem_memslot_supports_shared() is even worse.  It's simply that the
> memslot is bound to a mappable guest_memfd instance, it's that the guest_memfd
> instance is the _only_ entry point to the memslot.
> 
> So my vote would be "GUEST_MEMFD_FLAG_MAPPABLE", and then something like

If we are going to change this; FLAG_MAPPABLE is not clear to me either.
The guest can map private memory, right?  I see your point about shared
being overloaded with file shared but it would not be the first time a
term is overloaded.  kvm_slot_has_gmem() does makes a lot of sense.

If it is going to change; how about GUEST_MEMFD_FLAG_USER_MAPPABLE?

Ira

> KVM_MEMSLOT_GUEST_MEMFD_ONLY.  That will make code like this:
> 
> 	if (kvm_slot_has_gmem(slot) &&
> 	    (kvm_gmem_memslot_supports_shared(slot) ||
> 	     kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> 		return kvm_gmem_max_mapping_level(slot, gfn, max_level);
> 	}
> 
> much more intutive:
> 
> 	if (kvm_is_memslot_gmem_only(slot) ||
> 	    kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE))
> 		return kvm_gmem_max_mapping_level(slot, gfn, max_level);
> 
> And then have kvm_gmem_mapping_order() do:
> 
> 	WARN_ON_ONCE(!kvm_slot_has_gmem(slot));
> 	return 0;
> 
> >  struct kvm_create_guest_memfd {
> >  	__u64 size;
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 559c93ad90be..e90884f74404 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -128,3 +128,7 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_GMEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_GMEM
> > +       bool
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6db515833f61..06616b6b493b 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,77 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >  	return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >  
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +	const u64 flags = (u64)inode->i_private;
> > +
> > +	if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> > +		return false;
> > +
> > +	return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> 
> And to my point about "shared", this is also very confusing, because there are
> zero checks in here about shared vs. private.
> 
> > +{
> > +	struct inode *inode = file_inode(vmf->vma->vm_file);
> > +	struct folio *folio;
> > +	vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> > +		return VM_FAULT_SIGBUS;
> > +
> > +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +	if (IS_ERR(folio)) {
> > +		int err = PTR_ERR(folio);
> > +
> > +		if (err == -EAGAIN)
> > +			return VM_FAULT_RETRY;
> > +
> > +		return vmf_error(err);
> > +	}
> > +
> > +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +		ret = VM_FAULT_SIGBUS;
> > +		goto out_folio;
> > +	}
> > +
> > +	if (!folio_test_uptodate(folio)) {
> > +		clear_highpage(folio_page(folio, 0));
> > +		kvm_gmem_mark_prepared(folio);
> > +	}
> > +
> > +	vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +	if (ret != VM_FAULT_LOCKED) {
> > +		folio_unlock(folio);
> > +		folio_put(folio);
> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> > +	.fault = kvm_gmem_fault_shared,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +	if (!kvm_gmem_supports_shared(file_inode(file)))
> > +		return -ENODEV;
> > +
> > +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> > +	    (VM_SHARED | VM_MAYSHARE)) {
> 
> And the SHARED terminology gets really confusing here, due to colliding with the
> existing notion of SHARED file mappings.
> 
> > +		return -EINVAL;
> > +	}
> > +
> > +	vma->vm_ops = &kvm_gmem_vm_ops;
> > +
> > +	return 0;
> > +}
> > +
> >  static struct file_operations kvm_gmem_fops = {
> > +	.mmap		= kvm_gmem_mmap,
> >  	.open		= generic_file_open,
> >  	.release	= kvm_gmem_release,
> >  	.fallocate	= kvm_gmem_fallocate,
> > @@ -463,6 +533,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >  	u64 flags = args->flags;
> >  	u64 valid_flags = 0;
> >  
> > +	if (kvm_arch_supports_gmem_shared_mem(kvm))
> > +		valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +
> >  	if (flags & ~valid_flags)
> >  		return -EINVAL;
> >  
> > -- 
> > 2.50.0.rc0.642.g800a2b2222-goog
> > 



