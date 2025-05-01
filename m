Return-Path: <kvm+bounces-45140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 917D1AA626E
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 19:38:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B2C93B1846
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0573F218AB9;
	Thu,  1 May 2025 17:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ltcjcZh4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D082153FB;
	Thu,  1 May 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746121105; cv=fail; b=GUjrO+Yi0YYYsTAi0hzM70RBdAUXRHWg1VmLBMVGHXHOxWzAff9i/801z20U24QUsLQWBF3cA3+mW3rrOz4TyWkN+BfapRVIk54fJTs0d6M5rcu/h+gPq31QAZqse5gsdAa2sbouX8FAy135uPREIg20cJQoihKYyoq2ZnjUkhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746121105; c=relaxed/simple;
	bh=CVQGC3D0BWpZLvj7JJqnWZD4sQyNpQQwgNpFC1HsXXE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bXexdfFW7I/fBZdmrGbD38lAuMxK58Qg7+dOAHxKudJ6XgXvZOR7w3eTCMGq881/KPtGyKqZB8mfvi8265cZPDCP+R1ygGugvTKmaSHOu8Emoj9v6896cd1gngqITDmZSotc3h3SNDe9u2UxydTqP4qgvi+KcL+Neop/xcgTrUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ltcjcZh4; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746121104; x=1777657104;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=CVQGC3D0BWpZLvj7JJqnWZD4sQyNpQQwgNpFC1HsXXE=;
  b=ltcjcZh4doJECfrHgjPeD3lXHfud+LF4t9mQaGFcGef6qzR7MaL6917D
   w+rowKB0hb34qp1YvWRaqilwjizGOGl+SkQIRA+QBvt9KaR8UCYAipRg1
   qFAcYT87m1bXi5CS4yUQsJe4YCzDNtHkPgPkEGYDBqR+LwWFX4PLJDMjH
   yHFsISWunkChunv5B9tv47o5oAdyWQ1hf7pwThDRlODL505w6pFzqZPWT
   v031gGh+D8zaOT+byoUP8i6dG7cvrc5rFyc//6RDTVltQPDkJkd0aARN3
   dgSZSjJjzIGHKwgsndzecNy4vFSHSMuqsvA7SXdBhJGy/cCSMZitWgiH7
   w==;
X-CSE-ConnectionGUID: uTKAOvCJQ6qPiF5hpP3J2A==
X-CSE-MsgGUID: TssMEjHpRq+3jFXasPEdNg==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="70303039"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="70303039"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 10:38:23 -0700
X-CSE-ConnectionGUID: 1UBfPKErTpWijIFIqjXsqw==
X-CSE-MsgGUID: kXBf3sRBS3m1egRhRs4CQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="134356196"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 10:38:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 10:38:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 10:38:22 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 10:38:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wM1vxVEGFX+cPM/QpvXNaxJVjk4fnMgU/mcBCIqroIEHKNyv7mR2aYNTAvzVQ6LhW4FT451iMXO75EgIqQR4oEVEmx1r+jz0GUHyp9iquDFp+woPbeBPbeHr+M/C9oqnUCHxzqphJPYo09qSSrsaQZFaaI6B1ZgnrbQSj3k4H3Bj/LKzCEU9UwhXbOsYTqZjVxvaN+zH5EhcRkPmiOHJr2cmJwT8IZutSyf87R1SqZE6WzgEzogNxKlZjdq9rVMFlEsPPvdVSPBf5OB8sfL7oSdDkZtEBMAtJTSwsjIVz8GImI2BzyGgz20WVljl36Pz3q9nWdctzvzApQOvSowd+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oxuy90SQI9Fl4qcmcxFXVhD9at47aXBBjQZm3h9I4QM=;
 b=LJdZ1PN0MN1hORez0GV9eV6t3AjlRUZzBIAJcwqvQBrsxFs8vqU4UjNOHd/hCCm0Fe54ajG67k9PkOOGrBtLMaipDYBDQBgYWN+jMt97goqzAmVibuYRxl77DmL5inG60zyDsAEluNRb8WP58THxfeX5fpVWBA69pzaHExPel8JyceDha/SLBgI7t+QrirEVTwkZuxY8+MXn3Rc5do6wyZBMtoFxMLBb+jVPNd/BaD3we6nMaBn+gur/g+yi1IpdVLQCoB2pF6nllM+ksuDtN/fjal3Sxtt6vfhQDlOi+hTd5UaCI0IzzZiDiZaSt+dyj5S6oZJvbdtPDplO3wD4jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Thu, 1 May
 2025 17:37:45 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 17:37:45 +0000
Date: Thu, 1 May 2025 12:38:14 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
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
	<pankaj.gupta@amd.com>, <tabba@google.com>
Subject: Re: [PATCH v8 01/13] KVM: Rename CONFIG_KVM_PRIVATE_MEM to
 CONFIG_KVM_GMEM
Message-ID: <6813b1867ab94_2614f12947f@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-2-tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250430165655.605595-2-tabba@google.com>
X-ClientProxiedBy: MW4PR04CA0127.namprd04.prod.outlook.com
 (2603:10b6:303:84::12) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|MN0PR11MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: b5a53a34-190c-4b4f-da0a-08dd88d6e1e1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1mfmD2sTKlBjtCHeLsdKjjwQt3b1YDtsQ0L8cEJYxS5BL3COPH0wAzpS+PBD?=
 =?us-ascii?Q?nqR/CadKpPTT7oVNZKIaWNBOEVavkdj6G9+7xDcO5xFD/hbLnzU0Wc8Oluc/?=
 =?us-ascii?Q?mjXil60OPCxMgJASYSeOLPKWSAhHH1chjnIp8bIikPMgKFBerXUbN8G9d5GM?=
 =?us-ascii?Q?qMeKg0c3+EDeORxbi8urQe3+isL8Pna2c0XMkJQFmFQ/DGrlGMTBp37bEYYR?=
 =?us-ascii?Q?qCuEdeP10t6Emt6Bo8o4jUnAvjpY9rwBVoCWHr3fTYEWGuMuvXcZIV+k5KGh?=
 =?us-ascii?Q?f/OvRXj45CorngFvZWHmn/E/GAAWya7HLbrC+SXcFUCogUFSv5imZjtazDNg?=
 =?us-ascii?Q?JR4rKs9yXLsj+ukhnyjJz6ZSthhF825VocVbsBXf9XgXXEmLTp3ioNDW7whl?=
 =?us-ascii?Q?yA9QWcBVgN2jUIH0WEFkFOWfNjricB7JBxDiX6rjrp1R9yH2p/o9wMqrrz5H?=
 =?us-ascii?Q?j9DcTScbDkUSU5Uc5kevVPPEdkXfU5U0A8yp8q/CbHS+fje/Kq6zdJ+6oEe2?=
 =?us-ascii?Q?xrpfyQmPivcLsf5UmUI6TRiz/5sFWVRbAkFv/3ni1jYXMZBnwKEcAqZCQ+Gg?=
 =?us-ascii?Q?AAs0uYz1pjldK2R18wx1mTxsFf0aCUXi2YRPkzXcKzsYkROVFnsDXBZ7KmS6?=
 =?us-ascii?Q?gqmGoLjRUWuDhM2IqXHZbux8rivhFuic+reXw7JsCkPmpaj63hRUzPuaxo8l?=
 =?us-ascii?Q?QxRBVGiNW93Q+Xc5oWu/XWlyhUz8R/tgCg+HUi26Crn+DMIsUvAtKg7WbijU?=
 =?us-ascii?Q?1LZLj9K07DVcAQCwitmapbv4ip/Cm7vlBJkLw1GRRjXA7iccdj+llkLDiSvU?=
 =?us-ascii?Q?aa365ajfL1AHVivbsIDa67ZIrJdQkT0K/yeZQE6KSsDnU6gOcnGabB6RwS42?=
 =?us-ascii?Q?y7CFNRGfxQEfJXjvLFnhiBG0X1LOSiDzRjYh5B/82hVz61YqWGPl8dC6Pi/o?=
 =?us-ascii?Q?7n0LEy1zLCevVbNrk+ffUIOv42bHvZ/IsCheHrRpszFC6vmLsCmRqaRjPq/h?=
 =?us-ascii?Q?DDVyx6REk9eSszj5IMeWXQ+32pkXRV6oA6EDpM7HwgFq1j9V5yBoB8jSQzvn?=
 =?us-ascii?Q?KsQ65KCb0OVlTOdqvgSEHk2KkoO/JAGD0GNe1OXwhrPUvwK3DrxvF4mfSqLV?=
 =?us-ascii?Q?q9NnHeOd4c/dYM3JcMMHu/3bDKd2tkjwtxkwPBR6Beoj3+jGb/UgSxE/HSyL?=
 =?us-ascii?Q?Fe3BZcC3LnDMQcozdmBiDHXORZESmQTawz9BSyB9GJIjcSEhW4hyl1BScaKu?=
 =?us-ascii?Q?bqtp6j4Sn6tDelKfWILXsFnT03cyMAPORxMt0QOxuEJqEb6RR4C3P/k1Hzys?=
 =?us-ascii?Q?zLFRIqIq3UnQcrerythxA7AS20CE1E10lfrNJfJxr7a/HPDsDUKHXH+XQIhE?=
 =?us-ascii?Q?Qroe8mJwXqaXIitfaN2ULnntkJP0VZ2ZqMxBcwyaw8set0pjNA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D2vRi5Q6YBKhPlN6zZf6yte7e7I70RDzVCSdj1+vGnnNWCT2RA53PAlbA20I?=
 =?us-ascii?Q?SSszqewySlsZqBEvHTZdg2NCG6xYD/5btx28t0V6rzbBu5k8O1FprmLdBaYe?=
 =?us-ascii?Q?ZN+jVsAAjw6V0kPm12534gLVSmTzZ0I5orRF/1zWGhkUDsx0SXWKu/GZe1vZ?=
 =?us-ascii?Q?uR21XMPEe6HW/1+J9W4k11mLMjO0P2XPKAq1Jjdbnb5xMaGjTzCQvP0Y10js?=
 =?us-ascii?Q?eAWB/fh2fUEUO1W0V382YAHRQPE6eh2ZeyOOSt7Ov+Sq10mMViXeFICSAYMG?=
 =?us-ascii?Q?cyPYW192yX6kh/bbV/e0g0NQ7EWm7EDAFESXFm6YvWrozXKdELdSs0GnEmb1?=
 =?us-ascii?Q?spo2R97DKo17kir7tcY9aFNspoOv0ypC5t5JhdxpyI9q16DKy2UAEl2wtR0D?=
 =?us-ascii?Q?35G0WKon7OkJIjk3hbqNryd1tXHKV5iDS8oXM9gPF21aRqgQALcXEHKozN+7?=
 =?us-ascii?Q?MAUFFohigCR3vMFoTtTBAE8O+bCWoL1ZslHNU8WUDhZVdqN5+T7adLU9qRVk?=
 =?us-ascii?Q?SGfBTiHHqPUdG7StBlMZI1Zddfdk7DtiguP29PGV9uORjAs2QcYULWXdvXJz?=
 =?us-ascii?Q?GYWxvsy3HfWVxxVD8JSTnERL9FMJsOWJHhrX51qSVj5HO8UZyP9LFN0Q5kxw?=
 =?us-ascii?Q?SV0TZK+cCQGw1zeDHooCqeNEkVTgjCtmp81GKTqWuALuM4D2+GcfCDpEfOcB?=
 =?us-ascii?Q?0KxECegx8ufPiVS0yGmd+jlTtO7V0djKhrDGHoPS9LIa7N67L0JF8xXdGZXm?=
 =?us-ascii?Q?0oyaIhA/beHSkLpApDs6Ehb8dAL5ybpqvSFuLUuW7xiPXzWyzAvNe1XxwmJo?=
 =?us-ascii?Q?rtE3YlfCseOWqRFxjanSJ1PBWFKE+QWXutg/1i2pQVrpS5Pu5q/+Qwf4Xyb0?=
 =?us-ascii?Q?mkHMAOzThJcf1vaCYRU0DhoAt07KSU4j9a5bmQnpxd0dvjbucq2ROn0Bkzsj?=
 =?us-ascii?Q?BxfsBX+BxvP9JVk3eHW8cN0bpJGk/n/dUr4Nc3qa7WEomGUyrTeU6WLoTvyE?=
 =?us-ascii?Q?Nio5/93CR+rLaHhuc+kLFg4/s4PUyFlrvQONPNlpDiAt2M58Pyz1cCtM/G3s?=
 =?us-ascii?Q?3qT3myc7vWFi3dAPHGhBF37acotIkpuf1jtrWfcRc0CHtjjsVQvZSDPDiJvF?=
 =?us-ascii?Q?8iFuQKkg4UBURwT883VuUERs+R3KtDVse/eiF/Q8SNX+O7VDorWG1U7oey4X?=
 =?us-ascii?Q?fKDVOwpK8I7mDsDmR+3JBQVvNx4VN/xlMoxbjreUKm/xi+/L6D+1pOuq2yEh?=
 =?us-ascii?Q?qpuJrWESVS7xif9tq48g5IU/ZWSz409xPBbNp3eebpXeWAnXaDzOAE8eqV4u?=
 =?us-ascii?Q?z4uU3cVr/UjIomHAmTHjnzq+WyZ9PqFygv9yga/M8X9GOandfQmAex2TapV3?=
 =?us-ascii?Q?Q5H4J686hcN7I4n9tyRsUhcFem9tnFDWfOd0D4WEsP0FuFifetrqzxA2xb0U?=
 =?us-ascii?Q?F7Wb8N2bI4Qc9XAYTMPvkDHevOPSJNcx2JRtq8EAY25Pn4i16Zd4E5BM5zaw?=
 =?us-ascii?Q?pygaWl8TDN9kwXh0eahETq0qLAu6TJkgLyAkRAA7ThiPfoV+GshDiOcNVxkf?=
 =?us-ascii?Q?3vB0RH2Tpbg3eFMiCZyhMnquFVYO5Aa0nbAQ05/x?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a53a34-190c-4b4f-da0a-08dd88d6e1e1
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 17:37:45.2461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0GNQbrMIE0zxQ3Z7zKEiNisngpK9VEyFJtLyeNOGUr19I3zt8bSkmEHl4/p/pDVrX9A/JbRuazirDIzmwRhmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6011
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> The option KVM_PRIVATE_MEM enables guest_memfd in general. Subsequent
> patches add shared memory support to guest_memfd. Therefore, rename it
> to KVM_GMEM to make its purpose clearer.
> 
> Co-developed-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

