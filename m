Return-Path: <kvm+bounces-45143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF13FAA62A1
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:10:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72211983DA5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 18:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5826A21FF2F;
	Thu,  1 May 2025 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q8aRiiBY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF0221C19C;
	Thu,  1 May 2025 18:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746123043; cv=fail; b=ZYo6oQ8M/GB3Z2MuGM4HtdZw4J37gE5jwF584r5oADQ1Ipw34QWd7ecs1vsvre/71y9OTszzugL8bXyENVE2RbtVDkJYi2MwrPc8y04gyeKVqnKs3CMWOvKR0ToqThfnomUTi6JW0OhkZjhfSTLFmKyWIKHXf7I57un+OmWbucE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746123043; c=relaxed/simple;
	bh=T0GTs8rLAcDog3ezD8ngEUTR6Q0P8XPOF4fai4PL4Gg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r/I0CmtTGxQ9hSJkcPq/CJpV2uQ77W/XMybWV19O7zlcZENzwDVvKdjZvAOthjAWMDC+KcLUT9omRUOP4qMxKlsOCYEt2JB1uZB15Mjrfhk68jSh51OHSYAb0Ll1Ukavm5FHoqyObXHCbGdZYO1Dmsxv1CDC3+FHnI6wEHe4fbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q8aRiiBY; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746123042; x=1777659042;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=T0GTs8rLAcDog3ezD8ngEUTR6Q0P8XPOF4fai4PL4Gg=;
  b=Q8aRiiBYAkJ4gOY2kXSMs9k4EPBxawzXcV5dYdnzNjwZYm1C5pgzYbIz
   N+aEx0qLUmZJ1YojkTa+7FO91l/MyWwZyzXHQ/tdde6bFbbT4+Y24pKgx
   2hiNKUYXRSU8nXsDDyR3R3rWmEbJMOmKmXxgqqZZZhok++bUxIAUtLy6z
   hOM5pEE44ZwHORhjNi+FBh1P+qs+7C4V/wDQLC41ARdBWo3yNpN8+0tJU
   XHLBNLcmIYkzz3OfMi8sEJNNE1Q4VRPEme//jDpIRG3NQdwu+pL9A9DSN
   dAS7eEA+T5gjYxnYivK6G9EHEwYycfneagp8di7MmOaewpqKnlC/877xn
   g==;
X-CSE-ConnectionGUID: iPrUOrebS8aSezr9FvY/wA==
X-CSE-MsgGUID: p3tQY88wRL2qF4RAh+mdEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11420"; a="35422951"
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="35422951"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 11:10:18 -0700
X-CSE-ConnectionGUID: GCwd/F2WRNuHVHHkEuC44g==
X-CSE-MsgGUID: 01/BKk+mT/uPSlfHTyk2ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,254,1739865600"; 
   d="scan'208";a="165370775"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2025 11:10:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 1 May 2025 11:10:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 1 May 2025 11:10:15 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 1 May 2025 11:10:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UQUdG/ydqtwW5OicpFlbtz6xuH5Sg2hhiVkOoM85Y7So/2WIjSTWHlv5NIU33HeqHp/jTL9KYm8UqG2z3mRItVDBOE+/Nx9eJWKzkF/1yUsY+10PDnwKmKHGJDynXI7SGWOjMbDYmGFQYDazgyfm7oxCE3RiJGIbv5MHi1xC+HYCAV4NW9KjaBb5lBX4F0N5Ks/tdClEQaEFGjWbqpfZYuft27oIV1rbv67cWEkXZuBUzb77CX19C6ycxZddAVWu6ZoNlBd2tV069QlVN233leZnMfSYxL7oDIdsNS7/qPQHzasG6fosDo9bg4By1pWVMmbEEnxkynRhw9lorcD1VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T0GTs8rLAcDog3ezD8ngEUTR6Q0P8XPOF4fai4PL4Gg=;
 b=ylzGiGV/JN+lkvDRSXJrjmP+KaAGLB5Lck1Af53XaeHULiBzK3S+VRbQPSbzXP2yZmIdIM/phTsjlQyMEC8A9Ejls14uOmcbeXhLkxYlPsMbPYy6Jd3E+mTnntQQxgS5zTo0JdMe6t/poVYhKA/0FpOjdSn0Jrb0YTnSSfnL+bVj9KQeGAJXHsQ10vhUbMTUyVT5S+63GfYmVioGyxYD/E9L2VWvNA5HAAsqJkbtne0NafGQuHSMAXXdExlCcQldmqEF7X79lazC2MZkcJF/Q08OweDzweAPy/YgDKS1S13XoJLdBTtl7vk0D+7BfJsZS95+EppYxTqekruJSByNMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SN7PR11MB6876.namprd11.prod.outlook.com (2603:10b6:806:2a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Thu, 1 May
 2025 18:09:58 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8699.012; Thu, 1 May 2025
 18:09:58 +0000
Date: Thu, 1 May 2025 13:10:30 -0500
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
Subject: Re: [PATCH v8 02/13] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
Message-ID: <6813b9167661b_2614f12944e@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-3-tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250430165655.605595-3-tabba@google.com>
X-ClientProxiedBy: MW4PR04CA0217.namprd04.prod.outlook.com
 (2603:10b6:303:87::12) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SN7PR11MB6876:EE_
X-MS-Office365-Filtering-Correlation-Id: 28133826-483f-404a-4a17-08dd88db61de
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SCgQExShdIg6HCNf1r1HgqRv0ugwe1IIZEPqe8DQFcEOtDOb6AuH2SyjIE/j?=
 =?us-ascii?Q?PS+IeT3A2hhHE/KY+KT7KuIelaYytdqFuCvgvhI09fQhsqlqwK67bPLUxIFY?=
 =?us-ascii?Q?tWi5W+6ix8c1O6LxL+ZO2NvOvf9nvofW9Zz5jjGA8INFTl1n9LYX4epGmHYB?=
 =?us-ascii?Q?5dlBgINJec7BdrIs7Zqh6d3UyTT/YKpV6iklpRlidiRb5j0/cj5+DagEWVIH?=
 =?us-ascii?Q?PVlTW2f+iXNfYzIzCue8CBgi0I/ylA4239TeNIcW94LBEdqYY1OHUvhC1FjW?=
 =?us-ascii?Q?utVo71fctHB4LE8nSwDfXGpvt3mGTGTGUNJo3Lyg4mXxrIpuhOcFk6b2k/8t?=
 =?us-ascii?Q?9S5/hTIhYtKTiyf7ViHDT+Gl2Ad/JO3RPEX4lqLel/8QyYdBhPmlLKsTAHVo?=
 =?us-ascii?Q?kOSG8rjWdNKJXAn7oRK30PB3l+gXMCFPllOFAnBqBAGVvfMBczqvkEbeVr/r?=
 =?us-ascii?Q?z+fvjMp5qLmLVaW8UfMDnEsCF3+JrnIepojSvhlhnsAduLiM+YkYhG3cnEH6?=
 =?us-ascii?Q?M6qUmmQdwQdbgXu/TJg/w4MdhPY82UDbRmskLKWf2YGna9vlgGpiCJa5iRQx?=
 =?us-ascii?Q?PbAaUyR8A01gk5wkD1WpcS5gH0PTb2ae8dTqXrtZ/08pj2IWAgTS5ZiMkJss?=
 =?us-ascii?Q?+n2e794UTLt1bZpbJb94GdCAxj9EnihIE3H4OFSerjyJTdxhWP+Omd1Cv5FE?=
 =?us-ascii?Q?ywhhx0QSy81pPps+YU/Xz5yaB+Pzun+lYEQ/DgTWi8fJFxLywY6zsmJ022u+?=
 =?us-ascii?Q?NSAW90MipQ0iStza6LrpSLeUcbY0tHPa3yanZW0MhnrWyWKTRq88ghCCf4ZO?=
 =?us-ascii?Q?n2Lwl6+ZAegB0tTdwRBKQOqa2lmtX1gc5cwgqx+RNvkEGi/R22c6h9Jm3Xgo?=
 =?us-ascii?Q?GbnCg1p+j69bo9om9c6NTbuYAQV6WgEAchZHYa3ws+qWTDw7JyjYMbsgsSLd?=
 =?us-ascii?Q?f6v43W7+pWYSAcFjxtgT4q3hLt8A/m93S+0+jYImWncu9qMt4VB85T/Bn6F+?=
 =?us-ascii?Q?ktdpOYMMthGdsVO3l1YVQYgPC2wlnIAiFM81Eegr27Sbt5pEJ3Baekytmsbz?=
 =?us-ascii?Q?tRoyIQsrXoObvF882AasVYIoDhPL7NrcVaWm+TJYuXA9Oko0RPjPLR0Xz7La?=
 =?us-ascii?Q?v5tIhtOPk/dQY3EORpLgS9CFNGxNAme7x660+7L+Dk5oeCAVjWLQKTWeVipe?=
 =?us-ascii?Q?mpJkFVYTbiAz7nPJM6QTdzqS5j9UiHgG5itbwktpoqDzYDKOZ+Hysn48GpmL?=
 =?us-ascii?Q?xHeVrEUmuuRtK4GVGIzWbkhmfE9YK6pJBjbO2u1X4sLxM3ulW97YgTz6S+5Z?=
 =?us-ascii?Q?DFAxjrXzNfoohJ3rAIRz3qCxWOC5iTkIOQFUNEOclYEbT+QFl8q1+9RIeOjZ?=
 =?us-ascii?Q?JsX1soXBynlA79NG+lMEGaI9bh4ESnlYjgRHuLpOaRbmqa202A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2aFo2H7/QaQnMJWehe0CWf57z6AO3BfyFsl1sTTNYdE/sU5PmLuya+IXQYu1?=
 =?us-ascii?Q?/wBFiK00qkdyXi9m01LnVtIS6e1C35Zb3Df/k0HutbUr7VCkG8d419cdzLkr?=
 =?us-ascii?Q?rzcA0jwP1zM6ylWQIH0Y1f9sQpgTeB1JiUm4YrLwO2jVaDSEl9mOUS8rF3ek?=
 =?us-ascii?Q?NOt7X0lI9a+r2FQ1towkz03DiOS/LrUN87lNfZO9/DYt9a3EzI9Ow95yk68q?=
 =?us-ascii?Q?2Vm2YTG4BnN74hWiREr8vviov2S1X+XjYHsOghMmNn3VxA+TZ2KI+RHPsPBk?=
 =?us-ascii?Q?MKvWR6oUV8tUaF8wScUiNb9fEXiUUCNF2WBGbBZad2kepvUu1TSma+/rybnx?=
 =?us-ascii?Q?Bv5LzWQMHGEKeghtBBCF9Wh+xABLltax/E/WxgVa0RKfN3ND70NTkiqBGPk2?=
 =?us-ascii?Q?3UNvg7+DlErNkQHvaR4asPawMSi3cDhVfO4UaYP+SyWBHXvlzcFHVljvh/rK?=
 =?us-ascii?Q?487UVtBZpqGTZOdwMEcKS0R+3iCn3utxMAEGyaO5jg5Ug5WKeqYPT7/qLmj+?=
 =?us-ascii?Q?IL2iCrmLo7ohq5HMGqKPGh+4ffKRjg3TpRLx0+XiYZycfFGdY/uebhWThzxE?=
 =?us-ascii?Q?BcvqzsXj1UmEkT602zwXUysWH/agGZLOlAu1SPwzXzjLaUvuwhcN6k7JaK95?=
 =?us-ascii?Q?pZaiMO3cgKKO7sWzpXkExmhfbUdlgMZPTxWF4zVFHxjzjEqR88Y4vyzDojQS?=
 =?us-ascii?Q?Fz2QpoQ77Pu0kKv7xsiwiTn5uIkCctMfQY7jCN7WPLXzjtBj+m6rd3Gf0h0S?=
 =?us-ascii?Q?QXA8fqVuc3NuFN9yvIqO4jVoWSgF1V+RENDuQ8uyJpOG5Cn2oBRgVeVPb/U3?=
 =?us-ascii?Q?TMmcW61i2teEdjH7nSgHWgg8+E8zvTOJv2JRiVBbZ5Lzj+0iWLFppKZUq/zp?=
 =?us-ascii?Q?aNiESXMocaWkX/vVX8/Z9FmjjfQPL4Hbcjvk9Ss+tOqBd1ajzoVnIrg/Fvbc?=
 =?us-ascii?Q?oHF908Htc2YBB9WNBrLFLl/iJLQYY5F49nLOm5eitRhg4lOoYQarYsHsSbKm?=
 =?us-ascii?Q?Qb35aG9hAYD2Ig/Pl3JTY037lMlZDeywJ1PLPNfzle/bzh3g/4Zh4Yu5/yAW?=
 =?us-ascii?Q?ZMWeijL/iv1EjVdhmMLNkKqylYY89kwruKTih07KnZ21g68H4iMb0lfnm8Sm?=
 =?us-ascii?Q?pLLUW5rMou5W7taPnezkxqjGPzRdgZi1spDJURH8qC5+B8mNS+BE6PGw329R?=
 =?us-ascii?Q?x9O7MmOaIFnqXeJKc+ZK0qP4iVjD6+8ZI5bYKimnlXfU1DiDmOfP3WsZ7aI0?=
 =?us-ascii?Q?4xWsJIehC9Jk10uWWYI4iJjvWOdPgBCw621Lhz+MdVQ+Xwvwcd+B82KuCtnM?=
 =?us-ascii?Q?92uLNNRuCwF+WKl2XaHSJjQj73zufg8MMoBJ++cPNmGk4RyMftB55XjDNENM?=
 =?us-ascii?Q?FKBOYl8vz6fyKFD6SrPr7qWE99WXE1DMs0IYIg9jylCFh2oDa2TalrLx+Dw4?=
 =?us-ascii?Q?y+tOcq2MQaIWEaSaJnlmwZfwFiBderS9NEqIx8+d+mqFjTZLPyvlLDf4ltb7?=
 =?us-ascii?Q?DcZP9yt7a0qAL4bZ19exXg7fqJafuh1DLh3QKgJlqRrdKryFAWMs1EOzfsRX?=
 =?us-ascii?Q?J1VlpnGda/DV75sGJv5KmCjLR76aSvMsTlUne1ln?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 28133826-483f-404a-4a17-08dd88db61de
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2025 18:09:57.9317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 49FDmsX6VCyQt/rPJPGDqVaRDLjUegxGvr5RJp1u3KTGrhSfWZ7L1Lt4lx+ILIV/YLuY1H+Pf9efHWJrcv7Pkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6876
X-OriginatorOrg: intel.com

Fuad Tabba wrote:
> The option KVM_GENERIC_PRIVATE_MEM enables populating a GPA range with
> guest data. Rename it to KVM_GENERIC_GMEM_POPULATE to make its purpose
> clearer.

I'm curious what generic means in this name?

FWICT if we are going to change the name, KVM_GMEM_POPULATE is a better
name.

Ira

